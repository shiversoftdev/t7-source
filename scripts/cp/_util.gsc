// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\coop;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\load_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\string_shared;
#using scripts\shared\util_shared;

#namespace util;

/*
	Name: add_gametype
	Namespace: util
	Checksum: 0xDF2C10B4
	Offset: 0x580
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function add_gametype(gt)
{
}

/*
	Name: error
	Namespace: util
	Checksum: 0x4BA8D9B0
	Offset: 0x598
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
	Checksum: 0x4FC3A6D6
	Offset: 0x618
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
	Name: within_fov
	Namespace: util
	Checksum: 0x5A5DD738
	Offset: 0x658
	Size: 0xA2
	Parameters: 4
	Flags: None
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
	Checksum: 0xD017B532
	Offset: 0x708
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
	Checksum: 0xC661D7F
	Offset: 0x720
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
	Checksum: 0xF9A05FB7
	Offset: 0x768
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
	Checksum: 0x8947017D
	Offset: 0x7B0
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
	Checksum: 0x8FD7C138
	Offset: 0x9B8
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
	Checksum: 0x5394B20A
	Offset: 0xBE8
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
	Checksum: 0xC07FC4CE
	Offset: 0xCE8
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
	Checksum: 0x2080CF4B
	Offset: 0xDC8
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
	Checksum: 0xC2375D9
	Offset: 0xEA8
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
	Checksum: 0x8F3F64B8
	Offset: 0xF90
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
	Checksum: 0x6DD915AF
	Offset: 0xFB8
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
	Checksum: 0xF4320B79
	Offset: 0x10B0
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
	Checksum: 0x44B504FA
	Offset: 0x15D0
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
	Checksum: 0xE92F89DA
	Offset: 0x1628
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
	Checksum: 0x5793426
	Offset: 0x16A8
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
	Checksum: 0x7E0A6428
	Offset: 0x1718
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
	Checksum: 0x1BE427E3
	Offset: 0x17E8
	Size: 0x126
	Parameters: 5
	Flags: None
*/
function plot_points(plotpoints, r = 1, g = 1, b = 1, server_frames = 1)
{
	/#
		lastpoint = plotpoints[0];
		server_frames = int(server_frames);
		for(i = 1; i < plotpoints.size; i++)
		{
			line(lastpoint, plotpoints[i], (r, g, b), 1, server_frames);
			lastpoint = plotpoints[i];
		}
	#/
}

/*
	Name: getfx
	Namespace: util
	Checksum: 0x740149DF
	Offset: 0x1918
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
	Checksum: 0x69002AD8
	Offset: 0x1970
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
	Checksum: 0x469F7BDA
	Offset: 0x1A10
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
	Checksum: 0x5CC43A58
	Offset: 0x1AA8
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
	Name: add_trigger_to_ent
	Namespace: util
	Checksum: 0xD159A055
	Offset: 0x1B58
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
	Checksum: 0x3AB1DF54
	Offset: 0x1BC0
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
	Checksum: 0x20D53B0F
	Offset: 0x1C48
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
	Checksum: 0x97F36F82
	Offset: 0x1CC0
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
	Checksum: 0x7358CBDD
	Offset: 0x1D10
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
	Checksum: 0x73F82EDD
	Offset: 0x1EC0
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
	Checksum: 0xCB1C7A40
	Offset: 0x1F00
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
	Checksum: 0x41B8C145
	Offset: 0x1F20
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
	Checksum: 0x3B09E591
	Offset: 0x1FB0
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
	Checksum: 0x3EB3B383
	Offset: 0x1FF0
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
	Checksum: 0x8AF14CEC
	Offset: 0x2030
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
	Checksum: 0x721EC063
	Offset: 0x2070
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
	Checksum: 0xBE40CBD0
	Offset: 0x20B0
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
	Checksum: 0x2BD94D9D
	Offset: 0x20E0
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
	Checksum: 0x4E56EA
	Offset: 0x2110
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
	Checksum: 0x2FD99B1D
	Offset: 0x2140
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
	Checksum: 0xFD035CB3
	Offset: 0x21B0
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
	Checksum: 0xB70797AD
	Offset: 0x2220
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
	Checksum: 0xC487F20
	Offset: 0x2290
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
	Checksum: 0x67B07D14
	Offset: 0x2320
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
	Checksum: 0x70E37891
	Offset: 0x23B0
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
	Checksum: 0x8F0FFC76
	Offset: 0x2420
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
	Checksum: 0xECFC0627
	Offset: 0x24A8
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
	Checksum: 0xFD5BC1A0
	Offset: 0x2500
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function isflashbanged()
{
	return isdefined(self.flashendtime) && gettime() < self.flashendtime;
}

/*
	Name: isentstunned
	Namespace: util
	Checksum: 0x3460CF7E
	Offset: 0x2528
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function isentstunned()
{
	time = gettime();
	if(isdefined(self.stunned) && self.stunned)
	{
		return true;
	}
	if(self isflashbanged())
	{
		return true;
	}
	if(isdefined(self.stun_fx))
	{
		return true;
	}
	if(isdefined(self.laststunnedtime) && (self.laststunnedtime + 5000) > time)
	{
		return true;
	}
	if(isdefined(self.concussionendtime) && self.concussionendtime > time)
	{
		return true;
	}
	return false;
}

/*
	Name: domaxdamage
	Namespace: util
	Checksum: 0x5F65E78A
	Offset: 0x25E0
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
	Checksum: 0x9EE18FBF
	Offset: 0x26A8
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
	Checksum: 0x4F7A454C
	Offset: 0x26D8
	Size: 0x52C
	Parameters: 5
	Flags: Linked
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
	Checksum: 0x2397AB4D
	Offset: 0x2C10
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
	Name: screen_message_create_client
	Namespace: util
	Checksum: 0xCE784FE7
	Offset: 0x2CB0
	Size: 0x54C
	Parameters: 5
	Flags: Linked
*/
function screen_message_create_client(string_message_1, string_message_2, string_message_3, n_offset_y, n_time)
{
	self notify(#"screen_message_create");
	self endon(#"screen_message_create");
	self endon(#"death");
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
	if(!isdefined(self._screen_message_1))
	{
		self._screen_message_1 = newclienthudelem(self);
		self._screen_message_1.elemtype = "font";
		self._screen_message_1.font = "objective";
		self._screen_message_1.fontscale = 1.8;
		self._screen_message_1.horzalign = "center";
		self._screen_message_1.vertalign = "middle";
		self._screen_message_1.alignx = "center";
		self._screen_message_1.aligny = "middle";
		self._screen_message_1.y = -60 + n_offset_y;
		self._screen_message_1.sort = 2;
		self._screen_message_1.color = (1, 1, 1);
		self._screen_message_1.alpha = 1;
		self._screen_message_1.hidewheninmenu = 1;
	}
	self._screen_message_1 settext(string_message_1);
	if(isdefined(string_message_2))
	{
		if(!isdefined(self._screen_message_2))
		{
			self._screen_message_2 = newclienthudelem(self);
			self._screen_message_2.elemtype = "font";
			self._screen_message_2.font = "objective";
			self._screen_message_2.fontscale = 1.8;
			self._screen_message_2.horzalign = "center";
			self._screen_message_2.vertalign = "middle";
			self._screen_message_2.alignx = "center";
			self._screen_message_2.aligny = "middle";
			self._screen_message_2.y = -33 + n_offset_y;
			self._screen_message_2.sort = 2;
			self._screen_message_2.color = (1, 1, 1);
			self._screen_message_2.alpha = 1;
			self._screen_message_2.hidewheninmenu = 1;
		}
		self._screen_message_2 settext(string_message_2);
	}
	else if(isdefined(self._screen_message_2))
	{
		self._screen_message_2 destroy();
	}
	if(isdefined(string_message_3))
	{
		if(!isdefined(self._screen_message_3))
		{
			self._screen_message_3 = newclienthudelem(self);
			self._screen_message_3.elemtype = "font";
			self._screen_message_3.font = "objective";
			self._screen_message_3.fontscale = 1.8;
			self._screen_message_3.horzalign = "center";
			self._screen_message_3.vertalign = "middle";
			self._screen_message_3.alignx = "center";
			self._screen_message_3.aligny = "middle";
			self._screen_message_3.y = -6 + n_offset_y;
			self._screen_message_3.sort = 2;
			self._screen_message_3.color = (1, 1, 1);
			self._screen_message_3.alpha = 1;
			self._screen_message_3.hidewheninmenu = 1;
		}
		self._screen_message_3 settext(string_message_3);
	}
	else if(isdefined(self._screen_message_3))
	{
		self._screen_message_3 destroy();
	}
	if(isdefined(n_time) && n_time > 0)
	{
		wait(n_time);
		self screen_message_delete_client();
	}
}

/*
	Name: screen_message_delete_client
	Namespace: util
	Checksum: 0x2FA20BAD
	Offset: 0x3208
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function screen_message_delete_client(delay)
{
	self endon(#"death");
	if(isdefined(delay))
	{
		wait(delay);
	}
	if(isdefined(self._screen_message_1))
	{
		self._screen_message_1 destroy();
	}
	if(isdefined(self._screen_message_2))
	{
		self._screen_message_2 destroy();
	}
	if(isdefined(self._screen_message_3))
	{
		self._screen_message_3 destroy();
	}
}

/*
	Name: screen_fade_out
	Namespace: util
	Checksum: 0xEDF6A533
	Offset: 0x32B0
	Size: 0x3C
	Parameters: 3
	Flags: None
*/
function screen_fade_out(n_time, str_shader, str_menu_id)
{
	level lui::screen_fade_out(n_time, str_shader, str_menu_id);
}

/*
	Name: screen_fade_in
	Namespace: util
	Checksum: 0x5EE4EE3B
	Offset: 0x32F8
	Size: 0x3C
	Parameters: 3
	Flags: None
*/
function screen_fade_in(n_time, str_shader, str_menu_id)
{
	level lui::screen_fade_in(n_time, str_shader, str_menu_id);
}

/*
	Name: screen_fade_to_alpha_with_blur
	Namespace: util
	Checksum: 0x9EDB253F
	Offset: 0x3340
	Size: 0x122
	Parameters: 4
	Flags: Linked
*/
function screen_fade_to_alpha_with_blur(n_alpha, n_fade_time, n_blur, str_shader)
{
	/#
		assert(isdefined(n_alpha), "");
	#/
	/#
		assert(isplayer(self), "");
	#/
	level notify(#"_screen_fade");
	level endon(#"_screen_fade");
	hud_fade = get_fade_hud(str_shader);
	hud_fade fadeovertime(n_fade_time);
	hud_fade.alpha = n_alpha;
	if(isdefined(n_blur) && n_blur >= 0)
	{
		self setblur(n_blur, n_fade_time);
	}
	wait(n_fade_time);
}

/*
	Name: screen_fade_to_alpha
	Namespace: util
	Checksum: 0xF4C007B7
	Offset: 0x3470
	Size: 0x3C
	Parameters: 3
	Flags: None
*/
function screen_fade_to_alpha(n_alpha, n_fade_time, str_shader)
{
	screen_fade_to_alpha_with_blur(n_alpha, n_fade_time, 0, str_shader);
}

/*
	Name: get_fade_hud
	Namespace: util
	Checksum: 0x5A34BA90
	Offset: 0x34B8
	Size: 0xFA
	Parameters: 1
	Flags: Linked
*/
function get_fade_hud(str_shader = "black")
{
	if(!isdefined(level.fade_hud))
	{
		level.fade_hud = newhudelem();
		level.fade_hud.x = 0;
		level.fade_hud.y = 0;
		level.fade_hud.horzalign = "fullscreen";
		level.fade_hud.vertalign = "fullscreen";
		level.fade_hud.sort = 0;
		level.fade_hud.alpha = 0;
	}
	level.fade_hud setshader(str_shader, 640, 480);
	return level.fade_hud;
}

/*
	Name: missionfailedwrapper
	Namespace: util
	Checksum: 0x4A67E5CF
	Offset: 0x35C0
	Size: 0x154
	Parameters: 9
	Flags: Linked
*/
function missionfailedwrapper(fail_reason, fail_hint, shader, iwidth, iheight, fdelay, x, y, b_count_as_death = 1)
{
	if(level.missionfailed)
	{
		return;
	}
	if(isdefined(level.nextmission))
	{
		return;
	}
	if(getdvarstring("failure_disabled") == "1")
	{
		return;
	}
	screen_message_delete();
	if(isdefined(fail_hint))
	{
		setdvar("ui_deadquote", fail_hint);
	}
	if(isdefined(shader))
	{
		getplayers()[0] thread load::special_death_indicator_hudelement(shader, iwidth, iheight, fdelay, x, y);
	}
	level.missionfailed = 1;
	level thread coop::function_5ed5738a(fail_reason, fail_hint);
}

/*
	Name: missionfailedwrapper_nodeath
	Namespace: util
	Checksum: 0x5F9CED22
	Offset: 0x3720
	Size: 0x7C
	Parameters: 8
	Flags: Linked
*/
function missionfailedwrapper_nodeath(fail_reason, fail_hint, shader, iwidth, iheight, fdelay, x, y)
{
	missionfailedwrapper(fail_reason, fail_hint, shader, iwidth, iheight, fdelay, x, y, 0);
}

/*
	Name: helper_message
	Namespace: util
	Checksum: 0x1AE7F975
	Offset: 0x37A8
	Size: 0x13E
	Parameters: 3
	Flags: None
*/
function helper_message(message, delay, str_abort_flag)
{
	level notify(#"kill_helper_message");
	level endon(#"kill_helper_message");
	helper_message_delete();
	level.helper_message = message;
	screen_message_create(message);
	if(!isdefined(delay))
	{
		delay = 5;
	}
	start_time = gettime();
	while(true)
	{
		time = gettime();
		dt = (time - start_time) / 1000;
		if(dt >= delay)
		{
			break;
		}
		if(isdefined(str_abort_flag) && level flag::get(str_abort_flag) == 1)
		{
			break;
		}
		wait(0.01);
	}
	if(isdefined(level.helper_message))
	{
		screen_message_delete();
	}
	level.helper_message = undefined;
}

/*
	Name: helper_message_delete
	Namespace: util
	Checksum: 0x8DDA742B
	Offset: 0x38F0
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function helper_message_delete()
{
	if(isdefined(level.helper_message))
	{
		screen_message_delete();
	}
	level.helper_message = undefined;
}

/*
	Name: show_hit_marker
	Namespace: util
	Checksum: 0xBB3AE274
	Offset: 0x3928
	Size: 0x88
	Parameters: 0
	Flags: None
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
	Name: init_hero
	Namespace: util
	Checksum: 0x87CDF04C
	Offset: 0x39B8
	Size: 0x2F8
	Parameters: 8
	Flags: Linked
*/
function init_hero(name, func_init, arg1, arg2, arg3, arg4, arg5, b_show_in_ev = 1)
{
	if(!isdefined(level.heroes))
	{
		level.heroes = [];
	}
	name = tolower(name);
	ai_hero = getent(name + "_ai", "targetname", 1);
	if(!isalive(ai_hero))
	{
		ai_hero = getent(name, "targetname", 1);
		if(!isalive(ai_hero))
		{
			spawner = getent(name, "targetname");
			if(!(isdefined(spawner.spawning) && spawner.spawning))
			{
				spawner.count++;
				ai_hero = spawner::simple_spawn_single(spawner);
				/#
					assert(isdefined(ai_hero), ("" + name) + "");
				#/
				spawner notify(#"hero_spawned", ai_hero);
			}
			else
			{
				spawner waittill(#"hero_spawned", ai_hero);
			}
		}
	}
	level.heroes[name] = ai_hero;
	ai_hero.animname = name;
	ai_hero.is_hero = 1;
	ai_hero.enableterrainik = 1;
	ai_hero settmodeprovider(1);
	ai_hero magic_bullet_shield();
	ai_hero thread _hero_death(name);
	if(isdefined(func_init))
	{
		single_thread(ai_hero, func_init, arg1, arg2, arg3, arg4, arg5);
	}
	if(isdefined(level.customherospawn))
	{
		ai_hero [[level.customherospawn]]();
	}
	if(b_show_in_ev)
	{
		ai_hero thread oed::enable_thermal();
	}
	return ai_hero;
}

/*
	Name: init_heroes
	Namespace: util
	Checksum: 0x47B4BC7D
	Offset: 0x3CB8
	Size: 0x142
	Parameters: 7
	Flags: None
*/
function init_heroes(a_hero_names, func, arg1, arg2, arg3, arg4, arg5)
{
	a_heroes = [];
	foreach(str_hero in a_hero_names)
	{
		if(!isdefined(a_heroes))
		{
			a_heroes = [];
		}
		else if(!isarray(a_heroes))
		{
			a_heroes = array(a_heroes);
		}
		a_heroes[a_heroes.size] = init_hero(str_hero, func, arg1, arg2, arg3, arg4, arg5);
	}
	return a_heroes;
}

/*
	Name: _hero_death
	Namespace: util
	Checksum: 0x53A669F
	Offset: 0x3E08
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function _hero_death(str_name)
{
	self endon(#"unmake_hero");
	self waittill(#"death");
	if(isdefined(self))
	{
		/#
			assertmsg(("" + str_name) + "");
		#/
	}
	unmake_hero(str_name);
}

/*
	Name: unmake_hero
	Namespace: util
	Checksum: 0xE15BE440
	Offset: 0x3E88
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function unmake_hero(str_name)
{
	ai_hero = level.heroes[str_name];
	level.heroes = array::remove_index(level.heroes, str_name, 1);
	if(isalive(ai_hero))
	{
		ai_hero settmodeprovider(0);
		ai_hero stop_magic_bullet_shield();
		ai_hero notify(#"unmake_hero");
	}
}

/*
	Name: get_heroes
	Namespace: util
	Checksum: 0x6D811C4B
	Offset: 0x3F38
	Size: 0xA
	Parameters: 0
	Flags: None
*/
function get_heroes()
{
	return level.heroes;
}

/*
	Name: get_hero
	Namespace: util
	Checksum: 0xF3970B5B
	Offset: 0x3F50
	Size: 0x62
	Parameters: 1
	Flags: None
*/
function get_hero(str_name)
{
	if(!isdefined(level.heroes))
	{
		level.heroes = [];
	}
	if(isdefined(level.heroes[str_name]))
	{
		return level.heroes[str_name];
	}
	return init_hero(str_name);
}

/*
	Name: is_hero
	Namespace: util
	Checksum: 0xB2268FB6
	Offset: 0x3FC0
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function is_hero()
{
	return isdefined(self.is_hero) && self.is_hero;
}

/*
	Name: init_streamer_hints
	Namespace: util
	Checksum: 0x21171010
	Offset: 0x3FE0
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function init_streamer_hints(number_of_zones)
{
	clientfield::register("world", "force_streamer", 1, getminbitcountfornum(number_of_zones), "int");
}

/*
	Name: clear_streamer_hint
	Namespace: util
	Checksum: 0xEEBBD199
	Offset: 0x4038
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function clear_streamer_hint()
{
	level flag::wait_till("all_players_connected");
	level clientfield::set("force_streamer", 0);
}

/*
	Name: set_streamer_hint
	Namespace: util
	Checksum: 0xB2B3E65A
	Offset: 0x4088
	Size: 0x44
	Parameters: 2
	Flags: None
*/
function set_streamer_hint(n_zone, b_clear_previous = 1)
{
	level thread _set_streamer_hint(n_zone, b_clear_previous);
}

/*
	Name: _set_streamer_hint
	Namespace: util
	Checksum: 0xBBF3A563
	Offset: 0x40D8
	Size: 0x2BC
	Parameters: 2
	Flags: Linked
*/
function _set_streamer_hint(n_zone, b_clear_previous = 1)
{
	level notify(#"set_streamer_hint");
	level endon(#"set_streamer_hint");
	/#
		assert(n_zone > 0, "");
	#/
	level flagsys::set("streamer_loading");
	level flag::wait_till("all_players_connected");
	if(b_clear_previous)
	{
		level clientfield::set("force_streamer", 0);
		wait_network_frame();
	}
	level clientfield::set("force_streamer", n_zone);
	if(!isdefined(level.b_wait_for_streamer_default))
	{
		level.b_wait_for_streamer_default = 1;
		/#
			level.b_wait_for_streamer_default = 0;
		#/
	}
	foreach(player in level.players)
	{
		player thread _streamer_hint_wait(n_zone);
	}
	/#
		n_timeout = gettime() + 15000;
	#/
	array::wait_till(level.players, "streamer" + n_zone, 15);
	level flagsys::clear("streamer_loading");
	level streamer_wait();
	/#
		if(gettime() >= n_timeout)
		{
			printtoprightln("" + string::rfill(gettime(), 6, ""), (1, 0, 0));
		}
		else
		{
			printtoprightln("" + string::rfill(gettime(), 6, ""), (1, 1, 1));
		}
	#/
}

/*
	Name: _streamer_hint_wait
	Namespace: util
	Checksum: 0xE0CE45FB
	Offset: 0x43A0
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function _streamer_hint_wait(n_zone)
{
	self endon(#"disconnect");
	level endon(#"set_streamer_hint");
	self waittillmatch(#"streamer");
	self notify("streamer" + n_zone, n_zone);
}

/*
	Name: teleport_players_igc
	Namespace: util
	Checksum: 0x39C5A6C9
	Offset: 0x43F0
	Size: 0x15E
	Parameters: 2
	Flags: None
*/
function teleport_players_igc(str_spots, coop_sort)
{
	if(level.players.size <= 1)
	{
		return;
	}
	a_spots = skipto::get_spots(str_spots, coop_sort);
	/#
		assert(a_spots.size >= (level.players.size - 1), "");
	#/
	for(i = 0; i < (level.players.size - 1); i++)
	{
		level.players[i + 1] setorigin(a_spots[i].origin);
		if(isdefined(a_spots[i].angles))
		{
			level.players[i + 1] delay_network_frames(2, "disconnect", &setplayerangles, a_spots[i].angles);
		}
	}
}

/*
	Name: set_low_ready
	Namespace: util
	Checksum: 0x25258FBC
	Offset: 0x4558
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function set_low_ready(b_lowready)
{
	self setlowready(b_lowready);
	self setclientuivisibilityflag("weapon_hud_visible", !b_lowready);
	self allowjump(!b_lowready);
	self allowsprint(!b_lowready);
	self allowdoublejump(!b_lowready);
	if(b_lowready)
	{
		self disableoffhandweapons();
	}
	else
	{
		self enableoffhandweapons();
	}
	oed::enable_ev(!b_lowready);
	oed::enable_tac_mode(!b_lowready);
}

/*
	Name: cleanupactorcorpses
	Namespace: util
	Checksum: 0x93E62525
	Offset: 0x4658
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function cleanupactorcorpses()
{
	foreach(corpse in getcorpsearray())
	{
		if(isactorcorpse(corpse))
		{
			corpse delete();
		}
	}
}

/*
	Name: set_level_start_flag
	Namespace: util
	Checksum: 0x476200EA
	Offset: 0x4710
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function set_level_start_flag(str_flag)
{
	level.str_level_start_flag = str_flag;
	if(!flag::exists(str_flag))
	{
		level flag::init(level.str_level_start_flag);
	}
}

/*
	Name: set_player_start_flag
	Namespace: util
	Checksum: 0xFFF86BED
	Offset: 0x4768
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function set_player_start_flag(str_flag)
{
	level.str_player_start_flag = str_flag;
}

/*
	Name: set_rogue_controlled
	Namespace: util
	Checksum: 0x4B7047F
	Offset: 0x4788
	Size: 0xBE
	Parameters: 1
	Flags: None
*/
function set_rogue_controlled(b_state = 1)
{
	if(b_state)
	{
		self cybercom::cybercom_aioptout("cybercom_hijack");
		self cybercom::cybercom_aioptout("cybercom_iffoverride");
		self.rogue_controlled = 1;
	}
	else
	{
		self cybercom::cybercom_aiclearoptout("cybercom_hijack");
		self cybercom::cybercom_aiclearoptout("cybercom_iffoverride");
		self.rogue_controlled = undefined;
	}
}

/*
	Name: init_breath_fx
	Namespace: util
	Checksum: 0x61AD5FC3
	Offset: 0x4850
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function init_breath_fx()
{
	clientfield::register("toplayer", "player_cold_breath", 1, 1, "int");
	clientfield::register("actor", "ai_cold_breath", 1, 1, "counter");
}

/*
	Name: player_frost_breath
	Namespace: util
	Checksum: 0xC90EA492
	Offset: 0x48C0
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function player_frost_breath(b_true)
{
	self clientfield::set_to_player("player_cold_breath", b_true);
}

/*
	Name: ai_frost_breath
	Namespace: util
	Checksum: 0x30E700B1
	Offset: 0x48F8
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function ai_frost_breath()
{
	self endon(#"death");
	if(self.archetype === "human")
	{
		wait(randomfloatrange(1, 3));
		self clientfield::increment("ai_cold_breath");
	}
}

/*
	Name: show_hint_text
	Namespace: util
	Checksum: 0xD21C31
	Offset: 0x4960
	Size: 0x184
	Parameters: 4
	Flags: Linked
*/
function show_hint_text(str_text_to_show, b_should_blink = 0, str_turn_off_notify = "notify_turn_off_hint_text", n_display_time = 4)
{
	self endon(#"notify_turn_off_hint_text");
	self endon(#"hint_text_removed");
	if(isdefined(self.hint_menu_handle))
	{
		hide_hint_text(0);
	}
	self.hint_menu_handle = self openluimenu("CPHintText");
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
	Checksum: 0x90828D8F
	Offset: 0x4AF0
	Size: 0xC2
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
			waittill_any_timeout(0.75, "kill_hint_text", "death");
		}
		self closeluimenu(self.hint_menu_handle);
		self.hint_menu_handle = undefined;
	}
	self notify(#"hint_text_removed");
}

/*
	Name: fade_hint_text_after_time
	Namespace: util
	Checksum: 0xD3DA1A80
	Offset: 0x4BC0
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function fade_hint_text_after_time(n_display_time, str_turn_off_notify)
{
	self endon(#"hint_text_removed");
	self endon(#"death");
	self endon(#"kill_hint_text");
	waittill_any_timeout(n_display_time - 0.75, str_turn_off_notify);
	hide_hint_text(1);
}

/*
	Name: hide_hint_text_listener
	Namespace: util
	Checksum: 0x848B276D
	Offset: 0x4C40
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function hide_hint_text_listener(n_time)
{
	self endon(#"hint_text_removed");
	self endon(#"disconnect");
	waittill_any_timeout(n_time, "kill_hint_text", "death");
	hide_hint_text(0);
}

/*
	Name: show_event_message
	Namespace: util
	Checksum: 0x34EF5289
	Offset: 0x4CA8
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function show_event_message(player_handle, str_message)
{
	player_handle luinotifyevent(&"comms_event_message", 1, str_message);
}

/*
	Name: init_interactive_gameobject
	Namespace: util
	Checksum: 0xC7B9EDE3
	Offset: 0x4CF0
	Size: 0x264
	Parameters: 5
	Flags: Linked
*/
function init_interactive_gameobject(trigger, str_objective, str_hint_text, func_on_use, a_keyline_objects)
{
	trigger sethintstring(str_hint_text);
	trigger setcursorhint("HINT_INTERACTIVE_PROMPT");
	if(!isdefined(a_keyline_objects))
	{
		a_keyline_objects = [];
	}
	else
	{
		if(!isdefined(a_keyline_objects))
		{
			a_keyline_objects = [];
		}
		else if(!isarray(a_keyline_objects))
		{
			a_keyline_objects = array(a_keyline_objects);
		}
		foreach(mdl in a_keyline_objects)
		{
			mdl oed::enable_keyline(1);
		}
	}
	game_object = gameobjects::create_use_object("any", trigger, a_keyline_objects, (0, 0, 0), str_objective);
	game_object gameobjects::allow_use("any");
	game_object gameobjects::set_use_time(0.35);
	game_object gameobjects::set_owner_team("allies");
	game_object gameobjects::set_visible_team("any");
	game_object.single_use = 0;
	game_object.origin = game_object.origin;
	game_object.angles = game_object.angles;
	if(isdefined(func_on_use))
	{
		game_object.onuse = func_on_use;
	}
	return game_object;
}

