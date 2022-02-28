// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_octobomb;

/*
	Name: __init__sytem__
	Namespace: _zm_weap_octobomb
	Checksum: 0x517EEDFB
	Offset: 0x4D0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_octobomb", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: _zm_weap_octobomb
	Checksum: 0x6EE8CE99
	Offset: 0x518
	Size: 0x25C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "octobomb_fx", 1, 2, "int", &octobomb_fx, 1, 0);
	clientfield::register("actor", "octobomb_spores_fx", 1, 2, "int", &octobomb_spores_fx, 1, 0);
	clientfield::register("actor", "octobomb_tentacle_hit_fx", 1, 1, "int", &octobomb_tentacle_hit_fx, 1, 0);
	clientfield::register("actor", "zombie_explode_fx", 1, 1, "counter", &octobomb_zombie_explode_fx, 1, 0);
	clientfield::register("actor", "zombie_explode_fx", -8000, 1, "counter", &octobomb_zombie_explode_fx, 1, 0);
	clientfield::register("actor", "octobomb_zombie_explode_fx", 8000, 1, "counter", &octobomb_zombie_explode_fx, 1, 0);
	clientfield::register("missile", "octobomb_spit_fx", 1, 2, "int", &octobomb_spit_fx, 1, 0);
	clientfield::register("toplayer", "octobomb_state", 1, 3, "int", undefined, 0, 1);
	setupclientfieldcodecallbacks("toplayer", 1, "octobomb_state");
}

/*
	Name: __main__
	Namespace: _zm_weap_octobomb
	Checksum: 0x3267A05E
	Offset: 0x780
	Size: 0x162
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	if(!zm_weapons::is_weapon_included(getweapon("octobomb")))
	{
		return;
	}
	level._effect["octobomb_explode_fx"] = "zombie/fx_octobomb_explo_death_zod_zmb";
	level._effect["octobomb_spores"] = "zombie/fx_octobomb_sporesplosion_zod_zmb";
	level._effect["octobomb_spores_spine"] = "zombie/fx_octobomb_spore_burn_torso_zod_zmb";
	level._effect["octobomb_spores_legs"] = "zombie/fx_octobomb_spore_burn_leg_zod_zmb";
	level._effect["octobomb_sporesplosion"] = "zombie/fx_octobomb_sporesplosion_tell_zod_zmb";
	level._effect["octobomb_ug_spores"] = "zombie/fx_octobomb_sporesplosion_ee_zod_zmb";
	level._effect["octobomb_ug_spores_spine"] = "zombie/fx_octobomb_spore_burn_torso_ee_zod_zmb";
	level._effect["octobomb_ug_spores_legs"] = "zombie/fx_octobomb_spore_burn_leg_zod_zmb";
	level._effect["octobomb_ug_sporesplosion"] = "zombie/fx_octobomb_sporesplosion_tell_ee_zod_zmb";
	level._effect["octobomb_tentacle_hit"] = "impacts/fx_flesh_hit_knife_lg_zmb";
	level._effect["zombie_explode"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
}

/*
	Name: octobomb_tentacle_hit_fx
	Namespace: _zm_weap_octobomb
	Checksum: 0x8D171363
	Offset: 0x8F0
	Size: 0xB6
	Parameters: 7
	Flags: Linked
*/
function octobomb_tentacle_hit_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.fx_octobomb_tentacle_hit = playfxontag(localclientnum, level._effect["octobomb_tentacle_hit"], self, "j_spineupper");
	}
	else if(isdefined(self.fx_octobomb_tentacle_hit))
	{
		stopfx(localclientnum, self.fx_octobomb_tentacle_hit);
		self.fx_octobomb_tentacle_hit = undefined;
	}
}

/*
	Name: octobomb_fx
	Namespace: _zm_weap_octobomb
	Checksum: 0x7B8B94C4
	Offset: 0x9B0
	Size: 0x13E
	Parameters: 7
	Flags: Linked
*/
function octobomb_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 3:
		{
			playfx(localclientnum, level._effect["octobomb_explode_fx"], self.origin, anglestoup(self.angles));
			break;
		}
		case 2:
		{
			fx_octobomb = level._effect["octobomb_ug_spores"];
			playfxontag(localclientnum, fx_octobomb, self, "tag_origin");
			break;
		}
		default:
		{
			fx_octobomb = level._effect["octobomb_spores"];
			playfxontag(localclientnum, fx_octobomb, self, "tag_origin");
			break;
		}
	}
}

/*
	Name: octobomb_spores_fx
	Namespace: _zm_weap_octobomb
	Checksum: 0xC4A9F8A2
	Offset: 0xAF8
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function octobomb_spores_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread octobomb_spore_fx_on(localclientnum, newval);
	}
}

/*
	Name: octobomb_spore_fx_on
	Namespace: _zm_weap_octobomb
	Checksum: 0x3066F8BE
	Offset: 0xB68
	Size: 0x19C
	Parameters: 2
	Flags: Linked
*/
function octobomb_spore_fx_on(localclientnum, n_fx_type)
{
	self endon(#"entityshutdown");
	if(n_fx_type == 2)
	{
		fx_spine = level._effect["octobomb_ug_spores_spine"];
		fx_legs = level._effect["octobomb_ug_spores_legs"];
	}
	else
	{
		fx_spine = level._effect["octobomb_spores_spine"];
		fx_legs = level._effect["octobomb_spores_legs"];
	}
	self.fx_octobomb_spores_spine = playfxontag(localclientnum, fx_spine, self, "j_spine4");
	wait(3.5);
	self.fx_octobomb_spores_leg_ri = playfxontag(localclientnum, fx_legs, self, "j_hip_ri");
	self.fx_octobomb_spores_leg_le = playfxontag(localclientnum, fx_legs, self, "j_hip_le");
	wait(3.5);
	stopfx(localclientnum, self.fx_octobomb_spores_spine);
	stopfx(localclientnum, self.fx_octobomb_spores_leg_ri);
	stopfx(localclientnum, self.fx_octobomb_spores_leg_le);
}

/*
	Name: octobomb_zombie_explode_fx
	Namespace: _zm_weap_octobomb
	Checksum: 0xF54CA7DF
	Offset: 0xD10
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function octobomb_zombie_explode_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(util::is_mature() && !util::is_gib_restricted_build())
	{
		playfxontag(localclientnum, level._effect["zombie_explode"], self, "j_spinelower");
	}
}

/*
	Name: octobomb_spit_fx
	Namespace: _zm_weap_octobomb
	Checksum: 0x4F11CF14
	Offset: 0xDB8
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function octobomb_spit_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 2)
	{
		fx_spit = level._effect["octobomb_ug_sporesplosion"];
	}
	else
	{
		fx_spit = level._effect["octobomb_sporesplosion"];
	}
	level thread octobomb_spit_fx_and_cleanup(localclientnum, self.origin, self.angles, fx_spit);
}

/*
	Name: octobomb_spit_fx_and_cleanup
	Namespace: _zm_weap_octobomb
	Checksum: 0xA2293D04
	Offset: 0xE78
	Size: 0x84
	Parameters: 4
	Flags: Linked
*/
function octobomb_spit_fx_and_cleanup(localclientnum, v_origin, v_angles, fx_spit)
{
	fx_id = playfx(localclientnum, fx_spit, v_origin, anglestoup(v_angles));
	wait(3.416675);
	stopfx(localclientnum, fx_id);
}

