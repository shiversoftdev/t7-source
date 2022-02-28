// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace ball;

/*
	Name: __init__sytem__
	Namespace: ball
	Checksum: 0x4DC8603D
	Offset: 0x3C8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ball", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ball
	Checksum: 0x10DE5810
	Offset: 0x408
	Size: 0x2BA
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "ballcarrier", 15000, 1, "int", &player_ballcarrier_changed, 0, 1);
	clientfield::register("allplayers", "passoption", 15000, 1, "int", &player_passoption_changed, 0, 0);
	clientfield::register("world", "ball_away", 15000, 1, "int", &world_ball_away_changed, 0, 1);
	clientfield::register("world", "ball_score_allies", 15000, 1, "int", &world_ball_score_allies, 0, 1);
	clientfield::register("world", "ball_score_axis", 15000, 1, "int", &world_ball_score_axis, 0, 1);
	clientfield::register("scriptmover", "ball_on_ground_fx", 15000, 1, "int", &ball_on_ground_fx, 0, 0);
	callback::on_localclient_connect(&on_localclient_connect);
	callback::on_spawned(&on_player_spawned);
	level.effect_scriptbundles = [];
	level.effect_scriptbundles["goal"] = struct::get_script_bundle("teamcolorfx", "teamcolorfx_uplink_goal");
	level.effect_scriptbundles["goal_score"] = struct::get_script_bundle("teamcolorfx", "teamcolorfx_uplink_goal_score");
	level._effect["ball_on_ground"] = "dlc1/skyjacked/fx_light_blue_flashing_md_02";
	level._effect["balllight_fx"] = "dlc4/genesis/fx_summoningkey_light_loop";
	level._effect["lght_marker"] = "zombie/fx_weapon_box_marker_zmb";
}

/*
	Name: on_localclient_connect
	Namespace: ball
	Checksum: 0xFF2F5B2F
	Offset: 0x6D0
	Size: 0x17C
	Parameters: 1
	Flags: Linked
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
	Checksum: 0x86417DCC
	Offset: 0x858
	Size: 0xE2
	Parameters: 1
	Flags: Linked
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
	Checksum: 0x3DA0FB73
	Offset: 0x948
	Size: 0xC0
	Parameters: 2
	Flags: Linked
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
	Checksum: 0xCA107740
	Offset: 0xA10
	Size: 0xC4
	Parameters: 3
	Flags: Linked
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
	Checksum: 0x95B9D2E1
	Offset: 0xAE0
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function setup_fx(localclientnum)
{
	effects = [];
	effects["allies"] = "ui/fx_uplink_goal_marker";
	effects["axis"] = "ui/fx_uplink_goal_marker";
	foreach(goal in level.goals)
	{
	}
	thread watch_for_team_change(localclientnum);
}

/*
	Name: play_score_fx
	Namespace: ball
	Checksum: 0x509A5365
	Offset: 0xBC0
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function play_score_fx(localclientnum, goal)
{
	effects = [];
	effects["allies"] = "ui/fx_uplink_goal_marker_flash";
	effects["axis"] = "ui/fx_uplink_goal_marker_flash";
	fx_handle = playfx(localclientnum, effects[goal.team], goal.origin);
	setfxteam(localclientnum, fx_handle, goal.team);
}

/*
	Name: play_goal_score_fx
	Namespace: ball
	Checksum: 0x18C62B62
	Offset: 0xC88
	Size: 0x7C
	Parameters: 6
	Flags: Linked
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
	Checksum: 0xFC6E145F
	Offset: 0xD10
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function world_ball_score_allies(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	play_goal_score_fx(localclientnum, "allies", oldval, newval, binitialsnap, bwastimejump);
}

/*
	Name: world_ball_score_axis
	Namespace: ball
	Checksum: 0x30743B6D
	Offset: 0xD88
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function world_ball_score_axis(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	play_goal_score_fx(localclientnum, "axis", oldval, newval, binitialsnap, bwastimejump);
}

/*
	Name: player_ballcarrier_changed
	Namespace: ball
	Checksum: 0x2A21C751
	Offset: 0xE00
	Size: 0x18C
	Parameters: 7
	Flags: Linked
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
	Checksum: 0xA9F2ADEB
	Offset: 0xF98
	Size: 0x20C
	Parameters: 1
	Flags: None
*/
function set_hud(localclientnum)
{
	level.ball_carrier = self;
	friendly = self isfriendly(localclientnum);
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
	Checksum: 0x1A097270
	Offset: 0x11B0
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
	Checksum: 0x67116BD0
	Offset: 0x12A8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function watch_for_death(localclientnum)
{
	level endon(#"watch_for_death");
	self waittill(#"entityshutdown");
}

/*
	Name: player_passoption_changed
	Namespace: ball
	Checksum: 0x41442339
	Offset: 0x12D8
	Size: 0xF4
	Parameters: 7
	Flags: Linked
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
	Checksum: 0xFE63EA6F
	Offset: 0x13D8
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function world_ball_away_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(createuimodel(getuimodelforcontroller(localclientnum), "ballGametype.ballAway"), newval);
}

/*
	Name: set_player_ball_carrier_dr
	Namespace: ball
	Checksum: 0x5E082203
	Offset: 0x1468
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function set_player_ball_carrier_dr(localclientnum, on_off)
{
	self duplicate_render::update_dr_flag(localclientnum, "ballcarrier", on_off);
}

/*
	Name: set_player_pass_option_dr
	Namespace: ball
	Checksum: 0x24FA823C
	Offset: 0x14B0
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
	Checksum: 0x2A5801
	Offset: 0x14F8
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
	Checksum: 0x4E6236C7
	Offset: 0x1550
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function watch_for_team_change(localclientnum)
{
	level notify(#"end_team_change_watch");
	level endon(#"end_team_change_watch");
	level waittill(#"team_changed");
	thread setup_fx(localclientnum);
}

/*
	Name: ball_on_ground_fx
	Namespace: ball
	Checksum: 0xD1E2CB69
	Offset: 0x15A8
	Size: 0x20E
	Parameters: 7
	Flags: Linked
*/
function ball_on_ground_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(!isdefined(self.var_ff242ed4))
		{
			self.var_ff242ed4 = playfx(localclientnum, level._effect["ball_on_ground"], self.origin + vectorscale((0, 0, 1), 72), (0, 0, 1), (1, 0, 0));
		}
		if(!isdefined(self.var_cd030ed9))
		{
			self.var_cd030ed9 = playfx(localclientnum, level._effect["balllight_fx"], self.origin + vectorscale((0, 0, 1), 72), (0, 0, 1), (1, 0, 0));
		}
		if(!isdefined(self.var_2e7f5bfb))
		{
			self.var_2e7f5bfb = playfx(localclientnum, level._effect["lght_marker"], self.origin + vectorscale((0, 0, 1), 72), (0, 0, 1), (1, 0, 0));
		}
	}
	else
	{
		if(isdefined(self.var_ff242ed4))
		{
			stopfx(localclientnum, self.var_ff242ed4);
			self.var_ff242ed4 = undefined;
		}
		if(isdefined(self.var_cd030ed9))
		{
			stopfx(localclientnum, self.var_cd030ed9);
			self.var_cd030ed9 = undefined;
		}
		if(isdefined(self.var_2e7f5bfb))
		{
			stopfx(localclientnum, self.var_2e7f5bfb);
			self.var_2e7f5bfb = undefined;
		}
	}
}

