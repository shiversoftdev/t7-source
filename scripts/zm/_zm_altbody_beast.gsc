// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\grapple;
#using scripts\zm\_bb;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_altbody;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_zod_util;

#namespace zm_altbody_beast;

/*
	Name: __init__sytem__
	Namespace: zm_altbody_beast
	Checksum: 0x5F3C5E87
	Offset: 0xB18
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("zm_altbody_beast", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_altbody_beast
	Checksum: 0x4DAA56FE
	Offset: 0xB60
	Size: 0x5B2
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("missile", "bminteract", 1, 2, "int");
	clientfield::register("scriptmover", "bminteract", 1, 2, "int");
	clientfield::register("actor", "bm_zombie_melee_kill", 1, 1, "int");
	clientfield::register("actor", "bm_zombie_grapple_kill", 1, 1, "int");
	clientfield::register("toplayer", "beast_blood_on_player", 1, 1, "counter");
	clientfield::register("world", "bm_superbeast", 1, 1, "int");
	level thread function_10dcd1d5("beast_mode_kiosk");
	loadout = array("zombie_beast_grapple_dwr", "zombie_beast_lightning_dwl", "zombie_beast_lightning_dwl2", "zombie_beast_lightning_dwl3");
	beastmode_loadout = zm_weapons::create_loadout(loadout);
	var_55affbc1 = array("zm_bgb_disorderly_combat");
	zm_altbody::init("beast_mode", "beast_mode_kiosk", &"ZM_ZOD_ENTER_BEAST_MODE", "zombie_beast_2", 123, beastmode_loadout, 4, &player_enter_beastmode, &player_exit_beastmode, &player_allow_beastmode, &"ZM_ZOD_CANT_ENTER_BEAST_MODE", var_55affbc1);
	callback::on_connect(&player_on_connect);
	callback::on_spawned(&player_on_spawned);
	callback::on_player_killed(&player_on_killed);
	level.var_87ee6f27 = 4;
	level._effect["human_disappears"] = "zombie/fx_bmode_transition_zmb";
	level._effect["zombie_disappears"] = "zombie/fx_bmode_transition_zmb";
	level._effect["beast_shock"] = "zombie/fx_tesla_shock_zmb";
	level._effect["beast_shock_box"] = "zombie/fx_bmode_dest_pwrbox_zod_zmb";
	level._effect["beast_melee_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_grapple_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_return_aoe"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_return_aoe_kill"] = "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_shock_aoe"] = "zombie/fx_bmode_shock_lvl3_zod_zmb";
	level._effect["beast_3p_trail"] = "zombie/fx_bmode_trail_3p_zod_zmb";
	level.grapple_valid_target_check = &grapple_valid_target_check;
	level.get_grapple_targets = &get_grapple_targets;
	level.grapple_notarget_distance = 120;
	level.grapple_notarget_enabled = 0;
	zm_spawner::register_zombie_damage_callback(&lightning_zombie_damage_response);
	zm_spawner::register_zombie_death_event_callback(&beast_mode_death_watch);
	/#
		thread beastmode_devgui();
	#/
	triggers = getentarray("trig_beast_mode_kiosk", "targetname");
	foreach(var_a8b601f9, trigger in triggers)
	{
		trigger delete();
	}
	triggers = getentarray("trig_beast_mode_kiosk_unavailable", "targetname");
	foreach(var_66c26606, trigger in triggers)
	{
		trigger delete();
	}
}

/*
	Name: __main__
	Namespace: zm_altbody_beast
	Checksum: 0x9F6A4B4C
	Offset: 0x1120
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	thread watch_round_start_mana();
	thread hide_ooze_triggers();
	thread kiosk_cooldown();
	thread function_7de05274();
	zm_spawner::add_custom_zombie_spawn_logic(&zombie_on_spawn);
	function_3e9ddcc7();
	level.var_f68f0aeb = getweapon("syrette_zod_beast");
}

/*
	Name: player_cover_transition
	Namespace: zm_altbody_beast
	Checksum: 0x6948187D
	Offset: 0x11C0
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function player_cover_transition(extra_time = 0)
{
}

/*
	Name: player_disappear_in_flash
	Namespace: zm_altbody_beast
	Checksum: 0x23858842
	Offset: 0x11E8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function player_disappear_in_flash(washuman)
{
	self ghost();
}

/*
	Name: player_enter_beastmode
	Namespace: zm_altbody_beast
	Checksum: 0x951F79E5
	Offset: 0x1218
	Size: 0x5C4
	Parameters: 2
	Flags: Linked
*/
function player_enter_beastmode(name, trigger)
{
	/#
		assert(!(isdefined(self.beastmode) && self.beastmode));
	#/
	self notify(#"clear_red_flashing_overlay");
	self disableoffhandweapons();
	self zm_weapons::suppress_stowed_weapon(1);
	self player_give_mana(1);
	self player_take_lives(1);
	self.beast_mode_return_origin = self.var_b2356a6c;
	self.beast_mode_return_angles = self.var_227fe352;
	self zm_utility::create_streamer_hint(self.origin, self.angles + vectorscale((0, 1, 0), 180), 0.25);
	self thread player_cover_transition();
	self playsound("evt_beastmode_enter");
	if(!isdefined(self.firsttime))
	{
		self.firsttime = 1;
		level.var_9ecbc81 = self.characterindex;
		level notify(#"hash_571c8e3c");
	}
	self player_disappear_in_flash(1);
	self.overrideplayerdamage_original = self.overrideplayerdamage;
	self.overrideplayerdamage = &player_damage_override_beast_mode;
	self.weaponrevivetool = level.var_f68f0aeb;
	self.get_revive_time = &player_get_revive_time;
	self zm_utility::increment_ignoreme();
	self.beastmode = 1;
	self.inhibit_scoring_from_zombies = 1;
	self flag::set("in_beastmode");
	bb::function_e367a93e(self, "enter_beast_mode");
	self recordmapevent(1, gettime(), self.origin, level.round_number);
	self allowstand(1);
	self allowprone(0);
	self allowcrouch(0);
	self allowads(0);
	self allowjump(1);
	self allowslide(0);
	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
	self player_update_beast_mode_objects(1);
	self zm_utility::increment_is_drinking();
	self stopshellshock();
	self setperk("specialty_unlimitedsprint");
	self setperk("specialty_fallheight");
	self setperk("specialty_lowgravity");
	wait(0.1);
	self show();
	self thread player_watch_melee();
	self thread player_watch_melee_juke();
	self thread player_watch_melee_power();
	self thread player_watch_melee_charge();
	self thread player_watch_lightning();
	self thread player_watch_grapple();
	self thread player_watch_grappled_zombies();
	self thread player_watch_grappled_object();
	self thread player_kill_grappled_zombies();
	self thread player_watch_grapple_traverse();
	self thread player_watch_cancel();
	self thread function_92acebd3();
	if(level clientfield::get("bm_superbeast"))
	{
		self function_5c185b9f();
	}
	/#
		scr_beast_no_visionset = getdvarint("") > 0;
		self thread function_5d7a94fa();
	#/
}

/*
	Name: function_5d7a94fa
	Namespace: zm_altbody_beast
	Checksum: 0xAC0B168C
	Offset: 0x17E8
	Size: 0x18A
	Parameters: 1
	Flags: Linked
*/
function function_5d7a94fa(localclientnum)
{
	self endon(#"player_exit_beastmode");
	var_3f39d2cc = 0;
	while(isdefined(self))
	{
		scr_beast_no_visionset = getdvarint("scr_beast_no_visionset") > 0;
		if(scr_beast_no_visionset != var_3f39d2cc)
		{
			name = "beast_mode";
			visionset = "zombie_beast_2";
			if(scr_beast_no_visionset)
			{
				if(isdefined(visionset))
				{
					visionset_mgr::deactivate("visionset", visionset, self);
					self.altbody_visionset[name] = 0;
				}
			}
			else if(isdefined(visionset))
			{
				if(isdefined(self.altbody_visionset[name]) && self.altbody_visionset[name])
				{
					visionset_mgr::deactivate("visionset", visionset, self);
					util::wait_network_frame();
					util::wait_network_frame();
					if(!isdefined(self))
					{
						return;
					}
				}
				visionset_mgr::activate("visionset", visionset, self);
				self.altbody_visionset[name] = 1;
			}
		}
		var_3f39d2cc = scr_beast_no_visionset;
		wait(1);
	}
}

/*
	Name: function_5c185b9f
	Namespace: zm_altbody_beast
	Checksum: 0xD776B18
	Offset: 0x1980
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_5c185b9f()
{
	self zm_utility::decrement_ignoreme();
	self.var_e3e3d706 = 1;
	self.var_ff6ba411 = 1;
	self.var_ce25e278 = 1;
	self.var_1333176 = &function_57c301a6;
	self disableinvulnerability();
	self thread function_f3cafba8();
	bb::function_e367a93e(self, "enter_superbeast_mode");
	self recordmapevent(2, gettime(), self.origin, level.round_number);
}

/*
	Name: function_57c301a6
	Namespace: zm_altbody_beast
	Checksum: 0x889B4317
	Offset: 0x1A60
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function function_57c301a6(trigger, name)
{
	level notify(#"kiosk_used", trigger.kiosk);
	self.var_e3e3d706 = 1;
	self player_update_beast_mode_objects(1);
}

/*
	Name: function_f3cafba8
	Namespace: zm_altbody_beast
	Checksum: 0xEE3DAED4
	Offset: 0x1AC8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_f3cafba8()
{
	self endon(#"player_exit_beastmode");
	while(isdefined(self))
	{
		self.beastmana = self.var_e3e3d706;
		wait(0.05);
	}
}

/*
	Name: player_exit_beastmode
	Namespace: zm_altbody_beast
	Checksum: 0xC48B8418
	Offset: 0x1B08
	Size: 0x3A4
	Parameters: 2
	Flags: Linked
*/
function player_exit_beastmode(name, trigger)
{
	/#
		assert(isdefined(self.beastmode) && self.beastmode);
	#/
	self notify(#"clear_red_flashing_overlay");
	self thread player_cover_transition(0);
	self player_disappear_in_flash(0);
	self player_update_beast_mode_objects(0);
	if(self isthrowinggrenade())
	{
		self forcegrenadethrow();
	}
	if(0)
	{
		wait(0);
	}
	self notify(#"player_exit_beastmode");
	bb::function_e367a93e(self, "exit_beast_mode");
	self thread wait_invulnerable(2);
	self thread wait_enable_offhand_weapons(3);
	while(self isthrowinggrenade() || self isgrappling() || (isdefined(self.teleporting) && self.teleporting))
	{
		wait(0.05);
	}
	self unsetperk("specialty_unlimitedsprint");
	self unsetperk("specialty_fallheight");
	self unsetperk("specialty_lowgravity");
	self setmovespeedscale(1);
	self allowstand(1);
	self allowprone(1);
	self allowcrouch(1);
	self allowads(1);
	self allowjump(1);
	self allowdoublejump(0);
	self allowslide(1);
	self stopshellshock();
	self.inhibit_scoring_from_zombies = 0;
	self.beastmode = 0;
	self flag::clear("in_beastmode");
	self.get_revive_time = undefined;
	self.weaponrevivetool = undefined;
	self.overrideplayerdamage = self.overrideplayerdamage_original;
	self.overrideplayerdamage_original = undefined;
	if(level clientfield::get("bm_superbeast"))
	{
		var_66a6ef71 = 1;
		self.var_e3e3d706 = 0;
		self.var_ff6ba411 = 0;
		self.var_ce25e278 = 0;
		self.var_1333176 = undefined;
	}
	else
	{
		var_66a6ef71 = 0;
	}
	self thread wait_and_appear(var_66a6ef71);
}

/*
	Name: wait_and_appear
	Namespace: zm_altbody_beast
	Checksum: 0x1617416E
	Offset: 0x1EB8
	Size: 0x644
	Parameters: 1
	Flags: Linked
*/
function wait_and_appear(var_ee3c4cad)
{
	self setorigin(self.beast_mode_return_origin);
	self freezecontrols(1);
	v_return_pos = self.beast_mode_return_origin + vectorscale((0, 0, 1), 60);
	a_ai = getaiteamarray(level.zombie_team);
	a_closest = [];
	ai_closest = undefined;
	if(a_ai.size)
	{
		a_closest = arraysortclosest(a_ai, self.beast_mode_return_origin);
		foreach(var_cd97797e, ai in a_closest)
		{
			n_trace_val = ai sightconetrace(v_return_pos, self);
			if(n_trace_val > 0.2)
			{
				ai_closest = ai;
				break;
			}
		}
		if(isdefined(ai_closest))
		{
			self setplayerangles(vectortoangles(ai_closest getcentroid() - v_return_pos));
		}
	}
	/#
		if(getdvarint("") > 1)
		{
			ai_closest = self;
			self enableinvulnerability();
		}
	#/
	if(!isdefined(ai_closest))
	{
		self setplayerangles(self.beast_mode_return_angles + vectorscale((0, 1, 0), 180));
	}
	wait(0.5);
	self zm_utility::decrement_is_drinking();
	self zm_weapons::suppress_stowed_weapon(0);
	self show();
	self playsound("evt_beastmode_exit");
	self zm_utility::clear_streamer_hint();
	playfx(level._effect["human_disappears"], self.beast_mode_return_origin);
	playfx(level._effect["beast_return_aoe"], self.beast_mode_return_origin);
	a_ai = getaiarray();
	a_aoe_ai = arraysortclosest(a_ai, self.beast_mode_return_origin, a_ai.size, 0, 200);
	foreach(var_6a0695f6, ai in a_aoe_ai)
	{
		if(isactor(ai))
		{
			if(ai.archetype === "zombie")
			{
				playfx(level._effect["beast_return_aoe_kill"], ai gettagorigin("j_spineupper"));
			}
			else
			{
				playfx(level._effect["beast_return_aoe_kill"], ai.origin);
			}
			ai.no_powerups = 1;
			ai.marked_for_recycle = 1;
			ai.has_been_damaged_by_player = 0;
			ai.deathpoints_already_given = 1;
			ai dodamage(ai.health + 1000, self.beast_mode_return_origin, self);
		}
	}
	wait(0.2);
	if(!self zm::in_life_brush() && (self zm::in_kill_brush() || !self zm::in_enabled_playable_area()))
	{
		wait(3);
	}
	if(isdefined(self.firsttime) && self.firsttime)
	{
		self.firsttime = 0;
	}
	if(!level.intermission)
	{
		self freezecontrols(0);
	}
	wait(3);
	var_a315b31f = level clientfield::get("bm_superbeast");
	if(!var_ee3c4cad && !var_a315b31f)
	{
		self zm_utility::decrement_ignoreme();
	}
	level notify(#"hash_43352218", self);
	self thread zm_audio::create_and_play_dialog("beastmode", "exit");
}

/*
	Name: wait_invulnerable
	Namespace: zm_altbody_beast
	Checksum: 0xC0A4AB60
	Offset: 0x2508
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function wait_invulnerable(time)
{
	was_inv = self enableinvulnerability();
	wait(time);
	if(isdefined(self) && (!(isdefined(was_inv) && was_inv)))
	{
		self disableinvulnerability();
	}
}

/*
	Name: wait_enable_offhand_weapons
	Namespace: zm_altbody_beast
	Checksum: 0x3ECB7F90
	Offset: 0x2578
	Size: 0x170
	Parameters: 1
	Flags: Linked
*/
function wait_enable_offhand_weapons(time)
{
	self disableoffhandweapons();
	wait(time);
	if(isdefined(self))
	{
		self enableoffhandweapons();
	}
	if(isdefined(self.beast_grenades_missed) && self.beast_grenades_missed)
	{
		lethal_grenade = self zm_utility::get_player_lethal_grenade();
		if(!self hasweapon(lethal_grenade))
		{
			self giveweapon(lethal_grenade);
			self setweaponammoclip(lethal_grenade, 0);
		}
		frac = self getfractionmaxammo(lethal_grenade);
		if(frac < 0.25)
		{
			self setweaponammoclip(lethal_grenade, 2);
		}
		else if(frac < 0.5)
		{
			self setweaponammoclip(lethal_grenade, 3);
		}
		else
		{
			self setweaponammoclip(lethal_grenade, 4);
		}
	}
	self.beast_grenades_missed = 0;
}

/*
	Name: player_allow_beastmode
	Namespace: zm_altbody_beast
	Checksum: 0xD0755861
	Offset: 0x26F0
	Size: 0xE8
	Parameters: 2
	Flags: Linked
*/
function player_allow_beastmode(name, kiosk)
{
	var_a315b31f = level clientfield::get("bm_superbeast");
	if(!level flagsys::get("start_zombie_round_logic"))
	{
		return 0;
	}
	if(isdefined(self.beastmode) && self.beastmode && !var_a315b31f)
	{
		return 0;
	}
	if(isdefined(kiosk) && !kiosk_allowed(kiosk))
	{
		return 0;
	}
	if(level clientfield::get("bm_superbeast"))
	{
		return 1;
	}
	return self.beastlives >= 1;
}

/*
	Name: kiosk_allowed
	Namespace: zm_altbody_beast
	Checksum: 0xEDC001EB
	Offset: 0x27E0
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function kiosk_allowed(kiosk)
{
	return !(isdefined(kiosk.is_cooling_down) && kiosk.is_cooling_down);
}

/*
	Name: player_on_connect
	Namespace: zm_altbody_beast
	Checksum: 0x124C36E8
	Offset: 0x2818
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function player_on_connect()
{
	self flag::init("in_beastmode");
}

/*
	Name: player_on_spawned
	Namespace: zm_altbody_beast
	Checksum: 0xAFA1D322
	Offset: 0x2848
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function player_on_spawned()
{
	level flag::wait_till("initial_players_connected");
	self.beastmana = 1;
	if(level flag::get("solo_game"))
	{
		self.beastlives = 3;
	}
	else
	{
		self.beastlives = 1;
	}
	self thread update_kiosk_effects();
	self thread player_watch_mana();
	self player_update_beast_mode_objects(0);
}

/*
	Name: function_7de05274
	Namespace: zm_altbody_beast
	Checksum: 0x34C86644
	Offset: 0x2910
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_7de05274()
{
	while(true)
	{
		level waittill(#"powerup_dropped", powerup);
		powerup.grapple_type = 2;
		powerup setgrapplabletype(powerup.grapple_type);
	}
}

/*
	Name: function_10dcd1d5
	Namespace: zm_altbody_beast
	Checksum: 0x2BF244E
	Offset: 0x2978
	Size: 0x14A
	Parameters: 1
	Flags: Linked
*/
function function_10dcd1d5(var_4cc12170)
{
	level.var_8ad0ec05 = struct::get_array(var_4cc12170, "targetname");
	foreach(var_35de897, kiosk in level.var_8ad0ec05)
	{
		kiosk.var_80eeb471 = var_4cc12170 + "_plr_" + kiosk.origin;
		kiosk.var_39a60f4a = var_4cc12170 + "_crs_" + kiosk.origin;
		clientfield::register("world", kiosk.var_80eeb471, 1, 4, "int");
		kiosk thread _kiosk_cooldown();
	}
}

/*
	Name: update_kiosk_effects
	Namespace: zm_altbody_beast
	Checksum: 0xE13FC731
	Offset: 0x2AD0
	Size: 0x168
	Parameters: 0
	Flags: Linked
*/
function update_kiosk_effects()
{
	self endon(#"death");
	while(isdefined(self))
	{
		n_ent_num = self getentitynumber();
		foreach(var_46e583b4, kiosk in level.var_8ad0ec05)
		{
			n_players_allowed = level clientfield::get(kiosk.var_80eeb471);
			if(kiosk_allowed(kiosk))
			{
				n_players_allowed = n_players_allowed | 1 << n_ent_num;
			}
			else
			{
				~n_players_allowed;
				n_players_allowed = n_players_allowed & 1 << n_ent_num;
			}
			level clientfield::set(kiosk.var_80eeb471, n_players_allowed);
		}
		wait(randomfloatrange(0.2, 0.5));
	}
}

/*
	Name: function_61dc030a
	Namespace: zm_altbody_beast
	Checksum: 0x9C35D71A
	Offset: 0x2C40
	Size: 0xA6
	Parameters: 0
	Flags: None
*/
function function_61dc030a()
{
	var_ff430db0 = 0;
	foreach(var_c5cf7f78, kiosk in level.var_8ad0ec05)
	{
		if(kiosk_allowed(kiosk))
		{
			var_ff430db0++;
		}
	}
	return var_ff430db0;
}

/*
	Name: function_f6014f2c
	Namespace: zm_altbody_beast
	Checksum: 0x4ABCEC3B
	Offset: 0x2CF0
	Size: 0xF6
	Parameters: 2
	Flags: Linked
*/
function function_f6014f2c(v_origin, var_8ebf7724)
{
	a_kiosks = arraysortclosest(level.var_8ad0ec05, v_origin);
	a_kiosks = array::filter(a_kiosks, 0, &function_b7520b09);
	for(i = 0; i < a_kiosks.size && i < var_8ebf7724; i++)
	{
		zm_zod_util::function_5cc835d6(v_origin, a_kiosks[i].origin, 1);
		a_kiosks[i].is_cooling_down = 0;
		wait(0.05);
	}
}

/*
	Name: function_b7520b09
	Namespace: zm_altbody_beast
	Checksum: 0xE9206972
	Offset: 0x2DF0
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function function_b7520b09(var_20fdcbbc)
{
	if(!isdefined(var_20fdcbbc) || !isdefined(var_20fdcbbc.is_cooling_down) || !var_20fdcbbc.is_cooling_down)
	{
		return 0;
	}
	return 1;
}

/*
	Name: kiosk_cooldown
	Namespace: zm_altbody_beast
	Checksum: 0x652DC63A
	Offset: 0x2E40
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function kiosk_cooldown()
{
	while(true)
	{
		level waittill(#"kiosk_used", e_kiosk);
		if(isdefined(e_kiosk))
		{
			e_kiosk thread _kiosk_cooldown();
		}
	}
}

/*
	Name: round_number
	Namespace: zm_altbody_beast
	Checksum: 0x3B7A2C2F
	Offset: 0x2E90
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function round_number()
{
	n_start_round = 0;
	if(isdefined(level.round_number))
	{
		n_start_round = level.round_number;
	}
	return n_start_round;
}

/*
	Name: _kiosk_cooldown
	Namespace: zm_altbody_beast
	Checksum: 0xA7E37804
	Offset: 0x2EC8
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function _kiosk_cooldown()
{
	self notify(#"_kiosk_cooldown");
	self endon(#"_kiosk_cooldown");
	self.is_cooling_down = 1;
	n_start_round = round_number();
	while(round_number() - n_start_round < 1)
	{
		level waittill(#"start_of_round");
	}
	self.is_cooling_down = 0;
}

/*
	Name: function_fd8fb00d
	Namespace: zm_altbody_beast
	Checksum: 0x2AF48D55
	Offset: 0x2F58
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function function_fd8fb00d(var_a48bee9b = 1)
{
	foreach(var_8f2ca8b6, kiosk in level.var_8ad0ec05)
	{
		if(var_a48bee9b)
		{
			if(!(isdefined(kiosk.is_cooling_down) && kiosk.is_cooling_down))
			{
				kiosk thread _kiosk_cooldown();
			}
			continue;
		}
		if(isdefined(kiosk.is_cooling_down) && kiosk.is_cooling_down)
		{
			kiosk.is_cooling_down = 0;
		}
	}
}

/*
	Name: player_watch_cancel
	Namespace: zm_altbody_beast
	Checksum: 0xF193C9DA
	Offset: 0x3070
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function player_watch_cancel()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	if(!self flag::exists("beast_hint_shown"))
	{
		self flag::init("beast_hint_shown");
	}
	if(!self flag::get("beast_hint_shown"))
	{
		self thread beast_cancel_hint();
	}
	self.beast_cancel_timer = 0;
	while(isdefined(self))
	{
		if(self stancebuttonpressed())
		{
			self notify(#"hide_equipment_hint_text");
			self player_stance_hold_think();
		}
		wait(0.05);
	}
}

/*
	Name: beast_cancel_hint
	Namespace: zm_altbody_beast
	Checksum: 0xF6B53B9C
	Offset: 0x3158
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function beast_cancel_hint()
{
	hint = &"ZM_ZOD_EXIT_BEAST_MODE_HINT";
	y = 315;
	if(level.players.size > 1)
	{
		hint = &"ZM_ZOD_EXIT_BEAST_MODE_HINT_COOP";
		y = 285;
	}
	self thread function_371979a2(12, 12.05);
	self thread function_59ecc704(12, 12.05);
	zm_equipment::show_hint_text(hint, 12.05, 1.5, y);
}

/*
	Name: function_371979a2
	Namespace: zm_altbody_beast
	Checksum: 0x36FDECEB
	Offset: 0x3220
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function function_371979a2(mintime, maxtime)
{
	self endon(#"disconnect");
	self util::waittill_any_timeout(maxtime, "smashable_smashed", "grapplable_grappled", "shockable_shocked", "disconnect");
	self flag::set("beast_hint_shown");
}

/*
	Name: function_59ecc704
	Namespace: zm_altbody_beast
	Checksum: 0xD3825F44
	Offset: 0x32A0
	Size: 0x62
	Parameters: 2
	Flags: Linked
*/
function function_59ecc704(mintime, maxtime)
{
	self endon(#"disconnect");
	wait(mintime);
	if(isdefined(self))
	{
		self flag::wait_till_timeout(maxtime - mintime, "beast_hint_shown");
		self notify(#"hide_equipment_hint_text");
	}
}

/*
	Name: player_stance_hold_think
	Namespace: zm_altbody_beast
	Checksum: 0xF3D55F35
	Offset: 0x3310
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function player_stance_hold_think()
{
	self thread player_stance_hold_think_internal();
	retval = self util::waittill_any_return("exit_succeed", "exit_failed");
	if(retval == "exit_succeed")
	{
		self notify(#"altbody_end");
		return 1;
	}
	self.beast_cancel_timer = 0;
	return 0;
}

/*
	Name: function_92acebd3
	Namespace: zm_altbody_beast
	Checksum: 0x2D958236
	Offset: 0x33A0
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function function_92acebd3()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	self waittill(#"player_did_a_revive");
	self playrumbleonentity("damage_heavy");
	wait(1.5);
	self player_take_mana(1);
	self notify(#"altbody_end");
}

/*
	Name: player_continue_cancel
	Namespace: zm_altbody_beast
	Checksum: 0xE613F32B
	Offset: 0x3428
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function player_continue_cancel()
{
	if(self isthrowinggrenade())
	{
		return 0;
	}
	if(!self stancebuttonpressed())
	{
		return 0;
	}
	if(isdefined(self.teleporting) && self.teleporting)
	{
		return 0;
	}
	return 1;
}

/*
	Name: player_stance_hold_think_internal
	Namespace: zm_altbody_beast
	Checksum: 0xEE455655
	Offset: 0x3490
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function player_stance_hold_think_internal()
{
	wait(0.05);
	if(!isdefined(self))
	{
		self notify(#"exit_failed");
		return;
	}
	self.beast_cancel_timer = gettime();
	build_time = 1000;
	self thread player_beast_cancel_bar(self.beast_cancel_timer, build_time);
	while(isdefined(self) && self player_continue_cancel() && gettime() - self.beast_cancel_timer < build_time)
	{
		wait(0.05);
	}
	if(isdefined(self) && self player_continue_cancel() && gettime() - self.beast_cancel_timer >= build_time)
	{
		self notify(#"exit_succeed");
	}
	else
	{
		self notify(#"exit_failed");
	}
}

/*
	Name: player_beast_cancel_bar
	Namespace: zm_altbody_beast
	Checksum: 0x69CF82F1
	Offset: 0x3590
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function player_beast_cancel_bar(start_time, build_time)
{
	self.usebar = self hud::createprimaryprogressbar();
	self.usebartext = self hud::createprimaryprogressbartext();
	self.usebartext settext(&"ZM_ZOD_EXIT_BEAST_MODE");
	self player_progress_bar_update(start_time, build_time);
	self.usebartext hud::destroyelem();
	self.usebar hud::destroyelem();
}

/*
	Name: player_progress_bar_update
	Namespace: zm_altbody_beast
	Checksum: 0x1B7C2C19
	Offset: 0x3660
	Size: 0xD0
	Parameters: 2
	Flags: Linked
*/
function player_progress_bar_update(start_time, build_time)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"player_exit_beastmode");
	self endon(#"exit_failed");
	while(isdefined(self) && gettime() - start_time < build_time)
	{
		progress = gettime() - start_time / build_time;
		if(progress < 0)
		{
			progress = 0;
		}
		if(progress > 1)
		{
			progress = 1;
		}
		self.usebar hud::updatebar(progress);
		wait(0.05);
	}
}

/*
	Name: player_take_mana
	Namespace: zm_altbody_beast
	Checksum: 0xE16133D8
	Offset: 0x3738
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function player_take_mana(mana)
{
	self.beastmana = self.beastmana - mana;
	if(self.beastmana <= 0)
	{
		self.beastmana = 0;
		self notify(#"altbody_end");
	}
}

/*
	Name: player_give_lives
	Namespace: zm_altbody_beast
	Checksum: 0xDCF78A2C
	Offset: 0x3798
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function player_give_lives(lives)
{
	self.beastlives = self.beastlives + lives;
	if(level flag::get("solo_game"))
	{
		if(self.beastlives > 3)
		{
			self.beastlives = 3;
		}
	}
	else if(self.beastlives > 1)
	{
		self.beastlives = 1;
	}
}

/*
	Name: player_take_lives
	Namespace: zm_altbody_beast
	Checksum: 0xC75E794E
	Offset: 0x3820
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function player_take_lives(lives)
{
	self.beastlives = self.beastlives - lives;
	if(self.beastmana <= 0)
	{
		self.beastlives = 0;
	}
}

/*
	Name: player_give_mana
	Namespace: zm_altbody_beast
	Checksum: 0x456C4FC5
	Offset: 0x3860
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function player_give_mana(mana)
{
	self.beastmana = self.beastmana + mana;
	if(self.beastmana > 1)
	{
		self.beastmana = 1;
	}
}

/*
	Name: player_get_revive_time
	Namespace: zm_altbody_beast
	Checksum: 0x66739CD9
	Offset: 0x38B0
	Size: 0x12
	Parameters: 1
	Flags: Linked
*/
function player_get_revive_time(player_being_revived)
{
	return 0.75;
}

/*
	Name: player_damage_override_beast_mode
	Namespace: zm_altbody_beast
	Checksum: 0x338AEC33
	Offset: 0x38D0
	Size: 0x1FE
	Parameters: 10
	Flags: Linked
*/
function player_damage_override_beast_mode(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime)
{
	if(isdefined(eattacker) && isplayer(eattacker))
	{
		return 0;
	}
	var_a315b31f = level clientfield::get("bm_superbeast");
	if(var_a315b31f)
	{
		var_cc3794d8 = idamage * 0.0005;
		if(var_cc3794d8 > 0.4)
		{
			var_cc3794d8 = 0.4;
			self thread zm_zod_util::set_rumble_to_player(3);
		}
		else
		{
			self thread zm_zod_util::set_rumble_to_player(2);
		}
		self.var_e3e3d706 = self.var_e3e3d706 - var_cc3794d8;
		if(self.var_e3e3d706 <= 0)
		{
			self notify(#"altbody_end");
			self player_take_mana(1);
			self.beastlives = 1;
		}
		return 0;
	}
	if(isdefined(eattacker) && (isdefined(eattacker.is_zombie) && eattacker.is_zombie || eattacker.team === level.zombie_team))
	{
		return 0;
	}
	if(idamage < self.health)
	{
		return 0;
	}
	self notify(#"altbody_end");
	self player_take_mana(1);
	return 0;
}

/*
	Name: player_check_grenades
	Namespace: zm_altbody_beast
	Checksum: 0x31104357
	Offset: 0x3AD8
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function player_check_grenades()
{
	if(isdefined(self.beastmode) && self.beastmode)
	{
		self.beast_grenades_missed = 1;
	}
}

/*
	Name: watch_round_start_mana
	Namespace: zm_altbody_beast
	Checksum: 0x9DD5268E
	Offset: 0x3B08
	Size: 0x19E
	Parameters: 0
	Flags: Linked
*/
function watch_round_start_mana()
{
	level waittill(#"start_of_round");
	foreach(var_eb05ab1e, player in getplayers())
	{
		player player_check_grenades();
	}
	while(true)
	{
		level waittill(#"start_of_round");
		foreach(var_ab90ad3c, player in getplayers())
		{
			if(!(isdefined(player.beastmode) && player.beastmode))
			{
				player player_give_mana(1);
			}
			player player_give_lives(1);
			player player_check_grenades();
		}
	}
}

/*
	Name: player_watch_mana
	Namespace: zm_altbody_beast
	Checksum: 0x7D4503F1
	Offset: 0x3CB0
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function player_watch_mana()
{
	if(!isdefined(self.var_e3e3d706))
	{
		self.var_e3e3d706 = 0;
	}
	self notify(#"player_watch_mana");
	self endon(#"player_watch_mana");
	while(isdefined(self))
	{
		if(isdefined(level.hostmigrationtimer) && level.hostmigrationtimer)
		{
			wait(1);
			continue;
		}
		if(isdefined(self.beastmode) && self.beastmode && (!(isdefined(self.teleporting) && self.teleporting)))
		{
			self player_take_mana(1 / 500);
		}
		if(level clientfield::get("bm_superbeast"))
		{
			n_mapped_mana = math::linear_map(self.var_e3e3d706, 0, 1, 0, 1);
		}
		else
		{
			n_mapped_mana = math::linear_map(self.beastmana, 0, 1, 0, 1);
		}
		self clientfield::set_player_uimodel("player_mana", n_mapped_mana);
		lives = self.beastlives;
		if(lives != self clientfield::get_player_uimodel("player_lives"))
		{
			player_give_lives(0);
			lives = self.beastlives;
			self clientfield::set_player_uimodel("player_lives", lives);
		}
		wait(0.05);
	}
}

/*
	Name: player_on_killed
	Namespace: zm_altbody_beast
	Checksum: 0x12BFB3AD
	Offset: 0x3EB0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function player_on_killed()
{
	self notify(#"altbody_end");
	self player_take_mana(1);
}

/*
	Name: hide_ooze_triggers
	Namespace: zm_altbody_beast
	Checksum: 0xF77787BB
	Offset: 0x3EE8
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function hide_ooze_triggers()
{
	level flagsys::wait_till("start_zombie_round_logic");
	ooo = getentarray("ooze_only", "script_noteworthy");
	array::thread_all(ooo, &trigger_ooze_only);
	moo = getentarray("beast_melee_only", "script_noteworthy");
	array::thread_all(moo, &trigger_melee_only);
	goo = getentarray("beast_grapple_only", "script_noteworthy");
	array::thread_all(goo, &trigger_grapple_only);
}

/*
	Name: player_update_beast_mode_objects
	Namespace: zm_altbody_beast
	Checksum: 0xB2DB1481
	Offset: 0x4008
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function player_update_beast_mode_objects(onoff)
{
	bmo = getentarray("beast_mode", "script_noteworthy");
	if(isdefined(level.get_beast_mode_objects))
	{
		more_bmo = [[level.get_beast_mode_objects]]();
		bmo = arraycombine(bmo, more_bmo, 0, 0);
	}
	array::run_all(bmo, &entity_set_visible, self, onoff);
	bmho = getentarray("not_beast_mode", "script_noteworthy");
	if(isdefined(level.get_beast_mode_hide_objects))
	{
		more_bmho = [[level.get_beast_mode_hide_objects]]();
		bmho = arraycombine(bmho, more_bmho, 0, 0);
	}
	array::run_all(bmho, &entity_set_visible, self, !onoff);
}

/*
	Name: entity_set_visible
	Namespace: zm_altbody_beast
	Checksum: 0x83E9767
	Offset: 0x4158
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function entity_set_visible(player, onoff)
{
	if(onoff)
	{
		self setvisibletoplayer(player);
	}
	else
	{
		self setinvisibletoplayer(player);
	}
}

/*
	Name: player_watch_melee_charge
	Namespace: zm_altbody_beast
	Checksum: 0xCD3A3065
	Offset: 0x41B8
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function player_watch_melee_charge()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	while(isdefined(self))
	{
		self waittill(#"weapon_melee_charge", weapon);
		self notify(#"weapon_melee", weapon);
	}
}

/*
	Name: player_watch_melee_power
	Namespace: zm_altbody_beast
	Checksum: 0x2612113F
	Offset: 0x4218
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function player_watch_melee_power()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	while(isdefined(self))
	{
		self waittill(#"weapon_melee_power", weapon);
		self notify(#"weapon_melee", weapon);
	}
}

/*
	Name: player_watch_melee
	Namespace: zm_altbody_beast
	Checksum: 0xD92DA702
	Offset: 0x4278
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function player_watch_melee()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	while(isdefined(self))
	{
		self waittill(#"weapon_melee", weapon);
		if(weapon == getweapon("zombie_beast_grapple_dwr"))
		{
			self player_take_mana(0.03);
			forward = anglestoforward(self getplayerangles());
			up = anglestoup(self getplayerangles());
			var_1a423f4f = self.origin + 15 * up + 30 * forward;
			level notify(#"beast_melee", self, var_1a423f4f);
			self radiusdamage(var_1a423f4f, 48, 5000, 5000, self, "MOD_MELEE");
		}
	}
}

/*
	Name: player_watch_melee_juke
	Namespace: zm_altbody_beast
	Checksum: 0xA8E0104
	Offset: 0x43D0
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function player_watch_melee_juke()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	while(isdefined(self))
	{
		self waittill(#"weapon_melee_juke", weapon);
		if(weapon == getweapon("zombie_beast_grapple_dwr"))
		{
			player_beast_melee_juke(weapon);
		}
	}
}

/*
	Name: player_beast_melee_juke
	Namespace: zm_altbody_beast
	Checksum: 0xD972A214
	Offset: 0x4450
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function player_beast_melee_juke(weapon)
{
	self endon(#"weapon_melee");
	self endon(#"weapon_melee_power");
	self endon(#"weapon_melee_charge");
	start_time = gettime();
	while(start_time + 3000 > gettime())
	{
		self playrumbleonentity("zod_beast_juke");
		wait(0.1);
	}
}

/*
	Name: function_b484a03e
	Namespace: zm_altbody_beast
	Checksum: 0xB66EA038
	Offset: 0x44D0
	Size: 0x7A
	Parameters: 2
	Flags: Linked
*/
function function_b484a03e(var_1a423f4f, radius)
{
	mins = (radius * -1, radius * -1, radius * -1);
	maxs = (radius, radius, radius);
	return self istouchingvolume(var_1a423f4f, mins, maxs);
}

/*
	Name: trigger_melee_only
	Namespace: zm_altbody_beast
	Checksum: 0x1B4878ED
	Offset: 0x4558
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function trigger_melee_only()
{
	self endon(#"death");
	level flagsys::wait_till("start_zombie_round_logic");
	if(isdefined(self.target))
	{
		target = getent(self.target, "targetname");
		if(isdefined(target))
		{
			target enableaimassist();
		}
	}
	self setinvisibletoall();
	while(isdefined(self))
	{
		level waittill(#"beast_melee", player, var_1a423f4f);
		if(isdefined(self) && self function_b484a03e(var_1a423f4f, 48))
		{
			self useby(player);
		}
	}
}

/*
	Name: function_4c03fac9
	Namespace: zm_altbody_beast
	Checksum: 0x7C1ED15
	Offset: 0x4670
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function function_4c03fac9(weapon)
{
	if(!isdefined(weapon))
	{
		return 0;
	}
	if(weapon == getweapon("zombie_beast_lightning_dwl") || weapon == getweapon("zombie_beast_lightning_dwl2") || weapon == getweapon("zombie_beast_lightning_dwl3"))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_cebfc03f
	Namespace: zm_altbody_beast
	Checksum: 0x52374B7B
	Offset: 0x46F8
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function function_cebfc03f(weapon)
{
	if(!isdefined(weapon))
	{
		return 0;
	}
	if(weapon == getweapon("zombie_beast_lightning_dwl"))
	{
		return 1;
	}
	if(weapon == getweapon("zombie_beast_lightning_dwl2"))
	{
		return 2;
	}
	if(weapon == getweapon("zombie_beast_lightning_dwl3"))
	{
		return 3;
	}
	return 0;
}

/*
	Name: player_watch_lightning
	Namespace: zm_altbody_beast
	Checksum: 0xB9DDC1D7
	Offset: 0x4790
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function player_watch_lightning()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	self.tesla_enemies = undefined;
	self.tesla_enemies_hit = 0;
	self.tesla_powerup_dropped = 0;
	self.tesla_arc_count = 0;
	while(isdefined(self))
	{
		self waittill(#"weapon_fired", weapon);
		if(function_4c03fac9(weapon))
		{
			self player_take_mana(0);
		}
	}
}

/*
	Name: function_8ee03bb5
	Namespace: zm_altbody_beast
	Checksum: 0x3F65BA91
	Offset: 0x4838
	Size: 0x280
	Parameters: 1
	Flags: None
*/
function function_8ee03bb5(weapon)
{
	self endon(#"disconnect");
	self.tesla_enemies = undefined;
	self.tesla_enemies_hit = 0;
	self.tesla_powerup_dropped = 0;
	self.tesla_arc_count = 0;
	shocklevel = function_cebfc03f(weapon);
	var_96f81bff = 36;
	switch(shocklevel)
	{
		case 2:
		{
			var_96f81bff = 72;
			break;
		}
		case 3:
		{
			var_96f81bff = 108;
			break;
		}
	}
	forward = anglestoforward(self getplayerangles());
	up = anglestoup(self getplayerangles());
	center = self.origin + 16 * up + 24 * forward;
	if(shocklevel > 1)
	{
		playfx(level._effect["beast_shock_aoe"], center);
	}
	zombies = array::get_all_closest(center, getaiteamarray(level.zombie_team), undefined, undefined, var_96f81bff);
	foreach(var_edeff735, zombie in zombies)
	{
		zombie thread function_fe8a580e(zombie.origin, center, self, shocklevel);
		zombie notify(#"bhtn_action_notify", "electrocute");
	}
	wait(0.05);
	self.tesla_enemies_hit = 0;
}

/*
	Name: function_fe8a580e
	Namespace: zm_altbody_beast
	Checksum: 0xCCAE80DA
	Offset: 0x4AC0
	Size: 0xDC
	Parameters: 4
	Flags: Linked
*/
function function_fe8a580e(hit_location, hit_origin, player, shocklevel)
{
	player endon(#"disconnect");
	if(isdefined(self.zombie_tesla_hit) && self.zombie_tesla_hit)
	{
		return;
	}
	if(shocklevel < 2)
	{
		self lightning_chain::arc_damage(self, player, 1, level.var_3a2dca1e);
	}
	else if(shocklevel < 3)
	{
		self lightning_chain::arc_damage(self, player, 1, level.var_142b4fb5);
	}
	else
	{
		self lightning_chain::arc_damage(self, player, 1, level.var_ee28d54c);
	}
}

/*
	Name: function_3e9ddcc7
	Namespace: zm_altbody_beast
	Checksum: 0x34DC2009
	Offset: 0x4BA8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_3e9ddcc7()
{
	level.var_3a2dca1e = lightning_chain::create_lightning_chain_params(1);
	level.var_3a2dca1e.should_kill_enemies = 0;
	level.var_142b4fb5 = lightning_chain::create_lightning_chain_params(2);
	level.var_142b4fb5.should_kill_enemies = 0;
	level.var_142b4fb5.clientside_fx = 0;
	level.var_ee28d54c = lightning_chain::create_lightning_chain_params(3);
	level.var_ee28d54c.should_kill_enemies = 0;
	level.var_ee28d54c.clientside_fx = 0;
}

/*
	Name: get_grapple_targets
	Namespace: zm_altbody_beast
	Checksum: 0xFCF77A8B
	Offset: 0x4C78
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function get_grapple_targets()
{
	if(!isdefined(level.beast_mode_targets))
	{
		level.beast_mode_targets = [];
	}
	return level.beast_mode_targets;
}

/*
	Name: trigger_grapple_only
	Namespace: zm_altbody_beast
	Checksum: 0xF36560DD
	Offset: 0x4CA8
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function trigger_grapple_only()
{
	self endon(#"death");
	level flagsys::wait_till("start_zombie_round_logic");
	self setinvisibletoall();
	while(isdefined(self))
	{
		level waittill(#"grapple_hit", target, player);
		if(isdefined(self) && target istouching(self))
		{
			self useby(player);
		}
	}
}

/*
	Name: player_watch_grapple
	Namespace: zm_altbody_beast
	Checksum: 0x504693AB
	Offset: 0x4D60
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function player_watch_grapple()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	grapple = getweapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill(#"grapple_fired", weapon);
		if(weapon == grapple)
		{
			if(isdefined(self.lockonentity))
			{
				if(!self function_668dcfac(self.lockonentity))
				{
					self.lockonentity = undefined;
				}
			}
			self player_take_mana(0);
			self thread function_77a9a8f6(weapon, "zod_beast_grapple_out", 0.4);
		}
	}
}

/*
	Name: function_668dcfac
	Namespace: zm_altbody_beast
	Checksum: 0x287B2FC2
	Offset: 0x4E80
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function function_668dcfac(target)
{
	if(isdefined(target.var_deccd0c8) && target.var_deccd0c8)
	{
		return 0;
	}
	target.var_deccd0c8 = 1;
	self thread function_b8488073(target, 5);
	return 1;
}

/*
	Name: function_b8488073
	Namespace: zm_altbody_beast
	Checksum: 0x5D4ED013
	Offset: 0x4EF0
	Size: 0x104
	Parameters: 2
	Flags: Linked
*/
function function_b8488073(target, time)
{
	self util::waittill_any_timeout(time, "disconnect", "grapple_cancel", "player_exit_beastmode");
	if(isdefined(target))
	{
		target.var_deccd0c8 = undefined;
		if(isdefined(target.is_zombie) && target.is_zombie)
		{
			target dodamage(target.health + 1000, target.origin);
			if(!isvehicle(target))
			{
				target.no_powerups = 1;
				target.marked_for_recycle = 1;
				target.has_been_damaged_by_player = 0;
			}
		}
	}
}

/*
	Name: function_77a9a8f6
	Namespace: zm_altbody_beast
	Checksum: 0xF4CBDE7C
	Offset: 0x5000
	Size: 0x8E
	Parameters: 3
	Flags: Linked
*/
function function_77a9a8f6(weapon, rumble, length)
{
	self endon(#"grapple_stick");
	self endon(#"grapple_pulled");
	self endon(#"grapple_landed");
	self endon(#"grapple_cancel");
	start_time = gettime();
	while(start_time + 3000 > gettime())
	{
		self playrumbleonentity(rumble);
		wait(length);
	}
}

/*
	Name: grapple_valid_target_check
	Namespace: zm_altbody_beast
	Checksum: 0xBDA62C26
	Offset: 0x5098
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function grapple_valid_target_check(ent)
{
	if(!isvehicle(ent))
	{
		if(isdefined(ent.is_zombie) && ent.is_zombie)
		{
			if(!(isdefined(ent.completed_emerging_into_playable_area) && ent.completed_emerging_into_playable_area))
			{
				return 0;
			}
		}
	}
	return 1;
}

/*
	Name: zombie_on_spawn
	Namespace: zm_altbody_beast
	Checksum: 0xE2A8F73A
	Offset: 0x5118
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function zombie_on_spawn()
{
	self endon(#"death");
	self.grapple_type = 0;
	self setgrapplabletype(self.grapple_type);
	if(!isvehicle(self))
	{
		self waittill(#"completed_emerging_into_playable_area");
	}
	if(!isdefined(self))
	{
		return;
	}
	self.grapple_type = 2;
	self setgrapplabletype(self.grapple_type);
}

/*
	Name: player_watch_grappled_object
	Namespace: zm_altbody_beast
	Checksum: 0xF61B4941
	Offset: 0x51B8
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function player_watch_grappled_object()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	grapple = getweapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill(#"grapple_stick", weapon, target);
		if(weapon == grapple)
		{
			self notify(#"grapplable_grappled");
			self playrumbleonentity("zod_beast_grapple_hit");
			if(isdefined(target))
			{
				if(isdefined(target.is_zombie) && target.is_zombie)
				{
					target zombie_gets_pulled(self);
				}
			}
			level notify(#"grapple_hit", target, self, isdefined(self.pivotentity) && !isplayer(self.pivotentity));
			playsoundatposition("wpn_beastmode_grapple_imp", target.origin);
		}
	}
}

/*
	Name: player_watch_grapple_traverse
	Namespace: zm_altbody_beast
	Checksum: 0xBFDD6FB0
	Offset: 0x5310
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function player_watch_grapple_traverse()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	grapple = getweapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill(#"grapple_reelin", weapon, target);
		if(weapon == grapple)
		{
			origin = target.origin;
			self thread player_watch_grapple_landing(origin);
			self playsound("wpn_beastmode_grapple_pullin");
			wait(0.15);
			self thread function_77a9a8f6(weapon, "zod_beast_grapple_reel", 0.2);
		}
	}
}

/*
	Name: player_watch_grapple_landing
	Namespace: zm_altbody_beast
	Checksum: 0xCDE95143
	Offset: 0x5418
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function player_watch_grapple_landing(origin)
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	self notify(#"player_watch_grapple_landing");
	self endon(#"player_watch_grapple_landing");
	self waittill(#"grapple_landed", weapon, target);
	if(distance2dsquared(self.origin, origin) > 1024)
	{
		self setorigin(origin + vectorscale((0, 0, -1), 60));
	}
}

/*
	Name: player_watch_grappled_zombies
	Namespace: zm_altbody_beast
	Checksum: 0x47D11806
	Offset: 0x54D0
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function player_watch_grappled_zombies()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	grapple = getweapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill(#"grapple_pullin", weapon, target);
		if(weapon == grapple)
		{
			wait(0.15);
			self thread function_77a9a8f6(weapon, "zod_beast_grapple_pull", 0.2);
		}
	}
}

/*
	Name: player_kill_grappled_zombies
	Namespace: zm_altbody_beast
	Checksum: 0x861E5BB1
	Offset: 0x5588
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function player_kill_grappled_zombies()
{
	self endon(#"player_exit_beastmode");
	self endon(#"death");
	grapple = getweapon("zombie_beast_grapple_dwr");
	while(isdefined(self))
	{
		self waittill(#"grapple_pulled", weapon, target);
		if(weapon == grapple)
		{
			if(isdefined(target))
			{
				if(isdefined(target.is_zombie) && target.is_zombie)
				{
				}
				else if(isdefined(target.powerup_name))
				{
					target.origin = self.origin;
				}
			}
		}
	}
}

/*
	Name: zombie_gets_pulled
	Namespace: zm_altbody_beast
	Checksum: 0xD22F52EF
	Offset: 0x5668
	Size: 0x214
	Parameters: 1
	Flags: Linked
*/
function zombie_gets_pulled(player)
{
	self.grapple_is_fatal = 1;
	var_4361c12b = player.origin - self.origin;
	var_168907b4 = vectornormalize((var_4361c12b[0], var_4361c12b[1], 0));
	zombie_forward = anglestoforward(self.angles);
	zombie_forward_2d = vectornormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = anglestoright(self.angles);
	zombie_right_2d = vectornormalize((zombie_right[0], zombie_right[1], 0));
	dot = vectordot(var_168907b4, zombie_forward_2d);
	if(dot >= 0.5)
	{
		self.grapple_direction = "front";
	}
	else if(dot < 0.5 && dot > -0.5)
	{
		dot = vectordot(var_168907b4, zombie_right_2d);
		if(dot > 0)
		{
			self.grapple_direction = "right";
		}
		else
		{
			self.grapple_direction = "left";
		}
	}
	else
	{
		self.grapple_direction = "back";
	}
	self thread function_d4252c93(player);
}

/*
	Name: function_d4252c93
	Namespace: zm_altbody_beast
	Checksum: 0x7978A822
	Offset: 0x5888
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function function_d4252c93(player)
{
	player util::waittill_any_timeout(2.5, "disconnect", "grapple_pulled", "altbody_end");
	wait(0.15);
	if(isdefined(self))
	{
		if(isdefined(player))
		{
			player playsound("wpn_beastmode_grapple_zombie_imp");
		}
		if(!(isdefined(self.grapple_is_fatal) && self.grapple_is_fatal))
		{
			self dodamage(1000, player.origin, player);
		}
		else if(isdefined(player))
		{
			self dodamage(self.health + 1000, player.origin, player);
		}
		else
		{
			self dodamage(self.health + 1000, self.origin);
		}
		if(!isvehicle(self))
		{
			self.no_powerups = 1;
			self.marked_for_recycle = 1;
			self.has_been_damaged_by_player = 0;
			self startragdoll();
			if(isdefined(player))
			{
				player clientfield::increment_to_player("beast_blood_on_player");
			}
		}
	}
}

/*
	Name: lightning_zombie_damage_response
	Namespace: zm_altbody_beast
	Checksum: 0xD6208464
	Offset: 0x5A40
	Size: 0x16C
	Parameters: 13
	Flags: Linked
*/
function lightning_zombie_damage_response(mod, hit_location, hit_origin, player, amount, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)
{
	if(function_4c03fac9(weapon))
	{
		shocklevel = function_cebfc03f(weapon);
		self.tesla_death = 0;
		self thread function_fe8a580e(hit_location, hit_origin, player, shocklevel);
		return 1;
	}
	if(weapon === getweapon("zombie_beast_grapple_dwr"))
	{
		if(amount > 0 && isdefined(player))
		{
			player playrumbleonentity("damage_heavy");
			earthquake(1, 0.75, player.origin, 100);
		}
		return 1;
	}
	return 0;
}

/*
	Name: watch_lightning_damage
	Namespace: zm_altbody_beast
	Checksum: 0x67D0EBD9
	Offset: 0x5BB8
	Size: 0x240
	Parameters: 1
	Flags: Linked
*/
function watch_lightning_damage(triggers)
{
	self endon(#"delete");
	self setcandamage(1);
	while(isdefined(triggers))
	{
		self waittill(#"damage", amount, attacker, direction, point, mod, tagname, modelname, partname, weapon);
		if(function_4c03fac9(weapon) && isdefined(attacker) && amount > 0)
		{
			if(isdefined(attacker))
			{
				attacker notify(#"shockable_shocked");
			}
			if(isdefined(level._effect["beast_shock_box"]))
			{
				forward = anglestoforward(self.angles);
				playfx(level._effect["beast_shock_box"], self.origin, forward);
			}
			if(!isdefined(triggers))
			{
				return;
			}
			if(isarray(triggers))
			{
				foreach(var_355a6f2a, trigger in triggers)
				{
					if(isdefined(trigger))
					{
						trigger useby(attacker);
					}
				}
			}
			else
			{
				triggers useby(attacker);
			}
		}
	}
}

/*
	Name: beast_mode_death_watch
	Namespace: zm_altbody_beast
	Checksum: 0x8F8AD0B0
	Offset: 0x5E00
	Size: 0x25C
	Parameters: 1
	Flags: Linked
*/
function beast_mode_death_watch(attacker)
{
	if(isdefined(self.attacker) && (isdefined(self.attacker.beastmode) && self.attacker.beastmode))
	{
		self.no_powerups = 1;
		self.marked_for_recycle = 1;
		self.has_been_damaged_by_player = 0;
	}
	if(function_4c03fac9(self.damageweapon))
	{
		self.no_powerups = 1;
		self.marked_for_recycle = 1;
		self.has_been_damaged_by_player = 0;
	}
	if(self.damageweapon === getweapon("zombie_beast_grapple_dwr"))
	{
		self.no_powerups = 1;
		self.marked_for_recycle = 1;
		self.has_been_damaged_by_player = 0;
		if(!isvehicle(self))
		{
			if(self.damagemod === "MOD_MELEE")
			{
				player = self.attacker;
				if(isdefined(player))
				{
					player playrumbleonentity("damage_heavy");
					earthquake(1, 0.75, player.origin, 100);
				}
				self clientfield::set("bm_zombie_grapple_kill", 1);
				gibserverutils::annihilate(self);
			}
			else
			{
				player = self.attacker;
				if(isdefined(player))
				{
					player playrumbleonentity("damage_heavy");
					earthquake(1, 0.75, player.origin, 100);
				}
				self clientfield::set("bm_zombie_melee_kill", 1);
				gibserverutils::annihilate(self);
			}
		}
	}
}

/*
	Name: trigger_ooze_only
	Namespace: zm_altbody_beast
	Checksum: 0x8D940540
	Offset: 0x6068
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function trigger_ooze_only()
{
	self endon(#"death");
	level flagsys::wait_till("start_zombie_round_logic");
	self setinvisibletoall();
	while(isdefined(self))
	{
		level waittill(#"ooze_detonate", grenade, player);
		if(isdefined(self) && isdefined(grenade) && grenade istouching(self))
		{
			self useby(player);
		}
	}
}

/*
	Name: function_7fb730b3
	Namespace: zm_altbody_beast
	Checksum: 0xBDA24DB1
	Offset: 0x6128
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function function_7fb730b3()
{
	if(isdefined(self.barricade_enter) && self.barricade_enter)
	{
		return 0;
	}
	if(isdefined(self.is_traversing) && self.is_traversing)
	{
		return 0;
	}
	if(!(isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area) && !isdefined(self.first_node))
	{
		return 0;
	}
	if(isdefined(self.is_leaping) && self.is_leaping)
	{
		return 0;
	}
	return 1;
}

/*
	Name: lightning_slow_zombie
	Namespace: zm_altbody_beast
	Checksum: 0x572BF128
	Offset: 0x61B8
	Size: 0x39C
	Parameters: 1
	Flags: None
*/
function lightning_slow_zombie(zombie)
{
	zombie endon(#"death");
	zombie notify(#"lightning_slow_zombie");
	zombie endon(#"lightning_slow_zombie");
	if(!zombie function_7fb730b3())
	{
		return;
	}
	num = zombie getentitynumber();
	if(!isdefined(zombie.beast_slow_count))
	{
		zombie.beast_slow_count = 0;
	}
	zombie.beast_slow_count++;
	if(!isdefined(zombie.animation_rate))
	{
		zombie.animation_rate = 1;
	}
	zombie.slow_time_left = 8;
	zombie thread lightning_slow_zombie_fx(zombie);
	while(isdefined(zombie) && isalive(zombie) && zombie.animation_rate > 0.03)
	{
		zombie.animation_rate = zombie.animation_rate - 0.97 * 0.05;
		if(zombie.animation_rate < 0.03)
		{
			zombie.animation_rate = 0.03;
		}
		zombie asmsetanimationrate(zombie.animation_rate);
		zombie.slow_time_left = zombie.slow_time_left - 0.05;
		wait(0.05);
	}
	while(isdefined(zombie) && isalive(zombie) && zombie.slow_time_left > 0.5)
	{
		zombie.slow_time_left = zombie.slow_time_left - 0.05;
		wait(0.05);
	}
	while(isdefined(zombie) && isalive(zombie) && zombie.animation_rate < 1)
	{
		zombie.animation_rate = zombie.animation_rate + 0.97 * 0.1;
		if(zombie.animation_rate > 1)
		{
			zombie.animation_rate = 1;
		}
		zombie asmsetanimationrate(zombie.animation_rate);
		zombie.slow_time_left = zombie.slow_time_left - 0.05;
		wait(0.05);
	}
	zombie asmsetanimationrate(1);
	zombie.slow_time_left = 0;
	if(isdefined(zombie))
	{
		zombie.beast_slow_count--;
	}
}

/*
	Name: lightning_slow_zombie_fx
	Namespace: zm_altbody_beast
	Checksum: 0x301BA0F2
	Offset: 0x6560
	Size: 0xDE
	Parameters: 1
	Flags: Linked
*/
function lightning_slow_zombie_fx(zombie)
{
	tag = "J_SpineUpper";
	fx = "beast_shock";
	if(isdefined(zombie.isdog) && zombie.isdog)
	{
		tag = "J_Spine1";
	}
	while(isdefined(zombie) && isalive(zombie) && zombie.slow_time_left > 0)
	{
		zombie zm_net::network_safe_play_fx_on_tag("beast_slow_fx", 2, level._effect[fx], zombie, tag);
		wait(1);
	}
}

/*
	Name: function_41cc3fc8
	Namespace: zm_altbody_beast
	Checksum: 0xA5BECDC0
	Offset: 0x6648
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function function_41cc3fc8()
{
	players = level.activeplayers;
	foreach(var_ed8a77ca, player in players)
	{
		player thread player_update_beast_mode_objects(isdefined(player.beastmode) && player.beastmode);
	}
}

/*
	Name: function_d7b8b2f5
	Namespace: zm_altbody_beast
	Checksum: 0x87674772
	Offset: 0x6710
	Size: 0xD4
	Parameters: 0
	Flags: None
*/
function function_d7b8b2f5()
{
	self endon(#"player_exit_beastmode");
	self endon(#"altbody_end");
	n_start_time = undefined;
	while(true)
	{
		current_zone = self zm_utility::get_current_zone();
		if(!isdefined(current_zone))
		{
			if(!isdefined(n_start_time))
			{
				n_start_time = gettime();
			}
			n_current_time = gettime();
			n_time = n_current_time - n_start_time / 1000;
			if(n_time >= level.var_87ee6f27)
			{
				self notify(#"altbody_end");
				return;
			}
		}
		else
		{
			n_start_time = undefined;
		}
		wait(0.05);
	}
}

/*
	Name: beastmode_devgui
	Namespace: zm_altbody_beast
	Checksum: 0x646FB2FA
	Offset: 0x67F0
	Size: 0x1CE
	Parameters: 0
	Flags: Linked
*/
function beastmode_devgui()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&beastmode_devgui_callback);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			ip1 = i + 1;
			adddebugcommand("" + players[i].name + "" + ip1 + "");
			adddebugcommand("" + players[i].name + "" + ip1 + "");
		}
	#/
}

/*
	Name: beastmode_devgui_callback
	Namespace: zm_altbody_beast
	Checksum: 0xEC8A7A23
	Offset: 0x69C8
	Size: 0x5EE
	Parameters: 1
	Flags: Linked
*/
function beastmode_devgui_callback(cmd)
{
	/#
		players = getplayers();
		retval = 0;
		switch(cmd)
		{
			case "":
			{
				zm_devgui::zombie_devgui_give_powerup(cmd, 1);
				break;
			}
			case "":
			{
				zm_devgui::zombie_devgui_give_powerup(getsubstr(cmd, 5), 0);
				break;
			}
			case "":
			{
				array::thread_all(players, &player_zombie_devgui_beast_mode);
				retval = 1;
				break;
			}
			case "":
			{
				array::thread_all(players, &function_d92721d1);
				retval = 1;
				break;
			}
			case "":
			{
				a_trigs = getentarray("", "");
				foreach(var_142c6ec0, e_trig in a_trigs)
				{
					e_trig useby(level.players[0]);
				}
				a_trigs = getentarray("", "");
				foreach(var_904536da, e_trig in a_trigs)
				{
					e_trig useby(level.players[0]);
				}
				a_str_ritual_flags = array("", "", "", "");
				foreach(var_9df60e3, var_83f1459 in a_str_ritual_flags)
				{
					level flag::set(var_83f1459);
				}
				level flag::set("");
				level flag::set("");
				zm_devgui::zombie_devgui_open_sesame();
				break;
			}
			case "":
			{
				if(players.size >= 1)
				{
					players[0] thread player_zombie_devgui_beast_mode();
				}
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 2)
				{
					players[1] thread player_zombie_devgui_beast_mode();
				}
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 3)
				{
					players[2] thread player_zombie_devgui_beast_mode();
				}
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 4)
				{
					players[3] thread player_zombie_devgui_beast_mode();
				}
				retval = 1;
				break;
			}
			case "":
			{
				array::thread_all(players, &player_zombie_devgui_beast_mode_preserve);
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 1)
				{
					players[0] thread player_zombie_devgui_beast_mode_preserve();
				}
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 2)
				{
					players[1] thread player_zombie_devgui_beast_mode_preserve();
				}
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 3)
				{
					players[2] thread player_zombie_devgui_beast_mode_preserve();
				}
				retval = 1;
				break;
			}
			case "":
			{
				if(players.size >= 4)
				{
					players[3] thread player_zombie_devgui_beast_mode_preserve();
				}
				retval = 1;
				break;
			}
		}
		return retval;
	#/
}

/*
	Name: player_zombie_devgui_beast_mode
	Namespace: zm_altbody_beast
	Checksum: 0x48C5B9DB
	Offset: 0x6FC0
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function player_zombie_devgui_beast_mode()
{
	/#
		if(self detect_reentry())
		{
			return;
		}
		level flagsys::wait_till("");
		if(!(isdefined(self.beastmode) && self.beastmode))
		{
			self player_give_mana(1);
			self thread zm_altbody::devgui_start_altbody("");
		}
		else
		{
			self notify(#"altbody_end");
		}
	#/
}

/*
	Name: function_d92721d1
	Namespace: zm_altbody_beast
	Checksum: 0x1CEECE13
	Offset: 0x7068
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function function_d92721d1()
{
	/#
		if(self detect_reentry())
		{
			return;
		}
		level flagsys::wait_till("");
		var_a315b31f = level clientfield::get("");
		if(!(isdefined(self.beastmode) && self.beastmode) && !var_a315b31f)
		{
			self player_give_mana(1);
			self thread zm_altbody::devgui_start_altbody("");
		}
		else
		{
			self notify(#"altbody_end");
		}
	#/
}

/*
	Name: detect_reentry
	Namespace: zm_altbody_beast
	Checksum: 0x5B3BDFF5
	Offset: 0x7148
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function detect_reentry()
{
	/#
		if(isdefined(self.devgui_preserve_time))
		{
			if(self.devgui_preserve_time == gettime())
			{
				return 1;
			}
		}
		self.devgui_preserve_time = gettime();
		return 0;
	#/
}

/*
	Name: player_zombie_devgui_beast_mode_preserve
	Namespace: zm_altbody_beast
	Checksum: 0xCEFBD38E
	Offset: 0x7188
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function player_zombie_devgui_beast_mode_preserve()
{
	/#
		if(self detect_reentry())
		{
			return;
		}
		self notify(#"zombie_devgui_beast_mode_preserve");
		self endon(#"zombie_devgui_beast_mode_preserve");
		level flagsys::wait_till("");
		self.devgui_preserve_beast_mode = !(isdefined(self.devgui_preserve_beast_mode) && self.devgui_preserve_beast_mode);
		if(self.devgui_preserve_beast_mode)
		{
			while(isdefined(self))
			{
				self player_give_lives(3);
				self player_give_mana(1);
				wait(0.05);
			}
		}
	#/
}

