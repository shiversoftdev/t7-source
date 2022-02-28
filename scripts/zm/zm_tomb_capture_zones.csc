// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#using_animtree("generic");

#namespace zm_tomb_capture_zones;

/*
	Name: init_structs
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8E09BC50
	Offset: 0xE18
	Size: 0x59C
	Parameters: 0
	Flags: Linked
*/
function init_structs()
{
	level.zombie_custom_riser_fx_handler = &function_5f50cf29;
	level.var_d7512031 = 0;
	clientfield::register("world", "packapunch_anim", 21000, 3, "int", &play_pap_anim, 0, 0);
	clientfield::register("actor", "zone_capture_zombie", 21000, 1, "int", &function_a412a80d, 0, 0);
	clientfield::register("scriptmover", "zone_capture_emergence_hole", 21000, 1, "int", &function_be0738b1, 0, 0);
	clientfield::register("world", "zc_change_progress_bar_color", 21000, 1, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("world", "zone_capture_hud_all_generators_captured", 21000, 1, "int", &function_ac197e52, 0, 1);
	setupclientfieldcodecallbacks("world", 1, "zone_capture_hud_all_generators_captured");
	clientfield::register("world", "pap_monolith_ring_shake", 21000, 1, "counter", &pap_monolith_ring_shake, 0, 0);
	clientfield::register("world", "zone_capture_perk_machine_smoke_fx_always_on", 21000, 1, "int", &function_daf4318, 0, 0);
	clientfield::register("clientuimodel", "zmInventory.capture_generator_wheel_widget", 21000, 1, "int", undefined, 0, 0);
	clientfield::register("zbarrier", "pap_emissive_fx", 21000, 1, "int", &pap_emissive_fx, 0, 0);
	a_s_generator = struct::get_array("s_generator", "targetname");
	foreach(struct in a_s_generator)
	{
		clientfield::register("world", struct.script_noteworthy, 21000, 7, "float", &function_a6f34d1c, 0, 0);
		clientfield::register("world", "state_" + struct.script_noteworthy, 21000, 3, "int", &function_d56a2c4b, 0, 0);
		clientfield::register("world", "zone_capture_hud_generator_" + struct.script_int, 21000, 2, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
		clientfield::register("world", "zone_capture_monolith_crystal_" + struct.script_int, 21000, 1, "int", &function_54aa6e5c, 0, 0);
		clientfield::register("world", "zone_capture_perk_machine_smoke_fx_" + struct.script_int, 21000, 1, "int", &function_6543186c, 0, 0);
		setupclientfieldcodecallbacks("world", 1, "zone_capture_hud_generator_" + struct.script_int);
	}
	level._effect["zone_capture_damage_spark"] = "dlc5/tomb/fx_tomb_mech_dmg_armor";
	level._effect["zone_capture_damage_steam"] = "dlc1/castle/fx_mech_dmg_steam";
	level._effect["zone_capture_zombie_spawn"] = "dlc5/tomb/fx_tomb_emergence_spawn";
	function_3ec54bc4();
	function_7cc68e33();
	function_a4e6d2a7();
}

/*
	Name: function_a6f34d1c
	Namespace: zm_tomb_capture_zones
	Checksum: 0x153E6F17
	Offset: 0x13C0
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_a6f34d1c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	m_generator = function_f424a041(fieldname, localclientnum);
	m_generator function_c516c0e9(localclientnum, oldval, newval);
}

/*
	Name: function_c1a782c1
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1EBA8555
	Offset: 0x1450
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function function_c1a782c1()
{
	self clearanim("p7_fxanim_zm_ori_generator_fluid_up_anim", 0);
	self clearanim("p7_fxanim_zm_ori_generator_fluid_down_anim", 0);
}

/*
	Name: function_9c5303ba
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1E0C8CC9
	Offset: 0x14A0
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_9c5303ba(var_ce864151 = 0)
{
	n_blend_time = 0.2;
	if(var_ce864151)
	{
		n_blend_time = 0;
	}
	self clearanim("p7_fxanim_zm_ori_generator_start_anim", n_blend_time);
	self clearanim("p7_fxanim_zm_ori_generator_up_idle_anim", n_blend_time);
	self clearanim("p7_fxanim_zm_ori_generator_down_idle_anim", n_blend_time);
	self clearanim("p7_fxanim_zm_ori_generator_end_anim", n_blend_time);
}

/*
	Name: function_c516c0e9
	Namespace: zm_tomb_capture_zones
	Checksum: 0x26FA4447
	Offset: 0x1570
	Size: 0x14C
	Parameters: 3
	Flags: Linked
*/
function function_c516c0e9(localclientnumber, oldval, newval)
{
	if(newval == 1)
	{
		self clearanim("p7_fxanim_zm_ori_generator_fluid_rotate_down_anim", 0.2);
		self setanim("p7_fxanim_zm_ori_generator_fluid_rotate_up_anim", 1, 0.2, 1);
	}
	else if(newval < oldval && oldval == 1)
	{
		self clearanim("p7_fxanim_zm_ori_generator_fluid_rotate_up_anim", 0.2);
		self setanim("p7_fxanim_zm_ori_generator_fluid_rotate_down_anim", 1, 0.2, 1);
		wait(getanimlength("p7_fxanim_zm_ori_generator_fluid_rotate_down_anim"));
		self clearanim("p7_fxanim_zm_ori_generator_fluid_rotate_down_anim", 0.2);
	}
	self function_f937236c(newval);
}

/*
	Name: function_f937236c
	Namespace: zm_tomb_capture_zones
	Checksum: 0x87093BA
	Offset: 0x16C8
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function function_f937236c(newval, var_ce864151 = 0)
{
	n_blend_time = 0.2;
	if(var_ce864151)
	{
		n_blend_time = 0;
	}
	self setanim("p7_fxanim_zm_ori_generator_fluid_up_anim", newval, n_blend_time, 1);
	self setanim("p7_fxanim_zm_ori_generator_fluid_down_anim", 1 - newval, n_blend_time, 1);
	self function_7c4c8c42(newval);
}

/*
	Name: function_f424a041
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1D22ECC4
	Offset: 0x1790
	Size: 0x176
	Parameters: 2
	Flags: Linked
*/
function function_f424a041(str_name, localclientnumber)
{
	if(!isdefined(level.var_92a1717d))
	{
		level.var_92a1717d = [];
	}
	if(!isdefined(level.var_92a1717d[localclientnumber]))
	{
		level.var_92a1717d[localclientnumber] = [];
	}
	if(!isdefined(level.var_92a1717d[localclientnumber][str_name]))
	{
		level.var_92a1717d[localclientnumber][str_name] = getent(localclientnumber, str_name, "targetname");
	}
	/#
		assert(isdefined(level.var_92a1717d[localclientnumber][str_name]), ("" + str_name) + "");
	#/
	level.var_92a1717d[localclientnumber][str_name] util::waittill_dobj(localclientnumber);
	if(!level.var_92a1717d[localclientnumber][str_name] hasanimtree())
	{
		level.var_92a1717d[localclientnumber][str_name] useanimtree($generic);
	}
	return level.var_92a1717d[localclientnumber][str_name];
}

/*
	Name: function_d56a2c4b
	Namespace: zm_tomb_capture_zones
	Checksum: 0x7EE2409A
	Offset: 0x1910
	Size: 0x23A
	Parameters: 7
	Flags: Linked
*/
function function_d56a2c4b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	m_generator = function_f424a041(getsubstr(fieldname, 6), localclientnum);
	if(newval == 6)
	{
		m_generator function_bbdb6db3(localclientnum);
		return;
	}
	n_blend_time = 0.2;
	if(bnewent || binitialsnap || bwasdemojump)
	{
		n_blend_time = 0;
	}
	m_generator function_9c5303ba();
	m_generator notify(#"hash_a7f9aff7");
	if(newval != 0)
	{
		m_generator thread function_d66ac605(localclientnum);
	}
	switch(newval)
	{
		case 0:
		{
			m_generator generator_state_off(localclientnum, n_blend_time);
			break;
		}
		case 1:
		{
			m_generator generator_state_turn_on(localclientnum, n_blend_time);
			break;
		}
		case 2:
		{
			m_generator generator_state_power_up(localclientnum, n_blend_time);
			break;
		}
		case 3:
		{
			m_generator generator_state_power_down(localclientnum, n_blend_time);
			break;
		}
		case 5:
		{
			m_generator function_3414585a(localclientnum, n_blend_time);
			break;
		}
		case 4:
		{
			m_generator generator_state_turn_off(localclientnum, n_blend_time);
			break;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: function_d66ac605
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1789777E
	Offset: 0x1B58
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function function_d66ac605(localclientnumber)
{
	self endon(#"entityshutdown");
	self.var_c4cb7bc3 = 1;
	while(isdefined(self.var_c4cb7bc3) && self.var_c4cb7bc3)
	{
		playrumbleonposition(localclientnumber, "generator_active", self.origin);
		wait(0.3);
	}
}

/*
	Name: generator_state_off
	Namespace: zm_tomb_capture_zones
	Checksum: 0x59BF9A1E
	Offset: 0x1BC8
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function generator_state_off(localclientnumber, n_blend_time)
{
	self.var_c4cb7bc3 = 0;
	self function_71e86201();
	self mapshaderconstant(localclientnumber, 0, "ScriptVector2", 0, 0, 0, 0);
	self function_312726e4(localclientnumber);
	self thread function_7be891d1(localclientnumber);
}

/*
	Name: generator_state_turn_on
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF064B92D
	Offset: 0x1C60
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function generator_state_turn_on(localclientnumber, n_blend_time)
{
	self setanim("p7_fxanim_zm_ori_generator_start_anim", 1, n_blend_time, 1);
	self mapshaderconstant(localclientnumber, 0, "ScriptVector2", 0, 1, 0, 0);
	self function_f6af797d(localclientnumber);
	self function_3f53e168(localclientnumber);
}

/*
	Name: generator_state_power_up
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB82CE97D
	Offset: 0x1D00
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function generator_state_power_up(localclientnumber, n_blend_time)
{
	self setanim("p7_fxanim_zm_ori_generator_up_idle_anim", 1, n_blend_time, 1);
	self mapshaderconstant(localclientnumber, 0, "ScriptVector2", 0, 1, 0, 0);
	self function_f6af797d(localclientnumber);
	self function_3f53e168(localclientnumber);
}

/*
	Name: generator_state_power_down
	Namespace: zm_tomb_capture_zones
	Checksum: 0x4782384C
	Offset: 0x1DA0
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function generator_state_power_down(localclientnumber, n_blend_time)
{
	self setanim("p7_fxanim_zm_ori_generator_down_idle_anim", 1, n_blend_time, 1);
	self mapshaderconstant(localclientnumber, 0, "ScriptVector2", 0, 1, 0, 0);
}

/*
	Name: function_3414585a
	Namespace: zm_tomb_capture_zones
	Checksum: 0x37BCA49E
	Offset: 0x1E10
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function function_3414585a(localclientnumber, n_blend_time)
{
	self generator_state_power_down(localclientnumber, n_blend_time);
	self function_c1810bcc(localclientnumber);
}

/*
	Name: function_c1810bcc
	Namespace: zm_tomb_capture_zones
	Checksum: 0x2B919D00
	Offset: 0x1E68
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_c1810bcc(localclientnumber)
{
	self thread function_8daa207b(localclientnumber);
	self thread function_afe4ef7e(localclientnumber);
}

/*
	Name: function_8daa207b
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA562114A
	Offset: 0x1EB0
	Size: 0x108
	Parameters: 1
	Flags: Linked
*/
function function_8daa207b(localclientnumber)
{
	self notify(#"hash_74845d8b");
	self endon(#"hash_74845d8b");
	self endon(#"hash_a0c3abea");
	if(!isdefined(self.var_25ac834))
	{
		self.var_25ac834 = [];
	}
	a_tags = array("fx_side_exhaust01", "fx_frnt_exhaust", "fx_side_exhaust02", "j_piston_01");
	while(true)
	{
		self.var_25ac834[localclientnumber] = playfxontag(localclientnumber, level._effect["zone_capture_damage_spark"], self, array::random(a_tags));
		wait(randomfloatrange(0.15, 0.35));
	}
}

/*
	Name: function_afe4ef7e
	Namespace: zm_tomb_capture_zones
	Checksum: 0x93591B35
	Offset: 0x1FC0
	Size: 0x108
	Parameters: 1
	Flags: Linked
*/
function function_afe4ef7e(localclientnumber)
{
	self notify(#"hash_e3f7fe2e");
	self endon(#"hash_e3f7fe2e");
	self endon(#"hash_a0c3abea");
	if(!isdefined(self.var_9fe4037d))
	{
		self.var_9fe4037d = [];
	}
	a_tags = array("fx_side_exhaust01", "fx_frnt_exhaust", "fx_side_exhaust02", "j_piston_01");
	while(true)
	{
		self.var_9fe4037d[localclientnumber] = playfxontag(localclientnumber, level._effect["zone_capture_damage_steam"], self, array::random(a_tags));
		wait(randomfloatrange(0.25, 0.35));
	}
}

/*
	Name: function_501771e3
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8905683F
	Offset: 0x20D0
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_501771e3(localclientnumber)
{
	self notify(#"hash_a0c3abea");
	if(isdefined(self.var_25ac834) && isdefined(self.var_25ac834[localclientnumber]))
	{
		deletefx(localclientnumber, self.var_25ac834[localclientnumber], 1);
	}
	if(isdefined(self.var_9fe4037d) && isdefined(self.var_9fe4037d[localclientnumber]))
	{
		deletefx(localclientnumber, self.var_9fe4037d[localclientnumber], 1);
	}
}

/*
	Name: function_bbdb6db3
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8CCA09C
	Offset: 0x2188
	Size: 0x1A2
	Parameters: 1
	Flags: Linked
*/
function function_bbdb6db3(localclientnumber)
{
	if(!isdefined(self.var_244ac37))
	{
		self.var_244ac37 = [];
	}
	if(isdefined(self.var_244ac37[localclientnumber]))
	{
		stopfx(localclientnumber, self.var_244ac37[localclientnumber]);
	}
	var_a1c15b1a = self.targetname;
	var_2a0fd09 = undefined;
	switch(var_a1c15b1a)
	{
		case "generator_start_bunker":
		{
			var_2a0fd09 = level._effect["capture_complete_1"];
			break;
		}
		case "generator_tank_trench":
		{
			var_2a0fd09 = level._effect["capture_complete_2"];
			break;
		}
		case "generator_mid_trench":
		{
			var_2a0fd09 = level._effect["capture_complete_3"];
			break;
		}
		case "generator_nml_right":
		{
			var_2a0fd09 = level._effect["capture_complete_4"];
			break;
		}
		case "generator_nml_left":
		{
			var_2a0fd09 = level._effect["capture_complete_5"];
			break;
		}
		case "generator_church":
		{
			var_2a0fd09 = level._effect["capture_complete_6"];
			break;
		}
		default:
		{
			return;
		}
	}
	self.var_244ac37[localclientnumber] = playfxontag(localclientnumber, var_2a0fd09, self, "j_generator_pole");
}

/*
	Name: generator_state_turn_off
	Namespace: zm_tomb_capture_zones
	Checksum: 0x469960C6
	Offset: 0x2338
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function generator_state_turn_off(localclientnumber, n_blend_time)
{
	self setanim("p7_fxanim_zm_ori_generator_end_anim", 1, n_blend_time, 1);
	self mapshaderconstant(localclientnumber, 0, "ScriptVector2", 0, 0, 0, 0);
	self function_312726e4(localclientnumber);
	self thread function_7be891d1(localclientnumber);
}

/*
	Name: function_7c4c8c42
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3BCD1A58
	Offset: 0x23D8
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function function_7c4c8c42(newval)
{
	if(!isdefined(self.var_be886049))
	{
		sndorigin = self gettagorigin("j_generator_pole");
		self.var_be886049 = spawn(0, sndorigin, "script_origin");
		self.var_be886049 linkto(self, "j_generator_pole");
		playsound(0, "zmb_capturezone_donut_start", self.origin);
		self.var_be886049 thread function_3a4d4e97();
	}
	pitch = audio::scale_speed(0, 1, 0.8, 1.6, newval);
	loop_id = self.var_be886049 playloopsound("zmb_capturezone_rise", 1);
	setsoundpitch(loop_id, pitch);
	self function_738a49be(1);
}

/*
	Name: function_71e86201
	Namespace: zm_tomb_capture_zones
	Checksum: 0xAB9939AD
	Offset: 0x2550
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_71e86201()
{
	if(isdefined(self.var_ffb79f2))
	{
		playsound(0, "zmb_capturezone_donut_stop", self.origin);
		self.var_be886049 delete();
		self.var_be886049 = undefined;
	}
	self function_738a49be(0);
}

/*
	Name: function_f6af797d
	Namespace: zm_tomb_capture_zones
	Checksum: 0x894DF69C
	Offset: 0x25C8
	Size: 0x26A
	Parameters: 1
	Flags: Linked
*/
function function_f6af797d(localclientnumber)
{
	self function_312726e4(localclientnumber);
	var_a1c15b1a = self.targetname;
	var_2a0fd09 = undefined;
	switch(var_a1c15b1a)
	{
		case "generator_start_bunker":
		{
			var_2a0fd09 = level._effect["capture_progression_1"];
			break;
		}
		case "generator_tank_trench":
		{
			var_2a0fd09 = level._effect["capture_progression_2"];
			break;
		}
		case "generator_mid_trench":
		{
			var_2a0fd09 = level._effect["capture_progression_3"];
			break;
		}
		case "generator_nml_right":
		{
			var_2a0fd09 = level._effect["capture_progression_4"];
			break;
		}
		case "generator_nml_left":
		{
			var_2a0fd09 = level._effect["capture_progression_5"];
			break;
		}
		case "generator_church":
		{
			var_2a0fd09 = level._effect["capture_progression_6"];
			break;
		}
		default:
		{
			return;
		}
	}
	self.var_244ac37[localclientnumber] = playfxontag(localclientnumber, var_2a0fd09, self, "j_generator_pole");
	self.var_878c304c[localclientnumber] = playfxontag(localclientnumber, level._effect["capture_exhaust_front"], self, "fx_frnt_exhaust");
	self.var_7078bcfd[localclientnumber] = playfxontag(localclientnumber, level._effect["capture_exhaust_rear"], self, "fx_rear_exhaust");
	self.var_eb98b036[localclientnumber] = playfxontag(localclientnumber, level._effect["capture_exhaust_side"], self, "fx_vat_exhaust01");
	self.var_c59635cd[localclientnumber] = playfxontag(localclientnumber, level._effect["capture_exhaust_side"], self, "fx_vat_exhaust02");
}

/*
	Name: function_312726e4
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE39F3E97
	Offset: 0x2840
	Size: 0x1B4
	Parameters: 1
	Flags: Linked
*/
function function_312726e4(localclientnumber)
{
	if(!isdefined(self.var_244ac37))
	{
		self.var_244ac37 = [];
	}
	if(isdefined(self.var_244ac37[localclientnumber]))
	{
		stopfx(localclientnumber, self.var_244ac37[localclientnumber]);
	}
	if(!isdefined(self.var_878c304c))
	{
		self.var_878c304c = [];
	}
	if(!isdefined(self.var_7078bcfd))
	{
		self.var_7078bcfd = [];
	}
	if(!isdefined(self.var_eb98b036))
	{
		self.var_eb98b036 = [];
	}
	if(!isdefined(self.var_c59635cd))
	{
		self.var_c59635cd = [];
	}
	if(isdefined(self.var_878c304c[localclientnumber]))
	{
		stopfx(localclientnumber, self.var_878c304c[localclientnumber]);
	}
	if(isdefined(self.var_7078bcfd[localclientnumber]))
	{
		stopfx(localclientnumber, self.var_7078bcfd[localclientnumber]);
	}
	if(isdefined(self.var_eb98b036[localclientnumber]))
	{
		stopfx(localclientnumber, self.var_eb98b036[localclientnumber]);
	}
	if(isdefined(self.var_c59635cd[localclientnumber]))
	{
		stopfx(localclientnumber, self.var_c59635cd[localclientnumber]);
	}
	self function_501771e3(localclientnumber);
}

/*
	Name: function_3f53e168
	Namespace: zm_tomb_capture_zones
	Checksum: 0x107883D0
	Offset: 0x2A00
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_3f53e168(localclientnumber)
{
	if(!isdefined(self.var_88677912))
	{
		self.var_88677912 = [];
	}
	if(isdefined(self.var_88677912[localclientnumber]))
	{
		deletefx(localclientnumber, self.var_88677912[localclientnumber], 1);
	}
}

/*
	Name: function_7be891d1
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB177ADB6
	Offset: 0x2A68
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function function_7be891d1(localclientnumber)
{
	self endon(#"hash_a7f9aff7");
	self function_3f53e168(localclientnumber);
	self.var_88677912[localclientnumber] = playfxontag(localclientnumber, level._effect["zapper_light_notready"], self, "tag_pole_top");
}

/*
	Name: scale_speed
	Namespace: zm_tomb_capture_zones
	Checksum: 0x95DD005A
	Offset: 0x2AE0
	Size: 0xCC
	Parameters: 5
	Flags: None
*/
function scale_speed(x1, x2, y1, y2, z)
{
	if(z < x1)
	{
		z = x1;
	}
	if(z > x2)
	{
		z = x2;
	}
	dx = x2 - x1;
	n = (z - x1) / dx;
	dy = y2 - y1;
	w = (n * dy) + y1;
	return w;
}

/*
	Name: function_738a49be
	Namespace: zm_tomb_capture_zones
	Checksum: 0x20CB5BB0
	Offset: 0x2BB8
	Size: 0x120
	Parameters: 1
	Flags: Linked
*/
function function_738a49be(start)
{
	if(!isdefined(self.var_f2b9c979))
	{
		self.var_f2b9c979 = 0;
	}
	origin1 = self gettagorigin("vat_01_sound");
	origin2 = self gettagorigin("vat_02_sound");
	if(start)
	{
		if(!self.var_f2b9c979)
		{
			audio::playloopat("zmb_capturezone_vat_loop", origin1);
			audio::playloopat("zmb_capturezone_vat_loop", origin2);
			self.var_f2b9c979 = 1;
		}
	}
	else
	{
		audio::stoploopat("zmb_capturezone_vat_loop", origin1);
		audio::stoploopat("zmb_capturezone_vat_loop", origin2);
		self.var_f2b9c979 = 0;
	}
}

/*
	Name: function_54aa6e5c
	Namespace: zm_tomb_capture_zones
	Checksum: 0x20AEBA8
	Offset: 0x2CE0
	Size: 0x1D4
	Parameters: 7
	Flags: Linked
*/
function function_54aa6e5c(localclientnumber, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	var_a0a565ad = function_24fcf23b(fieldname, localclientnumber);
	str_exploder = "fxexp_" + level.var_6aec00d3[fieldname];
	if(newval)
	{
		var_a0a565ad thread function_59c8afc0(localclientnumber, 0, 0.1, 2, 4, 0.5, 3);
		var_a0a565ad stoploopsound(1);
		exploder::stop_exploder(str_exploder, localclientnumber);
		level thread function_31e3b463(0, level.var_6aec00d3[fieldname]);
	}
	else
	{
		var_a0a565ad thread function_59c8afc0(localclientnumber, 0.65, 1, 0.7, 1, 0.05, 0.35);
		var_a0a565ad playloopsound("amb_monolith_glow");
		exploder::exploder(str_exploder, localclientnumber);
		level thread function_31e3b463(1, level.var_6aec00d3[fieldname]);
	}
}

/*
	Name: function_31e3b463
	Namespace: zm_tomb_capture_zones
	Checksum: 0xABEA51AF
	Offset: 0x2EC0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function function_31e3b463(play, num)
{
}

/*
	Name: function_59c8afc0
	Namespace: zm_tomb_capture_zones
	Checksum: 0xDD0CB07C
	Offset: 0x2EE0
	Size: 0x1B0
	Parameters: 7
	Flags: Linked
*/
function function_59c8afc0(localclientnumber, var_98ce6736, var_4333264, var_e2ad4e8e, var_22a5887c, var_48d50352, var_d056f9f8)
{
	self notify(#"hash_c0d7e9d");
	self endon(#"hash_c0d7e9d");
	if(!isdefined(self.var_40a6544d))
	{
		self.var_40a6544d = var_98ce6736;
	}
	while(true)
	{
		var_68feedab = randomfloatrange(var_98ce6736, var_4333264);
		n_transition_time = randomfloatrange(var_e2ad4e8e, var_22a5887c);
		n_steps = int(n_transition_time / 0.016);
		var_5885a5c5 = (var_68feedab - self.var_40a6544d) / n_steps;
		for(i = 0; i < n_steps; i++)
		{
			self.var_40a6544d = self.var_40a6544d + var_5885a5c5;
			self mapshaderconstant(localclientnumber, 2, "scriptVector2", self.var_40a6544d, 0, 0, 0);
			wait(0.016);
		}
		wait(randomfloatrange(var_48d50352, var_d056f9f8));
	}
}

/*
	Name: function_217d24cd
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC3E22AF7
	Offset: 0x3098
	Size: 0x116
	Parameters: 3
	Flags: Linked
*/
function function_217d24cd(localclientnumber, var_68feedab, n_transition_time)
{
	self notify(#"hash_c0d7e9d");
	self endon(#"hash_c0d7e9d");
	if(!isdefined(self.var_40a6544d))
	{
		self.var_40a6544d = 1;
	}
	n_steps = int(n_transition_time / 0.016);
	var_5885a5c5 = (var_68feedab - self.var_40a6544d) / n_steps;
	for(i = 0; i < n_steps; i++)
	{
		self.var_40a6544d = self.var_40a6544d + var_5885a5c5;
		self mapshaderconstant(localclientnumber, 2, "scriptVector2", self.var_40a6544d, 0, 0, 0);
		wait(0.016);
	}
}

/*
	Name: function_24fcf23b
	Namespace: zm_tomb_capture_zones
	Checksum: 0xFDD0C945
	Offset: 0x31B8
	Size: 0x1DE
	Parameters: 2
	Flags: Linked
*/
function function_24fcf23b(str_targetname, localclientnum)
{
	if(!isdefined(level.var_4cb39fae))
	{
		level.var_4cb39fae = [];
	}
	if(!isdefined(level.var_4cb39fae[localclientnum]))
	{
		level.var_4cb39fae[localclientnum] = [];
	}
	if(!isdefined(level.var_4cb39fae[localclientnum][str_targetname]))
	{
		level.var_4cb39fae[localclientnum][str_targetname] = getent(localclientnum, str_targetname, "targetname");
		level.var_4cb39fae[localclientnum][str_targetname].var_8d2380bb = [];
		level.var_4cb39fae[localclientnum][str_targetname].var_8d2380bb[localclientnum] = 0;
	}
	level.var_4cb39fae[localclientnum][str_targetname] util::waittill_dobj(localclientnum);
	if(!level.var_4cb39fae[localclientnum][str_targetname].var_8d2380bb[localclientnum])
	{
		level.var_4cb39fae[localclientnum][str_targetname] mapshaderconstant(localclientnum, 2, "scriptVector2", 0);
		level.var_4cb39fae[localclientnum][str_targetname].var_8d2380bb[localclientnum] = 1;
	}
	/#
		assert(isdefined(level.var_4cb39fae[localclientnum][str_targetname]), ("" + str_targetname) + "");
	#/
	return level.var_4cb39fae[localclientnum][str_targetname];
}

/*
	Name: function_ac197e52
	Namespace: zm_tomb_capture_zones
	Checksum: 0x64B4D5BA
	Offset: 0x33A0
	Size: 0x194
	Parameters: 7
	Flags: Linked
*/
function function_ac197e52(localclientnumber, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	var_eb1b4657 = function_12a07195(localclientnumber);
	if(isdefined(var_eb1b4657))
	{
		if(newval)
		{
			var_eb1b4657 thread function_aab40f28(localclientnumber, 3);
			var_eb1b4657 thread function_f35264ff();
		}
		else
		{
			var_eb1b4657 thread function_aab40f28(localclientnumber, 0);
			var_eb1b4657 thread function_3f73ddc3(oldval);
		}
	}
	var_82347477 = function_cd49ce76(localclientnumber);
	if(isdefined(var_82347477))
	{
		if(newval)
		{
			var_82347477 thread function_59c8afc0(localclientnumber, 0.65, 1, 0.7, 1, 0.05, 0.35);
		}
		else
		{
			var_82347477 show();
			var_82347477 thread function_217d24cd(localclientnumber, 0, 5);
		}
	}
}

/*
	Name: function_9164d089
	Namespace: zm_tomb_capture_zones
	Checksum: 0x97DE2781
	Offset: 0x3540
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_9164d089(localclientnumber)
{
	var_82347477 = function_cd49ce76(localclientnumber);
	if(isdefined(var_82347477))
	{
		var_82347477 hide();
	}
}

/*
	Name: function_f35264ff
	Namespace: zm_tomb_capture_zones
	Checksum: 0x342547DA
	Offset: 0x35A0
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function function_f35264ff()
{
	self notify(#"hash_3b22402e");
	self endon(#"hash_765cfe11");
	self function_4f226940();
	self setanim(%generic::p7_fxanim_zm_ori_monolith_inductor_pull_anim, 1, 0.2);
	waitrealtime((getanimlength(%generic::p7_fxanim_zm_ori_monolith_inductor_pull_anim)) - 0.2);
	self clearanim(%generic::p7_fxanim_zm_ori_monolith_inductor_pull_anim, 0.2);
	self setanim(%generic::p7_fxanim_zm_ori_monolith_inductor_pull_idle_anim, 1, 0.2);
	level.var_d7512031 = 1;
}

/*
	Name: function_3f73ddc3
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF52F364B
	Offset: 0x3698
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function function_3f73ddc3(oldval)
{
	self notify(#"hash_765cfe11");
	self endon(#"hash_3b22402e");
	self function_4f226940();
	if(oldval)
	{
		self setanim(%generic::p7_fxanim_zm_ori_monolith_inductor_release_anim, 1, 0.2);
		waitrealtime((getanimlength(%generic::p7_fxanim_zm_ori_monolith_inductor_release_anim)) - 0.2);
		self function_4f226940();
	}
	self setanim(%generic::p7_fxanim_zm_ori_monolith_inductor_idle_anim, 1, 0.2);
	level.var_d7512031 = 0;
}

/*
	Name: pap_monolith_ring_shake
	Namespace: zm_tomb_capture_zones
	Checksum: 0x4A0E125A
	Offset: 0x3790
	Size: 0x1EC
	Parameters: 7
	Flags: Linked
*/
function pap_monolith_ring_shake(localclientnumber, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	var_eb1b4657 = function_12a07195(localclientnumber);
	var_eb1b4657 endon(#"hash_3b22402e");
	if(newval == 1)
	{
		var_eb1b4657 function_4f226940();
		var_eb1b4657 setanim(%generic::p7_fxanim_zm_ori_monolith_inductor_shake_anim, 1, 0.2);
		waitrealtime((getanimlength(%generic::p7_fxanim_zm_ori_monolith_inductor_shake_anim)) - 0.2);
		var_eb1b4657 clearanim(%generic::p7_fxanim_zm_ori_monolith_inductor_shake_anim, 0.2);
		if(level.var_d7512031)
		{
			var_eb1b4657 setanim(%generic::p7_fxanim_zm_ori_monolith_inductor_pull_anim, 1, 0.2);
			waitrealtime((getanimlength(%generic::p7_fxanim_zm_ori_monolith_inductor_pull_anim)) - 0.2);
			var_eb1b4657 clearanim(%generic::p7_fxanim_zm_ori_monolith_inductor_pull_anim, 0.2);
			var_eb1b4657 setanim(%generic::p7_fxanim_zm_ori_monolith_inductor_pull_idle_anim, 1, 0.2);
		}
		else
		{
			var_eb1b4657 thread function_3f73ddc3(0);
		}
	}
}

/*
	Name: function_4f226940
	Namespace: zm_tomb_capture_zones
	Checksum: 0x34E4441D
	Offset: 0x3988
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_4f226940()
{
	self clearanim(%generic::p7_fxanim_zm_ori_monolith_inductor_pull_anim, 0.2);
	self clearanim(%generic::p7_fxanim_zm_ori_monolith_inductor_pull_idle_anim, 0.2);
	self clearanim(%generic::p7_fxanim_zm_ori_monolith_inductor_release_anim, 0.2);
	self clearanim(%generic::p7_fxanim_zm_ori_monolith_inductor_shake_anim, 0.2);
	self clearanim(%generic::p7_fxanim_zm_ori_monolith_inductor_idle_anim, 0.2);
}

/*
	Name: function_aab40f28
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8F5AA8DA
	Offset: 0x3A60
	Size: 0x148
	Parameters: 2
	Flags: Linked
*/
function function_aab40f28(localclientnumber, n_value)
{
	self notify(#"hash_c6efbac2");
	self endon(#"hash_c6efbac2");
	if(!isdefined(self.var_40a6544d))
	{
		self.var_40a6544d = [];
	}
	if(!isdefined(self.var_40a6544d[localclientnumber]))
	{
		self.var_40a6544d[localclientnumber] = 0;
	}
	n_delta = n_value - self.var_40a6544d[localclientnumber];
	n_increment = (n_delta / 4.5) * 0.016;
	while(self.var_40a6544d[localclientnumber] != n_value)
	{
		self.var_40a6544d[localclientnumber] = math::clamp(self.var_40a6544d[localclientnumber] + n_increment, 0, 3);
		self mapshaderconstant(localclientnumber, 3, "scriptVector2", 0, self.var_40a6544d[localclientnumber], 0, 0);
		wait(0.016);
	}
}

/*
	Name: function_12a07195
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB0DBEBB0
	Offset: 0x3BB0
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function function_12a07195(localclientnumber)
{
	if(!isdefined(level.var_9920ede0))
	{
		level.var_9920ede0 = [];
	}
	if(!isdefined(level.var_9920ede0[localclientnumber]))
	{
		level.var_9920ede0[localclientnumber] = getent(localclientnumber, "pap_monolith_ring", "targetname");
	}
	level.var_9920ede0[localclientnumber] util::waittill_dobj(localclientnumber);
	if(!level.var_9920ede0[localclientnumber] hasanimtree())
	{
		level.var_9920ede0[localclientnumber] mapshaderconstant(localclientnumber, 3, "scriptVector2", 0, 0, 0, 0);
		level.var_9920ede0[localclientnumber] useanimtree($generic);
	}
	return level.var_9920ede0[localclientnumber];
}

/*
	Name: function_be0738b1
	Namespace: zm_tomb_capture_zones
	Checksum: 0x358B24E6
	Offset: 0x3CD0
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function function_be0738b1(localclientnumber, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		self emergence_hole_spawn(localclientnumber);
	}
	else
	{
		var_4478dceb = self function_45d7dc5a(localclientnumber, oldval && !bnewent && !bwasdemojump);
		self function_345cde91(localclientnumber, var_4478dceb);
	}
}

/*
	Name: emergence_hole_spawn
	Namespace: zm_tomb_capture_zones
	Checksum: 0xD511D2D2
	Offset: 0x3DA0
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function emergence_hole_spawn(localclientnumber)
{
	self function_345cde91(localclientnumber);
	self.var_a326f0e[localclientnumber] = playfxontag(localclientnumber, level._effect["tesla_elec_kill"], self, "tag_origin");
	self.var_70ef4eef[localclientnumber] = playfxontag(localclientnumber, level._effect["screecher_hole"], self, "tag_origin");
	if(!isdefined(self.sndent))
	{
		self.sndent = spawn(localclientnumber, self.origin, "script_origin");
		self.sndent thread function_3a4d4e97();
	}
	self.sndent playloopsound("zmb_capturezone_portal_loop", 2);
	playsound(localclientnumber, "zmb_capturezone_portal_start", self.origin);
}

/*
	Name: function_3a4d4e97
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC88CA6A6
	Offset: 0x3EF0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_3a4d4e97()
{
	self endon(#"entityshutdown");
	level waittill(#"demo_jump");
	self delete();
}

/*
	Name: function_45d7dc5a
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3109B476
	Offset: 0x3F30
	Size: 0x82
	Parameters: 2
	Flags: Linked
*/
function function_45d7dc5a(localclientnumber, var_4f49ffe0)
{
	if(var_4f49ffe0)
	{
		var_4478dceb = 0;
		playfxontag(localclientnumber, level._effect["tesla_elec_kill"], self, "tag_origin");
		playsound(localclientnumber, "zmb_capturezone_portal_stop");
	}
	return !var_4f49ffe0;
}

/*
	Name: function_345cde91
	Namespace: zm_tomb_capture_zones
	Checksum: 0xEB2A52F0
	Offset: 0x3FC0
	Size: 0x174
	Parameters: 2
	Flags: Linked
*/
function function_345cde91(localclientnumber, var_4478dceb = 1)
{
	if(!isdefined(self.var_a326f0e))
	{
		self.var_a326f0e = [];
	}
	if(!isdefined(self.var_70ef4eef))
	{
		self.var_70ef4eef = [];
	}
	if(!isdefined(self.var_6ecbad39))
	{
		self.var_6ecbad39 = [];
	}
	if(isdefined(self.var_70ef4eef[localclientnumber]))
	{
		deletefx(localclientnumber, self.var_a326f0e[localclientnumber], 1);
		self.var_a326f0e[localclientnumber] = undefined;
	}
	if(isdefined(self.var_70ef4eef[localclientnumber]))
	{
		deletefx(localclientnumber, self.var_70ef4eef[localclientnumber], 1);
		self.var_70ef4eef[localclientnumber] = undefined;
	}
	if(var_4478dceb)
	{
		if(isdefined(self.var_6ecbad39[localclientnumber]))
		{
			deletefx(localclientnumber, self.var_6ecbad39[localclientnumber], 1);
			self.var_6ecbad39[localclientnumber] = undefined;
		}
	}
	if(isdefined(self.sndent))
	{
		self.sndent delete();
	}
}

/*
	Name: function_5f50cf29
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE0E1518A
	Offset: 0x4140
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_5f50cf29()
{
	if(self._aitype === "zm_tomb_basic_zone_capture")
	{
		s_info = spawnstruct();
		s_info.burst_fx = level._effect["zone_capture_zombie_spawn"];
		s_info.billow_fx = level._effect["zone_capture_zombie_spawn"];
		s_info.type = "none";
		return s_info;
	}
}

/*
	Name: function_7cc68e33
	Namespace: zm_tomb_capture_zones
	Checksum: 0xCB24D87C
	Offset: 0x41E0
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_7cc68e33()
{
	function_6784d594(0, undefined, %generic::p7_fxanim_zm_ori_pack_return_pc1_anim);
	function_6784d594(1, %generic::p7_fxanim_zm_ori_pack_pc1_anim, %generic::p7_fxanim_zm_ori_pack_return_pc2_anim);
	function_6784d594(2, %generic::p7_fxanim_zm_ori_pack_pc2_anim, %generic::p7_fxanim_zm_ori_pack_return_pc3_anim);
	function_6784d594(3, %generic::p7_fxanim_zm_ori_pack_pc3_anim, %generic::p7_fxanim_zm_ori_pack_return_pc4_anim);
	function_6784d594(4, %generic::p7_fxanim_zm_ori_pack_pc4_anim, %generic::p7_fxanim_zm_ori_pack_return_pc5_anim);
	function_6784d594(5, %generic::p7_fxanim_zm_ori_pack_pc5_anim, %generic::p7_fxanim_zm_ori_pack_return_pc6_anim);
	function_6784d594(6, %generic::p7_fxanim_zm_ori_pack_pc6_anim, undefined);
}

/*
	Name: play_pap_anim
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8402969F
	Offset: 0x4320
	Size: 0x326
	Parameters: 7
	Flags: Linked
*/
function play_pap_anim(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	var_29003520 = function_cd49ce76(localclientnum);
	var_c0fc4c20 = bnewent || binitialsnap || bwasdemojump;
	if(newval > oldval || var_c0fc4c20)
	{
		for(i = 1; i <= newval; i++)
		{
			n_anim_time = 1;
			n_anim_rate = 0;
			if(i == newval && !var_c0fc4c20)
			{
				n_anim_time = 0;
				n_anim_rate = 1;
			}
			var_f24fe15c = level.var_f983511b["disassemble"][i - 1];
			if(isdefined(var_f24fe15c))
			{
				var_29003520 clearanim(var_f24fe15c, 0);
			}
			var_c930c99 = level.var_f983511b["assemble"][i];
			var_29003520 setanim(var_c930c99, 1, 0, n_anim_rate);
			var_29003520 setanimtime(var_c930c99, n_anim_time);
		}
	}
	else if(newval < oldval)
	{
		for(i = level.var_f983511b["disassemble"].size - 1; i >= newval; i--)
		{
			n_anim_time = 1;
			n_anim_rate = 0;
			if(i == newval)
			{
				n_anim_time = 0;
				n_anim_rate = 1;
			}
			var_f24fe15c = level.var_f983511b["assemble"][i + 1];
			if(isdefined(var_f24fe15c))
			{
				var_29003520 clearanim(var_f24fe15c, 0);
			}
			var_653a11db = level.var_f983511b["disassemble"][i];
			var_29003520 setanim(var_653a11db, 1, n_anim_time, n_anim_rate);
			var_29003520 setanimtime(var_653a11db, n_anim_time);
		}
	}
}

/*
	Name: function_6784d594
	Namespace: zm_tomb_capture_zones
	Checksum: 0x24018A81
	Offset: 0x4650
	Size: 0xC4
	Parameters: 3
	Flags: Linked
*/
function function_6784d594(n_index, var_c930c99, var_653a11db)
{
	if(!isdefined(level.var_f983511b))
	{
		level.var_f983511b = [];
	}
	if(!isdefined(level.var_f983511b["assemble"]))
	{
		level.var_f983511b["assemble"] = [];
	}
	if(!isdefined(level.var_f983511b["disassemble"]))
	{
		level.var_f983511b["disassemble"] = [];
	}
	level.var_f983511b["assemble"][n_index] = var_c930c99;
	level.var_f983511b["disassemble"][n_index] = var_653a11db;
}

/*
	Name: function_cd49ce76
	Namespace: zm_tomb_capture_zones
	Checksum: 0x1DFAF84A
	Offset: 0x4720
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function function_cd49ce76(localclientnumber)
{
	if(!isdefined(level.var_6a68eb65))
	{
		level.var_6a68eb65 = [];
	}
	if(!isdefined(level.var_6a68eb65[localclientnumber]))
	{
		level.var_6a68eb65[localclientnumber] = getent(localclientnumber, "pap_cs", "targetname");
	}
	level.var_6a68eb65[localclientnumber] util::waittill_dobj(localclientnumber);
	if(!level.var_6a68eb65[localclientnumber] hasanimtree())
	{
		level.var_6a68eb65[localclientnumber] useanimtree($generic);
		level.var_6a68eb65[localclientnumber] mapshaderconstant(localclientnumber, 2, "ScriptVector0", 1);
	}
	return level.var_6a68eb65[localclientnumber];
}

/*
	Name: function_902e1a6d
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE7ADA483
	Offset: 0x4840
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function function_902e1a6d()
{
	util::waitforallclients();
	a_players = getlocalplayers();
	for(localclientnum = 0; localclientnum < a_players.size; localclientnum++)
	{
		var_3fe0feb2 = function_cd49ce76(localclientnum);
	}
}

/*
	Name: function_a412a80d
	Namespace: zm_tomb_capture_zones
	Checksum: 0xB60DD6ED
	Offset: 0x48C8
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function function_a412a80d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self._aitype = "zm_tomb_basic_zone_capture";
		self thread zm::handle_zombie_risers(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump);
		self._eyeglow_fx_override = level._effect["crusader_zombie_eyes"];
		self zm::deletezombieeyes(localclientnum);
		self zm::createzombieeyes(localclientnum);
		self function_82ce76c3(localclientnum);
	}
}

/*
	Name: function_82ce76c3
	Namespace: zm_tomb_capture_zones
	Checksum: 0xE240295D
	Offset: 0x49B8
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_82ce76c3(localclientnumber)
{
	self function_b031f5ce(localclientnumber);
	self.var_3199f723[localclientnumber] = playfxontag(localclientnumber, level._effect["zone_capture_zombie_torso_fx"], self, "J_Spine4");
	if(!isdefined(self.sndent))
	{
		self.sndent = spawn(0, self.origin, "script_origin");
		self.sndent linkto(self);
		self thread snddeleteent(self.sndent);
	}
	self.sndent playloopsound("zmb_capturezone_zombie_loop", 1);
}

/*
	Name: snddeleteent
	Namespace: zm_tomb_capture_zones
	Checksum: 0x501E2868
	Offset: 0x4AC0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function snddeleteent(ent)
{
	self util::waittill_any("death", "entityshutdown");
	if(isdefined(ent))
	{
		ent delete();
	}
}

/*
	Name: function_b031f5ce
	Namespace: zm_tomb_capture_zones
	Checksum: 0xBC20094F
	Offset: 0x4B20
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_b031f5ce(localclientnumber)
{
	if(!isdefined(self.var_3199f723))
	{
		self.var_3199f723 = [];
	}
	if(isdefined(self.var_3199f723[localclientnumber]))
	{
		deletefx(localclientnumber, self.var_3199f723[localclientnumber], 1);
	}
}

/*
	Name: function_a4e6d2a7
	Namespace: zm_tomb_capture_zones
	Checksum: 0xCF826BC5
	Offset: 0x4B88
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_a4e6d2a7()
{
	function_eebeeca5("zone_capture_monolith_crystal_1", 5001);
	function_eebeeca5("zone_capture_monolith_crystal_2", 5002);
	function_eebeeca5("zone_capture_monolith_crystal_3", 5003);
	function_eebeeca5("zone_capture_monolith_crystal_4", 5004);
	function_eebeeca5("zone_capture_monolith_crystal_5", 5005);
	function_eebeeca5("zone_capture_monolith_crystal_6", 5006);
}

/*
	Name: function_eebeeca5
	Namespace: zm_tomb_capture_zones
	Checksum: 0x9E9E38D3
	Offset: 0x4C58
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function function_eebeeca5(str_field_name, n_exploder_id)
{
	if(!isdefined(level.var_6aec00d3))
	{
		level.var_6aec00d3 = [];
	}
	if(!isdefined(level.var_6aec00d3[str_field_name]))
	{
		level.var_6aec00d3[str_field_name] = n_exploder_id;
	}
}

/*
	Name: function_3ec54bc4
	Namespace: zm_tomb_capture_zones
	Checksum: 0xFA41AC88
	Offset: 0x4CB8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_3ec54bc4()
{
	function_b27ab5bf("zone_capture_perk_machine_smoke_fx_1", "revive_pipes");
	function_b27ab5bf("zone_capture_perk_machine_smoke_fx_3", "speedcola_pipes");
	function_b27ab5bf("zone_capture_perk_machine_smoke_fx_4", "jugg_pipes");
	function_b27ab5bf("zone_capture_perk_machine_smoke_fx_5", "staminup_pipes");
}

/*
	Name: function_b27ab5bf
	Namespace: zm_tomb_capture_zones
	Checksum: 0xC18DD335
	Offset: 0x4D48
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function function_b27ab5bf(str_field_name, var_4560e0ce)
{
	if(!isdefined(level.var_2707a8c))
	{
		level.var_2707a8c = [];
	}
	if(!isdefined(level.var_2707a8c[str_field_name]))
	{
		level.var_2707a8c[str_field_name] = var_4560e0ce;
	}
}

/*
	Name: pap_emissive_fx
	Namespace: zm_tomb_capture_zones
	Checksum: 0xA2A1FC6F
	Offset: 0x4DA8
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function pap_emissive_fx(localclientnumber, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		self mapshaderconstant(localclientnumber, 0, "scriptVector2", 0, 1, 0, 0);
		level thread function_9164d089(localclientnumber);
	}
	else
	{
		self mapshaderconstant(localclientnumber, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

/*
	Name: function_daf4318
	Namespace: zm_tomb_capture_zones
	Checksum: 0x6C1BDC3A
	Offset: 0x4EA0
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_daf4318(localclientnumber, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		var_3aed1533 = struct::get("mulekick_pipes", "targetname");
		var_3aed1533 function_b64620a3(localclientnumber);
	}
}

/*
	Name: function_6543186c
	Namespace: zm_tomb_capture_zones
	Checksum: 0x3DBA3EC9
	Offset: 0x4F38
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function function_6543186c(localclientnumber, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	var_d26305ae = function_23d70c75(fieldname);
	if(isdefined(var_d26305ae))
	{
		if(newval == 1)
		{
			var_d26305ae function_b64620a3(localclientnumber);
		}
		else
		{
			var_d26305ae function_176e302e(localclientnumber);
		}
	}
}

/*
	Name: function_23d70c75
	Namespace: zm_tomb_capture_zones
	Checksum: 0xF6A439C7
	Offset: 0x4FF8
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function function_23d70c75(str_field_name)
{
	s_fx = undefined;
	if(isdefined(level.var_2707a8c[str_field_name]))
	{
		if(!isdefined(level.var_d5b89792))
		{
			level.var_d5b89792 = [];
		}
		if(!isdefined(level.var_d5b89792[level.var_2707a8c[str_field_name]]))
		{
			level.var_d5b89792[level.var_2707a8c[str_field_name]] = struct::get(level.var_2707a8c[str_field_name], "targetname");
		}
		s_fx = level.var_d5b89792[level.var_2707a8c[str_field_name]];
	}
	return s_fx;
}

/*
	Name: function_176e302e
	Namespace: zm_tomb_capture_zones
	Checksum: 0x8EF1C42E
	Offset: 0x50C8
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_176e302e(localclientnumber)
{
	if(!isdefined(self.a_fx))
	{
		self.a_fx = [];
	}
	if(isdefined(self.a_fx[localclientnumber]))
	{
		deletefx(localclientnumber, self.a_fx[localclientnumber], 0);
	}
}

/*
	Name: function_b64620a3
	Namespace: zm_tomb_capture_zones
	Checksum: 0x628AA4F
	Offset: 0x5130
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function function_b64620a3(localclientnumber)
{
	self function_176e302e(localclientnumber);
	self.a_fx[localclientnumber] = playfx(localclientnumber, level._effect["perk_pipe_smoke"], self.origin, anglestoforward(self.angles));
}

