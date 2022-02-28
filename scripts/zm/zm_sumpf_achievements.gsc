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
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_prototype_achievements;

/*
	Name: __init__sytem__
	Namespace: zm_prototype_achievements
	Checksum: 0x59B7336A
	Offset: 0x270
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
	Checksum: 0xB19A3F5C
	Offset: 0x2B0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.achievement_sound_func = &achievement_sound_func;
	zm_spawner::register_zombie_death_event_callback(&function_1abfde35);
	callback::on_connect(&onplayerconnect);
}

/*
	Name: achievement_sound_func
	Namespace: zm_prototype_achievements
	Checksum: 0x2747D07E
	Offset: 0x318
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
	Checksum: 0x5AF04496
	Offset: 0x3D0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self thread function_2eb61ef5();
	self thread function_94fa04f0();
	self thread function_a634891();
	self thread function_2a1b645a();
	self thread function_b44fefa1();
	self thread function_25062f55();
	self thread function_32909149();
}

/*
	Name: function_2eb61ef5
	Namespace: zm_prototype_achievements
	Checksum: 0xCBCA027D
	Offset: 0x488
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_2eb61ef5()
{
	level endon(#"end_game");
	self endon(#"i_am_down");
	self endon(#"disconnect");
	while(isdefined(self))
	{
		if(isdefined(level.round_number) && level.round_number == 5)
		{
			/#
				self iprintln("");
			#/
			return;
		}
		wait(0.5);
	}
}

/*
	Name: function_94fa04f0
	Namespace: zm_prototype_achievements
	Checksum: 0x4DBB7BEB
	Offset: 0x518
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function function_94fa04f0()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"nuke_triggered");
		wait(2);
		if(isdefined(self.zombie_nuked) && self.zombie_nuked.size == 1)
		{
			/#
				self iprintln("");
			#/
			return;
		}
	}
}

/*
	Name: function_a634891
	Namespace: zm_prototype_achievements
	Checksum: 0x3E06AF20
	Offset: 0x5A0
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function function_a634891()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self.var_88c6ab10 = 0;
	while(self.var_88c6ab10 < 10)
	{
		self thread function_47ae7759();
		self function_a2ee1b6c();
	}
	self notify(#"hash_949655c9");
	/#
	#/
}

/*
	Name: function_a2ee1b6c
	Namespace: zm_prototype_achievements
	Checksum: 0x6079B6BD
	Offset: 0x628
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_a2ee1b6c()
{
	level endon(#"end_game");
	level endon(#"end_of_round");
	self endon(#"disconnect");
	while(self.var_88c6ab10 < 10)
	{
		self waittill(#"hash_7a5eece4");
		self.var_88c6ab10++;
	}
}

/*
	Name: function_47ae7759
	Namespace: zm_prototype_achievements
	Checksum: 0x2777E7F6
	Offset: 0x680
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_47ae7759()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self endon(#"hash_949655c9");
	level waittill(#"end_of_round");
	self.var_88c6ab10 = 0;
}

/*
	Name: function_2a1b645a
	Namespace: zm_prototype_achievements
	Checksum: 0xDD401F07
	Offset: 0x6C8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_2a1b645a()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	while(true)
	{
		if(self.score_total >= 75000)
		{
			/#
				self iprintln("");
			#/
			return;
		}
		wait(0.5);
	}
}

/*
	Name: function_b44fefa1
	Namespace: zm_prototype_achievements
	Checksum: 0xB6B9E5AD
	Offset: 0x748
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_b44fefa1()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	while(true)
	{
		if(isdefined(self.perk_hud) && self.perk_hud.size == 4)
		{
			/#
				self iprintln("");
			#/
			return;
		}
		wait(0.5);
	}
}

/*
	Name: function_f67810a2
	Namespace: zm_prototype_achievements
	Checksum: 0xCC8C113D
	Offset: 0x7C8
	Size: 0x7E
	Parameters: 0
	Flags: None
*/
function function_f67810a2()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	for(self.var_dcd9b1e7 = 0; self.var_dcd9b1e7 >= 200; self.var_dcd9b1e7++)
	{
		self waittill(#"hash_1d8b6c31");
	}
	/#
		self iprintln("");
	#/
	self.var_dcd9b1e7 = undefined;
}

/*
	Name: function_25062f55
	Namespace: zm_prototype_achievements
	Checksum: 0xC9AECDAA
	Offset: 0x850
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function function_25062f55()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self.var_498c9df8 = 0;
	if(self.var_498c9df8 >= 150)
	{
		self waittill(#"hash_cae861a8");
	}
	/#
		self iprintln("");
	#/
	self.var_498c9df8 = undefined;
}

/*
	Name: function_32909149
	Namespace: zm_prototype_achievements
	Checksum: 0x59DFC8B4
	Offset: 0x8D0
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function function_32909149()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	do
	{
		self function_f8c272e8();
	}
	while(self.var_59179d2c.size < 3);
	/#
		self iprintln("");
	#/
	self zm_utility::giveachievement_wrapper("DLC2_ZOMBIE_ALL_TRAPS", 0);
	self notify(#"hash_ea373971");
}

/*
	Name: function_f8c272e8
	Namespace: zm_prototype_achievements
	Checksum: 0x57CFA358
	Offset: 0x968
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function function_f8c272e8()
{
	level endon(#"end_game");
	level endon(#"end_of_round");
	self endon(#"disconnect");
	self endon(#"hash_ea373971");
	self.var_59179d2c = [];
	do
	{
		self waittill(#"hash_f0c3517c");
	}
	while(isdefined(self) && self.var_59179d2c.size < 3);
}

/*
	Name: function_1abfde35
	Namespace: zm_prototype_achievements
	Checksum: 0x520290A2
	Offset: 0x9D8
	Size: 0x2DC
	Parameters: 1
	Flags: Linked
*/
function function_1abfde35(e_attacker)
{
	if(!isdefined(e_attacker))
	{
		return;
	}
	if(isdefined(self.var_9a9a0f55) && isdefined(self.var_aa99de67) && isplayer(self.var_aa99de67))
	{
		e_player = self.var_aa99de67;
		if(!(isdefined(isinarray(e_player.var_59179d2c, e_attacker)) && isinarray(e_player.var_59179d2c, e_attacker)))
		{
			array::add(e_player.var_59179d2c, e_attacker);
			e_player notify(#"hash_f0c3517c");
			return;
		}
	}
	if(isdefined(e_attacker.activated_by_player) && e_attacker.targetname === "zombie_trap")
	{
		e_player = e_attacker.activated_by_player;
		if(!(isdefined(isinarray(e_player.var_59179d2c, e_attacker)) && isinarray(e_player.var_59179d2c, e_attacker)))
		{
			array::add(e_player.var_59179d2c, e_attacker);
			e_player notify(#"hash_f0c3517c");
			return;
		}
	}
	if(!isplayer(e_attacker))
	{
		return;
	}
	if(self.damagemod === "MOD_MELEE" && e_attacker zm_powerups::is_insta_kill_active())
	{
		e_attacker notify(#"hash_7a5eece4");
		return;
	}
	if(isdefined(self.var_dcd9b1e7))
	{
		e_attacker notify(#"hash_1d8b6c31");
		return;
	}
	if(isdefined(e_attacker.var_498c9df8) && self.archetype === "zombie" && isdefined(self.damageweapon) && isdefined(self.damagelocation) && isdefined(self.damagemod))
	{
		if(isdefined(zm_utility::is_headshot(self.damageweapon, self.damagelocation, self.damagemod)) && zm_utility::is_headshot(self.damageweapon, self.damagelocation, self.damagemod))
		{
			e_attacker notify(#"hash_cae861a8");
		}
	}
}

