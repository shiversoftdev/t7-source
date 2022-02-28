// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace zm_tomb_amb;

/*
	Name: main
	Namespace: zm_tomb_amb
	Checksum: 0x670B28C1
	Offset: 0x700
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function main()
{
	audio::snd_set_snapshot("cmn_fade_in");
	level.var_3e9ce4b5 = undefined;
	level thread function_af7b8418("water");
	level thread function_af7b8418("fire");
	level thread function_af7b8418("air");
	level thread function_af7b8418("lightning");
	setsoundcontext("train", "tunnel");
	level.var_da1a3c87 = &function_da1a3c87;
	function_6cc11add();
	level thread function_714746a6();
	thread snd_play_loopers();
	level thread function_ee449b54();
	level thread function_c9207335();
	level thread function_c052f9b8();
	level thread function_d19cb2f8();
}

/*
	Name: function_af7b8418
	Namespace: zm_tomb_amb
	Checksum: 0x93928687
	Offset: 0x880
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function function_af7b8418(str_name)
{
	if(!isdefined(level.var_c27b47a))
	{
		level.var_c27b47a = [];
	}
	if(!isdefined(level.var_c27b47a[str_name]))
	{
		level.var_c27b47a[str_name] = 1;
	}
	level waittill("snd" + str_name);
	level.var_c27b47a[str_name] = 0;
	if(isdefined(level.var_8f027e99[str_name]))
	{
		stopfx(0, level.var_8f027e99[str_name]);
		level.var_8f027e99[str_name] = undefined;
	}
}

/*
	Name: function_c9207335
	Namespace: zm_tomb_amb
	Checksum: 0x18477A54
	Offset: 0x938
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_c9207335()
{
	wait(3);
	level thread function_d667714e();
	var_13a52dfe = getentarray(0, "sndMusicTrig", "targetname");
	array::thread_all(var_13a52dfe, &function_60a32834);
}

/*
	Name: function_60a32834
	Namespace: zm_tomb_amb
	Checksum: 0x3C7F9978
	Offset: 0x9B8
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_60a32834()
{
	while(true)
	{
		self waittill(#"trigger", trigplayer);
		if(trigplayer islocalplayer())
		{
			level notify(#"hash_51d7bc7c", self.script_sound);
			self thread function_89793e8f();
			while(isdefined(trigplayer) && trigplayer istouching(self))
			{
				wait(0.016);
			}
			self notify(#"hash_ae459976");
		}
		else
		{
			wait(0.016);
		}
	}
}

/*
	Name: function_d667714e
	Namespace: zm_tomb_amb
	Checksum: 0x2C09AB09
	Offset: 0xA78
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_d667714e()
{
	level.var_b6342abd = "mus_tomb_underscore_null";
	level.var_6d9d81aa = "mus_tomb_underscore_null";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 playloopsound(level.var_b6342abd, 2);
	while(true)
	{
		level waittill(#"hash_51d7bc7c", location);
		level.var_6d9d81aa = "mus_tomb_underscore_" + location;
		if(level.var_6d9d81aa != level.var_b6342abd)
		{
			level thread function_b234849(level.var_6d9d81aa);
			level.var_b6342abd = level.var_6d9d81aa;
		}
	}
}

/*
	Name: function_89793e8f
	Namespace: zm_tomb_amb
	Checksum: 0x4B699896
	Offset: 0xB78
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function function_89793e8f()
{
	self notify(#"hash_6c4e5e2e");
	self endon(#"hash_6c4e5e2e");
	level endon(#"hash_51d7bc7c");
	self waittill(#"hash_ae459976");
	wait(0.1);
	level notify(#"hash_51d7bc7c", "null");
}

/*
	Name: function_b234849
	Namespace: zm_tomb_amb
	Checksum: 0x6C78FCB3
	Offset: 0xBD8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_b234849(var_6d9d81aa)
{
	level endon(#"hash_51d7bc7c");
	level.var_eb526c90 stopallloopsounds(2);
	wait(1);
	level.var_9433cf5a = level.var_eb526c90 playloopsound(var_6d9d81aa, 2);
}

/*
	Name: function_c052f9b8
	Namespace: zm_tomb_amb
	Checksum: 0x3468E135
	Offset: 0xC48
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function function_c052f9b8()
{
	while(true)
	{
		level waittill(#"hash_f099c69d");
		if(isdefined(level.var_1c69bb12.var_b13d6dfb) && level.var_1c69bb12.var_b13d6dfb)
		{
			setsoundcontext("train", "country");
		}
		else
		{
			if(isdefined(level.var_1c69bb12.var_308c43c8) && level.var_1c69bb12.var_308c43c8)
			{
				setsoundcontext("train", "city");
			}
			else
			{
				setsoundcontext("train", "tunnel");
			}
		}
	}
}

/*
	Name: function_33be1969
	Namespace: zm_tomb_amb
	Checksum: 0x4AD49724
	Offset: 0xD20
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_33be1969()
{
	level.var_1c69bb12 = spawnstruct();
	level.var_1c69bb12.var_b13d6dfb = 0;
	level.var_1c69bb12.var_308c43c8 = 0;
}

/*
	Name: function_da1a3c87
	Namespace: zm_tomb_amb
	Checksum: 0xDE974E92
	Offset: 0xD70
	Size: 0x96
	Parameters: 2
	Flags: Linked
*/
function function_da1a3c87(room, player)
{
	switch(room)
	{
		case "tomb_cave":
		case "tomb_large_chamber":
		case "tomb_robot_head":
		case "tomb_spiral_staircase_bot":
		{
			setsoundcontext("grass", "in_grass");
			break;
		}
		default:
		{
			setsoundcontext("grass", "no_grass");
			break;
		}
	}
}

/*
	Name: function_6fae68d7
	Namespace: zm_tomb_amb
	Checksum: 0xBEA9063C
	Offset: 0xE10
	Size: 0xEA
	Parameters: 0
	Flags: None
*/
function function_6fae68d7()
{
	trigs = getentarray(0, "sndCaptureZone", "targetname");
	if(isdefined(trigs))
	{
		foreach(trig in trigs)
		{
			trig.players = 0;
			trig.active = 0;
			trig thread function_6576aaa4();
		}
	}
}

/*
	Name: function_6576aaa4
	Namespace: zm_tomb_amb
	Checksum: 0xB35220D4
	Offset: 0xF08
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function function_6576aaa4()
{
	self thread function_74c85975();
	while(true)
	{
		self waittill(#"trigger", who);
		if(who isplayer() && (!(isdefined(who.var_c7721e47) && who.var_c7721e47)))
		{
			self.players++;
			who.var_c7721e47 = 1;
			self thread function_8e8fcdfc(who);
			if(!self.active)
			{
				self.active = 1;
				self thread function_3abd927c();
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_8e8fcdfc
	Namespace: zm_tomb_amb
	Checksum: 0x14170CF6
	Offset: 0x1000
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function function_8e8fcdfc(player)
{
	while(isdefined(self) && isdefined(player) && player istouching(self))
	{
		wait(0.1);
	}
	self.players--;
	if(isdefined(player))
	{
		player.var_c7721e47 = 0;
	}
	self notify(#"hash_961b140e");
}

/*
	Name: function_3abd927c
	Namespace: zm_tomb_amb
	Checksum: 0x26CD2E68
	Offset: 0x1080
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_3abd927c()
{
	playsound(0, "zmb_zone_plate_down", self.origin);
	self.sndloop = self playloopsound("zmb_zone_plate_loop", 2);
	self waittill(#"hash_8cd1836c");
	self.active = 0;
	self stoploopsound(self.sndloop);
	playsound(0, "zmb_zone_plate_up", self.origin);
}

/*
	Name: function_74c85975
	Namespace: zm_tomb_amb
	Checksum: 0xA2CC9AFD
	Offset: 0x1140
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function function_74c85975()
{
	while(true)
	{
		self waittill(#"hash_961b140e");
		if(self.players <= 0)
		{
			self.players = 0;
			self notify(#"hash_8cd1836c");
		}
	}
}

/*
	Name: function_6cc11add
	Namespace: zm_tomb_amb
	Checksum: 0x4BAC2FD1
	Offset: 0x1190
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_6cc11add()
{
	level.var_8f027e99 = array();
	clientfield::register("toplayer", "sndEggElements", 21000, 1, "int", &function_3599b48b, 0, 0);
	level.sndchargeshot_func = &function_6442a8c2;
}

/*
	Name: function_ec990408
	Namespace: zm_tomb_amb
	Checksum: 0xC0C165A3
	Offset: 0x1218
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_ec990408(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		audio::playloopat(fieldname, (0, 0, 0));
	}
	else
	{
		audio::stoploopat(fieldname, (0, 0, 0));
	}
}

/*
	Name: function_3599b48b
	Namespace: zm_tomb_amb
	Checksum: 0x5F53CFE8
	Offset: 0x12A0
	Size: 0x2DA
	Parameters: 7
	Flags: Linked
*/
function function_3599b48b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	var_92c47b0e = struct::get_array("s_zhdegg_elements", "targetname");
	if(!isdefined(level.var_8f027e99))
	{
		level.var_8f027e99 = array();
	}
	if(newval)
	{
		foreach(s_struct in var_92c47b0e)
		{
			var_61bcec7 = s_struct.script_string;
			if(s_struct.script_string == "lightning")
			{
				var_61bcec7 = "elec";
			}
			if(s_struct.script_string == "water")
			{
				var_61bcec7 = "ice";
			}
			if(isdefined(level.var_c27b47a[s_struct.script_string]) && level.var_c27b47a[s_struct.script_string])
			{
				if(isdefined(level.var_8f027e99[s_struct.script_string]))
				{
					stopfx(localclientnum, level.var_8f027e99[s_struct.script_string]);
				}
				level.var_8f027e99[s_struct.script_string] = playfx(localclientnum, level._effect[var_61bcec7 + "_glow"], s_struct.origin);
			}
		}
	}
	else
	{
		foreach(fxid in level.var_8f027e99)
		{
			stopfx(localclientnum, fxid);
			fxid = undefined;
		}
	}
}

/*
	Name: function_714746a6
	Namespace: zm_tomb_amb
	Checksum: 0x7C01CAE4
	Offset: 0x1588
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_714746a6()
{
	thread snd_start_autofx_audio();
	thread flyovers();
	thread function_57a479e1();
}

/*
	Name: snd_start_autofx_audio
	Namespace: zm_tomb_amb
	Checksum: 0x23D0890E
	Offset: 0x15C8
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function snd_start_autofx_audio()
{
	audio::snd_play_auto_fx("fx_tomb_fire_sm", "amb_fire_sm", 0, 0, 0, 0);
	audio::snd_play_auto_fx("fx_tomb_fire_lg", "amb_fire_lg", 0, 0, 0, 0);
	audio::snd_play_auto_fx("fx_tomb_steam_md", "amb_pipe_steam_md", 0, 0, 0, 0);
	audio::snd_play_auto_fx("fx_tomb_light_expensive", "amb_main_light", 0, 0, 0, 0);
	audio::snd_play_auto_fx("fx_tomb_light_lg", "amb_light_lrg", 0, 0, 0, 0);
	audio::snd_play_auto_fx("fx_tomb_light_md", "amb_light_md", 0, 0, 0, 0);
}

/*
	Name: flyovers
	Namespace: zm_tomb_amb
	Checksum: 0xD3F6E262
	Offset: 0x16C8
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function flyovers()
{
	while(true)
	{
		playsound(0, "amb_flyover", (1310, 859, 3064));
		wait(randomintrange(2, 8));
	}
}

/*
	Name: function_57a479e1
	Namespace: zm_tomb_amb
	Checksum: 0x6660265F
	Offset: 0x1720
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_57a479e1()
{
	audio::playloopat("amb_dist_battle_front", (-2492, 1263, 691));
	audio::playloopat("amb_dist_battle_back", (4190, -1050, 910));
}

/*
	Name: sndmudslow
	Namespace: zm_tomb_amb
	Checksum: 0xCE72D353
	Offset: 0x1780
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function sndmudslow(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(!isspectating(localclientnum, 0))
	{
		if(newval == 1)
		{
			self thread function_c85630a7();
		}
		else
		{
			self thread function_555b3a00();
		}
	}
}

/*
	Name: function_c85630a7
	Namespace: zm_tomb_amb
	Checksum: 0xCD801760
	Offset: 0x1820
	Size: 0x160
	Parameters: 0
	Flags: Linked
*/
function function_c85630a7()
{
	self endon(#"hash_ed11651a");
	self endon(#"entityshutdown");
	if(!isdefined(self.var_29fe0572))
	{
		self.var_29fe0572 = spawn(0, self.origin, "script_origin");
		self.var_29fe0572 linkto(self, "tag_origin");
	}
	self.var_29fe0572.var_8d8259d3 = self.var_29fe0572 playloopsound("zmb_tomb_slowed_movement_loop", 1);
	while(true)
	{
		if(!isdefined(self))
		{
			return;
		}
		var_3ec2ad89 = abs(self getspeed());
		var_fef3a6cb = audio::scale_speed(21, 285, 0.01, 1, var_3ec2ad89);
		self.var_29fe0572 setloopstate("zmb_tomb_slowed_movement_loop", var_fef3a6cb, 1);
		wait(0.1);
	}
}

/*
	Name: function_555b3a00
	Namespace: zm_tomb_amb
	Checksum: 0xC12EE60
	Offset: 0x1988
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function function_555b3a00()
{
	self notify(#"hash_ed11651a");
	self.var_29fe0572 stoploopsound(self.var_29fe0572.var_8d8259d3, 1.5);
	self.var_29fe0572.var_8d8259d3 = undefined;
}

/*
	Name: init
	Namespace: zm_tomb_amb
	Checksum: 0xB07B2D44
	Offset: 0x19E8
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level._entityshutdowncbfunc = &heli_linkto_sound_ents_delete;
	level.helisoundvalues = [];
	init_heli_sound_values("qrdrone", "turbine_idle", 30, 0.8, 0, 16, 0.9, 1.1);
	init_heli_sound_values("qrdrone", "turbine_moving", 30, 0, 0.9, 20, 0.9, 1.1);
	init_heli_sound_values("qrdrone", "turn", 5, 0, 1, 1, 1, 1);
	/#
		if(getdvarstring("") == "")
		{
			setdvar("", "");
		}
		level thread command_parser();
	#/
}

/*
	Name: init_heli_sound_values
	Namespace: zm_tomb_amb
	Checksum: 0x71BC7015
	Offset: 0x1B50
	Size: 0x28C
	Parameters: 8
	Flags: Linked
*/
function init_heli_sound_values(heli_type, part_type, max_speed_vol, min_vol, max_vol, max_speed_pitch, min_pitch, max_pitch)
{
	if(!isdefined(level.helisoundvalues[heli_type]))
	{
		level.helisoundvalues[heli_type] = [];
	}
	if(!isdefined(level.helisoundvalues[heli_type][part_type]))
	{
		level.helisoundvalues[heli_type][part_type] = spawnstruct();
	}
	level.helisoundvalues[heli_type][part_type].speedvolumemax = max_speed_vol;
	level.helisoundvalues[heli_type][part_type].speedpitchmax = max_speed_pitch;
	level.helisoundvalues[heli_type][part_type].volumemin = min_vol;
	level.helisoundvalues[heli_type][part_type].volumemax = max_vol;
	level.helisoundvalues[heli_type][part_type].pitchmin = min_pitch;
	level.helisoundvalues[heli_type][part_type].pitchmax = max_pitch;
	/#
		if(getdvarint("") > 0)
		{
			println("" + heli_type);
			println("" + part_type);
			println("" + max_speed_vol);
			println("" + min_vol);
			println("" + max_vol);
			println("" + max_speed_pitch);
			println("" + min_pitch);
			println("" + max_pitch);
		}
	#/
}

/*
	Name: command_parser
	Namespace: zm_tomb_amb
	Checksum: 0x859507F9
	Offset: 0x1DE8
	Size: 0x558
	Parameters: 0
	Flags: Linked
*/
function command_parser()
{
	/#
		while(true)
		{
			command = getdvarstring("");
			if(command != "")
			{
				success = 1;
				tokens = strtok(command, "");
				if(!isdefined(tokens[0]) || !isdefined(level.helisoundvalues[tokens[0]]))
				{
					if(isdefined(tokens[0]))
					{
						println("" + tokens[0]);
					}
					else
					{
						println("");
					}
					println("");
					success = 0;
				}
				else
				{
					if(!isdefined(tokens[1]))
					{
						if(isdefined(tokens[1]))
						{
							println((("" + tokens[0]) + "") + tokens[1]);
						}
						else
						{
							println("" + tokens[0]);
						}
						println("");
						success = 0;
					}
					else
					{
						if(!isdefined(tokens[2]))
						{
							println((("" + tokens[0]) + "") + tokens[1]);
							println("");
							success = 0;
						}
						else if(!isdefined(tokens[3]))
						{
							println((("" + tokens[0]) + "") + tokens[1]);
							println("");
							success = 0;
						}
					}
				}
				if(success)
				{
					heli_type = tokens[0];
					heli_part = tokens[1];
					value_name = tokens[2];
					value = float(tokens[3]);
					switch(value_name)
					{
						case "":
						{
							level.helisoundvalues[heli_type][heli_part].volumemin = value;
							println("" + value);
							break;
						}
						case "":
						{
							level.helisoundvalues[heli_type][heli_part].volumemax = value;
							println("" + value);
							break;
						}
						case "":
						{
							level.helisoundvalues[heli_type][heli_part].pitchmin = value;
							println("" + value);
							break;
						}
						case "":
						{
							level.helisoundvalues[heli_type][heli_part].pitchmax = value;
							println("" + value);
							break;
						}
						case "":
						{
							level.helisoundvalues[heli_type][heli_part].speedvolumemax = value;
							println("" + value);
							break;
						}
						case "":
						{
							level.helisoundvalues[heli_type][heli_part].speedpitchmax = value;
							println("" + value);
							break;
						}
						default:
						{
							println("");
						}
					}
				}
				setdvar("", "");
			}
			wait(0.1);
		}
	#/
}

/*
	Name: init_heli_sounds_player_drone
	Namespace: zm_tomb_amb
	Checksum: 0xCAB746F0
	Offset: 0x2348
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function init_heli_sounds_player_drone()
{
	setup_heli_sounds("turbine_idle", "engine", "tag_body", "veh_qrdrone_turbine_idle");
	setup_heli_sounds("turbine_moving", "engine", "tag_body", "veh_qrdrone_turbine_moving");
	setup_heli_sounds("turn", "engine", "tag_body", "veh_qrdrone_idle_rotate");
	self.warning_tag = undefined;
}

/*
	Name: sound_linkto
	Namespace: zm_tomb_amb
	Checksum: 0xFAA1FC99
	Offset: 0x23F0
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function sound_linkto(parent, tag)
{
	if(isdefined(tag))
	{
		self linkto(parent, tag);
	}
	else
	{
		self linkto(parent, "tag_body");
	}
}

/*
	Name: setup_heli_sounds
	Namespace: zm_tomb_amb
	Checksum: 0x3043B00D
	Offset: 0x2460
	Size: 0x38C
	Parameters: 7
	Flags: Linked
*/
function setup_heli_sounds(bone_location, type, tag, run, dmg1, dmg2, dmg3)
{
	self.heli[bone_location] = spawnstruct();
	self.heli[bone_location].sound_type = type;
	self.heli[bone_location].run = spawn(0, self.origin, "script_origin");
	self.heli[bone_location].run sound_linkto(self, tag);
	self.heli[bone_location].run.alias = run;
	self thread heli_loop_sound_delete(self.heli[bone_location].run);
	if(isdefined(dmg1))
	{
		self.heli[bone_location].idle = spawn(0, self.origin, "script_origin");
		self.heli[bone_location].idle sound_linkto(self, tag);
		self.heli[bone_location].idle.alias = dmg1;
		self thread heli_loop_sound_delete(self.heli[bone_location].dmg1);
	}
	if(isdefined(dmg2))
	{
		self.heli[bone_location].idle = spawn(0, self.origin, "script_origin");
		self.heli[bone_location].idle sound_linkto(self, tag);
		self.heli[bone_location].idle.alias = dmg2;
		self thread heli_loop_sound_delete(self.heli[bone_location].dmg2);
	}
	if(isdefined(dmg3))
	{
		self.heli[bone_location].idle = spawn(0, self.origin, "script_origin");
		self.heli[bone_location].idle sound_linkto(self, tag);
		self.heli[bone_location].idle.alias = dmg3;
		self thread heli_loop_sound_delete(self.heli[bone_location].dmg3);
	}
}

/*
	Name: start_helicopter_sounds
	Namespace: zm_tomb_amb
	Checksum: 0x91A39C03
	Offset: 0x27F8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function start_helicopter_sounds(localclientnum)
{
	if(isdefined(self.vehicletype))
	{
		self.heli = [];
		self.terrain = [];
		self.sound_ents = [];
		self.cur_speed = 0;
		self.mph_to_inches_per_sec = 17.6;
		self.speed_of_wind = 20;
		self.idle_run_trans_speed = 5;
		self init_heli_sounds_player_drone();
		self play_player_drone_sounds();
	}
}

/*
	Name: heli_loop_sound_delete
	Namespace: zm_tomb_amb
	Checksum: 0xEE5E2368
	Offset: 0x28A0
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function heli_loop_sound_delete(real_ent)
{
	self waittill(#"entityshutdown");
	real_ent unlink();
	real_ent stoploopsound(4);
	real_ent delete();
}

/*
	Name: heli_linkto_sound_ents_delete
	Namespace: zm_tomb_amb
	Checksum: 0xE774FAE6
	Offset: 0x2908
	Size: 0x24
	Parameters: 2
	Flags: Linked
*/
function heli_linkto_sound_ents_delete(localclientnum, entity)
{
	entity notify(#"entityshutdown");
}

/*
	Name: heli_sound_play
	Namespace: zm_tomb_amb
	Checksum: 0x1D828FD9
	Offset: 0x2938
	Size: 0xBE
	Parameters: 1
	Flags: None
*/
function heli_sound_play(heli_bone)
{
	switch(heli_bone.sound_type)
	{
		case "engine":
		{
			heli_bone.run playloopsound(heli_bone.run.alias, 2);
			break;
		}
		case "wind":
		{
			break;
		}
		default:
		{
			/#
				println(("" + heli_bone.type) + "");
			#/
			break;
		}
	}
}

/*
	Name: play_player_drone_sounds
	Namespace: zm_tomb_amb
	Checksum: 0x72CE6F4A
	Offset: 0x2A00
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function play_player_drone_sounds()
{
	self thread heli_idle_run_transition("qrdrone", "turbine_idle", 0.1, 1);
	self thread heli_idle_run_transition("qrdrone", "turbine_moving", 0.1, 1);
	self thread drone_up_down_transition();
	self thread drone_rotate_angle("qrdrone", "turn");
}

/*
	Name: heli_idle_run_transition
	Namespace: zm_tomb_amb
	Checksum: 0xFA93C1E9
	Offset: 0x2AB0
	Size: 0x45E
	Parameters: 4
	Flags: Linked
*/
function heli_idle_run_transition(heli_type, heli_part, wait_time, updown)
{
	self endon(#"entityshutdown");
	heli_bone = self.heli[heli_part];
	run_id = heli_bone.run playloopsound(heli_bone.run.alias, 0.5);
	if(!isdefined(wait_time))
	{
		wait_time = 0.5;
	}
	while(isdefined(self))
	{
		if(!isdefined(level.helisoundvalues[heli_type]) || !isdefined(level.helisoundvalues[heli_type][heli_part]))
		{
			/#
				println("");
			#/
			return;
		}
		max_speed_vol = level.helisoundvalues[heli_type][heli_part].speedvolumemax;
		min_vol = level.helisoundvalues[heli_type][heli_part].volumemin;
		max_vol = level.helisoundvalues[heli_type][heli_part].volumemax;
		max_speed_pitch = level.helisoundvalues[heli_type][heli_part].speedpitchmax;
		min_pitch = level.helisoundvalues[heli_type][heli_part].pitchmin;
		max_pitch = level.helisoundvalues[heli_type][heli_part].pitchmax;
		plr_vel = self getvelocity();
		self.cur_speed = abs(sqrt(vectordot(plr_vel, plr_vel))) / self.mph_to_inches_per_sec;
		run_volume = audio::scale_speed(self.idle_run_trans_speed, max_speed_vol, min_vol, max_vol, self.cur_speed);
		run_pitch = audio::scale_speed(self.idle_run_trans_speed, max_speed_pitch, min_pitch, max_pitch, self.cur_speed);
		if(isdefined(updown))
		{
			if(!isdefined(self.qrdrone_z_difference))
			{
				self.qrdrone_z_difference = 0;
			}
			run_volume_vertical = audio::scale_speed(5, 50, 0, 1, abs(self.qrdrone_z_difference));
			run_volume = run_volume - run_volume_vertical;
		}
		if(isdefined(run_volume) && isdefined(run_pitch))
		{
			heli_bone.run setloopstate(heli_bone.run.alias, run_volume, run_pitch, 1, 0.15);
			/#
				if(getdvarint("") > 0)
				{
					println("" + self.cur_speed);
					println("" + run_pitch);
					println("" + self.cur_speed);
					println("" + run_volume);
				}
			#/
		}
		wait(wait_time);
	}
}

/*
	Name: get_heli_sound_ent
	Namespace: zm_tomb_amb
	Checksum: 0x52705573
	Offset: 0x2F18
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function get_heli_sound_ent(sound_ent)
{
	if(!isdefined(sound_ent))
	{
		tag = "tag_origin";
		if(isdefined(self.warning_tag))
		{
			tag = self.warning_tag;
		}
		sound_ent = spawn(0, self gettagorigin(tag), "script_origin");
		sound_ent linkto(self, tag);
		self thread heli_sound_ent_delete(sound_ent);
	}
	return sound_ent;
}

/*
	Name: get_lock_sound_ent
	Namespace: zm_tomb_amb
	Checksum: 0x86EE9B2C
	Offset: 0x2FD0
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function get_lock_sound_ent()
{
	self.lock_sound_ent = get_heli_sound_ent(self.lock_sound_ent);
	return self.lock_sound_ent;
}

/*
	Name: get_leaving_sound_ent
	Namespace: zm_tomb_amb
	Checksum: 0x5BAB6901
	Offset: 0x3008
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function get_leaving_sound_ent()
{
	self.leaving_sound_ent = get_heli_sound_ent(self.leaving_sound_ent);
	return self.leaving_sound_ent;
}

/*
	Name: heli_sound_ent_delete
	Namespace: zm_tomb_amb
	Checksum: 0x89D568E7
	Offset: 0x3040
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function heli_sound_ent_delete(real_ent)
{
	self waittill(#"entityshutdown");
	real_ent stoploopsound(0.1);
	real_ent delete();
}

/*
	Name: drone_up_down_transition
	Namespace: zm_tomb_amb
	Checksum: 0xF4BDB435
	Offset: 0x3098
	Size: 0x528
	Parameters: 0
	Flags: Linked
*/
function drone_up_down_transition()
{
	self endon(#"entityshutdown");
	volumerate = 1;
	qr_ent_up = spawn(0, self.origin, "script_origin");
	qr_ent_down = spawn(0, self.origin, "script_origin");
	qr_ent_either = spawn(0, self.origin, "script_origin");
	qr_ent_up thread qr_ent_cleanup(self);
	qr_ent_down thread qr_ent_cleanup(self);
	qr_ent_either thread qr_ent_cleanup(self);
	self.qrdrone_z_difference = 0;
	down = qr_ent_down playloopsound("veh_qrdrone_move_down");
	qr_ent_down setloopstate("veh_qrdrone_move_down", 0, 0);
	up = qr_ent_up playloopsound("veh_qrdrone_move_up");
	qr_ent_up setloopstate("veh_qrdrone_move_up", 0, 0);
	either = qr_ent_either playloopsound("veh_qrdrone_vertical");
	qr_ent_either setloopstate("veh_qrdrone_vertical", 0, 0);
	tag = "tag_body";
	qr_ent_up linkto(self, tag);
	qr_ent_down linkto(self, tag);
	qr_ent_either linkto(self, tag);
	self thread drone_button_watch();
	while(true)
	{
		last_pos = self.origin[2];
		wait(0.1);
		self.qrdrone_z_difference = last_pos - self.origin[2];
		if(self.qrdrone_z_difference < 0)
		{
			up_difference = self.qrdrone_z_difference * -1;
			run_volume_up = audio::scale_speed(5, 40, 0, 1, up_difference);
			run_pitch_up = audio::scale_speed(5, 40, 0.9, 1.1, up_difference);
			run_volume_either = audio::scale_speed(5, 50, 0, 1, up_difference);
			run_pitch_either = audio::scale_speed(5, 50, 0.9, 1.1, up_difference);
		}
		else
		{
			run_volume_up = 0;
			run_pitch_up = 1;
			run_volume_either = audio::scale_speed(5, 50, 0, 1, self.qrdrone_z_difference);
			run_pitch_either = audio::scale_speed(5, 50, 0.95, 0.8, self.qrdrone_z_difference);
		}
		run_volume_down = audio::scale_speed(5, 50, 0, 1, self.qrdrone_z_difference);
		run_pitch_down = audio::scale_speed(5, 50, 1, 0.8, self.qrdrone_z_difference);
		qr_ent_down setloopstate("veh_qrdrone_move_down", run_volume_down, run_pitch_down, volumerate);
		qr_ent_up setloopstate("veh_qrdrone_move_up", run_volume_up, run_pitch_up, volumerate);
		qr_ent_either setloopstate("veh_qrdrone_vertical", run_volume_either, run_pitch_either, volumerate);
	}
}

/*
	Name: qr_ent_cleanup
	Namespace: zm_tomb_amb
	Checksum: 0x6100C9D0
	Offset: 0x35C8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function qr_ent_cleanup(veh_ent)
{
	veh_ent waittill(#"entityshutdown");
	self delete();
}

/*
	Name: drone_rotate_angle
	Namespace: zm_tomb_amb
	Checksum: 0xF0B8915E
	Offset: 0x3600
	Size: 0x230
	Parameters: 2
	Flags: Linked
*/
function drone_rotate_angle(heli_type, heli_part)
{
	self endon(#"entityshutdown");
	level endon(#"save_restore");
	volumerate = 2.5;
	qr_ent_angle = spawn(0, self.origin, "script_origin");
	qr_ent_angle thread qr_ent_cleanup(self);
	angle = qr_ent_angle playloopsound("veh_qrdrone_idle_rotate");
	setsoundvolume(angle, 0);
	tag = "tag_body";
	qr_ent_angle linkto(self, tag);
	while(true)
	{
		last_angle = abs(self.angles[1]);
		wait(0.1);
		turning_speed = last_angle - abs(self.angles[1]);
		abs_turning_speed = abs(turning_speed);
		jet_stick_vol = audio::scale_speed(0, 5, 0, 0.4, abs_turning_speed);
		jet_stick_pitch = audio::scale_speed(0, 4, 0.9, 1.05, abs_turning_speed);
		qr_ent_angle setloopstate("veh_qrdrone_idle_rotate", jet_stick_vol, jet_stick_pitch, volumerate);
	}
}

/*
	Name: drone_button_watch
	Namespace: zm_tomb_amb
	Checksum: 0x951ED9FD
	Offset: 0x3838
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function drone_button_watch()
{
	self endon(#"entityshutdown");
	player = getlocalplayers()[0];
	return_to_zero = 1;
	while(true)
	{
		if(abs(self.qrdrone_z_difference) > 5 && return_to_zero)
		{
			self playsound(0, "veh_qrdrone_move_start");
			return_to_zero = 0;
		}
		else if(abs(self.qrdrone_z_difference) < 5 && !return_to_zero)
		{
			return_to_zero = 1;
		}
		wait(0.05);
	}
}

/*
	Name: snd_play_loopers
	Namespace: zm_tomb_amb
	Checksum: 0x18F96593
	Offset: 0x3928
	Size: 0x694
	Parameters: 0
	Flags: Linked
*/
function snd_play_loopers()
{
	audio::playloopat("amb_cave_enter", (2352, 4138, -278));
	audio::playloopat("amb_cave_enter", (2176, 807, 107));
	audio::playloopat("amb_cave_enter", (-2433, 494, 220));
	audio::playloopat("amb_elemental_corner_air", (11279, -8683, -271));
	audio::playloopat("amb_elemental_corner_fire", (9459, -8564, -283));
	audio::playloopat("amb_elemental_corner_fire_lava", (9904, -8612, -405));
	audio::playloopat("amb_elemental_corner_lightning", (9616, -6973, -252));
	audio::playloopat("amb_elemental_corner_ice", (11252, -7040, -215));
	audio::playloopat("amb_plane_dist_loop", (636, 5382, 453));
	audio::playloopat("amb_plane_dist_loop", (2515, 2411, 377));
	audio::playloopat("amb_plane_dist_loop", (-76, 58, 1035));
	audio::playloopat("amb_plane_dist_loop", (-2452, -690, 818));
	audio::playloopat("amb_plane_dist_loop", (886, -4399, 1051));
	audio::playloopat("amb_plane_dist_loop", (1078, 2266, 744));
	audio::playloopat("amb_spawn_rays", (9514, -8741, -335));
	audio::playloopat("amb_spawn_rays", (9319, -8519, -295));
	audio::playloopat("amb_spawn_rays", (9391, -7986, -258));
	audio::playloopat("amb_spawn_rays", (9322, -7608, -165));
	audio::playloopat("amb_spawn_rays", (9322, -7608, -165));
	audio::playloopat("amb_spawn_rays", (9369, -7021, -269));
	audio::playloopat("amb_spawn_rays", (9730, -6749, -175));
	audio::playloopat("amb_spawn_rays", (9997, -7007, -200));
	audio::playloopat("amb_spawn_rays", (10262, -7362, -341));
	audio::playloopat("amb_spawn_rays", (10985, -6684, -3));
	audio::playloopat("amb_spawn_rays", (11542, -7255, -291));
	audio::playloopat("amb_spawn_rays", (11291, -7653, -235));
	audio::playloopat("amb_spawn_rays", (11327, -8091, -203));
	audio::playloopat("amb_spawn_rays", (11596, -8545, -222));
	audio::playloopat("amb_spawn_rays", (11102, -889, -305));
	audio::playloopat("amb_spawn_rays", (10586, -8794, -225));
	audio::playloopat("amb_spawn_rays", (10117, -8888, -264));
	audio::playloopat("amb_spawn_rays", (10048, -8431, -321));
	audio::playloopat("amb_spawn_rays", (11104, -8896, -300));
	audio::playloopat("amb_spawn_rays", (10416, -7055, -337));
	audio::playloopat("amb_spawn_rays", (11100, -8894, -303));
	audio::playloopat("zmb_sq_electric_pillar", (10091, -7663, -372));
	audio::playloopat("zmb_sq_ice_pillar", (10567, -7657, -372));
	audio::playloopat("zmb_sq_air_pillar", (10581, -8142, -377));
	audio::playloopat("zmb_sq_fire_pillar", (10106, -8147, -382));
	audio::playloopat("amb_robot_fans", (-6252, -6534, 398));
	audio::playloopat("amb_robot_fans", (-6767, -6543, 361));
	audio::playloopat("amb_robot_fans", (-5677, -6501, 405));
}

/*
	Name: function_6442a8c2
	Namespace: zm_tomb_amb
	Checksum: 0x46D7A96C
	Offset: 0x3FC8
	Size: 0x194
	Parameters: 3
	Flags: Linked
*/
function function_6442a8c2(localclientnum, weapon, chargeshotlevel)
{
	weaponname = weapon.name;
	self.var_4dde9ce5 = chargeshotlevel;
	if(!isdefined(self.var_d159d52b))
	{
		self.var_d159d52b = spawn(0, (0, 0, 0), "script_origin");
	}
	self thread function_6ee5be43();
	if(!isdefined(self.var_276de066) || self.var_4dde9ce5 != self.var_276de066)
	{
		alias = "wpn_firestaff_charge_";
		if(weaponname == "staff_water_upgraded")
		{
			alias = "wpn_waterstaff_charge_";
		}
		else
		{
			if(weaponname == "staff_lightning_upgraded")
			{
				alias = "wpn_lightningstaff_charge_";
			}
			else if(weaponname == "staff_air_upgraded")
			{
				alias = "wpn_airstaff_charge_";
			}
		}
		self.var_710dd188 = self.var_d159d52b playloopsound(alias + "loop", 1.5);
		playsound(localclientnum, alias + self.var_4dde9ce5, (0, 0, 0));
		self.var_276de066 = self.var_4dde9ce5;
	}
}

/*
	Name: function_6ee5be43
	Namespace: zm_tomb_amb
	Checksum: 0xF309F496
	Offset: 0x4168
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_6ee5be43()
{
	level notify(#"hash_df9ed1b6");
	level endon(#"hash_df9ed1b6");
	wait(0.5);
	self.var_d159d52b stoploopsound(self.var_710dd188, 0.1);
	self.var_4dde9ce5 = 0;
}

/*
	Name: function_ee449b54
	Namespace: zm_tomb_amb
	Checksum: 0x99EC1590
	Offset: 0x41D0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_ee449b54()
{
}

/*
	Name: function_8b8dd551
	Namespace: zm_tomb_amb
	Checksum: 0x74EF3744
	Offset: 0x41E0
	Size: 0xC6
	Parameters: 1
	Flags: None
*/
function function_8b8dd551(localclientnum)
{
	self endon(#"disconnect");
	self.sndent = spawn(0, (0, 0, 0), "script_origin");
	self.var_c5cda021 = "mus_underscore_default";
	self.var_a15dcd51 = "null";
	while(true)
	{
		if(self.var_a15dcd51 != self.var_c5cda021)
		{
			self.var_a15dcd51 = self.var_c5cda021;
			self.sndent notify(#"hash_9d70babf");
			self.sndent thread function_bca19b62(self.var_c5cda021);
		}
		wait(2);
	}
}

/*
	Name: function_4ff80996
	Namespace: zm_tomb_amb
	Checksum: 0x108F668F
	Offset: 0x42B0
	Size: 0xD8
	Parameters: 1
	Flags: None
*/
function function_4ff80996(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", who);
		if(isdefined(who) && who islocalplayer())
		{
			if(isdefined(level.var_3e9ce4b5) && self.script_sound == "mus_underscore_chamber")
			{
				who.var_c5cda021 = level.var_3e9ce4b5;
			}
			else
			{
				who.var_c5cda021 = self.script_sound;
			}
			who thread function_bc0edf8b();
		}
		wait(0.5);
	}
}

/*
	Name: function_bc0edf8b
	Namespace: zm_tomb_amb
	Checksum: 0x1C157040
	Offset: 0x4390
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_bc0edf8b()
{
	self notify(#"hash_11d444cc");
	self endon(#"disconnect");
	self endon(#"hash_11d444cc");
	wait(4);
	if(isdefined(self) && self islocalplayer())
	{
		self.var_c5cda021 = "mus_underscore_default";
	}
}

/*
	Name: function_bca19b62
	Namespace: zm_tomb_amb
	Checksum: 0x12C80BC0
	Offset: 0x43F8
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_bca19b62(alias)
{
	self endon(#"hash_9d70babf");
	self endon(#"death");
	self stoploopsound(2);
	wait(2);
	self playloopsound(alias, 2);
}

/*
	Name: sndmaelstrom
	Namespace: zm_tomb_amb
	Checksum: 0x10546557
	Offset: 0x4460
	Size: 0xD6
	Parameters: 7
	Flags: Linked
*/
function sndmaelstrom(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level thread function_572d945d();
	if(newval == 1)
	{
		if(!isdefined(self.sndmaelstrom))
		{
			self.sndmaelstrom = self playloopsound("amb_maelstrom", 3);
		}
	}
	else if(isdefined(self.sndmaelstrom))
	{
		self stoploopsound(self.sndmaelstrom);
		self.sndmaelstrom = undefined;
	}
}

/*
	Name: function_572d945d
	Namespace: zm_tomb_amb
	Checksum: 0x9694F800
	Offset: 0x4540
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function function_572d945d()
{
	if(!isdefined(level.var_ca141ce8))
	{
		level.var_ca141ce8 = 1;
	}
	while(level.var_ca141ce8 == 1)
	{
		wait(randomintrange(5, 15));
		playsound(0, "amb_distant_explosion", (0, 0, 0));
	}
}

/*
	Name: function_d19cb2f8
	Namespace: zm_tomb_amb
	Checksum: 0xECB7F1EF
	Offset: 0x45B0
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_d19cb2f8()
{
	loopers = struct::get_array("exterior_goal", "targetname");
	if(isdefined(loopers) && loopers.size > 0)
	{
		delay = 0;
		/#
			if(getdvarint("") > 0)
			{
				println(("" + loopers.size) + "");
			}
		#/
		for(i = 0; i < loopers.size; i++)
		{
			loopers[i] thread soundloopthink();
			delay = delay + 1;
			if((delay % 20) == 0)
			{
				wait(0.016);
			}
		}
	}
	else
	{
		/#
			println("");
		#/
		if(getdvarint("") > 0)
		{
		}
	}
}

/*
	Name: soundloopthink
	Namespace: zm_tomb_amb
	Checksum: 0xF4B7BF50
	Offset: 0x4718
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function soundloopthink()
{
	if(!isdefined(self.origin))
	{
		return;
	}
	if(!isdefined(self.script_sound))
	{
		self.script_sound = "zmb_spawn_walla";
	}
	notifyname = "";
	/#
		assert(isdefined(notifyname));
	#/
	if(isdefined(self.script_string))
	{
		notifyname = self.script_string;
	}
	/#
		assert(isdefined(notifyname));
	#/
	started = 1;
	if(isdefined(self.script_int))
	{
		started = self.script_int != 0;
	}
	if(started)
	{
		soundloopemitter(self.script_sound, self.origin);
	}
	if(notifyname != "")
	{
		for(;;)
		{
			level waittill(notifyname);
			if(started)
			{
				soundstoploopemitter(self.script_sound, self.origin);
			}
			else
			{
				soundloopemitter(self.script_sound, self.origin);
			}
			started = !started;
		}
	}
}

