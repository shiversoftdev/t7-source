// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;

#using_animtree("generic");

#namespace zm_zod_idgun_quest;

/*
	Name: __init__sytem__
	Namespace: zm_zod_idgun_quest
	Checksum: 0x826F946
	Offset: 0x188
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_idgun_quest", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_idgun_quest
	Checksum: 0x57843B39
	Offset: 0x1C8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("world", "add_idgun_to_box", 1, 4, "int", &add_idgun_to_box, 0, 0);
	clientfield::register("world", "remove_idgun_from_box", 1, 4, "int", &remove_idgun_from_box, 0, 0);
}

/*
	Name: add_idgun_to_box
	Namespace: zm_zod_idgun_quest
	Checksum: 0x849DB830
	Offset: 0x268
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function add_idgun_to_box(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	weapon_idgun = getweapon(("idgun" + "_") + newval);
	addzombieboxweapon(weapon_idgun, weapon_idgun.worldmodel, weapon_idgun.isdualwield);
}

/*
	Name: remove_idgun_from_box
	Namespace: zm_zod_idgun_quest
	Checksum: 0xD392FF6
	Offset: 0x310
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function remove_idgun_from_box(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	weapon_idgun = getweapon(("idgun" + "_") + newval);
	removezombieboxweapon(weapon_idgun);
}

