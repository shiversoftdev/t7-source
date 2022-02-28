// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_theater_achievements;

/*
	Name: __init__sytem__
	Namespace: zm_theater_achievements
	Checksum: 0x6AEFE740
	Offset: 0x248
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
	Namespace: zm_theater_achievements
	Checksum: 0x964055A2
	Offset: 0x288
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
	Namespace: zm_theater_achievements
	Checksum: 0x12C0B4D0
	Offset: 0x2F0
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
	Namespace: zm_theater_achievements
	Checksum: 0x885FDE47
	Offset: 0x3A8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self thread achievement_ive_seen_some_things();
	self thread function_24b05d89();
	self thread function_6c831509();
}

/*
	Name: achievement_ive_seen_some_things
	Namespace: zm_theater_achievements
	Checksum: 0xB1DD48B2
	Offset: 0x400
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function achievement_ive_seen_some_things()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self.var_3ac4b03d = [];
	for(i = 0; i <= 3; i++)
	{
		self.var_3ac4b03d[i] = i;
	}
	level flag::wait_till("power_on");
	while(self.var_3ac4b03d.size > 0)
	{
		self waittill(#"player_teleported", n_loc);
		if(isdefined(n_loc) && isint(n_loc) && isinarray(self.var_3ac4b03d, n_loc))
		{
			arrayremovevalue(self.var_3ac4b03d, n_loc);
		}
		wait(0.05);
	}
	/#
	#/
	self zm_utility::giveachievement_wrapper("ZM_THEATER_IVE_SEEN_SOME_THINGS", 0);
}

/*
	Name: function_24b05d89
	Namespace: zm_theater_achievements
	Checksum: 0xCBB3CF96
	Offset: 0x540
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_24b05d89()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self.var_597e831d = [];
	for(i = 1; i <= 3; i++)
	{
		self.var_597e831d[i - 1] = "ps" + i;
	}
	level flag::wait_till("power_on");
	while(self.var_597e831d.size > 0)
	{
		level waittill(#"play_movie", var_2be4351a);
		if(isdefined(var_2be4351a) && isinarray(self.var_597e831d, var_2be4351a))
		{
			arrayremovevalue(self.var_597e831d, var_2be4351a);
		}
	}
	/#
	#/
}

/*
	Name: function_6c831509
	Namespace: zm_theater_achievements
	Checksum: 0x630E90CE
	Offset: 0x650
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_6c831509()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self.var_386853b6 = [];
	self.var_386853b6["zombie"] = 40;
	self.var_386853b6["zombie_quad"] = 20;
	self.var_386853b6["zombie_dog"] = 10;
	self waittill(#"hash_f5c9d74f");
	/#
	#/
}

/*
	Name: function_1abfde35
	Namespace: zm_theater_achievements
	Checksum: 0x3F9A6E84
	Offset: 0x6F0
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function function_1abfde35(e_attacker)
{
	if(isdefined(e_attacker) && e_attacker.target === "crematorium_room_trap" && isdefined(self.archetype) && isdefined(e_attacker.activated_by_player))
	{
		var_3500dd7a = e_attacker.activated_by_player;
		var_3500dd7a.var_386853b6[self.archetype]--;
		var_fc3072e7 = 1;
		foreach(n_targets in var_3500dd7a.var_386853b6)
		{
			if(n_targets > 0)
			{
				var_fc3072e7 = 0;
				break;
			}
		}
		if(var_fc3072e7 && isdefined(var_3500dd7a))
		{
			var_3500dd7a notify(#"hash_f5c9d74f");
		}
	}
}

