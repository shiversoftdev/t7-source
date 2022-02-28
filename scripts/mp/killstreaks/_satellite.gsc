// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;

#namespace satellite;

/*
	Name: init
	Namespace: satellite
	Checksum: 0x5038038D
	Offset: 0x660
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			level.activesatellites[team] = 0;
		}
	}
	else
	{
		level.activesatellites = [];
	}
	level.activeplayersatellites = [];
	if(tweakables::gettweakablevalue("killstreak", "allowradardirection"))
	{
		killstreaks::register("satellite", "satellite", "killstreak_satellite", "uav_used", &activatesatellite);
		killstreaks::register_strings("satellite", &"KILLSTREAK_EARNED_SATELLITE", &"KILLSTREAK_SATELLITE_NOT_AVAILABLE", &"KILLSTREAK_SATELLITE_INBOUND", undefined, &"KILLSTREAK_SATELLITE_HACKED");
		killstreaks::register_dialog("satellite", "mpl_killstreak_satellite", "satelliteDialogBundle", undefined, "friendlySatellite", "enemySatellite", "enemySatelliteMultiple", "friendlySatelliteHacked", "enemySatelliteHacked", "requestSatellite", "threatSatellite");
	}
	callback::on_connect(&onplayerconnect);
	callback::on_spawned(&onplayerspawned);
	level thread satellitetracker();
}

/*
	Name: onplayerconnect
	Namespace: satellite
	Checksum: 0x5CC4A00E
	Offset: 0x868
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self.entnum = self getentitynumber();
	if(!level.teambased)
	{
		level.activesatellites[self.entnum] = 0;
	}
	level.activeplayersatellites[self.entnum] = 0;
}

/*
	Name: onplayerspawned
	Namespace: satellite
	Checksum: 0x5207FBAE
	Offset: 0x8C8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function onplayerspawned(local_client_num)
{
	if(!level.teambased)
	{
		updateplayersatellitefordm(self);
	}
}

/*
	Name: activatesatellite
	Namespace: satellite
	Checksum: 0x65F060B6
	Offset: 0x900
	Size: 0x5D0
	Parameters: 0
	Flags: Linked
*/
function activatesatellite()
{
	if(self killstreakrules::iskillstreakallowed("satellite", self.team) == 0)
	{
		return false;
	}
	killstreak_id = self killstreakrules::killstreakstart("satellite", self.team);
	if(killstreak_id == -1)
	{
		return false;
	}
	minflyheight = int(airsupport::getminimumflyheight());
	zoffset = minflyheight + 5500;
	travelangle = randomfloatrange((isdefined(level.satellite_spawn_from_angle_min) ? level.satellite_spawn_from_angle_min : 90), (isdefined(level.satellite_spawn_from_angle_max) ? level.satellite_spawn_from_angle_max : 180));
	travelradius = airsupport::getmaxmapwidth() * 1.5;
	xoffset = sin(travelangle) * travelradius;
	yoffset = cos(travelangle) * travelradius;
	satellite = spawn("script_model", airsupport::getmapcenter() + (xoffset, yoffset, zoffset));
	satellite setmodel("veh_t7_drone_srv_blimp");
	satellite setscale(1);
	satellite.killstreak_id = killstreak_id;
	satellite.owner = self;
	satellite.ownerentnum = self getentitynumber();
	satellite.team = self.team;
	satellite setteam(self.team);
	satellite setowner(self);
	satellite killstreaks::configure_team("satellite", killstreak_id, self, undefined, undefined, &configureteampost);
	satellite killstreak_hacking::enable_hacking("satellite", &hackedprefunction, undefined);
	satellite.targetname = "satellite";
	satellite.maxhealth = 700;
	satellite.lowhealth = 700 * 0.5;
	satellite.health = 99999;
	satellite.leaving = 0;
	satellite setcandamage(1);
	satellite thread killstreaks::monitordamage("satellite", satellite.maxhealth, &destroysatellite, satellite.lowhealth, &onlowhealth, 0, undefined, 0);
	satellite thread killstreaks::waittillemp(&destroysatellitebyemp);
	satellite.killstreakdamagemodifier = &killstreakdamagemodifier;
	satellite.rocketdamage = (satellite.maxhealth / 3) + 1;
	/#
	#/
	satellite moveto(airsupport::getmapcenter() + (xoffset * -1, yoffset * -1, zoffset), 40000 * 0.001);
	target_set(satellite);
	satellite clientfield::set("enemyvehicle", 1);
	satellite thread killstreaks::waitfortimeout("satellite", 40000, &ontimeout, "death", "crashing");
	satellite thread heatseekingmissile::missiletarget_proximitydetonateincomingmissile("death", undefined, 1);
	satellite thread rotate(10);
	self killstreaks::play_killstreak_start_dialog("satellite", self.team, killstreak_id);
	satellite thread killstreaks::player_killstreak_threat_tracking("satellite");
	self addweaponstat(getweapon("satellite"), "used", 1);
	return true;
}

/*
	Name: hackedprefunction
	Namespace: satellite
	Checksum: 0xAE48F69
	Offset: 0xED8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function hackedprefunction(hacker)
{
	satellite = self;
	satellite resetactivesatellite();
}

/*
	Name: configureteampost
	Namespace: satellite
	Checksum: 0x2B51BF9B
	Offset: 0xF18
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function configureteampost(owner, ishacked)
{
	satellite = self;
	satellite thread teams::waituntilteamchangesingleton(owner, "Satellite_watch_team_change", &onteamchange, self.entnum, "delete", "death", "leaving");
	if(ishacked == 0)
	{
		satellite teams::hidetosameteam();
	}
	else
	{
		satellite setvisibletoall();
	}
	satellite addactivesatellite();
}

/*
	Name: rotate
	Namespace: satellite
	Checksum: 0x73D307AC
	Offset: 0xFE8
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function rotate(duration)
{
	self endon(#"death");
	while(true)
	{
		self rotateyaw(-360, duration);
		wait(duration);
	}
}

/*
	Name: onlowhealth
	Namespace: satellite
	Checksum: 0xC671D950
	Offset: 0x1038
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function onlowhealth(attacker, weapon)
{
}

/*
	Name: onteamchange
	Namespace: satellite
	Checksum: 0x48980DBE
	Offset: 0x1058
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function onteamchange(entnum, event)
{
	destroysatellite(undefined, undefined);
}

/*
	Name: ontimeout
	Namespace: satellite
	Checksum: 0xF4D283A7
	Offset: 0x1090
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function ontimeout()
{
	self killstreaks::play_pilot_dialog_on_owner("timeout", "satellite");
	self.leaving = 1;
	self removeactivesatellite();
	airsupport::leave(10);
	wait(10);
	if(target_istarget(self))
	{
		target_remove(self);
	}
	self delete();
}

/*
	Name: destroysatellitebyemp
	Namespace: satellite
	Checksum: 0xAF65671A
	Offset: 0x1148
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function destroysatellitebyemp(attacker, arg)
{
	destroysatellite(attacker, getweapon("emp"));
}

/*
	Name: destroysatellite
	Namespace: satellite
	Checksum: 0xD78F71EF
	Offset: 0x1190
	Size: 0x244
	Parameters: 2
	Flags: Linked
*/
function destroysatellite(attacker = undefined, weapon = undefined)
{
	attacker = self [[level.figure_out_attacker]](attacker);
	if(isdefined(attacker) && (!isdefined(self.owner) || self.owner util::isenemyplayer(attacker)))
	{
		challenges::destroyedaircraft(attacker, weapon, 0);
		scoreevents::processscoreevent("destroyed_satellite", attacker, self.owner, weapon);
		attacker challenges::addflyswatterstat(weapon, self);
		luinotifyevent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_SATELLITE", attacker.entnum);
		if(!self.leaving)
		{
			self killstreaks::play_destroyed_dialog_on_owner("satellite", self.killstreak_id);
		}
	}
	self notify(#"crashing");
	params = level.killstreakbundle["satellite"];
	if(isdefined(params.ksexplosionfx))
	{
		playfxontag(params.ksexplosionfx, self, "tag_origin");
	}
	self setmodel("tag_origin");
	if(target_istarget(self))
	{
		target_remove(self);
	}
	wait(0.5);
	if(!self.leaving)
	{
		self removeactivesatellite();
	}
	self delete();
}

/*
	Name: hassatellite
	Namespace: satellite
	Checksum: 0xC3AA1A61
	Offset: 0x13E0
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function hassatellite(team_or_entnum)
{
	return level.activesatellites[team_or_entnum] > 0;
}

/*
	Name: addactivesatellite
	Namespace: satellite
	Checksum: 0x9E878859
	Offset: 0x1408
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function addactivesatellite()
{
	if(level.teambased)
	{
		level.activesatellites[self.team]++;
	}
	else
	{
		level.activesatellites[self.ownerentnum]++;
	}
	level.activeplayersatellites[self.ownerentnum]++;
	level notify(#"satellite_update");
}

/*
	Name: removeactivesatellite
	Namespace: satellite
	Checksum: 0xDCC394B2
	Offset: 0x1470
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function removeactivesatellite()
{
	self resetactivesatellite();
	killstreakrules::killstreakstop("satellite", self.originalteam, self.killstreak_id);
}

/*
	Name: resetactivesatellite
	Namespace: satellite
	Checksum: 0xAD92D74
	Offset: 0x14C0
	Size: 0x16A
	Parameters: 0
	Flags: Linked
*/
function resetactivesatellite()
{
	if(level.teambased)
	{
		level.activesatellites[self.team]--;
		/#
			assert(level.activesatellites[self.team] >= 0);
		#/
		if(level.activesatellites[self.team] < 0)
		{
			level.activesatellites[self.team] = 0;
		}
	}
	else if(isdefined(self.ownerentnum))
	{
		level.activesatellites[self.ownerentnum]--;
		/#
			assert(level.activesatellites[self.ownerentnum] >= 0);
		#/
		if(level.activesatellites[self.ownerentnum] < 0)
		{
			level.activesatellites[self.ownerentnum] = 0;
		}
	}
	/#
		assert(isdefined(self.ownerentnum));
	#/
	level.activeplayersatellites[self.ownerentnum]--;
	/#
		assert(level.activeplayersatellites[self.ownerentnum] >= 0);
	#/
	level notify(#"satellite_update");
}

/*
	Name: satellitetracker
	Namespace: satellite
	Checksum: 0x18AD5962
	Offset: 0x1638
	Size: 0x18A
	Parameters: 0
	Flags: Linked
*/
function satellitetracker()
{
	level endon(#"game_ended");
	while(true)
	{
		level waittill(#"satellite_update");
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				activesatellites = level.activesatellites[team];
				activesatellitesanduavs = activesatellites + (isdefined(level.activeuavs) ? level.activeuavs[team] : 0);
				setteamsatellite(team, activesatellites > 0);
				util::set_team_radar(team, activesatellitesanduavs > 0);
			}
		}
		else
		{
			for(i = 0; i < level.players.size; i++)
			{
				updateplayersatellitefordm(level.players[i]);
			}
		}
	}
}

/*
	Name: updateplayersatellitefordm
	Namespace: satellite
	Checksum: 0xF45C8CEB
	Offset: 0x17D0
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function updateplayersatellitefordm(player)
{
	if(!isdefined(player.entnum))
	{
		player.entnum = player getentitynumber();
	}
	activesatellites = level.activesatellites[player.entnum];
	activesatellitesanduavs = activesatellites + (isdefined(level.activeuavs) ? level.activeuavs[player.entnum] : 0);
	player setclientuivisibilityflag("radar_client", activesatellitesanduavs > 0);
	player.hassatellite = activesatellites > 0;
}

/*
	Name: killstreakdamagemodifier
	Namespace: satellite
	Checksum: 0x7EBAF75D
	Offset: 0x18C0
	Size: 0xA0
	Parameters: 12
	Flags: Linked
*/
function killstreakdamagemodifier(damage, attacker, direction, point, smeansofdeath, tagname, modelname, partname, weapon, flags, inflictor, chargelevel)
{
	if(smeansofdeath == "MOD_PISTOL_BULLET" || smeansofdeath == "MOD_RIFLE_BULLET")
	{
		return 0;
	}
	if(smeansofdeath == "MOD_PROJECTILE_SPLASH")
	{
		return 0;
	}
	return damage;
}

