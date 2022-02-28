// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_powerup_carpenter;

/*
	Name: __init__sytem__
	Namespace: zm_powerup_carpenter
	Checksum: 0x87118FF9
	Offset: 0x2D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_powerup_carpenter", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_powerup_carpenter
	Checksum: 0x11CA1409
	Offset: 0x318
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_powerups::register_powerup("carpenter", &grab_carpenter);
	if(tolower(getdvarstring("g_gametype")) != "zcleansed")
	{
		zm_powerups::add_zombie_powerup("carpenter", "p7_zm_power_up_carpenter", &"ZOMBIE_POWERUP_MAX_AMMO", &func_should_drop_carpenter, 0, 0, 0);
	}
	level.use_new_carpenter_func = &start_carpenter_new;
}

/*
	Name: grab_carpenter
	Namespace: zm_powerup_carpenter
	Checksum: 0xAC701618
	Offset: 0x3D8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function grab_carpenter(player)
{
	if(zm_utility::is_classic())
	{
		player thread zm_pers_upgrades::persistent_carpenter_ability_check();
	}
	if(isdefined(level.use_new_carpenter_func))
	{
		level thread [[level.use_new_carpenter_func]](self.origin);
	}
	else
	{
		level thread start_carpenter(self.origin);
	}
	player thread zm_powerups::powerup_vo("carpenter");
}

/*
	Name: start_carpenter
	Namespace: zm_powerup_carpenter
	Checksum: 0x58A509F9
	Offset: 0x480
	Size: 0x324
	Parameters: 1
	Flags: Linked
*/
function start_carpenter(origin)
{
	window_boards = struct::get_array("exterior_goal", "targetname");
	total = level.exterior_goals.size;
	carp_ent = spawn("script_origin", (0, 0, 0));
	carp_ent playloopsound("evt_carpenter");
	while(true)
	{
		windows = get_closest_window_repair(window_boards, origin);
		if(!isdefined(windows))
		{
			carp_ent stoploopsound(1);
			carp_ent playsoundwithnotify("evt_carpenter_end", "sound_done");
			carp_ent waittill(#"sound_done");
			break;
		}
		else
		{
			arrayremovevalue(window_boards, windows);
		}
		while(true)
		{
			if(zm_utility::all_chunks_intact(windows, windows.barrier_chunks))
			{
				break;
			}
			chunk = zm_utility::get_random_destroyed_chunk(windows, windows.barrier_chunks);
			if(!isdefined(chunk))
			{
				break;
			}
			windows thread zm_blockers::replace_chunk(windows, chunk, undefined, zm_powerups::is_carpenter_boards_upgraded(), 1);
			if(isdefined(windows.clip))
			{
				windows.clip triggerenable(1);
				windows.clip disconnectpaths();
			}
			else
			{
				zm_blockers::blocker_disconnect_paths(windows.neg_start, windows.neg_end);
			}
			util::wait_network_frame();
			wait(0.05);
		}
		util::wait_network_frame();
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] zm_score::player_add_points("carpenter_powerup", 200);
	}
	carp_ent delete();
}

/*
	Name: get_closest_window_repair
	Namespace: zm_powerup_carpenter
	Checksum: 0x68224385
	Offset: 0x7B0
	Size: 0x13E
	Parameters: 2
	Flags: Linked
*/
function get_closest_window_repair(windows, origin)
{
	current_window = undefined;
	shortest_distance = undefined;
	for(i = 0; i < windows.size; i++)
	{
		if(zm_utility::all_chunks_intact(windows, windows[i].barrier_chunks))
		{
			continue;
		}
		if(!isdefined(current_window))
		{
			current_window = windows[i];
			shortest_distance = distancesquared(current_window.origin, origin);
			continue;
		}
		if(distancesquared(windows[i].origin, origin) < shortest_distance)
		{
			current_window = windows[i];
			shortest_distance = distancesquared(windows[i].origin, origin);
		}
	}
	return current_window;
}

/*
	Name: start_carpenter_new
	Namespace: zm_powerup_carpenter
	Checksum: 0xB084675E
	Offset: 0x8F8
	Size: 0x492
	Parameters: 1
	Flags: Linked
*/
function start_carpenter_new(origin)
{
	level.carpenter_powerup_active = 1;
	window_boards = struct::get_array("exterior_goal", "targetname");
	if(isdefined(level._additional_carpenter_nodes))
	{
		window_boards = arraycombine(window_boards, level._additional_carpenter_nodes, 0, 0);
	}
	carp_ent = spawn("script_origin", (0, 0, 0));
	carp_ent playloopsound("evt_carpenter");
	boards_near_players = get_near_boards(window_boards);
	boards_far_from_players = get_far_boards(window_boards);
	level repair_far_boards(boards_far_from_players, zm_powerups::is_carpenter_boards_upgraded());
	for(i = 0; i < boards_near_players.size; i++)
	{
		window = boards_near_players[i];
		num_chunks_checked = 0;
		last_repaired_chunk = undefined;
		while(true)
		{
			if(zm_utility::all_chunks_intact(window, window.barrier_chunks))
			{
				break;
			}
			chunk = zm_utility::get_random_destroyed_chunk(window, window.barrier_chunks);
			if(!isdefined(chunk))
			{
				break;
			}
			window thread zm_blockers::replace_chunk(window, chunk, undefined, zm_powerups::is_carpenter_boards_upgraded(), 1);
			last_repaired_chunk = chunk;
			if(isdefined(window.clip))
			{
				window.clip triggerenable(1);
				window.clip disconnectpaths();
			}
			else
			{
				zm_blockers::blocker_disconnect_paths(window.neg_start, window.neg_end);
			}
			util::wait_network_frame();
			num_chunks_checked++;
			if(num_chunks_checked >= 20)
			{
				break;
			}
		}
		if(isdefined(window.zbarrier))
		{
			if(isdefined(last_repaired_chunk))
			{
				while(window.zbarrier getzbarrierpiecestate(last_repaired_chunk) == "closing")
				{
					wait(0.05);
				}
				if(isdefined(window._post_carpenter_callback))
				{
					window [[window._post_carpenter_callback]]();
				}
			}
			continue;
		}
		while(isdefined(last_repaired_chunk) && last_repaired_chunk.state == "mid_repair")
		{
			wait(0.05);
		}
	}
	carp_ent stoploopsound(1);
	carp_ent playsoundwithnotify("evt_carpenter_end", "sound_done");
	carp_ent waittill(#"sound_done");
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] zm_score::player_add_points("carpenter_powerup", 200);
	}
	carp_ent delete();
	level notify(#"carpenter_finished");
	level.carpenter_powerup_active = undefined;
}

/*
	Name: get_near_boards
	Namespace: zm_powerup_carpenter
	Checksum: 0x655AE79F
	Offset: 0xD98
	Size: 0x166
	Parameters: 1
	Flags: Linked
*/
function get_near_boards(windows)
{
	players = getplayers();
	boards_near_players = [];
	for(j = 0; j < windows.size; j++)
	{
		close = 0;
		for(i = 0; i < players.size; i++)
		{
			origin = undefined;
			if(isdefined(windows[j].zbarrier))
			{
				origin = windows[j].zbarrier.origin;
			}
			else
			{
				origin = windows[j].origin;
			}
			if(distancesquared(players[i].origin, origin) <= 562500)
			{
				close = 1;
				break;
			}
		}
		if(close)
		{
			boards_near_players[boards_near_players.size] = windows[j];
		}
	}
	return boards_near_players;
}

/*
	Name: get_far_boards
	Namespace: zm_powerup_carpenter
	Checksum: 0x3E73D3C6
	Offset: 0xF08
	Size: 0x166
	Parameters: 1
	Flags: Linked
*/
function get_far_boards(windows)
{
	players = getplayers();
	boards_far_from_players = [];
	for(j = 0; j < windows.size; j++)
	{
		close = 0;
		for(i = 0; i < players.size; i++)
		{
			origin = undefined;
			if(isdefined(windows[j].zbarrier))
			{
				origin = windows[j].zbarrier.origin;
			}
			else
			{
				origin = windows[j].origin;
			}
			if(distancesquared(players[i].origin, origin) >= 562500)
			{
				close = 1;
				break;
			}
		}
		if(close)
		{
			boards_far_from_players[boards_far_from_players.size] = windows[j];
		}
	}
	return boards_far_from_players;
}

/*
	Name: repair_far_boards
	Namespace: zm_powerup_carpenter
	Checksum: 0x9793AF3E
	Offset: 0x1078
	Size: 0x2EE
	Parameters: 2
	Flags: Linked
*/
function repair_far_boards(barriers, upgrade)
{
	for(i = 0; i < barriers.size; i++)
	{
		barrier = barriers[i];
		if(zm_utility::all_chunks_intact(barrier, barrier.barrier_chunks))
		{
			continue;
		}
		if(isdefined(barrier.zbarrier))
		{
			a_pieces = barrier.zbarrier getzbarrierpieceindicesinstate("open");
			if(isdefined(a_pieces))
			{
				for(xx = 0; xx < a_pieces.size; xx++)
				{
					chunk = a_pieces[xx];
					if(upgrade)
					{
						barrier.zbarrier zbarrierpieceuseupgradedmodel(chunk);
						barrier.zbarrier.chunk_health[chunk] = barrier.zbarrier getupgradedpiecenumlives(chunk);
						continue;
					}
					barrier.zbarrier zbarrierpieceusedefaultmodel(chunk);
					barrier.zbarrier.chunk_health[chunk] = 0;
				}
			}
			for(x = 0; x < barrier.zbarrier getnumzbarrierpieces(); x++)
			{
				barrier.zbarrier setzbarrierpiecestate(x, "closed");
				barrier.zbarrier showzbarrierpiece(x);
			}
		}
		if(isdefined(barrier.clip))
		{
			barrier.clip triggerenable(1);
			barrier.clip disconnectpaths();
		}
		else
		{
			zm_blockers::blocker_disconnect_paths(barrier.neg_start, barrier.neg_end);
		}
		if((i % 4) == 0)
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: func_should_drop_carpenter
	Namespace: zm_powerup_carpenter
	Checksum: 0x41F02807
	Offset: 0x1370
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function func_should_drop_carpenter()
{
	if(get_num_window_destroyed() < 5)
	{
		return false;
	}
	return true;
}

/*
	Name: get_num_window_destroyed
	Namespace: zm_powerup_carpenter
	Checksum: 0xFEB8F600
	Offset: 0x13A0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function get_num_window_destroyed()
{
	num = 0;
	for(i = 0; i < level.exterior_goals.size; i++)
	{
		if(zm_utility::all_chunks_destroyed(level.exterior_goals[i], level.exterior_goals[i].barrier_chunks))
		{
			num = num + 1;
		}
	}
	return num;
}

