// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

#namespace zm_asylum_fx;

/*
	Name: main
	Namespace: zm_asylum_fx
	Checksum: 0x3C90F6AC
	Offset: 0x10F0
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache_createfx_fx();
	disablefx = getdvarint("disable_fx");
	if(!isdefined(disablefx) || disablefx <= 0)
	{
		precache_scripted_fx();
	}
	level thread perk_wire_fx("revive_on", "revive_electric_wire");
	level thread perk_wire_fx("middle_door_open", "electric_middle_door");
	level thread perk_wire_fx("fast_reload_on", "electric_fast_reload");
	level thread perk_wire_fx("doubletap_on", "electric_double_tap");
	level thread perk_wire_fx("jugger_on", "electric_juggernog");
}

/*
	Name: function_dc095355
	Namespace: zm_asylum_fx
	Checksum: 0x18E2801E
	Offset: 0x1228
	Size: 0x244
	Parameters: 2
	Flags: Linked
*/
function function_dc095355(ent, localclientnum)
{
	switchfx = struct::get("zapper_switch_fx_" + ent, "targetname");
	zapperfx = struct::get("zapper_fx_" + ent, "targetname");
	switch_forward = anglestoforward(switchfx.angles);
	switch_up = anglestoup(switchfx.angles);
	zapper_forward = anglestoforward(zapperfx.angles);
	zapper_up = anglestoup(zapperfx.angles);
	if(isdefined(switchfx.loopfx))
	{
		switchfx.loopfx delete();
		zapperfx.loopfx delete();
	}
	switchfx.loopfx = spawnfx(localclientnum, level._effect["zapper_wall"], switchfx.origin, 0, switch_forward, switch_up);
	triggerfx(switchfx.loopfx);
	zapperfx.loopfx = spawnfx(localclientnum, level._effect["zapper_fx"], zapperfx.origin, 0, zapper_forward, zapper_up);
	triggerfx(zapperfx.loopfx);
}

/*
	Name: function_1c1a68e1
	Namespace: zm_asylum_fx
	Checksum: 0x771CF514
	Offset: 0x1478
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_1c1a68e1(ent)
{
	switchfx = struct::get("zapper_switch_fx_" + ent, "targetname");
	zapperfx = struct::get("zapper_fx_" + ent, "targetname");
	if(isdefined(switchfx.loopfx))
	{
		switchfx.loopfx delete();
		zapperfx.loopfx delete();
	}
}

/*
	Name: perk_wire_fx
	Namespace: zm_asylum_fx
	Checksum: 0xCC4957F
	Offset: 0x1550
	Size: 0x128
	Parameters: 2
	Flags: Linked
*/
function perk_wire_fx(notify_wait, init_targetname)
{
	level waittill(notify_wait);
	targ = struct::get(init_targetname, "targetname");
	while(isdefined(targ))
	{
		players = getlocalplayers();
		for(i = 0; i < players.size; i++)
		{
			playfx(i, level._effect["electric_short_oneshot"], targ.origin);
		}
		wait(0.075);
		if(isdefined(targ.target))
		{
			targ = struct::get(targ.target, "targetname");
		}
		else
		{
			targ = undefined;
		}
	}
}

/*
	Name: function_93f91575
	Namespace: zm_asylum_fx
	Checksum: 0x84AC52A0
	Offset: 0x1680
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function function_93f91575(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		level thread function_46f37b91("north", localclientnum);
		function_dc095355("north", localclientnum);
	}
	else
	{
		function_576a2cdd("north");
		function_1c1a68e1("north");
	}
}

/*
	Name: function_4c17ba1b
	Namespace: zm_asylum_fx
	Checksum: 0xC9CE3E34
	Offset: 0x1748
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function function_4c17ba1b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		level thread function_46f37b91("south", localclientnum);
		function_dc095355("south", localclientnum);
	}
	else
	{
		function_576a2cdd("south");
		function_1c1a68e1("south");
	}
}

/*
	Name: function_46f37b91
	Namespace: zm_asylum_fx
	Checksum: 0xA29E99B7
	Offset: 0x1810
	Size: 0x178
	Parameters: 2
	Flags: Linked
*/
function function_46f37b91(str_side, localclientnum)
{
	ent = struct::get("trap_wire_sparks_" + str_side, "targetname");
	ent.fx = 1;
	while(isdefined(ent.fx))
	{
		targ = struct::get(ent.target, "targetname");
		while(isdefined(targ))
		{
			if(randomint(100) > 50)
			{
				playfx(localclientnum, level._effect["electric_short_oneshot"], targ.origin);
			}
			wait(0.075);
			if(isdefined(targ.target))
			{
				targ = struct::get(targ.target, "targetname");
			}
			else
			{
				targ = undefined;
			}
		}
		wait(randomintrange(10, 15));
	}
}

/*
	Name: function_576a2cdd
	Namespace: zm_asylum_fx
	Checksum: 0xABE4814A
	Offset: 0x1990
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function function_576a2cdd(str_side)
{
	ent = struct::get("trap_wire_sparks_" + str_side, "targetname");
	ent.fx = undefined;
}

/*
	Name: precache_scripted_fx
	Namespace: zm_asylum_fx
	Checksum: 0xD15E433C
	Offset: 0x19E8
	Size: 0x1FA
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["zombie_grain"] = "misc/fx_zombie_grain_cloud";
	level._effect["zapper_fx"] = "dlc5/zmhd/fx_zombie_zapper_powerbox_on";
	level._effect["zapper_wall"] = "dlc5/zmhd/fx_zombie_zapper_wall_control_on";
	level._effect["zapper_light_ready"] = "dlc5/zmhd/fx_zombie_zapper_light_green";
	level._effect["zapper_light_notready"] = "dlc5/zmhd/fx_zombie_zapper_light_red";
	level._effect["elec_trail_one_shot"] = "maps/zombie/fx_zombie_elec_trail_oneshot";
	level._effect["electric_short_oneshot"] = "dlc5/zmhd/fx_elec_sparking_oneshot";
	level._effect["wire_sparks_oneshot"] = "env/electrical/fx_elec_wire_spark_dl_oneshot";
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange";
	level._effect["headshot"] = "impacts/fx_flesh_hit";
	level._effect["headshot_nochunks"] = "misc/fx_zombie_bloodsplat";
	level._effect["bloodspurt"] = "misc/fx_zombie_bloodspurt";
	level._effect["animscript_gib_fx"] = "weapon/bullet/fx_flesh_gib_fatal_01";
	level._effect["animscript_gibtrail_fx"] = "trail/fx_trail_blood_streak";
	level._effect["perk_machine_light_yellow"] = "dlc5/zmhd/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc5/zmhd/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc5/zmhd/fx_wonder_fizz_light_green";
}

/*
	Name: precache_createfx_fx
	Namespace: zm_asylum_fx
	Checksum: 0xC2AC7C3B
	Offset: 0x1BF0
	Size: 0x622
	Parameters: 0
	Flags: Linked
*/
function precache_createfx_fx()
{
	level._effect["god_rays_small"] = "env/light/fx_light_god_ray_sm_single";
	level._effect["god_rays_dust_motes"] = "env/light/fx_light_god_rays_dust_motes";
	level._effect["light_ceiling_dspot"] = "env/light/fx_ray_ceiling_amber_dim_sm";
	level._effect["dlight_fire_glow"] = "env/light/fx_dlight_fire_glow";
	level._effect["fire_detail"] = "env/fire/fx_fire_debris_xsmall";
	level._effect["fire_static_small"] = "env/fire/fx_static_fire_sm_ndlight";
	level._effect["fire_static_blk_smk"] = "env/fire/fx_static_fire_md_ndlight";
	level._effect["fire_column_creep_xsm"] = "env/fire/fx_fire_column_creep_xsm";
	level._effect["fire_column_creep_sm"] = "env/fire/fx_fire_column_creep_sm";
	level._effect["fire_distant_150_600"] = "env/fire/fx_fire_150x600_tall_distant";
	level._effect["fire_window"] = "env/fire/fx_fire_win_nsmk_0x35y50z";
	level._effect["fire_tree_trunk"] = "maps/mp_maps/fx_mp_fire_tree_trunk";
	level._effect["fire_rubble_sm_column"] = "maps/mp_maps/fx_mp_fire_rubble_small_column";
	level._effect["fire_rubble_sm_column_smldr"] = "maps/mp_maps/fx_mp_fire_rubble_small_column_smldr";
	level._effect["ash_and_embers"] = "env/fire/fx_ash_embers_light";
	level._effect["smoke_room_fill"] = "maps/ber2/fx_smoke_fill_indoor";
	level._effect["smoke_window_out_small"] = "env/smoke/fx_smoke_door_top_exit_drk";
	level._effect["smoke_plume_xlg_slow_blk"] = "maps/ber2/fx_smk_plume_xlg_slow_blk_w";
	level._effect["smoke_hallway_faint_dark"] = "env/smoke/fx_smoke_hallway_faint_dark";
	level._effect["brush_smoke_smolder_sm"] = "env/smoke/fx_smoke_brush_smolder_md";
	level._effect["smoke_fire_column_short"] = "maps/mp_maps/fx_mp_smoke_fire_column_short";
	level._effect["smoke_impact_smolder_w"] = "env/smoke/fx_smoke_crater_w";
	level._effect["smoke_column_tall"] = "maps/mp_maps/fx_mp_smoke_column_tall";
	level._effect["fog_thick"] = "env/smoke/fx_fog_rolling_thick_zombie";
	level._effect["fog_low_floor"] = "env/smoke/fx_fog_low_floor_sm";
	level._effect["fog_low_thick"] = "env/smoke/fx_fog_low_thick_sm";
	level._effect["blood_drips"] = "system_elements/fx_blood_drips_looped_decal";
	level._effect["insect_lantern"] = "maps/mp_maps/fx_mp_insects_lantern";
	level._effect["insect_swarm"] = "maps/mp_maps/fx_mp_insect_swarm";
	level._effect["insect_flies_carcass"] = "maps/mp_maps/fx_mp_flies_carcass";
	level._effect["water_spill_fall"] = "maps/mp_maps/fx_mp_water_spill";
	level._effect["water_leak_runner"] = "env/water/fx_water_leak_runner_100";
	level._effect["water_spill_splash"] = "maps/mp_maps/fx_mp_water_spill_splash";
	level._effect["water_heavy_leak"] = "env/water/fx_water_drips_hvy";
	level._effect["water_drip_sm_area"] = "maps/mp_maps/fx_mp_water_drip";
	level._effect["water_spill_long"] = "maps/mp_maps/fx_mp_water_spill_long";
	level._effect["water_drips_hvy_long"] = "maps/mp_maps/fx_mp_water_drips_hvy_long";
	level._effect["water_spill_splatter"] = "maps/mp_maps/fx_mp_water_spill_splatter";
	level._effect["water_splash_small"] = "maps/mp_maps/fx_mp_water_splash_small";
	level._effect["wire_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["wire_sparks_blue"] = "env/electrical/fx_elec_wire_spark_burst_blue";
	level._effect["betty_explode"] = "weapon/bouncing_betty/fx_explosion_betty_generic";
	level._effect["betty_trail"] = "weapon/bouncing_betty/fx_betty_trail";
	level._effect["zapper"] = "dlc0/factory/fx_elec_trap_factory";
	level._effect["switch_sparks"] = "env/electrical/fx_elec_wire_spark_burst";
	level._effect["fx_zm_asylum_fire_tree"] = "maps/zombie/fx_zm_asylum_fire_tree";
	level._effect["fx_zm_asylum_fire_sm"] = "maps/zombie/fx_zm_asylum_fire_sm";
	level._effect["fx_zm_asylum_fire_md"] = "maps/zombie/fx_zm_asylum_fire_md";
	level._effect["fx_zm_asylum_fire_lg"] = "maps/zombie/fx_zm_asylum_fire_lg";
	level._effect["fx_light_godray_md_asylum"] = "maps/zombie/fx_zm_asylum_godray_md";
	level._effect["fx_zm_asylum_ray_fire"] = "maps/zombie/fx_zm_asylum_ray_fire";
	level._effect["fx_zm_asylum_ray_fire_thin"] = "maps/zombie/fx_zm_asylum_ray_fire_thin";
	level._effect["fx_zm_proto_fire_detail"] = "maps/zombie/fx_zm_proto_fire_detail";
	level._effect["fx_zm_asylum_water_leak"] = "maps/zombie/fx_zm_asylum_water_leak";
	level._effect["chair_light_fx"] = "env/light/fx_glow_hanginglamp";
	level._effect["perk_machine_location"] = "dlc5/prototype/fx_wonder_fizz_lightning_all_interior";
}

