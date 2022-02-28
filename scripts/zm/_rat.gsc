// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\rat_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;

#namespace rat;

/*
	Name: __init__sytem__
	Namespace: rat
	Checksum: 0x1F2990B3
	Offset: 0x100
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("", &__init__, undefined, undefined);
	#/
}

/*
	Name: __init__
	Namespace: rat
	Checksum: 0x7B1372C7
	Offset: 0x140
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		rat_shared::init();
		level.rat.common.gethostplayer = &util::gethostplayer;
		rat_shared::addratscriptcmd("", &derriesezombiespawnnavmeshtest);
	#/
}

/*
	Name: derriesezombiespawnnavmeshtest
	Namespace: rat
	Checksum: 0x4E9D15A5
	Offset: 0x1B8
	Size: 0x514
	Parameters: 2
	Flags: Linked
*/
function derriesezombiespawnnavmeshtest(params, inrat)
{
	/#
		if(!isdefined(inrat))
		{
			inrat = 1;
		}
		if(inrat)
		{
			wait(10);
		}
		enemy = zm_devgui::devgui_zombie_spawn();
		enemy.is_rat_test = 1;
		failed_spawn_origin = [];
		failed_node_origin = [];
		failed_attack_spot_spawn_origin = [];
		failed_attack_spot = [];
		size = 0;
		failed_attack_spot_size = 0;
		wait(0.2);
		foreach(zone in level.zones)
		{
			foreach(loc in zone.a_loc_types[""])
			{
				angles = (0, 0, 0);
				enemy forceteleport(loc.origin, angles);
				wait(0.2);
				node = undefined;
				for(j = 0; j < level.exterior_goals.size; j++)
				{
					if(isdefined(level.exterior_goals[j].script_string) && level.exterior_goals[j].script_string == loc.script_string)
					{
						node = level.exterior_goals[j];
					}
				}
				if(isdefined(node))
				{
					ispath = enemy setgoal(node.origin);
					if(!ispath)
					{
						failed_spawn_origin[size] = loc.origin;
						failed_node_origin[size] = node.origin;
						size++;
					}
					wait(0.2);
					for(j = 0; j < node.attack_spots.size; j++)
					{
						isattackpath = enemy setgoal(node.attack_spots[j]);
						if(!isattackpath)
						{
							failed_attack_spot_spawn_origin[failed_attack_spot_size] = loc.origin;
							failed_attack_spot[failed_attack_spot_size] = node.attack_spots[j];
							failed_attack_spot_size++;
						}
						wait(0.2);
					}
				}
			}
		}
		if(inrat)
		{
			errmsg = "";
			for(i = 0; i < size; i++)
			{
				errmsg = errmsg + (((("" + failed_spawn_origin[i]) + "") + failed_node_origin[i]) + "");
			}
			for(i = 0; i < failed_attack_spot_size; i++)
			{
				errmsg = errmsg + (((("" + failed_attack_spot_spawn_origin[i]) + "") + failed_attack_spot[i]) + "");
			}
			if(size > 0 || failed_attack_spot_size > 0)
			{
				ratreportcommandresult(params._id, 0, errmsg);
			}
			else
			{
				ratreportcommandresult(params._id, 1);
			}
		}
	#/
}

