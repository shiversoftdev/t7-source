// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_altbody_beast;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#using_animtree("generic");

#namespace zm_zod_transformer;

/*
	Name: __init__sytem__
	Namespace: zm_zod_transformer
	Checksum: 0xCFE6EE67
	Offset: 0x318
	Size: 0x2C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_transformer", undefined, &__main__, undefined);
}

/*
	Name: __main__
	Namespace: zm_zod_transformer
	Checksum: 0x896F7415
	Offset: 0x350
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	n_bits = getminbitcountfornum(16);
	clientfield::register("scriptmover", "transformer_light_switch", 1, n_bits, "int");
	level thread init_transformers();
}

/*
	Name: init_transformers
	Namespace: zm_zod_transformer
	Checksum: 0xB15D153A
	Offset: 0x3D0
	Size: 0x132
	Parameters: 0
	Flags: Linked
*/
function init_transformers()
{
	level flag::wait_till("all_players_spawned");
	level flag::wait_till("zones_initialized");
	var_38d937f = getentarray("use_elec_switch", "targetname");
	foreach(var_b46b59df in var_38d937f)
	{
		var_677edb82 = getent(var_b46b59df.target, "targetname");
		var_677edb82 thread transformer_think(var_b46b59df);
		wait(0.05);
	}
}

/*
	Name: transformer_think
	Namespace: zm_zod_transformer
	Checksum: 0xD720BC3B
	Offset: 0x510
	Size: 0x14C
	Parameters: 1
	Flags: Linked
*/
function transformer_think(var_b46b59df)
{
	/#
		assert(isdefined(self.script_int), "" + self.origin);
	#/
	n_power_index = self.script_int;
	self thread zm_altbody_beast::watch_lightning_damage(var_b46b59df);
	self clientfield::set("bminteract", 2);
	level flag::wait_till("power_on" + n_power_index);
	self thread scene::play("p7_fxanim_zm_zod_power_box_bundle", self);
	self clientfield::set("transformer_light_switch", n_power_index);
	self playsound("zmb_bm_interaction_machine_start");
	self playloopsound("zmb_bm_interaction_machine_loop", 2);
	self clientfield::set("bminteract", 0);
}

