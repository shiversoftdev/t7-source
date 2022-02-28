// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
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
	Checksum: 0x90CC8E04
	Offset: 0x1A8
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
	Checksum: 0x945419C1
	Offset: 0x1E8
	Size: 0x11C
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
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		level thread run_scene_tests();
		level thread toggle_scene_menu();
		level thread toggle_postfx_igc_loop();
		level thread function_f69ab75e();
	#/
}

/*
	Name: function_f69ab75e
	Namespace: scene
	Checksum: 0xF81A5076
	Offset: 0x310
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
	Checksum: 0xB19F2FFC
	Offset: 0x3F0
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
	Checksum: 0x8208F8CA
	Offset: 0x500
	Size: 0x698
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
			str_client_scene = getdvarstring("");
			str_mode = tolower(getdvarstring("", ""));
			b_capture = str_mode == "" || str_mode == "";
			if(b_capture)
			{
				if(ispc())
				{
					if(str_scene != "")
					{
						setdvar("", str_scene);
						setdvar("", "");
					}
				}
				else
				{
					setdvar("", "");
				}
			}
			else
			{
				if(str_client_scene != "")
				{
					level util::clientnotify(str_client_scene + "");
					util::wait_network_frame();
				}
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
					if(!b_found && isdefined(level.active_scenes[str_scene]))
					{
						foreach(s_instance in level.active_scenes[str_scene])
						{
							b_found = 1;
							s_instance thread test_play(str_scene, str_mode);
						}
					}
					if(!b_found)
					{
						level.scene_test_struct thread test_play(str_scene, str_mode);
					}
				}
			}
			str_scene = getdvarstring("");
			str_client_scene = getdvarstring("");
			if(str_client_scene != "")
			{
				level util::clientnotify(str_client_scene + "");
				util::wait_network_frame();
			}
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
				if(b_capture)
				{
					capture_scene(str_scene, str_mode);
				}
			}
			str_scene = getdvarstring("");
			str_client_scene = getdvarstring("");
			if(str_client_scene != "")
			{
				level util::clientnotify(str_client_scene + "");
				util::wait_network_frame();
			}
			if(str_scene != "")
			{
				setdvar("", "");
				level stop(str_scene, 1);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: capture_scene
	Namespace: scene
	Checksum: 0xCDC90501
	Offset: 0xBA0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function capture_scene(str_scene, str_mode)
{
	/#
		setdvar("", 0);
		level play(str_scene, undefined, undefined, 1, undefined, str_mode);
	#/
}

/*
	Name: clear_old_ents
	Namespace: scene
	Checksum: 0xB17ABB79
	Offset: 0xC08
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function clear_old_ents(str_scene)
{
	/#
		foreach(ent in getentarray(str_scene, ""))
		{
			if(ent.scene_spawned === str_scene)
			{
				ent delete();
			}
		}
	#/
}

/*
	Name: toggle_scene_menu
	Namespace: scene
	Checksum: 0xCCF595B1
	Offset: 0xCD8
	Size: 0x178
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
							setdvar("", 0);
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
	Checksum: 0x4B1C36ED
	Offset: 0xE58
	Size: 0x190
	Parameters: 2
	Flags: Linked
*/
function create_scene_hud(scene_name, index)
{
	/#
		player = level.host;
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
		hudelem = player openluimenu("");
		player setluimenudata(hudelem, "", scene_name);
		player setluimenudata(hudelem, "", 100);
		player setluimenudata(hudelem, "", 80 + (index * 18));
		player setluimenudata(hudelem, "", 1000);
		return hudelem;
	#/
}

/*
	Name: display_scene_menu
	Namespace: scene
	Checksum: 0x8EC5F1B4
	Offset: 0xFF8
	Size: 0x948
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
		setdvar("", 1);
		setdvar("", 0);
		level thread display_mode();
		hudelem = level.host openluimenu("");
		level.host setluimenudata(hudelem, "", "");
		level.host setluimenudata(hudelem, "", 100);
		level.host setluimenudata(hudelem, "", 520);
		level.host setluimenudata(hudelem, "", 500);
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
		level thread scene_menu_cleanup(elems, title, hudelem);
		while(true)
		{
			scene_list_settext(elems, names, selected);
			if(held)
			{
				wait(0.5);
			}
			if(!up_pressed)
			{
				if(level.host util::up_button_pressed())
				{
					up_pressed = 1;
					selected--;
				}
			}
			else
			{
				if(level.host util::up_button_held())
				{
					held = 1;
					selected = selected - 10;
				}
				else if(!level.host util::up_button_pressed())
				{
					held = 0;
					up_pressed = 0;
				}
			}
			if(!down_pressed)
			{
				if(level.host util::down_button_pressed())
				{
					down_pressed = 1;
					selected++;
				}
			}
			else
			{
				if(level.host util::down_button_held())
				{
					held = 1;
					selected = selected + 10;
				}
				else if(!level.host util::down_button_pressed())
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
			if(level.host buttonpressed(""))
			{
				setdvar("", 0);
			}
			if(names[selected] != "")
			{
				if(level.host buttonpressed("") || level.host buttonpressed(""))
				{
					level.host move_to_scene(names[selected]);
					while(level.host buttonpressed("") || level.host buttonpressed(""))
					{
						wait(0.05);
					}
				}
				else if(level.host buttonpressed("") || level.host buttonpressed(""))
				{
					level.host move_to_scene(names[selected], 1);
					while(level.host buttonpressed("") || level.host buttonpressed(""))
					{
						wait(0.05);
					}
				}
			}
			if(level.host buttonpressed("") || level.host buttonpressed("") || level.host buttonpressed(""))
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
				while(level.host buttonpressed("") || level.host buttonpressed("") || level.host buttonpressed(""))
				{
					wait(0.05);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: display_mode
	Namespace: scene
	Checksum: 0x1B325CC0
	Offset: 0x1948
	Size: 0x234
	Parameters: 0
	Flags: Linked
*/
function display_mode()
{
	/#
		hudelem = level.host openluimenu("");
		level.host setluimenudata(hudelem, "", 100);
		level.host setluimenudata(hudelem, "", 490);
		level.host setluimenudata(hudelem, "", 500);
		while(level flagsys::get(""))
		{
			str_mode = tolower(getdvarstring("", ""));
			switch(str_mode)
			{
				case "":
				{
					level.host setluimenudata(hudelem, "", "");
					break;
				}
				case "":
				{
					level.host setluimenudata(hudelem, "", "");
					break;
				}
				case "":
				{
					level.host setluimenudata(hudelem, "", "");
					break;
				}
				case "":
				{
					level.host setluimenudata(hudelem, "", "");
					break;
				}
			}
			wait(0.05);
		}
		level.host closeluimenu(hudelem);
	#/
}

/*
	Name: scene_list_menu
	Namespace: scene
	Checksum: 0x8C620AE4
	Offset: 0x1B88
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
	Checksum: 0x6704776F
	Offset: 0x1C18
	Size: 0x20E
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
				level.host setluimenudata(hud_array[i], "", 1);
				text = text + "";
			}
			else
			{
				if(is_scene_initialized(text))
				{
					level.host setluimenudata(hud_array[i], "", 1);
					text = text + "";
				}
				else
				{
					level.host setluimenudata(hud_array[i], "", 0.5);
				}
			}
			if(i == 5)
			{
				level.host setluimenudata(hud_array[i], "", 1);
				text = ("" + text) + "";
			}
			level.host setluimenudata(hud_array[i], "", text);
		}
	#/
}

/*
	Name: is_scene_playing
	Namespace: scene
	Checksum: 0x6A7FE4C7
	Offset: 0x1E30
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
	Checksum: 0x2672DE33
	Offset: 0x1E98
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
	Checksum: 0x3FD7833B
	Offset: 0x1F00
	Size: 0xB4
	Parameters: 3
	Flags: Linked
*/
function scene_menu_cleanup(elems, title, hudelem)
{
	/#
		level waittill(#"scene_menu_cleanup");
		level.host closeluimenu(title);
		for(i = 0; i < elems.size; i++)
		{
			level.host closeluimenu(elems[i]);
		}
		level.host closeluimenu(hudelem);
	#/
}

/*
	Name: test_init
	Namespace: scene
	Checksum: 0xF08F4948
	Offset: 0x1FC0
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
	Checksum: 0x712082F7
	Offset: 0x1FF8
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function test_play(arg1, str_mode)
{
	/#
		play(arg1, undefined, undefined, 1, undefined, str_mode);
	#/
}

/*
	Name: debug_display
	Namespace: scene
	Checksum: 0xFAAE9549
	Offset: 0x2040
	Size: 0x2DE
	Parameters: 0
	Flags: Linked
*/
function debug_display()
{
	/#
		self endon(#"death");
		self notify(#"hash_87671d41");
		self endon(#"hash_87671d41");
		level endon(#"kill_anim_debug");
		while(true)
		{
			debug_frames = randomintrange(5, 15);
			debug_time = debug_frames / 20;
			v_origin = (isdefined(self.origin) ? self.origin : (0, 0, 0));
			sphere(v_origin, 1, (1, 1, 0), 1, 1, 8, debug_frames);
			if(isdefined(self.scenes))
			{
				foreach(i, o_scene in self.scenes)
				{
					n_offset = 15 * (i + 1);
					print3d(v_origin - (0, 0, n_offset), [[ o_scene ]]->get_name(), (0.8, 0.2, 0.8), 1, 0.3, debug_frames);
					print3d(v_origin - (0, 0, n_offset + 5), ("" + (isdefined([[ o_scene ]]->get_state()) ? "" + ([[ o_scene ]]->get_state()) : "")) + "", (0.8, 0.2, 0.8), 1, 0.15, debug_frames);
				}
			}
			else
			{
				if(isdefined(self.scriptbundlename))
				{
					print3d(v_origin - vectorscale((0, 0, 1), 15), self.scriptbundlename, (0.8, 0.2, 0.8), 1, 0.3, debug_frames);
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

/*
	Name: move_to_scene
	Namespace: scene
	Checksum: 0x2546C035
	Offset: 0x2328
	Size: 0x224
	Parameters: 2
	Flags: Linked
*/
function move_to_scene(str_scene, b_reverse_dir)
{
	/#
		if(!isdefined(b_reverse_dir))
		{
			b_reverse_dir = 0;
		}
		if(!level.debug_current_scene_name === str_scene)
		{
			level.debug_current_scene_instances = struct::get_array(str_scene, "");
			level.debug_current_scene_index = 0;
			level.debug_current_scene_name = str_scene;
		}
		else
		{
			if(b_reverse_dir)
			{
				level.debug_current_scene_index--;
				if(level.debug_current_scene_index == -1)
				{
					level.debug_current_scene_index = level.debug_current_scene_instances.size - 1;
				}
			}
			else
			{
				level.debug_current_scene_index++;
				if(level.debug_current_scene_index == level.debug_current_scene_instances.size)
				{
					level.debug_current_scene_index = 0;
				}
			}
		}
		if(level.debug_current_scene_instances.size == 0)
		{
			s_bundle = struct::get_script_bundle("", str_scene);
			if(isdefined(s_bundle.aligntarget))
			{
				e_align = get_existing_ent(s_bundle.aligntarget, 0, 1);
				if(isdefined(e_align))
				{
					level.host set_origin(e_align.origin);
				}
				else
				{
					scriptbundle::error_on_screen("");
				}
			}
			else
			{
				scriptbundle::error_on_screen("");
			}
		}
		else
		{
			s_scene = level.debug_current_scene_instances[level.debug_current_scene_index];
			level.host set_origin(s_scene.origin);
		}
	#/
}

/*
	Name: set_origin
	Namespace: scene
	Checksum: 0x6126F971
	Offset: 0x2558
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function set_origin(v_origin)
{
	/#
		if(!self isinmovemode("", ""))
		{
			adddebugcommand("");
		}
		self setorigin(v_origin);
	#/
}

/*
	Name: toggle_postfx_igc_loop
	Namespace: scene
	Checksum: 0xF20F5BAF
	Offset: 0x25C8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function toggle_postfx_igc_loop()
{
	/#
		while(true)
		{
			if(getdvarint("", 0))
			{
				array::run_all(level.activeplayers, &clientfield::increment_to_player, "", 1);
				wait(4);
			}
			wait(1);
		}
	#/
}

