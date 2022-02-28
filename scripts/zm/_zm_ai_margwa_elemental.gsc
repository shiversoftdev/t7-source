// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\margwa;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_margwa_no_idgun;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_light_zombie;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_shadow_zombie;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_ai_margwa_elemental;

/*
	Name: init
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x239F4434
	Offset: 0xF10
	Size: 0x1EC
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_afef488b();
	spawner::add_archetype_spawn_function("margwa", &function_e1859566);
	clientfield::register("actor", "margwa_elemental_type", 15000, 3, "int");
	clientfield::register("actor", "margwa_defense_actor_appear_disappear_fx", 15000, 1, "int");
	clientfield::register("scriptmover", "play_margwa_fire_attack_fx", 15000, 1, "counter");
	clientfield::register("scriptmover", "margwa_defense_hovering_fx", 15000, 3, "int");
	clientfield::register("actor", "shadow_margwa_attack_portal_fx", 15000, 1, "int");
	clientfield::register("actor", "margwa_shock_fx", 15000, 1, "int");
	var_91a17b7d = getentarray("zombie_wasp_elite_spawner", "script_noteworthy");
	if(isdefined(var_91a17b7d) && var_91a17b7d.size > 0)
	{
		level.var_39c0c115 = var_91a17b7d[0];
	}
	zm::register_actor_damage_callback(&function_5ff4198);
	/#
		level thread function_15492d9b();
	#/
}

/*
	Name: function_afef488b
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xC384F8DB
	Offset: 0x1108
	Size: 0x7D4
	Parameters: 0
	Flags: Linked, Private
*/
function private function_afef488b()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaFireAttackService", &brrebirth_triggerrespawnoverlay);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaFireDefendService", &function_c8dea044);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaElectricGroundAttackService", &function_744188c1);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaElectricShootAttackService", &function_7652cccb);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaElectricDefendService", &function_39eece3f);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaLightAttackService", &function_655b9672);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaLightDefendService", &function_64e5bb2);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShadowAttackService", &function_43079630);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShadowDefendService", &function_50654c28);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldFireAttack", &function_78f83c26);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldFireDefendOut", &function_782e86fb);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldFireDefendIn", &function_836eeae4);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldElectricGroundAttack", &function_eb0118e7);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldElectricShootAttack", &function_2672a46d);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldElectricDefendOut", &function_efc320f8);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldElectricDefendIn", &function_bcd55721);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldLightAttack", &function_fd4fb480);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldLightDefendOut", &function_5bfc92ed);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldLightDefendIn", &function_412d8b9a);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldShadowAttack", &function_dfedf376);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldShadowAttackLoop", &function_a5dc38a7);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldShadowAttackOut", &function_f2802e4b);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldShadowDefendOut", &function_87dfc76b);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShouldShadowDefendIn", &function_6af3c534);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaFireAttack", &function_face7ad8);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaFireAttackTerminate", &function_68e3291c);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaFireDefendOut", &function_99ba2c25);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaFireDefendOutTerminate", &function_6a7ddf05);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaFireDefendIn", &function_75f40972);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaFireDefendInTerminate", &function_cd27e3fa);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaElectricGroundAttack", &function_b473ad25);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaElectricShootAttack", &function_6619b5ab);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaElectricDefendOut", &function_8382b576);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaElectricDefendOutTerminate", &function_3c8bea36);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaElectricDefendIn", &function_11d72a03);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaLightAttack", &function_226a6f4a);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaLightDefendOut", &function_9c7737ef);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaLightDefendOutTerminate", &function_5d88ac4b);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaLightDefendIn", &function_c2614d30);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShadowAttack", &function_9a9f35ac);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShadowAttackLoop", &function_ae1bcedd);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShadowAttackLoopTerminate", &function_58c0f99d);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShadowAttackOutTerminate", &function_d89cf919);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShadowDefendOut", &function_d765e859);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShadowDefendOutTerminate", &function_4600a191);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaShadowDefendIn", &function_d258371e);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaIsElectric", &function_3cfb8731);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaIsFire", &function_6bbd2a18);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaIsLight", &function_7db0458);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zmMargwaIsShadow", &function_b9fad980);
}

/*
	Name: function_eb5051f4
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xE5A2522B
	Offset: 0x18E8
	Size: 0x5A4
	Parameters: 4
	Flags: Linked
*/
function function_eb5051f4(spawner, targetname, var_f9ebd43e, s_location)
{
	if(isdefined(spawner))
	{
		level.margwa_head_left_model_override = undefined;
		level.margwa_head_mid_model_override = undefined;
		level.margwa_head_right_model_override = undefined;
		level.margwa_gore_left_model_override = undefined;
		level.margwa_gore_mid_model_override = undefined;
		level.margwa_gore_right_model_override = undefined;
		switch(var_f9ebd43e)
		{
			case "fire":
			{
				level.margwa_head_left_model_override = "c_zom_dlc4_margwa_chunks_le_fire";
				level.margwa_head_mid_model_override = "c_zom_dlc4_margwa_chunks_mid_fire";
				level.margwa_head_right_model_override = "c_zom_dlc4_margwa_chunks_ri_fire";
				level.margwa_gore_left_model_override = "c_zom_dlc4_margwa_gore_le_fire";
				level.margwa_gore_mid_model_override = "c_zom_dlc4_margwa_gore_mid_fire";
				level.margwa_gore_right_model_override = "c_zom_dlc4_margwa_gore_ri_fire";
				break;
			}
			case "shadow":
			{
				level.margwa_head_left_model_override = "c_zom_dlc4_margwa_chunks_le_shadow";
				level.margwa_head_mid_model_override = "c_zom_dlc4_margwa_chunks_mid_shadow";
				level.margwa_head_right_model_override = "c_zom_dlc4_margwa_chunks_ri_shadow";
				level.margwa_gore_left_model_override = "c_zom_dlc4_margwa_gore_le_shadow";
				level.margwa_gore_mid_model_override = "c_zom_dlc4_margwa_gore_mid_shadow";
				level.margwa_gore_right_model_override = "c_zom_dlc4_margwa_gore_ri_shadow";
				break;
			}
		}
		spawner.script_forcespawn = 1;
		ai = zombie_utility::spawn_zombie(spawner, targetname, s_location);
		level.margwa_head_left_model_override = undefined;
		level.margwa_head_mid_model_override = undefined;
		level.margwa_head_right_model_override = undefined;
		level.margwa_gore_left_model_override = undefined;
		level.margwa_gore_mid_model_override = undefined;
		level.margwa_gore_right_model_override = undefined;
		if(isdefined(level.var_fd47363))
		{
			level.margwa_head_left_model_override = level.var_fd47363["head_le"];
			level.margwa_head_mid_model_override = level.var_fd47363["head_mid"];
			level.margwa_head_right_model_override = level.var_fd47363["head_ri"];
			level.margwa_gore_left_model_override = level.var_fd47363["gore_le"];
			level.margwa_gore_mid_model_override = level.var_fd47363["gore_mid"];
			level.margwa_gore_right_model_override = level.var_fd47363["gore_ri"];
		}
		ai disableaimassist();
		ai.actor_damage_func = &margwaserverutils::margwadamage;
		ai.candamage = 0;
		ai.targetname = targetname;
		ai.holdfire = 1;
		ai function_c0ff1e9(var_f9ebd43e);
		switch(var_f9ebd43e)
		{
			case "fire":
			{
				ai clientfield::set("margwa_elemental_type", 1);
				break;
			}
			case "electric":
			{
				ai clientfield::set("margwa_elemental_type", 2);
				break;
			}
			case "light":
			{
				ai clientfield::set("margwa_elemental_type", 3);
				break;
			}
			case "shadow":
			{
				ai clientfield::set("margwa_elemental_type", 4);
				break;
			}
		}
		ai.n_start_health = self.health;
		ai.team = level.zombie_team;
		ai.canstun = 1;
		ai.thundergun_fling_func = &zm_ai_margwa::function_7292417a;
		ai.thundergun_knockdown_func = &zm_ai_margwa::function_94fd1710;
		ai.var_23340a5d = &zm_ai_margwa::function_7292417a;
		ai.var_e1dbd63 = &zm_ai_margwa::function_94fd1710;
		e_player = zm_utility::get_closest_player(s_location.origin);
		v_dir = e_player.origin - s_location.origin;
		v_dir = vectornormalize(v_dir);
		v_angles = vectortoangles(v_dir);
		ai forceteleport(s_location.origin, v_angles);
		ai function_551e32b4();
		ai thread function_8d578a58();
		ai.ignore_round_robbin_death = 1;
		/#
			ai.ignore_devgui_death = 1;
			ai thread zm_ai_margwa::function_618bf323();
		#/
		ai thread function_3d56f587();
		level thread zm_spawner::zombie_death_event(ai);
		return ai;
	}
	return undefined;
}

/*
	Name: function_75b161ab
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x686BE795
	Offset: 0x1E98
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function function_75b161ab(spawner, s_location)
{
	if(!isdefined(spawner))
	{
		var_fda751f9 = getspawnerarray("zombie_margwa_fire_spawner", "script_noteworthy");
		if(var_fda751f9.size <= 0)
		{
			/#
				iprintln("");
			#/
			return;
		}
		spawner = var_fda751f9[0];
	}
	spawner_targetname = "margwa_fire";
	var_f9ebd43e = "fire";
	ai = function_eb5051f4(spawner, spawner_targetname, var_f9ebd43e, s_location);
	return ai;
}

/*
	Name: function_26efbc37
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x6D6C5C25
	Offset: 0x1F80
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function function_26efbc37(spawner, s_location)
{
	if(!isdefined(spawner))
	{
		var_5e8312fd = getspawnerarray("zombie_margwa_shadow_spawner", "script_noteworthy");
		if(var_5e8312fd.size <= 0)
		{
			/#
				iprintln("");
			#/
			return;
		}
		spawner = var_5e8312fd[0];
	}
	spawner_targetname = "margwa_shadow";
	var_f9ebd43e = "shadow";
	ai = function_eb5051f4(spawner, spawner_targetname, var_f9ebd43e, s_location);
	return ai;
}

/*
	Name: function_12301fd1
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x59EE3040
	Offset: 0x2068
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function function_12301fd1(spawner, s_location)
{
	if(!isdefined(spawner))
	{
		var_1977e3bb = getspawnerarray("zombie_margwa_light_spawner", "script_noteworthy");
		if(var_1977e3bb.size <= 0)
		{
			/#
				iprintln("");
			#/
			return;
		}
		spawner = var_1977e3bb[0];
	}
	spawner_targetname = "margwa_light";
	var_f9ebd43e = "light";
	ai = function_eb5051f4(spawner, spawner_targetname, var_f9ebd43e, s_location);
	return ai;
}

/*
	Name: function_5b1c9e5c
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x288E01DC
	Offset: 0x2150
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function function_5b1c9e5c(spawner, s_location)
{
	if(!isdefined(spawner))
	{
		var_9ceb03c8 = getspawnerarray("zombie_margwa_electricity_spawner", "script_noteworthy");
		if(var_9ceb03c8.size <= 0)
		{
			/#
				iprintln("");
			#/
			return;
		}
		spawner = var_9ceb03c8[0];
	}
	spawner_targetname = "margwa_electric";
	var_f9ebd43e = "electric";
	ai = function_eb5051f4(spawner, spawner_targetname, var_f9ebd43e, s_location);
	return ai;
}

/*
	Name: function_3d56f587
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xCB3F4518
	Offset: 0x2238
	Size: 0x6C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_3d56f587()
{
	util::wait_network_frame();
	self clientfield::increment("margwa_fx_spawn");
	wait(3);
	self function_26c35525();
	self.candamage = 1;
	self.needspawn = 1;
}

/*
	Name: function_551e32b4
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xBA1E138
	Offset: 0x22B0
	Size: 0x6C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_551e32b4()
{
	self.isfrozen = 1;
	self.dontshow = 1;
	self ghost();
	self notsolid();
	self pathmode("dont move");
}

/*
	Name: function_26c35525
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x69EC2A22
	Offset: 0x2328
	Size: 0x5C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_26c35525()
{
	self.isfrozen = 0;
	self show();
	self solid();
	self pathmode("move allowed");
}

/*
	Name: function_8d578a58
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x415BC5C
	Offset: 0x2390
	Size: 0x1F0
	Parameters: 0
	Flags: Linked, Private
*/
function private function_8d578a58()
{
	self waittill(#"death", attacker, mod, weapon);
	foreach(player in level.players)
	{
		if(player.am_i_valid && (!(isdefined(level.var_1f6ca9c8) && level.var_1f6ca9c8)) && (!(isdefined(self.var_2d5d7413) && self.var_2d5d7413)))
		{
			scoreevents::processscoreevent("kill_margwa", player, undefined, undefined);
		}
	}
	level notify(#"hash_1a2d33d7");
	if(isdefined(function_6bbd2a18(self)) && function_6bbd2a18(self))
	{
		function_396590c8(self.origin, 128);
	}
	if(isdefined(function_b9fad980(self)) && function_b9fad980(self))
	{
		self clientfield::set("shadow_margwa_attack_portal_fx", 0);
		function_3572faf3(self.origin, 128);
	}
	if(isdefined(level.var_7cef68dc))
	{
		[[level.var_7cef68dc]]();
	}
}

/*
	Name: function_396590c8
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x9456C9DC
	Offset: 0x2588
	Size: 0xBA
	Parameters: 2
	Flags: Linked, Private
*/
function private function_396590c8(pos, range)
{
	a_zombies = function_181f65f7(pos, range);
	foreach(zombie in a_zombies)
	{
		zombie zm_elemental_zombie::function_f4defbc2();
	}
}

/*
	Name: function_3572faf3
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xFFE117EB
	Offset: 0x2650
	Size: 0xBA
	Parameters: 2
	Flags: Linked, Private
*/
function private function_3572faf3(pos, range)
{
	a_zombies = function_181f65f7(pos, range);
	foreach(zombie in a_zombies)
	{
		zombie zm_shadow_zombie::function_1b2b62b();
	}
}

/*
	Name: function_181f65f7
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xC47819D6
	Offset: 0x2718
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function function_181f65f7(pos, range)
{
	var_7843fa64 = zm_elemental_zombie::function_d41418b8();
	a_zombies = array::get_all_closest(pos, var_7843fa64, undefined, undefined, range);
	return a_zombies;
}

/*
	Name: function_c0ff1e9
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x4BE2606C
	Offset: 0x2788
	Size: 0x18
	Parameters: 1
	Flags: Linked, Private
*/
function private function_c0ff1e9(var_f9ebd43e)
{
	self.var_f9ebd43e = var_f9ebd43e;
}

/*
	Name: function_6bbd2a18
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x87E28D9E
	Offset: 0x27A8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_6bbd2a18(entity)
{
	if(isdefined(entity) && isdefined(entity.var_f9ebd43e) && entity.var_f9ebd43e == "fire")
	{
		return true;
	}
	return false;
}

/*
	Name: function_3cfb8731
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xE2C42DE2
	Offset: 0x2800
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_3cfb8731(entity)
{
	if(isdefined(entity) && isdefined(entity.var_f9ebd43e) && entity.var_f9ebd43e == "electric")
	{
		return true;
	}
	return false;
}

/*
	Name: function_7db0458
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xA9555C11
	Offset: 0x2858
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_7db0458(entity)
{
	if(isdefined(entity) && isdefined(entity.var_f9ebd43e) && entity.var_f9ebd43e == "light")
	{
		return true;
	}
	return false;
}

/*
	Name: function_b9fad980
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xA7BA49AC
	Offset: 0x28B0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_b9fad980(entity)
{
	if(isdefined(entity) && isdefined(entity.var_f9ebd43e) && entity.var_f9ebd43e == "shadow")
	{
		return true;
	}
	return false;
}

/*
	Name: function_e1859566
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x5575B49A
	Offset: 0x2908
	Size: 0xF4
	Parameters: 0
	Flags: Linked, Private
*/
function private function_e1859566()
{
	self.zombie_lift_override = &function_2ab5f647;
	self function_68ff73f4();
	self function_1d2f460c();
	self function_3c6c3309();
	self function_36cf9d7();
	self function_4e78142b();
	self function_1da8deb6();
	self function_6ae4a816();
	self function_e268d040();
	self function_246f9ba8();
}

/*
	Name: function_68ff73f4
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x2833C6EC
	Offset: 0x2A08
	Size: 0x14
	Parameters: 0
	Flags: Linked, Private
*/
function private function_68ff73f4()
{
	self.var_16ee8ac0 = gettime() + 20000;
}

/*
	Name: function_1d2f460c
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x1C8E06BF
	Offset: 0x2A28
	Size: 0x14
	Parameters: 0
	Flags: Linked, Private
*/
function private function_1d2f460c()
{
	self.var_5ef5dff8 = gettime() + 20000;
}

/*
	Name: function_3c6c3309
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xE283071A
	Offset: 0x2A48
	Size: 0x14
	Parameters: 0
	Flags: Linked, Private
*/
function private function_3c6c3309()
{
	self.var_57ad950f = gettime() + 6000;
}

/*
	Name: function_36cf9d7
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x1CB86747
	Offset: 0x2A68
	Size: 0x14
	Parameters: 0
	Flags: Linked, Private
*/
function private function_36cf9d7()
{
	self.var_a5ab6e8d = gettime() + 6000;
}

/*
	Name: function_4e78142b
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x4F0B84B8
	Offset: 0x2A88
	Size: 0x14
	Parameters: 0
	Flags: Linked, Private
*/
function private function_4e78142b()
{
	self.var_7294169 = gettime() + 7500;
}

/*
	Name: function_1da8deb6
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x82FB34AB
	Offset: 0x2AA8
	Size: 0x14
	Parameters: 0
	Flags: Linked, Private
*/
function private function_1da8deb6()
{
	self.var_44d78ba2 = gettime() + 3000;
}

/*
	Name: function_6ae4a816
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x42E92201
	Offset: 0x2AC8
	Size: 0x14
	Parameters: 0
	Flags: Linked, Private
*/
function private function_6ae4a816()
{
	self.var_c0e54902 = gettime() + 20000;
}

/*
	Name: function_e268d040
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x4006F3E5
	Offset: 0x2AE8
	Size: 0x14
	Parameters: 0
	Flags: Linked, Private
*/
function private function_e268d040()
{
	self.var_70f89c94 = gettime() + 20000;
}

/*
	Name: function_246f9ba8
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x997B96C7
	Offset: 0x2B08
	Size: 0x14
	Parameters: 0
	Flags: Linked, Private
*/
function private function_246f9ba8()
{
	self.var_3a9ed1bc = gettime() + 20000;
}

/*
	Name: function_4f4a272
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x3A09C0E3
	Offset: 0x2B28
	Size: 0x1C4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_4f4a272(right_offset)
{
	origin = self.origin;
	if(isdefined(right_offset))
	{
		right_angle = anglestoright(self.angles);
		origin = origin + (right_angle * right_offset);
	}
	facing_vec = anglestoforward(self.angles);
	enemy_vec = self.favoriteenemy.origin - origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = vectornormalize(enemy_yaw_vec);
	facing_yaw_vec = vectornormalize(facing_yaw_vec);
	enemy_dot = vectordot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0.5)
	{
		return false;
	}
	enemy_angles = vectortoangles(enemy_vec);
	if(abs(angleclamp180(enemy_angles[0])) > 60)
	{
		return false;
	}
	return true;
}

/*
	Name: brrebirth_triggerrespawnoverlay
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x86ADCBBE
	Offset: 0x2CF8
	Size: 0x1CC
	Parameters: 1
	Flags: Linked, Private
*/
function private brrebirth_triggerrespawnoverlay(entity)
{
	if(!function_6bbd2a18(entity))
	{
		return false;
	}
	if(isdefined(entity.var_322364e8) && entity.var_322364e8)
	{
		entity.var_4ad63d98 = 1;
		return true;
	}
	time = gettime();
	entity.var_4ad63d98 = 0;
	if(time < entity.var_16ee8ac0)
	{
		return false;
	}
	if(isdefined(entity.var_b696faa3) && entity.var_b696faa3)
	{
		return false;
	}
	if(isdefined(entity.var_dd350502) && entity.var_dd350502)
	{
		return false;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		return false;
	}
	if(!entity function_4f4a272())
	{
		return false;
	}
	if(!entity cansee(entity.favoriteenemy))
	{
		return false;
	}
	dist_sq = distancesquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 62500 || dist_sq > 1440000)
	{
		return false;
	}
	entity.var_4ad63d98 = 1;
	return true;
}

/*
	Name: function_c8dea044
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xE4F36F1
	Offset: 0x2ED0
	Size: 0xC4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_c8dea044(entity)
{
	if(!function_6bbd2a18(entity))
	{
		return false;
	}
	if(entity.headattached > 2)
	{
		return false;
	}
	if(isdefined(entity.favoriteenemy) && (isdefined(entity.favoriteenemy.is_flung) && entity.favoriteenemy.is_flung))
	{
		return false;
	}
	if(gettime() > entity.var_5ef5dff8)
	{
		entity.var_501a54e5 = 1;
		return true;
	}
	return false;
}

/*
	Name: function_744188c1
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x9F822DC5
	Offset: 0x2FA0
	Size: 0x13C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_744188c1(entity)
{
	entity.var_6d87f4e5 = 0;
	if(!function_3cfb8731(entity))
	{
		return false;
	}
	if(gettime() > entity.var_57ad950f)
	{
		entity.var_6d87f4e5 = 1;
		return true;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		return false;
	}
	if(!entity function_4f4a272())
	{
		return false;
	}
	if(!entity cansee(entity.favoriteenemy))
	{
		return false;
	}
	dist_sq = distancesquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 62500 || dist_sq > 1440000)
	{
		return false;
	}
	entity.var_6d87f4e5 = 1;
	return true;
}

/*
	Name: function_7652cccb
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x327B26B4
	Offset: 0x30E8
	Size: 0x13C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_7652cccb(entity)
{
	if(!function_3cfb8731(entity))
	{
		return false;
	}
	entity.var_c521ba6b = 0;
	if(gettime() > entity.var_a5ab6e8d)
	{
		entity.var_c521ba6b = 1;
		return true;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		return false;
	}
	if(!entity function_4f4a272())
	{
		return false;
	}
	if(!entity cansee(entity.favoriteenemy))
	{
		return false;
	}
	dist_sq = distancesquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 62500 || dist_sq > 1440000)
	{
		return false;
	}
	entity.var_c521ba6b = 1;
	return true;
}

/*
	Name: function_39eece3f
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x6AC7FCAD
	Offset: 0x3230
	Size: 0xCC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_39eece3f(entity)
{
	entity.var_a48cbe36 = 0;
	if(!function_3cfb8731(entity))
	{
		return false;
	}
	if(gettime() < entity.var_7294169)
	{
		return false;
	}
	dist_sq = distancesquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 129600 || dist_sq > 921600)
	{
		return false;
	}
	entity.var_a48cbe36 = 1;
	return true;
}

/*
	Name: function_655b9672
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xA34DC19C
	Offset: 0x3308
	Size: 0x124
	Parameters: 1
	Flags: Linked, Private
*/
function private function_655b9672(entity)
{
	if(!function_7db0458(entity))
	{
		return false;
	}
	entity.var_d3c45f0a = 0;
	if(gettime() > entity.var_44d78ba2)
	{
		entity.var_d3c45f0a = 1;
		return true;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		return false;
	}
	if(!entity cansee(entity.favoriteenemy))
	{
		return false;
	}
	dist_sq = distancesquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 62500 || dist_sq > 1440000)
	{
		return false;
	}
	entity.var_d3c45f0a = 1;
	return true;
}

/*
	Name: function_64e5bb2
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x9431C421
	Offset: 0x3438
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_64e5bb2(entity)
{
	if(!function_7db0458(entity))
	{
		return false;
	}
	if(gettime() > entity.var_c0e54902)
	{
		entity.var_623927af = 1;
		return true;
	}
	return false;
}

/*
	Name: function_43079630
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xFB2EA923
	Offset: 0x34A0
	Size: 0x1BC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_43079630(entity)
{
	if(!function_b9fad980(entity))
	{
		return false;
	}
	if(isdefined(entity.var_3c58b79c) && entity.var_3c58b79c)
	{
		entity.var_321306c = 1;
		return true;
	}
	entity.var_321306c = 0;
	if(isdefined(entity.var_187c138e) && entity.var_187c138e)
	{
		return false;
	}
	if(isdefined(entity.isteleporting) && entity.isteleporting)
	{
		return false;
	}
	if(gettime() < entity.var_70f89c94)
	{
		return false;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		return false;
	}
	if(!entity cansee(entity.favoriteenemy))
	{
		return false;
	}
	if(!entity function_4f4a272())
	{
		return false;
	}
	dist_sq = distancesquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 16384 || dist_sq > 589824)
	{
		return false;
	}
	entity.var_321306c = 1;
	return true;
}

/*
	Name: function_50654c28
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x7CEF405A
	Offset: 0x3668
	Size: 0xEC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_50654c28(entity)
{
	if(!function_b9fad980(entity))
	{
		return false;
	}
	if(entity.headattached > 2)
	{
		return false;
	}
	if(isdefined(entity.favoriteenemy) && (isdefined(entity.favoriteenemy.is_flung) && entity.favoriteenemy.is_flung))
	{
		return false;
	}
	if(isdefined(entity.var_187c138e) && entity.var_187c138e)
	{
		return false;
	}
	if(gettime() > entity.var_3a9ed1bc)
	{
		entity.var_e9353b19 = 1;
		return true;
	}
	return false;
}

/*
	Name: function_78f83c26
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xA45D381
	Offset: 0x3760
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_78f83c26(entity)
{
	if(isdefined(entity.var_4ad63d98) && entity.var_4ad63d98)
	{
		return true;
	}
	return false;
}

/*
	Name: function_782e86fb
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xF02A7A1F
	Offset: 0x37A8
	Size: 0xE
	Parameters: 1
	Flags: Linked, Private
*/
function private function_782e86fb(entity)
{
	return false;
}

/*
	Name: function_836eeae4
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x4A5FD7A4
	Offset: 0x37C0
	Size: 0xE
	Parameters: 1
	Flags: Linked, Private
*/
function private function_836eeae4(entity)
{
	return false;
}

/*
	Name: function_eb0118e7
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x1FFEF45D
	Offset: 0x37D8
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_eb0118e7(entity)
{
	if(isdefined(entity.var_6d87f4e5) && entity.var_6d87f4e5)
	{
		return true;
	}
	return false;
}

/*
	Name: function_2672a46d
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x6AB69EBA
	Offset: 0x3820
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_2672a46d(entity)
{
	if(isdefined(entity.var_c521ba6b) && entity.var_c521ba6b)
	{
		return true;
	}
	return false;
}

/*
	Name: function_efc320f8
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x4C8AF006
	Offset: 0x3868
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_efc320f8(entity)
{
	if(isdefined(entity.var_a48cbe36) && entity.var_a48cbe36)
	{
		return true;
	}
	return false;
}

/*
	Name: function_bcd55721
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xD61B7678
	Offset: 0x38B0
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_bcd55721(entity)
{
	if(isdefined(entity.var_523cacc3) && entity.var_523cacc3)
	{
		return true;
	}
	return false;
}

/*
	Name: function_fd4fb480
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xF1E8EFD1
	Offset: 0x38F8
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_fd4fb480(entity)
{
	if(isdefined(entity.var_d3c45f0a) && entity.var_d3c45f0a)
	{
		return true;
	}
	return false;
}

/*
	Name: function_5bfc92ed
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x263E2098
	Offset: 0x3940
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_5bfc92ed(entity)
{
	if(isdefined(entity.var_623927af) && entity.var_623927af)
	{
		return true;
	}
	return false;
}

/*
	Name: function_412d8b9a
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xB25C1EC8
	Offset: 0x3988
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_412d8b9a(entity)
{
	if(isdefined(entity.var_5df615f0) && entity.var_5df615f0)
	{
		return true;
	}
	return false;
}

/*
	Name: function_dfedf376
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x953D740D
	Offset: 0x39D0
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_dfedf376(entity)
{
	if(isdefined(entity.var_321306c) && entity.var_321306c)
	{
		return true;
	}
	return false;
}

/*
	Name: function_a5dc38a7
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x76E3B814
	Offset: 0x3A18
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_a5dc38a7(entity)
{
	if(isdefined(entity.var_1ab20b9b))
	{
		if(gettime() > entity.var_1ab20b9b)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_f2802e4b
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x37AB98F2
	Offset: 0x3A60
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_f2802e4b(entity)
{
	if(isdefined(entity.var_6a2ba141) && entity.var_6a2ba141)
	{
		return true;
	}
	return false;
}

/*
	Name: function_87dfc76b
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x194A66B0
	Offset: 0x3AA8
	Size: 0xE
	Parameters: 1
	Flags: Linked, Private
*/
function private function_87dfc76b(entity)
{
	return false;
}

/*
	Name: function_6af3c534
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x46656606
	Offset: 0x3AC0
	Size: 0xE
	Parameters: 1
	Flags: Linked, Private
*/
function private function_6af3c534(entity)
{
	return false;
}

/*
	Name: function_face7ad8
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xA34F06A9
	Offset: 0x3AD8
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_face7ad8(entity)
{
	entity endon(#"death");
	entity.var_322364e8 = 0;
	entity thread function_90ec324d();
}

/*
	Name: function_90ec324d
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x4E84D36E
	Offset: 0x3B20
	Size: 0x73C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_90ec324d()
{
	self.var_dd350502 = 1;
	foreach(head in self.head)
	{
		if(!(isdefined(head.candamage) && head.candamage))
		{
			head.var_13ac78ab = 0;
			head.candamage = 1;
			continue;
		}
		head.var_13ac78ab = 1;
	}
	self waittill(#"hash_b55b6f2b");
	foreach(head in self.head)
	{
		if(!(isdefined(head.var_13ac78ab) && head.var_13ac78ab))
		{
			head.candamage = 0;
		}
	}
	if(isdefined(self.favoriteenemy))
	{
		var_70b6278d = self.favoriteenemy.origin - self.origin;
		var_68149ff9 = vectornormalize(var_70b6278d);
		target_entity = self.favoriteenemy;
	}
	else
	{
		var_68149ff9 = anglestoforward(self.angles);
	}
	var_1642db30 = var_68149ff9;
	var_74475c34 = int(13.33333);
	position = self.origin;
	var_898f5d33 = spawn("script_model", position);
	var_898f5d33 setmodel("tag_origin");
	level thread function_396590c8(position, 48);
	torpedo_yaw_per_interval = 13.5;
	torpedo_max_yaw_cos = cos(torpedo_yaw_per_interval);
	for(i = 0; i <= var_74475c34; i++)
	{
		self function_68ff73f4();
		position = position + vectorscale((0, 0, 1), 32);
		if(isdefined(target_entity))
		{
			torpedo_target_point = target_entity.origin;
			vector_to_target = torpedo_target_point - position;
			normal_vector = vectornormalize(vector_to_target);
			flat_mapped_normal_vector = vectornormalize((normal_vector[0], normal_vector[1], 0));
			flat_mapped_old_normal_vector = vectornormalize((var_1642db30[0], var_1642db30[1], 0));
			dot = vectordot(flat_mapped_normal_vector, flat_mapped_old_normal_vector);
			if(dot >= 1)
			{
				dot = 1;
			}
			else if(dot <= -1)
			{
				dot = -1;
			}
			if(dot < torpedo_max_yaw_cos)
			{
				new_vector = normal_vector - var_1642db30;
				angle_between_vectors = acos(dot);
				if(!isdefined(angle_between_vectors))
				{
					angle_between_vectors = 180;
				}
				if(angle_between_vectors == 0)
				{
					angle_between_vectors = 0.0001;
				}
				max_angle_per_interval = 13.5;
				ratio = max_angle_per_interval / angle_between_vectors;
				if(ratio > 1)
				{
					ratio = 1;
				}
				new_vector = new_vector * ratio;
				new_vector = new_vector + var_1642db30;
				normal_vector = vectornormalize(new_vector);
			}
			else
			{
				normal_vector = var_1642db30;
			}
		}
		if(!isdefined(normal_vector))
		{
			normal_vector = var_1642db30;
		}
		var_98258f16 = normal_vector * 48;
		var_1642db30 = normal_vector;
		target_pos = position + var_98258f16;
		if(bullettracepassed(position, target_pos, 0, self))
		{
			trace = bullettrace(target_pos, target_pos - vectorscale((0, 0, 1), 64), 0, self);
			if(!isdefined(trace["position"]))
			{
				continue;
			}
			position = trace["position"];
			var_898f5d33 moveto(position, 0.15);
			var_898f5d33 waittill(#"movedone");
			var_898f5d33 clientfield::increment("play_margwa_fire_attack_fx");
			var_898f5d33 thread function_396590c8(position, 48);
			self thread function_308ca6aa(position, 48, 30, "MOD_BURNED");
			if(isdefined(target_entity) && distancesquared(target_entity.origin, position) <= 2304)
			{
				break;
			}
			continue;
		}
		break;
	}
	self.var_dd350502 = 0;
}

/*
	Name: function_68e3291c
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x1A14047A
	Offset: 0x4268
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private function_68e3291c(entity)
{
	entity function_68ff73f4();
}

/*
	Name: function_99ba2c25
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x2923655F
	Offset: 0x4298
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_99ba2c25(entity)
{
	entity function_1d2f460c();
	entity.isteleporting = 1;
	entity.var_501a54e5 = 0;
	entity.var_b696faa3 = 1;
}

/*
	Name: function_6a7ddf05
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x335124D7
	Offset: 0x4300
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_6a7ddf05(entity)
{
	entity clientfield::set("margwa_defense_actor_appear_disappear_fx", 1);
	entity ghost();
	entity pathmode("dont move");
	entity thread function_ced695a8();
}

/*
	Name: function_ced695a8
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x77950973
	Offset: 0x4388
	Size: 0x118
	Parameters: 0
	Flags: Linked, Private
*/
function private function_ced695a8()
{
	self.waiting = 1;
	var_c37d9885 = vectorscale((0, 0, 1), 64);
	self function_258d1434(var_c37d9885, 240, 480);
	if(isdefined(self.var_937645c5))
	{
		self.var_937645c5 clientfield::set("margwa_defense_hovering_fx", 1);
	}
	if(isdefined(self.var_b978c02e))
	{
		self.var_b978c02e clientfield::set("margwa_defense_hovering_fx", 1);
	}
	if(isdefined(self.var_df7b3a97))
	{
		self.var_df7b3a97 clientfield::set("margwa_defense_hovering_fx", 1);
	}
	self forceteleport(self.var_58b84a32);
	wait(1);
	self.waiting = 0;
	self.var_847ae832 = 1;
}

/*
	Name: function_794b06f
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x3BD0D351
	Offset: 0x44A8
	Size: 0x4A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_794b06f(point)
{
	return zm_utility::check_point_in_playable_area(point.origin) && zm_utility::check_point_in_enabled_zone(point.origin);
}

/*
	Name: function_75f40972
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xF9B9401D
	Offset: 0x4500
	Size: 0x174
	Parameters: 1
	Flags: Linked, Private
*/
function private function_75f40972(entity)
{
	entity show();
	entity pathmode("move allowed");
	entity.isteleporting = 0;
	entity.var_847ae832 = 0;
	if(isdefined(self.var_937645c5))
	{
		self.var_937645c5 clientfield::set("margwa_defense_hovering_fx", 0);
	}
	if(isdefined(self.var_b978c02e))
	{
		self.var_b978c02e clientfield::set("margwa_defense_hovering_fx", 0);
	}
	if(isdefined(self.var_df7b3a97))
	{
		self.var_df7b3a97 clientfield::set("margwa_defense_hovering_fx", 0);
	}
	wait(0.05);
	if(isdefined(self.var_937645c5))
	{
		self.var_937645c5 delete();
	}
	if(isdefined(self.var_b978c02e))
	{
		self.var_b978c02e delete();
	}
	if(isdefined(self.var_df7b3a97))
	{
		self.var_df7b3a97 delete();
	}
}

/*
	Name: function_cd27e3fa
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xA1A7D95E
	Offset: 0x4680
	Size: 0x1C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_cd27e3fa(entity)
{
	entity.var_b696faa3 = 0;
}

/*
	Name: function_b473ad25
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xE976D017
	Offset: 0x46A8
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private function_b473ad25(entity)
{
	entity function_3c6c3309();
}

/*
	Name: function_6619b5ab
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x5BD5AA7C
	Offset: 0x46D8
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private function_6619b5ab(entity)
{
	entity function_36cf9d7();
}

/*
	Name: function_8382b576
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x2FD18B79
	Offset: 0x4708
	Size: 0x48
	Parameters: 1
	Flags: Linked, Private
*/
function private function_8382b576(entity)
{
	entity function_4e78142b();
	entity.isteleporting = 1;
	entity.var_a48cbe36 = 0;
}

/*
	Name: function_3c8bea36
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xD1AF826E
	Offset: 0x4758
	Size: 0x104
	Parameters: 1
	Flags: Linked, Private
*/
function private function_3c8bea36(entity)
{
	if(isdefined(entity.traveler))
	{
		entity.traveler.origin = entity gettagorigin("j_spine_1");
		entity.traveler clientfield::set("margwa_fx_travel", 1);
	}
	entity ghost();
	entity pathmode("dont move");
	if(isdefined(entity.traveler))
	{
		entity linkto(entity.traveler);
	}
	entity thread function_aa4e7619();
}

/*
	Name: function_aa4e7619
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x1B34324C
	Offset: 0x4868
	Size: 0x3D8
	Parameters: 0
	Flags: Linked, Private
*/
function private function_aa4e7619()
{
	self.waiting = 1;
	goal_pos = self.enemy.origin;
	if(isdefined(self.enemy.last_valid_position))
	{
		goal_pos = self.enemy.last_valid_position;
	}
	path = self calcapproximatepathtoposition(goal_pos, 0);
	var_2fd16fa4 = randomintrange(96, 192);
	segment_length = 0;
	teleport_point = [];
	var_f2593821 = 0;
	for(index = 1; index < path.size; index++)
	{
		var_cabd9641 = distance(path[index - 1], path[index]);
		if((segment_length + var_cabd9641) > var_2fd16fa4)
		{
			var_bee1a4a2 = var_2fd16fa4 - segment_length;
			var_5a78f4fc = (path[index - 1]) + ((vectornormalize(path[index] - (path[index - 1]))) * var_bee1a4a2);
			query_result = positionquery_source_navigation(var_5a78f4fc, 64, 128, 36, 16, self, 16);
			if(query_result.data.size > 0)
			{
				point = query_result.data[randomint(query_result.data.size)];
				teleport_point[var_f2593821] = point.origin;
				var_f2593821++;
				if(var_f2593821 == 3)
				{
					break;
				}
			}
		}
	}
	foreach(point in teleport_point)
	{
		var_bd23de7b = point + vectorscale((0, 0, 1), 60);
		dist = distance(self.traveler.origin, var_bd23de7b);
		time = dist / 1200;
		if(time < 0.1)
		{
			time = 0.1;
		}
		if(isdefined(self.traveler))
		{
			self.traveler moveto(var_bd23de7b, time);
			self.traveler util::waittill_any_timeout(time, "movedone");
		}
	}
	self.teleportpos = point;
	self.waiting = 0;
	self.var_523cacc3 = 1;
}

/*
	Name: function_11d72a03
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x4418C469
	Offset: 0x4C48
	Size: 0xDC
	Parameters: 1
	Flags: Linked, Private
*/
function private function_11d72a03(entity)
{
	entity unlink();
	if(isdefined(entity.teleportpos))
	{
		entity forceteleport(entity.teleportpos);
	}
	entity show();
	entity pathmode("move allowed");
	entity.isteleporting = 0;
	entity.var_523cacc3 = 0;
	entity.traveler clientfield::set("margwa_fx_travel", 0);
}

/*
	Name: function_226a6f4a
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x5C82B033
	Offset: 0x4D30
	Size: 0x44
	Parameters: 1
	Flags: Linked, Private
*/
function private function_226a6f4a(entity)
{
	entity function_1da8deb6();
	/#
		printtoprightln("");
	#/
}

/*
	Name: function_9c7737ef
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xDCA1B69B
	Offset: 0x4D80
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private function_9c7737ef(entity)
{
	entity function_6ae4a816();
	entity.isteleporting = 1;
	entity.var_623927af = 0;
	/#
		printtoprightln("");
	#/
}

/*
	Name: function_5d88ac4b
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x52B9F81E
	Offset: 0x4DF0
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_5d88ac4b(entity)
{
	entity ghost();
	entity pathmode("dont move");
	entity thread function_f10db74e();
}

/*
	Name: function_f10db74e
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x53C85FBA
	Offset: 0x4E58
	Size: 0xCC
	Parameters: 0
	Flags: Linked, Private
*/
function private function_f10db74e()
{
	self.waiting = 1;
	queryresult = positionquery_source_navigation(self.origin, 120, 360, 128, 32, self);
	pointlist = array::randomize(queryresult.data);
	self.var_58b84a32 = pointlist[0].origin;
	self forceteleport(self.var_58b84a32);
	wait(0.5);
	self.waiting = 0;
	self.var_5df615f0 = 1;
}

/*
	Name: function_c2614d30
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xC6501AE6
	Offset: 0x4F30
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private function_c2614d30(entity)
{
	entity show();
	entity pathmode("move allowed");
	entity.isteleporting = 0;
	entity.var_5df615f0 = 0;
}

/*
	Name: function_9a9f35ac
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xEA5FFC8A
	Offset: 0x4FA0
	Size: 0x244
	Parameters: 1
	Flags: Linked, Private
*/
function private function_9a9f35ac(entity)
{
	entity endon(#"death");
	var_3e944f2d = 0;
	entity.var_3c58b79c = 0;
	entity.var_187c138e = 1;
	entity.var_1ab20b9b = undefined;
	var_5ba5953 = anglestoforward(entity.angles);
	var_bc39bd09 = (entity.origin + vectorscale((0, 0, 1), 72)) + (var_5ba5953 * 96);
	var_1be3af57 = entity.angles;
	entity waittill(#"hash_64a0057e");
	entity clientfield::set("shadow_margwa_attack_portal_fx", 1);
	wait(0.5);
	target = undefined;
	if(isdefined(entity.favoriteenemy))
	{
		position = var_bc39bd09 + (var_5ba5953 * 96);
		target = spawn("script_model", position);
		target setmodel("tag_origin");
		target.var_8002cc8a = entity.favoriteenemy;
		target.owner = entity;
		target thread function_9a821f95();
	}
	while(var_3e944f2d < 4)
	{
		entity function_8969ba81(var_bc39bd09, var_1be3af57, target);
		var_3e944f2d = var_3e944f2d + 1;
		wait(0.25);
	}
	entity clientfield::set("shadow_margwa_attack_portal_fx", 0);
}

/*
	Name: function_ae1bcedd
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xD13490B0
	Offset: 0x51F0
	Size: 0x28
	Parameters: 1
	Flags: Linked, Private
*/
function private function_ae1bcedd(entity)
{
	entity.var_1ab20b9b = gettime() + 1000;
}

/*
	Name: function_58c0f99d
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x4851C739
	Offset: 0x5220
	Size: 0x20
	Parameters: 1
	Flags: Linked, Private
*/
function private function_58c0f99d(entity)
{
	entity.var_6a2ba141 = 1;
}

/*
	Name: function_d89cf919
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x1F78DE31
	Offset: 0x5248
	Size: 0x48
	Parameters: 1
	Flags: Linked, Private
*/
function private function_d89cf919(entity)
{
	entity.var_187c138e = 0;
	entity.var_6a2ba141 = 0;
	entity.var_70f89c94 = gettime() + 100000;
}

/*
	Name: function_9a821f95
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x9CD9F674
	Offset: 0x5298
	Size: 0x35C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_9a821f95()
{
	self.owner util::waittill_any("shadow_margwa_skull_launched", "death");
	self.owner.var_ed0c0558 = array::remove_undefined(self.owner.var_ed0c0558, 0);
	margwa = self.owner;
	while(isdefined(self) && isdefined(self.var_8002cc8a) && isalive(self.var_8002cc8a) && isdefined(self.owner) && isdefined(self.owner.var_ed0c0558) && self.owner.var_ed0c0558.size > 0)
	{
		eye_position = self.var_8002cc8a gettagorigin("tag_eye");
		self.owner.var_ed0c0558 = array::remove_undefined(self.owner.var_ed0c0558, 0);
		if(distancesquared(self.origin, eye_position) <= 10000)
		{
			if(!(isdefined(self.var_d7c0356e) && self.var_d7c0356e))
			{
				self.origin = eye_position;
				self linkto(self.var_8002cc8a, "tag_eye");
				self.var_d7c0356e = 1;
			}
		}
		else
		{
			var_2dca088d = eye_position - self.origin;
			var_6c4cc94d = vectornormalize(var_2dca088d);
			var_4037a81b = var_6c4cc94d * 50;
			var_5ae4b928 = self.origin + var_4037a81b;
			var_81e4178f = eye_position[2] - self.origin[2];
			bullet_trace = bullettrace(var_5ae4b928 + (0, 0, var_81e4178f), var_5ae4b928 - (0, 0, var_81e4178f), 0, self.var_8002cc8a);
			if(isdefined(bullet_trace["position"]))
			{
				var_5ae4b928 = bullet_trace["position"] + (0, 0, var_81e4178f);
			}
			self moveto(var_5ae4b928, 0.2);
		}
		wait(0.2);
	}
	margwa function_e268d040();
	if(isdefined(self))
	{
		if(isdefined(self.var_d7c0356e) && self.var_d7c0356e)
		{
			self unlink();
		}
		self delete();
	}
}

/*
	Name: function_8969ba81
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x80539E3B
	Offset: 0x5600
	Size: 0x260
	Parameters: 3
	Flags: Linked, Private
*/
function private function_8969ba81(var_bc39bd09, var_1be3af57, target = undefined)
{
	entity = self;
	weapon = getweapon("launcher_shadow_margwa");
	if(!isdefined(entity.var_ed0c0558))
	{
		entity.var_ed0c0558 = [];
	}
	vector = anglestoforward(var_1be3af57);
	vector = vector * 250;
	vector = vector + vectorscale((0, 0, 1), 250);
	var_c4d58545 = randomint(100) - 50;
	var_36db14ca = randomint(100) - 50;
	var_71c4e537 = randomint(50) - 25;
	var_4126099a = vector + (var_c4d58545, var_36db14ca, var_71c4e537);
	if(!isdefined(target))
	{
		skull = entity magicmissile(weapon, var_bc39bd09, var_4126099a);
		skull thread function_16cddcb6();
		entity.var_ed0c0558[entity.var_ed0c0558.size] = skull;
		entity notify(#"shadow_margwa_skull_launched");
	}
	else
	{
		skull = entity magicmissile(weapon, var_bc39bd09, var_4126099a, target);
		skull thread function_16cddcb6();
		entity.var_ed0c0558[entity.var_ed0c0558.size] = skull;
		entity notify(#"shadow_margwa_skull_launched");
	}
}

/*
	Name: function_16cddcb6
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x51B07486
	Offset: 0x5868
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function function_16cddcb6()
{
	self.takedamage = 1;
	var_b5f846f3 = 0;
	var_b52ddb1c = 100;
	if(isdefined(level.var_928e29b4))
	{
		var_b52ddb1c = level.var_928e29b4;
	}
	while(isdefined(self))
	{
		self waittill(#"damage", n_damage, e_attacker);
		if(isplayer(e_attacker))
		{
			var_b5f846f3 = var_b5f846f3 + n_damage;
			if(var_b5f846f3 >= var_b52ddb1c)
			{
				self detonate();
			}
		}
	}
}

/*
	Name: function_d765e859
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xCFB2F5B5
	Offset: 0x5938
	Size: 0x48
	Parameters: 1
	Flags: Linked, Private
*/
function private function_d765e859(entity)
{
	entity function_246f9ba8();
	entity.isteleporting = 1;
	entity.var_e9353b19 = 0;
}

/*
	Name: function_4600a191
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x5C258477
	Offset: 0x5988
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_4600a191(entity)
{
	entity ghost();
	entity pathmode("dont move");
	entity thread function_2f67316c();
}

/*
	Name: function_2f67316c
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xE329BC10
	Offset: 0x59F0
	Size: 0x118
	Parameters: 0
	Flags: Linked, Private
*/
function private function_2f67316c()
{
	self.waiting = 1;
	var_c37d9885 = vectorscale((0, 0, 1), 64);
	self function_258d1434(var_c37d9885, 240, 480);
	if(isdefined(self.var_937645c5))
	{
		self.var_937645c5 clientfield::set("margwa_defense_hovering_fx", 4);
	}
	if(isdefined(self.var_b978c02e))
	{
		self.var_b978c02e clientfield::set("margwa_defense_hovering_fx", 4);
	}
	if(isdefined(self.var_df7b3a97))
	{
		self.var_df7b3a97 clientfield::set("margwa_defense_hovering_fx", 4);
	}
	self forceteleport(self.var_58b84a32);
	wait(1);
	self.waiting = 0;
	self.var_5760b1de = 1;
}

/*
	Name: function_d258371e
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xA11FCFD
	Offset: 0x5B10
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_d258371e(entity)
{
	entity show();
	entity pathmode("move allowed");
	entity.isteleporting = 0;
	entity.var_5760b1de = 0;
	entity thread function_34067c01();
}

/*
	Name: function_34067c01
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xC9183A96
	Offset: 0x5B98
	Size: 0x114
	Parameters: 0
	Flags: Linked, Private
*/
function private function_34067c01()
{
	if(isdefined(self.var_937645c5))
	{
		self.var_937645c5 clientfield::set("margwa_defense_hovering_fx", 0);
	}
	if(isdefined(self.var_b978c02e))
	{
		self.var_b978c02e clientfield::set("margwa_defense_hovering_fx", 0);
	}
	if(isdefined(self.var_df7b3a97))
	{
		self.var_df7b3a97 clientfield::set("margwa_defense_hovering_fx", 0);
	}
	wait(0.05);
	if(isdefined(self.var_937645c5))
	{
		self.var_937645c5 delete();
	}
	if(isdefined(self.var_b978c02e))
	{
		self.var_b978c02e delete();
	}
	if(isdefined(self.var_df7b3a97))
	{
		self.var_df7b3a97 delete();
	}
}

/*
	Name: function_308ca6aa
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x8F2688CA
	Offset: 0x5CB8
	Size: 0x15A
	Parameters: 4
	Flags: Linked, Private
*/
function private function_308ca6aa(position, range, damage, damage_mod)
{
	margwa = self;
	players = getplayers();
	range_sq = range * range;
	foreach(player in players)
	{
		if(player laststand::player_is_in_laststand())
		{
			continue;
		}
		dist_sq = distancesquared(position, player.origin);
		if(dist_sq <= range_sq)
		{
			player dodamage(damage, position, margwa, undefined, undefined, damage_mod);
		}
	}
}

/*
	Name: function_5ff4198
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xC2EAFE17
	Offset: 0x5E20
	Size: 0x10C
	Parameters: 12
	Flags: Linked
*/
function function_5ff4198(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(isdefined(weapon) && weapon == getweapon("launcher_shadow_margwa"))
	{
		if(isdefined(attacker) && (self == attacker || self.team == attacker.team))
		{
			if(self.archetype === "zombie" && zm_elemental_zombie::function_b804eb62(self))
			{
				self zm_shadow_zombie::function_1b2b62b();
			}
			return 0;
		}
	}
	return -1;
}

/*
	Name: function_258d1434
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x6F96C3FC
	Offset: 0x5F38
	Size: 0x338
	Parameters: 3
	Flags: Linked
*/
function function_258d1434(var_c37d9885, var_6cd7eac7, var_19d406c9)
{
	var_58b84a32 = self.origin;
	if(isdefined(self.favoriteenemy))
	{
		var_58b84a32 = self.favoriteenemy.origin;
	}
	queryresult = positionquery_source_navigation(var_58b84a32, var_6cd7eac7, var_19d406c9, 256, 96, self);
	pointlist = array::randomize(queryresult.data);
	pointlist = array::filter(pointlist, 0, &function_794b06f);
	if(pointlist.size > 0)
	{
		self.var_58b84a32 = pointlist[0].origin;
		self.var_937645c5 = spawn("script_model", self.var_58b84a32 + var_c37d9885);
		self.var_937645c5 setmodel("tag_origin");
		var_d1122efb = 1;
		if(isdefined(pointlist[1]))
		{
			self.var_b978c02e = spawn("script_model", pointlist[1].origin + var_c37d9885);
			self.var_b978c02e setmodel("tag_origin");
			var_d1122efb = var_d1122efb + 1;
			if(isdefined(pointlist[2]))
			{
				self.var_df7b3a97 = spawn("script_model", pointlist[2].origin + var_c37d9885);
				self.var_df7b3a97 setmodel("tag_origin");
				var_d1122efb = var_d1122efb + 1;
			}
		}
	}
	else
	{
		self.var_58b84a32 = self.origin;
		self.var_937645c5 = spawn("script_model", self.var_58b84a32 + var_c37d9885);
		self.var_937645c5 setmodel("tag_origin");
		var_d1122efb = 1;
	}
	var_ce0ccfb0 = randomint(var_d1122efb);
	if(var_ce0ccfb0 === 1)
	{
		self.var_58b84a32 = pointlist[1].origin;
	}
	if(var_ce0ccfb0 === 2)
	{
		self.var_58b84a32 = pointlist[2].origin;
	}
}

/*
	Name: function_2ab5f647
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xAAE5B5FC
	Offset: 0x6278
	Size: 0x2FE
	Parameters: 6
	Flags: Linked
*/
function function_2ab5f647(e_player, v_attack_source, n_push_away, n_lift_height, v_lift_offset, n_lift_speed)
{
	self endon(#"death");
	if(isdefined(self.in_gravity_trap) && self.in_gravity_trap && e_player.gravityspikes_state === 3)
	{
		if(isdefined(self.var_1f5fe943) && self.var_1f5fe943)
		{
			return;
		}
		self.var_bcecff1d = 1;
		self.var_1f5fe943 = 1;
		self dodamage(10, self.origin);
		self.var_3abf1eec = self.origin;
		scene = "cin_zm_dlc4_margwa_dth_deathray_01";
		if(self.var_f9ebd43e === "fire")
		{
			scene = "cin_zm_dlc4_margwa_fire_dth_deathray_01";
		}
		if(self.var_f9ebd43e === "shadow")
		{
			scene = "cin_zm_dlc4_margwa_shadow_dth_deathray_01";
		}
		self thread scene::play(scene, self);
		self clientfield::set("sparky_beam_fx", 1);
		self clientfield::set("margwa_shock_fx", 1);
		self playsound("zmb_talon_electrocute");
		n_start_time = gettime();
		n_total_time = 0;
		while(10 > n_total_time && e_player.gravityspikes_state === 3)
		{
			util::wait_network_frame();
			n_total_time = (gettime() - n_start_time) / 1000;
		}
		self scene::stop(scene);
		self thread function_3f3b0b14(self);
		self clientfield::set("sparky_beam_fx", 0);
		self clientfield::set("margwa_shock_fx", 0);
		self.var_bcecff1d = undefined;
		while(e_player.gravityspikes_state === 3)
		{
			util::wait_network_frame();
		}
		self.var_1f5fe943 = undefined;
		self.in_gravity_trap = undefined;
	}
	else
	{
		if(!(isdefined(self.reactstun) && self.reactstun))
		{
			self.reactstun = 1;
		}
		self.in_gravity_trap = undefined;
	}
}

/*
	Name: function_3f3b0b14
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x6D37DF90
	Offset: 0x6580
	Size: 0x204
	Parameters: 1
	Flags: Linked
*/
function function_3f3b0b14(margwa)
{
	margwa endon(#"death");
	if(isdefined(margwa))
	{
		self.var_3abf1eec = self.origin;
		scene = "cin_zm_dlc4_margwa_dth_deathray_02";
		if(self.var_f9ebd43e === "fire")
		{
			scene = "cin_zm_dlc4_margwa_fire_dth_deathray_02";
		}
		if(self.var_f9ebd43e === "shadow")
		{
			scene = "cin_zm_dlc4_margwa_shadow_dth_deathray_02";
		}
		margwa scene::play(scene, margwa);
	}
	if(isdefined(margwa) && isalive(margwa) && isdefined(margwa.var_3abf1eec))
	{
		v_eye_pos = margwa gettagorigin("tag_eye");
		/#
			recordline(margwa.origin, v_eye_pos, vectorscale((0, 1, 0), 255), "", margwa);
		#/
		trace = bullettrace(v_eye_pos, margwa.origin, 0, margwa);
		if(trace["position"] !== margwa.origin)
		{
			point = getclosestpointonnavmesh(trace["position"], 64, 30);
			if(!isdefined(point))
			{
				point = margwa.var_3abf1eec;
			}
			margwa forceteleport(point);
		}
	}
}

/*
	Name: function_15492d9b
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x214498E1
	Offset: 0x6790
	Size: 0x248
	Parameters: 0
	Flags: Linked
*/
function function_15492d9b()
{
	/#
		wait(0.05);
		level waittill(#"start_zombie_round_logic");
		wait(0.05);
		str_cmd = "";
		adddebugcommand(str_cmd);
		str_cmd = "";
		adddebugcommand(str_cmd);
		str_cmd = "";
		adddebugcommand(str_cmd);
		str_cmd = "";
		adddebugcommand(str_cmd);
		while(true)
		{
			string = getdvarstring("");
			if(string === "")
			{
				level thread function_a06aa49e();
				setdvar("", "");
			}
			string = getdvarstring("");
			if(string === "")
			{
				level thread function_50a5b7b6();
				setdvar("", "");
			}
			string = getdvarstring("");
			if(string === "")
			{
				level thread function_d11bf3e();
				setdvar("", "");
			}
			string = getdvarstring("");
			if(string === "")
			{
				level thread function_156bbea2();
				setdvar("", "");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_a06aa49e
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xF27BB573
	Offset: 0x69E0
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_a06aa49e()
{
	/#
		players = getplayers();
		var_fda751f9 = getspawnerarray("", "");
		if(var_fda751f9.size <= 0)
		{
			iprintln("");
			return;
		}
		margwa_spawner = var_fda751f9[0];
		queryresult = positionquery_source_navigation(players[0].origin, 128, 256, 128, 20);
		spot = spawnstruct();
		spot.origin = players[0].origin;
		if(isdefined(queryresult) && queryresult.data.size > 0)
		{
			spot.origin = queryresult.data[0].origin;
		}
		level function_75b161ab(margwa_spawner, spot);
	#/
}

/*
	Name: function_156bbea2
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x5C5ECDB7
	Offset: 0x6B60
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_156bbea2()
{
	/#
		players = getplayers();
		var_5e8312fd = getspawnerarray("", "");
		if(var_5e8312fd.size <= 0)
		{
			iprintln("");
			return;
		}
		margwa_spawner = var_5e8312fd[0];
		queryresult = positionquery_source_navigation(players[0].origin, 128, 256, 128, 20);
		spot = spawnstruct();
		spot.origin = players[0].origin;
		if(isdefined(queryresult) && queryresult.data.size > 0)
		{
			spot.origin = queryresult.data[0].origin;
		}
		level function_26efbc37(margwa_spawner, spot);
	#/
}

/*
	Name: function_f6720b6e
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xFA103A34
	Offset: 0x6CE0
	Size: 0x174
	Parameters: 0
	Flags: None
*/
function function_f6720b6e()
{
	/#
		players = getplayers();
		var_1977e3bb = getspawnerarray("", "");
		if(var_1977e3bb.size <= 0)
		{
			iprintln("");
			return;
		}
		margwa_spawner = var_1977e3bb[0];
		queryresult = positionquery_source_navigation(players[0].origin, 128, 256, 128, 20);
		spot = spawnstruct();
		spot.origin = players[0].origin;
		if(isdefined(queryresult) && queryresult.data.size > 0)
		{
			spot.origin = queryresult.data[0].origin;
		}
		level function_12301fd1(margwa_spawner, spot);
	#/
}

/*
	Name: function_812b0245
	Namespace: zm_ai_margwa_elemental
	Checksum: 0x9683E9A3
	Offset: 0x6E60
	Size: 0x174
	Parameters: 0
	Flags: None
*/
function function_812b0245()
{
	/#
		players = getplayers();
		var_9ceb03c8 = getspawnerarray("", "");
		if(var_9ceb03c8.size <= 0)
		{
			iprintln("");
			return;
		}
		margwa_spawner = var_9ceb03c8[0];
		queryresult = positionquery_source_navigation(players[0].origin, 128, 256, 128, 20);
		spot = spawnstruct();
		spot.origin = players[0].origin;
		if(isdefined(queryresult) && queryresult.data.size > 0)
		{
			spot.origin = queryresult.data[0].origin;
		}
		level function_5b1c9e5c(margwa_spawner, spot);
	#/
}

/*
	Name: function_50a5b7b6
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xB1F9038A
	Offset: 0x6FE0
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_50a5b7b6()
{
	/#
		var_9ca661a2 = getaiarchetypearray("");
		foreach(margwa in var_9ca661a2)
		{
			margwa kill();
		}
	#/
}

/*
	Name: function_d11bf3e
	Namespace: zm_ai_margwa_elemental
	Checksum: 0xC53687F9
	Offset: 0x70A0
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function function_d11bf3e()
{
	/#
		var_9ca661a2 = getaiarchetypearray("");
		foreach(margwa in var_9ca661a2)
		{
			if(!isdefined(margwa.debughealth))
			{
				margwa.debughealth = 1;
				continue;
			}
			margwa.debughealth = !margwa.debughealth;
		}
	#/
}

