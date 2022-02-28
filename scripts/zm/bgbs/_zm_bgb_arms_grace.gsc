// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_bgb_arms_grace;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_arms_grace
	Checksum: 0xA0B58439
	Offset: 0x1E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_arms_grace", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_arms_grace
	Checksum: 0x6FAA7CB9
	Offset: 0x228
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_arms_grace", "event", &event, undefined, undefined, undefined);
	level.givestartloadout = &givestartloadout;
}

/*
	Name: event
	Namespace: zm_bgb_arms_grace
	Checksum: 0x38795B6C
	Offset: 0x2A0
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function event()
{
	self endon(#"disconnect");
	self endon(#"bgb_update");
	self waittill(#"bgb_about_to_take_on_bled_out");
	self bgb::do_one_shot_use(1);
	self.var_e445bfc6 = 1;
}

/*
	Name: givestartloadout
	Namespace: zm_bgb_arms_grace
	Checksum: 0x43BEADFE
	Offset: 0x2F8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function givestartloadout()
{
	if(isdefined(self.var_e445bfc6) && self.var_e445bfc6)
	{
		self.var_e445bfc6 = 0;
		function_f1adaf91(self);
	}
	else if(isdefined(level.givecustomloadout))
	{
		self [[level.givecustomloadout]]();
	}
}

/*
	Name: function_f1adaf91
	Namespace: zm_bgb_arms_grace
	Checksum: 0x9C90067D
	Offset: 0x360
	Size: 0x35C
	Parameters: 1
	Flags: Linked
*/
function function_f1adaf91(player)
{
	var_f49711f9 = player getcurrentweapon();
	weapon_limit = zm_utility::get_player_weapon_limit(player);
	var_a430f97e = 0;
	weapon_switched = 0;
	pap_triggers = zm_pap_util::get_triggers();
	ray_gun_weapon = getweapon("ray_gun");
	var_52633155 = 0;
	player giveweapon(level.weaponbasemelee);
	if(isdefined(player.laststandprimaryweapons))
	{
		var_f0e082e = 0;
		foreach(weapon in player.laststandprimaryweapons)
		{
			if(weapon.isprimary)
			{
				if(ray_gun_weapon == zm_weapons::get_base_weapon(weapon))
				{
					var_f0e082e = 1;
					break;
				}
			}
		}
		foreach(weapon in player.laststandprimaryweapons)
		{
			if(weapon == var_f49711f9)
			{
				continue;
			}
			if(weapon.isprimary)
			{
				var_cbbc46c5 = undefined;
				w_base = zm_weapons::get_base_weapon(weapon);
				if(!zm_weapons::limited_weapon_below_quota(w_base, player, pap_triggers) && weapon != level.start_weapon)
				{
					if(!var_52633155)
					{
						if(!var_f0e082e && !player zm_weapons::has_weapon_or_upgrade(ray_gun_weapon))
						{
							var_cbbc46c5 = ray_gun_weapon;
							var_52633155 = 1;
						}
					}
				}
				else
				{
					var_cbbc46c5 = weapon;
				}
				if(isdefined(var_cbbc46c5))
				{
					player zm_weapons::weapon_give(var_cbbc46c5, 0, 0, 1, !weapon_switched);
					var_a430f97e++;
					weapon_switched = 1;
				}
			}
			if(weapon_limit <= var_a430f97e)
			{
				break;
			}
		}
	}
}

