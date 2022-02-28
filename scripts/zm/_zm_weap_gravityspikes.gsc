// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\zombie_vortex;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\throttle_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_weap_gravityspikes;

/*
	Name: __init__sytem__
	Namespace: zm_weap_gravityspikes
	Checksum: 0xFCE55695
	Offset: 0x8A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_gravityspikes", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_gravityspikes
	Checksum: 0x88ADDDED
	Offset: 0x8E0
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.n_zombies_lifted_for_ragdoll = 0;
	level.spikes_chop_cone_range = 120;
	level.spikes_chop_cone_range_sq = level.spikes_chop_cone_range * level.spikes_chop_cone_range;
	level.ai_gravity_throttle = new throttle();
	[[ level.ai_gravity_throttle ]]->initialize(2, 0.1);
	level.ai_spikes_chop_throttle = new throttle();
	[[ level.ai_spikes_chop_throttle ]]->initialize(6, 0.1);
	register_clientfields();
	callback::on_connect(&on_connect_func_for_gravityspikes);
	zm_hero_weapon::register_hero_weapon("hero_gravityspikes_melee");
	zm_hero_weapon::register_hero_weapon_wield_unwield_callbacks("hero_gravityspikes_melee", &wield_gravityspikes, &unwield_gravityspikes);
	zm_hero_weapon::register_hero_weapon_power_callbacks("hero_gravityspikes_melee", undefined, &gravityspikes_power_expired);
	zm::register_player_damage_callback(&player_invulnerable_during_gravityspike_slam);
	zm_hero_weapon::register_hero_recharge_event(getweapon("hero_gravityspikes_melee"), &gravityspikes_power_override);
	/#
		level thread function_81889ac5();
	#/
}

/*
	Name: register_clientfields
	Namespace: zm_weap_gravityspikes
	Checksum: 0xB1FE7F5A
	Offset: 0xAA8
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("actor", "gravity_slam_down", 1, 1, "int");
	clientfield::register("scriptmover", "gravity_trap_fx", 1, 1, "int");
	clientfield::register("scriptmover", "gravity_trap_spike_spark", 1, 1, "int");
	clientfield::register("scriptmover", "gravity_trap_destroy", 1, 1, "counter");
	clientfield::register("scriptmover", "gravity_trap_location", 1, 1, "int");
	clientfield::register("scriptmover", "gravity_slam_fx", 1, 1, "int");
	clientfield::register("toplayer", "gravity_slam_player_fx", 1, 1, "counter");
	clientfield::register("actor", "sparky_beam_fx", 1, 1, "int");
	clientfield::register("actor", "sparky_zombie_fx", 1, 1, "int");
	clientfield::register("actor", "sparky_zombie_trail_fx", 1, 1, "int");
	clientfield::register("toplayer", "gravity_trap_rumble", 1, 1, "int");
	clientfield::register("actor", "ragdoll_impact_watch", 1, 1, "int");
	clientfield::register("actor", "gravity_spike_zombie_explode_fx", 12000, 1, "counter");
}

/*
	Name: on_connect_func_for_gravityspikes
	Namespace: zm_weap_gravityspikes
	Checksum: 0x9DBBBED
	Offset: 0xD28
	Size: 0x204
	Parameters: 0
	Flags: Linked, Private
*/
function private on_connect_func_for_gravityspikes()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"death");
	self endon(#"gravity_spike_expired");
	w_gravityspike = getweapon("hero_gravityspikes_melee");
	self update_gravityspikes_state(0);
	self.b_gravity_trap_spikes_in_ground = 0;
	self.disable_hero_power_charging = 0;
	self.b_gravity_trap_fx_on = 0;
	self thread reset_after_bleeding_out();
	do
	{
		self waittill(#"new_hero_weapon", weapon);
	}
	while(weapon != w_gravityspike);
	if(isdefined(self.a_gravityspikes_prev_ammo_clip) && isdefined(self.a_gravityspikes_prev_ammo_clip["hero_gravityspikes_melee"]))
	{
		self setweaponammoclip(w_gravityspike, self.a_gravityspikes_prev_ammo_clip["hero_gravityspikes_melee"]);
		self.a_gravityspikes_prev_ammo_clip = undefined;
	}
	else
	{
		self setweaponammoclip(w_gravityspike, w_gravityspike.clipsize);
	}
	if(isdefined(self.saved_spike_power))
	{
		self gadgetpowerset(self gadgetgetslot(w_gravityspike), self.saved_spike_power);
		self.saved_spike_power = undefined;
	}
	else
	{
		self gadgetpowerset(self gadgetgetslot(w_gravityspike), 100);
	}
	self.gravity_trap_unitrigger_stub = undefined;
	self thread weapon_drop_watcher();
	self thread weapon_change_watcher();
}

/*
	Name: reset_after_bleeding_out
	Namespace: zm_weap_gravityspikes
	Checksum: 0xC8E5C485
	Offset: 0xF38
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function reset_after_bleeding_out()
{
	self endon(#"disconnect");
	w_gravityspike = getweapon("hero_gravityspikes_melee");
	if(isdefined(self.b_has_gravityspikes) && self.b_has_gravityspikes)
	{
		util::wait_network_frame();
		self zm_weapons::weapon_give(w_gravityspike, 0, 1);
		self update_gravityspikes_state(2);
	}
	self waittill(#"bled_out");
	if(self hasweapon(w_gravityspike))
	{
		self.b_has_gravityspikes = 1;
		self.saved_spike_power = self gadgetpowerget(self gadgetgetslot(w_gravityspike));
		if(self.saved_spike_power >= 100)
		{
			self.saved_spike_power = undefined;
		}
		self.a_gravityspikes_prev_ammo_clip["hero_gravityspikes_melee"] = self getweaponammoclip(w_gravityspike);
	}
	if(isdefined(self.gravity_trap_unitrigger_stub))
	{
		zm_unitrigger::unregister_unitrigger(self.gravity_trap_unitrigger_stub);
		self.gravity_trap_unitrigger_stub = undefined;
	}
	self waittill(#"spawned_player");
	self thread on_connect_func_for_gravityspikes();
}

/*
	Name: gravityspikes_power_override
	Namespace: zm_weap_gravityspikes
	Checksum: 0xAE2952D0
	Offset: 0x10D8
	Size: 0x354
	Parameters: 2
	Flags: Linked
*/
function gravityspikes_power_override(e_player, ai_enemy)
{
	if(e_player laststand::player_is_in_laststand())
	{
		return;
	}
	if(ai_enemy.damageweapon === getweapon("hero_gravityspikes_melee"))
	{
		return;
	}
	if(isdefined(e_player.disable_hero_power_charging) && e_player.disable_hero_power_charging)
	{
		return;
	}
	if(isdefined(e_player) && isdefined(e_player.hero_power))
	{
		w_gravityspike = getweapon("hero_gravityspikes_melee");
		if(isdefined(ai_enemy.heroweapon_kill_power))
		{
			n_perk_factor = 1;
			if(e_player hasperk("specialty_overcharge"))
			{
				n_perk_factor = getdvarfloat("gadgetPowerOverchargePerkScoreFactor");
			}
			if(isdefined(ai_enemy.damageweapon) && (issubstr(ai_enemy.damageweapon.name, "elemental_bow_demongate") || issubstr(ai_enemy.damageweapon.name, "elemental_bow_run_prison") || issubstr(ai_enemy.damageweapon.name, "elemental_bow_storm") || issubstr(ai_enemy.damageweapon.name, "elemental_bow_wolf_howl")))
			{
				n_perk_factor = 0.25;
			}
			e_player.hero_power = e_player.hero_power + (n_perk_factor * ai_enemy.heroweapon_kill_power);
			e_player.hero_power = math::clamp(e_player.hero_power, 0, 100);
			if(e_player.hero_power >= e_player.hero_power_prev)
			{
				e_player gadgetpowerset(e_player gadgetgetslot(w_gravityspike), e_player.hero_power);
				e_player clientfield::set_player_uimodel("zmhud.swordEnergy", e_player.hero_power / 100);
				e_player clientfield::increment_uimodel("zmhud.swordChargeUpdate");
			}
			if(e_player.hero_power >= 100)
			{
				e_player update_gravityspikes_state(2);
			}
		}
	}
}

/*
	Name: wield_gravityspikes
	Namespace: zm_weap_gravityspikes
	Checksum: 0xBB8D4D8F
	Offset: 0x1438
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function wield_gravityspikes(wpn_gravityspikes)
{
	self zm_hero_weapon::default_wield(wpn_gravityspikes);
	if(!(isdefined(self.b_used_spikes) && self.b_used_spikes))
	{
		if(isdefined(self.hintelem))
		{
			self.hintelem settext("");
			self.hintelem destroy();
		}
		self thread zm_equipment::show_hint_text(&"ZM_CASTLE_GRAVITYSPIKE_INSTRUCTIONS", 3);
		self.b_used_spikes = 1;
	}
	self update_gravityspikes_state(3);
	self thread gravityspikes_attack_watcher(wpn_gravityspikes);
	self thread gravityspikes_stuck_above_zombie_watcher(wpn_gravityspikes);
	self thread gravityspikes_altfire_watcher(wpn_gravityspikes);
	self thread gravityspikes_swipe_watcher(wpn_gravityspikes);
}

/*
	Name: unwield_gravityspikes
	Namespace: zm_weap_gravityspikes
	Checksum: 0x915CE0E4
	Offset: 0x1570
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function unwield_gravityspikes(wpn_gravityspikes)
{
	self zm_hero_weapon::default_unwield(wpn_gravityspikes);
	self notify(#"gravityspikes_attack_watchers_end");
	if(isdefined(self.b_gravity_trap_spikes_in_ground) && self.b_gravity_trap_spikes_in_ground)
	{
		self.disable_hero_power_charging = 1;
		self thread zm_hero_weapon::continue_draining_hero_weapon(wpn_gravityspikes);
		self thread gravity_trap_loop(self.v_gravity_trap_pos, wpn_gravityspikes);
	}
}

/*
	Name: weapon_drop_watcher
	Namespace: zm_weap_gravityspikes
	Checksum: 0x2029D220
	Offset: 0x1610
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function weapon_drop_watcher()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"weapon_switch_started", w_current);
		if(zm_utility::is_hero_weapon(w_current))
		{
			self setweaponammoclip(w_current, 0);
		}
	}
}

/*
	Name: weapon_change_watcher
	Namespace: zm_weap_gravityspikes
	Checksum: 0xF7851EBF
	Offset: 0x1680
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function weapon_change_watcher()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"weapon_change", w_current, w_previous);
		if(isdefined(w_previous) && zm_utility::is_hero_weapon(w_current))
		{
			self.w_gravityspikes_wpn_prev = w_previous;
		}
	}
}

/*
	Name: gravityspikes_attack_watcher
	Namespace: zm_weap_gravityspikes
	Checksum: 0x35F3567B
	Offset: 0x16F8
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function gravityspikes_attack_watcher(wpn_gravityspikes)
{
	self endon(#"gravityspikes_attack_watchers_end");
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"death");
	self endon(#"gravity_spike_expired");
	while(true)
	{
		self waittill(#"weapon_melee_power", weapon);
		if(weapon == wpn_gravityspikes)
		{
			self playrumbleonentity("talon_spike");
			self thread knockdown_zombies_slam();
			self thread no_damage_gravityspikes_slam();
		}
	}
}

/*
	Name: gravityspikes_stuck_above_zombie_watcher
	Namespace: zm_weap_gravityspikes
	Checksum: 0x40AD9621
	Offset: 0x17C8
	Size: 0x4F0
	Parameters: 1
	Flags: Linked
*/
function gravityspikes_stuck_above_zombie_watcher(wpn_gravityspikes)
{
	self endon(#"gravityspikes_attack_watchers_end");
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"death");
	self endon(#"gravity_spike_expired");
	first_half_traces = 1;
	while(zm_utility::is_player_valid(self))
	{
		if(!self isslamming())
		{
			wait(0.05);
			continue;
		}
		while(self isslamming() && self getcurrentweapon() == wpn_gravityspikes)
		{
			player_angles = self getplayerangles();
			forward_vec = anglestoforward((0, player_angles[1], 0));
			if(forward_vec[0] == 0 && forward_vec[1] == 0 && forward_vec[2] == 0)
			{
				wait(0.05);
				continue;
			}
			forward_right_45_vec = rotatepoint(forward_vec, vectorscale((0, 1, 0), 45));
			forward_left_45_vec = rotatepoint(forward_vec, vectorscale((0, -1, 0), 45));
			right_vec = anglestoright(player_angles);
			end_height = -35;
			start_point = self.origin + vectorscale((0, 0, 1), 50);
			end_point = self.origin + (0, 0, end_height);
			end_radius = 30;
			trace_end_points = [];
			if(first_half_traces)
			{
				trace_end_points[0] = end_point + vectorscale(forward_vec, end_radius);
				trace_end_points[1] = end_point + vectorscale(right_vec, end_radius);
				trace_end_points[2] = end_point - vectorscale(right_vec, end_radius);
				first_half_traces = 0;
			}
			else
			{
				trace_end_points[0] = end_point + vectorscale(forward_right_45_vec, end_radius);
				trace_end_points[1] = end_point + vectorscale(forward_left_45_vec, end_radius);
				trace_end_points[2] = end_point - vectorscale(forward_vec, end_radius);
				first_half_traces = 1;
			}
			for(i = 0; i < 3; i++)
			{
				trace = bullettrace(start_point, trace_end_points[i], 1, self);
				/#
					if(getdvarint("", 0) > 0)
					{
						line(start_point, trace_end_points[i], (1, 1, 1), 1, 0, 60);
						recordline(start_point, trace_end_points[i], (1, 1, 1), "", self);
					}
				#/
				if(trace["fraction"] < 1)
				{
					if(isactor(trace["entity"]) && trace["entity"].health > 0 && (trace["entity"].archetype == "zombie" || trace["entity"].archetype == "zombie_dog"))
					{
						self thread knockdown_zombies_slam();
						self thread no_damage_gravityspikes_slam();
						wait(1);
						break;
					}
				}
			}
			wait(0.05);
		}
		wait(0.05);
	}
}

/*
	Name: gravityspikes_altfire_watcher
	Namespace: zm_weap_gravityspikes
	Checksum: 0x6D9C2068
	Offset: 0x1CC0
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function gravityspikes_altfire_watcher(wpn_gravityspikes)
{
	self endon(#"gravityspikes_attack_watchers_end");
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"death");
	self endon(#"gravity_spike_expired");
	while(true)
	{
		self waittill(#"weapon_melee_power_left", weapon);
		if(weapon == wpn_gravityspikes && self gravity_spike_position_valid())
		{
			self thread plant_gravity_trap(wpn_gravityspikes);
		}
	}
}

/*
	Name: gravity_spike_position_valid
	Namespace: zm_weap_gravityspikes
	Checksum: 0xC64AD22D
	Offset: 0x1D70
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gravity_spike_position_valid()
{
	if(isdefined(level.gravityspike_position_check))
	{
		return self [[level.gravityspike_position_check]]();
	}
	if(ispointonnavmesh(self.origin, self))
	{
		return 1;
	}
}

/*
	Name: chop_actor
	Namespace: zm_weap_gravityspikes
	Checksum: 0x3BD8F82A
	Offset: 0x1DC0
	Size: 0xFC
	Parameters: 3
	Flags: Linked
*/
function chop_actor(ai, leftswing, weapon = level.weaponnone)
{
	self endon(#"disconnect");
	if(!isdefined(ai) || !isalive(ai))
	{
		return;
	}
	if(3594 >= ai.health)
	{
		ai.ignoremelee = 1;
	}
	[[ level.ai_spikes_chop_throttle ]]->waitinqueue(ai);
	ai dodamage(3594, self.origin, self, self, "none", "MOD_UNKNOWN", 0, weapon);
	util::wait_network_frame();
}

/*
	Name: chop_zombies
	Namespace: zm_weap_gravityspikes
	Checksum: 0x2C30A235
	Offset: 0x1EC8
	Size: 0x2F2
	Parameters: 3
	Flags: Linked
*/
function chop_zombies(first_time, leftswing, weapon = level.weaponnone)
{
	view_pos = self getweaponmuzzlepoint();
	forward_view_angles = self getweaponforwarddir();
	zombie_list = getaiteamarray(level.zombie_team);
	foreach(ai in zombie_list)
	{
		if(!isdefined(ai) || !isalive(ai))
		{
			continue;
		}
		if(first_time)
		{
			ai.chopped = 0;
		}
		else if(isdefined(ai.chopped) && ai.chopped)
		{
			continue;
		}
		test_origin = ai getcentroid();
		dist_sq = distancesquared(view_pos, test_origin);
		dist_to_check = level.spikes_chop_cone_range_sq;
		if(dist_sq > dist_to_check)
		{
			continue;
		}
		normal = vectornormalize(test_origin - view_pos);
		dot = vectordot(forward_view_angles, normal);
		if(dot <= 0)
		{
			continue;
		}
		if(0 == ai damageconetrace(view_pos, self))
		{
			continue;
		}
		ai.chopped = 1;
		if(isdefined(ai.chop_actor_cb))
		{
			self thread [[ai.chop_actor_cb]](ai, self, weapon);
			continue;
		}
		self thread chop_actor(ai, leftswing, weapon);
	}
}

/*
	Name: spikesarc_swipe
	Namespace: zm_weap_gravityspikes
	Checksum: 0xFAFC149
	Offset: 0x21C8
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function spikesarc_swipe(player)
{
	player thread chop_zombies(1, 1, self);
	wait(0.3);
	player thread chop_zombies(0, 1, self);
	wait(0.5);
	player thread chop_zombies(0, 0, self);
}

/*
	Name: gravityspikes_swipe_watcher
	Namespace: zm_weap_gravityspikes
	Checksum: 0x579C0FC8
	Offset: 0x2250
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function gravityspikes_swipe_watcher(wpn_gravityspikes)
{
	self endon(#"gravityspikes_attack_watchers_end");
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"death");
	self endon(#"gravity_spike_expired");
	while(true)
	{
		self waittill(#"weapon_melee", weapon);
		weapon thread spikesarc_swipe(self);
	}
}

/*
	Name: gravityspikes_power_update
	Namespace: zm_weap_gravityspikes
	Checksum: 0xEC742FBB
	Offset: 0x22E0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function gravityspikes_power_update(player)
{
	if(!(isdefined(player.disable_hero_power_charging) && player.disable_hero_power_charging))
	{
		player gadgetpowerset(0, 100);
		player update_gravityspikes_state(2);
	}
}

/*
	Name: gravityspikes_power_expired
	Namespace: zm_weap_gravityspikes
	Checksum: 0x48C19739
	Offset: 0x2350
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function gravityspikes_power_expired(weapon)
{
	self zm_hero_weapon::default_power_empty(weapon);
	self notify(#"stop_draining_hero_weapon");
	self notify(#"gravityspikes_timer_end");
}

/*
	Name: player_invulnerable_during_gravityspike_slam
	Namespace: zm_weap_gravityspikes
	Checksum: 0x4C1DBD
	Offset: 0x2398
	Size: 0xAA
	Parameters: 11
	Flags: Linked
*/
function player_invulnerable_during_gravityspike_slam(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	if(self.gravityspikes_state === 3 && (self isslamming() || (isdefined(self.gravityspikes_slam) && self.gravityspikes_slam)))
	{
		return 0;
	}
	return -1;
}

/*
	Name: no_damage_gravityspikes_slam
	Namespace: zm_weap_gravityspikes
	Checksum: 0xD80F1E8
	Offset: 0x2450
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function no_damage_gravityspikes_slam()
{
	self.gravityspikes_slam = 1;
	wait(1.5);
	self.gravityspikes_slam = 0;
}

/*
	Name: player_near_gravity_vortex
	Namespace: zm_weap_gravityspikes
	Checksum: 0x9C6DEC69
	Offset: 0x2480
	Size: 0x1A0
	Parameters: 1
	Flags: Linked
*/
function player_near_gravity_vortex(v_vortex_origin)
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"death");
	while(isdefined(self.b_gravity_trap_spikes_in_ground) && self.b_gravity_trap_spikes_in_ground && self.gravityspikes_state === 3)
	{
		foreach(e_player in level.activeplayers)
		{
			if(isdefined(e_player) && (!(isdefined(e_player.idgun_vision_on) && e_player.idgun_vision_on)))
			{
				if(distance(e_player.origin, v_vortex_origin) < float(64))
				{
					e_player thread zombie_vortex::player_vortex_visionset("zm_idgun_vortex");
					if(!(isdefined(e_player.vortex_rumble) && e_player.vortex_rumble))
					{
						self thread player_vortex_rumble(e_player, v_vortex_origin);
					}
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: player_vortex_rumble
	Namespace: zm_weap_gravityspikes
	Checksum: 0x5F02671F
	Offset: 0x2628
	Size: 0xF2
	Parameters: 2
	Flags: Linked
*/
function player_vortex_rumble(e_player, v_vortex_origin)
{
	e_player endon(#"disconnect");
	e_player endon(#"bled_out");
	e_player endon(#"death");
	e_player.vortex_rumble = 1;
	e_player clientfield::set_to_player("gravity_trap_rumble", 1);
	while(distance(e_player.origin, v_vortex_origin) < float(64) && self.gravityspikes_state === 3)
	{
		wait(0.05);
	}
	e_player clientfield::set_to_player("gravity_trap_rumble", 0);
	e_player.vortex_rumble = undefined;
}

/*
	Name: plant_gravity_trap
	Namespace: zm_weap_gravityspikes
	Checksum: 0x531865B6
	Offset: 0x2728
	Size: 0x3A2
	Parameters: 1
	Flags: Linked
*/
function plant_gravity_trap(wpn_gravityspikes)
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"death");
	v_forward = anglestoforward(self.angles);
	v_right = anglestoright(self.angles);
	v_spawn_pos_right = self.origin + vectorscale((0, 0, 1), 32);
	v_spawn_pos_left = v_spawn_pos_right;
	a_trace = physicstraceex(v_spawn_pos_right, v_spawn_pos_right + (v_right * 24), vectorscale((-1, -1, -1), 16), vectorscale((1, 1, 1), 16), self);
	v_spawn_pos_right = v_spawn_pos_right + (v_right * (a_trace["fraction"] * 24));
	a_trace = physicstraceex(v_spawn_pos_left, v_spawn_pos_left + (v_right * -24), vectorscale((-1, -1, -1), 16), vectorscale((1, 1, 1), 16), self);
	v_spawn_pos_left = v_spawn_pos_left + (v_right * (a_trace["fraction"] * -24));
	v_spawn_pos_right = util::ground_position(v_spawn_pos_right, 1000, 24);
	v_spawn_pos_left = util::ground_position(v_spawn_pos_left, 1000, 24);
	a_v_spawn_pos = array(v_spawn_pos_right, v_spawn_pos_left);
	self create_gravity_trap_spikes_in_ground(a_v_spawn_pos);
	if(self isonground())
	{
		v_gravity_trap_pos = self.origin + vectorscale((0, 0, 1), 32);
	}
	else
	{
		v_gravity_trap_pos = util::ground_position(self.origin, 1000, length(vectorscale((0, 0, 1), 32)));
	}
	self gravity_trap_fx_on(v_gravity_trap_pos);
	self zm_weapons::switch_back_primary_weapon(self.w_gravityspikes_wpn_prev, 1);
	self setweaponammoclip(wpn_gravityspikes, 0);
	self.b_gravity_trap_spikes_in_ground = 1;
	self.v_gravity_trap_pos = v_gravity_trap_pos;
	self notify(#"gravity_trap_planted");
	self thread player_near_gravity_vortex(v_gravity_trap_pos);
	self thread destroy_gravity_trap_spikes_in_ground();
	self util::waittill_any("gravity_trap_spikes_retrieved", "disconnect", "bled_out");
	if(isdefined(self))
	{
		self.b_gravity_trap_spikes_in_ground = 0;
		self.disable_hero_power_charging = 0;
		self notify(#"destroy_ground_spikes");
	}
}

/*
	Name: gravity_trap_loop
	Namespace: zm_weap_gravityspikes
	Checksum: 0x4BCA5C95
	Offset: 0x2AD8
	Size: 0x1AC
	Parameters: 2
	Flags: Linked
*/
function gravity_trap_loop(v_gravity_trap_pos, wpn_gravityspikes)
{
	self endon(#"gravity_trap_spikes_retrieved");
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"death");
	is_gravity_trap_fx_on = 1;
	while(true)
	{
		if(self zm_hero_weapon::is_hero_weapon_in_use() && self.hero_power > 0)
		{
			a_zombies = getaiteamarray(level.zombie_team);
			a_zombies = array::filter(a_zombies, 0, &gravityspikes_target_filtering);
			array::thread_all(a_zombies, &gravity_trap_check, self);
		}
		else if(is_gravity_trap_fx_on)
		{
			self gravity_trap_fx_off();
			is_gravity_trap_fx_on = 0;
			self update_gravityspikes_state(4);
			util::wait_network_frame();
			self create_gravity_trap_unitrigger(v_gravity_trap_pos, wpn_gravityspikes);
			if(self zm_hero_weapon::is_hero_weapon_in_use())
			{
				self gravityspikes_power_expired(wpn_gravityspikes);
			}
			return;
		}
		wait(0.1);
	}
}

/*
	Name: gravity_trap_check
	Namespace: zm_weap_gravityspikes
	Checksum: 0x4C37855B
	Offset: 0x2C90
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function gravity_trap_check(player)
{
	player endon(#"gravity_trap_spikes_retrieved");
	player endon(#"disconnect");
	player endon(#"bled_out");
	player endon(#"death");
	/#
		assert(isdefined(level.ai_gravity_throttle));
	#/
	/#
		assert(isdefined(player));
	#/
	n_gravity_trap_radius_sq = 16384;
	v_gravity_trap_origin = player.mdl_gravity_trap_fx_source.origin;
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(self check_for_range_and_los(v_gravity_trap_origin, 96, n_gravity_trap_radius_sq))
	{
		if(self.in_gravity_trap === 1)
		{
			return;
		}
		self.in_gravity_trap = 1;
		[[ level.ai_gravity_throttle ]]->waitinqueue(self);
		if(isdefined(self) && isalive(self))
		{
			self zombie_lift(player, v_gravity_trap_origin, 0, randomintrange(184, 284), vectorscale((0, 0, -1), 24), randomintrange(64, 128));
		}
	}
}

/*
	Name: create_gravity_trap_spikes_in_ground
	Namespace: zm_weap_gravityspikes
	Checksum: 0xB3FFF473
	Offset: 0x2E48
	Size: 0x176
	Parameters: 1
	Flags: Linked
*/
function create_gravity_trap_spikes_in_ground(a_v_spawn_pos)
{
	if(!isdefined(self.mdl_gravity_trap_spikes))
	{
		self.mdl_gravity_trap_spikes = [];
	}
	for(i = 0; i < a_v_spawn_pos.size; i++)
	{
		if(!isdefined(self.mdl_gravity_trap_spikes[i]))
		{
			self.mdl_gravity_trap_spikes[i] = util::spawn_model("wpn_zmb_dlc1_talon_spike_single_world", a_v_spawn_pos[i]);
		}
		self.mdl_gravity_trap_spikes[i].origin = a_v_spawn_pos[i];
		self.mdl_gravity_trap_spikes[i].angles = self.angles;
		self.mdl_gravity_trap_spikes[i] show();
		wait(0.05);
		self.mdl_gravity_trap_spikes[i] thread gravity_spike_planted_play();
		self.mdl_gravity_trap_spikes[i] clientfield::set("gravity_trap_spike_spark", 1);
		if(isdefined(level.gravity_trap_spike_watcher))
		{
			[[level.gravity_trap_spike_watcher]](self.mdl_gravity_trap_spikes[i]);
		}
	}
}

/*
	Name: gravity_spike_planted_play
	Namespace: zm_weap_gravityspikes
	Checksum: 0x67648C38
	Offset: 0x2FC8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function gravity_spike_planted_play()
{
	wait(2);
	self thread scene::play("cin_zm_dlc1_spike_plant_loop", self);
}

/*
	Name: destroy_gravity_trap_spikes_in_ground
	Namespace: zm_weap_gravityspikes
	Checksum: 0xCCC94C93
	Offset: 0x3008
	Size: 0x186
	Parameters: 0
	Flags: Linked
*/
function destroy_gravity_trap_spikes_in_ground()
{
	mdl_spike_source = self.mdl_gravity_trap_fx_source;
	mdl_gravity_trap_spikes = self.mdl_gravity_trap_spikes;
	self util::waittill_any("destroy_ground_spikes", "disconnect", "bled_out");
	if(isdefined(mdl_spike_source))
	{
		mdl_spike_source clientfield::set("gravity_trap_location", 0);
		mdl_spike_source ghost();
		if(!isdefined(self))
		{
			mdl_spike_source delete();
		}
	}
	if(!isdefined(mdl_gravity_trap_spikes))
	{
		return;
	}
	for(i = 0; i < mdl_gravity_trap_spikes.size; i++)
	{
		mdl_gravity_trap_spikes[i] thread scene::stop("cin_zm_dlc1_spike_plant_loop");
		mdl_gravity_trap_spikes[i] clientfield::set("gravity_trap_spike_spark", 0);
		mdl_gravity_trap_spikes[i] ghost();
		if(!isdefined(self))
		{
			mdl_gravity_trap_spikes[i] delete();
		}
	}
}

/*
	Name: gravity_trap_fx_on
	Namespace: zm_weap_gravityspikes
	Checksum: 0xDB09CEDF
	Offset: 0x3198
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function gravity_trap_fx_on(v_spawn_pos)
{
	if(!isdefined(self.mdl_gravity_trap_fx_source))
	{
		self.mdl_gravity_trap_fx_source = util::spawn_model("tag_origin", v_spawn_pos);
	}
	self.mdl_gravity_trap_fx_source.origin = v_spawn_pos;
	self.mdl_gravity_trap_fx_source show();
	wait(0.05);
	self.mdl_gravity_trap_fx_source clientfield::set("gravity_trap_fx", 1);
}

/*
	Name: gravity_trap_fx_off
	Namespace: zm_weap_gravityspikes
	Checksum: 0xAC3BB5FD
	Offset: 0x3240
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function gravity_trap_fx_off()
{
	if(!isdefined(self.mdl_gravity_trap_fx_source))
	{
		return;
	}
	self.mdl_gravity_trap_fx_source clientfield::set("gravity_trap_fx", 0);
	self.mdl_gravity_trap_fx_source clientfield::set("gravity_trap_location", 1);
}

/*
	Name: create_gravity_trap_unitrigger
	Namespace: zm_weap_gravityspikes
	Checksum: 0x30348375
	Offset: 0x32A8
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function create_gravity_trap_unitrigger(v_origin, wpn_gravityspikes)
{
	if(isdefined(self.gravity_trap_unitrigger_stub))
	{
		return;
	}
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = v_origin;
	unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.radius = 128;
	unitrigger_stub.require_look_at = 0;
	unitrigger_stub.gravityspike_owner = self;
	unitrigger_stub.wpn_gravityspikes = wpn_gravityspikes;
	self.gravity_trap_unitrigger_stub = unitrigger_stub;
	zm_unitrigger::unitrigger_force_per_player_triggers(unitrigger_stub, 1);
	unitrigger_stub.prompt_and_visibility_func = &gravity_trap_trigger_visibility;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &gravity_trap_trigger_think);
}

/*
	Name: gravity_trap_trigger_visibility
	Namespace: zm_weap_gravityspikes
	Checksum: 0xDE5EC8B2
	Offset: 0x33E0
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function gravity_trap_trigger_visibility(player)
{
	if(player == self.stub.gravityspike_owner)
	{
		self sethintstring(&"ZM_CASTLE_GRAVITYSPIKE_PICKUP");
		return true;
	}
	self setinvisibletoplayer(player);
	return false;
}

/*
	Name: gravity_trap_trigger_think
	Namespace: zm_weap_gravityspikes
	Checksum: 0xB48D58C5
	Offset: 0x3450
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function gravity_trap_trigger_think()
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
		level thread gravity_trap_trigger_activate(self.stub, player);
		break;
	}
}

/*
	Name: gravity_trap_trigger_activate
	Namespace: zm_weap_gravityspikes
	Checksum: 0xFC7CDF3A
	Offset: 0x3500
	Size: 0x15A
	Parameters: 2
	Flags: Linked
*/
function gravity_trap_trigger_activate(trig_stub, player)
{
	if(player == trig_stub.gravityspike_owner)
	{
		player notify(#"gravity_trap_spikes_retrieved");
		player playsound("fly_talon_pickup");
		if(player.gravityspikes_state == 3)
		{
			player.w_gravityspikes_wpn_prev = player getcurrentweapon();
			player giveweapon(trig_stub.wpn_gravityspikes);
			player givemaxammo(trig_stub.wpn_gravityspikes);
			player setweaponammoclip(trig_stub.wpn_gravityspikes, trig_stub.wpn_gravityspikes.clipsize);
			player switchtoweapon(trig_stub.wpn_gravityspikes);
		}
		zm_unitrigger::unregister_unitrigger(trig_stub);
		player.gravity_trap_unitrigger_stub = undefined;
	}
}

/*
	Name: update_gravityspikes_state
	Namespace: zm_weap_gravityspikes
	Checksum: 0x6EF92CF8
	Offset: 0x3668
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function update_gravityspikes_state(n_gravityspikes_state)
{
	self.gravityspikes_state = n_gravityspikes_state;
}

/*
	Name: update_gravityspikes_energy
	Namespace: zm_weap_gravityspikes
	Checksum: 0xACEB333D
	Offset: 0x3688
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function update_gravityspikes_energy(n_gravityspikes_power)
{
	self.n_gravityspikes_power = n_gravityspikes_power;
	self clientfield::set_player_uimodel("zmhud.swordEnergy", self.n_gravityspikes_power);
}

/*
	Name: check_for_range_and_los
	Namespace: zm_weap_gravityspikes
	Checksum: 0x1ECF38C1
	Offset: 0x36D0
	Size: 0xF6
	Parameters: 3
	Flags: Linked
*/
function check_for_range_and_los(v_attack_source, n_allowed_z_diff, n_radius_sq)
{
	if(isalive(self))
	{
		n_z_diff = self.origin[2] - v_attack_source[2];
		if(abs(n_z_diff) < n_allowed_z_diff)
		{
			if(distance2dsquared(self.origin, v_attack_source) < n_radius_sq)
			{
				v_offset = vectorscale((0, 0, 1), 50);
				if(bullettracepassed(self.origin + v_offset, v_attack_source + v_offset, 0, self))
				{
					return true;
				}
			}
		}
	}
	return false;
}

/*
	Name: gravityspikes_target_filtering
	Namespace: zm_weap_gravityspikes
	Checksum: 0xED2EB59
	Offset: 0x37D0
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function gravityspikes_target_filtering(ai_enemy)
{
	b_callback_result = 1;
	if(isdefined(level.gravityspikes_target_filter_callback))
	{
		b_callback_result = [[level.gravityspikes_target_filter_callback]](ai_enemy);
	}
	return b_callback_result;
}

/*
	Name: zombie_lift
	Namespace: zm_weap_gravityspikes
	Checksum: 0x5A7BE68B
	Offset: 0x3820
	Size: 0x79C
	Parameters: 6
	Flags: Linked
*/
function zombie_lift(player, v_attack_source, n_push_away, n_lift_height, v_lift_offset, n_lift_speed)
{
	wpn_gravityspikes = getweapon("hero_gravityspikes_melee");
	if(isdefined(self.zombie_lift_override))
	{
		self thread [[self.zombie_lift_override]](player, v_attack_source, n_push_away, n_lift_height, v_lift_offset, n_lift_speed);
		return;
	}
	if(isdefined(self.isdog) && self.isdog || (isdefined(self.ignore_zombie_lift) && self.ignore_zombie_lift))
	{
		self.no_powerups = 1;
		self dodamage(self.health + 100, self.origin, player, player, undefined, "MOD_UNKNOWN", 0, wpn_gravityspikes);
		self playsound("zmb_talon_electrocute_swt");
	}
	else
	{
		if(level.n_zombies_lifted_for_ragdoll < 12)
		{
			self thread track_lifted_for_ragdoll_count();
			v_away_from_source = vectornormalize(self.origin - v_attack_source);
			v_away_from_source = v_away_from_source * n_push_away;
			v_away_from_source = (v_away_from_source[0], v_away_from_source[1], n_lift_height);
			a_trace = physicstraceex(self.origin + vectorscale((0, 0, 1), 32), self.origin + v_away_from_source, vectorscale((-1, -1, -1), 16), vectorscale((1, 1, 1), 16), self);
			v_lift = a_trace["fraction"] * v_away_from_source;
			v_lift = v_lift + v_lift_offset;
			n_lift_time = length(v_lift) / n_lift_speed;
			if(isdefined(self) && (isdefined(self.b_melee_kill) && self.b_melee_kill))
			{
				self setplayercollision(0);
				if(!(isdefined(level.ignore_gravityspikes_ragdoll) && level.ignore_gravityspikes_ragdoll))
				{
					self startragdoll();
					self launchragdoll((150 * anglestoup(self.angles)) + (v_away_from_source[0], v_away_from_source[1], 0));
				}
				self clientfield::set("ragdoll_impact_watch", 1);
				self clientfield::set("sparky_zombie_trail_fx", 1);
				util::wait_network_frame();
			}
			else if(isdefined(self) && v_lift[2] > 0 && length(v_lift) > length(v_lift_offset))
			{
				self setplayercollision(0);
				self clientfield::set("sparky_beam_fx", 1);
				self clientfield::set("sparky_zombie_fx", 1);
				self playsound("zmb_talon_electrocute");
				if(isdefined(self.missinglegs) && self.missinglegs)
				{
					self thread scene::play("cin_zm_dlc1_zombie_crawler_talonspike_a_loop", self);
				}
				else
				{
					self thread scene::play("cin_zm_dlc1_zombie_talonspike_loop", self);
				}
				self.mdl_trap_mover = util::spawn_model("tag_origin", self.origin, self.angles);
				self thread util::delete_on_death(self.mdl_trap_mover);
				self linkto(self.mdl_trap_mover, "tag_origin");
				self.mdl_trap_mover moveto(self.origin + v_lift, n_lift_time, 0, n_lift_time * 0.4);
				self thread zombie_lift_wacky_rotate(n_lift_time, player);
				self thread gravity_trap_notify_watcher(player);
				self waittill(#"gravity_trap_complete");
				if(isdefined(self))
				{
					self unlink();
					self scene::stop();
					self startragdoll(1);
					self clientfield::set("gravity_slam_down", 1);
					self clientfield::set("sparky_beam_fx", 0);
					self clientfield::set("sparky_zombie_fx", 0);
					self clientfield::set("sparky_zombie_trail_fx", 1);
					self thread corpse_off_navmesh_watcher();
					self clientfield::set("ragdoll_impact_watch", 1);
					v_land_pos = util::ground_position(self.origin, 1000);
					n_fall_dist = abs(self.origin[2] - v_land_pos[2]);
					n_slam_wait = (n_fall_dist / 200) * 0.75;
					if(n_slam_wait > 0)
					{
						wait(n_slam_wait);
					}
				}
			}
			if(isalive(self))
			{
				self zombie_kill_and_gib(player);
				self playsound("zmb_talon_ai_slam");
			}
		}
		else
		{
			self zombie_kill_and_gib(player);
			self playsound("zmb_talon_ai_slam");
		}
	}
}

/*
	Name: gravity_trap_notify_watcher
	Namespace: zm_weap_gravityspikes
	Checksum: 0x2BB1638C
	Offset: 0x3FC8
	Size: 0x8A
	Parameters: 1
	Flags: Linked
*/
function gravity_trap_notify_watcher(player)
{
	self endon(#"gravity_trap_complete");
	self thread gravity_trap_timeout_watcher();
	util::waittill_any_ents(self, "death", player, "gravity_trap_spikes_retrieved", player, "gravityspikes_timer_end", player, "disconnect", player, "bled_out");
	self notify(#"gravity_trap_complete");
}

/*
	Name: gravity_trap_timeout_watcher
	Namespace: zm_weap_gravityspikes
	Checksum: 0x7F565127
	Offset: 0x4060
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function gravity_trap_timeout_watcher()
{
	self endon(#"gravity_trap_complete");
	self.mdl_trap_mover util::waittill_any_timeout(4, "movedone", "gravity_trap_complete");
	if(isalive(self) && (!(isdefined(self.b_melee_kill) && self.b_melee_kill)))
	{
		wait(randomfloatrange(0.2, 1));
	}
	self notify(#"gravity_trap_complete");
}

/*
	Name: zombie_lift_wacky_rotate
	Namespace: zm_weap_gravityspikes
	Checksum: 0x841913C5
	Offset: 0x4110
	Size: 0x152
	Parameters: 2
	Flags: Linked
*/
function zombie_lift_wacky_rotate(n_lift_time, player)
{
	player endon(#"gravityspikes_timer_end");
	self endon(#"death");
	while(true)
	{
		negative_x = (randomintrange(0, 10) < 5 ? 1 : -1);
		negative_z = (randomintrange(0, 10) < 5 ? 1 : -1);
		self.mdl_trap_mover rotateto((randomintrange(90, 180) * negative_x, randomintrange(-90, 90), randomintrange(90, 180) * negative_z), (n_lift_time > 2 ? n_lift_time : 5), 0);
		self.mdl_trap_mover waittill(#"rotatedone");
	}
}

/*
	Name: zombie_kill_and_gib
	Namespace: zm_weap_gravityspikes
	Checksum: 0xF0322887
	Offset: 0x4270
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function zombie_kill_and_gib(player)
{
	wpn_gravityspikes = getweapon("hero_gravityspikes_melee");
	self.no_powerups = 1;
	self dodamage(self.health + 100, self.origin, player, player, undefined, "MOD_UNKNOWN", 0, wpn_gravityspikes);
	if(1)
	{
		n_random = randomint(100);
		if(n_random >= 20)
		{
			self zombie_utility::gib_random_parts();
		}
	}
}

/*
	Name: track_lifted_for_ragdoll_count
	Namespace: zm_weap_gravityspikes
	Checksum: 0xA87E4AF
	Offset: 0x4348
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function track_lifted_for_ragdoll_count()
{
	level.n_zombies_lifted_for_ragdoll++;
	self waittill(#"death");
	level.n_zombies_lifted_for_ragdoll--;
}

/*
	Name: corpse_off_navmesh_watcher
	Namespace: zm_weap_gravityspikes
	Checksum: 0x55DAF6AE
	Offset: 0x4370
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function corpse_off_navmesh_watcher()
{
	self waittill(#"actor_corpse", e_corpse);
	v_pos = getclosestpointonnavmesh(e_corpse.origin, 256);
	if(!isdefined(v_pos) || e_corpse.origin[2] > (v_pos[2] + 64))
	{
		e_corpse thread do_zombie_explode();
	}
}

/*
	Name: do_zombie_explode
	Namespace: zm_weap_gravityspikes
	Checksum: 0x2E603FB8
	Offset: 0x4410
	Size: 0x94
	Parameters: 0
	Flags: Linked, Private
*/
function private do_zombie_explode()
{
	util::wait_network_frame();
	if(isdefined(self))
	{
		self zombie_utility::zombie_eye_glow_stop();
		self clientfield::increment("gravity_spike_zombie_explode_fx");
		self ghost();
		self util::delay(0.25, undefined, &zm_utility::self_delete);
	}
}

/*
	Name: gravity_spike_melee_kill
	Namespace: zm_weap_gravityspikes
	Checksum: 0x53966D6E
	Offset: 0x44B0
	Size: 0xB4
	Parameters: 2
	Flags: Linked
*/
function gravity_spike_melee_kill(v_position, player)
{
	self.b_melee_kill = 1;
	n_gravity_spike_melee_radius_sq = 40000;
	if(self check_for_range_and_los(v_position, 96, n_gravity_spike_melee_radius_sq))
	{
		self zombie_lift(player, v_position, 128, randomintrange(128, 200), (0, 0, 0), randomintrange(150, 200));
	}
}

/*
	Name: knockdown_zombies_slam
	Namespace: zm_weap_gravityspikes
	Checksum: 0xDC353DD9
	Offset: 0x4570
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function knockdown_zombies_slam()
{
	v_forward = anglestoforward(self getplayerangles());
	v_pos = self.origin + vectorscale(v_forward, 24);
	a_ai = getaiteamarray(level.zombie_team);
	a_ai = array::filter(a_ai, 0, &gravityspikes_target_filtering);
	a_ai_kill_zombies = arraysortclosest(a_ai, v_pos, a_ai.size, 0, 200);
	array::thread_all(a_ai_kill_zombies, &gravity_spike_melee_kill, v_pos, self);
	a_ai_slam_zombies = arraysortclosest(a_ai, v_pos, a_ai.size, 200, 400);
	array::thread_all(a_ai_slam_zombies, &zombie_slam_direction, v_pos);
	self thread play_slam_fx(v_pos);
}

/*
	Name: play_slam_fx
	Namespace: zm_weap_gravityspikes
	Checksum: 0xC288D700
	Offset: 0x46F8
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function play_slam_fx(v_pos)
{
	mdl_fx_pos = util::spawn_model("tag_origin", v_pos, vectorscale((-1, 0, 0), 90));
	wait(0.05);
	mdl_fx_pos clientfield::set("gravity_slam_fx", 1);
	self clientfield::increment_to_player("gravity_slam_player_fx");
	wait(0.05);
	mdl_fx_pos delete();
}

/*
	Name: zombie_slam_direction
	Namespace: zm_weap_gravityspikes
	Checksum: 0x9CDA29E
	Offset: 0x47B0
	Size: 0x28C
	Parameters: 1
	Flags: Linked
*/
function zombie_slam_direction(v_position)
{
	self endon(#"death");
	if(!self.archetype === "zombie")
	{
		return;
	}
	self.knockdown = 1;
	v_zombie_to_player = v_position - self.origin;
	v_zombie_to_player_2d = vectornormalize((v_zombie_to_player[0], v_zombie_to_player[1], 0));
	v_zombie_forward = anglestoforward(self.angles);
	v_zombie_forward_2d = vectornormalize((v_zombie_forward[0], v_zombie_forward[1], 0));
	v_zombie_right = anglestoright(self.angles);
	v_zombie_right_2d = vectornormalize((v_zombie_right[0], v_zombie_right[1], 0));
	v_dot = vectordot(v_zombie_to_player_2d, v_zombie_forward_2d);
	if(v_dot >= 0.5)
	{
		self.knockdown_direction = "front";
		self.getup_direction = "getup_back";
	}
	else
	{
		if(v_dot < 0.5 && v_dot > -0.5)
		{
			v_dot = vectordot(v_zombie_to_player_2d, v_zombie_right_2d);
			if(v_dot > 0)
			{
				self.knockdown_direction = "right";
				if(math::cointoss())
				{
					self.getup_direction = "getup_back";
				}
				else
				{
					self.getup_direction = "getup_belly";
				}
			}
			else
			{
				self.knockdown_direction = "left";
				self.getup_direction = "getup_belly";
			}
		}
		else
		{
			self.knockdown_direction = "back";
			self.getup_direction = "getup_belly";
		}
	}
	wait(1);
	self.knockdown = 0;
}

/*
	Name: function_81889ac5
	Namespace: zm_weap_gravityspikes
	Checksum: 0xE226DAFF
	Offset: 0x4A48
	Size: 0x5D0
	Parameters: 0
	Flags: Linked
*/
function function_81889ac5()
{
	/#
		wait(0.05);
		level waittill(#"start_zombie_round_logic");
		wait(0.05);
		wpn_gravityspikes = getweapon("");
		equipment_id = wpn_gravityspikes.name;
		str_cmd = ((("" + equipment_id) + "") + equipment_id) + "";
		adddebugcommand(str_cmd);
		str_cmd = ((("" + equipment_id) + "") + equipment_id) + "";
		adddebugcommand(str_cmd);
		str_cmd = ((("" + equipment_id) + "") + equipment_id) + "";
		adddebugcommand(str_cmd);
		str_cmd = ((("" + equipment_id) + "") + equipment_id) + "";
		adddebugcommand(str_cmd);
		while(true)
		{
			equipment_id = getdvarstring("");
			if(equipment_id != "")
			{
				foreach(player in getplayers())
				{
					if(equipment_id == wpn_gravityspikes.name)
					{
						player zm_weapons::weapon_give(wpn_gravityspikes, 0, 1);
						player thread zm_equipment::show_hint_text(&"", 3);
						player gadgetpowerset(0, 100);
						player update_gravityspikes_state(2);
						player.n_gravityspikes_power = 1;
						level notify(#"hash_71de5140");
					}
				}
				setdvar("", "");
			}
			equipment_id = getdvarstring("");
			if(equipment_id != "")
			{
				foreach(player in getplayers())
				{
					if(equipment_id == wpn_gravityspikes.name)
					{
						gravityspikes_power_update(player);
					}
				}
				setdvar("", "");
			}
			equipment_id = getdvarstring("");
			if(equipment_id != "")
			{
				foreach(player in getplayers())
				{
					if(equipment_id == wpn_gravityspikes.name)
					{
						setdvar("", 1);
					}
				}
				setdvar("", "");
			}
			equipment_id = getdvarstring("");
			if(equipment_id != "")
			{
				foreach(player in getplayers())
				{
					if(equipment_id == wpn_gravityspikes.name)
					{
						setdvar("", 0);
					}
				}
				setdvar("", "");
			}
			wait(0.05);
		}
	#/
}

