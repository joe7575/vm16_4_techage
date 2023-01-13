--[[

	Beduino
	=======

	Copyright (C) 2022 Joachim Stolberg

	AGPL v3
	See LICENSE.txt for more information

	Mod recipes

]]--

if minetest.global_exists("techage") then

	minetest.register_craft({
		output = "vm16:programmer",
		recipe = {
			{"", "techage:ta4_display", ""},
			{"dye:black", "techage:ta4_wlanchip", "basic_materials:copper_wire"},
			{"basic_materials:plastic_sheet", "techage:aluminum", "basic_materials:plastic_sheet"},
		},
	})

	minetest.register_craft({
		output = "vm16:server",
		recipe = {
			{"default:steel_ingot", "dye:black", "default:steel_ingot"},
			{"techage:ta4_ramchip", "basic_materials:gold_wire", "techage:ta4_ramchip"},
			{"techage:ta4_ramchip", "techage:ta4_wlanchip", "techage:ta4_ramchip"},
		},
	})

	minetest.register_craft({
		output = "vm16:sdcard",
		recipe = {
			{"", "basic_materials:plastic_sheet", ""},
			{"", "basic_materials:ic", ""},
			{"", "basic_materials:plastic_sheet", ""},
		},
	})

	minetest.register_craft({
		output = "beduino:controller",
		recipe = {
			{"", "dye:blue", ""},
			{"basic_materials:plastic_sheet", "basic_materials:gold_wire", "techage:aluminum"},
			{"beduino:ram2k", "techage:ta4_wlanchip", ""},
		},
	})

	minetest.register_craft({
		output = "beduino:io_module",
		recipe = {
				{"", "dye:blue", ""},
				{"basic_materials:plastic_sheet", "basic_materials:copper_wire", "techage:aluminum"},
				{"beduino:ram2k", "techage:ta4_wlanchip", "beduino:ram2k"},
		},
	})

	minetest.register_craft({
		output = "beduino:inp_module",
		recipe = {
				{"", "dye:blue", ""},
				{"techage:aluminum", "basic_materials:copper_wire", "basic_materials:plastic_sheet"},
				{"beduino:ram2k", "techage:ta4_wlanchip", "beduino:ram2k"},
		},
	})

	minetest.register_craft({
		output = "beduino:router",
		recipe = {
				{"", "dye:blue", ""},
				{"basic_materials:plastic_sheet", "default:mese_crystal", "techage:aluminum"},
				{"beduino:ram2k", "techage:ta4_wlanchip", "beduino:ram2k"},
		},
	})

	minetest.register_craft({
		output = "beduino:broker",
		recipe = {
				{"", "dye:blue", ""},
				{"basic_materials:plastic_sheet", "default:mese_crystal", "techage:aluminum"},
				{"beduino:ram4k", "techage:ta4_wlanchip", "beduino:ram4k"},
		},
	})

	minetest.register_craft({
		output = "beduino:14segment1",
		recipe = {
			{"wool:white", "dye:white", "dye:black"},
			{"techage:ta4_leds", "techage:ta4_leds", ""},
			{"basic_materials:ic", "basic_materials:ic", ""},
		},
	})

	minetest.register_craft({
		output = "beduino:14segment2",
		recipe = {
			{"beduino:14segment1", "", ""},
			{"", "", ""},
			{"", "", ""},
		},
	})

	minetest.register_craft({
		output = "beduino:14segment3",
		recipe = {
			{"beduino:14segment2", "", ""},
			{"", "", ""},
			{"", "", ""},
		},
	})

	minetest.register_craft({
		output = "beduino:14segment1",
		recipe = {
			{"beduino:14segment2", "", ""},
			{"", "", ""},
			{"", "", ""},
		},
	})

	minetest.register_craft({
		output = "beduino:14segment2",
		recipe = {
			{"beduino:14segment3", "", ""},
			{"", "", ""},
			{"", "", ""},
		},
	})

	techage.recipes.add("ta4_electronic_fab", {
		output = "beduino:eeprom2k 1",
		input = {"basic_materials:plastic_sheet 1", "techage:ta4_silicon_wafer 1", "techage:usmium_nuggets 1"}
	})

	techage.recipes.add("ta4_electronic_fab", {
		output = "beduino:ram2k 1",
		input = {"basic_materials:plastic_sheet 1", "techage:ta4_silicon_wafer 1"}
	})

	techage.recipes.add("ta4_electronic_fab", {
		output = "beduino:ram4k 1",
		input = {"basic_materials:plastic_sheet 1", "techage:ta4_silicon_wafer 2"}
	})

	techage.recipes.add("ta4_electronic_fab", {
		output = "beduino:ram4k 1",
		input = {"basic_materials:plastic_sheet 1", "techage:ta4_silicon_wafer 2"}
	})

elseif minetest.global_exists("tubelib") then

	minetest.register_craft({
		output = "vm16:programmer",
		recipe = {
			{"basic_materials:steel_strip", "default:obsidian_glass", ""},
			{"basic_materials:ic", "basic_materials:ic", "basic_materials:ic"},
			{"basic_materials:steel_strip", "basic_materials:gold_wire", "basic_materials:copper_wire"},
		},
	})

	minetest.register_craft({
		output = "vm16:server",
		recipe = {
			{"dye:black", "basic_materials:copper_wire", "dye:black"},
			{"basic_materials:ic", "basic_materials:ic", "basic_materials:ic"},
			{"default:steelblock", "basic_materials:gold_wire", "default:steelblock"},
		},
	})

	minetest.register_craft({
		output = "vm16:sdcard",
		recipe = {
			{"", "basic_materials:plastic_sheet", ""},
			{"", "basic_materials:ic", ""},
			{"", "basic_materials:plastic_sheet", ""},
		},
	})

	minetest.register_craft({
		output = "beduino:controller",
		recipe = {
			{"", "dye:blue", ""},
			{"basic_materials:plastic_sheet", "basic_materials:gold_wire", "basic_materials:steel_strip"},
			{"basic_materials:ic", "basic_materials:ic", "basic_materials:ic"},
		},
	})

	minetest.register_craft({
		output = "beduino:io_module",
		recipe = {
			{"", "dye:blue", ""},
			{"basic_materials:plastic_sheet", "basic_materials:energy_crystal_simple", "basic_materials:steel_strip"},
			{"basic_materials:ic", "basic_materials:ic", "basic_materials:ic"},
		},
	})

	minetest.register_craft({
		output = "beduino:router",
		recipe = {
			{"", "dye:blue", ""},
			{"basic_materials:plastic_sheet", "default:mese_crystal", "basic_materials:steel_strip"},
			{"basic_materials:ic", "basic_materials:ic", "basic_materials:ic"},
		},
	})

	minetest.register_craft({
		output = "beduino:broker",
		recipe = {
			{"basic_materials:plastic_sheet", "dye:blue", "basic_materials:steel_strip"},
			{"basic_materials:ic", "default:mese_crystal", "basic_materials:ic"},
			{"basic_materials:ic", "basic_materials:ic", "basic_materials:ic"},
		},
	})
end
