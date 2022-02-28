// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace zm_tomb_fx;

/*
	Name: precache_util_fx
	Namespace: zm_tomb_fx
	Checksum: 0x99EC1590
	Offset: 0x1D68
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache_util_fx()
{
}

/*
	Name: precache_scripted_fx
	Namespace: zm_tomb_fx
	Checksum: 0xD3A0C32
	Offset: 0x1D78
	Size: 0xA12
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["eye_glow_blue"] = "maps/zombie/fx_zombie_eye_single_blue";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["glow_biplane_trail_fx"] = "dlc5/tomb/fx_glow_biplane_trail";
	level._effect["m14_zm_fx"] = "maps/zombie/fx_zmb_wall_buy_rifle";
	level._effect["fx_tomb_ee_vortex"] = "dlc5/tomb/fx_tomb_ee_vortex";
	level._effect["robot_foot_stomp"] = "dlc5/tomb/fx_tomb_robot_dust";
	level._effect["eject_warning"] = "dlc5/tomb/fx_tomb_robot_eject_warning";
	level._effect["eject_steam"] = "dlc5/tomb/fx_tomb_robot_eject_steam";
	level._effect["giant_robot_footstep_warning_light"] = "dlc5/tomb/fx_tomb_foot_warning_light_red";
	level._effect["giant_robot_foot_light"] = "light/fx_light_zm_tomb_robot_foot";
	level._effect["mechz_death"] = "dlc5/tomb/fx_tomb_mech_death";
	level._effect["mechz_sparks"] = "maps/zombie_tomb/fx_tomb_mech_dmg_sparks";
	level._effect["mechz_steam"] = "maps/zombie_tomb/fx_tomb_mech_dmg_steam";
	level._effect["mech_booster_landing"] = "maps/zombie_tomb/fx_tomb_mech_jump_landing";
	level._effect["mechz_claw"] = "dlc5/tomb/fx_tomb_mech_wpn_claw";
	level._effect["mechz_wpn_source"] = "dlc5/tomb/fx_tomb_mech_wpn_source";
	level._effect["staff_charge"] = "dlc5/zmb_weapon/fx_staff_charge";
	level._effect["staff_soul"] = "dlc5/zmb_weapon/fx_staff_charge_souls";
	level._effect["air_glow"] = "dlc5/tomb/fx_tomb_elem_reveal_air_glow";
	level._effect["elec_glow"] = "dlc5/tomb/fx_tomb_elem_reveal_elec_glow";
	level._effect["fire_glow"] = "dlc5/tomb/fx_tomb_elem_reveal_fire_glow";
	level._effect["ice_glow"] = "dlc5/tomb/fx_tomb_elem_reveal_ice_glow";
	level._effect["teleport_air"] = "dlc5/tomb/fx_portal_air";
	level._effect["teleport_elec"] = "dlc5/tomb/fx_portal_elec";
	level._effect["teleport_fire"] = "dlc5/tomb/fx_portal_fire";
	level._effect["teleport_ice"] = "dlc5/tomb/fx_portal_ice";
	level._effect["teleport_arrive_player"] = "dlc5/tomb/fx_teleport_arrive_3p";
	level._effect["tesla_elec_kill"] = "dlc5/tomb/fx_115_generator_tesla_kill";
	level._effect["capture_progression"] = "maps/zombie_tomb/fx_tomb_capture_progression";
	level._effect["capture_progression_1"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_1_activating";
	level._effect["capture_progression_2"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_2_activating";
	level._effect["capture_progression_3"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_3_activating";
	level._effect["capture_progression_4"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_4_activating";
	level._effect["capture_progression_5"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_5_activating";
	level._effect["capture_progression_6"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_6_activating";
	level._effect["capture_complete_1"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_1_idle";
	level._effect["capture_complete_2"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_2_idle";
	level._effect["capture_complete_3"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_3_idle";
	level._effect["capture_complete_4"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_4_idle";
	level._effect["capture_complete_5"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_5_idle";
	level._effect["capture_complete_6"] = "dlc5/tomb/fx_115_generator_progression_elec_ring_6_idle";
	level._effect["capture_exhaust"] = "maps/zombie_tomb/fx_tomb_capture_exhaust_back";
	level._effect["capture_exhaust_front"] = "dlc5/tomb/fx_115_generator_progression_exhaust_front";
	level._effect["capture_exhaust_rear"] = "dlc5/tomb/fx_115_generator_progression_exhaust_rear";
	level._effect["capture_exhaust_side"] = "dlc5/tomb/fx_115_generator_progression_exhaust_side";
	level._effect["screecher_hole"] = "dlc5/tomb/fx_tomb_screecher_vortex";
	level._effect["zone_capture_zombie_torso_fx"] = "dlc5/tomb/fx_crusader_torso_loop";
	level._effect["crusader_zombie_eyes"] = "dlc5/tomb/fx_crusader_eyes";
	level._effect["player_rain"] = "dlc5/tomb/fx_weather_rain_camera";
	level._effect["player_snow"] = "dlc5/tomb/fx_weather_snow_camera";
	level._effect["lightning_flash"] = "dlc5/tomb/fx_alcatraz_lightning_lg";
	level._effect["tank_treads"] = "dlc5/tomb/fx_tomb_veh_tank_treadfx_mud";
	level._effect["mech_wpn_flamethrower"] = "dlc5/tomb/fx_tomb_mech_wpn_flamethrower";
	level._effect["tank_light_grn"] = "dlc5/tomb/fx_tomb_capture_light_green";
	level._effect["tank_light_red"] = "dlc5/tomb/fx_tomb_capture_light_red_tank";
	level._effect["tank_overheat"] = "dlc5/tomb/fx_tomb_veh_tank_exhaust_overheat";
	level._effect["tank_exhaust"] = "dlc5/tomb/fx_tomb_veh_tank_exhaust";
	level._effect["zapper_light_notready"] = "dlc5/tomb/fx_115_generator_progression_red_light";
	level._effect["bottle_glow"] = "dlc5/tomb/fx_tomb_dieselmagic_portal";
	level._effect["perk_pipe_smoke"] = "dlc5/tomb/fx_tomb_perk_machine_exhaust";
	level._effect["wagon_fire"] = "maps/zombie_tomb/fx_tomb_ee_fire_wagon";
	level._effect["fist_glow"] = "dlc5/tomb/fx_tomb_ee_fists";
	level._effect["ee_vortex"] = "dlc5/tomb/fx_tomb_ee_vortex";
	level._effect["ee_beam"] = "dlc5/tomb/fx_tomb_ee_beam";
	level._effect["foot_box_glow"] = "dlc5/tomb/fx_tomb_challenge_fire";
	level._effect["sky_plane_tracers"] = "dlc5/tomb/fx_tomb_sky_plane_tracers";
	level._effect["sky_plane_trail"] = "dlc5/tomb/fx_smk_airplane_trail_vista";
	level._effect["biplane_glow"] = "dlc5/tomb/fx_glow_biplane";
	level._effect["zeppelin_lights"] = "dlc5/tomb/fx_light_zep_tail_spot";
	level._effect["special_glow"] = "dlc5/tomb/fx_elem_reveal_glow";
	level._effect["teleport_1p"] = "dlc5/tomb/fx_teleport_1p";
	level._effect["box_powered"] = "dlc5/tomb/fx_tomb_magicbox_on";
	level._effect["box_unpowered"] = "dlc5/tomb/fx_tomb_magicbox_off";
	level._effect["box_gone_ambient"] = "dlc5/tomb/fx_tomb_magicbox_amb_base";
	level._effect["box_here_ambient"] = "dlc5/tomb/fx_tomb_magicbox_amb_slab";
	level._effect["box_is_open"] = "dlc5/tomb/fx_tomb_magicbox_open";
	level._effect["box_is_open_beam_left"] = "dlc5/tomb/fx_tomb_magicbox_beam_tgt_left";
	level._effect["box_is_open_beam_right"] = "dlc5/tomb/fx_tomb_magicbox_beam_tgt_right";
	level._effect["box_portal"] = "dlc5/tomb/fx_tomb_magicbox_portal";
	level._effect["box_is_leaving"] = "dlc5/tomb/fx_tomb_magicbox_leave";
	level._effect["chest_light"] = "tools/fx_null";
	level._effect["chest_light_closed"] = "tools/fx_null";
	level._effect["cooldown_steam"] = "dlc5/tomb/fx_tomb_dieselmagic_steam";
	level._effect["crypt_wall_drop"] = "dlc5/tomb/fx_chamber_wall_impact";
	level._effect["perk_machine_light_yellow"] = "dlc5/zmhd/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc5/zmhd/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc5/zmhd/fx_wonder_fizz_light_green";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_tomb_fx
	Checksum: 0xBABE1F6B
	Offset: 0x2798
	Size: 0x40E
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
	level._effect["fx_sky_dist_aa_tracers"] = "maps/zombie_tomb/fx_tomb_sky_dist_aa_tracers";
	level._effect["fx_tomb_vortex_glow"] = "maps/zombie_tomb/fx_tomb_vortex_glow";
	level._effect["fx_pack_a_punch"] = "maps/zombie_tomb/fx_tomb_pack_a_punch_light_beams";
	level._effect["fire_sacrifice_flame"] = "dlc5/tomb/fx_tomb_puzzle_fire_sacrifice";
	level._effect["fx_tomb_dust_fall"] = "maps/zombie_tomb/fx_tomb_dust_fall";
	level._effect["fx_tomb_dust_fall_lg"] = "maps/zombie_tomb/fx_tomb_dust_fall_lg";
	level._effect["fx_tomb_embers_flat"] = "maps/zombie_tomb/fx_tomb_embers_flat";
	level._effect["fx_tomb_fire_lg"] = "maps/zombie_tomb/fx_tomb_fire_lg";
	level._effect["fx_tomb_fire_sm"] = "maps/zombie_tomb/fx_tomb_fire_sm";
	level._effect["fx_tomb_fire_line_sm"] = "maps/zombie_tomb/fx_tomb_fire_line_sm";
	level._effect["fx_tomb_fire_sm_smolder"] = "maps/zombie_tomb/fx_tomb_fire_sm_smolder";
	level._effect["fx_tomb_ground_fog"] = "maps/zombie_tomb/fx_tomb_ground_fog";
	level._effect["fx_tomb_sparks"] = "dlc5/tomb/fx_tomb_puzzle_elec_sparks_c";
	level._effect["fx_tomb_water_drips"] = "maps/zombie_tomb/fx_tomb_water_drips";
	level._effect["fx_tomb_water_drips_sm"] = "maps/zombie_tomb/fx_tomb_water_drips_sm";
	level._effect["fx_tomb_smoke_pillar_xlg"] = "maps/zombie_tomb/fx_tomb_smoke_pillar_xlg";
	level._effect["fx_tomb_godray_md"] = "maps/zombie_tomb/fx_tomb_godray_md";
	level._effect["fx_tomb_godray_mist_md"] = "maps/zombie_tomb/fx_tomb_godray_mist_md";
	level._effect["fx_tomb_dust_motes_md"] = "maps/zombie_tomb/fx_tomb_dust_motes_md";
	level._effect["fx_tomb_dust_motes_lg"] = "maps/zombie_tomb/fx_tomb_dust_motes_lg";
	level._effect["fx_tomb_light_md"] = "maps/zombie_tomb/fx_tomb_light_md";
	level._effect["fx_tomb_light_lg"] = "maps/zombie_tomb/fx_tomb_light_lg";
	level._effect["fx_tomb_light_expensive"] = "maps/zombie_tomb/fx_tomb_light_expensive";
	level._effect["fx_tomb_steam_md"] = "maps/zombie_tomb/fx_tomb_steam_md";
	level._effect["fx_tomb_steam_lg"] = "maps/zombie_tomb/fx_tomb_steam_lg";
	level._effect["fx_tomb_church_fire_vista"] = "maps/zombie_tomb/fx_tomb_church_fire_vista";
	level._effect["fx_tomb_church_custom"] = "maps/zombie_tomb/fx_tomb_church_custom";
	level._effect["fx_tomb_chamber_glow"] = "maps/zombie_tomb/fx_tomb_chamber_glow";
	level._effect["fx_tomb_chamber_glow_blue"] = "maps/zombie_tomb/fx_tomb_chamber_glow_blue";
	level._effect["fx_tomb_chamber_glow_purple"] = "maps/zombie_tomb/fx_tomb_chamber_glow_purple";
	level._effect["fx_tomb_chamber_glow_yellow"] = "maps/zombie_tomb/fx_tomb_chamber_glow_yellow";
	level._effect["fx_tomb_chamber_glow_red"] = "maps/zombie_tomb/fx_tomb_chamber_glow_red";
	level._effect["fx_tomb_chamber_walls_impact"] = "maps/zombie_tomb/fx_tomb_chamber_walls_impact";
	level._effect["fx_tomb_crafting_chamber_glow"] = "maps/zombie_tomb/fx_tomb_crafting_chamber_glow";
	level._effect["fx_tomb_probe_elec_on"] = "maps/zombie_tomb/fx_tomb_probe_elec_on";
	level._effect["fx_tomb_robot_ambient"] = "maps/zombie_tomb/fx_tomb_robot_ambient";
	level._effect["fx_tomb_skybox_vortex"] = "maps/zombie_tomb/fx_tomb_skybox_vortex";
}

/*
	Name: main
	Namespace: zm_tomb_fx
	Checksum: 0x51E2C202
	Offset: 0x2BB0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_util_fx();
	precache_createfx_fx();
	disablefx = getdvarint("disable_fx");
	if(!isdefined(disablefx) || disablefx <= 0)
	{
		precache_scripted_fx();
	}
	level thread trap_fx_monitor("flame_trap", "str_flame_trap");
}

/*
	Name: setup_prop_anims
	Namespace: zm_tomb_fx
	Checksum: 0x205F1E3B
	Offset: 0x2C58
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function setup_prop_anims()
{
	util::waitforclient(0);
	level thread play_fx_prop_anims();
}

/*
	Name: play_fx_prop_anims
	Namespace: zm_tomb_fx
	Checksum: 0xB817EF89
	Offset: 0x2C98
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function play_fx_prop_anims()
{
	fxanim_props = struct::get_array("fxanim_chamber_rocks", "targetname");
	array::thread_all(fxanim_props, &function_1c1d65fb);
}

/*
	Name: function_1c1d65fb
	Namespace: zm_tomb_fx
	Checksum: 0xC466133C
	Offset: 0x2CF8
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function function_1c1d65fb()
{
	self endon(#"delete");
	scene::add_scene_func(self.scriptbundlename, &function_b9b12551, "done");
	while(true)
	{
		self scene::play(self.scriptbundlename);
		wait(randomfloatrange(10, 30));
	}
}

/*
	Name: function_b9b12551
	Namespace: zm_tomb_fx
	Checksum: 0x32E3D0B3
	Offset: 0x2D80
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function function_b9b12551(a_ents)
{
	foreach(e_ent in a_ents)
	{
		e_ent delete();
	}
}

/*
	Name: trap_fx_monitor
	Namespace: zm_tomb_fx
	Checksum: 0x2C283D7F
	Offset: 0x2E20
	Size: 0xB2
	Parameters: 2
	Flags: Linked
*/
function trap_fx_monitor(str_name, str_side)
{
	while(true)
	{
		level waittill(str_name);
		var_276d0f92 = struct::get_array(str_name, "targetname");
		for(i = 0; i < var_276d0f92.size; i++)
		{
			if(str_name == "flame_trap")
			{
				var_276d0f92[i] thread function_ea3d061(str_name, str_side);
			}
		}
	}
}

/*
	Name: function_ea3d061
	Namespace: zm_tomb_fx
	Checksum: 0x8654C2A5
	Offset: 0x2EE0
	Size: 0x280
	Parameters: 2
	Flags: Linked
*/
function function_ea3d061(str_name, str_side)
{
	var_498b0d1c = self.angles;
	vec_forward = anglestoforward(var_498b0d1c);
	if(isdefined(self.var_6d5392e9))
	{
		for(i = 0; i < self.var_6d5392e9.size; i++)
		{
			stopfx(i, self.var_6d5392e9[i]);
		}
		self.var_6d5392e9 = [];
	}
	if(!isdefined(self.var_6d5392e9))
	{
		self.var_6d5392e9 = [];
	}
	a_players = getlocalplayers();
	for(i = 0; i < a_players.size; i++)
	{
		self.var_6d5392e9[i] = playfx(i, level._effect["flame_trap_start"], self.origin, vec_forward);
		wait(1);
		level.var_d9c7b303 = 1;
		level thread function_b8462abd();
		while(level.var_d9c7b303)
		{
			self.var_6d5392e9[i] = playfx(i, level._effect["flame_trap_loop"], self.origin, vec_forward);
			wait(1);
		}
		self.var_6d5392e9[i] = playfx(i, level._effect["flame_trap_start"], self.origin, vec_forward);
		wait(1);
	}
	level waittill(str_side + "off");
	for(i = 0; i < self.var_6d5392e9.size; i++)
	{
		stopfx(i, self.var_6d5392e9[i]);
	}
	self.var_6d5392e9 = [];
}

/*
	Name: function_b8462abd
	Namespace: zm_tomb_fx
	Checksum: 0xA91DAD0F
	Offset: 0x3168
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function function_b8462abd()
{
	wait(25);
	level.var_d9c7b303 = 0;
}

