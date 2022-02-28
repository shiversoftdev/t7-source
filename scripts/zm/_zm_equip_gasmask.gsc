// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_equip_gasmask;

/*
	Name: __init__sytem__
	Namespace: zm_equip_gasmask
	Checksum: 0x6EFAFA2B
	Offset: 0x2E8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_equip_gasmask", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_equip_gasmask
	Checksum: 0x66F61C76
	Offset: 0x330
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "gasmaskoverlay", 21000, 1, "int");
	clientfield::register("clientuimodel", "hudItems.showDpadDown_PES", 21000, 1, "int");
	zm_equipment::register("equip_gasmask", &"ZOMBIE_EQUIP_GASMASK_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_GASMASK_HOWTO", undefined, "gasmask");
	zm_equipment::register_slot_watcher_override("equip_gasmask", &function_7cb416b);
	visionset_mgr::register_info("overlay", "zm_gasmask_postfx", 21000, 501, 32, 1);
	callback::on_spawned(&on_player_spawned);
	level.var_f486078e = getweapon("equip_gasmask");
}

/*
	Name: __main__
	Namespace: zm_equip_gasmask
	Checksum: 0x4C492B5E
	Offset: 0x468
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	zm_equipment::register_for_level("equip_gasmask");
	zm_equipment::register_for_level("lower_equip_gasmask");
	zm_equipment::include("equip_gasmask");
}

/*
	Name: on_player_spawned
	Namespace: zm_equip_gasmask
	Checksum: 0x743CBA77
	Offset: 0x4C0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread gasmask_removed_watcher_thread();
	self thread remove_gasmask_on_game_over();
	self thread gasmask_activation_watcher_thread();
	self thread function_4933258e();
	self thread remove_gasmask_on_player_bleedout();
	self clientfield::set_to_player("gasmaskoverlay", 0);
	visionset_mgr::deactivate("overlay", "zm_gasmask_postfx", self);
	self zm_equipment::set_equipment_invisibility_to_player(level.var_f486078e, 0);
}

/*
	Name: gasmask_removed_watcher_thread
	Namespace: zm_equip_gasmask
	Checksum: 0xC63E9C3D
	Offset: 0x5A8
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function gasmask_removed_watcher_thread()
{
	self notify(#"only_one_gasmask_removed_thread");
	self endon(#"only_one_gasmask_removed_thread");
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"hash_5a02c845");
		if(isdefined(level.zombiemode_gasmask_reset_player_model))
		{
			ent_num = self.characterindex;
			if(isdefined(self.zm_random_char))
			{
				ent_num = self.zm_random_char;
			}
			self [[level.zombiemode_gasmask_reset_player_model]](ent_num);
		}
		if(isdefined(level.zombiemode_gasmask_reset_player_viewmodel))
		{
			ent_num = self.characterindex;
			if(isdefined(self.zm_random_char))
			{
				ent_num = self.zm_random_char;
			}
			self [[level.zombiemode_gasmask_reset_player_viewmodel]](ent_num);
		}
		self clientfield::set_player_uimodel("hudItems.showDpadDown_PES", 0);
		self clientfield::set_to_player("gasmaskoverlay", 0);
		visionset_mgr::deactivate("overlay", "zm_gasmask_postfx", self);
		level clientfield::set(("player" + self getentitynumber()) + "wearableItem", 0);
	}
}

/*
	Name: gasmask_activation_watcher_thread
	Namespace: zm_equip_gasmask
	Checksum: 0x3EEB0A44
	Offset: 0x710
	Size: 0x4EE
	Parameters: 0
	Flags: Linked
*/
function gasmask_activation_watcher_thread()
{
	self endon(#"zombified");
	self endon(#"disconnect");
	self notify(#"hash_b0734faa");
	self endon(#"hash_b0734faa");
	var_f499fcb0 = getweapon("lower_equip_gasmask");
	if(isdefined(level.zombiemode_gasmask_reset_player_model))
	{
		ent_num = self.characterindex;
		self [[level.zombiemode_gasmask_reset_player_model]](ent_num);
	}
	while(true)
	{
		str_notify = self util::waittill_any_return("equip_gasmask_activate", "equip_gasmask_deactivate", "disconnect");
		if(!self zm_equipment::has_player_equipment(level.var_f486078e))
		{
			continue;
		}
		if(self zm_equipment::is_active(level.var_f486078e))
		{
			self zm_utility::increment_is_drinking();
			self setactionslot(2, "");
			if(isdefined(level.zombiemode_gasmask_change_player_headmodel))
			{
				ent_num = self.characterindex;
				if(isdefined(self.zm_random_char))
				{
					ent_num = self.zm_random_char;
				}
				self [[level.zombiemode_gasmask_change_player_headmodel]](ent_num, 1);
			}
			self clientfield::increment_to_player("gas_mask_on");
			self waittill(#"weapon_change_complete");
			level clientfield::set(("player" + self getentitynumber()) + "wearableItem", 1);
			self clientfield::set_to_player("gasmaskoverlay", 1);
			visionset_mgr::activate("overlay", "zm_gasmask_postfx", self);
		}
		else
		{
			self zm_utility::increment_is_drinking();
			self setactionslot(2, "");
			if(isdefined(level.zombiemode_gasmask_change_player_headmodel))
			{
				ent_num = self.characterindex;
				if(isdefined(self.zm_random_char))
				{
					ent_num = self.zm_random_char;
				}
				self [[level.zombiemode_gasmask_change_player_headmodel]](ent_num, 0);
			}
			self takeweapon(level.var_f486078e);
			self giveweapon(var_f499fcb0);
			self switchtoweapon(var_f499fcb0);
			wait(0.05);
			self clientfield::set_to_player("gasmaskoverlay", 0);
			visionset_mgr::deactivate("overlay", "zm_gasmask_postfx", self);
			level clientfield::set(("player" + self getentitynumber()) + "wearableItem", 0);
			self waittill(#"weapon_change_complete");
			self takeweapon(var_f499fcb0);
			self giveweapon(level.var_f486078e);
		}
		if(!self laststand::player_is_in_laststand())
		{
			if(self zm_utility::is_multiple_drinking())
			{
				self zm_utility::decrement_is_drinking();
				self setactionslot(2, "weapon", level.var_f486078e);
				self notify(#"equipment_select_response_done");
				continue;
			}
			else
			{
				self zm_weapons::switch_back_primary_weapon(self.prev_weapon_before_equipment_change);
			}
		}
		self setactionslot(2, "weapon", level.var_f486078e);
		if(!self laststand::player_is_in_laststand() && (!(isdefined(self.intermission) && self.intermission)))
		{
			self zm_utility::decrement_is_drinking();
		}
		self notify(#"equipment_select_response_done");
	}
}

/*
	Name: function_4933258e
	Namespace: zm_equip_gasmask
	Checksum: 0xA52FF89
	Offset: 0xC08
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_4933258e()
{
	self notify(#"hash_17dade16");
	self endon(#"hash_17dade16");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"player_given", equipment);
		if(equipment == level.var_f486078e)
		{
			self clientfield::set_player_uimodel("hudItems.showDpadDown_PES", 1);
		}
		if(isdefined(level.zombiemode_gasmask_set_player_model))
		{
			ent_num = self.characterindex;
			if(isdefined(self.zm_random_char))
			{
				ent_num = self.zm_random_char;
			}
			self [[level.zombiemode_gasmask_set_player_model]](ent_num);
			self clientfield::increment_to_player("gas_mask_buy");
		}
	}
}

/*
	Name: remove_gasmask_on_player_bleedout
	Namespace: zm_equip_gasmask
	Checksum: 0x10FD02FC
	Offset: 0xCF8
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function remove_gasmask_on_player_bleedout()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"bled_out");
		self clientfield::set_player_uimodel("hudItems.showDpadDown_PES", 0);
		self clientfield::set_to_player("gasmaskoverlay", 0);
		visionset_mgr::deactivate("overlay", "zm_gasmask_postfx", self);
		level clientfield::set(("player" + self getentitynumber()) + "wearableItem", 0);
		self takeweapon(level.var_f486078e);
	}
}

/*
	Name: remove_gasmask_on_game_over
	Namespace: zm_equip_gasmask
	Checksum: 0xD9EAFE79
	Offset: 0xDE0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function remove_gasmask_on_game_over()
{
	self endon(#"hash_5a02c845");
	level waittill(#"pre_end_game");
	if(isdefined(self))
	{
		self clientfield::set_to_player("gasmaskoverlay", 0);
		visionset_mgr::deactivate("overlay", "zm_gasmask_postfx", self);
	}
}

/*
	Name: gasmask_active
	Namespace: zm_equip_gasmask
	Checksum: 0x8C59D722
	Offset: 0xE50
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function gasmask_active()
{
	return self zm_equipment::is_active(level.var_f486078e);
}

/*
	Name: gasmask_debug_print
	Namespace: zm_equip_gasmask
	Checksum: 0x5C06F647
	Offset: 0xE80
	Size: 0x8C
	Parameters: 2
	Flags: None
*/
function gasmask_debug_print(msg, color)
{
	/#
		if(!getdvarint(""))
		{
			return;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		print3d(self.origin + vectorscale((0, 0, 1), 60), msg, color, 1, 1, 40);
	#/
}

/*
	Name: function_7cb416b
	Namespace: zm_equip_gasmask
	Checksum: 0x8A00934
	Offset: 0xF18
	Size: 0xBC
	Parameters: 4
	Flags: Linked
*/
function function_7cb416b(var_226f0a45, var_4bbe5bcf, var_d79c9dc0, str_notify)
{
	if(var_4bbe5bcf == var_226f0a45)
	{
		if(self.current_equipment_active[var_226f0a45] == 1)
		{
			self notify(str_notify.deactivate);
			self.current_equipment_active[var_226f0a45] = 0;
		}
		else if(self.current_equipment_active[var_226f0a45] == 0)
		{
			self notify(str_notify.activate);
			self.current_equipment_active[var_226f0a45] = 1;
		}
		self waittill(#"equipment_select_response_done");
	}
}

