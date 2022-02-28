// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_shoutcaster;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\util_shared;

#namespace ball;

/*
	Name: main
	Namespace: ball
	Checksum: 0x9E2E2566
	Offset: 0x350
	Size: 0x236
	Parameters: 0
	Flags: None
*/
function main()
{
	clientfield::register("allplayers", "ballcarrier", 1, 1, "int", &player_ballcarrier_changed, 0, 1);
	clientfield::register("allplayers", "passoption", 1, 1, "int", &player_passoption_changed, 0, 0);
	clientfield::register("world", "ball_away", 1, 1, "int", &world_ball_away_changed, 0, 1);
	clientfield::register("world", "ball_score_allies", 1, 1, "int", &world_ball_score_allies, 0, 1);
	clientfield::register("world", "ball_score_axis", 1, 1, "int", &world_ball_score_axis, 0, 1);
	callback::on_localclient_connect(&on_localclient_connect);
	callback::on_spawned(&on_player_spawned);
	if(!getdvarint("tu11_programaticallyColoredGameFX"))
	{
		level.effect_scriptbundles = [];
		level.effect_scriptbundles["goal"] = struct::get_script_bundle("teamcolorfx", "teamcolorfx_uplink_goal");
		level.effect_scriptbundles["goal_score"] = struct::get_script_bundle("teamcolorfx", "teamcolorfx_uplink_goal_score");
	}
}

/*
	Name: on_localclient_connect
	Namespace: ball
	Checksum: 0x7EAB9C46
	Offset: 0x590
	Size: 0x17C
	Parameters: 1
	Flags: None
*/
function on_localclient_connect(localclientnum)
{
	objective_ids = [];
	while(!isdefined(objective_ids["allies"]))
	{
		objective_ids["allies"] = serverobjective_getobjective(localclientnum, "ball_goal_allies");
		objective_ids["axis"] = serverobjective_getobjective(localclientnum, "ball_goal_axis");
		wait(0.05);
	}
	foreach(key, objective in objective_ids)
	{
		level.goals[key] = spawnstruct();
		level.goals[key].objectiveid = objective;
		setup_goal(localclientnum, level.goals[key]);
	}
	setup_fx(localclientnum);
}

/*
	Name: on_player_spawned
	Namespace: ball
	Checksum: 0x7F52C131
	Offset: 0x718
	Size: 0xE2
	Parameters: 1
	Flags: None
*/
function on_player_spawned(localclientnum)
{
	players = getplayers(localclientnum);
	foreach(player in players)
	{
		if(player util::isenemyplayer(self))
		{
			player duplicate_render::update_dr_flag(localclientnum, "ballcarrier", 0);
		}
	}
}

/*
	Name: setup_goal
	Namespace: ball
	Checksum: 0xF259A730
	Offset: 0x808
	Size: 0xC0
	Parameters: 2
	Flags: None
*/
function setup_goal(localclientnum, goal)
{
	goal.origin = serverobjective_getobjectiveorigin(localclientnum, goal.objectiveid);
	goal_entity = serverobjective_getobjectiveentity(localclientnum, goal.objectiveid);
	if(isdefined(goal_entity))
	{
		goal.origin = goal_entity.origin;
	}
	goal.team = serverobjective_getobjectiveteam(localclientnum, goal.objectiveid);
}

/*
	Name: setup_goal_fx
	Namespace: ball
	Checksum: 0x4A42C58C
	Offset: 0x8D0
	Size: 0xC4
	Parameters: 3
	Flags: None
*/
function setup_goal_fx(localclientnum, goal, effects)
{
	if(isdefined(goal.base_fx))
	{
		stopfx(localclientnum, goal.base_fx);
	}
	goal.base_fx = playfx(localclientnum, effects[goal.team], goal.origin);
	setfxteam(localclientnum, goal.base_fx, goal.team);
}

/*
	Name: setup_fx
	Namespace: ball
	Checksum: 0x4D825120
	Offset: 0x9A0
	Size: 0x1AC
	Parameters: 1
	Flags: None
*/
function setup_fx(localclientnum)
{
	effects = [];
	if(shoutcaster::is_shoutcaster_using_team_identity(localclientnum))
	{
		if(getdvarint("tu11_programaticallyColoredGameFX"))
		{
			effects["allies"] = "ui/fx_uplink_goal_marker_white";
			effects["axis"] = "ui/fx_uplink_goal_marker_white";
		}
		else
		{
			effects = shoutcaster::get_color_fx(localclientnum, level.effect_scriptbundles["goal"]);
		}
	}
	else
	{
		effects["allies"] = "ui/fx_uplink_goal_marker";
		effects["axis"] = "ui/fx_uplink_goal_marker";
	}
	foreach(goal in level.goals)
	{
		thread setup_goal_fx(localclientnum, goal, effects);
		thread resetondemojump(localclientnum, goal, effects);
	}
	thread watch_for_team_change(localclientnum);
}

/*
	Name: play_score_fx
	Namespace: ball
	Checksum: 0x873549EF
	Offset: 0xB58
	Size: 0x154
	Parameters: 2
	Flags: None
*/
function play_score_fx(localclientnum, goal)
{
	effects = [];
	if(shoutcaster::is_shoutcaster_using_team_identity(localclientnum))
	{
		if(getdvarint("tu11_programaticallyColoredGameFX"))
		{
			effects["allies"] = "ui/fx_uplink_goal_marker_white_flash";
			effects["axis"] = "ui/fx_uplink_goal_marker_white_flash";
		}
		else
		{
			effects = shoutcaster::get_color_fx(localclientnum, level.effect_scriptbundles["goal_score"]);
		}
	}
	else
	{
		effects["allies"] = "ui/fx_uplink_goal_marker_flash";
		effects["axis"] = "ui/fx_uplink_goal_marker_flash";
	}
	fx_handle = playfx(localclientnum, effects[goal.team], goal.origin);
	setfxteam(localclientnum, fx_handle, goal.team);
}

/*
	Name: play_goal_score_fx
	Namespace: ball
	Checksum: 0xBAB27AA3
	Offset: 0xCB8
	Size: 0x7C
	Parameters: 6
	Flags: None
*/
function play_goal_score_fx(localclientnum, team, oldval, newval, binitialsnap, bwastimejump)
{
	if(newval != oldval && !binitialsnap && !bwastimejump)
	{
		play_score_fx(localclientnum, level.goals[team]);
	}
}

/*
	Name: world_ball_score_allies
	Namespace: ball
	Checksum: 0x1DA7138
	Offset: 0xD40
	Size: 0x6C
	Parameters: 7
	Flags: None
*/
function world_ball_score_allies(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	play_goal_score_fx(localclientnum, "allies", oldval, newval, binitialsnap, bwastimejump);
}

/*
	Name: world_ball_score_axis
	Namespace: ball
	Checksum: 0x86481149
	Offset: 0xDB8
	Size: 0x6C
	Parameters: 7
	Flags: None
*/
function world_ball_score_axis(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	play_goal_score_fx(localclientnum, "axis", oldval, newval, binitialsnap, bwastimejump);
}

/*
	Name: player_ballcarrier_changed
	Namespace: ball
	Checksum: 0x93994F2
	Offset: 0xE30
	Size: 0x18C
	Parameters: 7
	Flags: None
*/
function player_ballcarrier_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	localplayer = getlocalplayer(localclientnum);
	if(localplayer == self)
	{
		if(newval)
		{
			self._hasball = 1;
		}
		else
		{
			self._hasball = 0;
			setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.passOption"), 0);
		}
	}
	if(localplayer != self && self isfriendly(localclientnum))
	{
		self set_player_ball_carrier_dr(localclientnum, newval);
	}
	else
	{
		self set_player_ball_carrier_dr(localclientnum, 0);
	}
	if(isdefined(level.ball_carrier) && level.ball_carrier != self)
	{
		return;
	}
	level notify(#"watch_for_death");
	if(newval == 1)
	{
		self thread watch_for_death(localclientnum);
	}
}

/*
	Name: set_hud
	Namespace: ball
	Checksum: 0x2189F755
	Offset: 0xFC8
	Size: 0x23C
	Parameters: 1
	Flags: None
*/
function set_hud(localclientnum)
{
	level.ball_carrier = self;
	if(shoutcaster::is_shoutcaster(localclientnum))
	{
		friendly = self shoutcaster::is_friendly(localclientnum);
	}
	else
	{
		friendly = self isfriendly(localclientnum);
	}
	if(isdefined(self.name))
	{
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballStatusText"), self.name);
	}
	else
	{
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballStatusText"), "");
	}
	if(isdefined(friendly))
	{
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballHeldByFriendly"), friendly);
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballHeldByEnemy"), !friendly);
	}
	else
	{
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballHeldByFriendly"), 0);
		setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballHeldByEnemy"), 0);
	}
}

/*
	Name: clear_hud
	Namespace: ball
	Checksum: 0x37A7E272
	Offset: 0x1210
	Size: 0xEC
	Parameters: 1
	Flags: None
*/
function clear_hud(localclientnum)
{
	level.ball_carrier = undefined;
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballHeldByEnemy"), 0);
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballHeldByFriendly"), 0);
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballStatusText"), &"MPUI_BALL_AWAY");
}

/*
	Name: watch_for_death
	Namespace: ball
	Checksum: 0x3FFFBD4F
	Offset: 0x1308
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function watch_for_death(localclientnum)
{
	level endon(#"watch_for_death");
	self waittill(#"entityshutdown");
}

/*
	Name: player_passoption_changed
	Namespace: ball
	Checksum: 0xB9DE5619
	Offset: 0x1338
	Size: 0xF4
	Parameters: 7
	Flags: None
*/
function player_passoption_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	localplayer = getlocalplayer(localclientnum);
	if(localplayer != self && self isfriendly(localclientnum))
	{
		if(isdefined(localplayer._hasball) && localplayer._hasball)
		{
			setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.passOption"), newval);
		}
	}
}

/*
	Name: world_ball_away_changed
	Namespace: ball
	Checksum: 0x6EBFB289
	Offset: 0x1438
	Size: 0x84
	Parameters: 7
	Flags: None
*/
function world_ball_away_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballAway"), newval);
}

/*
	Name: set_player_ball_carrier_dr
	Namespace: ball
	Checksum: 0x749C276
	Offset: 0x14C8
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_player_ball_carrier_dr(localclientnum, on_off)
{
	self duplicate_render::update_dr_flag(localclientnum, "ballcarrier", on_off);
}

/*
	Name: set_player_pass_option_dr
	Namespace: ball
	Checksum: 0x691C35C7
	Offset: 0x1510
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_player_pass_option_dr(localclientnum, on_off)
{
	self duplicate_render::update_dr_flag(localclientnum, "passoption", on_off);
}

/*
	Name: resetondemojump
	Namespace: ball
	Checksum: 0x4D6AEAA5
	Offset: 0x1558
	Size: 0x50
	Parameters: 3
	Flags: None
*/
function resetondemojump(localclientnum, goal, effects)
{
	for(;;)
	{
		level waittill("demo_jump" + localclientnum);
		setup_goal_fx(localclientnum, goal, effects);
	}
}

/*
	Name: watch_for_team_change
	Namespace: ball
	Checksum: 0xC0B7E05A
	Offset: 0x15B0
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function watch_for_team_change(localclientnum)
{
	level notify(#"end_team_change_watch");
	level endon(#"end_team_change_watch");
	level waittill(#"team_changed");
	thread setup_fx(localclientnum);
}

