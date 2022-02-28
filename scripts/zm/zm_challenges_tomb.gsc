// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace zm_challenges_tomb;

/*
	Name: __init__sytem__
	Namespace: zm_challenges_tomb
	Checksum: 0xB40E745C
	Offset: 0x458
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_challenges_tomb", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_challenges_tomb
	Checksum: 0xC8210C8D
	Offset: 0x4A0
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._challenges = spawnstruct();
	level.a_m_challenge_boards = [];
	level.a_uts_challenge_boxes = [];
	callback::on_connect(&onplayerconnect);
	callback::on_spawned(&onplayerspawned);
	n_bits = getminbitcountfornum(14);
	clientfield::register("toplayer", "challenges.challenge_complete_1", 21000, 2, "int");
	clientfield::register("toplayer", "challenges.challenge_complete_2", 21000, 2, "int");
	clientfield::register("toplayer", "challenges.challenge_complete_3", 21000, 2, "int");
	clientfield::register("toplayer", "challenges.challenge_complete_4", 21000, 2, "int");
	/#
		level thread challenges_devgui();
	#/
}

/*
	Name: __main__
	Namespace: zm_challenges_tomb
	Checksum: 0x39A5A152
	Offset: 0x620
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	stats_init();
	a_m_challenge_boxes = getentarray("challenge_box", "targetname");
	array::thread_all(a_m_challenge_boxes, &box_init);
}

/*
	Name: onplayerconnect
	Namespace: zm_challenges_tomb
	Checksum: 0x56D4E630
	Offset: 0x690
	Size: 0x170
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	player_stats_init(self.characterindex);
	foreach(s_stat in level._challenges.a_players[self.characterindex].a_stats)
	{
		s_stat.b_display_tag = 1;
		foreach(m_board in level.a_m_challenge_boards)
		{
			m_board showpart(s_stat.str_medal_tag);
			m_board hidepart(s_stat.str_glow_tag);
		}
	}
}

/*
	Name: onplayerspawned
	Namespace: zm_challenges_tomb
	Checksum: 0xA1F8C61E
	Offset: 0x808
	Size: 0x200
	Parameters: 0
	Flags: Linked
*/
function onplayerspawned()
{
	self endon(#"disconnect");
	for(;;)
	{
		foreach(s_stat in level._challenges.a_players[self.characterindex].a_stats)
		{
			if(!s_stat.b_medal_awarded)
			{
				continue;
			}
			var_c4dd09e9 = 1;
			if(s_stat.b_reward_claimed)
			{
				var_c4dd09e9 = 2;
			}
			self clientfield::set_to_player(s_stat.s_parent.cf_complete, var_c4dd09e9);
		}
		foreach(s_stat in level._challenges.s_team.a_stats)
		{
			if(!s_stat.b_medal_awarded)
			{
				continue;
			}
			var_c4dd09e9 = 1;
			if(s_stat.a_b_player_rewarded[self.characterindex])
			{
				var_c4dd09e9 = 2;
			}
			self clientfield::set_to_player(s_stat.s_parent.cf_complete, var_c4dd09e9);
		}
		wait(0.05);
	}
}

/*
	Name: stats_init
	Namespace: zm_challenges_tomb
	Checksum: 0xCDFAF695
	Offset: 0xA10
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function stats_init()
{
	level._challenges.a_stats = [];
	if(isdefined(level.challenges_add_stats))
	{
		[[level.challenges_add_stats]]();
	}
	foreach(stat in level._challenges.a_stats)
	{
		if(isdefined(stat.fp_init_stat))
		{
			level thread [[stat.fp_init_stat]]();
		}
	}
	level._challenges.a_players = [];
	for(i = 0; i < 4; i++)
	{
		player_stats_init(i);
	}
	team_stats_init();
}

/*
	Name: add_stat
	Namespace: zm_challenges_tomb
	Checksum: 0xE1E3A92
	Offset: 0xB58
	Size: 0x190
	Parameters: 7
	Flags: Linked
*/
function add_stat(str_name, b_team = 0, str_hint = &"", n_goal = 1, str_reward_model, fp_give_reward, fp_init_stat)
{
	stat = spawnstruct();
	stat.str_name = str_name;
	stat.b_team = b_team;
	stat.str_hint = str_hint;
	stat.n_goal = n_goal;
	stat.str_reward_model = str_reward_model;
	stat.fp_give_reward = fp_give_reward;
	stat.n_index = level._challenges.a_stats.size;
	if(isdefined(fp_init_stat))
	{
		stat.fp_init_stat = fp_init_stat;
	}
	level._challenges.a_stats[str_name] = stat;
	stat.cf_complete = "challenges.challenge_complete_" + level._challenges.a_stats.size;
}

/*
	Name: player_stats_init
	Namespace: zm_challenges_tomb
	Checksum: 0x6B2B6294
	Offset: 0xCF0
	Size: 0x2D8
	Parameters: 1
	Flags: Linked
*/
function player_stats_init(n_index)
{
	a_characters = array("d", "n", "r", "t");
	str_character = a_characters[n_index];
	if(!isdefined(level._challenges.a_players[n_index]))
	{
		level._challenges.a_players[n_index] = spawnstruct();
		level._challenges.a_players[n_index].a_stats = [];
	}
	s_player_set = level._challenges.a_players[n_index];
	n_challenge_index = 1;
	foreach(s_challenge in level._challenges.a_stats)
	{
		if(!s_challenge.b_team)
		{
			if(!isdefined(s_player_set.a_stats[s_challenge.str_name]))
			{
				s_player_set.a_stats[s_challenge.str_name] = spawnstruct();
			}
			s_stat = s_player_set.a_stats[s_challenge.str_name];
			s_stat.s_parent = s_challenge;
			s_stat.n_value = 0;
			s_stat.b_medal_awarded = 0;
			s_stat.b_reward_claimed = 0;
			n_index = level._challenges.a_stats.size + 1;
			s_stat.str_medal_tag = (("j_" + str_character) + "_medal_0") + n_challenge_index;
			s_stat.str_glow_tag = (("j_" + str_character) + "_glow_0") + n_challenge_index;
			s_stat.b_display_tag = 0;
			n_challenge_index++;
		}
	}
	s_player_set.n_completed = 0;
	s_player_set.n_medals_held = 0;
}

/*
	Name: team_stats_init
	Namespace: zm_challenges_tomb
	Checksum: 0xA2CA1301
	Offset: 0xFD0
	Size: 0x244
	Parameters: 1
	Flags: Linked
*/
function team_stats_init(n_index)
{
	if(!isdefined(level._challenges.s_team))
	{
		level._challenges.s_team = spawnstruct();
		level._challenges.s_team.a_stats = [];
	}
	s_team_set = level._challenges.s_team;
	foreach(s_challenge in level._challenges.a_stats)
	{
		if(s_challenge.b_team)
		{
			if(!isdefined(s_team_set.a_stats[s_challenge.str_name]))
			{
				s_team_set.a_stats[s_challenge.str_name] = spawnstruct();
			}
			s_stat = s_team_set.a_stats[s_challenge.str_name];
			s_stat.s_parent = s_challenge;
			s_stat.n_value = 0;
			s_stat.b_medal_awarded = 0;
			s_stat.b_reward_claimed = 0;
			s_stat.a_b_player_rewarded = array(0, 0, 0, 0);
			s_stat.str_medal_tag = "j_g_medal";
			s_stat.str_glow_tag = "j_g_glow";
			s_stat.b_display_tag = 1;
		}
	}
	s_team_set.n_completed = 0;
	s_team_set.n_medals_held = 0;
}

/*
	Name: challenge_exists
	Namespace: zm_challenges_tomb
	Checksum: 0xD251B990
	Offset: 0x1220
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function challenge_exists(str_name)
{
	if(isdefined(level._challenges.a_stats[str_name]))
	{
		return true;
	}
	return false;
}

/*
	Name: get_stat
	Namespace: zm_challenges_tomb
	Checksum: 0xC869CBAA
	Offset: 0x1260
	Size: 0x126
	Parameters: 2
	Flags: Linked
*/
function get_stat(str_stat, player)
{
	s_parent_stat = level._challenges.a_stats[str_stat];
	/#
		assert(isdefined(s_parent_stat), ("" + str_stat) + "");
	#/
	/#
		assert(s_parent_stat.b_team || isdefined(player), ("" + str_stat) + "");
	#/
	if(s_parent_stat.b_team)
	{
		s_stat = level._challenges.s_team.a_stats[str_stat];
	}
	else
	{
		s_stat = level._challenges.a_players[player.characterindex].a_stats[str_stat];
	}
	return s_stat;
}

/*
	Name: increment_stat
	Namespace: zm_challenges_tomb
	Checksum: 0xC1DA97C
	Offset: 0x1390
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function increment_stat(str_stat, n_increment = 1)
{
	s_stat = get_stat(str_stat, self);
	if(!s_stat.b_medal_awarded)
	{
		s_stat.n_value = s_stat.n_value + n_increment;
		check_stat_complete(s_stat);
	}
}

/*
	Name: set_stat
	Namespace: zm_challenges_tomb
	Checksum: 0xF2625A96
	Offset: 0x1438
	Size: 0x74
	Parameters: 2
	Flags: None
*/
function set_stat(str_stat, n_set)
{
	s_stat = get_stat(str_stat, self);
	if(!s_stat.b_medal_awarded)
	{
		s_stat.n_value = n_set;
		check_stat_complete(s_stat);
	}
}

/*
	Name: function_fbbc8608
	Namespace: zm_challenges_tomb
	Checksum: 0x8CA23E83
	Offset: 0x14B8
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function function_fbbc8608(str_hint, var_7ca2c2ae)
{
	self luinotifyevent(&"trial_complete", 3, &"ZM_TOMB_CHALLENGE_COMPLETED", str_hint, var_7ca2c2ae);
}

/*
	Name: check_stat_complete
	Namespace: zm_challenges_tomb
	Checksum: 0x4EEF580E
	Offset: 0x1508
	Size: 0x4CC
	Parameters: 1
	Flags: Linked
*/
function check_stat_complete(s_stat)
{
	if(s_stat.b_medal_awarded)
	{
		return true;
	}
	if(s_stat.n_value >= s_stat.s_parent.n_goal)
	{
		s_stat.b_medal_awarded = 1;
		if(s_stat.s_parent.b_team)
		{
			s_team_stats = level._challenges.s_team;
			s_team_stats.n_completed++;
			s_team_stats.n_medals_held++;
			a_players = getplayers();
			foreach(player in a_players)
			{
				player clientfield::set_to_player(s_stat.s_parent.cf_complete, 1);
				player function_fbbc8608(s_stat.s_parent.str_hint, s_stat.s_parent.n_index);
				player playsound("evt_medal_acquired");
				util::wait_network_frame();
			}
		}
		else
		{
			s_player_stats = level._challenges.a_players[self.characterindex];
			s_player_stats.n_completed++;
			s_player_stats.n_medals_held++;
			self playsound("evt_medal_acquired");
			self clientfield::set_to_player(s_stat.s_parent.cf_complete, 1);
			self function_fbbc8608(s_stat.s_parent.str_hint, s_stat.s_parent.n_index);
		}
		foreach(m_board in level.a_m_challenge_boards)
		{
			m_board showpart(s_stat.str_glow_tag);
		}
		if(isplayer(self))
		{
			if((level._challenges.a_players[self.characterindex].n_completed + level._challenges.s_team.n_completed) == level._challenges.a_stats.size)
			{
				self notify(#"all_challenges_complete");
			}
		}
		else
		{
			foreach(player in getplayers())
			{
				if(isdefined(player.characterindex))
				{
					if((level._challenges.a_players[player.characterindex].n_completed + level._challenges.s_team.n_completed) == level._challenges.a_stats.size)
					{
						player notify(#"all_challenges_complete");
					}
				}
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: stat_reward_available
	Namespace: zm_challenges_tomb
	Checksum: 0x979C8C8F
	Offset: 0x19E0
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function stat_reward_available(stat, player)
{
	if(isstring(stat))
	{
		s_stat = get_stat(stat, player);
	}
	else
	{
		s_stat = stat;
	}
	if(!s_stat.b_medal_awarded)
	{
		return false;
	}
	if(s_stat.b_reward_claimed)
	{
		return false;
	}
	if(s_stat.s_parent.b_team && s_stat.a_b_player_rewarded[player.characterindex])
	{
		return false;
	}
	return true;
}

/*
	Name: player_has_unclaimed_team_reward
	Namespace: zm_challenges_tomb
	Checksum: 0x3C2FEF19
	Offset: 0x1AB8
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function player_has_unclaimed_team_reward()
{
	foreach(s_stat in level._challenges.s_team.a_stats)
	{
		if(s_stat.b_medal_awarded && !s_stat.a_b_player_rewarded[self.characterindex])
		{
			return true;
		}
	}
	return false;
}

/*
	Name: board_init
	Namespace: zm_challenges_tomb
	Checksum: 0xFFA1D1F9
	Offset: 0x1B78
	Size: 0x5AA
	Parameters: 1
	Flags: Linked
*/
function board_init(m_board)
{
	self.m_board = m_board;
	a_challenges = getarraykeys(level._challenges.a_stats);
	a_characters = array("d", "n", "r", "t");
	m_board.a_s_medal_tags = [];
	b_team_hint_added = 0;
	foreach(n_char_index, s_set in level._challenges.a_players)
	{
		str_character = a_characters[n_char_index];
		n_challenge_index = 1;
		foreach(s_stat in s_set.a_stats)
		{
			str_medal_tag = (("j_" + str_character) + "_medal_0") + n_challenge_index;
			str_glow_tag = (("j_" + str_character) + "_glow_0") + n_challenge_index;
			s_tag = spawnstruct();
			s_tag.v_origin = m_board gettagorigin(str_medal_tag);
			s_tag.s_stat = s_stat;
			s_tag.n_character_index = n_char_index;
			s_tag.str_medal_tag = str_medal_tag;
			if(!isdefined(m_board.a_s_medal_tags))
			{
				m_board.a_s_medal_tags = [];
			}
			else if(!isarray(m_board.a_s_medal_tags))
			{
				m_board.a_s_medal_tags = array(m_board.a_s_medal_tags);
			}
			m_board.a_s_medal_tags[m_board.a_s_medal_tags.size] = s_tag;
			m_board hidepart(str_medal_tag);
			m_board hidepart(str_glow_tag);
			n_challenge_index++;
		}
	}
	foreach(s_stat in level._challenges.s_team.a_stats)
	{
		str_medal_tag = "j_g_medal";
		str_glow_tag = "j_g_glow";
		s_tag = spawnstruct();
		s_tag.v_origin = m_board gettagorigin(str_medal_tag);
		s_tag.s_stat = s_stat;
		s_tag.n_character_index = 4;
		s_tag.str_medal_tag = str_medal_tag;
		if(!isdefined(m_board.a_s_medal_tags))
		{
			m_board.a_s_medal_tags = [];
		}
		else if(!isarray(m_board.a_s_medal_tags))
		{
			m_board.a_s_medal_tags = array(m_board.a_s_medal_tags);
		}
		m_board.a_s_medal_tags[m_board.a_s_medal_tags.size] = s_tag;
		m_board hidepart(str_glow_tag);
		b_team_hint_added = 1;
	}
	if(!isdefined(level.a_m_challenge_boards))
	{
		level.a_m_challenge_boards = [];
	}
	else if(!isarray(level.a_m_challenge_boards))
	{
		level.a_m_challenge_boards = array(level.a_m_challenge_boards);
	}
	level.a_m_challenge_boards[level.a_m_challenge_boards.size] = m_board;
}

/*
	Name: box_init
	Namespace: zm_challenges_tomb
	Checksum: 0x31CEFC0E
	Offset: 0x2130
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function box_init()
{
	s_unitrigger_stub = spawnstruct();
	s_unitrigger_stub.origin = self.origin + (0, 0, 0);
	s_unitrigger_stub.angles = self.angles;
	s_unitrigger_stub.radius = 64;
	s_unitrigger_stub.script_length = 64;
	s_unitrigger_stub.script_width = 64;
	s_unitrigger_stub.script_height = 64;
	s_unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_unitrigger_stub.hint_string = &"";
	s_unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_unitrigger_stub.prompt_and_visibility_func = &box_prompt_and_visiblity;
	s_unitrigger_stub flag::init("waiting_for_grab");
	s_unitrigger_stub flag::init("reward_timeout");
	s_unitrigger_stub.b_busy = 0;
	s_unitrigger_stub.m_box = self;
	s_unitrigger_stub.b_disable_trigger = 0;
	if(isdefined(self.script_string))
	{
		s_unitrigger_stub.str_location = self.script_string;
	}
	if(isdefined(s_unitrigger_stub.m_box.target))
	{
		s_unitrigger_stub.m_board = getent(s_unitrigger_stub.m_box.target, "targetname");
		s_unitrigger_stub board_init(s_unitrigger_stub.m_board);
	}
	zm_unitrigger::unitrigger_force_per_player_triggers(s_unitrigger_stub, 1);
	if(!isdefined(level.a_uts_challenge_boxes))
	{
		level.a_uts_challenge_boxes = [];
	}
	else if(!isarray(level.a_uts_challenge_boxes))
	{
		level.a_uts_challenge_boxes = array(level.a_uts_challenge_boxes);
	}
	level.a_uts_challenge_boxes[level.a_uts_challenge_boxes.size] = s_unitrigger_stub;
	zm_unitrigger::register_static_unitrigger(s_unitrigger_stub, &box_think);
}

/*
	Name: box_prompt_and_visiblity
	Namespace: zm_challenges_tomb
	Checksum: 0x7163C67B
	Offset: 0x23E0
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function box_prompt_and_visiblity(player)
{
	if(self.stub.b_disable_trigger)
	{
		return false;
	}
	self update_box_prompt(player);
	return true;
}

/*
	Name: update_box_prompt
	Namespace: zm_challenges_tomb
	Checksum: 0x30FB243D
	Offset: 0x2428
	Size: 0x544
	Parameters: 1
	Flags: Linked
*/
function update_box_prompt(player)
{
	str_hint = &"";
	str_old_hint = &"";
	m_board = self.stub.m_board;
	self sethintstring(str_hint);
	s_hint_tag = undefined;
	b_showing_stat = 0;
	self.b_can_open = 0;
	if(self.stub.b_busy)
	{
		if(self.stub flag::get("waiting_for_grab") && (!isdefined(self.stub.player_using) || self.stub.player_using == player))
		{
			str_hint = &"ZM_TOMB_CH_G";
		}
		else
		{
			str_hint = &"";
		}
	}
	else
	{
		str_hint = &"";
		player.s_lookat_stat = undefined;
		n_closest_dot = 0.996;
		v_eye_origin = player getplayercamerapos();
		v_eye_direction = anglestoforward(player getplayerangles());
		foreach(s_tag in m_board.a_s_medal_tags)
		{
			if(!s_tag.s_stat.b_display_tag)
			{
				continue;
			}
			v_tag_origin = s_tag.v_origin;
			v_eye_to_tag = vectornormalize(v_tag_origin - v_eye_origin);
			n_dot = vectordot(v_eye_to_tag, v_eye_direction);
			if(n_dot > n_closest_dot)
			{
				n_closest_dot = n_dot;
				str_hint = s_tag.s_stat.s_parent.str_hint;
				s_hint_tag = s_tag;
				b_showing_stat = 1;
				self.b_can_open = 0;
				if(s_tag.n_character_index == player.characterindex || s_tag.n_character_index == 4)
				{
					player.s_lookat_stat = s_tag.s_stat;
					if(stat_reward_available(s_tag.s_stat, player))
					{
						str_hint = &"ZM_TOMB_CH_S";
						b_showing_stat = 0;
						self.b_can_open = 1;
					}
				}
			}
		}
		if(str_hint == (&""))
		{
			s_player = level._challenges.a_players[player.characterindex];
			s_team = level._challenges.s_team;
			if(s_player.n_medals_held > 0 || player player_has_unclaimed_team_reward())
			{
				str_hint = &"ZM_TOMB_CH_O";
				self.b_can_open = 1;
			}
			else
			{
				str_hint = &"ZM_TOMB_CH_V";
			}
		}
	}
	if(str_old_hint != str_hint)
	{
		str_old_hint = str_hint;
		self.stub.hint_string = str_hint;
		if(isdefined(s_hint_tag))
		{
			str_name = s_hint_tag.s_stat.s_parent.str_name;
			n_character_index = s_hint_tag.n_character_index;
			if(n_character_index != 4)
			{
				s_player_stat = level._challenges.a_players[n_character_index].a_stats[str_name];
			}
		}
		self sethintstring(self.stub.hint_string);
	}
}

/*
	Name: box_think
	Namespace: zm_challenges_tomb
	Checksum: 0x30FC7C97
	Offset: 0x2978
	Size: 0x290
	Parameters: 0
	Flags: Linked
*/
function box_think()
{
	self endon(#"kill_trigger");
	s_team = level._challenges.s_team;
	while(true)
	{
		self waittill(#"trigger", player);
		if(!zombie_utility::is_player_valid(player))
		{
			continue;
		}
		if(self.stub.b_busy)
		{
			current_weapon = player getcurrentweapon();
			if(isdefined(player.intermission) && player.intermission || zm_utility::is_placeable_mine(current_weapon) || zm_equipment::is_equipment_that_blocks_purchase(current_weapon) || current_weapon == level.weaponnone || player laststand::player_is_in_laststand() || player isthrowinggrenade() || player zm_utility::in_revive_trigger() || player isswitchingweapons() || player.is_drinking > 0)
			{
				wait(0.1);
				continue;
			}
			if(self.stub flag::get("waiting_for_grab"))
			{
				if(!isdefined(self.stub.player_using))
				{
					self.stub.player_using = player;
				}
				if(player == self.stub.player_using)
				{
					self.stub flag::clear("waiting_for_grab");
				}
			}
			wait(0.05);
			continue;
		}
		if(self.b_can_open)
		{
			self.stub.hint_string = &"";
			self sethintstring(self.stub.hint_string);
			level thread open_box(player, self.stub);
		}
	}
}

/*
	Name: get_reward_category
	Namespace: zm_challenges_tomb
	Checksum: 0x9B6FBD47
	Offset: 0x2C10
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function get_reward_category(player, s_select_stat)
{
	if(isdefined(s_select_stat) && s_select_stat.s_parent.b_team || level._challenges.s_team.n_medals_held > 0)
	{
		return level._challenges.s_team;
	}
	if(level._challenges.a_players[player.characterindex].n_medals_held > 0)
	{
		return level._challenges.a_players[player.characterindex];
	}
	return undefined;
}

/*
	Name: get_reward_stat
	Namespace: zm_challenges_tomb
	Checksum: 0x4C4F0EF1
	Offset: 0x2CD8
	Size: 0xE6
	Parameters: 1
	Flags: Linked
*/
function get_reward_stat(s_category)
{
	foreach(s_stat in s_category.a_stats)
	{
		if(s_stat.b_medal_awarded && !s_stat.b_reward_claimed)
		{
			if(s_stat.s_parent.b_team && s_stat.a_b_player_rewarded[self.characterindex])
			{
				continue;
			}
			return s_stat;
		}
	}
	return undefined;
}

/*
	Name: open_box
	Namespace: zm_challenges_tomb
	Checksum: 0x46EF9A36
	Offset: 0x2DC8
	Size: 0x1E2
	Parameters: 4
	Flags: Linked
*/
function open_box(player, ut_stub, fp_reward_override, param1)
{
	m_box = ut_stub.m_box;
	while(ut_stub.b_busy)
	{
		wait(1);
	}
	ut_stub.b_busy = 1;
	ut_stub.player_using = player;
	if(isdefined(player) && isdefined(player.s_lookat_stat))
	{
		s_select_stat = player.s_lookat_stat;
	}
	m_box thread scene::play("p7_fxanim_zm_ori_challenge_box_open_bundle", m_box);
	m_box util::delay(0.75, undefined, &clientfield::set, "foot_print_box_glow", 1);
	wait(0.5);
	if(isdefined(fp_reward_override))
	{
		ut_stub [[fp_reward_override]](player, param1);
	}
	else
	{
		ut_stub spawn_reward(player, s_select_stat);
	}
	wait(1);
	m_box thread scene::play("p7_fxanim_zm_ori_challenge_box_close_bundle", m_box);
	m_box util::delay(0.75, undefined, &clientfield::set, "foot_print_box_glow", 0);
	wait(2);
	ut_stub.b_busy = 0;
	ut_stub.player_using = undefined;
}

/*
	Name: spawn_reward
	Namespace: zm_challenges_tomb
	Checksum: 0x31E82253
	Offset: 0x2FB8
	Size: 0x254
	Parameters: 2
	Flags: Linked
*/
function spawn_reward(player, s_select_stat)
{
	if(isdefined(player))
	{
		player endon(#"death_or_disconnect");
		if(isdefined(s_select_stat))
		{
			s_category = get_reward_category(player, s_select_stat);
			if(stat_reward_available(s_select_stat, player))
			{
				s_stat = s_select_stat;
			}
		}
		if(!isdefined(s_stat))
		{
			s_category = get_reward_category(player);
			s_stat = player get_reward_stat(s_category);
		}
		if(self [[s_stat.s_parent.fp_give_reward]](player, s_stat))
		{
			if(isdefined(s_stat.s_parent.cf_complete))
			{
				player clientfield::set_to_player(s_stat.s_parent.cf_complete, 2);
			}
			if(s_stat.s_parent.b_team)
			{
				s_stat.a_b_player_rewarded[player.characterindex] = 1;
				a_players = getplayers();
				foreach(player in a_players)
				{
					if(!s_stat.a_b_player_rewarded[player.characterindex])
					{
						return;
					}
				}
			}
			s_stat.b_reward_claimed = 1;
			s_category.n_medals_held--;
		}
	}
}

/*
	Name: reward_grab_wait
	Namespace: zm_challenges_tomb
	Checksum: 0x99B65DF1
	Offset: 0x3218
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function reward_grab_wait(n_timeout = 10)
{
	self flag::clear("reward_timeout");
	self flag::set("waiting_for_grab");
	self endon(#"waiting_for_grab");
	if(n_timeout > 0)
	{
		wait(n_timeout);
		self flag::set("reward_timeout");
		self flag::clear("waiting_for_grab");
	}
	else
	{
		self flag::wait_till_clear("waiting_for_grab");
	}
}

/*
	Name: reward_sink
	Namespace: zm_challenges_tomb
	Checksum: 0x9465FB9B
	Offset: 0x32F8
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function reward_sink(n_delay, n_z, n_time)
{
	if(isdefined(n_delay))
	{
		wait(n_delay);
		if(isdefined(self))
		{
			self movez(n_z * -1, n_time);
		}
	}
}

/*
	Name: reward_rise_and_grab
	Namespace: zm_challenges_tomb
	Checksum: 0xDE7E3A53
	Offset: 0x3358
	Size: 0xC6
	Parameters: 5
	Flags: Linked
*/
function reward_rise_and_grab(m_reward, n_z, n_rise_time, n_delay, n_timeout)
{
	m_reward movez(n_z, n_rise_time);
	wait(n_rise_time);
	if(n_timeout > 0)
	{
		m_reward thread reward_sink(n_delay, n_z, n_timeout + 1);
	}
	self reward_grab_wait(n_timeout);
	if(self flag::get("reward_timeout"))
	{
		return false;
	}
	return true;
}

/*
	Name: reward_points
	Namespace: zm_challenges_tomb
	Checksum: 0x8F6CBCB8
	Offset: 0x3428
	Size: 0x2C
	Parameters: 2
	Flags: None
*/
function reward_points(player, s_stat)
{
	player zm_score::add_to_player_score(2500);
}

/*
	Name: challenges_devgui
	Namespace: zm_challenges_tomb
	Checksum: 0xE58F6653
	Offset: 0x3460
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function challenges_devgui()
{
	/#
		setdvar("", "");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		thread watch_devgui_award_challenges();
	#/
}

/*
	Name: watch_devgui_award_challenges
	Namespace: zm_challenges_tomb
	Checksum: 0x67226673
	Offset: 0x3508
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function watch_devgui_award_challenges()
{
	/#
		while(true)
		{
			n_award_challenge = getdvarint("");
			if(n_award_challenge != 0)
			{
				devgui_award_challenge(n_award_challenge);
				setdvar("", 0);
			}
			wait(0.5);
		}
	#/
}

/*
	Name: devgui_award_challenge
	Namespace: zm_challenges_tomb
	Checksum: 0xA884A870
	Offset: 0x3590
	Size: 0x4E0
	Parameters: 1
	Flags: Linked
*/
function devgui_award_challenge(n_index)
{
	/#
		if(n_index == 4)
		{
			s_team_stats = level._challenges.s_team;
			s_team_stats.n_completed = 1;
			s_team_stats.n_medals_held = 1;
			a_keys = getarraykeys(level._challenges.s_team.a_stats);
			s_stat = level._challenges.s_team.a_stats[a_keys[0]];
			s_stat.b_medal_awarded = 1;
			s_stat.b_reward_claimed = 0;
			a_players = getplayers();
			foreach(player in a_players)
			{
				s_stat.a_b_player_rewarded[player.characterindex] = 0;
				player clientfield::set_to_player(s_stat.s_parent.cf_complete, 1);
				player function_fbbc8608(s_stat.s_parent.str_hint, s_stat.s_parent.n_index);
			}
			foreach(m_board in level.a_m_challenge_boards)
			{
				m_board showpart(s_stat.str_glow_tag);
			}
		}
		else
		{
			a_keys = getarraykeys(level._challenges.a_players[0].a_stats);
			a_players = getplayers();
			foreach(player in a_players)
			{
				s_player_data = level._challenges.a_players[player.characterindex];
				s_player_data.n_completed++;
				s_player_data.n_medals_held++;
				s_stat = s_player_data.a_stats[a_keys[n_index - 1]];
				s_stat.b_medal_awarded = 1;
				s_stat.b_reward_claimed = 0;
				player clientfield::set_to_player(s_stat.s_parent.cf_complete, 1);
				player function_fbbc8608(s_stat.s_parent.str_hint, s_stat.s_parent.n_index);
				foreach(m_board in level.a_m_challenge_boards)
				{
					m_board showpart(s_stat.str_glow_tag);
				}
			}
		}
	#/
}

