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
#using scripts\zm\_zm_weap_ball;
#using scripts\zm\zm_genesis_util;
#using scripts\zm\zm_genesis_vo;

#namespace zm_genesis_teleporter;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_teleporter
	Checksum: 0x3D532866
	Offset: 0x598
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_teleporter", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_teleporter
	Checksum: 0xFB2CBBC5
	Offset: 0x5E0
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.n_teleport_delay = 4;
	level.n_teleport_cooldown = 45;
	/#
		if(getdvarint("") > 0)
		{
			level.n_teleport_cooldown = 3;
		}
	#/
	level.var_18879020 = 0;
	level.var_47f4765c = 0;
	level flag::init("genesis_teleporter_used");
	visionset_mgr::register_info("overlay", "zm_factory_teleport", 15000, 61, 1, 1);
	visionset_mgr::register_info("overlay", "zm_genesis_transported", 15000, 20, 15, 1, &visionset_mgr::duration_lerp_thread_per_player, 0);
	clientfield::register("toplayer", "player_shadowman_teleport_hijack_fx", 15000, 1, "int");
}

/*
	Name: __main__
	Namespace: zm_genesis_teleporter
	Checksum: 0xE1CB0D98
	Offset: 0x710
	Size: 0x15E
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level.var_7d7ca0ea = getent("t_teleport_pad_ee", "targetname");
	level.var_7d7ca0ea thread teleport_pad_think();
	level.var_7d7ca0ea thread function_b6d07c17();
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
	Name: function_b6d07c17
	Namespace: zm_genesis_teleporter
	Checksum: 0xD1447263
	Offset: 0x878
	Size: 0x140
	Parameters: 0
	Flags: Linked
*/
function function_b6d07c17()
{
	while(true)
	{
		self.var_d0866ff4 = [];
		foreach(e_player in level.activeplayers)
		{
			if(zombie_utility::is_player_valid(e_player) && self player_is_near_pad(e_player))
			{
				if(!isdefined(self.var_d0866ff4))
				{
					self.var_d0866ff4 = [];
				}
				else if(!isarray(self.var_d0866ff4))
				{
					self.var_d0866ff4 = array(self.var_d0866ff4);
				}
				self.var_d0866ff4[self.var_d0866ff4.size] = e_player;
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: teleport_pad_think
	Namespace: zm_genesis_teleporter
	Checksum: 0xC8E1A26A
	Offset: 0x9C0
	Size: 0x130
	Parameters: 0
	Flags: Linked
*/
function teleport_pad_think()
{
	self setcursorhint("HINT_NOICON");
	self sethintstring(&"");
	level waittill(#"sophia_at_teleporter");
	self thread teleport_pad_active_think();
	while(true)
	{
		self sethintstring(&"");
		level flag::wait_till("teleporter_on");
		exploder::exploder("ee_teleporter_on");
		exploder::exploder("lgt_teleporter_powered");
		level flag::wait_till_clear("teleporter_on");
		exploder::stop_exploder("ee_teleporter_on");
		exploder::stop_exploder("lgt_teleporter_powered");
	}
}

/*
	Name: teleport_pad_active_think
	Namespace: zm_genesis_teleporter
	Checksum: 0x79ADC3B5
	Offset: 0xAF8
	Size: 0x18A
	Parameters: 0
	Flags: Linked
*/
function teleport_pad_active_think()
{
	level thread zm_genesis_vo::function_14ee80c6();
	while(true)
	{
		self waittill(#"trigger", e_player);
		if(zm_utility::is_player_valid(e_player) && !level.var_18879020)
		{
			var_12b659cf = 0;
			if(level flag::get("toys_collected") && !level flag::get("boss_fight"))
			{
				var_12b659cf = 1;
			}
			if(!function_7ae798cc(e_player))
			{
				continue;
			}
			self playsound("evt_teleporter_warmup");
			self thread teleport_trigger_invisible(1);
			b_result = self function_264f93ff(var_12b659cf);
			self thread teleport_trigger_invisible(0);
			level flag::clear("teleporter_on");
			if(b_result)
			{
				level notify(#"hash_944787dd", e_player);
			}
		}
	}
}

/*
	Name: function_7ae798cc
	Namespace: zm_genesis_teleporter
	Checksum: 0xCCC811A8
	Offset: 0xC90
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_7ae798cc(e_who)
{
	if(!level flag::get("teleporter_on"))
	{
		return false;
	}
	if(e_who.is_drinking > 0)
	{
		return false;
	}
	if(e_who zm_utility::in_revive_trigger())
	{
		return false;
	}
	if(!array::is_touching(level.activeplayers, self))
	{
		return false;
	}
	if(zm_utility::is_player_valid(e_who))
	{
		if(!e_who zm_score::can_player_purchase(0))
		{
			e_who zm_audio::create_and_play_dialog("general", "transport_deny");
			return false;
		}
		e_who zm_score::minus_to_player_score(0);
		return true;
	}
	return false;
}

/*
	Name: function_264f93ff
	Namespace: zm_genesis_teleporter
	Checksum: 0x620543D8
	Offset: 0xDA8
	Size: 0x570
	Parameters: 1
	Flags: Linked
*/
function function_264f93ff(var_12b659cf = 0)
{
	exploder::exploder("ee_teleporter_fx");
	self thread function_f5a06c(level.n_teleport_delay);
	self thread teleport_nuke(20, 300);
	if(var_12b659cf)
	{
		foreach(e_player in level.players)
		{
			e_player zm_utility::create_streamer_hint(struct::get_array("dark_arena_teleport_hijack", "targetname")[0].origin, struct::get_array("dark_arena_teleport_hijack", "targetname")[0].angles, 1);
		}
		var_2950e51 = struct::get_array("dark_arena_teleport_hijack", "targetname");
		wait(2);
		self notify(#"fx_done");
		zm_genesis_util::function_342295d8("dark_arena2_zone");
		zm_genesis_util::function_342295d8("dark_arena_zone");
		b_result = self function_67eda94(var_2950e51);
		if(!b_result)
		{
			return false;
		}
		level flag::set("boss_fight");
		return;
	}
	foreach(e_player in level.players)
	{
		e_player zm_utility::create_streamer_hint(struct::get_array("sams_room_pos", "script_noteworthy")[0].origin, struct::get_array("sams_room_pos", "script_noteworthy")[0].angles, 1, level.n_teleport_delay + 4);
		e_player clientfield::set_to_player("player_light_exploder", 2);
	}
	a_s_pos = struct::get_array(self.target, "targetname");
	var_221e828b = [];
	var_785e8821 = [];
	for(i = 0; i < a_s_pos.size; i++)
	{
		if(a_s_pos[i].script_noteworthy === "sams_room_pos")
		{
			array::add(var_221e828b, a_s_pos[i], 0);
			continue;
		}
		if(a_s_pos[i].script_noteworthy === "teleporter_pos")
		{
			array::add(var_785e8821, a_s_pos[i], 0);
		}
	}
	wait(2);
	self notify(#"fx_done");
	zm_genesis_util::function_342295d8("samanthas_room_zone");
	b_result = self function_f898dba2(var_221e828b, var_12b659cf);
	if(!b_result)
	{
		return false;
	}
	if(!var_12b659cf)
	{
		wait(30);
		exploder::exploder("ee_teleporter_fx");
		e_player zm_utility::create_streamer_hint(var_785e8821[0].origin, var_785e8821[0].angles, 1, level.n_teleport_delay + 2);
		self function_f3d057eb(var_785e8821);
		e_player clientfield::set_to_player("player_light_exploder", 1);
		zm_genesis_util::function_342295d8("samanthas_room_zone", 0);
		level thread zm_genesis_vo::function_60fe98c4();
	}
	return true;
}

/*
	Name: teleport_trigger_invisible
	Namespace: zm_genesis_teleporter
	Checksum: 0x44876906
	Offset: 0x1320
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function teleport_trigger_invisible(var_855ca94a)
{
	foreach(e_player in level.players)
	{
		self setinvisibletoplayer(e_player, var_855ca94a);
	}
}

/*
	Name: player_is_near_pad
	Namespace: zm_genesis_teleporter
	Checksum: 0x9E533B02
	Offset: 0x13C8
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function player_is_near_pad(player)
{
	n_dist_sq = distance2dsquared(player.origin, self.origin);
	if(n_dist_sq < 5184)
	{
		return true;
	}
	return false;
}

/*
	Name: function_f5a06c
	Namespace: zm_genesis_teleporter
	Checksum: 0xC6913E33
	Offset: 0x1430
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
	Namespace: zm_genesis_teleporter
	Checksum: 0x1AFEAD1
	Offset: 0x1478
	Size: 0x180
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
		if(array::contains(var_7d7ca0ea.var_d0866ff4, self))
		{
			visionset_mgr::activate("overlay", "zm_trap_electric", self, 1.25, 1.25);
			self playrumbleonentity("zm_castle_pulsing_rumble");
			while(n_total_time < n_duration && array::contains(var_7d7ca0ea.var_d0866ff4, self))
			{
				n_current_time = gettime();
				n_total_time = (n_current_time - n_start_time) / 1000;
				util::wait_network_frame();
			}
			visionset_mgr::deactivate("overlay", "zm_trap_electric", self);
		}
		n_current_time = gettime();
		n_total_time = (n_current_time - n_start_time) / 1000;
		util::wait_network_frame();
	}
}

/*
	Name: function_67eda94
	Namespace: zm_genesis_teleporter
	Checksum: 0x5C88FEC
	Offset: 0x1600
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function function_67eda94(a_s_pos)
{
	return self teleport_players(a_s_pos, 1, 0, 1);
}

/*
	Name: function_f898dba2
	Namespace: zm_genesis_teleporter
	Checksum: 0x510B23EF
	Offset: 0x1638
	Size: 0x42
	Parameters: 2
	Flags: Linked
*/
function function_f898dba2(a_s_pos, var_6bd63d0d)
{
	level notify(#"hash_a14d03aa");
	return self teleport_players(a_s_pos, 1, var_6bd63d0d);
}

/*
	Name: function_f3d057eb
	Namespace: zm_genesis_teleporter
	Checksum: 0x54EA62A6
	Offset: 0x1688
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function function_f3d057eb(a_s_pos)
{
	return self teleport_players(a_s_pos, 0, 1);
}

/*
	Name: teleport_players
	Namespace: zm_genesis_teleporter
	Checksum: 0xD02D9483
	Offset: 0x16C0
	Size: 0x940
	Parameters: 4
	Flags: Linked
*/
function teleport_players(a_s_pos, var_1bac7e2b, var_e11d2975, var_6bd63d0d = 0)
{
	level flag::set("genesis_teleporter_used");
	n_player_radius = 24;
	var_a80e3914 = struct::get_array("teleport_room_pos", "targetname");
	var_c172b345 = 1;
	foreach(e_player in level.activeplayers)
	{
		if(!array::contains(self.var_d0866ff4, e_player))
		{
			var_c172b345 = 0;
		}
	}
	if(var_e11d2975 || var_c172b345)
	{
		var_19ff0dfb = [];
		var_daad3c3c = vectorscale((0, 0, 1), 49);
		var_6b55b1c4 = vectorscale((0, 0, 1), 20);
		var_3abe10e2 = (0, 0, 0);
		var_d9543609 = undefined;
		for(i = 0; i < level.players.size; i++)
		{
			e_player = level.players[i];
			if(var_1bac7e2b || (!var_1bac7e2b && (isdefined(e_player.b_teleported) && e_player.b_teleported)))
			{
				if(isdefined(var_a80e3914[i]))
				{
					e_player.b_teleporting = 1;
					visionset_mgr::deactivate("overlay", "zm_trap_electric", e_player);
					if(var_6bd63d0d)
					{
						e_player clientfield::set_to_player("player_shadowman_teleport_hijack_fx", 1);
					}
					else
					{
						visionset_mgr::activate("overlay", "zm_factory_teleport", e_player);
					}
					if(e_player hasweapon(level.ballweapon))
					{
						var_d9543609 = e_player.carryobject;
					}
					e_player disableoffhandweapons();
					e_player disableweapons();
					if(e_player getstance() == "prone")
					{
						var_e2a6e15f = var_a80e3914[i].origin + var_daad3c3c;
					}
					else
					{
						if(e_player getstance() == "crouch")
						{
							var_e2a6e15f = var_a80e3914[i].origin + var_6b55b1c4;
						}
						else
						{
							var_e2a6e15f = var_a80e3914[i].origin + var_3abe10e2;
						}
					}
					array::add(var_19ff0dfb, e_player, 0);
					e_player.var_601ebf01 = util::spawn_model("tag_origin", e_player.origin, e_player.angles);
					e_player linkto(e_player.var_601ebf01);
					e_player dontinterpolate();
					e_player.var_601ebf01 dontinterpolate();
					e_player.var_601ebf01.origin = var_e2a6e15f;
					e_player.var_601ebf01.angles = var_a80e3914[i].angles;
					e_player freezecontrols(1);
					util::wait_network_frame();
					if(isdefined(e_player))
					{
						util::setclientsysstate("levelNotify", "black_box_start", e_player);
						e_player.var_601ebf01.angles = var_a80e3914[i].angles;
					}
				}
			}
		}
		if(var_1bac7e2b && var_19ff0dfb.size == level.activeplayers.size)
		{
			if(level flag::get("spawn_zombies"))
			{
				level flag::clear("spawn_zombies");
			}
		}
		wait(level.n_teleport_delay);
		array::random(a_s_pos) thread teleport_nuke(undefined, 300);
		for(i = 0; i < level.activeplayers.size; i++)
		{
			util::setclientsysstate("levelNotify", "black_box_end", level.activeplayers[i]);
		}
		util::wait_network_frame();
		for(i = 0; i < var_19ff0dfb.size; i++)
		{
			e_player = var_19ff0dfb[i];
			if(!isdefined(e_player))
			{
				continue;
			}
			e_player unlink();
			if(positionwouldtelefrag(a_s_pos[i].origin))
			{
				e_player setorigin(a_s_pos[i].origin + (randomfloatrange(-16, 16), randomfloatrange(-16, 16), 0));
			}
			else
			{
				e_player setorigin(a_s_pos[i].origin);
			}
			e_player setplayerangles(a_s_pos[i].angles);
			if(var_6bd63d0d)
			{
				e_player clientfield::set_to_player("player_shadowman_teleport_hijack_fx", 0);
			}
			else
			{
				visionset_mgr::deactivate("overlay", "zm_factory_teleport", e_player);
			}
			if(isdefined(var_d9543609))
			{
				var_d9543609 ball::reset_ball(0);
			}
			e_player enableweapons();
			e_player enableoffhandweapons();
			e_player freezecontrols(0);
			e_player thread teleport_aftereffects();
			e_player.var_601ebf01 delete();
			if(var_1bac7e2b)
			{
				e_player.b_teleported = 1;
			}
			else
			{
				e_player.b_teleported = undefined;
			}
			e_player.b_teleporting = 0;
		}
		if(!var_1bac7e2b)
		{
			level.var_47f4765c++;
			level flag::set("spawn_zombies");
			if(level.var_47f4765c == 1 || (level.var_47f4765c % 3) == 0)
			{
				playsoundatposition("vox_maxis_teleporter_pa_success_0", a_s_pos[0].origin);
			}
		}
		return true;
	}
	return false;
}

/*
	Name: teleport_nuke
	Namespace: zm_genesis_teleporter
	Checksum: 0xBC34B907
	Offset: 0x2010
	Size: 0x1C6
	Parameters: 2
	Flags: Linked
*/
function teleport_nuke(n_max_zombies, n_range)
{
	a_ai_zombies = getaiteamarray(level.zombie_team);
	a_ai_zombies = util::get_array_of_closest(self.origin, a_ai_zombies, undefined, n_max_zombies, n_range);
	for(i = 0; i < a_ai_zombies.size; i++)
	{
		wait(randomfloatrange(0.2, 0.3));
		if(!isdefined(a_ai_zombies[i]))
		{
			continue;
		}
		if(zm_utility::is_magic_bullet_shield_enabled(a_ai_zombies[i]))
		{
			continue;
		}
		if(a_ai_zombies[i].archetype === "mechz" || a_ai_zombies[i].archetype === "margwa")
		{
			continue;
		}
		if(!a_ai_zombies[i].isdog)
		{
			a_ai_zombies[i] zombie_utility::zombie_head_gib();
		}
		a_ai_zombies[i] dodamage(10000, a_ai_zombies[i].origin);
		playsoundatposition("nuked", a_ai_zombies[i].origin);
	}
}

/*
	Name: teleport_2d_audio
	Namespace: zm_genesis_teleporter
	Checksum: 0x73271CDC
	Offset: 0x21E0
	Size: 0xBA
	Parameters: 0
	Flags: None
*/
function teleport_2d_audio()
{
	self endon(#"fx_done");
	while(true)
	{
		wait(1.7);
		for(i = 0; i < level.players.size; i++)
		{
			if(isdefined(level.players[i]))
			{
				if(array::contains(self.var_d0866ff4, level.players[i]))
				{
					util::setclientsysstate("levelNotify", "t2d", level.players[i]);
				}
			}
		}
	}
}

/*
	Name: teleport_aftereffects
	Namespace: zm_genesis_teleporter
	Checksum: 0xEFC7E856
	Offset: 0x22A8
	Size: 0xAA
	Parameters: 2
	Flags: Linked
*/
function teleport_aftereffects(var_edc2ee2a, var_66f7e6b9)
{
	if(getdvarstring("genesisAftereffectOverride") == ("-1"))
	{
		self thread [[level.teleport_ae_funcs[randomint(level.teleport_ae_funcs.size)]]]();
	}
	else
	{
		self thread [[level.teleport_ae_funcs[int(getdvarstring("genesisAftereffectOverride"))]]]();
	}
}

/*
	Name: teleport_aftereffect_shellshock
	Namespace: zm_genesis_teleporter
	Checksum: 0xC110E397
	Offset: 0x2360
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
	Namespace: zm_genesis_teleporter
	Checksum: 0x666FDF70
	Offset: 0x23B0
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
	Namespace: zm_genesis_teleporter
	Checksum: 0x5C98AA18
	Offset: 0x2400
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
	Namespace: zm_genesis_teleporter
	Checksum: 0x51B8C6C6
	Offset: 0x2430
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
	Namespace: zm_genesis_teleporter
	Checksum: 0x1BE41346
	Offset: 0x2468
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
	Namespace: zm_genesis_teleporter
	Checksum: 0xC90E9CA9
	Offset: 0x24A0
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
	Namespace: zm_genesis_teleporter
	Checksum: 0x27C860AB
	Offset: 0x24D8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_flare_vision(localclientnum)
{
	util::setclientsysstate("levelNotify", "tae", self);
}

