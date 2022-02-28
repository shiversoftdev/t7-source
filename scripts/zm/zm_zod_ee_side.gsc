// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_token;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_shadowman;
#using scripts\zm\zm_zod_util;
#using scripts\zm\zm_zod_vo;

#using_animtree("generic");

#namespace zm_zod_ee_side;

/*
	Name: __init__sytem__
	Namespace: zm_zod_ee_side
	Checksum: 0x95F359A7
	Offset: 0x13B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_ee_side", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_ee_side
	Checksum: 0xEE4F770D
	Offset: 0x13F0
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("world", "change_bouncingbetties", 1, 2, "int");
	clientfield::register("world", "lil_arnie_dance", 1, 1, "int");
	callback::add_weapon_watcher(&function_758cc281);
	callback::add_weapon_watcher(&function_a3213b07);
	zm_placeable_mine::add_mine_type("bouncingbetty_devil", &"MP_BOUNCINGBETTY_PICKUP");
	zm_placeable_mine::add_mine_type("bouncingbetty_holly", &"MP_BOUNCINGBETTY_PICKUP");
}

/*
	Name: main
	Namespace: zm_zod_ee_side
	Checksum: 0x7BC04446
	Offset: 0x14E0
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level flag::init("play_vocals");
	level flag::init("awarded_lion_gumball1");
	level flag::init("awarded_lion_gumball2");
	level flag::init("awarded_lion_gumball3");
	level flag::init("awarded_lion_gumball4");
	callback::on_spawned(&on_player_spawned);
	level.riotshield_melee_juke_callback = &function_c6930415;
	level flag::wait_till("all_players_spawned");
	level thread function_932e3574();
	level thread function_6d012317();
	level thread function_a59032c3();
	level thread function_e947749a();
	level thread function_b943cc04();
	level thread laundry_ticket();
	level thread function_67a4dabe();
	if(level.onlinegame)
	{
		level thread function_de14e5a1();
	}
	level thread function_523509c2();
	level thread function_5045e366();
	level thread spare_change();
	level thread function_f93dd0b9();
	level thread function_41ecaace();
}

/*
	Name: on_player_spawned
	Namespace: zm_zod_ee_side
	Checksum: 0xF5D4AEEF
	Offset: 0x1728
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self.var_8c06218 = 0;
	self thread function_7a56bf90();
	if(isdefined(self.var_d89174ae) && self.var_d89174ae)
	{
		self thread function_4d249743();
	}
	if(level.onlinegame)
	{
		n_index = zm_utility::get_player_index(self) + 1;
		if(!level flag::get("awarded_lion_gumball" + n_index))
		{
			self thread function_7784eba6();
		}
	}
}

/*
	Name: function_f93dd0b9
	Namespace: zm_zod_ee_side
	Checksum: 0x8E7DBF9E
	Offset: 0x17E8
	Size: 0x176
	Parameters: 0
	Flags: Linked
*/
function function_f93dd0b9()
{
	level flag::wait_till("zones_initialized");
	level.var_94e23698 = [];
	var_7533f11 = struct::get_array("shadowman_map", "targetname");
	for(i = 0; i < var_7533f11.size; i++)
	{
		level.var_94e23698[var_7533f11[i].script_string] = var_7533f11[i];
		level.var_94e23698[var_7533f11[i].script_string] thread function_f2485365();
		level.var_94e23698[var_7533f11[i].script_string] thread function_f4bfd0b8();
		if(isdefined(level.var_94e23698[var_7533f11[i].script_string].script_noteworthy))
		{
			level.var_94e23698[var_7533f11[i].script_string] thread function_cbcaa042();
		}
	}
}

/*
	Name: function_f2485365
	Namespace: zm_zod_ee_side
	Checksum: 0x9225A670
	Offset: 0x1968
	Size: 0x20A
	Parameters: 0
	Flags: Linked
*/
function function_f2485365()
{
	level endon(#"_zombie_game_over");
	self endon(#"hash_a881e3fa");
	if(self.script_string != "play_on_map_load")
	{
		level waittill(self.script_string);
	}
	if(self.script_int != 4)
	{
		self thread function_724b1463();
		self thread function_e00f4f2a();
	}
	self function_1a99877f();
	switch(self.script_int)
	{
		case 5:
		{
			self function_ff688e23();
			break;
		}
		case 0:
		{
			while(!zm_zonemgr::get_players_in_zone(self.script_string))
			{
				wait(0.05);
			}
			self function_188b8017();
			break;
		}
		case 1:
		{
			while(!zm_zonemgr::get_players_in_zone(self.script_string))
			{
				wait(0.05);
			}
			self function_cd7431a8();
			break;
		}
		case 2:
		{
			self function_82fac046();
			break;
		}
		case 3:
		{
			self function_fa56dab0();
			break;
		}
		case 4:
		{
			self function_b066a053();
			break;
		}
	}
	wait(3);
	self zm_zod_shadowman::function_f25f7ff3();
	self zm_zod_shadowman::function_57b6041b();
	self notify(#"hash_a881e3fa");
}

/*
	Name: function_f4bfd0b8
	Namespace: zm_zod_ee_side
	Checksum: 0xEFE01BC3
	Offset: 0x1B80
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_f4bfd0b8()
{
	level waittill(#"_zombie_game_over");
	if(isdefined(self.var_93dad597))
	{
		if(isdefined(self.var_93dad597))
		{
			self zm_zod_shadowman::function_f25f7ff3();
		}
		if(isdefined(self.var_5afdc7fe))
		{
			self zm_zod_shadowman::function_57b6041b();
		}
	}
}

/*
	Name: function_cbcaa042
	Namespace: zm_zod_ee_side
	Checksum: 0x1B2862EC
	Offset: 0x1BE8
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function function_cbcaa042()
{
	level endon(#"_zombie_game_over");
	self endon(#"hash_a881e3fa");
	self waittill(#"hash_42d111a0");
	level.var_94e23698[self.script_noteworthy] notify(#"hash_a881e3fa");
}

/*
	Name: function_1a99877f
	Namespace: zm_zod_ee_side
	Checksum: 0x1600E90F
	Offset: 0x1C38
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function function_1a99877f()
{
	foreach(e_player in level.players)
	{
		self thread function_63d2d60e(e_player);
	}
}

/*
	Name: function_63d2d60e
	Namespace: zm_zod_ee_side
	Checksum: 0x214278BD
	Offset: 0x1CD0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_63d2d60e(e_player)
{
	self endon(#"hash_a881e3fa");
	while(true)
	{
		if(isdefined(e_player) && e_player zm_zod_vo::function_2d942575(self.var_93dad597, 1500))
		{
			e_player notify(#"shadowman_spotted");
			break;
		}
		wait(0.05);
	}
}

/*
	Name: function_82d8ec58
	Namespace: zm_zod_ee_side
	Checksum: 0xAD117C29
	Offset: 0x1D48
	Size: 0x130
	Parameters: 0
	Flags: Linked
*/
function function_82d8ec58()
{
	self endon(#"hash_a881e3fa");
	while(true)
	{
		foreach(player in level.players)
		{
			if(isalive(player) && distancesquared(self.var_93dad597.origin, player.origin) < 16384)
			{
				self zm_zod_shadowman::function_f25f7ff3();
				self zm_zod_shadowman::function_57b6041b();
				self notify(#"hash_a881e3fa");
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_ff688e23
	Namespace: zm_zod_ee_side
	Checksum: 0xEBD73E37
	Offset: 0x1E80
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function function_ff688e23()
{
	level endon(#"_zombie_game_over");
	self zm_zod_shadowman::function_12e7164a(1, 1, 0);
	self zm_zod_shadowman::function_8888a532(0, 1, 1);
	self notify(#"hash_42d111a0");
	level.players[0] waittill(self.script_parameters + "_vo_done");
	self thread function_fa2d33a4();
	self thread function_82d8ec58();
	level waittill(#"hash_5298c49");
}

/*
	Name: function_188b8017
	Namespace: zm_zod_ee_side
	Checksum: 0xE7C38D91
	Offset: 0x1F40
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function function_188b8017()
{
	level endon(#"_zombie_game_over");
	self endon(#"hash_a881e3fa");
	self zm_zod_shadowman::function_12e7164a(0, 1);
	self zm_zod_shadowman::function_8888a532(0, 1, 0);
	self notify(#"hash_42d111a0");
	var_bc9ce2d0 = zm_zonemgr::get_zone_from_position(self.origin, 1);
	if(isdefined(var_bc9ce2d0))
	{
		self endon(var_bc9ce2d0);
	}
	while(true)
	{
		foreach(e_player in level.activeplayers)
		{
			if(isdefined(e_player) && e_player zm_zod_vo::function_2d942575(self.var_93dad597, 1000))
			{
				return;
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_cd7431a8
	Namespace: zm_zod_ee_side
	Checksum: 0x8F91DE1C
	Offset: 0x20A0
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_cd7431a8()
{
	level endon(#"_zombie_game_over");
	self endon(#"hash_a881e3fa");
	self zm_zod_shadowman::function_12e7164a(0, 1);
	self zm_zod_shadowman::function_8888a532(0, 1, 0);
	self notify(#"hash_42d111a0");
	var_bc9ce2d0 = zm_zonemgr::get_zone_from_position(self.origin, 1);
	while(!self.var_93dad597 zm_zonemgr::entity_in_zone(var_bc9ce2d0, 0))
	{
		wait(0.05);
	}
}

/*
	Name: function_82fac046
	Namespace: zm_zod_ee_side
	Checksum: 0xEDF4E9FA
	Offset: 0x2160
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_82fac046()
{
	level endon(#"_zombie_game_over");
	if(self.script_string == "play_on_map_load")
	{
		self zm_zod_shadowman::function_12e7164a(1, 1, 0);
		self zm_zod_shadowman::function_8888a532(0, 1, 1);
	}
	else
	{
		self zm_zod_shadowman::function_12e7164a(0, 1);
		self zm_zod_shadowman::function_8888a532(0, 1);
	}
	self notify(#"hash_42d111a0");
	level.players[0] waittill(self.script_parameters + "_vo_done");
	if(self.script_string == "play_on_map_load")
	{
		wait(3);
	}
}

/*
	Name: function_fa56dab0
	Namespace: zm_zod_ee_side
	Checksum: 0x74DA5F60
	Offset: 0x2250
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_fa56dab0()
{
	level endon(#"_zombie_game_over");
	self zm_zod_shadowman::function_12e7164a(0, 1);
	self zm_zod_shadowman::function_8888a532(0, 1, 0);
	self notify(#"hash_42d111a0");
	wait(9);
}

/*
	Name: function_b066a053
	Namespace: zm_zod_ee_side
	Checksum: 0xC92B1B49
	Offset: 0x22C0
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function function_b066a053()
{
	level endon(#"_zombie_game_over");
	self endon(#"hash_a881e3fa");
	foreach(var_707e0d1c in level.var_94e23698)
	{
		if(isdefined(var_707e0d1c) && var_707e0d1c !== self)
		{
			var_707e0d1c notify(#"hash_a881e3fa");
		}
	}
	mdl_key = getent("quest_key_pickup", "targetname");
	mdl_key ghost();
	self zm_zod_shadowman::function_12e7164a(0, 1, 0, 1);
	self.var_93dad597 hidepart("tag_weapon_right");
	v_origin = self.var_93dad597 gettagorigin("tag_weapon_right");
	self.var_14030b0f = spawn("script_model", v_origin);
	self.var_14030b0f setmodel("p7_fxanim_zm_zod_redemption_key_ritual_mod");
	self.var_14030b0f linkto(self.var_93dad597, "tag_weapon_right");
	self.var_14030b0f clientfield::set("item_glow_fx", 1);
	level.players[0] waittill(self.script_parameters + "_vo_done");
	self thread function_98c5d1e5();
	playsoundatposition("zmb_shadowman_transition", (0, 0, 0));
	self.var_14030b0f delete();
	self zm_zod_shadowman::function_8888a532(0, 1, 0, 1);
	wait(0.05);
	self.var_5afdc7fe clientfield::set("shadowman_fx", 1);
	self.var_5afdc7fe playsound("zmb_shadowman_tele_in");
	self.var_93dad597 ghost();
	wait(3);
}

/*
	Name: function_98c5d1e5
	Namespace: zm_zod_ee_side
	Checksum: 0xD74BF066
	Offset: 0x25C0
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_98c5d1e5()
{
	self endon(#"hash_a881e3fa");
	while(true)
	{
		playrumbleonposition("zod_shadowman_transformed", self.origin);
		wait(0.1);
	}
}

/*
	Name: function_724b1463
	Namespace: zm_zod_ee_side
	Checksum: 0x3CDC11E7
	Offset: 0x2608
	Size: 0x238
	Parameters: 0
	Flags: Linked
*/
function function_724b1463()
{
	level endon(#"_zombie_game_over");
	self endon(#"hash_a881e3fa");
	while(true)
	{
		foreach(player in level.players)
		{
			if(!isdefined(player.var_226cc0a3))
			{
				player.var_226cc0a3 = [];
				array::add(player.var_226cc0a3, self.script_string);
				continue;
			}
			if(player.var_226cc0a3.size > 0)
			{
				foreach(var_a583588 in player.var_226cc0a3)
				{
					if(var_a583588 == self.script_string)
					{
						var_a7167425 = 0;
						break;
						continue;
					}
					var_a7167425 = 1;
				}
				if(var_a7167425)
				{
					array::add(player.var_226cc0a3, self.script_string);
					self thread function_1b5affd(player);
				}
				continue;
			}
			array::add(player.var_226cc0a3, self.script_int);
			self thread function_1b5affd(player);
		}
		wait(0.05);
	}
}

/*
	Name: function_e00f4f2a
	Namespace: zm_zod_ee_side
	Checksum: 0x57E2263
	Offset: 0x2848
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_e00f4f2a()
{
	var_3a813333 = self;
	self waittill(#"hash_a881e3fa");
	foreach(player in level.players)
	{
		arrayremovevalue(player.var_226cc0a3, var_3a813333);
	}
}

/*
	Name: function_1b5affd
	Namespace: zm_zod_ee_side
	Checksum: 0x7E797D9C
	Offset: 0x2908
	Size: 0x1C8
	Parameters: 1
	Flags: Linked
*/
function function_1b5affd(player)
{
	level endon(#"_zombie_game_over");
	self endon(#"hash_a881e3fa");
	player endon(#"disconnect");
	self waittill(#"hash_42d111a0");
	self.var_93dad597 setvisibletoplayer(player);
	self.var_5afdc7fe setinvisibletoplayer(player);
	while(true)
	{
		var_85e18920 = 0;
		player waittill(#"lightning_strike");
		n_time_started = gettime() / 1000;
		while(player.beastmode === 1)
		{
			n_time_current = gettime() / 1000;
			n_time_elapsed = n_time_current - n_time_started;
			if(n_time_elapsed >= 0.75)
			{
				self.var_93dad597 setvisibletoplayer(player);
				wait(0.05);
				self.var_5afdc7fe setinvisibletoplayer(player);
				break;
			}
			else if(!var_85e18920)
			{
				self.var_5afdc7fe setvisibletoplayer(player);
				wait(0.05);
				self.var_93dad597 setinvisibletoplayer(player);
				var_85e18920 = 1;
			}
			wait(0.05);
		}
	}
}

/*
	Name: function_932e3574
	Namespace: zm_zod_ee_side
	Checksum: 0xBAEF565B
	Offset: 0x2AD8
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function function_932e3574()
{
	level.var_4a9b0bd3 = 0;
	var_e2dface3 = struct::get_array("audio_recording");
	foreach(var_2f236ce8 in var_e2dface3)
	{
		var_2f236ce8 thread audio_recording();
	}
}

/*
	Name: function_b69c861
	Namespace: zm_zod_ee_side
	Checksum: 0xAB57D921
	Offset: 0x2BA0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_b69c861()
{
	s_portal = struct::get("maxis_portal");
	self fx::play("portal_shortcut_closed", s_portal.origin, s_portal.angles, "recording_done");
}

/*
	Name: audio_recording
	Namespace: zm_zod_ee_side
	Checksum: 0xD58DD2BA
	Offset: 0x2C10
	Size: 0x642
	Parameters: 0
	Flags: Linked
*/
function audio_recording()
{
	if(isdefined(self.script_noteworthy))
	{
		level flag::wait_till(self.script_noteworthy);
	}
	switch(self.script_string)
	{
		case "lawyer":
		case "partner":
		case "producer":
		case "promoter":
		{
			n_delay = 10;
			var_39fccb95 = 2;
			var_a288248d = "zmb_zod_ee_phone_ring";
			break;
		}
		case "reporter":
		{
			n_delay = 0;
			var_39fccb95 = 2;
			var_a288248d = "zmb_zod_ee_phonebooth_ring";
			break;
		}
		default:
		{
			n_delay = 2;
			var_39fccb95 = 1;
			var_a288248d = "zmb_zod_ee_phone_ring";
		}
	}
	wait(n_delay);
	if(isdefined(self.script_string) && self.script_string == "maxis")
	{
		self thread function_b69c861();
		var_a288248d = "zmb_zod_ee_phonemaxis_ring";
	}
	self create_unitrigger();
	self thread function_8faf1d24();
	e_temp = spawn("script_origin", self.origin);
	e_temp thread function_84b739e(var_39fccb95, var_a288248d);
	self waittill(#"trigger_activated");
	e_temp stopsound(var_a288248d);
	if(isdefined(self.script_string) && self.script_string == "reporter")
	{
		level.var_4a9b0bd3++;
		self.script_string = self.script_string + level.var_4a9b0bd3;
	}
	a_str_lines = [];
	switch(self.script_string)
	{
		case "lawyer":
		{
			a_str_lines = array("vox_lawy_callback_lawy_0", "vox_lawy_callback_lawy_1", "vox_lawy_callback_lawy_2");
			n_delay = 10;
			break;
		}
		case "maxis":
		{
			a_str_lines = array("vox_maxis_maxis_radio_0", "vox_maxis_maxis_radio_1", "vox_maxis_maxis_radio_2");
			break;
		}
		case "partner":
		{
			a_str_lines = array("vox_part_callback_part_0", "vox_part_callback_part_1", "vox_part_callback_part_2", "vox_part_callback_part_3", "vox_part_callback_part_4");
			n_delay = 10;
			break;
		}
		case "producer":
		{
			a_str_lines = array("vox_prod_callback_prod_0", "vox_prod_callback_prod_1", "vox_prod_callback_prod_2", "vox_prod_callback_prod_3");
			n_delay = 10;
			break;
		}
		case "promoter":
		{
			a_str_lines = array("vox_prom_callback_prom_0", "vox_prom_callback_prom_1", "vox_prom_callback_prom_2");
			n_delay = 10;
			break;
		}
		case "reporter1":
		{
			a_str_lines = array("vox_repo_reporter_log_1_0", "vox_repo_reporter_log_1_1", "vox_repo_reporter_log_1_2", "vox_repo_reporter_log_1_3", "vox_repo_reporter_log_1_4", "vox_repo_reporter_log_1_5", "vox_repo_reporter_log_1_6");
			break;
		}
		case "reporter2":
		{
			a_str_lines = array("vox_repo_reporter_log_2_0", "vox_repo_reporter_log_2_1", "vox_repo_reporter_log_2_2", "vox_repo_reporter_log_2_3", "vox_repo_reporter_log_2_4", "vox_repo_reporter_log_2_5");
			break;
		}
		case "reporter3":
		{
			a_str_lines = array("vox_repo_reporter_log_3_0", "vox_repo_reporter_log_3_1", "vox_repo_reporter_log_3_2", "vox_repo_reporter_log_3_3", "vox_repo_reporter_log_3_4", "vox_repo_reporter_log_3_5", "vox_repo_reporter_log_3_6");
			break;
		}
		case "shadowman_lawyer":
		{
			a_str_lines = array("vox_shad_victim_convo_lawy_0", "vox_lawy_victim_convo_lawy_1", "vox_shad_victim_convo_lawy_2", "vox_lawy_victim_convo_lawy_3", "vox_shad_victim_convo_lawy_4", "vox_lawy_victim_convo_lawy_5");
			break;
		}
		case "shadowman_partner":
		{
			a_str_lines = array("vox_shad_victim_convo_part_0", "vox_part_victim_convo_part_1", "vox_shad_victim_convo_part_2", "vox_part_victim_convo_part_3", "vox_shad_victim_convo_part_4", "vox_part_victim_convo_part_5", "vox_shad_victim_convo_part_6", "vox_part_victim_convo_part_7");
			break;
		}
		case "shadowman_producer":
		{
			a_str_lines = array("vox_shad_victim_convo_prod_0", "vox_prod_victim_convo_prod_1", "vox_shad_victim_convo_prod_2", "vox_prod_victim_convo_prod_3", "vox_shad_victim_convo_prod_4", "vox_prod_victim_convo_prod_5");
			break;
		}
		case "shadowman_promoter":
		{
			a_str_lines = array("vox_shad_victim_convo_prom_0", "vox_prom_victim_convo_prom_1", "vox_shad_victim_convo_prom_2", "vox_prom_victim_convo_prom_3", "vox_shad_victim_convo_prom_4", "vox_prom_victim_convo_prom_5", "vox_shad_victim_convo_prom_6", "vox_prom_victim_convo_prom_7");
			break;
		}
	}
	e_temp function_e7a3a98f(a_str_lines);
	e_temp delete();
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	self notify(#"recording_done");
}

/*
	Name: function_84b739e
	Namespace: zm_zod_ee_side
	Checksum: 0x936DFE5A
	Offset: 0x3260
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function function_84b739e(var_39fccb95 = 1, alias)
{
	self endon(#"trigger_activated");
	for(i = 0; i < var_39fccb95; i++)
	{
		self playsound(alias);
		wait(4);
	}
}

/*
	Name: function_e7a3a98f
	Namespace: zm_zod_ee_side
	Checksum: 0x9E77A828
	Offset: 0x32E8
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function function_e7a3a98f(a_str_lines)
{
	zm_zod_vo::function_218256bd(1);
	foreach(str_line in a_str_lines)
	{
		self playsoundwithnotify(str_line, str_line + "wait");
		self waittill(str_line + "wait");
		wait(0.05);
	}
	zm_zod_vo::function_218256bd(0);
}

/*
	Name: function_a59032c3
	Namespace: zm_zod_ee_side
	Checksum: 0xE423642F
	Offset: 0x33E0
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function function_a59032c3()
{
	level.var_89ad28cd = 0;
	var_e3c08ace = getentarray("hs_radio", "targetname");
	array::thread_all(var_e3c08ace, &function_68e137c8);
	while(true)
	{
		level waittill(#"hash_da6d056e");
		if(level.var_89ad28cd == var_e3c08ace.size)
		{
			break;
		}
	}
	if(level flag::get("play_vocals"))
	{
		level thread zm_audio::sndmusicsystem_playstate("snakeskinboots");
		level thread audio::unlockfrontendmusic("mus_snake_skin_boots_intro");
	}
	else
	{
		level thread zm_audio::sndmusicsystem_playstate("snakeskinboots_instr");
		level thread audio::unlockfrontendmusic("mus_snake_skin_instrumental_intro");
	}
}

/*
	Name: function_68e137c8
	Namespace: zm_zod_ee_side
	Checksum: 0x8BE28F9
	Offset: 0x3518
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function function_68e137c8()
{
	self create_unitrigger();
	self playloopsound("zmb_zod_radio_loop", 1);
	self thread function_8faf1d24(vectorscale((0, 0, 1), 255), "hs1");
	while(level.var_89ad28cd < 3)
	{
		self waittill(#"trigger_activated");
		level flag::toggle("play_vocals");
		if(!(isdefined(self.b_activated) && self.b_activated))
		{
			self.b_activated = 1;
			level.var_89ad28cd++;
			level notify(#"hash_da6d056e");
			self stoploopsound(0.2);
		}
		self playsound("zmb_zod_radio_activate");
		if(isdefined(level.musicsystem.currentplaytype) && level.musicsystem.currentplaytype >= 4 || (isdefined(level.musicsystemoverride) && level.musicsystemoverride))
		{
			continue;
		}
	}
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
}

/*
	Name: function_e947749a
	Namespace: zm_zod_ee_side
	Checksum: 0xC4E7C4F3
	Offset: 0x3698
	Size: 0x19A
	Parameters: 0
	Flags: Linked
*/
function function_e947749a()
{
	level.var_d98fa1f1 = 0;
	a_items = getentarray("hs_item", "targetname");
	array::thread_all(a_items, &function_47965455);
	while(true)
	{
		level waittill(#"hash_bcead67a");
		if(level.var_d98fa1f1 == a_items.size)
		{
			break;
		}
	}
	a_items = struct::get_array("hs_item_stage", "targetname");
	foreach(var_2e8087fe in a_items)
	{
		var_49d8189c = util::spawn_model(var_2e8087fe.model, var_2e8087fe.origin, var_2e8087fe.angles);
		if(var_2e8087fe.model == "p7_zm_zod_hidden_songs_mic_stand")
		{
			var_49d8189c thread function_b6296b8b();
		}
	}
}

/*
	Name: function_47965455
	Namespace: zm_zod_ee_side
	Checksum: 0x49252551
	Offset: 0x3840
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_47965455()
{
	self create_unitrigger();
	self thread function_8faf1d24(vectorscale((0, 0, 1), 255), "hs2");
	self waittill(#"trigger_activated");
	playsoundatposition("zmb_zod_ee_item_pickup", self.origin);
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	level.var_d98fa1f1++;
	level notify(#"hash_bcead67a");
	self delete();
}

/*
	Name: function_b6296b8b
	Namespace: zm_zod_ee_side
	Checksum: 0x7C053BC4
	Offset: 0x3900
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_b6296b8b()
{
	self create_unitrigger();
	while(true)
	{
		self waittill(#"trigger_activated");
		if(isdefined(level.musicsystem.currentplaytype) && level.musicsystem.currentplaytype >= 4 || (isdefined(level.musicsystemoverride) && level.musicsystemoverride))
		{
			continue;
		}
		else
		{
			break;
		}
	}
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	level thread zm_audio::sndmusicsystem_playstate("coldhardcash");
	level thread audio::unlockfrontendmusic("mus_cold_hard_cash_intro");
}

/*
	Name: function_6d012317
	Namespace: zm_zod_ee_side
	Checksum: 0x58A8B7B5
	Offset: 0x39E8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_6d012317()
{
	var_3d01fc2c = getent("brick_cipher", "targetname");
	var_3d01fc2c thread brick_cipher();
	var_c671e1b1 = getent("picture_cipher", "targetname");
	var_c671e1b1 thread picture_cipher();
	var_6a19ae41 = getent("hyena", "targetname");
	var_6a19ae41 thread function_7e754365();
}

/*
	Name: brick_cipher
	Namespace: zm_zod_ee_side
	Checksum: 0x7F542257
	Offset: 0x3AB8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function brick_cipher()
{
	self create_unitrigger();
	self waittill(#"trigger_activated");
	self movez(164, 2);
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	self waittill(#"movedone");
	self delete();
}

/*
	Name: picture_cipher
	Namespace: zm_zod_ee_side
	Checksum: 0xC6281E81
	Offset: 0x3B40
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function picture_cipher()
{
	self setcandamage(1);
	self waittill(#"damage");
	self physicslaunch(self.origin + (2, 0, 8), (2, 2, 5));
	wait(30);
	self delete();
}

/*
	Name: function_7e754365
	Namespace: zm_zod_ee_side
	Checksum: 0xBBEF3196
	Offset: 0x3BC0
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_7e754365()
{
	self setcandamage(1);
	var_face7c14 = getweapon("smg_standard_upgraded");
	while(true)
	{
		self waittill(#"damage", n_damage, e_attacker, v_dir, v_loc, str_type, str_model, str_tag, str_part, w_weapon, n_flags);
		if(w_weapon.rootweapon == var_face7c14)
		{
			break;
		}
	}
	self physicslaunch(self.origin + (6, 0, 8), (2, 2, 5));
	wait(30);
	self delete();
}

/*
	Name: function_523509c2
	Namespace: zm_zod_ee_side
	Checksum: 0x3927E5FA
	Offset: 0x3D08
	Size: 0x46C
	Parameters: 0
	Flags: Linked
*/
function function_523509c2()
{
	var_839c79fb = 0;
	/#
		if(getdvarint("") > 0)
		{
			var_839c79fb = 1;
		}
	#/
	if(!var_839c79fb)
	{
		for(var_8d01bd08 = 0; var_8d01bd08 != 6; var_8d01bd08++)
		{
			level waittill(#"hash_1a2d33d7");
		}
	}
	var_4a7285b7 = 0;
	/#
		if(getdvarint("") > 1)
		{
			var_4a7285b7 = 1;
		}
	#/
	if(!var_4a7285b7)
	{
		level.var_e0133c46 = [];
		var_fad038a6 = struct::get_array("margwa_heart");
		foreach(var_a3b2752a in var_fad038a6)
		{
			var_779fea3 = util::spawn_model("p7_zm_zod_margwa_heart_alive", var_a3b2752a.origin, var_a3b2752a.angles);
			var_779fea3 thread function_9a436d7f();
			if(!isdefined(level.var_e0133c46))
			{
				level.var_e0133c46 = [];
			}
			else if(!isarray(level.var_e0133c46))
			{
				level.var_e0133c46 = array(level.var_e0133c46);
			}
			level.var_e0133c46[level.var_e0133c46.size] = var_779fea3;
		}
		level thread function_51b665f0();
		while(true)
		{
			var_9094458d = 0;
			foreach(var_779fea3 in level.var_e0133c46)
			{
				if(isdefined(var_779fea3.b_shown) && var_779fea3.b_shown)
				{
					var_9094458d = 1;
					break;
				}
			}
			if(!var_9094458d)
			{
				break;
			}
			wait(0.05);
		}
		level notify(#"hash_e87ace62");
		array::run_all(level.var_e0133c46, &delete);
	}
	var_baa93c97 = struct::get_array("margwa_shiny", "targetname");
	var_baa93c97 = array::randomize(var_baa93c97);
	for(i = 0; i < level.players.size; i++)
	{
		var_b81be463 = var_baa93c97[i];
		var_1205599e = util::spawn_model("tag_origin", var_b81be463.origin, var_b81be463.angles);
		var_1205599e thread function_68f6dbc2();
	}
	level.margwa_smash_damage_callback = &function_e8628610;
	level.margwa_damage_override_callback = &function_e6f86e4d;
	playsoundatposition("zmb_vocals_margwa_death", (0, 0, 0));
}

/*
	Name: function_9a436d7f
	Namespace: zm_zod_ee_side
	Checksum: 0xFDF5F170
	Offset: 0x4180
	Size: 0x190
	Parameters: 0
	Flags: Linked
*/
function function_9a436d7f()
{
	level endon(#"hash_e87ace62");
	self setcandamage(1);
	self.b_shown = 1;
	while(true)
	{
		self waittill(#"damage", n_damage, e_attacker);
		if(isdefined(e_attacker.on_train) && e_attacker.on_train && level.o_zod_train flag::get("moving"))
		{
			self hide();
			self.b_shown = 0;
			level notify(#"hash_34141bc5");
			e_attacker playsound("zmb_vocals_margwa_pain_small");
			level waittill(#"hash_47c53d3");
			self show();
			self.b_shown = 1;
			self thread function_8faf1d24(vectorscale((1, 0, 0), 255), "<3", 1, "damage");
		}
		else
		{
			self hide();
			wait(0.15);
			self show();
		}
	}
}

/*
	Name: function_51b665f0
	Namespace: zm_zod_ee_side
	Checksum: 0xEC1C8F2F
	Offset: 0x4318
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function function_51b665f0()
{
	level endon(#"hash_e87ace62");
	while(true)
	{
		level waittill(#"hash_34141bc5");
		for(i = 0; i < 2; i++)
		{
			level.o_zod_train flag::wait_till("moving");
			level.o_zod_train flag::wait_till("cooldown");
		}
		level notify(#"hash_47c53d3");
	}
}

/*
	Name: function_e8628610
	Namespace: zm_zod_ee_side
	Checksum: 0x57C53F3F
	Offset: 0x43C8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_e8628610(var_225347e1)
{
	if(isdefined(self.var_d89174ae) && self.var_d89174ae)
	{
		n_damage = 166 * 0.75;
		self dodamage(n_damage, var_225347e1.origin);
		return true;
	}
	return false;
}

/*
	Name: function_e6f86e4d
	Namespace: zm_zod_ee_side
	Checksum: 0x99D84E81
	Offset: 0x4448
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function function_e6f86e4d(n_damage)
{
	var_6be53fb8 = n_damage;
	if(isplayer(self) && (isdefined(self.var_d89174ae) && self.var_d89174ae))
	{
		var_6be53fb8 = n_damage * 1.15;
	}
	return var_6be53fb8;
}

/*
	Name: function_68f6dbc2
	Namespace: zm_zod_ee_side
	Checksum: 0xA4BC3AE
	Offset: 0x44C0
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_68f6dbc2()
{
	wait(1);
	self clientfield::set("pod_sprayer_glint", 1);
	self create_unitrigger(&"ZM_ZOD_MH_MARGWA_HEAD");
	self waittill(#"trigger_activated", player);
	player playsound("zmb_vocals_margwa_pain_small");
	player.var_d89174ae = 1;
	player thread function_4d249743();
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	self clientfield::set("pod_sprayer_glint", 0);
	self delete();
}

/*
	Name: function_4d249743
	Namespace: zm_zod_ee_side
	Checksum: 0xDB040CEC
	Offset: 0x45C8
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function function_4d249743()
{
	self endon(#"death");
	while(true)
	{
		self attach("p7_zm_zod_margwa_head", "j_head");
		self flag::wait_till("in_beastmode");
		self detach("p7_zm_zod_margwa_head", "j_head");
		self flag::wait_till_clear("in_beastmode");
	}
}

/*
	Name: laundry_ticket
	Namespace: zm_zod_ee_side
	Checksum: 0x1B5F97E3
	Offset: 0x4678
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function laundry_ticket()
{
	var_43af12b1 = getent("laundry_ticket", "targetname");
	var_43af12b1 setcandamage(1);
	var_43af12b1.health = 999999;
	while(true)
	{
		var_43af12b1 waittill(#"damage", n_damage, e_attacker, v_dir, v_loc, str_type, str_model, str_tag, str_part, w_weapon);
		if(str_type == "MOD_GRENADE_SPLASH" && distancesquared(var_43af12b1.origin, v_loc) < 4096)
		{
			break;
		}
	}
	s_target = struct::get(var_43af12b1.target);
	var_43af12b1.origin = s_target.origin;
	var_43af12b1.angles = s_target.angles;
	var_43af12b1 create_unitrigger();
	var_43af12b1 waittill(#"trigger_activated", e_player);
	var_43af12b1 delete();
	e_player zm_score::add_to_player_score(500);
}

/*
	Name: function_67a4dabe
	Namespace: zm_zod_ee_side
	Checksum: 0x70E332E5
	Offset: 0x4870
	Size: 0x1E0
	Parameters: 0
	Flags: Linked
*/
function function_67a4dabe()
{
	level.var_f11300cd = 0;
	b_skip = 0;
	/#
		if(getdvarint("") > 0)
		{
			b_skip = 1;
		}
	#/
	if(b_skip == 0)
	{
		zm_zod_util::on_zombie_killed(&function_4a0f0038);
		level waittill(#"hash_6e41959b");
		arrayremovevalue(level.zombie_death_callbacks, &function_4a0f0038);
	}
	level.octobomb_attack_callback = &function_bfe0c3eb;
	level waittill(#"hash_8b3094ce");
	level.octobomb_attack_callback = &function_31ef8fd4;
	level waittill(#"hash_21edb6b6");
	foreach(player in level.activeplayers)
	{
		if(player hasweapon(level.w_octobomb))
		{
			player _zm_weap_octobomb::player_give_octobomb("octobomb_upgraded");
		}
	}
	level.zombie_weapons[level.w_octobomb].is_in_box = 0;
	level.zombie_weapons[level.w_octobomb_upgraded].is_in_box = 1;
}

/*
	Name: function_4a0f0038
	Namespace: zm_zod_ee_side
	Checksum: 0x28084E68
	Offset: 0x4A58
	Size: 0x64
	Parameters: 3
	Flags: Linked
*/
function function_4a0f0038(e_attacker, str_means_of_death, weapon)
{
	if(weapon === level.w_octobomb)
	{
		level.var_f11300cd++;
		if(level.var_f11300cd == 100)
		{
			level notify(#"hash_6e41959b");
		}
	}
}

/*
	Name: function_bfe0c3eb
	Namespace: zm_zod_ee_side
	Checksum: 0xAB6EAE64
	Offset: 0x4AC8
	Size: 0x1E6
	Parameters: 1
	Flags: Linked
*/
function function_bfe0c3eb(var_187d070c)
{
	var_52d8dc8d = getentarray("arnie_item", "targetname");
	foreach(var_f0a178a2 in var_52d8dc8d)
	{
		var_b1720580 = distance2dsquared(var_f0a178a2.origin, var_187d070c.origin);
		if(var_b1720580 < 16384)
		{
			if(var_52d8dc8d.size == 1)
			{
				level notify(#"hash_8b3094ce");
			}
			s_spot = struct::get(var_f0a178a2.script_noteworthy);
			var_1ff2613d = util::spawn_model(s_spot.model, s_spot.origin, s_spot.angles);
			var_1ff2613d.targetname = "arnie_stage_item";
			if(isdefined(s_spot.script_float))
			{
				var_1ff2613d setscale(s_spot.script_float);
			}
			var_f0a178a2 delete();
			break;
		}
	}
}

/*
	Name: function_31ef8fd4
	Namespace: zm_zod_ee_side
	Checksum: 0x191C0114
	Offset: 0x4CB8
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_31ef8fd4(var_187d070c)
{
	s_center = struct::get("lil_arnie_stage_center");
	var_b1720580 = distance2dsquared(s_center.origin, var_187d070c.origin);
	if(var_b1720580 < 16384)
	{
		level.octobomb_attack_callback = undefined;
		var_187d070c.b_special_octobomb = 1;
		level thread function_c4842cb1(var_187d070c);
	}
}

/*
	Name: function_c4842cb1
	Namespace: zm_zod_ee_side
	Checksum: 0x93B955D2
	Offset: 0x4D78
	Size: 0x26E
	Parameters: 1
	Flags: Linked
*/
function function_c4842cb1(var_187d070c)
{
	var_187d070c delete();
	var_4d0fab9c = getentarray("arnie_stage_item", "targetname");
	foreach(var_49d8189c in var_4d0fab9c)
	{
		var_49d8189c delete();
		util::wait_network_frame();
	}
	s_center = struct::get("lil_arnie_stage_center");
	foreach(player in level.activeplayers)
	{
		player zm_utility::increment_ignoreme();
	}
	playsoundatposition("zmb_zod_ee_arniedance", s_center.origin);
	level clientfield::set("lil_arnie_dance", 1);
	wait(24);
	foreach(player in level.activeplayers)
	{
		player zm_utility::decrement_ignoreme();
	}
	level notify(#"hash_21edb6b6");
}

/*
	Name: function_41ecaace
	Namespace: zm_zod_ee_side
	Checksum: 0xB8067F10
	Offset: 0x4FF0
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function function_41ecaace()
{
	level flag::wait_till("ritual_pap_complete");
	var_2ede2754 = getentarray("scream_pic", "targetname");
	foreach(var_c671e1b1 in var_2ede2754)
	{
		var_c671e1b1 thread function_8cffc675();
	}
}

/*
	Name: function_8cffc675
	Namespace: zm_zod_ee_side
	Checksum: 0x79A323A1
	Offset: 0x50D0
	Size: 0x14A
	Parameters: 0
	Flags: Linked
*/
function function_8cffc675()
{
	level endon(#"hash_b94b6391");
	while(true)
	{
		self waittill(#"trigger", player);
		if(zm_utility::is_player_valid(player) && function_12b65d38(player getcurrentweapon(), "sniper") && player util::is_ads())
		{
			break;
		}
		wait(0.05);
	}
	player playlocalsound("zmb_zod_egg_scream");
	player.var_92fcfed8 = player openluimenu("JumpScare");
	wait(0.55);
	if(isdefined(player.var_92fcfed8))
	{
		player closeluimenu(player.var_92fcfed8);
	}
	self delete();
	level notify(#"hash_b94b6391");
}

/*
	Name: function_12b65d38
	Namespace: zm_zod_ee_side
	Checksum: 0x88B31B2E
	Offset: 0x5228
	Size: 0x3E
	Parameters: 2
	Flags: Linked
*/
function function_12b65d38(w_current, str_class)
{
	if(issubstr(w_current.name, str_class))
	{
		return true;
	}
	return false;
}

/*
	Name: spare_change
	Namespace: zm_zod_ee_side
	Checksum: 0x497070F5
	Offset: 0x5270
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function spare_change()
{
	a_triggers = getentarray("audio_bump_trigger", "targetname");
	foreach(t_audio_bump in a_triggers)
	{
		if(t_audio_bump.script_sound === "zmb_perks_bump_bottle")
		{
			t_audio_bump thread check_for_change();
		}
	}
}

/*
	Name: check_for_change
	Namespace: zm_zod_ee_side
	Checksum: 0x1BD64CC
	Offset: 0x5350
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function check_for_change()
{
	while(true)
	{
		self waittill(#"trigger", e_player);
		if(e_player getstance() == "prone")
		{
			e_player zm_score::add_to_player_score(100);
			zm_utility::play_sound_at_pos("purchase", e_player.origin);
			break;
		}
		wait(0.15);
	}
}

/*
	Name: function_7a56bf90
	Namespace: zm_zod_ee_side
	Checksum: 0x42A15171
	Offset: 0x53F8
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function function_7a56bf90()
{
	self endon(#"death");
	self.var_c2faf069 = 0;
	self.var_e20230e3 = 0;
	while(true)
	{
		self waittill(#"weapon_melee_juke");
		if(isdefined(self.b_has_upgraded_shield) && self.b_has_upgraded_shield)
		{
			continue;
		}
		if(isdefined(self.hasriotshield) && self.hasriotshield)
		{
			self waittill(#"shield_juke_done");
			self notify(#"hash_4438d786", self.var_c2faf069);
			if(self.var_c2faf069 >= 10)
			{
				self playsoundtoplayer("zmb_zod_ee_bowling_strike", self);
				self.var_e20230e3++;
			}
			else
			{
				self.var_e20230e3 = 0;
			}
			if(self.var_e20230e3 == 12)
			{
				self playsoundtoplayer("zmb_zod_ee_bowling_cheer", self);
				self zm_equipment::buy("zod_riotshield_upgraded");
				self.b_has_upgraded_shield = 1;
				self.var_e20230e3 = 0;
				return;
			}
			self.var_c2faf069 = 0;
		}
		wait(0.05);
	}
}

/*
	Name: function_c6930415
	Namespace: zm_zod_ee_side
	Checksum: 0xEC4D28F2
	Offset: 0x5568
	Size: 0xC6
	Parameters: 1
	Flags: Linked
*/
function function_c6930415(a_enemies)
{
	foreach(e_enemy in a_enemies)
	{
		if(!(isdefined(e_enemy.var_c8b96c1f) && e_enemy.var_c8b96c1f))
		{
			e_enemy.var_c8b96c1f = 1;
			self.var_c2faf069 = self.var_c2faf069 + 1;
		}
	}
}

/*
	Name: function_fa2d33a4
	Namespace: zm_zod_ee_side
	Checksum: 0x9C5685E5
	Offset: 0x5638
	Size: 0x372
	Parameters: 0
	Flags: Linked
*/
function function_fa2d33a4()
{
	level endon(#"hash_5298c49");
	self endon(#"hash_a881e3fa");
	level.var_cfee9316 = 0;
	var_93dad597 = self.var_93dad597;
	var_93dad597.trigger = getent("play_on_map_load_trigger", "targetname");
	var_93dad597.trigger triggerenable(0);
	for(i = 1; i <= 3; i++)
	{
		level waittill(#"start_of_round");
		var_93dad597.trigger triggerenable(1);
		var_93dad597 thread function_b0ea6013();
		var_93dad597 function_b3430866();
		level notify(#"hash_ab07012");
		var_93dad597.trigger triggerenable(0);
		level.var_cfee9316++;
		var_9ef6b569 = level.var_cfee9316 * 5;
		if(level.next_wasp_round <= var_9ef6b569)
		{
			level.next_wasp_round = (5 + (level.wasp_round_count * 10)) + (randomintrange(-1, 1));
			level.wasp_round_count++;
		}
		if(level.n_next_raps_round <= var_9ef6b569)
		{
			level.n_next_raps_round = (10 + (level.raps_round_count * 10)) + (randomintrange(-1, 1));
			level.raps_round_count++;
		}
		if(level.var_bf361dc0 < var_9ef6b569)
		{
			level.var_bf361dc0 = level.var_bf361dc0 + randomintrange(3, 6);
			level.var_b383deb1++;
			if(level.var_bf361dc0 <= 12)
			{
				if(level.var_bf361dc0 == level.n_next_raps_round)
				{
					level.var_bf361dc0 = level.var_bf361dc0 + 2;
				}
				else if(level.var_bf361dc0 == (level.n_next_raps_round + 1))
				{
					level.var_bf361dc0 = level.var_bf361dc0 + 1;
				}
			}
		}
		foreach(player in level.players)
		{
			player.var_8c06218 = 0;
		}
		level thread function_9baef344();
	}
	var_93dad597.trigger delete();
	level notify(#"hash_5298c49");
}

/*
	Name: function_9baef344
	Namespace: zm_zod_ee_side
	Checksum: 0xBB47149B
	Offset: 0x59B8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_9baef344()
{
	if(level.var_cfee9316 > 0)
	{
		playsoundatposition("zmb_zod_ee_roundskip", (0, 0, 0));
		level thread function_456b7848(level.var_cfee9316);
		new_round = level.var_cfee9316 * 5;
		bgb_token::function_c2f81136(new_round - level.round_number);
		level.skip_alive_at_round_end_xp = 1;
		level zm_utility::zombie_goto_round(new_round);
	}
}

/*
	Name: function_b0ea6013
	Namespace: zm_zod_ee_side
	Checksum: 0xAB16450B
	Offset: 0x5A70
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function function_b0ea6013()
{
	level endon(#"hash_5298c49");
	level endon(#"hash_ab07012");
	wait(5);
	if(isdefined(self.trigger))
	{
		self.trigger delete();
	}
	level notify(#"hash_5298c49");
}

/*
	Name: function_b3430866
	Namespace: zm_zod_ee_side
	Checksum: 0x44B2EFD7
	Offset: 0x5AD0
	Size: 0x122
	Parameters: 0
	Flags: Linked
*/
function function_b3430866()
{
	self endon(#"death");
	self thread function_f11d743f();
	while(true)
	{
		var_e66e7864 = 1;
		foreach(player in level.players)
		{
			if(!(isdefined(player.var_8c06218) && player.var_8c06218))
			{
				var_e66e7864 = 0;
				break;
			}
		}
		if(var_e66e7864)
		{
			self.trigger triggerenable(0);
			break;
		}
		wait(0.05);
	}
	self notify(#"hash_dc49142d");
}

/*
	Name: function_f11d743f
	Namespace: zm_zod_ee_side
	Checksum: 0xA8E8F40E
	Offset: 0x5C00
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_f11d743f()
{
	self endon(#"death");
	self endon(#"hash_dc49142d");
	while(true)
	{
		self.trigger waittill(#"damage", n_damage, e_attacker);
		if(!(isdefined(e_attacker.var_8c06218) && e_attacker.var_8c06218))
		{
			e_attacker.var_8c06218 = 1;
		}
	}
}

/*
	Name: function_456b7848
	Namespace: zm_zod_ee_side
	Checksum: 0x9AEB49D9
	Offset: 0x5C90
	Size: 0x152
	Parameters: 1
	Flags: Linked
*/
function function_456b7848(var_c69ea03b)
{
	n_score = 0;
	for(i = 0; i < var_c69ea03b; i++)
	{
		switch(i)
		{
			case 0:
			{
				n_score = n_score + 1000;
				break;
			}
			case 1:
			{
				n_score = n_score + 3000;
				break;
			}
			case 2:
			{
				n_score = n_score + 7000;
				break;
			}
		}
	}
	foreach(player in level.players)
	{
		player zm_score::add_to_player_score(n_score);
	}
}

/*
	Name: function_b943cc04
	Namespace: zm_zod_ee_side
	Checksum: 0xD8439A58
	Offset: 0x5DF0
	Size: 0x272
	Parameters: 0
	Flags: Linked
*/
function function_b943cc04()
{
	level endon(#"hash_41eedc1");
	level.var_4c7e4e43 = getentarray("holly_cart", "targetname");
	level.var_6432377d = getentarray("devil_cart", "targetname");
	level.var_ee921bdc = level.var_4c7e4e43.size;
	level.var_a1445a76 = level.var_6432377d.size;
	/#
		if(getdvarint("") > 0)
		{
			level.var_ee921bdc = 1;
		}
	#/
	level.var_71279923 = getweapon("bouncingbetty");
	zm_zod_util::on_zombie_killed(&function_b134ab6c);
	level thread function_41eedc1();
	level waittill(#"hash_25ff6e8", str_weapon);
	var_7a2a8066 = getweapon(str_weapon);
	foreach(player in level.activeplayers)
	{
		if(player hasweapon(level.var_71279923))
		{
			player zm_weapons::weapon_take(level.var_71279923);
			player zm_weapons::weapon_give(var_7a2a8066);
		}
	}
	if(str_weapon == "bouncingbetty_devil")
	{
		level clientfield::set("change_bouncingbetties", 1);
	}
	else
	{
		level clientfield::set("change_bouncingbetties", 2);
	}
	level notify(#"hash_41eedc1");
}

/*
	Name: function_41eedc1
	Namespace: zm_zod_ee_side
	Checksum: 0x44AE811D
	Offset: 0x6070
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_41eedc1()
{
	level waittill(#"hash_41eedc1");
	arrayremovevalue(level.zombie_death_callbacks, &function_b134ab6c);
}

/*
	Name: function_b134ab6c
	Namespace: zm_zod_ee_side
	Checksum: 0x38AACFFA
	Offset: 0x60B8
	Size: 0x33E
	Parameters: 3
	Flags: Linked
*/
function function_b134ab6c(e_attacker, str_means_of_death, w_weapon)
{
	if(!isdefined(w_weapon) || w_weapon != level.var_71279923)
	{
		return;
	}
	foreach(var_5b58316f in level.var_4c7e4e43)
	{
		if(isdefined(var_5b58316f.var_2e4b6485) && var_5b58316f.var_2e4b6485)
		{
			continue;
		}
		if(distancesquared(var_5b58316f.origin, self.origin) < 40000)
		{
			if(level.var_a1445a76 < level.var_6432377d.size)
			{
				level notify(#"hash_41eedc1");
				return;
			}
			var_5b58316f playsound("zmb_zod_ee_cakefight_devil");
			var_5b58316f.var_2e4b6485 = 1;
			level.var_ee921bdc--;
			playfx(level._effect["lght_marker_flare"], var_5b58316f.origin);
			if(level.var_ee921bdc == 0)
			{
				level notify(#"hash_25ff6e8", "bouncingbetty_devil");
			}
			return;
		}
	}
	foreach(var_5b58316f in level.var_6432377d)
	{
		if(isdefined(var_5b58316f.var_2e4b6485) && var_5b58316f.var_2e4b6485)
		{
			continue;
		}
		if(distancesquared(var_5b58316f.origin, self.origin) < 40000)
		{
			if(level.var_ee921bdc < level.var_4c7e4e43.size)
			{
				level notify(#"hash_41eedc1");
				return;
			}
			var_5b58316f playsound("zmb_zod_ee_cakefight_angel");
			var_5b58316f.var_2e4b6485 = 1;
			level.var_a1445a76--;
			playfx(level._effect["lght_marker_flare"], var_5b58316f.origin);
			if(level.var_a1445a76 == 0)
			{
				level notify(#"hash_25ff6e8", "bouncingbetty_holly");
			}
			return;
		}
	}
}

/*
	Name: function_758cc281
	Namespace: zm_zod_ee_side
	Checksum: 0x3107C06
	Offset: 0x6400
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_758cc281()
{
	createbouncingbettywatcher("bouncingbetty_devil");
}

/*
	Name: function_a3213b07
	Namespace: zm_zod_ee_side
	Checksum: 0xA12C1B94
	Offset: 0x6428
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_a3213b07()
{
	createbouncingbettywatcher("bouncingbetty_holly");
}

/*
	Name: function_284bb3f1
	Namespace: zm_zod_ee_side
	Checksum: 0x116A02
	Offset: 0x6450
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function function_284bb3f1(watcher, owner)
{
	self bouncingbetty::onspawnbouncingbetty(watcher, owner);
}

/*
	Name: function_1bf9d0bf
	Namespace: zm_zod_ee_side
	Checksum: 0xFC6D352C
	Offset: 0x6490
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function function_1bf9d0bf(watcher, owner)
{
	self bouncingbetty::onspawnbouncingbetty(watcher, owner);
}

/*
	Name: createbouncingbettywatcher
	Namespace: zm_zod_ee_side
	Checksum: 0xB3B24962
	Offset: 0x64D0
	Size: 0x1D0
	Parameters: 1
	Flags: Linked
*/
function createbouncingbettywatcher(str_weapon)
{
	watcher = self weaponobjects::createproximityweaponobjectwatcher(str_weapon, self.team);
	if(str_weapon == "bouncingbetty_devil")
	{
		watcher.onspawn = &function_284bb3f1;
	}
	else
	{
		watcher.onspawn = &function_1bf9d0bf;
	}
	watcher.watchforfire = 1;
	watcher.ondetonatecallback = &bouncingbetty::bouncingbettydetonate;
	watcher.activatesound = "wpn_betty_alert";
	watcher.hackable = 1;
	watcher.hackertoolradius = level.equipmenthackertoolradius;
	watcher.hackertooltimems = level.equipmenthackertooltimems;
	watcher.ownergetsassist = 1;
	watcher.ignoredirection = 1;
	watcher.immediatedetonation = 1;
	watcher.immunespecialty = "specialty_immunetriggerbetty";
	watcher.detectionmindist = level.bettymindist;
	watcher.detectiongraceperiod = level.bettygraceperiod;
	watcher.detonateradius = level.bettyradius;
	watcher.stun = &weaponobjects::weaponstun;
	watcher.stuntime = level.bettystuntime;
	watcher.activationdelay = level.bettyactivationdelay;
}

/*
	Name: function_de14e5a1
	Namespace: zm_zod_ee_side
	Checksum: 0x63539B1E
	Offset: 0x66A8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_de14e5a1()
{
	level.var_4cde8c2c = struct::get_array("lion_mouth");
	level thread function_78758203();
}

/*
	Name: function_78758203
	Namespace: zm_zod_ee_side
	Checksum: 0x51BEBAED
	Offset: 0x66F0
	Size: 0x358
	Parameters: 0
	Flags: Linked
*/
function function_78758203()
{
	var_45be765 = struct::get("gum_bank");
	var_45be765 create_unitrigger();
	var_45be765.var_ab341779 = [];
	while(true)
	{
		var_45be765 waittill(#"trigger_activated", e_user);
		n_index = zm_utility::get_player_index(e_user) + 1;
		if(isdefined(e_user.var_339fc6c6) && e_user.var_339fc6c6)
		{
			e_user.var_339fc6c6 = undefined;
			level flag::set("awarded_lion_gumball" + n_index);
			var_45be765.var_251c3637 = struct::get("window_ball" + n_index);
			var_45be765.var_ab341779[n_index] = util::spawn_model("p7_zm_zod_bubblegum_machine_gumball_white", var_45be765.var_251c3637.origin);
			var_45be765.var_ab341779[n_index] thread function_63dde189();
		}
		else if(isdefined(var_45be765.var_ab341779[n_index]) && isdefined(var_45be765.var_ab341779[n_index].var_6cb12f5c))
		{
			if(isdefined(e_user.is_drinking) && e_user.is_drinking > 0)
			{
				wait(0.1);
				continue;
			}
			if(e_user getcurrentweapon() == level.weaponnone)
			{
				wait(0.1);
				continue;
			}
			current_weapon = level.weaponnone;
			if(zm_utility::is_player_valid(e_user))
			{
				current_weapon = e_user getcurrentweapon();
			}
			if(zm_utility::is_player_valid(e_user) && !(e_user.is_drinking > 0) && !zm_utility::is_placeable_mine(current_weapon) && !zm_equipment::is_equipment(current_weapon) && !e_user zm_utility::is_player_revive_tool(current_weapon) && !current_weapon.isheroweapon)
			{
				e_user thread bgb::bgb_gumball_anim(var_45be765.var_ab341779[n_index].var_6cb12f5c, 0);
				var_45be765.var_ab341779[n_index] delete();
			}
		}
	}
}

/*
	Name: function_63dde189
	Namespace: zm_zod_ee_side
	Checksum: 0x530C676E
	Offset: 0x6A50
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_63dde189()
{
	level waittill(#"between_round_over");
	level waittill(#"between_round_over");
	self.var_6cb12f5c = bgb::function_d51db887();
	self setscale(2);
}

/*
	Name: function_7784eba6
	Namespace: zm_zod_ee_side
	Checksum: 0xE1BA6315
	Offset: 0x6AB0
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function function_7784eba6()
{
	self endon(#"death");
	n_index = zm_utility::get_player_index(self) + 1;
	level endon("awarded_lion_gumball" + n_index);
	self.var_fc66e122 = [];
	while(true)
	{
		self waittill(#"grenade_fire", e_grenade, w_weapon);
		if(w_weapon == level.w_widows_wine_grenade)
		{
			self thread function_b0c6ab(e_grenade);
		}
	}
}

/*
	Name: function_b0c6ab
	Namespace: zm_zod_ee_side
	Checksum: 0x5F6DFFD
	Offset: 0x6B68
	Size: 0x216
	Parameters: 1
	Flags: Linked
*/
function function_b0c6ab(e_grenade)
{
	self endon(#"death");
	while(isdefined(e_grenade))
	{
		var_ac44693b = e_grenade.origin;
		wait(0.1);
	}
	var_dae4e184 = 0;
	var_be3ff756 = undefined;
	var_d29e4cff = undefined;
	n_dist_sq = distancesquared(level.var_4cde8c2c[0].origin, var_ac44693b);
	if(n_dist_sq <= 160000)
	{
		foreach(n_index, var_df70f8d0 in level.var_4cde8c2c)
		{
			n_dist_sq = distancesquared(var_df70f8d0.origin, var_ac44693b);
			if(n_dist_sq <= 36)
			{
				var_be3ff756 = var_df70f8d0;
				var_d29e4cff = n_index;
				if(!isdefined(self.var_fc66e122[n_index]))
				{
					self.var_fc66e122[n_index] = var_df70f8d0;
					var_dae4e184 = 1;
					if(self.var_fc66e122.size == level.var_4cde8c2c.size)
					{
						self function_edf5d07();
					}
				}
				break;
			}
		}
	}
	if(!var_dae4e184)
	{
		self.var_fc66e122 = [];
		if(isdefined(var_be3ff756))
		{
			self.var_fc66e122[var_d29e4cff] = var_be3ff756;
		}
	}
}

/*
	Name: function_edf5d07
	Namespace: zm_zod_ee_side
	Checksum: 0x123B317F
	Offset: 0x6D88
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function function_edf5d07()
{
	self endon(#"death");
	n_index = zm_utility::get_player_index(self) + 1;
	var_251c3637 = struct::get("lion_mouth_ball" + n_index);
	var_ab341779 = util::spawn_model("p7_zm_zod_bubblegum_machine_gumball_white", var_251c3637.origin);
	var_ab341779 create_unitrigger();
	var_ab341779 playsound("zmb_zod_ee_liontamer_roar");
	while(true)
	{
		var_ab341779 waittill(#"trigger_activated", e_user);
		if(e_user == self)
		{
			e_user playsound("zmb_zod_ee_liontamer_pickup");
			break;
		}
	}
	self.var_339fc6c6 = 1;
	zm_unitrigger::unregister_unitrigger(var_ab341779.s_unitrigger);
	var_ab341779 delete();
}

/*
	Name: function_5045e366
	Namespace: zm_zod_ee_side
	Checksum: 0xCB853EB0
	Offset: 0x6EE8
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function function_5045e366()
{
	level flag::wait_till("ritual_pap_complete");
	while(!level.zones["zone_junction_start"].is_occupied && !level.zones["zone_junction_slums"].is_occupied && !level.zones["zone_junction_canal"].is_occupied && !level.zones["zone_junction_theater"].is_occupied)
	{
		wait(1);
	}
	s_start = struct::get("alcatraz_plane_start");
	var_aab7a6d1 = util::spawn_model("p7_zm_der_alcatraz_plane", s_start.origin, s_start.angles);
	s_end = struct::get(s_start.target);
	var_aab7a6d1 moveto(s_end.origin, 30);
	var_aab7a6d1 playloopsound("zmb_zod_ee_motd_plane", 5);
	var_aab7a6d1 waittill(#"movedone");
	var_aab7a6d1 delete();
}

/*
	Name: function_8faf1d24
	Namespace: zm_zod_ee_side
	Checksum: 0xF711DE65
	Offset: 0x70A0
	Size: 0x108
	Parameters: 4
	Flags: Linked
*/
function function_8faf1d24(v_color = vectorscale((0, 0, 1), 255), var_8882142e = "+", n_scale = 0.25, str_endon = "trigger_activated")
{
	/#
		if(getdvarint("") == 0)
		{
			return;
		}
		if(isdefined(str_endon))
		{
			self endon(str_endon);
		}
		origin = self.origin;
		while(true)
		{
			print3d(origin, var_8882142e, v_color, n_scale);
			wait(0.1);
		}
	#/
}

/*
	Name: create_unitrigger
	Namespace: zm_zod_ee_side
	Checksum: 0xA06EE79F
	Offset: 0x71B0
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function create_unitrigger(str_hint)
{
	s_unitrigger = spawnstruct();
	s_unitrigger.origin = self.origin;
	s_unitrigger.angles = self.angles;
	s_unitrigger.script_unitrigger_type = "unitrigger_radius_use";
	s_unitrigger.cursor_hint = "HINT_NOICON";
	s_unitrigger.str_hint = str_hint;
	s_unitrigger.prompt_and_visibility_func = &unitrigger_prompt_and_visibility;
	s_unitrigger.related_parent = self;
	s_unitrigger.radius = 64;
	self.s_unitrigger = s_unitrigger;
	zm_unitrigger::register_static_unitrigger(s_unitrigger, &unitrigger_logic);
}

/*
	Name: unitrigger_prompt_and_visibility
	Namespace: zm_zod_ee_side
	Checksum: 0x699E91BE
	Offset: 0x72B8
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function unitrigger_prompt_and_visibility(player)
{
	b_visible = 1;
	if(isdefined(player.var_d89174ae) && player.var_d89174ae || (isdefined(player.beastmode) && player.beastmode))
	{
		b_visible = 0;
	}
	else if(isdefined(self.stub.str_hint))
	{
		self sethintstring(self.stub.str_hint);
	}
	return b_visible;
}

/*
	Name: unitrigger_logic
	Namespace: zm_zod_ee_side
	Checksum: 0x1059C7DC
	Offset: 0x7370
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function unitrigger_logic()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.is_drinking > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		self.stub.related_parent notify(#"trigger_activated", player);
	}
}

