// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_stalingrad_achievements;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_achievements
	Checksum: 0x585FCE64
	Offset: 0x238
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_achievements", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_achievements
	Checksum: 0xEA67B9D9
	Offset: 0x278
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level thread function_73d8758f();
	level thread function_42b2ae41();
	callback::on_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: zm_stalingrad_achievements
	Checksum: 0xA6044A79
	Offset: 0x2D8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread function_69021ea7();
	self thread function_35e5c39b();
	self thread function_68cad44c();
	self thread function_77f84ddb();
	self thread function_3a3c9cc6();
	self thread function_b6e817dd();
	self thread function_bdcf8e90();
	self thread function_54dbe534();
}

/*
	Name: function_73d8758f
	Namespace: zm_stalingrad_achievements
	Checksum: 0xA321952E
	Offset: 0x3A8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_73d8758f()
{
	level waittill(#"hash_c1471acf");
	array::run_all(level.players, &giveachievement, "ZM_STALINGRAD_NIKOLAI");
}

/*
	Name: function_69021ea7
	Namespace: zm_stalingrad_achievements
	Checksum: 0xBEB66235
	Offset: 0x3F8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_69021ea7()
{
	self endon(#"death");
	self waittill(#"hash_4e21f047");
	self giveachievement("ZM_STALINGRAD_WIELD_DRAGON");
}

/*
	Name: function_42b2ae41
	Namespace: zm_stalingrad_achievements
	Checksum: 0x367D7C03
	Offset: 0x440
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_42b2ae41()
{
	level waittill(#"hash_399599c1");
	array::run_all(level.players, &giveachievement, "ZM_STALINGRAD_TWENTY_ROUNDS");
}

/*
	Name: function_35e5c39b
	Namespace: zm_stalingrad_achievements
	Checksum: 0x3C8FA777
	Offset: 0x490
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_35e5c39b()
{
	self endon(#"death");
	self waittill(#"hash_2e47bc4a");
	self giveachievement("ZM_STALINGRAD_RIDE_DRAGON");
}

/*
	Name: function_68cad44c
	Namespace: zm_stalingrad_achievements
	Checksum: 0xDC7C9333
	Offset: 0x4D8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_68cad44c()
{
	self endon(#"death");
	self waittill(#"hash_1d89afbc");
	self giveachievement("ZM_STALINGRAD_LOCKDOWN");
}

/*
	Name: function_77f84ddb
	Namespace: zm_stalingrad_achievements
	Checksum: 0xBC007367
	Offset: 0x520
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_77f84ddb()
{
	self endon(#"death");
	self waittill(#"hash_41370469");
	self giveachievement("ZM_STALINGRAD_SOLO_TRIALS");
}

/*
	Name: function_3a3c9cc6
	Namespace: zm_stalingrad_achievements
	Checksum: 0xBC451B59
	Offset: 0x568
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function function_3a3c9cc6()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"hash_c925c266", n_kill_count);
		if(n_kill_count >= 20)
		{
			self giveachievement("ZM_STALINGRAD_BEAM_KILL");
			return;
		}
	}
}

/*
	Name: function_b6e817dd
	Namespace: zm_stalingrad_achievements
	Checksum: 0x45CCA3B4
	Offset: 0x5E0
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function function_b6e817dd()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"hash_ddb84fad", n_kill_count);
		if(n_kill_count >= 8)
		{
			self giveachievement("ZM_STALINGRAD_STRIKE_DRAGON");
			return;
		}
	}
}

/*
	Name: function_bdcf8e90
	Namespace: zm_stalingrad_achievements
	Checksum: 0x8B84FE90
	Offset: 0x658
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function function_bdcf8e90()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"hash_8c80a390", n_kill_count);
		if(n_kill_count >= 10)
		{
			self giveachievement("ZM_STALINGRAD_FAFNIR_KILL");
			return;
		}
	}
}

/*
	Name: function_54dbe534
	Namespace: zm_stalingrad_achievements
	Checksum: 0xB2E9EACD
	Offset: 0x6D0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_54dbe534()
{
	self thread function_99a5ed1a(10);
	self thread function_60593db9(10);
}

/*
	Name: function_99a5ed1a
	Namespace: zm_stalingrad_achievements
	Checksum: 0xB42D02C0
	Offset: 0x718
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function function_99a5ed1a(n_target_kills)
{
	self endon(#"death");
	self endon(#"hash_c43b59a6");
	while(true)
	{
		self waittill(#"hash_e442448", n_kill_count);
		if(n_kill_count >= n_target_kills)
		{
			self giveachievement("ZM_STALINGRAD_AIR_ZOMBIES");
			self notify(#"hash_c43b59a6");
		}
	}
}

/*
	Name: function_60593db9
	Namespace: zm_stalingrad_achievements
	Checksum: 0xF2CC378B
	Offset: 0x7A0
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function function_60593db9(n_target_kills)
{
	self endon(#"death");
	self endon(#"hash_c43b59a6");
	while(true)
	{
		self waittill(#"hash_f7608efe", n_kill_count);
		if(n_kill_count >= n_target_kills)
		{
			self giveachievement("ZM_STALINGRAD_AIR_ZOMBIES");
			self notify(#"hash_c43b59a6");
		}
	}
}

