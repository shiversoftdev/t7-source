// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\load_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace skipto;

/*
	Name: __init__sytem__
	Namespace: skipto
	Checksum: 0xF6497CB8
	Offset: 0x2F0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("skipto", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: skipto
	Checksum: 0xB395C696
	Offset: 0x338
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level flag::init("running_skipto");
	level flag::init("level_has_skiptos");
	level flag::init("level_has_skipto_branches");
	level.skipto_current_objective = [];
	clientfield::register("toplayer", "catch_up_transition", 1, 1, "counter", &catch_up_transition, 0, 0);
	clientfield::register("world", "set_last_map_dvar", 1, 1, "counter", &set_last_map_dvar, 0, 0);
	add_internal("_default");
	add_internal("no_game");
	load_mission_table("gamedata/tables/cp/cp_mapmissions.csv", getdvarstring("mapname"));
	level thread watch_players_connect();
	level thread function_91c7f6af();
}

/*
	Name: __main__
	Namespace: skipto
	Checksum: 0xDC31582F
	Offset: 0x4D0
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level thread handle();
	nextmapmodel = getuimodel(getglobaluimodel(), "nextMap");
	if(!util::is_safehouse())
	{
		nextmapmodel = createuimodel(getglobaluimodel(), "nextMap");
		setuimodelvalue(nextmapmodel, getdvarstring("ui_mapname"));
	}
}

/*
	Name: add
	Namespace: skipto
	Checksum: 0xCFA0FCF
	Offset: 0x5A8
	Size: 0x32C
	Parameters: 6
	Flags: None
*/
function add(skipto, func, loc_string, cleanup_func, launch_after, end_before)
{
	if(!isdefined(level.default_skipto))
	{
		level.default_skipto = skipto;
	}
	if(is_dev(skipto))
	{
		/#
			errormsg("");
		#/
		return;
	}
	if(isdefined(launch_after) || isdefined(end_before))
	{
		/#
			errormsg("");
		#/
		return;
	}
	if(level flag::get("level_has_skipto_branches"))
	{
		/#
			errormsg("");
		#/
	}
	if(!isdefined(launch_after))
	{
		if(isdefined(level.last_skipto))
		{
			if(isdefined(level.skipto_settings[level.last_skipto]))
			{
				if(!isdefined(level.skipto_settings[level.last_skipto].end_before) || level.skipto_settings[level.last_skipto].end_before.size < 1)
				{
					if(!isdefined(level.skipto_settings[level.last_skipto].end_before))
					{
						level.skipto_settings[level.last_skipto].end_before = [];
					}
					else if(!isarray(level.skipto_settings[level.last_skipto].end_before))
					{
						level.skipto_settings[level.last_skipto].end_before = array(level.skipto_settings[level.last_skipto].end_before);
					}
				}
				level.skipto_settings[level.last_skipto].end_before[level.skipto_settings[level.last_skipto].end_before.size] = skipto;
			}
		}
		if(isdefined(level.last_skipto))
		{
			launch_after = level.last_skipto;
		}
		level.last_skipto = skipto;
	}
	if(!isdefined(func))
	{
		/#
			assert(isdefined(func), "");
		#/
	}
	struct = add_internal(skipto, func, loc_string, cleanup_func, launch_after, end_before);
	struct.public = 1;
	level flag::set("level_has_skiptos");
}

/*
	Name: add_branch
	Namespace: skipto
	Checksum: 0xEA0B4B2D
	Offset: 0x8E0
	Size: 0x314
	Parameters: 6
	Flags: Linked
*/
function add_branch(skipto, func, loc_string, cleanup_func, launch_after, end_before)
{
	if(!isdefined(level.default_skipto))
	{
		level.default_skipto = skipto;
	}
	if(is_dev(skipto))
	{
		/#
			errormsg("");
		#/
		return;
	}
	if(!isdefined(launch_after) && !isdefined(end_before))
	{
		/#
			errormsg("");
		#/
		return;
	}
	if(!isdefined(launch_after))
	{
		if(isdefined(level.last_skipto))
		{
			if(isdefined(level.skipto_settings[level.last_skipto]))
			{
				if(!isdefined(level.skipto_settings[level.last_skipto].end_before) || level.skipto_settings[level.last_skipto].end_before.size < 1)
				{
					if(!isdefined(level.skipto_settings[level.last_skipto].end_before))
					{
						level.skipto_settings[level.last_skipto].end_before = [];
					}
					else if(!isarray(level.skipto_settings[level.last_skipto].end_before))
					{
						level.skipto_settings[level.last_skipto].end_before = array(level.skipto_settings[level.last_skipto].end_before);
					}
				}
				level.skipto_settings[level.last_skipto].end_before[level.skipto_settings[level.last_skipto].end_before.size] = skipto;
			}
		}
		if(isdefined(level.last_skipto))
		{
			launch_after = level.last_skipto;
		}
		level.last_skipto = skipto;
	}
	if(!isdefined(func))
	{
		/#
			assert(isdefined(func), "");
		#/
	}
	struct = add_internal(skipto, func, loc_string, cleanup_func, launch_after, end_before);
	struct.public = 1;
	level flag::set("level_has_skiptos");
	level flag::set("level_has_skipto_branches");
}

/*
	Name: add_dev
	Namespace: skipto
	Checksum: 0x1E4797C
	Offset: 0xC00
	Size: 0xD4
	Parameters: 6
	Flags: None
*/
function add_dev(skipto, func, loc_string, cleanup_func, launch_after, end_before)
{
	if(!isdefined(level.default_skipto))
	{
		level.default_skipto = skipto;
	}
	if(is_dev(skipto))
	{
		struct = add_internal(skipto, func, loc_string, cleanup_func, launch_after, end_before);
		struct.dev_skipto = 1;
		return;
	}
	/#
		errormsg("");
	#/
}

/*
	Name: add_internal
	Namespace: skipto
	Checksum: 0x3ADC9A1F
	Offset: 0xCE0
	Size: 0xC6
	Parameters: 6
	Flags: Linked
*/
function add_internal(msg, func, loc_string, cleanup_func, launch_after, end_before)
{
	/#
		assert(!isdefined(level._loadstarted), "");
	#/
	msg = tolower(msg);
	struct = add_construct(msg, func, loc_string, cleanup_func, launch_after, end_before);
	level.skipto_settings[msg] = struct;
	return struct;
}

/*
	Name: change
	Namespace: skipto
	Checksum: 0x1888B6DC
	Offset: 0xDB0
	Size: 0x194
	Parameters: 6
	Flags: None
*/
function change(msg, func, loc_string, cleanup_func, launch_after, end_before)
{
	struct = level.skipto_settings[msg];
	if(isdefined(func))
	{
		struct.skipto_func = func;
	}
	if(isdefined(loc_string))
	{
		struct.skipto_loc_string = loc_string;
	}
	if(isdefined(cleanup_func))
	{
		struct.cleanup_func = cleanup_func;
	}
	if(isdefined(launch_after))
	{
		if(!isdefined(struct.launch_after))
		{
			struct.launch_after = [];
		}
		else if(!isarray(struct.launch_after))
		{
			struct.launch_after = array(struct.launch_after);
		}
		struct.launch_after[struct.launch_after.size] = launch_after;
	}
	if(isdefined(end_before))
	{
		struct.end_before = strtok(end_before, ",");
		struct.next = struct.end_before;
	}
}

/*
	Name: set_skipto_cleanup_func
	Namespace: skipto
	Checksum: 0x11CE4F04
	Offset: 0xF50
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function set_skipto_cleanup_func(func)
{
	level.func_skipto_cleanup = func;
}

/*
	Name: add_construct
	Namespace: skipto
	Checksum: 0xFA7CA7CB
	Offset: 0xF70
	Size: 0x1F8
	Parameters: 6
	Flags: Linked
*/
function add_construct(msg, func, loc_string, cleanup_func, launch_after, end_before)
{
	struct = spawnstruct();
	struct.name = msg;
	struct.skipto_func = func;
	struct.skipto_loc_string = loc_string;
	struct.cleanup_func = cleanup_func;
	struct.next = [];
	struct.prev = [];
	struct.completion_conditions = "";
	struct.launch_after = [];
	if(isdefined(launch_after))
	{
		if(!isdefined(struct.launch_after))
		{
			struct.launch_after = [];
		}
		else if(!isarray(struct.launch_after))
		{
			struct.launch_after = array(struct.launch_after);
		}
		struct.launch_after[struct.launch_after.size] = launch_after;
	}
	struct.end_before = [];
	if(isdefined(end_before))
	{
		struct.end_before = strtok(end_before, ",");
		struct.next = struct.end_before;
	}
	struct.ent_movers = [];
	return struct;
}

/*
	Name: build_objective_tree
	Namespace: skipto
	Checksum: 0x4DF09A09
	Offset: 0x1170
	Size: 0x71C
	Parameters: 0
	Flags: Linked
*/
function build_objective_tree()
{
	foreach(struct in level.skipto_settings)
	{
		if(isdefined(struct.public) && struct.public)
		{
			if(struct.launch_after.size)
			{
				foreach(launch_after in struct.launch_after)
				{
					if(isdefined(level.skipto_settings[launch_after]))
					{
						if(!isinarray(level.skipto_settings[launch_after].next, struct.name))
						{
							if(!isdefined(level.skipto_settings[launch_after].next))
							{
								level.skipto_settings[launch_after].next = [];
							}
							else if(!isarray(level.skipto_settings[launch_after].next))
							{
								level.skipto_settings[launch_after].next = array(level.skipto_settings[launch_after].next);
							}
							level.skipto_settings[launch_after].next[level.skipto_settings[launch_after].next.size] = struct.name;
						}
						continue;
					}
					if(!isdefined(level.skipto_settings["_default"].next))
					{
						level.skipto_settings["_default"].next = [];
					}
					else if(!isarray(level.skipto_settings["_default"].next))
					{
						level.skipto_settings["_default"].next = array(level.skipto_settings["_default"].next);
					}
					level.skipto_settings["_default"].next[level.skipto_settings["_default"].next.size] = struct.name;
				}
			}
			else
			{
				if(!isdefined(level.skipto_settings["_default"].next))
				{
					level.skipto_settings["_default"].next = [];
				}
				else if(!isarray(level.skipto_settings["_default"].next))
				{
					level.skipto_settings["_default"].next = array(level.skipto_settings["_default"].next);
				}
				level.skipto_settings["_default"].next[level.skipto_settings["_default"].next.size] = struct.name;
			}
			foreach(end_before in struct.end_before)
			{
				if(isdefined(level.skipto_settings[end_before]))
				{
					if(!isdefined(level.skipto_settings[end_before].prev))
					{
						level.skipto_settings[end_before].prev = [];
					}
					else if(!isarray(level.skipto_settings[end_before].prev))
					{
						level.skipto_settings[end_before].prev = array(level.skipto_settings[end_before].prev);
					}
					level.skipto_settings[end_before].prev[level.skipto_settings[end_before].prev.size] = struct.name;
				}
			}
		}
	}
	foreach(struct in level.skipto_settings)
	{
		if(isdefined(struct.public) && struct.public)
		{
			if(struct.next.size < 1)
			{
				if(!isdefined(struct.next))
				{
					struct.next = [];
				}
				else if(!isarray(struct.next))
				{
					struct.next = array(struct.next);
				}
				struct.next[struct.next.size] = "_exit";
			}
		}
	}
}

/*
	Name: is_dev
	Namespace: skipto
	Checksum: 0x3AD732F
	Offset: 0x1898
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function is_dev(skipto)
{
	substr = tolower(getsubstr(skipto, 0, 4));
	if(substr == "dev_")
	{
		return true;
	}
	return false;
}

/*
	Name: level_has_skipto_points
	Namespace: skipto
	Checksum: 0x101492EF
	Offset: 0x1900
	Size: 0x22
	Parameters: 0
	Flags: None
*/
function level_has_skipto_points()
{
	return level flag::get("level_has_skiptos");
}

/*
	Name: get_current_skiptos
	Namespace: skipto
	Checksum: 0x5FBED789
	Offset: 0x1930
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function get_current_skiptos()
{
	skiptos = tolower(getskiptos());
	result = strtok(skiptos, ",");
	return result;
}

/*
	Name: handle
	Namespace: skipto
	Checksum: 0x934F972
	Offset: 0x19A0
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function handle()
{
	wait_for_first_player();
	build_objective_tree();
	run_initial_logic();
	skiptos = get_current_skiptos();
	set_level_objective(skiptos, 1);
	while(true)
	{
		level waittill(#"skiptos_changed");
		skiptos = get_current_skiptos();
		set_level_objective(skiptos, 0);
	}
}

/*
	Name: set_cleanup_func
	Namespace: skipto
	Checksum: 0x17E5378
	Offset: 0x1A60
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function set_cleanup_func(func)
{
	level.func_skipto_cleanup = func;
}

/*
	Name: default_skipto
	Namespace: skipto
	Checksum: 0x4A331FDB
	Offset: 0x1A80
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function default_skipto(skipto)
{
	level.default_skipto = skipto;
}

/*
	Name: convert_token
	Namespace: skipto
	Checksum: 0x3CE8A45C
	Offset: 0x1AA0
	Size: 0x108
	Parameters: 3
	Flags: Linked
*/
function convert_token(str, fromtok, totok)
{
	sarray = strtok(str, fromtok);
	ostr = "";
	first = 1;
	foreach(s in sarray)
	{
		if(!first)
		{
			ostr = ostr + totok;
		}
		first = 0;
		ostr = ostr + s;
	}
	return ostr;
}

/*
	Name: load_mission_table
	Namespace: skipto
	Checksum: 0xBC62726F
	Offset: 0x1BB0
	Size: 0x174
	Parameters: 3
	Flags: Linked
*/
function load_mission_table(table, levelname, sublevel = "")
{
	index = 0;
	row = tablelookuprow(table, index);
	while(isdefined(row))
	{
		if(row[0] == levelname && row[1] == sublevel)
		{
			skipto = row[2];
			launch_after = row[3];
			end_before = row[4];
			end_before = convert_token(end_before, "+", ",");
			locstr = row[5];
			add_branch(skipto, &load_mission_init, locstr, undefined, launch_after, end_before);
		}
		index++;
		row = tablelookuprow(table, index);
	}
}

/*
	Name: load_mission_init
	Namespace: skipto
	Checksum: 0x99EC1590
	Offset: 0x1D30
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function load_mission_init()
{
}

/*
	Name: wait_for_first_player
	Namespace: skipto
	Checksum: 0xD45890A5
	Offset: 0x1D40
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function wait_for_first_player()
{
	level flag::wait_till("skipto_player_connected");
}

/*
	Name: watch_players_connect
	Namespace: skipto
	Checksum: 0x7DBC5BF9
	Offset: 0x1D70
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function watch_players_connect()
{
	if(!level flag::exists("skipto_player_connected"))
	{
		level flag::init("skipto_player_connected");
	}
	callback::add_callback(#"hash_da8d7d74", &on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: skipto
	Checksum: 0x1F49FBEC
	Offset: 0x1DE8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function on_player_connect(localclientnum)
{
	level flag::set("skipto_player_connected");
}

/*
	Name: set_level_objective
	Namespace: skipto
	Checksum: 0xC1F392EA
	Offset: 0x1E20
	Size: 0x2A4
	Parameters: 2
	Flags: Linked
*/
function set_level_objective(objectives, starting)
{
	clear_recursion();
	if(starting)
	{
		foreach(objective in objectives)
		{
			if(isdefined(level.skipto_settings[objective]))
			{
				stop_objective_logic(level.skipto_settings[objective].prev, starting);
			}
		}
	}
	else
	{
		foreach(skipto in level.skipto_settings)
		{
			if(isdefined(skipto.objective_running) && skipto.objective_running && !isinarray(objectives, skipto.name))
			{
				stop_objective_logic(skipto.name, starting);
			}
		}
	}
	if(isdefined(level.func_skipto_cleanup))
	{
		foreach(name in objectives)
		{
			thread [[level.func_skipto_cleanup]](name);
		}
	}
	start_objective_logic(objectives, starting);
	level.skipto_point = level.skipto_current_objective[0];
	level notify(#"objective_changed", level.skipto_current_objective);
	level.skipto_current_objective = objectives;
}

/*
	Name: run_initial_logic
	Namespace: skipto
	Checksum: 0x53504FC9
	Offset: 0x20D0
	Size: 0xE6
	Parameters: 1
	Flags: Linked
*/
function run_initial_logic(objectives)
{
	foreach(skipto in level.skipto_settings)
	{
		if(!(isdefined(skipto.logic_running) && skipto.logic_running))
		{
			skipto.logic_running = 1;
			if(isdefined(skipto.logic_func))
			{
				thread [[skipto.logic_func]](skipto.name);
			}
		}
	}
}

/*
	Name: start_objective_logic
	Namespace: skipto
	Checksum: 0x546751AA
	Offset: 0x21C0
	Size: 0x220
	Parameters: 2
	Flags: Linked
*/
function start_objective_logic(name, starting)
{
	if(isarray(name))
	{
		foreach(element in name)
		{
			start_objective_logic(element, starting);
		}
	}
	else if(isdefined(level.skipto_settings[name]))
	{
		if(!(isdefined(level.skipto_settings[name].objective_running) && level.skipto_settings[name].objective_running))
		{
			if(!isinarray(level.skipto_current_objective, name))
			{
				if(!isdefined(level.skipto_current_objective))
				{
					level.skipto_current_objective = [];
				}
				else if(!isarray(level.skipto_current_objective))
				{
					level.skipto_current_objective = array(level.skipto_current_objective);
				}
				level.skipto_current_objective[level.skipto_current_objective.size] = name;
			}
			level notify(name + "_init");
			level.skipto_settings[name].objective_running = 1;
			standard_objective_init(name, starting);
			if(isdefined(level.skipto_settings[name].skipto_func))
			{
				thread [[level.skipto_settings[name].skipto_func]](name, starting);
			}
		}
	}
}

/*
	Name: clear_recursion
	Namespace: skipto
	Checksum: 0x67897D1C
	Offset: 0x23E8
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function clear_recursion()
{
	foreach(skipto in level.skipto_settings)
	{
		skipto.cleanup_recursion = 0;
	}
}

/*
	Name: stop_objective_logic
	Namespace: skipto
	Checksum: 0x43E8B003
	Offset: 0x2478
	Size: 0x2E4
	Parameters: 2
	Flags: Linked
*/
function stop_objective_logic(name, starting)
{
	if(isarray(name))
	{
		foreach(element in name)
		{
			stop_objective_logic(element, starting);
		}
	}
	else if(isdefined(level.skipto_settings[name]))
	{
		cleaned = 0;
		if(isdefined(level.skipto_settings[name].objective_running) && level.skipto_settings[name].objective_running)
		{
			cleaned = 1;
			level.skipto_settings[name].objective_running = 0;
			if(isinarray(level.skipto_current_objective, name))
			{
				arrayremovevalue(level.skipto_current_objective, name);
			}
			if(isdefined(level.skipto_settings[name].cleanup_func))
			{
				thread [[level.skipto_settings[name].cleanup_func]](name, starting);
			}
			standard_objective_done(name, starting);
			level notify(name + "_terminate");
		}
		if(starting && (!(isdefined(level.skipto_settings[name].cleanup_recursion) && level.skipto_settings[name].cleanup_recursion)))
		{
			level.skipto_settings[name].cleanup_recursion = 1;
			stop_objective_logic(level.skipto_settings[name].prev, starting);
			if(!cleaned)
			{
				if(isdefined(level.skipto_settings[name].cleanup_func))
				{
					thread [[level.skipto_settings[name].cleanup_func]](name, starting);
				}
				standard_objective_done(name, starting);
			}
		}
	}
}

/*
	Name: set_last_map_dvar
	Namespace: skipto
	Checksum: 0xD4574B8D
	Offset: 0x2768
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function set_last_map_dvar(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_1df2da04 = getdvarstring("ui_mapname");
	setdvar("last_map", var_1df2da04);
}

/*
	Name: standard_objective_init
	Namespace: skipto
	Checksum: 0x27DDDC59
	Offset: 0x27F0
	Size: 0x14
	Parameters: 2
	Flags: Linked, Private
*/
function private standard_objective_init(objective, starting)
{
}

/*
	Name: standard_objective_done
	Namespace: skipto
	Checksum: 0x281598C5
	Offset: 0x2810
	Size: 0x14
	Parameters: 2
	Flags: Linked, Private
*/
function private standard_objective_done(objective, starting)
{
}

/*
	Name: catch_up_transition
	Namespace: skipto
	Checksum: 0x4FC21311
	Offset: 0x2830
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function catch_up_transition(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	postfx::playpostfxbundle("pstfx_cp_transition_sprite");
}

/*
	Name: function_91c7f6af
	Namespace: skipto
	Checksum: 0xAAE5BFD5
	Offset: 0x2890
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_91c7f6af()
{
	level waittill(#"aar");
	audio::snd_set_snapshot("cmn_aar_screen");
}

