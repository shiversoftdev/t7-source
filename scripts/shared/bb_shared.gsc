// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace bb;

/*
	Name: init_shared
	Namespace: bb
	Checksum: 0x3AAE8D24
	Offset: 0x218
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function init_shared()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: bb
	Checksum: 0x1292C834
	Offset: 0x248
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function init()
{
	callback::on_connect(&player_init);
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: player_init
	Namespace: bb
	Checksum: 0xEAEEDA8
	Offset: 0x298
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function player_init()
{
	self thread on_player_death();
}

/*
	Name: on_player_spawned
	Namespace: bb
	Checksum: 0xA46F1E92
	Offset: 0x2C0
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	self._bbdata = [];
	self._bbdata["score"] = 0;
	self._bbdata["momentum"] = 0;
	self._bbdata["spawntime"] = gettime();
	self._bbdata["shots"] = 0;
	self._bbdata["hits"] = 0;
}

/*
	Name: on_player_disconnect
	Namespace: bb
	Checksum: 0xEE53C396
	Offset: 0x348
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function on_player_disconnect()
{
	for(;;)
	{
		self waittill(#"disconnect");
		self commit_spawn_data();
		break;
	}
}

/*
	Name: on_player_death
	Namespace: bb
	Checksum: 0xBDE88803
	Offset: 0x380
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function on_player_death()
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"death");
		self commit_spawn_data();
	}
}

/*
	Name: commit_spawn_data
	Namespace: bb
	Checksum: 0xBA180F58
	Offset: 0x3C0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function commit_spawn_data()
{
	/#
		/#
			assert(isdefined(self._bbdata));
		#/
	#/
	if(!isdefined(self._bbdata))
	{
		return;
	}
	bbprint("mpplayerlives", "gametime %d spawnid %d lifescore %d lifemomentum %d lifetime %d name %s", gettime(), getplayerspawnid(self), self._bbdata["score"], self._bbdata["momentum"], gettime() - self._bbdata["spawntime"], self.name);
}

/*
	Name: commit_weapon_data
	Namespace: bb
	Checksum: 0x8C564503
	Offset: 0x478
	Size: 0x146
	Parameters: 3
	Flags: Linked
*/
function commit_weapon_data(spawnid, currentweapon, time0)
{
	/#
		/#
			assert(isdefined(self._bbdata));
		#/
	#/
	if(!isdefined(self._bbdata))
	{
		return;
	}
	time1 = gettime();
	blackboxeventname = "mpweapons";
	if(sessionmodeiscampaigngame())
	{
		blackboxeventname = "cpweapons";
	}
	else if(sessionmodeiszombiesgame())
	{
		blackboxeventname = "zmweapons";
	}
	bbprint(blackboxeventname, "spawnid %d name %s duration %d shots %d hits %d", spawnid, currentweapon.name, time1 - time0, self._bbdata["shots"], self._bbdata["hits"]);
	self._bbdata["shots"] = 0;
	self._bbdata["hits"] = 0;
}

/*
	Name: add_to_stat
	Namespace: bb
	Checksum: 0x8E22CB3C
	Offset: 0x5C8
	Size: 0x56
	Parameters: 2
	Flags: Linked
*/
function add_to_stat(statname, delta)
{
	if(isdefined(self._bbdata) && isdefined(self._bbdata[statname]))
	{
		self._bbdata[statname] = self._bbdata[statname] + delta;
	}
}

/*
	Name: recordbbdataforplayer
	Namespace: bb
	Checksum: 0xBB0627D7
	Offset: 0x628
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function recordbbdataforplayer(breadcrumb_table)
{
	if(isdefined(level.gametype) && level.gametype === "doa")
	{
		return;
	}
	playerlifeidx = self getmatchrecordlifeindex();
	if(playerlifeidx == -1)
	{
		return;
	}
	movementtype = "";
	stance = "";
	bbprint(breadcrumb_table, "gametime %d lifeIndex %d posx %d posy %d posz %d yaw %d pitch %d movetype %s stance %s", gettime(), playerlifeidx, self.origin, self.angles[0], self.angles[1], movementtype, stance);
}

/*
	Name: recordblackboxbreadcrumbdata
	Namespace: bb
	Checksum: 0x3C081C84
	Offset: 0x708
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function recordblackboxbreadcrumbdata(breadcrumb_table)
{
	level endon(#"game_ended");
	if(!sessionmodeisonlinegame() || (isdefined(level.gametype) && level.gametype === "doa"))
	{
		return;
	}
	while(true)
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			if(isalive(player))
			{
				player recordbbdataforplayer(breadcrumb_table);
			}
		}
		wait(2);
	}
}

