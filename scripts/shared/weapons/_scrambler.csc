// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace scrambler;

/*
	Name: init_shared
	Namespace: scrambler
	Checksum: 0x94FEA33
	Offset: 0x238
	Size: 0x16C
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level._effect["scrambler_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["scrambler_friendly_light"] = "_t6/misc/fx_equip_light_green";
	level.scramblerhandle = 1;
	level.scramblervoouterradius = 1440000;
	level.scramblerinnerradius = 250000;
	level.scramblesound = "mpl_scrambler_static";
	level.globalscramblesound = "mpl_cuav_static";
	level.scramblesoundalert = "mpl_scrambler_alert";
	level.scramblesoundping = "mpl_scrambler_ping";
	level.scramblesoundburst = "mpl_scrambler_burst";
	clientfield::register("missile", "scrambler", 1, 1, "int", &spawnedscrambler, 0, 0);
	level.scramblers = [];
	level.playerpersistent = [];
	localclientnum = 0;
	util::waitforclient(localclientnum);
	level thread scramblerupdate(localclientnum);
	level thread checkforplayerswitch();
}

/*
	Name: spawnedscrambler
	Namespace: scrambler
	Checksum: 0x42665048
	Offset: 0x3B0
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function spawnedscrambler(localclientnum, set)
{
	if(!set)
	{
		return;
	}
	if(localclientnum != 0)
	{
		return;
	}
	self spawned(localclientnum, set, 1);
}

/*
	Name: spawnedglobalscramber
	Namespace: scrambler
	Checksum: 0x9C94BEB0
	Offset: 0x408
	Size: 0x74
	Parameters: 7
	Flags: None
*/
function spawnedglobalscramber(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	if(localclientnum != 0)
	{
		return;
	}
	self spawned(localclientnum, newval, 0);
}

/*
	Name: spawned
	Namespace: scrambler
	Checksum: 0xBA4BA597
	Offset: 0x488
	Size: 0x234
	Parameters: 3
	Flags: None
*/
function spawned(localclientnum, set, islocalized)
{
	if(!set)
	{
		return;
	}
	if(localclientnum != 0)
	{
		return;
	}
	scramblerhandle = level.scramblerhandle;
	level.scramblerhandle++;
	size = level.scramblers.size;
	level.scramblers[size] = spawnstruct();
	level.scramblers[size].scramblerhandle = scramblerhandle;
	level.scramblers[size].cent = self;
	level.scramblers[size].team = self.team;
	level.scramblers[size].islocalized = islocalized;
	level.scramblers[size].sndent = spawn(0, self.origin, "script_origin");
	level.scramblers[size].sndid = -1;
	level.scramblers[size].sndpingent = spawn(0, self.origin, "script_origin");
	level.scramblers[size].sndpingid = -1;
	players = level.localplayers;
	owner = self getowner(localclientnum);
	util::local_players_entity_thread(self, &spawnedperclient, islocalized, scramblerhandle);
	level thread cleanupscramblerondelete(self, scramblerhandle, islocalized, localclientnum);
}

/*
	Name: spawnedperclient
	Namespace: scrambler
	Checksum: 0xF713B19F
	Offset: 0x6C8
	Size: 0x354
	Parameters: 3
	Flags: None
*/
function spawnedperclient(localclientnum, islocalized, scramblerhandle)
{
	player = getlocalplayer(localclientnum);
	isenemy = self isenemyscrambler(localclientnum);
	owner = self getowner(localclientnum);
	scramblerindex = undefined;
	for(i = 0; i < level.scramblers.size; i++)
	{
		if(level.scramblers[i].scramblerhandle == scramblerhandle)
		{
			scramblerindex = i;
			break;
		}
	}
	if(!isdefined(scramblerindex))
	{
		return;
	}
	if(!isenemy)
	{
		if(islocalized)
		{
			if(owner == player && !isspectating(localclientnum, 0))
			{
				player addfriendlyscrambler(self.origin[0], self.origin[1], scramblerhandle);
			}
			if(isdefined(level.scramblers[scramblerindex].sndent))
			{
				level.scramblers[scramblerindex].sndid = level.scramblers[scramblerindex].sndent playloopsound(level.scramblesoundalert);
				playsound(0, level.scramblesoundburst, level.scramblers[scramblerindex].sndent.origin);
			}
			if(isdefined(level.scramblers[scramblerindex].sndpingent))
			{
				level.scramblers[scramblerindex].sndpingid = level.scramblers[scramblerindex].sndpingent playloopsound(level.scramblesoundping);
			}
		}
	}
	else
	{
		scramblesound = level.scramblesound;
		if(islocalized == 0)
		{
			scramblesound = level.globalscramblesound;
		}
		if(isdefined(level.scramblers[scramblerindex].sndent))
		{
			level.scramblers[scramblerindex].sndid = level.scramblers[scramblerindex].sndent playloopsound(scramblesound);
		}
	}
	self thread fx::blinky_light(localclientnum, "tag_light", level._effect["scrambler_friendly_light"], level._effect["scrambler_enemy_light"]);
}

/*
	Name: scramblerupdate
	Namespace: scrambler
	Checksum: 0xF5BA1137
	Offset: 0xA28
	Size: 0x8B0
	Parameters: 1
	Flags: None
*/
function scramblerupdate(localclientnum)
{
	nearestenemy = level.scramblervoouterradius;
	nearestfriendly = level.scramblervoouterradius;
	for(;;)
	{
		players = level.localplayers;
		for(localclientnum = 0; localclientnum < players.size; localclientnum++)
		{
			player = players[localclientnum];
			if(!isdefined(player.team))
			{
				continue;
			}
			if(!isdefined(level.playerpersistent[localclientnum]))
			{
				level.playerpersistent[localclientnum] = spawnstruct();
				level.playerpersistent[localclientnum].previousteam = player.team;
				player removeallfriendlyscramblers();
			}
			if(level.playerpersistent[localclientnum].previousteam != player.team)
			{
				teamchanged = 1;
				level.playerpersistent[localclientnum].previousteam = player.team;
			}
			else
			{
				teamchanged = 0;
			}
			enemyscrambleramount = 0;
			friendlyscrambleramount = 0;
			nearestenemy = level.scramblervoouterradius;
			nearestfriendly = level.scramblervoouterradius;
			isglobalscrambler = 0;
			disttoscrambler = level.scramblervoouterradius;
			nearestenemyscramblercent = undefined;
			for(i = 0; i < level.scramblers.size; i++)
			{
				if(!isdefined(level.scramblers[i].cent))
				{
					continue;
				}
				if(isdefined(level.scramblers[i].cent.stunned) && level.scramblers[i].cent.stunned)
				{
					level.scramblers[i].cent.reenable = 1;
					player removefriendlyscrambler(level.scramblers[i].scramblerhandle);
					continue;
				}
				else if(isdefined(level.scramblers[i].cent.reenable) && level.scramblers[i].cent.reenable)
				{
					teamchanged = 1;
					level.scramblers[i].cent.reenable = 0;
				}
				if(level.scramblers[i].islocalized)
				{
					disttoscrambler = distancesquared(player.origin, level.scramblers[i].cent.origin);
				}
				if(!level.scramblers[i].islocalized && level.scramblers[i].cent isenemyscrambler(localclientnum))
				{
					isglobalscrambler = 1;
				}
				isenemy = level.scramblers[i].cent isenemyscrambler(localclientnum);
				if(level.scramblers[i].team != level.scramblers[i].cent.team)
				{
					scramblerteamchanged = 1;
					level.scramblers[i].team = level.scramblers[i].cent.team;
				}
				else
				{
					scramblerteamchanged = 0;
				}
				if(teamchanged || scramblerteamchanged)
				{
					level.scramblers[i] restartsound(isenemy);
				}
				if(isenemy)
				{
					if(nearestenemy > disttoscrambler)
					{
						nearestenemyscramblercent = level.scramblers[i].cent;
						nearestenemy = disttoscrambler;
					}
					if(level.scramblers[i].islocalized && (teamchanged || scramblerteamchanged))
					{
						player removefriendlyscrambler(level.scramblers[i].scramblerhandle);
					}
					continue;
				}
				if(level.scramblers[i].islocalized)
				{
					if(nearestfriendly > disttoscrambler)
					{
						nearestfriendly = disttoscrambler;
					}
					owner = level.scramblers[i].cent getowner(localclientnum);
					if(owner == player && !isspectating(localclientnum, 0))
					{
						if(teamchanged || scramblerteamchanged)
						{
							player addfriendlyscrambler(level.scramblers[i].cent.origin[0], level.scramblers[i].cent.origin[1], level.scramblers[i].scramblerhandle);
						}
					}
				}
			}
			if(nearestenemy < level.scramblervoouterradius)
			{
				enemyvoscrambleramount = 1 - (nearestenemy - level.scramblerinnerradius) / (level.scramblervoouterradius - level.scramblerinnerradius);
			}
			else
			{
				enemyvoscrambleramount = 0;
			}
			if(nearestfriendly < level.scramblerinnerradius)
			{
				friendlyscrambleramount = 1;
			}
			else if(nearestfriendly < level.scramblervoouterradius)
			{
				friendlyscrambleramount = 1 - (nearestfriendly - level.scramblerinnerradius) / (level.scramblervoouterradius - level.scramblerinnerradius);
			}
			player setfriendlyscrambleramount(friendlyscrambleramount);
			if(level.scramblers.size > 0 && isdefined(nearestenemyscramblercent))
			{
				player setnearestenemyscrambler(nearestenemyscramblercent);
			}
			else
			{
				player clearnearestenemyscrambler();
			}
			if(isglobalscrambler && player hasperk(localclientnum, "specialty_immunecounteruav") == 0)
			{
				player setenemyglobalscrambler(1);
			}
			else
			{
				player setenemyglobalscrambler(0);
			}
			if(enemyvoscrambleramount > 1)
			{
				enemyvoscrambleramount = 1;
			}
			if(getdvarfloat("snd_futz") != enemyvoscrambleramount)
			{
				setdvar("snd_futz", enemyvoscrambleramount);
			}
		}
		wait(0.25);
		util::waitforallclients();
	}
}

/*
	Name: cleanupscramblerondelete
	Namespace: scrambler
	Checksum: 0x151400E3
	Offset: 0x12E0
	Size: 0x2F6
	Parameters: 4
	Flags: None
*/
function cleanupscramblerondelete(scramblerent, scramblerhandle, islocalized, localclientnum)
{
	scramblerent waittill(#"entityshutdown");
	players = level.localplayers;
	for(j = 0; j < level.scramblers.size; j++)
	{
		size = level.scramblers.size;
		if(scramblerhandle == level.scramblers[j].scramblerhandle)
		{
			playsound(0, level.scramblesoundburst, level.scramblers[j].sndent.origin);
			level.scramblers[j].sndent delete();
			level.scramblers[j].sndent = self.scramblers[size - 1].sndent;
			level.scramblers[j].sndpingent delete();
			level.scramblers[j].sndpingent = self.scramblers[size - 1].sndpingent;
			level.scramblers[j].cent = level.scramblers[size - 1].cent;
			level.scramblers[j].scramblerhandle = level.scramblers[size - 1].scramblerhandle;
			level.scramblers[j].team = level.scramblers[size - 1].team;
			level.scramblers[j].islocalized = level.scramblers[size - 1].islocalized;
			level.scramblers[size - 1] = undefined;
			break;
		}
	}
	if(islocalized)
	{
		for(i = 0; i < players.size; i++)
		{
			players[i] removefriendlyscrambler(scramblerhandle);
		}
	}
}

/*
	Name: isenemyscrambler
	Namespace: scrambler
	Checksum: 0x636F277E
	Offset: 0x15E0
	Size: 0x5E
	Parameters: 1
	Flags: None
*/
function isenemyscrambler(localclientnum)
{
	/#
		if(getdvarint("", 0))
		{
			return 1;
		}
	#/
	enemy = !util::friend_not_foe(localclientnum);
	return enemy;
}

/*
	Name: checkforplayerswitch
	Namespace: scrambler
	Checksum: 0xB0DF6B07
	Offset: 0x1648
	Size: 0x154
	Parameters: 0
	Flags: None
*/
function checkforplayerswitch()
{
	while(true)
	{
		level waittill(#"player_switch");
		waittillframeend();
		players = level.localplayers;
		for(localclientnum = 0; localclientnum < players.size; localclientnum++)
		{
			for(j = 0; j < level.scramblers.size; j++)
			{
				ent = level.scramblers[j].cent;
				ent thread fx::stop_blinky_light(localclientnum);
				ent thread fx::blinky_light(localclientnum, "tag_light", level._effect["scrambler_friendly_light"], level._effect["scrambler_enemy_light"]);
				isenemy = ent isenemyscrambler(localclientnum);
				level.scramblers[j] restartsound(isenemy);
			}
		}
	}
}

/*
	Name: restartsound
	Namespace: scrambler
	Checksum: 0xA7C804A0
	Offset: 0x17A8
	Size: 0xEC
	Parameters: 1
	Flags: None
*/
function restartsound(isenemy)
{
	if(self.sndid != -1)
	{
		self.sndent stopallloopsounds(0.1);
		self.sndid = -1;
	}
	if(!isenemy)
	{
		if(self.islocalized)
		{
			self.sndid = self.sndent playloopsound(level.scramblesoundalert);
		}
	}
	else
	{
		islocalized = self.islocalized;
		scramblesound = level.scramblesound;
		if(islocalized == 0)
		{
			scramblesound = level.globalscramblesound;
		}
		self.sndid = self.sndent playloopsound(scramblesound);
	}
}

