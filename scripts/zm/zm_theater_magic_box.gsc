// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_net;

#namespace zm_theater_magic_box;

/*
	Name: magic_box_init
	Namespace: zm_theater_magic_box
	Checksum: 0x43A16D54
	Offset: 0x1D0
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function magic_box_init()
{
	util::registerclientsys("box_indicator");
	level._box_indicator_no_lights = -1;
	level._box_indicator_flash_lights_moving = 99;
	level._box_indicator_flash_lights_fire_sale = 98;
	level._box_locations = array("start_chest", "foyer_chest", "crematorium_chest", "alleyway_chest", "control_chest", "stage_chest", "dressing_chest", "dining_chest", "theater_chest");
	level thread magic_box_update();
	level thread watch_fire_sale();
	callback::on_connect(&function_72feb26b);
}

/*
	Name: function_72feb26b
	Namespace: zm_theater_magic_box
	Checksum: 0x28E6571A
	Offset: 0x2D0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_72feb26b()
{
	if(level flag::get("power_on"))
	{
		util::setclientsysstate("box_indicator", get_location_from_chest_index(level.chest_index));
	}
}

/*
	Name: get_location_from_chest_index
	Namespace: zm_theater_magic_box
	Checksum: 0xBE7D5BF1
	Offset: 0x338
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function get_location_from_chest_index(chest_index)
{
	chest_loc = level.chests[chest_index].script_noteworthy;
	for(i = 0; i < level._box_locations.size; i++)
	{
		if(level._box_locations[i] == chest_loc)
		{
			return i;
		}
	}
	/#
		assertmsg("" + chest_loc);
	#/
}

/*
	Name: magic_box_update
	Namespace: zm_theater_magic_box
	Checksum: 0x442C0B2B
	Offset: 0x3E0
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function magic_box_update()
{
	wait(2);
	level flag::wait_till("power_on");
	box_mode = "Box Available";
	util::setclientsysstate("box_indicator", get_location_from_chest_index(level.chest_index));
	while(true)
	{
		switch(box_mode)
		{
			case "Box Available":
			{
				if(level flag::get("moving_chest_now"))
				{
					util::setclientsysstate("box_indicator", level._box_indicator_flash_lights_moving);
					box_mode = "Box is Moving";
				}
				break;
			}
			case "Box is Moving":
			{
				while(level flag::get("moving_chest_now"))
				{
					wait(0.1);
				}
				util::setclientsysstate("box_indicator", get_location_from_chest_index(level.chest_index));
				box_mode = "Box Available";
				break;
			}
		}
		wait(0.5);
	}
}

/*
	Name: watch_fire_sale
	Namespace: zm_theater_magic_box
	Checksum: 0xB5219CB
	Offset: 0x548
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function watch_fire_sale()
{
	while(true)
	{
		level waittill(#"hash_3b3c2756");
		util::setclientsysstate("box_indicator", level._box_indicator_flash_lights_fire_sale);
		while(level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
		{
			wait(0.1);
		}
		util::setclientsysstate("box_indicator", get_location_from_chest_index(level.chest_index));
	}
}

