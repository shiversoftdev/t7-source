// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_equip_hacker;

#namespace zm_hackables_doors;

/*
	Name: door_struct_debug
	Namespace: zm_hackables_doors
	Checksum: 0xEA963748
	Offset: 0x148
	Size: 0x12A
	Parameters: 0
	Flags: None
*/
function door_struct_debug()
{
	while(true)
	{
		wait(0.1);
		origin = self.origin;
		point = origin;
		for(i = 1; i < 5; i++)
		{
			point = origin + (anglestoforward(self.door.angles) * (i * 2));
			passed = bullettracepassed(point, origin, 0, undefined);
			color = vectorscale((0, 1, 0), 255);
			if(!passed)
			{
				color = vectorscale((1, 0, 0), 255);
			}
			/#
				print3d(point, "", color, 1, 1);
			#/
		}
	}
}

/*
	Name: hack_doors
	Namespace: zm_hackables_doors
	Checksum: 0x2F1921BD
	Offset: 0x280
	Size: 0x206
	Parameters: 2
	Flags: Linked
*/
function hack_doors(targetname = "zombie_door", door_activate_func = &zm_blockers::door_opened)
{
	doors = getentarray(targetname, "targetname");
	for(i = 0; i < doors.size; i++)
	{
		door = doors[i];
		struct = spawnstruct();
		struct.origin = door.origin + (anglestoforward(door.angles) * 2);
		struct.radius = 48;
		struct.height = 72;
		struct.script_float = 32.7;
		struct.script_int = 200;
		struct.door = door;
		struct.no_bullet_trace = 1;
		struct.door_activate_func = door_activate_func;
		trace_passed = 0;
		door thread hide_door_buy_when_hacker_active(struct);
		zm_equip_hacker::register_pooled_hackable_struct(struct, &door_hack);
		door thread watch_door_for_open(struct);
	}
}

/*
	Name: hide_door_buy_when_hacker_active
	Namespace: zm_hackables_doors
	Checksum: 0x89EA7117
	Offset: 0x490
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function hide_door_buy_when_hacker_active(door_struct)
{
	self endon(#"death");
	self endon(#"door_hacked");
	self endon(#"door_opened");
	zm_equip_hacker::hide_hint_when_hackers_active();
}

/*
	Name: watch_door_for_open
	Namespace: zm_hackables_doors
	Checksum: 0x4D13B7EF
	Offset: 0x4E0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function watch_door_for_open(door_struct)
{
	self waittill(#"door_opened");
	self endon(#"door_hacked");
	remove_all_door_hackables_that_target_door(door_struct.door);
}

/*
	Name: door_hack
	Namespace: zm_hackables_doors
	Checksum: 0x29CE261A
	Offset: 0x530
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function door_hack(hacker)
{
	self.door notify(#"door_hacked");
	self.door notify(#"kill_door_think");
	remove_all_door_hackables_that_target_door(self.door);
	self.door [[self.door_activate_func]]();
	self.door._door_open = 1;
}

/*
	Name: remove_all_door_hackables_that_target_door
	Namespace: zm_hackables_doors
	Checksum: 0x660D7AD6
	Offset: 0x5B0
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function remove_all_door_hackables_that_target_door(door)
{
	candidates = [];
	for(i = 0; i < level._hackable_objects.size; i++)
	{
		obj = level._hackable_objects[i];
		if(isdefined(obj.door) && obj.door.target == door.target)
		{
			candidates[candidates.size] = obj;
		}
	}
	for(i = 0; i < candidates.size; i++)
	{
		zm_equip_hacker::deregister_hackable_struct(candidates[i]);
	}
}

