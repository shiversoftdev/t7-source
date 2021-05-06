// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_objectives;
#using scripts\cp\_util;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace cobjective;

/*
	Name: __constructor
	Namespace: cobjective
	Checksum: 0x99EC1590
	Offset: 0x3B0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
}

/*
	Name: init
	Namespace: cobjective
	Checksum: 0xD71AF9BB
	Offset: 0x3C0
	Size: 0x1DC
	Parameters: 3
	Flags: Linked
*/
function init(str_type, a_target_list, b_done = 0)
{
	self.m_a_targets = [];
	self.m_a_game_obj = [];
	self.m_str_type = str_type;
	if(b_done)
	{
		gobj_id = gameobjects::get_next_obj_id();
		self.m_a_game_obj = array(gobj_id);
		objective_add(gobj_id, "done", (0, 0, 0), istring(str_type));
	}
	else if(isdefined(a_target_list) && a_target_list.size > 0)
	{
		foreach(var_e498c241, target in a_target_list)
		{
			add_target(target);
		}
	}
	else
	{
		gobj_id = gameobjects::get_next_obj_id();
		self.m_a_game_obj = array(gobj_id);
		objective_add(gobj_id, "active", (0, 0, 0), istring(str_type));
	}
}

/*
	Name: update_value
	Namespace: cobjective
	Checksum: 0x7B090724
	Offset: 0x5A8
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function update_value(str_menu_data_name, value)
{
	gobj_id = self.m_a_game_obj[0];
	objective_setuimodelvalue(gobj_id, str_menu_data_name, value);
}

/*
	Name: update_counter
	Namespace: cobjective
	Checksum: 0xC55BE099
	Offset: 0x600
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function update_counter(x_val, y_val)
{
	update_value("obj_x", x_val);
	if(isdefined(y_val))
	{
		update_value("obj_y", y_val);
	}
}

/*
	Name: add_target
	Namespace: cobjective
	Checksum: 0x38F22E8A
	Offset: 0x668
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function add_target(target)
{
	if(isinarray(self.m_a_targets, target))
	{
		return;
	}
	gobj_id = undefined;
	if(self.m_a_targets.size < self.m_a_game_obj.size)
	{
		gobj_id = self.m_a_game_obj[self.m_a_game_obj.size - 1];
	}
	else
	{
		gobj_id = gameobjects::get_next_obj_id();
		array::add(self.m_a_game_obj, gobj_id);
	}
	if(isvec(target) || isentity(target))
	{
		objective_add(gobj_id, "active", target, istring(self.m_str_type));
	}
	else
	{
		objective_add(gobj_id, "active", target.origin, istring(self.m_str_type));
	}
	array::add(self.m_a_targets, target);
	/#
		assert(self.m_a_targets.size == self.m_a_game_obj.size);
	#/
}

/*
	Name: complete
	Namespace: cobjective
	Checksum: 0xB18F993A
	Offset: 0x820
	Size: 0x26C
	Parameters: 1
	Flags: Linked
*/
function complete(a_target_or_list)
{
	if(a_target_or_list.size > 0)
	{
		foreach(var_e3bb182, target in a_target_or_list)
		{
			for(i = self.m_a_targets.size - 1; i >= 0; i--)
			{
				if(self.m_a_targets[i] == target)
				{
					objective_state(self.m_a_game_obj[i], "done");
					arrayremoveindex(self.m_a_game_obj, i);
					arrayremoveindex(self.m_a_targets, i);
					break;
				}
			}
		}
	}
	else
	{
		foreach(var_ef795c4e, n_gobj_id in self.m_a_game_obj)
		{
			objective_state(n_gobj_id, "done");
		}
		for(i = self.m_a_targets.size - 1; i >= 0; i--)
		{
			arrayremoveindex(self.m_a_game_obj, i);
			arrayremoveindex(self.m_a_targets, i);
		}
	}
	if(self.m_a_game_obj.size == 0)
	{
		arrayremovevalue(level.a_objectives, self, 1);
	}
}

/*
	Name: hide
	Namespace: cobjective
	Checksum: 0x8B597FFD
	Offset: 0xA98
	Size: 0x162
	Parameters: 1
	Flags: Linked
*/
function hide(e_player)
{
	if(isdefined(e_player))
	{
		/#
			assert(isplayer(e_player), "");
		#/
		foreach(var_88ece713, obj_id in self.m_a_game_obj)
		{
			objective_setinvisibletoplayer(obj_id, e_player);
		}
	}
	else
	{
		foreach(var_984e11ad, obj_id in self.m_a_game_obj)
		{
			objective_setinvisibletoall(obj_id);
		}
	}
}

/*
	Name: show
	Namespace: cobjective
	Checksum: 0x395B10E7
	Offset: 0xC08
	Size: 0x162
	Parameters: 1
	Flags: Linked
*/
function show(e_player)
{
	if(isdefined(e_player))
	{
		/#
			assert(isplayer(e_player), "");
		#/
		foreach(var_d8c9d541, obj_id in self.m_a_game_obj)
		{
			objective_setvisibletoplayer(obj_id, e_player);
		}
	}
	else
	{
		foreach(var_4d4fe28d, obj_id in self.m_a_game_obj)
		{
			objective_setvisibletoall(obj_id);
		}
	}
}

/*
	Name: hide_for_target
	Namespace: cobjective
	Checksum: 0xEA5D996C
	Offset: 0xD78
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function hide_for_target(e_target)
{
	foreach(i, obj_id in self.m_a_game_obj)
	{
		ent = self.m_a_targets[i];
		if(isdefined(ent) && ent == e_target)
		{
			objective_state(obj_id, "invisible");
			return;
		}
	}
}

/*
	Name: show_for_target
	Namespace: cobjective
	Checksum: 0xF39D87D3
	Offset: 0xE50
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function show_for_target(e_target)
{
	foreach(i, obj_id in self.m_a_game_obj)
	{
		ent = self.m_a_targets[i];
		if(isdefined(ent) && ent == e_target)
		{
			objective_state(obj_id, "active");
			return;
		}
	}
}

/*
	Name: get_id_for_target
	Namespace: cobjective
	Checksum: 0xA755AAC
	Offset: 0xF28
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function get_id_for_target(e_target)
{
	foreach(i, obj_id in self.m_a_game_obj)
	{
		ent = self.m_a_targets[i];
		if(isdefined(ent) && ent == e_target)
		{
			return obj_id;
		}
	}
	return -1;
}

/*
	Name: is_breadcrumb
	Namespace: cobjective
	Checksum: 0xE72E69A1
	Offset: 0xFF0
	Size: 0x6
	Parameters: 0
	Flags: Linked
*/
function is_breadcrumb()
{
	return 0;
}

/*
	Name: __destructor
	Namespace: cobjective
	Checksum: 0x99EC1590
	Offset: 0x1000
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
}

#namespace objectives;

/*
	Name: cobjective
	Namespace: objectives
	Checksum: 0x415A5E31
	Offset: 0x1010
	Size: 0x296
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cobjective()
{
	classes.cobjective[0] = spawnstruct();
	classes.cobjective[0].__vtable[1606033458] = &cobjective::__destructor;
	classes.cobjective[0].__vtable[167654991] = &cobjective::is_breadcrumb;
	classes.cobjective[0].__vtable[-379745077] = &cobjective::get_id_for_target;
	classes.cobjective[0].__vtable[-1058346386] = &cobjective::show_for_target;
	classes.cobjective[0].__vtable[1724316027] = &cobjective::hide_for_target;
	classes.cobjective[0].__vtable[1223845734] = &cobjective::show;
	classes.cobjective[0].__vtable[1355607693] = &cobjective::hide;
	classes.cobjective[0].__vtable[835524660] = &cobjective::complete;
	classes.cobjective[0].__vtable[1443065110] = &cobjective::add_target;
	classes.cobjective[0].__vtable[462299743] = &cobjective::update_counter;
	classes.cobjective[0].__vtable[-1714438864] = &cobjective::update_value;
	classes.cobjective[0].__vtable[-1017222485] = &cobjective::init;
	classes.cobjective[0].__vtable[-1690805083] = &cobjective::__constructor;
}

#namespace cbreadcrumbobjective;

/*
	Name: __constructor
	Namespace: cbreadcrumbobjective
	Checksum: 0xD613FFF
	Offset: 0x12B0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	cobjective::__constructor();
}

/*
	Name: init
	Namespace: cbreadcrumbobjective
	Checksum: 0xC2FABE03
	Offset: 0x12D0
	Size: 0x17C
	Parameters: 3
	Flags: Linked
*/
function init(str_type, a_target_list, b_done = 0)
{
	cobjective::init(str_type, a_target_list, b_done);
	self.m_str_first_trig_targetname = "";
	self.m_done = b_done;
	self.m_a_player_game_obj = [];
	for(i = 0; i < 4; i++)
	{
		obj_id = gameobjects::get_next_obj_id();
		self.m_a_player_game_obj[i] = obj_id;
		if(self.m_done)
		{
			objective_add(obj_id, "done", (0, 0, 0), istring(self.m_str_type));
			continue;
		}
		objective_add(obj_id, "empty", (0, 0, 0), istring(self.m_str_type));
	}
	obj_id = self.m_a_game_obj[0];
	objective_setinvisibletoall(obj_id);
}

/*
	Name: complete
	Namespace: cbreadcrumbobjective
	Checksum: 0xED9E6446
	Offset: 0x1458
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function complete(a_target_or_list)
{
	level notify("breadcrumb_" + self.m_str_type + "_complete");
	for(i = 0; i < 4; i++)
	{
		obj_id = self.m_a_player_game_obj[i];
		objective_state(obj_id, "done");
	}
	foreach(var_acd59c19, player in level.players)
	{
		player.v_current_active_breadcrumb = undefined;
	}
	cobjective::complete(a_target_or_list);
}

/*
	Name: hide
	Namespace: cbreadcrumbobjective
	Checksum: 0x811D1AB3
	Offset: 0x1588
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function hide(e_player)
{
	if(isdefined(e_player))
	{
		/#
			assert(isplayer(e_player), "");
		#/
		entnum = e_player getentitynumber();
		obj_id = self.m_a_player_game_obj[entnum];
		objective_setinvisibletoplayer(obj_id, e_player);
	}
	else
	{
		for(i = 0; i < 4; i++)
		{
			obj_id = self.m_a_player_game_obj[i];
			objective_setinvisibletoplayerbyindex(obj_id, i);
		}
	}
}

/*
	Name: show
	Namespace: cbreadcrumbobjective
	Checksum: 0x30F9045
	Offset: 0x1690
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function show(e_player)
{
	if(isdefined(e_player))
	{
		/#
			assert(isplayer(e_player), "");
		#/
		entnum = e_player getentitynumber();
		obj_id = self.m_a_player_game_obj[entnum];
		objective_setvisibletoplayer(obj_id, e_player);
	}
	else
	{
		for(i = 0; i < 4; i++)
		{
			obj_id = self.m_a_player_game_obj[i];
			objective_setvisibletoplayerbyindex(obj_id, i);
		}
	}
}

/*
	Name: start
	Namespace: cbreadcrumbobjective
	Checksum: 0x33D25588
	Offset: 0x1798
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function start(str_trig_targetname)
{
	self.m_str_first_trig_targetname = str_trig_targetname;
	self.m_done = 0;
	foreach(var_289bce9a, player in level.players)
	{
		add_player(player);
	}
}

/*
	Name: add_player
	Namespace: cbreadcrumbobjective
	Checksum: 0x7D679BC9
	Offset: 0x1850
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function add_player(player)
{
	entnum = player getentitynumber();
	obj_id = self.m_a_player_game_obj[entnum];
	objective_setinvisibletoall(obj_id);
	objective_setvisibletoplayer(obj_id, player);
	objective_state(obj_id, "active");
	thread do_player_breadcrumb(player);
}

/*
	Name: set_player_objective
	Namespace: cbreadcrumbobjective
	Checksum: 0xDF5C259E
	Offset: 0x1910
	Size: 0x134
	Parameters: 2
	Flags: Linked, Private
*/
private function set_player_objective(player, target)
{
	entnum = player getentitynumber();
	obj_id = self.m_a_player_game_obj[entnum];
	n_breadcrumb_height = 72;
	v_pos = target;
	if(!isvec(target))
	{
		v_pos = target.origin;
		if(isdefined(target.script_height))
		{
			n_breadcrumb_height = target.script_height;
		}
	}
	v_pos = util::ground_position(v_pos, 300, n_breadcrumb_height);
	player.v_current_active_breadcrumb = v_pos;
	objective_position(obj_id, v_pos);
	objective_state(obj_id, "active");
}

/*
	Name: do_player_breadcrumb
	Namespace: cbreadcrumbobjective
	Checksum: 0xFF77E1AB
	Offset: 0x1A50
	Size: 0x2DC
	Parameters: 1
	Flags: Linked
*/
function do_player_breadcrumb(player)
{
	level endon("breadcrumb_" + self.m_str_type);
	level endon("breadcrumb_" + self.m_str_type + "_complete");
	player endon(#"death");
	str_trig_targetname = self.m_str_first_trig_targetname;
	entnum = player getentitynumber();
	obj_id = self.m_a_player_game_obj[entnum];
	objective_setvisibletoplayer(obj_id, player);
	do
	{
		t_current = getent(str_trig_targetname, "targetname");
		if(isdefined(t_current))
		{
			if(isdefined(t_current.target))
			{
				if(isdefined(t_current.script_flag_true))
				{
					objective_setinvisibletoplayer(obj_id, player);
					level flag::wait_till(t_current.script_flag_true);
					objective_setvisibletoplayer(obj_id, player);
				}
				s_current = struct::get(t_current.target, "targetname");
				if(isdefined(s_current))
				{
					set_player_objective(player, s_current);
				}
				else
				{
					set_player_objective(player, t_current);
				}
			}
			else
			{
				set_player_objective(player, t_current);
			}
			str_trig_targetname = t_current.target;
			t_current trigger::wait_till(undefined, undefined, player);
		}
		else
		{
			str_trig_targetname = undefined;
		}
	}
	while(isdefined(str_trig_targetname));
	objective_setinvisibletoplayer(obj_id, player);
	foreach(var_3f3b212a, player in level.players)
	{
		player.v_current_active_breadcrumb = undefined;
	}
	self.m_done = 1;
}

/*
	Name: is_breadcrumb
	Namespace: cbreadcrumbobjective
	Checksum: 0x3FE0C49D
	Offset: 0x1D38
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function is_breadcrumb()
{
	return 1;
}

/*
	Name: is_done
	Namespace: cbreadcrumbobjective
	Checksum: 0xEF999E9C
	Offset: 0x1D48
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function is_done()
{
	return self.m_done;
}

/*
	Name: __destructor
	Namespace: cbreadcrumbobjective
	Checksum: 0x76F0669B
	Offset: 0x1D60
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
	cobjective::__destructor();
}

#namespace objectives;

/*
	Name: cbreadcrumbobjective
	Namespace: objectives
	Checksum: 0x3055588A
	Offset: 0x1D80
	Size: 0x4D6
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cbreadcrumbobjective()
{
	classes.cbreadcrumbobjective[0] = spawnstruct();
	classes.cbreadcrumbobjective[0].__vtable[1606033458] = &cobjective::__destructor;
	classes.cbreadcrumbobjective[0].__vtable[167654991] = &cobjective::is_breadcrumb;
	classes.cbreadcrumbobjective[0].__vtable[-379745077] = &cobjective::get_id_for_target;
	classes.cbreadcrumbobjective[0].__vtable[-1058346386] = &cobjective::show_for_target;
	classes.cbreadcrumbobjective[0].__vtable[1724316027] = &cobjective::hide_for_target;
	classes.cbreadcrumbobjective[0].__vtable[1223845734] = &cobjective::show;
	classes.cbreadcrumbobjective[0].__vtable[1355607693] = &cobjective::hide;
	classes.cbreadcrumbobjective[0].__vtable[835524660] = &cobjective::complete;
	classes.cbreadcrumbobjective[0].__vtable[1443065110] = &cobjective::add_target;
	classes.cbreadcrumbobjective[0].__vtable[462299743] = &cobjective::update_counter;
	classes.cbreadcrumbobjective[0].__vtable[-1714438864] = &cobjective::update_value;
	classes.cbreadcrumbobjective[0].__vtable[-1017222485] = &cobjective::init;
	classes.cbreadcrumbobjective[0].__vtable[-1690805083] = &cobjective::__constructor;
	classes.cbreadcrumbobjective[0].__vtable[1606033458] = &cbreadcrumbobjective::__destructor;
	classes.cbreadcrumbobjective[0].__vtable[-1590644052] = &cbreadcrumbobjective::is_done;
	classes.cbreadcrumbobjective[0].__vtable[167654991] = &cbreadcrumbobjective::is_breadcrumb;
	classes.cbreadcrumbobjective[0].__vtable[476493010] = &cbreadcrumbobjective::do_player_breadcrumb;
	classes.cbreadcrumbobjective[0].__vtable[-486393183] = &cbreadcrumbobjective::set_player_objective;
	classes.cbreadcrumbobjective[0].__vtable[1544512362] = &cbreadcrumbobjective::add_player;
	classes.cbreadcrumbobjective[0].__vtable[55554463] = &cbreadcrumbobjective::start;
	classes.cbreadcrumbobjective[0].__vtable[1223845734] = &cbreadcrumbobjective::show;
	classes.cbreadcrumbobjective[0].__vtable[1355607693] = &cbreadcrumbobjective::hide;
	classes.cbreadcrumbobjective[0].__vtable[835524660] = &cbreadcrumbobjective::complete;
	classes.cbreadcrumbobjective[0].__vtable[-1017222485] = &cbreadcrumbobjective::init;
	classes.cbreadcrumbobjective[0].__vtable[-1690805083] = &cbreadcrumbobjective::__constructor;
}

/*
	Name: __init__sytem__
	Namespace: objectives
	Checksum: 0xB5C7AB63
	Offset: 0x2260
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("objectives", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: objectives
	Checksum: 0xFFB95EB8
	Offset: 0x22A0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.a_objectives = [];
	level.n_obj_index = 0;
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: set
	Namespace: objectives
	Checksum: 0xE5311779
	Offset: 0x22E8
	Size: 0x1C2
	Parameters: 3
	Flags: Linked
*/
function set(str_obj_type, a_target_or_list, b_breadcrumb)
{
	if(!isdefined(level.a_objectives))
	{
		level.a_objectives = [];
	}
	if(!isdefined(b_breadcrumb))
	{
		b_breadcrumb = 0;
	}
	if(!isdefined(a_target_or_list))
	{
		a_target_or_list = [];
	}
	else if(!isarray(a_target_or_list))
	{
		a_target_or_list = array(a_target_or_list);
	}
	o_objective = undefined;
	if(isdefined(level.a_objectives[str_obj_type]))
	{
		o_objective = level.a_objectives[str_obj_type];
		if(isdefined(a_target_or_list))
		{
			foreach(var_61ca7ae5, target in a_target_or_list)
			{
				[[ o_objective ]]->add_target(target);
			}
		}
	}
	else if(b_breadcrumb)
	{
		object = new cbreadcrumbobjective();
		[[ object ]]->__constructor();
		o_objective = object;
	}
	else
	{
		object = new cobjective();
		[[ object ]]->__constructor();
		o_objective = object;
	}
	[[ o_objective ]]->init(str_obj_type, a_target_or_list);
	level.a_objectives[str_obj_type] = o_objective;
	return o_objective;
}

/*
	Name: complete
	Namespace: objectives
	Checksum: 0x73B7B942
	Offset: 0x24B8
	Size: 0x116
	Parameters: 2
	Flags: Linked
*/
function complete(str_obj_type, a_target_or_list)
{
	if(!isdefined(a_target_or_list))
	{
		a_target_or_list = [];
	}
	else if(!isarray(a_target_or_list))
	{
		a_target_or_list = array(a_target_or_list);
	}
	if(isdefined(level.a_objectives[str_obj_type]))
	{
		o_objective = level.a_objectives[str_obj_type];
		[[ o_objective ]]->complete(a_target_or_list);
	}
	else if(str_obj_type == "cp_waypoint_breadcrumb")
	{
		object = new cbreadcrumbobjective();
		[[ object ]]->__constructor();
		o_objective = object;
	}
	else
	{
		object = new cobjective();
		[[ object ]]->__constructor();
		o_objective = object;
	}
	[[ o_objective ]]->init(str_obj_type, undefined, 1);
	level.a_objectives[str_obj_type] = o_objective;
}

/*
	Name: set_with_counter
	Namespace: objectives
	Checksum: 0x9EBB1B12
	Offset: 0x25D8
	Size: 0xA0
	Parameters: 2
	Flags: None
*/
function set_with_counter(str_obj_id, a_targets)
{
	if(!isdefined(a_targets))
	{
		a_targets = [];
	}
	else if(!isarray(a_targets))
	{
		a_targets = array(a_targets);
	}
	o_obj = set(str_obj_id, a_targets);
	[[ o_obj ]]->update_counter(0, a_targets.size);
}

/*
	Name: update_counter
	Namespace: objectives
	Checksum: 0x3B343737
	Offset: 0x2680
	Size: 0x58
	Parameters: 3
	Flags: None
*/
function update_counter(str_obj_id, x_val, y_val)
{
	o_obj = level.a_objectives[str_obj_id];
	if(isdefined(o_obj))
	{
		[[ o_obj ]]->update_counter(x_val, y_val);
	}
}

/*
	Name: set_value
	Namespace: objectives
	Checksum: 0x3D66A80E
	Offset: 0x26E0
	Size: 0x58
	Parameters: 3
	Flags: None
*/
function set_value(str_obj_id, str_menu_data_name, value)
{
	o_obj = level.a_objectives[str_obj_id];
	if(isdefined(o_obj))
	{
		[[ o_obj ]]->update_value(str_menu_data_name, value);
	}
}

/*
	Name: breadcrumb
	Namespace: objectives
	Checksum: 0xAB32E7AF
	Offset: 0x2740
	Size: 0x114
	Parameters: 3
	Flags: None
*/
function breadcrumb(str_trig_targetname, str_obj_id = "cp_waypoint_breadcrumb", b_complete_on_first_player_finish = 1)
{
	level notify("breadcrumb_" + str_obj_id);
	level endon("breadcrumb_" + str_obj_id);
	if(isdefined(level.a_objectives[str_obj_id]))
	{
		complete(str_obj_id);
	}
	o_objective = set(str_obj_id, undefined, 1);
	[[ o_objective ]]->start(str_trig_targetname);
	while(![[ o_objective ]]->is_done())
	{
		wait(0.05);
	}
	if(b_complete_on_first_player_finish)
	{
		complete(str_obj_id);
	}
}

/*
	Name: hide
	Namespace: objectives
	Checksum: 0x725DDD3B
	Offset: 0x2860
	Size: 0x7C
	Parameters: 2
	Flags: None
*/
function hide(str_obj_type, e_player)
{
	if(isdefined(level.a_objectives[str_obj_type]))
	{
		o_objective = level.a_objectives[str_obj_type];
		[[ o_objective ]]->hide(e_player);
	}
	assert(0, "");
}

/*
	Name: hide_for_target
	Namespace: objectives
	Checksum: 0xA326BCFC
	Offset: 0x28E8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function hide_for_target(str_obj_type, e_target)
{
	if(isdefined(level.a_objectives[str_obj_type]))
	{
		o_objective = level.a_objectives[str_obj_type];
		[[ o_objective ]]->hide_for_target(e_target);
	}
	assert(0, "");
}

/*
	Name: show
	Namespace: objectives
	Checksum: 0xE9C9CE84
	Offset: 0x2970
	Size: 0x7C
	Parameters: 2
	Flags: None
*/
function show(str_obj_type, e_player)
{
	if(isdefined(level.a_objectives[str_obj_type]))
	{
		o_objective = level.a_objectives[str_obj_type];
		[[ o_objective ]]->show(e_player);
	}
	assert(0, "");
}

/*
	Name: show_for_target
	Namespace: objectives
	Checksum: 0xB48BD41
	Offset: 0x29F8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function show_for_target(str_obj_type, e_target)
{
	if(isdefined(level.a_objectives[str_obj_type]))
	{
		o_objective = level.a_objectives[str_obj_type];
		[[ o_objective ]]->show_for_target(e_target);
	}
	assert(0, "");
}

/*
	Name: get_id_for_target
	Namespace: objectives
	Checksum: 0xF1481587
	Offset: 0x2A80
	Size: 0xA0
	Parameters: 2
	Flags: None
*/
function get_id_for_target(str_obj_type, e_target)
{
	id = -1;
	if(isdefined(level.a_objectives[str_obj_type]))
	{
		o_objective = level.a_objectives[str_obj_type];
		id = [[ o_objective ]]->get_id_for_target(e_target);
	}
	if(id < 0)
	{
		/#
			assert(0, "");
		#/
	}
	return id;
}

/*
	Name: event_message
	Namespace: objectives
	Checksum: 0x8FE357EB
	Offset: 0x2B28
	Size: 0xA2
	Parameters: 1
	Flags: None
*/
function event_message(istr_message)
{
	foreach(var_26a0864b, player in level.players)
	{
		util::show_event_message(player, istring(istr_message));
	}
}

/*
	Name: create_temp_icon
	Namespace: objectives
	Checksum: 0x55C2D488
	Offset: 0x2BD8
	Size: 0x1D8
	Parameters: 4
	Flags: None
*/
function create_temp_icon(str_obj_type, str_obj_name, v_pos, v_offset = (0, 0, 0))
{
	switch(str_obj_type)
	{
		case "target":
		{
			str_shader = "waypoint_targetneutral";
			break;
		}
		case "capture":
		{
			str_shader = "waypoint_capture";
			break;
		}
		case "capture_a":
		{
			str_shader = "waypoint_capture_a";
			break;
		}
		case "capture_b":
		{
			str_shader = "waypoint_capture_b";
			break;
		}
		case "capture_c":
		{
			str_shader = "waypoint_capture_c";
			break;
		}
		case "defend":
		{
			str_shader = "waypoint_defend";
			break;
		}
		case "defend_a":
		{
			str_shader = "waypoint_defend_a";
			break;
		}
		case "defend_b":
		{
			str_shader = "waypoint_defend_b";
			break;
		}
		case "defend_c":
		{
			str_shader = "waypoint_defend_c";
			break;
		}
		case "return":
		{
			str_shader = "waypoint_return";
			break;
		}
		default:
		{
			/#
				assertmsg("" + str_obj_type + "");
			#/
			break;
		}
	}
	nextobjpoint = objpoints::create(str_obj_name, v_pos + v_offset, "all", str_shader);
	nextobjpoint setwaypoint(1, str_shader);
	return nextobjpoint;
}

/*
	Name: destroy_temp_icon
	Namespace: objectives
	Checksum: 0xFD79D6B6
	Offset: 0x2DB8
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function destroy_temp_icon()
{
	objpoints::delete(self);
}

/*
	Name: on_player_spawned
	Namespace: objectives
	Checksum: 0x76E69D94
	Offset: 0x2DE0
	Size: 0xBE
	Parameters: 0
	Flags: Linked, Private
*/
private function on_player_spawned()
{
	if(isdefined(level.a_objectives))
	{
		foreach(var_c5e897e5, o_objective in level.a_objectives)
		{
			if([[ o_objective ]]->is_breadcrumb() && !([[ o_objective ]]->is_done()))
			{
				[[ o_objective ]]->add_player(self);
			}
		}
	}
}

