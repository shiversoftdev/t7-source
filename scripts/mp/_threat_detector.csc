// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_decoy;
#using scripts\shared\weapons\_weaponobjects;

#namespace threat_detector;

/*
	Name: __init__sytem__
	Namespace: threat_detector
	Checksum: 0x3F481A07
	Offset: 0x1F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("threat_detector", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: threat_detector
	Checksum: 0x557BB153
	Offset: 0x238
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.sensorhandle = 1;
	level.sensors = [];
	clientfield::register("missile", "threat_detector", 1, 1, "int", &spawnedthreatdetector, 0, 0);
}

/*
	Name: spawnedthreatdetector
	Namespace: threat_detector
	Checksum: 0x40232C5
	Offset: 0x2A8
	Size: 0x1CC
	Parameters: 7
	Flags: Linked
*/
function spawnedthreatdetector(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval != 1)
	{
		return;
	}
	if(getlocalplayer(localclientnum) != self.owner)
	{
		return;
	}
	sensorindex = level.sensors.size;
	level.sensorhandle++;
	level.sensors[sensorindex] = spawnstruct();
	level.sensors[sensorindex].handle = level.sensorhandle;
	level.sensors[sensorindex].cent = self;
	level.sensors[sensorindex].team = self.team;
	level.sensors[sensorindex].owner = self getowner(localclientnum);
	level.sensors[sensorindex].owner addsensorgrenadearea(self.origin, level.sensorhandle);
	self.owner thread sensorgrenadethink(self, level.sensorhandle, localclientnum);
	self.owner thread clearthreatdetectorondelete(self, level.sensorhandle, localclientnum);
}

/*
	Name: sensorgrenadethink
	Namespace: threat_detector
	Checksum: 0xB00A786C
	Offset: 0x480
	Size: 0x21C
	Parameters: 3
	Flags: Linked
*/
function sensorgrenadethink(sensorent, sensorhandle, localclientnum)
{
	sensorent endon(#"entityshutdown");
	if(isdefined(sensorent.owner) == 0)
	{
		return;
	}
	while(true)
	{
		players = getplayers(localclientnum);
		foreach(player in players)
		{
			if(self util::isenemyplayer(player))
			{
				if(player hasperk(localclientnum, "specialty_nomotionsensor") || player hasperk(localclientnum, "specialty_sengrenjammer"))
				{
					player duplicate_render::set_player_threat_detected(localclientnum, 0);
					continue;
				}
				threatdetectorradius = getdvarfloat("cg_threatDetectorRadius", 0);
				threatdetectorradiussqrd = threatdetectorradius * threatdetectorradius;
				if(distancesquared(player.origin, sensorent.origin) < threatdetectorradiussqrd)
				{
					player duplicate_render::set_player_threat_detected(localclientnum, 1);
					continue;
				}
				player duplicate_render::set_player_threat_detected(localclientnum, 0);
			}
		}
		wait(1);
	}
}

/*
	Name: clearthreatdetectorondelete
	Namespace: threat_detector
	Checksum: 0x88204C4F
	Offset: 0x6A8
	Size: 0x1AA
	Parameters: 3
	Flags: Linked
*/
function clearthreatdetectorondelete(sensorent, sensorhandle, localclientnum)
{
	sensorent waittill(#"entityshutdown");
	entindex = 0;
	for(i = 0; i < level.sensors.size; i++)
	{
		size = level.sensors.size;
		if(sensorhandle == level.sensors[i].handle)
		{
			level.sensors[i].owner removesensorgrenadearea(sensorhandle);
			entindex = 0;
			break;
		}
	}
	players = getplayers(localclientnum);
	foreach(player in players)
	{
		if(self util::isenemyplayer(player))
		{
			player duplicate_render::set_player_threat_detected(localclientnum, 0);
		}
	}
}

