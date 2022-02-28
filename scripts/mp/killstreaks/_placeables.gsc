// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\_oob;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\util_shared;

#namespace placeables;

/*
	Name: spawnplaceable
	Namespace: placeables
	Checksum: 0x27EAC78D
	Offset: 0x280
	Size: 0x598
	Parameters: 18
	Flags: Linked
*/
function spawnplaceable(killstreakref, killstreakid, onplacecallback, oncancelcallback, onmovecallback, onshutdowncallback, ondeathcallback, onempcallback, model, validmodel, invalidmodel, spawnsvehicle, pickupstring, timeout, health, empdamage, placehintstring, invalidlocationhintstring)
{
	player = self;
	self killstreaks::switch_to_last_non_killstreak_weapon();
	placeable = spawn("script_model", player.origin);
	placeable.cancelable = 1;
	placeable.held = 0;
	placeable.validmodel = validmodel;
	placeable.invalidmodel = invalidmodel;
	placeable.killstreakid = killstreakid;
	placeable.killstreakref = killstreakref;
	placeable.oncancel = oncancelcallback;
	placeable.onemp = onempcallback;
	placeable.onmove = onmovecallback;
	placeable.onplace = onplacecallback;
	placeable.onshutdown = onshutdowncallback;
	placeable.ondeath = ondeathcallback;
	placeable.owner = player;
	placeable.originalowner = player;
	placeable.ownerentnum = player.entnum;
	placeable.originalownerentnum = player.entnum;
	placeable.pickupstring = pickupstring;
	placeable.placedmodel = model;
	placeable.spawnsvehicle = spawnsvehicle;
	placeable.originalteam = player.team;
	placeable.timedout = 0;
	placeable.timeout = timeout;
	placeable.timeoutstarted = 0;
	placeable.angles = (0, player.angles[1], 0);
	placeable.placehintstring = placehintstring;
	placeable.invalidlocationhintstring = invalidlocationhintstring;
	if(!isdefined(placeable.placehintstring))
	{
		placeable.placehintstring = "";
	}
	if(!isdefined(placeable.invalidlocationhintstring))
	{
		placeable.invalidlocationhintstring = "";
	}
	placeable notsolid();
	if(isdefined(placeable.vehicle))
	{
		placeable.vehicle notsolid();
	}
	placeable.othermodel = spawn("script_model", player.origin);
	placeable.othermodel setmodel(placeable.placedmodel);
	placeable.othermodel setinvisibletoplayer(player);
	placeable.othermodel notsolid();
	placeable.othermodel clientfield::set("enemyvehicle", 1);
	placeable killstreaks::configure_team(killstreakref, killstreakid, player);
	if(isdefined(health) && health > 0)
	{
		placeable.health = health;
		placeable setcandamage(0);
		placeable thread killstreaks::monitordamage(killstreakref, health, &ondeath, 0, undefined, empdamage, &onemp, 1);
	}
	player thread carryplaceable(placeable);
	level thread cancelongameend(placeable);
	player thread shutdownoncancelevent(placeable);
	player thread cancelonplayerdisconnect(placeable);
	placeable thread watchownergameevents();
	return placeable;
}

/*
	Name: updateplacementmodels
	Namespace: placeables
	Checksum: 0x557A2488
	Offset: 0x820
	Size: 0x68
	Parameters: 3
	Flags: None
*/
function updateplacementmodels(model, validmodel, invalidmodel)
{
	placeable = self;
	placeable.placedmodel = model;
	placeable.validmodel = validmodel;
	placeable.invalidmodel = invalidmodel;
}

/*
	Name: carryplaceable
	Namespace: placeables
	Checksum: 0x9E0B9D2B
	Offset: 0x890
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function carryplaceable(placeable)
{
	player = self;
	placeable show();
	placeable notsolid();
	if(isdefined(placeable.vehicle))
	{
		placeable.vehicle notsolid();
	}
	if(isdefined(placeable.othermodel))
	{
		placeable thread util::ghost_wait_show_to_player(player, 0.05, "abort_ghost_wait_show");
		placeable.othermodel thread util::ghost_wait_show_to_others(player, 0.05, "abort_ghost_wait_show");
		placeable.othermodel notsolid();
	}
	placeable.held = 1;
	player.holding_placeable = placeable;
	player carryturret(placeable, vectorscale((1, 0, 0), 40), (0, 0, 0));
	player util::_disableweapon();
	player thread watchplacement(placeable);
}

/*
	Name: innoplacementtrigger
	Namespace: placeables
	Checksum: 0x3BE2826E
	Offset: 0xA30
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function innoplacementtrigger()
{
	placeable = self;
	if(isdefined(level.noturretplacementtriggers))
	{
		for(i = 0; i < level.noturretplacementtriggers.size; i++)
		{
			if(placeable istouching(level.noturretplacementtriggers[i]))
			{
				return true;
			}
		}
	}
	if(isdefined(level.fatal_triggers))
	{
		for(i = 0; i < level.fatal_triggers.size; i++)
		{
			if(placeable istouching(level.fatal_triggers[i]))
			{
				return true;
			}
		}
	}
	if(placeable oob::istouchinganyoobtrigger())
	{
		return true;
	}
	return false;
}

/*
	Name: watchplacement
	Namespace: placeables
	Checksum: 0x3FC29F68
	Offset: 0xB30
	Size: 0x738
	Parameters: 1
	Flags: Linked
*/
function watchplacement(placeable)
{
	player = self;
	player endon(#"disconnect");
	player endon(#"death");
	placeable endon(#"placed");
	placeable endon(#"cancelled");
	player thread watchcarrycancelevents(placeable);
	lastattempt = -1;
	placeable.canbeplaced = 0;
	waitingforattackbuttonrelease = 1;
	while(true)
	{
		placement = player canplayerplaceturret();
		placeable.origin = placement["origin"];
		placeable.angles = placement["angles"];
		placeable.canbeplaced = placement["result"] && !placeable innoplacementtrigger();
		if(player.laststand === 1)
		{
			placeable.canbeplaced = 0;
		}
		if(isdefined(placeable.othermodel))
		{
			placeable.othermodel.origin = placement["origin"];
			placeable.othermodel.angles = placement["angles"];
		}
		if(placeable.canbeplaced != lastattempt)
		{
			if(placeable.canbeplaced)
			{
				placeable setmodel(placeable.validmodel);
				player sethintstring(istring(placeable.placehintstring));
			}
			else
			{
				placeable setmodel(placeable.invalidmodel);
				player sethintstring(istring(placeable.invalidlocationhintstring));
			}
			lastattempt = placeable.canbeplaced;
		}
		while(waitingforattackbuttonrelease && !player attackbuttonpressed())
		{
			waitingforattackbuttonrelease = 0;
		}
		if(!waitingforattackbuttonrelease && placeable.canbeplaced && player attackbuttonpressed())
		{
			if(placement["result"])
			{
				placeable.origin = placement["origin"];
				placeable.angles = placement["angles"];
				player sethintstring("");
				player stopcarryturret(placeable);
				if(!player util::isweaponenabled())
				{
					player util::_enableweapon();
				}
				placeable.held = 0;
				player.holding_placeable = undefined;
				placeable.cancelable = 0;
				if(isdefined(placeable.health) && placeable.health)
				{
					placeable setcandamage(1);
					placeable solid();
				}
				if(isdefined(placeable.vehicle))
				{
					placeable.vehicle setcandamage(1);
					placeable.vehicle solid();
				}
				if(isdefined(placeable.placedmodel) && !placeable.spawnsvehicle)
				{
					placeable setmodel(placeable.placedmodel);
				}
				else
				{
					placeable notify(#"abort_ghost_wait_show");
					placeable.abort_ghost_wait_show_to_player = 1;
					placeable.abort_ghost_wait_show_to_others = 1;
					placeable ghost();
					if(isdefined(placeable.othermodel))
					{
						placeable.othermodel notify(#"abort_ghost_wait_show");
						placeable.othermodel.abort_ghost_wait_show_to_player = 1;
						placeable.othermodel.abort_ghost_wait_show_to_others = 1;
						placeable.othermodel ghost();
					}
				}
				if(isdefined(placeable.timeout))
				{
					if(!placeable.timeoutstarted)
					{
						placeable.timeoutstarted = 1;
						placeable thread killstreaks::waitfortimeout(placeable.killstreakref, placeable.timeout, &ontimeout, "death", "cancelled");
					}
					else if(placeable.timedout)
					{
						placeable thread killstreaks::waitfortimeout(placeable.killstreakref, 5000, &ontimeout, "cancelled");
					}
				}
				if(isdefined(placeable.onplace))
				{
					player [[placeable.onplace]](placeable);
					if(isdefined(placeable.onmove) && !placeable.timedout)
					{
						spawnmovetrigger(placeable, player);
					}
				}
				placeable notify(#"placed");
			}
		}
		if(placeable.cancelable && player actionslotfourbuttonpressed())
		{
			placeable notify(#"cancelled");
		}
		wait(0.05);
	}
}

/*
	Name: watchcarrycancelevents
	Namespace: placeables
	Checksum: 0xABEDF147
	Offset: 0x1270
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function watchcarrycancelevents(placeable)
{
	player = self;
	/#
		assert(isplayer(player));
	#/
	placeable endon(#"cancelled");
	placeable endon(#"placed");
	player util::waittill_any("death", "emp_jammed", "emp_grenaded", "disconnect", "joined_team");
	placeable notify(#"cancelled");
}

/*
	Name: ontimeout
	Namespace: placeables
	Checksum: 0x10FD1F65
	Offset: 0x1330
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function ontimeout()
{
	placeable = self;
	if(isdefined(placeable.held) && placeable.held)
	{
		placeable.timedout = 1;
		return;
	}
	placeable notify(#"delete_placeable_trigger");
	placeable thread killstreaks::waitfortimeout(placeable.killstreakref, 5000, &forceshutdown, "cancelled");
}

/*
	Name: ondeath
	Namespace: placeables
	Checksum: 0x6A028A6D
	Offset: 0x13D0
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function ondeath(attacker, weapon)
{
	placeable = self;
	if(isdefined(placeable.ondeath))
	{
		[[placeable.ondeath]](attacker, weapon);
	}
	placeable notify(#"cancelled");
}

/*
	Name: onemp
	Namespace: placeables
	Checksum: 0x38509692
	Offset: 0x1440
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function onemp(attacker)
{
	placeable = self;
	if(isdefined(placeable.onemp))
	{
		placeable [[placeable.onemp]](attacker);
	}
}

/*
	Name: cancelonplayerdisconnect
	Namespace: placeables
	Checksum: 0x3163D31B
	Offset: 0x1498
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function cancelonplayerdisconnect(placeable)
{
	placeable endon(#"hacked");
	player = self;
	/#
		assert(isplayer(player));
	#/
	placeable endon(#"cancelled");
	placeable endon(#"death");
	player util::waittill_any("disconnect", "joined_team");
	placeable notify(#"cancelled");
}

/*
	Name: cancelongameend
	Namespace: placeables
	Checksum: 0x756003F4
	Offset: 0x1548
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function cancelongameend(placeable)
{
	placeable endon(#"cancelled");
	placeable endon(#"death");
	level waittill(#"game_ended");
	placeable notify(#"cancelled");
}

/*
	Name: spawnmovetrigger
	Namespace: placeables
	Checksum: 0xB3238835
	Offset: 0x1590
	Size: 0x13C
	Parameters: 2
	Flags: Linked
*/
function spawnmovetrigger(placeable, player)
{
	pos = placeable.origin + vectorscale((0, 0, 1), 15);
	placeable.pickuptrigger = spawn("trigger_radius_use", pos);
	placeable.pickuptrigger setcursorhint("HINT_NOICON", placeable);
	placeable.pickuptrigger sethintstring(placeable.pickupstring);
	placeable.pickuptrigger setteamfortrigger(player.team);
	player clientclaimtrigger(placeable.pickuptrigger);
	placeable thread watchpickup(player);
	placeable.pickuptrigger thread watchmovetriggershutdown(placeable);
}

/*
	Name: watchmovetriggershutdown
	Namespace: placeables
	Checksum: 0x9FF025CA
	Offset: 0x16D8
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function watchmovetriggershutdown(placeable)
{
	trigger = self;
	placeable util::waittill_any("cancelled", "picked_up", "death", "delete_placeable_trigger", "hacker_delete_placeable_trigger");
	placeable.pickuptrigger delete();
}

/*
	Name: watchpickup
	Namespace: placeables
	Checksum: 0x70F36F9F
	Offset: 0x1760
	Size: 0x342
	Parameters: 1
	Flags: Linked
*/
function watchpickup(player)
{
	placeable = self;
	placeable endon(#"death");
	placeable endon(#"cancelled");
	/#
		assert(isdefined(placeable.pickuptrigger));
	#/
	trigger = placeable.pickuptrigger;
	while(true)
	{
		trigger waittill(#"trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		if(player isusingoffhand())
		{
			continue;
		}
		if(!player isonground())
		{
			continue;
		}
		if(isdefined(placeable.vehicle) && placeable.vehicle.control_initiated === 1)
		{
			continue;
		}
		if(isdefined(player.carryobject) && player.carryobject.disallowplaceablepickup === 1)
		{
			continue;
		}
		if(isdefined(trigger.triggerteam) && player.team != trigger.triggerteam)
		{
			continue;
		}
		if(isdefined(trigger.claimedby) && player != trigger.claimedby)
		{
			continue;
		}
		if(player usebuttonpressed() && !player.throwinggrenade && !player meleebuttonpressed() && !player attackbuttonpressed() && (!(isdefined(player.isplanting) && player.isplanting)) && (!(isdefined(player.isdefusing) && player.isdefusing)) && !player isremotecontrolling() && !isdefined(player.holding_placeable))
		{
			placeable notify(#"picked_up");
			placeable.held = 1;
			placeable setcandamage(0);
			/#
				assert(isdefined(placeable.onmove));
			#/
			player [[placeable.onmove]](placeable);
			player thread carryplaceable(placeable);
			return;
		}
	}
}

/*
	Name: forceshutdown
	Namespace: placeables
	Checksum: 0x5CCDB335
	Offset: 0x1AB0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function forceshutdown()
{
	placeable = self;
	placeable.cancelable = 0;
	placeable notify(#"cancelled");
}

/*
	Name: watchownergameevents
	Namespace: placeables
	Checksum: 0xE2ABB45E
	Offset: 0x1AF0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function watchownergameevents()
{
	self notify(#"watchownergameevents_singleton");
	self endon(#"watchownergameevents_singleton");
	placeable = self;
	placeable endon(#"cancelled");
	placeable.owner util::waittill_any("joined_team", "disconnect", "joined_spectators");
	if(isdefined(placeable))
	{
		placeable.abandoned = 1;
		placeable forceshutdown();
	}
}

/*
	Name: shutdownoncancelevent
	Namespace: placeables
	Checksum: 0x5A8C8713
	Offset: 0x1BA0
	Size: 0x264
	Parameters: 1
	Flags: Linked
*/
function shutdownoncancelevent(placeable)
{
	placeable endon(#"hacked");
	player = self;
	/#
		assert(isplayer(player));
	#/
	placeable util::waittill_any("cancelled", "death");
	if(isdefined(player) && isdefined(placeable) && placeable.held === 1)
	{
		player sethintstring("");
		player stopcarryturret(placeable);
		if(!player util::isweaponenabled())
		{
			player util::_enableweapon();
		}
	}
	if(isdefined(placeable))
	{
		if(placeable.cancelable)
		{
			if(isdefined(placeable.oncancel))
			{
				[[placeable.oncancel]](placeable);
			}
		}
		else if(isdefined(placeable.onshutdown))
		{
			[[placeable.onshutdown]](placeable);
		}
		if(isdefined(placeable))
		{
			if(isdefined(placeable.vehicle))
			{
				vehicle_to_kill = placeable.vehicle;
				vehicle_to_kill.selfdestruct = 1;
				vehicle_to_kill kill();
				placeable.vehicle = undefined;
				placeable.othermodel delete();
				placeable delete();
			}
			else
			{
				placeable.othermodel delete();
				placeable delete();
			}
		}
	}
}

