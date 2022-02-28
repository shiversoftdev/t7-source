// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace oob;

/*
	Name: __init__sytem__
	Namespace: oob
	Checksum: 0xAE8C057D
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("out_of_bounds", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: oob
	Checksum: 0x7D58F041
	Offset: 0x240
	Size: 0x2D4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.oob_triggers = [];
	if(sessionmodeismultiplayergame())
	{
		level.oob_timekeep_ms = getdvarint("oob_timekeep_ms", 3000);
		level.oob_timelimit_ms = getdvarint("oob_timelimit_ms", 3000);
		level.oob_damage_interval_ms = getdvarint("oob_damage_interval_ms", 3000);
		level.oob_damage_per_interval = getdvarint("oob_damage_per_interval", 999);
		level.oob_max_distance_before_black = getdvarint("oob_max_distance_before_black", 100000);
		level.oob_time_remaining_before_black = getdvarint("oob_time_remaining_before_black", -1);
	}
	else
	{
		level.oob_timelimit_ms = getdvarint("oob_timelimit_ms", 6000);
		level.oob_damage_interval_ms = getdvarint("oob_damage_interval_ms", 1000);
		level.oob_damage_per_interval = getdvarint("oob_damage_per_interval", 5);
		level.oob_max_distance_before_black = getdvarint("oob_max_distance_before_black", 400);
		level.oob_time_remaining_before_black = getdvarint("oob_time_remaining_before_black", 1000);
	}
	level.oob_damage_interval_sec = level.oob_damage_interval_ms / 1000;
	hurt_triggers = getentarray("trigger_out_of_bounds", "classname");
	foreach(trigger in hurt_triggers)
	{
		trigger thread run_oob_trigger();
	}
	clientfield::register("toplayer", "out_of_bounds", 1, 5, "int");
}

/*
	Name: run_oob_trigger
	Namespace: oob
	Checksum: 0x783E749C
	Offset: 0x520
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function run_oob_trigger()
{
	self.oob_players = [];
	if(!isdefined(level.oob_triggers))
	{
		level.oob_triggers = [];
	}
	else if(!isarray(level.oob_triggers))
	{
		level.oob_triggers = array(level.oob_triggers);
	}
	level.oob_triggers[level.oob_triggers.size] = self;
	self thread waitforplayertouch();
	self thread waitforclonetouch();
}

/*
	Name: isoutofbounds
	Namespace: oob
	Checksum: 0x7F9C0879
	Offset: 0x5D0
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function isoutofbounds()
{
	if(!isdefined(self.oob_start_time))
	{
		return 0;
	}
	return self.oob_start_time != -1;
}

/*
	Name: istouchinganyoobtrigger
	Namespace: oob
	Checksum: 0x93E8A62E
	Offset: 0x5F8
	Size: 0x1D6
	Parameters: 0
	Flags: Linked
*/
function istouchinganyoobtrigger()
{
	triggers_to_remove = [];
	result = 0;
	foreach(trigger in level.oob_triggers)
	{
		if(!isdefined(trigger))
		{
			if(!isdefined(triggers_to_remove))
			{
				triggers_to_remove = [];
			}
			else if(!isarray(triggers_to_remove))
			{
				triggers_to_remove = array(triggers_to_remove);
			}
			triggers_to_remove[triggers_to_remove.size] = trigger;
			continue;
		}
		if(!trigger istriggerenabled())
		{
			continue;
		}
		if(self istouching(trigger))
		{
			result = 1;
			break;
		}
	}
	foreach(trigger in triggers_to_remove)
	{
		arrayremovevalue(level.oob_triggers, trigger);
	}
	triggers_to_remove = [];
	triggers_to_remove = undefined;
	return result;
}

/*
	Name: resetoobtimer
	Namespace: oob
	Checksum: 0x59FE2514
	Offset: 0x7D8
	Size: 0xC6
	Parameters: 2
	Flags: Linked
*/
function resetoobtimer(is_host_migrating, b_disable_timekeep)
{
	self.oob_lastvalidplayerloc = undefined;
	self.oob_lastvalidplayerdir = undefined;
	self clientfield::set_to_player("out_of_bounds", 0);
	self util::show_hud(1);
	self.oob_start_time = -1;
	if(isdefined(level.oob_timekeep_ms))
	{
		if(isdefined(b_disable_timekeep) && b_disable_timekeep)
		{
			self.last_oob_timekeep_ms = undefined;
		}
		else
		{
			self.last_oob_timekeep_ms = gettime();
		}
	}
	if(!(isdefined(is_host_migrating) && is_host_migrating))
	{
		self notify(#"oob_host_migration_exit");
	}
	self notify(#"oob_exit");
}

/*
	Name: waitforclonetouch
	Namespace: oob
	Checksum: 0x2F380CD2
	Offset: 0x8A8
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function waitforclonetouch()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", clone);
		if(isactor(clone) && isdefined(clone.isaiclone) && clone.isaiclone && !clone isplayinganimscripted())
		{
			clone notify(#"clone_shutdown");
		}
	}
}

/*
	Name: getadjusedplayer
	Namespace: oob
	Checksum: 0xAFC02708
	Offset: 0x950
	Size: 0x50
	Parameters: 1
	Flags: None
*/
function getadjusedplayer(player)
{
	if(isdefined(player.hijacked_vehicle_entity) && isalive(player.hijacked_vehicle_entity))
	{
		return player.hijacked_vehicle_entity;
	}
	return player;
}

/*
	Name: waitforplayertouch
	Namespace: oob
	Checksum: 0xA3D43195
	Offset: 0x9A8
	Size: 0x310
	Parameters: 0
	Flags: Linked
*/
function waitforplayertouch()
{
	self endon(#"death");
	while(true)
	{
		if(sessionmodeismultiplayergame())
		{
			hostmigration::waittillhostmigrationdone();
		}
		self waittill(#"trigger", entity);
		if(!isplayer(entity) && (!(isvehicle(entity) && (isdefined(entity.hijacked) && entity.hijacked) && isdefined(entity.owner) && isalive(entity))))
		{
			continue;
		}
		if(isplayer(entity))
		{
			player = entity;
		}
		else
		{
			vehicle = entity;
			player = vehicle.owner;
		}
		if(!player isoutofbounds() && !player isplayinganimscripted() && (!(isdefined(player.oobdisabled) && player.oobdisabled)))
		{
			player notify(#"oob_enter");
			if(isdefined(level.oob_timekeep_ms) && isdefined(player.last_oob_timekeep_ms) && isdefined(player.last_oob_duration_ms) && (gettime() - player.last_oob_timekeep_ms) < level.oob_timekeep_ms)
			{
				player.oob_start_time = gettime() - (level.oob_timelimit_ms - player.last_oob_duration_ms);
			}
			else
			{
				player.oob_start_time = gettime();
			}
			player.oob_lastvalidplayerloc = entity.origin;
			player.oob_lastvalidplayerdir = vectornormalize(entity getvelocity());
			player util::show_hud(0);
			player thread watchforleave(self, entity);
			player thread watchfordeath(self, entity);
			if(sessionmodeismultiplayergame())
			{
				player thread watchforhostmigration(self, entity);
			}
		}
	}
}

/*
	Name: getdistancefromlastvalidplayerloc
	Namespace: oob
	Checksum: 0x524E78F8
	Offset: 0xCC0
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function getdistancefromlastvalidplayerloc(trigger, entity)
{
	if(isdefined(self.oob_lastvalidplayerdir) && self.oob_lastvalidplayerdir != (0, 0, 0))
	{
		vectoplayerlocfromorigin = entity.origin - self.oob_lastvalidplayerloc;
		distance = vectordot(vectoplayerlocfromorigin, self.oob_lastvalidplayerdir);
	}
	else
	{
		distance = distance(entity.origin, self.oob_lastvalidplayerloc);
	}
	if(distance < 0)
	{
		distance = 0;
	}
	if(distance > level.oob_max_distance_before_black)
	{
		distance = level.oob_max_distance_before_black;
	}
	return distance / level.oob_max_distance_before_black;
}

/*
	Name: updatevisualeffects
	Namespace: oob
	Checksum: 0xEDC2676F
	Offset: 0xDB8
	Size: 0x1B4
	Parameters: 2
	Flags: Linked
*/
function updatevisualeffects(trigger, entity)
{
	timeremaining = level.oob_timelimit_ms - (gettime() - self.oob_start_time);
	if(isdefined(level.oob_timekeep_ms))
	{
		self.last_oob_duration_ms = timeremaining;
	}
	oob_effectvalue = 0;
	if(timeremaining <= level.oob_time_remaining_before_black)
	{
		if(!isdefined(self.oob_lasteffectvalue))
		{
			self.oob_lasteffectvalue = getdistancefromlastvalidplayerloc(trigger, entity);
		}
		time_val = 1 - (timeremaining / level.oob_time_remaining_before_black);
		if(time_val > 1)
		{
			time_val = 1;
		}
		oob_effectvalue = self.oob_lasteffectvalue + ((1 - self.oob_lasteffectvalue) * time_val);
	}
	else
	{
		oob_effectvalue = getdistancefromlastvalidplayerloc(trigger, entity);
		if(oob_effectvalue > 0.9)
		{
			oob_effectvalue = 0.9;
		}
		else if(oob_effectvalue < 0.05)
		{
			oob_effectvalue = 0.05;
		}
		self.oob_lasteffectvalue = oob_effectvalue;
	}
	oob_effectvalue = ceil(oob_effectvalue * 31);
	self clientfield::set_to_player("out_of_bounds", int(oob_effectvalue));
}

/*
	Name: killentity
	Namespace: oob
	Checksum: 0xEF12AF99
	Offset: 0xF78
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function killentity(entity)
{
	entity_to_kill = entity;
	if(isplayer(entity) && entity isinvehicle())
	{
		vehicle = entity getvehicleoccupied();
		if(isdefined(vehicle) && vehicle.is_oob_kill_target === 1)
		{
			entity_to_kill = vehicle;
		}
	}
	self resetoobtimer();
	entity_to_kill dodamage(entity_to_kill.health + 10000, entity_to_kill.origin, undefined, undefined, "none", "MOD_TRIGGER_HURT");
}

/*
	Name: watchforleave
	Namespace: oob
	Checksum: 0xAAB08131
	Offset: 0x1078
	Size: 0x140
	Parameters: 2
	Flags: Linked
*/
function watchforleave(trigger, entity)
{
	self endon(#"oob_exit");
	entity endon(#"death");
	while(true)
	{
		if(entity istouchinganyoobtrigger())
		{
			updatevisualeffects(trigger, entity);
			if((level.oob_timelimit_ms - (gettime() - self.oob_start_time)) <= 0)
			{
				if(isplayer(entity))
				{
					entity disableinvulnerability();
					entity.ignoreme = 0;
					entity.laststand = undefined;
					if(isdefined(entity.revivetrigger))
					{
						entity.revivetrigger delete();
					}
				}
				self thread killentity(entity);
			}
		}
		else
		{
			self resetoobtimer();
		}
		wait(0.1);
	}
}

/*
	Name: watchfordeath
	Namespace: oob
	Checksum: 0x8E5E8487
	Offset: 0x11C0
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function watchfordeath(trigger, entity)
{
	self endon(#"disconnect");
	self endon(#"oob_exit");
	util::waittill_any_ents_two(self, "death", entity, "death");
	self resetoobtimer();
}

/*
	Name: watchforhostmigration
	Namespace: oob
	Checksum: 0xDA556949
	Offset: 0x1238
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function watchforhostmigration(trigger, entity)
{
	self endon(#"oob_host_migration_exit");
	level waittill(#"host_migration_begin");
	self resetoobtimer(1, 1);
}

/*
	Name: disableplayeroob
	Namespace: oob
	Checksum: 0x6CF93AE2
	Offset: 0x1290
	Size: 0x48
	Parameters: 1
	Flags: None
*/
function disableplayeroob(disabled)
{
	if(disabled)
	{
		self resetoobtimer();
		self.oobdisabled = 1;
	}
	else
	{
		self.oobdisabled = 0;
	}
}

