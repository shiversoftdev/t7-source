// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_powerup_weapon_minigun;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0xAB254377
	Offset: 0x360
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_weapon_minigun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0x91D9045B
	Offset: 0x3A0
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_powerups::register_powerup("minigun", &grab_minigun);
	zm_powerups::register_powerup_weapon("minigun", &minigun_countdown);
	zm_powerups::powerup_set_prevent_pick_up_if_drinking("minigun", 1);
	zm_powerups::set_weapon_ignore_max_ammo("minigun");
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("minigun", "zombie_pickup_minigun", &"ZOMBIE_POWERUP_MINIGUN", &func_should_drop_minigun, 1, 0, 0, undefined, "powerup_mini_gun", "zombie_powerup_minigun_time", "zombie_powerup_minigun_on");
		level.zombie_powerup_weapon["minigun"] = getweapon("minigun");
	}
	callback::on_connect(&init_player_zombie_vars);
	zm::register_actor_damage_callback(&minigun_damage_adjust);
}

/*
	Name: grab_minigun
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0x76B7AB7A
	Offset: 0x530
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function grab_minigun(player)
{
	level thread minigun_weapon_powerup(player);
	player thread zm_powerups::powerup_vo("minigun");
	if(isdefined(level._grab_minigun))
	{
		level thread [[level._grab_minigun]](player);
	}
}

/*
	Name: init_player_zombie_vars
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0x83C26C6A
	Offset: 0x5A0
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function init_player_zombie_vars()
{
	self.zombie_vars["zombie_powerup_minigun_on"] = 0;
	self.zombie_vars["zombie_powerup_minigun_time"] = 0;
}

/*
	Name: func_should_drop_minigun
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0x82F7216B
	Offset: 0x5D8
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function func_should_drop_minigun()
{
	if(zm_powerups::minigun_no_drop())
	{
		return false;
	}
	return true;
}

/*
	Name: minigun_weapon_powerup
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0xD0AEF139
	Offset: 0x600
	Size: 0x22C
	Parameters: 2
	Flags: Linked
*/
function minigun_weapon_powerup(ent_player, time)
{
	ent_player endon(#"disconnect");
	ent_player endon(#"death");
	ent_player endon(#"player_downed");
	if(!isdefined(time))
	{
		time = 30;
	}
	if(isdefined(level._minigun_time_override))
	{
		time = level._minigun_time_override;
	}
	if(ent_player.zombie_vars["zombie_powerup_minigun_on"] && (level.zombie_powerup_weapon["minigun"] == ent_player getcurrentweapon() || (isdefined(ent_player.has_powerup_weapon["minigun"]) && ent_player.has_powerup_weapon["minigun"])))
	{
		if(ent_player.zombie_vars["zombie_powerup_minigun_time"] < time)
		{
			ent_player.zombie_vars["zombie_powerup_minigun_time"] = time;
		}
		return;
	}
	level._zombie_minigun_powerup_last_stand_func = &minigun_powerup_last_stand;
	stance_disabled = 0;
	if(ent_player getstance() === "prone")
	{
		ent_player allowcrouch(0);
		ent_player allowprone(0);
		stance_disabled = 1;
		while(ent_player getstance() != "stand")
		{
			wait(0.05);
		}
	}
	zm_powerups::weapon_powerup(ent_player, time, "minigun", 1);
	if(stance_disabled)
	{
		ent_player allowcrouch(1);
		ent_player allowprone(1);
	}
}

/*
	Name: minigun_powerup_last_stand
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0xB9E2C0F6
	Offset: 0x838
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function minigun_powerup_last_stand()
{
	zm_powerups::weapon_watch_gunner_downed("minigun");
}

/*
	Name: minigun_countdown
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0xCEBBA751
	Offset: 0x860
	Size: 0x6E
	Parameters: 2
	Flags: Linked
*/
function minigun_countdown(ent_player, str_weapon_time)
{
	while(ent_player.zombie_vars[str_weapon_time] > 0)
	{
		wait(0.05);
		ent_player.zombie_vars[str_weapon_time] = ent_player.zombie_vars[str_weapon_time] - 0.05;
	}
}

/*
	Name: minigun_weapon_powerup_off
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0x938B7360
	Offset: 0x8D8
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function minigun_weapon_powerup_off()
{
	self.zombie_vars["zombie_powerup_minigun_time"] = 0;
}

/*
	Name: minigun_damage_adjust
	Namespace: zm_powerup_weapon_minigun
	Checksum: 0x5D16575C
	Offset: 0x900
	Size: 0x186
	Parameters: 12
	Flags: Linked
*/
function minigun_damage_adjust(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(weapon.name != "minigun")
	{
		return -1;
	}
	if(self.archetype == "zombie" || self.archetype == "zombie_dog" || self.archetype == "zombie_quad")
	{
		n_percent_damage = self.health * randomfloatrange(0.34, 0.75);
	}
	if(isdefined(level.minigun_damage_adjust_override))
	{
		n_override_damage = thread [[level.minigun_damage_adjust_override]](inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype);
		if(isdefined(n_override_damage))
		{
			n_percent_damage = n_override_damage;
		}
	}
	if(isdefined(n_percent_damage))
	{
		damage = damage + n_percent_damage;
	}
	return damage;
}

