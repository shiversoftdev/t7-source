// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;

#namespace zm_zod_transformer;

/*
	Name: __init__sytem__
	Namespace: zm_zod_transformer
	Checksum: 0x603E7BF9
	Offset: 0x148
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_transformer", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_transformer
	Checksum: 0x15052C5A
	Offset: 0x188
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	n_bits = getminbitcountfornum(16);
	clientfield::register("scriptmover", "transformer_light_switch", 1, n_bits, "int", &transformer_light_switch, 0, 0);
}

/*
	Name: transformer_light_switch
	Namespace: zm_zod_transformer
	Checksum: 0x41F0C6D2
	Offset: 0x200
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function transformer_light_switch(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		exploder::exploder("powerbox_" + newval);
	}
}

