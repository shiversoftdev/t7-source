// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_island_planting;

/*
	Name: init
	Namespace: zm_island_planting
	Checksum: 0xFBBE0173
	Offset: 0x610
	Size: 0x31C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("scriptmover", "plant_growth_siege_anims", 9000, 2, "int", &plant_growth_siege_anims, 0, 0);
	clientfield::register("scriptmover", "cache_plant_interact_fx", 9000, 1, "int", &function_d6804e46, 0, 0);
	clientfield::register("scriptmover", "plant_hit_with_ww_fx", 9000, 1, "int", &plant_hit_with_ww, 0, 0);
	clientfield::register("scriptmover", "plant_watered_fx", 9000, 1, "int", &plant_watered, 0, 0);
	clientfield::register("scriptmover", "planter_model_watered", 9000, 1, "int", &planter_model_watered, 0, 0);
	clientfield::register("scriptmover", "babysitter_plant_fx", 9000, 1, "int", &babysitter_plant_fx, 0, 0);
	clientfield::register("scriptmover", "trap_plant_fx", 9000, 1, "int", &trap_plant_fx, 0, 0);
	clientfield::register("toplayer", "player_spawned_from_clone_plant", 9000, 1, "int", &player_spawned_from_clone_plant, 0, 0);
	clientfield::register("toplayer", "player_cloned_fx", 9000, 1, "int", &player_cloned_fx, 0, 0);
	clientfield::register("scriptmover", "zombie_or_grenade_spawned_from_minor_cache_plant", 9000, 2, "int", &zombie_or_grenade_spawned_from_minor_cache_plant, 0, 0);
	clientfield::register("allplayers", "player_vomit_fx", 9000, 1, "int", &player_vomit_fx, 0, 0);
}

/*
	Name: plant_growth_siege_anims
	Namespace: zm_island_planting
	Checksum: 0x6F02F9EB
	Offset: 0x938
	Size: 0x37C
	Parameters: 7
	Flags: Linked
*/
function plant_growth_siege_anims(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.var_600eec00))
	{
		self.var_600eec00 = util::spawn_model(localclientnum, "p7_fxanim_zm_island_plant_bulb_smod", self.origin, self.angles);
	}
	if(!isdefined(self.var_a32dfd4))
	{
		self.var_a32dfd4 = util::spawn_model(localclientnum, "p7_fxanim_zm_island_plant_roots_smod", self.origin, self.angles);
	}
	if(newval == 1)
	{
		self endon(#"hash_336ee8b2");
		self.var_600eec00 siegecmd("set_anim", "p7_fxanim_zm_island_plant_bulb_grow1_sanim", "unloop");
		self.var_a32dfd4 siegecmd("set_anim", "p7_fxanim_zm_island_plant_roots_grow1_sanim", "unloop");
		n_wait_time = getanimlength("p7_fxanim_zm_island_plant_bulb_grow1_sanim");
		wait(n_wait_time);
		self.var_600eec00 siegecmd("set_anim", "p7_fxanim_zm_island_plant_bulb_grow1_idle_sanim", "loop");
		self.var_a32dfd4 siegecmd("set_anim", "p7_fxanim_zm_island_plant_roots_grow1_idle_sanim", "loop");
	}
	else
	{
		if(newval == 2)
		{
			self endon(#"hash_d6c6e49");
			self notify(#"hash_336ee8b2");
			self.var_600eec00 siegecmd("set_anim", "p7_fxanim_zm_island_plant_bulb_grow2_sanim", "unloop");
			self.var_a32dfd4 siegecmd("set_anim", "p7_fxanim_zm_island_plant_roots_grow2_sanim", "unloop");
			n_wait_time = getanimlength("p7_fxanim_zm_island_plant_bulb_grow2_sanim");
			wait(n_wait_time);
			self.var_600eec00 siegecmd("set_anim", "p7_fxanim_zm_island_plant_bulb_grow2_idle_sanim", "loop");
			self.var_a32dfd4 siegecmd("set_anim", "p7_fxanim_zm_island_plant_roots_grow2_idle_sanim", "loop");
		}
		else
		{
			if(newval == 3)
			{
				self notify(#"hash_d6c6e49");
				self.var_600eec00 siegecmd("set_anim", "p7_fxanim_zm_island_plant_bulb_open_sanim", "unloop");
				self.var_a32dfd4 siegecmd("set_anim", "p7_fxanim_zm_island_plant_roots_open_sanim", "unloop");
			}
			else
			{
				self.var_600eec00 siegecmd("set_anim", "p7_fxanim_zm_island_plant_bulb_dead_sanim", "unloop");
			}
		}
	}
}

/*
	Name: function_d6804e46
	Namespace: zm_island_planting
	Checksum: 0x31E7E1D
	Offset: 0xCC0
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function function_d6804e46(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.fx_id))
	{
		deletefx(localclientnum, self.fx_id, 0);
		self.fx_id = undefined;
	}
	else if(newval == 1)
	{
		self.fx_id = playfxontag(localclientnum, level._effect["major_cache_plant"], self, "fx_tag_plant_cache_major_jnt");
	}
}

/*
	Name: babysitter_plant_fx
	Namespace: zm_island_planting
	Checksum: 0xCA083F16
	Offset: 0xD88
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function babysitter_plant_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.babysitter_plant_fx = playfxontag(localclientnum, level._effect["babysitter_plant"], self, "tag_origin");
	}
	else if(isdefined(self.babysitter_plant_fx))
	{
		deletefx(localclientnum, self.babysitter_plant_fx, 0);
		self.babysitter_plant_fx = undefined;
	}
}

/*
	Name: trap_plant_fx
	Namespace: zm_island_planting
	Checksum: 0x4C0965DB
	Offset: 0xE50
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function trap_plant_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.trap_plant_fx = playfxontag(localclientnum, level._effect["trap_plant"], self, "tag_origin");
	}
	else if(isdefined(self.trap_plant_fx))
	{
		deletefx(localclientnum, self.trap_plant_fx, 0);
		self.trap_plant_fx = undefined;
	}
}

/*
	Name: plant_hit_with_ww
	Namespace: zm_island_planting
	Checksum: 0x966FDA38
	Offset: 0xF18
	Size: 0xCE
	Parameters: 7
	Flags: Linked
*/
function plant_hit_with_ww(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_c00f8b20 = playfx(localclientnum, level._effect["plant_hit_with_ww"], self.origin + vectorscale((0, 0, 1), 8));
	}
	else if(isdefined(self.var_c00f8b20))
	{
		deletefx(localclientnum, self.var_c00f8b20, 0);
		self.var_c00f8b20 = undefined;
	}
}

/*
	Name: plant_watered
	Namespace: zm_island_planting
	Checksum: 0xE84E4693
	Offset: 0xFF0
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function plant_watered(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self notify(#"hash_15110cf6");
	if(isdefined(self.var_5257f4ba))
	{
		deletefx(localclientnum, self.var_5257f4ba, 0);
		self.var_5257f4ba = undefined;
	}
	if(newval == 1)
	{
		self thread function_2179698b(localclientnum);
	}
}

/*
	Name: function_2179698b
	Namespace: zm_island_planting
	Checksum: 0xC0DCFC71
	Offset: 0x10A0
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_2179698b(localclientnum)
{
	level endon(#"demo_jump");
	self endon(#"hash_15110cf6");
	self.var_5257f4ba = playfx(localclientnum, level._effect["plant_watered_startup"], self.origin + vectorscale((0, 0, 1), 8));
	wait(2);
	if(isdefined(self))
	{
		self.var_5257f4ba = playfx(localclientnum, level._effect["plant_watered"], self.origin + vectorscale((0, 0, 1), 8));
	}
}

/*
	Name: planter_model_watered
	Namespace: zm_island_planting
	Checksum: 0xC2BC7107
	Offset: 0x1170
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function planter_model_watered(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self thread function_b8ba462e(localclientnum, 1);
	}
	else
	{
		self thread function_b8ba462e(localclientnum, 0);
	}
}

/*
	Name: function_b8ba462e
	Namespace: zm_island_planting
	Checksum: 0xD90DB32
	Offset: 0x1200
	Size: 0x1D0
	Parameters: 2
	Flags: Linked
*/
function function_b8ba462e(localclientnum, b_on = 1)
{
	self endon(#"entityshutdown");
	self notify(#"hash_67a9e087");
	self endon(#"hash_67a9e087");
	level endon(#"demo_jump");
	n_start_time = gettime();
	n_end_time = n_start_time + (2 * 1000);
	b_is_updating = 1;
	if(isdefined(b_on) && b_on)
	{
		n_max = 1;
		n_min = 0;
	}
	else
	{
		n_max = 0;
		n_min = 1;
	}
	while(b_is_updating && isdefined(self))
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_time);
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: player_spawned_from_clone_plant
	Namespace: zm_island_planting
	Checksum: 0x9FE6B0BA
	Offset: 0x13D8
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function player_spawned_from_clone_plant(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self thread postfx::playpostfxbundle("pstfx_thrasher_stomach");
	}
	else if(isdefined(self.playingpostfxbundle))
	{
		self thread postfx::stopplayingpostfxbundle();
	}
}

/*
	Name: player_cloned_fx
	Namespace: zm_island_planting
	Checksum: 0x6FB72D5C
	Offset: 0x1470
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function player_cloned_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_23200cb7 = playfxontag(localclientnum, level._effect["clone_plant_emerge"], self, "tag_camera");
	}
	else if(isdefined(self.var_23200cb7))
	{
		deletefx(localclientnum, self.var_23200cb7, 0);
		self.var_23200cb7 = undefined;
	}
}

/*
	Name: zombie_or_grenade_spawned_from_minor_cache_plant
	Namespace: zm_island_planting
	Checksum: 0x70305D3A
	Offset: 0x1538
	Size: 0x106
	Parameters: 7
	Flags: Linked
*/
function zombie_or_grenade_spawned_from_minor_cache_plant(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_7fec15a0 = playfxontag(localclientnum, level._effect["cache_slime"], self, "plant_cache_major_feeler_03_03_jnt");
	}
	else
	{
		if(newval == 2)
		{
			self.var_7fec15a0 = playfxontag(localclientnum, level._effect["cache_slime_small"], self, "plant_cache_major_feeler_03_03_jnt");
		}
		else if(isdefined(self.var_7fec15a0))
		{
			deletefx(localclientnum, self.var_7fec15a0, 0);
			self.var_7fec15a0 = undefined;
		}
	}
}

/*
	Name: player_vomit_fx
	Namespace: zm_island_planting
	Checksum: 0xDDB6B668
	Offset: 0x1648
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function player_vomit_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_a56aa1f9 = playfxontag(localclientnum, level._effect["fruit_plant_vomit"], self, "j_neck");
	}
	else if(isdefined(self.var_a56aa1f9))
	{
		deletefx(localclientnum, self.var_a56aa1f9, 0);
		self.var_a56aa1f9 = undefined;
	}
}

