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
#using scripts\zm\_zm_zonemgr;

#namespace zm_genesis_ffotd;

/*
	Name: main_start
	Namespace: zm_genesis_ffotd
	Checksum: 0xBF7C2DB2
	Offset: 0x358
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function main_start()
{
	var_6674aa0f = struct::get("upper_courtyard_landing_pad12");
	var_6674aa0f.origin = var_6674aa0f.origin + vectorscale((1, 0, 0), 30);
	level.var_2d0e5eb6 = &function_8921895f;
	level.var_92a78c17 = spawn("trigger_box", (101, -6298, -625), 0, 425, 178, 520);
	level.var_92a78c17.angles = vectorscale((0, 1, 0), 317.8);
}

/*
	Name: main_end
	Namespace: zm_genesis_ffotd
	Checksum: 0x7D649F02
	Offset: 0x428
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function main_end()
{
	if(getdvarint("splitscreen_playerCount") <= 2)
	{
		spawncollision("collision_player_slick_wedge_32x256", "collider", (469.127, -6376.75, -1241), (282, 317.999, -90.001));
		spawncollision("collision_player_slick_wedge_32x256", "collider", (430.766, -6532.67, -1323), (282, 31.5004, -90.0014));
		spawncollision("collision_player_wall_128x128x10", "collider", (1518, 4436.25, 1312), vectorscale((0, 1, 0), 260.249));
	}
	level thread function_d7b99564();
}

/*
	Name: function_dce2d8a9
	Namespace: zm_genesis_ffotd
	Checksum: 0x82D8D4A
	Offset: 0x540
	Size: 0x210
	Parameters: 1
	Flags: Linked
*/
function function_dce2d8a9(str_zone)
{
	if(zm_zonemgr::any_player_in_zone(str_zone))
	{
		return true;
	}
	switch(str_zone)
	{
		case "zm_theater_zone":
		{
			foreach(player in level.activeplayers)
			{
				x = player.origin[0];
				y = player.origin[1];
				z = player.origin[2];
				if(x > -1200 && x < -1170 && (y > -8570 && y < -8540) && (z > -1710 && z < -1500))
				{
					return true;
				}
			}
			break;
		}
		case "zm_castle_power_zone":
		{
			foreach(player in level.activeplayers)
			{
				if(player istouching(level.var_92a78c17))
				{
					return true;
				}
			}
			break;
		}
	}
	return false;
}

/*
	Name: function_d51867e
	Namespace: zm_genesis_ffotd
	Checksum: 0x11154F23
	Offset: 0x758
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function function_d51867e()
{
	x = self.origin[0];
	y = self.origin[1];
	z = self.origin[2];
	if(x > -1200 && x < -1170 && (y > -8570 && y < -8540) && (z > -1710 && z < -1500))
	{
		return true;
	}
	if(self istouching(level.var_92a78c17))
	{
		return true;
	}
	return false;
}

/*
	Name: function_8921895f
	Namespace: zm_genesis_ffotd
	Checksum: 0x4D7A0ABA
	Offset: 0x838
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function function_8921895f()
{
	var_cdb0f86b = getarraykeys(level.zombie_powerups);
	var_b4442b55 = array("bonus_points_team", "shield_charge", "ww_grenade", "genesis_random_weapon");
	var_d7a75a6e = [];
	for(i = 0; i < var_cdb0f86b.size; i++)
	{
		var_77917a61 = 0;
		foreach(var_68de493a in var_b4442b55)
		{
			if(var_cdb0f86b[i] == var_68de493a)
			{
				var_77917a61 = 1;
			}
		}
		if(var_77917a61)
		{
			continue;
			continue;
		}
		var_d7a75a6e[var_d7a75a6e.size] = var_cdb0f86b[i];
	}
	var_d7a75a6e = array::randomize(var_d7a75a6e);
	return var_d7a75a6e[0];
}

/*
	Name: function_d7b99564
	Namespace: zm_genesis_ffotd
	Checksum: 0xCF32072C
	Offset: 0x9C8
	Size: 0x45C
	Parameters: 0
	Flags: Linked
*/
function function_d7b99564()
{
	var_e8eee856 = struct::spawn((5670.5, -1164, 353.5), vectorscale((0, 1, 0), 197));
	var_e8eee856.targetname = "zm_asylum_power_room_zone_spawners";
	var_e8eee856.zone_name = "zm_asylum_power_room_zone";
	var_e8eee856.script_int = 1;
	var_e8eee856.script_noteworthy = "riser_location";
	var_e8eee856.script_string = "find_flesh";
	var_e8eee856.is_enabled = 1;
	level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"] = [];
	if(!isdefined(level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"]))
	{
		level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"] = [];
	}
	else if(!isarray(level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"]))
	{
		level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"] = array(level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"]);
	}
	level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"][level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"].size] = var_e8eee856;
	var_c2ec6ded = struct::spawn((5214.43, -1441.85, 351.1));
	var_c2ec6ded.targetname = "zm_asylum_power_room_zone_spawners";
	var_c2ec6ded.zone_name = "zm_asylum_power_room_zone";
	var_c2ec6ded.script_int = 1;
	var_c2ec6ded.script_noteworthy = "riser_location";
	var_c2ec6ded.script_string = "find_flesh";
	var_c2ec6ded.is_enabled = 1;
	if(!isdefined(level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"]))
	{
		level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"] = [];
	}
	else if(!isarray(level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"]))
	{
		level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"] = array(level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"]);
	}
	level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"][level.zones["zm_asylum_power_room_zone"].a_loc_types["riser_location"].size] = var_c2ec6ded;
	level flag::wait_till("connect_asylum_kitchen_to_upstairs");
	var_e8eee856.is_enabled = 0;
	var_c2ec6ded.is_enabled = 0;
}

