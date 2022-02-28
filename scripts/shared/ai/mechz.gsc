// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace mechzbehavior;

/*
	Name: init
	Namespace: mechzbehavior
	Checksum: 0xA241E276
	Offset: 0xAB8
	Size: 0x274
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initmechzbehaviorsandasm();
	spawner::add_archetype_spawn_function("mechz", &archetypemechzblackboardinit);
	spawner::add_archetype_spawn_function("mechz", &mechzserverutils::mechzspawnsetup);
	clientfield::register("actor", "mechz_ft", 5000, 1, "int");
	clientfield::register("actor", "mechz_faceplate_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_powercap_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_claw_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_115_gun_firing", 5000, 1, "int");
	clientfield::register("actor", "mechz_rknee_armor_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_lknee_armor_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_rshoulder_armor_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_lshoulder_armor_detached", 5000, 1, "int");
	clientfield::register("actor", "mechz_headlamp_off", 5000, 2, "int");
	clientfield::register("actor", "mechz_face", 1, 3, "int");
}

/*
	Name: initmechzbehaviorsandasm
	Namespace: mechzbehavior
	Checksum: 0x33D94F30
	Offset: 0xD38
	Size: 0x474
	Parameters: 0
	Flags: Private
*/
function private initmechzbehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzTargetService", &mechztargetservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzGrenadeService", &mechzgrenadeservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzBerserkKnockdownService", &mechzberserkknockdownservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzShouldMelee", &mechzshouldmelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzShouldShowPain", &mechzshouldshowpain);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzShouldShootGrenade", &mechzshouldshootgrenade);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzShouldShootFlame", &mechzshouldshootflame);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzShouldShootFlameSweep", &mechzshouldshootflamesweep);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzShouldTurnBerserk", &mechzshouldturnberserk);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzShouldStun", &mechzshouldstun);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzShouldStumble", &mechzshouldstumble);
	behaviortreenetworkutility::registerbehaviortreeaction("mechzStunLoop", &mechzstunstart, &mechzstunupdate, &mechzstunend);
	behaviortreenetworkutility::registerbehaviortreeaction("mechzStumbleLoop", &mechzstumblestart, &mechzstumbleupdate, &mechzstumbleend);
	behaviortreenetworkutility::registerbehaviortreeaction("mechzShootFlameAction", &mechzshootflameactionstart, &mechzshootflameactionupdate, &mechzshootflameactionend);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzShootGrenade", &mechzshootgrenade);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzShootFlame", &mechzshootflame);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzUpdateFlame", &mechzupdateflame);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzStopFlame", &mechzstopflame);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzPlayedBerserkIntro", &mechzplayedberserkintro);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzAttackStart", &mechzattackstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzDeathStart", &mechzdeathstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzIdleStart", &mechzidlestart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzPainStart", &mechzpainstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("mechzPainTerminate", &mechzpainterminate);
	animationstatenetwork::registernotetrackhandlerfunction("melee_soldat", &mechznotetrackmelee);
	animationstatenetwork::registernotetrackhandlerfunction("fire_chaingun", &mechznotetrackshootgrenade);
}

/*
	Name: archetypemechzblackboardinit
	Namespace: mechzbehavior
	Checksum: 0xC5E372B0
	Offset: 0x11B8
	Size: 0x1EC
	Parameters: 0
	Flags: Private
*/
function private archetypemechzblackboardinit()
{
	blackboard::createblackboardforentity(self);
	self aiutility::registerutilityblackboardattributes();
	blackboard::registerblackboardattribute(self, "_locomotion_speed", "locomotion_speed_run", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_should_turn", "should_not_turn", &bb_getshouldturn);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_zombie_damageweapon_type", "regular", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_mechz_part", "mechz_powercore", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	self.___archetypeonanimscriptedcallback = &archetypemechzonanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: archetypemechzonanimscriptedcallback
	Namespace: mechzbehavior
	Checksum: 0xFDB8D738
	Offset: 0x13B0
	Size: 0x34
	Parameters: 1
	Flags: Private
*/
function private archetypemechzonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypemechzblackboardinit();
}

/*
	Name: bb_getshouldturn
	Namespace: mechzbehavior
	Checksum: 0x9C03DEA5
	Offset: 0x13F0
	Size: 0x2A
	Parameters: 0
	Flags: Private
*/
function private bb_getshouldturn()
{
	if(isdefined(self.should_turn) && self.should_turn)
	{
		return "should_turn";
	}
	return "should_not_turn";
}

/*
	Name: mechznotetrackmelee
	Namespace: mechzbehavior
	Checksum: 0xC5D808E
	Offset: 0x1428
	Size: 0x4C
	Parameters: 1
	Flags: Private
*/
function private mechznotetrackmelee(entity)
{
	if(isdefined(entity.mechz_melee_knockdown_function))
	{
		entity thread [[entity.mechz_melee_knockdown_function]]();
	}
	entity melee();
}

/*
	Name: mechznotetrackshootgrenade
	Namespace: mechzbehavior
	Checksum: 0x86A65D17
	Offset: 0x1480
	Size: 0x2CC
	Parameters: 1
	Flags: Private
*/
function private mechznotetrackshootgrenade(entity)
{
	if(!isdefined(entity.enemy))
	{
		return;
	}
	base_target_pos = entity.enemy.origin;
	v_velocity = entity.enemy getvelocity();
	base_target_pos = base_target_pos + (v_velocity * 1.5);
	target_pos_offset_x = math::randomsign() * randomint(32);
	target_pos_offset_y = math::randomsign() * randomint(32);
	target_pos = base_target_pos + (target_pos_offset_x, target_pos_offset_y, 0);
	dir = vectortoangles(target_pos - entity.origin);
	dir = anglestoforward(dir);
	launch_offset = dir * 5;
	launch_pos = entity gettagorigin("tag_gun_barrel2") + launch_offset;
	dist = distance(launch_pos, target_pos);
	velocity = dir * dist;
	velocity = velocity + vectorscale((0, 0, 1), 120);
	val = 1;
	oldval = entity clientfield::get("mechz_115_gun_firing");
	if(oldval === val)
	{
		val = 0;
	}
	entity clientfield::set("mechz_115_gun_firing", val);
	entity magicgrenadetype(getweapon("electroball_grenade"), launch_pos, velocity);
	playsoundatposition("wpn_grenade_fire_mechz", entity.origin);
}

/*
	Name: mechztargetservice
	Namespace: mechzbehavior
	Checksum: 0xEBF0C8F6
	Offset: 0x1758
	Size: 0x266
	Parameters: 1
	Flags: None
*/
function mechztargetservice(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return false;
	}
	if(isdefined(entity.destroy_octobomb))
	{
		return false;
	}
	player = zombie_utility::get_closest_valid_player(self.origin, self.ignore_player);
	entity.favoriteenemy = player;
	if(!isdefined(player) || player isnotarget())
	{
		if(isdefined(entity.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			entity.ignore_player = [];
		}
		/#
			if(isdefined(level.b_mechz_true_ignore) && level.b_mechz_true_ignore)
			{
				entity setgoal(entity.origin);
				return false;
			}
		#/
		if(isdefined(level.no_target_override))
		{
			[[level.no_target_override]](entity);
		}
		else
		{
			entity setgoal(entity.origin);
		}
		return false;
	}
	if(isdefined(level.enemy_location_override_func))
	{
		enemy_ground_pos = [[level.enemy_location_override_func]](entity, player);
		if(isdefined(enemy_ground_pos))
		{
			entity setgoal(enemy_ground_pos);
			return true;
		}
	}
	targetpos = getclosestpointonnavmesh(player.origin, 64, 30);
	if(isdefined(targetpos))
	{
		entity setgoal(targetpos);
		return true;
	}
	entity setgoal(entity.origin);
	return false;
}

/*
	Name: mechzgrenadeservice
	Namespace: mechzbehavior
	Checksum: 0x9D66E638
	Offset: 0x19C8
	Size: 0x100
	Parameters: 1
	Flags: Private
*/
function private mechzgrenadeservice(entity)
{
	if(!isdefined(entity.burstgrenadesfired))
	{
		entity.burstgrenadesfired = 0;
	}
	if(entity.burstgrenadesfired >= 3)
	{
		if(gettime() > entity.nextgrenadetime)
		{
			entity.burstgrenadesfired = 0;
		}
	}
	if(isdefined(level.a_electroball_grenades))
	{
		level.a_electroball_grenades = array::remove_undefined(level.a_electroball_grenades);
		a_active_grenades = array::filter(level.a_electroball_grenades, 0, &mechzfiltergrenadesbyowner, entity);
		entity.activegrenades = a_active_grenades.size;
	}
	else
	{
		entity.activegrenades = 0;
	}
}

/*
	Name: mechzfiltergrenadesbyowner
	Namespace: mechzbehavior
	Checksum: 0x8F624B3F
	Offset: 0x1AD0
	Size: 0x34
	Parameters: 2
	Flags: Private
*/
function private mechzfiltergrenadesbyowner(grenade, mechz)
{
	if(grenade.owner === mechz)
	{
		return true;
	}
	return false;
}

/*
	Name: mechzberserkknockdownservice
	Namespace: mechzbehavior
	Checksum: 0xC5D2D7A5
	Offset: 0x1B10
	Size: 0x43A
	Parameters: 1
	Flags: Private
*/
function private mechzberserkknockdownservice(entity)
{
	velocity = entity getvelocity();
	predict_time = 0.3;
	predicted_pos = entity.origin + (velocity * predict_time);
	move_dist_sq = distancesquared(predicted_pos, entity.origin);
	speed = move_dist_sq / predict_time;
	if(speed >= 10)
	{
		a_zombies = getaiarchetypearray("zombie");
		a_filtered_zombies = array::filter(a_zombies, 0, &mechzzombieeligibleforberserkknockdown, entity, predicted_pos);
		if(a_filtered_zombies.size > 0)
		{
			foreach(zombie in a_filtered_zombies)
			{
				zombie.knockdown = 1;
				zombie.knockdown_type = "knockdown_shoved";
				zombie_to_mechz = entity.origin - zombie.origin;
				zombie_to_mechz_2d = vectornormalize((zombie_to_mechz[0], zombie_to_mechz[1], 0));
				zombie_forward = anglestoforward(zombie.angles);
				zombie_forward_2d = vectornormalize((zombie_forward[0], zombie_forward[1], 0));
				zombie_right = anglestoright(zombie.angles);
				zombie_right_2d = vectornormalize((zombie_right[0], zombie_right[1], 0));
				dot = vectordot(zombie_to_mechz_2d, zombie_forward_2d);
				if(dot >= 0.5)
				{
					zombie.knockdown_direction = "front";
					zombie.getup_direction = "getup_back";
					continue;
				}
				if(dot < 0.5 && dot > -0.5)
				{
					dot = vectordot(zombie_to_mechz_2d, zombie_right_2d);
					if(dot > 0)
					{
						zombie.knockdown_direction = "right";
						if(math::cointoss())
						{
							zombie.getup_direction = "getup_back";
						}
						else
						{
							zombie.getup_direction = "getup_belly";
						}
					}
					else
					{
						zombie.knockdown_direction = "left";
						zombie.getup_direction = "getup_belly";
					}
					continue;
				}
				zombie.knockdown_direction = "back";
				zombie.getup_direction = "getup_belly";
			}
		}
	}
}

/*
	Name: mechzzombieeligibleforberserkknockdown
	Namespace: mechzbehavior
	Checksum: 0x27164013
	Offset: 0x1F58
	Size: 0x1C4
	Parameters: 3
	Flags: Private
*/
function private mechzzombieeligibleforberserkknockdown(zombie, mechz, predicted_pos)
{
	if(zombie.knockdown === 1)
	{
		return false;
	}
	knockdown_dist_sq = 2304;
	dist_sq = distancesquared(predicted_pos, zombie.origin);
	if(dist_sq > knockdown_dist_sq)
	{
		return false;
	}
	if(zombie.is_immune_to_knockdown === 1)
	{
		return false;
	}
	origin = mechz.origin;
	facing_vec = anglestoforward(mechz.angles);
	enemy_vec = zombie.origin - origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = vectornormalize(enemy_yaw_vec);
	facing_yaw_vec = vectornormalize(facing_yaw_vec);
	enemy_dot = vectordot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0)
	{
		return false;
	}
	return true;
}

/*
	Name: mechzshouldmelee
	Namespace: mechzbehavior
	Checksum: 0x68ED31
	Offset: 0x2128
	Size: 0xE6
	Parameters: 1
	Flags: None
*/
function mechzshouldmelee(entity)
{
	if(!isdefined(entity.enemy))
	{
		return false;
	}
	if(distancesquared(entity.origin, entity.enemy.origin) > 12544)
	{
		return false;
	}
	if(isdefined(entity.enemy.usingvehicle) && entity.enemy.usingvehicle)
	{
		return true;
	}
	yaw = abs(zombie_utility::getyawtoenemy());
	if(yaw > 45)
	{
		return false;
	}
	return true;
}

/*
	Name: mechzshouldshowpain
	Namespace: mechzbehavior
	Checksum: 0x4653E3C0
	Offset: 0x2218
	Size: 0x2C
	Parameters: 1
	Flags: Private
*/
function private mechzshouldshowpain(entity)
{
	if(entity.partdestroyed === 1)
	{
		return true;
	}
	return false;
}

/*
	Name: mechzshouldshootgrenade
	Namespace: mechzbehavior
	Checksum: 0x47A72C52
	Offset: 0x2250
	Size: 0x140
	Parameters: 1
	Flags: Private
*/
function private mechzshouldshootgrenade(entity)
{
	if(entity.berserk === 1)
	{
		return false;
	}
	if(entity.gun_attached !== 1)
	{
		return false;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		return false;
	}
	if(entity.burstgrenadesfired >= 3)
	{
		return false;
	}
	if(entity.activegrenades >= 9)
	{
		return false;
	}
	if(!entity mechzserverutils::mechzgrenadecheckinarc())
	{
		return false;
	}
	if(!entity cansee(entity.favoriteenemy))
	{
		return false;
	}
	dist_sq = distancesquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 62500 || dist_sq > 1440000)
	{
		return false;
	}
	return true;
}

/*
	Name: mechzshouldshootflame
	Namespace: mechzbehavior
	Checksum: 0xBBE24C5D
	Offset: 0x2398
	Size: 0x1F8
	Parameters: 1
	Flags: Private
*/
function private mechzshouldshootflame(entity)
{
	/#
		if(isdefined(entity.shoot_flame) && entity.shoot_flame)
		{
			return true;
		}
	#/
	if(entity.berserk === 1)
	{
		return false;
	}
	if(isdefined(entity.isshootingflame) && entity.isshootingflame && gettime() < entity.stopshootingflametime)
	{
		return true;
	}
	if(!isdefined(entity.favoriteenemy))
	{
		return false;
	}
	if(entity.isshootingflame === 1 && entity.stopshootingflametime <= gettime())
	{
		return false;
	}
	if(entity.nextflametime > gettime())
	{
		return false;
	}
	if(!entity mechzserverutils::mechzcheckinarc(26, "tag_flamethrower_fx"))
	{
		return false;
	}
	dist_sq = distancesquared(entity.origin, entity.favoriteenemy.origin);
	if(dist_sq < 9216 || dist_sq > 50625)
	{
		return false;
	}
	can_see = bullettracepassed(entity.origin + vectorscale((0, 0, 1), 36), entity.favoriteenemy.origin + vectorscale((0, 0, 1), 36), 0, undefined);
	if(!can_see)
	{
		return false;
	}
	return true;
}

/*
	Name: mechzshouldshootflamesweep
	Namespace: mechzbehavior
	Checksum: 0x4DFB1D87
	Offset: 0x2598
	Size: 0x156
	Parameters: 1
	Flags: Private
*/
function private mechzshouldshootflamesweep(entity)
{
	if(entity.berserk === 1)
	{
		return false;
	}
	if(!mechzshouldshootflame(entity))
	{
		return false;
	}
	if(randomint(100) > 10)
	{
		return false;
	}
	near_players = 0;
	players = getplayers();
	foreach(player in players)
	{
		if(distance2dsquared(entity.origin, player.origin) < 10000)
		{
			near_players++;
		}
	}
	if(near_players < 2)
	{
		return false;
	}
	return true;
}

/*
	Name: mechzshouldturnberserk
	Namespace: mechzbehavior
	Checksum: 0xE898D1A1
	Offset: 0x26F8
	Size: 0x44
	Parameters: 1
	Flags: Private
*/
function private mechzshouldturnberserk(entity)
{
	if(entity.berserk === 1 && entity.hasturnedberserk !== 1)
	{
		return true;
	}
	return false;
}

/*
	Name: mechzshouldstun
	Namespace: mechzbehavior
	Checksum: 0x86F0F149
	Offset: 0x2748
	Size: 0x3A
	Parameters: 1
	Flags: Private
*/
function private mechzshouldstun(entity)
{
	if(isdefined(entity.stun) && entity.stun)
	{
		return true;
	}
	return false;
}

/*
	Name: mechzshouldstumble
	Namespace: mechzbehavior
	Checksum: 0x1A2651E1
	Offset: 0x2790
	Size: 0x3A
	Parameters: 1
	Flags: Private
*/
function private mechzshouldstumble(entity)
{
	if(isdefined(entity.stumble) && entity.stumble)
	{
		return true;
	}
	return false;
}

/*
	Name: mechzshootgrenadeaction
	Namespace: mechzbehavior
	Checksum: 0x548BD0BD
	Offset: 0x27D8
	Size: 0x48
	Parameters: 2
	Flags: Private
*/
function private mechzshootgrenadeaction(entity, asmstatename)
{
	animationstatenetworkutility::requeststate(entity, asmstatename);
	entity.grenadestarttime = gettime() + 3000;
	return 5;
}

/*
	Name: mechzshootgrenadeactionupdate
	Namespace: mechzbehavior
	Checksum: 0x2673E98C
	Offset: 0x2828
	Size: 0x44
	Parameters: 2
	Flags: Private
*/
function private mechzshootgrenadeactionupdate(entity, asmstatename)
{
	if(!(isdefined(entity.shoot_grenade) && entity.shoot_grenade))
	{
		return 4;
	}
	return 5;
}

/*
	Name: mechzstunstart
	Namespace: mechzbehavior
	Checksum: 0x2F1A8BD6
	Offset: 0x2878
	Size: 0x48
	Parameters: 2
	Flags: Private
*/
function private mechzstunstart(entity, asmstatename)
{
	animationstatenetworkutility::requeststate(entity, asmstatename);
	entity.stuntime = gettime() + 500;
	return 5;
}

/*
	Name: mechzstunupdate
	Namespace: mechzbehavior
	Checksum: 0x35F1D3CA
	Offset: 0x28C8
	Size: 0x32
	Parameters: 2
	Flags: Private
*/
function private mechzstunupdate(entity, asmstatename)
{
	if(gettime() > entity.stuntime)
	{
		return 4;
	}
	return 5;
}

/*
	Name: mechzstunend
	Namespace: mechzbehavior
	Checksum: 0x7FEA3D7B
	Offset: 0x2908
	Size: 0x40
	Parameters: 2
	Flags: Private
*/
function private mechzstunend(entity, asmstatename)
{
	entity.stun = 0;
	entity.stumble_stun_cooldown_time = gettime() + 10000;
	return 4;
}

/*
	Name: mechzstumblestart
	Namespace: mechzbehavior
	Checksum: 0x4DBCB46B
	Offset: 0x2950
	Size: 0x48
	Parameters: 2
	Flags: Private
*/
function private mechzstumblestart(entity, asmstatename)
{
	animationstatenetworkutility::requeststate(entity, asmstatename);
	entity.stumbletime = gettime() + 500;
	return 5;
}

/*
	Name: mechzstumbleupdate
	Namespace: mechzbehavior
	Checksum: 0x5747D9B9
	Offset: 0x29A0
	Size: 0x32
	Parameters: 2
	Flags: Private
*/
function private mechzstumbleupdate(entity, asmstatename)
{
	if(gettime() > entity.stumbletime)
	{
		return 4;
	}
	return 5;
}

/*
	Name: mechzstumbleend
	Namespace: mechzbehavior
	Checksum: 0xF708103C
	Offset: 0x29E0
	Size: 0x40
	Parameters: 2
	Flags: Private
*/
function private mechzstumbleend(entity, asmstatename)
{
	entity.stumble = 0;
	entity.stumble_stun_cooldown_time = gettime() + 10000;
	return 4;
}

/*
	Name: mechzshootflameactionstart
	Namespace: mechzbehavior
	Checksum: 0x883DD19F
	Offset: 0x2A28
	Size: 0x48
	Parameters: 2
	Flags: None
*/
function mechzshootflameactionstart(entity, asmstatename)
{
	animationstatenetworkutility::requeststate(entity, asmstatename);
	mechzshootflame(entity);
	return 5;
}

/*
	Name: mechzshootflameactionupdate
	Namespace: mechzbehavior
	Checksum: 0x88E62F42
	Offset: 0x2A78
	Size: 0x130
	Parameters: 2
	Flags: None
*/
function mechzshootflameactionupdate(entity, asmstatename)
{
	if(isdefined(entity.berserk) && entity.berserk)
	{
		mechzstopflame(entity);
		return 4;
	}
	if(isdefined(mechzshouldmelee(entity)) && mechzshouldmelee(entity))
	{
		mechzstopflame(entity);
		return 4;
	}
	if(isdefined(entity.isshootingflame) && entity.isshootingflame)
	{
		if(isdefined(entity.stopshootingflametime) && gettime() > entity.stopshootingflametime)
		{
			mechzstopflame(entity);
			return 4;
		}
		mechzupdateflame(entity);
	}
	return 5;
}

/*
	Name: mechzshootflameactionend
	Namespace: mechzbehavior
	Checksum: 0x985A6238
	Offset: 0x2BB0
	Size: 0x30
	Parameters: 2
	Flags: None
*/
function mechzshootflameactionend(entity, asmstatename)
{
	mechzstopflame(entity);
	return 4;
}

/*
	Name: mechzshootgrenade
	Namespace: mechzbehavior
	Checksum: 0x52640D37
	Offset: 0x2BE8
	Size: 0x4C
	Parameters: 1
	Flags: Private
*/
function private mechzshootgrenade(entity)
{
	entity.burstgrenadesfired++;
	if(entity.burstgrenadesfired >= 3)
	{
		entity.nextgrenadetime = gettime() + 6000;
	}
}

/*
	Name: mechzshootflame
	Namespace: mechzbehavior
	Checksum: 0x3F71CAA2
	Offset: 0x2C40
	Size: 0x24
	Parameters: 1
	Flags: Private
*/
function private mechzshootflame(entity)
{
	entity thread mechzdelayflame();
}

/*
	Name: mechzdelayflame
	Namespace: mechzbehavior
	Checksum: 0x4D59C986
	Offset: 0x2C70
	Size: 0x70
	Parameters: 0
	Flags: Private
*/
function private mechzdelayflame()
{
	self endon(#"death");
	self notify(#"mechzdelayflame");
	self endon(#"mechzdelayflame");
	wait(0.3);
	self clientfield::set("mechz_ft", 1);
	self.isshootingflame = 1;
	self.stopshootingflametime = gettime() + 2500;
}

/*
	Name: mechzupdateflame
	Namespace: mechzbehavior
	Checksum: 0x9828CF1D
	Offset: 0x2CE8
	Size: 0x174
	Parameters: 1
	Flags: Private
*/
function private mechzupdateflame(entity)
{
	if(isdefined(level.mechz_flamethrower_player_callback))
	{
		[[level.mechz_flamethrower_player_callback]](entity);
	}
	else
	{
		players = getplayers();
		foreach(player in players)
		{
			if(!(isdefined(player.is_burning) && player.is_burning))
			{
				if(player istouching(entity.flametrigger))
				{
					if(isdefined(entity.mechzflamedamage))
					{
						player thread [[entity.mechzflamedamage]]();
						continue;
					}
					player thread playerflamedamage(entity);
				}
			}
		}
	}
	if(isdefined(level.mechz_flamethrower_ai_callback))
	{
		[[level.mechz_flamethrower_ai_callback]](entity);
	}
}

/*
	Name: playerflamedamage
	Namespace: mechzbehavior
	Checksum: 0xC331EB5D
	Offset: 0x2E68
	Size: 0xF8
	Parameters: 1
	Flags: None
*/
function playerflamedamage(mechz)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!(isdefined(self.is_burning) && self.is_burning) && zombie_utility::is_player_valid(self, 1))
	{
		self.is_burning = 1;
		if(!self hasperk("specialty_armorvest"))
		{
			self burnplayer::setplayerburning(1.5, 0.5, 30, mechz, undefined);
		}
		else
		{
			self burnplayer::setplayerburning(1.5, 0.5, 20, mechz, undefined);
		}
		wait(1.5);
		self.is_burning = 0;
	}
}

/*
	Name: mechzstopflame
	Namespace: mechzbehavior
	Checksum: 0xA9CAD245
	Offset: 0x2F68
	Size: 0x72
	Parameters: 1
	Flags: None
*/
function mechzstopflame(entity)
{
	self notify(#"mechzdelayflame");
	entity clientfield::set("mechz_ft", 0);
	entity.isshootingflame = 0;
	entity.nextflametime = gettime() + 7500;
	entity.stopshootingflametime = undefined;
}

/*
	Name: mechzgoberserk
	Namespace: mechzbehavior
	Checksum: 0xDD71AC10
	Offset: 0x2FE8
	Size: 0xA4
	Parameters: 0
	Flags: None
*/
function mechzgoberserk()
{
	entity = self;
	g_time = gettime();
	entity.berserkendtime = g_time + 10000;
	if(entity.berserk !== 1)
	{
		entity.berserk = 1;
		entity thread mechzendberserk();
		blackboard::setblackboardattribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
	}
}

/*
	Name: mechzplayedberserkintro
	Namespace: mechzbehavior
	Checksum: 0x3BF96614
	Offset: 0x3098
	Size: 0x20
	Parameters: 1
	Flags: Private
*/
function private mechzplayedberserkintro(entity)
{
	entity.hasturnedberserk = 1;
}

/*
	Name: mechzendberserk
	Namespace: mechzbehavior
	Checksum: 0x2A1E43B4
	Offset: 0x30C0
	Size: 0xA8
	Parameters: 0
	Flags: Private
*/
function private mechzendberserk()
{
	self endon(#"death");
	self endon(#"disconnect");
	while(self.berserk === 1)
	{
		if(gettime() >= self.berserkendtime)
		{
			self.berserk = 0;
			self.hasturnedberserk = 0;
			self asmsetanimationrate(1);
			blackboard::setblackboardattribute(self, "_locomotion_speed", "locomotion_speed_run");
		}
		wait(0.25);
	}
}

/*
	Name: mechzattackstart
	Namespace: mechzbehavior
	Checksum: 0x660F1FB7
	Offset: 0x3170
	Size: 0x2C
	Parameters: 1
	Flags: Private
*/
function private mechzattackstart(entity)
{
	entity clientfield::set("mechz_face", 1);
}

/*
	Name: mechzdeathstart
	Namespace: mechzbehavior
	Checksum: 0x4C604890
	Offset: 0x31A8
	Size: 0x2C
	Parameters: 1
	Flags: Private
*/
function private mechzdeathstart(entity)
{
	entity clientfield::set("mechz_face", 2);
}

/*
	Name: mechzidlestart
	Namespace: mechzbehavior
	Checksum: 0x6631C3C4
	Offset: 0x31E0
	Size: 0x2C
	Parameters: 1
	Flags: Private
*/
function private mechzidlestart(entity)
{
	entity clientfield::set("mechz_face", 3);
}

/*
	Name: mechzpainstart
	Namespace: mechzbehavior
	Checksum: 0xF4F64D0D
	Offset: 0x3218
	Size: 0x2C
	Parameters: 1
	Flags: Private
*/
function private mechzpainstart(entity)
{
	entity clientfield::set("mechz_face", 4);
}

/*
	Name: mechzpainterminate
	Namespace: mechzbehavior
	Checksum: 0xB2D5B22A
	Offset: 0x3250
	Size: 0x2A
	Parameters: 1
	Flags: Private
*/
function private mechzpainterminate(entity)
{
	entity.partdestroyed = 0;
	entity.show_pain_from_explosive_dmg = undefined;
}

#namespace mechzserverutils;

/*
	Name: mechzspawnsetup
	Namespace: mechzserverutils
	Checksum: 0x83D7AB87
	Offset: 0x3288
	Size: 0x1F2
	Parameters: 0
	Flags: Private
*/
function private mechzspawnsetup()
{
	self disableaimassist();
	self.disableammodrop = 1;
	self.no_gib = 1;
	self.ignore_nuke = 1;
	self.ignore_enemy_count = 1;
	self.ignore_round_robbin_death = 1;
	self.zombie_move_speed = "run";
	blackboard::setblackboardattribute(self, "_locomotion_speed", "locomotion_speed_run");
	self.ignorerunandgundist = 1;
	self mechzaddattachments();
	self.grenadecount = 9;
	self.nextflametime = gettime();
	self.stumble_stun_cooldown_time = gettime();
	/#
		self.debug_traversal_ast = "";
	#/
	self.flametrigger = spawn("trigger_box", self.origin, 0, 200, 50, 25);
	self.flametrigger enablelinkto();
	self.flametrigger.origin = self gettagorigin("tag_flamethrower_fx");
	self.flametrigger.angles = self gettagangles("tag_flamethrower_fx");
	self.flametrigger linkto(self, "tag_flamethrower_fx");
	self thread weaponobjects::watchweaponobjectusage();
	self.pers = [];
	self.pers["team"] = self.team;
}

/*
	Name: mechzflamewatcher
	Namespace: mechzserverutils
	Checksum: 0x7C76025E
	Offset: 0x3488
	Size: 0x70
	Parameters: 0
	Flags: Private
*/
function private mechzflamewatcher()
{
	self endon(#"death");
	while(true)
	{
		if(isdefined(self.favoriteenemy))
		{
			if(self.flametrigger istouching(self.favoriteenemy))
			{
				/#
					printtoprightln("");
				#/
			}
		}
		wait(0.05);
	}
}

/*
	Name: mechzaddattachments
	Namespace: mechzserverutils
	Checksum: 0xBF0BB662
	Offset: 0x3500
	Size: 0x10C
	Parameters: 0
	Flags: Private
*/
function private mechzaddattachments()
{
	self.has_left_knee_armor = 1;
	self.left_knee_armor_health = 50;
	self.has_right_knee_armor = 1;
	self.right_knee_armor_health = 50;
	self.has_left_shoulder_armor = 1;
	self.left_shoulder_armor_health = 50;
	self.has_right_shoulder_armor = 1;
	self.right_shoulder_armor_health = 50;
	org = self gettagorigin("tag_gun_spin");
	ang = self gettagangles("tag_gun_spin");
	self.gun_attached = 1;
	self.has_faceplate = 1;
	self.faceplate_health = 50;
	self.has_powercap = 1;
	self.powercap_covered = 1;
	self.powercap_cover_health = 50;
	self.powercap_health = 50;
}

/*
	Name: mechzdamagecallback
	Namespace: mechzserverutils
	Checksum: 0x690F974A
	Offset: 0x3618
	Size: 0x16B4
	Parameters: 12
	Flags: None
*/
function mechzdamagecallback(inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	if(isdefined(self.b_flyin_done) && (!(isdefined(self.b_flyin_done) && self.b_flyin_done)))
	{
		return 0;
	}
	if(isdefined(level.mechz_should_stun_override) && (!(isdefined(self.stun) && self.stun || (isdefined(self.stumble) && self.stumble))))
	{
		if(self.stumble_stun_cooldown_time < gettime() && (!(isdefined(self.berserk) && self.berserk)))
		{
			self [[level.mechz_should_stun_override]](inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex);
		}
	}
	if(issubstr(weapon.name, "elemental_bow") && isdefined(inflictor) && inflictor.classname === "rocket")
	{
		return 0;
	}
	damage = mechzweapondamagemodifier(damage, weapon);
	if(isdefined(level.mechz_damage_override))
	{
		damage = [[level.mechz_damage_override]](attacker, damage);
	}
	if(!isdefined(self.next_pain_time) || gettime() >= self.next_pain_time)
	{
		self thread mechz_play_pain_audio();
		self.next_pain_time = (gettime() + 250) + randomint(500);
	}
	if(isdefined(self.damage_scoring_function))
	{
		self [[self.damage_scoring_function]](inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex);
	}
	if(isdefined(level.mechz_staff_damage_override))
	{
		staffdamage = [[level.mechz_staff_damage_override]](inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex);
		if(staffdamage > 0)
		{
			n_mechz_damage_percent = 0.5;
			if(!(isdefined(self.has_faceplate) && self.has_faceplate) && n_mechz_damage_percent < 1)
			{
				n_mechz_damage_percent = 1;
			}
			staffdamage = staffdamage * n_mechz_damage_percent;
			if(isdefined(self.has_faceplate) && self.has_faceplate)
			{
				self mechz_track_faceplate_damage(staffdamage);
			}
			/#
				iprintlnbold((("" + staffdamage) + "") + (self.health - staffdamage));
			#/
			if(!isdefined(self.explosive_dmg_taken))
			{
				self.explosive_dmg_taken = 0;
			}
			self.explosive_dmg_taken = self.explosive_dmg_taken + staffdamage;
			if(isdefined(level.mechz_explosive_damage_reaction_callback))
			{
				self [[level.mechz_explosive_damage_reaction_callback]]();
			}
			return staffdamage;
		}
	}
	if(isdefined(level.mechz_explosive_damage_reaction_callback))
	{
		if(isdefined(mod) && mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE")
		{
			n_mechz_damage_percentage = 0.5;
			if(isdefined(attacker) && isplayer(attacker) && isalive(attacker) && (level.zombie_vars[attacker.team]["zombie_insta_kill"] || (isdefined(attacker.personal_instakill) && attacker.personal_instakill)))
			{
				n_mechz_damage_percentage = 1;
			}
			explosive_damage = damage * n_mechz_damage_percentage;
			if(!isdefined(self.explosive_dmg_taken))
			{
				self.explosive_dmg_taken = 0;
			}
			self.explosive_dmg_taken = self.explosive_dmg_taken + explosive_damage;
			if(isdefined(self.has_faceplate) && self.has_faceplate)
			{
				self mechz_track_faceplate_damage(explosive_damage);
			}
			self [[level.mechz_explosive_damage_reaction_callback]]();
			/#
				iprintlnbold((("" + explosive_damage) + "") + (self.health - explosive_damage));
			#/
			return explosive_damage;
		}
	}
	if(hitloc == "head")
	{
		attacker show_hit_marker();
		/#
			iprintlnbold((("" + damage) + "") + (self.health - damage));
		#/
		return damage;
	}
	if(hitloc !== "none")
	{
		switch(hitloc)
		{
			case "torso_upper":
			{
				if(self.has_faceplate == 1)
				{
					faceplate_pos = self gettagorigin("j_faceplate");
					dist_sq = distancesquared(faceplate_pos, point);
					if(dist_sq <= 144)
					{
						self mechz_track_faceplate_damage(damage);
						attacker show_hit_marker();
					}
					headlamp_dist_sq = distancesquared(point, self gettagorigin("tag_headlamp_FX"));
					if(headlamp_dist_sq <= 9)
					{
						self mechz_turn_off_headlamp(1);
					}
				}
				partname = getpartname("c_zom_mech_body", boneindex);
				if(self.powercap_covered === 1 && (partname === "tag_powersupply" || partname === "tag_powersupply_hit"))
				{
					self mechz_track_powercap_cover_damage(damage);
					attacker show_hit_marker();
					/#
						iprintlnbold((("" + (damage * 0.1)) + "") + (self.health - (damage * 0.1)));
					#/
					return damage * 0.1;
				}
				else
				{
					if(self.powercap_covered !== 1 && self.has_powercap === 1 && (partname === "tag_powersupply" || partname === "tag_powersupply_hit"))
					{
						self mechz_track_powercap_damage(damage);
						attacker show_hit_marker();
						/#
							iprintlnbold((("" + damage) + "") + (self.health - damage));
						#/
						return damage;
					}
					else if(self.powercap_covered !== 1 && self.has_powercap !== 1 && (partname === "tag_powersupply" || partname === "tag_powersupply_hit"))
					{
						/#
							iprintlnbold((("" + (damage * 0.5)) + "") + (self.health - (damage * 0.5)));
						#/
						attacker show_hit_marker();
						return damage * 0.5;
					}
				}
				if(self.has_right_shoulder_armor === 1 && partname === "j_shoulderarmor_ri")
				{
					self mechz_track_rshoulder_armor_damage(damage);
					/#
						iprintlnbold((("" + (damage * 0.1)) + "") + (self.health - (damage * 0.1)));
					#/
					return damage * 0.1;
				}
				if(self.has_left_shoulder_armor === 1 && partname === "j_shoulderarmor_le")
				{
					self mechz_track_lshoulder_armor_damage(damage);
					/#
						iprintlnbold((("" + (damage * 0.1)) + "") + (self.health - (damage * 0.1)));
					#/
					return damage * 0.1;
				}
				/#
					iprintlnbold((("" + (damage * 0.1)) + "") + (self.health - (damage * 0.1)));
				#/
				return damage * 0.1;
				break;
			}
			case "left_leg_lower":
			{
				partname = getpartname("c_zom_mech_body", boneindex);
				if(partname === "j_knee_attach_le" && self.has_left_knee_armor === 1)
				{
					self mechz_track_lknee_armor_damage(damage);
				}
				/#
					iprintlnbold((("" + (damage * 0.1)) + "") + (self.health - (damage * 0.1)));
				#/
				return damage * 0.1;
				break;
			}
			case "right_leg_lower":
			{
				partname = getpartname("c_zom_mech_body", boneindex);
				if(partname === "j_knee_attach_ri" && self.has_right_knee_armor === 1)
				{
					self mechz_track_rknee_armor_damage(damage);
				}
				/#
					iprintlnbold((("" + (damage * 0.1)) + "") + (self.health - (damage * 0.1)));
				#/
				return damage * 0.1;
				break;
			}
			case "left_arm_lower":
			case "left_arm_upper":
			case "left_hand":
			{
				if(isdefined(level.mechz_left_arm_damage_callback))
				{
					self [[level.mechz_left_arm_damage_callback]]();
				}
				/#
					iprintlnbold((("" + (damage * 0.1)) + "") + (self.health - (damage * 0.1)));
				#/
				return damage * 0.1;
				break;
			}
			default:
			{
				/#
					iprintlnbold((("" + (damage * 0.1)) + "") + (self.health - (damage * 0.1)));
				#/
				return damage * 0.1;
				break;
			}
		}
	}
	if(mod == "MOD_PROJECTILE")
	{
		hit_damage = damage * 0.1;
		if(self.has_faceplate !== 1)
		{
			head_pos = self gettagorigin("tag_eye");
			dist_sq = distancesquared(head_pos, point);
			if(dist_sq <= 144)
			{
				/#
					iprintlnbold((("" + damage) + "") + (self.health - damage));
				#/
				attacker show_hit_marker();
				return damage;
			}
		}
		if(self.has_faceplate === 1)
		{
			faceplate_pos = self gettagorigin("j_faceplate");
			dist_sq = distancesquared(faceplate_pos, point);
			if(dist_sq <= 144)
			{
				self mechz_track_faceplate_damage(damage);
				attacker show_hit_marker();
			}
			headlamp_dist_sq = distancesquared(point, self gettagorigin("tag_headlamp_FX"));
			if(headlamp_dist_sq <= 9)
			{
				self mechz_turn_off_headlamp(1);
			}
		}
		power_pos = self gettagorigin("tag_powersupply_hit");
		power_dist_sq = distancesquared(power_pos, point);
		if(power_dist_sq <= 25)
		{
			if(self.powercap_covered !== 1 && self.has_powercap !== 1)
			{
				/#
					iprintlnbold((("" + damage) + "") + (self.health - damage));
				#/
				attacker show_hit_marker();
				return damage;
			}
			if(self.powercap_covered !== 1 && self.has_powercap === 1)
			{
				self mechz_track_powercap_damage(damage);
				attacker show_hit_marker();
				/#
					iprintlnbold((("" + damage) + "") + (self.health - damage));
				#/
				return damage;
			}
			if(self.powercap_covered === 1)
			{
				self mechz_track_powercap_cover_damage(damage);
				attacker show_hit_marker();
			}
		}
		if(self.has_right_shoulder_armor === 1)
		{
			armor_pos = self gettagorigin("j_shoulderarmor_ri");
			dist_sq = distancesquared(armor_pos, point);
			if(dist_sq <= 64)
			{
				self mechz_track_rshoulder_armor_damage(damage);
			}
		}
		if(self.has_left_shoulder_armor === 1)
		{
			armor_pos = self gettagorigin("j_shoulderarmor_le");
			dist_sq = distancesquared(armor_pos, point);
			if(dist_sq <= 64)
			{
				self mechz_track_lshoulder_armor_damage(damage);
			}
		}
		if(self.has_right_knee_armor === 1)
		{
			armor_pos = self gettagorigin("j_knee_attach_ri");
			dist_sq = distancesquared(armor_pos, point);
			if(dist_sq <= 36)
			{
				self mechz_track_rknee_armor_damage(damage);
			}
		}
		if(self.has_left_knee_armor === 1)
		{
			armor_pos = self gettagorigin("j_knee_attach_le");
			dist_sq = distancesquared(armor_pos, point);
			if(dist_sq <= 36)
			{
				self mechz_track_lknee_armor_damage(damage);
			}
		}
		/#
			iprintlnbold((("" + hit_damage) + "") + (self.health - hit_damage));
		#/
		return hit_damage;
	}
	if(mod == "MOD_PROJECTILE_SPLASH")
	{
		hit_damage = damage * 0.2;
		i_num_armor_pieces = 0;
		if(isdefined(level.mechz_faceplate_damage_override))
		{
			self [[level.mechz_faceplate_damage_override]](inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex);
		}
		if(self.has_right_shoulder_armor === 1)
		{
			i_num_armor_pieces = i_num_armor_pieces + 1;
			right_shoulder_index = i_num_armor_pieces;
		}
		if(self.has_left_shoulder_armor === 1)
		{
			i_num_armor_pieces = i_num_armor_pieces + 1;
			left_shoulder_index = i_num_armor_pieces;
		}
		if(self.has_right_knee_armor === 1)
		{
			i_num_armor_pieces = i_num_armor_pieces + 1;
			right_knee_index = i_num_armor_pieces;
		}
		if(self.has_left_knee_armor === 1)
		{
			i_num_armor_pieces = i_num_armor_pieces + 1;
			left_knee_index = i_num_armor_pieces;
		}
		if(i_num_armor_pieces > 0)
		{
			if(i_num_armor_pieces <= 1)
			{
				i_random = 0;
			}
			else
			{
				i_random = randomint(i_num_armor_pieces - 1);
			}
			i_random = i_random + 1;
			if(self.has_right_shoulder_armor === 1 && right_shoulder_index === i_random)
			{
				self mechz_track_rshoulder_armor_damage(damage);
			}
			if(self.has_left_shoulder_armor === 1 && left_shoulder_index === i_random)
			{
				self mechz_track_lshoulder_armor_damage(damage);
			}
			if(self.has_right_knee_armor === 1 && right_knee_index === i_random)
			{
				self mechz_track_rknee_armor_damage(damage);
			}
			if(self.has_left_knee_armor === 1 && left_knee_index === i_random)
			{
				self mechz_track_lknee_armor_damage(damage);
			}
		}
		else
		{
			if(self.powercap_covered === 1)
			{
				self mechz_track_powercap_cover_damage(damage * 0.5);
			}
			if(self.has_faceplate == 1)
			{
				self mechz_track_faceplate_damage(damage * 0.5);
			}
		}
		/#
			iprintlnbold((("" + hit_damage) + "") + (self.health - hit_damage));
		#/
		return hit_damage;
	}
	return 0;
}

/*
	Name: mechzweapondamagemodifier
	Namespace: mechzserverutils
	Checksum: 0xC06BDF2F
	Offset: 0x4CD8
	Size: 0x14A
	Parameters: 2
	Flags: Private
*/
function private mechzweapondamagemodifier(damage, weapon)
{
	if(isdefined(weapon) && isdefined(weapon.name))
	{
		if(issubstr(weapon.name, "shotgun_fullauto"))
		{
			return damage * 0.5;
		}
		if(issubstr(weapon.name, "lmg_cqb"))
		{
			return damage * 0.65;
		}
		if(issubstr(weapon.name, "lmg_heavy"))
		{
			return damage * 0.65;
		}
		if(issubstr(weapon.name, "shotgun_precision"))
		{
			return damage * 0.65;
		}
		if(issubstr(weapon.name, "shotgun_semiauto"))
		{
			return damage * 0.75;
		}
	}
	return damage;
}

/*
	Name: mechz_play_pain_audio
	Namespace: mechzserverutils
	Checksum: 0xA5E536CA
	Offset: 0x4E30
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function mechz_play_pain_audio()
{
	self playsound("zmb_ai_mechz_destruction");
}

/*
	Name: show_hit_marker
	Namespace: mechzserverutils
	Checksum: 0x66F41B19
	Offset: 0x4E60
	Size: 0x88
	Parameters: 0
	Flags: None
*/
function show_hit_marker()
{
	if(isdefined(self) && isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback setshader("damage_feedback", 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeovertime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

/*
	Name: hide_part
	Namespace: mechzserverutils
	Checksum: 0x809EA9DF
	Offset: 0x4EF0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function hide_part(strtag)
{
	if(self haspart(strtag))
	{
		self hidepart(strtag);
	}
}

/*
	Name: mechz_track_faceplate_damage
	Namespace: mechzserverutils
	Checksum: 0x47D1BA10
	Offset: 0x4F38
	Size: 0xE2
	Parameters: 1
	Flags: None
*/
function mechz_track_faceplate_damage(damage)
{
	self.faceplate_health = self.faceplate_health - damage;
	if(self.faceplate_health <= 0)
	{
		self hide_part("j_faceplate");
		self clientfield::set("mechz_faceplate_detached", 1);
		self.has_faceplate = 0;
		self mechz_turn_off_headlamp();
		self.partdestroyed = 1;
		blackboard::setblackboardattribute(self, "_mechz_part", "mechz_faceplate");
		self mechzbehavior::mechzgoberserk();
		level notify(#"mechz_faceplate_detached");
	}
}

/*
	Name: mechz_track_powercap_cover_damage
	Namespace: mechzserverutils
	Checksum: 0x6A0D5B24
	Offset: 0x5028
	Size: 0xAC
	Parameters: 1
	Flags: None
*/
function mechz_track_powercap_cover_damage(damage)
{
	self.powercap_cover_health = self.powercap_cover_health - damage;
	if(self.powercap_cover_health <= 0)
	{
		self hide_part("tag_powersupply");
		self clientfield::set("mechz_powercap_detached", 1);
		self.powercap_covered = 0;
		self.partdestroyed = 1;
		blackboard::setblackboardattribute(self, "_mechz_part", "mechz_powercore");
	}
}

/*
	Name: mechz_track_powercap_damage
	Namespace: mechzserverutils
	Checksum: 0x6208F9B8
	Offset: 0x50E0
	Size: 0x1A2
	Parameters: 1
	Flags: None
*/
function mechz_track_powercap_damage(damage)
{
	self.powercap_health = self.powercap_health - damage;
	if(self.powercap_health <= 0)
	{
		if(isdefined(level.mechz_powercap_destroyed_callback))
		{
			self [[level.mechz_powercap_destroyed_callback]]();
		}
		self hide_part("tag_gun_spin");
		self hide_part("tag_gun_barrel1");
		self hide_part("tag_gun_barrel2");
		self hide_part("tag_gun_barrel3");
		self hide_part("tag_gun_barrel4");
		self hide_part("tag_gun_barrel5");
		self hide_part("tag_gun_barrel6");
		self clientfield::set("mechz_claw_detached", 1);
		self.has_powercap = 0;
		self.gun_attached = 0;
		self.partdestroyed = 1;
		blackboard::setblackboardattribute(self, "_mechz_part", "mechz_gun");
		level notify(#"mechz_gun_detached");
	}
}

/*
	Name: mechz_track_rknee_armor_damage
	Namespace: mechzserverutils
	Checksum: 0x5A9426F1
	Offset: 0x5290
	Size: 0x78
	Parameters: 1
	Flags: None
*/
function mechz_track_rknee_armor_damage(damage)
{
	self.right_knee_armor_health = self.right_knee_armor_health - damage;
	if(self.right_knee_armor_health <= 0)
	{
		self hide_part("j_knee_attach_ri");
		self clientfield::set("mechz_rknee_armor_detached", 1);
		self.has_right_knee_armor = 0;
	}
}

/*
	Name: mechz_track_lknee_armor_damage
	Namespace: mechzserverutils
	Checksum: 0x71910697
	Offset: 0x5310
	Size: 0x78
	Parameters: 1
	Flags: None
*/
function mechz_track_lknee_armor_damage(damage)
{
	self.left_knee_armor_health = self.left_knee_armor_health - damage;
	if(self.left_knee_armor_health <= 0)
	{
		self hide_part("j_knee_attach_le");
		self clientfield::set("mechz_lknee_armor_detached", 1);
		self.has_left_knee_armor = 0;
	}
}

/*
	Name: mechz_track_rshoulder_armor_damage
	Namespace: mechzserverutils
	Checksum: 0xDDD26758
	Offset: 0x5390
	Size: 0x78
	Parameters: 1
	Flags: None
*/
function mechz_track_rshoulder_armor_damage(damage)
{
	self.right_shoulder_armor_health = self.right_shoulder_armor_health - damage;
	if(self.right_shoulder_armor_health <= 0)
	{
		self hide_part("j_shoulderarmor_ri");
		self clientfield::set("mechz_rshoulder_armor_detached", 1);
		self.has_right_shoulder_armor = 0;
	}
}

/*
	Name: mechz_track_lshoulder_armor_damage
	Namespace: mechzserverutils
	Checksum: 0x38E7245D
	Offset: 0x5410
	Size: 0x78
	Parameters: 1
	Flags: None
*/
function mechz_track_lshoulder_armor_damage(damage)
{
	self.left_shoulder_armor_health = self.left_shoulder_armor_health - damage;
	if(self.left_shoulder_armor_health <= 0)
	{
		self hide_part("j_shoulderarmor_le");
		self clientfield::set("mechz_lshoulder_armor_detached", 1);
		self.has_left_shoulder_armor = 0;
	}
}

/*
	Name: mechzcheckinarc
	Namespace: mechzserverutils
	Checksum: 0x603F88AF
	Offset: 0x5490
	Size: 0x224
	Parameters: 2
	Flags: None
*/
function mechzcheckinarc(right_offset, aim_tag)
{
	origin = self.origin;
	angles = self.angles;
	if(isdefined(aim_tag))
	{
		origin = self gettagorigin(aim_tag);
		angles = self gettagangles(aim_tag);
	}
	if(isdefined(right_offset))
	{
		right_angle = anglestoright(angles);
		origin = origin + (right_angle * right_offset);
	}
	facing_vec = anglestoforward(angles);
	enemy_vec = self.favoriteenemy.origin - origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = vectornormalize(enemy_yaw_vec);
	facing_yaw_vec = vectornormalize(facing_yaw_vec);
	enemy_dot = vectordot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0.5)
	{
		return false;
	}
	enemy_angles = vectortoangles(enemy_vec);
	if(abs(angleclamp180(enemy_angles[0])) > 60)
	{
		return false;
	}
	return true;
}

/*
	Name: mechzgrenadecheckinarc
	Namespace: mechzserverutils
	Checksum: 0x51DEDCCE
	Offset: 0x56C0
	Size: 0x1C4
	Parameters: 1
	Flags: Private
*/
function private mechzgrenadecheckinarc(right_offset)
{
	origin = self.origin;
	if(isdefined(right_offset))
	{
		right_angle = anglestoright(self.angles);
		origin = origin + (right_angle * right_offset);
	}
	facing_vec = anglestoforward(self.angles);
	enemy_vec = self.favoriteenemy.origin - origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = vectornormalize(enemy_yaw_vec);
	facing_yaw_vec = vectornormalize(facing_yaw_vec);
	enemy_dot = vectordot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0.5)
	{
		return false;
	}
	enemy_angles = vectortoangles(enemy_vec);
	if(abs(angleclamp180(enemy_angles[0])) > 60)
	{
		return false;
	}
	return true;
}

/*
	Name: mechz_turn_off_headlamp
	Namespace: mechzserverutils
	Checksum: 0x2830C23D
	Offset: 0x5890
	Size: 0x64
	Parameters: 1
	Flags: None
*/
function mechz_turn_off_headlamp(headlamp_broken)
{
	if(headlamp_broken !== 1)
	{
		self clientfield::set("mechz_headlamp_off", 1);
	}
	else
	{
		self clientfield::set("mechz_headlamp_off", 2);
	}
}

