// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_factory;

#namespace zm_factory_teleporter;

/*
	Name: __init__sytem__
	Namespace: zm_factory_teleporter
	Checksum: 0x91A8C2AE
	Offset: 0x740
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_factory_teleporter", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_factory_teleporter
	Checksum: 0x660D51B4
	Offset: 0x788
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.dog_melee_range = 130;
	level thread dog_blocker_clip();
	level.teleport = [];
	level.active_links = 0;
	level.countdown = 0;
	level.teleport_delay = 2;
	level.teleport_cost = 1500;
	level.teleport_cooldown = 5;
	level.is_cooldown = 0;
	level.active_timer = -1;
	level.teleport_time = 0;
	level.teleport_pad_names = [];
	level.teleport_pad_names[0] = "a";
	level.teleport_pad_names[1] = "c";
	level.teleport_pad_names[2] = "b";
	level flag::init("teleporter_pad_link_1");
	level flag::init("teleporter_pad_link_2");
	level flag::init("teleporter_pad_link_3");
	visionset_mgr::register_info("overlay", "zm_factory_teleport", 1, 61, 1, 1);
}

/*
	Name: __main__
	Namespace: zm_factory_teleporter
	Checksum: 0x2BB30DA1
	Offset: 0x900
	Size: 0x256
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	for(i = 0; i < 3; i++)
	{
		trig = getent("trigger_teleport_pad_" + i, "targetname");
		if(isdefined(trig))
		{
			level.teleporter_pad_trig[i] = trig;
		}
	}
	level thread teleport_pad_think(0);
	level thread teleport_pad_think(1);
	level thread teleport_pad_think(2);
	level thread teleport_core_think();
	level thread init_pack_door();
	level.no_dog_clip = 1;
	packapunch_see = getent("packapunch_see", "targetname");
	if(isdefined(packapunch_see))
	{
		packapunch_see thread play_packa_see_vox();
	}
	level.teleport_ae_funcs = [];
	if(!issplitscreen())
	{
		level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_fov;
	}
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_shellshock;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_shellshock_electric;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_bw_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_red_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_flashy_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_flare_vision;
}

/*
	Name: init_pack_door
	Namespace: zm_factory_teleporter
	Checksum: 0xFFD88330
	Offset: 0xB60
	Size: 0x336
	Parameters: 0
	Flags: Linked
*/
function init_pack_door()
{
	collision = spawn("script_model", (-56, 467, 157));
	collision setmodel("collision_wall_128x128x10");
	collision.angles = (0, 0, 0);
	collision hide();
	door = getent("pack_door", "targetname");
	door movez(-50, 0.05, 0);
	wait(1);
	level flag::wait_till("start_zombie_round_logic");
	door movez(50, 1.5, 0);
	door playsound("evt_packa_door_1");
	wait(2);
	collision delete();
	level flag::wait_till("teleporter_pad_link_1");
	door movez(-35, 1.5, 1);
	door playsound("evt_packa_door_2");
	door thread packa_door_reminder();
	wait(2);
	level flag::wait_till("teleporter_pad_link_2");
	door movez(-25, 1.5, 1);
	door playsound("evt_packa_door_2");
	wait(2);
	level flag::wait_till("teleporter_pad_link_3");
	door movez(-60, 1.5, 1);
	door playsound("evt_packa_door_2");
	clip = getentarray("pack_door_clip", "targetname");
	for(i = 0; i < clip.size; i++)
	{
		clip[i] connectpaths();
		clip[i] delete();
	}
}

/*
	Name: pad_manager
	Namespace: zm_factory_teleporter
	Checksum: 0xFF47D615
	Offset: 0xEA0
	Size: 0x12E
	Parameters: 0
	Flags: Linked
*/
function pad_manager()
{
	for(i = 0; i < level.teleporter_pad_trig.size; i++)
	{
		level.teleporter_pad_trig[i] sethintstring(&"ZOMBIE_TELEPORT_COOLDOWN");
		level.teleporter_pad_trig[i] teleport_trigger_invisible(0);
	}
	level.is_cooldown = 1;
	wait(level.teleport_cooldown);
	level.is_cooldown = 0;
	for(i = 0; i < level.teleporter_pad_trig.size; i++)
	{
		if(level.teleporter_pad_trig[i].teleport_active)
		{
			level.teleporter_pad_trig[i] sethintstring(&"ZOMBIE_TELEPORT_TO_CORE");
			continue;
		}
		level.teleporter_pad_trig[i] sethintstring(&"ZOMBIE_LINK_TPAD");
	}
}

/*
	Name: teleport_pad_think
	Namespace: zm_factory_teleporter
	Checksum: 0xFC60D137
	Offset: 0xFD8
	Size: 0x3DC
	Parameters: 1
	Flags: Linked
*/
function teleport_pad_think(index)
{
	tele_help = getent("tele_help_" + index, "targetname");
	if(isdefined(tele_help))
	{
		tele_help thread play_tele_help_vox();
	}
	active = 0;
	level.teleport[index] = "waiting";
	trigger = level.teleporter_pad_trig[index];
	trigger setcursorhint("HINT_NOICON");
	trigger sethintstring(&"ZOMBIE_NEED_POWER");
	level flag::wait_till("power_on");
	trigger sethintstring(&"ZOMBIE_POWER_UP_TPAD");
	trigger.teleport_active = 0;
	if(isdefined(trigger))
	{
		while(!active)
		{
			trigger waittill(#"trigger");
			if(level.active_links < 3)
			{
				trigger_core = getent("trigger_teleport_core", "targetname");
				trigger_core teleport_trigger_invisible(0);
			}
			for(i = 0; i < level.teleporter_pad_trig.size; i++)
			{
				level.teleporter_pad_trig[i] teleport_trigger_invisible(1);
			}
			level.teleport[index] = "timer_on";
			trigger thread teleport_pad_countdown(index, 30);
			teleporter_vo("countdown", trigger);
			while(level.teleport[index] == "timer_on")
			{
				wait(0.05);
			}
			if(level.teleport[index] == "active")
			{
				active = 1;
				level util::clientnotify("pw" + index);
				level util::clientnotify("tp" + index);
				teleporter_wire_wait(index);
				trigger thread player_teleporting(index);
			}
			else
			{
				for(i = 0; i < level.teleporter_pad_trig.size; i++)
				{
					level.teleporter_pad_trig[i] teleport_trigger_invisible(0);
				}
			}
			wait(0.05);
		}
		if(level.is_cooldown)
		{
			trigger sethintstring(&"ZOMBIE_TELEPORT_COOLDOWN");
			trigger teleport_trigger_invisible(0);
			trigger.teleport_active = 1;
		}
		else
		{
			trigger thread teleport_pad_active_think(index);
		}
	}
}

/*
	Name: teleport_pad_countdown
	Namespace: zm_factory_teleporter
	Checksum: 0x8485C858
	Offset: 0x13C0
	Size: 0x154
	Parameters: 2
	Flags: Linked
*/
function teleport_pad_countdown(index, time)
{
	self endon(#"stop_countdown");
	if(level.active_timer < 0)
	{
		level.active_timer = index;
	}
	level.countdown++;
	self thread sndcountdown();
	level util::clientnotify("TRf");
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread zm_timer::start_timer(time + 1, "stop_countdown");
	}
	wait(time + 1);
	if(level.active_timer == index)
	{
		level.active_timer = -1;
	}
	level.teleport[index] = "timer_off";
	level util::clientnotify("TRs");
	level.countdown--;
}

/*
	Name: sndcountdown
	Namespace: zm_factory_teleporter
	Checksum: 0x5EA3D68E
	Offset: 0x1520
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function sndcountdown()
{
	self endon(#"stop_countdown");
	clock_sound = spawn("script_origin", (0, 0, 0));
	clock_sound thread clock_timer();
	level thread zm_factory::sndpa_dovox("vox_maxis_teleporter_ultimatum_0");
	count = 30;
	num = 11;
	while(count > 0)
	{
		play = count == 20 || count == 15 || count <= 10;
		if(play)
		{
			level thread zm_factory::sndpa_dovox("vox_maxis_teleporter_count_" + num, undefined, 1);
			num--;
		}
		wait(1);
		count--;
	}
	level notify(#"stop_countdown");
	level thread zm_factory::sndpa_dovox("vox_maxis_teleporter_expired_0");
}

/*
	Name: clock_timer
	Namespace: zm_factory_teleporter
	Checksum: 0x977560F1
	Offset: 0x1668
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function clock_timer()
{
	level util::delay(0, undefined, &zm_audio::sndmusicsystem_playstate, "timer");
	self playloopsound("evt_clock_tick_1sec");
	level waittill(#"stop_countdown");
	if(isdefined(level.musicsystem.currentstate) && level.musicsystem.currentstate == "timer")
	{
		level thread zm_audio::sndmusicsystem_stopandflush();
		music::setmusicstate("none");
	}
	self stoploopsound(0);
	self delete();
}

/*
	Name: teleport_pad_active_think
	Namespace: zm_factory_teleporter
	Checksum: 0xD3666F00
	Offset: 0x1760
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function teleport_pad_active_think(index)
{
	self setcursorhint("HINT_NOICON");
	self.teleport_active = 1;
	user = undefined;
	while(true)
	{
		self waittill(#"trigger", user);
		if(zm_utility::is_player_valid(user) && user zm_score::can_player_purchase(level.teleport_cost) && !level.is_cooldown)
		{
			for(i = 0; i < level.teleporter_pad_trig.size; i++)
			{
				level.teleporter_pad_trig[i] teleport_trigger_invisible(1);
			}
			user zm_score::minus_to_player_score(level.teleport_cost);
			self player_teleporting(index);
		}
	}
}

/*
	Name: player_teleporting
	Namespace: zm_factory_teleporter
	Checksum: 0xA74F6AB9
	Offset: 0x1898
	Size: 0x230
	Parameters: 1
	Flags: Linked
*/
function player_teleporting(index)
{
	time_since_last_teleport = gettime() - level.teleport_time;
	exploder::exploder_duration(("teleporter_" + level.teleport_pad_names[index]) + "_teleporting", 5.3);
	exploder::exploder_duration("mainframe_warm_up", 4.8);
	level util::clientnotify("tpw" + index);
	level thread zm_factory::sndpa_dovox("vox_maxis_teleporter_success_0");
	self thread teleport_pad_player_fx(level.teleport_delay);
	self thread teleport_2d_audio();
	self thread teleport_nuke(20, 300);
	wait(level.teleport_delay);
	self notify(#"fx_done");
	self thread zm_factory::function_c7b37638();
	self teleport_players();
	if(level.is_cooldown == 0)
	{
		thread pad_manager();
	}
	wait(2);
	ss = struct::get("teleporter_powerup", "targetname");
	if(isdefined(ss))
	{
		ss thread zm_powerups::special_powerup_drop(ss.origin);
	}
	if(time_since_last_teleport < 60000 && level.active_links == 3 && level.round_number > 20)
	{
		thread zm_utility::play_sound_2d("vox_sam_nospawn");
	}
	level.teleport_time = gettime();
}

/*
	Name: teleport_trigger_invisible
	Namespace: zm_factory_teleporter
	Checksum: 0xCBBA02AA
	Offset: 0x1AD0
	Size: 0x86
	Parameters: 1
	Flags: Linked
*/
function teleport_trigger_invisible(enable)
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i]))
		{
			self setinvisibletoplayer(players[i], enable);
		}
	}
}

/*
	Name: player_is_near_pad
	Namespace: zm_factory_teleporter
	Checksum: 0xEE9A7E5A
	Offset: 0x1B60
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function player_is_near_pad(player)
{
	radius = 88;
	scale_factor = 2;
	dist = distance2d(player.origin, self.origin);
	dist_touching = radius * scale_factor;
	if(dist < dist_touching)
	{
		return true;
	}
	return false;
}

/*
	Name: teleport_pad_player_fx
	Namespace: zm_factory_teleporter
	Checksum: 0x5A44095F
	Offset: 0x1BF8
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function teleport_pad_player_fx(duration)
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i]))
		{
			if(self player_is_near_pad(players[i]))
			{
				visionset_mgr::activate("overlay", "zm_trap_electric", players[i], 1.25, 1.25);
			}
		}
	}
}

/*
	Name: teleport_players
	Namespace: zm_factory_teleporter
	Checksum: 0x2ACD89DE
	Offset: 0x1CB8
	Size: 0x8B4
	Parameters: 0
	Flags: Linked
*/
function teleport_players()
{
	player_radius = 16;
	players = getplayers();
	core_pos = [];
	occupied = [];
	image_room = [];
	players_touching = [];
	player_idx = 0;
	prone_offset = vectorscale((0, 0, 1), 49);
	crouch_offset = vectorscale((0, 0, 1), 20);
	stand_offset = (0, 0, 0);
	for(i = 0; i < 4; i++)
	{
		core_pos[i] = getent("origin_teleport_player_" + i, "targetname");
		occupied[i] = 0;
		image_room[i] = getent("teleport_room_" + i, "targetname");
		if(isdefined(players[i]))
		{
			if(self player_is_near_pad(players[i]))
			{
				players[i].b_teleporting = 1;
				players_touching[player_idx] = i;
				player_idx++;
				if(isdefined(image_room[i]))
				{
					visionset_mgr::deactivate("overlay", "zm_trap_electric", players[i]);
					visionset_mgr::activate("overlay", "zm_factory_teleport", players[i]);
					players[i] disableoffhandweapons();
					players[i] disableweapons();
					if(players[i] getstance() == "prone")
					{
						desired_origin = image_room[i].origin + prone_offset;
					}
					else
					{
						if(players[i] getstance() == "crouch")
						{
							desired_origin = image_room[i].origin + crouch_offset;
						}
						else
						{
							desired_origin = image_room[i].origin + stand_offset;
						}
					}
					players[i].teleport_origin = spawn("script_origin", players[i].origin);
					players[i].teleport_origin.angles = players[i].angles;
					players[i] linkto(players[i].teleport_origin);
					players[i].teleport_origin.origin = desired_origin;
					players[i] freezecontrols(1);
					util::wait_network_frame();
					if(isdefined(players[i]))
					{
						util::setclientsysstate("levelNotify", "black_box_start", players[i]);
						players[i].teleport_origin.angles = image_room[i].angles;
					}
				}
			}
		}
	}
	wait(2);
	core = getent("trigger_teleport_core", "targetname");
	core thread teleport_nuke(undefined, 300);
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i]))
		{
			for(j = 0; j < 4; j++)
			{
				if(!occupied[j])
				{
					dist = distance2d(core_pos[j].origin, players[i].origin);
					if(dist < player_radius)
					{
						occupied[j] = 1;
					}
				}
			}
			util::setclientsysstate("levelNotify", "black_box_end", players[i]);
		}
	}
	util::wait_network_frame();
	for(i = 0; i < players_touching.size; i++)
	{
		player_idx = players_touching[i];
		player = players[player_idx];
		if(!isdefined(player))
		{
			continue;
		}
		slot = i;
		start = 0;
		while(occupied[slot] && start < 4)
		{
			start++;
			slot++;
			if(slot >= 4)
			{
				slot = 0;
			}
		}
		occupied[slot] = 1;
		pos_name = "origin_teleport_player_" + slot;
		teleport_core_pos = getent(pos_name, "targetname");
		player unlink();
		/#
			assert(isdefined(player.teleport_origin));
		#/
		player.teleport_origin delete();
		player.teleport_origin = undefined;
		visionset_mgr::deactivate("overlay", "zm_factory_teleport", player);
		player enableweapons();
		player enableoffhandweapons();
		player setorigin(core_pos[slot].origin);
		player setplayerangles(core_pos[slot].angles);
		player freezecontrols(0);
		player thread teleport_aftereffects();
		vox_rand = randomintrange(1, 100);
		if(vox_rand <= 2)
		{
		}
		player.b_teleporting = 0;
	}
	exploder::exploder_duration("mainframe_arrival", 1.7);
	exploder::exploder_duration("mainframe_steam", 14.6);
}

/*
	Name: teleport_core_hint_update
	Namespace: zm_factory_teleporter
	Checksum: 0xE420C0BE
	Offset: 0x2578
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function teleport_core_hint_update()
{
	self setcursorhint("HINT_NOICON");
	while(true)
	{
		if(!level flag::get("power_on"))
		{
			self sethintstring(&"ZOMBIE_NEED_POWER");
		}
		else
		{
			if(teleport_pads_are_active())
			{
				self sethintstring(&"ZOMBIE_LINK_TPAD");
			}
			else
			{
				if(level.active_links == 0)
				{
					self sethintstring(&"ZOMBIE_INACTIVE_TPAD");
				}
				else
				{
					self sethintstring("");
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: teleport_core_think
	Namespace: zm_factory_teleporter
	Checksum: 0x18BC7A90
	Offset: 0x2680
	Size: 0x428
	Parameters: 0
	Flags: Linked
*/
function teleport_core_think()
{
	trigger = getent("trigger_teleport_core", "targetname");
	if(isdefined(trigger))
	{
		trigger thread teleport_core_hint_update();
		level flag::wait_till("power_on");
		/#
			if(getdvarint("") >= 6)
			{
				for(i = 0; i < level.teleport.size; i++)
				{
					level.teleport[i] = "";
				}
			}
		#/
		while(true)
		{
			if(teleport_pads_are_active())
			{
				cheat = 0;
				/#
					if(getdvarint("") >= 6)
					{
						cheat = 1;
					}
				#/
				if(!cheat)
				{
					trigger waittill(#"trigger");
				}
				for(i = 0; i < level.teleport.size; i++)
				{
					if(isdefined(level.teleport[i]))
					{
						if(level.teleport[i] == "timer_on")
						{
							level.teleport[i] = "active";
							level.active_links++;
							level flag::set("teleporter_pad_link_" + level.active_links);
							level thread zm_factory::sndpa_dovox(("vox_maxis_teleporter_" + i) + "active_0");
							level util::delay(10, undefined, &zm_audio::sndmusicsystem_playstate, "teleporter_" + level.active_links);
							exploder::exploder(("teleporter_" + level.teleport_pad_names[i]) + "_linked");
							exploder::exploder(("lgt_teleporter_" + level.teleport_pad_names[i]) + "_linked");
							exploder::exploder_duration("mainframe_steam", 14.6);
							if(level.active_links == 3)
							{
								exploder::exploder_duration("mainframe_link_all", 4.6);
								exploder::exploder("mainframe_ambient");
								level util::clientnotify("pap1");
								teleporter_vo("linkall", trigger);
								earthquake(0.3, 2, trigger.origin, 3700);
							}
							pad = "trigger_teleport_pad_" + i;
							trigger_pad = getent(pad, "targetname");
							trigger_pad stop_countdown();
							level util::clientnotify("TRs");
							level.active_timer = -1;
						}
					}
				}
			}
			wait(0.05);
		}
	}
}

/*
	Name: stop_countdown
	Namespace: zm_factory_teleporter
	Checksum: 0xEDB4D5C3
	Offset: 0x2AB0
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function stop_countdown()
{
	self notify(#"stop_countdown");
	level notify(#"stop_countdown");
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] notify(#"stop_countdown");
	}
}

/*
	Name: teleport_pads_are_active
	Namespace: zm_factory_teleporter
	Checksum: 0x7D903A8D
	Offset: 0x2B38
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function teleport_pads_are_active()
{
	if(isdefined(level.teleport))
	{
		for(i = 0; i < level.teleport.size; i++)
		{
			if(isdefined(level.teleport[i]))
			{
				if(level.teleport[i] == "timer_on")
				{
					return true;
				}
			}
		}
	}
	return false;
}

/*
	Name: teleport_2d_audio
	Namespace: zm_factory_teleporter
	Checksum: 0x12FD169C
	Offset: 0x2BB8
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function teleport_2d_audio()
{
	self endon(#"fx_done");
	while(true)
	{
		players = getplayers();
		wait(1.7);
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(players[i]))
			{
				if(self player_is_near_pad(players[i]))
				{
					util::setclientsysstate("levelNotify", "t2d", players[i]);
				}
			}
		}
	}
}

/*
	Name: teleport_nuke
	Namespace: zm_factory_teleporter
	Checksum: 0xF4B7A4CA
	Offset: 0x2C90
	Size: 0x17E
	Parameters: 2
	Flags: Linked
*/
function teleport_nuke(max_zombies, range)
{
	zombies = getaispeciesarray(level.zombie_team);
	zombies = util::get_array_of_closest(self.origin, zombies, undefined, max_zombies, range);
	for(i = 0; i < zombies.size; i++)
	{
		wait(randomfloatrange(0.2, 0.3));
		if(!isdefined(zombies[i]))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(zombies[i]))
		{
			continue;
		}
		if(!zombies[i].isdog)
		{
			zombies[i] zombie_utility::zombie_head_gib();
		}
		zombies[i] dodamage(10000, zombies[i].origin);
		playsoundatposition("nuked", zombies[i].origin);
	}
}

/*
	Name: teleporter_vo
	Namespace: zm_factory_teleporter
	Checksum: 0x22E4A439
	Offset: 0x2E18
	Size: 0x140
	Parameters: 2
	Flags: Linked
*/
function teleporter_vo(tele_vo_type, location)
{
	if(!isdefined(location))
	{
		self thread teleporter_vo_play(tele_vo_type, 2);
	}
	else
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(distance(players[i].origin, location.origin) < 64)
			{
				switch(tele_vo_type)
				{
					case "linkall":
					{
						players[i] thread teleporter_vo_play("tele_linkall");
						break;
					}
					case "countdown":
					{
						players[i] thread teleporter_vo_play("tele_count", 3);
						break;
					}
				}
			}
		}
	}
}

/*
	Name: teleporter_vo_play
	Namespace: zm_factory_teleporter
	Checksum: 0x5FE4EBAB
	Offset: 0x2F60
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function teleporter_vo_play(vox_type, pre_wait = 0)
{
	wait(pre_wait);
}

/*
	Name: play_tele_help_vox
	Namespace: zm_factory_teleporter
	Checksum: 0x8A4C7AC1
	Offset: 0x2F98
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function play_tele_help_vox()
{
	level endon(#"tele_help_end");
	while(true)
	{
		self waittill(#"trigger", who);
		if(level flag::get("power_on"))
		{
			who thread teleporter_vo_play("tele_help");
			level notify(#"tele_help_end");
		}
		while(isdefined(who) && who istouching(self))
		{
			wait(0.1);
		}
	}
}

/*
	Name: play_packa_see_vox
	Namespace: zm_factory_teleporter
	Checksum: 0x7D45DFC9
	Offset: 0x3050
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function play_packa_see_vox()
{
	wait(10);
	if(!level flag::get("teleporter_pad_link_3"))
	{
		self waittill(#"trigger", who);
		who thread teleporter_vo_play("perk_packa_see");
	}
}

/*
	Name: teleporter_wire_wait
	Namespace: zm_factory_teleporter
	Checksum: 0xAE12C567
	Offset: 0x30B8
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function teleporter_wire_wait(index)
{
	targ = struct::get(("pad_" + index) + "_wire", "targetname");
	if(!isdefined(targ))
	{
		return;
	}
	while(isdefined(targ))
	{
		if(isdefined(targ.target))
		{
			target = struct::get(targ.target, "targetname");
			wait(0.1);
			targ = target;
		}
		else
		{
			break;
		}
	}
}

/*
	Name: teleport_aftereffects
	Namespace: zm_factory_teleporter
	Checksum: 0x50D9B2
	Offset: 0x3180
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function teleport_aftereffects()
{
	if(getdvarstring("factoryAftereffectOverride") == ("-1"))
	{
		self thread [[level.teleport_ae_funcs[randomint(level.teleport_ae_funcs.size)]]]();
	}
	else
	{
		self thread [[level.teleport_ae_funcs[int(getdvarstring("factoryAftereffectOverride"))]]]();
	}
}

/*
	Name: teleport_aftereffect_shellshock
	Namespace: zm_factory_teleporter
	Checksum: 0x509B45FB
	Offset: 0x3228
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function teleport_aftereffect_shellshock()
{
	/#
		println("");
	#/
	self shellshock("explosion", 4);
}

/*
	Name: teleport_aftereffect_shellshock_electric
	Namespace: zm_factory_teleporter
	Checksum: 0xE24FFD95
	Offset: 0x3278
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function teleport_aftereffect_shellshock_electric()
{
	/#
		println("");
	#/
	self shellshock("electrocution", 4);
}

/*
	Name: teleport_aftereffect_fov
	Namespace: zm_factory_teleporter
	Checksum: 0xEAF2BAD
	Offset: 0x32C8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function teleport_aftereffect_fov()
{
	util::setclientsysstate("levelNotify", "tae", self);
}

/*
	Name: teleport_aftereffect_bw_vision
	Namespace: zm_factory_teleporter
	Checksum: 0x9C685E9
	Offset: 0x32F8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_bw_vision(localclientnum)
{
	util::setclientsysstate("levelNotify", "tae", self);
}

/*
	Name: teleport_aftereffect_red_vision
	Namespace: zm_factory_teleporter
	Checksum: 0x3D87EA37
	Offset: 0x3330
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_red_vision(localclientnum)
{
	util::setclientsysstate("levelNotify", "tae", self);
}

/*
	Name: teleport_aftereffect_flashy_vision
	Namespace: zm_factory_teleporter
	Checksum: 0x715742
	Offset: 0x3368
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_flashy_vision(localclientnum)
{
	util::setclientsysstate("levelNotify", "tae", self);
}

/*
	Name: teleport_aftereffect_flare_vision
	Namespace: zm_factory_teleporter
	Checksum: 0x3646D2A3
	Offset: 0x33A0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_flare_vision(localclientnum)
{
	util::setclientsysstate("levelNotify", "tae", self);
}

/*
	Name: packa_door_reminder
	Namespace: zm_factory_teleporter
	Checksum: 0x934B1147
	Offset: 0x33D8
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function packa_door_reminder()
{
	while(!level flag::get("teleporter_pad_link_3"))
	{
		rand = randomintrange(4, 16);
		self playsound("evt_packa_door_hitch");
		wait(rand);
	}
}

/*
	Name: dog_blocker_clip
	Namespace: zm_factory_teleporter
	Checksum: 0x1B2C580B
	Offset: 0x3458
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function dog_blocker_clip()
{
	collision = spawn("script_model", (-106, -2294, 216));
	collision setmodel("collision_wall_128x128x10");
	collision.angles = vectorscale((0, 1, 0), 37.2);
	collision hide();
	collision = spawn("script_model", (-1208, -439, 363));
	collision setmodel("collision_wall_128x128x10");
	collision.angles = (0, 0, 0);
	collision hide();
}

