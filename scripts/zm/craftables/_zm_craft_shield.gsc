// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_powerup_shield_charge;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\craftables\_zm_craftables;

#namespace zm_craft_shield;

/*
	Name: __init__sytem__
	Namespace: zm_craft_shield
	Checksum: 0x1FD66332
	Offset: 0x438
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_craft_shield", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_craft_shield
	Checksum: 0x99EC1590
	Offset: 0x480
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: init
	Namespace: zm_craft_shield
	Checksum: 0xA0A13710
	Offset: 0x490
	Size: 0x47C
	Parameters: 6
	Flags: Linked
*/
function init(shield_equipment, shield_weapon, shield_model, str_to_craft = &"ZOMBIE_CRAFT_RIOT", str_taken = &"ZOMBIE_BOUGHT_RIOT", str_grab = &"ZOMBIE_GRAB_RIOTSHIELD")
{
	level.craftable_shield_equipment = shield_equipment;
	level.craftable_shield_weapon = shield_weapon;
	level.craftable_shield_model = shield_model;
	level.craftable_shield_grab = str_grab;
	level.riotshield_supports_deploy = 0;
	riotshield_dolly = zm_craftables::generate_zombie_craftable_piece(level.craftable_shield_equipment, "dolly", 32, 64, 0, undefined, &on_pickup_common, &on_drop_common, undefined, undefined, undefined, undefined, "piece_riotshield_dolly", 1, "build_zs");
	riotshield_door = zm_craftables::generate_zombie_craftable_piece(level.craftable_shield_equipment, "door", 48, 15, 25, undefined, &on_pickup_common, &on_drop_common, undefined, undefined, undefined, undefined, "piece_riotshield_door", 1, "build_zs");
	riotshield_clamp = zm_craftables::generate_zombie_craftable_piece(level.craftable_shield_equipment, "clamp", 48, 15, 25, undefined, &on_pickup_common, &on_drop_common, undefined, undefined, undefined, undefined, "piece_riotshield_clamp", 1, "build_zs");
	registerclientfield("world", "piece_riotshield_dolly", 1, 1, "int", undefined, 0);
	registerclientfield("world", "piece_riotshield_door", 1, 1, "int", undefined, 0);
	registerclientfield("world", "piece_riotshield_clamp", 1, 1, "int", undefined, 0);
	clientfield::register("toplayer", "ZMUI_SHIELD_PART_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZMUI_SHIELD_CRAFTED", 1, 1, "int");
	riotshield = spawnstruct();
	riotshield.name = level.craftable_shield_equipment;
	riotshield.weaponname = level.craftable_shield_weapon;
	riotshield zm_craftables::add_craftable_piece(riotshield_dolly);
	riotshield zm_craftables::add_craftable_piece(riotshield_door);
	riotshield zm_craftables::add_craftable_piece(riotshield_clamp);
	riotshield.onbuyweapon = &on_buy_weapon_riotshield;
	riotshield.triggerthink = &riotshield_craftable;
	zm_craftables::include_zombie_craftable(riotshield);
	zm_craftables::add_zombie_craftable(level.craftable_shield_equipment, str_to_craft, "ERROR", str_taken, &on_fully_crafted, 1);
	zm_craftables::add_zombie_craftable_vox_category(level.craftable_shield_equipment, "build_zs");
	zm_craftables::make_zombie_craftable_open(level.craftable_shield_equipment, level.craftable_shield_model, vectorscale((0, -1, 0), 90), vectorscale((0, 0, 1), 26));
}

/*
	Name: __main__
	Namespace: zm_craft_shield
	Checksum: 0x4D304F75
	Offset: 0x918
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	/#
		function_f3127c4f();
	#/
}

/*
	Name: riotshield_craftable
	Namespace: zm_craft_shield
	Checksum: 0xD2C90327
	Offset: 0x940
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function riotshield_craftable()
{
	zm_craftables::craftable_trigger_think("riotshield_zm_craftable_trigger", level.craftable_shield_equipment, level.craftable_shield_weapon, level.craftable_shield_grab, 1, 1);
}

/*
	Name: show_infotext_for_duration
	Namespace: zm_craft_shield
	Checksum: 0xBA70474A
	Offset: 0x988
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function show_infotext_for_duration(str_infotext, n_duration)
{
	self clientfield::set_to_player(str_infotext, 1);
	wait(n_duration);
	self clientfield::set_to_player(str_infotext, 0);
}

/*
	Name: on_pickup_common
	Namespace: zm_craft_shield
	Checksum: 0x84261DE7
	Offset: 0x9E8
	Size: 0x148
	Parameters: 1
	Flags: Linked
*/
function on_pickup_common(player)
{
	/#
		println("");
	#/
	player playsound("zmb_craftable_pickup");
	if(isdefined(level.craft_shield_piece_pickup_vo_override))
	{
		player thread [[level.craft_shield_piece_pickup_vo_override]]();
	}
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_shield", "zmInventory.widget_shield_parts", 0);
		e_player thread show_infotext_for_duration("ZMUI_SHIELD_PART_PICKUP", 3.5);
	}
	self pickup_from_mover();
	self.piece_owner = player;
}

/*
	Name: on_drop_common
	Namespace: zm_craft_shield
	Checksum: 0xCD5B9B4D
	Offset: 0xB38
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function on_drop_common(player)
{
	/#
		println("");
	#/
	self drop_on_mover(player);
	self.piece_owner = undefined;
}

/*
	Name: pickup_from_mover
	Namespace: zm_craft_shield
	Checksum: 0xF1366177
	Offset: 0xB90
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function pickup_from_mover()
{
	if(isdefined(level.craft_shield_pickup_override))
	{
		[[level.craft_shield_pickup_override]]();
	}
}

/*
	Name: on_fully_crafted
	Namespace: zm_craft_shield
	Checksum: 0x2EE760D8
	Offset: 0xBB8
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function on_fully_crafted()
{
	players = level.players;
	foreach(e_player in players)
	{
		if(zm_utility::is_player_valid(e_player))
		{
			e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_shield", "zmInventory.widget_shield_parts", 1);
			e_player thread show_infotext_for_duration("ZMUI_SHIELD_CRAFTED", 3.5);
		}
	}
	return true;
}

/*
	Name: drop_on_mover
	Namespace: zm_craft_shield
	Checksum: 0xB4F35B68
	Offset: 0xCB0
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function drop_on_mover(player)
{
	if(isdefined(level.craft_shield_drop_override))
	{
		[[level.craft_shield_drop_override]]();
	}
}

/*
	Name: on_buy_weapon_riotshield
	Namespace: zm_craft_shield
	Checksum: 0xF23923D0
	Offset: 0xCE0
	Size: 0x96
	Parameters: 1
	Flags: Linked
*/
function on_buy_weapon_riotshield(player)
{
	if(isdefined(player.player_shield_reset_health))
	{
		player [[player.player_shield_reset_health]]();
	}
	if(isdefined(player.player_shield_reset_location))
	{
		player [[player.player_shield_reset_location]]();
	}
	player playsound("zmb_craftable_buy_shield");
	level notify(#"shield_built", player);
}

/*
	Name: function_f3127c4f
	Namespace: zm_craft_shield
	Checksum: 0xC5BA1F70
	Offset: 0xD80
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_f3127c4f()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_b6937313);
		setdvar("", 0);
		adddebugcommand(("" + level.craftable_shield_equipment) + "");
		adddebugcommand(("" + level.craftable_shield_equipment) + "");
		adddebugcommand(("" + level.craftable_shield_equipment) + "");
	#/
}

/*
	Name: function_b6937313
	Namespace: zm_craft_shield
	Checksum: 0x73F015CF
	Offset: 0xE80
	Size: 0x1CE
	Parameters: 1
	Flags: Linked
*/
function function_b6937313(cmd)
{
	/#
		players = getplayers();
		retval = 0;
		switch(cmd)
		{
			case "":
			{
				array::thread_all(players, &function_2b0b208f);
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 1)
				{
					players[0] thread function_2b0b208f();
				}
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 2)
				{
					players[1] thread function_2b0b208f();
				}
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 3)
				{
					players[2] thread function_2b0b208f();
				}
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 4)
				{
					players[3] thread function_2b0b208f();
				}
				retval = 1;
				break;
			}
			case "":
			{
				array::thread_all(level.players, &function_70d7908d);
				retval = 1;
				break;
			}
		}
		return retval;
	#/
}

/*
	Name: detect_reentry
	Namespace: zm_craft_shield
	Checksum: 0xECEFADE4
	Offset: 0x1058
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function detect_reentry()
{
	/#
		if(isdefined(self.devgui_preserve_time))
		{
			if(self.devgui_preserve_time == gettime())
			{
				return true;
			}
		}
		self.devgui_preserve_time = gettime();
		return false;
	#/
}

/*
	Name: function_2b0b208f
	Namespace: zm_craft_shield
	Checksum: 0x8B036884
	Offset: 0x1098
	Size: 0x198
	Parameters: 0
	Flags: Linked
*/
function function_2b0b208f()
{
	/#
		if(self detect_reentry())
		{
			return;
		}
		self notify(#"hash_2b0b208f");
		self endon(#"hash_2b0b208f");
		self.var_74469a7a = !(isdefined(self.var_74469a7a) && self.var_74469a7a);
		println((("" + self.name) + "") + (self.var_74469a7a ? "" : ""));
		iprintlnbold((("" + self.name) + "") + (self.var_74469a7a ? "" : ""));
		if(self.var_74469a7a)
		{
			while(isdefined(self))
			{
				damagemax = level.weaponriotshield.weaponstarthitpoints;
				if(isdefined(self.weaponriotshield))
				{
					damagemax = self.weaponriotshield.weaponstarthitpoints;
				}
				shieldhealth = damagemax;
				shieldhealth = self damageriotshield(0);
				self damageriotshield(shieldhealth - damagemax);
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_70d7908d
	Namespace: zm_craft_shield
	Checksum: 0x975B5366
	Offset: 0x1238
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_70d7908d()
{
	/#
		if(self detect_reentry())
		{
			return;
		}
		if(isdefined(self.hasriotshield) && self.hasriotshield)
		{
			self zm_equipment::change_ammo(self.weaponriotshield, 1);
		}
	#/
}

