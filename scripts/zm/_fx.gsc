// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\exploder_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\sound_shared;
#using scripts\zm\_util;

#namespace fx;

/*
	Name: print_org
	Namespace: fx
	Checksum: 0x692DA508
	Offset: 0x110
	Size: 0x184
	Parameters: 4
	Flags: None
*/
function print_org(fxcommand, fxid, fxpos, waittime)
{
	/#
		if(getdvarstring("") == "")
		{
			println("");
			println(((((("" + fxpos[0]) + "") + fxpos[1]) + "") + fxpos[2]) + "");
			println("");
			println("");
			println(("" + fxcommand) + "");
			println(("" + fxid) + "");
			println(("" + waittime) + "");
			println("");
		}
	#/
}

/*
	Name: gunfireloopfx
	Namespace: fx
	Checksum: 0x78A02089
	Offset: 0x2A0
	Size: 0x74
	Parameters: 8
	Flags: None
*/
function gunfireloopfx(fxid, fxpos, shotsmin, shotsmax, shotdelaymin, shotdelaymax, betweensetsmin, betweensetsmax)
{
	thread gunfireloopfxthread(fxid, fxpos, shotsmin, shotsmax, shotdelaymin, shotdelaymax, betweensetsmin, betweensetsmax);
}

/*
	Name: gunfireloopfxthread
	Namespace: fx
	Checksum: 0x57640D33
	Offset: 0x320
	Size: 0x232
	Parameters: 8
	Flags: None
*/
function gunfireloopfxthread(fxid, fxpos, shotsmin, shotsmax, shotdelaymin, shotdelaymax, betweensetsmin, betweensetsmax)
{
	level endon(#"hash_ce9de5d2");
	wait(0.05);
	if(betweensetsmax < betweensetsmin)
	{
		temp = betweensetsmax;
		betweensetsmax = betweensetsmin;
		betweensetsmin = temp;
	}
	betweensetsbase = betweensetsmin;
	betweensetsrange = betweensetsmax - betweensetsmin;
	if(shotdelaymax < shotdelaymin)
	{
		temp = shotdelaymax;
		shotdelaymax = shotdelaymin;
		shotdelaymin = temp;
	}
	shotdelaybase = shotdelaymin;
	shotdelayrange = shotdelaymax - shotdelaymin;
	if(shotsmax < shotsmin)
	{
		temp = shotsmax;
		shotsmax = shotsmin;
		shotsmin = temp;
	}
	shotsbase = shotsmin;
	shotsrange = shotsmax - shotsmin;
	fxent = spawnfx(level._effect[fxid], fxpos);
	for(;;)
	{
		shotnum = shotsbase + randomint(shotsrange);
		for(i = 0; i < shotnum; i++)
		{
			triggerfx(fxent);
			wait(shotdelaybase + randomfloat(shotdelayrange));
		}
		wait(betweensetsbase + randomfloat(betweensetsrange));
	}
}

/*
	Name: gunfireloopfxvec
	Namespace: fx
	Checksum: 0x7261CB9C
	Offset: 0x560
	Size: 0x84
	Parameters: 9
	Flags: None
*/
function gunfireloopfxvec(fxid, fxpos, fxpos2, shotsmin, shotsmax, shotdelaymin, shotdelaymax, betweensetsmin, betweensetsmax)
{
	thread gunfireloopfxvecthread(fxid, fxpos, fxpos2, shotsmin, shotsmax, shotdelaymin, shotdelaymax, betweensetsmin, betweensetsmax);
}

/*
	Name: gunfireloopfxvecthread
	Namespace: fx
	Checksum: 0x53E758C6
	Offset: 0x5F0
	Size: 0x2D2
	Parameters: 9
	Flags: None
*/
function gunfireloopfxvecthread(fxid, fxpos, fxpos2, shotsmin, shotsmax, shotdelaymin, shotdelaymax, betweensetsmin, betweensetsmax)
{
	level endon(#"hash_ce9de5d2");
	wait(0.05);
	if(betweensetsmax < betweensetsmin)
	{
		temp = betweensetsmax;
		betweensetsmax = betweensetsmin;
		betweensetsmin = temp;
	}
	betweensetsbase = betweensetsmin;
	betweensetsrange = betweensetsmax - betweensetsmin;
	if(shotdelaymax < shotdelaymin)
	{
		temp = shotdelaymax;
		shotdelaymax = shotdelaymin;
		shotdelaymin = temp;
	}
	shotdelaybase = shotdelaymin;
	shotdelayrange = shotdelaymax - shotdelaymin;
	if(shotsmax < shotsmin)
	{
		temp = shotsmax;
		shotsmax = shotsmin;
		shotsmin = temp;
	}
	shotsbase = shotsmin;
	shotsrange = shotsmax - shotsmin;
	fxpos2 = vectornormalize(fxpos2 - fxpos);
	fxent = spawnfx(level._effect[fxid], fxpos, fxpos2);
	for(;;)
	{
		shotnum = shotsbase + randomint(shotsrange);
		for(i = 0; i < (int(shotnum / level.fxfireloopmod)); i++)
		{
			triggerfx(fxent);
			delay = (shotdelaybase + randomfloat(shotdelayrange)) * level.fxfireloopmod;
			if(delay < 0.05)
			{
				delay = 0.05;
			}
			wait(delay);
		}
		wait(shotdelaybase + randomfloat(shotdelayrange));
		wait(betweensetsbase + randomfloat(betweensetsrange));
	}
}

/*
	Name: grenadeexplosionfx
	Namespace: fx
	Checksum: 0xD996A8C1
	Offset: 0x8D0
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function grenadeexplosionfx(pos)
{
	playfx(level._effect["mechanical explosion"], pos);
	earthquake(0.15, 0.5, pos, 250);
}

