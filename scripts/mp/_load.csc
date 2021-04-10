// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_ambient;
#using scripts\mp\_bouncingbetty;
#using scripts\mp\_callbacks;
#using scripts\mp\_claymore;
#using scripts\mp\_ctf;
#using scripts\mp\_decoy;
#using scripts\mp\_destructible;
#using scripts\mp\_end_game_flow;
#using scripts\mp\_explosive_bolt;
#using scripts\mp\_flashgrenades;
#using scripts\mp\_global_fx;
#using scripts\mp\_gravity_spikes;
#using scripts\mp\_hacker_tool;
#using scripts\mp\_helicopter_sounds;
#using scripts\mp\_hive_gun;
#using scripts\mp\_lightninggun;
#using scripts\mp\_multi_extracam;
#using scripts\mp\_perks;
#using scripts\mp\_proximity_grenade;
#using scripts\mp\_radiant_live_update;
#using scripts\mp\_rewindobjects;
#using scripts\mp\_riotshield;
#using scripts\mp\_rotating_object;
#using scripts\mp\_satchel_charge;
#using scripts\mp\_tacticalinsertion;
#using scripts\mp\_threat_detector;
#using scripts\mp\_trophy_system;
#using scripts\mp\_util;
#using scripts\mp\_vehicle;
#using scripts\mp\gametypes\_classicmode;
#using scripts\mp\gametypes\_weaponobjects;
#using scripts\mp\killstreaks\_counteruav;
#using scripts\mp\killstreaks\_dart;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_flak_drone;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_helicopter_gunner;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_microwave_turret;
#using scripts\mp\killstreaks\_planemortar;
#using scripts\mp\killstreaks\_raps;
#using scripts\mp\killstreaks\_remotemissile;
#using scripts\mp\killstreaks\_turret;
#using scripts\mp\mpdialog;
#using scripts\shared\_burnplayer;
#using scripts\shared\_oob;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfaceanim_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\load_shared;
#using scripts\shared\music_shared;
#using scripts\shared\player_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_hive_gun;
#using scripts\shared\weapons\_lightninggun;
#using scripts\shared\weapons\_pineapple_gun;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_satchel_charge;
#using scripts\shared\weapons\_sticky_grenade;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\multilockapguidance;
#using scripts\shared\weapons\spike_charge;

#namespace load;

/*
	Name: levelnotifyhandler
	Namespace: load
	Checksum: 0x4A965A5C
	Offset: 0xAF0
	Size: 0x3A
	Parameters: 3
	Flags: Linked
*/
function levelnotifyhandler(clientnum, state, oldstate)
{
	if(state != "")
	{
		level notify(state, clientnum);
	}
}

/*
	Name: main
	Namespace: load
	Checksum: 0x57CA48C3
	Offset: 0xB38
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	/#
		/#
			assert(isdefined(level.first_frame), "");
		#/
	#/
	level thread util::servertime();
	level thread util::init_utility();
	util::registersystem("levelNotify", &levelnotifyhandler);
	register_clientfields();
	level.createfx_disable_fx = getdvarint("disable_fx") == 1;
	system::wait_till("all");
	level flagsys::set("load_main_complete");
}

/*
	Name: register_clientfields
	Namespace: load
	Checksum: 0x896F8A44
	Offset: 0xC40
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("missile", "cf_m_proximity", 1, 1, "int", &callback::callback_proximity, 0, 0);
	clientfield::register("missile", "cf_m_emp", 1, 1, "int", &callback::callback_emp, 0, 0);
	clientfield::register("missile", "cf_m_stun", 1, 1, "int", &callback::callback_stunned, 0, 0);
}

