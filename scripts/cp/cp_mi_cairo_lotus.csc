// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_cairo_lotus_fx;
#using scripts\cp\cp_mi_cairo_lotus_patch_c;
#using scripts\cp\cp_mi_cairo_lotus_sound;
#using scripts\cp\lotus_util;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace cp_mi_cairo_lotus;

/*
	Name: main
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xD069524F
	Offset: 0x958
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	util::set_streamer_hint_function(&force_streamer, 3);
	init_clientfields();
	cp_mi_cairo_lotus_fx::main();
	cp_mi_cairo_lotus_sound::main();
	setup_skiptos();
	lotus_util::function_84d3f32a();
	load::main();
	callback::on_spawned(&on_player_spawned);
	util::waitforclient(0);
	namespace_1a639ab1::function_7403e82b();
}

/*
	Name: on_player_spawned
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xEE7AC811
	Offset: 0xA38
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function on_player_spawned(localclientnum)
{
	player = getlocalplayer(localclientnum);
	var_8a357b77 = getentarray(localclientnum, "ventilation_fan", "targetname");
	array::thread_all(var_8a357b77, &lotus_util::spinning_fan);
	player thread lotus_util::falling_debris(localclientnum);
	player thread function_f61f00f(localclientnum);
}

/*
	Name: function_f61f00f
	Namespace: cp_mi_cairo_lotus
	Checksum: 0x67D23501
	Offset: 0xAF8
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function function_f61f00f(localclientnum)
{
	self notify(#"hash_78bd6500");
	self endon(#"hash_78bd6500");
	e_trigger = getent(localclientnum, "mobile_shop_1_final_ascent", "targetname");
	if(sessionmodeiscampaignzombiesgame() && !isdefined(e_trigger))
	{
		return;
	}
	e_trigger._localclientnum = localclientnum;
	e_trigger waittill(#"trigger", trigplayer);
	e_trigger thread trigger::function_d1278be0(trigplayer, &trig_mobile_shop_1_final_ascent);
}

/*
	Name: init_clientfields
	Namespace: cp_mi_cairo_lotus
	Checksum: 0x5690D9FC
	Offset: 0xBD8
	Size: 0x4B4
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	visionset_mgr::register_visionset_info("cp_raven_hallucination", 1, 1, "cp_raven_hallucination", "cp_raven_hallucination");
	clientfield::register("world", "hs_fxinit_vent", 1, 1, "int", &function_579de1bd, 0, 0);
	clientfield::register("world", "hs_fxanim_vent", 1, 1, "int", &function_42adde46, 0, 0);
	clientfield::register("world", "swap_crowd_to_riot", 1, 1, "int", &function_a24b1d9f, 0, 0);
	clientfield::register("world", "crowd_anims_off", 1, 1, "int", &function_a24774f1, 0, 0);
	clientfield::register("scriptmover", "mobile_shop_fxanims", 1, 3, "int", &lotus_util::function_571c4083, 0, 0);
	clientfield::register("scriptmover", "raven_decal", 1, 1, "int", &lotus_util::function_ace9894c, 0, 0);
	clientfield::register("toplayer", "pickup_hakim_rumble_loop", 1, 1, "int", &function_448b79a2, 0, 0);
	clientfield::register("toplayer", "mobile_shop_rumble_loop", 1, 1, "int", &function_29c8893e, 0, 0);
	clientfield::register("toplayer", "player_dust_fx", 1, 1, "int", &lotus_util::function_b33fd8cd, 0, 0);
	clientfield::register("toplayer", "snow_fog", 1, 1, "int", &lotus_util::function_a53d70f9, 0, 0);
	clientfield::register("toplayer", "frost_post_fx", 1, 1, "int", &lotus_util::function_d823aea7, 0, 0);
	clientfield::register("toplayer", "postfx_futz", 1, 1, "counter", &lotus_util::postfx_futz, 0, 0);
	clientfield::register("toplayer", "postfx_ravens", 1, 1, "counter", &lotus_util::function_16e0096d, 0, 0);
	clientfield::register("toplayer", "postfx_frozen_forest", 1, 1, "counter", &lotus_util::function_344d4c76, 0, 0);
	clientfield::register("allplayers", "player_frost_breath", 1, 1, "int", &lotus_util::player_frost_breath, 0, 0);
	clientfield::register("actor", "hendricks_frost_breath", 1, 1, "int", &lotus_util::function_b8a4442e, 0, 0);
}

/*
	Name: function_448b79a2
	Namespace: cp_mi_cairo_lotus
	Checksum: 0x95EDFD09
	Offset: 0x1098
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function function_448b79a2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self playrumblelooponentity(localclientnum, "cp_prologue_rumble_dropship");
	}
	else
	{
		self stoprumble(localclientnum, "cp_prologue_rumble_dropship");
	}
}

/*
	Name: function_29c8893e
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xF1137F94
	Offset: 0x1138
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function function_29c8893e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self playrumbleonentity(localclientnum, "cp_lotus_rumble_mobile_shop_shift");
		self playrumblelooponentity(localclientnum, "cp_lotus_rumble_mobile_shop_ride");
	}
	else
	{
		self stoprumble(localclientnum, "cp_lotus_rumble_mobile_shop_ride");
		self playrumbleonentity(localclientnum, "cp_lotus_rumble_mobile_shop_shift");
	}
}

/*
	Name: force_streamer
	Namespace: cp_mi_cairo_lotus
	Checksum: 0x54A33E9C
	Offset: 0x1218
	Size: 0x1CA
	Parameters: 1
	Flags: Linked
*/
function force_streamer(n_index)
{
	switch(n_index)
	{
		case 1:
		{
			forcestreambundle("cin_lot_01_planb_3rd_sh020");
			forcestreambundle("cin_lot_01_planb_3rd_sh030");
			forcestreambundle("cin_lot_01_planb_3rd_sh040");
			forcestreambundle("cin_lot_01_planb_3rd_sh050");
			forcestreambundle("cin_lot_01_planb_3rd_sh060");
			forcestreambundle("cin_lot_01_planb_3rd_sh070");
			forcestreambundle("cin_lot_01_planb_3rd_sh080");
			forcestreambundle("cin_lot_01_planb_3rd_sh090");
			forcestreambundle("cin_lot_01_planb_3rd_sh100");
			forcestreambundle("cin_lot_01_planb_3rd_sh120");
			forcestreambundle("cin_lot_01_planb_3rd_sh130");
			forcestreambundle("cin_lot_01_planb_3rd_sh140");
			forcestreambundle("cin_lot_01_planb_3rd_sh150");
			forcestreambundle("cin_lot_01_planb_3rd_sh160");
			break;
		}
		case 2:
		{
			break;
		}
		case 3:
		{
			forcestreambundle("p7_fxanim_cp_lotus_monitor_security_bundle");
			forcestreambundle("cin_lot_05_01_hack_system_1st_security_station");
			break;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: setup_skiptos
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xFA5A23DF
	Offset: 0x13F0
	Size: 0x414
	Parameters: 0
	Flags: Linked
*/
function setup_skiptos()
{
	skipto::add("plan_b", &skipto_init, "Plan B");
	skipto::add("start_the_riots", &start_the_riots, "Start the Riots");
	skipto::add("general_hakim", &general_hakim, "General Hakim");
	skipto::add("apartments", &skipto_init, "Apartments");
	skipto::add("atrium_battle", &atrium_battle, "Atrium Battle");
	skipto::add("to_security_station", &to_security_station, "To Security Station");
	skipto::add("hack_the_system", &skipto_init, "Hack the System");
	skipto::add("prometheus_otr", &skipto_init, "Prometheus OTR");
	skipto::add("vtol_hallway", &skipto_init, "VTOL Hallway");
	skipto::add("mobile_shop_ride2", &skipto_init, "Mobile Shop Ride 2");
	skipto::add("to_detention_center3", &skipto_init, "Get to the Detention Center");
	skipto::add("to_detention_center4", &skipto_init, "Get to the Detention Center");
	skipto::add("detention_center", &skipto_init, "Detention Center");
	skipto::add("stand_down", &skipto_init, "Stand Down");
	skipto::add("pursuit", &skipto_init, "Pursuit");
	skipto::add("sky_bridge", &skipto_init);
	skipto::add("tower_2_ascent", &skipto_init);
	skipto::add("minigun_platform", &skipto_init);
	skipto::add("platform_fall", &skipto_init);
	skipto::add("hunter", &skipto_init);
	skipto::add("prometheus_intro", &skipto_init);
	skipto::add("boss_battle", &skipto_init);
	skipto::add("old_friend", &skipto_init);
}

/*
	Name: skipto_init
	Namespace: cp_mi_cairo_lotus
	Checksum: 0x94D723D
	Offset: 0x1810
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function skipto_init(str_objective, b_starting)
{
}

/*
	Name: start_the_riots
	Namespace: cp_mi_cairo_lotus
	Checksum: 0x5402AD65
	Offset: 0x1830
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function start_the_riots(str_objective, b_starting)
{
	level thread scene::play("crowds_early", "script_noteworthy");
	level thread scene::play("crowds_hakim", "script_noteworthy");
}

/*
	Name: general_hakim
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xECB68DC2
	Offset: 0x18A8
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function general_hakim(str_objective, b_starting)
{
	if(b_starting)
	{
		level thread scene::play("crowds_hakim", "script_noteworthy");
	}
	level thread scene::stop("crowds_early", "script_noteworthy");
	level thread scene::play("crowds_atrium", "script_noteworthy");
}

/*
	Name: function_a24b1d9f
	Namespace: cp_mi_cairo_lotus
	Checksum: 0x87BE6775
	Offset: 0x1948
	Size: 0x2B2
	Parameters: 7
	Flags: Linked
*/
function function_a24b1d9f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level scene::stop("crowds_atrium", "script_noteworthy");
	level scene::stop("cin_lot_03_01_hakim_crowd_riot");
	a_scriptbundles = struct::get_array("crowds_hakim", "script_noteworthy");
	foreach(scriptbundle in a_scriptbundles)
	{
		if(scriptbundle.script_string !== "do_not_swap")
		{
			scriptbundle scene::stop();
			s_scene = struct::spawn(scriptbundle.origin, scriptbundle.angles);
			s_scene thread scene::play("cin_lot_03_01_hakim_crowd_riot");
		}
	}
	a_scriptbundles = struct::get_array("crowds_atrium", "script_noteworthy");
	foreach(scriptbundle in a_scriptbundles)
	{
		s_scene = struct::spawn(scriptbundle.origin, scriptbundle.angles);
		n_delay = randomfloat(10);
		s_scene thread util::delay(n_delay, undefined, &scene::play, "cin_lot_03_01_hakim_crowd_riot");
	}
}

/*
	Name: function_a24774f1
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xEC09DDAF
	Offset: 0x1C08
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function function_a24774f1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level scene::stop("crowds_atrium", "script_noteworthy");
	level scene::stop("crowds_mobile_shop_1", "script_noteworthy");
	level scene::stop("crowds_hakim", "script_noteworthy");
	level scene::stop("crowds_to_security_station", "script_noteworthy");
	level scene::stop("cin_lot_03_01_hakim_crowd_riot");
}

/*
	Name: atrium_battle
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xA09412DF
	Offset: 0x1D10
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function atrium_battle(str_objective, b_starting)
{
	if(b_starting)
	{
		level thread scene::play("crowds_atrium", "script_noteworthy");
		level thread scene::play("crowds_hakim", "script_noteworthy");
	}
	level thread scene::play("crowds_mobile_shop_1", "script_noteworthy");
}

/*
	Name: trig_mobile_shop_1_final_ascent
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xD42A4FB6
	Offset: 0x1DB0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function trig_mobile_shop_1_final_ascent(trigplayer)
{
	level thread scene::play("crowds_to_security_station", "script_noteworthy");
	level thread scene::stop("crowds_hakim", "script_noteworthy");
	level thread scene::stop("crowds_atrium", "script_noteworthy");
}

/*
	Name: to_security_station
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xFCE688B3
	Offset: 0x1E40
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function to_security_station(str_objective, b_starting)
{
	if(b_starting)
	{
		level thread scene::play("crowds_to_security_station", "script_noteworthy");
		level thread scene::stop("crowds_hakim", "script_noteworthy");
		level thread scene::stop("crowds_atrium", "script_noteworthy");
	}
}

/*
	Name: function_579de1bd
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xCAC3E820
	Offset: 0x1EE0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_579de1bd(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	level thread scene::init("p7_fxanim_cp_lotus_vents_bundle");
}

/*
	Name: function_42adde46
	Namespace: cp_mi_cairo_lotus
	Checksum: 0xA9E267C
	Offset: 0x1F48
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_42adde46(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	if(n_val_new)
	{
		level thread scene::play("p7_fxanim_cp_lotus_vents_bundle");
		level thread scene::play("p7_fxanim_gp_trash_paper_burst_up_01_bundle");
	}
}

