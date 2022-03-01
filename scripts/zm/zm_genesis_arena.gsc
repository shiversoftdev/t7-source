// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\margwa;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_parasite;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_margwa_elemental;
#using scripts\zm\_zm_ai_margwa_no_idgun;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_genesis_spiders;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_light_zombie;
#using scripts\zm\_zm_powerup_genesis_random_weapon;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_shadow_zombie;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_traps;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_ball;
#using scripts\zm\_zm_weap_gravityspikes;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_ai_spawning;
#using scripts\zm\zm_genesis_apothicon_fury;
#using scripts\zm\zm_genesis_shadowman;
#using scripts\zm\zm_genesis_sound;
#using scripts\zm\zm_genesis_spiders;
#using scripts\zm\zm_genesis_util;
#using scripts\zm\zm_genesis_vo;
#using scripts\zm\zm_genesis_wasp;

#using_animtree("zm_genesis");

class class_d90687be 
{
	var var_4ff05dea;
	var var_eeb77e19;
	var var_2da522a2;
	var var_2cf2d836;
	var var_dacf61a8;
	var var_8c5f9971;
	var var_6d226cbc;
	var var_ff517d49;
	var var_95ceb5f7;

	/*
		Name: constructor
		Namespace: namespace_d90687be
		Checksum: 0x99EC1590
		Offset: 0x5730
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: namespace_d90687be
		Checksum: 0x99EC1590
		Offset: 0x5740
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: get_unused_spawn_point
		Namespace: namespace_d90687be
		Checksum: 0x492A759D
		Offset: 0x5588
		Size: 0x1A0
		Parameters: 1
		Flags: Linked
	*/
	function get_unused_spawn_point(var_b852cbf7)
	{
		a_valid_spawn_points = [];
		b_all_points_used = 0;
		while(!a_valid_spawn_points.size)
		{
			foreach(s_spawn_point in var_4ff05dea)
			{
				if(!isdefined(s_spawn_point.spawned_zombie) || b_all_points_used)
				{
					s_spawn_point.spawned_zombie = 0;
				}
				var_ce040708 = !var_b852cbf7 || (isdefined(s_spawn_point.var_4ef230e4) && s_spawn_point.var_4ef230e4);
				if(!s_spawn_point.spawned_zombie && var_ce040708)
				{
					array::add(a_valid_spawn_points, s_spawn_point, 0);
				}
			}
			if(!a_valid_spawn_points.size)
			{
				b_all_points_used = 1;
			}
			wait(0.1);
		}
		s_spawn_point = array::random(a_valid_spawn_points);
		s_spawn_point.spawned_zombie = 1;
		return s_spawn_point;
	}

	/*
		Name: function_877a7365
		Namespace: namespace_d90687be
		Checksum: 0x1F0355E1
		Offset: 0x53A8
		Size: 0x1D8
		Parameters: 0
		Flags: Linked
	*/
	function function_877a7365()
	{
		self endon(#"death");
		while(true)
		{
			var_c7ca004c = [];
			foreach(player in level.activeplayers)
			{
				if(zm_utility::is_player_valid(player) && function_2a75673(player))
				{
					if(!isdefined(var_c7ca004c))
					{
						var_c7ca004c = [];
					}
					else if(!isarray(var_c7ca004c))
					{
						var_c7ca004c = array(var_c7ca004c);
					}
					var_c7ca004c[var_c7ca004c.size] = player;
				}
			}
			e_target_player = array::random(var_c7ca004c);
			while(isalive(e_target_player) && (!(isdefined(e_target_player.beastmode) && e_target_player.beastmode)) && !e_target_player laststand::player_is_in_laststand())
			{
				self setgoal(e_target_player);
				self waittill(#"goal");
			}
			wait(0.1);
		}
	}

	/*
		Name: function_523eee15
		Namespace: namespace_d90687be
		Checksum: 0x33107DF3
		Offset: 0x4F18
		Size: 0x482
		Parameters: 0
		Flags: Linked
	*/
	function function_523eee15()
	{
		var_efcfca6d = [];
		var_166a783a = getaiteamarray("axis");
		foreach(e_ent in var_166a783a)
		{
			if(e_ent.archetype == "parasite")
			{
				if(!isdefined(var_efcfca6d))
				{
					var_efcfca6d = [];
				}
				else if(!isarray(var_efcfca6d))
				{
					var_efcfca6d = array(var_efcfca6d);
				}
				var_efcfca6d[var_efcfca6d.size] = e_ent;
			}
		}
		var_eb96527b = getent("dark_arena_zone_active_trig", "targetname");
		foreach(var_acaa35c2 in var_efcfca6d)
		{
			if(var_acaa35c2 istouching(var_eb96527b))
			{
				if(!isdefined(var_eeb77e19))
				{
					var_eeb77e19 = [];
				}
				else if(!isarray(var_eeb77e19))
				{
					var_eeb77e19 = array(var_eeb77e19);
				}
				var_eeb77e19[var_eeb77e19.size] = var_acaa35c2;
			}
		}
		if(!isdefined(var_eeb77e19))
		{
			return;
		}
		var_2f263630 = var_eeb77e19;
		var_341c99f8 = [];
		foreach(ai_parasite in var_2f263630)
		{
			if(!isdefined(ai_parasite))
			{
				continue;
			}
			if(isdefined(ai_parasite.ignore_nuke) && ai_parasite.ignore_nuke)
			{
				continue;
			}
			if(isdefined(ai_parasite.marked_for_death) && ai_parasite.marked_for_death)
			{
				continue;
			}
			if(isdefined(ai_parasite.nuke_damage_func))
			{
				ai_parasite thread [[ai_parasite.nuke_damage_func]]();
				continue;
			}
			ai_parasite.marked_for_death = 1;
			ai_parasite.nuked = 1;
			var_341c99f8[var_341c99f8.size] = ai_parasite;
		}
		foreach(i, var_ab7516d5 in var_341c99f8)
		{
			if(!isdefined(var_ab7516d5))
			{
				continue;
			}
			if(i < 5)
			{
				var_ab7516d5 thread zombie_death::flame_death_fx();
			}
			var_ab7516d5 dodamage(var_ab7516d5.health, var_ab7516d5.origin);
		}
	}

	/*
		Name: function_43fd7d6e
		Namespace: namespace_d90687be
		Checksum: 0xE663CBDB
		Offset: 0x4D60
		Size: 0x1AA
		Parameters: 0
		Flags: Linked
	*/
	function function_43fd7d6e()
	{
		if(!isdefined(var_2da522a2))
		{
			return;
		}
		a_ai = var_2da522a2;
		var_52ec51cb = [];
		foreach(ai in a_ai)
		{
			if(!isdefined(ai))
			{
				continue;
			}
			if(isdefined(ai.marked_for_death) && ai.marked_for_death)
			{
				continue;
			}
			ai.marked_for_death = 1;
			ai.nuked = 1;
			var_52ec51cb[var_52ec51cb.size] = ai;
		}
		foreach(var_c427066b in var_52ec51cb)
		{
			if(!isdefined(var_c427066b))
			{
				continue;
			}
			var_c427066b kill();
		}
	}

	/*
		Name: function_2d4b8dda
		Namespace: namespace_d90687be
		Checksum: 0x77CEAAC1
		Offset: 0x4A58
		Size: 0x2FA
		Parameters: 0
		Flags: Linked
	*/
	function function_2d4b8dda()
	{
		if(!isdefined(var_2cf2d836))
		{
			return;
		}
		a_ai_zombies = var_2cf2d836;
		var_6b1085eb = [];
		foreach(ai_zombie in a_ai_zombies)
		{
			if(!isdefined(ai_zombie))
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
		}
	}

	/*
		Name: function_b4aac082
		Namespace: namespace_d90687be
		Checksum: 0x1E845759
		Offset: 0x49A0
		Size: 0xAC
		Parameters: 0
		Flags: Linked
	*/
	function function_b4aac082()
	{
		level.zombie_ai_limit = level.var_b89abaf8;
		level lui::screen_flash(0.2, 0.5, 1, 0.8, "white");
		wait(0.2);
		self thread function_2d4b8dda();
		self thread function_43fd7d6e();
		wait(0.5);
		self thread function_523eee15();
	}

	/*
		Name: function_34c1d454
		Namespace: namespace_d90687be
		Checksum: 0x12C670B3
		Offset: 0x48C0
		Size: 0xD2
		Parameters: 1
		Flags: Linked
	*/
	function function_34c1d454(var_87c8152d)
	{
		var_dacf61a8 = [];
		while(level clientfield::get("circle_state") == 3)
		{
			var_dacf61a8 = array::remove_dead(var_dacf61a8, 0);
			if(level.var_435967f3 < level.var_e10b491b)
			{
				ai = zm_genesis_arena::function_2ed620e8(var_87c8152d);
				if(isdefined(ai))
				{
					array::add(var_dacf61a8, ai, 0);
				}
			}
			wait(level.zombie_vars["zombie_spawn_delay"]);
		}
	}

	/*
		Name: function_e4dbca5a
		Namespace: namespace_d90687be
		Checksum: 0x5FF847F4
		Offset: 0x47B0
		Size: 0x106
		Parameters: 1
		Flags: Linked
	*/
	function function_e4dbca5a(var_87c8152d)
	{
		level notify(#"hash_e4dbca5a");
		level endon(#"hash_e4dbca5a");
		level endon(#"arena_challenge_ended");
		var_2da522a2 = [];
		while(true)
		{
			var_2da522a2 = array::remove_dead(var_2da522a2, 0);
			var_4dc249a = level.var_beccbadb < level.var_c4133b63;
			var_4f4cf7d7 = (level.var_beccbadb - level.var_de72c885) < level.var_42ec150d;
			if(var_4dc249a && var_4f4cf7d7)
			{
				ai = zm_genesis_arena::function_5a4ec2e2(var_87c8152d);
				array::add(var_2da522a2, ai, 0);
			}
			wait(5);
		}
	}

	/*
		Name: function_531007c0
		Namespace: namespace_d90687be
		Checksum: 0x9836B97A
		Offset: 0x4658
		Size: 0x14A
		Parameters: 1
		Flags: Linked
	*/
	function function_531007c0(e_player)
	{
		queryresult = positionquery_source_navigation(e_player.origin + (0, 0, randomintrange(40, 100)), 300, 600, 10, 10, "navvolume_small");
		a_points = array::randomize(queryresult.data);
		foreach(point in a_points)
		{
			if(bullettracepassed(point.origin, e_player.origin, 0, e_player))
			{
				return point;
			}
		}
		return a_points[0];
	}

	/*
		Name: function_17f3b496
		Namespace: namespace_d90687be
		Checksum: 0x8292F448
		Offset: 0x4028
		Size: 0x622
		Parameters: 0
		Flags: Linked
	*/
	function function_17f3b496()
	{
		level endon(#"arena_challenge_ended");
		var_eeb77e19 = [];
		while(level clientfield::get("circle_state") == 3)
		{
			var_eeb77e19 = array::remove_dead(var_eeb77e19, 0);
			var_16d0ce4b = 16;
			if(level.var_f98b3213 < 4)
			{
				var_16d0ce4b = 8;
			}
			else if(level.var_f98b3213 < 6)
			{
				var_16d0ce4b = 12;
			}
			e_player = array::random(function_e33fa65f());
			if(!isdefined(e_player))
			{
				continue;
			}
			spawn_point = function_531007c0(e_player);
			if(var_eeb77e19.size < var_16d0ce4b)
			{
				if(isdefined(spawn_point))
				{
					v_spawn_origin = spawn_point.origin;
					v_ground = bullettrace(spawn_point.origin + vectorscale((0, 0, 1), 40), (spawn_point.origin + vectorscale((0, 0, 1), 40)) + (vectorscale((0, 0, -1), 100000)), 0, undefined)["position"];
					if(distancesquared(v_ground, spawn_point.origin) < 1600)
					{
						v_spawn_origin = v_ground + vectorscale((0, 0, 1), 40);
					}
					queryresult = positionquery_source_navigation(v_spawn_origin, 0, 80, 80, 15, "navvolume_small");
					a_points = array::randomize(queryresult.data);
					a_spawn_origins = [];
					n_points_found = 0;
					foreach(point in a_points)
					{
						str_zone = zm_zonemgr::get_zone_from_position(point.origin, 1);
						if(isdefined(str_zone) && (str_zone == "dark_arena_zone" || str_zone == "dark_arena2_zone"))
						{
							if(bullettracepassed(point.origin, spawn_point.origin, 0, e_player))
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
					}
					if(a_spawn_origins.size >= 1)
					{
						n_spawn = 0;
						while(n_spawn < 1)
						{
							for(i = a_spawn_origins.size - 1; i >= 0; i--)
							{
								v_origin = a_spawn_origins[i];
								level.wasp_spawners[0].origin = v_origin;
								ai = zombie_utility::spawn_zombie(level.wasp_spawners[0]);
								if(isdefined(ai))
								{
									array::add(var_eeb77e19, ai, 0);
									ai parasite::set_parasite_enemy(e_player);
									level thread zm_genesis_wasp::wasp_spawn_init(ai, v_origin);
									arrayremoveindex(a_spawn_origins, i);
									ai.ignore_enemy_count = 1;
									ai.var_bdb9d21d = 1;
									ai.no_damage_points = 1;
									ai.deathpoints_already_given = 1;
									if(isdefined(level.zm_wasp_spawn_callback))
									{
										ai thread [[level.zm_wasp_spawn_callback]]();
									}
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
			}
			wait(level.zombie_vars["zombie_spawn_delay"]);
		}
	}

	/*
		Name: function_7ebc257e
		Namespace: namespace_d90687be
		Checksum: 0x3CDA432
		Offset: 0x3EE0
		Size: 0x13E
		Parameters: 0
		Flags: Linked
	*/
	function function_7ebc257e()
	{
		var_8c5f9971 = [];
		var_d12aa484 = struct::get_array("arena_spider_spawner", "targetname");
		while(level clientfield::get("circle_state") == 3)
		{
			var_8c5f9971 = array::remove_dead(var_8c5f9971, 0);
			var_9e20b46f = 12;
			if(var_8c5f9971.size < var_9e20b46f)
			{
				s_spawn_point = array::random(var_d12aa484);
				level.var_718361fb = zm_genesis_spiders::function_3f180afe();
				ai = zm_ai_spiders::function_f4bd92a2(1, s_spawn_point);
				array::add(var_8c5f9971, ai, 0);
			}
			wait(1);
		}
	}

	/*
		Name: function_352c3c15
		Namespace: namespace_d90687be
		Checksum: 0x462B34E8
		Offset: 0x3C90
		Size: 0x244
		Parameters: 0
		Flags: Linked
	*/
	function function_352c3c15()
	{
		if(level.var_42e19a0b == 1)
		{
			var_72214acc = randomintrange(0, 4);
			if(var_72214acc == 0)
			{
				self thread zm_elemental_zombie::function_1b1bb1b();
			}
			else if(var_72214acc == 1)
			{
				self thread zm_elemental_zombie::function_f4defbc2();
			}
		}
		else
		{
			if(level.var_42e19a0b == 2)
			{
				if(randomintrange(0, 4) > 0)
				{
					var_72214acc = randomintrange(0, 4);
					if(var_72214acc == 0)
					{
						self thread zm_elemental_zombie::function_1b1bb1b();
					}
					else
					{
						if(var_72214acc == 1)
						{
							self thread zm_elemental_zombie::function_f4defbc2();
						}
						else
						{
							if(var_72214acc == 2)
							{
								self thread zm_light_zombie::function_a35db70f();
							}
							else if(var_72214acc == 3)
							{
								self thread zm_shadow_zombie::function_1b2b62b();
							}
						}
					}
				}
			}
			else if(level.var_42e19a0b == 3)
			{
				var_72214acc = randomintrange(0, 4);
				if(var_72214acc == 0)
				{
					self thread zm_elemental_zombie::function_1b1bb1b();
				}
				else
				{
					if(var_72214acc == 1)
					{
						self thread zm_elemental_zombie::function_1b1bb1b();
					}
					else
					{
						if(var_72214acc == 2)
						{
							self thread zm_light_zombie::function_a35db70f();
						}
						else if(var_72214acc == 3)
						{
							self thread zm_shadow_zombie::function_1b2b62b();
						}
					}
				}
			}
		}
	}

	/*
		Name: function_422556eb
		Namespace: namespace_d90687be
		Checksum: 0x2ECDC0F
		Offset: 0x39E0
		Size: 0x2A4
		Parameters: 1
		Flags: Linked
	*/
	function function_422556eb(s_spawn_point)
	{
		e_spawner = getent("spawner_zm_genesis_apothicon_zombie", "targetname");
		ai = zombie_utility::spawn_zombie(e_spawner, "arena_zombie", s_spawn_point);
		if(!isdefined(ai))
		{
			/#
				println("");
			#/
			return;
		}
		ai endon(#"death");
		ai._rise_spot = s_spawn_point;
		ai.var_7879ec72 = 1;
		ai thread zm_genesis_arena::function_ffcee12c(s_spawn_point);
		ai thread function_877a7365();
		if(level flag::get("book_runes_success") && !level flag::get("final_boss_started") && !level flag::get("arena_vanilla_zombie_override"))
		{
			var_87c8152d = level clientfield::get("circle_challenge_identity");
			switch(var_87c8152d)
			{
				case 3:
				{
					ai thread zm_elemental_zombie::function_1b1bb1b();
					break;
				}
				case 2:
				{
					ai thread zm_genesis_util::function_c8040935(2);
					break;
				}
				case 0:
				{
					ai thread zm_light_zombie::function_a35db70f();
					break;
				}
				case 1:
				{
					ai thread zm_shadow_zombie::function_1b2b62b();
					break;
				}
				case 4:
				{
					ai thread function_352c3c15();
					break;
				}
			}
		}
		array::add(var_2cf2d836, ai, 0);
		ai waittill(#"completed_emerging_into_playable_area");
		ai.no_powerups = 1;
		ai.no_damage_points = 1;
		ai.deathpoints_already_given = 1;
	}

	/*
		Name: function_a1c7821d
		Namespace: namespace_d90687be
		Checksum: 0xBF90C50F
		Offset: 0x37F8
		Size: 0x1E0
		Parameters: 2
		Flags: Linked
	*/
	function function_a1c7821d(var_b852cbf7, var_3f571692 = 12)
	{
		level notify(#"hash_6d73b616");
		level endon(#"hash_6d73b616");
		level endon(#"arena_challenge_ended");
		level endon(#"final_boss_defeated");
		level.var_b89abaf8 = level.zombie_ai_limit;
		level.zombie_ai_limit = 16;
		var_2cf2d836 = [];
		while(true)
		{
			if(!level flag::get("final_boss_started"))
			{
				wait(level.zombie_vars["zombie_spawn_delay"]);
			}
			else
			{
				wait(0.5);
			}
			if(isdefined(level.var_8e402c12))
			{
				var_3f571692 = level.var_8e402c12;
				level.var_8e402c12 = undefined;
			}
			var_2cf2d836 = array::remove_dead(var_2cf2d836, 0);
			level flag::clear("spawn_zombies");
			while(getfreeactorcount() < 1)
			{
				util::wait_network_frame();
			}
			level flag::set("spawn_zombies");
			if(var_2cf2d836.size >= var_3f571692)
			{
				continue;
			}
			s_spawn_point = get_unused_spawn_point(var_b852cbf7);
			if(isdefined(s_spawn_point))
			{
				function_422556eb(s_spawn_point);
			}
		}
	}

	/*
		Name: function_15c5e1
		Namespace: namespace_d90687be
		Checksum: 0xBBD79693
		Offset: 0x3768
		Size: 0x86
		Parameters: 0
		Flags: Linked
	*/
	function function_15c5e1()
	{
		foreach(s_spawn_point in var_4ff05dea)
		{
			s_spawn_point.var_4ef230e4 = 0;
		}
	}

	/*
		Name: function_cba8ad32
		Namespace: namespace_d90687be
		Checksum: 0x1E02883D
		Offset: 0x3628
		Size: 0x134
		Parameters: 0
		Flags: Linked
	*/
	function function_cba8ad32()
	{
		level notify(#"hash_cba8ad32");
		level endon(#"hash_cba8ad32");
		level clientfield::set("arena_state", 4);
		level clientfield::set("circle_state", 5);
		wait(5);
		while(true)
		{
			players = level.activeplayers;
			foreach(player in players)
			{
				if(function_2a75673(player))
				{
					player dodamage(15, player.origin);
				}
			}
			wait(1);
		}
	}

	/*
		Name: function_f115a4c8
		Namespace: namespace_d90687be
		Checksum: 0x43FA0F0B
		Offset: 0x3588
		Size: 0x92
		Parameters: 0
		Flags: Linked
	*/
	function function_f115a4c8()
	{
		level notify(#"hash_f115a4c8");
		level endon(#"hash_f115a4c8");
		level endon(#"hash_78e9c51c");
		wait(30);
		for(i = 0; i < 5; i++)
		{
			/#
				iprintlnbold("" + (5 - i));
			#/
			wait(1);
		}
		level notify(#"hash_b7da93ea");
	}

	/*
		Name: function_32374471
		Namespace: namespace_d90687be
		Checksum: 0x4FFD5793
		Offset: 0x3540
		Size: 0x3C
		Parameters: 0
		Flags: Linked
	*/
	function function_32374471()
	{
		level endon(#"hash_b7da93ea");
		while(true)
		{
			level thread function_f115a4c8();
			level waittill(#"hash_78e9c51c");
		}
	}

	/*
		Name: function_15715797
		Namespace: namespace_d90687be
		Checksum: 0xBD11F13C
		Offset: 0x3300
		Size: 0x236
		Parameters: 0
		Flags: Linked
	*/
	function function_15715797()
	{
		level endon(#"hash_fa713eaf");
		level flag::wait_till("test_activate_arena");
		while(true)
		{
			level flag::wait_till("test_activate_arena");
			players = level.activeplayers;
			foreach(player in players)
			{
				level notify(#"hash_1c04ac7f", player);
			}
			level clientfield::set("arena_state", 1);
			level clientfield::set("circle_state", 1);
			wait(0.1);
			level clientfield::set("circle_state", 2);
			level flag::wait_till("arena_timer");
			level thread function_32374471();
			level waittill(#"hash_b7da93ea");
			level thread function_cba8ad32();
			level flag::wait_till_clear("test_activate_arena");
			flag::clear("test_activate_arena");
			level clientfield::set("arena_state", 0);
			level clientfield::set("circle_state", 0);
			level notify(#"hash_cba8ad32");
		}
	}

	/*
		Name: function_4d8d73c5
		Namespace: namespace_d90687be
		Checksum: 0xB3595042
		Offset: 0x3228
		Size: 0xCC
		Parameters: 1
		Flags: Linked
	*/
	function function_4d8d73c5(player)
	{
		str_zone = zm_zonemgr::get_zone_from_position(player.origin + vectorscale((0, 0, 1), 32), 1);
		if(isdefined(str_zone))
		{
			if(str_zone == "zm_theater_balcony_zone" || str_zone == "zm_theater_zone" || str_zone == "zm_theater_projection_zone" || str_zone == "zm_theater_foyer_zone" || str_zone == "zm_theater_hallway_zone" || str_zone == "zm_theater_jump_zone" || str_zone == "zm_theater_stage_zone")
			{
				return true;
			}
		}
		return false;
	}

	/*
		Name: function_2a75673
		Namespace: namespace_d90687be
		Checksum: 0x440E9F06
		Offset: 0x31B0
		Size: 0x6C
		Parameters: 1
		Flags: Linked
	*/
	function function_2a75673(player)
	{
		str_zone = zm_zonemgr::get_zone_from_position(player.origin, 1);
		if(isdefined(str_zone))
		{
			if(str_zone == "dark_arena_zone" || str_zone == "dark_arena2_zone")
			{
				return true;
			}
		}
		return false;
	}

	/*
		Name: function_e33fa65f
		Namespace: namespace_d90687be
		Checksum: 0x80814B9
		Offset: 0x30D0
		Size: 0xD6
		Parameters: 0
		Flags: Linked
	*/
	function function_e33fa65f()
	{
		var_a5d8479 = [];
		foreach(e_player in level.activeplayers)
		{
			if(zm_utility::is_player_valid(e_player) && function_2a75673(e_player))
			{
				array::add(var_a5d8479, e_player);
			}
		}
		return var_a5d8479;
	}

	/*
		Name: function_87ecf9f6
		Namespace: namespace_d90687be
		Checksum: 0xFEF04A0D
		Offset: 0x2FE8
		Size: 0xE0
		Parameters: 0
		Flags: Linked
	*/
	function function_87ecf9f6()
	{
		var_33f28c72 = 0;
		var_caac2b25 = function_e33fa65f();
		foreach(player in var_caac2b25)
		{
			if(zm_utility::is_player_valid(player) && function_2a75673(player))
			{
				var_33f28c72 = var_33f28c72 + 1;
			}
		}
		return var_33f28c72;
	}

	/*
		Name: function_b074bb56
		Namespace: namespace_d90687be
		Checksum: 0x64004E20
		Offset: 0x2F98
		Size: 0x44
		Parameters: 0
		Flags: Linked
	*/
	function function_b074bb56()
	{
		var_6d226cbc = var_6d226cbc - 1;
		if(var_6d226cbc == 0)
		{
			level flag::clear("test_activate_arena");
		}
	}

	/*
		Name: function_ea39787e
		Namespace: namespace_d90687be
		Checksum: 0xE27FAA76
		Offset: 0x2F20
		Size: 0x6C
		Parameters: 1
		Flags: Linked
	*/
	function function_ea39787e(player)
	{
		array::add(var_ff517d49, player);
		var_6d226cbc = var_6d226cbc + 1;
		level notify(#"hash_78e9c51c", player);
		level flag::set("arena_occupied_by_player");
	}

	/*
		Name: init
		Namespace: namespace_d90687be
		Checksum: 0x5566FD76
		Offset: 0x2E80
		Size: 0x94
		Parameters: 0
		Flags: Linked
	*/
	function init()
	{
		var_ff517d49 = [];
		var_6d226cbc = 0;
		var_95ceb5f7 = getent("dark_arena_volume", "targetname");
		var_4ff05dea = struct::get_array("arena_scripted_zombie_spawn", "targetname");
		zm_genesis_arena::function_c1402204();
		level thread function_15715797();
	}

}

#namespace zm_genesis_arena;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_arena
	Checksum: 0xBC2B76AC
	Offset: 0x1E78
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_arena", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_arena
	Checksum: 0xDEE9A09A
	Offset: 0x1EC0
	Size: 0xAC4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["zapper"] = "dlc0/factory/fx_elec_trap_factory";
	level._effect["light_challenge_safezone_end"] = "dlc4/genesis/fx_arena_safe_area_end";
	level thread function_6f772f30();
	level thread zm_genesis_util::monitor_wallrun_trigger("dark_arena_zone_active_trig", "arena_wallrun_active");
	level thread zm_genesis_util::function_88777efd("dark_arena_zone_active_trig", "arena_lowgrav_active");
	clientfield::register("world", "arena_state", 15000, getminbitcountfornum(5), "int");
	clientfield::register("world", "circle_state", 15000, getminbitcountfornum(6), "int");
	clientfield::register("world", "circle_challenge_identity", 15000, getminbitcountfornum(6), "int");
	clientfield::register("world", "summoning_key_charge_state", 15000, getminbitcountfornum(4), "int");
	clientfield::register("toplayer", "fire_postfx_set", 15000, 1, "int");
	clientfield::register("scriptmover", "fire_column", 15000, 1, "int");
	clientfield::register("toplayer", "darkness_postfx_set", 15000, 1, "int");
	clientfield::register("toplayer", "electricity_postfx_set", 15000, 1, "int");
	clientfield::register("world", "light_challenge_floor", 15000, 1, "int");
	clientfield::register("actor", "arena_margwa_init", 15000, 1, "int");
	clientfield::register("scriptmover", "arena_tornado", 15000, 1, "int");
	clientfield::register("scriptmover", "arena_shadow_pillar", 15000, 1, "int");
	clientfield::register("world", "arena_timeout_warning", 15000, 1, "int");
	clientfield::register("scriptmover", "elec_wall_tell", 15000, 1, "counter");
	clientfield::register("toplayer", "powerup_visual_marker", 15000, 2, "int");
	level._effect["powerup_column"] = "dlc4/genesis/fx_darkarena_powerup_pillar";
	clientfield::register("world", "summoning_key_pickup", 15000, getminbitcountfornum(3), "int");
	clientfield::register("world", "basin_state_0", 15000, getminbitcountfornum(5), "int");
	clientfield::register("world", "basin_state_1", 15000, getminbitcountfornum(5), "int");
	clientfield::register("world", "basin_state_2", 15000, getminbitcountfornum(5), "int");
	clientfield::register("world", "basin_state_3", 15000, getminbitcountfornum(5), "int");
	clientfield::register("scriptmover", "runeprison_rock_fx", 5000, 1, "int");
	clientfield::register("scriptmover", "runeprison_explode_fx", 5000, 1, "int");
	level.var_42e19a0b = 1;
	clientfield::register("scriptmover", "summoning_circle_fx", 15000, 1, "int");
	level.var_f98b3213 = 0;
	level.var_c4133b63 = 1;
	level.var_42ec150d = 4;
	level.var_beccbadb = 0;
	level.var_90280eb8 = 1;
	level.var_435967f3 = 0;
	level.var_fe2fb4b9 = -1;
	level.var_43e34f20 = [];
	level.var_43e34f20[0] = &function_48ffe1e9;
	level.var_43e34f20[1] = &function_2bacd397;
	level.var_43e34f20[2] = &function_f1e6c2a7;
	level.var_43e34f20[3] = &function_f1aed0c6;
	level.var_5afa678d = [];
	level.var_5afa678d[0] = &function_876e8a3c;
	level.var_5afa678d[1] = &function_d2a9fa8c;
	level.var_5afa678d[2] = &function_56b687ac;
	level.var_5afa678d[3] = &function_c78d187b;
	level flag::init("test_activate_arena");
	level flag::init("devgui_end_challenge");
	level flag::init("boss_rush_phase_1");
	level flag::init("boss_rush_phase_2");
	level flag::init("arena_timer", 1);
	level flag::init("arena_zombie_priority");
	level flag::init("arena_occupied_by_player");
	level flag::init("arena_vanilla_zombie_override");
	level flag::init("custom_challenge");
	level flag::init("custom_challenge_wallrun");
	level flag::init("custom_challenge_lowgrav");
	level flag::init("custom_challenge_smoke");
	level flag::init("custom_challenge_bridge");
	level flag::init("custom_challenge_fire");
	level flag::init("custom_challenge_elec");
	level flag::init("custom_challenge_cursetraps");
	level flag::init("final_boss_started");
	level flag::init("final_boss_summoning_key_in_play");
	level flag::init("final_boss_vulnerable");
	level flag::init("final_boss_at_deaths_door");
	level flag::init("final_boss_defeated");
	level flag::init("special_win");
	for(i = 0; i < 5; i++)
	{
		str_flag_name = "arena_challenge_complete_" + i;
		level flag::init(str_flag_name);
	}
	for(i = 4; i < 6; i++)
	{
		var_5a2492d5 = function_6ab2d662(i);
		str_flag_name = var_5a2492d5 + "_rq_done";
		level flag::init(str_flag_name);
	}
	level thread function_dd27cfe0();
	/#
		level thread function_cc5cac5f();
		level thread function_3745c6c8();
	#/
}

/*
	Name: __main__
	Namespace: zm_genesis_arena
	Checksum: 0xABBB8C4C
	Offset: 0x2990
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	setdvar("doublejump_enabled", 1);
	setdvar("playerEnergy_enabled", 1);
	setdvar("wallrun_enabled", 1);
	setdvar("bg_lowGravity", 300);
	setdvar("wallRun_maxTimeMs_zm", 10000);
	setdvar("playerEnergy_maxReserve_zm", 200);
	setdvar("wallRun_peakTest_zm", 0);
	level thread function_3dbace38();
}

/*
	Name: function_dd27cfe0
	Namespace: zm_genesis_arena
	Checksum: 0x11F199CF
	Offset: 0x2A90
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function function_dd27cfe0()
{
	var_7fdcd3a8 = getent("arena_wallrun_center_a", "targetname");
	var_7fdcd3a8.v_start = var_7fdcd3a8.origin;
	var_7fdcd3a8 moveto(var_7fdcd3a8.v_start - vectorscale((0, 0, 1), 1000), 0.01);
	var_7fdcd3a8 ghost();
	var_c0132a00 = getent("rift_entrance_rune_portal", "targetname");
	var_c0132a00 ghost();
	level waittill(#"start_zombie_round_logic");
	level.var_d90687be = new class_d90687be();
	[[ level.var_d90687be ]]->init();
	level waittill(#"book_placed");
	var_c0132a00 show();
	var_c0132a00 hidepart("tag_electricity_on");
	var_c0132a00 hidepart("tag_fire_on");
	var_c0132a00 hidepart("tag_light_on");
	var_c0132a00 hidepart("tag_shadow_on");
	var_c0132a00 playloopsound("zmb_main_runey_circle_lp", 2);
	var_c0132a00 clientfield::set("summoning_circle_fx", 1);
	exploder::exploder("fxexp_370");
	exploder::exploder("lgtexp_projector_rune");
}

/*
	Name: function_869c4353
	Namespace: zm_genesis_arena
	Checksum: 0xAFDA147E
	Offset: 0x2CC0
	Size: 0x94
	Parameters: 1
	Flags: None
*/
function function_869c4353(str_name)
{
	e_platform = getent(str_name, "targetname");
	v_origin = e_platform.origin;
	v_offset = vectorscale((0, 0, 1), 192);
	e_platform moveto(v_origin - v_offset, 1);
}

/*
	Name: function_6f772f30
	Namespace: zm_genesis_arena
	Checksum: 0xBA93FE78
	Offset: 0x2D60
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function function_6f772f30()
{
	level endon(#"end_game");
	level notify(#"hash_a3369c1f");
	level endon(#"hash_a3369c1f");
	while(true)
	{
		level waittill(#"host_migration_end");
		setdvar("doublejump_enabled", 1);
		setdvar("playerEnergy_enabled", 1);
		setdvar("wallrun_enabled", 1);
		setdvar("bg_lowGravity", 300);
		setdvar("wallRun_maxTimeMs_zm", 10000);
		setdvar("playerEnergy_maxReserve_zm", 200);
		setdvar("wallRun_peakTest_zm", 0);
	}
}

/*
	Name: function_ffcee12c
	Namespace: zm_genesis_arena
	Checksum: 0x91DAF2DC
	Offset: 0x5CC0
	Size: 0x1D4
	Parameters: 1
	Flags: Linked
*/
function function_ffcee12c(s_spawn_point)
{
	self endon(#"death");
	self.script_string = "find_flesh";
	self setphysparams(15, 0, 72);
	self.ignore_enemy_count = 1;
	self.deathpoints_already_given = 1;
	self.exclude_distance_cleanup_adding_to_total = 1;
	self.exclude_cleanup_adding_to_total = 1;
	self.no_powerups = 1;
	self zombie_utility::zombie_eye_glow();
	util::wait_network_frame();
	if(level flag::get("book_runes_success"))
	{
		if(self.zombie_move_speed === "walk")
		{
			self zombie_utility::set_zombie_run_cycle("run");
		}
	}
	else
	{
		if(!isdefined(level.var_c8508622))
		{
			function_ac6877f7();
		}
		level.var_c8508622--;
	}
	find_flesh_struct_string = "find_flesh";
	self notify(#"zombie_custom_think_done", find_flesh_struct_string);
	self.nocrawler = 1;
	self.no_powerups = 1;
	self waittill(#"completed_emerging_into_playable_area");
	self.no_powerups = 1;
	if(!level flag::get("book_runes_success"))
	{
		if(level.var_c8508622 < 0)
		{
			self thread function_2a690b3b();
			function_ac6877f7();
		}
	}
}

/*
	Name: function_2a690b3b
	Namespace: zm_genesis_arena
	Checksum: 0xB6859F4D
	Offset: 0x5EA0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_2a690b3b()
{
	self waittill(#"death");
	zm_powerups::specific_powerup_drop("full_ammo", self.origin);
}

/*
	Name: function_ac6877f7
	Namespace: zm_genesis_arena
	Checksum: 0x44CF0FEE
	Offset: 0x5EE0
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_ac6877f7()
{
	level.var_c8508622 = randomintrange(25, 45);
	level.var_c8508622 = level.var_c8508622 * level.activeplayers.size;
}

/*
	Name: function_6ab2d662
	Namespace: zm_genesis_arena
	Checksum: 0xECD6F4DC
	Offset: 0x5F28
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function function_6ab2d662(var_87c8152d)
{
	switch(var_87c8152d)
	{
		case 0:
		{
			return "light";
		}
		case 1:
		{
			return "shadow";
		}
		case 2:
		{
			return "fire";
		}
		case 3:
		{
			return "electricity";
		}
		case 5:
		{
			return "blood";
		}
		case 4:
		{
			return "weapon";
		}
	}
}

/*
	Name: function_e05cf870
	Namespace: zm_genesis_arena
	Checksum: 0xBB36DC1A
	Offset: 0x5FB0
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function function_e05cf870()
{
	var_53c2d5b3 = level clientfield::get("arena_state");
	if(var_53c2d5b3 != 1)
	{
		return false;
	}
	var_ba27cc22 = level clientfield::get("circle_state");
	if(var_ba27cc22 != 2)
	{
		return false;
	}
	return true;
}

/*
	Name: function_2cca8355
	Namespace: zm_genesis_arena
	Checksum: 0x103D4ED7
	Offset: 0x6038
	Size: 0x138
	Parameters: 0
	Flags: None
*/
function function_2cca8355()
{
	self endon(#"death");
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
		if(function_e05cf870() == 0)
		{
			continue;
		}
		if(level flag::get("arena_challenge_complete_" + self.stub.var_87c8152d))
		{
			continue;
		}
		if(level flag::get(self.stub.str_flag_name) == 0)
		{
			continue;
		}
		level.var_a7414746 = player;
		function_6a03c1d4(self.stub.var_87c8152d, level.var_f98b3213);
	}
}

/*
	Name: function_6a03c1d4
	Namespace: zm_genesis_arena
	Checksum: 0x4D47E52A
	Offset: 0x6178
	Size: 0x31C
	Parameters: 2
	Flags: Linked
*/
function function_6a03c1d4(var_87c8152d, var_eadfbdd4)
{
	if(level.var_fe2fb4b9 != -1)
	{
		level notify(#"arena_challenge_ended");
		func_cleanup = level.var_5afa678d[level.var_fe2fb4b9];
		level [[func_cleanup]]();
	}
	level.var_fe2fb4b9 = var_87c8152d;
	level notify(#"hash_f115a4c8");
	level clientfield::set("circle_challenge_identity", var_87c8152d);
	level clientfield::set("arena_state", 2);
	level clientfield::set("circle_state", 3);
	level.var_42ec150d = function_607249fd();
	level.var_beccbadb = 0;
	level.var_de72c885 = 0;
	level.var_435967f3 = 0;
	level.var_278e37cd = 0;
	if(level flag::get("custom_challenge"))
	{
		/#
			iprintlnbold("");
			iprintlnbold(((("" + level flag::get("")) + "") + level flag::get("") + "") + level flag::get(""));
			iprintlnbold((((("" + level flag::get("")) + "") + level flag::get("") + "") + level flag::get("") + "") + level flag::get(""));
		#/
		function_3cc5d8a6(var_eadfbdd4);
	}
	else
	{
		/#
			iprintlnbold("" + function_6ab2d662(var_87c8152d));
		#/
		var_cecde52d = level.var_43e34f20[var_87c8152d];
		level thread [[var_cecde52d]](var_87c8152d, var_eadfbdd4);
	}
}

/*
	Name: function_3dbace38
	Namespace: zm_genesis_arena
	Checksum: 0x56240967
	Offset: 0x64A0
	Size: 0x11E
	Parameters: 0
	Flags: Linked
*/
function function_3dbace38()
{
	for(i = 0; i < 4; i++)
	{
		e_pillar = getent("pillar_element_" + i, "targetname");
		for(j = 0; j < 4; j++)
		{
			str_name = function_6ab2d662(j);
			e_pillar hidepart("tag_" + str_name);
		}
		e_pillar showpart("tag_default");
	}
	if(isdefined(level.var_48b697ad))
	{
		exploder::stop_exploder(level.var_48b697ad);
		level.var_48b697ad = undefined;
	}
}

/*
	Name: function_b6ddba23
	Namespace: zm_genesis_arena
	Checksum: 0xBDC318E2
	Offset: 0x65C8
	Size: 0x20C
	Parameters: 1
	Flags: Linked
*/
function function_b6ddba23(n_element_index)
{
	for(i = 0; i < 4; i++)
	{
		e_pillar = getent("pillar_element_" + i, "targetname");
		e_pillar hidepart("tag_default");
		str_name = function_6ab2d662(n_element_index);
		e_pillar showpart("tag_" + str_name);
	}
	switch(n_element_index)
	{
		case 0:
		{
			str_exploder = "fxexp_081";
			playsoundatposition("zmb_bossrush_element_light", (0, 0, 0));
			break;
		}
		case 1:
		{
			str_exploder = "fxexp_084";
			playsoundatposition("zmb_bossrush_element_shadow", (0, 0, 0));
			break;
		}
		case 3:
		{
			str_exploder = "fxexp_087";
			playsoundatposition("zmb_bossrush_element_electricity", (0, 0, 0));
			break;
		}
		case 2:
		{
			playsoundatposition("zmb_bossrush_element_fire", (0, 0, 0));
			break;
		}
	}
	if(isdefined(level.var_48b697ad))
	{
		exploder::stop_exploder(level.var_48b697ad);
	}
	if(isdefined(str_exploder))
	{
		level.var_48b697ad = str_exploder;
		exploder::exploder(level.var_48b697ad);
	}
}

/*
	Name: function_3cc5d8a6
	Namespace: zm_genesis_arena
	Checksum: 0x36AFCE79
	Offset: 0x67E0
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function function_3cc5d8a6(var_eadfbdd4 = 0)
{
	if(level flag::get("custom_challenge_wallrun"))
	{
		level flag::set("arena_wallrun_active");
	}
	if(level flag::get("custom_challenge_lowgrav"))
	{
		level flag::set("arena_lowgrav_active");
	}
	if(level flag::get("custom_challenge_smoke"))
	{
		function_c5938cab(1);
	}
	function_44d21c21(level flag::get("custom_challenge_bridge"));
}

/*
	Name: function_32197961
	Namespace: zm_genesis_arena
	Checksum: 0xC7420C74
	Offset: 0x68F0
	Size: 0xD4
	Parameters: 0
	Flags: None
*/
function function_32197961()
{
	if(level flag::get("custom_challenge_wallrun"))
	{
		level flag::clear("arena_wallrun_active");
	}
	if(level flag::get("custom_challenge_lowgrav"))
	{
		level flag::clear("arena_lowgrav_active");
	}
	if(level flag::get("custom_challenge_smoke"))
	{
		function_c5938cab(0);
	}
	function_44d21c21(0);
}

/*
	Name: function_607249fd
	Namespace: zm_genesis_arena
	Checksum: 0x31FD85AB
	Offset: 0x69D0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_607249fd()
{
	var_93107413 = 0;
	players = level.activeplayers;
	foreach(player in players)
	{
		if([[ level.var_d90687be ]]->function_2a75673(player))
		{
			var_93107413 = var_93107413 + 1;
		}
	}
	return var_93107413;
}

/*
	Name: function_48ffe1e9
	Namespace: zm_genesis_arena
	Checksum: 0xBC7FB652
	Offset: 0x6AA0
	Size: 0x38C
	Parameters: 4
	Flags: Linked
*/
function function_48ffe1e9(var_87c8152d, var_eadfbdd4 = 0, var_e78a4f30 = 0, var_47a4362c = 0)
{
	level thread function_b6ddba23(var_87c8152d);
	if(var_e78a4f30 == 0)
	{
		level.var_beccbadb = 0;
		level.var_de72c885 = 0;
		level.var_c4133b63 = 3;
	}
	if(var_47a4362c == 1)
	{
		level.var_beccbadb = 0;
		level.var_de72c885 = 0;
		level.var_c4133b63 = 2;
	}
	players = level.activeplayers;
	foreach(player in players)
	{
		if([[ level.var_d90687be ]]->function_2a75673(player))
		{
			player thread function_d41481d2();
		}
	}
	exploder::exploder("lgt_darkarena_nuetral");
	exploder::exploder("lgt_darkarena_light_quest");
	for(x = 1; x < 4; x++)
	{
		for(y = 0; y < 5; y++)
		{
			var_495730fe = function_7d8f4dd0(x, y);
			var_495730fe.var_9391fde5 = 0;
			var_495730fe.n_x = x;
			var_495730fe.n_y = y;
		}
	}
	level clientfield::set("light_challenge_floor", 1);
	level thread function_df89e25c();
	players = level.activeplayers;
	foreach(player in players)
	{
		if([[ level.var_d90687be ]]->function_2a75673(player))
		{
			player thread function_e883aed0();
		}
	}
	if(var_e78a4f30 == 0)
	{
		wait(3);
		thread [[ level.var_d90687be ]]->function_a1c7821d(0);
		thread [[ level.var_d90687be ]]->function_e4dbca5a(var_87c8152d);
	}
}

/*
	Name: function_876e8a3c
	Namespace: zm_genesis_arena
	Checksum: 0xA4563DED
	Offset: 0x6E38
	Size: 0x184
	Parameters: 2
	Flags: Linked
*/
function function_876e8a3c(var_e78a4f30 = 0, var_47a4362c = 0)
{
	level.var_fe2fb4b9 = -1;
	level thread function_3dbace38();
	level notify(#"arena_challenge_ended");
	level notify(#"light_challenge_ended");
	exploder::stop_exploder("lgt_darkarena_nuetral");
	exploder::stop_exploder("lgt_darkarena_light_quest");
	for(x = 1; x < 4; x++)
	{
		for(y = 0; y < 5; y++)
		{
			exploder::stop_exploder(((("lgt_darkarena_light_safezone_" + x) + "_") + y) + "_safe");
			exploder::stop_exploder(((("lgt_darkarena_light_safezone_" + x) + "_") + y) + "_danger");
		}
	}
	level clientfield::set("light_challenge_floor", 0);
}

/*
	Name: function_d41481d2
	Namespace: zm_genesis_arena
	Checksum: 0x90DDD55E
	Offset: 0x6FC8
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function function_d41481d2()
{
	self allowdoublejump(1);
	self setperk("specialty_lowgravity");
	self.var_7dd18a0 = 1;
	level util::waittill_any("arena_challenge_ended", "light_challenge_ended");
	self allowdoublejump(0);
	self unsetperk("specialty_lowgravity");
	self.var_7dd18a0 = 0;
}

/*
	Name: function_e883aed0
	Namespace: zm_genesis_arena
	Checksum: 0x11E3456
	Offset: 0x7080
	Size: 0x2E8
	Parameters: 0
	Flags: Linked
*/
function function_e883aed0()
{
	level endon(#"arena_challenge_ended");
	level endon(#"light_challenge_ended");
	if(!isdefined(self.var_c08f97f))
	{
		self.var_c08f97f = 0;
	}
	if(!isdefined(self.var_fe2d0be6))
	{
		self.var_fe2d0be6 = 0;
	}
	var_ba0ff41 = [];
	for(x = 1; x < 4; x++)
	{
		for(y = 0; y < 5; y++)
		{
			var_495730fe = function_7d8f4dd0(x, y);
			if(!isdefined(var_ba0ff41))
			{
				var_ba0ff41 = [];
			}
			else if(!isarray(var_ba0ff41))
			{
				var_ba0ff41 = array(var_ba0ff41);
			}
			var_ba0ff41[var_ba0ff41.size] = var_495730fe;
		}
	}
	while(true)
	{
		if(self laststand::player_is_in_laststand())
		{
			self.var_fe2d0be6 = 0;
			wait(0.2);
			continue;
		}
		if(!self isonground())
		{
			wait(0.2);
			continue;
		}
		var_be0f0621 = arraygetclosest(self.origin, var_ba0ff41);
		n_dist = distance2dsquared(self.origin, var_be0f0621.origin);
		self.var_c08f97f = n_dist > 16384 || (!(isdefined(var_be0f0621.var_9391fde5) && var_be0f0621.var_9391fde5));
		if(self.var_c08f97f)
		{
			self.var_fe2d0be6 = self.var_fe2d0be6 + 1;
			if(self.var_fe2d0be6 > 3)
			{
				var_ba5b7fb9 = (self.maxhealth * 0.002) * (self.var_fe2d0be6 - 3);
				self dodamage(var_ba5b7fb9, self.origin, undefined, undefined, undefined, "MOD_BURNED", 0, getweapon("incendiary_fire"));
			}
		}
		else
		{
			self.var_fe2d0be6 = 0;
			var_be0f0621 notify(#"hash_ded217c8");
		}
		wait(0.2);
	}
}

/*
	Name: function_df89e25c
	Namespace: zm_genesis_arena
	Checksum: 0x5DEB1D4E
	Offset: 0x7370
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_df89e25c()
{
	level thread function_8a121ebd(1, 2);
	level thread function_8a121ebd(2, 2);
	level thread function_8a121ebd(3, 2);
	level thread function_8a121ebd(2, 4);
	level thread function_8a121ebd(2, 0);
}

/*
	Name: function_73ff31ff
	Namespace: zm_genesis_arena
	Checksum: 0xA1CADA0
	Offset: 0x7418
	Size: 0x122
	Parameters: 0
	Flags: Linked
*/
function function_73ff31ff()
{
	var_b687ed6e = [];
	for(x = 1; x < 4; x++)
	{
		for(y = 0; y < 5; y++)
		{
			var_495730fe = function_7d8f4dd0(x, y);
			if(!(isdefined(var_495730fe.var_9391fde5) && var_495730fe.var_9391fde5))
			{
				if(!isdefined(var_b687ed6e))
				{
					var_b687ed6e = [];
				}
				else if(!isarray(var_b687ed6e))
				{
					var_b687ed6e = array(var_b687ed6e);
				}
				var_b687ed6e[var_b687ed6e.size] = var_495730fe;
			}
		}
	}
	return array::random(var_b687ed6e);
}

/*
	Name: function_7d8f4dd0
	Namespace: zm_genesis_arena
	Checksum: 0xB9989966
	Offset: 0x7548
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function function_7d8f4dd0(n_x, n_y)
{
	var_9814a6d8 = (("arena_light_safepoint_" + n_x) + "_") + n_y;
	var_495730fe = struct::get(var_9814a6d8, "targetname");
	return var_495730fe;
}

/*
	Name: function_9f6208b0
	Namespace: zm_genesis_arena
	Checksum: 0x423894B7
	Offset: 0x75C0
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_9f6208b0()
{
	level endon(#"arena_challenge_ended");
	level endon(#"light_challenge_ended");
	self.var_9391fde5 = 1;
	exploder::exploder(((("lgt_darkarena_light_safezone_" + self.n_x) + "_") + self.n_y) + "_safe");
	self waittill(#"hash_ded217c8");
	wait(7);
	exploder::stop_exploder(((("lgt_darkarena_light_safezone_" + self.n_x) + "_") + self.n_y) + "_safe");
	exploder::exploder(((("lgt_darkarena_light_safezone_" + self.n_x) + "_") + self.n_y) + "_danger");
	var_996dc28e = function_73ff31ff();
	var_996dc28e thread function_9f6208b0();
	wait(5);
	exploder::stop_exploder(((("lgt_darkarena_light_safezone_" + self.n_x) + "_") + self.n_y) + "_danger");
	playfx(level._effect["light_challenge_safezone_end"], self.origin);
	wait(1);
	self.var_9391fde5 = 0;
}

/*
	Name: function_14dd4384
	Namespace: zm_genesis_arena
	Checksum: 0x67C763C3
	Offset: 0x7770
	Size: 0x80
	Parameters: 2
	Flags: None
*/
function function_14dd4384(v_origin, fxid)
{
	var_89576631 = spawn("script_model", v_origin);
	var_89576631 setmodel("tag_origin");
	playfxontag(fxid, var_89576631, "tag_origin");
	return var_89576631;
}

/*
	Name: function_8a121ebd
	Namespace: zm_genesis_arena
	Checksum: 0x2EB7FDE0
	Offset: 0x77F8
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function function_8a121ebd(n_x, n_y)
{
	var_495730fe = function_7d8f4dd0(n_x, n_y);
	var_495730fe thread function_9f6208b0();
}

/*
	Name: function_2bacd397
	Namespace: zm_genesis_arena
	Checksum: 0xF99E2F3F
	Offset: 0x7850
	Size: 0x208
	Parameters: 4
	Flags: Linked
*/
function function_2bacd397(var_87c8152d, var_eadfbdd4 = 0, var_e78a4f30 = 0, var_47a4362c = 0)
{
	level thread function_b6ddba23(var_87c8152d);
	if(var_e78a4f30 == 0)
	{
		level.var_beccbadb = 0;
		level.var_de72c885 = 0;
		level.var_c4133b63 = 3;
	}
	if(var_47a4362c == 1)
	{
		level.var_beccbadb = 0;
		level.var_de72c885 = 0;
		level.var_c4133b63 = 2;
	}
	exploder::exploder("lgt_darkarena_nuetral");
	exploder::exploder("lgt_darkarena_shadowquest");
	level thread function_80340a8d(0, 16);
	level thread function_80340a8d(4, 16);
	level thread function_80340a8d(8, 16);
	level thread function_80340a8d(12, 16);
	for(i = 0; i < 4; i++)
	{
		level thread function_27c3331e(i);
	}
	if(var_e78a4f30 == 0)
	{
		thread [[ level.var_d90687be ]]->function_a1c7821d(0);
		thread [[ level.var_d90687be ]]->function_e4dbca5a(var_87c8152d);
	}
}

/*
	Name: function_80340a8d
	Namespace: zm_genesis_arena
	Checksum: 0x7297DD3
	Offset: 0x7A60
	Size: 0x226
	Parameters: 2
	Flags: Linked
*/
function function_80340a8d(n_path_index, var_45868921)
{
	level endon(#"arena_challenge_ended");
	level endon(#"shadow_challenge_ended");
	var_60d3617 = 128;
	var_e453ffc4 = struct::get("arena_shadow_tornado_0_" + n_path_index, "targetname");
	var_f3364be4 = util::spawn_model("tag_origin", var_e453ffc4.origin, vectorscale((-1, 0, 0), 90));
	if(!isdefined(level.var_633c0362))
	{
		level.var_633c0362 = [];
	}
	if(!isdefined(level.var_633c0362))
	{
		level.var_633c0362 = [];
	}
	else if(!isarray(level.var_633c0362))
	{
		level.var_633c0362 = array(level.var_633c0362);
	}
	level.var_633c0362[level.var_633c0362.size] = var_f3364be4;
	level thread function_5a0567f1(var_f3364be4);
	while(true)
	{
		n_path_index = n_path_index + 1;
		if(n_path_index == var_45868921)
		{
			n_path_index = 0;
		}
		var_e453ffc4 = struct::get("arena_shadow_tornado_0_" + n_path_index, "targetname");
		var_7487d535 = distance(var_e453ffc4.origin, var_f3364be4.origin);
		var_c4f71af2 = var_7487d535 / var_60d3617;
		var_f3364be4 moveto(var_e453ffc4.origin, var_c4f71af2);
		wait(var_c4f71af2);
	}
}

/*
	Name: function_5a0567f1
	Namespace: zm_genesis_arena
	Checksum: 0xE9E93A2B
	Offset: 0x7C90
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function function_5a0567f1(var_f3364be4)
{
	level endon(#"arena_challenge_ended");
	level endon(#"shadow_challenge_ended");
	var_56169cc1 = 0;
	while(!var_56169cc1)
	{
		var_56169cc1 = 1;
		a_players = arraycopy(level.activeplayers);
		foreach(player in a_players)
		{
			if(isdefined(player) && distancesquared(var_f3364be4.origin, player.origin) < 36864)
			{
				var_56169cc1 = 0;
			}
		}
		util::wait_network_frame();
	}
	var_f3364be4 clientfield::set("arena_tornado", 1);
	var_f3364be4 thread function_2b740dcf();
}

/*
	Name: function_2b740dcf
	Namespace: zm_genesis_arena
	Checksum: 0x74C310A4
	Offset: 0x7E10
	Size: 0x1B0
	Parameters: 0
	Flags: Linked
*/
function function_2b740dcf()
{
	level endon(#"arena_challenge_ended");
	level endon(#"shadow_challenge_ended");
	self notify(#"hash_2b740dcf");
	self endon(#"hash_2b740dcf");
	self endon(#"delete");
	players = arraycopy(level.activeplayers);
	while(true)
	{
		if(!isdefined(self))
		{
			return;
		}
		players = arraycopy(level.activeplayers);
		foreach(player in players)
		{
			if(isdefined(player) && isdefined(self))
			{
				if(distancesquared(player.origin, self.origin) < 9216)
				{
					player dodamage(10, player.origin, undefined, undefined, undefined, "MOD_BURNED", 0, getweapon("incendiary_fire"));
					level thread function_de3937fa(player);
				}
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_306a8062
	Namespace: zm_genesis_arena
	Checksum: 0x5989CAD1
	Offset: 0x7FC8
	Size: 0x36
	Parameters: 0
	Flags: None
*/
function function_306a8062()
{
	level endon(#"hash_306a8062");
	while(true)
	{
		function_c5938cab(1);
		wait(3);
	}
}

/*
	Name: function_88f5a59c
	Namespace: zm_genesis_arena
	Checksum: 0xA67111FC
	Offset: 0x8008
	Size: 0xB6
	Parameters: 1
	Flags: None
*/
function function_88f5a59c(var_862980ee)
{
	level endon(#"hash_306a8062");
	if(isdefined(var_862980ee))
	{
		var_e0a3b3d7 = var_862980ee;
	}
	else
	{
		var_e0a3b3d7 = 0;
	}
	while(true)
	{
		zm_genesis_util::function_c3266652("arena_smoke_perimeter_" + var_e0a3b3d7, 1);
		level thread function_ab5cd340(var_e0a3b3d7);
		wait(0.1);
		var_e0a3b3d7 = var_e0a3b3d7 + 1;
		if(var_e0a3b3d7 >= 200)
		{
			var_e0a3b3d7 = 0;
		}
	}
}

/*
	Name: function_ab5cd340
	Namespace: zm_genesis_arena
	Checksum: 0x8013237D
	Offset: 0x80C8
	Size: 0x158
	Parameters: 1
	Flags: Linked
*/
function function_ab5cd340(var_e0a3b3d7)
{
	s_smoke = struct::get("arena_smoke_perimeter_" + var_e0a3b3d7, "targetname");
	n_start_time = gettime();
	while((gettime() - n_start_time) < 1)
	{
		a_players = arraycopy(level.activeplayers);
		foreach(player in a_players)
		{
			if(distancesquared(player.origin, s_smoke.origin) < 16384)
			{
				level thread function_de3937fa(player);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_de3937fa
	Namespace: zm_genesis_arena
	Checksum: 0xC1D599DE
	Offset: 0x8228
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_de3937fa(player)
{
	player notify(#"hash_de3937fa");
	player endon(#"hash_de3937fa");
	player clientfield::set_to_player("darkness_postfx_set", 1);
	wait(5);
	player clientfield::set_to_player("darkness_postfx_set", 0);
}

/*
	Name: function_2f3b6dab
	Namespace: zm_genesis_arena
	Checksum: 0xBE7ED98B
	Offset: 0x82A8
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_2f3b6dab()
{
	for(i = 0; i < 200; i++)
	{
		zm_genesis_util::function_7c229e48("arena_smoke_perimeter_" + i);
	}
}

/*
	Name: function_d2a9fa8c
	Namespace: zm_genesis_arena
	Checksum: 0xD1FBE09
	Offset: 0x8300
	Size: 0x232
	Parameters: 2
	Flags: Linked
*/
function function_d2a9fa8c(var_e78a4f30 = 0, var_47a4362c = 0)
{
	level.var_fe2fb4b9 = -1;
	level thread function_3dbace38();
	a_players = arraycopy(level.activeplayers);
	foreach(player in a_players)
	{
		player clientfield::set_to_player("darkness_postfx_set", 0);
	}
	level notify(#"hash_306a8062");
	zm_genesis_util::function_7c229e48("arena_smoke_spider_spawn");
	exploder::stop_exploder("lgt_darkarena_nuetral");
	exploder::stop_exploder("lgt_darkarena_shadowquest");
	function_c5938cab(0);
	function_2f3b6dab();
	foreach(var_f3364be4 in level.var_633c0362)
	{
		if(isdefined(var_f3364be4))
		{
			var_f3364be4 clientfield::set("arena_tornado", 0);
			var_f3364be4 delete();
		}
	}
}

/*
	Name: function_c5938cab
	Namespace: zm_genesis_arena
	Checksum: 0x1410A695
	Offset: 0x8540
	Size: 0x45C
	Parameters: 1
	Flags: Linked
*/
function function_c5938cab(b_on)
{
	var_c3f79192 = [];
	if(!isdefined(var_c3f79192))
	{
		var_c3f79192 = [];
	}
	else if(!isarray(var_c3f79192))
	{
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_left";
	if(!isdefined(var_c3f79192))
	{
		var_c3f79192 = [];
	}
	else if(!isarray(var_c3f79192))
	{
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_right";
	if(!isdefined(var_c3f79192))
	{
		var_c3f79192 = [];
	}
	else if(!isarray(var_c3f79192))
	{
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_front";
	if(!isdefined(var_c3f79192))
	{
		var_c3f79192 = [];
	}
	else if(!isarray(var_c3f79192))
	{
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_back";
	if(!isdefined(var_c3f79192))
	{
		var_c3f79192 = [];
	}
	else if(!isarray(var_c3f79192))
	{
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_center_left";
	if(!isdefined(var_c3f79192))
	{
		var_c3f79192 = [];
	}
	else if(!isarray(var_c3f79192))
	{
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_center_right";
	if(!isdefined(var_c3f79192))
	{
		var_c3f79192 = [];
	}
	else if(!isarray(var_c3f79192))
	{
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_center_back";
	foreach(var_36655503 in var_c3f79192)
	{
		zm_genesis_util::function_7c229e48(var_36655503);
	}
	if(b_on)
	{
		for(i = 0; i < 3; i++)
		{
			zm_genesis_util::function_c3266652(array::random(var_c3f79192), undefined, 0.5);
		}
	}
	else
	{
		zm_genesis_util::function_7c229e48("arena_smoke_left");
		zm_genesis_util::function_7c229e48("arena_smoke_right");
		zm_genesis_util::function_7c229e48("arena_smoke_front");
		zm_genesis_util::function_7c229e48("arena_smoke_back");
		zm_genesis_util::function_7c229e48("arena_smoke_center_left");
		zm_genesis_util::function_7c229e48("arena_smoke_center_right");
		zm_genesis_util::function_7c229e48("arena_smoke_center_back");
	}
}

/*
	Name: function_e462dab8
	Namespace: zm_genesis_arena
	Checksum: 0xCD0EE085
	Offset: 0x89A8
	Size: 0x78C
	Parameters: 3
	Flags: Linked
*/
function function_e462dab8(b_on, var_98176bbc, var_8a2d164 = 10)
{
	thread [[ level.var_d90687be ]]->function_15c5e1();
	function_1df8c24(b_on, var_98176bbc);
	var_d4a18b68 = [];
	if(!isdefined(var_d4a18b68))
	{
		var_d4a18b68 = [];
	}
	else if(!isarray(var_d4a18b68))
	{
		var_d4a18b68 = array(var_d4a18b68);
	}
	var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_pillar";
	switch(var_98176bbc)
	{
		case 0:
		{
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_front";
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_front_left";
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_front_right";
			break;
		}
		case 1:
		{
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_back";
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_back_left";
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_back_right";
			break;
		}
		case 2:
		{
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_left";
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_front_left";
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_back_left";
			break;
		}
		case 3:
		{
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_right";
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_front_right";
			if(!isdefined(var_d4a18b68))
			{
				var_d4a18b68 = [];
			}
			else if(!isarray(var_d4a18b68))
			{
				var_d4a18b68 = array(var_d4a18b68);
			}
			var_d4a18b68[var_d4a18b68.size] = "arena_scripted_zombie_back_right";
			break;
		}
	}
	var_f7894032 = [];
	foreach(var_5704a921 in var_d4a18b68)
	{
		var_a5b51858 = struct::get_array(var_5704a921, "script_noteworthy");
		foreach(s_spawner in var_a5b51858)
		{
			if(!isdefined(var_f7894032))
			{
				var_f7894032 = [];
			}
			else if(!isarray(var_f7894032))
			{
				var_f7894032 = array(var_f7894032);
			}
			var_f7894032[var_f7894032.size] = s_spawner;
		}
	}
	foreach(var_ed54bf23 in var_f7894032)
	{
		var_ed54bf23.var_4ef230e4 = 1;
	}
	wait(10);
	function_1df8c24(0, var_98176bbc);
}

/*
	Name: function_1df8c24
	Namespace: zm_genesis_arena
	Checksum: 0xE017BF5A
	Offset: 0x9140
	Size: 0x120
	Parameters: 2
	Flags: Linked
*/
function function_1df8c24(b_on, var_98176bbc)
{
	if(b_on)
	{
		exploder::exploder(("fxexp_0" + var_98176bbc) + "1");
		wait(2);
		exploder::stop_exploder(("fxexp_0" + var_98176bbc) + "1");
		exploder::exploder(("fxexp_0" + var_98176bbc) + "2");
		level thread function_d81d4dd8(var_98176bbc);
	}
	else
	{
		exploder::stop_exploder(("fxexp_0" + var_98176bbc) + "2");
		exploder::exploder(("fxexp_0" + var_98176bbc) + "3");
		level notify("arena_challenge_flame_wall_damage_thread_" + var_98176bbc);
	}
}

/*
	Name: function_f1e6c2a7
	Namespace: zm_genesis_arena
	Checksum: 0x62996EED
	Offset: 0x9268
	Size: 0x188
	Parameters: 4
	Flags: Linked
*/
function function_f1e6c2a7(var_87c8152d, var_eadfbdd4 = 0, var_e78a4f30 = 0, var_47a4362c = 0)
{
	level thread function_b6ddba23(var_87c8152d);
	if(var_e78a4f30 == 0)
	{
		level.var_beccbadb = 0;
		level.var_de72c885 = 0;
		level.var_c4133b63 = 3;
	}
	if(var_47a4362c == 1)
	{
		level.var_beccbadb = 0;
		level.var_de72c885 = 0;
		level.var_c4133b63 = 2;
	}
	exploder::exploder("lgt_darkarena_nuetral");
	exploder::exploder("lgt_darkarena_firequest");
	level thread function_e499e553();
	level thread function_82a0458d();
	level thread function_e06bfc41();
	if(var_e78a4f30 == 0)
	{
		thread [[ level.var_d90687be ]]->function_a1c7821d(1);
		thread [[ level.var_d90687be ]]->function_e4dbca5a(var_87c8152d);
	}
}

/*
	Name: function_82a0458d
	Namespace: zm_genesis_arena
	Checksum: 0x7814963A
	Offset: 0x93F8
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function function_82a0458d()
{
	for(i = 0; i < 10; i++)
	{
		var_eeb53a6c = struct::get("arena_lava_upper_" + i);
		level thread function_36c2a88b(var_eeb53a6c.origin);
	}
}

/*
	Name: function_e06bfc41
	Namespace: zm_genesis_arena
	Checksum: 0x5977C2F5
	Offset: 0x9488
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_e06bfc41()
{
	level endon(#"arena_challenge_ended");
	level endon(#"fire_challenge_ended");
	var_44ed020 = randomintrange(0, 4);
	while(true)
	{
		level thread function_a0aeb892(var_44ed020);
		wait(31);
		var_44ed020 = function_320bc09(4, var_44ed020);
	}
}

/*
	Name: function_a0aeb892
	Namespace: zm_genesis_arena
	Checksum: 0xA845C9F5
	Offset: 0x9520
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_a0aeb892(n_location_index)
{
	var_6da45390 = struct::get("arena_pillar_lava_" + n_location_index, "targetname");
	var_8f719caf = util::spawn_model("p7_fxanim_zm_gen_dark_arena_lava_01_mod", var_6da45390.origin, (0, randomintrange(0, 360), 0));
	var_8f719caf thread function_4706cfff(30000, 1);
	util::waittill_any_timeout(31, "arena_challenge_ended", "fire_challenge_ended");
	var_8f719caf clientfield::set("fire_column", 0);
	util::wait_network_frame();
	var_8f719caf delete();
	util::wait_network_frame();
}

/*
	Name: function_4706cfff
	Namespace: zm_genesis_arena
	Checksum: 0x4F58FF7E
	Offset: 0x9658
	Size: 0x3F0
	Parameters: 2
	Flags: Linked
*/
function function_4706cfff(n_duration, var_325cfa0d = 0)
{
	level endon(#"arena_challenge_ended");
	level endon(#"fire_challenge_ended");
	self endon(#"delete");
	if(var_325cfa0d)
	{
		self clientfield::set("fire_column", 1);
		var_112f4912 = 4;
	}
	else
	{
		var_112f4912 = 0.75;
	}
	n_rate = 1 / (n_duration / 180);
	var_c8ec0774 = var_112f4912 - 0.25;
	n_start_time = gettime();
	n_time_elapsed = gettime() - n_start_time;
	var_a8c2ff4b = 0;
	var_e2b185cf = n_duration * 0.9;
	if(var_325cfa0d)
	{
		self thread scene::play("p7_fxanim_zm_gen_dark_arena_lava_01_bundle", self);
	}
	else
	{
		self thread scene::play("p7_fxanim_zm_gen_dark_arena_lava_01_small_bundle", self);
	}
	while(n_time_elapsed < n_duration)
	{
		if(!isdefined(self))
		{
			return;
		}
		n_time_elapsed = gettime() - n_start_time;
		var_615956ca = sin(n_time_elapsed * n_rate);
		var_615956ca = abs(var_615956ca);
		n_scale = 0.25 + (var_615956ca * var_c8ec0774);
		if(var_325cfa0d && n_time_elapsed > var_e2b185cf && !var_a8c2ff4b)
		{
			self clientfield::set("fire_column", 0);
			var_a8c2ff4b = 1;
		}
		players = level.activeplayers;
		foreach(player in players)
		{
			var_14f93b92 = distance2dsquared(player.origin, self.origin) < (pow(n_scale * 116, 2));
			var_9cad7403 = player.origin[2] < (self.origin[2] + 8);
			if(var_14f93b92 && var_9cad7403 && player isonground())
			{
				player dodamage(10, player.origin, undefined, undefined, undefined, "MOD_BURNED", 0, getweapon("incendiary_fire"));
				level thread function_33b2cd3e(player);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_d81d4dd8
	Namespace: zm_genesis_arena
	Checksum: 0x7A6ED9CF
	Offset: 0x9A50
	Size: 0x240
	Parameters: 1
	Flags: Linked
*/
function function_d81d4dd8(var_7c34c9a5)
{
	level notify("arena_challenge_flame_wall_damage_thread_" + var_7c34c9a5);
	level endon("arena_challenge_flame_wall_damage_thread_" + var_7c34c9a5);
	level endon(#"arena_challenge_ended");
	level endon(#"fire_challenge_ended");
	a_e_triggers = getentarray("arena_flame_wall_" + var_7c34c9a5, "targetname");
	while(true)
	{
		foreach(e_trigger in a_e_triggers)
		{
			players = arraycopy(level.activeplayers);
			foreach(player in players)
			{
				if(isdefined(player) && player istouching(e_trigger))
				{
					player dodamage(player.maxhealth * 0.05, player.origin, undefined, undefined, undefined, "MOD_BURNED", 0, getweapon("incendiary_fire"));
					level thread function_33b2cd3e(player);
				}
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_e3782b49
	Namespace: zm_genesis_arena
	Checksum: 0x4E150802
	Offset: 0x9C98
	Size: 0x148
	Parameters: 0
	Flags: None
*/
function function_e3782b49()
{
	level endon(#"arena_challenge_ended");
	level endon(#"fire_challenge_ended");
	self endon(#"delete");
	while(true)
	{
		players = level.activeplayers;
		foreach(player in players)
		{
			if(player istouching(self))
			{
				player dodamage(10, player.origin, undefined, undefined, undefined, "MOD_BURNED", 0, getweapon("incendiary_fire"));
				level thread function_33b2cd3e(player);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_36c2a88b
	Namespace: zm_genesis_arena
	Checksum: 0x64714315
	Offset: 0x9DE8
	Size: 0x200
	Parameters: 2
	Flags: Linked
*/
function function_36c2a88b(v_spawn_pos, n_wait)
{
	wait(randomfloatrange(0.5, 17.5));
	while(level.var_fe2fb4b9 == 2)
	{
		var_2f0b203b = util::spawn_model("tag_origin", v_spawn_pos + (vectorscale((0, 0, -1), 25)), (0, randomintrange(0, 360), 0));
		util::wait_network_frame();
		var_2f0b203b clientfield::set("runeprison_rock_fx", 1);
		wait(3);
		var_2f0b203b clientfield::set("runeprison_explode_fx", 1);
		var_8f719caf = util::spawn_model("p7_fxanim_zm_gen_dark_arena_lava_01_small_mod", v_spawn_pos + (vectorscale((0, 0, -1), 13)), (0, randomintrange(0, 360), 0));
		var_8f719caf function_4706cfff(8500);
		var_8f719caf delete();
		var_2f0b203b clientfield::set("runeprison_rock_fx", 0);
		wait(6);
		var_2f0b203b delete();
		wait(randomfloatrange(5, 17.5 / 2));
	}
}

/*
	Name: function_e499e553
	Namespace: zm_genesis_arena
	Checksum: 0x25CE5371
	Offset: 0x9FF0
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function function_e499e553()
{
	level endon(#"arena_challenge_ended");
	level endon(#"fire_challenge_ended");
	while(true)
	{
		var_98176bbc = randomint(5);
		level thread function_e462dab8(1, var_98176bbc);
		wait(5);
		var_98176bbc = randomintrange(5, 8);
		level thread function_e462dab8(1, var_98176bbc);
		wait(5);
	}
}

/*
	Name: function_56b687ac
	Namespace: zm_genesis_arena
	Checksum: 0x4CEC685D
	Offset: 0xA0A8
	Size: 0x118
	Parameters: 2
	Flags: Linked
*/
function function_56b687ac(var_e78a4f30 = 0, var_47a4362c = 0)
{
	level.var_fe2fb4b9 = -1;
	level thread function_3dbace38();
	level notify(#"arena_challenge_ended");
	level notify(#"fire_challenge_ended");
	exploder::stop_exploder("lgt_darkarena_nuetral");
	exploder::stop_exploder("lgt_darkarena_firequest");
	for(i = 0; i < 8; i++)
	{
		level thread function_e462dab8(0, i);
	}
	if(!level flag::get("final_boss_started"))
	{
		thread [[ level.var_d90687be ]]->function_15c5e1();
	}
}

/*
	Name: function_33b2cd3e
	Namespace: zm_genesis_arena
	Checksum: 0x4DF74E8A
	Offset: 0xA1C8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_33b2cd3e(player)
{
	player notify(#"hash_33b2cd3e");
	player endon(#"hash_33b2cd3e");
	player clientfield::set_to_player("fire_postfx_set", 1);
	wait(2);
	player clientfield::set_to_player("fire_postfx_set", 0);
}

/*
	Name: function_f1aed0c6
	Namespace: zm_genesis_arena
	Checksum: 0xA1CD77D3
	Offset: 0xA248
	Size: 0x18C
	Parameters: 4
	Flags: Linked
*/
function function_f1aed0c6(var_87c8152d, var_eadfbdd4 = 0, var_e78a4f30 = 0, var_47a4362c = 0)
{
	level thread function_b6ddba23(var_87c8152d);
	if(var_e78a4f30 == 0)
	{
		level.var_beccbadb = 0;
		level.var_de72c885 = 0;
		level.var_c4133b63 = 3;
	}
	if(var_47a4362c == 1)
	{
		level.var_beccbadb = 0;
		level.var_de72c885 = 0;
		level.var_c4133b63 = 2;
	}
	level.var_867977f0 = [];
	level thread function_c0d6adb6();
	level thread function_e2a11bad();
	level thread function_ffce63a9();
	exploder::exploder("lgt_darkarena_nuetral");
	exploder::exploder("lgt_darkarena_electric_quest");
	if(var_e78a4f30 == 0)
	{
		thread [[ level.var_d90687be ]]->function_a1c7821d(0);
		thread [[ level.var_d90687be ]]->function_e4dbca5a(var_87c8152d);
	}
}

/*
	Name: function_c78d187b
	Namespace: zm_genesis_arena
	Checksum: 0xB5689D71
	Offset: 0xA3E0
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function function_c78d187b(var_e78a4f30 = 0, var_47a4362c = 0)
{
	level.var_fe2fb4b9 = -1;
	level thread function_3dbace38();
	level.var_435967f3 = 0;
	level notify(#"hash_c0d6adb6");
	exploder::stop_exploder("lgt_darkarena_nuetral");
	exploder::stop_exploder("lgt_darkarena_electric_quest");
	if(isdefined(level.var_867977f0))
	{
		array::thread_all(level.var_867977f0, &function_4d79d831);
	}
}

/*
	Name: function_c0d6adb6
	Namespace: zm_genesis_arena
	Checksum: 0x51B12B9D
	Offset: 0xA4C8
	Size: 0x2D6
	Parameters: 0
	Flags: Linked
*/
function function_c0d6adb6()
{
	level endon(#"hash_c0d6adb6");
	level endon(#"arena_challenge_ended");
	level endon(#"electricity_challenge_ended");
	var_4054c946 = 4;
	var_665743af = 4;
	var_5c856d1f = randomintrange(0, 4);
	switch(var_5c856d1f)
	{
		case 0:
		{
			var_665743af = var_665743af - 1;
			break;
		}
		case 1:
		{
			var_665743af = var_665743af + 1;
			break;
		}
		case 2:
		{
			var_4054c946 = var_4054c946 - 1;
			break;
		}
		case 3:
		{
			var_4054c946 = var_4054c946 + 1;
			break;
		}
	}
	while(true)
	{
		b_reverse_dir = 0;
		if(var_5c856d1f == 2 || var_5c856d1f == 1)
		{
			b_reverse_dir = 1;
		}
		str_name = (("arena_fence_" + var_4054c946) + "_") + var_665743af;
		var_44622ece = struct::get(str_name, "targetname");
		level thread function_cc9c82c8(var_44622ece, 3, undefined, b_reverse_dir, 1);
		wait(0.75);
		switch(var_5c856d1f)
		{
			case 0:
			{
				var_665743af = var_665743af + 1;
				break;
			}
			case 1:
			{
				var_665743af = var_665743af - 1;
				break;
			}
			case 2:
			{
				var_4054c946 = var_4054c946 - 1;
				break;
			}
			case 3:
			{
				var_4054c946 = var_4054c946 + 1;
				break;
			}
		}
		var_5c856d1f = function_1bd87d75(var_4054c946, var_665743af, var_5c856d1f);
		switch(var_5c856d1f)
		{
			case 0:
			{
				var_665743af = var_665743af + 1;
				break;
			}
			case 1:
			{
				var_665743af = var_665743af - 1;
				break;
			}
			case 2:
			{
				var_4054c946 = var_4054c946 - 1;
				break;
			}
			case 3:
			{
				var_4054c946 = var_4054c946 + 1;
				break;
			}
		}
	}
}

/*
	Name: function_e2a11bad
	Namespace: zm_genesis_arena
	Checksum: 0x10189FA5
	Offset: 0xA7A8
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function function_e2a11bad()
{
	level endon(#"arena_challenge_ended");
	level endon(#"electricity_challenge_ended");
	var_bcc7a104 = 0;
	var_d5c2ef73 = 6;
	while(true)
	{
		var_bcc7a104 = var_bcc7a104 + 1;
		if(var_bcc7a104 > 3)
		{
			var_bcc7a104 = 0;
		}
		str_name = "arena_fence_ext_low_" + var_bcc7a104;
		level thread function_5e9f49d2(str_name, 7, vectorscale((0, 0, -1), 192), 0, 2);
		var_d5c2ef73 = var_d5c2ef73 + 1;
		if(var_d5c2ef73 > 7)
		{
			var_d5c2ef73 = 4;
		}
		str_name = "arena_fence_ext_low_" + var_d5c2ef73;
		level thread function_5e9f49d2(str_name, 7, vectorscale((0, 0, -1), 192), 0, 2);
		wait(5);
	}
}

/*
	Name: function_ffce63a9
	Namespace: zm_genesis_arena
	Checksum: 0x466CE170
	Offset: 0xA8D8
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function function_ffce63a9()
{
	level endon(#"arena_challenge_ended");
	level endon(#"electricity_challenge_ended");
	a_indexes = array(0, 1, 2, 3, 4, 5);
	while(true)
	{
		a_indexes = array::randomize(a_indexes);
		for(i = 0; i < 3; i++)
		{
			str_name = "arena_fence_ext_high_" + a_indexes[i];
			level thread function_5e9f49d2(str_name, 7, vectorscale((0, 0, -1), 192), 0, 3);
		}
		wait(5);
	}
}

/*
	Name: function_1bd87d75
	Namespace: zm_genesis_arena
	Checksum: 0x668F5F90
	Offset: 0xA9D0
	Size: 0x2E0
	Parameters: 3
	Flags: Linked
*/
function function_1bd87d75(var_4054c946, var_665743af, var_5c856d1f)
{
	if(var_4054c946 == 0 && var_665743af == 0)
	{
		if(var_5c856d1f == 1)
		{
			return 3;
		}
		return 0;
	}
	if(var_4054c946 == 8 && var_665743af == 0)
	{
		if(var_5c856d1f == 1)
		{
			return 2;
		}
		return 0;
	}
	if(var_4054c946 == 0 && var_665743af == 8)
	{
		if(var_5c856d1f == 0)
		{
			return 3;
		}
		return 1;
	}
	if(var_4054c946 == 8 && var_665743af == 8)
	{
		if(var_5c856d1f == 0)
		{
			return 2;
		}
		return 1;
	}
	var_47c6b9e2 = function_c3557b99(var_5c856d1f);
	if(function_401ee1f7(var_4054c946, var_665743af))
	{
		if(var_4054c946 == 4 && var_665743af == 0)
		{
			var_6af9e605 = array(2, 0, 3);
		}
		if(var_4054c946 == 0 && var_665743af == 4)
		{
			var_6af9e605 = array(1, 0, 3);
		}
		if(var_4054c946 == 4 && var_665743af == 8)
		{
			var_6af9e605 = array(2, 1, 3);
		}
		if(var_4054c946 == 8 && var_665743af == 4)
		{
			var_6af9e605 = array(2, 0, 1);
		}
		var_6af9e605 = zm_genesis_util::array_remove(var_6af9e605, var_47c6b9e2);
		return array::random(var_6af9e605);
	}
	if(var_4054c946 == 4 && var_665743af == 4)
	{
		var_6af9e605 = array(2, 0, 3, 1);
		var_6af9e605 = zm_genesis_util::array_remove(var_6af9e605, var_47c6b9e2);
		return array::random(var_6af9e605);
	}
	return var_5c856d1f;
}

/*
	Name: function_401ee1f7
	Namespace: zm_genesis_arena
	Checksum: 0xD094907E
	Offset: 0xACB8
	Size: 0x88
	Parameters: 2
	Flags: Linked
*/
function function_401ee1f7(var_4054c946, var_665743af)
{
	if(var_4054c946 == 4 && var_665743af == 0 || (var_4054c946 == 0 && var_665743af == 4) || (var_4054c946 == 4 && var_665743af == 8) || (var_4054c946 == 8 && var_665743af == 4))
	{
		return true;
	}
	return false;
}

/*
	Name: function_c3557b99
	Namespace: zm_genesis_arena
	Checksum: 0x842D8479
	Offset: 0xAD48
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function function_c3557b99(n_dir)
{
	if(n_dir == 0)
	{
		return 1;
	}
	if(n_dir == 1)
	{
		return 0;
	}
	if(n_dir == 2)
	{
		return 3;
	}
	if(n_dir == 3)
	{
		return 2;
	}
}

/*
	Name: function_5e9f49d2
	Namespace: zm_genesis_arena
	Checksum: 0x58B2A8E9
	Offset: 0xADA8
	Size: 0xF2
	Parameters: 5
	Flags: Linked
*/
function function_5e9f49d2(str_name, n_duration, v_offset, b_reverse_dir, var_b222a396)
{
	var_659d66d1 = struct::get_array(str_name, "targetname");
	foreach(var_44622ece in var_659d66d1)
	{
		level thread function_cc9c82c8(var_44622ece, n_duration, v_offset, b_reverse_dir, var_b222a396);
	}
}

/*
	Name: function_cc9c82c8
	Namespace: zm_genesis_arena
	Checksum: 0x26D1D6F0
	Offset: 0xAEA8
	Size: 0x354
	Parameters: 5
	Flags: Linked
*/
function function_cc9c82c8(var_44622ece, n_duration, v_offset, b_reverse_dir, var_b222a396)
{
	if(isdefined(var_44622ece.var_1771513c) && var_44622ece.var_1771513c)
	{
		return;
	}
	var_44622ece.var_1771513c = 1;
	if(var_b222a396 == 3)
	{
		var_21d644c = util::spawn_model("p7_fxanim_zm_gen_dark_arena_moving_wall_02_mod", var_44622ece.origin, var_44622ece.angles);
	}
	else
	{
		var_21d644c = util::spawn_model("p7_fxanim_zm_gen_dark_arena_moving_wall_mod", var_44622ece.origin, var_44622ece.angles);
	}
	if(isdefined(b_reverse_dir) && b_reverse_dir)
	{
		var_21d644c.angles = var_21d644c.angles + vectorscale((0, 1, 0), 180);
	}
	var_21d644c notsolid();
	util::wait_network_frame();
	var_21d644c clientfield::increment("elec_wall_tell");
	wait(1);
	switch(var_b222a396)
	{
		case 1:
		{
			var_7146001e = "p7_fxanim_zm_gen_dark_arena_moving_wall_rise_anim";
			var_117d442a = "p7_fxanim_zm_gen_dark_arena_moving_wall_fall_anim";
			break;
		}
		case 2:
		{
			var_7146001e = "p7_fxanim_zm_gen_dark_arena_moving_wall_rise02_anim";
			var_117d442a = "p7_fxanim_zm_gen_dark_arena_moving_wall_fall02_anim";
			break;
		}
		case 3:
		{
			var_7146001e = "p7_fxanim_zm_gen_dark_arena_moving_wall_02_rise_anim";
			var_117d442a = "p7_fxanim_zm_gen_dark_arena_moving_wall_02_fall_anim";
		}
	}
	var_21d644c useanimtree($zm_genesis);
	var_21d644c thread animation::play(var_7146001e, undefined, undefined, 1);
	v_origin = var_44622ece.origin;
	if(!isdefined(v_offset))
	{
		v_offset = vectorscale((0, 0, 1), 128);
	}
	wait(0.5);
	var_21d644c solid();
	var_21d644c thread function_48791cb7();
	wait(0.5);
	if(isdefined(n_duration))
	{
		wait(n_duration);
	}
	else
	{
		level util::waittill_any("arena_challenge_ended", "electricity_challenge_ended");
	}
	var_21d644c animation::play(var_117d442a, undefined, undefined, 1);
	var_21d644c delete();
	var_44622ece.var_1771513c = 0;
}

/*
	Name: function_48791cb7
	Namespace: zm_genesis_arena
	Checksum: 0xCA81B8BB
	Offset: 0xB208
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function function_48791cb7()
{
	level endon(#"arena_challenge_ended");
	level endon(#"electricity_challenge_ended");
	self notify(#"hash_48791cb7");
	self endon(#"hash_48791cb7");
	self endon(#"delete");
	while(true)
	{
		if(!isdefined(self))
		{
			return;
		}
		foreach(player in level.activeplayers)
		{
			if(isdefined(player) && (distancesquared(player.origin, self.origin - vectorscale((0, 0, 1), 63))) < 6400)
			{
				level thread function_d1ced388(player);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_d1ced388
	Namespace: zm_genesis_arena
	Checksum: 0x5135EE07
	Offset: 0xB348
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_d1ced388(player)
{
	player dodamage(10, player.origin, undefined, undefined, undefined, "MOD_ELECTROCUTED", 0);
	/#
		iprintlnbold("");
	#/
}

/*
	Name: function_4d79d831
	Namespace: zm_genesis_arena
	Checksum: 0xB144A05A
	Offset: 0xB3B8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_4d79d831()
{
	if(isdefined(self.initial_origin))
	{
		self connectpaths();
		self moveto(self.initial_origin, 1);
	}
}

/*
	Name: function_27c3331e
	Namespace: zm_genesis_arena
	Checksum: 0x7E73725A
	Offset: 0xB410
	Size: 0x2E4
	Parameters: 1
	Flags: Linked
*/
function function_27c3331e(var_50a530a1)
{
	switch(var_50a530a1)
	{
		case 0:
		{
			n_start_index = 0;
			break;
		}
		case 1:
		{
			n_start_index = 2;
			break;
		}
		case 2:
		{
			n_start_index = 4;
			break;
		}
		case 3:
		{
			n_start_index = 6;
			break;
		}
	}
	s_start = struct::get("arena_shadow_column_" + n_start_index, "targetname");
	var_e728df08 = util::spawn_model("p7_zm_gen_shadow_q_pillar", s_start.origin + (0, 0, 896), s_start.angles);
	mdl_collision = util::spawn_model("p7_zm_gen_shadow_q_pillar_collision", var_e728df08.origin, var_e728df08.angles);
	mdl_collision enablelinkto();
	mdl_collision linkto(var_e728df08);
	var_e728df08 moveto(s_start.origin, 3);
	var_e728df08 playsound("zmb_bossrush_shadow_pillar_lower");
	wait(3);
	var_e728df08 thread function_61e62395(n_start_index);
	var_e728df08 clientfield::set("arena_shadow_pillar", 1);
	var_e728df08 thread function_a7750926();
	level util::waittill_any("arena_challenge_ended", "shadow_challenge_ended");
	var_e728df08 clientfield::set("arena_shadow_pillar", 0);
	var_e728df08 moveto(var_e728df08.origin + (0, 0, 896), 3);
	var_e728df08 playsound("zmb_bossrush_shadow_pillar_rise");
	wait(3);
	var_e728df08 delete();
	mdl_collision delete();
}

/*
	Name: function_a7750926
	Namespace: zm_genesis_arena
	Checksum: 0x4A5E779B
	Offset: 0xB700
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function function_a7750926()
{
	level endon(#"arena_challenge_ended");
	level endon(#"shadow_challenge_ended");
	self notify(#"hash_a7750926");
	self endon(#"hash_a7750926");
	self endon(#"delete");
	players = arraycopy(level.activeplayers);
	while(true)
	{
		if(!isdefined(self))
		{
			return;
		}
		foreach(player in players)
		{
			if(distancesquared(player.origin, self.origin) < 6400)
			{
				level thread function_88cd4fe1(player);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_88cd4fe1
	Namespace: zm_genesis_arena
	Checksum: 0xECA19622
	Offset: 0xB840
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_88cd4fe1(player)
{
	player dodamage(10, player.origin, undefined, undefined, undefined, "MOD_ELECTROCUTED", 0);
	/#
		iprintlnbold("");
	#/
}

/*
	Name: function_61e62395
	Namespace: zm_genesis_arena
	Checksum: 0x8F7E337D
	Offset: 0xB8B0
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function function_61e62395(var_50a530a1)
{
	level endon(#"arena_challenge_ended");
	level endon(#"shadow_challenge_ended");
	var_c951867e = var_50a530a1;
	while(true)
	{
		wait(3);
		var_c951867e = var_c951867e + 1;
		if(var_c951867e > 7)
		{
			var_c951867e = 0;
		}
		s_next = struct::get("arena_shadow_column_" + var_c951867e, "targetname");
		self moveto(s_next.origin, 6);
		self playloopsound("zmb_bossrush_shadow_pillar_lp", 0.25);
		wait(6);
		self stoploopsound(0.25);
	}
}

/*
	Name: function_320bc09
	Namespace: zm_genesis_arena
	Checksum: 0xA256E85C
	Offset: 0xB9E8
	Size: 0xCA
	Parameters: 2
	Flags: Linked
*/
function function_320bc09(n_max, var_b1f69aca)
{
	a_numbers = [];
	for(i = 0; i < n_max; i++)
	{
		if(i != var_b1f69aca)
		{
			if(!isdefined(a_numbers))
			{
				a_numbers = [];
			}
			else if(!isarray(a_numbers))
			{
				a_numbers = array(a_numbers);
			}
			a_numbers[a_numbers.size] = i;
		}
	}
	return array::random(a_numbers);
}

/*
	Name: function_5a4ec2e2
	Namespace: zm_genesis_arena
	Checksum: 0xB7DD519A
	Offset: 0xBAC0
	Size: 0x250
	Parameters: 1
	Flags: Linked
*/
function function_5a4ec2e2(var_87c8152d = 0)
{
	if(!isdefined(level.var_beccbadb))
	{
		level.var_beccbadb = 0;
	}
	if(!isdefined(level.var_359cfe42))
	{
		level.var_359cfe42 = 0;
	}
	var_fae0d733 = struct::get_array("arena_boss_spawnpoint", "targetname");
	if(isdefined(level.var_a0e9e53))
	{
		arrayremovevalue(var_fae0d733, level.var_a0e9e53);
	}
	s_loc = array::random(var_fae0d733);
	level.var_a0e9e53 = s_loc;
	if(var_87c8152d == 2)
	{
		e_ai = zm_ai_margwa_elemental::function_75b161ab(undefined, s_loc);
	}
	else
	{
		if(var_87c8152d == 1)
		{
			e_ai = zm_ai_margwa_elemental::function_26efbc37(undefined, s_loc);
		}
		else
		{
			e_ai = zm_ai_margwa::function_8a0708c2(s_loc);
			e_ai clientfield::set("arena_margwa_init", 1);
		}
	}
	if(isdefined(e_ai))
	{
		level.var_beccbadb = level.var_beccbadb + 1;
		level.var_359cfe42 = level.var_359cfe42 + 1;
		level.var_95981590 = e_ai;
		level notify(#"hash_c484afcb");
		e_ai.b_ignore_cleanup = 1;
		e_ai.no_powerups = 1;
		n_health = (level.round_number * 100) + 100;
		e_ai margwaserverutils::margwasetheadhealth(n_health);
		e_ai thread function_730e8210(var_87c8152d);
	}
	return e_ai;
}

/*
	Name: function_2ed620e8
	Namespace: zm_genesis_arena
	Checksum: 0x6DEA77D1
	Offset: 0xBD18
	Size: 0x142
	Parameters: 1
	Flags: Linked
*/
function function_2ed620e8(var_87c8152d = 0)
{
	var_fae0d733 = struct::get_array("arena_boss_spawnpoint", "targetname");
	s_loc = array::random(var_fae0d733);
	e_ai = zm_ai_mechz::spawn_mechz(s_loc, 0);
	if(isdefined(e_ai))
	{
		level.var_435967f3 = level.var_435967f3 + 1;
		level.var_359cfe42 = level.var_359cfe42 + 1;
		e_ai.no_powerups = 1;
		e_ai thread function_ebe65636();
		util::wait_network_frame();
		e_ai.b_ignore_cleanup = 1;
		level notify(#"hash_b4c3cb33");
		e_ai thread function_77127ffa(var_87c8152d);
		return e_ai;
	}
}

/*
	Name: function_730e8210
	Namespace: zm_genesis_arena
	Checksum: 0x832D0CC5
	Offset: 0xBE68
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function function_730e8210(var_87c8152d)
{
	self waittill(#"death");
	level.var_de72c885 = level.var_de72c885 + 1;
	level.var_beccbadb = level.var_beccbadb - 1;
	level.var_359cfe42 = level.var_359cfe42 - 1;
	if(level flag::get("boss_fight"))
	{
		return;
	}
	if(level flag::get("final_boss_started"))
	{
		return;
	}
	if(level.var_de72c885 == level.var_c4133b63)
	{
		if(level flag::get("boss_rush_phase_1"))
		{
			level notify(#"arena_challenge_ended");
			func_cleanup = level.var_5afa678d[var_87c8152d];
			level [[func_cleanup]]();
			level notify(#"hash_e59686ee");
		}
		else
		{
			if(level flag::get("boss_rush_phase_2"))
			{
				level notify(#"hash_7ea88c9e");
			}
			else
			{
				level thread function_c2578b2a();
			}
		}
	}
}

/*
	Name: function_77127ffa
	Namespace: zm_genesis_arena
	Checksum: 0x62B1EEBD
	Offset: 0xBFD0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_77127ffa(var_87c8152d)
{
	self waittill(#"death");
	level.var_278e37cd = level.var_278e37cd + 1;
	if(level flag::get("final_boss_started"))
	{
		return;
	}
	if(level.var_278e37cd == level.var_90280eb8)
	{
		function_c2578b2a();
	}
}

/*
	Name: function_c2578b2a
	Namespace: zm_genesis_arena
	Checksum: 0x115EC09E
	Offset: 0xC050
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function function_c2578b2a()
{
	if(level flag::get("boss_fight"))
	{
		return;
	}
	var_87c8152d = level clientfield::get("circle_challenge_identity");
	level notify(#"arena_challenge_ended");
	thread [[ level.var_d90687be ]]->function_b4aac082();
	if(level flag::get("custom_challenge"))
	{
		function_c5938cab(0);
		level flag::clear("custom_challenge");
	}
	else
	{
		func_cleanup = level.var_5afa678d[var_87c8152d];
		level thread [[func_cleanup]]();
	}
	/#
		iprintlnbold("");
	#/
	level flag::set("arena_challenge_complete_" + var_87c8152d);
	if(level flag::get("devgui_end_challenge"))
	{
		/#
			iprintlnbold("");
		#/
		level clientfield::set("arena_state", 1);
		level clientfield::set("circle_state", 4);
		wait(3);
		level clientfield::set("circle_state", 2);
		thread [[ level.var_d90687be ]]->function_32374471();
		level flag::clear("devgui_end_challenge");
	}
	else if(!level flag::get("final_boss_defeated"))
	{
		wait(7);
		level clientfield::set("arena_state", 3);
		thread [[ level.var_d90687be ]]->function_32374471();
		level util::waittill_any("arena_picked_up_reward", "arena_shutdown_thread");
	}
}

/*
	Name: function_ae8e44d6
	Namespace: zm_genesis_arena
	Checksum: 0xB254C38C
	Offset: 0xC2E0
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_ae8e44d6()
{
	level.var_eb7b7914 = 0;
	level.var_a0135c54 = 6;
	level notify(#"hash_f115a4c8");
	level clientfield::set("arena_state", 4);
	level clientfield::set("circle_state", 0);
	level clientfield::set("summoning_key_pickup", 1);
	wait(5);
	level thread function_ac440107();
	level flag::wait_till("book_runes_success");
	level notify(#"arena_challenge_ended");
	thread [[ level.var_d90687be ]]->function_b4aac082();
}

/*
	Name: function_ac440107
	Namespace: zm_genesis_arena
	Checksum: 0x9BE1B2D6
	Offset: 0xC3D0
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function function_ac440107()
{
	level endon(#"book_runes_success");
	while(!level flag::get("book_runes_success"))
	{
		level flag::wait_till("arena_occupied_by_player");
		thread [[ level.var_d90687be ]]->function_a1c7821d(0, 10);
		level thread function_d9624751();
		level flag::wait_till_clear("arena_occupied_by_player");
		level notify(#"hash_d9624751");
		level notify(#"hash_6d73b616");
	}
}

/*
	Name: function_32419cfe
	Namespace: zm_genesis_arena
	Checksum: 0xB9155383
	Offset: 0xC498
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_32419cfe()
{
	level endon(#"hash_6760e3ae");
	wait(14);
	level thread function_39df21f9();
}

/*
	Name: function_e3fb6380
	Namespace: zm_genesis_arena
	Checksum: 0x14F5B099
	Offset: 0xC4D0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_e3fb6380()
{
	level endon(#"hash_6760e3ae");
	wait(14 * 4.4);
	level thread function_39df21f9();
}

/*
	Name: function_b1b0d2b0
	Namespace: zm_genesis_arena
	Checksum: 0xB39ACAAF
	Offset: 0xC510
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_b1b0d2b0()
{
	var_78a22131 = struct::get("arena_shadowman_stage_center", "targetname");
	var_78a22131 zm_genesis_shadowman::function_8888a532(0, 1, 1);
	var_78a22131 notify(#"hash_42d111a0");
	var_cbddabee = spawn("script_model", var_78a22131.var_94d7beef.origin);
	var_cbddabee setmodel("p7_zm_gen_margwa_orb_red");
	var_cbddabee linkto(var_78a22131.var_94d7beef);
	var_cbddabee notsolid();
}

/*
	Name: function_655271b9
	Namespace: zm_genesis_arena
	Checksum: 0x65090709
	Offset: 0xC610
	Size: 0x47A
	Parameters: 0
	Flags: Linked
*/
function function_655271b9()
{
	level notify(#"hash_f115a4c8");
	var_6400c095 = array(6, 8, 10, 12);
	var_3e836e2f = array(4, 5, 6, 8);
	level.var_beccbadb = 0;
	level.var_c4133b63 = 2;
	level.var_de72c885 = 0;
	level.var_a0135c54 = var_3e836e2f[0];
	level.var_435967f3 = 0;
	level.var_e10b491b = 1;
	level.var_359cfe42 = 0;
	level.var_b9b689ce = 3;
	level.var_8e402c12 = var_6400c095[0];
	var_c6fda37e = struct::get_array("dark_arena_teleport_hijack", "targetname");
	for(i = 0; i < level.activeplayers.size; i++)
	{
		level.activeplayers[i] thread function_56668973(var_c6fda37e[i]);
	}
	level thread zm_genesis_sound::function_936d084f();
	level thread function_7719ec7(4);
	wait(4);
	level flag::set("boss_rush_phase_1");
	level notify(#"hash_f115a4c8");
	level thread function_389f8efe();
	for(i = 0; i < level.var_6000c357.size; i++)
	{
		clientfield::set("summoning_key_charge_state", i);
		level flag::set("arena_vanilla_zombie_override");
		if(i > 0)
		{
			level thread function_7719ec7(15);
			wait(15);
		}
		level thread function_7b82ff07(6);
		n_element_index = level.var_6000c357[i];
		level.var_8e402c12 = var_6400c095[i];
		level.var_a0135c54 = var_3e836e2f[i];
		level clientfield::set("circle_challenge_identity", n_element_index);
		level clientfield::set("arena_state", 2);
		level clientfield::set("circle_state", 3);
		level flag::clear("arena_vanilla_zombie_override");
		var_cecde52d = level.var_43e34f20[n_element_index];
		level thread [[var_cecde52d]](n_element_index, 0, 0, 1);
		level thread function_d9624751();
		level waittill(#"hash_e59686ee");
		playsoundatposition("zmb_bossrush_round_over", (0, 0, 0));
		thread [[ level.var_d90687be ]]->function_b4aac082();
		level thread function_7b82ff07(6);
	}
	wait(1);
	thread [[ level.var_d90687be ]]->function_b4aac082();
	level thread zm_genesis_sound::function_d73dcf42();
	wait(3);
	playsoundatposition("zmb_main_completion_big", (0, 0, 0));
	/#
		iprintlnbold("");
	#/
	level flag::clear("boss_rush_phase_1");
	level notify(#"hash_7af29ab");
}

/*
	Name: function_7719ec7
	Namespace: zm_genesis_arena
	Checksum: 0xE8AB08CA
	Offset: 0xCA98
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_7719ec7(time)
{
	level endon(#"hash_675baa5d");
	level endon(#"final_boss_defeated");
	wait(time - 1.9);
	playsoundatposition("zmb_bossrush_element_start", (0, 0, 0));
}

/*
	Name: function_389f8efe
	Namespace: zm_genesis_arena
	Checksum: 0x7EB7BF09
	Offset: 0xCAF0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_389f8efe()
{
	var_2c8e8252 = struct::get("arena_powerup_point", "targetname");
	powerup = level thread zm_powerups::specific_powerup_drop("full_ammo", var_2c8e8252.origin, undefined, undefined, undefined, undefined, 1);
	level flag::wait_till_clear("test_activate_arena");
	if(isdefined(powerup))
	{
		powerup thread zm_powerups::powerup_delete();
	}
}

/*
	Name: function_d9624751
	Namespace: zm_genesis_arena
	Checksum: 0x639FB071
	Offset: 0xCBA8
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function function_d9624751()
{
	level notify(#"hash_d9624751");
	level endon(#"hash_d9624751");
	level endon(#"hash_e59686ee");
	if(!isdefined(level.var_eb7b7914))
	{
		level.var_eb7b7914 = 0;
	}
	while(true)
	{
		if(level.var_eb7b7914 < level.var_a0135c54)
		{
			var_ea9e640b = randomintrange(0, 8);
			s_spawnpoint = struct::get("arena_fury_" + var_ea9e640b, "targetname");
			level thread function_e6146239(s_spawnpoint, 1);
			wait(3);
		}
		else
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: function_56668973
	Namespace: zm_genesis_arena
	Checksum: 0xB423E743
	Offset: 0xCCC0
	Size: 0x3EC
	Parameters: 1
	Flags: Linked
*/
function function_56668973(s_goto)
{
	if(distancesquared(self.origin, s_goto.origin) < 589824)
	{
		return;
	}
	self thread lui::screen_flash(0.1, 0.5, 0.5, 1, "white");
	var_daad3c3c = vectorscale((0, 0, 1), 49);
	var_6b55b1c4 = vectorscale((0, 0, 1), 20);
	var_3abe10e2 = (0, 0, 0);
	self disableoffhandweapons();
	self disableweapons();
	if(self getstance() == "prone")
	{
		var_e2a6e15f = s_goto.origin + var_daad3c3c;
	}
	else
	{
		if(self getstance() == "crouch")
		{
			var_e2a6e15f = s_goto.origin + var_6b55b1c4;
		}
		else
		{
			var_e2a6e15f = s_goto.origin + var_3abe10e2;
		}
	}
	self.var_601ebf01 = util::spawn_model("tag_origin", self.origin, self.angles);
	self linkto(self.var_601ebf01);
	self dontinterpolate();
	self.var_601ebf01 dontinterpolate();
	self.var_601ebf01.origin = var_e2a6e15f;
	self.var_601ebf01.angles = s_goto.angles;
	self freezecontrols(1);
	util::wait_network_frame();
	if(isdefined(self))
	{
		self.var_601ebf01.angles = s_goto.angles;
	}
	wait(0.5);
	self unlink();
	if(positionwouldtelefrag(s_goto.origin))
	{
		self setorigin(s_goto.origin + (randomfloatrange(-16, 16), randomfloatrange(-16, 16), 0));
	}
	else
	{
		self setorigin(s_goto.origin);
	}
	self setplayerangles(s_goto.angles);
	self enableweapons();
	self enableoffhandweapons();
	self freezecontrols(0);
	self.var_601ebf01 delete();
}

/*
	Name: function_63b428de
	Namespace: zm_genesis_arena
	Checksum: 0x519045E1
	Offset: 0xD0B8
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function function_63b428de()
{
	level flag::set("boss_rush_phase_2");
	level.var_beccbadb = 0;
	level.var_de72c885 = 0;
	level.var_c4133b63 = 4;
	level thread function_292fd4ff();
	level thread function_aa6f9476();
	level waittill(#"hash_7ea88c9e");
	level notify(#"arena_challenge_ended");
	func_cleanup = level.var_5afa678d[level.var_cbc0c05a];
	level [[func_cleanup]]();
	/#
		iprintlnbold("");
	#/
	wait(2);
	level notify(#"hash_7af29ab");
}

/*
	Name: function_aa6f9476
	Namespace: zm_genesis_arena
	Checksum: 0xDDD75668
	Offset: 0xD1B0
	Size: 0x1EE
	Parameters: 0
	Flags: Linked
*/
function function_aa6f9476()
{
	level endon(#"hash_7ea88c9e");
	while(true)
	{
		var_cecde52d = level.var_43e34f20[0];
		level thread [[var_cecde52d]](0, 0, 1, 0);
		level.var_cbc0c05a = 0;
		wait(30);
		level notify(#"arena_challenge_ended");
		func_cleanup = level.var_5afa678d[0];
		level [[func_cleanup]]();
		wait(1);
		var_cecde52d = level.var_43e34f20[3];
		level thread [[var_cecde52d]](3, 0, 1, 0);
		level.var_cbc0c05a = 3;
		wait(30);
		level notify(#"arena_challenge_ended");
		func_cleanup = level.var_5afa678d[3];
		level [[func_cleanup]]();
		wait(1);
		var_cecde52d = level.var_43e34f20[2];
		level thread [[var_cecde52d]](2, 0, 1, 0);
		level.var_cbc0c05a = 2;
		wait(30);
		level notify(#"arena_challenge_ended");
		func_cleanup = level.var_5afa678d[2];
		level [[func_cleanup]]();
		wait(1);
		var_cecde52d = level.var_43e34f20[1];
		level thread [[var_cecde52d]](1, 0, 1, 0);
		level.var_cbc0c05a = 1;
		wait(30);
		level notify(#"arena_challenge_ended");
		func_cleanup = level.var_5afa678d[1];
		level [[func_cleanup]]();
		wait(1);
	}
}

/*
	Name: function_292fd4ff
	Namespace: zm_genesis_arena
	Checksum: 0x32F2A21C
	Offset: 0xD3A8
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function function_292fd4ff()
{
	var_2da522a2 = [];
	level endon(#"hash_7ea88c9e");
	while(level.var_beccbadb < 4)
	{
		var_2da522a2 = array::remove_dead(var_2da522a2, 0);
		var_cee51300 = level.var_beccbadb - level.var_de72c885;
		if(var_cee51300 < 4)
		{
			ai = function_5a4ec2e2();
			array::add(var_2da522a2, ai, 0);
		}
		else
		{
			while(var_cee51300 >= 4)
			{
				var_cee51300 = level.var_beccbadb - level.var_de72c885;
				wait(0.5);
			}
		}
		wait(5);
	}
}

/*
	Name: function_e6146239
	Namespace: zm_genesis_arena
	Checksum: 0xFAF90706
	Offset: 0xD4A8
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function function_e6146239(s_spawnpoint, var_cbc1f143 = 0)
{
	v_origin = s_spawnpoint.origin;
	v_angles = s_spawnpoint.angles;
	if(var_cbc1f143)
	{
		zm_genesis_ai_spawning::function_1f0a0b52(v_origin);
	}
	function_439458e5(v_origin, v_angles);
}

/*
	Name: function_439458e5
	Namespace: zm_genesis_arena
	Checksum: 0x6B30694D
	Offset: 0xD558
	Size: 0x20C
	Parameters: 2
	Flags: Linked
*/
function function_439458e5(v_origin, v_angles)
{
	var_ecb2c615 = spawnactor("spawner_zm_genesis_apothicon_fury", v_origin, v_angles, undefined, 1, 1);
	if(!isdefined(var_ecb2c615))
	{
		return;
	}
	var_ecb2c615.spawn_time = gettime();
	var_ecb2c615.no_powerups = 1;
	var_ecb2c615.exclude_cleanup_adding_to_total = 1;
	var_ecb2c615.no_damage_points = 1;
	var_ecb2c615.deathpoints_already_given = 1;
	level.var_eb7b7914 = level.var_eb7b7914 + 1;
	var_ecb2c615 thread function_d0ff3ef8();
	var_ecb2c615 thread zm::update_zone_name();
	if(isdefined(var_ecb2c615))
	{
		var_ecb2c615 endon(#"death");
		level thread zm_genesis_ai_spawning::function_6cc52664(var_ecb2c615.origin);
		var_ecb2c615.voiceprefix = "fury";
		var_ecb2c615.animname = "fury";
		var_ecb2c615 thread zm_spawner::play_ambient_zombie_vocals();
		var_ecb2c615 thread zm_audio::zmbaivox_notifyconvert();
		var_ecb2c615 playsound("zmb_vocals_fury_spawn");
		var_ecb2c615.health = level.zombie_health;
		var_ecb2c615.heroweapon_kill_power = 2;
		wait(1);
		var_ecb2c615.zombie_think_done = 1;
		var_ecb2c615 ai::set_behavior_attribute("move_speed", "sprint");
	}
}

/*
	Name: function_d0ff3ef8
	Namespace: zm_genesis_arena
	Checksum: 0x8531AA17
	Offset: 0xD770
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_d0ff3ef8()
{
	self waittill(#"death");
	level.var_eb7b7914 = level.var_eb7b7914 - 1;
}

/*
	Name: function_ec36b14b
	Namespace: zm_genesis_arena
	Checksum: 0x928F6E8E
	Offset: 0xD7A0
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function function_ec36b14b(n_challenge_index)
{
	level.var_beccbadb = 0;
	level.var_de72c885 = 0;
	level clientfield::set("circle_challenge_identity", n_challenge_index);
	var_cecde52d = level.var_43e34f20[n_challenge_index];
	level thread [[var_cecde52d]](n_challenge_index, 0, 0, 1);
	level waittill(#"hash_e59686ee");
}

/*
	Name: function_11a85c29
	Namespace: zm_genesis_arena
	Checksum: 0xC91E564C
	Offset: 0xD830
	Size: 0x140
	Parameters: 1
	Flags: Linked
*/
function function_11a85c29(var_e5cba04c = 0)
{
	if(var_e5cba04c)
	{
		var_c6fda37e = struct::get_array("dark_arena_teleport_hijack", "targetname");
		for(i = 0; i < level.activeplayers.size; i++)
		{
			level.activeplayers[i] thread function_56668973(var_c6fda37e[i]);
		}
		wait(1);
		level notify(#"hash_f115a4c8");
	}
	exploder::exploder("fxexp_089");
	playsoundatposition("zmb_summoning_key_ball_spawn", (-828, -8546, -3760));
	level clientfield::set("summoning_key_pickup", 2);
	wait(3);
	level thread function_8780614b();
	level waittill(#"hash_f81a82d1");
}

/*
	Name: function_8780614b
	Namespace: zm_genesis_arena
	Checksum: 0xC2FCC135
	Offset: 0xD978
	Size: 0x1D2
	Parameters: 0
	Flags: Linked
*/
function function_8780614b()
{
	n_width = 128;
	n_height = 128;
	n_length = 128;
	s_loc = struct::get("arena_reward_pickup", "targetname");
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = n_width;
	s_loc.unitrigger_stub.script_height = n_height;
	s_loc.unitrigger_stub.script_length = n_length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_60c0ecd3;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_9307f775);
	return s_loc.unitrigger_stub;
}

/*
	Name: function_60c0ecd3
	Namespace: zm_genesis_arena
	Checksum: 0xD4739DEB
	Offset: 0xDB58
	Size: 0x86
	Parameters: 1
	Flags: Linked
*/
function function_60c0ecd3(player)
{
	var_141c477d = level clientfield::get("summoning_key_pickup");
	if(var_141c477d == 2)
	{
		self sethintstring("");
		return true;
	}
	self sethintstring("");
	return false;
}

/*
	Name: function_9307f775
	Namespace: zm_genesis_arena
	Checksum: 0x32DCF5DF
	Offset: 0xDBE8
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function function_9307f775()
{
	if(1)
	{
		for(;;)
		{
			self waittill(#"trigger", e_triggerer);
		}
		for(;;)
		{
		}
		for(;;)
		{
			var_141c477d = level clientfield::get("summoning_key_pickup");
		}
		if(e_triggerer zm_utility::in_revive_trigger())
		{
		}
		if(!zm_utility::is_player_valid(e_triggerer, 1, 1))
		{
		}
		if(var_141c477d != 2)
		{
		}
		function_1aa64a8(e_triggerer);
		level thread zm_genesis_vo::function_47713f03(e_triggerer);
		return;
	}
}

/*
	Name: function_1aa64a8
	Namespace: zm_genesis_arena
	Checksum: 0x733FE8B
	Offset: 0xDCD0
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function function_1aa64a8(e_triggerer)
{
	level clientfield::set("summoning_key_pickup", 0);
	playsoundatposition("zmb_summoning_ball_pickup", e_triggerer.origin);
	ball::function_5faeea5e(e_triggerer);
	level notify(#"hash_f81a82d1");
}

/*
	Name: function_386f30f4
	Namespace: zm_genesis_arena
	Checksum: 0x40D605F7
	Offset: 0xDD58
	Size: 0x4B4
	Parameters: 0
	Flags: Linked
*/
function function_386f30f4()
{
	if(level flag::get("final_boss_started"))
	{
		return;
	}
	level thread zm_genesis_vo::function_5f2a1c13();
	level flag::set("book_runes_success");
	level flag::set("final_boss_started");
	level thread zm_genesis_sound::function_e9341208();
	level notify(#"hash_b7da93ea");
	level notify(#"hash_f115a4c8");
	level notify(#"hash_fa713eaf");
	level clientfield::set("arena_state", 4);
	level clientfield::set("circle_state", 0);
	level clientfield::set("sophia_state", 1);
	level.var_beccbadb = 0;
	level.var_de72c885 = 0;
	level.var_c4133b63 = 2;
	level.var_42ec150d = 1;
	level.var_435967f3 = 0;
	level.var_278e37cd = 0;
	level.var_e10b491b = 2;
	level.var_2fe260b8 = 1;
	level.var_eb7b7914 = 0;
	level.var_a0135c54 = 4;
	level.var_359cfe42 = 0;
	level.var_b9b689ce = 3;
	level.var_338630d6 = 0;
	level.var_dba75e2a = 6;
	level.var_68377af0 = [];
	for(i = 0; i <= 12; i++)
	{
		level.var_d7e8c63e[i] = struct::get("boss_shadowman_4_" + i, "targetname");
	}
	for(i = 0; i < 12; i++)
	{
		n_index = randomint(12);
		s_temp = level.var_d7e8c63e[n_index];
		level.var_d7e8c63e[n_index] = level.var_d7e8c63e[i];
		level.var_d7e8c63e[i] = s_temp;
	}
	if(!isdefined(level.var_5d85ddf7))
	{
		level.var_5d85ddf7 = [];
	}
	s_loc = struct::get("boss_shadowman_4");
	level.var_5b08e991 = util::spawn_model("c_zom_dlc4_shadowman_fb", s_loc.origin, s_loc.angles);
	level.var_5b08e991 useanimtree($zm_genesis);
	level.var_5b08e991 clientfield::set("shadowman_fx", 1);
	level.var_5b08e991 playsound("zmb_shadowman_tele_in");
	level.var_5b08e991.health = 1000000;
	level.var_5b08e991 thread animation::play("ai_zm_dlc4_shadowman_idle");
	level.var_5b08e991 setcandamage(1);
	level.var_5b08e991 clientfield::set("boss_clone_fx", 2);
	level.var_5b08e991 thread function_47c38473();
	function_a295f22c();
	level thread function_fcac048f();
	level thread function_444d6737();
	thread [[ level.var_d90687be ]]->function_a1c7821d(0);
	level thread function_5c0b3137();
	level thread function_f71c240d();
}

/*
	Name: function_fcac048f
	Namespace: zm_genesis_arena
	Checksum: 0xB31D7665
	Offset: 0xE218
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_fcac048f()
{
	level.var_74f93a5e = 0;
	function_9faf5035();
	level thread final_boss_shadowman_attack_thread();
}

/*
	Name: final_boss_shadowman_attack_thread
	Namespace: zm_genesis_arena
	Checksum: 0x30A7CBCC
	Offset: 0xE260
	Size: 0x25E
	Parameters: 0
	Flags: Linked
*/
function final_boss_shadowman_attack_thread()
{
	level notify(#"final_boss_shadowman_attack_thread");
	level endon(#"final_boss_shadowman_attack_thread");
	level endon(#"final_boss_defeated");
	var_7de627cf = 5;
	var_97562c6c = 30;
	var_84b1a277 = array(0, 1, 2, 3);
	var_84b1a277 = array::randomize(var_84b1a277);
	while(!level flag::get("final_boss_defeated"))
	{
		if(level flag::get("final_boss_vulnerable"))
		{
			flag::wait_till_clear("final_boss_vulnerable");
			continue;
		}
		level.var_5b08e991 function_1a4e2d94(var_7de627cf, undefined);
		if(level flag::get("final_boss_vulnerable"))
		{
			flag::wait_till_clear("final_boss_vulnerable");
			continue;
		}
		var_e7d6a3ca = var_84b1a277[level.var_74f93a5e];
		level.var_74f93a5e = level.var_74f93a5e + 1;
		if(level.var_74f93a5e > var_84b1a277.size)
		{
			level.var_74f93a5e = 0;
			var_84b1a277 = array::randomize(var_84b1a277);
			var_e7d6a3ca = var_84b1a277[level.var_74f93a5e];
			if(var_84b1a277[0] == var_e7d6a3ca)
			{
				var_84b1a277 = array::reverse(var_84b1a277);
			}
			function_9faf5035();
		}
		function_60c23a57(var_e7d6a3ca);
		level util::waittill_any_timeout(var_97562c6c, "final_boss_defeated", "final_boss_shadowman_attack_thread");
		function_2de2733c();
		wait(15);
	}
}

/*
	Name: function_9faf5035
	Namespace: zm_genesis_arena
	Checksum: 0xD234F6A8
	Offset: 0xE4C8
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function function_9faf5035()
{
	thread [[ level.var_d90687be ]]->function_a1c7821d(0);
	thread [[ level.var_d90687be ]]->function_e4dbca5a(0);
	if(level.var_435967f3 < level.var_e10b491b)
	{
		function_2ed620e8(0);
	}
	wait(45);
}

/*
	Name: function_7b82ff07
	Namespace: zm_genesis_arena
	Checksum: 0x6B514851
	Offset: 0xE530
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function function_7b82ff07(var_b35c2422)
{
	level notify(#"hash_7b82ff07");
	level endon(#"hash_7b82ff07");
	players = arraycopy(level.activeplayers);
	foreach(player in players)
	{
		if(isdefined(player))
		{
			player clientfield::set_to_player("player_rumble_and_shake", var_b35c2422);
		}
	}
}

/*
	Name: function_1a4e2d94
	Namespace: zm_genesis_arena
	Checksum: 0xD412C431
	Offset: 0xE620
	Size: 0x2FC
	Parameters: 2
	Flags: Linked
*/
function function_1a4e2d94(n_move_duration, var_8fc8c481 = 1)
{
	level endon(#"hash_675baa5d");
	level endon(#"final_boss_defeated");
	self animation::stop();
	level thread function_7b82ff07(5);
	self clientfield::set("shadowman_fx", 3);
	self playsound("zmb_shadowman_spell_start");
	self playloopsound("zmb_shadowman_spell_loop", 0.75);
	self clearanim("ai_zm_dlc4_shadowman_idle", 0);
	self animation::play("ai_zm_dlc4_shadowman_attack_aoe_charge_intro", undefined, undefined, var_8fc8c481);
	self animation::stop();
	self clientfield::set("shadowman_fx", 4);
	self clearanim("ai_zm_dlc4_shadowman_attack_aoe_charge_intro", 0);
	self thread animation::play("ai_zm_dlc4_shadowman_attack_aoe_charge_loop", undefined, undefined, var_8fc8c481);
	wait(n_move_duration);
	level thread function_7719ec7(2.6);
	level thread function_7b82ff07(6);
	self animation::stop();
	self clientfield::set("shadowman_fx", 5);
	self stoploopsound(0.1);
	self playsound("zmb_shadowman_spell_cast");
	self clearanim("ai_zm_dlc4_shadowman_attack_aoe_charge_loop", 0);
	self animation::play("ai_zm_dlc4_shadowman_attack_aoe_charge_deploy", undefined, undefined, var_8fc8c481);
	self clientfield::set("shadowman_fx", 6);
	self clearanim("ai_zm_dlc4_shadowman_attack_aoe_charge_deploy", 0);
	self thread animation::play("ai_zm_dlc4_shadowman_idle", undefined, undefined, var_8fc8c481);
}

/*
	Name: function_47c38473
	Namespace: zm_genesis_arena
	Checksum: 0xF4BA34E
	Offset: 0xE928
	Size: 0x358
	Parameters: 0
	Flags: Linked
*/
function function_47c38473()
{
	level notify(#"hash_47c38473");
	level endon(#"hash_47c38473");
	level endon(#"final_boss_defeated");
	level.var_3ba63921 = 0;
	var_90530d3 = 0;
	while(true)
	{
		self.health = 1000000;
		self waittill(#"damage", amount, attacker, direction_vec, point, type, tagname, modelname, partname, weapon);
		if(!level flag::get("final_boss_vulnerable"))
		{
			continue;
		}
		if(isplayer(attacker))
		{
			attacker show_hit_marker();
		}
		playfx(level._effect["shadowman_impact_fx"], point);
		var_90530d3 = var_90530d3 + amount;
		n_player_count = level.activeplayers.size;
		var_d6a1b83c = 0.5 + (0.5 * ((n_player_count - 1) / 3));
		var_9bd75db5 = 2000 * var_d6a1b83c;
		if(var_90530d3 >= var_9bd75db5)
		{
			function_2de2733c();
			var_90530d3 = 0;
			level.var_3ba63921 = level.var_3ba63921 + randomintrange(1, 3);
			if(level flag::get("hope_done"))
			{
				level.var_3ba63921++;
			}
			if(level.var_3ba63921 >= 11)
			{
				level thread zm_genesis_sound::function_ecd49d9c();
			}
			if(level.var_3ba63921 >= 12)
			{
				level.var_3ba63921 = 12;
				if(level flag::get("hope_done"))
				{
					level.var_5b08e991 clientfield::set("hope_spark", 1);
				}
				level flag::set("final_boss_at_deaths_door");
			}
			self function_284b1884(level.var_d7e8c63e[level.var_3ba63921], 0.1);
			level.var_5b08e991 clientfield::set("boss_clone_fx", 1);
			level.var_5b08e991 thread function_d3b47fbf();
		}
	}
}

/*
	Name: function_d3b47fbf
	Namespace: zm_genesis_arena
	Checksum: 0xD92570FE
	Offset: 0xEC88
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_d3b47fbf()
{
	level endon(#"final_boss_vulnerable");
	level endon(#"ending_room");
	self animation::play("ai_zm_dlc4_shadowman_captured_intro", undefined, undefined, 1);
	if(isdefined(self))
	{
		self thread animation::play("ai_zm_dlc4_shadowman_captured_loop", undefined, undefined, 1);
	}
}

/*
	Name: show_hit_marker
	Namespace: zm_genesis_arena
	Checksum: 0xC935AC8A
	Offset: 0xED08
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function show_hit_marker()
{
	if(isdefined(self) && isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback setshader("damage_feedback", 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeovertime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

/*
	Name: function_1c231424
	Namespace: zm_genesis_arena
	Checksum: 0x2550A48
	Offset: 0xED98
	Size: 0x22C
	Parameters: 0
	Flags: Linked
*/
function function_1c231424()
{
	level endon(#"final_boss_defeated");
	if(!isdefined(level.var_3dc17f7b))
	{
		level.var_3dc17f7b = 1;
	}
	else
	{
		level.var_3dc17f7b = level.var_3dc17f7b + 1;
		if((level.var_3dc17f7b % 4) == 0)
		{
			level thread function_45ea8994();
		}
	}
	level.var_5b08e991 clientfield::set("boss_clone_fx", 1);
	level flag::set("final_boss_vulnerable");
	level thread function_7b82ff07(6);
	level thread function_6de6b768();
	wait(10 + (level.var_3dc17f7b * 5));
	if(level flag::get("hope_done") && level.var_3ba63921 >= 12)
	{
		wait(15);
		level.var_5b08e991 clientfield::set("hope_spark", 0);
	}
	level.var_5b08e991 clientfield::set("boss_clone_fx", 2);
	level flag::clear("final_boss_vulnerable");
	var_a8869736 = struct::get("boss_shadowman_4", "targetname");
	level.var_5b08e991 function_284b1884(var_a8869736, 0.1);
	level flag::clear("final_boss_at_deaths_door");
	level.var_3ba63921 = 0;
	function_a295f22c();
}

/*
	Name: function_6de6b768
	Namespace: zm_genesis_arena
	Checksum: 0x49BA4CAA
	Offset: 0xEFD0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_6de6b768()
{
	if(isdefined(level.var_7ec1d3f3))
	{
		return;
	}
	var_2c8e8252 = struct::get("arena_powerup_point", "targetname");
	level.var_7ec1d3f3 = level thread zm_powerups::specific_powerup_drop("full_ammo", var_2c8e8252.origin, undefined, undefined, undefined, undefined, 1);
	level flag::wait_till_clear("test_activate_arena");
	if(isdefined(level.var_7ec1d3f3))
	{
		level.var_7ec1d3f3 thread zm_powerups::powerup_delete();
	}
}

/*
	Name: function_a295f22c
	Namespace: zm_genesis_arena
	Checksum: 0xB8E228EB
	Offset: 0xF0A0
	Size: 0x340
	Parameters: 0
	Flags: Linked
*/
function function_a295f22c()
{
	level endon(#"final_boss_defeated");
	level.var_5b08e991 clearanim("ai_zm_dlc4_shadowman_idle", 0);
	level.var_5b08e991 animation::play("ai_zm_dlc4_shadowman_attack_aoe_charge_intro", undefined, undefined, 1);
	level.var_5b08e991 animation::stop();
	level thread function_7b82ff07(5);
	level.var_5b08e991 clientfield::set("shadowman_fx", 4);
	level.var_5b08e991 clearanim("ai_zm_dlc4_shadowman_attack_aoe_charge_intro", 0);
	level.var_5b08e991 thread animation::play("ai_zm_dlc4_shadowman_attack_aoe_charge_loop", undefined, undefined, 1);
	wait(1);
	level.var_5b08e991 animation::stop();
	level.var_5b08e991 clientfield::set("shadowman_fx", 5);
	level thread function_7b82ff07(6);
	level.var_5b08e991 stoploopsound(0.1);
	level.var_5b08e991 playsound("zmb_shadowman_spell_cast");
	level.var_5b08e991 clearanim("ai_zm_dlc4_shadowman_attack_aoe_charge_loop", 0);
	level.var_5b08e991 animation::play("ai_zm_dlc4_shadowman_attack_aoe_charge_deploy", undefined, undefined, 1);
	level.var_5b08e991 clientfield::set("shadowman_fx", 6);
	level.var_5b08e991 clearanim("ai_zm_dlc4_shadowman_attack_aoe_charge_deploy", 0);
	level.var_5b08e991 thread animation::play("ai_zm_dlc4_shadowman_idle", undefined, undefined, 1);
	level clientfield::set("sophia_state", 2);
	if(level.var_359cfe42 < level.var_b9b689ce)
	{
		var_bd2592aa = randomfloatrange(0, 1);
		if(var_bd2592aa < 0.25 && level.var_435967f3 < level.var_e10b491b)
		{
			function_47e5fca7();
		}
		else if(level.var_beccbadb < level.var_c4133b63)
		{
			function_67a2532f();
		}
	}
	thread [[ level.var_d90687be ]]->function_a1c7821d(0);
}

/*
	Name: function_47e5fca7
	Namespace: zm_genesis_arena
	Checksum: 0x3A5301D6
	Offset: 0xF3E8
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_47e5fca7()
{
	var_fae0d733 = struct::get_array("arena_boss_spawnpoint", "targetname");
	s_loc = array::random(var_fae0d733);
	e_ai = zm_ai_mechz::spawn_mechz(s_loc, 0);
	util::wait_network_frame();
	if(isdefined(e_ai))
	{
		e_ai.b_ignore_cleanup = 1;
		level notify(#"hash_b4c3cb33");
		level.var_435967f3 = level.var_435967f3 + 1;
		level.var_359cfe42 = level.var_359cfe42 + 1;
		e_ai thread function_ebe65636();
	}
	return e_ai;
}

/*
	Name: function_ebe65636
	Namespace: zm_genesis_arena
	Checksum: 0x567FF075
	Offset: 0xF4E8
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function function_ebe65636()
{
	self waittill(#"death");
	level.var_435967f3 = level.var_435967f3 - 1;
	level.var_359cfe42 = level.var_359cfe42 - 1;
}

/*
	Name: function_67a2532f
	Namespace: zm_genesis_arena
	Checksum: 0xE6501D96
	Offset: 0xF528
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function function_67a2532f()
{
	level.var_beccbadb = level.var_beccbadb + 1;
	level.var_359cfe42 = level.var_359cfe42 + 1;
	ai = function_5a4ec2e2();
}

/*
	Name: function_45ea8994
	Namespace: zm_genesis_arena
	Checksum: 0xC36301A9
	Offset: 0xF578
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_45ea8994()
{
	for(i = 0; i < 4; i++)
	{
		level clientfield::set("basin_state_" + i, 1);
	}
}

/*
	Name: function_284b1884
	Namespace: zm_genesis_arena
	Checksum: 0xBE71D62F
	Offset: 0xF5D0
	Size: 0x13C
	Parameters: 2
	Flags: Linked
*/
function function_284b1884(s_target, var_685eb707 = 0.1)
{
	self animation::stop();
	self clientfield::set("shadowman_fx", 2);
	self playsound("zmb_shadowman_tele_out");
	self hide();
	self.origin = s_target.origin;
	if(isdefined(s_target.angles))
	{
		self.angles = s_target.angles;
	}
	wait(var_685eb707);
	self clientfield::set("shadowman_fx", 1);
	self playsound("zmb_shadowman_tele_in");
	self show();
}

/*
	Name: function_60c23a57
	Namespace: zm_genesis_arena
	Checksum: 0xA3233BFF
	Offset: 0xF718
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_60c23a57(n_element_index)
{
	level clientfield::set("circle_challenge_identity", n_element_index);
	var_cecde52d = level.var_43e34f20[n_element_index];
	level thread [[var_cecde52d]](n_element_index, 0, 1, 0);
	level.var_cbc0c05a = n_element_index;
	thread [[ level.var_d90687be ]]->function_e4dbca5a(n_element_index);
}

/*
	Name: function_5c0b3137
	Namespace: zm_genesis_arena
	Checksum: 0xA9C77DF8
	Offset: 0xF7A8
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function function_5c0b3137()
{
	level notify(#"hash_5c0b3137");
	level endon(#"hash_5c0b3137");
	level endon(#"final_boss_defeated");
	if(!isdefined(level.var_eb7b7914))
	{
		level.var_eb7b7914 = 0;
	}
	while(true)
	{
		if(level.var_eb7b7914 < level.var_a0135c54)
		{
			var_ea9e640b = randomintrange(0, 8);
			s_spawnpoint = struct::get("arena_fury_" + var_ea9e640b, "targetname");
			level thread function_e6146239(s_spawnpoint);
			wait(randomintrange(5, 8));
		}
		else
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: function_f71c240d
	Namespace: zm_genesis_arena
	Checksum: 0xA0F3AD3
	Offset: 0xF8D8
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function function_f71c240d()
{
	level notify(#"hash_f71c240d");
	level endon(#"hash_f71c240d");
	level endon(#"final_boss_defeated");
	if(!isdefined(level.var_338630d6))
	{
		level.var_338630d6 = 0;
	}
	while(true)
	{
		if(level.var_338630d6 < level.var_dba75e2a)
		{
			var_bac4e70 = randomintrange(0, 4);
			s_spawnpoint = struct::get("arena_keeper_" + var_bac4e70, "targetname");
			level thread function_ff611187(s_spawnpoint);
			wait(3);
		}
		else
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: function_ff611187
	Namespace: zm_genesis_arena
	Checksum: 0x28A17729
	Offset: 0xF9F0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_ff611187(s_spawnpoint)
{
	v_origin = s_spawnpoint.origin;
	v_angles = s_spawnpoint.angles;
	if(!isdefined(v_angles))
	{
		v_angles = (0, 0, 0);
	}
	function_4888688f(v_origin, v_angles);
}

/*
	Name: function_4888688f
	Namespace: zm_genesis_arena
	Checksum: 0x39EBAE74
	Offset: 0xFA70
	Size: 0x1A8
	Parameters: 2
	Flags: Linked
*/
function function_4888688f(v_origin, v_angles)
{
	var_d88e6f5f = spawnactor("spawner_zm_genesis_keeper", v_origin, v_angles, undefined, 1, 1);
	if(isdefined(var_d88e6f5f))
	{
		level.var_338630d6 = level.var_338630d6 + 1;
		var_d88e6f5f.spawn_time = gettime();
		var_d88e6f5f.var_b8385ee5 = 1;
		var_d88e6f5f.health = level.zombie_health;
		var_d88e6f5f.no_powerups = 1;
		var_d88e6f5f thread zm::update_zone_name();
		var_d88e6f5f thread function_83144009();
		level thread zm_genesis_ai_spawning::function_6cc52664(var_d88e6f5f.origin);
		var_d88e6f5f.voiceprefix = "keeper";
		var_d88e6f5f.animname = "keeper";
		var_d88e6f5f thread zm_spawner::play_ambient_zombie_vocals();
		var_d88e6f5f thread zm_audio::zmbaivox_notifyconvert();
		wait(1.3);
		var_d88e6f5f.zombie_think_done = 1;
		var_d88e6f5f.heroweapon_kill_power = 2;
		var_d88e6f5f thread zombie_utility::round_spawn_failsafe();
	}
	return var_d88e6f5f;
}

/*
	Name: function_83144009
	Namespace: zm_genesis_arena
	Checksum: 0xBC6FFB44
	Offset: 0xFC20
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_83144009()
{
	self waittill(#"death");
	level.var_338630d6 = level.var_338630d6 - 1;
}

/*
	Name: function_2de2733c
	Namespace: zm_genesis_arena
	Checksum: 0x9C3F5153
	Offset: 0xFC50
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_2de2733c()
{
	n_element_index = level clientfield::get("circle_challenge_identity");
	level notify(#"arena_challenge_ended");
	func_cleanup = level.var_5afa678d[n_element_index];
	level [[func_cleanup]]();
	thread [[ level.var_d90687be ]]->function_a1c7821d(0);
}

/*
	Name: function_444d6737
	Namespace: zm_genesis_arena
	Checksum: 0xF2AA786
	Offset: 0xFCD8
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function function_444d6737()
{
	level thread function_205c3adf();
	for(i = 0; i < 4; i++)
	{
		level thread function_9c25c847(i);
	}
}

/*
	Name: function_9c25c847
	Namespace: zm_genesis_arena
	Checksum: 0xC3806B30
	Offset: 0xFD40
	Size: 0x20C
	Parameters: 1
	Flags: Linked
*/
function function_9c25c847(var_549b41ba)
{
	n_width = 128;
	n_height = 128;
	n_length = 128;
	s_loc = struct::get("clientside_key_" + var_549b41ba, "targetname");
	level clientfield::set("basin_state_" + var_549b41ba, 1);
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = n_width;
	s_loc.unitrigger_stub.script_height = n_height;
	s_loc.unitrigger_stub.script_length = n_length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.var_549b41ba = var_549b41ba;
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_5a68c25f;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_f20e5aa1);
}

/*
	Name: function_5a68c25f
	Namespace: zm_genesis_arena
	Checksum: 0xCEF8B854
	Offset: 0xFF58
	Size: 0x11E
	Parameters: 1
	Flags: Linked
*/
function function_5a68c25f(player)
{
	if(level flag::get("final_boss_defeated"))
	{
		return false;
	}
	var_c386eb4d = level clientfield::get("basin_state_" + self.stub.var_549b41ba);
	if(var_c386eb4d == 1 && level.var_2fe260b8 == 1)
	{
		self sethintstring("");
		return true;
	}
	if(var_c386eb4d == 4)
	{
		return false;
	}
	if(var_c386eb4d == 3 && level.var_2fe260b8 == 0)
	{
		self sethintstring("");
		return true;
	}
	self sethintstring("");
	return false;
}

/*
	Name: function_f20e5aa1
	Namespace: zm_genesis_arena
	Checksum: 0xFE9780ED
	Offset: 0x10080
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function function_f20e5aa1()
{
	while(true)
	{
		self waittill(#"trigger", e_triggerer);
		if(e_triggerer zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_triggerer, 1, 1))
		{
			continue;
		}
		var_c386eb4d = level clientfield::get("basin_state_" + self.stub.var_549b41ba);
		if(var_c386eb4d == 3)
		{
			level clientfield::set("basin_state_" + self.stub.var_549b41ba, 4);
			ball::function_5faeea5e(e_triggerer);
			e_triggerer playsound("zmb_finalfight_key_pickup");
			level.var_2fe260b8 = 2;
			level thread function_867f6495();
		}
		else if(var_c386eb4d == 1 && level.var_2fe260b8 == 1)
		{
			level clientfield::set("basin_state_" + self.stub.var_549b41ba, 2);
			level.var_2fe260b8 = 0;
			level.var_40ffc71d = 0;
			level thread function_4ea58c0(self.stub.var_549b41ba);
			level.var_a6e673dd = struct::get("clientside_key_" + self.stub.var_549b41ba, "targetname");
		}
		self.stub zm_unitrigger::run_visibility_function_for_all_triggers();
	}
}

/*
	Name: function_4ea58c0
	Namespace: zm_genesis_arena
	Checksum: 0x2D1CCDDE
	Offset: 0x102B0
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function function_4ea58c0(var_549b41ba)
{
	while(true)
	{
		if(level.var_40ffc71d >= 15)
		{
			level.var_a6e673dd = undefined;
			level clientfield::set("basin_state_" + var_549b41ba, 3);
			return;
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_867f6495
	Namespace: zm_genesis_arena
	Checksum: 0x113F5E6D
	Offset: 0x10328
	Size: 0x248
	Parameters: 0
	Flags: Linked
*/
function function_867f6495()
{
	level notify(#"hash_867f6495");
	level endon(#"hash_867f6495");
	level endon(#"final_boss_defeated");
	var_cb6acc3e = undefined;
	while(true)
	{
		var_46352a82 = level.ball;
		var_d6ba68c5 = var_46352a82.visuals[0];
		var_766335a0 = var_d6ba68c5.origin;
		if(isdefined(var_46352a82.carrier))
		{
			util::wait_network_frame();
			continue;
		}
		else if(isdefined(var_cb6acc3e) && var_766335a0 != var_cb6acc3e)
		{
			var_af8a18df = struct::get("boss_sophia_hover", "targetname");
			var_32769d76 = pointonsegmentnearesttopoint(var_766335a0, var_cb6acc3e, var_af8a18df.origin);
			var_bcf81f62 = var_32769d76 - var_af8a18df.origin;
			n_length = length(var_bcf81f62);
			if(n_length < 128)
			{
				level.ball thread ball::function_a41df27c();
				level thread zm_genesis_vo::function_8c5fea67(var_46352a82.lastcarrier);
				level clientfield::set("sophia_state", 3);
				level.var_2fe260b8 = 1;
				/#
					iprintlnbold("");
				#/
				level thread function_1c231424();
				return;
			}
		}
		var_cb6acc3e = var_766335a0;
		util::wait_network_frame();
	}
}

/*
	Name: function_205c3adf
	Namespace: zm_genesis_arena
	Checksum: 0xC31E2FE2
	Offset: 0x10578
	Size: 0x1D2
	Parameters: 0
	Flags: Linked
*/
function function_205c3adf()
{
	n_width = 160;
	n_height = 160;
	n_length = 160;
	s_loc = struct::get("ee_book_arena", "targetname");
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = n_width;
	s_loc.unitrigger_stub.script_height = n_height;
	s_loc.unitrigger_stub.script_length = n_length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_debdfa37;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_798c9ac9);
	return s_loc.unitrigger_stub;
}

/*
	Name: function_debdfa37
	Namespace: zm_genesis_arena
	Checksum: 0x16494F57
	Offset: 0x10758
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_debdfa37(player)
{
	if(level flag::get("final_boss_defeated"))
	{
		return false;
	}
	if(level flag::get("final_boss_at_deaths_door"))
	{
		self sethintstring("");
		return true;
	}
	return false;
}

/*
	Name: function_798c9ac9
	Namespace: zm_genesis_arena
	Checksum: 0x162CFF41
	Offset: 0x107D8
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_798c9ac9()
{
	if(1)
	{
		for(;;)
		{
			self waittill(#"trigger", e_triggerer);
		}
		for(;;)
		{
		}
		for(;;)
		{
		}
		for(;;)
		{
		}
		if(e_triggerer zm_utility::in_revive_trigger())
		{
		}
		if(!zm_utility::is_player_valid(e_triggerer, 1, 1))
		{
		}
		if(level flag::get("final_boss_defeated"))
		{
		}
		if(!level flag::get("final_boss_at_deaths_door"))
		{
		}
		level thread function_ab0e7bbf();
		return;
	}
}

/*
	Name: function_ab0e7bbf
	Namespace: zm_genesis_arena
	Checksum: 0xCE1401EE
	Offset: 0x108A8
	Size: 0x264
	Parameters: 0
	Flags: Linked
*/
function function_ab0e7bbf()
{
	var_eb26d898 = level.var_5b08e991 clientfield::get("hope_spark");
	if(var_eb26d898)
	{
		level flag::set("special_win");
	}
	level flag::set("final_boss_defeated");
	level clientfield::set("boss_beam_state", 1);
	var_87c8152d = level clientfield::get("circle_challenge_identity");
	level notify(#"arena_challenge_ended");
	func_cleanup = level.var_5afa678d[var_87c8152d];
	level thread [[func_cleanup]]();
	level flag::clear("spawn_zombies");
	level thread function_ab51bfd();
	playsoundatposition("zmb_finalfight_shadowman_die", level.var_5b08e991.origin);
	level thread zm_genesis_vo::function_dfd31c20();
	wait(3);
	level thread zm_genesis_sound::function_d73dcf42();
	playsoundatposition("zmb_shadowman_transition", (0, 0, 0));
	level lui::screen_fade_out(2, "white");
	level clientfield::set("boss_beam_state", 0);
	if(isdefined(level.var_5b08e991))
	{
		level.var_5b08e991 delete();
	}
	wait(3);
	level thread lui::screen_fade_in(2.5, "white");
	function_7fd60b47();
	level flag::set("ending_room");
}

/*
	Name: function_7fd60b47
	Namespace: zm_genesis_arena
	Checksum: 0xC8243FA6
	Offset: 0x10B18
	Size: 0x368
	Parameters: 0
	Flags: Linked
*/
function function_7fd60b47()
{
	wait(2);
	foreach(player in level.players)
	{
		scoreevents::processscoreevent("main_EE_quest_genesis", player);
		player addplayerstat("DARKOPS_GENESIS_EE", 1);
	}
	wait(2);
	var_d028d3a8 = array("ZOD", "FACTORY", "CASTLE", "ISLAND", "STALINGRAD");
	var_ce48d9bb = [];
	foreach(player in level.players)
	{
		foreach(var_1493eda1 in var_d028d3a8)
		{
			var_dc163518 = (player zm_stats::get_global_stat(("DARKOPS_" + var_1493eda1) + "_SUPER_EE")) > 0;
			if(var_dc163518)
			{
				var_ce48d9bb[var_1493eda1] = 1;
			}
		}
	}
	if(var_d028d3a8.size == var_ce48d9bb.size)
	{
		foreach(player in level.players)
		{
			var_f36c96f9 = player zm_stats::get_global_stat("DARKOPS_GENESIS_SUPER_EE") > 0;
			if(!var_f36c96f9)
			{
				player addplayerstat("DARKOPS_GENESIS_SUPER_EE", 1);
				player function_c35c1036();
			}
		}
	}
	wait(2);
	level notify(#"hash_91a3107");
	wait(2);
	if(function_43049e1e())
	{
		level notify(#"hash_154abf47");
		wait(2);
	}
}

/*
	Name: function_78325935
	Namespace: zm_genesis_arena
	Checksum: 0x4833E553
	Offset: 0x10E88
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_78325935()
{
	if(!isdefined(level.var_f0cbb403))
	{
		var_fba3cf4 = tablelookuprowcount("gamedata/tables/zm/zm_paragonRankTable.csv");
		var_4f928127 = tablelookuprow("gamedata/tables/zm/zm_paragonRankTable.csv", var_fba3cf4 - 1);
		level.var_f0cbb403 = int(var_4f928127[7]);
	}
	return level.var_f0cbb403;
}

/*
	Name: function_c35c1036
	Namespace: zm_genesis_arena
	Checksum: 0x445FA489
	Offset: 0x10F28
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function function_c35c1036()
{
	var_65bc96f9 = 1000000;
	var_b58b4125 = self zm_stats::get_global_stat("PLEVEL") == level.maxprestige;
	if(var_b58b4125)
	{
		var_4223990f = function_78325935();
		var_68756b4b = self zm_stats::get_global_stat("PARAGON_RANKXP");
	}
	else
	{
		var_4223990f = rank::getrankinfomaxxp(level.maxrank);
		var_68756b4b = self zm_stats::get_global_stat("RANKXP");
	}
	if((var_4223990f - var_68756b4b) < (1000000 * level.xpscale))
	{
		var_65bc96f9 = var_4223990f - var_68756b4b;
		var_65bc96f9 = var_65bc96f9 * (1 / level.xpscale);
	}
	self addrankxpvalue("main_ee_quest_all", int(var_65bc96f9));
	if(isdefined(level.scoreongiveplayerscore))
	{
		[[level.scoreongiveplayerscore]]("main_ee_quest_all", self, undefined, undefined, undefined);
	}
}

/*
	Name: function_43049e1e
	Namespace: zm_genesis_arena
	Checksum: 0x4D79C477
	Offset: 0x110B8
	Size: 0x246
	Parameters: 0
	Flags: Linked
*/
function function_43049e1e()
{
	var_d028d3a8 = array("ZOD", "FACTORY", "CASTLE", "ISLAND", "STALINGRAD");
	var_61d59a5a = [];
	foreach(player in level.players)
	{
		foreach(var_1493eda1 in var_d028d3a8)
		{
			var_dc163518 = (player zm_stats::get_global_stat(("DARKOPS_" + var_1493eda1) + "_SUPER_EE")) > 0;
			var_9d5e869 = isinarray(var_61d59a5a, var_1493eda1);
			if(var_dc163518 && !var_9d5e869)
			{
				if(!isdefined(var_61d59a5a))
				{
					var_61d59a5a = [];
				}
				else if(!isarray(var_61d59a5a))
				{
					var_61d59a5a = array(var_61d59a5a);
				}
				var_61d59a5a[var_61d59a5a.size] = var_1493eda1;
			}
		}
	}
	/#
		iprintlnbold(("" + var_61d59a5a.size) + "");
	#/
	if(var_61d59a5a.size == var_d028d3a8.size)
	{
		return true;
	}
	return false;
}

/*
	Name: function_ab51bfd
	Namespace: zm_genesis_arena
	Checksum: 0xDA661E28
	Offset: 0x11308
	Size: 0x1B2
	Parameters: 0
	Flags: Linked
*/
function function_ab51bfd()
{
	a_ai_enemies = getaiteamarray("axis");
	foreach(ai in a_ai_enemies)
	{
		if(isalive(ai))
		{
			ai.marked_for_death = 1;
			ai ai::set_ignoreall(1);
		}
		util::wait_network_frame();
	}
	foreach(ai in a_ai_enemies)
	{
		if(isalive(ai))
		{
			ai dodamage(ai.health + 666, ai.origin);
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_5c3f8f6b
	Namespace: zm_genesis_arena
	Checksum: 0x41849198
	Offset: 0x114C8
	Size: 0x1AA
	Parameters: 0
	Flags: None
*/
function function_5c3f8f6b()
{
	if(!isdefined(level.var_977b6d5b))
	{
		return;
	}
	a_ai = level.var_977b6d5b;
	var_52ec51cb = [];
	foreach(ai in a_ai)
	{
		if(!isdefined(ai))
		{
			continue;
		}
		if(isdefined(ai.marked_for_death) && ai.marked_for_death)
		{
			continue;
		}
		ai.marked_for_death = 1;
		ai.nuked = 1;
		var_52ec51cb[var_52ec51cb.size] = ai;
	}
	foreach(var_c427066b in var_52ec51cb)
	{
		if(!isdefined(var_c427066b))
		{
			continue;
		}
		var_c427066b kill();
	}
}

/*
	Name: function_c1402204
	Namespace: zm_genesis_arena
	Checksum: 0x204AE52C
	Offset: 0x11680
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_c1402204()
{
	level flag::init("rift_entrance_open");
	level thread function_4b9028e6();
}

/*
	Name: function_4b9028e6
	Namespace: zm_genesis_arena
	Checksum: 0xA20BB630
	Offset: 0x116C8
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function function_4b9028e6()
{
	level endon(#"grand_tour");
	level.var_b1b99f8d = [];
	level waittill(#"book_placed");
	var_c0132a00 = getent("rift_entrance_rune_portal", "targetname");
	while(true)
	{
		if(function_64d5ef9() && level.var_b1b99f8d.size >= 4)
		{
			var_12e29d53 = array::get_all_closest(var_c0132a00.origin, level.activeplayers, undefined, undefined, 84);
			if(var_12e29d53.size == level.activeplayers.size)
			{
				level flag::set("rift_entrance_open");
				function_ceedfe1c();
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_ceedfe1c
	Namespace: zm_genesis_arena
	Checksum: 0xDE3A3331
	Offset: 0x117E0
	Size: 0x2A4
	Parameters: 0
	Flags: Linked
*/
function function_ceedfe1c()
{
	a_s_port_locs = [];
	for(i = 0; i < 4; i++)
	{
		s_point = struct::get("arena_entrance_point_" + i, "targetname");
		if(!isdefined(a_s_port_locs))
		{
			a_s_port_locs = [];
		}
		else if(!isarray(a_s_port_locs))
		{
			a_s_port_locs = array(a_s_port_locs);
		}
		a_s_port_locs[a_s_port_locs.size] = s_point;
	}
	zm_genesis_util::function_342295d8("dark_arena2_zone");
	zm_genesis_util::function_342295d8("dark_arena_zone");
	a_players = arraycopy(level.activeplayers);
	foreach(player in a_players)
	{
		if(isdefined(player.b_teleporting) && player.b_teleporting)
		{
			continue;
		}
		if(isplayer(player))
		{
			player setstance("stand");
			playfx(level._effect["portal_3p"], player.origin);
			player playlocalsound("zmb_teleporter_teleport_2d");
			playsoundatposition("zmb_teleporter_teleport_out", player.origin);
			self thread function_14c1c18d(player, a_s_port_locs, 3);
		}
	}
	wait(3);
	level thread function_32419cfe();
}

/*
	Name: function_64d5ef9
	Namespace: zm_genesis_arena
	Checksum: 0xE7C031D2
	Offset: 0x11A90
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_64d5ef9()
{
	return !level flag::get("book_runes_in_progress") && !level flag::get("book_runes_failed") && !level flag::get("book_runes_success");
}

/*
	Name: function_b1e065cd
	Namespace: zm_genesis_arena
	Checksum: 0x18B46C83
	Offset: 0x11B00
	Size: 0x2EC
	Parameters: 0
	Flags: Linked
*/
function function_b1e065cd()
{
	var_e9469e74 = 0;
	a_s_port_locs = [];
	var_edface0 = 3;
	while(!var_e9469e74)
	{
		foreach(e_player in level.activeplayers)
		{
			if(e_player flag::get("has_ball"))
			{
				var_e9469e74 = 1;
				e_player waittill(#"weapon_change_complete");
			}
		}
		wait(0.1);
	}
	wait(1);
	for(i = 0; i < 4; i++)
	{
		s_point = struct::get("arena_exit_point_" + i, "targetname");
		if(!isdefined(a_s_port_locs))
		{
			a_s_port_locs = [];
		}
		else if(!isarray(a_s_port_locs))
		{
			a_s_port_locs = array(a_s_port_locs);
		}
		a_s_port_locs[a_s_port_locs.size] = s_point;
	}
	foreach(e_portee in level.players)
	{
		if(!isalive(e_portee))
		{
			continue;
		}
		playfx(level._effect["portal_3p"], e_portee.origin);
		e_portee playlocalsound("zmb_teleporter_teleport_2d");
		playsoundatposition("zmb_teleporter_teleport_out", e_portee.origin);
		self thread function_14c1c18d(e_portee, a_s_port_locs, var_edface0);
	}
	level flag::clear("arena_occupied_by_player");
}

/*
	Name: function_79a1b871
	Namespace: zm_genesis_arena
	Checksum: 0x7CA418DD
	Offset: 0x11DF8
	Size: 0x16C
	Parameters: 1
	Flags: None
*/
function function_79a1b871(e_triggerer)
{
	var_87c8152d = level clientfield::get("circle_challenge_identity");
	a_s_port_locs = [];
	s_point = struct::get("arena_reward_exit_point_" + var_87c8152d, "targetname");
	if(!isdefined(a_s_port_locs))
	{
		a_s_port_locs = [];
	}
	else if(!isarray(a_s_port_locs))
	{
		a_s_port_locs = array(a_s_port_locs);
	}
	a_s_port_locs[a_s_port_locs.size] = s_point;
	level function_14c1c18d(e_triggerer, a_s_port_locs, 3);
	wait(0.2);
	level.var_abc41d2[var_87c8152d] notify(#"trigger", e_triggerer);
	wait(0.1);
	w_current = e_triggerer getcurrentweapon();
	e_triggerer givemaxammo(w_current);
}

/*
	Name: function_14c1c18d
	Namespace: zm_genesis_arena
	Checksum: 0x9730EA30
	Offset: 0x11F70
	Size: 0x844
	Parameters: 4
	Flags: Linked
*/
function function_14c1c18d(player, a_s_port_locs, var_edface0, show_fx = 1)
{
	player endon(#"disconnect");
	player.b_teleporting = 1;
	player.teleport_location = player.origin;
	player zm_utility::create_streamer_hint(a_s_port_locs[0].origin, a_s_port_locs[0].angles, 1);
	if(show_fx)
	{
		player clientfield::set_to_player("player_shadowman_teleport_hijack_fx", 1);
	}
	n_pos = player.characterindex;
	prone_offset = vectorscale((0, 0, 1), 49);
	crouch_offset = vectorscale((0, 0, 1), 20);
	stand_offset = (0, 0, 0);
	image_room = struct::get("teleport_room_" + n_pos, "targetname");
	var_d9543609 = undefined;
	if(player hasweapon(level.ballweapon))
	{
		var_d9543609 = player.carryobject;
	}
	player disableoffhandweapons();
	player disableweapons();
	player freezecontrols(1);
	util::wait_network_frame();
	if(player getstance() == "prone")
	{
		desired_origin = image_room.origin + prone_offset;
	}
	else
	{
		if(player getstance() == "crouch")
		{
			desired_origin = image_room.origin + crouch_offset;
		}
		else
		{
			desired_origin = image_room.origin + stand_offset;
		}
	}
	player.teleport_origin = spawn("script_model", player.origin);
	player.teleport_origin setmodel("tag_origin");
	player.teleport_origin.angles = player.angles;
	player playerlinktoabsolute(player.teleport_origin, "tag_origin");
	player.teleport_origin.origin = desired_origin;
	player.teleport_origin.angles = image_room.angles;
	util::wait_network_frame();
	player.teleport_origin.angles = image_room.angles;
	wait(var_edface0);
	level flag::clear("arena_occupied_by_player");
	if(show_fx)
	{
		player clientfield::set_to_player("player_shadowman_teleport_hijack_fx", 0);
	}
	a_players = getplayers();
	arrayremovevalue(a_players, player);
	s_pos = a_s_port_locs[player.characterindex];
	playfx(level._effect["portal_3p"], s_pos.origin);
	player unlink();
	playsoundatposition("zmb_teleporter_teleport_in", s_pos.origin);
	if(isdefined(player.teleport_origin))
	{
		player.teleport_origin delete();
		player.teleport_origin = undefined;
	}
	player setorigin(s_pos.origin);
	player setplayerangles(s_pos.angles);
	player.zone_name = player zm_utility::get_current_zone();
	if([[ level.var_d90687be ]]->function_2a75673(player))
	{
		[[ level.var_d90687be ]]->function_ea39787e(player);
	}
	a_ai = getaiarray();
	a_aoe_ai = arraysortclosest(a_ai, s_pos.origin, a_ai.size, 0, 200);
	foreach(ai in a_aoe_ai)
	{
		if(isactor(ai))
		{
			if(ai.archetype === "zombie")
			{
				playfx(level._effect["beast_return_aoe_kill"], ai gettagorigin("j_spineupper"));
			}
			else
			{
				playfx(level._effect["beast_return_aoe_kill"], ai.origin);
			}
			ai.marked_for_recycle = 1;
			ai.has_been_damaged_by_player = 0;
			ai.deathpoints_already_given = 1;
			ai.no_powerups = 1;
			ai dodamage(ai.health + 1000, s_pos.origin, player);
		}
	}
	player enableweapons();
	player enableoffhandweapons();
	player freezecontrols(level.intermission);
	wait(0.05);
	if(isdefined(var_d9543609))
	{
		wait(0.05);
		var_d9543609 ball::reset_ball(0, s_pos.origin);
	}
	player.b_teleporting = 0;
}

/*
	Name: function_44d21c21
	Namespace: zm_genesis_arena
	Checksum: 0x44C9A24C
	Offset: 0x127C0
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function function_44d21c21(b_on)
{
	e_bridge = getent("arena_bridge_center", "targetname");
	if(b_on)
	{
		e_bridge.is_on = 1;
		e_bridge moveto(e_bridge.v_start, 0.01);
		e_bridge show();
		e_bridge connectpaths();
	}
	else
	{
		e_bridge.is_on = 0;
		e_bridge ghost();
		e_bridge moveto(e_bridge.v_start - vectorscale((0, 0, 1), 1000), 0.01);
		e_bridge disconnectpaths();
	}
}

/*
	Name: function_f2c00181
	Namespace: zm_genesis_arena
	Checksum: 0x61D5141E
	Offset: 0x128F0
	Size: 0xB2
	Parameters: 0
	Flags: None
*/
function function_f2c00181()
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
		level thread function_adbf2990(self.stub, player);
		level notify(#"hash_6e3ae83");
		break;
	}
}

/*
	Name: function_adbf2990
	Namespace: zm_genesis_arena
	Checksum: 0xE243B670
	Offset: 0x129B0
	Size: 0x3C2
	Parameters: 2
	Flags: Linked
*/
function function_adbf2990(trig_stub, player)
{
	if(player.gravityspikes_state == 0)
	{
		wpn_gravityspikes = getweapon("hero_gravityspikes_melee");
		player zm_weapons::weapon_give(wpn_gravityspikes, 0, 1);
		player thread zm_equipment::show_hint_text(&"ZM_GENESIS_GRAVITYSPIKE_USE_HINT", 3);
		player gadgetpowerset(player gadgetgetslot(wpn_gravityspikes), 100);
		player zm_weap_gravityspikes::update_gravityspikes_state(2);
	}
	a_s_port_locs = [];
	for(i = 0; i < 4; i++)
	{
		s_point = struct::get("arena_exit_point_" + i, "targetname");
		if(!isdefined(a_s_port_locs))
		{
			a_s_port_locs = [];
		}
		else if(!isarray(a_s_port_locs))
		{
			a_s_port_locs = array(a_s_port_locs);
		}
		a_s_port_locs[a_s_port_locs.size] = s_point;
	}
	foreach(e_player in level.activeplayers)
	{
		if([[ level.var_d90687be ]]->function_2a75673(e_player))
		{
			playfx(level._effect["portal_3p"], e_player.origin);
			e_player playlocalsound("zmb_teleporter_teleport_2d");
			playsoundatposition("zmb_teleporter_teleport_out", e_player.origin);
			if(e_player == self)
			{
				var_87c8152d = level clientfield::get("circle_challenge_identity");
				var_c93fda2c = [];
				s_point = struct::get("arena_reward_exit_point_" + var_87c8152d, "targetname");
				if(!isdefined(var_c93fda2c))
				{
					var_c93fda2c = [];
				}
				else if(!isarray(var_c93fda2c))
				{
					var_c93fda2c = array(var_c93fda2c);
				}
				var_c93fda2c[var_c93fda2c.size] = s_point;
				level thread function_14c1c18d(e_player, var_c93fda2c, 3);
				continue;
			}
			level thread function_14c1c18d(e_player, a_s_port_locs, 3);
		}
	}
}

/*
	Name: function_39df21f9
	Namespace: zm_genesis_arena
	Checksum: 0x53849472
	Offset: 0x12D80
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_39df21f9()
{
	level endon(#"hash_6760e3ae");
	level clientfield::set("arena_timeout_warning", 1);
	wait(6);
	level thread function_6cc51202();
}

/*
	Name: function_6cc51202
	Namespace: zm_genesis_arena
	Checksum: 0x93087961
	Offset: 0x12DD0
	Size: 0x2CC
	Parameters: 0
	Flags: Linked
*/
function function_6cc51202()
{
	level notify(#"arena_challenge_ended");
	a_s_port_locs = [];
	for(i = 0; i < 4; i++)
	{
		s_point = struct::get("arena_exit_point_" + i, "targetname");
		if(!isdefined(a_s_port_locs))
		{
			a_s_port_locs = [];
		}
		else if(!isarray(a_s_port_locs))
		{
			a_s_port_locs = array(a_s_port_locs);
		}
		a_s_port_locs[a_s_port_locs.size] = s_point;
	}
	a_players = arraycopy(level.activeplayers);
	foreach(e_player in a_players)
	{
		if([[ level.var_d90687be ]]->function_2a75673(e_player))
		{
			playfx(level._effect["portal_3p"], e_player.origin);
			e_player playlocalsound("zmb_teleporter_teleport_2d");
			playsoundatposition("zmb_teleporter_teleport_out", e_player.origin);
			level thread function_14c1c18d(e_player, a_s_port_locs, 3);
		}
	}
	level clientfield::set("arena_timeout_warning", 0);
	level flag::clear("arena_occupied_by_player");
	level flag::set("book_runes_failed");
	level flag::clear("rift_entrance_open");
	level waittill(#"start_of_round");
	level flag::clear("book_runes_failed");
}

/*
	Name: function_3745c6c8
	Namespace: zm_genesis_arena
	Checksum: 0xF590948A
	Offset: 0x130A8
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function function_3745c6c8()
{
	/#
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_506d0aab);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_db4e54c1);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_5addbab1);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_4f66f424);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_e4990d03);
		level thread zm_genesis_util::setup_devgui_func("", "", 2, &function_e4990d03);
		level thread zm_genesis_util::setup_devgui_func("", "", 3, &function_e4990d03);
	#/
}

/*
	Name: function_e4990d03
	Namespace: zm_genesis_arena
	Checksum: 0xEEA1A02C
	Offset: 0x13248
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function function_e4990d03(n_val)
{
	/#
		function_5addbab1(n_val);
		util::wait_network_frame();
		function_db4e54c1(n_val);
		util::wait_network_frame();
		function_506d0aab(n_val);
		util::wait_network_frame();
		switch(n_val)
		{
			case 1:
			{
				break;
			}
			case 2:
			{
				level thread zm_devgui::zombie_devgui_goto_round(6);
				break;
			}
			case 3:
			{
				level thread zm_devgui::zombie_devgui_goto_round(13);
				break;
			}
		}
	#/
}

/*
	Name: function_506d0aab
	Namespace: zm_genesis_arena
	Checksum: 0x4D2D1CE7
	Offset: 0x13340
	Size: 0x1C2
	Parameters: 1
	Flags: Linked
*/
function function_506d0aab(n_val)
{
	/#
		var_f52163c3 = array(0, 1, 2, 3, 5, 4);
		foreach(var_f4121fa3 in var_f52163c3)
		{
			level thread function_c4923f72(var_f4121fa3);
		}
		level thread zm_devgui::zombie_devgui_open_sesame();
		util::wait_network_frame();
		level thread function_4f66f424(n_val);
		util::wait_network_frame();
		foreach(e_player in level.activeplayers)
		{
			e_player disableinvulnerability();
			e_player thread zm_devgui::zombie_devgui_equipment_give("");
		}
	#/
}

/*
	Name: function_4f66f424
	Namespace: zm_genesis_arena
	Checksum: 0x7152032
	Offset: 0x13510
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function function_4f66f424(n_val)
{
	/#
		players = level.activeplayers;
		for(i = 0; i < players.size; i++)
		{
			s_teleport = struct::get("" + i, "");
			players[i] setorigin(s_teleport.origin);
			players[i].angles = s_teleport.angles;
		}
	#/
}

/*
	Name: function_5addbab1
	Namespace: zm_genesis_arena
	Checksum: 0xA9CBF263
	Offset: 0x135F0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_5addbab1(n_val)
{
	/#
		setdvar("", "");
		wait(1);
		setdvar("", "");
		wait(1);
		setdvar("", "");
	#/
}

/*
	Name: function_db4e54c1
	Namespace: zm_genesis_arena
	Checksum: 0xAB329635
	Offset: 0x13680
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_db4e54c1(n_val)
{
	/#
		array::thread_all(level.activeplayers, &zm_utility::give_player_all_perks);
	#/
}

/*
	Name: function_cc5cac5f
	Namespace: zm_genesis_arena
	Checksum: 0xF2720EA2
	Offset: 0x136C8
	Size: 0xB0C
	Parameters: 0
	Flags: Linked
*/
function function_cc5cac5f()
{
	/#
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_c4923f72);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_c4923f72);
		level thread zm_genesis_util::setup_devgui_func("", "", 2, &function_c4923f72);
		level thread zm_genesis_util::setup_devgui_func("", "", 3, &function_c4923f72);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_251f28c);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_251f28c);
		level thread zm_genesis_util::setup_devgui_func("", "", 2, &function_251f28c);
		level thread zm_genesis_util::setup_devgui_func("", "", 3, &function_251f28c);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_871092c9);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_871092c9);
		level thread zm_genesis_util::setup_devgui_func("", "", 2, &function_871092c9);
		level thread zm_genesis_util::setup_devgui_func("", "", 4, &function_871092c9);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_59d78fe0);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_59d78fe0);
		level thread zm_genesis_util::setup_devgui_func("", "", 2, &function_59d78fe0);
		level thread zm_genesis_util::setup_devgui_func("", "", 3, &function_59d78fe0);
		level thread zm_genesis_util::setup_devgui_func("", "", 4, &function_59d78fe0);
		level thread zm_genesis_util::setup_devgui_func("", "", 5, &function_59d78fe0);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_9efa2460);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_9efa2460);
		level thread zm_genesis_util::setup_devgui_func("", "", 2, &function_9efa2460);
		level thread zm_genesis_util::setup_devgui_func("", "", 3, &function_9efa2460);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_10d73de7);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_3e3aa4a2);
		level thread zm_genesis_util::setup_devgui_func("", "", 2, &function_3e3aa4a2);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_88f1ee45);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_88f1ee45);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_ef5cc959);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_7104ee61);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_bc5b95af);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_bc5b95af);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_fe9efe30);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_fe9efe30);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_8a771d77);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_8a771d77);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_82a40293);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_82a40293);
		level thread zm_genesis_util::setup_devgui_func("", "", 2, &function_ce0fad48);
		level thread zm_genesis_util::setup_devgui_func("", "", 3, &function_ce0fad48);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_11f7a042);
		level thread zm_genesis_util::setup_devgui_func("", "", 2, &function_11f7a042);
		level thread zm_genesis_util::setup_devgui_func("", "", 3, &function_11f7a042);
		level thread zm_genesis_util::setup_devgui_func("", "", 4, &function_11f7a042);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_4e3a221e);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_f8dfefdd);
		level thread zm_genesis_util::setup_devgui_func("", "", 0, &function_f8dfefdd);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_1189737f);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_4dd54050);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_cdccd485);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_995cb46);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_3cf095ce);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_60a02f3a);
	#/
}

/*
	Name: function_60a02f3a
	Namespace: zm_genesis_arena
	Checksum: 0x7D84B156
	Offset: 0x141E0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_60a02f3a(n_val)
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_cdccd485
	Namespace: zm_genesis_arena
	Checksum: 0xCC344BA6
	Offset: 0x14218
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_cdccd485(n_val)
{
	/#
		level thread function_b1b0d2b0();
	#/
}

/*
	Name: function_10d73de7
	Namespace: zm_genesis_arena
	Checksum: 0xE16BEC00
	Offset: 0x14248
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_10d73de7(n_val)
{
	/#
		level flag::set("");
		level thread function_c2578b2a();
	#/
}

/*
	Name: function_4dd54050
	Namespace: zm_genesis_arena
	Checksum: 0x8F0F58A1
	Offset: 0x14298
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function function_4dd54050(n_val)
{
	/#
		var_83d6000c = struct::get_array("", "");
		foreach(var_59b850ac in var_83d6000c)
		{
			playfx(level._effect[""], var_59b850ac.origin);
		}
	#/
}

/*
	Name: function_88f1ee45
	Namespace: zm_genesis_arena
	Checksum: 0x8A95B106
	Offset: 0x14388
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_88f1ee45(n_val)
{
	/#
		iprintlnbold("");
		if(n_val > 0)
		{
			function_44d21c21(1);
		}
		else
		{
			function_44d21c21(0);
		}
	#/
}

/*
	Name: function_11f7a042
	Namespace: zm_genesis_arena
	Checksum: 0xE3D6008C
	Offset: 0x143F8
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_11f7a042(n_val)
{
	/#
		switch(n_val)
		{
			case 1:
			{
				level.var_c4133b63 = 1;
				break;
			}
			case 2:
			{
				level.var_c4133b63 = 3;
				break;
			}
			case 3:
			{
				level.var_c4133b63 = 10;
				break;
			}
			case 4:
			{
				level.var_c4133b63 = 20;
				break;
			}
		}
		iprintlnbold("" + level.var_c4133b63);
	#/
}

/*
	Name: function_c4923f72
	Namespace: zm_genesis_arena
	Checksum: 0xEA361929
	Offset: 0x144A8
	Size: 0xDE
	Parameters: 1
	Flags: Linked
*/
function function_c4923f72(var_87c8152d)
{
	/#
		switch(var_87c8152d)
		{
			case 0:
			{
				level.activeplayers[0] zm_genesis_util::function_bb26d959(2);
				break;
			}
			case 1:
			{
				level.activeplayers[0] zm_genesis_util::function_bb26d959(3);
				break;
			}
			case 2:
			{
				level.activeplayers[0] zm_genesis_util::function_bb26d959(1);
				break;
			}
			case 3:
			{
				level.activeplayers[0] zm_genesis_util::function_bb26d959(0);
				break;
			}
		}
	#/
}

/*
	Name: function_251f28c
	Namespace: zm_genesis_arena
	Checksum: 0xAD4F41DC
	Offset: 0x14590
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_251f28c(var_87c8152d)
{
	/#
		var_5a2492d5 = function_6ab2d662(var_87c8152d);
		str_flag_name = var_5a2492d5 + "";
		level flag::clear(str_flag_name);
	#/
}

/*
	Name: function_871092c9
	Namespace: zm_genesis_arena
	Checksum: 0x6C3E93FD
	Offset: 0x14600
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_871092c9(n_val)
{
	/#
		level clientfield::set("", n_val);
	#/
}

/*
	Name: function_59d78fe0
	Namespace: zm_genesis_arena
	Checksum: 0x17DAAC21
	Offset: 0x14640
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_59d78fe0(n_val)
{
	/#
		level clientfield::set("", n_val);
	#/
}

/*
	Name: function_9efa2460
	Namespace: zm_genesis_arena
	Checksum: 0xFAEEB4B8
	Offset: 0x14680
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_9efa2460(n_val)
{
	/#
		level notify(#"hash_6760e3ae");
		function_6a03c1d4(n_val, level.var_f98b3213);
	#/
}

/*
	Name: function_ce0fad48
	Namespace: zm_genesis_arena
	Checksum: 0x3CAF4812
	Offset: 0x146C8
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function function_ce0fad48(n_val)
{
	/#
		if(n_val == 2)
		{
			self.var_e3b39dfc = 1;
			level.var_dbc3a0ef notify(#"hash_c7ccf077");
			level.var_42e19a0b = 2;
			level.var_dbc3a0ef.var_f60bc0ed = 2;
		}
		else if(n_val == 3)
		{
			self.var_e3b39dfc = 1;
			level.var_dbc3a0ef notify(#"hash_c7ccf077");
			level.var_dbc3a0ef notify(#"hash_a1ca760e");
			level.var_42e19a0b = 3;
			level.var_dbc3a0ef.var_f60bc0ed = 4;
		}
	#/
}

/*
	Name: function_f8dfefdd
	Namespace: zm_genesis_arena
	Checksum: 0x3F38E044
	Offset: 0x14798
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_f8dfefdd(n_val)
{
	/#
		if(n_val > 0)
		{
			level flag::set("");
		}
		else
		{
			level flag::clear("");
		}
	#/
}

/*
	Name: function_1189737f
	Namespace: zm_genesis_arena
	Checksum: 0x34ED7669
	Offset: 0x14800
	Size: 0x12A
	Parameters: 1
	Flags: Linked
*/
function function_1189737f(n_val)
{
	/#
		players = level.activeplayers;
		foreach(player in players)
		{
			var_8e5264b2 = struct::get("" + player.characterindex, "");
			player setorigin(var_8e5264b2.origin);
			player setplayerangles(var_8e5264b2.angles);
			[[ level.var_d90687be ]]->function_ea39787e(player);
		}
	#/
}

/*
	Name: function_ef5cc959
	Namespace: zm_genesis_arena
	Checksum: 0x850F44E8
	Offset: 0x14938
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_ef5cc959(n_val)
{
	/#
		level flag::set("");
		function_6a03c1d4(0, level.var_f98b3213);
	#/
}

/*
	Name: function_7104ee61
	Namespace: zm_genesis_arena
	Checksum: 0x4C7D147E
	Offset: 0x14990
	Size: 0x3BC
	Parameters: 1
	Flags: Linked
*/
function function_7104ee61(n_val)
{
	/#
		var_7f5d5c6 = [];
		if(!isdefined(var_7f5d5c6))
		{
			var_7f5d5c6 = [];
		}
		else if(!isarray(var_7f5d5c6))
		{
			var_7f5d5c6 = array(var_7f5d5c6);
		}
		var_7f5d5c6[var_7f5d5c6.size] = "";
		if(!isdefined(var_7f5d5c6))
		{
			var_7f5d5c6 = [];
		}
		else if(!isarray(var_7f5d5c6))
		{
			var_7f5d5c6 = array(var_7f5d5c6);
		}
		var_7f5d5c6[var_7f5d5c6.size] = "";
		if(!isdefined(var_7f5d5c6))
		{
			var_7f5d5c6 = [];
		}
		else if(!isarray(var_7f5d5c6))
		{
			var_7f5d5c6 = array(var_7f5d5c6);
		}
		var_7f5d5c6[var_7f5d5c6.size] = "";
		if(!isdefined(var_7f5d5c6))
		{
			var_7f5d5c6 = [];
		}
		else if(!isarray(var_7f5d5c6))
		{
			var_7f5d5c6 = array(var_7f5d5c6);
		}
		var_7f5d5c6[var_7f5d5c6.size] = "";
		if(!isdefined(var_7f5d5c6))
		{
			var_7f5d5c6 = [];
		}
		else if(!isarray(var_7f5d5c6))
		{
			var_7f5d5c6 = array(var_7f5d5c6);
		}
		var_7f5d5c6[var_7f5d5c6.size] = "";
		if(!isdefined(var_7f5d5c6))
		{
			var_7f5d5c6 = [];
		}
		else if(!isarray(var_7f5d5c6))
		{
			var_7f5d5c6 = array(var_7f5d5c6);
		}
		var_7f5d5c6[var_7f5d5c6.size] = "";
		if(!isdefined(var_7f5d5c6))
		{
			var_7f5d5c6 = [];
		}
		else if(!isarray(var_7f5d5c6))
		{
			var_7f5d5c6 = array(var_7f5d5c6);
		}
		var_7f5d5c6[var_7f5d5c6.size] = "";
		foreach(str_flag in var_7f5d5c6)
		{
			if(math::cointoss())
			{
				level flag::set("" + str_flag);
				continue;
			}
			level flag::clear("" + str_flag);
		}
		level flag::set("");
		function_6a03c1d4(0, level.var_f98b3213);
	#/
}

/*
	Name: function_9bc9cf70
	Namespace: zm_genesis_arena
	Checksum: 0x2A678C21
	Offset: 0x14D58
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function function_9bc9cf70(str_msg, n_val)
{
	/#
		if(n_val > 0)
		{
			iprintlnbold(str_msg + "");
		}
		else
		{
			iprintlnbold(str_msg + "");
		}
	#/
}

/*
	Name: function_bc5b95af
	Namespace: zm_genesis_arena
	Checksum: 0x709D0D7B
	Offset: 0x14DD0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_bc5b95af(n_val)
{
	/#
		level flag::set("");
		function_9bc9cf70("", n_val);
	#/
}

/*
	Name: function_fe9efe30
	Namespace: zm_genesis_arena
	Checksum: 0x1AB632EF
	Offset: 0x14E28
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_fe9efe30(n_val)
{
	/#
		level flag::set("");
		function_9bc9cf70("", n_val);
	#/
}

/*
	Name: function_8a771d77
	Namespace: zm_genesis_arena
	Checksum: 0x80CB2ABD
	Offset: 0x14E80
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_8a771d77(n_val)
{
	/#
		level flag::set("");
		function_9bc9cf70("", n_val);
	#/
}

/*
	Name: function_82a40293
	Namespace: zm_genesis_arena
	Checksum: 0xC8FBFB17
	Offset: 0x14ED8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_82a40293(n_val)
{
	/#
		level flag::set("");
		function_9bc9cf70("", n_val);
	#/
}

/*
	Name: function_d968aba8
	Namespace: zm_genesis_arena
	Checksum: 0xAFA74EDA
	Offset: 0x14F30
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function function_d968aba8(n_val)
{
	/#
		level flag::set("");
		function_9bc9cf70("", n_val);
	#/
}

/*
	Name: function_9808fea3
	Namespace: zm_genesis_arena
	Checksum: 0x4DB7E293
	Offset: 0x14F88
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function function_9808fea3(n_val)
{
	/#
		level flag::set("");
		function_9bc9cf70("", n_val);
	#/
}

/*
	Name: function_23d9750e
	Namespace: zm_genesis_arena
	Checksum: 0x244309E5
	Offset: 0x14FE0
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function function_23d9750e(n_val)
{
	/#
		level flag::set("");
		function_9bc9cf70("", n_val);
	#/
}

/*
	Name: function_4e3a221e
	Namespace: zm_genesis_arena
	Checksum: 0x38A920C3
	Offset: 0x15038
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function function_4e3a221e(n_val)
{
	/#
		level.var_f98b3213 = n_val;
	#/
}

/*
	Name: function_3e3aa4a2
	Namespace: zm_genesis_arena
	Checksum: 0xAC68F1C1
	Offset: 0x15060
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_3e3aa4a2(n_val)
{
	/#
		if(n_val == 1)
		{
			level thread function_655271b9();
		}
		else if(n_val == 2)
		{
			level notify(#"hash_f115a4c8");
			level clientfield::set("", 2);
			level clientfield::set("", 3);
			level thread function_63b428de();
		}
	#/
}

/*
	Name: function_995cb46
	Namespace: zm_genesis_arena
	Checksum: 0x3936B7EB
	Offset: 0x15118
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_995cb46(n_val)
{
	/#
		level thread function_386f30f4();
	#/
}

/*
	Name: function_3cf095ce
	Namespace: zm_genesis_arena
	Checksum: 0x2A82F5B7
	Offset: 0x15148
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_3cf095ce(n_val)
{
	/#
		if(isdefined(level.var_5b08e991))
		{
			level thread function_205c3adf();
			level function_ab0e7bbf();
		}
	#/
}

