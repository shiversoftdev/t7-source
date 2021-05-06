// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace acousticsensor;

/*
	Name: init_shared
	Namespace: acousticsensor
	Checksum: 0xF92C74CF
	Offset: 0x1A8
	Size: 0xB4
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["acousticsensor_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["acousticsensor_friendly_light"] = "_t6/misc/fx_equip_light_green";
	if(!isdefined(level.acousticsensors))
	{
		level.acousticsensors = [];
	}
	if(!isdefined(level.acousticsensorhandle))
	{
		level.acousticsensorhandle = 0;
	}
	callback::on_localclient_connect(&on_player_connect);
	callback::add_weapon_type("acoustic_sensor", &spawned);
}

/*
	Name: on_player_connect
	Namespace: acousticsensor
	Checksum: 0xADAC86C9
	Offset: 0x268
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function on_player_connect(localclientnum)
{
	setlocalradarenabled(localclientnum, 0);
	if(localclientnum == 0)
	{
		level thread updateacousticsensors();
	}
}

/*
	Name: addacousticsensor
	Namespace: acousticsensor
	Checksum: 0x4BC47850
	Offset: 0x2B8
	Size: 0x9E
	Parameters: 3
	Flags: None
*/
function addacousticsensor(handle, sensorent, owner)
{
	acousticsensor = spawnstruct();
	acousticsensor.handle = handle;
	acousticsensor.sensorent = sensorent;
	acousticsensor.owner = owner;
	size = level.acousticsensors.size;
	level.acousticsensors[size] = acousticsensor;
}

/*
	Name: removeacousticsensor
	Namespace: acousticsensor
	Checksum: 0x1538F359
	Offset: 0x360
	Size: 0x114
	Parameters: 1
	Flags: None
*/
function removeacousticsensor(acousticsensorhandle)
{
	for(i = 0; i < level.acousticsensors.size; i++)
	{
		last = level.acousticsensors.size - 1;
		if(level.acousticsensors[i].handle == acousticsensorhandle)
		{
			level.acousticsensors[i].handle = level.acousticsensors[last].handle;
			level.acousticsensors[i].sensorent = level.acousticsensors[last].sensorent;
			level.acousticsensors[i].owner = level.acousticsensors[last].owner;
			level.acousticsensors[last] = undefined;
			return;
		}
	}
}

/*
	Name: spawned
	Namespace: acousticsensor
	Checksum: 0x39BF2601
	Offset: 0x480
	Size: 0xA4
	Parameters: 1
	Flags: None
*/
function spawned(localclientnum)
{
	handle = level.acousticsensorhandle;
	level.acousticsensorhandle++;
	self thread watchshutdown(handle);
	owner = self getowner(localclientnum);
	addacousticsensor(handle, self, owner);
	util::local_players_entity_thread(self, &spawnedperclient);
}

/*
	Name: spawnedperclient
	Namespace: acousticsensor
	Checksum: 0x121B875F
	Offset: 0x530
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function spawnedperclient(localclientnum)
{
	self endon(#"entityshutdown");
	self thread fx::blinky_light(localclientnum, "tag_light", level._effect["acousticsensor_friendly_light"], level._effect["acousticsensor_enemy_light"]);
}

/*
	Name: watchshutdown
	Namespace: acousticsensor
	Checksum: 0x5B6AD378
	Offset: 0x590
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function watchshutdown(handle)
{
	self waittill(#"entityshutdown");
	removeacousticsensor(handle);
}

/*
	Name: updateacousticsensors
	Namespace: acousticsensor
	Checksum: 0xF132EB
	Offset: 0x5C8
	Size: 0x234
	Parameters: 0
	Flags: None
*/
function updateacousticsensors()
{
	self endon(#"entityshutdown");
	localradarenabled = [];
	previousacousticsensorcount = -1;
	util::waitforclient(0);
	while(true)
	{
		localplayers = level.localplayers;
		if(previousacousticsensorcount != 0 || level.acousticsensors.size != 0)
		{
			for(i = 0; i < localplayers.size; i++)
			{
				localradarenabled[i] = 0;
			}
			for(i = 0; i < level.acousticsensors.size; i++)
			{
				if(isdefined(level.acousticsensors[i].sensorent.stunned) && level.acousticsensors[i].sensorent.stunned)
				{
					continue;
				}
				for(j = 0; j < localplayers.size; j++)
				{
					if(localplayers[j] == level.acousticsensors[i].sensorent getowner(j))
					{
						localradarenabled[j] = 1;
						setlocalradarposition(j, level.acousticsensors[i].sensorent.origin);
					}
				}
			}
			for(i = 0; i < localplayers.size; i++)
			{
				setlocalradarenabled(i, localradarenabled[i]);
			}
		}
		previousacousticsensorcount = level.acousticsensors.size;
		wait(0.1);
	}
}

