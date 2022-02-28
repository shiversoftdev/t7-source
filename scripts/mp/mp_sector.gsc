// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_sector_fx;
#using scripts\mp\mp_sector_sound;
#using scripts\shared\_oob;
#using scripts\shared\compass;
#using scripts\shared\util_shared;

#namespace mp_sector;

/*
	Name: main
	Namespace: mp_sector
	Checksum: 0x6AFFE11
	Offset: 0x1E8
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache();
	trigger = spawn("trigger_radius_out_of_bounds", (687.5, 2679, -356.5), 0, 300, 400);
	trigger thread oob::run_oob_trigger();
	mp_sector_fx::main();
	mp_sector_sound::main();
	level.add_raps_omit_locations = &add_raps_omit_locations;
	level.add_raps_drop_locations = &add_raps_drop_locations;
	level.remotemissile_kill_z = -680;
	load::main();
	setdvar("compassmaxrange", "2100");
	compass::setupminimap("compass_map_mp_sector");
	link_traversals("under_bridge", "targetname", 1);
	spawncollision("collision_clip_wall_128x128x10", "collider", (597.185, -523.817, 584.206), (-5, 90, 0));
	level spawnkilltrigger();
	level.cleandepositpoints = array((-1.72432, 176.047, 172.125), (715.139, 1279.47, 158.417), (-825.34, 171.066, 106.517), (-108.124, -751.785, 154.839));
}

/*
	Name: link_traversals
	Namespace: mp_sector
	Checksum: 0x26F5886E
	Offset: 0x410
	Size: 0xE2
	Parameters: 3
	Flags: Linked
*/
function link_traversals(str_value, str_key, b_enable)
{
	a_nodes = getnodearray(str_value, str_key);
	foreach(node in a_nodes)
	{
		if(b_enable)
		{
			linktraversal(node);
			continue;
		}
		unlinktraversal(node);
	}
}

/*
	Name: precache
	Namespace: mp_sector
	Checksum: 0x99EC1590
	Offset: 0x500
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

/*
	Name: add_raps_omit_locations
	Namespace: mp_sector
	Checksum: 0x5B5CA6DA
	Offset: 0x510
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function add_raps_omit_locations(&omit_locations)
{
	if(!isdefined(omit_locations))
	{
		omit_locations = [];
	}
	else if(!isarray(omit_locations))
	{
		omit_locations = array(omit_locations);
	}
	omit_locations[omit_locations.size] = (32, 710, 189);
	if(!isdefined(omit_locations))
	{
		omit_locations = [];
	}
	else if(!isarray(omit_locations))
	{
		omit_locations = array(omit_locations);
	}
	omit_locations[omit_locations.size] = (-960, 1020, 168);
}

/*
	Name: add_raps_drop_locations
	Namespace: mp_sector
	Checksum: 0x41B7FAA0
	Offset: 0x5F8
	Size: 0xDA
	Parameters: 1
	Flags: Linked
*/
function add_raps_drop_locations(&drop_candidate_array)
{
	if(!isdefined(drop_candidate_array))
	{
		drop_candidate_array = [];
	}
	else if(!isarray(drop_candidate_array))
	{
		drop_candidate_array = array(drop_candidate_array);
	}
	drop_candidate_array[drop_candidate_array.size] = (-1100, 860, 145);
	if(!isdefined(drop_candidate_array))
	{
		drop_candidate_array = [];
	}
	else if(!isarray(drop_candidate_array))
	{
		drop_candidate_array = array(drop_candidate_array);
	}
	drop_candidate_array[drop_candidate_array.size] = (0, 520, 163);
}

/*
	Name: spawnkilltrigger
	Namespace: mp_sector
	Checksum: 0xB213AB6
	Offset: 0x6E0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function spawnkilltrigger()
{
	trigger = spawn("trigger_radius", (-480.116, 3217.5, 119.108), 0, 150, 200);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (-480.115, 3309.66, 119.108), 0, 150, 200);
	trigger thread watchkilltrigger();
}

/*
	Name: watchkilltrigger
	Namespace: mp_sector
	Checksum: 0x86747354
	Offset: 0x798
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function watchkilltrigger()
{
	level endon(#"game_ended");
	trigger = self;
	while(true)
	{
		trigger waittill(#"trigger", player);
		player dodamage(1000, trigger.origin + (0, 0, 0), trigger, trigger, "none", "MOD_SUICIDE", 0);
	}
}

