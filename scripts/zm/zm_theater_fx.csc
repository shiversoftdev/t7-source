// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_perks;

#namespace zm_theater_fx;

/*
	Name: main
	Namespace: zm_theater_fx
	Checksum: 0xD7417BC
	Offset: 0x15D0
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_createfx_fx();
	precache_scripted_fx();
	level thread trap_fx_monitor("dressing_room_trap", "e4", "electric_tall");
	level thread trap_fx_monitor("vip_room_trap", "e2", "electric");
	level thread trap_fx_monitor("foyer_room_trap", "e1", "electric_tall");
	level thread trap_fx_monitor("control_room_trap", "e3", "electric");
	level thread trap_fx_monitor("crematorium_room_trap", "f1", "fire");
	level thread light_model_swap("smodel_light_electric", "lights_indlight_on");
	level thread dog_start_monitor();
	level thread dog_stop_monitor();
	level notify(#"dog_stop");
	level thread projector_screen_fx();
}

/*
	Name: precache_scripted_fx
	Namespace: zm_theater_fx
	Checksum: 0x779924EF
	Offset: 0x1768
	Size: 0x286
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["boxlight_light_ready"] = "maps/zombie/fx_zombie_theater_lightboard_green";
	level._effect["boxlight_light_notready"] = "maps/zombie/fx_zombie_theater_lightboard_red";
	level._effect["theater_projector_beam"] = "maps/zombie/fx_zombie_theater_projector_beam";
	level._effect["projector_screen_0"] = "dlc5/theater/fx_projector_image_4";
	level._effect["ps1"] = "dlc5/theater/fx_projector_image_1";
	level._effect["ps2"] = "dlc5/theater/fx_projector_image_2";
	level._effect["ps3"] = "dlc5/theater/fx_projector_image_3";
	level._effect["headshot"] = "dlc5/zmhd/fx_flesh_hit_splat";
	level._effect["headshot_nochunks"] = "dlc5/zmhd/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "dlc5/zmhd/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "dlc5/zmhd/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["teleport_player_kino"] = "dlc5/theater/fx_teleport_flashback_kino";
	level._effect["teleport_player_kino_cover"] = "dlc5/theater/fx_teleport_flashback_kino_cover";
	level._effect["teleport_initiate"] = "dlc5/theater/fx_teleport_initiate";
	level._effect["teleport_initiate_top"] = "dlc5/theater/fx_teleport_initiate_top";
	level._effect["teleport_cooldown"] = "dlc5/theater/fx_teleport_cooldown";
	level._effect["teleport_player_flash"] = "dlc5/theater/fx_teleport_player_flash";
	level._effect["player_dust_motes"] = "dlc5/theater/fx_dust_motes_player_theater";
	level._effect["perk_machine_light_yellow"] = "dlc5/zmhd/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc5/zmhd/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc5/zmhd/fx_wonder_fizz_light_green";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_theater_fx
	Checksum: 0xD2504200
	Offset: 0x19F8
	Size: 0x6E6
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
	level._effect["fx_mp_smoke_thick_indoor"] = "maps/zombie/fx_mp_smoke_thick_indoor";
	level._effect["fx_mp_smoke_amb_indoor_misty"] = "maps/zombie/fx_zombie_theater_smoke_amb_indoor";
	level._effect["fx_smoke_smolder_md_gry"] = "maps/zombie/fx_smoke_smolder_md_gry";
	level._effect["fx_smk_smolder_sm"] = "env/smoke/fx_smk_smolder_sm";
	level._effect["fx_mp_smoke_crater"] = "maps/zombie/fx_mp_smoke_crater";
	level._effect["fx_mp_smoke_sm_slow"] = "maps/zombie/fx_mp_smoke_sm_slow";
	level._effect["fx_mp_fog_low"] = "maps/mp_maps/fx_mp_fog_low";
	level._effect["fx_zombie_theater_fog_lg"] = "maps/zombie/fx_zombie_theater_fog_lg";
	level._effect["fx_zombie_theater_fog_xlg"] = "maps/zombie/fx_zombie_theater_fog_xlg";
	level._effect["fx_mp_fog_ground_md"] = "maps/mp_maps/fx_mp_fog_ground_md";
	level._effect["fx_water_drip_light_long"] = "env/water/fx_water_drip_light_long";
	level._effect["fx_water_drip_light_short"] = "env/water/fx_water_drip_light_short";
	level._effect["fx_mp_ray_light_sm"] = "env/light/fx_light_godray_overcast_sm";
	level._effect["fx_mp_ray_light_md"] = "maps/zombie/fx_mp_ray_overcast_md";
	level._effect["fx_mp_ray_light_lg"] = "maps/zombie/fx_light_godray_overcast_lg";
	level._effect["fx_mp_dust_motes"] = "maps/zombie/fx_mp_ray_motes_lg";
	level._effect["fx_mp_dust_mote_pcloud_sm"] = "maps/zombie/fx_mp_dust_mote_pcloud_sm";
	level._effect["fx_mp_dust_mote_pcloud_md"] = "maps/zombie/fx_mp_dust_mote_pcloud_md";
	level._effect["fx_mp_pipe_steam"] = "dlc5/zmhd/fx_pipe_steam_md";
	level._effect["fx_mp_pipe_steam_random"] = "maps/zombie/fx_mp_pipe_steam_random";
	level._effect["fx_mp_fumes_vent_sm_int"] = "maps/mp_maps/fx_mp_fumes_vent_sm_int";
	level._effect["fx_mp_fumes_vent_xsm_int"] = "maps/mp_maps/fx_mp_fumes_vent_xsm_int";
	level._effect["fx_mp_elec_spark_burst_xsm_thin_runner"] = "maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin_runner";
	level._effect["fx_mp_elec_spark_burst_sm_runner"] = "maps/mp_maps/fx_mp_elec_spark_burst_sm_runner";
	level._effect["fx_mp_light_lamp"] = "dlc5/theater/fx_lensflare_projector";
	level._effect["fx_mp_light_corona_cool"] = "maps/zombie/fx_mp_light_corona_cool";
	level._effect["fx_mp_light_corona_bulb_ceiling"] = "maps/zombie/fx_mp_light_corona_bulb_ceiling";
	level._effect["fx_pent_tinhat_light"] = "maps/pentagon/fx_pent_tinhat_light";
	level._effect["fx_light_floodlight_bright"] = "maps/zombie/fx_zombie_light_floodlight_bright";
	level._effect["fx_light_overhead_sm_amber"] = "maps/zombie/fx_zombie_overhead_sm_amber";
	level._effect["fx_light_overhead_sm_amber_flkr"] = "maps/zombie/fx_zombie_overhead_sm_amber_flkr";
	level._effect["fx_light_overhead_sm_blue"] = "maps/zombie/fx_zombie_overhead_sm_blu";
	level._effect["fx_light_overhead_sm_blue_flkr"] = "maps/zombie/fx_zombie_overhead_sm_blu_flkr";
	level._effect["fx_mp_birds_circling"] = "maps/zombie/fx_mp_birds_circling";
	level._effect["fx_mp_insects_lantern"] = "maps/zombie_old/fx_mp_insects_lantern";
	level._effect["fx_insects_swarm_md_light"] = "bio/insects/fx_insects_swarm_md_light";
	level._effect["fx_insects_maggots"] = "bio/insects/fx_insects_maggots_sm";
	level._effect["fx_insects_moths_light_source"] = "bio/insects/fx_insects_moths_light_source";
	level._effect["fx_insects_moths_light_source_md"] = "bio/insects/fx_insects_moths_light_source_md";
	level._effect["fx_pent_movie_projector"] = "maps/pentagon/fx_pent_movie_projector";
	level._effect["fx_zombie_light_theater_blue"] = "maps/zombie/fx_zombie_light_theater_blue";
	level._effect["fx_zombie_light_theater_green"] = "maps/zombie/fx_zombie_light_theater_green";
	level._effect["fx_zombie_theater_projector_beam"] = "maps/zombie/fx_zombie_theater_projector_beam";
	level._effect["fx_zombie_theater_projector_screen"] = "maps/zombie/fx_zombie_theater_projection_screen";
	level._effect["fx_transporter_beam"] = "maps/zombie/fx_transporter_beam";
	level._effect["fx_transporter_pad_start"] = "maps/zombie/fx_transporter_pad_start";
	level._effect["fx_transporter_start"] = "maps/zombie/fx_transporter_start";
	level._effect["fx_transporter_ambient"] = "maps/zombie/fx_transporter_ambient";
	level._effect["fx_zombie_mainframe_beam"] = "maps/zombie/fx_zombie_mainframe_beam";
	level._effect["fx_zombie_mainframe_flat"] = "maps/zombie/fx_zombie_mainframe_flat";
	level._effect["fx_zombie_mainframe_flat_start"] = "maps/zombie/fx_zombie_mainframe_flat_start";
	level._effect["fx_zombie_mainframe_beam_start"] = "maps/zombie/fx_zombie_mainframe_beam_start";
	level._effect["fx_zombie_flashback_theater"] = "maps/zombie/fx_zombie_flashback_theater";
	level._effect["fx_zombie_difference"] = "maps/zombie/fx_zombie_difference";
	level._effect["fx_zombie_heat_sink"] = "maps/zombie/fx_zombie_heat_sink";
	level._effect["zapper"] = "dlc5/theater/fx_elec_trap_theater";
	level._effect["zapper_tall"] = "dlc0/factory/fx_elec_trap_factory";
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["fire_trap_med"] = "dlc5/zmb_traps/fx_fire_trap_med_loop";
	level._effect["fire_trap"] = "dlc5/zmb_traps/fx_fire_trap_med_loop";
	level._effect["fx_quad_roof_break"] = "maps/zombie/fx_zombie_crawler_roof_break";
	level._effect["fx_quad_roof_break_theater"] = "maps/zombie/fx_zombie_crawler_roof_theater";
	level._effect["fx_quad_dust_roof"] = "maps/zombie/fx_zombie_crawler_dust_roof";
}

/*
	Name: trap_fx_monitor
	Namespace: zm_theater_fx
	Checksum: 0x7F2C747A
	Offset: 0x20E8
	Size: 0x11A
	Parameters: 3
	Flags: Linked
*/
function trap_fx_monitor(name, loc, trap_type)
{
	structs = struct::get_array(name, "targetname");
	points = [];
	for(i = 0; i < structs.size; i++)
	{
		if(!isdefined(structs[i].model))
		{
			points[points.size] = structs[i];
		}
	}
	while(true)
	{
		level waittill(loc + "1");
		for(i = 0; i < points.size; i++)
		{
			points[i] thread trap_play_fx(loc, trap_type);
		}
	}
}

/*
	Name: trap_play_fx
	Namespace: zm_theater_fx
	Checksum: 0xDC301033
	Offset: 0x2210
	Size: 0x260
	Parameters: 2
	Flags: Linked
*/
function trap_play_fx(loc, trap_type)
{
	ang = self.angles;
	forward = anglestoforward(ang);
	up = anglestoup(ang);
	if(isdefined(self.loopfx))
	{
		for(i = 0; i < self.loopfx.size; i++)
		{
			self.loopfx[i] delete();
		}
		self.loopfx = [];
	}
	if(!isdefined(self.loopfx))
	{
		self.loopfx = [];
	}
	fx_name = "";
	switch(trap_type)
	{
		case "electric":
		{
			fx_name = "zapper";
			break;
		}
		case "electric_tall":
		{
			fx_name = "zapper_tall";
			break;
		}
		case "fire":
		default:
		{
			fx_name = "fire_trap_med";
			break;
		}
	}
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		self.loopfx[i] = spawnfx(i, level._effect[fx_name], self.origin, 0, forward, up);
		triggerfx(self.loopfx[i]);
	}
	level waittill(loc + "0");
	for(i = 0; i < self.loopfx.size; i++)
	{
		self.loopfx[i] delete();
	}
	self.loopfx = [];
}

/*
	Name: light_model_swap
	Namespace: zm_theater_fx
	Checksum: 0x11BB608B
	Offset: 0x2478
	Size: 0xE8
	Parameters: 2
	Flags: Linked
*/
function light_model_swap(name, model)
{
	level waittill(#"pl1");
	players = getlocalplayers();
	for(p = 0; p < players.size; p++)
	{
		lamps = getentarray(p, name, "targetname");
		for(i = 0; i < lamps.size; i++)
		{
			lamps[i] setmodel(model);
		}
	}
}

/*
	Name: projector_screen_fx
	Namespace: zm_theater_fx
	Checksum: 0x2051BED1
	Offset: 0x2568
	Size: 0x374
	Parameters: 0
	Flags: Linked
*/
function projector_screen_fx()
{
	projector_struct = struct::get("struct_theater_projector_beam", "targetname");
	projector_ang = projector_struct.angles;
	projector_up = anglestoup(projector_ang);
	projector_forward = anglestoforward(projector_ang);
	screen_struct = struct::get("struct_theater_screen", "targetname");
	screen_ang = screen_struct.angles;
	screen_up = anglestoup(screen_ang);
	screen_forward = anglestoforward(screen_ang);
	projector_struct.screen_beam = [];
	projector_struct.vid = [];
	if(!isdefined(screen_struct.script_string))
	{
		screen_struct.script_string = "ps0";
	}
	wait(0.016);
	if(!level clientfield::get("zm_theater_screen_in_place"))
	{
		level waittill(#"sip");
	}
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		projector_struct.screen_beam[i] = util::spawn_model(i, "tag_origin", projector_struct.origin, projector_struct.angles);
		playfxontag(i, level._effect["theater_projector_beam"], projector_struct.screen_beam[i], "tag_origin");
	}
	level.var_3cb13a71 = [];
	level.var_bcdc3660 = [];
	for(i = 0; i < players.size; i++)
	{
		projector_struct.vid[i] = util::spawn_model(i, "tag_origin", screen_struct.origin, screen_struct.angles);
		var_b4808d98 = playfxontag(i, level._effect["projector_screen_0"], projector_struct.vid[i], "tag_origin");
		level.var_3cb13a71[i] = var_b4808d98;
		level.var_bcdc3660[i] = "projector_screen_0";
	}
	projector_reel_change_init(projector_struct);
}

/*
	Name: projector_reel_change_init
	Namespace: zm_theater_fx
	Checksum: 0x4FEF4CAA
	Offset: 0x28E8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function projector_reel_change_init(struct_projector)
{
	level thread projector_reel_swap(struct_projector, "ps1");
	level thread projector_reel_swap(struct_projector, "ps2");
	level thread projector_reel_swap(struct_projector, "ps3");
}

/*
	Name: projector_reel_swap
	Namespace: zm_theater_fx
	Checksum: 0x9BE687E2
	Offset: 0x2960
	Size: 0x118
	Parameters: 2
	Flags: Linked
*/
function projector_reel_swap(struct_screen, str_clientnotify)
{
	level waittill(str_clientnotify);
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(struct_screen.vid[i]))
		{
			stopfx(i, level.var_3cb13a71[i]);
			if(!level.extracamactive[i])
			{
				level.var_3cb13a71[i] = playfxontag(i, level._effect[str_clientnotify], struct_screen.vid[i], "tag_origin");
			}
			level.var_bcdc3660[i] = str_clientnotify;
		}
	}
}

/*
	Name: function_e4b3e1ca
	Namespace: zm_theater_fx
	Checksum: 0x57412156
	Offset: 0x2A80
	Size: 0x96
	Parameters: 7
	Flags: Linked
*/
function function_e4b3e1ca(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	switch(newval)
	{
		case 1:
		{
			level notify(#"ps1");
			break;
		}
		case 2:
		{
			level notify(#"ps2");
			break;
		}
		case 3:
		{
			level notify(#"ps3");
			break;
		}
	}
}

/*
	Name: dog_start_monitor
	Namespace: zm_theater_fx
	Checksum: 0xE4D4A6D6
	Offset: 0x2B20
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function dog_start_monitor()
{
	while(true)
	{
		level waittill(#"dog_start");
		players = getlocalplayers();
		for(i = 0; i < players.size; i++)
		{
			setworldfogactivebank(i, 2);
		}
	}
}

/*
	Name: dog_stop_monitor
	Namespace: zm_theater_fx
	Checksum: 0x78281AB3
	Offset: 0x2BB0
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function dog_stop_monitor()
{
	while(true)
	{
		level waittill(#"dog_stop");
		players = getlocalplayers();
		for(i = 0; i < players.size; i++)
		{
			setworldfogactivebank(i, 1);
		}
	}
}

