// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_eth_prologue;
#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_prologue_apc;
#using scripts\cp\cp_prologue_hangars;
#using scripts\cp\cp_prologue_hostage_rescue;
#using scripts\cp\cp_prologue_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace security_camera;

/*
	Name: security_camera_start
	Namespace: security_camera
	Checksum: 0xA4A9142F
	Offset: 0xF18
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function security_camera_start(str_objective)
{
	security_camera_precache();
	level notify(#"hash_84f95272");
	array::run_all(level.players, &util::set_low_ready, 1);
	level util::clientnotify("sndStopFiretruck");
	level thread security_camera_main();
}

/*
	Name: security_camera_precache
	Namespace: security_camera
	Checksum: 0x3471BE9
	Offset: 0xFB0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function security_camera_precache()
{
	level flag::init("everyone_in_camera_room");
}

/*
	Name: security_camera_main
	Namespace: security_camera
	Checksum: 0x6F331A7E
	Offset: 0xFE0
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function security_camera_main()
{
	var_38907d67 = getent("t_regroup_security_camera", "targetname");
	var_38907d67 triggerenable(0);
	exploder::exploder("light_exploder_torture_rooms");
	level thread cp_prologue_util::function_950d1c3b(1);
	level thread security_desk::function_bfe70f02();
	level thread function_6475a61e();
	battlechatter::function_d9f49fba(0);
	cp_prologue_util::function_47a62798(1);
	level thread function_61e4fa9();
	level.ai_hendricks thread hendricks_security_camera();
	level thread setup_security_cameras();
	level waittill(#"hash_81d6c615");
	while(true)
	{
		var_d62d9e75 = function_e1a52cb4();
		if(!var_d62d9e75)
		{
			break;
		}
		wait(0.05);
	}
	level scene::stop("injured_carried1", "targetname");
	level scene::stop("injured_carried2", "targetname");
	level notify(#"hash_50dbb16b");
	exploder::exploder_stop("light_exploder_torture_rooms");
	skipto::objective_completed("skipto_security_camera");
}

/*
	Name: function_6475a61e
	Namespace: security_camera
	Checksum: 0xC02236B2
	Offset: 0x11E8
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function function_6475a61e()
{
	s_pos = struct::get("temp_security_door_obj", "targetname");
	objectives::set("cp_level_prologue_security_door", s_pos);
	cp_prologue_util::function_d1f1caad("t_start_security_cam_room_breach_v2");
	wait(2);
	objectives::complete("cp_level_prologue_security_door");
	level flag::wait_till("everyone_in_camera_room");
	objectives::complete("cp_level_prologue_locate_the_security_room");
	objectives::set("cp_level_prologue_locate_the_minister");
	level waittill(#"minister_located");
	objectives::complete("cp_level_prologue_security_camera");
	objectives::complete("cp_level_prologue_locate_the_minister");
	objectives::set("cp_level_prologue_free_the_minister");
}

/*
	Name: function_e1a52cb4
	Namespace: security_camera
	Checksum: 0xD89F83A6
	Offset: 0x1320
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_e1a52cb4()
{
	var_d62d9e75 = 0;
	foreach(e_player in level.activeplayers)
	{
		if(isdefined(e_player.var_1f4942ae) && e_player.var_1f4942ae)
		{
			var_d62d9e75++;
		}
	}
	return var_d62d9e75;
}

/*
	Name: setup_security_cameras
	Namespace: security_camera
	Checksum: 0x76F1B09
	Offset: 0x13E0
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function setup_security_cameras()
{
	util::wait_network_frame();
	level clientfield::set("setup_security_cameras", 1);
	level thread function_d0260dae();
	level.minister_located = 0;
	level.security_cams = [];
	function_d8d1298e("hallway", "cin_pro_05_02_securitycam_pip_ministerdrag", 1);
	function_d8d1298e("interrogation", "cin_pro_05_02_securitycam_pip_ministerdrag_interrogationroom", 1);
	function_d8d1298e("torture_prisoner_1", "cin_pro_05_02_securitycam_pip_solitary");
	function_d8d1298e("torture_prisoner_2", "cin_pro_05_02_securitycam_pip_pipe");
	function_d8d1298e("torture_prisoner_3", "cin_pro_05_02_securitycam_pip_funnel");
	function_d8d1298e("torture_khalil", "cin_pro_05_02_securitycam_pip_khalil");
	function_d8d1298e("torture_prisoner_4", "cin_pro_05_02_securitycam_pip_branding");
	function_d8d1298e("torture_minister", "cin_pro_05_02_securitycam_pip_waterboard");
	function_d8d1298e("torture_prisoner_5", "cin_pro_05_02_securitycam_pip_pressure");
	function_9f9f8c2a();
	level thread activate_player_video_screens("t_security_camera_use_left", "s_security_cam_station_left", 1);
}

/*
	Name: function_9f9f8c2a
	Namespace: security_camera
	Checksum: 0xAEC1B8C7
	Offset: 0x15B8
	Size: 0x18E
	Parameters: 0
	Flags: Linked
*/
function function_9f9f8c2a()
{
	if(!isdefined(level.var_690ce961))
	{
		level.var_690ce961 = level.security_cams["torture_minister"].n_index;
	}
	else
	{
		var_1d7e2b7c = function_6840a15e(level.var_690ce961);
		switch(var_1d7e2b7c.str_name)
		{
			case "torture_minister":
			{
				level.var_690ce961 = level.security_cams["hallway"].n_index;
				level.security_cams["hallway"].var_b5991f0e = 0;
				level.security_cams["hallway"].var_a1a1b35e = 3;
				break;
			}
			case "hallway":
			{
				level.var_690ce961 = level.security_cams["interrogation"].n_index;
				level.security_cams["interrogation"].var_b5991f0e = 0;
				level.security_cams["interrogation"].var_a1a1b35e = 3;
				break;
			}
			case "interrogation":
			{
				level.minister_located = 1;
				level thread namespace_21b2c1f2::function_fa2e45b8();
				break;
			}
		}
	}
}

/*
	Name: turn_off_security_cameras
	Namespace: security_camera
	Checksum: 0x50D8642
	Offset: 0x1750
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function turn_off_security_cameras()
{
	showmiscmodels("security_decal_prop");
	foreach(e_player in level.activeplayers)
	{
		e_player clientfield::set_to_player("turn_on_multicam", 0);
	}
	foreach(s_camera in level.security_cams)
	{
		if(isdefined(s_camera.str_scene) && level scene::is_playing(s_camera.str_scene))
		{
			level scene::stop(s_camera.str_scene);
		}
	}
	level clientfield::set("setup_security_cameras", 0);
	level clientfield::set("toggle_security_camera_pbg_bank", 0);
}

/*
	Name: activate_player_video_screens
	Namespace: security_camera
	Checksum: 0x7B71691A
	Offset: 0x1918
	Size: 0x154
	Parameters: 3
	Flags: Linked
*/
function activate_player_video_screens(var_3675dd99, str_player_use_struct, extra_cam_index)
{
	s_player_use = struct::get(str_player_use_struct, "targetname");
	t_interact = getent(var_3675dd99, "targetname");
	t_interact triggerenable(0);
	level waittill(#"hash_af8926a2");
	level.var_ab82ba6d = 0;
	level flag::wait_till("everyone_in_camera_room");
	t_interact triggerenable(1);
	e_object = util::init_interactive_gameobject(t_interact, &"cp_prompt_dni_prologue_security_camera", &"CP_MI_ETH_PROLOGUE_USE_SECURITY_CAMERA", &function_b85fc83f);
	e_object.s_player_use = s_player_use;
	e_object.extra_cam_index = extra_cam_index;
	e_object thread check_for_video_cam_disable();
}

/*
	Name: check_for_video_cam_disable
	Namespace: security_camera
	Checksum: 0xE8D621D3
	Offset: 0x1A78
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function check_for_video_cam_disable()
{
	self endon(#"death");
	level waittill(#"minister_located");
	wait(1);
	self gameobjects::disable_object();
}

/*
	Name: function_b85fc83f
	Namespace: security_camera
	Checksum: 0x1D7F9CB7
	Offset: 0x1AB8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_b85fc83f(e_player)
{
	e_player thread player_uses_the_security_camera_station(self.s_player_use, self.extra_cam_index);
	self thread function_85343e08(e_player);
	self gameobjects::disable_object();
}

/*
	Name: function_85343e08
	Namespace: security_camera
	Checksum: 0x3FF8A380
	Offset: 0x1B28
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_85343e08(e_player)
{
	level endon(#"minister_located");
	e_player waittill(#"disconnect");
	self gameobjects::enable_object();
}

/*
	Name: player_uses_the_security_camera_station
	Namespace: security_camera
	Checksum: 0x36E43093
	Offset: 0x1B70
	Size: 0x3DE
	Parameters: 2
	Flags: Linked
*/
function player_uses_the_security_camera_station(s_player_use, extra_cam_index)
{
	self endon(#"disconnect");
	self.var_1f4942ae = 1;
	snd_key = spawn("script_origin", s_player_use.origin);
	snd_key playsound("evt_typing");
	str_anim_comfirm = "p_security_cam_interface_point";
	str_anim_outro = "p_security_cam_interface_exit";
	str_anim_idle = "p_security_cam_interface_idle";
	s_align_struct = struct::get("s_security_cam_station_left", "targetname");
	s_align_struct scene::play("p_security_cam_interface_intro", self);
	if(!level.var_ab82ba6d)
	{
		level notify(#"hash_17ce64b4");
		self thread turn_on_security_camera(extra_cam_index);
		level.var_ab82ba6d = 1;
		level thread namespace_21b2c1f2::function_e847067();
	}
	s_align_struct thread scene::play(str_anim_idle, self);
	wait(2);
	while(!level.minister_located)
	{
		self util::screen_message_create_client(&"CP_MI_ETH_PROLOGUE_CAMERA_CHANGE", undefined, undefined, 170);
		if(self actionbuttonpressed())
		{
			self util::screen_message_delete_client();
			self playlocalsound("evt_camera_scan_switch");
			level.var_d658503a++;
			if(level.var_d658503a >= level.security_cams.size)
			{
				level.var_d658503a = 0;
			}
			if(level.var_d658503a == 4)
			{
				level flag::set("security_cam_full_house");
			}
			self thread function_a4090f73(level.var_d658503a);
			self function_d77b3165(extra_cam_index);
			self scan_handler(str_anim_idle, str_anim_comfirm, s_align_struct);
			level flag::wait_till("face_scanning_complete");
			level flag::wait_till_clear("face_scanning_double_pause");
		}
		wait(0.05);
	}
	self thread function_a4090f73(level.var_d658503a);
	level thread namespace_21b2c1f2::function_973b77f9();
	level.minister_located = 1;
	level notify(#"minister_located");
	var_38907d67 = getent("t_regroup_security_camera", "targetname");
	var_38907d67 triggerenable(1);
	snd_key delete();
	s_align_struct scene::play(str_anim_outro, self);
	turn_off_security_cameras();
	self.var_1f4942ae = undefined;
}

/*
	Name: function_d77b3165
	Namespace: security_camera
	Checksum: 0xAD920FBE
	Offset: 0x1F58
	Size: 0xA2
	Parameters: 1
	Flags: Linked
*/
function function_d77b3165(extra_cam_index)
{
	foreach(player in level.players)
	{
		player clientfield::set_to_player("set_cam_lookat_object", level.var_d658503a);
	}
}

/*
	Name: function_d8d1298e
	Namespace: security_camera
	Checksum: 0x176F0E8
	Offset: 0x2008
	Size: 0x1A6
	Parameters: 3
	Flags: Linked
*/
function function_d8d1298e(str_name, str_scene, var_b5991f0e = 0)
{
	var_1ca98eed = spawnstruct();
	var_1ca98eed.str_name = str_name;
	var_1ca98eed.n_index = level.security_cams.size;
	var_1ca98eed.b_vo_played = 0;
	var_1ca98eed.var_b5991f0e = var_b5991f0e;
	var_1ca98eed.str_scene = str_scene;
	var_1ca98eed.var_2cc1a0a1 = 1;
	var_1ca98eed.var_a1a1b35e = scene::get_actor_count(str_scene);
	level scene::add_scene_func(str_scene, &function_c41806ee, "init", var_1ca98eed.n_index);
	level scene::add_scene_func(str_scene, &function_48f438fd, "init");
	level scene::init(str_scene);
	if(var_b5991f0e)
	{
		var_1ca98eed.var_2cc1a0a1 = 0;
		var_1ca98eed.var_a1a1b35e = 0;
	}
	level.security_cams[str_name] = var_1ca98eed;
}

/*
	Name: function_c41806ee
	Namespace: security_camera
	Checksum: 0xAD926EF5
	Offset: 0x21B8
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function function_c41806ee(a_ents, n_index)
{
	if(!isdefined(a_ents["prisoner"]))
	{
		return;
	}
	var_a668bada = n_index - 1;
	while(!isdefined(level.var_d658503a) || level.var_d658503a < var_a668bada)
	{
		wait(0.05);
	}
	a_ents["prisoner"] sethighdetail(1);
	a_ents["prisoner"].e_streamer = createstreamerhint(a_ents["prisoner"].origin, 1);
	while(level.var_d658503a <= n_index)
	{
		wait(0.05);
	}
	a_ents["prisoner"] sethighdetail(0);
	a_ents["prisoner"].e_streamer delete();
}

/*
	Name: function_48f438fd
	Namespace: security_camera
	Checksum: 0xFD16C625
	Offset: 0x2308
	Size: 0x10A
	Parameters: 1
	Flags: Linked
*/
function function_48f438fd(a_ents)
{
	util::wait_network_frame();
	foreach(ent in a_ents)
	{
		if(ent.model === "tag_origin")
		{
			n_index = function_5e3416f2(self.scriptbundlename).n_index;
			if(n_index == 0)
			{
				n_index = 9;
			}
			ent clientfield::set("update_camera_position", n_index);
		}
	}
}

/*
	Name: function_6840a15e
	Namespace: security_camera
	Checksum: 0x8D32ED44
	Offset: 0x2420
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function function_6840a15e(n_index)
{
	foreach(var_1ca98eed in level.security_cams)
	{
		if(var_1ca98eed.n_index == n_index)
		{
			return var_1ca98eed;
		}
	}
}

/*
	Name: function_5e3416f2
	Namespace: security_camera
	Checksum: 0xB5D49E9B
	Offset: 0x24C0
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function function_5e3416f2(str_scene)
{
	foreach(var_1ca98eed in level.security_cams)
	{
		if(var_1ca98eed.str_scene === str_scene)
		{
			return var_1ca98eed;
		}
	}
}

/*
	Name: turn_on_security_camera
	Namespace: security_camera
	Checksum: 0x5685BA0A
	Offset: 0x2560
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function turn_on_security_camera(cam_index)
{
	hidemiscmodels("security_decal_prop");
	foreach(e_player in level.activeplayers)
	{
		e_player clientfield::set_to_player("turn_on_multicam", cam_index);
	}
	level.var_d658503a = 0;
	self clientfield::set_to_player("set_cam_lookat_object", level.var_d658503a);
	level clientfield::set("toggle_security_camera_pbg_bank", 1);
}

/*
	Name: scan_handler
	Namespace: security_camera
	Checksum: 0x21DDF003
	Offset: 0x2670
	Size: 0x1B4
	Parameters: 3
	Flags: Linked
*/
function scan_handler(str_anim_idle, str_anim_comfirm, s_align_struct)
{
	self endon(#"disconnect");
	var_1ca98eed = function_6840a15e(level.var_d658503a);
	if(level.var_d658503a > 0)
	{
		var_5b1f7665 = function_6840a15e(level.var_d658503a - 1);
		if(isdefined(var_5b1f7665.str_scene) && !var_5b1f7665.var_b5991f0e)
		{
			scene::stop(var_5b1f7665.str_scene, 1);
		}
	}
	if(isdefined(var_1ca98eed.str_scene) && !var_1ca98eed.var_b5991f0e)
	{
		level thread scene::play(var_1ca98eed.str_scene);
	}
	level thread function_2e16b263(var_1ca98eed.str_scene);
	var_378c281e = self start_face_scanner(level.var_d658503a);
	if(var_378c281e)
	{
		s_align_struct scene::play(str_anim_comfirm, self);
		s_align_struct thread scene::play(str_anim_idle, self);
		function_9f9f8c2a();
	}
}

/*
	Name: function_2e16b263
	Namespace: security_camera
	Checksum: 0x871F2B23
	Offset: 0x2830
	Size: 0x306
	Parameters: 1
	Flags: Linked
*/
function function_2e16b263(scenename)
{
	level notify(#"hash_1b4c750");
	level endon(#"hash_1b4c750");
	if(!isdefined(level.var_cc008929))
	{
		level.var_cc008929 = spawn("script_origin", (0, 0, 0));
		level.isfirsttime = 1;
	}
	switch(scenename)
	{
		case "cin_pro_05_02_securitycam_pip_solitary":
		{
			level.var_cc008929 playloopsound("evt_securitycam_solitary", 0.1);
			break;
		}
		case "cin_pro_05_02_securitycam_pip_pipe":
		{
			level.var_cc008929 playloopsound("evt_securitycam_pipe", 0.1);
			break;
		}
		case "cin_pro_05_02_securitycam_pip_funnel":
		{
			level.var_cc008929 playloopsound("evt_securitycam_funnel", 0.1);
			break;
		}
		case "cin_pro_05_02_securitycam_pip_branding":
		{
			level.var_cc008929 playloopsound("evt_securitycam_branding", 0.1);
			break;
		}
		case "cin_pro_05_02_securitycam_pip_pressure":
		{
			level.var_cc008929 playloopsound("evt_securitycam_pressure", 0.1);
			break;
		}
		case "cin_pro_05_02_securitycam_pip_waterboard":
		{
			level.var_cc008929 stoploopsound(0.1);
			level.var_cc008929 playsound("evt_securitycam_minister_water");
			break;
		}
		case "cin_pro_05_02_securitycam_pip_ministerdrag":
		{
			level.var_cc008929 stoploopsound(0.1);
			level.var_cc008929 playsound("evt_securitycam_minister_walk");
			break;
		}
		case "cin_pro_05_02_securitycam_pip_ministerdrag_interrogationroom":
		{
			if(isdefined(level.isfirsttime) && level.isfirsttime)
			{
				level.var_cc008929 stoploopsound(0.1);
				level.isfirsttime = 0;
			}
			else
			{
				level.var_cc008929 stoploopsound(0.1);
				level.var_cc008929 playsound("evt_securitycam_minister_sit");
			}
			break;
		}
		default:
		{
			level.var_cc008929 stoploopsound(0.1);
			level.var_cc008929 stopsounds();
			break;
		}
	}
}

/*
	Name: start_face_scanner
	Namespace: security_camera
	Checksum: 0x838FDC8F
	Offset: 0x2B40
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function start_face_scanner(extra_cam_index)
{
	self endon(#"disconnect");
	level flag::clear("face_scanning_complete");
	var_1ca98eed = function_6840a15e(extra_cam_index);
	if(var_1ca98eed.var_a1a1b35e == 0)
	{
		wait(2);
		return false;
	}
	wait(0.5);
	level flag::wait_till("face_scanning_complete");
	if(level.var_d658503a == level.var_690ce961)
	{
		return true;
	}
	return false;
}

/*
	Name: function_a4090f73
	Namespace: security_camera
	Checksum: 0xBC33A74C
	Offset: 0x2C08
	Size: 0x3B4
	Parameters: 1
	Flags: Linked
*/
function function_a4090f73(n_cam_index)
{
	if(!isdefined(level.var_965f8f82))
	{
		level.var_965f8f82 = 1;
	}
	switch(n_cam_index)
	{
		case 0:
		{
			wait(3);
			break;
		}
		case 1:
		{
			if(level.var_965f8f82)
			{
				level.var_965f8f82 = 0;
				wait(3);
			}
			else
			{
				level.ai_hendricks dialog::say("hend_bingo_0", 5);
				level notify(#"hash_fd656b57");
			}
			break;
		}
		case 2:
		{
			level flag::wait_till("scanning_dialog_done");
			self dialog::say("plyr_other_hostages_i_0", 0.5);
			level.ai_hendricks dialog::say("hend_so_did_i_0", 0.1);
			break;
		}
		case 3:
		{
			level.ai_hendricks dialog::say("hend_poor_sons_of_bitches_0", 1);
			level.ai_hendricks dialog::say("hend_the_nrc_are_known_fo_0", 0.5);
			break;
		}
		case 4:
		{
			level flag::set("face_scanning_double_pause");
			level waittill(#"hash_f35713c");
			level flag::set("face_scanning_complete");
			level.ai_hendricks dialog::say("hend_check_the_next_feed_0", 0.5);
			level flag::clear("face_scanning_double_pause");
			break;
		}
		case 5:
		{
			self dialog::say("plyr_are_we_just_going_to_1", 0.25);
			level.ai_hendricks dialog::say("hend_we_have_our_orders_0");
			break;
		}
		case 6:
		{
			wait(3);
			level.ai_hendricks thread dialog::say("hend_no_match_0");
			break;
		}
		case 7:
		{
			level flag::set("face_scanning_double_pause");
			wait(3);
			level flag::set("face_scanning_complete");
			level.ai_hendricks dialog::say("hend_that_s_him_the_min_0", 0.75);
			level.ai_hendricks dialog::say("hend_he_s_being_moved_0", 9);
			level flag::clear("face_scanning_double_pause");
			break;
		}
		case 8:
		{
			level.ai_hendricks dialog::say("hend_we_have_to_find_out_0", 0.5);
			break;
		}
		default:
		{
			break;
		}
	}
	level flag::set("face_scanning_complete");
}

/*
	Name: function_d0260dae
	Namespace: security_camera
	Checksum: 0xBB9A55B5
	Offset: 0x2FC8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_d0260dae()
{
	level waittill(#"hash_dbfb4368");
	level flag::set("scanning_dialog_done");
}

/*
	Name: hendricks_security_camera
	Namespace: security_camera
	Checksum: 0x38E0E08B
	Offset: 0x3000
	Size: 0x2EC
	Parameters: 0
	Flags: Linked
*/
function hendricks_security_camera()
{
	level flag::set("activate_bc_5");
	level flag::wait_till("stealth_kill_prepare_done");
	cp_prologue_util::function_d1f1caad("t_start_security_cam_room_breach_v2");
	level thread namespace_21b2c1f2::function_973b77f9();
	level notify(#"hash_fa5c41eb");
	exploder::exploder("light_exploder_cameraroom");
	level thread scene::add_scene_func("cin_pro_05_01_securitycam_1st_stealth_kill", &function_2b60c70b);
	level thread namespace_21b2c1f2::function_fd00a4f2();
	level scene::play("cin_pro_05_01_securitycam_1st_stealth_kill");
	level notify(#"hash_af8926a2");
	if(isdefined(level.bzm_prologuedialogue3callback))
	{
		level thread [[level.bzm_prologuedialogue3callback]]();
	}
	level flag::set("everyone_in_camera_room");
	level notify(#"breech");
	level thread function_fef03d1c();
	exploder::stop_exploder("light_exploder_cameraroom");
	level waittill(#"hash_17ce64b4");
	level scene::play("cin_pro_05_01_securitycam_1st_stealth_kill_scanning");
	level flag::wait_till("security_cam_full_house");
	level scene::play("cin_pro_05_01_securitycam_1st_stealth_kill_notice");
	level waittill(#"hash_fd656b57");
	level thread function_2e16b263("none");
	level scene::add_scene_func("cin_pro_05_01_securitycam_1st_stealth_kill_movetodoor", &function_8f6060f7, "play");
	level scene::play("cin_pro_05_01_securitycam_1st_stealth_kill_movetodoor");
	array::run_all(level.players, &util::set_low_ready, 0);
	level flag::wait_till("player_past_security_room");
	level notify(#"hash_81d6c615");
	level scene::play("cin_pro_05_01_securitycam_1st_stealth_kill_exit");
	level flag::set("hendricks_exit_cam_room");
}

/*
	Name: function_30b1de21
	Namespace: security_camera
	Checksum: 0x90A640D6
	Offset: 0x32F8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_30b1de21(a_ents)
{
	level waittill(#"hash_640b2018");
	level dialog::player_say("plyr_ready_when_you_are_0");
}

/*
	Name: function_8f6060f7
	Namespace: security_camera
	Checksum: 0xF22FB52D
	Offset: 0x3338
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_8f6060f7(a_ents)
{
	level waittill(#"hash_59303d35");
	level dialog::player_say("plyr_you_sound_like_the_v_0");
}

/*
	Name: function_9887d555
	Namespace: security_camera
	Checksum: 0x710108B5
	Offset: 0x3378
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_9887d555(a_ents)
{
	level flag::set("stealth_kill_prepare_done");
}

/*
	Name: function_d6557dc4
	Namespace: security_camera
	Checksum: 0x9110D549
	Offset: 0x33B0
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_d6557dc4(a_ents)
{
	a_ents["stealth_kill_pistol"] hide();
	level waittill(#"hash_7b2fc2a1");
	a_ents["stealth_kill_pistol"] show();
	util::wait_network_frame();
	util::wait_network_frame();
	a_ents["hendricks"] detach("c_hro_hendricks_prologue_cin_gunprop_fb");
	level waittill(#"hash_4b566398");
	a_ents["hendricks"] attach("c_hro_hendricks_prologue_cin_gunprop_fb");
	a_ents["stealth_kill_pistol"] hide();
}

/*
	Name: function_2b60c70b
	Namespace: security_camera
	Checksum: 0x2743CF56
	Offset: 0x34B8
	Size: 0x21C
	Parameters: 1
	Flags: Linked
*/
function function_2b60c70b(a_ents)
{
	level waittill(#"hash_55529da");
	var_fc54e080 = getent("security_control_room_blocker", "targetname");
	var_fc54e080 notsolid();
	var_3c301126 = getent("security_camera_door_r", "targetname");
	var_280d5f68 = getent("security_camera_door_l", "targetname");
	var_280d5f68 movey(52, 0.75, 0.25, 0);
	var_3c301126 movey(52 * -1, 0.75, 0.25, 0);
	playsoundatposition("evt_securityroom_door_open", (3464, -313, -263));
	level waittill(#"hash_cfa80fd0");
	trigger::wait_till("close_security_door_trig");
	var_fc54e080 solid();
	var_280d5f68 movey(52 * -1, 0.75, 0.25, 0);
	var_3c301126 movey(52, 0.75, 0.25, 0);
	playsoundatposition("evt_securityroom_door_close", (3464, -313, -263));
}

/*
	Name: function_fef03d1c
	Namespace: security_camera
	Checksum: 0x5C29F797
	Offset: 0x36E0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_fef03d1c()
{
	level endon(#"hash_17ce64b4");
	wait(15);
	level.ai_hendricks dialog::say("hend_you_wanna_hustle_ha_0");
	wait(20);
	level.ai_hendricks dialog::say("hend_our_cover_s_blown_an_0");
}

/*
	Name: function_61e4fa9
	Namespace: security_camera
	Checksum: 0x1B68C0AD
	Offset: 0x3748
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_61e4fa9()
{
	level endon(#"hash_fa5c41eb");
	level waittill(#"hash_6edff9b0");
	level.ai_hendricks dialog::say("hend_you_ve_got_breach_l_0");
	wait(20);
	level.ai_hendricks dialog::say("hend_minister_s_not_gonna_0");
}

