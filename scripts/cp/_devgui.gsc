// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_accolades;
#using scripts\cp\_challenges;
#using scripts\cp\_decorations;
#using scripts\cp\_laststand;
#using scripts\cp\_skipto;
#using scripts\cp\gametypes\_save;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\load_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;

#namespace devgui;

/*
	Name: __init__sytem__
	Namespace: devgui
	Checksum: 0x56FC5155
	Offset: 0x270
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
	Checksum: 0x2E544098
	Offset: 0x2B0
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", 0);
		setdvar("", "");
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", "");
		thread devgui_think();
		thread devgui_weapon_think();
		thread devgui_weapon_asset_name_display_think();
		thread devgui_test_chart_think();
		thread init_debug_center_screen();
		level thread dev::body_customization_devgui(2);
		callback::on_start_gametype(&devgui_player_commands);
		callback::on_connect(&devgui_player_connect);
		callback::on_disconnect(&devgui_player_disconnect);
	#/
}

/*
	Name: devgui_player_commands
	Namespace: devgui
	Checksum: 0xE52F8091
	Offset: 0x478
	Size: 0x1EE
	Parameters: 0
	Flags: Linked
*/
function devgui_player_commands()
{
	/#
		level flag::wait_till("");
		rootclear = "";
		adddebugcommand(rootclear);
		players = getplayers();
		foreach(player in getplayers())
		{
			rootclear = ("" + player.playername) + "";
			adddebugcommand(rootclear);
		}
		thread devgui_player_weapons();
		level.player_devgui_base = "";
		devgui_add_player_commands(level.player_devgui_base, "", 0);
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			ip1 = i + 1;
			devgui_add_player_commands(level.player_devgui_base, players[i].playername, ip1);
		}
	#/
}

/*
	Name: devgui_player_connect
	Namespace: devgui
	Checksum: 0xD1BD5F69
	Offset: 0x670
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function devgui_player_connect()
{
	/#
		if(!isdefined(level.player_devgui_base))
		{
			return;
		}
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i] != self)
			{
				continue;
			}
			devgui_add_player_commands(level.player_devgui_base, players[i].playername, i + 1);
		}
	#/
}

/*
	Name: devgui_player_disconnect
	Namespace: devgui
	Checksum: 0x2847C4CD
	Offset: 0x728
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function devgui_player_disconnect()
{
	/#
		if(!isdefined(level.player_devgui_base))
		{
			return;
		}
		rootclear = ("" + self.playername) + "";
		util::add_queued_debug_command(rootclear);
	#/
}

/*
	Name: devgui_add_player_commands
	Namespace: devgui
	Checksum: 0xABFF2DA0
	Offset: 0x788
	Size: 0x68C
	Parameters: 3
	Flags: Linked
*/
function devgui_add_player_commands(root, pname, index)
{
	/#
		player_devgui_root = (root + pname) + "";
		pid = "" + index;
		devgui_add_player_command(player_devgui_root, pid, "", 1, "");
		devgui_add_player_command(player_devgui_root, pid, "", 2, "");
		devgui_add_player_command(player_devgui_root, pid, "", 3, "");
		devgui_add_player_command(player_devgui_root, pid, "", 4, "");
		devgui_add_player_command(player_devgui_root, pid, "", 5, "");
		devgui_add_player_command(player_devgui_root, pid, "", 6, "");
		devgui_add_player_command(player_devgui_root, pid, "", 7, "");
		devgui_add_player_command(player_devgui_root, pid, "", 8, "");
		devgui_add_player_command(player_devgui_root, pid, "", 9, "");
		devgui_add_player_command(player_devgui_root, pid, "", 10, "");
		devgui_add_player_command(player_devgui_root, pid, "", 11, "");
		devgui_add_player_command(player_devgui_root, pid, "", 12, "");
		devgui_add_player_command(player_devgui_root, pid, "", 13, "");
		devgui_add_player_command(player_devgui_root, pid, "", 14, "");
		devgui_add_player_command(player_devgui_root, pid, "", 15, "");
		devgui_add_player_command(player_devgui_root, pid, "", 16, "");
		devgui_add_player_command(player_devgui_root, pid, "", 17, "");
		devgui_add_player_command(player_devgui_root, pid, "", 18, "");
		devgui_add_player_command(player_devgui_root, pid, "", 19, "");
		devgui_add_player_command(player_devgui_root, pid, "", 20, "");
		devgui_add_player_command(player_devgui_root, pid, "", 21, "");
		devgui_add_player_command(player_devgui_root, pid, "", 22, "");
		devgui_add_player_command(player_devgui_root, pid, "", 23, "");
		devgui_add_player_command(player_devgui_root, pid, "", 24, "");
		devgui_add_player_command(player_devgui_root, pid, "", 25, "");
		devgui_add_player_command(player_devgui_root, pid, "", 26, "");
		devgui_add_player_command(player_devgui_root, pid, "", 27, "");
		devgui_add_player_command(player_devgui_root, pid, "", 28, "");
		devgui_add_player_command(player_devgui_root, pid, "", 29, "");
		devgui_add_player_command(player_devgui_root, pid, "", 30, "");
		devgui_add_player_command(player_devgui_root, pid, "", 31, "");
		devgui_add_player_command(player_devgui_root, pid, "", 32, "");
		devgui_add_player_command(player_devgui_root, pid, "", 33, "");
	#/
}

/*
	Name: devgui_add_player_command
	Namespace: devgui
	Checksum: 0x5CEECD41
	Offset: 0xE20
	Size: 0x94
	Parameters: 5
	Flags: Linked
*/
function devgui_add_player_command(root, pid, cmdname, cmdindex, cmddvar)
{
	/#
		adddebugcommand((((((((((root + cmdname) + "") + "") + "") + pid) + "") + "") + "") + cmddvar) + "");
	#/
}

/*
	Name: devgui_handle_player_command
	Namespace: devgui
	Checksum: 0x26CFE2CE
	Offset: 0xEC0
	Size: 0x10C
	Parameters: 3
	Flags: Linked
*/
function devgui_handle_player_command(cmd, playercallback, pcb_param)
{
	/#
		pid = getdvarint("");
		if(pid > 0)
		{
			player = getplayers()[pid - 1];
			if(isdefined(player))
			{
				if(isdefined(pcb_param))
				{
					player thread [[playercallback]](pcb_param);
				}
				else
				{
					player thread [[playercallback]]();
				}
			}
		}
		else
		{
			array::thread_all(getplayers(), playercallback, pcb_param);
		}
		setdvar("", "");
	#/
}

/*
	Name: devgui_think
	Namespace: devgui
	Checksum: 0xF24B2B68
	Offset: 0xFD8
	Size: 0x7A8
	Parameters: 0
	Flags: Linked
*/
function devgui_think()
{
	/#
		for(;;)
		{
			cmd = getdvarstring("");
			if(cmd == "")
			{
				wait(0.05);
				continue;
			}
			switch(cmd)
			{
				case "":
				{
					devgui_handle_player_command(cmd, &devgui_give_health);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &devgui_toggle_ammo);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &devgui_toggle_ignore);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &devgui_invulnerable, 1);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &devgui_invulnerable, 0);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &devgui_kill);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &devgui_revive);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &devgui_toggle_infinitesolo);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_cac73614, 100);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_cac73614, 1000);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_9f78d70e, 100);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_9f78d70e, 1000);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_d7b26538);
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_fcd3cf3f);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_192ef5eb);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 0);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 1);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 2);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 3);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 4);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 5);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 6);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 7);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 8);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 9);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_b79fb0fe, 10);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_f61fdbaf);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_408729cd);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_4edb34ed);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_4533d882);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_cac73614, 1000000);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_e2643869);
					break;
				}
				case "":
				{
					devgui_handle_player_command(cmd, &function_9c35ef50, "");
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
								if(isdefined([[devgui]](cmd)) && [[devgui]](cmd))
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
	Name: function_9c35ef50
	Namespace: devgui
	Checksum: 0x925FBE7C
	Offset: 0x1788
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_9c35ef50(stat_name)
{
	/#
		self challenges::function_96ed590f(stat_name, 50);
	#/
}

/*
	Name: function_e2643869
	Namespace: devgui
	Checksum: 0xC82906BA
	Offset: 0x17C0
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function function_e2643869()
{
	/#
		var_c02de660 = skipto::function_23eda99c();
		foreach(mission in var_c02de660)
		{
			self addplayerstat("" + getsubstr(getmissionname(mission), 0, 3), 1);
		}
	#/
}

/*
	Name: function_4533d882
	Namespace: devgui
	Checksum: 0xA800F7E8
	Offset: 0x18B0
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function function_4533d882()
{
	/#
		for(itemindex = 1; itemindex < 76; itemindex++)
		{
			self setdstat("", itemindex, "", "", "", 999);
		}
	#/
}

/*
	Name: function_4edb34ed
	Namespace: devgui
	Checksum: 0x2ABEB0F6
	Offset: 0x1928
	Size: 0x66
	Parameters: 0
	Flags: Linked
*/
function function_4edb34ed()
{
	/#
		for(itemindex = 1; itemindex < 76; itemindex++)
		{
			self setdstat("", itemindex, "", 1000000);
		}
	#/
}

/*
	Name: function_408729cd
	Namespace: devgui
	Checksum: 0x16E5AFEC
	Offset: 0x1998
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function function_408729cd()
{
	/#
		if(!isdefined(getrootmapname()))
		{
			return;
		}
		foreach(mission in skipto::function_23eda99c())
		{
			self setdstat("", mission, "", 4, 1);
		}
	#/
}

/*
	Name: function_192ef5eb
	Namespace: devgui
	Checksum: 0xEC45DA43
	Offset: 0x1A70
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_192ef5eb()
{
	/#
		if(isdefined(self.var_f0080358) && self.var_f0080358)
		{
			self closeluimenu(self.var_f0080358);
		}
		self.var_f0080358 = self openluimenu("");
		self waittill(#"menuresponse", menu, response);
		while(response != "")
		{
			self waittill(#"menuresponse", menu, response);
		}
		self closeluimenu(self.var_f0080358);
	#/
}

/*
	Name: function_b79fb0fe
	Namespace: devgui
	Checksum: 0x30B2578E
	Offset: 0x1B48
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_b79fb0fe(var_b931f6fe)
{
	/#
		a_decorations = self getdecorations();
		self givedecoration(a_decorations[var_b931f6fe].name);
		uploadstats(self);
	#/
}

/*
	Name: function_f61fdbaf
	Namespace: devgui
	Checksum: 0x25B6FFAA
	Offset: 0x1BC8
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_f61fdbaf()
{
	/#
		var_c02de660 = skipto::function_23eda99c();
		foreach(mission_name in var_c02de660)
		{
			self setdstat("", mission_name, "", 1);
		}
	#/
}

/*
	Name: function_d7b26538
	Namespace: devgui
	Checksum: 0x9756E50F
	Offset: 0x1C98
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_d7b26538()
{
	/#
		var_c02de660 = skipto::function_23eda99c();
		foreach(mission in var_c02de660)
		{
			for(i = 0; i < 10; i++)
			{
				self setdstat("", mission, "", i, 1);
			}
		}
	#/
}

/*
	Name: function_fcd3cf3f
	Namespace: devgui
	Checksum: 0xC919A945
	Offset: 0x1D90
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_fcd3cf3f()
{
	/#
		var_c02de660 = skipto::function_23eda99c();
		foreach(mission_name in var_c02de660)
		{
			self setdstat("", mission_name, "", 1);
		}
	#/
}

/*
	Name: function_cac73614
	Namespace: devgui
	Checksum: 0x2CE7E4A4
	Offset: 0x1E60
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_cac73614(var_735c65d7)
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		self addrankxpvalue("", var_735c65d7);
	#/
}

/*
	Name: function_9f78d70e
	Namespace: devgui
	Checksum: 0x9B374B38
	Offset: 0x1EE0
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function function_9f78d70e(var_735c65d7)
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		weaponnum = int(tablelookup("", 3, self.currentweapon.rootweapon.displayname, 0));
		var_b51b0d94 = self getdstat("", weaponnum, "");
		self setdstat("", weaponnum, "", var_735c65d7 + var_b51b0d94);
	#/
}

/*
	Name: devgui_invulnerable
	Namespace: devgui
	Checksum: 0xCD32BAF
	Offset: 0x2000
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function devgui_invulnerable(onoff)
{
	/#
		if(onoff)
		{
			self enableinvulnerability();
		}
		else
		{
			self disableinvulnerability();
		}
	#/
}

/*
	Name: devgui_kill
	Namespace: devgui
	Checksum: 0xD5803204
	Offset: 0x2050
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function devgui_kill()
{
	/#
		/#
			assert(isdefined(self));
		#/
		/#
			assert(isplayer(self));
		#/
		if(isalive(self))
		{
			self disableinvulnerability();
			death_from = (randomfloatrange(-20, 20), randomfloatrange(-20, 20), randomfloatrange(-20, 20));
			self dodamage(self.health + 666, self.origin + death_from);
		}
	#/
}

/*
	Name: devgui_toggle_ammo
	Namespace: devgui
	Checksum: 0x6A46AD73
	Offset: 0x2158
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function devgui_toggle_ammo()
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
			weapon = self getcurrentweapon();
			if(weapon != level.weaponnone)
			{
				self setweaponoverheating(0, 0);
				max = weapon.maxammo;
				if(isdefined(max))
				{
					self setweaponammostock(weapon, max);
				}
			}
			wait(1);
		}
	#/
}

/*
	Name: devgui_toggle_ignore
	Namespace: devgui
	Checksum: 0x4E997271
	Offset: 0x22B8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function devgui_toggle_ignore()
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
		self.ignoreme = !self.ignoreme;
	#/
}

/*
	Name: devgui_toggle_infinitesolo
	Namespace: devgui
	Checksum: 0x3472D07B
	Offset: 0x2348
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function devgui_toggle_infinitesolo()
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
		self.infinite_solo_revives = !self.infinite_solo_revives;
	#/
}

/*
	Name: devgui_revive
	Namespace: devgui
	Checksum: 0x6D39044C
	Offset: 0x23D8
	Size: 0x13E
	Parameters: 0
	Flags: Linked
*/
function devgui_revive()
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
		if(isdefined(self.revivetrigger))
		{
			self.revivetrigger delete();
			self.revivetrigger = undefined;
		}
		self laststand::cleanup_suicide_hud();
		self laststand::laststand_enable_player_weapons();
		self allowjump(1);
		self.ignoreme = 0;
		self disableinvulnerability();
		self.laststand = undefined;
		self notify(#"player_revived", self);
	#/
}

/*
	Name: maintain_maxhealth
	Namespace: devgui
	Checksum: 0xF0E202D3
	Offset: 0x2520
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function maintain_maxhealth(maxhealth)
{
	/#
		self endon(#"disconnect");
		self endon(#"devgui_give_health");
		while(true)
		{
			wait(1);
			if(self.maxhealth != maxhealth)
			{
				self.maxhealth = maxhealth;
				self.health = self.maxhealth;
			}
		}
	#/
}

/*
	Name: devgui_give_health
	Namespace: devgui
	Checksum: 0x539C5EF2
	Offset: 0x2590
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function devgui_give_health()
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
		self notify(#"devgui_give_health");
		if(self.maxhealth >= 2000 && isdefined(self.orgmaxhealth))
		{
			self.maxhealth = self.orgmaxhealth;
		}
		else
		{
			self.orgmaxhealth = self.maxhealth;
			self.maxhealth = 2000;
			self thread maintain_maxhealth(self.maxhealth);
		}
		self.health = self.maxhealth;
	#/
}

/*
	Name: devgui_player_weapons
	Namespace: devgui
	Checksum: 0x290F738B
	Offset: 0x2698
	Size: 0x518
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
		wait(0.1);
		a_weapons = enumerateweapons("");
		a_weapons_cp = [];
		a_grenades_cp = [];
		a_misc_cp = [];
		for(i = 0; i < a_weapons.size; i++)
		{
			if(weapons::is_primary_weapon(a_weapons[i]) || weapons::is_side_arm(a_weapons[i]))
			{
				arrayinsert(a_weapons_cp, a_weapons[i], 0);
				continue;
			}
			if(weapons::is_grenade(a_weapons[i]))
			{
				arrayinsert(a_grenades_cp, a_weapons[i], 0);
				continue;
			}
			arrayinsert(a_misc_cp, a_weapons[i], 0);
		}
		player_devgui_base_cp = "";
		adddebugcommand((((player_devgui_base_cp + "") + "") + "") + "");
		adddebugcommand((((player_devgui_base_cp + "") + "") + "") + "");
		adddebugcommand((((player_devgui_base_cp + "") + "") + "") + "");
		devgui_add_player_weapons(player_devgui_base_cp, "", 0, a_grenades_cp, "");
		devgui_add_player_weapons(player_devgui_base_cp, "", 0, a_weapons_cp, "");
		devgui_add_player_weapons(player_devgui_base_cp, "", 0, a_misc_cp, "");
		devgui_add_player_gun_attachments(player_devgui_base_cp, "", 0, a_weapons_cp, "");
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			ip1 = i + 1;
			adddebugcommand((((player_devgui_base_cp + players[i].playername) + "") + "") + "");
			adddebugcommand((((player_devgui_base_cp + players[i].playername) + "") + "") + "");
			adddebugcommand((((player_devgui_base_cp + players[i].playername) + "") + "") + "");
			devgui_add_player_weapons(player_devgui_base_cp, players[i].playername, ip1, a_grenades_cp, "");
			devgui_add_player_weapons(player_devgui_base_cp, players[i].playername, ip1, a_weapons_cp, "");
			devgui_add_player_weapons(player_devgui_base_cp, players[i].playername, ip1, a_misc_cp, "");
			devgui_add_player_gun_attachments(player_devgui_base_cp, players[i].playername, ip1, a_weapons_cp, "");
		}
		game[""] = 1;
	#/
}

/*
	Name: devgui_add_player_gun_attachments
	Namespace: devgui
	Checksum: 0xADB12274
	Offset: 0x2BB8
	Size: 0x222
	Parameters: 5
	Flags: Linked
*/
function devgui_add_player_gun_attachments(root, pname, index, a_weapons, weapon_type)
{
	/#
		player_devgui_root = ((((root + pname) + "") + "") + weapon_type) + "";
		attachments = [];
		foreach(weapon in a_weapons)
		{
			foreach(supportedattachment in weapon.supportedattachments)
			{
				array::add(attachments, supportedattachment, 0);
			}
		}
		pid = "" + index;
		foreach(att in attachments)
		{
			devgui_add_player_attachment_command(player_devgui_root, pid, att, 1);
		}
	#/
}

/*
	Name: devgui_add_player_weapons
	Namespace: devgui
	Checksum: 0xBF1495A4
	Offset: 0x2DE8
	Size: 0x24E
	Parameters: 5
	Flags: Linked
*/
function devgui_add_player_weapons(root, pname, index, a_weapons, weapon_type)
{
	/#
		player_devgui_root = ((((root + pname) + "") + "") + weapon_type) + "";
		pid = "" + index;
		if(isdefined(a_weapons))
		{
			for(i = 0; i < a_weapons.size; i++)
			{
				if(weapon_type == "")
				{
					attachments = [];
				}
				else
				{
					attachments = a_weapons[i].supportedattachments;
				}
				name = a_weapons[i].name;
				if(attachments.size)
				{
					devgui_add_player_weap_command((player_devgui_root + name) + "", pid, name, i + 1);
					foreach(att in attachments)
					{
						if(att != "")
						{
							devgui_add_player_weap_command((player_devgui_root + name) + "", pid, (name + "") + att, i + 1);
						}
					}
				}
				else
				{
					devgui_add_player_weap_command(player_devgui_root, pid, name, i + 1);
				}
				wait(0.05);
			}
		}
	#/
}

/*
	Name: devgui_add_player_weap_command
	Namespace: devgui
	Checksum: 0x2E75D6E
	Offset: 0x3040
	Size: 0x8C
	Parameters: 4
	Flags: Linked
*/
function devgui_add_player_weap_command(root, pid, weap_name, cmdindex)
{
	/#
		adddebugcommand((((((((((root + weap_name) + "") + "") + "") + pid) + "") + "") + "") + weap_name) + "");
	#/
}

/*
	Name: devgui_add_player_attachment_command
	Namespace: devgui
	Checksum: 0x65801849
	Offset: 0x30D8
	Size: 0x8C
	Parameters: 4
	Flags: Linked
*/
function devgui_add_player_attachment_command(root, pid, attachment_name, cmdindex)
{
	/#
		adddebugcommand((((((((((root + attachment_name) + "") + "") + "") + pid) + "") + "") + "") + attachment_name) + "");
	#/
}

/*
	Name: devgui_weapon_think
	Namespace: devgui
	Checksum: 0x11A6E8F8
	Offset: 0x3170
	Size: 0x108
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
				devgui_handle_player_command(weapon_name, &devgui_give_weapon, weapon_name);
				setdvar("", "");
			}
			attachmentname = getdvarstring("");
			if(attachmentname != "")
			{
				devgui_handle_player_command(attachmentname, &devgui_give_attachment, attachmentname);
				setdvar("", "");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: devgui_weapon_asset_name_display_think
	Namespace: devgui
	Checksum: 0x76BEFB20
	Offset: 0x3280
	Size: 0x3E0
	Parameters: 0
	Flags: Linked
*/
function devgui_weapon_asset_name_display_think()
{
	/#
		update_time = 0.5;
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
	Name: devgui_test_chart_think
	Namespace: devgui
	Checksum: 0x9149A16C
	Offset: 0x3668
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
	Checksum: 0xE77AE077
	Offset: 0x3880
	Size: 0x324
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
			if(getdvarint(""))
			{
				adddebugcommand("" + weapon_name);
				wait(0.05);
			}
			else
			{
				self takeweapon(currentweapon);
				self giveweapon(weapon);
				self switchtoweapon(weapon);
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
	Name: devgui_give_attachment
	Namespace: devgui
	Checksum: 0x500D3027
	Offset: 0x3BB0
	Size: 0x46C
	Parameters: 1
	Flags: Linked
*/
function devgui_give_attachment(attachment_name)
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
		self notify(#"devgui_give_attachment");
		self endon(#"devgui_give_attachment");
		currentweapon = self getcurrentweapon();
		attachmentsupported = 0;
		split = strtok(currentweapon.name, "");
		foreach(attachment in currentweapon.supportedattachments)
		{
			if(attachment == attachment_name)
			{
				attachmentsupported = 1;
			}
		}
		if(attachmentsupported == 0)
		{
			iprintlnbold((("" + attachment_name) + "") + split[0]);
			attachmentsstring = "";
			if(currentweapon.supportedattachments.size == 0)
			{
				attachmentsstring = attachmentsstring + "";
			}
			foreach(attachment in currentweapon.supportedattachments)
			{
				attachmentsstring = attachmentsstring + ("" + attachment);
			}
			iprintlnbold(attachmentsstring);
			return;
		}
		foreach(currentattachment in split)
		{
			if(currentattachment == attachment_name)
			{
				iprintlnbold((("" + attachment_name) + "") + currentweapon.name);
				return;
			}
		}
		split[split.size] = attachment_name;
		for(index = split.size; index < 9; index++)
		{
			split[index] = "";
		}
		self takeweapon(currentweapon);
		newweapon = getweapon(split[0], split[1], split[2], split[3], split[4], split[5], split[6], split[7], split[8]);
		self giveweapon(newweapon);
		self switchtoweapon(newweapon);
	#/
}

/*
	Name: init_debug_center_screen
	Namespace: devgui
	Checksum: 0x40452B25
	Offset: 0x4028
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
	Checksum: 0x13C6FC57
	Offset: 0x4160
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

