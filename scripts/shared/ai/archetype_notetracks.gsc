// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_human_cover;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_shared;

#namespace animationstatenetwork;

/*
	Name: registerdefaultnotetrackhandlerfunctions
	Namespace: animationstatenetwork
	Checksum: 0xF6C90615
	Offset: 0x438
	Size: 0x43C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec registerdefaultnotetrackhandlerfunctions()
{
	registernotetrackhandlerfunction("fire", &notetrackfirebullet);
	registernotetrackhandlerfunction("gib_disable", &notetrackgibdisable);
	registernotetrackhandlerfunction("gib = \"head\"", &gibserverutils::gibhead);
	registernotetrackhandlerfunction("gib = \"arm_left\"", &gibserverutils::gibleftarm);
	registernotetrackhandlerfunction("gib = \"arm_right\"", &gibserverutils::gibrightarm);
	registernotetrackhandlerfunction("gib = \"leg_left\"", &gibserverutils::gibleftleg);
	registernotetrackhandlerfunction("gib = \"leg_right\"", &gibserverutils::gibrightleg);
	registernotetrackhandlerfunction("dropgun", &notetrackdropgun);
	registernotetrackhandlerfunction("gun drop", &notetrackdropgun);
	registernotetrackhandlerfunction("drop_shield", &notetrackdropshield);
	registernotetrackhandlerfunction("hide_weapon", &notetrackhideweapon);
	registernotetrackhandlerfunction("show_weapon", &notetrackshowweapon);
	registernotetrackhandlerfunction("hide_ai", &notetrackhideai);
	registernotetrackhandlerfunction("show_ai", &notetrackshowai);
	registernotetrackhandlerfunction("attach_knife", &notetrackattachknife);
	registernotetrackhandlerfunction("detach_knife", &notetrackdetachknife);
	registernotetrackhandlerfunction("grenade_throw", &notetrackgrenadethrow);
	registernotetrackhandlerfunction("start_ragdoll", &notetrackstartragdoll);
	registernotetrackhandlerfunction("ragdoll_nodeath", &notetrackstartragdollnodeath);
	registernotetrackhandlerfunction("unsync", &notetrackmeleeunsync);
	registernotetrackhandlerfunction("step1", &notetrackstaircasestep1);
	registernotetrackhandlerfunction("step2", &notetrackstaircasestep2);
	registernotetrackhandlerfunction("anim_movement = \"stop\"", &notetrackanimmovementstop);
	registerblackboardnotetrackhandler("anim_pose = \"stand\"", "_stance", "stand");
	registerblackboardnotetrackhandler("anim_pose = \"crouch\"", "_stance", "crouch");
	registerblackboardnotetrackhandler("anim_pose = \"prone_front\"", "_stance", "prone_front");
	registerblackboardnotetrackhandler("anim_pose = \"prone_back\"", "_stance", "prone_back");
}

/*
	Name: notetrackanimmovementstop
	Namespace: animationstatenetwork
	Checksum: 0x15562793
	Offset: 0x880
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackanimmovementstop(entity)
{
	if(entity haspath())
	{
		entity pathmode("move delayed", 1, randomfloatrange(2, 4));
	}
}

/*
	Name: notetrackstaircasestep1
	Namespace: animationstatenetwork
	Checksum: 0xAE971B2D
	Offset: 0x8F0
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackstaircasestep1(entity)
{
	numsteps = blackboard::getblackboardattribute(entity, "_staircase_num_steps");
	numsteps++;
	blackboard::setblackboardattribute(entity, "_staircase_num_steps", numsteps);
}

/*
	Name: notetrackstaircasestep2
	Namespace: animationstatenetwork
	Checksum: 0xC0E3500
	Offset: 0x958
	Size: 0x6C
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackstaircasestep2(entity)
{
	numsteps = blackboard::getblackboardattribute(entity, "_staircase_num_steps");
	numsteps = numsteps + 2;
	blackboard::setblackboardattribute(entity, "_staircase_num_steps", numsteps);
}

/*
	Name: notetrackdropguninternal
	Namespace: animationstatenetwork
	Checksum: 0xBE7E929D
	Offset: 0x9D0
	Size: 0x94
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackdropguninternal(entity)
{
	if(entity.weapon == level.weaponnone)
	{
		return;
	}
	entity.lastweapon = entity.weapon;
	primaryweapon = entity.primaryweapon;
	secondaryweapon = entity.secondaryweapon;
	entity thread shared::dropaiweapon();
}

/*
	Name: notetrackattachknife
	Namespace: animationstatenetwork
	Checksum: 0xC300680F
	Offset: 0xA70
	Size: 0x68
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackattachknife(entity)
{
	if(!(isdefined(entity._ai_melee_attachedknife) && entity._ai_melee_attachedknife))
	{
		entity attach("t6_wpn_knife_melee", "TAG_WEAPON_LEFT");
		entity._ai_melee_attachedknife = 1;
	}
}

/*
	Name: notetrackdetachknife
	Namespace: animationstatenetwork
	Checksum: 0xA3BB392A
	Offset: 0xAE0
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackdetachknife(entity)
{
	if(isdefined(entity._ai_melee_attachedknife) && entity._ai_melee_attachedknife)
	{
		entity detach("t6_wpn_knife_melee", "TAG_WEAPON_LEFT");
		entity._ai_melee_attachedknife = 0;
	}
}

/*
	Name: notetrackhideweapon
	Namespace: animationstatenetwork
	Checksum: 0xCA0AADC8
	Offset: 0xB50
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackhideweapon(entity)
{
	entity ai::gun_remove();
}

/*
	Name: notetrackshowweapon
	Namespace: animationstatenetwork
	Checksum: 0x2EBCF9DE
	Offset: 0xB80
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackshowweapon(entity)
{
	entity ai::gun_recall();
}

/*
	Name: notetrackhideai
	Namespace: animationstatenetwork
	Checksum: 0x2D0CAF1B
	Offset: 0xBB0
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackhideai(entity)
{
	entity hide();
}

/*
	Name: notetrackshowai
	Namespace: animationstatenetwork
	Checksum: 0x6038F3BC
	Offset: 0xBE0
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackshowai(entity)
{
	entity show();
}

/*
	Name: notetrackstartragdoll
	Namespace: animationstatenetwork
	Checksum: 0xCC16F3EA
	Offset: 0xC10
	Size: 0xB4
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackstartragdoll(entity)
{
	if(isactor(entity) && entity isinscriptedstate())
	{
		entity.overrideactordamage = undefined;
		entity.allowdeath = 1;
		entity.skipdeath = 1;
		entity kill();
	}
	notetrackdropguninternal(entity);
	entity startragdoll();
}

/*
	Name: _delayedragdoll
	Namespace: animationstatenetwork
	Checksum: 0x210EE748
	Offset: 0xCD0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function _delayedragdoll(entity)
{
	wait(0.25);
	if(isdefined(entity) && !entity isragdoll())
	{
		entity startragdoll();
	}
}

/*
	Name: notetrackstartragdollnodeath
	Namespace: animationstatenetwork
	Checksum: 0xA7C3B49F
	Offset: 0xD28
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function notetrackstartragdollnodeath(entity)
{
	if(isdefined(entity._ai_melee_opponent))
	{
		entity._ai_melee_opponent unlink();
	}
	entity thread _delayedragdoll(entity);
}

/*
	Name: notetrackfirebullet
	Namespace: animationstatenetwork
	Checksum: 0x989220D0
	Offset: 0xD88
	Size: 0x104
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackfirebullet(animationentity)
{
	if(isactor(animationentity) && animationentity isinscriptedstate())
	{
		if(animationentity.weapon != level.weaponnone)
		{
			animationentity notify(#"about_to_shoot");
			startpos = animationentity gettagorigin("tag_flash");
			endpos = startpos + vectorscale(animationentity getweaponforwarddir(), 100);
			magicbullet(animationentity.weapon, startpos, endpos, animationentity);
			animationentity notify(#"shoot");
			animationentity.bulletsinclip--;
		}
	}
}

/*
	Name: notetrackdropgun
	Namespace: animationstatenetwork
	Checksum: 0x1B2C6E95
	Offset: 0xE98
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackdropgun(animationentity)
{
	notetrackdropguninternal(animationentity);
}

/*
	Name: notetrackdropshield
	Namespace: animationstatenetwork
	Checksum: 0xFDA9364
	Offset: 0xEC8
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackdropshield(animationentity)
{
	aiutility::dropriotshield(animationentity);
}

/*
	Name: notetrackgrenadethrow
	Namespace: animationstatenetwork
	Checksum: 0x6729FE6E
	Offset: 0xEF8
	Size: 0xD4
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackgrenadethrow(animationentity)
{
	if(archetype_human_cover::shouldthrowgrenadeatcovercondition(animationentity, 1))
	{
		animationentity grenadethrow();
	}
	else if(isdefined(animationentity.grenadethrowposition))
	{
		arm_offset = archetype_human_cover::temp_get_arm_offset(animationentity, animationentity.grenadethrowposition);
		throw_vel = animationentity canthrowgrenadepos(arm_offset, animationentity.grenadethrowposition);
		if(isdefined(throw_vel))
		{
			animationentity grenadethrow();
		}
	}
}

/*
	Name: notetrackmeleeunsync
	Namespace: animationstatenetwork
	Checksum: 0x81C1A10B
	Offset: 0xFD8
	Size: 0x74
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackmeleeunsync(animationentity)
{
	if(isdefined(animationentity) && isdefined(animationentity.enemy))
	{
		if(isdefined(animationentity.enemy._ai_melee_markeddead) && animationentity.enemy._ai_melee_markeddead)
		{
			animationentity unlink();
		}
	}
}

/*
	Name: notetrackgibdisable
	Namespace: animationstatenetwork
	Checksum: 0xE786BE4E
	Offset: 0x1058
	Size: 0x4C
	Parameters: 1
	Flags: Linked, Private
*/
function private notetrackgibdisable(animationentity)
{
	if(animationentity ai::has_behavior_attribute("can_gib"))
	{
		animationentity ai::set_behavior_attribute("can_gib", 0);
	}
}

