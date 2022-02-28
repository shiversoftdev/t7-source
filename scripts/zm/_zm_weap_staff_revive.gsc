// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_weap_staff_common;

#namespace zm_weap_staff_revive;

/*
	Name: __init__sytem__
	Namespace: zm_weap_staff_revive
	Checksum: 0x266FE419
	Offset: 0x260
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_staff_revive", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_staff_revive
	Checksum: 0xB5506179
	Offset: 0x2A0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_spawned(&onplayerspawned);
}

/*
	Name: onplayerspawned
	Namespace: zm_weap_staff_revive
	Checksum: 0x30301E9A
	Offset: 0x2D0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function onplayerspawned()
{
	self endon(#"disconnect");
	self thread watch_staff_revive_fired();
}

/*
	Name: watch_staff_revive_fired
	Namespace: zm_weap_staff_revive
	Checksum: 0x631868F
	Offset: 0x300
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function watch_staff_revive_fired()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"missile_fire", e_projectile, str_weapon);
		if(!str_weapon.name == "staff_revive")
		{
			continue;
		}
		self waittill(#"projectile_impact", e_ent, v_explode_point, n_radius, str_name, n_impact);
		self thread staff_revive_impact(v_explode_point);
	}
}

/*
	Name: staff_revive_impact
	Namespace: zm_weap_staff_revive
	Checksum: 0xDAF0C075
	Offset: 0x3C8
	Size: 0x19A
	Parameters: 1
	Flags: Linked
*/
function staff_revive_impact(v_explode_point)
{
	self endon(#"disconnect");
	e_closest_player = undefined;
	n_closest_dist_sq = 1024;
	playsoundatposition("wpn_revivestaff_proj_impact", v_explode_point);
	a_e_players = getplayers();
	foreach(e_player in a_e_players)
	{
		if(e_player == self || !e_player laststand::player_is_in_laststand())
		{
			continue;
		}
		n_dist_sq = distancesquared(v_explode_point, e_player.origin);
		if(n_dist_sq < n_closest_dist_sq)
		{
			e_closest_player = e_player;
		}
	}
	if(isdefined(e_closest_player))
	{
		e_closest_player notify(#"remote_revive", self);
		e_closest_player playsoundtoplayer("wpn_revivestaff_revive_plr", e_player);
		self notify(#"revived_player_with_upgraded_staff");
	}
}

