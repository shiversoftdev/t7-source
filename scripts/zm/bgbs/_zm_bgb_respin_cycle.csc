// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_respin_cycle;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_respin_cycle
	Checksum: 0x2517BB27
	Offset: 0x1A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_respin_cycle", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_respin_cycle
	Checksum: 0x8680F337
	Offset: 0x1E8
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_respin_cycle", "activated");
	clientfield::register("zbarrier", "zm_bgb_respin_cycle", 1, 1, "counter", &function_74ecbbd7, 0, 0);
	level._effect["zm_bgb_respin_cycle"] = "zombie/fx_bgb_respin_cycle_box_flash_zmb";
}

/*
	Name: function_74ecbbd7
	Namespace: zm_bgb_respin_cycle
	Checksum: 0xB7059D5C
	Offset: 0x290
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function function_74ecbbd7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfx(localclientnum, level._effect["zm_bgb_respin_cycle"], self.origin, anglestoforward(self.angles), anglestoup(self.angles));
}

