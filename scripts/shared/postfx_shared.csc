// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\duplicaterenderbundle;
#using scripts\shared\filter_shared;
#using scripts\shared\gfx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace postfx;

/*
	Name: __init__sytem__
	Namespace: postfx
	Checksum: 0x228DCDFC
	Offset: 0x248
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("postfx_bundle", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: postfx
	Checksum: 0xB149BFC0
	Offset: 0x288
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_localplayer_spawned(&localplayer_postfx_bundle_init);
}

/*
	Name: localplayer_postfx_bundle_init
	Namespace: postfx
	Checksum: 0xDC4EFC84
	Offset: 0x2B8
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function localplayer_postfx_bundle_init(localclientnum)
{
	init_postfx_bundles();
}

/*
	Name: init_postfx_bundles
	Namespace: postfx
	Checksum: 0x6938A182
	Offset: 0x2E0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init_postfx_bundles()
{
	if(isdefined(self.postfxbundelsinited))
	{
		return;
	}
	self.postfxbundelsinited = 1;
	self.playingpostfxbundle = "";
	self.forcestoppostfxbundle = 0;
	self.exitpostfxbundle = 0;
	/#
		self thread postfxbundledebuglisten();
	#/
}

/*
	Name: postfxbundledebuglisten
	Namespace: postfx
	Checksum: 0x8D0A5480
	Offset: 0x350
	Size: 0x1C0
	Parameters: 0
	Flags: Linked
*/
function postfxbundledebuglisten()
{
	/#
		self endon(#"entityshutdown");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		while(true)
		{
			playbundlename = getdvarstring("");
			if(playbundlename != "")
			{
				self thread playpostfxbundle(playbundlename);
				setdvar("", "");
			}
			stopbundlename = getdvarstring("");
			if(stopbundlename != "")
			{
				self thread stoppostfxbundle();
				setdvar("", "");
			}
			stopbundlename = getdvarstring("");
			if(stopbundlename != "")
			{
				self thread exitpostfxbundle();
				setdvar("", "");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: playpostfxbundle
	Namespace: postfx
	Checksum: 0x50299743
	Offset: 0x518
	Size: 0x8B4
	Parameters: 1
	Flags: Linked
*/
function playpostfxbundle(playbundlename)
{
	self endon(#"entityshutdown");
	self endon(#"death");
	init_postfx_bundles();
	stopplayingpostfxbundle();
	bundle = struct::get_script_bundle("postfxbundle", playbundlename);
	if(!isdefined(bundle))
	{
		/#
			println(("" + playbundlename) + "");
		#/
		return;
	}
	filterid = 0;
	totalaccumtime = 0;
	filter::init_filter_indices();
	self.playingpostfxbundle = playbundlename;
	localclientnum = self.localclientnum;
	looping = 0;
	enterstage = 0;
	exitstage = 0;
	finishlooponexit = 0;
	firstpersononly = 0;
	if(isdefined(bundle.looping))
	{
		looping = bundle.looping;
	}
	if(isdefined(bundle.enterstage))
	{
		enterstage = bundle.enterstage;
	}
	if(isdefined(bundle.exitstage))
	{
		exitstage = bundle.exitstage;
	}
	if(isdefined(bundle.finishlooponexit))
	{
		finishlooponexit = bundle.finishlooponexit;
	}
	if(isdefined(bundle.firstpersononly))
	{
		firstpersononly = bundle.firstpersononly;
	}
	if(looping)
	{
		num_stages = 1;
		if(enterstage)
		{
			num_stages++;
		}
		if(exitstage)
		{
			num_stages++;
		}
	}
	else
	{
		num_stages = bundle.num_stages;
	}
	self.captureimagename = undefined;
	if(isdefined(bundle.screencapture) && bundle.screencapture)
	{
		self.captureimagename = playbundlename;
		createscenecodeimage(localclientnum, self.captureimagename);
		captureframe(localclientnum, self.captureimagename);
		setfilterpasscodetexture(localclientnum, filterid, 0, 0, self.captureimagename);
	}
	self thread watchentityshutdown(localclientnum, filterid);
	for(stageidx = 0; stageidx < num_stages && !self.forcestoppostfxbundle; stageidx++)
	{
		stageprefix = "s";
		if(stageidx < 10)
		{
			stageprefix = stageprefix + "0";
		}
		stageprefix = stageprefix + (stageidx + "_");
		stagelength = getstructfield(bundle, stageprefix + "length");
		if(!isdefined(stagelength))
		{
			finishplayingpostfxbundle(localclientnum, stageprefix + "length not defined", filterid);
			return;
		}
		stagelength = stagelength * 1000;
		stagematerial = getstructfield(bundle, stageprefix + "material");
		if(!isdefined(stagematerial))
		{
			finishplayingpostfxbundle(localclientnum, stageprefix + "material not defined", filterid);
			return;
		}
		filter::map_material_helper(self, stagematerial);
		setfilterpassmaterial(localclientnum, filterid, 0, filter::mapped_material_id(stagematerial));
		setfilterpassenabled(localclientnum, filterid, 0, 1, 0, firstpersononly);
		stagecapture = getstructfield(bundle, stageprefix + "screenCapture");
		if(isdefined(stagecapture) && stagecapture)
		{
			if(isdefined(self.captureimagename))
			{
				freecodeimage(localclientnum, self.captureimagename);
				self.captureimagename = undefined;
				setfilterpasscodetexture(localclientnum, filterid, 0, 0, "");
			}
			self.captureimagename = stageprefix + playbundlename;
			createscenecodeimage(localclientnum, self.captureimagename);
			captureframe(localclientnum, self.captureimagename);
			setfilterpasscodetexture(localclientnum, filterid, 0, 0, self.captureimagename);
		}
		stagesprite = getstructfield(bundle, stageprefix + "spriteFilter");
		if(isdefined(stagesprite) && stagesprite)
		{
			setfilterpassquads(localclientnum, filterid, 0, 2048);
		}
		else
		{
			setfilterpassquads(localclientnum, filterid, 0, 0);
		}
		thermal = getstructfield(bundle, stageprefix + "thermal");
		enablethermaldraw(localclientnum, isdefined(thermal) && thermal);
		loopingstage = looping && (!enterstage && stageidx == 0 || (enterstage && stageidx == 1));
		accumtime = 0;
		prevtime = self getclienttime();
		while(loopingstage || accumtime < stagelength && !self.forcestoppostfxbundle)
		{
			gfx::setstage(localclientnum, bundle, filterid, stageprefix, stagelength, accumtime, totalaccumtime, &setfilterconstants);
			wait(0.016);
			currtime = self getclienttime();
			deltatime = currtime - prevtime;
			accumtime = accumtime + deltatime;
			totalaccumtime = totalaccumtime + deltatime;
			prevtime = currtime;
			if(loopingstage)
			{
				while(accumtime >= stagelength)
				{
					accumtime = accumtime - stagelength;
				}
				if(self.exitpostfxbundle)
				{
					loopingstage = 0;
					if(!finishlooponexit)
					{
						break;
					}
				}
			}
		}
		setfilterpassenabled(localclientnum, filterid, 0, 0);
	}
	finishplayingpostfxbundle(localclientnum, "Finished " + playbundlename, filterid);
}

/*
	Name: watchentityshutdown
	Namespace: postfx
	Checksum: 0xEECF8868
	Offset: 0xDD8
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function watchentityshutdown(localclientnum, filterid)
{
	self util::waittill_any("entityshutdown", "death", "finished_playing_postfx_bundle");
	finishplayingpostfxbundle(localclientnum, "Entity Shutdown", filterid);
}

/*
	Name: setfilterconstants
	Namespace: postfx
	Checksum: 0xC9879422
	Offset: 0xE48
	Size: 0x104
	Parameters: 4
	Flags: Linked
*/
function setfilterconstants(localclientnum, shaderconstantname, filterid, values)
{
	baseshaderconstindex = gfx::getshaderconstantindex(shaderconstantname);
	setfilterpassconstant(localclientnum, filterid, 0, baseshaderconstindex + 0, values[0]);
	setfilterpassconstant(localclientnum, filterid, 0, baseshaderconstindex + 1, values[1]);
	setfilterpassconstant(localclientnum, filterid, 0, baseshaderconstindex + 2, values[2]);
	setfilterpassconstant(localclientnum, filterid, 0, baseshaderconstindex + 3, values[3]);
}

/*
	Name: finishplayingpostfxbundle
	Namespace: postfx
	Checksum: 0x4D9B9B49
	Offset: 0xF58
	Size: 0x12E
	Parameters: 3
	Flags: Linked
*/
function finishplayingpostfxbundle(localclientnum, msg, filterid)
{
	/#
		if(isdefined(msg))
		{
			println(msg);
		}
	#/
	if(isdefined(self))
	{
		self notify(#"finished_playing_postfx_bundle");
		self.forcestoppostfxbundle = 0;
		self.exitpostfxbundle = 0;
		self.playingpostfxbundle = "";
	}
	setfilterpassquads(localclientnum, filterid, 0, 0);
	setfilterpassenabled(localclientnum, filterid, 0, 0);
	enablethermaldraw(localclientnum, 0);
	if(isdefined(self.captureimagename))
	{
		setfilterpasscodetexture(localclientnum, filterid, 0, 0, "");
		freecodeimage(localclientnum, self.captureimagename);
		self.captureimagename = undefined;
	}
}

/*
	Name: stopplayingpostfxbundle
	Namespace: postfx
	Checksum: 0x83107AC0
	Offset: 0x1090
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function stopplayingpostfxbundle()
{
	if(self.playingpostfxbundle != "")
	{
		stoppostfxbundle();
	}
}

/*
	Name: stoppostfxbundle
	Namespace: postfx
	Checksum: 0xA81D07EE
	Offset: 0x10C8
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function stoppostfxbundle()
{
	self notify(#"stoppostfxbundle_singleton");
	self endon(#"stoppostfxbundle_singleton");
	if(isdefined(self.playingpostfxbundle) && self.playingpostfxbundle != "")
	{
		self.forcestoppostfxbundle = 1;
		while(self.playingpostfxbundle != "")
		{
			wait(0.016);
			if(!isdefined(self))
			{
				return;
			}
		}
	}
}

/*
	Name: exitpostfxbundle
	Namespace: postfx
	Checksum: 0xC55314BB
	Offset: 0x1148
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function exitpostfxbundle()
{
	if(!(isdefined(self.exitpostfxbundle) && self.exitpostfxbundle) && isdefined(self.playingpostfxbundle) && self.playingpostfxbundle != "")
	{
		self.exitpostfxbundle = 1;
	}
}

/*
	Name: setfrontendstreamingoverlay
	Namespace: postfx
	Checksum: 0x910F2A31
	Offset: 0x1198
	Size: 0x124
	Parameters: 3
	Flags: Linked
*/
function setfrontendstreamingoverlay(localclientnum, system, enabled)
{
	if(!isdefined(self.overlayclients))
	{
		self.overlayclients = [];
	}
	if(!isdefined(self.overlayclients[localclientnum]))
	{
		self.overlayclients[localclientnum] = [];
	}
	self.overlayclients[localclientnum][system] = enabled;
	foreach(en in self.overlayclients[localclientnum])
	{
		if(en)
		{
			enablefrontendstreamingoverlay(localclientnum, 1);
			return;
		}
	}
	enablefrontendstreamingoverlay(localclientnum, 0);
}

