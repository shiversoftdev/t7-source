// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\_wager;
#using scripts\shared\array_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\weapons\_weapon_utils;

#namespace shrp;

/*
	Name: main
	Namespace: shrp
	Checksum: 0x4AF9D642
	Offset: 0x7D8
	Size: 0x364
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	level.pointsperweaponkill = getgametypesetting("pointsPerWeaponKill");
	level.pointspermeleekill = getgametypesetting("pointsPerMeleeKill");
	level.shrpweapontimer = getgametypesetting("weaponTimer");
	level.shrpweaponnumber = getgametypesetting("weaponCount");
	util::registertimelimit((level.shrpweaponnumber * level.shrpweapontimer) / 60, (level.shrpweaponnumber * level.shrpweapontimer) / 60);
	util::registerscorelimit(0, 50000);
	util::registerroundlimit(0, 10);
	util::registerroundwinlimit(0, 10);
	util::registernumlives(0, 100);
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &onspawnplayer;
	level.onplayerkilled = &onplayerkilled;
	level.onwagerawards = &onwagerawards;
	gameobjects::register_allowed_gameobject(level.gametype);
	level.givecustomloadout = &givecustomloadout;
	game["dialog"]["gametype"] = "ss_start";
	game["dialog"]["wm_weapons_cycled"] = "ssharp_cycle_01";
	game["dialog"]["wm_final_weapon"] = "ssharp_fweapon";
	game["dialog"]["wm_bonus_rnd"] = "ssharp_2multi_00";
	game["dialog"]["wm_shrp_rnd"] = "ssharp_sround";
	game["dialog"]["wm_bonus0"] = "boost_gen_05";
	game["dialog"]["wm_bonus1"] = "boost_gen_05";
	game["dialog"]["wm_bonus2"] = "boost_gen_05";
	game["dialog"]["wm_bonus3"] = "boost_gen_05";
	game["dialog"]["wm_bonus4"] = "boost_gen_05";
	game["dialog"]["wm_bonus5"] = "boost_gen_05";
	globallogic::setvisiblescoreboardcolumns("pointstowin", "kills", "deaths", "stabs", "x2score");
}

/*
	Name: onstartgametype
	Namespace: shrp
	Checksum: 0xD3DCE8C4
	Offset: 0xB48
	Size: 0x544
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
	setdvar("scr_disable_weapondrop", 1);
	setdvar("scr_xpscalemp", 0);
	setdvar("ui_guncycle", 0);
	setclientnamemode("auto_change");
	util::setobjectivetext("allies", &"OBJECTIVES_SHRP");
	util::setobjectivetext("axis", &"OBJECTIVES_SHRP");
	attach_compatibility_init();
	if(level.splitscreen)
	{
		util::setobjectivescoretext("allies", &"OBJECTIVES_SHRP");
		util::setobjectivescoretext("axis", &"OBJECTIVES_SHRP");
	}
	else
	{
		util::setobjectivescoretext("allies", &"OBJECTIVES_SHRP_SCORE");
		util::setobjectivescoretext("axis", &"OBJECTIVES_SHRP_SCORE");
	}
	util::setobjectivehinttext("allies", &"OBJECTIVES_SHRP_HINT");
	util::setobjectivehinttext("axis", &"OBJECTIVES_SHRP_HINT");
	spawning::create_map_placed_influencers();
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	newspawns = getentarray("mp_wager_spawn", "classname");
	if(newspawns.size > 0)
	{
		spawnlogic::add_spawn_points("allies", "mp_wager_spawn");
		spawnlogic::add_spawn_points("axis", "mp_wager_spawn");
	}
	else
	{
		spawnlogic::add_spawn_points("allies", "mp_dm_spawn");
		spawnlogic::add_spawn_points("axis", "mp_dm_spawn");
	}
	spawning::updateallspawnpoints();
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level.usestartspawns = 0;
	wager::add_powerup("specialty_bulletflinch", "perk", &"PERKS_TOUGHNESS", "perk_warrior");
	wager::add_powerup("specialty_movefaster", "perk", &"PERKS_LIGHTWEIGHT", "perk_lightweight");
	wager::add_powerup("specialty_fallheight", "perk", &"PERKS_LIGHTWEIGHT", "perk_lightweight");
	wager::add_powerup("specialty_longersprint", "perk", &"PERKS_EXTREME_CONDITIONING", "perk_marathon");
	wager::add_powerup(2, "score_multiplier", &"PERKS_SCORE_MULTIPLIER", "perk_times_two");
	level.guncycletimer = hud::createservertimer("extrasmall", 1.2);
	level.guncycletimer.horzalign = "user_left";
	level.guncycletimer.vertalign = "user_top";
	level.guncycletimer.x = 10;
	level.guncycletimer.y = 123;
	level.guncycletimer.alignx = "left";
	level.guncycletimer.aligny = "top";
	level.guncycletimer.label = &"MP_SHRP_COUNTDOWN";
	level.guncycletimer.alpha = 0;
	level.guncycletimer.hidewheninkillcam = 1;
	level.displayroundendtext = 0;
	level.quickmessagetoall = 1;
	level thread chooserandomguns();
	level thread clearpowerupsongameend();
}

/*
	Name: attach_compatibility_init
	Namespace: shrp
	Checksum: 0xF1A8A97
	Offset: 0x1098
	Size: 0x11C
	Parameters: 0
	Flags: None
*/
function attach_compatibility_init()
{
	level.attach_compatible = [];
	set_attachtable_id();
	for(i = 0; i < 33; i++)
	{
		itemrow = tablelookuprownum(level.attachtableid, 9, i);
		if(itemrow > -1)
		{
			name = tablelookupcolumnforrow(level.attachtableid, itemrow, 4);
			level.attach_compatible[name] = [];
			compatible = tablelookupcolumnforrow(level.attachtableid, itemrow, 11);
			level.attach_compatible[name] = strtok(compatible, " ");
		}
	}
}

/*
	Name: set_attachtable_id
	Namespace: shrp
	Checksum: 0x760CE2D3
	Offset: 0x11C0
	Size: 0x20
	Parameters: 0
	Flags: None
*/
function set_attachtable_id()
{
	if(!isdefined(level.attachtableid))
	{
		level.attachtableid = "gamedata/weapons/common/attachmentTable.csv";
	}
}

/*
	Name: getrandomweaponnamefromprogression
	Namespace: shrp
	Checksum: 0xA8F29246
	Offset: 0x11E8
	Size: 0x4D0
	Parameters: 0
	Flags: None
*/
function getrandomweaponnamefromprogression()
{
	weaponidkeys = getarraykeys(level.tbl_weaponids);
	numweaponidkeys = weaponidkeys.size;
	gunprogressionsize = 0;
	if(isdefined(level.gunprogression))
	{
		size = level.gunprogression.size;
	}
	/#
		debug_weapon = getdvarstring("");
	#/
	allowproneblock = 1;
	players = getplayers();
	foreach(player in players)
	{
		if(player getstance() == "prone")
		{
			allowproneblock = 0;
			break;
		}
	}
	if(1)
	{
		for(;;)
		{
			randomindex = randomint(numweaponidkeys + gunprogressionsize);
			baseweaponname = "";
			weaponname = "";
			id = array::random(level.tbl_weaponids);
		}
		for(;;)
		{
		}
		for(;;)
		{
			baseweaponname = id["reference"];
			attachmentlist = id["attachment"];
			baseweaponname = "m32_wager";
			baseweaponname = "minigun_wager";
		}
		for(;;)
		{
			weaponname = addrandomattachmenttoweaponname(baseweaponname, attachmentlist);
			weapon = getweapon(weaponname);
		}
		for(;;)
		{
			baseweaponname = level.gunprogression[randomindex - numweaponidkeys].names[0];
			weaponname = level.gunprogression[randomindex - numweaponidkeys].names[0];
			level.usedbaseweapons = [];
			level.usedbaseweapons[0] = "fhj18";
			skipweapon = 0;
			skipweapon = 1;
			break;
		}
		if(randomindex < numweaponidkeys)
		{
			if(id["group"] != "weapon_launcher" && id["group"] != "weapon_sniper" && id["group"] != "weapon_lmg" && id["group"] != "weapon_assault" && id["group"] != "weapon_smg" && id["group"] != "weapon_pistol" && id["group"] != "weapon_cqb" && id["group"] != "weapon_special")
			{
			}
			if(id["reference"] == "weapon_null")
			{
			}
			if(baseweaponname == "m32")
			{
			}
			if(baseweaponname == "minigun")
			{
			}
			if(baseweaponname == "riotshield")
			{
			}
			if(!allowproneblock && weapon.blocksprone)
			{
			}
		}
		else
		{
		}
		if(!isdefined(level.usedbaseweapons))
		{
		}
		for(i = 0; i < level.usedbaseweapons.size; i++)
		{
			if(level.usedbaseweapons[i] == baseweaponname)
			{
			}
		}
		if(skipweapon)
		{
		}
		level.usedbaseweapons[level.usedbaseweapons.size] = baseweaponname;
		/#
			if(debug_weapon != "")
			{
				weaponname = debug_weapon;
			}
		#/
		return weaponname;
	}
}

/*
	Name: addrandomattachmenttoweaponname
	Namespace: shrp
	Checksum: 0x7110333C
	Offset: 0x16C0
	Size: 0x236
	Parameters: 2
	Flags: None
*/
function addrandomattachmenttoweaponname(baseweaponname, attachmentlist)
{
	if(!isdefined(attachmentlist))
	{
		return baseweaponname;
	}
	attachments = strtok(attachmentlist, " ");
	arrayremovevalue(attachments, "dw");
	if(attachments.size <= 0)
	{
		return baseweaponname;
	}
	attachments[attachments.size] = "";
	attachment = array::random(attachments);
	if(attachment == "")
	{
		return baseweaponname;
	}
	if(issubstr(attachment, "_"))
	{
		attachment = strtok(attachment, "_")[0];
	}
	if(isdefined(level.attach_compatible[attachment]) && level.attach_compatible[attachment].size > 0)
	{
		attachment2 = level.attach_compatible[attachment][randomint(level.attach_compatible[attachment].size)];
		contains = 0;
		for(i = 0; i < attachments.size; i++)
		{
			if(isdefined(attachment2) && attachments[i] == attachment2)
			{
				contains = 1;
				break;
			}
		}
		if(contains)
		{
			if(attachment < attachment2)
			{
				return (baseweaponname + attachment) + ("+") + attachment2;
			}
			return (baseweaponname + attachment2) + ("+") + attachment;
		}
	}
	return baseweaponname + attachment;
}

/*
	Name: waitlongdurationwithhostmigrationpause
	Namespace: shrp
	Checksum: 0x80682FCF
	Offset: 0x1900
	Size: 0x178
	Parameters: 2
	Flags: None
*/
function waitlongdurationwithhostmigrationpause(nextguncycletime, duration)
{
	endtime = gettime() + (duration * 1000);
	totaltimepassed = 0;
	while(gettime() < endtime)
	{
		hostmigration::waittillhostmigrationstarts((endtime - gettime()) / 1000);
		if(isdefined(level.hostmigrationtimer))
		{
			setdvar("ui_guncycle", 0);
			timepassed = hostmigration::waittillhostmigrationdone();
			totaltimepassed = totaltimepassed + timepassed;
			endtime = endtime + timepassed;
			/#
				println("" + timepassed);
				println("" + totaltimepassed);
				println("" + level.discardtime);
			#/
			setdvar("ui_guncycle", nextguncycletime + totaltimepassed);
		}
	}
	hostmigration::waittillhostmigrationdone();
	return totaltimepassed;
}

/*
	Name: guncyclewaiter
	Namespace: shrp
	Checksum: 0x75B5BB3E
	Offset: 0x1A80
	Size: 0x282
	Parameters: 2
	Flags: None
*/
function guncyclewaiter(nextguncycletime, waittime)
{
	continuecycling = 1;
	setdvar("ui_guncycle", nextguncycletime);
	level.guncycletimer settimer(waittime);
	level.guncycletimer.alpha = 1;
	timepassed = waitlongdurationwithhostmigrationpause(nextguncycletime, ((nextguncycletime - gettime()) / 1000) - 6);
	nextguncycletime = nextguncycletime + timepassed;
	for(i = 6; i > 1; i--)
	{
		for(j = 0; j < level.players.size; j++)
		{
			level.players[j] playlocalsound("uin_timer_wager_beep");
		}
		timepassed = waitlongdurationwithhostmigrationpause(nextguncycletime, ((nextguncycletime - gettime()) / 1000) / i);
		nextguncycletime = nextguncycletime + timepassed;
	}
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] playlocalsound("uin_timer_wager_last_beep");
	}
	if((nextguncycletime - gettime()) > 0)
	{
		wait((nextguncycletime - gettime()) / 1000);
	}
	level.shrprandomweapon = getweapon(getrandomweaponnamefromprogression());
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] notify(#"remove_planted_weapons");
		level.players[i] givecustomloadout(0, 1);
	}
	return continuecycling;
}

/*
	Name: chooserandomguns
	Namespace: shrp
	Checksum: 0x7930D3F9
	Offset: 0x1D10
	Size: 0x39E
	Parameters: 0
	Flags: None
*/
function chooserandomguns()
{
	level endon(#"game_ended");
	level thread awardmostpointsmedalgameend();
	waittime = level.shrpweapontimer;
	lightningwaittime = 15;
	level.shrprandomweapon = getweapon(getrandomweaponnamefromprogression());
	if(level.inprematchperiod)
	{
		level waittill(#"prematch_over");
	}
	guncycle = 1;
	numguncycles = int(((level.timelimit * 60) / waittime) + 0.5);
	while(true)
	{
		nextguncycletime = gettime() + (waittime * 1000);
		ispenultimateround = 0;
		issharpshooterround = guncycle == (numguncycles - 1);
		for(i = 0; i < level.players.size; i++)
		{
			level.players[i].currentguncyclepoints = 0;
		}
		level.currentguncyclemaxpoints = 0;
		guncyclewaiter(nextguncycletime, waittime);
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if((guncycle + 1) == numguncycles)
			{
				player wager::announcer("wm_final_weapon");
			}
			else
			{
				player wager::announcer("wm_weapons_cycled");
			}
			player checkawardmostpointsthiscycle();
		}
		if(ispenultimateround)
		{
			level.sharpshootermultiplier = 2;
			for(i = 0; i < level.players.size; i++)
			{
				level.players[i] thread wager::queue_popup(&"MP_SHRP_PENULTIMATE_RND", 0, &"MP_SHRP_PENULTIMATE_MULTIPLIER", "wm_bonus_rnd");
			}
		}
		else
		{
			if(issharpshooterround)
			{
				lastmultiplier = level.sharpshootermultiplier;
				if(!isdefined(lastmultiplier))
				{
					lastmultiplier = 1;
				}
				level.sharpshootermultiplier = 2;
				setdvar("ui_guncycle", 0);
				level.guncycletimer.alpha = 0;
				for(i = 0; i < level.players.size; i++)
				{
					level.players[i] thread wager::queue_popup(&"MP_SHRP_RND", 0, &"MP_SHRP_FINAL_MULTIPLIER", "wm_shrp_rnd");
				}
				break;
			}
			else
			{
				level.sharpshootermultiplier = 1;
			}
		}
		guncycle++;
	}
}

/*
	Name: checkawardmostpointsthiscycle
	Namespace: shrp
	Checksum: 0xF6C8D979
	Offset: 0x20B8
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function checkawardmostpointsthiscycle()
{
	if(isdefined(self.currentguncyclepoints) && self.currentguncyclepoints > 0)
	{
		if(self.currentguncyclepoints == level.currentguncyclemaxpoints)
		{
			scoreevents::processscoreevent("most_points_shrp", self);
		}
	}
}

/*
	Name: awardmostpointsmedalgameend
	Namespace: shrp
	Checksum: 0x95555E9
	Offset: 0x2110
	Size: 0x5E
	Parameters: 0
	Flags: None
*/
function awardmostpointsmedalgameend()
{
	level waittill(#"game_end");
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] checkawardmostpointsthiscycle();
	}
}

/*
	Name: givecustomloadout
	Namespace: shrp
	Checksum: 0x481540E9
	Offset: 0x2178
	Size: 0x15A
	Parameters: 2
	Flags: None
*/
function givecustomloadout(takeallweapons, alreadyspawned)
{
	chooserandombody = 0;
	if(!isdefined(alreadyspawned) || !alreadyspawned)
	{
		chooserandombody = 1;
	}
	self wager::setup_blank_random_player(takeallweapons, chooserandombody, level.shrprandomweapon);
	self disableweaponcycling();
	self giveweapon(level.shrprandomweapon);
	self switchtoweapon(level.shrprandomweapon);
	self giveweapon(level.weaponbasemelee);
	if(!isdefined(alreadyspawned) || !alreadyspawned)
	{
		self setspawnweapon(level.shrprandomweapon);
	}
	if(isdefined(takeallweapons) && !takeallweapons)
	{
		self thread takeoldweapons();
	}
	else
	{
		self enableweaponcycling();
	}
	return level.shrprandomweapon;
}

/*
	Name: takeoldweapons
	Namespace: shrp
	Checksum: 0x3115F02A
	Offset: 0x22E0
	Size: 0xFC
	Parameters: 0
	Flags: None
*/
function takeoldweapons()
{
	self endon(#"disconnect");
	self endon(#"death");
	for(;;)
	{
		self waittill(#"weapon_change", newweapon);
		if(newweapon != level.weaponnone)
		{
			break;
		}
	}
	weaponslist = self getweaponslist();
	for(i = 0; i < weaponslist.size; i++)
	{
		if(weaponslist[i] != level.shrprandomweapon && weaponslist[i] != level.weaponbasemelee)
		{
			self takeweapon(weaponslist[i]);
		}
	}
	self enableweaponcycling();
}

/*
	Name: onplayerkilled
	Namespace: shrp
	Checksum: 0xE0E8EF74
	Offset: 0x23E8
	Size: 0x664
	Parameters: 9
	Flags: None
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(isdefined(attacker) && isplayer(attacker) && attacker != self)
	{
		if(isdefined(level.sharpshootermultiplier) && level.sharpshootermultiplier == 2)
		{
			if(!isdefined(attacker.pers["x2kills"]))
			{
				attacker.pers["x2kills"] = 1;
			}
			else
			{
				attacker.pers["x2kills"]++;
			}
			attacker.x2kills = attacker.pers["x2kills"];
		}
		else if(isdefined(level.sharpshootermultiplier) && level.sharpshootermultiplier == 3)
		{
			if(!isdefined(attacker.pers["x3kills"]))
			{
				attacker.pers["x3kills"] = 1;
			}
			else
			{
				attacker.pers["x3kills"]++;
			}
			attacker.x2kills = attacker.pers["x3kills"];
		}
		if(isdefined(self.scoremultiplier) && self.scoremultiplier >= 2)
		{
			scoreevents::processscoreevent("kill_x2_score_shrp", attacker, self, weapon);
		}
		currentbonus = attacker.currentbonus;
		if(!isdefined(currentbonus))
		{
			currentbonus = 0;
		}
		if(currentbonus < level.poweruplist.size)
		{
			attacker wager::give_powerup(level.poweruplist[currentbonus]);
			attacker thread wager::announcer("wm_bonus" + currentbonus);
			if(level.poweruplist[currentbonus].type == "score_multiplier" && attacker.scoremultiplier == 2)
			{
				scoreevents::processscoreevent("x2_score_shrp", attacker, self, weapon);
			}
			currentbonus++;
			attacker.currentbonus = currentbonus;
		}
		if(currentbonus >= level.poweruplist.size)
		{
			if(isdefined(attacker.powerups) && isdefined(attacker.powerups.size) && attacker.powerups.size > 0)
			{
				attacker thread wager::pulse_powerup_icon(attacker.powerups.size - 1);
			}
		}
		scoremultiplier = 1;
		if(isdefined(attacker.scoremultiplier))
		{
			scoremultiplier = attacker.scoremultiplier;
		}
		if(isdefined(level.sharpshootermultiplier))
		{
			scoremultiplier = scoremultiplier * level.sharpshootermultiplier;
		}
		scoreincrease = attacker.pointstowin;
		for(i = 1; i <= scoremultiplier; i++)
		{
			if(weapon_utils::ismeleemod(smeansofdeath) && level.shrprandomweapon != level.weaponbasemelee && level.shrprandomweapon.isriotshield)
			{
				attacker globallogic_score::givepointstowin(level.pointspermeleekill);
				if(i != 1)
				{
					scoreevents::processscoreevent("kill", attacker, self, weapon);
					scoreevents::processscoreevent("wager_melee_kill", attacker, self, weapon);
				}
				continue;
			}
			attacker globallogic_score::givepointstowin(level.pointsperweaponkill);
			if(!isdefined(attacker.currentguncyclepoints))
			{
				attacker.currentguncyclepoints = 0;
			}
			attacker.currentguncyclepoints = attacker.currentguncyclepoints + level.pointsperweaponkill;
			if(level.currentguncyclemaxpoints < attacker.currentguncyclepoints)
			{
				level.currentguncyclemaxpoints = attacker.currentguncyclepoints;
			}
			if(i != 1)
			{
				scoreevents::processscoreevent("kill", attacker, self, weapon);
			}
		}
		scoreincrease = attacker.pointstowin - scoreincrease;
		if(scoremultiplier > 1 || (isdefined(level.sharpshootermultiplier) && level.sharpshootermultiplier > 1))
		{
			attacker playlocalsound("uin_alert_cash_register");
			attacker.pers["x2score"] = attacker.pers["x2score"] + scoreincrease;
			attacker.x2score = attacker.pers["x2score"];
		}
	}
	self.currentbonus = 0;
	self.scoremultiplier = 1;
	self wager::clear_powerups();
}

/*
	Name: onspawnplayer
	Namespace: shrp
	Checksum: 0xA091F3C7
	Offset: 0x2A58
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function onspawnplayer(predictedspawn)
{
	spawning::onspawnplayer(predictedspawn);
	self thread infiniteammo();
}

/*
	Name: infiniteammo
	Namespace: shrp
	Checksum: 0xDD0A90E9
	Offset: 0x2AA0
	Size: 0x68
	Parameters: 0
	Flags: None
*/
function infiniteammo()
{
	self endon(#"death");
	self endon(#"disconnect");
	for(;;)
	{
		wait(0.1);
		weapon = self getcurrentweapon();
		self givemaxammo(weapon);
	}
}

/*
	Name: onwagerawards
	Namespace: shrp
	Checksum: 0x3300C120
	Offset: 0x2B10
	Size: 0x124
	Parameters: 0
	Flags: None
*/
function onwagerawards()
{
	x2kills = self globallogic_score::getpersstat("x2kills");
	if(!isdefined(x2kills))
	{
		x2kills = 0;
	}
	self persistence::set_after_action_report_stat("wagerAwards", x2kills, 0);
	headshots = self globallogic_score::getpersstat("headshots");
	if(!isdefined(headshots))
	{
		headshots = 0;
	}
	self persistence::set_after_action_report_stat("wagerAwards", headshots, 1);
	bestkillstreak = self globallogic_score::getpersstat("best_kill_streak");
	if(!isdefined(bestkillstreak))
	{
		bestkillstreak = 0;
	}
	self persistence::set_after_action_report_stat("wagerAwards", bestkillstreak, 2);
}

/*
	Name: clearpowerupsongameend
	Namespace: shrp
	Checksum: 0x50307E0A
	Offset: 0x2C40
	Size: 0x6E
	Parameters: 0
	Flags: None
*/
function clearpowerupsongameend()
{
	level waittill(#"game_ended");
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		player wager::clear_powerups();
	}
}

