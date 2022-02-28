// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\shared\callbacks_shared;
#using scripts\shared\compass;
#using scripts\shared\util_shared;

#namespace namespace_49ee819c;

/*
	Name: main
	Namespace: namespace_49ee819c
	Checksum: 0xC6A2DACE
	Offset: 0x1A8
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function main()
{
	precache();
	load::main();
	init();
}

/*
	Name: precache
	Namespace: namespace_49ee819c
	Checksum: 0x99EC1590
	Offset: 0x1E8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function precache()
{
}

/*
	Name: init
	Namespace: namespace_49ee819c
	Checksum: 0x99EC1590
	Offset: 0x1F8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function init()
{
}

/*
	Name: speed_test_init
	Namespace: namespace_49ee819c
	Checksum: 0x6F62621A
	Offset: 0x208
	Size: 0x1AC
	Parameters: 0
	Flags: None
*/
function speed_test_init()
{
	trigger1 = getent("speed_trigger1", "targetname");
	trigger2 = getent("speed_trigger2", "targetname");
	trigger3 = getent("speed_trigger3", "targetname");
	trigger4 = getent("speed_trigger4", "targetname");
	trigger5 = getent("speed_trigger5", "targetname");
	trigger6 = getent("speed_trigger6", "targetname");
	trigger1 thread speed_test();
	trigger2 thread speed_test();
	trigger3 thread speed_test();
	trigger4 thread speed_test();
	trigger5 thread speed_test();
	trigger6 thread speed_test();
}

/*
	Name: speed_test
	Namespace: namespace_49ee819c
	Checksum: 0xF42E5CC3
	Offset: 0x3C0
	Size: 0x80
	Parameters: 0
	Flags: None
*/
function speed_test()
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(isplayer(player))
		{
			self thread util::trigger_thread(player, &player_on_trigger, &player_off_trigger);
		}
		wait(0.05);
	}
}

/*
	Name: player_on_trigger
	Namespace: namespace_49ee819c
	Checksum: 0x96E4303
	Offset: 0x448
	Size: 0xC2
	Parameters: 2
	Flags: None
*/
function player_on_trigger(player, endon_string)
{
	player endon(#"death");
	player endon(#"disconnect");
	player endon(endon_string);
	if(isdefined(player._speed_test2))
	{
		player._speed_test1 = gettime();
		total_time = player._speed_test1 - player._speed_test2;
		iprintlnbold(("" + (total_time / 1000)) + "seconds");
		player._speed_test2 = undefined;
	}
}

/*
	Name: player_off_trigger
	Namespace: namespace_49ee819c
	Checksum: 0x94CE140A
	Offset: 0x518
	Size: 0x56
	Parameters: 1
	Flags: None
*/
function player_off_trigger(player)
{
	player endon(#"death");
	player endon(#"disconnect");
	player._speed_test2 = gettime();
	if(isdefined(player._speed_test1))
	{
		player._speed_test1 = undefined;
	}
}

