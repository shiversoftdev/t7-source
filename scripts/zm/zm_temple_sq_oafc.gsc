// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_temple_sq;
#using scripts\zm\zm_temple_sq_brock;
#using scripts\zm\zm_temple_sq_skits;

#namespace zm_temple_sq_oafc;

/*
	Name: init
	Namespace: zm_temple_sq_oafc
	Checksum: 0x5DAFF6E
	Offset: 0x4E8
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function init()
{
	zm_sidequests::declare_sidequest_stage("sq", "OaFC", &init_stage, &stage_logic, &exit_stage);
	zm_sidequests::set_stage_time_limit("sq", "OaFC", 300);
	zm_sidequests::declare_stage_asset_from_struct("sq", "OaFC", "sq_oafc_switch", &oafc_switch);
	zm_sidequests::declare_stage_asset_from_struct("sq", "OaFC", "sq_oafc_tileset1", &function_34a397d8, &zm_sidequests::radius_trigger_thread);
	zm_sidequests::declare_stage_asset_from_struct("sq", "OaFC", "sq_oafc_tileset2", &function_a6ab0713, &zm_sidequests::radius_trigger_thread);
	level flag::init("oafc_switch_pressed");
	level flag::init("oafc_plot_vo_done");
}

/*
	Name: stage_logic
	Namespace: zm_temple_sq_oafc
	Checksum: 0x46CD9B37
	Offset: 0x678
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function stage_logic()
{
	/#
		level flag::wait_till("");
		if(getplayers().size == 1)
		{
			wait(20);
			level notify(#"raise_crystal_1", 1);
			level waittill(#"hash_64e9e78e");
			wait(5);
			iprintlnbold("");
			zm_sidequests::stage_completed("", "");
			return;
		}
	#/
}

/*
	Name: oafc_switch
	Namespace: zm_temple_sq_oafc
	Checksum: 0x1347CD25
	Offset: 0x728
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function oafc_switch()
{
	level endon(#"sq_oafc_over");
	level thread knocking_audio();
	self.on_pos = self.origin;
	self.off_pos = self.on_pos - (anglestoup(self.angles) * 5.5);
	self.trigger triggerignoreteam();
	self waittill(#"triggered", who);
	if(isdefined(who))
	{
		level._player_who_pressed_the_switch = who;
	}
	self playsound("evt_sq_gen_button");
	self moveto(self.off_pos, 0.25);
	self waittill(#"movedone");
	level flag::set("oafc_switch_pressed");
	level thread oafc_story_vox();
}

/*
	Name: knocking_audio
	Namespace: zm_temple_sq_oafc
	Checksum: 0x7115CB3A
	Offset: 0x870
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function knocking_audio()
{
	level endon(#"sq_oafc_over");
	struct = struct::get("sq_location_oafc", "targetname");
	if(!isdefined(struct))
	{
		return;
	}
	while(!level flag::get("oafc_switch_pressed"))
	{
		playsoundatposition("evt_sq_oafc_knock", struct.origin);
		wait(randomfloatrange(1.5, 4));
	}
}

/*
	Name: function_34a397d8
	Namespace: zm_temple_sq_oafc
	Checksum: 0x1010D11
	Offset: 0x928
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function function_34a397d8()
{
	self.set = 1;
	self.original_origin = self.origin;
}

/*
	Name: function_a6ab0713
	Namespace: zm_temple_sq_oafc
	Checksum: 0x78682D73
	Offset: 0x950
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function function_a6ab0713()
{
	self.set = 2;
	self.original_origin = self.origin;
}

/*
	Name: tile_cheat
	Namespace: zm_temple_sq_oafc
	Checksum: 0xCB70CDA8
	Offset: 0x978
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function tile_cheat()
{
	/#
		level endon(#"reset_tiles");
		level endon(#"sq_oafc_over");
		while(isdefined(self.matched) && !self.matched)
		{
			print3d(self.origin, self.tile, vectorscale((0, 1, 0), 255));
			wait(0.1);
		}
	#/
}

/*
	Name: tile_debug
	Namespace: zm_temple_sq_oafc
	Checksum: 0x9B45C8D8
	Offset: 0x9F0
	Size: 0x7C0
	Parameters: 0
	Flags: Linked
*/
function tile_debug()
{
	/#
		level endon(#"sq_oafc_over");
		if(!isdefined(level._debug_tiles))
		{
			level._debug_tiles = 1;
			level.var_e38ebc06 = newdebughudelem();
			level.var_e38ebc06.location = 0;
			level.var_e38ebc06.alignx = "";
			level.var_e38ebc06.aligny = "";
			level.var_e38ebc06.foreground = 1;
			level.var_e38ebc06.fontscale = 1.3;
			level.var_e38ebc06.sort = 20;
			level.var_e38ebc06.x = 10;
			level.var_e38ebc06.y = 240;
			level.var_e38ebc06.og_scale = 1;
			level.var_e38ebc06.color = vectorscale((1, 1, 1), 255);
			level.var_e38ebc06.alpha = 1;
			level.var_1fee3600 = newdebughudelem();
			level.var_1fee3600.location = 0;
			level.var_1fee3600.alignx = "";
			level.var_1fee3600.aligny = "";
			level.var_1fee3600.foreground = 1;
			level.var_1fee3600.fontscale = 1.3;
			level.var_1fee3600.sort = 20;
			level.var_1fee3600.x = 0;
			level.var_1fee3600.y = 240;
			level.var_1fee3600.og_scale = 1;
			level.var_1fee3600.color = vectorscale((1, 1, 1), 255);
			level.var_1fee3600.alpha = 1;
			level.var_1fee3600 settext("");
			level.var_bd8c419d = newdebughudelem();
			level.var_bd8c419d.location = 0;
			level.var_bd8c419d.alignx = "";
			level.var_bd8c419d.aligny = "";
			level.var_bd8c419d.foreground = 1;
			level.var_bd8c419d.fontscale = 1.3;
			level.var_bd8c419d.sort = 20;
			level.var_bd8c419d.x = 10;
			level.var_bd8c419d.y = 270;
			level.var_bd8c419d.og_scale = 1;
			level.var_bd8c419d.color = vectorscale((1, 1, 1), 255);
			level.var_bd8c419d.alpha = 1;
			level.var_1780e445 = newdebughudelem();
			level.var_1780e445.location = 0;
			level.var_1780e445.alignx = "";
			level.var_1780e445.aligny = "";
			level.var_1780e445.foreground = 1;
			level.var_1780e445.fontscale = 1.3;
			level.var_1780e445.sort = 20;
			level.var_1780e445.x = 0;
			level.var_1780e445.y = 270;
			level.var_1780e445.og_scale = 1;
			level.var_1780e445.color = vectorscale((1, 1, 1), 255);
			level.var_1780e445.alpha = 1;
			level.var_1780e445 settext("");
			level.num_matched = newdebughudelem();
			level.num_matched.location = 0;
			level.num_matched.alignx = "";
			level.num_matched.aligny = "";
			level.num_matched.foreground = 1;
			level.num_matched.fontscale = 1.3;
			level.num_matched.sort = 20;
			level.num_matched.x = 10;
			level.num_matched.y = 300;
			level.num_matched.og_scale = 1;
			level.num_matched.color = vectorscale((1, 1, 1), 255);
			level.num_matched.alpha = 1;
			level.num_matched_text = newdebughudelem();
			level.num_matched_text.location = 0;
			level.num_matched_text.alignx = "";
			level.num_matched_text.aligny = "";
			level.num_matched_text.foreground = 1;
			level.num_matched_text.fontscale = 1.3;
			level.num_matched_text.sort = 20;
			level.num_matched_text.x = 0;
			level.num_matched_text.y = 300;
			level.num_matched_text.og_scale = 1;
			level.num_matched_text.color = vectorscale((1, 1, 1), 255);
			level.num_matched_text.alpha = 1;
			level.num_matched_text settext("");
		}
		while(true)
		{
			if(isdefined(level.var_66c77de0))
			{
				level.var_e38ebc06 settext(level.var_66c77de0.tile);
			}
			else
			{
				level.var_e38ebc06 settext("");
			}
			if(isdefined(level.var_d8ceed1b))
			{
				level.var_bd8c419d settext(level.var_d8ceed1b.tile);
			}
			else
			{
				level.var_bd8c419d settext("");
			}
			if(isdefined(level._num_matched_tiles))
			{
				level.num_matched settext(level._num_matched_tiles);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: tile_monitor
	Namespace: zm_temple_sq_oafc
	Checksum: 0x86A88A22
	Offset: 0x11B8
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function tile_monitor()
{
	level endon(#"sq_oafc_over");
	self endon(#"tiles_picked");
	level endon(#"reset_tiles");
	self.origin = self.original_origin;
	/#
		self thread tile_cheat();
	#/
}

/*
	Name: init_stage
	Namespace: zm_temple_sq_oafc
	Checksum: 0xC4BAB787
	Offset: 0x1218
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function init_stage()
{
	/#
		level thread tile_debug();
	#/
	level flag::clear("oafc_switch_pressed");
	level flag::clear("oafc_plot_vo_done");
	reset_tiles();
	zm_temple_sq_brock::delete_radio();
	level thread delayed_start_skit();
}

/*
	Name: delayed_start_skit
	Namespace: zm_temple_sq_oafc
	Checksum: 0xAA203D4C
	Offset: 0x12B8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function delayed_start_skit()
{
	wait(0.5);
	level thread zm_temple_sq_skits::start_skit("tt1");
}

/*
	Name: tile_moves_up
	Namespace: zm_temple_sq_oafc
	Checksum: 0x3A581C66
	Offset: 0x12F0
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function tile_moves_up(delay)
{
	level endon(#"sq_oafc_over");
	level flag::wait_till("oafc_switch_pressed");
	for(i = 0; i < delay; i++)
	{
		util::wait_network_frame();
	}
	self moveto(self.original_origin, 0.25);
}

/*
	Name: set_tile_models
	Namespace: zm_temple_sq_oafc
	Checksum: 0xAC4E7C54
	Offset: 0x1390
	Size: 0xFE
	Parameters: 2
	Flags: Linked
*/
function set_tile_models(tiles, models)
{
	for(i = 0; i < tiles.size; i++)
	{
		tiles[i] setmodel("p7_zm_sha_glyph_stone_blank");
		tiles[i].tile = models[i];
		tiles[i].matched = 0;
		tiles[i].origin = tiles[i].original_origin - vectorscale((0, 0, 1), 24);
		tiles[i] thread tile_moves_up(i % 4);
	}
}

/*
	Name: player_in_trigger
	Namespace: zm_temple_sq_oafc
	Checksum: 0xE4E3CF9D
	Offset: 0x1498
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function player_in_trigger()
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i].sessionstate != "spectator" && self istouching(players[i]))
		{
			return players[i];
		}
	}
	return undefined;
}

/*
	Name: function_1667d8eb
	Namespace: zm_temple_sq_oafc
	Checksum: 0x5690E6C5
	Offset: 0x1538
	Size: 0x1D0
	Parameters: 1
	Flags: Linked
*/
function function_1667d8eb(tile)
{
	level endon(#"hash_2687e434");
	var_b7081a33 = [];
	if(tile.targetname == "sq_oafc_tileset1")
	{
		var_b7081a33 = getentarray("sq_oafc_tileset2", "targetname");
		level notify(#"hash_e177c495");
		level endon(#"hash_e177c495");
	}
	else
	{
		var_b7081a33 = getentarray("sq_oafc_tileset1", "targetname");
		level notify(#"hash_77a3efe");
		level endon(#"hash_77a3efe");
	}
	var_ad717133 = undefined;
	foreach(var_8bf17d58 in var_b7081a33)
	{
		if(tile.tile == var_8bf17d58.tile)
		{
			var_ad717133 = var_8bf17d58;
		}
	}
	while(isdefined(var_ad717133))
	{
		/#
			print3d(var_ad717133.origin + vectorscale((0, 0, 1), 32), "", vectorscale((1, 0, 0), 255), 1);
		#/
		util::wait_network_frame();
	}
}

/*
	Name: oafc_trigger_thread
	Namespace: zm_temple_sq_oafc
	Checksum: 0x233CB61
	Offset: 0x1710
	Size: 0x84C
	Parameters: 2
	Flags: Linked
*/
function oafc_trigger_thread(tiles, set)
{
	self endon(#"death");
	level endon(#"reset_tiles");
	self triggerenable(0);
	level flag::wait_till("oafc_switch_pressed");
	self triggerenable(1);
	while(true)
	{
		for(i = 0; i < tiles.size; i++)
		{
			tile = tiles[i];
			if(isdefined(tile) && !tile.matched)
			{
				self.origin = tiles[i].origin;
				touched_player = self player_in_trigger();
				if(isdefined(touched_player))
				{
					/#
						if(set == 1)
						{
							println("" + i);
						}
					#/
					tile setmodel(tile.tile);
					tile playsound("evt_sq_oafc_glyph_activate");
					/#
						level thread function_1667d8eb(tile);
					#/
					matched = 0;
					if(set == 1)
					{
						level.var_66c77de0 = tile;
					}
					else
					{
						level.var_d8ceed1b = tile;
					}
					while(isdefined(touched_player) && self istouching(touched_player) && touched_player.sessionstate != "spectator" && !tile.matched)
					{
						self.touched_player = touched_player;
						if(set == 1)
						{
							if(isdefined(level.var_66c77de0) && isdefined(level.var_d8ceed1b))
							{
								if(level.var_66c77de0.tile == level.var_d8ceed1b.tile)
								{
									level.var_66c77de0 playsound("evt_sq_oafc_glyph_correct");
									level.var_d8ceed1b playsound("evt_sq_oafc_glyph_correct");
									/#
										level notify(#"hash_2687e434");
									#/
									matched = 1;
									level.var_66c77de0.matched = 1;
									level.var_d8ceed1b.matched = 1;
									level.var_66c77de0 moveto(level.var_66c77de0.origin - vectorscale((0, 0, 1), 24), 0.5);
									level.var_d8ceed1b moveto(level.var_d8ceed1b.origin - vectorscale((0, 0, 1), 24), 0.5);
									level.var_66c77de0 waittill(#"movedone");
									level.var_66c77de0 = undefined;
									level.var_d8ceed1b = undefined;
									level._num_matched_tiles++;
									if(level._num_matched_tiles < level._num_tiles_to_match)
									{
										rand = randomintrange(0, 2);
										if(isdefined(touched_player) && rand == 0)
										{
											touched_player thread zm_audio::create_and_play_dialog("eggs", "quest1", randomintrange(5, 8));
										}
										else if(isdefined(level.var_ca8e74be.touched_player))
										{
											level.var_ca8e74be.touched_player thread zm_audio::create_and_play_dialog("eggs", "quest1", randomintrange(5, 8));
										}
									}
									if(level._num_matched_tiles == level._num_tiles_to_match)
									{
										/#
											println("");
										#/
										struct = struct::get("sq_location_oafc", "targetname");
										if(isdefined(struct))
										{
											playsoundatposition("evt_sq_oafc_glyph_complete", struct.origin);
											playsoundatposition("evt_sq_oafc_kachunk", struct.origin);
										}
										level notify(#"suspend_timer");
										level notify(#"raise_crystal_1", 1);
										level waittill(#"hash_64e9e78e");
										level flag::wait_till("oafc_plot_vo_done");
										wait(5);
										zm_sidequests::stage_completed("sq", "OaFC");
										return;
									}
									/#
										println("");
									#/
									break;
								}
								else
								{
									level.var_66c77de0 playsound("evt_sq_oafc_glyph_wrong");
									level.var_d8ceed1b playsound("evt_sq_oafc_glyph_wrong");
									rand = randomintrange(0, 2);
									if(isdefined(touched_player) && rand == 0)
									{
										touched_player thread zm_audio::create_and_play_dialog("eggs", "quest1", randomintrange(2, 5));
									}
									else if(isdefined(level.var_ca8e74be.touched_player))
									{
										level.var_ca8e74be.touched_player thread zm_audio::create_and_play_dialog("eggs", "quest1", randomintrange(2, 5));
									}
									while(isdefined(touched_player) && self istouching(touched_player) && isdefined(level.var_d8ceed1b))
									{
										wait(0.05);
									}
									/#
										println("");
									#/
									level thread reset_tiles();
									break;
								}
							}
						}
						wait(0.05);
					}
					tile playsound("evt_sq_oafc_glyph_clear");
					if(set == 1)
					{
						level.var_66c77de0 = undefined;
					}
					else
					{
						level.var_d8ceed1b = undefined;
					}
					tile setmodel("p7_zm_sha_glyph_stone_blank");
				}
			}
		}
		wait(0.05);
	}
	/#
		if(set == 1)
		{
			println("");
		}
	#/
}

/*
	Name: reset_tiles
	Namespace: zm_temple_sq_oafc
	Checksum: 0xB1227B31
	Offset: 0x1F68
	Size: 0x26C
	Parameters: 0
	Flags: Linked
*/
function reset_tiles()
{
	tile_models = array("p7_zm_sha_glyph_stone_01", "p7_zm_sha_glyph_stone_02", "p7_zm_sha_glyph_stone_03", "p7_zm_sha_glyph_stone_04", "p7_zm_sha_glyph_stone_05", "p7_zm_sha_glyph_stone_06", "p7_zm_sha_glyph_stone_07", "p7_zm_sha_glyph_stone_08", "p7_zm_sha_glyph_stone_09", "p7_zm_sha_glyph_stone_10", "p7_zm_sha_glyph_stone_11", "p7_zm_sha_glyph_stone_12");
	level notify(#"reset_tiles");
	if(!isdefined(level.var_a48bfa55))
	{
		level.var_a48bfa55 = spawn("trigger_radius", (0, 0, 0), 0, 22, 72);
		level.var_ca8e74be = spawn("trigger_radius", (0, 0, 0), 0, 22, 72);
		level.var_a48bfa55 thread wait_for_first_stepon();
		level.var_ca8e74be thread wait_for_first_stepon();
	}
	level._num_matched_tiles = 0;
	level.var_66c77de0 = undefined;
	level.var_d8ceed1b = undefined;
	tile_models = array::randomize(tile_models);
	var_34a397d8 = getentarray("sq_oafc_tileset1", "targetname");
	level._num_tiles_to_match = var_34a397d8.size;
	set_tile_models(var_34a397d8, tile_models);
	level.var_a48bfa55 thread oafc_trigger_thread(var_34a397d8, 1);
	tile_models = array::randomize(tile_models);
	var_a6ab0713 = getentarray("sq_oafc_tileset2", "targetname");
	set_tile_models(var_a6ab0713, tile_models);
	level.var_ca8e74be thread oafc_trigger_thread(var_a6ab0713, 2);
}

/*
	Name: wait_for_first_stepon
	Namespace: zm_temple_sq_oafc
	Checksum: 0xF4B864DF
	Offset: 0x21E0
	Size: 0x9A
	Parameters: 0
	Flags: Linked
*/
function wait_for_first_stepon()
{
	self endon(#"death");
	level endon(#"hash_be6d0796");
	while(true)
	{
		self waittill(#"trigger", who);
		if(isdefined(who) && isplayer(who))
		{
			who thread zm_audio::create_and_play_dialog("eggs", "quest1", 1);
			break;
		}
	}
	level notify(#"hash_be6d0796");
}

/*
	Name: exit_stage
	Namespace: zm_temple_sq_oafc
	Checksum: 0x8B4CDB49
	Offset: 0x2288
	Size: 0x1B0
	Parameters: 1
	Flags: Linked
*/
function exit_stage(success)
{
	if(isdefined(level._debug_tiles))
	{
		level._debug_tiles = undefined;
		level.var_e38ebc06 destroy();
		level.var_e38ebc06 = undefined;
		level.var_1fee3600 destroy();
		level.var_1fee3600 = undefined;
		level.var_bd8c419d destroy();
		level.var_bd8c419d = undefined;
		level.var_1780e445 destroy();
		level.var_1780e445 = undefined;
		level.num_matched destroy();
		level.num_matched.location = undefined;
		level.num_matched_text destroy();
		level.num_matched_text = undefined;
	}
	if(success)
	{
		zm_temple_sq_brock::create_radio(2, &zm_temple_sq_brock::radio2_override);
	}
	else
	{
		zm_temple_sq_brock::create_radio(1);
		level thread zm_temple_sq_skits::fail_skit(1);
	}
	level.var_a48bfa55 delete();
	level.var_ca8e74be delete();
	if(isdefined(level._oafc_sound_ent))
	{
		level._oafc_sound_ent delete();
		level._oafc_sound_ent = undefined;
	}
	level.skit_vox_override = 0;
}

/*
	Name: oafc_story_vox
	Namespace: zm_temple_sq_oafc
	Checksum: 0x49C4E88A
	Offset: 0x2440
	Size: 0x366
	Parameters: 0
	Flags: Linked
*/
function oafc_story_vox()
{
	level endon(#"sq_oafc_over");
	struct = struct::get("sq_location_oafc", "targetname");
	if(!isdefined(struct))
	{
		return;
	}
	level._oafc_sound_ent = spawn("script_origin", struct.origin);
	level._oafc_sound_ent playsoundwithnotify("vox_egg_story_1_0", "sounddone");
	level._oafc_sound_ent waittill(#"sounddone");
	if(isdefined(level._player_who_pressed_the_switch))
	{
		who = level._player_who_pressed_the_switch;
		level.skit_vox_override = 1;
		who playsoundwithnotify("vox_egg_story_1_1" + zm_temple_sq::function_26186755(who.characterindex), "vox_egg_sounddone");
		who waittill(#"vox_egg_sounddone");
		level.skit_vox_override = 0;
	}
	level._oafc_sound_ent playsoundwithnotify("vox_egg_story_1_2", "sounddone");
	level._oafc_sound_ent waittill(#"sounddone");
	while(level._num_matched_tiles < 1)
	{
		wait(0.1);
	}
	level._oafc_sound_ent playsoundwithnotify("vox_egg_story_1_3", "sounddone");
	level._oafc_sound_ent waittill(#"sounddone");
	while(level._num_matched_tiles != level._num_tiles_to_match)
	{
		wait(0.1);
	}
	level._oafc_sound_ent playsoundwithnotify("vox_egg_story_1_4", "sounddone");
	level._oafc_sound_ent waittill(#"sounddone");
	if(isdefined(level._player_who_pressed_the_switch))
	{
		who = level._player_who_pressed_the_switch;
		level.skit_vox_override = 1;
		who playsoundwithnotify("vox_egg_story_1_5" + zm_temple_sq::function_26186755(who.characterindex), "vox_egg_sounddone");
		who waittill(#"vox_egg_sounddone");
		level.skit_vox_override = 0;
	}
	level._oafc_sound_ent playsoundwithnotify("vox_egg_story_1_6", "sounddone");
	level._oafc_sound_ent waittill(#"sounddone");
	level._oafc_sound_ent playsoundwithnotify("vox_egg_story_1_7", "sounddone");
	level._oafc_sound_ent waittill(#"sounddone");
	level flag::set("oafc_plot_vo_done");
	level._oafc_sound_ent delete();
	level._oafc_sound_ent = undefined;
}

