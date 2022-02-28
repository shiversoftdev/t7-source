// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace dom;

/*
	Name: main
	Namespace: dom
	Checksum: 0x5B43CA31
	Offset: 0x1A0
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function main()
{
	callback::on_localclient_connect(&on_localclient_connect);
	if(getgametypesetting("silentPlant") != 0)
	{
		setsoundcontext("bomb_plant", "silent");
	}
}

/*
	Name: on_localclient_connect
	Namespace: dom
	Checksum: 0xD6B9AED7
	Offset: 0x210
	Size: 0x15A
	Parameters: 1
	Flags: None
*/
function on_localclient_connect(localclientnum)
{
	self.domflags = [];
	while(!isdefined(level.domflags["a"]))
	{
		self.domflags["a"] = serverobjective_getobjective(localclientnum, "dom_a");
		self.domflags["b"] = serverobjective_getobjective(localclientnum, "dom_b");
		self.domflags["c"] = serverobjective_getobjective(localclientnum, "dom_c");
		wait(0.05);
	}
	foreach(key, flag_objective in self.domflags)
	{
		self thread monitor_flag_fx(localclientnum, flag_objective, key);
	}
}

/*
	Name: monitor_flag_fx
	Namespace: dom
	Checksum: 0xC9411D12
	Offset: 0x378
	Size: 0x248
	Parameters: 3
	Flags: None
*/
function monitor_flag_fx(localclientnum, flag_objective, flag_name)
{
	if(!isdefined(flag_objective))
	{
		return;
	}
	flag = spawnstruct();
	flag.name = flag_name;
	flag.objectiveid = flag_objective;
	flag.origin = serverobjective_getobjectiveorigin(localclientnum, flag_objective);
	flag.angles = (0, 0, 0);
	flag_entity = serverobjective_getobjectiveentity(localclientnum, flag_objective);
	if(isdefined(flag_entity))
	{
		flag.origin = flag_entity.origin;
		flag.angles = flag_entity.angles;
	}
	fx_name = get_base_fx(flag, "neutral");
	play_base_fx(localclientnum, flag, fx_name, "neutral");
	flag.last_progress = 0;
	while(true)
	{
		team = serverobjective_getobjectiveteam(localclientnum, flag_objective);
		if(team != flag.last_team)
		{
			flag update_base_fx(localclientnum, flag, team);
		}
		progress = serverobjective_getobjectiveprogress(localclientnum, flag_objective) > 0;
		if(progress != flag.last_progress)
		{
			flag update_cap_fx(localclientnum, flag, team, progress);
		}
		wait(0.05);
	}
}

/*
	Name: play_base_fx
	Namespace: dom
	Checksum: 0x81B02CC4
	Offset: 0x5C8
	Size: 0x120
	Parameters: 4
	Flags: None
*/
function play_base_fx(localclientnum, flag, fx_name, team)
{
	if(isdefined(flag.base_fx))
	{
		stopfx(localclientnum, flag.base_fx);
	}
	up = anglestoup(flag.angles);
	forward = anglestoforward(flag.angles);
	flag.base_fx = playfx(localclientnum, fx_name, flag.origin, up, forward);
	setfxteam(localclientnum, flag.base_fx, team);
	flag.last_team = team;
}

/*
	Name: update_base_fx
	Namespace: dom
	Checksum: 0xBB292040
	Offset: 0x6F0
	Size: 0xF0
	Parameters: 3
	Flags: None
*/
function update_base_fx(localclientnum, flag, team)
{
	fx_name = get_base_fx(flag, team);
	if(team == "neutral")
	{
		play_base_fx(localclientnum, flag, fx_name, team);
	}
	else
	{
		if(flag.last_team == "neutral")
		{
			play_base_fx(localclientnum, flag, fx_name, team);
		}
		else
		{
			setfxteam(localclientnum, flag.base_fx, team);
			flag.last_team = team;
		}
	}
}

/*
	Name: play_cap_fx
	Namespace: dom
	Checksum: 0xC243E3
	Offset: 0x7E8
	Size: 0x10C
	Parameters: 4
	Flags: None
*/
function play_cap_fx(localclientnum, flag, fx_name, team)
{
	if(isdefined(flag.cap_fx))
	{
		killfx(localclientnum, flag.cap_fx);
	}
	up = anglestoup(flag.angles);
	forward = anglestoforward(flag.angles);
	flag.cap_fx = playfx(localclientnum, fx_name, flag.origin, up, forward);
	setfxteam(localclientnum, flag.cap_fx, team);
}

/*
	Name: update_cap_fx
	Namespace: dom
	Checksum: 0xE9305646
	Offset: 0x900
	Size: 0xD8
	Parameters: 4
	Flags: None
*/
function update_cap_fx(localclientnum, flag, team, progress)
{
	if(progress == 0)
	{
		if(isdefined(flag.cap_fx))
		{
			killfx(localclientnum, flag.cap_fx);
		}
		flag.last_progress = progress;
		return;
	}
	fx_name = get_cap_fx(flag, team);
	play_cap_fx(localclientnum, flag, fx_name, team);
	flag.last_progress = progress;
}

/*
	Name: get_base_fx
	Namespace: dom
	Checksum: 0x88B58279
	Offset: 0x9E0
	Size: 0x76
	Parameters: 2
	Flags: None
*/
function get_base_fx(flag, team)
{
	if(isdefined(level.domflagbasefxoverride))
	{
		fx = [[level.domflagbasefxoverride]](flag, team);
		if(isdefined(fx))
		{
			return fx;
		}
	}
	if(team == "neutral")
	{
		return "ui/fx_dom_marker_neutral";
	}
	return "ui/fx_dom_marker_team";
}

/*
	Name: get_cap_fx
	Namespace: dom
	Checksum: 0xF222362E
	Offset: 0xA60
	Size: 0x76
	Parameters: 2
	Flags: None
*/
function get_cap_fx(flag, team)
{
	if(isdefined(level.domflagcapfxoverride))
	{
		fx = [[level.domflagcapfxoverride]](flag, team);
		if(isdefined(fx))
		{
			return fx;
		}
	}
	if(team == "neutral")
	{
		return "ui/fx_dom_cap_indicator_neutral";
	}
	return "ui/fx_dom_cap_indicator_team";
}

