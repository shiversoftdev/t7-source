// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace planemortar;

/*
	Name: __init__sytem__
	Namespace: planemortar
	Checksum: 0x4FDA7BB
	Offset: 0x140
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("planemortar", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: planemortar
	Checksum: 0x527C0C8
	Offset: 0x180
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.planemortarexhaustfx = "killstreaks/fx_ls_exhaust_afterburner";
	clientfield::register("scriptmover", "planemortar_contrail", 1, 1, "int", &planemortar_contrail, 0, 0);
}

/*
	Name: planemortar_contrail
	Namespace: planemortar
	Checksum: 0xFE15E5F4
	Offset: 0x1E8
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function planemortar_contrail(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	if(newval)
	{
		self.fx = playfxontag(localclientnum, level.planemortarexhaustfx, self, "tag_fx");
	}
}

