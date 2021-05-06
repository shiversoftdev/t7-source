// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_enemy;
#using scripts\cp\doa\_doa_enemy_boss;
#using scripts\cp\doa\_doa_fate;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_hazard;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_challenge_room;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\cp\doa\_doa_round;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_sfx;
#using scripts\cp\doa\_doa_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace namespace_3ca3c537;

/*
	Name: function_a55a134f
	Namespace: namespace_3ca3c537
	Checksum: 0x4C598588
	Offset: 0x818
	Size: 0x1FC
	Parameters: 0
	Flags: Linked, Private
*/
private function function_a55a134f()
{
	arenas = struct::get_array("arena_center");
	for(i = 0; i < arenas.size; i++)
	{
		if(isdefined(arenas[i].var_e121d9e4) && arenas[i].var_e121d9e4 || (isdefined(arenas[i].script_parameters) && issubstr(arenas[i].script_parameters, "player_challenge")))
		{
			level.doa.var_3c04d3df[level.doa.var_3c04d3df.size] = arenas[i];
			arenas[i].script_parameters = "99999";
			arenas[i].var_e121d9e4 = 1;
		}
	}
	unsorted = arenas;
	for(i = 1; i < unsorted.size; i++)
	{
		for(j = i; j > 0 && int(unsorted[j - 1].script_parameters) > int(unsorted[j].script_parameters); j--)
		{
			array::swap(unsorted, j, j - 1);
		}
	}
	return unsorted;
}

/*
	Name: init
	Namespace: namespace_3ca3c537
	Checksum: 0xF565B438
	Offset: 0xA20
	Size: 0x42C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	/#
		assert(isdefined(level.doa));
	#/
	level.doa.arenas = [];
	level.doa.var_3c04d3df = [];
	arenas = function_a55a134f();
	for(i = 0; i < arenas.size; i++)
	{
		arenas[i] function_b7dafa0c(arenas[i].script_noteworthy, arenas[i].origin, arenas[i].script_parameters == "99999");
	}
	level.doa.current_arena = 0;
	level.doa.var_ec2bff7b = [];
	function_abd3b624("vault", 5, 2, &"DOA_VAULT", undefined, "vault");
	function_abd3b624("coop", 9, 3, &"DOA_FARM", undefined, "coop");
	function_abd3b624("armory", 13, 1, &"DOA_ARMORY", undefined, "armory");
	function_abd3b624("mystic_armory", 13, 7, &"DOA_MYSTICAL_ARMORY", undefined, "alien_armory");
	function_abd3b624("wolfhole", 17, 6, &"DOA_WOLFHOLE", undefined, "wolfhole");
	function_abd3b624("bomb_storage", 21, 8, &"DOA_BOMB_STORAGE", undefined, "bomb_storage");
	function_abd3b624("hangar", 21, 5, &"DOA_HANGAR", undefined, "hangar");
	function_abd3b624("mine", 28, 4, &"DOA_MINE", undefined, "cave");
	function_abd3b624("righteous", 36, 10, &"DOA_RIGHTEOUS_ROOM", 36, "temple", undefined, 2);
	foreach(var_1c6d03e, arena in level.doa.var_3c04d3df)
	{
		function_abd3b624(arena.script_noteworthy, 999, 13, istring("DOA_" + toupper(arena.script_noteworthy) + "_ROOM"), 999, arena.script_noteworthy, 120);
	}
	level.spawn_start["allies"][0] = level.doa.arenas[0];
	level.spawn_start["axis"][0] = level.doa.arenas[0];
	level thread doa_utility::set_lighting_state(0);
}

/*
	Name: function_abd3b624
	Namespace: namespace_3ca3c537
	Checksum: 0xF0A5D45C
	Offset: 0xE58
	Size: 0x26C
	Parameters: 8
	Flags: Linked, Private
*/
private function function_abd3b624(name, var_5281efe5, type, text, var_cbad0e8f, var_c9a1f25a, var_c92c30d9, var_6f369ab4)
{
	room = spawnstruct();
	room.name = name;
	room.var_5281efe5 = var_5281efe5;
	room.type = type;
	room.text = text;
	room.timeout = var_c92c30d9;
	room.var_cbad0e8f = var_cbad0e8f;
	room.location = var_c9a1f25a;
	room.var_6f369ab4 = (isdefined(var_6f369ab4) ? var_6f369ab4 : 999);
	room.var_57ce7582 = [];
	room.cooloff = 0;
	if(type == 13)
	{
		if(isdefined(level.doa.var_cefa8799))
		{
			level thread [[level.doa.var_cefa8799]](room);
		}
	}
	level.doa.var_ec2bff7b[level.doa.var_ec2bff7b.size] = room;
	location = (isdefined(var_c9a1f25a) ? var_c9a1f25a : name);
	room.player_spawn_points = struct::get_array(location + "_player_spawnpoint");
	if(type != 13)
	{
		if(!room.player_spawn_points.size && getdvarint("scr_doa_report_missing_struct", 0))
		{
			doa_utility::debugmsg("MISSING _player_spawnpoint: for arena: " + name);
		}
		assert(room.player_spawn_points.size);
	}
}

/*
	Name: function_8b90b6a7
	Namespace: namespace_3ca3c537
	Checksum: 0x59C952EB
	Offset: 0x10D0
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function function_8b90b6a7()
{
	foreach(var_6e8612, room in level.doa.var_ec2bff7b)
	{
		if(room.type == 10)
		{
			continue;
		}
		if(room.type == 9)
		{
			continue;
		}
		if(room.type == 13)
		{
			continue;
		}
		if(room.var_5281efe5 == 999)
		{
			continue;
		}
		room.var_57ce7582 = [];
	}
	if(isdefined(level.doa.var_771e3915))
	{
		level thread [[level.doa.var_771e3915]]();
	}
}

/*
	Name: function_63bc3226
	Namespace: namespace_3ca3c537
	Checksum: 0x69AACFC0
	Offset: 0x1200
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function function_63bc3226(type, var_436ba068)
{
	temp = doa_utility::function_4e9a23a9(level.doa.var_ec2bff7b);
	foreach(var_bce6eaf5, room in level.doa.var_ec2bff7b)
	{
		if(isdefined(var_436ba068))
		{
			if(room.name != var_436ba068)
			{
				continue;
			}
		}
		if(room.type == type)
		{
			return room;
		}
	}
}

/*
	Name: function_46b3be09
	Namespace: namespace_3ca3c537
	Checksum: 0xB3D96C9E
	Offset: 0x1308
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function function_46b3be09()
{
	foreach(var_724b9744, room in level.doa.var_ec2bff7b)
	{
		if(room.type == 13)
		{
			continue;
		}
		if(level.doa.round_number < room.var_5281efe5)
		{
			continue;
		}
		if(isdefined(room.var_5185e411) && !level [[room.var_5185e411]](room))
		{
			continue;
		}
		var_6f369ab4 = (isdefined(room.var_6f369ab4) ? room.var_6f369ab4 : 1);
		if(isdefined(room.var_cbad0e8f) && room.var_57ce7582.size < var_6f369ab4 && level.doa.round_number >= room.var_cbad0e8f)
		{
			level.doa.forced_magical_room = room.type;
			level.doa.var_94073ca5 = room.name;
			return;
		}
	}
}

/*
	Name: function_6b351e04
	Namespace: namespace_3ca3c537
	Checksum: 0x2B745C96
	Offset: 0x14D0
	Size: 0x3C2
	Parameters: 2
	Flags: Linked, Private
*/
private function function_6b351e04(type = 0, var_436ba068)
{
	temp = doa_utility::function_4e9a23a9(level.doa.var_ec2bff7b);
	if(type != 0)
	{
		var_c50a98cb = function_63bc3226(type, var_436ba068);
	}
	if(!isdefined(var_c50a98cb))
	{
		foreach(var_b1335bae, room in temp)
		{
			if(room.type == 13)
			{
				continue;
			}
			if(room.var_5281efe5 == 999)
			{
				continue;
			}
			if(room.var_6f369ab4 != 999 && room.var_57ce7582.size >= room.var_6f369ab4)
			{
				continue;
			}
			if(isdefined(room.var_5185e411) && !level [[room.var_5185e411]](room))
			{
				continue;
			}
			if(gettime() < room.cooloff)
			{
				continue;
			}
			if(isdefined(room.var_cbad0e8f) && level.doa.round_number >= room.var_cbad0e8f)
			{
				if(room.var_57ce7582.size == 0)
				{
					var_c50a98cb = room;
					break;
				}
				continue;
			}
		}
	}
	if(!isdefined(var_c50a98cb))
	{
		foreach(var_a6cf6d36, room in temp)
		{
			if(room.type == 13)
			{
				continue;
			}
			if(room.var_5281efe5 == 999)
			{
				continue;
			}
			if(room.var_6f369ab4 != 999 && room.var_57ce7582.size >= room.var_6f369ab4)
			{
				continue;
			}
			if(level.doa.round_number < room.var_5281efe5)
			{
				continue;
			}
			if(gettime() < room.cooloff)
			{
				continue;
			}
			if(isdefined(room.var_5185e411) && !level [[room.var_5185e411]](room))
			{
				continue;
			}
			var_c50a98cb = room;
			break;
		}
	}
	if(isdefined(var_c50a98cb))
	{
		var_c50a98cb.var_57ce7582[var_c50a98cb.var_57ce7582.size] = level.doa.round_number;
	}
	return var_c50a98cb;
}

/*
	Name: function_85c94f67
	Namespace: namespace_3ca3c537
	Checksum: 0xA025189
	Offset: 0x18A0
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function function_85c94f67(room)
{
	return room.type == 2 || room.type == 4;
}

/*
	Name: function_35f13fc4
	Namespace: namespace_3ca3c537
	Checksum: 0x180B68D0
	Offset: 0x18E0
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function function_35f13fc4(room)
{
	return room.type == 9 || room.type == 10;
}

/*
	Name: function_b9e4794c
	Namespace: namespace_3ca3c537
	Checksum: 0x40E1BC0A
	Offset: 0x1920
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function function_b9e4794c(room)
{
	return room.type == 13;
}

/*
	Name: function_e88371e5
	Namespace: namespace_3ca3c537
	Checksum: 0x134F4E28
	Offset: 0x1948
	Size: 0x16A
	Parameters: 0
	Flags: Linked
*/
function function_e88371e5()
{
	loots = function_d2d75f5d() + "_loot";
	points = struct::get_array(loots);
	foreach(var_2b6d0244, loot in points)
	{
		if(isdefined(loot.script_noteworthy))
		{
			doa_pickups::function_3238133b(loot.script_noteworthy, loot.origin, 1, 0, 1, 0, loot.angles);
			continue;
		}
		if(isdefined(loot.model))
		{
			doa_pickups::function_3238133b(loot.model, loot.origin, 1, 0, 1, 0, loot.angles);
		}
	}
}

/*
	Name: function_1c54aa82
	Namespace: namespace_3ca3c537
	Checksum: 0x2F1E4221
	Offset: 0x1AC0
	Size: 0xD70
	Parameters: 1
	Flags: Linked, Private
*/
private function function_1c54aa82(room)
{
	level.doa.var_677d1262 = 0;
	players = namespace_831a4a7c::function_5eb6e4d1();
	playercount = players.size;
	level.doa.lastarena = level.doa.current_arena;
	level thread doa_utility::clearallcorpses();
	level thread doa_pickups::function_c1869ec8();
	level clientfield::increment("cleanUpGibs");
	level waittill(#"hash_229914a6");
	if(isdefined(room.location))
	{
		function_5af67667(function_5835533a(room.location), 1);
	}
	points = struct::get_array(function_d2d75f5d() + "_player_spawnpoint");
	if(isdefined(points) && points.size)
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(players[i]))
			{
				if(isdefined(points[i]))
				{
					origin = points[i].origin;
				}
				else
				{
					origin = points[0].origin;
				}
				players[i] namespace_cdb9a8fe::function_fe0946ac(origin);
			}
		}
	}
	namespace_831a4a7c::function_82e3b1cb(1);
	room.cooloff = gettime() + 10 * 60000;
	level.doa.var_6f2c52d8 = 1;
	level thread doa_utility::set_lighting_state(0);
	level thread function_e88371e5();
	switch(room.type)
	{
		case 2:
		{
			flag::set("doa_bonusroom_active");
			function_8274c029();
			var_4833a640 = 1;
			level thread doa_pickups::spawnmoneyglob(0, 15, 0.1);
			level thread doa_pickups::function_3238133b(level.doa.booster_model, undefined, 2);
			level thread doa_pickups::function_3238133b(level.doa.var_501f85b4, undefined, 1);
			break;
		}
		case 1:
		{
			flag::set("doa_bonusroom_active");
			function_8274c029();
			var_4833a640 = 1;
			level thread doa_pickups::spawnmoneyglob(0, 2, randomfloatrange(2, 4));
			level thread doa_pickups::function_3238133b(level.doa.booster_model, undefined, 2);
			level thread doa_pickups::function_3238133b(level.doa.var_501f85b4, undefined, 1);
			break;
		}
		case 3:
		{
			flag::set("doa_bonusroom_active");
			level thread doa_pickups::spawnmoneyglob(0, 2, randomfloatrange(2, 4));
			level thread doa_pickups::function_3238133b(level.doa.var_8d63e734, undefined, 1);
			level thread doa_pickups::function_3238133b(level.doa.booster_model, undefined, 2);
			level thread doa_pickups::function_3238133b(level.doa.var_501f85b4, undefined, 1);
			spot = doa_pickups::function_ac410a13();
			if(isdefined(spot))
			{
				level doa_pickups::function_3238133b(level.doa.var_43922ff2, spot.origin + (randomfloatrange(-30, 30), randomfloatrange(-30, 30), 0), 7);
				room.cooloff = gettime() + 30 * 60000;
			}
			if(randomint(100) < 5)
			{
				level doa_pickups::function_3238133b(level.doa.var_468af4f0, spot.origin + (randomfloatrange(-30, 30), randomfloatrange(-30, 30), 0), 1 + randomintrange(0, 2));
			}
			break;
		}
		case 4:
		{
			flag::set("doa_bonusroom_active");
			level thread doa_pickups::spawnmoneyglob(1, 5, 0.1);
			level thread doa_pickups::spawnmoneyglob(0, 2, randomfloatrange(2, 4));
			level thread doa_pickups::function_3238133b(level.doa.booster_model, undefined, 2);
			level thread doa_pickups::function_3238133b(level.doa.var_501f85b4, undefined, 1);
			room.cooloff = gettime() + 30 * 60000;
			break;
		}
		case 6:
		{
			flag::set("doa_bonusroom_active");
			foreach(var_e4279757, player in getplayers())
			{
				player notify(#"hash_d28ba89d");
			}
			level thread doa_pickups::spawnmoneyglob(0, 2, randomfloatrange(2, 4));
			level doa_pickups::function_3238133b(level.doa.var_f6947407, undefined, 2);
			level doa_pickups::function_3238133b(level.doa.var_97bbae9c, undefined, 4);
			level doa_pickups::function_3238133b(level.doa.var_f6e22ab8, undefined, 3);
			level thread doa_pickups::function_3238133b(level.doa.booster_model, undefined, 2);
			level thread doa_pickups::function_3238133b(level.doa.var_501f85b4, undefined, 1);
			break;
		}
		case 5:
		{
			flag::set("doa_bonusroom_active");
			function_8274c029();
			var_4833a640 = 1;
			level.doa.var_a3a11449 = 1;
			level thread doa_pickups::spawnmoneyglob(0, 2, randomfloatrange(2, 4));
			level thread doa_pickups::function_3238133b(level.doa.booster_model, undefined, 2);
			level thread doa_pickups::function_3238133b(level.doa.var_501f85b4, undefined, 1);
			break;
		}
		case 7:
		{
			flag::set("doa_bonusroom_active");
			function_8274c029();
			var_4833a640 = 1;
			level thread doa_pickups::spawnmoneyglob(0, 2, randomfloatrange(2, 4));
			level thread doa_pickups::function_3238133b(level.doa.booster_model, undefined, 2);
			level thread doa_pickups::function_3238133b(level.doa.var_501f85b4, undefined, 1);
			break;
		}
		case 8:
		{
			flag::set("doa_bonusroom_active");
			function_8274c029();
			var_4833a640 = 1;
			level thread doa_pickups::spawnmoneyglob(0, 2, randomfloatrange(2, 4));
			level thread doa_pickups::function_3238133b(level.doa.booster_model, undefined, 2);
			break;
		}
		case 10:
		{
			room.var_5281efe5 = room.var_5281efe5 + 64;
			room.var_cbad0e8f = room.var_cbad0e8f + 64;
			function_ba9c838e();
			level.doa.var_6f2c52d8 = undefined;
			doa_fate::function_833dad0d();
			break;
		}
		case 13:
		{
			function_ba9c838e();
			level.doa.var_6f2c52d8 = undefined;
			namespace_74ae326f::function_15a0c9b5(room);
			break;
		}
	}
	if(!(isdefined(var_4833a640) && var_4833a640))
	{
		function_ba9c838e();
	}
	if(!function_35f13fc4(room) && !function_b9e4794c(room))
	{
		doa_utility::function_390adefe();
		level thread doa_utility::function_c5f3ece8(&"DOA_BONUS_ROOM", undefined, 6);
		if(mayspawnentity())
		{
			level.voice playsound("vox_doaa_bonus_room");
		}
		wait(1);
		level thread doa_utility::function_37fb5c23(room.text);
		wait(6);
		function_f64e4b70("all");
	}
	flag::clear("doa_bonusroom_active");
	function_5af67667(level.doa.lastarena, 1);
	return 1;
}

/*
	Name: function_b0e9983
	Namespace: namespace_3ca3c537
	Checksum: 0xFC08676F
	Offset: 0x2838
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function function_b0e9983(name)
{
	count = 28;
	switch(name)
	{
		case "farm":
		{
			count = 33;
			break;
		}
		case "graveyard":
		{
			count = 33;
			break;
		}
		case "temple":
		{
			count = 23;
			break;
		}
		case "safehouse":
		{
			count = 20;
			break;
		}
		case "vengeance":
		{
			count = 18;
			break;
		}
		case "sgen":
		{
			count = 38;
			break;
		}
		case "metro":
		{
			count = 40;
			break;
		}
		case "sector":
		{
			count = 24;
			break;
		}
		case "newworld":
		{
			count = 38;
			break;
		}
	}
	count = count + level.doa.var_da96f13c * 4;
	if(getplayers().size > 1)
	{
		count = count - int(getplayers().size * 1.5);
	}
	count = math::clamp(count, 0, 40);
	return count;
}

/*
	Name: function_9b67513c
	Namespace: namespace_3ca3c537
	Checksum: 0x7DC3981A
	Offset: 0x29D0
	Size: 0x10A
	Parameters: 1
	Flags: Linked, Private
*/
private function function_9b67513c(name)
{
	switch(name)
	{
		case "island":
		{
			return 1;
		}
		case "dock":
		{
			return 2;
		}
		case "farm":
		{
			return 3;
		}
		case "graveyard":
		{
			return 4;
		}
		case "temple":
		{
			return 5;
		}
		case "safehouse":
		{
			return 6;
		}
		case "blood":
		{
			return 7;
		}
		case "cave":
		{
			return 8;
		}
		case "vengeance":
		{
			return 9;
		}
		case "sgen":
		{
			return 10;
		}
		case "apartments":
		{
			return 11;
		}
		case "sector":
		{
			return 12;
		}
		case "metro":
		{
			return 13;
		}
		case "clearing":
		{
			return 14;
		}
		case "newworld":
		{
			return 15;
		}
		case "boss":
		{
			return 16;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: function_b7dafa0c
	Namespace: namespace_3ca3c537
	Checksum: 0xA8B851CC
	Offset: 0x2AE8
	Size: 0x942
	Parameters: 3
	Flags: Linked, Private
*/
private function function_b7dafa0c(name, center, valid)
{
	struct = spawnstruct();
	struct.name = name;
	struct.center = center;
	struct.origin = center;
	struct.angles = (0, 0, 0);
	struct.var_160ae6c6 = function_9b67513c(name);
	struct.exits = getentarray(name + "_doa_exit", "targetname");
	struct.var_63b4dab3 = valid;
	struct.safezone = getent(name + "_safezone", "targetname");
	struct.var_2ac7f133 = vectorscale((0, 0, 1), 2000) + center;
	struct.var_5a97f5e9 = vectorscale((0, 0, 1), 2000) + center;
	struct.entity = self;
	struct.var_fe390b01 = struct::get_array(name + "_flyer_spawn_loc", "targetname");
	struct.var_1d2ed40 = struct::get_array(name + "_safe_spot", "targetname");
	struct.var_f616a3b7 = [];
	struct.var_f616a3b7["top"] = [];
	struct.var_f616a3b7["bottom"] = [];
	struct.var_f616a3b7["left"] = [];
	struct.var_f616a3b7["right"] = [];
	struct.player_spawn_points = struct::get_array(name + "_player_spawnpoint");
	struct.var_f616a3b7["top"] = struct::get_array(name + "_exit_start_top");
	struct.var_f616a3b7["bottom"] = struct::get_array(name + "_exit_start_bottom");
	struct.var_f616a3b7["left"] = struct::get_array(name + "_exit_start_left");
	struct.var_f616a3b7["right"] = struct::get_array(name + "_exit_start_right");
	/#
		if(isdefined(struct.var_160ae6c6))
		{
			if(!struct.var_f616a3b7[""].size && getdvarint("", 0))
			{
				doa_utility::debugmsg("" + name);
			}
			assert(struct.var_f616a3b7[""].size);
			if(!struct.var_f616a3b7[""].size && getdvarint("", 0))
			{
				doa_utility::debugmsg("" + name);
			}
			assert(struct.var_f616a3b7[""].size);
			if(!struct.var_f616a3b7[""].size && getdvarint("", 0))
			{
				doa_utility::debugmsg("" + name);
			}
			assert(struct.var_f616a3b7[""].size);
			if(!struct.var_f616a3b7[""].size && getdvarint("", 0))
			{
				doa_utility::debugmsg("" + name);
			}
			assert(struct.var_f616a3b7[""].size);
			if(!struct.player_spawn_points.size && getdvarint("", 0))
			{
				doa_utility::debugmsg("" + name);
			}
			assert(struct.player_spawn_points.size);
		}
	#/
	var_5fabae4f = struct::get(name + "_camera_fixed_point");
	if(isdefined(var_5fabae4f) && isdefined(var_5fabae4f.script_parameters))
	{
		campos = strtok(var_5fabae4f.script_parameters, " ");
		/#
			assert(isdefined(campos.size == 3), "" + name + "");
		#/
		struct.var_2ac7f133 = (float(campos[0]), float(campos[1]), float(campos[2])) + center;
	}
	var_5fabae4f = struct::get(name + "_camera_fixed_point_flip");
	if(isdefined(var_5fabae4f) && isdefined(var_5fabae4f.script_parameters))
	{
		campos = strtok(var_5fabae4f.script_parameters, " ");
		/#
			assert(isdefined(campos.size == 3), "" + name + "");
		#/
		struct.var_5a97f5e9 = (float(campos[0]), float(campos[1]), float(campos[2])) + center;
	}
	/#
		assert(isdefined(struct.safezone), "" + name + "");
	#/
	for(i = 0; i < struct.exits.size; i++)
	{
		struct.exits[i] triggerenable(0);
	}
	namespace_cdb9a8fe::function_c81e1083(name);
	if(isdefined(level.doa.var_62423327))
	{
		[[level.doa.var_62423327]](struct);
	}
	level.doa.arenas[level.doa.arenas.size] = struct;
}

/*
	Name: function_5295ea97
	Namespace: namespace_3ca3c537
	Checksum: 0x9B3E9ADD
	Offset: 0x3438
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function function_5295ea97()
{
	return level.doa.arenas[level.doa.current_arena].var_160ae6c6;
}

/*
	Name: function_dc34896f
	Namespace: namespace_3ca3c537
	Checksum: 0x258A26E9
	Offset: 0x3470
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function function_dc34896f()
{
	return level.doa.arenas[level.doa.current_arena].safezone;
}

/*
	Name: function_61d60e0b
	Namespace: namespace_3ca3c537
	Checksum: 0xD6C726C4
	Offset: 0x34A8
	Size: 0x12A
	Parameters: 0
	Flags: Linked
*/
function function_61d60e0b()
{
	if(isdefined(level.doa.arenas))
	{
		return level.doa.arenas[level.doa.current_arena].center;
	}
	var_520dc677 = function_d2d75f5d();
	arenas = struct::get_array("arena_center");
	foreach(var_5a277a41, arena in arenas)
	{
		if(arena.script_noteworthy == var_520dc677)
		{
			return arena.origin;
		}
	}
	return (0, 0, 0);
}

/*
	Name: function_d2d75f5d
	Namespace: namespace_3ca3c537
	Checksum: 0x2ECCCC96
	Offset: 0x35E0
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_d2d75f5d()
{
	if(isdefined(level.doa.arenas))
	{
		return level.doa.arenas[level.doa.current_arena].name;
	}
	return "island";
}

/*
	Name: function_5835533a
	Namespace: namespace_3ca3c537
	Checksum: 0x19C108D8
	Offset: 0x3638
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function function_5835533a(name)
{
	for(i = 0; i < level.doa.arenas.size; i++)
	{
		if(level.doa.arenas[i].name == name)
		{
			return i;
		}
	}
}

/*
	Name: function_5147636f
	Namespace: namespace_3ca3c537
	Checksum: 0x205C40A0
	Offset: 0x36B0
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function function_5147636f()
{
	if(level.doa.flipped)
	{
		return level.doa.arenas[level.doa.current_arena].var_5a97f5e9;
	}
	return level.doa.arenas[level.doa.current_arena].var_2ac7f133;
}

/*
	Name: function_a8f91d6f
	Namespace: namespace_3ca3c537
	Checksum: 0x27F58862
	Offset: 0x3730
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function function_a8f91d6f()
{
	return level.doa.arenas[level.doa.current_arena].exits;
}

/*
	Name: function_ba9c838e
	Namespace: namespace_3ca3c537
	Checksum: 0x51F5039F
	Offset: 0x3768
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_ba9c838e(var_c56d15c4 = 0)
{
	level.doa.flipped = 0;
	level clientfield::set("flipCamera", (var_c56d15c4 == 0 ? 1 : 0));
	settopdowncamerayaw(0);
}

/*
	Name: function_8274c029
	Namespace: namespace_3ca3c537
	Checksum: 0x2B6528BC
	Offset: 0x37F0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_8274c029()
{
	level.doa.flipped = 1;
	level clientfield::set("flipCamera", 2);
	settopdowncamerayaw(180);
}

/*
	Name: function_78c7b56e
	Namespace: namespace_3ca3c537
	Checksum: 0xA0671406
	Offset: 0x3850
	Size: 0x410
	Parameters: 1
	Flags: Linked
*/
function function_78c7b56e(cheat = 0)
{
	level notify(#"hash_78c7b56e");
	level endon(#"hash_78c7b56e");
	level endon(#"doa_game_is_over");
	if(!level flag::get("doa_game_is_completed") && level.doa.arena_round_number + 1 < level.doa.rules.var_88c0b67b)
	{
		if(cheat == 0)
		{
			function_f64e4b70();
			/#
				if(isdefined(level.doa.dev_level_skipped))
				{
					level.doa.var_c03fe5f1 = undefined;
				}
			#/
			if(isdefined(level.doa.var_c03fe5f1))
			{
				level notify(#"hash_ba37290e", level.doa.var_c03fe5f1.name);
				function_1c54aa82(level.doa.var_c03fe5f1);
			}
		}
		if(level.doa.flipped)
		{
			function_ba9c838e();
		}
		else
		{
			function_8274c029();
		}
		level.doa.arena_round_number = math::clamp(level.doa.arena_round_number + 1, 0, level.doa.rules.var_88c0b67b - 1);
		level doa_utility::set_lighting_state(level.doa.arena_round_number);
		level clientfield::set("arenaRound", level.doa.arena_round_number);
		return 0;
	}
	function_4586479a();
	if(level.doa.flipped)
	{
		level.doa.flipped = 0;
		level clientfield::set("flipCamera", 0);
		settopdowncamerayaw(0);
	}
	level.doa.arena_round_number = 0;
	if(isdefined(level.doa.var_b5c260bb))
	{
		function_5af67667(level.doa.var_b5c260bb);
		level.doa.round_number = level.doa.var_b5c260bb * level.doa.rules.var_88c0b67b;
		level.doa.var_b5c260bb = undefined;
	}
	else
	{
		function_5af67667(level.doa.current_arena + 1);
	}
	level doa_utility::set_lighting_state(level.doa.arena_round_number);
	level clientfield::set("arenaRound", level.doa.arena_round_number);
	idx = function_5295ea97();
	if(isdefined(idx))
	{
		level clientfield::set("overworldlevel", idx);
		util::wait_network_frame();
	}
	function_a6c926fc(5);
	return 1;
}

/*
	Name: function_a6c926fc
	Namespace: namespace_3ca3c537
	Checksum: 0xF15759EE
	Offset: 0x3C68
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function function_a6c926fc(holdtime)
{
	level.var_3259f885 = 1;
	level clientfield::set("overworld", 1);
	wait(holdtime);
	level clientfield::set("overworld", 0);
	level.var_3259f885 = 0;
}

/*
	Name: function_5af67667
	Namespace: namespace_3ca3c537
	Checksum: 0x19C20796
	Offset: 0x3CE0
	Size: 0x2BC
	Parameters: 2
	Flags: Linked
*/
function function_5af67667(var_7dd30d23, var_b4ca654f = 0)
{
	if(level flag::get("doa_game_is_completed") || (!(isdefined(var_b4ca654f) && var_b4ca654f) && level.doa.arenas[var_7dd30d23].var_63b4dab3))
	{
		if(isdefined(level.doa.var_5ddb204f))
		{
			[[level.doa.var_5ddb204f]]();
		}
		var_7dd30d23 = 0;
		level.doa.var_da96f13c++;
		level.doa.var_5bd7f25a = level.doa.var_5bd7f25a - 2000;
		if(level.doa.var_5bd7f25a < 2000)
		{
			level.doa.var_5bd7f25a = 2000;
		}
		level.doa.var_c061227e = level.doa.var_c061227e + 0.05;
		if(level.doa.var_c061227e > 1.15)
		{
			level.doa.var_c061227e = 1.15;
		}
		function_8b90b6a7();
		level flag::clear("doa_game_is_completed");
	}
	level.doa.current_arena = var_7dd30d23;
	level notify(#"hash_ec7ca67b");
	level clientfield::set("arenaUpdate", level.doa.current_arena);
	util::wait_network_frame();
	level thread function_a50a72db();
	level thread function_1c812a03();
	level thread function_fd84aa1f();
	level.doa.var_3361a074 = struct::get_array(function_d2d75f5d() + "_pickup", "targetname");
	level thread doa_utility::set_lighting_state(level.doa.arena_round_number);
}

/*
	Name: function_fd84aa1f
	Namespace: namespace_3ca3c537
	Checksum: 0xD95E3B1D
	Offset: 0x3FA8
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function function_fd84aa1f()
{
	if(isdefined(level.var_fd84aa1f))
	{
		[[level.var_fd84aa1f]](function_d2d75f5d());
	}
}

/*
	Name: function_a50a72db
	Namespace: namespace_3ca3c537
	Checksum: 0xED32F78C
	Offset: 0x3FE0
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function function_a50a72db()
{
	level endon(#"hash_ec7ca67b");
	level endon(#"hash_24d3a44");
	level notify(#"hash_a50a72db");
	level endon(#"hash_a50a72db");
	level waittill(#"hash_3b6e1e2");
	safezone = function_dc34896f();
	wait(1);
	while(!level flag::get("doa_game_is_over"))
	{
		foreach(var_d2788ed5, player in getplayers())
		{
			if(!isdefined(player.doa))
			{
				continue;
			}
			if(!player istouching(safezone) && !player isinmovemode("ufo", "noclip"))
			{
				doa_utility::debugmsg("Player " + player.entnum + " (" + player.name + ") is out of safety zone (" + safezone.targetname + ") at:" + player.origin);
				player thread namespace_cdb9a8fe::function_fe0946ac(undefined);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_1c812a03
	Namespace: namespace_3ca3c537
	Checksum: 0x2716E4B4
	Offset: 0x41E0
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function function_1c812a03()
{
	platforms = getentarray(function_d2d75f5d() + "_moving_platform", "targetname");
	for(i = 0; i < platforms.size; i++)
	{
		platforms[i] thread function_573ad24e();
		platforms[i] thread function_7d65367c();
	}
}

/*
	Name: function_573ad24e
	Namespace: namespace_3ca3c537
	Checksum: 0xAD42C605
	Offset: 0x4298
	Size: 0x2B2
	Parameters: 0
	Flags: Linked
*/
function function_573ad24e()
{
	level endon(#"hash_ec7ca67b");
	if(!isdefined(self.script_noteworthy))
	{
		self.script_noteworthy = "move_to_target";
	}
	if(!isdefined(self.script_parameters))
	{
		self.script_parameters = 30;
	}
	else
	{
		self.script_parameters = int(self.script_parameters);
	}
	var_febfbf3a = self.origin;
	self setmovingplatformenabled(1);
	var_dce3037c = getentarray(function_d2d75f5d() + "_moving_platform_linktrigger", "targetname");
	foreach(var_6f8ec018, trigger in var_dce3037c)
	{
		self thread function_852998f1(trigger);
	}
	switch(self.script_noteworthy)
	{
		case "move_to_target":
		{
			target = getent(self.target, "targetname");
			if(!isdefined(target))
			{
				target = struct::get(self.target, "targetname");
			}
			/#
				assert(isdefined(target));
			#/
			while(true)
			{
				self moveto(target.origin, self.script_parameters);
				self util::waittill_any_timeout(self.script_parameters + 2, "movedone");
				wait(1);
				self moveto(var_febfbf3a, self.script_parameters);
				self util::waittill_any_timeout(self.script_parameters + 2, "movedone");
			}
			break;
		}
	}
}

/*
	Name: function_852998f1
	Namespace: namespace_3ca3c537
	Checksum: 0x1E648ED8
	Offset: 0x4558
	Size: 0x344
	Parameters: 1
	Flags: Linked
*/
function function_852998f1(trigger)
{
	level endon(#"hash_ec7ca67b");
	wait(0.4);
	trigger enablelinkto();
	trigger linkto(self);
	self.var_10d9457b = [];
	nodes = getnodearray(function_d2d75f5d() + "_platform_traversal_node", "targetname");
	foreach(var_ee262643, node in nodes)
	{
		org = spawn("script_model", node.origin);
		org.targetname = "movingPlatformOnOffTriggerWatch";
		org.origin = org.origin + vectorscale((0, 0, 1), 10);
		org setmodel("tag_origin");
		org.node = node;
		self.var_10d9457b[self.var_10d9457b.size] = org;
	}
	while(isdefined(self.var_10d9457b))
	{
		foreach(var_daee136c, ent in self.var_10d9457b)
		{
			if(ent istouching(trigger))
			{
				if(!(isdefined(ent.node.activated) && ent.node.activated))
				{
					linktraversal(ent.node);
					ent.node.activated = 1;
				}
				continue;
			}
			if(isdefined(ent.node.activated) && ent.node.activated)
			{
				unlinktraversal(ent.node);
				ent.node.activated = undefined;
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_7d65367c
	Namespace: namespace_3ca3c537
	Checksum: 0xA4C02F11
	Offset: 0x48A8
	Size: 0x18A
	Parameters: 0
	Flags: Linked
*/
function function_7d65367c()
{
	level waittill(#"hash_ec7ca67b");
	self setmovingplatformenabled(0);
	nodes = getnodearray(function_d2d75f5d() + "_platform_traversal_node", "targetname");
	foreach(var_5ac2ae17, node in nodes)
	{
		unlinktraversal(node);
	}
	if(isdefined(self.var_10d9457b))
	{
		foreach(var_d36fd8b2, ent in self.var_10d9457b)
		{
			ent delete();
		}
		self.var_10d9457b = undefined;
	}
}

/*
	Name: function_47f8f274
	Namespace: namespace_3ca3c537
	Checksum: 0x2F4C56E6
	Offset: 0x4A40
	Size: 0x4A
	Parameters: 0
	Flags: Linked, Private
*/
private function function_47f8f274()
{
	wait(0.1);
	level util::waittill_any("exit_taken", "doa_game_is_over");
	wait(0.05);
	self notify(#"trigger");
}

/*
	Name: function_17665174
	Namespace: namespace_3ca3c537
	Checksum: 0x938A7459
	Offset: 0x4A98
	Size: 0xA8
	Parameters: 1
	Flags: Linked, Private
*/
private function function_17665174(trigger)
{
	level endon(#"exit_taken");
	level endon(#"doa_game_is_over");
	trigger waittill(#"trigger");
	level.doa.var_c03fe5f1 = function_6b351e04(level.doa.forced_magical_room, level.doa.var_94073ca5);
	if(isdefined(level.doa.var_c03fe5f1))
	{
		level.doa.lastmagical_exit_taken = level.doa.round_number;
	}
}

/*
	Name: function_f64e4b70
	Namespace: namespace_3ca3c537
	Checksum: 0x733FF9C3
	Offset: 0x4B48
	Size: 0x5BC
	Parameters: 1
	Flags: Linked
*/
function function_f64e4b70(specific)
{
	while(isdefined(level.doa.var_9b77ca48) && level.doa.var_9b77ca48)
	{
		wait(0.25);
	}
	level notify(#"hash_31b5dd0d");
	level.doa.exits_open = [];
	if(!isdefined(level.doa.var_c03fe5f1))
	{
		level clientfield::set("roundMenu", 1);
	}
	level.doa.var_c03fe5f1 = undefined;
	exit_triggers = function_a8f91d6f();
	if(isdefined(level.doa.var_638a5ffc))
	{
		specific = level.doa.var_638a5ffc;
		level.doa.var_638a5ffc = undefined;
	}
	if(isdefined(specific))
	{
		num_exits = (specific == "all" ? exit_triggers.size : 1);
		the_specific_exit = [];
		for(i = 0; i < exit_triggers.size; i++)
		{
			if(specific == "all" || exit_triggers[i].script_noteworthy == specific)
			{
				the_specific_exit[the_specific_exit.size] = exit_triggers[i];
			}
		}
		exit_triggers = the_specific_exit;
	}
	else
	{
		exit_triggers = doa_utility::function_4e9a23a9(exit_triggers);
		num_exits = 1 + randomint(exit_triggers.size);
		if(doa_utility::function_5233dbc0())
		{
			num_exits = math::clamp(num_exits, 2, exit_triggers.size);
		}
	}
	magic_exit = undefined;
	if(level.doa.round_number - level.doa.lastmagical_exit_taken > 2)
	{
		if(num_exits > 1)
		{
			magic_exit = randomint(num_exits);
		}
	}
	opened_exits = 0;
	playsoundatposition("zmb_exit_open", (0, 0, 0));
	namespace_74ae326f::function_471d1403();
	if(!isdefined(level.doa.forced_magical_room))
	{
		function_46b3be09();
	}
	for(i = 0; i < num_exits; i++)
	{
		if(isdefined(level.doa.forced_magical_room) || (isdefined(magic_exit) && i == magic_exit))
		{
			level thread function_17665174(exit_triggers[i]);
			magic_exit = undefined;
		}
		level thread function_a8b0c139(exit_triggers[i], i);
		level.doa.exits_open[level.doa.exits_open.size] = exit_triggers[i];
		/#
			if(isdefined(level.doa.dev_level_skipped))
			{
				exit_triggers[i] thread doa_utility::function_a4d1f25e("", randomfloatrange(0.5, 1));
			}
		#/
		wait(0.2);
	}
	level notify(#"hash_7a1b7ce7");
	/#
		assert(level.doa.exits_open.size != 0, "");
	#/
	level clientfield::set("numexits", level.doa.exits_open.size);
	level waittill(#"exit_taken", exit_trigger);
	level.doa.forced_magical_room = undefined;
	level.doa.var_94073ca5 = undefined;
	level notify(#"hash_b96c96ac", level.doa.exits_open.size > 1);
	level notify(#"hash_97276c43");
	level.doa.exits_open = [];
	if(isdefined(exit_trigger))
	{
		doa_utility::function_44eb090b();
		playsoundatposition("zmb_exit_taken", exit_trigger.origin);
		level.doa.previous_exit_taken = exit_trigger.script_noteworthy;
	}
	level clientfield::set("roundMenu", 0);
	level clientfield::set("teleportMenu", 0);
	level clientfield::set("numexits", 0);
}

/*
	Name: function_a8b0c139
	Namespace: namespace_3ca3c537
	Checksum: 0x3F744B63
	Offset: 0x5110
	Size: 0x34A
	Parameters: 2
	Flags: Linked
*/
function function_a8b0c139(trigger, objective_id)
{
	objective_add(objective_id, "active", trigger.origin);
	objective_set3d(objective_id, 1, "default", "*");
	trigger thread function_47f8f274();
	level waittill(#"hash_7a1b7ce7");
	trigger triggerenable(1);
	trigger.open = 1;
	blockers = getentarray(trigger.target, "targetname");
	foreach(var_32e1221a, blocker in blockers)
	{
		blocker.origin = blocker.origin - vectorscale((0, 0, 1), 5000);
	}
	while(true)
	{
		trigger waittill(#"trigger", guy);
		if(isdefined(guy) && !isplayer(guy))
		{
			continue;
		}
		break;
	}
	trigger.open = 0;
	trigger triggerenable(0);
	foreach(var_66b0c7f3, blocker in blockers)
	{
		blocker.origin = blocker.origin + vectorscale((0, 0, 1), 5000);
	}
	objective_delete(objective_id);
	wait(0.1);
	level notify(#"exit_taken", trigger);
	foreach(var_804fb80d, player in getplayers())
	{
		player notify(#"exit_taken");
	}
}

/*
	Name: rotate
	Namespace: namespace_3ca3c537
	Checksum: 0x51C3CD3
	Offset: 0x5468
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function rotate()
{
	self endon(#"death");
	while(true)
	{
		self rotateto(self.angles + vectorscale((0, 1, 0), 180), 4);
		wait(4);
	}
}

/*
	Name: function_2a9d778d
	Namespace: namespace_3ca3c537
	Checksum: 0x3A47301F
	Offset: 0x54C0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_2a9d778d()
{
	location = struct::get(function_d2d75f5d() + "_doa_teleporter", "targetname");
	if(!isdefined(location))
	{
		location = function_61d60e0b();
	}
	else
	{
		location = location.origin;
	}
	return location;
}

/*
	Name: function_4586479a
	Namespace: namespace_3ca3c537
	Checksum: 0xDA3CDF23
	Offset: 0x5550
	Size: 0x6CA
	Parameters: 1
	Flags: Linked
*/
function function_4586479a(var_57e102cb = 1)
{
	while(isdefined(level.doa.var_9b77ca48) && level.doa.var_9b77ca48)
	{
		wait(0.25);
	}
	location = struct::get(function_d2d75f5d() + "_doa_teleporter", "targetname");
	if(!isdefined(location))
	{
		location = function_61d60e0b();
		if(!isdefined(location))
		{
			return;
		}
	}
	else
	{
		location = location.origin;
	}
	if(var_57e102cb)
	{
		level clientfield::set("roundMenu", 1);
		level clientfield::set("teleportMenu", 1);
	}
	start_point = location + vectorscale((0, 0, -1), 50);
	level.doa.teleporter = spawn("script_model", start_point);
	level.doa.teleporter endon(#"death");
	level.doa.teleporter setmodel("zombietron_teleporter");
	level.doa.teleporter enablelinkto();
	level.doa.teleporter thread namespace_eaa992c::function_285a2999("teleporter");
	level.doa.teleporter moveto(location + vectorscale((0, 0, 1), 5), 3, 0, 0);
	level.doa.teleporter thread rotate();
	physicsexplosionsphere(start_point, 200, 128, 4);
	level.doa.teleporter util::waittill_any_timeout(4, "movedone");
	physicsexplosionsphere(start_point, 200, 128, 3);
	level.doa.teleporter setmovingplatformenabled(1);
	level.doa.teleporter thread namespace_1a381543::function_90118d8c("zmb_teleporter_spawn");
	level.doa.teleporter playloopsound("zmb_teleporter_loop", 3);
	level.doa.teleporter.trigger = spawn("trigger_radius", location + vectorscale((0, 0, -1), 100), 0, 20, 200);
	level.doa.teleporter.trigger.targetname = "teleporter";
	/#
		if(isdefined(level.doa.dev_level_skipped))
		{
			level.doa.teleporter.trigger thread doa_utility::function_a4d1f25e("", randomfloatrange(0.1, 1));
		}
	#/
	level.doa.teleporter.trigger waittill(#"trigger", player);
	level notify(#"hash_6df89d17");
	level notify(#"hash_3b432f18");
	foreach(var_d4e24c6a, player in getplayers())
	{
		player notify(#"hash_d28ba89d");
	}
	if(var_57e102cb)
	{
		level notify(#"hash_b96c96ac");
		level notify(#"hash_97276c43");
	}
	playrumbleonposition("artillery_rumble", location);
	level.doa.teleporter stoploopsound(2);
	level.doa.teleporter thread namespace_1a381543::function_4f06fb8("zmb_teleporter_spawn");
	level notify(#"hash_ba37290e", "arenatransition");
	level.doa.teleporter thread namespace_1a381543::function_90118d8c("zmb_teleporter_tele_out");
	doa_utility::function_44eb090b();
	level clientfield::set("roundMenu", 0);
	level clientfield::set("teleportMenu", 0);
	level clientfield::set("numexits", 0);
	level doa_utility::set_lighting_state(0);
	level clientfield::set("arenaRound", 5);
	namespace_d88e3a06::function_116bb43();
	level.doa.teleporter.trigger delete();
	level.doa.teleporter delete();
	level.doa.teleporter = undefined;
}

