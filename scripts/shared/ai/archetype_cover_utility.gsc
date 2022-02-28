// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;

#namespace aiutility;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: aiutility
	Checksum: 0xAFB593FB
	Offset: 0x658
	Size: 0x504
	Parameters: 0
	Flags: AutoExec
*/
function autoexec registerbehaviorscriptfunctions()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("isAtCrouchNode", &isatcrouchnode);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isAtCoverCondition", &isatcovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isAtCoverStrictCondition", &isatcoverstrictcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isAtCoverModeOver", &isatcovermodeover);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isAtCoverModeNone", &isatcovermodenone);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isExposedAtCoverCondition", &isexposedatcovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("keepClaimedNodeAndChooseCoverDirection", &keepclaimednodeandchoosecoverdirection);
	behaviortreenetworkutility::registerbehaviortreescriptapi("resetCoverParameters", &resetcoverparameters);
	behaviortreenetworkutility::registerbehaviortreescriptapi("cleanupCoverMode", &cleanupcovermode);
	behaviortreenetworkutility::registerbehaviortreescriptapi("canBeFlankedService", &canbeflankedservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldCoverIdleOnly", &shouldcoveridleonly);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isSuppressedAtCoverCondition", &issuppressedatcovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverIdleInitialize", &coveridleinitialize);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverIdleUpdate", &coveridleupdate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverIdleTerminate", &coveridleterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isFlankedByEnemyAtCover", &isflankedbyenemyatcover);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverFlankedActionStart", &coverflankedinitialize);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverFlankedActionTerminate", &coverflankedactionterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("supportsOverCoverCondition", &supportsovercovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldOverAtCoverCondition", &shouldoveratcovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverOverInitialize", &coveroverinitialize);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverOverTerminate", &coveroverterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("supportsLeanCoverCondition", &supportsleancovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldLeanAtCoverCondition", &shouldleanatcovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("continueLeaningAtCoverCondition", &continueleaningatcovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverLeanInitialize", &coverleaninitialize);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverLeanTerminate", &coverleanterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("supportsPeekCoverCondition", &supportspeekcovercondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverPeekInitialize", &coverpeekinitialize);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverPeekTerminate", &coverpeekterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("coverReloadInitialize", &coverreloadinitialize);
	behaviortreenetworkutility::registerbehaviortreescriptapi("refillAmmoAndCleanupCoverMode", &refillammoandcleanupcovermode);
}

/*
	Name: coverreloadinitialize
	Namespace: aiutility
	Checksum: 0x6A6FDD18
	Offset: 0xB68
	Size: 0x4C
	Parameters: 1
	Flags: Linked, Private
*/
function private coverreloadinitialize(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_alert");
	keepclaimnode(behaviortreeentity);
}

/*
	Name: refillammoandcleanupcovermode
	Namespace: aiutility
	Checksum: 0x61DB8B36
	Offset: 0xBC0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function refillammoandcleanupcovermode(behaviortreeentity)
{
	if(isalive(behaviortreeentity))
	{
		refillammo(behaviortreeentity);
	}
	cleanupcovermode(behaviortreeentity);
}

/*
	Name: supportspeekcovercondition
	Namespace: aiutility
	Checksum: 0xFE942645
	Offset: 0xC20
	Size: 0x1C
	Parameters: 1
	Flags: Linked, Private
*/
function private supportspeekcovercondition(behaviortreeentity)
{
	return isdefined(behaviortreeentity.node);
}

/*
	Name: coverpeekinitialize
	Namespace: aiutility
	Checksum: 0x64C072A5
	Offset: 0xC48
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private coverpeekinitialize(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_alert");
	keepclaimnode(behaviortreeentity);
	choosecoverdirection(behaviortreeentity);
}

/*
	Name: coverpeekterminate
	Namespace: aiutility
	Checksum: 0xAE796100
	Offset: 0xCB8
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private coverpeekterminate(behaviortreeentity)
{
	choosefrontcoverdirection(behaviortreeentity);
	cleanupcovermode(behaviortreeentity);
}

/*
	Name: supportsleancovercondition
	Namespace: aiutility
	Checksum: 0xE70EF4A6
	Offset: 0xD00
	Size: 0x124
	Parameters: 1
	Flags: Linked, Private
*/
function private supportsleancovercondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.node))
	{
		if(behaviortreeentity.node.type == "Cover Left" || behaviortreeentity.node.type == "Cover Right")
		{
			return true;
		}
		if(behaviortreeentity.node.type == "Cover Pillar")
		{
			if(!(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 1024) == 1024) || (!(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 2048) == 2048)))
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: shouldleanatcovercondition
	Namespace: aiutility
	Checksum: 0xA1C27AEC
	Offset: 0xE30
	Size: 0x340
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldleanatcovercondition(behaviortreeentity)
{
	if(!isdefined(behaviortreeentity.node) || !isdefined(behaviortreeentity.node.type) || !isdefined(behaviortreeentity.enemy) || !isdefined(behaviortreeentity.enemy.origin))
	{
		return 0;
	}
	yawtoenemyposition = getaimyawtoenemyfromnode(behaviortreeentity, behaviortreeentity.node, behaviortreeentity.enemy);
	legalaimyaw = 0;
	if(behaviortreeentity.node.type == "Cover Left")
	{
		aimlimitsforcover = behaviortreeentity getaimlimitsfromentry("cover_left_lean");
		legalaimyaw = yawtoenemyposition <= (aimlimitsforcover["aim_left"] + 10) && yawtoenemyposition >= -10;
	}
	else
	{
		if(behaviortreeentity.node.type == "Cover Right")
		{
			aimlimitsforcover = behaviortreeentity getaimlimitsfromentry("cover_right_lean");
			legalaimyaw = yawtoenemyposition >= (aimlimitsforcover["aim_right"] - 10) && yawtoenemyposition <= 10;
		}
		else if(behaviortreeentity.node.type == "Cover Pillar")
		{
			aimlimitsforcover = behaviortreeentity getaimlimitsfromentry("cover");
			supportsleft = !(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 1024) == 1024);
			supportsright = !(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 2048) == 2048);
			angleleeway = 10;
			if(supportsright && supportsleft)
			{
				angleleeway = 0;
			}
			if(supportsleft)
			{
				legalaimyaw = yawtoenemyposition <= (aimlimitsforcover["aim_left"] + 10) && yawtoenemyposition >= (angleleeway * -1);
			}
			if(!legalaimyaw && supportsright)
			{
				legalaimyaw = yawtoenemyposition >= (aimlimitsforcover["aim_right"] - 10) && yawtoenemyposition <= angleleeway;
			}
		}
	}
	return legalaimyaw;
}

/*
	Name: continueleaningatcovercondition
	Namespace: aiutility
	Checksum: 0xEC2360E2
	Offset: 0x1178
	Size: 0x42
	Parameters: 1
	Flags: Linked, Private
*/
function private continueleaningatcovercondition(behaviortreeentity)
{
	if(behaviortreeentity asmistransitionrunning())
	{
		return 1;
	}
	return shouldleanatcovercondition(behaviortreeentity);
}

/*
	Name: coverleaninitialize
	Namespace: aiutility
	Checksum: 0x562801CD
	Offset: 0x11C8
	Size: 0x7C
	Parameters: 1
	Flags: Linked, Private
*/
function private coverleaninitialize(behaviortreeentity)
{
	setcovershootstarttime(behaviortreeentity);
	keepclaimnode(behaviortreeentity);
	blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_lean");
	choosecoverdirection(behaviortreeentity);
}

/*
	Name: coverleanterminate
	Namespace: aiutility
	Checksum: 0x98EA0A0E
	Offset: 0x1250
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private coverleanterminate(behaviortreeentity)
{
	choosefrontcoverdirection(behaviortreeentity);
	cleanupcovermode(behaviortreeentity);
	clearcovershootstarttime(behaviortreeentity);
}

/*
	Name: supportsovercovercondition
	Namespace: aiutility
	Checksum: 0x2FEF1789
	Offset: 0x12B0
	Size: 0x1B4
	Parameters: 1
	Flags: Linked, Private
*/
function private supportsovercovercondition(behaviortreeentity)
{
	stance = blackboard::getblackboardattribute(behaviortreeentity, "_stance");
	if(isdefined(behaviortreeentity.node))
	{
		if(!isinarray(getvalidcoverpeekouts(behaviortreeentity.node), "over"))
		{
			return false;
		}
		if(behaviortreeentity.node.type == "Cover Left" || behaviortreeentity.node.type == "Cover Right" || (behaviortreeentity.node.type == "Cover Crouch" || behaviortreeentity.node.type == "Cover Crouch Window" || behaviortreeentity.node.type == "Conceal Crouch"))
		{
			if(stance == "crouch")
			{
				return true;
			}
		}
		else if(behaviortreeentity.node.type == "Cover Stand" || behaviortreeentity.node.type == "Conceal Stand")
		{
			if(stance == "stand")
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: shouldoveratcovercondition
	Namespace: aiutility
	Checksum: 0xF1209478
	Offset: 0x1470
	Size: 0x1F2
	Parameters: 1
	Flags: Linked, Private
*/
function private shouldoveratcovercondition(entity)
{
	if(!isdefined(entity.node) || !isdefined(entity.node.type) || !isdefined(entity.enemy) || !isdefined(entity.enemy.origin))
	{
		return false;
	}
	aimtable = (iscoverconcealed(entity.node) ? "cover_concealed_over" : "cover_over");
	aimlimitsforcover = entity getaimlimitsfromentry(aimtable);
	yawtoenemyposition = getaimyawtoenemyfromnode(entity, entity.node, entity.enemy);
	legalaimyaw = yawtoenemyposition >= (aimlimitsforcover["aim_right"] - 10) && yawtoenemyposition <= (aimlimitsforcover["aim_left"] + 10);
	if(!legalaimyaw)
	{
		return false;
	}
	pitchtoenemyposition = getaimpitchtoenemyfromnode(entity, entity.node, entity.enemy);
	legalaimpitch = pitchtoenemyposition >= (aimlimitsforcover["aim_up"] + 10) && pitchtoenemyposition <= (aimlimitsforcover["aim_down"] + 10);
	if(!legalaimpitch)
	{
		return false;
	}
	return true;
}

/*
	Name: coveroverinitialize
	Namespace: aiutility
	Checksum: 0x9F66328F
	Offset: 0x1670
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private coveroverinitialize(behaviortreeentity)
{
	setcovershootstarttime(behaviortreeentity);
	keepclaimnode(behaviortreeentity);
	blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_over");
}

/*
	Name: coveroverterminate
	Namespace: aiutility
	Checksum: 0x30598AD9
	Offset: 0x16E0
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private coveroverterminate(behaviortreeentity)
{
	cleanupcovermode(behaviortreeentity);
	clearcovershootstarttime(behaviortreeentity);
}

/*
	Name: coveridleinitialize
	Namespace: aiutility
	Checksum: 0x317799C8
	Offset: 0x1728
	Size: 0x4C
	Parameters: 1
	Flags: Linked, Private
*/
function private coveridleinitialize(behaviortreeentity)
{
	keepclaimnode(behaviortreeentity);
	blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_alert");
}

/*
	Name: coveridleupdate
	Namespace: aiutility
	Checksum: 0xD4CC29C4
	Offset: 0x1780
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private coveridleupdate(behaviortreeentity)
{
	if(!behaviortreeentity asmistransitionrunning())
	{
		releaseclaimnode(behaviortreeentity);
	}
}

/*
	Name: coveridleterminate
	Namespace: aiutility
	Checksum: 0x3CBAD582
	Offset: 0x17C8
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private coveridleterminate(behaviortreeentity)
{
	releaseclaimnode(behaviortreeentity);
	cleanupcovermode(behaviortreeentity);
}

/*
	Name: isflankedbyenemyatcover
	Namespace: aiutility
	Checksum: 0xF3337E03
	Offset: 0x1810
	Size: 0x6C
	Parameters: 1
	Flags: Linked, Private
*/
function private isflankedbyenemyatcover(behaviortreeentity)
{
	return canbeflanked(behaviortreeentity) && behaviortreeentity isatcovernodestrict() && behaviortreeentity isflankedatcovernode() && !behaviortreeentity haspath();
}

/*
	Name: canbeflankedservice
	Namespace: aiutility
	Checksum: 0x43C9E4EA
	Offset: 0x1888
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private canbeflankedservice(behaviortreeentity)
{
	setcanbeflanked(behaviortreeentity, 1);
}

/*
	Name: coverflankedinitialize
	Namespace: aiutility
	Checksum: 0x34B27321
	Offset: 0x18B8
	Size: 0xD4
	Parameters: 1
	Flags: Linked, Private
*/
function private coverflankedinitialize(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enemy))
	{
		behaviortreeentity getperfectinfo(behaviortreeentity.enemy);
		behaviortreeentity pathmode("move delayed", 0, 2);
	}
	setcanbeflanked(behaviortreeentity, 0);
	cleanupcovermode(behaviortreeentity);
	keepclaimnode(behaviortreeentity);
	blackboard::setblackboardattribute(behaviortreeentity, "_desired_stance", "stand");
}

/*
	Name: coverflankedactionterminate
	Namespace: aiutility
	Checksum: 0xC476C8E3
	Offset: 0x1998
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private coverflankedactionterminate(behaviortreeentity)
{
	behaviortreeentity.newenemyreaction = 0;
	releaseclaimnode(behaviortreeentity);
}

/*
	Name: isatcrouchnode
	Namespace: aiutility
	Checksum: 0x40CE1BF0
	Offset: 0x19D8
	Size: 0x11E
	Parameters: 1
	Flags: Linked
*/
function isatcrouchnode(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.node) && (behaviortreeentity.node.type == "Exposed" || behaviortreeentity.node.type == "Guard" || behaviortreeentity.node.type == "Path"))
	{
		if(distancesquared(behaviortreeentity.origin, behaviortreeentity.node.origin) <= (24 * 24))
		{
			return !isstanceallowedatnode("stand", behaviortreeentity.node) && isstanceallowedatnode("crouch", behaviortreeentity.node);
		}
	}
	return 0;
}

/*
	Name: isatcovercondition
	Namespace: aiutility
	Checksum: 0xE95D1FCE
	Offset: 0x1B00
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function isatcovercondition(behaviortreeentity)
{
	return behaviortreeentity isatcovernodestrict() && behaviortreeentity shouldusecovernode() && !behaviortreeentity haspath();
}

/*
	Name: isatcoverstrictcondition
	Namespace: aiutility
	Checksum: 0xA8964D68
	Offset: 0x1B60
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function isatcoverstrictcondition(behaviortreeentity)
{
	return behaviortreeentity isatcovernodestrict() && !behaviortreeentity haspath();
}

/*
	Name: isatcovermodeover
	Namespace: aiutility
	Checksum: 0x5ED99EA0
	Offset: 0x1BA8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function isatcovermodeover(behaviortreeentity)
{
	covermode = blackboard::getblackboardattribute(behaviortreeentity, "_cover_mode");
	return covermode == "cover_over";
}

/*
	Name: isatcovermodenone
	Namespace: aiutility
	Checksum: 0x61592CAE
	Offset: 0x1BF8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function isatcovermodenone(behaviortreeentity)
{
	covermode = blackboard::getblackboardattribute(behaviortreeentity, "_cover_mode");
	return covermode == "cover_mode_none";
}

/*
	Name: isexposedatcovercondition
	Namespace: aiutility
	Checksum: 0xED85490D
	Offset: 0x1C48
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function isexposedatcovercondition(behaviortreeentity)
{
	return behaviortreeentity isatcovernodestrict() && !behaviortreeentity shouldusecovernode();
}

/*
	Name: shouldcoveridleonly
	Namespace: aiutility
	Checksum: 0x80415F0E
	Offset: 0x1C90
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function shouldcoveridleonly(behaviortreeentity)
{
	if(behaviortreeentity ai::get_behavior_attribute("coverIdleOnly"))
	{
		return true;
	}
	if(isdefined(behaviortreeentity.node.script_onlyidle) && behaviortreeentity.node.script_onlyidle)
	{
		return true;
	}
	return false;
}

/*
	Name: issuppressedatcovercondition
	Namespace: aiutility
	Checksum: 0x6A05B019
	Offset: 0x1D10
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function issuppressedatcovercondition(behaviortreeentity)
{
	return behaviortreeentity.suppressionmeter > behaviortreeentity.suppressionthreshold;
}

/*
	Name: keepclaimednodeandchoosecoverdirection
	Namespace: aiutility
	Checksum: 0x5D1FF9D
	Offset: 0x1D40
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function keepclaimednodeandchoosecoverdirection(behaviortreeentity)
{
	keepclaimnode(behaviortreeentity);
	choosecoverdirection(behaviortreeentity);
}

/*
	Name: resetcoverparameters
	Namespace: aiutility
	Checksum: 0xD9A5C848
	Offset: 0x1D88
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function resetcoverparameters(behaviortreeentity)
{
	choosefrontcoverdirection(behaviortreeentity);
	cleanupcovermode(behaviortreeentity);
	clearcovershootstarttime(behaviortreeentity);
}

/*
	Name: choosecoverdirection
	Namespace: aiutility
	Checksum: 0x34827DB8
	Offset: 0x1DE8
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function choosecoverdirection(behaviortreeentity, stepout)
{
	if(!isdefined(behaviortreeentity.node))
	{
		return;
	}
	coverdirection = blackboard::getblackboardattribute(behaviortreeentity, "_cover_direction");
	blackboard::setblackboardattribute(behaviortreeentity, "_previous_cover_direction", coverdirection);
	blackboard::setblackboardattribute(behaviortreeentity, "_cover_direction", calculatecoverdirection(behaviortreeentity, stepout));
}

/*
	Name: calculatecoverdirection
	Namespace: aiutility
	Checksum: 0x34D777BD
	Offset: 0x1EA0
	Size: 0x494
	Parameters: 2
	Flags: Linked
*/
function calculatecoverdirection(behaviortreeentity, stepout)
{
	if(isdefined(behaviortreeentity.treatallcoversasgeneric))
	{
		if(!isdefined(stepout))
		{
			stepout = 0;
		}
		coverdirection = "cover_front_direction";
		if(behaviortreeentity.node.type == "Cover Left")
		{
			if(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 4) == 4 || math::cointoss() || stepout)
			{
				coverdirection = "cover_left_direction";
			}
		}
		else
		{
			if(behaviortreeentity.node.type == "Cover Right")
			{
				if(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 4) == 4 || math::cointoss() || stepout)
				{
					coverdirection = "cover_right_direction";
				}
			}
			else if(behaviortreeentity.node.type == "Cover Pillar")
			{
				if(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 1024) == 1024)
				{
					return "cover_right_direction";
				}
				if(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 2048) == 2048)
				{
					return "cover_left_direction";
				}
				coverdirection = "cover_left_direction";
				if(isdefined(behaviortreeentity.enemy))
				{
					yawtoenemyposition = getaimyawtoenemyfromnode(behaviortreeentity, behaviortreeentity.node, behaviortreeentity.enemy);
					aimlimitsfordirectionright = behaviortreeentity getaimlimitsfromentry("pillar_right_lean");
					legalrightdirectionyaw = yawtoenemyposition >= (aimlimitsfordirectionright["aim_right"] - 10) && yawtoenemyposition <= 0;
					if(legalrightdirectionyaw)
					{
						coverdirection = "cover_right_direction";
					}
				}
			}
		}
		return coverdirection;
	}
	coverdirection = "cover_front_direction";
	if(behaviortreeentity.node.type == "Cover Pillar")
	{
		if(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 1024) == 1024)
		{
			return "cover_right_direction";
		}
		if(isdefined(behaviortreeentity.node.spawnflags) && (behaviortreeentity.node.spawnflags & 2048) == 2048)
		{
			return "cover_left_direction";
		}
		coverdirection = "cover_left_direction";
		if(isdefined(behaviortreeentity.enemy))
		{
			yawtoenemyposition = getaimyawtoenemyfromnode(behaviortreeentity, behaviortreeentity.node, behaviortreeentity.enemy);
			aimlimitsfordirectionright = behaviortreeentity getaimlimitsfromentry("pillar_right_lean");
			legalrightdirectionyaw = yawtoenemyposition >= (aimlimitsfordirectionright["aim_right"] - 10) && yawtoenemyposition <= 0;
			if(legalrightdirectionyaw)
			{
				coverdirection = "cover_right_direction";
			}
		}
	}
	return coverdirection;
}

/*
	Name: clearcovershootstarttime
	Namespace: aiutility
	Checksum: 0xBA8F02C
	Offset: 0x2340
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function clearcovershootstarttime(behaviortreeentity)
{
	behaviortreeentity.covershootstarttime = undefined;
}

/*
	Name: setcovershootstarttime
	Namespace: aiutility
	Checksum: 0x9AC73F53
	Offset: 0x2368
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function setcovershootstarttime(behaviortreeentity)
{
	behaviortreeentity.covershootstarttime = gettime();
}

/*
	Name: canbeflanked
	Namespace: aiutility
	Checksum: 0x7902730E
	Offset: 0x2390
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function canbeflanked(behaviortreeentity)
{
	return isdefined(behaviortreeentity.canbeflanked) && behaviortreeentity.canbeflanked;
}

/*
	Name: setcanbeflanked
	Namespace: aiutility
	Checksum: 0xFF7096CB
	Offset: 0x23C8
	Size: 0x28
	Parameters: 2
	Flags: Linked
*/
function setcanbeflanked(behaviortreeentity, canbeflanked)
{
	behaviortreeentity.canbeflanked = canbeflanked;
}

/*
	Name: cleanupcovermode
	Namespace: aiutility
	Checksum: 0xB57632BD
	Offset: 0x23F8
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function cleanupcovermode(behaviortreeentity)
{
	if(isatcovercondition(behaviortreeentity))
	{
		covermode = blackboard::getblackboardattribute(behaviortreeentity, "_cover_mode");
		blackboard::setblackboardattribute(behaviortreeentity, "_previous_cover_mode", covermode);
		blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_mode_none");
	}
	else
	{
		blackboard::setblackboardattribute(behaviortreeentity, "_previous_cover_mode", "cover_mode_none");
		blackboard::setblackboardattribute(behaviortreeentity, "_cover_mode", "cover_mode_none");
	}
}

