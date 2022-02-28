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
#using scripts\zm\_zm_utility;

#namespace zm_island_ffotd;

/*
	Name: main_start
	Namespace: zm_island_ffotd
	Checksum: 0x99EC1590
	Offset: 0x2B0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function main_start()
{
}

/*
	Name: main_end
	Namespace: zm_island_ffotd
	Checksum: 0x310333F1
	Offset: 0x2C0
	Size: 0x60A
	Parameters: 0
	Flags: Linked
*/
function main_end()
{
	zm::spawn_life_brush((2870, -179, -480), 200, 360);
	zm::spawn_life_brush((-1964, 1146, 304), 128, 150);
	zm::spawn_life_brush((3070, -2257, -733), 96, 200);
	zm::spawn_life_brush((246, 3506, -424), 156, 128);
	zm::spawn_life_brush((-4573, 1301, -409), 256, 300);
	zm::spawn_life_brush((2190, 800, -213), 32, 128);
	zm::spawn_life_brush((1900, -24, -694), 196, 64);
	spawn("trigger_box", (-1100, 7740, -750), 0, 350, 200, 300) disconnectpaths();
	spawncollision("collision_monster_32x32x32", "collider", (272, 5120, -626), (0, 0, 0)) disconnectpaths();
	spawncollision("collision_monster_32x32x32", "collider", (225, 5120, -626), (0, 0, 0)) disconnectpaths();
	spawncollision("collision_player_256x256x256", "collider", (1759, 1186, -604), (0, 0, 0));
	spawncollision("collision_player_256x256x256", "collider", (1724, 1007, -599), (0, 0, 0));
	spawncollision("collision_player_64x64x64", "collider", (2202, 805, -250), (12, 45, 0));
	spawncollision("collision_player_64x64x64", "collider", (-432, 7041, -598.5), (0, 0, 0));
	spawncollision("collision_player_64x64x64", "collider", (486, 2522, -216), (0, 0, 0));
	spawncollision("collision_player_wall_128x128x10", "collider", (250, 5924, -482), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_32x32x32", "collider", (1614.5, 4558, -429), vectorscale((0, 1, 0), 10.2996));
	spawncollision("collision_player_wall_128x128x10", "collider", (-83.5, 3392.5, -335.5), (0, 0, 0));
	zm::spawn_kill_brush((-929.5, 2593, -500), 512, 64);
	zm::spawn_kill_brush((2763, -426, -608), 64, 96);
	zm::spawn_kill_brush((2877, -282, -702), 256, 32);
	spawncollision("collision_player_wall_128x128x10", "collider", (2950, 572, -640), vectorscale((0, 1, 0), 314.2));
	t_killbrush_1 = spawn("trigger_box", (2392, 596, -210), 0, 32, 512, 64);
	t_killbrush_1.angles = vectorscale((0, 1, 0), 45);
	t_killbrush_1.script_noteworthy = "kill_brush";
	if(level flag::get("solo_game"))
	{
		a_t_doors = getentarray("zombie_door", "targetname");
		foreach(t_door in a_t_doors)
		{
			if(t_door.zombie_cost >= 1000)
			{
				t_door.zombie_cost = t_door.zombie_cost - 250;
				t_door zm_utility::set_hint_string(t_door, "default_buy_door", t_door.zombie_cost);
			}
		}
	}
}

