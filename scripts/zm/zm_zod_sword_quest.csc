// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#using_animtree("generic");

#namespace zm_zod_sword;

/*
	Name: __init__sytem__
	Namespace: zm_zod_sword
	Checksum: 0x73194443
	Offset: 0x890
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_sword", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_sword
	Checksum: 0x2AC8D5EE
	Offset: 0x8D0
	Size: 0x662
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["egg_glow"] = "zombie/fx_egg_ready_zod_zmb";
	level._effect["blood_soul"] = "zombie/fx_trail_blood_soul_zmb";
	level._effect["sword_quest_ground_glow_white"] = "zombie/fx_sword_quest_egg_ground_whitepedestal_zod_zmb";
	level._effect["sword_quest_ground_fire_white"] = "zombie/fx_sword_quest_egg_ground_whitefire_zod_zmb";
	level._effect["sword_quest_sword_glow"] = "zombie/fx_sword_quest_glow_zod_zmb";
	clientfield::register("scriptmover", "zod_egg_glow", 1, 1, "int", &sword_egg_glow, 0, 0);
	clientfield::register("scriptmover", "zod_egg_soul", 1, 1, "int", &blood_soul_fx, 0, 0);
	clientfield::register("scriptmover", "sword_statue_glow", 1, 1, "int", &sword_statue_glow, 0, 0);
	n_bits = getminbitcountfornum(5);
	clientfield::register("toplayer", "magic_circle_state_0", 1, n_bits, "int", &function_528aad40, 0, 1);
	clientfield::register("toplayer", "magic_circle_state_1", 1, n_bits, "int", &function_1d308217, 0, 1);
	clientfield::register("toplayer", "magic_circle_state_2", 1, n_bits, "int", &function_b17464d4, 0, 1);
	clientfield::register("toplayer", "magic_circle_state_3", 1, n_bits, "int", &function_b6499939, 0, 1);
	n_bits = getminbitcountfornum(9);
	clientfield::register("world", "keeper_quest_state_0", 1, n_bits, "int", &function_9ba2b995, 0, 1);
	clientfield::register("world", "keeper_quest_state_1", 1, n_bits, "int", &function_fd8ec03a, 0, 1);
	clientfield::register("world", "keeper_quest_state_2", 1, n_bits, "int", &function_32002235, 0, 1);
	clientfield::register("world", "keeper_quest_state_3", 1, n_bits, "int", &function_4fd5e276, 0, 1);
	n_bits = getminbitcountfornum(4);
	clientfield::register("world", "keeper_egg_location_0", 1, n_bits, "int", undefined, 0, 1);
	clientfield::register("world", "keeper_egg_location_1", 1, n_bits, "int", undefined, 0, 1);
	clientfield::register("world", "keeper_egg_location_2", 1, n_bits, "int", undefined, 0, 1);
	clientfield::register("world", "keeper_egg_location_3", 1, n_bits, "int", undefined, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL1_SWORD_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL1_EGG_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL2_SWORD_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL2_EGG_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	level.var_e91b9e85 = [];
	level.var_e91b9e85[0] = "wpn_t7_zmb_zod_sword2_box_world";
	level.var_e91b9e85[1] = "wpn_t7_zmb_zod_sword2_det_world";
	level.var_e91b9e85[2] = "wpn_t7_zmb_zod_sword2_fem_world";
	level.var_e91b9e85[3] = "wpn_t7_zmb_zod_sword2_mag_world";
}

/*
	Name: magic_circle_state_internal
	Namespace: zm_zod_sword
	Checksum: 0x80E9111F
	Offset: 0xF40
	Size: 0x3F6
	Parameters: 3
	Flags: Linked
*/
function magic_circle_state_internal(localclientnum, newval, n_current_ritual)
{
	self notify("magic_circle_state_internal" + localclientnum);
	self endon("magic_circle_state_internal" + localclientnum);
	var_4126c532 = function_5dab7fb(localclientnum, n_current_ritual);
	var_768e52e3 = undefined;
	var_5306b772 = struct::get_array("sword_quest_magic_circle_place", "targetname");
	foreach(var_87367d4f in var_5306b772)
	{
		if(var_87367d4f.script_int === n_current_ritual)
		{
			var_768e52e3 = var_87367d4f;
		}
	}
	if(!isdefined(var_4126c532.var_e2a5419e))
	{
		var_4126c532.var_e2a5419e = [];
	}
	if(!isdefined(var_4126c532.var_bbf9b058))
	{
		var_4126c532.var_bbf9b058 = [];
	}
	if(isdefined(var_4126c532.var_e2a5419e[localclientnum]))
	{
		stopfx(localclientnum, var_4126c532.var_e2a5419e[localclientnum]);
		var_4126c532.var_e2a5419e[localclientnum] = undefined;
	}
	if(isdefined(var_4126c532.var_bbf9b058[localclientnum]))
	{
		stopfx(localclientnum, var_4126c532.var_bbf9b058[localclientnum]);
		var_4126c532.var_bbf9b058[localclientnum] = undefined;
	}
	switch(newval)
	{
		case 0:
		{
			function_cf043736(var_4126c532, 0);
			break;
		}
		case 1:
		{
			var_4126c532.var_e2a5419e[localclientnum] = playfx(localclientnum, level._effect["sword_quest_ground_tell"], var_768e52e3.origin);
			function_cf043736(var_4126c532, 0);
			break;
		}
		case 2:
		{
			var_4126c532.var_e2a5419e[localclientnum] = playfx(localclientnum, level._effect["sword_quest_ground_glow"], var_768e52e3.origin);
			function_cf043736(var_4126c532, 1);
			break;
		}
		case 3:
		{
			var_4126c532.var_e2a5419e[localclientnum] = playfx(localclientnum, level._effect["sword_quest_ground_glow_white"], var_768e52e3.origin);
			var_4126c532.var_bbf9b058[localclientnum] = playfx(localclientnum, level._effect["sword_quest_ground_fire_white"], var_768e52e3.origin);
			function_cf043736(var_4126c532, 1);
			break;
		}
	}
}

/*
	Name: function_cf043736
	Namespace: zm_zod_sword
	Checksum: 0x79CDDDDE
	Offset: 0x1340
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function function_cf043736(var_4126c532, var_cbdba0c5)
{
	if(var_cbdba0c5)
	{
		var_4126c532.var_55e0bdcf show();
		var_4126c532.var_6a0d8b03 hide();
	}
	else
	{
		var_4126c532.var_55e0bdcf hide();
		var_4126c532.var_6a0d8b03 show();
	}
}

/*
	Name: function_4d020922
	Namespace: zm_zod_sword
	Checksum: 0x9B3A461F
	Offset: 0x13E8
	Size: 0xEAA
	Parameters: 3
	Flags: Linked
*/
function function_4d020922(localclientnum, newval, n_character_index)
{
	level notify(#"hash_4d020922");
	level endon(#"hash_4d020922");
	var_4126c532 = function_6890ca81(localclientnum, n_character_index);
	var_4126c532.var_d88e6f5f util::waittill_dobj(localclientnum);
	if(!var_4126c532.var_d88e6f5f hasanimtree())
	{
		var_4126c532.var_d88e6f5f useanimtree($generic);
	}
	var_4126c532.var_d88e6f5f duplicate_render::set_dr_flag("zod_ghost", 1);
	var_4126c532.var_d88e6f5f duplicate_render::update_dr_filters(localclientnum);
	if(!var_4126c532.e_egg hasanimtree())
	{
		var_4126c532.e_egg useanimtree($generic);
	}
	switch(newval)
	{
		case 0:
		{
			var_4126c532.var_d88e6f5f hide();
			var_4126c532.e_sword hide();
			var_4126c532.e_egg hide();
			if(isdefined(var_4126c532.var_d88e6f5f.sndloop))
			{
				var_4126c532.var_d88e6f5f stoploopsound(var_4126c532.var_d88e6f5f.sndloop, 1);
			}
			break;
		}
		case 1:
		{
			v_origin = var_4126c532.var_d88e6f5f gettagorigin("tag_weapon_right");
			v_angles = var_4126c532.var_d88e6f5f gettagangles("tag_weapon_right");
			var_4126c532.e_egg unlink();
			var_4126c532.e_egg.origin = v_origin;
			var_4126c532.e_egg.angles = v_angles;
			var_4126c532.e_egg linkto(var_4126c532.var_d88e6f5f, "tag_weapon_right");
			var_4126c532.var_d88e6f5f show();
			var_4126c532.e_sword hide();
			var_4126c532.e_egg show();
			level thread function_bd205438(localclientnum, var_4126c532);
			var_4126c532.var_d88e6f5f playsound(0, "zmb_ee_keeper_ghost_appear");
			if(!isdefined(var_4126c532.var_d88e6f5f.sndloop))
			{
				var_4126c532.var_d88e6f5f.sndloop = var_4126c532.var_d88e6f5f playloopsound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			var_4126c532.var_d88e6f5f animation::play("ai_zombie_zod_keeper_give_egg_intro", undefined, undefined, 1);
			var_4126c532.var_d88e6f5f thread function_274ba0e6("ai_zombie_zod_keeper_give_egg_loop");
			var_4126c532.e_egg thread play_fx(localclientnum, "egg_glow");
			break;
		}
		case 2:
		{
			var_4126c532.var_d88e6f5f show();
			var_4126c532.e_sword hide();
			var_4126c532.e_egg hide();
			if(!isdefined(var_4126c532.var_d88e6f5f.sndloop))
			{
				var_4126c532.var_d88e6f5f.sndloop = var_4126c532.var_d88e6f5f playloopsound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			var_4126c532.var_d88e6f5f notify(#"hash_274ba0e6");
			var_4126c532.var_d88e6f5f clearanim("ai_zombie_zod_keeper_give_egg_intro", 0);
			var_4126c532.var_d88e6f5f clearanim("ai_zombie_zod_keeper_give_egg_loop", 0);
			var_4126c532.var_d88e6f5f animation::play("ai_zombie_zod_keeper_give_egg_outro", undefined, undefined, 1);
			var_4126c532.e_egg notify("remove_" + "egg_glow");
			break;
		}
		case 3:
		{
			var_4126c532.var_d88e6f5f hide();
			var_4126c532.e_sword hide();
			var_4126c532.e_egg hide();
			var_4126c532.e_egg notify("remove_" + "egg_glow");
			if(isdefined(var_4126c532.var_d88e6f5f.sndloop))
			{
				var_4126c532.var_d88e6f5f stoploopsound(var_4126c532.var_d88e6f5f.sndloop, 1);
			}
			break;
		}
		case 4:
		{
			var_4d1c542 = level clientfield::get("keeper_egg_location_" + n_character_index);
			v_origin = function_85b951d8(var_4d1c542);
			var_4126c532.e_egg unlink();
			var_4126c532.e_egg.origin = v_origin;
			var_4126c532.var_d88e6f5f hide();
			var_4126c532.e_sword hide();
			var_4126c532.e_egg show();
			if(isdefined(var_4126c532.var_d88e6f5f.sndloop))
			{
				var_4126c532.var_d88e6f5f stoploopsound(var_4126c532.var_d88e6f5f.sndloop, 1);
			}
			var_4126c532.e_egg thread play_fx(localclientnum, "egg_glow", "egg_keeper_jnt");
			var_4126c532.e_egg thread function_5b78bb9e(v_origin);
			break;
		}
		case 5:
		{
			var_4126c532.var_d88e6f5f show();
			var_4126c532.e_sword hide();
			var_4126c532.e_egg hide();
			if(!isdefined(var_4126c532.var_d88e6f5f.sndloop))
			{
				var_4126c532.var_d88e6f5f.sndloop = var_4126c532.var_d88e6f5f playloopsound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			var_4126c532.e_egg notify("remove_" + "egg_glow");
			break;
		}
		case 6:
		{
			var_4126c532.var_d88e6f5f show();
			var_4126c532.e_sword hide();
			var_4126c532.e_egg hide();
			if(!isdefined(var_4126c532.var_d88e6f5f.sndloop))
			{
				var_4126c532.var_d88e6f5f.sndloop = var_4126c532.var_d88e6f5f playloopsound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			var_4126c532.var_d88e6f5f animation::play("ai_zombie_zod_keeper_give_me_sword_intro", undefined, undefined, 1);
			var_4126c532.var_d88e6f5f thread function_274ba0e6("ai_zombie_zod_keeper_give_me_sword_loop");
			break;
		}
		case 7:
		{
			v_origin = var_4126c532.var_d88e6f5f gettagorigin("tag_weapon_right");
			v_angles = var_4126c532.var_d88e6f5f gettagangles("tag_weapon_right");
			var_4126c532.e_sword unlink();
			var_4126c532.e_sword.origin = v_origin;
			var_4126c532.e_sword.angles = v_angles;
			var_4126c532.e_sword linkto(var_4126c532.var_d88e6f5f, "tag_weapon_right");
			var_4126c532.var_d88e6f5f show();
			var_4126c532.e_sword show();
			var_4126c532.e_egg hide();
			if(!isdefined(var_4126c532.var_d88e6f5f.sndloop))
			{
				var_4126c532.var_d88e6f5f.sndloop = var_4126c532.var_d88e6f5f playloopsound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			var_4126c532.var_d88e6f5f notify(#"hash_274ba0e6");
			var_4126c532.e_sword play_fx(localclientnum, "sword_quest_sword_glow", "tag_knife_fx");
			var_4126c532.var_d88e6f5f animation::play("ai_zombie_zod_keeper_upgrade_sword", undefined, undefined, 1);
			var_4126c532.var_d88e6f5f thread function_274ba0e6("ai_zombie_zod_keeper_give_me_sword_loop");
			break;
		}
		case 8:
		{
			var_4126c532.e_sword notify("remove_" + "sword_quest_sword_glow");
			wait(0.016);
			var_4126c532.var_d88e6f5f show();
			var_4126c532.e_sword hide();
			var_4126c532.e_egg hide();
			if(!isdefined(var_4126c532.var_d88e6f5f.sndloop))
			{
				var_4126c532.var_d88e6f5f.sndloop = var_4126c532.var_d88e6f5f playloopsound("zmb_ee_keeper_ghost_appear_lp", 2);
			}
			var_4126c532.var_d88e6f5f notify(#"hash_274ba0e6");
			var_4126c532.var_d88e6f5f animation::play("ai_zombie_zod_keeper_give_me_sword_outro", undefined, undefined, 1);
			var_4126c532.var_d88e6f5f thread function_274ba0e6("ai_zombie_zod_keeper_idle");
			wait(2);
			var_4126c532.var_5ab40ec3 = playfxontag(localclientnum, level._effect["keeper_spawn"], var_4126c532.var_d88e6f5f, "tag_origin");
			wait(0.5);
			var_4126c532.var_d88e6f5f hide();
		}
	}
}

/*
	Name: function_bd205438
	Namespace: zm_zod_sword
	Checksum: 0xBB9F12C0
	Offset: 0x22A0
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function function_bd205438(localclientnum, var_4126c532)
{
	var_4126c532.var_5ab40ec3 = playfxontag(localclientnum, level._effect["keeper_spawn"], var_4126c532.var_d88e6f5f, "tag_origin");
	wait(1);
	stopfx(localclientnum, var_4126c532.var_5ab40ec3);
}

/*
	Name: function_5b78bb9e
	Namespace: zm_zod_sword
	Checksum: 0xD956A7EE
	Offset: 0x2338
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_5b78bb9e(v_origin)
{
	self clearanim("p7_fxanim_zm_zod_egg_keeper_rise_anim", 0);
	self clearanim("p7_fxanim_zm_zod_egg_keeper_idle_anim", 0);
	self animation::play("p7_fxanim_zm_zod_egg_keeper_rise_anim", v_origin, (0, 0, 1), 1);
	self animation::play("p7_fxanim_zm_zod_egg_keeper_idle_anim", v_origin, (0, 0, 1), 1);
}

/*
	Name: function_274ba0e6
	Namespace: zm_zod_sword
	Checksum: 0xE4DA7DD0
	Offset: 0x23F0
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function function_274ba0e6(str_animname)
{
	self notify(#"hash_274ba0e6");
	self endon(#"hash_274ba0e6");
	while(true)
	{
		self animation::play(str_animname, undefined, undefined, 1);
	}
}

/*
	Name: function_528aad40
	Namespace: zm_zod_sword
	Checksum: 0x5E7EAB09
	Offset: 0x2450
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_528aad40(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	magic_circle_state_internal(localclientnum, newval, 0);
}

/*
	Name: function_1d308217
	Namespace: zm_zod_sword
	Checksum: 0x1C42A4F5
	Offset: 0x24B8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_1d308217(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	magic_circle_state_internal(localclientnum, newval, 1);
}

/*
	Name: function_b17464d4
	Namespace: zm_zod_sword
	Checksum: 0xB9894BD8
	Offset: 0x2520
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_b17464d4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	magic_circle_state_internal(localclientnum, newval, 2);
}

/*
	Name: function_b6499939
	Namespace: zm_zod_sword
	Checksum: 0x7B63602E
	Offset: 0x2588
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_b6499939(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	magic_circle_state_internal(localclientnum, newval, 3);
}

/*
	Name: function_9ba2b995
	Namespace: zm_zod_sword
	Checksum: 0xAEA98577
	Offset: 0x25F0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_9ba2b995(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_4d020922(localclientnum, newval, 0);
}

/*
	Name: function_fd8ec03a
	Namespace: zm_zod_sword
	Checksum: 0x6A865EE6
	Offset: 0x2658
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_fd8ec03a(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_4d020922(localclientnum, newval, 1);
}

/*
	Name: function_32002235
	Namespace: zm_zod_sword
	Checksum: 0x9BCBC289
	Offset: 0x26C0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_32002235(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_4d020922(localclientnum, newval, 2);
}

/*
	Name: function_4fd5e276
	Namespace: zm_zod_sword
	Checksum: 0x98C846A0
	Offset: 0x2728
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_4fd5e276(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_4d020922(localclientnum, newval, 3);
}

/*
	Name: function_5dab7fb
	Namespace: zm_zod_sword
	Checksum: 0xD8C85672
	Offset: 0x2790
	Size: 0xB4
	Parameters: 2
	Flags: Linked
*/
function function_5dab7fb(localclientnum, n_current_ritual)
{
	if(!isdefined(level.sword_quest))
	{
		level.sword_quest = [];
	}
	if(!isdefined(level.sword_quest[localclientnum]))
	{
		level.sword_quest[localclientnum] = [];
	}
	if(!isdefined(level.sword_quest[localclientnum][n_current_ritual]))
	{
		level.sword_quest[localclientnum][n_current_ritual] = spawnstruct();
	}
	var_4126c532 = level.sword_quest[localclientnum][n_current_ritual];
	return var_4126c532;
}

/*
	Name: function_6890ca81
	Namespace: zm_zod_sword
	Checksum: 0x7380D20B
	Offset: 0x2850
	Size: 0x3D0
	Parameters: 2
	Flags: Linked
*/
function function_6890ca81(localclientnum, n_character_index)
{
	s_loc = struct::get("keeper_spirit_" + n_character_index, "targetname");
	var_4126c532 = function_5dab7fb(localclientnum, n_character_index);
	if(!isdefined(var_4126c532.var_d88e6f5f))
	{
		var_4126c532.var_d88e6f5f = spawn(localclientnum, s_loc.origin, "script_model");
		var_4126c532.var_d88e6f5f.angles = s_loc.angles;
		var_4126c532.var_d88e6f5f setmodel("c_zom_zod_keeper_fb");
	}
	if(!isdefined(var_4126c532.e_sword))
	{
		var_4126c532.e_sword = spawn(localclientnum, s_loc.origin, "script_model");
		var_4126c532.e_sword setmodel(level.var_e91b9e85[n_character_index]);
	}
	if(!isdefined(var_4126c532.e_egg))
	{
		var_4126c532.e_egg = spawn(localclientnum, s_loc.origin, "script_model");
		var_4126c532.e_egg setmodel("zm_zod_sword_egg_keeper_s1");
	}
	if(!isdefined(var_4126c532.var_55e0bdcf))
	{
		a_circles = getentarray(localclientnum, "sword_quest_magic_circle_on", "targetname");
		var_55e0bdcf = undefined;
		foreach(e_circle in a_circles)
		{
			if(e_circle.script_int === n_character_index)
			{
				var_55e0bdcf = e_circle;
			}
		}
		var_4126c532.var_55e0bdcf = var_55e0bdcf;
	}
	if(!isdefined(var_4126c532.var_6a0d8b03))
	{
		a_circles = getentarray(localclientnum, "sword_quest_magic_circle_off", "targetname");
		var_6a0d8b03 = undefined;
		foreach(e_circle in a_circles)
		{
			if(e_circle.script_int === n_character_index)
			{
				var_6a0d8b03 = e_circle;
			}
		}
		var_4126c532.var_6a0d8b03 = var_6a0d8b03;
	}
	return var_4126c532;
}

/*
	Name: get_name_from_ritual_clientfield_value
	Namespace: zm_zod_sword
	Checksum: 0x719A89EB
	Offset: 0x2C28
	Size: 0x5E
	Parameters: 1
	Flags: None
*/
function get_name_from_ritual_clientfield_value(n_current_ritual)
{
	switch(n_current_ritual)
	{
		case 1:
		{
			return "boxer";
		}
		case 2:
		{
			return "detective";
		}
		case 3:
		{
			return "femme";
		}
		case 4:
		{
			return "magician";
		}
	}
}

/*
	Name: function_85b951d8
	Namespace: zm_zod_sword
	Checksum: 0x43595057
	Offset: 0x2C90
	Size: 0xCE
	Parameters: 1
	Flags: Linked
*/
function function_85b951d8(var_181b74a5)
{
	var_79d1dcf6 = struct::get_array("sword_quest_magic_circle_place", "targetname");
	foreach(var_87367d4f in var_79d1dcf6)
	{
		if(var_87367d4f.script_int === var_181b74a5)
		{
			return var_87367d4f.origin;
		}
	}
}

/*
	Name: function_96ae1a10
	Namespace: zm_zod_sword
	Checksum: 0xF4556CB3
	Offset: 0x2D68
	Size: 0xD4
	Parameters: 2
	Flags: None
*/
function function_96ae1a10(var_181b74a5, n_character_index)
{
	var_79d1dcf6 = struct::get_array("sword_quest_magic_circle_player_" + n_character_index, "targetname");
	foreach(var_87367d4f in var_79d1dcf6)
	{
		if(var_87367d4f.script_int === var_181b74a5)
		{
			return var_87367d4f;
		}
	}
}

/*
	Name: play_fx
	Namespace: zm_zod_sword
	Checksum: 0xE937124
	Offset: 0x2E48
	Size: 0xCC
	Parameters: 3
	Flags: Linked
*/
function play_fx(localclientnum, str_fx, str_tag)
{
	fx = undefined;
	if(isdefined(str_tag))
	{
		fx = playfxontag(localclientnum, level._effect[str_fx], self, str_tag);
	}
	else
	{
		fx = playfx(localclientnum, level._effect[str_fx], self.origin);
	}
	self waittill("remove_" + str_fx);
	stopfx(localclientnum, fx);
}

/*
	Name: sword_statue_glow
	Namespace: zm_zod_sword
	Checksum: 0x91987208
	Offset: 0x2F20
	Size: 0x88
	Parameters: 7
	Flags: Linked
*/
function sword_statue_glow(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread play_fx(localclientnum, "sword_quest_sword_glow", "tag_knife_fx");
	}
	else
	{
		self notify("remove_" + "sword_quest_sword_glow");
	}
}

/*
	Name: sword_egg_glow
	Namespace: zm_zod_sword
	Checksum: 0xD8C0C34D
	Offset: 0x2FB0
	Size: 0x80
	Parameters: 7
	Flags: Linked
*/
function sword_egg_glow(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread play_fx(localclientnum, "egg_glow");
	}
	else
	{
		self notify("remove_" + "egg_glow");
	}
}

/*
	Name: blood_soul_fx
	Namespace: zm_zod_sword
	Checksum: 0x37CCDEC7
	Offset: 0x3038
	Size: 0x7E
	Parameters: 7
	Flags: Linked
*/
function blood_soul_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread play_fx(localclientnum, "blood_soul", "tag_origin");
	}
	else
	{
		self notify(#"remove_blood_soul");
	}
}

