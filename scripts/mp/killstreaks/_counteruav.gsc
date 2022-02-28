// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_satellite;
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

#namespace counteruav;

/*
	Name: init
	Namespace: counteruav
	Checksum: 0x3C69EC29
	Offset: 0x708
	Size: 0x324
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.activecounteruavs = [];
	level.counter_uav_positions = generaterandompoints(20);
	level.counter_uav_position_index = [];
	level.counter_uav_offsets = buildoffsetlist((0, 0, 0), 3, 450, 450);
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			level.activecounteruavs[team] = 0;
			level.counter_uav_position_index[team] = 0;
			level thread movementmanagerthink(team);
		}
	}
	else
	{
		level.activecounteruavs = [];
	}
	level.activeplayercounteruavs = [];
	level.counter_uav_entities = [];
	if(tweakables::gettweakablevalue("killstreak", "allowcounteruav"))
	{
		killstreaks::register("counteruav", "counteruav", "killstreak_counteruav", "counteruav_used", &activatecounteruav);
		killstreaks::register_strings("counteruav", &"KILLSTREAK_EARNED_COUNTERUAV", &"KILLSTREAK_COUNTERUAV_NOT_AVAILABLE", &"KILLSTREAK_COUNTERUAV_INBOUND", undefined, &"KILLSTREAK_COUNTERUAV_HACKED");
		killstreaks::register_dialog("counteruav", "mpl_killstreak_radar", "counterUavDialogBundle", "counterUavPilotDialogBundle", "friendlyCounterUav", "enemyCounterUav", "enemyCounterUavMultiple", "friendlyCounterUavHacked", "enemyCounterUavHacked", "requestCounterUav", "threatCounterUav");
	}
	clientfield::register("toplayer", "counteruav", 1, 1, "int");
	level thread watchcounteruavs();
	callback::on_connect(&onplayerconnect);
	callback::on_spawned(&onplayerspawned);
	callback::on_joined_team(&onplayerjoinedteam);
	/#
		if(getdvarint(""))
		{
			level thread waitanddebugdrawoffsetlist();
		}
	#/
}

/*
	Name: onplayerconnect
	Namespace: counteruav
	Checksum: 0x52E15150
	Offset: 0xA38
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function onplayerconnect()
{
	self.entnum = self getentitynumber();
	if(!level.teambased)
	{
		level.activecounteruavs[self.entnum] = 0;
		level.counter_uav_position_index[self.entnum] = 0;
		self thread movementmanagerthink(self.entnum);
	}
	level.activeplayercounteruavs[self.entnum] = 0;
}

/*
	Name: onplayerspawned
	Namespace: counteruav
	Checksum: 0x1DBB2559
	Offset: 0xAD0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function onplayerspawned()
{
	if(self enemycounteruavactive())
	{
		self clientfield::set_to_player("counteruav", 1);
	}
	else
	{
		self clientfield::set_to_player("counteruav", 0);
	}
}

/*
	Name: generaterandompoints
	Namespace: counteruav
	Checksum: 0xF3DC2FB0
	Offset: 0xB38
	Size: 0x138
	Parameters: 1
	Flags: Linked
*/
function generaterandompoints(count)
{
	points = [];
	for(i = 0; i < count; i++)
	{
		point = airsupport::getrandommappoint((isdefined(level.cuav_map_x_offset) ? level.cuav_map_x_offset : 0), (isdefined(level.cuav_map_y_offset) ? level.cuav_map_y_offset : 0), (isdefined(level.cuav_map_x_percentage) ? level.cuav_map_x_percentage : 0.5), (isdefined(level.cuav_map_y_percentage) ? level.cuav_map_y_percentage : 0.5));
		minflyheight = airsupport::getminimumflyheight();
		point = point + (0, 0, minflyheight + (isdefined(level.counter_uav_position_z_offset) ? level.counter_uav_position_z_offset : 1000));
		points[i] = point;
	}
	return points;
}

/*
	Name: movementmanagerthink
	Namespace: counteruav
	Checksum: 0xF0443955
	Offset: 0xC78
	Size: 0x126
	Parameters: 1
	Flags: Linked
*/
function movementmanagerthink(teamorentnum)
{
	while(true)
	{
		level waittill(#"counter_uav_updated");
		activecount = 0;
		while(level.activecounteruavs[teamorentnum] > 0)
		{
			if(activecount == 0)
			{
				activecount = level.activecounteruavs[teamorentnum];
			}
			currentindex = level.counter_uav_position_index[teamorentnum];
			newindex = currentindex;
			while(newindex == currentindex)
			{
				newindex = randomintrange(0, 20);
			}
			destination = level.counter_uav_positions[newindex];
			level.counter_uav_position_index[teamorentnum] = newindex;
			level notify("counter_uav_move_" + teamorentnum);
			wait(5 + randomintrange(5, 10));
		}
	}
}

/*
	Name: getcurrentposition
	Namespace: counteruav
	Checksum: 0x7F3B312C
	Offset: 0xDA8
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function getcurrentposition(teamorentnum)
{
	baseposition = level.counter_uav_positions[level.counter_uav_position_index[teamorentnum]];
	offset = level.counter_uav_offsets[self.cuav_offset_index];
	return baseposition + offset;
}

/*
	Name: assignfirstavailableoffsetindex
	Namespace: counteruav
	Checksum: 0x8C347702
	Offset: 0xE08
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function assignfirstavailableoffsetindex()
{
	self.cuav_offset_index = getfirstavailableoffsetindex();
	maintaincouteruaventities();
}

/*
	Name: getfirstavailableoffsetindex
	Namespace: counteruav
	Checksum: 0x590E2428
	Offset: 0xE40
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function getfirstavailableoffsetindex()
{
	available_offsets = [];
	for(i = 0; i < level.counter_uav_offsets.size; i++)
	{
		available_offsets[i] = 1;
	}
	foreach(cuav in level.counter_uav_entities)
	{
		if(isdefined(cuav))
		{
			available_offsets[cuav.cuav_offset_index] = 0;
		}
	}
	for(i = 0; i < available_offsets.size; i++)
	{
		if(available_offsets[i])
		{
			return i;
		}
	}
	/#
		util::warning("");
	#/
	return 0;
}

/*
	Name: maintaincouteruaventities
	Namespace: counteruav
	Checksum: 0x7BA60E77
	Offset: 0xF80
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function maintaincouteruaventities()
{
	for(i = level.counter_uav_entities.size; i >= 0; i--)
	{
		if(!isdefined(level.counter_uav_entities[i]))
		{
			arrayremoveindex(level.counter_uav_entities, i);
		}
	}
}

/*
	Name: waitanddebugdrawoffsetlist
	Namespace: counteruav
	Checksum: 0xDCAE43EA
	Offset: 0xFE8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function waitanddebugdrawoffsetlist()
{
	/#
		level endon(#"game_ended");
		wait(10);
		debugdrawoffsetlist();
	#/
}

/*
	Name: debugdrawoffsetlist
	Namespace: counteruav
	Checksum: 0xFCA1B646
	Offset: 0x1020
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function debugdrawoffsetlist()
{
	/#
		baseposition = level.counter_uav_positions[0];
		foreach(offset in level.counter_uav_offsets)
		{
			util::debug_sphere(baseposition + offset, 24, (0.95, 0.05, 0.05), 0.75, 9999999);
		}
	#/
}

/*
	Name: buildoffsetlist
	Namespace: counteruav
	Checksum: 0xE657DAD2
	Offset: 0x1108
	Size: 0x15E
	Parameters: 4
	Flags: Linked
*/
function buildoffsetlist(startoffset, depth, offset_x, offset_y)
{
	offsets = [];
	for(col = 0; col < depth; col++)
	{
		itemcount = math::pow(2, col);
		startingindex = itemcount - 1;
		for(i = 0; i < itemcount; i++)
		{
			x = offset_x * col;
			y = 0;
			if(itemcount > 1)
			{
				y = i * offset_y;
				total_y = offset_y * startingindex;
				y = y - (total_y / 2);
			}
			offsets[startingindex + i] = startoffset + (x, y, 0);
		}
	}
	return offsets;
}

/*
	Name: activatecounteruav
	Namespace: counteruav
	Checksum: 0xF1A25301
	Offset: 0x1270
	Size: 0x338
	Parameters: 0
	Flags: Linked
*/
function activatecounteruav()
{
	if(self killstreakrules::iskillstreakallowed("counteruav", self.team) == 0)
	{
		return false;
	}
	killstreak_id = self killstreakrules::killstreakstart("counteruav", self.team);
	if(killstreak_id == -1)
	{
		return false;
	}
	counteruav = spawncounteruav(self, killstreak_id);
	if(!isdefined(counteruav))
	{
		return false;
	}
	counteruav setscale(1);
	counteruav clientfield::set("enemyvehicle", 1);
	counteruav.killstreak_id = killstreak_id;
	counteruav thread killstreaks::waittillemp(&destroycounteruavbyemp);
	counteruav thread killstreaks::waitfortimeout("counteruav", 30000, &ontimeout, "delete", "death", "crashing");
	counteruav thread killstreaks::waitfortimecheck(30000 / 2, &ontimecheck, "delete", "death", "crashing");
	counteruav thread util::waittillendonthreaded("death", &destroycounteruav, "delete", "leaving");
	counteruav setcandamage(1);
	counteruav thread killstreaks::monitordamage("counteruav", 700, &destroycounteruav, 700 * 0.5, &onlowhealth, 0, undefined, 1);
	counteruav playloopsound("veh_uav_engine_loop", 1);
	counteruav thread listenformove();
	self killstreaks::play_killstreak_start_dialog("counteruav", self.team, killstreak_id);
	counteruav killstreaks::play_pilot_dialog_on_owner("arrive", "counteruav", killstreak_id);
	counteruav thread killstreaks::player_killstreak_threat_tracking("counteruav");
	self addweaponstat(getweapon("counteruav"), "used", 1);
	return true;
}

/*
	Name: hackedprefunction
	Namespace: counteruav
	Checksum: 0x7F46FD29
	Offset: 0x15B0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function hackedprefunction(hacker)
{
	cuav = self;
	cuav resetactivecounteruav();
}

/*
	Name: spawncounteruav
	Namespace: counteruav
	Checksum: 0x3EBA090C
	Offset: 0x15F0
	Size: 0x226
	Parameters: 2
	Flags: Linked
*/
function spawncounteruav(owner, killstreak_id)
{
	minflyheight = airsupport::getminimumflyheight();
	cuav = spawnvehicle("veh_counteruav_mp", airsupport::getmapcenter() + (0, 0, minflyheight + (isdefined(level.counter_uav_position_z_offset) ? level.counter_uav_position_z_offset : 1000)), (0, 0, 0), "counteruav");
	cuav assignfirstavailableoffsetindex();
	cuav killstreaks::configure_team("counteruav", killstreak_id, owner, undefined, undefined, &configureteampost);
	cuav killstreak_hacking::enable_hacking("counteruav", &hackedprefunction, undefined);
	cuav.targetname = "counteruav";
	killstreak_detect::killstreaktargetset(cuav);
	cuav thread heatseekingmissile::missiletarget_proximitydetonateincomingmissile("crashing", undefined, 1);
	cuav.maxhealth = 700;
	cuav.health = 99999;
	cuav.rocketdamage = 700 + 1;
	cuav setdrawinfrared(1);
	if(!isdefined(level.counter_uav_entities))
	{
		level.counter_uav_entities = [];
	}
	else if(!isarray(level.counter_uav_entities))
	{
		level.counter_uav_entities = array(level.counter_uav_entities);
	}
	level.counter_uav_entities[level.counter_uav_entities.size] = cuav;
	return cuav;
}

/*
	Name: configureteampost
	Namespace: counteruav
	Checksum: 0x806159CE
	Offset: 0x1820
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function configureteampost(owner, ishacked)
{
	cuav = self;
	if(ishacked == 0)
	{
		cuav teams::hidetosameteam();
	}
	else
	{
		cuav setvisibletoall();
	}
	cuav thread teams::waituntilteamchangesingleton(owner, "CUAV_watch_team_change", &onteamchange, self.entnum, "death", "leaving", "crashing");
	cuav addactivecounteruav();
}

/*
	Name: listenformove
	Namespace: counteruav
	Checksum: 0xFED30F34
	Offset: 0x18F0
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function listenformove()
{
	self endon(#"death");
	self endon(#"leaving");
	while(true)
	{
		self thread counteruavmove();
		level util::waittill_any("counter_uav_move_" + self.team, "counter_uav_move_" + self.ownerentnum);
	}
}

/*
	Name: counteruavmove
	Namespace: counteruav
	Checksum: 0x72292CB4
	Offset: 0x1968
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function counteruavmove()
{
	self endon(#"death");
	self endon(#"leaving");
	level endon("counter_uav_move_" + self.team);
	destination = (0, 0, 0);
	if(level.teambased)
	{
		destination = self getcurrentposition(self.team);
	}
	else
	{
		destination = self getcurrentposition(self.ownerentnum);
	}
	lookangles = vectortoangles(destination - self.origin);
	rotationaccelerationduration = 0.5 * 0.2;
	rotationdecelerationduration = 0.5 * 0.2;
	travelaccelerationduration = 5 * 0.2;
	traveldecelerationduration = 5 * 0.2;
	self setvehgoalpos(destination, 1, 0);
}

/*
	Name: playfx
	Namespace: counteruav
	Checksum: 0x268CD2F
	Offset: 0x1AD0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function playfx(name)
{
	self endon(#"death");
	wait(0.1);
	if(isdefined(self))
	{
		playfxontag(name, self, "tag_origin");
	}
}

/*
	Name: onlowhealth
	Namespace: counteruav
	Checksum: 0xF966FCFB
	Offset: 0x1B28
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function onlowhealth(attacker, weapon)
{
	self.is_damaged = 1;
	params = level.killstreakbundle["counteruav"];
	if(isdefined(params.fxlowhealth))
	{
		playfxontag(params.fxlowhealth, self, "tag_origin");
	}
}

/*
	Name: onteamchange
	Namespace: counteruav
	Checksum: 0xBBA4B266
	Offset: 0x1BB0
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function onteamchange(entnum, event)
{
	destroycounteruav(undefined, undefined);
}

/*
	Name: onplayerjoinedteam
	Namespace: counteruav
	Checksum: 0x44BF349A
	Offset: 0x1BE8
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function onplayerjoinedteam()
{
	hideallcounteruavstosameteam();
}

/*
	Name: ontimeout
	Namespace: counteruav
	Checksum: 0xDF4299A6
	Offset: 0x1C08
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function ontimeout()
{
	self.leaving = 1;
	self killstreaks::play_pilot_dialog_on_owner("timeout", "counteruav");
	self airsupport::leave(5);
	wait(5);
	self removeactivecounteruav();
	target_remove(self);
	self delete();
}

/*
	Name: ontimecheck
	Namespace: counteruav
	Checksum: 0xDE08B955
	Offset: 0x1CA8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function ontimecheck()
{
	self killstreaks::play_pilot_dialog_on_owner("timecheck", "counteruav", self.killstreak_id);
}

/*
	Name: destroycounteruavbyemp
	Namespace: counteruav
	Checksum: 0x19DEA600
	Offset: 0x1CE8
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function destroycounteruavbyemp(attacker, arg)
{
	destroycounteruav(attacker, getweapon("emp"));
}

/*
	Name: destroycounteruav
	Namespace: counteruav
	Checksum: 0x34F0B16B
	Offset: 0x1D30
	Size: 0x1B4
	Parameters: 2
	Flags: Linked
*/
function destroycounteruav(attacker, weapon)
{
	if(self.leaving !== 1)
	{
		self killstreaks::play_destroyed_dialog_on_owner("counteruav", self.killstreak_id);
	}
	attacker = self [[level.figure_out_attacker]](attacker);
	if(isdefined(attacker) && (!isdefined(self.owner) || self.owner util::isenemyplayer(attacker)))
	{
		challenges::destroyedaircraft(attacker, weapon, 0);
		scoreevents::processscoreevent("destroyed_counter_uav", attacker, self.owner, weapon);
		luinotifyevent(&"player_callout", 2, &"KILLSTREAK_DESTROYED_COUNTERUAV", attacker.entnum);
		attacker challenges::addflyswatterstat(weapon, self);
	}
	self playsound("evt_helicopter_midair_exp");
	self removeactivecounteruav();
	if(target_istarget(self))
	{
		target_remove(self);
	}
	self thread deletecounteruav();
}

/*
	Name: deletecounteruav
	Namespace: counteruav
	Checksum: 0xDD6EEDC9
	Offset: 0x1EF0
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function deletecounteruav()
{
	self notify(#"crashing");
	params = level.killstreakbundle["counteruav"];
	if(isdefined(params.ksexplosionfx) && isdefined(self))
	{
		self thread playfx(params.ksexplosionfx);
	}
	wait(0.1);
	if(isdefined(self))
	{
		self setmodel("tag_origin");
	}
	wait(0.2);
	if(isdefined(self))
	{
		self notify(#"delete");
		self delete();
	}
}

/*
	Name: enemycounteruavactive
	Namespace: counteruav
	Checksum: 0xCF83226B
	Offset: 0x1FC8
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function enemycounteruavactive()
{
	if(level.teambased)
	{
		foreach(team in level.teams)
		{
			if(team == self.team)
			{
				continue;
			}
			if(teamhasactivecounteruav(team))
			{
				return true;
			}
		}
	}
	else
	{
		enemies = self teams::getenemyplayers();
		foreach(player in enemies)
		{
			if(player hasactivecounteruav())
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: hasactivecounteruav
	Namespace: counteruav
	Checksum: 0xE184D1D
	Offset: 0x2138
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function hasactivecounteruav()
{
	return level.activecounteruavs[self.entnum] > 0;
}

/*
	Name: teamhasactivecounteruav
	Namespace: counteruav
	Checksum: 0xE14D8282
	Offset: 0x2158
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function teamhasactivecounteruav(team)
{
	return level.activecounteruavs[team] > 0;
}

/*
	Name: hasindexactivecounteruav
	Namespace: counteruav
	Checksum: 0x4A93DF1E
	Offset: 0x2180
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function hasindexactivecounteruav(team_or_entnum)
{
	return level.activecounteruavs[team_or_entnum] > 0;
}

/*
	Name: addactivecounteruav
	Namespace: counteruav
	Checksum: 0x6FFE0B39
	Offset: 0x21A8
	Size: 0x1BA
	Parameters: 0
	Flags: Linked
*/
function addactivecounteruav()
{
	if(level.teambased)
	{
		level.activecounteruavs[self.team]++;
		foreach(team in level.teams)
		{
			if(team == self.team)
			{
				continue;
			}
			if(satellite::hassatellite(team))
			{
				self.owner challenges::blockedsatellite();
			}
		}
	}
	else
	{
		level.activecounteruavs[self.ownerentnum]++;
		keys = getarraykeys(level.activecounteruavs);
		for(i = 0; i < keys.size; i++)
		{
			if(keys[i] == self.ownerentnum)
			{
				continue;
			}
			if(satellite::hassatellite(keys[i]))
			{
				self.owner challenges::blockedsatellite();
				break;
			}
		}
	}
	level.activeplayercounteruavs[self.ownerentnum]++;
	level notify(#"counter_uav_updated");
}

/*
	Name: removeactivecounteruav
	Namespace: counteruav
	Checksum: 0x12DF9B87
	Offset: 0x2370
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function removeactivecounteruav()
{
	cuav = self;
	cuav resetactivecounteruav();
	cuav killstreakrules::killstreakstop("counteruav", self.originalteam, self.killstreak_id);
}

/*
	Name: resetactivecounteruav
	Namespace: counteruav
	Checksum: 0x6EF9CC09
	Offset: 0x23D8
	Size: 0x16A
	Parameters: 0
	Flags: Linked
*/
function resetactivecounteruav()
{
	if(level.teambased)
	{
		level.activecounteruavs[self.team]--;
		/#
			assert(level.activecounteruavs[self.team] >= 0);
		#/
		if(level.activecounteruavs[self.team] < 0)
		{
			level.activecounteruavs[self.team] = 0;
		}
	}
	else if(isdefined(self.owner))
	{
		/#
			assert(isdefined(self.ownerentnum));
		#/
		if(!isdefined(self.ownerentnum))
		{
			self.ownerentnum = self.owner getentitynumber();
		}
		level.activecounteruavs[self.ownerentnum]--;
		/#
			assert(level.activecounteruavs[self.ownerentnum] >= 0);
		#/
		if(level.activecounteruavs[self.ownerentnum] < 0)
		{
			level.activecounteruavs[self.ownerentnum] = 0;
		}
	}
	level.activeplayercounteruavs[self.ownerentnum]--;
	level notify(#"counter_uav_updated");
}

/*
	Name: watchcounteruavs
	Namespace: counteruav
	Checksum: 0xA82D4F7D
	Offset: 0x2550
	Size: 0xE6
	Parameters: 0
	Flags: Linked
*/
function watchcounteruavs()
{
	while(true)
	{
		level waittill(#"counter_uav_updated");
		foreach(player in level.players)
		{
			if(player enemycounteruavactive())
			{
				player clientfield::set_to_player("counteruav", 1);
				continue;
			}
			player clientfield::set_to_player("counteruav", 0);
		}
	}
}

/*
	Name: hideallcounteruavstosameteam
	Namespace: counteruav
	Checksum: 0x71A2C240
	Offset: 0x2640
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function hideallcounteruavstosameteam()
{
	foreach(counteruav in level.counter_uav_entities)
	{
		if(isdefined(counteruav))
		{
			counteruav teams::hidetosameteam();
		}
	}
}

