// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_monkey;
#using scripts\zm\_zm_ai_napalm;
#using scripts\zm\_zm_ai_sonic;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_radio;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_shrink_ray;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_temple_ai_monkey;
#using scripts\zm\zm_temple_amb;
#using scripts\zm\zm_temple_ffotd;
#using scripts\zm\zm_temple_fx;
#using scripts\zm\zm_temple_geyser;
#using scripts\zm\zm_temple_maze;
#using scripts\zm\zm_temple_sq;

#namespace zm_temple;

/*
	Name: function_d9af860b
	Namespace: zm_temple
	Checksum: 0x29D47E65
	Offset: 0xC98
	Size: 0x1C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_d9af860b()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
}

/*
	Name: main
	Namespace: zm_temple
	Checksum: 0x494B97B9
	Offset: 0xCC0
	Size: 0x314
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_temple_ffotd::main_start();
	setdvar("player_sliding_velocity_cap", 50);
	setdvar("player_sliding_wishspeed", 600);
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	thread zm_temple_fx::main();
	level._uses_sticky_grenades = 1;
	level._temple_vision_set = "zombie_temple";
	level._temple_vision_set_priority = 1;
	level._temple_caves_vision_set = "zombie_temple_caves";
	level._temple_caves_vision_set_priority = 2;
	level._temple_water_vision_set = "zombie_temple";
	level._temple_eclipse_vision_set = "zombie_temple_eclipse";
	level._temple_eclipse_vision_set_priority = 3;
	level._temple_caves_eclipse_vision_set = "zombie_temple_eclipseCave";
	level._temple_caves_eclipse_vision_set_priority = 3;
	level.riser_fx_on_client = 1;
	level.use_new_riser_water = 1;
	level.use_clientside_rock_tearin_fx = 1;
	level.use_clientside_board_fx = 1;
	level.var_e34b793e = 0;
	include_weapons();
	init_level_specific_wall_buy_fx();
	visionset_mgr::register_overlay_info_style_blur("zm_ai_screecher_blur", 21000, 15, 0.1, 0.25, 20);
	level thread zm_temple_amb::main();
	function_80cb4231();
	zm_temple_sq::init_clientfields();
	zm_temple_geyser::main();
	load::main();
	_zm_weap_cymbal_monkey::init();
	level thread power_watch();
	callback::on_localclient_connect(&temple_player_connect);
	callback::on_localplayer_spawned(&temple_player_spawned);
	level thread temple_light_model_swap_init();
	level thread sq_std_watcher();
	level._in_eclipse = 0;
	level thread crystal_sauce_monitor();
	util::waitforclient(0);
	level thread function_6ac83719();
	/#
		println("");
	#/
	zm_temple_ffotd::main_end();
}

/*
	Name: function_6ac83719
	Namespace: zm_temple
	Checksum: 0xABA209C
	Offset: 0xFE0
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_6ac83719()
{
	visionset_mgr::init_fog_vol_to_visionset_monitor("zombie_temple", 2);
	visionset_mgr::fog_vol_to_visionset_set_suffix("");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_temple");
	visionset_mgr::fog_vol_to_visionset_set_info(1, "zombie_temple_caves");
}

/*
	Name: function_80cb4231
	Namespace: zm_temple
	Checksum: 0xF327756B
	Offset: 0x1068
	Size: 0x4E4
	Parameters: 0
	Flags: Linked
*/
function function_80cb4231()
{
	clientfield::register("actor", "ragimpactgib", 21000, 1, "int", &ragdoll_impact_watch_start, 0, 0);
	clientfield::register("scriptmover", "spiketrap", 21000, 1, "int", &spike_trap_move, 0, 0);
	clientfield::register("scriptmover", "mazewall", 21000, 1, "int", &maze_wall_move, 0, 0);
	clientfield::register("scriptmover", "weaksauce", 21000, 1, "int", &crystal_weaksauce_start, 0, 0);
	clientfield::register("scriptmover", "hotsauce", 21000, 1, "int", &crystal_hotsauce_start, 0, 0);
	clientfield::register("scriptmover", "sauceend", 21000, 1, "int", &crystal_sauce_end, 0, 0);
	clientfield::register("scriptmover", "watertrail", 21000, 1, "int", &water_trail_monitor, 0, 0);
	clientfield::register("toplayer", "floorrumble", 21000, 1, "int", &maze_floor_controller_rumble, 0, 0);
	clientfield::register("toplayer", "minecart_rumble", 21000, 1, "int", &function_425904c0, 0, 0);
	clientfield::register("world", "papspinners", 21000, 4, "int", &function_9fe44296, 0, 0);
	clientfield::register("world", "water_wheel_right", 21000, 1, "int", &water_wheel_right, 0, 0);
	clientfield::register("world", "water_wheel_left", 21000, 1, "int", &water_wheel_left, 0, 0);
	clientfield::register("world", "waterfall_trap", 21000, 1, "int", &waterfall_watcher, 0, 0);
	clientfield::register("world", "time_transition", 21000, 1, "int", &timetravel_watcher, 0, 1);
	clientfield::register("allplayers", "player_legs_hide", 21000, 1, "int", &player_legs_hide, 0, 0);
	clientfield::register("scriptmover", "zombie_has_eyes", 21000, 1, "int", &zm::zombie_eyes_clientfield_cb, 0, 0);
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_waterfall_postfx", 21000, 32, "pstfx_waterfall_soft", 3);
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_temple_eclipse", 21000, 1, "pstfx_temple_eclipse_in", 3);
}

/*
	Name: spike_trap_move
	Namespace: zm_temple
	Checksum: 0xFE83413A
	Offset: 0x1558
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function spike_trap_move(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	spike_trap_move_spikes(localclientnum, newval);
}

/*
	Name: maze_wall_move
	Namespace: zm_temple
	Checksum: 0x3CCB0870
	Offset: 0x15B8
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function maze_wall_move(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	zm_temple_maze::maze_trap_move_wall(localclientnum, newval);
}

/*
	Name: delete_water_trail
	Namespace: zm_temple
	Checksum: 0xCECB248
	Offset: 0x1618
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function delete_water_trail()
{
	wait(1.2);
	for(i = 0; i < self.fx_ents.size; i++)
	{
		self.fx_ents[i] delete();
	}
	self.fx_ents = undefined;
}

/*
	Name: water_trail_monitor
	Namespace: zm_temple
	Checksum: 0xAF4A88D9
	Offset: 0x1680
	Size: 0x18C
	Parameters: 7
	Flags: Linked
*/
function water_trail_monitor(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(newval)
	{
		players = getlocalplayers();
		self.fx_ents = [];
		for(i = 0; i < players.size; i++)
		{
			self.fx_ents[i] = spawn(i, (0, 0, 0), "script_model");
			self.fx_ents[i] setmodel("tag_origin");
			self.fx_ents[i] linkto(self, "tag_origin");
			playfxontag(i, level._effect["fx_crystal_water_trail"], self.fx_ents[i], "tag_origin");
		}
	}
	else if(isdefined(self.fx_ents))
	{
		self thread delete_water_trail();
	}
}

/*
	Name: crystal_weaksauce_start
	Namespace: zm_temple
	Checksum: 0x91475AB1
	Offset: 0x1818
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function crystal_weaksauce_start(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(!newval)
	{
		return;
	}
	s = spawnstruct();
	s.fx = "fx_weak_sauce_trail";
	s.origin = self.origin + vectorscale((0, 0, 1), 134);
	level._crystal_sauce_start = s;
}

/*
	Name: crystal_hotsauce_start
	Namespace: zm_temple
	Checksum: 0x47BDCB72
	Offset: 0x18D8
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function crystal_hotsauce_start(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(!newval)
	{
		return;
	}
	s = spawnstruct();
	s.fx = "fx_hot_sauce_trail";
	s.origin = self.origin + vectorscale((0, 0, 1), 134);
	level._crystal_sauce_start = s;
}

/*
	Name: crystal_sauce_end
	Namespace: zm_temple
	Checksum: 0x45E97701
	Offset: 0x1998
	Size: 0x98
	Parameters: 7
	Flags: Linked
*/
function crystal_sauce_end(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(!newval)
	{
		return;
	}
	level._crystal_sauce_end = self.origin;
	if(self.model == "p7_zm_sha_crystal_holder_full")
	{
		level._crystal_sauce_end = level._crystal_sauce_end + vectorscale((0, 0, 1), 134);
	}
}

/*
	Name: crystal_trail_runner
	Namespace: zm_temple
	Checksum: 0x2FBB12BA
	Offset: 0x1A38
	Size: 0xF4
	Parameters: 3
	Flags: Linked
*/
function crystal_trail_runner(localclientnum, fx_name, dest)
{
	/#
		println((((("" + fx_name) + "") + self.origin) + "") + dest);
	#/
	playfxontag(localclientnum, level._effect[fx_name], self, "tag_origin");
	self playloopsound("evt_sq_bag_crystal_bounce_loop", 0.05);
	self moveto(dest, 0.5);
	self waittill(#"movedone");
	self delete();
}

/*
	Name: crystal_sauce_monitor
	Namespace: zm_temple
	Checksum: 0xC708704
	Offset: 0x1B38
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function crystal_sauce_monitor()
{
	num_players = getlocalplayers().size;
	while(true)
	{
		wait(0.016);
		if(!isdefined(level._crystal_sauce_start) || !isdefined(level._crystal_sauce_end))
		{
			continue;
		}
		for(i = 0; i < num_players; i++)
		{
			e = spawn(i, level._crystal_sauce_start.origin, "script_model");
			e setmodel("tag_origin");
			e thread crystal_trail_runner(i, level._crystal_sauce_start.fx, level._crystal_sauce_end);
		}
		level._crystal_sauce_start = undefined;
		level._crystal_sauce_end = undefined;
	}
}

/*
	Name: power_watch
	Namespace: zm_temple
	Checksum: 0xC21DB335
	Offset: 0x1C60
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function power_watch()
{
	level.power = 0;
	level waittill(#"zpo");
	level.power = 1;
	level thread start_generator_movement();
}

/*
	Name: timetravel_watcher
	Namespace: zm_temple
	Checksum: 0xF1CC01F4
	Offset: 0x1CA8
	Size: 0x2D4
	Parameters: 7
	Flags: Linked
*/
function timetravel_watcher(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		level notify(#"db");
		level thread zm_temple_amb::function_e3a6a660(bnewent, binitialsnap, bwasdemojump);
		var_4796f90 = isdefined(level._in_eclipse) && level._in_eclipse;
		level._in_eclipse = 0;
		visionset_mgr::fog_vol_to_visionset_set_suffix("");
		level notify(#"time_travel", level._in_eclipse);
		exploder::exploder("fxexp_401");
		if(var_4796f90)
		{
			exploder::kill_exploder("fxexp_402");
		}
		exploder::kill_exploder("eclipse");
		if(bnewent || binitialsnap || bwasdemojump)
		{
			setdvar("r_skyTransition", 0);
		}
		else
		{
			level thread function_bf1b3728(0, 2);
		}
		setlitfogbank(localclientnum, -1, 0, 0);
		setworldfogactivebank(localclientnum, 1);
	}
	else
	{
		level thread zm_temple_amb::function_418a175a();
		level._in_eclipse = 1;
		level notify(#"time_travel", level._in_eclipse);
		visionset_mgr::fog_vol_to_visionset_set_suffix("_eclipse");
		exploder::exploder("eclipse");
		exploder::exploder("fxexp_402");
		exploder::kill_exploder("fxexp_401");
		level thread function_bf1b3728(1, 2.5);
		setlitfogbank(localclientnum, -1, 1, 1);
		setworldfogactivebank(localclientnum, 2);
	}
	if(!isdefined(level._sidequest_firsttime))
	{
		level._sidequest_firsttime = 0;
		return;
	}
	level thread function_7b0ba395(localclientnum);
}

/*
	Name: function_bf1b3728
	Namespace: zm_temple
	Checksum: 0xA71C0B30
	Offset: 0x1F88
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function function_bf1b3728(n_val, n_time)
{
	level notify(#"hash_47d048e6");
	level endon(#"hash_47d048e6");
	if(!isdefined(level.var_3766c3d3))
	{
		level.var_3766c3d3 = 0;
	}
	if(level.var_3766c3d3 == n_val)
	{
		return;
	}
	if(n_val > level.var_3766c3d3)
	{
		var_83a6ec14 = n_val - level.var_3766c3d3;
	}
	else
	{
		var_83a6ec14 = (level.var_3766c3d3 - n_val) * -1;
		wait(0.5);
	}
	n_change = var_83a6ec14 / (n_time / 0.1);
	while(level.var_3766c3d3 != n_val)
	{
		level.var_3766c3d3 = level.var_3766c3d3 + n_change;
		setdvar("r_skyTransition", level.var_3766c3d3);
		wait(0.1);
	}
	setdvar("r_skyTransition", n_val);
}

/*
	Name: function_7b0ba395
	Namespace: zm_temple
	Checksum: 0xCC539365
	Offset: 0x20D8
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_7b0ba395(localclientnum)
{
	level endon(#"end_rumble");
	level endon(#"end_game");
	player = getlocalplayers()[localclientnum];
	var_efeac590 = 0;
	n_end_time = 2;
	player playrumblelooponentity(localclientnum, "tank_rumble");
	while(isdefined(player) && var_efeac590 < n_end_time)
	{
		player earthquake(0.3, 0.1, player.origin, 100);
		var_efeac590 = var_efeac590 + 0.1;
		wait(0.1);
	}
	if(isdefined(player))
	{
		player stoprumble(localclientnum, "tank_rumble");
	}
}

/*
	Name: start_generator_movement
	Namespace: zm_temple
	Checksum: 0x6BEB53E8
	Offset: 0x2210
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function start_generator_movement()
{
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		ent = getent(i, "power_generator", "targetname");
		ent thread generator_move();
	}
}

/*
	Name: generator_move
	Namespace: zm_temple
	Checksum: 0xD5041863
	Offset: 0x22A8
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function generator_move()
{
	offsetangle = 0.25;
	rottime = 0.1;
	total = 0;
	self rotateroll(0 - offsetangle, rottime);
	while(true)
	{
		self waittill(#"rotatedone");
		self rotateroll(offsetangle * 2, rottime);
		self waittill(#"rotatedone");
		self rotateroll(0 - (offsetangle * 2), rottime);
	}
}

/*
	Name: player_legs_hide
	Namespace: zm_temple
	Checksum: 0x67D9A957
	Offset: 0x2378
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function player_legs_hide(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self hideviewlegs();
	}
	else
	{
		self showviewlegs();
	}
}

/*
	Name: water_wheel_right
	Namespace: zm_temple
	Checksum: 0x68376B85
	Offset: 0x23F8
	Size: 0xD6
	Parameters: 7
	Flags: Linked
*/
function water_wheel_right(clientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		wheel = getent(i, "water_wheel_right", "targetname");
		wheel thread rotatewheel(120, 2.2);
	}
}

/*
	Name: water_wheel_left
	Namespace: zm_temple
	Checksum: 0x32C227C6
	Offset: 0x24D8
	Size: 0xD6
	Parameters: 7
	Flags: Linked
*/
function water_wheel_left(clientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		wheel = getent(i, "water_wheel_left", "targetname");
		wheel thread rotatewheel(120, 1.8);
	}
}

/*
	Name: rotatewheel
	Namespace: zm_temple
	Checksum: 0xAC8F2DF7
	Offset: 0x25B8
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function rotatewheel(rotate, time)
{
	spinuptime = time - 0.5;
	self rotatepitch(rotate, time, spinuptime, 0.1);
	self waittill(#"rotatedone");
	while(true)
	{
		self rotatepitch(rotate, time, 0, 0);
		self waittill(#"rotatedone");
	}
}

/*
	Name: disable_deadshot
	Namespace: zm_temple
	Checksum: 0x3E3F6D46
	Offset: 0x2660
	Size: 0x9E
	Parameters: 1
	Flags: Linked
*/
function disable_deadshot(i_local_client_num)
{
	while(!self hasdobj(i_local_client_num))
	{
		wait(0.05);
	}
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		if(self == players[i])
		{
			self clearalternateaimparams();
		}
	}
}

/*
	Name: water_gush_debug
	Namespace: zm_temple
	Checksum: 0xFF476DA2
	Offset: 0x2708
	Size: 0xE6
	Parameters: 0
	Flags: None
*/
function water_gush_debug()
{
	/#
		scale = 0.1;
		offset = (0, 0, 0);
		dir = anglestoforward(self.angles);
		for(i = 0; i < 5; i++)
		{
			print3d(self.origin + offset, "", (60, 60, 255), 1, scale, 10);
			scale = scale * 1.7;
			offset = offset + (dir * 6);
		}
	#/
}

/*
	Name: waterfall_watcher
	Namespace: zm_temple
	Checksum: 0x7E796D47
	Offset: 0x27F8
	Size: 0xF6
	Parameters: 7
	Flags: Linked
*/
function waterfall_watcher(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	targets = struct::get_array("sq_sad", "targetname");
	for(i = 0; i < targets.size; i++)
	{
		if(!isdefined(level._sq_std_status) || !isdefined(level._sq_std_status[i]))
		{
			continue;
		}
		if(level._sq_std_status[i] == 0)
		{
			exploder::exploder("fxexp_12" + i);
		}
		wait(0.25);
	}
}

/*
	Name: sq_std_watcher
	Namespace: zm_temple
	Checksum: 0x58E4E5D9
	Offset: 0x28F8
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function sq_std_watcher()
{
	/#
		println("");
	#/
	/#
		println("");
	#/
	level waittill(#"sr");
	players = getlocalplayers();
	/#
		println("");
	#/
	targets = struct::get_array("sq_sad", "targetname");
	/#
		println(("" + targets.size) + "");
	#/
	for(i = 0; i < targets.size; i++)
	{
		targets[i] thread sq_std_struct_watcher(players.size);
	}
}

/*
	Name: sq_std_watch_for_restart
	Namespace: zm_temple
	Checksum: 0xC1F5770E
	Offset: 0x2A38
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function sq_std_watch_for_restart(num_local_players)
{
	level waittill(#"sr");
	if(isdefined(level._sq_std_array[self.script_int - 1]))
	{
		for(i = 0; i < (level._sq_std_array[self.script_int - 1].size); i++)
		{
			if(isdefined(level._sq_std_array[self.script_int - 1][i]))
			{
				level._sq_std_array[self.script_int - 1][i] delete();
			}
		}
		level._sq_std_array[self.script_int - 1] = undefined;
	}
	level._sq_std_status[self.script_int - 1] = 0;
	self thread sq_std_struct_watcher(num_local_players);
}

/*
	Name: sq_struct_debug
	Namespace: zm_temple
	Checksum: 0x976AFF67
	Offset: 0x2B48
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function sq_struct_debug()
{
	/#
		level endon(#"sr");
		level endon(#"ksd");
		while(true)
		{
			print3d(self.origin, "", vectorscale((1, 0, 0), 255), 1);
			wait(0.1);
		}
	#/
}

/*
	Name: sq_std_struct_watcher
	Namespace: zm_temple
	Checksum: 0x71E2AD69
	Offset: 0x2BB0
	Size: 0x1EE
	Parameters: 1
	Flags: Linked
*/
function sq_std_struct_watcher(num_local_players)
{
	if(!isdefined(level._sq_std_array))
	{
		level._sq_std_array = [];
		level._sq_std_status = [];
		for(i = 0; i < 4; i++)
		{
			level._sq_std_status[i] = 0;
		}
	}
	level endon(#"sr");
	self thread sq_std_watch_for_restart(num_local_players);
	while(true)
	{
		level waittill("S" + self.script_int);
		/#
			println("" + self.script_int);
		#/
		self thread sq_struct_debug();
		level._sq_std_status[self.script_int - 1] = 1;
		level._sq_std_array[self.script_int - 1] = [];
		for(i = 0; i < num_local_players; i++)
		{
			e = spawn(i, self.origin, "script_model");
			e.angles = self.angles + vectorscale((1, 0, 0), 270);
			e setmodel("wpn_t7_spider_mine_world");
			level._sq_std_array[self.script_int - 1][level._sq_std_array[self.script_int - 1].size] = e;
		}
	}
}

/*
	Name: temple_player_spawned
	Namespace: zm_temple
	Checksum: 0x84259E10
	Offset: 0x2DA8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function temple_player_spawned(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	if(isdefined(self.var_1687ae46))
	{
		return;
	}
	self.var_1687ae46 = 1;
	if(localclientnum != 0)
	{
		return;
	}
	self thread disable_deadshot(localclientnum);
}

/*
	Name: temple_player_connect
	Namespace: zm_temple
	Checksum: 0x4A6C83B4
	Offset: 0x2E20
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function temple_player_connect(i_local_client_num)
{
	setsaveddvar("phys_buoyancy", 1);
	level thread _init_pap_indicators();
	thread floating_boards_init();
}

/*
	Name: init_level_specific_wall_buy_fx
	Namespace: zm_temple
	Checksum: 0x9A8E1205
	Offset: 0x2E80
	Size: 0x152
	Parameters: 0
	Flags: Linked
*/
function init_level_specific_wall_buy_fx()
{
	level._effect["sticky_grenade_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_pistol";
	level._effect["frag_grenade_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_pistol";
	level._effect["pdw57_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["870mcs_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["ak74u_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["beretta93r_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_pistol";
	level._effect["bowie_knife_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["claymore_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["m14_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["m16_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["mp5k_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["rottweil72_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
}

/*
	Name: include_weapons
	Namespace: zm_temple
	Checksum: 0xF0CF972D
	Offset: 0x2FE0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_temple_weapons.csv", 1);
}

/*
	Name: _init_magic_box
	Namespace: zm_temple
	Checksum: 0x9378F69E
	Offset: 0x3010
	Size: 0xB4
	Parameters: 0
	Flags: None
*/
function _init_magic_box()
{
	level._custom_box_monitor = &temple_box_monitor;
	level._box_locations = array("waterfall_upper_chest", "blender_chest", "pressure_chest", "bridge_chest", "caves_water_chest", "power_chest", "caves1_chest", "caves2_chest", "caves3_chest");
	callback::on_localclient_connect(&_init_indicators);
	level.cachedinfo = [];
	level.initialized = [];
}

/*
	Name: _init_indicators
	Namespace: zm_temple
	Checksum: 0xCAA523BD
	Offset: 0x30D0
	Size: 0x15E
	Parameters: 1
	Flags: Linked
*/
function _init_indicators(clientnum)
{
	structs = struct::get_array("magic_box_indicator", "targetname");
	for(i = 0; i < structs.size; i++)
	{
		s = structs[i];
		if(!isdefined(s.viewmodels))
		{
			s.viewmodels = [];
		}
		s.viewmodels[clientnum] = undefined;
	}
	level.initialized[clientnum] = 1;
	keys = getarraykeys(level.cachedinfo);
	for(i = 0; i < keys.size; i++)
	{
		key = keys[i];
		state = level.cachedinfo[key];
		temple_box_monitor(i, state, "");
	}
}

/*
	Name: temple_box_monitor
	Namespace: zm_temple
	Checksum: 0xD035772C
	Offset: 0x3238
	Size: 0xD6
	Parameters: 3
	Flags: Linked
*/
function temple_box_monitor(clientnum, state, oldstate)
{
	if(!isdefined(level.initialized[clientnum]))
	{
		level.cachedinfo[clientnum] = state;
		return;
	}
	switch(state)
	{
		case "fire_sale":
		{
			_all_locations(clientnum);
			break;
		}
		case "moving":
		{
			level thread _random_location(clientnum);
			break;
		}
		default:
		{
			level notify("location_set" + clientnum);
			_setup_location(clientnum, state);
			break;
		}
	}
}

/*
	Name: _delete_location
	Namespace: zm_temple
	Checksum: 0x18D4DB40
	Offset: 0x3318
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function _delete_location(clientnum, location)
{
	structs = struct::get_array(location, "script_noteworthy");
	array::thread_all(structs, &_setup_view_model, clientnum, undefined);
}

/*
	Name: _delete_all_locations
	Namespace: zm_temple
	Checksum: 0x823894BF
	Offset: 0x3388
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function _delete_all_locations(clientnum)
{
	for(i = 0; i < level._box_locations.size; i++)
	{
		location = level._box_locations[i];
		_delete_location(clientnum, location);
	}
}

/*
	Name: _show_location
	Namespace: zm_temple
	Checksum: 0xC9175078
	Offset: 0x3400
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function _show_location(clientnum, location)
{
	structs = struct::get_array(location, "script_noteworthy");
	array::thread_all(structs, &_setup_view_model, clientnum, "zt_map_knife");
}

/*
	Name: _setup_location
	Namespace: zm_temple
	Checksum: 0x1BE4A054
	Offset: 0x3478
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function _setup_location(clientnum, location)
{
	_delete_all_locations(clientnum);
	_show_location(clientnum, location);
}

/*
	Name: _setup_view_model
	Namespace: zm_temple
	Checksum: 0x9A13C482
	Offset: 0x34C8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function _setup_view_model(clientnum, viewmodel)
{
	if(isdefined(self.viewmodels[clientnum]))
	{
		self.viewmodels[clientnum] delete();
		self.viewmodels[clientnum] = undefined;
	}
	if(isdefined(viewmodel))
	{
		self.viewmodels[clientnum] = spawn(clientnum, self.origin, "script_model");
		self.viewmodels[clientnum].angles = self.angles;
		self.viewmodels[clientnum] setmodel(viewmodel);
	}
}

/*
	Name: _random_location
	Namespace: zm_temple
	Checksum: 0x40261E40
	Offset: 0x35A8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function _random_location(clientnum)
{
	level endon("location_set" + clientnum);
	index = 0;
	while(true)
	{
		location = level._box_locations[index];
		_setup_location(clientnum, location);
		index++;
		if(index >= level._box_locations.size)
		{
			index = 0;
		}
		wait(0.25);
	}
}

/*
	Name: _all_locations
	Namespace: zm_temple
	Checksum: 0x64276A61
	Offset: 0x3650
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function _all_locations(clientnum)
{
	for(i = 0; i < level._box_locations.size; i++)
	{
		location = level._box_locations[i];
		_show_location(clientnum, location);
	}
}

/*
	Name: _init_pap_indicators
	Namespace: zm_temple
	Checksum: 0x3773A9BD
	Offset: 0x36C8
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function _init_pap_indicators()
{
	local_players = getlocalplayers();
	for(index = 0; index < local_players.size; index++)
	{
		val = clientfield::get("papspinners");
		level _set_num_visible_spinners(index, level.var_e34b793e);
	}
}

/*
	Name: function_9fe44296
	Namespace: zm_temple
	Checksum: 0xE40B666B
	Offset: 0x3768
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_9fe44296(clientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level.var_e34b793e = newval;
	getlocalplayers()[clientnum] _set_num_visible_spinners(clientnum, level.var_e34b793e);
}

/*
	Name: power
	Namespace: zm_temple
	Checksum: 0x42774A11
	Offset: 0x37F0
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function power(base, exp)
{
	/#
		assert(exp >= 0);
	#/
	if(exp == 0)
	{
		return 1;
	}
	return base * (power(base, exp - 1));
}

/*
	Name: _set_num_visible_spinners
	Namespace: zm_temple
	Checksum: 0x6A849CA1
	Offset: 0x3868
	Size: 0x2B6
	Parameters: 2
	Flags: Linked
*/
function _set_num_visible_spinners(clientnum, num)
{
	/#
		println((("" + clientnum) + "") + num);
	#/
	if(!isdefined(level.spinners))
	{
		level _init_pap_spinners(clientnum);
	}
	else if(!isdefined(level.spinners[clientnum]))
	{
		level _init_pap_spinners(clientnum);
	}
	for(i = 3; i >= 0; i--)
	{
		/#
			println((("" + i) + "") + clientnum);
		#/
		/#
			assert(isdefined(level.spinners));
		#/
		/#
			assert(isdefined(level.spinners[clientnum]));
		#/
		/#
			assert(isdefined(level.spinners[clientnum][i]));
		#/
		pow = power(2, i);
		if(num >= pow)
		{
			num = num - pow;
			/#
				println((((("" + clientnum) + "") + i) + "") + level.spinners[clientnum][i].size);
			#/
			array::thread_all(level.spinners[clientnum][i], &spin_to_start);
			continue;
		}
		/#
			println((((("" + clientnum) + "") + i) + "") + level.spinners[clientnum][i].size);
		#/
		array::thread_all(level.spinners[clientnum][i], &spin_forever);
	}
}

/*
	Name: spike_trap_move_spikes
	Namespace: zm_temple
	Checksum: 0xA0F8291F
	Offset: 0x3B28
	Size: 0xE6
	Parameters: 2
	Flags: Linked
*/
function spike_trap_move_spikes(localclientnum, active)
{
	if(!isdefined(self.spears))
	{
		self set_trap_spears(localclientnum);
	}
	spears = self.spears;
	if(isdefined(spears))
	{
		for(i = 0; i < spears.size; i++)
		{
			playsound = i == 0;
			spears[i] thread spear_init(localclientnum);
			spears[i] thread spear_move(localclientnum, active, playsound);
		}
	}
}

/*
	Name: set_trap_spears
	Namespace: zm_temple
	Checksum: 0x4953E3BE
	Offset: 0x3C18
	Size: 0x150
	Parameters: 1
	Flags: Linked
*/
function set_trap_spears(localclientnum)
{
	allspears = getentarray(localclientnum, "spear_trap_spear", "targetname");
	self.spears = [];
	for(i = 0; i < allspears.size; i++)
	{
		spear = allspears[i];
		if(isdefined(spear.assigned) && spear.assigned)
		{
			continue;
		}
		delta = abs(self.origin[0] - spear.origin[0]);
		if((abs(self.origin[0] - spear.origin[0])) < 21)
		{
			spear.assigned = 1;
			self.spears[self.spears.size] = spear;
		}
	}
}

/*
	Name: spear_init
	Namespace: zm_temple
	Checksum: 0xEA4E7C42
	Offset: 0x3D70
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function spear_init(localclientnum)
{
	if(!isdefined(self.init) || !self.init)
	{
		self.movedistmin = 90;
		self.movedistmax = 120;
		self.start = self.origin;
		self.movedir = -1 * anglestoright(self.angles);
		self.init = 1;
	}
}

/*
	Name: spear_move
	Namespace: zm_temple
	Checksum: 0x6B491DA0
	Offset: 0x3DF8
	Size: 0x1BC
	Parameters: 3
	Flags: Linked
*/
function spear_move(localclientnum, active, playsound)
{
	if(active)
	{
		if(playsound)
		{
			sound::play_in_space(0, "evt_spiketrap_warn", self.origin);
		}
		movedist = randomfloatrange(self.movedistmin, self.movedistmax);
		endpos = self.start + (self.movedir * movedist);
		playfx(localclientnum, level._effect["punji_dust"], endpos);
		playsound(0, "evt_spiketrap", self.origin);
		movetime = randomfloatrange(0.08, 0.22);
		self moveto(endpos, movetime);
	}
	else
	{
		if(playsound)
		{
			playsound(0, "evt_spiketrap_retract", self.origin);
		}
		movetime = randomfloatrange(0.1, 0.2);
		self moveto(self.start, movetime);
	}
}

/*
	Name: floating_boards_init
	Namespace: zm_temple
	Checksum: 0xF709C5B6
	Offset: 0x3FC0
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function floating_boards_init()
{
	boards = [];
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		boards = arraycombine(boards, getentarray(i, "plank_water", "targetname"), 1, 0);
	}
	array::thread_all(boards, &float_board);
}

/*
	Name: float_board
	Namespace: zm_temple
	Checksum: 0x8E3D1EA9
	Offset: 0x4088
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function float_board()
{
	wait(randomfloat(1));
	self.start_origin = self.origin;
	self.start_angles = self.angles;
	self.moment_move = self.origin;
	self thread board_bob();
	self thread board_rotate();
}

/*
	Name: board_bob
	Namespace: zm_temple
	Checksum: 0xD75907C5
	Offset: 0x4110
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function board_bob()
{
	dist = randomfloatrange(2.5, 3);
	movetime = randomfloatrange(3.5, 4.5);
	minz = self.start_origin[2] - dist;
	maxz = self.start_origin[2] + dist;
	while(true)
	{
		toz = minz - self.origin[2];
		self movez(toz, movetime);
		self waittill(#"movedone");
		toz = maxz - self.origin[2];
		self movez(toz, movetime);
		self waittill(#"movedone");
	}
}

/*
	Name: board_rotate
	Namespace: zm_temple
	Checksum: 0xAFE5CDFC
	Offset: 0x4250
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function board_rotate()
{
	while(true)
	{
		yaw = randomfloatrange(-360, 360);
		self rotateyaw(yaw, randomfloatrange(60, 90));
		self waittill(#"rotatedone");
	}
}

/*
	Name: board_move
	Namespace: zm_temple
	Checksum: 0xAA01B0AC
	Offset: 0x42E0
	Size: 0x168
	Parameters: 0
	Flags: None
*/
function board_move()
{
	dist = randomfloatrange(20, 30);
	movetime = randomfloatrange(5, 10);
	while(true)
	{
		yaw = randomfloatrange(0, 360);
		tovector = anglestoforward((0, yaw, 0));
		newloc = self.start_origin + (tovector * dist);
		tox = newloc[0] - self.origin[0];
		self movex(tox, movetime);
		toy = newloc[1] - self.origin[1];
		self movey(toy, movetime);
	}
}

/*
	Name: _init_pap_spinners
	Namespace: zm_temple
	Checksum: 0xF3F1697A
	Offset: 0x4450
	Size: 0x186
	Parameters: 1
	Flags: Linked
*/
function _init_pap_spinners(cnum)
{
	if(!isdefined(level.spinners))
	{
		level.spinners = [];
	}
	if(level.spinners.size <= cnum)
	{
		level.spinners[level.spinners.size] = array([], [], [], []);
	}
	/#
		println(("" + cnum) + "");
	#/
	for(i = 0; i < level.spinners[cnum].size; i++)
	{
		spinners = getentarray(cnum, "pap_spinner" + (i + 1), "targetname");
		/#
			println((((("" + cnum) + "") + i) + "") + spinners.size);
		#/
		array::thread_all(spinners, &init_spinner, i + 1);
		level.spinners[cnum][i] = spinners;
	}
}

/*
	Name: init_spinner
	Namespace: zm_temple
	Checksum: 0x2EDEB659
	Offset: 0x45E0
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function init_spinner(listnum)
{
	self.spinner = listnum;
	self.startangles = self.angles;
	self.spin_sound = "evt_pap_spinner0" + listnum;
	self.spin_stop_sound = "evt_pap_timer_stop";
	self.angles = (0, (90 * (listnum - 1)) + randomfloatrange(10, 80), 0);
}

/*
	Name: spin_forever
	Namespace: zm_temple
	Checksum: 0x997DE786
	Offset: 0x4670
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function spin_forever()
{
	if(!level.power)
	{
		return;
	}
	if(isdefined(self.spin_forever) && self.spin_forever)
	{
		return;
	}
	self.spin_forever = 1;
	self.spin_to_start = 0;
	self notify(#"stop_spinning");
	self endon(#"death");
	self endon(#"stop_spinning");
	spintime = self spinner_get_spin_time();
	self start_spinner_sound();
	self rotateyaw(360, spintime, 0.25);
	self waittill(#"rotatedone");
	while(true)
	{
		self rotateyaw(360, spintime);
		self waittill(#"rotatedone");
	}
}

/*
	Name: spinner_get_spin_time
	Namespace: zm_temple
	Checksum: 0x3FAE0767
	Offset: 0x4780
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function spinner_get_spin_time()
{
	spintime = 1.7;
	if(self.spinner == 2)
	{
		spintime = 1.5;
	}
	else
	{
		if(self.spinner == 3)
		{
			spintime = 1.2;
		}
		else if(self.spinner == 4)
		{
			spintime = 0.8;
		}
	}
	return spintime;
}

/*
	Name: spin_to_start
	Namespace: zm_temple
	Checksum: 0x38B2207F
	Offset: 0x4800
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function spin_to_start()
{
	if(!level.power)
	{
		return;
	}
	if(isdefined(self.spin_to_start) && self.spin_to_start)
	{
		return;
	}
	self.spin_forever = 0;
	self.spin_to_start = 1;
	self notify(#"stop_spinning");
	self endon(#"death");
	self endon(#"stop_spinning");
	endyaw = self.startangles[1];
	currentyaw = self.angles[1];
	deltayaw = endyaw - currentyaw;
	while(deltayaw < 0)
	{
		deltayaw = deltayaw + 360;
	}
	spintime = self spinner_get_spin_time();
	spintime = spintime * (deltayaw / 360);
	if(spintime > 0)
	{
		self rotateyaw(deltayaw, spintime, 0);
		self waittill(#"rotatedone");
	}
	self stop_spinner_sound();
	self.angles = self.startangles;
}

/*
	Name: start_spinner_sound
	Namespace: zm_temple
	Checksum: 0x39EB210F
	Offset: 0x4978
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function start_spinner_sound()
{
	self.var_3539b4ec = self playloopsound(self.spin_sound);
}

/*
	Name: stop_spinner_sound
	Namespace: zm_temple
	Checksum: 0xC60F5D95
	Offset: 0x49B0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function stop_spinner_sound()
{
	if(isdefined(self.var_3539b4ec))
	{
		self stoploopsound(self.var_3539b4ec, 0.1);
	}
	self playsound(0, self.spin_stop_sound);
}

/*
	Name: temple_light_model_swap_init
	Namespace: zm_temple
	Checksum: 0x48CF36BD
	Offset: 0x4A10
	Size: 0x1B8
	Parameters: 0
	Flags: Linked
*/
function temple_light_model_swap_init()
{
	if(!level clientfield::get("zombie_power_on"))
	{
		level waittill(#"zpo");
	}
	wait(4.5);
	level notify(#"pl1");
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		light_models = getentarray(i, "model_lights_on", "targetname");
		for(x = 0; x < light_models.size; x++)
		{
			light = light_models[x];
			if(isdefined(light.script_string))
			{
				light setmodel(light.script_string);
				continue;
			}
			if(light.model == "p_ztem_power_hanging_light_off")
			{
				light setmodel("p_ztem_power_hanging_light");
				continue;
			}
			if(light.model == "p_lights_cagelight02_off")
			{
				light setmodel("p_lights_cagelight02_on");
			}
		}
	}
}

/*
	Name: ragdoll_impact_watch_start
	Namespace: zm_temple
	Checksum: 0xD7593AC4
	Offset: 0x4BD0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function ragdoll_impact_watch_start(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self thread ragdoll_impact_watch(localclientnum);
	}
}

/*
	Name: ragdoll_impact_watch
	Namespace: zm_temple
	Checksum: 0x659FD91E
	Offset: 0x4C38
	Size: 0x1C6
	Parameters: 1
	Flags: Linked
*/
function ragdoll_impact_watch(localclientnum)
{
	self endon(#"entityshutdown");
	waittime = 0.016;
	gibspeed = 500;
	prevorigin = self.origin;
	waitrealtime(waittime);
	prevvel = self.origin - prevorigin;
	prevspeed = length(prevvel);
	prevorigin = self.origin;
	waitrealtime(waittime);
	firstloop = 1;
	while(true)
	{
		vel = self.origin - prevorigin;
		speed = length(vel);
		if(speed < (prevspeed * 0.5) && prevspeed > (gibspeed * waittime))
		{
			dir = vectornormalize(prevvel);
			self gib_ragdoll(localclientnum, dir);
			break;
		}
		if(prevspeed < (gibspeed * waittime) && !firstloop)
		{
			break;
		}
		prevorigin = self.origin;
		prevvel = vel;
		prevspeed = speed;
		firstloop = 0;
		waitrealtime(waittime);
	}
}

/*
	Name: gib_ragdoll
	Namespace: zm_temple
	Checksum: 0x124C3F6E
	Offset: 0x4E08
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function gib_ragdoll(localclientnum, hitdir)
{
	if(util::is_mature())
	{
		playfx(localclientnum, level._effect["rag_doll_gib_mini"], self.origin, hitdir * -1);
	}
}

/*
	Name: maze_floor_controller_rumble
	Namespace: zm_temple
	Checksum: 0x71AC668E
	Offset: 0x4E78
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function maze_floor_controller_rumble(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	player = getlocalplayers()[localclientnum];
	if(player getentitynumber() != self getentitynumber())
	{
		return;
	}
	if(newval)
	{
		self thread maze_rumble_while_floor_shakes(localclientnum);
	}
	else
	{
		self notify(#"stop_maze_rumble");
		self stoprumble(localclientnum, "slide_rumble");
	}
}

/*
	Name: maze_rumble_while_floor_shakes
	Namespace: zm_temple
	Checksum: 0x36E38C48
	Offset: 0x4F68
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function maze_rumble_while_floor_shakes(int_client_num)
{
	self endon(#"stop_maze_rumble");
	while(isdefined(self))
	{
		self playrumbleonentity(int_client_num, "slide_rumble");
		wait(0.05);
	}
}

/*
	Name: function_425904c0
	Namespace: zm_temple
	Checksum: 0x2C7038A1
	Offset: 0x4FB8
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function function_425904c0(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		player = getlocalplayer(localclientnum);
		if(self == player)
		{
			self playrumblelooponentity(localclientnum, "tank_rumble");
		}
	}
	else
	{
		player = getlocalplayer(localclientnum);
		if(self == player)
		{
			self stoprumble(localclientnum, "tank_rumble");
		}
	}
}

