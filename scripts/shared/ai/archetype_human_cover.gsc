// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\laststand_shared;

#namespace archetype_human_cover;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: archetype_human_cover
	Checksum: 0x11FD381E
	Offset: 0x568
	Size: 0x2D4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldReturnToCoverCondition", &shouldreturntocovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldReturnToSuppressedCover", &shouldreturntosuppressedcover);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldAdjustToCover", &shouldadjusttocover);
	behaviortreenetworkutility::registerbehaviortreescriptapi("prepareForAdjustToCover", &prepareforadjusttocover);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverBlindfireShootStart", &coverblindfireshootactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("canChangeStanceAtCoverCondition", &canchangestanceatcovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverChangeStanceActionStart", &coverchangestanceactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("prepareToChangeStanceToStand", &preparetochangestancetostand);
	behaviortreenetworkutility::registerbehaviortreescriptapi("cleanUpChangeStanceToStand", &cleanupchangestancetostand);
	behaviortreenetworkutility::registerbehaviortreescriptapi("prepareToChangeStanceToCrouch", &preparetochangestancetocrouch);
	behaviortreenetworkutility::registerbehaviortreescriptapi("cleanUpChangeStanceToCrouch", &cleanupchangestancetocrouch);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldVantageAtCoverCondition", &shouldvantageatcovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("supportsVantageCoverCondition", &supportsvantagecovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverVantageInitialize", &covervantageinitialize);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldThrowGrenadeAtCoverCondition", &shouldthrowgrenadeatcovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverPrepareToThrowGrenade", &coverpreparetothrowgrenade);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverCleanUpToThrowGrenade", &covercleanuptothrowgrenade);
	behaviortreenetworkutility::registerbehaviortreescriptapi("senseNearbyPlayers", &sensenearbyplayers);
}

/*
	Name: shouldthrowgrenadeatcovercondition
	Namespace: archetype_human_cover
	Checksum: 0x43557135
	Offset: 0x848
	Size: 0x882
	Parameters: 2
	Flags: Linked
*/
function shouldthrowgrenadeatcovercondition(behaviortreeentity, throwifpossible = 0)
{
	if(isdefined(level.aidisablegrenadethrows) && level.aidisablegrenadethrows)
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.enemy))
	{
		return false;
	}
	if(!issentient(behaviortreeentity.enemy))
	{
		return false;
	}
	if(isvehicle(behaviortreeentity.enemy) && behaviortreeentity.enemy.vehicleclass === "helicopter")
	{
		return false;
	}
	if(ai::hasaiattribute(behaviortreeentity, "useGrenades") && !ai::getaiattribute(behaviortreeentity, "useGrenades"))
	{
		return false;
	}
	entityangles = behaviortreeentity.angles;
	if(isdefined(behaviortreeentity.node) && (behaviortreeentity.node.type == "Cover Left" || behaviortreeentity.node.type == "Cover Right" || behaviortreeentity.node.type == "Cover Pillar" || (behaviortreeentity.node.type == "Cover Stand" || behaviortreeentity.node.type == "Conceal Stand") || (behaviortreeentity.node.type == "Cover Crouch" || behaviortreeentity.node.type == "Cover Crouch Window" || behaviortreeentity.node.type == "Conceal Crouch")) && behaviortreeentity isatcovernodestrict())
	{
		entityangles = behaviortreeentity.node.angles;
	}
	toenemy = behaviortreeentity.enemy.origin - behaviortreeentity.origin;
	toenemy = vectornormalize((toenemy[0], toenemy[1], 0));
	entityforward = anglestoforward(entityangles);
	entityforward = vectornormalize((entityforward[0], entityforward[1], 0));
	if(vectordot(toenemy, entityforward) < 0.5)
	{
		return false;
	}
	if(!throwifpossible)
	{
		if(behaviortreeentity.team === "allies")
		{
			foreach(player in level.players)
			{
				if(distancesquared(behaviortreeentity.enemy.origin, player.origin) <= 250000)
				{
					return false;
				}
			}
		}
		foreach(player in level.players)
		{
			if(player laststand::player_is_in_laststand() && distancesquared(behaviortreeentity.enemy.origin, player.origin) <= 250000)
			{
				return false;
			}
		}
		grenadethrowinfos = blackboard::getblackboardevents("team_grenade_throw");
		foreach(grenadethrowinfo in grenadethrowinfos)
		{
			if(grenadethrowinfo.data.grenadethrowerteam === behaviortreeentity.team)
			{
				return false;
			}
		}
		grenadethrowinfos = blackboard::getblackboardevents("human_grenade_throw");
		foreach(grenadethrowinfo in grenadethrowinfos)
		{
			if(isdefined(grenadethrowinfo.data.grenadethrownat) && isalive(grenadethrowinfo.data.grenadethrownat))
			{
				if(grenadethrowinfo.data.grenadethrower == behaviortreeentity)
				{
					return false;
				}
				if(isdefined(grenadethrowinfo.data.grenadethrownat) && grenadethrowinfo.data.grenadethrownat == behaviortreeentity.enemy)
				{
					return false;
				}
				if(isdefined(grenadethrowinfo.data.grenadethrownposition) && isdefined(behaviortreeentity.grenadethrowposition) && distancesquared(grenadethrowinfo.data.grenadethrownposition, behaviortreeentity.grenadethrowposition) <= 360000)
				{
					return false;
				}
			}
		}
	}
	throw_dist = distance2dsquared(behaviortreeentity.origin, behaviortreeentity lastknownpos(behaviortreeentity.enemy));
	if(throw_dist < (500 * 500) || throw_dist > (1250 * 1250))
	{
		return false;
	}
	arm_offset = temp_get_arm_offset(behaviortreeentity, behaviortreeentity lastknownpos(behaviortreeentity.enemy));
	throw_vel = behaviortreeentity canthrowgrenadepos(arm_offset, behaviortreeentity lastknownpos(behaviortreeentity.enemy));
	if(!isdefined(throw_vel))
	{
		return false;
	}
	return true;
}

/*
	Name: sensenearbyplayers
	Namespace: archetype_human_cover
	Checksum: 0x3A98B8D7
	Offset: 0x10D8
	Size: 0x15A
	Parameters: 1
	Flags: Linked, Private
*/
function private sensenearbyplayers(entity)
{
	players = getplayers();
	foreach(player in players)
	{
		distancesq = distancesquared(player.origin, entity.origin);
		if(distancesq <= (360 * 360))
		{
			distancetoplayer = sqrt(distancesq);
			chancetodetect = randomfloat(1);
			if(chancetodetect < (distancetoplayer / 360))
			{
				entity getperfectinfo(player);
			}
		}
	}
}

/*
	Name: coverpreparetothrowgrenade
	Namespace: archetype_human_cover
	Checksum: 0x6FD0DB0C
	Offset: 0x1240
	Size: 0x190
	Parameters: 1
	Flags: Linked, Private
*/
function private coverpreparetothrowgrenade(behaviortreeentity)
{
	aiutility::keepclaimednodeandchoosecoverdirection(behaviortreeentity);
	if(isdefined(behaviortreeentity.enemy))
	{
		behaviortreeentity.grenadethrowposition = behaviortreeentity lastknownpos(behaviortreeentity.enemy);
	}
	grenadethrowinfo = spawnstruct();
	grenadethrowinfo.grenadethrower = behaviortreeentity;
	grenadethrowinfo.grenadethrownat = behaviortreeentity.enemy;
	grenadethrowinfo.grenadethrownposition = behaviortreeentity.grenadethrowposition;
	blackboard::addblackboardevent("human_grenade_throw", grenadethrowinfo, randomintrange(15000, 20000));
	grenadethrowinfo = spawnstruct();
	grenadethrowinfo.grenadethrowerteam = behaviortreeentity.team;
	blackboard::addblackboardevent("team_grenade_throw", grenadethrowinfo, randomintrange(1000, 2000));
	behaviortreeentity.preparegrenadeammo = behaviortreeentity.grenadeammo;
}

/*
	Name: covercleanuptothrowgrenade
	Namespace: archetype_human_cover
	Checksum: 0x8D8A6813
	Offset: 0x13D8
	Size: 0x21C
	Parameters: 1
	Flags: Linked, Private
*/
function private covercleanuptothrowgrenade(behaviortreeentity)
{
	aiutility::resetcoverparameters(behaviortreeentity);
	if(behaviortreeentity.preparegrenadeammo == behaviortreeentity.grenadeammo)
	{
		if(behaviortreeentity.health <= 0)
		{
			grenade = undefined;
			if(isactor(behaviortreeentity.enemy) && isdefined(behaviortreeentity.grenadeweapon))
			{
				grenade = behaviortreeentity.enemy magicgrenadetype(behaviortreeentity.grenadeweapon, behaviortreeentity gettagorigin("j_wrist_ri"), (0, 0, 0), behaviortreeentity.grenadeweapon.aifusetime / 1000);
			}
			else if(isplayer(behaviortreeentity.enemy) && isdefined(behaviortreeentity.grenadeweapon))
			{
				grenade = behaviortreeentity.enemy magicgrenadeplayer(behaviortreeentity.grenadeweapon, behaviortreeentity gettagorigin("j_wrist_ri"), (0, 0, 0));
			}
			if(isdefined(grenade))
			{
				grenade.owner = behaviortreeentity;
				grenade.team = behaviortreeentity.team;
				grenade setcontents(grenade setcontents(0) & (~(((32768 | 67108864) | 8388608) | 33554432)));
			}
		}
	}
}

/*
	Name: canchangestanceatcovercondition
	Namespace: archetype_human_cover
	Checksum: 0xB37ED1EB
	Offset: 0x1600
	Size: 0x9C
	Parameters: 1
	Flags: Linked, Private
*/
function private canchangestanceatcovercondition(behaviortreeentity)
{
	switch(blackboard::getblackboardattribute(behaviortreeentity, "_stance"))
	{
		case "stand":
		{
			return aiutility::isstanceallowedatnode("crouch", behaviortreeentity.node);
		}
		case "crouch":
		{
			return aiutility::isstanceallowedatnode("stand", behaviortreeentity.node);
		}
	}
	return 0;
}

/*
	Name: shouldreturntosuppressedcover
	Namespace: archetype_human_cover
	Checksum: 0x4847EDE1
	Offset: 0x16A8
	Size: 0x2E
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldreturntosuppressedcover(entity)
{
	if(!entity isatgoal())
	{
		return true;
	}
	return false;
}

/*
	Name: shouldreturntocovercondition
	Namespace: archetype_human_cover
	Checksum: 0x584B1F1
	Offset: 0x16E0
	Size: 0x1A6
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldreturntocovercondition(behaviortreeentity)
{
	if(behaviortreeentity asmistransitionrunning())
	{
		return 0;
	}
	if(isdefined(behaviortreeentity.covershootstarttime))
	{
		if(gettime() < (behaviortreeentity.covershootstarttime + 800))
		{
			return 0;
		}
		if(isdefined(behaviortreeentity.enemy) && isplayer(behaviortreeentity.enemy) && behaviortreeentity.enemy.health < (behaviortreeentity.enemy.maxhealth * 0.5))
		{
			if(gettime() < (behaviortreeentity.covershootstarttime + 3000))
			{
				return 0;
			}
		}
	}
	if(aiutility::issuppressedatcovercondition(behaviortreeentity))
	{
		return 1;
	}
	if(!behaviortreeentity isatgoal())
	{
		if(isdefined(behaviortreeentity.node))
		{
			offsetorigin = behaviortreeentity getnodeoffsetposition(behaviortreeentity.node);
			return !behaviortreeentity isposatgoal(offsetorigin);
		}
		return 1;
	}
	if(!behaviortreeentity issafefromgrenade())
	{
		return 1;
	}
	return 0;
}

/*
	Name: shouldadjusttocover
	Namespace: archetype_human_cover
	Checksum: 0x858E187C
	Offset: 0x1890
	Size: 0x156
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldadjusttocover(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.node))
	{
		return false;
	}
	highestsupportedstance = aiutility::gethighestnodestance(behaviortreeentity.node);
	currentstance = blackboard::getblackboardattribute(behaviortreeentity, "_stance");
	if(currentstance == "crouch" && highestsupportedstance == "crouch")
	{
		return false;
	}
	covermode = blackboard::getblackboardattribute(behaviortreeentity, "_cover_mode");
	previouscovermode = blackboard::getblackboardattribute(behaviortreeentity, "_previous_cover_mode");
	if(covermode != "cover_alert" && previouscovermode != "cover_alert" && !behaviortreeentity.keepclaimednode)
	{
		return true;
	}
	if(!aiutility::isstanceallowedatnode(currentstance, behaviortreeentity.node))
	{
		return true;
	}
	return false;
}

/*
	Name: shouldvantageatcovercondition
	Namespace: archetype_human_cover
	Checksum: 0xFF83653A
	Offset: 0x19F0
	Size: 0x1C2
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldvantageatcovercondition(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.node) || !isdefined(behaviortreeentity.node.type) || !isdefined(behaviortreeentity.enemy) || !isdefined(behaviortreeentity.enemy.origin))
	{
		return 0;
	}
	yawtoenemyposition = aiutility::getaimyawtoenemyfromnode(behaviortreeentity, behaviortreeentity.node, behaviortreeentity.enemy);
	pitchtoenemyposition = aiutility::getaimpitchtoenemyfromnode(behaviortreeentity, behaviortreeentity.node, behaviortreeentity.enemy);
	aimlimitsforcover = behaviortreeentity getaimlimitsfromentry("cover_vantage");
	legalaim = 0;
	if(yawtoenemyposition < aimlimitsforcover["aim_left"] && yawtoenemyposition > aimlimitsforcover["aim_right"] && pitchtoenemyposition < 85 && pitchtoenemyposition > 25 && (behaviortreeentity.node.origin[2] - behaviortreeentity.enemy.origin[2]) >= 36)
	{
		legalaim = 1;
	}
	return legalaim;
}

/*
	Name: supportsvantagecovercondition
	Namespace: archetype_human_cover
	Checksum: 0x7623DBA2
	Offset: 0x1BC0
	Size: 0xE
	Parameters: 1
	Flags: Linked, Private
*/
function private supportsvantagecovercondition(behaviortreeentity)
{
	return false;
}

/*
	Name: covervantageinitialize
	Namespace: archetype_human_cover
	Checksum: 0x1AF350A3
	Offset: 0x1BD8
	Size: 0x54
	Parameters: 2
	Flags: Linked, Private
*/
function private covervantageinitialize(behaviortreeentity, asmstatename)
{
	aiutility::keepclaimnode(behaviortreeentity);
	blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_vantage");
}

/*
	Name: coverblindfireshootactionstart
	Namespace: archetype_human_cover
	Checksum: 0xA4C580A3
	Offset: 0x1C38
	Size: 0x6C
	Parameters: 2
	Flags: Linked, Private
*/
function private coverblindfireshootactionstart(behaviortreeentity, asmstatename)
{
	aiutility::keepclaimnode(behaviortreeentity);
	blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_blind");
	aiutility::choosecoverdirection(behaviortreeentity);
}

/*
	Name: preparetochangestancetostand
	Namespace: archetype_human_cover
	Checksum: 0x7E67CCB5
	Offset: 0x1CB0
	Size: 0x54
	Parameters: 2
	Flags: Linked, Private
*/
function private preparetochangestancetostand(behaviortreeentity, asmstatename)
{
	aiutility::cleanupcovermode(behaviortreeentity);
	blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "stand");
}

/*
	Name: cleanupchangestancetostand
	Namespace: archetype_human_cover
	Checksum: 0xB664F0D0
	Offset: 0x1D10
	Size: 0x3C
	Parameters: 2
	Flags: Linked, Private
*/
function private cleanupchangestancetostand(behaviortreeentity, asmstatename)
{
	aiutility::releaseclaimnode(behaviortreeentity);
	behaviortreeentity.newenemyreaction = 0;
}

/*
	Name: preparetochangestancetocrouch
	Namespace: archetype_human_cover
	Checksum: 0x1B2F02DA
	Offset: 0x1D58
	Size: 0x54
	Parameters: 2
	Flags: Linked, Private
*/
function private preparetochangestancetocrouch(behaviortreeentity, asmstatename)
{
	aiutility::cleanupcovermode(behaviortreeentity);
	blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "crouch");
}

/*
	Name: cleanupchangestancetocrouch
	Namespace: archetype_human_cover
	Checksum: 0x41C91CEE
	Offset: 0x1DB8
	Size: 0x3C
	Parameters: 2
	Flags: Linked, Private
*/
function private cleanupchangestancetocrouch(behaviortreeentity, asmstatename)
{
	aiutility::releaseclaimnode(behaviortreeentity);
	behaviortreeentity.newenemyreaction = 0;
}

/*
	Name: prepareforadjusttocover
	Namespace: archetype_human_cover
	Checksum: 0x67C54587
	Offset: 0x1E00
	Size: 0x7C
	Parameters: 2
	Flags: Linked, Private
*/
function private prepareforadjusttocover(behaviortreeentity, asmstatename)
{
	aiutility::keepclaimnode(behaviortreeentity);
	highestsupportedstance = aiutility::gethighestnodestance(behaviortreeentity.node);
	blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", highestsupportedstance);
}

/*
	Name: coverchangestanceactionstart
	Namespace: archetype_human_cover
	Checksum: 0x396022EA
	Offset: 0x1E88
	Size: 0xDE
	Parameters: 2
	Flags: Linked, Private
*/
function private coverchangestanceactionstart(behaviortreeentity, asmstatename)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_alert");
	aiutility::keepclaimnode(behaviortreeentity);
	switch(blackboard::getblackboardattribute(behaviortreeentity, "_stance"))
	{
		case "stand":
		{
			blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "crouch");
			break;
		}
		case "crouch":
		{
			blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "stand");
			break;
		}
	}
}

/*
	Name: temp_get_arm_offset
	Namespace: archetype_human_cover
	Checksum: 0xFB9EBCB6
	Offset: 0x1F70
	Size: 0x48E
	Parameters: 2
	Flags: Linked
*/
function temp_get_arm_offset(behaviortreeentity, throwposition)
{
	stance = blackboard::getblackboardattribute(behaviortreeentity, "_stance");
	arm_offset = undefined;
	if(stance == "crouch")
	{
		arm_offset = (13, -1, 56);
	}
	else
	{
		arm_offset = (14, -3, 80);
	}
	if(isdefined(behaviortreeentity.node) && behaviortreeentity isatcovernodestrict())
	{
		if(behaviortreeentity.node.type == "Cover Left")
		{
			if(stance == "crouch")
			{
				arm_offset = (-38, 15, 23);
			}
			else
			{
				arm_offset = (-45, 0, 40);
			}
		}
		else
		{
			if(behaviortreeentity.node.type == "Cover Right")
			{
				if(stance == "crouch")
				{
					arm_offset = (46, 12, 26);
				}
				else
				{
					arm_offset = (34, -21, 50);
				}
			}
			else
			{
				if(behaviortreeentity.node.type == "Cover Stand" || behaviortreeentity.node.type == "Conceal Stand")
				{
					arm_offset = (10, 7, 77);
				}
				else
				{
					if(behaviortreeentity.node.type == "Cover Crouch" || behaviortreeentity.node.type == "Cover Crouch Window" || behaviortreeentity.node.type == "Conceal Crouch")
					{
						arm_offset = (19, 5, 60);
					}
					else if(behaviortreeentity.node.type == "Cover Pillar")
					{
						leftoffset = undefined;
						rightoffset = undefined;
						if(stance == "crouch")
						{
							leftoffset = (-20, 0, 35);
							rightoffset = (34, 6, 50);
						}
						else
						{
							leftoffset = (-24, 0, 76);
							rightoffset = (24, 0, 76);
						}
						if(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 1024) == 1024)
						{
							arm_offset = rightoffset;
						}
						else
						{
							if(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 2048) == 2048)
							{
								arm_offset = leftoffset;
							}
							else
							{
								yawtoenemyposition = angleclamp180((vectortoangles(throwposition - behaviortreeentity.node.origin)[1]) - behaviortreeentity.node.angles[1]);
								aimlimitsfordirectionright = behaviortreeentity getaimlimitsfromentry("pillar_right_lean");
								legalrightdirectionyaw = yawtoenemyposition >= (aimlimitsfordirectionright["aim_right"] - 10) && yawtoenemyposition <= 0;
								if(legalrightdirectionyaw)
								{
									arm_offset = rightoffset;
								}
								else
								{
									arm_offset = leftoffset;
								}
							}
						}
					}
				}
			}
		}
	}
	return arm_offset;
}

