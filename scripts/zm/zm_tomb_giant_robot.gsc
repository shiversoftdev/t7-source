// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_clone;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_one_inch_punch;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_tomb_amb;
#using scripts\zm\zm_tomb_mech;
#using scripts\zm\zm_tomb_teleporter;
#using scripts\zm\zm_tomb_vo;

#using_animtree("generic");

#namespace zm_tomb_giant_robot;

/*
	Name: init_giant_robot_glows
	Namespace: zm_tomb_giant_robot
	Checksum: 0x91CC9DCE
	Offset: 0xFE8
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function init_giant_robot_glows()
{
	level flag::init("foot_shot");
	level flag::init("three_robot_round");
	level flag::init("fire_link_enabled");
	level flag::init("timeout_vo_robot_0");
	level flag::init("timeout_vo_robot_1");
	level flag::init("timeout_vo_robot_2");
	level flag::init("all_robot_hatch");
	level thread setup_giant_robot_devgui();
	level.gr_foot_hatch_closed = [];
	level.gr_foot_hatch_closed[0] = 1;
	level.gr_foot_hatch_closed[1] = 1;
	level.gr_foot_hatch_closed[2] = 1;
	a_gr_head_triggers = struct::get_array("giant_robot_head_exit_trigger", "script_noteworthy");
	foreach(struct in a_gr_head_triggers)
	{
		gr_head_exit_trigger_start(struct);
	}
	level thread handle_wind_tunnel_bunker_collision();
	level thread handle_tank_bunker_collision();
}

/*
	Name: init_giant_robot
	Namespace: zm_tomb_giant_robot
	Checksum: 0xAD6D319B
	Offset: 0x1210
	Size: 0x3D4
	Parameters: 0
	Flags: Linked
*/
function init_giant_robot()
{
	clientfield::register("scriptmover", "register_giant_robot", 21000, 1, "int");
	clientfield::register("world", "start_anim_robot_0", 21000, 1, "int");
	clientfield::register("world", "start_anim_robot_1", 21000, 1, "int");
	clientfield::register("world", "start_anim_robot_2", 21000, 1, "int");
	clientfield::register("world", "play_foot_stomp_fx_robot_0", 21000, 2, "int");
	clientfield::register("world", "play_foot_stomp_fx_robot_1", 21000, 2, "int");
	clientfield::register("world", "play_foot_stomp_fx_robot_2", 21000, 2, "int");
	clientfield::register("world", "play_foot_open_fx_robot_0", 21000, 2, "int");
	clientfield::register("world", "play_foot_open_fx_robot_1", 21000, 2, "int");
	clientfield::register("world", "play_foot_open_fx_robot_2", 21000, 2, "int");
	clientfield::register("world", "eject_warning_fx_robot_0", 21000, 1, "int");
	clientfield::register("world", "eject_warning_fx_robot_1", 21000, 1, "int");
	clientfield::register("world", "eject_warning_fx_robot_2", 21000, 1, "int");
	clientfield::register("scriptmover", "light_foot_fx_robot", 21000, 2, "int");
	clientfield::register("allplayers", "eject_steam_fx", 21000, 1, "int");
	clientfield::register("allplayers", "all_tubes_play_eject_steam_fx", 21000, 1, "int");
	clientfield::register("allplayers", "gr_eject_player_impact_fx", 21000, 1, "int");
	clientfield::register("toplayer", "giant_robot_rumble_and_shake", 21000, 2, "int");
	clientfield::register("world", "church_ceiling_fxanim", 21000, 1, "int");
	level thread giant_robot_initial_spawns();
	level thread setup_giant_robots_intermission();
	init_footstep_safe_spots();
}

/*
	Name: init_footstep_safe_spots
	Namespace: zm_tomb_giant_robot
	Checksum: 0x1902F931
	Offset: 0x15F0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function init_footstep_safe_spots()
{
	level.giant_robot_footstep_safe_spots = [];
	make_safe_spot_trigger_box_at_point((-493, -198, 389), (0, 0, 0), 80, 64, 150);
}

/*
	Name: make_safe_spot_trigger_box_at_point
	Namespace: zm_tomb_giant_robot
	Checksum: 0x59DC2252
	Offset: 0x1640
	Size: 0xE2
	Parameters: 5
	Flags: Linked
*/
function make_safe_spot_trigger_box_at_point(v_origin, v_angles, n_length, n_width, n_height)
{
	trig = spawn("trigger_box", v_origin, 0, n_length, n_width, n_height);
	trig.angles = v_angles;
	if(!isdefined(level.giant_robot_footstep_safe_spots))
	{
		level.giant_robot_footstep_safe_spots = [];
	}
	else if(!isarray(level.giant_robot_footstep_safe_spots))
	{
		level.giant_robot_footstep_safe_spots = array(level.giant_robot_footstep_safe_spots);
	}
	level.giant_robot_footstep_safe_spots[level.giant_robot_footstep_safe_spots.size] = trig;
}

/*
	Name: tomb_can_revive_override
	Namespace: zm_tomb_giant_robot
	Checksum: 0x70430052
	Offset: 0x1730
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function tomb_can_revive_override(player_down)
{
	if(isdefined(player_down.is_stomped) && player_down.is_stomped)
	{
		return false;
	}
	return true;
}

/*
	Name: giant_robot_initial_spawns
	Namespace: zm_tomb_giant_robot
	Checksum: 0xEBBA9832
	Offset: 0x1778
	Size: 0x6BC
	Parameters: 0
	Flags: Linked
*/
function giant_robot_initial_spawns()
{
	while(!level flag::exists("start_zombie_round_logic"))
	{
		wait(0.5);
	}
	level flag::wait_till("start_zombie_round_logic");
	level.a_giant_robots = [];
	for(i = 0; i < 3; i++)
	{
		level.gr_foot_hatch_closed[i] = 1;
		trig_stomp_kill_right = getent("trig_stomp_kill_right_" + i, "targetname");
		trig_stomp_kill_left = getent("trig_stomp_kill_left_" + i, "targetname");
		trig_stomp_kill_right enablelinkto();
		trig_stomp_kill_left enablelinkto();
		clip_foot_right = getent("clip_foot_right_" + i, "targetname");
		clip_foot_left = getent("clip_foot_left_" + i, "targetname");
		ai = getent("giant_robot_" + i, "targetname");
		ai setignorepauseworld(1);
		ai.v_start_origin = ai.origin;
		ai.is_giant_robot = 1;
		ai.giant_robot_id = i;
		ai.ignore_enemy_count = 1;
		tag_right_foot = ai gettagorigin("TAG_ATTACH_HATCH_RI");
		tag_left_foot = ai gettagorigin("TAG_ATTACH_HATCH_LE");
		if(ai.targetname == "giant_robot_1")
		{
			n_offset = 80;
		}
		else
		{
			n_offset = 72;
		}
		trig_stomp_kill_right.origin = tag_right_foot + (0, 0, n_offset);
		trig_stomp_kill_right.angles = ai gettagangles("TAG_ATTACH_HATCH_RI");
		trig_stomp_kill_left.origin = tag_left_foot + (0, 0, n_offset);
		trig_stomp_kill_left.angles = ai gettagangles("TAG_ATTACH_HATCH_LE");
		wait(0.1);
		trig_stomp_kill_right linkto(ai, "tag_attach_hatch_ri", (0, 0, n_offset));
		util::wait_network_frame();
		trig_stomp_kill_left linkto(ai, "tag_attach_hatch_le", (0, 0, n_offset));
		util::wait_network_frame();
		ai.trig_stomp_kill_right = trig_stomp_kill_right;
		ai.trig_stomp_kill_left = trig_stomp_kill_left;
		clip_foot_right.origin = tag_right_foot + (0, 0, 0);
		clip_foot_left.origin = tag_left_foot + (0, 0, 0);
		clip_foot_right.angles = ai gettagangles("TAG_ATTACH_HATCH_RI");
		clip_foot_left.angles = ai gettagangles("TAG_ATTACH_HATCH_LE");
		wait(0.1);
		clip_foot_right linkto(ai, "tag_attach_hatch_ri", (0, 0, 0));
		util::wait_network_frame();
		clip_foot_left linkto(ai, "tag_attach_hatch_le", (0, 0, 0));
		util::wait_network_frame();
		ai.clip_foot_right = clip_foot_right;
		ai.clip_foot_left = clip_foot_left;
		ai.is_zombie = 0;
		ai.animname = "giant_robot_walker";
		ai.script_noteworthy = "giant_robot";
		ai.audio_type = "giant_robot";
		ai.ignoreall = 1;
		ai.ignoreme = 1;
		ai.ignore_game_over_death = 1;
		ai setcandamage(0);
		ai setplayercollision(1);
		ai setforcenocull();
		ai clientfield::set("register_giant_robot", 1);
		ai ghost();
		ai flag::init("robot_head_entered");
		ai flag::init("kill_trigger_active");
		level.a_giant_robots[i] = ai;
		util::wait_network_frame();
	}
	level thread robot_cycling();
}

/*
	Name: robot_cycling
	Namespace: zm_tomb_giant_robot
	Checksum: 0x488B0EBA
	Offset: 0x1E40
	Size: 0x3DA
	Parameters: 0
	Flags: Linked
*/
function robot_cycling()
{
	three_robot_round = 0;
	last_robot = -1;
	level thread giant_robot_intro_walk(1);
	level waittill(#"giant_robot_intro_complete");
	while(true)
	{
		if(!level.round_number % 4 && three_robot_round != level.round_number)
		{
			level flag::set("three_robot_round");
		}
		if(level flag::get("ee_all_staffs_placed") && !level flag::get("ee_mech_zombie_hole_opened"))
		{
			level flag::set("three_robot_round");
		}
		/#
			if(isdefined(level.devgui_force_three_robot_round) && level.devgui_force_three_robot_round)
			{
				level flag::set("");
			}
		#/
		if(level flag::get("three_robot_round"))
		{
			level.zombie_ai_limit = 22;
			random_number = randomint(3);
			if(random_number == 2 || level flag::get("all_robot_hatch"))
			{
				level thread giant_robot_start_walk(2);
			}
			else
			{
				level thread giant_robot_start_walk(2, 0);
			}
			wait(5);
			if(random_number == 0 || level flag::get("all_robot_hatch"))
			{
				level thread giant_robot_start_walk(0);
			}
			else
			{
				level thread giant_robot_start_walk(0, 0);
			}
			wait(5);
			if(random_number == 1 || level flag::get("all_robot_hatch"))
			{
				level thread giant_robot_start_walk(1);
			}
			else
			{
				level thread giant_robot_start_walk(1, 0);
			}
			level waittill(#"giant_robot_walk_cycle_complete");
			level waittill(#"giant_robot_walk_cycle_complete");
			level waittill(#"giant_robot_walk_cycle_complete");
			wait(5);
			level.zombie_ai_limit = 24;
			three_robot_round = level.round_number;
			last_robot = -1;
			level flag::clear("three_robot_round");
		}
		else
		{
			if(!level flag::get("activate_zone_nml"))
			{
				random_number = randomint(2);
			}
			random_number = randomint(3);
			/#
				if(isdefined(level.devgui_force_giant_robot))
				{
					random_number = level.devgui_force_giant_robot;
				}
			#/
			last_robot = random_number;
			level thread giant_robot_start_walk(random_number);
			level waittill(#"giant_robot_walk_cycle_complete");
			wait(5);
		}
	}
}

/*
	Name: giant_robot_intro_walk
	Namespace: zm_tomb_giant_robot
	Checksum: 0x501DD246
	Offset: 0x2228
	Size: 0x1FE
	Parameters: 1
	Flags: Linked
*/
function giant_robot_intro_walk(n_robot_id)
{
	ai = getent("giant_robot_" + n_robot_id, "targetname");
	ai attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_LE");
	ai attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_RI");
	ai thread giant_robot_think(ai.trig_stomp_kill_right, ai.trig_stomp_kill_left, ai.clip_foot_right, ai.clip_foot_left, undefined, 3);
	playsoundatposition("evt_footfall_robot_intro", (0, 0, 0));
	wait(0.5);
	exploder::exploder("fxexp_420");
	a_players = getplayers();
	foreach(player in a_players)
	{
		player clientfield::set_to_player("giant_robot_rumble_and_shake", 3);
		player thread turn_clientside_rumble_off();
	}
	level waittill(#"giant_robot_walk_cycle_complete");
	level notify(#"giant_robot_intro_complete");
}

/*
	Name: giant_robot_start_walk
	Namespace: zm_tomb_giant_robot
	Checksum: 0xDC703171
	Offset: 0x2430
	Size: 0x4E4
	Parameters: 2
	Flags: Linked
*/
function giant_robot_start_walk(n_robot_id, b_has_hatch = 1)
{
	ai = getent("giant_robot_" + n_robot_id, "targetname");
	level.gr_foot_hatch_closed[n_robot_id] = 1;
	ai.b_has_hatch = b_has_hatch;
	ai flag::clear("kill_trigger_active");
	ai flag::clear("robot_head_entered");
	if(isdefined(ai.b_has_hatch) && ai.b_has_hatch)
	{
		m_sole = getent("target_sole_" + n_robot_id, "targetname");
	}
	if(isdefined(m_sole) && (isdefined(ai.b_has_hatch) && ai.b_has_hatch))
	{
		m_sole setcandamage(1);
		m_sole.health = 99999;
		m_sole useanimtree($generic);
		m_sole unlink();
	}
	wait(10);
	if(isdefined(m_sole))
	{
		if(math::cointoss())
		{
			ai.hatch_foot = "left";
		}
		else
		{
			ai.hatch_foot = "right";
		}
		/#
			if(isdefined(level.devgui_force_giant_robot_foot) && (isdefined(ai.b_has_hatch) && ai.b_has_hatch))
			{
				ai.hatch_foot = level.devgui_force_giant_robot_foot;
			}
		#/
		if(ai.hatch_foot == "left")
		{
			n_sole_origin = ai gettagorigin("TAG_ATTACH_HATCH_LE");
			v_sole_angles = ai gettagangles("TAG_ATTACH_HATCH_LE");
			ai.hatch_foot = "left";
			str_sole_tag = "tag_attach_hatch_le";
			ai attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_RI");
		}
		else if(ai.hatch_foot == "right")
		{
			n_sole_origin = ai gettagorigin("TAG_ATTACH_HATCH_RI");
			v_sole_angles = ai gettagangles("TAG_ATTACH_HATCH_RI");
			ai.hatch_foot = "right";
			str_sole_tag = "tag_attach_hatch_ri";
			ai attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_LE");
		}
		m_sole.origin = n_sole_origin;
		m_sole.angles = v_sole_angles;
		wait(0.1);
		m_sole linkto(ai, str_sole_tag, (0, 0, 0));
		m_sole show();
	}
	if(!(isdefined(ai.b_has_hatch) && ai.b_has_hatch))
	{
		ai attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_RI");
		ai attach("veh_t7_zhd_robot_foot_hatch", "TAG_ATTACH_HATCH_LE");
	}
	wait(0.05);
	ai thread giant_robot_think(ai.trig_stomp_kill_right, ai.trig_stomp_kill_left, ai.clip_foot_right, ai.clip_foot_left, m_sole, n_robot_id);
}

/*
	Name: giant_robot_think
	Namespace: zm_tomb_giant_robot
	Checksum: 0xB63F876
	Offset: 0x2920
	Size: 0x5BA
	Parameters: 6
	Flags: Linked
*/
function giant_robot_think(trig_stomp_kill_right, trig_stomp_kill_left, clip_foot_right, clip_foot_left, m_sole, n_robot_id)
{
	self thread robot_walk_animation(n_robot_id);
	if(isdefined(self.hatch_foot) && (isdefined(self.b_has_hatch) && self.b_has_hatch))
	{
		switch(self.hatch_foot)
		{
			case "left":
			{
				self clientfield::set("light_foot_fx_robot", 1);
				break;
			}
			case "right":
			{
				self clientfield::set("light_foot_fx_robot", 2);
				break;
			}
			default:
			{
				self clientfield::set("light_foot_fx_robot", 0);
				break;
			}
		}
	}
	else
	{
		self clientfield::set("light_foot_fx_robot", 0);
	}
	self show();
	if(isdefined(m_sole))
	{
		self thread sole_cleanup(m_sole);
	}
	self.is_walking = 1;
	self thread monitor_footsteps(trig_stomp_kill_right, "right");
	self thread monitor_footsteps(trig_stomp_kill_left, "left");
	self thread monitor_footsteps_fx(trig_stomp_kill_right, "right");
	self thread monitor_footsteps_fx(trig_stomp_kill_left, "left");
	self thread monitor_shadow_notetracks("right");
	self thread monitor_shadow_notetracks("left");
	self thread sndgrthreads("left");
	self thread sndgrthreads("right");
	if(isdefined(m_sole) && level.gr_foot_hatch_closed[n_robot_id] && (isdefined(self.b_has_hatch) && self.b_has_hatch))
	{
		self thread giant_robot_foot_waittill_sole_shot(m_sole);
	}
	a_players = getplayers();
	if(n_robot_id != 3 && (!(isdefined(level.giant_robot_discovered) && level.giant_robot_discovered)))
	{
		foreach(player in a_players)
		{
			player thread giant_robot_discovered_vo(self);
		}
	}
	else if(level flag::get("three_robot_round") && (!(isdefined(level.three_robot_round_vo) && level.three_robot_round_vo)))
	{
		foreach(player in a_players)
		{
			player thread three_robot_round_vo(self);
		}
	}
	if(n_robot_id != 3 && (!(isdefined(level.shoot_robot_vo) && level.shoot_robot_vo)))
	{
		foreach(player in a_players)
		{
			player thread shoot_at_giant_robot_vo(self);
		}
	}
	self waittill(#"giant_robot_stop");
	self.is_walking = 0;
	self stopanimscripted();
	self.origin = self.v_start_origin;
	level clientfield::set("play_foot_open_fx_robot_" + self.giant_robot_id, 0);
	self clientfield::set("light_foot_fx_robot", 0);
	self ghost();
	self detachall();
	level notify(#"giant_robot_walk_cycle_complete");
}

/*
	Name: sole_cleanup
	Namespace: zm_tomb_giant_robot
	Checksum: 0xEE1632A3
	Offset: 0x2EE8
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function sole_cleanup(m_sole)
{
	self endon(#"death");
	self endon(#"giant_robot_stop");
	util::wait_network_frame();
	m_sole clearanim(%generic::root, 0);
	util::wait_network_frame();
	m_sole animscripted("hatch_anim", m_sole.origin, m_sole.angles, "ai_zm_dlc5_zombie_giant_robot_hatch_close");
}

/*
	Name: giant_robot_foot_waittill_sole_shot
	Namespace: zm_tomb_giant_robot
	Checksum: 0xC907A567
	Offset: 0x2FA0
	Size: 0x244
	Parameters: 1
	Flags: Linked
*/
function giant_robot_foot_waittill_sole_shot(m_sole)
{
	self endon(#"death");
	self endon(#"giant_robot_stop");
	if(isdefined(self.hatch_foot) && self.hatch_foot == "left")
	{
		str_tag = "TAG_ATTACH_HATCH_LE";
		n_foot = 2;
	}
	else if(isdefined(self.hatch_foot) && self.hatch_foot == "right")
	{
		str_tag = "TAG_ATTACH_HATCH_RI";
		n_foot = 1;
	}
	self waittill(#"kill_zombies_leftfoot_1");
	wait(1);
	m_sole waittill(#"damage", amount, inflictor, direction, point, type, tagname, modelname, partname, weaponname, idflags);
	m_sole.health = 99999;
	level.gr_foot_hatch_closed[self.giant_robot_id] = 0;
	level clientfield::set("play_foot_open_fx_robot_" + self.giant_robot_id, n_foot);
	m_sole animscripted("hatch_anim", m_sole.origin, m_sole.angles, "ai_zm_dlc5_zombie_giant_robot_hatch_open");
	n_time = getanimlength(%generic::ai_zm_dlc5_zombie_giant_robot_hatch_open);
	wait(n_time);
	m_sole animscripted("hatch_anim", m_sole.origin, m_sole.angles, "ai_zm_dlc5_zombie_giant_robot_hatch_open_idle");
}

/*
	Name: giant_robot_close_head_entrance
	Namespace: zm_tomb_giant_robot
	Checksum: 0x7A48F540
	Offset: 0x31F0
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function giant_robot_close_head_entrance(foot_side)
{
	level endon(#"intermission");
	wait(5);
	level.gr_foot_hatch_closed[self.giant_robot_id] = 1;
	level clientfield::set("play_foot_open_fx_robot_" + self.giant_robot_id, 0);
	m_sole = getent("target_sole_" + self.giant_robot_id, "targetname");
	if(isdefined(m_sole))
	{
		m_sole animscripted("hatch_anim", m_sole.origin, m_sole.angles, "ai_zm_dlc5_zombie_giant_robot_hatch_close");
		self clientfield::set("light_foot_fx_robot", 0);
	}
}

/*
	Name: robot_walk_animation
	Namespace: zm_tomb_giant_robot
	Checksum: 0x5B9BF4CF
	Offset: 0x32F8
	Size: 0x23C
	Parameters: 1
	Flags: Linked
*/
function robot_walk_animation(n_robot_id)
{
	if(n_robot_id != 3)
	{
		level clientfield::set("start_anim_robot_" + n_robot_id, 1);
		self thread start_footprint_warning_vo(n_robot_id);
	}
	if(n_robot_id == 0)
	{
		level scene::play("cin_tomb_giant_robot_walk_nml_intro", self);
		level scene::play("cin_tomb_giant_robot_walk_nml", self);
		level scene::play("cin_tomb_giant_robot_walk_nml_outtro", self);
		self notify(#"giant_robot_stop");
	}
	else
	{
		if(n_robot_id == 1)
		{
			level scene::play("cin_tomb_giant_robot_walk_trenches_intro", self);
			level scene::play("cin_tomb_giant_robot_walk_trenches", self);
			level scene::play("cin_tomb_giant_robot_walk_trenches_outtro", self);
			self notify(#"giant_robot_stop");
		}
		else
		{
			if(n_robot_id == 2)
			{
				level scene::play("cin_tomb_giant_robot_walk_village_intro", self);
				level scene::play("cin_tomb_giant_robot_walk_village", self);
				level scene::play("cin_tomb_giant_robot_walk_village_outtro", self);
				self notify(#"giant_robot_stop");
			}
			else if(n_robot_id == 3)
			{
				level scene::play("cin_tomb_giant_robot_bunker_intro", self);
				self notify(#"giant_robot_stop");
			}
		}
	}
	if(n_robot_id != 3)
	{
		level clientfield::set("start_anim_robot_" + n_robot_id, 0);
	}
}

/*
	Name: sndgrthreads
	Namespace: zm_tomb_giant_robot
	Checksum: 0xCB27E9ED
	Offset: 0x3540
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function sndgrthreads(side)
{
	self thread sndrobot("soundfootstart_" + side, "zmb_robot_leg_move_" + side, side);
	self thread sndrobot("soundfootwarning_" + side, "zmb_robot_foot_alarm", side);
}

/*
	Name: sndrobot
	Namespace: zm_tomb_giant_robot
	Checksum: 0xE7A7F379
	Offset: 0x35B8
	Size: 0x110
	Parameters: 3
	Flags: Linked
*/
function sndrobot(notetrack, alias, side)
{
	self endon(#"giant_robot_stop");
	if(side == "right")
	{
		str_tag = "TAG_ATTACH_HATCH_RI";
	}
	else if(side == "left")
	{
		str_tag = "TAG_ATTACH_HATCH_LE";
	}
	while(true)
	{
		self waittill(notetrack);
		if(notetrack == "soundfootstart_left" || notetrack == "soundfootstart_right")
		{
			self thread function_2124e9c6(1, str_tag, side);
		}
		else if(notetrack == "soundfootwarning_left" || notetrack == "soundfootwarning_right")
		{
			self thread function_2124e9c6(0, str_tag, side);
		}
		wait(0.1);
	}
}

/*
	Name: function_2124e9c6
	Namespace: zm_tomb_giant_robot
	Checksum: 0x3945A973
	Offset: 0x36D0
	Size: 0x13C
	Parameters: 3
	Flags: Linked
*/
function function_2124e9c6(startmove, str_tag, side)
{
	if(startmove)
	{
		self playsoundontag("zmb_robot_leg_move_" + side, str_tag);
		wait(1.1);
		self playsoundontag("zmb_robot_foot_alarm", str_tag);
		wait(0.7);
		self playsoundontag("zmb_robot_pre_stomp_a", str_tag);
		wait(0.6);
		self playsoundontag("zmb_robot_leg_whoosh", str_tag);
	}
	else
	{
		self playsoundontag("zmb_robot_foot_alarm", str_tag);
		wait(0.7);
		self playsoundontag("zmb_robot_pre_stomp_a", str_tag);
		wait(0.6);
		self playsoundontag("zmb_robot_leg_whoosh", str_tag);
	}
}

/*
	Name: monitor_footsteps
	Namespace: zm_tomb_giant_robot
	Checksum: 0x3E5FD460
	Offset: 0x3818
	Size: 0x148
	Parameters: 2
	Flags: Linked
*/
function monitor_footsteps(trig_stomp_kill, foot_side)
{
	self endon(#"death");
	self endon(#"giant_robot_stop");
	str_start_stomp = ("kill_zombies_" + foot_side) + "foot_1";
	str_end_stomp = ("footstep_" + foot_side) + "_large";
	while(true)
	{
		self waittillmatch(str_start_stomp);
		self thread toggle_kill_trigger_flag(trig_stomp_kill, 1, foot_side);
		self waittillmatch(str_end_stomp);
		if(self.giant_robot_id == 0 && foot_side == "left")
		{
			self thread toggle_wind_bunker_collision();
		}
		else if(self.giant_robot_id == 1 && foot_side == "left")
		{
			self thread toggle_tank_bunker_collision();
		}
		wait(0.5);
		self thread toggle_kill_trigger_flag(trig_stomp_kill, 0, foot_side);
	}
}

/*
	Name: monitor_footsteps_fx
	Namespace: zm_tomb_giant_robot
	Checksum: 0x6073E67B
	Offset: 0x3968
	Size: 0x170
	Parameters: 2
	Flags: Linked
*/
function monitor_footsteps_fx(trig_stomp_kill, foot_side)
{
	self endon(#"death");
	self endon(#"giant_robot_stop");
	str_end_stomp = ("footstep_" + foot_side) + "_large";
	while(true)
	{
		level clientfield::set("play_foot_stomp_fx_robot_" + self.giant_robot_id, 0);
		self waittillmatch(str_end_stomp);
		if(foot_side == "right")
		{
			level clientfield::set("play_foot_stomp_fx_robot_" + self.giant_robot_id, 1);
		}
		else
		{
			level clientfield::set("play_foot_stomp_fx_robot_" + self.giant_robot_id, 2);
		}
		trig_stomp_kill thread rumble_and_shake(self);
		if(self.giant_robot_id == 2)
		{
			self thread church_ceiling_fxanim(foot_side);
		}
		else if(self.giant_robot_id == 0)
		{
			self thread play_pap_shake_fxanim(foot_side);
		}
		util::wait_network_frame();
	}
}

/*
	Name: monitor_shadow_notetracks
	Namespace: zm_tomb_giant_robot
	Checksum: 0xAF63C2CC
	Offset: 0x3AE0
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function monitor_shadow_notetracks(foot_side)
{
	self endon(#"death");
	self endon(#"giant_robot_stop");
	while(true)
	{
		self waittillmatch("shadow_" + foot_side);
		start_robot_stomp_warning_vo(foot_side);
	}
}

/*
	Name: rumble_and_shake
	Namespace: zm_tomb_giant_robot
	Checksum: 0xAAC74F11
	Offset: 0x3B40
	Size: 0x232
	Parameters: 1
	Flags: Linked
*/
function rumble_and_shake(robot)
{
	a_players = getplayers();
	wait(0.2);
	foreach(player in a_players)
	{
		if(zombie_utility::is_player_valid(player))
		{
			if(isdefined(player.in_giant_robot_head))
			{
				if(isdefined(player.giant_robot_transition) && player.giant_robot_transition)
				{
					continue;
				}
				if(player.in_giant_robot_head == robot.giant_robot_id)
				{
					player clientfield::set_to_player("giant_robot_rumble_and_shake", 2);
				}
				else
				{
					continue;
				}
			}
			else
			{
				dist = distance(player.origin, self.origin);
				if(dist < 1500)
				{
					player clientfield::set_to_player("giant_robot_rumble_and_shake", 3);
					level notify(#"sam_clue_giant", player);
				}
				else
				{
					if(dist < 3000)
					{
						player clientfield::set_to_player("giant_robot_rumble_and_shake", 2);
					}
					else
					{
						if(dist < 6000)
						{
							player clientfield::set_to_player("giant_robot_rumble_and_shake", 1);
						}
						else
						{
							continue;
						}
					}
				}
			}
			player thread turn_clientside_rumble_off();
		}
	}
}

/*
	Name: toggle_kill_trigger_flag
	Namespace: zm_tomb_giant_robot
	Checksum: 0x7F03D9DD
	Offset: 0x3D80
	Size: 0x114
	Parameters: 3
	Flags: Linked
*/
function toggle_kill_trigger_flag(trig_stomp, b_flag, foot_side = undefined)
{
	if(b_flag)
	{
		self flag::set("kill_trigger_active");
		trig_stomp thread activate_kill_trigger(self, foot_side);
	}
	else
	{
		self flag::clear("kill_trigger_active");
		level notify(#"stop_kill_trig_think");
		if(self flag::get("robot_head_entered"))
		{
			self flag::clear("robot_head_entered");
			self thread giant_robot_close_head_entrance(foot_side);
			level thread giant_robot_head_teleport_timeout(self.giant_robot_id);
		}
	}
}

/*
	Name: activate_kill_trigger
	Namespace: zm_tomb_giant_robot
	Checksum: 0x2B6E121B
	Offset: 0x3EA0
	Size: 0xAEC
	Parameters: 2
	Flags: Linked
*/
function activate_kill_trigger(robot, foot_side)
{
	level endon(#"stop_kill_trig_think");
	if(foot_side == "left")
	{
		str_foot_tag = "TAG_ATTACH_HATCH_LE";
	}
	else if(foot_side == "right")
	{
		str_foot_tag = "TAG_ATTACH_HATCH_RI";
	}
	while(robot flag::get("kill_trigger_active"))
	{
		a_zombies = getaispeciesarray(level.zombie_team, "all");
		a_zombies_to_kill = [];
		foreach(zombie in a_zombies)
		{
			if(distancesquared(zombie.origin, self.origin) < 360000)
			{
				if(isdefined(zombie.is_giant_robot) && zombie.is_giant_robot)
				{
					continue;
				}
				if(isdefined(zombie.marked_for_death) && zombie.marked_for_death)
				{
					continue;
				}
				if(isdefined(zombie.robot_stomped) && zombie.robot_stomped)
				{
					continue;
				}
				if(zombie istouching(self))
				{
					if(isdefined(zombie.is_mechz) && zombie.is_mechz)
					{
						zombie thread zm_tomb_mech::mechz_robot_stomp_callback();
						continue;
					}
					zombie setgoalpos(zombie.origin);
					zombie.marked_for_death = 1;
					a_zombies_to_kill[a_zombies_to_kill.size] = zombie;
					continue;
				}
				if(!(isdefined(zombie.is_mechz) && zombie.is_mechz) && (!(isdefined(zombie.missinglegs) && zombie.missinglegs)) && (isdefined(zombie.completed_emerging_into_playable_area) && zombie.completed_emerging_into_playable_area))
				{
					n_my_z = zombie.origin[2];
					v_giant_robot = robot gettagorigin(str_foot_tag);
					n_giant_robot_z = v_giant_robot[2];
					z_diff = abs(n_my_z - n_giant_robot_z);
					if(z_diff <= 100)
					{
						zombie.v_punched_from = self.origin;
						zombie animcustom(&_zm_weap_one_inch_punch::knockdown_zombie_animate);
					}
				}
			}
		}
		if(a_zombies_to_kill.size > 0)
		{
			level thread zombie_stomp_death(robot, a_zombies_to_kill);
			robot thread zombie_stomped_by_gr_vo(foot_side);
		}
		if(isdefined(level.maxis_quadrotor))
		{
			if(level.maxis_quadrotor istouching(self))
			{
				level.maxis_quadrotor thread quadrotor_stomp_death();
			}
		}
		a_boxes = getentarray("foot_box", "script_noteworthy");
		foreach(m_box in a_boxes)
		{
			if(m_box istouching(self))
			{
				m_box notify(#"robot_foot_stomp");
			}
		}
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(zombie_utility::is_player_valid(players[i], 0, 1))
			{
				if(!players[i] istouching(self))
				{
					continue;
				}
				if(players[i] is_in_giant_robot_footstep_safe_spot())
				{
					continue;
				}
				if(isdefined(players[i].in_giant_robot_head))
				{
					continue;
				}
				if(isdefined(players[i].is_stomped) && players[i].is_stomped)
				{
					continue;
				}
				if(!level.gr_foot_hatch_closed[robot.giant_robot_id] && isdefined(robot.hatch_foot) && (isdefined(robot.b_has_hatch) && robot.b_has_hatch) && issubstr(self.targetname, robot.hatch_foot) && !self laststand::player_is_in_laststand())
				{
					players[i].ignoreme = 1;
					players[i].teleport_initial_origin = self.origin;
					players[i].var_b605c6c3 = 0;
					if(robot.giant_robot_id == 0)
					{
						level thread zm_tomb_teleporter::stargate_teleport_player("head_0_teleport_player", players[i], 2, 0);
						players[i].in_giant_robot_head = 0;
					}
					else
					{
						if(robot.giant_robot_id == 1)
						{
							level thread zm_tomb_teleporter::stargate_teleport_player("head_1_teleport_player", players[i], 2, 0);
							players[i].in_giant_robot_head = 1;
							if(players[i] zm_zonemgr::entity_in_zone("zone_bunker_4d") || players[i] zm_zonemgr::entity_in_zone("zone_bunker_4c"))
							{
								players[i].entered_foot_from_tank_bunker = 1;
							}
						}
						else
						{
							level thread zm_tomb_teleporter::stargate_teleport_player("head_2_teleport_player", players[i], 2, 0);
							players[i].in_giant_robot_head = 2;
						}
					}
					robot flag::set("robot_head_entered");
					players[i] playsoundtoplayer("zmb_bot_elevator_ride_up", players[i]);
					start_wait = 0;
					black_screen_wait = 4;
					fade_in_time = 0.01;
					fade_out_time = 0.2;
					players[i] thread hud::fade_to_black_for_x_sec(start_wait, black_screen_wait, fade_in_time, fade_out_time, "white");
					n_transition_time = ((start_wait + black_screen_wait) + fade_in_time) + fade_out_time;
					n_start_time = start_wait + fade_in_time;
					players[i] thread player_transition_into_robot_head_start(n_start_time);
					players[i] thread player_transition_into_robot_head_finish(n_transition_time);
					players[i] thread player_death_watch_on_giant_robot();
					continue;
					continue;
				}
				if(isdefined(players[i].dig_vars["has_helmet"]) && players[i].dig_vars["has_helmet"])
				{
					players[i] thread player_stomp_fake_death(robot);
				}
				else
				{
					players[i] thread player_stomp_death(robot);
				}
				start_wait = 0;
				black_screen_wait = 5;
				fade_in_time = 0.01;
				fade_out_time = 0.2;
				players[i] thread hud::fade_to_black_for_x_sec(start_wait, black_screen_wait, fade_in_time, fade_out_time, "black");
			}
		}
		wait(0.05);
	}
}

/*
	Name: is_in_giant_robot_footstep_safe_spot
	Namespace: zm_tomb_giant_robot
	Checksum: 0x89480CAB
	Offset: 0x4998
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function is_in_giant_robot_footstep_safe_spot()
{
	b_is_in_safe_spot = 0;
	if(isdefined(level.giant_robot_footstep_safe_spots))
	{
		foreach(e_volume in level.giant_robot_footstep_safe_spots)
		{
			if(self istouching(e_volume))
			{
				b_is_in_safe_spot = 1;
				break;
			}
		}
	}
	return b_is_in_safe_spot;
}

/*
	Name: player_stomp_death
	Namespace: zm_tomb_giant_robot
	Checksum: 0xEB9CF74
	Offset: 0x4A60
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function player_stomp_death(robot)
{
	self endon(#"death");
	self endon(#"disconnect");
	self.is_stomped = 1;
	self playsound("zmb_zombie_arc");
	self freezecontrols(1);
	if(self laststand::player_is_in_laststand())
	{
		self shellshock("explosion", 7);
	}
	else
	{
		self dodamage(self.health, self.origin, robot);
	}
	wait(5);
	self.is_stomped = 0;
	if(!(isdefined(self.hostmigrationcontrolsfrozen) && self.hostmigrationcontrolsfrozen))
	{
		self freezecontrols(0);
	}
	self thread play_robot_crush_player_vo();
}

/*
	Name: player_stomp_fake_death
	Namespace: zm_tomb_giant_robot
	Checksum: 0x599F6C07
	Offset: 0x4B90
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function player_stomp_fake_death(robot)
{
	self endon(#"death");
	self endon(#"disconnect");
	self.is_stomped = 1;
	self notify(#"hash_e2be4752");
	self playsound("zmb_zombie_arc");
	self freezecontrols(1);
	self zm_utility::increment_ignoreme();
	self setstance("prone");
	self shellshock("explosion", 7);
	wait(5);
	self.is_stomped = 0;
	if(!(isdefined(self.hostmigrationcontrolsfrozen) && self.hostmigrationcontrolsfrozen))
	{
		self freezecontrols(0);
	}
	if(!(isdefined(self.ee_stepped_on) && self.ee_stepped_on))
	{
		self zm_audio::create_and_play_dialog("general", "robot_crush_golden");
		self.ee_stepped_on = 1;
	}
	self zm_utility::decrement_ignoreme();
}

/*
	Name: zombie_stomp_death
	Namespace: zm_tomb_giant_robot
	Checksum: 0x8A3C586E
	Offset: 0x4D00
	Size: 0x27E
	Parameters: 2
	Flags: Linked
*/
function zombie_stomp_death(robot, a_zombies_to_kill)
{
	n_interval = 0;
	for(i = 0; i < a_zombies_to_kill.size; i++)
	{
		zombie = a_zombies_to_kill[i];
		if(!isdefined(zombie) || !isalive(zombie))
		{
			continue;
		}
		if(!(isdefined(zombie.exclude_cleanup_adding_to_total) && zombie.exclude_cleanup_adding_to_total))
		{
			level.zombie_total++;
			level.zombie_respawns++;
			if(zombie.health < zombie.maxhealth)
			{
				if(!isdefined(level.a_zombie_respawn_health[zombie.archetype]))
				{
					level.a_zombie_respawn_health[zombie.archetype] = [];
				}
				if(!isdefined(level.a_zombie_respawn_health[zombie.archetype]))
				{
					level.a_zombie_respawn_health[zombie.archetype] = [];
				}
				else if(!isarray(level.a_zombie_respawn_health[zombie.archetype]))
				{
					level.a_zombie_respawn_health[zombie.archetype] = array(level.a_zombie_respawn_health[zombie.archetype]);
				}
				level.a_zombie_respawn_health[zombie.archetype][level.a_zombie_respawn_health[zombie.archetype].size] = zombie.health;
			}
		}
		zombie zombie_utility::reset_attack_spot();
		zombie dodamage(zombie.health, zombie.origin, robot);
		n_interval++;
		if(n_interval >= 4)
		{
			util::wait_network_frame();
			n_interval = 0;
		}
	}
}

/*
	Name: quadrotor_stomp_death
	Namespace: zm_tomb_giant_robot
	Checksum: 0xFBB8D933
	Offset: 0x4F88
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function quadrotor_stomp_death()
{
	self endon(#"death");
	self delete();
}

/*
	Name: toggle_wind_bunker_collision
	Namespace: zm_tomb_giant_robot
	Checksum: 0x9C1CA3CD
	Offset: 0x4FB8
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function toggle_wind_bunker_collision()
{
	s_org = struct::get("wind_tunnel_bunker", "script_noteworthy");
	v_foot = self gettagorigin("TAG_ATTACH_HATCH_LE");
	if(distance2dsquared(s_org.origin, v_foot) < 57600)
	{
		level notify(#"wind_bunker_collision_on");
		wait(5);
		level notify(#"wind_bunker_collision_off");
	}
}

/*
	Name: toggle_tank_bunker_collision
	Namespace: zm_tomb_giant_robot
	Checksum: 0x616FD7FE
	Offset: 0x5070
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function toggle_tank_bunker_collision()
{
	s_org = struct::get("tank_bunker", "script_noteworthy");
	v_foot = self gettagorigin("TAG_ATTACH_HATCH_LE");
	if(distance2dsquared(s_org.origin, v_foot) < 57600)
	{
		level notify(#"tank_bunker_collision_on");
		wait(5);
		level notify(#"tank_bunker_collision_off");
	}
}

/*
	Name: handle_wind_tunnel_bunker_collision
	Namespace: zm_tomb_giant_robot
	Checksum: 0x1FE04774
	Offset: 0x5128
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function handle_wind_tunnel_bunker_collision()
{
	e_collision = getent("clip_foot_bottom_wind", "targetname");
	e_collision notsolid();
	e_collision connectpaths();
	while(true)
	{
		level waittill(#"wind_bunker_collision_on");
		wait(0.1);
		e_collision solid();
		e_collision disconnectpaths();
		level waittill(#"wind_bunker_collision_off");
		e_collision notsolid();
		e_collision connectpaths();
	}
}

/*
	Name: handle_tank_bunker_collision
	Namespace: zm_tomb_giant_robot
	Checksum: 0x66D31BF3
	Offset: 0x5210
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function handle_tank_bunker_collision()
{
	e_collision = getent("clip_foot_bottom_tank", "targetname");
	e_collision notsolid();
	e_collision connectpaths();
	while(true)
	{
		level waittill(#"tank_bunker_collision_on");
		wait(0.1);
		e_collision solid();
		e_collision disconnectpaths();
		level waittill(#"tank_bunker_collision_off");
		e_collision notsolid();
		e_collision connectpaths();
	}
}

/*
	Name: church_ceiling_fxanim
	Namespace: zm_tomb_giant_robot
	Checksum: 0x1CD67F34
	Offset: 0x52F8
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function church_ceiling_fxanim(foot_side)
{
	if(foot_side == "left")
	{
		tag_foot = self gettagorigin("TAG_ATTACH_HATCH_LE");
	}
	else
	{
		tag_foot = self gettagorigin("TAG_ATTACH_HATCH_RI");
	}
	s_church = struct::get("giant_robot_church_marker", "targetname");
	n_distance = distance2dsquared(tag_foot, s_church.origin);
	if(n_distance < 1000000)
	{
		level clientfield::set("church_ceiling_fxanim", 1);
		util::wait_network_frame();
		level clientfield::set("church_ceiling_fxanim", 0);
	}
}

/*
	Name: play_pap_shake_fxanim
	Namespace: zm_tomb_giant_robot
	Checksum: 0x7CE42C72
	Offset: 0x5438
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function play_pap_shake_fxanim(foot_side)
{
	if(foot_side == "left")
	{
		tag_foot = self gettagorigin("TAG_ATTACH_HATCH_LE");
	}
	else
	{
		tag_foot = self gettagorigin("TAG_ATTACH_HATCH_RI");
	}
	s_pap = struct::get("giant_robot_pap_marker", "targetname");
	wait(0.2);
	n_distance = distance2dsquared(tag_foot, s_pap.origin);
	if(n_distance < 2250000)
	{
		level clientfield::increment("pap_monolith_ring_shake");
	}
}

/*
	Name: player_transition_into_robot_head_start
	Namespace: zm_tomb_giant_robot
	Checksum: 0x3B157B64
	Offset: 0x5548
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function player_transition_into_robot_head_start(n_start_time)
{
	self endon(#"death");
	self endon(#"disconnect");
	self.giant_robot_transition = 1;
	self.dontspeak = 1;
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 3);
	wait(1.5);
	self clientfield::set_to_player("player_rumble_and_shake", 4);
}

/*
	Name: player_transition_into_robot_head_finish
	Namespace: zm_tomb_giant_robot
	Checksum: 0xB2B8ED62
	Offset: 0x55D8
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function player_transition_into_robot_head_finish(n_transition_time)
{
	self endon(#"death");
	self endon(#"disconnect");
	wait(n_transition_time);
	self clientfield::set_to_player("player_rumble_and_shake", 0);
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
	self.giant_robot_transition = 0;
	wait(2);
	if(!level flag::get("story_vo_playing"))
	{
		self.dontspeak = 0;
		self zm_audio::create_and_play_dialog("general", "enter_robot");
	}
	if(!isdefined(level.sndrobotheadcount) || level.sndrobotheadcount == 0)
	{
		level.sndrobotheadcount = 4;
		level thread zm_tomb_amb::sndplaystinger("zone_robot_head");
	}
	else
	{
		level.sndrobotheadcount--;
	}
}

/*
	Name: gr_head_exit_trigger_start
	Namespace: zm_tomb_giant_robot
	Checksum: 0x9C7EB815
	Offset: 0x56F8
	Size: 0x1C4
	Parameters: 1
	Flags: Linked
*/
function gr_head_exit_trigger_start(s_origin)
{
	s_origin.unitrigger_stub = spawnstruct();
	s_origin.unitrigger_stub.origin = s_origin.origin;
	s_origin.unitrigger_stub.radius = 36;
	s_origin.unitrigger_stub.height = 256;
	s_origin.unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	s_origin.unitrigger_stub.hint_string = &"ZM_TOMB_EHT";
	s_origin.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_origin.unitrigger_stub.require_look_at = 1;
	s_origin.unitrigger_stub.target = s_origin.target;
	s_origin.unitrigger_stub.script_int = s_origin.script_int;
	s_origin.unitrigger_stub.is_available = 1;
	s_origin.unitrigger_stub.prompt_and_visibility_func = &gr_head_eject_trigger_visibility;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_origin.unitrigger_stub, 1);
	zm_unitrigger::register_static_unitrigger(s_origin.unitrigger_stub, &player_exits_giant_robot_head_trigger_think);
}

/*
	Name: gr_head_eject_trigger_visibility
	Namespace: zm_tomb_giant_robot
	Checksum: 0x8B337E3C
	Offset: 0x58C8
	Size: 0x8A
	Parameters: 1
	Flags: Linked
*/
function gr_head_eject_trigger_visibility(player)
{
	b_is_invis = !(isdefined(self.stub.is_available) && self.stub.is_available);
	self setinvisibletoplayer(player, b_is_invis);
	self sethintstring(self.stub.hint_string);
	return !b_is_invis;
}

/*
	Name: reset_gr_head_unitriggers
	Namespace: zm_tomb_giant_robot
	Checksum: 0xF87C40D4
	Offset: 0x5960
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function reset_gr_head_unitriggers()
{
	zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &player_exits_giant_robot_head_trigger_think);
}

/*
	Name: player_exits_giant_robot_head_trigger_think
	Namespace: zm_tomb_giant_robot
	Checksum: 0xE2B47D6A
	Offset: 0x59B0
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function player_exits_giant_robot_head_trigger_think()
{
	self endon(#"tube_used_for_timeout");
	while(true)
	{
		self waittill(#"trigger", player);
		if(!(isdefined(self.stub.is_available) && self.stub.is_available))
		{
			continue;
		}
		if(!isplayer(player) || !zombie_utility::is_player_valid(player))
		{
			continue;
		}
		level thread init_player_eject_logic(self.stub, player);
		self.stub.is_available = 0;
	}
}

/*
	Name: init_player_eject_logic
	Namespace: zm_tomb_giant_robot
	Checksum: 0x2D20D0E7
	Offset: 0x5A88
	Size: 0x258
	Parameters: 3
	Flags: Linked
*/
function init_player_eject_logic(s_unitrigger, player, b_timeout = 0)
{
	s_unitrigger.is_available = 0;
	s_origin = struct::get(s_unitrigger.target, "targetname");
	v_origin = s_origin.origin;
	v_angles = s_origin.angles;
	m_linkpoint = spawn_model("tag_origin", v_origin, v_angles);
	if(isdefined(level.giant_robot_head_player_eject_thread_custom_func))
	{
		player thread [[level.giant_robot_head_player_eject_thread_custom_func]](m_linkpoint, s_origin.script_noteworthy, b_timeout);
	}
	else
	{
		player thread giant_robot_head_player_eject_thread(m_linkpoint, s_origin.script_noteworthy, b_timeout);
	}
	tube_clone = player zm_clone::spawn_player_clone(player, player.origin, undefined);
	player thread giant_robot_eject_disconnect_watcher(m_linkpoint, tube_clone);
	tube_clone linkto(m_linkpoint);
	tube_clone.ignoreme = 1;
	tube_clone show();
	tube_clone detachall();
	tube_clone setvisibletoall();
	tube_clone setinvisibletoplayer(player);
	tube_clone thread tube_clone_falls_to_earth(m_linkpoint);
	m_linkpoint waittill(#"movedone");
	wait(6);
	s_unitrigger.is_available = 1;
}

/*
	Name: giant_robot_head_player_eject_thread
	Namespace: zm_tomb_giant_robot
	Checksum: 0xD3DFF206
	Offset: 0x5CE8
	Size: 0x7E4
	Parameters: 3
	Flags: Linked
*/
function giant_robot_head_player_eject_thread(m_linkpoint, str_tube, b_timeout = 0)
{
	level endon(#"intermission");
	self endon(#"death_or_disconnect");
	w_current_weapon = self getcurrentweapon();
	self disableweapons();
	self disableoffhandweapons();
	self enableinvulnerability();
	self setstance("stand");
	self allowstand(1);
	self allowcrouch(0);
	self allowprone(0);
	self playerlinktodelta(m_linkpoint, "tag_origin", 1, 20, 20, 20, 20);
	self setplayerangles(m_linkpoint.angles);
	self.dontspeak = 1;
	self clientfield::set_to_player("isspeaking", 1);
	self notify(#"teleport");
	self.giant_robot_transition = 1;
	self playsoundtoplayer("zmb_bot_timeout_alarm", self);
	self.old_angles = self.angles;
	if(!b_timeout)
	{
		self clientfield::set("eject_steam_fx", 1);
		self thread in_tube_manual_looping_rumble();
		wait(3);
	}
	self stopsounds();
	util::wait_network_frame();
	self playsoundtoplayer("zmb_giantrobot_exit", self);
	self notify(#"end_in_tube_rumble");
	self thread exit_gr_manual_looping_rumble();
	m_linkpoint moveto(m_linkpoint.origin + vectorscale((0, 0, 1), 2000), 2.5);
	self thread hud::fade_to_black_for_x_sec(0, 2, 0.5, 0, "white");
	wait(1);
	m_linkpoint moveto(self.teleport_initial_origin + vectorscale((0, 0, 1), 3000), 0.05);
	self thread scene::play("cin_zm_gen_player_fall_loop", self);
	self setinvisibletoall();
	self setvisibletoplayer(self);
	wait(1);
	self playsoundtoplayer("zmb_giantrobot_fall", self);
	self playerlinktodelta(m_linkpoint, "tag_origin", 1, 180, 180, 20, 20);
	m_linkpoint moveto(self.teleport_initial_origin, 3, 1);
	m_linkpoint thread play_gr_eject_impact_player_fx(self);
	m_linkpoint notify(#"start_gr_eject_fall_to_earth");
	self thread player_screams_while_falling();
	wait(2.85);
	self thread hud::fade_to_black_for_x_sec(0, 1, 0, 0.5, "black");
	self waittill(#"gr_eject_fall_complete");
	self setvisibletoall();
	self enableweapons();
	if(isdefined(w_current_weapon) && w_current_weapon != level.weaponnone)
	{
		self switchtoweaponimmediate(w_current_weapon);
	}
	self enableoffhandweapons();
	self unlink();
	m_linkpoint delete();
	self teleport_player_to_gr_footprint_safe_spot();
	level scene::stop("cin_zm_gen_player_fall_loop");
	self show();
	self setplayerangles(self.old_angles);
	self disableinvulnerability();
	self.dontspeak = 0;
	self allowstand(1);
	self allowcrouch(1);
	self allowprone(1);
	self clientfield::set_to_player("isspeaking", 0);
	self.in_giant_robot_head = undefined;
	self.teleport_initial_origin = undefined;
	self.old_angles = undefined;
	self.var_b605c6c3 = 1;
	self thread gr_eject_landing_rumble();
	self thread gr_eject_landing_rumble_on_position();
	self clientfield::set("eject_steam_fx", 0);
	n_post_eject_time = 2.5;
	self setstance("prone");
	self shellshock("explosion", n_post_eject_time);
	self.giant_robot_transition = 0;
	self notify(#"gr_eject_sequence_complete");
	if(!level flag::get("story_vo_playing"))
	{
		self util::delay(3, undefined, &zm_audio::create_and_play_dialog, "general", "air_chute_landing");
	}
	/#
		debug_level = getdvarint("");
		if(isdefined(debug_level) && debug_level)
		{
			self enableinvulnerability();
		}
	#/
	wait(n_post_eject_time);
	self.ignoreme = 0;
}

/*
	Name: player_screams_while_falling
	Namespace: zm_tomb_giant_robot
	Checksum: 0x6C140823
	Offset: 0x64D8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function player_screams_while_falling()
{
	self endon(#"disconnect");
	self stopsounds();
	util::wait_network_frame();
	self playsoundtoplayer(("vox_plr_" + self.characterindex) + "_exit_robot_0", self);
}

/*
	Name: tube_clone_falls_to_earth
	Namespace: zm_tomb_giant_robot
	Checksum: 0x3F59D8E1
	Offset: 0x6548
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function tube_clone_falls_to_earth(m_linkpoint)
{
	m_linkpoint waittill(#"start_gr_eject_fall_to_earth");
	self thread scene::play("cin_zm_dlc1_jump_pad_air_loop", self);
	m_linkpoint waittill(#"movedone");
	self thread scene::stop("cin_zm_dlc1_jump_pad_air_loop");
	self delete();
}

/*
	Name: in_tube_manual_looping_rumble
	Namespace: zm_tomb_giant_robot
	Checksum: 0x11D1D2B8
	Offset: 0x65D0
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function in_tube_manual_looping_rumble()
{
	self endon(#"end_in_tube_rumble");
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		self clientfield::set_to_player("giant_robot_rumble_and_shake", 1);
		util::wait_network_frame();
		self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
		util::wait_network_frame();
		wait(0.1);
	}
}

/*
	Name: exit_gr_manual_looping_rumble
	Namespace: zm_tomb_giant_robot
	Checksum: 0x3A96EBED
	Offset: 0x6670
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function exit_gr_manual_looping_rumble()
{
	self endon(#"end_exit_gr_rumble");
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		self clientfield::set_to_player("giant_robot_rumble_and_shake", 1);
		util::wait_network_frame();
		self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
		util::wait_network_frame();
		wait(0.1);
	}
}

/*
	Name: gr_eject_landing_rumble
	Namespace: zm_tomb_giant_robot
	Checksum: 0x8863C821
	Offset: 0x6710
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function gr_eject_landing_rumble()
{
	self endon(#"death");
	self endon(#"disconnect");
	self notify(#"end_exit_gr_rumble");
	util::wait_network_frame();
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
	util::wait_network_frame();
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 3);
	util::wait_network_frame();
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
}

/*
	Name: gr_eject_landing_rumble_on_position
	Namespace: zm_tomb_giant_robot
	Checksum: 0x35492541
	Offset: 0x67D8
	Size: 0x122
	Parameters: 0
	Flags: Linked
*/
function gr_eject_landing_rumble_on_position()
{
	self endon(#"death");
	self endon(#"disconnect");
	a_players = getplayers();
	foreach(player in a_players)
	{
		if(player == self)
		{
			continue;
		}
		if(isdefined(player.giant_robot_transition) && player.giant_robot_transition)
		{
			continue;
		}
		if(distance2dsquared(player.origin, self.origin) < 250000)
		{
			player thread gr_eject_landing_rumble();
		}
	}
}

/*
	Name: teleport_player_to_gr_footprint_safe_spot
	Namespace: zm_tomb_giant_robot
	Checksum: 0x4CADB5BF
	Offset: 0x6908
	Size: 0x32A
	Parameters: 0
	Flags: Linked
*/
function teleport_player_to_gr_footprint_safe_spot()
{
	self endon(#"death");
	self endon(#"disconnect");
	if(isdefined(self.entered_foot_from_tank_bunker) && self.entered_foot_from_tank_bunker)
	{
		a_s_orgs = struct::get_array("tank_platform_safe_spots", "targetname");
		foreach(struct in a_s_orgs)
		{
			if(!positionwouldtelefrag(struct.origin))
			{
				self setorigin(struct.origin);
				break;
			}
		}
		self.entered_foot_from_tank_bunker = 0;
		return;
	}
	a_s_footprints = struct::get_array("giant_robot_footprint", "targetname");
	a_s_footprints = util::get_array_of_closest(self.teleport_initial_origin, a_s_footprints);
	s_footprint = a_s_footprints[0];
	a_v_offset = [];
	a_v_offset[0] = (0, 0, 0);
	a_v_offset[1] = vectorscale((1, 1, 0), 50);
	a_v_offset[2] = vectorscale((1, 0, 0), 50);
	a_v_offset[3] = vectorscale((1, -1, 0), 50);
	a_v_offset[4] = vectorscale((0, -1, 0), 50);
	a_v_offset[5] = vectorscale((-1, -1, 0), 50);
	a_v_offset[6] = vectorscale((-1, 0, 0), 50);
	a_v_offset[7] = vectorscale((-1, 1, 0), 50);
	a_v_offset[8] = vectorscale((0, 1, 0), 50);
	for(i = 0; i < a_v_offset.size; i++)
	{
		v_origin = s_footprint.origin + a_v_offset[i];
		v_trace_start = v_origin + vectorscale((0, 0, 1), 100);
		v_final = playerphysicstrace(v_trace_start, v_origin);
		if(!positionwouldtelefrag(v_final))
		{
			self setorigin(v_final);
			break;
		}
	}
}

/*
	Name: giant_robot_head_teleport_timeout
	Namespace: zm_tomb_giant_robot
	Checksum: 0xA390CE8E
	Offset: 0x6C40
	Size: 0x6CE
	Parameters: 1
	Flags: Linked
*/
function giant_robot_head_teleport_timeout(n_robot_id)
{
	level endon(#"intermission");
	wait(15);
	n_players_in_robot = count_players_in_gr_head(n_robot_id);
	if(n_players_in_robot == 0)
	{
		return;
	}
	while(level flag::get(("maxis_audiolog_gr" + n_robot_id) + "_playing"))
	{
		wait(0.1);
	}
	n_players_in_robot = count_players_in_gr_head(n_robot_id);
	if(n_players_in_robot == 0)
	{
		return;
	}
	level thread play_timeout_warning_vo(n_robot_id);
	zm_tomb_vo::reset_maxis_audiolog_unitrigger(n_robot_id);
	level clientfield::set("eject_warning_fx_robot_" + n_robot_id, 1);
	a_players = getplayers();
	a_players[0] clientfield::set("all_tubes_play_eject_steam_fx", 1);
	level waittill("timeout_warning_vo_complete_" + n_robot_id);
	a_gr_head_triggers = struct::get_array("giant_robot_head_exit_trigger", "script_noteworthy");
	a_shutdown_triggers = [];
	foreach(trigger in a_gr_head_triggers)
	{
		if(trigger.script_int == n_robot_id)
		{
			if(isdefined(trigger.unitrigger_stub.is_available) && trigger.unitrigger_stub.is_available)
			{
				zm_unitrigger::unregister_unitrigger(trigger.unitrigger_stub);
				a_shutdown_triggers[a_shutdown_triggers.size] = trigger;
			}
		}
	}
	a_players = getplayers();
	a_m_linkspots = [];
	foreach(player in a_players)
	{
		if(isdefined(player.in_giant_robot_head) && player.in_giant_robot_head == n_robot_id)
		{
			if(!(isdefined(player.giant_robot_transition) && player.giant_robot_transition))
			{
				if(player laststand::player_is_in_laststand())
				{
					if(isdefined(player.waiting_to_revive) && player.waiting_to_revive && a_players.size <= 1)
					{
						level flag::set("instant_revive");
						player.stopflashingbadlytime = gettime() + 1000;
						util::wait_network_frame();
						level flag::clear("instant_revive");
					}
					else
					{
						if(player bgb::is_enabled("zm_bgb_self_medication"))
						{
							player bgb::take();
							player.var_df0decf1 = undefined;
							player.var_25b88da = 0;
							player thread zm_laststand::bleed_out();
							player notify(#"gr_head_forced_bleed_out");
							continue;
						}
						else
						{
							player thread zm_laststand::bleed_out();
							player notify(#"gr_head_forced_bleed_out");
							continue;
						}
					}
				}
				if(isalive(player))
				{
					m_linkspot = spawn_model("tag_origin", player.origin, player.angles);
					a_m_linkspots[a_m_linkspots.size] = m_linkspot;
					player start_drag_player_to_eject_tube(n_robot_id, m_linkspot);
					wait(0.1);
				}
			}
		}
	}
	wait(10);
	zm_tomb_vo::restart_maxis_audiolog_unitrigger(n_robot_id);
	level clientfield::set("eject_warning_fx_robot_" + n_robot_id, 0);
	a_players = getplayers();
	a_players[0] clientfield::set("all_tubes_play_eject_steam_fx", 0);
	foreach(trigger in a_shutdown_triggers)
	{
		if(trigger.script_int == n_robot_id)
		{
			trigger thread reset_gr_head_unitriggers();
		}
	}
	if(a_m_linkspots.size > 0)
	{
		for(i = 0; i < a_m_linkspots.size; i++)
		{
			if(isdefined(a_m_linkspots[i]))
			{
				a_m_linkspots[i] delete();
			}
		}
	}
}

/*
	Name: start_drag_player_to_eject_tube
	Namespace: zm_tomb_giant_robot
	Checksum: 0x70EC89B3
	Offset: 0x7318
	Size: 0x1F6
	Parameters: 2
	Flags: Linked
*/
function start_drag_player_to_eject_tube(n_robot_id, m_linkspot)
{
	self endon(#"death");
	self endon(#"disconnect");
	a_gr_head_triggers = struct::get_array("giant_robot_head_exit_trigger", "script_noteworthy");
	a_gr_head_triggers = util::get_array_of_closest(self.origin, a_gr_head_triggers);
	foreach(trigger in a_gr_head_triggers)
	{
		if(trigger.unitrigger_stub.script_int == n_robot_id)
		{
			if(isdefined(trigger.unitrigger_stub.is_available) && trigger.unitrigger_stub.is_available)
			{
				self thread in_tube_manual_looping_rumble();
				trigger.unitrigger_stub.is_available = 0;
				s_tube = struct::get(trigger.target, "targetname");
				self playerlinktodelta(m_linkspot, "tag_origin", 1, 20, 20, 20, 20);
				self thread move_player_to_eject_tube(m_linkspot, s_tube, trigger);
				break;
			}
		}
	}
}

/*
	Name: move_player_to_eject_tube
	Namespace: zm_tomb_giant_robot
	Checksum: 0x550A1341
	Offset: 0x7518
	Size: 0x114
	Parameters: 3
	Flags: Linked
*/
function move_player_to_eject_tube(m_linkspot, s_tube, trigger)
{
	self endon(#"death");
	self endon(#"disconnect");
	self.giant_robot_transition = 1;
	n_speed = 500;
	n_dist = distance(m_linkspot.origin, s_tube.origin);
	n_time = n_dist / n_speed;
	m_linkspot moveto(s_tube.origin, n_time);
	m_linkspot waittill(#"movedone");
	m_linkspot delete();
	level thread init_player_eject_logic(trigger.unitrigger_stub, self, 1);
}

/*
	Name: sndalarmtimeout
	Namespace: zm_tomb_giant_robot
	Checksum: 0xEE00B64B
	Offset: 0x7638
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function sndalarmtimeout()
{
	self endon(#"teleport");
	self endon(#"disconnect");
	self playsoundtoplayer("zmb_bot_timeout_alarm", self);
	wait(2.5);
	self playsoundtoplayer("zmb_bot_timeout_alarm", self);
}

/*
	Name: play_gr_eject_impact_player_fx
	Namespace: zm_tomb_giant_robot
	Checksum: 0x4D8BB1DC
	Offset: 0x76A8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function play_gr_eject_impact_player_fx(player)
{
	player endon(#"death");
	player endon(#"disconnect");
	self waittill(#"movedone");
	player clientfield::set("gr_eject_player_impact_fx", 1);
	util::wait_network_frame();
	player notify(#"gr_eject_fall_complete");
	wait(1);
	player clientfield::set("gr_eject_player_impact_fx", 0);
}

/*
	Name: player_death_watch_on_giant_robot
	Namespace: zm_tomb_giant_robot
	Checksum: 0x3FA747E8
	Offset: 0x7750
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function player_death_watch_on_giant_robot()
{
	self endon(#"disconnect");
	self endon(#"gr_eject_sequence_complete");
	self util::waittill_either("bled_out", "gr_head_forced_bleed_out");
	self.entered_foot_from_tank_bunker = undefined;
	self.giant_robot_transition = undefined;
	self.in_giant_robot_head = undefined;
	self.ignoreme = 0;
	self.dontspeak = 0;
}

/*
	Name: giant_robot_eject_disconnect_watcher
	Namespace: zm_tomb_giant_robot
	Checksum: 0x947F57E0
	Offset: 0x77C8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function giant_robot_eject_disconnect_watcher(m_linkpoint, tube_clone)
{
	self endon(#"gr_eject_sequence_complete");
	self waittill(#"disconnect");
	if(isdefined(m_linkpoint))
	{
		m_linkpoint delete();
	}
	if(isdefined(tube_clone))
	{
		tube_clone delete();
	}
}

/*
	Name: turn_clientside_rumble_off
	Namespace: zm_tomb_giant_robot
	Checksum: 0xA5B7B308
	Offset: 0x7840
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function turn_clientside_rumble_off()
{
	self endon(#"death");
	self endon(#"disconnect");
	util::wait_network_frame();
	self clientfield::set_to_player("giant_robot_rumble_and_shake", 0);
}

/*
	Name: spawn_model
	Namespace: zm_tomb_giant_robot
	Checksum: 0xAC7C54A
	Offset: 0x7898
	Size: 0xB4
	Parameters: 4
	Flags: Linked
*/
function spawn_model(model_name, origin = (0, 0, 0), angles, n_spawnflags = 0)
{
	model = spawn("script_model", origin, n_spawnflags);
	model setmodel(model_name);
	if(isdefined(angles))
	{
		model.angles = angles;
	}
	return model;
}

/*
	Name: count_players_in_gr_head
	Namespace: zm_tomb_giant_robot
	Checksum: 0x37231B3
	Offset: 0x7958
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function count_players_in_gr_head(n_robot_id)
{
	n_players_in_robot = 0;
	a_players = getplayers();
	foreach(player in a_players)
	{
		if(isdefined(player.in_giant_robot_head) && player.in_giant_robot_head == n_robot_id)
		{
			n_players_in_robot++;
		}
	}
	return n_players_in_robot;
}

/*
	Name: setup_giant_robots_intermission
	Namespace: zm_tomb_giant_robot
	Checksum: 0x27D6844E
	Offset: 0x7A40
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function setup_giant_robots_intermission()
{
	level waittill(#"intermission");
	for(i = 0; i < 3; i++)
	{
		ai_giant_robot = getent("giant_robot_" + i, "targetname");
		if(!isdefined(ai_giant_robot))
		{
			continue;
		}
		ai_giant_robot ghost();
		ai_giant_robot stopanimscripted(0.05);
		ai_giant_robot notify(#"giant_robot_stop");
		if(i == 2)
		{
			util::wait_network_frame();
			ai_giant_robot show();
			level thread scene::play("cin_tomb_giant_robot_walk_village", ai_giant_robot);
		}
	}
}

/*
	Name: giant_robot_discovered_vo
	Namespace: zm_tomb_giant_robot
	Checksum: 0xF151AA57
	Offset: 0x7B60
	Size: 0x110
	Parameters: 1
	Flags: Linked
*/
function giant_robot_discovered_vo(ai_giant_robot)
{
	ai_giant_robot endon(#"giant_robot_stop");
	self endon(#"disconnect");
	level endon(#"giant_robot_discovered");
	while(true)
	{
		if(distance2dsquared(self.origin, ai_giant_robot.origin) < 16000000)
		{
			if(self zm_utility::is_player_looking_at(ai_giant_robot.origin + vectorscale((0, 0, 1), 2000), 0.85))
			{
				if(!(isdefined(self.dontspeak) && self.dontspeak))
				{
					self zm_audio::create_and_play_dialog("general", "discover_robot");
					level.giant_robot_discovered = 1;
					level notify(#"giant_robot_discovered");
					break;
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: three_robot_round_vo
	Namespace: zm_tomb_giant_robot
	Checksum: 0xB836A1F4
	Offset: 0x7C78
	Size: 0x110
	Parameters: 1
	Flags: Linked
*/
function three_robot_round_vo(ai_giant_robot)
{
	ai_giant_robot endon(#"giant_robot_stop");
	self endon(#"disconnect");
	level endon(#"three_robot_round_vo");
	while(true)
	{
		if(distance2dsquared(self.origin, ai_giant_robot.origin) < 16000000)
		{
			if(self zm_utility::is_player_looking_at(ai_giant_robot.origin + vectorscale((0, 0, 1), 2000), 0.85))
			{
				if(!(isdefined(self.dontspeak) && self.dontspeak))
				{
					self zm_audio::create_and_play_dialog("general", "see_robots");
					level.three_robot_round_vo = 1;
					level notify(#"three_robot_round_vo");
					break;
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: shoot_at_giant_robot_vo
	Namespace: zm_tomb_giant_robot
	Checksum: 0x389F7C16
	Offset: 0x7D90
	Size: 0x190
	Parameters: 1
	Flags: Linked
*/
function shoot_at_giant_robot_vo(ai_giant_robot)
{
	ai_giant_robot endon(#"giant_robot_stop");
	self endon(#"disconnect");
	level endon(#"shoot_robot_vo");
	while(true)
	{
		while(distance2dsquared(self.origin, ai_giant_robot.origin) < 16000000 && self zm_utility::is_player_looking_at(ai_giant_robot.origin + vectorscale((0, 0, 1), 2000), 0.7))
		{
			self waittill(#"weapon_fired");
			if(distance2dsquared(self.origin, ai_giant_robot.origin) < 16000000 && self zm_utility::is_player_looking_at(ai_giant_robot.origin + vectorscale((0, 0, 1), 2000), 0.7))
			{
				if(!(isdefined(self.dontspeak) && self.dontspeak))
				{
					self zm_audio::create_and_play_dialog("general", "shoot_robot");
					level.shoot_robot_vo = 1;
					level notify(#"shoot_robot_vo");
					return;
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: start_robot_stomp_warning_vo
	Namespace: zm_tomb_giant_robot
	Checksum: 0xA2C9D39E
	Offset: 0x7F28
	Size: 0x2C2
	Parameters: 1
	Flags: Linked
*/
function start_robot_stomp_warning_vo(foot_side)
{
	if(foot_side == "right")
	{
		str_tag = "TAG_ATTACH_HATCH_RI";
	}
	else if(foot_side == "left")
	{
		str_tag = "TAG_ATTACH_HATCH_LE";
	}
	v_origin = self gettagorigin(str_tag);
	a_s_footprint_all = struct::get_array("giant_robot_footprint_center", "targetname");
	a_s_footprint = [];
	foreach(footprint in a_s_footprint_all)
	{
		if(footprint.script_int == self.giant_robot_id)
		{
			if(!isdefined(a_s_footprint))
			{
				a_s_footprint = [];
			}
			else if(!isarray(a_s_footprint))
			{
				a_s_footprint = array(a_s_footprint);
			}
			a_s_footprint[a_s_footprint.size] = footprint;
		}
	}
	if(a_s_footprint.size == 0)
	{
		return;
	}
	a_s_footprint = util::get_array_of_closest(v_origin, a_s_footprint);
	s_footprint = a_s_footprint[0];
	a_players = getplayers();
	foreach(player in a_players)
	{
		if(distance2dsquared(player.origin, s_footprint.origin) < 160000)
		{
			player thread play_robot_stomp_warning_vo();
		}
	}
}

/*
	Name: play_robot_stomp_warning_vo
	Namespace: zm_tomb_giant_robot
	Checksum: 0xDB3BBF35
	Offset: 0x81F8
	Size: 0x146
	Parameters: 0
	Flags: Linked
*/
function play_robot_stomp_warning_vo()
{
	a_players = getplayers();
	foreach(player in a_players)
	{
		if(player == self)
		{
			continue;
		}
		if(distance2dsquared(self.origin, player.origin) < 640000)
		{
			if(player zm_utility::is_player_looking_at(self.origin + vectorscale((0, 0, 1), 60)))
			{
				if(!(isdefined(player.dontspeak) && player.dontspeak))
				{
					player zm_audio::create_and_play_dialog("general", "warn_robot_foot");
					break;
				}
			}
		}
	}
}

/*
	Name: zombie_stomped_by_gr_vo
	Namespace: zm_tomb_giant_robot
	Checksum: 0x93D3B03A
	Offset: 0x8348
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function zombie_stomped_by_gr_vo(foot_side)
{
	self endon(#"giant_robot_stop");
	if(foot_side == "right")
	{
		str_tag = "TAG_ATTACH_HATCH_RI";
	}
	else if(foot_side == "left")
	{
		str_tag = "TAG_ATTACH_HATCH_LE";
	}
	v_origin = self gettagorigin(str_tag);
	a_players = getplayers();
	foreach(player in a_players)
	{
		if(distancesquared(v_origin, player.origin) < 640000)
		{
			if(player zm_utility::is_player_looking_at(v_origin, 0.25))
			{
				if(!(isdefined(player.dontspeak) && player.dontspeak))
				{
					player zm_audio::create_and_play_dialog("general", "robot_crush_zombie");
					return;
				}
			}
		}
	}
}

/*
	Name: play_robot_crush_player_vo
	Namespace: zm_tomb_giant_robot
	Checksum: 0x50C22948
	Offset: 0x8500
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function play_robot_crush_player_vo()
{
	self endon(#"disconnect");
	if(self laststand::player_is_in_laststand())
	{
		if(math::cointoss())
		{
			n_alt = 1;
		}
		else
		{
			n_alt = 0;
		}
		self playsoundwithnotify((("vox_plr_" + self.characterindex) + "_robot_crush_player_") + n_alt, ((("sound_done" + "vox_plr_") + self.characterindex) + "_robot_crush_player_") + n_alt);
	}
}

/*
	Name: play_timeout_warning_vo
	Namespace: zm_tomb_giant_robot
	Checksum: 0x716B2B26
	Offset: 0x85C8
	Size: 0x2F4
	Parameters: 1
	Flags: Linked
*/
function play_timeout_warning_vo(n_robot_id)
{
	level flag::set("timeout_vo_robot_" + n_robot_id);
	s_origin = struct::get("eject_warning_fx_robot_" + n_robot_id, "targetname");
	e_vo_origin = spawn_model("tag_origin", s_origin.origin);
	e_vo_origin playsoundwithnotify("vox_maxi_purge_robot_0", "vox_maxi_purge_robot_0_done");
	e_vo_origin waittill(#"vox_maxi_purge_robot_0_done");
	a_players = getplayers();
	foreach(player in a_players)
	{
		if(isdefined(player.in_giant_robot_head) && player.in_giant_robot_head == n_robot_id)
		{
			if(!(isdefined(player.giant_robot_transition) && player.giant_robot_transition))
			{
				if(!(isdefined(player.dontspeak) && player.dontspeak))
				{
					player zm_audio::create_and_play_dialog("general", "purge_robot");
					break;
				}
			}
		}
	}
	while(isdefined(player) && (isdefined(player.isspeaking) && player.isspeaking))
	{
		wait(0.1);
	}
	wait(1);
	e_vo_origin playsoundwithnotify("vox_maxi_purge_countdown_0", "vox_maxi_purge_countdown_0_done");
	e_vo_origin waittill(#"vox_maxi_purge_countdown_0_done");
	wait(1);
	level notify("timeout_warning_vo_complete_" + n_robot_id);
	e_vo_origin playsoundwithnotify("vox_maxi_purge_now_0", "vox_maxi_purge_now_0_done");
	e_vo_origin waittill(#"vox_maxi_purge_now_0_done");
	e_vo_origin delete();
	level flag::clear("timeout_vo_robot_" + n_robot_id);
}

/*
	Name: start_footprint_warning_vo
	Namespace: zm_tomb_giant_robot
	Checksum: 0x10DE0CF5
	Offset: 0x88C8
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function start_footprint_warning_vo(n_robot_id)
{
	wait(20);
	a_structs = struct::get_array("giant_robot_footprint_center", "targetname");
	foreach(struct in a_structs)
	{
		if(struct.script_int == n_robot_id)
		{
			struct thread footprint_check_for_nearby_players(self);
		}
	}
}

/*
	Name: footprint_check_for_nearby_players
	Namespace: zm_tomb_giant_robot
	Checksum: 0x4352E6BB
	Offset: 0x89B8
	Size: 0x1B4
	Parameters: 1
	Flags: Linked
*/
function footprint_check_for_nearby_players(ai_giant_robot)
{
	level endon(#"footprint_warning_vo");
	ai_giant_robot endon(#"giant_robot_stop");
	while(true)
	{
		a_players = getplayers();
		foreach(player in a_players)
		{
			if(distance2dsquared(player.origin, self.origin) < 90000)
			{
				if(distance2dsquared(player.origin, ai_giant_robot.origin) < 16000000)
				{
					if(player.origin[0] > ai_giant_robot.origin[0])
					{
						if(!(isdefined(player.dontspeak) && player.dontspeak))
						{
							player zm_utility::do_player_general_vox("general", "warn_robot");
							level.footprint_warning_vo = 1;
							level notify(#"footprint_warning_vo");
							return;
						}
					}
				}
			}
		}
		wait(1);
	}
}

/*
	Name: setup_giant_robot_devgui
	Namespace: zm_tomb_giant_robot
	Checksum: 0xEC2E3C22
	Offset: 0x8B78
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function setup_giant_robot_devgui()
{
	/#
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		level thread watch_for_force_giant_robot();
	#/
}

/*
	Name: watch_for_force_giant_robot
	Namespace: zm_tomb_giant_robot
	Checksum: 0x4AD1FD54
	Offset: 0x8D30
	Size: 0x4C0
	Parameters: 0
	Flags: Linked
*/
function watch_for_force_giant_robot()
{
	/#
		while(true)
		{
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				if(isdefined(level.devgui_force_giant_robot) && level.devgui_force_giant_robot == 0)
				{
					level.devgui_force_giant_robot = undefined;
					iprintlnbold("");
				}
				else
				{
					level.devgui_force_giant_robot = 0;
					iprintlnbold("");
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				if(isdefined(level.devgui_force_giant_robot) && level.devgui_force_giant_robot == 1)
				{
					level.devgui_force_giant_robot = undefined;
					iprintlnbold("");
				}
				else
				{
					level.devgui_force_giant_robot = 1;
					iprintlnbold("");
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				if(isdefined(level.devgui_force_giant_robot) && level.devgui_force_giant_robot == 2)
				{
					level.devgui_force_giant_robot = undefined;
					iprintlnbold("");
				}
				else
				{
					level.devgui_force_giant_robot = 2;
					iprintlnbold("");
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				if(isdefined(level.devgui_force_three_robot_round) && level.devgui_force_three_robot_round)
				{
					level.devgui_force_three_robot_round = undefined;
					iprintlnbold("");
				}
				else
				{
					level.devgui_force_three_robot_round = 1;
					iprintlnbold("");
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				if(isdefined(level.devgui_force_giant_robot_foot) && level.devgui_force_giant_robot_foot == "")
				{
					level.devgui_force_giant_robot_foot = undefined;
					iprintlnbold("");
				}
				else
				{
					level.devgui_force_giant_robot_foot = "";
					iprintlnbold("");
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				if(isdefined(level.devgui_force_giant_robot_foot) && level.devgui_force_giant_robot_foot == "")
				{
					level.devgui_force_giant_robot_foot = undefined;
					iprintlnbold("");
				}
				else
				{
					level.devgui_force_giant_robot_foot = "";
					iprintlnbold("");
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				level flag::set("");
				iprintlnbold("");
			}
			wait(0.05);
		}
	#/
}

