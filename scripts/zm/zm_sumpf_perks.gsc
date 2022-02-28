// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace zm_sumpf_perks;

/*
	Name: randomize_vending_machines
	Namespace: zm_sumpf_perks
	Checksum: 0x7203552E
	Offset: 0x408
	Size: 0x432
	Parameters: 0
	Flags: Linked
*/
function randomize_vending_machines()
{
	level._dont_unhide_quickervive_on_hotjoin = 1;
	vending_machines = [];
	vending_machines = function_1b58b796("zombie_vending");
	start_locations = [];
	start_locations[0] = getent("random_vending_start_location_0", "script_noteworthy");
	start_locations[1] = getent("random_vending_start_location_1", "script_noteworthy");
	start_locations[2] = getent("random_vending_start_location_2", "script_noteworthy");
	start_locations[3] = getent("random_vending_start_location_3", "script_noteworthy");
	level.start_locations = [];
	level.start_locations[level.start_locations.size] = start_locations[0].origin;
	level.start_locations[level.start_locations.size] = start_locations[1].origin;
	level.start_locations[level.start_locations.size] = start_locations[2].origin;
	level.start_locations[level.start_locations.size] = start_locations[3].origin;
	start_locations = array::randomize(start_locations);
	start_locations[4] = getent("random_vending_start_location_4", "script_noteworthy");
	level.start_locations[level.start_locations.size] = start_locations[4].origin;
	for(i = 0; i < vending_machines.size; i++)
	{
		if(vending_machines[i].script_noteworthy == "specialty_quickrevive")
		{
			t_temp = vending_machines[i];
			vending_machines[i] = vending_machines[4];
			vending_machines[4] = t_temp;
		}
	}
	for(i = 0; i < vending_machines.size; i++)
	{
		origin = start_locations[i].origin;
		angles = start_locations[i].angles;
		machine = vending_machines[i] get_vending_machine(start_locations[i]);
		if(vending_machines[i].script_noteworthy != "specialty_quickrevive")
		{
			vending_machines[i] triggerenable(0);
		}
		start_locations[i].origin = origin;
		start_locations[i].angles = angles;
		machine.origin = origin;
		machine.angles = angles;
		if(machine.script_string != "revive_perk")
		{
			machine ghost();
			vending_machines[i] thread function_bede3562(machine);
		}
	}
	level.sndperksacolajingleoverride = &function_25413096;
	level notify(#"hash_57a00baa");
}

/*
	Name: function_bede3562
	Namespace: zm_sumpf_perks
	Checksum: 0x458911A6
	Offset: 0x848
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function function_bede3562(var_22082ed0)
{
	str_on = self.script_noteworthy + "_power_on";
	level waittill(str_on);
	var_22082ed0.b_keep_when_turned_off = 1;
	wait(10);
	var_22082ed0 zm_perks::perk_fx(undefined, 1);
	level waittill(self.script_noteworthy + "_unhide");
	str_fx_name = level._custom_perks[self.script_noteworthy].machine_light_effect;
	var_22082ed0 zm_perks::perk_fx(str_fx_name);
	var_22082ed0.s_fxloc.angles = var_22082ed0.angles;
}

/*
	Name: function_1b58b796
	Namespace: zm_sumpf_perks
	Checksum: 0x6625FD84
	Offset: 0x938
	Size: 0x15E
	Parameters: 1
	Flags: Linked
*/
function function_1b58b796(str_trigger)
{
	vending_machines = [];
	var_560b7d8d = getentarray(str_trigger, "targetname");
	for(i = 0; i < var_560b7d8d.size; i++)
	{
		if(isdefined(var_560b7d8d[i].script_noteworthy))
		{
			if(!isdefined(vending_machines))
			{
				vending_machines = [];
			}
			else if(!isarray(vending_machines))
			{
				vending_machines = array(vending_machines);
			}
			vending_machines[vending_machines.size] = var_560b7d8d[i];
			if(var_560b7d8d[i].script_noteworthy != "specialty_quickrevive")
			{
				var_560b7d8d[i].var_6ecf729b = 1;
				var_560b7d8d[i] thread function_17db950e();
			}
			continue;
		}
		var_560b7d8d[i].var_6ecf729b = 0;
	}
	return vending_machines;
}

/*
	Name: function_17db950e
	Namespace: zm_sumpf_perks
	Checksum: 0xDC574001
	Offset: 0xAA0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_17db950e()
{
	level waittill(self.script_noteworthy + "_unhide");
	self.var_6ecf729b = 0;
}

/*
	Name: function_25413096
	Namespace: zm_sumpf_perks
	Checksum: 0x8A82878B
	Offset: 0xAD0
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function function_25413096()
{
	perksacola = self.script_sound;
	if(!self.var_6ecf729b)
	{
		playsoundatposition("evt_electrical_surge", self.origin);
		if(!isdefined(self.jingle_is_playing))
		{
			self.jingle_is_playing = 0;
		}
		if(isdefined(perksacola))
		{
			if(self.jingle_is_playing == 0 && level.music_override == 0)
			{
				self.jingle_is_playing = 1;
				self playsoundontag(perksacola, "tag_origin", "sound_done");
				if(issubstr(perksacola, "sting"))
				{
					wait(10);
				}
				else
				{
					if(isdefined(self.longjinglewait))
					{
						wait(60);
					}
					else
					{
						wait(30);
					}
				}
				self.jingle_is_playing = 0;
			}
		}
	}
}

/*
	Name: solo_disable_quickrevive
	Namespace: zm_sumpf_perks
	Checksum: 0x6F127C37
	Offset: 0xBE8
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function solo_disable_quickrevive()
{
	level flag::wait_till("solo_revive");
	self unlink();
	self triggerenable(0);
}

/*
	Name: get_vending_machine
	Namespace: zm_sumpf_perks
	Checksum: 0xA563579
	Offset: 0xC48
	Size: 0x178
	Parameters: 1
	Flags: Linked
*/
function get_vending_machine(start_location)
{
	machine = undefined;
	machine_clip = undefined;
	machine_array = getentarray(self.target, "targetname");
	for(i = 0; i < machine_array.size; i++)
	{
		if(isdefined(machine_array[i].script_noteworthy) && machine_array[i].script_noteworthy == "clip")
		{
			machine_clip = machine_array[i];
			continue;
		}
		machine = machine_array[i];
	}
	if(!isdefined(machine))
	{
		return;
	}
	if(isdefined(machine_clip))
	{
		machine_clip linkto(machine);
	}
	start_location.origin = machine.origin;
	start_location.angles = machine.angles;
	self enablelinkto();
	self linkto(start_location);
	return machine;
}

/*
	Name: activate_vending_machine
	Namespace: zm_sumpf_perks
	Checksum: 0xFCCB99C8
	Offset: 0xDC8
	Size: 0x18C
	Parameters: 3
	Flags: Linked
*/
function activate_vending_machine(machine, origin, entity)
{
	level notify(#"master_switch_activated");
	switch(machine)
	{
		case "p7_zm_vending_jugg":
		{
			var_da5a8677 = "mus_perks_jugganog_sting";
			level notify(#"hash_5203f90d");
			break;
		}
		case "p7_zm_vending_doubletap2":
		{
			var_da5a8677 = "mus_perks_doubletap_sting";
			level notify(#"hash_b5265d08");
			break;
		}
		case "p7_zm_vending_revive":
		{
			var_da5a8677 = "mus_perks_quickrevive_sting";
			level notify(#"hash_57a00baa");
			level._dont_unhide_quickervive_on_hotjoin = 0;
			break;
		}
		case "p7_zm_vending_sleight":
		{
			var_da5a8677 = "mus_perks_speed_sting";
			level notify(#"hash_5331339b");
			break;
		}
		case "p7_zm_vending_three_gun":
		{
			var_da5a8677 = "mus_perks_mulekick_sting";
			level notify(#"hash_d2e0b345");
			break;
		}
	}
	if(isdefined(var_da5a8677))
	{
		e_trigger = getent(var_da5a8677, "script_label");
		e_trigger triggerenable(1);
	}
	level notify(#"revive_on");
	play_vending_vo(machine, origin);
}

/*
	Name: play_vending_vo
	Namespace: zm_sumpf_perks
	Checksum: 0x8FFDEC1F
	Offset: 0xF60
	Size: 0x1B6
	Parameters: 2
	Flags: Linked
*/
function play_vending_vo(machine, origin)
{
	players = getplayers();
	players = array::get_all_closest(origin, players, undefined, undefined, 512);
	player = undefined;
	for(i = 0; i < players.size; i++)
	{
		if(sighttracepassed(players[i] geteye(), origin, 0, undefined))
		{
			player = players[i];
		}
	}
	if(!isdefined(player))
	{
		return;
	}
	switch(machine)
	{
		case "p7_zm_vending_jugg":
		{
			player thread zm_audio::create_and_play_dialog("level", "jugga");
			break;
		}
		case "p7_zm_vending_doubletap2":
		{
			player thread zm_audio::create_and_play_dialog("level", "doubletap");
			break;
		}
		case "p7_zm_vending_revive":
		{
			player thread zm_audio::create_and_play_dialog("level", "revive");
			break;
		}
		case "p7_zm_vending_sleight":
		{
			player thread zm_audio::create_and_play_dialog("level", "speed");
			break;
		}
	}
}

/*
	Name: vending_randomization_effect
	Namespace: zm_sumpf_perks
	Checksum: 0xFB4C0729
	Offset: 0x1120
	Size: 0xA34
	Parameters: 1
	Flags: Linked
*/
function vending_randomization_effect(index)
{
	vending_triggers = getentarray("zombie_vending", "targetname");
	machines = [];
	for(j = 0; j < vending_triggers.size; j++)
	{
		machine_array = getentarray(vending_triggers[j].target, "targetname");
		for(i = 0; i < machine_array.size; i++)
		{
			if(isdefined(machine_array[i].script_noteworthy) && machine_array[i].script_noteworthy == "clip")
			{
				continue;
				continue;
			}
			machines[j] = machine_array[i];
		}
	}
	for(j = 0; j < machines.size; j++)
	{
		if(machines[j].origin == level.start_locations[index])
		{
			break;
		}
	}
	if(isdefined(level.first_time_opening_perk_hut))
	{
		if(level.first_time_opening_perk_hut)
		{
			if(machines[j].model != "p7_zm_vending_jugg" || machines[j].model != "p7_zm_vending_sleight")
			{
				for(i = 0; i < machines.size; i++)
				{
					if(i != j && (machines[i].model == "p7_zm_vending_jugg" || machines[i].model == "p7_zm_vending_sleight"))
					{
						break;
					}
				}
				start_locations = [];
				start_locations[0] = getent("random_vending_start_location_0", "script_noteworthy");
				start_locations[1] = getent("random_vending_start_location_1", "script_noteworthy");
				start_locations[2] = getent("random_vending_start_location_2", "script_noteworthy");
				start_locations[3] = getent("random_vending_start_location_3", "script_noteworthy");
				start_locations[4] = getent("random_vending_start_location_4", "script_noteworthy");
				target_index = undefined;
				switch_index = undefined;
				for(x = 0; x < start_locations.size; x++)
				{
					if(start_locations[x].origin == level.start_locations[index])
					{
						target_index = x;
					}
					if(start_locations[x].origin == machines[i].origin)
					{
						switch_index = x;
					}
				}
				temp_origin = machines[j].origin;
				temp_angles = machines[j].angles;
				machines[j].origin = machines[i].origin;
				machines[j].angles = machines[i].angles;
				start_locations[target_index].origin = start_locations[switch_index].origin;
				start_locations[target_index].angles = start_locations[switch_index].angles;
				machines[i].origin = temp_origin;
				machines[i].angles = temp_angles;
				start_locations[switch_index].origin = temp_origin;
				start_locations[switch_index].angles = temp_angles;
				j = i;
			}
			level.first_time_opening_perk_hut = 0;
		}
	}
	playsoundatposition("zmb_rando_start", machines[j].origin);
	origin = machines[j].origin;
	if(level.vending_model_info.size > 1)
	{
		playfxontag(level._effect["zombie_perk_start"], machines[j], "tag_origin");
		playsoundatposition("zmb_rando_perk", machines[j].origin);
	}
	else
	{
		playfxontag(level._effect["zombie_perk_4th"], machines[j], "tag_origin");
		playsoundatposition("zmb_rando_perk", machines[j].origin);
	}
	true_model = machines[j].model;
	machines[j] setmodel(true_model);
	machines[j] show();
	floatheight = 40;
	level thread zm_utility::play_sound_2d("zmb_perk_lottery");
	machines[j] moveto(origin + (0, 0, floatheight), 5, 3, 0.5);
	tag_fx = spawn("script_model", machines[j].origin);
	tag_fx setmodel("tag_origin");
	tag_fx.angles = machines[j].angles;
	tag_fx linkto(machines[j]);
	playfxontag(level._effect["zombie_perk_smoke_anim"], tag_fx, "tag_origin");
	modelindex = 0;
	machines[j] vibrate(machines[j].angles, 2, 1, 4);
	for(i = 0; i < 30; i++)
	{
		wait(0.15);
		if(level.vending_model_info.size > 1)
		{
			while(!isdefined(level.vending_model_info[modelindex]))
			{
				modelindex++;
				if(modelindex == 4)
				{
					modelindex = 0;
				}
			}
			modelname = level.vending_model_info[modelindex];
			machines[j] setmodel(modelname);
			modelindex++;
			if(modelindex == 4)
			{
				modelindex = 0;
			}
		}
	}
	modelname = true_model;
	machines[j] setmodel(modelname);
	machines[j] moveto(origin, 0.3, 0.3, 0);
	wait(0.2);
	playfxontag(level._effect["zombie_perk_end"], machines[j], "tag_origin");
	playsoundatposition("zmb_drop_perk_machine", machines[j].origin);
	wait(0.05);
	playfxontag(level._effect["zombie_perk_flash"], machines[j], "tag_origin");
	activate_vending_machine(true_model, origin, machines[j]);
}

