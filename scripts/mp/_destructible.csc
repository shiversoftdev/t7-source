// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace destructible;

/*
	Name: __init__sytem__
	Namespace: destructible
	Checksum: 0x8622D0B1
	Offset: 0x100
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("destructible", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: destructible
	Checksum: 0x7CF1A32F
	Offset: 0x140
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "start_destructible_explosion", 1, 10, "int", &doexplosion, 0, 0);
}

/*
	Name: playgrenaderumble
	Namespace: destructible
	Checksum: 0x1098056D
	Offset: 0x198
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function playgrenaderumble(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playrumbleonposition(localclientnum, "grenade_rumble", self.origin);
	getlocalplayer(localclientnum) earthquake(0.5, 0.5, self.origin, 800);
}

/*
	Name: doexplosion
	Namespace: destructible
	Checksum: 0x1FB84A1E
	Offset: 0x250
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function doexplosion(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		return;
	}
	physics_explosion = 0;
	if(newval & (1 << 9))
	{
		physics_explosion = 1;
		newval = newval - (1 << 9);
	}
	physics_force = 0.3;
	if(physics_explosion)
	{
		physicsexplosionsphere(localclientnum, self.origin, newval, newval - 1, physics_force, 25, 400);
	}
	playgrenaderumble(localclientnum, self.origin);
}

