// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_metro_fx;
#using scripts\mp\mp_metro_sound;
#using scripts\mp\mp_metro_train;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\util_shared;

#namespace mp_metro;

/*
	Name: main
	Namespace: mp_metro
	Checksum: 0x15CB9FB7
	Offset: 0x1D8
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	precache();
	setdvar("phys_buoyancy", 1);
	clientfield::register("scriptmover", "mp_metro_train_timer", 1, 1, "int");
	mp_metro_fx::main();
	mp_metro_sound::main();
	load::main();
	compass::setupminimap("compass_map_mp_metro");
	setdvar("compassmaxrange", "2100");
	level.cleandepositpoints = array((-399.059, 1.39783, -47.875), (-1539.2, -239.678, -207.875), (878.216, -0.543464, -47.875), (69.9086, 1382.49, 0.125));
	if(getgametypesetting("allowMapScripting"))
	{
		level thread mp_metro_train::init();
	}
	/#
		level thread devgui_metro();
		execdevgui("");
	#/
}

/*
	Name: precache
	Namespace: mp_metro
	Checksum: 0x99EC1590
	Offset: 0x390
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function precache()
{
}

/*
	Name: devgui_metro
	Namespace: mp_metro
	Checksum: 0x1961E654
	Offset: 0x3A0
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function devgui_metro()
{
	/#
		setdvar("", "");
		for(;;)
		{
			wait(0.5);
			devgui_string = getdvarstring("");
			switch(devgui_string)
			{
				case "":
				{
					break;
				}
				case "":
				{
					level notify(#"train_start_1");
					break;
				}
				case "":
				{
					level notify(#"train_start_2");
					break;
				}
				default:
				{
					break;
				}
			}
			if(getdvarstring("") != "")
			{
				setdvar("", "");
			}
		}
	#/
}

