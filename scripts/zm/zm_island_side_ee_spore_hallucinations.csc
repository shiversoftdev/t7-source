// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_island_side_ee_spore_hallucinations;

/*
	Name: __init__sytem__
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0xEC95ED3F
	Offset: 0x300
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_side_ee_spore_hallucinations", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x33F5B985
	Offset: 0x340
	Size: 0x1DA
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "hallucinate_bloody_walls", 9000, 1, "int", &hallucinate_bloody_walls, 0, 0);
	clientfield::register("toplayer", "hallucinate_spooky_sounds", 9000, 1, "int", &hallucinate_spooky_sounds, 0, 0);
	var_68003f28 = findvolumedecalindexarray("side_ee_horror_room_lab_a");
	var_da07ae63 = findvolumedecalindexarray("side_ee_horror_room_lab_b");
	var_b40533fa = findvolumedecalindexarray("side_ee_horror_room_operation");
	level.var_d76c60c4 = arraycombine(var_68003f28, var_da07ae63, 0, 0);
	level.var_d76c60c4 = arraycombine(level.var_d76c60c4, var_b40533fa, 0, 0);
	foreach(var_27ae6b3e in level.var_d76c60c4)
	{
		hidevolumedecal(var_27ae6b3e);
	}
}

/*
	Name: hallucinate_bloody_walls
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0xB8E48930
	Offset: 0x528
	Size: 0x1EA
	Parameters: 7
	Flags: Linked
*/
function hallucinate_bloody_walls(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread lui::screen_fade_in(1, "white");
	if(isdefined(newval) && newval)
	{
		foreach(var_78960d69 in level.var_d76c60c4)
		{
			unhidevolumedecal(var_78960d69);
		}
		playsound(0, "zmb_spore_hallucinate_bloody_start", (0, 0, 0));
		self thread function_13d64112();
	}
	else
	{
		foreach(var_78960d69 in level.var_d76c60c4)
		{
			hidevolumedecal(var_78960d69);
		}
		playsound(0, "zmb_spore_hallucinate_bloody_end", (0, 0, 0));
		level notify(#"hash_dad9c949");
	}
}

/*
	Name: hallucinate_spooky_sounds
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x133B1B78
	Offset: 0x720
	Size: 0x12A
	Parameters: 7
	Flags: Linked
*/
function hallucinate_spooky_sounds(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(newval) && newval)
	{
		playsound(0, "zmb_spore_hallucinate_start", (0, 0, 0));
		if(!isdefined(self.var_dafc6232))
		{
			self.var_dafc6232 = self playloopsound("zmb_spore_hallucinate_lp_1", 2);
		}
		self thread function_13d64112();
	}
	else
	{
		playsound(0, "zmb_spore_hallucinate_end", (0, 0, 0));
		if(isdefined(self.var_dafc6232))
		{
			self stoploopsound(self.var_dafc6232, 2);
			self.var_dafc6232 = undefined;
		}
		level notify(#"hash_dad9c949");
	}
}

/*
	Name: function_13d64112
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x5965CCAF
	Offset: 0x858
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function function_13d64112()
{
	self notify(#"hash_dad9c949");
	self endon(#"hash_dad9c949");
	level endon(#"hash_dad9c949");
	self endon(#"disconnect");
	while(isdefined(self))
	{
		wait(randomintrange(1, 8));
		self playsound(0, "zmb_spore_hallucinate_whisper");
	}
}

