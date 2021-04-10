// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_electric_cherry;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_perks;

#namespace zm_island_perks;

/*
	Name: init
	Namespace: zm_island_perks
	Checksum: 0x93A98CDE
	Offset: 0x408
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("world", "perk_light_speed_cola", 1, 3, "int", &perk_light_speed_cola, 0, 0);
	clientfield::register("world", "perk_light_doubletap", 1, 3, "int", &perk_light_doubletap, 0, 0);
	clientfield::register("world", "perk_light_quick_revive", 1, 3, "int", &perk_light_quick_revive, 0, 0);
	clientfield::register("world", "perk_light_staminup", 1, 3, "int", &perk_light_staminup, 0, 0);
	clientfield::register("world", "perk_light_juggernog", 1, 3, "int", &perk_light_juggernog, 0, 0);
	clientfield::register("world", "perk_light_mule_kick", 1, 1, "int", &perk_light_mule_kick, 0, 0);
}

/*
	Name: perk_light_speed_cola
	Namespace: zm_island_perks
	Checksum: 0xC551649F
	Offset: 0x5C8
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function perk_light_speed_cola(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level.var_7202315c = "lgt_sleight_" + newval;
		exploder::exploder(level.var_7202315c);
	}
	else if(isdefined(level.var_7202315c))
	{
		exploder::stop_exploder(level.var_7202315c);
	}
}

/*
	Name: perk_light_doubletap
	Namespace: zm_island_perks
	Checksum: 0xA140F3A3
	Offset: 0x670
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function perk_light_doubletap(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level.var_c09154cb = "lgt_doubletap_" + newval;
		exploder::exploder(level.var_c09154cb);
	}
	else if(isdefined(level.var_c09154cb))
	{
		exploder::stop_exploder(level.var_c09154cb);
	}
}

/*
	Name: perk_light_quick_revive
	Namespace: zm_island_perks
	Checksum: 0xD38C1140
	Offset: 0x718
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function perk_light_quick_revive(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level.var_2ff875ec = "lgt_revive_" + newval;
		exploder::exploder(level.var_2ff875ec);
	}
	else if(isdefined(level.var_2ff875ec))
	{
		exploder::stop_exploder(level.var_2ff875ec);
	}
}

/*
	Name: perk_light_staminup
	Namespace: zm_island_perks
	Checksum: 0xBAAF4844
	Offset: 0x7C0
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function perk_light_staminup(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level.var_d3ce4f8e = "lgt_staminup_" + newval;
		exploder::exploder(level.var_d3ce4f8e);
	}
	else if(isdefined(level.var_d3ce4f8e))
	{
		exploder::stop_exploder(level.var_d3ce4f8e);
	}
}

/*
	Name: perk_light_juggernog
	Namespace: zm_island_perks
	Checksum: 0x92CE3ED7
	Offset: 0x868
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function perk_light_juggernog(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level.var_7202315c = "lgt_jugg_" + newval;
		exploder::exploder(level.var_7202315c);
	}
	else if(isdefined(level.var_7202315c))
	{
		exploder::stop_exploder(level.var_7202315c);
	}
}

/*
	Name: perk_light_mule_kick
	Namespace: zm_island_perks
	Checksum: 0xEB8F6421
	Offset: 0x910
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function perk_light_mule_kick(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		exploder::exploder("lgt_island_vending_mulekick_on");
	}
	else
	{
		exploder::stop_exploder("lgt_island_vending_mulekick_on");
	}
}

