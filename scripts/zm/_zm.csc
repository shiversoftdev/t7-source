// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_sticky_grenade;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_demo;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_ffotd;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerup_bonus_points_player;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zdraw;
#using scripts\zm\aats\_zm_aat_blast_furnace;
#using scripts\zm\aats\_zm_aat_dead_wire;
#using scripts\zm\aats\_zm_aat_fire_works;
#using scripts\zm\aats\_zm_aat_thunder_wall;
#using scripts\zm\aats\_zm_aat_turned;
#using scripts\zm\bgbs\_zm_bgb_aftertaste;
#using scripts\zm\bgbs\_zm_bgb_alchemical_antithesis;
#using scripts\zm\bgbs\_zm_bgb_always_done_swiftly;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\bgbs\_zm_bgb_armamental_accomplishment;
#using scripts\zm\bgbs\_zm_bgb_arms_grace;
#using scripts\zm\bgbs\_zm_bgb_arsenal_accelerator;
#using scripts\zm\bgbs\_zm_bgb_board_games;
#using scripts\zm\bgbs\_zm_bgb_board_to_death;
#using scripts\zm\bgbs\_zm_bgb_bullet_boost;
#using scripts\zm\bgbs\_zm_bgb_burned_out;
#using scripts\zm\bgbs\_zm_bgb_cache_back;
#using scripts\zm\bgbs\_zm_bgb_coagulant;
#using scripts\zm\bgbs\_zm_bgb_crate_power;
#using scripts\zm\bgbs\_zm_bgb_crawl_space;
#using scripts\zm\bgbs\_zm_bgb_danger_closest;
#using scripts\zm\bgbs\_zm_bgb_dead_of_nuclear_winter;
#using scripts\zm\bgbs\_zm_bgb_disorderly_combat;
#using scripts\zm\bgbs\_zm_bgb_ephemeral_enhancement;
#using scripts\zm\bgbs\_zm_bgb_extra_credit;
#using scripts\zm\bgbs\_zm_bgb_eye_candy;
#using scripts\zm\bgbs\_zm_bgb_fatal_contraption;
#using scripts\zm\bgbs\_zm_bgb_fear_in_headlights;
#using scripts\zm\bgbs\_zm_bgb_firing_on_all_cylinders;
#using scripts\zm\bgbs\_zm_bgb_flavor_hexed;
#using scripts\zm\bgbs\_zm_bgb_head_drama;
#using scripts\zm\bgbs\_zm_bgb_idle_eyes;
#using scripts\zm\bgbs\_zm_bgb_im_feelin_lucky;
#using scripts\zm\bgbs\_zm_bgb_immolation_liquidation;
#using scripts\zm\bgbs\_zm_bgb_impatient;
#using scripts\zm\bgbs\_zm_bgb_in_plain_sight;
#using scripts\zm\bgbs\_zm_bgb_kill_joy;
#using scripts\zm\bgbs\_zm_bgb_killing_time;
#using scripts\zm\bgbs\_zm_bgb_licensed_contractor;
#using scripts\zm\bgbs\_zm_bgb_lucky_crit;
#using scripts\zm\bgbs\_zm_bgb_mind_blown;
#using scripts\zm\bgbs\_zm_bgb_near_death_experience;
#using scripts\zm\bgbs\_zm_bgb_newtonian_negation;
#using scripts\zm\bgbs\_zm_bgb_now_you_see_me;
#using scripts\zm\bgbs\_zm_bgb_on_the_house;
#using scripts\zm\bgbs\_zm_bgb_perkaholic;
#using scripts\zm\bgbs\_zm_bgb_phoenix_up;
#using scripts\zm\bgbs\_zm_bgb_pop_shocks;
#using scripts\zm\bgbs\_zm_bgb_power_vacuum;
#using scripts\zm\bgbs\_zm_bgb_profit_sharing;
#using scripts\zm\bgbs\_zm_bgb_projectile_vomiting;
#using scripts\zm\bgbs\_zm_bgb_reign_drops;
#using scripts\zm\bgbs\_zm_bgb_respin_cycle;
#using scripts\zm\bgbs\_zm_bgb_round_robbin;
#using scripts\zm\bgbs\_zm_bgb_secret_shopper;
#using scripts\zm\bgbs\_zm_bgb_self_medication;
#using scripts\zm\bgbs\_zm_bgb_shopping_free;
#using scripts\zm\bgbs\_zm_bgb_slaughter_slide;
#using scripts\zm\bgbs\_zm_bgb_soda_fountain;
#using scripts\zm\bgbs\_zm_bgb_stock_option;
#using scripts\zm\bgbs\_zm_bgb_sword_flay;
#using scripts\zm\bgbs\_zm_bgb_temporal_gift;
#using scripts\zm\bgbs\_zm_bgb_tone_death;
#using scripts\zm\bgbs\_zm_bgb_unbearable;
#using scripts\zm\bgbs\_zm_bgb_undead_man_walking;
#using scripts\zm\bgbs\_zm_bgb_unquenchable;
#using scripts\zm\bgbs\_zm_bgb_wall_power;
#using scripts\zm\bgbs\_zm_bgb_whos_keeping_score;

#namespace zm;

/*
	Name: ignore_systems
	Namespace: zm
	Checksum: 0x74C9E6E2
	Offset: 0x1900
	Size: 0x3B4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec ignore_systems()
{
	system::ignore("gadget_clone");
	system::ignore("gadget_heat_wave");
	system::ignore("gadget_resurrect");
	system::ignore("gadget_shock_field");
	system::ignore("gadget_es_strike");
	system::ignore("gadget_misdirection");
	system::ignore("gadget_smokescreen");
	system::ignore("gadget_firefly_swarm");
	system::ignore("gadget_immolation");
	system::ignore("gadget_forced_malfunction");
	system::ignore("gadget_sensory_overload");
	system::ignore("gadget_rapid_strike");
	system::ignore("gadget_camo_render");
	system::ignore("gadget_unstoppable_force");
	system::ignore("gadget_overdrive");
	system::ignore("gadget_concussive_wave");
	system::ignore("gadget_ravage_core");
	system::ignore("gadget_cacophany");
	system::ignore("gadget_iff_override");
	system::ignore("gadget_security_breach");
	system::ignore("gadget_surge");
	system::ignore("gadget_exo_breakdown");
	system::ignore("gadget_servo_shortout");
	system::ignore("gadget_system_overload");
	system::ignore("gadget_cleanse");
	system::ignore("gadget_flashback");
	system::ignore("gadget_combat_efficiency");
	system::ignore("gadget_other");
	system::ignore("gadget_vision_pulse");
	system::ignore("gadget_camo");
	system::ignore("gadget_speed_burst");
	system::ignore("gadget_armor");
	system::ignore("gadget_thief");
	system::ignore("replay_gun");
	system::ignore("spike_charge_siegebot");
	system::ignore("end_game_taunts");
	if(getdvarint("splitscreen_playerCount") > 2)
	{
		system::ignore("footsteps");
		system::ignore("ambient");
	}
}

/*
	Name: init
	Namespace: zm
	Checksum: 0x30EFBC66
	Offset: 0x1CC0
	Size: 0x3F4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	/#
		println("");
	#/
	level thread zm_ffotd::main_start();
	level.onlinegame = sessionmodeisonlinegame();
	level.swimmingfeature = 0;
	level.scr_zm_ui_gametype = getdvarstring("ui_gametype");
	level.scr_zm_map_start_location = "";
	level.gamedifficulty = getgametypesetting("zmDifficulty");
	level.enable_magic = getgametypesetting("magic");
	level.headshots_only = getgametypesetting("headshotsonly");
	level.disable_equipment_team_object = 1;
	util::register_system("lsm", &last_stand_monitor);
	level.clientvoicesetup = &zm_audio::clientvoicesetup;
	level.playerfalldamagesound = &zm_audio::playerfalldamagesound;
	/#
		println("");
	#/
	init_clientfields();
	zm_perks::init();
	zm_powerups::init();
	zm_weapons::init();
	init_blocker_fx();
	init_riser_fx();
	init_zombie_explode_fx();
	level.gibresettime = 0.5;
	level.gibmaxcount = 3;
	level.gibtimer = 0;
	level.gibcount = 0;
	level._gibeventcbfunc = &on_gib_event;
	level thread resetgibcounter();
	level thread zpo_listener();
	level thread zpoff_listener();
	level._box_indicator_no_lights = -1;
	level._box_indicator_flash_lights_moving = 99;
	level._box_indicator = level._box_indicator_no_lights;
	util::register_system("box_indicator", &box_monitor);
	level._zombie_gib_piece_index_all = 0;
	level._zombie_gib_piece_index_right_arm = 1;
	level._zombie_gib_piece_index_left_arm = 2;
	level._zombie_gib_piece_index_right_leg = 3;
	level._zombie_gib_piece_index_left_leg = 4;
	level._zombie_gib_piece_index_head = 5;
	level._zombie_gib_piece_index_guts = 6;
	level._zombie_gib_piece_index_hat = 7;
	callback::add_callback(#"hash_da8d7d74", &basic_player_connect);
	callback::on_spawned(&player_duplicaterender);
	callback::on_spawned(&player_umbrahotfixes);
	level.update_aat_hud = &update_aat_hud;
	if(isdefined(level.setupcustomcharacterexerts))
	{
		[[level.setupcustomcharacterexerts]]();
	}
	level thread zm_ffotd::main_end();
	/#
		level thread function_9fee0219();
	#/
}

/*
	Name: delay_for_clients_then_execute
	Namespace: zm
	Checksum: 0xBE7CC57B
	Offset: 0x20C0
	Size: 0x96
	Parameters: 1
	Flags: None
*/
function delay_for_clients_then_execute(func)
{
	wait(0.1);
	players = getlocalplayers();
	for(x = 0; x < players.size; x++)
	{
		while(!clienthassnapshot(x))
		{
			wait(0.05);
		}
	}
	wait(0.1);
	level thread [[func]]();
}

/*
	Name: function_9fee0219
	Namespace: zm
	Checksum: 0xBDF70B76
	Offset: 0x2160
	Size: 0x1B6
	Parameters: 0
	Flags: Linked
*/
function function_9fee0219()
{
	/#
		wait(0.1);
		players = getlocalplayers();
		for(x = 0; x < players.size; x++)
		{
			while(!clienthassnapshot(x))
			{
				wait(0.05);
			}
		}
		wait(0.1);
		if(!isdefined(level.var_478e3c32))
		{
			level.var_478e3c32 = [];
		}
		var_d38a76f6 = 0;
		while(true)
		{
			dvar_value = getdvarint("");
			if(dvar_value != var_d38a76f6)
			{
				players = level.var_478e3c32;
				foreach(player in players)
				{
					player duplicate_render::set_dr_flag("", !dvar_value);
					player duplicate_render::update_dr_filters(0);
				}
			}
			var_d38a76f6 = dvar_value;
			wait(1);
		}
	#/
}

/*
	Name: init_duplicaterender_settings
	Namespace: zm
	Checksum: 0x3B978554
	Offset: 0x2320
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function init_duplicaterender_settings()
{
	self oed_sitrepscan_enable(4);
	self oed_sitrepscan_setoutline(1);
	self oed_sitrepscan_setlinewidth(2);
	self oed_sitrepscan_setsolid(1);
	self oed_sitrepscan_setradius(800);
	self oed_sitrepscan_setfalloff(0.1);
	duplicate_render::set_dr_filter_offscreen("player_keyline", 25, "keyline_active", "keyline_disabled", 2, "mc/hud_keyline_zm_player", 1);
	duplicate_render::set_dr_filter_offscreen("player_keyline_ls", 30, "keyline_active,keyline_ls", "keyline_disabled", 2, "mc/hud_keyline_zm_player_ls", 1);
}

/*
	Name: player_duplicaterender
	Namespace: zm
	Checksum: 0x269E5211
	Offset: 0x2448
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function player_duplicaterender(localclientnum)
{
	/#
		if(!isdefined(level.var_478e3c32))
		{
			level.var_478e3c32 = [];
		}
		if(!isdefined(level.var_478e3c32))
		{
			level.var_478e3c32 = [];
		}
		else if(!isarray(level.var_478e3c32))
		{
			level.var_478e3c32 = array(level.var_478e3c32);
		}
		level.var_478e3c32[level.var_478e3c32.size] = self;
	#/
	if(self == getlocalplayer(localclientnum))
	{
		self init_duplicaterender_settings();
		self thread force_update_player_clientfields(localclientnum);
	}
	if(self isplayer() && self islocalplayer())
	{
		if(!isdefined(self getlocalclientnumber()) || localclientnum == self getlocalclientnumber())
		{
			return;
		}
	}
	dvar_value = getdvarint("scr_hide_player_keyline");
	self duplicate_render::set_dr_flag("keyline_active", !dvar_value);
	self duplicate_render::update_dr_filters(localclientnum);
}

/*
	Name: player_umbrahotfixes
	Namespace: zm
	Checksum: 0x6BA54B0D
	Offset: 0x2600
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function player_umbrahotfixes(localclientnum)
{
	if(!self islocalplayer() || !isdefined(self getlocalclientnumber()) || localclientnum != self getlocalclientnumber())
	{
		return;
	}
	self thread zm_utility::umbra_fix_logic(localclientnum);
}

/*
	Name: basic_player_connect
	Namespace: zm
	Checksum: 0xAAA20AB6
	Offset: 0x2688
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function basic_player_connect(localclientnum)
{
	if(!isdefined(level._laststand))
	{
		level._laststand = [];
	}
	level._laststand[localclientnum] = 0;
}

/*
	Name: force_update_player_clientfields
	Namespace: zm
	Checksum: 0x78FE4A60
	Offset: 0x26C8
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function force_update_player_clientfields(localclientnum)
{
	self endon(#"entityshutdown");
	while(!clienthassnapshot(localclientnum))
	{
		wait(0.25);
	}
	wait(0.25);
	self processclientfieldsasifnew();
}

/*
	Name: init_blocker_fx
	Namespace: zm
	Checksum: 0x99EC1590
	Offset: 0x2730
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init_blocker_fx()
{
}

/*
	Name: init_riser_fx
	Namespace: zm
	Checksum: 0x585B51C4
	Offset: 0x2740
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function init_riser_fx()
{
	if(isdefined(level.use_new_riser_water) && level.use_new_riser_water)
	{
		level._effect["rise_burst_water"] = "_t6/maps/zombie/fx_mp_zombie_hand_water_burst";
		level._effect["rise_billow_water"] = "_t6/maps/zombie/fx_mp_zombie_body_water_billowing";
		level._effect["rise_dust_water"] = "_t6/maps/zombie/fx_zombie_body_wtr_falling";
	}
	level._effect["rise_burst"] = "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow"] = "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust"] = "zombie/fx_spawn_dirt_body_dustfalling_zmb";
	if(isdefined(level.riser_type) && level.riser_type == "snow")
	{
		level._effect["rise_burst_snow"] = "_t6/maps/zombie/fx_mp_zombie_hand_snow_burst";
		level._effect["rise_billow_snow"] = "_t6/maps/zombie/fx_mp_zombie_body_snow_billowing";
		level._effect["rise_dust_snow"] = "_t6/maps/zombie/fx_mp_zombie_body_snow_falling";
	}
}

/*
	Name: init_clientfields
	Namespace: zm
	Checksum: 0xD5279033
	Offset: 0x2880
	Size: 0x55C
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	/#
		println("");
	#/
	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int", &handle_zombie_risers, 1, 1);
	if(isdefined(level.use_water_risers) && level.use_water_risers)
	{
		clientfield::register("actor", "zombie_riser_fx_water", 1, 1, "int", &handle_zombie_risers_water, 1, 1);
	}
	if(isdefined(level.use_foliage_risers) && level.use_foliage_risers)
	{
		clientfield::register("actor", "zombie_riser_fx_foliage", 1, 1, "int", &handle_zombie_risers_foliage, 1, 1);
	}
	if(isdefined(level.use_low_gravity_risers) && level.use_low_gravity_risers)
	{
		clientfield::register("actor", "zombie_riser_fx_lowg", 1, 1, "int", &handle_zombie_risers_lowg, 1, 1);
	}
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int", &zombie_eyes_clientfield_cb, 0, 1);
	clientfield::register("actor", "zombie_ragdoll_explode", 1, 1, "int", &zombie_ragdoll_explode_cb, 0, 1);
	clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int", &zombie_gut_explosion_cb, 0, 1);
	clientfield::register("actor", "sndZombieContext", -1, 1, "int", &zm_audio::sndsetzombiecontext, 0, 1);
	clientfield::register("actor", "zombie_keyline_render", 1, 1, "int", &zombie_zombie_keyline_render_clientfield_cb, 0, 1);
	bits = 4;
	power = struct::get_array("elec_switch_fx", "script_noteworthy");
	if(isdefined(power))
	{
		bits = getminbitcountfornum(power.size + 1);
	}
	clientfield::register("world", "zombie_power_on", 1, bits, "int", &zombie_power_clientfield_on, 1, 1);
	clientfield::register("world", "zombie_power_off", 1, bits, "int", &zombie_power_clientfield_off, 1, 1);
	clientfield::register("world", "round_complete_time", 1, 20, "int", &round_complete_time, 0, 1);
	clientfield::register("world", "round_complete_num", 1, 8, "int", &round_complete_num, 0, 1);
	clientfield::register("world", "game_end_time", 1, 20, "int", &game_end_time, 0, 1);
	clientfield::register("world", "quest_complete_time", 1, 20, "int", &quest_complete_time, 0, 1);
	clientfield::register("world", "game_start_time", 15001, 20, "int", &game_start_time, 0, 1);
}

/*
	Name: box_monitor
	Namespace: zm
	Checksum: 0x4980C0B4
	Offset: 0x2DE8
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function box_monitor(clientnum, state, oldstate)
{
	if(isdefined(level._custom_box_monitor))
	{
		[[level._custom_box_monitor]](clientnum, state, oldstate);
	}
}

/*
	Name: zpo_listener
	Namespace: zm
	Checksum: 0xE4E3F2C4
	Offset: 0x2E38
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function zpo_listener()
{
	while(true)
	{
		int = undefined;
		level waittill(#"zpo", int);
		if(isdefined(int))
		{
			level notify(#"power_on", int);
		}
		else
		{
			level notify(#"power_on");
		}
	}
}

/*
	Name: zpoff_listener
	Namespace: zm
	Checksum: 0xFED6339A
	Offset: 0x2EA0
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function zpoff_listener()
{
	while(true)
	{
		int = undefined;
		level waittill(#"zpoff", int);
		if(isdefined(int))
		{
			level notify(#"power_off", int);
		}
		else
		{
			level notify(#"power_off");
		}
	}
}

/*
	Name: zombie_power_clientfield_on
	Namespace: zm
	Checksum: 0xFF682800
	Offset: 0x2F08
	Size: 0x56
	Parameters: 7
	Flags: Linked
*/
function zombie_power_clientfield_on(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level notify(#"zpo", newval);
	}
}

/*
	Name: zombie_power_clientfield_off
	Namespace: zm
	Checksum: 0x65CAE13C
	Offset: 0x2F68
	Size: 0x56
	Parameters: 7
	Flags: Linked
*/
function zombie_power_clientfield_off(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level notify(#"zpoff", newval);
	}
}

/*
	Name: round_complete_time
	Namespace: zm
	Checksum: 0x8FD681EA
	Offset: 0x2FC8
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function round_complete_time(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	model = createuimodel(getuimodelforcontroller(localclientnum), "hudItems.time.round_complete_time");
	setuimodelvalue(model, newval);
}

/*
	Name: round_complete_num
	Namespace: zm
	Checksum: 0x51BB72F1
	Offset: 0x3068
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function round_complete_num(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	model = createuimodel(getuimodelforcontroller(localclientnum), "hudItems.time.round_complete_num");
	setuimodelvalue(model, newval);
}

/*
	Name: game_end_time
	Namespace: zm
	Checksum: 0xF3D61731
	Offset: 0x3108
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function game_end_time(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	model = createuimodel(getuimodelforcontroller(localclientnum), "hudItems.time.game_end_time");
	setuimodelvalue(model, newval);
}

/*
	Name: quest_complete_time
	Namespace: zm
	Checksum: 0x3BB9A4A2
	Offset: 0x31A8
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function quest_complete_time(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	model = createuimodel(getuimodelforcontroller(localclientnum), "hudItems.time.quest_complete_time");
	setuimodelvalue(model, newval);
}

/*
	Name: game_start_time
	Namespace: zm
	Checksum: 0x24DF764D
	Offset: 0x3248
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function game_start_time(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	model = createuimodel(getuimodelforcontroller(localclientnum), "hudItems.time.game_start_time");
	setuimodelvalue(model, newval);
}

/*
	Name: createzombieeyesinternal
	Namespace: zm
	Checksum: 0xECB384B5
	Offset: 0x32E8
	Size: 0x102
	Parameters: 1
	Flags: Linked
*/
function createzombieeyesinternal(localclientnum)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self._eyearray))
	{
		self._eyearray = [];
	}
	if(!isdefined(self._eyearray[localclientnum]))
	{
		linktag = "j_eyeball_le";
		effect = level._effect["eye_glow"];
		if(isdefined(level._override_eye_fx))
		{
			effect = level._override_eye_fx;
		}
		if(isdefined(self._eyeglow_fx_override))
		{
			effect = self._eyeglow_fx_override;
		}
		if(isdefined(self._eyeglow_tag_override))
		{
			linktag = self._eyeglow_tag_override;
		}
		self._eyearray[localclientnum] = playfxontag(localclientnum, effect, self, linktag);
	}
}

/*
	Name: createzombieeyes
	Namespace: zm
	Checksum: 0xF36F93B
	Offset: 0x33F8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function createzombieeyes(localclientnum)
{
	self thread createzombieeyesinternal(localclientnum);
}

/*
	Name: deletezombieeyes
	Namespace: zm
	Checksum: 0x13F963A9
	Offset: 0x3428
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function deletezombieeyes(localclientnum)
{
	if(isdefined(self._eyearray))
	{
		if(isdefined(self._eyearray[localclientnum]))
		{
			deletefx(localclientnum, self._eyearray[localclientnum], 1);
			self._eyearray[localclientnum] = undefined;
		}
	}
}

/*
	Name: player_eyes_clientfield_cb
	Namespace: zm
	Checksum: 0x8FCA5312
	Offset: 0x3490
	Size: 0x174
	Parameters: 7
	Flags: None
*/
function player_eyes_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(self isplayer())
	{
		self.zombie_face = newval;
		self notify(#"face", "face_advance");
		if(isdefined(self.special_eyes) && self.special_eyes)
		{
		}
	}
	if(self isplayer() && self islocalplayer() && !isdemoplaying())
	{
		else
		{
		}
		if(localclientnum == self getlocalclientnumber())
		{
			return;
		}
	}
	if(!isdemoplaying())
	{
		zombie_eyes_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
	}
	else
	{
		zombie_eyes_demo_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
	}
}

/*
	Name: player_eye_color_clientfield_cb
	Namespace: zm
	Checksum: 0xC5AE85D2
	Offset: 0x3610
	Size: 0x1B4
	Parameters: 7
	Flags: None
*/
function player_eye_color_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(self isplayer() && self islocalplayer() && !isdemoplaying())
	{
		if(localclientnum == self getlocalclientnumber())
		{
			return;
		}
	}
	if(!isdefined(self.special_eyes) || self.special_eyes != newval)
	{
		self.special_eyes = newval;
		if(isdefined(self.special_eyes) && self.special_eyes)
		{
			self._eyeglow_fx_override = level._effect["player_eye_glow_blue"];
		}
		else
		{
			self._eyeglow_fx_override = level._effect["player_eye_glow_orng"];
		}
		if(!isdemoplaying())
		{
			zombie_eyes_clientfield_cb(localclientnum, 0, isdefined(self.zombie_face) && self.zombie_face, bnewent, binitialsnap, fieldname, bwastimejump);
		}
		else
		{
			zombie_eyes_demo_clientfield_cb(localclientnum, 0, isdefined(self.zombie_face) && self.zombie_face, bnewent, binitialsnap, fieldname, bwastimejump);
		}
	}
}

/*
	Name: zombie_eyes_handle_demo_jump
	Namespace: zm
	Checksum: 0x9A4AF5ED
	Offset: 0x37D0
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function zombie_eyes_handle_demo_jump(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"death_or_disconnect");
	self endon(#"new_zombie_eye_cb");
	while(true)
	{
		level util::waittill_any("demo_jump", "demo_player_switch");
		self deletezombieeyes(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
		self.eyes_spawned = 0;
	}
}

/*
	Name: zombie_eyes_demo_watcher
	Namespace: zm
	Checksum: 0xD44A2B10
	Offset: 0x38A8
	Size: 0x260
	Parameters: 7
	Flags: Linked
*/
function zombie_eyes_demo_watcher(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self endon(#"death_or_disconnect");
	self endon(#"new_zombie_eye_cb");
	self thread zombie_eyes_handle_demo_jump(localclientnum);
	if(newval)
	{
		while(true)
		{
			if(!self islocalplayer() || isspectating(localclientnum, 1) || localclientnum != self getlocalclientnumber())
			{
				if(!(isdefined(self.eyes_spawned) && self.eyes_spawned))
				{
					self createzombieeyes(localclientnum);
					self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color());
					self.eyes_spawned = 1;
				}
			}
			else if(isdefined(self.eyes_spawned) && self.eyes_spawned)
			{
				self deletezombieeyes(localclientnum);
				self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
				self.eyes_spawned = 0;
			}
			wait(0.016);
		}
	}
	else
	{
		self deletezombieeyes(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
		self.eyes_spawned = 0;
	}
}

/*
	Name: zombie_eyes_demo_clientfield_cb
	Namespace: zm
	Checksum: 0x4E7A70F1
	Offset: 0x3B10
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function zombie_eyes_demo_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self notify(#"new_zombie_eye_cb");
	self thread zombie_eyes_demo_watcher(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
}

/*
	Name: zombie_eyes_clientfield_cb
	Namespace: zm
	Checksum: 0x87CC82E5
	Offset: 0x3B98
	Size: 0x154
	Parameters: 7
	Flags: Linked
*/
function zombie_eyes_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	if(newval)
	{
		self createzombieeyes(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color());
	}
	else
	{
		self deletezombieeyes(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
	}
	if(isdefined(level.zombie_eyes_clientfield_cb_additional))
	{
		self [[level.zombie_eyes_clientfield_cb_additional]](localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
	}
}

/*
	Name: zombie_zombie_keyline_render_clientfield_cb
	Namespace: zm
	Checksum: 0xB6E6AA2C
	Offset: 0x3CF8
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function zombie_zombie_keyline_render_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	if(isdefined(level.debug_keyline_zombies) && level.debug_keyline_zombies)
	{
		if(newval)
		{
			self duplicate_render::set_dr_flag("keyline_active", 1);
			self duplicate_render::update_dr_filters(localclientnum);
		}
		else
		{
			self duplicate_render::set_dr_flag("keyline_active", 0);
			self duplicate_render::update_dr_filters(localclientnum);
		}
	}
}

/*
	Name: get_eyeball_on_luminance
	Namespace: zm
	Checksum: 0xA327895A
	Offset: 0x3DD8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_on_luminance()
{
	if(isdefined(level.eyeball_on_luminance_override))
	{
		return level.eyeball_on_luminance_override;
	}
	return 1;
}

/*
	Name: get_eyeball_off_luminance
	Namespace: zm
	Checksum: 0x4D816DF3
	Offset: 0x3E00
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_off_luminance()
{
	if(isdefined(level.eyeball_off_luminance_override))
	{
		return level.eyeball_off_luminance_override;
	}
	return 0;
}

/*
	Name: get_eyeball_color
	Namespace: zm
	Checksum: 0x3BFA785E
	Offset: 0x3E28
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_color()
{
	val = 0;
	if(isdefined(level.zombie_eyeball_color_override))
	{
		val = level.zombie_eyeball_color_override;
	}
	if(isdefined(self.zombie_eyeball_color_override))
	{
		val = self.zombie_eyeball_color_override;
	}
	return val;
}

/*
	Name: zombie_ragdoll_explode_cb
	Namespace: zm
	Checksum: 0xC9C33D0B
	Offset: 0x3E78
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function zombie_ragdoll_explode_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self zombie_wait_explode(localclientnum);
	}
}

/*
	Name: zombie_gut_explosion_cb
	Namespace: zm
	Checksum: 0x503B4312
	Offset: 0x3EE0
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function zombie_gut_explosion_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(isdefined(level._effect["zombie_guts_explosion"]))
		{
			org = self gettagorigin("J_SpineLower");
			if(isdefined(org))
			{
				playfx(localclientnum, level._effect["zombie_guts_explosion"], org);
			}
		}
	}
}

/*
	Name: init_zombie_explode_fx
	Namespace: zm
	Checksum: 0x2C45CC35
	Offset: 0x3FA0
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function init_zombie_explode_fx()
{
	level._effect["zombie_guts_explosion"] = "zombie/fx_blood_torso_explo_lg_zmb";
}

/*
	Name: zombie_wait_explode
	Namespace: zm
	Checksum: 0xBBF4EBF6
	Offset: 0x3FC8
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function zombie_wait_explode(localclientnum)
{
	where = self gettagorigin("J_SpineLower");
	if(!isdefined(where))
	{
		where = self.origin;
	}
	start = gettime();
	while((gettime() - start) < 2000)
	{
		if(isdefined(self))
		{
			where = self gettagorigin("J_SpineLower");
			if(!isdefined(where))
			{
				where = self.origin;
			}
		}
		wait(0.05);
	}
	if(isdefined(level._effect["zombie_guts_explosion"]) && util::is_mature())
	{
		playfx(localclientnum, level._effect["zombie_guts_explosion"], where);
	}
}

/*
	Name: mark_piece_gibbed
	Namespace: zm
	Checksum: 0x966D6779
	Offset: 0x40E8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function mark_piece_gibbed(piece_index)
{
	if(!isdefined(self.gibbed_pieces))
	{
		self.gibbed_pieces = [];
	}
	self.gibbed_pieces[self.gibbed_pieces.size] = piece_index;
}

/*
	Name: has_gibbed_piece
	Namespace: zm
	Checksum: 0x69F97B7
	Offset: 0x4130
	Size: 0x68
	Parameters: 1
	Flags: None
*/
function has_gibbed_piece(piece_index)
{
	if(!isdefined(self.gibbed_pieces))
	{
		return false;
	}
	for(i = 0; i < self.gibbed_pieces.size; i++)
	{
		if(self.gibbed_pieces[i] == piece_index)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: do_headshot_gib_fx
	Namespace: zm
	Checksum: 0xB0987D6A
	Offset: 0x41A0
	Size: 0x1E6
	Parameters: 0
	Flags: Linked
*/
function do_headshot_gib_fx()
{
	fxtag = "j_neck";
	fxorigin = self gettagorigin(fxtag);
	upvec = anglestoup(self gettagangles(fxtag));
	forwardvec = anglestoforward(self gettagangles(fxtag));
	players = level.localplayers;
	for(i = 0; i < players.size; i++)
	{
		playfx(i, level._effect["headshot"], fxorigin, forwardvec, upvec);
		playfx(i, level._effect["headshot_nochunks"], fxorigin, forwardvec, upvec);
	}
	playsound(0, "zmb_zombie_head_gib", fxorigin);
	wait(0.3);
	if(isdefined(self))
	{
		players = level.localplayers;
		for(i = 0; i < players.size; i++)
		{
			playfxontag(i, level._effect["bloodspurt"], self, fxtag);
		}
	}
}

/*
	Name: do_gib_fx
	Namespace: zm
	Checksum: 0xC1E6A91B
	Offset: 0x4390
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function do_gib_fx(tag)
{
	players = level.localplayers;
	for(i = 0; i < players.size; i++)
	{
		playfxontag(i, level._effect["animscript_gib_fx"], self, tag);
	}
	playsound(0, "zmb_death_gibs", self gettagorigin(tag));
}

/*
	Name: do_gib
	Namespace: zm
	Checksum: 0x12003A1D
	Offset: 0x4448
	Size: 0x22C
	Parameters: 2
	Flags: Linked
*/
function do_gib(model, tag)
{
	start_pos = self gettagorigin(tag);
	start_angles = self gettagangles(tag);
	wait(0.016);
	end_pos = undefined;
	angles = undefined;
	if(!isdefined(self))
	{
		end_pos = start_pos + (anglestoforward(start_angles) * 10);
		angles = start_angles;
	}
	else
	{
		end_pos = self gettagorigin(tag);
		angles = self gettagangles(tag);
	}
	if(isdefined(self._gib_vel))
	{
		forward = self._gib_vel;
		self._gib_vel = undefined;
	}
	else
	{
		forward = vectornormalize(end_pos - start_pos);
		forward = forward * randomfloatrange(0.6, 1);
		forward = forward + (0, 0, randomfloatrange(0.4, 0.7));
	}
	createdynentandlaunch(0, model, end_pos, angles, start_pos, forward, level._effect["animscript_gibtrail_fx"], 1);
	if(isdefined(self))
	{
		self do_gib_fx(tag);
	}
	else
	{
		playsound(0, "zmb_death_gibs", end_pos);
	}
}

/*
	Name: do_hat_gib
	Namespace: zm
	Checksum: 0x53BE97EF
	Offset: 0x4680
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function do_hat_gib(model, tag)
{
	start_pos = self gettagorigin(tag);
	start_angles = self gettagangles(tag);
	up_angles = (0, 0, 1);
	force = (0, 0, randomfloatrange(1.4, 1.7));
	createdynentandlaunch(0, model, start_pos, up_angles, start_pos, force);
}

/*
	Name: check_should_gib
	Namespace: zm
	Checksum: 0x270F64BE
	Offset: 0x4758
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function check_should_gib()
{
	if(level.gibcount <= level.gibmaxcount)
	{
		return true;
	}
	return false;
}

/*
	Name: resetgibcounter
	Namespace: zm
	Checksum: 0xB04A2A36
	Offset: 0x4780
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function resetgibcounter()
{
	self endon(#"disconnect");
	while(true)
	{
		wait(level.gibresettime);
		level.gibtimer = 0;
		level.gibcount = 0;
	}
}

/*
	Name: on_gib_event
	Namespace: zm
	Checksum: 0x15B437B9
	Offset: 0x47C8
	Size: 0x6FC
	Parameters: 3
	Flags: Linked
*/
function on_gib_event(localclientnum, type, locations)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(!util::is_mature())
	{
		return;
	}
	if(!isdefined(self._gib_def))
	{
		return;
	}
	if(isdefined(level._gib_overload_func))
	{
		if(self [[level._gib_overload_func]](type, locations))
		{
			return;
		}
	}
	if(!check_should_gib())
	{
		return;
	}
	level.gibcount++;
	for(i = 0; i < locations.size; i++)
	{
		if(isdefined(self.gibbed) && level._zombie_gib_piece_index_head != locations[i])
		{
			continue;
		}
		switch(locations[i])
		{
			case 0:
			{
				if(isdefined(self._gib_def.gibspawn1) && isdefined(self._gib_def.gibspawntag1))
				{
					self thread do_gib(self._gib_def.gibspawn1, self._gib_def.gibspawntag1);
				}
				if(isdefined(self._gib_def.gibspawn2) && isdefined(self._gib_def.gibspawntag2))
				{
					self thread do_gib(self._gib_def.gibspawn2, self._gib_def.gibspawntag2);
				}
				if(isdefined(self._gib_def.gibspawn3) && isdefined(self._gib_def.gibspawntag3))
				{
					self thread do_gib(self._gib_def.gibspawn3, self._gib_def.gibspawntag3);
				}
				if(isdefined(self._gib_def.gibspawn4) && isdefined(self._gib_def.gibspawntag4))
				{
					self thread do_gib(self._gib_def.gibspawn4, self._gib_def.gibspawntag4);
				}
				if(isdefined(self._gib_def.gibspawn5) && isdefined(self._gib_def.gibspawntag5))
				{
					self thread do_hat_gib(self._gib_def.gibspawn5, self._gib_def.gibspawntag5);
				}
				self thread do_headshot_gib_fx();
				self thread do_gib_fx("J_SpineLower");
				mark_piece_gibbed(level._zombie_gib_piece_index_right_arm);
				mark_piece_gibbed(level._zombie_gib_piece_index_left_arm);
				mark_piece_gibbed(level._zombie_gib_piece_index_right_leg);
				mark_piece_gibbed(level._zombie_gib_piece_index_left_leg);
				mark_piece_gibbed(level._zombie_gib_piece_index_head);
				mark_piece_gibbed(level._zombie_gib_piece_index_hat);
				break;
			}
			case 1:
			{
				if(isdefined(self._gib_def.gibspawn1) && isdefined(self._gib_def.gibspawntag1))
				{
					self thread do_gib(self._gib_def.gibspawn1, self._gib_def.gibspawntag1);
				}
				else
				{
				}
				mark_piece_gibbed(level._zombie_gib_piece_index_right_arm);
				break;
			}
			case 2:
			{
				if(isdefined(self._gib_def.gibspawn2) && isdefined(self._gib_def.gibspawntag2))
				{
					self thread do_gib(self._gib_def.gibspawn2, self._gib_def.gibspawntag2);
				}
				else
				{
				}
				mark_piece_gibbed(level._zombie_gib_piece_index_left_arm);
				break;
			}
			case 3:
			{
				if(isdefined(self._gib_def.gibspawn3) && isdefined(self._gib_def.gibspawntag3))
				{
					self thread do_gib(self._gib_def.gibspawn3, self._gib_def.gibspawntag3);
				}
				mark_piece_gibbed(level._zombie_gib_piece_index_right_leg);
				break;
			}
			case 4:
			{
				if(isdefined(self._gib_def.gibspawn4) && isdefined(self._gib_def.gibspawntag4))
				{
					self thread do_gib(self._gib_def.gibspawn4, self._gib_def.gibspawntag4);
				}
				mark_piece_gibbed(level._zombie_gib_piece_index_left_leg);
				break;
			}
			case 5:
			{
				self thread do_headshot_gib_fx();
				mark_piece_gibbed(level._zombie_gib_piece_index_head);
				break;
			}
			case 6:
			{
				self thread do_gib_fx("J_SpineLower");
				break;
			}
			case 7:
			{
				if(isdefined(self._gib_def.gibspawn5) && isdefined(self._gib_def.gibspawntag5))
				{
					self thread do_hat_gib(self._gib_def.gibspawn5, self._gib_def.gibspawntag5);
				}
				mark_piece_gibbed(level._zombie_gib_piece_index_hat);
				break;
			}
		}
	}
	self.gibbed = 1;
}

/*
	Name: zombie_vision_set_apply
	Namespace: zm
	Checksum: 0x4B2DFF80
	Offset: 0x4ED0
	Size: 0x284
	Parameters: 4
	Flags: None
*/
function zombie_vision_set_apply(str_visionset, int_priority, flt_transition_time, int_clientnum)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!isdefined(self._zombie_visionset_list))
	{
		self._zombie_visionset_list = [];
	}
	if(!isdefined(str_visionset) || !isdefined(int_priority))
	{
		return;
	}
	if(!isdefined(flt_transition_time))
	{
		flt_transition_time = 1;
	}
	if(!isdefined(int_clientnum))
	{
		if(self islocalplayer())
		{
			int_clientnum = self getlocalclientnumber();
		}
		if(!isdefined(int_clientnum))
		{
			return;
		}
	}
	already_in_array = 0;
	if(self._zombie_visionset_list.size != 0)
	{
		for(i = 0; i < self._zombie_visionset_list.size; i++)
		{
			if(isdefined(self._zombie_visionset_list[i].vision_set) && self._zombie_visionset_list[i].vision_set == str_visionset)
			{
				already_in_array = 1;
				if(self._zombie_visionset_list[i].priority != int_priority)
				{
					self._zombie_visionset_list[i].priority = int_priority;
				}
				break;
			}
		}
	}
	if(!already_in_array)
	{
		temp_struct = spawnstruct();
		temp_struct.vision_set = str_visionset;
		temp_struct.priority = int_priority;
		array::add(self._zombie_visionset_list, temp_struct, 0);
	}
	vision_to_set = self zombie_highest_vision_set_apply();
	if(isdefined(vision_to_set))
	{
		visionsetnaked(int_clientnum, vision_to_set, flt_transition_time);
	}
	else
	{
		visionsetnaked(int_clientnum, "undefined", flt_transition_time);
	}
}

/*
	Name: zombie_vision_set_remove
	Namespace: zm
	Checksum: 0x362D963E
	Offset: 0x5160
	Size: 0x1DC
	Parameters: 3
	Flags: None
*/
function zombie_vision_set_remove(str_visionset, flt_transition_time, int_clientnum)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!isdefined(str_visionset))
	{
		return;
	}
	if(!isdefined(flt_transition_time))
	{
		flt_transition_time = 1;
	}
	if(!isdefined(self._zombie_visionset_list))
	{
		self._zombie_visionset_list = [];
	}
	if(!isdefined(int_clientnum))
	{
		if(self islocalplayer())
		{
			int_clientnum = self getlocalclientnumber();
		}
		if(!isdefined(int_clientnum))
		{
			return;
		}
	}
	temp_struct = undefined;
	for(i = 0; i < self._zombie_visionset_list.size; i++)
	{
		if(isdefined(self._zombie_visionset_list[i].vision_set) && self._zombie_visionset_list[i].vision_set == str_visionset)
		{
			temp_struct = self._zombie_visionset_list[i];
		}
	}
	if(isdefined(temp_struct))
	{
		arrayremovevalue(self._zombie_visionset_list, temp_struct);
	}
	vision_to_set = self zombie_highest_vision_set_apply();
	if(isdefined(vision_to_set))
	{
		visionsetnaked(int_clientnum, vision_to_set, flt_transition_time);
	}
	else
	{
		visionsetnaked(int_clientnum, "undefined", flt_transition_time);
	}
}

/*
	Name: zombie_highest_vision_set_apply
	Namespace: zm
	Checksum: 0x60DA8DFC
	Offset: 0x5348
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function zombie_highest_vision_set_apply()
{
	if(!isdefined(self._zombie_visionset_list))
	{
		return;
	}
	highest_score = 0;
	highest_score_vision = undefined;
	for(i = 0; i < self._zombie_visionset_list.size; i++)
	{
		if(isdefined(self._zombie_visionset_list[i].priority) && self._zombie_visionset_list[i].priority > highest_score)
		{
			highest_score = self._zombie_visionset_list[i].priority;
			highest_score_vision = self._zombie_visionset_list[i].vision_set;
		}
	}
	return highest_score_vision;
}

/*
	Name: handle_zombie_risers_foliage
	Namespace: zm
	Checksum: 0xE95875E5
	Offset: 0x5430
	Size: 0x13E
	Parameters: 7
	Flags: Linked
*/
function handle_zombie_risers_foliage(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level endon(#"demo_jump");
	self endon(#"entityshutdown");
	if(!oldval && newval)
	{
		localplayers = level.localplayers;
		playsound(0, "zmb_zombie_spawn", self.origin);
		burst_fx = level._effect["rise_burst_foliage"];
		billow_fx = level._effect["rise_billow_foliage"];
		type = "foliage";
		for(i = 0; i < localplayers.size; i++)
		{
			self thread rise_dust_fx(i, type, billow_fx, burst_fx);
		}
	}
}

/*
	Name: handle_zombie_risers_water
	Namespace: zm
	Checksum: 0x7B816927
	Offset: 0x5578
	Size: 0x13E
	Parameters: 7
	Flags: Linked
*/
function handle_zombie_risers_water(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level endon(#"demo_jump");
	self endon(#"entityshutdown");
	if(!oldval && newval)
	{
		localplayers = level.localplayers;
		playsound(0, "zmb_zombie_spawn_water", self.origin);
		burst_fx = level._effect["rise_burst_water"];
		billow_fx = level._effect["rise_billow_water"];
		type = "water";
		for(i = 0; i < localplayers.size; i++)
		{
			self thread rise_dust_fx(i, type, billow_fx, burst_fx);
		}
	}
}

/*
	Name: handle_zombie_risers
	Namespace: zm
	Checksum: 0x8DF561FE
	Offset: 0x56C0
	Size: 0x1BE
	Parameters: 7
	Flags: Linked
*/
function handle_zombie_risers(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level endon(#"demo_jump");
	self endon(#"entityshutdown");
	if(!oldval && newval)
	{
		localplayers = level.localplayers;
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst"];
		billow_fx = level._effect["rise_billow"];
		type = "dirt";
		if(isdefined(level.riser_type) && level.riser_type == "snow")
		{
			sound = "zmb_zombie_spawn_snow";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}
		playsound(0, sound, self.origin);
		for(i = 0; i < localplayers.size; i++)
		{
			self thread rise_dust_fx(i, type, billow_fx, burst_fx);
		}
	}
}

/*
	Name: handle_zombie_risers_lowg
	Namespace: zm
	Checksum: 0x18C23C07
	Offset: 0x5888
	Size: 0x1BE
	Parameters: 7
	Flags: Linked
*/
function handle_zombie_risers_lowg(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level endon(#"demo_jump");
	self endon(#"entityshutdown");
	if(!oldval && newval)
	{
		localplayers = level.localplayers;
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst_lg"];
		billow_fx = level._effect["rise_billow_lg"];
		type = "dirt";
		if(isdefined(level.riser_type) && level.riser_type == "snow")
		{
			sound = "zmb_zombie_spawn_snow";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}
		playsound(0, sound, self.origin);
		for(i = 0; i < localplayers.size; i++)
		{
			self thread rise_dust_fx(i, type, billow_fx, burst_fx);
		}
	}
}

/*
	Name: rise_dust_fx
	Namespace: zm
	Checksum: 0x1B3B914
	Offset: 0x5A50
	Size: 0x326
	Parameters: 4
	Flags: Linked
*/
function rise_dust_fx(clientnum, type, billow_fx, burst_fx)
{
	dust_tag = "J_SpineUpper";
	self endon(#"entityshutdown");
	level endon(#"demo_jump");
	if(isdefined(level.zombie_custom_riser_fx_handler))
	{
		s_info = self [[level.zombie_custom_riser_fx_handler]]();
		if(isdefined(s_info))
		{
			if(isdefined(s_info.burst_fx))
			{
				burst_fx = s_info.burst_fx;
			}
			if(isdefined(s_info.billow_fx))
			{
				billow_fx = s_info.billow_fx;
			}
			if(isdefined(s_info.type))
			{
				type = s_info.type;
			}
		}
	}
	if(isdefined(burst_fx))
	{
		playfx(clientnum, burst_fx, self.origin + (0, 0, randomintrange(5, 10)));
	}
	wait(0.25);
	if(isdefined(billow_fx))
	{
		playfx(clientnum, billow_fx, self.origin + (randomintrange(-10, 10), randomintrange(-10, 10), randomintrange(5, 10)));
	}
	wait(2);
	dust_time = 5.5;
	dust_interval = 0.3;
	player = level.localplayers[clientnum];
	effect = level._effect["rise_dust"];
	if(type == "water")
	{
		effect = level._effect["rise_dust_water"];
	}
	else
	{
		if(type == "snow")
		{
			effect = level._effect["rise_dust_snow"];
		}
		else
		{
			if(type == "foliage")
			{
				effect = level._effect["rise_dust_foliage"];
			}
			else if(type == "none")
			{
				return;
			}
		}
	}
	t = 0;
	while(t < dust_time)
	{
		if(!isdefined(self))
		{
			return;
		}
		playfxontag(clientnum, effect, self, dust_tag);
		wait(dust_interval);
		t = t + dust_interval;
	}
}

/*
	Name: end_last_stand
	Namespace: zm
	Checksum: 0x34AA64E8
	Offset: 0x5D80
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function end_last_stand(clientnum)
{
	self waittill(#"laststandend");
	/#
		println("" + clientnum);
	#/
	waitrealtime(0.7);
	/#
		println("");
	#/
	playsound(clientnum, "revive_gasp");
}

/*
	Name: last_stand_thread
	Namespace: zm
	Checksum: 0xD875607
	Offset: 0x5E10
	Size: 0x178
	Parameters: 1
	Flags: Linked
*/
function last_stand_thread(clientnum)
{
	self thread end_last_stand(clientnum);
	self endon(#"laststandend");
	/#
		println("" + clientnum);
	#/
	pause = 0.5;
	vol = 0.5;
	while(true)
	{
		id = playsound(clientnum, "chr_heart_beat");
		setsoundvolume(id, vol);
		waitrealtime(pause);
		if(pause < 2)
		{
			pause = pause * 1.05;
			if(pause > 2)
			{
				pause = 2;
			}
		}
		if(vol < 1)
		{
			vol = vol * 1.05;
			if(vol > 1)
			{
				vol = 1;
			}
		}
	}
}

/*
	Name: last_stand_monitor
	Namespace: zm
	Checksum: 0x1839CDCE
	Offset: 0x5F90
	Size: 0x19E
	Parameters: 3
	Flags: Linked
*/
function last_stand_monitor(clientnum, state, oldstate)
{
	player = level.localplayers[clientnum];
	players = level.localplayers;
	if(!isdefined(player))
	{
		return;
	}
	if(state == "1")
	{
		if(!level._laststand[clientnum])
		{
			if(!isdefined(level.lslooper))
			{
				level.lslooper = spawn(0, player.origin, "script.origin");
			}
			player thread last_stand_thread(clientnum);
			if(players.size <= 1)
			{
				level.lslooper playloopsound("evt_laststand_loop", 0.3);
			}
			level._laststand[clientnum] = 1;
		}
	}
	else if(level._laststand[clientnum])
	{
		if(isdefined(level.lslooper))
		{
			level.lslooper stopallloopsounds(0.7);
			playsound(0, "evt_laststand_in", (0, 0, 0));
		}
		player notify(#"laststandend");
		level._laststand[clientnum] = 0;
	}
}

/*
	Name: laststand
	Namespace: zm
	Checksum: 0x8AB02A33
	Offset: 0x6138
	Size: 0x1B4
	Parameters: 7
	Flags: Linked
*/
function laststand(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(!(self isplayer() && self islocalplayer() && isdemoplaying()))
		{
			self duplicate_render::set_dr_flag("keyline_ls", 1);
			self duplicate_render::update_dr_filters(localclientnum);
		}
	}
	else
	{
		self duplicate_render::set_dr_flag("keyline_ls", 0);
		self duplicate_render::update_dr_filters(localclientnum);
	}
	if(self isplayer() && self islocalplayer() && !isdemoplaying())
	{
		if(isdefined(self getlocalclientnumber()) && localclientnum == self getlocalclientnumber())
		{
			self zm_audio::sndzmblaststand(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
		}
	}
}

/*
	Name: update_aat_hud
	Namespace: zm
	Checksum: 0xB29BD461
	Offset: 0x62F8
	Size: 0x14C
	Parameters: 7
	Flags: Linked
*/
function update_aat_hud(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	str_localized = aat::get_string(newval);
	icon = aat::get_icon(newval);
	if(str_localized == "none")
	{
		str_localized = "";
	}
	controllermodel = getuimodelforcontroller(localclientnum);
	aatmodel = createuimodel(controllermodel, "CurrentWeapon.aat");
	setuimodelvalue(aatmodel, str_localized);
	aaticonmodel = createuimodel(controllermodel, "CurrentWeapon.aatIcon");
	setuimodelvalue(aaticonmodel, icon);
}

