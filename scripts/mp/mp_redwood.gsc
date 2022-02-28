// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_ball_utils;
#using scripts\mp\mp_redwood_fx;
#using scripts\mp\mp_redwood_sound;
#using scripts\shared\_oob;
#using scripts\shared\compass;
#using scripts\shared\util_shared;

#namespace mp_redwood;

/*
	Name: main
	Namespace: mp_redwood
	Checksum: 0x7A848F9F
	Offset: 0x240
	Size: 0x314
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache();
	level.uav_z_offset = 500;
	level.uav_rotation_radius = 1000;
	level.uav_rotation_random_offset = 1000;
	level.counter_uav_position_z_offset = 0;
	level.cuav_map_x_percentage = 0.25;
	level.heli_visual_range_override = 10000;
	level.raps_hurt_trigger_immune_duration_ms = 10000;
	level.escort_drop_speed = 7000;
	level.escort_drop_accel = 5000;
	level.escort_drop_height = 3000;
	trigger = spawn("trigger_radius_out_of_bounds", (-1499, -293.5, -139.5), 0, 500, 128);
	trigger thread oob::run_oob_trigger();
	trigger = spawn("trigger_radius_out_of_bounds", (1010.5, -738, -276), 0, 600, 300);
	trigger thread oob::run_oob_trigger();
	trigger = spawn("trigger_radius_out_of_bounds", (-1449, 234, -302), 0, 256, 300);
	trigger thread oob::run_oob_trigger();
	mp_redwood_fx::main();
	mp_redwood_sound::main();
	load::main();
	compass::setupminimap("compass_map_mp_redwood");
	setdvar("compassmaxrange", "2100");
	tree1 = spawn("script_model", (-1480, 692.274, 264.392));
	tree1.angles = (360, 296, 90);
	tree1 setmodel("p7_usa_bunker_roof_vent");
	level.cleandepositpoints = array((-448.776, -210.531, 45.5891), (1928.72, 191.469, 270.089), (570.724, -732.031, 165.589), (-1356.28, 58.969, 63.0891), (-955.276, -1142.53, 156.089));
	level spawnkilltrigger();
	function_9f6a9d3f();
}

/*
	Name: precache
	Namespace: mp_redwood
	Checksum: 0x99EC1590
	Offset: 0x560
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

/*
	Name: spawnkilltrigger
	Namespace: mp_redwood
	Checksum: 0x8187CF12
	Offset: 0x570
	Size: 0x2D4
	Parameters: 0
	Flags: Linked
*/
function spawnkilltrigger()
{
	trigger = spawn("trigger_radius", (2772.36, -2224.02, -77.52), 0, 500, 300);
	trigger thread watchkilltrigger();
	ball::add_ball_return_trigger(trigger);
	trigger = spawn("trigger_radius", (-1861.1, 1546.53, -106.53), 0, 175, 300);
	trigger thread watchkilltrigger();
	ball::add_ball_return_trigger(trigger);
	trigger = spawn("trigger_radius", (-1872, 568, -440), 0, 128, 416);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (-2080, 600, -440), 0, 128, 672);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (-2232, 440, -440), 0, 128, 900);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (-2352, 248, -440), 0, 128, 1120);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (-2128, 200, -440), 0, 128, 800);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (-1928, 200, -440), 0, 128, 540);
	trigger thread watchkilltrigger();
	trigger = spawn("trigger_radius", (-1768, 312, -440), 0, 128, 192);
	trigger thread watchkilltrigger();
}

/*
	Name: watchkilltrigger
	Namespace: mp_redwood
	Checksum: 0x3749D84C
	Offset: 0x850
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

/*
	Name: function_9f6a9d3f
	Namespace: mp_redwood
	Checksum: 0x163A8E35
	Offset: 0x8E8
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function function_9f6a9d3f()
{
	if(level.gametype == "prop")
	{
		spawncollision("collision_player_32x32x32", "collider", (-762, -336, 42), vectorscale((0, 1, 0), 40));
		spawncollision("collision_player_32x32x32", "collider", (-804, -282, 60), vectorscale((0, 1, 0), 80));
		spawncollision("collision_player_ramp_64x24", "collider", (294.068, -2630.52, 183), vectorscale((0, 1, 0), 284.999));
		spawncollision("collision_player_ramp_64x24", "collider", (260.932, -2639.48, 183), vectorscale((0, 1, 0), 104.998));
		spawncollision("collision_player_32x32x32", "collider", (-258.5, -1049, 140), vectorscale((0, 1, 0), 37.4985));
		spawncollision("collision_player_32x32x32", "collider", (-241.5, -1022.5, 132), vectorscale((0, 1, 0), 37.4985));
		spawncollision("collision_player_32x32x32", "collider", (887.5, -3096.5, 215.5), vectorscale((0, 1, 0), 327.198));
		spawncollision("collision_player_32x32x32", "collider", (411.5, -3072.5, 205.5), vectorscale((0, 1, 0), 12.8));
	}
}

