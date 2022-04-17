--[[

	Beduino
	=======

	Copyright (C) 2022 Joachim Stolberg

	AGPL v3
	See LICENSE.txt for more information

	I/O Module

]]--

-- for lazy programmers
local M = minetest.get_meta
local H = minetest.hash_node_position
local P2S = function(pos) if pos then return minetest.pos_to_string(pos) end end
local S2P = function(s) return minetest.string_to_pos(s) end
local S2T = function(s) return minetest.deserialize(s) or {} end
local T2S = function(t) return minetest.serialize(t) or 'return {}' end
local S   = function(s) return tostring(s or "-") end

local lib = beduino.lib
local io  = beduino.io

local DESCRIPTION = "Beduino I/O Module"

local Num2addr = {}

local function get_node_name(pos, lbl, port)
	if lbl and lbl ~= "" and lbl ~= "-" then
		return lbl
	end
	if port then
		local data = lib.get_node_data(pos, port)
		if data then
			return data.name
		end
	end
	return "-"
end

local function on_input(pos, address)
	local nvm = lib.get_nvm(pos)
	local baseaddr = M(pos):get_int("baseaddr")
	local port = address - baseaddr
	return lib.get_input(nvm, port)
end

local function on_output(pos, address, value)
	local nvm = lib.get_nvm(pos)
	local baseaddr = M(pos):get_int("baseaddr")
	local port = address - baseaddr
	lib.set_output(nvm, port, value)
end

local function formspec_place(pos)
	return "size[4,2]"..
		"field[0.2,0.8;3.8,1;addr;I/O port: (1 - 65535);]"..
		"button_exit[1.0,1.2;2,1;exit;Save]"
end

local function formspec_help()
	return "size[13,10]"..
		"real_coordinates[true]"..
		"tabheader[0,0;tab;I/O,config,help;3;;true]"..
		"style_type[table;font=mono]"..
		"table[0.35,0.25;12.3,9;help;"..lib.get_description()..";1]"
end


local function formspec_use(pos)
	local numbers = S2T(M(pos):get_string("numbers"))
	local labels  = S2T(M(pos):get_string("labels"))
	local baseaddr = M(pos):get_int("baseaddr")
	local running = M(pos):get_int("running") == 1
	local nvm = lib.get_nvm(pos)
	local lines = {}
	local buttons
	local tab = nvm.in_use and 1 or 2
	if nvm.in_use then
		buttons = "button[8.7,8.6;3.5,1.0;update;Update]"
	else
		buttons = "button[8.7,8.6;3.5,1.0;save;Save]"
	end
	
	for i = 0,7 do
		local y = i * 0.8 + 1
		lines[#lines+1] = "label[0.5,"..y..";#"..S(i + baseaddr).."]"
		lines[#lines+1] = "label[5.0,"..y..";"..S(lib.get_output(nvm, i)).."]"
		lines[#lines+1] = "label[6.7,"..y..";"..S(lib.get_input(nvm, i)).."]"
		if nvm.in_use then
			lines[#lines+1] = "label[2.0,"..y..";"..S(numbers[i]).."]"
			lines[#lines+1] = "label[8.4,"..y..";"..get_node_name(pos, labels[i], i).."]"
		else
			lines[#lines+1] = "field[2.0,"..(y-0.3)..";2.5,0.7;num"..S(i)..";;"..S(numbers[i]).."]"
			lines[#lines+1] = "field[8.4,"..(y-0.3)..";3.5,0.7;lbl"..S(i)..";;"..S(labels[i]).."]"
		end
	end
	
	return "size[13,10]"..
		"real_coordinates[true]"..
		"tabheader[0,0;tab;I/O,config,help;" .. tab .. ";;true]"..
		"container[0.3,1]"..
		"box[0.2,0.5;12,6.7;#333]"..
		"label[0.5,0;Addr]"..
		"label[2.0,0;Number]"..
		"label[5.0,0;OUT]"..
		"label[6.7,0;IN]"..
		"label[8.4,0;Description]"..
		table.concat(lines)..
		"container_end[]"..
		buttons
end

local function store_exchange_data(pos)
	local meta = M(pos)
	local numbers = S2T(meta:get_string("numbers"))
	local baseaddr = meta:get_int("baseaddr")

	for port = 0,7 do
		lib.add_node_data(pos, port, numbers[port])
	end
end

local function on_init_io(pos, cpu_pos)
	M(pos):set_int("running", 0)
	local baseaddr = M(pos):get_int("baseaddr")
	for addr = baseaddr, baseaddr + 8 do
		beduino.register_input_address(pos, cpu_pos, addr, on_input)
		beduino.register_output_address(pos, cpu_pos, addr, on_output)
	end
	store_exchange_data(pos)
	return baseaddr
end

local function on_start_io(pos, cpu_pos)
	store_exchange_data(pos)
end

local function store_settings(pos, meta, fields)
	local numbers = {}
	local labels = {}
	for i = 0,7 do
		numbers[i] = fields["num"..i]
		labels[i] = fields["lbl"..i]
	end
	meta:set_string("numbers", T2S(numbers))
	meta:set_string("labels", T2S(labels))
end

local function on_receive_fields(pos, formname, fields, player)
	if not player or minetest.is_protected(pos, player:get_player_name()) then
		return
	end
	
	local meta = M(pos)
	local nvm = lib.get_nvm(pos)
	if fields.tab == "3" then
		meta:set_string("formspec", formspec_help())
	elseif fields.tab == "2" then
		nvm.in_use = false
		meta:set_string("formspec", formspec_use(pos))
	elseif fields.tab == "1" or fields.save then
		Num2addr[H(pos)] = {}
		nvm.in_use = true
		store_settings(pos, meta, fields)
		store_exchange_data(pos)
		meta:set_string("formspec", formspec_use(pos))
	elseif fields.update then
		meta:set_string("formspec", formspec_use(pos))
	elseif fields.exit and fields.addr then
		local address = tonumber(fields.addr) or 1
		meta:set_int("baseaddr", address)
		lib.infotext(meta, DESCRIPTION)
		meta:set_string("formspec", formspec_use(pos))
	end
end

local function on_rightclick(pos, node, clicker, itemstack, pointed_thing)
	if not clicker or minetest.is_protected(pos, clicker:get_player_name()) then
		return
	end
	if M(pos):contains("baseaddr") then
		M(pos):set_string("formspec", formspec_use(pos))
	end
end

minetest.register_node("beduino:io_module", {
	description = DESCRIPTION,
	inventory_image = "beduino_iom_inventory.png",
	wield_image = "beduino_iom_inventory.png",
	tiles = {
		"beduino_controller_side.png",
		"beduino_controller_side.png",
		"beduino_controller_side.png",
		"beduino_controller_side.png",
		"beduino_controller_side.png",
		"beduino_controller_side.png^beduino_iom.png",
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-6/32, -6/32, 12/32,  6/32,  6/32, 16/32},
		},
	},

	after_place_node = function(pos, placer)
		local meta = M(pos)
		local own_num = lib.add_node(pos, "beduino:io_module")
		meta:set_string("node_number", own_num)  -- for techage
		meta:set_string("own_number", own_num)  -- for tubelib
		meta:set_string("owner", placer:get_player_name())
		lib.infotext(meta, DESCRIPTION)
		meta:set_string("formspec", formspec_place())
	end,

	on_receive_fields = on_receive_fields,
	on_init_io = on_init_io,
	on_start_io = on_start_io,
	on_receive_fields = on_receive_fields,
	on_rightclick = on_rightclick,

	paramtype = "light",
	use_texture_alpha = "clip",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = {choppy=2, cracky=2, crumbly=2},
	is_ground_content = false,
})

beduino.register_io_nodes({"beduino:io_module"})
beduino.lib.register_node({"beduino:io_module"}, {
	on_recv_message = function(pos, src, topic, payload)
		if lib.tubelib then
			pos, src, topic = pos, topic, src
		end
		local val = lib.get_num_cmnd(topic)
		if val then
			local nvm = lib.get_nvm(pos)
			local port = lib.get_node_port(pos, src)
			lib.set_input(nvm, port, val)
		else
			return "unsupported"
		end
	end,
})
