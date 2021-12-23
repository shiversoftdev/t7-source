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

#namespace zm_zod_perks;

/*
	Name: init
	Namespace: zm_zod_perks
	Checksum: 0x64727547
	Offset: 0x3C0
	Size: 0x324
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level._effect["bottle_jugg"] = "zombie/fx_bottle_break_glow_jugg_zmb";
	level._effect["bottle_dtap"] = "zombie/fx_bottle_break_glow_dtap_zmb";
	level._effect["bottle_speed"] = "zombie/fx_bottle_break_glow_speed_zmb";
	clientfield::register("world", "perk_light_speed_cola", 1, 2, "int", &perk_light_speed_cola, 0, 0);
	clientfield::register("world", "perk_light_juggernog", 1, 2, "int", &perk_light_juggernog, 0, 0);
	clientfield::register("world", "perk_light_doubletap", 1, 2, "int", &perk_light_doubletap, 0, 0);
	clientfield::register("world", "perk_light_quick_revive", 1, 1, "int", &perk_light_quick_revive, 0, 0);
	clientfield::register("world", "perk_light_widows_wine", 1, 1, "int", &perk_light_widows_wine, 0, 0);
	clientfield::register("world", "perk_light_mule_kick", 1, 1, "int", &perk_light_mule_kick, 0, 0);
	clientfield::register("world", "perk_light_staminup", 1, 1, "int", &perk_light_staminup, 0, 0);
	clientfield::register("scriptmover", "perk_bottle_speed_cola_fx", 1, 1, "int", &perk_bottle_speed_cola_fx, 0, 0);
	clientfield::register("scriptmover", "perk_bottle_juggernog_fx", 1, 1, "int", &perk_bottle_juggernog_fx, 0, 0);
	clientfield::register("scriptmover", "perk_bottle_doubletap_fx", 1, 1, "int", &perk_bottle_doubletap_fx, 0, 0);
}

/*
	Name: perk_light_speed_cola
	Namespace: zm_zod_perks
	Checksum: 0x79E3829F
	Offset: 0x6F0
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function perk_light_speed_cola(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level.var_320cd7b4 = ("lgt_vending_speed_" + newval) + "_on";
		exploder::exploder(level.var_320cd7b4);
	}
	else if(isdefined(level.var_320cd7b4))
	{
		exploder::stop_exploder(level.var_320cd7b4);
	}
}

/*
	Name: perk_light_juggernog
	Namespace: zm_zod_perks
	Checksum: 0x7965421D
	Offset: 0x7A0
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function perk_light_juggernog(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level.var_d1316ad = ("lgt_vending_jugg_" + newval) + "_on";
		exploder::exploder(level.var_d1316ad);
	}
	else if(isdefined(level.var_d1316ad))
	{
		exploder::stop_exploder(level.var_d1316ad);
	}
}

/*
	Name: perk_light_doubletap
	Namespace: zm_zod_perks
	Checksum: 0x5CD4CA2A
	Offset: 0x850
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function perk_light_doubletap(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level.var_c09154cb = ("lgt_vending_tap_" + newval) + "_on";
		exploder::exploder(level.var_c09154cb);
	}
	else if(isdefined(level.var_c09154cb))
	{
		exploder::stop_exploder(level.var_c09154cb);
	}
}

/*
	Name: perk_light_quick_revive
	Namespace: zm_zod_perks
	Checksum: 0x604F0EC
	Offset: 0x900
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function perk_light_quick_revive(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		exploder::exploder("quick_revive_lgts");
	}
	else
	{
		exploder::stop_exploder("quick_revive_lgts");
	}
}

/*
	Name: perk_light_widows_wine
	Namespace: zm_zod_perks
	Checksum: 0x55512872
	Offset: 0x988
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function perk_light_widows_wine(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		exploder::exploder("lgt_vending_widows_wine_on");
	}
	else
	{
		exploder::stop_exploder("lgt_vending_widows_wine_on");
	}
}

/*
	Name: perk_light_mule_kick
	Namespace: zm_zod_perks
	Checksum: 0xC8FB8059
	Offset: 0xA10
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function perk_light_mule_kick(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		exploder::exploder("lgt_vending_mulekick_on");
	}
	else
	{
		exploder::stop_exploder("lgt_vending_mulekick_on");
	}
}

/*
	Name: perk_light_staminup
	Namespace: zm_zod_perks
	Checksum: 0x8C655F26
	Offset: 0xA98
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function perk_light_staminup(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		exploder::exploder("lgt_vending_stamina_up");
	}
	else
	{
		exploder::stop_exploder("lgt_vending_stamina_up");
	}
}

/*
	Name: perk_bottle_speed_cola_fx
	Namespace: zm_zod_perks
	Checksum: 0xDC49EEE
	Offset: 0xB20
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function perk_bottle_speed_cola_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["bottle_speed"], self, "tag_origin");
}

/*
	Name: perk_bottle_juggernog_fx
	Namespace: zm_zod_perks
	Checksum: 0xA0B7505D
	Offset: 0xB98
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function perk_bottle_juggernog_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["bottle_jugg"], self, "tag_origin");
}

/*
	Name: perk_bottle_doubletap_fx
	Namespace: zm_zod_perks
	Checksum: 0xAA0F9BB2
	Offset: 0xC10
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function perk_bottle_doubletap_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["bottle_dtap"], self, "tag_origin");
}

