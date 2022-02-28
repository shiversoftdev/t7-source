// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_callbacks;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\util_shared;

#namespace prop;

/*
	Name: main
	Namespace: prop
	Checksum: 0xA282F846
	Offset: 0x218
	Size: 0xF4
	Parameters: 0
	Flags: None
*/
function main()
{
	clientfield::register("allplayers", "hideTeamPlayer", 27000, 2, "int", &function_8e3b5ce2, 0, 0);
	clientfield::register("allplayers", "pingHighlight", 27000, 1, "int", &function_c87d7938, 0, 0);
	callback::on_localplayer_spawned(&function_b413fb86);
	level.var_f12ccf06 = &function_6baff676;
	level.var_c301d021 = &function_76519db0;
	thread function_576e8126();
}

/*
	Name: function_b413fb86
	Namespace: prop
	Checksum: 0x1B09760E
	Offset: 0x318
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function function_b413fb86(localclientnum)
{
	level notify("localPlayerSpectatingEnd" + localclientnum);
	if(isspectating(localclientnum, 0))
	{
		level thread function_f336ce55(localclientnum);
	}
	level thread function_2bb59404(localclientnum);
}

/*
	Name: function_f336ce55
	Namespace: prop
	Checksum: 0x84F49575
	Offset: 0x390
	Size: 0xA4
	Parameters: 1
	Flags: None
*/
function function_f336ce55(localclientnum)
{
	level notify("localPlayerSpectating" + localclientnum);
	level endon("localPlayerSpectatingEnd" + localclientnum);
	var_cfcb9b39 = playerbeingspectated(localclientnum);
	while(true)
	{
		player = playerbeingspectated(localclientnum);
		if(player != var_cfcb9b39)
		{
			level notify("localPlayerSpectating" + localclientnum);
		}
		wait(0.1);
	}
}

/*
	Name: function_576e8126
	Namespace: prop
	Checksum: 0x237BBD34
	Offset: 0x440
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function function_576e8126()
{
	while(true)
	{
		level waittill(#"team_changed", localclientnum);
		level notify("team_changed" + localclientnum);
	}
}

/*
	Name: function_c5c7c3ef
	Namespace: prop
	Checksum: 0x7C234E2C
	Offset: 0x488
	Size: 0x76
	Parameters: 1
	Flags: None
*/
function function_c5c7c3ef(player)
{
	parent = self getlinkedent();
	while(isdefined(parent))
	{
		if(parent == player)
		{
			return true;
		}
		parent = parent getlinkedent();
	}
	return false;
}

/*
	Name: function_8ef128e8
	Namespace: prop
	Checksum: 0xD5799A55
	Offset: 0x508
	Size: 0x12A
	Parameters: 2
	Flags: None
*/
function function_8ef128e8(localclientnum, player)
{
	if(isdefined(player.prop))
	{
		return player.prop;
	}
	ents = getentarray(localclientnum);
	foreach(ent in ents)
	{
		if(!ent isplayer() && isdefined(ent.owner) && ent.owner == player && ent function_c5c7c3ef(player))
		{
			return ent;
		}
	}
}

/*
	Name: function_2bb59404
	Namespace: prop
	Checksum: 0x821AE7AE
	Offset: 0x640
	Size: 0x2B4
	Parameters: 1
	Flags: None
*/
function function_2bb59404(localclientnum)
{
	level notify("setupPropPlayerNames" + localclientnum);
	level endon("setupPropPlayerNames" + localclientnum);
	while(true)
	{
		localplayer = getlocalplayer(localclientnum);
		spectating = isspectating(localclientnum, 0);
		players = getplayers(localclientnum);
		foreach(player in players)
		{
			if(player != localplayer || spectating && player ishidden() && isdefined(player.team) && player.team == localplayer.team)
			{
				player.prop = function_8ef128e8(localclientnum, player);
				if(isdefined(player.prop))
				{
					if(!(isdefined(player.var_3a6ca2d4) && player.var_3a6ca2d4))
					{
						player.prop setdrawownername(1, spectating);
						player.var_3a6ca2d4 = 1;
					}
				}
				continue;
			}
			if(isdefined(player.var_3a6ca2d4) && player.var_3a6ca2d4)
			{
				player.prop = function_8ef128e8(localclientnum, player);
				if(isdefined(player.prop))
				{
					player.prop setdrawownername(0, spectating);
				}
				player.var_3a6ca2d4 = 0;
			}
		}
		wait(1);
	}
}

/*
	Name: function_76519db0
	Namespace: prop
	Checksum: 0xC2822249
	Offset: 0x900
	Size: 0xBC
	Parameters: 7
	Flags: None
*/
function function_76519db0(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		self notify(#"hash_e622a96b");
		self duplicate_render::update_dr_flag(localclientnum, "prop_ally", 0);
		self duplicate_render::update_dr_flag(localclientnum, "prop_clone", 0);
	}
	else
	{
		self thread function_e622a96b(localclientnum, newval);
	}
}

/*
	Name: function_e622a96b
	Namespace: prop
	Checksum: 0x3D0579B0
	Offset: 0x9C8
	Size: 0x208
	Parameters: 2
	Flags: None
*/
function function_e622a96b(localclientnum, var_2300871f)
{
	self endon(#"entityshutdown");
	level endon(#"disconnect");
	self notify(#"hash_e622a96b");
	self endon(#"hash_e622a96b");
	while(true)
	{
		localplayer = getlocalplayer(localclientnum);
		spectating = isspectating(localclientnum, 0) && !getinkillcam(localclientnum);
		var_9d961790 = !isdefined(self.owner) || self.owner != localplayer || spectating && isdefined(self.team) && isdefined(localplayer.team) && self.team == localplayer.team;
		if(var_2300871f == 1)
		{
			self duplicate_render::update_dr_flag(localclientnum, "prop_ally", var_9d961790);
			self duplicate_render::update_dr_flag(localclientnum, "prop_clone", 0);
		}
		else
		{
			self duplicate_render::update_dr_flag(localclientnum, "prop_clone", var_9d961790);
			self duplicate_render::update_dr_flag(localclientnum, "prop_ally", 0);
		}
		self duplicate_render::update_dr_filters(localclientnum);
		level util::waittill_any("team_changed" + localclientnum, "localPlayerSpectating" + localclientnum);
	}
}

/*
	Name: function_c87d7938
	Namespace: prop
	Checksum: 0x7A6D3B20
	Offset: 0xBD8
	Size: 0x9C
	Parameters: 7
	Flags: None
*/
function function_c87d7938(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		self notify(#"hash_e622a96b");
		self duplicate_render::update_dr_flag(localclientnum, "prop_clone", 0);
	}
	else
	{
		self thread function_b001ad83(localclientnum, newval);
	}
}

/*
	Name: function_b001ad83
	Namespace: prop
	Checksum: 0x158CF71D
	Offset: 0xC80
	Size: 0x108
	Parameters: 2
	Flags: None
*/
function function_b001ad83(localclientnum, var_2300871f)
{
	self endon(#"entityshutdown");
	self notify(#"hash_b001ad83");
	self endon(#"hash_b001ad83");
	while(true)
	{
		localplayer = getlocalplayer(localclientnum);
		var_9d961790 = self != localplayer && isdefined(self.team) && isdefined(localplayer.team) && self.team == localplayer.team;
		self duplicate_render::update_dr_flag(localclientnum, "prop_clone", var_9d961790);
		level util::waittill_any("team_changed" + localclientnum, "localPlayerSpectating" + localclientnum);
	}
}

/*
	Name: function_6baff676
	Namespace: prop
	Checksum: 0xBDD08B97
	Offset: 0xD90
	Size: 0x1D4
	Parameters: 7
	Flags: None
*/
function function_6baff676(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	localplayer = getlocalplayer(localclientnum);
	var_9d961790 = newval && isdefined(self.owner) && self.owner == localplayer;
	if(var_9d961790)
	{
		self duplicate_render::update_dr_flag(localclientnum, "prop_look_through", 1);
		self duplicate_render::set_dr_flag("hide_model", 1);
		self duplicate_render::set_dr_flag("active_camo_reveal", 0);
		self duplicate_render::set_dr_flag("active_camo_on", 1);
		self duplicate_render::update_dr_filters(localclientnum);
	}
	else
	{
		self duplicate_render::update_dr_flag(localclientnum, "prop_look_through", 0);
		self duplicate_render::set_dr_flag("hide_model", 0);
		self duplicate_render::set_dr_flag("active_camo_reveal", 0);
		self duplicate_render::set_dr_flag("active_camo_on", 0);
		self duplicate_render::update_dr_filters(localclientnum);
	}
}

/*
	Name: function_8e3b5ce2
	Namespace: prop
	Checksum: 0x4F180108
	Offset: 0xF70
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function function_8e3b5ce2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		self notify(#"hash_8819b68d");
		if(!self function_4ff87091(localclientnum))
		{
			self show();
		}
	}
	else
	{
		self function_4bf4d3e1(localclientnum, newval);
	}
}

/*
	Name: function_4ff87091
	Namespace: prop
	Checksum: 0x5555C2C0
	Offset: 0x1020
	Size: 0x60
	Parameters: 1
	Flags: None
*/
function function_4ff87091(localclientnum)
{
	if(isdefined(self.prop))
	{
		return 1;
	}
	if(self isplayer())
	{
		self.prop = function_8ef128e8(localclientnum, self);
		return isdefined(self.prop);
	}
	return 0;
}

/*
	Name: function_4bf4d3e1
	Namespace: prop
	Checksum: 0x3A1D49D9
	Offset: 0x1088
	Size: 0x17A
	Parameters: 2
	Flags: None
*/
function function_4bf4d3e1(localclientnum, var_1c61204d)
{
	self endon(#"entityshutdown");
	self notify(#"hash_8819b68d");
	self endon(#"hash_8819b68d");
	/#
		assert(var_1c61204d == 1 || var_1c61204d == 2);
	#/
	team = "allies";
	if(var_1c61204d == 2)
	{
		team = "axis";
	}
	while(true)
	{
		localplayer = getlocalplayer(localclientnum);
		ishidden = isdefined(localplayer.team) && team == localplayer.team && !isspectating(localclientnum);
		if(ishidden)
		{
			self hide();
		}
		else if(!self function_4ff87091(localclientnum))
		{
			self show();
		}
		level waittill("team_changed" + localclientnum);
	}
}

