// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using_animtree("mp_autoturret");

#namespace autoturret;

/*
	Name: __init__sytem__
	Namespace: autoturret
	Checksum: 0x3F4E8149
	Offset: 0x1D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("autoturret", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: autoturret
	Checksum: 0xC95B1F34
	Offset: 0x218
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("vehicle", "auto_turret_open", 1, 1, "int", &turret_open, 0, 0);
	clientfield::register("scriptmover", "auto_turret_init", 1, 1, "int", &turret_init_anim, 0, 0);
	clientfield::register("scriptmover", "auto_turret_close", 1, 1, "int", &turret_close_anim, 0, 0);
	visionset_mgr::register_visionset_info("turret_visionset", 1, 16, undefined, "mp_vehicles_turret");
}

/*
	Name: turret_init_anim
	Namespace: autoturret
	Checksum: 0x56C9F524
	Offset: 0x328
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function turret_init_anim(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	self useanimtree($mp_autoturret);
	self setanimrestart(%mp_autoturret::o_turret_sentry_close, 1, 0, 1);
	self setanimtime(%mp_autoturret::o_turret_sentry_close, 1);
}

/*
	Name: turret_open
	Namespace: autoturret
	Checksum: 0x9D508BD6
	Offset: 0x3F8
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function turret_open(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	self useanimtree($mp_autoturret);
	self setanimrestart(%mp_autoturret::o_turret_sentry_deploy, 1, 0, 1);
}

/*
	Name: turret_close_anim
	Namespace: autoturret
	Checksum: 0xA01FF616
	Offset: 0x4A0
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function turret_close_anim(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	self useanimtree($mp_autoturret);
	self setanimrestart(%mp_autoturret::o_turret_sentry_close, 1, 0, 1);
}

