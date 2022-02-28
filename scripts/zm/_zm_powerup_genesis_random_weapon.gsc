// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_powerup_genesis_random_weapon;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_genesis_random_weapon
	Checksum: 0xE565D991
	Offset: 0x4E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_genesis_random_weapon", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_genesis_random_weapon
	Checksum: 0xE32E26B0
	Offset: 0x520
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "random_weap_fx", 15000, 1, "int");
	zm_powerups::register_powerup("genesis_random_weapon", &function_984a38e);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("genesis_random_weapon", "p7_zm_power_up_max_ammo", &"", &zm_powerups::func_should_never_drop, 1, 0, 0);
		zm_powerups::powerup_set_statless_powerup("genesis_random_weapon");
		zm_powerups::powerup_set_player_specific("genesis_random_weapon", 1);
	}
	/#
		if(getdvarint("") > 0)
		{
			level thread function_15732f56();
		}
	#/
}

/*
	Name: function_f99a1ed4
	Namespace: zm_powerup_genesis_random_weapon
	Checksum: 0x99EC1590
	Offset: 0x670
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function function_f99a1ed4()
{
}

/*
	Name: function_984a38e
	Namespace: zm_powerup_genesis_random_weapon
	Checksum: 0x77C9A73F
	Offset: 0x680
	Size: 0x674
	Parameters: 1
	Flags: Linked
*/
function function_984a38e(e_player)
{
	var_9b752db1 = [];
	if(level.var_42e19a0b === 1)
	{
		var_9b752db1[var_9b752db1.size] = getweapon("pistol_burst");
		var_9b752db1[var_9b752db1.size] = getweapon("ar_damage");
		var_9b752db1[var_9b752db1.size] = getweapon("launcher_standard");
		var_9b752db1[var_9b752db1.size] = getweapon("smg_burst");
		var_9b752db1[var_9b752db1.size] = getweapon("ray_gun");
		var_9b752db1[var_9b752db1.size] = getweapon("pistol_fullauto");
		var_9b752db1[var_9b752db1.size] = getweapon("ar_garand");
		var_9b752db1[var_9b752db1.size] = getweapon("smg_standard");
		var_9b752db1[var_9b752db1.size] = getweapon("ar_marksman");
	}
	if(level.var_42e19a0b === 2)
	{
		var_9b752db1[var_9b752db1.size] = getweapon("smg_capacity");
		var_9b752db1[var_9b752db1.size] = getweapon("smg_thompson");
		var_9b752db1[var_9b752db1.size] = getweapon("launcher_standard");
		var_9b752db1[var_9b752db1.size] = getweapon("lmg_light");
		var_9b752db1[var_9b752db1.size] = getweapon("ray_gun");
		var_9b752db1[var_9b752db1.size] = getweapon("shotgun_precision");
		var_9b752db1[var_9b752db1.size] = getweapon("ar_longburst");
		var_9b752db1[var_9b752db1.size] = getweapon("smg_fastfire");
		var_9b752db1[var_9b752db1.size] = getweapon("smg_longrange");
		var_9b752db1[var_9b752db1.size] = getweapon("smg_versatile");
		var_9b752db1[var_9b752db1.size] = getweapon("shotgun_semiauto");
	}
	if(level.var_42e19a0b === 3)
	{
		var_9b752db1[var_9b752db1.size] = getweapon("pistol_shotgun_dw");
		var_9b752db1[var_9b752db1.size] = getweapon("launcher_standard");
		var_9b752db1[var_9b752db1.size] = getweapon("ray_gun");
		var_9b752db1[var_9b752db1.size] = getweapon("lmg_slowfire");
		var_9b752db1[var_9b752db1.size] = getweapon("shotgun_fullauto");
		var_9b752db1[var_9b752db1.size] = getweapon("ar_cqb");
		var_9b752db1[var_9b752db1.size] = getweapon("lmg_heavy");
		var_9b752db1[var_9b752db1.size] = getweapon("lmg_cqb");
		var_9b752db1[var_9b752db1.size] = getweapon("ar_standard");
		var_9b752db1[var_9b752db1.size] = getweapon("ar_standard");
	}
	w_weapon = array::random(var_9b752db1);
	if(w_weapon == e_player getcurrentweapon())
	{
		level thread function_984a38e(e_player);
		return;
	}
	e_player notify(#"hash_31471387");
	var_1d7eacf9 = e_player getcurrentweapon();
	if(var_1d7eacf9 != getweapon("knife") && var_1d7eacf9 != getweapon("bowie_knife") && var_1d7eacf9 != getweapon("knife_widows_wine"))
	{
		e_player takeweapon(var_1d7eacf9);
	}
	e_player zm_weapons::weapon_give(w_weapon, 0, 0, 1);
	wait(0.1);
	e_player setweaponammostock(w_weapon, int(w_weapon.maxammo * 0.3));
}

/*
	Name: function_89d232d2
	Namespace: zm_powerup_genesis_random_weapon
	Checksum: 0x8B5028CF
	Offset: 0xD00
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function function_89d232d2()
{
	self endon(#"powerup_grabbed");
	self endon(#"death");
	self endon(#"powerup_reset");
	self zm_powerups::powerup_show(1);
}

/*
	Name: function_15732f56
	Namespace: zm_powerup_genesis_random_weapon
	Checksum: 0x22D31693
	Offset: 0xD48
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_15732f56()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_9677023e);
		adddebugcommand("");
	#/
}

/*
	Name: function_9677023e
	Namespace: zm_powerup_genesis_random_weapon
	Checksum: 0x2A273BE5
	Offset: 0xDB8
	Size: 0xA2
	Parameters: 1
	Flags: Linked
*/
function function_9677023e(cmd)
{
	/#
		var_c533fd32 = 0;
		switch(cmd)
		{
			case "":
			{
				var_30fbd0e8 = level thread zm_powerups::specific_powerup_drop("", level.players[0].origin + vectorscale((0, 1, 0), 80), undefined, undefined, undefined, level.players[0]);
				return 1;
			}
		}
		return var_c533fd32;
	#/
}

