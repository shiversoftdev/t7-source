// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_dev_class;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hud_message;
#using scripts\mp\gametypes\_killcam;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_helicopter_gunner;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_supplydrop;
#using scripts\mp\killstreaks\_uav;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace dev;

/*
	Name: __init__sytem__
	Namespace: dev
	Checksum: 0xC847BBC1
	Offset: 0x3E0
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
	Checksum: 0x3577BE2F
	Offset: 0x428
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connected);
	level.devongetormakebot = &getormakebot;
}

/*
	Name: init
	Namespace: dev
	Checksum: 0x13BE6343
	Offset: 0x490
	Size: 0x4A0
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
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		thread testscriptruntimeerror();
		thread testdvars();
		thread addenemyheli();
		thread addtestcarepackage();
		thread watch_botsdvars();
		thread devhelipathdebugdraw();
		thread devstraferunpathdebugdraw();
		thread dev_class::dev_cac_init();
		thread globallogic_score::setplayermomentumdebug();
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		thread engagement_distance_debug_toggle();
		thread equipment_dev_gui();
		thread grenade_dev_gui();
		setdvar("", "");
		level.bot_overlay = 0;
		level.bot_threat = 0;
		level.bot_path = 0;
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
		for(;;)
		{
			updatedevsettings();
			wait(0.5);
		}
	#/
}

/*
	Name: on_player_connected
	Namespace: dev
	Checksum: 0xE27529EC
	Offset: 0x938
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function on_player_connected()
{
	/#
		if(isdefined(level.devgui_unlimited_ammo) && level.devgui_unlimited_ammo)
		{
			wait(1);
			self thread devgui_unlimited_ammo();
		}
	#/
}

/*
	Name: updatehardpoints
	Namespace: dev
	Checksum: 0x11700FD3
	Offset: 0x980
	Size: 0x46E
	Parameters: 0
	Flags: Linked
*/
function updatehardpoints()
{
	/#
		keys = getarraykeys(level.killstreaks);
		for(i = 0; i < keys.size; i++)
		{
			dvar = level.killstreaks[keys[i]].devdvar;
			enemydvar = level.killstreaks[keys[i]].devenemydvar;
			host = util::gethostplayer();
			if(isdefined(dvar) && getdvarint(dvar) == 1)
			{
				if(keys[i] == "")
				{
					if(isdefined(level.vtol))
					{
						iprintln("");
					}
					else
					{
						host killstreaks::give("" + keys[i]);
					}
				}
				else
				{
					foreach(player in level.players)
					{
						if(isdefined(level.usingmomentum) && level.usingmomentum && (isdefined(level.usingscorestreaks) && level.usingscorestreaks))
						{
							player killstreaks::give("" + keys[i]);
							continue;
						}
						if(player util::is_bot())
						{
							player.bot[""] = [];
							player.bot[""][0] = killstreaks::get_menu_name(keys[i]);
							killstreakweapon = killstreaks::get_killstreak_weapon(keys[i]);
							player killstreaks::give_weapon(killstreakweapon, 1);
							globallogic_score::_setplayermomentum(player, 2000);
							continue;
						}
						player killstreaks::give("" + keys[i]);
					}
				}
				setdvar(dvar, "");
			}
			if(isdefined(enemydvar) && getdvarint(enemydvar) == 1)
			{
				team = "";
				player = util::gethostplayer();
				if(isdefined(player.team))
				{
					team = util::getotherteam(player.team);
				}
				ent = getormakebot(team);
				if(!isdefined(ent))
				{
					println("");
					continue;
				}
				wait(1);
				ent killstreaks::give("" + keys[i]);
				setdvar(enemydvar, "");
			}
		}
	#/
}

/*
	Name: updateteamops
	Namespace: dev
	Checksum: 0x94DF881F
	Offset: 0xDF8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function updateteamops()
{
	/#
		teamops = getdvarstring(level.teamops_dvar);
		if(getdvarstring(level.teamops_dvar) != "")
		{
			teamops::startteamops(teamops);
			setdvar(level.teamops_dvar, "");
		}
	#/
}

/*
	Name: warpalltohost
	Namespace: dev
	Checksum: 0xA451EAB2
	Offset: 0xE90
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
	Checksum: 0x6D1D1EA2
	Offset: 0xEF0
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
	Checksum: 0x8C070C5
	Offset: 0x1270
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
					wait(5);
					setdvar("", "");
				}
			}
		}
	#/
}

/*
	Name: updatedevsettings
	Namespace: dev
	Checksum: 0xE5697C3C
	Offset: 0x16D0
	Size: 0x24DE
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
			updatehardpoints();
			updateteamops();
			playerwarp_string = getdvarstring("");
			if(playerwarp_string == "")
			{
				warpalltohost();
			}
			else
			{
				if(playerwarp_string == "")
				{
					warpalltohost(playerwarp_string);
				}
				else
				{
					if(playerwarp_string == "")
					{
						warpalltohost(playerwarp_string);
					}
					else
					{
						if(strstartswith(playerwarp_string, ""))
						{
							name = getsubstr(playerwarp_string, 8);
							warpalltoplayer(playerwarp_string, name);
						}
						else
						{
							if(strstartswith(playerwarp_string, ""))
							{
								name = getsubstr(playerwarp_string, 11);
								warpalltoplayer(playerwarp_string, name);
							}
							else
							{
								if(strstartswith(playerwarp_string, ""))
								{
									name = getsubstr(playerwarp_string, 4);
									warpalltoplayer(undefined, name);
								}
								else
								{
									if(playerwarp_string == "")
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
										if(playerwarp_string == "")
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
											if(playerwarp_string == "")
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
												if(playerwarp_string == "")
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
																				else
																				{
																					if(getdvarstring("") != "")
																					{
																						players = getplayers();
																						host = util::gethostplayer();
																						if(!isdefined(host.devgui_health_debug))
																						{
																							host.devgui_health_debug = 0;
																						}
																						if(host.devgui_health_debug)
																						{
																							host.devgui_health_debug = 0;
																							for(i = 0; i < players.size; i++)
																							{
																								players[i] notify(#"devgui_health_debug");
																								if(isdefined(players[i].debug_health_bar))
																								{
																									players[i].debug_health_bar destroy();
																									players[i].debug_health_text destroy();
																									players[i].debug_health_bar = undefined;
																									players[i].debug_health_text = undefined;
																								}
																							}
																						}
																						else
																						{
																							host.devgui_health_debug = 1;
																							for(i = 0; i < players.size; i++)
																							{
																								players[i] thread devgui_health_debug();
																							}
																						}
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
					wait(5);
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
			force_grenade_throw(getweapon(getdvarstring("")));
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
			ownername = getdvarstring("");
			setdvar("", "");
			owner = undefined;
			for(index = 0; index < level.players.size; index++)
			{
				if(level.players[index].name == ownername)
				{
					owner = level.players[index];
				}
			}
			if(isdefined(owner))
			{
				owner killstreaks::trigger_killstreak("");
			}
		}
		if(getdvarstring("") != "")
		{
			player.pers[""] = 0;
			player.pers[""] = 0;
			newrank = min(getdvarint(""), 54);
			newrank = max(newrank, 1);
			setdvar("", "");
			lastxp = 0;
			for(index = 0; index <= newrank; index++)
			{
				newxp = rank::getrankinfominxp(index);
				player thread rank::giverankxp("", newxp - lastxp);
				lastxp = newxp;
				wait(0.25);
				self notify(#"cancel_notify");
			}
		}
		if(getdvarstring("") != "")
		{
			player thread rank::giverankxp("", getdvarint(""), 1);
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
		if(getdvarstring("") == "" && !isdefined(level.larry))
		{
			thread larry_thread();
		}
		else if(getdvarstring("") == "")
		{
			level notify(#"kill_larry");
		}
		if(level.bot_overlay == 0 && getdvarint("") == 1)
		{
			level thread bot_overlay_think();
			level.bot_overlay = 1;
		}
		else if(level.bot_overlay == 1 && getdvarint("") == 0)
		{
			level bot_overlay_stop();
			level.bot_overlay = 0;
		}
		if(level.bot_threat == 0 && getdvarint("") == 1)
		{
			level thread bot_threat_think();
			level.bot_threat = 1;
		}
		else if(level.bot_threat == 1 && getdvarint("") == 0)
		{
			level bot_threat_stop();
			level.bot_threat = 0;
		}
		if(level.bot_path == 0 && getdvarint("") == 1)
		{
			level thread bot_path_think();
			level.bot_path = 1;
		}
		else if(level.bot_path == 1 && getdvarint("") == 0)
		{
			level bot_path_stop();
			level.bot_path = 0;
		}
		if(getdvarint("") == 1)
		{
			level thread killcam::do_final_killcam();
			level thread waitthennotifyfinalkillcam();
		}
		if(getdvarint("") == 1)
		{
			level thread killcam::do_final_killcam();
			level thread waitthennotifyroundkillcam();
		}
		if(!level.bot_overlay && !level.bot_threat && !level.bot_path)
		{
			level notify(#"bot_dpad_terminate");
		}
	#/
}

/*
	Name: waitthennotifyroundkillcam
	Namespace: dev
	Checksum: 0xAA2F7617
	Offset: 0x3BB8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function waitthennotifyroundkillcam()
{
	/#
		wait(0.05);
		level notify(#"play_final_killcam");
		setdvar("", 0);
	#/
}

/*
	Name: waitthennotifyfinalkillcam
	Namespace: dev
	Checksum: 0xDADD415A
	Offset: 0x3C00
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function waitthennotifyfinalkillcam()
{
	/#
		wait(0.05);
		level notify(#"play_final_killcam");
		wait(0.05);
		setdvar("", 0);
	#/
}

/*
	Name: devgui_spawn_think
	Namespace: dev
	Checksum: 0x2B40E928
	Offset: 0x3C50
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
	Checksum: 0x27A030A3
	Offset: 0x3DE8
	Size: 0x162
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
				if(killstreaks::is_killstreak_weapon(weapon))
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
	Checksum: 0x71B2D8B6
	Offset: 0x3F58
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
	Checksum: 0x50FB2A68
	Offset: 0x4080
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
			player globallogic_score::giveplayermomentumnotification(score, &"", "");
		}
	#/
}

/*
	Name: devgui_health_debug
	Namespace: dev
	Checksum: 0x156BCB9F
	Offset: 0x41A0
	Size: 0x318
	Parameters: 0
	Flags: Linked
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
	Checksum: 0xE50D0B39
	Offset: 0x44C0
	Size: 0xC6
	Parameters: 0
	Flags: Linked
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
	Checksum: 0xBC81E1ED
	Offset: 0x4590
	Size: 0x14C
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
		victim thread [[level.callbackplayerdamage]](attacker, attacker, 1000, 0, "", level.weaponnone, (0, 0, 0), (0, 0, 0), "", (0, 0, 0), 0, 0, (1, 0, 0));
	#/
}

/*
	Name: testscriptruntimeerrorassert
	Namespace: dev
	Checksum: 0x23FC05B7
	Offset: 0x46E8
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
	Name: testscriptruntimeassertmsgassert
	Namespace: dev
	Checksum: 0xF0D6B813
	Offset: 0x4718
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function testscriptruntimeassertmsgassert()
{
	/#
		wait(1);
		/#
			assertmsg("");
		#/
	#/
}

/*
	Name: testscriptruntimeerrormsgassert
	Namespace: dev
	Checksum: 0x6AB82F7
	Offset: 0x4750
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function testscriptruntimeerrormsgassert()
{
	/#
		wait(1);
		/#
			errormsg("");
		#/
	#/
}

/*
	Name: testscriptruntimeerror2
	Namespace: dev
	Checksum: 0x967402EB
	Offset: 0x4788
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
	Checksum: 0x99F770E5
	Offset: 0x47D8
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
	Checksum: 0x8F8AF74D
	Offset: 0x4800
	Size: 0x11C
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
			if(myerror == "")
			{
				testscriptruntimeassertmsgassert();
			}
			else
			{
				if(myerror == "")
				{
					testscriptruntimeerrormsgassert();
				}
				else
				{
					testscriptruntimeerror1();
				}
			}
		}
		thread testscriptruntimeerror();
	#/
}

/*
	Name: testdvars
	Namespace: dev
	Checksum: 0x85EEF04E
	Offset: 0x4928
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
	Name: addenemyheli
	Namespace: dev
	Checksum: 0x953B8AD6
	Offset: 0x4A28
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function addenemyheli()
{
	/#
		wait(5);
		for(;;)
		{
			if(getdvarint("") > 0)
			{
				break;
			}
			wait(1);
		}
		enemyheli = getdvarint("");
		setdvar("", 0);
		team = "";
		player = util::gethostplayer();
		if(isdefined(player.pers[""]))
		{
			team = util::getotherteam(player.pers[""]);
		}
		ent = getormakebot(team);
		if(!isdefined(ent))
		{
			println("");
			wait(1);
			thread addenemyheli();
			return;
		}
		switch(enemyheli)
		{
			case 1:
			{
				level.helilocation = ent.origin;
				ent thread helicopter::usekillstreakhelicopter("");
				wait(0.5);
				ent notify(#"confirm_location", level.helilocation);
				break;
			}
			case 2:
			{
				break;
			}
		}
		thread addenemyheli();
	#/
}

/*
	Name: getormakebot
	Namespace: dev
	Checksum: 0xAED7C259
	Offset: 0x4C18
	Size: 0x106
	Parameters: 1
	Flags: Linked
*/
function getormakebot(team)
{
	/#
		for(i = 0; i < level.players.size; i++)
		{
			if(level.players[i].team == team)
			{
				if(isdefined(level.players[i].pers[""]) && level.players[i].pers[""])
				{
					return level.players[i];
				}
			}
		}
		ent = bot::add_bot(team);
		if(isdefined(ent))
		{
			sound::play_on_players("");
			wait(1);
		}
		return ent;
	#/
}

/*
	Name: addtestcarepackage
	Namespace: dev
	Checksum: 0xD723E670
	Offset: 0x4D28
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function addtestcarepackage()
{
	/#
		wait(5);
		for(;;)
		{
			if(getdvarint("") > 0)
			{
				break;
			}
			wait(1);
		}
		supplydrop = getdvarint("");
		team = "";
		player = util::gethostplayer();
		if(isdefined(player.pers[""]))
		{
			switch(supplydrop)
			{
				case 2:
				{
					team = util::getotherteam(player.pers[""]);
					break;
				}
				case 1:
				default:
				{
					team = player.pers[""];
					break;
				}
			}
		}
		setdvar("", 0);
		ent = getormakebot(team);
		if(!isdefined(ent))
		{
			println("");
			wait(1);
			thread addtestcarepackage();
			return;
		}
		ent killstreakrules::killstreakstart("", team);
		ent thread supplydrop::helidelivercrate(ent.origin, getweapon(""), ent, team);
		thread addtestcarepackage();
	#/
}

/*
	Name: showonespawnpoint
	Namespace: dev
	Checksum: 0x5FA1B150
	Offset: 0x4F40
	Size: 0x5B4
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
			if(level.convert_spawns_to_structs)
			{
				print = spawn_point.targetname;
			}
			else
			{
				print = spawn_point.classname;
			}
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
	Checksum: 0x873925CD
	Offset: 0x5500
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
	Checksum: 0x8F477CDA
	Offset: 0x55F0
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
	Checksum: 0x19DA8736
	Offset: 0x5610
	Size: 0x2BA
	Parameters: 0
	Flags: Linked
*/
function showstartspawnpoints()
{
	/#
		if(!isdefined(level.spawn_start))
		{
			return;
		}
		if(level.teambased)
		{
			team_colors = [];
			team_colors[""] = (1, 0, 1);
			team_colors[""] = (0, 1, 1);
			team_colors[""] = (1, 1, 0);
			team_colors[""] = (0, 1, 0);
			team_colors[""] = (0, 0, 1);
			team_colors[""] = (1, 0.7, 0);
			team_colors[""] = (0.25, 0.25, 1);
			team_colors[""] = (0.88, 0, 1);
			foreach(key, color in team_colors)
			{
				if(!isdefined(level.spawn_start[key]))
				{
					continue;
				}
				foreach(spawnpoint in level.spawn_start[key])
				{
					showonespawnpoint(spawnpoint, color, "");
				}
			}
		}
		else
		{
			color = (1, 0, 1);
			foreach(spawnpoint in level.spawn_start)
			{
				showonespawnpoint(spawnpoint, color, "");
			}
		}
	#/
}

/*
	Name: hidestartspawnpoints
	Namespace: dev
	Checksum: 0x8BAC8A46
	Offset: 0x58D8
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
	Checksum: 0xDC31652C
	Offset: 0x58F8
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
	Checksum: 0xF629061E
	Offset: 0x5970
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
	Name: engagement_distance_debug_toggle
	Namespace: dev
	Checksum: 0xFA58C923
	Offset: 0x59E0
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function engagement_distance_debug_toggle()
{
	/#
		level endon(#"kill_engage_dist_debug_toggle_watcher");
		if(!isdefined(getdvarint("")))
		{
			setdvar("", "");
		}
		laststate = getdvarint("", 0);
		while(true)
		{
			currentstate = getdvarint("", 0);
			if(dvar_turned_on(currentstate) && !dvar_turned_on(laststate))
			{
				weapon_engage_dists_init();
				thread debug_realtime_engage_dist();
				laststate = currentstate;
			}
			else if(!dvar_turned_on(currentstate) && dvar_turned_on(laststate))
			{
				level notify(#"kill_all_engage_dist_debug");
				laststate = currentstate;
			}
			wait(0.3);
		}
	#/
}

/*
	Name: dvar_turned_on
	Namespace: dev
	Checksum: 0x5AEC9DA2
	Offset: 0x5B48
	Size: 0x28
	Parameters: 1
	Flags: Linked
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
	Name: engagement_distance_debug_init
	Namespace: dev
	Checksum: 0x18123CE9
	Offset: 0x5B80
	Size: 0x3BA
	Parameters: 0
	Flags: Linked
*/
function engagement_distance_debug_init()
{
	/#
		level.debug_xpos = -50;
		level.debug_ypos = 250;
		level.debug_yinc = 18;
		level.debug_fontscale = 1.5;
		level.white = (1, 1, 1);
		level.green = (0, 1, 0);
		level.yellow = (1, 1, 0);
		level.red = (1, 0, 0);
		level.realtimeengagedist = newhudelem();
		level.realtimeengagedist.alignx = "";
		level.realtimeengagedist.fontscale = level.debug_fontscale;
		level.realtimeengagedist.x = level.debug_xpos;
		level.realtimeengagedist.y = level.debug_ypos;
		level.realtimeengagedist.color = level.white;
		level.realtimeengagedist settext("");
		xpos = level.debug_xpos + 207;
		level.realtimeengagedist_value = newhudelem();
		level.realtimeengagedist_value.alignx = "";
		level.realtimeengagedist_value.fontscale = level.debug_fontscale;
		level.realtimeengagedist_value.x = xpos;
		level.realtimeengagedist_value.y = level.debug_ypos;
		level.realtimeengagedist_value.color = level.white;
		level.realtimeengagedist_value setvalue(0);
		xpos = xpos + 37;
		level.realtimeengagedist_middle = newhudelem();
		level.realtimeengagedist_middle.alignx = "";
		level.realtimeengagedist_middle.fontscale = level.debug_fontscale;
		level.realtimeengagedist_middle.x = xpos;
		level.realtimeengagedist_middle.y = level.debug_ypos;
		level.realtimeengagedist_middle.color = level.white;
		level.realtimeengagedist_middle settext("");
		xpos = xpos + 105;
		level.realtimeengagedist_offvalue = newhudelem();
		level.realtimeengagedist_offvalue.alignx = "";
		level.realtimeengagedist_offvalue.fontscale = level.debug_fontscale;
		level.realtimeengagedist_offvalue.x = xpos;
		level.realtimeengagedist_offvalue.y = level.debug_ypos;
		level.realtimeengagedist_offvalue.color = level.white;
		level.realtimeengagedist_offvalue setvalue(0);
		hudobjarray = [];
		hudobjarray[0] = level.realtimeengagedist;
		hudobjarray[1] = level.realtimeengagedist_value;
		hudobjarray[2] = level.realtimeengagedist_middle;
		hudobjarray[3] = level.realtimeengagedist_offvalue;
		return hudobjarray;
	#/
}

/*
	Name: engage_dist_debug_hud_destroy
	Namespace: dev
	Checksum: 0x6D743A90
	Offset: 0x5F48
	Size: 0x66
	Parameters: 2
	Flags: Linked
*/
function engage_dist_debug_hud_destroy(hudarray, killnotify)
{
	/#
		level waittill(killnotify);
		for(i = 0; i < hudarray.size; i++)
		{
			hudarray[i] destroy();
		}
	#/
}

/*
	Name: weapon_engage_dists_init
	Namespace: dev
	Checksum: 0x8BA9F94A
	Offset: 0x5FB8
	Size: 0x8C4
	Parameters: 0
	Flags: Linked
*/
function weapon_engage_dists_init()
{
	/#
		level.engagedists = [];
		genericpistol = spawnstruct();
		genericpistol.engagedistmin = 125;
		genericpistol.engagedistoptimal = 225;
		genericpistol.engagedistmulligan = 50;
		genericpistol.engagedistmax = 400;
		shotty = spawnstruct();
		shotty.engagedistmin = 50;
		shotty.engagedistoptimal = 200;
		shotty.engagedistmulligan = 75;
		shotty.engagedistmax = 350;
		genericsmg = spawnstruct();
		genericsmg.engagedistmin = 100;
		genericsmg.engagedistoptimal = 275;
		genericsmg.engagedistmulligan = 100;
		genericsmg.engagedistmax = 500;
		genericlmg = spawnstruct();
		genericlmg.engagedistmin = 325;
		genericlmg.engagedistoptimal = 550;
		genericlmg.engagedistmulligan = 150;
		genericlmg.engagedistmax = 850;
		genericriflesa = spawnstruct();
		genericriflesa.engagedistmin = 325;
		genericriflesa.engagedistoptimal = 550;
		genericriflesa.engagedistmulligan = 150;
		genericriflesa.engagedistmax = 850;
		genericriflebolt = spawnstruct();
		genericriflebolt.engagedistmin = 350;
		genericriflebolt.engagedistoptimal = 600;
		genericriflebolt.engagedistmulligan = 150;
		genericriflebolt.engagedistmax = 900;
		generichmg = spawnstruct();
		generichmg.engagedistmin = 390;
		generichmg.engagedistoptimal = 600;
		generichmg.engagedistmulligan = 100;
		generichmg.engagedistmax = 900;
		genericsniper = spawnstruct();
		genericsniper.engagedistmin = 950;
		genericsniper.engagedistoptimal = 1700;
		genericsniper.engagedistmulligan = 300;
		genericsniper.engagedistmax = 3000;
		engage_dists_add("", genericpistol);
		engage_dists_add("", genericpistol);
		engage_dists_add("", genericpistol);
		engage_dists_add("", genericpistol);
		engage_dists_add("", genericsmg);
		engage_dists_add("", genericsmg);
		engage_dists_add("", genericsmg);
		engage_dists_add("", genericsmg);
		engage_dists_add("", genericsmg);
		engage_dists_add("", genericsmg);
		engage_dists_add("", genericsmg);
		engage_dists_add("", shotty);
		engage_dists_add("", genericlmg);
		engage_dists_add("", genericlmg);
		engage_dists_add("", genericlmg);
		engage_dists_add("", genericlmg);
		engage_dists_add("", genericlmg);
		engage_dists_add("", genericlmg);
		engage_dists_add("", genericlmg);
		engage_dists_add("", genericlmg);
		engage_dists_add("", genericlmg);
		engage_dists_add("", genericlmg);
		engage_dists_add("", genericriflesa);
		engage_dists_add("", genericriflesa);
		engage_dists_add("", genericriflesa);
		engage_dists_add("", genericriflesa);
		engage_dists_add("", genericriflebolt);
		engage_dists_add("", genericriflebolt);
		engage_dists_add("", genericriflebolt);
		engage_dists_add("", genericriflebolt);
		engage_dists_add("", genericriflebolt);
		engage_dists_add("", generichmg);
		engage_dists_add("", generichmg);
		engage_dists_add("", generichmg);
		engage_dists_add("", generichmg);
		engage_dists_add("", genericsniper);
		engage_dists_add("", genericsniper);
		engage_dists_add("", genericsniper);
		engage_dists_add("", genericsniper);
		engage_dists_add("", genericsniper);
		engage_dists_add("", genericsniper);
		level thread engage_dists_watcher();
	#/
}

/*
	Name: engage_dists_add
	Namespace: dev
	Checksum: 0xD0850EA4
	Offset: 0x6888
	Size: 0x3E
	Parameters: 2
	Flags: Linked
*/
function engage_dists_add(weaponname, values)
{
	/#
		level.engagedists[getweapon(weaponname)] = values;
	#/
}

/*
	Name: get_engage_dists
	Namespace: dev
	Checksum: 0xA8B80D86
	Offset: 0x68D0
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function get_engage_dists(weapon)
{
	/#
		if(isdefined(level.engagedists[weapon]))
		{
			return level.engagedists[weapon];
		}
		return undefined;
	#/
}

/*
	Name: engage_dists_watcher
	Namespace: dev
	Checksum: 0x27F13CB3
	Offset: 0x6918
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function engage_dists_watcher()
{
	/#
		level endon(#"kill_all_engage_dist_debug");
		level endon(#"kill_engage_dists_watcher");
		while(true)
		{
			player = util::gethostplayer();
			playerweapon = player getcurrentweapon();
			if(!isdefined(player.lastweapon))
			{
				player.lastweapon = playerweapon;
			}
			else if(player.lastweapon == playerweapon)
			{
				wait(0.05);
				continue;
			}
			values = get_engage_dists(playerweapon);
			if(isdefined(values))
			{
				level.weaponengagedistvalues = values;
			}
			else
			{
				level.weaponengagedistvalues = undefined;
			}
			player.lastweapon = playerweapon;
			wait(0.05);
		}
	#/
}

/*
	Name: debug_realtime_engage_dist
	Namespace: dev
	Checksum: 0xE6FC00D7
	Offset: 0x6A40
	Size: 0x498
	Parameters: 0
	Flags: Linked
*/
function debug_realtime_engage_dist()
{
	/#
		level endon(#"kill_all_engage_dist_debug");
		level endon(#"kill_realtime_engagement_distance_debug");
		hudobjarray = engagement_distance_debug_init();
		level thread engage_dist_debug_hud_destroy(hudobjarray, "");
		level.debugrtengagedistcolor = level.green;
		player = util::gethostplayer();
		while(true)
		{
			lasttracepos = (0, 0, 0);
			direction = player getplayerangles();
			direction_vec = anglestoforward(direction);
			eye = player geteye();
			eye = (eye[0], eye[1], eye[2] + 20);
			trace = bullettrace(eye, eye + vectorscale(direction_vec, 10000), 1, player);
			tracepoint = trace[""];
			tracenormal = trace[""];
			tracedist = int(distance(eye, tracepoint));
			if(tracepoint != lasttracepos)
			{
				lasttracepos = tracepoint;
				if(!isdefined(level.weaponengagedistvalues))
				{
					hudobj_changecolor(hudobjarray, level.white);
					hudobjarray engagedist_hud_changetext("", tracedist);
				}
				else
				{
					engagedistmin = level.weaponengagedistvalues.engagedistmin;
					engagedistoptimal = level.weaponengagedistvalues.engagedistoptimal;
					engagedistmulligan = level.weaponengagedistvalues.engagedistmulligan;
					engagedistmax = level.weaponengagedistvalues.engagedistmax;
					if(tracedist >= engagedistmin && tracedist <= engagedistmax)
					{
						if(tracedist >= (engagedistoptimal - engagedistmulligan) && tracedist <= (engagedistoptimal + engagedistmulligan))
						{
							hudobjarray engagedist_hud_changetext("", tracedist);
							hudobj_changecolor(hudobjarray, level.green);
						}
						else
						{
							hudobjarray engagedist_hud_changetext("", tracedist);
							hudobj_changecolor(hudobjarray, level.yellow);
						}
					}
					else
					{
						if(tracedist < engagedistmin)
						{
							hudobj_changecolor(hudobjarray, level.red);
							hudobjarray engagedist_hud_changetext("", tracedist);
						}
						else if(tracedist > engagedistmax)
						{
							hudobj_changecolor(hudobjarray, level.red);
							hudobjarray engagedist_hud_changetext("", tracedist);
						}
					}
				}
			}
			thread plot_circle_fortime(1, 5, 0.05, level.debugrtengagedistcolor, tracepoint, tracenormal);
			thread plot_circle_fortime(1, 1, 0.05, level.debugrtengagedistcolor, tracepoint, tracenormal);
			wait(0.05);
		}
	#/
}

/*
	Name: hudobj_changecolor
	Namespace: dev
	Checksum: 0x193DE1DA
	Offset: 0x6EE0
	Size: 0x92
	Parameters: 2
	Flags: Linked
*/
function hudobj_changecolor(hudobjarray, newcolor)
{
	/#
		for(i = 0; i < hudobjarray.size; i++)
		{
			hudobj = hudobjarray[i];
			if(hudobj.color != newcolor)
			{
				hudobj.color = newcolor;
				level.debugrtengagedistcolor = newcolor;
			}
		}
	#/
}

/*
	Name: engagedist_hud_changetext
	Namespace: dev
	Checksum: 0xD73A623A
	Offset: 0x6F80
	Size: 0x2EC
	Parameters: 2
	Flags: Linked
*/
function engagedist_hud_changetext(engagedisttype, units)
{
	/#
		if(!isdefined(level.lastdisttype))
		{
			level.lastdisttype = "";
		}
		if(engagedisttype == "")
		{
			self[1] setvalue(units);
			self[2] settext("");
			self[3].alpha = 0;
		}
		else
		{
			if(engagedisttype == "")
			{
				self[1] setvalue(units);
				self[2] settext("");
				self[3].alpha = 0;
			}
			else
			{
				if(engagedisttype == "")
				{
					amountunder = level.weaponengagedistvalues.engagedistmin - units;
					self[1] setvalue(units);
					self[3] setvalue(amountunder);
					self[3].alpha = 1;
					if(level.lastdisttype != engagedisttype)
					{
						self[2] settext("");
					}
				}
				else
				{
					if(engagedisttype == "")
					{
						amountover = units - level.weaponengagedistvalues.engagedistmax;
						self[1] setvalue(units);
						self[3] setvalue(amountover);
						self[3].alpha = 1;
						if(level.lastdisttype != engagedisttype)
						{
							self[2] settext("");
						}
					}
					else if(engagedisttype == "")
					{
						self[1] setvalue(units);
						self[2] settext("");
						self[3].alpha = 0;
					}
				}
			}
		}
		level.lastdisttype = engagedisttype;
	#/
}

/*
	Name: plot_circle_fortime
	Namespace: dev
	Checksum: 0x860109FD
	Offset: 0x7278
	Size: 0x1EE
	Parameters: 6
	Flags: Linked
*/
function plot_circle_fortime(radius1, radius2, time, color, origin, normal)
{
	/#
		if(!isdefined(color))
		{
			color = (0, 1, 0);
		}
		hangtime = 0.05;
		circleres = 6;
		hemires = circleres / 2;
		circleinc = 360 / circleres;
		circleres++;
		plotpoints = [];
		rad = 0;
		timer = gettime() + (time * 1000);
		radius = radius1;
		while(gettime() < timer)
		{
			radius = radius2;
			angletoplayer = vectortoangles(normal);
			for(i = 0; i < circleres; i++)
			{
				plotpoints[plotpoints.size] = origin + (vectorscale(anglestoforward(angletoplayer + (rad, 90, 0)), radius));
				rad = rad + circleinc;
			}
			util::plot_points(plotpoints, color[0], color[1], color[2], hangtime);
			plotpoints = [];
			wait(hangtime);
		}
	#/
}

/*
	Name: larry_thread
	Namespace: dev
	Checksum: 0xB6977D03
	Offset: 0x7470
	Size: 0x1C6
	Parameters: 0
	Flags: Linked
*/
function larry_thread()
{
	/#
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		level.larry = spawnstruct();
		player = util::gethostplayer();
		player thread larry_init(level.larry);
		level waittill(#"kill_larry");
		larry_hud_destroy(level.larry);
		if(isdefined(level.larry.model))
		{
			level.larry.model delete();
		}
		if(isdefined(level.larry.ai))
		{
			for(i = 0; i < level.larry.ai.size; i++)
			{
				kick(level.larry.ai[i] getentitynumber());
			}
		}
		level.larry = undefined;
	#/
}

/*
	Name: larry_init
	Namespace: dev
	Checksum: 0x5110F
	Offset: 0x7640
	Size: 0x270
	Parameters: 1
	Flags: Linked
*/
function larry_init(larry)
{
	/#
		level endon(#"kill_larry");
		larry_hud_init(larry);
		larry.model = spawn("", (0, 0, 0));
		larry.model setmodel("");
		larry.ai = [];
		wait(0.1);
		for(;;)
		{
			wait(0.05);
			if(larry.ai.size > 0)
			{
				larry.model hide();
				continue;
			}
			direction = self getplayerangles();
			direction_vec = anglestoforward(direction);
			eye = self geteye();
			trace = bullettrace(eye, eye + vectorscale(direction_vec, 8000), 0, undefined);
			dist = distance(eye, trace[""]);
			position = eye + (vectorscale(direction_vec, dist - 64));
			larry.model.origin = position;
			larry.model.angles = self.angles + vectorscale((0, 1, 0), 180);
			if(self usebuttonpressed())
			{
				self larry_ai(larry);
				while(self usebuttonpressed())
				{
					wait(0.05);
				}
			}
		}
	#/
}

/*
	Name: larry_ai
	Namespace: dev
	Checksum: 0x21E6AABB
	Offset: 0x78B8
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function larry_ai(larry)
{
	/#
		larry.ai[larry.ai.size] = bot::add_bot("");
		i = larry.ai.size - 1;
		larry.ai[i] thread larry_ai_thread(larry, larry.model.origin, larry.model.angles);
		larry.ai[i] thread larry_ai_damage(larry);
		larry.ai[i] thread larry_ai_health(larry);
	#/
}

/*
	Name: larry_ai_thread
	Namespace: dev
	Checksum: 0x3B01A55C
	Offset: 0x79D0
	Size: 0x1D0
	Parameters: 3
	Flags: Linked
*/
function larry_ai_thread(larry, origin, angles)
{
	/#
		level endon(#"kill_larry");
		for(;;)
		{
			self waittill(#"spawned_player");
			larry.menu[larry.menu_health] setvalue(self.health);
			larry.menu[larry.menu_damage] settext("");
			larry.menu[larry.menu_range] settext("");
			larry.menu[larry.menu_hitloc] settext("");
			larry.menu[larry.menu_weapon] settext("");
			larry.menu[larry.menu_perks] settext("");
			self setorigin(origin);
			self setplayerangles(angles);
			self clearperks();
		}
	#/
}

/*
	Name: larry_ai_damage
	Namespace: dev
	Checksum: 0xD3629016
	Offset: 0x7BA8
	Size: 0x288
	Parameters: 1
	Flags: Linked
*/
function larry_ai_damage(larry)
{
	/#
		level endon(#"kill_larry");
		for(;;)
		{
			self waittill(#"damage", damage, attacker, dir, point);
			if(!isdefined(attacker))
			{
				continue;
			}
			player = util::gethostplayer();
			if(!isdefined(player))
			{
				continue;
			}
			if(attacker != player)
			{
				continue;
			}
			eye = player geteye();
			range = int(distance(eye, point));
			larry.menu[larry.menu_health] setvalue(self.health);
			larry.menu[larry.menu_damage] setvalue(damage);
			larry.menu[larry.menu_range] setvalue(range);
			if(isdefined(self.cac_debug_location))
			{
				larry.menu[larry.menu_hitloc] settext(self.cac_debug_location);
			}
			else
			{
				larry.menu[larry.menu_hitloc] settext("");
			}
			if(isdefined(self.cac_debug_weapon))
			{
				larry.menu[larry.menu_weapon] settext(self.cac_debug_weapon);
				continue;
			}
			larry.menu[larry.menu_weapon] settext("");
		}
	#/
}

/*
	Name: larry_ai_health
	Namespace: dev
	Checksum: 0x4CA61D9E
	Offset: 0x7E38
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function larry_ai_health(larry)
{
	/#
		level endon(#"kill_larry");
		for(;;)
		{
			wait(0.05);
			larry.menu[larry.menu_health] setvalue(self.health);
		}
	#/
}

/*
	Name: larry_hud_init
	Namespace: dev
	Checksum: 0x37D24781
	Offset: 0x7EA0
	Size: 0x5C6
	Parameters: 1
	Flags: Linked
*/
function larry_hud_init(larry)
{
	/#
		/#
			x = -45;
			y = 275;
			menu_name = "";
			larry.hud = new_hud(menu_name, undefined, x, y, 1);
			larry.hud setshader("", 135, 65);
			larry.hud.alignx = "";
			larry.hud.aligny = "";
			larry.hud.sort = 10;
			larry.hud.alpha = 0.6;
			larry.hud.color = vectorscale((0, 0, 1), 0.5);
			larry.menu[0] = new_hud(menu_name, "", x + 5, y + 10, 1);
			larry.menu[1] = new_hud(menu_name, "", x + 5, y + 20, 1);
			larry.menu[2] = new_hud(menu_name, "", x + 5, y + 30, 1);
			larry.menu[3] = new_hud(menu_name, "", x + 5, y + 40, 1);
			larry.menu[4] = new_hud(menu_name, "", x + 5, y + 50, 1);
			larry.cleartextmarker = newdebughudelem();
			larry.cleartextmarker.alpha = 0;
			larry.cleartextmarker settext("");
			larry.menu_health = larry.menu.size;
			larry.menu_damage = larry.menu.size + 1;
			larry.menu_range = larry.menu.size + 2;
			larry.menu_hitloc = larry.menu.size + 3;
			larry.menu_weapon = larry.menu.size + 4;
			larry.menu_perks = larry.menu.size + 5;
			x_offset = 70;
			larry.menu[larry.menu_health] = new_hud(menu_name, "", x + x_offset, y + 10, 1);
			larry.menu[larry.menu_damage] = new_hud(menu_name, "", x + x_offset, y + 20, 1);
			larry.menu[larry.menu_range] = new_hud(menu_name, "", x + x_offset, y + 30, 1);
			larry.menu[larry.menu_hitloc] = new_hud(menu_name, "", x + x_offset, y + 40, 1);
			larry.menu[larry.menu_weapon] = new_hud(menu_name, "", x + x_offset, y + 50, 1);
			larry.menu[larry.menu_perks] = new_hud(menu_name, "", x + x_offset, y + 60, 1);
		#/
	#/
}

/*
	Name: larry_hud_destroy
	Namespace: dev
	Checksum: 0x1C98712B
	Offset: 0x8470
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function larry_hud_destroy(larry)
{
	/#
		if(isdefined(larry.hud))
		{
			larry.hud destroy();
			for(i = 0; i < larry.menu.size; i++)
			{
				larry.menu[i] destroy();
			}
			larry.cleartextmarker destroy();
		}
	#/
}

/*
	Name: new_hud
	Namespace: dev
	Checksum: 0x144876F9
	Offset: 0x8538
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
	Name: set_hudelem
	Namespace: dev
	Checksum: 0x7A6D5DE1
	Offset: 0x8608
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
	Name: watch_botsdvars
	Namespace: dev
	Checksum: 0x6DCDBA09
	Offset: 0x87B8
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function watch_botsdvars()
{
	/#
		hasplayerweaponprev = getdvarint("");
		grenadesonlyprev = getdvarint("");
		secondarygrenadesonlyprev = getdvarint("");
		while(true)
		{
			if(hasplayerweaponprev != getdvarint(""))
			{
				hasplayerweaponprev = getdvarint("");
				if(hasplayerweaponprev)
				{
					iprintlnbold("");
				}
				else
				{
					iprintlnbold("");
				}
			}
			if(grenadesonlyprev != getdvarint(""))
			{
				grenadesonlyprev = getdvarint("");
				if(grenadesonlyprev)
				{
					iprintlnbold("");
				}
				else
				{
					iprintlnbold("");
				}
			}
			if(secondarygrenadesonlyprev != getdvarint(""))
			{
				secondarygrenadesonlyprev = getdvarint("");
				if(secondarygrenadesonlyprev)
				{
					iprintlnbold("");
				}
				else
				{
					iprintlnbold("");
				}
			}
			wait(1);
		}
	#/
}

/*
	Name: getattachmentchangemodifierbutton
	Namespace: dev
	Checksum: 0xF5AFDBAF
	Offset: 0x89E8
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
	Checksum: 0x974EB8F2
	Offset: 0x8A00
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
	Checksum: 0x4B66C4C8
	Offset: 0x8DB8
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
	Checksum: 0x6B3B6A44
	Offset: 0x8EE0
	Size: 0x1B2
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
		level.dev_equipment[10] = getweapon("");
	#/
}

/*
	Name: set_grenade_list
	Namespace: dev
	Checksum: 0xE8D5E3A2
	Offset: 0x90A0
	Size: 0x1DA
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
		level.dev_grenade[11] = getweapon("");
	#/
}

/*
	Name: take_all_grenades_and_equipment
	Namespace: dev
	Checksum: 0x511E34B6
	Offset: 0x9288
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
	Checksum: 0xE5EEE73F
	Offset: 0x9348
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
	Checksum: 0x46D7C44D
	Offset: 0x9478
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
	Name: force_grenade_throw
	Namespace: dev
	Checksum: 0x84E4D854
	Offset: 0x95A8
	Size: 0x28C
	Parameters: 1
	Flags: Linked
*/
function force_grenade_throw(weapon)
{
	/#
		if(weapon == level.weaponnone)
		{
			return;
		}
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		host = util::gethostplayer();
		if(!isdefined(host.team))
		{
			iprintln("");
			return;
		}
		bot = getormakebot(util::getotherteam(host.team));
		if(!isdefined(bot))
		{
			iprintln("");
			return;
		}
		angles = host getplayerangles();
		angles = (0, angles[1], 0);
		dir = anglestoforward(angles);
		dir = vectornormalize(dir);
		origin = host geteye() + vectorscale(dir, 256);
		velocity = vectorscale(dir, -1024);
		grenade = bot magicgrenadeplayer(weapon, origin, velocity);
		grenade setteam(bot.team);
		grenade setowner(bot);
	#/
}

/*
	Name: bot_dpad_think
	Namespace: dev
	Checksum: 0xA5E9190C
	Offset: 0x9840
	Size: 0x2A6
	Parameters: 0
	Flags: Linked
*/
function bot_dpad_think()
{
	/#
		level notify(#"bot_dpad_stop");
		level endon(#"bot_dpad_stop");
		level endon(#"bot_dpad_terminate");
		if(!isdefined(level.bot_index))
		{
			level.bot_index = 0;
		}
		host = util::gethostplayer();
		while(!isdefined(host))
		{
			wait(0.5);
			host = util::gethostplayer();
			level.bot_index = 0;
		}
		dpad_left = 0;
		dpad_right = 0;
		for(;;)
		{
			wait(0.05);
			host setactionslot(3, "");
			host setactionslot(4, "");
			players = getplayers();
			max = players.size;
			if(!dpad_left && host buttonpressed(""))
			{
				level.bot_index--;
				if(level.bot_index < 0)
				{
					level.bot_index = max - 1;
				}
				if(!players[level.bot_index] util::is_bot())
				{
					continue;
				}
				dpad_left = 1;
			}
			else if(!host buttonpressed(""))
			{
				dpad_left = 0;
			}
			if(!dpad_right && host buttonpressed(""))
			{
				level.bot_index++;
				if(level.bot_index >= max)
				{
					level.bot_index = 0;
				}
				if(!players[level.bot_index] util::is_bot())
				{
					continue;
				}
				dpad_right = 1;
			}
			else if(!host buttonpressed(""))
			{
				dpad_right = 0;
			}
			level notify(#"bot_index_changed");
		}
	#/
}

/*
	Name: bot_overlay_think
	Namespace: dev
	Checksum: 0x122DCE78
	Offset: 0x9AF0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function bot_overlay_think()
{
	/#
		level endon(#"bot_overlay_stop");
		level thread bot_dpad_think();
		iprintln("");
		iprintln("");
		for(;;)
		{
			if(getdvarint("") != level.bot_index)
			{
				setdvar("", level.bot_index);
			}
			level waittill(#"bot_index_changed");
		}
	#/
}

/*
	Name: bot_threat_think
	Namespace: dev
	Checksum: 0x4BB85F63
	Offset: 0x9BA8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function bot_threat_think()
{
	/#
		level endon(#"bot_threat_stop");
		level thread bot_dpad_think();
		iprintln("");
		iprintln("");
		for(;;)
		{
			if(getdvarint("") != level.bot_index)
			{
				setdvar("", level.bot_index);
			}
			level waittill(#"bot_index_changed");
		}
	#/
}

/*
	Name: bot_path_think
	Namespace: dev
	Checksum: 0x6B4A398C
	Offset: 0x9C60
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function bot_path_think()
{
	/#
		level endon(#"bot_path_stop");
		level thread bot_dpad_think();
		iprintln("");
		iprintln("");
		for(;;)
		{
			if(getdvarint("") != level.bot_index)
			{
				setdvar("", level.bot_index);
			}
			level waittill(#"bot_index_changed");
		}
	#/
}

/*
	Name: bot_overlay_stop
	Namespace: dev
	Checksum: 0x4870ABD
	Offset: 0x9D18
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function bot_overlay_stop()
{
	/#
		level notify(#"bot_overlay_stop");
		setdvar("", "");
	#/
}

/*
	Name: bot_path_stop
	Namespace: dev
	Checksum: 0x56CF9897
	Offset: 0x9D58
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function bot_path_stop()
{
	/#
		level notify(#"bot_path_stop");
		setdvar("", "");
	#/
}

/*
	Name: bot_threat_stop
	Namespace: dev
	Checksum: 0x8D38DD0C
	Offset: 0x9D98
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function bot_threat_stop()
{
	/#
		level notify(#"bot_threat_stop");
		setdvar("", "");
	#/
}

/*
	Name: devstraferunpathdebugdraw
	Namespace: dev
	Checksum: 0xB5CB3734
	Offset: 0x9DD8
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
			if(killstreaks::should_draw_debug("") > 0)
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
	Checksum: 0x7D199DF4
	Offset: 0xA280
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
	Checksum: 0x6ABFDE4E
	Offset: 0xA648
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
	Checksum: 0xA3935E6C
	Offset: 0xA768
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
	Checksum: 0x42E4CCD3
	Offset: 0xA7E8
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
	Checksum: 0x85C30AB3
	Offset: 0xA868
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
	Checksum: 0xD9E111A9
	Offset: 0xA938
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
	Checksum: 0xDAB997ED
	Offset: 0xAA20
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
	Checksum: 0xB6F3ECBC
	Offset: 0xAB80
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
	Checksum: 0xD9794609
	Offset: 0xACB0
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
	Checksum: 0x2065D9E6
	Offset: 0xAD80
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
	Checksum: 0xB08A4281
	Offset: 0xAE00
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
	Checksum: 0x785CC348
	Offset: 0xAE50
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
	Checksum: 0x2D6353B9
	Offset: 0xAE78
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
	Checksum: 0x6ABA584
	Offset: 0xAFA0
	Size: 0x1A6
	Parameters: 0
	Flags: Linked
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
	Checksum: 0xF5C55329
	Offset: 0xB150
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
	Checksum: 0x5272ED8D
	Offset: 0xB1B8
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
	Checksum: 0x606626A1
	Offset: 0xB260
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

