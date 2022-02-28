// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;

#using_animtree("generic");

#namespace zm_zod_quest;

/*
	Name: __init__sytem__
	Namespace: zm_zod_quest
	Checksum: 0xE167504
	Offset: 0x1340
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_quest", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_quest
	Checksum: 0x1619D77B
	Offset: 0x1380
	Size: 0xDEC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!isdefined(level.main_quest))
	{
		level.main_quest = [];
	}
	level._effect["keeper_spawn"] = "zombie/fx_portal_keeper_spawn_zod_zmb";
	level._effect["keeper_glow"] = "zombie/fx_keeper_ambient_torso_zod_zmb";
	level._effect["keeper_death"] = "zombie/fx_keeper_death_zod_zmb";
	level._effect["keeper_mouth"] = "zombie/fx_keeper_glow_mouth_zod_zmb";
	level._effect["keeper_trail"] = "zombie/fx_keeper_mist_trail_zod_zmb";
	level._effect["ritual_key_glow"] = "zombie/fx_ritual_glow_key_zod_zmb";
	level._effect["relic_glow"] = "zombie/fx_ritual_glow_relic_zod_zmb";
	level._effect["memento_glow"] = "zombie/fx_ritual_glow_memento_zod_zmb";
	level._effect["fuse_glow"] = "zombie/fx_fuse_glow_blue_zod_zmb";
	level._effect["ritual_key_open_glow"] = "zombie/fx_ritual_glow_key_open_zod_zmb";
	level._effect["totem_hover"] = "zombie/fx_totem_mist_zod_zmb";
	level._effect["totem_ready"] = "zombie/fx_totem_leyline_zod_zmb";
	level._effect["totem_charging"] = "zombie/fx_totem_charging_zod_zmb";
	level._effect["totem_charged"] = "zombie/fx_totem_charged_zod_zmb";
	level._effect["totem_break"] = "zombie/fx_totem_break_zod_zmb";
	level._effect["shadowman_hover"] = "zombie/fx_shdw_glow_hover_zod_zmb";
	level._effect["shadowman_teleport"] = "zombie/fx_shdw_teleport_zod_zmb";
	level._effect["shadowman_hover_charge"] = "zombie/fx_shdw_glow_hover_charge_zod_zmb";
	level._effect["shadowman_energy_ball_charge"] = "zombie/fx_shdw_spell_charge_zod_zmb";
	level._effect["shadowman_energy_ball_explosion"] = "zombie/fx_shdw_spell_exp_zod_zmb";
	level._effect["shadowman_energy_ball"] = "zombie/fx_shdw_spell_zod_zmb";
	level._effect["shadowman_shield"] = "zombie/fx_ee_shadowman_shield_loop_zod";
	level._effect["shadowman_sword_impact_shield"] = "zombie/fx_ee_shadowman_shield_impact_zod_zmb";
	level._effect["shadowman_shield_explosion"] = "zombie/fx_ee_shadowman_shield_explo_zod_zmb";
	level._effect["shadowman_shield_regeneration"] = "zombie/fx_ee_shadowman_shield_regeneration_zod_zmb";
	level._effect["shadowman_light"] = "light/fx_light_zod_shadowman_appear";
	level._effect["shadowman_smoke"] = "zombie/fx_shdw_floating_smk_zod_zmb";
	level._effect["footprint_l"] = "player/fx_plyr_footstep_tracker_lf_zmb";
	level._effect["footprint_r"] = "player/fx_plyr_footstep_tracker_rf_zmb";
	clientfield::register("toplayer", "ZM_ZOD_UI_SUMMONING_KEY_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_RITUAL_BUSY", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("world", "quest_key", 1, 1, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	clientfield::register("world", "ritual_progress", 1, 7, "float", &ritual_progress, 0, 0);
	clientfield::register("world", "ritual_current", 1, 3, "int", undefined, 0, 0);
	n_bits = getminbitcountfornum(5);
	clientfield::register("world", "ritual_state_boxer", 1, n_bits, "int", &ritual_state_boxer, 0, 1);
	clientfield::register("world", "ritual_state_detective", 1, n_bits, "int", &ritual_state_detective, 0, 1);
	clientfield::register("world", "ritual_state_femme", 1, n_bits, "int", &ritual_state_femme, 0, 1);
	clientfield::register("world", "ritual_state_magician", 1, n_bits, "int", &ritual_state_magician, 0, 1);
	clientfield::register("world", "ritual_state_pap", 1, n_bits, "int", &ritual_state_pap, 0, 1);
	clientfield::register("world", "keeper_spawn_portals", 1, 4, "int", &keeper_spawn_portals, 0, 0);
	clientfield::register("world", "keeper_subway_fx", 1, 1, "int", &function_af8eff6d, 0, 0);
	clientfield::register("scriptmover", "cursetrap_fx", 1, 1, "int", &cursetrap_fx, 0, 0);
	clientfield::register("scriptmover", "mini_cursetrap_fx", 1, 1, "int", &mini_cursetrap_fx, 0, 0);
	clientfield::register("scriptmover", "curse_tell_fx", 1, 1, "int", &curse_tell_fx, 0, 0);
	clientfield::register("scriptmover", "darkportal_fx", 1, 1, "int", &darkportal_fx, 0, 0);
	clientfield::register("scriptmover", "boss_shield_fx", 1, 1, "int", &boss_shield_fx, 0, 0);
	clientfield::register("scriptmover", "keeper_symbol_fx", 1, 1, "int", &keeper_symbol_fx, 0, 0);
	n_bits = getminbitcountfornum(6);
	clientfield::register("scriptmover", "totem_state_fx", 1, n_bits, "int", &totem_state_fx, 0, 0);
	clientfield::register("scriptmover", "totem_damage_fx", 1, 3, "int", &totem_damage_fx, 0, 0);
	clientfield::register("scriptmover", "set_fade_material", 1, 1, "int", &set_fade_material, 0, 0);
	clientfield::register("scriptmover", "set_subway_wall_dissolve", 1, 1, "int", &set_subway_wall_dissolve, 0, 0);
	n_bits = getminbitcountfornum(3);
	clientfield::register("actor", "status_fx", 1, n_bits, "int", &status_fx, 0, 0);
	n_bits = getminbitcountfornum(3);
	clientfield::register("vehicle", "veh_status_fx", 1, n_bits, "int", &veh_status_fx, 0, 0);
	clientfield::register("actor", "keeper_fx", 1, 1, "int", &keeper_fx, 0, 0);
	clientfield::register("scriptmover", "item_glow_fx", 1, 3, "int", &item_glow_fx, 0, 0);
	n_bits = getminbitcountfornum(7);
	clientfield::register("scriptmover", "shadowman_fx", 1, n_bits, "int", &shadowman_fx, 0, 0);
	clientfield::register("world", "devgui_gateworm", 1, 1, "int", undefined, 0, 0);
	clientfield::register("scriptmover", "gateworm_basin_fx", 1, 2, "int", &gateworm_basin_fx, 0, 0);
	clientfield::register("world", "wallrun_footprints", 1, 2, "int", &function_1fea37a4, 0, 0);
	a_str_names = array("boxer", "detective", "femme", "magician");
	for(i = 0; i < 4; i++)
	{
		clientfield::register("toplayer", ("check_" + a_str_names[i]) + "_memento", 1, 1, "int", &zm_utility::setinventoryuimodels, 0, 0);
	}
	n_bits = getminbitcountfornum(6);
	clientfield::register("toplayer", "used_quest_key", 1, n_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	clientfield::register("toplayer", "used_quest_key_location", 1, n_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 0);
	visionset_mgr::register_visionset_info("zod_ritual_dim", 1, 15, "zm_zod", "zod_ritual_dim");
	flag::init("set_ritual_finished_flag");
	flag::init("set_ritual_key_closed_flag");
	flag::init("set_ritual_key_vanish_flag");
}

/*
	Name: create_client_ritual_assembly
	Namespace: zm_zod_quest
	Checksum: 0xEAC280A8
	Offset: 0x2178
	Size: 0x844
	Parameters: 2
	Flags: Linked
*/
function create_client_ritual_assembly(localclientnum, n_current_ritual)
{
	str_charname = get_name_from_ritual_clientfield_value(n_current_ritual);
	s_position = struct::get("defend_area_" + str_charname, "targetname");
	level.main_quest[localclientnum][n_current_ritual] = s_position;
	if(!isdefined(level.main_quest[localclientnum][n_current_ritual].e_assembly))
	{
		level.main_quest[localclientnum][n_current_ritual].e_assembly = [];
	}
	level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum] = spawn(localclientnum, s_position.origin, "script_model");
	level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum].angles = s_position.angles;
	level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum] setmodel("p7_fxanim_zm_zod_redemption_key_ritual_mod");
	level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum].vfx_trails = [];
	level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum] util::waittill_dobj(localclientnum);
	v_origin = level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum] gettagorigin("tag_ritual_drop");
	v_angles = level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum] gettagangles("tag_ritual_drop");
	if(!isdefined(level.main_quest[localclientnum][n_current_ritual].e_memento))
	{
		level.main_quest[localclientnum][n_current_ritual].e_memento = [];
	}
	level.main_quest[localclientnum][n_current_ritual].e_memento[localclientnum] = spawn(localclientnum, v_origin, "script_model");
	level.main_quest[localclientnum][n_current_ritual].e_memento[localclientnum].angles = v_angles;
	level.main_quest[localclientnum][n_current_ritual].e_memento[localclientnum] setmodel("p7_zm_zod_memento_" + str_charname);
	level.main_quest[localclientnum][n_current_ritual].e_memento[localclientnum] linkto(level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum], "tag_ritual_drop");
	level.main_quest[localclientnum][n_current_ritual].e_memento[localclientnum] function_ae5b7493(localclientnum, 0, 0.025, 1, 1);
	v_tag_origin = level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum] gettagorigin("tag_ritual_drop");
	v_tag_angles = level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum] gettagangles("tag_ritual_drop");
	if(!isdefined(level.main_quest[localclientnum][n_current_ritual].e_relic))
	{
		level.main_quest[localclientnum][n_current_ritual].e_relic = [];
	}
	level.main_quest[localclientnum][n_current_ritual].e_relic[localclientnum] = spawn(localclientnum, v_tag_origin, "script_model");
	level.main_quest[localclientnum][n_current_ritual].e_relic[localclientnum] setmodel("p7_zm_zod_relic_" + str_charname);
	level.main_quest[localclientnum][n_current_ritual].e_relic[localclientnum].angles = v_tag_angles;
	level.main_quest[localclientnum][n_current_ritual].e_relic[localclientnum] linkto(level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum], "tag_ritual_drop");
	level.main_quest[localclientnum][n_current_ritual].var_77504307 = function_9118f74a(localclientnum, n_current_ritual, 1);
	level.main_quest[localclientnum][n_current_ritual].var_b1ece640 = function_9118f74a(localclientnum, n_current_ritual, 0);
	v_tag_origin = level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum] gettagorigin("tag_char_jnt");
	if(!isdefined(level.main_quest[localclientnum][n_current_ritual].e_victim))
	{
		level.main_quest[localclientnum][n_current_ritual].e_victim = [];
	}
	level.main_quest[localclientnum][n_current_ritual].e_victim[localclientnum] = spawn(localclientnum, v_tag_origin, "script_model");
	switch(str_charname)
	{
		case "boxer":
		{
			var_30040f63 = "c_zom_zod_promoter_reveal_fb";
			break;
		}
		case "detective":
		{
			var_30040f63 = "c_zom_zod_partner_reveal_fb";
			break;
		}
		case "femme":
		{
			var_30040f63 = "c_zom_zod_producer_reveal_fb";
			break;
		}
		case "magician":
		{
			var_30040f63 = "c_zom_zod_lawyer_reveal_fb";
			break;
		}
	}
	level.main_quest[localclientnum][n_current_ritual].e_victim[localclientnum] setmodel(var_30040f63);
	level.main_quest[localclientnum][n_current_ritual].e_victim[localclientnum] useanimtree($generic);
}

/*
	Name: function_9118f74a
	Namespace: zm_zod_quest
	Checksum: 0x4E35CBF1
	Offset: 0x29C8
	Size: 0x13E
	Parameters: 3
	Flags: Linked
*/
function function_9118f74a(localclientnum, n_current_ritual, var_85dc52da)
{
	if(var_85dc52da)
	{
		var_3c32cd48 = getentarray(localclientnum, "quest_ritual_magic_circle_on", "targetname");
	}
	else
	{
		var_3c32cd48 = getentarray(localclientnum, "quest_ritual_magic_circle_off", "targetname");
	}
	str_name = get_name_from_ritual_clientfield_value(n_current_ritual);
	foreach(var_fb62adc1 in var_3c32cd48)
	{
		if(var_fb62adc1.script_string === ("ritual_" + str_name))
		{
			return var_fb62adc1;
		}
	}
}

/*
	Name: function_60f1115e
	Namespace: zm_zod_quest
	Checksum: 0x2F7F4B39
	Offset: 0x2B10
	Size: 0x226
	Parameters: 4
	Flags: Linked
*/
function function_60f1115e(localclientnum, n_current_ritual, n_state, var_abf03d83 = 0)
{
	switch(n_state)
	{
		case 0:
		{
			var_b05b3457 = 0.01;
			level.main_quest[localclientnum][n_current_ritual].var_77504307 function_ae5b7493(localclientnum, 2, var_b05b3457, 0, var_abf03d83, 1);
			level.main_quest[localclientnum][n_current_ritual].var_b1ece640 function_ae5b7493(localclientnum, 0, var_b05b3457, 0, var_abf03d83, 1);
			break;
		}
		case 1:
		{
			var_b05b3457 = 0.1;
			level.main_quest[localclientnum][n_current_ritual].var_77504307 function_ae5b7493(localclientnum, 2, var_b05b3457, 0, var_abf03d83, 1);
			level.main_quest[localclientnum][n_current_ritual].var_b1ece640 function_ae5b7493(localclientnum, 0, var_b05b3457, 1, var_abf03d83, 1);
			break;
		}
		case 2:
		{
			var_b05b3457 = 0.1;
			level.main_quest[localclientnum][n_current_ritual].var_77504307 function_ae5b7493(localclientnum, 2, var_b05b3457, 1, var_abf03d83, 1);
			level.main_quest[localclientnum][n_current_ritual].var_b1ece640 function_ae5b7493(localclientnum, 0, var_b05b3457, 0, var_abf03d83, 1);
			break;
		}
	}
}

/*
	Name: function_ae5b7493
	Namespace: zm_zod_quest
	Checksum: 0x4443B764
	Offset: 0x2D40
	Size: 0x29C
	Parameters: 6
	Flags: Linked
*/
function function_ae5b7493(localclientnum, var_afc7cc94, var_b05b3457, b_on, var_abf03d83 = 0, var_c0ce8db2 = 0)
{
	self notify(#"hash_ae5b7493");
	self endon(#"hash_ae5b7493");
	if(self.b_on === b_on)
	{
		return;
	}
	self.b_on = b_on;
	if(var_abf03d83)
	{
		if(b_on)
		{
			self function_487ce26(localclientnum, 1, var_afc7cc94);
		}
		else
		{
			self function_487ce26(localclientnum, 0, var_afc7cc94);
		}
		return;
	}
	if(b_on)
	{
		var_24fbb6c6 = 0;
		i = 0;
		while(var_24fbb6c6 <= 1)
		{
			self function_487ce26(localclientnum, var_24fbb6c6, var_afc7cc94);
			if(var_c0ce8db2)
			{
				var_24fbb6c6 = sqrt(i);
			}
			else
			{
				var_24fbb6c6 = i;
			}
			wait(0.01);
			i = i + var_b05b3457;
		}
		self function_487ce26(localclientnum, 1, var_afc7cc94);
	}
	else
	{
		var_24fbb6c6 = 1;
		i = 1;
		while(var_24fbb6c6 >= 0)
		{
			self function_487ce26(localclientnum, var_24fbb6c6, var_afc7cc94);
			if(var_c0ce8db2)
			{
				var_24fbb6c6 = sqrt(i);
			}
			else
			{
				var_24fbb6c6 = i;
			}
			wait(0.01);
			i = i - var_b05b3457;
		}
		self function_487ce26(localclientnum, 0, var_afc7cc94);
	}
}

/*
	Name: function_487ce26
	Namespace: zm_zod_quest
	Checksum: 0xA3E906EF
	Offset: 0x2FE8
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function function_487ce26(localclientnum, n_value, var_afc7cc94)
{
	self mapshaderconstant(localclientnum, 0, "scriptVector" + var_afc7cc94, n_value, n_value, 0, 0);
}

/*
	Name: set_fade_material
	Namespace: zm_zod_quest
	Checksum: 0x31354AE9
	Offset: 0x3048
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function set_fade_material(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self mapshaderconstant(localclientnum, 0, "scriptVector0", newval, 0, 0, 0);
}

/*
	Name: set_subway_wall_dissolve
	Namespace: zm_zod_quest
	Checksum: 0xA581FF91
	Offset: 0x30B8
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function set_subway_wall_dissolve(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector0", newval, 0, 0, 0);
	}
	else
	{
		self thread function_6d34f463(localclientnum, 2);
		self playsound(0, "zmb_zod_wall_dissolve");
	}
}

/*
	Name: function_6d34f463
	Namespace: zm_zod_quest
	Checksum: 0x5D7C5AC0
	Offset: 0x3180
	Size: 0xD6
	Parameters: 2
	Flags: Linked
*/
function function_6d34f463(localclientnum, n_total_time)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	var_1baf89ac = n_total_time / 0.016;
	exploder::exploder("lgt_sword_altar_underground");
	for(i = 0; i <= var_1baf89ac; i++)
	{
		var_6740490 = 1 - (i / var_1baf89ac);
		self setshaderconstant(localclientnum, 0, var_6740490, 0, 0, 0);
		wait(0.016);
	}
}

/*
	Name: get_name_from_ritual_clientfield_value
	Namespace: zm_zod_quest
	Checksum: 0x5B061C79
	Offset: 0x3260
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function get_name_from_ritual_clientfield_value(current_ritual)
{
	switch(current_ritual)
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
		case 5:
		{
			return "pap";
		}
	}
}

/*
	Name: ritual_state_internal
	Namespace: zm_zod_quest
	Checksum: 0x8AFA6C69
	Offset: 0x32D8
	Size: 0xB66
	Parameters: 3
	Flags: Linked
*/
function ritual_state_internal(localclientnum, newval, n_current_ritual)
{
	level notify("ritual_state_internal" + localclientnum);
	level endon("ritual_state_internal" + localclientnum);
	str_name = get_name_from_ritual_clientfield_value(n_current_ritual);
	if(!isdefined(level.main_quest))
	{
		level.main_quest = [];
	}
	if(!isdefined(level.main_quest[localclientnum]))
	{
		level.main_quest[localclientnum] = [];
	}
	if(!isdefined(level.main_quest[localclientnum][n_current_ritual]))
	{
		create_client_ritual_assembly(localclientnum, n_current_ritual);
	}
	mdl_ritual = level.main_quest[localclientnum][n_current_ritual].e_assembly[localclientnum];
	mdl_ritual util::waittill_dobj(localclientnum);
	if(!mdl_ritual hasanimtree())
	{
		mdl_ritual useanimtree($generic);
	}
	mdl_memento = level.main_quest[localclientnum][n_current_ritual].e_memento[localclientnum];
	mdl_relic = level.main_quest[localclientnum][n_current_ritual].e_relic[localclientnum];
	if(!mdl_relic hasanimtree())
	{
		mdl_relic useanimtree($generic);
	}
	mdl_victim = level.main_quest[localclientnum][n_current_ritual].e_victim[localclientnum];
	switch(newval)
	{
		case 0:
		{
			mdl_ritual hide();
			mdl_memento hide();
			mdl_relic hide();
			mdl_victim hide();
			level thread function_60f1115e(localclientnum, n_current_ritual, 1, 1);
			if(isdefined(mdl_ritual.var_958bf245))
			{
				stopfx(localclientnum, mdl_ritual.var_958bf245);
			}
			level thread sndritual(0, mdl_ritual);
			break;
		}
		case 1:
		{
			level notify(#"ritual_victim_animation");
			mdl_ritual hide();
			mdl_memento show();
			mdl_memento function_ae5b7493(localclientnum, 0, 0.025, 1, 1);
			mdl_relic hide();
			mdl_victim hide();
			level thread function_60f1115e(localclientnum, n_current_ritual, 1);
			if(isdefined(mdl_ritual.var_958bf245))
			{
				stopfx(localclientnum, mdl_ritual.var_958bf245);
			}
			mdl_ritual clearanim("p7_fxanim_zm_zod_redemption_key_ritual_start_anim", 0);
			mdl_ritual clearanim("p7_fxanim_zm_zod_redemption_key_ritual_loop_anim", 0);
			mdl_ritual clearanim("p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim", 0);
			level thread sndritual(1, mdl_ritual);
			level thread exploder::stop_exploder("ritual_light_" + str_name);
			toggle_altar_vfx(localclientnum, str_name, 0);
			function_46df8306(localclientnum, "defend_area_spawn_point_" + str_name, 0);
			break;
		}
		case 2:
		{
			mdl_ritual show();
			mdl_relic hide();
			mdl_victim hide();
			level thread function_60f1115e(localclientnum, n_current_ritual, 2);
			for(i = 0; i < 4; i++)
			{
				mdl_ritual.vfx_trails[i] = playfxontag(localclientnum, level._effect["ritual_trail"], mdl_ritual, ("disc" + (i + 1)) + "_blade_body_jnt");
			}
			mdl_ritual.var_958bf245 = playfxontag(localclientnum, level._effect["ritual_key_open_glow"], mdl_ritual, "key_outer_rot_jnt");
			level thread sndritual(2, mdl_ritual);
			level thread exploder::exploder("ritual_light_" + str_name);
			toggle_altar_vfx(localclientnum, str_name, 1);
			function_46df8306(localclientnum, "defend_area_spawn_point_" + str_name, 1);
			mdl_memento show();
			mdl_memento function_ae5b7493(localclientnum, 0, 0.025, 1, 1);
			mdl_ritual animation::play("p7_fxanim_zm_zod_redemption_key_ritual_start_anim", undefined, undefined, 1, 0, 0);
			level thread function_eb1d9e29(localclientnum, mdl_ritual, mdl_memento, mdl_victim);
			mdl_ritual animation::play("p7_fxanim_zm_zod_redemption_key_ritual_loop_anim", undefined, undefined, 1, 0, 0);
			mdl_ritual clearanim("p7_fxanim_zm_zod_redemption_key_ritual_loop_anim", 0);
			mdl_ritual animation::play("p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim", undefined, undefined, 1, 0, 0);
			break;
		}
		case 3:
		{
			level notify(#"ritual_victim_animation");
			mdl_relic setanim("ai_zombie_zod_gateworm_idle_loop", 1, 0, 1);
			mdl_ritual show();
			mdl_memento hide();
			mdl_relic hide();
			mdl_victim show();
			mdl_victim = level.main_quest[localclientnum][n_current_ritual].e_victim[localclientnum];
			mdl_victim.vfx_chest = playfxontag(localclientnum, level._effect["ritual_glow_chest"], mdl_victim, "j_spineupper");
			mdl_victim.vfx_head = playfxontag(localclientnum, level._effect["ritual_glow_head"], mdl_victim, "tag_eye");
			mdl_ritual clearanim("p7_fxanim_zm_zod_redemption_key_ritual_loop_fast_anim", 0);
			if(isdefined(mdl_ritual.vfx_trails))
			{
				foreach(var_2d3cc156 in mdl_ritual.vfx_trails)
				{
					stopfx(localclientnum, var_2d3cc156);
				}
			}
			mdl_victim thread animation::play("ai_zombie_zod_ritual_sacrifice_outro", undefined, undefined, 1, 0.4, 0.25);
			level thread key_combines_notetrack_watcher(localclientnum, mdl_ritual, mdl_relic, mdl_victim, str_name);
			level thread function_ed53c8d4(localclientnum, mdl_ritual);
			level thread function_1088ce1d(localclientnum, mdl_ritual);
			mdl_ritual animation::play("p7_fxanim_zm_zod_redemption_key_ritual_end_anim");
			mdl_ritual clearanim("p7_fxanim_zm_zod_redemption_key_ritual_end_anim", 0);
			mdl_ritual thread animation::play("p7_fxanim_zm_zod_redemption_key_ritual_end_idle_anim");
			level thread function_60f1115e(localclientnum, n_current_ritual, 0);
			mdl_victim hide();
			break;
		}
		case 4:
		{
			mdl_relic hide();
			mdl_relic playsound(0, "zmb_zod_ritual_worm_pickup");
			mdl_relic stopallloopsounds(0.5);
			break;
		}
	}
}

/*
	Name: function_eb1d9e29
	Namespace: zm_zod_quest
	Checksum: 0x58A07EFC
	Offset: 0x3E48
	Size: 0x8C
	Parameters: 4
	Flags: Linked
*/
function function_eb1d9e29(localclientnum, mdl_ritual, mdl_memento, mdl_victim)
{
	mdl_memento thread function_ae5b7493(localclientnum, 0, 0.025, 0, 0, 0);
	wait(0.15);
	mdl_victim show();
	level thread ritual_victim_animation(localclientnum, mdl_ritual, mdl_victim);
}

/*
	Name: ritual_victim_animation
	Namespace: zm_zod_quest
	Checksum: 0x395D113E
	Offset: 0x3EE0
	Size: 0x154
	Parameters: 3
	Flags: Linked
*/
function ritual_victim_animation(localclientnum, mdl_ritual, mdl_victim)
{
	level notify("ritual_victim_animation" + localclientnum);
	level endon("ritual_victim_animation" + localclientnum);
	mdl_victim clearanim("ai_zombie_zod_ritual_sacrifice_intro", 0);
	mdl_victim clearanim("ai_zombie_zod_ritual_sacrifice_loop", 0);
	mdl_victim clearanim("ai_zombie_zod_ritual_sacrifice_outro", 0);
	mdl_victim linkto(mdl_victim, "tag_char_jnt", (0, 0, 0), (0, 0, 0));
	mdl_victim thread function_ae5b7493(localclientnum, 0, 0.025, 1);
	mdl_victim animation::play("ai_zombie_zod_ritual_sacrifice_intro", undefined, undefined, 1, 0, 0.2);
	mdl_victim thread animation::play("ai_zombie_zod_ritual_sacrifice_loop", undefined, undefined, 1, 0.2, 0.4);
}

/*
	Name: key_combines_notetrack_watcher
	Namespace: zm_zod_quest
	Checksum: 0xEE957936
	Offset: 0x4040
	Size: 0x24C
	Parameters: 5
	Flags: Linked
*/
function key_combines_notetrack_watcher(localclientnum, mdl_ritual, mdl_relic, mdl_victim, str_name)
{
	flag::wait_till("set_ritual_finished_flag");
	v_origin = mdl_ritual gettagorigin("tag_fx_chest");
	v_angles = mdl_ritual gettagangles("tag_fx_chest");
	v_angles = v_angles - vectorscale((1, 0, 0), 90);
	v_fwd = anglestoforward(v_angles);
	playfx(localclientnum, level._effect["ritual_bloodsplosion"], v_origin, v_fwd);
	level thread function_3a9a1b46(mdl_relic);
	if(str_name === "pap")
	{
		mdl_victim hide();
	}
	else
	{
		mdl_victim thread function_ae5b7493(localclientnum, 0, 0.05, 0, 0, 1);
	}
	stopfx(localclientnum, mdl_victim.vfx_chest);
	stopfx(localclientnum, mdl_victim.vfx_head);
	level thread sndritual(3, mdl_ritual);
	level thread ritual_success_light_exploder(str_name);
	toggle_altar_vfx(localclientnum, str_name, 0);
	function_46df8306(localclientnum, "defend_area_spawn_point_" + str_name, 0);
	flag::clear("set_ritual_finished_flag");
}

/*
	Name: function_3a9a1b46
	Namespace: zm_zod_quest
	Checksum: 0xBA83D42D
	Offset: 0x4298
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function function_3a9a1b46(mdl_relic)
{
	if(isdefined(mdl_relic))
	{
		var_69146d00 = level clientfield::get("devgui_gateworm");
		if(!(isdefined(var_69146d00) && var_69146d00))
		{
			wait(0.25);
			mdl_relic show();
			mdl_relic playloopsound("zmb_zod_ritual_worm_lp", 1);
		}
	}
}

/*
	Name: function_ed53c8d4
	Namespace: zm_zod_quest
	Checksum: 0xB11B9D6E
	Offset: 0x4338
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function function_ed53c8d4(localclientnum, mdl_ritual)
{
	flag::wait_till("set_ritual_key_closed_flag");
	if(isdefined(mdl_ritual.var_958bf245))
	{
		stopfx(localclientnum, mdl_ritual.var_958bf245);
	}
	flag::clear("set_ritual_key_closed_flag");
}

/*
	Name: function_1088ce1d
	Namespace: zm_zod_quest
	Checksum: 0x2AE6B08F
	Offset: 0x43C0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function function_1088ce1d(localclientnum, mdl_ritual)
{
	flag::wait_till("set_ritual_key_vanish_flag");
	mdl_ritual hide();
	flag::clear("set_ritual_key_vanish_flag");
}

/*
	Name: ritual_success_light_exploder
	Namespace: zm_zod_quest
	Checksum: 0x6CF5B77D
	Offset: 0x4428
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function ritual_success_light_exploder(str_name)
{
	level thread exploder::stop_exploder("ritual_light_" + str_name);
	level thread exploder::exploder(("ritual_light_" + str_name) + "_fin");
}

/*
	Name: toggle_altar_vfx
	Namespace: zm_zod_quest
	Checksum: 0x9612D8DF
	Offset: 0x4488
	Size: 0x1AE
	Parameters: 3
	Flags: Linked
*/
function toggle_altar_vfx(localclientnum, str_name, b_on)
{
	a_ritual_pedestal = getentarray(localclientnum, "ritual_pedestal", "targetname");
	foreach(e_ritual_pedestal in a_ritual_pedestal)
	{
		if(!isdefined(e_ritual_pedestal.ritual_fx))
		{
			e_ritual_pedestal.ritual_fx = [];
		}
		if(b_on && e_ritual_pedestal.script_string == ("ritual_" + str_name))
		{
			e_ritual_pedestal.ritual_fx[localclientnum] = playfx(localclientnum, level._effect["ritual_altar"], e_ritual_pedestal.origin);
			continue;
		}
		if(isdefined(e_ritual_pedestal.ritual_fx[localclientnum]))
		{
			stopfx(localclientnum, e_ritual_pedestal.ritual_fx[localclientnum]);
			e_ritual_pedestal.ritual_fx[localclientnum] = undefined;
		}
	}
}

/*
	Name: function_46df8306
	Namespace: zm_zod_quest
	Checksum: 0xFE590E93
	Offset: 0x4640
	Size: 0x252
	Parameters: 3
	Flags: Linked
*/
function function_46df8306(localclientnum, str_name, b_on = 1)
{
	a_s_spawn_points = struct::get_array(str_name, "targetname");
	foreach(s_spawn_point in a_s_spawn_points)
	{
		s_spawn_point function_267f859f(localclientnum, level._effect["keeper_spawn"], b_on);
		if(!isdefined(s_spawn_point.var_d52fc488))
		{
			s_spawn_point.var_d52fc488 = 0;
		}
		if(isdefined(b_on) && b_on)
		{
			if(!(isdefined(s_spawn_point.var_d52fc488) && s_spawn_point.var_d52fc488))
			{
				s_spawn_point.var_d52fc488 = 1;
				playsound(0, "evt_keeper_portal_start", s_spawn_point.origin);
				audio::playloopat("evt_keeper_portal_loop", s_spawn_point.origin);
			}
		}
		else if(isdefined(s_spawn_point.var_d52fc488) && s_spawn_point.var_d52fc488)
		{
			s_spawn_point.var_d52fc488 = 0;
			playsound(0, "evt_keeper_portal_end", s_spawn_point.origin);
			audio::stoploopat("evt_keeper_portal_loop", s_spawn_point.origin);
		}
		wait(0.2);
	}
}

/*
	Name: function_267f859f
	Namespace: zm_zod_quest
	Checksum: 0x1BA33036
	Offset: 0x48A0
	Size: 0x190
	Parameters: 5
	Flags: Linked
*/
function function_267f859f(localclientnum, fx_id = undefined, b_on = 1, var_afcc5d76 = 0, str_tag = "tag_origin")
{
	if(!isdefined(self.vfx_ref))
	{
		self.vfx_ref = [];
	}
	if(b_on)
	{
		if(!isdefined(self))
		{
			return;
		}
		if(isdefined(self.vfx_ref[localclientnum]))
		{
			stopfx(localclientnum, self.vfx_ref[localclientnum]);
		}
		if(var_afcc5d76)
		{
			self.vfx_ref[localclientnum] = playfxontag(localclientnum, fx_id, self, str_tag);
		}
		else
		{
			self.vfx_ref[localclientnum] = playfx(localclientnum, fx_id, self.origin, self.angles);
		}
	}
	else if(isdefined(self.vfx_ref[localclientnum]))
	{
		stopfx(localclientnum, self.vfx_ref[localclientnum]);
		self.vfx_ref[localclientnum] = undefined;
	}
}

/*
	Name: sndritual
	Namespace: zm_zod_quest
	Checksum: 0x4734B674
	Offset: 0x4A38
	Size: 0xB2
	Parameters: 2
	Flags: Linked
*/
function sndritual(state, e_model)
{
	level notify(#"sndritual");
	level endon(#"sndritual");
	switch(state)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			e_model playsound(0, "zmb_zod_ritual_piece_place");
			break;
		}
		case 2:
		{
			e_model playsound(0, "zmb_zod_ritual_key_flame");
			break;
		}
		case 3:
		{
			break;
		}
	}
}

/*
	Name: ritual_state_boxer
	Namespace: zm_zod_quest
	Checksum: 0xEB849CCF
	Offset: 0x4AF8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function ritual_state_boxer(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	ritual_state_internal(localclientnum, newval, 1);
}

/*
	Name: ritual_state_detective
	Namespace: zm_zod_quest
	Checksum: 0x61415650
	Offset: 0x4B60
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function ritual_state_detective(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	ritual_state_internal(localclientnum, newval, 2);
}

/*
	Name: ritual_state_femme
	Namespace: zm_zod_quest
	Checksum: 0xC46EB148
	Offset: 0x4BC8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function ritual_state_femme(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	ritual_state_internal(localclientnum, newval, 3);
}

/*
	Name: ritual_state_magician
	Namespace: zm_zod_quest
	Checksum: 0x5B4BD691
	Offset: 0x4C30
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function ritual_state_magician(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	ritual_state_internal(localclientnum, newval, 4);
}

/*
	Name: quest_state_boxer
	Namespace: zm_zod_quest
	Checksum: 0x1EEBCFC4
	Offset: 0x4C98
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function quest_state_boxer(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	zm_utility::setsharedinventoryuimodels(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
}

/*
	Name: quest_state_detective
	Namespace: zm_zod_quest
	Checksum: 0x56EC2D32
	Offset: 0x4D10
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function quest_state_detective(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	zm_utility::setsharedinventoryuimodels(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
}

/*
	Name: quest_state_femme
	Namespace: zm_zod_quest
	Checksum: 0x75936A2A
	Offset: 0x4D88
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function quest_state_femme(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	zm_utility::setsharedinventoryuimodels(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
}

/*
	Name: quest_state_magician
	Namespace: zm_zod_quest
	Checksum: 0xCEDE4CD
	Offset: 0x4E00
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function quest_state_magician(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	zm_utility::setsharedinventoryuimodels(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
}

/*
	Name: ritual_state_pap
	Namespace: zm_zod_quest
	Checksum: 0xB0C030A
	Offset: 0x4E78
	Size: 0x5BE
	Parameters: 7
	Flags: Linked
*/
function ritual_state_pap(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_c6f3f6c3 = getent(localclientnum, "pap_portal", "targetname");
	var_c6f3f6c3 util::waittill_dobj(localclientnum);
	if(!var_c6f3f6c3 hasanimtree())
	{
		var_c6f3f6c3 useanimtree($generic);
	}
	str_name = get_name_from_ritual_clientfield_value(5);
	if(newval == 2)
	{
		level thread exploder::exploder("ritual_light_pap");
		function_46df8306(localclientnum, "defend_area_spawn_point_" + str_name, 1);
		a_ritual_pedestal = getentarray(localclientnum, "ritual_pedestal", "targetname");
		foreach(e_ritual_pedestal in a_ritual_pedestal)
		{
			if(!isdefined(e_ritual_pedestal.ritual_fx))
			{
				e_ritual_pedestal.ritual_fx = [];
			}
			if(e_ritual_pedestal.script_string == "ritual_pap")
			{
				e_ritual_pedestal.ritual_fx[localclientnum] = playfx(localclientnum, level._effect["pap_altar_glow"], e_ritual_pedestal.origin);
			}
		}
	}
	else
	{
		if(newval == 3)
		{
			var_c6f3f6c3 show();
			var_c6f3f6c3 thread animation::play("p7_fxanim_zm_zod_gatestone_anim", undefined, undefined, 1);
			level thread exploder::stop_exploder("ritual_light_pap");
			level thread function_b2aa47f0();
			function_46df8306(localclientnum, "defend_area_spawn_point_" + str_name, 0);
			a_ritual_pedestal = getentarray(localclientnum, "ritual_pedestal", "targetname");
			foreach(e_ritual_pedestal in a_ritual_pedestal)
			{
				if(!isdefined(e_ritual_pedestal.ritual_fx))
				{
					e_ritual_pedestal.ritual_fx = [];
				}
				if(isdefined(e_ritual_pedestal.ritual_fx[localclientnum]))
				{
					stopfx(localclientnum, e_ritual_pedestal.ritual_fx[localclientnum]);
					e_ritual_pedestal.ritual_fx[localclientnum] = undefined;
				}
			}
		}
		else if(newval == 1)
		{
			var_c6f3f6c3 hide();
			level thread exploder::stop_exploder("ritual_light_pap");
			level thread function_b2aa47f0();
			function_46df8306(localclientnum, "defend_area_spawn_point_" + str_name, 0);
			a_ritual_pedestal = getentarray(localclientnum, "ritual_pedestal", "targetname");
			foreach(e_ritual_pedestal in a_ritual_pedestal)
			{
				if(!isdefined(e_ritual_pedestal.ritual_fx))
				{
					e_ritual_pedestal.ritual_fx = [];
				}
				if(isdefined(e_ritual_pedestal.ritual_fx[localclientnum]))
				{
					stopfx(localclientnum, e_ritual_pedestal.ritual_fx[localclientnum]);
					e_ritual_pedestal.ritual_fx[localclientnum] = undefined;
				}
			}
		}
	}
}

/*
	Name: function_b2aa47f0
	Namespace: zm_zod_quest
	Checksum: 0x614EECB9
	Offset: 0x5440
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_b2aa47f0()
{
	soundlineemitter("zmb_zod_pap_portal_lp_dist", (2613, -2239, -258), (2608, -3045, -275));
	soundloopemitter("zmb_zod_pap_portal_lp", (2613, -2239, -258));
}

/*
	Name: ritual_progress
	Namespace: zm_zod_quest
	Checksum: 0x137181CB
	Offset: 0x54B0
	Size: 0x96
	Parameters: 7
	Flags: Linked
*/
function ritual_progress(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.main_quest[localclientnum]))
	{
		return;
	}
	ritual_current = level clientfield::get("ritual_current");
	if(ritual_current != 5 && ritual_current != 0)
	{
	}
}

/*
	Name: keeper_fx
	Namespace: zm_zod_quest
	Checksum: 0xDBBE6F32
	Offset: 0x5550
	Size: 0x27C
	Parameters: 7
	Flags: Linked
*/
function keeper_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval === 1)
	{
		self.var_341f7209 = playfxontag(localclientnum, level._effect["keeper_glow"], self, "j_spineupper");
		self.var_c5e3cf4b = playfxontag(localclientnum, level._effect["keeper_mouth"], self, "j_head");
		self.var_2d3cc156 = playfxontag(localclientnum, level._effect["keeper_trail"], self, "j_robe_front_03");
		if(!isdefined(self.sndlooper))
		{
			self.sndlooper = self playloopsound("zmb_keeper_looper");
		}
	}
	else
	{
		if(isdefined(self.var_341f7209))
		{
			stopfx(localclientnum, self.var_341f7209);
		}
		self.var_341f7209 = undefined;
		if(isdefined(self.var_c5e3cf4b))
		{
			stopfx(localclientnum, self.var_c5e3cf4b);
		}
		self.var_c5e3cf4b = undefined;
		if(isdefined(self.var_2d3cc156))
		{
			stopfx(localclientnum, self.var_2d3cc156);
		}
		self.var_2d3cc156 = undefined;
		v_origin = self gettagorigin("j_spineupper");
		v_angles = self gettagangles("j_spineupper");
		if(isdefined(v_origin) && isdefined(v_angles))
		{
			playfx(localclientnum, level._effect["keeper_death"], v_origin, v_angles);
		}
		self stopallloopsounds(1);
	}
}

/*
	Name: keeper_symbol_fx
	Namespace: zm_zod_quest
	Checksum: 0x848BFE9F
	Offset: 0x57D8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function keeper_symbol_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_267f859f(localclientnum, level._effect["keeper_glow"], newval, 1);
}

/*
	Name: item_glow_fx
	Namespace: zm_zod_quest
	Checksum: 0x60724998
	Offset: 0x5850
	Size: 0x1DE
	Parameters: 7
	Flags: Linked
*/
function item_glow_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self notify(#"item_glow_fx");
	self endon(#"item_glow_fx");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.item_glow_fx))
	{
		stopfx(localclientnum, self.item_glow_fx);
		self.item_glow_fx = undefined;
	}
	switch(newval)
	{
		case 1:
		{
			self.item_glow_fx = playfxontag(localclientnum, level._effect["ritual_key_glow"], self, "key_body_jnt");
			break;
		}
		case 2:
		{
			self.item_glow_fx = playfxontag(localclientnum, level._effect["relic_glow"], self, "tag_origin");
			break;
		}
		case 3:
		{
			self.item_glow_fx = playfxontag(localclientnum, level._effect["memento_glow"], self, "tag_origin");
			break;
		}
		case 4:
		{
			self.item_glow_fx = playfxontag(localclientnum, level._effect["fuse_glow"], self, "tag_origin");
			break;
		}
	}
}

/*
	Name: keeper_spawn_portals
	Namespace: zm_zod_quest
	Checksum: 0x685D9FBA
	Offset: 0x5A38
	Size: 0xD6
	Parameters: 7
	Flags: Linked
*/
function keeper_spawn_portals(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	for(i = 0; i < 4; i++)
	{
		b_on = (newval >> i) & 1;
		str_name = get_name_from_ritual_clientfield_value(i + 1);
		function_46df8306(localclientnum, "memento_spawn_point_" + str_name, b_on);
	}
}

/*
	Name: function_af8eff6d
	Namespace: zm_zod_quest
	Checksum: 0x5B75085
	Offset: 0x5B18
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_af8eff6d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	function_46df8306(localclientnum, "keeper_spawn_point_subway", newval);
}

/*
	Name: cursetrap_fx
	Namespace: zm_zod_quest
	Checksum: 0x3FBE0D6C
	Offset: 0x5B80
	Size: 0x114
	Parameters: 7
	Flags: Linked
*/
function cursetrap_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.sndlooper))
	{
		self stoploopsound(self.sndlooper, 0.5);
		self.sndlooper = undefined;
		self playsound(0, "zmb_zod_cursed_landmine_end");
	}
	if(newval)
	{
		self.sndlooper = self playloopsound("zmb_zod_cursed_landmine_lp", 1);
		self playsound(0, "zmb_zod_cursed_landmine_start");
	}
	self function_267f859f(localclientnum, level._effect["curse_circle"], newval, 1);
}

/*
	Name: mini_cursetrap_fx
	Namespace: zm_zod_quest
	Checksum: 0xA386AC60
	Offset: 0x5CA0
	Size: 0x114
	Parameters: 7
	Flags: Linked
*/
function mini_cursetrap_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.sndlooper))
	{
		self stoploopsound(self.sndlooper, 0.5);
		self.sndlooper = undefined;
		self playsound(0, "zmb_zod_cursed_landmine_end");
	}
	if(newval)
	{
		self.sndlooper = self playloopsound("zmb_zod_cursed_landmine_lp", 1);
		self playsound(0, "zmb_zod_cursed_landmine_start");
	}
	self function_267f859f(localclientnum, level._effect["mini_curse_circle"], newval, 1);
}

/*
	Name: curse_tell_fx
	Namespace: zm_zod_quest
	Checksum: 0x84643177
	Offset: 0x5DC0
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function curse_tell_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_267f859f(localclientnum, level._effect["curse_tell"], newval, 1);
}

/*
	Name: boss_shield_fx
	Namespace: zm_zod_quest
	Checksum: 0x903C65C8
	Offset: 0x5E38
	Size: 0x264
	Parameters: 7
	Flags: Linked
*/
function boss_shield_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_53c5edf0 = self gettagorigin("j_spinelower");
	if(isdefined(self.sndlooper))
	{
		self stoploopsound(self.sndlooper, 1);
		self.sndlooper = undefined;
	}
	if(newval)
	{
		var_caece670 = playfx(localclientnum, level._effect["shadowman_shield_regeneration"], var_53c5edf0);
		wait(1);
		stopfx(localclientnum, var_caece670);
		if(isdefined(self))
		{
			self function_267f859f(localclientnum, level._effect["shadowman_shield"], 1, 1, "j_spinelower");
			self.sndlooper = self playloopsound("zmb_zod_shadfight_shield_lp", 2);
		}
	}
	else
	{
		var_2f708c86 = playfx(localclientnum, level._effect["shadowman_sword_impact_shield"], var_53c5edf0);
		wait(1);
		stopfx(localclientnum, var_2f708c86);
		playfx(localclientnum, level._effect["shadowman_shield_explosion"], var_53c5edf0);
		if(isdefined(self))
		{
			self function_267f859f(localclientnum, level._effect["shadowman_hover"], 1, 1, "j_spinelower");
			self.sndlooper = self playloopsound("zmb_zod_shadfight_shield_down_lp", 2);
		}
	}
}

/*
	Name: status_fx
	Namespace: zm_zod_quest
	Checksum: 0x5E86FFBC
	Offset: 0x60A8
	Size: 0x11E
	Parameters: 7
	Flags: Linked
*/
function status_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0 && isdefined(self.var_a77e68b9))
	{
		stopfx(localclientnum, self.var_a77e68b9);
	}
	else if(!isdefined(self.var_a77e68b9))
	{
		switch(newval)
		{
			case 1:
			{
				self.var_a77e68b9 = playfxontag(localclientnum, level._effect["darkfire_buff"], self, "j_head");
				break;
			}
			case 2:
			{
				self.var_a77e68b9 = playfxontag(localclientnum, level._effect["margwa_buff"], self, "j_head");
				break;
			}
		}
	}
}

/*
	Name: veh_status_fx
	Namespace: zm_zod_quest
	Checksum: 0x505E9771
	Offset: 0x61D0
	Size: 0x11E
	Parameters: 7
	Flags: Linked
*/
function veh_status_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0 && isdefined(self.var_a77e68b9))
	{
		stopfx(localclientnum, self.var_a77e68b9);
	}
	else if(!isdefined(self.var_a77e68b9))
	{
		switch(newval)
		{
			case 1:
			{
				self.var_a77e68b9 = playfxontag(localclientnum, level._effect["parasite_buff"], self, "j_head");
				break;
			}
			case 2:
			{
				self.var_a77e68b9 = playfxontag(localclientnum, level._effect["meatball_buff"], self, "tag_body");
				break;
			}
		}
	}
}

/*
	Name: shadowman_fx
	Namespace: zm_zod_quest
	Checksum: 0xC32A64A9
	Offset: 0x62F8
	Size: 0x392
	Parameters: 7
	Flags: Linked
*/
function shadowman_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_6067fcbe))
	{
		stopfx(localclientnum, self.var_6067fcbe);
	}
	if(isdefined(self.var_8eb9fdc0))
	{
		stopfx(localclientnum, self.var_8eb9fdc0);
	}
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newval)
	{
		case 1:
		{
			playfxontag(localclientnum, level._effect["shadowman_teleport"], self, "j_spinelower");
			self.var_8741354e = playfxontag(localclientnum, level._effect["shadowman_light"], self, "j_spineupper");
			self.vfx_smoke = playfxontag(localclientnum, level._effect["shadowman_smoke"], self, "tag_origin");
			break;
		}
		case 2:
		{
			if(isdefined(self.var_8741354e))
			{
				stopfx(localclientnum, self.var_8741354e);
			}
			if(isdefined(self.vfx_smoke))
			{
				stopfx(localclientnum, self.vfx_smoke);
			}
			v_origin = self gettagorigin("j_spinelower");
			if(!isdefined(v_origin))
			{
				v_origin = self.origin;
			}
			level thread function_705b696b(localclientnum, level._effect["shadowman_teleport"], v_origin, 2);
			level thread function_705b696b(localclientnum, level._effect["shadowman_smoke"], v_origin, 2);
			break;
		}
		case 3:
		{
			self.var_6067fcbe = playfxontag(localclientnum, level._effect["shadowman_hover_charge"], self, "j_spinelower");
			self.var_8eb9fdc0 = playfxontag(localclientnum, level._effect["shadowman_energy_ball_charge"], self, "tag_weapon_right");
			break;
		}
		case 4:
		{
			self.var_8eb9fdc0 = playfxontag(localclientnum, level._effect["shadowman_energy_ball"], self, "tag_weapon_right");
			break;
		}
		case 5:
		{
			self.var_8eb9fdc0 = playfxontag(localclientnum, level._effect["shadowman_energy_ball_explosion"], self, "tag_weapon_right");
			break;
		}
		case 6:
		{
			break;
		}
	}
}

/*
	Name: function_705b696b
	Namespace: zm_zod_quest
	Checksum: 0xFC8011A0
	Offset: 0x6698
	Size: 0x74
	Parameters: 4
	Flags: Linked
*/
function function_705b696b(localclientnum, str_fx, v_origin, n_seconds)
{
	fx_id = playfx(localclientnum, str_fx, v_origin);
	wait(n_seconds);
	stopfx(localclientnum, fx_id);
}

/*
	Name: darkportal_fx
	Namespace: zm_zod_quest
	Checksum: 0x6874AE89
	Offset: 0x6718
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function darkportal_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_267f859f(localclientnum, level._effect["darkfire_portal"], newval, 1);
}

/*
	Name: totem_state_fx
	Namespace: zm_zod_quest
	Checksum: 0x1AE26DC4
	Offset: 0x6790
	Size: 0x2AE
	Parameters: 7
	Flags: Linked
*/
function totem_state_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.sndloopid))
	{
		self stoploopsound(self.sndloopid, 0.25);
	}
	switch(newval)
	{
		case 0:
		{
			self function_267f859f(localclientnum, undefined, 0);
			break;
		}
		case 1:
		{
			self function_267f859f(localclientnum, level._effect["totem_hover"], 1, 1, "j_totem");
			break;
		}
		case 2:
		{
			self function_267f859f(localclientnum, level._effect["totem_ready"], 1, 1);
			self.sndloopid = self playloopsound("zmb_zod_totem_chargearea_glow_lp", 2);
			break;
		}
		case 3:
		{
			self function_267f859f(localclientnum, level._effect["totem_charging"], 1, 1, "j_head");
			self.sndloopid = self playloopsound("zmb_zod_totem_charging_lp", 2);
			break;
		}
		case 4:
		{
			self function_267f859f(localclientnum, level._effect["totem_charged"], 1, 1, "j_head");
			self playsound(0, "zmb_zod_totem_charged");
			self.sndloopid = self playloopsound("zmb_zod_totem_charged_lp", 2);
			break;
		}
		case 5:
		{
			self function_267f859f(localclientnum, undefined, 0);
			playfx(localclientnum, level._effect["totem_break"], self.origin);
			break;
		}
	}
}

/*
	Name: totem_damage_fx
	Namespace: zm_zod_quest
	Checksum: 0xB1A1C679
	Offset: 0x6A48
	Size: 0x146
	Parameters: 7
	Flags: Linked
*/
function totem_damage_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.var_da89d643))
	{
		level.var_de6a5ba3 = [];
	}
	if(!isdefined(level.var_de6a5ba3[newval - 1]))
	{
		level.var_de6a5ba3[newval - 1] = [];
	}
	if(newval > 0)
	{
		level.var_de6a5ba3[newval - 1][localclientnum] = playfx(localclientnum, level._effect["keeper_death"], self.origin + (0, 0, 16 * newval));
	}
	else
	{
		for(i = 0; i < level.var_de6a5ba3.size; i++)
		{
			stopfx(localclientnum, level.var_de6a5ba3[i][localclientnum]);
		}
	}
}

/*
	Name: function_1fea37a4
	Namespace: zm_zod_quest
	Checksum: 0xD6ADFB45
	Offset: 0x6B98
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function function_1fea37a4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		level thread footsteps(localclientnum, "s_left_wallrun");
	}
	else if(newval == 2)
	{
		level thread footsteps(localclientnum, "s_right_wallrun");
	}
}

/*
	Name: gateworm_basin_fx
	Namespace: zm_zod_quest
	Checksum: 0x8C050197
	Offset: 0x6C40
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function gateworm_basin_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.fx_id = playfxontag(localclientnum, level._effect["gateworm_basin_placed"], self, "tag_origin");
	}
	else if(newval == 2)
	{
		if(isdefined(self.fx_id))
		{
			stopfx(localclientnum, self.fx_id);
		}
		self.fx_id = playfxontag(localclientnum, level._effect["gateworm_basin_quest_complete"], self, "tag_origin");
	}
}

/*
	Name: footsteps
	Namespace: zm_zod_quest
	Checksum: 0x3C824622
	Offset: 0x6D48
	Size: 0x30A
	Parameters: 2
	Flags: Linked
*/
function footsteps(localclientnum, str_name)
{
	a_struct = [];
	var_8f19a67f = 10;
	for(i = 0; i < var_8f19a67f; i++)
	{
		str_struct = (str_name + "_") + i;
		a_struct[a_struct.size] = struct::get(str_struct, "targetname");
	}
	for(num_loops = 0; num_loops < 10; num_loops++)
	{
		for(i = 0; i < a_struct.size; i++)
		{
			s_inst = a_struct[i];
			if(!isdefined(s_inst.m_model))
			{
				s_inst.m_model = [];
			}
			if(!isdefined(s_inst.m_model[localclientnum]))
			{
				s_inst.m_model[localclientnum] = spawn(localclientnum, s_inst.origin, "script_model");
			}
			s_inst.m_model[localclientnum] setmodel("tag_origin");
			s_inst.m_model[localclientnum].angles = s_inst.angles;
			if(i & 1)
			{
				playfxontag(localclientnum, level._effect["footprint_r"], s_inst.m_model[localclientnum], "tag_origin");
			}
			else
			{
				playfxontag(localclientnum, level._effect["footprint_l"], s_inst.m_model[localclientnum], "tag_origin");
			}
			wait(0.1);
		}
		wait(4);
		for(i = 0; i < a_struct.size; i++)
		{
			s_inst = a_struct[i];
			if(isdefined(s_inst.m_model[localclientnum]))
			{
				s_inst.m_model[localclientnum] delete();
				s_inst.m_model[localclientnum] = undefined;
			}
		}
		wait(1);
	}
}

