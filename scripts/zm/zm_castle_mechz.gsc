// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\mechz;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_elemental_bow;
#using scripts\zm\zm_castle;
#using scripts\zm\zm_castle_ee_side;
#using scripts\zm\zm_castle_vo;

#namespace zm_castle_mechz;

/*
	Name: init
	Namespace: zm_castle_mechz
	Checksum: 0xE8FA6C22
	Offset: 0x578
	Size: 0xD4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_dd3133f7();
	level flag::init("can_spawn_mechz", 1);
	spawner::add_archetype_spawn_function("mechz", &function_d8d01032);
	level thread function_76e7495b();
	level.mechz_should_stun_override = &function_f517cdd6;
	level.mechz_faceplate_damage_override = &function_bddef31c;
	level.var_7f2a926d = &mechz_health_increases;
	/#
		level thread function_78e44cda();
	#/
}

/*
	Name: function_dd3133f7
	Namespace: zm_castle_mechz
	Checksum: 0xA07673BB
	Offset: 0x658
	Size: 0x12C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_dd3133f7()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("castleMechzTrapService", &function_78c0d00b);
	behaviortreenetworkutility::registerbehaviortreescriptapi("castleMechzShouldMoveToTrap", &function_697928b7);
	behaviortreenetworkutility::registerbehaviortreescriptapi("castleMechzIsAtTrap", &function_829fa81c);
	behaviortreenetworkutility::registerbehaviortreescriptapi("castleMechzShouldAttackTrap", &function_e4f26ac8);
	behaviortreenetworkutility::registerbehaviortreescriptapi("casteMechzTrapMoveTerminate", &function_cf4879ad);
	behaviortreenetworkutility::registerbehaviortreescriptapi("casteMechzTrapAttackTerminate", &function_7c295452);
	animationstatenetwork::registeranimationmocomp("mocomp_trap_attack@mechz", &function_f467e83, undefined, &function_e37c4112);
}

/*
	Name: function_76e7495b
	Namespace: zm_castle_mechz
	Checksum: 0x6D594467
	Offset: 0x790
	Size: 0xCE
	Parameters: 0
	Flags: Linked, Private
*/
function private function_76e7495b()
{
	wait(0.5);
	traps = getentarray("zombie_trap", "targetname");
	foreach(trap in traps)
	{
		if(trap.script_noteworthy == "electric")
		{
			level.electric_trap = trap;
		}
	}
}

/*
	Name: function_78c0d00b
	Namespace: zm_castle_mechz
	Checksum: 0xA8A9DC3A
	Offset: 0x868
	Size: 0x126
	Parameters: 1
	Flags: Linked, Private
*/
function private function_78c0d00b(entity)
{
	if(isdefined(entity.var_7c963fc4) && entity.var_7c963fc4 || (isdefined(entity.var_8993e21) && entity.var_8993e21))
	{
		return true;
	}
	if(level flag::get("masher_on"))
	{
		if(entity function_ced5d8b0("masher_trap_switch"))
		{
			return true;
		}
	}
	if(isdefined(level.electric_trap))
	{
		if(isdefined(level.electric_trap._trap_in_use) && level.electric_trap._trap_in_use && (!(isdefined(level.electric_trap._trap_cooling_down) && level.electric_trap._trap_cooling_down)))
		{
			if(entity function_ced5d8b0("elec_trap_switch"))
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: function_ced5d8b0
	Namespace: zm_castle_mechz
	Checksum: 0xD4A5BB50
	Offset: 0x998
	Size: 0x184
	Parameters: 1
	Flags: Linked, Private
*/
function private function_ced5d8b0(var_2dba2212)
{
	traps = struct::get_array(var_2dba2212, "script_noteworthy");
	self.trap_struct = undefined;
	closest_dist_sq = 57600;
	foreach(trap in traps)
	{
		dist_sq = distancesquared(trap.origin, self.origin);
		if(dist_sq < closest_dist_sq)
		{
			closest_dist_sq = dist_sq;
			self.trap_struct = trap;
		}
	}
	if(isdefined(self.trap_struct))
	{
		self.var_7c963fc4 = 1;
		self.ignoreall = 1;
		self setgoal(self.trap_struct.origin);
		self thread function_216e21ed();
		return true;
	}
	return false;
}

/*
	Name: function_216e21ed
	Namespace: zm_castle_mechz
	Checksum: 0x32355299
	Offset: 0xB28
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_216e21ed()
{
	self endon(#"death");
	wait(60);
	if(isdefined(self.var_7c963fc4) && self.var_7c963fc4 || (isdefined(self.var_8993e21) && self.var_8993e21) || (isdefined(self.ignoreall) && self.ignoreall))
	{
		self.var_7c963fc4 = 0;
		self.var_8993e21 = 0;
		self.ignoreall = 0;
		mechzbehavior::mechztargetservice(self);
	}
}

/*
	Name: function_697928b7
	Namespace: zm_castle_mechz
	Checksum: 0xE2C011FD
	Offset: 0xBC8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function function_697928b7(entity)
{
	if(isdefined(entity.var_7c963fc4) && entity.var_7c963fc4)
	{
		return true;
	}
	return false;
}

/*
	Name: function_829fa81c
	Namespace: zm_castle_mechz
	Checksum: 0xC965D4A1
	Offset: 0xC10
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function function_829fa81c(entity)
{
	if(entity isatgoal())
	{
		return true;
	}
	return false;
}

/*
	Name: function_e4f26ac8
	Namespace: zm_castle_mechz
	Checksum: 0x9F07A3E7
	Offset: 0xC48
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function function_e4f26ac8(entity)
{
	if(isdefined(entity.var_8993e21) && entity.var_8993e21)
	{
		return true;
	}
	return false;
}

/*
	Name: function_cf4879ad
	Namespace: zm_castle_mechz
	Checksum: 0xB1D25D7F
	Offset: 0xC90
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_cf4879ad(entity)
{
	entity.var_7c963fc4 = 0;
	entity.var_8993e21 = 1;
}

/*
	Name: function_7c295452
	Namespace: zm_castle_mechz
	Checksum: 0x13DF757E
	Offset: 0xCC8
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_7c295452(entity)
{
	entity.var_8993e21 = 0;
	entity.ignoreall = 0;
	if(isdefined(entity.trap_struct))
	{
		if(entity.trap_struct.script_noteworthy == "masher_trap_switch")
		{
			level flag::clear("masher_on");
		}
		else
		{
			level.electric_trap notify(#"trap_deactivate");
		}
	}
	mechzbehavior::mechztargetservice(entity);
}

/*
	Name: function_f467e83
	Namespace: zm_castle_mechz
	Checksum: 0xE5B8BD5E
	Offset: 0xD88
	Size: 0x84
	Parameters: 5
	Flags: Linked
*/
function function_f467e83(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.trap_struct.angles[1]);
	entity animmode("normal");
}

/*
	Name: function_e37c4112
	Namespace: zm_castle_mechz
	Checksum: 0xAC0D896E
	Offset: 0xE18
	Size: 0x4C
	Parameters: 5
	Flags: Linked
*/
function function_e37c4112(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face default");
}

/*
	Name: enable_mechz_rounds
	Namespace: zm_castle_mechz
	Checksum: 0x530BE3D1
	Offset: 0xE70
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function enable_mechz_rounds()
{
	/#
		if(getdvarint("") >= 2)
		{
			return;
		}
	#/
	level.var_76df55d3 = 1;
	level.var_28066209 = 0;
	level.var_f4dc2834 = 3062.5;
	level.var_c1f907b2 = 1750;
	level.var_42fd61f0 = 3500;
	level.var_42ee1b54 = level.var_42fd61f0 - level.var_c1f907b2;
	level thread mechz_round_tracker();
}

/*
	Name: mechz_health_increases
	Namespace: zm_castle_mechz
	Checksum: 0x6BA7471C
	Offset: 0xF20
	Size: 0x2EC
	Parameters: 0
	Flags: Linked
*/
function mechz_health_increases()
{
	if(!isdefined(level.mechz_last_spawn_round) || level.round_number > level.mechz_last_spawn_round)
	{
		a_players = getplayers();
		n_player_modifier = 1;
		switch(a_players.size)
		{
			case 0:
			case 1:
			{
				n_player_modifier = 1;
				break;
			}
			case 2:
			{
				n_player_modifier = 1.33;
				break;
			}
			case 3:
			{
				n_player_modifier = 1.66;
				break;
			}
			case 4:
			{
				n_player_modifier = 2;
				break;
			}
		}
		var_485a2c2c = level.zombie_health / level.zombie_vars["zombie_health_start"];
		level.mechz_health = int(n_player_modifier * (level.mechz_base_health + (level.mechz_health_increase * var_485a2c2c)));
		level.mechz_faceplate_health = int(n_player_modifier * (level.var_fa14536d + (level.var_1a5bb9d8 * var_485a2c2c)));
		level.mechz_powercap_cover_health = int(n_player_modifier * (level.mechz_powercap_cover_health + (level.var_a1943286 * var_485a2c2c)));
		level.mechz_powercap_health = int(n_player_modifier * (level.mechz_powercap_health + (level.var_9684c99e * var_485a2c2c)));
		level.var_2cbc5b59 = int(n_player_modifier * (level.var_3f1bf221 + (level.var_158234c * var_485a2c2c)));
		level.mechz_health = function_26beb37e(level.mechz_health, 17500, n_player_modifier);
		level.mechz_faceplate_health = function_26beb37e(level.mechz_faceplate_health, 16000, n_player_modifier);
		level.mechz_powercap_cover_health = function_26beb37e(level.mechz_powercap_cover_health, 7500, n_player_modifier);
		level.mechz_powercap_health = function_26beb37e(level.mechz_powercap_health, 5000, n_player_modifier);
		level.var_2cbc5b59 = function_26beb37e(level.var_2cbc5b59, 3500, n_player_modifier);
		level.mechz_last_spawn_round = level.round_number;
	}
}

/*
	Name: function_26beb37e
	Namespace: zm_castle_mechz
	Checksum: 0xACB1259E
	Offset: 0x1218
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function function_26beb37e(value, limit, var_69de4866)
{
	if(value >= (limit * var_69de4866))
	{
		value = int(limit * var_69de4866);
	}
	return value;
}

/*
	Name: mechz_round_tracker
	Namespace: zm_castle_mechz
	Checksum: 0xF3253F50
	Offset: 0x1278
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function mechz_round_tracker()
{
	level.var_b20dd348 = randomintrange(12, 13);
	level.var_2f0a5661 = 0;
	while(true)
	{
		while(level.round_number < level.var_b20dd348)
		{
			level waittill(#"between_round_over");
			/#
				if(level.round_number > level.var_b20dd348)
				{
					level.var_b20dd348 = level.round_number + 1;
				}
			#/
		}
		if(level flag::get("dog_round") && level.dog_round_count == 1)
		{
			level.var_b20dd348++;
		}
		else if(level.var_b20dd348 >= level.round_number)
		{
			function_6592b947();
		}
		level waittill(#"start_of_round");
	}
}

/*
	Name: function_6592b947
	Namespace: zm_castle_mechz
	Checksum: 0xD40561CD
	Offset: 0x1380
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_6592b947()
{
	var_b29defde = function_c7730c11();
	wait(5);
	while(var_b29defde > 0)
	{
		while(!function_b1a145c4())
		{
			wait(1);
		}
		ai_mechz = function_314d744b(1);
		if(isdefined(ai_mechz))
		{
			var_b29defde--;
			ai_mechz thread zm_castle_vo::function_5e426b67();
			ai_mechz thread zm_castle_vo::function_e8a09e6e();
		}
		if(var_b29defde > 0)
		{
			wait(randomfloatrange(5, 10));
		}
	}
	level.var_b20dd348 = level.round_number + randomintrange(5, 7);
	level.mechz_round_count++;
}

/*
	Name: function_b1a145c4
	Namespace: zm_castle_mechz
	Checksum: 0x283E7125
	Offset: 0x14A8
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_b1a145c4()
{
	var_f52ee0b1 = zombie_utility::get_current_zombie_count() >= level.zombie_ai_limit;
	if(var_f52ee0b1 || !level flag::get("spawn_zombies") || !level flag::get("can_spawn_mechz"))
	{
		return false;
	}
	return true;
}

/*
	Name: function_c7730c11
	Namespace: zm_castle_mechz
	Checksum: 0xD63FD880
	Offset: 0x1528
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function function_c7730c11()
{
	level.var_28066209++;
	if(level.players.size == 1)
	{
		if(level.var_28066209 == 1 || level.var_28066209 == 2)
		{
			return 1;
		}
		return 1;
	}
	if(level.var_28066209 == 1 || level.var_28066209 == 2)
	{
		return 1;
	}
	if(level.var_28066209 == 3 || level.var_28066209 == 4)
	{
		return 2;
	}
	return 3;
}

/*
	Name: function_d8d01032
	Namespace: zm_castle_mechz
	Checksum: 0x137F0305
	Offset: 0x15E0
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function function_d8d01032()
{
	level.var_2f0a5661++;
	level.zombie_ai_limit--;
	level thread achievement_watcher(self);
	self thread function_b2a1b297();
	self waittill(#"death");
	self thread function_2a2bfc25();
	if(isdefined(self.attacker) && isplayer(self.attacker) && self.attacker hasweapon(getweapon("knife_plunger")))
	{
		level thread zm_castle_ee_side::function_c7bb86e5(self.attacker);
	}
	level.var_2f0a5661--;
	level.zombie_ai_limit++;
	level notify(#"hash_8f65ad3d");
}

/*
	Name: function_b2a1b297
	Namespace: zm_castle_mechz
	Checksum: 0x11D6F9FE
	Offset: 0x16F0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_b2a1b297()
{
	self waittill(#"actor_corpse", mechz);
	wait(60);
	if(isdefined(mechz))
	{
		mechz delete();
	}
}

/*
	Name: function_2a2bfc25
	Namespace: zm_castle_mechz
	Checksum: 0x17454DBF
	Offset: 0x1740
	Size: 0xFE
	Parameters: 0
	Flags: Linked
*/
function function_2a2bfc25()
{
	self waittill(#"hash_46c1e51d");
	if(level flag::get("gravityspike_part_body_found"))
	{
		if(level flag::get("zombie_drop_powerups") && (!(isdefined(self.no_powerups) && self.no_powerups)))
		{
			a_bonus_types = array("double_points", "insta_kill", "full_ammo", "nuke");
			str_type = array::random(a_bonus_types);
			zm_powerups::specific_powerup_drop(str_type, self.origin);
		}
	}
	else
	{
		level notify(#"hash_b650259c", self.origin);
	}
}

/*
	Name: function_314d744b
	Namespace: zm_castle_mechz
	Checksum: 0x1F1A0F2B
	Offset: 0x1848
	Size: 0x208
	Parameters: 3
	Flags: Linked
*/
function function_314d744b(var_2533389a, s_loc, var_4211ee1f = 1)
{
	if(!isdefined(s_loc))
	{
		if(level.zm_loc_types["mechz_location"].size == 0)
		{
			var_79ed5347 = struct::get_array("mechz_location", "script_noteworthy");
			foreach(var_6000fab5 in var_79ed5347)
			{
				if(var_6000fab5.targetname == "zone_start_spawners")
				{
					s_loc = var_6000fab5;
				}
			}
		}
		else
		{
			s_loc = array::random(level.zm_loc_types["mechz_location"]);
		}
	}
	level thread zm_castle_vo::function_894d806e(s_loc);
	mechz_health_increases();
	ai_mechz = zm_ai_mechz::spawn_mechz(s_loc, var_4211ee1f);
	level.var_9618f5be = ai_mechz;
	level notify(#"hash_b4c3cb33");
	if(isdefined(ai_mechz))
	{
		ai_mechz.b_ignore_cleanup = 1;
	}
	if(!(isdefined(var_2533389a) && var_2533389a))
	{
		level.var_b20dd348 = level.round_number + randomintrange(4, 6);
	}
	return ai_mechz;
}

/*
	Name: achievement_watcher
	Namespace: zm_castle_mechz
	Checksum: 0x2134EA30
	Offset: 0x1A58
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function achievement_watcher(ai_mechz)
{
	ai_mechz waittill(#"death", attacker, meansofdeath);
	if(isdefined(attacker.currentweapon) && attacker.currentweapon.name === "minigun")
	{
		arrayremovevalue(attacker.var_544cf8c7, ai_mechz.archetype);
	}
	if(isdefined(ai_mechz.var_bcecff1d) && ai_mechz.var_bcecff1d)
	{
		attacker notify(#"hash_a72ebab5");
	}
}

/*
	Name: function_f517cdd6
	Namespace: zm_castle_mechz
	Checksum: 0x12B23DD1
	Offset: 0x1B28
	Size: 0xFE
	Parameters: 12
	Flags: Linked
*/
function function_f517cdd6(inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	switch(weapon.name)
	{
		case "elemental_bow_demongate4":
		case "elemental_bow_rune_prison4":
		case "elemental_bow_wolf_howl4":
		{
			if(!(isdefined(self.var_98056717) && self.var_98056717))
			{
				self.stun = 1;
			}
			break;
		}
		case "elemental_bow_demongate":
		{
			if(isdefined(inflictor) && inflictor.classname != "rocket")
			{
				self.stun = 1;
			}
			break;
		}
	}
}

/*
	Name: function_bddef31c
	Namespace: zm_castle_mechz
	Checksum: 0x3E3C694C
	Offset: 0x1C30
	Size: 0x114
	Parameters: 12
	Flags: Linked
*/
function function_bddef31c(inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	if(issubstr(weapon.name, "elemental_bow"))
	{
		var_45d7f4c0 = self.health - (damage * 0.2);
		var_be912ff6 = var_45d7f4c0 / level.mechz_health;
		if(self.has_faceplate == 1 && var_be912ff6 < 0.5)
		{
			self mechzserverutils::mechz_track_faceplate_damage(self.faceplate_health + 100);
		}
	}
}

/*
	Name: function_78e44cda
	Namespace: zm_castle_mechz
	Checksum: 0x58D67077
	Offset: 0x1D50
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function function_78e44cda()
{
	/#
		wait(0.05);
		level waittill(#"start_zombie_round_logic");
		wait(0.05);
		setdvar("", 0);
		adddebugcommand("");
		while(true)
		{
			if(getdvarint(""))
			{
				setdvar("", 0);
				level thread function_eac1444a();
			}
			wait(0.5);
		}
	#/
}

/*
	Name: function_eac1444a
	Namespace: zm_castle_mechz
	Checksum: 0xCC7509E4
	Offset: 0x1E10
	Size: 0x282
	Parameters: 0
	Flags: Linked
*/
function function_eac1444a()
{
	/#
		var_10b176f0 = getaiarchetypearray("");
		foreach(ai_mechz in var_10b176f0)
		{
			var_efe3c52f = level.activeplayers[0] gettagorigin("") + vectorscale((0, 0, 1), 20);
			var_7ddc55f4 = level.activeplayers[0] gettagorigin("") + (5, 0, 20);
			var_a3ded05d = level.activeplayers[0] gettagorigin("") + (-5, 0, 20);
			var_31d76122 = level.activeplayers[0] gettagorigin("") + vectorscale((0, 0, 1), 15);
			magicbullet(level.var_e106fba5, var_efe3c52f, ai_mechz getcentroid(), level.activeplayers[0]);
			magicbullet(level.var_791ba87b, var_7ddc55f4, ai_mechz getcentroid(), level.activeplayers[0]);
			magicbullet(level.var_5d4538da, var_a3ded05d, ai_mechz getcentroid(), level.activeplayers[0]);
			magicbullet(level.var_30611368, var_31d76122, ai_mechz getcentroid(), level.activeplayers[0]);
		}
	#/
}

/*
	Name: function_22cf3e9f
	Namespace: zm_castle_mechz
	Checksum: 0xEE277C67
	Offset: 0x20A0
	Size: 0x5C
	Parameters: 3
	Flags: None
*/
function function_22cf3e9f(str_weapon_name, v_source, ai_mechz)
{
	/#
		magicbullet(level.var_791ba87b, v_source, ai_mechz getcentroid(), level.activeplayers[0]);
	#/
}

