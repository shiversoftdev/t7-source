// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

#namespace zm_cosmodrome_fx;

/*
	Name: main
	Namespace: zm_cosmodrome_fx
	Checksum: 0x7328ABBA
	Offset: 0x11D8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_scripted_fx();
	level thread trap_fx_monitor("fire_trap_group1", "f1", "fire");
	level thread trap_fx_monitor("fire_trap_group2", "f2", "fire");
	level thread trap_fx_monitor("rocket_trap_group1", "r1", "fire");
	level thread trap_fx_monitor("rocket_trap_group2", "r2", "fire");
	disablefx = getdvarint("disable_fx");
	if(!isdefined(disablefx) || disablefx <= 0)
	{
		precache_scripted_fx();
	}
}

/*
	Name: precache_scripted_fx
	Namespace: zm_cosmodrome_fx
	Checksum: 0xB7CF7CFD
	Offset: 0x1308
	Size: 0x416
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["zombie_power_switch"] = "dlc5/cosmo/fx_zombie_power_switch";
	level._effect["zapper_light_ready"] = "dlc5/zmhd/fx_zombie_zapper_light_green";
	level._effect["zapper_light_notready"] = "dlc5/zmhd/fx_zombie_zapper_light_red";
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["zombie_eye_glow"] = level._effect["eye_glow"];
	level._effect["monkey_eye_glow"] = "dlc5/zmhd/fx_zmb_monkey_eyes";
	level._effect["fire_trap"] = "dlc5/zmb_traps/fx_fire_trap_med_loop";
	level._effect["zapper"] = "misc/fx_zombie_electric_trap";
	level._effect["wire_spark"] = "dlc5/zmhd/fx_zombie_wire_spark";
	level._effect["soul_spark"] = "dlc5/cosmo/fx_zmb_blackhole_zombie_death";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "dlc5/zmhd/fx_trail_blood_streak";
	level._effect["lander_green_left"] = "dlc5/cosmo/fx_zmb_csm_lander_pad_green_lft";
	level._effect["lander_green_right"] = "dlc5/cosmo/fx_zmb_csm_lander_pad_green";
	level._effect["lander_red_left"] = "dlc5/cosmo/fx_zmb_csm_lander_pad_red_lft";
	level._effect["lander_red_right"] = "dlc5/cosmo/fx_zmb_csm_lander_pad_red";
	level._effect["lander_green"] = "dlc5/cosmo/fx_zmb_csm_lander_post_green";
	level._effect["lander_red"] = "dlc5/cosmo/fx_zmb_csm_lander_post_red";
	level._effect["rocket_blast_trail"] = "dlc5/zmhd/fx_russian_rocket_exhaust_zmb";
	level._effect["lunar_lander_thruster_bellow"] = "dlc5/cosmo/fx_zombie_lunar_lander_thruster_bellow";
	level._effect["lunar_lander_thruster_leg"] = "dlc5/cosmo/fx_zombie_lunar_lander_thruster_leg";
	level._effect["debris_trail"] = "dlc5/zmhd/fx_exp_rocket_debris_trail";
	level._effect["debris_hit"] = "dlc5/cosmo/fx_zombie_ape_spawn_dust";
	level._effect["mig_trail"] = "dlc5/zmhd/fx_geotrail_jet_contrail";
	level._effect["panel_green"] = "dlc5/cosmo/fx_zmb_csm_lander_panel_green";
	level._effect["panel_red"] = "dlc5/cosmo/fx_zmb_csm_lander_panel_red";
	level._effect["centrifuge_warning_light"] = "dlc5/cosmo/fx_zmb_light_centrifuge_top";
	level._effect["centrifuge_light_spark"] = "dlc5/cosmo/fx_zombie_centrifuge_spark";
	level._effect["centrifuge_start_steam"] = "dlc5/cosmo/fx_zmb_csm_centrifuge_steam_blst";
	level._effect["monkey_spawn"] = "dlc5/cosmo/fx_zombie_ape_spawn_dust";
	level._effect["monkey_trail"] = "dlc5/cosmo/fx_zombie_ape_spawn_trail";
	level._effect["perk_machine_light_yellow"] = "dlc5/zmhd/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc5/zmhd/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc5/zmhd/fx_wonder_fizz_light_green";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_cosmodrome_fx
	Checksum: 0xF369A7E
	Offset: 0x1728
	Size: 0x40E
	Parameters: 0
	Flags: None
*/
function precache_createfx_fx()
{
	level._effect["fx_tower_light_glow"] = "maps/zombie/fx_tower_light_glow";
	level._effect["fx_zombie_rocket_trap_heat_glow"] = "dlc5/cosmo/fx_zombie_rocket_trap_heat_glow";
	level._effect["fx_zombie_nuke_distant"] = "dlc5/cosmo/fx_zombie_nuke_distant";
	level._effect["fx_zmb_water_spray_leak_sm"] = "maps/zombie/fx_zmb_water_spray_leak_sm";
	level._effect["fx_zmb_pipe_steam_md"] = "dlc5/zmhd/fx_pipe_steam_md";
	level._effect["fx_zmb_pipe_steam_md_runner"] = "maps/zombie/fx_zmb_pipe_steam_md_runner";
	level._effect["fx_zmb_steam_hallway_md"] = "maps/zombie/fx_zmb_steam_hallway_md";
	level._effect["fx_zmb_fog_lit_overhead_amber"] = "maps/zombie/fx_zmb_fog_lit_overhead_amber";
	level._effect["fx_zmb_fog_thick_300x300"] = "maps/zombie/fx_zmb_fog_thick_300x300";
	level._effect["fx_zmb_fog_thick_600x600"] = "maps/zombie/fx_zmb_fog_thick_600x600";
	level._effect["fx_zmb_fog_thick_1200x1200"] = "maps/zombie/fx_zmb_fog_thick_1200x1200";
	level._effect["fx_zmb_fog_dropdown"] = "maps/zombie/fx_zmb_fog_dropdown";
	level._effect["fx_zmb_fog_interior_md"] = "maps/zombie/fx_zmb_fog_interior_md";
	level._effect["fx_zmb_fog_lit_overhead"] = "maps/zombie/fx_zmb_fog_lit_overhead";
	level._effect["fx_light_ee_progress"] = "dlc5/cosmo/fx_light_ee_progress";
	level._effect["fx_zmb_light_fluorescent_tube"] = "maps/zombie/fx_zmb_light_fluorescent_tube";
	level._effect["fx_zmb_light_incandescent"] = "maps/zombie/fx_zmb_light_incandescent";
	level._effect["fx_zmb_light_square_white"] = "maps/zombie/fx_zmb_light_square_white";
	level._effect["fx_zmb_light_cagelight01"] = "maps/zombie/fx_zmb_csm_light_cagelight01";
	level._effect["fx_zmb_light_flashlight"] = "maps/zombie/fx_zmb_light_flashlight";
	level._effect["fx_light_dust_motes_xsm"] = "env/light/fx_light_dust_motes_xsm";
	level._effect["fx_zmb_booster_condensation"] = "dlc5/cosmo/fx_zmb_booster_condensation";
	level._effect["fx_zmb_elec_spark_burst_loop"] = "dlc5/zmhd/fx_zmb_elec_spark_burst_loop";
	level._effect["fx_zmb_fire_sm_smolder"] = "maps/zombie/fx_zmb_fire_sm_smolder";
	level._effect["fx_fire_line_xsm"] = "env/fire/fx_fire_line_xsm";
	level._effect["fx_fire_line_sm"] = "env/fire/fx_fire_line_sm";
	level._effect["fx_fire_wall_back_sm"] = "env/fire/fx_fire_wall_back_sm";
	level._effect["fx_fire_destruction_lg"] = "env/fire/fx_fire_destruction_lg";
	level._effect["fx_zmb_smk_linger_lit"] = "maps/zombie/fx_zmb_smk_linger_lit";
	level._effect["fx_zmb_smk_plume_md_wht_wispy"] = "maps/zombie/fx_zmb_smk_plume_md_wht_wispy";
	level._effect["fx_smk_fire_md_black"] = "env/smoke/fx_smk_fire_md_black";
	level._effect["fx_ship_smk_fire_xlg_black"] = "maps/zombie/fx_ship_smk_fire_xlg_black";
	level._effect["fx_zmb_pad_light"] = "dlc5/cosmo/fx_zmb_csm_rocket_pad_light";
	level._effect["fx_zmb_gantry_coolant_md"] = "dlc5/cosmo/fx_zmb_gantry_coolant_md";
	level._effect["fx_elec_terminal"] = "dlc5/cosmo/fx_zmb_elec_terminal_arc";
	level._effect["fx_zmb_elec_terminal_bridge"] = "dlc5/cosmo/fx_zmb_elec_terminal_bridge";
	level._effect["fx_zmb_russian_rocket_smk"] = "dlc5/cosmo/fx_zmb_russian_rocket_smk";
}

/*
	Name: trap_fx_monitor
	Namespace: zm_cosmodrome_fx
	Checksum: 0x3095B104
	Offset: 0x1B40
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
	Namespace: zm_cosmodrome_fx
	Checksum: 0x56BDE681
	Offset: 0x1C68
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
	if(isdefined(self.script_string))
	{
		fx_name = self.script_string;
	}
	else
	{
		switch(trap_type)
		{
			case "electric":
			{
				fx_name = "zapper";
				break;
			}
			case "fire":
			default:
			{
				fx_name = "fire_trap";
				break;
			}
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
	Name: toggle_lander_lights
	Namespace: zm_cosmodrome_fx
	Checksum: 0x8EFBAF42
	Offset: 0x1ED0
	Size: 0x37A
	Parameters: 2
	Flags: Linked
*/
function toggle_lander_lights(color, localclientnum)
{
	right_fx = level._effect["lander_green_right"];
	left_fx = level._effect["lander_green_left"];
	if(color == "red")
	{
		right_fx = level._effect["lander_red_right"];
		left_fx = level._effect["lander_red_left"];
	}
	var_1e2c44d5 = getentarray(localclientnum, "centrifuge_zip_door", "targetname");
	var_442ebf3e = getentarray(localclientnum, "base_entry_zip_door", "targetname");
	var_6a3139a7 = getentarray(localclientnum, "storage_zip_door", "targetname");
	var_601fe0c8 = getentarray(localclientnum, "catwalk_zip_door", "targetname");
	doorsa = arraycombine(var_1e2c44d5, var_442ebf3e, 0, 1);
	doorsb = arraycombine(var_6a3139a7, var_601fe0c8, 0, 1);
	all_doors = arraycombine(doorsa, doorsb, 0, 1);
	for(i = 0; i < all_doors.size; i++)
	{
		if(all_doors[i].model == "p7_zm_asc_door_lander_lunar_rt")
		{
			if(isdefined(all_doors[i].fx))
			{
				stopfx(localclientnum, all_doors[i].fx);
			}
			all_doors[i] util::waittill_dobj(localclientnum);
			all_doors[i].fx = playfxontag(localclientnum, right_fx, all_doors[i], "tag_origin");
			continue;
		}
		if(all_doors[i].model == "p7_zm_asc_door_lander_lunar_lft")
		{
			if(isdefined(all_doors[i].fx))
			{
				stopfx(localclientnum, all_doors[i].fx);
			}
			all_doors[i].fx = playfxontag(localclientnum, left_fx, all_doors[i], "tag_origin");
		}
	}
}

