// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_util;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_aware;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_level;
#using scripts\shared\stealth_status;
#using scripts\shared\stealth_tagging;
#using scripts\shared\stealth_vo;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace stealth_player;

/*
	Name: init
	Namespace: stealth_player
	Checksum: 0xB2E4BBBA
	Offset: 0x3D8
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	/#
		assert(isplayer(self));
	#/
	/#
		assert(!isdefined(self.stealth));
	#/
	if(!isdefined(self.stealth))
	{
		self.stealth = spawnstruct();
	}
	self.stealth.player_detected = 0;
	self.stealth.player_detect_count = 0;
	self thread stance_monitor_thread();
	self thread detected_monitor_thread();
	self stealth_tagging::init();
	self stealth_vo::init();
	/#
		self stealth_debug::init_debug();
	#/
	self thread function_7300ae66();
	self thread function_bb9ffa41();
	self thread function_ff057a95();
}

/*
	Name: stop
	Namespace: stealth_player
	Checksum: 0x99EC1590
	Offset: 0x540
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function stop()
{
}

/*
	Name: reset
	Namespace: stealth_player
	Checksum: 0x1C8F92B5
	Offset: 0x550
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function reset()
{
	self.stealth.var_31bf1854 = undefined;
	self.stealth.var_b9ae563d = undefined;
	self.stealth.var_23eafafa = undefined;
	self.stealth.var_9f4ce919 = [];
}

/*
	Name: enabled
	Namespace: stealth_player
	Checksum: 0x65332852
	Offset: 0x5A0
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function enabled()
{
	return isdefined(self.stealth) && isdefined(self.stealth.player_detected);
}

/*
	Name: inc_detected
	Namespace: stealth_player
	Checksum: 0xA5D6612F
	Offset: 0x5C8
	Size: 0x24
	Parameters: 2
	Flags: Linked
*/
function inc_detected(detector, alertvalue)
{
	self.stealth.player_detect_count++;
}

/*
	Name: inc_aware
	Namespace: stealth_player
	Checksum: 0xAB85D7C5
	Offset: 0x5F8
	Size: 0x232
	Parameters: 2
	Flags: Linked
*/
function inc_aware(detector, alertvalue)
{
	if(!isdefined(self.stealth.sensing))
	{
		self.stealth.sensing = [];
	}
	furthestsq = 0;
	replace = -1;
	for(i = 0; i < self.stealth.sensing.size; i++)
	{
		value = self detection_value(self.stealth.sensing[i]);
		if(value == 127 || !isdefined(self.stealth.sensing[i]) || self.stealth.sensing[i] == detector)
		{
			self.stealth.sensing[i] = detector;
			return;
		}
		distsq = distancesquared(self.stealth.sensing[i].origin, self.origin);
		if(distsq > furthestsq)
		{
			furthestsq = distsq;
			replace = i;
		}
	}
	if(self.stealth.sensing.size < 4)
	{
		self.stealth.sensing[self.stealth.sensing.size] = detector;
		return;
	}
	distsq = distancesquared(detector.origin, self.origin);
	if(distsq < furthestsq)
	{
		self.stealth.sensing[replace] = detector;
	}
}

/*
	Name: function_ff057a95
	Namespace: stealth_player
	Checksum: 0x8F960A37
	Offset: 0x838
	Size: 0x498
	Parameters: 0
	Flags: Linked
*/
function function_ff057a95()
{
	self notify(#"hash_ff057a95");
	self endon(#"hash_ff057a95");
	self endon(#"disconnect");
	self endon(#"stop_stealth");
	/#
		assert(isdefined(self.stealth));
	#/
	if(!isdefined(self.stealth.var_9f4ce919))
	{
		self.stealth.var_9f4ce919 = [];
	}
	while(true)
	{
		if(!(isdefined(level.stealth.vo_callouts) && level.stealth.vo_callouts))
		{
			wait(1);
			continue;
		}
		if(self playerads() > 0.3)
		{
			var_bd8fb968 = self hascybercomability("cybercom_hijack");
			eye = self geteye();
			var_fd26df34 = anglestoforward(self getplayerangles());
			targets = getaiteamarray("axis");
			if(isdefined(level.stealth.var_581c13ae))
			{
				var_2680d17d = [];
				foreach(var_daf22616 in level.stealth.var_581c13ae)
				{
					if(!isdefined(var_daf22616))
					{
						continue;
					}
					targets[targets.size] = var_daf22616;
					var_2680d17d[var_2680d17d.size] = var_daf22616;
				}
				if(var_2680d17d.size != level.stealth.var_581c13ae.size)
				{
					level.stealth.var_581c13ae = var_2680d17d;
				}
			}
			foreach(var_daf22616 in targets)
			{
				warnmsg = "careful";
				var_bbf94a49 = var_daf22616.origin;
				if(issentient(var_daf22616))
				{
					var_bbf94a49 = var_daf22616 geteye();
				}
				if(isdefined(var_daf22616.var_3bee9acf))
				{
					warnmsg = var_daf22616.var_3bee9acf;
				}
				else if(isvehicle(var_daf22616))
				{
					if(var_bd8fb968 && var_daf22616 isremotecontrol())
					{
						warnmsg = "careful_hack";
					}
					else
					{
						warnmsg = "careful_" + var_daf22616.archetype;
					}
				}
				if(isdefined(self.stealth.var_9f4ce919[warnmsg]))
				{
					continue;
				}
				dir = vectornormalize(var_bbf94a49 - eye);
				if(vectordot(var_fd26df34, dir) > 0.99)
				{
					if(sighttracepassed(var_bbf94a49, eye, 0, undefined))
					{
						self stealth_vo::function_e3ae87b3(warnmsg);
						self.stealth.var_9f4ce919[warnmsg] = 1;
					}
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: detection_value
	Namespace: stealth_player
	Checksum: 0x513419CB
	Offset: 0xCD8
	Size: 0x1F0
	Parameters: 1
	Flags: Linked
*/
function detection_value(other)
{
	if(!isdefined(other))
	{
		return 127;
	}
	if(getdvarint("stealth_display", 1) == 1 && isalive(other) && !other.ignoreall)
	{
		value = other getstealthsightvalue(self) * 49;
		bcansee = other stealth::can_see(self);
		bcombat = isdefined(other.stealth.aware_combat) && isdefined(other.stealth.aware_combat[self getentitynumber()]);
		balert = isdefined(other.stealth.aware_alerted) && isdefined(other.stealth.aware_alerted[self getentitynumber()]);
		if(value > 0 || balert || bcombat)
		{
			if(bcombat)
			{
				value = 50;
			}
			else if(balert)
			{
				value = 49;
			}
			if(bcansee || bcombat)
			{
				value = value + 50;
			}
			return int(value);
		}
	}
	return 127;
}

/*
	Name: function_b9393d6c
	Namespace: stealth_player
	Checksum: 0x8ED6A0BC
	Offset: 0xED0
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function function_b9393d6c(awareness)
{
	vals = level stealth_level::get_parms(awareness);
	/#
		assert(isdefined(vals));
	#/
	maxvisibledist = vals.maxsightdist;
	if(awareness != "combat")
	{
		stance = self getstance();
		if(isdefined(self.stealth.in_shadow) && self.stealth.in_shadow)
		{
			maxvisibledist = maxvisibledist * 0.5;
		}
		if(stance == "prone")
		{
			maxvisibledist = maxvisibledist * 0.25;
		}
		else if(stance == "crouch")
		{
			maxvisibledist = maxvisibledist * 0.5;
		}
	}
	self.maxvisibledist = maxvisibledist;
	self.maxseenfovcosine = vals.fovcosine;
	self.maxseenfovcosinez = vals.fovcosinez;
}

/*
	Name: set_detected
	Namespace: stealth_player
	Checksum: 0x8EAEC4D7
	Offset: 0x1038
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function set_detected(detected)
{
	self.stealth.player_detected = detected;
}

/*
	Name: get_detected
	Namespace: stealth_player
	Checksum: 0x300A0C81
	Offset: 0x1060
	Size: 0x32
	Parameters: 0
	Flags: None
*/
function get_detected()
{
	if(!self enabled())
	{
		return 0;
	}
	return self.stealth.player_detected;
}

/*
	Name: stance_monitor_thread
	Namespace: stealth_player
	Checksum: 0x95217A14
	Offset: 0x10A0
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function stance_monitor_thread()
{
	self endon(#"disconnect");
	while(true)
	{
		stance = self getstance();
		maxvisibledist = 1600;
		switch(stance)
		{
			case "crouch":
			{
				maxvisibledist = 800;
				break;
			}
			case "prone":
			{
				maxvisibledist = 400;
				break;
			}
		}
		if(isdefined(self.stealth) && (isdefined(self.stealth.in_shadow) && self.stealth.in_shadow))
		{
			maxvisibledist = maxvisibledist * 0.5;
		}
		self.maxvisibledist = maxvisibledist;
		wait(0.25);
	}
}

/*
	Name: detected_monitor_thread
	Namespace: stealth_player
	Checksum: 0x33A3AB99
	Offset: 0x1198
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function detected_monitor_thread()
{
	self endon(#"disconnect");
	self endon(#"stop_stealth");
	while(true)
	{
		self.stealth.player_detect_count = 0;
		wait(1);
		if(self.stealth.player_detect_count <= 0)
		{
			self set_detected(0);
		}
	}
}

/*
	Name: function_7300ae66
	Namespace: stealth_player
	Checksum: 0x384464C5
	Offset: 0x1210
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function function_7300ae66()
{
	self endon(#"disconnect");
	self endon(#"stop_stealth");
	wait(0.05);
	self set_ignore_me_one_to_one(1);
	while(true)
	{
		self util::waittill_any("spawned");
		self function_b9393d6c("high_alert");
		wait(0.05);
		self set_ignore_me_one_to_one(1);
	}
}

/*
	Name: function_bb9ffa41
	Namespace: stealth_player
	Checksum: 0xEC73224E
	Offset: 0x12C0
	Size: 0x210
	Parameters: 0
	Flags: Linked
*/
function function_bb9ffa41()
{
	self endon(#"disconnect");
	self endon(#"stop_stealth");
	var_52ff854e = 0;
	while(true)
	{
		kills = self globallogic_score::getpersstat("kills");
		if(!isdefined(kills))
		{
			kills = 0;
		}
		var_b69afa72 = kills;
		lastkilltime = gettime();
		self waittill(#"killed_ai", victim, smeansofdeath, weapon);
		waittillframeend();
		if(isdefined(victim) && isdefined(victim.team) && victim.team != "axis")
		{
			self thread stealth_vo::function_e3ae87b3("fail_kill");
			continue;
		}
		kills = self globallogic_score::getpersstat("kills");
		if(!isdefined(kills))
		{
			kills = 1;
		}
		var_c839bf74 = kills - var_b69afa72;
		if((gettime() - lastkilltime) > 1000)
		{
			var_52ff854e = 0;
		}
		if(var_c839bf74 >= 2 && isdefined(smeansofdeath) && util::isbulletimpactmod(smeansofdeath))
		{
			self notify(#"double_kill");
		}
		var_52ff854e = var_52ff854e + var_c839bf74;
		if(!isdefined(self.stealth))
		{
			return;
		}
		if(!isdefined(level.stealth))
		{
			return;
		}
		self thread function_e507ced8(victim, smeansofdeath, weapon, var_52ff854e);
	}
}

/*
	Name: function_e507ced8
	Namespace: stealth_player
	Checksum: 0x213AFB6F
	Offset: 0x14D8
	Size: 0x160
	Parameters: 4
	Flags: Linked
*/
function function_e507ced8(victim, smeansofdeath, weapon, killcount)
{
	self notify(#"hash_e507ced8");
	self endon(#"hash_e507ced8");
	self endon(#"disconnect");
	self endon(#"stop_stealth");
	self endon(#"death");
	if(!level flag::get("stealth_alert") && !level flag::get("stealth_combat") && !level flag::get("stealth_discovered"))
	{
		if(isdefined(victim) && isdefined(victim.var_99baf927))
		{
			self stealth_vo::function_e3ae87b3(victim.var_99baf927);
		}
		else if(!(isdefined(level.stealth.var_30d9fcc6) && level.stealth.var_30d9fcc6))
		{
			if(killcount > 1)
			{
			}
			else if(isdefined(weapon) && weapon.type == "bullet")
			{
			}
		}
	}
}

/*
	Name: set_ignore_me_one_to_one
	Namespace: stealth_player
	Checksum: 0x24CDFE1C
	Offset: 0x1640
	Size: 0x11A
	Parameters: 1
	Flags: Linked
*/
function set_ignore_me_one_to_one(ignore)
{
	if(!isdefined(level.stealth))
	{
		return;
	}
	if(!isdefined(level.stealth.enemies))
	{
		return;
	}
	if(!isdefined(level.stealth.enemies[self.team]))
	{
		return;
	}
	foreach(enemy in level.stealth.enemies[self.team])
	{
		if(!isdefined(enemy))
		{
			continue;
		}
		if(enemy stealth_aware::enabled())
		{
			enemy stealth_aware::set_ignore_sentient(self, ignore);
		}
	}
}

/*
	Name: update_audio
	Namespace: stealth_player
	Checksum: 0x7BA4A30B
	Offset: 0x1768
	Size: 0xFC
	Parameters: 3
	Flags: Linked
*/
function update_audio(e_other, bcansee, awareness)
{
	if(getdvarint("stealth_audio", 1) == 0)
	{
		return;
	}
	bcombat = awareness == "combat";
	if(!self enabled())
	{
		return;
	}
	if(!(isdefined(self.stealth.player_detected) && self.stealth.player_detected))
	{
		if(!bcombat)
		{
			if(bcansee)
			{
				self thread sighting_thread(awareness);
			}
		}
		if(bcombat)
		{
			self.stealth.player_detected = 1;
			self thread function_e6e6afd7(e_other);
		}
	}
}

/*
	Name: function_e6e6afd7
	Namespace: stealth_player
	Checksum: 0xBC9DC6ED
	Offset: 0x1870
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_e6e6afd7(e_other)
{
	self endon(#"disconnect");
	result = e_other util::waittill_any_timeout(0.25, "death");
	if(result == "timeout")
	{
		self thread stealth_broken_sound();
	}
}

/*
	Name: sighting_thread
	Namespace: stealth_player
	Checksum: 0xEF9E8BB4
	Offset: 0x18E8
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function sighting_thread(awareness)
{
	self notify(#"sighting_thread");
	self endon(#"sighting_thread");
	self endon(#"disconnect");
	self endon(#"stop_stealth");
	self endon(#"death");
	sighting_field = 1;
	if(awareness == "high_alert")
	{
		sighting_field = 2;
	}
	self clientfield::set_to_player("stealth_sighting", sighting_field);
	wait(0.15);
	self clientfield::set_to_player("stealth_sighting", 0);
}

/*
	Name: alerted_thread
	Namespace: stealth_player
	Checksum: 0x923F4064
	Offset: 0x19B0
	Size: 0x8C
	Parameters: 0
	Flags: None
*/
function alerted_thread()
{
	self notify(#"alerted_thread");
	self endon(#"alerted_thread");
	self endon(#"disconnect");
	self endon(#"stop_stealth");
	self endon(#"death");
	self clientfield::set_to_player("stealth_alerted", 1);
	wait(0.15);
	self clientfield::set_to_player("stealth_alerted", 0);
}

/*
	Name: stealth_broken_sound
	Namespace: stealth_player
	Checksum: 0x4C2F4B61
	Offset: 0x1A48
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function stealth_broken_sound()
{
	stealth::function_e0319e51("combat");
}

/*
	Name: function_ca6a0809
	Namespace: stealth_player
	Checksum: 0xCD0E4C14
	Offset: 0x1A70
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_ca6a0809(enemy)
{
	if(enemy stealth_aware::enabled() && enemy stealth_aware::get_awareness() == "combat")
	{
		return;
	}
	self thread function_509ca7a6(enemy);
	self thread function_3f6bd04c(enemy);
}

/*
	Name: function_509ca7a6
	Namespace: stealth_player
	Checksum: 0x4745C0A9
	Offset: 0x1AF8
	Size: 0x6B4
	Parameters: 1
	Flags: Linked
*/
function function_509ca7a6(enemy)
{
	now = gettime();
	var_9f8c9118 = now;
	entnum = self getentitynumber();
	/#
		assert(isdefined(enemy));
	#/
	/#
		assert(isdefined(enemy.stealth));
	#/
	if(isdefined(self.stealth.incombat) && self.stealth.incombat)
	{
		return;
	}
	if(isdefined(enemy.stealth.var_d1c69a51) && isdefined(enemy.stealth.var_d1c69a51[entnum]) && (now - enemy.stealth.var_d1c69a51[entnum]) < 20000)
	{
		return;
	}
	if(getdvarint("stealth_indicator", 0))
	{
		enemy notify("sight_indicator_" + entnum);
		enemy endon("sight_indicator_" + entnum);
		enemy endon(#"death");
		if(!isdefined(enemy.stealth.var_d1c69a51))
		{
			enemy.stealth.var_d1c69a51 = [];
		}
		enemy.stealth.var_d1c69a51[entnum] = now;
		basealpha = 0.67;
		var_f69107b4 = 1000;
		index = entnum + var_f69107b4;
		enemy stealth_status::icon_show(self, var_f69107b4);
		str_shader = "white_stealth_spotting";
		color = (1, 1, 1);
		if(isdefined(enemy.stealth.status.icon_ent) && isdefined(enemy.stealth.status.icons[index]))
		{
			enemy.stealth.status.icons[index] settargetent(enemy.stealth.status.icon_ent);
			enemy.stealth.status.icons[index] setshader(str_shader, 5, 5);
			enemy.stealth.status.icons[index] setwaypoint(0, str_shader, 0, 0);
			enemy.stealth.status.icons[index].color = color;
			enemy.stealth.status.icons[index].alpha = basealpha;
			enemy.stealth.status.icons[index].var_c3d91e16 = gettime();
		}
		var_8c974758 = 1 * 1000;
		var_61fba14c = min(1000, var_8c974758);
		var_a4ef7967 = 0;
		while(var_a4ef7967 < var_8c974758)
		{
			if(enemy stealth_aware::get_awareness() == "combat")
			{
				var_a4ef7967 = max(var_8c974758 - var_61fba14c, var_a4ef7967);
			}
			var_ddb74378 = basealpha + (sin(float(gettime())) * (1 - basealpha));
			if((var_8c974758 - var_a4ef7967) <= var_61fba14c && isdefined(enemy.stealth.status.icon_ent) && isdefined(enemy.stealth.status.icons[index]))
			{
				alpha = var_ddb74378 * (float(var_8c974758 - var_a4ef7967)) / float(var_61fba14c);
				enemy.stealth.status.icons[index].alpha = min(max(alpha, 0), 1);
			}
			else
			{
				enemy.stealth.status.icons[index].alpha = min(max(var_ddb74378, 0), 1);
			}
			wait(0.05);
			var_a4ef7967 = var_a4ef7967 + 50;
		}
		enemy stealth_status::function_180adb28(index, var_f69107b4);
	}
}

/*
	Name: function_3f6bd04c
	Namespace: stealth_player
	Checksum: 0xE3891B8D
	Offset: 0x21B8
	Size: 0x294
	Parameters: 1
	Flags: Linked
*/
function function_3f6bd04c(enemy)
{
	/#
		assert(isdefined(self.stealth));
	#/
	now = gettime();
	if(isdefined(self.stealth.incombat) && self.stealth.incombat)
	{
		return;
	}
	if(isdefined(self.stealth.var_45848ab) && (now - self.stealth.var_45848ab) < 20000)
	{
		return;
	}
	self notify(#"hash_3f6bd04c");
	self endon(#"hash_3f6bd04c");
	self endon(#"disconnect");
	self endon(#"stop_stealth");
	self.stealth.var_45848ab = now;
	var_612fc483 = self.angles[1] - (vectortoangles(enemy.origin - self.origin)[1]);
	var_a113a204 = vectortoangles(enemy.origin - self.origin)[0];
	var_a113a204 = angleclamp180(var_a113a204);
	if(var_612fc483 < 0)
	{
		var_612fc483 = var_612fc483 + 360;
	}
	var_be26784d = "enemy_behind";
	if(var_a113a204 > 45)
	{
		var_be26784d = "enemy_below";
	}
	else
	{
		if(var_a113a204 < -45)
		{
			var_be26784d = "enemy_above";
		}
		else
		{
			if(var_612fc483 >= 315 || var_612fc483 <= 45)
			{
				var_be26784d = "enemy_ahead";
			}
			else
			{
				if(var_612fc483 >= 45 && var_612fc483 <= 135)
				{
					var_be26784d = "enemy_right";
				}
				else if(var_612fc483 >= 225 && var_612fc483 <= 315)
				{
					var_be26784d = "enemy_left";
				}
			}
		}
	}
	self stealth_vo::function_866c6270(var_be26784d, 1);
}

