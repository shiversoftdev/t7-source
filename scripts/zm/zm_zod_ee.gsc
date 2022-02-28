// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\margwa;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\music_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_altbody;
#using scripts\zm\_zm_altbody_beast;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod;
#using scripts\zm\zm_zod_craftables;
#using scripts\zm\zm_zod_defend_areas;
#using scripts\zm\zm_zod_margwa;
#using scripts\zm\zm_zod_pods;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_quest_vo;
#using scripts\zm\zm_zod_shadowman;
#using scripts\zm\zm_zod_sword_quest;
#using scripts\zm\zm_zod_util;
#using scripts\zm\zm_zod_vo;

#using_animtree("generic");

#namespace zm_zod_ee;

/*
	Name: __init__sytem__
	Namespace: zm_zod_ee
	Checksum: 0x13EF71A3
	Offset: 0x11C0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_ee", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_ee
	Checksum: 0x167F4971
	Offset: 0x1200
	Size: 0x7D4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	n_bits = getminbitcountfornum(5);
	clientfield::register("world", "ee_quest_state", 1, n_bits, "int");
	n_bits = getminbitcountfornum(6);
	clientfield::register("world", "ee_totem_state", 1, n_bits, "int");
	n_bits = getminbitcountfornum(10);
	clientfield::register("world", "ee_keeper_boxer_state", 1, n_bits, "int");
	clientfield::register("world", "ee_keeper_detective_state", 1, n_bits, "int");
	clientfield::register("world", "ee_keeper_femme_state", 1, n_bits, "int");
	clientfield::register("world", "ee_keeper_magician_state", 1, n_bits, "int");
	clientfield::register("world", "ee_shadowman_battle_active", 1, 1, "int");
	clientfield::register("scriptmover", "near_apothigod_active", 1, 1, "int");
	clientfield::register("scriptmover", "far_apothigod_active", 1, 1, "int");
	clientfield::register("scriptmover", "near_apothigod_roar", 1, 1, "counter");
	clientfield::register("scriptmover", "far_apothigod_roar", 1, 1, "counter");
	clientfield::register("scriptmover", "apothigod_death", 1, 1, "counter");
	n_bits = getminbitcountfornum(5);
	clientfield::register("world", "ee_superworm_state", 1, n_bits, "int");
	n_bits = getminbitcountfornum(3);
	clientfield::register("world", "ee_keeper_beam_state", 1, n_bits, "int");
	clientfield::register("world", "ee_final_boss_shields", 1, 1, "int");
	clientfield::register("toplayer", "ee_final_boss_attack_tell", 1, 1, "int");
	clientfield::register("scriptmover", "ee_rail_electricity_state", 1, 1, "int");
	clientfield::register("world", "sndEndIGC", 1, 1, "int");
	var_9eb45ed3 = array("boxer", "detective", "femme", "magician");
	level flag::init("ee_begin");
	level flag::init("ee_book");
	foreach(str_charname in var_9eb45ed3)
	{
		level flag::init(("ee_keeper_" + str_charname) + "_resurrected");
		level flag::init(("ee_keeper_" + str_charname) + "_armed");
	}
	level flag::init("ee_boss_started");
	level flag::init("ee_boss_defeated");
	level flag::init("ee_boss_vulnerable");
	for(i = 1; i < 4; i++)
	{
		level flag::init("ee_district_rail_electrified_" + i);
	}
	for(i = 0; i < 3; i++)
	{
		level flag::init("ee_final_boss_keeper_electricity_" + i);
	}
	level flag::init("ee_superworm_present");
	level flag::init("ee_final_boss_beam_active");
	level flag::init("ee_final_boss_defeated");
	level flag::init("ee_final_boss_midattack");
	level flag::init("ee_final_boss_staggered");
	level flag::init("ee_complete");
	level flag::init("ee_ending_flash");
	level flag::init("ee_ending_fade");
	level flag::init("totem_placed");
	level._effect["ee_quest_book_mist"] = "zombie/fx_ee_book_mist_zod_zmb";
	level._effect["ee_quest_keeper_shocked"] = "zombie/fx_tesla_shock_zmb";
	/#
		level thread function_80d91769();
	#/
}

/*
	Name: on_player_connect
	Namespace: zm_zod_ee
	Checksum: 0x99EC1590
	Offset: 0x19E0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: on_player_spawned
	Namespace: zm_zod_ee
	Checksum: 0x99EC1590
	Offset: 0x19F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: function_7a1d4697
	Namespace: zm_zod_ee
	Checksum: 0x534CDBB2
	Offset: 0x1A00
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_7a1d4697()
{
	self notify(#"hash_7a1d4697");
	self endon(#"hash_7a1d4697");
	/#
		iprintlnbold("");
	#/
}

/*
	Name: function_189ed812
	Namespace: zm_zod_ee
	Checksum: 0x1F05752C
	Offset: 0x1A48
	Size: 0x23E
	Parameters: 0
	Flags: Linked
*/
function function_189ed812()
{
	callback::on_connect(&function_7a1d4697);
	function_1b6ee215();
	level flag::wait_till("ritual_pap_complete");
	function_8a05e65();
	level flag::wait_till("ee_begin");
	ee_begin();
	function_2e77f7bf();
	function_db49b939();
	players = level.players;
	if(players.size === 4 || (isdefined(level.var_421ff75e) && level.var_421ff75e))
	{
		level clientfield::set("ee_quest_state", 3);
		for(i = 1; i < 5; i++)
		{
			str_charname = function_d93f551b(i);
			var_91341fca = ("ee_keeper_" + str_charname) + "_state";
			level clientfield::set(var_91341fca, 8);
			wait(0.1);
		}
		function_db8d1f6e();
		ee_ending();
	}
	else
	{
		level clientfield::set("ee_quest_state", 2);
	}
	players = level.activeplayers;
	for(i = 0; i < players.size; i++)
	{
		players[i] zm_zod_sword::give_sword(2, 1);
	}
}

/*
	Name: function_1b6ee215
	Namespace: zm_zod_ee
	Checksum: 0xD04177B5
	Offset: 0x1C90
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_1b6ee215()
{
	var_501cba6a = getent("ee_book", "targetname");
	var_501cba6a ghost();
	function_c3466d96(0);
	level.var_b94f6d7a = struct::get_array("ee_totem_leyline", "targetname");
}

/*
	Name: function_c3466d96
	Namespace: zm_zod_ee
	Checksum: 0xFB539B84
	Offset: 0x1D20
	Size: 0x22C
	Parameters: 1
	Flags: Linked
*/
function function_c3466d96(b_on)
{
	if(!isdefined(level.var_76c101df))
	{
		level.var_76c101df = [];
	}
	if(b_on)
	{
		for(i = 0; i < 3; i++)
		{
			str_targetname = "ee_apothigod_keeper_clip_" + i;
			var_4fafa709 = struct::get(str_targetname, "targetname");
			mdl_clip = spawn("script_model", var_4fafa709.origin);
			mdl_clip setmodel("collision_clip_zod_keeper_32x32x128");
			mdl_clip.origin = var_4fafa709.origin + vectorscale((0, 0, 1), 48);
			mdl_clip.angles = var_4fafa709.angles;
			if(!isdefined(level.var_76c101df))
			{
				level.var_76c101df = [];
			}
			else if(!isarray(level.var_76c101df))
			{
				level.var_76c101df = array(level.var_76c101df);
			}
			level.var_76c101df[level.var_76c101df.size] = mdl_clip;
		}
	}
	else
	{
		foreach(mdl_clip in level.var_76c101df)
		{
			mdl_clip delete();
		}
		level.var_76c101df = [];
	}
}

/*
	Name: function_8a05e65
	Namespace: zm_zod_ee
	Checksum: 0x92E24728
	Offset: 0x1F58
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_8a05e65()
{
	var_ad91cbf7 = 0;
	while(!var_ad91cbf7)
	{
		if(isdefined(level.var_421ff75e) && level.var_421ff75e)
		{
			return;
		}
		var_ad91cbf7 = 1;
		players = level.activeplayers;
		for(i = 0; i < players.size; i++)
		{
			if(players[i] zm_zod_sword::has_sword(2) === 0)
			{
				var_ad91cbf7 = 0;
			}
		}
		wait(1);
	}
	level flag::set("ee_begin");
}

/*
	Name: ee_begin
	Namespace: zm_zod_ee
	Checksum: 0x9E42863B
	Offset: 0x2038
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function ee_begin()
{
	var_501cba6a = getent("ee_book", "targetname");
	e_deletable_spawn_point = spawn("script_model", var_501cba6a.origin);
	e_deletable_spawn_point setmodel("tag_origin");
	e_deletable_spawn_point.origin = var_501cba6a.origin;
	e_deletable_spawn_point.angles = var_501cba6a.angles;
	var_61835890 = playfxontag(level._effect["ee_quest_book_mist"], e_deletable_spawn_point, "tag_origin");
	wait(1.5);
	var_501cba6a show();
	wait(1.5);
	e_deletable_spawn_point delete();
	level thread function_e6341733(var_501cba6a);
	level flag::wait_till("ee_book");
}

/*
	Name: function_2e77f7bf
	Namespace: zm_zod_ee
	Checksum: 0x3B738507
	Offset: 0x21A8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_2e77f7bf()
{
	level.var_f47099f2 = 0;
	level.var_e59fb2 = function_e4f61654();
	var_6aaeecbc = [];
	for(i = 1; i <= 4; i++)
	{
		level thread function_9190a90e(i);
		str_charname = function_d93f551b(i);
		if(!isdefined(var_6aaeecbc))
		{
			var_6aaeecbc = [];
		}
		else if(!isarray(var_6aaeecbc))
		{
			var_6aaeecbc = array(var_6aaeecbc);
		}
		var_6aaeecbc[var_6aaeecbc.size] = ("ee_keeper_" + str_charname) + "_resurrected";
	}
	level flag::wait_till_all(var_6aaeecbc);
}

/*
	Name: function_db49b939
	Namespace: zm_zod_ee
	Checksum: 0xCDF65718
	Offset: 0x22D8
	Size: 0x374
	Parameters: 0
	Flags: Linked
*/
function function_db49b939()
{
	level clientfield::set("ee_quest_state", 1);
	var_9eb45ed3 = array("boxer", "detective", "femme", "magician");
	var_62e5c0fb = [];
	for(i = 0; i < 4; i++)
	{
		str_charname = var_9eb45ed3[i];
		if(!isdefined(var_62e5c0fb))
		{
			var_62e5c0fb = [];
		}
		else if(!isarray(var_62e5c0fb))
		{
			var_62e5c0fb = array(var_62e5c0fb);
		}
		var_62e5c0fb[var_62e5c0fb.size] = ("ee_keeper_" + str_charname) + "_armed";
		function_676d671(i + 1);
	}
	function_1e8f02dd();
	function_f0c43ca0();
	if(level flag::get("ee_boss_defeated"))
	{
		return;
	}
	function_5db6ba34();
	level thread function_7f4562e9();
	level flag::set("ee_boss_started");
	zm_zod_quest::set_ritual_barrier("pap", 1);
	var_a21704fb = [];
	var_a21704fb[0] = spawnstruct();
	var_a21704fb[0].func = &zm_zod_shadowman::function_b4b792ef;
	var_a21704fb[0].probability = 1;
	var_a21704fb[0].n_move_duration = randomfloatrange(6, 12);
	level.var_dbc3a0ef = level thread zm_zod_shadowman::function_f3805c8a("ee_shadowman_8", undefined, var_a21704fb, 6, 12);
	level.var_dbc3a0ef.var_93dad597 clientfield::set("boss_shield_fx", 1);
	level.var_dbc3a0ef.var_93dad597 playsound("zmb_zod_shadfight_shield_up_short");
	level thread function_4bcb6826();
	level thread function_e49d016d();
	level flag::wait_till("ee_boss_defeated");
	zm_zod_quest::set_ritual_barrier("pap", 0);
}

/*
	Name: function_7f4562e9
	Namespace: zm_zod_ee
	Checksum: 0x3D23D7EC
	Offset: 0x2658
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_7f4562e9()
{
	level endon(#"end_game");
	level.musicsystemoverride = 1;
	music::setmusicstate("zod_ee_shadfight");
	level flag::wait_till("ee_boss_defeated");
	music::setmusicstate("none");
	level.musicsystemoverride = 0;
}

/*
	Name: function_f0c43ca0
	Namespace: zm_zod_ee
	Checksum: 0x320C7C1B
	Offset: 0x26D8
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function function_f0c43ca0()
{
	while(true)
	{
		var_c96f65f1 = 1;
		players = level.activeplayers;
		foreach(player in players)
		{
			e_volume = getent("defend_area_volume_pap", "targetname");
			if(!player istouching(e_volume))
			{
				var_c96f65f1 = 0;
			}
			var_96ebfa18 = player zm_zod_sword::has_sword(2);
			if(var_96ebfa18)
			{
				var_c96f65f1 = 0;
			}
			if(level flag::get("ee_boss_defeated"))
			{
				return;
			}
		}
		if(var_c96f65f1)
		{
			for(i = 1; i < 5; i++)
			{
				str_charname = function_d93f551b(i);
				var_91341fca = ("ee_keeper_" + str_charname) + "_state";
				level clientfield::set(var_91341fca, 4);
				level flag::set(("ee_keeper_" + str_charname) + "_armed");
				wait(0.1);
			}
			return;
		}
		wait(0.1);
	}
}

/*
	Name: function_db8d1f6e
	Namespace: zm_zod_ee
	Checksum: 0xCCF12D37
	Offset: 0x2900
	Size: 0x288
	Parameters: 0
	Flags: Linked
*/
function function_db8d1f6e()
{
	mdl_god_far = getent("mdl_god_far", "targetname");
	mdl_god_near = getent("mdl_god_near", "targetname");
	mdl_god_far clientfield::set("far_apothigod_active", 0);
	mdl_god_near clientfield::set("near_apothigod_active", 1);
	mdl_god_far hide();
	mdl_god_near show();
	function_c3466d96(1);
	wait(15);
	level clientfield::set("ee_superworm_state", 3);
	level thread function_43750b40();
	level.var_1f6ca9c8 = 1;
	level.var_1a1d4400 = 1;
	level.var_a6e16eb2 = 4;
	level thread zm_zod_shadowman::function_6ceb834f();
	level thread function_13d06927();
	zm_altbody_beast::function_fd8fb00d(1);
	level clientfield::set("bm_superbeast", 1);
	zm_zod_pods::function_be2abe();
	level thread function_4778e04();
	level thread function_821065e6();
	level thread function_729859d0();
	level thread function_2c9861b9();
	level thread function_533399b1();
	level flag::wait_till("ee_final_boss_defeated");
	function_c3466d96(0);
	cleanup_ai();
	level.var_1f6ca9c8 = 0;
}

/*
	Name: function_43750b40
	Namespace: zm_zod_ee
	Checksum: 0xEE2C7C7F
	Offset: 0x2B90
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_43750b40()
{
	level endon(#"end_game");
	level.musicsystemoverride = 1;
	music::setmusicstate("zod_ee_apothifight");
	level flag::wait_till("ee_final_boss_defeated");
	music::setmusicstate("none");
	level.musicsystemoverride = 0;
	level zm_audio::sndmusicsystem_playstate("zod_endigc_lullaby");
}

/*
	Name: function_13d06927
	Namespace: zm_zod_ee
	Checksum: 0x92D098A4
	Offset: 0x2C30
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_13d06927()
{
	level.disable_nuke_delay_spawning = 1;
	level notify(#"disable_nuke_delay_spawning");
	level flag::clear("spawn_zombies");
	function_5db6ba34();
	level thread function_3fe90552();
	function_986f2374();
}

/*
	Name: function_4778e04
	Namespace: zm_zod_ee
	Checksum: 0xFEC0A48F
	Offset: 0x2CB0
	Size: 0xF2
	Parameters: 0
	Flags: Linked
*/
function function_4778e04()
{
	while(level flag::get("ee_final_boss_defeated") === 0)
	{
		flag::wait_till_clear("ee_final_boss_staggered");
		playsoundatposition("zmb_zod_apothigod_vox_warn_attack", (0, 0, 0));
		mdl_god_near = getent("mdl_god_near", "targetname");
		mdl_god_near clientfield::increment("near_apothigod_roar");
		function_224a2f3e();
		var_88a57214 = randomfloatrange(30, 45);
		wait(var_88a57214);
	}
}

/*
	Name: function_224a2f3e
	Namespace: zm_zod_ee
	Checksum: 0x83C29AE4
	Offset: 0x2DB0
	Size: 0x2D4
	Parameters: 0
	Flags: Linked
*/
function function_224a2f3e()
{
	level endon(#"ee_final_boss_staggered");
	if(level flag::get("ee_final_boss_beam_active"))
	{
		return;
	}
	if(level flag::get("ee_final_boss_midattack"))
	{
		return;
	}
	level flag::set("ee_final_boss_midattack");
	level clientfield::set("ee_final_boss_shields", 1);
	foreach(player in level.activeplayers)
	{
		if(isdefined(zm_utility::is_player_valid(player, 0, 0)) && zm_utility::is_player_valid(player, 0, 0))
		{
			level thread function_5334c072(player);
		}
	}
	wait(15);
	level notify(#"hash_b1c56287");
	level clientfield::set("ee_final_boss_shields", 0);
	foreach(player in level.activeplayers)
	{
		if(isdefined(zm_utility::is_player_valid(player)) && zm_utility::is_player_valid(player) && (isdefined(player.var_884d1375) && player.var_884d1375))
		{
			player thread zm_zod_util::set_rumble_to_player(6);
			player dodamage(player.health * 666, player.origin);
			player clientfield::set_to_player("ee_final_boss_attack_tell", 0);
		}
	}
	level flag::clear("ee_final_boss_midattack");
}

/*
	Name: function_5334c072
	Namespace: zm_zod_ee
	Checksum: 0xC3F6B274
	Offset: 0x3090
	Size: 0x1D8
	Parameters: 1
	Flags: Linked
*/
function function_5334c072(player)
{
	player endon(#"death");
	player endon(#"disconnect");
	player endon(#"bled_out");
	level endon(#"ee_final_boss_staggered");
	player.var_884d1375 = 1;
	player clientfield::set_to_player("ee_final_boss_attack_tell", 1);
	var_dcd4f61a = struct::get_array("final_boss_safepoint", "targetname");
	while(true)
	{
		player.var_884d1375 = 1;
		foreach(var_495730fe in var_dcd4f61a)
		{
			v_player_origin = player getorigin();
			var_e468ad3 = var_495730fe.origin;
			if(isdefined(v_player_origin))
			{
				n_dist_2 = distancesquared(var_e468ad3, v_player_origin);
				if(n_dist_2 <= 9216)
				{
					function_a8621648(player, 1);
					return;
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_a8621648
	Namespace: zm_zod_ee
	Checksum: 0x3ABCF0DC
	Offset: 0x3270
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function function_a8621648(player, var_67e5f9c0 = 1)
{
	player.var_884d1375 = 0;
	player zm_zod_util::set_rumble_to_player(0);
	player clientfield::set_to_player("ee_final_boss_attack_tell", 0);
	if(var_67e5f9c0)
	{
		level thread lui::screen_flash(0.2, 0.5, 1, 0.8, "white");
	}
}

/*
	Name: function_3fe90552
	Namespace: zm_zod_ee
	Checksum: 0x3E012A5F
	Offset: 0x3338
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_3fe90552()
{
	level thread function_9b59ab6();
}

/*
	Name: function_9b59ab6
	Namespace: zm_zod_ee
	Checksum: 0x9681AE8D
	Offset: 0x3360
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_9b59ab6()
{
	level endon(#"ee_final_boss_defeated");
	while(true)
	{
		while(!function_c7c3f7b5(level.var_a6e16eb2))
		{
			wait(1);
		}
		var_225347e1 = zm_zod_margwa::function_8bcb72e9(0);
		if(isdefined(var_225347e1))
		{
			var_225347e1.no_powerups = 1;
			var_225347e1 clientfield::set("supermargwa", 1);
			level thread function_91b5dbe8(var_225347e1);
		}
		wait(9);
	}
}

/*
	Name: function_91c4dc69
	Namespace: zm_zod_ee
	Checksum: 0xDF78DF64
	Offset: 0x3428
	Size: 0x340
	Parameters: 0
	Flags: None
*/
function function_91c4dc69()
{
	level endon(#"ee_final_boss_defeated");
	zombie_utility::ai_calculate_health(level.round_number);
	wait(3);
	while(true)
	{
		var_565450eb = zombie_utility::get_current_zombie_count();
		while(var_565450eb >= 10 || var_565450eb >= (level.players.size * 5))
		{
			wait(randomfloatrange(2, 4));
			var_565450eb = zombie_utility::get_current_zombie_count();
		}
		while(zombie_utility::get_current_actor_count() >= level.zombie_actor_limit)
		{
			zombie_utility::clear_all_corpses();
			wait(0.1);
		}
		zm::run_custom_ai_spawn_checks();
		if(isdefined(level.zombie_spawners))
		{
			if(isdefined(level.use_multiple_spawns) && level.use_multiple_spawns)
			{
				if(isdefined(level.spawner_int) && (isdefined(level.zombie_spawn[level.spawner_int].size) && level.zombie_spawn[level.spawner_int].size))
				{
					spawner = array::random(level.zombie_spawn[level.spawner_int]);
				}
				else
				{
					spawner = array::random(level.zombie_spawners);
				}
			}
			else
			{
				spawner = array::random(level.zombie_spawners);
			}
			ai = zombie_utility::spawn_zombie(spawner, spawner.targetname);
		}
		if(isdefined(ai))
		{
			ai.no_powerups = 1;
			ai.deathpoints_already_given = 1;
			ai.exclude_distance_cleanup_adding_to_total = 1;
			ai.exclude_cleanup_adding_to_total = 1;
			if(ai.zombie_move_speed === "walk")
			{
				ai zombie_utility::set_zombie_run_cycle("run");
			}
			find_flesh_struct_string = "find_flesh";
			ai notify(#"zombie_custom_think_done", find_flesh_struct_string);
			ai ai::set_behavior_attribute("can_juke", 0);
			if(level.zombie_respawns > 0 && level.zombie_vars["zombie_spawn_delay"] > 1)
			{
				wait(1);
			}
			else
			{
				wait(level.zombie_vars["zombie_spawn_delay"]);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_91b5dbe8
	Namespace: zm_zod_ee
	Checksum: 0x182E61D3
	Offset: 0x3770
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_91b5dbe8(var_225347e1)
{
	level endon(#"ee_final_boss_defeated");
	var_225347e1 waittill(#"death");
	v_origin = var_225347e1.origin;
	zm_altbody_beast::function_f6014f2c(v_origin, 3);
	function_224a2f3e();
}

/*
	Name: function_986f2374
	Namespace: zm_zod_ee
	Checksum: 0x7DF950EB
	Offset: 0x37E8
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_986f2374()
{
	switch(level.var_1a1d4400)
	{
		case 0:
		{
			var_87154e15 = 0;
			level.var_a6e16eb2 = 0;
			break;
		}
		case 1:
		{
			var_87154e15 = 1;
			level.var_a6e16eb2 = 4;
			break;
		}
		case 2:
		{
			var_87154e15 = 0.75;
			level.var_a6e16eb2 = 4;
			break;
		}
		case 3:
		{
			var_87154e15 = 0.5;
			level.var_a6e16eb2 = 4;
			break;
		}
	}
	var_c9a88def = struct::get_array("cursetrap_point", "targetname");
	var_96b4af2e = int(var_c9a88def.size * var_87154e15);
	level thread zm_zod_shadowman::function_f38a6a2a(var_96b4af2e);
}

/*
	Name: function_821065e6
	Namespace: zm_zod_ee
	Checksum: 0xEF2326C9
	Offset: 0x3910
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function function_821065e6()
{
	for(i = 1; i < 4; i++)
	{
		level thread function_3bd22f9e(i);
	}
}

/*
	Name: function_3bd22f9e
	Namespace: zm_zod_ee
	Checksum: 0xAFEDE7BF
	Offset: 0x3960
	Size: 0x128
	Parameters: 1
	Flags: Linked
*/
function function_3bd22f9e(var_9a8bfa33)
{
	level endon(#"ee_final_boss_defeated");
	level endon(#"ee_final_boss_staggered");
	var_5dab4912 = "ee_district_rail_electrified_" + var_9a8bfa33;
	var_9440a97c = getent(var_5dab4912, "targetname");
	var_a5fd6c97 = getent(var_9440a97c.target, "targetname");
	var_a5fd6c97 thread zm_altbody_beast::watch_lightning_damage(var_9440a97c);
	level flag::clear(var_5dab4912);
	var_a5fd6c97 clientfield::set("ee_rail_electricity_state", 0);
	while(true)
	{
		var_9440a97c waittill(#"trigger", e_triggerer);
		function_d3b3eb03(var_9a8bfa33);
	}
}

/*
	Name: function_d3b3eb03
	Namespace: zm_zod_ee
	Checksum: 0x8F37320
	Offset: 0x3A90
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_d3b3eb03(var_9a8bfa33)
{
	var_5dab4912 = "ee_district_rail_electrified_" + var_9a8bfa33;
	var_9440a97c = getent(var_5dab4912, "targetname");
	var_a5fd6c97 = getent(var_9440a97c.target, "targetname");
	level flag::set(var_5dab4912);
	var_a5fd6c97 clientfield::set("ee_rail_electricity_state", 1);
	function_61d12305(var_9a8bfa33, 1);
	wait(30);
	function_61d12305(var_9a8bfa33, 0);
	var_a5fd6c97 clientfield::set("ee_rail_electricity_state", 0);
	level flag::clear(var_5dab4912);
}

/*
	Name: function_61d12305
	Namespace: zm_zod_ee
	Checksum: 0x8F99B0C
	Offset: 0x3BC8
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function function_61d12305(var_9a8bfa33, b_on)
{
	function_93ea4183(var_9a8bfa33, b_on);
	str_scenename = function_2589b4ad(var_9a8bfa33);
	if(b_on)
	{
		level thread scene::play(str_scenename);
	}
	else
	{
		level thread scene::stop(str_scenename);
	}
}

/*
	Name: function_2589b4ad
	Namespace: zm_zod_ee
	Checksum: 0x12487CE5
	Offset: 0x3C68
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function function_2589b4ad(var_9a8bfa33)
{
	switch(var_9a8bfa33)
	{
		case 1:
		{
			return "p7_fxanim_zm_zod_train_rail_spark_canal_bundle";
		}
		case 2:
		{
			return "p7_fxanim_zm_zod_train_rail_spark_waterfront_bundle";
		}
		case 3:
		{
			return "p7_fxanim_zm_zod_train_rail_spark_footlight_bundle";
		}
	}
}

/*
	Name: function_93ea4183
	Namespace: zm_zod_ee
	Checksum: 0xEB26015
	Offset: 0x3CC0
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function function_93ea4183(var_9a8bfa33, b_on)
{
	if(b_on)
	{
		showmiscmodels("train_rail_glow_" + var_9a8bfa33);
		hidemiscmodels("train_rail_wet_" + var_9a8bfa33);
	}
	else
	{
		showmiscmodels("train_rail_wet_" + var_9a8bfa33);
		hidemiscmodels("train_rail_glow_" + var_9a8bfa33);
	}
}

/*
	Name: function_378c2b96
	Namespace: zm_zod_ee
	Checksum: 0x3C74B126
	Offset: 0x3D70
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function function_378c2b96()
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		e_player = players[i];
		e_player zm::spectator_respawn_player();
	}
}

/*
	Name: function_729859d0
	Namespace: zm_zod_ee
	Checksum: 0xD48EA130
	Offset: 0x3DF0
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function function_729859d0()
{
	level endon(#"ee_final_boss_defeated");
	level flag::set("ee_superworm_present");
	while(true)
	{
		level.o_zod_train flag::wait_till("moving");
		function_f09f9721();
		level thread function_378c2b96();
		if(level flag::get("ee_final_boss_beam_active") === 0)
		{
			level thread function_c898ab1();
			var_7f207012 = [[ level.o_zod_train ]]->get_players_on_train();
			foreach(var_813273c3 in var_7f207012)
			{
				var_813273c3 thread zm_zod_util::set_rumble_to_player(6, 1);
			}
		}
		level.o_zod_train flag::wait_till_clear("moving");
	}
}

/*
	Name: function_2c9861b9
	Namespace: zm_zod_ee
	Checksum: 0x9BA2F9C3
	Offset: 0x3F80
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function function_2c9861b9()
{
	for(i = 0; i < 3; i++)
	{
		level thread function_f30f87e4(i);
	}
}

/*
	Name: function_f30f87e4
	Namespace: zm_zod_ee
	Checksum: 0x9B7D470A
	Offset: 0x3FD0
	Size: 0x1E8
	Parameters: 1
	Flags: Linked
*/
function function_f30f87e4(n_index)
{
	level notify("ee_final_boss_keeper_electricity_watcher_" + n_index);
	level endon("ee_final_boss_keeper_electricity_watcher_" + n_index);
	level endon(#"ee_final_boss_defeated");
	var_da3dbbdf = level.var_76c101df[n_index];
	var_da3dbbdf endon(#"delete");
	var_da3dbbdf solid();
	var_da3dbbdf setcandamage(1);
	var_da3dbbdf.health = 1000000;
	while(true)
	{
		var_da3dbbdf waittill(#"damage", amount, attacker, direction, point, mod, tagname, modelname, partname, weapon);
		var_da3dbbdf.health = 1000000;
		if(zm_altbody_beast::is_lightning_weapon(weapon) && isdefined(attacker) && amount > 0)
		{
			if(isdefined(attacker))
			{
				attacker notify(#"shockable_shocked");
			}
			level thread function_6774c6fd(var_da3dbbdf);
			level flag::set("ee_final_boss_keeper_electricity_" + n_index);
			wait(5);
			level flag::clear("ee_final_boss_keeper_electricity_" + n_index);
		}
	}
}

/*
	Name: function_6774c6fd
	Namespace: zm_zod_ee
	Checksum: 0xBD0BC072
	Offset: 0x41C0
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_6774c6fd(var_da3dbbdf)
{
	fx_ent = spawn("script_model", var_da3dbbdf.origin);
	fx_ent setmodel("tag_origin");
	fx_ent.angles = var_da3dbbdf.angles;
	playfxontag(level._effect["ee_quest_keeper_shocked"], fx_ent, "tag_origin");
	fx_ent playsound("zmb_zod_keeper_charge_up");
	fx_ent playloopsound("zmb_zod_keeper_charge_lp", 1);
	wait(5);
	fx_ent playsound("zmb_zod_keeper_charge_down");
	fx_ent delete();
}

/*
	Name: function_c898ab1
	Namespace: zm_zod_ee
	Checksum: 0x4E36F343
	Offset: 0x42F8
	Size: 0x13C
	Parameters: 1
	Flags: Linked
*/
function function_c898ab1(var_a5322c01)
{
	level notify(#"hash_c898ab1");
	level endon(#"hash_c898ab1");
	level clientfield::set("ee_superworm_state", 2);
	var_a9f994a9 = struct::get("ee_apothigod_gateworm_junction", "targetname");
	earthquake(0.25, 0.3, var_a9f994a9.origin, 150);
	level flag::clear("ee_superworm_present");
	wait(10);
	while(level flag::get("ee_final_boss_staggered"))
	{
		wait(0.1);
	}
	level clientfield::set("ee_superworm_state", 3);
	level flag::set("ee_superworm_present");
}

/*
	Name: function_f09f9721
	Namespace: zm_zod_ee
	Checksum: 0x12318414
	Offset: 0x4440
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_f09f9721()
{
	level endon(#"hash_c898ab1");
	var_4843dc70 = [[ level.o_zod_train ]]->get_train_vehicle();
	var_a9f994a9 = struct::get("ee_apothigod_gateworm_junction", "targetname");
	str_station = [[ level.o_zod_train ]]->get_current_station();
	switch(str_station)
	{
		case "slums":
		{
			dist2 = 262144;
			break;
		}
		case "theater":
		{
			dist2 = 262144;
			break;
		}
		case "canal":
		{
			dist2 = 262144;
			break;
		}
	}
	while(true)
	{
		if(distance2dsquared(var_4843dc70.origin, var_a9f994a9.origin) <= dist2)
		{
			return;
		}
		wait(0.1);
	}
}

/*
	Name: function_c5f8b004
	Namespace: zm_zod_ee
	Checksum: 0xA6C0A53A
	Offset: 0x4570
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function function_c5f8b004(var_67e5f9c0 = 1)
{
	players = level.activeplayers;
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i]))
		{
			function_a8621648(players[i], var_67e5f9c0);
		}
	}
}

/*
	Name: function_533399b1
	Namespace: zm_zod_ee
	Checksum: 0x7110BC46
	Offset: 0x4608
	Size: 0x378
	Parameters: 0
	Flags: Linked
*/
function function_533399b1()
{
	while(level flag::get("ee_final_boss_defeated") === 0)
	{
		var_b4813f3d = array("ee_district_rail_electrified_1", "ee_district_rail_electrified_2", "ee_district_rail_electrified_3", "ee_final_boss_keeper_electricity_0", "ee_final_boss_keeper_electricity_1", "ee_final_boss_keeper_electricity_2");
		level flag::wait_till_all(var_b4813f3d);
		function_61d12305(4, 1);
		level flag::set("ee_final_boss_beam_active");
		if(level flag::get("ee_superworm_present"))
		{
			level clientfield::set("ee_keeper_beam_state", 1);
			level clientfield::set("ee_superworm_state", 4);
		}
		else
		{
			level flag::set("ee_final_boss_staggered");
			function_c5f8b004(1);
			level clientfield::set("rain_state", 1);
			level thread function_19076f5e();
			cleanup_ai();
			level notify(#"debug_pod_spawn");
			level clientfield::set("ee_keeper_beam_state", 2);
			level.var_1a1d4400--;
		}
		if(level.var_1a1d4400 === 0)
		{
			level flag::set("ee_final_boss_defeated");
		}
		else
		{
			players = level.activeplayers;
			foreach(player in players)
			{
				player thread function_d26c80f1();
			}
			wait(9);
			level clientfield::set("ee_keeper_beam_state", 0);
			level flag::clear("ee_final_boss_beam_active");
			function_986f2374();
			level thread function_821065e6();
		}
		function_61d12305(4, 0);
		level clientfield::set("rain_state", 0);
		level flag::clear("ee_final_boss_staggered");
	}
}

/*
	Name: function_19076f5e
	Namespace: zm_zod_ee
	Checksum: 0xE4226B95
	Offset: 0x4988
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_19076f5e()
{
	if(level.var_1a1d4400 == 3)
	{
		alias = "zmb_zod_beam_fire_success_1";
	}
	else
	{
		if(level.var_1a1d4400 == 2)
		{
			alias = "zmb_zod_beam_fire_success_2";
		}
		else if(level.var_1a1d4400 == 1)
		{
			alias = "zmb_zod_beam_fire_success_3";
			level clientfield::set("sndEndIGC", 1);
		}
	}
	playsoundatposition(alias, (0, 0, 0));
}

/*
	Name: function_d26c80f1
	Namespace: zm_zod_ee
	Checksum: 0x16C6EDFC
	Offset: 0x4A38
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_d26c80f1()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"bled_out");
	self zm_zod_util::set_rumble_to_player(5);
	earthquake(0.333, 7, self.origin, 1000);
	wait(7);
	if(!isdefined(self))
	{
		return;
	}
	self zm_zod_util::set_rumble_to_player(6);
}

/*
	Name: function_3f5c6609
	Namespace: zm_zod_ee
	Checksum: 0x62BA4C26
	Offset: 0x4AD8
	Size: 0xB2
	Parameters: 0
	Flags: None
*/
function function_3f5c6609()
{
	while(true)
	{
		players = level.activeplayers;
		foreach(player in players)
		{
			if(player.origin.z > 0)
			{
				return;
			}
		}
	}
}

/*
	Name: ee_ending
	Namespace: zm_zod_ee
	Checksum: 0x446CD05
	Offset: 0x4B98
	Size: 0x438
	Parameters: 0
	Flags: Linked
*/
function ee_ending()
{
	scene::init("cin_zod_vign_summoning_key");
	level clientfield::set("ee_quest_state", 4);
	zm_zod_vo::function_218256bd(1);
	scene::add_scene_func("cin_zod_vign_summoning_key", &function_e186ed49);
	level thread zm_zod_shadowman::function_f38a6a2a(0);
	level notify(#"hash_223edfde");
	function_c5f8b004(0);
	level clientfield::set("ee_final_boss_shields", 0);
	level notify(#"hash_c898ab1");
	level clientfield::set("ee_superworm_state", 0);
	level flag::clear("spawn_zombies");
	function_5db6ba34();
	cleanup_ai(1);
	wait(5);
	foreach(player in level.activeplayers)
	{
		player zm_altbody_beast::player_take_mana(1);
		player.play_scene_transition_effect = 1;
	}
	wait(2);
	mdl_god_near = getent("mdl_god_near", "targetname");
	mdl_god_near clientfield::increment("apothigod_death");
	level clientfield::set("portal_state_ending", 1);
	scene::play("cin_zod_vign_summoning_key");
	level clientfield::set("portal_state_ending", 0);
	level clientfield::set("sndEndIGC", 0);
	function_5091df99();
	level clientfield::set("bm_superbeast", 0);
	level clientfield::set("ee_keeper_beam_state", 0);
	level flag::clear("ee_final_boss_beam_active");
	zm_altbody_beast::function_fd8fb00d(0);
	wait(15);
	foreach(player in level.players)
	{
		player zm_stats::increment_challenge_stat("DARKOPS_ZOD_EE");
		player zm_stats::increment_challenge_stat("DARKOPS_ZOD_SUPER_EE");
	}
	zm_zod_vo::function_218256bd(0);
	level flag::set("spawn_zombies");
	level.disable_nuke_delay_spawning = 0;
}

/*
	Name: function_e186ed49
	Namespace: zm_zod_ee
	Checksum: 0xCF85FDB3
	Offset: 0x4FD8
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function function_e186ed49(a_ents)
{
	a_ents["archon"] waittill(#"start_fade");
	level thread lui::screen_flash(1, 1.5, 0.5, 1, "white");
	playsoundatposition("zmb_zod_endigc_whitescreen", (0, 0, 0));
	wait(1);
	for(i = 1; i < 5; i++)
	{
		str_charname = function_d93f551b(i);
		var_91341fca = ("ee_keeper_" + str_charname) + "_state";
		level clientfield::set(var_91341fca, 0);
	}
	level clientfield::set("ee_keeper_beam_state", 0);
	a_ents["archon"] waittill(#"start_fade");
	level thread lui::screen_flash(0.5, 1, 0.5, 1, "black");
	level flag::set("ee_complete");
}

/*
	Name: function_5091df99
	Namespace: zm_zod_ee
	Checksum: 0xE5959E1D
	Offset: 0x5190
	Size: 0x106
	Parameters: 0
	Flags: Linked
*/
function function_5091df99()
{
	if(level.players.size <= 1)
	{
		return;
	}
	a_spots = [];
	for(i = 0; i < level.players.size; i++)
	{
		a_spots[i] = struct::get("ending_igc_exit_" + i);
		level.players[i] setorigin(a_spots[i].origin);
		if(isdefined(a_spots[i].angles))
		{
			level.players[i] setplayerangles(a_spots[i].angles);
		}
	}
}

/*
	Name: function_e6341733
	Namespace: zm_zod_ee
	Checksum: 0x46EEC941
	Offset: 0x52A0
	Size: 0x19C
	Parameters: 1
	Flags: Linked
*/
function function_e6341733(s_loc)
{
	width = 128;
	height = 128;
	length = 128;
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = width;
	s_loc.unitrigger_stub.script_height = height;
	s_loc.unitrigger_stub.script_length = length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_19cf5463;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_e30b3505);
}

/*
	Name: function_19cf5463
	Namespace: zm_zod_ee
	Checksum: 0x360EC0FD
	Offset: 0x5448
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function function_19cf5463(player)
{
	b_is_invis = isdefined(player.beastmode) && player.beastmode || level flag::get("ee_book");
	self setinvisibletoplayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_e30b3505
	Namespace: zm_zod_ee
	Checksum: 0xCDBB1B49
	Offset: 0x54D0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_e30b3505()
{
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
		level thread function_bddd53dc(self.stub, player);
		break;
	}
}

/*
	Name: function_bddd53dc
	Namespace: zm_zod_ee
	Checksum: 0xE32550C2
	Offset: 0x5580
	Size: 0x1E4
	Parameters: 2
	Flags: Linked
*/
function function_bddd53dc(trig_stub, player)
{
	/#
		iprintlnbold("");
	#/
	var_501cba6a = getent("ee_book", "targetname");
	var_501cba6a moveto(var_501cba6a.origin + vectorscale((0, 0, 1), 48), 3, 1, 1);
	wait(3);
	playfxontag(level._effect["ee_quest_book_mist"], var_501cba6a, "tag_origin");
	var_501cba6a playsound("zmb_ee_main_book_aflame");
	var_501cba6a playloopsound("zmb_ee_main_book_aflame_lp", 1);
	level flag::set("ee_book");
	level clientfield::set("ee_keeper_boxer_state", 1);
	level clientfield::set("ee_keeper_detective_state", 1);
	level clientfield::set("ee_keeper_femme_state", 1);
	level clientfield::set("ee_keeper_magician_state", 1);
	level thread function_f75d6374();
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_f75d6374
	Namespace: zm_zod_ee
	Checksum: 0xB230D123
	Offset: 0x5770
	Size: 0x2AE
	Parameters: 0
	Flags: Linked
*/
function function_f75d6374()
{
	var_f59a8cd1 = getent("ee_totem_hanging", "targetname");
	s_loc = struct::get("ee_totem_landed_position", "targetname");
	var_f59a8cd1 moveto(s_loc.origin, 3, 1, 1);
	wait(3);
	level clientfield::set("ee_totem_state", 1);
	var_f59a8cd1 clientfield::set("totem_state_fx", 1);
	width = 128;
	height = 128;
	length = 128;
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = width;
	s_loc.unitrigger_stub.script_height = height;
	s_loc.unitrigger_stub.script_length = length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_6bd33d28;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_f3d23e2c);
	if(!isdefined(level.var_f86952c7))
	{
		level.var_f86952c7 = [];
	}
	level.var_f86952c7["totem_landed"] = s_loc.unitrigger_stub;
}

/*
	Name: function_6bd33d28
	Namespace: zm_zod_ee
	Checksum: 0xB9BBB86B
	Offset: 0x5A28
	Size: 0x132
	Parameters: 1
	Flags: Linked
*/
function function_6bd33d28(player)
{
	var_14123bd0 = self.stub.origin;
	var_a18af120 = 0;
	var_39ec9ec2 = level clientfield::get("ee_quest_state");
	if(var_39ec9ec2 == 0)
	{
		var_a18af120 = 1;
	}
	var_ec277adf = 0;
	var_fa9b3019 = level clientfield::get("ee_totem_state");
	if(var_fa9b3019 == 1)
	{
		var_ec277adf = 1;
	}
	b_is_invis = isdefined(player.beastmode) && player.beastmode || !var_a18af120 || !var_ec277adf;
	self setinvisibletoplayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_f3d23e2c
	Namespace: zm_zod_ee
	Checksum: 0x8BD99BB2
	Offset: 0x5B68
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_f3d23e2c()
{
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
		level function_e525a12(0);
		level function_ce4db8c8(player);
		self.stub zm_unitrigger::run_visibility_function_for_all_triggers();
		break;
	}
}

/*
	Name: function_e525a12
	Namespace: zm_zod_ee
	Checksum: 0x868F5F4F
	Offset: 0x5C40
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_e525a12(b_show)
{
	var_f59a8cd1 = getent("ee_totem_hanging", "targetname");
	if(b_show)
	{
		var_f59a8cd1 show();
		var_f59a8cd1 clientfield::set("totem_state_fx", 1);
	}
	else
	{
		var_f59a8cd1 ghost();
		var_f59a8cd1 clientfield::set("totem_state_fx", 0);
	}
}

/*
	Name: function_9190a90e
	Namespace: zm_zod_ee
	Checksum: 0xCD5B89E9
	Offset: 0x5CF8
	Size: 0x208
	Parameters: 1
	Flags: Linked
*/
function function_9190a90e(n_char_index)
{
	str_charname = function_d93f551b(n_char_index);
	str_triggername = "keeper_resurrection_" + str_charname;
	var_e6e52f57 = getent(str_triggername, "targetname");
	while(true)
	{
		var_e6e52f57 waittill(#"trigger", player);
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
		if(isdefined(player.beastmode) && player.beastmode)
		{
			continue;
		}
		var_39ec9ec2 = level clientfield::get("ee_quest_state");
		var_a18af120 = var_39ec9ec2 == 0;
		if(!var_a18af120)
		{
			continue;
		}
		if(!isdefined(player.var_11104075))
		{
			continue;
		}
		var_fa9b3019 = level clientfield::get("ee_totem_state");
		var_27b0f0e4 = level clientfield::get(("ee_keeper_" + str_charname) + "_state");
		if(var_27b0f0e4 == 1 && var_fa9b3019 == 3)
		{
			function_b54f7960(player, n_char_index);
		}
	}
}

/*
	Name: function_d93f551b
	Namespace: zm_zod_ee
	Checksum: 0xC8A99C95
	Offset: 0x5F08
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function function_d93f551b(n_char_index)
{
	switch(n_char_index)
	{
		case 1:
		{
			return "boxer";
		}
		case 2:
		{
			return "detective";
		}
		case 3:
		{
			return "femme";
		}
		case 4:
		{
			return "magician";
		}
	}
}

/*
	Name: function_b54f7960
	Namespace: zm_zod_ee
	Checksum: 0x66CC7FC4
	Offset: 0x5F70
	Size: 0x244
	Parameters: 2
	Flags: Linked
*/
function function_b54f7960(player, n_char_index)
{
	players = level.activeplayers;
	foreach(player in players)
	{
		if(isdefined(player.var_11104075))
		{
			player.var_11104075 delete();
		}
	}
	str_charname = function_d93f551b(n_char_index);
	level clientfield::set(("ee_keeper_" + str_charname) + "_state", 2);
	player playsound("zmb_zod_totem_place");
	wait(5);
	level function_8f4b6b20(n_char_index);
	foreach(var_b9caebb1 in level.var_dc1b8d40)
	{
		arrayremovevalue(level.var_b94f6d7a, var_b9caebb1);
	}
	wait(5);
	s_loc = struct::get("defend_area_" + str_charname);
	level thread zm_powerups::specific_powerup_drop("full_ammo", s_loc.origin);
}

/*
	Name: function_6032557b
	Namespace: zm_zod_ee
	Checksum: 0xBB25DB10
	Offset: 0x61C0
	Size: 0xBC
	Parameters: 2
	Flags: None
*/
function function_6032557b(player, trig_stub)
{
	if(isdefined(trig_stub.var_4cf62d2c))
	{
		trig_stub.var_4cf62d2c clientfield::set("totem_damage_fx", 0);
		trig_stub.var_4cf62d2c delete();
	}
	level flag::clear("totem_placed");
	level notify(#"hash_26f14b55");
	level.var_6e3c8a77 = undefined;
	level thread function_ce4db8c8(player);
}

/*
	Name: function_6f0edfa1
	Namespace: zm_zod_ee
	Checksum: 0x8010185B
	Offset: 0x6288
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_6f0edfa1()
{
	players = level.activeplayers;
	foreach(player in players)
	{
		if(isdefined(player.var_11104075))
		{
			player.var_11104075 delete();
		}
	}
	function_fe26340b();
	level flag::clear("totem_placed");
	level clientfield::set("ee_totem_state", 0);
	level.var_f47099f2 = 0;
	level thread zm_zod_shadowman::function_f38a6a2a(0);
	level thread cleanup_ai(0, 1);
	level thread zm_zod_shadowman::function_e48af0db();
}

/*
	Name: function_3089f820
	Namespace: zm_zod_ee
	Checksum: 0x12A3F8F
	Offset: 0x63F0
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function function_3089f820(var_ee1ff130)
{
	if(level flag::get("totem_placed") === 0)
	{
		return;
	}
	level notify(#"ee_keeper_resurrection_failed");
	level.var_dc1b8d40 = [];
	level function_6f0edfa1();
	if(isdefined(var_ee1ff130))
	{
		str_name = function_d93f551b(var_ee1ff130);
		level clientfield::set(("ee_keeper_" + str_name) + "_state", 1);
	}
	players = level.activeplayers;
	foreach(player in players)
	{
		if(isdefined(player.var_11104075))
		{
			player.var_11104075 delete();
		}
	}
	level function_e525a12(1);
	level clientfield::set("ee_totem_state", 1);
}

/*
	Name: function_5d546ced
	Namespace: zm_zod_ee
	Checksum: 0xB2F72BB8
	Offset: 0x65A8
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_5d546ced(var_ee1ff130)
{
	level notify(#"ee_keeper_resurrection_failed");
	level.var_dc1b8d40 = [];
	level function_6f0edfa1();
	if(isdefined(var_ee1ff130))
	{
		str_name = function_d93f551b(var_ee1ff130);
		level clientfield::set(("ee_keeper_" + str_name) + "_state", 1);
	}
	level function_e525a12(1);
	level clientfield::set("ee_totem_state", 1);
}

/*
	Name: function_8f4b6b20
	Namespace: zm_zod_ee
	Checksum: 0x6CAB457F
	Offset: 0x6680
	Size: 0x17C
	Parameters: 2
	Flags: Linked
*/
function function_8f4b6b20(var_ee1ff130, var_dcdf1cd5 = 0)
{
	level function_6f0edfa1();
	level notify(#"ee_keeper_resurrected");
	str_charname = function_d93f551b(var_ee1ff130);
	level clientfield::set(("ee_keeper_" + str_charname) + "_state", 3);
	level flag::set(("ee_keeper_" + str_charname) + "_resurrected");
	if(var_dcdf1cd5)
	{
		level function_e525a12(0);
		level clientfield::set("ee_totem_state", 0);
		return;
	}
	wait(5);
	zm_zod_margwa::function_8bcb72e9(1);
	if(function_832f1b2a() < 4)
	{
		level thread function_e6dd2eaf();
	}
	else
	{
		level.var_f47099f2 = 0;
		level.var_e59fb2 = function_e4f61654();
	}
}

/*
	Name: function_e6dd2eaf
	Namespace: zm_zod_ee
	Checksum: 0xBF54B527
	Offset: 0x6808
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_e6dd2eaf()
{
	level waittill(#"start_of_round");
	level function_e525a12(1);
	level clientfield::set("ee_totem_state", 1);
}

/*
	Name: function_676d671
	Namespace: zm_zod_ee
	Checksum: 0xD7C1891
	Offset: 0x6860
	Size: 0x272
	Parameters: 1
	Flags: Linked
*/
function function_676d671(n_char_index)
{
	width = 128;
	height = 128;
	length = 128;
	str_charname = function_d93f551b(n_char_index);
	s_loc = struct::get("ee_keeper_8_" + (n_char_index - 1), "targetname");
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = width;
	s_loc.unitrigger_stub.script_height = height;
	s_loc.unitrigger_stub.script_length = length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.n_char_index = n_char_index;
	s_loc.unitrigger_stub.str_charname = str_charname;
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_9207a201;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_5eae8cbb);
	if(!isdefined(level.var_f86952c7))
	{
		level.var_f86952c7 = [];
	}
	level.var_f86952c7["boss_1_" + str_charname] = s_loc.unitrigger_stub;
}

/*
	Name: function_9207a201
	Namespace: zm_zod_ee
	Checksum: 0xEFBBAEEB
	Offset: 0x6AE0
	Size: 0x1C2
	Parameters: 1
	Flags: Linked
*/
function function_9207a201(player)
{
	var_91341fca = ("ee_keeper_" + self.stub.str_charname) + "_state";
	var_fe2fb4b9 = level clientfield::get(var_91341fca);
	var_a18af120 = 0;
	var_39ec9ec2 = level clientfield::get("ee_quest_state");
	if(var_39ec9ec2 == 1)
	{
		var_a18af120 = 1;
	}
	var_96ebfa18 = player zm_zod_sword::has_sword(2);
	var_c7fc450f = 0;
	if(var_fe2fb4b9 === 3 && var_96ebfa18)
	{
		var_c7fc450f = 1;
	}
	else if(var_fe2fb4b9 === 6)
	{
		var_c7fc450f = 1;
	}
	b_superbeastmode = level clientfield::get("bm_superbeast");
	b_is_invis = isdefined(player.beastmode) && player.beastmode && !b_superbeastmode || !var_a18af120 || !var_c7fc450f;
	self setinvisibletoplayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_5eae8cbb
	Namespace: zm_zod_ee
	Checksum: 0x27558AC1
	Offset: 0x6CB0
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function function_5eae8cbb()
{
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
		var_27b0f0e4 = level clientfield::get(("ee_keeper_" + self.stub.str_charname) + "_state");
		if(var_27b0f0e4 === 3)
		{
			player zm_zod_sword::take_sword();
			level clientfield::set(("ee_keeper_" + self.stub.str_charname) + "_state", 4);
			level flag::set(("ee_keeper_" + self.stub.str_charname) + "_armed");
		}
		else if(var_27b0f0e4 === 6)
		{
			level clientfield::set(("ee_keeper_" + self.stub.str_charname) + "_state", 4);
			level flag::set(("ee_keeper_" + self.stub.str_charname) + "_armed");
		}
		self.stub zm_unitrigger::run_visibility_function_for_all_triggers();
		break;
	}
}

/*
	Name: function_4bcb6826
	Namespace: zm_zod_ee
	Checksum: 0xEF06B011
	Offset: 0x6EA8
	Size: 0x4C8
	Parameters: 0
	Flags: Linked
*/
function function_4bcb6826()
{
	level endon(#"ee_boss_defeated");
	var_9eb45ed3 = array("boxer", "detective", "femme", "magician");
	level.var_df5409ea = 9;
	while(true)
	{
		var_a74ccb30 = 1;
		foreach(str_charname in var_9eb45ed3)
		{
			var_587a4446 = level clientfield::get(("ee_keeper_" + str_charname) + "_state");
			if(var_587a4446 !== 4)
			{
				var_a74ccb30 = 0;
			}
		}
		if(!var_a74ccb30)
		{
			wait(0.1);
			continue;
		}
		wait(3);
		foreach(str_charname in var_9eb45ed3)
		{
			level clientfield::set(("ee_keeper_" + str_charname) + "_state", 5);
		}
		level.var_dbc3a0ef.var_93dad597 playsound("zmb_zod_shadfight_shield_down");
		wait(3);
		level.var_dbc3a0ef.var_93dad597 clientfield::set("boss_shield_fx", 0);
		level flag::set("ee_boss_vulnerable");
		var_e6fb7eb3 = randomintrange(0, 4);
		function_e59c5246(var_e6fb7eb3);
		level thread function_c188d0b0();
		wait(level.var_df5409ea);
		level flag::clear("ee_boss_vulnerable");
		level.var_dbc3a0ef.var_93dad597 clientfield::set("boss_shield_fx", 1);
		level notify(#"hash_b6c7fd80");
		level.var_dbc3a0ef.n_script_int = 0;
		a_s_spawnpoints = struct::get_array("ee_shadowman_8", "targetname");
		a_s_spawnpoints = array::filter(a_s_spawnpoints, 0, &zm_zod_shadowman::function_726d4cc4, 0);
		level.var_dbc3a0ef.s_spawnpoint = a_s_spawnpoints[0];
		zm_zod_shadowman::function_284b1884(level.var_dbc3a0ef, level.var_dbc3a0ef.s_spawnpoint, 0.1);
		level.var_dbc3a0ef zm_zod_shadowman::function_a3821eb5(0.1, 4);
		foreach(str_charname in var_9eb45ed3)
		{
			level clientfield::set(("ee_keeper_" + str_charname) + "_state", 6);
		}
		level.var_df5409ea = level.var_df5409ea + 2;
		level.var_dbc3a0ef thread zm_zod_shadowman::function_b6c7fd80();
		zm_zod_margwa::function_8bcb72e9(1);
	}
}

/*
	Name: function_c188d0b0
	Namespace: zm_zod_ee
	Checksum: 0xDB778096
	Offset: 0x7378
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_c188d0b0()
{
	wait(level.var_df5409ea - 3);
	if(isdefined(level.var_dbc3a0ef.var_93dad597))
	{
		level.var_dbc3a0ef.var_93dad597 playsound("zmb_zod_shadfight_shield_up");
	}
}

/*
	Name: function_e59c5246
	Namespace: zm_zod_ee
	Checksum: 0x683EEA57
	Offset: 0x73D8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_e59c5246(var_e6fb7eb3)
{
	var_10bc5bc2 = struct::get("ee_shadowman_boss_maxammo_" + var_e6fb7eb3);
	level thread zm_powerups::specific_powerup_drop("full_ammo", var_10bc5bc2.origin);
}

/*
	Name: function_e49d016d
	Namespace: zm_zod_ee
	Checksum: 0x2ADAC387
	Offset: 0x7448
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_e49d016d()
{
	level endon(#"ee_boss_defeated");
	level flag::wait_till("ee_boss_vulnerable");
	level flag::wait_till_clear("ee_boss_vulnerable");
	level thread function_877ea350();
}

/*
	Name: function_1e8f02dd
	Namespace: zm_zod_ee
	Checksum: 0xF0B75FA7
	Offset: 0x74B8
	Size: 0x216
	Parameters: 0
	Flags: Linked
*/
function function_1e8f02dd()
{
	width = 128;
	height = 128;
	length = 128;
	s_loc = struct::get("defend_area_pap", "targetname");
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = width;
	s_loc.unitrigger_stub.script_height = height;
	s_loc.unitrigger_stub.script_length = length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.hint_string = &"";
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_a683d8ab;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_96ac6f7d);
	if(!isdefined(level.var_f86952c7))
	{
		level.var_f86952c7 = [];
	}
	level.var_f86952c7["boss_1_victory"] = s_loc.unitrigger_stub;
}

/*
	Name: function_a683d8ab
	Namespace: zm_zod_ee
	Checksum: 0x2974351D
	Offset: 0x76D8
	Size: 0x102
	Parameters: 1
	Flags: Linked
*/
function function_a683d8ab(player)
{
	var_772700c5 = 0;
	if(isdefined(level.var_dbc3a0ef) && level.var_dbc3a0ef.n_script_int === 8)
	{
		var_772700c5 = 1;
	}
	var_a18af120 = 0;
	var_39ec9ec2 = level clientfield::get("ee_quest_state");
	if(var_39ec9ec2 == 1)
	{
		var_a18af120 = 1;
	}
	b_is_invis = isdefined(player.beastmode) && player.beastmode || !var_a18af120 || !var_772700c5;
	self setinvisibletoplayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_96ac6f7d
	Namespace: zm_zod_ee
	Checksum: 0x18A930B0
	Offset: 0x77E8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_96ac6f7d()
{
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
		function_3fc4aca5();
		self.stub zm_unitrigger::run_visibility_function_for_all_triggers();
		break;
	}
}

/*
	Name: function_3fc4aca5
	Namespace: zm_zod_ee
	Checksum: 0xD8FCEA62
	Offset: 0x78A0
	Size: 0x1C2
	Parameters: 0
	Flags: Linked
*/
function function_3fc4aca5()
{
	level flag::set("ee_boss_defeated");
	level notify(#"hash_a881e3fa");
	if(isdefined(level.var_dbc3a0ef) && isdefined(level.var_dbc3a0ef.var_93dad597))
	{
		level.var_dbc3a0ef.var_93dad597 delete();
	}
	level thread cleanup_ai(1);
	var_9eb45ed3 = array("boxer", "detective", "femme", "magician");
	foreach(str_charname in var_9eb45ed3)
	{
		if(isdefined(level.var_f86952c7["boss_1_" + str_charname]))
		{
			zm_unitrigger::unregister_unitrigger(level.var_f86952c7["boss_1_" + str_charname]);
		}
		var_91341fca = ("ee_keeper_" + str_charname) + "_state";
		level clientfield::set(var_91341fca, 7);
		wait(0.1);
	}
}

/*
	Name: function_ce4db8c8
	Namespace: zm_zod_ee
	Checksum: 0xBE9ADF92
	Offset: 0x7A70
	Size: 0x204
	Parameters: 1
	Flags: Linked
*/
function function_ce4db8c8(player)
{
	level clientfield::set("ee_totem_state", 2);
	player playsound("zmb_zod_totem_pickup");
	level.var_f47099f2 = 0;
	if(!isdefined(level.var_86557cb0))
	{
		level.var_86557cb0 = 0;
	}
	player.var_11104075 = spawn("script_model", player.origin);
	player.var_11104075 setmodel("t7_zm_zod_keepers_totem");
	player.var_11104075 linkto(player, "tag_stowed_back", (0, 12, -32));
	player.var_11104075 clientfield::set("totem_state_fx", 1);
	foreach(var_b9caebb1 in level.var_b94f6d7a)
	{
		level thread function_fe31ce39(var_b9caebb1);
	}
	level thread zm_zod_shadowman::function_6ceb834f();
	level thread function_57b64f04(player);
	level thread function_4cc29f4f(player);
	level thread function_904cb175();
}

/*
	Name: function_57b64f04
	Namespace: zm_zod_ee
	Checksum: 0x391A0E80
	Offset: 0x7C80
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function function_57b64f04(player)
{
	player playsound("evt_nuke_flash");
	level.disable_nuke_delay_spawning = 1;
	level notify(#"disable_nuke_delay_spawning");
	level flag::clear("spawn_zombies");
	function_5db6ba34(1, 1);
	level thread function_83bdd16b();
	level util::waittill_any("ee_keeper_resurrected", "ee_keeper_resurrection_failed");
	level flag::set("spawn_zombies");
	level.disable_nuke_delay_spawning = 0;
}

/*
	Name: function_4cc29f4f
	Namespace: zm_zod_ee
	Checksum: 0xD952D41F
	Offset: 0x7D70
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_4cc29f4f(player)
{
	level notify(#"hash_4cc29f4f");
	level endon(#"hash_4cc29f4f");
	level endon(#"ee_keeper_resurrected");
	level endon(#"ee_keeper_resurrection_failed");
	player endon(#"hash_f764159c");
	player util::waittill_any("death", "disconnect", "player_downed");
	if(isdefined(player.var_11104075))
	{
		player.var_11104075 delete();
	}
	level thread function_5d546ced();
}

/*
	Name: function_fe26340b
	Namespace: zm_zod_ee
	Checksum: 0xCAEFB0BC
	Offset: 0x7E40
	Size: 0xFA
	Parameters: 0
	Flags: Linked
*/
function function_fe26340b()
{
	foreach(var_b9caebb1 in level.var_b94f6d7a)
	{
		if(!isdefined(var_b9caebb1) || !isdefined(var_b9caebb1.unitrigger_stub) || !isdefined(var_b9caebb1.unitrigger_stub.var_4cf62d2c))
		{
			continue;
		}
		var_b9caebb1.unitrigger_stub.var_4cf62d2c delete();
		zm_unitrigger::unregister_unitrigger(var_b9caebb1.unitrigger_stub);
	}
}

/*
	Name: function_6b57b2d3
	Namespace: zm_zod_ee
	Checksum: 0x95675D2B
	Offset: 0x7F48
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function function_6b57b2d3()
{
	foreach(player in level.activeplayers)
	{
		if(isdefined(player.var_11104075))
		{
			return player;
		}
	}
	return array::random(level.activeplayers);
}

/*
	Name: function_596e7950
	Namespace: zm_zod_ee
	Checksum: 0x860E6C36
	Offset: 0x7FF8
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_596e7950(goal)
{
	self endon(#"death");
	self waittill(#"visible");
	self vehicle_ai::set_state("scripted");
	self setvehgoalpos(goal, 0, 1);
	self thread zm_zod_shadowman::function_75c9aad2(goal, 64, 1);
}

/*
	Name: function_fe31ce39
	Namespace: zm_zod_ee
	Checksum: 0xD5603865
	Offset: 0x8088
	Size: 0x2A4
	Parameters: 1
	Flags: Linked
*/
function function_fe31ce39(var_1652ac62)
{
	width = 128;
	height = 128;
	length = 128;
	var_1652ac62.unitrigger_stub = spawnstruct();
	var_1652ac62.unitrigger_stub.origin = var_1652ac62.origin;
	var_1652ac62.unitrigger_stub.angles = var_1652ac62.angles;
	var_1652ac62.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	var_1652ac62.unitrigger_stub.cursor_hint = "HINT_NOICON";
	var_1652ac62.unitrigger_stub.script_width = width;
	var_1652ac62.unitrigger_stub.script_height = height;
	var_1652ac62.unitrigger_stub.script_length = length;
	var_1652ac62.unitrigger_stub.script_noteworthy = var_1652ac62.script_noteworthy;
	var_1652ac62.unitrigger_stub.require_look_at = 0;
	var_1652ac62.unitrigger_stub.var_1652ac62 = var_1652ac62;
	var_1652ac62.unitrigger_stub.var_4cf62d2c = spawn("script_model", var_1652ac62.origin);
	var_1652ac62.unitrigger_stub.var_4cf62d2c setmodel("t7_zm_zod_keepers_totem");
	var_1652ac62.unitrigger_stub.var_4cf62d2c hidepart("j_totem");
	var_1652ac62.unitrigger_stub.var_4cf62d2c clientfield::set("totem_state_fx", 2);
	var_1652ac62.unitrigger_stub.prompt_and_visibility_func = &function_51ca11ba;
	zm_unitrigger::register_static_unitrigger(var_1652ac62.unitrigger_stub, &function_943c90e6);
}

/*
	Name: function_51ca11ba
	Namespace: zm_zod_ee
	Checksum: 0xB903FEA
	Offset: 0x8338
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function function_51ca11ba(player)
{
	var_10cc4e3e = 0;
	if(!(isdefined(self.stub.b_completed) && self.stub.b_completed) && level flag::get("totem_placed"))
	{
		var_10cc4e3e = 1;
	}
	b_is_invis = isdefined(player.beastmode) && player.beastmode || var_10cc4e3e || (isdefined(self.stub.b_taken) && self.stub.b_taken);
	self setinvisibletoplayer(player, b_is_invis);
	return true;
}

/*
	Name: function_943c90e6
	Namespace: zm_zod_ee
	Checksum: 0x33E27D33
	Offset: 0x8430
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_943c90e6()
{
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
		level thread function_f016ad0d(self.stub, player);
		break;
	}
}

/*
	Name: function_f016ad0d
	Namespace: zm_zod_ee
	Checksum: 0x7F0CA5F7
	Offset: 0x84E0
	Size: 0x664
	Parameters: 2
	Flags: Linked
*/
function function_f016ad0d(trig_stub, player)
{
	level endon(#"ee_keeper_resurrection_failed");
	if(isdefined(trig_stub.b_completed) && trig_stub.b_completed)
	{
		if(!level flag::get("totem_placed"))
		{
			return;
		}
		trig_stub.var_4cf62d2c clientfield::set("totem_state_fx", 0);
		level flag::clear("totem_placed");
		level notify(#"hash_26f14b55");
		player playsound("zmb_zod_totem_pickup");
		player.var_11104075 = spawn("script_model", player.origin);
		player.var_11104075 setmodel("t7_zm_zod_keepers_totem");
		player.var_11104075 linkto(player, "tag_stowed_back", (0, 12, -32));
		player.var_11104075 clientfield::set("totem_state_fx", 1);
		trig_stub.var_4cf62d2c clientfield::set("totem_damage_fx", 0);
		trig_stub.var_4cf62d2c delete();
		v_origin = level.var_6e3c8a77.origin + vectorscale((0, 0, 1), 30);
		if(level.var_f47099f2 == 1 || level.var_86557cb0 < 3)
		{
			level thread zm_powerups::specific_powerup_drop("full_ammo", v_origin);
			level.var_86557cb0++;
		}
		level.var_6e3c8a77 = undefined;
		if(!isdefined(level.var_dc1b8d40))
		{
			level.var_dc1b8d40 = [];
		}
		if(!isdefined(level.var_dc1b8d40))
		{
			level.var_dc1b8d40 = [];
		}
		else if(!isarray(level.var_dc1b8d40))
		{
			level.var_dc1b8d40 = array(level.var_dc1b8d40);
		}
		level.var_dc1b8d40[level.var_dc1b8d40.size] = trig_stub.var_1652ac62;
		level thread function_4cc29f4f(player);
		zm_zod_shadowman::function_e48af0db();
		var_c9a88def = struct::get_array("cursetrap_point", "targetname");
		var_96b4af2e = int((var_c9a88def.size * level.var_f47099f2) / 2);
		level thread zm_zod_shadowman::function_f38a6a2a(var_96b4af2e);
		trig_stub.b_taken = 1;
		level.var_f47099f2++;
		if(function_224eb2ac())
		{
			level clientfield::set("ee_totem_state", 3);
			function_fe26340b();
		}
		return;
	}
	if(!isdefined(player.var_11104075))
	{
		return;
	}
	level flag::set("totem_placed");
	level.var_6e3c8a77 = trig_stub.var_1652ac62;
	player playsound("zmb_zod_totem_place");
	player.var_11104075 delete();
	trig_stub.var_4cf62d2c showpart("j_totem");
	trig_stub.var_4cf62d2c setcandamage(1);
	trig_stub.var_4cf62d2c clientfield::set("totem_state_fx", 3);
	var_a21704fb = [];
	var_a21704fb[0] = spawnstruct();
	var_a21704fb[0].func = &zm_zod_shadowman::function_4a41b207;
	var_a21704fb[0].probability = 0.5;
	var_a21704fb[0].n_move_duration = 3;
	str_targetname = "ee_shadowman_totem";
	str_script_noteworthy = trig_stub.script_noteworthy;
	level thread zm_zod_shadowman::function_f3805c8a(str_targetname, str_script_noteworthy, var_a21704fb, 2, 4);
	trig_stub.var_4cf62d2c thread function_353871a(undefined, player);
	trig_stub.var_4cf62d2c thread function_ac3c8848();
	function_7a40f43c();
	wait(30);
	trig_stub.var_4cf62d2c clientfield::set("totem_state_fx", 4);
	trig_stub.b_completed = 1;
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_e4f61654
	Namespace: zm_zod_ee
	Checksum: 0x3AA52C6E
	Offset: 0x8B50
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function function_e4f61654()
{
	var_fb88b1ef = function_832f1b2a();
	if(var_fb88b1ef == 0)
	{
		return 2;
	}
	if(var_fb88b1ef == 1)
	{
		return 2;
	}
	if(var_fb88b1ef == 2)
	{
		return 2;
	}
	if(var_fb88b1ef == 3)
	{
		return 2;
	}
}

/*
	Name: function_832f1b2a
	Namespace: zm_zod_ee
	Checksum: 0x62BDBD65
	Offset: 0x8BD8
	Size: 0x106
	Parameters: 0
	Flags: Linked
*/
function function_832f1b2a()
{
	var_fb88b1ef = 0;
	var_9eb45ed3 = array("boxer", "detective", "femme", "magician");
	foreach(str_charname in var_9eb45ed3)
	{
		if((clientfield::get(("ee_keeper_" + str_charname) + "_state")) >= 3)
		{
			var_fb88b1ef = var_fb88b1ef + 1;
		}
	}
	return var_fb88b1ef;
}

/*
	Name: function_224eb2ac
	Namespace: zm_zod_ee
	Checksum: 0x664A770B
	Offset: 0x8CE8
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function function_224eb2ac()
{
	if(level.var_f47099f2 == level.var_e59fb2)
	{
		return true;
	}
	return false;
}

/*
	Name: function_353871a
	Namespace: zm_zod_ee
	Checksum: 0x20E48992
	Offset: 0x8D10
	Size: 0x2C2
	Parameters: 2
	Flags: Linked
*/
function function_353871a(var_ee1ff130, owner)
{
	level endon(#"ee_keeper_resurrection_failed");
	level endon(#"hash_26f14b55");
	self.health = 1000000;
	self.team = "allies";
	self setteam(self.team);
	self.owner = owner;
	self setowner(owner);
	var_9124cf71 = 0;
	var_a62764b3 = 2400 + -1600 * ((level.activeplayers.size - 1) / 3);
	while(true)
	{
		self waittill(#"damage", amount, attacker, direction_vec, point, type, tagname, modelname, partname, weapon);
		self.health = 1000000;
		if(isdefined(level.var_ad555b99) && level.var_ad555b99)
		{
			return;
		}
		if(type === "MOD_CRUSH")
		{
			return;
		}
		if(isdefined(zm::is_idgun_damage(weapon)) && zm::is_idgun_damage(weapon))
		{
		}
		else
		{
			if(!isdefined(attacker.archetype))
			{
				return;
			}
			if(attacker.archetype !== "margwa" && attacker.archetype !== "zombie" && !isvehicle(attacker))
			{
				return;
			}
		}
		var_9124cf71 = var_9124cf71 + amount;
		if(var_9124cf71 >= var_a62764b3)
		{
			self playsound("zmb_zod_totem_breakapart");
			self clientfield::set("totem_state_fx", 5);
			if(isdefined(var_ee1ff130))
			{
				level thread function_3089f820(var_ee1ff130);
			}
			else
			{
				level thread function_3089f820();
			}
			return;
		}
	}
}

/*
	Name: function_ac3c8848
	Namespace: zm_zod_ee
	Checksum: 0x31B98242
	Offset: 0x8FE0
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function function_ac3c8848(var_ee1ff130)
{
	level endon(#"ee_keeper_resurrection_failed");
	level endon(#"hash_26f14b55");
	var_cabf2f4c = 0;
	var_3efd73a6 = 5;
	while(true)
	{
		level waittill(#"hash_d103204");
		var_cabf2f4c++;
		if(var_cabf2f4c >= var_3efd73a6)
		{
			self playsound("zmb_zod_totem_breakapart");
			self clientfield::set("totem_state_fx", 5);
			if(isdefined(var_ee1ff130))
			{
				level thread function_3089f820(var_ee1ff130);
			}
			else
			{
				level thread function_3089f820();
			}
			return;
		}
	}
}

/*
	Name: function_877ea350
	Namespace: zm_zod_ee
	Checksum: 0x20DBD72C
	Offset: 0x90D8
	Size: 0x360
	Parameters: 0
	Flags: Linked
*/
function function_877ea350()
{
	level endon(#"ee_keeper_resurrected");
	level endon(#"ee_keeper_resurrection_failed");
	level endon(#"ee_boss_defeated");
	zombie_utility::ai_calculate_health(level.round_number);
	while(true)
	{
		var_565450eb = zombie_utility::get_current_zombie_count();
		while(var_565450eb >= 10 || var_565450eb >= (level.players.size * 5))
		{
			wait(randomfloatrange(2, 4));
			var_565450eb = zombie_utility::get_current_zombie_count();
		}
		while(zombie_utility::get_current_actor_count() >= level.zombie_actor_limit)
		{
			zombie_utility::clear_all_corpses();
			wait(0.1);
		}
		zm::run_custom_ai_spawn_checks();
		if(isdefined(level.zombie_spawners))
		{
			if(isdefined(level.use_multiple_spawns) && level.use_multiple_spawns)
			{
				if(isdefined(level.spawner_int) && (isdefined(level.zombie_spawn[level.spawner_int].size) && level.zombie_spawn[level.spawner_int].size))
				{
					spawner = array::random(level.zombie_spawn[level.spawner_int]);
				}
				else
				{
					spawner = array::random(level.zombie_spawners);
				}
			}
			else
			{
				spawner = array::random(level.zombie_spawners);
			}
			ai = zombie_utility::spawn_zombie(spawner, spawner.targetname);
		}
		if(isdefined(ai))
		{
			ai.no_powerups = 1;
			ai.deathpoints_already_given = 1;
			ai.exclude_distance_cleanup_adding_to_total = 1;
			ai.exclude_cleanup_adding_to_total = 1;
			ai.targetname = "ee_zombie";
			if(ai.zombie_move_speed === "walk")
			{
				ai zombie_utility::set_zombie_run_cycle("run");
			}
			find_flesh_struct_string = "find_flesh";
			ai notify(#"zombie_custom_think_done", find_flesh_struct_string);
			ai ai::set_behavior_attribute("can_juke", 0);
			if(level.zombie_respawns > 0 && level.zombie_vars["zombie_spawn_delay"] > 1)
			{
				wait(1);
			}
			else
			{
				wait(level.zombie_vars["zombie_spawn_delay"]);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_737ebab
	Namespace: zm_zod_ee
	Checksum: 0x1230C14A
	Offset: 0x9440
	Size: 0x638
	Parameters: 0
	Flags: None
*/
function function_737ebab()
{
	level endon(#"ee_keeper_resurrected");
	level endon(#"ee_keeper_resurrection_failed");
	level endon(#"ee_boss_defeated");
	level.wasp_targets = getplayers();
	for(i = 0; i < level.wasp_targets.size; i++)
	{
		level.wasp_targets[i].hunted_by = 0;
	}
	zm_ai_wasp::wasp_health_increase();
	n_wasps_alive = 0;
	level clientfield::set("toggle_on_parasite_fog", 1);
	wait(3);
	while(true)
	{
		b_swarm_spawned = 0;
		while(!b_swarm_spawned)
		{
			n_wasps_alive = zm_ai_wasp::get_current_wasp_count();
			while(n_wasps_alive >= 8 || n_wasps_alive >= (level.players.size * 4))
			{
				wait(randomfloatrange(2, 4));
				n_wasps_alive = zm_ai_wasp::get_current_wasp_count();
			}
			spawn_point = undefined;
			while(!isdefined(spawn_point))
			{
				favorite_enemy = array::random(level.activeplayers);
				if(isdefined(level.wasp_spawn_func))
				{
					spawn_point = [[level.wasp_spawn_func]](favorite_enemy);
				}
				else
				{
					spawn_point = zm_ai_wasp::wasp_spawn_logic(favorite_enemy);
				}
				if(!isdefined(spawn_point))
				{
					wait(randomfloatrange(0.6666666, 1.333333));
				}
			}
			v_spawn_origin = spawn_point.origin;
			v_ground = bullettrace(spawn_point.origin + (0, 0, 60), (spawn_point.origin + (0, 0, 60)) + (vectorscale((0, 0, -1), 100000)), 0, undefined)["position"];
			if(distancesquared(v_ground, spawn_point.origin) < (60 * 60))
			{
				v_spawn_origin = v_ground + (0, 0, 60);
			}
			queryresult = positionquery_source_navigation(v_spawn_origin, 0, 80, 80, 15, "navvolume_small");
			a_points = array::randomize(queryresult.data);
			a_spawn_origins = [];
			n_points_found = 0;
			foreach(point in a_points)
			{
				if(bullettracepassed(point.origin, spawn_point.origin, 0, favorite_enemy))
				{
					if(!isdefined(a_spawn_origins))
					{
						a_spawn_origins = [];
					}
					else if(!isarray(a_spawn_origins))
					{
						a_spawn_origins = array(a_spawn_origins);
					}
					a_spawn_origins[a_spawn_origins.size] = point.origin;
					n_points_found++;
					if(n_points_found >= 1)
					{
						break;
					}
				}
			}
			if(a_spawn_origins.size >= 1)
			{
				n_spawn = 0;
				while(n_spawn < 1 && level.zombie_total > 0)
				{
					for(i = a_spawn_origins.size - 1; i >= 0; i--)
					{
						v_origin = a_spawn_origins[i];
						level.wasp_spawners[0].origin = v_origin;
						ai = zombie_utility::spawn_zombie(level.wasp_spawners[0]);
						if(isdefined(ai))
						{
							ai.favoriteenemy = favorite_enemy;
							level thread zm_ai_wasp::wasp_spawn_init(ai, v_origin);
							arrayremoveindex(a_spawn_origins, i);
							n_spawn++;
							wait(randomfloatrange(0.06666666, 0.1333333));
							break;
						}
						wait(randomfloatrange(0.06666666, 0.1333333));
					}
				}
				b_swarm_spawned = 1;
			}
			util::wait_network_frame();
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_83bdd16b
	Namespace: zm_zod_ee
	Checksum: 0x6646DA8C
	Offset: 0x9A80
	Size: 0x310
	Parameters: 0
	Flags: Linked
*/
function function_83bdd16b()
{
	level endon(#"ee_keeper_resurrected");
	level endon(#"ee_keeper_resurrection_failed");
	level endon(#"ee_boss_defeated");
	level.raps_targets = getplayers();
	for(i = 0; i < level.raps_targets.size; i++)
	{
		level.raps_targets[i].hunted_by = 0;
	}
	zm_ai_raps::raps_health_increase();
	n_raps_alive = 0;
	level clientfield::set("toggle_on_parasite_fog", 1);
	wait(3);
	while(true)
	{
		n_raps_alive = zm_ai_raps::get_current_raps_count();
		while(n_raps_alive >= 13 || n_raps_alive >= (level.players.size * 4))
		{
			wait(randomfloatrange(2, 4));
			n_raps_alive = zm_ai_raps::get_current_raps_count();
		}
		spawn_point = undefined;
		favorite_enemy = function_6b57b2d3();
		if(isdefined(level.raps_spawn_func))
		{
			spawn_point = [[level.raps_spawn_func]](favorite_enemy);
		}
		else
		{
			spawn_point = zm_ai_raps::calculate_spawn_position(favorite_enemy);
		}
		if(!isdefined(spawn_point))
		{
			wait(randomfloatrange(0.6666666, 1.333333));
			continue;
		}
		ai = zombie_utility::spawn_zombie(level.raps_spawners[0]);
		if(isdefined(ai))
		{
			var_8388cfbb = undefined;
			ai.deathpoints_already_given = 1;
			ai.favoriteenemy = favorite_enemy;
			spawn_point thread zm_ai_raps::raps_spawn_fx(ai, spawn_point);
			if(level flag::get("totem_placed"))
			{
				var_8388cfbb = level.var_6e3c8a77.origin;
				var_8388cfbb = var_8388cfbb + vectorscale((0, 0, 1), 32);
			}
			if(isdefined(var_8388cfbb))
			{
				ai thread function_596e7950(var_8388cfbb);
			}
			zm_ai_raps::waiting_for_next_raps_spawn();
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_7a40f43c
	Namespace: zm_zod_ee
	Checksum: 0xBFFA9BA4
	Offset: 0x9D98
	Size: 0x15A
	Parameters: 0
	Flags: Linked
*/
function function_7a40f43c()
{
	var_e159ea26 = getentarray("zombie_raps", "targetname");
	foreach(var_b847ad06 in var_e159ea26)
	{
		if(isdefined(var_b847ad06) && isalive(var_b847ad06))
		{
			var_8388cfbb = level.var_6e3c8a77.origin;
			var_8388cfbb = var_8388cfbb + vectorscale((0, 0, 1), 32);
			var_b847ad06 vehicle_ai::set_state("scripted");
			var_b847ad06 setvehgoalpos(var_8388cfbb, 0, 1);
			var_b847ad06 thread zm_zod_shadowman::function_75c9aad2(var_8388cfbb, 64, 1);
		}
	}
}

/*
	Name: cleanup_ai
	Namespace: zm_zod_ee
	Checksum: 0xCDE1DCF7
	Offset: 0x9F00
	Size: 0x37A
	Parameters: 2
	Flags: Linked
*/
function cleanup_ai(var_1a60ad71 = 0, var_75541524 = 0)
{
	if(var_1a60ad71)
	{
		level thread lui::screen_flash(0.2, 0.5, 1, 0.8, "white");
	}
	var_da5df44a = array("ee_zombie", "zombie_wasp", "zombie_raps");
	if(!(isdefined(var_75541524) && var_75541524))
	{
		if(!isdefined(var_da5df44a))
		{
			var_da5df44a = [];
		}
		else if(!isarray(var_da5df44a))
		{
			var_da5df44a = array(var_da5df44a);
		}
		var_da5df44a[var_da5df44a.size] = "margwa";
	}
	foreach(var_493961de in var_da5df44a)
	{
		a_ai = getentarray(var_493961de, "targetname");
		if(!isdefined(a_ai))
		{
			continue;
		}
		foreach(ai in a_ai)
		{
			if(isdefined(ai) && isalive(ai))
			{
				ai kill();
			}
			wait(0.1);
		}
	}
	a_ai_zombies = getaiteamarray(level.zombie_team);
	if(!isdefined(a_ai_zombies))
	{
		return;
	}
	foreach(ai in a_ai_zombies)
	{
		if(isdefined(ai) && isalive(ai))
		{
			if(isdefined(var_75541524) && var_75541524 && ai.archetype == "margwa")
			{
				continue;
			}
			ai kill();
		}
		wait(0.1);
	}
}

/*
	Name: function_5db6ba34
	Namespace: zm_zod_ee
	Checksum: 0x1FE57A2C
	Offset: 0xA288
	Size: 0x43A
	Parameters: 2
	Flags: Linked
*/
function function_5db6ba34(var_1a60ad71 = 1, var_75541524 = 0)
{
	if(var_1a60ad71)
	{
		level thread lui::screen_flash(0.2, 0.5, 1, 0.8, "white");
	}
	wait(0.5);
	a_ai_zombies = getaiteamarray(level.zombie_team);
	var_6b1085eb = [];
	foreach(ai_zombie in a_ai_zombies)
	{
		ai_zombie.no_powerups = 1;
		ai_zombie.deathpoints_already_given = 1;
		if(isdefined(var_75541524) && var_75541524 && ai_zombie.archetype == "margwa")
		{
			continue;
		}
		if(isdefined(ai_zombie.ignore_nuke) && ai_zombie.ignore_nuke)
		{
			continue;
		}
		if(isdefined(ai_zombie.marked_for_death) && ai_zombie.marked_for_death)
		{
			continue;
		}
		if(isdefined(ai_zombie.nuke_damage_func))
		{
			ai_zombie thread [[ai_zombie.nuke_damage_func]]();
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(ai_zombie))
		{
			continue;
		}
		ai_zombie.marked_for_death = 1;
		ai_zombie.nuked = 1;
		var_6b1085eb[var_6b1085eb.size] = ai_zombie;
	}
	foreach(i, var_f92b3d80 in var_6b1085eb)
	{
		wait(randomfloatrange(0.1, 0.2));
		if(!isdefined(var_f92b3d80))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(var_f92b3d80))
		{
			continue;
		}
		if(i < 5 && (!(isdefined(var_f92b3d80.isdog) && var_f92b3d80.isdog)))
		{
			var_f92b3d80 thread zombie_death::flame_death_fx();
		}
		if(!(isdefined(var_f92b3d80.isdog) && var_f92b3d80.isdog))
		{
			if(!(isdefined(var_f92b3d80.no_gib) && var_f92b3d80.no_gib))
			{
				var_f92b3d80 zombie_utility::zombie_head_gib();
			}
		}
		var_f92b3d80 dodamage(var_f92b3d80.health, var_f92b3d80.origin);
		if(!level flag::get("special_round"))
		{
			if(var_f92b3d80.archetype == "margwa")
			{
				level.var_e0191376++;
				continue;
			}
			level.zombie_total++;
		}
	}
}

/*
	Name: function_904cb175
	Namespace: zm_zod_ee
	Checksum: 0xD4509D2D
	Offset: 0xA6D0
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function function_904cb175(var_e6fb7eb3)
{
	players = level.activeplayers;
	foreach(player in players)
	{
		if(isdefined(var_e6fb7eb3))
		{
			level thread function_22d6774c(player, var_e6fb7eb3);
			continue;
		}
		level thread function_22d6774c(player);
	}
}

/*
	Name: function_22d6774c
	Namespace: zm_zod_ee
	Checksum: 0x6292821E
	Offset: 0xA7B0
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function function_22d6774c(player, var_e6fb7eb3)
{
	level endon(#"ee_keeper_resurrected");
	level endon(#"ee_keeper_resurrection_failed");
	player util::waittill_any("death", "bled_out", "disconnect");
	if(isdefined(var_e6fb7eb3))
	{
		level thread function_3089f820(var_e6fb7eb3);
	}
	else
	{
		level thread function_3089f820();
	}
}

/*
	Name: function_c7c3f7b5
	Namespace: zm_zod_ee
	Checksum: 0xC13E0D54
	Offset: 0xA848
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function function_c7c3f7b5(var_495327e)
{
	if(level flag::get("ee_final_boss_staggered"))
	{
		return false;
	}
	if(!isdefined(var_495327e))
	{
		var_495327e = 3;
	}
	var_3026634e = level.var_6e63e659 >= var_495327e;
	var_f52ee0b1 = zombie_utility::get_current_zombie_count() >= level.zombie_ai_limit;
	var_73d2bce8 = level.zm_loc_types["margwa_location"].size < 1;
	if(var_3026634e || var_f52ee0b1 || var_73d2bce8)
	{
		return false;
	}
	return true;
}

/*
	Name: function_37dc5568
	Namespace: zm_zod_ee
	Checksum: 0x7F637026
	Offset: 0xA928
	Size: 0x346
	Parameters: 12
	Flags: Linked
*/
function function_37dc5568(inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	damageopen = 0;
	b_superbeastmode = level clientfield::get("bm_superbeast");
	if(isdefined(attacker) && b_superbeastmode)
	{
		headalive = [];
		foreach(head in self.head)
		{
			if(head margwaserverutils::margwacandamagehead())
			{
				headalive[headalive.size] = head;
			}
		}
		if(headalive.size > 0)
		{
			max = 100000;
			headclosest = undefined;
			foreach(head in headalive)
			{
				distsq = distancesquared(point, self gettagorigin(head.tag));
				if(distsq < max)
				{
					max = distsq;
					headclosest = head;
				}
			}
			if(isdefined(headclosest))
			{
				if(max < 576)
				{
					headclosest.health = headclosest.health - damage;
					damageopen = 1;
					self clientfield::increment(headclosest.impactcf);
					attacker margwaserverutils::show_hit_marker();
					if(headclosest.health <= 0)
					{
						if(self margwaserverutils::margwakillhead(headclosest.model, attacker))
						{
							return self.health;
						}
					}
				}
			}
		}
	}
	else if(isdefined(self.var_c874832e) && self.var_c874832e)
	{
		return 0;
	}
}

/*
	Name: function_80d91769
	Namespace: zm_zod_ee
	Checksum: 0x743B4699
	Offset: 0xAC78
	Size: 0x664
	Parameters: 0
	Flags: Linked
*/
function function_80d91769()
{
	/#
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_b44200f1);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_7a0bffae);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_54098545);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_d2f61efa);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_bdd0041e);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_932267b5);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_3089f820);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_fdcb978b);
		level thread zm_zod_util::setup_devgui_func("", "", 2, &function_fdcb978b);
		level thread zm_zod_util::setup_devgui_func("", "", 3, &function_fdcb978b);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_892e1f69);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_656b9ef0);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_690f9751);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_7787c089);
		level thread zm_zod_util::setup_devgui_func("", "", 2, &function_7787c089);
		level thread zm_zod_util::setup_devgui_func("", "", 3, &function_7787c089);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_1c4c22d9);
		level thread zm_zod_util::setup_devgui_func("", "", 2, &function_1c4c22d9);
		level thread zm_zod_util::setup_devgui_func("", "", 3, &function_1c4c22d9);
		level thread zm_zod_util::setup_devgui_func("", "", 4, &function_1c4c22d9);
		level thread zm_zod_util::setup_devgui_func("", "", 5, &function_1c4c22d9);
		level thread zm_zod_util::setup_devgui_func("", "", 6, &function_1c4c22d9);
		level thread zm_zod_util::setup_devgui_func("", "", 7, &function_1c4c22d9);
		level thread zm_zod_util::setup_devgui_func("", "", 8, &function_1c4c22d9);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_2a306df);
		level thread zm_zod_util::setup_devgui_func("", "", 2, &function_2a306df);
		level thread zm_zod_util::setup_devgui_func("", "", 3, &function_2a306df);
		level thread zm_zod_util::setup_devgui_func("", "", 4, &function_2a306df);
		level thread zm_zod_util::setup_devgui_func("", "", 5, &function_2a306df);
	#/
}

/*
	Name: function_690f9751
	Namespace: zm_zod_ee
	Checksum: 0xDD79A11C
	Offset: 0xB2E8
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function function_690f9751(n_val)
{
	level.var_421ff75e = 1;
}

/*
	Name: function_656b9ef0
	Namespace: zm_zod_ee
	Checksum: 0xDEB0F9A1
	Offset: 0xB308
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function function_656b9ef0(n_val)
{
	level.var_ad555b99 = 1;
}

/*
	Name: function_bdd0041e
	Namespace: zm_zod_ee
	Checksum: 0x646870F
	Offset: 0xB328
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_bdd0041e(n_val)
{
	level flag::set("ee_complete");
}

/*
	Name: function_7787c089
	Namespace: zm_zod_ee
	Checksum: 0xC118355A
	Offset: 0xB360
	Size: 0x1EE
	Parameters: 1
	Flags: Linked
*/
function function_7787c089(n_val)
{
	mdl_god_far = getent("mdl_god_far", "targetname");
	mdl_god_near = getent("mdl_god_near", "targetname");
	switch(n_val)
	{
		case 1:
		{
			mdl_god_far clientfield::set("far_apothigod_active", 0);
			mdl_god_near clientfield::set("near_apothigod_active", 0);
			mdl_god_far hide();
			mdl_god_near hide();
			break;
		}
		case 2:
		{
			mdl_god_far clientfield::set("far_apothigod_active", 1);
			mdl_god_near clientfield::set("near_apothigod_active", 0);
			mdl_god_far show();
			mdl_god_near hide();
			break;
		}
		case 3:
		{
			mdl_god_far clientfield::set("far_apothigod_active", 0);
			mdl_god_near clientfield::set("near_apothigod_active", 1);
			mdl_god_far hide();
			mdl_god_near show();
			break;
		}
	}
}

/*
	Name: function_2a306df
	Namespace: zm_zod_ee
	Checksum: 0x6B8169B3
	Offset: 0xB558
	Size: 0x19A
	Parameters: 1
	Flags: Linked
*/
function function_2a306df(n_val)
{
	switch(n_val)
	{
		case 1:
		{
			for(i = 1; i < 5; i++)
			{
				str_charname = function_d93f551b(i);
				var_91341fca = ("ee_keeper_" + str_charname) + "_state";
				level clientfield::set(var_91341fca, 4);
			}
			break;
		}
		case 2:
		{
			function_c07e1993();
			for(i = 1; i < 5; i++)
			{
				str_charname = function_d93f551b(i);
				var_91341fca = ("ee_keeper_" + str_charname) + "_state";
				level clientfield::set(var_91341fca, 5);
			}
			wait(3);
			level.var_1a2a51eb.var_93dad597 clientfield::set("boss_shield_fx", 0);
			break;
		}
		case 3:
		{
			break;
		}
		case 4:
		{
			break;
		}
		case 5:
		{
			break;
		}
	}
}

/*
	Name: function_c07e1993
	Namespace: zm_zod_ee
	Checksum: 0x675FF0B0
	Offset: 0xB700
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function function_c07e1993()
{
	if(!isdefined(level.var_1a2a51eb))
	{
		level.var_1a2a51eb = spawnstruct();
	}
	level.var_1a2a51eb.s_spawnpoint = struct::get("ee_shadowman_8", "targetname");
	var_2e456dd1 = level.var_1a2a51eb.s_spawnpoint.origin;
	var_7e1ba25f = level.var_1a2a51eb.s_spawnpoint.angles;
	level.var_1a2a51eb.var_93dad597 = spawn("script_model", var_2e456dd1);
	level.var_1a2a51eb.var_93dad597.angles = var_7e1ba25f;
	level.var_1a2a51eb.var_93dad597 setmodel("c_zom_zod_shadowman_tentacles_fb");
	level.var_1a2a51eb.var_93dad597 useanimtree($generic);
	level.var_1a2a51eb.var_93dad597 clientfield::set("shadowman_fx", 1);
	level.var_1a2a51eb.var_93dad597 playsound("zmb_shadowman_tele_in");
}

/*
	Name: function_1c4c22d9
	Namespace: zm_zod_ee
	Checksum: 0xF93CFFBF
	Offset: 0xB8A8
	Size: 0x15E
	Parameters: 1
	Flags: Linked
*/
function function_1c4c22d9(n_val)
{
	switch(n_val)
	{
		case 1:
		{
			function_61d12305(1, 1);
			break;
		}
		case 2:
		{
			function_61d12305(1, 0);
			break;
		}
		case 3:
		{
			function_61d12305(2, 1);
			break;
		}
		case 4:
		{
			function_61d12305(2, 0);
			break;
		}
		case 5:
		{
			function_61d12305(3, 1);
			break;
		}
		case 6:
		{
			function_61d12305(3, 0);
			break;
		}
		case 7:
		{
			function_61d12305(4, 1);
			break;
		}
		case 8:
		{
			function_61d12305(4, 0);
			break;
		}
	}
}

/*
	Name: function_fdcb978b
	Namespace: zm_zod_ee
	Checksum: 0x1D544836
	Offset: 0xBA10
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_fdcb978b(n_val)
{
	level thread function_d3b3eb03(n_val);
}

/*
	Name: function_892e1f69
	Namespace: zm_zod_ee
	Checksum: 0xA9F7504
	Offset: 0xBA40
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_892e1f69(n_val)
{
	level thread function_c898ab1(n_val);
}

/*
	Name: function_b44200f1
	Namespace: zm_zod_ee
	Checksum: 0xDA146504
	Offset: 0xBA70
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_b44200f1(n_val)
{
	zm_altbody_beast::beastmode_devgui_callback("super_sesame");
	zm_zod_quest::function_c0a29676();
	level flag::set("ee_begin");
}

/*
	Name: function_7a0bffae
	Namespace: zm_zod_ee
	Checksum: 0x8FF34C62
	Offset: 0xBAD0
	Size: 0xF6
	Parameters: 1
	Flags: Linked
*/
function function_7a0bffae(n_val)
{
	function_b44200f1();
	level flag::set("ee_book");
	for(i = 1; i < 5; i++)
	{
		str_charname = function_d93f551b(i);
		var_27b0f0e4 = level clientfield::get(("ee_keeper_" + str_charname) + "_state");
		if(var_27b0f0e4 == 3)
		{
			continue;
		}
		level function_8f4b6b20(i, 1);
		wait(1);
	}
}

/*
	Name: function_54098545
	Namespace: zm_zod_ee
	Checksum: 0xBF7638BF
	Offset: 0xBBD0
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function function_54098545(n_val)
{
	level.var_421ff75e = 1;
	function_b44200f1();
	level flag::set("ee_book");
	for(i = 1; i < 5; i++)
	{
		str_charname = function_d93f551b(i);
		var_27b0f0e4 = level clientfield::get(("ee_keeper_" + str_charname) + "_state");
		if(var_27b0f0e4 == 3)
		{
			continue;
		}
		level function_8f4b6b20(i, 1);
		wait(1);
	}
	wait(5);
	function_3fc4aca5();
}

/*
	Name: function_d2f61efa
	Namespace: zm_zod_ee
	Checksum: 0x8242DD2C
	Offset: 0xBCF8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_d2f61efa(n_val)
{
	function_b44200f1();
	level flag::set("ee_book");
	function_3fc4aca5();
	level flag::set("ee_final_boss_defeated");
}

/*
	Name: function_932267b5
	Namespace: zm_zod_ee
	Checksum: 0x8EE220FA
	Offset: 0xBD70
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function function_932267b5(n_val)
{
	ee_ending();
}

/*
	Name: function_c1cc37db
	Namespace: zm_zod_ee
	Checksum: 0x696866E4
	Offset: 0xBD98
	Size: 0x116
	Parameters: 1
	Flags: None
*/
function function_c1cc37db(n_val)
{
	if(n_val < 5)
	{
		level function_8f4b6b20();
	}
	else
	{
		if(n_val == 5)
		{
			level function_8f4b6b20();
		}
		else if(n_val == 6)
		{
			for(i = 1; i < 5; i++)
			{
				str_charname = function_d93f551b(i);
				var_27b0f0e4 = level clientfield::get(("ee_keeper_" + str_charname) + "_state");
				if(var_27b0f0e4 == 3)
				{
					continue;
				}
				level function_8f4b6b20();
				wait(1);
			}
		}
	}
}

