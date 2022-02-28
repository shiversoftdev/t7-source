// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_zombie_interface;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
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

#namespace zombiebehavior;

/*
	Name: init
	Namespace: zombiebehavior
	Checksum: 0xEABD0F58
	Offset: 0xD08
	Size: 0x124
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzombiebehaviorsandasm();
	spawner::add_archetype_spawn_function("zombie", &archetypezombieblackboardinit);
	spawner::add_archetype_spawn_function("zombie", &archetypezombiedeathoverrideinit);
	spawner::add_archetype_spawn_function("zombie", &archetypezombiespecialeffectsinit);
	spawner::add_archetype_spawn_function("zombie", &zombie_utility::zombiespawnsetup);
	clientfield::register("actor", "zombie", 1, 1, "int");
	clientfield::register("actor", "zombie_special_day", 6001, 1, "counter");
	zombieinterface::registerzombieinterfaceattributes();
}

/*
	Name: initzombiebehaviorsandasm
	Namespace: zombiebehavior
	Checksum: 0xAAE773BD
	Offset: 0xE38
	Size: 0x6F4
	Parameters: 0
	Flags: Linked, Private
*/
function private initzombiebehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreeaction("zombieMoveAction", &zombiemoveaction, &zombiemoveactionupdate, undefined);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieTargetService", &zombietargetservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieCrawlerCollisionService", &zombiecrawlercollision);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieTraversalService", &zombietraversalservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsAtAttackObject", &zombieisatattackobject);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldAttackObject", &zombieshouldattackobject);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldMelee", &zombieshouldmeleecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldJumpMelee", &zombieshouldjumpmeleecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldJumpUnderwaterMelee", &zombieshouldjumpunderwatermelee);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieGibLegsCondition", &zombiegiblegscondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldDisplayPain", &zombieshoulddisplaypain);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isZombieWalking", &iszombiewalking);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldMeleeSuicide", &zombieshouldmeleesuicide);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieMeleeSuicideStart", &zombiemeleesuicidestart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieMeleeSuicideUpdate", &zombiemeleesuicideupdate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieMeleeSuicideTerminate", &zombiemeleesuicideterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldJuke", &zombieshouldjukecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieJukeActionStart", &zombiejukeactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieJukeActionTerminate", &zombiejukeactionterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieDeathAction", &zombiedeathaction);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieJukeService", &zombiejuke);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieStumbleService", &zombiestumble);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieStumbleCondition", &zombieshouldstumblecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieStumbleActionStart", &zombiestumbleactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieAttackObjectStart", &zombieattackobjectstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieAttackObjectTerminate", &zombieattackobjectterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("wasKilledByInterdimensionalGun", &waskilledbyinterdimensionalguncondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("wasCrushedByInterdimensionalGunBlackhole", &wascrushedbyinterdimensionalgunblackholecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIDGunDeathUpdate", &zombieidgundeathupdate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieVortexPullUpdate", &zombieidgundeathupdate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieHasLegs", &zombiehaslegs);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldProceduralTraverse", &zombieshouldproceduraltraverse);
	animationstatenetwork::registernotetrackhandlerfunction("zombie_melee", &zombienotetrackmeleefire);
	animationstatenetwork::registernotetrackhandlerfunction("crushed", &zombienotetrackcrushfire);
	animationstatenetwork::registeranimationmocomp("mocomp_death_idgun@zombie", &zombieidgundeathmocompstart, undefined, undefined);
	animationstatenetwork::registeranimationmocomp("mocomp_vortex_pull@zombie", &zombieidgundeathmocompstart, undefined, undefined);
	animationstatenetwork::registeranimationmocomp("mocomp_death_idgun_hole@zombie", &zombieidgunholedeathmocompstart, undefined, &zombieidgunholedeathmocompterminate);
	animationstatenetwork::registeranimationmocomp("mocomp_turn@zombie", &zombieturnmocompstart, &zombieturnmocompupdate, &zombieturnmocompterminate);
	animationstatenetwork::registeranimationmocomp("mocomp_melee_jump@zombie", &zombiemeleejumpmocompstart, &zombiemeleejumpmocompupdate, &zombiemeleejumpmocompterminate);
	animationstatenetwork::registeranimationmocomp("mocomp_zombie_idle@zombie", &zombiezombieidlemocompstart, undefined, undefined);
	animationstatenetwork::registeranimationmocomp("mocomp_attack_object@zombie", &zombieattackobjectmocompstart, &zombieattackobjectmocompupdate, undefined);
}

/*
	Name: archetypezombieblackboardinit
	Namespace: zombiebehavior
	Checksum: 0x474E1C3A
	Offset: 0x1538
	Size: 0x5B4
	Parameters: 0
	Flags: Linked
*/
function archetypezombieblackboardinit()
{
	blackboard::createblackboardforentity(self);
	self aiutility::registerutilityblackboardattributes();
	ai::createinterfaceforentity(self);
	blackboard::registerblackboardattribute(self, "_arms_position", "arms_up", &bb_getarmsposition);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_locomotion_speed", "locomotion_speed_walk", &bb_getlocomotionspeedtype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_has_legs", "has_legs_yes", &bb_gethaslegsstatus);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_variant_type", 0, &bb_getvarianttype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_which_board_pull", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_board_attack_spot", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_grapple_direction", undefined, undefined);
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
	blackboard::registerblackboardattribute(self, "_idgun_damage_direction", "back", &bb_idgungetdamagedirection);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_low_gravity_variant", 0, &bb_getlowgravityvariant);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_knockdown_direction", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_knockdown_type", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_whirlwind_speed", "whirlwind_normal", undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_zombie_blackholebomb_pull_state", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	self.___archetypeonanimscriptedcallback = &archetypezombieonanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: archetypezombieonanimscriptedcallback
	Namespace: zombiebehavior
	Checksum: 0xBCDF9E74
	Offset: 0x1AF8
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypezombieonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypezombieblackboardinit();
}

/*
	Name: archetypezombiespecialeffectsinit
	Namespace: zombiebehavior
	Checksum: 0xEDF73A18
	Offset: 0x1B38
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function archetypezombiespecialeffectsinit()
{
	aiutility::addaioverridedamagecallback(self, &archetypezombiespecialeffectscallback);
}

/*
	Name: archetypezombiespecialeffectscallback
	Namespace: zombiebehavior
	Checksum: 0x844B21F7
	Offset: 0x1B68
	Size: 0xF8
	Parameters: 13
	Flags: Linked, Private
*/
function private archetypezombiespecialeffectscallback(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname)
{
	specialdayeffectchance = getdvarint("tu6_ffotd_zombieSpecialDayEffectsChance", 0);
	if(specialdayeffectchance && randomint(100) < specialdayeffectchance)
	{
		if(isdefined(eattacker) && isplayer(eattacker))
		{
			self clientfield::increment("zombie_special_day");
		}
	}
	return idamage;
}

/*
	Name: bb_getarmsposition
	Namespace: zombiebehavior
	Checksum: 0xEFC1A862
	Offset: 0x1C68
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function bb_getarmsposition()
{
	if(isdefined(self.zombie_arms_position))
	{
		if(self.zombie_arms_position == "up")
		{
			return "arms_up";
		}
		return "arms_down";
	}
	return "arms_up";
}

/*
	Name: bb_getlocomotionspeedtype
	Namespace: zombiebehavior
	Checksum: 0x3CE7253E
	Offset: 0x1CB0
	Size: 0xF2
	Parameters: 0
	Flags: Linked
*/
function bb_getlocomotionspeedtype()
{
	if(isdefined(self.zombie_move_speed))
	{
		if(self.zombie_move_speed == "walk")
		{
			return "locomotion_speed_walk";
		}
		if(self.zombie_move_speed == "run")
		{
			return "locomotion_speed_run";
		}
		if(self.zombie_move_speed == "sprint")
		{
			return "locomotion_speed_sprint";
		}
		if(self.zombie_move_speed == "super_sprint")
		{
			return "locomotion_speed_super_sprint";
		}
		if(self.zombie_move_speed == "jump_pad_super_sprint")
		{
			return "locomotion_speed_jump_pad_super_sprint";
		}
		if(self.zombie_move_speed == "burned")
		{
			return "locomotion_speed_burned";
		}
		if(self.zombie_move_speed == "slide")
		{
			return "locomotion_speed_slide";
		}
	}
	return "locomotion_speed_walk";
}

/*
	Name: bb_getvarianttype
	Namespace: zombiebehavior
	Checksum: 0x90CFFC3C
	Offset: 0x1DB0
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function bb_getvarianttype()
{
	if(isdefined(self.variant_type))
	{
		return self.variant_type;
	}
	return 0;
}

/*
	Name: bb_gethaslegsstatus
	Namespace: zombiebehavior
	Checksum: 0x1D2BC77F
	Offset: 0x1DD8
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function bb_gethaslegsstatus()
{
	if(self.missinglegs)
	{
		return "has_legs_no";
	}
	return "has_legs_yes";
}

/*
	Name: bb_getshouldturn
	Namespace: zombiebehavior
	Checksum: 0x58256513
	Offset: 0x1E00
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function bb_getshouldturn()
{
	if(isdefined(self.should_turn) && self.should_turn)
	{
		return "should_turn";
	}
	return "should_not_turn";
}

/*
	Name: bb_idgungetdamagedirection
	Namespace: zombiebehavior
	Checksum: 0x61257325
	Offset: 0x1E38
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function bb_idgungetdamagedirection()
{
	if(isdefined(self.damage_direction))
	{
		return self.damage_direction;
	}
	return self aiutility::bb_getdamagedirection();
}

/*
	Name: bb_getlowgravityvariant
	Namespace: zombiebehavior
	Checksum: 0x5FBF48FE
	Offset: 0x1E70
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function bb_getlowgravityvariant()
{
	if(isdefined(self.low_gravity_variant))
	{
		return self.low_gravity_variant;
	}
	return 0;
}

/*
	Name: iszombiewalking
	Namespace: zombiebehavior
	Checksum: 0xC6CC2638
	Offset: 0x1E98
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function iszombiewalking(behaviortreeentity)
{
	return !(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs);
}

/*
	Name: zombieshoulddisplaypain
	Namespace: zombiebehavior
	Checksum: 0x9A38B6A1
	Offset: 0x1ED0
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function zombieshoulddisplaypain(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.suicidaldeath) && behaviortreeentity.suicidaldeath)
	{
		return 0;
	}
	return !(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs);
}

/*
	Name: zombieshouldjukecondition
	Namespace: zombiebehavior
	Checksum: 0x4B04AD93
	Offset: 0x1F30
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function zombieshouldjukecondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.juke) && (behaviortreeentity.juke == "left" || behaviortreeentity.juke == "right"))
	{
		return true;
	}
	return false;
}

/*
	Name: zombieshouldstumblecondition
	Namespace: zombiebehavior
	Checksum: 0xAE83B099
	Offset: 0x1F98
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function zombieshouldstumblecondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.stumble))
	{
		return true;
	}
	return false;
}

/*
	Name: zombiejukeactionstart
	Namespace: zombiebehavior
	Checksum: 0x9D6F04C9
	Offset: 0x1FC8
	Size: 0xB6
	Parameters: 1
	Flags: Linked, Private
*/
function private zombiejukeactionstart(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_juke_direction", behaviortreeentity.juke);
	if(isdefined(behaviortreeentity.jukedistance))
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_juke_distance", behaviortreeentity.jukedistance);
	}
	else
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_juke_distance", "short");
	}
	behaviortreeentity.jukedistance = undefined;
	behaviortreeentity.juke = undefined;
}

/*
	Name: zombiejukeactionterminate
	Namespace: zombiebehavior
	Checksum: 0x34258B7F
	Offset: 0x2088
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private zombiejukeactionterminate(behaviortreeentity)
{
	behaviortreeentity clearpath();
}

/*
	Name: zombiestumbleactionstart
	Namespace: zombiebehavior
	Checksum: 0x34C6476B
	Offset: 0x20B8
	Size: 0x1A
	Parameters: 1
	Flags: Linked, Private
*/
function private zombiestumbleactionstart(behaviortreeentity)
{
	behaviortreeentity.stumble = undefined;
}

/*
	Name: zombieattackobjectstart
	Namespace: zombiebehavior
	Checksum: 0xCEFCFBFC
	Offset: 0x20E0
	Size: 0x20
	Parameters: 1
	Flags: Linked, Private
*/
function private zombieattackobjectstart(behaviortreeentity)
{
	behaviortreeentity.is_inert = 1;
}

/*
	Name: zombieattackobjectterminate
	Namespace: zombiebehavior
	Checksum: 0x750CD3AA
	Offset: 0x2108
	Size: 0x1C
	Parameters: 1
	Flags: Linked, Private
*/
function private zombieattackobjectterminate(behaviortreeentity)
{
	behaviortreeentity.is_inert = 0;
}

/*
	Name: zombiegiblegscondition
	Namespace: zombiebehavior
	Checksum: 0x1114B66C
	Offset: 0x2130
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function zombiegiblegscondition(behaviortreeentity)
{
	return gibserverutils::isgibbed(behaviortreeentity, 256) || gibserverutils::isgibbed(behaviortreeentity, 128);
}

/*
	Name: zombienotetrackmeleefire
	Namespace: zombiebehavior
	Checksum: 0xF87AB082
	Offset: 0x2180
	Size: 0x40C
	Parameters: 1
	Flags: Linked
*/
function zombienotetrackmeleefire(entity)
{
	if(isdefined(entity.aat_turned) && entity.aat_turned)
	{
		if(isdefined(entity.enemy) && !isplayer(entity.enemy))
		{
			if(entity.enemy.archetype == "zombie" && (isdefined(entity.enemy.allowdeath) && entity.enemy.allowdeath))
			{
				gibserverutils::gibhead(entity.enemy);
				entity.enemy zombie_utility::gib_random_parts();
				entity.enemy kill();
				entity.n_aat_turned_zombie_kills++;
			}
			else
			{
				if(entity.enemy.archetype == "zombie_quad" || entity.enemy.archetype == "spider" && (isdefined(entity.enemy.allowdeath) && entity.enemy.allowdeath))
				{
					entity.enemy kill();
					entity.n_aat_turned_zombie_kills++;
				}
				else if(isdefined(entity.enemy.canbetargetedbyturnedzombies) && entity.enemy.canbetargetedbyturnedzombies)
				{
					entity melee();
				}
			}
		}
	}
	else
	{
		if(isdefined(entity.enemy) && (isdefined(entity.enemy.bgb_in_plain_sight_active) && entity.enemy.bgb_in_plain_sight_active || (isdefined(entity.enemy.bgb_idle_eyes_active) && entity.enemy.bgb_idle_eyes_active)))
		{
			return;
		}
		if(isdefined(entity.enemy) && (isdefined(entity.enemy.allow_zombie_to_target_ai) && entity.enemy.allow_zombie_to_target_ai))
		{
			if(entity.enemy.health > 0)
			{
				entity.enemy dodamage(entity.meleeweapon.meleedamage, entity.origin, entity, entity, "none", "MOD_MELEE");
			}
			return;
		}
		entity melee();
		/#
			record3dtext("", self.origin, (1, 0, 0), "", entity);
		#/
		if(zombieshouldattackobject(entity))
		{
			if(isdefined(level.attackablecallback))
			{
				entity.attackable [[level.attackablecallback]](entity);
			}
		}
	}
}

/*
	Name: zombienotetrackcrushfire
	Namespace: zombiebehavior
	Checksum: 0xED32202C
	Offset: 0x2598
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function zombienotetrackcrushfire(behaviortreeentity)
{
	behaviortreeentity delete();
}

/*
	Name: zombietargetservice
	Namespace: zombiebehavior
	Checksum: 0xD1A39E1F
	Offset: 0x25C8
	Size: 0x2F8
	Parameters: 1
	Flags: Linked
*/
function zombietargetservice(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enablepushtime))
	{
		if(gettime() >= behaviortreeentity.enablepushtime)
		{
			behaviortreeentity pushactors(1);
			behaviortreeentity.enablepushtime = undefined;
		}
	}
	if(isdefined(behaviortreeentity.disabletargetservice) && behaviortreeentity.disabletargetservice)
	{
		return false;
	}
	if(isdefined(behaviortreeentity.ignoreall) && behaviortreeentity.ignoreall)
	{
		return false;
	}
	specifictarget = undefined;
	if(isdefined(level.zombielevelspecifictargetcallback))
	{
		specifictarget = [[level.zombielevelspecifictargetcallback]]();
	}
	if(isdefined(specifictarget))
	{
		behaviortreeentity setgoal(specifictarget.origin);
	}
	else
	{
		if(isdefined(behaviortreeentity.v_zombie_custom_goal_pos))
		{
			goalpos = behaviortreeentity.v_zombie_custom_goal_pos;
			if(isdefined(behaviortreeentity.n_zombie_custom_goal_radius))
			{
				behaviortreeentity.goalradius = behaviortreeentity.n_zombie_custom_goal_radius;
			}
			behaviortreeentity setgoal(goalpos);
		}
		else
		{
			player = zombie_utility::get_closest_valid_player(self.origin, self.ignore_player);
			if(!isdefined(player))
			{
				if(isdefined(self.ignore_player))
				{
					if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
					{
						return false;
					}
					self.ignore_player = [];
				}
				self setgoal(self.origin);
				return false;
			}
			if(isdefined(player.last_valid_position))
			{
				if(!(isdefined(self.zombie_do_not_update_goal) && self.zombie_do_not_update_goal))
				{
					if(isdefined(level.zombie_use_zigzag_path) && level.zombie_use_zigzag_path)
					{
						behaviortreeentity zombieupdatezigzaggoal();
					}
					else
					{
						behaviortreeentity setgoal(player.last_valid_position);
					}
				}
				return true;
			}
			if(!(isdefined(self.zombie_do_not_update_goal) && self.zombie_do_not_update_goal))
			{
				behaviortreeentity setgoal(behaviortreeentity.origin);
			}
			return false;
		}
	}
}

/*
	Name: zombieupdatezigzaggoal
	Namespace: zombiebehavior
	Checksum: 0x1665C52F
	Offset: 0x28C8
	Size: 0x5F4
	Parameters: 0
	Flags: Linked
*/
function zombieupdatezigzaggoal()
{
	aiprofile_beginentry("zombieUpdateZigZagGoal");
	shouldrepath = 0;
	if(!shouldrepath && isdefined(self.favoriteenemy))
	{
		if(!isdefined(self.nextgoalupdate) || self.nextgoalupdate <= gettime())
		{
			shouldrepath = 1;
		}
		else
		{
			if(distancesquared(self.origin, self.favoriteenemy.origin) <= (250 * 250))
			{
				shouldrepath = 1;
			}
			else if(isdefined(self.pathgoalpos))
			{
				distancetogoalsqr = distancesquared(self.origin, self.pathgoalpos);
				shouldrepath = distancetogoalsqr < (72 * 72);
			}
		}
	}
	if(isdefined(self.keep_moving) && self.keep_moving)
	{
		if(gettime() > self.keep_moving_time)
		{
			self.keep_moving = 0;
		}
	}
	if(shouldrepath)
	{
		goalpos = self.favoriteenemy.origin;
		if(isdefined(self.favoriteenemy.last_valid_position))
		{
			goalpos = self.favoriteenemy.last_valid_position;
		}
		self setgoal(goalpos);
		if(distancesquared(self.origin, goalpos) > (250 * 250))
		{
			self.keep_moving = 1;
			self.keep_moving_time = gettime() + 250;
			path = self calcapproximatepathtoposition(goalpos, 0);
			/#
				if(getdvarint(""))
				{
					for(index = 1; index < path.size; index++)
					{
						recordline(path[index - 1], path[index], (1, 0.5, 0), "", self);
					}
				}
			#/
			if(isdefined(level._zombiezigzagdistancemin) && isdefined(level._zombiezigzagdistancemax))
			{
				min = level._zombiezigzagdistancemin;
				max = level._zombiezigzagdistancemax;
			}
			else
			{
				min = 240;
				max = 600;
			}
			deviationdistance = randomintrange(min, max);
			segmentlength = 0;
			for(index = 1; index < path.size; index++)
			{
				currentseglength = distance(path[index - 1], path[index]);
				if((segmentlength + currentseglength) > deviationdistance)
				{
					remaininglength = deviationdistance - segmentlength;
					seedposition = (path[index - 1]) + ((vectornormalize(path[index] - (path[index - 1]))) * remaininglength);
					/#
						recordcircle(seedposition, 2, (1, 0.5, 0), "", self);
					#/
					innerzigzagradius = 0;
					outerzigzagradius = 96;
					queryresult = positionquery_source_navigation(seedposition, innerzigzagradius, outerzigzagradius, 0.5 * 72, 16, self, 16);
					positionquery_filter_inclaimedlocation(queryresult, self);
					if(queryresult.data.size > 0)
					{
						point = queryresult.data[randomint(queryresult.data.size)];
						self setgoal(point.origin);
					}
					break;
				}
				segmentlength = segmentlength + currentseglength;
			}
		}
		if(isdefined(level._zombiezigzagtimemin) && isdefined(level._zombiezigzagtimemax))
		{
			mintime = level._zombiezigzagtimemin;
			maxtime = level._zombiezigzagtimemax;
		}
		else
		{
			mintime = 2500;
			maxtime = 3500;
		}
		self.nextgoalupdate = gettime() + randomintrange(mintime, maxtime);
	}
	aiprofile_endentry();
}

/*
	Name: zombiecrawlercollision
	Namespace: zombiebehavior
	Checksum: 0x69BDCE3B
	Offset: 0x2EC8
	Size: 0x216
	Parameters: 1
	Flags: Linked
*/
function zombiecrawlercollision(behaviortreeentity)
{
	if(!(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs) && (!(isdefined(behaviortreeentity.knockdown) && behaviortreeentity.knockdown)))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.dontpushtime))
	{
		if(gettime() < behaviortreeentity.dontpushtime)
		{
			return true;
		}
	}
	zombies = getaiteamarray(level.zombie_team);
	foreach(zombie in zombies)
	{
		if(zombie == behaviortreeentity)
		{
			continue;
		}
		if(isdefined(zombie.missinglegs) && zombie.missinglegs || (isdefined(zombie.knockdown) && zombie.knockdown))
		{
			continue;
		}
		dist_sq = distancesquared(behaviortreeentity.origin, zombie.origin);
		if(dist_sq < 14400)
		{
			behaviortreeentity pushactors(0);
			behaviortreeentity.dontpushtime = gettime() + 2000;
			return true;
		}
	}
	behaviortreeentity pushactors(1);
	return false;
}

/*
	Name: zombietraversalservice
	Namespace: zombiebehavior
	Checksum: 0x8D3CE993
	Offset: 0x30E8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function zombietraversalservice(entity)
{
	if(isdefined(entity.traversestartnode))
	{
		entity pushactors(0);
		return true;
	}
	return false;
}

/*
	Name: zombieisatattackobject
	Namespace: zombiebehavior
	Checksum: 0xE903DB5E
	Offset: 0x3138
	Size: 0x200
	Parameters: 1
	Flags: Linked
*/
function zombieisatattackobject(entity)
{
	if(isdefined(entity.missinglegs) && entity.missinglegs)
	{
		return false;
	}
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]))
	{
		return false;
	}
	if(isdefined(entity.favoriteenemy) && (isdefined(entity.favoriteenemy.b_is_designated_target) && entity.favoriteenemy.b_is_designated_target))
	{
		return false;
	}
	if(isdefined(entity.aat_turned) && entity.aat_turned)
	{
		return false;
	}
	if(isdefined(entity.attackable) && (isdefined(entity.attackable.is_active) && entity.attackable.is_active))
	{
		if(!isdefined(entity.attackable_slot))
		{
			return false;
		}
		dist = distance2dsquared(entity.origin, entity.attackable_slot.origin);
		if(dist < 256)
		{
			height_offset = abs(entity.origin[2] - entity.attackable_slot.origin[2]);
			if(height_offset < 32)
			{
				entity.is_at_attackable = 1;
				return true;
			}
		}
	}
	return false;
}

/*
	Name: zombieshouldattackobject
	Namespace: zombiebehavior
	Checksum: 0xF0A619F9
	Offset: 0x3340
	Size: 0x14E
	Parameters: 1
	Flags: Linked
*/
function zombieshouldattackobject(entity)
{
	if(isdefined(entity.missinglegs) && entity.missinglegs)
	{
		return false;
	}
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]))
	{
		return false;
	}
	if(isdefined(entity.favoriteenemy) && (isdefined(entity.favoriteenemy.b_is_designated_target) && entity.favoriteenemy.b_is_designated_target))
	{
		return false;
	}
	if(isdefined(entity.aat_turned) && entity.aat_turned)
	{
		return false;
	}
	if(isdefined(entity.attackable) && (isdefined(entity.attackable.is_active) && entity.attackable.is_active))
	{
		if(isdefined(entity.is_at_attackable) && entity.is_at_attackable)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: zombieshouldmeleecondition
	Namespace: zombiebehavior
	Checksum: 0x7C3AA022
	Offset: 0x3498
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function zombieshouldmeleecondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemyoverride) && isdefined(behaviortreeentity.enemyoverride[1]))
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.marked_for_death))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.ignoremelee) && behaviortreeentity.ignoremelee)
	{
		return false;
	}
	if(distancesquared(behaviortreeentity.origin, behaviortreeentity.enemy.origin) > 4096)
	{
		return false;
	}
	yawtoenemy = angleclamp180(behaviortreeentity.angles[1] - (vectortoangles(behaviortreeentity.enemy.origin - behaviortreeentity.origin)[1]));
	if(abs(yawtoenemy) > 60)
	{
		return false;
	}
	return true;
}

/*
	Name: zombieshouldjumpmeleecondition
	Namespace: zombiebehavior
	Checksum: 0xE20E0B6C
	Offset: 0x3608
	Size: 0x2F8
	Parameters: 1
	Flags: Linked
*/
function zombieshouldjumpmeleecondition(behaviortreeentity)
{
	if(!(isdefined(behaviortreeentity.low_gravity) && behaviortreeentity.low_gravity))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.enemyoverride) && isdefined(behaviortreeentity.enemyoverride[1]))
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.marked_for_death))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.ignoremelee) && behaviortreeentity.ignoremelee)
	{
		return false;
	}
	if(behaviortreeentity.enemy isonground())
	{
		return false;
	}
	jumpchance = getdvarfloat("zmMeleeJumpChance", 0.5);
	if(((behaviortreeentity getentitynumber() % 10) / 10) > jumpchance)
	{
		return false;
	}
	predictedposition = behaviortreeentity.enemy.origin + ((behaviortreeentity.enemy getvelocity() * 0.05) * 2);
	jumpdistancesq = pow(getdvarint("zmMeleeJumpDistance", 180), 2);
	if(distance2dsquared(behaviortreeentity.origin, predictedposition) > jumpdistancesq)
	{
		return false;
	}
	yawtoenemy = angleclamp180(behaviortreeentity.angles[1] - (vectortoangles(behaviortreeentity.enemy.origin - behaviortreeentity.origin)[1]));
	if(abs(yawtoenemy) > 60)
	{
		return false;
	}
	heighttoenemy = behaviortreeentity.enemy.origin[2] - behaviortreeentity.origin[2];
	if(heighttoenemy <= getdvarint("zmMeleeJumpHeightDifference", 60))
	{
		return false;
	}
	return true;
}

/*
	Name: zombieshouldjumpunderwatermelee
	Namespace: zombiebehavior
	Checksum: 0x8D53E452
	Offset: 0x3908
	Size: 0x258
	Parameters: 1
	Flags: Linked
*/
function zombieshouldjumpunderwatermelee(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemyoverride) && isdefined(behaviortreeentity.enemyoverride[1]))
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.marked_for_death))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.ignoremelee) && behaviortreeentity.ignoremelee)
	{
		return false;
	}
	if(behaviortreeentity.enemy isonground())
	{
		return false;
	}
	if(behaviortreeentity depthinwater() < 48)
	{
		return false;
	}
	jumpdistancesq = pow(getdvarint("zmMeleeWaterJumpDistance", 64), 2);
	if(distance2dsquared(behaviortreeentity.origin, behaviortreeentity.enemy.origin) > jumpdistancesq)
	{
		return false;
	}
	yawtoenemy = angleclamp180(behaviortreeentity.angles[1] - (vectortoangles(behaviortreeentity.enemy.origin - behaviortreeentity.origin)[1]));
	if(abs(yawtoenemy) > 60)
	{
		return false;
	}
	heighttoenemy = behaviortreeentity.enemy.origin[2] - behaviortreeentity.origin[2];
	if(heighttoenemy <= getdvarint("zmMeleeJumpUnderwaterHeightDifference", 48))
	{
		return false;
	}
	return true;
}

/*
	Name: zombiestumble
	Namespace: zombiebehavior
	Checksum: 0x12859AE1
	Offset: 0x3B68
	Size: 0x1D0
	Parameters: 1
	Flags: Linked
*/
function zombiestumble(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs)
	{
		return false;
	}
	if(!(isdefined(behaviortreeentity.canstumble) && behaviortreeentity.canstumble))
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.zombie_move_speed) || behaviortreeentity.zombie_move_speed != "sprint")
	{
		return false;
	}
	if(isdefined(behaviortreeentity.stumble))
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.next_stumble_time))
	{
		behaviortreeentity.next_stumble_time = gettime() + randomintrange(9000, 12000);
	}
	if(gettime() > behaviortreeentity.next_stumble_time)
	{
		if(randomint(100) < 5)
		{
			closestplayer = arraygetclosest(behaviortreeentity.origin, level.players);
			if(distancesquared(closestplayer.origin, behaviortreeentity.origin) > 50000)
			{
				if(isdefined(behaviortreeentity.next_juke_time))
				{
					behaviortreeentity.next_juke_time = undefined;
				}
				behaviortreeentity.next_stumble_time = undefined;
				behaviortreeentity.stumble = 1;
				return true;
			}
		}
	}
	return false;
}

/*
	Name: zombiejuke
	Namespace: zombiebehavior
	Checksum: 0x4E3E8D48
	Offset: 0x3D40
	Size: 0x3CA
	Parameters: 1
	Flags: Linked
*/
function zombiejuke(behaviortreeentity)
{
	if(!behaviortreeentity ai::has_behavior_attribute("can_juke"))
	{
		return false;
	}
	if(!behaviortreeentity ai::get_behavior_attribute("can_juke"))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs)
	{
		return false;
	}
	if(behaviortreeentity bb_getlocomotionspeedtype() != "locomotion_speed_walk")
	{
		if(behaviortreeentity ai::has_behavior_attribute("spark_behavior") && !behaviortreeentity ai::get_behavior_attribute("spark_behavior"))
		{
			return false;
		}
	}
	if(isdefined(behaviortreeentity.juke))
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.next_juke_time))
	{
		behaviortreeentity.next_juke_time = gettime() + randomintrange(7500, 9500);
	}
	if(gettime() > behaviortreeentity.next_juke_time)
	{
		behaviortreeentity.next_juke_time = undefined;
		if(randomint(100) < 25 || (behaviortreeentity ai::has_behavior_attribute("spark_behavior") && behaviortreeentity ai::get_behavior_attribute("spark_behavior")))
		{
			if(isdefined(behaviortreeentity.next_stumble_time))
			{
				behaviortreeentity.next_stumble_time = undefined;
			}
			forwardoffset = 15;
			behaviortreeentity.ignorebackwardposition = 1;
			if(math::cointoss())
			{
				jukedistance = 101;
				behaviortreeentity.jukedistance = "long";
				switch(behaviortreeentity bb_getlocomotionspeedtype())
				{
					case "locomotion_speed_run":
					case "locomotion_speed_walk":
					{
						forwardoffset = 122;
						break;
					}
					case "locomotion_speed_sprint":
					{
						forwardoffset = 129;
						break;
					}
				}
				behaviortreeentity.juke = aiutility::calculatejukedirection(behaviortreeentity, forwardoffset, jukedistance);
			}
			if(!isdefined(behaviortreeentity.juke) || behaviortreeentity.juke == "forward")
			{
				jukedistance = 69;
				behaviortreeentity.jukedistance = "short";
				switch(behaviortreeentity bb_getlocomotionspeedtype())
				{
					case "locomotion_speed_run":
					case "locomotion_speed_walk":
					{
						forwardoffset = 127;
						break;
					}
					case "locomotion_speed_sprint":
					{
						forwardoffset = 148;
						break;
					}
				}
				behaviortreeentity.juke = aiutility::calculatejukedirection(behaviortreeentity, forwardoffset, jukedistance);
				if(behaviortreeentity.juke == "forward")
				{
					behaviortreeentity.juke = undefined;
					behaviortreeentity.jukedistance = undefined;
					return false;
				}
			}
		}
	}
}

/*
	Name: zombiedeathaction
	Namespace: zombiebehavior
	Checksum: 0x86CE86FC
	Offset: 0x4118
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function zombiedeathaction(behaviortreeentity)
{
}

/*
	Name: waskilledbyinterdimensionalguncondition
	Namespace: zombiebehavior
	Checksum: 0x4F7A2ABF
	Offset: 0x4130
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function waskilledbyinterdimensionalguncondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.interdimensional_gun_kill) && !isdefined(behaviortreeentity.killby_interdimensional_gun_hole) && isalive(behaviortreeentity))
	{
		return true;
	}
	return false;
}

/*
	Name: wascrushedbyinterdimensionalgunblackholecondition
	Namespace: zombiebehavior
	Checksum: 0xA729D1FB
	Offset: 0x4190
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function wascrushedbyinterdimensionalgunblackholecondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.killby_interdimensional_gun_hole))
	{
		return true;
	}
	return false;
}

/*
	Name: zombieidgundeathmocompstart
	Namespace: zombiebehavior
	Checksum: 0x800F8EC9
	Offset: 0x41C0
	Size: 0xCC
	Parameters: 5
	Flags: Linked
*/
function zombieidgundeathmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.angles[1]);
	entity animmode("noclip");
	entity.pushable = 0;
	entity.blockingpain = 1;
	entity pathmode("dont move");
	entity.hole_pull_speed = 0;
}

/*
	Name: zombiemeleejumpmocompstart
	Namespace: zombiebehavior
	Checksum: 0xD022258E
	Offset: 0x4298
	Size: 0xD8
	Parameters: 5
	Flags: Linked
*/
function zombiemeleejumpmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face enemy");
	entity animmode("noclip", 0);
	entity.pushable = 0;
	entity.blockingpain = 1;
	entity.clamptonavmesh = 0;
	entity pushactors(0);
	entity.jumpstartposition = entity.origin;
}

/*
	Name: zombiemeleejumpmocompupdate
	Namespace: zombiebehavior
	Checksum: 0x7B03A47C
	Offset: 0x4378
	Size: 0x2B4
	Parameters: 5
	Flags: Linked
*/
function zombiemeleejumpmocompupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	normalizedtime = ((entity getanimtime(mocompanim) * getanimlength(mocompanim)) + mocompanimblendouttime) / mocompduration;
	if(normalizedtime > 0.5)
	{
		entity orientmode("face angle", entity.angles[1]);
	}
	speed = 5;
	if(isdefined(entity.zombie_move_speed))
	{
		switch(entity.zombie_move_speed)
		{
			case "walk":
			{
				speed = 5;
				break;
			}
			case "run":
			{
				speed = 6;
				break;
			}
			case "sprint":
			{
				speed = 7;
				break;
			}
		}
	}
	newposition = entity.origin + (anglestoforward(entity.angles) * speed);
	newtestposition = (newposition[0], newposition[1], entity.jumpstartposition[2]);
	newvalidposition = getclosestpointonnavmesh(newtestposition, 12, 20);
	if(isdefined(newvalidposition))
	{
		newvalidposition = (newvalidposition[0], newvalidposition[1], entity.origin[2]);
	}
	else
	{
		newvalidposition = entity.origin;
	}
	groundpoint = getclosestpointonnavmesh(newvalidposition, 12, 20);
	if(isdefined(groundpoint) && groundpoint[2] > newvalidposition[2])
	{
		newvalidposition = (newvalidposition[0], newvalidposition[1], groundpoint[2]);
	}
	entity forceteleport(newvalidposition);
}

/*
	Name: zombiemeleejumpmocompterminate
	Namespace: zombiebehavior
	Checksum: 0x59F7C3C8
	Offset: 0x4638
	Size: 0xCC
	Parameters: 5
	Flags: Linked
*/
function zombiemeleejumpmocompterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity.pushable = 1;
	entity.blockingpain = 0;
	entity.clamptonavmesh = 1;
	entity pushactors(1);
	groundpoint = getclosestpointonnavmesh(entity.origin, 12);
	if(isdefined(groundpoint))
	{
		entity forceteleport(groundpoint);
	}
}

/*
	Name: zombieidgundeathupdate
	Namespace: zombiebehavior
	Checksum: 0x65BB6823
	Offset: 0x4710
	Size: 0x3CC
	Parameters: 5
	Flags: Linked
*/
function zombieidgundeathupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	if(!isdefined(entity.killby_interdimensional_gun_hole))
	{
		entity_eye = entity geteye();
		if(entity ispaused())
		{
			entity setignorepauseworld(1);
			entity setentitypaused(0);
		}
		if(entity.b_vortex_repositioned !== 1)
		{
			entity.b_vortex_repositioned = 1;
			v_nearest_navmesh_point = getclosestpointonnavmesh(entity.damageorigin, 36, 15);
			if(isdefined(v_nearest_navmesh_point))
			{
				f_distance = distance(entity.damageorigin, v_nearest_navmesh_point);
				if(f_distance < 41)
				{
					entity.damageorigin = entity.damageorigin + vectorscale((0, 0, 1), 36);
				}
			}
		}
		entity_center = entity.origin + ((entity_eye - entity.origin) / 2);
		flyingdir = entity.damageorigin - entity_center;
		lengthfromhole = length(flyingdir);
		if(lengthfromhole < entity.hole_pull_speed)
		{
			entity.killby_interdimensional_gun_hole = 1;
			entity.allowdeath = 1;
			entity.takedamage = 1;
			entity.aioverridedamage = undefined;
			entity.magic_bullet_shield = 0;
			level notify(#"interdimensional_kill", entity);
			if(isdefined(entity.interdimensional_gun_weapon) && isdefined(entity.interdimensional_gun_attacker))
			{
				entity kill(entity.origin, entity.interdimensional_gun_attacker, entity.interdimensional_gun_attacker, entity.interdimensional_gun_weapon);
			}
			else
			{
				entity kill(entity.origin);
			}
		}
		else
		{
			if(entity.hole_pull_speed < 12)
			{
				entity.hole_pull_speed = entity.hole_pull_speed + 0.5;
				if(entity.hole_pull_speed > 12)
				{
					entity.hole_pull_speed = 12;
				}
			}
			flyingdir = vectornormalize(flyingdir);
			entity forceteleport(entity.origin + (flyingdir * entity.hole_pull_speed));
		}
	}
}

/*
	Name: zombieidgunholedeathmocompstart
	Namespace: zombiebehavior
	Checksum: 0x5DDB645B
	Offset: 0x4AE8
	Size: 0x8C
	Parameters: 5
	Flags: Linked
*/
function zombieidgunholedeathmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.angles[1]);
	entity animmode("noclip");
	entity.pushable = 0;
}

/*
	Name: zombieidgunholedeathmocompterminate
	Namespace: zombiebehavior
	Checksum: 0xC34BAAEE
	Offset: 0x4B80
	Size: 0x6C
	Parameters: 5
	Flags: Linked
*/
function zombieidgunholedeathmocompterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	if(!(isdefined(entity.interdimensional_gun_kill_vortex_explosion) && entity.interdimensional_gun_kill_vortex_explosion))
	{
		entity hide();
	}
}

/*
	Name: zombieturnmocompstart
	Namespace: zombiebehavior
	Checksum: 0x853E9A67
	Offset: 0x4BF8
	Size: 0x7C
	Parameters: 5
	Flags: Linked, Private
*/
function private zombieturnmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.angles[1]);
	entity animmode("angle deltas", 0);
}

/*
	Name: zombieturnmocompupdate
	Namespace: zombiebehavior
	Checksum: 0xDC3F97F7
	Offset: 0x4C80
	Size: 0xAC
	Parameters: 5
	Flags: Linked, Private
*/
function private zombieturnmocompupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	normalizedtime = (entity getanimtime(mocompanim) + mocompanimblendouttime) / mocompduration;
	if(normalizedtime > 0.25)
	{
		entity orientmode("face motion");
		entity animmode("normal", 0);
	}
}

/*
	Name: zombieturnmocompterminate
	Namespace: zombiebehavior
	Checksum: 0x1F398383
	Offset: 0x4D38
	Size: 0x6C
	Parameters: 5
	Flags: Linked, Private
*/
function private zombieturnmocompterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face motion");
	entity animmode("normal", 0);
}

/*
	Name: zombiehaslegs
	Namespace: zombiebehavior
	Checksum: 0xC2BB20E3
	Offset: 0x4DB0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function zombiehaslegs(behaviortreeentity)
{
	if(behaviortreeentity.missinglegs === 1)
	{
		return false;
	}
	return true;
}

/*
	Name: zombieshouldproceduraltraverse
	Namespace: zombiebehavior
	Checksum: 0x6F91D8F6
	Offset: 0x4DE8
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function zombieshouldproceduraltraverse(entity)
{
	return isdefined(entity.traversestartnode) && isdefined(entity.traverseendnode) && entity.traversestartnode.spawnflags & 1024 && entity.traverseendnode.spawnflags & 1024;
}

/*
	Name: zombieshouldmeleesuicide
	Namespace: zombiebehavior
	Checksum: 0x35E021FF
	Offset: 0x4E60
	Size: 0xD0
	Parameters: 1
	Flags: Linked
*/
function zombieshouldmeleesuicide(behaviortreeentity)
{
	if(!behaviortreeentity ai::get_behavior_attribute("suicidal_behavior"))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.magic_bullet_shield) && behaviortreeentity.magic_bullet_shield)
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	if(isdefined(behaviortreeentity.marked_for_death))
	{
		return false;
	}
	if(distancesquared(behaviortreeentity.origin, behaviortreeentity.enemy.origin) > 40000)
	{
		return false;
	}
	return true;
}

/*
	Name: zombiemeleesuicidestart
	Namespace: zombiebehavior
	Checksum: 0x7B333AA4
	Offset: 0x4F38
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function zombiemeleesuicidestart(behaviortreeentity)
{
	behaviortreeentity.blockingpain = 1;
	if(isdefined(level.zombiemeleesuicidecallback))
	{
		behaviortreeentity thread [[level.zombiemeleesuicidecallback]](behaviortreeentity);
	}
}

/*
	Name: zombiemeleesuicideupdate
	Namespace: zombiebehavior
	Checksum: 0x5F0D1E1
	Offset: 0x4F88
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function zombiemeleesuicideupdate(behaviortreeentity)
{
}

/*
	Name: zombiemeleesuicideterminate
	Namespace: zombiebehavior
	Checksum: 0xBA45091
	Offset: 0x4FA0
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function zombiemeleesuicideterminate(behaviortreeentity)
{
	if(isalive(behaviortreeentity) && zombieshouldmeleesuicide(behaviortreeentity))
	{
		behaviortreeentity.takedamage = 1;
		behaviortreeentity.allowdeath = 1;
		if(isdefined(level.zombiemeleesuicidedonecallback))
		{
			behaviortreeentity thread [[level.zombiemeleesuicidedonecallback]](behaviortreeentity);
		}
	}
}

/*
	Name: zombiemoveaction
	Namespace: zombiebehavior
	Checksum: 0xAD33B3B7
	Offset: 0x5030
	Size: 0x150
	Parameters: 2
	Flags: Linked
*/
function zombiemoveaction(behaviortreeentity, asmstatename)
{
	behaviortreeentity.movetime = gettime();
	behaviortreeentity.moveorigin = behaviortreeentity.origin;
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	if(isdefined(behaviortreeentity.stumble) && !isdefined(behaviortreeentity.move_anim_end_time))
	{
		stumbleactionresult = behaviortreeentity astsearch(istring(asmstatename));
		stumbleactionanimation = animationstatenetworkutility::searchanimationmap(behaviortreeentity, stumbleactionresult["animation"]);
		behaviortreeentity.move_anim_end_time = behaviortreeentity.movetime + getanimlength(stumbleactionanimation);
	}
	if(isdefined(behaviortreeentity.zombiemoveactioncallback))
	{
		behaviortreeentity [[behaviortreeentity.zombiemoveactioncallback]](behaviortreeentity);
	}
	return 5;
}

/*
	Name: zombiemoveactionupdate
	Namespace: zombiebehavior
	Checksum: 0x37B8D985
	Offset: 0x5188
	Size: 0x1F2
	Parameters: 2
	Flags: Linked
*/
function zombiemoveactionupdate(behaviortreeentity, asmstatename)
{
	if(isdefined(behaviortreeentity.move_anim_end_time) && gettime() >= behaviortreeentity.move_anim_end_time)
	{
		behaviortreeentity.move_anim_end_time = undefined;
		return 4;
	}
	if(!(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs) && (gettime() - behaviortreeentity.movetime) > 1000)
	{
		distsq = distance2dsquared(behaviortreeentity.origin, behaviortreeentity.moveorigin);
		if(distsq < 144)
		{
			behaviortreeentity setavoidancemask("avoid all");
			behaviortreeentity.cant_move = 1;
			if(isdefined(behaviortreeentity.cant_move_cb))
			{
				behaviortreeentity [[behaviortreeentity.cant_move_cb]]();
			}
		}
		else
		{
			behaviortreeentity setavoidancemask("avoid none");
			behaviortreeentity.cant_move = 0;
		}
		behaviortreeentity.movetime = gettime();
		behaviortreeentity.moveorigin = behaviortreeentity.origin;
	}
	if(behaviortreeentity asmgetstatus() == "asm_status_complete")
	{
		if(behaviortreeentity iscurrentbtactionlooping())
		{
			zombiemoveaction(behaviortreeentity, asmstatename);
		}
		else
		{
			return 4;
		}
	}
	return 5;
}

/*
	Name: zombiemoveactionterminate
	Namespace: zombiebehavior
	Checksum: 0xA0A7B5AD
	Offset: 0x5388
	Size: 0x58
	Parameters: 2
	Flags: None
*/
function zombiemoveactionterminate(behaviortreeentity, asmstatename)
{
	if(!(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs))
	{
		behaviortreeentity setavoidancemask("avoid none");
	}
	return 4;
}

/*
	Name: archetypezombiedeathoverrideinit
	Namespace: zombiebehavior
	Checksum: 0x91AE16F3
	Offset: 0x53E8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function archetypezombiedeathoverrideinit()
{
	aiutility::addaioverridekilledcallback(self, &zombiegibkilledanhilateoverride);
}

/*
	Name: zombiegibkilledanhilateoverride
	Namespace: zombiebehavior
	Checksum: 0x5088DB3E
	Offset: 0x5418
	Size: 0x2F8
	Parameters: 8
	Flags: Linked, Private
*/
function private zombiegibkilledanhilateoverride(inflictor, attacker, damage, meansofdeath, weapon, dir, hitloc, offsettime)
{
	if(!(isdefined(level.zombieanhilationenabled) && level.zombieanhilationenabled))
	{
		return damage;
	}
	if(isdefined(self.forceanhilateondeath) && self.forceanhilateondeath)
	{
		self zombie_utility::gib_random_parts();
		gibserverutils::annihilate(self);
		return damage;
	}
	if(isdefined(attacker) && isplayer(attacker) && (isdefined(attacker.forceanhilateondeath) && attacker.forceanhilateondeath || (isdefined(level.forceanhilateondeath) && level.forceanhilateondeath)))
	{
		self zombie_utility::gib_random_parts();
		gibserverutils::annihilate(self);
		return damage;
	}
	attackerdistance = 0;
	if(isdefined(attacker))
	{
		attackerdistance = distancesquared(attacker.origin, self.origin);
	}
	isexplosive = isinarray(array("MOD_CRUSH", "MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansofdeath);
	if(isdefined(weapon.weapclass) && weapon.weapclass == "turret")
	{
		if(isdefined(inflictor))
		{
			isdirectexplosive = isinarray(array("MOD_GRENADE", "MOD_GRENADE_SPLASH", "MOD_PROJECTILE", "MOD_PROJECTILE_SPLASH", "MOD_EXPLOSIVE"), meansofdeath);
			iscloseexplosive = distancesquared(inflictor.origin, self.origin) <= (60 * 60);
			if(isdirectexplosive && iscloseexplosive)
			{
				self zombie_utility::gib_random_parts();
				gibserverutils::annihilate(self);
			}
		}
	}
	return damage;
}

/*
	Name: zombiezombieidlemocompstart
	Namespace: zombiebehavior
	Checksum: 0x7F9AEEA8
	Offset: 0x5718
	Size: 0x11C
	Parameters: 5
	Flags: Linked, Private
*/
function private zombiezombieidlemocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	if(isdefined(entity.enemyoverride) && isdefined(entity.enemyoverride[1]) && entity != entity.enemyoverride[1])
	{
		entity orientmode("face direction", entity.enemyoverride[1].origin - entity.origin);
		entity animmode("zonly_physics", 0);
	}
	else
	{
		entity orientmode("face current");
		entity animmode("zonly_physics", 0);
	}
}

/*
	Name: zombieattackobjectmocompstart
	Namespace: zombiebehavior
	Checksum: 0x6788C382
	Offset: 0x5840
	Size: 0xD4
	Parameters: 5
	Flags: Linked, Private
*/
function private zombieattackobjectmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	if(isdefined(entity.attackable_slot))
	{
		entity orientmode("face angle", entity.attackable_slot.angles[1]);
		entity animmode("zonly_physics", 0);
	}
	else
	{
		entity orientmode("face current");
		entity animmode("zonly_physics", 0);
	}
}

/*
	Name: zombieattackobjectmocompupdate
	Namespace: zombiebehavior
	Checksum: 0x383C4C0F
	Offset: 0x5920
	Size: 0x6C
	Parameters: 5
	Flags: Linked, Private
*/
function private zombieattackobjectmocompupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	if(isdefined(entity.attackable_slot))
	{
		entity forceteleport(entity.attackable_slot.origin);
	}
}

