// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\bots\_bot_combat;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_bot;

/*
	Name: __init__sytem__
	Namespace: zm_bot
	Checksum: 0xE8A73F01
	Offset: 0x1F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bot
	Checksum: 0xD54B1689
	Offset: 0x238
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		println("");
	#/
	/#
		level.onbotspawned = &on_bot_spawned;
		level.getbotthreats = &bot_combat::get_ai_threats;
		level.botprecombat = &bot::coop_pre_combat;
		level.botpostcombat = &bot::coop_post_combat;
		level.botidle = &bot::follow_coop_players;
		level.botdevguicmd = &bot::coop_bot_devgui_cmd;
		thread debug_coop_bot_test();
	#/
}

/*
	Name: debug_coop_bot_test
	Namespace: zm_bot
	Checksum: 0xB1F46EEA
	Offset: 0x308
	Size: 0x1E8
	Parameters: 0
	Flags: Linked
*/
function debug_coop_bot_test()
{
	/#
		botcount = 0;
		adddebugcommand("");
		while(true)
		{
			if(getdvarint("") > 0)
			{
				while(getdvarint("") > 0)
				{
					if(botcount > 0 && randomint(100) > 60)
					{
						adddebugcommand("");
						botcount--;
						debugmsg("" + botcount);
					}
					else if(botcount < getdvarint("") && randomint(100) > 50)
					{
						adddebugcommand("");
						botcount++;
						debugmsg("" + botcount);
					}
					wait(randomintrange(1, 3));
				}
			}
			else
			{
				while(botcount > 0)
				{
					adddebugcommand("");
					botcount--;
					debugmsg("" + botcount);
					wait(1);
				}
			}
			wait(1);
		}
	#/
}

/*
	Name: on_bot_spawned
	Namespace: zm_bot
	Checksum: 0x18071DF4
	Offset: 0x4F8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function on_bot_spawned()
{
	/#
		host = bot::get_host_player();
		loadout = host zm_weapons::player_get_loadout();
		self zm_weapons::player_give_loadout(loadout);
	#/
}

/*
	Name: debugmsg
	Namespace: zm_bot
	Checksum: 0x95D1E69
	Offset: 0x568
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function debugmsg(str_txt)
{
	/#
		iprintlnbold(str_txt);
		if(isdefined(level.name))
		{
			println((("" + level.name) + "") + str_txt);
		}
	#/
}

