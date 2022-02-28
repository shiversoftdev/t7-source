// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace util;

/*
	Name: error
	Namespace: util
	Checksum: 0xA1FD40F2
	Offset: 0x270
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
	Checksum: 0xA02AA6F1
	Offset: 0x2F0
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function warning(msg)
{
	/#
		println("" + msg);
	#/
}

/*
	Name: brush_delete
	Namespace: util
	Checksum: 0x29C03407
	Offset: 0x330
	Size: 0xEC
	Parameters: 0
	Flags: None
*/
function brush_delete()
{
	num = self.v["exploder"];
	if(isdefined(self.v["delay"]))
	{
		wait(self.v["delay"]);
	}
	else
	{
		wait(0.05);
	}
	if(!isdefined(self.model))
	{
		return;
	}
	/#
		assert(isdefined(self.model));
	#/
	if(!isdefined(self.v["fxid"]) || self.v["fxid"] == "No FX")
	{
		self.v["exploder"] = undefined;
	}
	waittillframeend();
	self.model delete();
}

/*
	Name: brush_show
	Namespace: util
	Checksum: 0x8DD2055D
	Offset: 0x428
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function brush_show()
{
	if(isdefined(self.v["delay"]))
	{
		wait(self.v["delay"]);
	}
	/#
		assert(isdefined(self.model));
	#/
	self.model show();
	self.model solid();
}

/*
	Name: brush_throw
	Namespace: util
	Checksum: 0x47E4C043
	Offset: 0x4B0
	Size: 0x20C
	Parameters: 0
	Flags: None
*/
function brush_throw()
{
	if(isdefined(self.v["delay"]))
	{
		wait(self.v["delay"]);
	}
	ent = undefined;
	if(isdefined(self.v["target"]))
	{
		ent = getent(self.v["target"], "targetname");
	}
	if(!isdefined(ent))
	{
		self.model delete();
		return;
	}
	self.model show();
	startorg = self.v["origin"];
	startang = self.v["angles"];
	org = ent.origin;
	temp_vec = org - self.v["origin"];
	x = temp_vec[0];
	y = temp_vec[1];
	z = temp_vec[2];
	self.model rotatevelocity((x, y, z), 12);
	self.model movegravity((x, y, z), 12);
	self.v["exploder"] = undefined;
	wait(6);
	self.model delete();
}

/*
	Name: playsoundonplayers
	Namespace: util
	Checksum: 0x8D6618CE
	Offset: 0x6C8
	Size: 0x176
	Parameters: 2
	Flags: Linked
*/
function playsoundonplayers(sound, team)
{
	/#
		assert(isdefined(level.players));
	#/
	if(level.splitscreen)
	{
		if(isdefined(level.players[0]))
		{
			level.players[0] playlocalsound(sound);
		}
	}
	else
	{
		if(isdefined(team))
		{
			for(i = 0; i < level.players.size; i++)
			{
				player = level.players[i];
				if(isdefined(player.pers["team"]) && player.pers["team"] == team)
				{
					player playlocalsound(sound);
				}
			}
		}
		else
		{
			for(i = 0; i < level.players.size; i++)
			{
				level.players[i] playlocalsound(sound);
			}
		}
	}
}

/*
	Name: get_player_height
	Namespace: util
	Checksum: 0xAF6A8C70
	Offset: 0x848
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
	Checksum: 0xF8A53991
	Offset: 0x860
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
	Checksum: 0x673C12E1
	Offset: 0x8A8
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
	Checksum: 0x393A04CD
	Offset: 0x8F0
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
	Checksum: 0x85B3CB54
	Offset: 0xAF8
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
	Checksum: 0xA108F191
	Offset: 0xD28
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
	Checksum: 0x4A3577E3
	Offset: 0xE28
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
	Checksum: 0x616F55C6
	Offset: 0xF08
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
	Checksum: 0x2F21DF99
	Offset: 0xFE8
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
	Checksum: 0x526CB98C
	Offset: 0x10D0
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
	Checksum: 0x72CB3B72
	Offset: 0x10F8
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
	Checksum: 0xBAAA1ADE
	Offset: 0x11F0
	Size: 0x516
	Parameters: 7
	Flags: None
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
	Checksum: 0xD456B4B4
	Offset: 0x1710
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
	Checksum: 0x260E7090
	Offset: 0x1768
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
	Checksum: 0xE633F130
	Offset: 0x17E8
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
	Checksum: 0x68A95EE8
	Offset: 0x1858
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
	Name: plot_points
	Namespace: util
	Checksum: 0x46F5F282
	Offset: 0x1928
	Size: 0x10E
	Parameters: 5
	Flags: None
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
	Checksum: 0xE2A1B730
	Offset: 0x1A40
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
	Checksum: 0xD0C9770F
	Offset: 0x1A98
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
	Checksum: 0xC7E74D2B
	Offset: 0x1B38
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
	Checksum: 0x494368F8
	Offset: 0x1BD0
	Size: 0xA2
	Parameters: 3
	Flags: None
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
	Name: isstrstart
	Namespace: util
	Checksum: 0x9C25316E
	Offset: 0x1C80
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
	Checksum: 0x5DFD93AA
	Offset: 0x1CC0
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function iskillstreaksenabled()
{
	return isdefined(level.killstreaksenabled) && level.killstreaksenabled;
}

/*
	Name: setusingremote
	Namespace: util
	Checksum: 0x394B61BA
	Offset: 0x1CE0
	Size: 0x82
	Parameters: 1
	Flags: None
*/
function setusingremote(remotename)
{
	if(isdefined(self.carryicon))
	{
		self.carryicon.alpha = 0;
	}
	/#
		assert(!self isusingremote());
	#/
	self.usingremote = remotename;
	self disableoffhandweapons();
	self notify(#"using_remote");
}

/*
	Name: getremotename
	Namespace: util
	Checksum: 0xFEA073EA
	Offset: 0x1D70
	Size: 0x32
	Parameters: 0
	Flags: None
*/
function getremotename()
{
	/#
		assert(self isusingremote());
	#/
	return self.usingremote;
}

/*
	Name: setobjectivetext
	Namespace: util
	Checksum: 0x977051AB
	Offset: 0x1DB0
	Size: 0x32
	Parameters: 2
	Flags: None
*/
function setobjectivetext(team, text)
{
	game["strings"]["objective_" + team] = text;
}

/*
	Name: setobjectivescoretext
	Namespace: util
	Checksum: 0x907EA9E3
	Offset: 0x1DF0
	Size: 0x32
	Parameters: 2
	Flags: None
*/
function setobjectivescoretext(team, text)
{
	game["strings"]["objective_score_" + team] = text;
}

/*
	Name: setobjectivehinttext
	Namespace: util
	Checksum: 0x74881B0
	Offset: 0x1E30
	Size: 0x32
	Parameters: 2
	Flags: None
*/
function setobjectivehinttext(team, text)
{
	game["strings"]["objective_hint_" + team] = text;
}

/*
	Name: getobjectivetext
	Namespace: util
	Checksum: 0xE4E71209
	Offset: 0x1E70
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
	Checksum: 0x337A7CA5
	Offset: 0x1EA0
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
	Checksum: 0x5C0B9BDD
	Offset: 0x1ED0
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
	Checksum: 0xC29B81F9
	Offset: 0x1F00
	Size: 0x64
	Parameters: 2
	Flags: None
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
	Checksum: 0x713C3392
	Offset: 0x1F70
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
	Checksum: 0xA14BF1E8
	Offset: 0x1FE0
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
	Checksum: 0x2003C062
	Offset: 0x2050
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
	Name: registertimelimit
	Namespace: util
	Checksum: 0x36D23CF6
	Offset: 0x20E0
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
	Checksum: 0x11C9519D
	Offset: 0x2170
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function registernumlives(minvalue, maxvalue)
{
	level.numlives = math::clamp(getgametypesetting("playerNumLives"), minvalue, maxvalue);
	level.numlivesmin = minvalue;
	level.numlivesmax = maxvalue;
}

/*
	Name: getplayerfromclientnum
	Namespace: util
	Checksum: 0xD89A118C
	Offset: 0x21E0
	Size: 0x7E
	Parameters: 1
	Flags: None
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
	Checksum: 0xB7703687
	Offset: 0x2268
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
	Checksum: 0x5B41C029
	Offset: 0x22C0
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
	Checksum: 0x4C7FC933
	Offset: 0x22E8
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
	Name: get_array_of_closest
	Namespace: util
	Checksum: 0xBFD0E975
	Offset: 0x23B0
	Size: 0x328
	Parameters: 5
	Flags: None
*/
function get_array_of_closest(org, array, excluders = [], max = array.size, maxdist)
{
	maxdists2rd = undefined;
	if(isdefined(maxdist))
	{
		maxdists2rd = maxdist * maxdist;
	}
	dist = [];
	index = [];
	for(i = 0; i < array.size; i++)
	{
		if(!isdefined(array[i]))
		{
			continue;
		}
		if(isinarray(excluders, array[i]))
		{
			continue;
		}
		if(isvec(array[i]))
		{
			length = distancesquared(org, array[i]);
		}
		else
		{
			length = distancesquared(org, array[i].origin);
		}
		if(isdefined(maxdists2rd) && maxdists2rd < length)
		{
			continue;
		}
		dist[dist.size] = length;
		index[index.size] = i;
	}
	for(;;)
	{
		change = 0;
		for(i = 0; i < (dist.size - 1); i++)
		{
			if(dist[i] <= (dist[i + 1]))
			{
				continue;
			}
			change = 1;
			temp = dist[i];
			dist[i] = dist[i + 1];
			dist[i + 1] = temp;
			temp = index[i];
			index[i] = index[i + 1];
			index[i + 1] = temp;
		}
		if(!change)
		{
			break;
		}
	}
	newarray = [];
	if(max > dist.size)
	{
		max = dist.size;
	}
	for(i = 0; i < max; i++)
	{
		newarray[i] = array[index[i]];
	}
	return newarray;
}

