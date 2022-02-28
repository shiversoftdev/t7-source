// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_shoutcaster;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\util_shared;

#namespace escort;

/*
	Name: main
	Namespace: escort
	Checksum: 0x4A18A0AF
	Offset: 0x1E8
	Size: 0xB4
	Parameters: 0
	Flags: None
*/
function main()
{
	clientfield::register("actor", "robot_state", 1, 2, "int", &robot_state_changed, 0, 1);
	clientfield::register("actor", "escort_robot_burn", 1, 1, "int", &robot_burn, 0, 0);
	callback::on_localclient_connect(&on_localclient_connect);
}

/*
	Name: onprecachegametype
	Namespace: escort
	Checksum: 0x99EC1590
	Offset: 0x2A8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onprecachegametype()
{
}

/*
	Name: onstartgametype
	Namespace: escort
	Checksum: 0x99EC1590
	Offset: 0x2B8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
}

/*
	Name: on_localclient_connect
	Namespace: escort
	Checksum: 0x203DE21B
	Offset: 0x2C8
	Size: 0xFC
	Parameters: 1
	Flags: None
*/
function on_localclient_connect(localclientnum)
{
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "escortGametype.robotStatusText"), &"MPUI_ESCORT_ROBOT_MOVING");
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "escortGametype.robotStatusVisible"), 0);
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "escortGametype.enemyRobot"), 0);
	level wait_team_changed(localclientnum);
}

/*
	Name: robot_burn
	Namespace: escort
	Checksum: 0x63DF61A
	Offset: 0x3D0
	Size: 0xAC
	Parameters: 7
	Flags: None
*/
function robot_burn(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self endon(#"entityshutdown");
		self util::waittill_dobj(localclientnum);
		fxhandles = playtagfxset(localclientnum, "escort_robot_burn", self);
		self thread watch_fx_shutdown(localclientnum, fxhandles);
	}
}

/*
	Name: watch_fx_shutdown
	Namespace: escort
	Checksum: 0x9051C6A4
	Offset: 0x488
	Size: 0xA2
	Parameters: 2
	Flags: None
*/
function watch_fx_shutdown(localclientnum, fxhandles)
{
	wait(3);
	foreach(fx in fxhandles)
	{
		stopfx(localclientnum, fx);
	}
}

/*
	Name: robot_state_changed
	Namespace: escort
	Checksum: 0x3E883ADE
	Offset: 0x538
	Size: 0x16C
	Parameters: 7
	Flags: None
*/
function robot_state_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(bnewent)
	{
		if(!isdefined(level.escortrobots))
		{
			level.escortrobots = [];
		}
		else if(!isarray(level.escortrobots))
		{
			level.escortrobots = array(level.escortrobots);
		}
		level.escortrobots[level.escortrobots.size] = self;
		self thread update_robot_team(localclientnum);
	}
	if(newval == 1)
	{
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "escortGametype.robotStatusVisible"), 1);
	}
	else
	{
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "escortGametype.robotStatusVisible"), 0);
	}
}

/*
	Name: wait_team_changed
	Namespace: escort
	Checksum: 0x7749F2D1
	Offset: 0x6B0
	Size: 0xE6
	Parameters: 1
	Flags: None
*/
function wait_team_changed(localclientnum)
{
	while(true)
	{
		level waittill(#"team_changed");
		while(!isdefined(getnonpredictedlocalplayer(localclientnum)))
		{
			wait(0.05);
		}
		if(!isdefined(level.escortrobots))
		{
			continue;
		}
		foreach(robot in level.escortrobots)
		{
			robot thread update_robot_team(localclientnum);
		}
	}
}

/*
	Name: update_robot_team
	Namespace: escort
	Checksum: 0x14BF9D2F
	Offset: 0x7A0
	Size: 0x174
	Parameters: 1
	Flags: None
*/
function update_robot_team(localclientnum)
{
	localplayerteam = getlocalplayerteam(localclientnum);
	if(shoutcaster::is_shoutcaster(localclientnum))
	{
		friend = self shoutcaster::is_friendly(localclientnum);
	}
	else
	{
		friend = self.team == localplayerteam;
	}
	if(friend)
	{
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "escortGametype.enemyRobot"), 0);
	}
	else
	{
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "escortGametype.enemyRobot"), 1);
	}
	self duplicate_render::set_dr_flag("enemyvehicle_fb", !friend);
	localplayer = getlocalplayer(localclientnum);
	localplayer duplicate_render::update_dr_filters(localclientnum);
}

