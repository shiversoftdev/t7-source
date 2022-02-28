// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_util;
#using scripts\mp\bots\_bot;
#using scripts\mp\gametypes\_dev;
#using scripts\shared\array_shared;
#using scripts\shared\rat_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace rat;

/*
	Name: __init__sytem__
	Namespace: rat
	Checksum: 0x4188ACBD
	Offset: 0x130
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("", &__init__, undefined, undefined);
	#/
}

/*
	Name: __init__
	Namespace: rat
	Checksum: 0xA2E1D915
	Offset: 0x170
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		rat_shared::init();
		level.rat.common.gethostplayer = &util::gethostplayer;
		level.rat.deathcount = 0;
		rat_shared::addratscriptcmd("", &rscaddenemy);
		setdvar("", 0);
	#/
}

/*
	Name: rscaddenemy
	Namespace: rat
	Checksum: 0xAE3E113B
	Offset: 0x218
	Size: 0x284
	Parameters: 1
	Flags: Linked
*/
function rscaddenemy(params)
{
	/#
		player = [[level.rat.common.gethostplayer]]();
		team = "";
		if(isdefined(player.pers[""]))
		{
			team = util::getotherteam(player.pers[""]);
		}
		bot = dev::getormakebot(team);
		if(!isdefined(bot))
		{
			println("");
			ratreportcommandresult(params._id, 0, "");
			return;
		}
		bot thread testenemy(team);
		bot thread deathcounter();
		wait(2);
		pos = (float(params.x), float(params.y), float(params.z));
		bot setorigin(pos);
		if(isdefined(params.ax))
		{
			angles = (float(params.ax), float(params.ay), float(params.az));
			bot setplayerangles(angles);
		}
		ratreportcommandresult(params._id, 1);
	#/
}

/*
	Name: testenemy
	Namespace: rat
	Checksum: 0xE170273F
	Offset: 0x4A8
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function testenemy(team)
{
	/#
		self endon(#"disconnect");
		while(!isdefined(self.pers[""]))
		{
			wait(0.05);
		}
		if(level.teambased)
		{
			self notify(#"menuresponse", game[""], team);
		}
	#/
}

/*
	Name: deathcounter
	Namespace: rat
	Checksum: 0x6E23E87
	Offset: 0x518
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function deathcounter()
{
	/#
		self waittill(#"death");
		level.rat.deathcount++;
		setdvar("", level.rat.deathcount);
	#/
}

