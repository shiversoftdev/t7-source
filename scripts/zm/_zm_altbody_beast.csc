// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\grapple;
#using scripts\zm\_util;
#using scripts\zm\_zm_altbody;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace zm_altbody_beast;

/*
	Name: __init__sytem__
	Namespace: zm_altbody_beast
	Checksum: 0x2911AC80
	Offset: 0xA88
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_altbody_beast", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_altbody_beast
	Checksum: 0x21EAAE4
	Offset: 0xAC8
	Size: 0x41E
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!isdefined(level.bminteract))
	{
		level.bminteract = [];
	}
	clientfield::register("missile", "bminteract", 1, 2, "int", &bminteract_changed, 0, 0);
	clientfield::register("scriptmover", "bminteract", 1, 2, "int", &bminteract_changed, 0, 0);
	clientfield::register("actor", "bm_zombie_melee_kill", 1, 1, "int", &bm_zombie_melee_kill, 0, 0);
	clientfield::register("actor", "bm_zombie_grapple_kill", 1, 1, "int", &bm_zombie_grapple_kill, 0, 0);
	clientfield::register("toplayer", "beast_blood_on_player", 1, 1, "counter", &function_70f7f4d2, 0, 0);
	clientfield::register("world", "bm_superbeast", 1, 1, "int", undefined, 0, 0);
	function_10dcd1d5("beast_mode_kiosk");
	duplicate_render::set_dr_filter_offscreen("bmint", 35, "bminteract,bmplayer", undefined, 2, "mc/hud_keyline_beastmode", 0);
	zm_altbody::init("beast_mode", "beast_mode_kiosk", &"ZM_ZOD_ENTER_BEAST_MODE", "zombie_beast_2", 123, &player_enter_beastmode, &player_exit_beastmode, &function_df3032fc, &function_da014198);
	callback::on_localclient_connect(&player_on_connect);
	callback::on_spawned(&player_on_spawned);
	level._effect["beast_kiosk_fx_reset"] = "zombie/fx_bmode_kiosk_fire_reset_zod_zmb";
	level._effect["beast_kiosk_fx_enabled"] = "zombie/fx_bmode_kiosk_fire_zod_zmb";
	level._effect["beast_kiosk_fx_disabled"] = "zombie/fx_bmode_kiosk_idle_zod_zmb";
	level._effect["beast_kiosk_fx_cursed"] = "zombie/fx_bmode_kiosk_fire_tainted_zod_zmb";
	level._effect["beast_kiosk_fx_super"] = "zombie/fx_ritual_pap_basin_fire_lg_zod_zmb";
	level._effect["beast_fork"] = "zombie/fx_bmode_tent_fork_zod_zmb";
	level._effect["beast_fork_1"] = "zombie/fx_bmode_tent_charging1_zod_zmb";
	level._effect["beast_fork_2"] = "zombie/fx_bmode_tent_charging2_zod_zmb";
	level._effect["beast_fork_3"] = "zombie/fx_bmode_tent_charging3_zod_zmb";
	level._effect["beast_3p_trail"] = "zombie/fx_bmode_trail_3p_zod_zmb";
	level._effect["beast_1p_light"] = "zombie/fx_bmode_tent_light_zod_zmb";
	level._effect["beast_melee_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_grapple_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
}

/*
	Name: player_on_connect
	Namespace: zm_altbody_beast
	Checksum: 0x8323681C
	Offset: 0xEF0
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function player_on_connect(localclientnum)
{
	if(!isdefined(level.bminteract[localclientnum]))
	{
		level.bminteract[localclientnum] = [];
	}
}

/*
	Name: player_on_spawned
	Namespace: zm_altbody_beast
	Checksum: 0xE77C623F
	Offset: 0xF28
	Size: 0x13C
	Parameters: 1
	Flags: Linked
*/
function player_on_spawned(localclientnum)
{
	if(!self islocalplayer() || !isdefined(self getlocalclientnumber()) || localclientnum != self getlocalclientnumber())
	{
		return;
	}
	setbeastmodeiconmaterial(localclientnum, 1, "t7_hud_zm_beastmode_meleeattack");
	setbeastmodeiconmaterial(localclientnum, 2, "t7_hud_zm_beastmode_electricityattack");
	setbeastmodeiconmaterial(localclientnum, 3, "t7_hud_zm_beastmode_grapplehook");
	self function_62095f03(localclientnum);
	filter::init_filter_blood_spatter(self);
	self thread player_update_beast_mode_objects(localclientnum, 0);
	self oed_sitrepscan_setradius(1800);
	/#
		self thread function_ac7706bc();
	#/
}

/*
	Name: player_enter_beastmode
	Namespace: zm_altbody_beast
	Checksum: 0x76D2D048
	Offset: 0x1070
	Size: 0x2B4
	Parameters: 1
	Flags: Linked
*/
function player_enter_beastmode(localclientnum)
{
	var_84301bb1 = getnonpredictedlocalplayer(localclientnum);
	player = getlocalplayer(localclientnum);
	self.beast_mode = 1;
	self thread player_update_beast_mode_objects(localclientnum, !function_faf41e73(localclientnum));
	self thread sndbeastmode(player === var_84301bb1);
	self thread function_2a7bb7b3(localclientnum, 1);
	self thread grapple_watch(1, "tag_flash", 0.15);
	self thread function_89d6f49a(localclientnum, 1);
	self function_2d565c0(localclientnum, 0);
	function_cce7ef03(localclientnum, 1);
	scr_beast_no_visionset = 0;
	/#
		scr_beast_no_visionset = getdvarint("") > 0;
		self thread watch_scr_beast_no_visionset(localclientnum);
	#/
	if(isdemoplaying())
	{
		self thread function_cb236f81(localclientnum);
	}
	if(!scr_beast_no_visionset && !function_faf41e73(localclientnum) && player === var_84301bb1)
	{
		setpbgactivebank(localclientnum, 2);
		self thread function_56c9cf9d(localclientnum);
		self.beast_1p_light = playfxoncamera(localclientnum, level._effect["beast_1p_light"]);
	}
	/#
		if(getdvarint("") > 0)
		{
			self.beast_3p_trail = playfxontag(localclientnum, level._effect[""], self, "");
		}
	#/
}

/*
	Name: watch_scr_beast_no_visionset
	Namespace: zm_altbody_beast
	Checksum: 0xAF52451D
	Offset: 0x1330
	Size: 0x168
	Parameters: 1
	Flags: Linked
*/
function watch_scr_beast_no_visionset(localclientnum)
{
	self endon(#"beast_mode_exit");
	was_scr_beast_no_visionset = getdvarint("scr_beast_no_visionset") > 0;
	while(isdefined(self))
	{
		scr_beast_no_visionset = getdvarint("scr_beast_no_visionset") > 0;
		if(scr_beast_no_visionset != was_scr_beast_no_visionset)
		{
			if(scr_beast_no_visionset)
			{
				if(isdefined(self.beast_1p_light))
				{
					stopfx(localclientnum, self.beast_1p_light);
					self.beast_1p_light = undefined;
				}
				setpbgactivebank(localclientnum, 1);
				self thread function_ea06d888(localclientnum);
			}
			else
			{
				setpbgactivebank(localclientnum, 2);
				self thread function_56c9cf9d(localclientnum);
				self.beast_1p_light = playfxoncamera(localclientnum, level._effect["beast_1p_light"]);
			}
		}
		was_scr_beast_no_visionset = scr_beast_no_visionset;
		wait(1);
	}
}

/*
	Name: function_faf41e73
	Namespace: zm_altbody_beast
	Checksum: 0xA8290583
	Offset: 0x14A0
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function function_faf41e73(localclientnum)
{
	return isdemoplaying() && demoisanyfreemovecamera();
}

/*
	Name: function_cb236f81
	Namespace: zm_altbody_beast
	Checksum: 0x562F9096
	Offset: 0x14E0
	Size: 0x198
	Parameters: 1
	Flags: Linked
*/
function function_cb236f81(localclientnum)
{
	self endon(#"beast_mode_exit");
	if(!isdemoplaying())
	{
		return;
	}
	var_af2f137b = function_faf41e73(localclientnum);
	while(isdefined(self))
	{
		var_26495de5 = function_faf41e73(localclientnum);
		if(var_26495de5 != var_af2f137b)
		{
			if(var_26495de5)
			{
				if(isdefined(self.beast_1p_light))
				{
					stopfx(localclientnum, self.beast_1p_light);
					self.beast_1p_light = undefined;
				}
				setpbgactivebank(localclientnum, 1);
				self thread function_ea06d888(localclientnum);
			}
			else
			{
				setpbgactivebank(localclientnum, 2);
				self thread function_56c9cf9d(localclientnum);
				self.beast_1p_light = playfxoncamera(localclientnum, level._effect["beast_1p_light"]);
			}
			self thread player_update_beast_mode_objects(localclientnum, !var_26495de5);
		}
		var_af2f137b = var_26495de5;
		wait(1);
	}
}

/*
	Name: function_56c9cf9d
	Namespace: zm_altbody_beast
	Checksum: 0x3E8FC19F
	Offset: 0x1680
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_56c9cf9d(localclientnum)
{
	self thread postfx::playpostfxbundle("pstfx_zm_beast_mode_loop");
}

/*
	Name: player_exit_beastmode
	Namespace: zm_altbody_beast
	Checksum: 0xA4650177
	Offset: 0x16B8
	Size: 0x170
	Parameters: 1
	Flags: Linked
*/
function player_exit_beastmode(localclientnum)
{
	self notify(#"beast_mode_exit");
	/#
		if(isdefined(self.beast_3p_trail))
		{
			stopfx(localclientnum, self.beast_3p_trail);
			self.beast_3p_trail = undefined;
		}
	#/
	if(isdefined(self.beast_1p_light))
	{
		stopfx(localclientnum, self.beast_1p_light);
		self.beast_1p_light = undefined;
	}
	function_cce7ef03(localclientnum, 0);
	setpbgactivebank(localclientnum, 1);
	self thread function_89d6f49a(localclientnum, 0);
	self thread function_ea06d888(localclientnum);
	self thread grapple_watch(0);
	self thread player_update_beast_mode_objects(localclientnum, 0);
	self thread function_2a7bb7b3(localclientnum, 0);
	self thread sndbeastmode(0);
	self oed_sitrepscan_enable(4);
	self.beast_mode = 0;
}

/*
	Name: function_ea06d888
	Namespace: zm_altbody_beast
	Checksum: 0x13ADD9EF
	Offset: 0x1830
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_ea06d888(localclientnum)
{
	self thread postfx::exitpostfxbundle();
}

/*
	Name: function_df3032fc
	Namespace: zm_altbody_beast
	Checksum: 0x594E1169
	Offset: 0x1860
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_df3032fc(localclientnum)
{
	self.beast_3p_trail = playfxontag(localclientnum, level._effect["beast_3p_trail"], self, "j_spinelower");
	self thread grapple_watch(1, "J_Tent_Main_14_RI", 0.05);
}

/*
	Name: function_da014198
	Namespace: zm_altbody_beast
	Checksum: 0xAE109876
	Offset: 0x18D8
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function function_da014198(localclientnum)
{
	self thread grapple_watch(0);
	if(isdefined(self.beast_3p_trail))
	{
		stopfx(localclientnum, self.beast_3p_trail);
		self.beast_3p_trail = undefined;
	}
}

/*
	Name: get_script_noteworthy_array
	Namespace: zm_altbody_beast
	Checksum: 0x1213E76E
	Offset: 0x1938
	Size: 0x100
	Parameters: 3
	Flags: Linked
*/
function get_script_noteworthy_array(localclientnum, val, key)
{
	all = getentarray(localclientnum);
	ret = [];
	foreach(ent in all)
	{
		if(isdefined(ent.script_noteworthy))
		{
			if(ent.script_noteworthy === val)
			{
				ret[ret.size] = ent;
			}
		}
	}
	return ret;
}

/*
	Name: function_70f7f4d2
	Namespace: zm_altbody_beast
	Checksum: 0xCBD9FF07
	Offset: 0x1A40
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_70f7f4d2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setsoundcontext("foley", "normal");
	if(newval == 1)
	{
		self thread function_4685bc0f(localclientnum, 0.1, 3);
	}
}

/*
	Name: function_4685bc0f
	Namespace: zm_altbody_beast
	Checksum: 0xB7FF55E9
	Offset: 0x1AD8
	Size: 0xB4
	Parameters: 3
	Flags: Linked
*/
function function_4685bc0f(localclientnum, var_2646032, var_72af98b3)
{
	self endon(#"entityshutdown");
	if(isdefined(self))
	{
		filter::enable_filter_blood_spatter(self, 5);
		self thread function_ef4c8536(localclientnum, var_2646032, var_72af98b3);
		self util::waittill_any_timeout(var_2646032 + var_72af98b3, "beast_mode_exit", "entityshutdown");
		if(isdefined(self))
		{
			filter::disable_filter_blood_spatter(self, 5);
		}
	}
}

/*
	Name: function_ef4c8536
	Namespace: zm_altbody_beast
	Checksum: 0x3574E92
	Offset: 0x1B98
	Size: 0x23C
	Parameters: 3
	Flags: Linked
*/
function function_ef4c8536(localclientnum, var_2646032, var_72af98b3)
{
	self notify(#"hash_ef4c8536");
	self endon(#"hash_ef4c8536");
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	if(!isdefined(self.var_90b6339d))
	{
		self.var_90b6339d = 0;
	}
	filter::set_filter_blood_spatter_reveal(self, 5, 0, 0);
	t = 0;
	while(t <= var_2646032 && isdefined(self))
	{
		self.var_90b6339d = max(self.var_90b6339d, t / var_2646032);
		filter::set_filter_blood_spatter_reveal(self, 5, self.var_90b6339d, 0);
		wait(0.05);
		t = t + 0.05;
	}
	self.var_90b6339d = 1;
	filter::set_filter_blood_spatter_reveal(self, 5, self.var_90b6339d, 0);
	t = 0;
	while(t <= var_72af98b3 && isdefined(self))
	{
		self.var_90b6339d = min(self.var_90b6339d, 1 - (t / var_72af98b3));
		filter::set_filter_blood_spatter_reveal(self, 5, self.var_90b6339d, 0);
		wait(0.05);
		t = t + 0.05;
	}
	self.var_90b6339d = 0;
	filter::set_filter_blood_spatter_reveal(self, 5, self.var_90b6339d, 0);
}

/*
	Name: function_cce7ef03
	Namespace: zm_altbody_beast
	Checksum: 0x96B4F06C
	Offset: 0x1DE0
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function function_cce7ef03(localclientnum, onoff)
{
	if(getdvarint("splitscreen_playerCount") == 2)
	{
		var_b401f607 = getdvarint("scr_num_in_beast");
		if(onoff)
		{
			var_b401f607++;
			setdvar("cg_focalLength", 21);
		}
		else
		{
			var_b401f607--;
			if(var_b401f607 == 0)
			{
				setdvar("cg_focalLength", 14.64);
			}
		}
		setdvar("scr_num_in_beast", var_b401f607);
	}
}

/*
	Name: player_update_beast_mode_objects
	Namespace: zm_altbody_beast
	Checksum: 0xA0C18453
	Offset: 0x1EC8
	Size: 0x134
	Parameters: 2
	Flags: Linked
*/
function player_update_beast_mode_objects(localclientnum, onoff)
{
	bmo = get_script_noteworthy_array(localclientnum, "beast_mode", "script_noteworthy");
	array::run_all(bmo, &entity_set_visible, localclientnum, self, onoff);
	bmho = get_script_noteworthy_array(localclientnum, "not_beast_mode", "script_noteworthy");
	array::run_all(bmho, &entity_set_visible, localclientnum, self, !onoff);
	wait(0.016);
	clean_deleted(level.bminteract[localclientnum]);
	array::run_all(level.bminteract[localclientnum], &entity_set_bmplayer, localclientnum, onoff);
}

/*
	Name: entity_set_bmplayer
	Namespace: zm_altbody_beast
	Checksum: 0x5225610A
	Offset: 0x2008
	Size: 0x16C
	Parameters: 2
	Flags: Linked
*/
function entity_set_bmplayer(localclientnum, onoff)
{
	if(!isdefined(self.var_2a7bb7b3))
	{
		self.var_2a7bb7b3 = [];
	}
	if(isdefined(self.var_2a7bb7b3[localclientnum]))
	{
		stopfx(localclientnum, self.var_2a7bb7b3[localclientnum]);
		self.var_2a7bb7b3[localclientnum] = undefined;
	}
	if(isdefined(self.model))
	{
		if(onoff)
		{
			fx = function_d9f5b74d(self.model);
		}
		else
		{
			fx = function_f74ecbae(self.model);
		}
		if(isdefined(fx))
		{
			self.var_2a7bb7b3[localclientnum] = playfxontag(localclientnum, fx, self, "tag_origin");
		}
	}
	if(!issplitscreen() && !isdemoplaying())
	{
		self duplicate_render::set_dr_flag("bmplayer", onoff);
		self duplicate_render::update_dr_filters(localclientnum);
	}
}

/*
	Name: function_d9f5b74d
	Namespace: zm_altbody_beast
	Checksum: 0x726560EE
	Offset: 0x2180
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function function_d9f5b74d(modelname)
{
	switch(modelname)
	{
		case "p7_zm_zod_beast_gargoyle":
		{
			return "zombie/fx_bmode_glow_hook_zod_zmb";
		}
		case "p7_zm_zod_power_box_yellow":
		{
			return "zombie/fx_bmode_glow_pwrbox_zod_zmb";
		}
		case "p7_fxanim_zm_zod_beast_door_mod":
		{
			return "zombie/fx_bmode_glow_door_zod_zmb";
		}
		case "p7_zm_zod_crate_breakable_03":
		{
			return "zombie/fx_bmode_glow_crate_zod_zmb";
		}
		case "p7_fxanim_zm_zod_crate_breakable_03_mod":
		{
			return "zombie/fx_bmode_glow_crate_zod_zmb";
		}
		case "p7_fxanim_zm_zod_crate_breakable_01_mod":
		{
			return "zombie/fx_bmode_glow_crate_tall_zod_zmb";
		}
	}
	return undefined;
}

/*
	Name: function_f74ecbae
	Namespace: zm_altbody_beast
	Checksum: 0xFF139AC7
	Offset: 0x2208
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_f74ecbae(modelname)
{
	switch(modelname)
	{
		case "p7_zm_zod_beast_gargoyle":
		{
			return "zombie/fx_bmode_glint_hook_zod_zmb";
		}
	}
	return undefined;
}

/*
	Name: entity_set_visible
	Namespace: zm_altbody_beast
	Checksum: 0xA29A5215
	Offset: 0x2240
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function entity_set_visible(localclientnum, player, onoff)
{
	if(onoff)
	{
		self show();
	}
	else
	{
		self hide();
	}
}

/*
	Name: add_remove_list
	Namespace: zm_altbody_beast
	Checksum: 0x59747A3A
	Offset: 0x22A0
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function add_remove_list(&a = [], on_off)
{
	if(on_off)
	{
		if(!isinarray(a, self))
		{
			arrayinsert(a, self, a.size);
		}
	}
	else
	{
		arrayremovevalue(a, self, 0);
	}
}

/*
	Name: clean_deleted
	Namespace: zm_altbody_beast
	Checksum: 0x96643789
	Offset: 0x2330
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function clean_deleted(&array)
{
	done = 0;
	while(!done && array.size > 0)
	{
		done = 1;
		foreach(key, val in array)
		{
			if(!isdefined(val))
			{
				arrayremoveindex(array, key, 0);
				done = 0;
				break;
			}
		}
	}
}

/*
	Name: function_7d675424
	Namespace: zm_altbody_beast
	Checksum: 0x69F457D7
	Offset: 0x2420
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function function_7d675424(type)
{
	if(type == 2)
	{
		up = anglestoup(self.angles);
		forward = anglestoforward(self.angles);
		location = self.origin + (12 * forward);
		return location;
	}
	return undefined;
}

/*
	Name: bminteract_changed
	Namespace: zm_altbody_beast
	Checksum: 0x5BDEDEDC
	Offset: 0x24B8
	Size: 0x22C
	Parameters: 7
	Flags: Linked
*/
function bminteract_changed(local_client_num, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	onoff = newval != 0;
	location = self function_7d675424(newval);
	if(isdefined(location))
	{
		self setentbeastmodeicontype(newval, location);
	}
	else
	{
		self setentbeastmodeicontype(newval);
	}
	self add_remove_list(level.bminteract[local_client_num], onoff);
	if(!issplitscreen())
	{
		self duplicate_render::set_dr_flag("bmplayer", isdefined(getlocalplayer(local_client_num).beast_mode) && getlocalplayer(local_client_num).beast_mode);
	}
	if(onoff)
	{
		self duplicate_render::set_dr_flag("bminteract", onoff);
		self duplicate_render::update_dr_filters(local_client_num);
	}
	else
	{
		if(!isdefined(self.var_2a7bb7b3))
		{
			self.var_2a7bb7b3 = [];
		}
		if(isdefined(self.var_2a7bb7b3[local_client_num]))
		{
			stopfx(local_client_num, self.var_2a7bb7b3[local_client_num]);
			self.var_2a7bb7b3[local_client_num] = undefined;
		}
		if(isdefined(self.currentdrfilter))
		{
			self duplicate_render::set_dr_flag("bminteract", onoff);
			self duplicate_render::update_dr_filters(local_client_num);
		}
	}
}

/*
	Name: function_10dcd1d5
	Namespace: zm_altbody_beast
	Checksum: 0x3B840A5A
	Offset: 0x26F0
	Size: 0x1DA
	Parameters: 1
	Flags: Linked
*/
function function_10dcd1d5(kiosk_name)
{
	level.beast_kiosks = struct::get_array(kiosk_name, "targetname");
	level.var_dc56ce87 = [];
	level.var_104eabe = [];
	foreach(kiosk in level.beast_kiosks)
	{
		if(!isdefined(kiosk.state))
		{
			kiosk.state = [];
		}
		if(!isdefined(kiosk.fake_ent))
		{
			kiosk.fake_ent = [];
		}
		kiosk.var_80eeb471 = (kiosk_name + "_plr_") + kiosk.origin;
		kiosk.var_39a60f4a = (kiosk_name + "_crs_") + kiosk.origin;
		level.var_dc56ce87[kiosk.var_80eeb471] = kiosk;
		level.var_104eabe[kiosk.var_39a60f4a] = kiosk;
		clientfield::register("world", kiosk.var_80eeb471, 1, 4, "int", &function_fa828651, 0, 0);
	}
}

/*
	Name: function_62095f03
	Namespace: zm_altbody_beast
	Checksum: 0xFF86EFD0
	Offset: 0x28D8
	Size: 0x1A2
	Parameters: 1
	Flags: Linked
*/
function function_62095f03(localclientnum)
{
	foreach(kiosk in level.beast_kiosks)
	{
		if(!isdefined(kiosk.state))
		{
			kiosk.state = [];
		}
		if(!isdefined(kiosk.fake_ent))
		{
			kiosk.fake_ent = [];
		}
		if(!isdefined(kiosk.fake_ent[localclientnum]))
		{
			kiosk.fake_ent[localclientnum] = util::spawn_model(localclientnum, "tag_origin", kiosk.origin, kiosk.angles);
			if(isdefined(kiosk.state[localclientnum]))
			{
				kiosk.fake_ent[localclientnum] update_kiosk_state(localclientnum, kiosk.state[localclientnum], kiosk.state[localclientnum], 1, 0, kiosk.var_80eeb471, 0);
			}
		}
	}
}

/*
	Name: function_fa828651
	Namespace: zm_altbody_beast
	Checksum: 0x353B920E
	Offset: 0x2A88
	Size: 0x11C
	Parameters: 7
	Flags: Linked
*/
function function_fa828651(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	kiosk = level.var_dc56ce87[fieldname];
	if(isdefined(kiosk))
	{
		if(!isdefined(kiosk.state))
		{
			kiosk.state = [];
		}
		if(!isdefined(kiosk.fake_ent))
		{
			kiosk.fake_ent = [];
		}
		kiosk.state[localclientnum] = newval;
		if(isdefined(kiosk.fake_ent[localclientnum]))
		{
			kiosk.fake_ent[localclientnum] update_kiosk_state(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
		}
	}
}

/*
	Name: update_kiosk_state
	Namespace: zm_altbody_beast
	Checksum: 0x7580E43
	Offset: 0x2BB0
	Size: 0x334
	Parameters: 7
	Flags: Linked
*/
function update_kiosk_state(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	n_entnum = player getentitynumber();
	if(!isdefined(self.beast_kiosk_fx))
	{
		self.beast_kiosk_fx = [];
	}
	if(!isdefined(self.beast_kiosk_fx[localclientnum]))
	{
		self.beast_kiosk_fx[localclientnum] = [];
	}
	if(newval & (1 << n_entnum))
	{
		if(isdefined(self.beast_kiosk_fx[localclientnum]["disabled"]))
		{
			stopfx(localclientnum, self.beast_kiosk_fx[localclientnum]["disabled"]);
			self.beast_kiosk_fx[localclientnum]["disabled"] = undefined;
		}
		if(!isdefined(self.beast_kiosk_fx[localclientnum]["enabled"]))
		{
			playfxontag(localclientnum, level._effect["beast_kiosk_fx_reset"], self, "tag_origin");
			playsound(0, "evt_beastmode_torch_ignite", self.origin);
			if(level clientfield::get("bm_superbeast"))
			{
				self.beast_kiosk_fx[localclientnum]["enabled"] = playfxontag(localclientnum, level._effect["beast_kiosk_fx_super"], self, "tag_origin");
			}
			else
			{
				self.beast_kiosk_fx[localclientnum]["enabled"] = playfxontag(localclientnum, level._effect["beast_kiosk_fx_enabled"], self, "tag_origin");
			}
		}
	}
	else
	{
		if(isdefined(self.beast_kiosk_fx[localclientnum]["enabled"]))
		{
			stopfx(localclientnum, self.beast_kiosk_fx[localclientnum]["enabled"]);
			self.beast_kiosk_fx[localclientnum]["enabled"] = undefined;
		}
		if(!isdefined(self.beast_kiosk_fx[localclientnum]["disabled"]))
		{
			self.beast_kiosk_fx[localclientnum]["disabled"] = playfxontag(localclientnum, level._effect["beast_kiosk_fx_disabled"], self, "tag_origin");
		}
	}
}

/*
	Name: function_5e873a4e
	Namespace: zm_altbody_beast
	Checksum: 0xF71CF6CD
	Offset: 0x2EF0
	Size: 0x9C
	Parameters: 7
	Flags: None
*/
function function_5e873a4e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	kiosk = level.var_104eabe[fieldname];
	if(isdefined(kiosk))
	{
		kiosk.fake_ent function_e97fecd7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
	}
}

/*
	Name: function_e97fecd7
	Namespace: zm_altbody_beast
	Checksum: 0xBA005EDB
	Offset: 0x2F98
	Size: 0x15C
	Parameters: 7
	Flags: Linked
*/
function function_e97fecd7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	if(!isdefined(self.beast_kiosk_fx))
	{
		self.beast_kiosk_fx = [];
	}
	if(!isdefined(self.beast_kiosk_fx[localclientnum]))
	{
		self.beast_kiosk_fx[localclientnum] = [];
	}
	if(newval)
	{
		if(!isdefined(self.beast_kiosk_fx[localclientnum]["denied"]))
		{
			self.beast_kiosk_fx[localclientnum]["denied"] = playfxontag(localclientnum, level._effect["beast_kiosk_fx_cursed"], self, "tag_origin");
		}
	}
	else if(isdefined(self.beast_kiosk_fx[localclientnum]["denied"]))
	{
		stopfx(localclientnum, self.beast_kiosk_fx[localclientnum]["denied"]);
	}
}

/*
	Name: sndbeastmode
	Namespace: zm_altbody_beast
	Checksum: 0x280E7A3D
	Offset: 0x3100
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function sndbeastmode(activate)
{
	if(activate)
	{
		forceambientroom("zm_zod_beastmode");
		self thread sndbeastmode_manastart();
	}
	else
	{
		forceambientroom("");
		self thread sndbeastmode_manastop();
	}
}

/*
	Name: sndbeastmode_manastart
	Namespace: zm_altbody_beast
	Checksum: 0x3C2397F0
	Offset: 0x3188
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function sndbeastmode_manastart()
{
	level endon(#"sndmanastop");
	self endon(#"entityshutdown");
	if(!isdefined(level.sndbeastmodeent))
	{
		level.sndbeastmodeent = spawn(0, (0, 0, 0), "script_origin");
		soundid = level.sndbeastmodeent playloopsound("zmb_beastmode_mana_looper", 2);
		setsoundvolume(soundid, 0);
	}
	while(true)
	{
		if(isdefined(self.mana))
		{
			if(self.mana <= 0.5)
			{
				volume = 0.51 - self.mana;
				if(isdefined(soundid))
				{
					setsoundvolume(soundid, volume);
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: sndbeastmode_manastop
	Namespace: zm_altbody_beast
	Checksum: 0x12619A13
	Offset: 0x32A8
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function sndbeastmode_manastop()
{
	level notify(#"sndmanastop");
	if(isdefined(level.sndbeastmodeent))
	{
		level.sndbeastmodeent delete();
		level.sndbeastmodeent = undefined;
	}
}

/*
	Name: function_14637ad2
	Namespace: zm_altbody_beast
	Checksum: 0xEB78A48D
	Offset: 0x32F8
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function function_14637ad2(localclientnum)
{
	if(isdefined(self.var_a4e22c06))
	{
		stopfx(localclientnum, self.var_a4e22c06);
		self.var_a4e22c06 = undefined;
	}
}

/*
	Name: function_2a7bb7b3
	Namespace: zm_altbody_beast
	Checksum: 0xBDD54BDC
	Offset: 0x3340
	Size: 0x1F8
	Parameters: 2
	Flags: Linked
*/
function function_2a7bb7b3(localclientnum, on_off)
{
	self notify(#"hash_2a7bb7b3");
	self endon(#"hash_2a7bb7b3");
	function_14637ad2(localclientnum);
	if(on_off)
	{
		while(isdefined(self))
		{
			level waittill(#"notetrack", lcn, note);
			if(note == "shock_loop")
			{
				function_14637ad2(localclientnum);
				charge = getweaponchargelevel(localclientnum);
				switch(charge)
				{
					case 2:
					{
						self.var_a4e22c06 = playviewmodelfx(localclientnum, level._effect["beast_fork_2"], "tag_flash_le");
						break;
					}
					case 3:
					{
						self.var_a4e22c06 = playviewmodelfx(localclientnum, level._effect["beast_fork_3"], "tag_flash_le");
						break;
					}
					case 1:
					default:
					{
						self.var_a4e22c06 = playviewmodelfx(localclientnum, level._effect["beast_fork_1"], "tag_flash_le");
						break;
					}
				}
				self function_2d565c0(localclientnum, charge);
			}
			else if(note == "shock_loop_end")
			{
				function_14637ad2(localclientnum);
			}
		}
	}
}

/*
	Name: function_2d565c0
	Namespace: zm_altbody_beast
	Checksum: 0x54DFA2E9
	Offset: 0x3540
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function function_2d565c0(localclientnum, charge)
{
	time = 0.85;
	var_c6eef0d = 0;
	var_49d2fa23 = 1;
	switch(charge)
	{
		default:
		{
			time = 2;
			break;
		}
		case 1:
		{
			time = 0.5;
			break;
		}
		case 2:
		{
			time = 0.25;
			break;
		}
		case 3:
		{
			time = 0.15;
			break;
		}
	}
	self thread function_892cc334(localclientnum, time, var_c6eef0d, var_49d2fa23, charge);
}

/*
	Name: function_892cc334
	Namespace: zm_altbody_beast
	Checksum: 0x76FEC9A1
	Offset: 0x3638
	Size: 0x160
	Parameters: 5
	Flags: Linked
*/
function function_892cc334(localclientnum, time, var_c6eef0d, var_49d2fa23, charge)
{
	self notify(#"hash_892cc334");
	self endon(#"hash_892cc334");
	self endon(#"beast_mode_exit");
	if(!isdefined(self.var_652e98))
	{
		self.var_652e98 = 0;
	}
	while(isdefined(self))
	{
		self.var_652e98 = self.var_652e98 + 0.016;
		if(self.var_652e98 > time)
		{
			self.var_652e98 = self.var_652e98 - time;
		}
		val = lerpfloat(var_c6eef0d, var_49d2fa23, self.var_652e98 / time);
		self setarmpulseposition(val);
		if(charge != getweaponchargelevel(localclientnum))
		{
			self function_2d565c0(localclientnum, getweaponchargelevel(localclientnum));
		}
		wait(0.016);
	}
}

/*
	Name: function_ac7706bc
	Namespace: zm_altbody_beast
	Checksum: 0xBB7B6D6B
	Offset: 0x37A0
	Size: 0x2DC
	Parameters: 0
	Flags: Linked
*/
function function_ac7706bc()
{
	/#
		self notify(#"hash_ac7706bc");
		self endon(#"hash_ac7706bc");
		if(!isdefined(self.var_652e98))
		{
			self.var_652e98 = 0;
		}
		while(isdefined(self))
		{
			if(getdvarint("") > 0)
			{
				self notify(#"hash_892cc334");
				time = getdvarfloat("");
				speed = getdvarfloat("");
				pulse = getdvarfloat("");
				if(time > 0)
				{
					self setarmpulse(time, speed, pulse, "");
					wait(time);
				}
				else
				{
					wait(0.016);
				}
			}
			else
			{
				if(getdvarint("") > 0)
				{
					self notify(#"hash_892cc334");
					pos = getdvarfloat("");
					self setarmpulseposition(pos);
					wait(0.016);
				}
				else
				{
					if(getdvarint("") > 0)
					{
						self notify(#"hash_892cc334");
						time = getdvarfloat("");
						var_c6eef0d = getdvarfloat("");
						var_49d2fa23 = getdvarfloat("");
						self.var_652e98 = self.var_652e98 + 0.016;
						if(self.var_652e98 > time)
						{
							self.var_652e98 = self.var_652e98 - time;
						}
						val = lerpfloat(var_c6eef0d, var_49d2fa23, self.var_652e98 / time);
						self setarmpulseposition(val);
						wait(0.016);
					}
					else
					{
						wait(0.016);
					}
				}
			}
		}
	#/
}

/*
	Name: function_55af4b5b
	Namespace: zm_altbody_beast
	Checksum: 0xC2CBFF8D
	Offset: 0x3A88
	Size: 0x54
	Parameters: 4
	Flags: Linked
*/
function function_55af4b5b(player, tag, pivot, delay)
{
	player endon(#"grapple_done");
	wait(delay);
	thread grapple_beam(player, tag, pivot);
}

/*
	Name: grapple_beam
	Namespace: zm_altbody_beast
	Checksum: 0xF46C7C5B
	Offset: 0x3AE8
	Size: 0x8C
	Parameters: 3
	Flags: Linked
*/
function grapple_beam(player, tag, pivot)
{
	level beam::launch(player, tag, pivot, "tag_origin", "zod_beast_grapple_beam");
	player waittill(#"grapple_done");
	level beam::kill(player, tag, pivot, "tag_origin", "zod_beast_grapple_beam");
}

/*
	Name: grapple_watch
	Namespace: zm_altbody_beast
	Checksum: 0x1062B659
	Offset: 0x3B80
	Size: 0x19A
	Parameters: 3
	Flags: Linked
*/
function grapple_watch(onoff, tag = "tag_flash", delay = 0.15)
{
	self notify(#"grapple_done");
	self notify(#"grapple_watch");
	self endon(#"grapple_watch");
	if(onoff)
	{
		while(isdefined(self))
		{
			self waittill(#"grapple_beam_on", pivot);
			var_1e66ebb1 = tag;
			/#
				if(getdvarint("") > 0)
				{
					var_1e66ebb1 = "";
				}
			#/
			if(isdefined(pivot) && !pivot isplayer())
			{
				thread function_55af4b5b(self, var_1e66ebb1, pivot, delay);
			}
			evt = self util::waittill_any_ex(7.5, "grapple_pulled", "grapple_landed", "grapple_cancel", "grapple_beam_off", "grapple_watch", "disconnect");
			self notify(#"grapple_done");
		}
	}
}

/*
	Name: function_4778b020
	Namespace: zm_altbody_beast
	Checksum: 0x4780DD3A
	Offset: 0x3D28
	Size: 0x96
	Parameters: 2
	Flags: Linked
*/
function function_4778b020(lo, hi)
{
	color = (randomfloatrange(lo[0], hi[0]), randomfloatrange(lo[1], hi[1]), randomfloatrange(lo[2], hi[2]));
	return color;
}

/*
	Name: function_4b2bbece
	Namespace: zm_altbody_beast
	Checksum: 0x3CFEDAC2
	Offset: 0x3DC8
	Size: 0xAA
	Parameters: 3
	Flags: Linked
*/
function function_4b2bbece(var_3ae5c24, var_1bfa7cb7, frac)
{
	frac0 = 1 - frac;
	color = ((frac0 * var_3ae5c24[0]) + (frac * var_1bfa7cb7[0]), (frac0 * var_3ae5c24[1]) + (frac * var_1bfa7cb7[1]), (frac0 * var_3ae5c24[2]) + (frac * var_1bfa7cb7[2]));
	return color;
}

/*
	Name: function_89d6f49a
	Namespace: zm_altbody_beast
	Checksum: 0xEE1F3FD6
	Offset: 0x3E80
	Size: 0x1E2
	Parameters: 2
	Flags: Linked
*/
function function_89d6f49a(localclientnum, onoff)
{
	self notify(#"hash_89d6f49a");
	self endon(#"hash_89d6f49a");
	if(!onoff)
	{
		self setcontrollerlightbarcolor(localclientnum);
		self.controllercolor = undefined;
		return;
	}
	if(isdemoplaying())
	{
		return;
	}
	var_781fc232 = (63, 103, 4) / 255;
	var_27745be8 = (105, 148, 24) / 255;
	var_d7805253 = 2;
	var_ec055171 = 0.25;
	cycle_time = var_d7805253;
	old_color = function_4778b020(var_781fc232, var_27745be8);
	new_color = old_color;
	while(isdefined(self))
	{
		if(cycle_time >= var_d7805253)
		{
			old_color = new_color;
			new_color = function_4778b020(var_781fc232, var_27745be8);
			cycle_time = 0;
		}
		color = function_4b2bbece(old_color, new_color, cycle_time / var_d7805253);
		self setcontrollerlightbarcolor(localclientnum, color);
		self.controllercolor = color;
		cycle_time = cycle_time + var_ec055171;
		wait(var_ec055171);
	}
}

/*
	Name: bm_zombie_melee_kill
	Namespace: zm_altbody_beast
	Checksum: 0x8404D992
	Offset: 0x4070
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function bm_zombie_melee_kill(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(util::is_mature() && !util::is_gib_restricted_build())
	{
		playfxontag(localclientnum, level._effect["beast_melee_kill"], self, "j_spineupper");
	}
}

/*
	Name: bm_zombie_grapple_kill
	Namespace: zm_altbody_beast
	Checksum: 0x2DF04B7A
	Offset: 0x4118
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function bm_zombie_grapple_kill(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(util::is_mature() && !util::is_gib_restricted_build())
	{
		playfxontag(localclientnum, level._effect["beast_grapple_kill"], self, "j_spineupper");
	}
}

