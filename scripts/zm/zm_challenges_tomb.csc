// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_utility;

#namespace zm_challenges_tomb;

/*
	Name: __init__sytem__
	Namespace: zm_challenges_tomb
	Checksum: 0x3F5E0D4A
	Offset: 0x178
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_challenges_tomb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_challenges_tomb
	Checksum: 0x5A1A0D0E
	Offset: 0x1B8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "challenges.challenge_complete_1", 21000, 2, "int", &zm_utility::setinventoryuimodels, 0, 1);
	clientfield::register("toplayer", "challenges.challenge_complete_2", 21000, 2, "int", &zm_utility::setinventoryuimodels, 0, 1);
	clientfield::register("toplayer", "challenges.challenge_complete_3", 21000, 2, "int", &zm_utility::setinventoryuimodels, 0, 1);
	clientfield::register("toplayer", "challenges.challenge_complete_4", 21000, 2, "int", &function_2d46c9fd, 0, 1);
}

/*
	Name: function_2d46c9fd
	Namespace: zm_challenges_tomb
	Checksum: 0x6D8295F5
	Offset: 0x2E8
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function function_2d46c9fd(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 2 && isspectating(localclientnum))
	{
		return;
	}
	zm_utility::setsharedinventoryuimodels(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump);
}

