// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_ai_sonic;

/*
	Name: __init__sytem__
	Namespace: zm_ai_sonic
	Checksum: 0x6A4B5C1D
	Offset: 0xE8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_sonic", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_sonic
	Checksum: 0x689CA440
	Offset: 0x128
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_clientfields();
}

/*
	Name: init_clientfields
	Namespace: zm_ai_sonic
	Checksum: 0xCC1B227B
	Offset: 0x148
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("actor", "issonic", 21000, 1, "int", &sonic_zombie_callback, 0, 0);
}

/*
	Name: sonic_zombie_callback
	Namespace: zm_ai_sonic
	Checksum: 0x34F715AA
	Offset: 0x1A0
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function sonic_zombie_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self thread sonic_ambient_sounds(localclientnum);
	}
	else
	{
		self thread function_59e62cc8(localclientnum);
	}
}

/*
	Name: sonic_ambient_sounds
	Namespace: zm_ai_sonic
	Checksum: 0x7FD0259B
	Offset: 0x228
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function sonic_ambient_sounds(client_num)
{
	if(client_num != 0)
	{
		return;
	}
	self playloopsound("evt_sonic_ambient_loop", 1);
}

/*
	Name: function_59e62cc8
	Namespace: zm_ai_sonic
	Checksum: 0xA42E6B18
	Offset: 0x270
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function function_59e62cc8(client_num)
{
	self notify(#"stop_sounds");
}

