// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\cp_doa_bo3_enemy;
#using scripts\cp\cp_doa_bo3_fx;
#using scripts\cp\cp_doa_bo3_sound;
#using scripts\cp\doa\_doa_arena;
#using scripts\cp\doa\_doa_chicken_pickup;
#using scripts\cp\doa\_doa_core;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_enemy;
#using scripts\cp\doa\_doa_enemy_boss;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_hazard;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\cp\doa\_doa_round;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace namespace_a3646565;

/*
	Name: init
	Namespace: namespace_a3646565
	Checksum: 0x12AF5DB3
	Offset: 0xD58
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(!isdefined(level.doa.var_55dddb3a))
	{
		level.doa.var_55dddb3a = getent("doa_silverback_spawner", "targetname");
	}
	level.doa.var_5f57a68d = getent("doa_spawner_parasite", "targetname");
	level.doa.var_b5aef19c = getent("doa_spawner_purple_parasite", "targetname");
	level.doa.var_4f253f44 = getent("boss_mech", "targetname");
	level.doa.var_4f253f44.count = 999999;
	level.doa.var_155f5b81 = [];
	level.doa.var_22c9944 = [];
	level.doa.var_7b9808fc = 0;
	level.doa.var_635342b0 = getent("fido_egg", "targetname");
	level.doa.var_635342b0 show();
}

/*
	Name: function_d8e6314c
	Namespace: namespace_a3646565
	Checksum: 0x39D2DA32
	Offset: 0xEF0
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function function_d8e6314c()
{
	foreach(var_2e488485 in level.doa.var_155f5b81)
	{
		if(isdefined(var_2e488485))
		{
			var_2e488485 delete();
		}
	}
	if(isdefined(level.doa.var_6fb37836))
	{
		level.doa.var_6fb37836 delete();
	}
	if(isdefined(level.doa.var_2775f29c))
	{
		level.doa.var_2775f29c delete();
	}
	if(isdefined(level.doa.var_17593d0e))
	{
		level.doa.var_17593d0e delete();
	}
	level thread doa_pickups::function_c1869ec8();
	level thread doa_utility::clearallcorpses();
	level thread namespace_d88e3a06::function_116bb43();
	level flag::clear("doa_game_silverback_round");
	level flag::clear("doa_round_abort");
}

/*
	Name: function_f35c54a
	Namespace: namespace_a3646565
	Checksum: 0x128BA027
	Offset: 0x10C8
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function function_f35c54a()
{
	level endon(#"hash_593b80cb");
	level waittill(#"doa_game_is_over");
	function_d8e6314c();
}

/*
	Name: function_8b1dfb44
	Namespace: namespace_a3646565
	Checksum: 0x1A1A350A
	Offset: 0x1100
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_8b1dfb44()
{
	self namespace_cdb9a8fe::function_fe0946ac();
}

/*
	Name: function_fc48f9f3
	Namespace: namespace_a3646565
	Checksum: 0xC706525A
	Offset: 0x1128
	Size: 0xFF4
	Parameters: 0
	Flags: Linked
*/
function function_fc48f9f3()
{
	level endon(#"doa_game_is_over");
	init();
	level flag::set("doa_round_paused");
	flag::set("doa_round_active");
	/#
		if(level.doa.round_number < 64)
		{
			level.doa.round_number = 64;
			level.doa.zombie_move_speed = level.doa.zombie_move_speed + (level.doa.round_number * level.doa.var_c9e1c854);
			level.doa.zombie_health = level.doa.zombie_health + (level.doa.round_number * level.doa.zombie_health_inc);
			namespace_d88e3a06::function_7a8a936b();
			namespace_cdb9a8fe::function_691ef36b();
			namespace_cdb9a8fe::function_703bb8b2(level.doa.round_number);
		}
	#/
	level thread namespace_cdb9a8fe::function_87703158(1);
	var_e5c8b9e7 = level.doa.var_bc9b7c71;
	level.doa.var_bc9b7c71 = &function_8b1dfb44;
	foreach(player in namespace_831a4a7c::function_5eb6e4d1())
	{
		player notify(#"hash_d28ba89d");
	}
	level thread doa_utility::function_c5f3ece8(&"DOA_BOSS", undefined, 6, (1, 0, 0));
	level.voice playsound("vox_doaa_boss_fight");
	level notify(#"hash_ba37290e", "bossbattle");
	wait(1);
	level thread doa_utility::function_37fb5c23(&"CP_DOA_BO3_SILVERBACK_LAIR", undefined, 5, (1, 0, 0));
	if(getdvarint("scr_boss_silverback_mech_enabled", 0))
	{
		level clientfield::set("cameraHeight", 2);
		var_60de7d19 = namespace_3ca3c537::function_61d60e0b();
		loc = spawnstruct();
		loc.angles = (0, 0, 0);
		loc.origin = var_60de7d19 + vectorscale((0, 0, 1), 3000);
		mech = level.doa.var_4f253f44 spawner::spawn(1);
		mech.origin = loc.origin;
		mech.boss = 1;
		mech enablelinkto();
		mech.driver = spawn("script_model", mech gettagorigin("tag_driver"));
		mech.driver.targetname = "mechDrive";
		mech.driver setmodel("c_rus_simianaut_body");
		mech.driver linkto(mech, "tag_driver");
		mech.health = getdvarint("scr_boss_silverback_mech_health", 200000);
		mech.maxhealth = getdvarint("scr_boss_silverback_mech_health", 200000);
		mech clientfield::set("camera_focus_item", 1);
		org = spawn("script_model", loc.origin);
		org.targetname = "mechOrg";
		org setmodel("tag_origin");
		mech linkto(org);
		org thread namespace_eaa992c::function_285a2999("def_explode");
		org thread namespace_eaa992c::function_285a2999("fire_trail");
		org moveto(var_60de7d19, 2);
		org util::waittill_any_timeout(3, "movedone");
		mech unlink();
		org delete();
		level clientfield::set("cameraHeight", 0);
	}
	foreach(player in namespace_831a4a7c::function_5eb6e4d1())
	{
		player freezecontrols(0);
	}
	if(getdvarint("scr_boss_silverback_mech_enabled", 0))
	{
		level clientfield::set("activateBanner", 6);
		level thread function_28eb6914(mech);
		level thread function_a733cd6a(mech);
		level waittill(#"hash_885b3b5e");
	}
	var_3d99e7a6 = math::clamp(1 + level.doa.var_da96f13c, 1, 10);
	while(var_3d99e7a6)
	{
		var_3d99e7a6--;
		level thread function_b90daa04(var_3d99e7a6);
	}
	level waittill(#"hash_d29de2a8");
	level flag::set("doa_game_silverback_round");
	level.var_172ed9a1 = [];
	level flag::clear("doa_round_paused");
	level thread function_b4195d47();
	level function_72e0a286();
	level notify(#"hash_a95298f3");
	level.doa.var_677d1262 = 0;
	level clientfield::set("activateBanner", 0);
	level.doa.boss = undefined;
	level flag::set("doa_round_abort");
	level flag::clear("doa_round_active");
	if(isdefined(level.doa.var_2c8bf5cd))
	{
		foreach(margwa in level.doa.var_2c8bf5cd)
		{
			margwa kill(margwa.origin);
		}
	}
	doa_utility::function_1ced251e();
	level thread doa_utility::function_c5f3ece8(&"CP_DOA_BO3_SILVERBACK_DEFEATED", undefined, 6, (1, 0, 0));
	wait(4);
	foreach(player in getplayers())
	{
		if(isdefined(player.doa.var_1f7cae53))
		{
			player namespace_64c6b720::function_80eb303(player.doa.var_1f7cae53, 1);
		}
		player.doa.var_1f7cae53 = 0;
	}
	level thread doa_utility::function_37fb5c23(&"CP_DOA_BO3_SILVERBACK_DEFEATED2", undefined, 5, (1, 0, 0));
	wait(6.5);
	doa_utility::function_44eb090b();
	level.doa.var_635342b0 hide();
	array::thread_all(getplayers(), &namespace_831a4a7c::function_82e3b1cb);
	level thread doa_pickups::function_c1869ec8();
	level thread doa_utility::clearallcorpses();
	if(isdefined(level.doa.var_6fb37836))
	{
		level.doa.var_6fb37836 delete();
	}
	egg = spawn("script_model", namespace_3ca3c537::function_61d60e0b() + vectorscale((0, 0, 1), 48));
	egg.targetname = "fido";
	egg setmodel("zombietron_eggxl");
	level thread doa_pickups::spawnmoneyglob(0, 10, 0.1);
	level thread doa_pickups::spawnmoneyglob(1, 15, randomfloatrange(2, 4));
	var_249f9545 = struct::get_array("boss_player_end_spot");
	i = 0;
	foreach(player in getplayers())
	{
		player namespace_cdb9a8fe::function_fe0946ac(var_249f9545[i].origin);
		player thread namespace_831a4a7c::function_f2507519(0);
		i++;
	}
	level doa_utility::set_lighting_state(2);
	level clientfield::increment("killweather");
	doa_utility::function_390adefe();
	function_a753035a(egg);
	level thread doa_utility::function_c5f3ece8(&"CP_DOA_BO3_FIDO_SAVED", undefined, 6, (1, 1, 0));
	wait(4);
	level thread doa_utility::function_37fb5c23(&"CP_DOA_BO3_FIDO_SAVED2", undefined, 5, (1, 1, 0));
	wait(6.5);
	level.var_de693c3 = 0;
	namespace_3ca3c537::function_4586479a(0);
	function_d8e6314c();
	level thread function_14ba3248();
	foreach(player in getplayers())
	{
		player thread namespace_693feb87::initialblack(24);
	}
	lui::play_movie("cp_doa_bo3_endgame", "fullscreen", 1);
	level notify(#"hash_629939b8");
	level flag::set("doa_game_is_completed");
	level.doa.var_635342b0 show();
	level.doa.arena_round_number = 0;
	level clientfield::set("arenaRound", level.doa.arena_round_number);
	level thread util::set_lighting_state(level.doa.arena_round_number);
	namespace_3ca3c537::function_5af67667(level.doa.current_arena + 1);
	level.doa.var_bc9b7c71 = var_e5c8b9e7;
	level.var_de693c3 = 1;
}

/*
	Name: function_14ba3248
	Namespace: namespace_a3646565
	Checksum: 0x97D0FBB3
	Offset: 0x2128
	Size: 0xAA
	Parameters: 0
	Flags: Linked, Private
*/
function private function_14ba3248()
{
	level endon(#"hash_629939b8");
	wait(16);
	foreach(player in getplayers())
	{
		player notify(#"menuresponse", "FullscreenMovie", "finished_movie_playback");
	}
}

/*
	Name: function_72e0a286
	Namespace: namespace_a3646565
	Checksum: 0x90E5A4B7
	Offset: 0x21E0
	Size: 0x10A
	Parameters: 0
	Flags: Linked, Private
*/
function private function_72e0a286()
{
	level endon(#"hash_a95298f3");
	while(true)
	{
		wait(1);
		valid = [];
		foreach(var_2e488485 in level.doa.var_155f5b81)
		{
			if(isdefined(var_2e488485) && var_2e488485.health > 0)
			{
				valid[valid.size] = var_2e488485;
			}
		}
		level.doa.var_155f5b81 = valid;
		if(level.doa.var_155f5b81.size == 0)
		{
			return;
		}
	}
}

/*
	Name: function_b4195d47
	Namespace: namespace_a3646565
	Checksum: 0x46ECC72A
	Offset: 0x22F8
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_b4195d47()
{
	level thread function_28eb6914();
	level clientfield::set("activateBanner", 5);
}

/*
	Name: function_28eb6914
	Namespace: namespace_a3646565
	Checksum: 0x235F7C5D
	Offset: 0x2340
	Size: 0x27E
	Parameters: 1
	Flags: Linked
*/
function function_28eb6914(ent)
{
	level notify(#"hash_28eb6914");
	level endon(#"hash_28eb6914");
	level endon(#"doa_game_is_over");
	level endon(#"hash_a95298f3");
	level clientfield::set("pumpBannerBar", 0);
	util::wait_network_frame();
	level clientfield::set("pumpBannerBar", 1);
	if(isdefined(ent))
	{
		ent endon(#"death");
		while(true)
		{
			lasthealth = ent.health;
			ent waittill(#"damage", damage, attacker);
			data = doa_utility::clamp(ent.health / ent.maxhealth, 0, 1);
			level clientfield::set("pumpBannerBar", data);
		}
	}
	else
	{
		while(level.doa.var_155f5b81.size)
		{
			var_9386082f = 0;
			foreach(var_2e488485 in level.doa.var_155f5b81)
			{
				if(!isdefined(var_2e488485))
				{
					continue;
				}
				var_9386082f = var_9386082f + var_2e488485.health;
			}
			data = doa_utility::clamp(var_9386082f / level.doa.var_7b9808fc, 0, 1);
			level clientfield::set("pumpBannerBar", data);
			wait(1);
		}
	}
}

/*
	Name: function_eb6ee9e0
	Namespace: namespace_a3646565
	Checksum: 0xC1DCC01B
	Offset: 0x25C8
	Size: 0x4C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_eb6ee9e0()
{
	level endon(#"doa_game_is_over");
	self waittill(#"death");
	level notify(#"hash_ae3ed999");
	level clientfield::set("activateBanner", 0);
}

/*
	Name: function_b90daa04
	Namespace: namespace_a3646565
	Checksum: 0x71426739
	Offset: 0x2620
	Size: 0x67C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_b90daa04(delay)
{
	level endon(#"doa_game_is_over");
	level endon(#"hash_a95298f3");
	if(delay)
	{
		wait(delay * 30);
	}
	spawnloc = doa_utility::function_308fa126(6);
	spot = spawnloc[randomint(spawnloc.size)];
	org = spawn("script_model", spot);
	org.targetname = "_silverbackGroundSpawn";
	org setmodel("tag_origin");
	org2 = spawn("script_origin", spot + vectorscale((0, 0, 1), 2500));
	org2.targetname = "_silverbackGroundSpawn2";
	org thread doa_utility::function_75e76155(level, "doa_game_is_over");
	org thread doa_utility::function_75e76155(level, "all_silverbacks_dead");
	org2 thread doa_utility::function_75e76155(level, "doa_game_is_over");
	org2 thread doa_utility::function_75e76155(level, "all_silverbacks_dead");
	player = getplayers()[0];
	if(isdefined(player))
	{
		org.angles = vectortoangles(getplayers()[0].origin - org.origin);
	}
	else
	{
		org.angles = (0, 0, 0);
	}
	playsoundatposition("zmb_ape_prespawn", org.origin);
	org thread namespace_eaa992c::function_285a2999("silverback_intro");
	wait(0.5);
	org thread namespace_eaa992c::function_285a2999("silverback_intro");
	org thread namespace_eaa992c::function_285a2999("stoneboss_shield_explode");
	wait(0.5);
	org thread namespace_eaa992c::function_285a2999("silverback_intro");
	org thread namespace_eaa992c::function_285a2999("stoneboss_shield_explode");
	wait(0.5);
	wait(getdvarfloat("scr_boss_silverback_intro_time", 1));
	silverback = namespace_51bd792::function_36aa8b6c(org2);
	silverback linkto(org2);
	silverback thread namespace_eaa992c::function_285a2999("player_trail_red");
	silverback thread namespace_eaa992c::function_285a2999("silverback_intro_trail1");
	silverback thread namespace_eaa992c::function_285a2999("silverback_intro_trail2");
	silverback thread function_b8a39218();
	player = namespace_831a4a7c::function_5eb6e4d1()[0];
	if(isdefined(player))
	{
		anim_ang = vectortoangles(player.origin - org2.origin);
		org2 rotateto((0, anim_ang[1], 0), 0.75);
	}
	org2 moveto(org.origin, 1);
	org2 util::waittill_any_timeout(2, "movedone");
	silverback unlink();
	silverback thread namespace_eaa992c::function_285a2999("silverback_intro_explo");
	silverback thread namespace_eaa992c::turnofffx("silverback_intro_trail1");
	silverback thread namespace_eaa992c::turnofffx("silverback_intro_trail2");
	playrumbleonposition("explosion_generic", org.origin);
	playsoundatposition("zmb_ape_spawn", org.origin);
	silverback.aioverridedamage = &function_ae39e30a;
	level.doa.var_155f5b81[level.doa.var_155f5b81.size] = silverback;
	silverback thread function_19b9f1d6();
	silverback thread namespace_4973e019::function_ce73145c();
	level notify(#"hash_d29de2a8");
	level.doa.var_7b9808fc = level.doa.var_7b9808fc + silverback.health;
	wait(1);
	org delete();
	org2 delete();
}

/*
	Name: function_b8a39218
	Namespace: namespace_a3646565
	Checksum: 0x127122D9
	Offset: 0x2CA8
	Size: 0x182
	Parameters: 0
	Flags: Linked
*/
function function_b8a39218()
{
	level endon(#"hash_593b80cb");
	level endon(#"doa_game_is_over");
	self waittill(#"death");
	players = getplayers();
	foreach(player in players)
	{
		if(!isdefined(player.doa))
		{
			continue;
		}
		if(!isdefined(player.doa.var_53bd6cfa))
		{
			player.doa.var_53bd6cfa = 0;
			player.doa.var_52e89a72 = 0;
		}
		player.doa.var_53bd6cfa = player.doa.var_53bd6cfa + 1;
		player.doa.var_52e89a72 = player.doa.var_52e89a72 + 1;
	}
}

/*
	Name: function_ae39e30a
	Namespace: namespace_a3646565
	Checksum: 0x1CA00C33
	Offset: 0x2E38
	Size: 0x1B8
	Parameters: 15
	Flags: Linked
*/
function function_ae39e30a(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, modelindex, surfacetype, surfacenormal)
{
	if(isdefined(eattacker) && isplayer(eattacker))
	{
		if(!isdefined(eattacker.doa.var_1f7cae53))
		{
			eattacker.doa.var_1f7cae53 = 0;
		}
		eattacker.doa.var_1f7cae53 = eattacker.doa.var_1f7cae53 + (int(idamage * 0.2));
	}
	if(isdefined(einflictor) && einflictor.team == self.team)
	{
		idamage = 0;
	}
	if(isdefined(eattacker) && eattacker.team == self.team)
	{
		idamage = 0;
	}
	/#
		doa_utility::debugmsg((("" + self.targetname) + "") + (self.health - idamage));
	#/
	return idamage;
}

/*
	Name: function_a733cd6a
	Namespace: namespace_a3646565
	Checksum: 0x66AA62ED
	Offset: 0x2FF8
	Size: 0x150
	Parameters: 1
	Flags: Linked, Private
*/
function private function_a733cd6a(mech)
{
	level endon(#"doa_game_is_over");
	level.doa.var_6fb37836 = mech;
	mech endon(#"death");
	mech thread function_eb6ee9e0();
	level thread function_c64a860f(mech.driver);
	mech.driver thread function_fb3b78fe();
	if(!isdefined(mech.maxhealth))
	{
		mech.maxhealth = mech.health;
	}
	while(mech.health > 0)
	{
		/#
			if(getdvarint("", 0))
			{
				self dodamage(int(mech.maxhealth * 0.01), mech.origin);
			}
		#/
		wait(0.05);
	}
}

/*
	Name: function_fb3b78fe
	Namespace: namespace_a3646565
	Checksum: 0x4DC976C4
	Offset: 0x3150
	Size: 0x15E
	Parameters: 0
	Flags: Linked
*/
function function_fb3b78fe()
{
	self endon(#"death");
	level endon(#"hash_ae3ed999");
	self.var_15a6bfe6 = 0;
	self useanimtree($generic);
	while(true)
	{
		if(isdefined(self.damagedplayer) && self.damagedplayer && self.damagedplayer < (gettime() + 1500))
		{
			if(self.var_15a6bfe6 > gettime())
			{
				wait(0.05);
				continue;
			}
			self.var_15a6bfe6 = gettime() + randomintrange(5000, 15000);
			self animscripted("mech_taunt", self.origin, self.angles, "ai_zombie_doa_simianaut_mech_idle_taunt");
			self waittillmatch(#"hash_3b8ce577");
		}
		else
		{
			self animscripted("mech_idle", self.origin, self.angles, "ai_zombie_doa_simianaut_mech_idle");
			self waittillmatch(#"hash_4b135fff");
		}
	}
}

/*
	Name: function_c64a860f
	Namespace: namespace_a3646565
	Checksum: 0xA1DD2230
	Offset: 0x32B8
	Size: 0x25A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_c64a860f(driver)
{
	level endon(#"doa_game_is_over");
	level waittill(#"hash_ae3ed999");
	driver playsound("zmb_simianaut_roar");
	driver animscripted("mech_eject", driver.origin, driver.angles, "ai_zombie_doa_simianaut_mech_idle_eject");
	driver waittillmatch(#"hash_165e6714");
	loc = spawnstruct();
	loc.angles = (0, 0, 0);
	loc.origin = driver.origin;
	org = spawn("script_model", driver.origin);
	org.targetname = "_monkeyEjectionSeat";
	org setmodel("tag_origin");
	driver linkto(org);
	driver thread namespace_eaa992c::function_285a2999("def_explode");
	driver thread namespace_eaa992c::function_285a2999("silverback_intro_trail1");
	driver thread namespace_eaa992c::function_285a2999("silverback_intro_trail2");
	org moveto(org.origin + vectorscale((0, 0, 1), 3000), 2);
	org util::waittill_any_timeout(3, "movedone");
	driver delete();
	org delete();
	level notify(#"hash_885b3b5e", "eject");
}

/*
	Name: function_19b9f1d6
	Namespace: namespace_a3646565
	Checksum: 0x4DFA7756
	Offset: 0x3520
	Size: 0xC8
	Parameters: 0
	Flags: Linked, Private
*/
function private function_19b9f1d6()
{
	level endon(#"doa_game_is_over");
	self.var_d3627554 = int(self.health * 0.8);
	self.var_b220d777 = int(self.health * 0.5);
	self.var_e6ea564a = int(self.health * 0.2);
	self.takedamage = 1;
	self function_ec5c4c1c();
	self waittill(#"death");
}

/*
	Name: function_162d9658
	Namespace: namespace_a3646565
	Checksum: 0x44354F9B
	Offset: 0x35F0
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function function_162d9658(params)
{
}

/*
	Name: function_695a39c6
	Namespace: namespace_a3646565
	Checksum: 0x24E63246
	Offset: 0x3608
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function function_695a39c6(params)
{
}

/*
	Name: function_6441ddee
	Namespace: namespace_a3646565
	Checksum: 0x4CDAD002
	Offset: 0x3620
	Size: 0xAE
	Parameters: 1
	Flags: Linked
*/
function function_6441ddee(ent)
{
	if(!isdefined(ent))
	{
		return false;
	}
	if(!isplayer(ent))
	{
		return false;
	}
	if(isdefined(ent.doa) && isdefined(ent.doa.vehicle))
	{
		return false;
	}
	safezone = namespace_3ca3c537::function_dc34896f();
	if(!ent istouching(safezone))
	{
		return false;
	}
	return true;
}

/*
	Name: function_3cc9ed44
	Namespace: namespace_a3646565
	Checksum: 0x240B8186
	Offset: 0x36D8
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_3cc9ed44()
{
	self endon(#"death");
	safezone = namespace_3ca3c537::function_dc34896f();
	failures = 0;
	while(true)
	{
		wait(1);
		if(!self istouching(safezone))
		{
			if(isdefined(self.launching) && self.launching)
			{
				continue;
			}
			else
			{
				failures++;
			}
			if(failures > 5)
			{
				self.oob = 1;
			}
		}
		else
		{
			failures = 0;
			self.oob = undefined;
		}
	}
}

/*
	Name: function_ec5c4c1c
	Namespace: namespace_a3646565
	Checksum: 0xE794EA16
	Offset: 0x37A8
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function function_ec5c4c1c(params)
{
	level endon(#"doa_game_is_over");
	self playsound("zmb_simianaut_roar");
	self animscripted("pissedoff", self.origin, self.angles, "ai_zombie_doa_simianaut_ground_pound");
	self waittillmatch(#"pissedoff");
	playfx(level._effect["ground_pound"], self.origin);
	self waittillmatch(#"pissedoff");
	self playsound("zmb_simianaut_roar");
	self thread function_f61639be();
	self thread function_a3a6c6d0();
	self thread function_c8f8a134();
	self thread function_b3eb3a0b();
	self thread function_47e8d1a6();
	self thread function_2fd43405();
	self thread function_3cc9ed44();
}

/*
	Name: function_2fd43405
	Namespace: namespace_a3646565
	Checksum: 0xF3DA0009
	Offset: 0x3938
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function function_2fd43405()
{
	self endon(#"death");
	if(!isdefined(self.maxhealth))
	{
		self.maxhealth = self.health;
	}
	self.var_d3627554 = int(self.health) * 0.75;
	self.var_b220d777 = int(self.health) * 0.5;
	self.var_e6ea564a = int(self.health) * 0.25;
	self.var_b96cf2ea = 0;
	while(true)
	{
		lasthealth = self.health;
		self waittill(#"damage");
		if(lasthealth > self.var_d3627554 && self.health <= self.var_d3627554)
		{
			self.var_b96cf2ea = self.var_b96cf2ea + 2;
		}
		if(lasthealth > self.var_b220d777 && self.health <= self.var_b220d777)
		{
			self.var_b96cf2ea = self.var_b96cf2ea + 2;
		}
		if(lasthealth > self.var_e6ea564a && self.health <= self.var_e6ea564a)
		{
			self.var_b96cf2ea = self.var_b96cf2ea + 4;
		}
	}
}

/*
	Name: function_47e8d1a6
	Namespace: namespace_a3646565
	Checksum: 0x3941A14C
	Offset: 0x3AC8
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_47e8d1a6()
{
	if(getdvarint("scr_doa_soak_think", 0))
	{
		self endon(#"death");
		if(!isdefined(self.maxhealth))
		{
			self.maxhealth = self.health;
		}
		while(true)
		{
			self dodamage(int(self.maxhealth * 0.05), self.origin);
			if(getdvarint("scr_doa_soak_think", 0) > 1)
			{
				wait(5);
			}
			else
			{
				wait(60);
			}
		}
	}
}

/*
	Name: function_c8f8a134
	Namespace: namespace_a3646565
	Checksum: 0xFBFC4FEC
	Offset: 0x3B90
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_c8f8a134()
{
	self endon(#"death");
	self function_f98533fb("run");
	while(true)
	{
		wait(1);
		if(isdefined(self.var_9d1f3352))
		{
			wait(self.var_9d1f3352);
		}
		self.var_9d1f3352 = undefined;
		self function_f98533fb("run");
	}
}

/*
	Name: function_f98533fb
	Namespace: namespace_a3646565
	Checksum: 0x217AF03B
	Offset: 0x3C10
	Size: 0xCC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_f98533fb(rate)
{
	if(rate == "walk")
	{
		self.zombie_move_speed = "walk";
		self asmsetanimationrate(1);
	}
	else
	{
		if(rate == "run")
		{
			self.zombie_move_speed = "run";
			self asmsetanimationrate(0.98);
		}
		else if(rate == "sprint")
		{
			self.zombie_move_speed = "sprint";
			self asmsetanimationrate(0.96);
		}
	}
}

/*
	Name: function_f5afb415
	Namespace: namespace_a3646565
	Checksum: 0x90793026
	Offset: 0x3CE8
	Size: 0x51C
	Parameters: 2
	Flags: Linked
*/
function function_f5afb415(var_b84274b8, numattacks = 1)
{
	self endon(#"death");
	self playsound("zmb_simianaut_roar");
	self animscripted("pissedoff", self.origin, self.angles, "ai_zombie_doa_simianaut_taunt");
	self waittillmatch(#"pissedoff");
	sqr64 = 64 * 64;
	var_b84274b8.angles = self.angles;
	var_b84274b8.origin = self.origin;
	self linkto(var_b84274b8);
	while(numattacks && isdefined(self.enemy))
	{
		numattacks--;
		targetorigin = self.enemy.origin;
		anim_ang = vectortoangles(targetorigin - self.origin);
		var_b84274b8 rotateto((0, anim_ang[1], 0), 0.5);
		var_b84274b8 waittill(#"rotatedone");
		self playsound("zmb_speed_boost_activate_boss");
		playrumbleonposition("explosion_generic", self.origin);
		dist = distance(targetorigin, self.origin) + 256;
		forward = anglestoforward(var_b84274b8.angles);
		targetspot = var_b84274b8.origin + (forward * dist);
		trace = bullettrace(var_b84274b8.origin + vectorscale((0, 0, 1), 30), targetspot + vectorscale((0, 0, 1), 30), 0, undefined);
		targetspot = trace["position"] + (forward * -64);
		distsq = distancesquared(var_b84274b8.origin, targetspot);
		var_65ef86fe = math::clamp(int(distsq / sqr64), 1, 9999);
		traveltime = math::clamp(var_65ef86fe * getdvarfloat("scr_boss_silverback_travel_time64", 0.005), 0, 0.7);
		if(getdvarint("scr_boss_debug_boost", 0))
		{
			level thread doa_utility::debug_circle(targetspot + vectorscale((0, 0, 1), 20), 30, 3, (1, 0, 0));
			level thread doa_utility::debug_line(targetspot + vectorscale((0, 0, 1), 20), self.origin + vectorscale((0, 0, 1), 20), 3, (1, 0, 0));
			var_b84274b8 thread doa_utility::debugorigin(3, 20, (1, 0, 0));
		}
		var_b84274b8 thread function_df12b0c9(self.enemy);
		self.boosting = 1;
		var_b84274b8 moveto(targetspot, traveltime);
		var_b84274b8 util::waittill_any_timeout(traveltime + 2, "movedone");
		self.boosting = undefined;
		var_b84274b8 notify(#"hash_7018a851", "end");
		if(getdvarint("scr_boss_debug_boost", 0))
		{
			var_b84274b8 notify(#"hash_c32e3b78");
		}
	}
	self unlink();
	self stopanimscripted();
}

/*
	Name: function_615e73a
	Namespace: namespace_a3646565
	Checksum: 0xAD883CE2
	Offset: 0x4210
	Size: 0x4D0
	Parameters: 2
	Flags: Linked
*/
function function_615e73a(var_b84274b8, numattacks = 1)
{
	self endon(#"death");
	self playsound("zmb_simianaut_roar");
	self animscripted("pissedoff", self.origin, self.angles, "ai_zombie_doa_simianaut_taunt");
	self waittillmatch(#"pissedoff");
	while(numattacks)
	{
		numattacks--;
		players = namespace_831a4a7c::function_5eb6e4d1();
		if(players.size == 1)
		{
			self.favoriteenemy = players[0];
		}
		else
		{
			if(isdefined(self.enemy))
			{
				arrayremovevalue(players, self.enemy);
			}
			if(players.size == 1)
			{
				self.favoriteenemy = players[0];
			}
			else
			{
				self.favoriteenemy = players[randomint(players.size)];
			}
		}
		if(isdefined(self.favoriteenemy) && function_6441ddee(self.favoriteenemy))
		{
			targetpos = self.favoriteenemy.origin;
		}
		if(!isdefined(targetpos))
		{
			continue;
		}
		self playsound("evt_turret_takeoff");
		self thread namespace_eaa992c::function_285a2999("boss_takeoff");
		self thread namespace_eaa992c::function_285a2999("crater_dust");
		playrumbleonposition("explosion_generic", self.origin);
		height = 800;
		timems = (height / 1000) * 3000;
		var_b84274b8.angles = self.angles;
		var_b84274b8.origin = self.origin;
		self linkto(var_b84274b8);
		if(getdvarint("scr_boss_debug_launch", 0))
		{
			level thread doa_utility::debug_circle(targetpos + vectorscale((0, 0, 1), 20), 30, 3, (1, 0, 0));
			var_b84274b8 thread doa_utility::debugorigin(3, 20, (1, 0, 0));
		}
		var_b84274b8 thread function_df12b0c9(self.enemy);
		self thread function_5659ec29("move_to_pos_downward_cycle");
		var_b84274b8 move_to_position_over_time(targetpos, timems, height);
		self unlink();
		self playsound("zmb_simianaut_roar");
		self animscripted("pissedoff", self.origin, self.angles, "ai_zombie_doa_simianaut_attack_v1");
		self waittillmatch(#"pissedoff");
		if(isdefined(self.var_a09d9abe))
		{
			self.var_a09d9abe unlink();
			self.var_a09d9abe = undefined;
		}
		var_b84274b8 notify(#"hash_7018a851", "fire", "end");
		if(getdvarint("scr_boss_debug_launch", 0))
		{
			var_b84274b8 notify(#"hash_c32e3b78");
		}
		self thread namespace_eaa992c::function_285a2999("turret_impact");
		self playsound("evt_turret_land");
		physicsexplosionsphere(self.origin, 200, 128, 2);
		targetpos = undefined;
	}
}

/*
	Name: function_b3eb3a0b
	Namespace: namespace_a3646565
	Checksum: 0x87DC4701
	Offset: 0x46E8
	Size: 0x67C
	Parameters: 1
	Flags: Linked
*/
function function_b3eb3a0b(params)
{
	self endon(#"death");
	var_b84274b8 = spawn("script_origin", self.origin);
	var_b84274b8 thread doa_utility::function_75e76155(self, "death");
	self.var_dc477b8d = 0;
	while(true)
	{
		wait(0.05);
		if(isdefined(level.hostmigrationtimer) && level.hostmigrationtimer)
		{
			self playsound("zmb_simianaut_roar");
			self animscripted("pissedoff", self.origin, self.angles, "ai_zombie_doa_simianaut_taunt");
			self waittillmatch(#"pissedoff");
			continue;
		}
		if(gettime() >= self.var_dc477b8d && isdefined(self.enemy) && isplayer(self.enemy) && randomint(100) < getdvarint("scr_boss_silverback_special_attack_chance_boost", 10))
		{
			roll = randomint(100);
			if(roll < 5)
			{
				attacks = 5;
			}
			else
			{
				if(roll < 15)
				{
					attacks = 3;
				}
				else
				{
					if(roll < 35)
					{
						attacks = 2;
					}
					else
					{
						attacks = 1;
					}
				}
			}
			self function_f5afb415(var_b84274b8, attacks);
			self.var_dc477b8d = gettime() + getdvarint("scr_boss_silverback_special_attack_cooldown", 4000);
			continue;
		}
		if(isdefined(self.oob) && self.oob)
		{
			self.oob = undefined;
			spot = namespace_3ca3c537::function_2a9d778d();
			spots = doa_utility::function_308fa126();
			if(isdefined(spots) && spots.size)
			{
				spot = spots[randomint(spots.size)];
			}
			self forceteleport(spot);
		}
		if(gettime() >= self.var_dc477b8d && randomint(100) < getdvarint("scr_boss_silverback_special_attack_chance_launch", 15))
		{
			roll = randomint(100);
			if(roll < 15)
			{
				attacks = 2;
			}
			else
			{
				attacks = 1;
			}
			self.var_dc477b8d = gettime() + getdvarint("scr_boss_silverback_special_attack_cooldown", 4000);
			self function_615e73a(var_b84274b8, attacks);
			continue;
		}
		if(gettime() >= self.var_dc477b8d && function_e1938709() && isdefined(self.enemy) && randomint(100) < (getdvarint("scr_boss_silverback_special_attack_chance_banana", 6) + self.var_b96cf2ea))
		{
			banana1 = spawn("script_model", self.origin);
			banana1.targetname = "banana1";
			if(isdefined(banana1))
			{
				banana1 thread function_b830b6d7("tag_weapon_right", self);
			}
			banana2 = spawn("script_model", self.origin);
			banana2.targetname = "banana2";
			if(isdefined(banana2))
			{
				banana2 thread function_b830b6d7("tag_weapon_left", self);
			}
			if(isdefined(banana1) || isdefined(banana2))
			{
				self playsound("zmb_simianaut_roar");
				var_b84274b8.angles = self.angles;
				var_b84274b8.origin = self.origin;
				self linkto(var_b84274b8);
				anim_ang = vectortoangles(self.enemy.origin - self.origin);
				var_b84274b8 rotateto((0, anim_ang[1], 0), 0.5);
				var_b84274b8 waittill(#"rotatedone");
				self unlink();
				self animscripted("pissedoff", self.origin, self.angles, "ai_zombie_doa_simianaut_attack_v1");
				self waittillmatch(#"pissedoff");
				self notify(#"hash_5825c195", "fire", "end");
			}
			self.var_dc477b8d = gettime() + getdvarint("scr_boss_silverback_special_attack_cooldown", 4000);
			continue;
		}
	}
}

/*
	Name: function_e1938709
	Namespace: namespace_a3646565
	Checksum: 0x6B2938E9
	Offset: 0x4D70
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_e1938709()
{
	return level.doa.var_22c9944.size <= getdvarint("scr_boss_banana_max", 4);
}

/*
	Name: function_b830b6d7
	Namespace: namespace_a3646565
	Checksum: 0x9097F3F6
	Offset: 0x4DB0
	Size: 0x3E4
	Parameters: 2
	Flags: Linked
*/
function function_b830b6d7(linktag, silverback)
{
	level.doa.var_22c9944[level.doa.var_22c9944.size] = self;
	self linkto(silverback, linktag);
	self setmodel("zombietron_banana");
	silverback waittill(#"hash_5825c195");
	self unlink();
	forward = anglestoforward(silverback.angles);
	target_point = (silverback.origin + (getdvarfloat("scr_boss_banana_influence_forward", 64) * forward)) + (randomfloatrange(getdvarfloat("scr_boss_banana_incluence_random", 2) * -1, getdvarfloat("scr_boss_banana_incluence_random", 2)), randomfloatrange(getdvarfloat("scr_boss_banana_incluence_random", 2) * -1, getdvarfloat("scr_boss_banana_incluence_random", 2)), getdvarfloat("scr_boss_banana_incluence_up", 130));
	vel = vectornormalize(target_point - self.origin);
	vel = vel * getdvarfloat("scr_boss_banana_velocity", 0.8);
	self physicslaunch(self.origin, vel);
	self thread namespace_eaa992c::function_285a2999("explo_warning_light_banana");
	wait(getdvarfloat("scr_boss_banana_fuse", 5));
	self thread namespace_eaa992c::function_285a2999("silverback_banana_explo");
	util::wait_network_frame();
	trigger = spawn("trigger_radius", self.origin, 0, 128, 64);
	trigger.targetname = "banana";
	arrayremovevalue(level.doa.var_22c9944, self);
	self delete();
	trigger thread function_c2d22e21();
	if(getdvarint("scr_boss_debug_banana", 0))
	{
		level thread doa_utility::debug_circle(trigger.origin + vectorscale((0, 0, 1), 20), 128, getdvarfloat("scr_boss_banana_life", 5), (1, 0, 0));
	}
	wait(getdvarfloat("scr_boss_banana_life", 5));
	trigger delete();
}

/*
	Name: function_c2d22e21
	Namespace: namespace_a3646565
	Checksum: 0x903B4369
	Offset: 0x51A0
	Size: 0x9C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_c2d22e21()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", guy);
		if(isplayer(guy))
		{
			if(!isdefined(guy.var_18098213) || gettime() > guy.var_18098213)
			{
				guy notify(#"hash_9132a424");
				guy.var_18098213 = gettime() + 1000;
			}
		}
	}
}

/*
	Name: function_df12b0c9
	Namespace: namespace_a3646565
	Checksum: 0x5D9A0D50
	Offset: 0x5248
	Size: 0xD4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_df12b0c9(target)
{
	if(!isdefined(target))
	{
		return;
	}
	self endon(#"hash_7018a851");
	self notify(#"hash_df12b0c9");
	self endon(#"hash_df12b0c9");
	target endon(#"death");
	target endon(#"disconnect");
	while(isdefined(target))
	{
		anim_ang = vectortoangles(target.origin - self.origin);
		self rotateto((0, anim_ang[1], 0), 0.5);
		self waittill(#"rotatedone");
	}
}

/*
	Name: function_5659ec29
	Namespace: namespace_a3646565
	Checksum: 0xF33B9DC6
	Offset: 0x5328
	Size: 0x174
	Parameters: 1
	Flags: Linked, Private
*/
function private function_5659ec29(var_c840292d)
{
	self notify(#"hash_5659ec29");
	self endon(#"death");
	self endon(#"hash_5659ec29");
	level waittill(var_c840292d);
	loc = spawnstruct();
	loc.origin = self.origin;
	loc.angles = self.angles;
	spawner = (randomint(100) > 50 ? level.doa.var_5f57a68d : level.doa.var_b5aef19c);
	if(spawner == level.doa.var_5f57a68d)
	{
		ai = namespace_51bd792::function_1631202b(spawner, loc);
	}
	else
	{
		ai = namespace_51bd792::function_33525e11(spawner, loc);
	}
	if(isdefined(ai))
	{
		ai linkto(self, "tag_weapon_right");
		ai.health = 1000;
		self.var_a09d9abe = ai;
	}
}

/*
	Name: function_a3a6c6d0
	Namespace: namespace_a3646565
	Checksum: 0x6D8D713D
	Offset: 0x54A8
	Size: 0xFC
	Parameters: 0
	Flags: Linked, Private
*/
function private function_a3a6c6d0()
{
	self endon(#"death");
	while(true)
	{
		pickupsitems = getentarray("a_pickup_item", "script_noteworthy");
		for(i = 0; i < pickupsitems.size; i++)
		{
			pickup = pickupsitems[i];
			if(isdefined(pickup))
			{
				distsq = distancesquared(self.origin, pickup.origin);
				if(distsq < (72 * 72))
				{
					pickup thread doa_pickups::function_6b4a5f81();
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_f61639be
	Namespace: namespace_a3646565
	Checksum: 0xB2A89C67
	Offset: 0x55B0
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function function_f61639be(dist = 72)
{
	level endon(#"exit_taken");
	level endon(#"ape_exited");
	self endon(#"death");
	distsq = dist * dist;
	while(isdefined(self))
	{
		players = namespace_831a4a7c::function_5eb6e4d1();
		foreach(player in players)
		{
			if(!isdefined(player))
			{
				continue;
			}
			if(distancesquared(self.origin, player.origin) < distsq)
			{
				player dodamage(player.health + 666, player.origin);
				if(!(isdefined(self.boosting) && self.boosting))
				{
					self playsound("zmb_simianaut_roar");
					self animscripted("pissedoff", self.origin, self.angles, "ai_zombie_doa_simianaut_attack_v1");
				}
				wait(3);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_a753035a
	Namespace: namespace_a3646565
	Checksum: 0x47E2C975
	Offset: 0x5798
	Size: 0x1C4
	Parameters: 1
	Flags: Linked
*/
function function_a753035a(egg)
{
	level.doa.var_2775f29c = egg;
	level endon(#"doa_game_is_over");
	egg physicslaunch(egg.origin, vectorscale((0, 0, 1), 10));
	hops = 6;
	while(hops)
	{
		wait(randomfloatrange(0.5 * hops, 1.2 * hops));
		hops--;
		egg namespace_5e6c5d1f::function_d63bdb9(1);
	}
	egg playsound("zmb_egg_hatch");
	egg thread namespace_eaa992c::function_285a2999("egg_hatchXL");
	chicken = spawn("script_model", egg.origin);
	chicken.targetname = "fidohatched";
	chicken setmodel("zombietron_chicken_fido");
	level.doa.var_17593d0e = chicken;
	util::wait_network_frame();
	egg delete();
	level thread function_1d9d0ed2(chicken);
}

/*
	Name: function_1d9d0ed2
	Namespace: namespace_a3646565
	Checksum: 0xF7996316
	Offset: 0x5968
	Size: 0xA6
	Parameters: 1
	Flags: Linked
*/
function function_1d9d0ed2(chicken)
{
	chicken endon(#"death");
	chicken thread namespace_5e6c5d1f::function_cdfa9ce8(chicken);
	chicken.var_a732885d = 1;
	rotate180time = 1;
	while(true)
	{
		chicken rotateto(chicken.angles + vectorscale((0, 1, 0), 180), rotate180time);
		wait(1);
	}
}

/*
	Name: move_to_position_over_time
	Namespace: namespace_a3646565
	Checksum: 0x310DE92
	Offset: 0x5A18
	Size: 0x2C8
	Parameters: 3
	Flags: Linked
*/
function move_to_position_over_time(destination, timems, elevationdelta)
{
	self endon(#"death");
	frames = timems / 50;
	delta = (destination - self.origin) / frames;
	stoptime = gettime() + timems;
	var_4f4b0e1a = 0;
	if(isdefined(elevationdelta))
	{
		deltaz = elevationdelta / (frames / 2);
		stoptimeup = gettime() + (timems / 2);
		while(true)
		{
			time = gettime();
			if(time > stoptime)
			{
				break;
			}
			if(time < stoptimeup)
			{
				deltaplus = delta + (0, 0, deltaz);
				var_4f4b0e1a = 1;
			}
			else
			{
				if(isdefined(var_4f4b0e1a) && var_4f4b0e1a)
				{
					level notify(#"move_to_pos_downward_cycle");
					self notify(#"move_to_pos_downward_cycle");
				}
				var_4f4b0e1a = 0;
				deltaplus = delta - (0, 0, deltaz);
			}
			newspot = self.origin + deltaplus;
			if(!var_4f4b0e1a && newspot[2] < destination[2])
			{
				newspot = (newspot[0], newspot[1], destination[2]);
				if(isai(self))
				{
					self forceteleport(newspot);
				}
				else
				{
					self.origin = newspot;
				}
				return;
			}
			if(isai(self))
			{
				self forceteleport(newspot);
			}
			else
			{
				self.origin = newspot;
			}
			wait(0.05);
		}
	}
	else
	{
		while(gettime() < stoptime)
		{
			if(isai(self))
			{
				self forceteleport(self.origin + delta);
			}
			else
			{
				self.origin = self.origin + delta;
			}
			wait(0.05);
		}
	}
}

