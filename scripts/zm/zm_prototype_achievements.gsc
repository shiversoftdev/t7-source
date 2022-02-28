// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_prototype_achievements;

/*
	Name: __init__sytem__
	Namespace: zm_prototype_achievements
	Checksum: 0xE8455936
	Offset: 0x2A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_theater_achievements", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_prototype_achievements
	Checksum: 0xDC4A2704
	Offset: 0x2E8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.achievement_sound_func = &achievement_sound_func;
	level thread function_dab290f5();
	level thread function_94bb4bfb();
	zm_spawner::register_zombie_death_event_callback(&function_1abfde35);
	callback::on_connect(&onplayerconnect);
}

/*
	Name: achievement_sound_func
	Namespace: zm_prototype_achievements
	Checksum: 0x17ED5F
	Offset: 0x380
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function achievement_sound_func(achievement_name_lower)
{
	self endon(#"disconnect");
	if(!sessionmodeisonlinegame())
	{
		return;
	}
	for(i = 0; i < (self getentitynumber() + 1); i++)
	{
		util::wait_network_frame();
	}
	self thread zm_utility::do_player_general_vox("general", "achievement");
}

/*
	Name: onplayerconnect
	Namespace: zm_prototype_achievements
	Checksum: 0xC19EBC29
	Offset: 0x438
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self thread function_405cf907();
}

/*
	Name: function_dab290f5
	Namespace: zm_prototype_achievements
	Checksum: 0xECEEDBD1
	Offset: 0x460
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_dab290f5()
{
	level endon(#"end_game");
	level endon(#"i_said_were_closed_failed");
	level waittill(#"start_zombie_round_logic");
	level thread function_2d04250a();
	while(level.round_number < 3)
	{
		level waittill(#"end_of_round");
	}
	/#
	#/
	level zm_utility::giveachievement_wrapper("ZM_PROTOTYPE_I_SAID_WERE_CLOSED", 1);
	level notify(#"i_said_were_closed_completed");
}

/*
	Name: function_2d04250a
	Namespace: zm_prototype_achievements
	Checksum: 0xB9FD093A
	Offset: 0x500
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_2d04250a()
{
	/#
		assert(isdefined(level.zombie_spawners), "");
	#/
	array::thread_all(level.zombie_spawners, &spawner::add_spawn_function, &function_c97e69a9);
	level util::waittill_any("i_said_were_closed_failed", "i_said_were_closed_completed");
	array::run_all(level.zombie_spawners, &spawner::remove_spawn_function, &function_c97e69a9);
}

/*
	Name: function_c97e69a9
	Namespace: zm_prototype_achievements
	Checksum: 0xD6420B5F
	Offset: 0x5D0
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function function_c97e69a9()
{
	self endon(#"death");
	level endon(#"i_said_were_closed_failed");
	level endon(#"i_said_were_closed_completed");
	if(self.archetype !== "zombie")
	{
		return;
	}
	self waittill(#"completed_emerging_into_playable_area");
	if(self.zone_name === "start_zone")
	{
		level notify(#"i_said_were_closed_failed");
	}
}

/*
	Name: function_94bb4bfb
	Namespace: zm_prototype_achievements
	Checksum: 0xE9EFB006
	Offset: 0x648
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_94bb4bfb()
{
	level endon(#"end_game");
	level endon(#"door_opened");
	level waittill(#"start_of_round");
	while(level.round_number <= 10)
	{
		level waittill(#"end_of_round");
	}
	/#
	#/
}

/*
	Name: function_405cf907
	Namespace: zm_prototype_achievements
	Checksum: 0x387F9BD5
	Offset: 0x6A0
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function function_405cf907()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self.var_dc48525e = 0;
	while(self.var_dc48525e < 5)
	{
		self thread function_b32b243f();
		self function_7ea87222();
	}
	self notify(#"hash_7227b667");
	/#
	#/
}

/*
	Name: function_7ea87222
	Namespace: zm_prototype_achievements
	Checksum: 0x28B4E190
	Offset: 0x728
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_7ea87222()
{
	level endon(#"end_game");
	level endon(#"end_of_round");
	self endon(#"disconnect");
	while(self.var_dc48525e < 5)
	{
		self waittill(#"hash_abf05fe4");
		self.var_dc48525e++;
	}
}

/*
	Name: function_b32b243f
	Namespace: zm_prototype_achievements
	Checksum: 0xEFA45E6D
	Offset: 0x780
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_b32b243f()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self endon(#"hash_7227b667");
	level waittill(#"end_of_round");
	self.var_dc48525e = 0;
}

/*
	Name: function_1abfde35
	Namespace: zm_prototype_achievements
	Checksum: 0x43CF3520
	Offset: 0x7C8
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function function_1abfde35(e_attacker)
{
	if(isdefined(e_attacker) && isdefined(self.damagemod) && isdefined(level.lastexplodingbarrel) && isdefined(level.lastexplodingbarrel["origin"]))
	{
		if(self.damagemod != "MOD_EXPLOSIVE")
		{
			return;
		}
		var_d67079b2 = 62500;
		var_6522294b = level.lastexplodingbarrel["origin"];
		var_2145bd89 = self.origin + vectorscale((0, 0, 1), 30);
		if(distancesquared(var_2145bd89, var_6522294b) <= var_d67079b2)
		{
			e_attacker notify(#"hash_abf05fe4");
		}
	}
}

