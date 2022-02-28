// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;

#namespace zm_factory_ffotd;

/*
	Name: main_start
	Namespace: zm_factory_ffotd
	Checksum: 0xF9D6B859
	Offset: 0x2D8
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function main_start()
{
	level.var_42792b8b = 1;
}

/*
	Name: main_end
	Namespace: zm_factory_ffotd
	Checksum: 0xC6A0EFD2
	Offset: 0x2F0
	Size: 0x4B4
	Parameters: 0
	Flags: Linked
*/
function main_end()
{
	zm::spawn_life_brush((700, -986, 280), 128, 128);
	spawncollision("collision_clip_wall_128x128x10", "collider", (104, -2520, 328), (0, 0, 0));
	spawncollision("collision_clip_wall_512x512x10", "collider", (262, -1997, 448), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_64x64x256", "collider", (569.81, -507.91, 186.1), vectorscale((0, 1, 0), 55));
	spawncollision("collision_player_64x64x128", "collider", (-296, 29, -36), vectorscale((0, 0, 1), 90));
	spawncollision("collision_player_wall_512x512x10", "collider", (-371, 640, 237), vectorscale((0, 1, 0), 270));
	zm::spawn_kill_brush((88, -1532, 208), 48, 112);
	spawncollision("collision_player_32x32x128", "collider", (-368, -800, 128), (0, 0, 0));
	spawncollision("collision_player_32x32x128", "collider", (-368, -776, 128), (0, 0, 0));
	spawncollision("collision_player_wall_512x512x10", "collider", (-280.813, -2371.83, 408), vectorscale((0, 1, 0), 293.399));
	spawncollision("collision_player_wall_512x512x10", "collider", (1382, -780, 0), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_wall_512x512x10", "collider", (-390, 648, 240), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_wall_256x256x10", "collider", (728, -1360, 260), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_wall_256x256x10", "collider", (658, -1440, 260), vectorscale((0, 1, 0), 180));
	spawncollision("collision_player_32x32x128", "collider", (678, -1381, 196), (0, 0, 0));
	spawncollision("collision_player_32x32x128", "collider", (678, -1381, 324), (0, 0, 0));
	zm::spawn_life_brush((209, -1055, 191), 128, 128);
	zm::spawn_kill_brush((296, -2864, 0), 300, 72);
	zm::spawn_kill_brush((-384, 192, -88), 500, 32);
	spawncollision("collision_clip_ramp_128x24", "collider", (191.809, -1469.44, 46.163), (354.599, 269.943, 9.00205));
	spawncollision("collision_clip_ramp_128x24", "collider", (-492.532, 88.7538, -33.5596), (338.852, 14.7756, -36.1736));
	level thread function_1c45822c();
}

/*
	Name: function_1c45822c
	Namespace: zm_factory_ffotd
	Checksum: 0x2F3CF534
	Offset: 0x7B0
	Size: 0x148
	Parameters: 0
	Flags: Linked
*/
function function_1c45822c()
{
	level waittill(#"start_zombie_round_logic");
	var_5381c01a = struct::get_array("player_respawn_point", "targetname");
	foreach(s_respawn in var_5381c01a)
	{
		if(s_respawn.script_noteworthy === "reciever_zone")
		{
			var_e50cc92f = struct::get_array(s_respawn.target, "targetname");
			for(i = 0; i < var_e50cc92f.size; i++)
			{
				var_e50cc92f[i].script_int = i + 1;
			}
		}
	}
}

