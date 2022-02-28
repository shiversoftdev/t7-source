// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace rat_shared;

/*
	Name: init
	Namespace: rat_shared
	Checksum: 0x645BC421
	Offset: 0xD0
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function init()
{
	/#
		if(!isdefined(level.rat))
		{
			level.rat = spawnstruct();
			level.rat.common = spawnstruct();
			level.rat.script_command_list = [];
			addratscriptcmd("", &rscteleport);
			addratscriptcmd("", &rscteleportenemies);
			addratscriptcmd("", &rscsimulatescripterror);
			addratscriptcmd("", &rscrecteleport);
		}
	#/
}

/*
	Name: addratscriptcmd
	Namespace: rat_shared
	Checksum: 0xA1D5276C
	Offset: 0x1E0
	Size: 0x46
	Parameters: 2
	Flags: Linked
*/
function addratscriptcmd(commandname, functioncallback)
{
	/#
		init();
		level.rat.script_command_list[commandname] = functioncallback;
	#/
}

/*
	Name: codecallback_ratscriptcommand
	Namespace: rat_shared
	Checksum: 0x177B05BD
	Offset: 0x230
	Size: 0x104
	Parameters: 1
	Flags: None
*/
function codecallback_ratscriptcommand(params)
{
	/#
		init();
		/#
			assert(isdefined(params._cmd));
		#/
		/#
			assert(isdefined(params._id));
		#/
		/#
			assert(isdefined(level.rat.script_command_list[params._cmd]), "" + params._cmd);
		#/
		callback = level.rat.script_command_list[params._cmd];
		level thread [[callback]](params);
	#/
}

/*
	Name: rscteleport
	Namespace: rat_shared
	Checksum: 0x58DB72F7
	Offset: 0x340
	Size: 0x17C
	Parameters: 1
	Flags: Linked
*/
function rscteleport(params)
{
	/#
		player = [[level.rat.common.gethostplayer]]();
		pos = (float(params.x), float(params.y), float(params.z));
		player setorigin(pos);
		if(isdefined(params.ax))
		{
			angles = (float(params.ax), float(params.ay), float(params.az));
			player setplayerangles(angles);
		}
		ratreportcommandresult(params._id, 1);
	#/
}

/*
	Name: rscteleportenemies
	Namespace: rat_shared
	Checksum: 0x5D890268
	Offset: 0x4C8
	Size: 0x1EC
	Parameters: 1
	Flags: Linked
*/
function rscteleportenemies(params)
{
	/#
		foreach(player in level.players)
		{
			if(!isdefined(player.bot))
			{
				continue;
			}
			pos = (float(params.x), float(params.y), float(params.z));
			player setorigin(pos);
			if(isdefined(params.ax))
			{
				angles = (float(params.ax), float(params.ay), float(params.az));
				player setplayerangles(angles);
			}
			if(!isdefined(params.all))
			{
				break;
			}
		}
		ratreportcommandresult(params._id, 1);
	#/
}

/*
	Name: rscsimulatescripterror
	Namespace: rat_shared
	Checksum: 0x1C804330
	Offset: 0x6C0
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function rscsimulatescripterror(params)
{
	/#
		if(params.errorlevel == "")
		{
			/#
				assertmsg("");
			#/
		}
		else
		{
			thisdoesntexist.orthis = 0;
		}
		ratreportcommandresult(params._id, 1);
	#/
}

/*
	Name: rscrecteleport
	Namespace: rat_shared
	Checksum: 0x8012E80
	Offset: 0x758
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function rscrecteleport(params)
{
	/#
		println("");
		player = [[level.rat.common.gethostplayer]]();
		pos = player getorigin();
		angles = player getplayerangles();
		cmd = (((((((((("" + pos[0]) + "") + pos[1]) + "") + pos[2]) + "") + angles[0]) + "") + angles[1]) + "") + angles[2];
		ratrecordmessage(0, "", cmd);
		setdvar("", "");
	#/
}

