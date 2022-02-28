// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\margwa;
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

#namespace margwabehavior;

/*
	Name: init
	Namespace: margwabehavior
	Checksum: 0xA965E697
	Offset: 0xBA8
	Size: 0x374
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initmargwabehaviorsandasm();
	spawner::add_archetype_spawn_function("margwa", &archetypemargwablackboardinit);
	spawner::add_archetype_spawn_function("margwa", &margwaserverutils::margwaspawnsetup);
	clientfield::register("actor", "margwa_head_left", 1, 2, "int");
	clientfield::register("actor", "margwa_head_mid", 1, 2, "int");
	clientfield::register("actor", "margwa_head_right", 1, 2, "int");
	clientfield::register("actor", "margwa_fx_in", 1, 1, "counter");
	clientfield::register("actor", "margwa_fx_out", 1, 1, "counter");
	clientfield::register("actor", "margwa_fx_spawn", 1, 1, "counter");
	clientfield::register("actor", "margwa_smash", 1, 1, "counter");
	clientfield::register("actor", "margwa_head_left_hit", 1, 1, "counter");
	clientfield::register("actor", "margwa_head_mid_hit", 1, 1, "counter");
	clientfield::register("actor", "margwa_head_right_hit", 1, 1, "counter");
	clientfield::register("actor", "margwa_head_killed", 1, 2, "int");
	clientfield::register("actor", "margwa_jaw", 1, 6, "int");
	clientfield::register("toplayer", "margwa_head_explosion", 1, 1, "counter");
	clientfield::register("scriptmover", "margwa_fx_travel", 1, 1, "int");
	clientfield::register("scriptmover", "margwa_fx_travel_tell", 1, 1, "int");
	clientfield::register("actor", "supermargwa", 1, 1, "int");
	initdirecthitweapons();
}

/*
	Name: initdirecthitweapons
	Namespace: margwabehavior
	Checksum: 0xC4888C0D
	Offset: 0xF28
	Size: 0xDE
	Parameters: 0
	Flags: Linked, Private
*/
function private initdirecthitweapons()
{
	if(!isdefined(level.dhweapons))
	{
		level.dhweapons = [];
	}
	level.dhweapons[level.dhweapons.size] = "ray_gun";
	level.dhweapons[level.dhweapons.size] = "ray_gun_upgraded";
	level.dhweapons[level.dhweapons.size] = "pistol_standard_upgraded";
	level.dhweapons[level.dhweapons.size] = "pistol_revolver38_upgraded";
	level.dhweapons[level.dhweapons.size] = "pistol_revolver38lh_upgraded";
	level.dhweapons[level.dhweapons.size] = "launcher_standard";
	level.dhweapons[level.dhweapons.size] = "launcher_standard_upgraded";
}

/*
	Name: adddirecthitweapon
	Namespace: margwabehavior
	Checksum: 0x8767BE64
	Offset: 0x1010
	Size: 0xA2
	Parameters: 1
	Flags: None
*/
function adddirecthitweapon(weaponname)
{
	foreach(weapon in level.dhweapons)
	{
		if(weapon == weaponname)
		{
			return;
		}
	}
	level.dhweapons[level.dhweapons.size] = weaponname;
}

/*
	Name: initmargwabehaviorsandasm
	Namespace: margwabehavior
	Checksum: 0xA7B6071C
	Offset: 0x10C0
	Size: 0x654
	Parameters: 0
	Flags: Linked, Private
*/
function private initmargwabehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaTargetService", &margwatargetservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldSmashAttack", &margwashouldsmashattack);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldSwipeAttack", &margwashouldswipeattack);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldShowPain", &margwashouldshowpain);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldReactStun", &margwashouldreactstun);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldReactIDGun", &margwashouldreactidgun);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldReactSword", &margwashouldreactsword);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldSpawn", &margwashouldspawn);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldFreeze", &margwashouldfreeze);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldTeleportIn", &margwashouldteleportin);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldTeleportOut", &margwashouldteleportout);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldWait", &margwashouldwait);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaShouldReset", &margwashouldreset);
	behaviortreenetworkutility::registerbehaviortreeaction("margwaReactStunAction", &margwareactstunaction, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreeaction("margwaSwipeAttackAction", &margwaswipeattackaction, &margwaswipeattackactionupdate, undefined);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaIdleStart", &margwaidlestart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaMoveStart", &margwamovestart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaTraverseActionStart", &margwatraverseactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaTeleportInStart", &margwateleportinstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaTeleportInTerminate", &margwateleportinterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaTeleportOutStart", &margwateleportoutstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaTeleportOutTerminate", &margwateleportoutterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaPainStart", &margwapainstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaPainTerminate", &margwapainterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaReactStunStart", &margwareactstunstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaReactStunTerminate", &margwareactstunterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaReactIDGunStart", &margwareactidgunstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaReactIDGunTerminate", &margwareactidgunterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaReactSwordStart", &margwareactswordstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaReactSwordTerminate", &margwareactswordterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaSpawnStart", &margwaspawnstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaSmashAttackStart", &margwasmashattackstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaSmashAttackTerminate", &margwasmashattackterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaSwipeAttackStart", &margwaswipeattackstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("margwaSwipeAttackTerminate", &margwaswipeattackterminate);
	animationstatenetwork::registeranimationmocomp("mocomp_teleport_traversal@margwa", &mocompmargwateleporttraversalinit, &mocompmargwateleporttraversalupdate, &mocompmargwateleporttraversalterminate);
	animationstatenetwork::registernotetrackhandlerfunction("margwa_smash_attack", &margwanotetracksmashattack);
	animationstatenetwork::registernotetrackhandlerfunction("margwa_bodyfall large", &margwanotetrackbodyfall);
	animationstatenetwork::registernotetrackhandlerfunction("margwa_melee_fire", &margwanotetrackpainmelee);
}

/*
	Name: archetypemargwablackboardinit
	Namespace: margwabehavior
	Checksum: 0xFA165BD7
	Offset: 0x1720
	Size: 0x1E4
	Parameters: 0
	Flags: Linked, Private
*/
function private archetypemargwablackboardinit()
{
	blackboard::createblackboardforentity(self);
	self aiutility::registerutilityblackboardattributes();
	blackboard::registerblackboardattribute(self, "_locomotion_speed", "locomotion_speed_walk", undefined);
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
	self.___archetypeonanimscriptedcallback = &archetypemargwaonanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: archetypemargwaonanimscriptedcallback
	Namespace: margwabehavior
	Checksum: 0x8CF5C123
	Offset: 0x1910
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private archetypemargwaonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity archetypemargwablackboardinit();
}

/*
	Name: bb_getshouldturn
	Namespace: margwabehavior
	Checksum: 0x4CEB83C0
	Offset: 0x1950
	Size: 0x2A
	Parameters: 0
	Flags: Linked, Private
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
	Name: margwanotetracksmashattack
	Namespace: margwabehavior
	Checksum: 0xA780BA6F
	Offset: 0x1988
	Size: 0x330
	Parameters: 1
	Flags: Linked, Private
*/
function private margwanotetracksmashattack(entity)
{
	players = getplayers();
	foreach(player in players)
	{
		smashpos = entity.origin + vectorscale(anglestoforward(self.angles), 60);
		distsq = distancesquared(smashpos, player.origin);
		if(distsq < 20736)
		{
			if(!isgodmode(player))
			{
				if(isdefined(player.hasriotshield) && player.hasriotshield)
				{
					damageshield = 0;
					attackdir = player.origin - self.origin;
					if(isdefined(player.hasriotshieldequipped) && player.hasriotshieldequipped)
					{
						if(player margwaserverutils::shieldfacing(attackdir, 0.2))
						{
							damageshield = 1;
						}
					}
					else if(player margwaserverutils::shieldfacing(attackdir, 0.2, 0))
					{
						damageshield = 1;
					}
					if(damageshield)
					{
						self clientfield::increment("margwa_smash");
						shield_damage = level.weaponriotshield.weaponstarthitpoints;
						if(isdefined(player.weaponriotshield))
						{
							shield_damage = player.weaponriotshield.weaponstarthitpoints;
						}
						player [[player.player_shield_apply_damage]](shield_damage, 0);
						continue;
					}
				}
				if(isdefined(level.margwa_smash_damage_callback) && isfunctionptr(level.margwa_smash_damage_callback))
				{
					if(player [[level.margwa_smash_damage_callback]](self))
					{
						continue;
					}
				}
				self clientfield::increment("margwa_smash");
				player dodamage(166, self.origin, self);
			}
		}
	}
	if(isdefined(self.smashattackcb))
	{
		self [[self.smashattackcb]]();
	}
}

/*
	Name: margwanotetrackbodyfall
	Namespace: margwabehavior
	Checksum: 0xCC2FF858
	Offset: 0x1CC0
	Size: 0x50
	Parameters: 1
	Flags: Linked, Private
*/
function private margwanotetrackbodyfall(entity)
{
	if(self.archetype == "margwa")
	{
		entity ghost();
		if(isdefined(self.bodyfallcb))
		{
			self [[self.bodyfallcb]]();
		}
	}
}

/*
	Name: margwanotetrackpainmelee
	Namespace: margwabehavior
	Checksum: 0x3D30E629
	Offset: 0x1D18
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private margwanotetrackpainmelee(entity)
{
	entity melee();
}

/*
	Name: margwatargetservice
	Namespace: margwabehavior
	Checksum: 0xD35CFD3F
	Offset: 0x1D48
	Size: 0x156
	Parameters: 1
	Flags: Linked, Private
*/
function private margwatargetservice(entity)
{
	if(isdefined(entity.ignoreall) && entity.ignoreall)
	{
		return false;
	}
	player = zombie_utility::get_closest_valid_player(self.origin, self.ignore_player);
	if(!isdefined(player))
	{
		if(isdefined(self.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			self.ignore_player = [];
		}
		self setgoal(self.origin);
		return false;
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
	Name: margwashouldsmashattack
	Namespace: margwabehavior
	Checksum: 0x55FEA848
	Offset: 0x1EA8
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function margwashouldsmashattack(entity)
{
	if(!isdefined(entity.enemy))
	{
		return false;
	}
	if(!entity margwaserverutils::insmashattackrange(entity.enemy))
	{
		return false;
	}
	yaw = abs(zombie_utility::getyawtoenemy());
	if(yaw > 45)
	{
		return false;
	}
	return true;
}

/*
	Name: margwashouldswipeattack
	Namespace: margwabehavior
	Checksum: 0xAA61328B
	Offset: 0x1F40
	Size: 0xA6
	Parameters: 1
	Flags: Linked
*/
function margwashouldswipeattack(entity)
{
	if(!isdefined(entity.enemy))
	{
		return false;
	}
	if(distancesquared(entity.origin, entity.enemy.origin) > 16384)
	{
		return false;
	}
	yaw = abs(zombie_utility::getyawtoenemy());
	if(yaw > 45)
	{
		return false;
	}
	return true;
}

/*
	Name: margwashouldshowpain
	Namespace: margwabehavior
	Checksum: 0x55B8C89E
	Offset: 0x1FF0
	Size: 0xFE
	Parameters: 1
	Flags: Linked, Private
*/
function private margwashouldshowpain(entity)
{
	if(isdefined(entity.headdestroyed))
	{
		headinfo = entity.head[entity.headdestroyed];
		switch(headinfo.cf)
		{
			case "margwa_head_left":
			{
				blackboard::setblackboardattribute(self, "_margwa_head", "left");
				break;
			}
			case "margwa_head_mid":
			{
				blackboard::setblackboardattribute(self, "_margwa_head", "middle");
				break;
			}
			case "margwa_head_right":
			{
				blackboard::setblackboardattribute(self, "_margwa_head", "right");
				break;
			}
		}
		return true;
	}
	return false;
}

/*
	Name: margwashouldreactstun
	Namespace: margwabehavior
	Checksum: 0x6F008555
	Offset: 0x20F8
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private margwashouldreactstun(entity)
{
	if(isdefined(entity.reactstun) && entity.reactstun)
	{
		return true;
	}
	return false;
}

/*
	Name: margwashouldreactidgun
	Namespace: margwabehavior
	Checksum: 0x99E54D21
	Offset: 0x2140
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private margwashouldreactidgun(entity)
{
	if(isdefined(entity.reactidgun) && entity.reactidgun)
	{
		return true;
	}
	return false;
}

/*
	Name: margwashouldreactsword
	Namespace: margwabehavior
	Checksum: 0x5502ADC7
	Offset: 0x2188
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private margwashouldreactsword(entity)
{
	if(isdefined(entity.reactsword) && entity.reactsword)
	{
		return true;
	}
	return false;
}

/*
	Name: margwashouldspawn
	Namespace: margwabehavior
	Checksum: 0x16151AD8
	Offset: 0x21D0
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private margwashouldspawn(entity)
{
	if(isdefined(entity.needspawn) && entity.needspawn)
	{
		return true;
	}
	return false;
}

/*
	Name: margwashouldfreeze
	Namespace: margwabehavior
	Checksum: 0xC130F05
	Offset: 0x2218
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private margwashouldfreeze(entity)
{
	if(isdefined(entity.isfrozen) && entity.isfrozen)
	{
		return true;
	}
	return false;
}

/*
	Name: margwashouldteleportin
	Namespace: margwabehavior
	Checksum: 0x3BCAEDEB
	Offset: 0x2260
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private margwashouldteleportin(entity)
{
	if(isdefined(entity.needteleportin) && entity.needteleportin)
	{
		return true;
	}
	return false;
}

/*
	Name: margwashouldteleportout
	Namespace: margwabehavior
	Checksum: 0x244FF5FB
	Offset: 0x22A8
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private margwashouldteleportout(entity)
{
	if(isdefined(entity.needteleportout) && entity.needteleportout)
	{
		return true;
	}
	return false;
}

/*
	Name: margwashouldwait
	Namespace: margwabehavior
	Checksum: 0x87DA610
	Offset: 0x22F0
	Size: 0x3A
	Parameters: 1
	Flags: Linked, Private
*/
function private margwashouldwait(entity)
{
	if(isdefined(entity.waiting) && entity.waiting)
	{
		return true;
	}
	return false;
}

/*
	Name: margwashouldreset
	Namespace: margwabehavior
	Checksum: 0xBE201424
	Offset: 0x2338
	Size: 0xAA
	Parameters: 1
	Flags: Linked, Private
*/
function private margwashouldreset(entity)
{
	if(isdefined(entity.headdestroyed))
	{
		return true;
	}
	if(isdefined(entity.reactidgun) && entity.reactidgun)
	{
		return true;
	}
	if(isdefined(entity.reactsword) && entity.reactsword)
	{
		return true;
	}
	if(isdefined(entity.reactstun) && entity.reactstun)
	{
		return true;
	}
	return false;
}

/*
	Name: margwareactstunaction
	Namespace: margwabehavior
	Checksum: 0xB4B5902E
	Offset: 0x23F0
	Size: 0xF0
	Parameters: 2
	Flags: Linked, Private
*/
function private margwareactstunaction(entity, asmstatename)
{
	animationstatenetworkutility::requeststate(entity, asmstatename);
	stunactionast = entity astsearch(istring(asmstatename));
	stunactionanimation = animationstatenetworkutility::searchanimationmap(entity, stunactionast["animation"]);
	closetime = getanimlength(stunactionanimation) * 1000;
	entity margwaserverutils::margwacloseallheads(closetime);
	margwareactstunstart(entity);
	return 5;
}

/*
	Name: margwaswipeattackaction
	Namespace: margwabehavior
	Checksum: 0xD06E7FC6
	Offset: 0x24E8
	Size: 0xE8
	Parameters: 2
	Flags: Linked, Private
*/
function private margwaswipeattackaction(entity, asmstatename)
{
	animationstatenetworkutility::requeststate(entity, asmstatename);
	if(!isdefined(entity.swipe_end_time))
	{
		swipeactionast = entity astsearch(istring(asmstatename));
		swipeactionanimation = animationstatenetworkutility::searchanimationmap(entity, swipeactionast["animation"]);
		swipeactiontime = getanimlength(swipeactionanimation) * 1000;
		entity.swipe_end_time = gettime() + swipeactiontime;
	}
	return 5;
}

/*
	Name: margwaswipeattackactionupdate
	Namespace: margwabehavior
	Checksum: 0xC27867E9
	Offset: 0x25D8
	Size: 0x46
	Parameters: 2
	Flags: Linked, Private
*/
function private margwaswipeattackactionupdate(entity, asmstatename)
{
	if(isdefined(entity.swipe_end_time) && gettime() > entity.swipe_end_time)
	{
		return 4;
	}
	return 5;
}

/*
	Name: margwaidlestart
	Namespace: margwabehavior
	Checksum: 0x40D5DCA6
	Offset: 0x2628
	Size: 0x44
	Parameters: 1
	Flags: Linked, Private
*/
function private margwaidlestart(entity)
{
	if(entity margwaserverutils::shouldupdatejaw())
	{
		entity clientfield::set("margwa_jaw", 1);
	}
}

/*
	Name: margwamovestart
	Namespace: margwabehavior
	Checksum: 0x5DEEBAD0
	Offset: 0x2678
	Size: 0x8C
	Parameters: 1
	Flags: Linked, Private
*/
function private margwamovestart(entity)
{
	if(entity margwaserverutils::shouldupdatejaw())
	{
		if(entity.zombie_move_speed == "run")
		{
			entity clientfield::set("margwa_jaw", 13);
		}
		else
		{
			entity clientfield::set("margwa_jaw", 7);
		}
	}
}

/*
	Name: margwadeathaction
	Namespace: margwabehavior
	Checksum: 0x57CEAD69
	Offset: 0x2710
	Size: 0xC
	Parameters: 1
	Flags: Private
*/
function private margwadeathaction(entity)
{
}

/*
	Name: margwatraverseactionstart
	Namespace: margwabehavior
	Checksum: 0xDD88BF83
	Offset: 0x2728
	Size: 0x14E
	Parameters: 1
	Flags: Linked, Private
*/
function private margwatraverseactionstart(entity)
{
	blackboard::setblackboardattribute(entity, "_traversal_type", entity.traversestartnode.animscript);
	if(isdefined(entity.traversestartnode.animscript))
	{
		if(entity margwaserverutils::shouldupdatejaw())
		{
			switch(entity.traversestartnode.animscript)
			{
				case "jump_down_36":
				{
					entity clientfield::set("margwa_jaw", 21);
					break;
				}
				case "jump_down_96":
				{
					entity clientfield::set("margwa_jaw", 22);
					break;
				}
				case "jump_up_36":
				{
					entity clientfield::set("margwa_jaw", 24);
					break;
				}
				case "jump_up_96":
				{
					entity clientfield::set("margwa_jaw", 25);
					break;
				}
			}
		}
	}
}

/*
	Name: margwateleportinstart
	Namespace: margwabehavior
	Checksum: 0x84B64EC8
	Offset: 0x2880
	Size: 0x154
	Parameters: 1
	Flags: Linked, Private
*/
function private margwateleportinstart(entity)
{
	entity unlink();
	if(isdefined(entity.teleportpos))
	{
		entity forceteleport(entity.teleportpos);
	}
	entity show();
	entity pathmode("move allowed");
	entity.needteleportin = 0;
	blackboard::setblackboardattribute(self, "_margwa_teleport", "in");
	if(isdefined(self.traveler))
	{
		self.traveler clientfield::set("margwa_fx_travel", 0);
	}
	self clientfield::increment("margwa_fx_in", 1);
	if(entity margwaserverutils::shouldupdatejaw())
	{
		entity clientfield::set("margwa_jaw", 17);
	}
}

/*
	Name: margwateleportinterminate
	Namespace: margwabehavior
	Checksum: 0xB1CFCFC2
	Offset: 0x29E0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function margwateleportinterminate(entity)
{
	if(isdefined(self.traveler))
	{
		self.traveler clientfield::set("margwa_fx_travel", 0);
	}
	entity.isteleporting = 0;
}

/*
	Name: margwateleportoutstart
	Namespace: margwabehavior
	Checksum: 0x646D917E
	Offset: 0x2A38
	Size: 0xCC
	Parameters: 1
	Flags: Linked, Private
*/
function private margwateleportoutstart(entity)
{
	entity.needteleportout = 0;
	entity.isteleporting = 1;
	entity.teleportstart = entity.origin;
	blackboard::setblackboardattribute(self, "_margwa_teleport", "out");
	self clientfield::increment("margwa_fx_out", 1);
	if(entity margwaserverutils::shouldupdatejaw())
	{
		entity clientfield::set("margwa_jaw", 18);
	}
}

/*
	Name: margwateleportoutterminate
	Namespace: margwabehavior
	Checksum: 0x70776916
	Offset: 0x2B10
	Size: 0x134
	Parameters: 1
	Flags: Linked, Private
*/
function private margwateleportoutterminate(entity)
{
	if(isdefined(entity.traveler))
	{
		entity.traveler.origin = entity gettagorigin("j_spine_1");
		entity.traveler clientfield::set("margwa_fx_travel", 1);
	}
	entity ghost();
	entity pathmode("dont move");
	if(isdefined(entity.traveler))
	{
		entity linkto(entity.traveler);
	}
	if(isdefined(entity.margwawait))
	{
		entity thread [[entity.margwawait]]();
	}
	else
	{
		entity thread margwaserverutils::margwawait();
	}
}

/*
	Name: margwapainstart
	Namespace: margwabehavior
	Checksum: 0x1DD691BE
	Offset: 0x2C50
	Size: 0x12C
	Parameters: 1
	Flags: Linked, Private
*/
function private margwapainstart(entity)
{
	entity notify(#"stop_head_update");
	if(entity margwaserverutils::shouldupdatejaw())
	{
		head = blackboard::getblackboardattribute(self, "_margwa_head");
		switch(head)
		{
			case "left":
			{
				entity clientfield::set("margwa_jaw", 3);
				break;
			}
			case "middle":
			{
				entity clientfield::set("margwa_jaw", 4);
				break;
			}
			case "right":
			{
				entity clientfield::set("margwa_jaw", 5);
				break;
			}
		}
	}
	entity.headdestroyed = undefined;
	entity.canstun = 0;
	entity.candamage = 0;
}

/*
	Name: margwapainterminate
	Namespace: margwabehavior
	Checksum: 0x13FC1942
	Offset: 0x2D88
	Size: 0xA0
	Parameters: 1
	Flags: Linked, Private
*/
function private margwapainterminate(entity)
{
	entity.headdestroyed = undefined;
	entity.canstun = 1;
	entity.candamage = 1;
	entity margwaserverutils::margwacloseallheads(5000);
	entity clearpath();
	if(isdefined(entity.margwapainterminatecb))
	{
		entity [[entity.margwapainterminatecb]]();
	}
}

/*
	Name: margwareactstunstart
	Namespace: margwabehavior
	Checksum: 0xE29ED658
	Offset: 0x2E30
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private margwareactstunstart(entity)
{
	entity.reactstun = undefined;
	entity.canstun = 0;
	if(entity margwaserverutils::shouldupdatejaw())
	{
		entity clientfield::set("margwa_jaw", 6);
	}
}

/*
	Name: margwareactstunterminate
	Namespace: margwabehavior
	Checksum: 0x567ED9E2
	Offset: 0x2EA0
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function margwareactstunterminate(entity)
{
	entity.canstun = 1;
}

/*
	Name: margwareactidgunstart
	Namespace: margwabehavior
	Checksum: 0x6EA2D157
	Offset: 0x2EC8
	Size: 0x13C
	Parameters: 1
	Flags: Linked, Private
*/
function private margwareactidgunstart(entity)
{
	entity.reactidgun = undefined;
	entity.canstun = 0;
	ispacked = 0;
	if(blackboard::getblackboardattribute(entity, "_zombie_damageweapon_type") == "regular")
	{
		if(entity margwaserverutils::shouldupdatejaw())
		{
			entity clientfield::set("margwa_jaw", 8);
		}
		entity margwaserverutils::margwacloseallheads(5000);
	}
	else
	{
		if(entity margwaserverutils::shouldupdatejaw())
		{
			entity clientfield::set("margwa_jaw", 9);
		}
		entity margwaserverutils::margwacloseallheads(10000);
		ispacked = 1;
	}
	if(isdefined(entity.idgun_damage))
	{
		entity [[entity.idgun_damage]](ispacked);
	}
}

/*
	Name: margwareactidgunterminate
	Namespace: margwabehavior
	Checksum: 0x417F8CEF
	Offset: 0x3010
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function margwareactidgunterminate(entity)
{
	entity.canstun = 1;
	blackboard::setblackboardattribute(entity, "_zombie_damageweapon_type", "regular");
}

/*
	Name: margwareactswordstart
	Namespace: margwabehavior
	Checksum: 0xB22073AE
	Offset: 0x3060
	Size: 0x58
	Parameters: 1
	Flags: Linked, Private
*/
function private margwareactswordstart(entity)
{
	entity.reactsword = undefined;
	entity.canstun = 0;
	if(isdefined(entity.head_chopper))
	{
		entity.head_chopper notify(#"react_sword");
	}
}

/*
	Name: margwareactswordterminate
	Namespace: margwabehavior
	Checksum: 0xFF73C378
	Offset: 0x30C0
	Size: 0x20
	Parameters: 1
	Flags: Linked, Private
*/
function private margwareactswordterminate(entity)
{
	entity.canstun = 1;
}

/*
	Name: margwaspawnstart
	Namespace: margwabehavior
	Checksum: 0x38AD1A57
	Offset: 0x30E8
	Size: 0x1C
	Parameters: 1
	Flags: Linked, Private
*/
function private margwaspawnstart(entity)
{
	entity.needspawn = 0;
}

/*
	Name: margwasmashattackstart
	Namespace: margwabehavior
	Checksum: 0xF8F02AF9
	Offset: 0x3110
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private margwasmashattackstart(entity)
{
	entity margwaserverutils::margwaheadsmash();
	if(entity margwaserverutils::shouldupdatejaw())
	{
		entity clientfield::set("margwa_jaw", 14);
	}
}

/*
	Name: margwasmashattackterminate
	Namespace: margwabehavior
	Checksum: 0xD562EA55
	Offset: 0x3178
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function margwasmashattackterminate(entity)
{
	entity margwaserverutils::margwacloseallheads();
}

/*
	Name: margwaswipeattackstart
	Namespace: margwabehavior
	Checksum: 0x37DE952B
	Offset: 0x31A8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function margwaswipeattackstart(entity)
{
	if(entity margwaserverutils::shouldupdatejaw())
	{
		entity clientfield::set("margwa_jaw", 16);
	}
}

/*
	Name: margwaswipeattackterminate
	Namespace: margwabehavior
	Checksum: 0xFA0A0930
	Offset: 0x31F8
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private margwaswipeattackterminate(entity)
{
	entity margwaserverutils::margwacloseallheads();
}

/*
	Name: mocompmargwateleporttraversalinit
	Namespace: margwabehavior
	Checksum: 0x1C7A55F3
	Offset: 0x3228
	Size: 0x144
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompmargwateleporttraversalinit(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.angles[1]);
	entity animmode("normal");
	if(isdefined(entity.traverseendnode))
	{
		entity.teleportstart = entity.origin;
		entity.teleportpos = entity.traverseendnode.origin;
		self clientfield::increment("margwa_fx_out", 1);
		if(isdefined(entity.traversestartnode))
		{
			if(isdefined(entity.traversestartnode.speed))
			{
				self.margwa_teleport_speed = entity.traversestartnode.speed;
			}
		}
	}
}

/*
	Name: mocompmargwateleporttraversalupdate
	Namespace: margwabehavior
	Checksum: 0x44041490
	Offset: 0x3378
	Size: 0x2C
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompmargwateleporttraversalupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
}

/*
	Name: mocompmargwateleporttraversalterminate
	Namespace: margwabehavior
	Checksum: 0x897D052C
	Offset: 0x33B0
	Size: 0x44
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompmargwateleporttraversalterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	margwateleportoutterminate(entity);
}

#namespace margwaserverutils;

/*
	Name: margwaspawnsetup
	Namespace: margwaserverutils
	Checksum: 0x99D9DEB3
	Offset: 0x3400
	Size: 0x224
	Parameters: 0
	Flags: Linked, Private
*/
function private margwaspawnsetup()
{
	self disableaimassist();
	self.disableammodrop = 1;
	self.no_gib = 1;
	self.ignore_nuke = 1;
	self.ignore_enemy_count = 1;
	self.ignore_round_robbin_death = 1;
	self.zombie_move_speed = "walk";
	self.overrideactordamage = &margwadamage;
	self.candamage = 1;
	self.headattached = 3;
	self.headopen = 0;
	self margwainithead("c_zom_margwa_chunks_le", "j_chunk_head_bone_le");
	self margwainithead("c_zom_margwa_chunks_mid", "j_chunk_head_bone");
	self margwainithead("c_zom_margwa_chunks_ri", "j_chunk_head_bone_ri");
	self.headhealthmax = 600;
	self margwadisablestun();
	self.traveler = spawn("script_model", self.origin);
	self.traveler setmodel("tag_origin");
	self.traveler notsolid();
	self.travelertell = spawn("script_model", self.origin);
	self.travelertell setmodel("tag_origin");
	self.travelertell notsolid();
	self thread margwadeath();
	self.updatesight = 0;
	self.ignorerunandgundist = 1;
}

/*
	Name: margwadeath
	Namespace: margwaserverutils
	Checksum: 0x10D7870E
	Offset: 0x3630
	Size: 0x7C
	Parameters: 0
	Flags: Linked, Private
*/
function private margwadeath()
{
	self waittill(#"death");
	if(isdefined(self.e_head_attacker))
	{
		self.e_head_attacker notify(#"margwa_kill");
	}
	if(isdefined(self.traveler))
	{
		self.traveler delete();
	}
	if(isdefined(self.travelertell))
	{
		self.travelertell delete();
	}
}

/*
	Name: margwaenablestun
	Namespace: margwaserverutils
	Checksum: 0x7BFCD1CF
	Offset: 0x36B8
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function margwaenablestun()
{
	self.canstun = 1;
}

/*
	Name: margwadisablestun
	Namespace: margwaserverutils
	Checksum: 0xE1852A59
	Offset: 0x36D0
	Size: 0x10
	Parameters: 0
	Flags: Linked, Private
*/
function private margwadisablestun()
{
	self.canstun = 0;
}

/*
	Name: margwainithead
	Namespace: margwaserverutils
	Checksum: 0x4F6311E4
	Offset: 0x36E8
	Size: 0x454
	Parameters: 2
	Flags: Linked, Private
*/
function private margwainithead(headmodel, headtag)
{
	model = headmodel;
	model_gore = undefined;
	switch(headmodel)
	{
		case "c_zom_margwa_chunks_le":
		{
			if(isdefined(level.margwa_head_left_model_override))
			{
				model = level.margwa_head_left_model_override;
				model_gore = level.margwa_gore_left_model_override;
			}
			break;
		}
		case "c_zom_margwa_chunks_mid":
		{
			if(isdefined(level.margwa_head_mid_model_override))
			{
				model = level.margwa_head_mid_model_override;
				model_gore = level.margwa_gore_mid_model_override;
			}
			break;
		}
		case "c_zom_margwa_chunks_ri":
		{
			if(isdefined(level.margwa_head_right_model_override))
			{
				model = level.margwa_head_right_model_override;
				model_gore = level.margwa_gore_right_model_override;
			}
			break;
		}
	}
	self attach(model);
	if(!isdefined(self.head))
	{
		self.head = [];
	}
	self.head[model] = spawnstruct();
	self.head[model].model = model;
	self.head[model].tag = headtag;
	self.head[model].health = 600;
	self.head[model].candamage = 0;
	self.head[model].open = 1;
	self.head[model].closed = 2;
	self.head[model].smash = 3;
	switch(headmodel)
	{
		case "c_zom_margwa_chunks_le":
		{
			self.head[model].cf = "margwa_head_left";
			self.head[model].impactcf = "margwa_head_left_hit";
			self.head[model].gore = "c_zom_margwa_gore_le";
			if(isdefined(model_gore))
			{
				self.head[model].gore = model_gore;
			}
			self.head[model].killindex = 1;
			self.head_left_model = model;
			break;
		}
		case "c_zom_margwa_chunks_mid":
		{
			self.head[model].cf = "margwa_head_mid";
			self.head[model].impactcf = "margwa_head_mid_hit";
			self.head[model].gore = "c_zom_margwa_gore_mid";
			if(isdefined(model_gore))
			{
				self.head[model].gore = model_gore;
			}
			self.head[model].killindex = 2;
			self.head_mid_model = model;
			break;
		}
		case "c_zom_margwa_chunks_ri":
		{
			self.head[model].cf = "margwa_head_right";
			self.head[model].impactcf = "margwa_head_right_hit";
			self.head[model].gore = "c_zom_margwa_gore_ri";
			if(isdefined(model_gore))
			{
				self.head[model].gore = model_gore;
			}
			self.head[model].killindex = 3;
			self.head_right_model = model;
			break;
		}
	}
	self thread margwaheadupdate(self.head[model]);
}

/*
	Name: margwasetheadhealth
	Namespace: margwaserverutils
	Checksum: 0x91582E3A
	Offset: 0x3B48
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function margwasetheadhealth(health)
{
	self.headhealthmax = health;
	foreach(head in self.head)
	{
		head.health = health;
	}
}

/*
	Name: margwaresetheadtime
	Namespace: margwaserverutils
	Checksum: 0xEE2C76D4
	Offset: 0x3BF0
	Size: 0x46
	Parameters: 2
	Flags: Linked, Private
*/
function private margwaresetheadtime(min, max)
{
	time = gettime() + randomintrange(min, max);
	return time;
}

/*
	Name: margwaheadcanopen
	Namespace: margwaserverutils
	Checksum: 0xA2C54F6B
	Offset: 0x3C40
	Size: 0x40
	Parameters: 0
	Flags: Linked, Private
*/
function private margwaheadcanopen()
{
	if(self.headattached > 1)
	{
		if(self.headopen < (self.headattached - 1))
		{
			return true;
		}
	}
	else
	{
		return true;
	}
	return false;
}

/*
	Name: margwaheadupdate
	Namespace: margwaserverutils
	Checksum: 0x81D78407
	Offset: 0x3C88
	Size: 0x298
	Parameters: 1
	Flags: Linked, Private
*/
function private margwaheadupdate(headinfo)
{
	self endon(#"death");
	self endon(#"stop_head_update");
	headinfo notify(#"stop_head_update");
	headinfo endon(#"stop_head_update");
	while(true)
	{
		if(self ispaused())
		{
			util::wait_network_frame();
			continue;
		}
		if(!isdefined(headinfo.closetime))
		{
			if(self.headattached == 1)
			{
				headinfo.closetime = margwaresetheadtime(500, 1000);
			}
			else
			{
				headinfo.closetime = margwaresetheadtime(1500, 3500);
			}
		}
		if(gettime() > headinfo.closetime && self margwaheadcanopen())
		{
			self.headopen++;
			headinfo.closetime = undefined;
		}
		else
		{
			util::wait_network_frame();
			continue;
		}
		self margwaheaddamagedelay(headinfo, 1);
		self clientfield::set(headinfo.cf, headinfo.open);
		self playsoundontag("zmb_vocals_margwa_ambient", headinfo.tag);
		while(true)
		{
			if(!isdefined(headinfo.opentime))
			{
				headinfo.opentime = margwaresetheadtime(3000, 5000);
			}
			if(gettime() > headinfo.opentime)
			{
				self.headopen--;
				headinfo.opentime = undefined;
				break;
			}
			else
			{
				util::wait_network_frame();
				continue;
			}
		}
		self margwaheaddamagedelay(headinfo, 0);
		self clientfield::set(headinfo.cf, headinfo.closed);
	}
}

/*
	Name: margwaheaddamagedelay
	Namespace: margwaserverutils
	Checksum: 0xCB063EC9
	Offset: 0x3F28
	Size: 0x3C
	Parameters: 2
	Flags: Linked, Private
*/
function private margwaheaddamagedelay(headinfo, candamage)
{
	self endon(#"death");
	wait(0.1);
	headinfo.candamage = candamage;
}

/*
	Name: margwaheadsmash
	Namespace: margwaserverutils
	Checksum: 0x94918C5C
	Offset: 0x3F70
	Size: 0x1C2
	Parameters: 0
	Flags: Linked, Private
*/
function private margwaheadsmash()
{
	self notify(#"stop_head_update");
	headalive = [];
	foreach(head in self.head)
	{
		if(head.health > 0)
		{
			headalive[headalive.size] = head;
		}
	}
	headalive = array::randomize(headalive);
	open = 0;
	foreach(head in headalive)
	{
		if(!open)
		{
			head.candamage = 1;
			self clientfield::set(head.cf, head.smash);
			open = 1;
			continue;
		}
		self margwaclosehead(head);
	}
}

/*
	Name: margwaclosehead
	Namespace: margwaserverutils
	Checksum: 0xEBA348FD
	Offset: 0x4140
	Size: 0x4C
	Parameters: 1
	Flags: Linked, Private
*/
function private margwaclosehead(headinfo)
{
	headinfo.candamage = 0;
	self clientfield::set(headinfo.cf, headinfo.closed);
}

/*
	Name: margwacloseallheads
	Namespace: margwaserverutils
	Checksum: 0x51F32313
	Offset: 0x4198
	Size: 0x122
	Parameters: 1
	Flags: Linked, Private
*/
function private margwacloseallheads(closetime)
{
	if(self ispaused())
	{
		return;
	}
	foreach(head in self.head)
	{
		if(head.health > 0)
		{
			head.closetime = undefined;
			head.opentime = undefined;
			if(isdefined(closetime))
			{
				head.closetime = gettime() + closetime;
			}
			self.headopen = 0;
			self margwaclosehead(head);
			self thread margwaheadupdate(head);
		}
	}
}

/*
	Name: margwakillhead
	Namespace: margwaserverutils
	Checksum: 0xB02E33BE
	Offset: 0x42C8
	Size: 0x17A
	Parameters: 2
	Flags: Linked
*/
function margwakillhead(modelhit, attacker)
{
	headinfo = self.head[modelhit];
	headinfo.health = 0;
	headinfo notify(#"stop_head_update");
	if(isdefined(headinfo.candamage) && headinfo.candamage)
	{
		self margwaclosehead(headinfo);
		self.headopen--;
	}
	self margwaupdatemovespeed();
	if(isdefined(self.destroyheadcb))
	{
		self thread [[self.destroyheadcb]](modelhit, attacker);
	}
	self clientfield::set("margwa_head_killed", headinfo.killindex);
	self detach(headinfo.model);
	self attach(headinfo.gore);
	self.headattached--;
	if(self.headattached <= 0)
	{
		self.e_head_attacker = attacker;
		return true;
	}
	self.headdestroyed = modelhit;
	return false;
}

/*
	Name: margwacandamageanyhead
	Namespace: margwaserverutils
	Checksum: 0x43563241
	Offset: 0x4450
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function margwacandamageanyhead()
{
	foreach(head in self.head)
	{
		if(isdefined(head) && head.health > 0 && (isdefined(head.candamage) && head.candamage))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: margwacandamagehead
	Namespace: margwaserverutils
	Checksum: 0x2167A7ED
	Offset: 0x4518
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function margwacandamagehead()
{
	if(isdefined(self) && self.health > 0 && (isdefined(self.candamage) && self.candamage))
	{
		return true;
	}
	return false;
}

/*
	Name: show_hit_marker
	Namespace: margwaserverutils
	Checksum: 0x7D7D2633
	Offset: 0x4560
	Size: 0x88
	Parameters: 0
	Flags: Linked
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
	Name: isdirecthitweapon
	Namespace: margwaserverutils
	Checksum: 0x9E36F596
	Offset: 0x45F0
	Size: 0xEE
	Parameters: 1
	Flags: Linked, Private
*/
function private isdirecthitweapon(weapon)
{
	foreach(dhweapon in level.dhweapons)
	{
		if(weapon.name == dhweapon)
		{
			return true;
		}
		if(isdefined(weapon.rootweapon) && isdefined(weapon.rootweapon.name) && weapon.rootweapon.name == dhweapon)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: margwadamage
	Namespace: margwaserverutils
	Checksum: 0xD0E1889D
	Offset: 0x46E8
	Size: 0x67C
	Parameters: 12
	Flags: Linked
*/
function margwadamage(inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	if(isdefined(self.is_kill) && self.is_kill)
	{
		return damage;
	}
	if(isdefined(attacker) && isdefined(attacker.n_margwa_head_damage_scale))
	{
		damage = damage * attacker.n_margwa_head_damage_scale;
	}
	if(isdefined(level._margwa_damage_cb))
	{
		n_result = [[level._margwa_damage_cb]](inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex);
		if(isdefined(n_result))
		{
			return n_result;
		}
	}
	damageopen = 0;
	if(!(isdefined(self.candamage) && self.candamage))
	{
		self.health = self.health + 1;
		return 1;
	}
	if(isdirecthitweapon(weapon))
	{
		headalive = [];
		foreach(head in self.head)
		{
			if(head margwacandamagehead())
			{
				headalive[headalive.size] = head;
			}
		}
		if(headalive.size > 0)
		{
			max = 100000;
			headclosest = undefined;
			foreach(head in headalive)
			{
				distsq = distancesquared(point, self gettagorigin(head.tag));
				if(distsq < max)
				{
					max = distsq;
					headclosest = head;
				}
			}
			if(isdefined(headclosest))
			{
				if(max < 576)
				{
					if(isdefined(level.margwa_damage_override_callback) && isfunctionptr(level.margwa_damage_override_callback))
					{
						damage = attacker [[level.margwa_damage_override_callback]](damage);
					}
					headclosest.health = headclosest.health - damage;
					damageopen = 1;
					self clientfield::increment(headclosest.impactcf);
					attacker show_hit_marker();
					if(headclosest.health <= 0)
					{
						if(isdefined(level.margwa_head_kill_weapon_check))
						{
							[[level.margwa_head_kill_weapon_check]](self, weapon);
						}
						if(self margwakillhead(headclosest.model, attacker))
						{
							return self.health;
						}
					}
				}
			}
		}
	}
	partname = getpartname(self.model, boneindex);
	if(isdefined(partname))
	{
		/#
			if(isdefined(self.debughitloc) && self.debughitloc)
			{
				printtoprightln((partname + "") + damage);
			}
		#/
		modelhit = self margwaheadhit(self, partname);
		if(isdefined(modelhit))
		{
			headinfo = self.head[modelhit];
			if(headinfo margwacandamagehead())
			{
				if(isdefined(level.margwa_damage_override_callback) && isfunctionptr(level.margwa_damage_override_callback))
				{
					damage = attacker [[level.margwa_damage_override_callback]](damage);
				}
				if(isdefined(attacker))
				{
					attacker notify(#"margwa_headshot", self);
				}
				headinfo.health = headinfo.health - damage;
				damageopen = 1;
				self clientfield::increment(headinfo.impactcf);
				attacker show_hit_marker();
				if(headinfo.health <= 0)
				{
					if(isdefined(level.margwa_head_kill_weapon_check))
					{
						[[level.margwa_head_kill_weapon_check]](self, weapon);
					}
					if(self margwakillhead(modelhit, attacker))
					{
						return self.health;
					}
				}
			}
		}
	}
	if(damageopen)
	{
		return 0;
	}
	self.health = self.health + 1;
	return 1;
}

/*
	Name: margwaheadhit
	Namespace: margwaserverutils
	Checksum: 0x5A7E92A6
	Offset: 0x4D70
	Size: 0x70
	Parameters: 2
	Flags: Linked, Private
*/
function private margwaheadhit(entity, partname)
{
	switch(partname)
	{
		case "j_chunk_head_bone_le":
		case "j_jaw_lower_1_le":
		{
			return self.head_left_model;
		}
		case "j_chunk_head_bone":
		case "j_jaw_lower_1":
		{
			return self.head_mid_model;
		}
		case "j_chunk_head_bone_ri":
		case "j_jaw_lower_1_ri":
		{
			return self.head_right_model;
		}
	}
	return undefined;
}

/*
	Name: margwaupdatemovespeed
	Namespace: margwaserverutils
	Checksum: 0x5C02A521
	Offset: 0x4DE8
	Size: 0x9C
	Parameters: 0
	Flags: Linked, Private
*/
function private margwaupdatemovespeed()
{
	if(self.zombie_move_speed == "walk")
	{
		self.zombie_move_speed = "run";
		blackboard::setblackboardattribute(self, "_locomotion_speed", "locomotion_speed_run");
	}
	else if(self.zombie_move_speed == "run")
	{
		self.zombie_move_speed = "sprint";
		blackboard::setblackboardattribute(self, "_locomotion_speed", "locomotion_speed_sprint");
	}
}

/*
	Name: margwaforcesprint
	Namespace: margwaserverutils
	Checksum: 0x98CBB6AB
	Offset: 0x4E90
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function margwaforcesprint()
{
	self.zombie_move_speed = "sprint";
	blackboard::setblackboardattribute(self, "_locomotion_speed", "locomotion_speed_sprint");
}

/*
	Name: margwadestroyhead
	Namespace: margwaserverutils
	Checksum: 0xA69A2999
	Offset: 0x4ED8
	Size: 0xC
	Parameters: 1
	Flags: Private
*/
function private margwadestroyhead(modelhit)
{
}

/*
	Name: shouldupdatejaw
	Namespace: margwaserverutils
	Checksum: 0x2EAC2FC5
	Offset: 0x4EF0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function shouldupdatejaw()
{
	if(!(isdefined(self.jawanimenabled) && self.jawanimenabled))
	{
		return false;
	}
	if(self.headattached < 3)
	{
		return true;
	}
	return false;
}

/*
	Name: margwasetgoal
	Namespace: margwaserverutils
	Checksum: 0x47B9066C
	Offset: 0x4F30
	Size: 0x8E
	Parameters: 3
	Flags: Linked
*/
function margwasetgoal(origin, radius, boundarydist)
{
	pos = getclosestpointonnavmesh(origin, 64, 30);
	if(isdefined(pos))
	{
		self setgoal(pos);
		return true;
	}
	self setgoal(self.origin);
	return false;
}

/*
	Name: margwawait
	Namespace: margwaserverutils
	Checksum: 0x35D62B4D
	Offset: 0x4FC8
	Size: 0x18A
	Parameters: 0
	Flags: Linked, Private
*/
function private margwawait()
{
	self endon(#"death");
	self.waiting = 1;
	self.needteleportin = 1;
	destpos = self.teleportpos + vectorscale((0, 0, 1), 60);
	dist = distance(self.teleportstart, destpos);
	time = dist / 600;
	if(isdefined(self.margwa_teleport_speed))
	{
		if(self.margwa_teleport_speed > 0)
		{
			time = dist / self.margwa_teleport_speed;
		}
	}
	if(isdefined(self.traveler))
	{
		self thread margwatell();
		self.traveler moveto(destpos, time);
		self.traveler util::waittill_any_ex(time + 0.1, "movedone", self, "death");
		self.travelertell clientfield::set("margwa_fx_travel_tell", 0);
	}
	self.waiting = 0;
	self.needteleportout = 0;
	if(isdefined(self.margwa_teleport_speed))
	{
		self.margwa_teleport_speed = undefined;
	}
}

/*
	Name: margwatell
	Namespace: margwaserverutils
	Checksum: 0x7FEB04F2
	Offset: 0x5160
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function margwatell()
{
	self endon(#"death");
	self.travelertell.origin = self.teleportpos;
	util::wait_network_frame();
	self.travelertell clientfield::set("margwa_fx_travel_tell", 1);
}

/*
	Name: shieldfacing
	Namespace: margwaserverutils
	Checksum: 0x241B8C09
	Offset: 0x51D0
	Size: 0x162
	Parameters: 3
	Flags: Linked, Private
*/
function private shieldfacing(vdir, limit, front = 1)
{
	orientation = self getplayerangles();
	forwardvec = anglestoforward(orientation);
	if(!front)
	{
		forwardvec = forwardvec * -1;
	}
	forwardvec2d = (forwardvec[0], forwardvec[1], 0);
	unitforwardvec2d = vectornormalize(forwardvec2d);
	tofaceevec = vdir * -1;
	tofaceevec2d = (tofaceevec[0], tofaceevec[1], 0);
	unittofaceevec2d = vectornormalize(tofaceevec2d);
	dotproduct = vectordot(unitforwardvec2d, unittofaceevec2d);
	return dotproduct > limit;
}

/*
	Name: insmashattackrange
	Namespace: margwaserverutils
	Checksum: 0x63151C0A
	Offset: 0x5340
	Size: 0xC8
	Parameters: 1
	Flags: Linked, Private
*/
function private insmashattackrange(enemy)
{
	smashpos = self.origin;
	heightoffset = abs(self.origin[2] - enemy.origin[2]);
	if(heightoffset > 48)
	{
		return false;
	}
	distsq = distancesquared(smashpos, enemy.origin);
	range = 25600;
	if(distsq < range)
	{
		return true;
	}
	return false;
}

