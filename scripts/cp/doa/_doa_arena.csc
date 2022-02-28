// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\cp_doa_bo3_fx;
#using scripts\cp\cp_doa_bo3_sound;
#using scripts\cp\doa\_doa_camera;
#using scripts\cp\doa\_doa_core;
#using scripts\cp\doa\_doa_fx;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_3ca3c537;

/*
	Name: function_a55a134f
	Namespace: namespace_3ca3c537
	Checksum: 0xA3EA456E
	Offset: 0x3C0
	Size: 0x19C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_a55a134f()
{
	arenas = struct::get_array("arena_center");
	for(i = 0; i < arenas.size; i++)
	{
		if(issubstr(arenas[i].script_parameters, "player_challenge"))
		{
			arenas[i].var_f869148f = arenas[i].script_parameters;
			arenas[i].script_parameters = "99999";
		}
	}
	unsorted = arenas;
	for(i = 1; i < unsorted.size; i++)
	{
		for(j = i; j > 0 && (int(unsorted[j - 1].script_parameters)) > int(unsorted[j].script_parameters); j--)
		{
			array::swap(unsorted, j, j - 1);
		}
	}
	return unsorted;
}

/*
	Name: function_bd3519f2
	Namespace: namespace_3ca3c537
	Checksum: 0x48FA5778
	Offset: 0x568
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function function_bd3519f2(name)
{
	switch(name)
	{
		case "safehouse":
		{
			return 500;
		}
		case "redins":
		case "tankmaze":
		{
			return 1000;
		}
		case "combat":
		{
			return 1800;
		}
		default:
		{
			return 600;
		}
	}
}

/*
	Name: function_61e2e743
	Namespace: namespace_3ca3c537
	Checksum: 0xAEB9EEDD
	Offset: 0x5D0
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function function_61e2e743()
{
	if(isdefined(level.doa.var_708cc739))
	{
		switch(level.doa.var_708cc739)
		{
			case 1:
			{
				return 400;
			}
			case 2:
			{
				return 800;
			}
			case 3:
			{
				return 1000;
			}
			case 4:
			{
				return 1800;
			}
		}
		/#
			assert(0);
		#/
	}
	return level.doa.arenas[level.doa.current_arena].var_5b6a567;
}

/*
	Name: function_382c20a3
	Namespace: namespace_3ca3c537
	Checksum: 0x9C963EC
	Offset: 0x688
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function function_382c20a3()
{
	return level.doa.arenas[level.doa.current_arena].var_bfa5d6ae;
}

/*
	Name: init
	Namespace: namespace_3ca3c537
	Checksum: 0x6DB052AC
	Offset: 0x6C0
	Size: 0xF84
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.doa.arenas = [];
	arenas = function_a55a134f();
	for(i = 0; i < arenas.size; i++)
	{
		arena = spawnstruct();
		arena.name = arenas[i].script_noteworthy;
		arena.center = arenas[i].origin;
		arena.var_5b6a567 = function_bd3519f2(arena.name);
		arena.var_37d3a53b = (isdefined(arenas[i].var_f869148f) ? 1 : 0);
		arena.var_aad78940 = 1.4;
		arena.var_bfa5d6ae = 0;
		arena.var_dd94482c = (1 + 2) + 16;
		arena.var_ecf7ec70 = undefined;
		if(isdefined(level.var_2eda2d85))
		{
			[[level.var_2eda2d85]](arena);
		}
		arena.exits = getentarray(0, arena.name + "_doa_exit", "targetname");
		arena.startpoints["left"] = struct::get_array((arena.name + "_exit_start_") + "left");
		arena.startpoints["right"] = struct::get_array((arena.name + "_exit_start_") + "right");
		arena.startpoints["top"] = struct::get_array((arena.name + "_exit_start_") + "top");
		arena.startpoints["bottom"] = struct::get_array((arena.name + "_exit_start_") + "bottom");
		arena.startpoints["player"] = struct::get_array(arena.name + "_player_spawnpoint");
		if(arena.name == "vault" || arena.name == "tankmaze" || arena.name == "coop" || arena.name == "armory" || arena.name == "alien_armory" || arena.name == "wolfhole" || arena.name == "bomb_storage" || arena.name == "hangar" || arena.name == "redins" || arena.name == "truck_soccer" || arena.name == "tankmaze")
		{
			arena.var_869acbe6 = 1;
		}
		var_5fabae4f = struct::get(arena.name + "_camera_fixed_point");
		if(isdefined(var_5fabae4f) && isdefined(var_5fabae4f.script_parameters))
		{
			campos = strtok(var_5fabae4f.script_parameters, " ");
			/#
				assert(isdefined(campos.size == 3), ("" + arena.name) + "");
			#/
			arena.var_2ac7f133 = (float(campos[0]), float(campos[1]), float(campos[2]));
		}
		else
		{
			arena.var_2ac7f133 = (0, 0, 0);
		}
		if(isdefined(var_5fabae4f) && isdefined(var_5fabae4f.script_noteworthy))
		{
			var_b5091c96 = strtok(var_5fabae4f.script_noteworthy, " ");
			/#
				assert(isdefined(var_b5091c96.size == 3), ("" + arena.name) + "");
			#/
			arena.var_5fec1234 = (float(var_b5091c96[0]), float(var_b5091c96[1]), float(var_b5091c96[2]));
		}
		else
		{
			arena.var_5fec1234 = vectorscale((1, 0, 0), 60);
		}
		arena.var_7526f3f5 = arena.var_2ac7f133;
		arena.var_790aac0e = arena.var_5fec1234;
		var_5fabae4f = struct::get(arena.name + "_camera_fixed_point_flip");
		if(isdefined(var_5fabae4f))
		{
			if(isdefined(var_5fabae4f.script_parameters))
			{
				campos = strtok(var_5fabae4f.script_parameters, " ");
				/#
					assert(isdefined(campos.size == 3), ("" + arena.name) + "");
				#/
				arena.var_5a97f5e9 = (float(campos[0]), float(campos[1]), float(campos[2]));
			}
			else
			{
				arena.var_5a97f5e9 = (0, 0, 0);
			}
			if(isdefined(var_5fabae4f.script_noteworthy))
			{
				var_b5091c96 = strtok(var_5fabae4f.script_noteworthy, " ");
				/#
					assert(isdefined(var_b5091c96.size == 3), ("" + arena.name) + "");
				#/
				arena.var_a8b67ea4 = (float(var_b5091c96[0]), float(var_b5091c96[1]), float(var_b5091c96[2]));
			}
			else
			{
				arena.var_5fec1234 = (60, 180, 0);
			}
		}
		if(isdefined(arena.var_f4f1abf3))
		{
			if(arena.var_f4f1abf3 == 1)
			{
				arena.var_f4f1abf3 = arena.var_5fec1234;
			}
			if(arena.var_f4f1abf3 == 2)
			{
				arena.var_f4f1abf3 = arena.var_5a97f5e9;
			}
		}
		level.doa.arenas[level.doa.arenas.size] = arena;
	}
	level.doa.current_arena = 0;
	level.doa.var_95e3fdf9 = -1;
	level.doa.var_1a75d02b = 1;
	level.doa.var_d94564a5 = "morning";
	level thread function_a83dfb2c();
	keywords = [];
	keywords["targetname"] = [];
	if(!isdefined(keywords["targetname"]))
	{
		keywords["targetname"] = [];
	}
	else if(!isarray(keywords["targetname"]))
	{
		keywords["targetname"] = array(keywords["targetname"]);
	}
	keywords["targetname"][keywords["targetname"].size] = "_spot";
	if(!isdefined(keywords["targetname"]))
	{
		keywords["targetname"] = [];
	}
	else if(!isarray(keywords["targetname"]))
	{
		keywords["targetname"] = array(keywords["targetname"]);
	}
	keywords["targetname"][keywords["targetname"].size] = "_hazard";
	if(!isdefined(keywords["targetname"]))
	{
		keywords["targetname"] = [];
	}
	else if(!isarray(keywords["targetname"]))
	{
		keywords["targetname"] = array(keywords["targetname"]);
	}
	keywords["targetname"][keywords["targetname"].size] = "_pickup";
	if(!isdefined(keywords["targetname"]))
	{
		keywords["targetname"] = [];
	}
	else if(!isarray(keywords["targetname"]))
	{
		keywords["targetname"] = array(keywords["targetname"]);
	}
	keywords["targetname"][keywords["targetname"].size] = "_teleporter";
	if(!isdefined(keywords["targetname"]))
	{
		keywords["targetname"] = [];
	}
	else if(!isarray(keywords["targetname"]))
	{
		keywords["targetname"] = array(keywords["targetname"]);
	}
	keywords["targetname"][keywords["targetname"].size] = "_loot";
	if(!isdefined(keywords["targetname"]))
	{
		keywords["targetname"] = [];
	}
	else if(!isarray(keywords["targetname"]))
	{
		keywords["targetname"] = array(keywords["targetname"]);
	}
	keywords["targetname"][keywords["targetname"].size] = "_spawn";
	if(!isdefined(keywords["targetname"]))
	{
		keywords["targetname"] = [];
	}
	else if(!isarray(keywords["targetname"]))
	{
		keywords["targetname"] = array(keywords["targetname"]);
	}
	keywords["targetname"][keywords["targetname"].size] = "_destructible";
	keywords["script_noteworthy"] = [];
	if(!isdefined(keywords["script_noteworthy"]))
	{
		keywords["script_noteworthy"] = [];
	}
	else if(!isarray(keywords["script_noteworthy"]))
	{
		keywords["script_noteworthy"] = array(keywords["script_noteworthy"]);
	}
	keywords["script_noteworthy"][keywords["script_noteworthy"].size] = "tankmaze_gemspot";
	level function_d6bfcb75(keywords);
}

/*
	Name: function_d6bfcb75
	Namespace: namespace_3ca3c537
	Checksum: 0xDA9815D
	Offset: 0x1650
	Size: 0x200
	Parameters: 1
	Flags: Linked
*/
function function_d6bfcb75(keywords)
{
	var_3c8074ad = getarraykeys(keywords);
	for(i = 0; i < level.struct.size; i++)
	{
		if(function_a5b9b9b9(keywords, var_3c8074ad, level.struct[i]))
		{
			arrayremoveindex(level.struct, i, 0);
			i--;
		}
	}
	var_e5c5b3d2 = level.struct_class_names;
	var_7234d8ce = getarraykeys(var_e5c5b3d2);
	for(i = 0; i < var_7234d8ce.size; i++)
	{
		var_df94bc60 = var_e5c5b3d2[var_7234d8ce[i]];
		keys = getarraykeys(var_df94bc60);
		for(j = 0; j < keys.size; j++)
		{
			values = var_df94bc60[keys[j]];
			for(k = 0; k < values.size; k++)
			{
				if(function_a5b9b9b9(keywords, var_3c8074ad, values[k]))
				{
					arrayremoveindex(values, k, 0);
					k--;
				}
			}
		}
	}
}

/*
	Name: function_a5b9b9b9
	Namespace: namespace_3ca3c537
	Checksum: 0xB627411B
	Offset: 0x1858
	Size: 0xFA
	Parameters: 3
	Flags: Linked
*/
function function_a5b9b9b9(var_92804e37, var_b092b293, struct)
{
	for(i = 0; i < var_b092b293.size; i++)
	{
		key = var_b092b293[i];
		var_cd3c820 = var_92804e37[key];
		for(j = 0; j < var_cd3c820.size; j++)
		{
			field = getstructfield(struct, key);
			if(isdefined(field) && issubstr(field, var_cd3c820[j]))
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: restart
	Namespace: namespace_3ca3c537
	Checksum: 0xB4E26B98
	Offset: 0x1960
	Size: 0x202
	Parameters: 0
	Flags: Linked
*/
function restart()
{
	level.doa.current_arena = 0;
	level.doa.var_95e3fdf9 = -1;
	level.doa.var_708cc739 = undefined;
	level.doa.var_1a75d02b = 1;
	level.doa.flipped = 0;
	namespace_ad544aeb::function_d22ceb57(vectorscale((1, 0, 0), 75), function_61e2e743());
	if(isdefined(level.doa.arenas[level.doa.current_arena].var_2ac7f133))
	{
		level.doa.arenas[level.doa.current_arena].var_7526f3f5 = level.doa.arenas[level.doa.current_arena].var_2ac7f133;
	}
	if(isdefined(level.doa.arenas[level.doa.current_arena].var_5fec1234))
	{
		level.doa.arenas[level.doa.current_arena].var_790aac0e = level.doa.arenas[level.doa.current_arena].var_5fec1234;
	}
	cleanupspawneddynents();
	if(isdefined(level.doa.var_1a3f3152))
	{
		exploder::kill_exploder(level.doa.var_1a3f3152);
		level.doa.var_1a3f3152 = undefined;
	}
}

/*
	Name: function_a83dfb2c
	Namespace: namespace_3ca3c537
	Checksum: 0xE91CA488
	Offset: 0x1B70
	Size: 0x176
	Parameters: 0
	Flags: Linked
*/
function function_a83dfb2c()
{
	while(!clienthassnapshot(0))
	{
		wait(0.016);
	}
	foreach(arena in level.doa.arenas)
	{
		arena.exits = getentarray(0, arena.name + "_doa_exit", "targetname");
	}
	a_all_entities = getentarray(0);
	foreach(entity in a_all_entities)
	{
		wait(0.01);
	}
}

/*
	Name: flipcamera
	Namespace: namespace_3ca3c537
	Checksum: 0x32AEE30D
	Offset: 0x1CF0
	Size: 0x384
	Parameters: 7
	Flags: Linked
*/
function flipcamera(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level.doa.var_1a75d02b = newval;
	switch(level.doa.var_1a75d02b)
	{
		case 0:
		case 1:
		{
			level.doa.flipped = 0;
			namespace_ad544aeb::function_d22ceb57(function_c530afc5(vectorscale((1, 0, 0), 75)), function_61e2e743());
			if(isdefined(level.doa.arenas[level.doa.current_arena].var_2ac7f133))
			{
				level.doa.arenas[level.doa.current_arena].var_7526f3f5 = level.doa.arenas[level.doa.current_arena].var_2ac7f133;
			}
			if(isdefined(level.doa.arenas[level.doa.current_arena].var_5fec1234))
			{
				level.doa.arenas[level.doa.current_arena].var_790aac0e = level.doa.arenas[level.doa.current_arena].var_5fec1234;
			}
			level.doa.var_1a75d02b = 1;
			break;
		}
		case 2:
		{
			level.doa.flipped = 1;
			namespace_ad544aeb::function_d22ceb57(function_c530afc5((75, 180, 0)), function_61e2e743());
			if(isdefined(level.doa.arenas[level.doa.current_arena].var_5a97f5e9))
			{
				level.doa.arenas[level.doa.current_arena].var_7526f3f5 = level.doa.arenas[level.doa.current_arena].var_5a97f5e9;
			}
			if(isdefined(level.doa.arenas[level.doa.current_arena].var_a8b67ea4))
			{
				level.doa.arenas[level.doa.current_arena].var_790aac0e = level.doa.arenas[level.doa.current_arena].var_a8b67ea4;
			}
			break;
		}
	}
	cleanupspawneddynents();
}

/*
	Name: function_c530afc5
	Namespace: namespace_3ca3c537
	Checksum: 0x3ADAB3B6
	Offset: 0x2080
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function function_c530afc5(angles)
{
	if(function_61e2e743() == 400 || function_382c20a3() == 1)
	{
		if(level.doa.var_1a75d02b != 2)
		{
			return vectorscale((1, 0, 0), 88);
		}
		return (88, 180, 0);
	}
	return angles;
}

/*
	Name: function_be152c54
	Namespace: namespace_3ca3c537
	Checksum: 0x4FD50D38
	Offset: 0x2100
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_be152c54()
{
	if(function_61e2e743() == 400)
	{
		return 99;
	}
	return level.doa.arenas[level.doa.current_arena].var_aad78940;
}

/*
	Name: function_9f1a0b26
	Namespace: namespace_3ca3c537
	Checksum: 0x52345715
	Offset: 0x2158
	Size: 0x10A
	Parameters: 1
	Flags: Linked
*/
function function_9f1a0b26(var_c3479584)
{
	localplayers = getlocalplayers();
	if(localplayers.size > 1)
	{
		if(level.doa.arenas[level.doa.current_arena].var_dd94482c & 4)
		{
			return 2;
		}
	}
	var_44509e49 = level.doa.arenas[level.doa.current_arena].var_ecf7ec70;
	if(isdefined(var_44509e49))
	{
		return var_44509e49;
	}
	if(isdefined(var_c3479584) && level.doa.arenas[level.doa.current_arena].var_dd94482c & (1 << var_c3479584))
	{
		return var_c3479584;
	}
	return 0;
}

/*
	Name: function_61d60e0b
	Namespace: namespace_3ca3c537
	Checksum: 0x87B50EE1
	Offset: 0x2270
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_61d60e0b()
{
	if(isdefined(level.doa.arenas) && level.doa.arenas.size > 0)
	{
		return level.doa.arenas[level.doa.current_arena].center;
	}
	return (0, 0, 0);
}

/*
	Name: function_d2d75f5d
	Namespace: namespace_3ca3c537
	Checksum: 0xA1309FCF
	Offset: 0x22D8
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function function_d2d75f5d()
{
	return level.doa.arenas[level.doa.current_arena].name;
}

/*
	Name: function_22f2039b
	Namespace: namespace_3ca3c537
	Checksum: 0x24E95917
	Offset: 0x2310
	Size: 0x8E
	Parameters: 7
	Flags: Linked
*/
function function_22f2039b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(level.weatherfx) && isdefined(level.weatherfx[localclientnum]))
	{
		stopfx(localclientnum, level.weatherfx[localclientnum]);
		level.weatherfx[localclientnum] = 0;
	}
}

/*
	Name: function_9977953
	Namespace: namespace_3ca3c537
	Checksum: 0xD86CD486
	Offset: 0x23A8
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function function_9977953(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setworldfogactivebank(localclientnum, 0);
}

/*
	Name: function_836d1e22
	Namespace: namespace_3ca3c537
	Checksum: 0x146D6662
	Offset: 0x2408
	Size: 0x3A4
	Parameters: 7
	Flags: Linked
*/
function function_836d1e22(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(level.doa.var_1a3f3152))
	{
		stopradiantexploder(localclientnum, level.doa.var_1a3f3152);
		level.doa.var_1a3f3152 = undefined;
	}
	level.doa.var_d94564a5 = "morning";
	switch(newval)
	{
		case 0:
		{
			level.doa.var_d94564a5 = "morning";
			setworldfogactivebank(localclientnum, 1);
			break;
		}
		case 1:
		{
			level.doa.var_d94564a5 = "noon";
			setworldfogactivebank(localclientnum, 2);
			break;
		}
		case 2:
		{
			level.doa.var_d94564a5 = "dusk";
			setworldfogactivebank(localclientnum, 4);
			break;
		}
		case 3:
		{
			level.doa.var_d94564a5 = "night";
			setworldfogactivebank(localclientnum, 8);
			break;
		}
		default:
		{
			level.doa.var_d94564a5 = "morning";
			setworldfogactivebank(localclientnum, 1);
			break;
		}
	}
	if(function_d2d75f5d() == "temple" || function_d2d75f5d() == "tankmaze" || function_d2d75f5d() == "sgen" || function_d2d75f5d() == "blood" || function_d2d75f5d() == "vengeance" || function_d2d75f5d() == "boss")
	{
		setworldfogactivebank(localclientnum, 0);
	}
	level.doa.var_1a3f3152 = (("fx_exploder_" + level.doa.arenas[level.doa.current_arena].name) + "_") + level.doa.var_d94564a5;
	/#
		namespace_693feb87::debugmsg((("" + level.doa.var_1a3f3152) + "") + localclientnum);
	#/
	playradiantexploder(localclientnum, level.doa.var_1a3f3152);
	level function_43141563(localclientnum);
}

/*
	Name: function_43141563
	Namespace: namespace_3ca3c537
	Checksum: 0x402DF781
	Offset: 0x27B8
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function function_43141563(localclientnum)
{
	if(isdefined(level.var_1f314fb9))
	{
		[[level.var_1f314fb9]](localclientnum, level.doa.arenas[level.doa.current_arena].name, level.doa.var_d94564a5);
	}
}

/*
	Name: setarena
	Namespace: namespace_3ca3c537
	Checksum: 0x69176B69
	Offset: 0x2828
	Size: 0x2EC
	Parameters: 7
	Flags: Linked
*/
function setarena(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(level.doa.current_arena == newval && level.doa.var_95e3fdf9 != -1)
	{
		return;
	}
	level.doa.var_708cc739 = undefined;
	level notify(#"hash_ec7ca67b");
	/#
		namespace_693feb87::debugmsg((("" + level.doa.arenas[level.doa.current_arena].name) + "") + level.doa.arenas[newval].name);
	#/
	level.doa.var_95e3fdf9 = level.doa.current_arena;
	level.doa.current_arena = newval;
	if(level.doa.arenas[level.doa.current_arena].var_37d3a53b)
	{
		namespace_ad544aeb::function_d22ceb57(vectorscale((1, 0, 0), 75), function_61e2e743());
	}
	else
	{
		namespace_ad544aeb::function_d22ceb57(undefined, function_61e2e743());
	}
	cleanupspawneddynents();
	if(isdefined(level.doa.arenas[level.doa.current_arena].var_f3114f93))
	{
		level thread [[level.doa.arenas[level.doa.current_arena].var_f3114f93]](localclientnum);
	}
	players = getlocalplayers();
	while(players.size == 0)
	{
		players = getlocalplayers();
		wait(0.016);
	}
	players[0].var_44509e49 = function_9f1a0b26(players[0].var_44509e49);
	function_986ae2b3(localclientnum);
	players[0] cameraforcedisablescriptcam(0);
}

/*
	Name: function_986ae2b3
	Namespace: namespace_3ca3c537
	Checksum: 0xF75AA969
	Offset: 0x2B20
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_986ae2b3(localclientnum)
{
	var_46caea66 = (level.doa.var_1a75d02b == 1 ? vectorscale((1, 0, 0), 75) : (75, 180, 0));
	namespace_ad544aeb::function_d22ceb57(function_c530afc5(var_46caea66), function_61e2e743());
	level function_43141563(localclientnum);
}

