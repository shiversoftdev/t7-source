// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_clone;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_ai_clone;

/*
	Name: __init__sytem__
	Namespace: zm_ai_clone
	Checksum: 0x3656668A
	Offset: 0x3A8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_clone", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_clone
	Checksum: 0x82D72A9F
	Offset: 0x3F0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level flag::init("thrasher_round");
	/#
		execdevgui("");
		thread function_78933fc2();
	#/
	init();
}

/*
	Name: __main__
	Namespace: zm_ai_clone
	Checksum: 0x5D118D13
	Offset: 0x460
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	register_clientfields();
}

/*
	Name: register_clientfields
	Namespace: zm_ai_clone
	Checksum: 0x99EC1590
	Offset: 0x480
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
}

/*
	Name: init
	Namespace: zm_ai_clone
	Checksum: 0xF72A6783
	Offset: 0x490
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function init()
{
	precache();
}

/*
	Name: precache
	Namespace: zm_ai_clone
	Checksum: 0x99EC1590
	Offset: 0x4B0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

/*
	Name: function_78933fc2
	Namespace: zm_ai_clone
	Checksum: 0x1A73A026
	Offset: 0x4C0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_78933fc2()
{
	/#
		level flagsys::wait_till("");
		zm_devgui::add_custom_devgui_callback(&clone_devgui_callback);
	#/
}

/*
	Name: clone_devgui_callback
	Namespace: zm_ai_clone
	Checksum: 0x52E3CFD0
	Offset: 0x510
	Size: 0x1E6
	Parameters: 1
	Flags: Linked
*/
function clone_devgui_callback(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				players = getplayers();
				queryresult = positionquery_source_navigation(players[0].origin, 128, 256, 128, 20);
				if(isdefined(queryresult) && queryresult.data.size > 0)
				{
					clone = spawnactor("", queryresult.data[0].origin, (0, 0, 0), "", 1);
					clone cloneserverutils::cloneplayerlook(clone, players[0], players[0]);
				}
				break;
			}
			case "":
			{
				clones = getaiarchetypearray("");
				if(clones.size > 0)
				{
					foreach(clone in clones)
					{
						clone kill();
					}
				}
				break;
			}
		}
	#/
}

