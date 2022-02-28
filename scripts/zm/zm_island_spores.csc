// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_island_spores;

/*
	Name: init
	Namespace: zm_island_spores
	Checksum: 0xEBF3C173
	Offset: 0x580
	Size: 0x268
	Parameters: 0
	Flags: Linked
*/
function init()
{
	var_d1cfa380 = getminbitcountfornum(7);
	var_a15256dd = getminbitcountfornum(3);
	var_a17d01a1 = getminbitcountfornum(5);
	clientfield::register("scriptmover", "spore_glow_fx", 9000, 1, "int", &spore_glow_fx, 0, 0);
	clientfield::register("scriptmover", "spore_cloud_fx", 9000, var_d1cfa380, "int", &spore_cloud_fx, 0, 0);
	clientfield::register("actor", "spore_trail_enemy_fx", 9000, var_a15256dd, "int", &function_d4effeda, 0, 0);
	clientfield::register("allplayers", "spore_trail_player_fx", 9000, var_a15256dd, "int", &function_d4effeda, 0, 0);
	clientfield::register("scriptmover", "spore_grows", 9000, var_a17d01a1, "int", &spore_grows, 0, 0);
	clientfield::register("toplayer", "play_spore_bubbles", 9000, 1, "int", &function_6225657f, 0, 0);
	clientfield::register("toplayer", "spore_camera_fx", 9000, var_a15256dd, "int", &spore_camera_fx, 0, 0);
	level.b_thrasher_custom_spore_fx = 1;
}

/*
	Name: spore_glow_fx
	Namespace: zm_island_spores
	Checksum: 0xAD508920
	Offset: 0x7F0
	Size: 0x17E
	Parameters: 7
	Flags: Linked
*/
function spore_glow_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.var_b5a2b77f))
	{
		self.var_b5a2b77f = arraygetclosest(self.origin, struct::get_array("spore_fx_org", "script_noteworthy"));
	}
	if(newval == 1)
	{
		if(isdefined(self.var_a1aff3d8))
		{
			stopfx(localclientnum, self.var_a1aff3d8);
		}
		self.var_a1aff3d8 = playfx(localclientnum, level._effect["SPORE_GLOW"], self.var_b5a2b77f.origin, anglestoforward(self.var_b5a2b77f.angles), anglestoup(self.var_b5a2b77f.angles));
	}
	else if(isdefined(self.var_a1aff3d8))
	{
		stopfx(localclientnum, self.var_a1aff3d8);
		self.var_a1aff3d8 = undefined;
	}
}

/*
	Name: spore_cloud_fx
	Namespace: zm_island_spores
	Checksum: 0x43A789FD
	Offset: 0x978
	Size: 0x85E
	Parameters: 7
	Flags: Linked
*/
function spore_cloud_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum))
	{
		return;
	}
	if(!isdefined(self.var_a5969fbf) && !isdefined(self.var_338f3084) && !isdefined(self.var_5991aaed) && self.model != "tag_origin")
	{
		self.var_a5969fbf = arraygetclosest(self.origin, struct::get_array("spore_cloud_org_stage_01", "script_noteworthy"));
		self.var_338f3084 = arraygetclosest(self.origin, struct::get_array("spore_cloud_org_stage_02", "script_noteworthy"));
		self.var_5991aaed = arraygetclosest(self.origin, struct::get_array("spore_cloud_org_stage_03", "script_noteworthy"));
	}
	else if(!isdefined(self.var_a5969fbf) && !isdefined(self.var_338f3084) && !isdefined(self.var_5991aaed) && self.model == "tag_origin")
	{
		self.var_a5969fbf = spawnstruct();
		self.var_a5969fbf.origin = self.origin;
		self.var_a5969fbf.angles = self.angles;
		self.var_338f3084 = spawnstruct();
		self.var_338f3084.origin = self.origin;
		self.var_338f3084.angles = self.angles;
		self.var_5991aaed = spawnstruct();
		self.var_5991aaed.origin = self.origin;
		self.var_5991aaed.angles = self.angles;
	}
	if(!isdefined(self.var_b5a2b77f) && self.model != "tag_origin")
	{
		self.var_b5a2b77f = arraygetclosest(self.origin, struct::get_array("spore_fx_org", "script_noteworthy"));
	}
	else if(!isdefined(self.var_b5a2b77f) && self.model == "tag_origin")
	{
		self.var_b5a2b77f = spawnstruct();
		self.var_b5a2b77f.origin = self.origin;
		self.var_b5a2b77f.angles = self.angles;
	}
	if(newval >= 1)
	{
		switch(newval)
		{
			case 1:
			{
				playfx(localclientnum, level._effect["SPORE_CLOUD_EXP_GOOD_SM"], self.var_b5a2b77f.origin, anglestoforward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playfx(localclientnum, level._effect["SPORE_CLOUD_GOOD_SM"], self.var_a5969fbf.origin, anglestoforward(self.var_a5969fbf.angles));
				break;
			}
			case 2:
			{
				playfx(localclientnum, level._effect["SPORE_CLOUD_EXP_GOOD_MD"], self.var_b5a2b77f.origin, anglestoforward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playfx(localclientnum, level._effect["SPORE_CLOUD_GOOD_MD"], self.var_338f3084.origin, anglestoforward(self.var_338f3084.angles));
				break;
			}
			case 3:
			{
				playfx(localclientnum, level._effect["SPORE_CLOUD_EXP_GOOD_LG"], self.var_b5a2b77f.origin, anglestoforward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playfx(localclientnum, level._effect["SPORE_CLOUD_GOOD_LG"], self.var_5991aaed.origin, anglestoforward(self.var_5991aaed.angles));
				break;
			}
			case 4:
			{
				playfx(localclientnum, level._effect["SPORE_CLOUD_EXP_SM"], self.var_b5a2b77f.origin, anglestoforward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playfx(localclientnum, level._effect["SPORE_CLOUD_SM"], self.var_a5969fbf.origin, anglestoforward(self.var_a5969fbf.angles));
				break;
			}
			case 5:
			{
				playfx(localclientnum, level._effect["SPORE_CLOUD_EXP_MD"], self.var_b5a2b77f.origin, anglestoforward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playfx(localclientnum, level._effect["SPORE_CLOUD_MD"], self.var_338f3084.origin, anglestoforward(self.var_338f3084.angles));
				break;
			}
			case 6:
			{
				playfx(localclientnum, level._effect["SPORE_CLOUD_EXP_LG"], self.var_b5a2b77f.origin, anglestoforward(self.var_b5a2b77f.angles));
				self.var_1ca05152 = playfx(localclientnum, level._effect["SPORE_CLOUD_LG"], self.var_5991aaed.origin, anglestoforward(self.var_5991aaed.angles));
				break;
			}
		}
	}
	else if(isdefined(self.var_1ca05152))
	{
		stopfx(localclientnum, self.var_1ca05152);
		self.var_1ca05152 = undefined;
	}
}

/*
	Name: function_d4effeda
	Namespace: zm_island_spores
	Checksum: 0x4B9ACF25
	Offset: 0x11E0
	Size: 0x11E
	Parameters: 7
	Flags: Linked
*/
function function_d4effeda(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum))
	{
		return;
	}
	if(newval == 1)
	{
		self.var_b01b7371 = playfxontag(localclientnum, level._effect["SPORE_TRAIL_GOOD"], self, "j_spine4");
	}
	else
	{
		if(newval == 2)
		{
			self.var_b01b7371 = playfxontag(localclientnum, level._effect["SPORE_TRAIL"], self, "j_spine4");
		}
		else if(isdefined(self.var_b01b7371))
		{
			stopfx(localclientnum, self.var_b01b7371);
			self.var_b01b7371 = undefined;
		}
	}
}

/*
	Name: spore_grows
	Namespace: zm_island_spores
	Checksum: 0xF8F0141B
	Offset: 0x1308
	Size: 0x60C
	Parameters: 7
	Flags: Linked
*/
function spore_grows(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.var_baeb5712))
	{
		if(self.model == "p7_zm_isl_spore_flat")
		{
			self.var_baeb5712 = 1;
		}
		else
		{
			self.var_baeb5712 = 0;
		}
	}
	if(isdemoplaying() && getnumfreeentities(localclientnum) < 100)
	{
		return;
	}
	if(newval >= 1)
	{
		switch(newval)
		{
			case 1:
			{
				self scene::stop(1);
				if(self.var_baeb5712)
				{
					self scene::add_scene_func("p7_fxanim_zm_island_spores_wall_stage_01_bundle", &function_dd0015d, "play");
					self thread scene_play("p7_fxanim_zm_island_spores_wall_stage_01_bundle");
				}
				else
				{
					self scene::add_scene_func("p7_fxanim_zm_island_spores_rock_stage_01_bundle", &function_dd0015d, "play");
					self thread scene_play("p7_fxanim_zm_island_spores_rock_stage_01_bundle");
				}
				break;
			}
			case 2:
			{
				self scene::stop(1);
				if(isdefined(self.var_4df7e11b) && self.var_4df7e11b.size > 0)
				{
					self.var_4df7e11b = array::remove_undefined(self.var_4df7e11b);
					array::run_all(self.var_4df7e11b, &delete);
					self.var_4df7e11b = [];
				}
				if(self.var_baeb5712)
				{
					self thread scene_play("p7_fxanim_zm_island_spores_wall_stage_02_bundle");
				}
				else
				{
					self thread scene_play("p7_fxanim_zm_island_spores_rock_stage_02_bundle");
				}
				break;
			}
			case 3:
			{
				self scene::stop(1);
				if(self.var_baeb5712)
				{
					self scene::add_scene_func("p7_fxanim_zm_island_spores_wall_stage_02_rapid_bundle", &function_dd0015d, "play");
					self thread scene_play("p7_fxanim_zm_island_spores_wall_stage_02_rapid_bundle");
				}
				else
				{
					self scene::add_scene_func("p7_fxanim_zm_island_spores_rock_stage_02_rapid_bundle", &function_dd0015d, "play");
					self thread scene_play("p7_fxanim_zm_island_spores_rock_stage_02_rapid_bundle");
				}
				break;
			}
			case 4:
			{
				if(self.var_baeb5712)
				{
					self thread scene::init("p7_fxanim_zm_island_spores_wall_stage_01_bundle");
				}
				else
				{
					self thread scene::init("p7_fxanim_zm_island_spores_rock_stage_01_bundle");
				}
				break;
			}
			case 5:
			{
				self scene::stop(1);
				if(isdefined(self.var_4df7e11b) && self.var_4df7e11b.size > 0)
				{
					self.var_4df7e11b = array::remove_undefined(self.var_4df7e11b);
					array::run_all(self.var_4df7e11b, &delete);
					self.var_4df7e11b = [];
				}
				if(self.var_baeb5712)
				{
					self thread scene::init("p7_fxanim_zm_island_spores_wall_stage_01_bundle");
				}
				else
				{
					self thread scene::init("p7_fxanim_zm_island_spores_rock_stage_01_bundle");
				}
				break;
			}
		}
	}
	else
	{
		self scene::stop(1);
		if(self.var_baeb5712)
		{
			self scene::add_scene_func("p7_fxanim_zm_island_spores_wall_stage_03_bundle", &function_dd0015d, "play");
			self scene_play("p7_fxanim_zm_island_spores_wall_stage_03_bundle");
		}
		else
		{
			self scene::add_scene_func("p7_fxanim_zm_island_spores_rock_stage_03_bundle", &function_dd0015d, "play");
			self scene_play("p7_fxanim_zm_island_spores_rock_stage_03_bundle");
		}
		if(isdefined(self.var_4df7e11b) && self.var_4df7e11b.size > 0)
		{
			self.var_4df7e11b = array::remove_undefined(self.var_4df7e11b);
			array::run_all(self.var_4df7e11b, &delete);
			self.var_4df7e11b = [];
		}
		if(self.var_baeb5712)
		{
			self thread scene::init("p7_fxanim_zm_island_spores_wall_stage_01_bundle");
		}
		else
		{
			self thread scene::init("p7_fxanim_zm_island_spores_rock_stage_01_bundle");
		}
	}
}

/*
	Name: scene_play
	Namespace: zm_island_spores
	Checksum: 0x584B5E1E
	Offset: 0x1920
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function scene_play(scene)
{
	self notify(#"scene_play");
	self endon(#"scene_play");
	self scene::stop();
	self function_6221b6b9(scene);
	self scene::stop();
}

/*
	Name: function_6221b6b9
	Namespace: zm_island_spores
	Checksum: 0x10C21C44
	Offset: 0x1998
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function function_6221b6b9(scene, var_165d49f6)
{
	level endon(#"demo_jump");
	self scene::play(scene);
}

/*
	Name: function_dd0015d
	Namespace: zm_island_spores
	Checksum: 0x2B6675A4
	Offset: 0x19D8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_dd0015d(a_ents)
{
	if(!isdefined(self.var_4df7e11b))
	{
		self.var_4df7e11b = [];
	}
	self.var_4df7e11b = arraycombine(self.var_4df7e11b, a_ents, 0, 0);
}

/*
	Name: function_6225657f
	Namespace: zm_island_spores
	Checksum: 0xB37AB55D
	Offset: 0x1A30
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function function_6225657f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum))
	{
		return;
	}
	if(newval)
	{
		self thread function_3ba5e2ae(localclientnum);
	}
	else
	{
		self thread function_7be165af(localclientnum);
	}
}

/*
	Name: function_3ba5e2ae
	Namespace: zm_island_spores
	Checksum: 0x19ED3A56
	Offset: 0x1AD8
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_3ba5e2ae(localclientnum)
{
	self endon(#"death");
	if(!isdefined(self.var_ea3e4398))
	{
		self.var_ea3e4398 = playfxoncamera(localclientnum, level._effect["SPORE_BUBBLES"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		self thread function_9067dab6(localclientnum);
	}
}

/*
	Name: function_7be165af
	Namespace: zm_island_spores
	Checksum: 0x6582DA54
	Offset: 0x1B60
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_7be165af(localclientnum)
{
	if(isdefined(self.var_ea3e4398))
	{
		deletefx(localclientnum, self.var_ea3e4398, 1);
		self.var_ea3e4398 = undefined;
	}
	self notify(#"hash_a48959b9");
}

/*
	Name: function_9067dab6
	Namespace: zm_island_spores
	Checksum: 0xC9AD6A81
	Offset: 0x1BC0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_9067dab6(localclientnum)
{
	self endon(#"hash_a48959b9");
	self waittill(#"death");
	self function_7be165af(localclientnum);
}

/*
	Name: spore_camera_fx
	Namespace: zm_island_spores
	Checksum: 0x87175BB5
	Offset: 0x1C08
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function spore_camera_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum))
	{
		return;
	}
	if(newval == 1)
	{
		self thread function_4ff31749(localclientnum, 1);
	}
	else
	{
		if(newval == 2)
		{
			self thread function_4ff31749(localclientnum, 0);
		}
		else
		{
			self thread function_b8071fc(localclientnum);
		}
	}
}

/*
	Name: function_4ff31749
	Namespace: zm_island_spores
	Checksum: 0xE27D639D
	Offset: 0x1CE8
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function function_4ff31749(localclientnum, var_c55abf21)
{
	self endon(#"death");
	if(!isdefined(self.var_adac13ec))
	{
		if(var_c55abf21)
		{
			self.var_adac13ec = playfxoncamera(localclientnum, level._effect["SPORE_TRAIL_GOOD_CAM"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		}
		else
		{
			self.var_adac13ec = playfxoncamera(localclientnum, level._effect["SPORE_TRAIL_CAM"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		}
		self thread function_c0e328f2(localclientnum);
	}
}

/*
	Name: function_b8071fc
	Namespace: zm_island_spores
	Checksum: 0xB6AABCA5
	Offset: 0x1DC0
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_b8071fc(localclientnum)
{
	if(isdefined(self.var_adac13ec))
	{
		deletefx(localclientnum, self.var_adac13ec, 1);
		self.var_adac13ec = undefined;
	}
	self notify(#"hash_6cc118c6");
}

/*
	Name: function_c0e328f2
	Namespace: zm_island_spores
	Checksum: 0xE7BE9A04
	Offset: 0x1E20
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_c0e328f2(localclientnum)
{
	self endon(#"hash_6cc118c6");
	self waittill(#"death");
	self function_b8071fc(localclientnum);
}

