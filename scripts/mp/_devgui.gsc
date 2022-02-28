// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_vehicle;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\load_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\weapons_shared;

#namespace devgui;

/*
	Name: __init__sytem__
	Namespace: devgui
	Checksum: 0xA37866F7
	Offset: 0x278
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
	Namespace: devgui
	Checksum: 0xF04A5C64
	Offset: 0x2B8
	Size: 0x4B4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		setdvar("", "");
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		level.attachment_cycling_dvars = [];
		level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "";
		level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "";
		level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "";
		level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "";
		level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "";
		level.attachment_cycling_dvars[level.attachment_cycling_dvars.size] = "";
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		level.acv_cycling_dvars = [];
		level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "";
		level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "";
		level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "";
		level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "";
		level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "";
		level.acv_cycling_dvars[level.acv_cycling_dvars.size] = "";
		level thread devgui_weapon_think();
		level thread devgui_weapon_asset_name_display_think();
		level thread devgui_player_weapons();
		level thread devgui_test_chart_think();
		level thread devgui_player_spawn_think();
		level thread devgui_vehicle_spawn_think();
		thread init_debug_center_screen();
		level thread dev::body_customization_devgui(1);
		callback::on_connect(&hero_art_on_player_connect);
		callback::on_connect(&on_player_connect);
	#/
}

/*
	Name: on_player_connect
	Namespace: devgui
	Checksum: 0x9CD0602E
	Offset: 0x778
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	/#
		/#
			self.devguilockspawn = 0;
			self thread devgui_player_spawn();
		#/
	#/
}

/*
	Name: devgui_player_spawn
	Namespace: devgui
	Checksum: 0xB1985489
	Offset: 0x7B0
	Size: 0x172
	Parameters: 0
	Flags: Linked
*/
function devgui_player_spawn()
{
	/#
		wait(1);
		player_devgui_base_mp = "";
		wait(0.05);
		players = getplayers();
		foreach(player in players)
		{
			if(player != self)
			{
				continue;
			}
			temp = (((((player_devgui_base_mp + player.playername) + "") + "") + "") + player.playername) + "";
			adddebugcommand((((((player_devgui_base_mp + player.playername) + "") + "") + "") + player.playername) + "");
		}
	#/
}

/*
	Name: devgui_player_spawn_think
	Namespace: devgui
	Checksum: 0x364FB713
	Offset: 0x930
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function devgui_player_spawn_think()
{
	/#
		for(;;)
		{
			playername = getdvarstring("");
			if(playername == "")
			{
				wait(0.05);
				continue;
			}
			players = getplayers();
			foreach(player in players)
			{
				if(player.playername != playername)
				{
					continue;
				}
				player.devguilockspawn = !player.devguilockspawn;
				if(player.devguilockspawn)
				{
					player.resurrect_origin = player.origin;
					player.resurrect_angles = player.angles;
				}
			}
			setdvar("", "");
			wait(0.5);
		}
	#/
}

/*
	Name: devgui_vehicle_spawn_think
	Namespace: devgui
	Checksum: 0xFA3065BB
	Offset: 0xAC0
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function devgui_vehicle_spawn_think()
{
	/#
		wait(0.05);
		for(;;)
		{
			val = getdvarint("");
			if(val != 0)
			{
				if(val == 1)
				{
					add_vehicle_at_eye_trace("");
				}
				else
				{
					if(val == 2)
					{
						add_vehicle_at_eye_trace("");
					}
					else
					{
						if(val == 3)
						{
							add_vehicle_at_eye_trace("");
						}
						else if(val == 4)
						{
							add_vehicle_at_eye_trace("");
						}
					}
				}
				setdvar("", "");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: devgui_player_weapons
	Namespace: devgui
	Checksum: 0x92344CFD
	Offset: 0xBD8
	Size: 0x8FC
	Parameters: 0
	Flags: Linked
*/
function devgui_player_weapons()
{
	/#
		if(isdefined(game[""]) && game[""])
		{
			return;
		}
		level flag::wait_till("");
		a_weapons = enumerateweapons("");
		a_weapons_mp = [];
		a_grenades_mp = [];
		a_misc_mp = [];
		for(i = 0; i < a_weapons.size; i++)
		{
			if(weapons::is_primary_weapon(a_weapons[i]) || weapons::is_side_arm(a_weapons[i]) && !killstreaks::is_killstreak_weapon(a_weapons[i]))
			{
				arrayinsert(a_weapons_mp, a_weapons[i], 0);
				continue;
			}
			if(weapons::is_grenade(a_weapons[i]))
			{
				arrayinsert(a_grenades_mp, a_weapons[i], 0);
				continue;
			}
			arrayinsert(a_misc_mp, a_weapons[i], 0);
		}
		player_devgui_base_mp = "";
		menu_index = 1;
		level thread devgui_add_player_weapons(player_devgui_base_mp, "", 0, a_weapons_mp, "", menu_index);
		menu_index++;
		level thread devgui_add_player_weapons(player_devgui_base_mp, "", 0, a_grenades_mp, "", menu_index);
		menu_index++;
		level thread devgui_add_player_weapons(player_devgui_base_mp, "", 0, a_misc_mp, "", menu_index);
		menu_index++;
		game[""] = 1;
		wait(0.05);
		adddebugcommand((((player_devgui_base_mp + "") + "") + "") + "");
		menu_index++;
		adddebugcommand((((player_devgui_base_mp + "") + "") + "") + "");
		menu_index++;
		adddebugcommand((((player_devgui_base_mp + "") + "") + "") + "");
		menu_index++;
		acv_devgui_base_mp = (player_devgui_base_mp + "") + "";
		menu_index++;
		acv_menu_index = 1;
		acv_sub_menu_index = 1;
		for(i = 0; i <= 3; i++)
		{
			adddebugcommand((((((((acv_devgui_base_mp + "") + "") + i) + "") + "") + "") + i) + "");
			acv_sub_menu_index++;
		}
		acv_menu_index++;
		attachmentnames = getattachmentnames();
		acv_sub_menu_index = 1;
		for(i = 0; i < attachmentnames.size; i++)
		{
			if(issubstr(attachmentnames[i], ""))
			{
				continue;
			}
			function_27141585();
			adddebugcommand((((((((acv_devgui_base_mp + "") + "") + attachmentnames[i]) + "") + "") + "") + attachmentnames[i]) + "");
			acv_sub_menu_index++;
		}
		acv_menu_index++;
		acv_sub_menu_index = 1;
		for(i = 0; i < attachmentnames.size; i++)
		{
			if(issubstr(attachmentnames[i], ""))
			{
				continue;
			}
			function_27141585();
			adddebugcommand((((((((acv_devgui_base_mp + "") + "") + attachmentnames[i]) + "") + "") + "") + attachmentnames[i]) + "");
			acv_sub_menu_index++;
		}
		acv_menu_index++;
		wait(0.05);
		attachment_cycling_devgui_base_mp = (player_devgui_base_mp + "") + "";
		adddebugcommand(((attachment_cycling_devgui_base_mp + "") + "") + "");
		adddebugcommand(((attachment_cycling_devgui_base_mp + "") + "") + "");
		for(i = 0; i < 6; i++)
		{
			attachment_cycling_sub_menu_index = 1;
			adddebugcommand((((((attachment_cycling_devgui_base_mp + "") + (i + 1) + "") + "") + "") + i) + "");
			for(attachmentname = 0; attachmentname < attachmentnames.size; attachmentname++)
			{
				if(issubstr(attachmentnames[attachmentname], ""))
				{
					continue;
				}
				function_27141585();
				adddebugcommand((((((((((((((attachment_cycling_devgui_base_mp + "") + (i + 1) + "") + attachmentnames[attachmentname]) + "") + "") + "") + level.attachment_cycling_dvars[i]) + "") + attachmentnames[attachmentname]) + "") + level.acv_cycling_dvars[i]) + "") + 0) + "");
				attachment_cycling_sub_menu_index++;
				adddebugcommand((((((((((((((attachment_cycling_devgui_base_mp + "") + (i + 1) + "") + attachmentnames[attachmentname]) + "") + "") + "") + level.attachment_cycling_dvars[i]) + "") + attachmentnames[attachmentname]) + "") + level.acv_cycling_dvars[i]) + "") + 1) + "");
				attachment_cycling_sub_menu_index++;
			}
		}
		level thread devgui_attachment_cosmetic_variant_think();
		level thread devgui_attachment_cycling_think();
	#/
}

/*
	Name: devgui_add_player_weapons
	Namespace: devgui
	Checksum: 0x315A2F80
	Offset: 0x14E0
	Size: 0x21E
	Parameters: 6
	Flags: Linked
*/
function devgui_add_player_weapons(root, pname, index, a_weapons, weapon_type, mindex)
{
	/#
		if(isdedicated())
		{
			return;
		}
		devgui_root = (root + weapon_type) + "";
		if(isdefined(a_weapons))
		{
			for(i = 0; i < a_weapons.size; i++)
			{
				attachments = a_weapons[i].supportedattachments;
				name = a_weapons[i].name;
				if(attachments.size)
				{
					devgui_add_player_weap_command((devgui_root + name) + "", index, name, i + 1);
					foreach(att in attachments)
					{
						if(att != "")
						{
							devgui_add_player_weap_command((devgui_root + name) + "", index, (name + "") + att, i + 1);
						}
					}
				}
				else
				{
					devgui_add_player_weap_command(devgui_root, index, name, i + 1);
				}
				wait(0.05);
			}
		}
	#/
}

/*
	Name: function_27141585
	Namespace: devgui
	Checksum: 0x81A2D5B5
	Offset: 0x1708
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function function_27141585()
{
	/#
		if(!isdefined(level.var_f842514b))
		{
			level.var_f842514b = 0;
		}
		level.var_f842514b++;
		if((level.var_f842514b % 10) == 0)
		{
			wait(randomintrange(2, 5) * 0.05);
		}
	#/
}

/*
	Name: devgui_add_player_weap_command
	Namespace: devgui
	Checksum: 0x1C86EC2F
	Offset: 0x1770
	Size: 0x84
	Parameters: 4
	Flags: Linked
*/
function devgui_add_player_weap_command(root, pid, weap_name, cmdindex)
{
	/#
		function_27141585();
		adddebugcommand((((((root + weap_name) + "") + "") + "") + weap_name) + "");
	#/
}

/*
	Name: devgui_weapon_think
	Namespace: devgui
	Checksum: 0xA13A7FD4
	Offset: 0x1800
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function devgui_weapon_think()
{
	/#
		for(;;)
		{
			weapon_name = getdvarstring("");
			if(weapon_name != "")
			{
				devgui_handle_player_command(&devgui_give_weapon, weapon_name);
			}
			setdvar("", "");
			wait(0.5);
		}
	#/
}

/*
	Name: hero_art_on_player_connect
	Namespace: devgui
	Checksum: 0x83890241
	Offset: 0x1898
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function hero_art_on_player_connect()
{
	/#
		self._debugheromodels = spawnstruct();
	#/
}

/*
	Name: devgui_weapon_asset_name_display_think
	Namespace: devgui
	Checksum: 0xF144B144
	Offset: 0x18C8
	Size: 0x3E0
	Parameters: 0
	Flags: Linked
*/
function devgui_weapon_asset_name_display_think()
{
	/#
		update_time = 1;
		print_duration = int(update_time / 0.05);
		printlnbold_update = int(1 / update_time);
		printlnbold_counter = 0;
		colors = [];
		colors[colors.size] = (1, 1, 1);
		colors[colors.size] = (1, 0, 0);
		colors[colors.size] = (0, 1, 0);
		colors[colors.size] = (1, 1, 0);
		colors[colors.size] = (1, 0, 1);
		colors[colors.size] = (0, 1, 1);
		for(;;)
		{
			wait(update_time);
			display = getdvarint("");
			if(!display)
			{
				continue;
			}
			if(!printlnbold_counter)
			{
				iprintlnbold(level.players[0] getcurrentweapon().name);
			}
			printlnbold_counter++;
			if(printlnbold_counter >= printlnbold_update)
			{
				printlnbold_counter = 0;
			}
			color_index = 0;
			for(i = 1; i < level.players.size; i++)
			{
				player = level.players[i];
				weapon = player getcurrentweapon();
				if(!isdefined(weapon) || level.weaponnone == weapon)
				{
					continue;
				}
				print3d(player gettagorigin(""), weapon.name, colors[color_index], 1, 0.15, print_duration);
				color_index++;
				if(color_index >= colors.size)
				{
					color_index = 0;
				}
			}
			color_index = 0;
			ai_list = getaiarray();
			for(i = 0; i < ai_list.size; i++)
			{
				ai = ai_list[i];
				if(isvehicle(ai))
				{
					weapon = ai.turretweapon;
				}
				else
				{
					weapon = ai.weapon;
				}
				if(!isdefined(weapon) || level.weaponnone == weapon)
				{
					continue;
				}
				print3d(ai gettagorigin(""), weapon.name, colors[color_index], 1, 0.15, print_duration);
				color_index++;
				if(color_index >= colors.size)
				{
					color_index = 0;
				}
			}
		}
	#/
}

/*
	Name: devgui_attachment_cosmetic_variant_think
	Namespace: devgui
	Checksum: 0x1C06142B
	Offset: 0x1CB0
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function devgui_attachment_cosmetic_variant_think()
{
	/#
		old_index = 0;
		old_attachment_1 = "";
		old_attachment_2 = "";
		for(;;)
		{
			index = getdvarint("");
			attachment_1 = getdvarstring("");
			attachment_2 = getdvarstring("");
			if(old_attachment_1 != attachment_1 || old_attachment_2 != attachment_2 || old_index != index)
			{
				devgui_handle_player_command(&devgui_update_attachment_cosmetic_variant, attachment_1, attachment_2);
			}
			old_index = index;
			old_attachment_1 = attachment_1;
			old_attachment_2 = attachment_2;
			wait(0.5);
		}
	#/
}

/*
	Name: devgui_attachment_cycling_clear
	Namespace: devgui
	Checksum: 0xE29D96C
	Offset: 0x1DF0
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function devgui_attachment_cycling_clear(index)
{
	/#
		setdvar(level.attachment_cycling_dvars[index], "");
		setdvar(level.acv_cycling_dvars[index], 0);
	#/
}

/*
	Name: devgui_attachment_cycling_update
	Namespace: devgui
	Checksum: 0xABD9F930
	Offset: 0x1E58
	Size: 0x514
	Parameters: 0
	Flags: Linked
*/
function devgui_attachment_cycling_update()
{
	/#
		currentweapon = self getcurrentweapon();
		rootweapon = currentweapon.rootweapon;
		supportedattachments = currentweapon.supportedattachments;
		textcolors = [];
		attachments = [];
		acvs = [];
		originalattachments = [];
		originalacvs = [];
		for(i = 0; i < 6; i++)
		{
			originalattachments[i] = getdvarstring(level.attachment_cycling_dvars[i]);
			originalacvs[i] = getdvarint(level.acv_cycling_dvars[i]);
			textcolor[i] = "";
			attachments[i] = "";
			acvs[i] = 0;
			name = originalattachments[i];
			if("" == name)
			{
				continue;
			}
			textcolor[i] = "";
			for(supportedindex = 0; supportedindex < supportedattachments.size; supportedindex++)
			{
				if(name == supportedattachments[supportedindex])
				{
					textcolor[i] = "";
					attachments[i] = name;
					acvs[i] = originalacvs[i];
					break;
				}
			}
		}
		for(i = 0; i < 6; i++)
		{
			if("" == originalattachments[i])
			{
				continue;
			}
			for(j = i + 1; j < 6; j++)
			{
				if(originalattachments[i] == originalattachments[j])
				{
					textcolor[j] = "";
					attachments[j] = "";
					acvs[j] = 0;
				}
			}
		}
		msg = "";
		for(i = 0; i < 6; i++)
		{
			if("" == originalattachments[i])
			{
				continue;
			}
			msg = msg + textcolor[i];
			msg = msg + i;
			msg = msg + "";
			msg = msg + originalattachments[i];
			msg = msg + "";
			msg = msg + originalacvs[i];
			msg = msg + "";
		}
		iprintlnbold(msg);
		self takeweapon(currentweapon);
		currentweapon = getweapon(rootweapon.name, attachments[0], attachments[1], attachments[2], attachments[3], attachments[4], attachments[5]);
		acvi = getattachmentcosmeticvariantindexes(currentweapon, attachments[0], acvs[0], attachments[1], acvs[1], attachments[2], acvs[2], attachments[3], acvs[3], attachments[4], acvs[4], attachments[5], acvs[5]);
		wait(0.25);
		self giveweapon(currentweapon, undefined, acvi);
		self switchtoweapon(currentweapon);
	#/
}

/*
	Name: devgui_attachment_cycling_think
	Namespace: devgui
	Checksum: 0x34B9EA45
	Offset: 0x2378
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function devgui_attachment_cycling_think()
{
	/#
		for(;;)
		{
			state = getdvarstring("");
			setdvar("", "");
			if(issubstr(state, ""))
			{
				if("" == state)
				{
					for(i = 0; i < 6; i++)
					{
						devgui_attachment_cycling_clear(i);
					}
				}
				else
				{
					index = int(getsubstr(state, 6, 7));
					devgui_attachment_cycling_clear(index);
				}
				state = "";
			}
			if("" == state)
			{
				array::thread_all(getplayers(), &devgui_attachment_cycling_update);
			}
			wait(0.5);
		}
	#/
}

/*
	Name: devgui_test_chart_think
	Namespace: devgui
	Checksum: 0x6FB99D43
	Offset: 0x24F8
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
	Name: devgui_give_weapon
	Namespace: devgui
	Checksum: 0xFF585057
	Offset: 0x2710
	Size: 0x4AC
	Parameters: 1
	Flags: Linked
*/
function devgui_give_weapon(weapon_name)
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
		self notify(#"devgui_give_ammo");
		self endon(#"devgui_give_ammo");
		currentweapon = self getcurrentweapon();
		split = strtok(weapon_name, "");
		switch(split.size)
		{
			case 1:
			default:
			{
				weapon = getweapon(split[0]);
				break;
			}
			case 2:
			{
				weapon = getweapon(split[0], split[1]);
				break;
			}
			case 3:
			{
				weapon = getweapon(split[0], split[1], split[2]);
				break;
			}
			case 4:
			{
				weapon = getweapon(split[0], split[1], split[2], split[3]);
				break;
			}
			case 5:
			{
				weapon = getweapon(split[0], split[1], split[2], split[3], split[4]);
				break;
			}
		}
		if(currentweapon != weapon)
		{
			if(weapon.isgrenadeweapon)
			{
				grenades = 0;
				pweapons = self getweaponslist();
				foreach(pweapon in pweapons)
				{
					if(pweapon != weapon && pweapon.isgrenadeweapon)
					{
						grenades++;
					}
				}
				if(grenades > 1)
				{
					foreach(pweapon in pweapons)
					{
						if(pweapon != weapon && pweapon.isgrenadeweapon)
						{
							grenades--;
							self takeweapon(pweapon);
							if(grenades < 2)
							{
								break;
							}
						}
					}
				}
			}
			if(getdvarint(""))
			{
				adddebugcommand("" + weapon_name);
				wait(0.05);
			}
			else
			{
				self giveweapon(weapon);
				if(!weapon.isgrenadeweapon)
				{
					self switchtoweapon(weapon);
				}
			}
			max = weapon.maxammo;
			if(max)
			{
				self setweaponammostock(weapon, max);
			}
		}
	#/
}

/*
	Name: devgui_update_attachment_cosmetic_variant
	Namespace: devgui
	Checksum: 0x98638C6
	Offset: 0x2BC8
	Size: 0x15C
	Parameters: 2
	Flags: Linked
*/
function devgui_update_attachment_cosmetic_variant(attachment_1, attachment_2)
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
		currentweapon = self getcurrentweapon();
		variant_index = getdvarint("");
		acvi = getattachmentcosmeticvariantindexes(currentweapon, attachment_1, variant_index, attachment_2, variant_index);
		self takeweapon(currentweapon);
		wait(0.25);
		self giveweapon(currentweapon, undefined, acvi);
		self switchtoweapon(currentweapon);
	#/
}

/*
	Name: devgui_handle_player_command
	Namespace: devgui
	Checksum: 0x8010D4E
	Offset: 0x2D30
	Size: 0x13C
	Parameters: 3
	Flags: Linked
*/
function devgui_handle_player_command(playercallback, pcb_param_1, pcb_param_2)
{
	/#
		pid = getdvarint("");
		if(pid > 0)
		{
			player = getplayers()[pid - 1];
			if(isdefined(player))
			{
				if(isdefined(pcb_param_2))
				{
					player thread [[playercallback]](pcb_param_1, pcb_param_2);
				}
				else
				{
					if(isdefined(pcb_param_1))
					{
						player thread [[playercallback]](pcb_param_1);
					}
					else
					{
						player thread [[playercallback]]();
					}
				}
			}
		}
		else
		{
			array::thread_all(getplayers(), playercallback, pcb_param_1, pcb_param_2);
		}
		setdvar("", "");
	#/
}

/*
	Name: init_debug_center_screen
	Namespace: devgui
	Checksum: 0xA879970A
	Offset: 0x2E78
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function init_debug_center_screen()
{
	/#
		zero_idle_movement = "";
		for(;;)
		{
			if(getdvarint(""))
			{
				if(!isdefined(level.center_screen_debug_hudelem_active) || level.center_screen_debug_hudelem_active == 0)
				{
					thread debug_center_screen();
					zero_idle_movement = getdvarstring("");
					if(isdefined(zero_idle_movement) && zero_idle_movement == "")
					{
						setdvar("", "");
						zero_idle_movement = "";
					}
				}
			}
			else
			{
				level notify(#"hash_8e42baed");
				if(zero_idle_movement == "")
				{
					setdvar("", "");
					zero_idle_movement = "";
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: debug_center_screen
	Namespace: devgui
	Checksum: 0x107ADB7B
	Offset: 0x2FB0
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function debug_center_screen()
{
	/#
		level.center_screen_debug_hudelem_active = 1;
		wait(0.1);
		level.center_screen_debug_hudelem1 = newclienthudelem(level.players[0]);
		level.center_screen_debug_hudelem1.alignx = "";
		level.center_screen_debug_hudelem1.aligny = "";
		level.center_screen_debug_hudelem1.fontscale = 1;
		level.center_screen_debug_hudelem1.alpha = 0.5;
		level.center_screen_debug_hudelem1.x = 320 - 1;
		level.center_screen_debug_hudelem1.y = 240;
		level.center_screen_debug_hudelem1 setshader("", 1000, 1);
		level.center_screen_debug_hudelem2 = newclienthudelem(level.players[0]);
		level.center_screen_debug_hudelem2.alignx = "";
		level.center_screen_debug_hudelem2.aligny = "";
		level.center_screen_debug_hudelem2.fontscale = 1;
		level.center_screen_debug_hudelem2.alpha = 0.5;
		level.center_screen_debug_hudelem2.x = 320 - 1;
		level.center_screen_debug_hudelem2.y = 240;
		level.center_screen_debug_hudelem2 setshader("", 1, 480);
		level waittill(#"hash_8e42baed");
		level.center_screen_debug_hudelem1 destroy();
		level.center_screen_debug_hudelem2 destroy();
		level.center_screen_debug_hudelem_active = 0;
	#/
}

/*
	Name: add_vehicle_at_eye_trace
	Namespace: devgui
	Checksum: 0xDB996DDB
	Offset: 0x31E0
	Size: 0x140
	Parameters: 1
	Flags: Linked
*/
function add_vehicle_at_eye_trace(vehiclename)
{
	/#
		host = util::gethostplayer();
		trace = host bot::eye_trace();
		veh_spawner = getent(vehiclename + "", "");
		vehicle = veh_spawner spawnfromspawner(vehiclename, 1, 1, 1);
		if(isdefined(vehicle.archetype))
		{
			vehicle asmrequestsubstate("");
		}
		wait(0.05);
		vehicle.origin = trace[""];
		vehicle thread vehicle::vehicleteamthread();
		vehicle thread watch_player_death();
		return vehicle;
	#/
}

/*
	Name: watch_player_death
	Namespace: devgui
	Checksum: 0xF3E9DF2B
	Offset: 0x3330
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function watch_player_death()
{
	/#
		self endon(#"death");
		vehicle = self;
		while(true)
		{
			driver = self getseatoccupant(0);
			if(isdefined(driver) && !isalive(driver))
			{
				driver unlink();
			}
			wait(0.05);
		}
	#/
}

