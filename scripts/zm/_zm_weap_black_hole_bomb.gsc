// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\zombie_vortex;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_black_hole_bomb;
#using scripts\zm\_zm_zonemgr;

#using_animtree("zombie_cymbal_monkey");

#namespace zm_weap_black_hole_bomb;

/*
	Name: __init__sytem__
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x8B369468
	Offset: 0x7A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_black_hole_bomb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x44F0C8DC
	Offset: 0x7E8
	Size: 0x2BC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	visionset_mgr::register_info("visionset", "zombie_cosmodrome_blackhole", 21000, level.vsmgr_prio_visionset_zombie_vortex + 1, 30, 1, &function_bf9781f8, 1);
	clientfield::register("toplayer", "bhb_viewlights", 21000, 2, "int");
	clientfield::register("scriptmover", "toggle_black_hole_deployed", 21000, 1, "int");
	clientfield::register("actor", "toggle_black_hole_being_pulled", 21000, 1, "int");
	level._effect["black_hole_bomb_portal"] = "dlc5/cosmo/fx_zmb_blackhole_looping";
	level._effect["black_hole_bomb_portal_exit"] = "dlc5/cosmo/fx_zmb_blackhole_exit";
	level._effect["black_hole_bomb_zombie_soul"] = "dlc5/cosmo/fx_zmb_blackhole_zombie_death";
	level._effect["black_hole_bomb_zombie_destroy"] = "dlc5/cosmo/fx_zmb_blackhole_zombie_flare";
	level._effect["black_hole_bomb_zombie_gib"] = "dlc5/zmhd/fx_zombie_dog_explosion";
	level._effect["black_hole_bomb_event_horizon"] = "dlc5/cosmo/fx_zmb_blackhole_implode";
	level._effect["black_hole_samantha_steal"] = "dlc5/cosmo/fx_zmb_blackhole_trap_end";
	level._effect["black_hole_bomb_zombie_pull"] = "dlc5/cosmo/fx_blackhole_zombie_breakup";
	level._effect["black_hole_bomb_marker_flare"] = "dlc5/cosmo/fx_zmb_blackhole_flare_marker";
	/#
		level.zombiemode_devgui_black_hole_bomb_give = &player_give_black_hole_bomb;
	#/
	level.var_4af7fb42 = [];
	level._black_hole_bomb_zombies_anim_change = [];
	level flag::init("bhb_anim_change_allowed");
	level thread black_hole_bomb_throttle_anim_changes();
	level flag::set("bhb_anim_change_allowed");
	level.w_black_hole_bomb = getweapon("black_hole_bomb");
	level.black_hole_bomb_death_start_func = &black_hole_bomb_event_horizon_death;
	level.vortexresetcondition = &zm_behavior::zombiekilledbyblackholebombcondition;
}

/*
	Name: player_give_black_hole_bomb
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x47493AC8
	Offset: 0xAB0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function player_give_black_hole_bomb()
{
	self giveweapon(level.w_black_hole_bomb);
	self zm_utility::set_player_tactical_grenade(level.w_black_hole_bomb);
	self thread player_handle_black_hole_bomb();
	self thread function_e877695e();
}

/*
	Name: player_handle_black_hole_bomb
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xB5C28948
	Offset: 0xB30
	Size: 0x560
	Parameters: 0
	Flags: Linked
*/
function player_handle_black_hole_bomb()
{
	self notify(#"starting_black_hole_bomb");
	self endon(#"disconnect");
	self endon(#"starting_black_hole_bomb");
	attract_dist_diff = level.black_hole_attract_dist_diff;
	if(!isdefined(attract_dist_diff))
	{
		attract_dist_diff = 10;
	}
	num_attractors = level.num_black_hole_bomb_attractors;
	if(!isdefined(num_attractors))
	{
		num_attractors = 15;
	}
	max_attract_dist = level.black_hole_bomb_attract_dist;
	if(!isdefined(max_attract_dist))
	{
		max_attract_dist = 2056;
	}
	while(true)
	{
		grenade = get_thrown_black_hole_bomb();
		if(isdefined(grenade))
		{
			if(self laststand::player_is_in_laststand() || (isdefined(self.intermission) && self.intermission))
			{
				grenade delete();
				continue;
			}
			grenade hide();
			model = util::spawn_model("wpn_t7_zmb_hd_gersch_device_world", grenade.origin);
			model linkto(grenade);
			model.angles = grenade.angles;
			info = spawnstruct();
			info.sound_attractors = [];
			grenade thread monitor_zombie_groans(info);
			velocitysq = 100000000;
			oldpos = grenade.origin;
			while(velocitysq != 0)
			{
				wait(0.05);
				if(!isdefined(grenade))
				{
					break;
				}
				velocitysq = distancesquared(grenade.origin, oldpos);
				oldpos = grenade.origin;
			}
			if(isdefined(grenade))
			{
				self thread black_hole_bomb_kill_counter(grenade);
				model unlink();
				model.origin = grenade.origin;
				model.angles = grenade.angles;
				model._black_hole_bomb_player = self;
				model.targetname = "zm_bhb";
				model._new_ground_trace = 1;
				grenade resetmissiledetonationtime();
				if(isdefined(level.black_hole_bomb_loc_check_func))
				{
					if([[level.black_hole_bomb_loc_check_func]](grenade, model, info))
					{
						continue;
					}
				}
				if(isdefined(level._blackhole_bomb_valid_area_check))
				{
					if([[level._blackhole_bomb_valid_area_check]](grenade, model, self))
					{
						continue;
					}
				}
				valid_poi = zm_utility::is_point_inside_enabled_zone(grenade.origin);
				valid_poi = valid_poi && grenade move_valid_poi_to_navmesh(valid_poi);
				if(valid_poi)
				{
					level thread black_hole_bomb_cleanup(grenade, model);
					if(isdefined(level._black_hole_bomb_poi_override))
					{
						model thread [[level._black_hole_bomb_poi_override]]();
					}
					duration = grenade.weapon.fusetime / 1000;
					self thread zombie_vortex::start_timed_vortex(grenade.origin, 4227136, duration, undefined, undefined, self, level.w_black_hole_bomb, 0, undefined, 0, 0, 0, grenade);
					model clientfield::set("toggle_black_hole_deployed", 1);
					grenade thread function_1ff5cae1();
					level thread black_hole_bomb_teleport_init(grenade);
					grenade.is_valid = 1;
				}
				else
				{
					self.script_noteworthy = undefined;
					level thread black_hole_bomb_stolen_by_sam(self, model);
				}
			}
			else
			{
				self.script_noteworthy = undefined;
				level thread black_hole_bomb_stolen_by_sam(self, model);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_e877695e
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xA3EB8453
	Offset: 0x1098
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_e877695e()
{
	self notify(#"hash_e877695e");
	self endon(#"disconnect");
	self endon(#"hash_e877695e");
	while(true)
	{
		self waittill(#"grenade_pullback", var_f4612f93);
		var_fe9168ca = 0.75;
		if(var_f4612f93 == level.w_black_hole_bomb)
		{
			wait(var_fe9168ca);
			self clientfield::set_to_player("bhb_viewlights", 1);
			wait(3);
			self clientfield::set_to_player("bhb_viewlights", 0);
		}
	}
}

/*
	Name: function_1ff5cae1
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x57949E5D
	Offset: 0x1160
	Size: 0x16A
	Parameters: 0
	Flags: Linked
*/
function function_1ff5cae1()
{
	array::add(level.var_4af7fb42, self);
	foreach(player in level.players)
	{
		visionset_mgr::activate("visionset", "zombie_cosmodrome_blackhole", player);
	}
	self waittill(#"explode");
	arrayremovevalue(level.var_4af7fb42, self);
	foreach(player in level.players)
	{
		visionset_mgr::deactivate("visionset", "zombie_cosmodrome_blackhole", player);
	}
}

/*
	Name: function_bf9781f8
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x22AF6157
	Offset: 0x12D8
	Size: 0x138
	Parameters: 1
	Flags: Linked
*/
function function_bf9781f8(player)
{
	while(level.var_4af7fb42.size > 0)
	{
		var_a81ad02a = 2147483647;
		foreach(bhb in level.var_4af7fb42)
		{
			curr_dist = distancesquared(player.origin, bhb.origin);
			if(curr_dist < var_a81ad02a)
			{
				var_a81ad02a = curr_dist;
			}
		}
		if(var_a81ad02a < 262144)
		{
			visionset_mgr::set_state_active(player, 1 - (var_a81ad02a / 262144));
		}
		wait(0.05);
	}
}

/*
	Name: move_valid_poi_to_navmesh
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x28BC1700
	Offset: 0x1418
	Size: 0x1DA
	Parameters: 1
	Flags: Linked
*/
function move_valid_poi_to_navmesh(valid_poi)
{
	if(!(isdefined(valid_poi) && valid_poi))
	{
		return false;
	}
	if(ispointonnavmesh(self.origin))
	{
		return true;
	}
	v_orig = self.origin;
	queryresult = positionquery_source_navigation(self.origin, 0, 200, 100, 2, 15);
	if(queryresult.data.size)
	{
		foreach(point in queryresult.data)
		{
			height_offset = abs(self.origin[2] - point.origin[2]);
			if(height_offset > 36)
			{
				continue;
			}
			if(bullettracepassed(point.origin + vectorscale((0, 0, 1), 20), v_orig + vectorscale((0, 0, 1), 20), 0, self, undefined, 0, 0))
			{
				self.origin = point.origin;
				return true;
			}
		}
	}
	return false;
}

/*
	Name: wait_for_attractor_positions_complete
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xCA644C76
	Offset: 0x1600
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function wait_for_attractor_positions_complete()
{
	self waittill(#"attractor_positions_generated");
	self.attract_to_origin = 0;
}

/*
	Name: black_hole_bomb_cleanup
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x9A69CC79
	Offset: 0x1628
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function black_hole_bomb_cleanup(parent, model)
{
	model endon(#"sam_stole_it");
	grenade_org = parent.origin;
	while(true)
	{
		if(!isdefined(parent))
		{
			if(isdefined(model))
			{
				model delete();
				util::wait_network_frame();
			}
			break;
		}
		wait(0.05);
	}
	level thread black_hole_bomb_corpse_collect(grenade_org);
}

/*
	Name: black_hole_bomb_corpse_collect
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xF107C05A
	Offset: 0x16D8
	Size: 0xAE
	Parameters: 1
	Flags: Linked
*/
function black_hole_bomb_corpse_collect(vec_origin)
{
	wait(0.1);
	corpse_array = getcorpsearray();
	for(i = 0; i < corpse_array.size; i++)
	{
		if(distancesquared(corpse_array[i].origin, vec_origin) < 36864)
		{
			corpse_array[i] thread black_hole_bomb_corpse_delete();
		}
	}
}

/*
	Name: black_hole_bomb_corpse_delete
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x90F4C449
	Offset: 0x1790
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function black_hole_bomb_corpse_delete()
{
	self delete();
}

/*
	Name: get_thrown_black_hole_bomb
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x765FB71C
	Offset: 0x17B8
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function get_thrown_black_hole_bomb()
{
	self endon(#"disconnect");
	self endon(#"starting_black_hole_bomb");
	while(true)
	{
		self waittill(#"grenade_fire", grenade, weapon);
		if(weapon == level.w_black_hole_bomb)
		{
			grenade.weapon = weapon;
			return grenade;
		}
		wait(0.05);
	}
}

/*
	Name: monitor_zombie_groans
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x2351BE47
	Offset: 0x1840
	Size: 0x1CC
	Parameters: 1
	Flags: Linked
*/
function monitor_zombie_groans(info)
{
	self endon(#"explode");
	while(true)
	{
		if(!isdefined(self))
		{
			return;
		}
		if(!isdefined(self.attractor_array))
		{
			wait(0.05);
			continue;
		}
		for(i = 0; i < self.attractor_array.size; i++)
		{
			if(!isinarray(info.sound_attractors, self.attractor_array[i]))
			{
				if(isdefined(self.origin) && isdefined(self.attractor_array[i].origin))
				{
					if(distancesquared(self.origin, self.attractor_array[i].origin) < 250000)
					{
						if(!isdefined(info.sound_attractors))
						{
							info.sound_attractors = [];
						}
						else if(!isarray(info.sound_attractors))
						{
							info.sound_attractors = array(info.sound_attractors);
						}
						info.sound_attractors[info.sound_attractors.size] = self.attractor_array[i];
						self.attractor_array[i] thread play_zombie_groans();
					}
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: play_zombie_groans
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x688A08AC
	Offset: 0x1A18
	Size: 0x66
	Parameters: 0
	Flags: Linked
*/
function play_zombie_groans()
{
	self endon(#"death");
	self endon(#"black_hole_bomb_blown_up");
	while(true)
	{
		if(isdefined(self))
		{
			self playsound("zmb_vox_zombie_groan");
			wait(randomfloatrange(2, 3));
		}
		else
		{
			return;
		}
	}
}

/*
	Name: black_hole_bomb_exists
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xED75638A
	Offset: 0x1A88
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function black_hole_bomb_exists()
{
	return isdefined(level.zombie_weapons["black_hole_bomb"]);
}

/*
	Name: black_hole_bomb_store_movement_anim
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xD1F0FC9A
	Offset: 0x1AA8
	Size: 0xD4
	Parameters: 0
	Flags: None
*/
function black_hole_bomb_store_movement_anim()
{
	self endon(#"death");
	current_anim = self.run_combatanim;
	anim_keys = getarraykeys(level.scr_anim[self.animname]);
	for(j = 0; j < anim_keys.size; j++)
	{
		if(level.scr_anim[self.animname][anim_keys[j]] == current_anim)
		{
			return anim_keys[j];
		}
	}
	/#
		assertmsg("");
	#/
}

/*
	Name: black_hole_bomb_being_pulled_fx
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x60677A7D
	Offset: 0x1B88
	Size: 0x50
	Parameters: 0
	Flags: None
*/
function black_hole_bomb_being_pulled_fx()
{
	self endon(#"death");
	util::wait_network_frame();
	self clientfield::set("toggle_black_hole_being_pulled", 1);
	self._black_hole_bomb_being_pulled_in_fx = 1;
}

/*
	Name: black_hole_bomb_event_horizon_death
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xE9FB3595
	Offset: 0x1BE0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function black_hole_bomb_event_horizon_death(vec_black_hole_org, grenade)
{
	self zombie_utility::zombie_eye_glow_stop();
	self playsound("zmb_bhbomb_zombie_explode");
}

/*
	Name: black_hole_bomb_corpse_hide
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x305E4DC1
	Offset: 0x1C38
	Size: 0xA8
	Parameters: 0
	Flags: None
*/
function black_hole_bomb_corpse_hide()
{
	if(isdefined(self._black_hole_bomb_collapse_death) && self._black_hole_bomb_collapse_death == 1)
	{
		fxorigin = self gettagorigin("tag_origin");
		playfx(level._effect["black_hole_bomb_zombie_gib"], fxorigin);
		self hide();
	}
}

/*
	Name: black_hole_bomb_throttle_anim_changes
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xDF8F86A
	Offset: 0x1CE8
	Size: 0x260
	Parameters: 0
	Flags: Linked
*/
function black_hole_bomb_throttle_anim_changes()
{
	if(!isdefined(level._black_hole_bomb_zombies_anim_change))
	{
		level._black_hole_bomb_zombies_anim_change = [];
	}
	int_max_num_zombies_per_frame = 7;
	array_zombies_allowed_to_switch = [];
	while(isdefined(level._black_hole_bomb_zombies_anim_change))
	{
		if(level._black_hole_bomb_zombies_anim_change.size == 0)
		{
			wait(0.1);
			continue;
		}
		array_zombies_allowed_to_switch = level._black_hole_bomb_zombies_anim_change;
		for(i = 0; i < array_zombies_allowed_to_switch.size; i++)
		{
			if(isdefined(array_zombies_allowed_to_switch[i]) && isalive(array_zombies_allowed_to_switch[i]))
			{
				array_zombies_allowed_to_switch[i] flag::set("bhb_anim_change");
			}
			if(i >= int_max_num_zombies_per_frame)
			{
				break;
			}
		}
		level flag::clear("bhb_anim_change_allowed");
		for(i = 0; i < array_zombies_allowed_to_switch.size; i++)
		{
			if(!isdefined(array_zombies_allowed_to_switch[i]._bhb_ent_flag_init))
			{
				array_zombies_allowed_to_switch[i] flag::init("bhb_anim_change");
				array_zombies_allowed_to_switch[i]._bhb_ent_flag_init = 1;
			}
			if(array_zombies_allowed_to_switch[i] flag::get("bhb_anim_change"))
			{
				arrayremovevalue(level._black_hole_bomb_zombies_anim_change, array_zombies_allowed_to_switch[i]);
			}
		}
		level._black_hole_bomb_zombies_anim_change = array::remove_dead(level._black_hole_bomb_zombies_anim_change);
		arrayremovevalue(level._black_hole_bomb_zombies_anim_change, undefined);
		level flag::set("bhb_anim_change_allowed");
		util::wait_network_frame();
		wait(0.1);
	}
}

/*
	Name: black_hole_bomb_teleport_init
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x72CFDBCF
	Offset: 0x1F50
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function black_hole_bomb_teleport_init(ent_grenade)
{
	if(!isdefined(ent_grenade))
	{
		return;
	}
	teleport_trigger = spawn("trigger_radius", ent_grenade.origin, 0, 64, 70);
	ent_grenade thread black_hole_bomb_trigger_monitor(teleport_trigger);
	ent_grenade waittill(#"explode");
	teleport_trigger notify(#"black_hole_complete");
	wait(0.1);
	teleport_trigger delete();
}

/*
	Name: black_hole_bomb_trigger_monitor
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x7278302D
	Offset: 0x2008
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function black_hole_bomb_trigger_monitor(ent_trigger)
{
	ent_trigger endon(#"black_hole_complete");
	while(true)
	{
		ent_trigger waittill(#"trigger", ent_player);
		if(isplayer(ent_player) && !ent_player isonground() && (!(isdefined(ent_player.lander) && ent_player.lander)))
		{
			ent_trigger thread black_hole_teleport_trigger_thread(ent_player, &black_hole_time_before_teleport, &black_hole_teleport_cancel);
		}
		wait(0.1);
	}
}

/*
	Name: black_hole_time_before_teleport
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x47308103
	Offset: 0x20F0
	Size: 0x224
	Parameters: 2
	Flags: Linked
*/
function black_hole_time_before_teleport(ent_player, str_endon)
{
	ent_player endon(str_endon);
	if(!bullettracepassed(ent_player geteye(), self.origin + vectorscale((0, 0, 1), 65), 0, ent_player))
	{
		return;
	}
	black_hole_teleport_structs = struct::get_array("struct_black_hole_teleport", "targetname");
	chosen_spot = undefined;
	if(isdefined(level._special_blackhole_bomb_structs))
	{
		black_hole_teleport_structs = [[level._special_blackhole_bomb_structs]]();
	}
	if(!isdefined(black_hole_teleport_structs) || black_hole_teleport_structs.size == 0)
	{
		return;
	}
	black_hole_teleport_structs = array::randomize(black_hole_teleport_structs);
	if(isdefined(level._override_blackhole_destination_logic))
	{
		chosen_spot = [[level._override_blackhole_destination_logic]](black_hole_teleport_structs, ent_player);
	}
	else
	{
		for(i = 0; i < black_hole_teleport_structs.size; i++)
		{
			if(zm_utility::check_point_in_enabled_zone(black_hole_teleport_structs[i].origin) && ent_player zm_utility::get_current_zone() != black_hole_teleport_structs[i].script_string)
			{
				chosen_spot = black_hole_teleport_structs[i];
				break;
			}
		}
	}
	if(isdefined(chosen_spot))
	{
		self playsound("zmb_gersh_teleporter_out");
		ent_player playsoundtoplayer("zmb_gersh_teleporter_out_plr", ent_player);
		ent_player thread black_hole_teleport(chosen_spot);
	}
}

/*
	Name: black_hole_teleport_cancel
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x8F0B58E2
	Offset: 0x2320
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function black_hole_teleport_cancel(ent_player)
{
}

/*
	Name: black_hole_teleport
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x60A4CFA7
	Offset: 0x2338
	Size: 0x24C
	Parameters: 1
	Flags: Linked
*/
function black_hole_teleport(struct_dest)
{
	self endon(#"death");
	if(!isdefined(struct_dest))
	{
		return;
	}
	prone_offset = vectorscale((0, 0, 1), 49);
	crouch_offset = vectorscale((0, 0, 1), 20);
	stand_offset = (0, 0, 0);
	destination = undefined;
	if(self getstance() == "prone")
	{
		destination = struct_dest.origin + prone_offset;
	}
	else
	{
		if(self getstance() == "crouch")
		{
			destination = struct_dest.origin + crouch_offset;
		}
		else
		{
			destination = struct_dest.origin + stand_offset;
		}
	}
	if(isdefined(level._black_hole_teleport_override))
	{
		level [[level._black_hole_teleport_override]](self);
	}
	black_hole_bomb_create_exit_portal(struct_dest.origin);
	self freezecontrols(1);
	self disableoffhandweapons();
	self disableweapons();
	self dontinterpolate();
	self setorigin(destination);
	self setplayerangles(struct_dest.angles);
	self enableoffhandweapons();
	self enableweapons();
	self freezecontrols(0);
	self thread slightly_delayed_player_response();
}

/*
	Name: slightly_delayed_player_response
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x6D634FC
	Offset: 0x2590
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function slightly_delayed_player_response()
{
	wait(1);
	self zm_audio::create_and_play_dialog("general", "teleport_gersh");
}

/*
	Name: black_hole_teleport_trigger_thread
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xFAEC90A5
	Offset: 0x25C8
	Size: 0x144
	Parameters: 3
	Flags: Linked
*/
function black_hole_teleport_trigger_thread(ent, on_enter_payload, on_exit_payload)
{
	ent endon(#"death");
	self endon(#"black_hole_complete");
	if(ent black_hole_teleport_ent_already_in_trigger(self))
	{
		return;
	}
	self black_hole_teleport_add_trigger_to_ent(ent);
	endon_condition = "leave_trigger_" + self getentitynumber();
	if(isdefined(on_enter_payload))
	{
		self thread [[on_enter_payload]](ent, endon_condition);
	}
	while(isdefined(ent) && ent istouching(self) && isdefined(self))
	{
		wait(0.01);
	}
	ent notify(endon_condition);
	if(isdefined(ent) && isdefined(on_exit_payload))
	{
		self thread [[on_exit_payload]](ent);
	}
	if(isdefined(ent))
	{
		self black_hole_teleport_remove_trigger_from_ent(ent);
	}
}

/*
	Name: black_hole_teleport_add_trigger_to_ent
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x6293F7B1
	Offset: 0x2718
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function black_hole_teleport_add_trigger_to_ent(ent)
{
	if(!isdefined(ent._triggers))
	{
		ent._triggers = [];
	}
	ent._triggers[self getentitynumber()] = 1;
}

/*
	Name: black_hole_teleport_remove_trigger_from_ent
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x6E58570D
	Offset: 0x2780
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function black_hole_teleport_remove_trigger_from_ent(ent)
{
	if(!isdefined(ent._triggers))
	{
		return;
	}
	if(!isdefined(ent._triggers[self getentitynumber()]))
	{
		return;
	}
	ent._triggers[self getentitynumber()] = 0;
}

/*
	Name: black_hole_teleport_ent_already_in_trigger
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xF25D610F
	Offset: 0x27F8
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function black_hole_teleport_ent_already_in_trigger(trig)
{
	if(!isdefined(self._triggers))
	{
		return false;
	}
	if(!isdefined(self._triggers[trig getentitynumber()]))
	{
		return false;
	}
	if(!self._triggers[trig getentitynumber()])
	{
		return false;
	}
	return true;
}

/*
	Name: black_hole_bomb_kill_counter
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x7051958
	Offset: 0x2870
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function black_hole_bomb_kill_counter(grenade)
{
	self endon(#"death");
	grenade endon(#"death");
	kill_count = 0;
	for(;;)
	{
		grenade waittill(#"black_hole_bomb_kill");
		kill_count++;
		if(kill_count == 4)
		{
			self zm_audio::create_and_play_dialog("kill", "gersh_device");
		}
		if(5 <= kill_count)
		{
			self notify(#"black_hole_kills_achievement");
		}
	}
}

/*
	Name: black_hole_bomb_create_exit_portal
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xD51B1AEB
	Offset: 0x2918
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function black_hole_bomb_create_exit_portal(pos)
{
	exit_portal_fx_spot = spawn("script_model", pos);
	exit_portal_fx_spot setmodel("tag_origin");
	playfxontag(level._effect["black_hole_bomb_portal_exit"], exit_portal_fx_spot, "tag_origin");
	exit_portal_fx_spot thread black_hole_bomb_exit_clean_up();
	exit_portal_fx_spot playsound("wpn_bhbomb_portal_exit_start");
	exit_portal_fx_spot playloopsound("wpn_bhbomb_portal_exit_loop", 0.2);
}

/*
	Name: black_hole_bomb_exit_clean_up
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0xEC7A3F6C
	Offset: 0x2A08
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function black_hole_bomb_exit_clean_up()
{
	wait(4);
	playsoundatposition("wpn_bhbomb_portal_exit_pop", self.origin);
	self delete();
}

/*
	Name: black_hole_bomb_stolen_by_sam
	Namespace: zm_weap_black_hole_bomb
	Checksum: 0x15432CD3
	Offset: 0x2A58
	Size: 0x224
	Parameters: 2
	Flags: Linked
*/
function black_hole_bomb_stolen_by_sam(ent_grenade, ent_model)
{
	if(!isdefined(ent_model))
	{
		return;
	}
	direction = ent_model.origin;
	direction = (direction[1], direction[0], 0);
	if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if(direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isalive(players[i]))
		{
			players[i] playlocalsound(level.zmb_laugh_alias);
		}
	}
	playfxontag(level._effect["black_hole_samantha_steal"], ent_model, "tag_origin");
	ent_model movez(60, 1, 0.25, 0.25);
	ent_model vibrate(direction, 1.5, 2.5, 1);
	ent_model waittill(#"movedone");
	ent_model delete();
}

