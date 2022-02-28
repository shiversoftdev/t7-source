// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_flashgrenades;

#namespace empgrenade;

/*
	Name: __init__sytem__
	Namespace: empgrenade
	Checksum: 0xB225A7F3
	Offset: 0x2F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("empgrenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: empgrenade
	Checksum: 0x6AF1CE46
	Offset: 0x338
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "empd", 1, 1, "int", &onempchanged, 0, 1);
	clientfield::register("toplayer", "empd_monitor_distance", 1, 1, "int", &onempmonitordistancechanged, 0, 0);
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: onempchanged
	Namespace: empgrenade
	Checksum: 0x49592E32
	Offset: 0x3F8
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function onempchanged(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	localplayer = getlocalplayer(localclientnum);
	if(newval == 1)
	{
		self startempeffects(localplayer);
	}
	else
	{
		already_distance_monitored = localplayer clientfield::get_to_player("empd_monitor_distance") == 1;
		if(!already_distance_monitored)
		{
			self stopempeffects(localplayer, oldval);
		}
	}
}

/*
	Name: startempeffects
	Namespace: empgrenade
	Checksum: 0xC136734F
	Offset: 0x4E0
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function startempeffects(localplayer, bwastimejump = 0)
{
	filter::init_filter_tactical(localplayer);
	filter::enable_filter_tactical(localplayer, 2);
	filter::set_filter_tactical_amount(localplayer, 2, 1);
	if(!bwastimejump)
	{
		playsound(0, "mpl_plr_emp_activate", (0, 0, 0));
	}
	audio::playloopat("mpl_plr_emp_looper", (0, 0, 0));
}

/*
	Name: stopempeffects
	Namespace: empgrenade
	Checksum: 0x62D0955
	Offset: 0x5A8
	Size: 0xB4
	Parameters: 3
	Flags: Linked
*/
function stopempeffects(localplayer, oldval, bwastimejump = 0)
{
	filter::init_filter_tactical(localplayer);
	filter::disable_filter_tactical(localplayer, 2);
	if(oldval != 0 && !bwastimejump)
	{
		playsound(0, "mpl_plr_emp_deactivate", (0, 0, 0));
	}
	audio::stoploopat("mpl_plr_emp_looper", (0, 0, 0));
}

/*
	Name: on_player_spawned
	Namespace: empgrenade
	Checksum: 0x8BBCB603
	Offset: 0x668
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function on_player_spawned(localclientnum)
{
	self endon(#"disconnect");
	localplayer = getlocalplayer(localclientnum);
	if(localplayer != self)
	{
		return;
	}
	curval = localplayer clientfield::get_to_player("empd_monitor_distance");
	inkillcam = getinkillcam(localclientnum);
	if(curval > 0 && localplayer isempjammed())
	{
		startempeffects(localplayer, inkillcam);
		localplayer monitordistance(localclientnum);
	}
	else
	{
		stopempeffects(localplayer, 0, 1);
		localplayer notify(#"end_emp_monitor_distance");
	}
}

/*
	Name: onempmonitordistancechanged
	Namespace: empgrenade
	Checksum: 0x53C80090
	Offset: 0x790
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function onempmonitordistancechanged(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	localplayer = getlocalplayer(localclientnum);
	if(newval == 1)
	{
		startempeffects(localplayer, bwastimejump);
		localplayer monitordistance(localclientnum);
	}
	else
	{
		stopempeffects(localplayer, oldval, bwastimejump);
		localplayer notify(#"end_emp_monitor_distance");
	}
}

/*
	Name: monitordistance
	Namespace: empgrenade
	Checksum: 0xFC778972
	Offset: 0x870
	Size: 0x2E8
	Parameters: 1
	Flags: Linked
*/
function monitordistance(localclientnum)
{
	localplayer = self;
	localplayer endon(#"entityshutdown");
	localplayer endon(#"end_emp_monitor_distance");
	localplayer endon(#"team_changed");
	if(localplayer isempjammed() == 0)
	{
		return;
	}
	distance_to_closest_enemy_emp_ui_model = getuimodel(getuimodelforcontroller(localclientnum), "distanceToClosestEnemyEmpKillstreak");
	new_distance = 0;
	max_static_value = getdvarfloat("ks_emp_fullscreen_maxStaticValue");
	min_static_value = getdvarfloat("ks_emp_fullscreen_minStaticValue");
	min_radius_max_static = getdvarfloat("ks_emp_fullscreen_minRadiusMaxStatic");
	max_radius_min_static = getdvarfloat("ks_emp_fullscreen_maxRadiusMinStatic");
	if(isdefined(distance_to_closest_enemy_emp_ui_model))
	{
		while(true)
		{
			/#
				max_static_value = getdvarfloat("");
				min_static_value = getdvarfloat("");
				min_radius_max_static = getdvarfloat("");
				max_radius_min_static = getdvarfloat("");
			#/
			new_distance = getuimodelvalue(distance_to_closest_enemy_emp_ui_model);
			range = max_radius_min_static - min_radius_max_static;
			current_static_value = max_static_value - (range <= 0 ? max_static_value : (new_distance - min_radius_max_static) / range);
			current_static_value = math::clamp(current_static_value, min_static_value, max_static_value);
			emp_grenaded = localplayer clientfield::get_to_player("empd") == 1;
			if(emp_grenaded && current_static_value < 1)
			{
				current_static_value = 1;
			}
			filter::set_filter_tactical_amount(localplayer, 2, current_static_value);
			wait(0.1);
		}
	}
}

