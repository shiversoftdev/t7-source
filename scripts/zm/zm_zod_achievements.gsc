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
#using scripts\zm\zm_zod_util;

#namespace namespace_e2600f27;

/*
	Name: __init__sytem__
	Namespace: namespace_e2600f27
	Checksum: 0xED352723
	Offset: 0x3E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("zm_zod_achievements", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_e2600f27
	Checksum: 0x1F1FE2E7
	Offset: 0x428
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level thread function_36ffe1d1();
	callback::on_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: namespace_e2600f27
	Checksum: 0xA33C22A7
	Offset: 0x470
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread function_ea06cc8c();
	self thread function_f50b1960();
	self thread function_46ea87bb();
	self thread function_b9e36150();
	self thread function_f10a087d();
	self thread function_47cc3ddf();
	self thread function_1f3cbfd1();
	self thread function_d7f7b38b();
}

/*
	Name: function_fc2e6576
	Namespace: namespace_e2600f27
	Checksum: 0x11FFE48B
	Offset: 0x540
	Size: 0x96
	Parameters: 0
	Flags: None
*/
function function_fc2e6576()
{
	level endon(#"end_game");
	level flag::wait_till("ritual_pap_complete");
	a_players = getplayers();
	for(i = 0; i < a_players.size; i++)
	{
		a_players[i] giveachievement("ZM_HELP_OTHERS");
	}
}

/*
	Name: function_36ffe1d1
	Namespace: namespace_e2600f27
	Checksum: 0xC537034A
	Offset: 0x5E0
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function function_36ffe1d1()
{
	level endon(#"end_game");
	a_str_ritual_flags = array("ritual_boxer_complete", "ritual_detective_complete", "ritual_femme_complete", "ritual_magician_complete");
	level flag::wait_till_all(a_str_ritual_flags);
	a_players = getplayers();
	for(i = 0; i < a_players.size; i++)
	{
		a_players[i] giveachievement("ZM_COMPLETE_RITUALS");
	}
}

/*
	Name: function_ea06cc8c
	Namespace: namespace_e2600f27
	Checksum: 0xF0876C1B
	Offset: 0x6B8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_ea06cc8c()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	for(var_66f8342 = 0; var_66f8342 < 5; var_66f8342++)
	{
		self waittill(#"hash_86ef5199");
	}
	self giveachievement("ZM_SPOT_SHADOWMAN");
}

/*
	Name: function_f50b1960
	Namespace: namespace_e2600f27
	Checksum: 0xE1A8AEBC
	Offset: 0x730
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_f50b1960()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	while(var_a49e2257.size < 5)
	{
		self waittill(#"bgb_update");
		str_name = self.bgb;
		found = 0;
		for(i = 0; i < var_a49e2257.size; i++)
		{
			if(var_a49e2257[i] == str_name)
			{
				found = 1;
				break;
			}
		}
		if(!found)
		{
			array::add(var_a49e2257, str_name);
		}
	}
	self giveachievement("ZM_GOBBLE_GUM");
}

/*
	Name: function_46ea87bb
	Namespace: namespace_e2600f27
	Checksum: 0xF78CB1F9
	Offset: 0x838
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_46ea87bb()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	while(var_fce7f186 < 10)
	{
		self waittill(#"zombie_death_params", var_7ef6d493, var_c3f7e0ed);
		if(isdefined(var_7ef6d493) && isstring(var_7ef6d493) && var_7ef6d493 == "zod_store")
		{
			if(!var_c3f7e0ed)
			{
				var_fce7f186++;
			}
		}
	}
	self giveachievement("ZM_STORE_KILL");
}

/*
	Name: function_b9e36150
	Namespace: namespace_e2600f27
	Checksum: 0xB62628CB
	Offset: 0x900
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_b9e36150()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	while(1)
	{
		self waittill(#"hash_4438d786", var_c2faf069);
		if(var_c2faf069 >= 10)
		{
			break;
		}
	}
	self giveachievement("ZM_ROCKET_SHIELD_KILL");
}

/*
	Name: function_f10a087d
	Namespace: namespace_e2600f27
	Checksum: 0x7568DCD
	Offset: 0x978
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function function_f10a087d()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	var_edf7e9c1 = 0;
	var_5c366274 = 0;
	var_6ca52f65 = 0;
	var_aa482c3 = 0;
	while(var_edf7e9c1 < 4)
	{
		self waittill(#"hash_b7f8e77c");
		var_9b0b20f3 = level.zones[self.zone_name].district;
		if(!var_5c366274 && var_9b0b20f3 == "junction")
		{
			var_5c366274 = 1;
			var_edf7e9c1++;
		}
		else if(!var_6ca52f65 && var_9b0b20f3 == "canal")
		{
			var_6ca52f65 = 1;
			var_edf7e9c1++;
		}
		else if(!var_aa482c3 && var_9b0b20f3 == "theater")
		{
			var_aa482c3 = 1;
			var_edf7e9c1++;
		}
		else if(!var_2c8c3602 && var_9b0b20f3 == "slums")
		{
			var_2c8c3602 = 1;
			var_edf7e9c1++;
		}
	}
	self giveachievement("ZM_CIVIL_PROTECTOR");
}

/*
	Name: function_47cc3ddf
	Namespace: namespace_e2600f27
	Checksum: 0x607ACDC4
	Offset: 0xB10
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_47cc3ddf()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	while(var_fce7f186 < 10)
	{
		self waittill(#"widows_wine_kill", var_190c9827);
		if(isdefined(var_190c9827) && var_190c9827 == self)
		{
			var_fce7f186++;
		}
	}
	self giveachievement("ZM_WINE_GRENADE_KILL");
}

/*
	Name: function_1f3cbfd1
	Namespace: namespace_e2600f27
	Checksum: 0x8B9FF6C1
	Offset: 0xBA8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_1f3cbfd1()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	while(1)
	{
		self waittill(#"margwa_kill");
		if(var_b8ac8cce == 0)
		{
			var_a07758ed = level.round_number;
		}
		else if(var_a07758ed != level.round_number)
		{
			var_a07758ed = level.round_number;
			var_b8ac8cce = 0;
		}
		var_b8ac8cce++;
		if(var_b8ac8cce == 2)
		{
			break;
		}
	}
	self giveachievement("ZM_MARGWA_KILL");
}

/*
	Name: function_d7f7b38b
	Namespace: namespace_e2600f27
	Checksum: 0xE08CE765
	Offset: 0xC78
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_d7f7b38b()
{
	level endon(#"end_game");
	self endon(#"disconnect");
	for(var_fce7f186 = 0; var_fce7f186 < 5; var_fce7f186++)
	{
		self waittill(#"wasp_train_kill");
	}
	self giveachievement("ZM_PARASITE_KILL");
}

