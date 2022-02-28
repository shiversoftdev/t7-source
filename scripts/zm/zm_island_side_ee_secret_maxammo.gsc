// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_island_util;

#namespace zm_island_side_ee_secret_maxammo;

/*
	Name: __init__sytem__
	Namespace: zm_island_side_ee_secret_maxammo
	Checksum: 0x8EC3DDD7
	Offset: 0x430
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_side_ee_secret_maxammo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_side_ee_secret_maxammo
	Checksum: 0x763F90C3
	Offset: 0x470
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.var_e9cb2217 = spawnstruct();
	level.var_e9cb2217.mdl_wall = getent("side_ee_secret_maxammo_wall", "targetname");
	level.var_e9cb2217.var_66253114 = getent("side_ee_secret_maxammo_decal", "targetname");
	level.var_e9cb2217.mdl_clip = getent("side_ee_secret_maxammo_clip", "targetname");
	level.var_e9cb2217.var_fc7e1b7a = struct::get("s_secret_ammo_pos", "targetname");
	level.var_e9cb2217.var_2559c370 = getent("easter_egg_hidden_max_ammo_appear", "targetname");
	level.var_e9cb2217.var_2559c370 hide();
	callback::on_spawned(&on_player_spawned);
	callback::on_connect(&on_player_connected);
}

/*
	Name: main
	Namespace: zm_island_side_ee_secret_maxammo
	Checksum: 0xBE1D8FA5
	Offset: 0x5E8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level.var_e9cb2217.mdl_wall clientfield::set("do_fade_material", 1);
	level.var_e9cb2217.var_66253114 clientfield::set("do_fade_material", 0.5);
	/#
		level thread function_35b46d1a();
	#/
}

/*
	Name: on_player_spawned
	Namespace: zm_island_side_ee_secret_maxammo
	Checksum: 0x12185FEE
	Offset: 0x670
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread function_1c4fc4a7(level.var_e9cb2217.mdl_wall);
}

/*
	Name: on_player_connected
	Namespace: zm_island_side_ee_secret_maxammo
	Checksum: 0x99EC1590
	Offset: 0x6A8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connected()
{
}

/*
	Name: function_1c4fc4a7
	Namespace: zm_island_side_ee_secret_maxammo
	Checksum: 0xC03C180A
	Offset: 0x6B8
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function function_1c4fc4a7(mdl_target)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"hash_49419595");
	if(isdefined(mdl_target))
	{
		self zm_island_util::function_7448e472(mdl_target);
		if(!isdefined(mdl_target) || mdl_target.var_f0b65c0a !== self)
		{
			self notify(#"hash_49419595");
		}
		else
		{
			function_8ae0d6df();
			callback::remove_on_spawned(&on_player_spawned);
		}
	}
}

/*
	Name: function_8ae0d6df
	Namespace: zm_island_side_ee_secret_maxammo
	Checksum: 0xEA5BA053
	Offset: 0x780
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function function_8ae0d6df()
{
	exploder::exploder("fxexp_507");
	var_7ddcf23 = level.var_e9cb2217.var_fc7e1b7a;
	var_b1f3f7cd = var_7ddcf23.origin;
	zm_powerups::specific_powerup_drop("full_ammo", var_b1f3f7cd);
	level.var_e9cb2217.var_2559c370 show();
	level.var_e9cb2217.var_66253114 clientfield::set("do_fade_material", 0);
	wait(0.25);
	level.var_e9cb2217.mdl_wall clientfield::set("do_fade_material", 0);
	wait(0.25);
	level.var_e9cb2217.var_66253114 delete();
	level.var_e9cb2217.mdl_wall delete();
	if(isdefined(level.var_e9cb2217.mdl_clip))
	{
		level.var_e9cb2217.mdl_clip delete();
	}
}

/*
	Name: function_35b46d1a
	Namespace: zm_island_side_ee_secret_maxammo
	Checksum: 0x89AC6280
	Offset: 0x8F8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_35b46d1a()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_41601624);
		adddebugcommand("");
	#/
}

/*
	Name: function_41601624
	Namespace: zm_island_side_ee_secret_maxammo
	Checksum: 0xE807F219
	Offset: 0x948
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_41601624(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				function_8ae0d6df();
				return true;
			}
		}
		return false;
	#/
}

