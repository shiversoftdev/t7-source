// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\ai_sniper_shared;
#using scripts\shared\stealth;
#using scripts\shared\stealth_behavior;
#using scripts\shared\stealth_debug;
#using scripts\shared\stealth_event;
#using scripts\shared\stealth_level;
#using scripts\shared\stealth_player;
#using scripts\shared\stealth_vo;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace stealth_aware;

/*
	Name: init
	Namespace: stealth_aware
	Checksum: 0x6F2FE7F1
	Offset: 0x318
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	/#
		assert(isdefined(self.stealth));
	#/
	self.stealth.aware_combat = [];
	self.stealth.aware_alerted = [];
	self.stealth.aware_sighted = [];
	/#
		self.stealth.debug_ignore = [];
	#/
	self set_awareness("unaware");
	self thread function_a85b6c52();
}

/*
	Name: enabled
	Namespace: stealth_aware
	Checksum: 0x98439DB6
	Offset: 0x3D0
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function enabled()
{
	return isdefined(self.stealth) && isdefined(self.stealth.aware_combat);
}

/*
	Name: set_awareness
	Namespace: stealth_aware
	Checksum: 0x6FC52195
	Offset: 0x3F8
	Size: 0x48C
	Parameters: 1
	Flags: Linked
*/
function set_awareness(str_awareness)
{
	/#
		assert(self enabled());
	#/
	prevawareness = self.awarenesslevelcurrent;
	if(!isdefined(prevawareness))
	{
		prevawareness = "unaware";
	}
	if(isdefined(self.awarenesslevelcurrent) && self.awarenesslevelcurrent != str_awareness)
	{
		self.awarenesslevelprevious = self.awarenesslevelcurrent;
	}
	self.awarenesslevelcurrent = str_awareness;
	bstealthmode = self.awarenesslevelcurrent != "combat";
	parms = stealth_level::get_parms(str_awareness);
	self.fovcosine = parms.fovcosine;
	self.fovcosinez = parms.fovcosinez;
	self.maxsightdist = parms.maxsightdist;
	self.maxsightdistsqrd = self.maxsightdist * self.maxsightdist;
	self.quiet_death = bstealthmode;
	self setstealthsightawareness(self.awarenesslevelcurrent, bstealthmode);
	if(isdefined(self.patroller) && self.patroller)
	{
		self.stealth.was_patrolling = 1;
	}
	else if(!(isdefined(self.stealth.was_patrolling) && self.stealth.was_patrolling) && !isdefined(self.stealth.var_b463484b) && self.awarenesslevelcurrent != "unaware")
	{
		self.stealth.var_b463484b = self.origin;
	}
	switch(self.awarenesslevelcurrent)
	{
		case "high_alert":
		case "low_alert":
		case "unaware":
		{
			self set_ignore_sentient_all(1);
			break;
		}
	}
	if(str_awareness == "unaware")
	{
		self.stealth.aware_combat = [];
		self.stealth.aware_alerted = [];
		self.stealth.aware_sighted = [];
		self serviceeventsinradius(self.origin, -1);
		if(isactor(self))
		{
			self clearenemy();
		}
		self.awarenesslevelprevious = "unaware";
		if(isdefined(self.stealth.was_patrolling) && self.stealth.was_patrolling && isdefined(self.currentgoal))
		{
			self thread ai::patrol(self.currentgoal);
		}
		else if(isdefined(self.stealth.var_b463484b))
		{
			if(isactor(self))
			{
				self thread stealth_behavior::function_edba2e78(self.stealth.var_b463484b);
			}
			self.stealth.var_b463484b = undefined;
		}
	}
	if(self ai::has_behavior_attribute("stealth"))
	{
		self ai::set_behavior_attribute("stealth", bstealthmode);
	}
	if(self ai::has_behavior_attribute("disablearrivals"))
	{
		self ai::set_behavior_attribute("disablearrivals", bstealthmode);
	}
	if(self stealth_vo::enabled())
	{
		self stealth_vo::set_stealth_mode(bstealthmode);
	}
	if(prevawareness != str_awareness)
	{
		self notify(#"awareness", str_awareness);
	}
	if(bstealthmode)
	{
		self.stealth.aware_combat = [];
	}
}

/*
	Name: get_awareness
	Namespace: stealth_aware
	Checksum: 0xA0B90120
	Offset: 0x890
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_awareness()
{
	return self.awarenesslevelcurrent;
}

/*
	Name: was_alerted
	Namespace: stealth_aware
	Checksum: 0xA8F6D3FE
	Offset: 0x8A8
	Size: 0x36
	Parameters: 1
	Flags: None
*/
function was_alerted(entity)
{
	return isdefined(self.stealth.aware_alerted[entity getentitynumber()]);
}

/*
	Name: change_awareness
	Namespace: stealth_aware
	Checksum: 0xD97730BA
	Offset: 0x8E8
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function change_awareness(delta)
{
	/#
		assert(self enabled());
	#/
	prevaware = self.awarenesslevelcurrent;
	abs_offset = abs(delta);
	if(abs_offset > 1)
	{
		for(i = 0; i < abs_offset; i++)
		{
			if(delta > 0)
			{
				change_awareness(1);
				continue;
			}
			change_awareness(-1);
		}
		return prevaware != self.awarenesslevelcurrent;
	}
	if(delta > 0)
	{
		switch(self.awarenesslevelcurrent)
		{
			case "low_alert":
			case "unaware":
			{
				self set_awareness("high_alert");
				break;
			}
			case "high_alert":
			{
				self set_awareness("combat");
				break;
			}
		}
	}
	else
	{
		switch(self.awarenesslevelcurrent)
		{
			case "high_alert":
			case "low_alert":
			{
				self set_awareness("unaware");
				break;
			}
			case "combat":
			{
				self set_awareness("high_alert");
				break;
			}
		}
	}
	return prevaware != self.awarenesslevelcurrent;
}

/*
	Name: set_ignore_sentient_all
	Namespace: stealth_aware
	Checksum: 0xF71AC81A
	Offset: 0xAD0
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function set_ignore_sentient_all(ignore)
{
	/#
		assert(self enabled());
	#/
	foreach(enemy in level.stealth.enemies[self.team])
	{
		if(!isdefined(enemy))
		{
			continue;
		}
		self set_ignore_sentient(enemy, ignore);
	}
}

/*
	Name: set_ignore_sentient
	Namespace: stealth_aware
	Checksum: 0xE2AED551
	Offset: 0xBC0
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function set_ignore_sentient(sentient, ignore)
{
	/#
		assert(self enabled());
	#/
	if(issentient(self) && issentient(sentient))
	{
		self setignoreent(sentient, ignore);
	}
	/#
		if(ignore)
		{
			self.stealth.debug_ignore[sentient getentitynumber()] = sentient;
		}
		else
		{
			self.stealth.debug_ignore[sentient getentitynumber()] = undefined;
		}
	#/
}

/*
	Name: function_ca6a0809
	Namespace: stealth_aware
	Checksum: 0x2B0B1D2E
	Offset: 0xCC0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_ca6a0809(eventpackage)
{
	self endon(#"death");
	self endon(#"disconnect");
	e_originator = eventpackage.parms[0];
	self notify(#"stealth_vo", "alert");
	if(isplayer(e_originator))
	{
		e_originator stealth_player::function_ca6a0809(self);
	}
}

/*
	Name: on_sighted
	Namespace: stealth_aware
	Checksum: 0xD5F98E8A
	Offset: 0xD50
	Size: 0x2CE
	Parameters: 1
	Flags: Linked
*/
function on_sighted(eventpackage)
{
	e_originator = eventpackage.parms[0];
	if(!isdefined(e_originator))
	{
		return;
	}
	debugreason = "";
	maxsightawareness = "unaware";
	curawareness = self get_awareness();
	var_f51f605d = e_originator getentitynumber();
	if(self stealth::is_enemy(e_originator) && isalive(e_originator))
	{
		maxsightawareness = "combat";
		/#
			debugreason = "";
		#/
	}
	else if(e_originator enabled() && e_originator get_awareness() == "combat")
	{
		maxsightawareness = "high_alert";
		/#
			debugreason = "";
		#/
	}
	var_edfa68f2 = 0;
	if(stealth::awareness_delta(curawareness, maxsightawareness) < 0)
	{
		var_edfa68f2 = self change_awareness(1);
	}
	if(var_edfa68f2 || !isdefined(self.stealth.aware_alerted[var_f51f605d]) || !isdefined(self.stealth.aware_sighted[var_f51f605d]))
	{
		curawareness = self get_awareness();
		self notify(#"alert", curawareness, e_originator.origin + vectorscale((0, 0, 1), 20), e_originator, debugreason);
		if(var_edfa68f2 && curawareness != "combat" && issentient(e_originator))
		{
			self setstealthsightvalue(e_originator, 0);
		}
	}
	if(isdefined(e_originator) && self stealth::is_enemy(e_originator))
	{
		self.stealth.aware_alerted[var_f51f605d] = e_originator;
		self.stealth.aware_sighted[var_f51f605d] = e_originator;
	}
}

/*
	Name: on_sight_end
	Namespace: stealth_aware
	Checksum: 0xEA238E8B
	Offset: 0x1028
	Size: 0x2FE
	Parameters: 1
	Flags: Linked
*/
function on_sight_end(eventpackage)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(getdvarint("stealth_no_return") && self get_awareness() == "combat")
	{
		return;
	}
	e_originator = eventpackage.parms[0];
	sightname = "on_sight_end";
	if(isdefined(e_originator))
	{
		sightname = (sightname + "_") + e_originator getentitynumber();
	}
	self notify(sightname);
	self endon(sightname);
	var_5400af02 = stealth::awareness_delta(self get_awareness(), "unaware");
	if(isdefined(self.stealth.investigating) && (self.stealth.investigating != "infinite" || var_5400af02 == 1))
	{
		self waittill(#"investigate_stop");
	}
	maxsightvalue = 0;
	foreach(enemy in self.stealth.aware_alerted)
	{
		if(!isdefined(enemy))
		{
			continue;
		}
		if(!issentient(enemy))
		{
			continue;
		}
		maxsightvalue = max(maxsightvalue, self getstealthsightvalue(enemy));
	}
	if(maxsightvalue <= 0 && self change_awareness(-1))
	{
		if(self get_awareness() != "unaware")
		{
			if(isdefined(e_originator))
			{
				if(issentient(e_originator))
				{
					self setstealthsightvalue(e_originator, 1);
				}
			}
			else
			{
				self notify(#"investigate", self.origin, undefined, "quick");
			}
		}
	}
}

/*
	Name: on_alert_changed
	Namespace: stealth_aware
	Checksum: 0x43368798
	Offset: 0x1330
	Size: 0x634
	Parameters: 1
	Flags: Linked
*/
function on_alert_changed(eventpackage)
{
	eventinterestpos = self geteventpointofinterest();
	v_origin = eventinterestpos;
	e_originator = self getcurrenteventoriginator();
	i_id = self getcurrenteventid();
	str_typename = self getcurrenteventtypename();
	str_newalert = eventpackage.parms[0];
	if(isdefined(str_typename) && str_typename == "grenade_ping")
	{
		str_newalert = "combat";
	}
	if(str_newalert == "low_alert")
	{
		str_newalert = "high_alert";
	}
	if(isdefined(eventpackage.parms[1]))
	{
		v_origin = eventpackage.parms[1];
	}
	if(isdefined(eventpackage.parms[2]))
	{
		e_originator = eventpackage.parms[2];
	}
	if(stealth::awareness_delta(str_newalert, self get_awareness()) >= 0)
	{
		if(isdefined(v_origin))
		{
			if(!isdefined(eventinterestpos) || distancesquared(v_origin, eventinterestpos) > 0.1)
			{
				deltaorigin = v_origin - self.origin;
				deltaangles = vectortoangles(deltaorigin);
				self.react_yaw = absangleclamp360(self.angles[1] - deltaangles[1]);
			}
			if(isactor(self))
			{
				if(str_newalert == "combat" && isdefined(e_originator))
				{
					self thread react_head_look(e_originator, 0.5);
				}
				else
				{
					self thread react_head_look(v_origin, 0.5);
				}
			}
		}
		/#
			debugreason = self getcurrenteventtypename() + self getcurrenteventname();
			if(!isdefined(debugreason) || debugreason == "")
			{
				debugreason = "";
			}
			if(isdefined(e_originator) && iscorpse(e_originator))
			{
				debugreason = "";
			}
			if(eventpackage.parms.size > 1)
			{
				debugreason = eventpackage.parms[eventpackage.parms.size - 1];
			}
			if(isdefined(debugreason) && isstring(debugreason))
			{
				self.stealth.debug_reason = debugreason;
			}
		#/
		if(str_typename == "explosion")
		{
			self notify(#"stealth_vo", "explosion");
		}
		else if(isdefined(e_originator) && iscorpse(e_originator))
		{
			self notify(#"stealth_vo", "corpse");
		}
		self set_awareness(str_newalert);
		switch(str_newalert)
		{
			case "high_alert":
			case "low_alert":
			{
				self notify(#"investigate", v_origin, e_originator);
				break;
			}
		}
		if(isdefined(i_id) && isdefined(e_originator) && iscorpse(e_originator))
		{
			self thread delayed_service_event(8, i_id);
		}
		if(isplayer(e_originator) && str_newalert == "combat" && level.stealth.var_e7ad9c1f == 0)
		{
			if(isdefined(self.blindaim) && self.blindaim)
			{
				e_originator stealth_vo::function_e3ae87b3("spotted_sniper", self, 2);
			}
			else
			{
				if(isvehicle(self))
				{
					e_originator stealth_vo::function_e3ae87b3("spotted_drone", self, 2);
				}
				else
				{
					e_originator stealth_vo::function_e3ae87b3("spotted", self, 2);
				}
			}
		}
	}
	if(isdefined(e_originator) && self stealth::is_enemy(e_originator))
	{
		self.stealth.aware_alerted[e_originator getentitynumber()] = e_originator;
		if(str_newalert == "combat")
		{
			self enter_combat_with(e_originator);
		}
	}
}

/*
	Name: function_101ac5
	Namespace: stealth_aware
	Checksum: 0xD0A7D45E
	Offset: 0x1970
	Size: 0x9E
	Parameters: 1
	Flags: Linked
*/
function function_101ac5(eventpackage)
{
	e_originator = eventpackage.parms[0];
	if(!isentity(e_originator))
	{
		return;
	}
	if(stealth::awareness_delta(self.awarenesslevelcurrent, self.awarenesslevelprevious) > 0)
	{
		self notify(#"alert", "combat", e_originator.origin, e_originator, "close_combat");
	}
}

/*
	Name: function_933965f6
	Namespace: stealth_aware
	Checksum: 0x4F3F1EC8
	Offset: 0x1A18
	Size: 0x244
	Parameters: 1
	Flags: Linked
*/
function function_933965f6(eventpackage)
{
	e_originator = eventpackage.parms[0];
	var_62bc230d = eventpackage.parms[1];
	if(self.awarenesslevelcurrent != "unaware")
	{
		return;
	}
	if(!isentity(e_originator))
	{
		return;
	}
	if(!isentity(var_62bc230d))
	{
		return;
	}
	if(stealth::awareness_delta(self.awarenesslevelcurrent, self.awarenesslevelprevious) > 0)
	{
		if(isdefined(self.stealth.var_c9b747e1) && (gettime() - self.stealth.var_c9b747e1) < 30000)
		{
			return;
		}
		goalpos = var_62bc230d getfinalpathpos();
		delta = goalpos - var_62bc230d.origin;
		if(lengthsquared(delta) > 250000)
		{
			var_fbbdb5f6 = var_62bc230d.origin + (vectornormalize(delta) * 500);
			deltaorigin = var_62bc230d.origin - self.origin;
			deltaangles = vectortoangles(deltaorigin);
			self.react_yaw = absangleclamp360(self.angles[1] - deltaangles[1]);
			self notify(#"investigate", var_fbbdb5f6, e_originator, "quick");
			self.stealth.var_c9b747e1 = gettime();
		}
	}
}

/*
	Name: alert_group
	Namespace: stealth_aware
	Checksum: 0xA69F4BFB
	Offset: 0x1C68
	Size: 0x1C2
	Parameters: 4
	Flags: None
*/
function alert_group(group, str_newalert, v_origin, e_originator)
{
	group = getaiarray(group, "script_aigroup");
	maxdistsq = getdvarint("stealth_group_radius", 1000);
	maxdistsq = maxdistsq * maxdistsq;
	foreach(guy in group)
	{
		if(guy == self)
		{
			continue;
		}
		if(!isalive(guy))
		{
			continue;
		}
		if(distancesquared(guy.origin, self.origin) > maxdistsq)
		{
			continue;
		}
		if(stealth::awareness_delta(str_newalert, guy get_awareness()) <= 0)
		{
			continue;
		}
		guy util::delay_notify(randomfloatrange(0.33, 0.66), "alert", undefined, str_newalert, v_origin, e_originator);
	}
}

/*
	Name: react_head_look
	Namespace: stealth_aware
	Checksum: 0xB0E20E5E
	Offset: 0x1E38
	Size: 0x25E
	Parameters: 2
	Flags: Linked
*/
function react_head_look(lookat, delay)
{
	self notify(#"react_head_look");
	self endon(#"react_head_look");
	ent = lookat;
	if(!isentity(lookat))
	{
		if(!isdefined(self.stealth_head_look_ent))
		{
			self.stealth_head_look_ent = spawn("script_model", lookat);
		}
		ent = self.stealth_head_look_ent;
	}
	else if(isdefined(self.stealth_head_look_ent))
	{
		self.stealth_head_look_ent delete();
		self.stealth_head_look_ent = undefined;
	}
	starttime = gettime();
	delayms = delay * 1000;
	wait(0.2);
	while(isalive(self) && (isdefined(self.stealth_reacting) && self.stealth_reacting))
	{
		if((gettime() - starttime) >= delayms)
		{
			self lookatentity(ent);
			/#
				if(stealth_debug::enabled())
				{
					line(self geteye(), ent.origin + vectorscale((0, 0, 1), 20), (0, 0, 1), 1, 1, 1);
					debugstar(ent.origin + vectorscale((0, 0, 1), 20), 1, (0, 0, 1));
				}
			#/
		}
		wait(0.05);
	}
	if(isdefined(self))
	{
		self lookatentity();
		if(isdefined(self.stealth_head_look_ent))
		{
			self.stealth_head_look_ent delete();
			self.stealth_head_look_ent = undefined;
		}
	}
}

/*
	Name: delayed_service_event
	Namespace: stealth_aware
	Checksum: 0xA0E34AB3
	Offset: 0x20A0
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function delayed_service_event(delay, id)
{
	self endon(#"death");
	wait(delay);
	self serviceevent(id);
}

/*
	Name: on_witness_combat
	Namespace: stealth_aware
	Checksum: 0xB38445BA
	Offset: 0x20E8
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function on_witness_combat(eventpackage)
{
	self endon(#"death");
	e_attacker = eventpackage.parms[0];
	debugreason = eventpackage.parms[1];
	if(isdefined(e_attacker))
	{
		if(stealth::awareness_delta(self get_awareness(), "high_alert") < 0)
		{
			self notify(#"alert", "high_alert", e_attacker.origin, e_attacker, debugreason);
		}
	}
}

/*
	Name: combat_alert_event
	Namespace: stealth_aware
	Checksum: 0x67F34230
	Offset: 0x21B0
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function combat_alert_event(e_attacker)
{
	self endon(#"death");
	if(isdefined(e_attacker) && self enabled())
	{
		wait(randomfloatrange(0.25, 0.75));
		self enter_combat_with(e_attacker);
	}
}

/*
	Name: enter_combat_with
	Namespace: stealth_aware
	Checksum: 0xBA707156
	Offset: 0x2228
	Size: 0x2B2
	Parameters: 1
	Flags: Linked
*/
function enter_combat_with(enemy)
{
	if(!self enabled())
	{
		return;
	}
	if(!isdefined(enemy) || !self stealth::is_enemy(enemy))
	{
		return;
	}
	self stealth_behavior::investigate_stop();
	self stopanimscripted();
	enemyentnum = enemy getentitynumber();
	self set_awareness("combat");
	self set_ignore_sentient(enemy, 0);
	if(!isdefined(self.stealth.aware_combat[enemyentnum]))
	{
		self.stealth.aware_combat[enemyentnum] = enemy;
		self.stealth.aware_alerted[enemyentnum] = enemy;
		self thread combat_spread_thread(enemy);
		self notify(#"stealth_vo", "enemy");
	}
	if(issentient(enemy))
	{
		self setstealthsightvalue(enemy, 1);
	}
	self ai_sniper::actor_lase_stop();
	if(isplayer(enemy) && getdvarint("stealth_all_aware"))
	{
		foreach(player in level.activeplayers)
		{
			if(player == enemy)
			{
				continue;
			}
			playerentnum = player getentitynumber();
			if(!isdefined(self.stealth.aware_combat[playerentnum]))
			{
				enter_combat_with(player);
			}
		}
	}
}

/*
	Name: combat_spread_thread
	Namespace: stealth_aware
	Checksum: 0x6B612CEF
	Offset: 0x24E8
	Size: 0x1F4
	Parameters: 1
	Flags: Linked
*/
function combat_spread_thread(enemy)
{
	self notify("combat_spread_thread_" + enemy getentitynumber());
	self endon("combat_spread_thread_" + enemy getentitynumber());
	self endon(#"death");
	idletime = 0;
	while(true)
	{
		wait(0.5);
		if(!isdefined(enemy) || enemy.health <= 0 || self get_awareness() != "combat" || (isdefined(self.silenced) && self.silenced))
		{
			break;
		}
		self stealth_event::broadcast_to_team(self.team, self.origin, 200, 100, 0, "combat_spread", "combat", enemy, self);
		self stealth_event::broadcast_to_team(self.team, self.origin, 400, 300, 1, "combat_interest", enemy, self);
		if(!isdefined(self.enemy) || !self stealth::can_see(self.enemy))
		{
			self setstealthsightawareness(self.awarenesslevelcurrent, 1);
		}
		else
		{
			self setstealthsightawareness(self.awarenesslevelcurrent, 0);
		}
	}
	self setstealthsightawareness(self.awarenesslevelcurrent, 1);
}

/*
	Name: function_a85b6c52
	Namespace: stealth_aware
	Checksum: 0xD0FC0BCD
	Offset: 0x26E8
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function function_a85b6c52()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"enemy");
		while(isdefined(self.enemy) && isalive(self.enemy))
		{
			if(isdefined(self.enemy.civilian) && self.enemy.civilian || (isdefined(self.enemy.lase_override) && (isdefined(self.enemy.lase_override.civilian) && self.enemy.lase_override.civilian)))
			{
				self.avoid_cover = 1;
				self.silentshot = 1;
			}
			else
			{
				self.avoid_cover = undefined;
				self.silentshot = 0;
			}
			wait(0.05);
		}
		self notify(#"stealth_sight_end", self.enemy);
	}
}

