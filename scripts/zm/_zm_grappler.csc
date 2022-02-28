// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_grappler;

/*
	Name: __init__sytem__
	Namespace: zm_grappler
	Checksum: 0xF7763E72
	Offset: 0x208
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_grappler", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_grappler
	Checksum: 0xD78A5AEB
	Offset: 0x248
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "grappler_beam_source", 15000, 1, "int", &function_79d05fa8, 0, 0);
	clientfield::register("scriptmover", "grappler_beam_target", 15000, 1, "int", &function_7bbbd82e, 0, 0);
}

/*
	Name: function_79d05fa8
	Namespace: zm_grappler
	Checksum: 0x2BEDF7C9
	Offset: 0x2E8
	Size: 0x6E
	Parameters: 7
	Flags: Linked
*/
function function_79d05fa8(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.var_3d35ab43))
	{
		level.var_3d35ab43 = [];
	}
	if(newval)
	{
		level.var_3d35ab43[localclientnum] = self;
	}
}

/*
	Name: function_7bbbd82e
	Namespace: zm_grappler
	Checksum: 0x99739A26
	Offset: 0x360
	Size: 0xD6
	Parameters: 7
	Flags: Linked
*/
function function_7bbbd82e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.var_3d35ab43))
	{
		level.var_3d35ab43 = [];
	}
	/#
		assert(isdefined(level.var_3d35ab43[localclientnum]));
	#/
	pivot = level.var_3d35ab43[localclientnum];
	if(newval)
	{
		thread function_55af4b5b(self, "tag_origin", pivot, 0.05);
	}
	else
	{
		self notify(#"hash_dabe9c83");
	}
}

/*
	Name: function_55af4b5b
	Namespace: zm_grappler
	Checksum: 0x10DD379B
	Offset: 0x440
	Size: 0x54
	Parameters: 4
	Flags: Linked
*/
function function_55af4b5b(player, tag, pivot, delay)
{
	player endon(#"hash_dabe9c83");
	wait(delay);
	thread grapple_beam(player, tag, pivot);
}

/*
	Name: grapple_beam
	Namespace: zm_grappler
	Checksum: 0x48D4D47E
	Offset: 0x4A0
	Size: 0x8C
	Parameters: 3
	Flags: Linked
*/
function grapple_beam(player, tag, pivot)
{
	level beam::launch(player, tag, pivot, "tag_origin", "zod_beast_grapple_beam");
	player waittill(#"hash_dabe9c83");
	level beam::kill(player, tag, pivot, "tag_origin", "zod_beast_grapple_beam");
}

