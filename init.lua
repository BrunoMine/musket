--[[
	Mod Musket para Minetest
	Copyright (C) 2018 BrunoMine (https://github.com/BrunoMine)
	
	Recebeste uma cópia da GNU Lesser General
	Public License junto com esse software,
	se não, veja em <http://www.gnu.org/licenses/>. 
	
	Arma Mosquete
  ]]
  
-- Tabela Global
musket = {}

local modpath = minetest.get_modpath("musket")

dofile(modpath.."/tradutor.lua")

local S = musket.S

-- Arma descarregada
minetest.register_craftitem("musket:ammo_mosquete_descarregado", {
	description = "Mosquete Descarregado",
	inventory_image = "musket_mosquete_descarregado.png",
 
	on_drop = function(itemstack, dropper, pos)
		-- Prints a random number and removes one item from the stack
		minetest.chat_send_all(math.random())
		itemstack:take_item()
		return itemstack
	end,
})

-- Munição de Mosquete
minetest.register_craftitem("musket:ammo_mosquete", {
	description = S("Munição para Mosquete"),
	inventory_image = "musket_ammo_mosquete.png",
	wield_image = "musket_ammo_mosquete_na_mao.png",
	stack_max = 15,
})

-- Mosquete
shooter:register_weapon("musket:mosquete", {
	description = S("Mosquete"),
	inventory_image = "musket_mosquete.png",
	rounds = 1.1,
	ammo = "musket:ammo_mosquete",
	spec = {
		range = 20,
		step = 30,
		tool_caps = {full_punch_interval=1.2, damage_groups={fleshy=6}},
		groups = {snappy=3, crumbly=3, choppy=3, fleshy=2, oddly_breakable_by_hand=2},
		sound = "musket_mosquete",
		particle = "shooter_bullet.png",
	},
})

-- Mosquete Descarregado
shooter:register_weapon("musket:mosquete_descarregado", {
	description = S("Mosquete"),
	inventory_image = "musket_mosquete_descarregado.png",
	rounds = 1.1,
	ammo = "musket:ammo_mosquete",
	spec = {
		range = 20,
		step = 30,
		tool_caps = {full_punch_interval=1.2, damage_groups={fleshy=6}},
		groups = {snappy=3, crumbly=3, choppy=3, fleshy=2, oddly_breakable_by_hand=2},
		sound = "musket_mosquete",
		particle = "shooter_bullet.png",
	},
})


-- Ajustes
local old_on_use1 = minetest.registered_tools["musket:mosquete_descarregado"].on_use
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_tools["musket:mosquete_descarregado"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups)) or {}
	
	-- Altera alguns paremetros
	def.groups.not_in_creative_inventory = 1
	
	-- Troca o mosquete
	def.on_use = function(itemstack, user, pointed_thing)
		if old_on_use1 then
			itemstack = old_on_use1(itemstack, user, pointed_thing)
		end
		
		-- Verifica se descarregou
		if itemstack:get_wear() < 500 then
			itemstack:set_name("musket:mosquete")
		end
		
		return itemstack
	end
	
	-- Registra o novo node
	minetest.override_item("musket:mosquete_descarregado", {groups=def.groups, on_use=def.on_use})
end

local old_on_use2 = minetest.registered_tools["musket:mosquete"].on_use
do
	-- Copiar tabela de definições
	local def = {}
	for n,d in pairs(minetest.registered_tools["musket:mosquete"]) do
		def[n] = d
	end
	-- Mantem a tabela groups separada
	def.groups = minetest.deserialize(minetest.serialize(def.groups)) or {}
	
	-- Altera alguns paremetros
	-- Troca o mosquete
	def.on_use = function(itemstack, user, pointed_thing)
		if old_on_use2 then
			itemstack = old_on_use2(itemstack, user, pointed_thing)
		end
		
		-- Verifica se descarregou
		if itemstack:get_wear() > 50000 then
			itemstack:set_name("musket:mosquete_descarregado")
		end
		
		return itemstack
	end
	
	-- Registra o novo node
	minetest.override_item("musket:mosquete", {groups=def.groups, on_use=def.on_use})
end
