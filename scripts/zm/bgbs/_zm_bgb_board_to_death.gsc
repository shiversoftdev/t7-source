// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_board_to_death;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_board_to_death
	Checksum: 0x36DE24E4
	Offset: 0x170
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_board_to_death", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_board_to_death
	Checksum: 0xAD1708BC
	Offset: 0x1B0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_board_to_death", "time", 300, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_board_to_death
	Checksum: 0x283366A0
	Offset: 0x218
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	self thread function_3c61f2df();
}

/*
	Name: disable
	Namespace: zm_bgb_board_to_death
	Checksum: 0x99EC1590
	Offset: 0x240
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function disable()
{
}

/*
	Name: function_3c61f2df
	Namespace: zm_bgb_board_to_death
	Checksum: 0x1C8C7534
	Offset: 0x250
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_3c61f2df()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_update");
	while(true)
	{
		self waittill(#"boarding_window", s_window);
		self bgb::do_one_shot_use();
		self thread function_64ea6cea(s_window);
	}
}

/*
	Name: function_64ea6cea
	Namespace: zm_bgb_board_to_death
	Checksum: 0x21A8FC74
	Offset: 0x2D0
	Size: 0x166
	Parameters: 1
	Flags: Linked
*/
function function_64ea6cea(s_window)
{
	wait(0.3);
	a_ai = getaiteamarray(level.zombie_team);
	a_closest = arraysortclosest(a_ai, s_window.origin, a_ai.size, 0, 180);
	for(i = 0; i < a_closest.size; i++)
	{
		if(a_closest[i].archetype === "zombie" && isalive(a_closest[i]))
		{
			a_closest[i] dodamage(a_closest[i].health + 100, a_closest[i].origin);
			a_closest[i] playsound("zmb_bgb_boardtodeath_imp");
			wait(randomfloatrange(0.05, 0.2));
		}
	}
}

