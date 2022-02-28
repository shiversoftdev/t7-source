// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_callbacks;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\shared\ai\margwa;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\throttle_shared;

#namespace doa;

/*
	Name: ignore_systems
	Namespace: doa
	Checksum: 0x906F51FC
	Offset: 0x350
	Size: 0x17C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec ignore_systems()
{
	level.var_be177839 = "";
	system::ignore("cybercom");
	system::ignore("healthoverlay");
	system::ignore("challenges");
	system::ignore("rank");
	system::ignore("hacker_tool");
	system::ignore("grapple");
	system::ignore("replay_gun");
	system::ignore("riotshield");
	system::ignore("oed");
	system::ignore("explosive_bolt");
	system::ignore("empgrenade");
	system::ignore("spawning");
	system::ignore("save");
	system::ignore("hud_message");
	system::ignore("friendlyfire");
}

/*
	Name: main
	Namespace: doa
	Checksum: 0x5FCC44BF
	Offset: 0x4D8
	Size: 0x2D0
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level.var_e2c19907 = 1;
	globallogic::init();
	level.gametype = tolower(getdvarstring("g_gametype"));
	util::registerroundswitch(0, 9);
	util::registertimelimit(0, 0);
	util::registerscorelimit(0, 0);
	util::registerroundlimit(0, 10);
	util::registerroundwinlimit(0, 0);
	util::registernumlives(0, 100);
	globallogic::registerfriendlyfiredelay(level.gametype, 15, 0, 1440);
	level.scoreroundwinbased = 0;
	level.teamscoreperkill = 0;
	level.teamscoreperdeath = 0;
	level.teamscoreperheadshot = 0;
	level.teambased = 1;
	level.overrideteamscore = 1;
	level.onstartgametype = &onstartgametype;
	level.onspawnplayer = &onspawnplayer;
	level.onplayerkilled = &onplayerkilled;
	level.playermayspawn = &may_player_spawn;
	level.gametypespawnwaiter = &wait_to_spawn;
	level.noscavenger = 1;
	level.disableprematchmessages = 1;
	level.endgameonscorelimit = 0;
	level.endgameontimelimit = 0;
	level.ontimelimit = &globallogic::blank;
	level.onscorelimit = &globallogic::blank;
	level.onendgame = &onendgame;
	gameobjects::register_allowed_gameobject("coop");
	setscoreboardcolumns("kills", "gems", "skulls", "chickens", "deaths");
	if(!isdefined(level.gib_throttle))
	{
		level.gib_throttle = new throttle();
	}
	[[ level.gib_throttle ]]->initialize(5, 0.2);
}

/*
	Name: onstartgametype
	Namespace: doa
	Checksum: 0x4677315D
	Offset: 0x7B0
	Size: 0x208
	Parameters: 0
	Flags: Linked
*/
function onstartgametype()
{
	level.displayroundendtext = 0;
	setclientnamemode("auto_change");
	game["switchedsides"] = 0;
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	foreach(team in level.playerteams)
	{
		util::setobjectivetext(team, &"OBJECTIVES_COOP");
		util::setobjectivehinttext(team, &"OBJECTIVES_COOP_HINT");
		util::setobjectivescoretext(team, &"OBJECTIVES_COOP");
		spawnlogic::add_spawn_points(team, "cp_coop_spawn");
		spawnlogic::add_spawn_points(team, "cp_coop_respawn");
	}
	spawning::updateallspawnpoints();
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
	spawnpoint = spawnlogic::get_random_intermission_point();
	setdemointermissionpoint(spawnpoint.origin, spawnpoint.angles);
	level.zombie_use_zigzag_path = 1;
}

/*
	Name: onspawnplayer
	Namespace: doa
	Checksum: 0xF9E97F2D
	Offset: 0x9C0
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function onspawnplayer(predictedspawn, question)
{
	pixbeginevent("COOP:onSpawnPlayer");
	pixendevent();
}

/*
	Name: onendgame
	Namespace: doa
	Checksum: 0x497B97D5
	Offset: 0xA08
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function onendgame(winningteam)
{
	exitlevel(0);
}

/*
	Name: onplayerkilled
	Namespace: doa
	Checksum: 0xA0EC98E8
	Offset: 0xA38
	Size: 0x4C
	Parameters: 9
	Flags: Linked
*/
function onplayerkilled(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
}

/*
	Name: wait_to_spawn
	Namespace: doa
	Checksum: 0x8DD79B36
	Offset: 0xA90
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function wait_to_spawn()
{
	return true;
}

/*
	Name: may_player_spawn
	Namespace: doa
	Checksum: 0xB4B721C
	Offset: 0xAA0
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function may_player_spawn()
{
	return true;
}

