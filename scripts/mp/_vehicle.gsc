// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_qrdrone;
#using scripts\mp\killstreaks\_rcbomb;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;

#using_animtree("mp_vehicles");

#namespace vehicle;

/*
	Name: __init__sytem__
	Namespace: vehicle
	Checksum: 0x118588F
	Offset: 0xC98
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicle", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: vehicle
	Checksum: 0x4AC9BC32
	Offset: 0xCD8
	Size: 0x742
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	setdvar("scr_veh_cleanupdebugprint", "0");
	setdvar("scr_veh_driversarehidden", "1");
	setdvar("scr_veh_driversareinvulnerable", "1");
	setdvar("scr_veh_alive_cleanuptimemin", "119");
	setdvar("scr_veh_alive_cleanuptimemax", "120");
	setdvar("scr_veh_dead_cleanuptimemin", "20");
	setdvar("scr_veh_dead_cleanuptimemax", "30");
	setdvar("scr_veh_cleanuptime_dmgfactor_min", "0.33");
	setdvar("scr_veh_cleanuptime_dmgfactor_max", "1.0");
	setdvar("scr_veh_cleanuptime_dmgfactor_deadtread", "0.25");
	setdvar("scr_veh_cleanuptime_dmgfraction_curve_begin", "0.0");
	setdvar("scr_veh_cleanuptime_dmgfraction_curve_end", "1.0");
	setdvar("scr_veh_cleanupabandoned", "1");
	setdvar("scr_veh_cleanupdrifted", "1");
	setdvar("scr_veh_cleanupmaxspeedmph", "1");
	setdvar("scr_veh_cleanupmindistancefeet", "75");
	setdvar("scr_veh_waittillstoppedandmindist_maxtime", "10");
	setdvar("scr_veh_waittillstoppedandmindist_maxtimeenabledistfeet", "5");
	setdvar("scr_veh_respawnafterhuskcleanup", "1");
	setdvar("scr_veh_respawntimemin", "50");
	setdvar("scr_veh_respawntimemax", "90");
	setdvar("scr_veh_respawnwait_maxiterations", "30");
	setdvar("scr_veh_respawnwait_iterationwaitseconds", "1");
	setdvar("scr_veh_disablerespawn", "0");
	setdvar("scr_veh_disableoverturndamage", "0");
	setdvar("scr_veh_explosion_spawnfx", "1");
	setdvar("scr_veh_explosion_doradiusdamage", "1");
	setdvar("scr_veh_explosion_radius", "256");
	setdvar("scr_veh_explosion_mindamage", "20");
	setdvar("scr_veh_explosion_maxdamage", "200");
	setdvar("scr_veh_ondeath_createhusk", "1");
	setdvar("scr_veh_ondeath_usevehicleashusk", "1");
	setdvar("scr_veh_explosion_husk_forcepointvariance", "30");
	setdvar("scr_veh_explosion_husk_horzvelocityvariance", "25");
	setdvar("scr_veh_explosion_husk_vertvelocitymin", "100");
	setdvar("scr_veh_explosion_husk_vertvelocitymax", "200");
	setdvar("scr_veh_explode_on_cleanup", "1");
	setdvar("scr_veh_disappear_maxwaittime", "60");
	setdvar("scr_veh_disappear_maxpreventdistancefeet", "30");
	setdvar("scr_veh_disappear_maxpreventvisibilityfeet", "150");
	setdvar("scr_veh_health_tank", "1350");
	level.vehicle_drivers_are_invulnerable = getdvarint("scr_veh_driversareinvulnerable");
	level.onejectoccupants = &vehicle_eject_all_occupants;
	level.vehiclehealths["panzer4_mp"] = 2600;
	level.vehiclehealths["t34_mp"] = 2600;
	setdvar("scr_veh_health_jeep", "700");
	if(init_vehicle_entities())
	{
		level.vehicle_explosion_effect = "_t6/vehicle/vexplosion/fx_vexplode_helicopter_exp_mp";
		level.veh_husk_models = [];
		level.veh_husk_effects = [];
		if(isdefined(level.use_new_veh_husks))
		{
			level.veh_husk_models["t34_mp"] = "veh_t34_destroyed_mp";
		}
		if(isdefined(level.onaddvehiclehusks))
		{
			[[level.onaddvehiclehusks]]();
		}
	}
	chopper_player_get_on_gun = %mp_vehicles::int_huey_gunner_on;
	chopper_door_open = %mp_vehicles::v_huey_door_open;
	chopper_door_open_state = %mp_vehicles::v_huey_door_open_state;
	chopper_door_closed_state = %mp_vehicles::v_huey_door_close_state;
	killbrushes = getentarray("water_killbrush", "targetname");
	foreach(brush in killbrushes)
	{
		brush thread water_killbrush_think();
	}
}

/*
	Name: water_killbrush_think
	Namespace: vehicle
	Checksum: 0x3AAD7ABD
	Offset: 0x1428
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function water_killbrush_think()
{
	for(;;)
	{
		self waittill(#"trigger", entity);
		if(isdefined(entity))
		{
			if(isdefined(entity.targetname))
			{
				if(entity.targetname == "rcbomb")
				{
					entity notify(#"rcbomb_shutdown");
				}
				else if(entity.targetname == "talon" && (!(isdefined(entity.dead) && entity.dead)))
				{
					entity notify(#"death");
				}
			}
			if(isdefined(entity.helitype) && entity.helitype == "qrdrone")
			{
				entity qrdrone::qrdrone_force_destroy();
			}
		}
	}
}

/*
	Name: initialize_vehicle_damage_effects_for_level
	Namespace: vehicle
	Checksum: 0x25E1E79
	Offset: 0x1538
	Size: 0x62A
	Parameters: 0
	Flags: None
*/
function initialize_vehicle_damage_effects_for_level()
{
	k_mild_damage_index = 0;
	k_moderate_damage_index = 1;
	k_severe_damage_index = 2;
	k_total_damage_index = 3;
	k_mild_damage_health_percentage = 0.85;
	k_moderate_damage_health_percentage = 0.55;
	k_severe_damage_health_percentage = 0.35;
	k_total_damage_health_percentage = 0;
	level.k_mild_damage_health_percentage = k_mild_damage_health_percentage;
	level.k_moderate_damage_health_percentage = k_moderate_damage_health_percentage;
	level.k_severe_damage_health_percentage = k_severe_damage_health_percentage;
	level.k_total_damage_health_percentage = k_total_damage_health_percentage;
	level.vehicles_damage_states = [];
	level.vehicles_husk_effects = [];
	level.vehicles_damage_treadfx = [];
	vehicle_name = get_default_vehicle_name();
	level.vehicles_damage_states[vehicle_name] = [];
	level.vehicles_damage_treadfx[vehicle_name] = [];
	level.vehicles_damage_states[vehicle_name][k_mild_damage_index] = spawnstruct();
	level.vehicles_damage_states[vehicle_name][k_mild_damage_index].health_percentage = k_mild_damage_health_percentage;
	level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array = [];
	level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0] = spawnstruct();
	level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0].damage_effect = "_t6/vehicle/vfire/fx_tank_sherman_smldr";
	level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0].sound_effect = undefined;
	level.vehicles_damage_states[vehicle_name][k_mild_damage_index].effect_array[0].vehicle_tag = "tag_origin";
	level.vehicles_damage_states[vehicle_name][k_moderate_damage_index] = spawnstruct();
	level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].health_percentage = k_moderate_damage_health_percentage;
	level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array = [];
	level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0] = spawnstruct();
	level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0].damage_effect = "_t6/vehicle/vfire/fx_vfire_med_12";
	level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0].sound_effect = undefined;
	level.vehicles_damage_states[vehicle_name][k_moderate_damage_index].effect_array[0].vehicle_tag = "tag_origin";
	level.vehicles_damage_states[vehicle_name][k_severe_damage_index] = spawnstruct();
	level.vehicles_damage_states[vehicle_name][k_severe_damage_index].health_percentage = k_severe_damage_health_percentage;
	level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array = [];
	level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0] = spawnstruct();
	level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0].damage_effect = "_t6/vehicle/vfire/fx_vfire_sherman";
	level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0].sound_effect = undefined;
	level.vehicles_damage_states[vehicle_name][k_severe_damage_index].effect_array[0].vehicle_tag = "tag_origin";
	level.vehicles_damage_states[vehicle_name][k_total_damage_index] = spawnstruct();
	level.vehicles_damage_states[vehicle_name][k_total_damage_index].health_percentage = k_total_damage_health_percentage;
	level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array = [];
	level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0] = spawnstruct();
	level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0].damage_effect = "_t6/vehicle/vexplosion/fx_vexplode_helicopter_exp_mp";
	level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0].sound_effect = "vehicle_explo";
	level.vehicles_damage_states[vehicle_name][k_total_damage_index].effect_array[0].vehicle_tag = "tag_origin";
	default_husk_effects = spawnstruct();
	default_husk_effects.damage_effect = undefined;
	default_husk_effects.sound_effect = undefined;
	default_husk_effects.vehicle_tag = "tag_origin";
	level.vehicles_husk_effects[vehicle_name] = default_husk_effects;
}

/*
	Name: get_vehicle_name
	Namespace: vehicle
	Checksum: 0x7149B778
	Offset: 0x1B70
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function get_vehicle_name(vehicle)
{
	name = "";
	if(isdefined(vehicle))
	{
		if(isdefined(vehicle.vehicletype))
		{
			name = vehicle.vehicletype;
		}
	}
	return name;
}

/*
	Name: get_default_vehicle_name
	Namespace: vehicle
	Checksum: 0xA7A2BE51
	Offset: 0x1BD0
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_default_vehicle_name()
{
	return "defaultvehicle_mp";
}

/*
	Name: get_vehicle_name_key_for_damage_states
	Namespace: vehicle
	Checksum: 0x464805ED
	Offset: 0x1BE8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function get_vehicle_name_key_for_damage_states(vehicle)
{
	vehicle_name = get_vehicle_name(vehicle);
	if(!isdefined(level.vehicles_damage_states) || !isdefined(level.vehicles_damage_states[vehicle_name]))
	{
		vehicle_name = get_default_vehicle_name();
	}
	return vehicle_name;
}

/*
	Name: get_vehicle_damage_state_index_from_health_percentage
	Namespace: vehicle
	Checksum: 0x84CE34F6
	Offset: 0x1C60
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function get_vehicle_damage_state_index_from_health_percentage(vehicle)
{
	if(!isdefined(level.vehicles_damage_states))
	{
		return -1;
	}
	damage_state_index = -1;
	vehicle_name = get_vehicle_name_key_for_damage_states();
	for(test_index = 0; test_index < level.vehicles_damage_states[vehicle_name].size; test_index++)
	{
		if(vehicle.current_health_percentage <= level.vehicles_damage_states[vehicle_name][test_index].health_percentage)
		{
			damage_state_index = test_index;
			continue;
		}
		break;
	}
	return damage_state_index;
}

/*
	Name: update_damage_effects
	Namespace: vehicle
	Checksum: 0xD56E85E5
	Offset: 0x1D30
	Size: 0x14C
	Parameters: 2
	Flags: Linked
*/
function update_damage_effects(vehicle, attacker)
{
	if(vehicle.initial_state.health > 0)
	{
		previous_damage_state_index = get_vehicle_damage_state_index_from_health_percentage(vehicle);
		vehicle.current_health_percentage = vehicle.health / vehicle.initial_state.health;
		current_damage_state_index = get_vehicle_damage_state_index_from_health_percentage(vehicle);
		if(previous_damage_state_index != current_damage_state_index)
		{
			vehicle notify(#"damage_state_changed");
			if(previous_damage_state_index < 0)
			{
				start_damage_state_index = 0;
			}
			else
			{
				start_damage_state_index = previous_damage_state_index + 1;
			}
			play_damage_state_effects(vehicle, start_damage_state_index, current_damage_state_index);
			if(vehicle.health <= 0)
			{
				vehicle kill_vehicle(attacker);
			}
		}
	}
}

/*
	Name: play_damage_state_effects
	Namespace: vehicle
	Checksum: 0x27587B0
	Offset: 0x1E88
	Size: 0xF8
	Parameters: 3
	Flags: Linked
*/
function play_damage_state_effects(vehicle, start_damage_state_index, end_damage_state_index)
{
	vehicle_name = get_vehicle_name_key_for_damage_states(vehicle);
	for(damage_state_index = start_damage_state_index; damage_state_index <= end_damage_state_index; damage_state_index++)
	{
		for(effect_index = 0; effect_index < level.vehicles_damage_states[vehicle_name][damage_state_index].effect_array.size; effect_index++)
		{
			effects = level.vehicles_damage_states[vehicle_name][damage_state_index].effect_array[effect_index];
			vehicle thread play_vehicle_effects(effects);
		}
	}
}

/*
	Name: play_vehicle_effects
	Namespace: vehicle
	Checksum: 0x37C312CF
	Offset: 0x1F90
	Size: 0x116
	Parameters: 2
	Flags: Linked
*/
function play_vehicle_effects(effects, isdamagedtread)
{
	self endon(#"delete");
	self endon(#"removed");
	if(!isdefined(isdamagedtread) || isdamagedtread == 0)
	{
		self endon(#"damage_state_changed");
	}
	if(isdefined(effects.sound_effect))
	{
		self playsound(effects.sound_effect);
	}
	waittime = 0;
	if(isdefined(effects.damage_effect_loop_time))
	{
		waittime = effects.damage_effect_loop_time;
	}
	while(waittime > 0)
	{
		if(isdefined(effects.damage_effect))
		{
			playfxontag(effects.damage_effect, self, effects.vehicle_tag);
		}
		wait(waittime);
	}
}

/*
	Name: init_vehicle_entities
	Namespace: vehicle
	Checksum: 0xB725B122
	Offset: 0x20B0
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function init_vehicle_entities()
{
	vehicles = getentarray("script_vehicle", "classname");
	array::thread_all(vehicles, &init_original_vehicle);
	if(isdefined(vehicles))
	{
		return vehicles.size;
	}
	return 0;
}

/*
	Name: precache_vehicles
	Namespace: vehicle
	Checksum: 0x99EC1590
	Offset: 0x2120
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function precache_vehicles()
{
}

/*
	Name: register_vehicle
	Namespace: vehicle
	Checksum: 0x4AF6E813
	Offset: 0x2130
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function register_vehicle()
{
	if(!isdefined(level.vehicles_list))
	{
		level.vehicles_list = [];
	}
	level.vehicles_list[level.vehicles_list.size] = self;
}

/*
	Name: manage_vehicles
	Namespace: vehicle
	Checksum: 0xAB7C78BC
	Offset: 0x2170
	Size: 0x1C2
	Parameters: 0
	Flags: Linked
*/
function manage_vehicles()
{
	if(!isdefined(level.vehicles_list))
	{
		return 1;
	}
	max_vehicles = getmaxvehicles();
	newarray = [];
	for(i = 0; i < level.vehicles_list.size; i++)
	{
		if(isdefined(level.vehicles_list[i]))
		{
			newarray[newarray.size] = level.vehicles_list[i];
		}
	}
	level.vehicles_list = newarray;
	vehiclestodelete = (level.vehicles_list.size + 1) - max_vehicles;
	if(vehiclestodelete > 0)
	{
		newarray = [];
		for(i = 0; i < level.vehicles_list.size; i++)
		{
			vehicle = level.vehicles_list[i];
			if(vehiclestodelete > 0)
			{
				if(isdefined(vehicle.is_husk) && !isdefined(vehicle.permanentlyremoved))
				{
					deleted = vehicle husk_do_cleanup();
					if(deleted)
					{
						vehiclestodelete--;
						continue;
					}
				}
			}
			newarray[newarray.size] = vehicle;
		}
		level.vehicles_list = newarray;
	}
	return level.vehicles_list.size < max_vehicles;
}

/*
	Name: init_vehicle
	Namespace: vehicle
	Checksum: 0xE3C73EF1
	Offset: 0x2340
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function init_vehicle()
{
	self register_vehicle();
	if(isdefined(level.vehiclehealths) && isdefined(level.vehiclehealths[self.vehicletype]))
	{
		self.maxhealth = level.vehiclehealths[self.vehicletype];
	}
	else
	{
		self.maxhealth = getdvarint("scr_veh_health_tank");
		/#
			println(("" + self.vehicletype) + "");
		#/
	}
	self.health = self.maxhealth;
	self vehicle_record_initial_values();
	self init_vehicle_threads();
	system::wait_till("spawning");
}

/*
	Name: initialize_vehicle_damage_state_data
	Namespace: vehicle
	Checksum: 0x5E131E24
	Offset: 0x2450
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function initialize_vehicle_damage_state_data()
{
	if(self.initial_state.health > 0)
	{
		self.current_health_percentage = self.health / self.initial_state.health;
		self.previous_health_percentage = self.health / self.initial_state.health;
	}
	else
	{
		self.current_health_percentage = 1;
		self.previous_health_percentage = 1;
	}
}

/*
	Name: init_original_vehicle
	Namespace: vehicle
	Checksum: 0xA437B336
	Offset: 0x24D8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function init_original_vehicle()
{
	self.original_vehicle = 1;
	self init_vehicle();
}

/*
	Name: vehicle_wait_player_enter_t
	Namespace: vehicle
	Checksum: 0x87CE3B4
	Offset: 0x2508
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function vehicle_wait_player_enter_t()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	while(true)
	{
		self waittill(#"enter_vehicle", player);
		player thread player_wait_exit_vehicle_t();
		player player_update_vehicle_hud(1, self);
	}
}

/*
	Name: player_wait_exit_vehicle_t
	Namespace: vehicle
	Checksum: 0x1B483FC5
	Offset: 0x2590
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function player_wait_exit_vehicle_t()
{
	self endon(#"disconnect");
	self waittill(#"exit_vehicle", vehicle);
	self player_update_vehicle_hud(0, vehicle);
}

/*
	Name: vehicle_wait_damage_t
	Namespace: vehicle
	Checksum: 0x3106B9AB
	Offset: 0x25E0
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function vehicle_wait_damage_t()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	while(true)
	{
		self waittill(#"damage");
		occupants = self getvehoccupants();
		if(isdefined(occupants))
		{
			for(i = 0; i < occupants.size; i++)
			{
				occupants[i] player_update_vehicle_hud(1, self);
			}
		}
	}
}

/*
	Name: player_update_vehicle_hud
	Namespace: vehicle
	Checksum: 0xBD5CA8E5
	Offset: 0x26A8
	Size: 0x25C
	Parameters: 2
	Flags: Linked
*/
function player_update_vehicle_hud(show, vehicle)
{
	if(show)
	{
		if(!isdefined(self.vehiclehud))
		{
			self.vehiclehud = hud::createbar((1, 1, 1), 64, 16);
			self.vehiclehud hud::setpoint("CENTER", "BOTTOM", 0, -40);
			self.vehiclehud.alpha = 0.75;
		}
		self.vehiclehud hud::updatebar(vehicle.health / vehicle.initial_state.health);
	}
	else if(isdefined(self.vehiclehud))
	{
		self.vehiclehud hud::destroyelem();
	}
	if(getdvarstring("scr_vehicle_healthnumbers") != "")
	{
		if(getdvarint("scr_vehicle_healthnumbers") != 0)
		{
			if(show)
			{
				if(!isdefined(self.vehiclehudhealthnumbers))
				{
					self.vehiclehudhealthnumbers = hud::createfontstring("default", 2);
					self.vehiclehudhealthnumbers hud::setparent(self.vehiclehud);
					self.vehiclehudhealthnumbers hud::setpoint("LEFT", "RIGHT", 8, 0);
					self.vehiclehudhealthnumbers.alpha = 0.75;
					self.vehiclehudhealthnumbers.hidewheninmenu = 0;
					self.vehiclehudhealthnumbers.archived = 0;
				}
				self.vehiclehudhealthnumbers setvalue(vehicle.health);
			}
			else if(isdefined(self.vehiclehudhealthnumbers))
			{
				self.vehiclehudhealthnumbers hud::destroyelem();
			}
		}
	}
}

/*
	Name: init_vehicle_threads
	Namespace: vehicle
	Checksum: 0xD0EEE825
	Offset: 0x2910
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function init_vehicle_threads()
{
	self thread vehicle_abandoned_by_drift_t();
	self thread vehicle_abandoned_by_occupants_t();
	self thread vehicle_damage_t();
	self thread vehicle_ghost_entering_occupants_t();
	self thread vehicle_recycle_spawner_t();
	self thread vehicle_disconnect_paths();
	if(isdefined(level.enablevehiclehealthbar) && level.enablevehiclehealthbar)
	{
		self thread vehicle_wait_player_enter_t();
		self thread vehicle_wait_damage_t();
	}
	self thread vehicle_wait_tread_damage();
	self thread vehicle_overturn_eject_occupants();
	if(getdvarint("scr_veh_disableoverturndamage") == 0)
	{
		self thread vehicle_overturn_suicide();
	}
	/#
		self thread cleanup_debug_print_t();
		self thread cleanup_debug_print_clearmsg_t();
	#/
}

/*
	Name: build_template
	Namespace: vehicle
	Checksum: 0x80EAD5A8
	Offset: 0x2A80
	Size: 0xE0
	Parameters: 3
	Flags: None
*/
function build_template(type, model, typeoverride)
{
	if(isdefined(typeoverride))
	{
		type = typeoverride;
	}
	if(!isdefined(level.vehicle_death_fx))
	{
		level.vehicle_death_fx = [];
	}
	if(!isdefined(level.vehicle_death_fx[type]))
	{
		level.vehicle_death_fx[type] = [];
	}
	level.vehicle_compassicon[type] = 0;
	level.vehicle_team[type] = "axis";
	level.vehicle_life[type] = 999;
	level.vehicle_hasmainturret[model] = 0;
	level.vehicle_mainturrets[model] = [];
	level.vtmodel = model;
	level.vttype = type;
}

/*
	Name: build_rumble
	Namespace: vehicle
	Checksum: 0xD17AC653
	Offset: 0x2B68
	Size: 0xC6
	Parameters: 6
	Flags: None
*/
function build_rumble(rumble, scale, duration, radius, basetime, randomaditionaltime)
{
	if(!isdefined(level.vehicle_rumble))
	{
		level.vehicle_rumble = [];
	}
	struct = build_quake(scale, duration, radius, basetime, randomaditionaltime);
	/#
		assert(isdefined(rumble));
	#/
	struct.rumble = rumble;
	level.vehicle_rumble[level.vttype] = struct;
}

/*
	Name: build_quake
	Namespace: vehicle
	Checksum: 0x2AB09E9F
	Offset: 0x2C38
	Size: 0xC0
	Parameters: 5
	Flags: Linked
*/
function build_quake(scale, duration, radius, basetime, randomaditionaltime)
{
	struct = spawnstruct();
	struct.scale = scale;
	struct.duration = duration;
	struct.radius = radius;
	if(isdefined(basetime))
	{
		struct.basetime = basetime;
	}
	if(isdefined(randomaditionaltime))
	{
		struct.randomaditionaltime = randomaditionaltime;
	}
	return struct;
}

/*
	Name: build_exhaust
	Namespace: vehicle
	Checksum: 0xC97EF76E
	Offset: 0x2D00
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function build_exhaust(effect)
{
	level.vehicle_exhaust[level.vtmodel] = effect;
}

/*
	Name: cleanup_debug_print_t
	Namespace: vehicle
	Checksum: 0xB7A8196
	Offset: 0x2D30
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function cleanup_debug_print_t()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	/#
		while(true)
		{
			if(isdefined(self.debug_message) && getdvarint("") != 0)
			{
				print3d(self.origin + vectorscale((0, 0, 1), 150), self.debug_message, (0, 1, 0), 1, 1, 1);
			}
			wait(0.01);
		}
	#/
}

/*
	Name: cleanup_debug_print_clearmsg_t
	Namespace: vehicle
	Checksum: 0x9B70B484
	Offset: 0x2DE8
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function cleanup_debug_print_clearmsg_t()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	/#
		while(true)
		{
			self waittill(#"enter_vehicle");
			self.debug_message = undefined;
		}
	#/
}

/*
	Name: cleanup_debug_print
	Namespace: vehicle
	Checksum: 0x386A6980
	Offset: 0x2E40
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function cleanup_debug_print(message)
{
	/#
		self.debug_message = message;
	#/
}

/*
	Name: vehicle_abandoned_by_drift_t
	Namespace: vehicle
	Checksum: 0x321212FE
	Offset: 0x2E68
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function vehicle_abandoned_by_drift_t()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	self wait_then_cleanup_vehicle("Drift Test", "scr_veh_cleanupdrifted");
}

/*
	Name: vehicle_abandoned_by_occupants_timeout_t
	Namespace: vehicle
	Checksum: 0xABA6C6CB
	Offset: 0x2EC0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function vehicle_abandoned_by_occupants_timeout_t()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	self wait_then_cleanup_vehicle("Abandon Test", "scr_veh_cleanupabandoned");
}

/*
	Name: wait_then_cleanup_vehicle
	Namespace: vehicle
	Checksum: 0x301ADD1
	Offset: 0x2F18
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function wait_then_cleanup_vehicle(test_name, cleanup_dvar_name)
{
	self endon(#"enter_vehicle");
	self wait_until_severely_damaged();
	self do_alive_cleanup_wait(test_name);
	self wait_for_vehicle_to_stop_outside_min_radius();
	self cleanup(test_name, cleanup_dvar_name, &vehicle_recycle);
}

/*
	Name: wait_until_severely_damaged
	Namespace: vehicle
	Checksum: 0x47BA5ADD
	Offset: 0x2FB0
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function wait_until_severely_damaged()
{
	while(true)
	{
		health_percentage = self.health / self.initial_state.health;
		if(isdefined(level.k_severe_damage_health_percentage))
		{
			self cleanup_debug_print(((("Damage Test: Still healthy - (") + health_percentage) + (" >= ") + level.k_severe_damage_health_percentage) + ") and working treads");
		}
		else
		{
			self cleanup_debug_print("Damage Test: Still healthy and working treads");
		}
		self waittill(#"damage");
		health_percentage = self.health / self.initial_state.health;
		if(isdefined(level.k_severe_damage_health_percentage) && health_percentage < level.k_severe_damage_health_percentage)
		{
			break;
		}
	}
}

/*
	Name: get_random_cleanup_wait_time
	Namespace: vehicle
	Checksum: 0xFBBBCF3
	Offset: 0x30A8
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function get_random_cleanup_wait_time(state)
{
	varnameprefix = ("scr_veh_" + state) + "_cleanuptime";
	mintime = getdvarfloat(varnameprefix + "min");
	maxtime = getdvarfloat(varnameprefix + "max");
	if(maxtime > mintime)
	{
		return randomfloatrange(mintime, maxtime);
	}
	return maxtime;
}

/*
	Name: do_alive_cleanup_wait
	Namespace: vehicle
	Checksum: 0xE6ADC741
	Offset: 0x3170
	Size: 0x29E
	Parameters: 1
	Flags: Linked
*/
function do_alive_cleanup_wait(test_name)
{
	initialrandomwaitseconds = get_random_cleanup_wait_time("alive");
	secondswaited = 0;
	seconds_per_iteration = 1;
	while(true)
	{
		curve_begin = getdvarfloat("scr_veh_cleanuptime_dmgfraction_curve_begin");
		curve_end = getdvarfloat("scr_veh_cleanuptime_dmgfraction_curve_end");
		factor_min = getdvarfloat("scr_veh_cleanuptime_dmgfactor_min");
		factor_max = getdvarfloat("scr_veh_cleanuptime_dmgfactor_max");
		treaddeaddamagefactor = getdvarfloat("scr_veh_cleanuptime_dmgfactor_deadtread");
		damagefraction = 0;
		if(self is_vehicle())
		{
			damagefraction = (self.initial_state.health - self.health) / self.initial_state.health;
		}
		else
		{
			damagefraction = 1;
		}
		damagefactor = 0;
		if(damagefraction <= curve_begin)
		{
			damagefactor = factor_max;
		}
		else
		{
			if(damagefraction >= curve_end)
			{
				damagefactor = factor_min;
			}
			else
			{
				dydx = (factor_min - factor_max) / (curve_end - curve_begin);
				damagefactor = factor_max + ((damagefraction - curve_begin) * dydx);
			}
		}
		totalsecstowait = initialrandomwaitseconds * damagefactor;
		if(secondswaited >= totalsecstowait)
		{
			break;
		}
		self cleanup_debug_print((test_name + ": Waiting ") + (totalsecstowait - secondswaited) + "s");
		wait(seconds_per_iteration);
		secondswaited = secondswaited + seconds_per_iteration;
	}
}

/*
	Name: do_dead_cleanup_wait
	Namespace: vehicle
	Checksum: 0xC24449DF
	Offset: 0x3418
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function do_dead_cleanup_wait(test_name)
{
	total_secs_to_wait = get_random_cleanup_wait_time("dead");
	seconds_waited = 0;
	seconds_per_iteration = 1;
	while(seconds_waited < total_secs_to_wait)
	{
		self cleanup_debug_print((test_name + ": Waiting ") + (total_secs_to_wait - seconds_waited) + "s");
		wait(seconds_per_iteration);
		seconds_waited = seconds_waited + seconds_per_iteration;
	}
}

/*
	Name: cleanup
	Namespace: vehicle
	Checksum: 0x243541FE
	Offset: 0x34D8
	Size: 0xE2
	Parameters: 3
	Flags: Linked
*/
function cleanup(test_name, cleanup_dvar_name, cleanup_func)
{
	keep_waiting = 1;
	while(keep_waiting)
	{
		cleanupenabled = !isdefined(cleanup_dvar_name) || getdvarint(cleanup_dvar_name) != 0;
		if(cleanupenabled != 0)
		{
			self [[cleanup_func]]();
			break;
		}
		keep_waiting = 0;
		/#
			self cleanup_debug_print(((("" + test_name) + "") + cleanup_dvar_name) + "");
			wait(5);
			keep_waiting = 1;
		#/
	}
}

/*
	Name: vehicle_wait_tread_damage
	Namespace: vehicle
	Checksum: 0x79C2C368
	Offset: 0x35C8
	Size: 0x130
	Parameters: 0
	Flags: Linked
*/
function vehicle_wait_tread_damage()
{
	self endon(#"death");
	self endon(#"delete");
	vehicle_name = get_vehicle_name(self);
	while(true)
	{
		self waittill(#"broken", brokennotify);
		if(brokennotify == "left_tread_destroyed")
		{
			if(isdefined(level.vehicles_damage_treadfx[vehicle_name]) && isdefined(level.vehicles_damage_treadfx[vehicle_name][0]))
			{
				self thread play_vehicle_effects(level.vehicles_damage_treadfx[vehicle_name][0], 1);
			}
		}
		else if(brokennotify == "right_tread_destroyed")
		{
			if(isdefined(level.vehicles_damage_treadfx[vehicle_name]) && isdefined(level.vehicles_damage_treadfx[vehicle_name][1]))
			{
				self thread play_vehicle_effects(level.vehicles_damage_treadfx[vehicle_name][1], 1);
			}
		}
	}
}

/*
	Name: wait_for_vehicle_to_stop_outside_min_radius
	Namespace: vehicle
	Checksum: 0xD132508B
	Offset: 0x3700
	Size: 0x166
	Parameters: 0
	Flags: Linked
*/
function wait_for_vehicle_to_stop_outside_min_radius()
{
	maxwaittime = getdvarfloat("scr_veh_waittillstoppedandmindist_maxtime");
	iterationwaitseconds = 1;
	maxwaittimeenabledistinches = 12 * getdvarfloat("scr_veh_waittillstoppedandmindist_maxtimeenabledistfeet");
	initialorigin = self.initial_state.origin;
	totalsecondswaited = 0;
	while(totalsecondswaited < maxwaittime)
	{
		speedmph = self getspeedmph();
		cutoffmph = getdvarfloat("scr_veh_cleanupmaxspeedmph");
		if(speedmph > cutoffmph)
		{
			cleanup_debug_print(((("(" + (maxwaittime - totalsecondswaited)) + "s) Speed: ") + speedmph) + (">") + cutoffmph);
		}
		else
		{
			break;
		}
		wait(iterationwaitseconds);
		totalsecondswaited = totalsecondswaited + iterationwaitseconds;
	}
}

/*
	Name: vehicle_abandoned_by_occupants_t
	Namespace: vehicle
	Checksum: 0x2616DDF2
	Offset: 0x3870
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function vehicle_abandoned_by_occupants_t()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	while(true)
	{
		self waittill(#"exit_vehicle");
		occupants = self getvehoccupants();
		if(occupants.size == 0)
		{
			self play_start_stop_sound("tank_shutdown_sfx");
			self thread vehicle_abandoned_by_occupants_timeout_t();
		}
	}
}

/*
	Name: play_start_stop_sound
	Namespace: vehicle
	Checksum: 0xBF36EE77
	Offset: 0x3920
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function play_start_stop_sound(sound_alias, modulation)
{
	self.start_stop_sfxid = self playsound(sound_alias);
}

/*
	Name: vehicle_ghost_entering_occupants_t
	Namespace: vehicle
	Checksum: 0xD03CBCD3
	Offset: 0x3970
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function vehicle_ghost_entering_occupants_t()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	if(isdefined(self.vehicleclass) && "artillery" == self.vehicleclass)
	{
		return;
	}
	while(true)
	{
		self waittill(#"enter_vehicle", player, seat);
		isdriver = seat == 0;
		if(getdvarint("scr_veh_driversarehidden") != 0 && isdriver)
		{
			player ghost();
		}
		occupants = self getvehoccupants();
		if(occupants.size == 1)
		{
			self play_start_stop_sound("tank_startup_sfx");
		}
		player thread player_change_seat_handler_t(self);
		player thread player_leave_vehicle_cleanup_t(self);
	}
}

/*
	Name: player_is_occupant_invulnerable
	Namespace: vehicle
	Checksum: 0xC415E179
	Offset: 0x3AC8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function player_is_occupant_invulnerable(smeansofdeath)
{
	if(self isremotecontrolling())
	{
		return 0;
	}
	if(!isdefined(level.vehicle_drivers_are_invulnerable))
	{
		level.vehicle_drivers_are_invulnerable = 0;
	}
	invulnerable = level.vehicle_drivers_are_invulnerable && self player_is_driver();
	return invulnerable;
}

/*
	Name: player_is_driver
	Namespace: vehicle
	Checksum: 0xB37FEAB2
	Offset: 0x3B48
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function player_is_driver()
{
	if(!isalive(self))
	{
		return false;
	}
	vehicle = self getvehicleoccupied();
	if(isdefined(vehicle))
	{
		if(isdefined(vehicle.vehicleclass) && "artillery" == vehicle.vehicleclass)
		{
			return false;
		}
		seat = vehicle getoccupantseat(self);
		if(isdefined(seat) && seat == 0)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: player_change_seat_handler_t
	Namespace: vehicle
	Checksum: 0x77969DF4
	Offset: 0x3C10
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function player_change_seat_handler_t(vehicle)
{
	self endon(#"disconnect");
	self endon(#"exit_vehicle");
	while(true)
	{
		self waittill(#"change_seat", vehicle, oldseat, newseat);
		isdriver = newseat == 0;
		if(isdriver)
		{
			if(getdvarint("scr_veh_driversarehidden") != 0)
			{
				self ghost();
			}
		}
		else
		{
			self show();
		}
	}
}

/*
	Name: player_leave_vehicle_cleanup_t
	Namespace: vehicle
	Checksum: 0x8FDA2181
	Offset: 0x3CD8
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function player_leave_vehicle_cleanup_t(vehicle)
{
	self endon(#"disconnect");
	self waittill(#"exit_vehicle");
	currentweapon = self getcurrentweapon();
	if(isdefined(self.lastweapon) && self.lastweapon != currentweapon && self.lastweapon != level.weaponnone)
	{
		self switchtoweapon(self.lastweapon);
	}
	self show();
}

/*
	Name: vehicle_is_tank
	Namespace: vehicle
	Checksum: 0x6EB7457A
	Offset: 0x3D90
	Size: 0x50
	Parameters: 0
	Flags: None
*/
function vehicle_is_tank()
{
	return self.vehicletype == "sherman_mp" || self.vehicletype == "panzer4_mp" || self.vehicletype == "type97_mp" || self.vehicletype == "t34_mp";
}

/*
	Name: vehicle_record_initial_values
	Namespace: vehicle
	Checksum: 0x72BA29C3
	Offset: 0x3DE8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function vehicle_record_initial_values()
{
	if(!isdefined(self.initial_state))
	{
		self.initial_state = spawnstruct();
	}
	if(isdefined(self.origin))
	{
		self.initial_state.origin = self.origin;
	}
	if(isdefined(self.angles))
	{
		self.initial_state.angles = self.angles;
	}
	if(isdefined(self.health))
	{
		self.initial_state.health = self.health;
	}
	self initialize_vehicle_damage_state_data();
}

/*
	Name: vehicle_should_explode_on_cleanup
	Namespace: vehicle
	Checksum: 0xB5D20C3E
	Offset: 0x3EA0
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function vehicle_should_explode_on_cleanup()
{
	return getdvarint("scr_veh_explode_on_cleanup") != 0;
}

/*
	Name: vehicle_recycle
	Namespace: vehicle
	Checksum: 0xF20878CF
	Offset: 0x3EC8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function vehicle_recycle()
{
	self wait_for_unnoticeable_cleanup_opportunity();
	self.recycling = 1;
	self suicide();
}

/*
	Name: wait_for_vehicle_overturn
	Namespace: vehicle
	Checksum: 0xA4AA8D71
	Offset: 0x3F10
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function wait_for_vehicle_overturn()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	worldup = anglestoup(vectorscale((0, 1, 0), 90));
	overturned = 0;
	while(!overturned)
	{
		if(isdefined(self.angles))
		{
			up = anglestoup(self.angles);
			dot = vectordot(up, worldup);
			if(dot <= 0)
			{
				overturned = 1;
			}
		}
		if(!overturned)
		{
			wait(1);
		}
	}
}

/*
	Name: vehicle_overturn_eject_occupants
	Namespace: vehicle
	Checksum: 0x205EDA4E
	Offset: 0x4008
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function vehicle_overturn_eject_occupants()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	for(;;)
	{
		self waittill(#"veh_ejectoccupants");
		if(isdefined(level.onejectoccupants))
		{
			[[level.onejectoccupants]]();
		}
		wait(0.25);
	}
}

/*
	Name: vehicle_eject_all_occupants
	Namespace: vehicle
	Checksum: 0x8812B93B
	Offset: 0x4070
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function vehicle_eject_all_occupants()
{
	occupants = self getvehoccupants();
	if(isdefined(occupants))
	{
		for(i = 0; i < occupants.size; i++)
		{
			if(isdefined(occupants[i]))
			{
				occupants[i] unlink();
			}
		}
	}
}

/*
	Name: vehicle_overturn_suicide
	Namespace: vehicle
	Checksum: 0xB3F38289
	Offset: 0x4100
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function vehicle_overturn_suicide()
{
	self endon(#"transmute");
	self endon(#"death");
	self endon(#"delete");
	self wait_for_vehicle_overturn();
	seconds = randomfloatrange(5, 7);
	wait(seconds);
	damageorigin = self.origin + vectorscale((0, 0, 1), 25);
	self finishvehicleradiusdamage(self, self, 32000, 32000, 32000, 0, "MOD_EXPLOSIVE", level.weaponnone, damageorigin, 400, -1, (0, 0, 1), 0);
}

/*
	Name: suicide
	Namespace: vehicle
	Checksum: 0x80513EA6
	Offset: 0x41E0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function suicide()
{
	self kill_vehicle(self);
}

/*
	Name: kill_vehicle
	Namespace: vehicle
	Checksum: 0xD0012F23
	Offset: 0x4208
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function kill_vehicle(attacker)
{
	damageorigin = self.origin + (0, 0, 1);
	self finishvehicleradiusdamage(attacker, attacker, 32000, 32000, 10, 0, "MOD_EXPLOSIVE", level.weaponnone, damageorigin, 400, -1, (0, 0, 1), 0);
}

/*
	Name: value_with_default
	Namespace: vehicle
	Checksum: 0x7B3B28C3
	Offset: 0x4288
	Size: 0x28
	Parameters: 2
	Flags: Linked
*/
function value_with_default(preferred_value, default_value)
{
	if(isdefined(preferred_value))
	{
		return preferred_value;
	}
	return default_value;
}

/*
	Name: vehicle_transmute
	Namespace: vehicle
	Checksum: 0x2CCE2FC9
	Offset: 0x42B8
	Size: 0x3EC
	Parameters: 1
	Flags: Linked
*/
function vehicle_transmute(attacker)
{
	deathorigin = self.origin;
	deathangles = self.angles;
	vehicle_name = get_vehicle_name_key_for_damage_states(self);
	respawn_parameters = spawnstruct();
	respawn_parameters.origin = self.initial_state.origin;
	respawn_parameters.angles = self.initial_state.angles;
	respawn_parameters.health = self.initial_state.health;
	respawn_parameters.targetname = value_with_default(self.targetname, "");
	respawn_parameters.vehicletype = value_with_default(self.vehicletype, "");
	respawn_parameters.destructibledef = self.destructibledef;
	vehiclewasdestroyed = !isdefined(self.recycling);
	if(vehiclewasdestroyed || vehicle_should_explode_on_cleanup())
	{
		_spawn_explosion(deathorigin);
		if(vehiclewasdestroyed && getdvarint("scr_veh_explosion_doradiusdamage") != 0)
		{
			explosionradius = getdvarint("scr_veh_explosion_radius");
			explosionmindamage = getdvarint("scr_veh_explosion_mindamage");
			explosionmaxdamage = getdvarint("scr_veh_explosion_maxdamage");
			self kill_vehicle(attacker);
			self radiusdamage(deathorigin, explosionradius, explosionmaxdamage, explosionmindamage, attacker, "MOD_EXPLOSIVE", getweapon(self.vehicletype + "_explosion"));
		}
	}
	self notify(#"transmute");
	respawn_vehicle_now = 1;
	if(vehiclewasdestroyed && getdvarint("scr_veh_ondeath_createhusk") != 0)
	{
		if(getdvarint("scr_veh_ondeath_usevehicleashusk") != 0)
		{
			husk = self;
			self.is_husk = 1;
		}
		else
		{
			husk = _spawn_husk(deathorigin, deathangles, self.vehmodel);
		}
		husk _init_husk(vehicle_name, respawn_parameters);
		if(getdvarint("scr_veh_respawnafterhuskcleanup") != 0)
		{
			respawn_vehicle_now = 0;
		}
	}
	if(!isdefined(self.is_husk))
	{
		self remove_vehicle_from_world();
	}
	if(getdvarint("scr_veh_disablerespawn") != 0)
	{
		respawn_vehicle_now = 0;
	}
	if(respawn_vehicle_now)
	{
		respawn_vehicle(respawn_parameters);
	}
}

/*
	Name: respawn_vehicle
	Namespace: vehicle
	Checksum: 0xCA087A8C
	Offset: 0x46B0
	Size: 0x21C
	Parameters: 1
	Flags: Linked
*/
function respawn_vehicle(respawn_parameters)
{
	mintime = getdvarint("scr_veh_respawntimemin");
	maxtime = getdvarint("scr_veh_respawntimemax");
	seconds = randomfloatrange(mintime, maxtime);
	wait(seconds);
	wait_until_vehicle_position_wont_telefrag(respawn_parameters.origin);
	if(!manage_vehicles())
	{
		/#
			iprintln("");
		#/
	}
	else
	{
		if(isdefined(respawn_parameters.destructibledef))
		{
			vehicle = spawnvehicle(respawn_parameters.vehicletype, respawn_parameters.origin, respawn_parameters.angles, respawn_parameters.targetname, respawn_parameters.destructibledef);
		}
		else
		{
			vehicle = spawnvehicle(respawn_parameters.vehicletype, respawn_parameters.origin, respawn_parameters.angles, respawn_parameters.targetname);
		}
		vehicle.vehicletype = respawn_parameters.vehicletype;
		vehicle.destructibledef = respawn_parameters.destructibledef;
		vehicle.health = respawn_parameters.health;
		vehicle init_vehicle();
		vehicle vehicle_telefrag_griefers_at_position(respawn_parameters.origin);
	}
}

/*
	Name: remove_vehicle_from_world
	Namespace: vehicle
	Checksum: 0xEA224D3C
	Offset: 0x48D8
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function remove_vehicle_from_world()
{
	self notify(#"removed");
	if(isdefined(self.original_vehicle))
	{
		if(!isdefined(self.permanentlyremoved))
		{
			self.permanentlyremoved = 1;
			self thread hide_vehicle();
		}
		return false;
	}
	self _delete_entity();
	return true;
}

/*
	Name: _delete_entity
	Namespace: vehicle
	Checksum: 0x66FBDA12
	Offset: 0x4958
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function _delete_entity()
{
	/#
	#/
	self delete();
}

/*
	Name: hide_vehicle
	Namespace: vehicle
	Checksum: 0x8F76EF3B
	Offset: 0x4980
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function hide_vehicle()
{
	under_the_world = (self.origin[0], self.origin[1], self.origin[2] - 10000);
	self.origin = under_the_world;
	wait(0.1);
	self hide();
	self notify(#"hidden_permanently");
}

/*
	Name: wait_for_unnoticeable_cleanup_opportunity
	Namespace: vehicle
	Checksum: 0x6CC13DC0
	Offset: 0x4A08
	Size: 0x2CA
	Parameters: 0
	Flags: Linked
*/
function wait_for_unnoticeable_cleanup_opportunity()
{
	maxpreventdistancefeet = getdvarint("scr_veh_disappear_maxpreventdistancefeet");
	maxpreventvisibilityfeet = getdvarint("scr_veh_disappear_maxpreventvisibilityfeet");
	maxpreventdistanceinchessq = (144 * maxpreventdistancefeet) * maxpreventdistancefeet;
	maxpreventvisibilityinchessq = (144 * maxpreventvisibilityfeet) * maxpreventvisibilityfeet;
	maxsecondstowait = getdvarfloat("scr_veh_disappear_maxwaittime");
	iterationwaitseconds = 1;
	secondswaited = 0;
	while(secondswaited < maxsecondstowait)
	{
		players_s = util::get_all_alive_players_s();
		oktocleanup = 1;
		for(j = 0; j < players_s.a.size && oktocleanup; j++)
		{
			player = players_s.a[j];
			distinchessq = distancesquared(self.origin, player.origin);
			if(distinchessq < maxpreventdistanceinchessq)
			{
				self cleanup_debug_print(((("(" + (maxsecondstowait - secondswaited)) + "s) Player too close: ") + distinchessq) + ("<") + maxpreventdistanceinchessq);
				oktocleanup = 0;
				continue;
			}
			if(distinchessq < maxpreventvisibilityinchessq)
			{
				vehiclevisibilityfromplayer = self sightconetrace(player.origin, player, anglestoforward(player.angles));
				if(vehiclevisibilityfromplayer > 0)
				{
					self cleanup_debug_print(("(" + (maxsecondstowait - secondswaited)) + "s) Player can see");
					oktocleanup = 0;
				}
			}
		}
		if(oktocleanup)
		{
			return;
		}
		wait(iterationwaitseconds);
		secondswaited = secondswaited + iterationwaitseconds;
	}
}

/*
	Name: wait_until_vehicle_position_wont_telefrag
	Namespace: vehicle
	Checksum: 0x345F15F
	Offset: 0x4CE0
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function wait_until_vehicle_position_wont_telefrag(position)
{
	maxiterations = getdvarint("scr_veh_respawnwait_maxiterations");
	iterationwaitseconds = getdvarint("scr_veh_respawnwait_iterationwaitseconds");
	for(i = 0; i < maxiterations; i++)
	{
		if(!vehicle_position_will_telefrag(position))
		{
			return;
		}
		wait(iterationwaitseconds);
	}
}

/*
	Name: vehicle_position_will_telefrag
	Namespace: vehicle
	Checksum: 0x9102B156
	Offset: 0x4D88
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function vehicle_position_will_telefrag(position)
{
	players_s = util::get_all_alive_players_s();
	for(i = 0; i < players_s.a.size; i++)
	{
		if(players_s.a[i] player_vehicle_position_will_telefrag(position))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: vehicle_telefrag_griefers_at_position
	Namespace: vehicle
	Checksum: 0xD63C9775
	Offset: 0x4E20
	Size: 0xF6
	Parameters: 1
	Flags: Linked
*/
function vehicle_telefrag_griefers_at_position(position)
{
	attacker = self;
	inflictor = self;
	players_s = util::get_all_alive_players_s();
	for(i = 0; i < players_s.a.size; i++)
	{
		player = players_s.a[i];
		if(player player_vehicle_position_will_telefrag(position))
		{
			player dodamage(20000, player.origin + (0, 0, 1), attacker, inflictor, "none");
		}
	}
}

/*
	Name: player_vehicle_position_will_telefrag
	Namespace: vehicle
	Checksum: 0x8066F431
	Offset: 0x4F20
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function player_vehicle_position_will_telefrag(position)
{
	distanceinches = 240;
	mindistinchessq = distanceinches * distanceinches;
	distinchessq = distancesquared(self.origin, position);
	return distinchessq < mindistinchessq;
}

/*
	Name: vehicle_recycle_spawner_t
	Namespace: vehicle
	Checksum: 0x96DB3EF4
	Offset: 0x4F98
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function vehicle_recycle_spawner_t()
{
	self endon(#"delete");
	self waittill(#"death", attacker);
	if(isdefined(self))
	{
		self vehicle_transmute(attacker);
	}
}

/*
	Name: vehicle_play_explosion_sound
	Namespace: vehicle
	Checksum: 0xE3642018
	Offset: 0x4FF0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function vehicle_play_explosion_sound()
{
	self playsound("car_explo_large");
}

/*
	Name: vehicle_damage_t
	Namespace: vehicle
	Checksum: 0xA27CD50D
	Offset: 0x5020
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function vehicle_damage_t()
{
	self endon(#"delete");
	self endon(#"removed");
	for(;;)
	{
		self waittill(#"damage", damage, attacker);
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(!isalive(players[i]))
			{
				continue;
			}
			vehicle = players[i] getvehicleoccupied();
			if(isdefined(vehicle) && self == vehicle && players[i] player_is_driver())
			{
				if(damage > 0)
				{
					earthquake(damage / 400, 1, players[i].origin, 512, players[i]);
				}
				if(damage > 100)
				{
					/#
						println("");
					#/
					players[i] playrumbleonentity("tank_damage_heavy_mp");
					continue;
				}
				if(damage > 10)
				{
					/#
						println("");
					#/
					players[i] playrumbleonentity("tank_damage_light_mp");
				}
			}
		}
		update_damage_effects(self, attacker);
	}
}

/*
	Name: _spawn_husk
	Namespace: vehicle
	Checksum: 0x37DB1F15
	Offset: 0x5250
	Size: 0xA8
	Parameters: 3
	Flags: Linked
*/
function _spawn_husk(origin, angles, modelname)
{
	husk = spawn("script_model", origin);
	husk.angles = angles;
	husk setmodel(modelname);
	husk.health = 1;
	husk setcandamage(0);
	return husk;
}

/*
	Name: is_vehicle
	Namespace: vehicle
	Checksum: 0xFE483B22
	Offset: 0x5300
	Size: 0xC
	Parameters: 0
	Flags: Linked
*/
function is_vehicle()
{
	return isdefined(self.vehicletype);
}

/*
	Name: swap_to_husk_model
	Namespace: vehicle
	Checksum: 0xA7480BB
	Offset: 0x5318
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function swap_to_husk_model()
{
	if(isdefined(self.vehicletype))
	{
		husk_model = level.veh_husk_models[self.vehicletype];
		if(isdefined(husk_model))
		{
			self setmodel(husk_model);
		}
	}
}

/*
	Name: _init_husk
	Namespace: vehicle
	Checksum: 0x7095DA79
	Offset: 0x5378
	Size: 0x2B4
	Parameters: 2
	Flags: Linked
*/
function _init_husk(vehicle_name, respawn_parameters)
{
	self swap_to_husk_model();
	if(isdefined(level.vehicles_husk_effects))
	{
		effects = level.vehicles_husk_effects[vehicle_name];
		self play_vehicle_effects(effects);
	}
	self.respawn_parameters = respawn_parameters;
	forcepointvariance = getdvarint("scr_veh_explosion_husk_forcepointvariance");
	horzvelocityvariance = getdvarint("scr_veh_explosion_husk_horzvelocityvariance");
	vertvelocitymin = getdvarint("scr_veh_explosion_husk_vertvelocitymin");
	vertvelocitymax = getdvarint("scr_veh_explosion_husk_vertvelocitymax");
	forcepointx = randomfloatrange(0 - forcepointvariance, forcepointvariance);
	forcepointy = randomfloatrange(0 - forcepointvariance, forcepointvariance);
	forcepoint = (forcepointx, forcepointy, 0);
	forcepoint = forcepoint + self.origin;
	initialvelocityx = randomfloatrange(0 - horzvelocityvariance, horzvelocityvariance);
	initialvelocityy = randomfloatrange(0 - horzvelocityvariance, horzvelocityvariance);
	initialvelocityz = randomfloatrange(vertvelocitymin, vertvelocitymax);
	initialvelocity = (initialvelocityx, initialvelocityy, initialvelocityz);
	if(self is_vehicle())
	{
		self launchvehicle(initialvelocity, forcepoint);
	}
	else
	{
		self physicslaunch(forcepoint, initialvelocity);
	}
	self thread husk_cleanup_t();
	/#
		self thread cleanup_debug_print_t();
	#/
}

/*
	Name: husk_cleanup_t
	Namespace: vehicle
	Checksum: 0x48970D5C
	Offset: 0x5638
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function husk_cleanup_t()
{
	self endon(#"death");
	self endon(#"delete");
	self endon(#"hidden_permanently");
	respawn_parameters = self.respawn_parameters;
	self do_dead_cleanup_wait("Husk Cleanup Test");
	self wait_for_unnoticeable_cleanup_opportunity();
	self thread final_husk_cleanup_t(respawn_parameters);
}

/*
	Name: final_husk_cleanup_t
	Namespace: vehicle
	Checksum: 0x1E62CD8A
	Offset: 0x56D0
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function final_husk_cleanup_t(respawn_parameters)
{
	self husk_do_cleanup();
	if(getdvarint("scr_veh_respawnafterhuskcleanup") != 0)
	{
		if(getdvarint("scr_veh_disablerespawn") == 0)
		{
			respawn_vehicle(respawn_parameters);
		}
	}
}

/*
	Name: husk_do_cleanup
	Namespace: vehicle
	Checksum: 0x89B17569
	Offset: 0x5758
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function husk_do_cleanup()
{
	self _spawn_explosion(self.origin);
	if(self is_vehicle())
	{
		return self remove_vehicle_from_world();
	}
	self _delete_entity();
	return 1;
}

/*
	Name: _spawn_explosion
	Namespace: vehicle
	Checksum: 0xFE221F1B
	Offset: 0x57D8
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function _spawn_explosion(origin)
{
	if(getdvarint("scr_veh_explosion_spawnfx") == 0)
	{
		return;
	}
	if(isdefined(level.vehicle_explosion_effect))
	{
		forward = (0, 0, 1);
		rot = randomfloat(360);
		up = (cos(rot), sin(rot), 0);
		playfx(level.vehicle_explosion_effect, origin, forward, up);
	}
	thread _play_sound_in_space("vehicle_explo", origin);
}

/*
	Name: _play_sound_in_space
	Namespace: vehicle
	Checksum: 0xD6C52B89
	Offset: 0x58D8
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function _play_sound_in_space(soundeffectname, origin)
{
	org = spawn("script_origin", origin);
	org.origin = origin;
	org playsoundwithnotify(soundeffectname, "sounddone");
	org waittill(#"sounddone");
	org delete();
}

/*
	Name: vehicle_kill_disconnect_paths_forever
	Namespace: vehicle
	Checksum: 0xAB69D102
	Offset: 0x5980
	Size: 0x12
	Parameters: 0
	Flags: None
*/
function vehicle_kill_disconnect_paths_forever()
{
	self notify(#"kill_disconnect_paths_forever");
}

/*
	Name: vehicle_disconnect_paths
	Namespace: vehicle
	Checksum: 0x99EC1590
	Offset: 0x59A0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function vehicle_disconnect_paths()
{
}

/*
	Name: follow_path
	Namespace: vehicle
	Checksum: 0xF95FC0CA
	Offset: 0x59B0
	Size: 0x164
	Parameters: 1
	Flags: None
*/
function follow_path(node)
{
	self endon(#"death");
	/#
		assert(isdefined(node), "");
	#/
	self notify(#"newpath");
	if(isdefined(node))
	{
		self.attachedpath = node;
	}
	pathstart = self.attachedpath;
	self.currentnode = self.attachedpath;
	if(!isdefined(pathstart))
	{
		return;
	}
	self attachpath(pathstart);
	self startpath();
	self endon(#"newpath");
	nextpoint = pathstart;
	while(isdefined(nextpoint))
	{
		self waittill(#"reached_node", nextpoint);
		self.currentnode = nextpoint;
		nextpoint notify(#"trigger", self);
		if(isdefined(nextpoint.script_noteworthy))
		{
			self notify(nextpoint.script_noteworthy);
			self notify(#"noteworthy", nextpoint.script_noteworthy, nextpoint);
		}
		waittillframeend();
	}
}

/*
	Name: initvehiclemap
	Namespace: vehicle
	Checksum: 0xBABAC715
	Offset: 0x5B20
	Size: 0xAC
	Parameters: 0
	Flags: None
*/
function initvehiclemap()
{
	root = "devgui_cmd \"MP/Vehicles/";
	adddebugcommand(root + "Spawn siegebot\" \"set scr_spawnvehicle 1\"\n");
	adddebugcommand(root + "Spawn siegebot boss\" \"set scr_spawnvehicle 2\"\n");
	adddebugcommand(root + "Spawn quadtank\" \"set scr_spawnvehicle 3\"\n");
	adddebugcommand(root + "Spawn mechtank\" \"set scr_spawnvehicle 4\"\n");
	thread vehiclemainthread();
}

/*
	Name: vehiclemainthread
	Namespace: vehicle
	Checksum: 0x3BA61492
	Offset: 0x5BD8
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function vehiclemainthread()
{
	if(level.disablevehiclespawners === 1)
	{
		return;
	}
	spawn_nodes = struct::get_array("veh_spawn_point", "targetname");
	veh_spawner_id = 0;
	for(i = 0; i < spawn_nodes.size; i++)
	{
		spawn_node = spawn_nodes[i];
		veh_name = spawn_node.script_noteworthy;
		time_interval = int(spawn_node.script_parameters);
		if(!isdefined(veh_name))
		{
			continue;
		}
		veh_spawner_id++;
		thread vehiclespawnthread(veh_spawner_id, veh_name, spawn_node.origin, spawn_node.angles, time_interval);
		if(isdefined(level.vehicle_spawner_init))
		{
			level [[level.vehicle_spawner_init]](veh_spawner_id, veh_name, spawn_node.origin, spawn_node.angles);
		}
		wait(0.05);
	}
	if(isdefined(level.vehicle_spawners_init_finished))
	{
		level thread [[level.vehicle_spawners_init_finished]]();
	}
}

/*
	Name: vehiclespawnthread
	Namespace: vehicle
	Checksum: 0x60C44D1D
	Offset: 0x5D68
	Size: 0x2EE
	Parameters: 5
	Flags: Linked
*/
function vehiclespawnthread(veh_spawner_id, veh_name, origin, angles, time_interval)
{
	level endon(#"game_ended");
	veh_spawner = getent(veh_name + "_spawner", "targetname");
	kill_trigger = spawn("trigger_radius", origin, 0, 60, 180);
	/#
		level thread function_87e9a4ad(veh_name, origin, angles);
		var_45b6c208 = time_interval;
	#/
	while(true)
	{
		vehicle = veh_spawner spawnfromspawner(veh_name, 1, 1, 1);
		if(!isdefined(vehicle))
		{
			wait(randomfloatrange(1, 2));
			continue;
		}
		if(isdefined(vehicle.archetype))
		{
			vehicle asmrequestsubstate("locomotion@movement");
		}
		wait(0.05);
		vehicle.origin = origin;
		vehicle.angles = angles;
		vehicle.veh_spawner_id = veh_spawner_id;
		vehicle thread vehicleteamthread();
		/#
			level thread function_4b28749d(vehicle);
		#/
		vehicle waittill(#"death");
		vehicle vehicle_death::deletewhensafe(0.25);
		if(isdefined(level.vehicle_destroyed))
		{
			level thread [[level.vehicle_destroyed]](veh_spawner_id);
		}
		/#
			time_interval = var_45b6c208;
			if(getdvarfloat("", 0) != 0)
			{
				time_interval = getdvarfloat("", 0);
				if(time_interval < 5.1)
				{
					time_interval = 5.1;
				}
			}
		#/
		if(isdefined(time_interval))
		{
			level thread performvehicleprespawn(veh_spawner_id, veh_name, origin, angles, time_interval, kill_trigger);
			wait(time_interval);
		}
	}
}

/*
	Name: performvehicleprespawn
	Namespace: vehicle
	Checksum: 0xEFCE4E
	Offset: 0x6060
	Size: 0x10A
	Parameters: 6
	Flags: Linked
*/
function performvehicleprespawn(veh_spawner_id, veh_name, origin, angles, spawn_delay, kill_trigger)
{
	fx_prespawn_time = 5;
	fx_spawn_delay = spawn_delay - fx_prespawn_time;
	wait(fx_spawn_delay);
	if(isdefined(level.vehicle_about_to_spawn))
	{
		level thread [[level.vehicle_about_to_spawn]](veh_spawner_id, veh_name, origin, angles, fx_prespawn_time);
	}
	kill_overlap_time = 0.1;
	wait_before_kill = fx_prespawn_time - kill_overlap_time;
	wait(wait_before_kill);
	kill_duration_ms = (kill_overlap_time * 2) * 1000;
	level thread kill_any_touching(kill_trigger, kill_duration_ms);
	wait(kill_overlap_time);
}

/*
	Name: kill_any_touching
	Namespace: vehicle
	Checksum: 0x3F32B906
	Offset: 0x6178
	Size: 0x2E8
	Parameters: 2
	Flags: Linked
*/
function kill_any_touching(kill_trigger, kill_duration_ms)
{
	kill_expire_time_ms = gettime() + kill_duration_ms;
	kill_weapon = getweapon("hero_minigun");
	while(gettime() <= kill_expire_time_ms)
	{
		foreach(player in level.players)
		{
			if(!isdefined(player))
			{
				continue;
			}
			if(player istouching(kill_trigger))
			{
				if(player isinvehicle())
				{
					vehicle = player getvehicleoccupied();
					if(isdefined(vehicle) && vehicle.is_oob_kill_target === 1)
					{
						destroy_vehicle(vehicle);
						continue;
					}
				}
				player dodamage(player.health + 1, player.origin, kill_trigger, kill_trigger, "none", "MOD_SUICIDE", 0, kill_weapon);
			}
		}
		potential_victims = getaiarray();
		if(isdefined(potential_victims))
		{
			foreach(entity in potential_victims)
			{
				if(!isdefined(entity))
				{
					continue;
				}
				if(!entity istouching(kill_trigger))
				{
					continue;
				}
				if(isdefined(entity.health) && entity.health <= 0)
				{
					continue;
				}
				if(isvehicle(entity))
				{
					destroy_vehicle(entity);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: destroy_vehicle
	Namespace: vehicle
	Checksum: 0x54144AFE
	Offset: 0x6468
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function destroy_vehicle(vehicle)
{
	vehicle dodamage(vehicle.health + 10000, vehicle.origin, undefined, undefined, "none", "MOD_TRIGGER_HURT");
}

/*
	Name: function_87e9a4ad
	Namespace: vehicle
	Checksum: 0x66C0F5C1
	Offset: 0x64C8
	Size: 0xA0
	Parameters: 3
	Flags: Linked
*/
function function_87e9a4ad(veh_name, origin, angles)
{
	/#
		fx_prespawn_time = 5;
		while(true)
		{
			if(getdvarint("", 0) == 0)
			{
				wait(1);
			}
			else
			{
				if(isdefined(level.vehicle_about_to_spawn))
				{
					level thread [[level.vehicle_about_to_spawn]](veh_name, origin, angles, fx_prespawn_time);
				}
				wait(6);
			}
		}
	#/
}

/*
	Name: function_4b28749d
	Namespace: vehicle
	Checksum: 0x58A9B96A
	Offset: 0x6570
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function function_4b28749d(vehicle)
{
	/#
		vehicle endon(#"death");
		setdvar("", 0);
		while(true)
		{
			if(getdvarint("") != 0)
			{
				destroy_vehicle(vehicle);
			}
			wait(1);
		}
	#/
}

/*
	Name: vehicleteamthread
	Namespace: vehicle
	Checksum: 0xFD6245E9
	Offset: 0x65F8
	Size: 0x2F0
	Parameters: 0
	Flags: Linked
*/
function vehicleteamthread()
{
	vehicle = self;
	vehicle endon(#"death");
	vehicle makevehicleusable();
	if(target_istarget(vehicle))
	{
		target_remove(vehicle);
	}
	vehicle.nojumping = 1;
	vehicle.forcedamagefeedback = 1;
	vehicle.vehkilloccupantsondeath = 1;
	vehicle disableaimassist();
	while(true)
	{
		vehicle setteam("neutral");
		vehicle.ignoreme = 1;
		vehicle clientfield::set("toggle_lights", 1);
		if(target_istarget(vehicle))
		{
			target_remove(vehicle);
		}
		vehicle waittill(#"enter_vehicle", player);
		player clearandcacheperks();
		vehicle setteam(player.team);
		vehicle.ignoreme = 0;
		vehicle clientfield::set("toggle_lights", 0);
		vehicle spawning::create_entity_enemy_influencer("small_vehicle", player.team);
		player spawning::enable_influencers(0);
		if(!target_istarget(vehicle))
		{
			if(isdefined(vehicle.targetoffset))
			{
				target_set(vehicle, vehicle.targetoffset);
			}
			else
			{
				target_set(vehicle, (0, 0, 0));
			}
		}
		vehicle thread watchplayerexitrequestthread(player);
		vehicle waittill(#"exit_vehicle", player);
		if(isdefined(player))
		{
			player setcachedperks();
			player spawning::enable_influencers(1);
		}
		vehicle spawning::remove_influencers();
	}
}

/*
	Name: watchplayerexitrequestthread
	Namespace: vehicle
	Checksum: 0xFBB5A3C4
	Offset: 0x68F0
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function watchplayerexitrequestthread(player)
{
	level endon(#"game_ended");
	player endon(#"death");
	player endon(#"disconnect");
	vehicle = self;
	vehicle endon(#"death");
	wait(1.5);
	while(true)
	{
		timeused = 0;
		while(player usebuttonpressed())
		{
			timeused = timeused + 0.05;
			if(timeused > 0.25)
			{
				player unlink();
				return;
			}
			wait(0.05);
		}
		wait(0.05);
	}
}

/*
	Name: clearandcacheperks
	Namespace: vehicle
	Checksum: 0x827E76EB
	Offset: 0x69D8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function clearandcacheperks()
{
	self.perks_before_vehicle = self getperks();
	self clearperks();
}

/*
	Name: setcachedperks
	Namespace: vehicle
	Checksum: 0x33670FE2
	Offset: 0x6A20
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function setcachedperks()
{
	/#
		assert(isdefined(self.perks_before_vehicle));
	#/
	foreach(perk in self.perks_before_vehicle)
	{
		self setperk(perk);
	}
}

