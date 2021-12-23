// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_perplayer;
#using scripts\shared\util_shared;

#namespace _teargrenades;

/*
	Name: main
	Namespace: _teargrenades
	Checksum: 0xFB5F7A04
	Offset: 0x138
	Size: 0xA4
	Parameters: 0
	Flags: None
*/
function main()
{
	level.tearradius = 170;
	level.tearheight = 128;
	level.teargasfillduration = 7;
	level.teargasduration = 23;
	level.tearsufferingduration = 3;
	level.teargrenadetimer = 4;
	fgmonitor = perplayer::init("tear_grenade_monitor", &startmonitoringtearusage, &stopmonitoringtearusage);
	perplayer::enable(fgmonitor);
}

/*
	Name: startmonitoringtearusage
	Namespace: _teargrenades
	Checksum: 0x4DBF47A4
	Offset: 0x1E8
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function startmonitoringtearusage()
{
	self thread monitortearusage();
}

/*
	Name: stopmonitoringtearusage
	Namespace: _teargrenades
	Checksum: 0x96CC1FBA
	Offset: 0x210
	Size: 0x1A
	Parameters: 1
	Flags: None
*/
function stopmonitoringtearusage(disconnected)
{
	self notify(#"stop_monitoring_tear_usage");
}

/*
	Name: monitortearusage
	Namespace: _teargrenades
	Checksum: 0x5A33845E
	Offset: 0x238
	Size: 0x274
	Parameters: 0
	Flags: None
*/
function monitortearusage()
{
	self endon(#"stop_monitoring_tear_usage");
	wait(0.05);
	weapon = getweapon("tear_grenade");
	if(!self hasweapon(weapon))
	{
		return;
	}
	prevammo = self getammocount(weapon);
	while(true)
	{
		ammo = self getammocount(weapon);
		if(ammo < prevammo)
		{
			num = prevammo - ammo;
			/#
			#/
			for(i = 0; i < num; i++)
			{
				grenades = getentarray("grenade", "classname");
				bestdist = undefined;
				bestg = undefined;
				for(g = 0; g < grenades.size; g++)
				{
					if(!isdefined(grenades[g].teargrenade))
					{
						dist = distance(grenades[g].origin, self.origin + vectorscale((0, 0, 1), 48));
						if(!isdefined(bestdist) || dist < bestdist)
						{
							bestdist = dist;
							bestg = g;
						}
					}
				}
				if(isdefined(bestdist))
				{
					grenades[bestg].teargrenade = 1;
					grenades[bestg] thread teargrenade_think(self.team);
				}
			}
		}
		prevammo = ammo;
		wait(0.05);
	}
}

/*
	Name: teargrenade_think
	Namespace: _teargrenades
	Checksum: 0x711DA42B
	Offset: 0x4B8
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function teargrenade_think(team)
{
	wait(level.teargrenadetimer);
	ent = spawnstruct();
	ent thread tear(self.origin);
}

/*
	Name: tear
	Namespace: _teargrenades
	Checksum: 0xA14BC6F7
	Offset: 0x510
	Size: 0x228
	Parameters: 1
	Flags: None
*/
function tear(pos)
{
	trig = spawn("trigger_radius", pos, 0, level.tearradius, level.tearheight);
	starttime = gettime();
	self thread teartimer();
	self endon(#"tear_timeout");
	while(true)
	{
		trig waittill(#"trigger", player);
		if(player.sessionstate != "playing")
		{
			continue;
		}
		time = (gettime() - starttime) / 1000;
		currad = level.tearradius;
		curheight = level.tearheight;
		if(time < level.teargasfillduration)
		{
			currad = currad * (time / level.teargasfillduration);
			curheight = curheight * (time / level.teargasfillduration);
		}
		offset = (player.origin + vectorscale((0, 0, 1), 32)) - pos;
		offset2d = (offset[0], offset[1], 0);
		if(lengthsquared(offset2d) > (currad * currad))
		{
			continue;
		}
		if((player.origin[2] - pos[2]) > curheight)
		{
			continue;
		}
		player.teargasstarttime = gettime();
		if(!isdefined(player.teargassuffering))
		{
			player thread teargassuffering();
		}
	}
}

/*
	Name: teartimer
	Namespace: _teargrenades
	Checksum: 0x50A39CB8
	Offset: 0x740
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function teartimer()
{
	wait(level.teargasduration);
	self notify(#"tear_timeout");
}

/*
	Name: teargassuffering
	Namespace: _teargrenades
	Checksum: 0x83E855BB
	Offset: 0x768
	Size: 0xD6
	Parameters: 0
	Flags: None
*/
function teargassuffering()
{
	self endon(#"death");
	self endon(#"disconnect");
	self.teargassuffering = 1;
	if(self util::mayapplyscreeneffect())
	{
		self shellshock("teargas", 60);
	}
	while(true)
	{
		if((gettime() - self.teargasstarttime) > (level.tearsufferingduration * 1000))
		{
			break;
		}
		wait(1);
	}
	self shellshock("teargas", 1);
	if(self util::mayapplyscreeneffect())
	{
		self.teargassuffering = undefined;
	}
}

/*
	Name: drawcylinder
	Namespace: _teargrenades
	Checksum: 0xE1881F9A
	Offset: 0x848
	Size: 0x2EC
	Parameters: 3
	Flags: None
*/
function drawcylinder(pos, rad, height)
{
	/#
		time = 0;
		while(true)
		{
			currad = rad;
			curheight = height;
			if(time < level.teargasfillduration)
			{
				currad = currad * (time / level.teargasfillduration);
				curheight = curheight * (time / level.teargasfillduration);
			}
			for(r = 0; r < 20; r++)
			{
				theta = (r / 20) * 360;
				theta2 = ((r + 1) / 20) * 360;
				line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0));
				line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight));
				line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight));
			}
			time = time + 0.05;
			if(time > level.teargasduration)
			{
				break;
			}
			wait(0.05);
		}
	#/
}

