// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;

#namespace zm_game_module_utility;

/*
	Name: move_ring
	Namespace: zm_game_module_utility
	Checksum: 0xC2EA6A80
	Offset: 0xC8
	Size: 0x122
	Parameters: 1
	Flags: None
*/
function move_ring(ring)
{
	positions = struct::get_array(ring.target, "targetname");
	positions = array::randomize(positions);
	level endon(#"end_game");
	while(true)
	{
		foreach(position in positions)
		{
			self moveto(position.origin, randomintrange(30, 45));
			self waittill(#"movedone");
		}
	}
}

/*
	Name: rotate_ring
	Namespace: zm_game_module_utility
	Checksum: 0x2B93D922
	Offset: 0x1F8
	Size: 0x66
	Parameters: 1
	Flags: None
*/
function rotate_ring(forward)
{
	level endon(#"end_game");
	dir = -360;
	if(forward)
	{
		dir = 360;
	}
	while(true)
	{
		self rotateyaw(dir, 9);
		wait(9);
	}
}

