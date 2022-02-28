// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;

#namespace zm_elemental_zombie;

/*
	Name: __init__sytem__
	Namespace: zm_elemental_zombie
	Checksum: 0xD36D6B89
	Offset: 0x5B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_elemental_zombie", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_elemental_zombie
	Checksum: 0x2B98B691
	Offset: 0x5F0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	register_clientfields();
	/#
		execdevgui("");
		thread function_f6901b6a();
	#/
}

/*
	Name: register_clientfields
	Namespace: zm_elemental_zombie
	Checksum: 0xA92D772F
	Offset: 0x640
	Size: 0x124
	Parameters: 0
	Flags: Linked, Private
*/
function private register_clientfields()
{
	clientfield::register("actor", "sparky_zombie_spark_fx", 1, 1, "int");
	clientfield::register("actor", "sparky_zombie_death_fx", 1, 1, "int");
	clientfield::register("actor", "napalm_zombie_death_fx", 1, 1, "int");
	clientfield::register("actor", "sparky_damaged_fx", 1, 1, "counter");
	clientfield::register("actor", "napalm_damaged_fx", 1, 1, "counter");
	clientfield::register("actor", "napalm_sfx", 11000, 1, "int");
}

/*
	Name: function_1b1bb1b
	Namespace: zm_elemental_zombie
	Checksum: 0x2E2C0504
	Offset: 0x770
	Size: 0x264
	Parameters: 0
	Flags: Linked
*/
function function_1b1bb1b()
{
	ai_zombie = self;
	if(!isalive(ai_zombie))
	{
		return;
	}
	var_199ecc3a = function_4aeed0a5("sparky");
	if(!isdefined(level.var_1ae26ca5) || var_199ecc3a < level.var_1ae26ca5)
	{
		if(!isdefined(ai_zombie.is_elemental_zombie) || ai_zombie.is_elemental_zombie == 0)
		{
			ai_zombie.is_elemental_zombie = 1;
			ai_zombie.var_9a02a614 = "sparky";
			ai_zombie clientfield::set("sparky_zombie_spark_fx", 1);
			ai_zombie.health = int(ai_zombie.health * 1.5);
			ai_zombie thread function_d9226011();
			ai_zombie thread function_2987b6dc();
			if(ai_zombie.iscrawler === 1)
			{
				var_f4a5c99 = array("ai_zm_dlc1_zombie_crawl_turn_sparky_a", "ai_zm_dlc1_zombie_crawl_turn_sparky_b", "ai_zm_dlc1_zombie_crawl_turn_sparky_c", "ai_zm_dlc1_zombie_crawl_turn_sparky_d", "ai_zm_dlc1_zombie_crawl_turn_sparky_e");
			}
			else
			{
				var_f4a5c99 = array("ai_zm_dlc1_zombie_turn_sparky_a", "ai_zm_dlc1_zombie_turn_sparky_b", "ai_zm_dlc1_zombie_turn_sparky_c", "ai_zm_dlc1_zombie_turn_sparky_d", "ai_zm_dlc1_zombie_turn_sparky_e");
			}
			if(isdefined(ai_zombie) && !isdefined(ai_zombie.traversestartnode) && (!(isdefined(self.var_bb98125f) && self.var_bb98125f)))
			{
				ai_zombie animation::play(array::random(var_f4a5c99), ai_zombie, undefined, 1, 0.2, 0.2);
			}
		}
	}
}

/*
	Name: function_f4defbc2
	Namespace: zm_elemental_zombie
	Checksum: 0xD4F495CE
	Offset: 0x9E0
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_f4defbc2()
{
	if(isdefined(self))
	{
		ai_zombie = self;
		var_ac4641b = function_4aeed0a5("napalm");
		if(!isdefined(level.var_bd64e31e) || var_ac4641b < level.var_bd64e31e)
		{
			if(!isdefined(ai_zombie.is_elemental_zombie) || ai_zombie.is_elemental_zombie == 0)
			{
				ai_zombie.is_elemental_zombie = 1;
				ai_zombie.var_9a02a614 = "napalm";
				ai_zombie clientfield::set("arch_actor_fire_fx", 1);
				ai_zombie clientfield::set("napalm_sfx", 1);
				ai_zombie.health = int(ai_zombie.health * 0.75);
				ai_zombie thread napalm_zombie_death();
				ai_zombie thread function_d070bfba();
				ai_zombie zombie_utility::set_zombie_run_cycle("sprint");
			}
		}
	}
}

/*
	Name: function_2987b6dc
	Namespace: zm_elemental_zombie
	Checksum: 0x51E9E8B7
	Offset: 0xB60
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_2987b6dc()
{
	self endon(#"entityshutdown");
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage");
		if(randomint(100) < 50)
		{
			self clientfield::increment("sparky_damaged_fx");
		}
		wait(0.05);
	}
}

/*
	Name: function_d070bfba
	Namespace: zm_elemental_zombie
	Checksum: 0x1160D905
	Offset: 0xBE0
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_d070bfba()
{
	self endon(#"entityshutdown");
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage");
		if(randomint(100) < 50)
		{
			self clientfield::increment("napalm_damaged_fx");
		}
		wait(0.05);
	}
}

/*
	Name: function_d9226011
	Namespace: zm_elemental_zombie
	Checksum: 0x156C1353
	Offset: 0xC60
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_d9226011()
{
	ai_zombie = self;
	ai_zombie waittill(#"death", attacker);
	if(!isdefined(ai_zombie) || ai_zombie.nuked === 1)
	{
		return;
	}
	ai_zombie clientfield::set("sparky_zombie_death_fx", 1);
	ai_zombie zombie_utility::gib_random_parts();
	gibserverutils::annihilate(ai_zombie);
	radiusdamage(ai_zombie.origin + vectorscale((0, 0, 1), 35), 128, 70, 30, self, "MOD_EXPLOSIVE");
}

/*
	Name: napalm_zombie_death
	Namespace: zm_elemental_zombie
	Checksum: 0x9456FA2B
	Offset: 0xD58
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function napalm_zombie_death()
{
	ai_zombie = self;
	ai_zombie waittill(#"death", attacker);
	if(!isdefined(ai_zombie) || ai_zombie.nuked === 1)
	{
		return;
	}
	ai_zombie clientfield::set("napalm_zombie_death_fx", 1);
	ai_zombie zombie_utility::gib_random_parts();
	gibserverutils::annihilate(ai_zombie);
	if(isdefined(level.var_36b5dab) && level.var_36b5dab || (isdefined(ai_zombie.var_36b5dab) && ai_zombie.var_36b5dab))
	{
		ai_zombie.custom_player_shellshock = &function_e6cd7e78;
	}
	radiusdamage(ai_zombie.origin + vectorscale((0, 0, 1), 35), 128, 70, 30, self, "MOD_EXPLOSIVE");
}

/*
	Name: function_e6cd7e78
	Namespace: zm_elemental_zombie
	Checksum: 0x6B29BAC1
	Offset: 0xEA0
	Size: 0x74
	Parameters: 5
	Flags: Linked
*/
function function_e6cd7e78(damage, attacker, direction_vec, point, mod)
{
	if(getdvarstring("blurpain") == "on")
	{
		self shellshock("pain_zm", 0.5);
	}
}

/*
	Name: function_d41418b8
	Namespace: zm_elemental_zombie
	Checksum: 0x9D448BB2
	Offset: 0xF20
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_d41418b8()
{
	a_zombies = getaiarchetypearray("zombie");
	a_filtered_zombies = array::filter(a_zombies, 0, &function_b804eb62);
	return a_filtered_zombies;
}

/*
	Name: function_c50e890f
	Namespace: zm_elemental_zombie
	Checksum: 0x54599B75
	Offset: 0xF90
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_c50e890f(type)
{
	a_zombies = getaiarchetypearray("zombie");
	a_filtered_zombies = array::filter(a_zombies, 0, &function_361f6caa, type);
	return a_filtered_zombies;
}

/*
	Name: function_4aeed0a5
	Namespace: zm_elemental_zombie
	Checksum: 0x3C20E926
	Offset: 0x1008
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function function_4aeed0a5(type)
{
	a_zombies = function_c50e890f(type);
	return a_zombies.size;
}

/*
	Name: function_361f6caa
	Namespace: zm_elemental_zombie
	Checksum: 0x96C8CE2A
	Offset: 0x1048
	Size: 0x28
	Parameters: 2
	Flags: Linked
*/
function function_361f6caa(ai_zombie, type)
{
	return ai_zombie.var_9a02a614 === type;
}

/*
	Name: function_b804eb62
	Namespace: zm_elemental_zombie
	Checksum: 0x590ECFE
	Offset: 0x1078
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function function_b804eb62(ai_zombie)
{
	return ai_zombie.is_elemental_zombie !== 1;
}

/*
	Name: function_f6901b6a
	Namespace: zm_elemental_zombie
	Checksum: 0x96F67E6F
	Offset: 0x10A0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_f6901b6a()
{
	/#
		level flagsys::wait_till("");
		zm_devgui::add_custom_devgui_callback(&function_2d0e7f4);
	#/
}

/*
	Name: function_2d0e7f4
	Namespace: zm_elemental_zombie
	Checksum: 0xA227CFD7
	Offset: 0x10F0
	Size: 0x28E
	Parameters: 1
	Flags: Linked
*/
function function_2d0e7f4(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				a_zombies = function_d41418b8();
				if(a_zombies.size > 0)
				{
					a_zombies = arraysortclosest(a_zombies, level.players[0].origin);
					a_zombies[0] function_1b1bb1b();
				}
				break;
			}
			case "":
			{
				a_zombies = function_d41418b8();
				if(a_zombies.size > 0)
				{
					a_zombies = arraysortclosest(a_zombies, level.players[0].origin);
					a_zombies[0] function_f4defbc2();
				}
				break;
			}
			case "":
			{
				a_zombies = function_d41418b8();
				if(a_zombies.size > 0)
				{
					foreach(zombie in a_zombies)
					{
						zombie function_1b1bb1b();
					}
				}
				break;
			}
			case "":
			{
				a_zombies = function_d41418b8();
				if(a_zombies.size > 0)
				{
					foreach(zombie in a_zombies)
					{
						zombie function_f4defbc2();
					}
				}
				break;
			}
		}
	#/
}

