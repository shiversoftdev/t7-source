// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;

#namespace shoutcaster;

/*
	Name: is_shoutcaster
	Namespace: shoutcaster
	Checksum: 0xE25C96A6
	Offset: 0x128
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function is_shoutcaster(localclientnum)
{
	return isshoutcaster(localclientnum);
}

/*
	Name: is_shoutcaster_using_team_identity
	Namespace: shoutcaster
	Checksum: 0x66308F95
	Offset: 0x158
	Size: 0x42
	Parameters: 1
	Flags: None
*/
function is_shoutcaster_using_team_identity(localclientnum)
{
	return is_shoutcaster(localclientnum) && getshoutcastersetting(localclientnum, "shoutcaster_team_identity");
}

/*
	Name: get_team_color_id
	Namespace: shoutcaster
	Checksum: 0x33BE1AAE
	Offset: 0x1A8
	Size: 0x62
	Parameters: 2
	Flags: None
*/
function get_team_color_id(localclientnum, team)
{
	if(team == "allies")
	{
		return getshoutcastersetting(localclientnum, "shoutcaster_fe_team1_color");
	}
	return getshoutcastersetting(localclientnum, "shoutcaster_fe_team2_color");
}

/*
	Name: get_team_color_fx
	Namespace: shoutcaster
	Checksum: 0x51F254F9
	Offset: 0x218
	Size: 0x5E
	Parameters: 3
	Flags: None
*/
function get_team_color_fx(localclientnum, team, script_bundle)
{
	color = get_team_color_id(localclientnum, team);
	return script_bundle.objects[color].fx_colorid;
}

/*
	Name: get_color_fx
	Namespace: shoutcaster
	Checksum: 0x7A60E4FC
	Offset: 0x280
	Size: 0x86
	Parameters: 2
	Flags: None
*/
function get_color_fx(localclientnum, script_bundle)
{
	effects = [];
	effects["allies"] = get_team_color_fx(localclientnum, "allies", script_bundle);
	effects["axis"] = get_team_color_fx(localclientnum, "axis", script_bundle);
	return effects;
}

/*
	Name: is_friendly
	Namespace: shoutcaster
	Checksum: 0xBD395153
	Offset: 0x310
	Size: 0x9E
	Parameters: 1
	Flags: None
*/
function is_friendly(localclientnum)
{
	localplayer = getlocalplayer(localclientnum);
	scorepanel_flipped = getshoutcastersetting(localclientnum, "shoutcaster_flip_scorepanel");
	if(!scorepanel_flipped)
	{
		friendly = self.team == "allies";
	}
	else
	{
		friendly = self.team == "axis";
	}
	return friendly;
}

