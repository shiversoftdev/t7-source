// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\margwa;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_ai_margwa_elemental;
#using scripts\zm\_zm_ai_margwa_no_idgun;
#using scripts\zm\_zm_ai_mechz;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_genesis_spiders;
#using scripts\zm\_zm_light_zombie;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_shadow_zombie;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis;
#using scripts\zm\zm_genesis_apothicon_fury;
#using scripts\zm\zm_genesis_cleanup_mgr;
#using scripts\zm\zm_genesis_fx;
#using scripts\zm\zm_genesis_keeper;
#using scripts\zm\zm_genesis_mechz;
#using scripts\zm\zm_genesis_power;
#using scripts\zm\zm_genesis_shadowman;
#using scripts\zm\zm_genesis_spiders;
#using scripts\zm\zm_genesis_util;
#using scripts\zm\zm_genesis_vo;
#using scripts\zm\zm_genesis_wasp;

#namespace zm_genesis_round_bosses;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_round_bosses
	Checksum: 0xC9782B84
	Offset: 0x578
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_round_bosses", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_round_bosses
	Checksum: 0xF0124328
	Offset: 0x5B8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level flag::init("can_spawn_margwa", 1);
	level thread function_755b4548();
}

/*
	Name: function_755b4548
	Namespace: zm_genesis_round_bosses
	Checksum: 0x81F48886
	Offset: 0x600
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function function_755b4548()
{
	level.var_b32a2aa0 = 0;
	level.var_ba0d6d40 = randomintrange(11, 13);
	while(true)
	{
		level waittill(#"between_round_over");
		if(level.round_number > level.var_ba0d6d40)
		{
			level.var_ba0d6d40 = level.round_number + 1;
		}
		if(level.round_number == level.var_ba0d6d40)
		{
			level.var_ba0d6d40 = level.round_number + randomintrange(7, 10);
			level thread function_c68599fd();
		}
		if(level.var_ba0d6d40 == level.var_783db6ab)
		{
			level.var_ba0d6d40 = level.var_ba0d6d40 + 2;
		}
	}
}

/*
	Name: function_c68599fd
	Namespace: zm_genesis_round_bosses
	Checksum: 0x1E4A799
	Offset: 0x6F8
	Size: 0x36E
	Parameters: 0
	Flags: Linked
*/
function function_c68599fd()
{
	level.var_b32a2aa0++;
	switch(level.var_b32a2aa0)
	{
		case 1:
		{
			level thread spawn_boss("margwa");
			break;
		}
		case 2:
		{
			level thread spawn_boss("mechz");
			break;
		}
		default:
		{
			if(math::cointoss())
			{
				level thread spawn_boss("margwa");
			}
			else
			{
				level thread spawn_boss("mechz");
			}
			break;
		}
	}
	wait(1);
	a_players = getplayers();
	if(a_players.size == 1)
	{
		return;
	}
	switch(level.var_b32a2aa0)
	{
		case 1:
		{
			break;
		}
		case 2:
		{
			if(a_players.size == 3)
			{
				spawn_boss("margwa");
			}
			else if(a_players.size == 4)
			{
				spawn_boss("margwa");
			}
			break;
		}
		case 3:
		{
			if(a_players.size == 2)
			{
				spawn_boss("mechz");
			}
			else
			{
				if(a_players.size == 3)
				{
					spawn_boss("mechz");
					wait(1);
					spawn_boss("margwa");
				}
				else if(a_players.size == 4)
				{
					spawn_boss("mechz");
					wait(1);
					spawn_boss("margwa");
					wait(1);
					spawn_boss("margwa");
				}
			}
			break;
		}
		default:
		{
			if(a_players.size == 1)
			{
				var_b3c4bbcc = 1;
			}
			else
			{
				if(a_players.size == 2)
				{
					var_b3c4bbcc = 1;
				}
				else
				{
					if(a_players.size == 3)
					{
						var_b3c4bbcc = 2;
					}
					else
					{
						var_b3c4bbcc = 3;
					}
				}
			}
			for(i = 0; i < var_b3c4bbcc; i++)
			{
				if(math::cointoss())
				{
					spawn_boss("margwa");
				}
				else
				{
					spawn_boss("mechz");
				}
				wait(1);
			}
			break;
		}
	}
}

/*
	Name: spawn_boss
	Namespace: zm_genesis_round_bosses
	Checksum: 0x27A5F2DC
	Offset: 0xA70
	Size: 0x244
	Parameters: 2
	Flags: Linked
*/
function spawn_boss(str_enemy, v_pos)
{
	s_loc = function_830cdf99();
	if(!isdefined(s_loc))
	{
		return;
	}
	level thread zm_genesis_vo::function_79eeee03(str_enemy);
	if(str_enemy == "margwa")
	{
		if(math::cointoss())
		{
			var_33504256 = zm_ai_margwa_elemental::function_75b161ab(undefined, s_loc);
		}
		else
		{
			var_33504256 = zm_ai_margwa_elemental::function_26efbc37(undefined, s_loc);
		}
		var_33504256.var_26f9f957 = &function_26f9f957;
		level.var_95981590 = var_33504256;
		level notify(#"hash_c484afcb");
		if(isdefined(var_33504256))
		{
			var_33504256.b_ignore_cleanup = 1;
			n_health = (level.round_number * 100) + 100;
			var_33504256 margwaserverutils::margwasetheadhealth(n_health);
		}
	}
	else if(str_enemy == "mechz")
	{
		if(isdefined(s_loc.script_string) && s_loc.script_string == "exterior")
		{
			var_33504256 = zm_ai_mechz::spawn_mechz(s_loc, 1);
		}
		else
		{
			var_33504256 = zm_ai_mechz::spawn_mechz(s_loc, 0);
		}
	}
	if(!isdefined(var_33504256.maxhealth))
	{
		var_33504256.maxhealth = var_33504256.health;
	}
	if(isdefined(v_pos))
	{
		var_33504256 forceteleport(v_pos, var_33504256.angles);
	}
	var_33504256.var_953b581c = 1;
	return var_33504256;
}

/*
	Name: function_830cdf99
	Namespace: zm_genesis_round_bosses
	Checksum: 0xE2CB723A
	Offset: 0xCC0
	Size: 0x1BA
	Parameters: 0
	Flags: Linked
*/
function function_830cdf99()
{
	var_fffe05f0 = array::randomize(level.margwa_locations);
	a_spawn_locs = [];
	for(i = 0; i < var_fffe05f0.size; i++)
	{
		s_loc = var_fffe05f0[i];
		str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
		if(isdefined(str_zone) && level.zones[str_zone].is_occupied)
		{
			a_spawn_locs[a_spawn_locs.size] = s_loc;
		}
	}
	if(a_spawn_locs.size == 0)
	{
		for(i = 0; i < var_fffe05f0.size; i++)
		{
			s_loc = var_fffe05f0[i];
			str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
			if(isdefined(str_zone) && level.zones[str_zone].is_active)
			{
				a_spawn_locs[a_spawn_locs.size] = s_loc;
			}
		}
	}
	if(a_spawn_locs.size > 0)
	{
		a_spawn_locs = array::randomize(a_spawn_locs);
		return a_spawn_locs[0];
	}
	return var_fffe05f0[0];
}

/*
	Name: function_26f9f957
	Namespace: zm_genesis_round_bosses
	Checksum: 0x814B8784
	Offset: 0xE88
	Size: 0x2E
	Parameters: 2
	Flags: Linked
*/
function function_26f9f957(modelhit, e_attacker)
{
}

