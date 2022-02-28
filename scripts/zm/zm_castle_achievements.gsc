// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace castle_achievements;

/*
	Name: __init__sytem__
	Namespace: castle_achievements
	Checksum: 0x68DAC2C3
	Offset: 0x3F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_achievements", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: castle_achievements
	Checksum: 0xE01B4A82
	Offset: 0x438
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level thread function_c190d113();
	level thread function_a7a00809();
	callback::on_connect(&on_player_connect);
	zm_spawner::register_zombie_death_event_callback(&function_1abfde35);
}

/*
	Name: on_player_connect
	Namespace: castle_achievements
	Checksum: 0x309766F3
	Offset: 0x4B8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread function_a54c1d45();
	self thread function_abd6b408();
	self thread function_2ac65a0e();
	self thread function_2aca0270();
	self thread function_763e50f3();
	self thread function_ed9679c1();
	self thread function_fd055c44();
	self thread function_2ec19399();
}

/*
	Name: function_c190d113
	Namespace: castle_achievements
	Checksum: 0xC0A8ABE8
	Offset: 0x588
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_c190d113()
{
	level waittill(#"hash_b39ccbbf");
	array::run_all(level.players, &giveachievement, "ZM_CASTLE_EE");
}

/*
	Name: function_a7a00809
	Namespace: castle_achievements
	Checksum: 0xFE219CCF
	Offset: 0x5D8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_a7a00809()
{
	for(i = 0; i < 4; i++)
	{
		level waittill(#"hash_ea0c887b");
	}
	array::run_all(level.players, &giveachievement, "ZM_CASTLE_ALL_BOWS");
}

/*
	Name: function_a54c1d45
	Namespace: castle_achievements
	Checksum: 0xC8F1D473
	Offset: 0x650
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_a54c1d45()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	var_16939907 = [];
	var_16939907["lower_courtyard_flinger"] = 0;
	var_16939907["v10_rocket_pad_flinger"] = 0;
	var_16939907["roof_flinger"] = 0;
	var_16939907["upper_courtyard_flinger"] = 0;
	while(true)
	{
		str_notify = util::waittill_any_return("disconnect", "lower_courtyard_flinger", "v10_rocket_pad_flinger", "roof_flinger", "upper_courtyard_flinger");
		var_16939907[str_notify]++;
		if(var_16939907["lower_courtyard_flinger"] > 1 && var_16939907["v10_rocket_pad_flinger"] > 1 && var_16939907["roof_flinger"] > 1 && var_16939907["upper_courtyard_flinger"] > 1)
		{
			break;
		}
	}
	self giveachievement("ZM_CASTLE_WUNDER_TOURIST");
}

/*
	Name: function_abd6b408
	Namespace: castle_achievements
	Checksum: 0x21E1AB6B
	Offset: 0x7A0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_abd6b408()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self waittill(#"hash_f00d390e");
	self giveachievement("ZM_CASTLE_WUNDER_SNIPER");
}

/*
	Name: function_2ac65a0e
	Namespace: castle_achievements
	Checksum: 0x82A77276
	Offset: 0x7F0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_2ac65a0e()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	while(true)
	{
		level waittill(#"weapon_bought", player, weapon);
		if(player == self && weapon.name == "lmg_light")
		{
			break;
		}
	}
	self giveachievement("ZM_CASTLE_WALL_RUNNER");
}

/*
	Name: function_2aca0270
	Namespace: castle_achievements
	Checksum: 0xDB3E7BFD
	Offset: 0x890
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_2aca0270()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self.zapped_zombies = 0;
	while(self.zapped_zombies < 121)
	{
		self waittill(#"zombie_zapped");
	}
	self giveachievement("ZM_CASTLE_ELECTROCUTIONER");
}

/*
	Name: function_763e50f3
	Namespace: castle_achievements
	Checksum: 0x2ACD5755
	Offset: 0x900
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_763e50f3()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self waittill(#"hash_a72ebab5");
	self giveachievement("ZM_CASTLE_MECH_TRAPPER");
}

/*
	Name: function_ed9679c1
	Namespace: castle_achievements
	Checksum: 0xBB595704
	Offset: 0x950
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_ed9679c1()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self waittill(#"hash_ea0c887b");
	self giveachievement("ZM_CASTLE_UPGRADED_BOW");
}

/*
	Name: function_fd055c44
	Namespace: castle_achievements
	Checksum: 0x5D865042
	Offset: 0x9A0
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_fd055c44()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	var_8a655363 = 0;
	while(true)
	{
		self waittill(#"player_did_a_revive");
		foreach(e_player in level.players)
		{
			if(isdefined(e_player.b_gravity_trap_spikes_in_ground) && e_player.b_gravity_trap_spikes_in_ground && e_player.gravityspikes_state === 3)
			{
				var_d0dad0be = distance(self.origin, e_player.mdl_gravity_trap_fx_source.origin);
				if(var_d0dad0be <= 256)
				{
					var_8a655363++;
					break;
				}
			}
		}
		if(var_8a655363 > 1)
		{
			break;
		}
	}
	self giveachievement("ZM_CASTLE_SPIKE_REVIVE");
}

/*
	Name: function_2ec19399
	Namespace: castle_achievements
	Checksum: 0xF8C75C72
	Offset: 0xB20
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_2ec19399()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	self.var_544cf8c7 = [];
	self.var_544cf8c7[0] = "mechz";
	self.var_544cf8c7[1] = "zombie";
	self.var_544cf8c7[2] = "sparky";
	self.var_544cf8c7[3] = "napalm";
	self thread function_a0e4a574();
}

/*
	Name: function_a0e4a574
	Namespace: castle_achievements
	Checksum: 0x7710D64A
	Offset: 0xBC0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_a0e4a574()
{
	do
	{
		self waittill(#"hash_430cbeac");
	}
	while(self.var_544cf8c7.size > 0);
	self giveachievement("ZM_CASTLE_MINIGUN_MURDER");
}

/*
	Name: function_1abfde35
	Namespace: castle_achievements
	Checksum: 0x11EC1EE
	Offset: 0xC08
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function function_1abfde35(e_attacker)
{
	if(isdefined(e_attacker.is_flung) && e_attacker.is_flung)
	{
		e_attacker notify(#"hash_f00d390e");
	}
	if(issubstr(self.damageweapon.name, "minigun") && isdefined(e_attacker.var_544cf8c7))
	{
		if(isdefined(self.var_9a02a614))
		{
			arrayremovevalue(e_attacker.var_544cf8c7, self.var_9a02a614);
		}
		else
		{
			arrayremovevalue(e_attacker.var_544cf8c7, self.archetype);
		}
		e_attacker notify(#"hash_430cbeac");
	}
}

