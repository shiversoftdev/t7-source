// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_debug_menu;
#using scripts\cp\_util;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\init;
#using scripts\shared\ai\systems\weaponlist;
#using scripts\shared\ai_puppeteer_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace debug;

/*
	Name: __init__sytem__
	Namespace: debug
	Checksum: 0x48227B8
	Offset: 0x220
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
	Namespace: debug
	Checksum: 0x6A97CE95
	Offset: 0x260
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		level.animsound_hudlimit = 14;
		level.debugteamcolors = [];
		level.debugteamcolors[""] = (1, 0, 0);
		level.debugteamcolors[""] = (0, 1, 0);
		level.debugteamcolors[""] = (1, 1, 0);
		level.debugteamcolors[""] = (1, 1, 1);
		thread debugdvars();
		thread engagement_distance_debug_toggle();
		thread debug_coop_bot_test();
	#/
}

/*
	Name: drawenttag
	Namespace: debug
	Checksum: 0xBCDFA15D
	Offset: 0x320
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function drawenttag(num)
{
	/#
		ai = getaiarray();
		for(i = 0; i < ai.size; i++)
		{
			if(ai[i] getentnum() != num)
			{
				continue;
			}
			ai[i] thread dragtaguntildeath(getdvarstring(""));
		}
		/#
			setdvar("", "");
		#/
	#/
}

/*
	Name: drawtag
	Namespace: debug
	Checksum: 0x59EC0D79
	Offset: 0x408
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function drawtag(tag, opcolor)
{
	/#
		org = self gettagorigin(tag);
		ang = self gettagangles(tag);
		drawarrow(org, ang, opcolor);
	#/
}

/*
	Name: draworgforever
	Namespace: debug
	Checksum: 0x3A943FFF
	Offset: 0x498
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function draworgforever(opcolor)
{
	/#
		for(;;)
		{
			drawarrow(self.origin, self.angles, opcolor);
			wait(0.05);
		}
	#/
}

/*
	Name: drawarrowforever
	Namespace: debug
	Checksum: 0x3793B79C
	Offset: 0x4E0
	Size: 0x40
	Parameters: 2
	Flags: None
*/
function drawarrowforever(org, ang)
{
	/#
		for(;;)
		{
			drawarrow(org, ang);
			wait(0.05);
		}
	#/
}

/*
	Name: draworiginforever
	Namespace: debug
	Checksum: 0x93399B64
	Offset: 0x528
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function draworiginforever()
{
	/#
		for(;;)
		{
			drawarrow(self.origin, self.angles);
			wait(0.05);
		}
	#/
}

/*
	Name: drawarrow
	Namespace: debug
	Checksum: 0xC0B4A71A
	Offset: 0x568
	Size: 0x2BC
	Parameters: 3
	Flags: Linked
*/
function drawarrow(org, ang, opcolor)
{
	/#
		forward = anglestoforward(ang);
		forwardfar = vectorscale(forward, 50);
		forwardclose = vectorscale(forward, 50 * 0.8);
		right = anglestoright(ang);
		leftdraw = vectorscale(right, 50 * -0.2);
		rightdraw = vectorscale(right, 50 * 0.2);
		up = anglestoup(ang);
		right = vectorscale(right, 50);
		up = vectorscale(up, 50);
		red = (0.9, 0.2, 0.2);
		green = (0.2, 0.9, 0.2);
		blue = (0.2, 0.2, 0.9);
		if(isdefined(opcolor))
		{
			red = opcolor;
			green = opcolor;
			blue = opcolor;
		}
		line(org, org + forwardfar, red, 0.9);
		line(org + forwardfar, (org + forwardclose) + rightdraw, red, 0.9);
		line(org + forwardfar, (org + forwardclose) + leftdraw, red, 0.9);
		line(org, org + right, blue, 0.9);
		line(org, org + up, green, 0.9);
	#/
}

/*
	Name: drawplayerviewforever
	Namespace: debug
	Checksum: 0x81E515F0
	Offset: 0x830
	Size: 0x50
	Parameters: 0
	Flags: None
*/
function drawplayerviewforever()
{
	/#
		for(;;)
		{
			drawarrow(level.player.origin, level.player getplayerangles(), (1, 1, 1));
			wait(0.05);
		}
	#/
}

/*
	Name: drawtagforever
	Namespace: debug
	Checksum: 0xFF551FF8
	Offset: 0x888
	Size: 0x48
	Parameters: 2
	Flags: None
*/
function drawtagforever(tag, opcolor)
{
	/#
		self endon(#"death");
		for(;;)
		{
			drawtag(tag, opcolor);
			wait(0.05);
		}
	#/
}

/*
	Name: dragtaguntildeath
	Namespace: debug
	Checksum: 0xF5055DBA
	Offset: 0x8D8
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function dragtaguntildeath(tag)
{
	/#
		for(;;)
		{
			if(!isdefined(self.origin))
			{
				break;
			}
			drawtag(tag);
			wait(0.05);
		}
	#/
}

/*
	Name: viewtag
	Namespace: debug
	Checksum: 0xAE1589C0
	Offset: 0x920
	Size: 0x10E
	Parameters: 2
	Flags: Linked
*/
function viewtag(type, tag)
{
	/#
		if(type == "")
		{
			ai = getaiarray();
			for(i = 0; i < ai.size; i++)
			{
				ai[i] drawtag(tag);
			}
		}
		else
		{
			vehicle = getentarray("", "");
			for(i = 0; i < vehicle.size; i++)
			{
				vehicle[i] drawtag(tag);
			}
		}
	#/
}

/*
	Name: removeactivespawner
	Namespace: debug
	Checksum: 0xFE7DB7D3
	Offset: 0xA38
	Size: 0x90
	Parameters: 1
	Flags: None
*/
function removeactivespawner(spawner)
{
	/#
		newspawners = [];
		for(p = 0; p < level.activenodes.size; p++)
		{
			if(level.activenodes[p] == spawner)
			{
				continue;
			}
			newspawners[newspawners.size] = level.activenodes[p];
		}
		level.activenodes = newspawners;
	#/
}

/*
	Name: createline
	Namespace: debug
	Checksum: 0xEBD5B11B
	Offset: 0xAD0
	Size: 0x68
	Parameters: 1
	Flags: None
*/
function createline(org)
{
	/#
		for(;;)
		{
			line(org + vectorscale((0, 0, 1), 35), org, (0.2, 0.5, 0.8), 0.5);
			wait(0.05);
		}
	#/
}

/*
	Name: createlineconstantly
	Namespace: debug
	Checksum: 0xA2078325
	Offset: 0xB40
	Size: 0xA8
	Parameters: 1
	Flags: None
*/
function createlineconstantly(ent)
{
	/#
		org = undefined;
		while(isalive(ent))
		{
			org = ent.origin;
			wait(0.05);
		}
		for(;;)
		{
			line(org + vectorscale((0, 0, 1), 35), org, (1, 0.2, 0.1), 0.5);
			wait(0.05);
		}
	#/
}

/*
	Name: debugmisstime
	Namespace: debug
	Checksum: 0x988EE688
	Offset: 0xBF0
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function debugmisstime()
{
	/#
		self notify(#"stopdebugmisstime");
		self endon(#"stopdebugmisstime");
		self endon(#"death");
		for(;;)
		{
			if(self.a.misstime <= 0)
			{
				print3d(self gettagorigin("") + vectorscale((0, 0, 1), 15), "", (0.3, 1, 1), 1);
			}
			else
			{
				print3d(self gettagorigin("") + vectorscale((0, 0, 1), 15), self.a.misstime / 20, (0.3, 1, 1), 1);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: debugmisstimeoff
	Namespace: debug
	Checksum: 0x6B45A073
	Offset: 0xD10
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function debugmisstimeoff()
{
	/#
		self notify(#"stopdebugmisstime");
	#/
}

/*
	Name: setemptydvar
	Namespace: debug
	Checksum: 0xE3C73AC7
	Offset: 0xD30
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function setemptydvar(dvar, setting)
{
	/#
		/#
			if(getdvarstring(dvar) == "")
			{
				setdvar(dvar, setting);
			}
		#/
	#/
}

/*
	Name: debugjump
	Namespace: debug
	Checksum: 0x6F6D57C1
	Offset: 0xD98
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function debugjump(num)
{
	/#
		ai = getaiarray();
		for(i = 0; i < ai.size; i++)
		{
			if(ai[i] getentnum() != num)
			{
				continue;
			}
			players = getplayers();
			line(players[0].origin, ai[i].origin, (0.2, 0.3, 1));
			return;
		}
	#/
}

/*
	Name: debugdvars
	Namespace: debug
	Checksum: 0x63A43B57
	Offset: 0xE90
	Size: 0x1328
	Parameters: 0
	Flags: Linked
*/
function debugdvars()
{
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		setemptydvar("", "");
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		level.debug_badpath = 0;
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		for(i = 1; i <= level.animsound_hudlimit; i++)
		{
			if((getdvarstring("" + i)) == "")
			{
				setdvar("" + i, "");
			}
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
			setdvar("", "");
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		level.last_threat_debug = -23430;
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		waittillframeend();
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		noanimscripts = getdvarstring("") == "";
		for(;;)
		{
			if(getdvarstring("") != "")
			{
				debugjump(getdvarstring(""));
			}
			if(getdvarint("") == 1)
			{
				level thread function_2ceda325();
			}
			if(getdvarstring("") != "")
			{
				thread viewtag("", getdvarstring(""));
				if(getdvarstring("") > 0)
				{
					thread drawenttag(getdvarstring(""));
				}
			}
			if(getdvarstring("") == "")
			{
				level thread debug_goalradius();
			}
			if(getdvarstring("") == "")
			{
				level thread debug_maxvisibledist();
			}
			if(getdvarstring("") == "")
			{
				level thread debug_health();
			}
			if(getdvarstring("") == "")
			{
				level thread debug_engagedist();
			}
			if(getdvarstring("") != "")
			{
				thread viewtag("", getdvarstring(""));
			}
			thread debug_animsound();
			if(getdvarstring("") != "")
			{
				thread debug_animsoundtagselected();
			}
			for(i = 1; i <= level.animsound_hudlimit; i++)
			{
				if((getdvarstring("" + i)) != "")
				{
					thread debug_animsoundtag(i);
				}
			}
			if(getdvarstring("") != "")
			{
				thread debug_animsoundsave();
			}
			if(getdvarstring("") != "")
			{
				thread debug_nuke();
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				array::thread_all(getaiarray(), &debugmisstime);
			}
			else if(getdvarstring("") == "")
			{
				setdvar("", "");
				array::thread_all(getaiarray(), &debugmisstimeoff);
			}
			if(getdvarstring("") == "")
			{
				thread deathspawnerpreview();
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				players = getplayers();
				for(i = 0; i < players.size; i++)
				{
					players[i] dodamage(50, (324234, 3423423, 2323));
				}
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				players = getplayers();
				for(i = 0; i < players.size; i++)
				{
					players[i] dodamage(50, (324234, 3423423, 2323));
				}
			}
			if(getdvarstring("") == "")
			{
				thread fogcheck();
			}
			if(getdvarstring("") != "" && getdvarstring("") != "")
			{
				debugthreat();
			}
			level.debug_badpath = getdvarstring("") == "";
			if(!noanimscripts && getdvarstring("") == "")
			{
				noanimscripts = 1;
			}
			if(noanimscripts && getdvarstring("") == "")
			{
				anim.defaultexception = &util::empty;
				anim notify(#"hash_9a6633d5");
				noanimscripts = 0;
			}
			if(getdvarstring("") == "")
			{
				if(!isdefined(level.tracestart))
				{
					thread showdebugtrace();
				}
				players = getplayers();
				level.tracestart = players[0] geteye();
				setdvar("", "");
			}
			if(getdvarstring("") == "" && (!isdefined(level.spawn_anywhere_active) || level.spawn_anywhere_active == 0))
			{
				level.spawn_anywhere_active = 1;
				thread dynamic_ai_spawner();
			}
			else if(getdvarstring("") == "" && isdefined(level.spawn_anywhere_active) && level.spawn_anywhere_active == 1)
			{
				level.spawn_anywhere_active = 0;
				level notify(#"hash_d123a0a5");
			}
			debug_ik_on_actors();
			wait(0.05);
		}
	#/
}

/*
	Name: debug_ik_on_actors
	Namespace: debug
	Checksum: 0xF64BC17F
	Offset: 0x21C0
	Size: 0x1A2
	Parameters: 0
	Flags: Linked
*/
function debug_ik_on_actors()
{
	/#
		toggleon = getdvarstring("") == "";
		if(!toggleon)
		{
			return;
		}
		togglelegik = getdvarstring("") == "";
		toggleheadik = getdvarstring("") == "";
		ais = getactorarray();
		foreach(ai in ais)
		{
			if(togglelegik)
			{
				ai.enableterrainik = 1;
			}
			else
			{
				ai.enableterrainik = 0;
			}
			if(toggleheadik)
			{
				ai lookatentity(level.players[0]);
				continue;
			}
			ai lookatentity();
		}
	#/
}

/*
	Name: showdebugtrace
	Namespace: debug
	Checksum: 0xE4E1AA1A
	Offset: 0x2370
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function showdebugtrace()
{
	/#
		startoverride = undefined;
		endoverride = undefined;
		startoverride = (15.1859, -12.2822, 4.071);
		endoverride = (947.2, -10918, 64.9514);
		/#
			assert(!isdefined(level.traceend));
		#/
		for(;;)
		{
			players = getplayers();
			wait(0.05);
			start = startoverride;
			end = endoverride;
			if(!isdefined(startoverride))
			{
				start = level.tracestart;
			}
			if(!isdefined(endoverride))
			{
				end = players[0] geteye();
			}
			trace = bullettrace(start, end, 0, undefined);
			line(start, trace[""], (0.9, 0.5, 0.8), 0.5);
		}
	#/
}

/*
	Name: hatmodel
	Namespace: debug
	Checksum: 0x1E358FF9
	Offset: 0x24F8
	Size: 0x1DE
	Parameters: 0
	Flags: None
*/
function hatmodel()
{
	/#
		for(;;)
		{
			if(getdvarstring("") == "")
			{
				return;
			}
			nohat = [];
			ai = getaiarray();
			for(i = 0; i < ai.size; i++)
			{
				if(isdefined(ai[i].hatmodel))
				{
					continue;
				}
				alreadyknown = 0;
				for(p = 0; p < nohat.size; p++)
				{
					if(nohat[p] != ai[i].classname)
					{
						continue;
					}
					alreadyknown = 1;
					break;
				}
				if(!alreadyknown)
				{
					nohat[nohat.size] = ai[i].classname;
				}
			}
			if(nohat.size)
			{
				println("");
				println("");
				for(i = 0; i < nohat.size; i++)
				{
					println("", nohat[i]);
				}
				println("");
			}
			wait(15);
		}
	#/
}

/*
	Name: debug_nuke
	Namespace: debug
	Checksum: 0x5D08F0E2
	Offset: 0x26E0
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function debug_nuke()
{
	/#
		players = getplayers();
		player = players[0];
		dvar = getdvarstring("");
		if(dvar == "")
		{
			ai = getaiteamarray("", "");
			for(i = 0; i < ai.size; i++)
			{
				ignore = 0;
				classname = ai[i].classname;
				if(isdefined(classname) && (issubstr(classname, "") || issubstr(classname, "") || issubstr(classname, "")))
				{
					ignore = 1;
				}
				if(!ignore)
				{
					ai[i] dodamage(ai[i].health, (0, 0, 0), player);
				}
			}
		}
		else
		{
			if(dvar == "")
			{
				ai = getaiteamarray("");
				for(i = 0; i < ai.size; i++)
				{
					ai[i] dodamage(ai[i].health, (0, 0, 0), player);
				}
			}
			else if(dvar == "")
			{
				ai = getaispeciesarray("", "");
				for(i = 0; i < ai.size; i++)
				{
					ai[i] dodamage(ai[i].health, (0, 0, 0), player);
				}
			}
		}
		setdvar("", "");
	#/
}

/*
	Name: debug_misstime
	Namespace: debug
	Checksum: 0x39FFB43E
	Offset: 0x29E0
	Size: 0x8
	Parameters: 0
	Flags: None
*/
function debug_misstime()
{
	/#
	#/
}

/*
	Name: freeplayer
	Namespace: debug
	Checksum: 0xD558006
	Offset: 0x29F0
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function freeplayer()
{
	/#
		setdvar("", "");
	#/
}

/*
	Name: deathspawnerpreview
	Namespace: debug
	Checksum: 0xFBDAF281
	Offset: 0x2A28
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function deathspawnerpreview()
{
	/#
		waittillframeend();
		for(i = 0; i < 50; i++)
		{
			if(!isdefined(level.deathspawnerents[i]))
			{
				continue;
			}
			array = level.deathspawnerents[i];
			for(p = 0; p < array.size; p++)
			{
				ent = array[p];
				if(isdefined(ent.truecount))
				{
					print3d(ent.origin, (i + "") + ent.truecount, (0, 0.8, 0.6), 5);
					continue;
				}
				print3d(ent.origin, (i + "") + "", (0, 0.8, 0.6), 5);
			}
		}
	#/
}

/*
	Name: getchains
	Namespace: debug
	Checksum: 0xDACD9543
	Offset: 0x2B90
	Size: 0xA4
	Parameters: 0
	Flags: None
*/
function getchains()
{
	/#
		chainarray = [];
		chainarray = getentarray("", "");
		array = [];
		for(i = 0; i < chainarray.size; i++)
		{
			array[i] = chainarray[i] getchain();
		}
		return array;
	#/
}

/*
	Name: getchain
	Namespace: debug
	Checksum: 0xB640BE75
	Offset: 0x2C40
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function getchain()
{
	/#
		array = [];
		ent = self;
		while(isdefined(ent))
		{
			array[array.size] = ent;
			if(!isdefined(ent) || !isdefined(ent.target))
			{
				break;
			}
			ent = getent(ent.target, "");
			if(isdefined(ent) && ent == array[0])
			{
				array[array.size] = ent;
				break;
			}
		}
		originarray = [];
		for(i = 0; i < array.size; i++)
		{
			originarray[i] = array[i].origin;
		}
		return originarray;
	#/
}

/*
	Name: vecscale
	Namespace: debug
	Checksum: 0x63961390
	Offset: 0x2D70
	Size: 0x48
	Parameters: 2
	Flags: None
*/
function vecscale(vec, scalar)
{
	/#
		return (vec[0] * scalar, vec[1] * scalar, vec[2] * scalar);
	#/
}

/*
	Name: islookingatorigin
	Namespace: debug
	Checksum: 0x9BCC0140
	Offset: 0x2DC8
	Size: 0x12A
	Parameters: 1
	Flags: None
*/
function islookingatorigin(origin)
{
	/#
		normalvec = vectornormalize(origin - self getshootatpos());
		veccomp = vectornormalize((origin - vectorscale((0, 0, 1), 24)) - self getshootatpos());
		insidedot = vectordot(normalvec, veccomp);
		anglevec = anglestoforward(self getplayerangles());
		vectordot = vectordot(anglevec, normalvec);
		if(vectordot > insidedot)
		{
			return true;
		}
		return false;
	#/
}

/*
	Name: fogcheck
	Namespace: debug
	Checksum: 0xF53F8B38
	Offset: 0x2F00
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function fogcheck()
{
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		close = getdvarint("");
		far = getdvarint("");
		setexpfog(close, far, 1, 1, 1, 0);
	#/
}

/*
	Name: debugthreat
	Namespace: debug
	Checksum: 0xE53222EC
	Offset: 0x3020
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function debugthreat()
{
	/#
		level.last_threat_debug = gettime();
		thread debugthreatcalc();
	#/
}

/*
	Name: debugthreatcalc
	Namespace: debug
	Checksum: 0x2411F664
	Offset: 0x3050
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function debugthreatcalc()
{
	/#
		ai = getaiarray();
		entnum = getdvarstring("");
		entity = undefined;
		players = getplayers();
		if(entnum == 0)
		{
			entity = players[0];
		}
		else
		{
			for(i = 0; i < ai.size; i++)
			{
				if(entnum != ai[i] getentnum())
				{
					continue;
				}
				entity = ai[i];
				break;
			}
		}
		if(!isalive(entity))
		{
			return;
		}
		entitygroup = entity getthreatbiasgroup();
		array::thread_all(ai, &displaythreat, entity, entitygroup);
		players[0] thread displaythreat(entity, entitygroup);
	#/
}

/*
	Name: displaythreat
	Namespace: debug
	Checksum: 0x4B06F516
	Offset: 0x31E8
	Size: 0x3CE
	Parameters: 2
	Flags: Linked
*/
function displaythreat(entity, entitygroup)
{
	/#
		self endon(#"death");
		if(self.team == entity.team)
		{
			return;
		}
		selfthreat = 0;
		selfthreat = selfthreat + self.threatbias;
		threat = 0;
		threat = threat + entity.threatbias;
		mygroup = undefined;
		if(isdefined(entitygroup))
		{
			mygroup = self getthreatbiasgroup();
			if(isdefined(mygroup))
			{
				threat = threat + getthreatbias(entitygroup, mygroup);
				selfthreat = selfthreat + getthreatbias(mygroup, entitygroup);
			}
		}
		if(entity.ignoreme || threat < -900000)
		{
			threat = "";
		}
		if(self.ignoreme || selfthreat < -900000)
		{
			selfthreat = "";
		}
		players = getplayers();
		col = (1, 0.5, 0.2);
		col2 = (0.2, 0.5, 1);
		pacifist = self != players[0] && self.pacifist;
		for(i = 0; i <= 20; i++)
		{
			print3d(self.origin + vectorscale((0, 0, 1), 65), "", col, 3);
			print3d(self.origin + vectorscale((0, 0, 1), 50), threat, col, 5);
			if(isdefined(entitygroup))
			{
				print3d(self.origin + vectorscale((0, 0, 1), 35), entitygroup, col, 2);
			}
			print3d(self.origin + vectorscale((0, 0, 1), 15), "", col2, 3);
			print3d(self.origin + (0, 0, 0), selfthreat, col2, 5);
			if(isdefined(mygroup))
			{
				print3d(self.origin + (vectorscale((0, 0, -1), 15)), mygroup, col2, 2);
			}
			if(pacifist)
			{
				print3d(self.origin + vectorscale((0, 0, 1), 25), "", col2, 5);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: init_animsounds
	Namespace: debug
	Checksum: 0x311D95C7
	Offset: 0x35C0
	Size: 0xE6
	Parameters: 0
	Flags: Linked
*/
function init_animsounds()
{
	/#
		level.animsounds = [];
		level.animsound_aliases = [];
		waittillframeend();
		waittillframeend();
		animnames = getarraykeys(level.scr_notetrack);
		for(i = 0; i < animnames.size; i++)
		{
			init_notetracks_for_animname(animnames[i]);
		}
		animnames = getarraykeys(level.scr_animsound);
		for(i = 0; i < animnames.size; i++)
		{
			init_animsounds_for_animname(animnames[i]);
		}
	#/
}

/*
	Name: init_notetracks_for_animname
	Namespace: debug
	Checksum: 0x1F1A8413
	Offset: 0x36B0
	Size: 0x16E
	Parameters: 1
	Flags: Linked
*/
function init_notetracks_for_animname(animname)
{
	/#
		notetracks = getarraykeys(level.scr_notetrack[animname]);
		for(i = 0; i < notetracks.size; i++)
		{
			soundalias = level.scr_notetrack[animname][i][""];
			if(!isdefined(soundalias))
			{
				continue;
			}
			anime = level.scr_notetrack[animname][i][""];
			notetrack = level.scr_notetrack[animname][i][""];
			level.animsound_aliases[animname][anime][notetrack][""] = soundalias;
			if(isdefined(level.scr_notetrack[animname][i][""]))
			{
				level.animsound_aliases[animname][anime][notetrack][""] = 1;
			}
		}
	#/
}

/*
	Name: init_animsounds_for_animname
	Namespace: debug
	Checksum: 0x741F5161
	Offset: 0x3828
	Size: 0x102
	Parameters: 1
	Flags: Linked
*/
function init_animsounds_for_animname(animname)
{
	/#
		animes = getarraykeys(level.scr_animsound[animname]);
		for(i = 0; i < animes.size; i++)
		{
			anime = animes[i];
			soundalias = level.scr_animsound[animname][anime];
			level.animsound_aliases[animname][anime]["" + anime][""] = soundalias;
			level.animsound_aliases[animname][anime]["" + anime][""] = 1;
		}
	#/
}

/*
	Name: add_hud_line
	Namespace: debug
	Checksum: 0x33A0EFE9
	Offset: 0x3938
	Size: 0xE6
	Parameters: 3
	Flags: Linked
*/
function add_hud_line(x, y, msg)
{
	/#
		hudelm = newhudelem();
		hudelm.alignx = "";
		hudelm.aligny = "";
		hudelm.x = x;
		hudelm.y = y;
		hudelm.alpha = 1;
		hudelm.fontscale = 1;
		hudelm.label = msg;
		level.animsound_hud_extralines[level.animsound_hud_extralines.size] = hudelm;
		return hudelm;
	#/
}

/*
	Name: debug_animsound
	Namespace: debug
	Checksum: 0x9A542A82
	Offset: 0x3A28
	Size: 0x96C
	Parameters: 0
	Flags: Linked
*/
function debug_animsound()
{
	/#
		enabled = getdvarstring("") == "";
		if(!isdefined(level.animsound_hud))
		{
			if(!enabled)
			{
				return;
			}
			level.animsound_selected = 0;
			level.animsound_input = "";
			level.animsound_hud = [];
			level.animsound_hud_timer = [];
			level.animsound_hud_alias = [];
			level.animsound_hud_extralines = [];
			level.animsound_locked = 0;
			level.animsound_locked_pressed = 0;
			level.animsound_hud_animname = add_hud_line(-30, 180, "");
			level.animsound_hud_anime = add_hud_line(100, 180, "");
			add_hud_line(10, 190, "");
			add_hud_line(-30, 190, "");
			add_hud_line(-30, 160, "");
			add_hud_line(-30, 150, "");
			add_hud_line(-30, 140, "");
			level.animsound_hud_locked = add_hud_line(-30, 170, "");
			level.animsound_hud_locked.alpha = 0;
			for(i = 0; i < level.animsound_hudlimit; i++)
			{
				hudelm = newhudelem();
				hudelm.alignx = "";
				hudelm.aligny = "";
				hudelm.x = 10;
				hudelm.y = 200 + (i * 10);
				hudelm.alpha = 1;
				hudelm.fontscale = 1;
				hudelm.label = "";
				level.animsound_hud[level.animsound_hud.size] = hudelm;
				hudelm = newhudelem();
				hudelm.alignx = "";
				hudelm.aligny = "";
				hudelm.x = -10;
				hudelm.y = 200 + (i * 10);
				hudelm.alpha = 1;
				hudelm.fontscale = 1;
				hudelm.label = "";
				level.animsound_hud_timer[level.animsound_hud_timer.size] = hudelm;
				hudelm = newhudelem();
				hudelm.alignx = "";
				hudelm.aligny = "";
				hudelm.x = 210;
				hudelm.y = 200 + (i * 10);
				hudelm.alpha = 1;
				hudelm.fontscale = 1;
				hudelm.label = "";
				level.animsound_hud_alias[level.animsound_hud_alias.size] = hudelm;
			}
			level.animsound_hud[0].color = (1, 1, 0);
			level.animsound_hud_timer[0].color = (1, 1, 0);
		}
		else if(!enabled)
		{
			for(i = 0; i < level.animsound_hudlimit; i++)
			{
				level.animsound_hud[i] destroy();
				level.animsound_hud_timer[i] destroy();
				level.animsound_hud_alias[i] destroy();
			}
			for(i = 0; i < level.animsound_hud_extralines.size; i++)
			{
				level.animsound_hud_extralines[i] destroy();
			}
			level.animsound_hud = undefined;
			level.animsound_hud_timer = undefined;
			level.animsound_hud_alias = undefined;
			level.animsound_hud_extralines = undefined;
			level.animsounds = undefined;
			return;
		}
		if(!isdefined(level.animsound_tagged))
		{
			level.animsound_locked = 0;
		}
		if(level.animsound_locked)
		{
			level.animsound_hud_locked.alpha = 1;
		}
		else
		{
			level.animsound_hud_locked.alpha = 0;
		}
		if(!isdefined(level.animsounds))
		{
			init_animsounds();
		}
		level.animsounds_thisframe = [];
		arrayremovevalue(level.animsounds, undefined);
		array::thread_all(level.animsounds, &display_animsound);
		players = getplayers();
		if(level.animsound_locked)
		{
			for(i = 0; i < level.animsounds_thisframe.size; i++)
			{
				animsound = level.animsounds_thisframe[i];
				animsound.animsound_color = vectorscale((1, 1, 1), 0.5);
			}
		}
		else if(players.size > 0)
		{
			dot = 0.85;
			forward = anglestoforward(players[0] getplayerangles());
			for(i = 0; i < level.animsounds_thisframe.size; i++)
			{
				animsound = level.animsounds_thisframe[i];
				animsound.animsound_color = (0.25, 1, 0.5);
				difference = vectornormalize((animsound.origin + vectorscale((0, 0, 1), 40)) - (players[0].origin + vectorscale((0, 0, 1), 55)));
				newdot = vectordot(forward, difference);
				if(newdot < dot)
				{
					continue;
				}
				dot = newdot;
				level.animsound_tagged = animsound;
			}
		}
		if(isdefined(level.animsound_tagged))
		{
			level.animsound_tagged.animsound_color = (1, 1, 0);
		}
		is_tagged = isdefined(level.animsound_tagged);
		for(i = 0; i < level.animsounds_thisframe.size; i++)
		{
			animsound = level.animsounds_thisframe[i];
			msg = "";
			if(level.animsound_locked)
			{
				msg = "";
			}
			print3d(animsound.origin + vectorscale((0, 0, 1), 40), msg + animsound.animsounds.size, animsound.animsound_color, 1, 1);
		}
		if(is_tagged)
		{
			draw_animsounds_in_hud();
		}
	#/
}

/*
	Name: draw_animsounds_in_hud
	Namespace: debug
	Checksum: 0x62FFED0B
	Offset: 0x43A0
	Size: 0x6EC
	Parameters: 0
	Flags: Linked
*/
function draw_animsounds_in_hud()
{
	/#
		guy = level.animsound_tagged;
		animsounds = guy.animsounds;
		animname = "";
		if(isdefined(guy.animname))
		{
			animname = guy.animname;
		}
		level.animsound_hud_animname.label = "" + animname;
		players = getplayers();
		if(players[0] buttonpressed(""))
		{
			if(!level.animsound_locked_pressed)
			{
				level.animsound_locked = !level.animsound_locked;
				level.animsound_locked_pressed = 1;
			}
		}
		else
		{
			level.animsound_locked_pressed = 0;
		}
		if(players[0] buttonpressed(""))
		{
			if(level.animsound_input != "")
			{
				level.animsound_selected--;
			}
			level.animsound_input = "";
		}
		else
		{
			if(players[0] buttonpressed(""))
			{
				if(level.animsound_input != "")
				{
					level.animsound_selected++;
				}
				level.animsound_input = "";
			}
			else
			{
				level.animsound_input = "";
			}
		}
		for(i = 0; i < level.animsound_hudlimit; i++)
		{
			hudelm = level.animsound_hud[i];
			hudelm.label = "";
			hudelm.color = (1, 1, 1);
			hudelm = level.animsound_hud_timer[i];
			hudelm.label = "";
			hudelm.color = (1, 1, 1);
			hudelm = level.animsound_hud_alias[i];
			hudelm.label = "";
			hudelm.color = (1, 1, 1);
		}
		keys = getarraykeys(animsounds);
		highest = -1;
		for(i = 0; i < keys.size; i++)
		{
			if(keys[i] > highest)
			{
				highest = keys[i];
			}
		}
		if(highest == -1)
		{
			return;
		}
		if(level.animsound_selected > highest)
		{
			level.animsound_selected = highest;
		}
		if(level.animsound_selected < 0)
		{
			level.animsound_selected = 0;
		}
		for(;;)
		{
			if(isdefined(animsounds[level.animsound_selected]))
			{
				break;
			}
			level.animsound_selected--;
			if(level.animsound_selected < 0)
			{
				level.animsound_selected = highest;
			}
		}
		level.animsound_hud_anime.label = "" + animsounds[level.animsound_selected].anime;
		level.animsound_hud[level.animsound_selected].color = (1, 1, 0);
		level.animsound_hud_timer[level.animsound_selected].color = (1, 1, 0);
		level.animsound_hud_alias[level.animsound_selected].color = (1, 1, 0);
		time = gettime();
		for(i = 0; i < keys.size; i++)
		{
			key = keys[i];
			animsound = animsounds[key];
			hudelm = level.animsound_hud[key];
			soundalias = get_alias_from_stored(animsound);
			hudelm.label = ((key + 1) + "") + animsound.notetrack;
			hudelm = level.animsound_hud_timer[key];
			hudelm.label = int((time - (animsound.end_time - 60000)) * 0.001);
			if(isdefined(soundalias))
			{
				hudelm = level.animsound_hud_alias[key];
				hudelm.label = soundalias;
				if(!is_from_animsound(animsound.animname, animsound.anime, animsound.notetrack))
				{
					hudelm.color = vectorscale((1, 1, 1), 0.7);
				}
			}
		}
		players = getplayers();
		if(players[0] buttonpressed(""))
		{
			animsound = animsounds[level.animsound_selected];
			soundalias = get_alias_from_stored(animsound);
			if(!isdefined(soundalias))
			{
				return;
			}
			if(!is_from_animsound(animsound.animname, animsound.anime, animsound.notetrack))
			{
				return;
			}
			level.animsound_aliases[animsound.animname][animsound.anime][animsound.notetrack] = undefined;
			debug_animsoundsave();
		}
	#/
}

/*
	Name: get_alias_from_stored
	Namespace: debug
	Checksum: 0xE89DA0A4
	Offset: 0x4A98
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function get_alias_from_stored(animsound)
{
	/#
		if(!isdefined(level.animsound_aliases[animsound.animname]))
		{
			return;
		}
		if(!isdefined(level.animsound_aliases[animsound.animname][animsound.anime]))
		{
			return;
		}
		if(!isdefined(level.animsound_aliases[animsound.animname][animsound.anime][animsound.notetrack]))
		{
			return;
		}
		return level.animsound_aliases[animsound.animname][animsound.anime][animsound.notetrack][""];
	#/
}

/*
	Name: is_from_animsound
	Namespace: debug
	Checksum: 0x64BF1628
	Offset: 0x4B78
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function is_from_animsound(animname, anime, notetrack)
{
	/#
		return isdefined(level.animsound_aliases[animname][anime][notetrack][""]);
	#/
}

/*
	Name: display_animsound
	Namespace: debug
	Checksum: 0x200114FD
	Offset: 0x4BC8
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function display_animsound()
{
	/#
		players = getplayers();
		if(distance(players[0].origin, self.origin) > 1500)
		{
			return;
		}
		level.animsounds_thisframe[level.animsounds_thisframe.size] = self;
	#/
}

/*
	Name: debug_animsoundtag
	Namespace: debug
	Checksum: 0x50D81A90
	Offset: 0x4C48
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function debug_animsoundtag(tagnum)
{
	/#
		tag = getdvarstring("" + tagnum);
		if(tag == "")
		{
			iprintlnbold("");
			return;
		}
		tag_sound(tag, tagnum - 1);
		setdvar("" + tagnum, "");
	#/
}

/*
	Name: debug_animsoundtagselected
	Namespace: debug
	Checksum: 0x711905BE
	Offset: 0x4D08
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function debug_animsoundtagselected()
{
	/#
		tag = getdvarstring("");
		if(tag == "")
		{
			iprintlnbold("");
			return;
		}
		tag_sound(tag, level.animsound_selected);
		setdvar("", "");
	#/
}

/*
	Name: tag_sound
	Namespace: debug
	Checksum: 0x71EC5DA1
	Offset: 0x4DB0
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function tag_sound(tag, tagnum)
{
	/#
		if(!isdefined(level.animsound_tagged))
		{
			return;
		}
		if(!isdefined(level.animsound_tagged.animsounds[tagnum]))
		{
			return;
		}
		animsound = level.animsound_tagged.animsounds[tagnum];
		soundalias = get_alias_from_stored(animsound);
		if(!isdefined(soundalias) || is_from_animsound(animsound.animname, animsound.anime, animsound.notetrack))
		{
			level.animsound_aliases[animsound.animname][animsound.anime][animsound.notetrack][""] = tag;
			level.animsound_aliases[animsound.animname][animsound.anime][animsound.notetrack][""] = 1;
			debug_animsoundsave();
		}
	#/
}

/*
	Name: debug_animsoundsave
	Namespace: debug
	Checksum: 0x591A8F25
	Offset: 0x4F20
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function debug_animsoundsave()
{
	/#
		filename = ("" + level.script) + "";
		file = openfile(filename, "");
		if(file == -1)
		{
			iprintlnbold(("" + filename) + "");
			return;
		}
		iprintlnbold("" + filename);
		print_aliases_to_file(file);
		saved = closefile(file);
		setdvar("", "");
	#/
}

/*
	Name: print_aliases_to_file
	Namespace: debug
	Checksum: 0x43768076
	Offset: 0x5038
	Size: 0x4B4
	Parameters: 1
	Flags: Linked
*/
function print_aliases_to_file(file)
{
	/#
		tab = "";
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, tab + "");
		fprintln(file, tab + "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, tab + "");
		animnames = getarraykeys(level.animsound_aliases);
		for(i = 0; i < animnames.size; i++)
		{
			animes = getarraykeys(level.animsound_aliases[animnames[i]]);
			for(p = 0; p < animes.size; p++)
			{
				anime = animes[p];
				notetracks = getarraykeys(level.animsound_aliases[animnames[i]][anime]);
				for(z = 0; z < notetracks.size; z++)
				{
					notetrack = notetracks[z];
					if(!is_from_animsound(animnames[i], anime, notetrack))
					{
						continue;
					}
					alias = level.animsound_aliases[animnames[i]][anime][notetrack][""];
					if(notetrack == ("" + anime))
					{
						fprintln(file, (((tab + "") + tostr(animnames[i]) + "") + tostr(anime) + "") + tostr(alias) + "");
					}
					else
					{
						fprintln(file, ((((tab + "") + tostr(animnames[i]) + "") + tostr(anime) + "") + tostr(notetrack) + "") + tostr(alias) + "");
					}
					println((("" + alias) + "") + notetrack);
				}
			}
		}
		fprintln(file, "");
	#/
}

/*
	Name: function_2ceda325
	Namespace: debug
	Checksum: 0xBA2242B3
	Offset: 0x54F8
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function function_2ceda325()
{
	/#
		setdvar("", 0);
		if(!isdefined(level.a_npcdeaths) || getdvarint("") != 1)
		{
			return;
		}
		players = getplayers();
		filename = ((("" + level.savename) + "") + players[0].playername) + "";
		/#
			file = openfile(filename, "");
			if(file == -1)
			{
				iprintlnbold(("" + filename) + "");
				return;
			}
			if(isdefined(level.current_skipto))
			{
				fprintln(file, ("" + level.current_skipto) + "");
			}
			else
			{
				fprintln(file, "");
			}
			if(level.a_npcdeaths.size <= 0)
			{
				fprintln(file, "");
			}
			foreach(deadnpctypecount in level.a_npcdeaths)
			{
				fprintln(file, (((((deadnpctypecount.strscoretype + "") + deadnpctypecount.icount) + "") + deadnpctypecount.ikilledbyplayercount) + "") + deadnpctypecount.ixpvaluesum);
			}
			fprintln(file, "");
			iprintlnbold("" + filename);
			saved = closefile(file);
		#/
		level.a_npcdeaths = [];
	#/
}

/*
	Name: tostr
	Namespace: debug
	Checksum: 0x94437A62
	Offset: 0x57F8
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function tostr(str)
{
	/#
		newstr = "";
		for(i = 0; i < str.size; i++)
		{
			if(str[i] == "")
			{
				newstr = newstr + "";
				newstr = newstr + "";
				continue;
			}
			newstr = newstr + str[i];
		}
		newstr = newstr + "";
		return newstr;
	#/
}

/*
	Name: drawdebuglineinternal
	Namespace: debug
	Checksum: 0x7EDD907C
	Offset: 0x58C0
	Size: 0x76
	Parameters: 4
	Flags: Linked
*/
function drawdebuglineinternal(frompoint, topoint, color, durationframes)
{
	/#
		for(i = 0; i < durationframes; i++)
		{
			line(frompoint, topoint, color);
			wait(0.05);
		}
	#/
}

/*
	Name: drawdebugline
	Namespace: debug
	Checksum: 0x8C49236A
	Offset: 0x5940
	Size: 0x4C
	Parameters: 4
	Flags: None
*/
function drawdebugline(frompoint, topoint, color, durationframes)
{
	/#
		thread drawdebuglineinternal(frompoint, topoint, color, durationframes);
	#/
}

/*
	Name: drawdebugenttoentinternal
	Namespace: debug
	Checksum: 0xDAFA6D3A
	Offset: 0x5998
	Size: 0x9E
	Parameters: 4
	Flags: Linked
*/
function drawdebugenttoentinternal(ent1, ent2, color, durationframes)
{
	/#
		for(i = 0; i < durationframes; i++)
		{
			if(!isdefined(ent1) || !isdefined(ent2))
			{
				return;
			}
			line(ent1.origin, ent2.origin, color);
			wait(0.05);
		}
	#/
}

/*
	Name: drawdebuglineenttoent
	Namespace: debug
	Checksum: 0x2AAA9B33
	Offset: 0x5A40
	Size: 0x4C
	Parameters: 4
	Flags: None
*/
function drawdebuglineenttoent(ent1, ent2, color, durationframes)
{
	/#
		thread drawdebugenttoentinternal(ent1, ent2, color, durationframes);
	#/
}

/*
	Name: new_hud
	Namespace: debug
	Checksum: 0x68479A06
	Offset: 0x5A98
	Size: 0xC0
	Parameters: 5
	Flags: None
*/
function new_hud(hud_name, msg, x, y, scale)
{
	/#
		if(!isdefined(level.hud_array))
		{
			level.hud_array = [];
		}
		if(!isdefined(level.hud_array[hud_name]))
		{
			level.hud_array[hud_name] = [];
		}
		hud = debug_menu::set_hudelem(msg, x, y, scale);
		level.hud_array[hud_name][level.hud_array[hud_name].size] = hud;
		return hud;
	#/
}

/*
	Name: debug_show_viewpos
	Namespace: debug
	Checksum: 0x4D031F93
	Offset: 0x5B68
	Size: 0x534
	Parameters: 0
	Flags: None
*/
function debug_show_viewpos()
{
	/#
		hud_title = newdebughudelem();
		hud_title.x = 10;
		hud_title.y = 300;
		hud_title.alpha = 0;
		hud_title.alignx = "";
		hud_title.fontscale = 1.2;
		hud_title settext(&"");
		x_pos = hud_title.x + 50;
		hud_x = newdebughudelem();
		hud_x.x = x_pos;
		hud_x.y = 300;
		hud_x.alpha = 0;
		hud_x.alignx = "";
		hud_x.fontscale = 1.2;
		hud_x setvalue(0);
		hud_y = newdebughudelem();
		hud_y.x = 10;
		hud_y.y = 300;
		hud_y.alpha = 0;
		hud_y.alignx = "";
		hud_y.fontscale = 1.2;
		hud_y setvalue(0);
		hud_z = newdebughudelem();
		hud_z.x = 10;
		hud_z.y = 300;
		hud_z.alpha = 0;
		hud_z.alignx = "";
		hud_z.fontscale = 1.2;
		hud_z setvalue(0);
		setdvar("", "");
		players = getplayers();
		while(true)
		{
			if(getdvarint("") > 0)
			{
				hud_title.alpha = 1;
				hud_x.alpha = 1;
				hud_y.alpha = 1;
				hud_z.alpha = 1;
				x = players[0].origin[0];
				y = players[0].origin[1];
				z = players[0].origin[2];
				spacing1 = ((2 + number_before_decimal(x)) * 8) + 10;
				spacing2 = ((2 + number_before_decimal(y)) * 8) + 10;
				hud_y.x = x_pos + spacing1;
				hud_z.x = (x_pos + spacing1) + spacing2;
				hud_x setvalue(round_to(x, 100));
				hud_y setvalue(round_to(y, 100));
				hud_z setvalue(round_to(z, 100));
			}
			else
			{
				hud_title.alpha = 0;
				hud_x.alpha = 0;
				hud_y.alpha = 0;
				hud_z.alpha = 0;
			}
			wait(0.5);
		}
	#/
}

/*
	Name: number_before_decimal
	Namespace: debug
	Checksum: 0x83971EDF
	Offset: 0x60A8
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function number_before_decimal(num)
{
	/#
		abs_num = abs(num);
		count = 0;
		while(true)
		{
			abs_num = abs_num * 0.1;
			count = count + 1;
			if(abs_num < 1)
			{
				return count;
			}
		}
	#/
}

/*
	Name: round_to
	Namespace: debug
	Checksum: 0x30A54370
	Offset: 0x6138
	Size: 0x38
	Parameters: 2
	Flags: Linked
*/
function round_to(val, num)
{
	/#
		return (int(val * num)) / num;
	#/
}

/*
	Name: set_event_printname_thread
	Namespace: debug
	Checksum: 0xA31BDEBB
	Offset: 0x6180
	Size: 0x320
	Parameters: 2
	Flags: None
*/
function set_event_printname_thread(text, focus)
{
	/#
		level notify(#"stop_event_name_thread");
		level endon(#"stop_event_name_thread");
		if(getdvarint("") > 0)
		{
			return;
		}
		if(!isdefined(focus))
		{
			focus = 0;
		}
		suffix = "";
		if(focus)
		{
			suffix = "";
		}
		setdvar("", text);
		text = ("" + text) + suffix;
		if(!isdefined(level.event_hudelem))
		{
			hud = newhudelem();
			hud.horzalign = "";
			hud.alignx = "";
			hud.aligny = "";
			hud.foreground = 1;
			hud.fontscale = 1.5;
			hud.sort = 50;
			hud.alpha = 1;
			hud.y = 15;
			level.event_hudelem = hud;
		}
		if(focus)
		{
			level.event_hudelem.color = (1, 1, 0);
		}
		else
		{
			level.event_hudelem.color = (1, 1, 1);
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		level.event_hudelem settext(text);
		enabled = 1;
		while(true)
		{
			toggle = 0;
			if(getdvarint("") < 1)
			{
				toggle = 1;
				enabled = 0;
			}
			else if(getdvarint("") > 0)
			{
				toggle = 1;
				enabled = 1;
			}
			if(toggle && enabled)
			{
				level.event_hudelem.alpha = 1;
			}
			else if(toggle)
			{
				level.event_hudelem.alpha = 0;
			}
			wait(0.5);
		}
	#/
}

/*
	Name: get_playerone
	Namespace: debug
	Checksum: 0xE60D16C2
	Offset: 0x64A8
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function get_playerone()
{
	/#
		return level.players[0];
	#/
}

/*
	Name: engagement_distance_debug_toggle
	Namespace: debug
	Checksum: 0xE9B3D32D
	Offset: 0x64C8
	Size: 0x130
	Parameters: 0
	Flags: Linked
*/
function engagement_distance_debug_toggle()
{
	/#
		level endon(#"kill_engage_dist_debug_toggle_watcher");
		laststate = getdvarint("");
		while(true)
		{
			currentstate = getdvarint("");
			if(dvar_turned_on(currentstate) && !dvar_turned_on(laststate))
			{
				weapon_engage_dists_init();
				thread debug_realtime_engage_dist();
				thread debug_ai_engage_dist();
				laststate = currentstate;
			}
			else if(!dvar_turned_on(currentstate) && dvar_turned_on(laststate))
			{
				level notify(#"kill_all_engage_dist_debug");
				laststate = currentstate;
			}
			wait(0.3);
		}
	#/
}

/*
	Name: dvar_turned_on
	Namespace: debug
	Checksum: 0x8DF10036
	Offset: 0x6600
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function dvar_turned_on(val)
{
	/#
		if(val <= 0)
		{
			return false;
		}
		return true;
	#/
}

/*
	Name: engagement_distance_debug_init
	Namespace: debug
	Checksum: 0xD87D2C89
	Offset: 0x6638
	Size: 0x34A
	Parameters: 1
	Flags: Linked
*/
function engagement_distance_debug_init(player)
{
	/#
		level.realtimeengagedist = newclienthudelem(player);
		level.realtimeengagedist.alignx = "";
		level.realtimeengagedist.fontscale = 1.5;
		level.realtimeengagedist.x = -50;
		level.realtimeengagedist.y = 250;
		level.realtimeengagedist.color = (1, 1, 1);
		level.realtimeengagedist settext("");
		xpos = 157;
		level.realtimeengagedist_value = newclienthudelem(player);
		level.realtimeengagedist_value.alignx = "";
		level.realtimeengagedist_value.fontscale = 1.5;
		level.realtimeengagedist_value.x = xpos;
		level.realtimeengagedist_value.y = 250;
		level.realtimeengagedist_value.color = (1, 1, 1);
		level.realtimeengagedist_value setvalue(0);
		xpos = xpos + 37;
		level.realtimeengagedist_middle = newclienthudelem(player);
		level.realtimeengagedist_middle.alignx = "";
		level.realtimeengagedist_middle.fontscale = 1.5;
		level.realtimeengagedist_middle.x = xpos;
		level.realtimeengagedist_middle.y = 250;
		level.realtimeengagedist_middle.color = (1, 1, 1);
		level.realtimeengagedist_middle settext("");
		xpos = xpos + 105;
		level.realtimeengagedist_offvalue = newclienthudelem(player);
		level.realtimeengagedist_offvalue.alignx = "";
		level.realtimeengagedist_offvalue.fontscale = 1.5;
		level.realtimeengagedist_offvalue.x = xpos;
		level.realtimeengagedist_offvalue.y = 250;
		level.realtimeengagedist_offvalue.color = (1, 1, 1);
		level.realtimeengagedist_offvalue setvalue(0);
		hudobjarray = [];
		hudobjarray[0] = level.realtimeengagedist;
		hudobjarray[1] = level.realtimeengagedist_value;
		hudobjarray[2] = level.realtimeengagedist_middle;
		hudobjarray[3] = level.realtimeengagedist_offvalue;
		return hudobjarray;
	#/
}

/*
	Name: engage_dist_debug_hud_destroy
	Namespace: debug
	Checksum: 0x64CE37D8
	Offset: 0x6990
	Size: 0x66
	Parameters: 2
	Flags: Linked
*/
function engage_dist_debug_hud_destroy(hudarray, killnotify)
{
	/#
		level waittill(killnotify);
		for(i = 0; i < hudarray.size; i++)
		{
			hudarray[i] destroy();
		}
	#/
}

/*
	Name: weapon_engage_dists_init
	Namespace: debug
	Checksum: 0x1532F400
	Offset: 0x6A00
	Size: 0x35C
	Parameters: 0
	Flags: Linked
*/
function weapon_engage_dists_init()
{
	/#
		level.engagedists = [];
		genericpistol = spawnstruct();
		genericpistol.engagedistmin = 125;
		genericpistol.engagedistoptimal = 400;
		genericpistol.engagedistmulligan = 100;
		genericpistol.engagedistmax = 600;
		shotty = spawnstruct();
		shotty.engagedistmin = 0;
		shotty.engagedistoptimal = 300;
		shotty.engagedistmulligan = 100;
		shotty.engagedistmax = 600;
		genericsmg = spawnstruct();
		genericsmg.engagedistmin = 100;
		genericsmg.engagedistoptimal = 500;
		genericsmg.engagedistmulligan = 150;
		genericsmg.engagedistmax = 1000;
		genericriflesa = spawnstruct();
		genericriflesa.engagedistmin = 325;
		genericriflesa.engagedistoptimal = 800;
		genericriflesa.engagedistmulligan = 300;
		genericriflesa.engagedistmax = 1600;
		generichmg = spawnstruct();
		generichmg.engagedistmin = 500;
		generichmg.engagedistoptimal = 700;
		generichmg.engagedistmulligan = 300;
		generichmg.engagedistmax = 1400;
		genericsniper = spawnstruct();
		genericsniper.engagedistmin = 950;
		genericsniper.engagedistoptimal = 2000;
		genericsniper.engagedistmulligan = 500;
		genericsniper.engagedistmax = 3000;
		engage_dists_add("", genericpistol);
		engage_dists_add("", genericsmg);
		engage_dists_add("", shotty);
		engage_dists_add("", generichmg);
		engage_dists_add("", genericriflesa);
		level thread engage_dists_watcher();
	#/
}

/*
	Name: engage_dists_add
	Namespace: debug
	Checksum: 0x7B928B11
	Offset: 0x6D68
	Size: 0x2A
	Parameters: 2
	Flags: Linked
*/
function engage_dists_add(weaponname, values)
{
	/#
		level.engagedists[weaponname] = values;
	#/
}

/*
	Name: get_engage_dists
	Namespace: debug
	Checksum: 0x56C43DE2
	Offset: 0x6DA0
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function get_engage_dists(weapon)
{
	/#
		if(isdefined(level.engagedists[weapon]))
		{
			return level.engagedists[weapon];
		}
		return undefined;
	#/
}

/*
	Name: engage_dists_watcher
	Namespace: debug
	Checksum: 0xEB02A8AD
	Offset: 0x6DE8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function engage_dists_watcher()
{
	/#
		level endon(#"kill_all_engage_dist_debug");
		level endon(#"kill_engage_dists_watcher");
		while(true)
		{
			player = get_playerone();
			playerweapon = player getcurrentweapon();
			if(!isdefined(player.lastweapon))
			{
				player.lastweapon = playerweapon;
			}
			else if(player.lastweapon == playerweapon)
			{
				wait(0.05);
				continue;
			}
			values = get_engage_dists(playerweapon.weapclass);
			if(isdefined(values))
			{
				level.weaponengagedistvalues = values;
			}
			else
			{
				level.weaponengagedistvalues = undefined;
			}
			player.lastweapon = playerweapon;
			wait(0.05);
		}
	#/
}

/*
	Name: debug_realtime_engage_dist
	Namespace: debug
	Checksum: 0x9D0F0847
	Offset: 0x6F18
	Size: 0x450
	Parameters: 0
	Flags: Linked
*/
function debug_realtime_engage_dist()
{
	/#
		level endon(#"kill_all_engage_dist_debug");
		level endon(#"kill_realtime_engagement_distance_debug");
		player = get_playerone();
		hudobjarray = engagement_distance_debug_init(player);
		level thread engage_dist_debug_hud_destroy(hudobjarray, "");
		level.debugrtengagedistcolor = (0, 1, 0);
		while(true)
		{
			lasttracepos = (0, 0, 0);
			direction = player getplayerangles();
			direction_vec = anglestoforward(direction);
			eye = player geteye();
			trace = bullettrace(eye, eye + vectorscale(direction_vec, 10000), 1, player);
			tracepoint = trace[""];
			tracenormal = trace[""];
			tracedist = int(distance(eye, tracepoint));
			if(tracepoint != lasttracepos)
			{
				lasttracepos = tracepoint;
				if(!isdefined(level.weaponengagedistvalues))
				{
					hudobj_changecolor(hudobjarray, (1, 1, 1));
					hudobjarray engagedist_hud_changetext("", tracedist);
				}
				else
				{
					engagedistmin = level.weaponengagedistvalues.engagedistmin;
					engagedistoptimal = level.weaponengagedistvalues.engagedistoptimal;
					engagedistmulligan = level.weaponengagedistvalues.engagedistmulligan;
					engagedistmax = level.weaponengagedistvalues.engagedistmax;
					if(tracedist >= engagedistmin && tracedist <= engagedistmax)
					{
						if(tracedist >= (engagedistoptimal - engagedistmulligan) && tracedist <= (engagedistoptimal + engagedistmulligan))
						{
							hudobjarray engagedist_hud_changetext("", tracedist);
							hudobj_changecolor(hudobjarray, (0, 1, 0));
						}
						else
						{
							hudobjarray engagedist_hud_changetext("", tracedist);
							hudobj_changecolor(hudobjarray, (1, 1, 0));
						}
					}
					else
					{
						if(tracedist < engagedistmin)
						{
							hudobj_changecolor(hudobjarray, (1, 0, 0));
							hudobjarray engagedist_hud_changetext("", tracedist);
						}
						else if(tracedist > engagedistmax)
						{
							hudobj_changecolor(hudobjarray, (1, 0, 0));
							hudobjarray engagedist_hud_changetext("", tracedist);
						}
					}
				}
			}
			thread plot_circle_fortime(1, 5, 0.05, level.debugrtengagedistcolor, tracepoint, tracenormal);
			thread plot_circle_fortime(1, 1, 0.05, level.debugrtengagedistcolor, tracepoint, tracenormal);
			wait(0.05);
		}
	#/
}

/*
	Name: hudobj_changecolor
	Namespace: debug
	Checksum: 0x2B95FE36
	Offset: 0x7370
	Size: 0x92
	Parameters: 2
	Flags: Linked
*/
function hudobj_changecolor(hudobjarray, newcolor)
{
	/#
		for(i = 0; i < hudobjarray.size; i++)
		{
			hudobj = hudobjarray[i];
			if(hudobj.color != newcolor)
			{
				hudobj.color = newcolor;
				level.debugrtengagedistcolor = newcolor;
			}
		}
	#/
}

/*
	Name: engagedist_hud_changetext
	Namespace: debug
	Checksum: 0xE1B5E4E9
	Offset: 0x7410
	Size: 0x2EC
	Parameters: 2
	Flags: Linked
*/
function engagedist_hud_changetext(engagedisttype, units)
{
	/#
		if(!isdefined(level.lastdisttype))
		{
			level.lastdisttype = "";
		}
		if(engagedisttype == "")
		{
			self[1] setvalue(units);
			self[2] settext("");
			self[3].alpha = 0;
		}
		else
		{
			if(engagedisttype == "")
			{
				self[1] setvalue(units);
				self[2] settext("");
				self[3].alpha = 0;
			}
			else
			{
				if(engagedisttype == "")
				{
					amountunder = level.weaponengagedistvalues.engagedistmin - units;
					self[1] setvalue(units);
					self[3] setvalue(amountunder);
					self[3].alpha = 1;
					if(level.lastdisttype != engagedisttype)
					{
						self[2] settext("");
					}
				}
				else
				{
					if(engagedisttype == "")
					{
						amountover = units - level.weaponengagedistvalues.engagedistmax;
						self[1] setvalue(units);
						self[3] setvalue(amountover);
						self[3].alpha = 1;
						if(level.lastdisttype != engagedisttype)
						{
							self[2] settext("");
						}
					}
					else if(engagedisttype == "")
					{
						self[1] setvalue(units);
						self[2] settext("");
						self[3].alpha = 0;
					}
				}
			}
		}
		level.lastdisttype = engagedisttype;
	#/
}

/*
	Name: debug_ai_engage_dist
	Namespace: debug
	Checksum: 0xEFD0CE04
	Offset: 0x7708
	Size: 0x374
	Parameters: 0
	Flags: Linked
*/
function debug_ai_engage_dist()
{
	/#
		level endon(#"kill_all_engage_dist_debug");
		level endon(#"kill_ai_engagement_distance_debug");
		player = get_playerone();
		while(true)
		{
			axis = getaiteamarray("");
			if(isdefined(axis) && axis.size > 0)
			{
				playereye = player geteye();
				for(i = 0; i < axis.size; i++)
				{
					ai = axis[i];
					aieye = ai geteye();
					if(sighttracepassed(playereye, aieye, 0, player) && !isvehicle(ai))
					{
						dist = distance(playereye, aieye);
						drawcolor = (1, 1, 1);
						drawstring = "";
						engagedistmin = ai.engagemindist;
						engagedistfalloffmin = ai.engageminfalloffdist;
						engagedistfalloffmax = ai.engagemaxfalloffdist;
						engagedistmax = ai.engagemaxdist;
						if(dist >= engagedistmin && dist <= engagedistmax)
						{
							drawcolor = (0, 1, 0);
							drawstring = "";
						}
						else
						{
							if(dist < engagedistmin && dist >= engagedistfalloffmin)
							{
								drawcolor = (1, 1, 0);
								drawstring = "";
							}
							else
							{
								if(dist > engagedistmax && dist <= engagedistfalloffmax)
								{
									drawcolor = (1, 1, 0);
									drawstring = "";
								}
								else
								{
									if(dist > engagedistfalloffmax)
									{
										drawcolor = (1, 0, 0);
										drawstring = "";
									}
									else if(dist < engagedistfalloffmin)
									{
										drawcolor = (1, 0, 0);
										drawstring = "";
									}
								}
							}
						}
						scale = dist / 1000;
						print3d(ai.origin + vectorscale((0, 0, 1), 67), (drawstring + "") + dist, drawcolor, 1, scale);
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: bot_count
	Namespace: debug
	Checksum: 0x46DAE5D1
	Offset: 0x7A88
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function bot_count()
{
	/#
		count = 0;
		foreach(player in level.players)
		{
			if(player istestclient())
			{
				count++;
			}
		}
		return count;
	#/
}

/*
	Name: function_6a200458
	Namespace: debug
	Checksum: 0x1F218DC0
	Offset: 0x7B40
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function function_6a200458()
{
	/#
		count = 0;
		foreach(player in level.players)
		{
			if(!player istestclient())
			{
				count++;
			}
		}
		return count;
	#/
}

/*
	Name: debug_coop_bot_test
	Namespace: debug
	Checksum: 0xD85D2E23
	Offset: 0x7BF8
	Size: 0x29A
	Parameters: 0
	Flags: Linked
*/
function debug_coop_bot_test()
{
	/#
		adddebugcommand("");
		while(!isdefined(level.players))
		{
			wait(0.5);
		}
		var_d49b0ff = 0;
		while(true)
		{
			if(getdvarint("") > 0)
			{
				while(getdvarint("") > 0)
				{
					var_7e4baf07 = 4 - function_6a200458();
					botcount = bot_count();
					if(botcount > 0 && randomint(100) > 60)
					{
						util::add_queued_debug_command("");
						wait(2);
						debugmsg("" + bot_count());
					}
					else if(botcount < var_7e4baf07)
					{
						if(botcount < getdvarint("") && randomint(100) > 50)
						{
							var_d49b0ff = 1;
							util::add_queued_debug_command("");
							wait(2);
							debugmsg("" + bot_count());
						}
					}
					wait(randomintrange(1, 3));
				}
			}
			else if(var_d49b0ff)
			{
				while(bot_count() > 0)
				{
					util::add_queued_debug_command("");
					wait(2);
					debugmsg("" + bot_count());
				}
				var_d49b0ff = 0;
			}
			wait(1);
		}
	#/
}

/*
	Name: debugmsg
	Namespace: debug
	Checksum: 0x10EC1113
	Offset: 0x7EA0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function debugmsg(str_txt)
{
	/#
		/#
			iprintlnbold(str_txt);
			if(isdefined(level.name))
			{
				println((("" + level.name) + "") + str_txt);
			}
		#/
	#/
}

/*
	Name: plot_circle_fortime
	Namespace: debug
	Checksum: 0x9E05FF1F
	Offset: 0x7F18
	Size: 0x184
	Parameters: 6
	Flags: Linked
*/
function plot_circle_fortime(radius1, radius2, time, color, origin, normal)
{
	/#
		if(!isdefined(color))
		{
			color = (0, 1, 0);
		}
		circleres = 6;
		circleinc = 360 / circleres;
		circleres++;
		plotpoints = [];
		rad = 0;
		radius = radius2;
		angletoplayer = vectortoangles(normal);
		for(i = 0; i < circleres; i++)
		{
			plotpoints[plotpoints.size] = origin + (vectorscale(anglestoforward(angletoplayer + (rad, 90, 0)), radius));
			rad = rad + circleinc;
		}
		plot_points(plotpoints, color[0], color[1], color[2], time);
	#/
}

/*
	Name: dynamic_ai_spawner
	Namespace: debug
	Checksum: 0x5849E1F1
	Offset: 0x80A8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function dynamic_ai_spawner()
{
	/#
		if(!isdefined(level.debug_dynamic_ai_spawner))
		{
			dynamic_ai_spawner_find_spawners();
			level.debug_dynamic_ai_spawner = 1;
		}
		getplayers()[0] thread spawn_guy_placement();
		level waittill(#"hash_d123a0a5");
		if(isdefined(level.dynamic_spawn_hud))
		{
			level.dynamic_spawn_hud destroy();
		}
		if(isdefined(level.dynamic_spawn_dummy_model))
		{
			level.dynamic_spawn_dummy_model delete();
		}
	#/
}

/*
	Name: dynamic_ai_spawner_find_spawners
	Namespace: debug
	Checksum: 0x6710431C
	Offset: 0x8160
	Size: 0x1D8
	Parameters: 0
	Flags: Linked
*/
function dynamic_ai_spawner_find_spawners()
{
	/#
		spawners = getspawnerarray();
		level.aitypes = [];
		level.aitype_index = 0;
		var_7b3173a8 = [];
		foreach(spawner in spawners)
		{
			if(!isdefined(var_7b3173a8[spawner.classname]))
			{
				var_7b3173a8[spawner.classname] = 1;
				struct = spawnstruct();
				classname = spawner.classname;
				vehicletype = spawner.vehicletype;
				if(issubstr(classname, ""))
				{
					struct.radius = 64;
					struct.isvehicle = 0;
					classname = getsubstr(classname, 6);
				}
				else
				{
					continue;
				}
				struct.classname = classname;
				level.aitypes[level.aitypes.size] = struct;
			}
		}
	#/
}

/*
	Name: spawn_guy_placement
	Namespace: debug
	Checksum: 0x91AE4D9F
	Offset: 0x8340
	Size: 0x640
	Parameters: 0
	Flags: Linked
*/
function spawn_guy_placement()
{
	/#
		level endon(#"hash_d123a0a5");
		/#
			assert(isdefined(level.aitypes) && level.aitypes.size > 0, "");
		#/
		level.dynamic_spawn_hud = newclienthudelem(getplayers()[0]);
		level.dynamic_spawn_hud.alignx = "";
		level.dynamic_spawn_hud.x = 0;
		level.dynamic_spawn_hud.y = 245;
		level.dynamic_spawn_hud.fontscale = 1.5;
		level.dynamic_spawn_hud settext("");
		level.dynamic_spawn_dummy_model = spawn("", (0, 0, 0));
		wait(0.1);
		while(true)
		{
			direction = self getplayerangles();
			direction_vec = anglestoforward(direction);
			eye = self geteye();
			trace_dist = 4000;
			trace = bullettrace(eye, eye + vectorscale(direction_vec, trace_dist), 0, level.dynamic_spawn_dummy_model);
			dist = distance(eye, trace[""]);
			position = eye + (vectorscale(direction_vec, dist - level.aitypes[level.aitype_index].radius));
			origin = position;
			angles = self.angles + vectorscale((0, 1, 0), 180);
			level.dynamic_spawn_dummy_model.origin = position;
			level.dynamic_spawn_dummy_model.angles = angles;
			level.dynamic_spawn_hud settext((((("" + level.aitype_index) + "") + level.aitypes.size) + "") + level.aitypes[level.aitype_index].classname);
			level.dynamic_spawn_dummy_model detachall();
			level.dynamic_spawn_dummy_model setmodel(level.aitypes[level.aitype_index].classname);
			level.dynamic_spawn_dummy_model show();
			level.dynamic_spawn_dummy_model notsolid();
			if(self usebuttonpressed())
			{
				level.dynamic_spawn_dummy_model hide();
				if(level.aitypes[level.aitype_index].isvehicle)
				{
					spawn = spawnvehicle(level.aitypes[level.aitype_index].classname, origin, angles, "");
				}
				else
				{
					spawn = spawnactor(level.aitypes[level.aitype_index].classname, origin, angles, "", 1);
				}
				spawn.ignoreme = getdvarstring("") == "";
				spawn.ignoreall = getdvarstring("") == "";
				spawn.pacifist = getdvarstring("") == "";
				spawn.fixednode = 0;
				wait(0.3);
			}
			else
			{
				if(self buttonpressed(""))
				{
					level.dynamic_spawn_dummy_model hide();
					level.aitype_index++;
					if(level.aitype_index >= level.aitypes.size)
					{
						level.aitype_index = 0;
					}
					wait(0.3);
				}
				else
				{
					if(self buttonpressed(""))
					{
						level.dynamic_spawn_dummy_model hide();
						level.aitype_index--;
						if(level.aitype_index < 0)
						{
							level.aitype_index = level.aitypes.size - 1;
						}
						wait(0.3);
					}
					else if(self buttonpressed(""))
					{
						setdvar("", "");
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: display_module_text
	Namespace: debug
	Checksum: 0x535E3DB2
	Offset: 0x8988
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function display_module_text()
{
	/#
		wait(1);
		iprintlnbold(("" + level.script) + "");
	#/
}

/*
	Name: debug_goalradius
	Namespace: debug
	Checksum: 0x6AF5BFD4
	Offset: 0x89D0
	Size: 0x23E
	Parameters: 0
	Flags: Linked
*/
function debug_goalradius()
{
	/#
		guys = getaiarray();
		for(i = 0; i < guys.size; i++)
		{
			if(guys[i].team == "")
			{
				print3d(guys[i].origin + vectorscale((0, 0, 1), 70), (isdefined(guys[i].goalradius) ? "" + guys[i].goalradius : ""), (1, 0, 0), 1, 1, 1);
				record3dtext("" + guys[i].goalradius, guys[i].origin + vectorscale((0, 0, 1), 70), (1, 0, 0), "");
				continue;
			}
			print3d(guys[i].origin + vectorscale((0, 0, 1), 70), (isdefined(guys[i].goalradius) ? "" + guys[i].goalradius : ""), (0, 1, 0), 1, 1, 1);
			record3dtext("" + guys[i].goalradius, guys[i].origin + vectorscale((0, 0, 1), 70), (0, 1, 0), "");
		}
	#/
}

/*
	Name: debug_maxvisibledist
	Namespace: debug
	Checksum: 0x54771798
	Offset: 0x8C18
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function debug_maxvisibledist()
{
	/#
		guys = getaiarray();
		for(i = 0; i < guys.size; i++)
		{
			recordenttext((isdefined(guys[i].maxvisibledist) ? "" + guys[i].maxvisibledist : ""), guys[i], level.debugteamcolors[guys[i].team], "");
		}
		recordenttext((isdefined(level.player.maxvisibledist) ? "" + level.player.maxvisibledist : ""), level.player, level.debugteamcolors[""], "");
	#/
}

/*
	Name: debug_health
	Namespace: debug
	Checksum: 0x7CA263FB
	Offset: 0x8D60
	Size: 0x334
	Parameters: 0
	Flags: Linked
*/
function debug_health()
{
	/#
		v_print_pos = (0, 0, 0);
		guys = getaiarray();
		for(i = 0; i < guys.size; i++)
		{
			if(isdefined(guys[i] gettagorigin("")))
			{
				v_print_pos = guys[i] gettagorigin("") + vectorscale((0, 0, 1), 15);
			}
			else
			{
				v_print_pos = guys[i] getorigin() + vectorscale((0, 0, 1), 70);
			}
			print3d(v_print_pos, (isdefined(guys[i].health) ? "" + guys[i].health : ""), level.debugteamcolors[guys[i].team], 1, 0.5);
			recordenttext((isdefined(guys[i].health) ? "" + guys[i].health : ""), guys[i], level.debugteamcolors[guys[i].team], "");
		}
		vehicles = getvehiclearray();
		for(i = 0; i < vehicles.size; i++)
		{
			recordenttext((isdefined(vehicles[i].health) ? "" + vehicles[i].health : ""), vehicles[i], level.debugteamcolors[vehicles[i].team], "");
		}
		if(isdefined(level.player))
		{
			recordenttext((isdefined(level.player.health) ? "" + level.player.health : ""), level.player, level.debugteamcolors[""], "");
		}
	#/
}

/*
	Name: debug_engagedist
	Namespace: debug
	Checksum: 0x883F4570
	Offset: 0x90A0
	Size: 0x10E
	Parameters: 0
	Flags: Linked
*/
function debug_engagedist()
{
	/#
		guys = getaiarray();
		for(i = 0; i < guys.size; i++)
		{
			diststring = (((((guys[i].engageminfalloffdist + "") + guys[i].engagemindist) + "") + guys[i].engagemaxdist) + "") + guys[i].engagemaxfalloffdist;
			recordenttext(diststring, guys[i], level.debugteamcolors[guys[i].team], "");
		}
	#/
}

/*
	Name: debug_sphere
	Namespace: debug
	Checksum: 0x28EE4120
	Offset: 0x91B8
	Size: 0xCC
	Parameters: 5
	Flags: None
*/
function debug_sphere(origin, radius, color, alpha, time)
{
	/#
		if(!isdefined(time))
		{
			time = 1000;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		sides = int(10 * (1 + (int(radius) % 100)));
		sphere(origin, radius, color, alpha, 1, sides, time);
	#/
}

/*
	Name: draw_arrow_time
	Namespace: debug
	Checksum: 0x51464E28
	Offset: 0x9290
	Size: 0x2B4
	Parameters: 4
	Flags: None
*/
function draw_arrow_time(start, end, color, frames)
{
	/#
		level endon(#"newpath");
		pts = [];
		angles = vectortoangles(start - end);
		right = anglestoright(angles);
		forward = anglestoforward(angles);
		up = anglestoup(angles);
		dist = distance(start, end);
		arrow = [];
		arrow[0] = start;
		arrow[1] = (start + (vectorscale(right, dist * 0.1))) + (vectorscale(forward, dist * -0.1));
		arrow[2] = end;
		arrow[3] = (start + (vectorscale(right, dist * -1 * 0.1))) + (vectorscale(forward, dist * -0.1));
		arrow[4] = start;
		arrow[5] = (start + (vectorscale(up, dist * 0.1))) + (vectorscale(forward, dist * -0.1));
		arrow[6] = end;
		arrow[7] = (start + (vectorscale(up, dist * -1 * 0.1))) + (vectorscale(forward, dist * -0.1));
		arrow[8] = start;
		r = color[0];
		g = color[1];
		b = color[2];
		plot_points(arrow, r, g, b, frames);
	#/
}

/*
	Name: draw_arrow
	Namespace: debug
	Checksum: 0x3D3EA8EB
	Offset: 0x9550
	Size: 0x1FE
	Parameters: 3
	Flags: None
*/
function draw_arrow(start, end, color)
{
	/#
		level endon(#"newpath");
		pts = [];
		angles = vectortoangles(start - end);
		right = anglestoright(angles);
		forward = anglestoforward(angles);
		dist = distance(start, end);
		arrow = [];
		arrow[0] = start;
		arrow[1] = (start + (vectorscale(right, dist * 0.05))) + (vectorscale(forward, dist * -0.2));
		arrow[2] = end;
		arrow[3] = (start + (vectorscale(right, dist * -1 * 0.05))) + (vectorscale(forward, dist * -0.2));
		for(p = 0; p < 4; p++)
		{
			nextpoint = p + 1;
			if(nextpoint >= 4)
			{
				nextpoint = 0;
			}
			line(arrow[p], arrow[nextpoint], color, 1);
		}
	#/
}

/*
	Name: debugorigin
	Namespace: debug
	Checksum: 0xEFD0D5C4
	Offset: 0x9758
	Size: 0x1D0
	Parameters: 0
	Flags: None
*/
function debugorigin()
{
	/#
		self notify(#"hash_707e044");
		self endon(#"hash_707e044");
		self endon(#"death");
		for(;;)
		{
			forward = anglestoforward(self.angles);
			forwardfar = vectorscale(forward, 30);
			forwardclose = vectorscale(forward, 20);
			right = anglestoright(self.angles);
			left = vectorscale(right, -10);
			right = vectorscale(right, 10);
			line(self.origin, self.origin + forwardfar, (0.9, 0.7, 0.6), 0.9);
			line(self.origin + forwardfar, (self.origin + forwardclose) + right, (0.9, 0.7, 0.6), 0.9);
			line(self.origin + forwardfar, (self.origin + forwardclose) + left, (0.9, 0.7, 0.6), 0.9);
			wait(0.05);
		}
	#/
}

/*
	Name: plot_points
	Namespace: debug
	Checksum: 0x7D643086
	Offset: 0x9930
	Size: 0x106
	Parameters: 5
	Flags: Linked
*/
function plot_points(plotpoints, r, g, b, timer)
{
	/#
		lastpoint = plotpoints[0];
		if(!isdefined(r))
		{
			r = 1;
		}
		if(!isdefined(g))
		{
			g = 1;
		}
		if(!isdefined(b))
		{
			b = 1;
		}
		if(!isdefined(timer))
		{
			timer = 0.05;
		}
		for(i = 1; i < plotpoints.size; i++)
		{
			thread draw_line_for_time(lastpoint, plotpoints[i], r, g, b, timer);
			lastpoint = plotpoints[i];
		}
	#/
}

/*
	Name: draw_line_for_time
	Namespace: debug
	Checksum: 0x3ED2C25B
	Offset: 0x9A40
	Size: 0xB8
	Parameters: 6
	Flags: Linked
*/
function draw_line_for_time(org1, org2, r, g, b, timer)
{
	/#
		timer = gettime() + (timer * 1000);
		while(gettime() < timer)
		{
			line(org1, org2, (r, g, b), 1);
			recordline(org1, org2, (1, 1, 1), "");
			wait(0.05);
		}
	#/
}

/*
	Name: _get_debug_color
	Namespace: debug
	Checksum: 0xD41D2234
	Offset: 0x9B00
	Size: 0x11E
	Parameters: 1
	Flags: None
*/
function _get_debug_color(str_color)
{
	/#
		switch(str_color)
		{
			case "":
			{
				return (1, 0, 0);
				break;
			}
			case "":
			{
				return (0, 1, 0);
				break;
			}
			case "":
			{
				return (0, 0, 1);
				break;
			}
			case "":
			{
				return (1, 1, 0);
				break;
			}
			case "":
			{
				return (1, 0.5, 0);
				break;
			}
			case "":
			{
				return (0, 1, 1);
				break;
			}
			case "":
			{
				return (1, 1, 1);
				break;
			}
			case "":
			{
				return vectorscale((1, 1, 1), 0.75);
				break;
			}
			case "":
			{
				return (0, 0, 0);
				break;
			}
			default:
			{
				println(("" + str_color) + "");
				return (0, 0, 0);
				break;
			}
		}
	#/
}

/*
	Name: debug_info_screen
	Namespace: debug
	Checksum: 0x72B39D49
	Offset: 0x9C28
	Size: 0x79A
	Parameters: 8
	Flags: None
*/
function debug_info_screen(text_array, time, fade_in_bg_time, fade_out_bg_time, fade_in_text_time, fade_out_text_time, font_size, show_black_background)
{
	/#
		if(!isdefined(time))
		{
			time = 3;
		}
		if(!isdefined(fade_in_bg_time))
		{
			fade_in_bg_time = 0;
		}
		if(!isdefined(fade_out_bg_time))
		{
			fade_out_bg_time = 2;
		}
		if(!isdefined(fade_in_text_time))
		{
			fade_in_text_time = 2;
		}
		if(!isdefined(fade_out_text_time))
		{
			fade_out_text_time = 2;
		}
		if(!isdefined(font_size))
		{
			font_size = 2;
		}
		if(!isdefined(show_black_background))
		{
			show_black_background = 1;
		}
		if(show_black_background)
		{
			if(isplayer(self))
			{
				background = hud::createicon("", 640, 480);
			}
			else
			{
				background = hud::createservericon("", 640, 480);
			}
			background.horzalign = "";
			background.vertalign = "";
			background.foreground = 1;
			background.sort = 0;
			background.x = 320;
			background.y = 0;
			if(fade_in_bg_time > 0)
			{
				background.alpha = 0;
				background fadeovertime(fade_in_bg_time);
				background.alpha = 1;
				wait(fade_in_bg_time);
			}
			else
			{
				background.alpha = 1;
			}
		}
		text_elems = [];
		spacing = (int(level.fontheight * font_size)) + 2;
		start_y = 0;
		if(isarray(text_array))
		{
			start_y = 0 - ((text_array.size * spacing) / 2);
			foreach(text in text_array)
			{
				if(isplayer(self))
				{
					text_elems[text_elems.size] = hud::createfontstring("", font_size);
				}
				else
				{
					text_elems[text_elems.size] = hud::createserverfontstring("", font_size);
				}
				text_elems[text_elems.size - 1] settext(text);
			}
		}
		else
		{
			if(isplayer(self))
			{
				text_elems[text_elems.size] = hud::createfontstring("", font_size);
			}
			else
			{
				text_elems[text_elems.size] = hud::createserverfontstring("", font_size);
			}
			text_elems[text_elems.size - 1] settext(text);
		}
		text_num = 0;
		foreach(text_elem in text_elems)
		{
			text_elem.horzalign = "";
			text_elem.vertalign = "";
			text_elem.x = 0;
			text_elem.y = start_y + (spacing * text_num);
			text_elem.color = (1, 1, 1);
			text_elem.foreground = 1;
			text_elem.sort = 1;
			if(fade_in_text_time > 0)
			{
				text_elem.alpha = 0;
				text_elem fadeovertime(fade_in_text_time);
				text_elem.alpha = 1;
			}
			else
			{
				text_elem.alpha = 1;
			}
			text_num++;
		}
		if(fade_in_text_time > 0)
		{
			wait(fade_in_text_time);
		}
		wait(time);
		if(fade_out_text_time > 0)
		{
			foreach(text_elem in text_elems)
			{
				text_elem fadeovertime(fade_out_text_time);
				text_elem.alpha = 0;
			}
			wait(fade_out_text_time);
		}
		if(show_black_background)
		{
			if(fade_out_bg_time > 0)
			{
				background fadeovertime(fade_out_bg_time);
				background.alpha = 0;
				wait(fade_out_bg_time);
			}
			background destroy();
		}
		foreach(text_elem in text_elems)
		{
			text_elem destroy();
		}
	#/
}

