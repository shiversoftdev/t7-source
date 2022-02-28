// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_utility;

#namespace zm_aat_dead_wire;

/*
	Name: __init__sytem__
	Namespace: zm_aat_dead_wire
	Checksum: 0x2B13C541
	Offset: 0x290
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_dead_wire", &__init__, undefined, "aat");
}

/*
	Name: __init__
	Namespace: zm_aat_dead_wire
	Checksum: 0x4F38E0DA
	Offset: 0x2D0
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	aat::register("zm_aat_dead_wire", 0.2, 0, 5, 2, 1, &result, "t7_hud_zm_aat_deadwire", "wpn_aat_dead_wire_plr");
	clientfield::register("actor", "zm_aat_dead_wire" + "_zap", 1, 1, "int");
	clientfield::register("vehicle", "zm_aat_dead_wire" + "_zap_vehicle", 1, 1, "int");
	level.zm_aat_dead_wire_lightning_chain_params = lightning_chain::create_lightning_chain_params(8, 9, 120);
	level.zm_aat_dead_wire_lightning_chain_params.head_gib_chance = 100;
	level.zm_aat_dead_wire_lightning_chain_params.network_death_choke = 4;
	level.zm_aat_dead_wire_lightning_chain_params.challenge_stat_name = "ZOMBIE_HUNTER_DEAD_WIRE";
}

/*
	Name: result
	Namespace: zm_aat_dead_wire
	Checksum: 0x193C00A1
	Offset: 0x418
	Size: 0xCC
	Parameters: 4
	Flags: Linked
*/
function result(death, attacker, mod, weapon)
{
	if(!isdefined(level.zombie_vars["tesla_head_gib_chance"]))
	{
		zombie_utility::set_zombie_var("tesla_head_gib_chance", 50);
	}
	attacker.tesla_enemies = undefined;
	attacker.tesla_enemies_hit = 1;
	attacker.tesla_powerup_dropped = 0;
	attacker.tesla_arc_count = 0;
	level.zm_aat_dead_wire_lightning_chain_params.weapon = weapon;
	self lightning_chain::arc_damage(self, attacker, 1, level.zm_aat_dead_wire_lightning_chain_params);
}

