// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_elemental_bow;

#namespace _zm_weap_elemental_bow_wolf_howl;

/*
	Name: __init__sytem__
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0xE932100
	Offset: 0x638
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("_zm_weap_elemental_bow_wolf_howl", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0xB8820190
	Offset: 0x678
	Size: 0x47C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "elemental_bow_wolf_howl" + "_ambient_bow_fx", 5000, 1, "int", &function_cb5344d7, 0, 0);
	clientfield::register("missile", "elemental_bow_wolf_howl" + "_arrow_impact_fx", 5000, 1, "int", &function_6974030a, 0, 0);
	clientfield::register("scriptmover", "elemental_bow_wolf_howl4" + "_arrow_impact_fx", 5000, 1, "int", &function_644da66f, 0, 0);
	clientfield::register("toplayer", "wolf_howl_muzzle_flash", 5000, 1, "int", &wolf_howl_muzzle_flash, 0, 0);
	clientfield::register("scriptmover", "wolf_howl_arrow_charged_trail", 5000, 1, "int", &function_76bb77a6, 0, 0);
	clientfield::register("scriptmover", "wolf_howl_arrow_charged_spiral", 5000, 1, "int", &function_714aa0e1, 0, 0);
	clientfield::register("actor", "wolf_howl_slow_snow_fx", 5000, 1, "int", &wolf_howl_slow_snow_fx, 0, 0);
	clientfield::register("actor", "zombie_hit_by_wolf_howl_charge", 5000, 1, "int", &zombie_hit_by_wolf_howl_charge, 0, 0);
	clientfield::register("actor", "zombie_explode_fx", 5000, 1, "counter", &wolf_howl_zombie_explode_fx, 0, 0);
	clientfield::register("actor", "zombie_explode_fx", -8000, 1, "counter", &wolf_howl_zombie_explode_fx, 0, 0);
	clientfield::register("actor", "wolf_howl_zombie_explode_fx", 8000, 1, "counter", &wolf_howl_zombie_explode_fx, 0, 0);
	level._effect["wolf_howl_ambient_bow"] = "dlc1/zmb_weapon/fx_bow_wolf_ambient_1p_zmb";
	level._effect["wolf_howl_arrow_impact"] = "dlc1/zmb_weapon/fx_bow_wolf_impact_zmb";
	level._effect["wolf_howl_arrow_charged_impact"] = "dlc1/zmb_weapon/fx_bow_wolf_impact_ug_zmb";
	level._effect["wolf_howl_slow_torso"] = "dlc1/zmb_weapon/fx_bow_wolf_wrap_torso";
	level._effect["wolf_howl_charge_spiral"] = "dlc1/zmb_weapon/fx_bow_wolf_arrow_spiral_ug_zmb";
	level._effect["wolf_howl_charge_trail"] = "dlc1/zmb_weapon/fx_bow_wolf_arrow_trail_ug_zmb";
	level._effect["wolf_howl_arrow_trail"] = "dlc1/zmb_weapon/fx_bow_wolf_arrow_trail_zmb";
	level._effect["wolf_howl_muzzle_flash"] = "dlc1/zmb_weapon/fx_bow_wolf_muz_flash_ug_1p_zmb";
	level._effect["zombie_trail_wolf_howl_hit"] = "dlc1/zmb_weapon/fx_bow_wolf_torso_trail";
	level._effect["zombie_wolf_howl_hit_explode"] = "dlc1/castle/fx_tesla_trap_body_exp";
	duplicate_render::set_dr_filter_framebuffer("ghostly", 10, "ghostly_on", undefined, 0, "mc/mtl_c_zom_der_zombie_body1_ghost", 0);
}

/*
	Name: function_cb5344d7
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0xFC42EC1D
	Offset: 0xB00
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_cb5344d7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self zm_weap_elemental_bow::function_3158b481(localclientnum, newval, "wolf_howl_ambient_bow");
}

/*
	Name: function_6974030a
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0x45CA7B3E
	Offset: 0xB70
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_6974030a(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["wolf_howl_arrow_impact"], self.origin);
	}
}

/*
	Name: function_644da66f
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0xAC6D83E5
	Offset: 0xBF0
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_644da66f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["wolf_howl_arrow_charged_impact"], self.origin);
	}
}

/*
	Name: wolf_howl_muzzle_flash
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0x62313211
	Offset: 0xC70
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function wolf_howl_muzzle_flash(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playviewmodelfx(localclientnum, level._effect["wolf_howl_muzzle_flash"], "tag_flash");
	}
}

/*
	Name: function_76bb77a6
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0xA136F6BF
	Offset: 0xCF0
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function function_76bb77a6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.var_e73f2a59 = playfxontag(localclientnum, level._effect["wolf_howl_charge_trail"], self, "tag_origin");
	}
	else
	{
		deletefx(localclientnum, self.var_e73f2a59, 0);
	}
}

/*
	Name: function_714aa0e1
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0xB71196F6
	Offset: 0xD98
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function function_714aa0e1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.var_36615b6 = playfxontag(localclientnum, level._effect["wolf_howl_charge_spiral"], self, "tag_origin");
	}
	else
	{
		deletefx(localclientnum, self.var_36615b6, 0);
	}
}

/*
	Name: wolf_howl_slow_snow_fx
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0xB01AFCDE
	Offset: 0xE40
	Size: 0xC6
	Parameters: 7
	Flags: Linked
*/
function wolf_howl_slow_snow_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(!isdefined(self.var_3e50c3b4))
		{
			self.var_3e50c3b4 = playfxontag(localclientnum, level._effect["wolf_howl_slow_torso"], self, "j_spineupper");
		}
	}
	else if(isdefined(self.var_3e50c3b4))
	{
		deletefx(localclientnum, self.var_3e50c3b4, 0);
		self.var_3e50c3b4 = undefined;
	}
}

/*
	Name: zombie_hit_by_wolf_howl_charge
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0x51D8BE91
	Offset: 0xF10
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function zombie_hit_by_wolf_howl_charge(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval)
	{
		playfxontag(localclientnum, level._effect["zombie_trail_wolf_howl_hit"], self, "j_spine4");
		self duplicate_render::set_dr_flag("ghostly_on", newval);
		self duplicate_render::update_dr_filters(localclientnum);
	}
}

/*
	Name: wolf_howl_zombie_explode_fx
	Namespace: _zm_weap_elemental_bow_wolf_howl
	Checksum: 0x292C7829
	Offset: 0xFD0
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function wolf_howl_zombie_explode_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	playfxontag(localclientnum, level._effect["zombie_wolf_howl_hit_explode"], self, "j_spine4");
}

