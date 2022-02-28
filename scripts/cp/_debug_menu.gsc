// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace debug_menu;

/*
	Name: add_menu
	Namespace: debug_menu
	Checksum: 0x4DA4D193
	Offset: 0x70
	Size: 0xB8
	Parameters: 2
	Flags: Linked
*/
function add_menu(menu_name, title)
{
	/#
		if(isdefined(level.menu_sys[menu_name]))
		{
			println(("" + menu_name) + "");
			return;
		}
		level.menu_sys[menu_name] = spawnstruct();
		level.menu_sys[menu_name].title = "";
		level.menu_sys[menu_name].title = title;
	#/
}

/*
	Name: add_menuoptions
	Namespace: debug_menu
	Checksum: 0x9C1B5CFB
	Offset: 0x130
	Size: 0x132
	Parameters: 4
	Flags: None
*/
function add_menuoptions(menu_name, option_text, func, key)
{
	/#
		if(!isdefined(level.menu_sys[menu_name].options))
		{
			level.menu_sys[menu_name].options = [];
		}
		num = level.menu_sys[menu_name].options.size;
		level.menu_sys[menu_name].options[num] = option_text;
		level.menu_sys[menu_name].func[num] = func;
		if(isdefined(key))
		{
			if(!isdefined(level.menu_sys[menu_name].func_key))
			{
				level.menu_sys[menu_name].func_key = [];
			}
			level.menu_sys[menu_name].func_key[num] = key;
		}
	#/
}

/*
	Name: add_menu_child
	Namespace: debug_menu
	Checksum: 0xAB49B5D0
	Offset: 0x270
	Size: 0x176
	Parameters: 5
	Flags: None
*/
function add_menu_child(parent_menu, child_menu, child_title, child_number_override, func)
{
	/#
		if(!isdefined(level.menu_sys[child_menu]))
		{
			add_menu(child_menu, child_title);
		}
		level.menu_sys[child_menu].parent_menu = parent_menu;
		if(!isdefined(level.menu_sys[parent_menu].children_menu))
		{
			level.menu_sys[parent_menu].children_menu = [];
		}
		if(!isdefined(child_number_override))
		{
			size = level.menu_sys[parent_menu].children_menu.size;
		}
		else
		{
			size = child_number_override;
		}
		level.menu_sys[parent_menu].children_menu[size] = child_menu;
		if(isdefined(func))
		{
			if(!isdefined(level.menu_sys[parent_menu].children_func))
			{
				level.menu_sys[parent_menu].children_func = [];
			}
			level.menu_sys[parent_menu].children_func[size] = func;
		}
	#/
}

/*
	Name: set_no_back_menu
	Namespace: debug_menu
	Checksum: 0xA8AEB386
	Offset: 0x3F0
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function set_no_back_menu(menu_name)
{
	/#
		level.menu_sys[menu_name].no_back = 1;
	#/
}

/*
	Name: enable_menu
	Namespace: debug_menu
	Checksum: 0xDC9FD09D
	Offset: 0x428
	Size: 0x276
	Parameters: 1
	Flags: Linked
*/
function enable_menu(menu_name)
{
	/#
		disable_menu("");
		if(isdefined(level.menu_cursor))
		{
			level.menu_cursor.y = 130;
			level.menu_cursor.current_pos = 0;
		}
		level.menu_sys[""].title = set_menu_hudelem(level.menu_sys[menu_name].title, "");
		level.menu_sys[""].menu_name = menu_name;
		back_option_num = 0;
		if(isdefined(level.menu_sys[menu_name].options))
		{
			options = level.menu_sys[menu_name].options;
			for(i = 0; i < options.size; i++)
			{
				text = ((i + 1) + "") + options[i];
				level.menu_sys[""].options[i] = set_menu_hudelem(text, "", 20 * i);
				back_option_num = i;
			}
		}
		if(isdefined(level.menu_sys[menu_name].parent_menu) && !isdefined(level.menu_sys[menu_name].no_back))
		{
			back_option_num++;
			text = ((back_option_num + 1) + "") + "";
			level.menu_sys[""].options[back_option_num] = set_menu_hudelem(text, "", 20 * back_option_num);
		}
	#/
}

/*
	Name: disable_menu
	Namespace: debug_menu
	Checksum: 0xB94BF3F
	Offset: 0x6A8
	Size: 0x128
	Parameters: 1
	Flags: Linked
*/
function disable_menu(menu_name)
{
	/#
		if(isdefined(level.menu_sys[menu_name]))
		{
			if(isdefined(level.menu_sys[menu_name].title))
			{
				level.menu_sys[menu_name].title destroy();
			}
			if(isdefined(level.menu_sys[menu_name].options))
			{
				options = level.menu_sys[menu_name].options;
				for(i = 0; i < options.size; i++)
				{
					options[i] destroy();
				}
			}
		}
		level.menu_sys[menu_name].title = undefined;
		level.menu_sys[menu_name].options = [];
	#/
}

/*
	Name: set_menu_hudelem
	Namespace: debug_menu
	Checksum: 0x8AB091B4
	Offset: 0x7D8
	Size: 0xCA
	Parameters: 3
	Flags: Linked
*/
function set_menu_hudelem(text, type, y_offset)
{
	/#
		y = 100;
		if(isdefined(type) && type == "")
		{
			scale = 2;
		}
		else
		{
			scale = 1.3;
			y = y + 30;
		}
		if(!isdefined(y_offset))
		{
			y_offset = 0;
		}
		y = y + y_offset;
		return set_hudelem(text, 10, y, scale);
	#/
}

/*
	Name: set_hudelem
	Namespace: debug_menu
	Checksum: 0xEC09D14
	Offset: 0x8B0
	Size: 0x1D0
	Parameters: 7
	Flags: Linked
*/
function set_hudelem(text, x, y, scale, alpha, sort, debug_hudelem)
{
	/#
		if(!isdefined(alpha))
		{
			alpha = 1;
		}
		if(!isdefined(scale))
		{
			scale = 1;
		}
		if(!isdefined(sort))
		{
			sort = 20;
		}
		if(isdefined(level.player) && !isdefined(debug_hudelem))
		{
			hud = newclienthudelem(level.player);
		}
		else
		{
			hud = newdebughudelem();
			hud.debug_hudelem = 1;
		}
		hud.location = 0;
		hud.alignx = "";
		hud.aligny = "";
		hud.foreground = 1;
		hud.fontscale = scale;
		hud.sort = sort;
		hud.alpha = alpha;
		hud.x = x;
		hud.y = y;
		hud.og_scale = scale;
		if(isdefined(text))
		{
			hud settext(text);
		}
		return hud;
	#/
}

/*
	Name: menu_input
	Namespace: debug_menu
	Checksum: 0x19B1B57A
	Offset: 0xA90
	Size: 0x820
	Parameters: 0
	Flags: None
*/
function menu_input()
{
	/#
		while(true)
		{
			level waittill(#"menu_button_pressed", keystring);
			menu_name = level.menu_sys[""].menu_name;
			if(keystring == "" || keystring == "")
			{
				if(level.menu_cursor.current_pos > 0)
				{
					level.menu_cursor.y = level.menu_cursor.y - 20;
					level.menu_cursor.current_pos--;
				}
				else if(level.menu_cursor.current_pos == 0)
				{
					level.menu_cursor.y = level.menu_cursor.y + ((level.menu_sys[""].options.size - 1) * 20);
					level.menu_cursor.current_pos = level.menu_sys[""].options.size - 1;
				}
				wait(0.1);
				continue;
			}
			else
			{
				if(keystring == "" || keystring == "")
				{
					if(level.menu_cursor.current_pos < (level.menu_sys[""].options.size - 1))
					{
						level.menu_cursor.y = level.menu_cursor.y + 20;
						level.menu_cursor.current_pos++;
					}
					else if(level.menu_cursor.current_pos == (level.menu_sys[""].options.size - 1))
					{
						level.menu_cursor.y = level.menu_cursor.y + (level.menu_cursor.current_pos * -20);
						level.menu_cursor.current_pos = 0;
					}
					wait(0.1);
					continue;
				}
				else
				{
					if(keystring == "" || keystring == "")
					{
						key = level.menu_cursor.current_pos;
					}
					else
					{
						key = int(keystring) - 1;
					}
				}
			}
			if(key > level.menu_sys[menu_name].options.size)
			{
				continue;
			}
			else
			{
				if(isdefined(level.menu_sys[menu_name].parent_menu) && key == level.menu_sys[menu_name].options.size)
				{
					level notify("" + menu_name);
					level enable_menu(level.menu_sys[menu_name].parent_menu);
				}
				else if(isdefined(level.menu_sys[menu_name].func) && isdefined(level.menu_sys[menu_name].func[key]))
				{
					level.menu_sys[""].options[key] thread hud_selector(level.menu_sys[""].options[key].x, level.menu_sys[""].options[key].y);
					if(isdefined(level.menu_sys[menu_name].func_key) && isdefined(level.menu_sys[menu_name].func_key[key]) && level.menu_sys[menu_name].func_key[key] == keystring)
					{
						error_msg = level [[level.menu_sys[menu_name].func[key]]]();
					}
					else
					{
						error_msg = level [[level.menu_sys[menu_name].func[key]]]();
					}
					level thread hud_selector_fade_out();
					if(isdefined(error_msg))
					{
						level thread selection_error(error_msg, level.menu_sys[""].options[key].x, level.menu_sys[""].options[key].y);
					}
				}
			}
			if(!isdefined(level.menu_sys[menu_name].children_menu))
			{
				println(("" + menu_name) + "");
				continue;
			}
			else
			{
				if(!isdefined(level.menu_sys[menu_name].children_menu[key]))
				{
					println(((("" + menu_name) + "") + key) + "");
					continue;
				}
				else if(!isdefined(level.menu_sys[level.menu_sys[menu_name].children_menu[key]]))
				{
					println(("" + level.menu_sys[menu_name].options[key]) + "");
					continue;
				}
			}
			if(isdefined(level.menu_sys[menu_name].children_func) && isdefined(level.menu_sys[menu_name].children_func[key]))
			{
				func = level.menu_sys[menu_name].children_func[key];
				error_msg = [[func]]();
				if(isdefined(error_msg))
				{
					level thread selection_error(error_msg, level.menu_sys[""].options[key].x, level.menu_sys[""].options[key].y);
					continue;
				}
			}
			level enable_menu(level.menu_sys[menu_name].children_menu[key]);
			wait(0.1);
		}
	#/
}

/*
	Name: force_menu_back
	Namespace: debug_menu
	Checksum: 0x6A25ED7
	Offset: 0x12B8
	Size: 0x1AE
	Parameters: 1
	Flags: None
*/
function force_menu_back(waittill_msg)
{
	/#
		if(isdefined(waittill_msg))
		{
			level waittill(waittill_msg);
		}
		wait(0.1);
		menu_name = level.menu_sys[""].menu_name;
		key = level.menu_sys[menu_name].options.size;
		key++;
		if(key == 1)
		{
			key = "";
		}
		else
		{
			if(key == 2)
			{
				key = "";
			}
			else
			{
				if(key == 3)
				{
					key = "";
				}
				else
				{
					if(key == 4)
					{
						key = "";
					}
					else
					{
						if(key == 5)
						{
							key = "";
						}
						else
						{
							if(key == 6)
							{
								key = "";
							}
							else
							{
								if(key == 7)
								{
									key = "";
								}
								else
								{
									if(key == 8)
									{
										key = "";
									}
									else if(key == 9)
									{
										key = "";
									}
								}
							}
						}
					}
				}
			}
		}
		level notify(#"menu_button_pressed", key);
	#/
}

/*
	Name: list_menu
	Namespace: debug_menu
	Checksum: 0xA83F6979
	Offset: 0x1470
	Size: 0x46C
	Parameters: 7
	Flags: None
*/
function list_menu(list, x, y, scale, func, sort, start_num)
{
	/#
		if(!isdefined(list) || list.size == 0)
		{
			return -1;
		}
		hud_array = [];
		for(i = 0; i < 5; i++)
		{
			if(i == 0)
			{
				alpha = 0.3;
			}
			else
			{
				if(i == 1)
				{
					alpha = 0.6;
				}
				else
				{
					if(i == 2)
					{
						alpha = 1;
					}
					else
					{
						if(i == 3)
						{
							alpha = 0.6;
						}
						else
						{
							alpha = 0.3;
						}
					}
				}
			}
			hud = set_hudelem(list[i], x, y + ((i - 2) * 15), scale, alpha, sort);
			if(!isdefined(hud_array))
			{
				hud_array = [];
			}
			else if(!isarray(hud_array))
			{
				hud_array = array(hud_array);
			}
			hud_array[hud_array.size] = hud;
		}
		if(isdefined(start_num))
		{
			new_move_list_menu(hud_array, list, start_num);
		}
		current_num = 0;
		old_num = 0;
		selected = 0;
		level.menu_list_selected = 0;
		if(isdefined(func))
		{
			[[func]](list[current_num]);
		}
		while(true)
		{
			level waittill(#"menu_button_pressed", key);
			level.menu_list_selected = 1;
			if(any_button_hit(key, ""))
			{
				break;
			}
			else
			{
				if(key == "" || key == "")
				{
					if(current_num >= (list.size - 1))
					{
						continue;
					}
					current_num++;
					new_move_list_menu(hud_array, list, current_num);
				}
				else
				{
					if(key == "" || key == "")
					{
						if(current_num <= 0)
						{
							continue;
						}
						current_num--;
						new_move_list_menu(hud_array, list, current_num);
					}
					else
					{
						if(key == "" || key == "")
						{
							selected = 1;
							break;
						}
						else if(key == "" || key == "")
						{
							selected = 0;
							break;
						}
					}
				}
			}
			level notify(#"scroll_list");
			if(current_num != old_num)
			{
				old_num = current_num;
				if(isdefined(func))
				{
					[[func]](list[current_num]);
				}
			}
			wait(0.1);
		}
		for(i = 0; i < hud_array.size; i++)
		{
			hud_array[i] destroy();
		}
		if(selected)
		{
			return current_num;
		}
	#/
}

/*
	Name: new_move_list_menu
	Namespace: debug_menu
	Checksum: 0xC724FF64
	Offset: 0x18E8
	Size: 0xBE
	Parameters: 3
	Flags: Linked
*/
function new_move_list_menu(hud_array, list, num)
{
	/#
		for(i = 0; i < hud_array.size; i++)
		{
			if(isdefined(list[i + (num - 2)]))
			{
				text = list[i + (num - 2)];
			}
			else
			{
				text = "";
			}
			hud_array[i] settext(text);
		}
	#/
}

/*
	Name: move_list_menu
	Namespace: debug_menu
	Checksum: 0x6B6DA306
	Offset: 0x19B0
	Size: 0x27E
	Parameters: 6
	Flags: None
*/
function move_list_menu(hud_array, dir, space, num, min_alpha, num_of_fades)
{
	/#
		if(!isdefined(min_alpha))
		{
			min_alpha = 0;
		}
		if(!isdefined(num_of_fades))
		{
			num_of_fades = 3;
		}
		side_movement = 0;
		if(dir == "")
		{
			side_movement = 1;
			movement = space;
		}
		else
		{
			if(dir == "")
			{
				side_movement = 1;
				movement = space * -1;
			}
			else
			{
				if(dir == "")
				{
					movement = space;
				}
				else
				{
					movement = space * -1;
				}
			}
		}
		for(i = 0; i < hud_array.size; i++)
		{
			hud_array[i] moveovertime(0.1);
			if(side_movement)
			{
				hud_array[i].x = hud_array[i].x + movement;
			}
			else
			{
				hud_array[i].y = hud_array[i].y + movement;
			}
			temp = i - num;
			if(temp < 0)
			{
				temp = temp * -1;
			}
			alpha = 1 / (temp + 1);
			if(alpha < (1 / num_of_fades))
			{
				alpha = min_alpha;
			}
			if(!isdefined(hud_array[i].debug_hudelem))
			{
				hud_array[i] fadeovertime(0.1);
			}
			hud_array[i].alpha = alpha;
		}
	#/
}

/*
	Name: hud_selector
	Namespace: debug_menu
	Checksum: 0xC8E901A6
	Offset: 0x1C38
	Size: 0xF0
	Parameters: 2
	Flags: Linked
*/
function hud_selector(x, y)
{
	/#
		if(isdefined(level.hud_selector))
		{
			level thread hud_selector_fade_out();
		}
		level.menu_cursor.alpha = 0;
		level.hud_selector = set_hudelem(undefined, x - 10, y, 1);
		level.hud_selector setshader("", 125, 20);
		level.hud_selector.color = (1, 1, 0.5);
		level.hud_selector.alpha = 0.5;
		level.hud_selector.sort = 10;
	#/
}

/*
	Name: hud_selector_fade_out
	Namespace: debug_menu
	Checksum: 0xE3862B1A
	Offset: 0x1D30
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function hud_selector_fade_out(time)
{
	/#
		if(!isdefined(time))
		{
			time = 0.25;
		}
		level.menu_cursor.alpha = 0.5;
		hud = level.hud_selector;
		level.hud_selector = undefined;
		if(!isdefined(hud.debug_hudelem))
		{
			hud fadeovertime(time);
		}
		hud.alpha = 0;
		wait(time + 0.1);
		hud destroy();
	#/
}

/*
	Name: selection_error
	Namespace: debug_menu
	Checksum: 0x45385F29
	Offset: 0x1E00
	Size: 0x1A4
	Parameters: 3
	Flags: Linked
*/
function selection_error(msg, x, y)
{
	/#
		hud = set_hudelem(undefined, x - 10, y, 1);
		hud setshader("", 125, 20);
		hud.color = vectorscale((1, 0, 0), 0.5);
		hud.alpha = 0.7;
		error_hud = set_hudelem(msg, x + 125, y, 1);
		error_hud.color = (1, 0, 0);
		if(!isdefined(hud.debug_hudelem))
		{
			hud fadeovertime(3);
		}
		hud.alpha = 0;
		if(!isdefined(error_hud.debug_hudelem))
		{
			error_hud fadeovertime(3);
		}
		error_hud.alpha = 0;
		wait(3.1);
		hud destroy();
		error_hud destroy();
	#/
}

/*
	Name: hud_font_scaler
	Namespace: debug_menu
	Checksum: 0xCEED86E0
	Offset: 0x1FB0
	Size: 0xFA
	Parameters: 1
	Flags: None
*/
function hud_font_scaler(mult)
{
	/#
		self notify(#"stop_fontscaler");
		self endon(#"death");
		self endon(#"stop_fontscaler");
		og_scale = self.og_scale;
		if(!isdefined(mult))
		{
			mult = 1.5;
		}
		self.fontscale = og_scale * mult;
		dif = og_scale - self.fontscale;
		dif = dif / (1 * 20);
		for(i = 0; i < (1 * 20); i++)
		{
			self.fontscale = self.fontscale + dif;
			wait(0.05);
		}
	#/
}

/*
	Name: menu_cursor
	Namespace: debug_menu
	Checksum: 0x7296D8F
	Offset: 0x20B8
	Size: 0xBC
	Parameters: 0
	Flags: None
*/
function menu_cursor()
{
	/#
		level.menu_cursor = set_hudelem(undefined, 0, 130, 1.3);
		level.menu_cursor setshader("", 125, 20);
		level.menu_cursor.color = (1, 0.5, 0);
		level.menu_cursor.alpha = 0.5;
		level.menu_cursor.sort = 1;
		level.menu_cursor.current_pos = 0;
	#/
}

/*
	Name: new_hud
	Namespace: debug_menu
	Checksum: 0xE43FBAEA
	Offset: 0x2180
	Size: 0xC0
	Parameters: 5
	Flags: Linked
*/
function new_hud(hud_name, msg, x, y, scale)
{
	/#
		if(!isdefined(level.hud_array))
		{
			level.hud_array = [];
		}
		if(!isdefined(level.hud_array[hud_name]))
		{
			level.hud_array[hud_name] = [];
		}
		hud = set_hudelem(msg, x, y, scale);
		level.hud_array[hud_name][level.hud_array[hud_name].size] = hud;
		return hud;
	#/
}

/*
	Name: remove_hud
	Namespace: debug_menu
	Checksum: 0xDB331F61
	Offset: 0x2250
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function remove_hud(hud_name)
{
	/#
		if(!isdefined(level.hud_array[hud_name]))
		{
			return;
		}
		huds = level.hud_array[hud_name];
		for(i = 0; i < huds.size; i++)
		{
			destroy_hud(huds[i]);
		}
		level.hud_array[hud_name] = undefined;
	#/
}

/*
	Name: destroy_hud
	Namespace: debug_menu
	Checksum: 0x9F867DCA
	Offset: 0x22F0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function destroy_hud(hud)
{
	/#
		if(isdefined(hud))
		{
			hud destroy();
		}
	#/
}

/*
	Name: set_menus_pos_by_num
	Namespace: debug_menu
	Checksum: 0x729D6A77
	Offset: 0x2330
	Size: 0x142
	Parameters: 7
	Flags: None
*/
function set_menus_pos_by_num(hud_array, num, x, y, space, min_alpha, num_of_fades)
{
	/#
		if(!isdefined(min_alpha))
		{
			min_alpha = 0.1;
		}
		if(!isdefined(num_of_fades))
		{
			num_of_fades = 3;
		}
		for(i = 0; i < hud_array.size; i++)
		{
			temp = i - num;
			hud_array[i].y = y + (temp * space);
			if(temp < 0)
			{
				temp = temp * -1;
			}
			alpha = 1 / (temp + 1);
			if(alpha < (1 / num_of_fades))
			{
				alpha = min_alpha;
			}
			hud_array[i].alpha = alpha;
		}
	#/
}

/*
	Name: popup_box
	Namespace: debug_menu
	Checksum: 0x57CD8107
	Offset: 0x2480
	Size: 0x35E
	Parameters: 7
	Flags: None
*/
function popup_box(x, y, width, height, time, color, alpha)
{
	/#
		if(!isdefined(alpha))
		{
			alpha = 0.5;
		}
		if(!isdefined(color))
		{
			color = vectorscale((0, 0, 1), 0.5);
		}
		if(isdefined(level.player))
		{
			hud = newclienthudelem(level.player);
		}
		else
		{
			hud = newdebughudelem();
			hud.debug_hudelem = 1;
		}
		hud.alignx = "";
		hud.aligny = "";
		hud.foreground = 1;
		hud.sort = 30;
		hud.x = x;
		hud.y = y;
		hud.alpha = alpha;
		hud.color = color;
		if(isdefined(level.player))
		{
			hud.background = newclienthudelem(level.player);
		}
		else
		{
			hud.background = newdebughudelem();
			hud.debug_hudelem = 1;
		}
		hud.background.alignx = "";
		hud.background.aligny = "";
		hud.background.foreground = 1;
		hud.background.sort = 25;
		hud.background.x = x + 2;
		hud.background.y = y + 2;
		hud.background.alpha = 0.75;
		hud.background.color = (0, 0, 0);
		hud setshader("", 0, 0);
		hud scaleovertime(time, width, height);
		hud.background setshader("", 0, 0);
		hud.background scaleovertime(time, width, height);
		wait(time);
		return hud;
	#/
}

/*
	Name: destroy_popup
	Namespace: debug_menu
	Checksum: 0x74C070B4
	Offset: 0x27E8
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function destroy_popup()
{
	/#
		self.background scaleovertime(0.25, 0, 0);
		self scaleovertime(0.25, 0, 0);
		wait(0.1);
		if(isdefined(self.background))
		{
			self.background destroy();
		}
		if(isdefined(self))
		{
			self destroy();
		}
	#/
}

/*
	Name: dialog_text_box
	Namespace: debug_menu
	Checksum: 0xD25C54B0
	Offset: 0x2890
	Size: 0x4E0
	Parameters: 3
	Flags: None
*/
function dialog_text_box(dialog_msg, dialog_msg2, word_length)
{
	/#
		y = 100;
		hud = new_hud("", undefined, 320 - (300 * 0.5), y, 1);
		hud setshader("", 300, 100);
		hud.aligny = "";
		hud.color = vectorscale((0, 0, 1), 0.2);
		hud.alpha = 0.85;
		hud.sort = 20;
		hud = new_hud("", dialog_msg, (320 - (300 * 0.5)) + 10, y + 10, 1.25);
		hud.sort = 25;
		if(isdefined(dialog_msg2))
		{
			hud = new_hud("", dialog_msg2, (320 - (300 * 0.5)) + 10, y + 30, 1.1);
			hud.sort = 25;
		}
		bg2_shader_width = 300 - 20;
		y = 150;
		hud = new_hud("", undefined, 320 - (bg2_shader_width * 0.5), y, 1);
		hud setshader("", bg2_shader_width, 20);
		hud.aligny = "";
		hud.color = (0, 0, 0);
		hud.alpha = 0.85;
		hud.sort = 30;
		cursor_x = (320 - (bg2_shader_width * 0.5)) + 2;
		cursor_y = y + 8;
		if(level.xenon)
		{
			hud = new_hud("", "", 320 - 50, y + 30, 1.25);
			hud.alignx = "";
			hud.sort = 25;
			hud = new_hud("", "", 320 + 50, y + 30, 1.25);
			hud.alignx = "";
			hud.sort = 25;
		}
		else
		{
			hud = new_hud("", "", 320 - 50, y + 30, 1.25);
			hud.alignx = "";
			hud.sort = 25;
			hud = new_hud("", "", 320 + 50, y + 30, 1.25);
			hud.alignx = "";
			hud.sort = 25;
		}
		result = dialog_text_box_input(cursor_x, cursor_y, word_length);
		remove_hud("");
		return result;
	#/
}

/*
	Name: dialog_text_box_input
	Namespace: debug_menu
	Checksum: 0x60843BD4
	Offset: 0x2D80
	Size: 0x2EA
	Parameters: 3
	Flags: Linked
*/
function dialog_text_box_input(cursor_x, cursor_y, word_length)
{
	/#
		level.dialog_box_cursor = new_hud("", "", cursor_x, cursor_y, 1.25);
		level.dialog_box_cursor.sort = 75;
		level thread dialog_text_box_cursor();
		dialog_text_box_buttons();
		hud_word = new_hud("", "", cursor_x, cursor_y, 1.25);
		hud_word.sort = 75;
		hud_letters = [];
		word = "";
		while(true)
		{
			level waittill(#"dialog_box_button_pressed", button);
			if(button == "" || button == "")
			{
				word = "";
				break;
			}
			else
			{
				if(button == "" || button == "" || button == "")
				{
					break;
				}
				else
				{
					if(button == "" || button == "")
					{
						new_word = "";
						for(i = 0; i < (word.size - 1); i++)
						{
							new_word = new_word + word[i];
						}
						word = new_word;
					}
					else if(word.size < word_length)
					{
						word = word + button;
					}
				}
			}
			hud_word settext(word);
			x = cursor_x;
			for(i = 0; i < word.size; i++)
			{
				x = x + get_letter_space(word[i]);
			}
			level.dialog_box_cursor.x = x;
			wait(0.05);
		}
		level notify(#"stop_dialog_text_box_cursor");
		level notify(#"stop_dialog_text_input");
		return word;
	#/
}

/*
	Name: dialog_text_box_buttons
	Namespace: debug_menu
	Checksum: 0xF5A974D8
	Offset: 0x3078
	Size: 0x5D4
	Parameters: 0
	Flags: Linked
*/
function dialog_text_box_buttons()
{
	/#
		clear_universal_buttons("");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		add_universal_button("", "");
		if(level.xenon)
		{
			add_universal_button("", "");
			add_universal_button("", "");
		}
		level thread universal_input_loop("", "", undefined, undefined);
	#/
}

/*
	Name: dialog_text_box_cursor
	Namespace: debug_menu
	Checksum: 0x8BDCA92C
	Offset: 0x3658
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function dialog_text_box_cursor()
{
	/#
		level endon(#"stop_dialog_text_box_cursor");
		while(true)
		{
			level.dialog_box_cursor.alpha = 0;
			wait(0.5);
			level.dialog_box_cursor.alpha = 1;
			wait(0.5);
		}
	#/
}

/*
	Name: get_letter_space
	Namespace: debug_menu
	Checksum: 0x3D9A7869
	Offset: 0x36B8
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function get_letter_space(letter)
{
	/#
		if(letter == "" || letter == "" || letter == "")
		{
			space = 10;
		}
		else
		{
			if(letter == "" || letter == "" || letter == "" || letter == "" || letter == "" || letter == "")
			{
				space = 7;
			}
			else
			{
				if(letter == "" || letter == "" || letter == "")
				{
					space = 5;
				}
				else
				{
					if(letter == "" || letter == "")
					{
						space = 4;
					}
					else
					{
						if(letter == "")
						{
							space = 3;
						}
						else
						{
							space = 6;
						}
					}
				}
			}
		}
		return space;
	#/
}

/*
	Name: add_universal_button
	Namespace: debug_menu
	Checksum: 0xA0346B7C
	Offset: 0x3828
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function add_universal_button(button_group, name)
{
	/#
		if(!isdefined(level.u_buttons[button_group]))
		{
			level.u_buttons[button_group] = [];
		}
		if(!isinarray(level.u_buttons[button_group], name))
		{
			level.u_buttons[button_group][level.u_buttons[button_group].size] = name;
		}
	#/
}

/*
	Name: clear_universal_buttons
	Namespace: debug_menu
	Checksum: 0xC9C28309
	Offset: 0x38B8
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function clear_universal_buttons(button_group)
{
	/#
		level.u_buttons[button_group] = [];
	#/
}

/*
	Name: universal_input_loop
	Namespace: debug_menu
	Checksum: 0x22EC86C5
	Offset: 0x38E8
	Size: 0x1E0
	Parameters: 5
	Flags: Linked
*/
function universal_input_loop(button_group, end_on, use_attackbutton, mod_button, no_mod_button)
{
	/#
		level endon(end_on);
		if(!isdefined(use_attackbutton))
		{
			use_attackbutton = 0;
		}
		notify_name = button_group + "";
		buttons = level.u_buttons[button_group];
		level.u_buttons_disable[button_group] = 0;
		while(true)
		{
			if(level.u_buttons_disable[button_group])
			{
				wait(0.05);
				continue;
			}
			if(isdefined(mod_button) && !level.player buttonpressed(mod_button))
			{
				wait(0.05);
				continue;
			}
			else if(isdefined(no_mod_button) && level.player buttonpressed(no_mod_button))
			{
				wait(0.05);
				continue;
			}
			if(use_attackbutton && level.player attackbuttonpressed())
			{
				level notify(notify_name, "");
				wait(0.1);
				continue;
			}
			for(i = 0; i < buttons.size; i++)
			{
				if(level.player buttonpressed(buttons[i]))
				{
					level notify(notify_name, buttons[i]);
					wait(0.1);
					break;
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: disable_buttons
	Namespace: debug_menu
	Checksum: 0x4EC99FC1
	Offset: 0x3AD0
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function disable_buttons(button_group)
{
	/#
		level.u_buttons_disable[button_group] = 1;
	#/
}

/*
	Name: enable_buttons
	Namespace: debug_menu
	Checksum: 0xD9C67699
	Offset: 0x3B00
	Size: 0x26
	Parameters: 1
	Flags: None
*/
function enable_buttons(button_group)
{
	/#
		wait(1);
		level.u_buttons_disable[button_group] = 0;
	#/
}

/*
	Name: any_button_hit
	Namespace: debug_menu
	Checksum: 0x11D4C4C4
	Offset: 0x3B30
	Size: 0x152
	Parameters: 2
	Flags: Linked
*/
function any_button_hit(button_hit, type)
{
	/#
		buttons = [];
		if(type == "")
		{
			buttons[0] = "";
			buttons[1] = "";
			buttons[2] = "";
			buttons[3] = "";
			buttons[4] = "";
			buttons[5] = "";
			buttons[6] = "";
			buttons[7] = "";
			buttons[8] = "";
			buttons[9] = "";
		}
		else
		{
			buttons = level.buttons;
		}
		for(i = 0; i < buttons.size; i++)
		{
			if(button_hit == buttons[i])
			{
				return true;
			}
		}
		return false;
	#/
}

