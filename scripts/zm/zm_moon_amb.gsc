// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_equip_gasmask;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_moon_amb;

#namespace zm_moon_amb;

/*
	Name: main
	Namespace: zm_moon_amb
	Checksum: 0xE2B6C551
	Offset: 0x998
	Size: 0x27C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level._audio_custom_weapon_check = &weapon_type_check_custom;
	level._custom_intro_vox = &no_intro_vox;
	level._do_player_or_npc_playvox_override = &do_player_playvox_custom;
	level.player_4_vox_override = 0;
	level.been_to_moon_before = 0;
	level.var_61f315ab = &function_3630300b;
	level.audio_zones_breached = [];
	level.audio_zones_breached["1"] = 0;
	level.audio_zones_breached["2a"] = 0;
	level.audio_zones_breached["2b"] = 0;
	level.audio_zones_breached["3a"] = 0;
	level.audio_zones_breached["3b"] = 0;
	level.audio_zones_breached["4a"] = 0;
	level.audio_zones_breached["4b"] = 0;
	level.audio_zones_breached["5"] = 0;
	level thread setup_music_egg();
	level thread waitfor_forest_zone_entry();
	level thread poweron_vox();
	level thread setup_moon_visit_vox();
	level thread intro_vox_or_skit();
	level thread eight_bit_easteregg();
	level thread radio_setup();
	level thread function_45b4acf2();
	level thread function_c844cebe();
	callback::on_spawned(&function_10ffc7d7);
	clientfield::register("allplayers", "beam_fx_audio", 21000, 1, "counter");
	clientfield::register("world", "teleporter_audio_sfx", 21000, 1, "counter");
}

/*
	Name: function_10ffc7d7
	Namespace: zm_moon_amb
	Checksum: 0xB85EA26A
	Offset: 0xC20
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_10ffc7d7()
{
	if(!isdefined(self.var_626b83bf))
	{
		self.var_626b83bf = 1;
		level thread zm_audio::sndmusicsystem_playstate("none");
	}
}

/*
	Name: radio_setup
	Namespace: zm_moon_amb
	Checksum: 0xF1F1129
	Offset: 0xC68
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function radio_setup()
{
	var_1a5f0b42 = struct::get_array("egg_radios", "targetname");
	array::thread_all(var_1a5f0b42, &play_radio_eastereggs);
}

/*
	Name: play_radio_eastereggs
	Namespace: zm_moon_amb
	Checksum: 0x425BDB55
	Offset: 0xCC8
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function play_radio_eastereggs()
{
	self zm_unitrigger::create_unitrigger();
	/#
		self thread zm_utility::print3d_ent("", (0, 1, 0), 3, vectorscale((0, 0, 1), 24));
	#/
	while(true)
	{
		self waittill(#"trigger_activated");
		if(isdefined(self.script_noteworthy))
		{
			breakout = self checkfor_radio_override();
			if(breakout)
			{
				break;
			}
			continue;
		}
		break;
	}
	/#
		self notify(#"end_print3d");
	#/
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	playsoundatposition("vox_story_1_log_" + self.script_int, self.origin);
}

/*
	Name: checkfor_radio_override
	Namespace: zm_moon_amb
	Checksum: 0xF112B1E4
	Offset: 0xDE0
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function checkfor_radio_override()
{
	if(!isdefined(level.glass))
	{
		return true;
	}
	for(i = 0; i < level.glass.size; i++)
	{
		if(level.glass[i].damage_state == 1)
		{
			for(j = 0; j < level.glass[i].fxpos_array.size; j++)
			{
				glass_origin = level.glass[i].fxpos_array[j].origin;
				if(distancesquared(glass_origin, self.origin) < 2500)
				{
					return true;
				}
			}
		}
	}
	return false;
}

/*
	Name: eight_bit_easteregg
	Namespace: zm_moon_amb
	Checksum: 0xF8D7F869
	Offset: 0xEF0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function eight_bit_easteregg()
{
	structs = struct::get_array("8bitsongs", "targetname");
	array::thread_all(structs, &waitfor_eightbit_use);
}

/*
	Name: waitfor_eightbit_use
	Namespace: zm_moon_amb
	Checksum: 0x7B6F35CF
	Offset: 0xF50
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function waitfor_eightbit_use()
{
	level flag::wait_till("power_on");
	self zm_unitrigger::create_unitrigger();
	/#
		self thread zm_utility::print3d_ent("", (1, 0, 1), 3, vectorscale((0, 0, 1), 24));
	#/
	n_count = 0;
	while(true)
	{
		self waittill(#"trigger_activated");
		if(!zm_audio_zhd::function_8090042c())
		{
			continue;
		}
		playsoundatposition("zmb_8bit_button_" + n_count, self.origin);
		n_count++;
		if(n_count >= 3)
		{
			break;
		}
		wait(1);
	}
	/#
		self notify(#"end_print3d");
	#/
	level thread zm_audio::sndmusicsystem_playstate(self.script_string);
}

/*
	Name: no_intro_vox
	Namespace: zm_moon_amb
	Checksum: 0x99EC1590
	Offset: 0x1088
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function no_intro_vox()
{
}

/*
	Name: intro_vox_or_skit
	Namespace: zm_moon_amb
	Checksum: 0xDBB42047
	Offset: 0x1098
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function intro_vox_or_skit()
{
	wait(1);
	level flag::wait_till("start_zombie_round_logic");
	playsoundatposition("evt_warp_in", (0, 0, 0));
	wait(3);
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("general", "start");
}

/*
	Name: poweron_vox
	Namespace: zm_moon_amb
	Checksum: 0xD390EFF7
	Offset: 0x1150
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function poweron_vox()
{
	wait(3);
	level flag::wait_till("power_on");
	wait(20);
	level thread play_mooncomp_vox("vox_mcomp_power");
}

/*
	Name: audio_alias_override
	Namespace: zm_moon_amb
	Checksum: 0x68FE41C
	Offset: 0x11A0
	Size: 0x696
	Parameters: 0
	Flags: None
*/
function audio_alias_override()
{
	level.plr_vox["kill"]["explosive"] = "kill_explosive";
	level.plr_vox["kill"]["explosive_response"] = undefined;
	level.plr_vox["weapon_pickup"]["microwave"] = "wpck_microwave";
	level.plr_vox["weapon_pickup"]["microwave_response"] = undefined;
	level.plr_vox["weapon_pickup"]["quantum"] = "wpck_quantum";
	level.plr_vox["weapon_pickup"]["quantum_response"] = undefined;
	level.plr_vox["weapon_pickup"]["gasmask"] = "wpck_gasmask";
	level.plr_vox["weapon_pickup"]["gasmask_response"] = undefined;
	level.plr_vox["weapon_pickup"]["hacker"] = "wpck_hacker";
	level.plr_vox["weapon_pickup"]["hacker_response"] = undefined;
	level.plr_vox["kill"]["micro_dual"] = "kill_micro_dual";
	level.plr_vox["kill"]["micro_dual_response"] = undefined;
	level.plr_vox["kill"]["micro_single"] = "kill_micro_single";
	level.plr_vox["kill"]["micro_single_response"] = undefined;
	level.plr_vox["kill"]["quant_good"] = "kill_quant_good";
	level.plr_vox["kill"]["quant_good_response"] = undefined;
	level.plr_vox["kill"]["quant_bad"] = "kill_quant_bad";
	level.plr_vox["kill"]["quant_bad_response"] = undefined;
	level.plr_vox["digger"] = [];
	level.plr_vox["digger"]["incoming"] = "digger_incoming";
	level.plr_vox["digger"]["incoming_response"] = undefined;
	level.plr_vox["digger"]["breach"] = "digger_breach";
	level.plr_vox["digger"]["breach_response"] = undefined;
	level.plr_vox["digger"]["hacked"] = "digger_hacked";
	level.plr_vox["digger"]["hacked_response"] = undefined;
	level.plr_vox["general"]["astro_spawn"] = "spawn_astro";
	level.plr_vox["general"]["astro_spawn_response"] = undefined;
	level.plr_vox["kill"]["astro"] = "kill_astro";
	level.plr_vox["kill"]["astro_response"] = undefined;
	level.plr_vox["general"]["biodome"] = "location_biodome";
	level.plr_vox["general"]["biodome_response"] = undefined;
	level.plr_vox["general"]["jumppad"] = "jumppad";
	level.plr_vox["general"]["jumppad_response"] = undefined;
	level.plr_vox["general"]["teleporter"] = "teleporter";
	level.plr_vox["general"]["teleporter_response"] = undefined;
	level.plr_vox["perk"]["specialty_additionalprimaryweapon"] = "perk_arsenal";
	level.plr_vox["perk"]["specialty_additionalprimaryweapon_response"] = undefined;
	level.plr_vox["powerup"]["bonus_points_solo"] = "powerup_pts_solo";
	level.plr_vox["powerup"]["bonus_points_solo_response"] = undefined;
	level.plr_vox["powerup"]["bonus_points_team"] = "powerup_pts_team";
	level.plr_vox["powerup"]["bonus_points_team_response"] = undefined;
	level.plr_vox["powerup"]["lose_points"] = "powerup_antipts_zmb";
	level.plr_vox["powerup"]["lose_points_response"] = undefined;
	level.plr_vox["general"]["hack_plr"] = "hack_plr";
	level.plr_vox["general"]["hack_plr_response"] = undefined;
	level.plr_vox["general"]["hack_vox"] = "hack_vox";
	level.plr_vox["general"]["hack_vox_response"] = undefined;
	level.plr_vox["general"]["airless"] = "location_airless";
	level.plr_vox["general"]["airless_response"] = undefined;
	level.plr_vox["general"]["moonjump"] = "moonjump";
	level.plr_vox["general"]["moonjump_response"] = undefined;
	level.plr_vox["weapon_pickup"]["grenade"] = "wpck_launcher";
	level.plr_vox["weapon_pickup"]["grenade_response"] = undefined;
}

/*
	Name: force_player4_override
	Namespace: zm_moon_amb
	Checksum: 0x8D26C952
	Offset: 0x1840
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function force_player4_override()
{
	wait(60);
	level thread player_4_override();
}

/*
	Name: player_4_override
	Namespace: zm_moon_amb
	Checksum: 0xAB8BE9FB
	Offset: 0x1868
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function player_4_override()
{
	level.player_4_vox_override = 1;
	level.zmannouncerprefix = "vox_zmbar_";
	foreach(player in level.players)
	{
		if(isdefined(player.characterindex) && player.characterindex == 2)
		{
			player.issamantha = 1;
		}
	}
}

/*
	Name: do_player_playvox_custom
	Namespace: zm_moon_amb
	Checksum: 0x606965EC
	Offset: 0x1940
	Size: 0x100
	Parameters: 5
	Flags: Linked
*/
function do_player_playvox_custom(sound_to_play, waittime, category, type, override)
{
	players = getplayers();
	if(!isdefined(level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	if(isdefined(level.skit_vox_override) && level.skit_vox_override && (!(isdefined(override) && override)))
	{
		return;
	}
	if(isdefined(self.in_low_gravity) && self.in_low_gravity && !self zm_equip_gasmask::gasmask_active())
	{
		return;
	}
	if(level.player_is_speaking != 1)
	{
		level.player_is_speaking = 1;
		self play_futz_or_not_moonvox(sound_to_play);
		level.player_is_speaking = 0;
	}
}

/*
	Name: play_futz_or_not_moonvox
	Namespace: zm_moon_amb
	Checksum: 0x6B871264
	Offset: 0x1A48
	Size: 0x112
	Parameters: 1
	Flags: Linked
*/
function play_futz_or_not_moonvox(sound_to_play)
{
	players = getplayers();
	if(self.sessionstate == "spectator")
	{
		return;
	}
	for(i = 0; i < players.size; i++)
	{
		if(self zm_equipment::is_active(level.var_f486078e))
		{
			if(self == players[i])
			{
				self playsoundwithnotify(sound_to_play + "_f", "sound_done" + sound_to_play);
			}
			continue;
		}
		if(self == players[i])
		{
			self playsoundwithnotify(sound_to_play, "sound_done" + sound_to_play);
		}
	}
	self waittill("sound_done" + sound_to_play);
}

/*
	Name: weapon_type_check_custom
	Namespace: zm_moon_amb
	Checksum: 0xDE432CF0
	Offset: 0x1B68
	Size: 0x2AE
	Parameters: 2
	Flags: Linked
*/
function weapon_type_check_custom(weapon, magic_box)
{
	if(!isdefined(self.entity_num))
	{
		return "crappy";
	}
	switch(self.entity_num)
	{
		case 0:
		{
			if(weapon == getweapon("m16"))
			{
				return "favorite";
			}
			else if(weapon == getweapon("m16_gl_upgraded"))
			{
				return "favorite_upgrade";
			}
			break;
		}
		case 1:
		{
			if(weapon == getweapon("fnfal"))
			{
				return "favorite";
			}
			else if(weapon == getweapon("hk21_upgraded"))
			{
				return "favorite_upgrade";
			}
			break;
		}
		case 2:
		{
			if(weapon == getweapon("ak74u"))
			{
				return "favorite";
			}
			else if(weapon == getweapon("m14_upgraded"))
			{
				return "favorite_upgrade";
			}
			break;
		}
		case 3:
		{
			if(!(isdefined(level.player_4_vox_override) && level.player_4_vox_override))
			{
				if(weapon == getweapon("spectre"))
				{
					return "favorite";
				}
				else if(weapon == getweapon("g11_lps_upgraded"))
				{
					return "favorite_upgrade";
				}
			}
			else
			{
				if(weapon == getweapon("spas"))
				{
					return "favorite";
				}
				else if(weapon == getweapon("mp40_upgraded"))
				{
					return "favorite_upgrade";
				}
			}
			break;
		}
	}
	if(issubstr(weapon.name, "upgraded"))
	{
		return "upgrade";
	}
	w_root = weapon.rootweapon;
	return level.zombie_weapons[w_root].vox;
}

/*
	Name: setup_music_egg
	Namespace: zm_moon_amb
	Checksum: 0x97332FDA
	Offset: 0x1E20
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function setup_music_egg()
{
	level thread zm_audio_zhd::function_e753d4f();
	level flag::wait_till("snd_song_completed");
	level thread zm_audio::sndmusicsystem_playstate("cominghome");
}

/*
	Name: waitfor_override
	Namespace: zm_moon_amb
	Checksum: 0x12DDC9DC
	Offset: 0x1E88
	Size: 0x22
	Parameters: 0
	Flags: None
*/
function waitfor_override()
{
	if(isdefined(level.music_override) && level.music_override)
	{
		return false;
	}
	return true;
}

/*
	Name: play_mooncomp_vox
	Namespace: zm_moon_amb
	Checksum: 0x7801A022
	Offset: 0x1EB8
	Size: 0x108
	Parameters: 2
	Flags: Linked
*/
function play_mooncomp_vox(alias, digger)
{
	if(!isdefined(alias))
	{
		return;
	}
	if(!level.on_the_moon)
	{
		return;
	}
	num = 0;
	if(isdefined(digger))
	{
		switch(digger)
		{
			case "hangar":
			{
				num = 1;
				break;
			}
			case "teleporter":
			{
				num = 0;
				break;
			}
			case "biodome":
			{
				num = 2;
				break;
			}
		}
	}
	else
	{
		num = "";
	}
	if(!isdefined(level.mooncomp_is_speaking))
	{
		level.mooncomp_is_speaking = 0;
	}
	if(level.mooncomp_is_speaking == 0)
	{
		level.mooncomp_is_speaking = 1;
		level do_mooncomp_vox(alias + num);
		level.mooncomp_is_speaking = 0;
	}
}

/*
	Name: do_mooncomp_vox
	Namespace: zm_moon_amb
	Checksum: 0xF4AD5DD9
	Offset: 0x1FC8
	Size: 0x15A
	Parameters: 1
	Flags: Linked
*/
function do_mooncomp_vox(alias)
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] zm_equipment::is_active(level.var_f486078e))
		{
			players[i] playsoundtoplayer(alias + "_f", players[i]);
		}
	}
	if(!isdefined(level.var_2ff0efb3))
	{
		return;
	}
	foreach(speaker in level.var_2ff0efb3)
	{
		playsoundatposition(alias, speaker.origin);
		wait(0.05);
	}
}

/*
	Name: function_c844cebe
	Namespace: zm_moon_amb
	Checksum: 0xE7910B5B
	Offset: 0x2130
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function function_c844cebe()
{
	level.var_2ff0efb3 = struct::get_array("sndMoonPa", "targetname");
	if(!isdefined(level.var_2ff0efb3))
	{
		return;
	}
}

/*
	Name: waitfor_forest_zone_entry
	Namespace: zm_moon_amb
	Checksum: 0xA8DF5067
	Offset: 0x2178
	Size: 0x148
	Parameters: 0
	Flags: Linked
*/
function waitfor_forest_zone_entry()
{
	level waittill(#"forest_zone");
	while(true)
	{
		zone = level.zones["forest_zone"];
		players = getplayers();
		for(i = 0; i < zone.volumes.size; i++)
		{
			for(j = 0; j < players.size; j++)
			{
				if(players[j] istouching(zone.volumes[i]) && !players[j].sessionstate == "spectator")
				{
					players[j] thread zm_audio::create_and_play_dialog("general", "biodome");
					return;
				}
			}
		}
		wait(0.5);
	}
}

/*
	Name: setup_moon_visit_vox
	Namespace: zm_moon_amb
	Checksum: 0x1878A234
	Offset: 0x22C8
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function setup_moon_visit_vox()
{
	wait(5);
	level flag::wait_till("start_zombie_round_logic");
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread play_delayed_first_time_vox();
	}
	level thread waitfor_first_player();
}

/*
	Name: play_delayed_first_time_vox
	Namespace: zm_moon_amb
	Checksum: 0x856EE953
	Offset: 0x2370
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function play_delayed_first_time_vox()
{
	self endon(#"death");
	self endon(#"disconnect");
	self waittill(#"equip_gasmask_activate");
	self waittill(#"weapon_change_complete");
	self playsoundtoplayer("vox_mcomp_suit_on", self);
	wait(1.5);
	self playsoundtoplayer("vox_mcomp_start", self);
	wait(7);
	self thread play_maskon_vox();
	self thread play_warning_vox();
	level notify(#"first_player_vox", self);
}

/*
	Name: waitfor_first_player
	Namespace: zm_moon_amb
	Checksum: 0x6B268D8B
	Offset: 0x2438
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function waitfor_first_player()
{
	level waittill(#"first_player_vox", who);
	who thread zm_audio::create_and_play_dialog("general", "moonbase");
}

/*
	Name: play_maskon_vox
	Namespace: zm_moon_amb
	Checksum: 0xADEE84E2
	Offset: 0x2488
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function play_maskon_vox()
{
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"equip_gasmask_activate");
		self waittill(#"weapon_change_complete");
		self stopsounds();
		wait(0.05);
		self playsoundtoplayer("vox_mcomp_suit_on", self);
	}
}

/*
	Name: play_warning_vox
	Namespace: zm_moon_amb
	Checksum: 0x5269F62
	Offset: 0x2510
	Size: 0x142
	Parameters: 0
	Flags: Linked
*/
function play_warning_vox()
{
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		while(!self.in_low_gravity)
		{
			wait(0.1);
		}
		if(isdefined(self.in_low_gravity && self hasweapon(level.var_f486078e) && !self zm_equip_gasmask::gasmask_active()) && self.in_low_gravity && self hasweapon(level.var_f486078e) && !self zm_equip_gasmask::gasmask_active())
		{
			self stopsounds();
			wait(0.05);
			self playsoundtoplayer("vox_mcomp_suit_reminder", self);
			while(self.in_low_gravity)
			{
				if(self zm_equip_gasmask::gasmask_active())
				{
					break;
				}
				wait(0.1);
			}
		}
		wait(8);
	}
}

/*
	Name: function_45b4acf2
	Namespace: zm_moon_amb
	Checksum: 0x4FCE8307
	Offset: 0x2660
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_45b4acf2()
{
	var_757351da = struct::get_array("zhdbuttons", "targetname");
	array::thread_all(var_757351da, &function_1d6f553d);
	level thread function_e091daa4();
	var_22ee0088 = array(1, 2, 2, 3, 3, 2, 3, 4, 3, 4, 3, 2, 2, 4, 1);
	var_c957db9f = 0;
	while(var_c957db9f < var_22ee0088.size)
	{
		level waittill(#"hash_351576b1", var_333c1c87);
		if(var_333c1c87 == var_22ee0088[var_c957db9f])
		{
			var_c957db9f++;
		}
		else
		{
			var_c957db9f = 0;
		}
	}
	level flag::set("snd_zhdegg_activate");
}

/*
	Name: function_1d6f553d
	Namespace: zm_moon_amb
	Checksum: 0x7ED629E2
	Offset: 0x27B0
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_1d6f553d()
{
	level endon(#"snd_zhdegg_activate");
	self zm_unitrigger::create_unitrigger();
	while(true)
	{
		self waittill(#"trigger_activated");
		playsoundatposition("zmb_zhdmoon_button_" + self.script_int, self.origin);
		level notify(#"hash_351576b1", self.script_int);
		wait(0.5);
	}
}

/*
	Name: function_e091daa4
	Namespace: zm_moon_amb
	Checksum: 0xE9231E7D
	Offset: 0x2840
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function function_e091daa4()
{
	level endon(#"snd_zhdegg_activate");
	var_924a65e5 = spawn("script_origin", (919, -303, -171));
	while(true)
	{
		wait(randomfloatrange(60, 120));
		var_924a65e5 playsoundwithnotify("zmb_zhdmoon_voices", "sounddone");
		var_924a65e5 waittill(#"sounddone");
	}
}

/*
	Name: function_3630300b
	Namespace: zm_moon_amb
	Checksum: 0xB144CB80
	Offset: 0x28E8
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function function_3630300b()
{
	var_d1f154fd = struct::get_array("s_ballerina_timed", "targetname");
	var_d1f154fd = array::sort_by_script_int(var_d1f154fd, 1);
	level.var_aa39de8 = 0;
	wait(1);
	foreach(var_6d450235 in var_d1f154fd)
	{
		var_6d450235 thread function_b8227f87();
		wait(1);
	}
	while(level.var_aa39de8 < var_d1f154fd.size)
	{
		wait(0.1);
	}
	wait(1);
	return true;
}

/*
	Name: function_b8227f87
	Namespace: zm_moon_amb
	Checksum: 0xC5C5E242
	Offset: 0x2A10
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_b8227f87()
{
	self.var_ac086ffb = util::spawn_model(self.model, self.origin, self.angles);
	self.var_ac086ffb clientfield::set("snd_zhdegg", 1);
	self.var_ac086ffb playloopsound("mus_musicbox_lp", 2);
	self thread zm_audio_zhd::function_9d55fd08();
	self thread zm_audio_zhd::function_2fdaabf3();
	self util::waittill_any("ballerina_destroyed");
	level.var_aa39de8++;
	self.var_ac086ffb clientfield::set("snd_zhdegg", 0);
	util::wait_network_frame();
	self.var_ac086ffb delete();
}

