// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_dev;
#using scripts\shared\util_shared;

#namespace dev_class;

/*
	Name: dev_cac_init
	Namespace: dev_class
	Checksum: 0xC80A5CAD
	Offset: 0xE8
	Size: 0x630
	Parameters: 0
	Flags: Linked
*/
function dev_cac_init()
{
	/#
		dev_cac_overlay = 0;
		dev_cac_camera_on = 0;
		level thread dev_cac_gdt_update_think();
		for(;;)
		{
			wait(0.5);
			reset = 1;
			if(getdvarstring("") != "")
			{
				continue;
			}
			host = util::gethostplayer();
			if(!isdefined(level.dev_cac_player))
			{
				level.dev_cac_player = host;
			}
			switch(getdvarstring(""))
			{
				case "":
				{
					reset = 0;
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_body, "");
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_head, "");
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_character, "");
					break;
				}
				case "":
				{
					dev_cac_cycle_player(1);
					break;
				}
				case "":
				{
					dev_cac_cycle_player(0);
					break;
				}
				case "":
				{
					level notify(#"dev_cac_overlay_think");
					if(!dev_cac_overlay)
					{
						level thread dev_cac_overlay_think();
					}
					dev_cac_overlay = !dev_cac_overlay;
					break;
				}
				case "":
				{
					dev_cac_set_model_range(&sort_greatest, "");
					break;
				}
				case "":
				{
					dev_cac_set_model_range(&sort_least, "");
					break;
				}
				case "":
				{
					dev_cac_set_model_range(&sort_greatest, "");
					break;
				}
				case "":
				{
					dev_cac_set_model_range(&sort_least, "");
					break;
				}
				case "":
				{
					dev_cac_set_model_range(&sort_greatest, "");
					break;
				}
				case "":
				{
					dev_cac_set_model_range(&sort_least, "");
					break;
				}
				case "":
				{
					dev_cac_camera_on = !dev_cac_camera_on;
					dev_cac_camera(dev_cac_camera_on);
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_render_options, "");
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_render_options, "");
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_render_options, "");
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_render_options, "");
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_render_options, "");
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_render_options, "");
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_render_options, "");
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_render_options, "");
					break;
				}
				case "":
				{
					host thread dev_cac_dpad_think("", &dev_cac_cycle_render_options, "");
					break;
				}
				case "":
				{
					host notify(#"dev_cac_dpad_think");
					break;
				}
			}
			if(reset)
			{
				setdvar("", "");
			}
		}
	#/
}

/*
	Name: dev_cac_camera
	Namespace: dev_class
	Checksum: 0x91FC1279
	Offset: 0x720
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function dev_cac_camera(on)
{
	/#
		if(on)
		{
			self setclientthirdperson(1);
			setdvar("", "");
			setdvar("", "");
			setdvar("", "");
		}
		else
		{
			self setclientthirdperson(0);
			setdvar("", getdvarstring(""));
		}
	#/
}

/*
	Name: dev_cac_dpad_think
	Namespace: dev_class
	Checksum: 0xD5250500
	Offset: 0x808
	Size: 0x1FC
	Parameters: 3
	Flags: Linked
*/
function dev_cac_dpad_think(part_name, cycle_function, tag)
{
	/#
		self notify(#"dev_cac_dpad_think");
		self endon(#"dev_cac_dpad_think");
		self endon(#"disconnect");
		iprintln(("" + part_name) + "");
		iprintln(("" + part_name) + "");
		dpad_left = 0;
		dpad_right = 0;
		level.dev_cac_player thread highlight_player();
		for(;;)
		{
			self setactionslot(3, "");
			self setactionslot(4, "");
			if(!dpad_left && self buttonpressed(""))
			{
				[[cycle_function]](0, tag);
				dpad_left = 1;
			}
			else if(!self buttonpressed(""))
			{
				dpad_left = 0;
			}
			if(!dpad_right && self buttonpressed(""))
			{
				[[cycle_function]](1, tag);
				dpad_right = 1;
			}
			else if(!self buttonpressed(""))
			{
				dpad_right = 0;
			}
			wait(0.05);
		}
	#/
}

/*
	Name: next_in_list
	Namespace: dev_class
	Checksum: 0x926EAF23
	Offset: 0xA10
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function next_in_list(value, list)
{
	/#
		if(!isdefined(value))
		{
			return list[0];
		}
		for(i = 0; i < list.size; i++)
		{
			if(value == list[i])
			{
				if(isdefined(list[i + 1]))
				{
					value = list[i + 1];
				}
				else
				{
					value = list[0];
				}
				break;
			}
		}
		return value;
	#/
}

/*
	Name: prev_in_list
	Namespace: dev_class
	Checksum: 0xA0202941
	Offset: 0xAD0
	Size: 0xBA
	Parameters: 2
	Flags: Linked
*/
function prev_in_list(value, list)
{
	/#
		if(!isdefined(value))
		{
			return list[0];
		}
		for(i = 0; i < list.size; i++)
		{
			if(value == list[i])
			{
				if(isdefined(list[i - 1]))
				{
					value = list[i - 1];
				}
				else
				{
					value = list[list.size - 1];
				}
				break;
			}
		}
		return value;
	#/
}

/*
	Name: dev_cac_set_player_model
	Namespace: dev_class
	Checksum: 0x1B90951A
	Offset: 0xB98
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function dev_cac_set_player_model()
{
	/#
		self.tag_stowed_back = undefined;
		self.tag_stowed_hip = undefined;
	#/
}

/*
	Name: dev_cac_cycle_body
	Namespace: dev_class
	Checksum: 0x3C550183
	Offset: 0xBC0
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function dev_cac_cycle_body(forward, tag)
{
	/#
		if(!dev_cac_player_valid())
		{
			return;
		}
		player = level.dev_cac_player;
		keys = getarraykeys(level.cac_functions[""]);
		if(forward)
		{
			player.cac_body_type = next_in_list(player.cac_body_type, keys);
		}
		else
		{
			player.cac_body_type = prev_in_list(player.cac_body_type, keys);
		}
		player dev_cac_set_player_model();
	#/
}

/*
	Name: dev_cac_cycle_head
	Namespace: dev_class
	Checksum: 0x28BBD674
	Offset: 0xCC0
	Size: 0x10C
	Parameters: 2
	Flags: Linked
*/
function dev_cac_cycle_head(forward, tag)
{
	/#
		if(!dev_cac_player_valid())
		{
			return;
		}
		player = level.dev_cac_player;
		keys = getarraykeys(level.cac_functions[""]);
		if(forward)
		{
			player.cac_head_type = next_in_list(player.cac_head_type, keys);
		}
		else
		{
			player.cac_head_type = prev_in_list(player.cac_head_type, keys);
		}
		player.cac_hat_type = "";
		player dev_cac_set_player_model();
	#/
}

/*
	Name: dev_cac_cycle_character
	Namespace: dev_class
	Checksum: 0x23BE81AB
	Offset: 0xDD8
	Size: 0x10C
	Parameters: 2
	Flags: Linked
*/
function dev_cac_cycle_character(forward, tag)
{
	/#
		if(!dev_cac_player_valid())
		{
			return;
		}
		player = level.dev_cac_player;
		keys = getarraykeys(level.cac_functions[""]);
		if(forward)
		{
			player.cac_body_type = next_in_list(player.cac_body_type, keys);
		}
		else
		{
			player.cac_body_type = prev_in_list(player.cac_body_type, keys);
		}
		player.cac_hat_type = "";
		player dev_cac_set_player_model();
	#/
}

/*
	Name: dev_cac_cycle_render_options
	Namespace: dev_class
	Checksum: 0xC16CEE3E
	Offset: 0xEF0
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function dev_cac_cycle_render_options(forward, tag)
{
	/#
		if(!dev_cac_player_valid())
		{
			return;
		}
		level.dev_cac_player nextplayerrenderoption(tag, forward);
	#/
}

/*
	Name: dev_cac_player_valid
	Namespace: dev_class
	Checksum: 0x1A42D779
	Offset: 0xF50
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function dev_cac_player_valid()
{
	/#
		return isdefined(level.dev_cac_player) && level.dev_cac_player.sessionstate == "";
	#/
}

/*
	Name: dev_cac_cycle_player
	Namespace: dev_class
	Checksum: 0x6CC2019A
	Offset: 0xF88
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function dev_cac_cycle_player(forward)
{
	/#
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(forward)
			{
				level.dev_cac_player = next_in_list(level.dev_cac_player, players);
			}
			else
			{
				level.dev_cac_player = prev_in_list(level.dev_cac_player, players);
			}
			if(dev_cac_player_valid())
			{
				level.dev_cac_player thread highlight_player();
				return;
			}
		}
		level.dev_cac_player = undefined;
	#/
}

/*
	Name: highlight_player
	Namespace: dev_class
	Checksum: 0x4F345C3C
	Offset: 0x1078
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function highlight_player()
{
	/#
		self sethighlighted(1);
		wait(1);
		self sethighlighted(0);
	#/
}

/*
	Name: dev_cac_overlay_think
	Namespace: dev_class
	Checksum: 0xCD91AD7D
	Offset: 0x10C8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function dev_cac_overlay_think()
{
	/#
		hud = dev_cac_overlay_create();
		level thread dev_cac_overlay_update(hud);
		level waittill(#"dev_cac_overlay_think");
		dev_cac_overlay_destroy(hud);
	#/
}

/*
	Name: dev_cac_overlay_update
	Namespace: dev_class
	Checksum: 0x9368DFD2
	Offset: 0x1138
	Size: 0x10
	Parameters: 1
	Flags: Linked
*/
function dev_cac_overlay_update(hud)
{
	/#
	#/
}

/*
	Name: dev_cac_overlay_destroy
	Namespace: dev_class
	Checksum: 0x312AEC
	Offset: 0x1150
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function dev_cac_overlay_destroy(hud)
{
	/#
		for(i = 0; i < hud.menu.size; i++)
		{
			hud.menu[i] destroy();
		}
		hud destroy();
		setdvar("", "");
	#/
}

/*
	Name: dev_cac_overlay_create
	Namespace: dev_class
	Checksum: 0xAF3B9C1D
	Offset: 0x1200
	Size: 0xD92
	Parameters: 0
	Flags: Linked
*/
function dev_cac_overlay_create()
{
	/#
		x = -80;
		y = 140;
		menu_name = "";
		hud = dev::new_hud(menu_name, undefined, x, y, 1);
		hud setshader("", 185, 285);
		hud.alignx = "";
		hud.aligny = "";
		hud.sort = 10;
		hud.alpha = 0.6;
		hud.color = vectorscale((0, 0, 1), 0.5);
		x_offset = 100;
		hud.menu[0] = dev::new_hud(menu_name, "", x + 5, y + 10, 1.3);
		hud.menu[1] = dev::new_hud(menu_name, "", x + 5, y + 25, 1);
		hud.menu[2] = dev::new_hud(menu_name, "", x + 5, y + 35, 1);
		hud.menu[3] = dev::new_hud(menu_name, "", x + 5, y + 45, 1);
		hud.menu[4] = dev::new_hud(menu_name, "", x + 5, y + 55, 1);
		hud.menu[5] = dev::new_hud(menu_name, "", x + 5, y + 70, 1);
		hud.menu[6] = dev::new_hud(menu_name, "", x + 5, y + 80, 1);
		hud.menu[7] = dev::new_hud(menu_name, "", x + 5, y + 90, 1);
		hud.menu[8] = dev::new_hud(menu_name, "", x + 5, y + 100, 1);
		hud.menu[9] = dev::new_hud(menu_name, "", x + 5, y + 110, 1);
		hud.menu[10] = dev::new_hud(menu_name, "", x + 5, y + 120, 1);
		hud.menu[11] = dev::new_hud(menu_name, "", x + 5, y + 135, 1);
		hud.menu[12] = dev::new_hud(menu_name, "", x + 5, y + 145, 1);
		hud.menu[13] = dev::new_hud(menu_name, "", x + 5, y + 155, 1);
		hud.menu[14] = dev::new_hud(menu_name, "", x + 5, y + 170, 1);
		hud.menu[15] = dev::new_hud(menu_name, "", x + 5, y + 180, 1);
		hud.menu[16] = dev::new_hud(menu_name, "", x + 5, y + 190, 1);
		hud.menu[17] = dev::new_hud(menu_name, "", x + 5, y + 205, 1);
		hud.menu[18] = dev::new_hud(menu_name, "", x + 5, y + 215, 1);
		hud.menu[19] = dev::new_hud(menu_name, "", x + 5, y + 225, 1);
		hud.menu[20] = dev::new_hud(menu_name, "", x + 5, y + 235, 1);
		hud.menu[21] = dev::new_hud(menu_name, "", x + 5, y + 245, 1);
		hud.menu[22] = dev::new_hud(menu_name, "", x + 5, y + 255, 1);
		hud.menu[23] = dev::new_hud(menu_name, "", x + 5, y + 265, 1);
		hud.menu[24] = dev::new_hud(menu_name, "", x + 5, y + 275, 1);
		x_offset = 65;
		hud.menu[25] = dev::new_hud(menu_name, "", x + x_offset, y + 35, 1);
		hud.menu[26] = dev::new_hud(menu_name, "", x + x_offset, y + 45, 1);
		hud.menu[27] = dev::new_hud(menu_name, "", x + x_offset, y + 55, 1);
		x_offset = 100;
		hud.menu[28] = dev::new_hud(menu_name, "", x + x_offset, y + 80, 1);
		hud.menu[29] = dev::new_hud(menu_name, "", x + x_offset, y + 90, 1);
		hud.menu[30] = dev::new_hud(menu_name, "", x + x_offset, y + 100, 1);
		hud.menu[31] = dev::new_hud(menu_name, "", x + x_offset, y + 110, 1);
		hud.menu[32] = dev::new_hud(menu_name, "", x + x_offset, y + 120, 1);
		hud.menu[33] = dev::new_hud(menu_name, "", x + x_offset, y + 145, 1);
		hud.menu[34] = dev::new_hud(menu_name, "", x + x_offset, y + 155, 1);
		hud.menu[35] = dev::new_hud(menu_name, "", x + x_offset, y + 180, 1);
		hud.menu[36] = dev::new_hud(menu_name, "", x + x_offset, y + 190, 1);
		x_offset = 65;
		hud.menu[37] = dev::new_hud(menu_name, "", x + x_offset, y + 215, 1);
		hud.menu[38] = dev::new_hud(menu_name, "", x + x_offset, y + 225, 1);
		hud.menu[39] = dev::new_hud(menu_name, "", x + x_offset, y + 235, 1);
		hud.menu[40] = dev::new_hud(menu_name, "", x + x_offset, y + 245, 1);
		hud.menu[41] = dev::new_hud(menu_name, "", x + x_offset, y + 255, 1);
		hud.menu[42] = dev::new_hud(menu_name, "", x + x_offset, y + 265, 1);
		hud.menu[43] = dev::new_hud(menu_name, "", x + x_offset, y + 275, 1);
		return hud;
	#/
}

/*
	Name: color
	Namespace: dev_class
	Checksum: 0x5CAA611A
	Offset: 0x1FA0
	Size: 0xA6
	Parameters: 1
	Flags: None
*/
function color(value)
{
	/#
		r = 1;
		g = 1;
		b = 0;
		color = (0, 0, 0);
		if(value > 0)
		{
			r = r - value;
		}
		else
		{
			g = g + value;
		}
		c = (r, g, b);
		return c;
	#/
}

/*
	Name: dev_cac_gdt_update_think
	Namespace: dev_class
	Checksum: 0x849C748C
	Offset: 0x2050
	Size: 0x1A6
	Parameters: 0
	Flags: Linked
*/
function dev_cac_gdt_update_think()
{
	/#
		for(;;)
		{
			level waittill(#"gdt_update", asset, keyvalue);
			keyvalue = strtok(keyvalue, "");
			key = keyvalue[0];
			switch(key)
			{
				case "":
				{
					key = "";
					break;
				}
				case "":
				{
					key = "";
					break;
				}
				case "":
				{
					key = "";
					break;
				}
				case "":
				{
					key = "";
					break;
				}
				case "":
				{
					key = "";
					break;
				}
				default:
				{
					key = undefined;
					break;
				}
			}
			if(!isdefined(key))
			{
				continue;
			}
			value = float(keyvalue[1]);
			level.cac_attributes[key][asset] = value;
			players = getplayers();
			for(i = 0; i < players.size; i++)
			{
			}
		}
	#/
}

/*
	Name: sort_greatest
	Namespace: dev_class
	Checksum: 0x7D635622
	Offset: 0x2200
	Size: 0xCE
	Parameters: 3
	Flags: Linked
*/
function sort_greatest(func, attribute, greatest)
{
	/#
		keys = getarraykeys(level.cac_functions[func]);
		greatest = keys[0];
		for(i = 0; i < keys.size; i++)
		{
			if(level.cac_attributes[attribute][keys[i]] > level.cac_attributes[attribute][greatest])
			{
				greatest = keys[i];
			}
		}
		return greatest;
	#/
}

/*
	Name: sort_least
	Namespace: dev_class
	Checksum: 0xDCA35CC6
	Offset: 0x22D8
	Size: 0xCE
	Parameters: 3
	Flags: Linked
*/
function sort_least(func, attribute, least)
{
	/#
		keys = getarraykeys(level.cac_functions[func]);
		least = keys[0];
		for(i = 0; i < keys.size; i++)
		{
			if(level.cac_attributes[attribute][keys[i]] < level.cac_attributes[attribute][least])
			{
				least = keys[i];
			}
		}
		return least;
	#/
}

/*
	Name: dev_cac_set_model_range
	Namespace: dev_class
	Checksum: 0xCFD29B40
	Offset: 0x23B0
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function dev_cac_set_model_range(sort_function, attribute)
{
	/#
		if(!dev_cac_player_valid())
		{
			return;
		}
		player = level.dev_cac_player;
		player.cac_body_type = [[sort_function]]("", attribute);
		player.cac_head_type = [[sort_function]]("", attribute);
		player.cac_hat_type = [[sort_function]]("", attribute);
		player dev_cac_set_player_model();
	#/
}

