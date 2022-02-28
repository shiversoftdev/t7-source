// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_crawl_space;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_crawl_space
	Checksum: 0x97F9BE4A
	Offset: 0x1B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_crawl_space", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_crawl_space
	Checksum: 0x83252F4C
	Offset: 0x1F0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_crawl_space", "activated", 5, undefined, undefined, undefined, &activation);
}

/*
	Name: activation
	Namespace: zm_bgb_crawl_space
	Checksum: 0xBB425F2F
	Offset: 0x250
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	a_ai = getaiarray();
	for(i = 0; i < a_ai.size; i++)
	{
		if(isdefined(a_ai[i]) && isalive(a_ai[i]) && a_ai[i].archetype === "zombie" && isdefined(a_ai[i].gibdef))
		{
			var_5a3ad5d6 = distancesquared(self.origin, a_ai[i].origin);
			if(var_5a3ad5d6 < 360000)
			{
				a_ai[i] zombie_utility::makezombiecrawler();
			}
		}
	}
}

