// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace destructible;

/*
	Name: __init__sytem__
	Namespace: destructible
	Checksum: 0x183D495F
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
	Checksum: 0x5FC646DB
	Offset: 0x140
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "start_destructible_explosion", 1, 11, "int", &doexplosion, 0, 0);
}

/*
	Name: playgrenaderumble
	Namespace: destructible
	Checksum: 0x69261B71
	Offset: 0x198
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function playgrenaderumble(localclientnum, position)
{
	playrumbleonposition(localclientnum, "grenade_rumble", position);
	getlocalplayer(localclientnum) earthquake(0.5, 0.5, position, 800);
}

/*
	Name: doexplosion
	Namespace: destructible
	Checksum: 0x38A4089C
	Offset: 0x218
	Size: 0x1A4
	Parameters: 7
	Flags: Linked
*/
function doexplosion(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		return;
	}
	var_824b40e2 = newval & (1 << 10);
	if(var_824b40e2)
	{
		newval = newval - (1 << 10);
	}
	physics_force = 0.3;
	var_34aa7e9b = newval & (1 << 9);
	if(var_34aa7e9b)
	{
		physics_force = 0.5;
		newval = newval - (1 << 9);
	}
	if(isdefined(var_824b40e2) && var_824b40e2)
	{
		physicsexplosionsphere(localclientnum, self.origin, newval, newval / 2, physics_force, 25, 400);
	}
	else
	{
		physicsexplosionsphere(localclientnum, self.origin, newval, newval - 1, physics_force, 25, 400);
	}
	playgrenaderumble(localclientnum, self.origin);
	soundrattle(self.origin, 200, 800);
}

