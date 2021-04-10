// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_ambient;
#using scripts\cp\_bouncingbetty;
#using scripts\cp\_callbacks;
#using scripts\cp\_claymore;
#using scripts\cp\_decoy;
#using scripts\cp\_destructible;
#using scripts\cp\_explosive_bolt;
#using scripts\cp\_flashgrenades;
#using scripts\cp\_global_fx;
#using scripts\cp\_hacker_tool;
#using scripts\cp\_helicopter_sounds;
#using scripts\cp\_laststand;
#using scripts\cp\_mobile_armory;
#using scripts\cp\_oed;
#using scripts\cp\_proximity_grenade;
#using scripts\cp\_radiant_live_update;
#using scripts\cp\_rewindobjects;
#using scripts\cp\_riotshield;
#using scripts\cp\_rotating_object;
#using scripts\cp\_satchel_charge;
#using scripts\cp\_skipto;
#using scripts\cp\_tacticalinsertion;
#using scripts\cp\_trophy_system;
#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\gametypes\_player_cam;
#using scripts\cp\gametypes\_weaponobjects;
#using scripts\shared\_oob;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfaceanim_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\load_shared;
#using scripts\shared\music_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_satchel_charge;
#using scripts\shared\weapons\_sticky_grenade;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\antipersonnelguidance;
#using scripts\shared\weapons\multilockapguidance;
#using scripts\shared\weapons\spike_charge;

#namespace load;

/*
	Name: levelnotifyhandler
	Namespace: load
	Checksum: 0xFC7F8EBB
	Offset: 0x7F0
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
	Checksum: 0x1D397CF3
	Offset: 0x838
	Size: 0x1BC
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
	if(isdefined(level._loadstarted) && level._loadstarted)
	{
		return;
	}
	level._loadstarted = 1;
	level thread util::servertime();
	level thread util::init_utility();
	level thread register_clientfields();
	util::registersystem("levelNotify", &levelnotifyhandler);
	level.createfx_disable_fx = getdvarint("disable_fx") == 1;
	level thread _claymore::init();
	level thread _explosive_bolt::main();
	callback::add_callback(#"hash_da8d7d74", &basic_player_connect);
	callback::on_spawned(&on_player_spawned);
	system::wait_till("all");
	art_review();
	level flagsys::set("load_main_complete");
	setdvar("phys_wind_enabled", 0);
}

/*
	Name: basic_player_connect
	Namespace: load
	Checksum: 0x478993FF
	Offset: 0xA00
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function basic_player_connect(localclientnum)
{
	if(!isdefined(level._laststand))
	{
		level._laststand = [];
	}
	level._laststand[localclientnum] = 0;
	forcegamemodemappings(localclientnum, "default");
}

/*
	Name: on_player_spawned
	Namespace: load
	Checksum: 0x3DD95BC4
	Offset: 0xA60
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function on_player_spawned(localclientnum)
{
	self thread force_update_player_clientfields(localclientnum);
}

/*
	Name: force_update_player_clientfields
	Namespace: load
	Checksum: 0x80A7C077
	Offset: 0xA90
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function force_update_player_clientfields(localclientnum)
{
	self endon(#"entityshutdown");
	while(!clienthassnapshot(localclientnum))
	{
		wait(0.25);
	}
	wait(0.25);
	self processclientfieldsasifnew();
}

/*
	Name: register_clientfields
	Namespace: load
	Checksum: 0x576E8083
	Offset: 0xAF8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("toplayer", "sndHealth", 1, 2, "int", &audio::sndhealthsystem, 0, 0);
}

