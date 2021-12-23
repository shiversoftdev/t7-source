// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_temple_sq;
#using scripts\zm\zm_temple_sq_brock;

#namespace zm_temple_sq_skits;

/*
	Name: build_skit_entry
	Namespace: zm_temple_sq_skits
	Checksum: 0xF6D2B9A2
	Offset: 0x9C8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function build_skit_entry(character, vo)
{
	entry = spawnstruct();
	switch(character)
	{
		case "dempsey":
		{
			entry.character = 0;
			break;
		}
		case "nikolai":
		{
			entry.character = 1;
			break;
		}
		case "takeo":
		{
			entry.character = 3;
			break;
		}
		case "richtofen":
		{
			entry.character = 2;
			break;
		}
	}
	entry.vo = vo;
	return entry;
}

/*
	Name: init_skits
	Namespace: zm_temple_sq_skits
	Checksum: 0x74B0A6C1
	Offset: 0xAA8
	Size: 0xDB6
	Parameters: 0
	Flags: Linked
*/
function init_skits()
{
	if(!isdefined(level._skit_data))
	{
		level._skit_data = [];
		level._skit_data["tt1"] = array(build_skit_entry("dempsey", "vox_egg_skit_travel_1_0"), build_skit_entry("nikolai", "vox_egg_skit_travel_1_1"), build_skit_entry("takeo", "vox_egg_skit_travel_1_2"), build_skit_entry("richtofen", "vox_egg_skit_travel_1_3"), build_skit_entry("dempsey", "vox_egg_skit_travel_1_4"));
		level._skit_data["tt2"] = array(build_skit_entry("takeo", "vox_egg_skit_travel_2_0"), build_skit_entry("nikolai", "vox_egg_skit_travel_2_1"), build_skit_entry("richtofen", "vox_egg_skit_travel_2_2"), build_skit_entry("dempsey", "vox_egg_skit_travel_2_3"), build_skit_entry("nikolai", "vox_egg_skit_travel_2_4"));
		level._skit_data["tt3"] = array(build_skit_entry("dempsey", "vox_egg_skit_travel_3_0"), build_skit_entry("takeo", "vox_egg_skit_travel_3_1"), build_skit_entry("richtofen", "vox_egg_skit_travel_3_2"), build_skit_entry("nikolai", "vox_egg_skit_travel_3_3"), build_skit_entry("richtofen", "vox_egg_skit_travel_3_3a"), build_skit_entry("dempsey", "vox_egg_skit_travel_3_4"));
		level._skit_data["tt4a"] = array(build_skit_entry("takeo", "vox_egg_skit_travel_4a_0"), build_skit_entry("dempsey", "vox_egg_skit_travel_4a_1"), build_skit_entry("richtofen", "vox_egg_skit_travel_4a_2"), build_skit_entry("nikolai", "vox_egg_skit_travel_4a_3"), build_skit_entry("dempsey", "vox_egg_skit_travel_4a_4"), build_skit_entry("dempsey", "vox_egg_skit_travel_4a_5"), build_skit_entry("dempsey", "vox_egg_skit_travel_4a_6"), build_skit_entry("richtofen", "vox_egg_skit_travel_4a_7"));
		level._skit_data["tt4b"] = array(build_skit_entry("richtofen", "vox_egg_skit_travel_4b_0"), build_skit_entry("dempsey", "vox_egg_skit_travel_4b_1"), build_skit_entry("richtofen", "vox_egg_skit_travel_4b_2"), build_skit_entry("dempsey", "vox_egg_skit_travel_4b_3"), build_skit_entry("richtofen", "vox_egg_skit_travel_4b_4"), build_skit_entry("nikolai", "vox_egg_skit_travel_4b_5"), build_skit_entry("richtofen", "vox_egg_skit_travel_4b_6"));
		level._skit_data["tt5"] = array(build_skit_entry("richtofen", "vox_egg_skit_travel_5_0"), build_skit_entry("takeo", "vox_egg_skit_travel_5_1"), build_skit_entry("dempsey", "vox_egg_skit_travel_5_2"), build_skit_entry("nikolai", "vox_egg_skit_travel_5_3"), build_skit_entry("richtofen", "vox_egg_skit_travel_5_4"));
		level._skit_data["tt6"] = array(build_skit_entry("dempsey", "vox_egg_skit_travel_6_0"), build_skit_entry("richtofen", "vox_egg_skit_travel_6_1"), build_skit_entry("richtofen", "vox_egg_skit_travel_6_2"), build_skit_entry("nikolai", "vox_egg_skit_travel_6_3"), build_skit_entry("richtofen", "vox_egg_skit_travel_6_4"), build_skit_entry("takeo", "vox_egg_skit_travel_6_5"), build_skit_entry("takeo", "vox_egg_skit_travel_6_6"));
		level._skit_data["tt7a"] = array(build_skit_entry("dempsey", "vox_egg_skit_travel_7a_0"), build_skit_entry("richtofen", "vox_egg_skit_travel_7a_1"), build_skit_entry("dempsey", "vox_egg_skit_travel_7a_2"), build_skit_entry("nikolai", "vox_egg_skit_travel_7a_3"), build_skit_entry("takeo", "vox_egg_skit_travel_7a_4"));
		level._skit_data["tt7b"] = array(build_skit_entry("dempsey", "vox_egg_skit_travel_7b_0"), build_skit_entry("richtofen", "vox_egg_skit_travel_7b_1"), build_skit_entry("nikolai", "vox_egg_skit_travel_7b_2"), build_skit_entry("takeo", "vox_egg_skit_travel_7b_3"), build_skit_entry("takeo", "vox_egg_skit_travel_7b_4"));
		level._skit_data["tt8"] = array(build_skit_entry("richtofen", "vox_egg_skit_travel_8_0"), build_skit_entry("dempsey", "vox_egg_skit_travel_8_1"), build_skit_entry("richtofen", "vox_egg_skit_travel_8_2"), build_skit_entry("nikolai", "vox_egg_skit_travel_8_3"), build_skit_entry("richtofen", "vox_egg_skit_travel_8_4"));
		level._skit_data["fail1"] = array(build_skit_entry("dempsey", "vox_egg_skit_fail_0_0"), build_skit_entry("nikolai", "vox_egg_skit_fail_0_1"), build_skit_entry("takeo", "vox_egg_skit_fail_0_2"), build_skit_entry("richtofen", "vox_egg_skit_fail_0_3"));
		level._skit_data["fail2"] = array(build_skit_entry("dempsey", "vox_egg_skit_fail_1_0"), build_skit_entry("nikolai", "vox_egg_skit_fail_2_1"), build_skit_entry("takeo", "vox_egg_skit_fail_3_2"), build_skit_entry("richtofen", "vox_egg_skit_fail_4_3"));
		level._skit_data["fail3"] = array(build_skit_entry("dempsey", "vox_egg_skit_fail_0_0"), build_skit_entry("nikolai", "vox_egg_skit_fail_1_1"), build_skit_entry("takeo", "vox_egg_skit_fail_2_2"), build_skit_entry("richtofen", "vox_egg_skit_fail_3_3"));
		level._skit_data["fail4"] = array(build_skit_entry("dempsey", "vox_egg_skit_fail_0_0"), build_skit_entry("nikolai", "vox_egg_skit_fail_1_1"), build_skit_entry("takeo", "vox_egg_skit_fail_2_2"), build_skit_entry("richtofen", "vox_egg_skit_fail_3_3"));
		level._skit_data["start0"] = array(build_skit_entry("dempsey", "vox_egg_skit_start_0_0"), build_skit_entry("nikolai", "vox_egg_skit_start_0_1"), build_skit_entry("takeo", "vox_egg_skit_start_0_2"), build_skit_entry("richtofen", "vox_egg_skit_start_0_2a"), build_skit_entry("nikolai", "vox_egg_skit_start_0_3"), build_skit_entry("richtofen", "vox_egg_skit_start_0_4"), build_skit_entry("richtofen", "vox_egg_skit_start_0_5"));
		level._skit_data["start1"] = array(build_skit_entry("takeo", "vox_egg_skit_start_1_0"), build_skit_entry("richtofen", "vox_egg_skit_start_1_1"), build_skit_entry("nikolai", "vox_egg_skit_start_1_2"), build_skit_entry("nikolai", "vox_egg_skit_start_1_3"), build_skit_entry("takeo", "vox_egg_skit_start_1_4"), build_skit_entry("nikolai", "vox_egg_skit_start_1_5"), build_skit_entry("dempsey", "vox_egg_skit_start_1_6"), build_skit_entry("dempsey", "vox_egg_skit_start_1_7"));
	}
}

/*
	Name: skit_interupt
	Namespace: zm_temple_sq_skits
	Checksum: 0xA983F838
	Offset: 0x1868
	Size: 0x444
	Parameters: 2
	Flags: Linked
*/
function skit_interupt(fail_pos, group)
{
	level endon(#"start_skit_done");
	if(!isdefined(level._start_skit_pos))
	{
		buttons = getentarray("sq_sundial_button", "targetname");
		pos = (0, 0, 0);
		for(i = 0; i < buttons.size; i++)
		{
			pos = pos + buttons[i].origin;
		}
		pos = pos / buttons.size;
		level._start_skit_pos = pos;
	}
	if(!isdefined(fail_pos))
	{
		fail_pos = level._start_skit_pos;
	}
	while(true)
	{
		players = getplayers();
		if(isdefined(group))
		{
			players = group;
		}
		max_dist_squared = 0;
		check_pos = level._start_skit_pos;
		if(isdefined(group))
		{
			check_pos = (0, 0, 0);
			num_group = 0;
			for(i = 0; i < group.size; i++)
			{
				if(isdefined(group[i]))
				{
					check_pos = check_pos + group[i].origin;
					num_group++;
				}
			}
			if(num_group)
			{
				check_pos = check_pos / num_group;
			}
		}
		for(i = 0; i < players.size; i++)
		{
			if(!isdefined(players[i]))
			{
				break;
			}
			dist_squared = distance2dsquared(players[i].origin, check_pos);
			if(isdefined(dist_squared))
			{
				max_dist_squared = max(max_dist_squared, dist_squared);
			}
		}
		if(max_dist_squared > 518400)
		{
			break;
		}
		wait(0.1);
	}
	level notify(#"skit_interupt");
	speaker = getplayers()[0];
	if(isdefined(level._last_skit_line_speaker))
	{
		speaker = level._last_skit_line_speaker;
	}
	if(isdefined(speaker.speaking_line) && speaker.speaking_line)
	{
		while(isdefined(speaker) && speaker.speaking_line)
		{
			wait(0.2);
		}
	}
	character = speaker.characterindex;
	if(isdefined(speaker) && isdefined(speaker.zm_random_char))
	{
		character = speaker.zm_random_char;
	}
	num = 5;
	if(character === 3)
	{
		num = 8;
	}
	snd = (("vox_plr_" + character) + "_safety_") + randomintrange(0, num);
	if(!isdefined(speaker))
	{
		return;
	}
	/#
		iprintln((character + "") + snd);
	#/
	speaker playsoundwithnotify(snd, "line_done");
	speaker waittill(#"line_done");
	level.skit_vox_override = 0;
}

/*
	Name: do_skit_line
	Namespace: zm_temple_sq_skits
	Checksum: 0x9173FF5D
	Offset: 0x1CB8
	Size: 0x1BA
	Parameters: 1
	Flags: Linked
*/
function do_skit_line(script_line)
{
	players = getplayers();
	speaking_player = players[0];
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].zm_random_char))
		{
			if(players[i].zm_random_char == script_line.character)
			{
				speaking_player = players[i];
				break;
			}
			continue;
		}
		if(players[i].characterindex == script_line.character)
		{
			speaking_player = players[i];
			break;
		}
	}
	speaking_player.speaking_line = 1;
	level._last_skit_line_speaker = speaking_player;
	if(!isdefined(speaking_player))
	{
		return;
	}
	/#
		iprintln((speaking_player getentitynumber() + "") + script_line.vo);
	#/
	speaking_player playsoundwithnotify(script_line.vo, "line_done");
	speaking_player waittill(#"line_done");
	speaking_player.speaking_line = 0;
	level notify(#"line_spoken");
}

/*
	Name: start_skit
	Namespace: zm_temple_sq_skits
	Checksum: 0x740CC220
	Offset: 0x1E80
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function start_skit(skit_name, group)
{
	level endon(#"skit_interupt");
	script = level._skit_data[skit_name];
	level.skit_vox_override = 1;
	level thread skit_interupt(undefined, group);
	for(i = 0; i < script.size; i++)
	{
		if(i == (script.size - 1))
		{
			level notify(#"start_skit_done");
		}
		level thread do_skit_line(script[i]);
		level waittill(#"line_spoken");
	}
	level.skit_vox_override = 0;
}

/*
	Name: fail_skit
	Namespace: zm_temple_sq_skits
	Checksum: 0x430FDB2C
	Offset: 0x1F70
	Size: 0x35C
	Parameters: 1
	Flags: Linked
*/
function fail_skit(first_time)
{
	fail_skits = undefined;
	if(isdefined(first_time) && first_time)
	{
		fail_skits = array(level._skit_data["fail1"]);
	}
	else
	{
		fail_skits = array(level._skit_data["fail2"], level._skit_data["fail3"], level._skit_data["fail4"]);
	}
	players = getplayers();
	player_index = 0;
	proposed_group = undefined;
	while(player_index != players.size)
	{
		proposed_group = [];
		for(i = 0; i < players.size; i++)
		{
			if(i == player_index)
			{
				continue;
			}
			if(distance2dsquared(players[player_index].origin, players[i].origin) < 129600)
			{
				proposed_group[proposed_group.size] = players[i];
			}
		}
		player_index++;
		if(proposed_group.size > 0)
		{
			break;
		}
	}
	level.skit_vox_override = 1;
	skit = fail_skits[randomintrange(0, fail_skits.size)];
	if(proposed_group.size > 0)
	{
		pos = (0, 0, 0);
		for(i = 0; i < proposed_group.size; i++)
		{
			pos = pos + proposed_group[i].origin;
		}
		pos = pos / proposed_group.size;
		level endon(#"skit_interupt");
		level thread skit_interupt(pos, proposed_group);
		for(i = 0; i < proposed_group.size; i++)
		{
			level thread do_skit_line(skit[proposed_group[i].characterindex]);
			level waittill(#"line_spoken");
		}
	}
	else
	{
		player = players[randomintrange(0, players.size)];
		level thread do_skit_line(skit[player.characterindex]);
		level waittill(#"line_spoken");
	}
	level.skit_vox_override = 0;
}

