// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\craftables\_zm_craftables;

#namespace zm_island_inventory;

/*
	Name: init
	Namespace: zm_island_inventory
	Checksum: 0x57E55C70
	Offset: 0x4D0
	Size: 0x494
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("clientuimodel", "zmInventory.widget_bucket_parts", 9000, 1, "int");
	clientfield::register("toplayer", "bucket_held", 9000, getminbitcountfornum(2), "int");
	clientfield::register("toplayer", "bucket_bucket_type", 9000, getminbitcountfornum(2), "int");
	clientfield::register("toplayer", "bucket_bucket_water_type", 9000, getminbitcountfornum(3), "int");
	clientfield::register("toplayer", "bucket_bucket_water_level", 9000, getminbitcountfornum(3), "int");
	clientfield::register("clientuimodel", "zmInventory.widget_skull_parts", 9000, 1, "int");
	clientfield::register("toplayer", "skull_skull_state", 9000, getminbitcountfornum(3), "int");
	clientfield::register("toplayer", "skull_skull_type", 9000, getminbitcountfornum(3), "int");
	clientfield::register("clientuimodel", "zmInventory.widget_gasmask_parts", 9000, 1, "int");
	clientfield::register("toplayer", "gaskmask_part_visor", 9000, 1, "int");
	clientfield::register("toplayer", "gaskmask_part_strap", 9000, 1, "int");
	clientfield::register("toplayer", "gaskmask_part_filter", 9000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.gaskmask_gasmask_active", 9000, 1, "int");
	clientfield::register("toplayer", "gaskmask_gasmask_progress", 9000, getminbitcountfornum(10), "int");
	clientfield::register("clientuimodel", "zmInventory.widget_machinetools_parts", 9000, 1, "int");
	clientfield::register("toplayer", "valveone_part_lever", 9000, 1, "int");
	clientfield::register("toplayer", "valvetwo_part_lever", 9000, 1, "int");
	clientfield::register("toplayer", "valvethree_part_lever", 9000, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_wonderweapon_parts", 9000, 1, "int");
	clientfield::register("toplayer", "wonderweapon_part_wwi", 9000, 1, "int");
	clientfield::register("toplayer", "wonderweapon_part_wwii", 9000, 1, "int");
	clientfield::register("toplayer", "wonderweapon_part_wwiii", 9000, 1, "int");
}

/*
	Name: main
	Namespace: zm_island_inventory
	Checksum: 0x99EC1590
	Offset: 0x970
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function main()
{
}

/*
	Name: function_1a9a4375
	Namespace: zm_island_inventory
	Checksum: 0x5E3951E9
	Offset: 0x980
	Size: 0x166
	Parameters: 0
	Flags: Linked
*/
function function_1a9a4375()
{
	self endon(#"disconnect");
	self.var_df4182b1 = 0;
	self.var_4d1c77e5 = 0;
	while(true)
	{
		self waittill(#"player_has_gasmask");
		self thread function_2cc6bcea();
		self playsoundtoplayer("zmb_gasmask_pickup", self);
		self thread function_8801a9c5();
		var_ba18d83c = 10;
		self thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.gaskmask_gasmask_active", 0);
		self clientfield::set_to_player("gaskmask_gasmask_progress", var_ba18d83c);
		while(isdefined(self.var_df4182b1) && self.var_df4182b1 && var_ba18d83c > 0)
		{
			self waittill(#"hash_b56a74a8");
			self playsoundtoplayer("zmb_gasmask_use", self);
			var_ba18d83c = var_ba18d83c - 1;
			self thread function_6649823b(var_ba18d83c);
			wait(1);
		}
		self notify(#"player_lost_gasmask");
	}
}

/*
	Name: function_2cc6bcea
	Namespace: zm_island_inventory
	Checksum: 0x26B41F7F
	Offset: 0xAF0
	Size: 0x170
	Parameters: 0
	Flags: Linked
*/
function function_2cc6bcea()
{
	self endon(#"disconnect");
	mdl_body = self getcharacterbodymodel();
	switch(mdl_body)
	{
		case "c_zom_der_nikolai_mpc_fb":
		{
			str_character = "nikolai";
			break;
		}
		case "c_zom_der_dempsey_mpc_fb":
		{
			str_character = "dempsey";
			break;
		}
		case "c_zom_der_richtofen_mpc_fb":
		{
			str_character = "richtofen";
			break;
		}
		case "c_zom_der_takeo_mpc_fb":
		{
			str_character = "takeo";
			break;
		}
	}
	if(!(isdefined(self.var_4d1c77e5) && self.var_4d1c77e5))
	{
		self attach(("c_zom_dlc2_" + str_character) + "_head_gasmask");
		self.var_4d1c77e5 = 1;
	}
	self util::waittill_any("disconnect", "death", "player_lost_gasmask");
	if(isdefined(self.var_4d1c77e5) && self.var_4d1c77e5)
	{
		self detach(("c_zom_dlc2_" + str_character) + "_head_gasmask");
		self.var_4d1c77e5 = 0;
	}
}

/*
	Name: function_6649823b
	Namespace: zm_island_inventory
	Checksum: 0xA8424F3F
	Offset: 0xC68
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_6649823b(var_ba18d83c)
{
	self notify(#"hash_cc68cc91");
	self endon(#"death");
	self endon(#"hash_cc68cc91");
	self clientfield::set_player_uimodel("zmInventory.gaskmask_gasmask_active", 1);
	self clientfield::set_to_player("gaskmask_gasmask_progress", var_ba18d83c);
	self waittill(#"hash_dd8e5266");
	self thread clientfield::set_player_uimodel("zmInventory.gaskmask_gasmask_active", 0);
}

/*
	Name: function_8801a9c5
	Namespace: zm_island_inventory
	Checksum: 0x87BD9D5
	Offset: 0xD10
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_8801a9c5()
{
	self endon(#"disconnect");
	self util::waittill_any("death", "player_lost_gasmask");
	self playsoundtoplayer("zmb_gasmask_break", self);
	self.var_df4182b1 = 0;
}

