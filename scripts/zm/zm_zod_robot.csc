// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_zod_robot;

/*
	Name: __init__sytem__
	Namespace: zm_zod_robot
	Checksum: 0x34716B07
	Offset: 0x2C0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_robot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_robot
	Checksum: 0xE94728A4
	Offset: 0x300
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "robot_switch", 1, 1, "int", &robot_switch, 0, 0);
	clientfield::register("world", "robot_lights", 1, 2, "int", &robot_lights, 0, 0);
	ai::add_archetype_spawn_function("zod_companion", &function_a0b7ccbf);
}

/*
	Name: function_a0b7ccbf
	Namespace: zm_zod_robot
	Checksum: 0x25BA1C5C
	Offset: 0x3C8
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_a0b7ccbf(localclientnum)
{
	entity = self;
	entity setdrawname(&"ZM_ZOD_ROBOT_NAME");
}

/*
	Name: robot_switch
	Namespace: zm_zod_robot
	Checksum: 0x82129AED
	Offset: 0x410
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function robot_switch(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfx(localclientnum, "zombie/fx_fuse_master_switch_on_zod_zmb", self.origin);
}

/*
	Name: robot_lights
	Namespace: zm_zod_robot
	Checksum: 0xCC0E75EA
	Offset: 0x480
	Size: 0x1A6
	Parameters: 7
	Flags: Linked
*/
function robot_lights(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 1:
		{
			exploder::exploder("lgt_robot_callbox_green");
			exploder::stop_exploder("lgt_robot_callbox_red");
			exploder::stop_exploder("lgt_robot_callbox_yellow");
			break;
		}
		case 2:
		{
			exploder::stop_exploder("lgt_robot_callbox_green");
			exploder::exploder("lgt_robot_callbox_red");
			exploder::stop_exploder("lgt_robot_callbox_yellow");
			break;
		}
		case 3:
		{
			exploder::stop_exploder("lgt_robot_callbox_green");
			exploder::stop_exploder("lgt_robot_callbox_red");
			exploder::exploder("lgt_robot_callbox_yellow");
			break;
		}
		default:
		{
			exploder::stop_exploder("lgt_robot_callbox_green");
			exploder::stop_exploder("lgt_robot_callbox_red");
			exploder::stop_exploder("lgt_robot_callbox_yellow");
			break;
		}
	}
}

