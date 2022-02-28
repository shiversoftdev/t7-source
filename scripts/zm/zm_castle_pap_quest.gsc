// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\zm_castle_flingers;
#using scripts\zm\zm_castle_vo;

#namespace zm_castle_pap_quest;

/*
	Name: __init__sytem__
	Namespace: zm_castle_pap_quest
	Checksum: 0x663618B
	Offset: 0x540
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_pap_quest", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_castle_pap_quest
	Checksum: 0x5C1626B3
	Offset: 0x588
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "pap_tp_fx", 5000, 1, "counter");
	level.var_e1ee8457 = 0;
	level flag::init("pap_reform_available");
	level flag::init("pap_reformed");
	level.pack_a_punch.custom_power_think = &function_c4641d12;
	level.zombiemode_reusing_pack_a_punch = 1;
	zm_pap_util::set_interaction_trigger_radius(128);
}

/*
	Name: __main__
	Namespace: zm_castle_pap_quest
	Checksum: 0x1AB23914
	Offset: 0x650
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	/#
		level thread function_42a3de0d();
	#/
}

/*
	Name: function_c4641d12
	Namespace: zm_castle_pap_quest
	Checksum: 0xED75B347
	Offset: 0x678
	Size: 0x8E0
	Parameters: 1
	Flags: Linked
*/
function function_c4641d12(is_powered)
{
	level.var_1c602ba8 = struct::get_array("s_pap_tp");
	level.pap_machine = self;
	self.zbarrier _zm_pack_a_punch::set_state_hidden();
	array::thread_all(level.var_1c602ba8, &function_53bc4f86, self);
	level.var_164e92cf = 2;
	level.var_1e4d46e3 = 0;
	level.var_22ce1993 = [];
	level.var_22ce1993[0] = "fxexp_804";
	level.var_22ce1993[1] = "fxexp_805";
	level.var_22ce1993[2] = "fxexp_803";
	var_6eb9e3e5 = [];
	var_6eb9e3e5[0] = "lgt_undercroft_exp";
	var_6eb9e3e5[1] = "lgt_rocketpad_exp";
	var_6eb9e3e5[2] = "lgt_bastion_exp";
	var_e98af28a = [];
	var_e98af28a[0] = "fxexp_801";
	var_e98af28a[1] = "fxexp_802";
	var_e98af28a[2] = "fxexp_800";
	while(level.var_1e4d46e3 < level.var_164e92cf)
	{
		wait(0.05);
	}
	self.zbarrier show();
	pap_machine = getent("pap_prefab", "prefabname");
	self.zbarrier _zm_pack_a_punch::set_state_initial();
	self.zbarrier _zm_pack_a_punch::set_state_power_on();
	level waittill(#"pack_machine_in_use");
	level.var_9b1767c1 = level.round_number + randomintrange(2, 4);
	var_94e7d6ca = undefined;
	var_3c7c9ebd = undefined;
	while(true)
	{
		level waittill(#"end_of_round");
		if(isdefined(var_94e7d6ca))
		{
			var_94e7d6ca delete();
		}
		if(isdefined(var_3c7c9ebd))
		{
			var_3c7c9ebd delete();
		}
		if(level.round_number >= level.var_9b1767c1)
		{
			while(self.zbarrier.state == "eject_gun" || self.zbarrier.state == "take_gun")
			{
				wait(0.05);
			}
			e_clip = getent(("pap_" + level.var_94c82bf8[level.var_2eccab0d].script_noteworthy) + "_clip", "targetname");
			e_clip function_2209afdf();
			e_clip solid();
			var_4a6273cc = getent("pap_debris_" + level.var_94c82bf8[level.var_2eccab0d].script_noteworthy, "targetname");
			var_4a6273cc show();
			var_92f094dc = var_6eb9e3e5[level.var_2eccab0d];
			var_b57a445e = level.var_22ce1993[level.var_2eccab0d];
			playrumbleonposition("zm_castle_pap_tp", self.origin);
			level.var_2eccab0d++;
			if(level.var_2eccab0d >= level.var_94c82bf8.size)
			{
				level.var_2eccab0d = 0;
			}
			var_528227ee = level.var_94c82bf8[level.var_2eccab0d].origin;
			var_39796348 = level.var_94c82bf8[level.var_2eccab0d].angles;
			self.zbarrier _zm_pack_a_punch::set_state_leaving();
			var_3c7c9ebd = spawn("script_model", self.origin + vectorscale((0, 0, 1), 72));
			var_3c7c9ebd setmodel("tag_origin");
			var_3c7c9ebd.angles = self.angles;
			var_94e7d6ca = spawn("script_model", var_528227ee);
			var_94e7d6ca setmodel("tag_origin");
			var_94e7d6ca.angles = var_39796348;
			self.zbarrier waittill(#"leave_anim_done");
			var_4a6273cc = getent("pap_debris_" + level.var_94c82bf8[level.var_2eccab0d].script_noteworthy, "targetname");
			var_4a6273cc hide();
			e_clip = getent(("pap_" + level.var_94c82bf8[level.var_2eccab0d].script_noteworthy) + "_clip", "targetname");
			e_clip notsolid();
			var_3c7c9ebd clientfield::increment("pap_tp_fx");
			var_94e7d6ca clientfield::increment("pap_tp_fx");
			var_56f90684 = var_6eb9e3e5[level.var_2eccab0d];
			var_592384e6 = level.var_22ce1993[level.var_2eccab0d];
			exploder::exploder_stop(var_b57a445e);
			exploder::exploder_stop(var_92f094dc);
			exploder::exploder(var_592384e6);
			exploder::exploder(var_56f90684);
			self.origin = var_528227ee + vectorscale((0, 0, 1), 32);
			self.angles = var_39796348;
			self.zbarrier.origin = var_528227ee + (vectorscale((0, 0, -1), 16));
			self.zbarrier.angles = var_39796348;
			self thread function_5f17a55c();
			wait(0.05);
			e_brush = getent("pap_clip", "targetname");
			var_f72d376e = (vectornormalize(anglestoforward(level.var_94c82bf8[level.var_2eccab0d].angles + (vectorscale((0, -1, 0), 90))))) * 16;
			e_brush.origin = (var_528227ee + var_f72d376e) + vectorscale((0, 0, 1), 64);
			e_brush.angles = var_39796348 + vectorscale((0, 1, 0), 90);
			e_brush function_88c193db();
			self.zbarrier _zm_pack_a_punch::set_state_arriving();
			level.var_9b1767c1 = level.round_number + randomintrange(2, 4);
		}
	}
}

/*
	Name: function_88c193db
	Namespace: zm_castle_pap_quest
	Checksum: 0x8001BCB9
	Offset: 0xF60
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_88c193db()
{
	if(level.var_94c82bf8[level.var_2eccab0d].script_noteworthy === "under")
	{
		self.origin = (-256, 2500, 310);
	}
}

/*
	Name: function_2209afdf
	Namespace: zm_castle_pap_quest
	Checksum: 0xC540C5CA
	Offset: 0xFB0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_2209afdf()
{
	b_touching = util::any_player_is_touching(self, "allies");
	while(b_touching)
	{
		wait(0.05);
		b_touching = util::any_player_is_touching(self, "allies");
	}
}

/*
	Name: function_5f17a55c
	Namespace: zm_castle_pap_quest
	Checksum: 0x328E18C0
	Offset: 0x1020
	Size: 0x22A
	Parameters: 0
	Flags: Linked
*/
function function_5f17a55c()
{
	a_players = array::get_all_closest(self.origin, level.players, undefined, 4, 95);
	foreach(e_player in a_players)
	{
		e_player dodamage(e_player.health + 100, e_player.origin + vectorscale((0, 1, 0), 100));
		if(self laststand::player_is_in_laststand())
		{
			if(self.bleedout_time > 0)
			{
				self.bleedout_time = 0;
			}
			continue;
		}
		self.bleedout_time = 0.5;
	}
	a_ai_enemies = array::get_all_closest(self.origin, getaiteamarray(level.zombie_team), undefined, 40, 100);
	foreach(ai_zombie in a_ai_enemies)
	{
		ai_zombie dodamage(ai_zombie.health + 100, ai_zombie.origin + vectorscale((0, 1, 0), 100));
	}
}

/*
	Name: function_53bc4f86
	Namespace: zm_castle_pap_quest
	Checksum: 0xE9B286BB
	Offset: 0x1258
	Size: 0x4BC
	Parameters: 1
	Flags: Linked
*/
function function_53bc4f86(pap_machine)
{
	e_clip = getent(self.script_string, "targetname");
	e_clip.targetname = ("pap_" + self.script_noteworthy) + "_clip";
	var_4a6273cc = function_23193d81(self.script_noteworthy);
	var_4a6273cc hide();
	s_unitrigger_stub = spawnstruct();
	s_unitrigger_stub.origin = self.origin + vectorscale((0, 0, 1), 30);
	s_unitrigger_stub.radius = 70;
	s_unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	s_unitrigger_stub.prompt_and_visibility_func = &function_99664e8;
	s_unitrigger_stub.parent_struct = self;
	s_unitrigger_stub.parent_struct.activated = 0;
	zm_unitrigger::register_static_unitrigger(s_unitrigger_stub, &zm_castle_flingers::function_4029cf56);
	s_unitrigger_stub waittill(#"trigger", e_who);
	while(level.var_e1ee8457 > 0)
	{
		wait(0.05);
	}
	if(level.var_1e4d46e3 >= level.var_164e92cf)
	{
		return;
	}
	var_40cae301 = [];
	var_40cae301["under"] = "fxexp_811";
	var_40cae301["rocket"] = "fxexp_812";
	var_40cae301["roof"] = "fxexp_810";
	exploder::exploder(var_40cae301[self.script_noteworthy]);
	var_22ce1993 = [];
	var_22ce1993["under"] = "fxexp_801";
	var_22ce1993["rocket"] = "fxexp_802";
	var_22ce1993["roof"] = "fxexp_800";
	exploder::exploder(var_22ce1993[self.script_noteworthy]);
	playrumbleonposition("zm_castle_pap_tp", self.origin);
	for(i = 0; i < level.var_1c602ba8.size; i++)
	{
		if(level.var_1c602ba8[i] == self)
		{
			level.var_1c602ba8 = array::remove_index(level.var_1c602ba8, i);
		}
	}
	if(level.var_1e4d46e3 < level.var_164e92cf)
	{
		e_who thread zm_castle_vo::function_ce6b93fc();
	}
	level.var_a8ca2bee = level.var_1c602ba8[0];
	level.var_1e4d46e3++;
	s_unitrigger_stub.parent_struct.activated = 1;
	self function_566e5eb4();
	if(level.var_1e4d46e3 >= level.var_164e92cf)
	{
		level.var_1c602ba8[0].activated = 1;
		level.var_54cd8d06 = level.var_1c602ba8[0];
		while(level.var_e1ee8457)
		{
			wait(0.05);
		}
		level flag::set("pap_reform_available");
	}
	var_4a6273cc = getent("pap_debris_" + self.script_noteworthy, "targetname");
	var_4a6273cc show();
	while(level.var_e1ee8457)
	{
		wait(0.05);
	}
	exploder::exploder_stop(var_22ce1993[self.script_noteworthy]);
}

/*
	Name: function_23193d81
	Namespace: zm_castle_pap_quest
	Checksum: 0x94D69835
	Offset: 0x1720
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function function_23193d81(str_location)
{
	v_origin = undefined;
	v_angles = undefined;
	switch(str_location)
	{
		case "rocket":
		{
			v_origin = (3890, -2587.36, -2155.74);
			v_angles = (359.934, 168.599, 0.997782);
			break;
		}
		case "roof":
		{
			v_origin = (150, 2446.97, 927.25);
			v_angles = (0, 0, 0);
			break;
		}
		case "under":
		{
			v_origin = (-256, 2485.48, 207.974);
			v_angles = (359.785, 136.597, 0.976539);
			break;
		}
		default:
		{
			break;
		}
	}
	var_4a6273cc = util::spawn_model("p7_debris_metal_twisted_a_lrg", v_origin, v_angles);
	var_4a6273cc setscale(0.85);
	var_4a6273cc.targetname = "pap_debris_" + str_location;
	return var_4a6273cc;
}

/*
	Name: function_b9cca08f
	Namespace: zm_castle_pap_quest
	Checksum: 0xD9CA6569
	Offset: 0x18A0
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function function_b9cca08f()
{
	level endon(#"pap_reformed");
	self endon(#"death");
	self endon(#"disconnect");
	level flag::wait_till("pap_reform_available");
	s_pap_location = level.var_54cd8d06;
	while(true)
	{
		self util::waittill_player_looking_at(s_pap_location.origin + vectorscale((0, 0, 1), 50), 90);
		if(distance(self.origin, s_pap_location.origin) < 400)
		{
			level thread function_eb56512();
			level flag::set("pap_reformed");
		}
		wait(0.05);
	}
}

/*
	Name: function_eb56512
	Namespace: zm_castle_pap_quest
	Checksum: 0xCE6CDD43
	Offset: 0x19B0
	Size: 0x5D4
	Parameters: 0
	Flags: Linked
*/
function function_eb56512()
{
	s_pap_location = level.var_54cd8d06;
	var_22ce1993 = [];
	var_22ce1993["under"] = "fxexp_801";
	var_22ce1993["rocket"] = "fxexp_802";
	var_22ce1993["roof"] = "fxexp_800";
	var_6eb9e3e5 = [];
	var_6eb9e3e5["under"] = "lgt_undercroft_exp";
	var_6eb9e3e5["rocket"] = "lgt_rocketpad_exp";
	var_6eb9e3e5["roof"] = "lgt_bastion_exp";
	var_9e129aa9 = var_22ce1993[s_pap_location.script_noteworthy];
	exploder::exploder(var_9e129aa9);
	playrumbleonposition("zm_castle_pap_tp", s_pap_location.origin);
	zm_pap_util::set_interaction_height(256);
	level.var_94c82bf8 = [];
	var_aa03df75 = struct::get_array("s_pap_location", "targetname");
	foreach(var_309749f1 in var_aa03df75)
	{
		level.var_94c82bf8[var_309749f1.script_int] = var_309749f1;
	}
	var_fc5d165 = arraygetclosest(s_pap_location.origin, level.var_94c82bf8);
	level.var_c9f5f61 = getentarray(s_pap_location.target, "targetname");
	scene::add_scene_func("p7_fxanim_zm_castle_pap_complete_reform_bundle", &function_335f66d5, "play");
	var_fc5d165.origin = var_fc5d165.origin + (vectorscale((0, 0, -1), 16));
	var_fc5d165 scene::play("p7_fxanim_zm_castle_pap_complete_reform_bundle");
	var_fc5d165.origin = var_fc5d165.origin + vectorscale((0, 0, 1), 16);
	level.var_2eccab0d = var_fc5d165.script_int;
	var_528227ee = level.var_94c82bf8[level.var_2eccab0d].origin;
	var_39796348 = level.var_94c82bf8[level.var_2eccab0d].angles;
	level.pap_machine.origin = var_528227ee + vectorscale((0, 0, 1), 32);
	level.pap_machine.angles = var_39796348;
	level.pap_machine.zbarrier.origin = var_528227ee + (vectorscale((0, 0, -1), 16));
	level.pap_machine.zbarrier.angles = var_39796348;
	e_brush = getent("pap_clip", "targetname");
	var_f72d376e = (vectornormalize(anglestoforward(var_fc5d165.angles + (vectorscale((0, -1, 0), 90))))) * 16;
	e_brush.origin = (var_528227ee + var_f72d376e) + vectorscale((0, 0, 1), 64);
	e_brush.angles = var_39796348 + vectorscale((0, 1, 0), 90);
	e_brush function_88c193db();
	exploder::exploder(level.var_22ce1993[level.var_2eccab0d]);
	exploder::exploder_stop(var_9e129aa9);
	level.pap_machine.zbarrier thread function_a8c41b9();
	level.pap_machine.zbarrier _zm_pack_a_punch::set_state_power_on();
	e_clip = getent(("pap_" + s_pap_location.script_noteworthy) + "_clip", "targetname");
	e_clip notsolid();
	exploder::exploder(var_6eb9e3e5[s_pap_location.script_noteworthy]);
}

/*
	Name: function_566e5eb4
	Namespace: zm_castle_pap_quest
	Checksum: 0x8FB752EA
	Offset: 0x1F90
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function function_566e5eb4()
{
	var_cd9abb80 = getentarray(self.target, "targetname");
	n_loc_index = 0;
	foreach(var_c790d258 in var_cd9abb80)
	{
		var_b9d22a4b = level.var_1c602ba8[n_loc_index];
		n_loc_index++;
		if(n_loc_index >= level.var_1c602ba8.size)
		{
			n_loc_index = 0;
		}
		var_c790d258 thread function_6591f9c7(var_b9d22a4b);
	}
}

/*
	Name: function_335f66d5
	Namespace: zm_castle_pap_quest
	Checksum: 0xE982F39B
	Offset: 0x20A0
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_335f66d5()
{
	wait(0.25);
	foreach(var_c790d258 in level.var_c9f5f61)
	{
		var_c790d258 delete();
	}
}

/*
	Name: function_6591f9c7
	Namespace: zm_castle_pap_quest
	Checksum: 0xE1245B86
	Offset: 0x2140
	Size: 0x1BC
	Parameters: 1
	Flags: Linked
*/
function function_6591f9c7(var_b9d22a4b)
{
	level.var_e1ee8457++;
	str_scenedef = ("p7_fxanim_zm_castle_pap_part" + self.script_int) + "_depart_bundle";
	scene::play(str_scenedef, self);
	var_f7c4d7b5 = ("s_pap_chunk_" + var_b9d22a4b.script_noteworthy) + self.script_int;
	var_5e73f984 = struct::get(var_f7c4d7b5, "targetname");
	self.origin = var_5e73f984.origin;
	self.angles = var_5e73f984.angles;
	str_scenedef = ("p7_fxanim_zm_castle_pap_part" + self.script_int) + "_arrive_bundle";
	scene::play(str_scenedef, self);
	foreach(s_pap_location in level.var_1c602ba8)
	{
		if(s_pap_location.script_noteworthy == var_b9d22a4b.script_noteworthy)
		{
			self.targetname = s_pap_location.target;
		}
	}
	level.var_e1ee8457--;
}

/*
	Name: function_a8c41b9
	Namespace: zm_castle_pap_quest
	Checksum: 0xADD30E0E
	Offset: 0x2308
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function function_a8c41b9()
{
	var_40cae301 = [];
	var_40cae301[0] = "fxexp_801";
	var_40cae301[1] = "fxexp_802";
	var_40cae301[2] = "fxexp_800";
	while(true)
	{
		while(self.state != "take_gun" && self.state != "eject_gun")
		{
			wait(0.05);
		}
		exploder::exploder(var_40cae301[level.var_2eccab0d]);
		while(self.state == "take_gun" || self.state == "eject_gun")
		{
			wait(0.05);
		}
		exploder::exploder_stop(var_40cae301[level.var_2eccab0d]);
	}
}

/*
	Name: function_99664e8
	Namespace: zm_castle_pap_quest
	Checksum: 0xE508B05D
	Offset: 0x2418
	Size: 0x190
	Parameters: 0
	Flags: Linked
*/
function function_99664e8()
{
	str_msg = &"";
	str_msg = self.stub.hint_string;
	if(level.var_e1ee8457 > 0)
	{
		self sethintstring(&"ZM_CASTLE_PAP_TP_UNAVAILABLE");
		return false;
	}
	if(self.stub.parent_struct.activated === 1)
	{
		var_32a8ab39 = [];
		var_32a8ab39[0] = "under";
		var_32a8ab39[1] = "rocket";
		var_32a8ab39[2] = "roof";
		if(isdefined(level.var_2eccab0d) && self.stub.parent_struct.script_noteworthy == var_32a8ab39[level.var_2eccab0d])
		{
			self sethintstring("");
		}
		else
		{
			if(!isdefined(level.var_2eccab0d))
			{
				self sethintstring("");
			}
			else
			{
				self sethintstring(&"ZM_CASTLE_PAP_TP_AWAY");
			}
		}
		return false;
	}
	self sethintstring(&"ZM_CASTLE_PAP_TP_ACTIVATE");
	return true;
}

/*
	Name: detect_reentry
	Namespace: zm_castle_pap_quest
	Checksum: 0x9FF21716
	Offset: 0x25B8
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function detect_reentry()
{
	/#
		if(isdefined(self.var_8665ab89))
		{
			if(self.var_8665ab89 == gettime())
			{
				return true;
			}
		}
		self.var_8665ab89 = gettime();
		return false;
	#/
}

/*
	Name: function_42a3de0d
	Namespace: zm_castle_pap_quest
	Checksum: 0xBEF82CE1
	Offset: 0x25F8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_42a3de0d()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_f04119b5);
		adddebugcommand("");
	#/
}

/*
	Name: function_f04119b5
	Namespace: zm_castle_pap_quest
	Checksum: 0x239F4B1C
	Offset: 0x2668
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_f04119b5(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				if(level detect_reentry())
				{
					return true;
				}
				level.var_1e4d46e3 = 10;
				wait(1);
				pap_machine = getent("", "");
				level.var_54cd8d06 = level.var_1c602ba8[0];
				array::thread_all(level.players, &function_b9cca08f, pap_machine);
				return true;
			}
		}
		return false;
	#/
}

