// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#namespace zm_stalingrad_timer;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_timer
	Checksum: 0x744B49DE
	Offset: 0x360
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_timer", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_timer
	Checksum: 0x99EC1590
	Offset: 0x3A8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: zm_stalingrad_timer
	Checksum: 0xFEC4A344
	Offset: 0x3B8
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	clientfield::register("world", "time_attack_reward", 12000, 3, "int");
	level flag::init("time_attack_weapon_awarded");
	level flag::wait_till("start_zombie_round_logic");
	foreach(s_wallbuy in level._spawned_wallbuys)
	{
		if(s_wallbuy.zombie_weapon_upgrade == "melee_wrench")
		{
			level.var_b9f3bf28 = s_wallbuy;
			level.var_b9f3bf28.trigger_stub.prompt_and_visibility_func = &function_6ac3689a;
			break;
		}
	}
	level thread function_86419da();
}

/*
	Name: function_6ac3689a
	Namespace: zm_stalingrad_timer
	Checksum: 0x54E521E1
	Offset: 0x510
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function function_6ac3689a(player)
{
	if(player zm_magicbox::can_buy_weapon() && !player bgb::is_enabled("zm_bgb_disorderly_combat") && level flag::get("time_attack_weapon_awarded"))
	{
		self setvisibletoplayer(player);
		self.stub.hint_string = zm_weapons::get_weapon_hint(self.weapon);
		self sethintstring(self.stub.hint_string);
		return true;
	}
	self setinvisibletoplayer(player);
	return false;
}

/*
	Name: function_86419da
	Namespace: zm_stalingrad_timer
	Checksum: 0x3BE65786
	Offset: 0x608
	Size: 0x3BC
	Parameters: 0
	Flags: Linked
*/
function function_86419da()
{
	do
	{
		level waittill(#"end_of_round");
		n_current_time = (gettime() - level.n_gameplay_start_time) / 1000;
		var_99870abd = zm::get_round_number() - 1;
		var_ec31aba8 = undefined;
		switch(var_99870abd)
		{
			case 5:
			{
				switch(level.players.size)
				{
					case 1:
					{
						var_ec31aba8 = 300;
						break;
					}
					case 2:
					{
						var_ec31aba8 = 270;
						break;
					}
					case 3:
					{
						var_ec31aba8 = 250;
						break;
					}
					case 4:
					{
						var_ec31aba8 = 240;
						break;
					}
				}
				jump loc_0000075C;
			}
			case 10:
			{
				switch(level.players.size)
				{
					case 1:
					{
						var_ec31aba8 = 780;
						break;
					}
					case 2:
					{
						var_ec31aba8 = 720;
						break;
					}
					case 3:
					{
						var_ec31aba8 = 670;
						break;
					}
					case 4:
					{
						var_ec31aba8 = 660;
						break;
					}
				}
				loc_0000075C:
				jump loc_000007D0;
			}
			case 15:
			{
				switch(level.players.size)
				{
					case 1:
					{
						var_ec31aba8 = 1440;
						break;
					}
					case 2:
					{
						var_ec31aba8 = 1200;
						break;
					}
					case 3:
					{
						var_ec31aba8 = 1020;
						break;
					}
					case 4:
					{
						var_ec31aba8 = 960;
						break;
					}
				}
				loc_000007D0:
				jump loc_00000844;
			}
			case 20:
			{
				switch(level.players.size)
				{
					case 1:
					{
						var_ec31aba8 = 1920;
						break;
					}
					case 2:
					{
						var_ec31aba8 = 1800;
						break;
					}
					case 3:
					{
						var_ec31aba8 = 1740;
						break;
					}
					case 4:
					{
						var_ec31aba8 = 1680;
						break;
					}
				}
				loc_00000844:
				jump loc_000008B8;
			}
			case 50:
			{
				switch(level.players.size)
				{
					case 1:
					{
						var_ec31aba8 = 1920;
						break;
					}
					case 2:
					{
						var_ec31aba8 = 1800;
						break;
					}
					case 3:
					{
						var_ec31aba8 = 1740;
						break;
					}
					case 4:
					{
						var_ec31aba8 = 1680;
						break;
					}
				}
				loc_000008B8:
				break;
			}
			default:
			{
				break;
			}
		}
		if((var_99870abd % 5) == 0)
		{
			if(isdefined(var_ec31aba8) && n_current_time < var_ec31aba8)
			{
				luinotifyevent(&"zombie_time_attack_notification", 2, zm::get_round_number() - 1, level.players.size);
				playsoundatposition("zmb_stalingrad_time_trial_complete", (0, 0, 0));
				level thread function_cc8ae246(var_99870abd);
				if(var_99870abd == 20)
				{
					level notify(#"hash_399599c1");
				}
			}
		}
	}
	while(var_99870abd < 50);
}

/*
	Name: function_cc8ae246
	Namespace: zm_stalingrad_timer
	Checksum: 0x6B3E463
	Offset: 0x9D0
	Size: 0x26C
	Parameters: 1
	Flags: Linked
*/
function function_cc8ae246(str_reward)
{
	switch(str_reward)
	{
		case 5:
		{
			str_weapon = "melee_wrench";
			var_31fcdfe3 = 1;
			break;
		}
		case 10:
		{
			str_weapon = "melee_dagger";
			var_31fcdfe3 = 2;
			break;
		}
		case 15:
		{
			str_weapon = "melee_fireaxe";
			var_31fcdfe3 = 3;
			break;
		}
		case 20:
		{
			str_weapon = "melee_sword";
			var_31fcdfe3 = 4;
			break;
		}
		case 50:
		{
			str_weapon = "melee_daisho";
			var_31fcdfe3 = 5;
			level.var_b9f3bf28.var_5cf530a8 = &"ZM_STALINGRAD_EE_WONDERWEAPON";
			break;
		}
	}
	weapon = getweapon(str_weapon);
	level.var_b9f3bf28.zombie_weapon_upgrade = str_weapon;
	level.var_b9f3bf28.weapon = weapon;
	level.var_b9f3bf28.trigger_stub.weapon = weapon;
	level.var_b9f3bf28.trigger_stub.cursor_hint_weapon = weapon;
	clientfield::set(level.var_b9f3bf28.trigger_stub.clientfieldname, 0);
	level clientfield::set("time_attack_reward", var_31fcdfe3);
	util::wait_network_frame();
	clientfield::set(level.var_b9f3bf28.trigger_stub.clientfieldname, 2);
	util::wait_network_frame();
	clientfield::set(level.var_b9f3bf28.trigger_stub.clientfieldname, 1);
	level flag::set("time_attack_weapon_awarded");
}

/*
	Name: function_3d5b5002
	Namespace: zm_stalingrad_timer
	Checksum: 0xD2A28F06
	Offset: 0xC48
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_3d5b5002()
{
	switch(level.players.size)
	{
		case 1:
		{
			var_ec31aba8 = 6000;
			break;
		}
		case 2:
		{
			var_ec31aba8 = 5340;
			break;
		}
		case 3:
		{
			var_ec31aba8 = 4980;
			break;
		}
		case 4:
		{
			var_ec31aba8 = 4800;
			break;
		}
	}
	if(level.var_2801f599 < var_ec31aba8)
	{
		level.perk_purchase_limit = level._custom_perks.size;
		callback::on_spawned(&on_player_spawned);
		array::thread_all(level.players, &function_959f59b8);
	}
}

/*
	Name: on_player_spawned
	Namespace: zm_stalingrad_timer
	Checksum: 0x88CCF2D6
	Offset: 0xD38
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread function_88b9bf27();
}

/*
	Name: function_88b9bf27
	Namespace: zm_stalingrad_timer
	Checksum: 0x6217008D
	Offset: 0xD60
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_88b9bf27()
{
	if(!isdefined(self.num_perks))
	{
		wait(0.1);
	}
	self zm_utility::give_player_all_perks();
}

/*
	Name: function_959f59b8
	Namespace: zm_stalingrad_timer
	Checksum: 0x75B3CE55
	Offset: 0xD98
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_959f59b8()
{
	self endon(#"disconnect");
	while(isdefined(self))
	{
		self waittill(#"player_revived");
		b_exclude_quick_revive = level.players.size == 1;
		self zm_utility::give_player_all_perks(b_exclude_quick_revive);
	}
}

