// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace zm_sumpf_fx;

/*
	Name: main
	Namespace: zm_sumpf_fx
	Checksum: 0xF1D6C74C
	Offset: 0xDC8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_scripted_fx();
	precache_createfx_fx();
	level thread trap_fx_monitor("north_west_tgt", "north_west_elec_light");
	level thread trap_fx_monitor("south_west_tgt", "south_west_elec_light");
	level thread trap_fx_monitor("north_east_tgt", "north_east_elec_light");
	level thread trap_fx_monitor("south_east_tgt", "south_east_elec_light");
}

/*
	Name: precache_scripted_fx
	Namespace: zm_sumpf_fx
	Checksum: 0x7F3D1F97
	Offset: 0xE98
	Size: 0x232
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["zapper_fx"] = "maps/zombie/fx_zombie_zapper_powerbox_on";
	level._effect["zapper_wall"] = "maps/zombie/fx_zombie_zapper_wall_control_on";
	level._effect["elec_trail_one_shot"] = "maps/zombie/fx_zombie_elec_trail_oneshot";
	level._effect["zapper_light_ready"] = "maps/zombie/fx_zm_swamp_light_glow_green";
	level._effect["zapper_light_notready"] = "maps/zombie/fx_zm_swamp_light_glow_red";
	level._effect["wire_sparks_oneshot"] = "electrical/fx_elec_wire_spark_dl_oneshot";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["rise_burst_water"] = "maps/zombie/fx_zombie_body_wtr_burst_smpf";
	level._effect["rise_billow_water"] = "maps/zombie/fx_zombie_body_wtr_billow_smpf";
	level._effect["rise_dust_water"] = "maps/zombie/fx_zombie_body_wtr_falling";
	level._effect["trap_log"] = "dlc5/sumpf/fx_log_trap";
	level._effect["chest_light_closed"] = "zombie/fx_weapon_box_closed_glow_hut1_zmb";
	level._effect["perk_machine_light_yellow"] = "dlc5/zmhd/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc5/zmhd/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc5/zmhd/fx_wonder_fizz_light_green";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_sumpf_fx
	Checksum: 0xF0A4E329
	Offset: 0x10D8
	Size: 0x42A
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
	level._effect["mp_fire_medium"] = "fire/fx_fire_fuel_sm";
	level._effect["mp_fire_large"] = "maps/zombie/fx_zmb_tranzit_fire_lrg";
	level._effect["mp_smoke_ambiance_indoor"] = "maps/mp_maps/fx_mp_smoke_ambiance_indoor";
	level._effect["mp_smoke_ambiance_indoor_misty"] = "maps/mp_maps/fx_mp_smoke_ambiance_indoor_misty";
	level._effect["mp_smoke_ambiance_indoor_sm"] = "maps/mp_maps/fx_mp_smoke_ambiance_indoor_sm";
	level._effect["fx_fog_low_floor_sm"] = "env/smoke/fx_fog_low_floor_sm";
	level._effect["mp_smoke_column_tall"] = "maps/mp_maps/fx_mp_smoke_column_tall";
	level._effect["mp_smoke_column_short"] = "maps/mp_maps/fx_mp_smoke_column_short";
	level._effect["mp_fog_rolling_large"] = "maps/mp_maps/fx_mp_fog_rolling_thick_large_area";
	level._effect["mp_fog_rolling_small"] = "maps/mp_maps/fx_mp_fog_rolling_thick_small_area";
	level._effect["mp_flies_carcass"] = "maps/mp_maps/fx_mp_flies_carcass";
	level._effect["mp_insects_swarm"] = "maps/mp_maps/fx_mp_insect_swarm";
	level._effect["mp_insects_lantern"] = "maps/zombie_old/fx_mp_insects_lantern";
	level._effect["mp_firefly_ambient"] = "maps/mp_maps/fx_mp_firefly_ambient";
	level._effect["mp_firefly_swarm"] = "maps/mp_maps/fx_mp_firefly_swarm";
	level._effect["mp_maggots"] = "maps/mp_maps/fx_mp_maggots";
	level._effect["mp_falling_leaves_elm"] = "maps/mp_maps/fx_mp_falling_leaves_elm";
	level._effect["god_rays_dust_motes"] = "env/light/fx_light_god_rays_dust_motes";
	level._effect["light_ceiling_dspot"] = "env/light/fx_ray_ceiling_amber_dim_sm";
	level._effect["fx_bats_circling"] = "bio/animals/fx_bats_circling";
	level._effect["fx_bats_ambient"] = "maps/mp_maps/fx_bats_ambient";
	level._effect["mp_dragonflies"] = "bio/insects/fx_insects_dragonflies_ambient";
	level._effect["fx_mp_ray_moon_xsm_near"] = "maps/mp_maps/fx_mp_ray_moon_xsm_near";
	level._effect["fx_meteor_ambient"] = "maps/zombie/fx_meteor_ambient";
	level._effect["fx_meteor_flash"] = "maps/zombie/fx_meteor_flash";
	level._effect["fx_meteor_flash_spawn"] = "maps/zombie/fx_meteor_flash_spawn";
	level._effect["fx_meteor_hotspot"] = "maps/zombie/fx_meteor_hotspot";
	level._effect["fx_zm_swamp_fire_torch"] = "fire/fx_zm_swamp_fire_torch";
	level._effect["fx_zm_swamp_fire_detail"] = "fire/fx_zm_swamp_fire_detail";
	level._effect["fx_zm_swamp_glow_lantern"] = "maps/zombie/fx_zm_swamp_glow_lantern";
	level._effect["fx_zm_swamp_glow_lantern_sm"] = "maps/zombie/fx_zm_swamp_glow_lantern_sm";
	level._effect["fx_zm_swamp_glow_int_tinhat\t"] = "maps/zombie/fx_zm_swamp_glow_int_tinhat";
	level._effect["fx_zm_swamp_glow_beacon\t"] = "maps/zombie/fx_zm_swamp_glow_beacon";
	level._effect["zapper"] = "dlc0/factory/fx_elec_trap_factory";
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["betty_explode"] = "weapon/bouncing_betty/fx_explosion_betty_generic";
	level._effect["betty_trail"] = "weapon/bouncing_betty/fx_betty_trail";
	level._effect["fx_light_god_ray_sm_sumpf_warm_v1"] = "env/light/fx_light_god_ray_sm_sumpf_warm_v1";
}

/*
	Name: trap_fx_monitor
	Namespace: zm_sumpf_fx
	Checksum: 0x9A367DC5
	Offset: 0x1510
	Size: 0xA2
	Parameters: 2
	Flags: Linked
*/
function trap_fx_monitor(name, side)
{
	while(true)
	{
		level waittill(name);
		fire_points = struct::get_array(name, "targetname");
		for(i = 0; i < fire_points.size; i++)
		{
			fire_points[i] thread electric_trap_fx(name, side);
		}
	}
}

/*
	Name: electric_trap_fx
	Namespace: zm_sumpf_fx
	Checksum: 0xB1F683A5
	Offset: 0x15C0
	Size: 0x1F0
	Parameters: 2
	Flags: Linked
*/
function electric_trap_fx(name, side)
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
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		self.loopfx[i] = spawnfx(i, level._effect["zapper"], self.origin, 0, forward, up);
		triggerfx(self.loopfx[i]);
	}
	level waittill(side + "off");
	for(i = 0; i < self.loopfx.size; i++)
	{
		self.loopfx[i] delete();
	}
	self.loopfx = [];
}

/*
	Name: zapper_switch_fx
	Namespace: zm_sumpf_fx
	Checksum: 0xC994532A
	Offset: 0x17B8
	Size: 0x3EC
	Parameters: 1
	Flags: None
*/
function zapper_switch_fx(ent)
{
	switchfx = struct::get("zapper_switch_fx_" + ent, "targetname");
	zapperfx = struct::get("zapper_fx_" + ent, "targetname");
	switch_forward = anglestoforward(switchfx.angles);
	switch_up = anglestoup(switchfx.angles);
	zapper_forward = anglestoforward(zapperfx.angles);
	zapper_up = anglestoup(zapperfx.angles);
	while(true)
	{
		level waittill(ent);
		if(isdefined(switchfx.loopfx))
		{
			for(i = 0; i < switchfx.loopfx.size; i++)
			{
				switchfx.loopfx[i] delete();
				zapperfx.loopfx[i] delete();
			}
			switchfx.loopfx = [];
			zapperfx.loopfx = [];
		}
		if(!isdefined(switchfx.loopfx))
		{
			switchfx.loopfx = [];
			zapperfx.loopfx = [];
		}
		players = getlocalplayers();
		for(i = 0; i < players.size; i++)
		{
			switchfx.loopfx[i] = spawnfx(i, level._effect["zapper_wall"], switchfx.origin, 0, switch_forward, switch_up);
			triggerfx(switchfx.loopfx[i]);
			zapperfx.loopfx[i] = spawnfx(i, level._effect["zapper_fx"], zapperfx.origin, 0, zapper_forward, zapper_up);
			triggerfx(zapperfx.loopfx[i]);
		}
		wait(30);
		for(i = 0; i < switchfx.loopfx.size; i++)
		{
			switchfx.loopfx[i] delete();
			zapperfx.loopfx[i] delete();
		}
		switchfx.loopfx = [];
		zapperfx.loopfx = [];
	}
}

