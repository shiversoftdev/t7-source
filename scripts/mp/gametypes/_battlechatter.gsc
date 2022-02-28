// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_dev;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\abilities\gadgets\_gadget_camo;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace battlechatter;

/*
	Name: __init__sytem__
	Namespace: battlechatter
	Checksum: 0x988120EB
	Offset: 0xFE0
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
	Checksum: 0x5D18B264
	Offset: 0x1020
	Size: 0x7A0
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		level thread devgui_think();
	#/
	callback::on_joined_team(&on_joined_team);
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	level.heroplaydialog = &play_dialog;
	level.playgadgetready = &play_gadget_ready;
	level.playgadgetactivate = &play_gadget_activate;
	level.playgadgetsuccess = &play_gadget_success;
	level.playpromotionreaction = &play_promotion_reaction;
	level.playthrowhatchet = &play_throw_hatchet;
	level.bcsounds = [];
	level.bcsounds["incoming_alert"] = [];
	level.bcsounds["incoming_alert"]["frag_grenade"] = "incomingFrag";
	level.bcsounds["incoming_alert"]["incendiary_grenade"] = "incomingIncendiary";
	level.bcsounds["incoming_alert"]["sticky_grenade"] = "incomingSemtex";
	level.bcsounds["incoming_alert"]["launcher_standard"] = "threatRpg";
	level.bcsounds["incoming_delay"] = [];
	level.bcsounds["incoming_delay"]["frag_grenade"] = "fragGrenadeDelay";
	level.bcsounds["incoming_delay"]["incendiary_grenade"] = "incendiaryGrenadeDelay";
	level.bcsounds["incoming_alert"]["sticky_grenade"] = "semtexDelay";
	level.bcsounds["incoming_delay"]["launcher_standard"] = "missileDelay";
	level.bcsounds["kill_dialog"] = [];
	level.bcsounds["kill_dialog"]["assassin"] = "killSpectre";
	level.bcsounds["kill_dialog"]["grenadier"] = "killGrenadier";
	level.bcsounds["kill_dialog"]["outrider"] = "killOutrider";
	level.bcsounds["kill_dialog"]["prophet"] = "killTechnomancer";
	level.bcsounds["kill_dialog"]["pyro"] = "killFirebreak";
	level.bcsounds["kill_dialog"]["reaper"] = "killReaper";
	level.bcsounds["kill_dialog"]["ruin"] = "killMercenary";
	level.bcsounds["kill_dialog"]["seraph"] = "killEnforcer";
	level.bcsounds["kill_dialog"]["trapper"] = "killTrapper";
	level.bcsounds["kill_dialog"]["blackjack"] = "killBlackjack";
	if(level.teambased && !isdefined(game["boostPlayersPicked"]))
	{
		game["boostPlayersPicked"] = [];
		foreach(team in level.teams)
		{
			game["boostPlayersPicked"][team] = 0;
		}
	}
	level.allowbattlechatter = getgametypesetting("allowBattleChatter");
	clientfield::register("world", "boost_number", 1, 2, "int");
	clientfield::register("allplayers", "play_boost", 1, 2, "int");
	level thread pick_boost_number();
	playerdialogbundles = struct::get_script_bundles("mpdialog_player");
	foreach(bundle in playerdialogbundles)
	{
		count_keys(bundle, "killGeneric");
		count_keys(bundle, "killSniper");
		count_keys(bundle, "killSpectre");
		count_keys(bundle, "killGrenadier");
		count_keys(bundle, "killOutrider");
		count_keys(bundle, "killTechnomancer");
		count_keys(bundle, "killFirebreak");
		count_keys(bundle, "killReaper");
		count_keys(bundle, "killMercenary");
		count_keys(bundle, "killEnforcer");
		count_keys(bundle, "killTrapper");
		count_keys(bundle, "killBlackjack");
	}
	level.allowspecialistdialog = mpdialog_value("enableHeroDialog", 0) && level.allowbattlechatter;
	level.playstartconversation = mpdialog_value("enableConversation", 0) && level.allowbattlechatter;
}

/*
	Name: pick_boost_number
	Namespace: battlechatter
	Checksum: 0x7AA0497C
	Offset: 0x17C8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function pick_boost_number()
{
	wait(5);
	level clientfield::set("boost_number", randomint(4));
}

/*
	Name: on_joined_team
	Namespace: battlechatter
	Checksum: 0x9A09DD22
	Offset: 0x1810
	Size: 0x1AA
	Parameters: 0
	Flags: Linked
*/
function on_joined_team()
{
	self endon(#"disconnect");
	if(level.teambased)
	{
		if(self.team == "allies")
		{
			self set_blops_dialog();
		}
		else
		{
			self set_cdp_dialog();
		}
	}
	else
	{
		if(randomintrange(0, 2))
		{
			self set_blops_dialog();
		}
		else
		{
			self set_cdp_dialog();
		}
	}
	self globallogic_audio::flush_dialog();
	if(level.disableprematchmessages === 1)
	{
		return;
	}
	if(isdefined(level.inprematchperiod) && level.inprematchperiod && (!(isdefined(self.pers["playedGameMode"]) && self.pers["playedGameMode"])) && isdefined(level.leaderdialog))
	{
		if(level.hardcoremode)
		{
			self globallogic_audio::leader_dialog_on_player(level.leaderdialog.starthcgamedialog, undefined, undefined, undefined, 1);
		}
		else
		{
			self globallogic_audio::leader_dialog_on_player(level.leaderdialog.startgamedialog, undefined, undefined, undefined, 1);
		}
		self.pers["playedGameMode"] = 1;
	}
}

/*
	Name: set_blops_dialog
	Namespace: battlechatter
	Checksum: 0x7C290948
	Offset: 0x19C8
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function set_blops_dialog()
{
	self.pers["mptaacom"] = "blops_taacom";
	self.pers["mpcommander"] = "blops_commander";
}

/*
	Name: set_cdp_dialog
	Namespace: battlechatter
	Checksum: 0xD11D16D8
	Offset: 0x1A10
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function set_cdp_dialog()
{
	self.pers["mptaacom"] = "cdp_taacom";
	self.pers["mpcommander"] = "cdp_commander";
}

/*
	Name: on_player_connect
	Namespace: battlechatter
	Checksum: 0x7E21C9BA
	Offset: 0x1A58
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self reset_dialog_fields();
}

/*
	Name: on_player_spawned
	Namespace: battlechatter
	Checksum: 0xBE5CDEFA
	Offset: 0x1A80
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self reset_dialog_fields();
	if(level.splitscreen)
	{
		return;
	}
	self thread water_vox();
	self thread grenade_tracking();
	self thread missile_tracking();
	self thread sticky_grenade_tracking();
	if(level.teambased)
	{
		self thread enemy_threat();
		self thread check_boost_start_conversation();
	}
}

/*
	Name: reset_dialog_fields
	Namespace: battlechatter
	Checksum: 0xC6D64470
	Offset: 0x1B48
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function reset_dialog_fields()
{
	self.enemythreattime = 0;
	self.heartbeatsnd = 0;
	self.soundmod = "player";
	self.voxunderwatertime = 0;
	self.voxemergebreath = 0;
	self.voxdrowning = 0;
	self.pilotisspeaking = 0;
	self.playingdialog = 0;
	self.playinggadgetreadydialog = 0;
	self.playedgadgetsuccess = 1;
}

/*
	Name: dialog_chance
	Namespace: battlechatter
	Checksum: 0x143E7AC
	Offset: 0x1BD0
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function dialog_chance(chancekey)
{
	dialogchance = mpdialog_value(chancekey);
	if(!isdefined(dialogchance) || dialogchance <= 0)
	{
		return 0;
	}
	if(dialogchance >= 100)
	{
		return 1;
	}
	return randomint(100) < dialogchance;
}

/*
	Name: mpdialog_value
	Namespace: battlechatter
	Checksum: 0xCA07B64B
	Offset: 0x1C58
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function mpdialog_value(mpdialogkey, defaultvalue)
{
	if(!isdefined(mpdialogkey))
	{
		return defaultvalue;
	}
	mpdialog = struct::get_script_bundle("mpdialog", "mpdialog_default");
	if(!isdefined(mpdialog))
	{
		return defaultvalue;
	}
	structvalue = getstructfield(mpdialog, mpdialogkey);
	if(!isdefined(structvalue))
	{
		return defaultvalue;
	}
	return structvalue;
}

/*
	Name: water_vox
	Namespace: battlechatter
	Checksum: 0x740FC1C2
	Offset: 0x1D00
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function water_vox()
{
	self endon(#"death");
	level endon(#"game_ended");
	while(true)
	{
		interval = mpdialog_value("underwaterInterval", 0.05);
		if(interval <= 0)
		{
			/#
				assert(interval > 0, "");
			#/
			return;
		}
		wait(interval);
		if(util::isprophuntgametype() && self util::isprop())
		{
			continue;
		}
		if(self isplayerunderwater())
		{
			if(!self.voxunderwatertime && !self.voxemergebreath)
			{
				self stopsounds();
				self.voxunderwatertime = gettime();
			}
			else if(self.voxunderwatertime)
			{
				if(gettime() > (self.voxunderwatertime + (mpdialog_value("underwaterBreathTime", 0) * 1000)))
				{
					self.voxunderwatertime = 0;
					self.voxemergebreath = 1;
				}
			}
		}
		else
		{
			if(self.voxdrowning)
			{
				self thread play_dialog("exertEmergeGasp", 20, mpdialog_value("playerExertBuffer", 0));
				self.voxdrowning = 0;
				self.voxemergebreath = 0;
			}
			else if(self.voxemergebreath)
			{
				self thread play_dialog("exertEmergeBreath", 20, mpdialog_value("playerExertBuffer", 0));
				self.voxemergebreath = 0;
			}
		}
	}
}

/*
	Name: pain_vox
	Namespace: battlechatter
	Checksum: 0x43531411
	Offset: 0x1F28
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function pain_vox(meansofdeath)
{
	if(dialog_chance("smallPainChance"))
	{
		if(meansofdeath == "MOD_DROWN")
		{
			dialogkey = "exertPainDrowning";
			self.voxdrowning = 1;
		}
		else
		{
			if(meansofdeath == "MOD_FALLING")
			{
				dialogkey = "exertPainFalling";
			}
			else
			{
				if(self isplayerunderwater())
				{
					dialogkey = "exertPainUnderwater";
				}
				else
				{
					dialogkey = "exertPain";
				}
			}
		}
		exertbuffer = mpdialog_value("playerExertBuffer", 0);
		self thread play_dialog(dialogkey, 30, exertbuffer);
	}
}

/*
	Name: on_player_suicide_or_team_kill
	Namespace: battlechatter
	Checksum: 0xF58220FD
	Offset: 0x2030
	Size: 0x38
	Parameters: 2
	Flags: Linked
*/
function on_player_suicide_or_team_kill(player, type)
{
	self endon(#"death");
	level endon(#"game_ended");
	waittillframeend();
	if(!level.teambased)
	{
		return;
	}
}

/*
	Name: on_player_near_explodable
	Namespace: battlechatter
	Checksum: 0x1CAD6F47
	Offset: 0x2070
	Size: 0x2A
	Parameters: 2
	Flags: Linked
*/
function on_player_near_explodable(object, type)
{
	self endon(#"death");
	level endon(#"game_ended");
}

/*
	Name: enemy_threat
	Namespace: battlechatter
	Checksum: 0x8EBD3D23
	Offset: 0x20A8
	Size: 0x298
	Parameters: 0
	Flags: Linked
*/
function enemy_threat()
{
	self endon(#"death");
	level endon(#"game_ended");
	if(util::isprophuntgametype())
	{
		return;
	}
	while(true)
	{
		self waittill(#"weapon_ads");
		if(self hasperk("specialty_quieter"))
		{
			continue;
		}
		if((self.enemythreattime + (mpdialog_value("enemyContactInterval", 0) * 1000)) >= gettime())
		{
			continue;
		}
		closest_ally = self get_closest_player_ally(1);
		if(!isdefined(closest_ally))
		{
			continue;
		}
		allyradius = mpdialog_value("enemyContactAllyRadius", 0);
		if(distancesquared(self.origin, closest_ally.origin) < (allyradius * allyradius))
		{
			eyepoint = self geteye();
			dir = anglestoforward(self getplayerangles());
			dir = dir * mpdialog_value("enemyContactDistance", 0);
			endpoint = eyepoint + dir;
			traceresult = bullettrace(eyepoint, endpoint, 1, self);
			if(isdefined(traceresult["entity"]) && traceresult["entity"].classname == "player" && traceresult["entity"].team != self.team)
			{
				if(dialog_chance("enemyContactChance"))
				{
					self thread play_dialog("threatInfantry", 1);
					level notify(#"level_enemy_spotted", self.team);
					self.enemythreattime = gettime();
				}
			}
		}
	}
}

/*
	Name: killed_by_sniper
	Namespace: battlechatter
	Checksum: 0x4892D87B
	Offset: 0x2348
	Size: 0x290
	Parameters: 1
	Flags: Linked
*/
function killed_by_sniper(sniper)
{
	self endon(#"disconnect");
	sniper endon(#"disconnect");
	level endon(#"game_ended");
	if(!level.teambased)
	{
		return false;
	}
	if(util::isprophuntgametype())
	{
		return false;
	}
	waittillframeend();
	if(dialog_chance("sniperKillChance"))
	{
		closest_ally = self get_closest_player_ally();
		allyradius = mpdialog_value("sniperKillAllyRadius", 0);
		if(isdefined(closest_ally) && distancesquared(self.origin, closest_ally.origin) < (allyradius * allyradius))
		{
			closest_ally thread play_dialog("threatSniper", 1);
			sniper.spottedtime = gettime();
			sniper.spottedby = [];
			players = self get_friendly_players();
			players = arraysort(players, self.origin);
			voiceradius = mpdialog_value("playerVoiceRadius", 0);
			voiceradiussq = voiceradius * voiceradius;
			foreach(player in players)
			{
				if(distancesquared(closest_ally.origin, player.origin) <= voiceradiussq)
				{
					sniper.spottedby[sniper.spottedby.size] = player;
				}
			}
		}
	}
}

/*
	Name: player_killed
	Namespace: battlechatter
	Checksum: 0x528B26C8
	Offset: 0x25E0
	Size: 0x154
	Parameters: 2
	Flags: Linked
*/
function player_killed(attacker, killstreaktype)
{
	if(!level.teambased)
	{
		return;
	}
	if(self === attacker)
	{
		return;
	}
	waittillframeend();
	if(isdefined(killstreaktype))
	{
		if(!isdefined(level.killstreaks[killstreaktype]) || !isdefined(level.killstreaks[killstreaktype].threatonkill) || !level.killstreaks[killstreaktype].threatonkill || !dialog_chance("killstreakKillChance"))
		{
			return;
		}
		ally = get_closest_player_ally(1);
		allyradius = mpdialog_value("killstreakKillAllyRadius", 0);
		if(isdefined(ally) && distancesquared(self.origin, ally.origin) < (allyradius * allyradius))
		{
			ally play_killstreak_threat(killstreaktype);
		}
	}
}

/*
	Name: say_kill_battle_chatter
	Namespace: battlechatter
	Checksum: 0x8ADEAD5D
	Offset: 0x2740
	Size: 0x574
	Parameters: 4
	Flags: Linked
*/
function say_kill_battle_chatter(attacker, weapon, victim, inflictor)
{
	if(weapon.skipbattlechatterkill || !isdefined(attacker) || !isplayer(attacker) || !isalive(attacker) || attacker isremotecontrolling() || attacker isinvehicle() || attacker isweaponviewonlylinked() || !isdefined(victim) || !isplayer(victim) || util::isprophuntgametype())
	{
		return;
	}
	if(isdefined(inflictor) && !isplayer(inflictor) && inflictor.birthtime < attacker.spawntime)
	{
		return;
	}
	if(weapon.inventorytype == "hero")
	{
		if(!isdefined(attacker.heroweaponkillcount))
		{
			attacker.heroweaponkillcount = 0;
		}
		attacker.heroweaponkillcount++;
		if(!(isdefined(attacker.playedgadgetsuccess) && attacker.playedgadgetsuccess) && attacker.heroweaponkillcount === mpdialog_value("heroWeaponKillCount", 0))
		{
			attacker thread play_gadget_success(weapon, "enemyKillDelay", victim);
			attacker thread hero_weapon_success_reaction();
		}
	}
	else
	{
		if(isdefined(attacker.speedburston) && attacker.speedburston)
		{
			if(!(isdefined(attacker.speedburstkill) && attacker.speedburstkill))
			{
				speedburstkilldist = mpdialog_value("speedBurstKillDistance", 0);
				if(distancesquared(attacker.origin, victim.origin) < (speedburstkilldist * speedburstkilldist))
				{
					attacker.speedburstkill = 1;
				}
			}
		}
		else
		{
			if(attacker _gadget_camo::camo_is_inuse() || (isdefined(attacker.gadget_camo_off_time) && (attacker.gadget_camo_off_time + (mpdialog_value("camoKillTime", 0) * 1000)) >= gettime()))
			{
				if(!(isdefined(attacker.playedgadgetsuccess) && attacker.playedgadgetsuccess))
				{
					attacker thread play_gadget_success(getweapon("gadget_camo"), "enemyKillDelay", victim);
				}
			}
			else if(dialog_chance("enemyKillChance"))
			{
				if(isdefined(victim.spottedtime) && (victim.spottedtime + mpdialog_value("enemySniperKillTime", 0)) >= gettime() && array::contains(victim.spottedby, attacker) && dialog_chance("enemySniperKillChance"))
				{
					killdialog = attacker get_random_key("killSniper");
				}
				else
				{
					if(dialog_chance("enemyHeroKillChance"))
					{
						victimdialogname = victim getmpdialogname();
						killdialog = attacker get_random_key(level.bcsounds["kill_dialog"][victimdialogname]);
					}
					else
					{
						killdialog = attacker get_random_key("killGeneric");
					}
				}
			}
		}
	}
	victim.spottedtime = undefined;
	victim.spottedby = undefined;
	if(!isdefined(killdialog))
	{
		return;
	}
	attacker thread wait_play_dialog(mpdialog_value("enemyKillDelay", 0), killdialog, 1, undefined, victim, "cancel_kill_dialog");
}

/*
	Name: grenade_tracking
	Namespace: battlechatter
	Checksum: 0x74D9C28C
	Offset: 0x2CC0
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function grenade_tracking()
{
	self endon(#"death");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"grenade_fire", grenade, weapon);
		if(!isdefined(grenade.weapon) || !isdefined(grenade.weapon.rootweapon) || !dialog_chance("incomingProjectileChance"))
		{
			continue;
		}
		dialogkey = level.bcsounds["incoming_alert"][grenade.weapon.rootweapon.name];
		if(isdefined(dialogkey))
		{
			waittime = mpdialog_value(level.bcsounds["incoming_delay"][grenade.weapon.rootweapon.name], 0.05);
			level thread incoming_projectile_alert(self, grenade, dialogkey, waittime);
		}
	}
}

/*
	Name: missile_tracking
	Namespace: battlechatter
	Checksum: 0x81B38420
	Offset: 0x2E28
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function missile_tracking()
{
	self endon(#"death");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"missile_fire", missile, weapon);
		if(!isdefined(missile.item) || !isdefined(missile.item.rootweapon) || !dialog_chance("incomingProjectileChance"))
		{
			continue;
		}
		dialogkey = level.bcsounds["incoming_alert"][missile.item.rootweapon.name];
		if(isdefined(dialogkey))
		{
			waittime = mpdialog_value(level.bcsounds["incoming_delay"][missile.item.rootweapon.name], 0.05);
			level thread incoming_projectile_alert(self, missile, dialogkey, waittime);
		}
	}
}

/*
	Name: incoming_projectile_alert
	Namespace: battlechatter
	Checksum: 0x4A9707
	Offset: 0x2F90
	Size: 0x1AA
	Parameters: 4
	Flags: Linked
*/
function incoming_projectile_alert(thrower, projectile, dialogkey, waittime)
{
	level endon(#"game_ended");
	if(waittime <= 0)
	{
		/#
			assert(waittime > 0, "");
		#/
		return;
	}
	if(util::isprophuntgametype())
	{
		return;
	}
	while(true)
	{
		wait(waittime);
		if(waittime > 0.2)
		{
			waittime = waittime / 2;
		}
		if(!isdefined(projectile))
		{
			return;
		}
		if(!isdefined(thrower) || thrower.team == "spectator")
		{
			return;
		}
		if(level.players.size)
		{
			closest_enemy = thrower get_closest_player_enemy(projectile.origin);
			incomingprojectileradius = mpdialog_value("incomingProjectileRadius", 0);
			if(isdefined(closest_enemy) && distancesquared(projectile.origin, closest_enemy.origin) < (incomingprojectileradius * incomingprojectileradius))
			{
				closest_enemy thread play_dialog(dialogkey, 6);
				return;
			}
		}
	}
}

/*
	Name: sticky_grenade_tracking
	Namespace: battlechatter
	Checksum: 0x1851EE5
	Offset: 0x3148
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function sticky_grenade_tracking()
{
	self endon(#"death");
	level endon(#"game_ended");
	while(true)
	{
		self waittill(#"grenade_stuck", grenade);
		if(isalive(self) && isdefined(grenade) && isdefined(grenade.weapon))
		{
			if(grenade.weapon.rootweapon.name == "sticky_grenade")
			{
				self thread play_dialog("stuckSticky", 6);
			}
		}
	}
}

/*
	Name: hero_weapon_success_reaction
	Namespace: battlechatter
	Checksum: 0x90B26441
	Offset: 0x3218
	Size: 0x38E
	Parameters: 0
	Flags: Linked
*/
function hero_weapon_success_reaction()
{
	self endon(#"death");
	level endon(#"game_ended");
	if(!level.teambased)
	{
		return;
	}
	if(util::isprophuntgametype())
	{
		return;
	}
	allies = [];
	allyradiussq = mpdialog_value("playerVoiceRadius", 0);
	allyradiussq = allyradiussq * allyradiussq;
	foreach(player in level.players)
	{
		if(!isdefined(player) || !isalive(player) || player.sessionstate != "playing" || player == self || player.team != self.team)
		{
			continue;
		}
		distsq = distancesquared(self.origin, player.origin);
		if(distsq > allyradiussq)
		{
			continue;
		}
		allies[allies.size] = player;
	}
	wait(mpdialog_value("enemyKillDelay", 0) + 0.1);
	while(self.playingdialog)
	{
		wait(0.5);
	}
	allies = arraysort(allies, self.origin);
	foreach(player in allies)
	{
		if(!isalive(player) || player.sessionstate != "playing" || player.playingdialog || player isplayerunderwater() || player isremotecontrolling() || player isinvehicle() || player isweaponviewonlylinked())
		{
			continue;
		}
		distsq = distancesquared(self.origin, player.origin);
		if(distsq > allyradiussq)
		{
			break;
		}
		player play_dialog("heroWeaponSuccessReaction", 1);
		break;
	}
}

/*
	Name: play_promotion_reaction
	Namespace: battlechatter
	Checksum: 0xA9CE52D7
	Offset: 0x35B0
	Size: 0x294
	Parameters: 0
	Flags: Linked
*/
function play_promotion_reaction()
{
	self endon(#"death");
	level endon(#"game_ended");
	if(!level.teambased)
	{
		return;
	}
	if(util::isprophuntgametype() && self util::isprop())
	{
		return;
	}
	wait(9);
	players = self get_friendly_players();
	players = arraysort(players, self.origin);
	selfdialog = self getmpdialogname();
	voiceradius = mpdialog_value("playerVoiceRadius", 0);
	voiceradiussq = voiceradius * voiceradius;
	foreach(player in players)
	{
		if(player == self || player getmpdialogname() == selfdialog || !player can_play_dialog(1) || distancesquared(self.origin, player.origin) >= voiceradiussq)
		{
			continue;
		}
		dialogalias = player get_player_dialog_alias("promotionReaction");
		if(!isdefined(dialogalias))
		{
			continue;
		}
		ally = player;
		break;
	}
	if(isdefined(ally))
	{
		ally playsoundontag(dialogalias, "J_Head", undefined, self);
		ally thread wait_dialog_buffer(mpdialog_value("playerDialogBuffer", 0));
	}
}

/*
	Name: gametype_specific_battle_chatter
	Namespace: battlechatter
	Checksum: 0x8BDC17EA
	Offset: 0x3850
	Size: 0x2A
	Parameters: 2
	Flags: None
*/
function gametype_specific_battle_chatter(event, team)
{
	self endon(#"death");
	level endon(#"game_ended");
}

/*
	Name: play_death_vox
	Namespace: battlechatter
	Checksum: 0x9AB9B6E5
	Offset: 0x3888
	Size: 0xA4
	Parameters: 4
	Flags: Linked
*/
function play_death_vox(body, attacker, weapon, meansofdeath)
{
	dialogkey = self get_death_vox(weapon, meansofdeath);
	dialogalias = self get_player_dialog_alias(dialogkey);
	if(isdefined(dialogalias))
	{
		body playsoundontag(dialogalias, "J_Head");
	}
}

/*
	Name: get_death_vox
	Namespace: battlechatter
	Checksum: 0x7D35BB1D
	Offset: 0x3938
	Size: 0xFE
	Parameters: 2
	Flags: Linked
*/
function get_death_vox(weapon, meansofdeath)
{
	if(self isplayerunderwater())
	{
		return "exertDeathDrowned";
	}
	if(isdefined(meansofdeath))
	{
		switch(meansofdeath)
		{
			case "MOD_BURNED":
			{
				return "exertDeathBurned";
			}
			case "MOD_DROWN":
			{
				return "exertDeathDrowned";
			}
		}
	}
	if(isdefined(weapon) && meansofdeath !== "MOD_MELEE_WEAPON_BUTT")
	{
		switch(weapon.rootweapon.name)
		{
			case "hatchet":
			case "hero_armblade":
			case "knife_loadout":
			{
				return "exertDeathStabbed";
			}
			case "hero_firefly_swarm":
			{
				return "exertDeathBurned";
			}
			case "hero_lightninggun_arc":
			{
				return "exertDeathElectrocuted";
			}
		}
	}
	return "exertDeath";
}

/*
	Name: play_killstreak_threat
	Namespace: battlechatter
	Checksum: 0xCFCC7CA8
	Offset: 0x3A40
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function play_killstreak_threat(killstreaktype)
{
	if(!isdefined(killstreaktype) || !isdefined(level.killstreaks[killstreaktype]))
	{
		return;
	}
	self thread play_dialog(level.killstreaks[killstreaktype].threatdialogkey, 1);
}

/*
	Name: wait_play_dialog
	Namespace: battlechatter
	Checksum: 0x40D0BC94
	Offset: 0x3AA8
	Size: 0x9C
	Parameters: 6
	Flags: Linked
*/
function wait_play_dialog(waittime, dialogkey, dialogflags, dialogbuffer, enemy, endnotify)
{
	self endon(#"death");
	level endon(#"game_ended");
	if(isdefined(waittime) && waittime > 0)
	{
		if(isdefined(endnotify))
		{
			self endon(endnotify);
		}
		wait(waittime);
	}
	self thread play_dialog(dialogkey, dialogflags, dialogbuffer, enemy);
}

/*
	Name: play_dialog
	Namespace: battlechatter
	Checksum: 0x3F7D6454
	Offset: 0x3B50
	Size: 0x2DC
	Parameters: 4
	Flags: Linked
*/
function play_dialog(dialogkey, dialogflags, dialogbuffer, enemy)
{
	self endon(#"death");
	level endon(#"game_ended");
	if(!isdefined(dialogkey) || !isplayer(self) || !isalive(self) || level.gameended)
	{
		return;
	}
	if(!isdefined(dialogflags))
	{
		dialogflags = 0;
	}
	if(!level.allowspecialistdialog && (dialogflags & 16) == 0)
	{
		return;
	}
	if(!isdefined(dialogbuffer))
	{
		dialogbuffer = mpdialog_value("playerDialogBuffer", 0);
	}
	dialogalias = self get_player_dialog_alias(dialogkey);
	if(!isdefined(dialogalias))
	{
		return;
	}
	if(self isplayerunderwater() && !dialogflags & 8)
	{
		return;
	}
	if(self.playingdialog)
	{
		if(!dialogflags & 4)
		{
			return;
		}
		self stopsounds();
		wait(0.05);
	}
	if(dialogflags & 32)
	{
		self.playinggadgetreadydialog = 1;
	}
	if(dialogflags & 64)
	{
		if(!isdefined(self.stolendialogindex))
		{
			self.stolendialogindex = 0;
		}
		dialogalias = (dialogalias + "_0") + self.stolendialogindex;
		self.stolendialogindex++;
		self.stolendialogindex = self.stolendialogindex % 4;
	}
	if(dialogflags & 2)
	{
		self playsoundontag(dialogalias, "J_Head");
	}
	else
	{
		if(dialogflags & 1)
		{
			if(isdefined(enemy))
			{
				self playsoundontag(dialogalias, "J_Head", self.team, enemy);
			}
			else
			{
				self playsoundontag(dialogalias, "J_Head", self.team);
			}
		}
		else
		{
			self playlocalsound(dialogalias);
		}
	}
	self notify(#"played_dialog");
	self thread wait_dialog_buffer(dialogbuffer);
}

/*
	Name: wait_dialog_buffer
	Namespace: battlechatter
	Checksum: 0xA876A7CE
	Offset: 0x3E38
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function wait_dialog_buffer(dialogbuffer)
{
	self endon(#"death");
	self endon(#"played_dialog");
	self endon(#"stop_dialog");
	level endon(#"game_ended");
	self.playingdialog = 1;
	if(isdefined(dialogbuffer) && dialogbuffer > 0)
	{
		wait(dialogbuffer);
	}
	self.playingdialog = 0;
	self.playinggadgetreadydialog = 0;
}

/*
	Name: stop_dialog
	Namespace: battlechatter
	Checksum: 0xB222CE59
	Offset: 0x3EC0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function stop_dialog()
{
	self notify(#"stop_dialog");
	self stopsounds();
	self.playingdialog = 0;
	self.playinggadgetreadydialog = 0;
}

/*
	Name: wait_playback_time
	Namespace: battlechatter
	Checksum: 0x5D0E1B41
	Offset: 0x3F08
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function wait_playback_time(soundalias)
{
}

/*
	Name: get_player_dialog_alias
	Namespace: battlechatter
	Checksum: 0x77AC6D9C
	Offset: 0x3F20
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function get_player_dialog_alias(dialogkey)
{
	if(!isplayer(self))
	{
		return undefined;
	}
	bundlename = self getmpdialogname();
	if(!isdefined(bundlename))
	{
		return undefined;
	}
	playerbundle = struct::get_script_bundle("mpdialog_player", bundlename);
	if(!isdefined(playerbundle))
	{
		return undefined;
	}
	return globallogic_audio::get_dialog_bundle_alias(playerbundle, dialogkey);
}

/*
	Name: count_keys
	Namespace: battlechatter
	Checksum: 0x4E2D63C7
	Offset: 0x3FD8
	Size: 0xFA
	Parameters: 2
	Flags: Linked
*/
function count_keys(bundle, dialogkey)
{
	i = 0;
	field = dialogkey + i;
	fieldvalue = getstructfield(bundle, field);
	while(isdefined(fieldvalue))
	{
		aliasarray[i] = fieldvalue;
		i++;
		field = dialogkey + i;
		fieldvalue = getstructfield(bundle, field);
	}
	if(!isdefined(bundle.keycounts))
	{
		bundle.keycounts = [];
	}
	bundle.keycounts[dialogkey] = i;
}

/*
	Name: get_random_key
	Namespace: battlechatter
	Checksum: 0xB131A971
	Offset: 0x40E0
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function get_random_key(dialogkey)
{
	bundlename = self getmpdialogname();
	if(!isdefined(bundlename))
	{
		return undefined;
	}
	playerbundle = struct::get_script_bundle("mpdialog_player", bundlename);
	if(!isdefined(playerbundle) || !isdefined(playerbundle.keycounts) || !isdefined(playerbundle.keycounts[dialogkey]))
	{
		return dialogkey;
	}
	return dialogkey + randomint(playerbundle.keycounts[dialogkey]);
}

/*
	Name: play_gadget_ready
	Namespace: battlechatter
	Checksum: 0xB1F3EBB9
	Offset: 0x41C0
	Size: 0x50C
	Parameters: 2
	Flags: Linked
*/
function play_gadget_ready(weapon, userflip = 0)
{
	if(!isdefined(weapon))
	{
		return;
	}
	dialogkey = undefined;
	switch(weapon.name)
	{
		case "hero_gravityspikes":
		{
			dialogkey = "gravspikesWeaponReady";
			break;
		}
		case "gadget_speed_burst":
		{
			dialogkey = "overdriveAbilityReady";
			break;
		}
		case "hero_bowlauncher":
		case "hero_bowlauncher2":
		case "hero_bowlauncher3":
		case "hero_bowlauncher4":
		{
			dialogkey = "sparrowWeaponReady";
			break;
		}
		case "gadget_vision_pulse":
		{
			dialogkey = "visionpulseAbilityReady";
			break;
		}
		case "hero_lightninggun":
		case "hero_lightninggun_arc":
		{
			dialogkey = "tempestWeaponReady";
			break;
		}
		case "gadget_flashback":
		{
			dialogkey = "glitchAbilityReady";
			break;
		}
		case "hero_pineapplegun":
		{
			dialogkey = "warmachineWeaponREady";
			break;
		}
		case "gadget_armor":
		{
			dialogkey = "kineticArmorAbilityReady";
			break;
		}
		case "hero_annihilator":
		{
			dialogkey = "annihilatorWeaponReady";
			break;
		}
		case "gadget_combat_efficiency":
		{
			dialogkey = "combatfocusAbilityReady";
			break;
		}
		case "hero_chemicalgelgun":
		{
			dialogkey = "hiveWeaponReady";
			break;
		}
		case "gadget_resurrect":
		{
			dialogkey = "rejackAbilityReady";
			break;
		}
		case "hero_minigun":
		case "hero_minigun_body3":
		{
			dialogkey = "scytheWeaponReady";
			break;
		}
		case "gadget_clone":
		{
			dialogkey = "psychosisAbilityReady";
			break;
		}
		case "hero_armblade":
		{
			dialogkey = "ripperWeaponReady";
			break;
		}
		case "gadget_camo":
		{
			dialogkey = "activeCamoAbilityReady";
			break;
		}
		case "hero_flamethrower":
		{
			dialogkey = "purifierWeaponReady";
			break;
		}
		case "gadget_heat_wave":
		{
			dialogkey = "heatwaveAbilityReady";
			break;
		}
		default:
		{
			return;
		}
	}
	if(!(isdefined(self.isthief) && self.isthief) && (!(isdefined(self.isroulette) && self.isroulette)))
	{
		self thread play_dialog(dialogkey);
		return;
	}
	waittime = 0;
	dialogflags = 32;
	if(userflip)
	{
		minwaittime = 0;
		if(self.playinggadgetreadydialog)
		{
			self stop_dialog();
			minwaittime = 0.05;
		}
		if(isdefined(self.isthief) && self.isthief)
		{
			delaykey = "thiefFlipDelay";
		}
		else
		{
			delaykey = "rouletteFlipDelay";
		}
		waittime = mpdialog_value(delaykey, minwaittime);
		dialogflags = dialogflags + 64;
	}
	else
	{
		if(isdefined(self.isthief) && self.isthief)
		{
			generickey = "thiefWeaponReady";
			repeatkey = "thiefWeaponRepeat";
			repeatthresholdkey = "thiefRepeatThreshold";
			chancekey = "thiefReadyChance";
			delaykey = "thiefRevealDelay";
		}
		else
		{
			generickey = "rouletteAbilityReady";
			repeatkey = "rouletteAbilityRepeat";
			repeatthresholdkey = "rouletteRepeatThreshold";
			chancekey = "rouletteReadyChance";
			delaykey = "rouletteRevealDelay";
		}
		if(randomint(100) < mpdialog_value(chancekey, 0))
		{
			dialogkey = generickey;
		}
		else
		{
			waittime = mpdialog_value(delaykey, 0);
			if(self.laststolengadget === weapon && (self.laststolengadgettime + (mpdialog_value(repeatthresholdkey, 0) * 1000)) > gettime())
			{
				dialogkey = repeatkey;
			}
			else
			{
				dialogflags = dialogflags + 64;
			}
		}
	}
	self.laststolengadget = weapon;
	self.laststolengadgettime = gettime();
	if(waittime)
	{
		self notify(#"cancel_kill_dialog");
	}
	self thread wait_play_dialog(waittime, dialogkey, dialogflags);
}

/*
	Name: play_gadget_activate
	Namespace: battlechatter
	Checksum: 0x49F2113D
	Offset: 0x46D8
	Size: 0x274
	Parameters: 1
	Flags: Linked
*/
function play_gadget_activate(weapon)
{
	if(!isdefined(weapon))
	{
		return;
	}
	dialogkey = undefined;
	switch(weapon.name)
	{
		case "hero_gravityspikes":
		{
			dialogkey = "gravspikesWeaponUse";
			dialogflags = 22;
			dialogbuffer = 0.05;
			break;
		}
		case "gadget_speed_burst":
		{
			dialogkey = "overdriveAbilityUse";
			break;
		}
		case "hero_bowlauncher":
		case "hero_bowlauncher2":
		case "hero_bowlauncher3":
		case "hero_bowlauncher4":
		{
			dialogkey = "sparrowWeaponUse";
			break;
		}
		case "gadget_vision_pulse":
		{
			dialogkey = "visionpulseAbilityUse";
			break;
		}
		case "hero_lightninggun":
		case "hero_lightninggun_arc":
		{
			dialogkey = "tempestWeaponUse";
			break;
		}
		case "gadget_flashback":
		{
			dialogkey = "glitchAbilityUse";
			break;
		}
		case "hero_pineapplegun":
		{
			dialogkey = "warmachineWeaponUse";
			break;
		}
		case "gadget_armor":
		{
			dialogkey = "kineticArmorAbilityUse";
			break;
		}
		case "hero_annihilator":
		{
			dialogkey = "annihilatorWeaponUse";
			break;
		}
		case "gadget_combat_efficiency":
		{
			dialogkey = "combatfocusAbilityUse";
			break;
		}
		case "hero_chemicalgelgun":
		{
			dialogkey = "hiveWeaponUse";
			break;
		}
		case "gadget_resurrect":
		{
			dialogkey = "rejackAbilityUse";
			break;
		}
		case "hero_minigun":
		case "hero_minigun_body3":
		{
			dialogkey = "scytheWeaponUse";
			break;
		}
		case "gadget_clone":
		{
			dialogkey = "psychosisAbilityUse";
			break;
		}
		case "hero_armblade":
		{
			dialogkey = "ripperWeaponUse";
			break;
		}
		case "gadget_camo":
		{
			dialogkey = "activeCamoAbilityUse";
			break;
		}
		case "hero_flamethrower":
		{
			dialogkey = "purifierWeaponUse";
			break;
		}
		case "gadget_heat_wave":
		{
			dialogkey = "heatwaveAbilityUse";
			break;
		}
		default:
		{
			return;
		}
	}
	self thread play_dialog(dialogkey, dialogflags, dialogbuffer);
}

/*
	Name: play_gadget_success
	Namespace: battlechatter
	Checksum: 0x33B26E8D
	Offset: 0x4958
	Size: 0x2AC
	Parameters: 3
	Flags: Linked
*/
function play_gadget_success(weapon, waitkey, victim)
{
	if(!isdefined(weapon))
	{
		return;
	}
	dialogkey = undefined;
	switch(weapon.name)
	{
		case "hero_gravityspikes":
		{
			dialogkey = "gravspikesWeaponSuccess";
			break;
		}
		case "gadget_speed_burst":
		{
			dialogkey = "overdriveAbilitySuccess";
			break;
		}
		case "hero_bowlauncher":
		case "hero_bowlauncher2":
		case "hero_bowlauncher3":
		case "hero_bowlauncher4":
		{
			dialogkey = "sparrowWeaponSuccess";
			break;
		}
		case "gadget_vision_pulse":
		{
			dialogkey = "visionpulseAbilitySuccess";
			break;
		}
		case "hero_lightninggun":
		case "hero_lightninggun_arc":
		{
			dialogkey = "tempestWeaponSuccess";
			break;
		}
		case "gadget_flashback":
		{
			dialogkey = "glitchAbilitySuccess";
			break;
		}
		case "hero_pineapplegun":
		{
			dialogkey = "warmachineWeaponSuccess";
			break;
		}
		case "gadget_armor":
		{
			dialogkey = "kineticArmorAbilitySuccess";
			break;
		}
		case "hero_annihilator":
		{
			dialogkey = "annihilatorWeaponSuccess";
			break;
		}
		case "gadget_combat_efficiency":
		{
			dialogkey = "combatfocusAbilitySuccess";
			break;
		}
		case "hero_chemicalgelgun":
		{
			dialogkey = "hiveWeaponSuccess";
			break;
		}
		case "gadget_resurrect":
		{
			dialogkey = "rejackAbilitySuccess";
			break;
		}
		case "hero_minigun":
		case "hero_minigun_body3":
		{
			dialogkey = "scytheWeaponSuccess";
			break;
		}
		case "gadget_clone":
		{
			dialogkey = "psychosisAbilitySuccess";
			break;
		}
		case "hero_armblade":
		{
			dialogkey = "ripperWeaponSuccess";
			break;
		}
		case "gadget_camo":
		{
			dialogkey = "activeCamoAbilitySuccess";
			break;
		}
		case "hero_flamethrower":
		{
			dialogkey = "purifierWeaponSuccess";
			break;
		}
		case "gadget_heat_wave":
		{
			dialogkey = "heatwaveAbilitySuccess";
			break;
		}
		default:
		{
			return;
		}
	}
	if(isdefined(waitkey))
	{
		waittime = mpdialog_value(waitkey, 0);
	}
	dialogkey = dialogkey + "0";
	self.playedgadgetsuccess = 1;
	self thread wait_play_dialog(waittime, dialogkey, 1, undefined, victim);
}

/*
	Name: play_throw_hatchet
	Namespace: battlechatter
	Checksum: 0x7AFAF9E6
	Offset: 0x4C10
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function play_throw_hatchet()
{
	self thread play_dialog("exertAxeThrow", 21, mpdialog_value("playerExertBuffer", 0));
}

/*
	Name: get_enemy_players
	Namespace: battlechatter
	Checksum: 0x6A98E8EE
	Offset: 0x4C60
	Size: 0x1BE
	Parameters: 0
	Flags: Linked
*/
function get_enemy_players()
{
	players = [];
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			if(team == self.team)
			{
				continue;
			}
			foreach(player in level.aliveplayers[team])
			{
				players[players.size] = player;
			}
		}
	}
	else
	{
		foreach(player in level.activeplayers)
		{
			if(player != self)
			{
				players[players.size] = player;
			}
		}
	}
	return players;
}

/*
	Name: get_friendly_players
	Namespace: battlechatter
	Checksum: 0xBEC860B1
	Offset: 0x4E28
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function get_friendly_players()
{
	players = [];
	if(level.teambased)
	{
		foreach(player in level.aliveplayers[self.team])
		{
			players[players.size] = player;
		}
	}
	else
	{
		players[0] = self;
	}
	return players;
}

/*
	Name: can_play_dialog
	Namespace: battlechatter
	Checksum: 0x9A57E6BF
	Offset: 0x4EF0
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function can_play_dialog(teamonly)
{
	if(!isplayer(self) || !isalive(self) || self.playingdialog === 1 || self isplayerunderwater() || self isremotecontrolling() || self isinvehicle() || self isweaponviewonlylinked())
	{
		return false;
	}
	if(isdefined(teamonly) && !teamonly && self hasperk("specialty_quieter"))
	{
		return false;
	}
	return true;
}

/*
	Name: get_closest_player_enemy
	Namespace: battlechatter
	Checksum: 0x89654807
	Offset: 0x4FE8
	Size: 0x108
	Parameters: 2
	Flags: Linked
*/
function get_closest_player_enemy(origin = self.origin, teamonly)
{
	players = self get_enemy_players();
	players = arraysort(players, origin);
	foreach(player in players)
	{
		if(!player can_play_dialog(teamonly))
		{
			continue;
		}
		return player;
	}
	return undefined;
}

/*
	Name: get_closest_player_ally
	Namespace: battlechatter
	Checksum: 0xA5CDEC1E
	Offset: 0x50F8
	Size: 0xFA
	Parameters: 1
	Flags: Linked
*/
function get_closest_player_ally(teamonly)
{
	if(!level.teambased)
	{
		return undefined;
	}
	players = self get_friendly_players();
	players = arraysort(players, self.origin);
	foreach(player in players)
	{
		if(player == self || !player can_play_dialog(teamonly))
		{
			continue;
		}
		return player;
	}
	return undefined;
}

/*
	Name: check_boost_start_conversation
	Namespace: battlechatter
	Checksum: 0x111C94B8
	Offset: 0x5200
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function check_boost_start_conversation()
{
	if(!level.playstartconversation)
	{
		return;
	}
	if(!level.inprematchperiod || !level.teambased || game["boostPlayersPicked"][self.team])
	{
		return;
	}
	players = self get_friendly_players();
	array::add(players, self, 0);
	players = array::randomize(players);
	playerindex = 1;
	foreach(player in players)
	{
		playerdialog = player getmpdialogname();
		for(i = playerindex; i < players.size; i++)
		{
			playeri = players[i];
			if(playerdialog != playeri getmpdialogname())
			{
				pick_boost_players(player, playeri);
				return;
			}
		}
		playerindex++;
	}
}

/*
	Name: pick_boost_players
	Namespace: battlechatter
	Checksum: 0xC83824DE
	Offset: 0x53D0
	Size: 0x76
	Parameters: 2
	Flags: Linked
*/
function pick_boost_players(player1, player2)
{
	player1 clientfield::set("play_boost", 1);
	player2 clientfield::set("play_boost", 2);
	game["boostPlayersPicked"][player1.team] = 1;
}

/*
	Name: game_end_vox
	Namespace: battlechatter
	Checksum: 0xB2749565
	Offset: 0x5450
	Size: 0x1BA
	Parameters: 1
	Flags: Linked
*/
function game_end_vox(winner)
{
	if(!level.allowspecialistdialog)
	{
		return;
	}
	gameisdraw = !isdefined(winner) || (level.teambased && winner == "tie");
	foreach(player in level.players)
	{
		if(player issplitscreen())
		{
			continue;
		}
		if(gameisdraw)
		{
			dialogkey = "boostDraw";
		}
		else
		{
			if(level.teambased && isdefined(level.teams[winner]) && player.pers["team"] == winner || (!level.teambased && player == winner))
			{
				dialogkey = "boostWin";
			}
			else
			{
				dialogkey = "boostLoss";
			}
		}
		dialogalias = player get_player_dialog_alias(dialogkey);
		if(isdefined(dialogalias))
		{
			player playlocalsound(dialogalias);
		}
	}
}

/*
	Name: devgui_think
	Namespace: battlechatter
	Checksum: 0x58DB8A52
	Offset: 0x5618
	Size: 0x380
	Parameters: 0
	Flags: Linked
*/
function devgui_think()
{
	/#
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		while(true)
		{
			wait(1);
			player = util::gethostplayer();
			if(!isdefined(player))
			{
				continue;
			}
			spacing = getdvarfloat("", 0.25);
			switch(getdvarstring("", ""))
			{
				case "":
				{
					player thread test_player_dialog(0);
					player thread test_taacom_dialog(spacing);
					player thread test_commander_dialog(2 * spacing);
					break;
				}
				case "":
				{
					player thread test_player_dialog(0);
					player thread test_commander_dialog(spacing);
					break;
				}
				case "":
				{
					player thread test_other_dialog(0);
					player thread test_commander_dialog(spacing);
					break;
				}
				case "":
				{
					player thread test_taacom_dialog(0);
					player thread test_commander_dialog(spacing);
					break;
				}
				case "":
				{
					player thread test_player_dialog(0);
					player thread test_taacom_dialog(spacing);
					break;
				}
				case "":
				{
					player thread test_other_dialog(0);
					player thread test_taacom_dialog(spacing);
					break;
				}
				case "":
				{
					player thread test_other_dialog(0);
					player thread test_player_dialog(spacing);
					break;
				}
				case "":
				{
					player thread play_conv_self_other();
					break;
				}
				case "":
				{
					player thread play_conv_other_self();
					break;
				}
				case "":
				{
					player thread play_conv_other_other();
					break;
				}
			}
			setdvar("", "");
		}
	#/
}

/*
	Name: test_other_dialog
	Namespace: battlechatter
	Checksum: 0xFA7736BB
	Offset: 0x59A0
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function test_other_dialog(delay)
{
	/#
		players = arraysort(level.players, self.origin);
		foreach(player in players)
		{
			if(player != self && isalive(player))
			{
				player thread test_player_dialog(delay);
				return;
			}
		}
	#/
}

/*
	Name: test_player_dialog
	Namespace: battlechatter
	Checksum: 0xEE7A2D00
	Offset: 0x5AA0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function test_player_dialog(delay)
{
	/#
		if(!isdefined(delay))
		{
			delay = 0;
		}
		wait(delay);
		self playsoundontag(getdvarstring("", ""), "");
	#/
}

/*
	Name: test_taacom_dialog
	Namespace: battlechatter
	Checksum: 0xC71652A6
	Offset: 0x5B10
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function test_taacom_dialog(delay)
{
	/#
		if(!isdefined(delay))
		{
			delay = 0;
		}
		wait(delay);
		self playlocalsound(getdvarstring("", ""));
	#/
}

/*
	Name: test_commander_dialog
	Namespace: battlechatter
	Checksum: 0x27832BAB
	Offset: 0x5B78
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function test_commander_dialog(delay)
{
	/#
		if(!isdefined(delay))
		{
			delay = 0;
		}
		wait(delay);
		self playlocalsound(getdvarstring("", ""));
	#/
}

/*
	Name: play_test_dialog
	Namespace: battlechatter
	Checksum: 0x2F8526D5
	Offset: 0x5BE0
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function play_test_dialog(dialogkey)
{
	/#
		dialogalias = self get_player_dialog_alias(dialogkey);
		self playsoundontag(dialogalias, "");
	#/
}

/*
	Name: response_key
	Namespace: battlechatter
	Checksum: 0x30B80B24
	Offset: 0x5C48
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function response_key()
{
	/#
		switch(self getmpdialogname())
		{
			case "":
			{
				return "";
			}
			case "":
			{
				return "";
			}
			case "":
			{
				return "";
			}
			case "":
			{
				return "";
			}
			case "":
			{
				return "";
			}
			case "":
			{
				return "";
			}
			case "":
			{
				return "";
			}
			case "":
			{
				return "";
			}
			case "":
			{
				return "";
			}
		}
		return "";
	#/
}

/*
	Name: play_conv_self_other
	Namespace: battlechatter
	Checksum: 0xBFD80586
	Offset: 0x5D18
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function play_conv_self_other()
{
	/#
		num = randomintrange(0, 4);
		self play_test_dialog("" + num);
		wait(4);
		players = arraysort(level.players, self.origin);
		foreach(player in players)
		{
			if(player != self && isalive(player))
			{
				player play_test_dialog(("" + self response_key()) + num);
				break;
			}
		}
	#/
}

/*
	Name: play_conv_other_self
	Namespace: battlechatter
	Checksum: 0x858D8965
	Offset: 0x5E78
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function play_conv_other_self()
{
	/#
		num = randomintrange(0, 4);
		players = arraysort(level.players, self.origin);
		foreach(player in players)
		{
			if(player != self && isalive(player))
			{
				player play_test_dialog("" + num);
				break;
			}
		}
		wait(4);
		self play_test_dialog(("" + player response_key()) + num);
	#/
}

/*
	Name: play_conv_other_other
	Namespace: battlechatter
	Checksum: 0x6F286298
	Offset: 0x5FE0
	Size: 0x206
	Parameters: 0
	Flags: Linked
*/
function play_conv_other_other()
{
	/#
		num = randomintrange(0, 4);
		players = arraysort(level.players, self.origin);
		foreach(player in players)
		{
			if(player != self && isalive(player))
			{
				player play_test_dialog("" + num);
				firstplayer = player;
				break;
			}
		}
		wait(4);
		foreach(player in players)
		{
			if(player != self && player !== firstplayer && isalive(player))
			{
				player play_test_dialog(("" + firstplayer response_key()) + num);
				break;
			}
		}
	#/
}

