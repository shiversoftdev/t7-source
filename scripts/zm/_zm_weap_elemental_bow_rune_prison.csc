// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weap_elemental_bow;

#namespace _zm_weap_elemental_bow_rune_prison;

/*
	Name: __init__sytem__
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0x48DBD3C
	Offset: 0x510
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("_zm_weap_elemental_bow_rune_prison", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0x2A6A6B8C
	Offset: 0x550
	Size: 0x32E
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "elemental_bow_rune_prison" + "_ambient_bow_fx", 5000, 1, "int", &function_8339cd3d, 0, 0);
	clientfield::register("missile", "elemental_bow_rune_prison" + "_arrow_impact_fx", 5000, 1, "int", &function_4b59f7f4, 0, 0);
	clientfield::register("missile", "elemental_bow_rune_prison4" + "_arrow_impact_fx", 5000, 1, "int", &function_ed22f261, 0, 0);
	clientfield::register("scriptmover", "runeprison_rock_fx", 5000, 1, "int", &runeprison_rock_fx, 0, 0);
	clientfield::register("scriptmover", "runeprison_explode_fx", 5000, 1, "int", &runeprison_explode_fx, 0, 0);
	clientfield::register("scriptmover", "runeprison_lava_geyser_fx", 5000, 1, "int", &runeprison_lava_geyser_fx, 0, 0);
	clientfield::register("actor", "runeprison_lava_geyser_dot_fx", 5000, 1, "int", &runeprison_lava_geyser_dot_fx, 0, 0);
	clientfield::register("actor", "runeprison_zombie_charring", 5000, 1, "int", &runeprison_zombie_charring, 0, 0);
	clientfield::register("actor", "runeprison_zombie_death_skull", 5000, 1, "int", &runeprison_zombie_death_skull, 0, 0);
	level._effect["rune_ambient_bow"] = "dlc1/zmb_weapon/fx_bow_rune_ambient_1p_zmb";
	level._effect["rune_arrow_impact"] = "dlc1/zmb_weapon/fx_bow_rune_impact_zmb";
	level._effect["rune_fire_pillar"] = "dlc1/zmb_weapon/fx_bow_rune_impact_ug_fire_zmb";
	level._effect["rune_lava_geyser"] = "dlc1/zmb_weapon/fx_bow_rune_impact_aoe_zmb";
	level._effect["rune_lava_geyser_dot"] = "dlc1/zmb_weapon/fx_bow_rune_fire_torso_zmb";
}

/*
	Name: function_8339cd3d
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0xC37DC270
	Offset: 0x888
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_8339cd3d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self zm_weap_elemental_bow::function_3158b481(localclientnum, newval, "rune_ambient_bow");
}

/*
	Name: function_4b59f7f4
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0xE93829D1
	Offset: 0x8F8
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_4b59f7f4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["rune_arrow_impact"], self.origin);
	}
}

/*
	Name: function_ed22f261
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0xC2EAB864
	Offset: 0x978
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_ed22f261(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["rune_arrow_impact"], self.origin);
	}
}

/*
	Name: runeprison_rock_fx
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0xEA86C45D
	Offset: 0x9F8
	Size: 0x126
	Parameters: 7
	Flags: Linked
*/
function runeprison_rock_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 0:
		{
			self scene_play("p7_fxanim_zm_bow_rune_prison_01_bundle");
			if(!isdefined(self))
			{
				return;
			}
			self thread scene_play("p7_fxanim_zm_bow_rune_prison_01_dissolve_bundle", self.var_728caca2);
			self.var_728caca2 thread function_79854312(localclientnum);
			break;
		}
		case 1:
		{
			self thread scene::init("p7_fxanim_zm_bow_rune_prison_01_bundle");
			self.var_728caca2 = util::spawn_model(localclientnum, "p7_fxanim_zm_bow_rune_prison_dissolve_mod", self.origin, self.angles);
			break;
		}
	}
}

/*
	Name: scene_play
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0xB7EF3984
	Offset: 0xB28
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function scene_play(scene, var_7b98b639)
{
	self notify(#"scene_play");
	self endon(#"scene_play");
	self scene::stop();
	self function_6221b6b9(scene, var_7b98b639);
	if(isdefined(self))
	{
		self scene::stop();
	}
}

/*
	Name: function_6221b6b9
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0x5DA365BC
	Offset: 0xBB8
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function function_6221b6b9(scene, var_7b98b639)
{
	level endon(#"demo_jump");
	self scene::play(scene, var_7b98b639);
}

/*
	Name: function_79854312
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0xCC36C409
	Offset: 0xC00
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function function_79854312(localclientnum)
{
	self endon(#"entityshutdown");
	n_start_time = gettime();
	n_end_time = n_start_time + 1633;
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector0", n_shader_value, 0, 0);
		wait(0.016);
	}
}

/*
	Name: runeprison_explode_fx
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0x776F42C8
	Offset: 0xD20
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function runeprison_explode_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["rune_fire_pillar"], self.origin, (0, 0, 1), (1, 0, 0));
	}
}

/*
	Name: runeprison_lava_geyser_fx
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0xFBE809E1
	Offset: 0xDA8
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function runeprison_lava_geyser_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["rune_lava_geyser"], self.origin, (0, 0, 1), (1, 0, 0));
		self playsound(0, "wpn_rune_prison_lava_lump", self.origin);
	}
}

/*
	Name: runeprison_lava_geyser_dot_fx
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0xCB126A2F
	Offset: 0xE58
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function runeprison_lava_geyser_dot_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.var_1892be10 = playfxontag(localclientnum, level._effect["rune_lava_geyser_dot"], self, "j_spine4");
	}
	else
	{
		deletefx(localclientnum, self.var_1892be10, 0);
	}
}

/*
	Name: runeprison_zombie_charring
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0xA6C6940A
	Offset: 0xF00
	Size: 0xF8
	Parameters: 7
	Flags: Linked
*/
function runeprison_zombie_charring(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(newval)
	{
		n_cur_time = gettime();
		n_start_time = n_cur_time;
		var_39255d08 = n_cur_time + 1200;
		while(n_cur_time < var_39255d08)
		{
			var_dd5c416e = (n_cur_time - n_start_time) / 1200;
			self mapshaderconstant(localclientnum, 0, "scriptVector0", var_dd5c416e, var_dd5c416e, 0);
			wait(0.016);
			n_cur_time = gettime();
		}
	}
}

/*
	Name: runeprison_zombie_death_skull
	Namespace: _zm_weap_elemental_bow_rune_prison
	Checksum: 0x3470F574
	Offset: 0x1000
	Size: 0x10C
	Parameters: 7
	Flags: Linked
*/
function runeprison_zombie_death_skull(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		var_3704946b = self gettagorigin("j_head");
		var_94fe2196 = self gettagangles("j_head");
		createdynentandlaunch(localclientnum, "rune_prison_death_skull", var_3704946b, var_94fe2196, self.origin, (randomfloatrange(-0.15, 0.15), randomfloatrange(-0.15, 0.15), 0.1));
	}
}

