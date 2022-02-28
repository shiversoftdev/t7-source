// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_newtonian_negation;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_newtonian_negation
	Checksum: 0xE91D8A00
	Offset: 0x1A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_newtonian_negation", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_newtonian_negation
	Checksum: 0x17A758B2
	Offset: 0x1E8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_newtonian_negation", "time", 1500, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_newtonian_negation
	Checksum: 0xC088CF25
	Offset: 0x250
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	function_2b4ff13a(1);
	self thread function_7d6ddd3a();
}

/*
	Name: function_7d6ddd3a
	Namespace: zm_bgb_newtonian_negation
	Checksum: 0x7D77B374
	Offset: 0x290
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_7d6ddd3a()
{
	self endon(#"hash_7e8cbf8f");
	self waittill(#"disconnect");
	thread disable();
}

/*
	Name: disable
	Namespace: zm_bgb_newtonian_negation
	Checksum: 0xB239C052
	Offset: 0x2C8
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function disable()
{
	if(isdefined(self))
	{
		self notify(#"hash_7e8cbf8f");
	}
	foreach(player in level.players)
	{
		if(player !== self && player bgb::is_enabled("zm_bgb_newtonian_negation"))
		{
			return;
		}
	}
	function_2b4ff13a(0);
	zombie_utility::clear_all_corpses();
}

/*
	Name: function_2b4ff13a
	Namespace: zm_bgb_newtonian_negation
	Checksum: 0xD8054583
	Offset: 0x3B0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_2b4ff13a(var_365c612)
{
	if(var_365c612)
	{
		setdvar("phys_gravity_dir", (0, 0, -1));
	}
	else
	{
		setdvar("phys_gravity_dir", (0, 0, 1));
	}
}

