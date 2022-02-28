// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;

#namespace util;

/*
	Name: error
	Namespace: util
	Checksum: 0x35EBBCC1
	Offset: 0x3B0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function error(msg)
{
	/#
		println("", msg);
		wait(0.05);
		if(getdvarstring("") != "")
		{
			/#
				assertmsg("");
			#/
		}
	#/
}

/*
	Name: warning
	Namespace: util
	Checksum: 0x999FC99C
	Offset: 0x430
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function warning(msg)
{
	/#
		println("" + msg);
	#/
}

/*
	Name: within_fov
	Namespace: util
	Checksum: 0x992E3BE3
	Offset: 0x470
	Size: 0xA2
	Parameters: 4
	Flags: Linked
*/
function within_fov(start_origin, start_angles, end_origin, fov)
{
	normal = vectornormalize(end_origin - start_origin);
	forward = anglestoforward(start_angles);
	dot = vectordot(forward, normal);
	return dot >= fov;
}

/*
	Name: get_player_height
	Namespace: util
	Checksum: 0x67A7E87C
	Offset: 0x520
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_player_height()
{
	return 70;
}

/*
	Name: isbulletimpactmod
	Namespace: util
	Checksum: 0xB7A36004
	Offset: 0x538
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function isbulletimpactmod(smeansofdeath)
{
	return issubstr(smeansofdeath, "BULLET") || smeansofdeath == "MOD_HEAD_SHOT";
}

/*
	Name: waitrespawnbutton
	Namespace: util
	Checksum: 0x199A247E
	Offset: 0x580
	Size: 0x40
	Parameters: 0
	Flags: None
*/
function waitrespawnbutton()
{
	self endon(#"disconnect");
	self endon(#"end_respawn");
	while(self usebuttonpressed() != 1)
	{
		wait(0.05);
	}
}

/*
	Name: setlowermessage
	Namespace: util
	Checksum: 0x2AD698A4
	Offset: 0x5C8
	Size: 0x200
	Parameters: 3
	Flags: Linked
*/
function setlowermessage(text, time, combinemessageandtimer)
{
	if(!isdefined(self.lowermessage))
	{
		return;
	}
	if(isdefined(self.lowermessageoverride) && text != (&""))
	{
		text = self.lowermessageoverride;
		time = undefined;
	}
	self notify(#"lower_message_set");
	self.lowermessage settext(text);
	if(isdefined(time) && time > 0)
	{
		if(!isdefined(combinemessageandtimer) || !combinemessageandtimer)
		{
			self.lowertimer.label = &"";
		}
		else
		{
			self.lowermessage settext("");
			self.lowertimer.label = text;
		}
		self.lowertimer settimer(time);
	}
	else
	{
		self.lowertimer settext("");
		self.lowertimer.label = &"";
	}
	if(self issplitscreen())
	{
		self.lowermessage.fontscale = 1.4;
	}
	self.lowermessage fadeovertime(0.05);
	self.lowermessage.alpha = 1;
	self.lowertimer fadeovertime(0.05);
	self.lowertimer.alpha = 1;
}

/*
	Name: setlowermessagevalue
	Namespace: util
	Checksum: 0x193D1A84
	Offset: 0x7D0
	Size: 0x228
	Parameters: 3
	Flags: None
*/
function setlowermessagevalue(text, value, combinemessage)
{
	if(!isdefined(self.lowermessage))
	{
		return;
	}
	if(isdefined(self.lowermessageoverride) && text != (&""))
	{
		text = self.lowermessageoverride;
		time = undefined;
	}
	self notify(#"lower_message_set");
	if(!isdefined(combinemessage) || !combinemessage)
	{
		self.lowermessage settext(text);
	}
	else
	{
		self.lowermessage settext("");
	}
	if(isdefined(value) && value > 0)
	{
		if(!isdefined(combinemessage) || !combinemessage)
		{
			self.lowertimer.label = &"";
		}
		else
		{
			self.lowertimer.label = text;
		}
		self.lowertimer setvalue(value);
	}
	else
	{
		self.lowertimer settext("");
		self.lowertimer.label = &"";
	}
	if(self issplitscreen())
	{
		self.lowermessage.fontscale = 1.4;
	}
	self.lowermessage fadeovertime(0.05);
	self.lowermessage.alpha = 1;
	self.lowertimer fadeovertime(0.05);
	self.lowertimer.alpha = 1;
}

/*
	Name: clearlowermessage
	Namespace: util
	Checksum: 0x380F59F4
	Offset: 0xA00
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function clearlowermessage(fadetime)
{
	if(!isdefined(self.lowermessage))
	{
		return;
	}
	self notify(#"lower_message_set");
	if(!isdefined(fadetime) || fadetime == 0)
	{
		setlowermessage(&"");
	}
	else
	{
		self endon(#"disconnect");
		self endon(#"lower_message_set");
		self.lowermessage fadeovertime(fadetime);
		self.lowermessage.alpha = 0;
		self.lowertimer fadeovertime(fadetime);
		self.lowertimer.alpha = 0;
		wait(fadetime);
		self setlowermessage("");
	}
}

/*
	Name: printonteam
	Namespace: util
	Checksum: 0x890AAB74
	Offset: 0xB00
	Size: 0xD6
	Parameters: 2
	Flags: None
*/
function printonteam(text, team)
{
	/#
		assert(isdefined(level.players));
	#/
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player iprintln(text);
		}
	}
}

/*
	Name: printboldonteam
	Namespace: util
	Checksum: 0xB46B3114
	Offset: 0xBE0
	Size: 0xD6
	Parameters: 2
	Flags: None
*/
function printboldonteam(text, team)
{
	/#
		assert(isdefined(level.players));
	#/
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player iprintlnbold(text);
		}
	}
}

/*
	Name: printboldonteamarg
	Namespace: util
	Checksum: 0x74035C02
	Offset: 0xCC0
	Size: 0xDE
	Parameters: 3
	Flags: None
*/
function printboldonteamarg(text, team, arg)
{
	/#
		assert(isdefined(level.players));
	#/
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(isdefined(player.pers["team"]) && player.pers["team"] == team)
		{
			player iprintlnbold(text, arg);
		}
	}
}

/*
	Name: printonteamarg
	Namespace: util
	Checksum: 0x238842A6
	Offset: 0xDA8
	Size: 0x1C
	Parameters: 3
	Flags: None
*/
function printonteamarg(text, team, arg)
{
}

/*
	Name: printonplayers
	Namespace: util
	Checksum: 0xA87D9305
	Offset: 0xDD0
	Size: 0xEE
	Parameters: 2
	Flags: None
*/
function printonplayers(text, team)
{
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(team))
		{
			if(isdefined(players[i].pers["team"]) && players[i].pers["team"] == team)
			{
				players[i] iprintln(text);
			}
			continue;
		}
		players[i] iprintln(text);
	}
}

/*
	Name: printandsoundoneveryone
	Namespace: util
	Checksum: 0x26CC4A64
	Offset: 0xEC8
	Size: 0x516
	Parameters: 7
	Flags: Linked
*/
function printandsoundoneveryone(team, enemyteam, printfriendly, printenemy, soundfriendly, soundenemy, printarg)
{
	shoulddosounds = isdefined(soundfriendly);
	shoulddoenemysounds = 0;
	if(isdefined(soundenemy))
	{
		/#
			assert(shoulddosounds);
		#/
		shoulddoenemysounds = 1;
	}
	if(!isdefined(printarg))
	{
		printarg = "";
	}
	if(level.splitscreen || !shoulddosounds)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if(isdefined(playerteam))
			{
				if(playerteam == team && isdefined(printfriendly) && printfriendly != (&""))
				{
					player iprintln(printfriendly, printarg);
					continue;
				}
				if(isdefined(printenemy) && printenemy != (&""))
				{
					if(isdefined(enemyteam) && playerteam == enemyteam)
					{
						player iprintln(printenemy, printarg);
						continue;
					}
					if(!isdefined(enemyteam) && playerteam != team)
					{
						player iprintln(printenemy, printarg);
					}
				}
			}
		}
		if(shoulddosounds)
		{
			/#
				assert(level.splitscreen);
			#/
			level.players[0] playlocalsound(soundfriendly);
		}
	}
	else
	{
		/#
			assert(shoulddosounds);
		#/
		if(shoulddoenemysounds)
		{
			for(i = 0; i < level.players.size; i++)
			{
				player = level.players[i];
				playerteam = player.pers["team"];
				if(isdefined(playerteam))
				{
					if(playerteam == team)
					{
						if(isdefined(printfriendly) && printfriendly != (&""))
						{
							player iprintln(printfriendly, printarg);
						}
						player playlocalsound(soundfriendly);
						continue;
					}
					if(isdefined(enemyteam) && playerteam == enemyteam || (!isdefined(enemyteam) && playerteam != team))
					{
						if(isdefined(printenemy) && printenemy != (&""))
						{
							player iprintln(printenemy, printarg);
						}
						player playlocalsound(soundenemy);
					}
				}
			}
		}
		else
		{
			for(i = 0; i < level.players.size; i++)
			{
				player = level.players[i];
				playerteam = player.pers["team"];
				if(isdefined(playerteam))
				{
					if(playerteam == team)
					{
						if(isdefined(printfriendly) && printfriendly != (&""))
						{
							player iprintln(printfriendly, printarg);
						}
						player playlocalsound(soundfriendly);
						continue;
					}
					if(isdefined(printenemy) && printenemy != (&""))
					{
						if(isdefined(enemyteam) && playerteam == enemyteam)
						{
							player iprintln(printenemy, printarg);
							continue;
						}
						if(!isdefined(enemyteam) && playerteam != team)
						{
							player iprintln(printenemy, printarg);
						}
					}
				}
			}
		}
	}
}

/*
	Name: _playlocalsound
	Namespace: util
	Checksum: 0x2FD5DD2D
	Offset: 0x13E8
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function _playlocalsound(soundalias)
{
	if(level.splitscreen && !self ishost())
	{
		return;
	}
	self playlocalsound(soundalias);
}

/*
	Name: getotherteam
	Namespace: util
	Checksum: 0x3AE8711C
	Offset: 0x1440
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function getotherteam(team)
{
	if(team == "allies")
	{
		return "axis";
	}
	if(team == "axis")
	{
		return "allies";
	}
	return "allies";
}

/*
	Name: getteammask
	Namespace: util
	Checksum: 0x63204842
	Offset: 0x14C0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function getteammask(team)
{
	if(!level.teambased || !isdefined(team) || !isdefined(level.spawnsystem.ispawn_teammask[team]))
	{
		return level.spawnsystem.ispawn_teammask_free;
	}
	return level.spawnsystem.ispawn_teammask[team];
}

/*
	Name: getotherteamsmask
	Namespace: util
	Checksum: 0xA6008AB9
	Offset: 0x1530
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function getotherteamsmask(skip_team)
{
	mask = 0;
	foreach(team in level.teams)
	{
		if(team == skip_team)
		{
			continue;
		}
		mask = mask | getteammask(team);
	}
	return mask;
}

/*
	Name: wait_endon
	Namespace: util
	Checksum: 0xD389B7C
	Offset: 0x1600
	Size: 0x74
	Parameters: 5
	Flags: Linked
*/
function wait_endon(waittime, endonstring, endonstring2, endonstring3, endonstring4)
{
	self endon(endonstring);
	if(isdefined(endonstring2))
	{
		self endon(endonstring2);
	}
	if(isdefined(endonstring3))
	{
		self endon(endonstring3);
	}
	if(isdefined(endonstring4))
	{
		self endon(endonstring4);
	}
	wait(waittime);
	return true;
}

/*
	Name: plot_points
	Namespace: util
	Checksum: 0x3F567D86
	Offset: 0x1680
	Size: 0x10E
	Parameters: 5
	Flags: Linked
*/
function plot_points(plotpoints, r, g, b, timer)
{
	/#
		lastpoint = plotpoints[0];
		if(!isdefined(r))
		{
			r = 1;
		}
		if(!isdefined(g))
		{
			g = 1;
		}
		if(!isdefined(b))
		{
			b = 1;
		}
		if(!isdefined(timer))
		{
			timer = 0.05;
		}
		for(i = 1; i < plotpoints.size; i++)
		{
			line(lastpoint, plotpoints[i], (r, g, b), 1, timer);
			lastpoint = plotpoints[i];
		}
	#/
}

/*
	Name: getfx
	Namespace: util
	Checksum: 0xBC3EF4BD
	Offset: 0x1798
	Size: 0x50
	Parameters: 1
	Flags: None
*/
function getfx(fx)
{
	/#
		assert(isdefined(level._effect[fx]), ("" + fx) + "");
	#/
	return level._effect[fx];
}

/*
	Name: set_dvar_if_unset
	Namespace: util
	Checksum: 0x9B0ED0A3
	Offset: 0x17F0
	Size: 0x92
	Parameters: 3
	Flags: Linked
*/
function set_dvar_if_unset(dvar, value, reset = 0)
{
	if(reset || getdvarstring(dvar) == "")
	{
		setdvar(dvar, value);
		return value;
	}
	return getdvarstring(dvar);
}

/*
	Name: set_dvar_float_if_unset
	Namespace: util
	Checksum: 0xEBB125BC
	Offset: 0x1890
	Size: 0x8A
	Parameters: 3
	Flags: None
*/
function set_dvar_float_if_unset(dvar, value, reset = 0)
{
	if(reset || getdvarstring(dvar) == "")
	{
		setdvar(dvar, value);
	}
	return getdvarfloat(dvar);
}

/*
	Name: set_dvar_int_if_unset
	Namespace: util
	Checksum: 0xD37540E4
	Offset: 0x1928
	Size: 0xA2
	Parameters: 3
	Flags: Linked
*/
function set_dvar_int_if_unset(dvar, value, reset = 0)
{
	if(reset || getdvarstring(dvar) == "")
	{
		setdvar(dvar, value);
		return int(value);
	}
	return getdvarint(dvar);
}

/*
	Name: add_trigger_to_ent
	Namespace: util
	Checksum: 0x8C32E329
	Offset: 0x19D8
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function add_trigger_to_ent(ent)
{
	if(!isdefined(ent._triggers))
	{
		ent._triggers = [];
	}
	ent._triggers[self getentitynumber()] = 1;
}

/*
	Name: remove_trigger_from_ent
	Namespace: util
	Checksum: 0xFC164DC4
	Offset: 0x1A40
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function remove_trigger_from_ent(ent)
{
	if(!isdefined(ent))
	{
		return;
	}
	if(!isdefined(ent._triggers))
	{
		return;
	}
	if(!isdefined(ent._triggers[self getentitynumber()]))
	{
		return;
	}
	ent._triggers[self getentitynumber()] = 0;
}

/*
	Name: ent_already_in_trigger
	Namespace: util
	Checksum: 0xCBFA7A71
	Offset: 0x1AC8
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function ent_already_in_trigger(trig)
{
	if(!isdefined(self._triggers))
	{
		return false;
	}
	if(!isdefined(self._triggers[trig getentitynumber()]))
	{
		return false;
	}
	if(!self._triggers[trig getentitynumber()])
	{
		return false;
	}
	return true;
}

/*
	Name: trigger_thread_death_monitor
	Namespace: util
	Checksum: 0xA379003D
	Offset: 0x1B40
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function trigger_thread_death_monitor(ent, ender)
{
	ent waittill(#"death");
	self endon(ender);
	self remove_trigger_from_ent(ent);
}

/*
	Name: trigger_thread
	Namespace: util
	Checksum: 0x8A6D7FF6
	Offset: 0x1B90
	Size: 0x1A6
	Parameters: 3
	Flags: None
*/
function trigger_thread(ent, on_enter_payload, on_exit_payload)
{
	ent endon(#"entityshutdown");
	ent endon(#"death");
	if(ent ent_already_in_trigger(self))
	{
		return;
	}
	self add_trigger_to_ent(ent);
	ender = (("end_trig_death_monitor" + self getentitynumber()) + " ") + ent getentitynumber();
	self thread trigger_thread_death_monitor(ent, ender);
	endon_condition = "leave_trigger_" + self getentitynumber();
	if(isdefined(on_enter_payload))
	{
		self thread [[on_enter_payload]](ent, endon_condition);
	}
	while(isdefined(ent) && ent istouching(self))
	{
		wait(0.01);
	}
	ent notify(endon_condition);
	if(isdefined(ent) && isdefined(on_exit_payload))
	{
		self thread [[on_exit_payload]](ent);
	}
	if(isdefined(ent))
	{
		self remove_trigger_from_ent(ent);
	}
	self notify(ender);
}

/*
	Name: isstrstart
	Namespace: util
	Checksum: 0x368601AE
	Offset: 0x1D40
	Size: 0x38
	Parameters: 2
	Flags: None
*/
function isstrstart(string1, substr)
{
	return getsubstr(string1, 0, substr.size) == substr;
}

/*
	Name: iskillstreaksenabled
	Namespace: util
	Checksum: 0x68124EFF
	Offset: 0x1D80
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function iskillstreaksenabled()
{
	return isdefined(level.killstreaksenabled) && level.killstreaksenabled;
}

/*
	Name: setusingremote
	Namespace: util
	Checksum: 0xC4013EFB
	Offset: 0x1DA0
	Size: 0xDA
	Parameters: 2
	Flags: Linked
*/
function setusingremote(remotename, set_killstreak_delay_killcam = 1)
{
	if(isdefined(self.carryicon))
	{
		self.carryicon.alpha = 0;
	}
	/#
		assert(!self isusingremote());
	#/
	self.usingremote = remotename;
	if(set_killstreak_delay_killcam)
	{
		self.killstreak_delay_killcam = remotename;
	}
	self disableoffhandweapons();
	self clientfield::set_player_uimodel("hudItems.remoteKillstreakActivated", 1);
	self notify(#"using_remote");
}

/*
	Name: setobjectivetext
	Namespace: util
	Checksum: 0x33171F8B
	Offset: 0x1E88
	Size: 0x32
	Parameters: 2
	Flags: Linked
*/
function setobjectivetext(team, text)
{
	game["strings"]["objective_" + team] = text;
}

/*
	Name: setobjectivescoretext
	Namespace: util
	Checksum: 0xCFBE3C2E
	Offset: 0x1EC8
	Size: 0x32
	Parameters: 2
	Flags: Linked
*/
function setobjectivescoretext(team, text)
{
	game["strings"]["objective_score_" + team] = text;
}

/*
	Name: setobjectivehinttext
	Namespace: util
	Checksum: 0x7606FE6A
	Offset: 0x1F08
	Size: 0x32
	Parameters: 2
	Flags: Linked
*/
function setobjectivehinttext(team, text)
{
	game["strings"]["objective_hint_" + team] = text;
}

/*
	Name: getobjectivetext
	Namespace: util
	Checksum: 0x168D0C90
	Offset: 0x1F48
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function getobjectivetext(team)
{
	return game["strings"]["objective_" + team];
}

/*
	Name: getobjectivescoretext
	Namespace: util
	Checksum: 0x61F761DE
	Offset: 0x1F78
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function getobjectivescoretext(team)
{
	return game["strings"]["objective_score_" + team];
}

/*
	Name: getobjectivehinttext
	Namespace: util
	Checksum: 0x7FBB9A2
	Offset: 0x1FA8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function getobjectivehinttext(team)
{
	return game["strings"]["objective_hint_" + team];
}

/*
	Name: registerroundswitch
	Namespace: util
	Checksum: 0xB766AED1
	Offset: 0x1FD8
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function registerroundswitch(minvalue, maxvalue)
{
	level.roundswitch = math::clamp(getgametypesetting("roundSwitch"), minvalue, maxvalue);
	level.roundswitchmin = minvalue;
	level.roundswitchmax = maxvalue;
}

/*
	Name: registerroundlimit
	Namespace: util
	Checksum: 0x221E1F6F
	Offset: 0x2048
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function registerroundlimit(minvalue, maxvalue)
{
	level.roundlimit = math::clamp(getgametypesetting("roundLimit"), minvalue, maxvalue);
	level.roundlimitmin = minvalue;
	level.roundlimitmax = maxvalue;
}

/*
	Name: registerroundwinlimit
	Namespace: util
	Checksum: 0x32B6F2
	Offset: 0x20B8
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function registerroundwinlimit(minvalue, maxvalue)
{
	level.roundwinlimit = math::clamp(getgametypesetting("roundWinLimit"), minvalue, maxvalue);
	level.roundwinlimitmin = minvalue;
	level.roundwinlimitmax = maxvalue;
}

/*
	Name: registerscorelimit
	Namespace: util
	Checksum: 0xFD59466
	Offset: 0x2128
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function registerscorelimit(minvalue, maxvalue)
{
	level.scorelimit = math::clamp(getgametypesetting("scoreLimit"), minvalue, maxvalue);
	level.scorelimitmin = minvalue;
	level.scorelimitmax = maxvalue;
	setdvar("ui_scorelimit", level.scorelimit);
}

/*
	Name: registerroundscorelimit
	Namespace: util
	Checksum: 0x48FCBA9F
	Offset: 0x21B8
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function registerroundscorelimit(minvalue, maxvalue)
{
	level.roundscorelimit = math::clamp(getgametypesetting("roundScoreLimit"), minvalue, maxvalue);
	level.roundscorelimitmin = minvalue;
	level.roundscorelimitmax = maxvalue;
}

/*
	Name: registertimelimit
	Namespace: util
	Checksum: 0x472A2371
	Offset: 0x2228
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function registertimelimit(minvalue, maxvalue)
{
	level.timelimit = math::clamp(getgametypesetting("timeLimit"), minvalue, maxvalue);
	level.timelimitmin = minvalue;
	level.timelimitmax = maxvalue;
	setdvar("ui_timelimit", level.timelimit);
}

/*
	Name: registernumlives
	Namespace: util
	Checksum: 0xFB209220
	Offset: 0x22B8
	Size: 0xEC
	Parameters: 4
	Flags: Linked
*/
function registernumlives(minvalue, maxvalue, teamlivesminvalue = minvalue, teamlivesmaxvalue = maxvalue)
{
	level.numlives = math::clamp(getgametypesetting("playerNumLives"), minvalue, maxvalue);
	level.numlivesmin = minvalue;
	level.numlivesmax = maxvalue;
	level.numteamlives = math::clamp(getgametypesetting("teamNumLives"), teamlivesminvalue, teamlivesmaxvalue);
	level.numteamlivesmin = teamlivesminvalue;
	level.numteamlivesmax = teamlivesmaxvalue;
}

/*
	Name: getplayerfromclientnum
	Namespace: util
	Checksum: 0x5E445E80
	Offset: 0x23B0
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function getplayerfromclientnum(clientnum)
{
	if(clientnum < 0)
	{
		return undefined;
	}
	for(i = 0; i < level.players.size; i++)
	{
		if(level.players[i] getentitynumber() == clientnum)
		{
			return level.players[i];
		}
	}
	return undefined;
}

/*
	Name: ispressbuild
	Namespace: util
	Checksum: 0x9D289341
	Offset: 0x2438
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function ispressbuild()
{
	buildtype = getdvarstring("buildType");
	if(isdefined(buildtype) && buildtype == "press")
	{
		return true;
	}
	return false;
}

/*
	Name: isflashbanged
	Namespace: util
	Checksum: 0x82F7F5DD
	Offset: 0x2490
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function isflashbanged()
{
	return isdefined(self.flashendtime) && gettime() < self.flashendtime;
}

/*
	Name: domaxdamage
	Namespace: util
	Checksum: 0x874C0072
	Offset: 0x24B8
	Size: 0xBC
	Parameters: 5
	Flags: None
*/
function domaxdamage(origin, attacker, inflictor, headshot, mod)
{
	if(isdefined(self.damagedtodeath) && self.damagedtodeath)
	{
		return;
	}
	if(isdefined(self.maxhealth))
	{
		damage = self.maxhealth + 1;
	}
	else
	{
		damage = self.health + 1;
	}
	self.damagedtodeath = 1;
	self dodamage(damage, origin, attacker, inflictor, headshot, mod);
}

/*
	Name: self_delete
	Namespace: util
	Checksum: 0x7A52CC76
	Offset: 0x2580
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function self_delete()
{
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: screen_message_create
	Namespace: util
	Checksum: 0x4CF14497
	Offset: 0x25B0
	Size: 0x52C
	Parameters: 5
	Flags: None
*/
function screen_message_create(string_message_1, string_message_2, string_message_3, n_offset_y, n_time)
{
	level notify(#"screen_message_create");
	level endon(#"screen_message_create");
	if(isdefined(level.missionfailed) && level.missionfailed)
	{
		return;
	}
	if(getdvarint("hud_missionFailed") == 1)
	{
		return;
	}
	if(!isdefined(n_offset_y))
	{
		n_offset_y = 0;
	}
	if(!isdefined(level._screen_message_1))
	{
		level._screen_message_1 = newhudelem();
		level._screen_message_1.elemtype = "font";
		level._screen_message_1.font = "objective";
		level._screen_message_1.fontscale = 1.8;
		level._screen_message_1.horzalign = "center";
		level._screen_message_1.vertalign = "middle";
		level._screen_message_1.alignx = "center";
		level._screen_message_1.aligny = "middle";
		level._screen_message_1.y = -60 + n_offset_y;
		level._screen_message_1.sort = 2;
		level._screen_message_1.color = (1, 1, 1);
		level._screen_message_1.alpha = 1;
		level._screen_message_1.hidewheninmenu = 1;
	}
	level._screen_message_1 settext(string_message_1);
	if(isdefined(string_message_2))
	{
		if(!isdefined(level._screen_message_2))
		{
			level._screen_message_2 = newhudelem();
			level._screen_message_2.elemtype = "font";
			level._screen_message_2.font = "objective";
			level._screen_message_2.fontscale = 1.8;
			level._screen_message_2.horzalign = "center";
			level._screen_message_2.vertalign = "middle";
			level._screen_message_2.alignx = "center";
			level._screen_message_2.aligny = "middle";
			level._screen_message_2.y = -33 + n_offset_y;
			level._screen_message_2.sort = 2;
			level._screen_message_2.color = (1, 1, 1);
			level._screen_message_2.alpha = 1;
			level._screen_message_2.hidewheninmenu = 1;
		}
		level._screen_message_2 settext(string_message_2);
	}
	else if(isdefined(level._screen_message_2))
	{
		level._screen_message_2 destroy();
	}
	if(isdefined(string_message_3))
	{
		if(!isdefined(level._screen_message_3))
		{
			level._screen_message_3 = newhudelem();
			level._screen_message_3.elemtype = "font";
			level._screen_message_3.font = "objective";
			level._screen_message_3.fontscale = 1.8;
			level._screen_message_3.horzalign = "center";
			level._screen_message_3.vertalign = "middle";
			level._screen_message_3.alignx = "center";
			level._screen_message_3.aligny = "middle";
			level._screen_message_3.y = -6 + n_offset_y;
			level._screen_message_3.sort = 2;
			level._screen_message_3.color = (1, 1, 1);
			level._screen_message_3.alpha = 1;
			level._screen_message_3.hidewheninmenu = 1;
		}
		level._screen_message_3 settext(string_message_3);
	}
	else if(isdefined(level._screen_message_3))
	{
		level._screen_message_3 destroy();
	}
	if(isdefined(n_time) && n_time > 0)
	{
		wait(n_time);
		screen_message_delete();
	}
}

/*
	Name: screen_message_delete
	Namespace: util
	Checksum: 0x1878C164
	Offset: 0x2AE8
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function screen_message_delete(delay)
{
	if(isdefined(delay))
	{
		wait(delay);
	}
	if(isdefined(level._screen_message_1))
	{
		level._screen_message_1 destroy();
	}
	if(isdefined(level._screen_message_2))
	{
		level._screen_message_2 destroy();
	}
	if(isdefined(level._screen_message_3))
	{
		level._screen_message_3 destroy();
	}
}

/*
	Name: ghost_wait_show
	Namespace: util
	Checksum: 0xB7D17F98
	Offset: 0x2B88
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function ghost_wait_show(wait_time = 0.1)
{
	self endon(#"death");
	self ghost();
	wait(wait_time);
	self show();
}

/*
	Name: ghost_wait_show_to_player
	Namespace: util
	Checksum: 0x22B04635
	Offset: 0x2BF0
	Size: 0x114
	Parameters: 3
	Flags: Linked
*/
function ghost_wait_show_to_player(player, wait_time = 0.1, self_endon_string1)
{
	if(!isdefined(self))
	{
		return;
	}
	self endon(#"death");
	self.abort_ghost_wait_show_to_player = undefined;
	if(isdefined(player))
	{
		player endon(#"death");
		player endon(#"disconnect");
		player endon(#"joined_team");
		player endon(#"joined_spectators");
	}
	if(isdefined(self_endon_string1))
	{
		self endon(self_endon_string1);
	}
	self ghost();
	self setinvisibletoall();
	self setvisibletoplayer(player);
	wait(wait_time);
	if(!isdefined(self.abort_ghost_wait_show_to_player))
	{
		self showtoplayer(player);
	}
}

/*
	Name: ghost_wait_show_to_others
	Namespace: util
	Checksum: 0x6B8CB56C
	Offset: 0x2D10
	Size: 0x10C
	Parameters: 3
	Flags: Linked
*/
function ghost_wait_show_to_others(player, wait_time = 0.1, self_endon_string1)
{
	if(!isdefined(self))
	{
		return;
	}
	self endon(#"death");
	self.abort_ghost_wait_show_to_others = undefined;
	if(isdefined(player))
	{
		player endon(#"death");
		player endon(#"disconnect");
		player endon(#"joined_team");
		player endon(#"joined_spectators");
	}
	if(isdefined(self_endon_string1))
	{
		self endon(self_endon_string1);
	}
	self ghost();
	self setinvisibletoplayer(player);
	wait(wait_time);
	if(!isdefined(self.abort_ghost_wait_show_to_others))
	{
		self show();
		self setinvisibletoplayer(player);
	}
}

/*
	Name: use_button_pressed
	Namespace: util
	Checksum: 0xE88B82C6
	Offset: 0x2E28
	Size: 0x4A
	Parameters: 0
	Flags: Linked
*/
function use_button_pressed()
{
	/#
		assert(isplayer(self), "");
	#/
	return self usebuttonpressed();
}

/*
	Name: waittill_use_button_pressed
	Namespace: util
	Checksum: 0xF3E2E015
	Offset: 0x2E80
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function waittill_use_button_pressed()
{
	while(!self use_button_pressed())
	{
		wait(0.05);
	}
}

/*
	Name: show_hint_text
	Namespace: util
	Checksum: 0x48CAF6C2
	Offset: 0x2EB8
	Size: 0x184
	Parameters: 4
	Flags: None
*/
function show_hint_text(str_text_to_show, b_should_blink = 0, str_turn_off_notify = "notify_turn_off_hint_text", n_display_time = 4)
{
	self endon(#"notify_turn_off_hint_text");
	self endon(#"hint_text_removed");
	if(isdefined(self.hint_menu_handle))
	{
		hide_hint_text(0);
	}
	self.hint_menu_handle = self openluimenu("MPHintText");
	self setluimenudata(self.hint_menu_handle, "hint_text_line", str_text_to_show);
	if(b_should_blink)
	{
		lui::play_animation(self.hint_menu_handle, "blinking");
	}
	else
	{
		lui::play_animation(self.hint_menu_handle, "display_noblink");
	}
	if(n_display_time != -1)
	{
		self thread hide_hint_text_listener(n_display_time);
		self thread fade_hint_text_after_time(n_display_time, str_turn_off_notify);
	}
}

/*
	Name: hide_hint_text
	Namespace: util
	Checksum: 0x1EE1C43
	Offset: 0x3048
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function hide_hint_text(b_fade_before_hiding = 1)
{
	self endon(#"hint_text_removed");
	if(isdefined(self.hint_menu_handle))
	{
		if(b_fade_before_hiding)
		{
			lui::play_animation(self.hint_menu_handle, "fadeout");
			waittill_any_timeout(0.75, "kill_hint_text", "death", "hint_text_removed");
		}
		self closeluimenu(self.hint_menu_handle);
		self.hint_menu_handle = undefined;
	}
	self notify(#"hint_text_removed");
}

/*
	Name: fade_hint_text_after_time
	Namespace: util
	Checksum: 0xF66AE44B
	Offset: 0x3120
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function fade_hint_text_after_time(n_display_time, str_turn_off_notify)
{
	self endon(#"hint_text_removed");
	self endon(#"death");
	self endon(#"kill_hint_text");
	waittill_any_timeout(n_display_time - 0.75, str_turn_off_notify, "hint_text_removed", "kill_hint_text");
	hide_hint_text(1);
}

/*
	Name: hide_hint_text_listener
	Namespace: util
	Checksum: 0xCE5FC1A5
	Offset: 0x31B0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function hide_hint_text_listener(n_time)
{
	self endon(#"hint_text_removed");
	self endon(#"disconnect");
	waittill_any_timeout(n_time, "kill_hint_text", "death", "hint_text_removed", "disconnect");
	hide_hint_text(0);
}

/*
	Name: set_team_radar
	Namespace: util
	Checksum: 0xB4AA6D2
	Offset: 0x3228
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function set_team_radar(team, value)
{
	if(team == "allies")
	{
		setmatchflag("radar_allies", value);
	}
	else if(team == "axis")
	{
		setmatchflag("radar_axis", value);
	}
}

/*
	Name: init_player_contract_events
	Namespace: util
	Checksum: 0xD19124A1
	Offset: 0x32A8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function init_player_contract_events()
{
	if(!isdefined(level.player_contract_events))
	{
		level.player_contract_events = [];
	}
}

/*
	Name: register_player_contract_event
	Namespace: util
	Checksum: 0xA0107447
	Offset: 0x32D0
	Size: 0x10A
	Parameters: 3
	Flags: Linked
*/
function register_player_contract_event(event_name, event_func, max_param_count = 0)
{
	if(!isdefined(level.player_contract_events[event_name]))
	{
		level.player_contract_events[event_name] = spawnstruct();
		level.player_contract_events[event_name].param_count = max_param_count;
		level.player_contract_events[event_name].events = [];
	}
	/#
		assert(max_param_count == level.player_contract_events[event_name].param_count);
	#/
	level.player_contract_events[event_name].events[level.player_contract_events[event_name].events.size] = event_func;
}

/*
	Name: player_contract_event
	Namespace: util
	Checksum: 0x8A82ACCC
	Offset: 0x33E8
	Size: 0x362
	Parameters: 4
	Flags: Linked
*/
function player_contract_event(event_name, param1 = undefined, param2 = undefined, param3 = undefined)
{
	if(!isdefined(level.player_contract_events[event_name]))
	{
		return;
	}
	param_count = (isdefined(level.player_contract_events[event_name].param_count) ? level.player_contract_events[event_name].param_count : 0);
	switch(param_count)
	{
		case 0:
		default:
		{
			foreach(event_func in level.player_contract_events[event_name].events)
			{
				if(isdefined(event_func))
				{
					self [[event_func]]();
				}
			}
			break;
		}
		case 1:
		{
			foreach(event_func in level.player_contract_events[event_name].events)
			{
				if(isdefined(event_func))
				{
					self [[event_func]](param1);
				}
			}
			break;
		}
		case 2:
		{
			foreach(event_func in level.player_contract_events[event_name].events)
			{
				if(isdefined(event_func))
				{
					self [[event_func]](param1, param2);
				}
			}
			break;
		}
		case 3:
		{
			foreach(event_func in level.player_contract_events[event_name].events)
			{
				if(isdefined(event_func))
				{
					self [[event_func]](param1, param2, param3);
				}
			}
			break;
		}
	}
}

/*
	Name: debug_slow_heli_speed
	Namespace: util
	Checksum: 0x1FC153E4
	Offset: 0x3758
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function debug_slow_heli_speed()
{
	/#
		if(getdvarint("", 0) > 0)
		{
			self setspeed(getdvarint(""));
		}
	#/
}

/*
	Name: is_objective_game
	Namespace: util
	Checksum: 0xFA6EC968
	Offset: 0x37B8
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function is_objective_game(game_type)
{
	switch(game_type)
	{
		case "conf":
		case "dm":
		case "gun":
		case "tdm":
		{
			return false;
			break;
		}
		default:
		{
			return true;
		}
	}
}

/*
	Name: isprophuntgametype
	Namespace: util
	Checksum: 0x5FF6C939
	Offset: 0x3818
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function isprophuntgametype()
{
	return isdefined(level.isprophunt) && level.isprophunt;
}

/*
	Name: isprop
	Namespace: util
	Checksum: 0x81B73453
	Offset: 0x3838
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function isprop()
{
	return isdefined(self.pers["team"]) && self.pers["team"] == game["defenders"];
}

/*
	Name: function_a7d853be
	Namespace: util
	Checksum: 0x20FF2EB6
	Offset: 0x3878
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function function_a7d853be(amount)
{
	if(getdvarint("ui_enablePromoTracking", 0))
	{
		function_a4c90358("cwl_thermometer", amount);
	}
}

/*
	Name: function_938b1b6b
	Namespace: util
	Checksum: 0x4114DCD5
	Offset: 0x38C8
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function function_938b1b6b()
{
	return isdefined(level.var_f817b02b) && level.var_f817b02b;
}

