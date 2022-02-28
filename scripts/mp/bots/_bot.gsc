// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\bots\_bot_ball;
#using scripts\mp\bots\_bot_clean;
#using scripts\mp\bots\_bot_combat;
#using scripts\mp\bots\_bot_conf;
#using scripts\mp\bots\_bot_ctf;
#using scripts\mp\bots\_bot_dem;
#using scripts\mp\bots\_bot_dom;
#using scripts\mp\bots\_bot_escort;
#using scripts\mp\bots\_bot_hq;
#using scripts\mp\bots\_bot_koth;
#using scripts\mp\bots\_bot_loadout;
#using scripts\mp\bots\_bot_sd;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_satellite;
#using scripts\mp\killstreaks\_uav;
#using scripts\mp\teams\_teams;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\bot_buttons;
#using scripts\shared\bots\bot_traversals;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\weapons_shared;

#namespace bot;

/*
	Name: __init__sytem__
	Namespace: bot
	Checksum: 0xF459461A
	Offset: 0x650
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bot_mp", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bot
	Checksum: 0xD13CB7F0
	Offset: 0x690
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	level.getbotsettings = &get_bot_settings;
	level.onbotconnect = &on_bot_connect;
	level.onbotspawned = &on_bot_spawned;
	level.onbotkilled = &on_bot_killed;
	level.botidle = &bot_idle;
	level.botthreatlost = &bot_combat::chase_threat;
	level.botprecombat = &bot_combat::mp_pre_combat;
	level.botcombat = &bot_combat::combat_think;
	level.botpostcombat = &bot_combat::mp_post_combat;
	level.botignorethreat = &bot_combat::bot_ignore_threat;
	level.enemyempactive = &emp::enemyempactive;
	/#
		level.botdevguicmd = &function_682f20bc;
		level thread system_devgui_gadget_think();
	#/
}

/*
	Name: init
	Namespace: bot
	Checksum: 0x4E87F123
	Offset: 0x7F8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level endon(#"game_ended");
	level.botsoak = is_bot_soak();
	if(level.rankedmatch && !level.botsoak || !init_bot_gametype())
	{
		return;
	}
	wait_for_host();
	level thread populate_bots();
}

/*
	Name: is_bot_soak
	Namespace: bot
	Checksum: 0xD544FA50
	Offset: 0x888
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function is_bot_soak()
{
	/#
		return getdvarint("", 0);
	#/
}

/*
	Name: wait_for_host
	Namespace: bot
	Checksum: 0x92CA68DB
	Offset: 0x8E8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function wait_for_host()
{
	level endon(#"game_ended");
	if(level.botsoak)
	{
		return;
	}
	host = util::gethostplayerforbots();
	while(!isdefined(host))
	{
		wait(0.25);
		host = util::gethostplayerforbots();
	}
}

/*
	Name: get_host_team
	Namespace: bot
	Checksum: 0x6ED01A99
	Offset: 0x958
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function get_host_team()
{
	host = util::gethostplayerforbots();
	if(!isdefined(host) || host.team == "spectator")
	{
		return "allies";
	}
	return host.team;
}

/*
	Name: is_bot_comp_stomp
	Namespace: bot
	Checksum: 0xCED4510B
	Offset: 0x9C0
	Size: 0x6
	Parameters: 0
	Flags: Linked
*/
function is_bot_comp_stomp()
{
	return false;
}

/*
	Name: on_bot_connect
	Namespace: bot
	Checksum: 0x22A8233A
	Offset: 0x9D0
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function on_bot_connect()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	if(isdefined(level.disableclassselection) && level.disableclassselection)
	{
		self set_rank();
		self bot_loadout::pick_hero_gadget();
		self bot_loadout::pick_killstreaks();
		return;
	}
	if(!(isdefined(self.pers["bot_loadout"]) && self.pers["bot_loadout"]))
	{
		self set_rank();
		self bot_loadout::build_classes();
		self bot_loadout::pick_hero_gadget();
		self bot_loadout::pick_killstreaks();
		self.pers["bot_loadout"] = 1;
	}
	self bot_loadout::pick_classes();
	self choose_class();
}

/*
	Name: on_bot_spawned
	Namespace: bot
	Checksum: 0xE122225D
	Offset: 0xB20
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function on_bot_spawned()
{
	self.bot.goaltag = undefined;
	/#
		weapon = undefined;
		if(getdvarint("") != 0)
		{
			player = util::gethostplayer();
			weapon = player getcurrentweapon();
		}
		if(getdvarstring("", "") != "")
		{
			weapon = getweapon(getdvarstring(""));
		}
		if(isdefined(weapon) && level.weaponnone != weapon)
		{
			self weapons::detach_all_weapons();
			self takeallweapons();
			self giveweapon(weapon);
			self switchtoweapon(weapon);
			self setspawnweapon(weapon);
			self teams::set_player_model(self.team, weapon);
		}
	#/
}

/*
	Name: on_bot_killed
	Namespace: bot
	Checksum: 0x153D5789
	Offset: 0xCB8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function on_bot_killed()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	self endon(#"spawned");
	self waittill(#"death_delay_finished");
	wait(0.1);
	if(self choose_class() && level.playerforcerespawn)
	{
		return;
	}
	self thread respawn();
}

/*
	Name: respawn
	Namespace: bot
	Checksum: 0x117DA822
	Offset: 0xD40
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function respawn()
{
	self endon(#"spawned");
	self endon(#"disconnect");
	level endon(#"game_ended");
	while(true)
	{
		self tap_use_button();
		wait(0.1);
	}
}

/*
	Name: bot_idle
	Namespace: bot
	Checksum: 0x9DC3A64B
	Offset: 0xD98
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function bot_idle()
{
	if(self do_supplydrop())
	{
		return;
	}
	self navmesh_wander();
	self sprint_to_goal();
}

/*
	Name: do_supplydrop
	Namespace: bot
	Checksum: 0xA72D913B
	Offset: 0xDF0
	Size: 0x334
	Parameters: 1
	Flags: Linked
*/
function do_supplydrop(maxrange = 1400)
{
	crates = getentarray("care_package", "script_noteworthy");
	maxrangesq = maxrange * maxrange;
	useradiussq = 3844;
	closestcrate = undefined;
	closestcratedistsq = undefined;
	foreach(crate in crates)
	{
		if(!crate isonground())
		{
			continue;
		}
		cratedistsq = distance2dsquared(self.origin, crate.origin);
		if(cratedistsq > maxrangesq)
		{
			continue;
		}
		inuse = isdefined(crate.useent) && (isdefined(crate.useent.inuse) && crate.useent.inuse);
		if(cratedistsq <= useradiussq)
		{
			if(inuse && !self usebuttonpressed())
			{
				continue;
			}
			self press_use_button();
			return true;
		}
		if(!self has_minimap() && !self botsighttracepassed(crate))
		{
			continue;
		}
		if(!isdefined(closestcrate) || cratedistsq < closestcratedistsq)
		{
			closestcrate = crate;
			closestcratedistsq = cratedistsq;
		}
	}
	if(isdefined(closestcrate))
	{
		randomangle = (0, randomint(360), 0);
		randomvec = anglestoforward(randomangle);
		point = closestcrate.origin + (randomvec * 39);
		if(self botsetgoal(point))
		{
			self thread watch_crate(closestcrate);
			return true;
		}
	}
	return false;
}

/*
	Name: watch_crate
	Namespace: bot
	Checksum: 0xB0B37450
	Offset: 0x1130
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function watch_crate(crate)
{
	self endon(#"death");
	self endon(#"bot_goal_reached");
	level endon(#"game_ended");
	while(isdefined(crate) && !self bot_combat::has_threat())
	{
		wait(level.botsettings.thinkinterval);
	}
	self botsetgoal(self.origin);
}

/*
	Name: populate_bots
	Namespace: bot
	Checksum: 0x4D85DF5F
	Offset: 0x11C0
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function populate_bots()
{
	level endon(#"game_ended");
	if(level.teambased)
	{
		maxallies = getdvarint("bot_maxAllies", 0);
		maxaxis = getdvarint("bot_maxAxis", 0);
		level thread monitor_bot_team_population(maxallies, maxaxis);
	}
	else
	{
		maxfree = getdvarint("bot_maxFree", 0);
		level thread monitor_bot_population(maxfree);
	}
}

/*
	Name: monitor_bot_team_population
	Namespace: bot
	Checksum: 0x379B3BC7
	Offset: 0x1298
	Size: 0x148
	Parameters: 2
	Flags: Linked
*/
function monitor_bot_team_population(maxallies, maxaxis)
{
	level endon(#"game_ended");
	if(!maxallies && !maxaxis)
	{
		return;
	}
	fill_balanced_teams(maxallies, maxaxis);
	while(true)
	{
		wait(3);
		allies = getplayers("allies");
		axis = getplayers("axis");
		if(allies.size > maxallies && remove_best_bot(allies))
		{
			continue;
		}
		if(axis.size > maxaxis && remove_best_bot(axis))
		{
			continue;
		}
		if(allies.size < maxallies || axis.size < maxaxis)
		{
			add_balanced_bot(allies, maxallies, axis, maxaxis);
		}
	}
}

/*
	Name: fill_balanced_teams
	Namespace: bot
	Checksum: 0x8EB8C4B9
	Offset: 0x13E8
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function fill_balanced_teams(maxallies, maxaxis)
{
	allies = getplayers("allies");
	axis = getplayers("axis");
	while(allies.size < maxallies || axis.size < maxaxis && add_balanced_bot(allies, maxallies, axis, maxaxis))
	{
		wait(0.05);
		allies = getplayers("allies");
		axis = getplayers("axis");
	}
}

/*
	Name: add_balanced_bot
	Namespace: bot
	Checksum: 0xCC7D3217
	Offset: 0x14E8
	Size: 0xB6
	Parameters: 4
	Flags: Linked
*/
function add_balanced_bot(allies, maxallies, axis, maxaxis)
{
	bot = undefined;
	if(allies.size < maxallies && (allies.size <= axis.size || axis.size >= maxaxis))
	{
		bot = add_bot("allies");
	}
	else if(axis.size < maxaxis)
	{
		bot = add_bot("axis");
	}
	return isdefined(bot);
}

/*
	Name: monitor_bot_population
	Namespace: bot
	Checksum: 0xC6EFE319
	Offset: 0x15A8
	Size: 0xF8
	Parameters: 1
	Flags: Linked
*/
function monitor_bot_population(maxfree)
{
	level endon(#"game_ended");
	if(!maxfree)
	{
		return;
	}
	players = getplayers();
	while(players.size < maxfree)
	{
		add_bot();
		wait(0.05);
		players = getplayers();
	}
	while(true)
	{
		wait(3);
		players = getplayers();
		if(players.size < maxfree)
		{
			add_bot();
		}
		else if(players.size > maxfree)
		{
			remove_best_bot(players);
		}
	}
}

/*
	Name: remove_best_bot
	Namespace: bot
	Checksum: 0x406E420C
	Offset: 0x16A8
	Size: 0x198
	Parameters: 1
	Flags: Linked
*/
function remove_best_bot(players)
{
	bots = filter_bots(players);
	if(!bots.size)
	{
		return false;
	}
	bestbots = [];
	foreach(bot in bots)
	{
		if(bot.sessionstate == "spectator")
		{
			continue;
		}
		if(bot.sessionstate == "dead" || !bot bot_combat::has_threat())
		{
			bestbots[bestbots.size] = bot;
		}
	}
	if(bestbots.size)
	{
		remove_bot(bestbots[randomint(bestbots.size)]);
	}
	else
	{
		remove_bot(bots[randomint(bots.size)]);
	}
	return true;
}

/*
	Name: choose_class
	Namespace: bot
	Checksum: 0xA2746BC4
	Offset: 0x1848
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function choose_class()
{
	if(isdefined(level.disableclassselection) && level.disableclassselection)
	{
		return false;
	}
	currclass = self bot_loadout::get_current_class();
	if(!isdefined(currclass) || randomint(100) < (isdefined(level.botsettings.changeclassweight) ? level.botsettings.changeclassweight : 0))
	{
		classindex = randomint(self.loadoutclasses.size);
		classname = self.loadoutclasses[classindex].name;
	}
	if(!isdefined(classname) || classname === currclass)
	{
		return false;
	}
	self notify(#"menuresponse", "ChooseClass_InGame", classname);
	return true;
}

/*
	Name: use_killstreak
	Namespace: bot
	Checksum: 0x1CE3024C
	Offset: 0x1968
	Size: 0x1F6
	Parameters: 0
	Flags: Linked
*/
function use_killstreak()
{
	if(!level.loadoutkillstreaksenabled || self emp::enemyempactive())
	{
		return;
	}
	weapons = self getweaponslist();
	inventoryweapon = self getinventoryweapon();
	foreach(weapon in weapons)
	{
		killstreak = killstreaks::get_killstreak_for_weapon(weapon);
		if(!isdefined(killstreak))
		{
			continue;
		}
		if(weapon != inventoryweapon && !self getweaponammoclip(weapon))
		{
			continue;
		}
		if(self killstreakrules::iskillstreakallowed(killstreak, self.team))
		{
			useweapon = weapon;
			break;
		}
	}
	if(!isdefined(useweapon))
	{
		return;
	}
	killstreak_ref = killstreaks::get_menu_name(killstreak);
	switch(killstreak_ref)
	{
		case "killstreak_counteruav":
		case "killstreak_helicopter_player_gunner":
		case "killstreak_raps":
		case "killstreak_satellite":
		case "killstreak_sentinel":
		case "killstreak_uav":
		{
			self switchtoweapon(useweapon);
			break;
		}
	}
}

/*
	Name: has_radar
	Namespace: bot
	Checksum: 0xF6389D03
	Offset: 0x1B68
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function has_radar()
{
	if(level.teambased)
	{
		return uav::hasuav(self.team) || satellite::hassatellite(self.team);
	}
	return uav::hasuav(self.entnum) || satellite::hassatellite(self.entnum);
}

/*
	Name: has_minimap
	Namespace: bot
	Checksum: 0xB4C29A33
	Offset: 0x1BE0
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function has_minimap()
{
	if(self isempjammed())
	{
		return 0;
	}
	if(isdefined(level.hardcoremode) && level.hardcoremode)
	{
		return self has_radar();
	}
	return 1;
}

/*
	Name: get_enemies
	Namespace: bot
	Checksum: 0xE3BD3CA
	Offset: 0x1C38
	Size: 0x1B0
	Parameters: 1
	Flags: Linked
*/
function get_enemies(on_radar = 0)
{
	enemies = self getenemies();
	/#
		for(i = 0; i < enemies.size; i++)
		{
			if(isplayer(enemies[i]) && enemies[i] isinmovemode("", ""))
			{
				arrayremoveindex(enemies, i);
				i--;
			}
		}
	#/
	if(on_radar && !self has_radar())
	{
		for(i = 0; i < enemies.size; i++)
		{
			if(!isdefined(enemies[i].lastfiretime))
			{
				arrayremoveindex(enemies, i);
				i--;
				continue;
			}
			if((gettime() - enemies[i].lastfiretime) > 2000)
			{
				arrayremoveindex(enemies, i);
				i--;
			}
		}
	}
	return enemies;
}

/*
	Name: set_rank
	Namespace: bot
	Checksum: 0x4B60B0FD
	Offset: 0x1DF0
	Size: 0x324
	Parameters: 0
	Flags: Linked
*/
function set_rank()
{
	players = getplayers();
	ranks = [];
	bot_ranks = [];
	human_ranks = [];
	for(i = 0; i < players.size; i++)
	{
		if(players[i] == self)
		{
			continue;
		}
		if(isdefined(players[i].pers["rank"]))
		{
			if(players[i] util::is_bot())
			{
				bot_ranks[bot_ranks.size] = players[i].pers["rank"];
				continue;
			}
			human_ranks[human_ranks.size] = players[i].pers["rank"];
		}
	}
	if(!human_ranks.size)
	{
		human_ranks[human_ranks.size] = 10;
	}
	human_avg = math::array_average(human_ranks);
	while((bot_ranks.size + human_ranks.size) < 5)
	{
		r = human_avg + (randomintrange(-5, 5));
		rank = math::clamp(r, 0, level.maxrank);
		human_ranks[human_ranks.size] = rank;
	}
	ranks = arraycombine(human_ranks, bot_ranks, 1, 0);
	avg = math::array_average(ranks);
	s = math::array_std_deviation(ranks, avg);
	rank = int(math::random_normal_distribution(avg, s, 0, level.maxrank));
	while(!isdefined(self.pers["codpoints"]))
	{
		wait(0.1);
	}
	self.pers["rank"] = rank;
	self.pers["rankxp"] = rank::getrankinfominxp(rank);
	self setrank(rank);
	self rank::syncxpstat();
}

/*
	Name: init_bot_gametype
	Namespace: bot
	Checksum: 0xB85CF2B0
	Offset: 0x2120
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function init_bot_gametype()
{
	switch(level.gametype)
	{
		case "ball":
		{
			bot_ball::init();
			return true;
		}
		case "conf":
		{
			bot_conf::init();
			return true;
		}
		case "ctf":
		{
			bot_ctf::init();
			return true;
		}
		case "dem":
		{
			bot_dem::init();
			return true;
		}
		case "dm":
		{
			return true;
		}
		case "dom":
		{
			bot_dom::init();
			return true;
		}
		case "escort":
		{
			namespace_ebd80b8b::init();
			return true;
		}
		case "infect":
		{
			return true;
		}
		case "gun":
		{
			return true;
		}
		case "koth":
		{
			bot_koth::init();
			return true;
		}
		case "sd":
		{
			bot_sd::init();
			return true;
		}
		case "clean":
		{
			bot_clean::init();
			return true;
		}
		case "tdm":
		{
			return true;
		}
	}
	return false;
}

/*
	Name: get_bot_settings
	Namespace: bot
	Checksum: 0xD251C025
	Offset: 0x22A0
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function get_bot_settings()
{
	switch(getdvarint("bot_difficulty", 1))
	{
		case 0:
		{
			bundlename = "bot_mp_easy";
			break;
		}
		case 1:
		{
			bundlename = "bot_mp_normal";
			break;
		}
		case 2:
		{
			bundlename = "bot_mp_hard";
			break;
		}
		case 3:
		default:
		{
			bundlename = "bot_mp_veteran";
			break;
		}
	}
	return struct::get_script_bundle("botsettings", bundlename);
}

/*
	Name: friend_goal_in_radius
	Namespace: bot
	Checksum: 0xED3002FD
	Offset: 0x2368
	Size: 0x1E
	Parameters: 3
	Flags: Linked
*/
function friend_goal_in_radius(goal_name, origin, radius)
{
	return false;
}

/*
	Name: friend_in_radius
	Namespace: bot
	Checksum: 0xB6116329
	Offset: 0x2390
	Size: 0x1E
	Parameters: 3
	Flags: None
*/
function friend_in_radius(goal_name, origin, radius)
{
	return false;
}

/*
	Name: get_friends
	Namespace: bot
	Checksum: 0xC902D934
	Offset: 0x23B8
	Size: 0x6
	Parameters: 0
	Flags: None
*/
function get_friends()
{
	return [];
}

/*
	Name: get_closest_enemy
	Namespace: bot
	Checksum: 0x5B4F9F29
	Offset: 0x23C8
	Size: 0x16
	Parameters: 2
	Flags: Linked
*/
function get_closest_enemy(origin, someflag)
{
	return undefined;
}

/*
	Name: bot_vehicle_weapon_ammo
	Namespace: bot
	Checksum: 0x12B3937C
	Offset: 0x23E8
	Size: 0xE
	Parameters: 1
	Flags: None
*/
function bot_vehicle_weapon_ammo(weaponname)
{
	return false;
}

/*
	Name: navmesh_points_visible
	Namespace: bot
	Checksum: 0x79895444
	Offset: 0x2400
	Size: 0x16
	Parameters: 2
	Flags: Linked
*/
function navmesh_points_visible(origin, point)
{
	return false;
}

/*
	Name: dive_to_prone
	Namespace: bot
	Checksum: 0x2EED0321
	Offset: 0x2420
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function dive_to_prone(exit_stance)
{
}

/*
	Name: function_682f20bc
	Namespace: bot
	Checksum: 0xD22845A2
	Offset: 0x2438
	Size: 0x388
	Parameters: 1
	Flags: Linked
*/
function function_682f20bc(cmd)
{
	/#
		var_d03a6f21 = strtok(cmd, "");
		if(var_d03a6f21.size == 0)
		{
			return false;
		}
		host = util::gethostplayerforbots();
		team = get_host_team();
		switch(var_d03a6f21[0])
		{
			case "":
			{
				team = util::getotherteam(team);
			}
			case "":
			{
				count = 1;
				if(var_d03a6f21.size > 1)
				{
					count = int(var_d03a6f21[1]);
				}
				for(i = 0; i < count; i++)
				{
					add_bot(team);
				}
				return true;
			}
			case "":
			{
				team = util::getotherteam(team);
			}
			case "":
			{
				remove_bots(undefined, team);
				return true;
			}
			case "":
			{
				team = util::getotherteam(team);
			}
			case "":
			{
				bot = add_bot_at_eye_trace(team);
				if(isdefined(bot))
				{
					bot thread fixed_spawn_override();
				}
				return true;
			}
			case "":
			{
				players = getplayers();
				foreach(player in players)
				{
					if(!player util::is_bot())
					{
						continue;
					}
					weapon = host getcurrentweapon();
					player weapons::detach_all_weapons();
					player takeallweapons();
					player giveweapon(weapon);
					player switchtoweapon(weapon);
					player setspawnweapon(weapon);
					player teams::set_player_model(player.team, weapon);
				}
				return true;
			}
		}
		return false;
	#/
}

/*
	Name: system_devgui_gadget_think
	Namespace: bot
	Checksum: 0xD5D02109
	Offset: 0x27D0
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function system_devgui_gadget_think()
{
	/#
		setdvar("", "");
		for(;;)
		{
			wait(1);
			gadget = getdvarstring("");
			if(gadget != "")
			{
				bot_turn_on_gadget(getweapon(gadget));
				setdvar("", "");
			}
		}
	#/
}

/*
	Name: bot_turn_on_gadget
	Namespace: bot
	Checksum: 0x4458AFCD
	Offset: 0x2890
	Size: 0x252
	Parameters: 1
	Flags: Linked
*/
function bot_turn_on_gadget(gadget)
{
	/#
		players = getplayers();
		foreach(player in players)
		{
			if(!player util::is_bot())
			{
				continue;
			}
			host = util::gethostplayer();
			weapon = host getcurrentweapon();
			if(!isdefined(weapon) || weapon == level.weaponnone || weapon == level.weaponnull)
			{
				weapon = getweapon("");
			}
			player weapons::detach_all_weapons();
			player takeallweapons();
			player giveweapon(weapon);
			player switchtoweapon(weapon);
			player setspawnweapon(weapon);
			player teams::set_player_model(player.team, weapon);
			player giveweapon(gadget);
			slot = player gadgetgetslot(gadget);
			player gadgetpowerset(slot, 100);
			player botpressbuttonforgadget(gadget);
		}
	#/
}

/*
	Name: fixed_spawn_override
	Namespace: bot
	Checksum: 0xD218870F
	Offset: 0x2AF0
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function fixed_spawn_override()
{
	/#
		self endon(#"disconnect");
		spawnorigin = self.origin;
		spawnangles = self.angles;
		while(true)
		{
			self waittill(#"spawned_player");
			self setorigin(spawnorigin);
			self setplayerangles(spawnangles);
		}
	#/
}

