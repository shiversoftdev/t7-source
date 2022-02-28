// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;

#namespace uav;

/*
	Name: init
	Namespace: uav
	Checksum: 0x4E03FE8E
	Offset: 0x678
	Size: 0x264
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			level.activeuavs[team] = 0;
		}
	}
	else
	{
		level.activeuavs = [];
	}
	level.activeplayeruavs = [];
	level.spawneduavs = [];
	if(tweakables::gettweakablevalue("killstreak", "allowradar"))
	{
		killstreaks::register("uav", "uav", "killstreak_uav", "uav_used", &activateuav);
		killstreaks::register_strings("uav", &"KILLSTREAK_EARNED_RADAR", &"KILLSTREAK_RADAR_NOT_AVAILABLE", &"KILLSTREAK_RADAR_INBOUND", undefined, &"KILLSTREAK_RADAR_HACKED");
		killstreaks::register_dialog("uav", "mpl_killstreak_radar", "uavDialogBundle", "uavPilotDialogBundle", "friendlyUav", "enemyUav", "enemyUavMultiple", "friendlyUavHacked", "enemyUavHacked", "requestUav", "threatUav");
	}
	level thread uavtracker();
	callback::on_connect(&onplayerconnect);
	callback::on_spawned(&onplayerspawned);
	callback::on_joined_team(&onplayerjoinedteam);
	setmatchflag("radar_allies", 0);
	setmatchflag("radar_axis", 0);
}

/*
	Name: hackedprefunction
	Namespace: uav
	Checksum: 0x1A315810
	Offset: 0x8E8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function hackedprefunction(hacker)
{
	uav = self;
	uav resetactiveuav();
}

/*
	Name: configureteampost
	Namespace: uav
	Checksum: 0xD0896157
	Offset: 0x928
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function configureteampost(owner, ishacked)
{
	uav = self;
	uav thread teams::waituntilteamchangesingleton(owner, "UAV_watch_team_change", &onteamchange, owner.entnum, "delete", "death", "leaving");
	if(ishacked == 0)
	{
		uav teams::hidetosameteam();
	}
	else
	{
		uav setvisibletoall();
	}
	owner addactiveuav();
}

/*
	Name: activateuav
	Namespace: uav
	Checksum: 0xACF15C3D
	Offset: 0xA00
	Size: 0x650
	Parameters: 0
	Flags: Linked
*/
function activateuav()
{
	/#
		assert(isdefined(level.players));
	#/
	if(self killstreakrules::iskillstreakallowed("uav", self.team) == 0)
	{
		return false;
	}
	killstreak_id = self killstreakrules::killstreakstart("uav", self.team);
	if(killstreak_id == -1)
	{
		return false;
	}
	rotator = level.airsupport_rotator;
	attach_angle = -90;
	uav = spawn("script_model", rotator gettagorigin("tag_origin"));
	if(!isdefined(level.spawneduavs))
	{
		level.spawneduavs = [];
	}
	else if(!isarray(level.spawneduavs))
	{
		level.spawneduavs = array(level.spawneduavs);
	}
	level.spawneduavs[level.spawneduavs.size] = uav;
	uav setmodel("veh_t7_drone_uav_enemy_vista");
	uav.targetname = "uav";
	uav killstreaks::configure_team("uav", killstreak_id, self, undefined, undefined, &configureteampost);
	uav killstreak_hacking::enable_hacking("uav", &hackedprefunction, undefined);
	uav clientfield::set("enemyvehicle", 1);
	killstreak_detect::killstreaktargetset(uav);
	uav setdrawinfrared(1);
	uav.killstreak_id = killstreak_id;
	uav.leaving = 0;
	uav.health = 99999;
	uav.maxhealth = 700;
	uav.lowhealth = 700 * 0.5;
	uav setcandamage(1);
	uav thread killstreaks::monitordamage("uav", uav.maxhealth, &destroyuav, uav.lowhealth, &onlowhealth, 0, undefined, 1);
	uav thread heatseekingmissile::missiletarget_proximitydetonateincomingmissile("crashing", undefined, 1);
	uav.rocketdamage = uav.maxhealth + 1;
	minflyheight = int(airsupport::getminimumflyheight());
	zoffset = minflyheight + (isdefined(level.uav_z_offset) ? level.uav_z_offset : 2500);
	angle = randomint(360);
	loc_00000E20:
	radiusoffset = (isdefined(level.uav_rotation_radius) ? level.uav_rotation_radius : 4000) + randomint((isdefined(level.uav_rotation_random_offset) ? level.uav_rotation_random_offset : 1000));
	xoffset = cos(angle) * radiusoffset;
	yoffset = sin(angle) * radiusoffset;
	anglevector = vectornormalize((xoffset, yoffset, zoffset));
	anglevector = anglevector * zoffset;
	uav linkto(rotator, "tag_origin", anglevector, (0, angle + attach_angle, 0));
	self addweaponstat(getweapon("uav"), "used", 1);
	uav thread killstreaks::waitfortimeout("uav", 25000, &ontimeout, "delete", "death", "crashing");
	uav thread killstreaks::waitfortimecheck(25000 / 2, &ontimecheck, "delete", "death", "crashing");
	uav thread startuavfx();
	self killstreaks::play_killstreak_start_dialog("uav", self.team, killstreak_id);
	uav killstreaks::play_pilot_dialog_on_owner("arrive", "uav", killstreak_id);
	uav thread killstreaks::player_killstreak_threat_tracking("uav");
	return true;
}

/*
	Name: onlowhealth
	Namespace: uav
	Checksum: 0x1044BE01
	Offset: 0x1058
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function onlowhealth(attacker, weapon)
{
	self.is_damaged = 1;
	params = level.killstreakbundle["uav"];
	if(isdefined(params.fxlowhealth))
	{
		playfxontag(params.fxlowhealth, self, "tag_origin");
	}
}

/*
	Name: onteamchange
	Namespace: uav
	Checksum: 0x665B3F24
	Offset: 0x10E0
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function onteamchange(entnum, event)
{
	destroyuav(undefined, undefined);
}

/*
	Name: destroyuav
	Namespace: uav
	Checksum: 0xFAB4ABAA
	Offset: 0x1118
	Size: 0x26C
	Parameters: 2
	Flags: Linked
*/
function destroyuav(attacker, weapon)
{
	attacker = self [[level.figure_out_attacker]](attacker);
	if(isdefined(attacker) && (!isdefined(self.owner) || self.owner util::isenemyplayer(attacker)))
	{
		challenges::destroyedaircraft(attacker, weapon, 0);
		scoreevents::processscoreevent("destroyed_uav", attacker, self.owner, weapon);
		luinotifyevent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_UAV", attacker.entnum);
		attacker challenges::addflyswatterstat(weapon, self);
	}
	if(!self.leaving)
	{
		self removeactiveuav();
		self killstreaks::play_destroyed_dialog_on_owner("uav", self.killstreak_id);
	}
	self notify(#"crashing");
	self playsound("evt_helicopter_midair_exp");
	params = level.killstreakbundle["uav"];
	if(isdefined(params.ksexplosionfx))
	{
		playfxontag(params.ksexplosionfx, self, "tag_origin");
	}
	self stoploopsound();
	self setmodel("tag_origin");
	target_remove(self);
	self unlink();
	wait(0.5);
	arrayremovevalue(level.spawneduavs, self);
	self notify(#"delete");
	self delete();
}

/*
	Name: onplayerconnect
	Namespace: uav
	Checksum: 0x788F2114
	Offset: 0x1390
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self.entnum = self getentitynumber();
	if(!level.teambased)
	{
		level.activeuavs[self.entnum] = 0;
	}
	level.activeplayeruavs[self.entnum] = 0;
}

/*
	Name: onplayerspawned
	Namespace: uav
	Checksum: 0x18B45ED6
	Offset: 0x13F0
	Size: 0x3E
	Parameters: 0
	Flags: Linked
*/
function onplayerspawned()
{
	self endon(#"disconnect");
	if(level.teambased == 0 || level.multiteam == 1)
	{
		level notify(#"uav_update");
	}
}

/*
	Name: onplayerjoinedteam
	Namespace: uav
	Checksum: 0xBBB20CD2
	Offset: 0x1438
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function onplayerjoinedteam()
{
	hidealluavstosameteam();
}

/*
	Name: ontimeout
	Namespace: uav
	Checksum: 0x2EAF1CCD
	Offset: 0x1458
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function ontimeout()
{
	playafterburnerfx();
	if(isdefined(self.is_damaged) && self.is_damaged)
	{
		playfxontag("killstreaks/fx_uav_damage_trail", self, "tag_body");
	}
	self killstreaks::play_pilot_dialog_on_owner("timeout", "uav");
	self.leaving = 1;
	self removeactiveuav();
	airsupport::leave(10);
	wait(10);
	target_remove(self);
	arrayremovevalue(level.spawneduavs, self);
	self delete();
}

/*
	Name: ontimecheck
	Namespace: uav
	Checksum: 0x3C48E2AE
	Offset: 0x1558
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function ontimecheck()
{
	self killstreaks::play_pilot_dialog_on_owner("timecheck", "uav", self.killstreak_id);
}

/*
	Name: startuavfx
	Namespace: uav
	Checksum: 0xE0319EA2
	Offset: 0x1598
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function startuavfx()
{
	self endon(#"death");
	wait(0.1);
	if(isdefined(self))
	{
		playfxontag("killstreaks/fx_uav_lights", self, "tag_origin");
		playfxontag("killstreaks/fx_uav_bunner", self, "tag_origin");
		self playloopsound("veh_uav_engine_loop", 1);
	}
}

/*
	Name: playafterburnerfx
	Namespace: uav
	Checksum: 0x86EE0BD0
	Offset: 0x1628
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function playafterburnerfx()
{
	self endon(#"death");
	wait(0.1);
	if(isdefined(self))
	{
		playfxontag("killstreaks/fx_uav_bunner", self, "tag_origin");
		self stoploopsound();
		team = util::getotherteam(self.team);
		self playsoundtoteam("veh_kls_uav_afterburner", team);
	}
}

/*
	Name: hasuav
	Namespace: uav
	Checksum: 0x1D78BD95
	Offset: 0x16D8
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function hasuav(team_or_entnum)
{
	return level.activeuavs[team_or_entnum] > 0;
}

/*
	Name: addactiveuav
	Namespace: uav
	Checksum: 0xE2765B2A
	Offset: 0x1700
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function addactiveuav()
{
	if(level.teambased)
	{
		/#
			assert(isdefined(self.team));
		#/
		level.activeuavs[self.team]++;
	}
	else
	{
		/#
			assert(isdefined(self.entnum));
		#/
		if(!isdefined(self.entnum))
		{
			self.entnum = self getentitynumber();
		}
		level.activeuavs[self.entnum]++;
	}
	level.activeplayeruavs[self.entnum]++;
	level notify(#"uav_update");
}

/*
	Name: removeactiveuav
	Namespace: uav
	Checksum: 0xCAE8EFF9
	Offset: 0x17C8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function removeactiveuav()
{
	uav = self;
	uav resetactiveuav();
	uav killstreakrules::killstreakstop("uav", self.originalteam, self.killstreak_id);
}

/*
	Name: resetactiveuav
	Namespace: uav
	Checksum: 0x27AC3FA9
	Offset: 0x1830
	Size: 0x1EA
	Parameters: 0
	Flags: Linked
*/
function resetactiveuav()
{
	if(level.teambased)
	{
		level.activeuavs[self.team]--;
		/#
			assert(level.activeuavs[self.team] >= 0);
		#/
		if(level.activeuavs[self.team] < 0)
		{
			level.activeuavs[self.team] = 0;
		}
	}
	else if(isdefined(self.owner))
	{
		/#
			assert(isdefined(self.owner.entnum));
		#/
		if(!isdefined(self.owner.entnum))
		{
			self.owner.entnum = self.owner getentitynumber();
		}
		level.activeuavs[self.owner.entnum]--;
		/#
			assert(level.activeuavs[self.owner.entnum] >= 0);
		#/
		if(level.activeuavs[self.owner.entnum] < 0)
		{
			level.activeuavs[self.owner.entnum] = 0;
		}
	}
	if(isdefined(self.owner))
	{
		level.activeplayeruavs[self.owner.entnum]--;
		/#
			assert(level.activeplayeruavs[self.owner.entnum] >= 0);
		#/
	}
	level notify(#"uav_update");
}

/*
	Name: uavtracker
	Namespace: uav
	Checksum: 0x8B0A7716
	Offset: 0x1A28
	Size: 0x2B6
	Parameters: 0
	Flags: Linked
*/
function uavtracker()
{
	level endon(#"game_ended");
	while(true)
	{
		level waittill(#"uav_update");
		if(level.teambased)
		{
			foreach(team in level.teams)
			{
				activeuavs = level.activeuavs[team];
				activeuavsandsatellites = activeuavs + (isdefined(level.activesatellites) ? level.activesatellites[team] : 0);
				setteamspyplane(team, int(min(activeuavs, 2)));
				util::set_team_radar(team, activeuavsandsatellites > 0);
			}
		}
		else
		{
			for(i = 0; i < level.players.size; i++)
			{
				player = level.players[i];
				/#
					assert(isdefined(player.entnum));
				#/
				if(!isdefined(player.entnum))
				{
					player.entnum = player getentitynumber();
				}
				activeuavs = level.activeuavs[player.entnum];
				activeuavsandsatellites = activeuavs + (isdefined(level.activesatellites) ? level.activesatellites[player.entnum] : 0);
				player setclientuivisibilityflag("radar_client", activeuavsandsatellites > 0);
				player.hasspyplane = int(min(activeuavs, 2));
			}
		}
	}
}

/*
	Name: hidealluavstosameteam
	Namespace: uav
	Checksum: 0xBAE2FF1A
	Offset: 0x1CE8
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function hidealluavstosameteam()
{
	foreach(uav in level.spawneduavs)
	{
		if(isdefined(uav))
		{
			uav teams::hidetosameteam();
		}
	}
}

