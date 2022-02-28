// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\zm\_zm;

#namespace zm_temple_ffotd;

/*
	Name: main_start
	Namespace: zm_temple_ffotd
	Checksum: 0xFF76F463
	Offset: 0x248
	Size: 0x13E
	Parameters: 0
	Flags: Linked
*/
function main_start()
{
	a_wallbuys = struct::get_array("weapon_upgrade", "targetname");
	foreach(s_wallbuy in a_wallbuys)
	{
		if(s_wallbuy.zombie_weapon_upgrade == "smg_standard")
		{
			s_wallbuy.origin = s_wallbuy.origin + vectorscale((0, 1, 0), 5);
		}
	}
	spawncollision("collision_bullet_wall_128x128x10", "collider", (1555, -1493, -293), vectorscale((0, 1, 0), 347.199));
	level._effect["powerup_on_red"] = "zombie/fx_powerup_on_red_zmb";
}

/*
	Name: main_end
	Namespace: zm_temple_ffotd
	Checksum: 0x4134D4A9
	Offset: 0x390
	Size: 0x46C
	Parameters: 0
	Flags: Linked
*/
function main_end()
{
	spawncollision("collision_clip_ramp_256x24", "collider", (-51.9, -1049.64, -253.5), (90, 10.25, 75.85));
	spawncollision("collision_clip_ramp_256x24", "collider", (-51.9, -1049.64, 2.5), (90, 10.25, 75.85));
	spawncollision("collision_clip_ramp_256x24", "collider", (-51.9, -1049.64, 258.5), (90, 10.25, 75.85));
	spawncollision("collision_clip_wedge_32x256", "collider", (44, -1020, -240), vectorscale((0, 1, 0), 180));
	spawncollision("collision_clip_wedge_32x256", "collider", (44, -1020, 16), vectorscale((0, 1, 0), 180));
	spawncollision("collision_clip_wedge_32x256", "collider", (44, -1020, 272), vectorscale((0, 1, 0), 180));
	spawncollision("collision_player_slick_32x32x128", "collider", (51.9385, -1035.86, -16.28), (316.299, 351.698, -90));
	spawncollision("collision_monster_128x128x128", "collider", (93.3531, -1041.94, 46), vectorscale((0, 1, 0), 351.397));
	spawncollision("collision_player_wall_512x512x10", "collider", (-1000, -1392, 122), vectorscale((1, 0, 0), 270));
	spawncollision("collision_player_wall_512x512x10", "collider", (-1112, -1560, 122), vectorscale((1, 0, 0), 270));
	spawncollision("collision_player_wall_512x512x10", "collider", (-1125.08, -859.956, -328), (270, 0.2, 21.5992));
	spawncollision("collision_player_wall_256x256x10", "collider", (-1048.47, -1100.99, -205.044), (6.5924E-06, 291.799, 90));
	spawncollision("collision_player_slick_wall_256x256x10", "collider", (1009.23, -1052.8, 1.965), (4.49303, 183.106, 0.243273));
	spawncollision("collision_player_slick_wedge_32x128", "collider", (-1655.5, -428, 8), vectorscale((1, 1, 0), 270));
	spawncollision("collision_player_slick_wall_128x128x10", "collider", (546.5, -499.5, -347), vectorscale((0, 1, 0), 3.79971));
	spawncollision("collision_player_slick_wall_128x128x10", "collider", (541, -439.5, -347), vectorscale((0, 1, 0), 6.299));
}

