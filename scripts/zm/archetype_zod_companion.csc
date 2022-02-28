// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zodcompanionclientutils;

/*
	Name: __init__sytem__
	Namespace: zodcompanionclientutils
	Checksum: 0x10CC164
	Offset: 0x290
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_companion", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zodcompanionclientutils
	Checksum: 0xF4B4988D
	Offset: 0x2D0
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "being_robot_revived", 1, 1, "int", &play_revival_fx, 0, 0);
	ai::add_archetype_spawn_function("zod_companion", &zodcompanionspawnsetup);
	level._effect["fx_dest_robot_head_sparks"] = "destruct/fx_dest_robot_head_sparks";
	level._effect["fx_dest_robot_body_sparks"] = "destruct/fx_dest_robot_body_sparks";
	level._effect["companion_revive_effect"] = "zombie/fx_robot_helper_revive_player_zod_zmb";
	ai::add_archetype_spawn_function("robot", &zodcompanionspawnsetup);
}

/*
	Name: zodcompanionspawnsetup
	Namespace: zodcompanionclientutils
	Checksum: 0x10FEFD58
	Offset: 0x3C8
	Size: 0x134
	Parameters: 1
	Flags: Linked, Private
*/
function private zodcompanionspawnsetup(localclientnum)
{
	entity = self;
	gibclientutils::addgibcallback(localclientnum, entity, 8, &zodcompanionheadgibfx);
	gibclientutils::addgibcallback(localclientnum, entity, 8, &_gibcallback);
	gibclientutils::addgibcallback(localclientnum, entity, 16, &_gibcallback);
	gibclientutils::addgibcallback(localclientnum, entity, 32, &_gibcallback);
	gibclientutils::addgibcallback(localclientnum, entity, 128, &_gibcallback);
	gibclientutils::addgibcallback(localclientnum, entity, 256, &_gibcallback);
	fxclientutils::playfxbundle(localclientnum, entity, entity.fxdef);
}

/*
	Name: zodcompanionheadgibfx
	Namespace: zodcompanionclientutils
	Checksum: 0xAC04FC83
	Offset: 0x508
	Size: 0x104
	Parameters: 3
	Flags: Linked
*/
function zodcompanionheadgibfx(localclientnum, entity, gibflag)
{
	if(!isdefined(entity) || !entity isai() || !isalive(entity))
	{
		return;
	}
	if(isdefined(entity.mindcontrolheadfx))
	{
		stopfx(localclientnum, entity.mindcontrolheadfx);
		entity.mindcontrolheadfx = undefined;
	}
	entity.headgibfx = playfxontag(localclientnum, level._effect["fx_dest_robot_head_sparks"], entity, "j_neck");
	playsound(0, "prj_bullet_impact_robot_headshot", entity.origin);
}

/*
	Name: zodcompaniondamagedfx
	Namespace: zodcompanionclientutils
	Checksum: 0x834F8091
	Offset: 0x618
	Size: 0x90
	Parameters: 2
	Flags: None
*/
function zodcompaniondamagedfx(localclientnum, entity)
{
	if(!isdefined(entity) || !entity isai() || !isalive(entity))
	{
		return;
	}
	entity.damagedfx = playfxontag(localclientnum, level._effect["fx_dest_robot_body_sparks"], entity, "j_spine4");
}

/*
	Name: zodcompanionclearfx
	Namespace: zodcompanionclientutils
	Checksum: 0x8A42D885
	Offset: 0x6B0
	Size: 0x3A
	Parameters: 2
	Flags: None
*/
function zodcompanionclearfx(localclientnum, entity)
{
	if(!isdefined(entity) || !entity isai())
	{
		return;
	}
}

/*
	Name: _gibcallback
	Namespace: zodcompanionclientutils
	Checksum: 0x579AA4E2
	Offset: 0x6F8
	Size: 0x92
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibcallback(localclientnum, entity, gibflag)
{
	if(!isdefined(entity) || !entity isai())
	{
		return;
	}
	switch(gibflag)
	{
		case 8:
		{
			break;
		}
		case 16:
		{
			break;
		}
		case 32:
		{
			break;
		}
		case 128:
		{
			break;
		}
		case 256:
		{
			break;
		}
	}
}

/*
	Name: play_revival_fx
	Namespace: zodcompanionclientutils
	Checksum: 0x86B0ED7B
	Offset: 0x798
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function play_revival_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.robot_revival_fx) && oldval == 1 && newval == 0)
	{
		stopfx(localclientnum, self.robot_revival_fx);
	}
	if(newval === 1)
	{
		self playsound(0, "evt_civil_protector_revive_plr");
		self.robot_revival_fx = playfxontag(localclientnum, level._effect["companion_revive_effect"], self, "j_spineupper");
	}
}

