// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_spider;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb_machine;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_ai_spiders;

/*
	Name: __init__sytem__
	Namespace: zm_ai_spiders
	Checksum: 0x478DDF65
	Offset: 0x838
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_spiders", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_spiders
	Checksum: 0x76F44131
	Offset: 0x880
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.var_9d7b5e00 = 200;
	level.var_6ea0fe2e = 1;
	level flag::init("spider_round");
	/#
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		level thread function_3fd0c070();
	#/
	function_5c48d276();
	init();
	callback::on_spawned(&function_83a70ec3);
	spawner::add_archetype_spawn_function("spider", &function_82b6256d);
	spawner::add_archetype_spawn_function("spider", &function_df94945b);
	zm::register_vehicle_damage_callback(&function_5b625d74);
}

/*
	Name: __main__
	Namespace: zm_ai_spiders
	Checksum: 0xDD26C302
	Offset: 0x9F8
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	register_clientfields();
}

/*
	Name: register_clientfields
	Namespace: zm_ai_spiders
	Checksum: 0xBA007C2F
	Offset: 0xA18
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("toplayer", "spider_round_fx", 9000, 1, "counter");
	clientfield::register("toplayer", "spider_round_ring_fx", 9000, 1, "counter");
	clientfield::register("toplayer", "spider_end_of_round_reset", 9000, 1, "counter");
}

/*
	Name: function_83a70ec3
	Namespace: zm_ai_spiders
	Checksum: 0xA2FD47C2
	Offset: 0xAB8
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function function_83a70ec3()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"bled_out");
		if(level flag::get("spider_round_in_progress"))
		{
			self waittill(#"spawned_player");
			level flag::wait_till_clear("spider_round_in_progress");
			util::wait_network_frame();
			self clientfield::increment_to_player("spider_end_of_round_reset", 1);
		}
	}
}

/*
	Name: init
	Namespace: zm_ai_spiders
	Checksum: 0x1A8BCE3D
	Offset: 0xB68
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.var_173ca157 = 1;
	level.var_347e707c = 0;
	level.var_7f2af1cf = 1;
	level.var_c38a4fee = [];
	level flag::init("spider_clips");
	level flag::init("spider_round_in_progress");
	level.aat["zm_aat_turned"].immune_trigger["spider"] = 1;
	level.aat["zm_aat_thunder_wall"].immune_result_indirect["spider"] = 1;
	level.aat["zm_aat_dead_wire"].immune_trigger["spider"] = 1;
	level.melee_range_sav = getdvarstring("ai_meleeRange");
	level.melee_width_sav = getdvarstring("ai_meleeWidth");
	level.melee_height_sav = getdvarstring("ai_meleeHeight");
	function_7a544164();
	level thread function_fd32a77c();
	visionset_mgr::register_info("visionset", "zm_isl_parasite_spider_visionset", 9000, 33, 16, 0, &visionset_mgr::ramp_in_out_thread, 0);
}

/*
	Name: function_1c624caf
	Namespace: zm_ai_spiders
	Checksum: 0xC0072293
	Offset: 0xD28
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function function_1c624caf(a_ents)
{
	if(self.model === "tag_origin")
	{
		self zm_utility::self_delete();
	}
}

/*
	Name: function_5c48d276
	Namespace: zm_ai_spiders
	Checksum: 0x1C086475
	Offset: 0xD68
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function function_5c48d276()
{
	level._effect["spider_gib"] = "dlc2/island/fx_spider_death_explo_sm";
}

/*
	Name: function_fd32a77c
	Namespace: zm_ai_spiders
	Checksum: 0xE23B7AF0
	Offset: 0xD90
	Size: 0x206
	Parameters: 0
	Flags: Linked
*/
function function_fd32a77c()
{
	clips_on = 0;
	level.spider_clips = getentarray("spider_clips", "targetname");
	while(true)
	{
		for(i = 0; i < level.spider_clips.size; i++)
		{
			level.spider_clips[i] connectpaths();
		}
		level flag::wait_till("spider_clips");
		if(isdefined(level.var_e564e9cd) && level.var_e564e9cd == 1)
		{
			return;
		}
		for(i = 0; i < level.spider_clips.size; i++)
		{
			level.spider_clips[i] disconnectpaths();
			util::wait_network_frame();
		}
		var_26b8af54 = 1;
		while(var_26b8af54 || level flag::get("spider_round"))
		{
			var_26b8af54 = 0;
			var_4b55c671 = getvehiclearray("zombie_spider", "targetname");
			for(i = 0; i < var_4b55c671.size; i++)
			{
				if(isalive(var_4b55c671[i]))
				{
					var_26b8af54 = 1;
				}
			}
			wait(1);
		}
		level flag::clear("spider_clips");
		wait(1);
	}
}

/*
	Name: function_d2716ad8
	Namespace: zm_ai_spiders
	Checksum: 0xE07B6724
	Offset: 0xFA0
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function function_d2716ad8()
{
	level.var_347e707c = 1;
	if(!isdefined(level.var_33655cba))
	{
		level.var_33655cba = &function_2a424152;
	}
	level thread [[level.var_33655cba]]();
}

/*
	Name: function_7a544164
	Namespace: zm_ai_spiders
	Checksum: 0x4F3411D4
	Offset: 0xFF0
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function function_7a544164()
{
	level.var_c38a4fee = getentarray("zombie_spider_spawner", "script_noteworthy");
	var_c84b3c65 = getentarray("later_round_spider_spawners", "script_noteworthy");
	level.var_c7f0b45b = arraycombine(level.var_c38a4fee, var_c84b3c65, 1, 0);
	if(level.var_c38a4fee.size == 0)
	{
		return;
	}
	for(i = 0; i < level.var_c38a4fee.size; i++)
	{
		if(zm_spawner::is_spawner_targeted_by_blocker(level.var_c38a4fee[i]))
		{
			level.var_c38a4fee[i].is_enabled = 0;
			continue;
		}
		level.var_c38a4fee[i].is_enabled = 1;
		level.var_c38a4fee[i].script_forcespawn = 1;
	}
	/#
		assert(level.var_c38a4fee.size > 0);
	#/
	array::thread_all(level.var_c38a4fee, &spawner::add_spawn_function, &function_7c1ef59b);
}

/*
	Name: function_7c1ef59b
	Namespace: zm_ai_spiders
	Checksum: 0xF5B240F
	Offset: 0x1198
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_7c1ef59b()
{
	function_6e19aa86();
	self.targetname = "zombie_spider";
	self.maxhealth = level.var_fda270a4;
	self.health = self.maxhealth;
	self.no_gib = 1;
	self.b_is_spider = 1;
	self.no_eye_glow = 1;
	self.custom_player_shellshock = &function_c685a92b;
	self.team = level.zombie_team;
	self.missinglegs = 0;
	self.thundergun_knockdown_func = &function_96d38ff4;
	self.lightning_chain_immune = 1;
	self thread function_747a2fea();
	self thread function_7609fd9();
	self playsound("zmb_spider_spawn");
	self thread function_eebdfab2();
}

/*
	Name: function_747a2fea
	Namespace: zm_ai_spiders
	Checksum: 0xF0A6064E
	Offset: 0x12C0
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function function_747a2fea()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage", n_amount, e_attacker, v_direction, v_hit_location, str_mod);
		if(isplayer(e_attacker))
		{
			e_attacker.use_weapon_type = str_mod;
			self thread zm_powerups::check_for_instakill(e_attacker, str_mod, v_hit_location);
		}
	}
}

/*
	Name: function_96d38ff4
	Namespace: zm_ai_spiders
	Checksum: 0x4D8CAA36
	Offset: 0x1378
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function function_96d38ff4(e_player, gib)
{
	self endon(#"death");
	n_damage = int(self.maxhealth * 0.5);
	self dodamage(n_damage, self.origin, e_player);
}

/*
	Name: function_a3f4adb
	Namespace: zm_ai_spiders
	Checksum: 0x99EC1590
	Offset: 0x13F8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function function_a3f4adb()
{
}

/*
	Name: function_eebdfab2
	Namespace: zm_ai_spiders
	Checksum: 0x5A05079D
	Offset: 0x1408
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_eebdfab2()
{
	self endon(#"death");
	wait(randomfloatrange(3, 6));
	while(true)
	{
		self playsoundontag("zmb_spider_vocals_ambient", "tag_eye");
		wait(randomfloatrange(2, 6));
	}
}

/*
	Name: function_7609fd9
	Namespace: zm_ai_spiders
	Checksum: 0x8E406D16
	Offset: 0x1488
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function function_7609fd9()
{
	self waittill(#"death", e_attacker);
	if(function_c9adb887() == 0 && level.zombie_total == 0)
	{
		if(!isdefined(level.zm_ai_round_over) || [[level.zm_ai_round_over]]())
		{
			level.last_ai_origin = self.origin;
			level notify(#"last_ai_down", self);
		}
	}
	if(isplayer(e_attacker))
	{
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			e_attacker zm_score::player_add_points("death_spider");
		}
		if(isdefined(self.riotshield_death) && self.riotshield_death)
		{
			level notify(#"hash_92ad8590", e_attacker);
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](e_attacker, self);
		}
		e_attacker notify(#"player_killed_spider");
		e_attacker zm_stats::increment_client_stat("zspiders_killed");
		e_attacker zm_stats::increment_player_stat("zspiders_killed");
	}
	if(isdefined(e_attacker) && isai(e_attacker))
	{
		if(isdefined(e_attacker.var_5a513941) && e_attacker.var_5a513941)
		{
			level notify(#"hash_9218d45f", e_attacker);
		}
		e_attacker notify(#"killed", self);
	}
	if(isdefined(self))
	{
		self stoploopsound();
		self thread function_c3147dc1(self.origin);
	}
}

/*
	Name: function_c3147dc1
	Namespace: zm_ai_spiders
	Checksum: 0xCCA3AB52
	Offset: 0x16A8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_c3147dc1(v_pos)
{
	self thread fx::play("spider_gib", v_pos);
}

/*
	Name: function_2a424152
	Namespace: zm_ai_spiders
	Checksum: 0x79DFFECC
	Offset: 0x16E0
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function function_2a424152()
{
	level.var_3013498 = level.round_number + randomintrange(4, 7);
	level.var_5ccd3661 = level.var_3013498;
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	while(true)
	{
		level waittill(#"between_round_over");
		/#
			if(getdvarint("") > 0)
			{
				level.var_3013498 = level.round_number;
			}
		#/
		if(level.round_number == level.var_3013498)
		{
			level.sndmusicspecialround = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			function_9f7a20d2();
			level.round_spawn_func = &function_a2a299a1;
			level.round_wait_func = &function_872e306e;
			level.var_3013498 = level.round_number + randomintrange(4, 6);
			/#
				getplayers()[0] iprintln("" + level.var_3013498);
			#/
		}
		else if(level flag::get("spider_round"))
		{
			function_123b370a();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.var_6ea0fe2e = level.var_6ea0fe2e + 1;
		}
	}
}

/*
	Name: spider_round_fx
	Namespace: zm_ai_spiders
	Checksum: 0xF2FBFCCF
	Offset: 0x18E0
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function spider_round_fx()
{
	foreach(player in level.players)
	{
		player clientfield::increment_to_player("spider_round_fx");
		player clientfield::increment_to_player("spider_round_ring_fx");
	}
	visionset_mgr::activate("visionset", "zm_isl_parasite_spider_visionset", undefined, 1.5, &function_fad41aec, 2);
}

/*
	Name: function_fad41aec
	Namespace: zm_ai_spiders
	Checksum: 0xFDD0CD29
	Offset: 0x19D8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_fad41aec()
{
	level flag::wait_till_clear("spider_round_in_progress");
}

/*
	Name: function_a2a299a1
	Namespace: zm_ai_spiders
	Checksum: 0xB895DC88
	Offset: 0x1A08
	Size: 0x240
	Parameters: 0
	Flags: Linked
*/
function function_a2a299a1()
{
	level endon(#"intermission");
	level endon(#"end_of_round");
	level endon(#"restart_round");
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i].hunted_by = 0;
	}
	level endon(#"kill_round");
	/#
		if(getdvarint("") == 2 || getdvarint("") >= 4)
		{
			return;
		}
	#/
	if(level.intermission)
	{
		return;
	}
	level flag::set("spider_round_in_progress");
	level thread function_f602171e();
	array::thread_all(level.players, &function_cb42e438);
	wait(1);
	spider_round_fx();
	wait(4);
	var_c15d44e9 = function_67c1c842();
	/#
		if(getdvarstring("") != "")
		{
			var_c15d44e9 = getdvarint("");
		}
	#/
	level.zombie_total = var_c15d44e9;
	while(true)
	{
		while(level.zombie_total > 0)
		{
			if(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused)
			{
				util::wait_network_frame();
				continue;
			}
			function_45237f11();
			util::wait_network_frame();
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_67c1c842
	Namespace: zm_ai_spiders
	Checksum: 0xF975DBCD
	Offset: 0x1C50
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_67c1c842()
{
	if(level.var_6ea0fe2e < 3)
	{
		n_wave_count = level.players.size * 6;
	}
	else
	{
		n_wave_count = level.players.size * 8;
	}
	return n_wave_count;
}

/*
	Name: function_45237f11
	Namespace: zm_ai_spiders
	Checksum: 0x8F28C98D
	Offset: 0x1CA8
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function function_45237f11()
{
	while(!function_c1730af7())
	{
		wait(0.1);
	}
	s_spawn_loc = undefined;
	var_19764360 = get_favorite_enemy();
	if(!isdefined(var_19764360))
	{
		wait(randomfloatrange(0.3333333, 0.6666667));
		return;
	}
	if(isdefined(level.var_21f08627))
	{
		s_spawn_loc = [[level.var_21f08627]](var_19764360);
	}
	else
	{
		s_spawn_loc = function_570247b9(var_19764360);
	}
	if(!isdefined(s_spawn_loc))
	{
		wait(randomfloatrange(0.3333333, 0.6666667));
		return;
	}
	if(level flag::exists("spiders_from_mars_round") && level flag::get("spiders_from_mars_round") && isdefined(level.var_39b24700))
	{
		ai = zombie_utility::spawn_zombie(level.var_39b24700[0]);
	}
	else
	{
		ai = zombie_utility::spawn_zombie(level.var_c38a4fee[0]);
	}
	if(isdefined(ai))
	{
		s_spawn_loc thread function_49e57a3b(ai, s_spawn_loc);
		level.zombie_total--;
		level thread zm_spawner::zombie_death_event(ai);
		if(isdefined(level.var_2aacffb1))
		{
			ai thread [[level.var_2aacffb1]]();
		}
		function_1abf8192();
	}
}

/*
	Name: function_c1730af7
	Namespace: zm_ai_spiders
	Checksum: 0xC1D0BCA3
	Offset: 0x1EC0
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function function_c1730af7()
{
	var_621b3c65 = function_c9adb887();
	var_8817ee62 = var_621b3c65 >= 13;
	var_72a71294 = var_621b3c65 >= (level.players.size * 4);
	if(var_8817ee62 || var_72a71294 || !level flag::get("spawn_zombies"))
	{
		return false;
	}
	return true;
}

/*
	Name: function_c9adb887
	Namespace: zm_ai_spiders
	Checksum: 0xEBF80140
	Offset: 0x1F58
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function function_c9adb887()
{
	var_388bdc38 = getentarray("zombie_spider", "targetname");
	var_aa45da74 = var_388bdc38.size;
	foreach(var_c79d3f71 in var_388bdc38)
	{
		if(!isalive(var_c79d3f71))
		{
			var_aa45da74--;
		}
	}
	return var_aa45da74;
}

/*
	Name: function_872e306e
	Namespace: zm_ai_spiders
	Checksum: 0xC842299F
	Offset: 0x2038
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function function_872e306e()
{
	level endon(#"restart_round");
	level endon(#"kill_round");
	if(level flag::get("spider_round"))
	{
		level flag::wait_till("spider_round_in_progress");
		level flag::wait_till_clear("spider_round_in_progress");
	}
	level.sndmusicspecialround = 0;
}

/*
	Name: function_9f7a20d2
	Namespace: zm_ai_spiders
	Checksum: 0x23BBAD6D
	Offset: 0x20C0
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_9f7a20d2()
{
	level flag::set("spider_round");
	level flag::set("special_round");
	if(!isdefined(level.var_8276ee15))
	{
		level.var_8276ee15 = 0;
	}
	level.var_8276ee15 = 1;
	level notify(#"hash_f96039de");
	level thread zm_audio::sndmusicsystem_playstate("spider_roundstart");
	if(isdefined(level.var_9d7b5e00))
	{
		setdvar("ai_meleeRange", level.var_9d7b5e00);
	}
	else
	{
		setdvar("ai_meleeRange", 100);
	}
}

/*
	Name: function_123b370a
	Namespace: zm_ai_spiders
	Checksum: 0xC32408CB
	Offset: 0x21B0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_123b370a()
{
	level flag::clear("spider_round");
	level flag::clear("special_round");
	if(!isdefined(level.var_8276ee15))
	{
		level.var_8276ee15 = 0;
	}
	level.var_8276ee15 = 0;
	level notify(#"hash_daeb2e4f");
	setdvar("ai_meleeRange", level.melee_range_sav);
	setdvar("ai_meleeWidth", level.melee_width_sav);
	setdvar("ai_meleeHeight", level.melee_height_sav);
}

/*
	Name: function_1abf8192
	Namespace: zm_ai_spiders
	Checksum: 0x78D3E2DE
	Offset: 0x2290
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_1abf8192()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_default_wait = 2.25;
			break;
		}
		case 2:
		{
			n_default_wait = 2;
			break;
		}
		case 3:
		{
			n_default_wait = 1.75;
			break;
		}
		default:
		{
			n_default_wait = 1.5;
			break;
		}
	}
	wait(n_default_wait);
}

/*
	Name: function_6e19aa86
	Namespace: zm_ai_spiders
	Checksum: 0x6842D65
	Offset: 0x2320
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_6e19aa86()
{
	if(isdefined(level.var_718361fb))
	{
		level.var_fda270a4 = level.var_718361fb;
	}
	else
	{
		switch(level.var_6ea0fe2e)
		{
			case 1:
			{
				level.var_fda270a4 = 400;
				break;
			}
			case 2:
			{
				level.var_fda270a4 = 900;
				break;
			}
			case 3:
			{
				level.var_fda270a4 = 1300;
				break;
			}
			default:
			{
				level.var_fda270a4 = 1600;
				break;
			}
		}
		level.var_fda270a4 = int(level.var_fda270a4 * 0.5);
		if(level flag::exists("spiders_from_mars_round") && level flag::get("spiders_from_mars_round"))
		{
			level.var_fda270a4 = level.var_fda270a4 * 2;
		}
	}
}

/*
	Name: function_570247b9
	Namespace: zm_ai_spiders
	Checksum: 0x4D0EB201
	Offset: 0x2448
	Size: 0x2E8
	Parameters: 1
	Flags: Linked
*/
function function_570247b9(var_19764360)
{
	switch(level.players.size)
	{
		case 1:
		{
			var_3a613778 = 2500;
			var_e27d607a = 490000;
			break;
		}
		case 2:
		{
			var_3a613778 = 2500;
			var_e27d607a = 810000;
			break;
		}
		case 3:
		{
			var_3a613778 = 2500;
			var_e27d607a = 1000000;
			break;
		}
		case 4:
		{
			var_3a613778 = 2500;
			var_e27d607a = 1000000;
			break;
		}
		default:
		{
			var_3a613778 = 2500;
			var_e27d607a = 490000;
			break;
		}
	}
	if(isdefined(level.zm_loc_types["spider_location"]))
	{
		var_aa136cb0 = array::randomize(level.zm_loc_types["spider_location"]);
	}
	else
	{
		/#
			assertmsg("");
		#/
		return;
	}
	for(i = 0; i < var_aa136cb0.size; i++)
	{
		if(isdefined(level.var_fcbb5ce0) && level.var_fcbb5ce0 == var_aa136cb0[i])
		{
			continue;
		}
		n_dist_squared = distancesquared(var_aa136cb0[i].origin, var_19764360.origin);
		n_height_diff = abs(var_aa136cb0[i].origin[2] - var_19764360.origin[2]);
		if(n_dist_squared > var_3a613778 && n_dist_squared < var_e27d607a && n_height_diff < 128)
		{
			s_spawn_loc = function_4df33b5a(var_aa136cb0[i]);
			level.var_fcbb5ce0 = s_spawn_loc;
			return s_spawn_loc;
		}
	}
	s_spawn_loc = function_4df33b5a(arraygetclosest(var_19764360.origin, var_aa136cb0));
	level.var_fcbb5ce0 = s_spawn_loc;
	return s_spawn_loc;
}

/*
	Name: function_4df33b5a
	Namespace: zm_ai_spiders
	Checksum: 0x117F963A
	Offset: 0x2738
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_4df33b5a(s_spawn_loc)
{
	/#
		assert(isdefined(s_spawn_loc), "");
	#/
	var_8bf32428 = s_spawn_loc;
	var_8bf32428.origin = s_spawn_loc.origin + vectorscale((0, 0, 1), 16);
	return var_8bf32428;
}

/*
	Name: function_cb42e438
	Namespace: zm_ai_spiders
	Checksum: 0x46E19929
	Offset: 0x27B8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_cb42e438()
{
	self playlocalsound("zmb_raps_round_start");
}

/*
	Name: function_f602171e
	Namespace: zm_ai_spiders
	Checksum: 0x56F34428
	Offset: 0x27E8
	Size: 0x262
	Parameters: 0
	Flags: Linked
*/
function function_f602171e()
{
	level waittill(#"last_ai_down", e_enemy_ai);
	level thread zm_audio::sndmusicsystem_playstate("spider_roundend");
	if(isdefined(level.zm_override_ai_aftermath_powerup_drop))
	{
		[[level.zm_override_ai_aftermath_powerup_drop]](e_enemy_ai, level.last_ai_origin);
	}
	else
	{
		var_4a50cb2a = level.last_ai_origin;
		if(!ispointonnavmesh(var_4a50cb2a, e_enemy_ai))
		{
			var_4a50cb2a = getclosestpointonnavmesh(var_4a50cb2a, 100);
			if(!isdefined(var_4a50cb2a))
			{
				e_player = zm_utility::get_closest_player(level.last_ai_origin);
				var_4a50cb2a = e_player.origin;
			}
		}
		trace = groundtrace(var_4a50cb2a + vectorscale((0, 0, 1), 15), var_4a50cb2a + (vectorscale((0, 0, -1), 1000)), 0, undefined);
		var_4a50cb2a = trace["position"];
		if(isdefined(var_4a50cb2a))
		{
			level thread zm_powerups::specific_powerup_drop("full_ammo", var_4a50cb2a);
		}
	}
	wait(2);
	level.sndmusicspecialround = 0;
	if(isdefined(level.var_c102a998))
	{
		[[level.var_c102a998]]();
	}
	else
	{
		wait(6);
		level flag::clear("spider_round_in_progress");
		foreach(player in level.players)
		{
			player clientfield::increment_to_player("spider_end_of_round_reset", 1);
		}
	}
}

/*
	Name: get_favorite_enemy
	Namespace: zm_ai_spiders
	Checksum: 0x842589D
	Offset: 0x2A58
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function get_favorite_enemy()
{
	var_5a210579 = level.players;
	e_least_hunted = var_5a210579[0];
	for(i = 0; i < var_5a210579.size; i++)
	{
		if(!isdefined(var_5a210579[i].hunted_by))
		{
			var_5a210579[i].hunted_by = 0;
		}
		if(!zm_utility::is_player_valid(var_5a210579[i]))
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_least_hunted))
		{
			e_least_hunted = var_5a210579[i];
		}
		if(var_5a210579[i].hunted_by < e_least_hunted.hunted_by)
		{
			e_least_hunted = var_5a210579[i];
		}
	}
	e_least_hunted.hunted_by = e_least_hunted.hunted_by + 1;
	return e_least_hunted;
}

/*
	Name: function_f4bd92a2
	Namespace: zm_ai_spiders
	Checksum: 0x5782B6B4
	Offset: 0x2B98
	Size: 0x236
	Parameters: 2
	Flags: Linked
*/
function function_f4bd92a2(n_to_spawn, s_spawn_point)
{
	var_4b55c671 = getvehiclearray("zombie_spider", "targetname");
	if(isdefined(var_4b55c671) && var_4b55c671.size >= 9)
	{
		return 0;
	}
	if(!isdefined(n_to_spawn))
	{
		n_to_spawn = 1;
	}
	var_c46ed637 = 0;
	while(var_c46ed637 < n_to_spawn)
	{
		var_19764360 = get_favorite_enemy();
		if(isdefined(level.var_21f08627))
		{
			if(!isdefined(s_spawn_point))
			{
				s_spawn_point = [[level.var_21f08627]](level.var_c38a4fee, var_19764360);
			}
			ai = zombie_utility::spawn_zombie(level.var_c38a4fee[0]);
			if(isdefined(ai))
			{
				s_spawn_point thread function_49e57a3b(ai, s_spawn_point);
				level.zombie_total--;
				var_c46ed637++;
				level flag::set("spider_clips");
			}
		}
		else
		{
			if(!isdefined(s_spawn_point))
			{
				s_spawn_point = function_570247b9(var_19764360);
			}
			ai = zombie_utility::spawn_zombie(level.var_c38a4fee[0]);
			if(isdefined(ai))
			{
				s_spawn_point thread function_49e57a3b(ai, s_spawn_point);
				level.zombie_total--;
				var_c46ed637++;
				level flag::set("spider_clips");
			}
		}
		function_1abf8192();
	}
	if(isdefined(ai))
	{
		return ai;
	}
	return undefined;
}

/*
	Name: function_82b6256d
	Namespace: zm_ai_spiders
	Checksum: 0x7BF84D9B
	Offset: 0x2DD8
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function function_82b6256d()
{
	self waittill(#"death", e_attacker);
	self zm_spawner::check_zombie_death_event_callbacks(e_attacker);
	if(isplayer(e_attacker) && (isdefined(level.var_26af7b39) && level.var_26af7b39) && (isdefined(level.var_a5d2ba4) && level.var_a5d2ba4))
	{
		var_46927a7e = getent("apothicon_belly_center", "targetname");
		if(e_attacker istouching(var_46927a7e) && self istouching(var_46927a7e))
		{
			level notify(#"hash_ca3a841");
		}
	}
}

/*
	Name: function_df94945b
	Namespace: zm_ai_spiders
	Checksum: 0xC90B97BB
	Offset: 0x2ED0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_df94945b()
{
	self thread zm_spawner::enemy_death_detection();
	self.completed_emerging_into_playable_area = 1;
	self.ignore_zombie_lift = 1;
}

/*
	Name: function_5b625d74
	Namespace: zm_ai_spiders
	Checksum: 0x79476A02
	Offset: 0x2F10
	Size: 0x10C
	Parameters: 15
	Flags: Linked
*/
function function_5b625d74(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(isdefined(self.archetype) && self.archetype == "spider")
	{
		if(isdefined(eattacker))
		{
			if(isdefined(eattacker.team) && eattacker.team == self.team)
			{
				return 0;
			}
		}
		if(!(isdefined(self.next_shot_kills) && self.next_shot_kills))
		{
			self.next_shot_kills = 1;
		}
		else
		{
			return self.health;
		}
	}
	return idamage;
}

/*
	Name: function_49e57a3b
	Namespace: zm_ai_spiders
	Checksum: 0xD35E0191
	Offset: 0x3028
	Size: 0x6F0
	Parameters: 3
	Flags: Linked
*/
function function_49e57a3b(var_c79d3f71, ent = self, var_a79b986e = 0)
{
	var_c79d3f71 endon(#"death");
	if(!isdefined(ent.target) || var_a79b986e)
	{
		var_c79d3f71 ghost();
		var_c79d3f71 util::delay(0.2, "death", &show);
		var_c79d3f71 util::delay_notify(0.2, "visible", "death");
		var_c79d3f71.origin = ent.origin;
		var_c79d3f71.angles = ent.angles;
		var_c79d3f71 vehicle_ai::set_state("scripted");
		if(isalive(var_c79d3f71))
		{
			a_ground_trace = groundtrace(var_c79d3f71.origin + vectorscale((0, 0, 1), 100), var_c79d3f71.origin - vectorscale((0, 0, 1), 1000), 0, var_c79d3f71, 1);
			if(isdefined(a_ground_trace["position"]))
			{
				var_197f1988 = util::spawn_model("tag_origin", a_ground_trace["position"], var_c79d3f71.angles);
			}
			else
			{
				var_197f1988 = util::spawn_model("tag_origin", var_c79d3f71.origin, var_c79d3f71.angles);
			}
			var_197f1988 scene::play("scene_zm_dlc2_spider_burrow_out_of_ground", var_c79d3f71);
			state = "combat";
			if(randomfloat(1) > 0.6)
			{
				state = "meleeCombat";
			}
			var_c79d3f71 vehicle_ai::set_state(state);
			var_c79d3f71 setvisibletoall();
			var_c79d3f71 ai::set_ignoreme(0);
		}
	}
	else
	{
		var_c79d3f71 ai::set_ignoreall(0);
		var_c79d3f71.meleeattackdist = 64;
		var_c79d3f71.disablearrivals = 1;
		var_c79d3f71.disableexits = 1;
		var_c79d3f71 vehicle_ai::set_state("scripted");
		var_c79d3f71 notify(#"visible");
		var_ce7c81e4 = struct::get_array(ent.target, "targetname");
		var_ed41ff6b = array::random(var_ce7c81e4);
		if(isdefined(var_ed41ff6b) && isalive(var_c79d3f71))
		{
			var_ed41ff6b.script_play_multiple = 1;
			level scene::play(ent.target, var_c79d3f71);
		}
		else
		{
			var_36eb5144 = getvehiclenodearray(ent.target, "targetname");
			var_a8deb964 = array::random(var_36eb5144);
			var_c79d3f71 ghost();
			var_c79d3f71.var_75bf86b = spawner::simple_spawn_single("spider_mover_spawner");
			var_c79d3f71.origin = var_c79d3f71.var_75bf86b.origin;
			var_c79d3f71.angles = var_c79d3f71.var_75bf86b.angles;
			var_c79d3f71 linkto(var_c79d3f71.var_75bf86b);
			s_end = struct::get(var_a8deb964.target, "targetname");
			var_c79d3f71.var_75bf86b vehicle::get_on_path(var_a8deb964);
			var_c79d3f71 show();
			if(isdefined(var_a8deb964.script_int))
			{
				var_c79d3f71.var_75bf86b setspeed(var_a8deb964.script_int);
			}
			else
			{
				var_c79d3f71.var_75bf86b setspeed(20);
			}
			var_c79d3f71.var_75bf86b vehicle::go_path();
			var_c79d3f71 notify(#"hash_a81735f9");
			var_c79d3f71 unlink();
			var_c79d3f71.var_75bf86b delete();
		}
		earthquake(0.1, 0.5, var_c79d3f71.origin, 256);
		state = "combat";
		if(randomfloat(1) > 0.6)
		{
			state = "meleeCombat";
		}
		var_c79d3f71 vehicle_ai::set_state(state);
		var_c79d3f71.completed_emerging_into_playable_area = 1;
	}
}

/*
	Name: function_c685a92b
	Namespace: zm_ai_spiders
	Checksum: 0x74A5E5E4
	Offset: 0x3720
	Size: 0x54
	Parameters: 5
	Flags: Linked
*/
function function_c685a92b(damage, attacker, direction_vec, point, mod)
{
	if(mod == "MOD_EXPLOSIVE")
	{
		self thread function_81cf36fd();
	}
}

/*
	Name: function_81cf36fd
	Namespace: zm_ai_spiders
	Checksum: 0x52FB929B
	Offset: 0x3780
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_81cf36fd()
{
	self endon(#"death");
	if(!isdefined(self.var_7f8ad3ef))
	{
		self.var_7f8ad3ef = 0;
	}
	self.var_7f8ad3ef++;
	if(self.var_7f8ad3ef >= 4)
	{
		self shellshock("pain", 1);
	}
	self util::waittill_any_timeout(10, "death");
	self.var_7f8ad3ef--;
}

/*
	Name: function_d8cfc139
	Namespace: zm_ai_spiders
	Checksum: 0x6BC1FBC8
	Offset: 0x3818
	Size: 0x8C
	Parameters: 1
	Flags: None
*/
function function_d8cfc139(e_dest)
{
	self endon(#"death");
	var_366514d8 = util::spawn_model("tag_origin", self.origin, self.angles);
	var_366514d8 thread scene::play("scene_zm_dlc2_spider_web_engage", self);
	self waittill(#"web");
	self spit_projectile(e_dest);
}

/*
	Name: spit_projectile
	Namespace: zm_ai_spiders
	Checksum: 0x4FE0440B
	Offset: 0x38B0
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function spit_projectile(e_dest)
{
	v_origin = self gettagorigin("head_1");
	v_angles = self gettagangles("head_1");
	var_e9ad0294 = util::spawn_model("tag_origin", v_origin, v_angles);
	var_e9ad0294 thread fx::play("spider_web_spit_reweb", v_origin, v_angles, "movedone", 1);
	var_e9ad0294 moveto(e_dest.origin, 0.5);
	var_e9ad0294 waittill(#"movedone");
	var_e9ad0294 delete();
}

/*
	Name: function_7be01d65
	Namespace: zm_ai_spiders
	Checksum: 0xF300CE14
	Offset: 0x39D0
	Size: 0x11E
	Parameters: 1
	Flags: None
*/
function function_7be01d65(str_zone)
{
	e_zone = level.zones[str_zone];
	for(i = 0; i < e_zone.volumes.size; i++)
	{
		foreach(player in level.players)
		{
			if(zm_utility::is_player_valid(player, 0, 0) && player istouching(e_zone.volumes[i]))
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: function_3fd0c070
	Namespace: zm_ai_spiders
	Checksum: 0x445CB7C3
	Offset: 0x3AF8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_3fd0c070()
{
	/#
		level flagsys::wait_till("");
		zm_devgui::add_custom_devgui_callback(&function_8457e10f);
	#/
}

/*
	Name: function_8457e10f
	Namespace: zm_ai_spiders
	Checksum: 0x9DCB747E
	Offset: 0x3B48
	Size: 0x296
	Parameters: 1
	Flags: Linked
*/
function function_8457e10f(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				var_19764360 = get_favorite_enemy();
				s_spawn_point = function_570247b9(var_19764360);
				ai = zombie_utility::spawn_zombie(level.var_c38a4fee[0]);
				if(isdefined(ai) && isdefined(s_spawn_point))
				{
					s_spawn_point thread function_49e57a3b(ai, s_spawn_point);
				}
				break;
			}
			case "":
			{
				var_19764360 = get_favorite_enemy();
				s_spawn_point = function_570247b9(var_19764360);
				ai = zombie_utility::spawn_zombie(level.var_c38a4fee[0]);
				if(isdefined(ai) && isdefined(s_spawn_point))
				{
					s_spawn_point thread function_49e57a3b(ai, s_spawn_point, 1);
				}
				break;
			}
			case "":
			{
				a_enemies = getaiteamarray(level.zombie_team);
				if(a_enemies.size > 0)
				{
					foreach(e_enemy in a_enemies)
					{
						if(isdefined(e_enemy.b_is_spider) && e_enemy.b_is_spider)
						{
							e_enemy kill();
						}
					}
				}
				break;
			}
			case "":
			{
				level.var_3013498 = level.round_number + 1;
				zm_devgui::zombie_devgui_goto_round(level.var_3013498);
				break;
			}
			case "":
			{
				level.var_42034f6a = 100;
				break;
			}
		}
	#/
}

