// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using_animtree("mp_emp_power_core");

#namespace emp;

/*
	Name: __init__sytem__
	Namespace: emp
	Checksum: 0x9159F0AB
	Offset: 0x1E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("emp", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: emp
	Checksum: 0x1773B161
	Offset: 0x220
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "emp_turret_init", 1, 1, "int", &emp_turret_init, 0, 0);
	clientfield::register("vehicle", "emp_turret_deploy", 1, 1, "int", &emp_turret_deploy_start, 0, 0);
	thread monitor_emp_killstreaks();
}

/*
	Name: monitor_emp_killstreaks
	Namespace: emp
	Checksum: 0xACC5ACD2
	Offset: 0x2D0
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function monitor_emp_killstreaks()
{
	level endon(#"disconnect");
	if(!isdefined(level.emp_killstreaks))
	{
		level.emp_killstreaks = [];
	}
	for(;;)
	{
		has_at_least_one_active_enemy_turret = 0;
		arrayremovevalue(level.emp_killstreaks, undefined);
		local_players = getlocalplayers();
		foreach(local_player in local_players)
		{
			if(local_player islocalplayer() == 0)
			{
				continue;
			}
			closest_enemy_emp = get_closest_enemy_emp_killstreak(local_player);
			if(isdefined(closest_enemy_emp))
			{
				has_at_least_one_active_enemy_turret = 1;
				localclientnum = local_player getlocalclientnumber();
				update_distance_to_closest_emp(localclientnum, distance(local_player.origin, closest_enemy_emp.origin));
			}
		}
		wait((has_at_least_one_active_enemy_turret ? 0.1 : 0.7));
	}
}

/*
	Name: get_closest_enemy_emp_killstreak
	Namespace: emp
	Checksum: 0x8441B57B
	Offset: 0x490
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function get_closest_enemy_emp_killstreak(local_player)
{
	closest_emp = undefined;
	closest_emp_distance_squared = 99999999;
	foreach(emp in level.emp_killstreaks)
	{
		if(emp.owner == local_player || emp.team == local_player.team)
		{
			continue;
		}
		distance_squared = distancesquared(local_player.origin, emp.origin);
		if(distance_squared < closest_emp_distance_squared)
		{
			closest_emp = emp;
			closest_emp_distance_squared = distance_squared;
		}
	}
	return closest_emp;
}

/*
	Name: update_distance_to_closest_emp
	Namespace: emp
	Checksum: 0x999F39B9
	Offset: 0x5D0
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function update_distance_to_closest_emp(localclientnum, new_value)
{
	if(!isdefined(localclientnum))
	{
		return;
	}
	distance_to_closest_enemy_emp_ui_model = getuimodel(getuimodelforcontroller(localclientnum), "distanceToClosestEnemyEmpKillstreak");
	if(isdefined(distance_to_closest_enemy_emp_ui_model))
	{
		setuimodelvalue(distance_to_closest_enemy_emp_ui_model, new_value);
	}
}

/*
	Name: emp_turret_init
	Namespace: emp
	Checksum: 0x42132B16
	Offset: 0x660
	Size: 0xCC
	Parameters: 7
	Flags: Linked
*/
function emp_turret_init(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(!newval)
	{
		return;
	}
	self useanimtree($mp_emp_power_core);
	self setanimrestart(%mp_emp_power_core::o_turret_emp_core_deploy, 1, 0, 0);
	self setanimtime(%mp_emp_power_core::o_turret_emp_core_deploy, 0);
}

/*
	Name: cleanup_fx_on_shutdown
	Namespace: emp
	Checksum: 0x335D503F
	Offset: 0x738
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function cleanup_fx_on_shutdown(localclientnum, handle)
{
	self endon(#"kill_fx_cleanup");
	self waittill(#"entityshutdown");
	stopfx(localclientnum, handle);
}

/*
	Name: emp_turret_deploy_start
	Namespace: emp
	Checksum: 0xC434F4EE
	Offset: 0x788
	Size: 0xCE
	Parameters: 7
	Flags: Linked
*/
function emp_turret_deploy_start(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		self thread emp_turret_deploy(localclientnum);
	}
	else
	{
		self notify(#"kill_fx_cleanup");
		if(isdefined(self.fxhandle))
		{
			stopfx(localclientnum, self.fxhandle);
			self.fxhandle = undefined;
		}
	}
}

/*
	Name: emp_turret_deploy
	Namespace: emp
	Checksum: 0x5A3BF7AB
	Offset: 0x860
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function emp_turret_deploy(localclientnum)
{
	self endon(#"entityshutdown");
	self useanimtree($mp_emp_power_core);
	self setanimrestart(%mp_emp_power_core::o_turret_emp_core_deploy, 1, 0, 1);
	length = getanimlength(%mp_emp_power_core::o_turret_emp_core_deploy);
	wait(length * 0.75);
	self useanimtree($mp_emp_power_core);
	self setanim(%mp_emp_power_core::o_turret_emp_core_spin, 1);
	self.fxhandle = playfxontag(localclientnum, "killstreaks/fx_emp_core", self, "tag_fx");
	self thread cleanup_fx_on_shutdown(localclientnum, self.fxhandle);
	wait(length * 0.25);
	self setanim(%mp_emp_power_core::o_turret_emp_core_deploy, 0);
}

