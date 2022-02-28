// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\gametypes\_globallogic;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace battlechatter;

/*
	Name: __init__sytem__
	Namespace: battlechatter
	Checksum: 0x46335FE9
	Offset: 0x858
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("battlechatter", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: battlechatter
	Checksum: 0x49CE9F9B
	Offset: 0x898
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	aispawnerarray = getactorspawnerarray();
	callback::on_ai_spawned(&on_joined_ai);
}

/*
	Name: init
	Namespace: battlechatter
	Checksum: 0xB8ADF613
	Offset: 0x908
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init()
{
	callback::on_spawned(&on_player_spawned);
	level.battlechatter_init = 1;
	level.allowbattlechatter = [];
	level.allowbattlechatter["bc"] = 1;
	level thread sndvehiclehijackwatcher();
}

/*
	Name: sndvehiclehijackwatcher
	Namespace: battlechatter
	Checksum: 0xA863678F
	Offset: 0x978
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function sndvehiclehijackwatcher()
{
	while(true)
	{
		level waittill(#"clonedentity", clone, vehentnum);
		if(isdefined(clone) && isdefined(clone.archetype))
		{
			vehiclename = clone.archetype;
			if(vehiclename == "wasp")
			{
				alias = "hijack_wasps";
			}
			else
			{
				if(vehiclename == "raps")
				{
					alias = "hijack_raps";
				}
				else
				{
					if(vehiclename == "quadtank")
					{
						alias = "hijack_quad";
					}
					else
					{
						alias = undefined;
					}
				}
			}
			nearbyenemy = get_closest_ai_to_object("axis", clone);
			if(isdefined(nearbyenemy) && isdefined(alias))
			{
				level thread bc_makeline(nearbyenemy, alias);
			}
		}
	}
}

/*
	Name: on_joined_ai
	Namespace: battlechatter
	Checksum: 0x874E044C
	Offset: 0xAB8
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function on_joined_ai()
{
	self endon(#"disconnect");
	if(isdefined(level.deadops) && level.deadops)
	{
		return;
	}
	if(isvehicle(self))
	{
		return;
	}
	if(isdefined(self.archetype) && self.archetype == "zombie")
	{
		return;
	}
	if(isdefined(self.archetype) && self.archetype == "direwolf")
	{
		return;
	}
	if(!isdefined(self.voiceprefix))
	{
		self.voiceprefix = "vox_ax";
	}
	if(isdefined(self.voiceprefix) && (self.voiceprefix == "vox_hend" || self.voiceprefix == "vox_khal" || self.voiceprefix == "vox_kane" || self.voiceprefix == "vox_hall" || self.voiceprefix == "vox_mare" || self.voiceprefix == "vox_diaz"))
	{
		self.bcvoicenumber = "";
	}
	else
	{
		if(self.voiceprefix == "vox_term")
		{
			self.bcvoicenumber = randomintrange(0, 3);
		}
		else
		{
			self.bcvoicenumber = randomintrange(0, 4);
		}
	}
	if(isdefined(self.archetype) && self.archetype == "warlord")
	{
		self thread function_c8397d24();
	}
	self.isspeaking = 0;
	self.soundmod = "player";
	self thread bc_ainotifyconvert();
	self thread bc_grenadewatcher();
	self thread bc_stickygrenadewatcher();
	if(!(isdefined(self.archetype) && self.archetype == "robot"))
	{
		self thread bc_death();
		self thread bc_scriptedline();
		if(isdefined(self.voiceprefix) && getsubstr(self.voiceprefix, 7) == "f")
		{
			self.bcvoicenumber = randomintrange(0, 2);
		}
	}
	else
	{
		self thread function_897d1130();
	}
}

/*
	Name: function_c8397d24
	Namespace: battlechatter
	Checksum: 0xCFFDF2C7
	Offset: 0xDB8
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function function_c8397d24()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	while(true)
	{
		wait(randomintrange(6, 14));
		if(isdefined(self))
		{
			linearray = array("action_peek", "action_moving", "enemy_contact");
			line = linearray[randomintrange(0, linearray.size)];
			level thread bc_makeline(self, line);
		}
	}
}

/*
	Name: bc_ainotifyconvert
	Namespace: battlechatter
	Checksum: 0x9DB3B3DD
	Offset: 0xE98
	Size: 0xD7E
	Parameters: 0
	Flags: Linked
*/
function bc_ainotifyconvert()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"bhtn_action_notify", notify_string);
		switch(notify_string)
		{
			case "pain":
			{
				if(!(isdefined(self.archetype) && self.archetype == "robot"))
				{
					level thread bc_makeline(self, "exert_pain");
				}
				break;
			}
			case "concussiveReact":
			{
				if(!(isdefined(self.archetype) && self.archetype == "robot"))
				{
					level thread bc_makeline(self, "exert_cough", undefined, undefined, 1);
				}
				break;
			}
			case "enemyKill":
			{
				if(!(isdefined(self.archetype) && self.archetype == "robot") && (!(isdefined(self.voiceprefix) && (self.voiceprefix == "vox_germ" || self.voiceprefix == "vox_usa"))))
				{
					if(randomintrange(0, 100) <= 50)
					{
						level thread bc_makeline(self, "enemy_kill");
					}
				}
				break;
			}
			case "meleeKill":
			{
				if(!(isdefined(self.archetype) && self.archetype == "robot") && (!(isdefined(self.voiceprefix) && (self.voiceprefix == "vox_germ" || self.voiceprefix == "vox_usa"))))
				{
					if(randomintrange(0, 100) <= 50)
					{
						level thread bc_makeline(self, "melee_kill");
					}
				}
				break;
			}
			case "asp_incoming":
			case "hounds_incoming":
			case "manticore_incoming":
			case "orthrus_incoming":
			case "raps_incoming":
			case "robots_incoming":
			case "talon_incoming":
			case "technical_incoming":
			{
				if(!(isdefined(self.archetype) && self.archetype == "robot") && (!(isdefined(self.voiceprefix) && (self.voiceprefix == "vox_germ" || self.voiceprefix == "vox_usa"))))
				{
					level thread bc_makeline(self, notify_string);
				}
				break;
			}
			case "electrocute":
			case "pukeStart":
			{
				if(!(isdefined(self.archetype) && self.archetype == "robot"))
				{
					level thread bc_makeline(self, "exert_electrocution", undefined, undefined, 1);
				}
				break;
			}
			case "puke":
			{
				if(!(isdefined(self.archetype) && self.archetype == "robot"))
				{
					level thread bc_makeline(self, "exert_sonic", undefined, undefined, 1);
				}
				break;
			}
			case "scream":
			{
				if(!(isdefined(self.archetype) && self.archetype == "robot"))
				{
					level thread bc_makeline(self, "exert_scream");
				}
				break;
			}
			case "scriptedRobotvox":
			{
				if(isdefined(self.archetype) && self.archetype == "robot")
				{
					level thread bc_makeline(self, "action_intocover");
				}
				break;
			}
			case "reload":
			{
				if(randomintrange(0, 100) <= 20)
				{
					level thread bc_makeline(self, "action_reloading", 1);
				}
				break;
			}
			case "enemycontact":
			{
				self thread bc_enemycontact();
				break;
			}
			case "cover_shoot":
			{
				if(randomintrange(0, 100) <= 10)
				{
					level thread bc_makeline(self, "enemy_contact");
				}
				break;
			}
			case "cover_stance":
			{
				if(randomintrange(0, 100) <= 45)
				{
					level thread bc_makeline(self, "action_intocover");
				}
				break;
			}
			case "charge":
			{
				if(!(isdefined(self.archetype) && self.archetype == "robot"))
				{
					if(!(isdefined(self.voiceprefix) && (self.voiceprefix == "vox_hend" || self.voiceprefix == "vox_khal" || self.voiceprefix == "vox_kane" || self.voiceprefix == "vox_hall" || self.voiceprefix == "vox_mare" || self.voiceprefix == "vox_diaz")))
					{
						soundalias = "vox_generic_exert_charge_male";
						if(isdefined(self.voiceprefix) && getsubstr(self.voiceprefix, 7) == "f")
						{
							soundalias = "vox_generic_exert_charge_female";
						}
						self thread do_sound(soundalias, 1);
					}
					else
					{
						level thread bc_makeline(self, "exert_charge");
					}
				}
				break;
			}
			case "attack_melee":
			{
				if(!(isdefined(self.archetype) && self.archetype == "robot"))
				{
					if(!(isdefined(self.voiceprefix) && (self.voiceprefix == "vox_hend" || self.voiceprefix == "vox_khal" || self.voiceprefix == "vox_kane" || self.voiceprefix == "vox_hall" || self.voiceprefix == "vox_mare" || self.voiceprefix == "vox_diaz")))
					{
						soundalias = "vox_generic_exert_melee_male";
						if(isdefined(self.voiceprefix) && getsubstr(self.voiceprefix, 7) == "f")
						{
							soundalias = "vox_generic_exert_melee_female";
						}
						self thread do_sound(soundalias, 1);
					}
					else
					{
						level thread bc_makeline(self, "exert_melee");
					}
				}
				break;
			}
			case "blindfire":
			{
				level thread bc_makeline(self, "action_blindfire");
				break;
			}
			case "flanked":
			{
				level thread bc_makeline(self, "action_flanked");
				break;
			}
			case "peek":
			case "scan":
			{
				if(randomintrange(0, 100) <= 25)
				{
					level thread bc_makeline(self, "action_peek");
				}
				break;
			}
			case "exposed":
			{
				level thread bc_makeline(self, "action_exposed");
				break;
			}
			case "taking_cover":
			{
				if(randomintrange(0, 100) <= 75)
				{
					level thread bc_makeline(self, "action_intocover");
				}
				break;
			}
			case "moving_up":
			{
				if(randomintrange(0, 100) <= 6)
				{
					level thread bc_makeline(self, "action_moving");
				}
				break;
			}
			case "rbCharge":
			case "rbCrawler":
			case "rbPhalanx":
			case "rbTakeover":
			{
				level thread bc_makeline(self, "action_exposed");
				break;
			}
			case "rbJuke":
			{
				if(randomintrange(0, 100) <= 30)
				{
					level thread bc_makeline(self, "action_moving");
				}
				break;
			}
			case "firefly_swarm":
			{
				if(randomintrange(0, 100) <= 50)
				{
					level thread bc_makeline(self, "firefly_response");
				}
				if(randomintrange(0, 100) <= 50)
				{
					alliesguy = get_closest_ai_to_object("allies", self);
					if(isdefined(alliesguy))
					{
						level util::delay(1, undefined, &bc_makeline, alliesguy, "firefly_response");
					}
				}
				break;
			}
			case "firefly_explode":
			{
				if(randomintrange(0, 100) <= 50)
				{
					teammate = get_closest_ai_on_sameteam(self);
					if(isdefined(teammate))
					{
						level thread bc_makeline(teammate, "firefly_explode");
					}
				}
				break;
			}
			case "fireflyAttack":
			{
				level thread bc_makeline(self, "exert_firefly", undefined, undefined, 1);
				break;
			}
			case "fireflyAttackUpg":
			{
				level thread bc_makeline(self, "exert_firefly_burning", undefined, undefined, 1);
				break;
			}
			case "rapidstrike":
			{
				level thread bc_makeline(self, "rapidstrike_response");
				break;
			}
			case "warlord_angry":
			case "warlord_juke":
			{
				linearray = array("action_peek", "action_moving", "enemy_contact");
				line = linearray[randomintrange(0, linearray.size)];
				level thread bc_makeline(self, line);
				break;
			}
			case "reactImmolation":
			{
				level thread bc_makeline(self, "exert_immolation", undefined, undefined, 1);
				break;
			}
			case "reactImmolationLong":
			{
				level thread bc_makeline(self, "exert_immolation", undefined, undefined, 1);
				break;
			}
			case "reactSensory":
			{
				level thread bc_makeline(self, "exert_screaming", undefined, undefined, 1);
				break;
			}
			case "weaponmalfunction":
			{
				level thread bc_makeline(self, "exert_malfunction", undefined, undefined, 1);
				break;
			}
			case "reactExosuit":
			{
				level thread bc_makeline(self, "exert_breakdown", undefined, undefined, 1);
				break;
			}
			case "reactMisdirection":
			{
				break;
			}
			case "reactBodyBlow":
			{
				level thread bc_makeline(self, "exert_body_blow", undefined, undefined, 1);
				break;
			}
			default:
			{
				break;
			}
		}
	}
}

/*
	Name: bc_scriptedline
	Namespace: battlechatter
	Checksum: 0xCE7DFC51
	Offset: 0x1C20
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function bc_scriptedline()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"scriptedbc", alias_suffix);
		level thread bc_makeline(self, alias_suffix);
	}
}

/*
	Name: bc_enemycontact
	Namespace: battlechatter
	Checksum: 0x484CC03E
	Offset: 0x1C90
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function bc_enemycontact()
{
	self endon(#"death");
	self endon(#"disconnect");
	if(randomintrange(0, 100) <= 35)
	{
		if(!(isdefined(level.bc_enemycontact) && level.bc_enemycontact))
		{
			level thread bc_makeline(self, "enemy_contact");
			level thread bc_enemycontact_wait();
		}
	}
}

/*
	Name: bc_enemycontact_wait
	Namespace: battlechatter
	Checksum: 0x93B2F612
	Offset: 0x1D20
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function bc_enemycontact_wait()
{
	level.bc_enemycontact = 1;
	wait(15);
	level.bc_enemycontact = 0;
}

/*
	Name: bc_grenadewatcher
	Namespace: battlechatter
	Checksum: 0x366E049D
	Offset: 0x1D48
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function bc_grenadewatcher()
{
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"grenade_fire", grenade, weapon);
		if(weapon.name == "frag_grenade" || weapon.name == "frag_grenade_invisible")
		{
			if(randomintrange(0, 100) <= 80 && !isplayer(self))
			{
				level thread bc_makeline(self, "grenade_toss");
			}
			level thread bc_incominggrenadewatcher(self, grenade);
		}
	}
}

/*
	Name: bc_incominggrenadewatcher
	Namespace: battlechatter
	Checksum: 0x688AE3FC
	Offset: 0x1E48
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function bc_incominggrenadewatcher(thrower, grenade)
{
	if(randomintrange(0, 100) <= 95)
	{
		wait(1);
		if(!isdefined(thrower) || !isdefined(grenade))
		{
			return;
		}
		team = "axis";
		if(isdefined(thrower.team) && team == thrower.team)
		{
			team = "allies";
		}
		ai = get_closest_ai_to_object(team, grenade);
		if(isdefined(ai))
		{
			level thread bc_makeline(ai, "grenade_incoming", 1);
		}
	}
}

/*
	Name: bc_stickygrenadewatcher
	Namespace: battlechatter
	Checksum: 0x995F7D5
	Offset: 0x1F48
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function bc_stickygrenadewatcher()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"sticky_explode");
	while(true)
	{
		self waittill(#"grenade_stuck", grenade);
		if(isdefined(grenade))
		{
			grenade.stucktoplayer = self;
		}
		if(isalive(self))
		{
			level thread bc_makeline(self, "grenade_sticky");
		}
		break;
	}
}

/*
	Name: function_897d1130
	Namespace: battlechatter
	Checksum: 0x6DDA1D1C
	Offset: 0x1FF8
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_897d1130()
{
	self endon(#"disconnect");
	self waittill(#"death", attacker, meansofdeath);
	if(isdefined(attacker) && !isplayer(attacker))
	{
		if(meansofdeath == "MOD_MELEE")
		{
			attacker notify(#"bhtn_action_notify", "meleeKill");
		}
		else
		{
			attacker notify(#"bhtn_action_notify", "enemyKill");
		}
	}
}

/*
	Name: bc_death
	Namespace: battlechatter
	Checksum: 0xD0B1A4F0
	Offset: 0x20A0
	Size: 0x38C
	Parameters: 0
	Flags: Linked
*/
function bc_death()
{
	self endon(#"disconnect");
	self waittill(#"death", attacker, meansofdeath);
	if(isdefined(self))
	{
		meleeassassinate = isdefined(meansofdeath) && meansofdeath == "MOD_MELEE_ASSASSINATE";
		if(isdefined(self.archetype) && self.archetype == "warlord")
		{
			self playsound("chr_warlord_death");
		}
		if(!(isdefined(self.quiet_death) && self.quiet_death) && !meleeassassinate && isdefined(attacker))
		{
			if(meansofdeath == "MOD_ELECTROCUTED")
			{
				soundalias = ((self.voiceprefix + self.bcvoicenumber) + "_") + "exert_electrocution";
			}
			else
			{
				if(meansofdeath == "MOD_BURNED")
				{
					soundalias = ((self.voiceprefix + self.bcvoicenumber) + "_") + "exert_firefly_burning";
				}
				else
				{
					soundalias = ((self.voiceprefix + self.bcvoicenumber) + "_") + "exert_death";
				}
			}
			self thread do_sound(soundalias, 1);
		}
		if(isdefined(self.sndissniper) && self.sndissniper && isdefined(attacker) && !isplayer(attacker))
		{
			level thread bc_makeline(attacker, "sniper_kill");
			return;
		}
		if(isdefined(attacker) && !isplayer(attacker))
		{
			if(meansofdeath == "MOD_MELEE")
			{
				attacker notify(#"bhtn_action_notify", "meleeKill");
			}
			else
			{
				attacker notify(#"bhtn_action_notify", "enemyKill");
			}
		}
		sniper = isdefined(attacker) && isdefined(attacker.scoretype) && attacker.scoretype == "_sniper";
		if(!meleeassassinate && (sniper || randomintrange(0, 100) <= 35))
		{
			close_ai = get_closest_ai_on_sameteam(self);
			if(isdefined(close_ai) && (!(isdefined(close_ai.quiet_death) && close_ai.quiet_death)))
			{
				if(sniper)
				{
					attacker.sndissniper = 1;
					level thread bc_makeline(close_ai, "sniper_threat");
				}
				else
				{
					level thread bc_makeline(close_ai, "friendly_down");
				}
			}
		}
	}
}

/*
	Name: bc_ainearexplodable
	Namespace: battlechatter
	Checksum: 0x506C278F
	Offset: 0x2438
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function bc_ainearexplodable(object, type)
{
	wait(randomfloatrange(0.1, 0.4));
	ai = get_closest_ai_to_object("both", object, 500);
	if(isdefined(ai))
	{
		if(type == "car")
		{
			level thread bc_makeline(ai, "destructible_car");
		}
		else
		{
			level thread bc_makeline(ai, "destructible_barrel");
		}
	}
}

/*
	Name: bc_robotbehindvox
	Namespace: battlechatter
	Checksum: 0x80159F15
	Offset: 0x2508
	Size: 0x4B2
	Parameters: 0
	Flags: Linked
*/
function bc_robotbehindvox()
{
	level endon(#"unloaded");
	self endon(#"death_or_disconnect");
	self endon(#"hash_f8c5dd60");
	if(!isdefined(level._bc_robotbehindvoxtime))
	{
		level._bc_robotbehindvoxtime = 0;
		enemies = getaiteamarray("axis", "team3");
		level._bc_robotbehindarray = array();
		foreach(enemy in enemies)
		{
			if(isdefined(enemy.archetype) && enemy.archetype == "robot")
			{
				array::add(level._bc_robotbehindarray, enemy, 0);
			}
		}
	}
	while(true)
	{
		wait(1);
		t = gettime();
		if(t > (level._bc_robotbehindvoxtime + 1000))
		{
			level._bc_robotbehindvoxtime = t;
			enemies = getaiteamarray("axis", "team3");
			array::remove_dead(level._bc_robotbehindarray);
			array::remove_undefined(level._bc_robotbehindarray);
			foreach(enemy in enemies)
			{
				if(isdefined(enemy.archetype) && enemy.archetype == "robot")
				{
					array::add(level._bc_robotbehindarray, enemy, 0);
				}
			}
		}
		if(level._bc_robotbehindarray.size <= 0)
		{
			continue;
		}
		played_sound = 0;
		foreach(robot in level._bc_robotbehindarray)
		{
			if(!isdefined(robot))
			{
				continue;
			}
			if(distancesquared(robot.origin, self.origin) < 90000)
			{
				if(isdefined(robot.current_scene))
				{
					continue;
				}
				if(isdefined(robot.health) && robot.health <= 0)
				{
					continue;
				}
				if(isdefined(level.scenes) && level.scenes.size >= 1)
				{
					continue;
				}
				yaw = self getyawtospot(robot.origin);
				diff = self.origin[2] - robot.origin[2];
				if(yaw < -95 || yaw > 95 && abs(diff) < 200)
				{
					robot playsound("chr_robot_behind");
					played_sound = 1;
					break;
				}
			}
		}
		if(played_sound)
		{
			wait(5);
		}
	}
}

/*
	Name: getyawtospot
	Namespace: battlechatter
	Checksum: 0xBAD40E49
	Offset: 0x29C8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function getyawtospot(spot)
{
	pos = spot;
	yaw = self.angles[1] - getyaw(pos);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: getyaw
	Namespace: battlechatter
	Checksum: 0x6B19C29C
	Offset: 0x2A48
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function getyaw(org)
{
	angles = vectortoangles(org - self.origin);
	return angles[1];
}

/*
	Name: bc_makeline
	Namespace: battlechatter
	Checksum: 0x4BCD9115
	Offset: 0x2A98
	Size: 0x16C
	Parameters: 5
	Flags: Linked
*/
function bc_makeline(ai, line, causeresponse, category, alwaysplay)
{
	if(!isdefined(ai))
	{
		return;
	}
	ai endon(#"death");
	ai endon(#"disconnect");
	response = undefined;
	if(isdefined(causeresponse))
	{
		response = line + "_response";
	}
	if(!isdefined(ai.voiceprefix) || !isdefined(ai.bcvoicenumber))
	{
		return;
	}
	if(isdefined(ai.archetype) && ai.archetype == "robot")
	{
		soundalias = ((ai.voiceprefix + ai.bcvoicenumber) + "_") + "chatter";
	}
	else
	{
		soundalias = ((ai.voiceprefix + ai.bcvoicenumber) + "_") + line;
	}
	ai thread do_sound(soundalias, alwaysplay, response, category);
}

/*
	Name: do_sound
	Namespace: battlechatter
	Checksum: 0x418DE78F
	Offset: 0x2C10
	Size: 0x21C
	Parameters: 4
	Flags: Linked
*/
function do_sound(soundalias, alwaysplay, response, category)
{
	if(!isdefined(soundalias))
	{
		return;
	}
	if(!isdefined(alwaysplay))
	{
		alwaysplay = 0;
	}
	if(self bc_allowed(category) && (!(isdefined(self.isspeaking) && self.isspeaking) || alwaysplay))
	{
		if(!isdefined(self.enemy) && !alwaysplay)
		{
			return;
		}
		function_20dcacc5();
		if(!isdefined(self))
		{
			return;
		}
		if(isdefined(self.istalking) && self.istalking)
		{
			return;
		}
		if(isdefined(self.isspeaking) && self.isspeaking)
		{
			self notify(#"bc_interrupt");
		}
		if(isalive(self))
		{
			self playsoundontag(soundalias, "J_neck");
		}
		else
		{
			self playsound(soundalias);
		}
		self thread wait_playback_time(soundalias);
		result = self util::waittill_any_return(soundalias, "death", "disconnect", "bc_interrupt");
		if(result == soundalias)
		{
			if(isdefined(response))
			{
				ai = get_closest_ai_on_sameteam(self);
				if(isdefined(ai))
				{
					level thread bc_makeline(ai, response);
				}
			}
		}
		else if(isdefined(self))
		{
			self stopsound(soundalias);
		}
	}
}

/*
	Name: function_20dcacc5
	Namespace: battlechatter
	Checksum: 0x8115231E
	Offset: 0x2E38
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_20dcacc5()
{
	if(!isdefined(level.var_769cc2b1))
	{
		level thread function_1af43712();
	}
	while(level.var_769cc2b1 != 0)
	{
		util::wait_network_frame();
	}
	level.var_769cc2b1++;
}

/*
	Name: function_1af43712
	Namespace: battlechatter
	Checksum: 0xFC78A1DC
	Offset: 0x2E90
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function function_1af43712()
{
	while(true)
	{
		level.var_769cc2b1 = 0;
		util::wait_network_frame();
	}
}

/*
	Name: bc_allowed
	Namespace: battlechatter
	Checksum: 0xA3BE1CC8
	Offset: 0x2EC8
	Size: 0x96
	Parameters: 1
	Flags: Linked
*/
function bc_allowed(str_category = "bc")
{
	if(isdefined(level.allowbattlechatter) && (!(isdefined(level.allowbattlechatter[str_category]) && level.allowbattlechatter[str_category])))
	{
		return false;
	}
	if(isdefined(self.allowbattlechatter) && (!(isdefined(self.allowbattlechatter[str_category]) && self.allowbattlechatter[str_category])))
	{
		return false;
	}
	return true;
}

/*
	Name: on_player_spawned
	Namespace: battlechatter
	Checksum: 0x9705872B
	Offset: 0x2F68
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	self.soundmod = "player";
	self.voxshouldgasp = 0;
	self.voxshouldgasploop = 1;
	self.isspeaking = 0;
	self thread pain_vox();
	self thread bc_grenadewatcher();
	self thread bc_robotbehindvox();
	self thread bc_plrnotifyconvert();
	self thread cybercoremeleewatcher();
}

/*
	Name: bc_plrnotifyconvert
	Namespace: battlechatter
	Checksum: 0x3964D763
	Offset: 0x3030
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function bc_plrnotifyconvert()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"bhtn_action_notify", notify_string);
		switch(notify_string)
		{
			case "firefly_deploy":
			{
				break;
			}
			case "firefly_end":
			{
				break;
			}
			default:
			{
				break;
			}
		}
	}
}

/*
	Name: bc_doplayervox
	Namespace: battlechatter
	Checksum: 0xEBB7A07C
	Offset: 0x30C0
	Size: 0xA4
	Parameters: 1
	Flags: None
*/
function bc_doplayervox(suffix)
{
	soundalias = "vox_plyr_" + suffix;
	if(self bc_allowed() && (!(isdefined(self.istalking) && self.istalking)) && (!(isdefined(self.isspeaking) && self.isspeaking)))
	{
		self playsoundtoplayer(soundalias, self);
		self thread wait_playback_time(soundalias);
	}
}

/*
	Name: pain_vox
	Namespace: battlechatter
	Checksum: 0x25938FE3
	Offset: 0x3170
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function pain_vox()
{
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"snd_pain_player", meansofdeath);
		if(randomintrange(0, 100) <= 100)
		{
			if(isalive(self))
			{
				if(meansofdeath == "MOD_DROWN")
				{
					soundalias = "chr_swimming_drown";
					self.voxshouldgasp = 1;
					if(self.voxshouldgasploop)
					{
						self thread water_gasp();
					}
				}
				soundalias = "vox_plyr_exert_pain";
				self thread do_sound(soundalias, 1);
			}
		}
		wait(0.5);
	}
}

/*
	Name: water_gasp
	Namespace: battlechatter
	Checksum: 0xA6CCC3FA
	Offset: 0x3278
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function water_gasp()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"snd_gasp");
	level endon(#"game_ended");
	self.voxshouldgasploop = 0;
	while(true)
	{
		if(!self isplayerunderwater() && self.voxshouldgasp)
		{
			self.voxshouldgasp = 0;
			self.voxshouldgasploop = 1;
			self thread do_sound("vox_pm1_gas_gasp", 1);
			self notify(#"snd_gasp");
		}
		wait(0.5);
	}
}

/*
	Name: cybercoremeleewatcher
	Namespace: battlechatter
	Checksum: 0xA05D64ED
	Offset: 0x3340
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function cybercoremeleewatcher()
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"melee_cybercom");
		self thread sndcybercoremeleeresponse();
	}
}

/*
	Name: sndcybercoremeleeresponse
	Namespace: battlechatter
	Checksum: 0x9E652FE
	Offset: 0x33A0
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function sndcybercoremeleeresponse()
{
	self endon(#"melee_cybercom");
	wait(2);
	if(isdefined(self))
	{
		ai = level get_closest_ai_to_object("axis", self, 700);
		if(isdefined(ai))
		{
			ai notify(#"bhtn_action_notify", "rapidstrike");
		}
	}
}

/*
	Name: wait_playback_time
	Namespace: battlechatter
	Checksum: 0x5F424B52
	Offset: 0x3410
	Size: 0xA8
	Parameters: 2
	Flags: Linked
*/
function wait_playback_time(soundalias, timeout)
{
	self endon(#"death");
	self endon(#"disconnect");
	playbacktime = soundgetplaybacktime(soundalias);
	self.isspeaking = 1;
	if(playbacktime >= 0)
	{
		waittime = playbacktime * 0.001;
		wait(waittime);
	}
	else
	{
		wait(1);
	}
	self notify(soundalias);
	self.isspeaking = 0;
}

/*
	Name: get_closest_ai_on_sameteam
	Namespace: battlechatter
	Checksum: 0xDDF5BE60
	Offset: 0x34C0
	Size: 0x37E
	Parameters: 2
	Flags: Linked
*/
function get_closest_ai_on_sameteam(some_ai, maxdist)
{
	if(isdefined(some_ai))
	{
		aiarray = getaiteamarray(some_ai.team);
		aiarray = arraysort(aiarray, some_ai.origin);
		if(!isdefined(maxdist))
		{
			maxdist = 1000;
		}
		foreach(dude in aiarray)
		{
			if(!isdefined(some_ai))
			{
				return undefined;
			}
			if(!isdefined(dude) || !isalive(dude) || !isdefined(dude.bcvoicenumber))
			{
				continue;
			}
			if(dude == some_ai)
			{
				continue;
			}
			if(isvehicle(dude))
			{
				continue;
			}
			if(isdefined(dude.archetype) && dude.archetype == "robot")
			{
				continue;
			}
			if(!(isdefined(dude.voiceprefix) && (dude.voiceprefix == "vox_hend" || dude.voiceprefix == "vox_khal" || dude.voiceprefix == "vox_kane" || dude.voiceprefix == "vox_hall" || dude.voiceprefix == "vox_mare" || dude.voiceprefix == "vox_diaz")) && (!(isdefined(some_ai.voiceprefix) && (some_ai.voiceprefix == "vox_hend" || some_ai.voiceprefix == "vox_khal" || some_ai.voiceprefix == "vox_kane" || some_ai.voiceprefix == "vox_hall" || some_ai.voiceprefix == "vox_mare" || some_ai.voiceprefix == "vox_diaz"))))
			{
				if(dude.bcvoicenumber == some_ai.bcvoicenumber)
				{
					continue;
				}
			}
			if(distance(some_ai.origin, dude.origin) > maxdist)
			{
				continue;
			}
			return dude;
		}
	}
	return undefined;
}

/*
	Name: get_closest_ai_to_object
	Namespace: battlechatter
	Checksum: 0xF3730A1A
	Offset: 0x3848
	Size: 0x216
	Parameters: 3
	Flags: Linked
*/
function get_closest_ai_to_object(team, object, maxdist)
{
	if(!isdefined(object))
	{
		return;
	}
	if(team == "both")
	{
		aiarray = getaiteamarray("axis", "allies");
	}
	else
	{
		aiarray = getaiteamarray(team);
	}
	aiarray = arraysort(aiarray, object.origin);
	if(!isdefined(maxdist))
	{
		maxdist = 1000;
	}
	foreach(dude in aiarray)
	{
		if(!isdefined(dude) || !isalive(dude))
		{
			continue;
		}
		if(isvehicle(dude))
		{
			continue;
		}
		if(isdefined(dude.archetype) && dude.archetype == "robot")
		{
			continue;
		}
		if(!isdefined(dude.voiceprefix) || !isdefined(dude.bcvoicenumber))
		{
			continue;
		}
		if(distance(dude.origin, object.origin) > maxdist)
		{
			continue;
		}
		return dude;
	}
	return undefined;
}

/*
	Name: function_d9f49fba
	Namespace: battlechatter
	Checksum: 0xB9E6B090
	Offset: 0x3A68
	Size: 0x66
	Parameters: 2
	Flags: Linked
*/
function function_d9f49fba(b_allow, str_category = "bc")
{
	/#
		assert(isdefined(b_allow), "");
	#/
	level.allowbattlechatter[str_category] = b_allow;
}

