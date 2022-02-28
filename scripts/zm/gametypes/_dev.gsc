// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_utils;

#namespace dev;

/*
	Name: __init__sytem__
	Namespace: dev
	Checksum: 0xAC029F3C
	Offset: 0x228
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("", &__init__, undefined, "");
	#/
}

/*
	Name: __init__
	Namespace: dev
	Checksum: 0xB8BEAF42
	Offset: 0x270
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		callback::on_start_gametype(&init);
	#/
}

/*
	Name: init
	Namespace: dev
	Checksum: 0x8DA1E1DE
	Offset: 0x2A8
	Size: 0x400
	Parameters: 0
	Flags: Linked
*/
function init()
{
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		thread testscriptruntimeerror();
		thread testdvars();
		thread devhelipathdebugdraw();
		thread devstraferunpathdebugdraw();
		thread globallogic_score::setplayermomentumdebug();
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		thread equipment_dev_gui();
		thread grenade_dev_gui();
		setdvar("", "");
		level.dem_spawns = [];
		if(level.gametype == "")
		{
			extra_spawns = [];
			extra_spawns[0] = "";
			extra_spawns[1] = "";
			extra_spawns[2] = "";
			extra_spawns[3] = "";
			for(i = 0; i < extra_spawns.size; i++)
			{
				points = getentarray(extra_spawns[i], "");
				if(isdefined(points) && points.size > 0)
				{
					level.dem_spawns = arraycombine(level.dem_spawns, points, 1, 0);
				}
			}
		}
		callback::on_connect(&on_player_connect);
		for(;;)
		{
			updatedevsettings();
			wait(0.5);
		}
	#/
}

/*
	Name: on_player_connect
	Namespace: dev
	Checksum: 0x278095A5
	Offset: 0x6B0
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	/#
	#/
}

/*
	Name: warpalltohost
	Namespace: dev
	Checksum: 0x73878099
	Offset: 0x6C0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function warpalltohost(team)
{
	/#
		host = util::gethostplayer();
		warpalltoplayer(team, host.name);
	#/
}

/*
	Name: warpalltoplayer
	Namespace: dev
	Checksum: 0xAC4B34D4
	Offset: 0x720
	Size: 0x374
	Parameters: 2
	Flags: Linked
*/
function warpalltoplayer(team, player)
{
	/#
		players = getplayers();
		target = undefined;
		for(i = 0; i < players.size; i++)
		{
			if(players[i].name == player)
			{
				target = players[i];
				break;
			}
		}
		if(isdefined(target))
		{
			origin = target.origin;
			nodes = getnodesinradius(origin, 128, 32, 128, "");
			angles = target getplayerangles();
			yaw = (0, angles[1], 0);
			forward = anglestoforward(yaw);
			spawn_origin = (origin + (forward * 128)) + vectorscale((0, 0, 1), 16);
			if(!bullettracepassed(target geteye(), spawn_origin, 0, target))
			{
				spawn_origin = undefined;
			}
			for(i = 0; i < players.size; i++)
			{
				if(players[i] == target)
				{
					continue;
				}
				if(isdefined(team))
				{
					if(strstartswith(team, "") && target.team == players[i].team)
					{
						continue;
					}
					if(strstartswith(team, "") && target.team != players[i].team)
					{
						continue;
					}
				}
				if(isdefined(spawn_origin))
				{
					players[i] setorigin(spawn_origin);
					continue;
				}
				if(nodes.size > 0)
				{
					node = array::random(nodes);
					players[i] setorigin(node.origin);
					continue;
				}
				players[i] setorigin(origin);
			}
		}
		setdvar("", "");
	#/
}

/*
	Name: updatedevsettingszm
	Namespace: dev
	Checksum: 0xC3AEE491
	Offset: 0xAA0
	Size: 0x454
	Parameters: 0
	Flags: None
*/
function updatedevsettingszm()
{
	/#
		if(level.players.size > 0)
		{
			if(getdvarstring("") == "")
			{
				if(!isdefined(level.streamdumpteamindex))
				{
					level.streamdumpteamindex = 0;
				}
				else
				{
					level.streamdumpteamindex++;
				}
				numpoints = 0;
				spawnpoints = [];
				location = level.scr_zm_map_start_location;
				if(location == "" || location == "" && isdefined(level.default_start_location))
				{
					location = level.default_start_location;
				}
				match_string = (level.scr_zm_ui_gametype + "") + location;
				if(level.streamdumpteamindex < level.teams.size)
				{
					structs = struct::get_array("", "");
					if(isdefined(structs))
					{
						foreach(struct in structs)
						{
							if(isdefined(struct.script_string))
							{
								tokens = strtok(struct.script_string, "");
								foreach(token in tokens)
								{
									if(token == match_string)
									{
										spawnpoints[spawnpoints.size] = struct;
									}
								}
							}
						}
					}
					if(!isdefined(spawnpoints) || spawnpoints.size == 0)
					{
						spawnpoints = struct::get_array("", "");
					}
					if(isdefined(spawnpoints))
					{
						numpoints = spawnpoints.size;
					}
				}
				if(numpoints == 0)
				{
					setdvar("", "");
					level.streamdumpteamindex = -1;
				}
				else
				{
					averageorigin = (0, 0, 0);
					averageangles = (0, 0, 0);
					foreach(spawnpoint in spawnpoints)
					{
						averageorigin = averageorigin + (spawnpoint.origin / numpoints);
						averageangles = averageangles + (spawnpoint.angles / numpoints);
					}
					level.players[0] setplayerangles(averageangles);
					level.players[0] setorigin(averageorigin);
					wait(0.05);
					setdvar("", "");
				}
			}
		}
	#/
}

/*
	Name: updatedevsettings
	Namespace: dev
	Checksum: 0xF469B382
	Offset: 0xF00
	Size: 0x1DC6
	Parameters: 0
	Flags: Linked
*/
function updatedevsettings()
{
	/#
		show_spawns = getdvarint("");
		show_start_spawns = getdvarint("");
		player = util::gethostplayer();
		if(show_spawns >= 1)
		{
			show_spawns = 1;
		}
		else
		{
			show_spawns = 0;
		}
		if(show_start_spawns >= 1)
		{
			show_start_spawns = 1;
		}
		else
		{
			show_start_spawns = 0;
		}
		if(!isdefined(level.show_spawns) || level.show_spawns != show_spawns)
		{
			level.show_spawns = show_spawns;
			setdvar("", level.show_spawns);
			if(level.show_spawns)
			{
				showspawnpoints();
			}
			else
			{
				hidespawnpoints();
			}
		}
		if(!isdefined(level.show_start_spawns) || level.show_start_spawns != show_start_spawns)
		{
			level.show_start_spawns = show_start_spawns;
			setdvar("", level.show_start_spawns);
			if(level.show_start_spawns)
			{
				showstartspawnpoints();
			}
			else
			{
				hidestartspawnpoints();
			}
		}
		updateminimapsetting();
		if(level.players.size > 0)
		{
			if(getdvarstring("") == "")
			{
				warpalltohost();
			}
			else
			{
				if(getdvarstring("") == "")
				{
					warpalltohost(getdvarstring(""));
				}
				else
				{
					if(getdvarstring("") == "")
					{
						warpalltohost(getdvarstring(""));
					}
					else
					{
						if(strstartswith(getdvarstring(""), ""))
						{
							name = getsubstr(getdvarstring(""), 8);
							warpalltoplayer(getdvarstring(""), name);
						}
						else
						{
							if(strstartswith(getdvarstring(""), ""))
							{
								name = getsubstr(getdvarstring(""), 11);
								warpalltoplayer(getdvarstring(""), name);
							}
							else
							{
								if(strstartswith(getdvarstring(""), ""))
								{
									name = getsubstr(getdvarstring(""), 4);
									warpalltoplayer(undefined, name);
								}
								else
								{
									if(getdvarstring("") == "")
									{
										players = getplayers();
										setdvar("", "");
										if(!isdefined(level.devgui_start_spawn_index))
										{
											level.devgui_start_spawn_index = 0;
										}
										player = util::gethostplayer();
										spawns = level.spawn_start[player.pers[""]];
										if(!isdefined(spawns) || spawns.size <= 0)
										{
											return;
										}
										for(i = 0; i < players.size; i++)
										{
											players[i] setorigin(spawns[level.devgui_start_spawn_index].origin);
											players[i] setplayerangles(spawns[level.devgui_start_spawn_index].angles);
										}
										level.devgui_start_spawn_index++;
										if(level.devgui_start_spawn_index >= spawns.size)
										{
											level.devgui_start_spawn_index = 0;
										}
									}
									else
									{
										if(getdvarstring("") == "")
										{
											players = getplayers();
											setdvar("", "");
											if(!isdefined(level.devgui_start_spawn_index))
											{
												level.devgui_start_spawn_index = 0;
											}
											player = util::gethostplayer();
											spawns = level.spawn_start[player.pers[""]];
											if(!isdefined(spawns) || spawns.size <= 0)
											{
												return;
											}
											for(i = 0; i < players.size; i++)
											{
												players[i] setorigin(spawns[level.devgui_start_spawn_index].origin);
												players[i] setplayerangles(spawns[level.devgui_start_spawn_index].angles);
											}
											level.devgui_start_spawn_index--;
											if(level.devgui_start_spawn_index < 0)
											{
												level.devgui_start_spawn_index = spawns.size - 1;
											}
										}
										else
										{
											if(getdvarstring("") == "")
											{
												players = getplayers();
												setdvar("", "");
												if(!isdefined(level.devgui_spawn_index))
												{
													level.devgui_spawn_index = 0;
												}
												spawns = level.spawnpoints;
												spawns = arraycombine(spawns, level.dem_spawns, 1, 0);
												if(!isdefined(spawns) || spawns.size <= 0)
												{
													return;
												}
												for(i = 0; i < players.size; i++)
												{
													players[i] setorigin(spawns[level.devgui_spawn_index].origin);
													players[i] setplayerangles(spawns[level.devgui_spawn_index].angles);
												}
												level.devgui_spawn_index++;
												if(level.devgui_spawn_index >= spawns.size)
												{
													level.devgui_spawn_index = 0;
												}
											}
											else
											{
												if(getdvarstring("") == "")
												{
													players = getplayers();
													setdvar("", "");
													if(!isdefined(level.devgui_spawn_index))
													{
														level.devgui_spawn_index = 0;
													}
													spawns = level.spawnpoints;
													spawns = arraycombine(spawns, level.dem_spawns, 1, 0);
													if(!isdefined(spawns) || spawns.size <= 0)
													{
														return;
													}
													for(i = 0; i < players.size; i++)
													{
														players[i] setorigin(spawns[level.devgui_spawn_index].origin);
														players[i] setplayerangles(spawns[level.devgui_spawn_index].angles);
													}
													level.devgui_spawn_index--;
													if(level.devgui_spawn_index < 0)
													{
														level.devgui_spawn_index = spawns.size - 1;
													}
												}
												else
												{
													if(getdvarstring("") != "")
													{
														player = util::gethostplayer();
														if(!isdefined(player.devgui_spawn_active))
														{
															player.devgui_spawn_active = 0;
														}
														if(!player.devgui_spawn_active)
														{
															iprintln("");
															iprintln("");
															player.devgui_spawn_active = 1;
															player thread devgui_spawn_think();
														}
														else
														{
															player notify(#"devgui_spawn_think");
															player.devgui_spawn_active = 0;
															player setactionslot(3, "");
														}
														setdvar("", "");
													}
													else
													{
														if(getdvarstring("") != "")
														{
															players = getplayers();
															if(!isdefined(level.devgui_unlimited_ammo))
															{
																level.devgui_unlimited_ammo = 1;
															}
															else
															{
																level.devgui_unlimited_ammo = !level.devgui_unlimited_ammo;
															}
															if(level.devgui_unlimited_ammo)
															{
																iprintln("");
															}
															else
															{
																iprintln("");
															}
															for(i = 0; i < players.size; i++)
															{
																if(level.devgui_unlimited_ammo)
																{
																	players[i] thread devgui_unlimited_ammo();
																	continue;
																}
																players[i] notify(#"devgui_unlimited_ammo");
															}
															setdvar("", "");
														}
														else
														{
															if(getdvarstring("") != "")
															{
																if(!isdefined(level.devgui_unlimited_momentum))
																{
																	level.devgui_unlimited_momentum = 1;
																}
																else
																{
																	level.devgui_unlimited_momentum = !level.devgui_unlimited_momentum;
																}
																if(level.devgui_unlimited_momentum)
																{
																	iprintln("");
																	level thread devgui_unlimited_momentum();
																}
																else
																{
																	iprintln("");
																	level notify(#"devgui_unlimited_momentum");
																}
																setdvar("", "");
															}
															else
															{
																if(getdvarstring("") != "")
																{
																	level thread devgui_increase_momentum(getdvarint(""));
																	setdvar("", "");
																}
																else
																{
																	if(getdvarstring("") != "")
																	{
																		players = getplayers();
																		for(i = 0; i < players.size; i++)
																		{
																			player = players[i];
																			weapons = player getweaponslist();
																			arrayremovevalue(weapons, level.weaponbasemelee);
																			for(j = 0; j < weapons.size; j++)
																			{
																				if(weapons[j] == level.weaponnone)
																				{
																					continue;
																				}
																				player setweaponammostock(weapons[j], 0);
																				player setweaponammoclip(weapons[j], 0);
																			}
																		}
																		setdvar("", "");
																	}
																	else
																	{
																		if(getdvarstring("") != "")
																		{
																			players = getplayers();
																			for(i = 0; i < players.size; i++)
																			{
																				player = players[i];
																				if(getdvarstring("") == "")
																				{
																					player setempjammed(0);
																					continue;
																				}
																				player setempjammed(1);
																			}
																			setdvar("", "");
																		}
																		else
																		{
																			if(getdvarstring("") != "")
																			{
																				if(!level.timerstopped)
																				{
																					iprintln("");
																					globallogic_utils::pausetimer();
																				}
																				else
																				{
																					iprintln("");
																					globallogic_utils::resumetimer();
																				}
																				setdvar("", "");
																			}
																			else
																			{
																				if(getdvarstring("") != "")
																				{
																					level globallogic::forceend();
																					setdvar("", "");
																				}
																				else if(getdvarstring("") != "")
																				{
																					if(!isdefined(level.devgui_show_hq))
																					{
																						level.devgui_show_hq = 0;
																					}
																					if(level.gametype == "" && isdefined(level.radios))
																					{
																						if(!level.devgui_show_hq)
																						{
																							for(i = 0; i < level.radios.size; i++)
																							{
																								color = (1, 0, 0);
																								level showonespawnpoint(level.radios[i], color, "", 32, "");
																							}
																						}
																						else
																						{
																							level notify(#"hide_hq_points");
																						}
																						level.devgui_show_hq = !level.devgui_show_hq;
																					}
																					setdvar("", "");
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			if(getdvarstring("") == "")
			{
				if(!isdefined(level.streamdumpteamindex))
				{
					level.streamdumpteamindex = 0;
				}
				else
				{
					level.streamdumpteamindex++;
				}
				numpoints = 0;
				if(level.streamdumpteamindex < level.teams.size)
				{
					teamname = getarraykeys(level.teams)[level.streamdumpteamindex];
					if(isdefined(level.spawn_start[teamname]))
					{
						numpoints = level.spawn_start[teamname].size;
					}
				}
				if(numpoints == 0)
				{
					setdvar("", "");
					level.streamdumpteamindex = -1;
				}
				else
				{
					averageorigin = (0, 0, 0);
					averageangles = (0, 0, 0);
					foreach(spawnpoint in level.spawn_start[teamname])
					{
						averageorigin = averageorigin + (spawnpoint.origin / numpoints);
						averageangles = averageangles + (spawnpoint.angles / numpoints);
					}
					level.players[0] setplayerangles(averageangles);
					level.players[0] setorigin(averageorigin);
					wait(0.05);
					setdvar("", "");
				}
			}
		}
		if(getdvarstring("") == "")
		{
			players = getplayers();
			iprintln("");
			for(i = 0; i < players.size; i++)
			{
				players[i] clearperks();
			}
			setdvar("", "");
		}
		if(getdvarstring("") != "")
		{
			perk = getdvarstring("");
			specialties = strtok(perk, "");
			players = getplayers();
			iprintln(("" + perk) + "");
			for(i = 0; i < players.size; i++)
			{
				for(j = 0; j < specialties.size; j++)
				{
					players[i] setperk(specialties[j]);
					players[i].extraperks[specialties[j]] = 1;
				}
			}
			setdvar("", "");
		}
		if(getdvarstring("") != "")
		{
			event = getdvarstring("");
			player = util::gethostplayer();
			forward = anglestoforward(player.angles);
			right = anglestoright(player.angles);
			if(event == "")
			{
				player dodamage(1, player.origin + forward);
			}
			else
			{
				if(event == "")
				{
					player dodamage(1, player.origin - forward);
				}
				else
				{
					if(event == "")
					{
						player dodamage(1, player.origin - right);
					}
					else if(event == "")
					{
						player dodamage(1, player.origin + right);
					}
				}
			}
			setdvar("", "");
		}
		if(getdvarstring("") != "")
		{
			perk = getdvarstring("");
			for(i = 0; i < level.players.size; i++)
			{
				level.players[i] unsetperk(perk);
				level.players[i].extraperks[perk] = undefined;
			}
			setdvar("", "");
		}
		if(getdvarstring("") != "")
		{
			nametokens = strtok(getdvarstring(""), "");
			if(nametokens.size > 1)
			{
				thread xkillsy(nametokens[0], nametokens[1]);
			}
			setdvar("", "");
		}
		if(getdvarstring("") != "")
		{
			for(i = 0; i < level.players.size; i++)
			{
				level.players[i] hud_message::oldnotifymessage(getdvarstring(""), getdvarstring(""), game[""][""]);
			}
			announcement(getdvarstring(""), 0);
			setdvar("", "");
		}
		if(getdvarstring("") != "")
		{
			ents = getentarray();
			level.entarray = [];
			level.entcounts = [];
			level.entgroups = [];
			for(index = 0; index < ents.size; index++)
			{
				classname = ents[index].classname;
				if(!issubstr(classname, ""))
				{
					curent = ents[index];
					level.entarray[level.entarray.size] = curent;
					if(!isdefined(level.entcounts[classname]))
					{
						level.entcounts[classname] = 0;
					}
					level.entcounts[classname]++;
					if(!isdefined(level.entgroups[classname]))
					{
						level.entgroups[classname] = [];
					}
					level.entgroups[classname][level.entgroups[classname].size] = curent;
				}
			}
		}
	#/
}

/*
	Name: devgui_spawn_think
	Namespace: dev
	Checksum: 0x7FEF9BC0
	Offset: 0x2CD0
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function devgui_spawn_think()
{
	/#
		self notify(#"devgui_spawn_think");
		self endon(#"devgui_spawn_think");
		self endon(#"disconnect");
		dpad_left = 0;
		dpad_right = 0;
		for(;;)
		{
			self setactionslot(3, "");
			self setactionslot(4, "");
			if(!dpad_left && self buttonpressed(""))
			{
				setdvar("", "");
				dpad_left = 1;
			}
			else if(!self buttonpressed(""))
			{
				dpad_left = 0;
			}
			if(!dpad_right && self buttonpressed(""))
			{
				setdvar("", "");
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
	Name: devgui_unlimited_ammo
	Namespace: dev
	Checksum: 0xB80672C5
	Offset: 0x2E68
	Size: 0x14A
	Parameters: 0
	Flags: Linked
*/
function devgui_unlimited_ammo()
{
	/#
		self notify(#"devgui_unlimited_ammo");
		self endon(#"devgui_unlimited_ammo");
		self endon(#"disconnect");
		for(;;)
		{
			wait(1);
			primary_weapons = self getweaponslistprimaries();
			offhand_weapons_and_alts = array::exclude(self getweaponslist(1), primary_weapons);
			weapons = arraycombine(primary_weapons, offhand_weapons_and_alts, 0, 0);
			arrayremovevalue(weapons, level.weaponbasemelee);
			for(i = 0; i < weapons.size; i++)
			{
				weapon = weapons[i];
				if(weapon == level.weaponnone)
				{
					continue;
				}
				self givemaxammo(weapon);
			}
		}
	#/
}

/*
	Name: devgui_unlimited_momentum
	Namespace: dev
	Checksum: 0xC615B559
	Offset: 0x2FC0
	Size: 0x11E
	Parameters: 0
	Flags: Linked
*/
function devgui_unlimited_momentum()
{
	/#
		level notify(#"devgui_unlimited_momentum");
		level endon(#"devgui_unlimited_momentum");
		for(;;)
		{
			wait(1);
			players = getplayers();
			foreach(player in players)
			{
				if(!isdefined(player))
				{
					continue;
				}
				if(!isalive(player))
				{
					continue;
				}
				if(player.sessionstate != "")
				{
					continue;
				}
				globallogic_score::_setplayermomentum(player, 5000);
			}
		}
	#/
}

/*
	Name: devgui_increase_momentum
	Namespace: dev
	Checksum: 0x5DE7DF38
	Offset: 0x30E8
	Size: 0x112
	Parameters: 1
	Flags: Linked
*/
function devgui_increase_momentum(score)
{
	/#
		players = getplayers();
		foreach(player in players)
		{
			if(!isdefined(player))
			{
				continue;
			}
			if(!isalive(player))
			{
				continue;
			}
			if(player.sessionstate != "")
			{
				continue;
			}
			player globallogic_score::giveplayermomentumnotification(score, &"", "", 0);
		}
	#/
}

/*
	Name: devgui_health_debug
	Namespace: dev
	Checksum: 0xF72FFC35
	Offset: 0x3208
	Size: 0x318
	Parameters: 0
	Flags: None
*/
function devgui_health_debug()
{
	/#
		self notify(#"devgui_health_debug");
		self endon(#"devgui_health_debug");
		self endon(#"disconnect");
		x = 80;
		y = 40;
		self.debug_health_bar = newclienthudelem(self);
		self.debug_health_bar.x = x + 80;
		self.debug_health_bar.y = y + 2;
		self.debug_health_bar.alignx = "";
		self.debug_health_bar.aligny = "";
		self.debug_health_bar.horzalign = "";
		self.debug_health_bar.vertalign = "";
		self.debug_health_bar.alpha = 1;
		self.debug_health_bar.foreground = 1;
		self.debug_health_bar setshader("", 1, 8);
		self.debug_health_text = newclienthudelem(self);
		self.debug_health_text.x = x + 80;
		self.debug_health_text.y = y;
		self.debug_health_text.alignx = "";
		self.debug_health_text.aligny = "";
		self.debug_health_text.horzalign = "";
		self.debug_health_text.vertalign = "";
		self.debug_health_text.alpha = 1;
		self.debug_health_text.fontscale = 1;
		self.debug_health_text.foreground = 1;
		if(!isdefined(self.maxhealth) || self.maxhealth <= 0)
		{
			self.maxhealth = 100;
		}
		for(;;)
		{
			wait(0.05);
			width = (self.health / self.maxhealth) * 300;
			width = int(max(width, 1));
			self.debug_health_bar setshader("", width, 8);
			self.debug_health_text setvalue(self.health);
		}
	#/
}

/*
	Name: giveextraperks
	Namespace: dev
	Checksum: 0x676A75FE
	Offset: 0x3528
	Size: 0xC6
	Parameters: 0
	Flags: None
*/
function giveextraperks()
{
	/#
		if(!isdefined(self.extraperks))
		{
			return;
		}
		perks = getarraykeys(self.extraperks);
		for(i = 0; i < perks.size; i++)
		{
			/#
				println(((("" + self.name) + "") + perks[i]) + "");
			#/
			self setperk(perks[i]);
		}
	#/
}

/*
	Name: xkillsy
	Namespace: dev
	Checksum: 0x6CC04F7A
	Offset: 0x35F8
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function xkillsy(attackername, victimname)
{
	/#
		attacker = undefined;
		victim = undefined;
		for(index = 0; index < level.players.size; index++)
		{
			if(level.players[index].name == attackername)
			{
				attacker = level.players[index];
				continue;
			}
			if(level.players[index].name == victimname)
			{
				victim = level.players[index];
			}
		}
		if(!isalive(attacker) || !isalive(victim))
		{
			return;
		}
		victim thread [[level.callbackplayerdamage]](attacker, attacker, 1000, 0, "", level.weaponnone, (0, 0, 0), (0, 0, 0), "", 0, 0);
	#/
}

/*
	Name: testscriptruntimeerrorassert
	Namespace: dev
	Checksum: 0xB5A5361C
	Offset: 0x3748
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
	Namespace: dev
	Checksum: 0x6C7AA9B3
	Offset: 0x3778
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
	Namespace: dev
	Checksum: 0xAF449B5
	Offset: 0x37C8
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
	Namespace: dev
	Checksum: 0x1DAB855B
	Offset: 0x37F0
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
	Name: testdvars
	Namespace: dev
	Checksum: 0xD2497C9A
	Offset: 0x38C8
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function testdvars()
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
		tokens = strtok(getdvarstring(""), "");
		dvarname = tokens[0];
		dvarvalue = tokens[1];
		setdvar(dvarname, dvarvalue);
		setdvar("", "");
		thread testdvars();
	#/
}

/*
	Name: showonespawnpoint
	Namespace: dev
	Checksum: 0xF9836ABD
	Offset: 0x39C8
	Size: 0x58C
	Parameters: 5
	Flags: Linked
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
	Name: showspawnpoints
	Namespace: dev
	Checksum: 0xA1F683B7
	Offset: 0x3F60
	Size: 0xE6
	Parameters: 0
	Flags: Linked
*/
function showspawnpoints()
{
	/#
		if(isdefined(level.spawnpoints))
		{
			color = (1, 1, 1);
			for(spawn_point_index = 0; spawn_point_index < level.spawnpoints.size; spawn_point_index++)
			{
				showonespawnpoint(level.spawnpoints[spawn_point_index], color, "");
			}
		}
		for(i = 0; i < level.dem_spawns.size; i++)
		{
			color = (0, 1, 0);
			showonespawnpoint(level.dem_spawns[i], color, "");
		}
	#/
}

/*
	Name: hidespawnpoints
	Namespace: dev
	Checksum: 0xA335972A
	Offset: 0x4050
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function hidespawnpoints()
{
	/#
		level notify(#"hide_spawnpoints");
	#/
}

/*
	Name: showstartspawnpoints
	Namespace: dev
	Checksum: 0x565BEBB1
	Offset: 0x4070
	Size: 0x220
	Parameters: 0
	Flags: Linked
*/
function showstartspawnpoints()
{
	/#
		if(!level.teambased)
		{
			return;
		}
		if(!isdefined(level.spawn_start))
		{
			return;
		}
		team_colors = [];
		team_colors[""] = (1, 0, 1);
		team_colors[""] = (0, 1, 1);
		team_colors[""] = (1, 1, 0);
		team_colors[""] = (0, 1, 0);
		team_colors[""] = (0, 0, 1);
		team_colors[""] = (1, 0.7, 0);
		team_colors[""] = (0.25, 0.25, 1);
		team_colors[""] = (0.88, 0, 1);
		foreach(team in level.teams)
		{
			color = team_colors[team];
			foreach(spawnpoint in level.spawn_start[team])
			{
				showonespawnpoint(spawnpoint, color, "");
			}
		}
	#/
}

/*
	Name: hidestartspawnpoints
	Namespace: dev
	Checksum: 0x3320C390
	Offset: 0x42A0
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function hidestartspawnpoints()
{
	/#
		level notify(#"hide_startspawnpoints");
	#/
}

/*
	Name: print3duntilnotified
	Namespace: dev
	Checksum: 0xBAF713B1
	Offset: 0x42C0
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
	Namespace: dev
	Checksum: 0x5E25762E
	Offset: 0x4338
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
	Name: dvar_turned_on
	Namespace: dev
	Checksum: 0x7C627ADA
	Offset: 0x43A8
	Size: 0x28
	Parameters: 1
	Flags: None
*/
function dvar_turned_on(val)
{
	/#
		if(val <= 0)
		{
			return false;
		}
		return true;
	#/
}

/*
	Name: new_hud
	Namespace: dev
	Checksum: 0x966535A
	Offset: 0x43E0
	Size: 0xC0
	Parameters: 5
	Flags: None
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
	Name: set_hudelem
	Namespace: dev
	Checksum: 0x16DDC577
	Offset: 0x44B0
	Size: 0x1A0
	Parameters: 7
	Flags: Linked
*/
function set_hudelem(text, x, y, scale, alpha, sort, debug_hudelem)
{
	/#
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
			hud = newdebughudelem();
			hud.debug_hudelem = 1;
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
	#/
}

/*
	Name: getattachmentchangemodifierbutton
	Namespace: dev
	Checksum: 0xA797B16D
	Offset: 0x4660
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function getattachmentchangemodifierbutton()
{
	/#
		return "";
	#/
}

/*
	Name: watchattachmentchange
	Namespace: dev
	Checksum: 0x48EF0A43
	Offset: 0x4678
	Size: 0x3AC
	Parameters: 0
	Flags: None
*/
function watchattachmentchange()
{
	/#
		self endon(#"disconnect");
		clientnum = self getentitynumber();
		if(clientnum != 0)
		{
			return;
		}
		dpad_left = 0;
		dpad_right = 0;
		dpad_up = 0;
		dpad_down = 0;
		lstick_down = 0;
		dpad_modifier_button = getattachmentchangemodifierbutton();
		for(;;)
		{
			if(self buttonpressed(dpad_modifier_button))
			{
				if(!dpad_left && self buttonpressed(""))
				{
					self giveweaponnextattachment("");
					dpad_left = 1;
					self thread print_weapon_name();
				}
				if(!dpad_right && self buttonpressed(""))
				{
					self giveweaponnextattachment("");
					dpad_right = 1;
					self thread print_weapon_name();
				}
				if(!dpad_up && self buttonpressed(""))
				{
					self giveweaponnextattachment("");
					dpad_up = 1;
					self thread print_weapon_name();
				}
				if(!dpad_down && self buttonpressed(""))
				{
					self giveweaponnextattachment("");
					dpad_down = 1;
					self thread print_weapon_name();
				}
				if(!lstick_down && self buttonpressed(""))
				{
					self giveweaponnextattachment("");
					lstick_down = 1;
					self thread print_weapon_name();
				}
			}
			if(!self buttonpressed(""))
			{
				dpad_left = 0;
			}
			if(!self buttonpressed(""))
			{
				dpad_right = 0;
			}
			if(!self buttonpressed(""))
			{
				dpad_up = 0;
			}
			if(!self buttonpressed(""))
			{
				dpad_down = 0;
			}
			if(!self buttonpressed(""))
			{
				lstick_down = 0;
			}
			wait(0.05);
		}
	#/
}

/*
	Name: print_weapon_name
	Namespace: dev
	Checksum: 0xFC0A9F7F
	Offset: 0x4A30
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function print_weapon_name()
{
	/#
		self notify(#"print_weapon_name");
		self endon(#"print_weapon_name");
		wait(0.2);
		if(self isswitchingweapons())
		{
			self waittill(#"weapon_change_complete", weapon);
			fail_safe = 0;
			while(weapon == level.weaponnone)
			{
				self waittill(#"weapon_change_complete", weapon);
				wait(0.05);
				fail_safe++;
				if(fail_safe > 120)
				{
					break;
				}
			}
		}
		else
		{
			weapon = self getcurrentweapon();
		}
		printweaponname = getdvarint("", 1);
		if(printweaponname)
		{
			iprintlnbold(weapon.name);
		}
	#/
}

/*
	Name: set_equipment_list
	Namespace: dev
	Checksum: 0x99911C09
	Offset: 0x4B58
	Size: 0x18A
	Parameters: 0
	Flags: Linked
*/
function set_equipment_list()
{
	/#
		if(isdefined(level.dev_equipment))
		{
			return;
		}
		level.dev_equipment = [];
		level.dev_equipment[1] = getweapon("");
		level.dev_equipment[2] = getweapon("");
		level.dev_equipment[3] = getweapon("");
		level.dev_equipment[4] = getweapon("");
		level.dev_equipment[5] = getweapon("");
		level.dev_equipment[6] = getweapon("");
		level.dev_equipment[7] = getweapon("");
		level.dev_equipment[8] = getweapon("");
		level.dev_equipment[9] = getweapon("");
	#/
}

/*
	Name: set_grenade_list
	Namespace: dev
	Checksum: 0xE61B4E5D
	Offset: 0x4CF0
	Size: 0x1B2
	Parameters: 0
	Flags: Linked
*/
function set_grenade_list()
{
	/#
		if(isdefined(level.dev_grenade))
		{
			return;
		}
		level.dev_grenade = [];
		level.dev_grenade[1] = getweapon("");
		level.dev_grenade[2] = getweapon("");
		level.dev_grenade[3] = getweapon("");
		level.dev_grenade[4] = getweapon("");
		level.dev_grenade[5] = getweapon("");
		level.dev_grenade[6] = getweapon("");
		level.dev_grenade[7] = getweapon("");
		level.dev_grenade[8] = getweapon("");
		level.dev_grenade[9] = getweapon("");
		level.dev_grenade[10] = getweapon("");
	#/
}

/*
	Name: take_all_grenades_and_equipment
	Namespace: dev
	Checksum: 0x52574342
	Offset: 0x4EB0
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function take_all_grenades_and_equipment(player)
{
	/#
		for(i = 0; i < level.dev_equipment.size; i++)
		{
			player takeweapon(level.dev_equipment[i + 1]);
		}
		for(i = 0; i < level.dev_grenade.size; i++)
		{
			player takeweapon(level.dev_grenade[i + 1]);
		}
	#/
}

/*
	Name: equipment_dev_gui
	Namespace: dev
	Checksum: 0xDE08C1BB
	Offset: 0x4F70
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function equipment_dev_gui()
{
	/#
		set_equipment_list();
		set_grenade_list();
		setdvar("", "");
		while(true)
		{
			wait(0.5);
			devgui_int = getdvarint("");
			if(devgui_int != 0)
			{
				for(i = 0; i < level.players.size; i++)
				{
					take_all_grenades_and_equipment(level.players[i]);
					level.players[i] giveweapon(level.dev_equipment[devgui_int]);
				}
				setdvar("", "");
			}
		}
	#/
}

/*
	Name: grenade_dev_gui
	Namespace: dev
	Checksum: 0x1A1DB87A
	Offset: 0x50A0
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function grenade_dev_gui()
{
	/#
		set_equipment_list();
		set_grenade_list();
		setdvar("", "");
		while(true)
		{
			wait(0.5);
			devgui_int = getdvarint("");
			if(devgui_int != 0)
			{
				for(i = 0; i < level.players.size; i++)
				{
					take_all_grenades_and_equipment(level.players[i]);
					level.players[i] giveweapon(level.dev_grenade[devgui_int]);
				}
				setdvar("", "");
			}
		}
	#/
}

/*
	Name: devstraferunpathdebugdraw
	Namespace: dev
	Checksum: 0xA0FEAB5D
	Offset: 0x51D0
	Size: 0x49A
	Parameters: 0
	Flags: Linked
*/
function devstraferunpathdebugdraw()
{
	/#
		white = (1, 1, 1);
		red = (1, 0, 0);
		green = (0, 1, 0);
		blue = (0, 0, 1);
		violet = (0.4, 0, 0.6);
		maxdrawtime = 10;
		drawtime = maxdrawtime;
		origintextoffset = vectorscale((0, 0, -1), 50);
		endonmsg = "";
		while(true)
		{
			if(getdvarint("") > 0)
			{
				nodes = [];
				end = 0;
				node = getvehiclenode("", "");
				if(!isdefined(node))
				{
					println("");
					setdvar("", "");
					continue;
				}
				while(isdefined(node.target))
				{
					new_node = getvehiclenode(node.target, "");
					foreach(n in nodes)
					{
						if(n == new_node)
						{
							end = 1;
						}
					}
					textscale = 30;
					if(drawtime == maxdrawtime)
					{
						node thread drawpathsegment(new_node, violet, violet, 1, textscale, origintextoffset, drawtime, endonmsg);
					}
					if(isdefined(node.script_noteworthy))
					{
						textscale = 10;
						switch(node.script_noteworthy)
						{
							case "":
							{
								textcolor = green;
								textalpha = 1;
								break;
							}
							case "":
							{
								textcolor = red;
								textalpha = 1;
								break;
							}
							case "":
							{
								textcolor = white;
								textalpha = 1;
								break;
							}
						}
						switch(node.script_noteworthy)
						{
							case "":
							case "":
							case "":
							{
								sides = 10;
								radius = 100;
								if(drawtime == maxdrawtime)
								{
									sphere(node.origin, radius, textcolor, textalpha, 1, sides, drawtime * 1000);
								}
								node draworiginlines();
								node drawnoteworthytext(textcolor, textalpha, textscale);
								break;
							}
						}
					}
					if(end)
					{
						break;
					}
					nodes[nodes.size] = new_node;
					node = new_node;
				}
				drawtime = drawtime - 0.05;
				if(drawtime < 0)
				{
					drawtime = maxdrawtime;
				}
				wait(0.05);
			}
			else
			{
				wait(1);
			}
		}
	#/
}

/*
	Name: devhelipathdebugdraw
	Namespace: dev
	Checksum: 0x49642BBD
	Offset: 0x5678
	Size: 0x3C0
	Parameters: 0
	Flags: Linked
*/
function devhelipathdebugdraw()
{
	/#
		white = (1, 1, 1);
		red = (1, 0, 0);
		green = (0, 1, 0);
		blue = (0, 0, 1);
		textcolor = white;
		textalpha = 1;
		textscale = 1;
		maxdrawtime = 10;
		drawtime = maxdrawtime;
		origintextoffset = vectorscale((0, 0, -1), 50);
		endonmsg = "";
		while(true)
		{
			if(getdvarint("") > 0)
			{
				script_origins = getentarray("", "");
				foreach(ent in script_origins)
				{
					if(isdefined(ent.targetname))
					{
						switch(ent.targetname)
						{
							case "":
							{
								textcolor = blue;
								textalpha = 1;
								textscale = 3;
								break;
							}
							case "":
							{
								textcolor = green;
								textalpha = 1;
								textscale = 3;
								break;
							}
							case "":
							{
								textcolor = red;
								textalpha = 1;
								textscale = 3;
								break;
							}
							case "":
							{
								textcolor = white;
								textalpha = 1;
								textscale = 3;
								break;
							}
						}
						switch(ent.targetname)
						{
							case "":
							case "":
							case "":
							case "":
							{
								if(drawtime == maxdrawtime)
								{
									ent thread drawpath(textcolor, white, textalpha, textscale, origintextoffset, drawtime, endonmsg);
								}
								ent draworiginlines();
								ent drawtargetnametext(textcolor, textalpha, textscale);
								ent draworigintext(textcolor, textalpha, textscale, origintextoffset);
								break;
							}
						}
					}
				}
				drawtime = drawtime - 0.05;
				if(drawtime < 0)
				{
					drawtime = maxdrawtime;
				}
			}
			if(getdvarint("") == 0)
			{
				level notify(endonmsg);
				drawtime = maxdrawtime;
				wait(1);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: draworiginlines
	Namespace: dev
	Checksum: 0x2F4EF59E
	Offset: 0x5A40
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function draworiginlines()
{
	/#
		red = (1, 0, 0);
		green = (0, 1, 0);
		blue = (0, 0, 1);
		line(self.origin, self.origin + (anglestoforward(self.angles) * 10), red);
		line(self.origin, self.origin + (anglestoright(self.angles) * 10), green);
		line(self.origin, self.origin + (anglestoup(self.angles) * 10), blue);
	#/
}

/*
	Name: drawtargetnametext
	Namespace: dev
	Checksum: 0x2250E984
	Offset: 0x5B60
	Size: 0x74
	Parameters: 4
	Flags: Linked
*/
function drawtargetnametext(textcolor, textalpha, textscale, textoffset)
{
	/#
		if(!isdefined(textoffset))
		{
			textoffset = (0, 0, 0);
		}
		print3d(self.origin + textoffset, self.targetname, textcolor, textalpha, textscale);
	#/
}

/*
	Name: drawnoteworthytext
	Namespace: dev
	Checksum: 0xE47BE90
	Offset: 0x5BE0
	Size: 0x74
	Parameters: 4
	Flags: Linked
*/
function drawnoteworthytext(textcolor, textalpha, textscale, textoffset)
{
	/#
		if(!isdefined(textoffset))
		{
			textoffset = (0, 0, 0);
		}
		print3d(self.origin + textoffset, self.script_noteworthy, textcolor, textalpha, textscale);
	#/
}

/*
	Name: draworigintext
	Namespace: dev
	Checksum: 0x4E1414B4
	Offset: 0x5C60
	Size: 0xC4
	Parameters: 4
	Flags: Linked
*/
function draworigintext(textcolor, textalpha, textscale, textoffset)
{
	/#
		if(!isdefined(textoffset))
		{
			textoffset = (0, 0, 0);
		}
		originstring = ((((("" + self.origin[0]) + "") + self.origin[1]) + "") + self.origin[2]) + "";
		print3d(self.origin + textoffset, originstring, textcolor, textalpha, textscale);
	#/
}

/*
	Name: drawspeedacceltext
	Namespace: dev
	Checksum: 0x6290D8AE
	Offset: 0x5D30
	Size: 0xDC
	Parameters: 4
	Flags: Linked
*/
function drawspeedacceltext(textcolor, textalpha, textscale, textoffset)
{
	/#
		if(isdefined(self.script_airspeed))
		{
			print3d(self.origin + (0, 0, textoffset[2] * 2), "" + self.script_airspeed, textcolor, textalpha, textscale);
		}
		if(isdefined(self.script_accel))
		{
			print3d(self.origin + (0, 0, textoffset[2] * 3), "" + self.script_accel, textcolor, textalpha, textscale);
		}
	#/
}

/*
	Name: drawpath
	Namespace: dev
	Checksum: 0x70C8ACFB
	Offset: 0x5E18
	Size: 0x154
	Parameters: 7
	Flags: Linked
*/
function drawpath(linecolor, textcolor, textalpha, textscale, textoffset, drawtime, endonmsg)
{
	/#
		level endon(endonmsg);
		ent = self;
		entfirsttarget = ent.targetname;
		while(isdefined(ent.target))
		{
			enttarget = getent(ent.target, "");
			ent thread drawpathsegment(enttarget, linecolor, textcolor, textalpha, textscale, textoffset, drawtime, endonmsg);
			if(ent.targetname == "")
			{
				entfirsttarget = ent.target;
			}
			else if(ent.target == entfirsttarget)
			{
				break;
			}
			ent = enttarget;
			wait(0.05);
		}
	#/
}

/*
	Name: drawpathsegment
	Namespace: dev
	Checksum: 0x6013EAA1
	Offset: 0x5F78
	Size: 0x124
	Parameters: 8
	Flags: Linked
*/
function drawpathsegment(enttarget, linecolor, textcolor, textalpha, textscale, textoffset, drawtime, endonmsg)
{
	/#
		level endon(endonmsg);
		while(drawtime > 0)
		{
			if(isdefined(self.targetname) && self.targetname == "")
			{
				print3d(self.origin + textoffset, self.targetname, textcolor, textalpha, textscale);
			}
			line(self.origin, enttarget.origin, linecolor);
			self drawspeedacceltext(textcolor, textalpha, textscale, textoffset);
			drawtime = drawtime - 0.05;
			wait(0.05);
		}
	#/
}

/*
	Name: get_lookat_origin
	Namespace: dev
	Checksum: 0x7B3EFDB4
	Offset: 0x60A8
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function get_lookat_origin(player)
{
	/#
		angles = player getplayerangles();
		forward = anglestoforward(angles);
		dir = vectorscale(forward, 8000);
		eye = player geteye();
		trace = bullettrace(eye, eye + dir, 0, undefined);
		return trace[""];
	#/
}

/*
	Name: draw_pathnode
	Namespace: dev
	Checksum: 0x7DDCFFEB
	Offset: 0x6178
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function draw_pathnode(node, color)
{
	/#
		if(!isdefined(color))
		{
			color = (1, 0, 1);
		}
		box(node.origin, vectorscale((-1, -1, 0), 16), vectorscale((1, 1, 1), 16), 0, color, 1, 0, 1);
	#/
}

/*
	Name: draw_pathnode_think
	Namespace: dev
	Checksum: 0xDF9A0CFC
	Offset: 0x61F8
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function draw_pathnode_think(node, color)
{
	/#
		level endon(#"draw_pathnode_stop");
		for(;;)
		{
			draw_pathnode(node, color);
			wait(0.05);
		}
	#/
}

/*
	Name: draw_pathnodes_stop
	Namespace: dev
	Checksum: 0x3BA9E3FC
	Offset: 0x6248
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function draw_pathnodes_stop()
{
	/#
		wait(5);
		level notify(#"draw_pathnode_stop");
	#/
}

/*
	Name: node_get
	Namespace: dev
	Checksum: 0xFF2042AF
	Offset: 0x6270
	Size: 0x120
	Parameters: 1
	Flags: Linked
*/
function node_get(player)
{
	/#
		for(;;)
		{
			wait(0.05);
			origin = get_lookat_origin(player);
			node = getnearestnode(origin);
			if(!isdefined(node))
			{
				continue;
			}
			if(player buttonpressed(""))
			{
				return node;
			}
			if(player buttonpressed(""))
			{
				return undefined;
			}
			if(node.type == "")
			{
				draw_pathnode(node, (1, 0, 1));
				continue;
			}
			draw_pathnode(node, (0.85, 0.85, 0.1));
		}
	#/
}

/*
	Name: dev_get_node_pair
	Namespace: dev
	Checksum: 0x8619B1A7
	Offset: 0x6398
	Size: 0x1A6
	Parameters: 0
	Flags: None
*/
function dev_get_node_pair()
{
	/#
		player = util::gethostplayer();
		start = undefined;
		while(!isdefined(start))
		{
			start = node_get(player);
			if(player buttonpressed(""))
			{
				level notify(#"draw_pathnode_stop");
				return undefined;
			}
		}
		level thread draw_pathnode_think(start, (0, 1, 0));
		while(player buttonpressed(""))
		{
			wait(0.05);
		}
		end = undefined;
		while(!isdefined(end))
		{
			end = node_get(player);
			if(player buttonpressed(""))
			{
				level notify(#"draw_pathnode_stop");
				return undefined;
			}
		}
		level thread draw_pathnode_think(end, (0, 1, 0));
		level thread draw_pathnodes_stop();
		array = [];
		array[0] = start;
		array[1] = end;
		return array;
	#/
}

/*
	Name: draw_point
	Namespace: dev
	Checksum: 0x98E37D0A
	Offset: 0x6548
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function draw_point(origin, color)
{
	/#
		if(!isdefined(color))
		{
			color = (1, 0, 1);
		}
		sphere(origin, 16, color, 0.25, 0, 16, 1);
	#/
}

/*
	Name: point_get
	Namespace: dev
	Checksum: 0xA73E3740
	Offset: 0x65B0
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function point_get(player)
{
	/#
		for(;;)
		{
			wait(0.05);
			origin = get_lookat_origin(player);
			if(player buttonpressed(""))
			{
				return origin;
			}
			if(player buttonpressed(""))
			{
				return undefined;
			}
			draw_point(origin, (1, 0, 1));
		}
	#/
}

/*
	Name: dev_get_point_pair
	Namespace: dev
	Checksum: 0x510A2EAE
	Offset: 0x6658
	Size: 0x11E
	Parameters: 0
	Flags: None
*/
function dev_get_point_pair()
{
	/#
		player = util::gethostplayer();
		start = undefined;
		points = [];
		while(!isdefined(start))
		{
			start = point_get(player);
			if(!isdefined(start))
			{
				return points;
			}
		}
		while(player buttonpressed(""))
		{
			wait(0.05);
		}
		end = undefined;
		while(!isdefined(end))
		{
			end = point_get(player);
			if(!isdefined(end))
			{
				return points;
			}
		}
		points[0] = start;
		points[1] = end;
		return points;
	#/
}

