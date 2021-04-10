// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

#namespace namespace_4fca3ee8;

/*
	Name: main
	Namespace: namespace_4fca3ee8
	Checksum: 0x99EC1590
	Offset: 0xD0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function main()
{
}

#namespace namespace_1a381543;

/*
	Name: function_68fdd800
	Namespace: namespace_1a381543
	Checksum: 0x8514A9DF
	Offset: 0xE0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_68fdd800()
{
	if(!isdefined(level.var_ae4549e5))
	{
		level.var_ae4549e5 = spawn("script_origin", (0, 0, 0));
	}
	level.var_ae4549e5 playloopsound("amb_rally_bg");
	level.var_ae4549e5 function_42b6c406();
}

/*
	Name: function_42b6c406
	Namespace: namespace_1a381543
	Checksum: 0x87E393D2
	Offset: 0x158
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_42b6c406()
{
	level waittill(#"ro");
	self stoploopsound();
	wait(1);
	self delete();
}

