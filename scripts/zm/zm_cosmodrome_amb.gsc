// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace zm_cosmodrome_amb;

/*
	Name: main
	Namespace: zm_cosmodrome_amb
	Checksum: 0x55B4A5A8
	Offset: 0x3C0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level._blackhole_bomb_valid_area_check = &function_a0f14d15;
	level thread function_5b4692c9();
	level thread monkey_round_announcer();
	level thread radio_easter_eggs();
	level thread function_7624a208();
	level thread init_redphone_eggs();
	level thread function_337aada8();
	level thread init_doll_eggs();
	level thread play_intro_music();
}

/*
	Name: play_intro_music
	Namespace: zm_cosmodrome_amb
	Checksum: 0xDBD49CF6
	Offset: 0x4A8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function play_intro_music()
{
	level waittill(#"hash_fd9adc1e");
	level thread zm_audio::sndmusicsystem_playstate("round_start_first_lander");
}

/*
	Name: power_clangs
	Namespace: zm_cosmodrome_amb
	Checksum: 0x41C9ABC6
	Offset: 0x4E0
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function power_clangs()
{
	clangs = struct::get_array("amb_power_clang", "targetname");
	for(i = 0; i < clangs.size; i++)
	{
		playsoundatposition("zmb_circuit", clangs[i].origin);
		wait(randomfloatrange(0.25, 0.7));
	}
}

/*
	Name: play_cosmo_announcer_vox
	Namespace: zm_cosmodrome_amb
	Checksum: 0xAFAE44F0
	Offset: 0x598
	Size: 0xFC
	Parameters: 3
	Flags: Linked
*/
function play_cosmo_announcer_vox(alias, alarm_override, wait_override)
{
	if(!isdefined(alias))
	{
		return;
	}
	if(!isdefined(level.cosmann_is_speaking))
	{
		level.cosmann_is_speaking = 0;
	}
	if(!isdefined(alarm_override))
	{
		alarm_override = 0;
	}
	if(!isdefined(wait_override))
	{
		wait_override = 0;
	}
	if(level.cosmann_is_speaking == 0 && wait_override == 0)
	{
		level.cosmann_is_speaking = 1;
		if(!alarm_override)
		{
			level play_initial_alarm();
		}
		level zm_utility::really_play_2d_sound(alias);
		level.cosmann_is_speaking = 0;
	}
	else if(wait_override == 1)
	{
		level zm_utility::really_play_2d_sound(alias);
	}
}

/*
	Name: play_gersh_vox
	Namespace: zm_cosmodrome_amb
	Checksum: 0x49B769BA
	Offset: 0x6A0
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function play_gersh_vox(alias)
{
	if(!isdefined(alias))
	{
		return;
	}
	if(!isdefined(level.gersh_is_speaking))
	{
		level.gersh_is_speaking = 0;
	}
	if(level.gersh_is_speaking == 0)
	{
		level.gersh_is_speaking = 1;
		level zm_utility::really_play_2d_sound(alias);
		level.gersh_is_speaking = 0;
	}
}

/*
	Name: play_initial_alarm
	Namespace: zm_cosmodrome_amb
	Checksum: 0xB23EBE59
	Offset: 0x718
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function play_initial_alarm()
{
	structs = struct::get_array("amb_warning_siren", "targetname");
	wait(1);
	for(i = 0; i < structs.size; i++)
	{
		playsoundatposition("evt_cosmo_alarm_single", structs[i].origin);
	}
	wait(0.5);
}

/*
	Name: monkey_round_announcer
	Namespace: zm_cosmodrome_amb
	Checksum: 0xEFFF50E0
	Offset: 0x7B8
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function monkey_round_announcer()
{
	wait(3);
	while(true)
	{
		level flag::wait_till("monkey_round");
		level thread play_cosmo_announcer_vox("vox_ann_monkey_begin");
		level waittill(#"between_round_over");
		level thread play_cosmo_announcer_vox("vox_ann_monkey_end");
		wait(10);
	}
}

/*
	Name: radio_easter_eggs
	Namespace: zm_cosmodrome_amb
	Checksum: 0xD5C51A1
	Offset: 0x840
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function radio_easter_eggs()
{
	var_385d0c76 = struct::get_array("radio_egg", "targetname");
	array::thread_all(var_385d0c76, &function_5fd10b57);
}

/*
	Name: function_5fd10b57
	Namespace: zm_cosmodrome_amb
	Checksum: 0xC71C7D78
	Offset: 0x8A0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_5fd10b57()
{
	self zm_unitrigger::create_unitrigger();
	self waittill(#"trigger_activated");
	playsoundatposition("vox_radio_egg_" + self.script_int, self.origin);
}

/*
	Name: function_7624a208
	Namespace: zm_cosmodrome_amb
	Checksum: 0xBA8E27EF
	Offset: 0x900
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_7624a208()
{
	level thread zm_audio_zhd::function_e753d4f();
	level flag::wait_till("snd_song_completed");
	level thread zm_audio::sndmusicsystem_playstate("abracadavre");
}

/*
	Name: function_337aada8
	Namespace: zm_cosmodrome_amb
	Checksum: 0x17F13715
	Offset: 0x968
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_337aada8()
{
	level.var_568da27 = 0;
	var_85d06ae4 = struct::get_array("egg_phone", "targetname");
	while(true)
	{
		level waittill(#"hash_b524a8eb");
		level.var_568da27++;
		if(level.var_568da27 == var_85d06ae4.size)
		{
			break;
		}
	}
	level notify(#"hash_2d7a77fa");
	level thread zm_audio::sndmusicsystem_playstate("not_ready_to_die");
}

/*
	Name: function_10544d8
	Namespace: zm_cosmodrome_amb
	Checksum: 0xF0F7873
	Offset: 0xA10
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_10544d8()
{
	self endon(#"phone_activated");
	self endon(#"timeout");
	self.t_damage = spawn("trigger_damage", self.origin, 0, 5, 5);
	while(true)
	{
		self.t_damage waittill(#"damage", n_amount, e_attacker, dir, point, str_means_of_death);
		if(!zm_audio_zhd::function_8090042c())
		{
			continue;
		}
		if(!isplayer(e_attacker))
		{
			continue;
		}
		if(str_means_of_death != "MOD_MELEE")
		{
			continue;
		}
		if(distancesquared(e_attacker.origin, self.origin) > 4225)
		{
			continue;
		}
		break;
	}
	self.broken = 1;
	self notify(#"hash_b524a8eb");
	if(isdefined(self.var_48df29fd))
	{
		self.var_48df29fd delete();
	}
	level notify(#"hash_b524a8eb");
	playsoundatposition("zmb_redphone_destroy", self.origin);
	self.t_damage delete();
}

/*
	Name: init_redphone_eggs
	Namespace: zm_cosmodrome_amb
	Checksum: 0xD73FE40A
	Offset: 0xBD0
	Size: 0x268
	Parameters: 0
	Flags: Linked
*/
function init_redphone_eggs()
{
	level endon(#"hash_2d7a77fa");
	var_85d06ae4 = struct::get_array("egg_phone", "targetname");
	var_a008170d = array(0, 1, 2, 3, 4, 5, 6, 7, 8);
	if(var_85d06ae4.size <= 0)
	{
		return;
	}
	var_693fabd9 = undefined;
	while(true)
	{
		wait(randomintrange(90, 240));
		while(true)
		{
			var_9d999891 = array::random(var_85d06ae4);
			arrayremovevalue(var_85d06ae4, var_9d999891);
			if(var_85d06ae4.size <= 0)
			{
				var_85d06ae4 = struct::get_array("egg_phone", "targetname");
			}
			if(isdefined(var_9d999891.broken) && var_9d999891.broken)
			{
				continue;
			}
			break;
		}
		activation = var_9d999891 function_de8ef595();
		if(isdefined(activation) && activation)
		{
			var_f1b4932d = array::random(var_a008170d);
			arrayremovevalue(var_a008170d, var_f1b4932d);
			if(var_a008170d.size <= 0)
			{
				var_a008170d = array(0, 1, 2, 3, 4, 5, 6, 7, 8);
			}
			playsoundatposition("vox_egg_redphone_" + var_f1b4932d, var_9d999891.origin);
			var_693fabd9 = var_f1b4932d;
			wait(30);
		}
	}
}

/*
	Name: function_de8ef595
	Namespace: zm_cosmodrome_amb
	Checksum: 0x55BE04C
	Offset: 0xE40
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_de8ef595()
{
	level endon(#"hash_2d7a77fa");
	self endon(#"hash_b524a8eb");
	self thread function_99199901();
	self thread function_d772340();
	self thread function_10544d8();
	self.var_a3f075d6 = 1;
	str_notify = self util::waittill_any_return("phone_activated", "timeout");
	self.var_a3f075d6 = 0;
	if(isdefined(self.t_damage))
	{
		self.t_damage delete();
	}
	if(str_notify === "timeout")
	{
		return false;
	}
	return true;
}

/*
	Name: function_99199901
	Namespace: zm_cosmodrome_amb
	Checksum: 0x30ECC7A6
	Offset: 0xF30
	Size: 0x198
	Parameters: 0
	Flags: Linked
*/
function function_99199901()
{
	level endon(#"hash_2d7a77fa");
	self endon(#"timeout");
	self endon(#"hash_b524a8eb");
	self.var_7f6e3a35 = spawn("trigger_radius", self.origin - vectorscale((0, 0, 1), 200), 0, 75, 400);
	self.var_48df29fd = spawn("script_origin", self.origin);
	self.var_48df29fd playloopsound("zmb_egg_phone_loop", 0.05);
	while(true)
	{
		self.var_7f6e3a35 waittill(#"trigger", who);
		if(!isplayer(who))
		{
			wait(0.05);
			continue;
		}
		while(who istouching(self.var_7f6e3a35))
		{
			if(who usebuttonpressed())
			{
				self notify(#"phone_activated");
				self.var_7f6e3a35 delete();
				self.var_48df29fd delete();
				return;
			}
			wait(0.05);
		}
	}
}

/*
	Name: function_d772340
	Namespace: zm_cosmodrome_amb
	Checksum: 0x82CEB9D8
	Offset: 0x10D0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_d772340()
{
	level endon(#"hash_2d7a77fa");
	self endon(#"phone_activated");
	self endon(#"hash_b524a8eb");
	wait(10);
	self notify(#"timeout");
	self.var_7f6e3a35 delete();
	self.var_48df29fd delete();
}

/*
	Name: init_doll_eggs
	Namespace: zm_cosmodrome_amb
	Checksum: 0xC2B93900
	Offset: 0x1148
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function init_doll_eggs()
{
	wait(10);
	for(i = 0; i < 4; i++)
	{
		ent = getent("doll_egg_" + i, "targetname");
		if(!isdefined(ent))
		{
			return;
		}
		ent thread doll_egg(i);
	}
}

/*
	Name: doll_egg
	Namespace: zm_cosmodrome_amb
	Checksum: 0x984750
	Offset: 0x11E0
	Size: 0x1B6
	Parameters: 1
	Flags: Linked
*/
function doll_egg(num)
{
	if(!isdefined(self))
	{
		return;
	}
	self usetriggerrequirelookat();
	self setcursorhint("HINT_NOICON");
	alias = undefined;
	while(true)
	{
		self waittill(#"trigger", player);
		index = zm_utility::get_player_index(player);
		switch(index)
		{
			case 0:
			{
				alias = ("vox_egg_doll_response_" + num) + "_0";
				break;
			}
			case 1:
			{
				alias = ("vox_egg_doll_response_" + num) + "_1";
				break;
			}
			case 3:
			{
				alias = ("vox_egg_doll_response_" + num) + "_2";
				break;
			}
			case 2:
			{
				alias = ("vox_egg_doll_response_" + num) + "_3";
				break;
			}
		}
		self playsoundwithnotify(alias, "sounddone" + alias);
		self waittill("sounddone" + alias);
		player zm_audio::create_and_play_dialog("weapon_pickup", "dolls");
		wait(8);
	}
}

/*
	Name: function_a0f14d15
	Namespace: zm_cosmodrome_amb
	Checksum: 0xB0D56239
	Offset: 0x13A0
	Size: 0xBC
	Parameters: 3
	Flags: Linked
*/
function function_a0f14d15(grenade, model, player)
{
	var_7d5605b7 = getent("sndzhdeggtrig", "targetname");
	if(!isdefined(var_7d5605b7))
	{
		return false;
	}
	if(model istouching(var_7d5605b7))
	{
		model clientfield::set("toggle_black_hole_deployed", 1);
		level thread function_61c7f9a3(grenade, model, var_7d5605b7);
		return true;
	}
	return false;
}

/*
	Name: function_5b4692c9
	Namespace: zm_cosmodrome_amb
	Checksum: 0xF346DE0A
	Offset: 0x1468
	Size: 0x10E
	Parameters: 0
	Flags: Linked
*/
function function_5b4692c9()
{
	var_7533f11 = struct::get_array("s_ballerina_bhb", "targetname");
	if(var_7533f11.size <= 0)
	{
		return;
	}
	var_ead6e450 = array::sort_by_script_int(var_7533f11, 1);
	foreach(var_6d450235 in var_ead6e450)
	{
		var_6d450235 function_2e4843da();
	}
	level flag::set("snd_zhdegg_activate");
	level._blackhole_bomb_valid_area_check = undefined;
}

/*
	Name: function_2e4843da
	Namespace: zm_cosmodrome_amb
	Checksum: 0xE2E95507
	Offset: 0x1580
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_2e4843da()
{
	self.var_ac086ffb = util::spawn_model(self.model, self.origin, self.angles);
	e_trig = spawn("trigger_radius", self.origin + (vectorscale((0, 0, -1), 120)), 0, 175, 200);
	e_trig.targetname = "sndzhdeggtrig";
	e_trig.s_target = self;
	e_trig waittill(#"hash_de264026");
	self.var_ac086ffb delete();
	e_trig delete();
}

/*
	Name: function_61c7f9a3
	Namespace: zm_cosmodrome_amb
	Checksum: 0x264A5D9E
	Offset: 0x1668
	Size: 0xF4
	Parameters: 3
	Flags: Linked
*/
function function_61c7f9a3(grenade, model, var_7d5605b7)
{
	wait(1);
	time = 3;
	var_7d5605b7.s_target.var_ac086ffb moveto(grenade.origin + vectorscale((0, 0, 1), 50), time, time - 0.05);
	wait(time);
	playsoundatposition("zmb_gersh_teleporter_out", grenade.origin + vectorscale((0, 0, 1), 50));
	model delete();
	var_7d5605b7 notify(#"hash_de264026");
}

