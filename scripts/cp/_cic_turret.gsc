// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

#namespace cic_turret;

/*
	Name: __init__sytem__
	Namespace: cic_turret
	Checksum: 0x8A6E355
	Offset: 0x500
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("cic_turret", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: cic_turret
	Checksum: 0x6BA16EA4
	Offset: 0x540
	Size: 0x1B6
	Parameters: 0
	Flags: None
*/
function __init__()
{
	vehicle::add_main_callback("turret_cic", &cic_turret_think);
	vehicle::add_main_callback("turret_cic_world", &cic_turret_think);
	vehicle::add_main_callback("turret_sentry", &cic_turret_think);
	vehicle::add_main_callback("turret_sentry_world", &cic_turret_think);
	vehicle::add_main_callback("turret_sentry_cic", &cic_turret_think);
	vehicle::add_main_callback("turret_sentry_rts", &cic_turret_think);
	level._effect["cic_turret_damage01"] = "destruct/fx_dest_turret_1";
	level._effect["cic_turret_damage02"] = "destruct/fx_dest_turret_2";
	level._effect["sentry_turret_damage01"] = "destruct/fx_dest_turret_1";
	level._effect["sentry_turret_damage02"] = "destruct/fx_dest_turret_2";
	level._effect["cic_turret_death"] = "_t6/destructibles/fx_cic_turret_death";
	level._effect["cic_turret_stun"] = "_t6/electrical/fx_elec_sp_emp_stun_cic_turret";
	level._effect["sentry_turret_stun"] = "_t6/electrical/fx_elec_sp_emp_stun_sentry_turret";
}

/*
	Name: cic_turret_think
	Namespace: cic_turret
	Checksum: 0x34715B9C
	Offset: 0x700
	Size: 0x2DC
	Parameters: 0
	Flags: None
*/
function cic_turret_think()
{
	self enableaimassist();
	if(issubstr(self.vehicletype, "cic"))
	{
		self.scanning_arc = 60;
		self.default_pitch = 15;
	}
	else
	{
		self.scanning_arc = 60;
		self.default_pitch = 0;
	}
	self.state_machine = statemachine::create("brain", self);
	main = self.state_machine statemachine::add_state("main", undefined, &cic_turret_main, undefined);
	scripted = self.state_machine statemachine::add_state("scripted", undefined, &cic_turret_scripted, undefined);
	vehicle_ai::set_role("brain");
	vehicle_ai::add_interrupt_connection("main", "scripted", "enter_vehicle");
	vehicle_ai::add_interrupt_connection("main", "scripted", "scripted");
	vehicle_ai::add_interrupt_connection("scripted", "main", "exit_vehicle");
	vehicle_ai::add_interrupt_connection("scripted", "main", "scripted_done");
	self disconnectpaths();
	self thread cic_turret_death();
	self thread cic_turret_damage();
	self thread turret::track_lens_flare();
	self.overridevehicledamage = &cicturretcallback_vehicledamage;
	if(isdefined(self.script_startstate))
	{
		if(self.script_startstate == "off")
		{
			self cic_turret_off(self.angles);
		}
		else
		{
			self.state_machine statemachine::set_state(self.script_startstate);
		}
	}
	else
	{
		cic_turret_start_ai();
	}
	self laseron();
}

/*
	Name: cic_turret_start_scripted
	Namespace: cic_turret
	Checksum: 0xC2E6879B
	Offset: 0x9E8
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function cic_turret_start_scripted()
{
	self.state_machine statemachine::set_state("scripted");
}

/*
	Name: cic_turret_start_ai
	Namespace: cic_turret
	Checksum: 0xF2E06DF2
	Offset: 0xA18
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function cic_turret_start_ai()
{
	self.state_machine statemachine::set_state("main");
}

/*
	Name: cic_turret_main
	Namespace: cic_turret
	Checksum: 0x71837B3E
	Offset: 0xA48
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function cic_turret_main(params)
{
	if(isalive(self))
	{
		self enableaimassist();
		self thread cic_turret_fireupdate();
	}
}

/*
	Name: cic_turret_off
	Namespace: cic_turret
	Checksum: 0x44F56E9F
	Offset: 0xAA8
	Size: 0x168
	Parameters: 1
	Flags: None
*/
function cic_turret_off(angles)
{
	self.state_machine statemachine::set_state("scripted");
	self vehicle::lights_off();
	self laseroff();
	self vehicle::toggle_sounds(0);
	self vehicle::toggle_exhaust_fx(0);
	if(!isdefined(angles))
	{
		angles = self gettagangles("tag_flash");
	}
	target_vec = self.origin + (anglestoforward((0, angles[1], 0)) * 1000);
	target_vec = target_vec + (vectorscale((0, 0, -1), 1700));
	self settargetorigin(target_vec);
	self.off = 1;
	if(!isdefined(self.emped))
	{
		self disableaimassist();
	}
	self.ignoreme = 1;
}

/*
	Name: cic_turret_on
	Namespace: cic_turret
	Checksum: 0x5FBE3CA5
	Offset: 0xC18
	Size: 0xE0
	Parameters: 0
	Flags: None
*/
function cic_turret_on()
{
	self endon(#"death");
	self playsound("veh_cic_turret_boot");
	self vehicle::lights_on();
	self enableaimassist();
	self vehicle::toggle_sounds(1);
	self bootup();
	self vehicle::toggle_exhaust_fx(1);
	self.off = undefined;
	self laseron();
	cic_turret_start_ai();
	self.ignoreme = 0;
}

/*
	Name: bootup
	Namespace: cic_turret
	Checksum: 0x35465245
	Offset: 0xD00
	Size: 0x118
	Parameters: 0
	Flags: None
*/
function bootup()
{
	for(i = 0; i < 6; i++)
	{
		wait(0.1);
		vehicle::lights_off();
		wait(0.1);
		vehicle::lights_on();
	}
	if(!isdefined(self.player))
	{
		angles = self gettagangles("tag_flash");
		target_vec = self.origin + (anglestoforward((self.default_pitch, angles[1], 0)) * 1000);
		self.turretrotscale = 0.3;
		self settargetorigin(target_vec);
		wait(1);
		self.turretrotscale = 1;
	}
}

/*
	Name: cic_turret_fireupdate
	Namespace: cic_turret
	Checksum: 0xB9C163CD
	Offset: 0xE20
	Size: 0x498
	Parameters: 0
	Flags: None
*/
function cic_turret_fireupdate()
{
	self endon(#"death");
	self endon(#"change_state");
	cant_see_enemy_count = 0;
	wait(0.2);
	origin = self gettagorigin("tag_barrel");
	left_look_at_pt = origin + ((anglestoforward(self.angles + (self.default_pitch, self.scanning_arc, 0))) * 1000);
	right_look_at_pt = origin + ((anglestoforward(self.angles + (self.default_pitch, self.scanning_arc * -1, 0))) * 1000);
	while(true)
	{
		if(isdefined(self.enemy) && self vehcansee(self.enemy))
		{
			self.turretrotscale = 1;
			if(cant_see_enemy_count > 0 && isplayer(self.enemy))
			{
				cic_turret_alert_sound();
				wait(0.5);
			}
			cant_see_enemy_count = 0;
			for(i = 0; i < 3; i++)
			{
				if(isdefined(self.enemy) && isalive(self.enemy) && self vehcansee(self.enemy))
				{
					self setturrettargetent(self.enemy);
					wait(0.1);
					self cic_turret_fire_for_time(randomfloatrange(0.4, 1.5));
				}
				else
				{
					self cleartargetentity();
				}
				if(isdefined(self.enemy) && isplayer(self.enemy))
				{
					wait(randomfloatrange(0.3, 0.6));
					continue;
				}
				wait(randomfloatrange(0.3, 0.6) * 2);
			}
			if(isdefined(self.enemy) && isalive(self.enemy) && self vehcansee(self.enemy))
			{
				if(isplayer(self.enemy))
				{
					wait(randomfloatrange(0.5, 1.3));
				}
				else
				{
					wait(randomfloatrange(0.5, 1.3) * 2);
				}
			}
		}
		else
		{
			self.turretrotscale = 0.25;
			cant_see_enemy_count++;
			wait(1);
			if(cant_see_enemy_count > 1)
			{
				self.turret_state = 0;
				while(!isdefined(self.enemy) || !self vehcansee(self.enemy))
				{
					if(self.turretontarget)
					{
						self.turret_state++;
						if(self.turret_state > 1)
						{
							self.turret_state = 0;
						}
					}
					if(self.turret_state == 0)
					{
						self setturrettargetvec(left_look_at_pt);
					}
					else
					{
						self setturrettargetvec(right_look_at_pt);
					}
					wait(0.5);
				}
			}
			else
			{
				self cleartargetentity();
			}
		}
		wait(0.5);
	}
}

/*
	Name: cic_turret_scripted
	Namespace: cic_turret
	Checksum: 0x849787E2
	Offset: 0x12C0
	Size: 0xC4
	Parameters: 1
	Flags: None
*/
function cic_turret_scripted(params)
{
	driver = self getseatoccupant(0);
	if(isdefined(driver))
	{
		self.turretrotscale = 1;
		self disableaimassist();
		if(driver == level.players[0])
		{
			self thread vehicle_death::vehicle_damage_filter("firestorm_turret");
			level.players[0] thread cic_overheat_hud(self);
		}
	}
	self cleartargetentity();
}

/*
	Name: cic_turret_get_damage_effect
	Namespace: cic_turret
	Checksum: 0x1F3E6725
	Offset: 0x1390
	Size: 0xA8
	Parameters: 1
	Flags: None
*/
function cic_turret_get_damage_effect(health_pct)
{
	if(issubstr(self.vehicletype, "turret_sentry"))
	{
		if(health_pct < 0.6)
		{
			return level._effect["sentry_turret_damage02"];
		}
		return level._effect["sentry_turret_damage01"];
	}
	if(health_pct < 0.6)
	{
		return level._effect["cic_turret_damage02"];
	}
	return level._effect["cic_turret_damage01"];
}

/*
	Name: cic_turret_play_single_fx_on_tag
	Namespace: cic_turret
	Checksum: 0x23638C18
	Offset: 0x1448
	Size: 0x1B0
	Parameters: 2
	Flags: None
*/
function cic_turret_play_single_fx_on_tag(effect, tag)
{
	if(isdefined(self.damage_fx_ent))
	{
		if(self.damage_fx_ent.effect == effect)
		{
			return;
		}
		self.damage_fx_ent delete();
	}
	if(!isdefined(self gettagangles(tag)))
	{
		return;
	}
	ent = spawn("script_model", (0, 0, 0));
	ent setmodel("tag_origin");
	ent.origin = self gettagorigin(tag);
	ent.angles = self gettagangles(tag);
	ent notsolid();
	ent hide();
	ent linkto(self, tag);
	ent.effect = effect;
	playfxontag(effect, ent, "tag_origin");
	ent playsound("veh_cic_turret_sparks");
	self.damage_fx_ent = ent;
}

/*
	Name: cic_turret_damage
	Namespace: cic_turret
	Checksum: 0xC8EC1E6D
	Offset: 0x1600
	Size: 0x98
	Parameters: 0
	Flags: None
*/
function cic_turret_damage()
{
	self endon(#"crash_done");
	while(isdefined(self))
	{
		self waittill(#"damage");
		if(self.health > 0)
		{
			effect = self cic_turret_get_damage_effect(self.health / self.healthdefault);
			tag = "tag_fx";
			cic_turret_play_single_fx_on_tag(effect, tag);
		}
		wait(0.3);
	}
}

/*
	Name: cic_turret_death
	Namespace: cic_turret
	Checksum: 0xB5C7BA71
	Offset: 0x16A0
	Size: 0x244
	Parameters: 0
	Flags: None
*/
function cic_turret_death()
{
	wait(0.1);
	self notify(#"nodeath_thread");
	self waittill(#"death", attacker, damagefromunderneath, weapon, point, dir);
	if(isdefined(self.delete_on_death))
	{
		if(isdefined(self.damage_fx_ent))
		{
			self.damage_fx_ent delete();
		}
		self delete();
		return;
	}
	if(!isdefined(self))
	{
		return;
	}
	self vehicle_death::death_cleanup_level_variables();
	self disableaimassist();
	self cleartargetentity();
	self vehicle::lights_off();
	self laseroff();
	self setturretspinning(0);
	self turret::toggle_lensflare(0);
	self death_fx();
	self thread vehicle_death::death_radius_damage();
	self thread vehicle_death::set_death_model(self.deathmodel, self.modelswapdelay);
	self vehicle::toggle_sounds(0);
	self thread cic_turret_death_movement(attacker, dir);
	if(isdefined(self.damage_fx_ent))
	{
		self.damage_fx_ent delete();
	}
	self.ignoreme = 1;
	self waittill(#"crash_done");
	self freevehicle();
}

/*
	Name: death_fx
	Namespace: cic_turret
	Checksum: 0x9574B5A2
	Offset: 0x18F0
	Size: 0xAC
	Parameters: 0
	Flags: None
*/
function death_fx()
{
	self vehicle::do_death_fx();
	self playsound("veh_cic_turret_sparks");
	fire_ent = spawn("script_origin", self.origin);
	fire_ent playloopsound("veh_cic_turret_dmg_fire_loop", 0.5);
	wait(2);
	fire_ent delete();
}

/*
	Name: cic_turret_death_movement
	Namespace: cic_turret
	Checksum: 0xAD37636E
	Offset: 0x19A8
	Size: 0x106
	Parameters: 2
	Flags: None
*/
function cic_turret_death_movement(attacker, hitdir)
{
	self endon(#"crash_done");
	self endon(#"death");
	self playsound("veh_cic_turret_dmg_hit");
	wait(0.1);
	self.turretrotscale = 0.5;
	tag_angles = self gettagangles("tag_flash");
	target_pos = (self.origin + (anglestoforward((0, tag_angles[1], 0)) * 1000)) + (vectorscale((0, 0, -1), 1800));
	self setturrettargetvec(target_pos);
	wait(4);
	self notify(#"crash_done");
}

/*
	Name: cic_turret_fire_for_time
	Namespace: cic_turret
	Checksum: 0x55B66B0A
	Offset: 0x1AB8
	Size: 0x224
	Parameters: 1
	Flags: None
*/
function cic_turret_fire_for_time(totalfiretime)
{
	self endon(#"crash_done");
	self endon(#"death");
	cic_turret_alert_sound();
	wait(0.1);
	weapon = self seatgetweapon(0);
	firetime = weapon.firetime;
	time = 0;
	is_minigun = 0;
	if(issubstr(weapon.name, "minigun"))
	{
		is_minigun = 1;
		self setturretspinning(1);
		wait(0.5);
	}
	firechance = 2;
	if(isdefined(self.enemy) && isplayer(self.enemy))
	{
		firechance = 1;
	}
	firecount = 1;
	while(time < totalfiretime)
	{
		if(isdefined(self.enemy) && isdefined(self.enemy.attackeraccuracy) && self.enemy.attackeraccuracy == 0)
		{
			self fireweapon();
		}
		else
		{
			if(firechance > 1)
			{
				self fireweapon();
			}
			else
			{
				self fireweapon();
			}
		}
		firecount++;
		wait(firetime);
		time = time + firetime;
	}
	if(is_minigun)
	{
		self setturretspinning(0);
	}
}

/*
	Name: cic_turret_alert_sound
	Namespace: cic_turret
	Checksum: 0xA4C83C37
	Offset: 0x1CE8
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function cic_turret_alert_sound()
{
	self playsound("veh_turret_alert");
}

/*
	Name: cic_turret_set_team
	Namespace: cic_turret
	Checksum: 0x723778BE
	Offset: 0x1D18
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function cic_turret_set_team(team)
{
	self.team = team;
	if(!isdefined(self.off))
	{
		cic_turret_blink_lights();
	}
}

/*
	Name: cic_turret_blink_lights
	Namespace: cic_turret
	Checksum: 0xE0AA07ED
	Offset: 0x1D58
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function cic_turret_blink_lights()
{
	self endon(#"death");
	self vehicle::lights_off();
	wait(0.1);
	self vehicle::lights_on();
}

/*
	Name: cic_turret_emped
	Namespace: cic_turret
	Checksum: 0x9E72899F
	Offset: 0x1DA8
	Size: 0x1DC
	Parameters: 0
	Flags: None
*/
function cic_turret_emped()
{
	self endon(#"death");
	self notify(#"emped");
	self endon(#"emped");
	self.emped = 1;
	playsoundatposition("veh_cic_turret_emp_down", self.origin);
	self.turretrotscale = 0.2;
	self cic_turret_off();
	if(!isdefined(self.stun_fx))
	{
		self.stun_fx = spawn("script_model", self.origin);
		self.stun_fx setmodel("tag_origin");
		self.stun_fx linkto(self, "tag_fx", (0, 0, 0), (0, 0, 0));
		if(issubstr(self.vehicletype, "turret_sentry"))
		{
			playfxontag(level._effect["sentry_turret_stun"], self.stun_fx, "tag_origin");
		}
		else
		{
			playfxontag(level._effect["cic_turret_stun"], self.stun_fx, "tag_origin");
		}
	}
	wait(randomfloatrange(6, 10));
	self.stun_fx delete();
	self.emped = undefined;
	self cic_turret_on();
}

/*
	Name: cicturretcallback_vehicledamage
	Namespace: cic_turret
	Checksum: 0xFC69B334
	Offset: 0x1F90
	Size: 0x17C
	Parameters: 14
	Flags: None
*/
function cicturretcallback_vehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname)
{
	if(weapon.isemp && smeansofdeath != "MOD_IMPACT")
	{
		driver = self getseatoccupant(0);
		if(!isdefined(driver))
		{
			self thread cic_turret_emped();
		}
	}
	if(weapon == getweapon("shotgun_pump_taser") && smeansofdeath == "MOD_PISTOL_BULLET")
	{
		idamage = int(idamage * 3);
		self thread cic_turret_stunned();
	}
	if(!isplayer(eattacker))
	{
		idamage = int(idamage / 4);
	}
	return idamage;
}

/*
	Name: cic_overheat_hud
	Namespace: cic_turret
	Checksum: 0x72136C4
	Offset: 0x2118
	Size: 0x128
	Parameters: 1
	Flags: None
*/
function cic_overheat_hud(turret)
{
	self endon(#"exit_vehicle");
	turret endon(#"turret_exited");
	level endon(#"player_using_turret");
	heat = 0;
	overheat = 0;
	while(true)
	{
		if(isdefined(self.viewlockedentity))
		{
			old_heat = heat;
			heat = self.viewlockedentity getturretheatvalue(0);
			old_overheat = overheat;
			overheat = self.viewlockedentity isvehicleturretoverheating(0);
			if(old_heat != heat || old_overheat != overheat)
			{
				luinotifyevent(&"hud_cic_weapon_heat", 2, int(heat), overheat);
			}
		}
		wait(0.05);
	}
}

/*
	Name: cic_turret_stunned
	Namespace: cic_turret
	Checksum: 0xD83D71DF
	Offset: 0x2248
	Size: 0x1DC
	Parameters: 0
	Flags: None
*/
function cic_turret_stunned()
{
	self endon(#"death");
	self notify(#"stunned");
	self endon(#"stunned");
	self.stunned = 1;
	self.turretrotscale = 0.2;
	self cic_turret_off();
	if(!isdefined(self.stun_fx))
	{
		playsoundatposition("veh_cic_turret_emp_down", self.origin);
		self.stun_fx = spawn("script_model", self.origin);
		self.stun_fx setmodel("tag_origin");
		self.stun_fx linkto(self, "tag_fx", (0, 0, 0), (0, 0, 0));
		if(issubstr(self.vehicletype, "turret_sentry"))
		{
			playfxontag(level._effect["sentry_turret_stun"], self.stun_fx, "tag_origin");
		}
		else
		{
			playfxontag(level._effect["cic_turret_stun"], self.stun_fx, "tag_origin");
		}
	}
	wait(randomfloatrange(3, 5));
	self.stun_fx delete();
	self.stunned = undefined;
	self cic_turret_on();
}

