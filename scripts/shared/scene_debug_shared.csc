// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scriptbundle_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace scene;

/*
	Name: __init__sytem__
	Namespace: scene
	Checksum: 0x190B6660
	Offset: 0x180
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("", &__init__, undefined, undefined);
	#/
}

/*
	Name: __init__
	Namespace: scene
	Checksum: 0x8F374282
	Offset: 0x1C0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		if(getdvarstring("", "") == "")
		{
			setdvar("", "");
		}
		level thread run_scene_tests();
		level thread toggle_scene_menu();
		level thread function_f69ab75e();
	#/
}

/*
	Name: function_f69ab75e
	Namespace: scene
	Checksum: 0xA6AB3BD5
	Offset: 0x270
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function function_f69ab75e()
{
	/#
		while(true)
		{
			level flagsys::wait_till("");
			foreach(var_4d881e03 in function_c4a37ed9())
			{
				var_4d881e03 thread debug_display();
			}
			level flagsys::wait_till_clear("");
		}
	#/
}

/*
	Name: function_c4a37ed9
	Namespace: scene
	Checksum: 0x8A28E2C5
	Offset: 0x350
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function function_c4a37ed9()
{
	/#
		a_scenes = arraycombine(struct::get_array("", ""), struct::get_array("", ""), 0, 0);
		foreach(a_active_scenes in level.active_scenes)
		{
			a_scenes = arraycombine(a_scenes, a_active_scenes, 0, 0);
		}
		return a_scenes;
	#/
}

/*
	Name: run_scene_tests
	Namespace: scene
	Checksum: 0x712831C9
	Offset: 0x460
	Size: 0x4A0
	Parameters: 0
	Flags: Linked
*/
function run_scene_tests()
{
	/#
		level endon(#"run_scene_tests");
		level.scene_test_struct = spawnstruct();
		level.scene_test_struct.origin = (0, 0, 0);
		level.scene_test_struct.angles = (0, 0, 0);
		while(true)
		{
			str_scene = getdvarstring("");
			str_mode = tolower(getdvarstring("", ""));
			if(str_scene != "")
			{
				setdvar("", "");
				clear_old_ents(str_scene);
				b_found = 0;
				a_scenes = struct::get_array(str_scene, "");
				foreach(s_instance in a_scenes)
				{
					if(isdefined(s_instance))
					{
						b_found = 1;
						s_instance thread test_play(undefined, str_mode);
					}
				}
				if(isdefined(level.active_scenes[str_scene]))
				{
					foreach(s_instance in level.active_scenes[str_scene])
					{
						if(!isinarray(a_scenes, s_instance))
						{
							b_found = 1;
							s_instance thread test_play(str_scene, str_mode);
						}
					}
				}
				if(!b_found)
				{
					level.scene_test_struct thread test_play(str_scene, str_mode);
				}
			}
			str_scene = getdvarstring("");
			if(str_scene != "")
			{
				setdvar("", "");
				clear_old_ents(str_scene);
				b_found = 0;
				a_scenes = struct::get_array(str_scene, "");
				foreach(s_instance in a_scenes)
				{
					if(isdefined(s_instance))
					{
						b_found = 1;
						s_instance thread test_init();
					}
				}
				if(!b_found)
				{
					level.scene_test_struct thread test_init(str_scene);
				}
			}
			str_scene = getdvarstring("");
			if(str_scene != "")
			{
				setdvar("", "");
				level stop(str_scene, 1);
			}
			wait(0.016);
		}
	#/
}

/*
	Name: clear_old_ents
	Namespace: scene
	Checksum: 0xF9D73B94
	Offset: 0x908
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function clear_old_ents(str_scene)
{
	/#
		foreach(ent in getentarray(0))
		{
			if(ent.scene_spawned === str_scene && ent.finished_scene === str_scene)
			{
				ent delete();
			}
		}
	#/
}

/*
	Name: toggle_scene_menu
	Namespace: scene
	Checksum: 0xA9046D1B
	Offset: 0x9E8
	Size: 0x158
	Parameters: 0
	Flags: Linked
*/
function toggle_scene_menu()
{
	/#
		setdvar("", 0);
		n_scene_menu_last = -1;
		while(true)
		{
			n_scene_menu = getdvarstring("");
			if(n_scene_menu != "")
			{
				n_scene_menu = int(n_scene_menu);
				if(n_scene_menu != n_scene_menu_last)
				{
					switch(n_scene_menu)
					{
						case 1:
						{
							level thread display_scene_menu("");
							break;
						}
						case 2:
						{
							level thread display_scene_menu("");
							break;
						}
						default:
						{
							level flagsys::clear("");
							level notify(#"scene_menu_cleanup");
							setdvar("", 1);
						}
					}
					n_scene_menu_last = n_scene_menu;
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: create_scene_hud
	Namespace: scene
	Checksum: 0x85068A1F
	Offset: 0xB48
	Size: 0x198
	Parameters: 2
	Flags: Linked
*/
function create_scene_hud(scene_name, index)
{
	/#
		alpha = 1;
		color = vectorscale((1, 1, 1), 0.9);
		if(index != -1)
		{
			if(index != 5)
			{
				alpha = 1 - ((abs(5 - index)) / 5);
			}
		}
		if(alpha == 0)
		{
			alpha = 0.05;
		}
		hudelem = createluimenu(0, "");
		setluimenudata(0, hudelem, "", scene_name);
		setluimenudata(0, hudelem, "", 100);
		setluimenudata(0, hudelem, "", 80 + (index * 18));
		setluimenudata(0, hudelem, "", 1000);
		openluimenu(0, hudelem);
		return hudelem;
	#/
}

/*
	Name: display_scene_menu
	Namespace: scene
	Checksum: 0x95C64570
	Offset: 0xCF0
	Size: 0x730
	Parameters: 1
	Flags: Linked
*/
function display_scene_menu(str_type)
{
	/#
		if(!isdefined(str_type))
		{
			str_type = "";
		}
		level notify(#"scene_menu_cleanup");
		level endon(#"scene_menu_cleanup");
		waittillframeend();
		level flagsys::set("");
		setdvar("", 0);
		level thread display_mode();
		a_scenedefs = get_scenedefs(str_type);
		if(str_type == "")
		{
			a_scenedefs = arraycombine(a_scenedefs, get_scenedefs(""), 0, 1);
		}
		names = [];
		foreach(s_scenedef in a_scenedefs)
		{
			array::add_sorted(names, s_scenedef.name, 0);
		}
		names[names.size] = "";
		elems = scene_list_menu();
		title = create_scene_hud(str_type + "", -1);
		selected = 0;
		up_pressed = 0;
		down_pressed = 0;
		held = 0;
		scene_list_settext(elems, names, selected);
		old_selected = selected;
		level thread scene_menu_cleanup(elems, title);
		while(true)
		{
			scene_list_settext(elems, names, selected);
			if(held)
			{
				wait(0.5);
			}
			if(!up_pressed)
			{
				if(level.localplayers[0] util::up_button_pressed())
				{
					up_pressed = 1;
					selected--;
				}
			}
			else
			{
				if(level.localplayers[0] util::up_button_held())
				{
					held = 1;
					selected = selected - 10;
				}
				else if(!level.localplayers[0] util::up_button_pressed())
				{
					held = 0;
					up_pressed = 0;
				}
			}
			if(!down_pressed)
			{
				if(level.localplayers[0] util::down_button_pressed())
				{
					down_pressed = 1;
					selected++;
				}
			}
			else
			{
				if(level.localplayers[0] util::down_button_held())
				{
					held = 1;
					selected = selected + 10;
				}
				else if(!level.localplayers[0] util::down_button_pressed())
				{
					held = 0;
					down_pressed = 0;
				}
			}
			if(held)
			{
				if(selected < 0)
				{
					selected = 0;
				}
				else if(selected >= names.size)
				{
					selected = names.size - 1;
				}
			}
			else
			{
				if(selected < 0)
				{
					selected = names.size - 1;
				}
				else if(selected >= names.size)
				{
					selected = 0;
				}
			}
			if(level.localplayers[0] buttonpressed(""))
			{
				setdvar("", 0);
			}
			if(level.localplayers[0] buttonpressed("") || level.localplayers[0] buttonpressed("") || level.localplayers[0] buttonpressed(""))
			{
				if(names[selected] == "")
				{
					setdvar("", 0);
				}
				else
				{
					if(is_scene_playing(names[selected]))
					{
						setdvar("", names[selected]);
					}
					else
					{
						if(is_scene_initialized(names[selected]))
						{
							setdvar("", names[selected]);
						}
						else
						{
							if(has_init_state(names[selected]))
							{
								setdvar("", names[selected]);
							}
							else
							{
								setdvar("", names[selected]);
							}
						}
					}
				}
				while(level.localplayers[0] buttonpressed("") || level.localplayers[0] buttonpressed("") || level.localplayers[0] buttonpressed(""))
				{
					wait(0.016);
				}
			}
			wait(0.016);
		}
	#/
}

/*
	Name: display_mode
	Namespace: scene
	Checksum: 0xDDC307AA
	Offset: 0x1428
	Size: 0x234
	Parameters: 0
	Flags: Linked
*/
function display_mode()
{
	/#
		hudelem = createluimenu(0, "");
		setluimenudata(0, hudelem, "", 100);
		setluimenudata(0, hudelem, "", 490);
		setluimenudata(0, hudelem, "", 500);
		openluimenu(0, hudelem);
		while(level flagsys::get(""))
		{
			str_mode = tolower(getdvarstring("", ""));
			switch(str_mode)
			{
				case "":
				{
					setluimenudata(0, hudelem, "", "");
					break;
				}
				case "":
				{
					setluimenudata(0, hudelem, "", "");
					break;
				}
				case "":
				{
					setluimenudata(0, hudelem, "", "");
					break;
				}
				case "":
				{
					setluimenudata(0, hudelem, "", "");
					break;
				}
			}
			wait(0.05);
		}
		closeluimenu(0, hudelem);
	#/
}

/*
	Name: scene_list_menu
	Namespace: scene
	Checksum: 0x3BAE486B
	Offset: 0x1668
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function scene_list_menu()
{
	/#
		hud_array = [];
		for(i = 0; i < 22; i++)
		{
			hud = create_scene_hud("", i);
			hud_array[hud_array.size] = hud;
		}
		return hud_array;
	#/
}

/*
	Name: scene_list_settext
	Namespace: scene
	Checksum: 0xAC6C5028
	Offset: 0x16F8
	Size: 0x1EE
	Parameters: 3
	Flags: Linked
*/
function scene_list_settext(hud_array, strings, num)
{
	/#
		for(i = 0; i < hud_array.size; i++)
		{
			index = i + (num - 5);
			if(isdefined(strings[index]))
			{
				text = strings[index];
			}
			else
			{
				text = "";
			}
			if(is_scene_playing(text))
			{
				setluimenudata(0, hud_array[i], "", 1);
				text = text + "";
			}
			else
			{
				if(is_scene_initialized(text))
				{
					setluimenudata(0, hud_array[i], "", 1);
					text = text + "";
				}
				else
				{
					setluimenudata(0, hud_array[i], "", 0.5);
				}
			}
			if(i == 5)
			{
				setluimenudata(0, hud_array[i], "", 1);
				text = ("" + text) + "";
			}
			setluimenudata(0, hud_array[i], "", text);
		}
	#/
}

/*
	Name: is_scene_playing
	Namespace: scene
	Checksum: 0xEFE33B74
	Offset: 0x18F0
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function is_scene_playing(str_scene)
{
	/#
		if(str_scene != "" && str_scene != "")
		{
			if(level flagsys::get(str_scene + ""))
			{
				return true;
			}
		}
		return false;
	#/
}

/*
	Name: is_scene_initialized
	Namespace: scene
	Checksum: 0xF642CC53
	Offset: 0x1958
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function is_scene_initialized(str_scene)
{
	/#
		if(str_scene != "" && str_scene != "")
		{
			if(level flagsys::get(str_scene + ""))
			{
				return true;
			}
		}
		return false;
	#/
}

/*
	Name: scene_menu_cleanup
	Namespace: scene
	Checksum: 0x5E39B8CD
	Offset: 0x19C0
	Size: 0x86
	Parameters: 2
	Flags: Linked
*/
function scene_menu_cleanup(elems, title)
{
	/#
		level waittill(#"scene_menu_cleanup");
		closeluimenu(0, title);
		for(i = 0; i < elems.size; i++)
		{
			closeluimenu(0, elems[i]);
		}
	#/
}

/*
	Name: test_init
	Namespace: scene
	Checksum: 0x5F195845
	Offset: 0x1A50
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function test_init(arg1)
{
	/#
		init(arg1, undefined, undefined, 1);
	#/
}

/*
	Name: test_play
	Namespace: scene
	Checksum: 0xDAC5A38D
	Offset: 0x1A88
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function test_play(arg1, str_mode)
{
	/#
		play(arg1, undefined, undefined, 1, str_mode);
	#/
}

/*
	Name: debug_display
	Namespace: scene
	Checksum: 0x8D177824
	Offset: 0x1AD0
	Size: 0x2CE
	Parameters: 0
	Flags: Linked
*/
function debug_display()
{
	/#
		self endon(#"entityshutdown");
		self notify(#"hash_87671d41");
		self endon(#"hash_87671d41");
		level endon(#"kill_anim_debug");
		while(true)
		{
			debug_frames = randomintrange(5, 15);
			debug_time = debug_frames / 60;
			sphere(self.origin, 1, (0, 1, 1), 1, 1, 8, debug_frames);
			if(isdefined(self.scenes))
			{
				foreach(i, o_scene in self.scenes)
				{
					n_offset = 15 * (i + 1);
					print3d(self.origin - (0, 0, n_offset), [[ o_scene ]]->get_name(), (0.8, 0.2, 0.8), 1, 0.3, debug_frames);
					print3d(self.origin - (0, 0, n_offset + 5), ("" + (isdefined([[ o_scene ]]->get_state()) ? "" + ([[ o_scene ]]->get_state()) : "")) + "", (0.8, 0.2, 0.8), 1, 0.15, debug_frames);
				}
			}
			else
			{
				if(isdefined(self.scriptbundlename))
				{
					print3d(self.origin - vectorscale((0, 0, 1), 15), self.scriptbundlename, (0.8, 0.2, 0.8), 1, 0.3, debug_frames);
				}
				else
				{
					break;
				}
			}
			wait(debug_time);
		}
	#/
}

