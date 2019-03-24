--[[
	Musket mod for Minetest
	Copyright (C) 2019 BrunoMine (https://github.com/BrunoMine)
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
  ]]

  
-- Global Table
musket = {}

local modpath = minetest.get_modpath("musket")

-- Make translation files
dofile(modpath.."/translation_file_maker.lua")

-- Translate strings
local S = minetest.get_translator("musket")

-- Musket Ammo
minetest.register_craftitem("musket:musket_ammo", {
	description = S("Musket Ammo"),
	inventory_image = "musket_ammo_inv.png",
	wield_image = "musket_ammo_wielded.png",
	stack_max = 15,
})

-- Register Musket shooter
shooter.register_weapon("musket:musket", {
	description = S("Musket (Loaded)"),
	inventory_image = "musket_loaded.png",
	reload_item = "musket:musket_ammo",
	unloaded_item = {
		description = S("Musket"),
		inventory_image = "musket.png",
	},
	
	spec = {
		rounds = 1.1,
		range = 20,
		step = 30,
		tool_caps = {full_punch_interval=1.2, damage_groups={fleshy=6}},
		sound = "musket_shot",
		particle = "shooter_bullet.png",
	},
})

-- Exchange mesket to unloaded after a shot
local old_on_use = minetest.registered_tools["musket:musket_loaded"].on_use
do
	-- Copy table def
	local def = {}
	for n,d in pairs(minetest.registered_tools["musket:musket_loaded"]) do
		def[n] = d
	end
	
	-- Separate groups
	def.groups = minetest.deserialize(minetest.serialize(def.groups)) or {}
	
	-- New 'on_use' callback
	def.on_use = function(itemstack, user, pointed_thing)
		if old_on_use then
			itemstack = old_on_use(itemstack, user, pointed_thing)
		end
		
		-- Exchange mesket
		itemstack:set_name("musket:musket")
		
		return itemstack
	end
	
	-- Override item
	minetest.override_item("musket:musket_loaded", {groups=def.groups, on_use=def.on_use})
end

