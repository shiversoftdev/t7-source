// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flag_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace zm_ai_raps;

/*
	Name: __init__sytem__
	Namespace: zm_ai_raps
	Checksum: 0x980FB306
	Offset: 0x328
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_raps", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_raps
	Checksum: 0x94D6B9FC
	Offset: 0x368
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "elemental_round_fx", 1, 1, "counter", &elemental_round_fx, 0, 0);
	clientfield::register("toplayer", "elemental_round_ring_fx", 1, 1, "counter", &elemental_round_ring_fx, 0, 0);
	visionset_mgr::register_visionset_info("zm_elemental_round_visionset", 1, 31, undefined, "zm_elemental_round_visionset");
	level._effect["elemental_round"] = "zombie/fx_meatball_round_tell_zod_zmb";
	vehicle::add_vehicletype_callback("raps", &_setup_);
}

/*
	Name: _setup_
	Namespace: zm_ai_raps
	Checksum: 0xF7E452EF
	Offset: 0x470
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function _setup_(localclientnum)
{
	self.notifyonbulletimpact = 1;
	self thread wait_for_bullet_impact(localclientnum);
	self setanim("ai_zombie_zod_insanity_elemental_idle", 1);
	if(isdefined(level.debug_keyline_zombies) && level.debug_keyline_zombies)
	{
		self duplicate_render::set_dr_flag("keyline_active", 1);
		self duplicate_render::update_dr_filters(localclientnum);
	}
}

/*
	Name: elemental_round_fx
	Namespace: zm_ai_raps
	Checksum: 0xAD6F8201
	Offset: 0x528
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function elemental_round_fx(n_local_client, n_val_old, n_val_new, b_ent_new, b_initial_snap, str_field, b_demo_jump)
{
	self endon(#"disconnect");
	if(isspectating(n_local_client))
	{
		return;
	}
	self.n_elemental_round_fx_id = playfxoncamera(n_local_client, level._effect["elemental_round"]);
	wait(3.5);
	deletefx(n_local_client, self.n_elemental_round_fx_id);
}

/*
	Name: elemental_round_ring_fx
	Namespace: zm_ai_raps
	Checksum: 0xF8E8A35E
	Offset: 0x5F0
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function elemental_round_ring_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"disconnect");
	if(isspectating(localclientnum))
	{
		return;
	}
	self thread postfx::playpostfxbundle("pstfx_ring_loop");
	wait(1.5);
	self postfx::exitpostfxbundle();
}

/*
	Name: wait_for_bullet_impact
	Namespace: zm_ai_raps
	Checksum: 0xDEB7F1D7
	Offset: 0x698
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function wait_for_bullet_impact(localclientnum)
{
	self endon(#"entityshutdown");
	if(isdefined(self.scriptbundlesettings))
	{
		settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	else
	{
		return;
	}
	while(true)
	{
		self waittill(#"damage", attacker, impactpos, effectdir, partname);
		playfx(localclientnum, settings.weakspotfx, impactpos, effectdir);
	}
}

