// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_projectile_vomiting;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_projectile_vomiting
	Checksum: 0xF631C93
	Offset: 0x210
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_projectile_vomiting", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_projectile_vomiting
	Checksum: 0x34D7B1E0
	Offset: 0x250
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("actor", "projectile_vomit", 12000, 1, "counter");
	bgb::register("zm_bgb_projectile_vomiting", "rounds", 5, &enable, &disable, undefined);
	bgb::register_actor_death_override("zm_bgb_projectile_vomiting", &actor_death_override);
}

/*
	Name: enable
	Namespace: zm_bgb_projectile_vomiting
	Checksum: 0x99EC1590
	Offset: 0x310
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function enable()
{
}

/*
	Name: disable
	Namespace: zm_bgb_projectile_vomiting
	Checksum: 0x99EC1590
	Offset: 0x320
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function disable()
{
}

/*
	Name: actor_death_override
	Namespace: zm_bgb_projectile_vomiting
	Checksum: 0xAD3199E8
	Offset: 0x330
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function actor_death_override(attacker)
{
	if(isdefined(self.damagemod))
	{
		switch(self.damagemod)
		{
			case "MOD_EXPLOSIVE":
			case "MOD_GRENADE":
			case "MOD_GRENADE_SPLASH":
			case "MOD_PROJECTILE":
			case "MOD_PROJECTILE_SPLASH":
			{
				clientfield::increment("projectile_vomit", 1);
				break;
			}
		}
	}
}

