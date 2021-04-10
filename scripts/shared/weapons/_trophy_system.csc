// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#using_animtree("mp_trophy_system");

#namespace trophy_system;

/*
	Name: init_shared
	Namespace: trophy_system
	Checksum: 0x984C335
	Offset: 0x1A8
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function init_shared(localclientnum)
{
	clientfield::register("missile", "trophy_system_state", 1, 2, "int", &trophy_state_change, 0, 1);
	clientfield::register("scriptmover", "trophy_system_state", 1, 2, "int", &trophy_state_change_recon, 0, 0);
}

/*
	Name: trophy_state_change
	Namespace: trophy_system
	Checksum: 0x8AAA277B
	Offset: 0x250
	Size: 0xDE
	Parameters: 7
	Flags: None
*/
function trophy_state_change(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newval)
	{
		case 1:
		{
			self thread trophy_rolling_anim(localclientnum);
			break;
		}
		case 2:
		{
			self thread trophy_stationary_anim(localclientnum);
			break;
		}
		case 3:
		{
			break;
		}
		case 0:
		{
			break;
		}
	}
}

/*
	Name: trophy_state_change_recon
	Namespace: trophy_system
	Checksum: 0x226FA8B2
	Offset: 0x338
	Size: 0xDE
	Parameters: 7
	Flags: None
*/
function trophy_state_change_recon(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newval)
	{
		case 1:
		{
			self thread trophy_rolling_anim(localclientnum);
			break;
		}
		case 2:
		{
			self thread trophy_stationary_anim(localclientnum);
			break;
		}
		case 3:
		{
			break;
		}
		case 0:
		{
			break;
		}
	}
}

/*
	Name: trophy_rolling_anim
	Namespace: trophy_system
	Checksum: 0x5AC8D53D
	Offset: 0x420
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function trophy_rolling_anim(localclientnum)
{
	self endon(#"entityshutdown");
	self useanimtree($mp_trophy_system);
	self setanim(%mp_trophy_system::o_trophy_deploy, 1);
}

/*
	Name: trophy_stationary_anim
	Namespace: trophy_system
	Checksum: 0x2AFC6136
	Offset: 0x488
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function trophy_stationary_anim(localclientnum)
{
	self endon(#"entityshutdown");
	self useanimtree($mp_trophy_system);
	self setanim(%mp_trophy_system::o_trophy_deploy, 0);
	self setanim(%mp_trophy_system::o_trophy_spin, 1);
}

