// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equip_hacker;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_moon_amb;
#using scripts\zm\zm_moon_sq;

#namespace zm_moon_sq_ss;

/*
	Name: ss_debug
	Namespace: zm_moon_sq_ss
	Checksum: 0x81E3CC71
	Offset: 0x4F8
	Size: 0x558
	Parameters: 0
	Flags: Linked
*/
function ss_debug()
{
	/#
		level endon(#"sq_ss1_over");
		level endon(#"sq_ss2_over");
		if(!isdefined(level._debug_ss))
		{
			level._debug_ss = 1;
			level.ss_val = newdebughudelem();
			level.ss_val.location = 0;
			level.ss_val.alignx = "";
			level.ss_val.aligny = "";
			level.ss_val.foreground = 1;
			level.ss_val.fontscale = 1.3;
			level.ss_val.sort = 20;
			level.ss_val.x = 10;
			level.ss_val.y = 240;
			level.ss_val.og_scale = 1;
			level.ss_val.color = vectorscale((1, 1, 1), 255);
			level.ss_val.alpha = 1;
			level.ss_val_text = newdebughudelem();
			level.ss_val_text.location = 0;
			level.ss_val_text.alignx = "";
			level.ss_val_text.aligny = "";
			level.ss_val_text.foreground = 1;
			level.ss_val_text.fontscale = 1.3;
			level.ss_val_text.sort = 20;
			level.ss_val_text.x = 0;
			level.ss_val_text.y = 240;
			level.ss_val_text.og_scale = 1;
			level.ss_val_text.color = vectorscale((1, 1, 1), 255);
			level.ss_val_text.alpha = 1;
			level.ss_val_text settext("");
			level.ss_user_val = newdebughudelem();
			level.ss_user_val.location = 0;
			level.ss_user_val.alignx = "";
			level.ss_user_val.aligny = "";
			level.ss_user_val.foreground = 1;
			level.ss_user_val.fontscale = 1.3;
			level.ss_user_val.sort = 20;
			level.ss_user_val.x = 10;
			level.ss_user_val.y = 270;
			level.ss_user_val.og_scale = 1;
			level.ss_user_val.color = vectorscale((1, 1, 1), 255);
			level.ss_user_val.alpha = 1;
			level.ss_user_val_text = newdebughudelem();
			level.ss_user_val_text.location = 0;
			level.ss_user_val_text.alignx = "";
			level.ss_user_val_text.aligny = "";
			level.ss_user_val_text.foreground = 1;
			level.ss_user_val_text.fontscale = 1.3;
			level.ss_user_val_text.sort = 20;
			level.ss_user_val_text.x = 0;
			level.ss_user_val_text.y = 270;
			level.ss_user_val_text.og_scale = 1;
			level.ss_user_val_text.color = vectorscale((1, 1, 1), 255);
			level.ss_user_val_text.alpha = 1;
			level.ss_user_val_text settext("");
		}
		while(true)
		{
			if(isdefined(level._ss_user_seq))
			{
				str = "";
				for(i = 0; i < level._ss_user_seq.size; i++)
				{
					str = str + level._ss_user_seq[i];
				}
				level.ss_user_val settext(str);
			}
			else
			{
				level.ss_user_val settext("");
			}
			wait(0.1);
		}
	#/
}

/*
	Name: init_1
	Namespace: zm_moon_sq_ss
	Checksum: 0xFB5FA100
	Offset: 0xA58
	Size: 0x148
	Parameters: 0
	Flags: Linked
*/
function init_1()
{
	level flag::init("displays_active");
	level flag::init("wait_for_hack");
	zm_sidequests::declare_sidequest_stage("sq", "ss1", &init_stage_1, &stage_logic, &exit_stage_1);
	buttons = getentarray("sq_ss_button", "targetname");
	for(i = 0; i < buttons.size; i++)
	{
		ent = getent(buttons[i].target, "targetname");
		buttons[i].terminal_model = ent;
	}
	level._ss_buttons = buttons;
}

/*
	Name: init_2
	Namespace: zm_moon_sq_ss
	Checksum: 0xA272F70F
	Offset: 0xBA8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function init_2()
{
	zm_sidequests::declare_sidequest_stage("sq", "ss2", &init_stage_2, &stage_logic, &exit_stage_2);
}

/*
	Name: init_stage_1
	Namespace: zm_moon_sq_ss
	Checksum: 0xEF332A35
	Offset: 0xC08
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function init_stage_1()
{
	level flag::clear("wait_for_hack");
	level._ss_stage = 1;
}

/*
	Name: init_stage_2
	Namespace: zm_moon_sq_ss
	Checksum: 0x7822343
	Offset: 0xC40
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function init_stage_2()
{
	level._ss_stage = 2;
}

/*
	Name: ss2_hack
	Namespace: zm_moon_sq_ss
	Checksum: 0x1434F9E3
	Offset: 0xC58
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function ss2_hack(hacker)
{
	level flag::clear("wait_for_hack");
}

/*
	Name: stage_logic
	Namespace: zm_moon_sq_ss
	Checksum: 0x96C969D
	Offset: 0xC90
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function stage_logic()
{
	buttons = level._ss_buttons;
	array::thread_all(buttons, &sq_ss_button_thread);
	if(isdefined(level._ss_hacks))
	{
		for(i = 0; i < level._ss_hacks.size; i++)
		{
			zm_equip_hacker::deregister_hackable_struct(level._ss_hacks[i]);
		}
	}
	level thread ss_debug();
	if(level._ss_stage == 1)
	{
		do_ss1_logic();
	}
	else
	{
		do_ss2_logic();
	}
	zm_sidequests::stage_completed("sq", "ss" + level._ss_stage);
}

/*
	Name: do_ss1_logic
	Namespace: zm_moon_sq_ss
	Checksum: 0xEC3FE8A
	Offset: 0xDA8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function do_ss1_logic()
{
	ss_logic(6, 1);
}

/*
	Name: do_ss2_logic
	Namespace: zm_moon_sq_ss
	Checksum: 0x95617AB
	Offset: 0xDD0
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function do_ss2_logic()
{
	level.ss_comp_vox_count = 0;
	ss_logic(6, 3);
	wait(2);
	level notify(#"rl");
	ss_logic(7, 4);
	wait(2);
	level notify(#"rl");
	ss_logic(8, 5);
	wait(2);
	level notify(#"rl");
}

/*
	Name: generate_sequence
	Namespace: zm_moon_sq_ss
	Checksum: 0xA83B18E
	Offset: 0xE78
	Size: 0x214
	Parameters: 1
	Flags: Linked
*/
function generate_sequence(seq_length)
{
	seq = [];
	for(i = 0; i < seq_length; i++)
	{
		seq[seq.size] = randomintrange(0, 4);
	}
	last = -1;
	num_reps = 0;
	for(i = 0; i < seq_length; i++)
	{
		if(seq[i] == last)
		{
			num_reps++;
			if(num_reps >= 2)
			{
				while(seq[i] == last)
				{
					seq[i] = randomintrange(0, 4);
				}
				num_reps = 0;
				last = seq[i];
			}
			continue;
		}
		last = seq[i];
		num_reps = 0;
	}
	/#
		if(isdefined(level.ss_val))
		{
			str = "";
			for(i = 0; i < seq.size; i++)
			{
				str = str + seq[i];
			}
			level.ss_val settext(str);
		}
	#/
	if(1 == getdvarint("scr_debug_ss"))
	{
		for(i = 0; i < seq.size; i++)
		{
			seq[i] = 0;
		}
	}
	return seq;
}

/*
	Name: kill_debug
	Namespace: zm_moon_sq_ss
	Checksum: 0xB561C824
	Offset: 0x1098
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function kill_debug()
{
	/#
		if(isdefined(level.ss_val))
		{
			level.ss_val destroy();
			level.ss_val = undefined;
			level.ss_val_text destroy();
			level.ss_val_text = undefined;
			level.ss_user_val destroy();
			level.ss_user_val = undefined;
			level.ss_user_val_text destroy();
			level.ss_user_val_text = undefined;
			level._debug_ss = undefined;
		}
	#/
}

/*
	Name: exit_stage_1
	Namespace: zm_moon_sq_ss
	Checksum: 0x4897C184
	Offset: 0x1140
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function exit_stage_1(success)
{
	kill_debug();
	level flag::set("ss1");
	array::thread_all(level._ss_buttons, &sq_ss_button_dud_thread);
}

/*
	Name: exit_stage_2
	Namespace: zm_moon_sq_ss
	Checksum: 0x35538CD9
	Offset: 0x11B0
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function exit_stage_2(success)
{
	kill_debug();
}

/*
	Name: sq_ss_button_dud_thread
	Namespace: zm_moon_sq_ss
	Checksum: 0x2FB6565A
	Offset: 0x11D8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function sq_ss_button_dud_thread()
{
	self endon(#"ss_kill_button_thread");
	self thread sq_ss_button_thread(1);
}

/*
	Name: sq_ss_button_debug
	Namespace: zm_moon_sq_ss
	Checksum: 0x73135C14
	Offset: 0x1208
	Size: 0x80
	Parameters: 0
	Flags: None
*/
function sq_ss_button_debug()
{
	level endon(#"ss_kill_button_thread");
	level endon(#"sq_ss1_over");
	level endon(#"sq_ss2_over");
	while(true)
	{
		/#
			print3d(self.origin + vectorscale((0, 0, 1), 12), self.script_int, vectorscale((0, 1, 0), 255), 1);
		#/
		wait(0.1);
	}
}

/*
	Name: do_attract
	Namespace: zm_moon_sq_ss
	Checksum: 0x125AC8B
	Offset: 0x1290
	Size: 0x35C
	Parameters: 0
	Flags: Linked
*/
function do_attract()
{
	level flag::set("displays_active");
	buttons = level._ss_buttons;
	for(i = 0; i < buttons.size; i++)
	{
		ent = buttons[i].terminal_model;
		ent setmodel("p7_zm_moo_computer_rocket_launch");
	}
	for(i = 0; i < buttons.size; i++)
	{
		button = undefined;
		for(j = 0; j < buttons.size; j++)
		{
			if(buttons[j].script_int == i)
			{
				button = buttons[j];
			}
		}
		if(isdefined(button))
		{
			ent = button.terminal_model;
			model = get_console_model(button.script_int);
			ent setmodel(model);
			ent playsound(color_sound_selector(button.script_int));
			wait(0.6);
			ent setmodel("p7_zm_moo_computer_rocket_launch");
		}
	}
	level thread do_ss_start_vox(level._ss_stage);
	for(i = buttons.size - 1; i >= 0; i--)
	{
		button = undefined;
		for(j = 0; j < buttons.size; j++)
		{
			if(buttons[j].script_int == i)
			{
				button = buttons[j];
			}
		}
		if(isdefined(button))
		{
			ent = button.terminal_model;
			model = get_console_model(button.script_int);
			ent setmodel(model);
			ent playsound(color_sound_selector(button.script_int));
			wait(0.6);
			ent setmodel("p7_zm_moo_computer_rocket_launch");
		}
	}
	wait(0.5);
	level flag::clear("displays_active");
}

/*
	Name: sq_ss_button_thread
	Namespace: zm_moon_sq_ss
	Checksum: 0x9842501F
	Offset: 0x15F8
	Size: 0x190
	Parameters: 1
	Flags: Linked
*/
function sq_ss_button_thread(dud)
{
	level endon(#"sq_ss1_over");
	level endon(#"sq_ss2_over");
	if(!isdefined(dud))
	{
		self notify(#"ss_kill_button_thread");
	}
	pos = self.origin;
	pressed = self.origin - (anglestoright(self.angles) * 0.25);
	targ_model = self.terminal_model;
	while(true)
	{
		self waittill(#"trigger");
		if(!level flag::get("displays_active"))
		{
			if(!isdefined(dud))
			{
				if(isdefined(level._ss_user_seq))
				{
					level._ss_user_seq[level._ss_user_seq.size] = self.script_int;
				}
			}
			model = get_console_model(self.script_int);
			targ_model playsound(color_sound_selector(self.script_int));
			targ_model setmodel(model);
		}
		wait(0.3);
		targ_model setmodel("p7_zm_moo_computer_rocket_launch");
	}
}

/*
	Name: get_console_model
	Namespace: zm_moon_sq_ss
	Checksum: 0xA6BF3DCD
	Offset: 0x1790
	Size: 0x96
	Parameters: 1
	Flags: Linked
*/
function get_console_model(num)
{
	model = "p7_zm_moo_computer_rocket_launch";
	switch(num)
	{
		case 0:
		{
			model = "p7_zm_moo_computer_rocket_launch_red";
			break;
		}
		case 1:
		{
			model = "p7_zm_moo_computer_rocket_launch_green";
			break;
		}
		case 2:
		{
			model = "p7_zm_moo_computer_rocket_launch_blue";
			break;
		}
		case 3:
		{
			model = "p7_zm_moo_computer_rocket_launch_yellow";
			break;
		}
	}
	return model;
}

/*
	Name: ss_logic
	Namespace: zm_moon_sq_ss
	Checksum: 0x30DA104D
	Offset: 0x1830
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function ss_logic(seq_length, seq_start_length)
{
	seq = generate_sequence(seq_length);
	level._ss_user_seq = [];
	level._ss_sequence_matched = 0;
	fails = 0;
	while(!level._ss_sequence_matched)
	{
		wait(0.5);
		self thread ss_logic_internal(seq, seq_length, seq_start_length);
		self util::waittill_either("ss_won", "ss_failed");
		if(level._ss_sequence_matched)
		{
			display_success(seq);
		}
		else
		{
			display_fail();
			fails++;
			if(fails == 4)
			{
				seq = generate_sequence(seq_length);
				fails = 0;
			}
		}
	}
}

/*
	Name: ss_logic_internal
	Namespace: zm_moon_sq_ss
	Checksum: 0x5BDAAEEE
	Offset: 0x1968
	Size: 0x102
	Parameters: 3
	Flags: Linked
*/
function ss_logic_internal(seq, seq_length, seq_start_length)
{
	self endon(#"ss_won");
	self endon(#"ss_failed");
	do_attract();
	pos = seq_start_length;
	buttons = level._ss_buttons;
	for(i = pos; i <= seq_length; i++)
	{
		level._ss_user_seq = [];
		display_seq(buttons, seq, i);
		wait(1);
		validate_input(seq, i);
		wait(1);
	}
	level._ss_sequence_matched = 1;
	self notify(#"ss_won");
}

/*
	Name: user_input_timeout
	Namespace: zm_moon_sq_ss
	Checksum: 0xE3680651
	Offset: 0x1A78
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function user_input_timeout(len)
{
	self endon(#"correct_input");
	self endon(#"ss_failed");
	self endon(#"ss_won");
	wait(len * 4);
	self notify(#"ss_failed");
}

/*
	Name: validate_input
	Namespace: zm_moon_sq_ss
	Checksum: 0xD9E1CE6C
	Offset: 0x1AC8
	Size: 0x10E
	Parameters: 2
	Flags: Linked
*/
function validate_input(sequence, len)
{
	self thread user_input_timeout(len);
	while(level._ss_user_seq.size < len)
	{
		for(i = 0; i < level._ss_user_seq.size; i++)
		{
			if(level._ss_user_seq[i] != sequence[i])
			{
				self notify(#"ss_failed");
			}
		}
		wait(0.05);
	}
	for(i = 0; i < level._ss_user_seq.size; i++)
	{
		if(level._ss_user_seq[i] != sequence[i])
		{
			self notify(#"ss_failed");
		}
	}
	level._ss_user_seq = [];
	self notify(#"correct_input");
}

/*
	Name: display_fail
	Namespace: zm_moon_sq_ss
	Checksum: 0x2087A31D
	Offset: 0x1BE0
	Size: 0x234
	Parameters: 0
	Flags: Linked
*/
function display_fail()
{
	level flag::set("displays_active");
	buttons = level._ss_buttons;
	level thread do_ss_failure_vox(level._ss_stage);
	all_screens_black = 0;
	while(!all_screens_black)
	{
		all_screens_black = 1;
		for(i = 0; i < buttons.size; i++)
		{
			ent = buttons[i].terminal_model;
			if(ent.model != "p7_zm_moo_computer_rocket_launch")
			{
				all_screens_black = 0;
				break;
			}
		}
		wait(0.1);
	}
	level thread sound::play_in_space("evt_ss_wrong", (-1006.3, 294.2, -93.7));
	for(i = 0; i < 5; i++)
	{
		for(j = 0; j < buttons.size; j++)
		{
			ent = buttons[j].terminal_model;
			ent setmodel("p7_zm_moo_computer_rocket_launch_red");
		}
		wait(0.2);
		for(j = 0; j < buttons.size; j++)
		{
			ent = buttons[j].terminal_model;
			ent setmodel("p7_zm_moo_computer_rocket_launch");
		}
		wait(0.05);
	}
	level flag::clear("displays_active");
}

/*
	Name: play_win_seq
	Namespace: zm_moon_sq_ss
	Checksum: 0x9267E87A
	Offset: 0x1E20
	Size: 0x86
	Parameters: 1
	Flags: Linked
*/
function play_win_seq(seq)
{
	for(i = 0; i < seq.size; i++)
	{
		level thread sound::play_in_space(color_sound_selector(seq[i]), (-1006.3, 294.2, -93.7));
		wait(0.2);
	}
}

/*
	Name: display_success
	Namespace: zm_moon_sq_ss
	Checksum: 0x8DF2E6BE
	Offset: 0x1EB0
	Size: 0x224
	Parameters: 1
	Flags: Linked
*/
function display_success(seq)
{
	level flag::set("displays_active");
	buttons = level._ss_buttons;
	level thread do_ss_success_vox(level._ss_stage);
	all_screens_black = 0;
	while(!all_screens_black)
	{
		all_screens_black = 1;
		for(i = 0; i < buttons.size; i++)
		{
			ent = buttons[i].terminal_model;
			if(ent.model != "p7_zm_moo_computer_rocket_launch")
			{
				all_screens_black = 0;
				break;
			}
		}
		wait(0.1);
	}
	level thread play_win_seq(seq);
	for(i = 0; i < 5; i++)
	{
		for(j = 0; j < buttons.size; j++)
		{
			ent = buttons[j].terminal_model;
			ent setmodel("p7_zm_moo_computer_rocket_launch_green");
		}
		wait(0.2);
		for(j = 0; j < buttons.size; j++)
		{
			ent = buttons[j].terminal_model;
			ent setmodel("p7_zm_moo_computer_rocket_launch");
		}
		wait(0.05);
	}
	level flag::clear("displays_active");
}

/*
	Name: display_seq
	Namespace: zm_moon_sq_ss
	Checksum: 0xC48A72F5
	Offset: 0x20E0
	Size: 0x21C
	Parameters: 3
	Flags: Linked
*/
function display_seq(buttons, seq, index)
{
	level flag::set("displays_active");
	for(i = 0; i < index; i++)
	{
		print_duration = 1;
		wait_duration = 0.4;
		if(i < (index - 1))
		{
			print_duration = print_duration / 2;
			wait_duration = wait_duration / 2;
		}
		for(j = 0; j < buttons.size; j++)
		{
			ent = buttons[j].terminal_model;
			model = get_console_model(seq[i]);
			level thread sound::play_in_space(color_sound_selector(seq[i]), (-1006.3, 294.2, -93.7));
			ent setmodel(model);
		}
		wait(print_duration);
		for(j = 0; j < buttons.size; j++)
		{
			ent = buttons[j].terminal_model;
			ent setmodel("p7_zm_moo_computer_rocket_launch");
		}
		wait(wait_duration);
	}
	level flag::clear("displays_active");
}

/*
	Name: color_sound_selector
	Namespace: zm_moon_sq_ss
	Checksum: 0x8A5A5A66
	Offset: 0x2308
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function color_sound_selector(index)
{
	switch(index)
	{
		case 0:
		{
			return "evt_ss_e";
		}
		case 1:
		{
			return "evt_ss_d";
		}
		case 2:
		{
			return "evt_ss_c";
		}
		case 3:
		{
			return "evt_ss_lo_g";
		}
	}
}

/*
	Name: do_ss_start_vox
	Namespace: zm_moon_sq_ss
	Checksum: 0xE3ADB3B6
	Offset: 0x2370
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function do_ss_start_vox(stage)
{
	playon = level._ss_buttons[1].terminal_model;
	if(stage == 1)
	{
		player = is_player_close_enough(playon);
		if(isdefined(player))
		{
			playon playsoundwithnotify("vox_mcomp_quest_step1_0", "mcomp_done0");
			playon waittill(#"mcomp_done0");
			if(isdefined(player))
			{
				player thread zm_audio::create_and_play_dialog("eggs", "quest1", 0);
			}
		}
	}
	else if(level.ss_comp_vox_count == 0)
	{
		playon playsoundwithnotify("vox_mcomp_quest_step7_0", "mcomp_done1");
	}
}

/*
	Name: do_ss_failure_vox
	Namespace: zm_moon_sq_ss
	Checksum: 0x4B6F772B
	Offset: 0x2480
	Size: 0x1AE
	Parameters: 1
	Flags: Linked
*/
function do_ss_failure_vox(stage)
{
	playon = level._ss_buttons[1].terminal_model;
	if(stage == 1)
	{
		player = is_player_close_enough(playon);
		if(isdefined(player))
		{
			playon playsoundwithnotify("vox_mcomp_quest_step1_1", "mcomp_done2");
			playon waittill(#"mcomp_done2");
			if(isdefined(player))
			{
				player thread zm_audio::create_and_play_dialog("eggs", "quest1", 1);
			}
		}
	}
	else
	{
		player = is_player_close_enough(playon);
		if(isdefined(player))
		{
			switch(level.ss_comp_vox_count)
			{
				case 0:
				{
					player thread zm_audio::create_and_play_dialog("eggs", "quest1", 1);
					break;
				}
				case 1:
				{
					player thread zm_audio::create_and_play_dialog("eggs", "quest7", 1);
					break;
				}
				case 2:
				{
					player thread zm_audio::create_and_play_dialog("eggs", "quest7", 3);
					break;
				}
			}
		}
	}
}

/*
	Name: do_ss_success_vox
	Namespace: zm_moon_sq_ss
	Checksum: 0xE8B3A417
	Offset: 0x2638
	Size: 0x1D6
	Parameters: 1
	Flags: Linked
*/
function do_ss_success_vox(stage)
{
	playon = level._ss_buttons[1].terminal_model;
	if(stage == 1)
	{
		player = is_player_close_enough(playon);
		if(isdefined(player))
		{
			playon playsoundwithnotify("vox_mcomp_quest_step1_2", "mcomp_done3");
			playon waittill(#"mcomp_done3");
			if(isdefined(player))
			{
				player thread zm_audio::create_and_play_dialog("eggs", "quest1", 2);
			}
		}
	}
	else
	{
		switch(level.ss_comp_vox_count)
		{
			case 0:
			{
				playon playsoundwithnotify("vox_mcomp_quest_step7_2", "mcomp_done4");
				level.ss_comp_vox_count++;
				break;
			}
			case 1:
			{
				playon playsoundwithnotify("vox_mcomp_hack_success", "mcomp_done5");
				level.ss_comp_vox_count++;
				break;
			}
			case 2:
			{
				playon playsoundwithnotify("vox_mcomp_quest_step7_4", "mcomp_done6");
				playon waittill(#"mcomp_done6");
				if(!level flag::get("be2"))
				{
					playon playsoundwithnotify("vox_xcomp_quest_step7_5", "xcomp_done7");
				}
				break;
			}
		}
	}
}

/*
	Name: is_player_close_enough
	Namespace: zm_moon_sq_ss
	Checksum: 0x2F4139B1
	Offset: 0x2818
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function is_player_close_enough(org)
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(distancesquared(org.origin, players[i].origin) <= 5625)
		{
			return players[i];
		}
	}
	return undefined;
}

