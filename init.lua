--[[
	Musket mod for Minetest
	Copyright (C) 2019 BrunoMine (https://github.com/BrunoMine)
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
  ]]


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

-- Musket Ammo craft
minetest.register_craft({
	output = "musket:musket_ammo 6",
	recipe = {
		{"shooter:gunpowder", "", "shooter:gunpowder"},
		{"", "default:steel_ingot", ""},
		{"shooter:gunpowder", "default:acacia_wood", "shooter:gunpowder"}
	}
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
		range = 30,
		step = 30,
		tool_caps = {full_punch_interval=1.2, damage_groups={fleshy=4}},
		groups = {snappy=3, crumbly=3, choppy=3, fleshy=2, oddly_breakable_by_hand=2},
		sound = "musket_shot",
		bullet_image = "musket_bullet.png",
		particles = {
			amount = 8,
			minsize = 0.25,
			maxsize = 0.75,
		},
	},
	
	sounds = {
		reload = "musket_reload",
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
	
	def.groups.not_in_creative_inventory = nil
	
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

-- Musket craft
minetest.register_craft({
	output = "musket:musket_loaded",
	recipe = {
		{"default:steel_ingot", "", ""},
		{"", "default:steel_ingot", "musket:musket_ammo"},
		{"", "group:stick", "default:acacia_wood"}
	}
})

