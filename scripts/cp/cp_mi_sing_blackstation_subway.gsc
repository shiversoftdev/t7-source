// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_sing_blackstation_police_station;
#using scripts\cp\cp_mi_sing_blackstation_sound;
#using scripts\cp\cp_mi_sing_blackstation_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace cp_mi_sing_blackstation_subway;

/*
	Name: subway_main
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x550EC314
	Offset: 0x760
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function subway_main()
{
	level clientfield::set("flotsam", 1);
	level thread subway_waypoints();
	level thread subway_completion();
	level thread subway_floating_bodies();
	level thread subway_scare_scene_01();
	level thread subway_scare_scene_02();
	level thread subway_scare_scene_03();
	level thread hendricks_swimming();
	level thread subway_dialog();
	level thread function_c7ea2242();
	level thread function_27e6ca54();
	level thread function_eb060258();
	objectives::set("cp_level_blackstation_goto_comm_relay");
	level.ai_hendricks ai::set_behavior_attribute("cqb", 1);
	foreach(ai in getaiteamarray("axis"))
	{
		ai delete();
	}
	level clientfield::set("subway_entrance_crash", 1);
	if(isdefined(level.bzm_blackstationdialogue3_5callback))
	{
		level thread [[level.bzm_blackstationdialogue3_5callback]]();
	}
	a_s_subway = struct::get_array("player_subway_pos");
	exploder::exploder("fx_expl_tanker_splashes_mist");
}

/*
	Name: function_eb060258
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x97BDF95F
	Offset: 0x9F0
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_eb060258()
{
	trigger::wait_till("trigger_underwater_vo");
	level dialog::player_say("plyr_kane_we_re_approac_0");
	level dialog::remote("kane_better_make_it_fast_0");
	level dialog::player_say("plyr_understood_1");
}

/*
	Name: function_27e6ca54
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0xDAA60392
	Offset: 0xA78
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_27e6ca54()
{
	var_ec39b8a8 = getentarray("subway_corpse_floating", "targetname");
	foreach(e_corpse in var_ec39b8a8)
	{
		e_corpse thread function_62437267();
	}
	var_40eadcd7 = getent("subway_corpse_3", "targetname");
	var_40eadcd7 thread function_62437267();
}

/*
	Name: function_62437267
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x5F8773FB
	Offset: 0xB78
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_62437267()
{
	self thread scene::play(self.script_noteworthy, self);
}

/*
	Name: function_c7ea2242
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x40491F38
	Offset: 0xBA8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_c7ea2242()
{
	trigger::wait_till("trigger_subway_tiles");
	clientfield::set("subway_tiles", 1);
}

/*
	Name: function_99f304f0
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x47F17581
	Offset: 0xBF0
	Size: 0x182
	Parameters: 0
	Flags: Linked
*/
function function_99f304f0()
{
	self endon(#"death");
	self.var_15caaa0c = 0;
	while(!level flag::get("flag_kane_intro_complete"))
	{
		while(!self isplayerunderwater())
		{
			wait(0.1);
		}
		if(!self.var_15caaa0c)
		{
			self.var_15caaa0c = 1;
			self thread util::show_hint_text(&"COOP_SWIM_INSTRUCTIONS");
		}
		self clientfield::set_to_player("play_bubbles", 1);
		self fx::play("bubbles", self.origin, (0, 0, 0), "swim_done", 1, "j_spineupper");
		while(self isplayerunderwater())
		{
			wait(0.1);
		}
		self clientfield::set_to_player("play_bubbles", 0);
		self notify(#"swim_done");
		wait(0.1);
	}
	self clientfield::set_to_player("play_bubbles", 0);
	self notify(#"swim_done");
}

/*
	Name: subway_waypoints
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0xEFF535E7
	Offset: 0xD80
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function subway_waypoints()
{
	level objectives::breadcrumb("subway_breadcrumb");
	level objectives::breadcrumb("trigger_breadcrumb_subway_exit");
	level objectives::breadcrumb("trigger_breadcrumb_police_street", "cp_level_blackstation_climb");
}

/*
	Name: subway_completion
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x32E30D4
	Offset: 0xDF8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function subway_completion()
{
	level flag::wait_till("flag_waypoint_subway01");
	wait(2);
	level thread scene::play("p7_fxanim_cp_blackstation_subway_stair_debris_bundle");
	skipto::objective_completed("objective_subway");
}

/*
	Name: subway_dialog
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x85DE0B4D
	Offset: 0xE60
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function subway_dialog()
{
	trigger::wait_till("trig_hendricks_swim");
	level thread namespace_4297372::function_37f7c98d();
	level thread cp_mi_sing_blackstation_police_station::function_a7bb8a82();
}

/*
	Name: hendricks_swimming
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x5371479C
	Offset: 0xEB8
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function hendricks_swimming()
{
	level scene::init("cin_bla_08_02_subway_vign_swim_first_section");
	trigger::wait_till("trig_hendricks_swim");
	level scene::add_scene_func("cin_bla_08_02_subway_vign_swim_first_section", &function_561cae8a, "play");
	level scene::play("cin_bla_08_02_subway_vign_swim_first_section");
	level flag::wait_till("subway_second_section");
	level scene::play("cin_bla_08_02_subway_vign_swim_second_section");
	level flag::wait_till("subway_third_section");
	level scene::add_scene_func("cin_bla_08_02_subway_vign_swim_third_section", &function_5f8ce82c, "done");
	level scene::play("cin_bla_08_02_subway_vign_swim_third_section");
	if(!level flag::get("flag_waypoint_subway01"))
	{
		trigger::use("trig_hendricks_color_b2", "targetname");
	}
	level.ai_hendricks notify(#"move_to_subway_exit");
	level.ai_hendricks ai::set_behavior_attribute("forceTacticalWalk", 1);
	level flag::wait_till("subway_exit");
	level.ai_hendricks ai::set_behavior_attribute("forceTacticalWalk", 0);
}

/*
	Name: function_561cae8a
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0xA520390D
	Offset: 0x10B8
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_561cae8a(a_ents)
{
	wait(2);
	level.ai_hendricks fx::play("bubbles", level.ai_hendricks.origin, (0, 0, 0), "swim_done", 1, "j_spineupper");
}

/*
	Name: function_5f8ce82c
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x47DF79D8
	Offset: 0x1120
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function function_5f8ce82c(a_ents)
{
	level.ai_hendricks notify(#"swim_done");
}

/*
	Name: subway_floating_bodies
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x33E2B795
	Offset: 0x1148
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function subway_floating_bodies()
{
	level endon(#"out_of_water");
	e_floating_bodies = getentarray("subway_corpse_floating", "targetname");
	array::thread_all(e_floating_bodies, &subway_floating_bodies_move);
}

/*
	Name: subway_floating_bodies_move
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0xF4FFC240
	Offset: 0x11B0
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function subway_floating_bodies_move()
{
	level endon(#"out_of_water");
	self endon(#"death");
	e_body = self;
	n_rotate_angle = 60;
	while(true)
	{
		e_body rotatepitch(n_rotate_angle, 5);
		wait(4.5);
	}
}

/*
	Name: subway_scare_scene_01
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x2B438832
	Offset: 0x1228
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function subway_scare_scene_01()
{
	level endon(#"out_of_water");
	level endon(#"cancel_scare");
	e_corpse = getent("subway_corpse", "targetname");
	e_linkto = util::spawn_model("tag_origin", e_corpse.origin, e_corpse.angles);
	e_corpse linkto(e_linkto);
	e_corpse thread scene::play("cin_bla_08_02_subway_vign_dead_body_scare", e_corpse);
	t_trigger = getent("trig_subway_scare", "targetname");
	t_trigger waittill(#"trigger", player);
	playsoundatposition("mus_subway_scare", (0, 0, 0));
	level notify(#"scare_happened");
	level thread corpse_dialog(player);
	e_linkto movey(-60, 0.5);
	e_linkto rotateroll(50, 2);
	e_linkto rotateyaw(90, 1);
	e_linkto waittill(#"movedone");
	e_linkto moveto(e_corpse.origin - (0, 50, 25), 5);
}

/*
	Name: subway_scare_scene_02
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x83F5ABE5
	Offset: 0x1428
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function subway_scare_scene_02()
{
	level endon(#"out_of_water");
	t_trigger = getent("trig_subway_scare_2", "targetname");
	e_corpse = getent("subway_corpse_2", "targetname");
	level waittill(#"scare_happened");
	e_corpse endon(#"death");
	t_trigger waittill(#"trigger", player);
	e_corpse movex(-80, 2);
	e_corpse rotatepitch(60, 5);
	e_corpse waittill(#"movedone");
	e_corpse moveto(e_corpse.origin - (0, -50, 50), 5);
}

/*
	Name: subway_scare_scene_03
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x46210B46
	Offset: 0x1558
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function subway_scare_scene_03()
{
	level endon(#"out_of_water");
	t_trigger = getent("trig_subway_scare_3", "targetname");
	e_corpse = getent("subway_corpse_3", "targetname");
	e_corpse endon(#"death");
	t_trigger waittill(#"trigger", player);
	e_corpse movez(-24, 0.75);
	e_corpse rotateroll(60, 5);
	e_corpse waittill(#"movedone");
	e_corpse moveto(e_corpse.origin - (25, 25, 75), 5);
}

/*
	Name: corpse_dialog
	Namespace: cp_mi_sing_blackstation_subway
	Checksum: 0x57B50964
	Offset: 0x1678
	Size: 0x16
	Parameters: 1
	Flags: Linked
*/
function corpse_dialog(player)
{
	level endon(#"out_of_water");
}

