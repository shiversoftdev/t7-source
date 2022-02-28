// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\voice\voice_prologue;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\weapons_shared;

#namespace cp_prologue_util;

/*
	Name: give_max_ammo
	Namespace: cp_prologue_util
	Checksum: 0x78E1AAAB
	Offset: 0x638
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function give_max_ammo()
{
	a_w_weapons = self getweaponslist();
	foreach(w_weapon in a_w_weapons)
	{
		self givemaxammo(w_weapon);
		self setweaponammoclip(w_weapon, w_weapon.clipsize);
	}
}

/*
	Name: function_b50f5d52
	Namespace: cp_prologue_util
	Checksum: 0xC2501119
	Offset: 0x720
	Size: 0x112
	Parameters: 1
	Flags: Linked
*/
function function_b50f5d52(var_76cb0c72 = 0)
{
	a_ai_enemies = getaiteamarray("axis");
	foreach(ai_enemy in a_ai_enemies)
	{
		if(isalive(ai_enemy))
		{
			if(var_76cb0c72)
			{
				ai_enemy ai::bloody_death(randomfloat(0.25));
				continue;
			}
			ai_enemy delete();
		}
	}
}

/*
	Name: function_2f943869
	Namespace: cp_prologue_util
	Checksum: 0xB46E4171
	Offset: 0x840
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_2f943869()
{
	self endon(#"death");
	wait(randomfloatrange(0.1, 0.6));
	self vehicle::get_out();
	if(isdefined(self.script_noteworthy))
	{
		self setgoal(getnode(self.script_noteworthy, "targetname"), 1);
	}
}

/*
	Name: base_alarm_goes_off
	Namespace: cp_prologue_util
	Checksum: 0x7FEEC538
	Offset: 0x8D0
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function base_alarm_goes_off()
{
	level.is_base_alerted = 1;
	level flag::set_val("is_base_alerted", 1);
	/#
		println("");
	#/
	level util::clientnotify("alarm_on");
	playsoundatposition("evt_base_alarm", (-1546, 287, 461));
	wait(2);
	playsoundatposition("evt_base_alarm", (-1546, 287, 461));
	wait(2);
	playsoundatposition("evt_base_alarm", (-1546, 287, 461));
}

/*
	Name: spawn_coop_player_replacement
	Namespace: cp_prologue_util
	Checksum: 0xFAA7B9E0
	Offset: 0x9D8
	Size: 0x4D8
	Parameters: 2
	Flags: Linked
*/
function spawn_coop_player_replacement(skipto, var_de2f1b3 = 1)
{
	flag::wait_till("all_players_spawned");
	primary_weapon = getweapon("ar_standard_hero");
	var_5178c24b = getdvarint("scene_debug_player", 0);
	if(!isdefined(level.var_681ad194))
	{
		level.var_681ad194 = [];
	}
	if(var_de2f1b3)
	{
		if(level.players.size <= 3 && !isdefined(level.var_681ad194[1]) && var_5178c24b != 2)
		{
			level.var_681ad194[1] = util::get_hero("ally_03");
			s_struct = struct::get(skipto + "_ally_03", "targetname");
			level.var_681ad194[1] forceteleport(s_struct.origin, s_struct.angles);
			level.var_681ad194[1] ai::gun_switchto(primary_weapon, "right");
			level.var_681ad194[1].var_a89679b6 = 3;
		}
		if(level.players.size <= 2 && !isdefined(level.var_681ad194[2]) && var_5178c24b != 3)
		{
			level.var_681ad194[2] = util::get_hero("ally_02");
			s_struct = struct::get(skipto + "_ally_02", "targetname");
			level.var_681ad194[2] forceteleport(s_struct.origin, s_struct.angles);
			level.var_681ad194[2] ai::gun_switchto(primary_weapon, "right");
			level.var_681ad194[2].var_a89679b6 = 2;
		}
		if(level.players.size == 1 && !isdefined(level.var_681ad194[3]) && var_5178c24b != 4)
		{
			level.var_681ad194[3] = util::get_hero("ally_01");
			s_struct = struct::get(skipto + "_ally_01", "targetname");
			level.var_681ad194[3] forceteleport(s_struct.origin, s_struct.angles);
			level.var_681ad194[3] ai::gun_switchto(primary_weapon, "right");
			level.var_681ad194[3].var_a89679b6 = 1;
		}
	}
	if(level.players.size >= 2 && isdefined(level.var_681ad194[3]))
	{
		level.var_681ad194[3] delete();
		level.var_681ad194[3] = undefined;
	}
	if(level.players.size >= 3 && isdefined(level.var_681ad194[2]))
	{
		level.var_681ad194[2] delete();
		level.var_681ad194[2] = undefined;
	}
	if(level.players.size >= 4 && isdefined(level.var_681ad194[1]))
	{
		level.var_681ad194[1] delete();
		level.var_681ad194[1] = undefined;
	}
}

/*
	Name: give_player_weapons
	Namespace: cp_prologue_util
	Checksum: 0xE9D943FC
	Offset: 0xEB8
	Size: 0x26C
	Parameters: 0
	Flags: Linked
*/
function give_player_weapons()
{
	self flag::clear("custom_loadout");
	self takeallweapons();
	self.primaryloadoutweapon = getweapon("smg_standard", "grip", "fastreload", "reflex");
	self.secondaryloadoutweapon = getweapon("pistol_standard", "fastreload");
	self giveweapon(self.primaryloadoutweapon);
	self giveweapon(self.secondaryloadoutweapon);
	self.grenadetypeprimary = getweapon("frag_grenade");
	self.grenadetypesecondary = getweapon("concussion_grenade");
	self giveweapon(self.grenadetypeprimary);
	self giveweapon(self.grenadetypesecondary);
	a_w_weapons = self getweaponslist();
	foreach(w_weapon in a_w_weapons)
	{
		self givemaxammo(w_weapon);
		self setweaponammoclip(w_weapon, w_weapon.clipsize);
	}
	self switchtoweapon(self.primaryloadoutweapon);
	self flag::set("custom_loadout");
}

/*
	Name: arrive_and_spawn
	Namespace: cp_prologue_util
	Checksum: 0x2C3EF8B9
	Offset: 0x1130
	Size: 0x54
	Parameters: 2
	Flags: None
*/
function arrive_and_spawn(vehicle, str_spawn_manager)
{
	vehicle waittill(#"reached_end_node");
	vehicle disconnectpaths();
	spawn_manager::enable(str_spawn_manager);
}

/*
	Name: ai_idle_then_alert
	Namespace: cp_prologue_util
	Checksum: 0x68F83483
	Offset: 0x1190
	Size: 0x178
	Parameters: 2
	Flags: Linked
*/
function ai_idle_then_alert(str_wait_till, var_4afdd260)
{
	self endon(#"death");
	self.goalradius = 8;
	self ai::set_ignoreall(1);
	self ai::set_ignoreme(1);
	self setgoal(self.origin);
	level flag::wait_till(str_wait_till);
	self.goalradius = 32;
	self ai::set_ignoreall(0);
	self ai::set_ignoreme(0);
	if(isdefined(self.target))
	{
		node = getnodearray(self.target, "targetname");
		index = randomintrange(0, node.size);
		self setgoal(node[index], 1);
	}
	if(isdefined(var_4afdd260))
	{
		self waittill(#"goal");
		self.goalradius = var_4afdd260;
	}
}

/*
	Name: get_ai_allies
	Namespace: cp_prologue_util
	Checksum: 0x55DB82BC
	Offset: 0x1310
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function get_ai_allies()
{
	if(!isdefined(level.var_681ad194))
	{
		return [];
	}
	for(i = 1; i < 4; i++)
	{
		if(!isdefined(level.var_681ad194[i]) || !isalive(level.var_681ad194[i]))
		{
			level.var_681ad194[i] = undefined;
		}
	}
	return arraycopy(level.var_681ad194);
}

/*
	Name: get_ai_allies_and_players
	Namespace: cp_prologue_util
	Checksum: 0x41F55383
	Offset: 0x13B8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function get_ai_allies_and_players()
{
	a_team = arraycombine(getplayers(), level.var_681ad194, 0, 0);
	return a_team;
}

/*
	Name: follow_linked_scripted_nodes
	Namespace: cp_prologue_util
	Checksum: 0xFB51D0FD
	Offset: 0x1408
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function follow_linked_scripted_nodes()
{
	self endon(#"death");
	self.goalradius = 64;
	self.ignoreall = 1;
	nd_node = getnode(self.script_string, "targetname");
	while(true)
	{
		self setgoal(nd_node.origin);
		self waittill(#"goal");
		if(!isdefined(nd_node.script_string))
		{
			break;
		}
		nd_node = getnode(nd_node.script_string, "targetname");
	}
}

/*
	Name: ai_setgoal
	Namespace: cp_prologue_util
	Checksum: 0x65C8BA8F
	Offset: 0x14E8
	Size: 0x60
	Parameters: 1
	Flags: None
*/
function ai_setgoal(goal)
{
	nd_node = getnode(goal, "targetname");
	self setgoal(nd_node, 1);
	self waittill(#"goal");
}

/*
	Name: ai_low_goal_radius
	Namespace: cp_prologue_util
	Checksum: 0xFFDF55CE
	Offset: 0x1550
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function ai_low_goal_radius()
{
	self.goalradius = 512;
}

/*
	Name: ai_very_low_goal_radius
	Namespace: cp_prologue_util
	Checksum: 0xC656DAB5
	Offset: 0x1568
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function ai_very_low_goal_radius()
{
	self.goalradius = 16;
}

/*
	Name: set_goal_volume
	Namespace: cp_prologue_util
	Checksum: 0xDDF05E53
	Offset: 0x1580
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function set_goal_volume(e_goal_volume)
{
	self setgoalvolume(e_goal_volume);
}

/*
	Name: set_robot_unarmed
	Namespace: cp_prologue_util
	Checksum: 0x5D0F7F48
	Offset: 0x15B0
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function set_robot_unarmed()
{
	orig_team = self getteam();
	self ai::set_behavior_attribute("rogue_control", "forced_level_2");
	self ai::set_behavior_attribute("rogue_control_speed", "run");
	self setteam(orig_team);
	if(level.players.size > 1)
	{
		self.health = int(self.health * 1.4);
	}
}

/*
	Name: function_bd761fba
	Namespace: cp_prologue_util
	Checksum: 0x1399FCEA
	Offset: 0x1688
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_bd761fba(str_flag)
{
	self endon(#"death");
	self turret::enable(1, 0);
	level flag::wait_till(str_flag);
	self thread function_3a642801();
}

/*
	Name: function_9af14b02
	Namespace: cp_prologue_util
	Checksum: 0xEC12A697
	Offset: 0x16F8
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function function_9af14b02(str_flag, n_time)
{
	self endon(#"death");
	self thread vehicle::get_on_and_go_path(getvehiclenode(self.target, "targetname"));
	self waittill(#"open_fire");
	self turret::shoot_at_target(level.apc, n_time, undefined, 1, 0);
	self turret::enable(1, 1);
	level flag::wait_till(str_flag);
	self thread function_3a642801();
}

/*
	Name: function_1db6047f
	Namespace: cp_prologue_util
	Checksum: 0x44911C51
	Offset: 0x17E0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_1db6047f(str_cleanup)
{
	self endon(#"death");
	trigger::wait_till(str_cleanup);
	self delete();
}

/*
	Name: function_3a642801
	Namespace: cp_prologue_util
	Checksum: 0x7545FA71
	Offset: 0x1830
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_3a642801()
{
	foreach(ai_rider in self.riders)
	{
		if(isdefined(ai_rider))
		{
			ai_rider delete();
		}
	}
	level flag::wait_till_clear("deleting_havok_object");
	level flag::set("deleting_havok_object");
	self.delete_on_death = 1;
	self notify(#"death");
	if(!isalive(self))
	{
		self delete();
	}
	wait(0.05);
	level flag::clear("deleting_havok_object");
}

/*
	Name: function_73acb160
	Namespace: cp_prologue_util
	Checksum: 0x7C0D79ED
	Offset: 0x1978
	Size: 0x8E
	Parameters: 2
	Flags: Linked
*/
function function_73acb160(str_spawners, start_func)
{
	a_spawners = getentarray(str_spawners, "targetname");
	for(i = 0; i < a_spawners.size; i++)
	{
		level thread function_1f89893f(a_spawners[i], start_func);
	}
}

/*
	Name: function_1f89893f
	Namespace: cp_prologue_util
	Checksum: 0x4E7812AE
	Offset: 0x1A10
	Size: 0x72
	Parameters: 2
	Flags: Linked
*/
function function_1f89893f(e_spawner, start_func)
{
	if(isdefined(e_spawner.script_delay))
	{
		wait(e_spawner.script_delay);
	}
	e_ent = e_spawner spawner::spawn();
	if(isdefined(start_func))
	{
		e_ent thread [[start_func]]();
	}
}

/*
	Name: remove_grenades
	Namespace: cp_prologue_util
	Checksum: 0xE4AD8B64
	Offset: 0x1A90
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function remove_grenades()
{
	self.grenadeammo = 0;
}

/*
	Name: function_40e4b0cf
	Namespace: cp_prologue_util
	Checksum: 0x3ED4D89F
	Offset: 0x1AA8
	Size: 0x11C
	Parameters: 3
	Flags: Linked
*/
function function_40e4b0cf(str_spawn_manager, str_spawners, var_c5690501)
{
	a_spawners = getentarray(str_spawners, "targetname");
	e_volume = getent(var_c5690501, "targetname");
	foreach(sp_spawner in a_spawners)
	{
		sp_spawner spawner::add_spawn_function(&set_goal_volume, e_volume);
	}
	spawn_manager::enable(str_spawn_manager);
}

/*
	Name: function_a7eac508
	Namespace: cp_prologue_util
	Checksum: 0xFA4A8E40
	Offset: 0x1BD0
	Size: 0xDE
	Parameters: 4
	Flags: Linked
*/
function function_a7eac508(str_spawner, var_4ac59d48, end_goal_radius, disable_fallback)
{
	a_ents = getentarray(str_spawner, "targetname");
	for(i = 0; i < a_ents.size; i++)
	{
		e_ent = a_ents[i] spawner::spawn();
		if(isdefined(var_4ac59d48))
		{
			e_ent.goalradius = 64;
		}
		e_ent thread ai_wakamole(end_goal_radius, disable_fallback);
	}
}

/*
	Name: ai_wakamole
	Namespace: cp_prologue_util
	Checksum: 0x168577CE
	Offset: 0x1CB8
	Size: 0x60
	Parameters: 2
	Flags: Linked
*/
function ai_wakamole(end_goal_radius, disable_fallback)
{
	self endon(#"death");
	if(isdefined(disable_fallback) && disable_fallback)
	{
		self.disable_fallback = 1;
	}
	self waittill(#"goal");
	if(isdefined(end_goal_radius))
	{
		self.goalradius = end_goal_radius;
	}
}

/*
	Name: function_8f7b1e06
	Namespace: cp_prologue_util
	Checksum: 0x82A25A05
	Offset: 0x1D20
	Size: 0x16E
	Parameters: 3
	Flags: Linked
*/
function function_8f7b1e06(str_trigger, var_390543cc, var_9d774f5d)
{
	if(isdefined(str_trigger))
	{
		e_trigger = getent(str_trigger, "targetname");
		e_trigger waittill(#"trigger");
	}
	var_441bd962 = getent(var_390543cc, "targetname");
	var_ee2fd889 = getent(var_9d774f5d, "targetname");
	a_ai = getaiteamarray("axis");
	for(i = 0; i < a_ai.size; i++)
	{
		e_ent = a_ai[i];
		if(e_ent istouching(var_441bd962))
		{
			e_ent setgoal(var_ee2fd889);
			e_ent thread ai_wakamole(undefined, 0);
		}
	}
}

/*
	Name: wait_for_all_players_to_pass_struct
	Namespace: cp_prologue_util
	Checksum: 0x9F4BF0C8
	Offset: 0x1E98
	Size: 0x198
	Parameters: 2
	Flags: Linked
*/
function wait_for_all_players_to_pass_struct(str_struct, var_e209da48)
{
	s_struct = struct::get(str_struct, "targetname");
	v_struct_dir = anglestoforward(s_struct.angles);
	while(true)
	{
		num_players_past = 0;
		a_players = getplayers();
		for(i = 0; i < a_players.size; i++)
		{
			e_player = a_players[i];
			v_dir = vectornormalize(e_player.origin - s_struct.origin);
			dp = vectordot(v_dir, v_struct_dir);
			if(dp > 0.3)
			{
				num_players_past++;
			}
		}
		if(isdefined(var_e209da48) && num_players_past >= a_players.size)
		{
			break;
		}
		if(num_players_past == a_players.size)
		{
			break;
		}
		wait(0.05);
	}
}

/*
	Name: function_12ce22ee
	Namespace: cp_prologue_util
	Checksum: 0x9F2B3A9
	Offset: 0x2038
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_12ce22ee()
{
	level.a_ai_allies = [];
	if(isdefined(level.var_681ad194[1]))
	{
		arrayinsert(level.a_ai_allies, level.var_681ad194[1], 0);
	}
	if(isdefined(level.var_681ad194[2]))
	{
		arrayinsert(level.a_ai_allies, level.var_681ad194[2], 0);
	}
	if(isdefined(level.var_681ad194[3]))
	{
		arrayinsert(level.a_ai_allies, level.var_681ad194[3], 0);
	}
}

/*
	Name: function_520255e3
	Namespace: cp_prologue_util
	Checksum: 0x9A4B819A
	Offset: 0x2100
	Size: 0x76
	Parameters: 2
	Flags: Linked
*/
function function_520255e3(str_trigger, time)
{
	str_notify = "mufc_" + str_trigger;
	level thread function_901793d(str_trigger, str_notify);
	level thread function_2ffbaa00(time, str_notify);
	level waittill(str_notify);
}

/*
	Name: function_901793d
	Namespace: cp_prologue_util
	Checksum: 0x2F242981
	Offset: 0x2180
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function function_901793d(str_trigger, str_notify)
{
	level endon(str_notify);
	e_trigger = getent(str_trigger, "targetname");
	if(isdefined(e_trigger))
	{
		e_trigger waittill(#"trigger");
	}
	level notify(str_notify);
}

/*
	Name: function_2ffbaa00
	Namespace: cp_prologue_util
	Checksum: 0x25B5A3A8
	Offset: 0x21F8
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function function_2ffbaa00(time, str_notify)
{
	level endon(str_notify);
	wait(time);
	level notify(str_notify);
}

/*
	Name: groundpos_ignore_water
	Namespace: cp_prologue_util
	Checksum: 0x422FADE6
	Offset: 0x2230
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function groundpos_ignore_water(origin)
{
	return groundtrace(origin, origin + (vectorscale((0, 0, -1), 100000)), 0, undefined, 1)["position"];
}

/*
	Name: function_609c412a
	Namespace: cp_prologue_util
	Checksum: 0x8D9FD110
	Offset: 0x2280
	Size: 0x14E
	Parameters: 2
	Flags: Linked
*/
function function_609c412a(str_volume, check_players)
{
	e_volume = getent(str_volume, "targetname");
	num_touching = 0;
	a_ai = getaiteamarray("axis");
	for(i = 0; i < a_ai.size; i++)
	{
		if(a_ai[i] istouching(e_volume))
		{
			num_touching++;
		}
	}
	if(check_players)
	{
		a_players = getplayers();
		for(i = 0; i < a_players.size; i++)
		{
			if(a_players[i] istouching(e_volume))
			{
				num_touching++;
				break;
			}
		}
	}
	return num_touching;
}

/*
	Name: function_15823dab
	Namespace: cp_prologue_util
	Checksum: 0x9645485A
	Offset: 0x23D8
	Size: 0xA6
	Parameters: 6
	Flags: None
*/
function function_15823dab(v_pos, shake_size, shake_time, var_e64e30a6, rumble_num, e_player)
{
	if(shake_size)
	{
		earthquake(shake_size, shake_time, v_pos, var_e64e30a6);
	}
	for(i = 0; i < rumble_num; i++)
	{
		e_player playrumbleonentity("damage_heavy");
		wait(0.1);
	}
}

/*
	Name: rumble_all_players
	Namespace: cp_prologue_util
	Checksum: 0x8EF2B3E2
	Offset: 0x2488
	Size: 0x6C
	Parameters: 4
	Flags: Linked
*/
function rumble_all_players(str_type, n_time_between, n_iterations, e_ent)
{
	for(i = 0; i < n_iterations; i++)
	{
		e_ent playrumbleonentity(str_type);
		wait(n_time_between);
	}
}

/*
	Name: function_2a0bc326
	Namespace: cp_prologue_util
	Checksum: 0x56A27373
	Offset: 0x2500
	Size: 0x152
	Parameters: 7
	Flags: Linked
*/
function function_2a0bc326(v_pos, var_48f82942, var_51fbdea, var_644bf6a7, var_8f4ca4be, str_rumble_type = "damage_heavy", var_183c13ad)
{
	if(var_48f82942)
	{
		earthquake(var_48f82942, var_51fbdea, v_pos, var_644bf6a7);
	}
	var_5ca58060 = var_644bf6a7 * var_644bf6a7;
	foreach(player in level.activeplayers)
	{
		if(isdefined(var_183c13ad))
		{
			player shellshock(var_183c13ad, var_51fbdea);
		}
		player thread function_e42cebb6(v_pos, var_5ca58060, var_8f4ca4be, str_rumble_type);
	}
}

/*
	Name: function_e42cebb6
	Namespace: cp_prologue_util
	Checksum: 0x8B6F6E0
	Offset: 0x2660
	Size: 0x9E
	Parameters: 4
	Flags: Linked
*/
function function_e42cebb6(v_pos, var_5ca58060, var_8f4ca4be, str_rumble_type)
{
	self endon(#"death");
	for(i = 0; i < var_8f4ca4be; i++)
	{
		if(distancesquared(v_pos, self.origin) <= var_5ca58060)
		{
			self playrumbleonentity(str_rumble_type);
		}
		wait(0.1);
	}
}

/*
	Name: vehicle_rumble
	Namespace: cp_prologue_util
	Checksum: 0xAEEBDA79
	Offset: 0x2708
	Size: 0x154
	Parameters: 6
	Flags: Linked
*/
function vehicle_rumble(str_rumble_type = "damage_light", var_74584a64, var_48f82942 = 0.1, n_period = 0.1, n_radius = 2000, n_timeout)
{
	if(isdefined(var_74584a64))
	{
		self endon(var_74584a64);
	}
	self endon(#"death");
	n_timepassed = 0;
	b_done = 0;
	while(!b_done)
	{
		self playrumbleonentity(str_rumble_type);
		earthquake(var_48f82942, n_period, self.origin, n_radius);
		wait(n_period);
		if(isdefined(n_timeout) && n_timeout > 0)
		{
			n_timepassed = n_timepassed + n_period;
			b_done = n_timepassed >= n_timeout;
		}
	}
}

/*
	Name: function_47a62798
	Namespace: cp_prologue_util
	Checksum: 0x34F94EE5
	Offset: 0x2868
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function function_47a62798(var_de243c2)
{
	level.ai_hendricks ai::set_behavior_attribute("cqb", var_de243c2);
	a_allies = get_ai_allies();
	foreach(e_ally in a_allies)
	{
		e_ally ai::set_behavior_attribute("cqb", var_de243c2);
	}
}

/*
	Name: function_a5398264
	Namespace: cp_prologue_util
	Checksum: 0x63CE418D
	Offset: 0x2958
	Size: 0x132
	Parameters: 1
	Flags: Linked
*/
function function_a5398264(str_mode)
{
	level.ai_hendricks ai::set_behavior_attribute("move_mode", str_mode);
	level.ai_khalil ai::set_behavior_attribute("move_mode", str_mode);
	level.ai_minister ai::set_behavior_attribute("move_mode", str_mode);
	a_allies = get_ai_allies();
	foreach(e_ally in a_allies)
	{
		e_ally ai::set_behavior_attribute("move_mode", str_mode);
	}
}

/*
	Name: function_db027040
	Namespace: cp_prologue_util
	Checksum: 0x8122F065
	Offset: 0x2A98
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function function_db027040(var_eb6e3c93)
{
	level.ai_hendricks.perfectaim = var_eb6e3c93;
	level.ai_khalil.perfectaim = var_eb6e3c93;
	level.ai_minister.perfectaim = var_eb6e3c93;
	a_allies = get_ai_allies();
	foreach(e_ally in a_allies)
	{
		e_ally.perfectaim = var_eb6e3c93;
	}
}

/*
	Name: num_players_touching_volume
	Namespace: cp_prologue_util
	Checksum: 0x9B8C579E
	Offset: 0x2B90
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function num_players_touching_volume(e_volume)
{
	a_players = getplayers();
	num_touching = 0;
	for(i = 0; i < a_players.size; i++)
	{
		if(a_players[i] istouching(e_volume))
		{
			num_touching++;
		}
	}
	return num_touching;
}

/*
	Name: function_68b8f4af
	Namespace: cp_prologue_util
	Checksum: 0xC5B61D73
	Offset: 0x2C30
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_68b8f4af(e_volume)
{
	a_ai = getaiteamarray("axis");
	a_touching = [];
	for(i = 0; i < a_ai.size; i++)
	{
		if(a_ai[i] istouching(e_volume))
		{
			a_touching[a_touching.size] = a_ai[i];
		}
	}
	return a_touching;
}

/*
	Name: function_d1f1caad
	Namespace: cp_prologue_util
	Checksum: 0x9BB4FE63
	Offset: 0x2CE8
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_d1f1caad(str_trigger)
{
	e_trigger = getent(str_trigger, "targetname");
	if(isdefined(e_trigger))
	{
		e_trigger waittill(#"trigger");
	}
}

/*
	Name: function_e0fb6da9
	Namespace: cp_prologue_util
	Checksum: 0x603F00D9
	Offset: 0x2D48
	Size: 0x414
	Parameters: 8
	Flags: Linked
*/
function function_e0fb6da9(str_struct, close_dist, wait_time, var_d1b83750, max_ai, var_a70db4af, var_1813646e, var_98e9bc46)
{
	a_players = getplayers();
	if(a_players.size > 1)
	{
		return;
	}
	s_struct = struct::get(str_struct, "targetname");
	var_37124366 = getent(var_1813646e, "targetname");
	var_7d22b48e = getent(var_98e9bc46, "targetname");
	v_forward = anglestoforward(s_struct.angles);
	s_struct.start_time = undefined;
	var_cc06a93d = 0;
	while(true)
	{
		e_player = getplayers()[0];
		v_dir = s_struct.origin - e_player.origin;
		var_989d1f7c = vectordot(v_dir, v_forward);
		if(var_989d1f7c < -100)
		{
			return;
		}
		dist = distance(s_struct.origin, e_player.origin);
		if(dist < close_dist)
		{
			if(!isdefined(s_struct.start_time))
			{
				s_struct.start_time = gettime();
			}
		}
		else
		{
			s_struct.start_time = undefined;
		}
		if(isdefined(s_struct.start_time))
		{
			time = gettime();
			dt = (time - s_struct.start_time) / 1000;
			if(dt > wait_time)
			{
				a_ai = getaiteamarray("axis");
				a_touching = [];
				for(i = 0; i < a_ai.size; i++)
				{
					e_ent = a_ai[i];
					if(!isdefined(e_ent.var_db552f4))
					{
						if(e_ent istouching(var_37124366))
						{
							a_touching[a_touching.size] = e_ent;
						}
					}
				}
				var_d6f9eed8 = randomintrange(var_d1b83750, max_ai + 1);
				if(var_d6f9eed8 > a_touching.size)
				{
					var_d6f9eed8 = a_touching.size;
				}
				for(i = 0; i < var_d6f9eed8; i++)
				{
					a_touching[i] setgoal(var_7d22b48e);
					a_touching[i].var_db552f4 = 1;
				}
				s_struct.start_time = undefined;
				var_cc06a93d++;
				if(var_cc06a93d >= var_a70db4af)
				{
					return;
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_f5363f47
	Namespace: cp_prologue_util
	Checksum: 0xC814AFD3
	Offset: 0x3168
	Size: 0xA8
	Parameters: 1
	Flags: None
*/
function function_f5363f47(str_trigger)
{
	a_triggers = getentarray(str_trigger, "targetname");
	str_notify = str_trigger + "_waiting";
	for(i = 0; i < a_triggers.size; i++)
	{
		level thread function_7eb8a7ab(a_triggers[i], str_notify);
	}
	level waittill(str_notify);
}

/*
	Name: function_7eb8a7ab
	Namespace: cp_prologue_util
	Checksum: 0x20F40BD9
	Offset: 0x3218
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function function_7eb8a7ab(e_trigger, str_notify)
{
	level endon(str_notify);
	e_trigger waittill(#"trigger");
	level notify(str_notify);
}

/*
	Name: function_25e841ea
	Namespace: cp_prologue_util
	Checksum: 0xAF85B09
	Offset: 0x3258
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_25e841ea()
{
	if(!isdefined(level.var_c6c69fca))
	{
		level.var_c6c69fca = 1;
	}
}

/*
	Name: function_92d5b013
	Namespace: cp_prologue_util
	Checksum: 0x89790420
	Offset: 0x3280
	Size: 0x76
	Parameters: 1
	Flags: None
*/
function function_92d5b013(speed_frac)
{
	a_players = getplayers();
	for(i = 0; i < a_players.size; i++)
	{
		a_players[i] setmovespeedscale(speed_frac);
	}
}

/*
	Name: debug_line
	Namespace: cp_prologue_util
	Checksum: 0x8F74D4BE
	Offset: 0x3300
	Size: 0xA0
	Parameters: 1
	Flags: None
*/
function debug_line(e_ent)
{
	e_ent endon(#"death");
	while(true)
	{
		v_start = e_ent.origin;
		v_end = v_start + vectorscale((0, 0, 1), 1000);
		v_col = (1, 1, 1);
		/#
			line(v_start, v_end, v_col);
		#/
		wait(0.1);
	}
}

/*
	Name: function_42da021e
	Namespace: cp_prologue_util
	Checksum: 0x9A1F4332
	Offset: 0x33A8
	Size: 0x1FC
	Parameters: 4
	Flags: Linked
*/
function function_42da021e(str_spawner_name, var_4c026543, var_61e0b19a, var_e3f49331 = 0)
{
	var_28290004 = str_spawner_name + "_end";
	e_vtol = vehicle::simple_spawn_single(str_spawner_name);
	e_vtol endon(#"death");
	e_vtol thread vehicle_rumble("buzz_high", var_28290004, 0.05, 0.1, 5000);
	nd_start = getvehiclenode(e_vtol.target, "targetname");
	e_vtol attachpath(nd_start);
	if(isdefined(var_4c026543))
	{
		if(!isdefined(var_61e0b19a))
		{
			e_vtol setspeed(var_4c026543);
		}
		else
		{
			e_vtol setspeed(var_4c026543, var_61e0b19a);
		}
	}
	if(var_e3f49331)
	{
		e_vtol thread function_c56034b7();
	}
	e_vtol startpath();
	e_vtol waittill(#"reached_end_node");
	e_vtol notify(var_28290004);
	e_vtol.delete_on_death = 1;
	e_vtol notify(#"death");
	if(!isalive(e_vtol))
	{
		e_vtol delete();
	}
}

/*
	Name: function_c56034b7
	Namespace: cp_prologue_util
	Checksum: 0x51593EA8
	Offset: 0x35B0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_c56034b7()
{
	playfxontag(level._effect["vtol_rotorwash"], self, "tag_engine_left");
	playfxontag(level._effect["vtol_rotorwash"], self, "tag_engine_right");
}

/*
	Name: function_950d1c3b
	Namespace: cp_prologue_util
	Checksum: 0x17055E82
	Offset: 0x3620
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function function_950d1c3b(b_enable = 1)
{
	var_9dff5377 = (b_enable ? 1 : 0);
	foreach(player in level.players)
	{
		player clientfield::set_to_player("player_tunnel_dust_fx", var_9dff5377);
	}
}

/*
	Name: function_34acbf2
	Namespace: cp_prologue_util
	Checksum: 0x618401CA
	Offset: 0x3700
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_34acbf2()
{
	objectives::complete("cp_level_prologue_locate_the_security_room");
	objectives::complete("cp_level_prologue_security_camera");
}

/*
	Name: function_df278013
	Namespace: cp_prologue_util
	Checksum: 0xF592198C
	Offset: 0x3740
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_df278013()
{
	objectives::complete("cp_level_prologue_free_the_minister");
}

/*
	Name: function_9d35b20d
	Namespace: cp_prologue_util
	Checksum: 0x8C2A8F46
	Offset: 0x3768
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_9d35b20d()
{
	objectives::complete("cp_level_prologue_free_khalil");
}

/*
	Name: function_cfabe921
	Namespace: cp_prologue_util
	Checksum: 0xD5B75E0A
	Offset: 0x3790
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_cfabe921()
{
	function_34acbf2();
	function_df278013();
	function_9d35b20d();
	objectives::complete("cp_level_prologue_find_vehicle");
	objectives::complete("cp_level_prologue_defend_theia");
	objectives::set("cp_level_prologue_goto_exfil");
}

/*
	Name: function_21f52196
	Namespace: cp_prologue_util
	Checksum: 0x7957A931
	Offset: 0x3818
	Size: 0x214
	Parameters: 3
	Flags: Linked
*/
function function_21f52196(str_door_name, t_enter, var_13aabd08)
{
	/#
		assert(isdefined(t_enter), "");
	#/
	/#
		assert(isdefined(t_enter.target), "");
	#/
	level endon("stop_door_" + str_door_name);
	t_exit = getent(t_enter.target, "targetname");
	t_enter thread function_e0f9fe98(str_door_name, 0);
	t_exit thread function_e0f9fe98(str_door_name, 1);
	if(isdefined(var_13aabd08))
	{
		var_dee3d10a = getent(var_13aabd08, "targetname");
		/#
			assert(isdefined(var_dee3d10a), "");
		#/
		var_dee3d10a endon(#"death");
		var_dee3d10a waittill(#"hash_c0b9931e");
		foreach(player in level.players)
		{
			if(!isdefined(player.a_doors))
			{
				player.a_doors = [];
			}
			player.a_doors[str_door_name] = 1;
		}
	}
}

/*
	Name: function_2e61b3e8
	Namespace: cp_prologue_util
	Checksum: 0x8E318DD5
	Offset: 0x3A38
	Size: 0x172
	Parameters: 3
	Flags: Linked
*/
function function_2e61b3e8(str_door_name, t_enter, a_ai)
{
	/#
		assert(isdefined(t_enter), "");
	#/
	/#
		assert(isdefined(t_enter.target), "");
	#/
	level endon("stop_door_" + str_door_name);
	t_exit = getent(t_enter.target, "targetname");
	if(!isdefined(level.var_40c4c9da))
	{
		level.var_40c4c9da = [];
	}
	level.var_40c4c9da[str_door_name] = a_ai;
	foreach(e_guy in a_ai)
	{
		t_exit thread function_e010251d(str_door_name, 1, e_guy);
	}
}

/*
	Name: function_e0f9fe98
	Namespace: cp_prologue_util
	Checksum: 0x7D7ABC3B
	Offset: 0x3BB8
	Size: 0xA6
	Parameters: 2
	Flags: Linked
*/
function function_e0f9fe98(str_door_name, b_state)
{
	level endon("stop_door_" + str_door_name);
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(isplayer(e_who))
		{
			if(!isdefined(e_who.a_doors))
			{
				e_who.a_doors = [];
			}
			e_who.a_doors[str_door_name] = b_state;
		}
	}
}

/*
	Name: function_e010251d
	Namespace: cp_prologue_util
	Checksum: 0xE1160CC3
	Offset: 0x3C68
	Size: 0xF6
	Parameters: 3
	Flags: Linked
*/
function function_e010251d(str_door_name, b_state, e_guy)
{
	level endon("stop_door_" + str_door_name);
	self endon(#"death");
	if(!isdefined(e_guy.a_doors))
	{
		e_guy.a_doors = [];
	}
	e_guy.a_doors[str_door_name] = 0;
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(isai(e_who) && e_who == e_guy)
		{
			if(!isdefined(e_who.a_doors))
			{
				e_who.a_doors = [];
			}
			e_who.a_doors[str_door_name] = b_state;
		}
	}
}

/*
	Name: function_cdd726fb
	Namespace: cp_prologue_util
	Checksum: 0xC46A2E05
	Offset: 0x3D68
	Size: 0x1E0
	Parameters: 1
	Flags: Linked
*/
function function_cdd726fb(str_door_name)
{
	var_83b77796 = 1;
	foreach(player in level.activeplayers)
	{
		if(!isdefined(player.a_doors) || !isdefined(player.a_doors[str_door_name]) || !player.a_doors[str_door_name])
		{
			var_83b77796 = 0;
		}
	}
	if(isdefined(level.var_40c4c9da) && isdefined(level.var_40c4c9da[str_door_name]))
	{
		foreach(e_guy in level.var_40c4c9da[str_door_name])
		{
			if(isalive(e_guy) && (!isdefined(e_guy.a_doors) || !isdefined(e_guy.a_doors[str_door_name]) || !e_guy.a_doors[str_door_name]))
			{
				var_83b77796 = 0;
			}
		}
	}
	return var_83b77796;
}

/*
	Name: function_d990de5a
	Namespace: cp_prologue_util
	Checksum: 0x53789E04
	Offset: 0x3F50
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function function_d990de5a(t_enter)
{
	t_exit = getent(t_enter.target, "targetname");
	t_enter delete();
	t_exit delete();
}

/*
	Name: function_d723979e
	Namespace: cp_prologue_util
	Checksum: 0x7A6832D0
	Offset: 0x3FC8
	Size: 0x5C
	Parameters: 3
	Flags: Linked
*/
function function_d723979e(str_notify, str_model, str_endon)
{
	self endon(#"death");
	if(isdefined(str_endon))
	{
		level endon(str_endon);
	}
	self waittill(str_notify);
	self setmodel(str_model);
}

/*
	Name: function_72e9bdb8
	Namespace: cp_prologue_util
	Checksum: 0x628F057D
	Offset: 0x4030
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function function_72e9bdb8()
{
	if(self ishost())
	{
		return self getdstat("highestMapReached") > 0;
	}
	return self getdstat("PlayerStatsByMap", "cp_mi_eth_prologue", "hasBeenCompleted");
}

