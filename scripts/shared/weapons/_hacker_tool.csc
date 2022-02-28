// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_flashgrenades;

#namespace hacker_tool;

/*
	Name: init_shared
	Namespace: hacker_tool
	Checksum: 0xE79BEDD1
	Offset: 0x280
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	clientfield::register("toplayer", "hacker_tool", 1, 2, "int", &player_hacking, 0, 0);
	level.hackingsoundid = [];
	level.hackingsweetspotid = [];
	level.friendlyhackingsoundid = [];
	callback::on_localplayer_spawned(&on_localplayer_spawned);
}

/*
	Name: on_localplayer_spawned
	Namespace: hacker_tool
	Checksum: 0x990620EE
	Offset: 0x320
	Size: 0x100
	Parameters: 1
	Flags: None
*/
function on_localplayer_spawned(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	player = self;
	if(isdefined(level.hackingsoundid[localclientnum]))
	{
		player stoploopsound(level.hackingsoundid[localclientnum]);
		level.hackingsoundid[localclientnum] = undefined;
	}
	if(isdefined(level.hackingsweetspotid[localclientnum]))
	{
		player stoploopsound(level.hackingsweetspotid[localclientnum]);
		level.hackingsweetspotid[localclientnum] = undefined;
	}
	if(isdefined(level.friendlyhackingsoundid[localclientnum]))
	{
		player stoploopsound(level.friendlyhackingsoundid[localclientnum]);
		level.friendlyhackingsoundid[localclientnum] = undefined;
	}
}

/*
	Name: player_hacking
	Namespace: hacker_tool
	Checksum: 0x31D4F09C
	Offset: 0x428
	Size: 0x48C
	Parameters: 7
	Flags: None
*/
function player_hacking(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self notify(#"player_hacking_callback");
	player = self;
	if(isdefined(level.hackingsoundid[localclientnum]))
	{
		player stoploopsound(level.hackingsoundid[localclientnum]);
		level.hackingsoundid[localclientnum] = undefined;
	}
	if(isdefined(level.hackingsweetspotid[localclientnum]))
	{
		player stoploopsound(level.hackingsweetspotid[localclientnum]);
		level.hackingsweetspotid[localclientnum] = undefined;
	}
	if(isdefined(level.friendlyhackingsoundid[localclientnum]))
	{
		player stoploopsound(level.friendlyhackingsoundid[localclientnum]);
		level.friendlyhackingsoundid[localclientnum] = undefined;
	}
	if(isdefined(player.targetent))
	{
		player.targetent duplicate_render::set_hacker_tool_hacking(localclientnum, 0);
		player.targetent duplicate_render::set_hacker_tool_breaching(localclientnum, 0);
		player.targetent.isbreachingfirewall = 0;
		player.targetent = undefined;
	}
	if(newval == 2)
	{
		player thread watchhackspeed(localclientnum, 0);
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.status"), 2);
	}
	else
	{
		if(newval == 3)
		{
			player thread watchhackspeed(localclientnum, 1);
			setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.status"), 1);
		}
		else
		{
			if(newval == 1)
			{
				setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.status"), 0);
				setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.perc"), 0);
				setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.offsetShaderValue"), ((0 + " ") + 0) + " 0 0");
				self thread watchforemp(localclientnum);
			}
			else
			{
				setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.status"), 0);
				setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.perc"), 0);
				setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.offsetShaderValue"), ((0 + " ") + 0) + " 0 0");
			}
		}
	}
}

/*
	Name: watchhackspeed
	Namespace: hacker_tool
	Checksum: 0x1DFBB7D3
	Offset: 0x8C0
	Size: 0xAC
	Parameters: 2
	Flags: None
*/
function watchhackspeed(localclientnum, isbreachingfirewall)
{
	self endon(#"entityshutdown");
	self endon(#"player_hacking_callback");
	player = self;
	for(;;)
	{
		targetentarray = self gettargetlockentityarray();
		if(targetentarray.size > 0)
		{
			targetent = targetentarray[0];
			break;
		}
		wait(0.02);
	}
	targetent watchtargethack(localclientnum, player, isbreachingfirewall);
}

/*
	Name: watchtargethack
	Namespace: hacker_tool
	Checksum: 0xCC654700
	Offset: 0x978
	Size: 0x42C
	Parameters: 3
	Flags: None
*/
function watchtargethack(localclientnum, player, isbreachingfirewall)
{
	self endon(#"entityshutdown");
	player endon(#"entityshutdown");
	self endon(#"player_hacking_callback");
	targetent = self;
	player.targetent = targetent;
	if(isbreachingfirewall)
	{
		targetent.isbreachingfirewall = 1;
		targetent duplicate_render::set_hacker_tool_breaching(localclientnum, 1);
	}
	targetent thread watchhackerplayershutdown(localclientnum, player, targetent);
	for(;;)
	{
		distancefromcenter = targetent getdistancefromscreencenter(localclientnum);
		inverse = 40 - distancefromcenter;
		ratio = inverse / 40;
		heatval = getweaponhackratio(localclientnum);
		ratio = ((ratio * ratio) * ratio) * ratio;
		if(ratio > 1 || ratio < 0.001)
		{
			ratio = 0;
			horizontal = 0;
		}
		else
		{
			horizontal = targetent gethorizontaloffsetfromscreencenter(localclientnum, 40);
		}
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.offsetShaderValue"), ((horizontal + " ") + ratio) + " 0 0");
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.perc"), heatval);
		if(ratio > 0.8)
		{
			if(!isdefined(level.hackingsweetspotid[localclientnum]))
			{
				level.hackingsweetspotid[localclientnum] = player playloopsound("evt_hacker_hacking_sweet");
			}
		}
		else
		{
			if(isdefined(level.hackingsweetspotid[localclientnum]))
			{
				player stoploopsound(level.hackingsweetspotid[localclientnum]);
				level.hackingsweetspotid[localclientnum] = undefined;
			}
			if(!isdefined(level.hackingsoundid[localclientnum]))
			{
				level.hackingsoundid[localclientnum] = player playloopsound("evt_hacker_hacking_loop");
			}
			if(isdefined(level.hackingsoundid[localclientnum]))
			{
				setsoundpitch(level.hackingsoundid[localclientnum], ratio);
			}
		}
		if(!isbreachingfirewall)
		{
			friendlyhacking = weaponfriendlyhacking(localclientnum);
			if(friendlyhacking && !isdefined(level.friendlyhackingsoundid[localclientnum]))
			{
				level.friendlyhackingsoundid[localclientnum] = player playloopsound("evt_hacker_hacking_loop_mult");
			}
			else if(!friendlyhacking && isdefined(level.friendlyhackingsoundid[localclientnum]))
			{
				player stoploopsound(level.friendlyhackingsoundid[localclientnum]);
				level.friendlyhackingsoundid[localclientnum] = undefined;
			}
		}
		wait(0.1);
	}
}

/*
	Name: watchhackerplayershutdown
	Namespace: hacker_tool
	Checksum: 0xEF93BB3E
	Offset: 0xDB0
	Size: 0xAC
	Parameters: 3
	Flags: None
*/
function watchhackerplayershutdown(localclientnum, hackerplayer, targetent)
{
	self endon(#"entityshutdown");
	killstreakentity = self;
	hackerplayer endon(#"player_hacking_callback");
	hackerplayer waittill(#"entityshutdown");
	if(isdefined(targetent))
	{
		targetent.isbreachingfirewall = 1;
	}
	killstreakentity duplicate_render::set_hacker_tool_hacking(localclientnum, 0);
	killstreakentity duplicate_render::set_hacker_tool_breaching(localclientnum, 0);
}

/*
	Name: watchforemp
	Namespace: hacker_tool
	Checksum: 0x79EDE318
	Offset: 0xE68
	Size: 0xD8
	Parameters: 1
	Flags: None
*/
function watchforemp(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"player_hacking_callback");
	while(true)
	{
		if(self isempjammed())
		{
			setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.status"), 3);
		}
		else
		{
			setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "hudItems.blackhat.status"), 0);
		}
		wait(0.1);
	}
}

