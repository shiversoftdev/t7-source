// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace archetypedirewolf;

/*
	Name: __init__sytem__
	Namespace: archetypedirewolf
	Checksum: 0xACAE8F51
	Offset: 0x140
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("direwolf", &__init__, undefined, undefined);
}

/*
	Name: precache
	Namespace: archetypedirewolf
	Checksum: 0x3DEC4EE8
	Offset: 0x180
	Size: 0x1E
	Parameters: 0
	Flags: AutoExec
*/
function autoexec precache()
{
	level._effect["fx_bio_direwolf_eyes"] = "animals/fx_bio_direwolf_eyes";
}

/*
	Name: __init__
	Namespace: archetypedirewolf
	Checksum: 0x11DDFCB1
	Offset: 0x1A8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(ai::shouldregisterclientfieldforarchetype("direwolf"))
	{
		clientfield::register("actor", "direwolf_eye_glow_fx", 1, 1, "int", &direwolfeyeglowfxhandler, 0, 1);
	}
}

/*
	Name: direwolfeyeglowfxhandler
	Namespace: archetypedirewolf
	Checksum: 0xF0DF0394
	Offset: 0x218
	Size: 0x108
	Parameters: 7
	Flags: Linked, Private
*/
function private direwolfeyeglowfxhandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(isdefined(entity.archetype) && entity.archetype != "direwolf")
	{
		return;
	}
	if(isdefined(entity.eyeglowfx))
	{
		stopfx(localclientnum, entity.eyeglowfx);
		entity.eyeglowfx = undefined;
	}
	if(newvalue)
	{
		entity.eyeglowfx = playfxontag(localclientnum, level._effect["fx_bio_direwolf_eyes"], entity, "tag_eye");
	}
}

