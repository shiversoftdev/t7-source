// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\gfx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace duplicate_render_bundle;

/*
	Name: __init__sytem__
	Namespace: duplicate_render_bundle
	Checksum: 0xB03B661A
	Offset: 0x230
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("duplicate_render_bundle", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: duplicate_render_bundle
	Checksum: 0x4FB7160B
	Offset: 0x270
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_localplayer_spawned(&localplayer_duplicate_render_bundle_init);
}

/*
	Name: localplayer_duplicate_render_bundle_init
	Namespace: duplicate_render_bundle
	Checksum: 0x5A01651D
	Offset: 0x2A0
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function localplayer_duplicate_render_bundle_init(localclientnum)
{
	init_duplicate_render_bundles();
}

/*
	Name: init_duplicate_render_bundles
	Namespace: duplicate_render_bundle
	Checksum: 0xBCE53F3F
	Offset: 0x2C8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init_duplicate_render_bundles()
{
	if(isdefined(self.duprenderbundelsinited))
	{
		return;
	}
	self.duprenderbundelsinited = 1;
	self.playingduprenderbundle = "";
	self.forcestopduprenderbundle = 0;
	self.exitduprenderbundle = 0;
	/#
		self thread duprenderbundledebuglisten();
	#/
}

/*
	Name: duprenderbundledebuglisten
	Namespace: duplicate_render_bundle
	Checksum: 0xDF8C00CC
	Offset: 0x338
	Size: 0x1C0
	Parameters: 0
	Flags: Linked
*/
function duprenderbundledebuglisten()
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
				self thread playduprenderbundle(playbundlename);
				setdvar("", "");
			}
			stopbundlename = getdvarstring("");
			if(stopbundlename != "")
			{
				self thread stopduprenderbundle();
				setdvar("", "");
			}
			stopbundlename = getdvarstring("");
			if(stopbundlename != "")
			{
				self thread exitduprenderbundle();
				setdvar("", "");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: playduprenderbundle
	Namespace: duplicate_render_bundle
	Checksum: 0x2CC9B982
	Offset: 0x500
	Size: 0x554
	Parameters: 1
	Flags: Linked
*/
function playduprenderbundle(playbundlename)
{
	self endon(#"entityshutdown");
	init_duplicate_render_bundles();
	stopplayingduprenderbundle();
	bundle = struct::get_script_bundle("duprenderbundle", playbundlename);
	if(!isdefined(bundle))
	{
		/#
			println(("" + playbundlename) + "");
		#/
		return;
	}
	totalaccumtime = 0;
	filter::init_filter_indices();
	self.playingduprenderbundle = playbundlename;
	localclientnum = self.localclientnum;
	looping = 0;
	enterstage = 0;
	exitstage = 0;
	finishlooponexit = 0;
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
	for(stageidx = 0; stageidx < num_stages && !self.forcestopduprenderbundle; stageidx++)
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
			finishplayingduprenderbundle(localclientnum, stageprefix + " length not defined");
			return;
		}
		stagelength = stagelength * 1000;
		adddupmaterial(localclientnum, bundle, stageprefix + "fb_", 0);
		adddupmaterial(localclientnum, bundle, stageprefix + "dupfb_", 1);
		adddupmaterial(localclientnum, bundle, stageprefix + "sonar_", 2);
		loopingstage = looping && (!enterstage && stageidx == 0 || (enterstage && stageidx == 1));
		accumtime = 0;
		prevtime = self getclienttime();
		while(loopingstage || accumtime < stagelength && !self.forcestopduprenderbundle)
		{
			gfx::setstage(localclientnum, bundle, undefined, stageprefix, stagelength, accumtime, totalaccumtime, &setshaderconstants);
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
				if(self.exitduprenderbundle)
				{
					loopingstage = 0;
					if(!finishlooponexit)
					{
						break;
					}
				}
			}
		}
		self disableduplicaterendering();
	}
	finishplayingduprenderbundle(localclientnum, "Finished " + playbundlename);
}

/*
	Name: adddupmaterial
	Namespace: duplicate_render_bundle
	Checksum: 0xF41254A7
	Offset: 0xA60
	Size: 0x1FC
	Parameters: 4
	Flags: Linked
*/
function adddupmaterial(localclientnum, bundle, prefix, type)
{
	method = 0;
	methodstr = getstructfield(bundle, prefix + "method");
	if(isdefined(methodstr))
	{
		switch(methodstr)
		{
			case "off":
			{
				method = 0;
				break;
			}
			case "default material":
			{
				method = 1;
				break;
			}
			case "custom material":
			{
				method = 3;
				break;
			}
			case "force custom material":
			{
				method = 3;
				break;
			}
			case "thermal":
			{
				method = 2;
				break;
			}
			case "enemy material":
			{
				method = 4;
				break;
			}
		}
	}
	materialname = getstructfield(bundle, prefix + "mc_material");
	materialid = -1;
	if(isdefined(materialname) && materialname != "")
	{
		materialname = ("mc/") + materialname;
		materialid = filter::mapped_material_id(materialname);
		if(!isdefined(materialid))
		{
			filter::map_material_helper_by_localclientnum(localclientnum, materialname);
			materialid = filter::mapped_material_id();
			if(!isdefined(materialid))
			{
				materialid = -1;
			}
		}
	}
	self addduplicaterenderoption(type, method, materialid);
}

/*
	Name: setshaderconstants
	Namespace: duplicate_render_bundle
	Checksum: 0x8A82312D
	Offset: 0xC68
	Size: 0x6C
	Parameters: 4
	Flags: Linked
*/
function setshaderconstants(localclientnum, shaderconstantname, filterid, values)
{
	self mapshaderconstant(localclientnum, 0, shaderconstantname, values[0], values[1], values[2], values[3]);
}

/*
	Name: finishplayingduprenderbundle
	Namespace: duplicate_render_bundle
	Checksum: 0x48DA07DE
	Offset: 0xCE0
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function finishplayingduprenderbundle(localclientnum, msg)
{
	/#
		if(isdefined(msg))
		{
			println(msg);
		}
	#/
	self.forcestopduprenderbundle = 0;
	self.exitduprenderbundle = 0;
	self.playingduprenderbundle = "";
}

/*
	Name: stopplayingduprenderbundle
	Namespace: duplicate_render_bundle
	Checksum: 0x9277AC22
	Offset: 0xD50
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function stopplayingduprenderbundle()
{
	if(self.playingduprenderbundle != "")
	{
		stopduprenderbundle();
	}
}

/*
	Name: stopduprenderbundle
	Namespace: duplicate_render_bundle
	Checksum: 0x3BD6C971
	Offset: 0xD88
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function stopduprenderbundle()
{
	if(!(isdefined(self.forcestopduprenderbundle) && self.forcestopduprenderbundle) && isdefined(self.playingduprenderbundle) && self.playingduprenderbundle != "")
	{
		self.forcestopduprenderbundle = 1;
		while(self.playingduprenderbundle != "")
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
	Name: exitduprenderbundle
	Namespace: duplicate_render_bundle
	Checksum: 0x20BE7A97
	Offset: 0xE08
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function exitduprenderbundle()
{
	if(!(isdefined(self.exitduprenderbundle) && self.exitduprenderbundle) && isdefined(self.playingduprenderbundle) && self.playingduprenderbundle != "")
	{
		self.exitduprenderbundle = 1;
	}
}

