// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\abilities\gadgets\_gadget_armor;
#using scripts\shared\abilities\gadgets\_gadget_cacophany;
#using scripts\shared\abilities\gadgets\_gadget_camo;
#using scripts\shared\abilities\gadgets\_gadget_cleanse;
#using scripts\shared\abilities\gadgets\_gadget_clone;
#using scripts\shared\abilities\gadgets\_gadget_combat_efficiency;
#using scripts\shared\abilities\gadgets\_gadget_concussive_wave;
#using scripts\shared\abilities\gadgets\_gadget_es_strike;
#using scripts\shared\abilities\gadgets\_gadget_exo_breakdown;
#using scripts\shared\abilities\gadgets\_gadget_firefly_swarm;
#using scripts\shared\abilities\gadgets\_gadget_flashback;
#using scripts\shared\abilities\gadgets\_gadget_forced_malfunction;
#using scripts\shared\abilities\gadgets\_gadget_heat_wave;
#using scripts\shared\abilities\gadgets\_gadget_hero_weapon;
#using scripts\shared\abilities\gadgets\_gadget_iff_override;
#using scripts\shared\abilities\gadgets\_gadget_immolation;
#using scripts\shared\abilities\gadgets\_gadget_misdirection;
#using scripts\shared\abilities\gadgets\_gadget_mrpukey;
#using scripts\shared\abilities\gadgets\_gadget_other;
#using scripts\shared\abilities\gadgets\_gadget_overdrive;
#using scripts\shared\abilities\gadgets\_gadget_rapid_strike;
#using scripts\shared\abilities\gadgets\_gadget_ravage_core;
#using scripts\shared\abilities\gadgets\_gadget_resurrect;
#using scripts\shared\abilities\gadgets\_gadget_roulette;
#using scripts\shared\abilities\gadgets\_gadget_security_breach;
#using scripts\shared\abilities\gadgets\_gadget_sensory_overload;
#using scripts\shared\abilities\gadgets\_gadget_servo_shortout;
#using scripts\shared\abilities\gadgets\_gadget_shock_field;
#using scripts\shared\abilities\gadgets\_gadget_smokescreen;
#using scripts\shared\abilities\gadgets\_gadget_speed_burst;
#using scripts\shared\abilities\gadgets\_gadget_surge;
#using scripts\shared\abilities\gadgets\_gadget_system_overload;
#using scripts\shared\abilities\gadgets\_gadget_thief;
#using scripts\shared\abilities\gadgets\_gadget_unstoppable_force;
#using scripts\shared\abilities\gadgets\_gadget_vision_pulse;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\replay_gun;

#namespace ability_player;

/*
	Name: __init__sytem__
	Namespace: ability_player
	Checksum: 0x94EFCF07
	Offset: 0x9C8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ability_player", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ability_player
	Checksum: 0x99EC1590
	Offset: 0xA08
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

