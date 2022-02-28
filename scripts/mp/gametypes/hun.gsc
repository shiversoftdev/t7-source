// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\killstreaks\_supplydrop;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace hun;

/*
	Name: main
	Namespace: hun
	Checksum: 0x1F06CBE9
	Offset: 0x378
	Size: 0x1EC
	Parameters: 0
	Flags: None
*/
function main()
{
	globallogic::init();
	util::registertimelimit(0, 1440);
	util::registerscorelimit(0, 50000);
	util::registerroundlimit(0, 10);
	util::registerroundwinlimit(0, 10);
	util::registernumlives(0, 100);
	globallogic::registerfriendlyfiredelay(level.gametype, 0, 0, 1440);
	level.scoreroundwinbased = 1;
	level.resetplayerscoreeveryround = 1;
	level.onstartgametype = &onstartgametype;
	level.givecustomloadout = &givecustomloadout;
	level.helitime = getgametypesetting("objectiveSpawnTime");
	gameobjects::register_allowed_gameobject("dm");
	game["dialog"]["gametype"] = "ffa_start";
	game["dialog"]["gametype_hardcore"] = "hcffa_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	globallogic::setvisiblescoreboardcolumns("score", "kills", "deaths", "kdratio", "headshots");
}

/*
	Name: onstartgametype
	Namespace: hun
	Checksum: 0xDFB1D3F4
	Offset: 0x570
	Size: 0x2D4
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
	setclientnamemode("auto_change");
	util::setobjectivetext("allies", &"OBJECTIVES_DM");
	util::setobjectivetext("axis", &"OBJECTIVES_DM");
	if(level.splitscreen)
	{
		util::setobjectivescoretext("allies", &"OBJECTIVES_DM");
		util::setobjectivescoretext("axis", &"OBJECTIVES_DM");
	}
	else
	{
		util::setobjectivescoretext("allies", &"OBJECTIVES_DM_SCORE");
		util::setobjectivescoretext("axis", &"OBJECTIVES_DM_SCORE");
	}
	util::setobjectivehinttext("allies", &"OBJECTIVES_DM_HINT");
	util::setobjectivehinttext("axis", &"OBJECTIVES_DM_HINT");
	spawning::create_map_placed_influencers();
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	spawnlogic::add_spawn_points("allies", "mp_dm_spawn");
	spawnlogic::add_spawn_points("axis", "mp_dm_spawn");
	spawning::updateallspawnpoints();
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level.usestartspawns = 0;
	level.displayroundendtext = 0;
	level thread onscoreclosemusic();
	if(!util::isoneround())
	{
		level.displayroundendtext = 1;
	}
	level.heliowner = spawn("script_origin", (0, 0, 0));
	initdroplocations();
	registercrates();
	thread cratedropper();
}

/*
	Name: onendgame
	Namespace: hun
	Checksum: 0xE39E3D58
	Offset: 0x850
	Size: 0x58
	Parameters: 1
	Flags: None
*/
function onendgame(winningplayer)
{
	if(isdefined(winningplayer) && isplayer(winningplayer))
	{
		[[level._setplayerscore]](winningplayer, winningplayer [[level._getplayerscore]]() + 1);
	}
}

/*
	Name: givecustomloadout
	Namespace: hun
	Checksum: 0x754DA67C
	Offset: 0x8B0
	Size: 0x170
	Parameters: 0
	Flags: None
*/
function givecustomloadout()
{
	self takeallweapons();
	self clearperks();
	weapon = getweapon("pistol_standard");
	self.primaryweapon = weapon;
	self.lethalgrenade = getweapon("hatchet");
	self.tacticalgrenade = undefined;
	self giveweapon(weapon);
	self giveweapon(level.weaponbasemelee);
	self giveweapon(level.weaponbasemeleeheld);
	self giveweapon(self.lethalgrenade);
	self setweaponammostock(weapon, 0);
	self setweaponammoclip(weapon, 5);
	self switchtoweapon(weapon);
	self setspawnweapon(weapon);
	return weapon;
}

/*
	Name: onscoreclosemusic
	Namespace: hun
	Checksum: 0xDCA4E648
	Offset: 0xA28
	Size: 0xC4
	Parameters: 0
	Flags: None
*/
function onscoreclosemusic()
{
	while(!level.gameended)
	{
		scorelimit = level.scorelimit;
		scorethreshold = scorelimit * 0.9;
		for(i = 0; i < level.players.size; i++)
		{
			scorecheck = [[level._getplayerscore]](level.players[i]);
			if(scorecheck >= scorethreshold)
			{
				thread globallogic_audio::set_music_on_team("timeOut");
				return;
			}
		}
		wait(0.5);
	}
}

/*
	Name: inside_bounds
	Namespace: hun
	Checksum: 0xE9A4746B
	Offset: 0xAF8
	Size: 0xBE
	Parameters: 2
	Flags: None
*/
function inside_bounds(node_origin, bounds)
{
	mins = level.mapcenter - bounds;
	maxs = level.mapcenter + bounds;
	if(node_origin[0] > maxs[0])
	{
		return false;
	}
	if(node_origin[0] < mins[0])
	{
		return false;
	}
	if(node_origin[1] > maxs[1])
	{
		return false;
	}
	if(node_origin[1] < mins[1])
	{
		return false;
	}
	return true;
}

/*
	Name: initdroplocations
	Namespace: hun
	Checksum: 0x20ACFCDE
	Offset: 0xBC0
	Size: 0x130
	Parameters: 0
	Flags: None
*/
function initdroplocations()
{
	scalar = 0.8;
	bound = (level.spawnmaxs - level.mapcenter) * scalar;
	possible_nodes = getallnodes();
	nodes = [];
	count = 0;
	foreach(node in possible_nodes)
	{
		if(inside_bounds(node.origin, bound))
		{
			nodes[nodes.size] = node;
			count++;
		}
	}
	level.dropnodes = nodes;
}

/*
	Name: registercrates
	Namespace: hun
	Checksum: 0x4D6A14E1
	Offset: 0xCF8
	Size: 0x1FC
	Parameters: 0
	Flags: None
*/
function registercrates()
{
	supplydrop::registercratetype("hunted", "weapon", "smg_standard", 1, &"WEAPON_SMG_STANDARD", undefined, &givehuntedweapon, &huntedcratelandoverride);
	supplydrop::registercratetype("hunted", "weapon", "ar_standard", 1, &"WEAPON_AR_STANDARD", undefined, &givehuntedweapon, &huntedcratelandoverride);
	supplydrop::registercratetype("hunted", "weapon", "lmg_light", 1, &"WEAPON_LMG_LIGHT", undefined, &givehuntedweapon, &huntedcratelandoverride);
	supplydrop::registercratetype("hunted", "weapon", "shotgun_pump", 1, &"WEAPON_SHOTGUN_PUMP", undefined, &givehuntedweapon, &huntedcratelandoverride);
	supplydrop::registercratetype("hunted", "weapon", "pistol_standard", 1, &"WEAPON_PISTOL_STANDARD", undefined, &givehuntedweapon, &huntedcratelandoverride);
	supplydrop::setcategorytypeweight("hunted", "weapon", 4);
	supplydrop::setcategorytypeweight("hunted", "killstreak", 1);
	supplydrop::advancedfinalizecratecategory("hunted");
}

/*
	Name: givehuntedweapon
	Namespace: hun
	Checksum: 0x3A7A4894
	Offset: 0xF00
	Size: 0x8C
	Parameters: 1
	Flags: None
*/
function givehuntedweapon(weapon)
{
	if(isdefined(self.primaryweapon))
	{
		self takeweapon(self.primaryweapon);
	}
	self.primaryweapon = weapon;
	self giveweapon(weapon);
	self switchtoweapon(weapon);
	self setweaponammostock(weapon, 0);
}

/*
	Name: givehuntedlethalgrenade
	Namespace: hun
	Checksum: 0x183CCDEE
	Offset: 0xF98
	Size: 0xD4
	Parameters: 1
	Flags: None
*/
function givehuntedlethalgrenade(weapon)
{
	if(self.lethalgrenade == weapon)
	{
		currstock = self getammocount(weapon);
		self setweaponammostock(weapon, currstock + 1);
		return;
	}
	if(isdefined(self.lethalgrenade))
	{
		self takeweapon(self.lethalgrenade);
	}
	self.lethalgrenade = weapon;
	self giveweapon(weapon);
	self setoffhandprimaryclass(weapon);
}

/*
	Name: givehuntedtacticalgrenade
	Namespace: hun
	Checksum: 0xB047CB45
	Offset: 0x1078
	Size: 0xD4
	Parameters: 1
	Flags: None
*/
function givehuntedtacticalgrenade(weapon)
{
	if(self.tacticalgrenade == weapon)
	{
		currstock = self getammocount(weapon);
		self setweaponammostock(weapon, currstock + 1);
		return;
	}
	if(isdefined(self.tacticalgrenade))
	{
		self takeweapon(self.tacticalgrenade);
	}
	self.tacticalgrenade = weapon;
	self giveweapon(weapon);
	self setoffhandsecondaryclass(weapon);
}

/*
	Name: huntedcratelandoverride
	Namespace: hun
	Checksum: 0x47EF7FAB
	Offset: 0x1158
	Size: 0x9C
	Parameters: 4
	Flags: None
*/
function huntedcratelandoverride(crate, category, owner, team)
{
	crate.visibletoall = 1;
	crate supplydrop::crateactivate();
	crate thread supplydrop::crateusethink();
	crate thread supplydrop::crateusethinkowner();
	supplydrop::default_land_function(crate, category, owner, team);
}

/*
	Name: getcratedroporigin
	Namespace: hun
	Checksum: 0xF96B2F9C
	Offset: 0x1200
	Size: 0xFE
	Parameters: 0
	Flags: None
*/
function getcratedroporigin()
{
	node = undefined;
	time = 10000;
	while(!isdefined(node))
	{
		random_index = randomint(level.dropnodes.size);
		if(!isdefined(level.dropnodes[random_index]))
		{
			continue;
		}
		node_origin = level.dropnodes[random_index].origin;
		if(!bullettracepassed(node_origin + vectorscale((0, 0, 1), 1000), node_origin, 0, undefined))
		{
			level.dropnodes[random_index] = undefined;
			continue;
		}
		node = level.dropnodes[random_index];
		break;
	}
	return node.origin;
}

/*
	Name: cratedropper
	Namespace: hun
	Checksum: 0x34F5FAE9
	Offset: 0x1308
	Size: 0x90
	Parameters: 0
	Flags: None
*/
function cratedropper()
{
	wait_time = level.helitime;
	time = 10000;
	while(true)
	{
		wait(wait_time);
		origin = getcratedroporigin();
		self thread supplydrop::helidelivercrate(origin, "hunted", level.heliowner, "free", 0, 0);
	}
}

