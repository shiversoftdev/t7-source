// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craftables;

#using_animtree("zm_genesis");

#namespace zm_genesis_shadowman;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_shadowman
	Checksum: 0x39F22B80
	Offset: 0x448
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_shadowman", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_shadowman
	Checksum: 0x1A15FB5E
	Offset: 0x490
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["shadowman_impact_fx"] = "zombie/fx_shdw_impact_zod_zmb";
	level._effect["shadowman_damaged_fx"] = "zombie/fx_powerup_nuke_zmb";
	clientfield::register("scriptmover", "shadowman_fx", 15000, 3, "int");
}

/*
	Name: __main__
	Namespace: zm_genesis_shadowman
	Checksum: 0x99EC1590
	Offset: 0x508
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
}

/*
	Name: function_8888a532
	Namespace: zm_genesis_shadowman
	Checksum: 0x113788F1
	Offset: 0x518
	Size: 0x1CC
	Parameters: 4
	Flags: Linked
*/
function function_8888a532(var_5b35973a = 1, var_d250bd20 = 0, var_2c1a0d8f = 0, var_32a5629a = 0)
{
	self.var_94d7beef = util::spawn_model("c_zom_dlc4_shadowman_fb", self.origin, self.angles);
	self.var_94d7beef useanimtree($zm_genesis);
	self.var_94d7beef.health = 1000000;
	util::wait_network_frame();
	self.var_94d7beef clientfield::set("shadowman_fx", 1);
	if(var_d250bd20)
	{
		if(var_32a5629a)
		{
			self.var_94d7beef thread animation::play("ai_zm_dlc4_shadowman_idle");
		}
		else
		{
			self.var_94d7beef thread animation::play("ai_zm_dlc4_shadowman_idle");
		}
	}
	if(var_5b35973a)
	{
		self.var_94d7beef setcandamage(1);
	}
	else
	{
		self.var_94d7beef setcandamage(0);
	}
	if(var_2c1a0d8f)
	{
		self.var_94d7beef setinvisibletoall();
	}
}

