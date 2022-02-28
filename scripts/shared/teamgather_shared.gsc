// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

class cteamgather 
{
	var e_gameobject;
	var v_font_color;
	var n_font_scale;
	var m_e_player_leader;
	var m_num_players;
	var m_num_players_ready;
	var m_v_gather_position;
	var m_v_interact_angles;
	var m_v_interact_position;
	var in_position_start_time;
	var m_success;
	var m_teamgather_complete;
	var m_e_interact_entity;
	var m_gather_fx;
	var c_teamgather;

	/*
		Name: constructor
		Namespace: cteamgather
		Checksum: 0x582A1C21
		Offset: 0x590
		Size: 0x74
		Parameters: 0
		Flags: None
	*/
	constructor()
	{
		e_gameobject = undefined;
		n_font_scale = 2;
		v_font_color = (1, 1, 1);
		m_teamgather_complete = 0;
		m_num_players = 0;
		m_num_players_ready = 0;
		m_gather_fx = undefined;
		m_teamgather_complete = 0;
		m_success = 0;
	}

	/*
		Name: destructor
		Namespace: cteamgather
		Checksum: 0x99EC1590
		Offset: 0x610
		Size: 0x4
		Parameters: 0
		Flags: None
	*/
	destructor()
	{
	}

	/*
		Name: get_players_playing
		Namespace: cteamgather
		Checksum: 0xEF59DB9B
		Offset: 0x25E0
		Size: 0xA4
		Parameters: 0
		Flags: None
	*/
	function get_players_playing()
	{
		a_players = [];
		a_all_players = getplayers();
		for(i = 0; i < a_all_players.size; i++)
		{
			e_player = a_all_players[i];
			if(e_player.sessionstate == "playing")
			{
				a_players[a_players.size] = e_player;
			}
		}
		return a_players;
	}

	/*
		Name: get_time_remaining_in_seconds
		Namespace: cteamgather
		Checksum: 0xD67C85D1
		Offset: 0x2540
		Size: 0x98
		Parameters: 0
		Flags: None
	*/
	function get_time_remaining_in_seconds()
	{
		time_remaining = int(get_time_remaining());
		time_remaining = time_remaining + 1;
		if(time_remaining > 10)
		{
			time_remaining = 10;
		}
		if(time_remaining > 10)
		{
			time_remaining = 10;
		}
		else if(time_remaining < 1)
		{
			time_remaining = 1;
		}
		return time_remaining;
	}

	/*
		Name: get_time_remaining
		Namespace: cteamgather
		Checksum: 0x6028B0F7
		Offset: 0x24D0
		Size: 0x62
		Parameters: 0
		Flags: None
	*/
	function get_time_remaining()
	{
		time = gettime();
		dt = (time - e_gameobject.start_time) / 1000;
		time_remaining = e_gameobject.total_time - dt;
		return time_remaining;
	}

	/*
		Name: start_player_timer
		Namespace: cteamgather
		Checksum: 0x893D1DFF
		Offset: 0x2490
		Size: 0x34
		Parameters: 1
		Flags: None
	*/
	function start_player_timer(total_time)
	{
		e_gameobject.start_time = gettime();
		e_gameobject.total_time = total_time;
	}

	/*
		Name: __create_client_hud_elem
		Namespace: cteamgather
		Checksum: 0xE2B8F3AE
		Offset: 0x22D8
		Size: 0x1B0
		Parameters: 9
		Flags: None
	*/
	function __create_client_hud_elem(alignx, aligny, horzalign, vertalign, xoffset, yoffset, fontscale, color, str_text)
	{
		hud_elem = newclienthudelem(self);
		hud_elem.elemtype = "font";
		hud_elem.font = "objective";
		hud_elem.alignx = alignx;
		hud_elem.aligny = aligny;
		hud_elem.horzalign = horzalign;
		hud_elem.vertalign = vertalign;
		hud_elem.x = hud_elem.x + xoffset;
		hud_elem.y = hud_elem.y + yoffset;
		hud_elem.foreground = 1;
		hud_elem.fontscale = fontscale;
		hud_elem.alpha = 1;
		hud_elem.color = color;
		hud_elem.hidewheninmenu = 1;
		hud_elem settext(str_text);
		return hud_elem;
	}

	/*
		Name: display_hud_player_team_member
		Namespace: cteamgather
		Checksum: 0x9B300D72
		Offset: 0x1EA8
		Size: 0x424
		Parameters: 1
		Flags: None
	*/
	function display_hud_player_team_member(e_player)
	{
		e_player endon(#"disconnect");
		y_start = 180;
		x_off = 0;
		y_off = y_start;
		starting_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "");
		starting_hud_elem settext(&"TEAM_GATHER_PLAYER_STARTING_EVENT", m_e_player_leader);
		x_off = -118;
		y_off = y_start + 40;
		gathered_hud_elem = e_player __create_client_hud_elem("left", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "");
		x_off = 54;
		y_off = y_start + 40;
		start_in_hud_elem = e_player __create_client_hud_elem("left", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "");
		x_off = 0;
		y_off = y_start + 80;
		go_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "");
		a_start_in = array("0", &"TEAM_GATHER_START_IN_1", &"TEAM_GATHER_START_IN_2", &"TEAM_GATHER_START_IN_3", &"TEAM_GATHER_START_IN_4", &"TEAM_GATHER_START_IN_5", &"TEAM_GATHER_START_IN_6", &"TEAM_GATHER_START_IN_7", &"TEAM_GATHER_START_IN_8", &"TEAM_GATHER_START_IN_9", &"TEAM_GATHER_START_IN_10");
		while(!is_teamgather_complete())
		{
			gathered_hud_elem settext(&"TEAM_GATHER_NUM_PLAYERS", int(m_num_players_ready), int(m_num_players));
			time_remaining = get_time_remaining_in_seconds();
			start_in_hud_elem settext(a_start_in[time_remaining]);
			if(isdefined(e_player.in_gather_position) && e_player.in_gather_position)
			{
				go_hud_elem settext("");
			}
			else
			{
				go_hud_elem settext(&"TEAM_GATHER_HOLD_TO_GO_NOW");
			}
			wait(0.05);
		}
		starting_hud_elem destroy();
		gathered_hud_elem destroy();
		start_in_hud_elem destroy();
		go_hud_elem destroy();
	}

	/*
		Name: display_hud_player_leader
		Namespace: cteamgather
		Checksum: 0x5A0C539C
		Offset: 0x1BB0
		Size: 0x2EC
		Parameters: 1
		Flags: None
	*/
	function display_hud_player_leader(e_player)
	{
		e_player endon(#"disconnect");
		y_start = 180;
		x_off = 0;
		y_off = y_start;
		gather_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, &"TEAM_GATHER_TEAM_STEALTH_ENTER");
		x_off = 0;
		y_off = y_start + 100;
		ready_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "");
		x_off = -45;
		y_off = y_start + 130;
		execute_hud_elem = e_player __create_client_hud_elem("left", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, "");
		a_time_remaining = array("0", &"TEAM_GATHER_TIME_REMAINING_1", &"TEAM_GATHER_TIME_REMAINING_2", &"TEAM_GATHER_TIME_REMAINING_3", &"TEAM_GATHER_TIME_REMAINING_4", &"TEAM_GATHER_TIME_REMAINING_5", &"TEAM_GATHER_TIME_REMAINING_6", &"TEAM_GATHER_TIME_REMAINING_7", &"TEAM_GATHER_TIME_REMAINING_8", &"TEAM_GATHER_TIME_REMAINING_9", &"TEAM_GATHER_TIME_REMAINING_10");
		while(!is_teamgather_complete())
		{
			ready_hud_elem settext(&"TEAM_GATHER_PLAYERS_READY", m_num_players_ready, m_num_players);
			time_remaining = get_time_remaining_in_seconds();
			execute_hud_elem settext(a_time_remaining[time_remaining]);
			wait(0.05);
		}
		gather_hud_elem destroy();
		ready_hud_elem destroy();
		execute_hud_elem destroy();
	}

	/*
		Name: teleport_player_into_position
		Namespace: cteamgather
		Checksum: 0xD45779A8
		Offset: 0x1850
		Size: 0x354
		Parameters: 1
		Flags: None
	*/
	function teleport_player_into_position(e_player)
	{
		a_players = get_players_playing();
		while(true)
		{
			x_offset = randomfloatrange((210 - 42) * -1, 210 - 42);
			y_offset = randomfloatrange((210 - 42) * -1, 210 - 42);
			e_player.zoom_pos = (m_v_gather_position[0] + x_offset, m_v_gather_position[1] + y_offset, m_v_gather_position[2]);
			reject = 0;
			for(i = 0; i < a_players.size; i++)
			{
				if(e_player != a_players[i])
				{
					dist = distance2d(e_player.origin, a_players[i].origin);
					if(dist < 84)
					{
						reject = 1;
						break;
					}
				}
			}
			if(!reject)
			{
				v_forward = anglestoforward(m_v_interact_angles);
				v_dir = vectornormalize(e_player.zoom_pos - m_v_interact_position);
				dp = vectordot(v_forward, v_dir);
				if(dp > -0.5)
				{
					reject = 1;
				}
			}
			if(reject)
			{
				break;
			}
			if(!positionwouldtelefrag(e_player.zoom_pos))
			{
				break;
			}
		}
		e_player setorigin(e_player.zoom_pos);
		v0 = (m_v_interact_position[0], m_v_interact_position[1], m_v_interact_position[2]);
		v1 = (e_player.zoom_pos[0], e_player.zoom_pos[1], m_v_interact_position[2]);
		v_dir = vectornormalize(v0 - v1);
		v_angles = vectortoangles(v_dir);
		e_player setplayerangles(v_angles);
	}

	/*
		Name: team_member_zoom_button_check
		Namespace: cteamgather
		Checksum: 0xC6EAAD37
		Offset: 0x1808
		Size: 0x3C
		Parameters: 1
		Flags: None
	*/
	function team_member_zoom_button_check(e_player)
	{
		if(e_player usebuttonpressed())
		{
			teleport_player_into_position(e_player);
		}
	}

	/*
		Name: player_lowready_state
		Namespace: cteamgather
		Checksum: 0x492EC5EA
		Offset: 0x1788
		Size: 0x74
		Parameters: 1
		Flags: None
	*/
	function player_lowready_state(lower_weapon)
	{
		if(lower_weapon)
		{
			if(self util::isweaponenabled())
			{
				self util::_disableweapon();
			}
		}
		else if(!self util::isweaponenabled())
		{
			self util::_enableweapon();
		}
	}

	/*
		Name: is_player_in_gather_position
		Namespace: cteamgather
		Checksum: 0x7A97BE5A
		Offset: 0x15C8
		Size: 0x1B2
		Parameters: 1
		Flags: None
	*/
	function is_player_in_gather_position(e_player)
	{
		player_valid = 1;
		n_dist = distance2d(e_player.origin, m_v_gather_position);
		if(n_dist > 210)
		{
			player_valid = 0;
		}
		else
		{
			v_start_pos = (e_player.origin[0], e_player.origin[1], e_player.origin[2] + 32);
			v_end_pos = (m_v_gather_position[0], m_v_gather_position[1], m_v_gather_position[2]);
			if((e_player.origin[2] - v_end_pos[2]) < -64)
			{
				player_valid = 0;
			}
			v_trace = bullettrace(v_start_pos, v_end_pos, 0, undefined);
			v_trace_pos = v_trace["position"];
			dz = abs(v_trace_pos[2] - m_v_gather_position[2]);
			if(dz > 64)
			{
				player_valid = 0;
			}
		}
		return player_valid;
	}

	/*
		Name: update_players_in_radius
		Namespace: cteamgather
		Checksum: 0x82001D62
		Offset: 0x1408
		Size: 0x1B6
		Parameters: 1
		Flags: None
	*/
	function update_players_in_radius(force_player_into_position)
	{
		a_players = get_players_playing();
		m_num_players = a_players.size;
		for(i = 0; i < a_players.size; i++)
		{
			a_players[i].in_gather_position = undefined;
		}
		m_num_players_ready = 0;
		for(i = 0; i < a_players.size; i++)
		{
			e_player = a_players[i];
			e_player.in_gather_position = is_player_in_gather_position(e_player);
			if(isdefined(force_player_into_position) && force_player_into_position && (!(isdefined(e_player.in_gather_position) && e_player.in_gather_position)))
			{
				teleport_player_into_position(e_player);
			}
			if(isdefined(e_player.in_gather_position) && e_player.in_gather_position)
			{
				e_player player_lowready_state(1);
				m_num_players_ready++;
				continue;
			}
			e_player player_lowready_state(0);
			if(e_player != m_e_player_leader)
			{
				team_member_zoom_button_check(e_player);
			}
		}
	}

	/*
		Name: players_in_position
		Namespace: cteamgather
		Checksum: 0x2F62D74E
		Offset: 0x1370
		Size: 0x8C
		Parameters: 1
		Flags: None
	*/
	function players_in_position(in_position)
	{
		if(isdefined(in_position) && in_position)
		{
			if(!isdefined(in_position_start_time))
			{
				in_position_start_time = gettime();
			}
			time = gettime();
			dt = (time - in_position_start_time) / 1000;
			if(dt >= 0)
			{
				return true;
			}
		}
		else
		{
			self.in_position_start_time = undefined;
		}
		return false;
	}

	/*
		Name: teamgather_main_update
		Namespace: cteamgather
		Checksum: 0xA39F96AF
		Offset: 0x1170
		Size: 0x1F2
		Parameters: 0
		Flags: None
	*/
	function teamgather_main_update()
	{
		while(!is_teamgather_complete())
		{
			update_players_in_radius(0);
			if(m_num_players_ready == 0)
			{
				set_teamgather_complete(0);
				break;
			}
			if(m_num_players > 0 && m_num_players_ready >= m_num_players)
			{
				if(players_in_position(1))
				{
					set_teamgather_complete(1);
					break;
				}
			}
			else
			{
				players_in_position(0);
			}
			time_remaining = get_time_remaining();
			if(time_remaining <= 0)
			{
				set_teamgather_complete(1);
				break;
			}
			wait(0.05);
		}
		if(m_success == 1)
		{
			update_players_in_radius(1);
		}
		a_players = get_players_playing();
		for(i = 0; i < a_players.size; i++)
		{
			e_player = a_players[i];
			if(isdefined(e_player.in_gather_position) && e_player.in_gather_position)
			{
				e_player util::_enableweapon();
			}
			e_player.in_gather_position = undefined;
		}
		return m_success;
	}

	/*
		Name: set_teamgather_complete
		Namespace: cteamgather
		Checksum: 0x84696FF8
		Offset: 0x1140
		Size: 0x24
		Parameters: 1
		Flags: None
	*/
	function set_teamgather_complete(success)
	{
		m_teamgather_complete = 1;
		m_success = success;
	}

	/*
		Name: is_teamgather_complete
		Namespace: cteamgather
		Checksum: 0x6902C4B5
		Offset: 0x1128
		Size: 0xA
		Parameters: 0
		Flags: None
	*/
	function is_teamgather_complete()
	{
		return m_teamgather_complete;
	}

	/*
		Name: create_player_huds
		Namespace: cteamgather
		Checksum: 0xDE8E0F5F
		Offset: 0x1060
		Size: 0xBE
		Parameters: 0
		Flags: None
	*/
	function create_player_huds()
	{
		a_players = get_players_playing();
		if(a_players.size <= 1)
		{
			return;
		}
		for(i = 0; i < a_players.size; i++)
		{
			e_player = a_players[i];
			if(e_player == m_e_player_leader)
			{
				self thread display_hud_player_leader(e_player);
				continue;
			}
			self thread display_hud_player_team_member(e_player);
		}
	}

	/*
		Name: gather_players
		Namespace: cteamgather
		Checksum: 0x4BC46AF0
		Offset: 0x1008
		Size: 0x4C
		Parameters: 0
		Flags: None
	*/
	function gather_players()
	{
		start_player_timer(10);
		create_player_huds();
		b_success = teamgather_main_update();
		return b_success;
	}

	/*
		Name: interact_entity_highlight
		Namespace: cteamgather
		Checksum: 0xEA81B126
		Offset: 0xF88
		Size: 0x74
		Parameters: 1
		Flags: None
	*/
	function interact_entity_highlight(highlight_object)
	{
		if(isdefined(m_e_interact_entity))
		{
			if(isdefined(highlight_object) && highlight_object)
			{
				m_e_interact_entity clientfield::set("teamgather_material", 1);
			}
			else
			{
				m_e_interact_entity clientfield::set("teamgather_material", 0);
			}
		}
	}

	/*
		Name: cleanup_floor_effect
		Namespace: cteamgather
		Checksum: 0x9AB9BF60
		Offset: 0xF38
		Size: 0x48
		Parameters: 0
		Flags: None
	*/
	function cleanup_floor_effect()
	{
		if(!(isdefined(0) && 0))
		{
			return;
		}
		if(isdefined(m_gather_fx))
		{
			m_gather_fx delete();
			m_gather_fx = undefined;
		}
	}

	/*
		Name: spawn_floor_effect
		Namespace: cteamgather
		Checksum: 0xD8E157F3
		Offset: 0xE20
		Size: 0x10C
		Parameters: 0
		Flags: None
	*/
	function spawn_floor_effect()
	{
		if(!(isdefined(0) && 0))
		{
			return;
		}
		v_pos = m_v_gather_position;
		v_start = (v_pos[0], v_pos[1], v_pos[2] + 20);
		v_end = (v_pos[0], v_pos[1], v_pos[2] - 94);
		trace = bullettrace(v_start, v_end, 0, undefined);
		v_floor_pos = trace["position"];
		m_gather_fx = spawnfx("_t6/misc/fx_ui_flagbase_pmc", v_floor_pos);
		triggerfx(m_gather_fx);
	}

	/*
		Name: onusegameobject
		Namespace: cteamgather
		Checksum: 0xB2FA7DC5
		Offset: 0xDE8
		Size: 0x2E
		Parameters: 1
		Flags: None
	*/
	function onusegameobject(player)
	{
		c_teamgather.m_e_player_leader = player;
		self notify(#"player_interaction");
	}

	/*
		Name: setup_gameobject
		Namespace: cteamgather
		Checksum: 0xAAAC6CE8
		Offset: 0xA78
		Size: 0x368
		Parameters: 4
		Flags: None
	*/
	function setup_gameobject(v_pos, str_model, str_use_hint, e_los_ignore_me)
	{
		n_radius = 48;
		e_trigger = spawn("trigger_radius_use", v_pos, 0, n_radius, 30);
		e_trigger triggerignoreteam();
		e_trigger setvisibletoall();
		e_trigger setteamfortrigger("none");
		e_trigger usetriggerrequirelookat();
		e_trigger setcursorhint("HINT_NOICON");
		gobj_model_offset = (0, 0, 0);
		if(isdefined(str_model))
		{
			gobj_visuals[0] = spawn("script_model", v_pos + gobj_model_offset);
			gobj_visuals[0] setmodel(str_model);
		}
		else
		{
			gobj_visuals = [];
		}
		gobj_objective_name = undefined;
		gobj_team = "allies";
		gobj_trigger = e_trigger;
		gobj_offset = vectorscale((0, 0, -1), 5);
		e_object = gameobjects::create_use_object(gobj_team, gobj_trigger, gobj_visuals, gobj_offset, gobj_objective_name);
		e_object gameobjects::allow_use("any");
		e_object gameobjects::set_use_time(0);
		e_object gameobjects::set_use_text("");
		e_object gameobjects::set_use_hint_text(str_use_hint);
		e_object gameobjects::set_visible_team("any");
		e_object.onuse = &onusegameobject;
		e_object gameobjects::set_3d_icon("friendly", "T7_hud_prompt_press_64");
		e_object gameobjects::set_3d_icon("enemy", "T7_hud_prompt_press_64");
		e_object gameobjects::set_2d_icon("friendly", "T7_hud_prompt_press_64");
		e_object gameobjects::set_2d_icon("enemy", "T7_hud_prompt_press_64");
		e_object thread gameobjects::hide_icon_distance_and_los((1, 1, 1), 840, 1, e_los_ignore_me);
		return e_object;
	}

	/*
		Name: teamgather_failure
		Namespace: cteamgather
		Checksum: 0x577E6D7D
		Offset: 0x930
		Size: 0x13E
		Parameters: 0
		Flags: None
	*/
	function teamgather_failure()
	{
		x_off = 0;
		y_off = 180;
		a_players = get_players_playing();
		for(i = 0; i < a_players.size; i++)
		{
			e_player = a_players[i];
			e_player.failure_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, &"TEAM_GATHER_TEAM_EVENT_ABORTED");
		}
		wait(0);
		for(i = 0; i < a_players.size; i++)
		{
			e_player = a_players[i];
			e_player.failure_hud_elem destroy();
		}
	}

	/*
		Name: teamgather_success
		Namespace: cteamgather
		Checksum: 0xC0FE96EA
		Offset: 0x7E0
		Size: 0x146
		Parameters: 0
		Flags: None
	*/
	function teamgather_success()
	{
		if(0 > 0)
		{
			x_off = 0;
			y_off = 180;
			a_players = get_players_playing();
			for(i = 0; i < a_players.size; i++)
			{
				e_player = a_players[i];
				e_player.success_hud_elem = e_player __create_client_hud_elem("center", "middle", "center", "top", x_off, y_off, n_font_scale, v_font_color, &"TEAM_GATHER_GATHER_SUCCESS");
			}
			wait(0);
			for(i = 0; i < a_players.size; i++)
			{
				e_player = a_players[i];
				e_player.success_hud_elem destroy();
			}
		}
	}

	/*
		Name: create_teamgather_event
		Namespace: cteamgather
		Checksum: 0x88ADEEE4
		Offset: 0x660
		Size: 0x178
		Parameters: 4
		Flags: None
	*/
	function create_teamgather_event(v_interact_pos, v_interact_angles, v_gather_pos, e_interact_entity)
	{
		m_v_interact_position = v_interact_pos;
		m_v_interact_angles = v_interact_angles;
		m_e_interact_entity = e_interact_entity;
		m_v_gather_position = v_gather_pos;
		e_gameobject = setup_gameobject(v_interact_pos, undefined, &"TEAM_GATHER_HOLD_FOR_TEAM_ENTER", m_e_interact_entity);
		e_gameobject.c_teamgather = self;
		e_gameobject waittill(#"player_interaction");
		e_gameobject gameobjects::disable_object();
		spawn_floor_effect();
		interact_entity_highlight(1);
		b_success = gather_players();
		cleanup_floor_effect();
		interact_entity_highlight(0);
		if(isdefined(b_success) && b_success)
		{
			teamgather_success();
		}
		else
		{
			teamgather_failure();
		}
		return b_success;
	}

	/*
		Name: cleanup
		Namespace: cteamgather
		Checksum: 0xFCAFA201
		Offset: 0x620
		Size: 0x34
		Parameters: 0
		Flags: None
	*/
	function cleanup()
	{
		cleanup_floor_effect();
		e_gameobject gameobjects::destroy_object(1, 1);
	}

}

#namespace teamgather;

/*
	Name: setup_teamgather
	Namespace: teamgather
	Checksum: 0x1E8F92BA
	Offset: 0x2C30
	Size: 0x1C4
	Parameters: 3
	Flags: None
*/
function setup_teamgather(v_interact_pos, v_interact_angles, e_interact_entity)
{
	v_forward = anglestoforward(v_interact_angles);
	v_gather_pos = v_interact_pos + (v_forward * -100);
	v_start = (v_gather_pos[0], v_gather_pos[1], v_gather_pos[2] + 20);
	v_end = (v_gather_pos[0], v_gather_pos[1], v_gather_pos[2] - 100);
	v_trace = bullettrace(v_start, v_end, 0, undefined);
	v_floor_pos = v_trace["position"];
	v_gather_pos = (v_gather_pos[0], v_gather_pos[1], v_floor_pos[2] + 10);
	c_teamgather = new cteamgather();
	success = [[ c_teamgather ]]->create_teamgather_event(v_interact_pos, v_interact_angles, v_gather_pos, e_interact_entity);
	if(success)
	{
		e_player = c_teamgather.m_e_player_leader;
	}
	else
	{
		e_player = undefined;
	}
	[[ c_teamgather ]]->cleanup();
	return e_player;
}

/*
	Name: mike_debug_line
	Namespace: teamgather
	Checksum: 0xE9E65ECD
	Offset: 0x2E00
	Size: 0x68
	Parameters: 2
	Flags: None
*/
function mike_debug_line(v1, v2)
{
	level notify(#"hash_62ab67ff");
	self endon(#"hash_62ab67ff");
	while(true)
	{
		/#
			line(v1, v2, (0, 0, 1));
		#/
		wait(0.1);
	}
}

