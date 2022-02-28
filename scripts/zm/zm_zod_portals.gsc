// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_quest;

#using_animtree("generic");

#namespace zm_zod_portals;

/*
	Name: __init__sytem__
	Namespace: zm_zod_portals
	Checksum: 0xB683972A
	Offset: 0x600
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_portals", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_portals
	Checksum: 0x54A6FBBE
	Offset: 0x640
	Size: 0x294
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["portal_3p"] = "zombie/fx_quest_portal_trail_zod_zmb";
	n_bits = getminbitcountfornum(3);
	clientfield::register("toplayer", "player_stargate_fx", 1, 1, "int");
	clientfield::register("world", "portal_state_canal", 1, n_bits, "int");
	clientfield::register("world", "portal_state_slums", 1, n_bits, "int");
	clientfield::register("world", "portal_state_theater", 1, n_bits, "int");
	clientfield::register("world", "portal_state_ending", 1, 1, "int");
	clientfield::register("world", "pulse_canal_portal_top", 1, 1, "counter");
	clientfield::register("world", "pulse_canal_portal_bottom", 1, 1, "counter");
	clientfield::register("world", "pulse_slums_portal_top", 1, 1, "counter");
	clientfield::register("world", "pulse_slums_portal_bottom", 1, 1, "counter");
	clientfield::register("world", "pulse_theater_portal_top", 1, 1, "counter");
	clientfield::register("world", "pulse_theater_portal_bottom", 1, 1, "counter");
	visionset_mgr::register_info("overlay", "zm_zod_transported", 1, 20, 15, 1, &visionset_mgr::duration_lerp_thread_per_player, 0);
}

/*
	Name: function_54ec766b
	Namespace: zm_zod_portals
	Checksum: 0x3B736B57
	Offset: 0x8E0
	Size: 0x2BC
	Parameters: 1
	Flags: Linked
*/
function function_54ec766b(str_id)
{
	width = 192;
	height = 128;
	length = 192;
	str_areaname = return_district_name_from_string(str_id);
	s_loc = function_42ed55f2(str_areaname);
	var_1693bd2 = getnodearray(str_areaname + "_portal_node", "script_noteworthy");
	foreach(var_9110bac3 in var_1693bd2)
	{
		setenablenode(var_9110bac3, 0);
	}
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = width;
	s_loc.unitrigger_stub.script_height = height;
	s_loc.unitrigger_stub.script_length = length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.str_areaname = str_areaname;
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_16fca6d;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_a90ab0d7);
}

/*
	Name: function_16fca6d
	Namespace: zm_zod_portals
	Checksum: 0xE6446812
	Offset: 0xBA8
	Size: 0xF2
	Parameters: 1
	Flags: Linked
*/
function function_16fca6d(player)
{
	level endon(#"ritual_pap_complete");
	str_areaname = self.stub.str_areaname;
	var_8f5050e8 = level clientfield::get("portal_state_" + str_areaname);
	if(var_8f5050e8 !== 1 && (!(isdefined(player.beastmode) && player.beastmode)))
	{
		self sethintstring(&"ZM_ZOD_PORTAL_OPEN");
		b_is_invis = 0;
	}
	else
	{
		b_is_invis = 1;
	}
	self setinvisibletoplayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_a90ab0d7
	Namespace: zm_zod_portals
	Checksum: 0x909F3271
	Offset: 0xCA8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_a90ab0d7()
{
	level endon(#"ritual_pap_complete");
	while(true)
	{
		self waittill(#"trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.is_drinking > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		level thread function_e0c93f92(self.stub.str_areaname);
		break;
	}
}

/*
	Name: function_42ed55f2
	Namespace: zm_zod_portals
	Checksum: 0xAC2689B9
	Offset: 0xD60
	Size: 0xE6
	Parameters: 1
	Flags: Linked
*/
function function_42ed55f2(str_areaname)
{
	a_s_portal_locs = struct::get_array("teleport_effect_origin", "targetname");
	s_return_loc = undefined;
	foreach(s_portal_loc in a_s_portal_locs)
	{
		if(s_portal_loc.script_noteworthy === (str_areaname + "_portal_top"))
		{
			s_return_loc = s_portal_loc;
		}
	}
	return s_return_loc;
}

/*
	Name: function_e0c93f92
	Namespace: zm_zod_portals
	Checksum: 0x69B35316
	Offset: 0xE50
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_e0c93f92(str_areaname)
{
	level clientfield::set("portal_state_" + str_areaname, 1);
	portal_open(str_areaname);
}

/*
	Name: portal_open
	Namespace: zm_zod_portals
	Checksum: 0x36C40FF2
	Offset: 0xEA8
	Size: 0x38C
	Parameters: 2
	Flags: Linked
*/
function portal_open(str_areaname, var_14429fc9 = 0)
{
	if(var_14429fc9)
	{
		level clientfield::set("portal_state_" + str_areaname, 2);
	}
	var_1693bd2 = getnodearray(str_areaname + "_portal_node", "script_noteworthy");
	foreach(var_9110bac3 in var_1693bd2)
	{
		setenablenode(var_9110bac3, 1);
	}
	a_t_portal_top = getentarray(str_areaname + "_portal_top", "script_noteworthy");
	var_ebfa395 = getentarrayfromarray(a_t_portal_top, "teleport_trigger", "targetname");
	a_t_portal_bottom = getentarray(str_areaname + "_portal_bottom", "script_noteworthy");
	var_50fc4fb = getentarrayfromarray(a_t_portal_bottom, "teleport_trigger", "targetname");
	var_ebfa395[0].e_dest = var_50fc4fb[0];
	var_50fc4fb[0].e_dest = var_ebfa395[0];
	foreach(var_9110bac3 in var_1693bd2)
	{
		var_e8b9ac31 = distancesquared(var_9110bac3.origin, var_ebfa395[0].origin);
		var_6d6d9e09 = distancesquared(var_9110bac3.origin, var_50fc4fb[0].origin);
		if(var_e8b9ac31 < var_6d6d9e09)
		{
			var_9110bac3.portal_trig = var_ebfa395[0];
			continue;
		}
		var_9110bac3.portal_trig = var_50fc4fb[0];
	}
	wait(2.5);
	var_ebfa395[0] thread portal_think();
	var_50fc4fb[0] thread portal_think();
	level flag::set("activate_underground");
}

/*
	Name: return_district_name_from_string
	Namespace: zm_zod_portals
	Checksum: 0x8EA2C018
	Offset: 0x1240
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function return_district_name_from_string(str_input)
{
	a_str_names = array("canal", "slums", "theater");
	foreach(str_name in a_str_names)
	{
		if(issubstr(str_input, str_name))
		{
			return str_name;
		}
	}
}

/*
	Name: portal_think
	Namespace: zm_zod_portals
	Checksum: 0x355A376
	Offset: 0x1320
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function portal_think()
{
	self.a_s_port_locs = struct::get_array(self.target, "targetname");
	while(true)
	{
		self waittill(#"trigger", e_portee);
		level clientfield::increment("pulse_" + self.script_noteworthy);
		if(isdefined(e_portee.teleporting) && e_portee.teleporting)
		{
			continue;
		}
		if(isplayer(e_portee))
		{
			if(e_portee getstance() != "prone")
			{
				playfx(level._effect["portal_3p"], e_portee.origin);
				e_portee playlocalsound("zmb_teleporter_teleport_2d");
				playsoundatposition("zmb_teleporter_teleport_out", e_portee.origin);
				self thread portal_teleport_player(e_portee);
			}
		}
	}
}

/*
	Name: portal_teleport_player
	Namespace: zm_zod_portals
	Checksum: 0x733F4314
	Offset: 0x14A0
	Size: 0x924
	Parameters: 2
	Flags: Linked
*/
function portal_teleport_player(player, show_fx = 1)
{
	player endon(#"disconnect");
	player.teleporting = 1;
	player.teleport_location = player.origin;
	if(show_fx)
	{
		player clientfield::set_to_player("player_stargate_fx", 1);
	}
	n_pos = player.characterindex;
	prone_offset = vectorscale((0, 0, 1), 49);
	crouch_offset = vectorscale((0, 0, 1), 20);
	stand_offset = (0, 0, 0);
	a_ai_enemies = getaiteamarray("axis");
	a_ai_enemies = arraysort(a_ai_enemies, self.origin, 1, 99, 768);
	array::thread_all(a_ai_enemies, &ai_delay_cleanup);
	level.n_cleanup_manager_restart_time = 2 + 15;
	level.n_cleanup_manager_restart_time = level.n_cleanup_manager_restart_time + (gettime() / 1000);
	image_room = struct::get("teleport_room_" + n_pos, "targetname");
	player disableoffhandweapons();
	player disableweapons();
	player freezecontrols(1);
	util::wait_network_frame();
	if(player getstance() == "prone")
	{
		desired_origin = image_room.origin + prone_offset;
	}
	else
	{
		if(player getstance() == "crouch")
		{
			desired_origin = image_room.origin + crouch_offset;
		}
		else
		{
			desired_origin = image_room.origin + stand_offset;
		}
	}
	player.teleport_origin = spawn("script_model", player.origin);
	player.teleport_origin setmodel("tag_origin");
	player.teleport_origin.angles = player.angles;
	player playerlinktoabsolute(player.teleport_origin, "tag_origin");
	player.teleport_origin.origin = desired_origin;
	player.teleport_origin.angles = image_room.angles;
	util::wait_network_frame();
	player.teleport_origin.angles = image_room.angles;
	wait(2);
	if(show_fx)
	{
		player clientfield::set_to_player("player_stargate_fx", 0);
	}
	a_players = getplayers();
	arrayremovevalue(a_players, player);
	s_pos = array::random(self.a_s_port_locs);
	if(a_players.size > 0)
	{
		var_cefa4b63 = 0;
		while(!var_cefa4b63)
		{
			var_cefa4b63 = 1;
			s_pos = array::random(self.a_s_port_locs);
			foreach(var_3bc10d31 in a_players)
			{
				var_f2c93934 = distance(var_3bc10d31.origin, s_pos.origin);
				if(var_f2c93934 < 32)
				{
					var_cefa4b63 = 0;
				}
			}
			wait(0.05);
		}
	}
	playfx(level._effect["portal_3p"], s_pos.origin);
	player unlink();
	playsoundatposition("zmb_teleporter_teleport_in", s_pos.origin);
	if(isdefined(player.teleport_origin))
	{
		player.teleport_origin delete();
		player.teleport_origin = undefined;
	}
	player setorigin(s_pos.origin);
	player setplayerangles(s_pos.angles);
	level clientfield::increment("pulse_" + self.e_dest.script_noteworthy);
	a_ai = getaiarray();
	a_aoe_ai = arraysortclosest(a_ai, s_pos.origin, a_ai.size, 0, 200);
	foreach(ai in a_aoe_ai)
	{
		if(isactor(ai))
		{
			if(ai.archetype === "zombie")
			{
				playfx(level._effect["beast_return_aoe_kill"], ai gettagorigin("j_spineupper"));
			}
			else
			{
				playfx(level._effect["beast_return_aoe_kill"], ai.origin);
			}
			ai.marked_for_recycle = 1;
			ai.has_been_damaged_by_player = 0;
			ai.deathpoints_already_given = 1;
			ai.no_powerups = 1;
			ai dodamage(ai.health + 1000, s_pos.origin, player);
		}
	}
	player enableweapons();
	player enableoffhandweapons();
	player freezecontrols(level.intermission);
	player.teleporting = 0;
	player thread zm_audio::create_and_play_dialog("portal", "travel");
}

/*
	Name: ai_delay_cleanup
	Namespace: zm_zod_portals
	Checksum: 0x7FFAFFFF
	Offset: 0x1DD0
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function ai_delay_cleanup()
{
	if(!(isdefined(self.b_ignore_cleanup) && self.b_ignore_cleanup))
	{
		self notify(#"delay_cleanup");
		self endon(#"death");
		self endon(#"delay_cleanup");
		self.b_ignore_cleanup = 1;
		wait(10);
		self.b_ignore_cleanup = undefined;
	}
}

/*
	Name: portal_teleport_ai
	Namespace: zm_zod_portals
	Checksum: 0xEFF1321
	Offset: 0x1E38
	Size: 0x2C4
	Parameters: 1
	Flags: Linked
*/
function portal_teleport_ai(e_portee)
{
	e_portee endon(#"death");
	e_portee.teleporting = 1;
	e_portee pathmode("dont move");
	playfx(level._effect["portal_3p"], e_portee.origin);
	playsoundatposition("zmb_teleporter_teleport_out", e_portee.origin);
	util::wait_network_frame();
	image_room = struct::get("teleport_room_zombies", "targetname");
	if(isactor(e_portee))
	{
		e_portee forceteleport(image_room.origin, image_room.angles);
	}
	else
	{
		e_portee.origin = image_room.origin;
		e_portee.angles = image_room.angles;
	}
	wait(2);
	s_port_loc = array::random(self.a_s_port_locs);
	if(isactor(e_portee))
	{
		e_portee forceteleport(s_port_loc.origin, s_port_loc.angles);
	}
	else
	{
		e_portee.origin = s_port_loc.origin;
		e_portee.angles = s_port_loc.angles;
	}
	level clientfield::increment("pulse_" + self.e_dest.script_noteworthy);
	playsoundatposition("zmb_teleporter_teleport_in", s_port_loc.origin);
	playfx(level._effect["portal_3p"], s_port_loc.origin);
	wait(1);
	e_portee pathmode("move allowed");
	e_portee.teleporting = 0;
}

