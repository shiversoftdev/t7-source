// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace ball;

/*
	Name: add_ball_return_trigger
	Namespace: ball
	Checksum: 0x6693204A
	Offset: 0x78
	Size: 0x3A
	Parameters: 1
	Flags: None
*/
function add_ball_return_trigger(trigger)
{
	if(!isdefined(level.ball_return_trigger))
	{
		level.ball_return_trigger = [];
	}
	level.ball_return_trigger[level.ball_return_trigger.size] = trigger;
}

