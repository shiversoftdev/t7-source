// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\bots\bot_traversals;
#using scripts\shared\callbacks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace bot;

/*
	Name: __init__sytem__
	Namespace: bot
	Checksum: 0xD24E8FB0
	Offset: 0x3D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bot
	Checksum: 0xCDD1D3B8
	Offset: 0x418
	Size: 0x2DC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	callback::on_player_killed(&on_player_killed);
	if(!isdefined(level.getbotsettings))
	{
		level.getbotsettings = &get_bot_default_settings;
	}
	if(!isdefined(level.onbotremove))
	{
		level.onbotremove = &bot_void;
	}
	if(!isdefined(level.onbotconnect))
	{
		level.onbotconnect = &bot_void;
	}
	if(!isdefined(level.onbotspawned))
	{
		level.onbotspawned = &bot_void;
	}
	if(!isdefined(level.onbotkilled))
	{
		level.onbotkilled = &bot_void;
	}
	if(!isdefined(level.onbotdamage))
	{
		level.onbotdamage = &bot_void;
	}
	if(!isdefined(level.botupdate))
	{
		level.botupdate = &bot_update;
	}
	if(!isdefined(level.botprecombat))
	{
		level.botprecombat = &bot_void;
	}
	if(!isdefined(level.botcombat))
	{
		level.botcombat = &bot_combat::combat_think;
	}
	if(!isdefined(level.botpostcombat))
	{
		level.botpostcombat = &bot_void;
	}
	if(!isdefined(level.botidle))
	{
		level.botidle = &bot_void;
	}
	if(!isdefined(level.botthreatdead))
	{
		level.botthreatdead = &bot_combat::clear_threat;
	}
	if(!isdefined(level.botthreatengage))
	{
		level.botthreatengage = &bot_combat::engage_threat;
	}
	if(!isdefined(level.botupdatethreatgoal))
	{
		level.botupdatethreatgoal = &bot_combat::update_threat_goal;
	}
	if(!isdefined(level.botthreatlost))
	{
		level.botthreatlost = &bot_combat::clear_threat;
	}
	if(!isdefined(level.botgetthreats))
	{
		level.botgetthreats = &bot_combat::get_bot_threats;
	}
	if(!isdefined(level.botignorethreat))
	{
		level.botignorethreat = &bot_combat::ignore_non_sentient;
	}
	setdvar("bot_maxMantleHeight", 200);
	/#
		level thread bot_devgui_think();
	#/
}

/*
	Name: init
	Namespace: bot
	Checksum: 0x40462943
	Offset: 0x700
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function init()
{
	init_bot_settings();
}

/*
	Name: is_bot_ranked_match
	Namespace: bot
	Checksum: 0xE404801D
	Offset: 0x720
	Size: 0x6
	Parameters: 0
	Flags: None
*/
function is_bot_ranked_match()
{
	return false;
}

/*
	Name: bot_void
	Namespace: bot
	Checksum: 0x99EC1590
	Offset: 0x730
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function bot_void()
{
}

/*
	Name: bot_unhandled
	Namespace: bot
	Checksum: 0x4AA714A7
	Offset: 0x740
	Size: 0x6
	Parameters: 0
	Flags: None
*/
function bot_unhandled()
{
	return false;
}

/*
	Name: add_bots
	Namespace: bot
	Checksum: 0xD1C99D13
	Offset: 0x750
	Size: 0x56
	Parameters: 2
	Flags: Linked
*/
function add_bots(count, team)
{
	for(i = 0; i < count; i++)
	{
		add_bot(team);
	}
}

/*
	Name: add_bot
	Namespace: bot
	Checksum: 0xC535196A
	Offset: 0x7B0
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function add_bot(team)
{
	botent = addtestclient();
	if(!isdefined(botent))
	{
		return undefined;
	}
	botent botsetrandomcharactercustomization();
	if(isdefined(level.disableclassselection) && level.disableclassselection)
	{
		botent.pers["class"] = level.defaultclass;
		botent.curclass = level.defaultclass;
	}
	if(level.teambased && team !== "autoassign")
	{
		botent.pers["team"] = team;
	}
	return botent;
}

/*
	Name: remove_bots
	Namespace: bot
	Checksum: 0xCD6DF001
	Offset: 0x890
	Size: 0x112
	Parameters: 2
	Flags: Linked
*/
function remove_bots(count, team)
{
	players = getplayers();
	foreach(player in players)
	{
		if(!player istestclient())
		{
			continue;
		}
		if(isdefined(team) && player.team != team)
		{
			continue;
		}
		remove_bot(player);
		if(isdefined(count))
		{
			count--;
			if(count <= 0)
			{
				break;
			}
		}
	}
}

/*
	Name: remove_bot
	Namespace: bot
	Checksum: 0x89FE72DD
	Offset: 0x9B0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function remove_bot(bot)
{
	if(!bot istestclient())
	{
		return;
	}
	bot [[level.onbotremove]]();
	bot botdropclient();
}

/*
	Name: filter_bots
	Namespace: bot
	Checksum: 0x66B013FC
	Offset: 0xA10
	Size: 0xBA
	Parameters: 1
	Flags: None
*/
function filter_bots(players)
{
	bots = [];
	foreach(player in players)
	{
		if(player util::is_bot())
		{
			bots[bots.size] = player;
		}
	}
	return bots;
}

/*
	Name: on_player_connect
	Namespace: bot
	Checksum: 0xCA8F5DAC
	Offset: 0xAD8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	if(!self istestclient())
	{
		return;
	}
	self endon(#"disconnect");
	self.bot = spawnstruct();
	self.bot.threat = spawnstruct();
	self.bot.damage = spawnstruct();
	self.pers["isBot"] = 1;
	if(level.teambased)
	{
		self notify(#"menuresponse", game["menu_team"], self.team);
		wait(0.5);
	}
	self notify(#"joined_team");
	callback::callback(#"hash_95a6c4c0");
	self thread [[level.onbotconnect]]();
}

/*
	Name: on_player_spawned
	Namespace: bot
	Checksum: 0xBA949B8D
	Offset: 0xBE8
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	if(!self util::is_bot())
	{
		return;
	}
	self clear_stuck();
	self bot_combat::clear_threat();
	self.bot.prevweapon = undefined;
	self botlookforward();
	self thread [[level.onbotspawned]]();
	self thread bot_combat::wait_damage_loop();
	self thread wait_bot_path_failed_loop();
	self thread wait_bot_goal_reached_loop();
	self thread bot_think_loop();
}

/*
	Name: on_player_killed
	Namespace: bot
	Checksum: 0x8F8A5E9
	Offset: 0xCD0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function on_player_killed()
{
	if(!self util::is_bot())
	{
		return;
	}
	self thread [[level.onbotkilled]]();
	self botreleasemanualcontrol();
}

/*
	Name: bot_think_loop
	Namespace: bot
	Checksum: 0x8D6BE3A8
	Offset: 0xD20
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function bot_think_loop()
{
	self endon(#"death");
	level endon(#"game_ended");
	while(true)
	{
		self bot_think();
		wait(level.botsettings.thinkinterval);
	}
}

/*
	Name: bot_think
	Namespace: bot
	Checksum: 0x5B437328
	Offset: 0xD70
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function bot_think()
{
	self botreleasebuttons();
	if(level.inprematchperiod || level.gameended || !isalive(self))
	{
		return;
	}
	self check_stuck();
	self sprint_think();
	self update_swim();
	self thread [[level.botupdate]]();
	self thread [[level.botprecombat]]();
	self thread [[level.botcombat]]();
	self thread [[level.botpostcombat]]();
	if(!self bot_combat::has_threat() && !self botgoalset())
	{
		self thread [[level.botidle]]();
	}
}

/*
	Name: bot_update
	Namespace: bot
	Checksum: 0x99EC1590
	Offset: 0xE88
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function bot_update()
{
}

/*
	Name: update_swim
	Namespace: bot
	Checksum: 0xDD977F64
	Offset: 0xE98
	Size: 0x2BC
	Parameters: 0
	Flags: Linked
*/
function update_swim()
{
	if(!self isplayerswimming())
	{
		self.bot.resurfacetime = undefined;
		return;
	}
	if(self isplayerunderwater())
	{
		if(!isdefined(self.bot.resurfacetime))
		{
			self.bot.resurfacetime = gettime() + level.botsettings.swimtime;
		}
	}
	else
	{
		self.bot.resurfacetime = undefined;
	}
	if(self botundermanualcontrol())
	{
		return;
	}
	goalposition = self botgetgoalposition();
	if(distance2dsquared(goalposition, self.origin) <= 16384 && getwaterheight(goalposition) > 0)
	{
		self press_swim_down();
		return;
	}
	if(isdefined(self.bot.resurfacetime) && self.bot.resurfacetime <= gettime())
	{
		press_swim_up();
		return;
	}
	bottomtrace = groundtrace(self.origin, self.origin + (vectorscale((0, 0, -1), 1000)), 0, self, 1);
	swimheight = self.origin[2] - bottomtrace["position"][2];
	if(swimheight < 25)
	{
		self press_swim_up();
		vertdist = 25 - swimheight;
	}
	else if(swimheight > 45)
	{
		self press_swim_down();
		vertdist = swimheight - 45;
	}
	if(isdefined(vertdist))
	{
		intervaldist = level.botsettings.swimverticalspeed * level.botsettings.thinkinterval;
		if(intervaldist > vertdist)
		{
			self wait_release_swim_buttons((level.botsettings.thinkinterval * vertdist) / intervaldist);
		}
	}
}

/*
	Name: wait_release_swim_buttons
	Namespace: bot
	Checksum: 0x3D46EB
	Offset: 0x1160
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function wait_release_swim_buttons(waittime)
{
	self endon(#"death");
	level endon(#"game_ended");
	wait(waittime);
	self release_swim_up();
	self release_swim_down();
}

/*
	Name: init_bot_settings
	Namespace: bot
	Checksum: 0xB6CC53AB
	Offset: 0x11C0
	Size: 0x688
	Parameters: 0
	Flags: Linked
*/
function init_bot_settings()
{
	level.botsettings = [[level.getbotsettings]]();
	setdvar("bot_AllowMelee", (isdefined(level.botsettings.allowmelee) ? level.botsettings.allowmelee : 0));
	setdvar("bot_AllowGrenades", (isdefined(level.botsettings.allowgrenades) ? level.botsettings.allowgrenades : 0));
	setdvar("bot_AllowKillstreaks", (isdefined(level.botsettings.allowkillstreaks) ? level.botsettings.allowkillstreaks : 0));
	setdvar("bot_AllowHeroGadgets", (isdefined(level.botsettings.allowherogadgets) ? level.botsettings.allowherogadgets : 0));
	setdvar("bot_Fov", (isdefined(level.botsettings.fov) ? level.botsettings.fov : 0));
	setdvar("bot_FovAds", (isdefined(level.botsettings.fovads) ? level.botsettings.fovads : 0));
	setdvar("bot_PitchSensitivity", level.botsettings.pitchsensitivity);
	setdvar("bot_YawSensitivity", level.botsettings.yawsensitivity);
	setdvar("bot_PitchSpeed", (isdefined(level.botsettings.pitchspeed) ? level.botsettings.pitchspeed : 0));
	setdvar("bot_PitchSpeedAds", (isdefined(level.botsettings.pitchspeedads) ? level.botsettings.pitchspeedads : 0));
	setdvar("bot_YawSpeed", (isdefined(level.botsettings.yawspeed) ? level.botsettings.yawspeed : 0));
	setdvar("bot_YawSpeedAds", (isdefined(level.botsettings.yawspeedads) ? level.botsettings.yawspeedads : 0));
	setdvar("pitchAccelerationTime", (isdefined(level.botsettings.pitchaccelerationtime) ? level.botsettings.pitchaccelerationtime : 0));
	setdvar("yawAccelerationTime", (isdefined(level.botsettings.yawaccelerationtime) ? level.botsettings.yawaccelerationtime : 0));
	setdvar("pitchDecelerationThreshold", (isdefined(level.botsettings.pitchdecelerationthreshold) ? level.botsettings.pitchdecelerationthreshold : 0));
	setdvar("yawDecelerationThreshold", (isdefined(level.botsettings.yawdecelerationthreshold) ? level.botsettings.yawdecelerationthreshold : 0));
	meleerange = getdvarint("player_meleeRangeDefault") * (isdefined(level.botsettings.meleerangemultiplier) ? level.botsettings.meleerangemultiplier : 0);
	level.botsettings.meleerange = int(meleerange);
	level.botsettings.meleerangesq = meleerange * meleerange;
	level.botsettings.threatradiusminsq = level.botsettings.threatradiusmin * level.botsettings.threatradiusmin;
	level.botsettings.threatradiusmaxsq = level.botsettings.threatradiusmax * level.botsettings.threatradiusmax;
	lethaldistancemin = (isdefined(level.botsettings.lethaldistancemin) ? level.botsettings.lethaldistancemin : 0);
	level.botsettings.lethaldistanceminsq = lethaldistancemin * lethaldistancemin;
	lethaldistancemax = (isdefined(level.botsettings.lethaldistancemax) ? level.botsettings.lethaldistancemax : 1024);
	level.botsettings.lethaldistancemaxsq = lethaldistancemax * lethaldistancemax;
	tacticaldistancemin = (isdefined(level.botsettings.tacticaldistancemin) ? level.botsettings.tacticaldistancemin : 0);
	level.botsettings.tacticaldistanceminsq = tacticaldistancemin * tacticaldistancemin;
	tacticaldistancemax = (isdefined(level.botsettings.tacticaldistancemax) ? level.botsettings.tacticaldistancemax : 1024);
	level.botsettings.tacticaldistancemaxsq = tacticaldistancemax * tacticaldistancemax;
	level.botsettings.swimverticalspeed = getdvarfloat("player_swimVerticalSpeedMax");
	level.botsettings.swimtime = getdvarfloat("player_swimTime", 5) * 1000;
}

/*
	Name: get_bot_default_settings
	Namespace: bot
	Checksum: 0xF73A4A26
	Offset: 0x1850
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function get_bot_default_settings()
{
	return struct::get_script_bundle("botsettings", "bot_default");
}

/*
	Name: sprint_to_goal
	Namespace: bot
	Checksum: 0x11C741FD
	Offset: 0x1880
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function sprint_to_goal()
{
	self.bot.sprinttogoal = 1;
}

/*
	Name: end_sprint_to_goal
	Namespace: bot
	Checksum: 0x8838991
	Offset: 0x18A0
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function end_sprint_to_goal()
{
	self.bot.sprinttogoal = 0;
}

/*
	Name: sprint_think
	Namespace: bot
	Checksum: 0xFDF326D5
	Offset: 0x18C0
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function sprint_think()
{
	if(isdefined(self.bot.sprinttogoal) && self.bot.sprinttogoal)
	{
		if(self botgoalreached())
		{
			self end_sprint_to_goal();
			return;
		}
		self press_sprint_button();
		return;
	}
}

/*
	Name: goal_in_trigger
	Namespace: bot
	Checksum: 0x16D86964
	Offset: 0x1938
	Size: 0x66
	Parameters: 1
	Flags: None
*/
function goal_in_trigger(trigger)
{
	radius = self get_trigger_radius(trigger);
	return distancesquared(trigger.origin, self botgetgoalposition()) <= (radius * radius);
}

/*
	Name: point_in_goal
	Namespace: bot
	Checksum: 0x8F819DD0
	Offset: 0x19A8
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function point_in_goal(point)
{
	deltasq = distance2dsquared(self botgetgoalposition(), point);
	goalradius = self botgetgoalradius();
	return deltasq <= (goalradius * goalradius);
}

/*
	Name: path_to_trigger
	Namespace: bot
	Checksum: 0xEA05BB9
	Offset: 0x1A20
	Size: 0x14C
	Parameters: 2
	Flags: Linked
*/
function path_to_trigger(trigger, radius)
{
	if(trigger.classname == "trigger_use" || trigger.classname == "trigger_use_touch")
	{
		if(!isdefined(radius))
		{
			radius = get_trigger_radius(trigger);
		}
		randomangle = (0, randomint(360), 0);
		randomvec = anglestoforward(randomangle);
		point = trigger.origin + (randomvec * radius);
		self botsetgoal(point);
	}
	if(!isdefined(radius))
	{
		radius = 0;
	}
	self botsetgoal(trigger.origin, int(radius));
}

/*
	Name: path_to_point_in_trigger
	Namespace: bot
	Checksum: 0x21D2C2AA
	Offset: 0x1B78
	Size: 0x33C
	Parameters: 1
	Flags: Linked
*/
function path_to_point_in_trigger(trigger)
{
	mins = trigger getmins();
	maxs = trigger getmaxs();
	radius = min(maxs[0], maxs[1]);
	height = maxs[2] - mins[2];
	minorigin = trigger.origin + (0, 0, mins[2]);
	queryheight = height / 4;
	queryorigin = minorigin + (0, 0, queryheight);
	/#
		if(getdvarint("", 0))
		{
			draws = 10;
			circle(queryorigin, radius, (0, 1, 0), 0, 1, 20 * draws);
			circle(queryorigin + (0, 0, queryheight), radius, (0, 1, 0), 0, 1, 20 * draws);
			circle(queryorigin - (0, 0, queryheight), radius, (0, 1, 0), 0, 1, 20 * draws);
		}
	#/
	queryresult = positionquery_source_navigation(queryorigin, 0, radius, queryheight, 17, self);
	best_point = undefined;
	foreach(point in queryresult.data)
	{
		point.score = randomfloatrange(0, 100);
		if(!isdefined(best_point) || point.score > best_point.score)
		{
			best_point = point;
		}
	}
	if(isdefined(best_point))
	{
		self botsetgoal(best_point.origin, 24);
		return;
	}
	self path_to_trigger(trigger, radius);
}

/*
	Name: get_trigger_radius
	Namespace: bot
	Checksum: 0x7B6C1CE3
	Offset: 0x1EC0
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function get_trigger_radius(trigger)
{
	maxs = trigger getmaxs();
	if(trigger.classname == "trigger_radius")
	{
		return maxs[0];
	}
	return min(maxs[0], maxs[1]);
}

/*
	Name: get_trigger_height
	Namespace: bot
	Checksum: 0xE5DFA0B
	Offset: 0x1F48
	Size: 0x68
	Parameters: 1
	Flags: None
*/
function get_trigger_height(trigger)
{
	maxs = trigger getmaxs();
	if(trigger.classname == "trigger_radius")
	{
		return maxs[2];
	}
	return maxs[2] * 2;
}

/*
	Name: check_stuck
	Namespace: bot
	Checksum: 0x54016300
	Offset: 0x1FB8
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function check_stuck()
{
	/#
		if(!getdvarint(""))
		{
			return;
		}
	#/
	if(self botundermanualcontrol() || self botgoalreached() || self util::isstunned() || self ismeleeing() || self meleebuttonpressed() || (self bot_combat::has_threat() && self.bot.threat.lastdistancesq < 16384))
	{
		return;
	}
	velocity = self getvelocity();
	if(velocity[0] == 0 && velocity[1] == 0 && (velocity[2] == 0 || self isplayerswimming()))
	{
		if(!isdefined(self.bot.stuckcycles))
		{
			self.bot.stuckcycles = 0;
		}
		self.bot.stuckcycles++;
		if(self.bot.stuckcycles >= 3)
		{
			/#
				if(getdvarint("", 0))
				{
					sphere(self.origin, 16, (1, 0, 0), 0.25, 0, 16, 1200);
					iprintln((("" + self.name) + "") + self.origin);
				}
			#/
			self thread stuck_resolution();
		}
	}
	else
	{
		self.bot.stuckcycles = 0;
	}
	if(!self bot_combat::threat_visible())
	{
		self check_stuck_position();
	}
}

/*
	Name: check_stuck_position
	Namespace: bot
	Checksum: 0x341D4ADC
	Offset: 0x2248
	Size: 0x2AC
	Parameters: 0
	Flags: Linked
*/
function check_stuck_position()
{
	if(gettime() < self.bot.checkpositiontime)
	{
		return;
	}
	self.bot.checkpositiontime = gettime() + 500;
	self.bot.positionhistory[self.bot.positionhistoryindex] = self.origin;
	self.bot.positionhistoryindex = (self.bot.positionhistoryindex + 1) % 5;
	if(self.bot.positionhistory.size < 5)
	{
		return;
	}
	maxdistsq = undefined;
	for(i = 0; i < self.bot.positionhistory.size; i++)
	{
		/#
			if(getdvarint("", 0))
			{
				line(self.bot.positionhistory[i], self.bot.positionhistory[i] + vectorscale((0, 0, 1), 72), (0, 1, 0), 1, 0, 10);
			}
		#/
		for(j = i + 1; j < self.bot.positionhistory.size; j++)
		{
			distsq = distancesquared(self.bot.positionhistory[i], self.bot.positionhistory[j]);
			if(distsq > 16384)
			{
				return;
			}
		}
	}
	/#
		if(getdvarint("", 0))
		{
			sphere(self.origin, 128, (1, 0, 0), 0.25, 0, 16, 1200);
			iprintln((("" + self.name) + "") + self.origin);
		}
	#/
	self thread stuck_resolution();
}

/*
	Name: stuck_resolution
	Namespace: bot
	Checksum: 0xEBA93359
	Offset: 0x2500
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function stuck_resolution()
{
	self endon(#"death");
	level endon(#"game_ended");
	self clear_stuck();
	self bottakemanualcontrol();
	escapeangle = (self getangles()[1] + 180) + (randomintrange(-60, 60));
	escapedir = anglestoforward((0, escapeangle, 0));
	self botsetmoveangle(escapedir);
	self botsetmovemagnitude(1);
	wait(1.5);
	self botreleasemanualcontrol();
}

/*
	Name: clear_stuck
	Namespace: bot
	Checksum: 0xDC719305
	Offset: 0x2610
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function clear_stuck()
{
	self.bot.stuckcycles = 0;
	self.bot.positionhistory = [];
	self.bot.positionhistoryindex = 0;
	self.bot.checkpositiontime = 0;
}

/*
	Name: camp
	Namespace: bot
	Checksum: 0xC993C7F5
	Offset: 0x2670
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function camp()
{
	self botsetgoal(self.origin);
	self press_crouch_button();
}

/*
	Name: wait_bot_path_failed_loop
	Namespace: bot
	Checksum: 0x7DC91E22
	Offset: 0x26B8
	Size: 0x190
	Parameters: 0
	Flags: Linked
*/
function wait_bot_path_failed_loop()
{
	self endon(#"death");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"bot_path_failed", reason);
		/#
			if(getdvarint("", 0))
			{
				goalposition = self botgetgoalposition();
				box(self.origin, vectorscale((-1, -1, 0), 15), (15, 15, 72), 0, (0, 1, 0), 0.25, 0, 1200);
				box(goalposition, vectorscale((-1, -1, 0), 15), (15, 15, 72), 0, (1, 0, 0), 0.25, 0, 1200);
				line(self.origin, goalposition, (1, 1, 1), 1, 0, 1200);
				iprintln((((("" + self.name) + "") + self.origin) + "") + goalposition);
			}
		#/
		self thread stuck_resolution();
	}
}

/*
	Name: wait_bot_goal_reached_loop
	Namespace: bot
	Checksum: 0x1D52E868
	Offset: 0x2850
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function wait_bot_goal_reached_loop()
{
	self endon(#"death");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"bot_goal_reached", reason);
		self clear_stuck();
	}
}

/*
	Name: stow_gun_gadget
	Namespace: bot
	Checksum: 0xC9B3CC76
	Offset: 0x28B0
	Size: 0xA4
	Parameters: 0
	Flags: None
*/
function stow_gun_gadget()
{
	currentweapon = self getcurrentweapon();
	if(self getweaponammoclip(currentweapon) || !currentweapon.isheroweapon)
	{
		return;
	}
	if(isdefined(self.lastdroppableweapon) && self hasweapon(self.lastdroppableweapon))
	{
		self switchtoweapon(self.lastdroppableweapon);
	}
}

/*
	Name: get_ready_gadget
	Namespace: bot
	Checksum: 0x8B3C430E
	Offset: 0x2960
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function get_ready_gadget()
{
	weapons = self getweaponslist();
	foreach(weapon in weapons)
	{
		slot = self gadgetgetslot(weapon);
		if(slot < 0 || !self gadgetisready(slot) || self gadgetisactive(slot))
		{
			continue;
		}
		return weapon;
	}
	return level.weaponnone;
}

/*
	Name: get_ready_gun_gadget
	Namespace: bot
	Checksum: 0xB0875F01
	Offset: 0x2A80
	Size: 0x12E
	Parameters: 0
	Flags: None
*/
function get_ready_gun_gadget()
{
	weapons = self getweaponslist();
	foreach(weapon in weapons)
	{
		if(!is_gun_gadget(weapon))
		{
			continue;
		}
		slot = self gadgetgetslot(weapon);
		if(slot < 0 || !self gadgetisready(slot) || self gadgetisactive(slot))
		{
			continue;
		}
		return weapon;
	}
	return level.weaponnone;
}

/*
	Name: is_gun_gadget
	Namespace: bot
	Checksum: 0x3D28D0E7
	Offset: 0x2BB8
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function is_gun_gadget(weapon)
{
	if(!isdefined(weapon) || weapon == level.weaponnone || !weapon.isheroweapon)
	{
		return 0;
	}
	return weapon.isbulletweapon || weapon.isprojectileweapon || weapon.islauncher || weapon.isgasweapon;
}

/*
	Name: activate_hero_gadget
	Namespace: bot
	Checksum: 0x64966E8B
	Offset: 0x2C40
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function activate_hero_gadget(weapon)
{
	if(!isdefined(weapon) || weapon == level.weaponnone || !weapon.isgadget)
	{
		return;
	}
	if(is_gun_gadget(weapon))
	{
		self switchtoweapon(weapon);
	}
	else
	{
		if(weapon.isheroweapon)
		{
			self tap_offhand_special_button();
		}
		else
		{
			self botpressbuttonforgadget(weapon);
		}
	}
}

/*
	Name: coop_pre_combat
	Namespace: bot
	Checksum: 0x7908E56C
	Offset: 0x2D00
	Size: 0x140
	Parameters: 0
	Flags: Linked
*/
function coop_pre_combat()
{
	self bot_combat::bot_pre_combat();
	if(self bot_combat::has_threat())
	{
		return;
	}
	if(self isreloading() || self isswitchingweapons() || self isthrowinggrenade() || self fragbuttonpressed() || self secondaryoffhandbuttonpressed() || self ismeleeing() || self isremotecontrolling() || self isinvehicle() || self isweaponviewonlylinked())
	{
		return;
	}
	if(self bot_combat::switch_weapon())
	{
		return;
	}
	if(self bot_combat::reload_weapon())
	{
		return;
	}
}

/*
	Name: coop_post_combat
	Namespace: bot
	Checksum: 0x8D061F74
	Offset: 0x2E48
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function coop_post_combat()
{
	if(self revive_players())
	{
		if(self bot_combat::has_threat())
		{
			self bot_combat::clear_threat();
			self botsetgoal(self.origin);
		}
		return;
	}
	self bot_combat::bot_post_combat();
}

/*
	Name: follow_coop_players
	Namespace: bot
	Checksum: 0x2BE90678
	Offset: 0x2ED8
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function follow_coop_players()
{
	host = get_host_player();
	if(!isalive(host))
	{
		players = arraysort(level.players, self.origin);
		foreach(player in players)
		{
			if(!player util::is_bot() && player.team == self.team && isalive(player))
			{
				break;
			}
		}
	}
	else
	{
		player = host;
	}
	if(isdefined(player))
	{
		fwd = anglestoforward(player.angles);
		botdir = self.origin - player.origin;
		if(vectordot(botdir, fwd) < 0)
		{
			self thread lead_player(player, 150);
		}
	}
}

/*
	Name: lead_player
	Namespace: bot
	Checksum: 0x83E1AC9F
	Offset: 0x30A0
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function lead_player(player, followmin)
{
	radiusmin = followmin - 32;
	radiusmax = followmin;
	dotmin = 0.85;
	dotmax = 0.92;
	queryresult = positionquery_source_navigation(player.origin, radiusmin, radiusmax, 150, 32, self);
	fwd = anglestoforward(player.angles);
	point = player.origin + (fwd * 72);
	self botsetgoal(point, 42);
	self sprint_to_goal();
}

/*
	Name: follow_entity
	Namespace: bot
	Checksum: 0xCD932C6
	Offset: 0x31D8
	Size: 0xD4
	Parameters: 3
	Flags: None
*/
function follow_entity(entity, radiusmin = 24, radiusmax = radiusmin + 1)
{
	if(!point_in_goal(entity.origin))
	{
		radius = randomintrange(radiusmin, radiusmax);
		self botsetgoal(entity.origin, radius);
		self sprint_to_goal();
	}
}

/*
	Name: navmesh_wander
	Namespace: bot
	Checksum: 0xA7EE6018
	Offset: 0x32B8
	Size: 0x544
	Parameters: 5
	Flags: Linked
*/
function navmesh_wander(fwd, radiusmin = (isdefined(level.botsettings.wandermin) ? level.botsettings.wandermin : 0), radiusmax, spacing, fwddot)
{
	if(!isdefined(radiusmax))
	{
		radiusmax = (isdefined(level.botsettings.wandermax) ? level.botsettings.wandermax : 0);
	}
	if(!isdefined(spacing))
	{
		spacing = (isdefined(level.botsettings.wanderspacing) ? level.botsettings.wanderspacing : 0);
	}
	if(!isdefined(fwddot))
	{
		fwddot = (isdefined(level.botsettings.wanderfwddot) ? level.botsettings.wanderfwddot : 0);
	}
	if(!isdefined(fwd))
	{
		fwd = anglestoforward(self.angles);
	}
	fwd = vectornormalize((fwd[0], fwd[1], 0));
	/#
	#/
	queryresult = positionquery_source_navigation(self.origin, radiusmin, radiusmax, 150, spacing, self);
	best_point = undefined;
	origin = (self.origin[0], self.origin[1], 0);
	foreach(point in queryresult.data)
	{
		movepoint = (point.origin[0], point.origin[1], 0);
		movedir = vectornormalize(movepoint - origin);
		dot = vectordot(movedir, fwd);
		point.score = mapfloat(radiusmin, radiusmax, 0, 50, point.disttoorigin2d);
		if(dot > fwddot)
		{
			point.score = point.score + randomfloatrange(30, 50);
		}
		else
		{
			if(dot > 0)
			{
				point.score = point.score + randomfloatrange(10, 35);
			}
			else
			{
				point.score = point.score + randomfloatrange(0, 15);
			}
		}
		/#
		#/
		if(!isdefined(best_point) || point.score > best_point.score)
		{
			best_point = point;
		}
	}
	if(isdefined(best_point))
	{
		/#
		#/
		self botsetgoal(best_point.origin, radiusmin);
	}
	else
	{
		/#
			circle(self.origin, radiusmin, (1, 0, 0), 0, 1, 1200);
			circle(self.origin, radiusmax, (1, 0, 0), 0, 1, 1200);
			sphere(self.origin, 16, (0, 1, 0), 0.25, 0, 16, 1200);
			iprintln((("" + self.name) + "") + self.origin);
		#/
		if(getdvarint("", 0))
		{
		}
		self thread stuck_resolution();
	}
}

/*
	Name: approach_goal_trigger
	Namespace: bot
	Checksum: 0x520B72D7
	Offset: 0x3808
	Size: 0xF4
	Parameters: 3
	Flags: None
*/
function approach_goal_trigger(trigger, radiusmax = 1500, spacing = 128)
{
	distsq = distancesquared(self.origin, trigger.origin);
	if(distsq < (radiusmax * radiusmax))
	{
		self path_to_point_in_trigger(trigger);
		return;
	}
	radiusmin = self get_trigger_radius(trigger);
	self approach_point(trigger.origin, radiusmin, radiusmax, spacing);
}

/*
	Name: approach_point
	Namespace: bot
	Checksum: 0x7A8E2522
	Offset: 0x3908
	Size: 0x37C
	Parameters: 4
	Flags: Linked
*/
function approach_point(point, radiusmin = 0, radiusmax = 1500, spacing = 128)
{
	distsq = distancesquared(self.origin, point);
	if(distsq < (radiusmax * radiusmax))
	{
		self botsetgoal(point, 24);
		return;
	}
	queryresult = positionquery_source_navigation(point, radiusmin, radiusmax, 150, spacing, self);
	fwd = anglestoforward(self.angles);
	fwd = (fwd[0], fwd[1], 0);
	origin = (self.origin[0], self.origin[1], 0);
	best_point = undefined;
	foreach(point in queryresult.data)
	{
		movepoint = (point.origin[0], point.origin[1], 0);
		movedir = vectornormalize(movepoint - origin);
		dot = vectordot(movedir, fwd);
		point.score = randomfloatrange(0, 50);
		if(dot < 0.5)
		{
			point.score = point.score + randomfloatrange(30, 50);
		}
		else
		{
			point.score = point.score + randomfloatrange(0, 15);
		}
		if(!isdefined(best_point) || point.score > best_point.score)
		{
			best_point = point;
		}
	}
	if(isdefined(best_point))
	{
		self botsetgoal(best_point.origin, 24);
	}
}

/*
	Name: revive_players
	Namespace: bot
	Checksum: 0xEAA81190
	Offset: 0x3C90
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function revive_players()
{
	players = self get_team_players_in_laststand();
	if(players.size > 0)
	{
		revive_player(players[0]);
		return true;
	}
	return false;
}

/*
	Name: get_team_players_in_laststand
	Namespace: bot
	Checksum: 0x28B517DC
	Offset: 0x3CF8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function get_team_players_in_laststand()
{
	players = [];
	foreach(player in level.players)
	{
		if(player != self && player laststand::player_is_in_laststand() && player.team == self.team)
		{
			players[players.size] = player;
		}
	}
	players = arraysort(players, self.origin);
	return players;
}

/*
	Name: revive_player
	Namespace: bot
	Checksum: 0xD42B2BA8
	Offset: 0x3E00
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function revive_player(player)
{
	if(!point_in_goal(player.origin))
	{
		self botsetgoal(player.origin, 64);
		self sprint_to_goal();
		return;
	}
	if(self botgoalreached())
	{
		self botsetlookanglesfrompoint(player getcentroid());
		self tap_use_button();
	}
}

/*
	Name: watch_bot_corner
	Namespace: bot
	Checksum: 0x63B22886
	Offset: 0x3ED0
	Size: 0x170
	Parameters: 2
	Flags: None
*/
function watch_bot_corner(startcornerdist, cornerdist)
{
	self endon(#"death");
	self endon(#"bot_combat_target");
	level endon(#"game_ended");
	if(!isdefined(startcornerdist))
	{
		startcornerdist = 64;
	}
	if(!isdefined(cornerdist))
	{
		cornerdist = 128;
	}
	startcornerdistsq = cornerdist * cornerdist;
	cornerdistsq = cornerdist * cornerdist;
	while(true)
	{
		self waittill(#"bot_corner", centerpoint, enterpoint, leavepoint, angle, nextenterpoint);
		if(self bot_combat::has_threat())
		{
			continue;
		}
		if(distance2dsquared(self.origin, enterpoint) < startcornerdistsq || distance2dsquared(leavepoint, nextenterpoint) < cornerdistsq)
		{
			continue;
		}
		self thread wait_corner_radius(startcornerdistsq, centerpoint, enterpoint, leavepoint, angle, nextenterpoint);
	}
}

/*
	Name: wait_corner_radius
	Namespace: bot
	Checksum: 0xFE82EDD
	Offset: 0x4048
	Size: 0x10C
	Parameters: 6
	Flags: Linked
*/
function wait_corner_radius(startcornerdistsq, centerpoint, enterpoint, leavepoint, angle, nextenterpoint)
{
	self endon(#"death");
	self endon(#"bot_corner");
	self endon(#"bot_goal_reached");
	self endon(#"bot_combat_target");
	level endon(#"game_ended");
	while(distance2dsquared(self.origin, enterpoint) > startcornerdistsq)
	{
		if(self bot_combat::has_threat())
		{
			return;
		}
		wait(0.05);
	}
	self botlookatpoint((nextenterpoint[0], nextenterpoint[1], nextenterpoint[1] + 60));
	self thread finish_corner();
}

/*
	Name: finish_corner
	Namespace: bot
	Checksum: 0x3E052610
	Offset: 0x4160
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function finish_corner()
{
	self endon(#"death");
	self endon(#"combat_target");
	level endon(#"game_ended");
	self util::waittill_any("bot_corner", "bot_goal_reached");
	self botlookforward();
}

/*
	Name: get_host_player
	Namespace: bot
	Checksum: 0x33006195
	Offset: 0x41D0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function get_host_player()
{
	players = getplayers();
	foreach(player in players)
	{
		if(player ishost())
		{
			return player;
		}
	}
	return undefined;
}

/*
	Name: fwd_dot
	Namespace: bot
	Checksum: 0x88446226
	Offset: 0x4288
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function fwd_dot(point)
{
	angles = self getplayerangles();
	fwd = anglestoforward(angles);
	delta = point - self geteye();
	delta = vectornormalize(delta);
	dot = vectordot(fwd, delta);
	return dot;
}

/*
	Name: has_launcher
	Namespace: bot
	Checksum: 0x6807058C
	Offset: 0x4358
	Size: 0xB0
	Parameters: 0
	Flags: None
*/
function has_launcher()
{
	weapons = self getweaponslist();
	foreach(weapon in weapons)
	{
		if(weapon.isrocketlauncher)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: kill_bot
	Namespace: bot
	Checksum: 0x5A9A61F7
	Offset: 0x4410
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function kill_bot()
{
	self dodamage(self.health, self.origin);
}

/*
	Name: kill_bots
	Namespace: bot
	Checksum: 0x5405430A
	Offset: 0x4448
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function kill_bots()
{
	/#
		foreach(player in level.players)
		{
			if(player util::is_bot())
			{
				player kill_bot();
			}
		}
	#/
}

/*
	Name: add_bot_at_eye_trace
	Namespace: bot
	Checksum: 0xF51CEA5B
	Offset: 0x4500
	Size: 0x158
	Parameters: 1
	Flags: Linked
*/
function add_bot_at_eye_trace(team)
{
	/#
		host = util::gethostplayer();
		trace = host eye_trace();
		direction_vec = host.origin - trace[""];
		direction = vectortoangles(direction_vec);
		yaw = direction[1];
		bot = add_bot(team);
		if(isdefined(bot))
		{
			bot waittill(#"spawned_player");
			bot setorigin(trace[""]);
			bot setplayerangles((bot.angles[0], yaw, bot.angles[2]));
		}
		return bot;
	#/
}

/*
	Name: eye_trace
	Namespace: bot
	Checksum: 0xA97D49DF
	Offset: 0x4668
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function eye_trace()
{
	/#
		direction = self getplayerangles();
		direction_vec = anglestoforward(direction);
		eye = self geteye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		return bullettrace(eye, eye + direction_vec, 0, undefined);
	#/
}

/*
	Name: devgui_debug_route
	Namespace: bot
	Checksum: 0xBA222ABC
	Offset: 0x4748
	Size: 0x152
	Parameters: 0
	Flags: Linked
*/
function devgui_debug_route()
{
	/#
		iprintln("");
		points = self get_nav_points();
		if(!isdefined(points) || points.size == 0)
		{
			iprintln("");
			return;
		}
		iprintln("");
		players = getplayers();
		foreach(player in players)
		{
			if(!player util::is_bot())
			{
				continue;
			}
			player thread debug_patrol(points);
		}
	#/
}

/*
	Name: get_nav_points
	Namespace: bot
	Checksum: 0xA866648F
	Offset: 0x48A8
	Size: 0x22A
	Parameters: 0
	Flags: Linked
*/
function get_nav_points()
{
	/#
		iprintln("");
		iprintln("");
		iprintln("");
		points = [];
		while(true)
		{
			wait(0.05);
			point = self eye_trace()[""];
			if(isdefined(point))
			{
				point = getclosestpointonnavmesh(point, 128);
				if(isdefined(point))
				{
					sphere(point, 16, (0, 0, 1), 0.25, 0, 16, 1);
				}
			}
			if(self buttonpressed(""))
			{
				if(isdefined(point) && (points.size == 0 || (distance2d(point, points[points.size - 1])) > 16))
				{
					points[points.size] = point;
				}
			}
			else
			{
				if(self buttonpressed(""))
				{
					return points;
				}
				if(self buttonpressed(""))
				{
					return undefined;
				}
			}
			for(i = 0; i < points.size; i++)
			{
				sphere(points[i], 16, (0, 1, 0), 0.25, 0, 16, 1);
			}
		}
	#/
}

/*
	Name: debug_patrol
	Namespace: bot
	Checksum: 0xBB172EBE
	Offset: 0x4AE0
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function debug_patrol(points)
{
	/#
		self notify(#"debug_patrol");
		self endon(#"death");
		self endon(#"debug_patrol");
		i = 0;
		while(true)
		{
			self botsetgoal(points[i], 24);
			self sprint_to_goal();
			self waittill(#"bot_goal_reached");
			i = (i + 1) % points.size;
		}
	#/
}

/*
	Name: bot_devgui_think
	Namespace: bot
	Checksum: 0x11E3E8FD
	Offset: 0x4BA0
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function bot_devgui_think()
{
	/#
		while(true)
		{
			wait(0.25);
			cmd = getdvarstring("", "");
			if(!isdefined(level.botdevguicmd) || ![[level.botdevguicmd]](cmd))
			{
				host = util::gethostplayer();
				switch(cmd)
				{
					case "":
					{
						remove_bots();
						break;
					}
					case "":
					{
						kill_bots();
						break;
					}
					case "":
					{
						host devgui_debug_route();
						break;
					}
					default:
					{
						break;
					}
				}
			}
			setdvar("", "");
		}
	#/
}

/*
	Name: coop_bot_devgui_cmd
	Namespace: bot
	Checksum: 0xCBAFBDDD
	Offset: 0x4CD0
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function coop_bot_devgui_cmd(cmd)
{
	/#
		host = get_host_player();
		switch(cmd)
		{
			case "":
			{
				add_bot(host.team);
				return true;
			}
			case "":
			{
				add_bots(3, host.team);
				return true;
			}
			case "":
			{
				add_bot_at_eye_trace();
				return true;
			}
			case "":
			{
				remove_bots(1);
				return true;
				break;
			}
		}
		return false;
	#/
}

/*
	Name: debug_star
	Namespace: bot
	Checksum: 0x6DBFB4D4
	Offset: 0x4DD0
	Size: 0x8C
	Parameters: 3
	Flags: None
*/
function debug_star(origin, seconds, color)
{
	/#
		if(!isdefined(seconds))
		{
			seconds = 1;
		}
		if(!isdefined(color))
		{
			color = (1, 0, 0);
		}
		frames = int(20 * seconds);
		debugstar(origin, frames, color);
	#/
}

