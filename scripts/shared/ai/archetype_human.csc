// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace archetype_human;

/*
	Name: precache
	Namespace: archetype_human
	Checksum: 0x99EC1590
	Offset: 0x170
	Size: 0x4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec precache()
{
}

/*
	Name: main
	Namespace: archetype_human
	Checksum: 0xD88AF5A1
	Offset: 0x180
	Size: 0x4C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "facial_dial", 1, 1, "int", &humanclientutils::facialdialoguehandler, 0, 1);
}

#namespace humanclientutils;

/*
	Name: facialdialoguehandler
	Namespace: humanclientutils
	Checksum: 0xD40EE132
	Offset: 0x1D8
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function facialdialoguehandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		self.facialdialogueactive = 1;
	}
	else if(isdefined(self.facialdialogueactive) && self.facialdialogueactive)
	{
		self clearanim(%generic::faces, 0);
	}
}

