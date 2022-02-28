// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_genesis_spiders;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_ai_spawning;

#namespace zm_genesis_spiders;

/*
	Name: function_56aaef97
	Namespace: zm_genesis_spiders
	Checksum: 0x7A9048DA
	Offset: 0x348
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_56aaef97()
{
	level.var_adca2f3c = 0;
	level.var_7cba7005 = 0;
	level.var_a3ad836b = 50;
	level.fn_custom_round_ai_spawn = &function_33aa4940;
}

/*
	Name: function_33aa4940
	Namespace: zm_genesis_spiders
	Checksum: 0x9FD5A688
	Offset: 0x390
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_33aa4940()
{
	var_c0692329 = 0;
	if(isdefined(level.var_7cba7005) && level.var_7cba7005)
	{
		if(randomint(100) < level.var_a3ad836b)
		{
			var_c0692329 = 1;
		}
	}
	else if(isdefined(level.var_adca2f3c) && level.var_adca2f3c)
	{
		if(zm_zonemgr::any_player_in_zone("apothicon_interior_zone"))
		{
			if(randomint(100) < level.var_a3ad836b)
			{
				var_c0692329 = 1;
				var_aa671dd4 = "apothicon_interior_zone_spawners";
			}
		}
	}
	if(var_c0692329)
	{
		s_spawn_point = function_99f6dbf1(var_aa671dd4);
		/#
			assert(isdefined(s_spawn_point), "");
		#/
		level.var_718361fb = function_3f180afe();
		zm_ai_spiders::function_f4bd92a2(1, s_spawn_point);
	}
	if(!var_c0692329)
	{
		var_c0692329 = zm_genesis_ai_spawning::function_fd8b24f5();
	}
	return var_c0692329;
}

/*
	Name: function_99f6dbf1
	Namespace: zm_genesis_spiders
	Checksum: 0x4E8E678D
	Offset: 0x510
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function function_99f6dbf1(var_aa671dd4)
{
	a_s_locs = array::randomize(level.zm_loc_types["spider_location"]);
	for(i = 0; i < a_s_locs.size; i++)
	{
		if(isdefined(var_aa671dd4))
		{
			if(a_s_locs[i].targetname === var_aa671dd4)
			{
				return a_s_locs[i];
			}
			continue;
		}
		return a_s_locs[i];
	}
	return undefined;
}

/*
	Name: function_3f180afe
	Namespace: zm_genesis_spiders
	Checksum: 0x4EE86D7A
	Offset: 0x5C8
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function function_3f180afe()
{
	if(level.round_number < 5)
	{
		var_fda270a4 = 400;
	}
	else
	{
		if(level.round_number < 10)
		{
			var_fda270a4 = 900;
		}
		else
		{
			if(level.round_number < 15)
			{
				var_fda270a4 = 1300;
			}
			else
			{
				var_fda270a4 = 1600;
			}
		}
	}
	return int(var_fda270a4 * 0.35);
}

