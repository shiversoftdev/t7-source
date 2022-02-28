// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_sword_flay;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_sword_flay
	Checksum: 0xC0C4313B
	Offset: 0x198
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_sword_flay", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_sword_flay
	Checksum: 0xC10F4D85
	Offset: 0x1D8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_sword_flay", "time", 150, &enable, &disable, undefined);
	bgb::register_actor_damage_override("zm_bgb_sword_flay", &actor_damage_override);
	bgb::register_vehicle_damage_override("zm_bgb_sword_flay", &vehicle_damage_override);
}

/*
	Name: enable
	Namespace: zm_bgb_sword_flay
	Checksum: 0x99EC1590
	Offset: 0x290
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function enable()
{
}

/*
	Name: disable
	Namespace: zm_bgb_sword_flay
	Checksum: 0x99EC1590
	Offset: 0x2A0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function disable()
{
}

/*
	Name: actor_damage_override
	Namespace: zm_bgb_sword_flay
	Checksum: 0xCD14ACEE
	Offset: 0x2B0
	Size: 0xE0
	Parameters: 12
	Flags: Linked
*/
function actor_damage_override(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(meansofdeath === "MOD_MELEE")
	{
		damage = damage * 5;
		if((self.health - damage) <= 0 && isdefined(attacker) && isplayer(attacker))
		{
			attacker zm_stats::increment_challenge_stat("GUM_GOBBLER_SWORD_FLAY");
		}
	}
	return damage;
}

/*
	Name: vehicle_damage_override
	Namespace: zm_bgb_sword_flay
	Checksum: 0xC12369CB
	Offset: 0x398
	Size: 0xA2
	Parameters: 15
	Flags: Linked
*/
function vehicle_damage_override(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(smeansofdeath === "MOD_MELEE")
	{
		idamage = idamage * 5;
	}
	return idamage;
}

