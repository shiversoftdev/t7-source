// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_challenges;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_supplydrop;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_puppeteer_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\weapons\_heatseekingmissile;

#namespace combat_robot;

/*
	Name: init
	Namespace: combat_robot
	Checksum: 0xCCE5922A
	Offset: 0x9E8
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function init()
{
	killstreaks::register("combat_robot", "combat_robot_marker", "killstreak_" + "combat_robot", "combat_robot" + "_used", &activatecombatrobot, undefined, 1);
	killstreaks::register_alt_weapon("combat_robot", "lmg_light_robot");
	killstreaks::register_strings("combat_robot", &"KILLSTREAK_COMBAT_ROBOT_EARNED", &"KILLSTREAK_COMBAT_ROBOT_NOT_AVAILABLE", &"KILLSTREAK_COMBAT_ROBOT_INBOUND", undefined, &"KILLSTREAK_COMBAT_ROBOT_HACKED");
	killstreaks::register_dialog("combat_robot", "mpl_killstreak_combat_robot", "combatRobotDialogBundle", "combatRobotPilotDialogBundle", "friendlyCombatRobot", "enemyCombatRobot", "enemyCombatRobotMultiple", "friendlyCombatRobotHacked", "enemyCombatRobotHacked", "requestCombatRobot", "threatCombatRobot");
	level.killstreaks["inventory_combat_robot"].threatonkill = 1;
	level.killstreaks["combat_robot"].threatonkill = 1;
	level thread _cleanuprobotcorpses();
}

/*
	Name: _calculateprojectedguardposition
	Namespace: combat_robot
	Checksum: 0xED9CCE1F
	Offset: 0xB68
	Size: 0x2A
	Parameters: 1
	Flags: Linked, Private
*/
function private _calculateprojectedguardposition(player)
{
	return getclosestpointonnavmesh(player.origin, 48);
}

/*
	Name: _calculaterobotspawnposition
	Namespace: combat_robot
	Checksum: 0xB0D63A62
	Offset: 0xBA0
	Size: 0x6A
	Parameters: 1
	Flags: Private
*/
function private _calculaterobotspawnposition(player)
{
	desiredspawnposition = (anglestoforward(player.angles) * 72) + player.origin;
	return getclosestpointonnavmesh(desiredspawnposition, 48);
}

/*
	Name: _cleanuprobotcorpses
	Namespace: combat_robot
	Checksum: 0x1F8AEA73
	Offset: 0xC18
	Size: 0x17C
	Parameters: 0
	Flags: Linked, Private
*/
function private _cleanuprobotcorpses()
{
	corpsedeletetime = 15000;
	while(true)
	{
		deletecorpses = [];
		foreach(corpse in getcorpsearray())
		{
			if(isdefined(corpse.birthtime) && isdefined(corpse.archetype) && corpse.archetype == "robot" && (corpse.birthtime + corpsedeletetime) < gettime())
			{
				deletecorpses[deletecorpses.size] = corpse;
			}
		}
		for(index = 0; index < deletecorpses.size; index++)
		{
			deletecorpses[index] delete();
		}
		wait((corpsedeletetime / 1000) / 2);
	}
}

/*
	Name: configureteampost
	Namespace: combat_robot
	Checksum: 0x55E894B8
	Offset: 0xDA0
	Size: 0x21C
	Parameters: 2
	Flags: Linked
*/
function configureteampost(player, ishacked)
{
	robot = self;
	robot.propername = "";
	robot.ignoretriggerdamage = 1;
	robot.empshutdowntime = 750;
	robot.minwalkdistance = 60;
	robot.supersprintdistance = 180;
	robot.robotrusherminradius = 64;
	robot.robotrushermaxradius = 120;
	robot.allowpushactors = 0;
	robot.chargemeleedistance = 0;
	robot.fovcosine = 0;
	robot.fovcosinebusy = 0;
	robot.maxsightdistsqrd = 2000 * 2000;
	blackboard::setblackboardattribute(robot, "_robot_mode", "combat");
	robot.gib_state = 0 | (8 & (512 - 1));
	robot clientfield::set("gib_state", robot.gib_state);
	_configurerobotteam(robot, player, ishacked);
	robot ai::set_behavior_attribute("can_become_crawler", 0);
	robot ai::set_behavior_attribute("can_be_meleed", 0);
	robot ai::set_behavior_attribute("can_initiateaivsaimelee", 0);
	robot ai::set_behavior_attribute("supports_super_sprint", 1);
}

/*
	Name: _configurerobotteam
	Namespace: combat_robot
	Checksum: 0xADB4D1FF
	Offset: 0xFC8
	Size: 0xFC
	Parameters: 3
	Flags: Linked, Private
*/
function private _configurerobotteam(robot, player, ishacked)
{
	if(ishacked)
	{
		lightsstate = 3;
	}
	else
	{
		lightsstate = 0;
	}
	robot ai::set_behavior_attribute("robot_lights", lightsstate);
	robot thread watchcombatrobotownerdisconnect(player);
	if(!isdefined(robot.objective))
	{
		robot.objective = getequipmentheadobjective(getweapon("combat_robot_marker"));
	}
	robot thread _watchmodeswap(robot, player);
	robot thread _underwater(robot);
}

/*
	Name: _createguardmarker
	Namespace: combat_robot
	Checksum: 0x85D73383
	Offset: 0x10D0
	Size: 0xA8
	Parameters: 2
	Flags: Linked, Private
*/
function private _createguardmarker(robot, position)
{
	owner = robot.owner;
	guardmarker = spawn("script_model", (0, 0, 0));
	guardmarker.origin = position;
	guardmarker entityheadicons::setentityheadicon(owner.pers["team"], owner, undefined, &"airdrop_combatrobot");
	return guardmarker;
}

/*
	Name: _destroyguardmarker
	Namespace: combat_robot
	Checksum: 0x7F6199E9
	Offset: 0x1180
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private _destroyguardmarker(robot)
{
	if(isdefined(robot.guardmarker))
	{
		robot.guardmarker delete();
	}
}

/*
	Name: _underwater
	Namespace: combat_robot
	Checksum: 0x3E8A6D29
	Offset: 0x11C8
	Size: 0xA8
	Parameters: 1
	Flags: Linked, Private
*/
function private _underwater(robot)
{
	robot endon(#"death");
	while(true)
	{
		if((robot.origin[2] + 36) <= getwaterheight(robot.origin))
		{
			robot asmsetanimationrate(0.85);
		}
		else
		{
			robot asmsetanimationrate(1);
		}
		wait(0.1);
	}
}

/*
	Name: _escort
	Namespace: combat_robot
	Checksum: 0x5071CE34
	Offset: 0x1278
	Size: 0x20E
	Parameters: 1
	Flags: Linked, Private
*/
function private _escort(robot)
{
	robot endon(#"death");
	robot.escorting = 1;
	robot.guarding = 0;
	_destroyguardmarker(robot);
	while(robot.escorting)
	{
		attackingenemy = 0;
		if(isdefined(robot.enemy) && isalive(robot.enemy))
		{
			if((robot lastknowntime(robot.enemy) + 10000) >= gettime())
			{
				robot ai::set_behavior_attribute("move_mode", "rusher");
				attackingenemy = 1;
			}
			else
			{
				robot clearenemy();
			}
		}
		if(!attackingenemy && isdefined(robot.owner) && isalive(robot.owner))
		{
			lookaheadtime = 1;
			predicitedposition = robot.owner.origin + vectorscale(robot.owner getvelocity(), lookaheadtime);
			robot ai::set_behavior_attribute("escort_position", predicitedposition);
			robot ai::set_behavior_attribute("move_mode", "escort");
		}
		wait(1);
	}
}

/*
	Name: _ignoreunattackableenemy
	Namespace: combat_robot
	Checksum: 0x1929A29D
	Offset: 0x1490
	Size: 0x64
	Parameters: 2
	Flags: Private
*/
function private _ignoreunattackableenemy(robot, enemy)
{
	robot endon(#"death");
	robot setignoreent(enemy, 1);
	wait(5);
	robot setignoreent(enemy, 0);
}

/*
	Name: _guardposition
	Namespace: combat_robot
	Checksum: 0x3EBD7A05
	Offset: 0x1500
	Size: 0x1B6
	Parameters: 2
	Flags: Linked, Private
*/
function private _guardposition(robot, position)
{
	robot endon(#"death");
	robot.goalradius = 1000;
	robot setgoal(position);
	robot.escorting = 0;
	robot.guarding = 1;
	_destroyguardmarker(robot);
	robot.guardmarker = _createguardmarker(robot, position);
	while(robot.guarding)
	{
		attackingenemy = 0;
		if(isdefined(robot.enemy) && isalive(robot.enemy))
		{
			if((robot lastknowntime(robot.enemy) + 10000) >= gettime())
			{
				robot ai::set_behavior_attribute("move_mode", "rusher");
				attackingenemy = 1;
			}
			else
			{
				robot clearenemy();
			}
		}
		if(!attackingenemy)
		{
			robot ai::set_behavior_attribute("move_mode", "guard");
		}
		wait(1);
	}
}

/*
	Name: _watchmodeswap
	Namespace: combat_robot
	Checksum: 0x8247011
	Offset: 0x16C0
	Size: 0x3EE
	Parameters: 2
	Flags: Linked
*/
function _watchmodeswap(robot, player)
{
	robot endon(#"death");
	nextswitchtime = gettime();
	while(true)
	{
		wait(0.05);
		if(!isdefined(robot.usetrigger))
		{
			continue;
		}
		robot.usetrigger waittill(#"trigger");
		if(nextswitchtime <= gettime() && isalive(player))
		{
			if(isdefined(robot.guarding) && robot.guarding)
			{
				robot.guarding = 0;
				robot.escorting = 1;
				player playsoundtoplayer("uin_mp_combat_bot_escort", player);
				robot thread _escort(robot);
				if(isdefined(robot.usetrigger))
				{
					robot.usetrigger sethintstring(&"KILLSTREAK_COMBAT_ROBOT_GUARD_HINT");
				}
				if(isdefined(robot.markerfxhandle))
				{
					robot.markerfxhandle delete();
				}
			}
			else
			{
				navguardposition = _calculateprojectedguardposition(player);
				if(isdefined(navguardposition))
				{
					robot.guarding = 1;
					robot.escorting = 0;
					player playsoundtoplayer("uin_mp_combat_bot_guard", player);
					robot thread _guardposition(robot, navguardposition);
					if(isdefined(robot.usetrigger))
					{
						robot.usetrigger sethintstring(&"KILLSTREAK_COMBAT_ROBOT_ESCORT_HINT");
					}
					if(isdefined(robot.markerfxhandle))
					{
						robot.markerfxhandle delete();
					}
					params = level.killstreakbundle["combat_robot"];
					if(isdefined(params.kscombatrobotpatrolfx))
					{
						point = player.origin;
						if(!isdefined(point))
						{
							point = navguardposition;
						}
						robot.markerfxhandle = spawnfx(params.kscombatrobotpatrolfx, point + vectorscale((0, 0, 1), 3), (0, 0, 1), (1, 0, 0));
						robot.markerfxhandle.team = player.team;
						triggerfx(robot.markerfxhandle);
						robot.markerfxhandle setinvisibletoall();
						robot.markerfxhandle setvisibletoplayer(player);
					}
				}
				else
				{
					player iprintlnbold(&"KILLSTREAK_COMBAT_ROBOT_PATROL_FAIL");
				}
			}
			robot notify(#"bhtn_action_notify", "modeSwap");
			nextswitchtime = gettime() + 1000;
		}
	}
}

/*
	Name: activatecombatrobot
	Namespace: combat_robot
	Checksum: 0x920D3E7E
	Offset: 0x1AB8
	Size: 0x300
	Parameters: 1
	Flags: Linked
*/
function activatecombatrobot(killstreak)
{
	player = self;
	team = self.team;
	if(!self supplydrop::issupplydropgrenadeallowed(killstreak))
	{
		return 0;
	}
	killstreak_id = self killstreakrules::killstreakstart(killstreak, team, 0, 0);
	if(killstreak_id == -1)
	{
		return 0;
	}
	context = spawnstruct();
	context.prolog = &prolog;
	context.epilog = &epilog;
	context.hasflares = 1;
	context.radius = level.killstreakcorebundle.ksairdroprobotradius;
	context.dist_from_boundary = 18;
	context.max_dist_from_location = 4;
	context.perform_physics_trace = 1;
	context.drop_from_goal_distance2d = 96;
	context.islocationgood = &supplydrop::islocationgood;
	context.objective = &"airdrop_combatrobot";
	context.killstreakref = killstreak;
	context.validlocationsound = level.killstreakcorebundle.ksvalidcombatrobotlocationsound;
	context.vehiclename = "combat_robot_dropship";
	context.killstreak_id = killstreak_id;
	context.tracemask = 1 | 4;
	context.dropoffset = vectorscale((0, -1, 0), 120);
	result = self supplydrop::usesupplydropmarker(killstreak_id, context);
	if(!isdefined(result) || !result)
	{
		killstreakrules::killstreakstop(killstreak, team, killstreak_id);
		return 0;
	}
	self killstreaks::play_killstreak_start_dialog("combat_robot", self.team, killstreak_id);
	self killstreakrules::displaykillstreakstartteammessagetoall("combat_robot");
	self addweaponstat(getweapon("combat_robot_marker"), "used", 1);
	return result;
}

/*
	Name: dropkillthread
	Namespace: combat_robot
	Checksum: 0xC6096BB7
	Offset: 0x1DC0
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function dropkillthread()
{
	robot = self;
	robot endon(#"death");
	robot endon(#"combat_robot_land");
	while(true)
	{
		robot supplydrop::is_touching_crate();
		robot supplydrop::is_clone_touching_crate();
		wait(0.05);
	}
}

/*
	Name: watchhelicopterdeath
	Namespace: combat_robot
	Checksum: 0xE61DC09E
	Offset: 0x1E38
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function watchhelicopterdeath(context)
{
	helicopter = self;
	helicopter waittill(#"death");
	callback::callback(#"hash_acb66515");
	if(isdefined(context.marker))
	{
		context.marker delete();
		context.marker = undefined;
		if(isdefined(context.markerfxhandle))
		{
			context.markerfxhandle delete();
			context.markerfxhandle = undefined;
		}
		supplydrop::deldroplocation(context.killstreak_id);
	}
}

/*
	Name: prolog
	Namespace: combat_robot
	Checksum: 0xE610B521
	Offset: 0x1F28
	Size: 0x508
	Parameters: 1
	Flags: Linked
*/
function prolog(context)
{
	helicopter = self;
	player = helicopter.owner;
	spawnposition = (0, 0, 0);
	spawnangles = (0, 0, 0);
	combatrobot = spawnactor("spawner_bo3_robot_grunt_assault_mp", spawnposition, spawnangles, "", 1);
	combatrobot.missiletrackdamage = 0;
	combatrobot killstreaks::configure_team("combat_robot", context.killstreak_id, player, "small_vehicle", undefined, &configureteampost);
	combatrobot killstreak_hacking::enable_hacking("combat_robot", undefined, &hackedcallbackpost);
	combatrobot thread _escort(combatrobot);
	combatrobot thread watchcombatrobothelicopterhacked(helicopter);
	combatrobot thread watchcombatrobotshutdown();
	combatrobot thread watchcombatrobotdeath();
	combatrobot thread killstreaks::waitfortimeout("combat_robot", 90000, &oncombatrobottimeout, "combat_robot_shutdown");
	combatrobot thread sndwatchcombatrobotvoxnotifies();
	helicopter thread watchhelicopterdeath(context);
	helicopter.unloadtimeout = 6;
	killstreak_detect::killstreaktargetset(combatrobot, vectorscale((0, 0, 1), 50));
	combatrobot.maxhealth = combatrobot.health;
	tablehealth = killstreak_bundles::get_max_health("combat_robot");
	if(isdefined(tablehealth))
	{
		combatrobot.maxhealth = tablehealth;
	}
	combatrobot.health = combatrobot.maxhealth;
	combatrobot.treat_owner_damage_as_friendly_fire = 1;
	combatrobot.ignore_team_kills = 1;
	combatrobot.remotemissiledamage = combatrobot.maxhealth + 1;
	combatrobot.rocketdamage = (combatrobot.maxhealth / 2) + 1;
	combatrobot thread heatseekingmissile::missiletarget_proximitydetonateincomingmissile("death");
	combatrobot clientfield::set("enemyvehicle", 1);
	combatrobot.soundmod = "drone_land";
	aiutility::addaioverridedamagecallback(combatrobot, &combatrobotdamageoverride);
	combatrobot.vehicle = helicopter;
	combatrobot.vehicle.ignore_seat_check = 1;
	combatrobot vehicle::get_in(helicopter, "driver", 1);
	combatrobot.overridedropposition = player.markerposition;
	combatrobot thread watchcombatrobotlanding();
	combatrobot thread sndwatchexit();
	combatrobot thread sndwatchlanding();
	combatrobot thread sndwatchactivate();
	foreach(player in level.players)
	{
		combatrobot respectnottargetedbyrobotperk(player);
	}
	callback::on_spawned(&respectnottargetedbyrobotperk, combatrobot);
	context.robot = combatrobot;
}

/*
	Name: respectnottargetedbyrobotperk
	Namespace: combat_robot
	Checksum: 0x96CBA5C9
	Offset: 0x2438
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function respectnottargetedbyrobotperk(player)
{
	combatrobot = self;
	combatrobot setignoreent(player, player hasperk("specialty_nottargetedbyrobot"));
}

/*
	Name: epilog
	Namespace: combat_robot
	Checksum: 0x4CC68B08
	Offset: 0x2498
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function epilog(context)
{
	helicopter = self;
	context.robot thread dropkillthread();
	context.robot.starttime = gettime() + 750;
	thread cleanupthread(context);
	/#
		debug_delay_robot_deploy();
	#/
	helicopter waitthensetdeleteafterdestructionwaittime(0.8, (isdefined(self.unloadtimeout) ? self.unloadtimeout : 0) + 0.1);
	helicopter vehicle::unload("all", undefined, 1, 0.8);
}

/*
	Name: debug_delay_robot_deploy
	Namespace: combat_robot
	Checksum: 0x5F2834FB
	Offset: 0x2598
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function debug_delay_robot_deploy()
{
	/#
		seconds_to_wait = getdvarint("", 0);
		while(seconds_to_wait > 0)
		{
			iprintlnbold("" + seconds_to_wait);
			wait(1);
			seconds_to_wait--;
			if(seconds_to_wait == 0)
			{
				iprintlnbold("");
			}
		}
	#/
}

/*
	Name: waitthensetdeleteafterdestructionwaittime
	Namespace: combat_robot
	Checksum: 0x7437DBEB
	Offset: 0x2630
	Size: 0x30
	Parameters: 2
	Flags: Linked
*/
function waitthensetdeleteafterdestructionwaittime(set_wait_time, delete_after_destruction_wait_time)
{
	wait(set_wait_time);
	if(isdefined(self))
	{
		self.delete_after_destruction_wait_time = delete_after_destruction_wait_time;
	}
}

/*
	Name: hackedcallbackpost
	Namespace: combat_robot
	Checksum: 0x32095855
	Offset: 0x2668
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function hackedcallbackpost(hacker)
{
	robot = self;
	robot clearenemy();
	robot setupcombatrobothinttrigger(hacker);
}

/*
	Name: watchcombatrobothelicopterhacked
	Namespace: combat_robot
	Checksum: 0x1BEEAEF0
	Offset: 0x26C0
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function watchcombatrobothelicopterhacked(helicopter)
{
	robot = self;
	robot endon(#"death");
	robot endon(#"killstreak_hacked");
	robot endon(#"combat_robot_land");
	helicopter endon(#"death");
	helicopter waittill(#"killstreak_hacked", hacker);
	if(robot flagsys::get("in_vehicle") == 0)
	{
		return;
	}
	robot [[robot.killstreak_hackedcallback]](hacker);
}

/*
	Name: cleanupthread
	Namespace: combat_robot
	Checksum: 0xB840D1FB
	Offset: 0x2770
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function cleanupthread(context)
{
	robot = context.robot;
	while(isdefined(robot) && isdefined(context.marker) && robot flagsys::get("in_vehicle"))
	{
		wait(1);
	}
	if(isdefined(context.marker))
	{
		context.marker delete();
		context.marker = undefined;
		if(isdefined(context.markerfxhandle))
		{
			context.markerfxhandle delete();
			context.markerfxhandle = undefined;
		}
		supplydrop::deldroplocation(context.killstreak_id);
	}
}

/*
	Name: watchcombatrobotdeath
	Namespace: combat_robot
	Checksum: 0xD2B6976A
	Offset: 0x2890
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function watchcombatrobotdeath()
{
	combatrobot = self;
	combatrobot endon(#"combat_robot_shutdown");
	callback::remove_on_spawned(&respectnottargetedbyrobotperk, combatrobot);
	combatrobot waittill(#"death", attacker, damagefromunderneath, weapon);
	attacker = self [[level.figure_out_attacker]](attacker);
	if(isdefined(attacker) && isplayer(attacker) && (!isdefined(combatrobot.owner) || combatrobot.owner util::isenemyplayer(attacker)))
	{
		attacker challenges::destroyscorestreak(weapon, 0, 1);
		attacker challenges::destroynonairscorestreak_poststatslock(weapon);
		scoreevents::processscoreevent("destroyed_combat_robot", attacker, combatrobot.owner, weapon);
		luinotifyevent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_COMBAT_ROBOT", attacker.entnum);
	}
	combatrobot killstreaks::play_destroyed_dialog_on_owner("combat_robot", combatrobot.killstreak_id);
	combatrobot notify(#"combat_robot_shutdown");
}

/*
	Name: watchcombatrobotlanding
	Namespace: combat_robot
	Checksum: 0x95D76796
	Offset: 0x2A58
	Size: 0x120
	Parameters: 0
	Flags: Linked
*/
function watchcombatrobotlanding()
{
	robot = self;
	robot endon(#"death");
	robot endon(#"combat_robot_shutdown");
	while(robot flagsys::get("in_vehicle"))
	{
		wait(1);
	}
	robot notify(#"combat_robot_land");
	robot.ignoretriggerdamage = 0;
	while(isdefined(robot.traversestartnode))
	{
		robot waittill(#"traverse_end");
	}
	v_on_navmesh = getclosestpointonnavmesh(robot.origin, 50, 20);
	if(isdefined(v_on_navmesh))
	{
		player = robot.owner;
		robot setupcombatrobothinttrigger(player);
	}
	else
	{
		robot notify(#"combat_robot_shutdown");
	}
}

/*
	Name: setupcombatrobothinttrigger
	Namespace: combat_robot
	Checksum: 0xE322B6DF
	Offset: 0x2B80
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function setupcombatrobothinttrigger(player)
{
	robot = self;
	if(isdefined(robot.usetrigger))
	{
		robot.usetrigger delete();
	}
	robot.usetrigger = spawn("trigger_radius_use", player.origin, 32, 32);
	robot.usetrigger enablelinkto();
	robot.usetrigger linkto(player);
	robot.usetrigger sethintlowpriority(1);
	robot.usetrigger setcursorhint("HINT_NOICON");
	robot.usetrigger sethintstring(&"KILLSTREAK_COMBAT_ROBOT_GUARD_HINT");
	robot.usetrigger setteamfortrigger(player.team);
	robot.usetrigger.team = player.team;
	player clientclaimtrigger(robot.usetrigger);
	player.remotecontroltrigger = robot.usetrigger;
	robot.usetrigger.claimedby = player;
}

/*
	Name: watchcombatrobotownerdisconnect
	Namespace: combat_robot
	Checksum: 0x9E4E51E9
	Offset: 0x2D68
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function watchcombatrobotownerdisconnect(player)
{
	combatrobot = self;
	combatrobot notify(#"watchcombatrobotownerdisconnect_singleton");
	combatrobot endon(#"watchcombatrobotownerdisconnect_singleton");
	combatrobot endon(#"combat_robot_shutdown");
	player util::waittill_any("joined_team", "disconnect", "joined_spectators");
	combatrobot notify(#"combat_robot_shutdown");
}

/*
	Name: _corpsewatcher
	Namespace: combat_robot
	Checksum: 0xA055F172
	Offset: 0x2DF8
	Size: 0x54
	Parameters: 0
	Flags: Linked, Private
*/
function private _corpsewatcher()
{
	archetype = self.archetype;
	self waittill(#"actor_corpse", corpse);
	corpse clientfield::set("arch_actor_fire_fx", 3);
}

/*
	Name: _exploderobot
	Namespace: combat_robot
	Checksum: 0x376610D0
	Offset: 0x2E58
	Size: 0x1AC
	Parameters: 1
	Flags: Linked, Private
*/
function private _exploderobot(combatrobot)
{
	combatrobot clientfield::set("arch_actor_fire_fx", 1);
	clientfield::set("robot_mind_control_explosion", 1);
	combatrobot thread _corpsewatcher();
	if(randomint(100) >= 50)
	{
		gibserverutils::gibleftarm(combatrobot);
	}
	else
	{
		gibserverutils::gibrightarm(combatrobot);
	}
	gibserverutils::giblegs(combatrobot);
	gibserverutils::gibhead(combatrobot);
	velocity = combatrobot getvelocity() * 0.125;
	combatrobot startragdoll();
	combatrobot launchragdoll((velocity[0] + (randomfloatrange(-20, 20)), velocity[1] + (randomfloatrange(-20, 20)), randomfloatrange(60, 80)), "j_mainroot");
}

/*
	Name: oncombatrobottimeout
	Namespace: combat_robot
	Checksum: 0xE6DDE25B
	Offset: 0x3010
	Size: 0x2FC
	Parameters: 0
	Flags: Linked
*/
function oncombatrobottimeout()
{
	combatrobot = self;
	combatrobot killstreaks::play_pilot_dialog_on_owner("timeout", "combat_robot");
	combatrobot ai::set_behavior_attribute("shutdown", 1);
	wait(randomfloatrange(3, 4.5));
	_exploderobot(combatrobot);
	params = level.killstreakbundle["combat_robot"];
	if(isdefined(params.ksexplosionfx))
	{
		playfxontag(params.ksexplosionfx, combatrobot, "tag_origin");
	}
	target_remove(combatrobot);
	if(!isdefined(params.ksexplosionouterradius))
	{
		params.ksexplosionouterradius = 200;
	}
	if(!isdefined(params.ksexplosioninnerradius))
	{
		params.ksexplosioninnerradius = 1;
	}
	if(!isdefined(params.ksexplosionouterdamage))
	{
		params.ksexplosionouterdamage = 25;
	}
	if(!isdefined(params.ksexplosioninnerdamage))
	{
		params.ksexplosioninnerdamage = 350;
	}
	if(!isdefined(params.ksexplosionmagnitude))
	{
		params.ksexplosionmagnitude = 1;
	}
	physicsexplosionsphere(combatrobot.origin, params.ksexplosionouterradius, params.ksexplosioninnerradius, params.ksexplosionmagnitude, params.ksexplosionouterdamage, params.ksexplosioninnerdamage);
	if(isdefined(combatrobot.owner))
	{
		radiusdamage(combatrobot.origin, params.ksexplosionouterradius, params.ksexplosioninnerdamage, params.ksexplosionouterdamage, combatrobot.owner, "MOD_EXPLOSIVE", getweapon("combat_robot_marker"));
		if(isdefined(params.ksexplosionrumble))
		{
			combatrobot.owner playrumbleonentity(params.ksexplosionrumble);
		}
	}
	wait(0.2);
	combatrobot notify(#"combat_robot_shutdown");
}

/*
	Name: watchcombatrobotshutdown
	Namespace: combat_robot
	Checksum: 0x981DDDB4
	Offset: 0x3318
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function watchcombatrobotshutdown()
{
	combatrobot = self;
	combatrobotteam = combatrobot.originalteam;
	combatrobotkillstreakid = combatrobot.killstreak_id;
	combatrobot waittill(#"combat_robot_shutdown");
	combatrobot playsound("evt_combat_bot_mech_fail_explode");
	if(isdefined(combatrobot.usetrigger))
	{
		combatrobot.usetrigger delete();
	}
	if(isdefined(combatrobot.markerfxhandle))
	{
		combatrobot.markerfxhandle delete();
	}
	_destroyguardmarker(combatrobot);
	killstreakrules::killstreakstop("combat_robot", combatrobotteam, combatrobotkillstreakid);
	if(isdefined(combatrobot))
	{
		if(target_istarget(combatrobot))
		{
			target_remove(combatrobot);
		}
		if(!level.gameended)
		{
			if(combatrobot flagsys::get("in_vehicle"))
			{
				combatrobot unlink();
			}
			combatrobot kill();
		}
	}
}

/*
	Name: sndwatchcombatrobotvoxnotifies
	Namespace: combat_robot
	Checksum: 0xAF043E63
	Offset: 0x34C0
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function sndwatchcombatrobotvoxnotifies()
{
	combatrobot = self;
	combatrobot endon(#"combat_robot_shutdown");
	combatrobot endon(#"death");
	combatrobot playsoundontag("vox_robot_chatter", "j_head");
	while(true)
	{
		soundalias = undefined;
		combatrobot waittill(#"bhtn_action_notify", notify_string);
		switch(notify_string)
		{
			case "attack_kill":
			case "attack_melee":
			case "charge":
			case "modeSwap":
			{
				soundalias = "vox_robot_chatter";
				break;
			}
		}
		if(isdefined(soundalias))
		{
			combatrobot playsoundontag(soundalias, "j_head");
			wait(1.2);
		}
	}
}

/*
	Name: sndwatchexit
	Namespace: combat_robot
	Checksum: 0x45B5B559
	Offset: 0x35C8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function sndwatchexit()
{
	combatrobot = self;
	combatrobot endon(#"combat_robot_shutdown");
	combatrobot endon(#"death");
	combatrobot waittill(#"exiting_vehicle");
	combatrobot playsound("veh_vtol_supply_robot_launch");
}

/*
	Name: sndwatchlanding
	Namespace: combat_robot
	Checksum: 0xAEE064B6
	Offset: 0x3628
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function sndwatchlanding()
{
	combatrobot = self;
	combatrobot endon(#"combat_robot_shutdown");
	combatrobot endon(#"death");
	combatrobot waittill(#"falling", falltime);
	wait_time = falltime - 0.5;
	if(wait_time > 0)
	{
		wait(wait_time);
	}
	combatrobot playsound("veh_vtol_supply_robot_land");
}

/*
	Name: sndwatchactivate
	Namespace: combat_robot
	Checksum: 0x2D7295B4
	Offset: 0x36C8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function sndwatchactivate()
{
	combatrobot = self;
	combatrobot endon(#"combat_robot_shutdown");
	combatrobot endon(#"death");
	combatrobot waittill(#"landing");
	wait(0.1);
	combatrobot playsound("veh_vtol_supply_robot_activate");
}

/*
	Name: combatrobotdamageoverride
	Namespace: combat_robot
	Checksum: 0x5E2702DE
	Offset: 0x3738
	Size: 0x1A0
	Parameters: 12
	Flags: Linked
*/
function combatrobotdamageoverride(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex)
{
	combatrobot = self;
	if(combatrobot flagsys::get("in_vehicle") && smeansofdeath == "MOD_TRIGGER_HURT")
	{
		idamage = 0;
	}
	else
	{
		idamage = killstreaks::ondamageperweapon("combat_robot", eattacker, idamage, idflags, smeansofdeath, weapon, self.maxhealth, undefined, self.maxhealth * 0.4, undefined, 0, undefined, 1, 1);
	}
	combatrobot.missiletrackdamage = combatrobot.missiletrackdamage + idamage;
	if(idamage > 0 && isdefined(eattacker))
	{
		if(isplayer(eattacker))
		{
			if(isdefined(combatrobot.owner))
			{
				challenges::combat_robot_damage(eattacker, combatrobot.owner);
			}
		}
	}
	return idamage;
}

