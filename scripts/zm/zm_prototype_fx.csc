// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace zm_prototype_fx;

/*
	Name: main
	Namespace: zm_prototype_fx
	Checksum: 0x6922E1CB
	Offset: 0x398
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function main()
{
	disablefx = getdvarint("disable_fx");
	if(!isdefined(disablefx) || disablefx <= 0)
	{
		precache_scripted_fx();
	}
}

/*
	Name: precache_scripted_fx
	Namespace: zm_prototype_fx
	Checksum: 0x2DE1DD6
	Offset: 0x3F8
	Size: 0x17E
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["zombie_grain"] = "misc/fx_zombie_grain_cloud";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level.breakables_fx["barrel"]["explode"] = "explosions/fx_exp_dest_barrel_sm";
	level.breakables_fx["barrel"]["burn_start"] = "dlc5/prototype/fx_barrel_ignite";
	level._effect["perk_machine_light_yellow"] = "dlc5/zmhd/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc5/zmhd/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc5/zmhd/fx_wonder_fizz_light_green";
	level._effect["perk_machine_location"] = "dlc5/prototype/fx_wonder_fizz_lightning_all_interior";
}

/*
	Name: scriptedfx
	Namespace: zm_prototype_fx
	Checksum: 0xD52B60D1
	Offset: 0x580
	Size: 0x56
	Parameters: 0
	Flags: None
*/
function scriptedfx()
{
	level._effect["large_ceiling_dust"] = "dlc5/zmhd/fx_dust_ceiling_impact_lg_mdbrown";
	level._effect["poltergeist"] = "dlc5/zmhd/fx_zombie_couch_effect";
	level._effect["nuke_dust"] = "maps/zombie/fx_zombie_body_nuke_dust";
}

