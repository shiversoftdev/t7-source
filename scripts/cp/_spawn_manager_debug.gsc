// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_spawn_manager;
#using scripts\shared\util_shared;

#namespace spawn_manager;

/*
	Name: spawn_manager_debug
	Namespace: spawn_manager
	Checksum: 0x446E2B77
	Offset: 0xD0
	Size: 0x220
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_debug()
{
	/#
		for(;;)
		{
			if(getdvarstring("") != "")
			{
				wait(0.1);
				continue;
			}
			managers = get_spawn_manager_array();
			manageractivecount = 0;
			managerpotentialspawncount = 0;
			level.debugactivemanagers = [];
			for(i = 0; i < managers.size; i++)
			{
				if(isdefined(managers[i]) && isdefined(managers[i].enable))
				{
					if(managers[i].enable || (!managers[i].enable && isdefined(managers[i].spawners)))
					{
						if(managers[i].count < 0 || managers[i].count > managers[i].spawncount)
						{
							if(managers[i].enable && isdefined(managers[i].sm_active_count))
							{
								manageractivecount = manageractivecount + 1;
								managerpotentialspawncount = managerpotentialspawncount + managers[i].sm_active_count;
							}
							level.debugactivemanagers[level.debugactivemanagers.size] = managers[i];
						}
					}
				}
			}
			spawn_manager_debug_hud_update(level.spawn_manager_active_ai, level.spawn_manager_total_count, level.spawn_manager_max_ai, manageractivecount, managerpotentialspawncount);
			wait(0.05);
		}
	#/
}

/*
	Name: spawn_manager_debug_hud_update
	Namespace: spawn_manager
	Checksum: 0xF3C375E1
	Offset: 0x2F8
	Size: 0x636
	Parameters: 5
	Flags: Linked
*/
function spawn_manager_debug_hud_update(active_ai, spawn_ai, max_ai, active_managers, potential_ai)
{
	/#
		if(getdvarstring("") == "")
		{
			if(!isdefined(level.spawn_manager_debug_hud_title))
			{
				level.spawn_manager_debug_hud_title = newhudelem();
				level.spawn_manager_debug_hud_title.alignx = "";
				level.spawn_manager_debug_hud_title.x = 2;
				level.spawn_manager_debug_hud_title.y = 40;
				level.spawn_manager_debug_hud_title.fontscale = 1.5;
				level.spawn_manager_debug_hud_title.color = (1, 1, 1);
			}
			if(!isdefined(level.spawn_manager_debug_hud))
			{
				level.spawn_manager_debug_hud = [];
			}
			level.spawn_manager_debug_hud_title settext((((((((("" + spawn_ai) + "") + active_ai) + "") + potential_ai) + "") + max_ai) + "") + active_managers);
			for(i = 0; i < level.debugactivemanagers.size; i++)
			{
				if(!isdefined(level.spawn_manager_debug_hud[i]))
				{
					level.spawn_manager_debug_hud[i] = newhudelem();
					level.spawn_manager_debug_hud[i].alignx = "";
					level.spawn_manager_debug_hud[i].x = 0;
					level.spawn_manager_debug_hud[i].fontscale = 1;
					level.spawn_manager_debug_hud[i].y = level.spawn_manager_debug_hud_title.y + ((i + 1) * 15);
				}
				if(isdefined(level.current_debug_spawn_manager) && level.debugactivemanagers[i] == level.current_debug_spawn_manager)
				{
					if(!level.debugactivemanagers[i].enable)
					{
						level.spawn_manager_debug_hud[i].color = vectorscale((0, 1, 0), 0.4);
					}
					else
					{
						level.spawn_manager_debug_hud[i].color = (0, 1, 0);
					}
				}
				else
				{
					if(level.debugactivemanagers[i].enable)
					{
						level.spawn_manager_debug_hud[i].color = (1, 1, 1);
					}
					else
					{
						level.spawn_manager_debug_hud[i].color = vectorscale((1, 1, 1), 0.4);
					}
				}
				text = ("" + level.debugactivemanagers[i].sm_id) + "";
				text = text + ("" + level.debugactivemanagers[i].spawncount);
				text = text + (((((("" + level.debugactivemanagers[i].activeai.size) + "") + level.debugactivemanagers[i].sm_active_count_min) + "") + level.debugactivemanagers[i].sm_active_count_max) + "");
				text = text + ("" + level.debugactivemanagers[i].allspawners.size);
				if(isdefined(level.debugactivemanagers[i].sm_group_size))
				{
					text = text + (((((("" + level.debugactivemanagers[i].sm_group_size) + "") + level.debugactivemanagers[i].sm_group_size_min) + "") + level.debugactivemanagers[i].sm_group_size_max) + "");
				}
				level.spawn_manager_debug_hud[i] settext(text);
			}
			if(level.debugactivemanagers.size < level.spawn_manager_debug_hud.size)
			{
				for(i = level.debugactivemanagers.size; i < level.spawn_manager_debug_hud.size; i++)
				{
					if(isdefined(level.spawn_manager_debug_hud[i]))
					{
						level.spawn_manager_debug_hud[i] destroy();
					}
				}
			}
		}
		if(getdvarstring("") != "")
		{
			if(isdefined(level.spawn_manager_debug_hud_title))
			{
				level.spawn_manager_debug_hud_title destroy();
			}
			if(isdefined(level.spawn_manager_debug_hud))
			{
				for(i = 0; i < level.spawn_manager_debug_hud.size; i++)
				{
					if(isdefined(level.spawn_manager_debug_hud) && isdefined(level.spawn_manager_debug_hud[i]))
					{
						level.spawn_manager_debug_hud[i] destroy();
					}
				}
				level.spawn_manager_debug_hud = undefined;
			}
		}
	#/
}

/*
	Name: on_player_connect
	Namespace: spawn_manager
	Checksum: 0xDF8555B3
	Offset: 0x938
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	/#
		level thread spawn_manager_debug_spawn_manager();
	#/
}

/*
	Name: spawn_manager_debug_spawn_manager
	Namespace: spawn_manager
	Checksum: 0xFBF28BC6
	Offset: 0x960
	Size: 0x328
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_debug_spawn_manager()
{
	/#
		level notify(#"spawn_manager_debug_spawn_manager");
		level endon(#"spawn_manager_debug_spawn_manager");
		level.current_debug_spawn_manager = undefined;
		level.current_debug_spawn_manager_targetname = undefined;
		level.test_player = getplayers()[0];
		current_spawn_manager_index = -1;
		old_spawn_manager_index = undefined;
		while(true)
		{
			if(getdvarstring("") != "")
			{
				destroy_tweak_hud_elements();
				wait(0.05);
				continue;
			}
			if(isdefined(level.debugactivemanagers) && level.debugactivemanagers.size > 0)
			{
				if(current_spawn_manager_index == -1)
				{
					current_spawn_manager_index = 0;
					old_spawn_manager_index = 0;
				}
				if(level.test_player buttonpressed(""))
				{
					old_spawn_manager_index = current_spawn_manager_index;
					if(level.test_player buttonpressed(""))
					{
						current_spawn_manager_index--;
						if(current_spawn_manager_index < 0)
						{
							current_spawn_manager_index = 0;
						}
					}
					if(level.test_player buttonpressed(""))
					{
						current_spawn_manager_index++;
						if(current_spawn_manager_index > (level.debugactivemanagers.size - 1))
						{
							current_spawn_manager_index = level.debugactivemanagers.size - 1;
						}
					}
				}
				if(isdefined(current_spawn_manager_index) && current_spawn_manager_index != -1)
				{
					if(isdefined(level.current_debug_spawn_manager) && isdefined(level.debugactivemanagers[current_spawn_manager_index]))
					{
						if(isdefined(old_spawn_manager_index) && old_spawn_manager_index == current_spawn_manager_index)
						{
							if(level.debugactivemanagers[current_spawn_manager_index].targetname != level.current_debug_spawn_manager_targetname)
							{
								for(i = 0; i < level.debugactivemanagers.size; i++)
								{
									if(level.debugactivemanagers[i].targetname == level.current_debug_spawn_manager_targetname)
									{
										current_spawn_manager_index = i;
										old_spawn_manager_index = i;
									}
								}
							}
						}
					}
					if(isdefined(level.debugactivemanagers[current_spawn_manager_index]))
					{
						level.current_debug_spawn_manager = level.debugactivemanagers[current_spawn_manager_index];
						level.current_debug_spawn_manager_targetname = level.debugactivemanagers[current_spawn_manager_index].targetname;
					}
				}
				if(isdefined(level.current_debug_spawn_manager))
				{
					level.current_debug_spawn_manager spawn_manager_debug_spawn_manager_values_dpad();
				}
			}
			else
			{
				destroy_tweak_hud_elements();
			}
			wait(0.25);
		}
	#/
}

/*
	Name: spawn_manager_debug_spawner_values
	Namespace: spawn_manager
	Checksum: 0x348BC46B
	Offset: 0xC90
	Size: 0x20C
	Parameters: 0
	Flags: None
*/
function spawn_manager_debug_spawner_values()
{
	/#
		while(true)
		{
			if(getdvarstring("") != "")
			{
				wait(0.1);
				continue;
			}
			if(isdefined(level.current_debug_spawn_manager))
			{
				spawn_manager = level.current_debug_spawn_manager;
				if(isdefined(spawn_manager.spawners))
				{
					for(i = 0; i < spawn_manager.spawners.size; i++)
					{
						current_spawner = spawn_manager.spawners[i];
						if(isdefined(current_spawner) && current_spawner.count > 0)
						{
							spawnerfree = current_spawner.sm_active_count - current_spawner.activeai.size;
							print3d(current_spawner.origin + vectorscale((0, 0, 1), 65), "" + current_spawner.count, (0, 1, 0), 1, 1.25, 2);
							print3d(current_spawner.origin + vectorscale((0, 0, 1), 85), (((("" + current_spawner.activeai.size) + "") + spawnerfree) + "") + current_spawner.sm_active_count, (0, 1, 0), 1, 1.25, 2);
						}
					}
				}
				wait(0.05);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: ent_print
	Namespace: spawn_manager
	Checksum: 0xA51CA00
	Offset: 0xEA8
	Size: 0x78
	Parameters: 1
	Flags: None
*/
function ent_print(text)
{
	/#
		self endon(#"death");
		while(true)
		{
			print3d(self.origin + vectorscale((0, 0, 1), 65), text, (0.48, 9.4, 0.76), 1, 1);
			wait(0.05);
		}
	#/
}

/*
	Name: spawn_manager_debug_spawn_manager_values_dpad
	Namespace: spawn_manager
	Checksum: 0xF35DEB89
	Offset: 0xF28
	Size: 0xBCC
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_debug_spawn_manager_values_dpad()
{
	/#
		if(!isdefined(level.current_debug_index))
		{
			level.current_debug_index = 0;
		}
		if(!isdefined(level.spawn_manager_debug_hud2))
		{
			level.spawn_manager_debug_hud2 = newhudelem();
			level.spawn_manager_debug_hud2.alignx = "";
			level.spawn_manager_debug_hud2.x = 10;
			level.spawn_manager_debug_hud2.y = 150;
			level.spawn_manager_debug_hud2.fontscale = 1.25;
			level.spawn_manager_debug_hud2.color = (1, 0, 0);
		}
		if(!isdefined(level.sm_active_count_title))
		{
			level.sm_active_count_title = newhudelem();
			level.sm_active_count_title.alignx = "";
			level.sm_active_count_title.x = 10;
			level.sm_active_count_title.y = 165;
			level.sm_active_count_title.color = (1, 1, 1);
		}
		if(!isdefined(level.sm_active_count_min_hud))
		{
			level.sm_active_count_min_hud = newhudelem();
			level.sm_active_count_min_hud.alignx = "";
			level.sm_active_count_min_hud.x = 10;
			level.sm_active_count_min_hud.y = 180;
			level.sm_active_count_min_hud.color = (1, 1, 1);
		}
		if(!isdefined(level.sm_active_count_max_hud))
		{
			level.sm_active_count_max_hud = newhudelem();
			level.sm_active_count_max_hud.alignx = "";
			level.sm_active_count_max_hud.x = 10;
			level.sm_active_count_max_hud.y = 195;
			level.sm_active_count_max_hud.color = (1, 1, 1);
		}
		if(!isdefined(level.sm_group_size_min_hud))
		{
			level.sm_group_size_min_hud = newhudelem();
			level.sm_group_size_min_hud.alignx = "";
			level.sm_group_size_min_hud.x = 10;
			level.sm_group_size_min_hud.y = 210;
			level.sm_group_size_min_hud.color = (1, 1, 1);
		}
		if(!isdefined(level.sm_group_size_max_hud))
		{
			level.sm_group_size_max_hud = newhudelem();
			level.sm_group_size_max_hud.alignx = "";
			level.sm_group_size_max_hud.x = 10;
			level.sm_group_size_max_hud.y = 225;
			level.sm_group_size_max_hud.color = (1, 1, 1);
		}
		if(!isdefined(level.sm_spawner_count_title))
		{
			level.sm_spawner_count_title = newhudelem();
			level.sm_spawner_count_title.alignx = "";
			level.sm_spawner_count_title.x = 10;
			level.sm_spawner_count_title.y = 240;
			level.sm_spawner_count_title.color = (1, 1, 1);
		}
		if(!isdefined(level.sm_spawner_count_min_hud))
		{
			level.sm_spawner_count_min_hud = newhudelem();
			level.sm_spawner_count_min_hud.alignx = "";
			level.sm_spawner_count_min_hud.x = 10;
			level.sm_spawner_count_min_hud.y = 255;
			level.sm_spawner_count_min_hud.color = (1, 1, 1);
		}
		if(!isdefined(level.sm_spawner_count_max_hud))
		{
			level.sm_spawner_count_max_hud = newhudelem();
			level.sm_spawner_count_max_hud.alignx = "";
			level.sm_spawner_count_max_hud.x = 10;
			level.sm_spawner_count_max_hud.y = 270;
			level.sm_spawner_count_max_hud.color = (1, 1, 1);
		}
		if(level.test_player buttonpressed(""))
		{
			if(level.test_player buttonpressed(""))
			{
				level.current_debug_index++;
				if(level.current_debug_index > 7)
				{
					level.current_debug_index = 7;
				}
			}
			if(level.test_player buttonpressed(""))
			{
				level.current_debug_index--;
				if(level.current_debug_index < 0)
				{
					level.current_debug_index = 0;
				}
			}
		}
		set_debug_hud_colors();
		increase_value = 0;
		decrease_value = 0;
		if(level.test_player buttonpressed(""))
		{
			if(level.test_player buttonpressed(""))
			{
				decrease_value = 1;
			}
			if(level.test_player buttonpressed(""))
			{
				increase_value = 1;
			}
		}
		should_run_set_up = 0;
		if(increase_value || decrease_value)
		{
			if(increase_value)
			{
				add = 1;
			}
			else
			{
				add = -1;
			}
			switch(level.current_debug_index)
			{
				case 0:
				{
					if((self.sm_active_count + add) > self.sm_active_count_max)
					{
						self.sm_active_count_max = self.sm_active_count + add;
					}
					if((self.sm_active_count + add) < self.sm_active_count_min)
					{
						if((self.sm_active_count + add) > 0)
						{
							self.sm_active_count_min = self.sm_active_count + add;
						}
					}
					should_run_set_up = 1;
					self.sm_active_count = self.sm_active_count + add;
					break;
				}
				case 1:
				{
					if((self.sm_active_count_min + add) < self.sm_group_size_max)
					{
						modify_debug_hud2("");
						break;
					}
					if((self.sm_active_count_min + add) > self.sm_active_count_max)
					{
						modify_debug_hud2("");
						break;
					}
					should_run_set_up = 1;
					self.sm_active_count_min = self.sm_active_count_min + add;
					break;
				}
				case 2:
				{
					if((self.sm_active_count_max + add) < self.sm_active_count_min)
					{
						modify_debug_hud2("");
						break;
					}
					should_run_set_up = 1;
					self.sm_active_count_max = self.sm_active_count_max + add;
					break;
				}
				case 3:
				{
					if((self.sm_group_size_min + add) > self.sm_group_size_max)
					{
						modify_debug_hud2("");
						break;
					}
					should_run_set_up = 1;
					self.sm_group_size_min = self.sm_group_size_min + add;
					break;
				}
				case 4:
				{
					if((self.sm_group_size_max + add) < self.sm_group_size_min)
					{
						modify_debug_hud2("");
						break;
					}
					if((self.sm_group_size_max + add) > self.sm_active_count)
					{
						modify_debug_hud2("");
						break;
					}
					should_run_set_up = 1;
					self.sm_group_size_max = self.sm_group_size_max + add;
					break;
				}
				case 5:
				{
					if((self.sm_spawner_count + add) > self.allspawners.size)
					{
						modify_debug_hud2("");
						break;
					}
					if((self.sm_spawner_count + add) <= 0)
					{
						modify_debug_hud2("");
						break;
					}
					if((self.sm_spawner_count + add) < self.sm_spawner_count_min)
					{
						if((self.sm_spawner_count + add) > 0)
						{
							self.sm_spawner_count_min = self.sm_spawner_count + add;
						}
					}
					if((self.sm_spawner_count + add) > self.sm_spawner_count_max)
					{
						self.sm_spawner_count_max = self.sm_spawner_count + add;
					}
					should_run_set_up = 1;
					self.sm_spawner_count = self.sm_spawner_count + add;
					break;
				}
				case 6:
				{
					if((self.sm_spawner_count_min + add) > self.sm_spawner_count_max)
					{
						modify_debug_hud2("");
						break;
					}
					should_run_set_up = 1;
					self.sm_spawner_count_min = self.sm_spawner_count_min + add;
					break;
				}
				case 7:
				{
					if((self.sm_spawner_count_max + add) < self.sm_spawner_count_min)
					{
						modify_debug_hud2("");
						break;
					}
					should_run_set_up = 1;
					self.sm_spawner_count_max = self.sm_spawner_count_max + add;
					break;
				}
			}
		}
		if(should_run_set_up)
		{
			level.current_debug_spawn_manager spawn_manager_debug_setup();
		}
		if(isdefined(self))
		{
			level.sm_active_count_min_hud settext("" + self.sm_active_count_min);
			level.sm_active_count_max_hud settext("" + self.sm_active_count_max);
			level.sm_group_size_min_hud settext("" + self.sm_group_size_min);
			level.sm_group_size_max_hud settext("" + self.sm_group_size_max);
			if(isdefined(self.sm_spawner_count))
			{
				level.sm_spawner_count_title settext("" + self.sm_spawner_count);
				level.sm_spawner_count_min_hud settext("" + self.sm_spawner_count_min);
				level.sm_spawner_count_max_hud settext("" + self.sm_spawner_count_max);
			}
		}
	#/
}

/*
	Name: set_debug_hud_colors
	Namespace: spawn_manager
	Checksum: 0x4C007A0D
	Offset: 0x1B00
	Size: 0x57E
	Parameters: 0
	Flags: Linked
*/
function set_debug_hud_colors()
{
	/#
		switch(level.current_debug_index)
		{
			case 0:
			{
				level.sm_active_count_title.color = (0, 1, 0);
				level.sm_active_count_min_hud.color = (1, 1, 1);
				level.sm_active_count_max_hud.color = (1, 1, 1);
				level.sm_group_size_min_hud.color = (1, 1, 1);
				level.sm_group_size_max_hud.color = (1, 1, 1);
				level.sm_spawner_count_title.color = (1, 1, 1);
				level.sm_spawner_count_min_hud.color = (1, 1, 1);
				level.sm_spawner_count_max_hud.color = (1, 1, 1);
				break;
			}
			case 1:
			{
				level.sm_active_count_title.color = (1, 1, 1);
				level.sm_active_count_min_hud.color = (0, 1, 0);
				level.sm_active_count_max_hud.color = (1, 1, 1);
				level.sm_group_size_min_hud.color = (1, 1, 1);
				level.sm_group_size_max_hud.color = (1, 1, 1);
				level.sm_spawner_count_title.color = (1, 1, 1);
				level.sm_spawner_count_min_hud.color = (1, 1, 1);
				level.sm_spawner_count_max_hud.color = (1, 1, 1);
				break;
			}
			case 2:
			{
				level.sm_active_count_title.color = (1, 1, 1);
				level.sm_active_count_min_hud.color = (1, 1, 1);
				level.sm_active_count_max_hud.color = (0, 1, 0);
				level.sm_group_size_min_hud.color = (1, 1, 1);
				level.sm_group_size_max_hud.color = (1, 1, 1);
				level.sm_spawner_count_title.color = (1, 1, 1);
				level.sm_spawner_count_min_hud.color = (1, 1, 1);
				level.sm_spawner_count_max_hud.color = (1, 1, 1);
				break;
			}
			case 3:
			{
				level.sm_active_count_title.color = (1, 1, 1);
				level.sm_active_count_min_hud.color = (1, 1, 1);
				level.sm_active_count_max_hud.color = (1, 1, 1);
				level.sm_group_size_min_hud.color = (0, 1, 0);
				level.sm_group_size_max_hud.color = (1, 1, 1);
				level.sm_spawner_count_title.color = (1, 1, 1);
				level.sm_spawner_count_min_hud.color = (1, 1, 1);
				level.sm_spawner_count_max_hud.color = (1, 1, 1);
				break;
			}
			case 4:
			{
				level.sm_active_count_title.color = (1, 1, 1);
				level.sm_active_count_min_hud.color = (1, 1, 1);
				level.sm_active_count_max_hud.color = (1, 1, 1);
				level.sm_group_size_min_hud.color = (1, 1, 1);
				level.sm_group_size_max_hud.color = (0, 1, 0);
				level.sm_spawner_count_title.color = (1, 1, 1);
				level.sm_spawner_count_min_hud.color = (1, 1, 1);
				level.sm_spawner_count_max_hud.color = (1, 1, 1);
				break;
			}
			case 5:
			{
				level.sm_active_count_title.color = (1, 1, 1);
				level.sm_active_count_min_hud.color = (1, 1, 1);
				level.sm_active_count_max_hud.color = (1, 1, 1);
				level.sm_group_size_min_hud.color = (1, 1, 1);
				level.sm_group_size_max_hud.color = (1, 1, 1);
				level.sm_spawner_count_title.color = (0, 1, 0);
				level.sm_spawner_count_min_hud.color = (1, 1, 1);
				level.sm_spawner_count_max_hud.color = (1, 1, 1);
				break;
			}
			case 6:
			{
				level.sm_active_count_title.color = (1, 1, 1);
				level.sm_active_count_min_hud.color = (1, 1, 1);
				level.sm_active_count_max_hud.color = (1, 1, 1);
				level.sm_group_size_min_hud.color = (1, 1, 1);
				level.sm_group_size_max_hud.color = (1, 1, 1);
				level.sm_spawner_count_title.color = (1, 1, 1);
				level.sm_spawner_count_min_hud.color = (0, 1, 0);
				level.sm_spawner_count_max_hud.color = (1, 1, 1);
				break;
			}
			case 7:
			{
				level.sm_active_count_title.color = (1, 1, 1);
				level.sm_active_count_min_hud.color = (1, 1, 1);
				level.sm_active_count_max_hud.color = (1, 1, 1);
				level.sm_group_size_min_hud.color = (1, 1, 1);
				level.sm_group_size_max_hud.color = (1, 1, 1);
				level.sm_spawner_count_title.color = (1, 1, 1);
				level.sm_spawner_count_min_hud.color = (1, 1, 1);
				level.sm_spawner_count_max_hud.color = (0, 1, 0);
				break;
			}
		}
	#/
}

/*
	Name: spawn_manager_debug_setup
	Namespace: spawn_manager
	Checksum: 0x6ADE33D8
	Offset: 0x2088
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function spawn_manager_debug_setup()
{
	/#
		if(isdefined(level.current_debug_index) && level.current_debug_index != 5)
		{
			self.sm_spawner_count = randomintrange(self.sm_spawner_count_min, self.sm_spawner_count_max + 1);
		}
		if(isdefined(level.current_debug_index) && level.current_debug_index != 0)
		{
			self.sm_active_count = randomintrange(self.sm_active_count_min, self.sm_active_count_max + 1);
		}
		self.spawners = self spawn_manager_get_spawners();
		/#
			assert(self.count >= self.count_min);
		#/
		/#
			assert(self.count <= self.count_max);
		#/
		/#
			assert(self.sm_active_count >= self.sm_active_count_min);
		#/
		/#
			assert(self.sm_active_count <= self.sm_active_count_max);
		#/
		/#
			assert(self.sm_group_size_max <= self.sm_active_count);
		#/
		/#
			assert(self.sm_group_size_min <= self.sm_active_count);
		#/
	#/
}

/*
	Name: modify_debug_hud2
	Namespace: spawn_manager
	Checksum: 0x35A09932
	Offset: 0x2240
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function modify_debug_hud2(text)
{
	/#
		self notify(#"modified");
		wait(0.05);
		level.spawn_manager_debug_hud2 settext(text);
		level.spawn_manager_debug_hud2 thread moniter_debug_hud2();
	#/
}

/*
	Name: moniter_debug_hud2
	Namespace: spawn_manager
	Checksum: 0xCE440999
	Offset: 0x22A8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function moniter_debug_hud2()
{
	/#
		self endon(#"modified");
		wait(10);
		level.spawn_manager_debug_hud2 settext("");
	#/
}

/*
	Name: destroy_tweak_hud_elements
	Namespace: spawn_manager
	Checksum: 0x8E345548
	Offset: 0x22F0
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function destroy_tweak_hud_elements()
{
	/#
		if(isdefined(level.sm_active_count_title))
		{
			level.sm_active_count_title destroy();
		}
		if(isdefined(level.sm_active_count_min_hud))
		{
			level.sm_active_count_min_hud destroy();
		}
		if(isdefined(level.sm_active_count_max_hud))
		{
			level.sm_active_count_max_hud destroy();
		}
		if(isdefined(level.sm_group_size_min_hud))
		{
			level.sm_group_size_min_hud destroy();
		}
		if(isdefined(level.sm_group_size_max_hud))
		{
			level.sm_group_size_max_hud destroy();
		}
		if(isdefined(level.sm_spawner_count_title))
		{
			level.sm_spawner_count_title destroy();
		}
		if(isdefined(level.sm_spawner_count_min_hud))
		{
			level.sm_spawner_count_min_hud destroy();
		}
		if(isdefined(level.sm_spawner_count_max_hud))
		{
			level.sm_spawner_count_max_hud destroy();
		}
	#/
}

