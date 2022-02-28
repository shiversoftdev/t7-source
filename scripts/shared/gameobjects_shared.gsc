// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;

#namespace gameobjects;

/*
	Name: __init__sytem__
	Namespace: gameobjects
	Checksum: 0x2A163B6C
	Offset: 0x440
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gameobjects", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: gameobjects
	Checksum: 0xF6DD918E
	Offset: 0x480
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.numgametypereservedobjectives = 0;
	level.releasedobjectives = [];
	callback::on_spawned(&on_player_spawned);
	callback::on_disconnect(&on_disconnect);
	callback::on_laststand(&on_player_last_stand);
}

/*
	Name: main
	Namespace: gameobjects
	Checksum: 0xF49F0968
	Offset: 0x508
	Size: 0x186
	Parameters: 0
	Flags: None
*/
function main()
{
	level.vehiclesenabled = getgametypesetting("vehiclesEnabled");
	level.vehiclestimed = getgametypesetting("vehiclesTimed");
	level.objectivepingdelay = getgametypesetting("objectivePingTime");
	level.nonteambasedteam = "allies";
	if(!isdefined(level.allowedgameobjects))
	{
		level.allowedgameobjects = [];
	}
	/#
		if(level.script == "")
		{
			level.vehiclesenabled = 1;
		}
	#/
	if(level.vehiclesenabled)
	{
		level.allowedgameobjects[level.allowedgameobjects.size] = "vehicle";
		filter_script_vehicles_from_vehicle_descriptors(level.allowedgameobjects);
	}
	entities = getentarray();
	for(entity_index = entities.size - 1; entity_index >= 0; entity_index--)
	{
		entity = entities[entity_index];
		if(!entity_is_allowed(entity, level.allowedgameobjects))
		{
			entity delete();
		}
	}
}

/*
	Name: register_allowed_gameobject
	Namespace: gameobjects
	Checksum: 0xB6046714
	Offset: 0x698
	Size: 0x3A
	Parameters: 1
	Flags: None
*/
function register_allowed_gameobject(gameobject)
{
	if(!isdefined(level.allowedgameobjects))
	{
		level.allowedgameobjects = [];
	}
	level.allowedgameobjects[level.allowedgameobjects.size] = gameobject;
}

/*
	Name: clear_allowed_gameobjects
	Namespace: gameobjects
	Checksum: 0x5488802E
	Offset: 0x6E0
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function clear_allowed_gameobjects()
{
	level.allowedgameobjects = [];
}

/*
	Name: entity_is_allowed
	Namespace: gameobjects
	Checksum: 0x7955C27C
	Offset: 0x6F8
	Size: 0x118
	Parameters: 2
	Flags: Linked
*/
function entity_is_allowed(entity, allowed_game_modes)
{
	allowed = 1;
	if(isdefined(entity.script_gameobjectname) && entity.script_gameobjectname != "[all_modes]")
	{
		allowed = 0;
		gameobjectnames = strtok(entity.script_gameobjectname, " ");
		for(i = 0; i < allowed_game_modes.size && !allowed; i++)
		{
			for(j = 0; j < gameobjectnames.size && !allowed; j++)
			{
				allowed = gameobjectnames[j] == allowed_game_modes[i];
			}
		}
	}
	return allowed;
}

/*
	Name: location_is_allowed
	Namespace: gameobjects
	Checksum: 0xBB16E102
	Offset: 0x818
	Size: 0x130
	Parameters: 2
	Flags: None
*/
function location_is_allowed(entity, location)
{
	allowed = 1;
	location_list = undefined;
	if(isdefined(entity.script_noteworthy))
	{
		location_list = entity.script_noteworthy;
	}
	if(isdefined(entity.script_location))
	{
		location_list = entity.script_location;
	}
	if(isdefined(location_list))
	{
		if(location_list == "[all_modes]")
		{
			allowed = 1;
		}
		else
		{
			allowed = 0;
			gameobjectlocations = strtok(location_list, " ");
			for(j = 0; j < gameobjectlocations.size; j++)
			{
				if(gameobjectlocations[j] == location)
				{
					allowed = 1;
					break;
				}
			}
		}
	}
	return allowed;
}

/*
	Name: filter_script_vehicles_from_vehicle_descriptors
	Namespace: gameobjects
	Checksum: 0x13452D51
	Offset: 0x950
	Size: 0x206
	Parameters: 1
	Flags: Linked
*/
function filter_script_vehicles_from_vehicle_descriptors(allowed_game_modes)
{
	vehicle_descriptors = getentarray("vehicle_descriptor", "targetname");
	script_vehicles = getentarray("script_vehicle", "classname");
	vehicles_to_remove = [];
	for(descriptor_index = 0; descriptor_index < vehicle_descriptors.size; descriptor_index++)
	{
		descriptor = vehicle_descriptors[descriptor_index];
		closest_distance_sq = 1E+12;
		closest_vehicle = undefined;
		for(vehicle_index = 0; vehicle_index < script_vehicles.size; vehicle_index++)
		{
			vehicle = script_vehicles[vehicle_index];
			dsquared = distancesquared(vehicle getorigin(), descriptor getorigin());
			if(dsquared < closest_distance_sq)
			{
				closest_distance_sq = dsquared;
				closest_vehicle = vehicle;
			}
		}
		if(isdefined(closest_vehicle))
		{
			if(!entity_is_allowed(descriptor, allowed_game_modes))
			{
				vehicles_to_remove[vehicles_to_remove.size] = closest_vehicle;
			}
		}
	}
	for(vehicle_index = 0; vehicle_index < vehicles_to_remove.size; vehicle_index++)
	{
		vehicles_to_remove[vehicle_index] delete();
	}
}

/*
	Name: on_player_spawned
	Namespace: gameobjects
	Checksum: 0x47ECDB6F
	Offset: 0xB60
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	level endon(#"game_ended");
	self thread on_death();
	self.touchtriggers = [];
	self.packobject = [];
	self.packicon = [];
	self.carryobject = undefined;
	self.claimtrigger = undefined;
	self.canpickupobject = 1;
	self.disabledweapon = 0;
	self.killedinuse = undefined;
}

/*
	Name: on_death
	Namespace: gameobjects
	Checksum: 0x9A49462
	Offset: 0xBF0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function on_death()
{
	level endon(#"game_ended");
	self endon(#"killondeathmonitor");
	self waittill(#"death");
	self thread gameobjects_dropped();
}

/*
	Name: on_disconnect
	Namespace: gameobjects
	Checksum: 0xE9B3FAE
	Offset: 0xC38
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_disconnect()
{
	level endon(#"game_ended");
	self thread gameobjects_dropped();
}

/*
	Name: on_player_last_stand
	Namespace: gameobjects
	Checksum: 0x1CAC77BD
	Offset: 0xC68
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_last_stand()
{
	self thread gameobjects_dropped();
}

/*
	Name: gameobjects_dropped
	Namespace: gameobjects
	Checksum: 0x9A70D5C0
	Offset: 0xC90
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function gameobjects_dropped()
{
	if(isdefined(self.carryobject))
	{
		self.carryobject thread set_dropped();
	}
	if(isdefined(self.packobject) && self.packobject.size > 0)
	{
		foreach(item in self.packobject)
		{
			item thread set_dropped();
		}
	}
}

/*
	Name: create_carry_object
	Namespace: gameobjects
	Checksum: 0xD4A5D341
	Offset: 0xD70
	Size: 0xA28
	Parameters: 6
	Flags: None
*/
function create_carry_object(ownerteam, trigger, visuals, offset, objectivename, hitsound)
{
	carryobject = spawnstruct();
	carryobject.type = "carryObject";
	carryobject.curorigin = trigger.origin;
	carryobject.entnum = trigger getentitynumber();
	carryobject.hitsound = hitsound;
	if(issubstr(trigger.classname, "use"))
	{
		carryobject.triggertype = "use";
	}
	else
	{
		carryobject.triggertype = "proximity";
	}
	trigger.baseorigin = trigger.origin;
	carryobject.trigger = trigger;
	carryobject.useweapon = undefined;
	if(!isdefined(offset))
	{
		offset = (0, 0, 0);
	}
	carryobject.offset3d = offset;
	carryobject.newstyle = 0;
	if(isdefined(objectivename))
	{
		if(!sessionmodeiscampaigngame())
		{
			carryobject.newstyle = 1;
		}
	}
	else
	{
		objectivename = &"";
	}
	for(index = 0; index < visuals.size; index++)
	{
		visuals[index].baseorigin = visuals[index].origin;
		visuals[index].baseangles = visuals[index].angles;
	}
	carryobject.visuals = visuals;
	carryobject _set_team(ownerteam);
	carryobject.compassicons = [];
	carryobject.objid = [];
	if(!carryobject.newstyle)
	{
		foreach(team in level.teams)
		{
			carryobject.objid[team] = get_next_obj_id();
		}
	}
	carryobject.objidpingfriendly = 0;
	carryobject.objidpingenemy = 0;
	level.objidstart = level.objidstart + 2;
	if(!carryobject.newstyle)
	{
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				if(sessionmodeiscampaigngame())
				{
					if(team == "allies")
					{
						objective_add(carryobject.objid[team], "active", carryobject.curorigin, objectivename);
					}
					else
					{
						objective_add(carryobject.objid[team], "invisible", carryobject.curorigin, objectivename);
					}
				}
				else
				{
					objective_add(carryobject.objid[team], "invisible", carryobject.curorigin, objectivename);
				}
				objective_team(carryobject.objid[team], team);
				carryobject.objpoints[team] = objpoints::create((("objpoint_" + team) + "_") + carryobject.entnum, carryobject.curorigin + offset, team, undefined);
				carryobject.objpoints[team].alpha = 0;
			}
		}
		else
		{
			objective_add(carryobject.objid[level.nonteambasedteam], "invisible", carryobject.curorigin, objectivename);
			carryobject.objpoints[level.nonteambasedteam] = objpoints::create((("objpoint_" + level.nonteambasedteam) + "_") + carryobject.entnum, carryobject.curorigin + offset, "all", undefined);
			carryobject.objpoints[level.nonteambasedteam].alpha = 0;
		}
	}
	carryobject.objectiveid = get_next_obj_id();
	if(carryobject.newstyle)
	{
		objective_add(carryobject.objectiveid, "invisible", carryobject.curorigin, objectivename);
	}
	carryobject.carrier = undefined;
	carryobject.isresetting = 0;
	carryobject.interactteam = "none";
	carryobject.allowweapons = 0;
	carryobject.visiblecarriermodel = undefined;
	carryobject.dropoffset = 0;
	carryobject.disallowremotecontrol = 0;
	carryobject.worldicons = [];
	carryobject.carriervisible = 0;
	carryobject.visibleteam = "none";
	carryobject.worldiswaypoint = [];
	carryobject.worldicons_disabled = [];
	carryobject.carryicon = undefined;
	carryobject.setdropped = undefined;
	carryobject.ondrop = undefined;
	carryobject.onpickup = undefined;
	carryobject.onreset = undefined;
	if(carryobject.triggertype == "use")
	{
		carryobject thread carry_object_use_think();
	}
	else
	{
		carryobject.numtouching["neutral"] = 0;
		carryobject.numtouching["none"] = 0;
		carryobject.touchlist["neutral"] = [];
		carryobject.touchlist["none"] = [];
		foreach(team in level.teams)
		{
			carryobject.numtouching[team] = 0;
			carryobject.touchlist[team] = [];
		}
		carryobject.curprogress = 0;
		carryobject.usetime = 0;
		carryobject.userate = 0;
		carryobject.claimteam = "none";
		carryobject.claimplayer = undefined;
		carryobject.lastclaimteam = "none";
		carryobject.lastclaimtime = 0;
		carryobject.claimgraceperiod = 0;
		carryobject.mustmaintainclaim = 0;
		carryobject.cancontestclaim = 0;
		carryobject.decayprogress = 0;
		carryobject.teamusetimes = [];
		carryobject.teamusetexts = [];
		carryobject.onuse = &set_picked_up;
		carryobject thread use_object_prox_think();
	}
	carryobject thread update_carry_object_origin();
	carryobject thread update_carry_object_objective_origin();
	return carryobject;
}

/*
	Name: carry_object_use_think
	Namespace: gameobjects
	Checksum: 0xA56C3042
	Offset: 0x17A0
	Size: 0x1D0
	Parameters: 0
	Flags: Linked
*/
function carry_object_use_think()
{
	level endon(#"game_ended");
	self.trigger endon(#"destroyed");
	while(true)
	{
		self.trigger waittill(#"trigger", player);
		if(self.isresetting)
		{
			continue;
		}
		if(!isalive(player))
		{
			continue;
		}
		if(isdefined(player.laststand) && player.laststand)
		{
			continue;
		}
		if(!self can_interact_with(player))
		{
			continue;
		}
		if(!player.canpickupobject)
		{
			continue;
		}
		if(player.throwinggrenade)
		{
			continue;
		}
		if(isdefined(self.carrier))
		{
			continue;
		}
		if(player isinvehicle())
		{
			continue;
		}
		if(player isremotecontrolling() || player util::isusingremote())
		{
			continue;
		}
		if(isdefined(player.selectinglocation) && player.selectinglocation)
		{
			continue;
		}
		if(player isweaponviewonlylinked())
		{
			continue;
		}
		if(!player istouching(self.trigger))
		{
			continue;
		}
		self set_picked_up(player);
	}
}

/*
	Name: carry_object_prox_think
	Namespace: gameobjects
	Checksum: 0x647FCEAF
	Offset: 0x1978
	Size: 0x1D0
	Parameters: 0
	Flags: None
*/
function carry_object_prox_think()
{
	level endon(#"game_ended");
	self.trigger endon(#"destroyed");
	while(true)
	{
		self.trigger waittill(#"trigger", player);
		if(self.isresetting)
		{
			continue;
		}
		if(!isalive(player))
		{
			continue;
		}
		if(isdefined(player.laststand) && player.laststand)
		{
			continue;
		}
		if(!self can_interact_with(player))
		{
			continue;
		}
		if(!player.canpickupobject)
		{
			continue;
		}
		if(player.throwinggrenade)
		{
			continue;
		}
		if(isdefined(self.carrier))
		{
			continue;
		}
		if(player isinvehicle())
		{
			continue;
		}
		if(player isremotecontrolling() || player util::isusingremote())
		{
			continue;
		}
		if(isdefined(player.selectinglocation) && player.selectinglocation)
		{
			continue;
		}
		if(player isweaponviewonlylinked())
		{
			continue;
		}
		if(!player istouching(self.trigger))
		{
			continue;
		}
		self set_picked_up(player);
	}
}

/*
	Name: pickup_object_delay
	Namespace: gameobjects
	Checksum: 0x4669BF18
	Offset: 0x1B50
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function pickup_object_delay(origin)
{
	level endon(#"game_ended");
	self endon(#"death");
	self endon(#"disconnect");
	self.canpickupobject = 0;
	for(;;)
	{
		if(distancesquared(self.origin, origin) > 4096)
		{
			break;
		}
		wait(0.2);
	}
	self.canpickupobject = 1;
}

/*
	Name: set_picked_up
	Namespace: gameobjects
	Checksum: 0x58F59212
	Offset: 0x1BD0
	Size: 0x234
	Parameters: 1
	Flags: Linked
*/
function set_picked_up(player)
{
	if(!isalive(player))
	{
		return;
	}
	if(self.type == "carryObject")
	{
		if(isdefined(player.carryobject))
		{
			if(isdefined(player.carryobject.swappable) && player.carryobject.swappable)
			{
				player.carryobject thread set_dropped();
			}
			else
			{
				if(isdefined(self.onpickupfailed))
				{
					self [[self.onpickupfailed]](player);
				}
				return;
			}
		}
		player give_object(self);
	}
	else if(self.type == "packObject")
	{
		if(isdefined(level.max_packobjects) && level.max_packobjects <= player.packobject.size)
		{
			if(isdefined(self.onpickupfailed))
			{
				self [[self.onpickupfailed]](player);
			}
			return;
		}
		player give_pack_object(self);
	}
	self set_carrier(player);
	self ghost_visuals();
	self.trigger.origin = self.trigger.origin + vectorscale((0, 0, 1), 10000);
	self notify(#"pickup_object");
	if(isdefined(self.onpickup))
	{
		self [[self.onpickup]](player);
	}
	self update_compass_icons();
	self update_world_icons();
	self update_objective();
}

/*
	Name: unlink_grenades
	Namespace: gameobjects
	Checksum: 0xE0D425A
	Offset: 0x1E10
	Size: 0x212
	Parameters: 0
	Flags: Linked
*/
function unlink_grenades()
{
	radius = 32;
	origin = self.origin;
	grenades = getentarray("grenade", "classname");
	radiussq = radius * radius;
	linkedgrenades = [];
	foreach(grenade in grenades)
	{
		if(distancesquared(origin, grenade.origin) < radiussq)
		{
			if(grenade islinkedto(self))
			{
				grenade unlink();
				linkedgrenades[linkedgrenades.size] = grenade;
			}
		}
	}
	waittillframeend();
	foreach(grenade in linkedgrenades)
	{
		grenade launch((randomfloatrange(-5, 5), randomfloatrange(-5, 5), 5));
	}
}

/*
	Name: ghost_visuals
	Namespace: gameobjects
	Checksum: 0x8BCCD6BD
	Offset: 0x2030
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function ghost_visuals()
{
	foreach(visual in self.visuals)
	{
		visual ghost();
		visual thread unlink_grenades();
	}
}

/*
	Name: update_carry_object_origin
	Namespace: gameobjects
	Checksum: 0xF48C4938
	Offset: 0x20E0
	Size: 0x560
	Parameters: 0
	Flags: Linked
*/
function update_carry_object_origin()
{
	level endon(#"game_ended");
	self.trigger endon(#"destroyed");
	if(self.newstyle)
	{
		return;
	}
	objpingdelay = level.objectivepingdelay;
	for(;;)
	{
		if(isdefined(self.carrier) && level.teambased)
		{
			self.curorigin = self.carrier.origin + vectorscale((0, 0, 1), 75);
			foreach(team in level.teams)
			{
				self.objpoints[team] objpoints::update_origin(self.curorigin);
			}
			if(self.visibleteam == "friendly" || self.visibleteam == "any" && self.objidpingfriendly)
			{
				foreach(team in level.teams)
				{
					if(self is_friendly_team(team))
					{
						if(self.objpoints[team].isshown)
						{
							self.objpoints[team].alpha = self.objpoints[team].basealpha;
							self.objpoints[team] fadeovertime(objpingdelay + 1);
							self.objpoints[team].alpha = 0;
						}
						objective_position(self.objid[team], self.curorigin);
					}
				}
			}
			if(self.visibleteam == "enemy" || self.visibleteam == "any" && self.objidpingenemy)
			{
				if(!self is_friendly_team(team))
				{
					if(self.objpoints[team].isshown)
					{
						self.objpoints[team].alpha = self.objpoints[team].basealpha;
						self.objpoints[team] fadeovertime(objpingdelay + 1);
						self.objpoints[team].alpha = 0;
					}
					objective_position(self.objid[team], self.curorigin);
				}
			}
			self util::wait_endon(objpingdelay, "dropped", "reset");
			continue;
		}
		if(isdefined(self.carrier))
		{
			self.curorigin = self.carrier.origin + vectorscale((0, 0, 1), 75);
			self.objpoints[level.nonteambasedteam] objpoints::update_origin(self.curorigin);
			objective_position(self.objid[level.nonteambasedteam], self.curorigin);
			wait(0.05);
			continue;
		}
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				self.objpoints[team] objpoints::update_origin(self.curorigin + self.offset3d);
			}
		}
		else
		{
			self.objpoints[level.nonteambasedteam] objpoints::update_origin(self.curorigin + self.offset3d);
		}
		wait(0.05);
	}
}

/*
	Name: update_carry_object_objective_origin
	Namespace: gameobjects
	Checksum: 0xF3A909D6
	Offset: 0x2648
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function update_carry_object_objective_origin()
{
	level endon(#"game_ended");
	self.trigger endon(#"destroyed");
	if(!self.newstyle)
	{
		return;
	}
	objpingdelay = level.objectivepingdelay;
	for(;;)
	{
		if(isdefined(self.carrier))
		{
			self.curorigin = self.carrier.origin;
			objective_position(self.objectiveid, self.curorigin);
			self util::wait_endon(objpingdelay, "dropped", "reset");
			continue;
		}
		objective_position(self.objectiveid, self.curorigin);
		wait(0.05);
	}
}

/*
	Name: give_object
	Namespace: gameobjects
	Checksum: 0xF589352C
	Offset: 0x2730
	Size: 0x3E0
	Parameters: 1
	Flags: Linked
*/
function give_object(object)
{
	/#
		assert(!isdefined(self.carryobject));
	#/
	self.carryobject = object;
	self thread track_carrier(object);
	if(isdefined(object.carryweapon))
	{
		if(isdefined(object.carryweaponthink))
		{
			self thread [[object.carryweaponthink]]();
		}
		count = 0;
		while(self ismeleeing() && count < 10)
		{
			count++;
			wait(0.2);
		}
		self giveweapon(object.carryweapon);
		if(self isswitchingweapons())
		{
			self util::waittill_any_timeout(2, "weapon_change");
		}
		self switchtoweaponimmediate(object.carryweapon);
		self setblockweaponpickup(object.carryweapon, 1);
		self disableweaponcycling();
	}
	else if(!object.allowweapons)
	{
		self util::_disableweapon();
		self thread manual_drop_think();
	}
	self.disallowvehicleusage = 1;
	if(isdefined(object.visiblecarriermodel))
	{
		self weapons::force_stowed_weapon_update();
	}
	if(!object.newstyle)
	{
		if(isdefined(object.carryicon))
		{
			if(self issplitscreen())
			{
				self.carryicon = hud::createicon(object.carryicon, 35, 35);
				self.carryicon.x = -130;
				self.carryicon.y = -90;
				self.carryicon.horzalign = "right";
				self.carryicon.vertalign = "bottom";
			}
			else
			{
				self.carryicon = hud::createicon(object.carryicon, 50, 50);
				if(!object.allowweapons)
				{
					self.carryicon hud::setpoint("CENTER", "CENTER", 0, 60);
				}
				else
				{
					self.carryicon.x = 130;
					self.carryicon.y = -60;
					self.carryicon.horzalign = "user_left";
					self.carryicon.vertalign = "user_bottom";
				}
			}
			self.carryicon.alpha = 0.75;
			self.carryicon.hidewhileremotecontrolling = 1;
			self.carryicon.hidewheninkillcam = 1;
		}
	}
}

/*
	Name: move_visuals_to_base
	Namespace: gameobjects
	Checksum: 0xC1708D5E
	Offset: 0x2B18
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function move_visuals_to_base()
{
	foreach(visual in self.visuals)
	{
		visual.origin = visual.baseorigin;
		visual.angles = visual.baseangles;
		visual dontinterpolate();
		visual show();
	}
}

/*
	Name: return_home
	Namespace: gameobjects
	Checksum: 0xD0AB47
	Offset: 0x2C00
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function return_home()
{
	self.isresetting = 1;
	prev_origin = self.trigger.origin;
	self notify(#"reset");
	self move_visuals_to_base();
	self.trigger.origin = self.trigger.baseorigin;
	self.curorigin = self.trigger.origin;
	if(isdefined(self.onreset))
	{
		self [[self.onreset]](prev_origin);
	}
	self clear_carrier();
	update_world_icons();
	update_compass_icons();
	update_objective();
	self.isresetting = 0;
}

/*
	Name: is_object_away_from_home
	Namespace: gameobjects
	Checksum: 0x116D6B0E
	Offset: 0x2D00
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function is_object_away_from_home()
{
	if(isdefined(self.carrier))
	{
		return true;
	}
	if(distancesquared(self.trigger.origin, self.trigger.baseorigin) > 4)
	{
		return true;
	}
	return false;
}

/*
	Name: set_position
	Namespace: gameobjects
	Checksum: 0xFB4B5DD4
	Offset: 0x2D60
	Size: 0x160
	Parameters: 2
	Flags: None
*/
function set_position(origin, angles)
{
	self.isresetting = 1;
	foreach(visual in self.visuals)
	{
		visual.origin = origin;
		visual.angles = angles;
		visual dontinterpolate();
		visual show();
	}
	self.trigger.origin = origin;
	self.curorigin = self.trigger.origin;
	self clear_carrier();
	update_world_icons();
	update_compass_icons();
	update_objective();
	self.isresetting = 0;
}

/*
	Name: set_drop_offset
	Namespace: gameobjects
	Checksum: 0x5C7C1D06
	Offset: 0x2EC8
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function set_drop_offset(height)
{
	self.dropoffset = height;
}

/*
	Name: set_dropped
	Namespace: gameobjects
	Checksum: 0x60E9CD05
	Offset: 0x2EE8
	Size: 0x6D8
	Parameters: 0
	Flags: Linked
*/
function set_dropped()
{
	if(isdefined(self.setdropped))
	{
		if([[self.setdropped]]())
		{
			return;
		}
	}
	self.isresetting = 1;
	self notify(#"dropped");
	startorigin = (0, 0, 0);
	endorigin = (0, 0, 0);
	body = undefined;
	if(isdefined(self.carrier) && self.carrier.team != "spectator")
	{
		startorigin = self.carrier.origin + vectorscale((0, 0, 1), 20);
		endorigin = self.carrier.origin - vectorscale((0, 0, 1), 2000);
		body = self.carrier.body;
	}
	else
	{
		if(isdefined(self.safeorigin))
		{
			startorigin = self.safeorigin + vectorscale((0, 0, 1), 20);
			endorigin = self.safeorigin - vectorscale((0, 0, 1), 20);
		}
		else
		{
			startorigin = self.curorigin + vectorscale((0, 0, 1), 20);
			endorigin = self.curorigin - vectorscale((0, 0, 1), 20);
		}
	}
	trace_size = 10;
	trace = physicstrace(startorigin, endorigin, (trace_size * -1, trace_size * -1, trace_size * -1), (trace_size, trace_size, trace_size), self, 32);
	droppingplayer = self.carrier;
	self clear_carrier();
	if(isdefined(trace))
	{
		tempangle = randomfloat(360);
		droporigin = trace["position"] + (0, 0, self.dropoffset);
		if(trace["fraction"] < 1)
		{
			forward = (cos(tempangle), sin(tempangle), 0);
			forward = vectornormalize(forward - vectorscale(trace["normal"], vectordot(forward, trace["normal"])));
			if(sessionmodeismultiplayergame())
			{
				if(isdefined(trace["walkable"]))
				{
					if(trace["walkable"] == 0)
					{
						if(self should_be_reset(trace["position"][2], startorigin[2], 1))
						{
							self thread return_home();
							self.isresetting = 0;
							return;
						}
						end_reflect = (forward * 1000) + trace["position"];
						reflect_trace = physicstrace(trace["position"], end_reflect, (trace_size * -1, trace_size * -1, trace_size * -1), (trace_size, trace_size, trace_size), self, 32);
						if(isdefined(reflect_trace) && reflect_trace["normal"][2] < 0)
						{
							droporigin_reflect = reflect_trace["position"] + (0, 0, self.dropoffset);
							if(self should_be_reset(droporigin_reflect[2], trace["position"][2], 1))
							{
								self thread return_home();
								self.isresetting = 0;
								return;
							}
						}
					}
				}
			}
			dropangles = vectortoangles(forward);
		}
		else
		{
			dropangles = (0, tempangle, 0);
		}
		foreach(visual in self.visuals)
		{
			visual.origin = droporigin;
			visual.angles = dropangles;
			visual dontinterpolate();
			visual show();
		}
		self.trigger.origin = droporigin;
		self.curorigin = self.trigger.origin;
		self thread pickup_timeout(trace["position"][2], startorigin[2]);
	}
	else
	{
		self move_visuals_to_base();
		self.trigger.origin = self.trigger.baseorigin;
		self.curorigin = self.trigger.baseorigin;
	}
	if(isdefined(self.ondrop))
	{
		self [[self.ondrop]](droppingplayer);
	}
	self update_icons_and_objective();
	self.isresetting = 0;
}

/*
	Name: update_icons_and_objective
	Namespace: gameobjects
	Checksum: 0xEF9FD5A1
	Offset: 0x35C8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function update_icons_and_objective()
{
	self update_compass_icons();
	self update_world_icons();
	self update_objective();
}

/*
	Name: set_carrier
	Namespace: gameobjects
	Checksum: 0xD8282EDC
	Offset: 0x3620
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function set_carrier(carrier)
{
	self.carrier = carrier;
	objective_setplayerusing(self.objectiveid, carrier);
	self thread update_visibility_according_to_radar();
}

/*
	Name: get_carrier
	Namespace: gameobjects
	Checksum: 0xD9311F34
	Offset: 0x3678
	Size: 0xA
	Parameters: 0
	Flags: None
*/
function get_carrier()
{
	return self.carrier;
}

/*
	Name: clear_carrier
	Namespace: gameobjects
	Checksum: 0x3A8EA0FF
	Offset: 0x3690
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function clear_carrier()
{
	if(!isdefined(self.carrier))
	{
		return;
	}
	self.carrier take_object(self);
	objective_clearplayerusing(self.objectiveid, self.carrier);
	self.carrier = undefined;
	self notify(#"carrier_cleared");
}

/*
	Name: is_touching_any_trigger
	Namespace: gameobjects
	Checksum: 0x366ED7F8
	Offset: 0x3700
	Size: 0xB4
	Parameters: 3
	Flags: Linked
*/
function is_touching_any_trigger(triggers, minz, maxz)
{
	foreach(trigger in triggers)
	{
		if(self istouchingswept(trigger, minz, maxz))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: is_touching_any_trigger_key_value
	Namespace: gameobjects
	Checksum: 0xF343E613
	Offset: 0x37C0
	Size: 0x5A
	Parameters: 4
	Flags: Linked
*/
function is_touching_any_trigger_key_value(value, key, minz, maxz)
{
	return self is_touching_any_trigger(getentarray(value, key), minz, maxz);
}

/*
	Name: should_be_reset
	Namespace: gameobjects
	Checksum: 0x48F7C1D6
	Offset: 0x3828
	Size: 0x1DC
	Parameters: 3
	Flags: Linked
*/
function should_be_reset(minz, maxz, testhurttriggers)
{
	if(self.visuals[0] is_touching_any_trigger_key_value("minefield", "targetname", minz, maxz))
	{
		return true;
	}
	if(isdefined(testhurttriggers) && testhurttriggers && self.visuals[0] is_touching_any_trigger_key_value("trigger_hurt", "classname", minz, maxz))
	{
		return true;
	}
	if(self.visuals[0] is_touching_any_trigger(level.oob_triggers, minz, maxz))
	{
		return true;
	}
	elevators = getentarray("script_elevator", "targetname");
	foreach(elevator in elevators)
	{
		/#
			assert(isdefined(elevator.occupy_volume));
		#/
		if(self.visuals[0] istouchingswept(elevator.occupy_volume, minz, maxz))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: pickup_timeout
	Namespace: gameobjects
	Checksum: 0x66C66250
	Offset: 0x3A10
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function pickup_timeout(minz, maxz)
{
	self endon(#"pickup_object");
	self endon(#"reset");
	wait(0.05);
	if(self should_be_reset(minz, maxz, 1))
	{
		self thread return_home();
		return;
	}
	if(isdefined(self.pickuptimeoutoverride))
	{
		self thread [[self.pickuptimeoutoverride]]();
	}
	else if(isdefined(self.autoresettime))
	{
		wait(self.autoresettime);
		if(!isdefined(self.carrier))
		{
			self thread return_home();
		}
	}
}

/*
	Name: take_object
	Namespace: gameobjects
	Checksum: 0xBA743F52
	Offset: 0x3AE0
	Size: 0x2EC
	Parameters: 1
	Flags: Linked
*/
function take_object(object)
{
	if(isdefined(object.visiblecarriermodel))
	{
		self weapons::detach_all_weapons();
	}
	shouldenableweapon = 1;
	if(isdefined(object.carryweapon) && !isdefined(self.player_disconnected))
	{
		shouldenableweapon = 0;
		self thread wait_take_carry_weapon(object.carryweapon);
	}
	if(object.type == "carryObject")
	{
		if(isdefined(self.carryicon))
		{
			self.carryicon hud::destroyelem();
		}
		self.carryobject = undefined;
	}
	else if(object.type == "packObject")
	{
		if(isdefined(self.packicon) && self.packicon.size > 0)
		{
			for(i = 0; i < self.packicon.size; i++)
			{
				if(isdefined(self.packicon[i].script_string))
				{
					if(self.packicon[i].script_string == object.packicon)
					{
						elem = self.packicon[i];
						arrayremovevalue(self.packicon, elem);
						elem hud::destroyelem();
						self thread adjust_remaining_packicons();
					}
				}
			}
		}
		arrayremovevalue(self.packobject, object);
	}
	if(!isalive(self) || isdefined(self.player_disconnected))
	{
		return;
	}
	self notify(#"drop_object");
	self.disallowvehicleusage = 0;
	if(object.triggertype == "proximity")
	{
		self thread pickup_object_delay(object.trigger.origin);
	}
	if(isdefined(object.visiblecarriermodel))
	{
		self weapons::force_stowed_weapon_update();
	}
	if(!object.allowweapons && shouldenableweapon)
	{
		self util::_enableweapon();
	}
}

/*
	Name: wait_take_carry_weapon
	Namespace: gameobjects
	Checksum: 0x9A848935
	Offset: 0x3DD8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function wait_take_carry_weapon(weapon)
{
	self thread take_carry_weapon_on_death(weapon);
	wait(max(0, weapon.firetime - 0.1));
	self take_carry_weapon(weapon);
}

/*
	Name: take_carry_weapon_on_death
	Namespace: gameobjects
	Checksum: 0x3AE8E9E1
	Offset: 0x3E48
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function take_carry_weapon_on_death(weapon)
{
	self endon(#"take_carry_weapon");
	self waittill(#"death");
	self take_carry_weapon(weapon);
}

/*
	Name: take_carry_weapon
	Namespace: gameobjects
	Checksum: 0xB34B1225
	Offset: 0x3E90
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function take_carry_weapon(weapon)
{
	self notify(#"take_carry_weapon");
	if(self hasweapon(weapon, 1))
	{
		ballweapon = getweapon("ball");
		currweapon = self getcurrentweapon();
		if(weapon == ballweapon && currweapon === ballweapon)
		{
			self killstreaks::switch_to_last_non_killstreak_weapon(undefined, 1);
		}
		self setblockweaponpickup(weapon, 0);
		self takeweapon(weapon);
		self enableweaponcycling();
		if(level.gametype == "ball")
		{
			self enableoffhandweapons();
		}
	}
}

/*
	Name: track_carrier
	Namespace: gameobjects
	Checksum: 0xF55419A1
	Offset: 0x3FB8
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function track_carrier(object)
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"drop_object");
	wait(0.05);
	while(isdefined(object.carrier) && object.carrier == self && isalive(self))
	{
		if(self isonground())
		{
			trace = bullettrace(self.origin + vectorscale((0, 0, 1), 20), self.origin - vectorscale((0, 0, 1), 20), 0, undefined);
			if(trace["fraction"] < 1)
			{
				object.safeorigin = trace["position"];
			}
		}
		wait(0.05);
	}
}

/*
	Name: manual_drop_think
	Namespace: gameobjects
	Checksum: 0xEFE86245
	Offset: 0x40F0
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function manual_drop_think()
{
	level endon(#"game_ended");
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"drop_object");
	for(;;)
	{
		while(self attackbuttonpressed() || self fragbuttonpressed() || self secondaryoffhandbuttonpressed() || self meleebuttonpressed())
		{
			wait(0.05);
		}
		while(!self attackbuttonpressed() && !self fragbuttonpressed() && !self secondaryoffhandbuttonpressed() && !self meleebuttonpressed())
		{
			wait(0.05);
		}
		if(isdefined(self.carryobject) && !self usebuttonpressed())
		{
			self.carryobject thread set_dropped();
		}
	}
}

/*
	Name: create_use_object
	Namespace: gameobjects
	Checksum: 0x4ED5B286
	Offset: 0x4248
	Size: 0x9F0
	Parameters: 7
	Flags: None
*/
function create_use_object(ownerteam, trigger, visuals, offset, objectivename, allowinitialholddelay = 0, allowweaponcyclingduringhold = 0)
{
	useobject = spawn("script_model", trigger.origin);
	useobject.type = "useObject";
	useobject.curorigin = trigger.origin;
	useobject.entnum = trigger getentitynumber();
	useobject.keyobject = undefined;
	if(issubstr(trigger.classname, "use"))
	{
		useobject.triggertype = "use";
	}
	else
	{
		useobject.triggertype = "proximity";
	}
	useobject.trigger = trigger;
	useobject linkto(trigger);
	for(index = 0; index < visuals.size; index++)
	{
		visuals[index].baseorigin = visuals[index].origin;
		visuals[index].baseangles = visuals[index].angles;
	}
	useobject.visuals = visuals;
	useobject _set_team(ownerteam);
	if(!isdefined(offset))
	{
		offset = (0, 0, 0);
	}
	useobject.offset3d = offset;
	useobject.newstyle = 0;
	if(isdefined(objectivename))
	{
		useobject.newstyle = 1;
	}
	else
	{
		objectivename = &"";
	}
	useobject.compassicons = [];
	useobject.objid = [];
	if(!useobject.newstyle)
	{
		foreach(team in level.teams)
		{
			useobject.objid[team] = get_next_obj_id();
		}
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				if(sessionmodeiscampaigngame())
				{
					objective_add(useobject.objid["allies"], "active", useobject.curorigin, objectivename);
					break;
				}
				else
				{
					objective_add(useobject.objid[team], "invisible", useobject.curorigin, objectivename);
				}
				objective_team(useobject.objid[team], team);
			}
		}
		else
		{
			objective_add(useobject.objid[level.nonteambasedteam], "invisible", useobject.curorigin, objectivename);
		}
	}
	useobject.objectiveid = get_next_obj_id();
	if(useobject.newstyle)
	{
		if(sessionmodeiscampaigngame())
		{
			objective_add(useobject.objectiveid, "invisible", useobject, objectivename);
			useobject.keepweapon = 1;
		}
		else
		{
			objective_add(useobject.objectiveid, "invisible", useobject.curorigin + offset, objectivename);
		}
	}
	if(!useobject.newstyle)
	{
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				useobject.objpoints[team] = objpoints::create((("objpoint_" + team) + "_") + useobject.entnum, useobject.curorigin + offset, team, undefined);
				useobject.objpoints[team].alpha = 0;
			}
		}
		else
		{
			useobject.objpoints[level.nonteambasedteam] = objpoints::create("objpoint_allies_" + useobject.entnum, useobject.curorigin + offset, "all", undefined);
			useobject.objpoints[level.nonteambasedteam].alpha = 0;
		}
	}
	useobject.interactteam = "none";
	useobject.worldicons = [];
	useobject.visibleteam = "none";
	useobject.worldiswaypoint = [];
	useobject.worldicons_disabled = [];
	useobject.onuse = undefined;
	useobject.oncantuse = undefined;
	useobject.usetext = "default";
	useobject.usetime = 10000;
	useobject clear_progress();
	useobject.decayprogress = 0;
	if(useobject.triggertype == "proximity")
	{
		useobject.numtouching["neutral"] = 0;
		useobject.numtouching["none"] = 0;
		useobject.touchlist["neutral"] = [];
		useobject.touchlist["none"] = [];
		foreach(team in level.teams)
		{
			useobject.numtouching[team] = 0;
			useobject.touchlist[team] = [];
		}
		useobject.teamusetimes = [];
		useobject.teamusetexts = [];
		useobject.userate = 0;
		useobject.claimteam = "none";
		useobject.claimplayer = undefined;
		useobject.lastclaimteam = "none";
		useobject.lastclaimtime = 0;
		useobject.claimgraceperiod = 1;
		useobject.mustmaintainclaim = 0;
		useobject.cancontestclaim = 0;
		useobject thread use_object_prox_think();
	}
	else
	{
		useobject.userate = 1;
		useobject thread use_object_use_think(!allowinitialholddelay, !allowweaponcyclingduringhold);
	}
	return useobject;
}

/*
	Name: set_key_object
	Namespace: gameobjects
	Checksum: 0xF09C09D6
	Offset: 0x4C40
	Size: 0x4E
	Parameters: 1
	Flags: None
*/
function set_key_object(object)
{
	if(!isdefined(object))
	{
		self.keyobject = undefined;
		return;
	}
	if(!isdefined(self.keyobject))
	{
		self.keyobject = [];
	}
	self.keyobject[self.keyobject.size] = object;
}

/*
	Name: has_key_object
	Namespace: gameobjects
	Checksum: 0xAA7E2951
	Offset: 0x4C98
	Size: 0xF6
	Parameters: 1
	Flags: Linked
*/
function has_key_object(use)
{
	if(!isdefined(use.keyobject))
	{
		return false;
	}
	for(x = 0; x < use.keyobject.size; x++)
	{
		if(isdefined(self.carryobject) && self.carryobject == use.keyobject[x])
		{
			return true;
		}
		if(isdefined(self.packobject))
		{
			for(i = 0; i < self.packobject.size; i++)
			{
				if(self.packobject[i] == use.keyobject[x])
				{
					return true;
				}
			}
		}
	}
	return false;
}

/*
	Name: use_object_use_think
	Namespace: gameobjects
	Checksum: 0x9EB2E901
	Offset: 0x4D98
	Size: 0x2E8
	Parameters: 2
	Flags: Linked
*/
function use_object_use_think(disableinitialholddelay, disableweaponcyclingduringhold)
{
	self.trigger endon(#"destroyed");
	if(self.usetime > 0 && disableinitialholddelay)
	{
		self.trigger usetriggerignoreuseholdtime();
	}
	while(true)
	{
		self.trigger waittill(#"trigger", player);
		if(level.gameended)
		{
			continue;
		}
		if(!isalive(player))
		{
			continue;
		}
		if(!self can_interact_with(player))
		{
			continue;
		}
		if(isdefined(self.caninteractwithplayer) && ![[self.caninteractwithplayer]](player))
		{
			continue;
		}
		if(!player isonground() || player iswallrunning())
		{
			continue;
		}
		if(player isinvehicle())
		{
			continue;
		}
		if(isdefined(self.keyobject) && !player has_key_object(self))
		{
			if(isdefined(self.oncantuse))
			{
				self [[self.oncantuse]](player);
			}
			continue;
		}
		result = 1;
		if(self.usetime > 0)
		{
			if(isdefined(self.onbeginuse))
			{
				if(isdefined(self.classobj))
				{
					[[ self.classobj ]]->onbeginuse(player);
				}
				else
				{
					self [[self.onbeginuse]](player);
				}
			}
			team = player.pers["team"];
			result = self use_hold_think(player, disableweaponcyclingduringhold);
			if(isdefined(self.onenduse))
			{
				self [[self.onenduse]](team, player, result);
			}
		}
		if(!(isdefined(result) && result))
		{
			continue;
		}
		if(isdefined(self.onuse))
		{
			if(isdefined(self.onuse_thread) && self.onuse_thread)
			{
				self thread use_object_onuse(player);
			}
			else
			{
				self use_object_onuse(player);
			}
		}
	}
}

/*
	Name: use_object_onuse
	Namespace: gameobjects
	Checksum: 0x4A7250B8
	Offset: 0x5088
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function use_object_onuse(player)
{
	level endon(#"game_ended");
	self.trigger endon(#"destroyed");
	if(isdefined(self.classobj))
	{
		[[ self.classobj ]]->onuse(player);
	}
	else
	{
		self [[self.onuse]](player);
	}
}

/*
	Name: get_earliest_claim_player
	Namespace: gameobjects
	Checksum: 0xA1C05ED9
	Offset: 0x50F8
	Size: 0x14A
	Parameters: 0
	Flags: Linked
*/
function get_earliest_claim_player()
{
	/#
		assert(self.claimteam != "");
	#/
	team = self.claimteam;
	earliestplayer = self.claimplayer;
	if(self.touchlist[team].size > 0)
	{
		earliesttime = undefined;
		players = getarraykeys(self.touchlist[team]);
		for(index = 0; index < players.size; index++)
		{
			touchdata = self.touchlist[team][players[index]];
			if(!isdefined(earliesttime) || touchdata.starttime < earliesttime)
			{
				earliestplayer = touchdata.player;
				earliesttime = touchdata.starttime;
			}
		}
	}
	return earliestplayer;
}

/*
	Name: use_object_prox_think
	Namespace: gameobjects
	Checksum: 0xA4218BC3
	Offset: 0x5250
	Size: 0x740
	Parameters: 0
	Flags: Linked
*/
function use_object_prox_think()
{
	level endon(#"game_ended");
	self.trigger endon(#"destroyed");
	self thread prox_trigger_think();
	while(true)
	{
		if(self.usetime && self.curprogress >= self.usetime)
		{
			self clear_progress();
			creditplayer = get_earliest_claim_player();
			if(isdefined(self.onenduse))
			{
				self [[self.onenduse]](self get_claim_team(), creditplayer, isdefined(creditplayer));
			}
			if(isdefined(creditplayer) && isdefined(self.onuse))
			{
				self [[self.onuse]](creditplayer);
			}
			if(!self.mustmaintainclaim)
			{
				self set_claim_team("none");
				self.claimplayer = undefined;
			}
		}
		if(self.claimteam != "none")
		{
			if(self use_object_locked_for_team(self.claimteam))
			{
				if(isdefined(self.onenduse))
				{
					self [[self.onenduse]](self get_claim_team(), self.claimplayer, 0);
				}
				self set_claim_team("none");
				self.claimplayer = undefined;
				self clear_progress();
			}
			else
			{
				if(self.usetime && (!self.mustmaintainclaim || self get_owner_team() != self get_claim_team()))
				{
					if(self.decayprogress && !self.numtouching[self.claimteam])
					{
						if(isdefined(self.claimplayer))
						{
							if(isdefined(self.onenduse))
							{
								self [[self.onenduse]](self get_claim_team(), self.claimplayer, 0);
							}
							self.claimplayer = undefined;
						}
						decayscale = 0;
						if(self.decaytime)
						{
							decayscale = self.usetime / self.decaytime;
						}
						self.curprogress = self.curprogress - ((50 * self.userate) * decayscale);
						if(self.curprogress <= 0)
						{
							self clear_progress();
						}
						self update_current_progress();
						if(isdefined(self.onuseupdate))
						{
							self [[self.onuseupdate]](self get_claim_team(), self.curprogress / self.usetime, ((50 * self.userate) * decayscale) / self.usetime);
						}
						if(self.curprogress == 0)
						{
							self set_claim_team("none");
						}
					}
					else
					{
						if(!self.numtouching[self.claimteam])
						{
							if(isdefined(self.onenduse))
							{
								self [[self.onenduse]](self get_claim_team(), self.claimplayer, 0);
							}
							self set_claim_team("none");
							self.claimplayer = undefined;
						}
						else
						{
							self.curprogress = self.curprogress + (50 * self.userate);
							self update_current_progress();
							if(isdefined(self.onuseupdate))
							{
								self [[self.onuseupdate]](self get_claim_team(), self.curprogress / self.usetime, (50 * self.userate) / self.usetime);
							}
						}
					}
				}
				else
				{
					if(!self.mustmaintainclaim)
					{
						if(isdefined(self.onuse))
						{
							self [[self.onuse]](self.claimplayer);
						}
						if(!self.mustmaintainclaim)
						{
							self set_claim_team("none");
							self.claimplayer = undefined;
						}
					}
					else
					{
						if(!self.numtouching[self.claimteam])
						{
							if(isdefined(self.onunoccupied))
							{
								self [[self.onunoccupied]]();
							}
							self set_claim_team("none");
							self.claimplayer = undefined;
						}
						else if(self.cancontestclaim)
						{
							numother = get_num_touching_except_team(self.claimteam);
							if(numother > 0)
							{
								if(isdefined(self.oncontested))
								{
									self [[self.oncontested]]();
								}
								self set_claim_team("none");
								self.claimplayer = undefined;
							}
						}
					}
				}
			}
		}
		else
		{
			if(self.curprogress > 0 && (gettime() - self.lastclaimtime) > (self.claimgraceperiod * 1000))
			{
				self clear_progress();
			}
			if(self.mustmaintainclaim && self get_owner_team() != "none")
			{
				if(!self.numtouching[self get_owner_team()])
				{
					if(isdefined(self.onunoccupied))
					{
						self [[self.onunoccupied]]();
					}
				}
				else if(self.cancontestclaim && self.lastclaimteam != "none" && self.numtouching[self.lastclaimteam])
				{
					numother = get_num_touching_except_team(self.lastclaimteam);
					if(numother == 0)
					{
						if(isdefined(self.onuncontested))
						{
							self [[self.onuncontested]](self.lastclaimteam);
						}
					}
				}
			}
		}
		wait(0.05);
		hostmigration::waittillhostmigrationdone();
	}
}

/*
	Name: use_object_locked_for_team
	Namespace: gameobjects
	Checksum: 0x18D12F08
	Offset: 0x5998
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function use_object_locked_for_team(team)
{
	if(isdefined(self.teamlock) && isdefined(level.teams[team]))
	{
		return self.teamlock[team];
	}
	return 0;
}

/*
	Name: can_claim
	Namespace: gameobjects
	Checksum: 0x306555C3
	Offset: 0x59E0
	Size: 0x96
	Parameters: 1
	Flags: Linked
*/
function can_claim(player)
{
	if(isdefined(self.carrier))
	{
		return false;
	}
	if(self.cancontestclaim)
	{
		numother = get_num_touching_except_team(player.pers["team"]);
		if(numother != 0)
		{
			return false;
		}
	}
	if(!isdefined(self.keyobject) || player has_key_object(self))
	{
		return true;
	}
	return false;
}

/*
	Name: prox_trigger_think
	Namespace: gameobjects
	Checksum: 0x9B3AF5B6
	Offset: 0x5A80
	Size: 0x3D0
	Parameters: 0
	Flags: Linked
*/
function prox_trigger_think()
{
	level endon(#"game_ended");
	self.trigger endon(#"destroyed");
	entitynumber = self.entnum;
	if(!isdefined(self.trigger.remote_control_player_can_trigger))
	{
		self.trigger.remote_control_player_can_trigger = 0;
	}
	while(true)
	{
		self.trigger waittill(#"trigger", player);
		if(!isplayer(player))
		{
			continue;
		}
		if(player.using_map_vehicle === 1)
		{
			if(!isdefined(self.allow_map_vehicles) || self.allow_map_vehicles == 0)
			{
				continue;
			}
		}
		if(!isalive(player) || self use_object_locked_for_team(player.pers["team"]))
		{
			continue;
		}
		if(isdefined(player.laststand) && player.laststand)
		{
			continue;
		}
		if(player.spawntime == gettime())
		{
			continue;
		}
		if(self.trigger.remote_control_player_can_trigger == 0)
		{
			if(player isremotecontrolling() || player util::isusingremote())
			{
				continue;
			}
		}
		if(isdefined(player.selectinglocation) && player.selectinglocation)
		{
			continue;
		}
		if(player isweaponviewonlylinked())
		{
			continue;
		}
		if(self is_excluded(player))
		{
			continue;
		}
		if(isdefined(self.canuseobject) && ![[self.canuseobject]](player))
		{
			continue;
		}
		if(self can_interact_with(player) && self.claimteam == "none")
		{
			if(self can_claim(player))
			{
				set_claim_team(player.pers["team"]);
				self.claimplayer = player;
				relativeteam = self get_relative_team(player.pers["team"]);
				if(isdefined(self.teamusetimes[relativeteam]))
				{
					self.usetime = self.teamusetimes[relativeteam];
				}
				if(self.usetime && isdefined(self.onbeginuse))
				{
					self [[self.onbeginuse]](self.claimplayer);
				}
			}
			else if(isdefined(self.oncantuse))
			{
				self [[self.oncantuse]](player);
			}
		}
		if(isalive(player) && !isdefined(player.touchtriggers[entitynumber]))
		{
			player thread trigger_touch_think(self);
		}
	}
}

/*
	Name: is_excluded
	Namespace: gameobjects
	Checksum: 0x3C360BB0
	Offset: 0x5E58
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function is_excluded(player)
{
	if(!isdefined(self.exclusions))
	{
		return false;
	}
	foreach(exclusion in self.exclusions)
	{
		if(exclusion istouching(player))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: clear_progress
	Namespace: gameobjects
	Checksum: 0xD6BE9694
	Offset: 0x5F18
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function clear_progress()
{
	self.curprogress = 0;
	self update_current_progress();
	if(isdefined(self.onuseclear))
	{
		self [[self.onuseclear]]();
	}
}

/*
	Name: set_claim_team
	Namespace: gameobjects
	Checksum: 0x96D0B689
	Offset: 0x5F60
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function set_claim_team(newteam)
{
	/#
		assert(newteam != self.claimteam);
	#/
	if(self.claimteam == "none" && (gettime() - self.lastclaimtime) > (self.claimgraceperiod * 1000))
	{
		self clear_progress();
	}
	else if(newteam != "none" && newteam != self.lastclaimteam)
	{
		self clear_progress();
	}
	self.lastclaimteam = self.claimteam;
	self.lastclaimtime = gettime();
	self.claimteam = newteam;
	self update_use_rate();
}

/*
	Name: get_claim_team
	Namespace: gameobjects
	Checksum: 0x986DD103
	Offset: 0x6060
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_claim_team()
{
	return self.claimteam;
}

/*
	Name: continue_trigger_touch_think
	Namespace: gameobjects
	Checksum: 0x61E7E3A1
	Offset: 0x6078
	Size: 0x226
	Parameters: 2
	Flags: Linked
*/
function continue_trigger_touch_think(team, object)
{
	if(!isalive(self))
	{
		return false;
	}
	if(self.using_map_vehicle === 1)
	{
		if(!isdefined(object.allow_map_vehicles) || object.allow_map_vehicles == 0)
		{
			return false;
		}
	}
	else
	{
		if(!isdefined(object) || !isdefined(object.trigger) || !isdefined(object.trigger.remote_control_player_can_trigger) || object.trigger.remote_control_player_can_trigger == 0)
		{
			if(self isinvehicle())
			{
				return false;
			}
			if(self isremotecontrolling() || self util::isusingremote())
			{
				return false;
			}
		}
		else if(self isinvehicle() && (!(self isremotecontrolling() || self util::isusingremote())))
		{
			return false;
		}
	}
	if(self use_object_locked_for_team(team))
	{
		return false;
	}
	if(isdefined(self.laststand) && self.laststand)
	{
		return false;
	}
	if(!isdefined(object) || !isdefined(object.trigger))
	{
		return false;
	}
	if(!object.trigger istriggerenabled())
	{
		return false;
	}
	if(!self istouching(object.trigger))
	{
		return false;
	}
	return true;
}

/*
	Name: trigger_touch_think
	Namespace: gameobjects
	Checksum: 0x8E0F267F
	Offset: 0x62A8
	Size: 0x3A4
	Parameters: 1
	Flags: Linked
*/
function trigger_touch_think(object)
{
	team = self.pers["team"];
	score = 1;
	object.numtouching[team] = object.numtouching[team] + score;
	if(object.usetime)
	{
		object update_use_rate();
	}
	touchname = "player" + self.clientid;
	struct = spawnstruct();
	struct.player = self;
	struct.starttime = gettime();
	object.touchlist[team][touchname] = struct;
	objective_setplayerusing(object.objectiveid, self);
	self.touchtriggers[object.entnum] = object.trigger;
	if(isdefined(object.ontouchuse))
	{
		object [[object.ontouchuse]](self);
	}
	while(self continue_trigger_touch_think(team, object))
	{
		if(object.usetime)
		{
			self update_prox_bar(object, 0);
		}
		wait(0.05);
	}
	if(isdefined(self))
	{
		if(object.usetime)
		{
			self update_prox_bar(object, 1);
		}
		self.touchtriggers[object.entnum] = undefined;
		objective_clearplayerusing(object.objectiveid, self);
	}
	if(level.gameended)
	{
		return;
	}
	object.touchlist[team][touchname] = undefined;
	object.numtouching[team] = object.numtouching[team] - score;
	if(object.numtouching[team] < 1)
	{
		object.numtouching[team] = 0;
	}
	if(object.usetime)
	{
		if(object.numtouching[team] <= 0 && object.curprogress >= object.usetime)
		{
			object.curprogress = object.usetime - 1;
			object update_current_progress();
		}
	}
	if(isdefined(self) && isdefined(object.onendtouchuse))
	{
		object [[object.onendtouchuse]](self);
	}
	object update_use_rate();
}

/*
	Name: update_prox_bar
	Namespace: gameobjects
	Checksum: 0xEA1E0A98
	Offset: 0x6658
	Size: 0x5AC
	Parameters: 2
	Flags: Linked
*/
function update_prox_bar(object, forceremove)
{
	if(object.newstyle)
	{
		return;
	}
	if(!forceremove && object.decayprogress)
	{
		if(!object can_interact_with(self))
		{
			if(isdefined(self.proxbar))
			{
				self.proxbar hud::hideelem();
			}
			if(isdefined(self.proxbartext))
			{
				self.proxbartext hud::hideelem();
			}
			return;
		}
		if(!isdefined(self.proxbar))
		{
			self.proxbar = hud::createprimaryprogressbar();
			self.proxbar.lastuserate = -1;
		}
		if(self.pers["team"] == object.claimteam)
		{
			if(self.proxbar.bar.color != (1, 1, 1))
			{
				self.proxbar.bar.color = (1, 1, 1);
				self.proxbar.lastuserate = -1;
			}
		}
		else if(self.proxbar.bar.color != (1, 0, 0))
		{
			self.proxbar.bar.color = (1, 0, 0);
			self.proxbar.lastuserate = -1;
		}
	}
	else if(forceremove || !object can_interact_with(self) || self.pers["team"] != object.claimteam)
	{
		if(isdefined(self.proxbar))
		{
			self.proxbar hud::hideelem();
		}
		if(isdefined(self.proxbartext))
		{
			self.proxbartext hud::hideelem();
		}
		return;
	}
	if(!isdefined(self.proxbar))
	{
		self.proxbar = hud::createprimaryprogressbar();
		self.proxbar.lastuserate = -1;
		self.proxbar.lasthostmigrationstate = 0;
	}
	if(self.proxbar.hidden)
	{
		self.proxbar hud::showelem();
		self.proxbar.lastuserate = -1;
		self.proxbar.lasthostmigrationstate = 0;
	}
	if(!isdefined(self.proxbartext))
	{
		self.proxbartext = hud::createprimaryprogressbartext();
		self.proxbartext settext(object.usetext);
	}
	if(self.proxbartext.hidden)
	{
		self.proxbartext hud::showelem();
		self.proxbartext settext(object.usetext);
	}
	if(self.proxbar.lastuserate != object.userate || self.proxbar.lasthostmigrationstate != isdefined(level.hostmigrationtimer))
	{
		if(object.curprogress > object.usetime)
		{
			object.curprogress = object.usetime;
		}
		if(object.decayprogress && self.pers["team"] != object.claimteam)
		{
			if(object.curprogress > 0)
			{
				progress = object.curprogress / object.usetime;
				rate = (1000 / object.usetime) * (object.userate * -1);
				if(isdefined(level.hostmigrationtimer))
				{
					rate = 0;
				}
				self.proxbar hud::updatebar(progress, rate);
			}
		}
		else
		{
			progress = object.curprogress / object.usetime;
			rate = (1000 / object.usetime) * object.userate;
			if(isdefined(level.hostmigrationtimer))
			{
				rate = 0;
			}
			self.proxbar hud::updatebar(progress, rate);
		}
		self.proxbar.lasthostmigrationstate = isdefined(level.hostmigrationtimer);
		self.proxbar.lastuserate = object.userate;
	}
}

/*
	Name: get_num_touching_except_team
	Namespace: gameobjects
	Checksum: 0xB3EBE4DA
	Offset: 0x6C10
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function get_num_touching_except_team(ignoreteam)
{
	numtouching = 0;
	foreach(team in level.teams)
	{
		if(ignoreteam == team)
		{
			continue;
		}
		numtouching = numtouching + self.numtouching[team];
	}
	return numtouching;
}

/*
	Name: update_use_rate
	Namespace: gameobjects
	Checksum: 0x21899A96
	Offset: 0x6CD8
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function update_use_rate()
{
	numclaimants = self.numtouching[self.claimteam];
	numother = 0;
	numother = get_num_touching_except_team(self.claimteam);
	self.userate = 0;
	if(self.decayprogress)
	{
		if(numclaimants && !numother)
		{
			self.userate = numclaimants;
		}
		else
		{
			if(!numclaimants && numother)
			{
				self.userate = numother;
			}
			else if(!numclaimants && !numother)
			{
				self.userate = 0;
			}
		}
	}
	else if(numclaimants && !numother)
	{
		self.userate = numclaimants;
	}
	if(isdefined(self.onupdateuserate))
	{
		self [[self.onupdateuserate]]();
	}
}

/*
	Name: use_hold_think
	Namespace: gameobjects
	Checksum: 0x27B8F339
	Offset: 0x6DF0
	Size: 0x498
	Parameters: 2
	Flags: Linked
*/
function use_hold_think(player, disableweaponcyclingduringhold)
{
	player notify(#"use_hold");
	if(!(isdefined(self.dontlinkplayertotrigger) && self.dontlinkplayertotrigger))
	{
		if(!sessionmodeismultiplayergame())
		{
			gameobject_link = util::spawn_model("tag_origin", player.origin, player.angles);
			player playerlinkto(gameobject_link);
		}
		else
		{
			player playerlinkto(self.trigger);
			player playerlinkedoffsetenable();
		}
	}
	player clientclaimtrigger(self.trigger);
	player.claimtrigger = self.trigger;
	useweapon = self.useweapon;
	if(isdefined(useweapon))
	{
		player giveweapon(useweapon);
		player setweaponammostock(useweapon, 0);
		player setweaponammoclip(useweapon, 0);
		player switchtoweapon(useweapon);
	}
	else if(self.keepweapon !== 1)
	{
		player util::_disableweapon();
	}
	self clear_progress();
	self.inuse = 1;
	self.userate = 0;
	objective_setplayerusing(self.objectiveid, player);
	player thread personal_use_bar(self);
	if(disableweaponcyclingduringhold)
	{
		player disableweaponcycling();
		enableweaponcyclingafterhold = 1;
	}
	result = use_hold_think_loop(player);
	self.inuse = 0;
	if(isdefined(player))
	{
		if(enableweaponcyclingafterhold === 1)
		{
			player enableweaponcycling();
		}
		objective_clearplayerusing(self.objectiveid, player);
		self clear_progress();
		if(isdefined(player.attachedusemodel))
		{
			player detach(player.attachedusemodel, "tag_inhand");
			player.attachedusemodel = undefined;
		}
		player notify(#"done_using");
		if(isdefined(useweapon))
		{
			player thread take_use_weapon(useweapon);
		}
		player.claimtrigger = undefined;
		player clientreleasetrigger(self.trigger);
		if(isdefined(useweapon))
		{
			player killstreaks::switch_to_last_non_killstreak_weapon();
		}
		else if(self.keepweapon !== 1)
		{
			player util::_enableweapon();
		}
		if(!(isdefined(self.dontlinkplayertotrigger) && self.dontlinkplayertotrigger))
		{
			player unlink();
		}
		if(!isalive(player))
		{
			player.killedinuse = 1;
		}
		if(level.gameended)
		{
			player waitthenfreezeplayercontrolsifgameendedstill();
		}
	}
	if(isdefined(gameobject_link))
	{
		gameobject_link delete();
	}
	return result;
}

/*
	Name: waitthenfreezeplayercontrolsifgameendedstill
	Namespace: gameobjects
	Checksum: 0x1B80441B
	Offset: 0x7290
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function waitthenfreezeplayercontrolsifgameendedstill(wait_time = 1)
{
	player = self;
	wait(wait_time);
	if(isdefined(player) && level.gameended)
	{
		player freezecontrols(1);
	}
}

/*
	Name: take_use_weapon
	Namespace: gameobjects
	Checksum: 0x2CDF079B
	Offset: 0x7308
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function take_use_weapon(useweapon)
{
	self endon(#"use_hold");
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"game_ended");
	while(self getcurrentweapon() == useweapon && !self.throwinggrenade)
	{
		wait(0.05);
	}
	self takeweapon(useweapon);
}

/*
	Name: continue_hold_think_loop
	Namespace: gameobjects
	Checksum: 0xA69DACE4
	Offset: 0x7398
	Size: 0x206
	Parameters: 4
	Flags: Linked
*/
function continue_hold_think_loop(player, waitforweapon, timedout, usetime)
{
	maxwaittime = 1.5;
	if(!isalive(player))
	{
		return false;
	}
	if(isdefined(player.laststand) && player.laststand)
	{
		return false;
	}
	if(self.curprogress >= usetime)
	{
		return false;
	}
	if(!player usebuttonpressed())
	{
		return false;
	}
	if(player.throwinggrenade)
	{
		return false;
	}
	if(player isinvehicle())
	{
		return false;
	}
	if(player isremotecontrolling() || player util::isusingremote())
	{
		return false;
	}
	if(isdefined(player.selectinglocation) && player.selectinglocation)
	{
		return false;
	}
	if(player isweaponviewonlylinked())
	{
		return false;
	}
	if(!player istouching(self.trigger))
	{
		if(!isdefined(player.cursorhintent) || player.cursorhintent != self)
		{
			return false;
		}
	}
	if(!self.userate && !waitforweapon)
	{
		return false;
	}
	if(waitforweapon && timedout > maxwaittime)
	{
		return false;
	}
	if(isdefined(self.interrupted) && self.interrupted)
	{
		return false;
	}
	if(level.gameended)
	{
		return false;
	}
	return true;
}

/*
	Name: update_current_progress
	Namespace: gameobjects
	Checksum: 0x4C34A39
	Offset: 0x75A8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function update_current_progress()
{
	if(self.usetime)
	{
		if(isdefined(self.curprogress))
		{
			progress = float(self.curprogress) / self.usetime;
		}
		else
		{
			progress = 0;
		}
		objective_setprogress(self.objectiveid, math::clamp(progress, 0, 1));
	}
}

/*
	Name: use_hold_think_loop
	Namespace: gameobjects
	Checksum: 0xA6F94669
	Offset: 0x7640
	Size: 0x1AA
	Parameters: 1
	Flags: Linked
*/
function use_hold_think_loop(player)
{
	self endon(#"disabled");
	useweapon = self.useweapon;
	waitforweapon = 1;
	timedout = 0;
	usetime = self.usetime;
	while(self continue_hold_think_loop(player, waitforweapon, timedout, usetime))
	{
		timedout = timedout + 0.05;
		if(!isdefined(useweapon) || player getcurrentweapon() == useweapon)
		{
			self.curprogress = self.curprogress + (50 * self.userate);
			self update_current_progress();
			self.userate = 1;
			waitforweapon = 0;
		}
		else
		{
			self.userate = 0;
		}
		if(sessionmodeismultiplayergame())
		{
			if(self.curprogress >= usetime)
			{
				return true;
			}
			wait(0.05);
		}
		else
		{
			wait(0.05);
			if(self.curprogress >= usetime)
			{
				util::wait_network_frame();
				return true;
			}
		}
		hostmigration::waittillhostmigrationdone();
	}
	return false;
}

/*
	Name: personal_use_bar
	Namespace: gameobjects
	Checksum: 0x3C7598E6
	Offset: 0x77F8
	Size: 0x384
	Parameters: 1
	Flags: Linked
*/
function personal_use_bar(object)
{
	self endon(#"disconnect");
	if(object.newstyle)
	{
		return;
	}
	if(isdefined(self.usebar))
	{
		return;
	}
	self.usebar = hud::createprimaryprogressbar();
	self.usebartext = hud::createprimaryprogressbartext();
	self.usebartext settext(object.usetext);
	usetime = object.usetime;
	lastrate = -1;
	lasthostmigrationstate = isdefined(level.hostmigrationtimer);
	while(isalive(self) && object.inuse && !level.gameended)
	{
		if(lastrate != object.userate || lasthostmigrationstate != isdefined(level.hostmigrationtimer))
		{
			if(object.curprogress > usetime)
			{
				object.curprogress = usetime;
			}
			if(object.decayprogress && self.pers["team"] != object.claimteam)
			{
				if(object.curprogress > 0)
				{
					progress = object.curprogress / usetime;
					rate = (1000 / usetime) * (object.userate * -1);
					if(isdefined(level.hostmigrationtimer))
					{
						rate = 0;
					}
					self.proxbar hud::updatebar(progress, rate);
				}
			}
			else
			{
				progress = object.curprogress / usetime;
				rate = (1000 / usetime) * object.userate;
				if(isdefined(level.hostmigrationtimer))
				{
					rate = 0;
				}
				self.usebar hud::updatebar(progress, rate);
			}
			if(!object.userate)
			{
				self.usebar hud::hideelem();
				self.usebartext hud::hideelem();
			}
			else
			{
				self.usebar hud::showelem();
				self.usebartext hud::showelem();
			}
		}
		lastrate = object.userate;
		lasthostmigrationstate = isdefined(level.hostmigrationtimer);
		wait(0.05);
	}
	self.usebar hud::destroyelem();
	self.usebartext hud::destroyelem();
}

/*
	Name: update_trigger
	Namespace: gameobjects
	Checksum: 0x747AB918
	Offset: 0x7B88
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function update_trigger()
{
	if(self.triggertype != "use")
	{
		return;
	}
	if(self.interactteam == "none")
	{
		self.trigger triggerenable(0);
	}
	else
	{
		if(self.interactteam == "any" || !level.teambased)
		{
			self.trigger triggerenable(1);
			self.trigger setteamfortrigger("none");
		}
		else
		{
			if(self.interactteam == "friendly")
			{
				self.trigger triggerenable(1);
				if(isdefined(level.teams[self.ownerteam]))
				{
					self.trigger setteamfortrigger(self.ownerteam);
				}
				else
				{
					self.trigger triggerenable(0);
				}
			}
			else if(self.interactteam == "enemy")
			{
				self.trigger triggerenable(1);
				self.trigger setexcludeteamfortrigger(self.ownerteam);
			}
		}
	}
}

/*
	Name: update_objective
	Namespace: gameobjects
	Checksum: 0xB553AFF6
	Offset: 0x7D28
	Size: 0x28C
	Parameters: 0
	Flags: Linked
*/
function update_objective()
{
	if(!self.newstyle)
	{
		return;
	}
	objective_team(self.objectiveid, self.ownerteam);
	if(self.visibleteam == "any")
	{
		objective_state(self.objectiveid, "active");
		objective_visibleteams(self.objectiveid, level.spawnsystem.ispawn_teammask["all"]);
	}
	else
	{
		if(self.visibleteam == "friendly")
		{
			objective_state(self.objectiveid, "active");
			objective_visibleteams(self.objectiveid, level.spawnsystem.ispawn_teammask[self.ownerteam]);
		}
		else
		{
			if(self.visibleteam == "enemy")
			{
				objective_state(self.objectiveid, "active");
				objective_visibleteams(self.objectiveid, level.spawnsystem.ispawn_teammask["all"] & (~level.spawnsystem.ispawn_teammask[self.ownerteam]));
			}
			else
			{
				objective_state(self.objectiveid, "invisible");
				objective_visibleteams(self.objectiveid, 0);
			}
		}
	}
	if(self.type == "carryObject" || self.type == "packObject")
	{
		if(isalive(self.carrier))
		{
			objective_onentity(self.objectiveid, self.carrier);
		}
		else
		{
			if(isdefined(self.objectiveonvisuals) && self.objectiveonvisuals)
			{
				objective_onentity(self.objectiveid, self.visuals[0]);
			}
			else
			{
				objective_clearentity(self.objectiveid);
			}
		}
	}
}

/*
	Name: update_world_icons
	Namespace: gameobjects
	Checksum: 0x8DCE9B5A
	Offset: 0x7FC0
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function update_world_icons()
{
	if(self.visibleteam == "any")
	{
		update_world_icon("friendly", 1);
		update_world_icon("enemy", 1);
	}
	else
	{
		if(self.visibleteam == "friendly")
		{
			update_world_icon("friendly", 1);
			update_world_icon("enemy", 0);
		}
		else
		{
			if(self.visibleteam == "enemy")
			{
				update_world_icon("friendly", 0);
				update_world_icon("enemy", 1);
			}
			else
			{
				update_world_icon("friendly", 0);
				update_world_icon("enemy", 0);
			}
		}
	}
}

/*
	Name: update_world_icon
	Namespace: gameobjects
	Checksum: 0x23E69F8D
	Offset: 0x80F8
	Size: 0x32E
	Parameters: 2
	Flags: Linked
*/
function update_world_icon(relativeteam, showicon)
{
	if(self.newstyle)
	{
		return;
	}
	if(!isdefined(self.worldicons[relativeteam]))
	{
		showicon = 0;
	}
	updateteams = get_update_teams(relativeteam);
	for(index = 0; index < updateteams.size; index++)
	{
		if(!level.teambased && updateteams[index] != level.nonteambasedteam)
		{
			continue;
		}
		opname = (("objpoint_" + updateteams[index]) + "_") + self.entnum;
		objpoint = objpoints::get_by_name(opname);
		objpoint notify(#"stop_flashing_thread");
		objpoint thread objpoints::stop_flashing();
		if(showicon)
		{
			objpoint setshader(self.worldicons[relativeteam], level.objpointsize, level.objpointsize);
			objpoint fadeovertime(0.05);
			objpoint.alpha = objpoint.basealpha;
			objpoint.isshown = 1;
			iswaypoint = 1;
			if(isdefined(self.worldiswaypoint[relativeteam]))
			{
				iswaypoint = self.worldiswaypoint[relativeteam];
			}
			if(isdefined(self.compassicons[relativeteam]))
			{
				objpoint setwaypoint(iswaypoint, self.worldicons[relativeteam]);
			}
			else
			{
				objpoint setwaypoint(iswaypoint);
			}
			if(self.type == "carryObject" || self.type == "packObject")
			{
				if(isdefined(self.carrier) && !should_ping_object(relativeteam))
				{
					objpoint settargetent(self.carrier);
				}
				else
				{
					objpoint cleartargetent();
				}
			}
			continue;
		}
		objpoint fadeovertime(0.05);
		objpoint.alpha = 0;
		objpoint.isshown = 0;
		objpoint cleartargetent();
	}
}

/*
	Name: update_compass_icons
	Namespace: gameobjects
	Checksum: 0x3427E21B
	Offset: 0x8430
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function update_compass_icons()
{
	if(self.visibleteam == "any")
	{
		update_compass_icon("friendly", 1);
		update_compass_icon("enemy", 1);
	}
	else
	{
		if(self.visibleteam == "friendly")
		{
			update_compass_icon("friendly", 1);
			update_compass_icon("enemy", 0);
		}
		else
		{
			if(self.visibleteam == "enemy")
			{
				update_compass_icon("friendly", 0);
				update_compass_icon("enemy", 1);
			}
			else
			{
				update_compass_icon("friendly", 0);
				update_compass_icon("enemy", 0);
			}
		}
	}
}

/*
	Name: update_compass_icon
	Namespace: gameobjects
	Checksum: 0xCB4BB31A
	Offset: 0x8568
	Size: 0x26E
	Parameters: 2
	Flags: Linked
*/
function update_compass_icon(relativeteam, showicon)
{
	if(self.newstyle)
	{
		return;
	}
	updateteams = get_update_teams(relativeteam);
	for(index = 0; index < updateteams.size; index++)
	{
		showiconthisteam = showicon;
		if(!showiconthisteam && should_show_compass_due_to_radar(updateteams[index]))
		{
			showiconthisteam = 1;
		}
		if(level.teambased)
		{
			objid = self.objid[updateteams[index]];
		}
		else
		{
			objid = self.objid[level.nonteambasedteam];
		}
		if(!isdefined(self.compassicons[relativeteam]) || !showiconthisteam)
		{
			if(!sessionmodeiscampaigngame())
			{
				objective_state(objid, "invisible");
			}
			continue;
		}
		objective_icon(objid, self.compassicons[relativeteam]);
		if(!sessionmodeiscampaigngame())
		{
			objective_state(objid, "active");
		}
		if(self.type == "carryObject" || self.type == "packObject")
		{
			if(isalive(self.carrier) && !should_ping_object(relativeteam))
			{
				objective_onentity(objid, self.carrier);
				continue;
			}
			if(!sessionmodeiscampaigngame())
			{
				objective_clearentity(objid);
			}
			objective_position(objid, self.curorigin);
		}
	}
}

/*
	Name: hide_waypoint
	Namespace: gameobjects
	Checksum: 0x599F0506
	Offset: 0x87E0
	Size: 0x8C
	Parameters: 1
	Flags: None
*/
function hide_waypoint(e_player)
{
	if(isdefined(e_player))
	{
		/#
			assert(isplayer(e_player), "");
		#/
		objective_setinvisibletoplayer(self.objectiveid, e_player);
	}
	else
	{
		objective_setinvisibletoall(self.objectiveid);
	}
}

/*
	Name: show_waypoint
	Namespace: gameobjects
	Checksum: 0xCC2EA3B4
	Offset: 0x8878
	Size: 0x8C
	Parameters: 1
	Flags: None
*/
function show_waypoint(e_player)
{
	if(isdefined(e_player))
	{
		/#
			assert(isplayer(e_player), "");
		#/
		objective_setvisibletoplayer(self.objectiveid, e_player);
	}
	else
	{
		objective_setvisibletoall(self.objectiveid);
	}
}

/*
	Name: should_ping_object
	Namespace: gameobjects
	Checksum: 0x458B775B
	Offset: 0x8910
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function should_ping_object(relativeteam)
{
	if(relativeteam == "friendly" && self.objidpingfriendly)
	{
		return true;
	}
	if(relativeteam == "enemy" && self.objidpingenemy)
	{
		return true;
	}
	return false;
}

/*
	Name: get_update_teams
	Namespace: gameobjects
	Checksum: 0x26E67958
	Offset: 0x8970
	Size: 0x1C4
	Parameters: 1
	Flags: Linked
*/
function get_update_teams(relativeteam)
{
	updateteams = [];
	if(level.teambased)
	{
		if(relativeteam == "friendly")
		{
			foreach(team in level.teams)
			{
				if(self is_friendly_team(team))
				{
					updateteams[updateteams.size] = team;
				}
			}
		}
		else if(relativeteam == "enemy")
		{
			foreach(team in level.teams)
			{
				if(!self is_friendly_team(team))
				{
					updateteams[updateteams.size] = team;
				}
			}
		}
	}
	else
	{
		if(relativeteam == "friendly")
		{
			updateteams[updateteams.size] = level.nonteambasedteam;
		}
		else
		{
			updateteams[updateteams.size] = "axis";
		}
	}
	return updateteams;
}

/*
	Name: should_show_compass_due_to_radar
	Namespace: gameobjects
	Checksum: 0x6CF7B265
	Offset: 0x8B40
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function should_show_compass_due_to_radar(team)
{
	showcompass = 0;
	if(!isdefined(self.carrier))
	{
		return 0;
	}
	if(self.carrier hasperk("specialty_gpsjammer") == 0)
	{
		if(killstreaks::hasuav(team))
		{
			showcompass = 1;
		}
	}
	if(killstreaks::hassatellite(team))
	{
		showcompass = 1;
	}
	return showcompass;
}

/*
	Name: update_visibility_according_to_radar
	Namespace: gameobjects
	Checksum: 0xA2083056
	Offset: 0x8BE8
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function update_visibility_according_to_radar()
{
	self endon(#"death");
	self endon(#"carrier_cleared");
	while(true)
	{
		level waittill(#"radar_status_change");
		self update_compass_icons();
	}
}

/*
	Name: _set_team
	Namespace: gameobjects
	Checksum: 0xCFFF5854
	Offset: 0x8C38
	Size: 0xB6
	Parameters: 1
	Flags: Linked, Private
*/
function private _set_team(team)
{
	self.ownerteam = team;
	if(team != "any")
	{
		self.team = team;
		foreach(visual in self.visuals)
		{
			visual.team = team;
		}
	}
}

/*
	Name: set_owner_team
	Namespace: gameobjects
	Checksum: 0x6D78F2EF
	Offset: 0x8CF8
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function set_owner_team(team)
{
	self _set_team(team);
	self update_trigger();
	self update_icons_and_objective();
}

/*
	Name: get_owner_team
	Namespace: gameobjects
	Checksum: 0x98DB38C3
	Offset: 0x8D58
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_owner_team()
{
	return self.ownerteam;
}

/*
	Name: set_decay_time
	Namespace: gameobjects
	Checksum: 0x2E6F4ACB
	Offset: 0x8D70
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function set_decay_time(time)
{
	self.decaytime = int(time * 1000);
}

/*
	Name: set_use_time
	Namespace: gameobjects
	Checksum: 0x64B08F18
	Offset: 0x8DB0
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function set_use_time(time)
{
	self.usetime = int(time * 1000);
}

/*
	Name: set_use_text
	Namespace: gameobjects
	Checksum: 0xD4182D6C
	Offset: 0x8DF0
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function set_use_text(text)
{
	self.usetext = text;
}

/*
	Name: set_team_use_time
	Namespace: gameobjects
	Checksum: 0xC2AE9C23
	Offset: 0x8E10
	Size: 0x42
	Parameters: 2
	Flags: None
*/
function set_team_use_time(relativeteam, time)
{
	self.teamusetimes[relativeteam] = int(time * 1000);
}

/*
	Name: set_team_use_text
	Namespace: gameobjects
	Checksum: 0x75DB1836
	Offset: 0x8E60
	Size: 0x26
	Parameters: 2
	Flags: None
*/
function set_team_use_text(relativeteam, text)
{
	self.teamusetexts[relativeteam] = text;
}

/*
	Name: set_use_hint_text
	Namespace: gameobjects
	Checksum: 0x2AF8EA43
	Offset: 0x8E90
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function set_use_hint_text(text)
{
	self.trigger sethintstring(text);
}

/*
	Name: allow_carry
	Namespace: gameobjects
	Checksum: 0xA826FCB4
	Offset: 0x8EC8
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function allow_carry(relativeteam)
{
	allow_use(relativeteam);
}

/*
	Name: allow_use
	Namespace: gameobjects
	Checksum: 0x6075BAC7
	Offset: 0x8EF8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function allow_use(relativeteam)
{
	self.interactteam = relativeteam;
	update_trigger();
}

/*
	Name: set_visible_team
	Namespace: gameobjects
	Checksum: 0x316FFDF0
	Offset: 0x8F30
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function set_visible_team(relativeteam)
{
	self.visibleteam = relativeteam;
	if(!tweakables::gettweakablevalue("hud", "showobjicons"))
	{
		self.visibleteam = "none";
	}
	update_icons_and_objective();
}

/*
	Name: set_model_visibility
	Namespace: gameobjects
	Checksum: 0xFC5F6E90
	Offset: 0x8FA0
	Size: 0x18E
	Parameters: 1
	Flags: None
*/
function set_model_visibility(visibility)
{
	if(visibility)
	{
		for(index = 0; index < self.visuals.size; index++)
		{
			self.visuals[index] show();
			if(self.visuals[index].classname == "script_brushmodel" || self.visuals[index].classname == "script_model")
			{
				self.visuals[index] thread make_solid();
			}
		}
	}
	else
	{
		for(index = 0; index < self.visuals.size; index++)
		{
			self.visuals[index] ghost();
			if(self.visuals[index].classname == "script_brushmodel" || self.visuals[index].classname == "script_model")
			{
				self.visuals[index] notify(#"changing_solidness");
				self.visuals[index] notsolid();
			}
		}
	}
}

/*
	Name: make_solid
	Namespace: gameobjects
	Checksum: 0xB3AE3DB2
	Offset: 0x9138
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function make_solid()
{
	self endon(#"death");
	self notify(#"changing_solidness");
	self endon(#"changing_solidness");
	while(true)
	{
		for(i = 0; i < level.players.size; i++)
		{
			if(level.players[i] istouching(self))
			{
				break;
			}
		}
		if(i == level.players.size)
		{
			self solid();
			break;
		}
		wait(0.05);
	}
}

/*
	Name: set_carrier_visible
	Namespace: gameobjects
	Checksum: 0xE200A3BB
	Offset: 0x9200
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function set_carrier_visible(relativeteam)
{
	self.carriervisible = relativeteam;
}

/*
	Name: set_can_use
	Namespace: gameobjects
	Checksum: 0x546A8F8E
	Offset: 0x9220
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function set_can_use(relativeteam)
{
	self.useteam = relativeteam;
}

/*
	Name: set_2d_icon
	Namespace: gameobjects
	Checksum: 0xBE4E1343
	Offset: 0x9240
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function set_2d_icon(relativeteam, shader)
{
	self.compassicons[relativeteam] = shader;
	update_compass_icons();
}

/*
	Name: set_3d_icon
	Namespace: gameobjects
	Checksum: 0xD4A1135C
	Offset: 0x9288
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function set_3d_icon(relativeteam, shader)
{
	if(!isdefined(shader))
	{
		self.worldicons_disabled[relativeteam] = 1;
	}
	else
	{
		self.worldicons_disabled[relativeteam] = 0;
	}
	self.worldicons[relativeteam] = shader;
	update_world_icons();
}

/*
	Name: set_3d_icon_color
	Namespace: gameobjects
	Checksum: 0x1F70A2DF
	Offset: 0x9300
	Size: 0x12E
	Parameters: 3
	Flags: Linked
*/
function set_3d_icon_color(relativeteam, v_color, alpha)
{
	updateteams = get_update_teams(relativeteam);
	for(index = 0; index < updateteams.size; index++)
	{
		if(!level.teambased && updateteams[index] != level.nonteambasedteam)
		{
			continue;
		}
		opname = (("objpoint_" + updateteams[index]) + "_") + self.entnum;
		objpoint = objpoints::get_by_name(opname);
		if(isdefined(objpoint))
		{
			if(isdefined(v_color))
			{
				objpoint.color = v_color;
			}
			if(isdefined(alpha))
			{
				objpoint.alpha = alpha;
			}
		}
	}
}

/*
	Name: set_objective_color
	Namespace: gameobjects
	Checksum: 0xC21D0E62
	Offset: 0x9438
	Size: 0x12E
	Parameters: 3
	Flags: None
*/
function set_objective_color(relativeteam, v_color, alpha = 1)
{
	if(self.newstyle)
	{
		objective_setcolor(self.objectiveid, v_color[0], v_color[1], v_color[2], alpha);
	}
	else
	{
		a_teams = get_update_teams(relativeteam);
		for(index = 0; index < a_teams.size; index++)
		{
			if(!level.teambased && a_teams[index] != level.nonteambasedteam)
			{
				continue;
			}
			objective_setcolor(self.objid[a_teams[index]], v_color[0], v_color[1], v_color[2], alpha);
		}
	}
}

/*
	Name: set_objective_entity
	Namespace: gameobjects
	Checksum: 0x475AEFBC
	Offset: 0x9570
	Size: 0x102
	Parameters: 1
	Flags: None
*/
function set_objective_entity(entity)
{
	if(self.newstyle)
	{
		if(isdefined(self.objectiveid))
		{
			objective_onentity(self.objectiveid, entity);
		}
	}
	else
	{
		a_teams = get_update_teams(self.interactteam);
		foreach(str_team in a_teams)
		{
			objective_onentity(self.objid[str_team], entity);
		}
	}
}

/*
	Name: get_objective_ids
	Namespace: gameobjects
	Checksum: 0x7297B4BE
	Offset: 0x9680
	Size: 0x1D0
	Parameters: 1
	Flags: None
*/
function get_objective_ids(str_team)
{
	a_objective_ids = [];
	if(isdefined(self.newstyle) && self.newstyle)
	{
		if(!isdefined(a_objective_ids))
		{
			a_objective_ids = [];
		}
		else if(!isarray(a_objective_ids))
		{
			a_objective_ids = array(a_objective_ids);
		}
		a_objective_ids[a_objective_ids.size] = self.objectiveid;
	}
	else
	{
		a_keys = getarraykeys(self.objid);
		for(i = 0; i < a_keys.size; i++)
		{
			if(!isdefined(str_team) || str_team == a_keys[i])
			{
				if(!isdefined(a_objective_ids))
				{
					a_objective_ids = [];
				}
				else if(!isarray(a_objective_ids))
				{
					a_objective_ids = array(a_objective_ids);
				}
				a_objective_ids[a_objective_ids.size] = self.objid[a_keys[i]];
			}
		}
		if(!isdefined(a_objective_ids))
		{
			a_objective_ids = [];
		}
		else if(!isarray(a_objective_ids))
		{
			a_objective_ids = array(a_objective_ids);
		}
		a_objective_ids[a_objective_ids.size] = self.objectiveid;
	}
	return a_objective_ids;
}

/*
	Name: hide_icon_distance_and_los
	Namespace: gameobjects
	Checksum: 0xE4955DAA
	Offset: 0x9858
	Size: 0x1F8
	Parameters: 4
	Flags: None
*/
function hide_icon_distance_and_los(v_color, hide_distance, los_check, ignore_ent)
{
	self endon(#"disabled");
	self endon(#"destroyed_complete");
	while(true)
	{
		hide = 0;
		if(isdefined(self.worldicons_disabled["friendly"]) && self.worldicons_disabled["friendly"] == 1)
		{
			hide = 1;
		}
		if(!hide)
		{
			hide = 1;
			for(i = 0; i < level.players.size; i++)
			{
				n_dist = distance(level.players[i].origin, self.curorigin);
				if(n_dist < hide_distance)
				{
					if(isdefined(los_check) && los_check)
					{
						b_cansee = level.players[i] gameobject_is_player_looking_at(self.curorigin, 0.8, 1, ignore_ent, 42);
						if(b_cansee)
						{
							hide = 0;
							break;
						}
						continue;
					}
					hide = 0;
					break;
				}
			}
		}
		if(hide)
		{
			self set_3d_icon_color("friendly", v_color, 0);
		}
		else
		{
			self set_3d_icon_color("friendly", v_color, 1);
		}
		wait(0.05);
	}
}

/*
	Name: gameobject_is_player_looking_at
	Namespace: gameobjects
	Checksum: 0xD8E0AEBF
	Offset: 0x9A58
	Size: 0x240
	Parameters: 5
	Flags: Linked
*/
function gameobject_is_player_looking_at(origin, dot, do_trace, ignore_ent, ignore_trace_distance)
{
	/#
		assert(isplayer(self), "");
	#/
	if(!isdefined(dot))
	{
		dot = 0.7;
	}
	if(!isdefined(do_trace))
	{
		do_trace = 1;
	}
	eye = self util::get_eye();
	delta_vec = anglestoforward(vectortoangles(origin - eye));
	view_vec = anglestoforward(self getplayerangles());
	new_dot = vectordot(delta_vec, view_vec);
	if(new_dot >= dot)
	{
		if(do_trace)
		{
			trace = bullettrace(eye, origin, 0, ignore_ent);
			if(trace["position"] == origin)
			{
				return true;
			}
			if(isdefined(ignore_trace_distance))
			{
				n_mag = distance(origin, eye);
				n_dist = distance(trace["position"], eye);
				n_delta = abs(n_dist - n_mag);
				if(n_delta <= ignore_trace_distance)
				{
					return true;
				}
			}
		}
		else
		{
			return true;
		}
	}
	return false;
}

/*
	Name: hide_icons
	Namespace: gameobjects
	Checksum: 0x3F3D75F1
	Offset: 0x9CA0
	Size: 0x18C
	Parameters: 1
	Flags: None
*/
function hide_icons(team)
{
	if(self.visibleteam == "any" || self.visibleteam == "friendly")
	{
		hide_friendly = 1;
	}
	else
	{
		hide_friendly = 0;
	}
	if(self.visibleteam == "any" || self.visibleteam == "enemy")
	{
		hide_enemy = 1;
	}
	else
	{
		hide_enemy = 0;
	}
	self.hidden_compassicon = [];
	self.hidden_worldicon = [];
	if(hide_friendly == 1)
	{
		self.hidden_compassicon["friendly"] = self.compassicons["friendly"];
		self.hidden_worldicon["friendly"] = self.worldicons["friendly"];
	}
	if(hide_enemy == 1)
	{
		self.hidden_compassicon["enemy"] = self.compassicons["enemyy"];
		self.hidden_worldicon["enemy"] = self.worldicons["enemy"];
	}
	self set_2d_icon(team, undefined);
	self set_3d_icon(team, undefined);
}

/*
	Name: show_icons
	Namespace: gameobjects
	Checksum: 0x610AA78E
	Offset: 0x9E38
	Size: 0x7C
	Parameters: 1
	Flags: None
*/
function show_icons(team)
{
	if(isdefined(self.hidden_compassicon[team]))
	{
		self set_2d_icon(team, self.hidden_compassicon[team]);
	}
	if(isdefined(self.hidden_worldicon[team]))
	{
		self set_3d_icon(team, self.hidden_worldicon[team]);
	}
}

/*
	Name: set_3d_use_icon
	Namespace: gameobjects
	Checksum: 0x6D0DF958
	Offset: 0x9EC0
	Size: 0x26
	Parameters: 2
	Flags: None
*/
function set_3d_use_icon(relativeteam, shader)
{
	self.worlduseicons[relativeteam] = shader;
}

/*
	Name: set_3d_is_waypoint
	Namespace: gameobjects
	Checksum: 0xAF5AF8C5
	Offset: 0x9EF0
	Size: 0x26
	Parameters: 2
	Flags: None
*/
function set_3d_is_waypoint(relativeteam, waypoint)
{
	self.worldiswaypoint[relativeteam] = waypoint;
}

/*
	Name: set_carry_icon
	Namespace: gameobjects
	Checksum: 0xA8B7E38F
	Offset: 0x9F20
	Size: 0x48
	Parameters: 1
	Flags: None
*/
function set_carry_icon(shader)
{
	/#
		assert(self.type == "", "");
	#/
	self.carryicon = shader;
}

/*
	Name: set_visible_carrier_model
	Namespace: gameobjects
	Checksum: 0xDEE4DC23
	Offset: 0x9F70
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function set_visible_carrier_model(visiblemodel)
{
	self.visiblecarriermodel = visiblemodel;
}

/*
	Name: get_visible_carrier_model
	Namespace: gameobjects
	Checksum: 0xB71CC207
	Offset: 0x9F90
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_visible_carrier_model()
{
	return self.visiblecarriermodel;
}

/*
	Name: destroy_object
	Namespace: gameobjects
	Checksum: 0x50039FD8
	Offset: 0x9FA8
	Size: 0x18A
	Parameters: 3
	Flags: None
*/
function destroy_object(deletetrigger, forcehide = 1, b_connect_paths = 0)
{
	self disable_object(forcehide);
	foreach(visual in self.visuals)
	{
		if(b_connect_paths)
		{
			visual connectpaths();
		}
		if(isdefined(visual))
		{
			visual ghost();
			visual delete();
		}
	}
	self.trigger notify(#"destroyed");
	if(isdefined(deletetrigger) && deletetrigger)
	{
		self.trigger delete();
	}
	else
	{
		self.trigger triggerenable(1);
	}
	self notify(#"destroyed_complete");
}

/*
	Name: disable_object
	Namespace: gameobjects
	Checksum: 0xA6B26050
	Offset: 0xA140
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function disable_object(forcehide)
{
	self notify(#"disabled");
	if(self.type == "carryObject" || self.type == "packObject" || (isdefined(forcehide) && forcehide))
	{
		if(isdefined(self.carrier))
		{
			self.carrier take_object(self);
		}
		for(index = 0; index < self.visuals.size; index++)
		{
			if(isdefined(self.visuals[index]))
			{
				self.visuals[index] ghost();
			}
		}
	}
	self.trigger triggerenable(0);
	self set_visible_team("none");
	if(isdefined(self.objectiveid))
	{
		objective_clearentity(self.objectiveid);
	}
}

/*
	Name: enable_object
	Namespace: gameobjects
	Checksum: 0x97D77F34
	Offset: 0xA290
	Size: 0xFC
	Parameters: 1
	Flags: None
*/
function enable_object(forceshow)
{
	if(self.type == "carryObject" || self.type == "packObject" || (isdefined(forceshow) && forceshow))
	{
		for(index = 0; index < self.visuals.size; index++)
		{
			self.visuals[index] show();
		}
	}
	self.trigger triggerenable(1);
	self set_visible_team("any");
	if(isdefined(self.objectiveid))
	{
		objective_onentity(self.objectiveid, self);
	}
}

/*
	Name: get_relative_team
	Namespace: gameobjects
	Checksum: 0xC284422
	Offset: 0xA398
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function get_relative_team(team)
{
	if(self.ownerteam == "any")
	{
		return "friendly";
	}
	if(team == self.ownerteam)
	{
		return "friendly";
	}
	if(team == get_enemy_team(self.ownerteam))
	{
		return "enemy";
	}
	return "neutral";
}

/*
	Name: is_friendly_team
	Namespace: gameobjects
	Checksum: 0x74FDE2AF
	Offset: 0xA420
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function is_friendly_team(team)
{
	if(!level.teambased)
	{
		return true;
	}
	if(self.ownerteam == "any")
	{
		return true;
	}
	if(self.ownerteam == team)
	{
		return true;
	}
	return false;
}

/*
	Name: can_interact_with
	Namespace: gameobjects
	Checksum: 0x64A9A256
	Offset: 0xA478
	Size: 0x1A6
	Parameters: 1
	Flags: Linked
*/
function can_interact_with(player)
{
	if(player.using_map_vehicle === 1)
	{
		if(!isdefined(self.allow_map_vehicles) || self.allow_map_vehicles == 0)
		{
			return false;
		}
	}
	team = player.pers["team"];
	switch(self.interactteam)
	{
		case "none":
		{
			return false;
		}
		case "any":
		{
			return true;
		}
		case "friendly":
		{
			if(level.teambased)
			{
				if(team == self.ownerteam)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				if(player == self.ownerteam)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		case "enemy":
		{
			if(level.teambased)
			{
				if(team != self.ownerteam)
				{
					return true;
				}
				else
				{
					if(isdefined(self.decayprogress) && self.decayprogress && self.curprogress > 0)
					{
						return true;
					}
					else
					{
						return false;
					}
				}
			}
			else
			{
				if(player != self.ownerteam)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		default:
		{
			/#
				assert(0, "");
			#/
			return false;
		}
	}
}

/*
	Name: is_team
	Namespace: gameobjects
	Checksum: 0x6946FABD
	Offset: 0xA628
	Size: 0x5A
	Parameters: 1
	Flags: None
*/
function is_team(team)
{
	switch(team)
	{
		case "any":
		case "neutral":
		case "none":
		{
			return true;
			break;
		}
	}
	if(isdefined(level.teams[team]))
	{
		return true;
	}
	return false;
}

/*
	Name: is_relative_team
	Namespace: gameobjects
	Checksum: 0xAA3FCA20
	Offset: 0xA690
	Size: 0x56
	Parameters: 1
	Flags: None
*/
function is_relative_team(relativeteam)
{
	switch(relativeteam)
	{
		case "any":
		case "enemy":
		case "friendly":
		case "none":
		{
			return true;
			break;
		}
		default:
		{
			return false;
			break;
		}
	}
}

/*
	Name: get_enemy_team
	Namespace: gameobjects
	Checksum: 0x3CE61800
	Offset: 0xA6F0
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function get_enemy_team(team)
{
	switch(team)
	{
		case "neutral":
		{
			return "none";
			break;
		}
		case "allies":
		{
			return "axis";
			break;
		}
		default:
		{
			return "allies";
			break;
		}
	}
}

/*
	Name: get_next_obj_id
	Namespace: gameobjects
	Checksum: 0xEFC1C87C
	Offset: 0xA758
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function get_next_obj_id()
{
	nextid = 0;
	if(level.releasedobjectives.size > 0)
	{
		nextid = level.releasedobjectives[level.releasedobjectives.size - 1];
		level.releasedobjectives[level.releasedobjectives.size - 1] = undefined;
	}
	else
	{
		nextid = level.numgametypereservedobjectives;
		level.numgametypereservedobjectives++;
	}
	/#
		if(nextid >= 128)
		{
			println("");
		}
	#/
	if(nextid > 127)
	{
		nextid = 127;
	}
	return nextid;
}

/*
	Name: release_obj_id
	Namespace: gameobjects
	Checksum: 0xDA1D62C
	Offset: 0xA818
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function release_obj_id(objid)
{
	/#
		assert(objid < level.numgametypereservedobjectives);
	#/
	for(i = 0; i < level.releasedobjectives.size; i++)
	{
		if(objid == level.releasedobjectives[i] && objid == 127)
		{
			return;
		}
		/#
			/#
				assert(objid != level.releasedobjectives[i]);
			#/
		#/
	}
	level.releasedobjectives[level.releasedobjectives.size] = objid;
	objective_setcolor(objid, 1, 1, 1, 1);
	objective_state(objid, "empty");
}

/*
	Name: release_all_objective_ids
	Namespace: gameobjects
	Checksum: 0x99534E1F
	Offset: 0xA938
	Size: 0xAC
	Parameters: 0
	Flags: None
*/
function release_all_objective_ids()
{
	if(isdefined(self.objid))
	{
		a_keys = getarraykeys(self.objid);
		for(i = 0; i < a_keys.size; i++)
		{
			release_obj_id(self.objid[a_keys[i]]);
		}
	}
	if(isdefined(self.objectiveid))
	{
		release_obj_id(self.objectiveid);
	}
}

/*
	Name: get_label
	Namespace: gameobjects
	Checksum: 0x18E84BA2
	Offset: 0xA9F0
	Size: 0x66
	Parameters: 0
	Flags: None
*/
function get_label()
{
	label = self.trigger.script_label;
	if(!isdefined(label))
	{
		label = "";
		return label;
	}
	if(label[0] != "_")
	{
		return "_" + label;
	}
	return label;
}

/*
	Name: must_maintain_claim
	Namespace: gameobjects
	Checksum: 0x8A97C263
	Offset: 0xAA60
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function must_maintain_claim(enabled)
{
	self.mustmaintainclaim = enabled;
}

/*
	Name: can_contest_claim
	Namespace: gameobjects
	Checksum: 0x5377AF22
	Offset: 0xAA80
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function can_contest_claim(enabled)
{
	self.cancontestclaim = enabled;
}

/*
	Name: set_flags
	Namespace: gameobjects
	Checksum: 0x4E6917B7
	Offset: 0xAAA0
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function set_flags(flags)
{
	objective_setgamemodeflags(self.objectiveid, flags);
}

/*
	Name: get_flags
	Namespace: gameobjects
	Checksum: 0x9E6D636C
	Offset: 0xAAD8
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function get_flags(flags)
{
	return objective_getgamemodeflags(self.objectiveid);
}

/*
	Name: create_pack_object
	Namespace: gameobjects
	Checksum: 0x37C1B5CE
	Offset: 0xAB08
	Size: 0x998
	Parameters: 5
	Flags: None
*/
function create_pack_object(ownerteam, trigger, visuals, offset, objectivename)
{
	if(!isdefined(level.max_packobjects))
	{
		level.max_packobjects = 4;
	}
	/#
		assert(level.max_packobjects < 5, "");
	#/
	packobject = spawnstruct();
	packobject.type = "packObject";
	packobject.curorigin = trigger.origin;
	packobject.entnum = trigger getentitynumber();
	if(issubstr(trigger.classname, "use"))
	{
		packobject.triggertype = "use";
	}
	else
	{
		packobject.triggertype = "proximity";
	}
	trigger.baseorigin = trigger.origin;
	packobject.trigger = trigger;
	packobject.useweapon = undefined;
	if(!isdefined(offset))
	{
		offset = (0, 0, 0);
	}
	packobject.offset3d = offset;
	packobject.newstyle = 0;
	if(isdefined(objectivename))
	{
		if(!sessionmodeiscampaigngame())
		{
			packobject.newstyle = 1;
		}
	}
	else
	{
		objectivename = &"";
	}
	for(index = 0; index < visuals.size; index++)
	{
		visuals[index].baseorigin = visuals[index].origin;
		visuals[index].baseangles = visuals[index].angles;
	}
	packobject.visuals = visuals;
	packobject _set_team(ownerteam);
	packobject.compassicons = [];
	packobject.objid = [];
	if(!packobject.newstyle)
	{
		foreach(team in level.teams)
		{
			packobject.objid[team] = get_next_obj_id();
		}
	}
	packobject.objidpingfriendly = 0;
	packobject.objidpingenemy = 0;
	level.objidstart = level.objidstart + 2;
	if(!packobject.newstyle)
	{
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				objective_add(packobject.objid[team], "invisible", packobject.curorigin);
				objective_team(packobject.objid[team], team);
				packobject.objpoints[team] = objpoints::create((("objpoint_" + team) + "_") + packobject.entnum, packobject.curorigin + offset, team, undefined);
				packobject.objpoints[team].alpha = 0;
			}
		}
		else
		{
			objective_add(packobject.objid[level.nonteambasedteam], "invisible", packobject.curorigin);
			packobject.objpoints[level.nonteambasedteam] = objpoints::create((("objpoint_" + level.nonteambasedteam) + "_") + packobject.entnum, packobject.curorigin + offset, "all", undefined);
			packobject.objpoints[level.nonteambasedteam].alpha = 0;
		}
	}
	packobject.objectiveid = get_next_obj_id();
	if(packobject.newstyle)
	{
		objective_add(packobject.objectiveid, "invisible", packobject.curorigin, objectivename);
	}
	packobject.carrier = undefined;
	packobject.isresetting = 0;
	packobject.interactteam = "none";
	packobject.allowweapons = 1;
	packobject.visiblecarriermodel = undefined;
	packobject.dropoffset = 0;
	packobject.worldicons = [];
	packobject.carriervisible = 0;
	packobject.visibleteam = "none";
	packobject.worldiswaypoint = [];
	packobject.worldicons_disabled = [];
	packobject.packicon = undefined;
	packobject.setdropped = undefined;
	packobject.ondrop = undefined;
	packobject.onpickup = undefined;
	packobject.onreset = undefined;
	if(packobject.triggertype == "use")
	{
		packobject thread carry_object_use_think();
	}
	else
	{
		packobject.numtouching["neutral"] = 0;
		packobject.numtouching["none"] = 0;
		packobject.touchlist["neutral"] = [];
		packobject.touchlist["none"] = [];
		foreach(team in level.teams)
		{
			packobject.numtouching[team] = 0;
			packobject.touchlist[team] = [];
		}
		packobject.curprogress = 0;
		packobject.usetime = 0;
		packobject.userate = 0;
		packobject.claimteam = "none";
		packobject.claimplayer = undefined;
		packobject.lastclaimteam = "none";
		packobject.lastclaimtime = 0;
		packobject.claimgraceperiod = 0;
		packobject.mustmaintainclaim = 0;
		packobject.cancontestclaim = 0;
		packobject.decayprogress = 0;
		packobject.teamusetimes = [];
		packobject.teamusetexts = [];
		packobject.onuse = &set_picked_up;
		packobject thread use_object_prox_think();
	}
	packobject thread update_carry_object_origin();
	packobject thread update_carry_object_objective_origin();
	return packobject;
}

/*
	Name: give_pack_object
	Namespace: gameobjects
	Checksum: 0x8BF9A107
	Offset: 0xB4A8
	Size: 0x1E6
	Parameters: 1
	Flags: Linked
*/
function give_pack_object(object)
{
	self.packobject[self.packobject.size] = object;
	self thread track_carrier(object);
	if(!object.newstyle)
	{
		if(isdefined(object.packicon))
		{
			if(self issplitscreen())
			{
				elem = hud::createicon(object.packicon, 25, 25);
				elem.y = -90;
				elem.horzalign = "right";
				elem.vertalign = "bottom";
			}
			else
			{
				elem = hud::createicon(object.packicon, 35, 35);
				elem.y = -110;
				elem.horzalign = "user_right";
				elem.vertalign = "user_bottom";
			}
			elem.x = get_packicon_offset(self.packicon.size);
			elem.alpha = 0.75;
			elem.hidewhileremotecontrolling = 1;
			elem.hidewheninkillcam = 1;
			elem.script_string = object.packicon;
			self.packicon[self.packicon.size] = elem;
		}
	}
}

/*
	Name: get_packicon_offset
	Namespace: gameobjects
	Checksum: 0xFE5E94A4
	Offset: 0xB698
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function get_packicon_offset(index = 0)
{
	if(self issplitscreen())
	{
		size = 25;
		base = -130;
	}
	else
	{
		size = 35;
		base = -40;
	}
	int = base - (size * index);
	return int;
}

/*
	Name: adjust_remaining_packicons
	Namespace: gameobjects
	Checksum: 0x77B319A0
	Offset: 0xB738
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function adjust_remaining_packicons()
{
	if(!isdefined(self.packicon))
	{
		return;
	}
	if(self.packicon.size > 0)
	{
		for(i = 0; i < self.packicon.size; i++)
		{
			self.packicon[i].x = get_packicon_offset(i);
		}
	}
}

/*
	Name: set_pack_icon
	Namespace: gameobjects
	Checksum: 0xC66754AA
	Offset: 0xB7C0
	Size: 0x48
	Parameters: 1
	Flags: None
*/
function set_pack_icon(shader)
{
	/#
		assert(self.type == "", "");
	#/
	self.packicon = shader;
}

