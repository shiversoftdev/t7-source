// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_heatseekingmissile;

#using_animtree("generic");

#namespace amws;

/*
	Name: __init__sytem__
	Namespace: amws
	Checksum: 0x8B599A3E
	Offset: 0x3D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("amws", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: amws
	Checksum: 0x2E17A590
	Offset: 0x418
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	vehicle::add_main_callback("amws", &amws_initialize);
}

/*
	Name: amws_initialize
	Namespace: amws
	Checksum: 0x376B90E4
	Offset: 0x450
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function amws_initialize()
{
	self useanimtree($generic);
	target_set(self, (0, 0, 0));
	blackboard::createblackboardforentity(self);
	self blackboard::registervehicleblackboardattributes();
	self.health = self.healthdefault;
	self vehicle::friendly_fire_shield();
	self enableaimassist();
	self setneargoalnotifydist(40);
	self.fovcosine = 0;
	self.fovcosinebusy = 0.574;
	self.vehaircraftcollisionenabled = 1;
	/#
		assert(isdefined(self.scriptbundlesettings));
	#/
	self.settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	self.goalradius = 999999;
	self.goalheight = 512;
	self setgoal(self.origin, 0, self.goalradius, self.goalheight);
	self.delete_on_death = 0;
	self.overridevehicledamage = &drone_callback_damage;
	self thread vehicle_ai::nudge_collision();
	self.cobra = 0;
	self asmrequestsubstate("locomotion@movement");
	self.variant = "light_weight";
	if(issubstr(self.vehicletype, "pamws"))
	{
		self.variant = "armored";
	}
	self vehicle_ai::cooldown("cobra_up", 10);
	if(isdefined(level.vehicle_initializer_cb))
	{
		[[level.vehicle_initializer_cb]](self);
	}
	defaultrole();
}

/*
	Name: defaultrole
	Namespace: amws
	Checksum: 0x53E6F4DF
	Offset: 0x6D0
	Size: 0x30C
	Parameters: 0
	Flags: Linked
*/
function defaultrole()
{
	self vehicle_ai::init_state_machine_for_role("default");
	self vehicle_ai::get_state_callbacks("combat").enter_func = &state_combat_enter;
	self vehicle_ai::get_state_callbacks("combat").update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks("driving").update_func = &state_driving_update;
	self vehicle_ai::get_state_callbacks("emped").update_func = &state_emped_update;
	self vehicle_ai::get_state_callbacks("surge").update_func = &state_surge_update;
	self vehicle_ai::get_state_callbacks("surge").exit_func = &state_surge_exit;
	self vehicle_ai::get_state_callbacks("death").update_func = &state_death_update;
	self vehicle_ai::add_state("stationary", &state_stationary_enter, &state_stationary_update, &state_stationary_exit);
	vehicle_ai::add_interrupt_connection("stationary", "scripted", "enter_scripted");
	vehicle_ai::add_interrupt_connection("stationary", "emped", "emped");
	vehicle_ai::add_interrupt_connection("stationary", "off", "shut_off");
	vehicle_ai::add_interrupt_connection("stationary", "driving", "enter_vehicle");
	vehicle_ai::add_interrupt_connection("stationary", "pain", "pain");
	vehicle_ai::add_interrupt_connection("stationary", "surge", "surge");
	vehicle_ai::add_utility_connection("stationary", "combat");
	vehicle_ai::add_utility_connection("combat", "stationary");
	self vehicle_ai::startinitialstate("combat");
}

/*
	Name: state_death_update
	Namespace: amws
	Checksum: 0xD370A46B
	Offset: 0x9E8
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function state_death_update(params)
{
	self endon(#"death");
	death_type = vehicle_ai::get_death_type(params);
	if(!isdefined(death_type))
	{
		params.death_type = "gibbed";
		death_type = params.death_type;
	}
	if(death_type === "suicide_crash")
	{
		self death_suicide_crash(params);
	}
	self vehicle_ai::defaultstate_death_update(params);
}

/*
	Name: death_suicide_crash
	Namespace: amws
	Checksum: 0x37EEF556
	Offset: 0xAA0
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function death_suicide_crash(params)
{
	self endon(#"death");
	goaldir = anglestoforward(self.angles);
	goaldist = randomfloatrange(300, 400);
	goalpos = self.origin + (goaldir * goaldist);
	self setmaxspeedscale(880 / self getmaxspeed(1));
	self setmaxaccelerationscale(50 / self getdefaultacceleration());
	self setspeed(self.settings.surgespeedmultiplier * self.settings.defaultmovespeed);
	self setvehgoalpos(goalpos, 0);
	self util::waittill_any_timeout(3.5, "near_goal", "veh_collision");
	self setmaxspeedscale(0.1);
	self setspeed(0.1);
	self vehicle_ai::clearallmovement();
	self vehicle_ai::clearalllookingandtargeting();
	self.death_type = "gibbed";
}

/*
	Name: state_driving_update
	Namespace: amws
	Checksum: 0x1C59F4B2
	Offset: 0xC88
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function state_driving_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	driver = self getseatoccupant(0);
	if(isplayer(driver))
	{
		while(true)
		{
			driver endon(#"disconnect");
			driver util::waittill_vehicle_move_up_button_pressed();
			if(self.cobra === 0)
			{
				self cobra_raise();
			}
			else
			{
				self cobra_retract();
			}
		}
	}
}

/*
	Name: cobra_raise
	Namespace: amws
	Checksum: 0xFB2BB9EE
	Offset: 0xD58
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function cobra_raise()
{
	self.cobra = 1;
	if(isdefined(self.settings.cobra_fx_1) && isdefined(self.settings.cobra_tag_1))
	{
		playfxontag(self.settings.cobra_fx_1, self, self.settings.cobra_tag_1);
	}
	self asmrequestsubstate("cobra@stationary");
	self vehicle_ai::waittill_asm_complete("cobra@stationary", 4);
	self laseron();
}

/*
	Name: cobra_retract
	Namespace: amws
	Checksum: 0xD09BB11B
	Offset: 0xE28
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function cobra_retract()
{
	self.cobra = 0;
	self laseroff();
	self notify(#"disable_lens_flare");
	self asmrequestsubstate("locomotion@movement");
	self vehicle_ai::waittill_asm_complete("locomotion@movement", 4);
}

/*
	Name: state_emped_update
	Namespace: amws
	Checksum: 0x712CC0D1
	Offset: 0xEA0
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function state_emped_update(params)
{
	self endon(#"death");
	self endon(#"change_state");
	angles = self gettagangles("tag_turret");
	self setturrettargetrelativeangles((45, angles[1] - self.angles[1], 0), 0);
	angles = self gettagangles("tag_gunner_turret1");
	self setturrettargetrelativeangles((45, angles[1] - self.angles[1], 0), 1);
	self vehicle_ai::defaultstate_emped_update(params);
}

/*
	Name: state_surge_update
	Namespace: amws
	Checksum: 0x5BBFEE9E
	Offset: 0xFA0
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function state_surge_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	self setmaxspeedscale(880 / self getmaxspeed(1));
	self setmaxaccelerationscale(50 / self getdefaultacceleration());
	self vehicle_ai::defaultstate_surge_update(params);
}

/*
	Name: state_surge_exit
	Namespace: amws
	Checksum: 0x7E2FC0E5
	Offset: 0x1040
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function state_surge_exit(params)
{
	self setmaxspeedscale(0.1);
	self setspeed(0.1);
	self vehicle_ai::clearallmovement();
	self vehicle_ai::clearalllookingandtargeting();
}

/*
	Name: state_stationary_enter
	Namespace: amws
	Checksum: 0xA9D0AEC7
	Offset: 0x10C8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function state_stationary_enter(params)
{
	vehicle_ai::clearalllookingandtargeting();
	vehicle_ai::clearallmovement();
	self setbrake(1);
}

/*
	Name: state_stationary_update
	Namespace: amws
	Checksum: 0x3CF7ADEB
	Offset: 0x1118
	Size: 0x49C
	Parameters: 1
	Flags: Linked
*/
function state_stationary_update(params)
{
	self endon(#"death");
	self endon(#"change_state");
	self notify(#"stop_rocket_firing_thread");
	vehicle_ai::clearalllookingandtargeting();
	vehicle_ai::clearallmovement();
	wait(1);
	self cobra_raise();
	mintime = 6;
	maxtime = 12;
	transformwhenenemyclose = randomint(100) < 25;
	losepatienttime = 3 + randomfloat(2);
	starttime = gettime();
	vehicle_ai::cooldown("rocket", 2);
	evade_now = 0;
	while(true)
	{
		evade_now = self.settings.evade_enemies_locked_on_me === 1 && self.locked_on || (self.settings.evade_enemies_locking_on_me === 1 && self.locking_on);
		if(vehicle_ai::timesince(starttime) > maxtime || evade_now)
		{
			break;
		}
		if(isdefined(self.enemy))
		{
			distsqr = distancesquared(self.enemy.origin, self.origin);
			if(vehicle_ai::timesince(starttime) > mintime)
			{
				if(transformwhenenemyclose && distsqr < (200 * 200))
				{
					break;
				}
				if(!self vehseenrecently(self.enemy, losepatienttime))
				{
					break;
				}
			}
			if(self vehcansee(self.enemy))
			{
				if(distsqr < (self.settings.engagementdistmax * 3) * (self.settings.engagementdistmax * 3))
				{
					self setturrettargetent(self.enemy, vectorscale((0, 0, -1), 5));
					self setgunnertargetent(self.enemy, vectorscale((0, 0, -1), 5), 0);
					if(vehicle_ai::iscooldownready("rocket") && self.turretontarget && self.gib_rocket !== 1)
					{
						self thread firerocketlauncher(self.enemy);
						vehicle_ai::cooldown("rocket", self.settings.rocketcooldown);
					}
					weapon = self seatgetweapon(1);
					if(weapon.name == "none")
					{
						idx = 0;
					}
					else
					{
						idx = 1;
					}
					self vehicle_ai::fire_for_time(1, idx, self.enemy, 0.5);
				}
				else
				{
					break;
				}
			}
		}
		wait(0.1);
	}
	self notify(#"stop_rocket_firing_thread");
	vehicle_ai::clearalllookingandtargeting();
	vehicle_ai::clearallmovement();
	if(evade_now)
	{
		self wait_evasion_reaction_time();
	}
	else
	{
		self state_stationary_update_wait(0.5);
	}
	self cobra_retract();
	self vehicle_ai::evaluate_connections();
}

/*
	Name: state_stationary_update_wait
	Namespace: amws
	Checksum: 0x8584797
	Offset: 0x15C0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function state_stationary_update_wait(wait_time)
{
	waittill_weapon_lock_or_timeout(wait_time);
}

/*
	Name: state_stationary_exit
	Namespace: amws
	Checksum: 0xCC1AF1CE
	Offset: 0x15F0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function state_stationary_exit(params)
{
	vehicle_ai::clearalllookingandtargeting();
	vehicle_ai::clearallmovement();
	self setbrake(0);
	self vehicle_ai::cooldown("cobra_up", 10);
}

/*
	Name: state_combat_enter
	Namespace: amws
	Checksum: 0x87029BF
	Offset: 0x1660
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function state_combat_enter(params)
{
	self thread turretfireupdate();
}

/*
	Name: is_ai_using_minigun
	Namespace: amws
	Checksum: 0x7D36AD10
	Offset: 0x1690
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function is_ai_using_minigun()
{
	return true;
}

/*
	Name: turretfireupdate
	Namespace: amws
	Checksum: 0x4599F70C
	Offset: 0x16C8
	Size: 0x320
	Parameters: 0
	Flags: Linked
*/
function turretfireupdate()
{
	weapon = self seatgetweapon(1);
	if(weapon.name == "none")
	{
		return;
	}
	self endon(#"death");
	self endon(#"change_state");
	self setontargetangle(7);
	self setontargetangle(7, 0);
	while(true)
	{
		if(self.avoid_shooting_owner === 1 && isdefined(self.owner))
		{
			if(self vehicle_ai::owner_in_line_of_fire())
			{
				wait(0.5);
				continue;
			}
		}
		if(isdefined(self.enemy) && self vehcansee(self.enemy) && distancesquared(self.enemy.origin, self.origin) < (self.settings.engagementdistmax * 3) * (self.settings.engagementdistmax * 3))
		{
			self setgunnertargetent(self.enemy, (0, 0, 0), 0);
			if(self is_ai_using_minigun())
			{
				self setturretspinning(1);
			}
			wait(0.05);
			if(!self.gunner1ontarget)
			{
				wait(0.5);
			}
			if(self.gunner1ontarget)
			{
				if(isdefined(self.enemy) && self vehcansee(self.enemy))
				{
					self vehicle_ai::fire_for_time(randomfloatrange(self.settings.burstfiredurationmin, self.settings.burstfiredurationmax), 1, self.enemy);
				}
				if(self is_ai_using_minigun())
				{
					self setturretspinning(0);
				}
				if(isdefined(self.enemy) && isai(self.enemy))
				{
					wait(randomfloatrange(self.settings.burstfireaidelaymin, self.settings.burstfireaidelaymax));
				}
				else
				{
					wait(randomfloatrange(self.settings.burstfiredelaymin, self.settings.burstfiredelaymax));
				}
			}
			else
			{
				wait(0.5);
			}
		}
		else
		{
			wait(0.4);
		}
	}
}

/*
	Name: state_combat_update
	Namespace: amws
	Checksum: 0x92373BDE
	Offset: 0x19F0
	Size: 0x750
	Parameters: 1
	Flags: Linked
*/
function state_combat_update(params)
{
	self endon(#"change_state");
	self endon(#"death");
	lasttimechangeposition = 0;
	self.shouldgotonewposition = 0;
	self.lasttimetargetinsight = 0;
	heatseekingmissile::initlockfield(self);
	self.lock_evading = 0;
	for(;;)
	{
		if(self.lock_evading == 0)
		{
			self setspeed(self.settings.defaultmovespeed);
			self setacceleration((isdefined(self.settings.default_move_acceleration) ? self.settings.default_move_acceleration : 10));
		}
		if(randomint(100) < 3 && vehicle_ai::iscooldownready("cobra_up") && self.lock_evading == 0)
		{
			if(isdefined(self.enemy) && distancesquared(self.enemy.origin, self.origin) > (200 * 200))
			{
				if(distancesquared(self.enemy.origin, self.origin) < (self.settings.engagementdistmax * 2) * (self.settings.engagementdistmax * 2))
				{
					self vehicle_ai::evaluate_connections();
				}
			}
		}
		if(self.settings.engage_enemies_locked_on_me === 1 && self.locked_on)
		{
			loc_00001C2C:
			self vehicle_ai::updatepersonalthreatbias_attackerlockedontome((isdefined(self.settings.enemies_locked_on_me_threat_bias) ? self.settings.enemies_locked_on_me_threat_bias : 5000), (isdefined(self.settings.enemies_locked_on_me_threat_bias_duration) ? self.settings.enemies_locked_on_me_threat_bias_duration : 1));
			self.shouldgotonewposition = 1;
		}
		else if(self.settings.engage_enemies_locking_on_me === 1 && self.locking_on)
		{
			loc_00001CCC:
			self vehicle_ai::updatepersonalthreatbias_attackerlockingontome((isdefined(self.settings.enemies_locking_on_me_threat_bias) ? self.settings.enemies_locking_on_me_threat_bias : 2000), (isdefined(self.settings.enemies_locking_on_me_threat_bias_duration) ? self.settings.enemies_locking_on_me_threat_bias_duration : 1));
			self.shouldgotonewposition = 1;
		}
		self.lock_evading = 0;
		if(self.settings.evade_enemies_locked_on_me === 1)
		{
			self.lock_evading = self.lock_evading | self.locked_on;
		}
		if(self.settings.evade_enemies_locking_on_me === 1)
		{
			self.lock_evading = self.lock_evading | self.locking_on;
			self.lock_evading = self.lock_evading | self.locking_on_hacking;
		}
		if(isdefined(self.inpain) && self.inpain)
		{
			wait(0.1);
			continue;
		}
		if(!isdefined(self.enemy))
		{
			should_slow_down_at_goal = 1;
			if(self.lock_evading)
			{
				self.current_pathto_pos = getnextmoveposition_evasive(self.lock_evading);
				should_slow_down_at_goal = 0;
			}
			else
			{
				self.current_pathto_pos = getnextmoveposition_wander();
			}
			if(isdefined(self.current_pathto_pos))
			{
				if(self setvehgoalpos(self.current_pathto_pos, should_slow_down_at_goal, 1))
				{
					self thread path_update_interrupt_by_attacker();
					self thread path_update_interrupt();
					self vehicle_ai::waittill_pathing_done();
					self notify(#"amws_end_interrupt_watch");
					self playsound("veh_amws_scan");
				}
			}
			self state_combat_update_wait(0.5);
			continue;
		}
		self setturrettargetent(self.enemy);
		if(self vehcansee(self.enemy))
		{
			self.lasttimetargetinsight = gettime();
		}
		if(self.shouldgotonewposition == 0)
		{
			if(gettime() > (lasttimechangeposition + 1000))
			{
				self.shouldgotonewposition = 1;
			}
			else if(gettime() > (self.lasttimetargetinsight + 500))
			{
				self.shouldgotonewposition = 1;
			}
		}
		if(self.shouldgotonewposition)
		{
			should_slow_down_at_goal = 1;
			if(self.lock_evading)
			{
				self.current_pathto_pos = getnextmoveposition_evasive(self.lock_evading);
				should_slow_down_at_goal = 0;
			}
			else
			{
				self.current_pathto_pos = getnextmoveposition_tactical(self.enemy);
			}
			if(isdefined(self.current_pathto_pos))
			{
				if(self setvehgoalpos(self.current_pathto_pos, should_slow_down_at_goal, 1))
				{
					self thread path_update_interrupt_by_attacker();
					self thread path_update_interrupt();
					self vehicle_ai::waittill_pathing_done();
					self notify(#"amws_end_interrupt_watch");
				}
				if(isdefined(self.enemy) && vehicle_ai::iscooldownready("rocket", 0.5) && self vehcansee(self.enemy) && self.gib_rocket !== 1)
				{
					self thread aim_and_fire_rocket_launcher(0.4);
				}
				lasttimechangeposition = gettime();
				self.shouldgotonewposition = 0;
			}
		}
		self state_combat_update_wait(0.5);
	}
}

/*
	Name: aim_and_fire_rocket_launcher
	Namespace: amws
	Checksum: 0x1B0F2D31
	Offset: 0x2148
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function aim_and_fire_rocket_launcher(aim_time)
{
	self endon(#"death");
	self endon(#"change_state");
	self notify(#"stop_rocket_firing_thread");
	self endon(#"stop_rocket_firing_thread");
	if(!self.turretontarget)
	{
		wait(aim_time);
	}
	if(isdefined(self.enemy) && self.turretontarget)
	{
		vehicle_ai::cooldown("rocket", self.settings.rocketcooldown);
		self thread firerocketlauncher(self.enemy);
	}
}

/*
	Name: state_combat_update_wait
	Namespace: amws
	Checksum: 0xC4B60E4C
	Offset: 0x2200
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function state_combat_update_wait(wait_time)
{
	self waittill_weapon_lock_or_timeout(wait_time);
}

/*
	Name: waittill_weapon_lock_or_timeout
	Namespace: amws
	Checksum: 0x9DAF4C59
	Offset: 0x2230
	Size: 0x1CC
	Parameters: 1
	Flags: Linked
*/
function waittill_weapon_lock_or_timeout(wait_time)
{
	if(self.lock_evade_now === 1)
	{
		perform_evasion_reaction_wait = 1;
	}
	else
	{
		locked_on_notify = undefined;
		locking_on_notify = undefined;
		reacting_to_locks = self.settings.evade_enemies_locked_on_me === 1 || self.settings.engage_enemies_locked_on_me === 1;
		reacting_to_locking = self.settings.evade_enemies_locking_on_me === 1 || self.settings.engage_enemies_locking_on_me === 1;
		previous_locked_on_to_me = self.locked_on;
		previous_locking_on_to_me = self.locking_on;
		if(reacting_to_locks)
		{
			locked_on_notify = "missle_lock";
		}
		if(reacting_to_locking)
		{
			locking_on_notify = "locking on";
		}
		self util::waittill_any_timeout(wait_time, "damage", locking_on_notify, locked_on_notify);
		locked_on_to_me_just_changed = previous_locked_on_to_me != self.locked_on && self.locked_on;
		locking_on_to_me_just_changed = previous_locking_on_to_me != self.locking_on && self.locking_on;
		perform_evasion_reaction_wait = reacting_to_locks && locked_on_to_me_just_changed || (reacting_to_locking && locking_on_to_me_just_changed);
	}
	if(perform_evasion_reaction_wait)
	{
		self wait_evasion_reaction_time();
	}
}

/*
	Name: wait_evasion_reaction_time
	Namespace: amws
	Checksum: 0x9D8515ED
	Offset: 0x2408
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function wait_evasion_reaction_time()
{
	loc_0000243C:
	wait(randomfloatrange((isdefined(self.settings.enemy_evasion_reaction_time_min) ? self.settings.enemy_evasion_reaction_time_min : 0.1), (isdefined(self.settings.enemy_evasion_reaction_time_max) ? self.settings.enemy_evasion_reaction_time_max : 0.2)));
}

/*
	Name: firerocketlauncher
	Namespace: amws
	Checksum: 0xD51F859E
	Offset: 0x2488
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function firerocketlauncher(enemy)
{
	self endon(#"death");
	self endon(#"change_state");
	self notify(#"stop_rocket_firing_thread");
	self endon(#"stop_rocket_firing_thread");
	if(isdefined(enemy))
	{
		self setturrettargetent(enemy);
		self util::waittill_any_timeout(1, "turret_on_target");
		if(self.variant == "armored")
		{
			vehicle_ai::fire_for_rounds(1, 0, enemy);
		}
		else
		{
			vehicle_ai::fire_for_rounds(2, 0, enemy);
		}
	}
}

/*
	Name: getnextmoveposition_wander
	Namespace: amws
	Checksum: 0xBE426544
	Offset: 0x2560
	Size: 0x34A
	Parameters: 0
	Flags: Linked
*/
function getnextmoveposition_wander()
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	querymultiplier = 1.5;
	queryresult = positionquery_source_navigation(self.origin, 80, 500 * querymultiplier, 250, (3 * self.radius) * querymultiplier, self, self.radius * querymultiplier);
	if(queryresult.data.size == 0)
	{
		queryresult = positionquery_source_navigation(self.origin, 36, 120, 240, self.radius, self);
	}
	positionquery_filter_distancetogoal(queryresult, self);
	vehicle_ai::positionquery_filter_outofgoalanchor(queryresult);
	positionquery_filter_inclaimedlocation(queryresult, self);
	best_point = undefined;
	best_score = -999999;
	foreach(point in queryresult.data)
	{
		randomscore = randomfloatrange(0, 100);
		disttooriginscore = point.disttoorigin2d * 0.2;
		if(point.inclaimedlocation)
		{
			point.score = point.score - 500;
		}
		point.score = point.score + (randomscore + disttooriginscore);
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	/#
		self.debug_ai_move_to_points_considered = queryresult.data;
	#/
	if(!isdefined(best_point))
	{
		/#
			self.debug_ai_movement_type = ("" + queryresult.data.size) + "";
		#/
		/#
			self.debug_ai_move_to_point = undefined;
		#/
		return undefined;
	}
	/#
		self.debug_ai_movement_type = "" + queryresult.data.size;
	#/
	/#
		self.debug_ai_move_to_point = best_point.origin;
	#/
	return best_point.origin;
}

/*
	Name: getnextmoveposition_evasive
	Namespace: amws
	Checksum: 0xFE62B7C5
	Offset: 0x28B8
	Size: 0x89A
	Parameters: 1
	Flags: Linked
*/
function getnextmoveposition_evasive(client_flags)
{
	/#
		assert(isdefined(client_flags));
	#/
	self setspeed(self.settings.defaultmovespeed * (isdefined(self.settings.lock_evade_speed_boost) ? self.settings.lock_evade_speed_boost : 2));
	loc_00002A1C:
	self setacceleration((isdefined(self.settings.default_move_acceleration) ? self.settings.default_move_acceleration : 10) * (isdefined(self.settings.lock_evade_acceleration_boost) ? self.settings.lock_evade_acceleration_boost : 2));
	loc_00002A94:
	loc_00002AE0:
	loc_00002B1C:
	queryresult = positionquery_source_navigation(self.origin, (isdefined(self.settings.lock_evade_dist_min) ? self.settings.lock_evade_dist_min : 120), (isdefined(self.settings.lock_evade_dist_max) ? self.settings.lock_evade_dist_max : 360), math::clamp((isdefined(self.settings.lock_evade_dist_half_height) ? self.settings.lock_evade_dist_half_height : 250), 0.1, 99000), (isdefined(self.settings.lock_evade_point_spacing_factor) ? self.settings.lock_evade_point_spacing_factor : 1.5) * self.radius, self);
	positionquery_filter_inclaimedlocation(queryresult, self);
	foreach(point in queryresult.data)
	{
		if(point.inclaimedlocation)
		{
			/#
				if(!isdefined(point._scoredebug))
				{
					point._scoredebug = [];
				}
				point._scoredebug[""] = -500;
			#/
			point.score = point.score + -500;
		}
	}
	remaining_lock_threats_to_evaluate = 3;
	remaining_flags_to_process = client_flags;
	for(i = 0; remaining_flags_to_process && remaining_lock_threats_to_evaluate > 0 && i < level.players.size; i++)
	{
		attacker = level.players[i];
		if(isdefined(attacker))
		{
			client_flag = 1 << attacker getentitynumber();
			if(client_flag & remaining_flags_to_process)
			{
				positionquery_filter_directness(queryresult, self.origin, attacker.origin);
				foreach(point in queryresult.data)
				{
					abs_directness = abs(point.directness);
					if(abs_directness < 0.2)
					{
						/#
							if(!isdefined(point._scoredebug))
							{
								point._scoredebug = [];
							}
							point._scoredebug[""] = 200;
						#/
						point.score = point.score + 200;
						continue;
					}
					if(abs_directness > (isdefined(self.settings.lock_evade_enemy_line_of_sight_directness) ? self.settings.lock_evade_enemy_line_of_sight_directness : 0.9))
					{
						/#
							if(!isdefined(point._scoredebug))
							{
								point._scoredebug = [];
							}
							point._scoredebug[""] = -101;
						#/
						point.score = point.score + -101;
					}
				}
				remaining_flags_to_process = remaining_flags_to_process & (~client_flag);
				remaining_lock_threats_to_evaluate--;
			}
		}
	}
	positionquery_filter_directness(queryresult, self.origin, self.origin + (anglestoforward(self.angles) * 360));
	foreach(point in queryresult.data)
	{
		if(point.directness > 0.5)
		{
			/#
				if(!isdefined(point._scoredebug))
				{
					point._scoredebug = [];
				}
				point._scoredebug[""] = 105;
			#/
			point.score = point.score + 105;
		}
	}
	best_point = undefined;
	best_score = -999999;
	foreach(point in queryresult.data)
	{
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self.lock_evade_now = 0;
	self vehicle_ai::positionquery_debugscores(queryresult);
	/#
		self.debug_ai_move_to_points_considered = queryresult.data;
	#/
	if(!isdefined(best_point))
	{
		/#
			self.debug_ai_movement_type = ("" + queryresult.data.size) + "";
		#/
		/#
			self.debug_ai_move_to_point = undefined;
		#/
		return undefined;
	}
	/#
		self.debug_ai_movement_type = "" + queryresult.data.size;
	#/
	/#
		self.debug_ai_move_to_point = best_point.origin;
	#/
	return best_point.origin;
}

/*
	Name: getnextmoveposition_tactical
	Namespace: amws
	Checksum: 0x55B81EF9
	Offset: 0x3160
	Size: 0x91A
	Parameters: 1
	Flags: Linked
*/
function getnextmoveposition_tactical(enemy)
{
	if(self.goalforced)
	{
		return self.goalpos;
	}
	selfdisttotarget = distance2d(self.origin, enemy.origin);
	gooddist = 0.5 * (self.settings.engagementdistmin + self.settings.engagementdistmax);
	tooclosedist = 0.4 * (self.settings.engagementdistmin + self.settings.engagementdistmax);
	closedist = 1.2 * gooddist;
	fardist = 3 * gooddist;
	querymultiplier = mapfloat(closedist, fardist, 1, 3, selfdisttotarget);
	prefereddirectness = 0;
	if(selfdisttotarget > gooddist)
	{
		prefereddirectness = mapfloat(closedist, fardist, 0, 1, selfdisttotarget);
	}
	else
	{
		prefereddirectness = mapfloat(tooclosedist * 0.4, tooclosedist, -1, -0.6, selfdisttotarget);
	}
	prefereddistawayfromorigin = 300;
	randomness = 30;
	queryresult = positionquery_source_navigation(self.origin, 80, 500 * querymultiplier, 250, (2 * self.radius) * querymultiplier, self, (1 * self.radius) * querymultiplier);
	positionquery_filter_directness(queryresult, self.origin, enemy.origin);
	positionquery_filter_distancetogoal(queryresult, self);
	vehicle_ai::positionquery_filter_outofgoalanchor(queryresult);
	positionquery_filter_inclaimedlocation(queryresult, self);
	vehicle_ai::positionquery_filter_engagementdist(queryresult, enemy, self.settings.engagementdistmin, self.settings.engagementdistmax);
	if(isdefined(self.avoidentities) && isdefined(self.avoidentitiesdistance))
	{
		vehicle_ai::positionquery_filter_distawayfromtarget(queryresult, self.avoidentities, self.avoidentitiesdistance, -500);
	}
	best_point = undefined;
	best_score = -999999;
	foreach(point in queryresult.data)
	{
		difftoprefereddirectness = abs(point.directness - prefereddirectness);
		directnessscore = mapfloat(0, 1, 100, 0, difftoprefereddirectness);
		if(difftoprefereddirectness > 0.2)
		{
			directnessscore = directnessscore - 200;
		}
		/#
			if(!isdefined(point._scoredebug))
			{
				point._scoredebug = [];
			}
			point._scoredebug[""] = point.directness;
		#/
		point.score = point.score + point.directness;
		/#
			if(!isdefined(point._scoredebug))
			{
				point._scoredebug = [];
			}
			point._scoredebug[""] = directnessscore;
		#/
		point.score = point.score + directnessscore;
		/#
			if(!isdefined(point._scoredebug))
			{
				point._scoredebug = [];
			}
			point._scoredebug[""] = mapfloat(0, prefereddistawayfromorigin, 0, 100, point.disttoorigin2d);
		#/
		point.score = point.score + mapfloat(0, prefereddistawayfromorigin, 0, 100, point.disttoorigin2d);
		targetdistscore = 0;
		if(point.targetdist < tooclosedist)
		{
			targetdistscore = targetdistscore - 200;
		}
		if(point.inclaimedlocation)
		{
			/#
				if(!isdefined(point._scoredebug))
				{
					point._scoredebug = [];
				}
				point._scoredebug[""] = -500;
			#/
			point.score = point.score + -500;
		}
		/#
			if(!isdefined(point._scoredebug))
			{
				point._scoredebug = [];
			}
			point._scoredebug[""] = targetdistscore;
		#/
		point.score = point.score + targetdistscore;
		/#
			if(!isdefined(point._scoredebug))
			{
				point._scoredebug = [];
			}
			point._scoredebug[""] = randomfloatrange(0, randomness);
		#/
		point.score = point.score + randomfloatrange(0, randomness);
		if(point.score > best_score)
		{
			best_score = point.score;
			best_point = point;
		}
	}
	self vehicle_ai::positionquery_debugscores(queryresult);
	/#
		self.debug_ai_move_to_points_considered = queryresult.data;
	#/
	if(!isdefined(best_point))
	{
		/#
			self.debug_ai_movement_type = ("" + queryresult.data.size) + "";
		#/
		/#
			self.debug_ai_move_to_point = undefined;
		#/
		return undefined;
	}
	/#
		if(isdefined(getdvarint("")) && getdvarint(""))
		{
			recordline(self.origin, best_point.origin, (0.3, 1, 0));
			recordline(self.origin, enemy.origin, (1, 0, 0.4));
		}
	#/
	/#
		self.debug_ai_movement_type = "" + queryresult.data.size;
	#/
	/#
		self.debug_ai_move_to_point = best_point.origin;
	#/
	return best_point.origin;
}

/*
	Name: path_update_interrupt_by_attacker
	Namespace: amws
	Checksum: 0x6373A229
	Offset: 0x3A88
	Size: 0xDE
	Parameters: 0
	Flags: Linked
*/
function path_update_interrupt_by_attacker()
{
	self endon(#"death");
	self endon(#"change_state");
	self endon(#"near_goal");
	self endon(#"reached_end_node");
	self endon(#"amws_end_interrupt_watch");
	self util::waittill_any("locking on", "missile_lock", "damage");
	if(self.locked_on || self.locking_on)
	{
		/#
			self.debug_ai_move_to_points_considered = [];
		#/
		/#
			self.debug_ai_movement_type = "";
		#/
		/#
			self.debug_ai_move_to_point = undefined;
		#/
		self clearvehgoalpos();
		self.lock_evade_now = 1;
	}
	self notify(#"near_goal");
}

/*
	Name: path_update_interrupt
	Namespace: amws
	Checksum: 0x4CF3B255
	Offset: 0x3B70
	Size: 0x1D0
	Parameters: 0
	Flags: Linked
*/
function path_update_interrupt()
{
	self endon(#"death");
	self endon(#"change_state");
	self endon(#"near_goal");
	self endon(#"reached_end_node");
	self endon(#"amws_end_interrupt_watch");
	wait(1);
	while(true)
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(distance2dsquared(self.current_pathto_pos, self.goalpos) > (self.goalradius * self.goalradius))
			{
				wait(0.2);
				self notify(#"near_goal");
			}
		}
		if(isdefined(self.enemy))
		{
			if(self vehcansee(self.enemy) && distance2dsquared(self.origin, self.enemy.origin) < (0.4 * (self.settings.engagementdistmin + self.settings.engagementdistmax)) * (0.4 * (self.settings.engagementdistmin + self.settings.engagementdistmax)))
			{
				self notify(#"near_goal");
			}
			if(vehicle_ai::iscooldownready("rocket") && vehicle_ai::iscooldownready("rocket_launcher_check"))
			{
				vehicle_ai::cooldown("rocket_launcher_check", 2.5);
				self notify(#"near_goal");
			}
		}
		wait(0.2);
	}
}

/*
	Name: gib
	Namespace: amws
	Checksum: 0x17B123D9
	Offset: 0x3D48
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function gib(attacker)
{
	if(self.gibbed !== 1)
	{
		self vehicle::do_gib_dynents();
		self.gibbed = 1;
		self.death_type = "suicide_crash";
		self kill(self.origin + vectorscale((0, 0, 1), 10), attacker);
	}
}

/*
	Name: drone_callback_damage
	Namespace: amws
	Checksum: 0x65936A9B
	Offset: 0x3DD8
	Size: 0xD4
	Parameters: 15
	Flags: Linked
*/
function drone_callback_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	idamage = vehicle_ai::shared_callback_damage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
	return idamage;
}

