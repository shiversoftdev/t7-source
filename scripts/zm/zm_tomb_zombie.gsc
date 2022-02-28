// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_behavior;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_tomb_tank;

#namespace zm_tomb_zombie;

/*
	Name: init
	Namespace: zm_tomb_zombie
	Checksum: 0xF519961F
	Offset: 0x4C0
	Size: 0x5C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_b5da43f3();
	setdvar("scr_zm_use_code_enemy_selection", 0);
	level thread update_closest_player();
	level.validate_on_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: function_b5da43f3
	Namespace: zm_tomb_zombie
	Checksum: 0xA4FE2CFE
	Offset: 0x528
	Size: 0x234
	Parameters: 0
	Flags: Linked, Private
*/
function private function_b5da43f3()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("wasKilledByWaterStaff", &function_901a96ec);
	behaviortreenetworkutility::registerbehaviortreescriptapi("wasKilledByFireStaff", &function_7ae408dd);
	behaviortreenetworkutility::registerbehaviortreescriptapi("wasKilledByLightningStaff", &function_a8b7161f);
	behaviortreenetworkutility::registerbehaviortreescriptapi("wasKilledOnTank", &waskilledontank);
	behaviortreenetworkutility::registerbehaviortreescriptapi("wasStunnedByFireStaff", &function_1beccbaf);
	behaviortreenetworkutility::registerbehaviortreescriptapi("wasStunnedByLightningStaff", &function_4638613d);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldWhirlwind", &zombieshouldwhirlwind);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieStunFireActionEnd", &zombiestunfireactionend);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieStunLightningActionEnd", &zombiestunlightningactionend);
	behaviortreenetworkutility::registerbehaviortreescriptapi("tombSetFindFleshState", &tombsetfindfleshstate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("tombClearFindFleshState", &tombclearfindfleshstate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("tombOnTankDeathActionStart", &tombontankdeathactionstart);
	spawner::add_archetype_spawn_function("zombie", &function_59f740e7);
	animationstatenetwork::registernotetrackhandlerfunction("shatter", &function_e24c6a3f);
}

/*
	Name: function_59f740e7
	Namespace: zm_tomb_zombie
	Checksum: 0xB56819E3
	Offset: 0x768
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_59f740e7()
{
	self.zombiemoveactioncallback = &tombsetfindfleshstate;
}

/*
	Name: function_e24c6a3f
	Namespace: zm_tomb_zombie
	Checksum: 0xB84ED822
	Offset: 0x790
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_e24c6a3f(entity)
{
	entity clientfield::set("staff_shatter_fx", 1);
	entity clientfield::set("attach_bullet_model", 0);
	entity ghost();
}

/*
	Name: function_901a96ec
	Namespace: zm_tomb_zombie
	Checksum: 0xD827ECDE
	Offset: 0x800
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function function_901a96ec(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.var_93022f09) && behaviortreeentity.var_93022f09)
	{
		return true;
	}
	return false;
}

/*
	Name: function_7ae408dd
	Namespace: zm_tomb_zombie
	Checksum: 0x7EAF6D4C
	Offset: 0x848
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function function_7ae408dd(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.var_1339189a) && behaviortreeentity.var_1339189a)
	{
		return true;
	}
	return false;
}

/*
	Name: function_a8b7161f
	Namespace: zm_tomb_zombie
	Checksum: 0x8BB749C9
	Offset: 0x890
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function function_a8b7161f(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.var_26747e92) && behaviortreeentity.var_26747e92)
	{
		return true;
	}
	return false;
}

/*
	Name: waskilledontank
	Namespace: zm_tomb_zombie
	Checksum: 0xDA16385
	Offset: 0x8D8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function waskilledontank(behaviortreeentity)
{
	return self zm_tomb_tank::entity_on_tank() || (isdefined(self.b_climbing_tank) && self.b_climbing_tank);
}

/*
	Name: function_1beccbaf
	Namespace: zm_tomb_zombie
	Checksum: 0x77E38544
	Offset: 0x920
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function function_1beccbaf(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.var_262d5062) && behaviortreeentity.var_262d5062)
	{
		return true;
	}
	return false;
}

/*
	Name: function_4638613d
	Namespace: zm_tomb_zombie
	Checksum: 0x80EBBCC8
	Offset: 0x968
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function function_4638613d(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.var_b52ab77a) && behaviortreeentity.var_b52ab77a)
	{
		return true;
	}
	return false;
}

/*
	Name: zombieshouldwhirlwind
	Namespace: zm_tomb_zombie
	Checksum: 0x5CFF1286
	Offset: 0x9B0
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function zombieshouldwhirlwind(behaviortreeentity)
{
	if(isdefined(behaviortreeentity._whirlwind_attract_anim) && behaviortreeentity._whirlwind_attract_anim)
	{
		return true;
	}
	return false;
}

/*
	Name: zombiestunlightningactionend
	Namespace: zm_tomb_zombie
	Checksum: 0x9FFE38D3
	Offset: 0x9F8
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function zombiestunlightningactionend(behaviortreeentity)
{
	behaviortreeentity.var_b52ab77a = 0;
}

/*
	Name: zombiestunfireactionend
	Namespace: zm_tomb_zombie
	Checksum: 0x50C2BC42
	Offset: 0xA20
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function zombiestunfireactionend(behaviortreeentity)
{
	behaviortreeentity.var_262d5062 = 0;
}

/*
	Name: tombontankdeathactionstart
	Namespace: zm_tomb_zombie
	Checksum: 0x7D2B2D4E
	Offset: 0xA48
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function tombontankdeathactionstart(behaviortreeentity)
{
	behaviortreeentity thread function_fe0480d9();
	var_25c21be0 = spawnstruct();
	var_25c21be0 thread function_57039dd1();
	behaviortreeentity thread function_66e3edec(var_25c21be0);
}

/*
	Name: function_fe0480d9
	Namespace: zm_tomb_zombie
	Checksum: 0x4F2A062A
	Offset: 0xAC0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_fe0480d9()
{
	wait(0.7);
	if(!isdefined(self))
	{
		return;
	}
	self zombie_utility::zombie_eye_glow_stop();
	self clientfield::set("zombie_instant_explode", 1);
	wait(0.05);
	if(!isdefined(self))
	{
		return;
	}
	self hide();
}

/*
	Name: function_57039dd1
	Namespace: zm_tomb_zombie
	Checksum: 0x80781915
	Offset: 0xB40
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function function_57039dd1()
{
	wait(10);
	self notify(#"hash_57039dd1");
}

/*
	Name: function_66e3edec
	Namespace: zm_tomb_zombie
	Checksum: 0xC7B6E9E
	Offset: 0xB60
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_66e3edec(var_25c21be0)
{
	var_25c21be0 endon(#"hash_57039dd1");
	self waittill(#"actor_corpse", e_corpse);
	e_corpse hide();
}

/*
	Name: function_ce3464b9
	Namespace: zm_tomb_zombie
	Checksum: 0x7BE2B94B
	Offset: 0xBB0
	Size: 0xFA
	Parameters: 1
	Flags: Linked, Private
*/
function private function_ce3464b9(players)
{
	if(isdefined(self.last_closest_player) && (isdefined(self.last_closest_player.am_i_valid) && self.last_closest_player.am_i_valid))
	{
		return;
	}
	self.need_closest_player = 1;
	foreach(player in players)
	{
		if(isdefined(player.am_i_valid) && player.am_i_valid)
		{
			self.last_closest_player = player;
			return;
		}
	}
	self.last_closest_player = undefined;
}

/*
	Name: function_3394e22d
	Namespace: zm_tomb_zombie
	Checksum: 0xF424BBA4
	Offset: 0xCB8
	Size: 0x262
	Parameters: 2
	Flags: Private
*/
function private function_3394e22d(origin, players)
{
	if(players.size == 0)
	{
		return undefined;
	}
	if(isdefined(self.zombie_poi))
	{
		return undefined;
	}
	if(players.size == 1)
	{
		self.last_closest_player = players[0];
		return self.last_closest_player;
	}
	if(!isdefined(self.last_closest_player))
	{
		self.last_closest_player = players[0];
	}
	if(!isdefined(self.need_closest_player))
	{
		self.need_closest_player = 1;
	}
	if(isdefined(level.last_closest_time) && level.last_closest_time >= level.time)
	{
		self function_ce3464b9(players);
		return self.last_closest_player;
	}
	if(isdefined(self.need_closest_player) && self.need_closest_player)
	{
		level.last_closest_time = level.time;
		self.need_closest_player = 0;
		closest = players[0];
		closest_dist = self zm_utility::approximate_path_dist(closest);
		if(!isdefined(closest_dist))
		{
			closest = undefined;
		}
		for(index = 1; index < players.size; index++)
		{
			dist = self zm_utility::approximate_path_dist(players[index]);
			if(isdefined(dist))
			{
				if(isdefined(closest_dist))
				{
					if(dist < closest_dist)
					{
						closest = players[index];
						closest_dist = dist;
					}
					continue;
				}
				closest = players[index];
				closest_dist = dist;
			}
		}
		self.last_closest_player = closest;
	}
	if(players.size > 1 && isdefined(closest))
	{
		self zm_utility::approximate_path_dist(closest);
	}
	self function_ce3464b9(players);
	return self.last_closest_player;
}

/*
	Name: update_closest_player
	Namespace: zm_tomb_zombie
	Checksum: 0xC67E7AE9
	Offset: 0xF28
	Size: 0x1F8
	Parameters: 0
	Flags: Linked, Private
*/
function private update_closest_player()
{
	level waittill(#"start_of_round");
	while(true)
	{
		reset_closest_player = 1;
		zombies = zombie_utility::get_zombie_array();
		var_6aad1b23 = getaiarchetypearray("mechz", level.zombie_team);
		if(var_6aad1b23.size)
		{
			zombies = arraycombine(zombies, var_6aad1b23, 0, 0);
		}
		foreach(zombie in zombies)
		{
			if(isdefined(zombie.completed_emerging_into_playable_area) && zombie.completed_emerging_into_playable_area && !isdefined(zombie.var_13ed8adf))
			{
				reset_closest_player = 0;
				break;
			}
		}
		if(reset_closest_player)
		{
			foreach(zombie in zombies)
			{
				if(isdefined(zombie.var_13ed8adf))
				{
					zombie.var_13ed8adf = undefined;
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: tombsetfindfleshstate
	Namespace: zm_tomb_zombie
	Checksum: 0xCBE841E9
	Offset: 0x1128
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function tombsetfindfleshstate(behaviortreeentity)
{
	behaviortreeentity.var_68ff8357 = behaviortreeentity.ai_state;
	behaviortreeentity.ai_state = "find_flesh";
}

/*
	Name: tombclearfindfleshstate
	Namespace: zm_tomb_zombie
	Checksum: 0x66F5BB4F
	Offset: 0x1170
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function tombclearfindfleshstate(behaviortreeentity)
{
	behaviortreeentity.ai_state = behaviortreeentity.var_68ff8357;
	behaviortreeentity.var_68ff8357 = undefined;
}

