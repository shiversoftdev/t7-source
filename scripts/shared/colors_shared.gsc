// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace colors;

/*
	Name: __init__sytem__
	Namespace: colors
	Checksum: 0x3EC97383
	Offset: 0x3C8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("colors", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: colors
	Checksum: 0x4C6F5581
	Offset: 0x410
	Size: 0x88C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	nodes = getallnodes();
	level flag::init("player_looks_away_from_spawner");
	level flag::init("friendly_spawner_locked");
	level flag::init("respawn_friendlies");
	level.arrays_of_colorcoded_nodes = [];
	level.arrays_of_colorcoded_nodes["axis"] = [];
	level.arrays_of_colorcoded_nodes["allies"] = [];
	level.colorcoded_volumes = [];
	level.colorcoded_volumes["axis"] = [];
	level.colorcoded_volumes["allies"] = [];
	volumes = getentarray("info_volume", "classname");
	for(i = 0; i < nodes.size; i++)
	{
		if(isdefined(nodes[i].script_color_allies))
		{
			nodes[i] add_node_to_global_arrays(nodes[i].script_color_allies, "allies");
		}
		if(isdefined(nodes[i].script_color_axis))
		{
			nodes[i] add_node_to_global_arrays(nodes[i].script_color_axis, "axis");
		}
	}
	for(i = 0; i < volumes.size; i++)
	{
		if(isdefined(volumes[i].script_color_allies))
		{
			volumes[i] add_volume_to_global_arrays(volumes[i].script_color_allies, "allies");
		}
		if(isdefined(volumes[i].script_color_axis))
		{
			volumes[i] add_volume_to_global_arrays(volumes[i].script_color_axis, "axis");
		}
	}
	/#
		level.colornodes_debug_array = [];
		level.colornodes_debug_array[""] = [];
		level.colornodes_debug_array[""] = [];
	#/
	level.color_node_type_function = [];
	add_cover_node("BAD NODE");
	add_cover_node("Cover Stand");
	add_cover_node("Cover Crouch");
	add_cover_node("Cover Prone");
	add_cover_node("Cover Crouch Window");
	add_cover_node("Cover Right");
	add_cover_node("Cover Left");
	add_cover_node("Cover Wide Left");
	add_cover_node("Cover Wide Right");
	add_cover_node("Cover Pillar");
	add_cover_node("Conceal Stand");
	add_cover_node("Conceal Crouch");
	add_cover_node("Conceal Prone");
	add_cover_node("Reacquire");
	add_cover_node("Balcony");
	add_cover_node("Scripted");
	add_cover_node("Begin");
	add_cover_node("End");
	add_cover_node("Turret");
	add_path_node("Guard");
	add_path_node("Exposed");
	add_path_node("Path");
	level.colorlist = [];
	level.colorlist[level.colorlist.size] = "r";
	level.colorlist[level.colorlist.size] = "b";
	level.colorlist[level.colorlist.size] = "y";
	level.colorlist[level.colorlist.size] = "c";
	level.colorlist[level.colorlist.size] = "g";
	level.colorlist[level.colorlist.size] = "p";
	level.colorlist[level.colorlist.size] = "o";
	level.colorchecklist["red"] = "r";
	level.colorchecklist["r"] = "r";
	level.colorchecklist["blue"] = "b";
	level.colorchecklist["b"] = "b";
	level.colorchecklist["yellow"] = "y";
	level.colorchecklist["y"] = "y";
	level.colorchecklist["cyan"] = "c";
	level.colorchecklist["c"] = "c";
	level.colorchecklist["green"] = "g";
	level.colorchecklist["g"] = "g";
	level.colorchecklist["purple"] = "p";
	level.colorchecklist["p"] = "p";
	level.colorchecklist["orange"] = "o";
	level.colorchecklist["o"] = "o";
	level.currentcolorforced = [];
	level.currentcolorforced["allies"] = [];
	level.currentcolorforced["axis"] = [];
	level.lastcolorforced = [];
	level.lastcolorforced["allies"] = [];
	level.lastcolorforced["axis"] = [];
	for(i = 0; i < level.colorlist.size; i++)
	{
		level.arrays_of_colorforced_ai["allies"][level.colorlist[i]] = [];
		level.arrays_of_colorforced_ai["axis"][level.colorlist[i]] = [];
		level.currentcolorforced["allies"][level.colorlist[i]] = undefined;
		level.currentcolorforced["axis"][level.colorlist[i]] = undefined;
	}
	/#
		thread debugdvars();
		thread debugcolorfriendlies();
	#/
}

/*
	Name: __main__
	Namespace: colors
	Checksum: 0x6B06ABF2
	Offset: 0xCA8
	Size: 0xFA
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	foreach(trig in trigger::get_all())
	{
		if(isdefined(trig.script_color_allies))
		{
			trig thread trigger_issues_orders(trig.script_color_allies, "allies");
		}
		if(isdefined(trig.script_color_axis))
		{
			trig thread trigger_issues_orders(trig.script_color_axis, "axis");
		}
	}
}

/*
	Name: debugdvars
	Namespace: colors
	Checksum: 0xAB28E8A0
	Offset: 0xDB0
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function debugdvars()
{
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		while(true)
		{
			if(getdvarint("") > 0)
			{
				thread debug_colornodes();
			}
			wait(0.05);
		}
	#/
}

/*
	Name: get_team_substr
	Namespace: colors
	Checksum: 0xD4742313
	Offset: 0xE50
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function get_team_substr()
{
	/#
		if(self.team == "")
		{
			if(!isdefined(self.node.script_color_allies_old))
			{
				return;
			}
			return self.node.script_color_allies_old;
		}
		if(self.team == "")
		{
			if(!isdefined(self.node.script_color_axis_old))
			{
				return;
			}
			return self.node.script_color_axis_old;
		}
	#/
}

/*
	Name: try_to_draw_line_to_node
	Namespace: colors
	Checksum: 0x3159F7DF
	Offset: 0xED8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function try_to_draw_line_to_node()
{
	/#
		if(!isdefined(self.node))
		{
			return;
		}
		if(!isdefined(self.script_forcecolor))
		{
			return;
		}
		substr = get_team_substr();
		if(!isdefined(substr))
		{
			return;
		}
		if(!issubstr(substr, self.script_forcecolor))
		{
			return;
		}
		recordline(self.origin + vectorscale((0, 0, 1), 25), self.node.origin, _get_debug_color(self.script_forcecolor), "", self);
		line(self.origin + vectorscale((0, 0, 1), 25), self.node.origin, _get_debug_color(self.script_forcecolor));
	#/
}

/*
	Name: _get_debug_color
	Namespace: colors
	Checksum: 0xAE842A2A
	Offset: 0x1008
	Size: 0x126
	Parameters: 1
	Flags: Linked
*/
function _get_debug_color(str_color)
{
	/#
		switch(str_color)
		{
			case "":
			case "":
			{
				return (1, 0, 0);
				break;
			}
			case "":
			case "":
			{
				return (0, 1, 0);
				break;
			}
			case "":
			case "":
			{
				return (0, 0, 1);
				break;
			}
			case "":
			case "":
			{
				return (1, 1, 0);
				break;
			}
			case "":
			case "":
			{
				return (1, 0.5, 0);
				break;
			}
			case "":
			case "":
			{
				return (0, 1, 1);
				break;
			}
			case "":
			case "":
			{
				return (1, 0, 1);
				break;
			}
			default:
			{
				println(("" + str_color) + "");
				return (0, 0, 0);
				break;
			}
		}
	#/
}

/*
	Name: debug_colornodes
	Namespace: colors
	Checksum: 0x6BEB9722
	Offset: 0x1138
	Size: 0x22C
	Parameters: 0
	Flags: Linked
*/
function debug_colornodes()
{
	/#
		array = [];
		array[""] = [];
		array[""] = [];
		array[""] = [];
		foreach(ai in getaiarray())
		{
			if(!isdefined(ai.currentcolorcode))
			{
				continue;
			}
			array[ai.team][ai.currentcolorcode] = 1;
			color = (1, 1, 1);
			if(isdefined(ai.script_forcecolor))
			{
				color = _get_debug_color(ai.script_forcecolor);
			}
			recordenttext(ai.currentcolorcode, ai, color, "");
			print3d(ai.origin + vectorscale((0, 0, 1), 25), ai.currentcolorcode, color, 1, 0.7);
			if(ai.team == "")
			{
				continue;
			}
			ai try_to_draw_line_to_node();
		}
		draw_colornodes(array, "");
		draw_colornodes(array, "");
	#/
}

/*
	Name: draw_colornodes
	Namespace: colors
	Checksum: 0x28B56944
	Offset: 0x1370
	Size: 0x2F8
	Parameters: 2
	Flags: Linked
*/
function draw_colornodes(array, team)
{
	/#
		keys = getarraykeys(array[team]);
		for(i = 0; i < keys.size; i++)
		{
			color = _get_debug_color(getsubstr(keys[i], 0, 1));
			if(isdefined(level.colornodes_debug_array[team][keys[i]]))
			{
				a_team_nodes = level.colornodes_debug_array[team][keys[i]];
				for(p = 0; p < a_team_nodes.size; p++)
				{
					print3d(a_team_nodes[p].origin, "" + keys[i], color, 1, 0.7);
					if(getdvarstring("") == "" && isdefined(a_team_nodes[p].script_color_allies_old))
					{
						if(isdefined(a_team_nodes[p].color_user) && isalive(a_team_nodes[p].color_user) && isdefined(a_team_nodes[p].color_user.script_forcecolor))
						{
							print3d(a_team_nodes[p].origin + (vectorscale((0, 0, -1), 5)), "" + a_team_nodes[p].script_color_allies_old, _get_debug_color(a_team_nodes[p].color_user.script_forcecolor), 0.5, 0.4);
							continue;
						}
						print3d(a_team_nodes[p].origin + (vectorscale((0, 0, -1), 5)), "" + a_team_nodes[p].script_color_allies_old, color, 0.5, 0.4);
					}
				}
			}
		}
	#/
}

/*
	Name: debugcolorfriendlies
	Namespace: colors
	Checksum: 0xDA48F319
	Offset: 0x1670
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function debugcolorfriendlies()
{
	/#
		level.debug_color_friendlies = [];
		level.debug_color_huds = [];
		level thread debugcolorfriendliestogglewatch();
		for(;;)
		{
			level waittill(#"updated_color_friendlies");
			draw_color_friendlies();
		}
	#/
}

/*
	Name: debugcolorfriendliestogglewatch
	Namespace: colors
	Checksum: 0xE0A44F34
	Offset: 0x16D0
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function debugcolorfriendliestogglewatch()
{
	/#
		just_turned_on = 0;
		just_turned_off = 0;
		while(true)
		{
			if(getdvarstring("") == "" && !just_turned_on)
			{
				just_turned_on = 1;
				just_turned_off = 0;
				draw_color_friendlies();
			}
			if(getdvarstring("") != "" && !just_turned_off)
			{
				just_turned_off = 1;
				just_turned_on = 0;
				draw_color_friendlies();
			}
			wait(0.25);
		}
	#/
}

/*
	Name: get_script_palette
	Namespace: colors
	Checksum: 0xB35E26BE
	Offset: 0x17B8
	Size: 0xB6
	Parameters: 0
	Flags: Linked
*/
function get_script_palette()
{
	/#
		rgb = [];
		rgb[""] = (1, 0, 0);
		rgb[""] = (1, 0.5, 0);
		rgb[""] = (1, 1, 0);
		rgb[""] = (0, 1, 0);
		rgb[""] = (0, 1, 1);
		rgb[""] = (0, 0, 1);
		rgb[""] = (1, 0, 1);
		return rgb;
	#/
}

/*
	Name: draw_color_friendlies
	Namespace: colors
	Checksum: 0x2DEF34E6
	Offset: 0x1878
	Size: 0x392
	Parameters: 0
	Flags: Linked
*/
function draw_color_friendlies()
{
	/#
		level endon(#"updated_color_friendlies");
		keys = getarraykeys(level.debug_color_friendlies);
		colored_friendlies = [];
		colors = [];
		colors[colors.size] = "";
		colors[colors.size] = "";
		colors[colors.size] = "";
		colors[colors.size] = "";
		colors[colors.size] = "";
		colors[colors.size] = "";
		colors[colors.size] = "";
		rgb = get_script_palette();
		for(i = 0; i < colors.size; i++)
		{
			colored_friendlies[colors[i]] = 0;
		}
		for(i = 0; i < keys.size; i++)
		{
			color = level.debug_color_friendlies[keys[i]];
			colored_friendlies[color]++;
		}
		for(i = 0; i < level.debug_color_huds.size; i++)
		{
			level.debug_color_huds[i] destroy();
		}
		level.debug_color_huds = [];
		if(getdvarstring("") != "")
		{
			return;
		}
		y = 365;
		for(i = 0; i < colors.size; i++)
		{
			if(colored_friendlies[colors[i]] <= 0)
			{
				continue;
			}
			for(p = 0; p < colored_friendlies[colors[i]]; p++)
			{
				overlay = newhudelem();
				overlay.x = 15 + (25 * p);
				overlay.y = y;
				overlay setshader("", 16, 16);
				overlay.alignx = "";
				overlay.aligny = "";
				overlay.alpha = 1;
				overlay.color = rgb[colors[i]];
				level.debug_color_huds[level.debug_color_huds.size] = overlay;
			}
			y = y + 25;
		}
	#/
}

/*
	Name: player_init_color_grouping
	Namespace: colors
	Checksum: 0x2046CE39
	Offset: 0x1C18
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function player_init_color_grouping()
{
	thread player_color_node();
}

/*
	Name: convert_color_to_short_string
	Namespace: colors
	Checksum: 0xEBF75FC9
	Offset: 0x1C38
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function convert_color_to_short_string()
{
	self.script_forcecolor = level.colorchecklist[self.script_forcecolor];
}

/*
	Name: goto_current_colorindex
	Namespace: colors
	Checksum: 0x86B71F80
	Offset: 0x1C60
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function goto_current_colorindex()
{
	if(!isdefined(self.currentcolorcode))
	{
		return;
	}
	nodes = level.arrays_of_colorcoded_nodes[self.team][self.currentcolorcode];
	if(!isdefined(nodes))
	{
		nodes = [];
	}
	else if(!isarray(nodes))
	{
		nodes = array(nodes);
	}
	nodes[nodes.size] = level.colorcoded_volumes[self.team][self.currentcolorcode];
	self left_color_node();
	if(!isalive(self))
	{
		return;
	}
	if(!has_color())
	{
		return;
	}
	for(i = 0; i < nodes.size; i++)
	{
		node = nodes[i];
		if(isalive(node.color_user) && !isplayer(node.color_user))
		{
			continue;
		}
		self thread ai_sets_goal_with_delay(node);
		thread decrementcolorusers(node);
		return;
	}
	/#
		println(("" + self.export) + "");
	#/
}

/*
	Name: get_color_list
	Namespace: colors
	Checksum: 0x60E0F9EA
	Offset: 0x1E50
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function get_color_list()
{
	colorlist = [];
	colorlist[colorlist.size] = "r";
	colorlist[colorlist.size] = "b";
	colorlist[colorlist.size] = "y";
	colorlist[colorlist.size] = "c";
	colorlist[colorlist.size] = "g";
	colorlist[colorlist.size] = "p";
	colorlist[colorlist.size] = "o";
	return colorlist;
}

/*
	Name: get_colorcodes_from_trigger
	Namespace: colors
	Checksum: 0x48CBC8D6
	Offset: 0x1F00
	Size: 0x256
	Parameters: 2
	Flags: Linked
*/
function get_colorcodes_from_trigger(color_team, team)
{
	colorcodes = strtok(color_team, " ");
	colors = [];
	colorcodesbycolorindex = [];
	usable_colorcodes = [];
	colorlist = get_color_list();
	for(i = 0; i < colorcodes.size; i++)
	{
		color = undefined;
		for(p = 0; p < colorlist.size; p++)
		{
			if(issubstr(colorcodes[i], colorlist[p]))
			{
				color = colorlist[p];
				break;
			}
		}
		if(!isdefined(level.arrays_of_colorcoded_nodes[team][colorcodes[i]]) && !isdefined(level.colorcoded_volumes[team][colorcodes[i]]))
		{
			continue;
		}
		/#
			assert(isdefined(color), (("" + self getorigin()) + "") + colorcodes[i]);
		#/
		colorcodesbycolorindex[color] = colorcodes[i];
		colors[colors.size] = color;
		usable_colorcodes[usable_colorcodes.size] = colorcodes[i];
	}
	colorcodes = usable_colorcodes;
	array = [];
	array["colorCodes"] = colorcodes;
	array["colorCodesByColorIndex"] = colorcodesbycolorindex;
	array["colors"] = colors;
	return array;
}

/*
	Name: trigger_issues_orders
	Namespace: colors
	Checksum: 0xCF2316C6
	Offset: 0x2160
	Size: 0x298
	Parameters: 2
	Flags: Linked
*/
function trigger_issues_orders(color_team, team)
{
	self endon(#"death");
	array = get_colorcodes_from_trigger(color_team, team);
	colorcodes = array["colorCodes"];
	colorcodesbycolorindex = array["colorCodesByColorIndex"];
	colors = array["colors"];
	if(isdefined(self.target))
	{
		a_s_targets = struct::get_array(self.target, "targetname");
		foreach(s_target in a_s_targets)
		{
			if(s_target.script_string === "hero_catch_up")
			{
				if(!isdefined(self.a_s_hero_catch_up))
				{
					self.a_s_hero_catch_up = [];
				}
				if(!isdefined(self.a_s_hero_catch_up))
				{
					self.a_s_hero_catch_up = [];
				}
				else if(!isarray(self.a_s_hero_catch_up))
				{
					self.a_s_hero_catch_up = array(self.a_s_hero_catch_up);
				}
				self.a_s_hero_catch_up[self.a_s_hero_catch_up.size] = s_target;
				if(isdefined(s_target.script_num))
				{
					self.num_hero_catch_up_dist = s_target.script_num;
				}
			}
		}
	}
	for(;;)
	{
		self waittill(#"trigger");
		if(isdefined(self.activated_color_trigger))
		{
			self.activated_color_trigger = undefined;
			continue;
		}
		if(!isdefined(self.color_enabled) || (isdefined(self.color_enabled) && self.color_enabled))
		{
			activate_color_trigger_internal(colorcodes, colors, team, colorcodesbycolorindex);
		}
		trigger_auto_disable();
	}
}

/*
	Name: trigger_auto_disable
	Namespace: colors
	Checksum: 0xC214B5BD
	Offset: 0x2400
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function trigger_auto_disable()
{
	if(!isdefined(self.script_color_stay_on))
	{
		self.script_color_stay_on = 0;
	}
	if(!isdefined(self.color_enabled))
	{
		if(isdefined(self.script_color_stay_on) && self.script_color_stay_on)
		{
			self.color_enabled = 1;
		}
		else
		{
			self.color_enabled = 0;
		}
	}
}

/*
	Name: function_b8457087
	Namespace: colors
	Checksum: 0xF74E22F2
	Offset: 0x2468
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function function_b8457087(team)
{
	if(team == "allies")
	{
		self thread get_colorcodes_and_activate_trigger(self.script_color_allies, team);
	}
	else
	{
		self thread get_colorcodes_and_activate_trigger(self.script_color_axis, team);
	}
}

/*
	Name: get_colorcodes_and_activate_trigger
	Namespace: colors
	Checksum: 0x56246455
	Offset: 0x24D8
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function get_colorcodes_and_activate_trigger(color_team, team)
{
	array = get_colorcodes_from_trigger(color_team, team);
	colorcodes = array["colorCodes"];
	colorcodesbycolorindex = array["colorCodesByColorIndex"];
	colors = array["colors"];
	activate_color_trigger_internal(colorcodes, colors, team, colorcodesbycolorindex);
}

/*
	Name: is_target_visible
	Namespace: colors
	Checksum: 0xA11F33B2
	Offset: 0x2590
	Size: 0x250
	Parameters: 1
	Flags: Linked, Private
*/
function private is_target_visible(target)
{
	n_player_fov = getdvarfloat("cg_fov");
	n_dot_check = cos(n_player_fov);
	v_pos = target;
	if(!isvec(target))
	{
		v_pos = target.origin;
	}
	foreach(player in level.players)
	{
		v_eye = player geteye();
		v_facing = anglestoforward(player getplayerangles());
		v_to_ent = vectornormalize(v_pos - v_eye);
		n_dot = vectordot(v_facing, v_to_ent);
		if(n_dot > n_dot_check)
		{
			return true;
		}
		if(isvec(target))
		{
			a_trace = bullettrace(v_eye, target, 0, player);
			if(a_trace["fraction"] == 1)
			{
				return true;
			}
			continue;
		}
		if(target sightconetrace(v_eye, player) != 0)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: hero_catch_up_teleport
	Namespace: colors
	Checksum: 0xC6FF04F6
	Offset: 0x27E8
	Size: 0x4E8
	Parameters: 4
	Flags: Linked
*/
function hero_catch_up_teleport(s_teleport, n_min_dist_from_player = 400, b_disable_colors = 0, func_callback)
{
	self notify(#"_hero_catch_up_teleport_");
	self endon(#"_hero_catch_up_teleport_");
	self endon(#"stop_hero_catch_up_teleport");
	n_min_player_dist_sq = n_min_dist_from_player * n_min_dist_from_player;
	self endon(#"death");
	a_teleport = s_teleport;
	if(!isdefined(a_teleport))
	{
		a_teleport = [];
	}
	else if(!isarray(a_teleport))
	{
		a_teleport = array(a_teleport);
	}
	a_teleport = array::randomize(a_teleport);
	while(true)
	{
		b_player_nearby = 0;
		foreach(player in level.players)
		{
			if(distancesquared(player.origin, self.origin) < n_min_player_dist_sq)
			{
				b_player_nearby = 1;
				break;
			}
		}
		if(!b_player_nearby)
		{
			n_ai_dist = -1;
			if(isdefined(self.goal))
			{
				n_ai_dist = self calcpathlength(self.node);
			}
			foreach(s in a_teleport)
			{
				if(positionwouldtelefrag(s.origin))
				{
					continue;
				}
				if(isdefined(s.teleport_cooldown))
				{
					if(gettime() < s.teleport_cooldown)
					{
						continue;
					}
				}
				if(self.team == "allies" && isdefined(level.heroes))
				{
					hit_hero = arraygetclosest(s.origin, level.heroes, 16);
					if(isdefined(hit_hero))
					{
						continue;
					}
				}
				if(isdefined(self.node) && n_ai_dist >= 0)
				{
					n_teleport_distance = pathdistance(s.origin, self.node.origin);
					if(n_teleport_distance > n_ai_dist)
					{
						return;
					}
				}
				if(is_target_visible(self))
				{
					continue;
				}
				if(is_target_visible(s.origin))
				{
					continue;
				}
				if(isdefined(self.script_forcecolor) || b_disable_colors)
				{
					if(self forceteleport(s.origin, s.angles, 1, 1))
					{
						self pathmode("move allowed");
						s.teleport_cooldown = gettime() + 2000;
						self notify(#"hero_catch_up_teleport");
						if(b_disable_colors)
						{
							disable();
						}
						else
						{
							self set_force_color(self.script_forcecolor);
						}
						if(isdefined(func_callback))
						{
							self [[func_callback]]();
						}
						return;
					}
				}
			}
		}
		else
		{
			return;
		}
		wait(0.5);
	}
}

/*
	Name: activate_color_trigger_internal
	Namespace: colors
	Checksum: 0xA96C7742
	Offset: 0x2CD8
	Size: 0x4BE
	Parameters: 4
	Flags: Linked
*/
function activate_color_trigger_internal(colorcodes, colors, team, colorcodesbycolorindex)
{
	for(i = 0; i < colorcodes.size; i++)
	{
		if(!isdefined(level.arrays_of_colorcoded_spawners[team][colorcodes[i]]))
		{
			continue;
		}
		arrayremovevalue(level.arrays_of_colorcoded_spawners[team][colorcodes[i]], undefined);
		for(p = 0; p < level.arrays_of_colorcoded_spawners[team][colorcodes[i]].size; p++)
		{
			level.arrays_of_colorcoded_spawners[team][colorcodes[i]][p].currentcolorcode = colorcodes[i];
		}
	}
	for(i = 0; i < colors.size; i++)
	{
		level.arrays_of_colorforced_ai[team][colors[i]] = array::remove_dead(level.arrays_of_colorforced_ai[team][colors[i]]);
		level.lastcolorforced[team][colors[i]] = level.currentcolorforced[team][colors[i]];
		level.currentcolorforced[team][colors[i]] = colorcodesbycolorindex[colors[i]];
		/#
			/#
				assert(isdefined(level.arrays_of_colorcoded_nodes[team][level.currentcolorforced[team][colors[i]]]) || isdefined(level.colorcoded_volumes[team][level.currentcolorforced[team][colors[i]]]), ((("" + colors[i]) + "") + team) + "");
			#/
		#/
	}
	ai_array = [];
	for(i = 0; i < colorcodes.size; i++)
	{
		if(same_color_code_as_last_time(team, colors[i]))
		{
			continue;
		}
		colorcode = colorcodes[i];
		if(!isdefined(level.arrays_of_colorcoded_ai[team][colorcode]))
		{
			continue;
		}
		ai_array[colorcode] = issue_leave_node_order_to_ai_and_get_ai(colorcode, colors[i], team);
		if(isdefined(self.a_s_hero_catch_up) && ai_array.size > 0)
		{
			if(isdefined(ai_array[colorcode]))
			{
				for(j = 0; j < ai_array[colorcode].size; j++)
				{
					ai = ai_array[colorcode][j];
					if(isdefined(ai.is_hero) && ai.is_hero && isdefined(ai.script_forcecolor))
					{
						ai thread hero_catch_up_teleport(self.a_s_hero_catch_up);
					}
				}
			}
		}
	}
	for(i = 0; i < colorcodes.size; i++)
	{
		colorcode = colorcodes[i];
		if(!isdefined(ai_array[colorcode]))
		{
			continue;
		}
		if(same_color_code_as_last_time(team, colors[i]))
		{
			continue;
		}
		if(!isdefined(level.arrays_of_colorcoded_ai[team][colorcode]))
		{
			continue;
		}
		issue_color_order_to_ai(colorcode, colors[i], team, ai_array[colorcode]);
	}
}

/*
	Name: same_color_code_as_last_time
	Namespace: colors
	Checksum: 0xBB58EC24
	Offset: 0x31A0
	Size: 0x58
	Parameters: 2
	Flags: Linked
*/
function same_color_code_as_last_time(team, color)
{
	if(!isdefined(level.lastcolorforced[team][color]))
	{
		return 0;
	}
	return level.lastcolorforced[team][color] == level.currentcolorforced[team][color];
}

/*
	Name: process_cover_node_with_last_in_mind_allies
	Namespace: colors
	Checksum: 0xA992CE5F
	Offset: 0x3200
	Size: 0x6A
	Parameters: 2
	Flags: Linked
*/
function process_cover_node_with_last_in_mind_allies(node, lastcolor)
{
	if(issubstr(node.script_color_allies, lastcolor))
	{
		self.cover_nodes_last[self.cover_nodes_last.size] = node;
	}
	else
	{
		self.cover_nodes_first[self.cover_nodes_first.size] = node;
	}
}

/*
	Name: process_cover_node_with_last_in_mind_axis
	Namespace: colors
	Checksum: 0xAD889497
	Offset: 0x3278
	Size: 0x6A
	Parameters: 2
	Flags: Linked
*/
function process_cover_node_with_last_in_mind_axis(node, lastcolor)
{
	if(issubstr(node.script_color_axis, lastcolor))
	{
		self.cover_nodes_last[self.cover_nodes_last.size] = node;
	}
	else
	{
		self.cover_nodes_first[self.cover_nodes_first.size] = node;
	}
}

/*
	Name: process_cover_node
	Namespace: colors
	Checksum: 0x954AD4F3
	Offset: 0x32F0
	Size: 0x2A
	Parameters: 2
	Flags: Linked
*/
function process_cover_node(node, null)
{
	self.cover_nodes_first[self.cover_nodes_first.size] = node;
}

/*
	Name: process_path_node
	Namespace: colors
	Checksum: 0xD3B398D5
	Offset: 0x3328
	Size: 0x2A
	Parameters: 2
	Flags: Linked
*/
function process_path_node(node, null)
{
	self.path_nodes[self.path_nodes.size] = node;
}

/*
	Name: prioritize_colorcoded_nodes
	Namespace: colors
	Checksum: 0xB1CD1A17
	Offset: 0x3360
	Size: 0x21C
	Parameters: 3
	Flags: Linked
*/
function prioritize_colorcoded_nodes(team, colorcode, color)
{
	nodes = level.arrays_of_colorcoded_nodes[team][colorcode];
	ent = spawnstruct();
	ent.path_nodes = [];
	ent.cover_nodes_first = [];
	ent.cover_nodes_last = [];
	lastcolorforced_exists = isdefined(level.lastcolorforced[team][color]);
	for(i = 0; i < nodes.size; i++)
	{
		node = nodes[i];
		ent [[level.color_node_type_function[node.type][lastcolorforced_exists][team]]](node, level.lastcolorforced[team][color]);
	}
	ent.cover_nodes_first = array::randomize(ent.cover_nodes_first);
	nodes = ent.cover_nodes_first;
	for(i = 0; i < ent.cover_nodes_last.size; i++)
	{
		nodes[nodes.size] = ent.cover_nodes_last[i];
	}
	for(i = 0; i < ent.path_nodes.size; i++)
	{
		nodes[nodes.size] = ent.path_nodes[i];
	}
	level.arrays_of_colorcoded_nodes[team][colorcode] = nodes;
}

/*
	Name: get_prioritized_colorcoded_nodes
	Namespace: colors
	Checksum: 0xD63ADA45
	Offset: 0x3588
	Size: 0x74
	Parameters: 3
	Flags: Linked
*/
function get_prioritized_colorcoded_nodes(team, colorcode, color)
{
	if(isdefined(level.arrays_of_colorcoded_nodes[team][colorcode]))
	{
		return level.arrays_of_colorcoded_nodes[team][colorcode];
	}
	if(isdefined(level.colorcoded_volumes[team][colorcode]))
	{
		return level.colorcoded_volumes[team][colorcode];
	}
}

/*
	Name: issue_leave_node_order_to_ai_and_get_ai
	Namespace: colors
	Checksum: 0x438F74E6
	Offset: 0x3608
	Size: 0x18A
	Parameters: 3
	Flags: Linked
*/
function issue_leave_node_order_to_ai_and_get_ai(colorcode, color, team)
{
	level.arrays_of_colorcoded_ai[team][colorcode] = array::remove_dead(level.arrays_of_colorcoded_ai[team][colorcode]);
	ai = level.arrays_of_colorcoded_ai[team][colorcode];
	ai = arraycombine(ai, level.arrays_of_colorforced_ai[team][color], 1, 0);
	newarray = [];
	for(i = 0; i < ai.size; i++)
	{
		if(isdefined(ai[i].currentcolorcode) && ai[i].currentcolorcode == colorcode)
		{
			continue;
		}
		newarray[newarray.size] = ai[i];
	}
	ai = newarray;
	if(!ai.size)
	{
		return;
	}
	for(i = 0; i < ai.size; i++)
	{
		ai[i] left_color_node();
	}
	return ai;
}

/*
	Name: issue_color_order_to_ai
	Namespace: colors
	Checksum: 0x8B02D036
	Offset: 0x37A0
	Size: 0x228
	Parameters: 4
	Flags: Linked
*/
function issue_color_order_to_ai(colorcode, color, team, ai)
{
	original_ai_array = ai;
	prioritize_colorcoded_nodes(team, colorcode, color);
	nodes = get_prioritized_colorcoded_nodes(team, colorcode, color);
	/#
		level.colornodes_debug_array[team][colorcode] = nodes;
	#/
	/#
		if(nodes.size < ai.size)
		{
			println(((("" + ai.size) + "") + nodes.size) + "");
		}
	#/
	counter = 0;
	ai_count = ai.size;
	for(i = 0; i < nodes.size; i++)
	{
		node = nodes[i];
		if(isalive(node.color_user))
		{
			continue;
		}
		closestai = arraysort(ai, node.origin, 1, 1)[0];
		/#
			assert(isalive(closestai));
		#/
		arrayremovevalue(ai, closestai);
		closestai take_color_node(node, colorcode, self, counter);
		counter++;
		if(!ai.size)
		{
			return;
		}
	}
}

/*
	Name: take_color_node
	Namespace: colors
	Checksum: 0xBF792997
	Offset: 0x39D0
	Size: 0x6C
	Parameters: 4
	Flags: Linked
*/
function take_color_node(node, colorcode, trigger, counter)
{
	self notify(#"stop_color_move");
	self.script_careful = 1;
	self.currentcolorcode = colorcode;
	self thread process_color_order_to_ai(node, trigger, counter);
}

/*
	Name: player_color_node
	Namespace: colors
	Checksum: 0xF04771CF
	Offset: 0x3A48
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function player_color_node()
{
	for(;;)
	{
		playernode = undefined;
		if(!isdefined(self.node))
		{
			wait(0.05);
			continue;
		}
		olduser = self.node.color_user;
		playernode = self.node;
		playernode.color_user = self;
		for(;;)
		{
			if(!isdefined(self.node))
			{
				break;
			}
			if(self.node != playernode)
			{
				break;
			}
			wait(0.05);
		}
		playernode.color_user = undefined;
		playernode color_node_finds_a_user();
	}
}

/*
	Name: color_node_finds_a_user
	Namespace: colors
	Checksum: 0x8C6BB86E
	Offset: 0x3B10
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function color_node_finds_a_user()
{
	if(isdefined(self.script_color_allies))
	{
		color_node_finds_user_from_colorcodes(self.script_color_allies, "allies");
	}
	if(isdefined(self.script_color_axis))
	{
		color_node_finds_user_from_colorcodes(self.script_color_axis, "axis");
	}
}

/*
	Name: color_node_finds_user_from_colorcodes
	Namespace: colors
	Checksum: 0xF6A88993
	Offset: 0x3B80
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function color_node_finds_user_from_colorcodes(colorcodestring, team)
{
	if(isdefined(self.color_user))
	{
		return;
	}
	colorcodes = strtok(colorcodestring, " ");
	array::thread_all_ents(colorcodes, &color_node_finds_user_for_colorcode, team);
}

/*
	Name: color_node_finds_user_for_colorcode
	Namespace: colors
	Checksum: 0x9ABA7A01
	Offset: 0x3BF8
	Size: 0x158
	Parameters: 2
	Flags: Linked
*/
function color_node_finds_user_for_colorcode(colorcode, team)
{
	color = colorcode[0];
	/#
		assert(colorislegit(color), ("" + color) + "");
	#/
	if(!isdefined(level.currentcolorforced[team][color]))
	{
		return;
	}
	if(level.currentcolorforced[team][color] != colorcode)
	{
		return;
	}
	ai = get_force_color_guys(team, color);
	if(!ai.size)
	{
		return;
	}
	for(i = 0; i < ai.size; i++)
	{
		guy = ai[i];
		if(guy occupies_colorcode(colorcode))
		{
			continue;
		}
		guy take_color_node(self, colorcode);
		return;
	}
}

/*
	Name: occupies_colorcode
	Namespace: colors
	Checksum: 0x128D7439
	Offset: 0x3D58
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function occupies_colorcode(colorcode)
{
	if(!isdefined(self.currentcolorcode))
	{
		return 0;
	}
	return self.currentcolorcode == colorcode;
}

/*
	Name: ai_sets_goal_with_delay
	Namespace: colors
	Checksum: 0x699294D6
	Offset: 0x3D88
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function ai_sets_goal_with_delay(node)
{
	self endon(#"death");
	delay = my_current_node_delays();
	if(delay)
	{
		wait(delay);
	}
	ai_sets_goal(node);
}

/*
	Name: ai_sets_goal
	Namespace: colors
	Checksum: 0x4AFC43C
	Offset: 0x3DF0
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function ai_sets_goal(node)
{
	self notify(#"stop_going_to_node");
	set_goal_and_volume(node);
	volume = level.colorcoded_volumes[self.team][self.currentcolorcode];
}

/*
	Name: set_goal_and_volume
	Namespace: colors
	Checksum: 0x631B29E6
	Offset: 0x3E58
	Size: 0x160
	Parameters: 1
	Flags: Linked
*/
function set_goal_and_volume(node)
{
	if(isdefined(self._colors_go_line))
	{
		self notify(#"colors_go_line_done");
		self._colors_go_line = undefined;
	}
	if(isdefined(node.radius) && node.radius)
	{
		self.goalradius = node.radius;
	}
	if(isdefined(node.script_forcegoal) && node.script_forcegoal)
	{
		self thread color_force_goal(node);
	}
	else
	{
		self setgoal(node);
	}
	volume = level.colorcoded_volumes[self.team][self.currentcolorcode];
	if(isdefined(volume))
	{
		self setgoal(volume);
	}
	else
	{
		self clearfixednodesafevolume();
	}
	if(isdefined(node.fixednodesaferadius))
	{
		self.fixednodesaferadius = node.fixednodesaferadius;
	}
	else
	{
		self.fixednodesaferadius = 64;
	}
}

/*
	Name: color_force_goal
	Namespace: colors
	Checksum: 0x5EA659AD
	Offset: 0x3FC0
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function color_force_goal(node)
{
	self endon(#"death");
	self thread ai::force_goal(node, undefined, 1, "stop_color_forcegoal", 1);
	self util::waittill_either("goal", "stop_color_move");
	self notify(#"stop_color_forcegoal");
}

/*
	Name: careful_logic
	Namespace: colors
	Checksum: 0x7CAB48E6
	Offset: 0x4040
	Size: 0x98
	Parameters: 2
	Flags: None
*/
function careful_logic(node, volume)
{
	self endon(#"death");
	self endon(#"stop_being_careful");
	self endon(#"stop_going_to_node");
	thread recover_from_careful_disable(node);
	for(;;)
	{
		wait_until_an_enemy_is_in_safe_area(node, volume);
		use_big_goal_until_goal_is_safe(node, volume);
		set_goal_and_volume(node);
	}
}

/*
	Name: recover_from_careful_disable
	Namespace: colors
	Checksum: 0x1DC9AA72
	Offset: 0x40E0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function recover_from_careful_disable(node)
{
	self endon(#"death");
	self endon(#"stop_going_to_node");
	self waittill(#"stop_being_careful");
	set_goal_and_volume(node);
}

/*
	Name: use_big_goal_until_goal_is_safe
	Namespace: colors
	Checksum: 0x949F8A42
	Offset: 0x4130
	Size: 0xDA
	Parameters: 2
	Flags: Linked
*/
function use_big_goal_until_goal_is_safe(node, volume)
{
	self.goalradius = 1024;
	self setgoal(self.origin);
	if(isdefined(volume))
	{
		for(;;)
		{
			wait(1);
			if(self isknownenemyinradius(node.origin, self.fixednodesaferadius))
			{
				continue;
			}
			if(self isknownenemyinvolume(volume))
			{
				continue;
			}
			return;
		}
	}
	else
	{
		for(;;)
		{
			if(!self isknownenemyinradius(node.origin, self.fixednodesaferadius))
			{
				return;
			}
			wait(1);
		}
	}
}

/*
	Name: wait_until_an_enemy_is_in_safe_area
	Namespace: colors
	Checksum: 0x688E6159
	Offset: 0x4218
	Size: 0xAA
	Parameters: 2
	Flags: Linked
*/
function wait_until_an_enemy_is_in_safe_area(node, volume)
{
	if(isdefined(volume))
	{
		for(;;)
		{
			if(self isknownenemyinradius(node.origin, self.fixednodesaferadius))
			{
				return;
			}
			if(self isknownenemyinvolume(volume))
			{
				return;
			}
			wait(1);
		}
	}
	else
	{
		for(;;)
		{
			if(self isknownenemyinradius(node.origin, self.fixednodesaferadius))
			{
				return;
			}
			wait(1);
		}
	}
}

/*
	Name: my_current_node_delays
	Namespace: colors
	Checksum: 0xEEA81BFB
	Offset: 0x42D0
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function my_current_node_delays()
{
	if(!isdefined(self.node))
	{
		return 0;
	}
	return self.node util::script_delay();
}

/*
	Name: process_color_order_to_ai
	Namespace: colors
	Checksum: 0x3502A90D
	Offset: 0x4308
	Size: 0x218
	Parameters: 3
	Flags: Linked
*/
function process_color_order_to_ai(node, trigger, counter)
{
	thread decrementcolorusers(node);
	self endon(#"stop_color_move");
	self endon(#"death");
	if(isdefined(trigger))
	{
		trigger util::script_delay();
	}
	if(isdefined(trigger))
	{
		if(isdefined(trigger.script_flag_wait))
		{
			level flag::wait_till(trigger.script_flag_wait);
		}
	}
	if(!my_current_node_delays())
	{
		if(isdefined(counter))
		{
			wait(counter * randomfloatrange(0.2, 0.35));
		}
	}
	self ai_sets_goal(node);
	self.color_ordered_node_assignment = node;
	for(;;)
	{
		self waittill(#"node_taken", taker);
		if(taker == self)
		{
			wait(0.05);
		}
		node = get_best_available_new_colored_node();
		if(isdefined(node))
		{
			/#
				assert(!isalive(node.color_user), "");
			#/
			if(isalive(self.color_node.color_user) && self.color_node.color_user == self)
			{
				self.color_node.color_user = undefined;
			}
			self.color_node = node;
			node.color_user = self;
			self ai_sets_goal(node);
		}
	}
}

/*
	Name: get_best_available_colored_node
	Namespace: colors
	Checksum: 0x1F05508E
	Offset: 0x4528
	Size: 0x16C
	Parameters: 0
	Flags: None
*/
function get_best_available_colored_node()
{
	/#
		assert(self.team != "");
	#/
	/#
		assert(isdefined(self.script_forcecolor), ("" + self.export) + "");
	#/
	colorcode = level.currentcolorforced[self.team][self.script_forcecolor];
	nodes = get_prioritized_colorcoded_nodes(self.team, colorcode, self.script_forcecolor);
	/#
		assert(nodes.size > 0, ((("" + self.export) + "") + self.script_forcecolor) + "");
	#/
	for(i = 0; i < nodes.size; i++)
	{
		if(!isalive(nodes[i].color_user))
		{
			return nodes[i];
		}
	}
}

/*
	Name: get_best_available_new_colored_node
	Namespace: colors
	Checksum: 0x47D06455
	Offset: 0x46A0
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function get_best_available_new_colored_node()
{
	/#
		assert(self.team != "");
	#/
	/#
		assert(isdefined(self.script_forcecolor), ("" + self.export) + "");
	#/
	colorcode = level.currentcolorforced[self.team][self.script_forcecolor];
	nodes = get_prioritized_colorcoded_nodes(self.team, colorcode, self.script_forcecolor);
	/#
		assert(nodes.size > 0, ((("" + self.export) + "") + self.script_forcecolor) + "");
	#/
	nodes = arraysort(nodes, self.origin);
	for(i = 0; i < nodes.size; i++)
	{
		if(!isalive(nodes[i].color_user))
		{
			return nodes[i];
		}
	}
}

/*
	Name: process_stop_short_of_node
	Namespace: colors
	Checksum: 0x598D226E
	Offset: 0x4838
	Size: 0xD4
	Parameters: 1
	Flags: None
*/
function process_stop_short_of_node(node)
{
	self endon(#"stopscript");
	self endon(#"death");
	if(isdefined(self.node))
	{
		return;
	}
	if(distancesquared(node.origin, self.origin) < 1024)
	{
		reached_node_but_could_not_claim_it(node);
		return;
	}
	currenttime = gettime();
	wait_for_killanimscript_or_time(1);
	newtime = gettime();
	if((newtime - currenttime) >= 1000)
	{
		reached_node_but_could_not_claim_it(node);
	}
}

/*
	Name: wait_for_killanimscript_or_time
	Namespace: colors
	Checksum: 0x879D3279
	Offset: 0x4918
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function wait_for_killanimscript_or_time(timer)
{
	self endon(#"killanimscript");
	wait(timer);
}

/*
	Name: reached_node_but_could_not_claim_it
	Namespace: colors
	Checksum: 0x9572631E
	Offset: 0x4940
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function reached_node_but_could_not_claim_it(node)
{
	ai = getaiarray();
	for(i = 0; i < ai.size; i++)
	{
		if(!isdefined(ai[i].node))
		{
			continue;
		}
		if(ai[i].node != node)
		{
			continue;
		}
		ai[i] notify(#"eject_from_my_node");
		wait(1);
		self notify(#"eject_from_my_node");
		return true;
	}
	return false;
}

/*
	Name: decrementcolorusers
	Namespace: colors
	Checksum: 0xB91058F5
	Offset: 0x4A08
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function decrementcolorusers(node)
{
	node.color_user = self;
	self.color_node = node;
	/#
		self.color_node_debug_val = 1;
	#/
	self endon(#"stop_color_move");
	self waittill(#"death");
	self.color_node.color_user = undefined;
}

/*
	Name: colorislegit
	Namespace: colors
	Checksum: 0x5391E178
	Offset: 0x4A70
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function colorislegit(color)
{
	for(i = 0; i < level.colorlist.size; i++)
	{
		if(color == level.colorlist[i])
		{
			return true;
		}
	}
	return false;
}

/*
	Name: add_volume_to_global_arrays
	Namespace: colors
	Checksum: 0xF7AB04A3
	Offset: 0x4AD0
	Size: 0xCA
	Parameters: 2
	Flags: Linked
*/
function add_volume_to_global_arrays(colorcode, team)
{
	colors = strtok(colorcode, " ");
	for(p = 0; p < colors.size; p++)
	{
		/#
			assert(!isdefined(level.colorcoded_volumes[team][colors[p]]), "" + colors[p]);
		#/
		level.colorcoded_volumes[team][colors[p]] = self;
	}
}

/*
	Name: add_node_to_global_arrays
	Namespace: colors
	Checksum: 0x2BEDC8ED
	Offset: 0x4BA8
	Size: 0x1EE
	Parameters: 2
	Flags: Linked
*/
function add_node_to_global_arrays(colorcode, team)
{
	self.color_user = undefined;
	colors = strtok(colorcode, " ");
	for(p = 0; p < colors.size; p++)
	{
		if(isdefined(level.arrays_of_colorcoded_nodes[team]) && isdefined(level.arrays_of_colorcoded_nodes[team][colors[p]]))
		{
			if(!isdefined(level.arrays_of_colorcoded_nodes[team][colors[p]]))
			{
				level.arrays_of_colorcoded_nodes[team][colors[p]] = [];
			}
			else if(!isarray(level.arrays_of_colorcoded_nodes[team][colors[p]]))
			{
				level.arrays_of_colorcoded_nodes[team][colors[p]] = array(level.arrays_of_colorcoded_nodes[team][colors[p]]);
			}
			level.arrays_of_colorcoded_nodes[team][colors[p]][level.arrays_of_colorcoded_nodes[team][colors[p]].size] = self;
			continue;
		}
		level.arrays_of_colorcoded_nodes[team][colors[p]][0] = self;
		level.arrays_of_colorcoded_ai[team][colors[p]] = [];
		level.arrays_of_colorcoded_spawners[team][colors[p]] = [];
	}
}

/*
	Name: left_color_node
	Namespace: colors
	Checksum: 0xEB920D3F
	Offset: 0x4DA0
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function left_color_node()
{
	/#
		self.color_node_debug_val = undefined;
	#/
	if(!isdefined(self.color_node))
	{
		return;
	}
	if(isdefined(self.color_node.color_user) && self.color_node.color_user == self)
	{
		self.color_node.color_user = undefined;
	}
	self.color_node = undefined;
	self notify(#"stop_color_move");
}

/*
	Name: getcolornumberarray
	Namespace: colors
	Checksum: 0x3FC1753C
	Offset: 0x4E20
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function getcolornumberarray()
{
	array = [];
	if(issubstr(self.classname, "axis") || issubstr(self.classname, "enemy"))
	{
		array["team"] = "axis";
		array["colorTeam"] = self.script_color_axis;
	}
	if(issubstr(self.classname, "ally") || issubstr(self.classname, "civilian"))
	{
		array["team"] = "allies";
		array["colorTeam"] = self.script_color_allies;
	}
	if(!isdefined(array["colorTeam"]))
	{
		array = undefined;
	}
	return array;
}

/*
	Name: removespawnerfromcolornumberarray
	Namespace: colors
	Checksum: 0x6BBA5EDC
	Offset: 0x4F40
	Size: 0xDE
	Parameters: 0
	Flags: None
*/
function removespawnerfromcolornumberarray()
{
	colornumberarray = getcolornumberarray();
	if(!isdefined(colornumberarray))
	{
		return;
	}
	team = colornumberarray["team"];
	colorteam = colornumberarray["colorTeam"];
	colors = strtok(colorteam, " ");
	for(i = 0; i < colors.size; i++)
	{
		arrayremovevalue(level.arrays_of_colorcoded_spawners[team][colors[i]], self);
	}
}

/*
	Name: add_cover_node
	Namespace: colors
	Checksum: 0xD01E9457
	Offset: 0x5028
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function add_cover_node(type)
{
	level.color_node_type_function[type][1]["allies"] = &process_cover_node_with_last_in_mind_allies;
	level.color_node_type_function[type][1]["axis"] = &process_cover_node_with_last_in_mind_axis;
	level.color_node_type_function[type][0]["allies"] = &process_cover_node;
	level.color_node_type_function[type][0]["axis"] = &process_cover_node;
}

/*
	Name: add_path_node
	Namespace: colors
	Checksum: 0xB494F2A
	Offset: 0x50F0
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function add_path_node(type)
{
	level.color_node_type_function[type][1]["allies"] = &process_path_node;
	level.color_node_type_function[type][0]["allies"] = &process_path_node;
	level.color_node_type_function[type][1]["axis"] = &process_path_node;
	level.color_node_type_function[type][0]["axis"] = &process_path_node;
}

/*
	Name: colornode_spawn_reinforcement
	Namespace: colors
	Checksum: 0x5598015E
	Offset: 0x51B8
	Size: 0x300
	Parameters: 2
	Flags: Linked
*/
function colornode_spawn_reinforcement(classname, fromcolor)
{
	level endon(#"kill_color_replacements");
	friendly_spawners_type = getclasscolorhash(classname, fromcolor);
	while(level.friendly_spawners_types[friendly_spawners_type] > 0)
	{
		spawn = undefined;
		for(;;)
		{
			if(!level flag::get("respawn_friendlies"))
			{
				if(!isdefined(level.friendly_respawn_vision_checker_thread))
				{
					thread friendly_spawner_vision_checker();
				}
				for(;;)
				{
					level flag::wait_till_any(array("player_looks_away_from_spawner", "respawn_friendlies"));
					level flag::wait_till_clear("friendly_spawner_locked");
					if(level flag::get("player_looks_away_from_spawner") || level flag::get("respawn_friendlies"))
					{
						break;
					}
				}
				level flag::set("friendly_spawner_locked");
			}
			spawner = get_color_spawner(classname, fromcolor);
			spawner.count = 1;
			level.friendly_spawners_types[friendly_spawners_type] = level.friendly_spawners_types[friendly_spawners_type] - 1;
			spawner util::script_wait();
			spawn = spawner spawner::spawn();
			if(spawner::spawn_failed(spawn))
			{
				thread lock_spawner_for_awhile();
				wait(1);
				continue;
			}
			level notify(#"reinforcement_spawned", spawn);
			break;
		}
		for(;;)
		{
			if(!isdefined(fromcolor))
			{
				break;
			}
			if(get_color_from_order(fromcolor, level.current_color_order) == "none")
			{
				break;
			}
			fromcolor = level.current_color_order[fromcolor];
		}
		if(isdefined(fromcolor))
		{
			spawn set_force_color(fromcolor);
		}
		thread lock_spawner_for_awhile();
		if(isdefined(level.friendly_startup_thread))
		{
			spawn thread [[level.friendly_startup_thread]]();
		}
		spawn thread colornode_replace_on_death();
	}
}

/*
	Name: colornode_replace_on_death
	Namespace: colors
	Checksum: 0x6CD84B2
	Offset: 0x54C0
	Size: 0x3B4
	Parameters: 0
	Flags: Linked
*/
function colornode_replace_on_death()
{
	level endon(#"kill_color_replacements");
	/#
		assert(isalive(self), "");
	#/
	self endon(#"_disable_reinforcement");
	if(self.team == "axis")
	{
		return;
	}
	if(isdefined(self.replace_on_death))
	{
		return;
	}
	self.replace_on_death = 1;
	/#
		assert(!isdefined(self.respawn_on_death), ("" + self.export) + "");
	#/
	classname = self.classname;
	color = self.script_forcecolor;
	waittillframeend();
	if(isalive(self))
	{
		self waittill(#"death");
	}
	color_order = level.current_color_order;
	if(!isdefined(self.script_forcecolor))
	{
		return;
	}
	friendly_spawners_type = getclasscolorhash(classname, self.script_forcecolor);
	if(!isdefined(level.friendly_spawners_types) || !isdefined(level.friendly_spawners_types[friendly_spawners_type]) || level.friendly_spawners_types[friendly_spawners_type] <= 0)
	{
		level.friendly_spawners_types[friendly_spawners_type] = 1;
		thread colornode_spawn_reinforcement(classname, self.script_forcecolor);
	}
	else
	{
		level.friendly_spawners_types[friendly_spawners_type] = level.friendly_spawners_types[friendly_spawners_type] + 1;
	}
	if(isdefined(self) && isdefined(self.script_forcecolor))
	{
		color = self.script_forcecolor;
	}
	if(isdefined(self) && isdefined(self.origin))
	{
		origin = self.origin;
	}
	for(;;)
	{
		if(get_color_from_order(color, color_order) == "none")
		{
			return;
		}
		correct_colored_friendlies = get_force_color_guys("allies", color_order[color]);
		correct_colored_friendlies = array::filter_classname(correct_colored_friendlies, 1, classname);
		if(!correct_colored_friendlies.size)
		{
			wait(2);
			continue;
		}
		players = getplayers();
		correct_colored_guy = arraysort(correct_colored_friendlies, players[0].origin, 1)[0];
		/#
			assert(correct_colored_guy.script_forcecolor != color, ("" + color) + "");
		#/
		waittillframeend();
		if(!isalive(correct_colored_guy))
		{
			continue;
		}
		correct_colored_guy set_force_color(color);
		if(isdefined(level.friendly_promotion_thread))
		{
			correct_colored_guy [[level.friendly_promotion_thread]](color);
		}
		color = color_order[color];
	}
}

/*
	Name: get_color_from_order
	Namespace: colors
	Checksum: 0x3434303D
	Offset: 0x5880
	Size: 0x5E
	Parameters: 2
	Flags: Linked
*/
function get_color_from_order(color, color_order)
{
	if(!isdefined(color))
	{
		return "none";
	}
	if(!isdefined(color_order))
	{
		return "none";
	}
	if(!isdefined(color_order[color]))
	{
		return "none";
	}
	return color_order[color];
}

/*
	Name: friendly_spawner_vision_checker
	Namespace: colors
	Checksum: 0x8A737BCD
	Offset: 0x58E8
	Size: 0x230
	Parameters: 0
	Flags: Linked
*/
function friendly_spawner_vision_checker()
{
	level.friendly_respawn_vision_checker_thread = 1;
	successes = 0;
	for(;;)
	{
		level flag::wait_till_clear("respawn_friendlies");
		wait(1);
		if(!isdefined(level.respawn_spawner))
		{
			continue;
		}
		spawner = level.respawn_spawner;
		players = getplayers();
		player_sees_spawner = 0;
		for(q = 0; q < players.size; q++)
		{
			difference_vec = players[q].origin - spawner.origin;
			if(length(difference_vec) < 200)
			{
				player_sees_spawner();
				player_sees_spawner = 1;
				break;
			}
			forward = anglestoforward((0, players[q] getplayerangles()[1], 0));
			difference = vectornormalize(difference_vec);
			dot = vectordot(forward, difference);
			if(dot < 0.2)
			{
				player_sees_spawner();
				player_sees_spawner = 1;
				break;
			}
			successes++;
			if(successes < 3)
			{
				continue;
			}
		}
		if(player_sees_spawner)
		{
			continue;
		}
		level flag::set("player_looks_away_from_spawner");
	}
}

/*
	Name: get_color_spawner
	Namespace: colors
	Checksum: 0xE032E8F3
	Offset: 0x5B20
	Size: 0x284
	Parameters: 2
	Flags: Linked
*/
function get_color_spawner(classname, fromcolor)
{
	specificfromcolor = 0;
	if(isdefined(level.respawn_spawners_specific) && isdefined(level.respawn_spawners_specific[fromcolor]))
	{
		specificfromcolor = 1;
	}
	if(!isdefined(level.respawn_spawner))
	{
		if(!isdefined(fromcolor) || !specificfromcolor)
		{
			/#
				assertmsg("");
			#/
		}
	}
	if(!isdefined(classname))
	{
		if(isdefined(fromcolor) && specificfromcolor)
		{
			return level.respawn_spawners_specific[fromcolor];
		}
		return level.respawn_spawner;
	}
	spawners = getentarray("color_spawner", "targetname");
	class_spawners = [];
	for(i = 0; i < spawners.size; i++)
	{
		class_spawners[spawners[i].classname] = spawners[i];
	}
	spawner = undefined;
	keys = getarraykeys(class_spawners);
	for(i = 0; i < keys.size; i++)
	{
		if(!issubstr(class_spawners[keys[i]].classname, classname))
		{
			continue;
		}
		spawner = class_spawners[keys[i]];
		break;
	}
	if(!isdefined(spawner))
	{
		if(isdefined(fromcolor) && specificfromcolor)
		{
			return level.respawn_spawners_specific[fromcolor];
		}
		return level.respawn_spawner;
	}
	if(isdefined(fromcolor) && specificfromcolor)
	{
		spawner.origin = level.respawn_spawners_specific[fromcolor].origin;
	}
	else
	{
		spawner.origin = level.respawn_spawner.origin;
	}
	return spawner;
}

/*
	Name: getclasscolorhash
	Namespace: colors
	Checksum: 0xDD9C0F0B
	Offset: 0x5DB0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function getclasscolorhash(classname, fromcolor)
{
	classcolorhash = classname;
	if(isdefined(fromcolor))
	{
		classcolorhash = classcolorhash + ("##" + fromcolor);
	}
	return classcolorhash;
}

/*
	Name: lock_spawner_for_awhile
	Namespace: colors
	Checksum: 0x1099FB02
	Offset: 0x5E08
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function lock_spawner_for_awhile()
{
	level flag::set("friendly_spawner_locked");
	wait(2);
	level flag::clear("friendly_spawner_locked");
}

/*
	Name: player_sees_spawner
	Namespace: colors
	Checksum: 0x9BC18E48
	Offset: 0x5E58
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function player_sees_spawner()
{
	level flag::clear("player_looks_away_from_spawner");
}

/*
	Name: kill_color_replacements
	Namespace: colors
	Checksum: 0x87E38CF3
	Offset: 0x5E88
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function kill_color_replacements()
{
	level flag::clear("friendly_spawner_locked");
	level notify(#"kill_color_replacements");
	level.friendly_spawners_types = undefined;
	ai = getaiarray();
	array::thread_all(ai, &remove_replace_on_death);
}

/*
	Name: remove_replace_on_death
	Namespace: colors
	Checksum: 0xCDA5C060
	Offset: 0x5F10
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function remove_replace_on_death()
{
	self.replace_on_death = undefined;
}

/*
	Name: set_force_color
	Namespace: colors
	Checksum: 0x13DFBB31
	Offset: 0x5F28
	Size: 0x264
	Parameters: 1
	Flags: Linked
*/
function set_force_color(_color)
{
	color = shortencolor(_color);
	/#
		assert(colorislegit(color), "" + color);
	#/
	if(!isactor(self))
	{
		set_force_color_spawner(color);
		return;
	}
	/#
		assert(isalive(self), "");
	#/
	self.fixednodesaferadius = 64;
	self.script_color_axis = undefined;
	self.script_color_allies = undefined;
	self.old_forcecolor = undefined;
	if(isdefined(self.script_forcecolor))
	{
		arrayremovevalue(level.arrays_of_colorforced_ai[self.team][self.script_forcecolor], self);
	}
	self.script_forcecolor = color;
	if(!isdefined(level.arrays_of_colorforced_ai[self.team][self.script_forcecolor]))
	{
		level.arrays_of_colorforced_ai[self.team][self.script_forcecolor] = [];
	}
	else if(!isarray(level.arrays_of_colorforced_ai[self.team][self.script_forcecolor]))
	{
		level.arrays_of_colorforced_ai[self.team][self.script_forcecolor] = array(level.arrays_of_colorforced_ai[self.team][self.script_forcecolor]);
	}
	level.arrays_of_colorforced_ai[self.team][self.script_forcecolor][level.arrays_of_colorforced_ai[self.team][self.script_forcecolor].size] = self;
	level thread remove_colorforced_ai_when_dead(self);
	self thread new_color_being_set(color);
}

/*
	Name: remove_colorforced_ai_when_dead
	Namespace: colors
	Checksum: 0x19A53544
	Offset: 0x6198
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function remove_colorforced_ai_when_dead(ai)
{
	script_forcecolor = ai.script_forcecolor;
	team = ai.team;
	ai waittill(#"death");
	level.arrays_of_colorforced_ai[team][script_forcecolor] = array::remove_undefined(level.arrays_of_colorforced_ai[team][script_forcecolor]);
}

/*
	Name: shortencolor
	Namespace: colors
	Checksum: 0xC3A921A5
	Offset: 0x6228
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function shortencolor(color)
{
	/#
		assert(isdefined(level.colorchecklist[tolower(color)]), "" + color);
	#/
	return level.colorchecklist[tolower(color)];
}

/*
	Name: set_force_color_spawner
	Namespace: colors
	Checksum: 0xE93A8079
	Offset: 0x62A0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function set_force_color_spawner(color)
{
	self.script_forcecolor = color;
	self.old_forcecolor = undefined;
}

/*
	Name: new_color_being_set
	Namespace: colors
	Checksum: 0x86E0B71E
	Offset: 0x62D0
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function new_color_being_set(color)
{
	self notify(#"new_color_being_set");
	self.new_force_color_being_set = 1;
	left_color_node();
	self endon(#"new_color_being_set");
	self endon(#"death");
	waittillframeend();
	waittillframeend();
	if(isdefined(self.script_forcecolor))
	{
		self.currentcolorcode = level.currentcolorforced[self.team][self.script_forcecolor];
		self thread goto_current_colorindex();
	}
	self.new_force_color_being_set = undefined;
	self notify(#"done_setting_new_color");
	/#
		update_debug_friendlycolor();
	#/
}

/*
	Name: update_debug_friendlycolor_on_death
	Namespace: colors
	Checksum: 0x5E5836F0
	Offset: 0x63A8
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function update_debug_friendlycolor_on_death()
{
	self notify(#"debug_color_update");
	self endon(#"debug_color_update");
	self waittill(#"death");
	/#
		a_keys = getarraykeys(level.debug_color_friendlies);
		foreach(n_key in a_keys)
		{
			ai = getentbynum(n_key);
			if(!isalive(ai))
			{
				arrayremoveindex(level.debug_color_friendlies, n_key, 1);
			}
		}
	#/
	level notify(#"updated_color_friendlies");
}

/*
	Name: update_debug_friendlycolor
	Namespace: colors
	Checksum: 0xF336FAC5
	Offset: 0x64D8
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function update_debug_friendlycolor()
{
	self thread update_debug_friendlycolor_on_death();
	if(isdefined(self.script_forcecolor))
	{
		level.debug_color_friendlies[self getentitynumber()] = self.script_forcecolor;
	}
	else
	{
		level.debug_color_friendlies[self getentitynumber()] = undefined;
	}
	level notify(#"updated_color_friendlies");
}

/*
	Name: has_color
	Namespace: colors
	Checksum: 0x939A5164
	Offset: 0x6560
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function has_color()
{
	if(self.team == "axis")
	{
		return isdefined(self.script_color_axis) || isdefined(self.script_forcecolor);
	}
	return isdefined(self.script_color_allies) || isdefined(self.script_forcecolor);
}

/*
	Name: get_force_color
	Namespace: colors
	Checksum: 0xF38A2714
	Offset: 0x65B0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function get_force_color()
{
	color = self.script_forcecolor;
	return color;
}

/*
	Name: get_force_color_guys
	Namespace: colors
	Checksum: 0x3E873281
	Offset: 0x65D8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function get_force_color_guys(team, color)
{
	ai = getaiteamarray(team);
	guys = [];
	for(i = 0; i < ai.size; i++)
	{
		guy = ai[i];
		if(!isdefined(guy.script_forcecolor))
		{
			continue;
		}
		if(guy.script_forcecolor != color)
		{
			continue;
		}
		guys[guys.size] = guy;
	}
	return guys;
}

/*
	Name: get_all_force_color_friendlies
	Namespace: colors
	Checksum: 0xEA699EE5
	Offset: 0x66B8
	Size: 0xA8
	Parameters: 0
	Flags: None
*/
function get_all_force_color_friendlies()
{
	ai = getaiteamarray("allies");
	guys = [];
	for(i = 0; i < ai.size; i++)
	{
		guy = ai[i];
		if(!isdefined(guy.script_forcecolor))
		{
			continue;
		}
		guys[guys.size] = guy;
	}
	return guys;
}

/*
	Name: disable
	Namespace: colors
	Checksum: 0xE8F46EFD
	Offset: 0x6768
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function disable(stop_being_careful)
{
	if(isdefined(self.new_force_color_being_set))
	{
		self endon(#"death");
		self waittill(#"done_setting_new_color");
	}
	if(isdefined(stop_being_careful) && stop_being_careful)
	{
		self notify(#"stop_going_to_node");
		self notify(#"stop_being_careful");
	}
	self clearfixednodesafevolume();
	if(!isdefined(self.script_forcecolor))
	{
		return;
	}
	/#
		assert(!isdefined(self.old_forcecolor), "");
	#/
	self.old_forcecolor = self.script_forcecolor;
	arrayremovevalue(level.arrays_of_colorforced_ai[self.team][self.script_forcecolor], self);
	left_color_node();
	self.script_forcecolor = undefined;
	self.currentcolorcode = undefined;
	/#
		update_debug_friendlycolor();
	#/
}

/*
	Name: enable
	Namespace: colors
	Checksum: 0xBD0E601F
	Offset: 0x6890
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	if(isdefined(self.script_forcecolor))
	{
		return;
	}
	if(!isdefined(self.old_forcecolor))
	{
		return;
	}
	set_force_color(self.old_forcecolor);
	self.old_forcecolor = undefined;
}

/*
	Name: is_color_ai
	Namespace: colors
	Checksum: 0xFD7E9382
	Offset: 0x68E0
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function is_color_ai()
{
	return isdefined(self.script_forcecolor) || isdefined(self.old_forcecolor);
}

/*
	Name: insure_player_does_not_set_forcecolor_twice_in_one_frame
	Namespace: colors
	Checksum: 0x8F107D4B
	Offset: 0x6900
	Size: 0x62
	Parameters: 0
	Flags: None
*/
function insure_player_does_not_set_forcecolor_twice_in_one_frame()
{
	/#
		/#
			assert(!isdefined(self.setforcecolor), "");
		#/
		self.setforcecolor = 1;
		waittillframeend();
		if(!isalive(self))
		{
			return;
		}
		self.setforcecolor = undefined;
	#/
}

