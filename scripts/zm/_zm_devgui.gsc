// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_rat;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_turned;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_devgui;

/*
	Name: __init__sytem__
	Namespace: zm_devgui
	Checksum: 0x4CE78BC
	Offset: 0x3E0
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("", &__init__, &__main__, undefined);
	#/
}

/*
	Name: __init__
	Namespace: zm_devgui
	Checksum: 0xE1065E72
	Offset: 0x430
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		level.devgui_add_weapon = &devgui_add_weapon;
		level.devgui_add_ability = &devgui_add_ability;
		level thread zombie_devgui_think();
		thread zombie_weapon_devgui_think();
		thread function_315fab2d();
		thread devgui_zombie_healthbar();
		thread devgui_test_chart_think();
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		level thread dev::body_customization_devgui(0);
		thread testscriptruntimeerror();
		callback::on_connect(&player_on_connect);
	#/
}

/*
	Name: __main__
	Namespace: zm_devgui
	Checksum: 0x61E7FD8F
	Offset: 0x620
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	/#
		level thread zombie_devgui_player_commands();
		level thread zombie_devgui_validation_commands();
		level thread zombie_draw_traversals();
		level thread function_1d21f4f();
	#/
}

/*
	Name: zombie_devgui_player_commands
	Namespace: zm_devgui
	Checksum: 0x70C4E3F4
	Offset: 0x690
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_player_commands()
{
	/#
	#/
}

/*
	Name: player_on_connect
	Namespace: zm_devgui
	Checksum: 0x42A9C1CD
	Offset: 0x6A0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function player_on_connect()
{
	/#
		level flag::wait_till("");
		wait(1);
		if(isdefined(self))
		{
			zombie_devgui_player_menu(self);
		}
	#/
}

/*
	Name: zombie_devgui_player_menu_clear
	Namespace: zm_devgui
	Checksum: 0x15A4F6B3
	Offset: 0x6F0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_player_menu_clear(playername)
{
	/#
		rootclear = ("" + playername) + "";
		adddebugcommand(rootclear);
	#/
}

/*
	Name: zombie_devgui_player_menu
	Namespace: zm_devgui
	Checksum: 0xEABBCDC6
	Offset: 0x748
	Size: 0x454
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_player_menu(player)
{
	/#
		zombie_devgui_player_menu_clear(player.name);
		ip1 = player getentitynumber() + 1;
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		adddebugcommand(((((("" + player.name) + "") + ip1) + "") + ip1) + "");
		if(isdefined(level.var_e26adf8d))
		{
			level thread [[level.var_e26adf8d]](player, ip1);
		}
		self thread zombie_devgui_player_menu_clear_on_disconnect(player);
	#/
}

/*
	Name: zombie_devgui_player_menu_clear_on_disconnect
	Namespace: zm_devgui
	Checksum: 0x854843D
	Offset: 0xBA8
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_player_menu_clear_on_disconnect(player)
{
	/#
		playername = player.name;
		player waittill(#"disconnect");
		zombie_devgui_player_menu_clear(playername);
	#/
}

/*
	Name: zombie_devgui_validation_commands
	Namespace: zm_devgui
	Checksum: 0x17ECA99D
	Offset: 0xC08
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_validation_commands()
{
	/#
		setdvar("", "");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		while(true)
		{
			cmd = getdvarstring("");
			if(cmd != "")
			{
				switch(cmd)
				{
					case "":
					{
						zombie_spawner_validation();
						break;
					}
					case "":
					{
						if(!isdefined(level.toggle_zone_adjacencies_validation))
						{
							level.toggle_zone_adjacencies_validation = 1;
						}
						else
						{
							level.toggle_zone_adjacencies_validation = !level.toggle_zone_adjacencies_validation;
						}
						thread zone_adjacencies_validation();
						break;
					}
					case "":
					{
						thread zombie_pathing_validation();
					}
					default:
					{
						break;
					}
				}
				setdvar("", "");
			}
			util::wait_network_frame();
		}
	#/
}

/*
	Name: zombie_spawner_validation
	Namespace: zm_devgui
	Checksum: 0x8833465F
	Offset: 0xD90
	Size: 0x3F4
	Parameters: 0
	Flags: Linked
*/
function zombie_spawner_validation()
{
	/#
		level.validation_errors_count = 0;
		if(!isdefined(level.var_3d3b24de))
		{
			level.var_3d3b24de = 1;
			zombie_devgui_open_sesame();
			spawner = level.zombie_spawners[0];
			enemy = undefined;
			foreach(zone in level.zones)
			{
				foreach(spawn_point in zone.a_loc_types[""])
				{
					if(!isdefined(zone.a_loc_types[""]) || zone.a_loc_types[""].size <= 0)
					{
						level.validation_errors_count++;
						thread drawvalidation(spawn_point.origin, spawn_point.zone_name);
						println("" + spawn_point.zone_name);
						iprintlnbold("" + spawn_point.zone_name);
						break;
					}
					if(!isdefined(enemy))
					{
						enemy = zombie_utility::spawn_zombie(spawner, spawner.targetname, spawn_point);
					}
					node = undefined;
					spawn_point_origin = spawn_point.origin;
					if(isdefined(spawn_point.script_string) && spawn_point.script_string != "")
					{
						spawn_point_origin = enemy validate_to_board(spawn_point, spawn_point_origin);
					}
					new_spawn_point_origin = getclosestpointonnavmesh(spawn_point_origin, 40, 30);
					if(!isdefined(new_spawn_point_origin))
					{
						new_spawn_point_origin = getclosestpointonnavmesh(spawn_point_origin, 100, 30);
						if(!isdefined(new_spawn_point_origin))
						{
							level.validation_errors_count++;
							thread drawvalidation(spawn_point_origin);
						}
					}
					ispath = enemy validate_to_wait_point(zone, new_spawn_point_origin, spawn_point);
				}
			}
			println("" + level.validation_errors_count);
			iprintlnbold("" + level.validation_errors_count);
			level.validation_errors_count = undefined;
		}
		else
		{
			level.var_3d3b24de = !level.var_3d3b24de;
		}
	#/
}

/*
	Name: validate_to_board
	Namespace: zm_devgui
	Checksum: 0x5F62E36B
	Offset: 0x1190
	Size: 0x20A
	Parameters: 2
	Flags: Linked
*/
function validate_to_board(spawn_point, spawn_point_origin_backup)
{
	/#
		for(j = 0; j < level.exterior_goals.size; j++)
		{
			if(isdefined(level.exterior_goals[j].script_string) && level.exterior_goals[j].script_string == spawn_point.script_string)
			{
				node = level.exterior_goals[j];
				break;
			}
		}
		if(isdefined(node))
		{
			ispath = self canpath(spawn_point.origin, node.origin);
			if(!ispath)
			{
				level.validation_errors_count++;
				thread drawvalidation(spawn_point_origin_backup, undefined, undefined, node.origin);
				println((("" + spawn_point_origin_backup) + "") + spawn_point.targetname);
				iprintlnbold((("" + spawn_point_origin_backup) + "") + spawn_point.targetname);
			}
			nodeforward = anglestoforward(node.angles);
			nodeforward = vectornormalize(nodeforward);
			spawn_point_origin = node.origin + (nodeforward * 100);
			return spawn_point_origin;
		}
		return spawn_point_origin_backup;
	#/
}

/*
	Name: validate_to_wait_point
	Namespace: zm_devgui
	Checksum: 0xAA60C80D
	Offset: 0x13A8
	Size: 0x218
	Parameters: 3
	Flags: Linked
*/
function validate_to_wait_point(zone, new_spawn_point_origin, spawn_point)
{
	/#
		foreach(loc in zone.a_loc_types[""])
		{
			if(isdefined(loc))
			{
				wait_point = loc.origin;
				if(isdefined(wait_point))
				{
					new_wait_point = getclosestpointonnavmesh(wait_point, 40, 30);
					if(!isdefined(new_wait_point))
					{
						new_wait_point = getclosestpointonnavmesh(wait_point, 100, 30);
					}
					if(isdefined(new_spawn_point_origin) && isdefined(new_wait_point))
					{
						ispath = self canpath(new_spawn_point_origin, new_wait_point);
						if(ispath)
						{
							return true;
						}
						level.validation_errors_count++;
						thread drawvalidation(new_spawn_point_origin, undefined, new_wait_point);
						println((("" + new_spawn_point_origin) + "") + spawn_point.targetname);
						iprintlnbold((("" + new_spawn_point_origin) + "") + spawn_point.targetname);
						return false;
					}
				}
			}
		}
		return false;
	#/
}

/*
	Name: drawvalidation
	Namespace: zm_devgui
	Checksum: 0x7678F58
	Offset: 0x15D0
	Size: 0x310
	Parameters: 4
	Flags: Linked
*/
function drawvalidation(origin, zone_name, nav_mesh_wait_point, boards_point)
{
	/#
		if(!isdefined(zone_name))
		{
			zone_name = undefined;
		}
		if(!isdefined(nav_mesh_wait_point))
		{
			nav_mesh_wait_point = undefined;
		}
		if(!isdefined(boards_point))
		{
			boards_point = undefined;
		}
		while(true)
		{
			if(isdefined(level.var_3d3b24de) && level.var_3d3b24de)
			{
				if(!isdefined(origin))
				{
					break;
				}
				if(isdefined(zone_name))
				{
					circle(origin, 32, (1, 0, 0));
					print3d(origin, "" + zone_name, (1, 1, 1), 1, 0.5);
				}
				else
				{
					if(isdefined(nav_mesh_wait_point))
					{
						circle(origin, 32, (0, 0, 1));
						print3d(origin, "" + origin, (1, 1, 1), 1, 0.5);
						line(origin, nav_mesh_wait_point, (1, 0, 0));
						circle(nav_mesh_wait_point, 32, (1, 0, 0));
						print3d(nav_mesh_wait_point, "" + nav_mesh_wait_point, (1, 1, 1), 1, 0.5);
					}
					else
					{
						if(isdefined(boards_point))
						{
							circle(origin, 32, (0, 0, 1));
							print3d(origin, "" + origin, (1, 1, 1), 1, 0.5);
							line(origin, boards_point, (1, 0, 0));
							circle(boards_point, 32, (1, 0, 0));
							print3d(boards_point, "" + boards_point, (1, 1, 1), 1, 0.5);
						}
						else
						{
							circle(origin, 32, (0, 0, 1));
							print3d(origin, "" + origin, (1, 1, 1), 1, 0.5);
						}
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: zone_adjacencies_validation
	Namespace: zm_devgui
	Checksum: 0x5020E431
	Offset: 0x18E8
	Size: 0x260
	Parameters: 0
	Flags: Linked
*/
function zone_adjacencies_validation()
{
	/#
		zombie_devgui_open_sesame();
		while(true)
		{
			if(isdefined(level.toggle_zone_adjacencies_validation) && level.toggle_zone_adjacencies_validation)
			{
				if(!isdefined(getplayers()[0].zone_name))
				{
					wait(0.05);
					continue;
				}
				str_zone = getplayers()[0].zone_name;
				keys = getarraykeys(level.zones);
				offset = 0;
				foreach(key in keys)
				{
					if(key === str_zone)
					{
						draw_zone_adjacencies_validation(level.zones[key], 2, key);
						continue;
					}
					if(isdefined(level.zones[str_zone].adjacent_zones[key]))
					{
						if(level.zones[str_zone].adjacent_zones[key].is_connected)
						{
							offset = offset + 10;
							draw_zone_adjacencies_validation(level.zones[key], 1, key, level.zones[str_zone], offset);
						}
						else
						{
							draw_zone_adjacencies_validation(level.zones[key], 0, key);
						}
						continue;
					}
					draw_zone_adjacencies_validation(level.zones[key], 0, key);
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: draw_zone_adjacencies_validation
	Namespace: zm_devgui
	Checksum: 0x3101DF27
	Offset: 0x1B50
	Size: 0x244
	Parameters: 5
	Flags: Linked
*/
function draw_zone_adjacencies_validation(zone, status, name, current_zone, offset)
{
	/#
		if(!isdefined(current_zone))
		{
			current_zone = undefined;
		}
		if(!isdefined(offset))
		{
			offset = 0;
		}
		if(!isdefined(zone.volumes[0]))
		{
			return;
		}
		if(status == 2)
		{
			circle(zone.volumes[0].origin, 30, (0, 1, 0));
			print3d(zone.volumes[0].origin, name, (0, 1, 0), 1, 0.5);
		}
		else
		{
			if(status == 1)
			{
				circle(zone.volumes[0].origin, 30, (0, 0, 1));
				print3d(zone.volumes[0].origin, name, (0, 0, 1), 1, 0.5);
				print3d(current_zone.volumes[0].origin + (0, 20, offset * -1), name, (0, 0, 1), 1, 0.5);
			}
			else
			{
				circle(zone.volumes[0].origin, 30, (1, 0, 0));
				print3d(zone.volumes[0].origin, name, (1, 0, 0), 1, 0.5);
			}
		}
	#/
}

/*
	Name: zombie_pathing_validation
	Namespace: zm_devgui
	Checksum: 0xCAC8D0E0
	Offset: 0x1DA0
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function zombie_pathing_validation()
{
	/#
		if(!isdefined(level.zombie_spawners[0]))
		{
			return;
		}
		if(!isdefined(level.zombie_pathing_validation))
		{
			level.zombie_pathing_validation = 1;
		}
		zombie_devgui_open_sesame();
		setdvar("", 0);
		zombie_devgui_goto_round(20);
		wait(2);
		spawner = level.zombie_spawners[0];
		slums_station = (808, -1856, 544);
		enemy = zombie_utility::spawn_zombie(spawner, spawner.targetname);
		wait(1);
		while(isdefined(enemy) && enemy.completed_emerging_into_playable_area !== 1)
		{
			wait(0.05);
		}
		if(isdefined(enemy))
		{
			enemy forceteleport(slums_station);
			enemy.b_ignore_cleanup = 1;
		}
	#/
}

/*
	Name: function_300fe60f
	Namespace: zm_devgui
	Checksum: 0xC72218BA
	Offset: 0x1EF8
	Size: 0xEC
	Parameters: 3
	Flags: Linked
*/
function function_300fe60f(weapon_name, up, root)
{
	/#
		rootslash = "";
		if(isdefined(root) && root.size)
		{
			rootslash = root + "";
		}
		uppath = "" + up;
		if(up.size < 1)
		{
			uppath = "";
		}
		cmd = ((((("" + rootslash) + weapon_name) + uppath) + "") + weapon_name) + "";
		adddebugcommand(cmd);
	#/
}

/*
	Name: devgui_add_weapon_entry
	Namespace: zm_devgui
	Checksum: 0x5055821B
	Offset: 0x1FF0
	Size: 0xEC
	Parameters: 3
	Flags: Linked
*/
function devgui_add_weapon_entry(weapon_name, up, root)
{
	/#
		rootslash = "";
		if(isdefined(root) && root.size)
		{
			rootslash = root + "";
		}
		uppath = "" + up;
		if(up.size < 1)
		{
			uppath = "";
		}
		cmd = ((((("" + rootslash) + weapon_name) + uppath) + "") + weapon_name) + "";
		adddebugcommand(cmd);
	#/
}

/*
	Name: devgui_add_weapon_and_attachments
	Namespace: zm_devgui
	Checksum: 0xFB274287
	Offset: 0x20E8
	Size: 0x3C
	Parameters: 3
	Flags: Linked
*/
function devgui_add_weapon_and_attachments(weapon_name, up, root)
{
	/#
		devgui_add_weapon_entry(weapon_name, up, root);
	#/
}

/*
	Name: devgui_add_weapon
	Namespace: zm_devgui
	Checksum: 0x19D2AED5
	Offset: 0x2130
	Size: 0x13C
	Parameters: 7
	Flags: Linked
*/
function devgui_add_weapon(weapon, upgrade, hint, cost, weaponvo, weaponvoresp, ammo_cost)
{
	/#
		function_300fe60f(weapon.name, "", "");
		if(zm_utility::is_offhand_weapon(weapon) && !zm_utility::is_melee_weapon(weapon))
		{
			return;
		}
		if(!isdefined(level.devgui_weapons_added))
		{
			level.devgui_weapons_added = 0;
		}
		level.devgui_weapons_added++;
		if(zm_utility::is_melee_weapon(weapon))
		{
			devgui_add_weapon_and_attachments(weapon.name, "", "");
		}
		else
		{
			devgui_add_weapon_and_attachments(weapon.name, "", "");
		}
	#/
}

/*
	Name: function_315fab2d
	Namespace: zm_devgui
	Checksum: 0x8B84BA27
	Offset: 0x2278
	Size: 0x300
	Parameters: 0
	Flags: Linked
*/
function function_315fab2d()
{
	/#
		level.zombie_devgui_gun = getdvarstring("");
		for(;;)
		{
			wait(0.1);
			cmd = getdvarstring("");
			if(isdefined(cmd) && cmd.size > 0)
			{
				level.zombie_devgui_gun = cmd;
				players = getplayers();
				if(players.size >= 1)
				{
					players[0] thread zombie_devgui_weapon_give(level.zombie_devgui_gun);
				}
				setdvar("", "");
			}
			wait(0.1);
			cmd = getdvarstring("");
			if(isdefined(cmd) && cmd.size > 0)
			{
				level.zombie_devgui_gun = cmd;
				players = getplayers();
				if(players.size >= 2)
				{
					players[1] thread zombie_devgui_weapon_give(level.zombie_devgui_gun);
				}
				setdvar("", "");
			}
			wait(0.1);
			cmd = getdvarstring("");
			if(isdefined(cmd) && cmd.size > 0)
			{
				level.zombie_devgui_gun = cmd;
				players = getplayers();
				if(players.size >= 3)
				{
					players[2] thread zombie_devgui_weapon_give(level.zombie_devgui_gun);
				}
				setdvar("", "");
			}
			wait(0.1);
			cmd = getdvarstring("");
			if(isdefined(cmd) && cmd.size > 0)
			{
				level.zombie_devgui_gun = cmd;
				players = getplayers();
				if(players.size >= 4)
				{
					players[3] thread zombie_devgui_weapon_give(level.zombie_devgui_gun);
				}
				setdvar("", "");
			}
		}
	#/
}

/*
	Name: zombie_weapon_devgui_think
	Namespace: zm_devgui
	Checksum: 0x22C61E2A
	Offset: 0x2580
	Size: 0x1A0
	Parameters: 0
	Flags: Linked
*/
function zombie_weapon_devgui_think()
{
	/#
		level.zombie_devgui_gun = getdvarstring("");
		level.zombie_devgui_att = getdvarstring("");
		for(;;)
		{
			wait(0.25);
			cmd = getdvarstring("");
			if(isdefined(cmd) && cmd.size > 0)
			{
				level.zombie_devgui_gun = cmd;
				array::thread_all(getplayers(), &zombie_devgui_weapon_give, level.zombie_devgui_gun);
				setdvar("", "");
			}
			wait(0.25);
			att = getdvarstring("");
			if(isdefined(att) && att.size > 0)
			{
				level.zombie_devgui_att = att;
				array::thread_all(getplayers(), &zombie_devgui_attachment_give, level.zombie_devgui_att);
				setdvar("", "");
			}
		}
	#/
}

/*
	Name: zombie_devgui_weapon_give
	Namespace: zm_devgui
	Checksum: 0xB9D8DA6D
	Offset: 0x2728
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_weapon_give(weapon_name)
{
	/#
		weapon = getweapon(weapon_name);
		self zm_weapons::weapon_give(weapon, zm_weapons::is_weapon_upgraded(weapon), 0);
	#/
}

/*
	Name: zombie_devgui_attachment_give
	Namespace: zm_devgui
	Checksum: 0x7EF518A7
	Offset: 0x2798
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_attachment_give(attachment)
{
	/#
		weapon = self getcurrentweapon();
		weapon = getweapon(weapon.rootweapon.name, attachment);
		self zm_weapons::weapon_give(weapon, zm_weapons::is_weapon_upgraded(weapon), 0);
	#/
}

/*
	Name: devgui_add_ability
	Namespace: zm_devgui
	Checksum: 0x48BBE3E2
	Offset: 0x2838
	Size: 0x164
	Parameters: 5
	Flags: Linked
*/
function devgui_add_ability(name, upgrade_active_func, stat_name, stat_desired_value, game_end_reset_if_not_achieved)
{
	/#
		online_game = sessionmodeisonlinegame();
		if(!online_game)
		{
			return;
		}
		if(!(isdefined(level.devgui_watch_abilities) && level.devgui_watch_abilities))
		{
			cmd = "";
			adddebugcommand(cmd);
			cmd = "";
			adddebugcommand(cmd);
			level thread zombie_ability_devgui_think();
			level.devgui_watch_abilities = 1;
		}
		cmd = ((("" + name) + "") + name) + "";
		adddebugcommand(cmd);
		cmd = ((("" + name) + "") + name) + "";
		adddebugcommand(cmd);
	#/
}

/*
	Name: zombie_devgui_ability_give
	Namespace: zm_devgui
	Checksum: 0x2F6F8013
	Offset: 0x29A8
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_ability_give(name)
{
	/#
		pers_upgrade = level.pers_upgrades[name];
		if(isdefined(pers_upgrade))
		{
			for(i = 0; i < pers_upgrade.stat_names.size; i++)
			{
				stat_name = pers_upgrade.stat_names[i];
				stat_value = pers_upgrade.stat_desired_values[i];
				self zm_stats::set_global_stat(stat_name, stat_value);
				self.pers_upgrade_force_test = 1;
			}
		}
	#/
}

/*
	Name: zombie_devgui_ability_take
	Namespace: zm_devgui
	Checksum: 0xE2044081
	Offset: 0x2A88
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_ability_take(name)
{
	/#
		pers_upgrade = level.pers_upgrades[name];
		if(isdefined(pers_upgrade))
		{
			for(i = 0; i < pers_upgrade.stat_names.size; i++)
			{
				stat_name = pers_upgrade.stat_names[i];
				stat_value = 0;
				self zm_stats::set_global_stat(stat_name, stat_value);
				self.pers_upgrade_force_test = 1;
			}
		}
	#/
}

/*
	Name: zombie_ability_devgui_think
	Namespace: zm_devgui
	Checksum: 0xB96A3E57
	Offset: 0x2B58
	Size: 0x1C8
	Parameters: 0
	Flags: Linked
*/
function zombie_ability_devgui_think()
{
	/#
		level.zombie_devgui_give_ability = getdvarstring("");
		level.zombie_devgui_take_ability = getdvarstring("");
		for(;;)
		{
			wait(0.25);
			cmd = getdvarstring("");
			if(!isdefined(level.zombie_devgui_give_ability) || level.zombie_devgui_give_ability != cmd)
			{
				if(cmd == "")
				{
					level flag::set("");
				}
				else
				{
					if(cmd == "")
					{
						level flag::clear("");
					}
					else
					{
						level.zombie_devgui_give_ability = cmd;
						array::thread_all(getplayers(), &zombie_devgui_ability_give, level.zombie_devgui_give_ability);
					}
				}
			}
			wait(0.25);
			cmd = getdvarstring("");
			if(!isdefined(level.zombie_devgui_take_ability) || level.zombie_devgui_take_ability != cmd)
			{
				level.zombie_devgui_take_ability = cmd;
				array::thread_all(getplayers(), &zombie_devgui_ability_take, level.zombie_devgui_take_ability);
			}
		}
	#/
}

/*
	Name: zombie_healthbar
	Namespace: zm_devgui
	Checksum: 0x2EBCC66C
	Offset: 0x2D28
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function zombie_healthbar(pos, dsquared)
{
	/#
		if(distancesquared(pos, self.origin) > dsquared)
		{
			return;
		}
		rate = 1;
		if(isdefined(self.maxhealth))
		{
			rate = self.health / self.maxhealth;
		}
		color = (1 - rate, rate, 0);
		text = "" + int(self.health);
		print3d(self.origin + (0, 0, 0), text, color, 1, 0.5, 1);
	#/
}

/*
	Name: devgui_zombie_healthbar
	Namespace: zm_devgui
	Checksum: 0xD6449724
	Offset: 0x2E30
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function devgui_zombie_healthbar()
{
	/#
		while(true)
		{
			if(getdvarint("") == 1)
			{
				lp = getplayers()[0];
				zombies = getaispeciesarray("", "");
				if(isdefined(zombies))
				{
					foreach(zombie in zombies)
					{
						zombie zombie_healthbar(lp.origin, 360000);
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: zombie_devgui_watch_input
	Namespace: zm_devgui
	Checksum: 0x6A616DA9
	Offset: 0x2F70
	Size: 0x8E
	Parameters: 0
	Flags: None
*/
function zombie_devgui_watch_input()
{
	/#
		level flag::wait_till("");
		wait(1);
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			players[i] thread watch_debug_input();
		}
	#/
}

/*
	Name: damage_player
	Namespace: zm_devgui
	Checksum: 0x1E1E5523
	Offset: 0x3008
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function damage_player()
{
	/#
		self disableinvulnerability();
		self dodamage(self.health / 2, self.origin);
	#/
}

/*
	Name: kill_player
	Namespace: zm_devgui
	Checksum: 0xDEA01D12
	Offset: 0x3058
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function kill_player()
{
	/#
		self disableinvulnerability();
		death_from = (randomfloatrange(-20, 20), randomfloatrange(-20, 20), randomfloatrange(-20, 20));
		self dodamage(self.health + 666, self.origin + death_from);
	#/
}

/*
	Name: force_drink
	Namespace: zm_devgui
	Checksum: 0x750309FF
	Offset: 0x3100
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function force_drink()
{
	/#
		wait(0.01);
		lean = self allowlean(0);
		ads = self allowads(0);
		sprint = self allowsprint(0);
		crouch = self allowcrouch(1);
		prone = self allowprone(0);
		melee = self allowmelee(0);
		self zm_utility::increment_is_drinking();
		orgweapon = self getcurrentweapon();
		build_weapon = getweapon("");
		self giveweapon(build_weapon);
		self switchtoweapon(build_weapon);
		self.build_time = self.usetime;
		self.build_start_time = gettime();
		wait(2);
		self zm_weapons::switch_back_primary_weapon(orgweapon);
		self takeweapon(build_weapon);
		if(isdefined(self.is_drinking) && self.is_drinking)
		{
			self zm_utility::decrement_is_drinking();
		}
		self allowlean(lean);
		self allowads(ads);
		self allowsprint(sprint);
		self allowprone(prone);
		self allowcrouch(crouch);
		self allowmelee(melee);
	#/
}

/*
	Name: zombie_devgui_dpad_none
	Namespace: zm_devgui
	Checksum: 0x934A27F1
	Offset: 0x3380
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_dpad_none()
{
	/#
		self thread watch_debug_input();
	#/
}

/*
	Name: zombie_devgui_dpad_death
	Namespace: zm_devgui
	Checksum: 0x157772C6
	Offset: 0x33A8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_dpad_death()
{
	/#
		self thread watch_debug_input(&kill_player);
	#/
}

/*
	Name: zombie_devgui_dpad_damage
	Namespace: zm_devgui
	Checksum: 0xFBDE5089
	Offset: 0x33E0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_dpad_damage()
{
	/#
		self thread watch_debug_input(&damage_player);
	#/
}

/*
	Name: zombie_devgui_dpad_changeweapon
	Namespace: zm_devgui
	Checksum: 0xDF9F2BC2
	Offset: 0x3418
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_dpad_changeweapon()
{
	/#
		self thread watch_debug_input(&force_drink);
	#/
}

/*
	Name: watch_debug_input
	Namespace: zm_devgui
	Checksum: 0x3F9F83DD
	Offset: 0x3450
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function watch_debug_input(callback)
{
	/#
		self endon(#"disconnect");
		self notify(#"watch_debug_input");
		self endon(#"watch_debug_input");
		level.devgui_dpad_watch = 0;
		if(isdefined(callback))
		{
			level.devgui_dpad_watch = 1;
			for(;;)
			{
				if(self actionslottwobuttonpressed())
				{
					self thread [[callback]]();
					while(self actionslottwobuttonpressed())
					{
						wait(0.05);
					}
				}
				wait(0.05);
			}
		}
	#/
}

/*
	Name: zombie_devgui_think
	Namespace: zm_devgui
	Checksum: 0x6FD74E0
	Offset: 0x3508
	Size: 0x2220
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_think()
{
	/#
		level notify(#"zombie_devgui_think");
		level endon(#"zombie_devgui_think");
		for(;;)
		{
			cmd = getdvarstring("");
			switch(cmd)
			{
				case "":
				{
					players = getplayers();
					array::thread_all(players, &zombie_devgui_give_money);
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_give_money();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_give_money();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_give_money();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_give_money();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					array::thread_all(players, &zombie_devgui_take_money);
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_take_money();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_take_money();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_take_money();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_take_money();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_give_xp(1000);
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_give_xp(1000);
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_give_xp(1000);
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_give_xp(1000);
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_give_xp(10000);
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_give_xp(10000);
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_give_xp(10000);
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_give_xp(10000);
					}
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_give_health);
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_give_health();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_give_health();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_give_health();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_give_health();
					}
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_low_health);
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_low_health();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_low_health();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_low_health();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_low_health();
					}
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_toggle_ammo);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_toggle_ignore);
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_toggle_ignore();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_toggle_ignore();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_toggle_ignore();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_toggle_ignore();
					}
					break;
				}
				case "":
				{
					zombie_devgui_invulnerable(undefined, 1);
					break;
				}
				case "":
				{
					zombie_devgui_invulnerable(undefined, 0);
					break;
				}
				case "":
				{
					zombie_devgui_invulnerable(0, 1);
					break;
				}
				case "":
				{
					zombie_devgui_invulnerable(0, 0);
					break;
				}
				case "":
				{
					zombie_devgui_invulnerable(1, 1);
					break;
				}
				case "":
				{
					zombie_devgui_invulnerable(1, 0);
					break;
				}
				case "":
				{
					zombie_devgui_invulnerable(2, 1);
					break;
				}
				case "":
				{
					zombie_devgui_invulnerable(2, 0);
					break;
				}
				case "":
				{
					zombie_devgui_invulnerable(3, 1);
					break;
				}
				case "":
				{
					zombie_devgui_invulnerable(3, 0);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_revive);
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_revive();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_revive();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_revive();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_revive();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 1)
					{
						players[0] thread zombie_devgui_kill();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 2)
					{
						players[1] thread zombie_devgui_kill();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 3)
					{
						players[2] thread zombie_devgui_kill();
					}
					break;
				}
				case "":
				{
					players = getplayers();
					if(players.size >= 4)
					{
						players[3] thread zombie_devgui_kill();
					}
					break;
				}
				case "":
				{
					player = util::gethostplayer();
					team = player.team;
					devgui_bot_spawn(team);
					break;
				}
				case "":
				{
					level.solo_lives_given = 0;
				}
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				{
					zombie_devgui_give_perk(cmd);
					break;
				}
				case "":
				{
					function_af69dfbe(cmd);
					break;
				}
				case "":
				{
					function_3df1388a(cmd);
					break;
				}
				case "":
				{
					function_f976401d(cmd);
					break;
				}
				case "":
				{
					function_a888b17c(cmd);
					break;
				}
				case "":
				{
					function_7743668b(cmd);
					break;
				}
				case "":
				{
					function_7d8af9ea(cmd);
					break;
				}
				case "":
				{
					function_7d8af9ea(cmd);
					break;
				}
				case "":
				{
					zombie_devgui_take_perks(cmd);
					break;
				}
				case "":
				{
					zombie_devgui_turn_player();
					break;
				}
				case "":
				{
					zombie_devgui_turn_player(0);
					break;
				}
				case "":
				{
					zombie_devgui_turn_player(1);
					break;
				}
				case "":
				{
					zombie_devgui_turn_player(2);
					break;
				}
				case "":
				{
					zombie_devgui_turn_player(3);
					break;
				}
				case "":
				{
					zombie_devgui_debug_pers(0);
					break;
				}
				case "":
				{
					zombie_devgui_debug_pers(1);
					break;
				}
				case "":
				{
					zombie_devgui_debug_pers(2);
					break;
				}
				case "":
				{
					zombie_devgui_debug_pers(3);
					break;
				}
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				{
					zombie_devgui_give_powerup(cmd, 1);
					break;
				}
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				case "":
				{
					zombie_devgui_give_powerup(getsubstr(cmd, 5), 0);
					break;
				}
				case "":
				{
					zombie_devgui_goto_round(getdvarint(""));
					break;
				}
				case "":
				{
					zombie_devgui_goto_round(level.round_number + 1);
					break;
				}
				case "":
				{
					zombie_devgui_goto_round(level.round_number - 1);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &function_4619dfa7);
					break;
				}
				case "":
				{
					if(isdefined(level.chest_accessed))
					{
						level notify(#"devgui_chest_end_monitor");
						level.chest_accessed = 100;
					}
					break;
				}
				case "":
				{
					if(isdefined(level.chest_accessed))
					{
						level thread zombie_devgui_chest_never_move();
					}
					break;
				}
				case "":
				{
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_preserve_turbines);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_equipment_stays_healthy);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_disown_equipment);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_give_placeable_mine, getweapon(""));
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_give_placeable_mine, getweapon(""));
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_give_frags);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_give_sticky);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_give_monkey);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_give_bhb);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_give_qed);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_give_dolls);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_give_emp_bomb);
					break;
				}
				case "":
				{
					zombie_devgui_dog_round(getdvarint(""));
					break;
				}
				case "":
				{
					zombie_devgui_dog_round_skip();
					break;
				}
				case "":
				{
					zombie_devgui_dump_zombie_vars();
					break;
				}
				case "":
				{
					zombie_devgui_pack_current_weapon();
					break;
				}
				case "":
				{
					function_9e5bfd9d();
					break;
				}
				case "":
				{
					function_435ea700();
					break;
				}
				case "":
				{
					function_525facc6();
					break;
				}
				case "":
				{
					function_935f6cc2();
					break;
				}
				case "":
				{
					zombie_devgui_repack_current_weapon();
					break;
				}
				case "":
				{
					zombie_devgui_unpack_current_weapon();
					break;
				}
				case "":
				{
					function_2306f73c();
					break;
				}
				case "":
				{
					function_5da1c3cd();
					break;
				}
				case "":
				{
					function_6afc4c2f();
					break;
				}
				case "":
				{
					function_9b4ea903();
					break;
				}
				case "":
				{
					function_4d2e8278();
					break;
				}
				case "":
				{
					function_ce561484();
					break;
				}
				case "":
				{
					zombie_devgui_reopt_current_weapon();
					break;
				}
				case "":
				{
					zombie_devgui_take_weapons(1);
					break;
				}
				case "":
				{
					zombie_devgui_take_weapons(0);
					break;
				}
				case "":
				{
					zombie_devgui_take_weapon();
					break;
				}
				case "":
				{
					level flag::set("");
					level clientfield::set("", 0);
					power_trigs = getentarray("", "");
					foreach(trig in power_trigs)
					{
						if(isdefined(trig.script_int))
						{
							level flag::set("" + trig.script_int);
							level clientfield::set("", trig.script_int);
						}
					}
					break;
				}
				case "":
				{
					level flag::clear("");
					level clientfield::set("", 0);
					power_trigs = getentarray("", "");
					foreach(trig in power_trigs)
					{
						if(isdefined(trig.script_int))
						{
							level flag::clear("" + trig.script_int);
							level clientfield::set("", trig.script_int);
						}
					}
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_dpad_none);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_dpad_damage);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_dpad_death);
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &zombie_devgui_dpad_changeweapon);
					break;
				}
				case "":
				{
					zombie_devgui_director_easy();
					break;
				}
				case "":
				{
					zombie_devgui_open_sesame();
					break;
				}
				case "":
				{
					zombie_devgui_allow_fog();
					break;
				}
				case "":
				{
					zombie_devgui_disable_kill_thread_toggle();
					break;
				}
				case "":
				{
					zombie_devgui_check_kill_thread_every_frame_toggle();
					break;
				}
				case "":
				{
					zombie_devgui_kill_thread_test_mode_toggle();
					break;
				}
				case "":
				{
					level notify(#"zombie_failsafe_debug_flush", isdefined(level.zombie_weapons[getweapon(getdvarstring(""))]));
					break;
				}
				case "":
				{
					level thread rat::derriesezombiespawnnavmeshtest(0, 0);
					break;
				}
				case "":
				{
					devgui_zombie_spawn();
					break;
				}
				case "":
				{
					devgui_all_spawn();
					break;
				}
				case "":
				{
					devgui_make_crawler();
					break;
				}
				case "":
				{
					devgui_toggle_show_spawn_locations();
					break;
				}
				case "":
				{
					devgui_toggle_show_exterior_goals();
					break;
				}
				case "":
				{
					zombie_devgui_draw_traversals();
					break;
				}
				case "":
				{
					function_364ed1b9();
					break;
				}
				case "":
				{
					array::thread_all(getplayers(), &devgui_debug_hud);
					break;
				}
				case "":
				{
					zombie_devgui_keyline_always();
					break;
				}
				case "":
				{
					function_13d8ea87();
					break;
				}
				case "":
				{
					thread function_1acc8e35();
					break;
				}
				case "":
				{
					function_eec2d58b();
					break;
				}
				case "":
				{
					break;
				}
				default:
				{
					if(isdefined(level.custom_devgui))
					{
						if(isarray(level.custom_devgui))
						{
							foreach(devgui in level.custom_devgui)
							{
								b_result = [[devgui]](cmd);
								if(isdefined(b_result) && b_result)
								{
									break;
								}
							}
						}
						else
						{
							[[level.custom_devgui]](cmd);
						}
					}
					break;
				}
			}
			setdvar("", "");
			wait(0.5);
		}
	#/
}

/*
	Name: add_custom_devgui_callback
	Namespace: zm_devgui
	Checksum: 0x8076BAF9
	Offset: 0x5730
	Size: 0x13A
	Parameters: 1
	Flags: Linked
*/
function add_custom_devgui_callback(callback)
{
	/#
		if(isdefined(level.custom_devgui))
		{
			if(!isarray(level.custom_devgui))
			{
				cdgui = level.custom_devgui;
				level.custom_devgui = [];
				if(!isdefined(level.custom_devgui))
				{
					level.custom_devgui = [];
				}
				else if(!isarray(level.custom_devgui))
				{
					level.custom_devgui = array(level.custom_devgui);
				}
				level.custom_devgui[level.custom_devgui.size] = cdgui;
			}
		}
		else
		{
			level.custom_devgui = [];
		}
		if(!isdefined(level.custom_devgui))
		{
			level.custom_devgui = [];
		}
		else if(!isarray(level.custom_devgui))
		{
			level.custom_devgui = array(level.custom_devgui);
		}
		level.custom_devgui[level.custom_devgui.size] = callback;
	#/
}

/*
	Name: devgui_all_spawn
	Namespace: zm_devgui
	Checksum: 0x833924A5
	Offset: 0x5878
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function devgui_all_spawn()
{
	/#
		player = util::gethostplayer();
		devgui_bot_spawn(player.team);
		wait(0.1);
		devgui_bot_spawn(player.team);
		wait(0.1);
		devgui_bot_spawn(player.team);
		wait(0.1);
		zombie_devgui_goto_round(8);
	#/
}

/*
	Name: devgui_toggle_show_spawn_locations
	Namespace: zm_devgui
	Checksum: 0xDDEFFC9
	Offset: 0x5938
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function devgui_toggle_show_spawn_locations()
{
	/#
		if(!isdefined(level.toggle_show_spawn_locations))
		{
			level.toggle_show_spawn_locations = 1;
		}
		else
		{
			level.toggle_show_spawn_locations = !level.toggle_show_spawn_locations;
		}
	#/
}

/*
	Name: devgui_toggle_show_exterior_goals
	Namespace: zm_devgui
	Checksum: 0xB4EE3E52
	Offset: 0x5978
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function devgui_toggle_show_exterior_goals()
{
	/#
		if(!isdefined(level.toggle_show_exterior_goals))
		{
			level.toggle_show_exterior_goals = 1;
		}
		else
		{
			level.toggle_show_exterior_goals = !level.toggle_show_exterior_goals;
		}
	#/
}

/*
	Name: devgui_zombie_spawn
	Namespace: zm_devgui
	Checksum: 0x809796AD
	Offset: 0x59B8
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function devgui_zombie_spawn()
{
	/#
		player = getplayers()[0];
		spawnername = undefined;
		spawnername = "";
		direction = player getplayerangles();
		direction_vec = anglestoforward(direction);
		eye = player geteye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		guy = undefined;
		spawners = getentarray(spawnername, "");
		spawner = spawners[0];
		guy = zombie_utility::spawn_zombie(spawner);
		if(isdefined(guy))
		{
			guy.script_string = "";
			wait(0.5);
			guy forceteleport(trace[""], player.angles + vectorscale((0, 1, 0), 180));
		}
		return guy;
	#/
}

/*
	Name: devgui_make_crawler
	Namespace: zm_devgui
	Checksum: 0x5B569DE
	Offset: 0x5BC0
	Size: 0x1EA
	Parameters: 0
	Flags: Linked
*/
function devgui_make_crawler()
{
	/#
		zombies = zombie_utility::get_round_enemy_array();
		foreach(zombie in zombies)
		{
			gib_style = [];
			gib_style[gib_style.size] = "";
			gib_style[gib_style.size] = "";
			gib_style[gib_style.size] = "";
			gib_style = zombie_death::randomize_array(gib_style);
			zombie.a.gib_ref = gib_style[0];
			zombie.missinglegs = 1;
			zombie allowedstances("");
			zombie setphysparams(15, 0, 24);
			zombie allowpitchangle(1);
			zombie setpitchorient();
			health = zombie.health;
			health = health * 0.1;
			zombie thread zombie_death::do_gib();
		}
	#/
}

/*
	Name: devgui_bot_spawn
	Namespace: zm_devgui
	Checksum: 0xA122D596
	Offset: 0x5DB8
	Size: 0x24C
	Parameters: 1
	Flags: Linked
*/
function devgui_bot_spawn(team)
{
	/#
		player = util::gethostplayer();
		direction = player getplayerangles();
		direction_vec = anglestoforward(direction);
		eye = player geteye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		direction_vec = player.origin - trace[""];
		direction = vectortoangles(direction_vec);
		bot = addtestclient();
		if(!isdefined(bot))
		{
			println("");
			return;
		}
		bot.pers[""] = 1;
		bot.equipment_enabled = 0;
		bot demo::reset_actor_bookmark_kill_times();
		bot.team = "";
		bot._player_entnum = bot getentitynumber();
		yaw = direction[1];
		bot thread devgui_bot_spawn_think(trace[""], yaw);
	#/
}

/*
	Name: devgui_bot_spawn_think
	Namespace: zm_devgui
	Checksum: 0x146C070
	Offset: 0x6010
	Size: 0x80
	Parameters: 2
	Flags: Linked
*/
function devgui_bot_spawn_think(origin, yaw)
{
	/#
		self endon(#"disconnect");
		for(;;)
		{
			self waittill(#"spawned_player");
			self setorigin(origin);
			angles = (0, yaw, 0);
			self setplayerangles(angles);
		}
	#/
}

/*
	Name: zombie_devgui_open_sesame
	Namespace: zm_devgui
	Checksum: 0xF23439C6
	Offset: 0x6098
	Size: 0x38C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_open_sesame()
{
	/#
		setdvar("", 1);
		level flag::set("");
		level clientfield::set("", 0);
		power_trigs = getentarray("", "");
		foreach(trig in power_trigs)
		{
			if(isdefined(trig.script_int))
			{
				level flag::set("" + trig.script_int);
				level clientfield::set("", trig.script_int);
			}
		}
		players = getplayers();
		array::thread_all(players, &zombie_devgui_give_money);
		zombie_doors = getentarray("", "");
		for(i = 0; i < zombie_doors.size; i++)
		{
			zombie_doors[i] notify(#"trigger", players[0]);
			if(isdefined(zombie_doors[i].power_door_ignore_flag_wait) && zombie_doors[i].power_door_ignore_flag_wait)
			{
				zombie_doors[i] notify(#"power_on");
			}
			wait(0.05);
		}
		zombie_airlock_doors = getentarray("", "");
		for(i = 0; i < zombie_airlock_doors.size; i++)
		{
			zombie_airlock_doors[i] notify(#"trigger", players[0]);
			wait(0.05);
		}
		zombie_debris = getentarray("", "");
		for(i = 0; i < zombie_debris.size; i++)
		{
			if(isdefined(zombie_debris[i]))
			{
				zombie_debris[i] notify(#"trigger", players[0]);
			}
			wait(0.05);
		}
		level notify(#"open_sesame");
		wait(1);
		setdvar("", 0);
	#/
}

/*
	Name: any_player_in_noclip
	Namespace: zm_devgui
	Checksum: 0x948D7F16
	Offset: 0x6430
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function any_player_in_noclip()
{
	/#
		foreach(player in getplayers())
		{
			if(player isinmovemode("", ""))
			{
				return true;
			}
		}
		return false;
	#/
}

/*
	Name: diable_fog_in_noclip
	Namespace: zm_devgui
	Checksum: 0xE69E3A05
	Offset: 0x64F0
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function diable_fog_in_noclip()
{
	/#
		level.fog_disabled_in_noclip = 1;
		level endon(#"allowfoginnoclip");
		level flag::wait_till("");
		while(true)
		{
			while(!any_player_in_noclip())
			{
				wait(1);
			}
			setdvar("", "");
			setdvar("", "");
			if(isdefined(level.culldist))
			{
				setculldist(0);
			}
			while(any_player_in_noclip())
			{
				wait(1);
			}
			setdvar("", "");
			setdvar("", "");
			if(isdefined(level.culldist))
			{
				setculldist(level.culldist);
			}
		}
	#/
}

/*
	Name: zombie_devgui_allow_fog
	Namespace: zm_devgui
	Checksum: 0x9C47BC0F
	Offset: 0x6648
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_allow_fog()
{
	/#
		if(isdefined(level.fog_disabled_in_noclip) && level.fog_disabled_in_noclip)
		{
			level notify(#"allowfoginnoclip");
			level.fog_disabled_in_noclip = 0;
			setdvar("", "");
			setdvar("", "");
		}
		else
		{
			thread diable_fog_in_noclip();
		}
	#/
}

/*
	Name: zombie_devgui_give_money
	Namespace: zm_devgui
	Checksum: 0xC344FED
	Offset: 0x66E0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_give_money()
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		level.devcheater = 1;
		self zm_score::add_to_player_score(100000);
	#/
}

/*
	Name: zombie_devgui_take_money
	Namespace: zm_devgui
	Checksum: 0x9679E5F
	Offset: 0x6788
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_take_money()
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		if(self.score > 100)
		{
			self zm_score::player_reduce_points("");
		}
		else
		{
			self zm_score::player_reduce_points("");
		}
	#/
}

/*
	Name: zombie_devgui_give_xp
	Namespace: zm_devgui
	Checksum: 0x1E3E20C3
	Offset: 0x6858
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_give_xp(amount)
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		self addrankxp("", self.currentweapon, undefined, undefined, 1, amount / 50);
	#/
}

/*
	Name: zombie_devgui_turn_player
	Namespace: zm_devgui
	Checksum: 0x7DB63DC1
	Offset: 0x6918
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_turn_player(index)
{
	/#
		players = getplayers();
		if(!isdefined(index) || index >= players.size)
		{
			player = players[0];
		}
		else
		{
			player = players[index];
		}
		/#
			assert(isdefined(player));
		#/
		/#
			assert(isplayer(player));
		#/
		/#
			assert(isalive(player));
		#/
		level.devcheater = 1;
		if(player hasperk(""))
		{
			println("");
			player zm_turned::turn_to_human();
		}
		else
		{
			println("");
			player zm_turned::turn_to_zombie();
		}
	#/
}

/*
	Name: zombie_devgui_debug_pers
	Namespace: zm_devgui
	Checksum: 0x829C7890
	Offset: 0x6AA8
	Size: 0x384
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_debug_pers(index)
{
	/#
		players = getplayers();
		if(!isdefined(index) || index >= players.size)
		{
			player = players[0];
		}
		else
		{
			player = players[index];
		}
		/#
			assert(isdefined(player));
		#/
		/#
			assert(isplayer(player));
		#/
		/#
			assert(isalive(player));
		#/
		level.devcheater = 1;
		println("");
		println(("" + level.pers_upgrades_keys.size) + "");
		for(pers_upgrade_index = 0; pers_upgrade_index < level.pers_upgrades_keys.size; pers_upgrade_index++)
		{
			name = level.pers_upgrades_keys[pers_upgrade_index];
			println((pers_upgrade_index + "") + name);
			pers_upgrade = level.pers_upgrades[name];
			for(i = 0; i < pers_upgrade.stat_names.size; i++)
			{
				stat_name = pers_upgrade.stat_names[i];
				stat_desired_value = pers_upgrade.stat_desired_values[i];
				player_current_stat_value = player zm_stats::get_global_stat(stat_name);
				println((("" + i) + "") + stat_name);
				println((("" + i) + "") + stat_desired_value);
				println((("" + i) + "") + player_current_stat_value);
			}
			if(isdefined(player.pers_upgrades_awarded[name]) && player.pers_upgrades_awarded[name])
			{
				println("" + name);
				continue;
			}
			println("" + name);
		}
		println("");
	#/
}

/*
	Name: function_4619dfa7
	Namespace: zm_devgui
	Checksum: 0xEFAACBE
	Offset: 0x6E38
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function function_4619dfa7()
{
	/#
		entnum = self getentitynumber();
		chest = level.chests[level.chest_index];
		origin = chest.zbarrier.origin;
		forward = anglestoforward(chest.zbarrier.angles);
		right = anglestoright(chest.zbarrier.angles);
		var_d9191ee9 = vectortoangles(right);
		var_f2857d87 = origin - (48 * right);
		switch(entnum)
		{
			case 0:
			{
				var_f2857d87 = var_f2857d87 + (16 * right);
				break;
			}
			case 1:
			{
				var_f2857d87 = var_f2857d87 + (16 * forward);
				break;
			}
			case 2:
			{
				var_f2857d87 = var_f2857d87 - (16 * right);
				break;
			}
			case 3:
			{
				var_f2857d87 = var_f2857d87 - (16 * forward);
				break;
			}
		}
		self setorigin(var_f2857d87);
		self setplayerangles(var_d9191ee9);
	#/
}

/*
	Name: zombie_devgui_cool_jetgun
	Namespace: zm_devgui
	Checksum: 0xE50B7B5C
	Offset: 0x7018
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function zombie_devgui_cool_jetgun()
{
	/#
		if(isdefined(level.zm_devgui_jetgun_never_overheat))
		{
			self thread [[level.zm_devgui_jetgun_never_overheat]]();
		}
	#/
}

/*
	Name: zombie_devgui_preserve_turbines
	Namespace: zm_devgui
	Checksum: 0xE2AA2F6E
	Offset: 0x7048
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_preserve_turbines()
{
	/#
		self endon(#"disconnect");
		self notify(#"preserve_turbines");
		self endon(#"preserve_turbines");
		if(!(isdefined(self.preserving_turbines) && self.preserving_turbines))
		{
			self.preserving_turbines = 1;
			while(true)
			{
				self.turbine_health = 1200;
				wait(1);
			}
		}
		self.preserving_turbines = 0;
	#/
}

/*
	Name: zombie_devgui_equipment_stays_healthy
	Namespace: zm_devgui
	Checksum: 0x7C28D7FB
	Offset: 0x70C8
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_equipment_stays_healthy()
{
	/#
		self endon(#"disconnect");
		self notify(#"preserve_equipment");
		self endon(#"preserve_equipment");
		if(!(isdefined(self.preserving_equipment) && self.preserving_equipment))
		{
			self.preserving_equipment = 1;
			while(true)
			{
				self.equipment_damage = [];
				self.shielddamagetaken = 0;
				if(isdefined(level.destructible_equipment))
				{
					foreach(equip in level.destructible_equipment)
					{
						if(isdefined(equip))
						{
							equip.shielddamagetaken = 0;
							equip.damage = 0;
							equip.headchopper_kills = 0;
							equip.springpad_kills = 0;
							equip.subwoofer_kills = 0;
						}
					}
				}
				wait(0.1);
			}
		}
		self.preserving_equipment = 0;
	#/
}

/*
	Name: zombie_devgui_disown_equipment
	Namespace: zm_devgui
	Checksum: 0x633C714B
	Offset: 0x7230
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_disown_equipment()
{
	/#
		self.deployed_equipment = [];
	#/
}

/*
	Name: zombie_devgui_equipment_give
	Namespace: zm_devgui
	Checksum: 0x329E5679
	Offset: 0x7250
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_equipment_give(equipment)
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		level.devcheater = 1;
		if(zm_equipment::is_included(equipment))
		{
			self zm_equipment::buy(equipment);
		}
	#/
}

/*
	Name: zombie_devgui_give_placeable_mine
	Namespace: zm_devgui
	Checksum: 0x5E236D4E
	Offset: 0x7310
	Size: 0x13E
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_give_placeable_mine(weapon)
{
	/#
		self endon(#"disconnect");
		self notify(#"give_planted_grenade_thread");
		self endon(#"give_planted_grenade_thread");
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		level.devcheater = 1;
		if(!zm_utility::is_placeable_mine(weapon))
		{
			return;
		}
		if(isdefined(self zm_utility::get_player_placeable_mine()))
		{
			self takeweapon(self zm_utility::get_player_placeable_mine());
		}
		self thread zm_placeable_mine::setup_for_player(weapon);
		while(true)
		{
			self givemaxammo(weapon);
			wait(1);
		}
	#/
}

/*
	Name: zombie_devgui_give_claymores
	Namespace: zm_devgui
	Checksum: 0xB131C463
	Offset: 0x7458
	Size: 0x14E
	Parameters: 0
	Flags: None
*/
function zombie_devgui_give_claymores()
{
	/#
		self endon(#"disconnect");
		self notify(#"give_planted_grenade_thread");
		self endon(#"give_planted_grenade_thread");
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_placeable_mine()))
		{
			self takeweapon(self zm_utility::get_player_placeable_mine());
		}
		wpn_type = zm_placeable_mine::get_first_available();
		if(wpn_type != level.weaponnone)
		{
			self thread zm_placeable_mine::setup_for_player(wpn_type);
		}
		while(true)
		{
			self givemaxammo(wpn_type);
			wait(1);
		}
	#/
}

/*
	Name: zombie_devgui_give_lethal
	Namespace: zm_devgui
	Checksum: 0x104F9C84
	Offset: 0x75B0
	Size: 0x13E
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_give_lethal(weapon)
{
	/#
		self endon(#"disconnect");
		self notify(#"give_lethal_grenade_thread");
		self endon(#"give_lethal_grenade_thread");
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_lethal_grenade()))
		{
			self takeweapon(self zm_utility::get_player_lethal_grenade());
		}
		self giveweapon(weapon);
		self zm_utility::set_player_lethal_grenade(weapon);
		while(true)
		{
			self givemaxammo(weapon);
			wait(1);
		}
	#/
}

/*
	Name: zombie_devgui_give_frags
	Namespace: zm_devgui
	Checksum: 0x2D088871
	Offset: 0x76F8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_give_frags()
{
	/#
		zombie_devgui_give_lethal(getweapon(""));
	#/
}

/*
	Name: zombie_devgui_give_sticky
	Namespace: zm_devgui
	Checksum: 0xC317352D
	Offset: 0x7738
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_give_sticky()
{
	/#
		zombie_devgui_give_lethal(getweapon(""));
	#/
}

/*
	Name: zombie_devgui_give_monkey
	Namespace: zm_devgui
	Checksum: 0x99F040AA
	Offset: 0x7778
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_give_monkey()
{
	/#
		self endon(#"disconnect");
		self notify(#"give_tactical_grenade_thread");
		self endon(#"give_tactical_grenade_thread");
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self takeweapon(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombiemode_devgui_cymbal_monkey_give))
		{
			self [[level.zombiemode_devgui_cymbal_monkey_give]]();
			while(true)
			{
				self givemaxammo(getweapon(""));
				wait(1);
			}
		}
	#/
}

/*
	Name: zombie_devgui_give_bhb
	Namespace: zm_devgui
	Checksum: 0x3FE4DFD1
	Offset: 0x78B8
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_give_bhb()
{
	/#
		self endon(#"disconnect");
		self notify(#"give_tactical_grenade_thread");
		self endon(#"give_tactical_grenade_thread");
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self takeweapon(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombiemode_devgui_black_hole_bomb_give))
		{
			self [[level.zombiemode_devgui_black_hole_bomb_give]]();
			while(true)
			{
				self givemaxammo(level.w_black_hole_bomb);
				wait(1);
			}
		}
	#/
}

/*
	Name: zombie_devgui_give_qed
	Namespace: zm_devgui
	Checksum: 0x44978D04
	Offset: 0x79E8
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_give_qed()
{
	/#
		self endon(#"disconnect");
		self notify(#"give_tactical_grenade_thread");
		self endon(#"give_tactical_grenade_thread");
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self takeweapon(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombiemode_devgui_quantum_bomb_give))
		{
			self [[level.zombiemode_devgui_quantum_bomb_give]]();
			while(true)
			{
				self givemaxammo(level.w_quantum_bomb);
				wait(1);
			}
		}
	#/
}

/*
	Name: zombie_devgui_give_dolls
	Namespace: zm_devgui
	Checksum: 0xD7B02818
	Offset: 0x7B18
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_give_dolls()
{
	/#
		self endon(#"disconnect");
		self notify(#"give_tactical_grenade_thread");
		self endon(#"give_tactical_grenade_thread");
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self takeweapon(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombiemode_devgui_nesting_dolls_give))
		{
			self [[level.zombiemode_devgui_nesting_dolls_give]]();
			while(true)
			{
				self givemaxammo(level.w_nesting_dolls);
				wait(1);
			}
		}
	#/
}

/*
	Name: zombie_devgui_give_emp_bomb
	Namespace: zm_devgui
	Checksum: 0x168406C
	Offset: 0x7C48
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_give_emp_bomb()
{
	/#
		self endon(#"disconnect");
		self notify(#"give_tactical_grenade_thread");
		self endon(#"give_tactical_grenade_thread");
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		level.devcheater = 1;
		if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self takeweapon(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombiemode_devgui_emp_bomb_give))
		{
			self [[level.zombiemode_devgui_emp_bomb_give]]();
			while(true)
			{
				self givemaxammo(getweapon(""));
				wait(1);
			}
		}
	#/
}

/*
	Name: zombie_devgui_invulnerable
	Namespace: zm_devgui
	Checksum: 0xB2667B7F
	Offset: 0x7D88
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function zombie_devgui_invulnerable(playerindex, onoff)
{
	/#
		players = getplayers();
		if(!isdefined(playerindex))
		{
			for(i = 0; i < players.size; i++)
			{
				zombie_devgui_invulnerable(i, onoff);
			}
		}
		else if(players.size > playerindex)
		{
			if(onoff)
			{
				players[playerindex] enableinvulnerability();
			}
			else
			{
				players[playerindex] disableinvulnerability();
			}
		}
	#/
}

/*
	Name: zombie_devgui_kill
	Namespace: zm_devgui
	Checksum: 0xCAA0AC9F
	Offset: 0x7E70
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_kill()
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		self disableinvulnerability();
		death_from = (randomfloatrange(-20, 20), randomfloatrange(-20, 20), randomfloatrange(-20, 20));
		self dodamage(self.health + 666, self.origin + death_from);
	#/
}

/*
	Name: zombie_devgui_toggle_ammo
	Namespace: zm_devgui
	Checksum: 0xBE8D35A7
	Offset: 0x7F88
	Size: 0x1EE
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_toggle_ammo()
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		self notify(#"devgui_toggle_ammo");
		self endon(#"devgui_toggle_ammo");
		self.ammo4evah = !(isdefined(self.ammo4evah) && self.ammo4evah);
		while(isdefined(self) && self.ammo4evah)
		{
			if(!(isdefined(self.is_drinking) && self.is_drinking))
			{
				weapon = self getcurrentweapon();
				if(weapon != level.weaponnone)
				{
					self setweaponoverheating(0, 0);
					max = weapon.maxammo;
					if(isdefined(max))
					{
						self setweaponammostock(weapon, max);
					}
					if(isdefined(self zm_utility::get_player_tactical_grenade()))
					{
						self givemaxammo(self zm_utility::get_player_tactical_grenade());
					}
					if(isdefined(self zm_utility::get_player_lethal_grenade()))
					{
						self givemaxammo(self zm_utility::get_player_lethal_grenade());
					}
				}
			}
			wait(1);
		}
	#/
}

/*
	Name: zombie_devgui_toggle_ignore
	Namespace: zm_devgui
	Checksum: 0x15CA9588
	Offset: 0x8180
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_toggle_ignore()
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		if(!isdefined(self.var_b67d35de))
		{
			self.var_b67d35de = 0;
		}
		self.var_b67d35de = !self.var_b67d35de;
		if(self.var_b67d35de)
		{
			self zm_utility::increment_ignoreme();
		}
		else
		{
			self zm_utility::decrement_ignoreme();
		}
		if(self.ignoreme)
		{
			setdvar("", 0);
		}
	#/
}

/*
	Name: zombie_devgui_revive
	Namespace: zm_devgui
	Checksum: 0xBB822371
	Offset: 0x8288
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_revive()
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		self reviveplayer();
		self notify(#"stop_revive_trigger");
		if(isdefined(self.revivetrigger))
		{
			self.revivetrigger delete();
			self.revivetrigger = undefined;
		}
		self allowjump(1);
		self zm_laststand::set_ignoreme(0);
		self.laststand = undefined;
		self notify(#"player_revived", self);
	#/
}

/*
	Name: zombie_devgui_give_health
	Namespace: zm_devgui
	Checksum: 0xA745EF8E
	Offset: 0x83A8
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_give_health()
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		self notify(#"devgui_health");
		self endon(#"devgui_health");
		self endon(#"disconnect");
		self endon(#"death");
		level.devcheater = 1;
		while(true)
		{
			self.maxhealth = 100000;
			self.health = 100000;
			self util::waittill_any("", "", "");
			wait(2);
		}
	#/
}

/*
	Name: zombie_devgui_low_health
	Namespace: zm_devgui
	Checksum: 0xD5BF64C4
	Offset: 0x84C8
	Size: 0x10E
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_low_health()
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		/#
			assert(isalive(self));
		#/
		self notify(#"devgui_health");
		self endon(#"devgui_health");
		self endon(#"disconnect");
		self endon(#"death");
		level.devcheater = 1;
		while(true)
		{
			self.maxhealth = 10;
			self.health = 10;
			self util::waittill_any("", "", "");
			wait(2);
		}
	#/
}

/*
	Name: zombie_devgui_give_perk
	Namespace: zm_devgui
	Checksum: 0x149C56C3
	Offset: 0x85E0
	Size: 0x148
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_give_perk(perk)
{
	/#
		vending_triggers = getentarray("", "");
		level.devcheater = 1;
		if(vending_triggers.size < 1)
		{
			return;
		}
		foreach(player in getplayers())
		{
			for(i = 0; i < vending_triggers.size; i++)
			{
				if(vending_triggers[i].script_noteworthy == perk)
				{
					vending_triggers[i] notify(#"trigger", player);
					break;
				}
			}
			wait(1);
		}
	#/
}

/*
	Name: zombie_devgui_take_perks
	Namespace: zm_devgui
	Checksum: 0xD64D3F60
	Offset: 0x8730
	Size: 0x1D2
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_take_perks(cmd)
{
	/#
		vending_triggers = getentarray("", "");
		perks = [];
		for(i = 0; i < vending_triggers.size; i++)
		{
			perk = vending_triggers[i].script_noteworthy;
			if(isdefined(self.perk_purchased) && self.perk_purchased == perk)
			{
				continue;
			}
			perks[perks.size] = perk;
		}
		foreach(player in getplayers())
		{
			foreach(perk in perks)
			{
				perk_str = perk + "";
				player notify(perk_str);
			}
		}
	#/
}

/*
	Name: function_af69dfbe
	Namespace: zm_devgui
	Checksum: 0xCB69F9E6
	Offset: 0x8910
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_af69dfbe(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_3df1388a
	Namespace: zm_devgui
	Checksum: 0x704D7A31
	Offset: 0x8948
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_3df1388a(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_f976401d
	Namespace: zm_devgui
	Checksum: 0x6638E0AC
	Offset: 0x8980
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_f976401d(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_a888b17c
	Namespace: zm_devgui
	Checksum: 0xECAB6C91
	Offset: 0x89B8
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_a888b17c(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_7743668b
	Namespace: zm_devgui
	Checksum: 0x85C7891E
	Offset: 0x89F0
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_7743668b(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_7d8af9ea
	Namespace: zm_devgui
	Checksum: 0x98232765
	Offset: 0x8A28
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function function_7d8af9ea(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: function_c2cda548
	Namespace: zm_devgui
	Checksum: 0x4C5C50AF
	Offset: 0x8A60
	Size: 0x30
	Parameters: 1
	Flags: None
*/
function function_c2cda548(cmd)
{
	/#
		if(isdefined(level.perk_random_devgui_callback))
		{
			self [[level.perk_random_devgui_callback]](cmd);
		}
	#/
}

/*
	Name: zombie_devgui_give_powerup
	Namespace: zm_devgui
	Checksum: 0xBA0CE416
	Offset: 0x8A98
	Size: 0x234
	Parameters: 3
	Flags: Linked
*/
function zombie_devgui_give_powerup(powerup_name, now, origin)
{
	/#
		player = getplayers()[0];
		found = 0;
		level.devcheater = 1;
		if(isdefined(now) && !now)
		{
			for(i = 0; i < level.zombie_powerup_array.size; i++)
			{
				if(level.zombie_powerup_array[i] == powerup_name)
				{
					level.zombie_powerup_index = i;
					found = 1;
					break;
				}
			}
			if(!found)
			{
				return;
			}
			level.zombie_devgui_power = 1;
			level.zombie_vars[""] = 1;
			level.powerup_drop_count = 0;
			return;
		}
		direction = player getplayerangles();
		direction_vec = anglestoforward(direction);
		eye = player geteye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		if(isdefined(origin))
		{
			level thread zm_powerups::specific_powerup_drop(powerup_name, origin);
		}
		else
		{
			level thread zm_powerups::specific_powerup_drop(powerup_name, trace[""]);
		}
	#/
}

/*
	Name: zombie_devgui_give_powerup_player
	Namespace: zm_devgui
	Checksum: 0x309F0D12
	Offset: 0x8CD8
	Size: 0x1FC
	Parameters: 2
	Flags: Linked
*/
function zombie_devgui_give_powerup_player(powerup_name, now)
{
	/#
		player = self;
		found = 0;
		level.devcheater = 1;
		if(isdefined(now) && !now)
		{
			for(i = 0; i < level.zombie_powerup_array.size; i++)
			{
				if(level.zombie_powerup_array[i] == powerup_name)
				{
					level.zombie_powerup_index = i;
					found = 1;
					break;
				}
			}
			if(!found)
			{
				return;
			}
			level.zombie_devgui_power = 1;
			level.zombie_vars[""] = 1;
			level.powerup_drop_count = 0;
			return;
		}
		direction = player getplayerangles();
		direction_vec = anglestoforward(direction);
		eye = player geteye();
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(eye, eye + direction_vec, 0, undefined);
		level thread zm_powerups::specific_powerup_drop(powerup_name, trace[""], undefined, undefined, undefined, player);
	#/
}

/*
	Name: zombie_devgui_goto_round
	Namespace: zm_devgui
	Checksum: 0x6B0A6AA6
	Offset: 0x8EE0
	Size: 0x186
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_goto_round(target_round)
{
	/#
		player = getplayers()[0];
		if(target_round < 1)
		{
			target_round = 1;
		}
		level.devcheater = 1;
		level.zombie_total = 0;
		zombie_utility::ai_calculate_health(target_round);
		zm::set_round_number(target_round - 1);
		level notify(#"kill_round");
		wait(1);
		zombies = getaiteamarray(level.zombie_team);
		if(isdefined(zombies))
		{
			for(i = 0; i < zombies.size; i++)
			{
				if(isdefined(zombies[i].ignore_devgui_death) && zombies[i].ignore_devgui_death)
				{
					continue;
				}
				zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
			}
		}
	#/
}

/*
	Name: zombie_devgui_monkey_round
	Namespace: zm_devgui
	Checksum: 0x55BEAB9F
	Offset: 0x9070
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function zombie_devgui_monkey_round()
{
	/#
		if(isdefined(level.next_monkey_round))
		{
			zombie_devgui_goto_round(level.next_monkey_round);
		}
	#/
}

/*
	Name: zombie_devgui_thief_round
	Namespace: zm_devgui
	Checksum: 0x1E41250B
	Offset: 0x90A8
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function zombie_devgui_thief_round()
{
	/#
		if(isdefined(level.next_thief_round))
		{
			zombie_devgui_goto_round(level.next_thief_round);
		}
	#/
}

/*
	Name: zombie_devgui_dog_round
	Namespace: zm_devgui
	Checksum: 0x8DE0D88B
	Offset: 0x90E0
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_dog_round(num_dogs)
{
	/#
		if(!isdefined(level.dogs_enabled) || !level.dogs_enabled)
		{
			return;
		}
		if(!isdefined(level.dog_rounds_enabled) || !level.dog_rounds_enabled)
		{
			return;
		}
		if(!isdefined(level.enemy_dog_spawns) || level.enemy_dog_spawns.size < 1)
		{
			return;
		}
		if(!level flag::get(""))
		{
			setdvar("", num_dogs);
		}
		zombie_devgui_goto_round(level.round_number + 1);
	#/
}

/*
	Name: zombie_devgui_dog_round_skip
	Namespace: zm_devgui
	Checksum: 0x43B82AE4
	Offset: 0x91C8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_dog_round_skip()
{
	/#
		if(isdefined(level.next_dog_round))
		{
			zombie_devgui_goto_round(level.next_dog_round);
		}
	#/
}

/*
	Name: zombie_devgui_dump_zombie_vars
	Namespace: zm_devgui
	Checksum: 0x44B987D5
	Offset: 0x9200
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_dump_zombie_vars()
{
	/#
		if(!isdefined(level.zombie_vars))
		{
			return;
		}
		if(level.zombie_vars.size > 0)
		{
			println("");
		}
		else
		{
			return;
		}
		var_66026a81 = getarraykeys(level.zombie_vars);
		for(i = 0; i < level.zombie_vars.size; i++)
		{
			key = var_66026a81[i];
			println((key + "") + level.zombie_vars[key]);
		}
		println("");
	#/
}

/*
	Name: zombie_devgui_pack_current_weapon
	Namespace: zm_devgui
	Checksum: 0x82F9ACB8
	Offset: 0x9300
	Size: 0x196
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_pack_current_weapon()
{
	/#
		players = getplayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				weap = players[i] getcurrentweapon();
				weapon = get_upgrade(weap.rootweapon);
				players[i] takeweapon(weap);
				weapon = players[i] zm_weapons::give_build_kit_weapon(weapon);
				players[i] thread aat::remove(weapon);
				players[i] givestartammo(weapon);
				players[i] switchtoweapon(weapon);
			}
		}
	#/
}

/*
	Name: zombie_devgui_repack_current_weapon
	Namespace: zm_devgui
	Checksum: 0x7F17B085
	Offset: 0x94A0
	Size: 0x10E
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_repack_current_weapon()
{
	/#
		players = getplayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				weap = players[i] getcurrentweapon();
				if(isdefined(level.aat_in_use) && level.aat_in_use && zm_weapons::weapon_supports_aat(weap))
				{
					players[i] thread aat::acquire(weap);
				}
			}
		}
	#/
}

/*
	Name: zombie_devgui_unpack_current_weapon
	Namespace: zm_devgui
	Checksum: 0x17D3CF37
	Offset: 0x95B8
	Size: 0x16E
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_unpack_current_weapon()
{
	/#
		players = getplayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				weap = players[i] getcurrentweapon();
				weapon = zm_weapons::get_base_weapon(weap);
				players[i] takeweapon(weap);
				weapon = players[i] zm_weapons::give_build_kit_weapon(weapon);
				players[i] givestartammo(weapon);
				players[i] switchtoweapon(weapon);
			}
		}
	#/
}

/*
	Name: function_3ec0de8d
	Namespace: zm_devgui
	Checksum: 0xB4FD818F
	Offset: 0x9730
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function function_3ec0de8d(itemindex, xp)
{
	/#
		if(!itemindex || !level.onlinegame)
		{
			return;
		}
		if(0 > xp)
		{
			xp = 0;
		}
		self setdstat("", itemindex, "", xp);
	#/
}

/*
	Name: function_949d6013
	Namespace: zm_devgui
	Checksum: 0xE3D71C52
	Offset: 0x97B0
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_949d6013(weapon)
{
	/#
		var_1121268 = [];
		table = popups::devgui_notif_getgunleveltablename();
		weapon_name = weapon.rootweapon.name;
		for(i = 0; i < 15; i++)
		{
			var_d4b6b0ab = tablelookup(table, 2, weapon_name, 0, i, 1);
			if("" == var_d4b6b0ab)
			{
				break;
			}
			var_1121268[i] = int(var_d4b6b0ab);
		}
		return var_1121268;
	#/
}

/*
	Name: function_718c64af
	Namespace: zm_devgui
	Checksum: 0xC8132C5F
	Offset: 0x98B8
	Size: 0x8E
	Parameters: 2
	Flags: Linked
*/
function function_718c64af(weapon, var_2e8a2b5e)
{
	/#
		xp = 0;
		var_1121268 = function_949d6013(weapon);
		if(var_1121268.size)
		{
			xp = var_1121268[var_1121268.size - 1];
			if(var_2e8a2b5e < var_1121268.size)
			{
				xp = var_1121268[var_2e8a2b5e];
			}
		}
		return xp;
	#/
}

/*
	Name: function_e9906f08
	Namespace: zm_devgui
	Checksum: 0x1B99EC5C
	Offset: 0x9950
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function function_e9906f08(weapon)
{
	/#
		xp = 0;
		var_1121268 = function_949d6013(weapon);
		if(var_1121268.size)
		{
			xp = var_1121268[var_1121268.size - 1];
		}
		return xp;
	#/
}

/*
	Name: function_2306f73c
	Namespace: zm_devgui
	Checksum: 0x6908CF36
	Offset: 0x99C0
	Size: 0x13E
	Parameters: 0
	Flags: Linked
*/
function function_2306f73c()
{
	/#
		players = getplayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				weapon = player getcurrentweapon();
				itemindex = getbaseweaponitemindex(weapon);
				var_2e8a2b5e = player getcurrentgunrank(itemindex);
				xp = function_718c64af(weapon, var_2e8a2b5e);
				player function_3ec0de8d(itemindex, xp);
			}
		}
	#/
}

/*
	Name: function_5da1c3cd
	Namespace: zm_devgui
	Checksum: 0x48447650
	Offset: 0x9B08
	Size: 0x146
	Parameters: 0
	Flags: Linked
*/
function function_5da1c3cd()
{
	/#
		players = getplayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				weapon = player getcurrentweapon();
				itemindex = getbaseweaponitemindex(weapon);
				var_2e8a2b5e = player getcurrentgunrank(itemindex);
				xp = function_718c64af(weapon, var_2e8a2b5e);
				player function_3ec0de8d(itemindex, xp - 50);
			}
		}
	#/
}

/*
	Name: function_6afc4c2f
	Namespace: zm_devgui
	Checksum: 0x5C269215
	Offset: 0x9C58
	Size: 0x10E
	Parameters: 0
	Flags: Linked
*/
function function_6afc4c2f()
{
	/#
		players = getplayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				weapon = player getcurrentweapon();
				itemindex = getbaseweaponitemindex(weapon);
				xp = function_e9906f08(weapon);
				player function_3ec0de8d(itemindex, xp);
			}
		}
	#/
}

/*
	Name: function_9b4ea903
	Namespace: zm_devgui
	Checksum: 0xA2F66BF6
	Offset: 0x9D70
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function function_9b4ea903()
{
	/#
		players = getplayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				weapon = player getcurrentweapon();
				itemindex = getbaseweaponitemindex(weapon);
				player function_3ec0de8d(itemindex, 0);
			}
		}
	#/
}

/*
	Name: function_4d2e8278
	Namespace: zm_devgui
	Checksum: 0x98BD74CD
	Offset: 0x9E68
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function function_4d2e8278()
{
	/#
		players = getplayers();
		level.devcheater = 1;
		a_weapons = enumerateweapons("");
		for(weapon_index = 0; weapon_index < a_weapons.size; weapon_index++)
		{
			weapon = a_weapons[weapon_index];
			itemindex = getbaseweaponitemindex(weapon);
			if(!itemindex)
			{
				continue;
			}
			xp = function_e9906f08(weapon);
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				if(!player laststand::player_is_in_laststand())
				{
					player function_3ec0de8d(itemindex, xp);
				}
			}
		}
	#/
}

/*
	Name: function_ce561484
	Namespace: zm_devgui
	Checksum: 0x2550312C
	Offset: 0x9FD0
	Size: 0x140
	Parameters: 0
	Flags: Linked
*/
function function_ce561484()
{
	/#
		players = getplayers();
		level.devcheater = 1;
		a_weapons = enumerateweapons("");
		for(weapon_index = 0; weapon_index < a_weapons.size; weapon_index++)
		{
			weapon = a_weapons[weapon_index];
			itemindex = getbaseweaponitemindex(weapon);
			if(!itemindex)
			{
				continue;
			}
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				if(!player laststand::player_is_in_laststand())
				{
					player function_3ec0de8d(itemindex, 0);
				}
			}
		}
	#/
}

/*
	Name: function_be6b95c4
	Namespace: zm_devgui
	Checksum: 0xF89A404A
	Offset: 0xA118
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function function_be6b95c4(xp)
{
	/#
		if(self.pers[""] > xp)
		{
			self.pers[""] = 0;
			self setrank(0);
			self setdstat("", "", "", 0);
		}
		self.pers[""] = xp;
		self rank::syncxpstat();
		self rank::updaterank();
		self setdstat("", "", "", self.pers[""]);
	#/
}

/*
	Name: function_1a6e88f7
	Namespace: zm_devgui
	Checksum: 0x43D61E30
	Offset: 0xA228
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function function_1a6e88f7(var_2e8a2b5e)
{
	/#
		return int(level.ranktable[var_2e8a2b5e][7]);
	#/
}

/*
	Name: function_b207ef2e
	Namespace: zm_devgui
	Checksum: 0x8A6A9550
	Offset: 0xA268
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_b207ef2e()
{
	/#
		xp = 0;
		xp = function_1a6e88f7(level.ranktable.size - 1);
		return xp;
	#/
}

/*
	Name: function_9e5bfd9d
	Namespace: zm_devgui
	Checksum: 0x2231105C
	Offset: 0xA2B8
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function function_9e5bfd9d()
{
	/#
		players = getplayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				var_2e8a2b5e = player rank::getrank();
				xp = function_1a6e88f7(var_2e8a2b5e);
				player function_be6b95c4(xp);
			}
		}
	#/
}

/*
	Name: function_435ea700
	Namespace: zm_devgui
	Checksum: 0xE743155F
	Offset: 0xA3B0
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function function_435ea700()
{
	/#
		players = getplayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				var_2e8a2b5e = player rank::getrank();
				xp = function_1a6e88f7(var_2e8a2b5e);
				player function_be6b95c4(xp - 50);
			}
		}
	#/
}

/*
	Name: function_525facc6
	Namespace: zm_devgui
	Checksum: 0x50878941
	Offset: 0xA4B0
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function function_525facc6()
{
	/#
		players = getplayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				xp = function_b207ef2e();
				player function_be6b95c4(xp);
			}
		}
	#/
}

/*
	Name: function_935f6cc2
	Namespace: zm_devgui
	Checksum: 0xBA7EF207
	Offset: 0xA588
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function function_935f6cc2()
{
	/#
		players = getplayers();
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!player laststand::player_is_in_laststand())
			{
				player function_be6b95c4(0);
			}
		}
	#/
}

/*
	Name: zombie_devgui_reopt_current_weapon
	Namespace: zm_devgui
	Checksum: 0x16A4B86F
	Offset: 0xA638
	Size: 0x17E
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_reopt_current_weapon()
{
	/#
		players = getplayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				weapon = players[i] getcurrentweapon();
				if(isdefined(players[i].pack_a_punch_weapon_options))
				{
					players[i].pack_a_punch_weapon_options[weapon] = undefined;
				}
				players[i] takeweapon(weapon);
				weapon = players[i] zm_weapons::give_build_kit_weapon(weapon);
				players[i] givestartammo(weapon);
				players[i] switchtoweapon(weapon);
			}
		}
	#/
}

/*
	Name: zombie_devgui_take_weapon
	Namespace: zm_devgui
	Checksum: 0xEA16F241
	Offset: 0xA7C0
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_take_weapon()
{
	/#
		players = getplayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				players[i] takeweapon(players[i] getcurrentweapon());
				players[i] zm_weapons::switch_back_primary_weapon(undefined);
			}
		}
	#/
}

/*
	Name: zombie_devgui_take_weapons
	Namespace: zm_devgui
	Checksum: 0x2EE68388
	Offset: 0xA8B8
	Size: 0xE6
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_take_weapons(give_fallback)
{
	/#
		players = getplayers();
		reviver = players[0];
		level.devcheater = 1;
		for(i = 0; i < players.size; i++)
		{
			if(!players[i] laststand::player_is_in_laststand())
			{
				players[i] takeallweapons();
				if(give_fallback)
				{
					players[i] zm_weapons::give_fallback_weapon();
				}
			}
		}
	#/
}

/*
	Name: get_upgrade
	Namespace: zm_devgui
	Checksum: 0x87747146
	Offset: 0xA9A8
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function get_upgrade(weapon)
{
	/#
		if(isdefined(level.zombie_weapons[weapon]) && isdefined(level.zombie_weapons[weapon].upgrade_name))
		{
			return zm_weapons::get_upgrade_weapon(weapon, 0);
		}
		return zm_weapons::get_upgrade_weapon(weapon, 1);
	#/
}

/*
	Name: zombie_devgui_director_easy
	Namespace: zm_devgui
	Checksum: 0x70CE405D
	Offset: 0xAA30
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_director_easy()
{
	/#
		if(isdefined(level.director_devgui_health))
		{
			[[level.director_devgui_health]]();
		}
	#/
}

/*
	Name: zombie_devgui_chest_never_move
	Namespace: zm_devgui
	Checksum: 0xDECE5EDC
	Offset: 0xAA60
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_chest_never_move()
{
	/#
		level notify(#"devgui_chest_end_monitor");
		level endon(#"devgui_chest_end_monitor");
		for(;;)
		{
			level.chest_accessed = 0;
			wait(5);
		}
	#/
}

/*
	Name: zombie_devgui_disable_kill_thread_toggle
	Namespace: zm_devgui
	Checksum: 0x7E716BAC
	Offset: 0xAAA0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_disable_kill_thread_toggle()
{
	/#
		if(!(isdefined(level.disable_kill_thread) && level.disable_kill_thread))
		{
			level.disable_kill_thread = 1;
		}
		else
		{
			level.disable_kill_thread = 0;
		}
	#/
}

/*
	Name: zombie_devgui_check_kill_thread_every_frame_toggle
	Namespace: zm_devgui
	Checksum: 0x4A9C1E0F
	Offset: 0xAAE8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_check_kill_thread_every_frame_toggle()
{
	/#
		if(!(isdefined(level.check_kill_thread_every_frame) && level.check_kill_thread_every_frame))
		{
			level.check_kill_thread_every_frame = 1;
		}
		else
		{
			level.check_kill_thread_every_frame = 0;
		}
	#/
}

/*
	Name: zombie_devgui_kill_thread_test_mode_toggle
	Namespace: zm_devgui
	Checksum: 0xEBDEC2D6
	Offset: 0xAB30
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_kill_thread_test_mode_toggle()
{
	/#
		if(!(isdefined(level.kill_thread_test_mode) && level.kill_thread_test_mode))
		{
			level.kill_thread_test_mode = 1;
		}
		else
		{
			level.kill_thread_test_mode = 0;
		}
	#/
}

/*
	Name: showonespawnpoint
	Namespace: zm_devgui
	Checksum: 0x25B235D5
	Offset: 0xAB78
	Size: 0x58C
	Parameters: 5
	Flags: None
*/
function showonespawnpoint(spawn_point, color, notification, height, print)
{
	/#
		if(!isdefined(height) || height <= 0)
		{
			height = util::get_player_height();
		}
		if(!isdefined(print))
		{
			print = spawn_point.classname;
		}
		center = spawn_point.origin;
		forward = anglestoforward(spawn_point.angles);
		right = anglestoright(spawn_point.angles);
		forward = vectorscale(forward, 16);
		right = vectorscale(right, 16);
		a = (center + forward) - right;
		b = (center + forward) + right;
		c = (center - forward) + right;
		d = (center - forward) - right;
		thread lineuntilnotified(a, b, color, 0, notification);
		thread lineuntilnotified(b, c, color, 0, notification);
		thread lineuntilnotified(c, d, color, 0, notification);
		thread lineuntilnotified(d, a, color, 0, notification);
		thread lineuntilnotified(a, a + (0, 0, height), color, 0, notification);
		thread lineuntilnotified(b, b + (0, 0, height), color, 0, notification);
		thread lineuntilnotified(c, c + (0, 0, height), color, 0, notification);
		thread lineuntilnotified(d, d + (0, 0, height), color, 0, notification);
		a = a + (0, 0, height);
		b = b + (0, 0, height);
		c = c + (0, 0, height);
		d = d + (0, 0, height);
		thread lineuntilnotified(a, b, color, 0, notification);
		thread lineuntilnotified(b, c, color, 0, notification);
		thread lineuntilnotified(c, d, color, 0, notification);
		thread lineuntilnotified(d, a, color, 0, notification);
		center = center + (0, 0, height / 2);
		arrow_forward = anglestoforward(spawn_point.angles);
		arrowhead_forward = anglestoforward(spawn_point.angles);
		arrowhead_right = anglestoright(spawn_point.angles);
		arrow_forward = vectorscale(arrow_forward, 32);
		arrowhead_forward = vectorscale(arrowhead_forward, 24);
		arrowhead_right = vectorscale(arrowhead_right, 8);
		a = center + arrow_forward;
		b = (center + arrowhead_forward) - arrowhead_right;
		c = (center + arrowhead_forward) + arrowhead_right;
		thread lineuntilnotified(center, a, color, 0, notification);
		thread lineuntilnotified(a, b, color, 0, notification);
		thread lineuntilnotified(a, c, color, 0, notification);
		thread print3duntilnotified(spawn_point.origin + (0, 0, height), print, color, 1, 1, notification);
	#/
}

/*
	Name: print3duntilnotified
	Namespace: zm_devgui
	Checksum: 0x6BCA5A04
	Offset: 0xB110
	Size: 0x70
	Parameters: 6
	Flags: Linked
*/
function print3duntilnotified(origin, text, color, alpha, scale, notification)
{
	/#
		level endon(notification);
		for(;;)
		{
			print3d(origin, text, color, alpha, scale);
			wait(0.05);
		}
	#/
}

/*
	Name: lineuntilnotified
	Namespace: zm_devgui
	Checksum: 0xCE6240A4
	Offset: 0xB188
	Size: 0x68
	Parameters: 5
	Flags: Linked
*/
function lineuntilnotified(start, end, color, depthtest, notification)
{
	/#
		level endon(notification);
		for(;;)
		{
			line(start, end, color, depthtest);
			wait(0.05);
		}
	#/
}

/*
	Name: devgui_debug_hud
	Namespace: zm_devgui
	Checksum: 0xADF4520D
	Offset: 0xB1F8
	Size: 0x2DC
	Parameters: 0
	Flags: Linked
*/
function devgui_debug_hud()
{
	/#
		if(isdefined(self zm_utility::get_player_lethal_grenade()))
		{
			self givemaxammo(self zm_utility::get_player_lethal_grenade());
		}
		wpn_type = zm_placeable_mine::get_first_available();
		if(wpn_type != level.weaponnone)
		{
			self thread zm_placeable_mine::setup_for_player(wpn_type);
		}
		if(isdefined(level.zombiemode_devgui_cymbal_monkey_give))
		{
			if(isdefined(self zm_utility::get_player_tactical_grenade()))
			{
				self takeweapon(self zm_utility::get_player_tactical_grenade());
			}
			self [[level.zombiemode_devgui_cymbal_monkey_give]]();
		}
		else if(isdefined(self zm_utility::get_player_tactical_grenade()))
		{
			self givemaxammo(self zm_utility::get_player_tactical_grenade());
		}
		if(isdefined(level.zombie_include_equipment) && !isdefined(self zm_equipment::get_player_equipment()))
		{
			equipment = getarraykeys(level.zombie_include_equipment);
			if(isdefined(equipment[0]))
			{
				self zombie_devgui_equipment_give(equipment[0]);
			}
		}
		for(i = 0; i < 10; i++)
		{
			zombie_devgui_give_powerup("", 1, self.origin);
			wait(0.25);
		}
		zombie_devgui_give_powerup("", 1, self.origin);
		wait(0.25);
		zombie_devgui_give_powerup("", 1, self.origin);
		wait(0.25);
		zombie_devgui_give_powerup("", 1, self.origin);
		wait(0.25);
		zombie_devgui_give_powerup("", 1, self.origin);
		wait(0.25);
		zombie_devgui_give_powerup("", 1, self.origin);
		wait(0.25);
	#/
}

/*
	Name: devgui_test_chart_think
	Namespace: zm_devgui
	Checksum: 0x515572A3
	Offset: 0xB4E0
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function devgui_test_chart_think()
{
	/#
		wait(0.05);
		old_val = getdvarint("");
		for(;;)
		{
			val = getdvarint("");
			if(old_val != val)
			{
				if(isdefined(level.test_chart_model))
				{
					level.test_chart_model delete();
					level.test_chart_model = undefined;
				}
				if(val)
				{
					player = getplayers()[0];
					direction = player getplayerangles();
					direction_vec = anglestoforward((0, direction[1], 0));
					scale = 120;
					direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
					level.test_chart_model = spawn("", player geteye() + direction_vec);
					level.test_chart_model setmodel("");
					level.test_chart_model.angles = (0, direction[1], 0) + vectorscale((0, 1, 0), 90);
				}
			}
			old_val = val;
			wait(0.05);
		}
	#/
}

/*
	Name: zombie_devgui_draw_traversals
	Namespace: zm_devgui
	Checksum: 0xC735CB95
	Offset: 0xB6F8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_draw_traversals()
{
	/#
		if(!isdefined(level.toggle_draw_traversals))
		{
			level.toggle_draw_traversals = 1;
		}
		else
		{
			level.toggle_draw_traversals = !level.toggle_draw_traversals;
		}
	#/
}

/*
	Name: zombie_devgui_keyline_always
	Namespace: zm_devgui
	Checksum: 0x6C9B94D7
	Offset: 0xB738
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function zombie_devgui_keyline_always()
{
	/#
		if(!isdefined(level.toggle_keyline_always))
		{
			level.toggle_keyline_always = 1;
		}
		else
		{
			level.toggle_keyline_always = !level.toggle_keyline_always;
		}
	#/
}

/*
	Name: function_13d8ea87
	Namespace: zm_devgui
	Checksum: 0xBA2FFA47
	Offset: 0xB778
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_13d8ea87()
{
	/#
		if(!isdefined(level.var_c2a01768))
		{
			level.var_c2a01768 = 1;
		}
		else
		{
			level.var_c2a01768 = !level.var_c2a01768;
		}
	#/
}

/*
	Name: wait_for_zombie
	Namespace: zm_devgui
	Checksum: 0x528DC1D1
	Offset: 0xB7B8
	Size: 0x2DC
	Parameters: 1
	Flags: Linked
*/
function wait_for_zombie(crawler)
{
	/#
		nodes = getallnodes();
		while(true)
		{
			ai = getactorarray();
			zombie = ai[0];
			if(isdefined(zombie))
			{
				foreach(node in nodes)
				{
					if(node.type == "" || node.type == "" || node.type == "")
					{
						if(isdefined(node.animscript))
						{
							blackboard::setblackboardattribute(zombie, "", "");
							blackboard::setblackboardattribute(zombie, "", node.animscript);
							table = istring("");
							if(isdefined(crawler) && crawler)
							{
								table = istring("");
							}
							if(isdefined(zombie.debug_traversal_ast))
							{
								table = istring(zombie.debug_traversal_ast);
							}
							anim_results = zombie astsearch(table);
							if(!isdefined(anim_results[""]))
							{
								if(isdefined(crawler) && crawler)
								{
									node.bad_crawler_traverse = 1;
								}
								else
								{
									node.bad_traverse = 1;
								}
								continue;
							}
							if(anim_results[""] == "")
							{
								teleport = 1;
							}
						}
					}
				}
				break;
			}
			wait(0.25);
		}
	#/
}

/*
	Name: zombie_draw_traversals
	Namespace: zm_devgui
	Checksum: 0xD1714B48
	Offset: 0xBAA0
	Size: 0x230
	Parameters: 0
	Flags: Linked
*/
function zombie_draw_traversals()
{
	/#
		level thread wait_for_zombie();
		level thread wait_for_zombie(1);
		nodes = getallnodes();
		while(true)
		{
			if(isdefined(level.toggle_draw_traversals) && level.toggle_draw_traversals)
			{
				foreach(node in nodes)
				{
					if(isdefined(node.animscript))
					{
						txt_color = (0, 0.8, 0.6);
						circle_color = (1, 1, 1);
						if(isdefined(node.bad_traverse) && node.bad_traverse)
						{
							txt_color = (1, 0, 0);
							circle_color = (1, 0, 0);
						}
						circle(node.origin, 16, circle_color);
						print3d(node.origin, node.animscript, txt_color, 1, 0.5);
						if(isdefined(node.bad_crawler_traverse) && node.bad_crawler_traverse)
						{
							print3d(node.origin + (vectorscale((0, 0, -1), 12)), "", (1, 0, 0), 1, 0.5);
						}
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_364ed1b9
	Namespace: zm_devgui
	Checksum: 0x362AA267
	Offset: 0xBCD8
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function function_364ed1b9()
{
	/#
		nodes = getallnodes();
		var_242e809d = [];
		foreach(node in nodes)
		{
			if(isdefined(node.animscript) && node.animscript != "")
			{
				var_242e809d[node.animscript] = 1;
			}
		}
		var_d1e1ebcf = getarraykeys(var_242e809d);
		var_bbd3b866 = array::sort_by_value(var_d1e1ebcf, 1);
		println("");
		foreach(name in var_bbd3b866)
		{
			println("" + name);
		}
		println("");
	#/
}

/*
	Name: function_1d21f4f
	Namespace: zm_devgui
	Checksum: 0x6D5E3542
	Offset: 0xBEE0
	Size: 0x220
	Parameters: 0
	Flags: Linked
*/
function function_1d21f4f()
{
	/#
		while(true)
		{
			if(isdefined(level.var_c2a01768) && level.var_c2a01768)
			{
				if(!isdefined(level.var_ff15f442))
				{
					level.var_ff15f442 = newhudelem();
					level.var_ff15f442.alignx = "";
					level.var_ff15f442.x = 2;
					level.var_ff15f442.y = 160;
					level.var_ff15f442.fontscale = 1.5;
					level.var_ff15f442.color = (1, 1, 1);
				}
				zombie_count = zombie_utility::get_current_zombie_count();
				zombie_left = level.zombie_total;
				zombie_runners = 0;
				var_8cbe658b = zombie_utility::get_zombie_array();
				foreach(ai_zombie in var_8cbe658b)
				{
					if(ai_zombie.zombie_move_speed == "")
					{
						zombie_runners++;
					}
				}
				level.var_ff15f442 settext((((("" + zombie_count) + "") + zombie_left) + "") + zombie_runners);
			}
			else if(isdefined(level.var_ff15f442))
			{
				level.var_ff15f442 destroy();
			}
			wait(0.05);
		}
	#/
}

/*
	Name: testscriptruntimeerrorassert
	Namespace: zm_devgui
	Checksum: 0x4B960277
	Offset: 0xC108
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function testscriptruntimeerrorassert()
{
	/#
		wait(1);
		/#
			assert(0);
		#/
	#/
}

/*
	Name: testscriptruntimeerror2
	Namespace: zm_devgui
	Checksum: 0xC866F8F9
	Offset: 0xC138
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function testscriptruntimeerror2()
{
	/#
		myundefined = "";
		if(myundefined == 1)
		{
			println("");
		}
	#/
}

/*
	Name: testscriptruntimeerror1
	Namespace: zm_devgui
	Checksum: 0x901D1CBD
	Offset: 0xC188
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function testscriptruntimeerror1()
{
	/#
		testscriptruntimeerror2();
	#/
}

/*
	Name: testscriptruntimeerror
	Namespace: zm_devgui
	Checksum: 0x92534BC4
	Offset: 0xC1B0
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function testscriptruntimeerror()
{
	/#
		wait(5);
		for(;;)
		{
			if(getdvarstring("") != "")
			{
				break;
			}
			wait(1);
		}
		myerror = getdvarstring("");
		setdvar("", "");
		if(myerror == "")
		{
			testscriptruntimeerrorassert();
		}
		else
		{
			testscriptruntimeerror1();
		}
		thread testscriptruntimeerror();
	#/
}

/*
	Name: function_2fcc56bd
	Namespace: zm_devgui
	Checksum: 0xA7661B2D
	Offset: 0xC288
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function function_2fcc56bd()
{
	/#
		var_9857308b = getdvarint("");
		return array(array(var_9857308b / 2, 30), array(var_9857308b - 1, 20));
	#/
}

/*
	Name: function_1acc8e35
	Namespace: zm_devgui
	Checksum: 0x43FAF036
	Offset: 0xC318
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function function_1acc8e35()
{
	/#
		self endon(#"hash_eec2d58b");
		setdvar("", 1);
		var_9857308b = getdvarint("");
		timescale = getdvarint("");
		var_da0f3f6 = function_2fcc56bd();
		setdvar("", timescale);
		while(level.round_number < var_9857308b)
		{
			foreach(var_b16efbf2 in var_da0f3f6)
			{
				if(level.round_number < var_b16efbf2[0])
				{
					wait(var_b16efbf2[1]);
					break;
				}
			}
			ai_enemies = getaiteamarray("");
			foreach(ai in ai_enemies)
			{
				ai kill();
			}
			adddebugcommand("");
			wait(0.2);
		}
		setdvar("", 1);
	#/
}

/*
	Name: function_eec2d58b
	Namespace: zm_devgui
	Checksum: 0x6E03069E
	Offset: 0xC568
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_eec2d58b()
{
	/#
		self notify(#"hash_eec2d58b");
		setdvar("", 1);
	#/
}

