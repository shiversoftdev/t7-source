// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace zm_castle_fx;

/*
	Name: precache_util_fx
	Namespace: zm_castle_fx
	Checksum: 0x99EC1590
	Offset: 0x1F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache_util_fx()
{
}

/*
	Name: main
	Namespace: zm_castle_fx
	Checksum: 0x24FEC0E7
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
}

/*
	Name: precache_scripted_fx
	Namespace: zm_castle_fx
	Checksum: 0xF9CDE396
	Offset: 0x240
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["zapper"] = "dlc1/castle/fx_elec_trap_castle";
	level._effect["rocket_warning_smoke"] = "smoke/fx_smk_ambient_cieling_newworld";
	level._effect["rocket_warning_fire"] = "explosions/fx_exp_vtol_crash_trail_prologue";
	level._effect["rocket_side_blast"] = "fire/fx_fire_side_lrg";
	level._effect["death_ray_shock_eyes"] = "zombie/fx_tesla_shock_eyes_zmb";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_castle_fx
	Checksum: 0x99EC1590
	Offset: 0x2D8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
}

