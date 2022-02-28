// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_board_games;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_board_games
	Checksum: 0x939E567D
	Offset: 0x1D0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_board_games", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_board_games
	Checksum: 0x76E19A19
	Offset: 0x210
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_board_games", "rounds", 5, &enable, &disable, undefined);
}

/*
	Name: enable
	Namespace: zm_bgb_board_games
	Checksum: 0x17E56E38
	Offset: 0x278
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	self thread function_7b627622();
}

/*
	Name: disable
	Namespace: zm_bgb_board_games
	Checksum: 0x99EC1590
	Offset: 0x2A0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function disable()
{
}

/*
	Name: function_7b627622
	Namespace: zm_bgb_board_games
	Checksum: 0x418D6917
	Offset: 0x2B0
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_7b627622()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_update");
	while(true)
	{
		self waittill(#"boarding_window", s_window);
		self bgb::do_one_shot_use();
		self thread function_d5ed5165(s_window);
	}
}

/*
	Name: function_d5ed5165
	Namespace: zm_bgb_board_games
	Checksum: 0x8481EE4B
	Offset: 0x330
	Size: 0x2DC
	Parameters: 1
	Flags: Linked
*/
function function_d5ed5165(s_window)
{
	carp_ent = spawn("script_origin", (0, 0, 0));
	carp_ent playloopsound("evt_carpenter");
	num_chunks_checked = 0;
	while(true)
	{
		if(zm_utility::all_chunks_intact(s_window, s_window.barrier_chunks))
		{
			break;
		}
		chunk = zm_utility::get_random_destroyed_chunk(s_window, s_window.barrier_chunks);
		if(!isdefined(chunk))
		{
			break;
		}
		s_window thread zm_blockers::replace_chunk(s_window, chunk, undefined, 0, 1);
		last_repaired_chunk = chunk;
		if(isdefined(s_window.clip))
		{
			s_window.clip triggerenable(1);
			s_window.clip disconnectpaths();
		}
		else
		{
			zm_blockers::blocker_disconnect_paths(s_window.neg_start, s_window.neg_end);
		}
		util::wait_network_frame();
		num_chunks_checked++;
		if(num_chunks_checked >= 20)
		{
			break;
		}
	}
	if(isdefined(s_window.zbarrier))
	{
		if(isdefined(last_repaired_chunk))
		{
			while(s_window.zbarrier getzbarrierpiecestate(last_repaired_chunk) == "closing")
			{
				wait(0.05);
			}
			if(isdefined(s_window._post_carpenter_callback))
			{
				s_window [[s_window._post_carpenter_callback]]();
			}
		}
	}
	else
	{
		while(isdefined(last_repaired_chunk) && last_repaired_chunk.state == "mid_repair")
		{
			wait(0.05);
		}
	}
	carp_ent stoploopsound(1);
	carp_ent playsoundwithnotify("evt_carpenter_end", "sound_done");
	carp_ent waittill(#"sound_done");
	carp_ent delete();
}

