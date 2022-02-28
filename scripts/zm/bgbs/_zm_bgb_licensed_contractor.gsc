// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_licensed_contractor;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_licensed_contractor
	Checksum: 0xE47F214B
	Offset: 0x180
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_licensed_contractor", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_licensed_contractor
	Checksum: 0x2F25E1EA
	Offset: 0x1C0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_licensed_contractor", "activated", 3, undefined, undefined, undefined, &activation);
}

/*
	Name: activation
	Namespace: zm_bgb_licensed_contractor
	Checksum: 0xD0C39E03
	Offset: 0x220
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self thread bgb::function_dea74fb0("carpenter");
}

