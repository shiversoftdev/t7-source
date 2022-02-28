// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\abilities\gadgets\_gadget_clone_render;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_clone;

/*
	Name: __init__sytem__
	Namespace: _gadget_clone
	Checksum: 0x4FCC7EA5
	Offset: 0x2D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_clone", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_clone
	Checksum: 0x172B240F
	Offset: 0x318
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("actor", "clone_activated", 1, 1, "int", &clone_activated, 0, 1);
	clientfield::register("actor", "clone_damaged", 1, 1, "int", &clone_damaged, 0, 0);
	clientfield::register("allplayers", "clone_activated", 1, 1, "int", &player_clone_activated, 0, 0);
}

/*
	Name: set_shader
	Namespace: _gadget_clone
	Checksum: 0x98284375
	Offset: 0x400
	Size: 0x84
	Parameters: 3
	Flags: Linked
*/
function set_shader(localclientnum, enabled, entity)
{
	if(entity isfriendly(localclientnum))
	{
		self duplicate_render::update_dr_flag(localclientnum, "clone_ally_on", enabled);
	}
	else
	{
		self duplicate_render::update_dr_flag(localclientnum, "clone_enemy_on", enabled);
	}
}

/*
	Name: clone_activated
	Namespace: _gadget_clone
	Checksum: 0x5C834F63
	Offset: 0x490
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function clone_activated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self._isclone = 1;
		self set_shader(localclientnum, 1, self getowner(localclientnum));
		if(isdefined(level._monitor_tracker))
		{
			self thread [[level._monitor_tracker]](localclientnum);
		}
		self thread gadget_clone_render::transition_shader(localclientnum);
	}
}

/*
	Name: player_clone_activated
	Namespace: _gadget_clone
	Checksum: 0x45B8F3
	Offset: 0x558
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function player_clone_activated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		self set_shader(localclientnum, 1, self);
		self thread gadget_clone_render::transition_shader(localclientnum);
	}
	else
	{
		self set_shader(localclientnum, 0, self);
		self notify(#"clone_shader_off");
		self mapshaderconstant(localclientnum, 0, "scriptVector3", 1, 0, 0, 1);
	}
}

/*
	Name: clone_damage_flicker
	Namespace: _gadget_clone
	Checksum: 0xEA2814F6
	Offset: 0x640
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function clone_damage_flicker(localclientnum)
{
	self endon(#"entityshutdown");
	self notify(#"start_flicker");
	self endon(#"start_flicker");
	self duplicate_render::update_dr_flag(localclientnum, "clone_damage", 1);
	self waittill(#"stop_flicker");
	self duplicate_render::update_dr_flag(localclientnum, "clone_damage", 0);
}

/*
	Name: clone_damage_finish
	Namespace: _gadget_clone
	Checksum: 0xBE0400B5
	Offset: 0x6D0
	Size: 0x3E
	Parameters: 0
	Flags: Linked
*/
function clone_damage_finish()
{
	self endon(#"entityshutdown");
	self endon(#"start_flicker");
	self endon(#"stop_flicker");
	wait(0.2);
	self notify(#"stop_flicker");
}

/*
	Name: clone_damaged
	Namespace: _gadget_clone
	Checksum: 0x41EA835C
	Offset: 0x718
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function clone_damaged(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread clone_damage_flicker(localclientnum);
	}
	else
	{
		self thread clone_damage_finish();
	}
}

