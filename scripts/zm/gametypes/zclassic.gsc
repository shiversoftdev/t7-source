// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\math_shared;
#using scripts\zm\_zm_stats;
#using scripts\zm\gametypes\_zm_gametype;

#namespace zclassic;

/*
	Name: main
	Namespace: zclassic
	Checksum: 0xC3EB8D6B
	Offset: 0x110
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_gametype::main();
	level.onprecachegametype = &onprecachegametype;
	level.onstartgametype = &onstartgametype;
	level._game_module_custom_spawn_init_func = &zm_gametype::custom_spawn_init_func;
	level._game_module_stat_update_func = &zm_stats::survival_classic_custom_stat_update;
}

/*
	Name: onprecachegametype
	Namespace: zclassic
	Checksum: 0xEC319984
	Offset: 0x190
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function onprecachegametype()
{
	level.playersuicideallowed = 1;
	level.canplayersuicide = &zm_gametype::canplayersuicide;
}

/*
	Name: onstartgametype
	Namespace: zclassic
	Checksum: 0xE1C16F5E
	Offset: 0x1C0
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function onstartgametype()
{
	level.spawnmins = (0, 0, 0);
	level.spawnmaxs = (0, 0, 0);
	structs = struct::get_array("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		level.spawnmins = math::expand_mins(level.spawnmins, struct.origin);
		level.spawnmaxs = math::expand_maxs(level.spawnmaxs, struct.origin);
	}
	level.mapcenter = math::find_box_center(level.spawnmins, level.spawnmaxs);
	setmapcenter(level.mapcenter);
}

