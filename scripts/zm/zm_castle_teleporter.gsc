// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_castle_ee;
#using scripts\zm\zm_castle_mechz;
#using scripts\zm\zm_castle_vo;

#namespace zm_castle_teleporter;

/*
	Name: __init__sytem__
	Namespace: zm_castle_teleporter
	Checksum: 0x56CAFF5B
	Offset: 0x6A0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_teleporter", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_castle_teleporter
	Checksum: 0x65DCB24
	Offset: 0x6E8
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.dog_melee_range = 130;
	level.teleport = [];
	level.active_links = 0;
	level.countdown = 0;
	level.n_teleport_delay = 2;
	level.n_teleport_cooldown = 45;
	/#
		if(getdvarint("") > 0)
		{
			level.n_teleport_cooldown = 3;
		}
	#/
	level.is_cooldown = 0;
	level.n_teleport_time = 0;
	level.var_47f4765c = 0;
	level flag::init("castle_teleporter_used");
	visionset_mgr::register_info("overlay", "zm_factory_teleport", 5000, 61, 1, 1);
	visionset_mgr::register_info("overlay", "zm_castle_transported", 1, 20, 15, 1, &visionset_mgr::duration_lerp_thread_per_player, 0);
	clientfield::register("world", "ee_quest_time_travel_ready", 5000, 1, "int");
	clientfield::register("toplayer", "ee_quest_back_in_time_teleport_fx", 5000, 1, "int");
	clientfield::register("toplayer", "ee_quest_back_in_time_postfx", 5000, 1, "int");
	clientfield::register("toplayer", "ee_quest_back_in_time_sfx", 5000, 1, "int");
}

/*
	Name: __main__
	Namespace: zm_castle_teleporter
	Checksum: 0xE27615D9
	Offset: 0x8E8
	Size: 0x1D6
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	var_a0cf8f2b = getentarray("trigger_teleport_pad", "targetname");
	foreach(n_index, e_trig in var_a0cf8f2b)
	{
		level.var_27b3c884[n_index] = e_trig;
		e_trig thread teleport_pad_think();
	}
	level.no_dog_clip = 1;
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
	Name: pad_manager
	Namespace: zm_castle_teleporter
	Checksum: 0x2B01A53E
	Offset: 0xAC8
	Size: 0x202
	Parameters: 0
	Flags: Linked
*/
function pad_manager()
{
	foreach(t_trig in level.var_27b3c884)
	{
		t_trig sethintstring(&"ZOMBIE_TELEPORT_COOLDOWN");
		t_trig teleport_trigger_invisible(0);
	}
	level.is_cooldown = 1;
	array::thread_all(level.var_27b3c884, &function_68ebacd3);
	wait(level.n_teleport_cooldown);
	level.is_cooldown = 0;
	foreach(t_trig in level.var_27b3c884)
	{
		if(level flag::get("rocket_firing"))
		{
			t_trig sethintstring(&"ZM_CASTLE_TELEPORT_LOCKED");
			continue;
		}
		if(isdefined(t_trig.var_1c5080fe) && t_trig.var_1c5080fe)
		{
			t_trig sethintstring(&"ZM_CASTLE_TELEPORT_USE", 500);
			continue;
		}
		t_trig sethintstring(&"ZOMBIE_LINK_TPAD");
	}
}

/*
	Name: function_68ebacd3
	Namespace: zm_castle_teleporter
	Checksum: 0xB9923B19
	Offset: 0xCD8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_68ebacd3()
{
	self.var_eb37ce09 = undefined;
	wait(10);
	while(level.is_cooldown)
	{
		if(!isdefined(self.var_eb37ce09))
		{
			foreach(e_player in level.activeplayers)
			{
				if(e_player istouching(self))
				{
					if(!level flag::get("rocket_firing"))
					{
						self thread function_798f36c();
						continue;
					}
				}
			}
		}
		wait(0.4);
	}
}

/*
	Name: function_798f36c
	Namespace: zm_castle_teleporter
	Checksum: 0xE1B81D01
	Offset: 0xDE0
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_798f36c()
{
	self.var_eb37ce09 = gettime();
	playsoundatposition("vox_maxis_teleporter_pa_recharging_0", self.origin);
	while(level.is_cooldown)
	{
		if((gettime() - self.var_eb37ce09) > 16000)
		{
			foreach(e_player in level.activeplayers)
			{
				if(e_player istouching(self))
				{
					self.var_eb37ce09 = gettime();
					playsoundatposition("vox_maxis_teleporter_pa_recharging_0", self.origin);
					continue;
				}
			}
		}
		wait(1);
	}
	self.var_eb37ce09 = undefined;
	wait(3);
	playsoundatposition("vox_maxis_teleporter_pa_available_0", self.origin);
}

/*
	Name: function_ee24bc2e
	Namespace: zm_castle_teleporter
	Checksum: 0x524A40CD
	Offset: 0xF38
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function function_ee24bc2e()
{
	foreach(t_trig in level.var_27b3c884)
	{
		if(level flag::get("rocket_firing"))
		{
			t_trig sethintstring(&"ZM_CASTLE_TELEPORT_LOCKED");
			continue;
		}
		if(level.is_cooldown == 1)
		{
			t_trig sethintstring(&"ZOMBIE_TELEPORT_COOLDOWN");
			continue;
		}
		t_trig sethintstring(&"ZM_CASTLE_TELEPORT_USE", 500);
	}
}

/*
	Name: update_trigger_visibility
	Namespace: zm_castle_teleporter
	Checksum: 0x9161DDC4
	Offset: 0x1050
	Size: 0xFC
	Parameters: 0
	Flags: Linked, Private
*/
function private update_trigger_visibility()
{
	self endon(#"death");
	while(true)
	{
		for(i = 0; i < level.players.size; i++)
		{
			if(distancesquared(level.players[i].origin, self.origin) < 16384)
			{
				if(level.players[i].is_drinking > 0)
				{
					self setinvisibletoplayer(level.players[i], 1);
					continue;
				}
				self setinvisibletoplayer(level.players[i], 0);
			}
		}
		wait(0.25);
	}
}

/*
	Name: teleport_pad_think
	Namespace: zm_castle_teleporter
	Checksum: 0xAA5E7C0E
	Offset: 0x1158
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function teleport_pad_think()
{
	self setcursorhint("HINT_NOICON");
	self sethintstring(&"ZOMBIE_NEED_POWER");
	level flag::wait_till("power_on");
	self thread teleport_pad_active_think();
	self thread update_trigger_visibility();
}

/*
	Name: teleport_pad_active_think
	Namespace: zm_castle_teleporter
	Checksum: 0xB2481B61
	Offset: 0x11F8
	Size: 0x200
	Parameters: 0
	Flags: Linked
*/
function teleport_pad_active_think()
{
	self setcursorhint("HINT_NOICON");
	self.var_1c5080fe = 1;
	e_player = undefined;
	self sethintstring(&"ZM_CASTLE_TELEPORT_USE", 500);
	exploder::exploder("fxexp_100");
	while(true)
	{
		self waittill(#"trigger", e_player);
		if(zm_utility::is_player_valid(e_player) && !level.is_cooldown && !level flag::get("rocket_firing") && level flag::get("time_travel_teleporter_ready"))
		{
			if(function_6b3344b4())
			{
				if(!function_ad16f13c(e_player))
				{
					continue;
				}
				self playsound("evt_teleporter_warmup");
				self function_264f93ff(1, 0);
			}
		}
		else if(zm_utility::is_player_valid(e_player) && !level.is_cooldown && !level flag::get("rocket_firing"))
		{
			if(!function_ad16f13c(e_player))
			{
				continue;
			}
			self playsound("evt_teleporter_warmup");
			self function_264f93ff(0);
		}
	}
}

/*
	Name: function_ad16f13c
	Namespace: zm_castle_teleporter
	Checksum: 0x2314DB02
	Offset: 0x1400
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_ad16f13c(e_who)
{
	if(e_who.is_drinking > 0)
	{
		return false;
	}
	if(e_who zm_utility::in_revive_trigger())
	{
		return false;
	}
	if(zm_utility::is_player_valid(e_who))
	{
		if(!e_who zm_score::can_player_purchase(500))
		{
			e_who zm_audio::create_and_play_dialog("general", "transport_deny");
			return false;
		}
		e_who zm_score::minus_to_player_score(500);
		return true;
	}
	return false;
}

/*
	Name: function_6b3344b4
	Namespace: zm_castle_teleporter
	Checksum: 0x794F4920
	Offset: 0x14D8
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function function_6b3344b4()
{
	var_a0cf8f2b = getentarray("trigger_teleport_pad", "targetname");
	var_d30fe07b = 1;
	players = level.activeplayers;
	foreach(player in players)
	{
		var_1a19680c = 0;
		foreach(e_trig in var_a0cf8f2b)
		{
			if(player istouching(e_trig))
			{
				var_1a19680c = 1;
			}
		}
		if(!isalive(player) || !var_1a19680c)
		{
			var_d30fe07b = 0;
		}
	}
	return var_d30fe07b;
}

/*
	Name: function_264f93ff
	Namespace: zm_castle_teleporter
	Checksum: 0xCEA68181
	Offset: 0x1680
	Size: 0x594
	Parameters: 2
	Flags: Linked
*/
function function_264f93ff(var_edc2ee2a = 0, var_66f7e6b9 = 0)
{
	array::thread_all(level.var_27b3c884, &teleport_trigger_invisible, 1);
	if(var_edc2ee2a && !var_66f7e6b9)
	{
		level.disable_nuke_delay_spawning = 1;
		level flag::clear("spawn_zombies");
		zm_castle_ee::function_5db6ba34();
	}
	time_since_last_teleport = gettime() - level.n_teleport_time;
	exploder::exploder("fxexp_101");
	self thread function_f5a06c(level.n_teleport_delay);
	if(!var_edc2ee2a)
	{
		self thread teleport_nuke(20, 300);
	}
	if(var_edc2ee2a && !var_66f7e6b9)
	{
		level thread zm_castle_ee::function_2c1aa78f();
	}
	foreach(player in level.players)
	{
		if(player.zone_name === "zone_v10_pad")
		{
			player zm_utility::create_streamer_hint(struct::get_array(self.target, "targetname")[0].origin, struct::get_array(self.target, "targetname")[0].angles, 1);
		}
		if(var_edc2ee2a)
		{
			if(var_66f7e6b9)
			{
				player clientfield::set_to_player("ee_quest_back_in_time_sfx", 0);
				continue;
			}
			player clientfield::set_to_player("ee_quest_back_in_time_sfx", 1);
		}
	}
	wait(level.n_teleport_delay);
	self notify(#"fx_done");
	if(var_edc2ee2a && !var_66f7e6b9)
	{
		if(!level flag::get("dimension_set"))
		{
			zm_castle_ee::function_3918d831("safe_code_past");
		}
	}
	self teleport_players(var_edc2ee2a, var_66f7e6b9);
	if(var_edc2ee2a)
	{
		if(var_66f7e6b9)
		{
			if(self.script_int === 0)
			{
				level thread function_e421dd3f();
			}
			else
			{
				s_spawn_pos = struct::get("ee_mechz_time_lab", "targetname");
				playfx(level._effect["lightning_dog_spawn"], s_spawn_pos.origin);
				ai_mechz = zm_castle_mechz::function_314d744b(0, s_spawn_pos, 0);
				ai_mechz.no_damage_points = 1;
				ai_mechz.deathpoints_already_given = 1;
				ai_mechz.exclude_cleanup_adding_to_total = 1;
			}
			level flag::set("spawn_zombies");
			level.disable_nuke_delay_spawning = 0;
		}
		else
		{
			wait(0.5);
			level notify(#"hash_59b7ed");
		}
	}
	if(level.is_cooldown == 0 && !level flag::get("time_travel_teleporter_ready"))
	{
		thread pad_manager();
	}
	wait(2);
	ss = struct::get("teleporter_powerup", "targetname");
	if(isdefined(ss))
	{
		ss thread zm_powerups::special_powerup_drop(ss.origin);
	}
	level.n_teleport_time = gettime();
	if(var_edc2ee2a && !var_66f7e6b9)
	{
		level flag::clear("time_travel_teleporter_ready");
		wait(33);
		self function_264f93ff(1, 1);
		level thread zm_castle_vo::function_8b0b26a6();
		zm_castle_ee::function_71152937();
	}
}

/*
	Name: function_e421dd3f
	Namespace: zm_castle_teleporter
	Checksum: 0x513F3FD4
	Offset: 0x1C20
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_e421dd3f()
{
	level notify(#"hash_bff04a2b");
	level endon(#"hash_bff04a2b");
	var_9e5ac8d1 = getent("trig_mechz_ee_a10", "targetname");
	var_9e5ac8d1 waittill(#"trigger", e_who);
	s_spawn_pos = arraygetclosest(e_who.origin, level.zm_loc_types["mechz_location"]);
	if(isplayer(e_who) && isdefined(s_spawn_pos))
	{
		ai_mechz = zm_castle_mechz::function_314d744b(0, s_spawn_pos, 1);
		ai_mechz.no_damage_points = 1;
		ai_mechz.deathpoints_already_given = 1;
		ai_mechz.exclude_cleanup_adding_to_total = 1;
	}
}

/*
	Name: teleport_trigger_invisible
	Namespace: zm_castle_teleporter
	Checksum: 0xD87939AF
	Offset: 0x1D50
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function teleport_trigger_invisible(enable)
{
	players = getplayers();
	foreach(player in players)
	{
		self setinvisibletoplayer(player, enable);
	}
}

/*
	Name: player_is_near_pad
	Namespace: zm_castle_teleporter
	Checksum: 0x353C1B13
	Offset: 0x1E10
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function player_is_near_pad(player)
{
	n_dist_sq = distancesquared(player.origin, self.origin);
	if(n_dist_sq < 30625)
	{
		return true;
	}
	return false;
}

/*
	Name: function_f5a06c
	Namespace: zm_castle_teleporter
	Checksum: 0xF4620AD
	Offset: 0x1E78
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_f5a06c(n_duration)
{
	array::thread_all(level.activeplayers, &teleport_pad_player_fx, self, n_duration);
}

/*
	Name: teleport_pad_player_fx
	Namespace: zm_castle_teleporter
	Checksum: 0x5D0C1E7E
	Offset: 0x1EC0
	Size: 0x170
	Parameters: 2
	Flags: Linked
*/
function teleport_pad_player_fx(var_7d7ca0ea, n_duration)
{
	var_7d7ca0ea endon(#"fx_done");
	n_start_time = gettime();
	n_total_time = 0;
	while(n_total_time < n_duration)
	{
		if(var_7d7ca0ea player_is_near_pad(self))
		{
			visionset_mgr::activate("overlay", "zm_factory_teleport", self, n_duration, n_duration);
			self playrumbleonentity("zm_castle_pulsing_rumble");
			while(n_total_time < n_duration && var_7d7ca0ea player_is_near_pad(self))
			{
				n_current_time = gettime();
				n_total_time = (n_current_time - n_start_time) / 1000;
				util::wait_network_frame();
			}
			visionset_mgr::deactivate("overlay", "zm_factory_teleport", self);
		}
		n_current_time = gettime();
		n_total_time = (n_current_time - n_start_time) / 1000;
		util::wait_network_frame();
	}
}

/*
	Name: teleport_players
	Namespace: zm_castle_teleporter
	Checksum: 0x4B1697DF
	Offset: 0x2038
	Size: 0x93C
	Parameters: 2
	Flags: Linked
*/
function teleport_players(var_edc2ee2a = 0, var_66f7e6b9 = 0)
{
	level flag::set("castle_teleporter_used");
	n_player_radius = 24;
	if(var_edc2ee2a && !var_66f7e6b9)
	{
		var_764d9cb = struct::get_array("past_laboratory_telepoints", "targetname");
	}
	else
	{
		var_764d9cb = struct::get_array(self.target, "targetname");
	}
	var_492a5e1e = struct::get_array("teleport_room_pos", "targetname");
	var_19ff0dfb = [];
	var_daad3c3c = vectorscale((0, 0, 1), 49);
	var_6b55b1c4 = vectorscale((0, 0, 1), 20);
	var_3abe10e2 = (0, 0, 0);
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(var_edc2ee2a)
		{
			if(var_66f7e6b9)
			{
				level flag::clear("time_travel_teleporter_ready");
			}
		}
		v_dest_origin = var_764d9cb[i].origin;
		var_a9d3e161 = var_764d9cb[i].angles;
		if(var_edc2ee2a || self player_is_near_pad(player))
		{
			if(var_edc2ee2a && var_66f7e6b9)
			{
				player clientfield::set_to_player("ee_quest_back_in_time_postfx", 0);
			}
			if(var_edc2ee2a)
			{
				if(var_66f7e6b9)
				{
					player clientfield::set_to_player("ee_quest_back_in_time_sfx", 0);
				}
				else
				{
					player clientfield::set_to_player("ee_quest_back_in_time_sfx", 1);
				}
			}
			if(isdefined(var_492a5e1e[i]))
			{
				visionset_mgr::deactivate("overlay", "zm_trap_electric", player);
				if(var_edc2ee2a)
				{
					player clientfield::set_to_player("ee_quest_back_in_time_teleport_fx", 1);
				}
				else
				{
					visionset_mgr::activate("overlay", "zm_factory_teleport", player);
				}
				player disableoffhandweapons();
				player disableweapons();
				player.b_teleporting = 1;
				if(player getstance() == "prone")
				{
					desired_origin = var_492a5e1e[i].origin + var_daad3c3c;
				}
				else
				{
					if(player getstance() == "crouch")
					{
						desired_origin = var_492a5e1e[i].origin + var_6b55b1c4;
					}
					else
					{
						desired_origin = var_492a5e1e[i].origin + var_3abe10e2;
					}
				}
				array::add(var_19ff0dfb, player, 0);
				player.var_601ebf01 = util::spawn_model("tag_origin", player.origin, player.angles);
				player linkto(player.var_601ebf01);
				player dontinterpolate();
				player.var_601ebf01 dontinterpolate();
				player.var_601ebf01.origin = desired_origin;
				player.var_601ebf01.angles = var_492a5e1e[i].angles;
				player freezecontrols(1);
				util::wait_network_frame();
				if(isdefined(player))
				{
					util::setclientsysstate("levelNotify", "black_box_start", player);
					player.var_601ebf01.angles = var_492a5e1e[i].angles;
				}
			}
			continue;
		}
		visionset_mgr::deactivate("overlay", "zm_factory_teleport", player);
	}
	wait(2);
	array::random(var_764d9cb) thread teleport_nuke(undefined, 300);
	for(i = 0; i < level.activeplayers.size; i++)
	{
		util::setclientsysstate("levelNotify", "black_box_end", level.activeplayers[i]);
	}
	util::wait_network_frame();
	for(i = 0; i < var_19ff0dfb.size; i++)
	{
		player = var_19ff0dfb[i];
		if(!isdefined(player))
		{
			continue;
		}
		player unlink();
		if(positionwouldtelefrag(var_764d9cb[i].origin))
		{
			player setorigin(var_764d9cb[i].origin + (randomfloatrange(-16, 16), randomfloatrange(-16, 16), 0));
		}
		else
		{
			player setorigin(var_764d9cb[i].origin);
		}
		player setplayerangles(var_764d9cb[i].angles);
		if(var_edc2ee2a)
		{
			player clientfield::set_to_player("ee_quest_back_in_time_teleport_fx", 0);
		}
		visionset_mgr::deactivate("overlay", "zm_factory_teleport", player);
		player enableweapons();
		player enableoffhandweapons();
		player.b_teleporting = undefined;
		player freezecontrols(0);
		player thread teleport_aftereffects();
		if(var_edc2ee2a && !var_66f7e6b9)
		{
			player thread function_4a0d1595();
		}
		player zm_utility::clear_streamer_hint();
		player.var_601ebf01 delete();
	}
	level.var_47f4765c++;
	if(level.var_47f4765c == 1 || (level.var_47f4765c % 3) == 0)
	{
		playsoundatposition("vox_maxis_teleporter_pa_success_0", var_764d9cb[0].origin);
	}
	exploder::exploder("fxexp_102");
}

/*
	Name: function_4a0d1595
	Namespace: zm_castle_teleporter
	Checksum: 0x69A7D862
	Offset: 0x2980
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function function_4a0d1595()
{
	wait(0.05);
	self clientfield::set_to_player("ee_quest_back_in_time_postfx", 1);
	self disableoffhandweapons();
	self disableweapons();
	self.b_teleporting = 1;
}

/*
	Name: teleport_2d_audio
	Namespace: zm_castle_teleporter
	Checksum: 0xF46083C3
	Offset: 0x29F0
	Size: 0xCA
	Parameters: 0
	Flags: None
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
	Namespace: zm_castle_teleporter
	Checksum: 0x882E209F
	Offset: 0x2AC8
	Size: 0x1A6
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
		if(zombies[i].archetype === "mechz")
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
	Name: teleporter_wire_wait
	Namespace: zm_castle_teleporter
	Checksum: 0x903F5298
	Offset: 0x2C78
	Size: 0xBE
	Parameters: 1
	Flags: None
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
	Namespace: zm_castle_teleporter
	Checksum: 0xDA80D117
	Offset: 0x2D40
	Size: 0xAA
	Parameters: 2
	Flags: Linked
*/
function teleport_aftereffects(var_edc2ee2a, var_66f7e6b9)
{
	if(getdvarstring("castleAftereffectOverride") == ("-1"))
	{
		self thread [[level.teleport_ae_funcs[randomint(level.teleport_ae_funcs.size)]]]();
	}
	else
	{
		self thread [[level.teleport_ae_funcs[int(getdvarstring("castleAftereffectOverride"))]]]();
	}
}

/*
	Name: teleport_aftereffect_shellshock
	Namespace: zm_castle_teleporter
	Checksum: 0x8A0C923E
	Offset: 0x2DF8
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
	Namespace: zm_castle_teleporter
	Checksum: 0xA484BE94
	Offset: 0x2E48
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
	Namespace: zm_castle_teleporter
	Checksum: 0xFDE4BF05
	Offset: 0x2E98
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
	Namespace: zm_castle_teleporter
	Checksum: 0x725114C2
	Offset: 0x2EC8
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
	Namespace: zm_castle_teleporter
	Checksum: 0xFDD97E9E
	Offset: 0x2F00
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
	Namespace: zm_castle_teleporter
	Checksum: 0x9BF752C0
	Offset: 0x2F38
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
	Namespace: zm_castle_teleporter
	Checksum: 0xFEE3D8ED
	Offset: 0x2F70
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_flare_vision(localclientnum)
{
	util::setclientsysstate("levelNotify", "tae", self);
}

