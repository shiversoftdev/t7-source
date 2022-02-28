// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace skeleton;

/*
	Name: __init__sytem__
	Namespace: skeleton
	Checksum: 0xB77616BF
	Offset: 0x138
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("skeleton", &__init__, undefined, undefined);
}

/*
	Name: precache
	Namespace: skeleton
	Checksum: 0x99EC1590
	Offset: 0x178
	Size: 0x4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec precache()
{
}

/*
	Name: __init__
	Namespace: skeleton
	Checksum: 0x90EDA43C
	Offset: 0x188
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(ai::shouldregisterclientfieldforarchetype("skeleton"))
	{
		clientfield::register("actor", "skeleton", 1, 1, "int", &zombieclientutils::zombiehandler, 0, 0);
	}
}

#namespace zombieclientutils;

/*
	Name: zombiehandler
	Namespace: zombieclientutils
	Checksum: 0xCDFB6200
	Offset: 0x1F8
	Size: 0x184
	Parameters: 7
	Flags: Linked
*/
function zombiehandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(isdefined(entity.archetype) && entity.archetype != "zombie")
	{
		return;
	}
	if(!isdefined(entity.initializedgibcallbacks) || !entity.initializedgibcallbacks)
	{
		entity.initializedgibcallbacks = 1;
		gibclientutils::addgibcallback(localclientnum, entity, 8, &_gibcallback);
		gibclientutils::addgibcallback(localclientnum, entity, 16, &_gibcallback);
		gibclientutils::addgibcallback(localclientnum, entity, 32, &_gibcallback);
		gibclientutils::addgibcallback(localclientnum, entity, 128, &_gibcallback);
		gibclientutils::addgibcallback(localclientnum, entity, 256, &_gibcallback);
	}
}

/*
	Name: _gibcallback
	Namespace: zombieclientutils
	Checksum: 0x3AC2300A
	Offset: 0x388
	Size: 0xA6
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibcallback(localclientnum, entity, gibflag)
{
	switch(gibflag)
	{
		case 8:
		{
			playsound(0, "zmb_zombie_head_gib", self.origin);
			break;
		}
		case 16:
		case 32:
		case 128:
		case 256:
		{
			playsound(0, "zmb_death_gibs", self.origin);
			break;
		}
	}
}

