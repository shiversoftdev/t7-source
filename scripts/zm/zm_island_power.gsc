// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_ai_thrasher;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_perks;
#using scripts\zm\zm_island_planting;
#using scripts\zm\zm_island_util;
#using scripts\zm\zm_island_vo;
#using scripts\zm\zm_island_ww_quest;

#namespace zm_island_power;

/*
	Name: main
	Namespace: zm_island_power
	Checksum: 0xCA14DBAC
	Offset: 0xB58
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	wait(0.05);
	level thread function_d17ab8c6();
	level thread function_fbe51672();
	level thread function_d806d0f9();
	level thread function_46ffc7b4();
	level thread function_801ffa37();
	level thread function_ae1e48b4();
	callback::on_spawned(&function_45585311);
	level thread function_662fba30();
	level thread function_c5751341();
	/#
		level thread function_83ead54e();
	#/
	/#
		level thread function_5b3bc8();
	#/
}

/*
	Name: function_d17ab8c6
	Namespace: zm_island_power
	Checksum: 0x87912DD7
	Offset: 0xC80
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function function_d17ab8c6()
{
	level endon(#"connect_bunker_exterior_to_bunker_interior");
	level flag::init("power_on" + 3);
	level thread function_9e6292be();
	level thread function_bbe228f8();
	level scene::init("p7_fxanim_zm_island_bunker_door_main_bundle");
	while(true)
	{
		level util::waittill_any("power_on" + 1, "power_on" + 2);
		if(flag::get("power_on" + 1) && flag::get("power_on" + 2))
		{
			level zm_power::turn_power_on_and_open_doors(3);
			level thread zm_island_vo::function_3bf2d62a("both_power_on", 1, 1, 1);
			level util::delay_notify(0.25, "override_bunker_door_string");
		}
		else
		{
			level zm_power::turn_power_off_and_close_doors(3);
		}
	}
}

/*
	Name: function_bbe228f8
	Namespace: zm_island_power
	Checksum: 0xC4557F53
	Offset: 0xE08
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function function_bbe228f8()
{
	level endon(#"connect_bunker_exterior_to_bunker_interior");
	zm_utility::add_zombie_hint("bunker_door_text", &"ZM_ISLAND_BUNKER_DOOR_OPEN");
	var_25d5f24c = getent("door_bunker_main", "target");
	while(true)
	{
		level waittill(#"override_bunker_door_string");
		var_25d5f24c zm_utility::set_hint_string(var_25d5f24c, "bunker_door_text");
	}
}

/*
	Name: function_9e6292be
	Namespace: zm_island_power
	Checksum: 0x9FBB17E1
	Offset: 0xEA0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_9e6292be()
{
	level flag::wait_till("connect_bunker_exterior_to_bunker_interior");
	function_5144d0ee();
}

/*
	Name: function_fbe51672
	Namespace: zm_island_power
	Checksum: 0xD54C5DC3
	Offset: 0xEE0
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function function_fbe51672()
{
	level flag::init("power_on" + 4);
	var_2a07ad9e = getent("bunker_cypher_screen", "targetname");
	var_2a07ad9e hide();
	var_3968d838 = getent("bunker_cypher_screen_4codes", "targetname");
	var_3968d838 hide();
	level flag::wait_till("power_on" + 4);
	foreach(var_ac878678 in level.var_769c0729)
	{
		var_ac878678 hide();
	}
	playsoundatposition("zmb_island_main_power_on", (0, 0, 0));
	level clientfield::set(("power_switch_" + 1) + "_fx", 0);
	level clientfield::set(("power_switch_" + 2) + "_fx", 0);
	exploder::exploder("ex_power_bdoor_left");
	exploder::exploder("ex_power_bdoor_right");
	function_2b5b24e9();
	level flag::set("power_on");
	exploder::exploder("fxexp_200");
	exploder::exploder("global_power");
	var_2a07ad9e show();
	var_3968d838 show();
}

/*
	Name: function_d806d0f9
	Namespace: zm_island_power
	Checksum: 0xE60549FF
	Offset: 0x1160
	Size: 0x1D8
	Parameters: 0
	Flags: Linked
*/
function function_d806d0f9()
{
	var_84f67a50 = [];
	var_84f67a50[0] = "power_on" + 1;
	var_84f67a50[1] = "power_on";
	while(true)
	{
		level flag::wait_till_any(var_84f67a50);
		exploder::exploder("temporary_power_jungle_lab");
		exploder::exploder("fxexp_211");
		exploder::exploder("ex_prop_switch");
		level.var_1dbad94a = 1;
		zm_island_ww_quest::function_23d17338(level.var_1dbad94a);
		level thread zm_island_vo::function_3bf2d62a("local_power_on", 1, 0, 0);
		if(level flag::get("power_on"))
		{
			break;
		}
		level flag::wait_till_clear("power_on" + 1);
		if(level flag::get("power_on"))
		{
			break;
		}
		exploder::stop_exploder("temporary_power_jungle_lab");
		exploder::stop_exploder("fxexp_211");
		exploder::stop_exploder("ex_prop_switch");
		level.var_1dbad94a = 0;
		zm_island_ww_quest::function_23d17338(level.var_1dbad94a);
	}
}

/*
	Name: function_46ffc7b4
	Namespace: zm_island_power
	Checksum: 0xB08E3A53
	Offset: 0x1340
	Size: 0x1A8
	Parameters: 0
	Flags: Linked
*/
function function_46ffc7b4()
{
	var_84f67a50 = [];
	var_84f67a50[0] = "power_on" + 2;
	var_84f67a50[1] = "power_on";
	while(true)
	{
		level flag::wait_till_any(var_84f67a50);
		exploder::exploder("temporary_power_swamp_lab");
		exploder::exploder("fxexp_210");
		level.var_2e16e689 = 1;
		zm_island_ww_quest::function_1dc42fdf(level.var_2e16e689);
		level thread zm_island_vo::function_3bf2d62a("local_power_on", 0, 0, 1);
		if(level flag::get("power_on"))
		{
			break;
		}
		level flag::wait_till_clear("power_on" + 2);
		if(level flag::get("power_on"))
		{
			break;
		}
		exploder::stop_exploder("temporary_power_swamp_lab");
		exploder::stop_exploder("fxexp_210");
		level.var_2e16e689 = 0;
		zm_island_ww_quest::function_1dc42fdf(level.var_2e16e689);
	}
}

/*
	Name: function_801ffa37
	Namespace: zm_island_power
	Checksum: 0xEF5FF361
	Offset: 0x14F0
	Size: 0x254
	Parameters: 0
	Flags: Linked
*/
function function_801ffa37()
{
	var_ac878678 = getent("use_elec_switch_deferred", "targetname");
	var_ac878678 sethintstring(&"ZM_ISLAND_PENSTOCK_DEBRIS");
	var_ac878678 setvisibletoall();
	var_ac878678 setcursorhint("HINT_NOICON");
	level flag::init(var_ac878678.script_string);
	level clientfield::set("penstock_fx_anim", 1);
	function_e9f46546();
	exploder::exploder("fxexp_303");
	/#
		println("");
	#/
	level flag::set(var_ac878678.script_string);
	level flag::wait_till("defend_over");
	var_ac878678 thread zm_power::electric_switch();
	exploder::exploder("lgt_penstock");
	level clientfield::set("penstock_fx_anim", 0);
	var_ac878678 waittill(#"trigger", user);
	level thread scene::play("p7_fxanim_zm_power_switch_bundle");
	user zm_audio::create_and_play_dialog("general", "power_on");
	level thread zm_island_vo::function_3bf2d62a("main_power_on", 1, 1, 1);
	exploder::exploder("ex_prop_switch");
	exploder::exploder("ex_fan_switch");
}

/*
	Name: function_e9f46546
	Namespace: zm_island_power
	Checksum: 0xE0E3B1AA
	Offset: 0x1750
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function function_e9f46546()
{
	while(!isdefined(level.var_d3b40681))
	{
		wait(1);
	}
	var_e08b3d94 = getent("penstock_web_trigger", "targetname");
	var_e08b3d94 zm_ai_spiders::function_7428955c();
	if(!isdefined(level.var_d3b40681))
	{
		level.var_d3b40681 = [];
	}
	else if(!isarray(level.var_d3b40681))
	{
		level.var_d3b40681 = array(level.var_d3b40681);
	}
	level.var_d3b40681[level.var_d3b40681.size] = var_e08b3d94;
	var_e08b3d94 zm_ai_spiders::function_f375c6d9(1, 1);
	var_e08b3d94.var_e084d7bd = 1;
	var_e08b3d94 waittill(#"web_torn");
	level util::clientnotify("snd_valve");
	level thread zm_island_vo::function_3bf2d62a("unblock_penstock", 0, 1, 0);
	var_e08b3d94 zm_ai_spiders::function_f375c6d9(0);
	arrayremovevalue(level.var_d3b40681, var_e08b3d94);
	var_e08b3d94.var_1e831600 util::delay(5, undefined, &delete);
	var_e08b3d94 util::delay(6, undefined, &delete);
}

/*
	Name: function_ae1e48b4
	Namespace: zm_island_power
	Checksum: 0xDD6DDFF0
	Offset: 0x1940
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_ae1e48b4()
{
	level.var_769c0729 = getentarray("temporary_power_switch", "script_string");
	level clientfield::set("power_switch_1_fx", 1);
	level clientfield::set("power_switch_2_fx", 1);
}

/*
	Name: function_156f973e
	Namespace: zm_island_power
	Checksum: 0x8CB221A5
	Offset: 0x19B8
	Size: 0x876
	Parameters: 0
	Flags: Linked
*/
function function_156f973e()
{
	if(!isdefined(self))
	{
		return;
	}
	if(self.script_string === "temporary_power_switch")
	{
		self sethintstring(&"ZM_ISLAND_POWER_SWITCH_NEEEDS_WATER");
	}
	if(isdefined(self.target))
	{
		ent_parts = getentarray(self.target, "targetname");
		struct_parts = struct::get_array(self.target, "targetname");
		foreach(ent in ent_parts)
		{
			if(isdefined(ent.script_noteworthy) && ent.script_noteworthy == "elec_switch")
			{
				master_switch = ent;
				master_switch notsolid();
			}
		}
		foreach(struct in struct_parts)
		{
			if(struct.script_noteworthy === "elec_switch_fx")
			{
				fx_pos = struct;
			}
		}
	}
	if(isdefined(self.script_int))
	{
		if(self.script_int == 1)
		{
			var_b46e7d63 = struct::get("jungle_lab_power_plant", "targetname");
			var_b46e7d63.str_exploder = "fxexp_213";
			var_b46e7d63 scene::init();
		}
		else if(self.script_int == 2)
		{
			var_b46e7d63 = struct::get("swamp_lab_power_plant", "targetname");
			var_b46e7d63.str_exploder = "fxexp_212";
			var_b46e7d63 scene::init();
		}
	}
	while(isdefined(self))
	{
		self setvisibletoall();
		self setcursorhint("HINT_NOICON");
		self waittill(#"trigger", user);
		if(isdefined(user.var_6fd3d65c) && user.var_6fd3d65c && user.var_bb2fd41c === 3)
		{
			user thread function_a84a1aec(undefined, 1);
		}
		else
		{
			continue;
		}
		user thread zm_island_vo::function_c8bcaf11();
		var_b46e7d63 thread scene::play("p7_fxanim_zm_island_power_plant_on_bundle", var_b46e7d63.var_8c4b44d4);
		self thread function_e2e52f31();
		self setinvisibletoall();
		if(isdefined(master_switch))
		{
			master_switch rotateroll(-90, 0.3);
			master_switch playsound("zmb_switch_flip");
		}
		power_zone = undefined;
		if(isdefined(self.script_int))
		{
			power_zone = self.script_int;
		}
		var_b46e7d63 waittill(#"hash_26b8743e");
		level zm_power::turn_power_on_and_open_doors(power_zone);
		if(!isdefined(self.script_noteworthy) || self.script_noteworthy != "allow_power_off")
		{
			self delete();
			return;
		}
		if(isdefined(level.var_7b5a9e65) && level.var_7b5a9e65 > 0)
		{
			level clientfield::set(("power_switch_" + self.script_int) + "_fx", 0);
			if(self.script_int == 1)
			{
				exploder::exploder("ex_power_bdoor_left");
				self thread function_7963db9c((251, 1869, -219));
			}
			else if(self.script_int == 2)
			{
				exploder::exploder("ex_power_bdoor_right");
				self thread function_7963db9c((331, 1859, -235));
			}
			self setinvisibletoall();
			if(level.activeplayers.size <= 1)
			{
				wait(level.var_7b5a9e65 * 2);
			}
			else
			{
				wait(level.var_7b5a9e65);
			}
			if(level flag::get("power_on"))
			{
				self delete();
				return;
			}
			level notify(#"hash_94e4da4f");
			self playsound("zmb_temp_power_alert");
			level clientfield::set(("power_switch_" + self.script_int) + "_fx", 1);
			var_b46e7d63.var_5260546a clientfield::set("power_plant_glow", 0);
			var_b46e7d63 thread scene::play("p7_fxanim_zm_island_power_plant_off_bundle", var_b46e7d63.var_969af1da);
			if(self.script_int == 1)
			{
				exploder::exploder_stop("ex_power_bdoor_left");
				level thread zm_island_vo::function_3bf2d62a("local_power_off", 1, 0, 0);
			}
			else if(self.script_int == 2)
			{
				exploder::exploder_stop("ex_power_bdoor_right");
				level thread zm_island_vo::function_3bf2d62a("local_power_off", 0, 0, 1);
			}
		}
		else
		{
			self sethintstring(&"ZOMBIE_ELECTRIC_SWITCH_OFF");
			self setvisibletoall();
			self waittill(#"trigger", user);
			self setinvisibletoall();
		}
		if(isdefined(master_switch))
		{
			master_switch rotateroll(90, 0.3);
		}
		if(isdefined(master_switch))
		{
			master_switch waittill(#"rotatedone");
		}
		level zm_power::turn_power_off_and_close_doors(power_zone);
		self notify(#"hash_42c31433");
	}
}

/*
	Name: function_f0a1682d
	Namespace: zm_island_power
	Checksum: 0xD6629B7D
	Offset: 0x2238
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function function_f0a1682d(a_ents)
{
	self.var_969af1da = a_ents["power_plant_dials"];
	self.var_5260546a = a_ents["power_plant"];
	self.var_8c4b44d4 = a_ents;
}

/*
	Name: function_c1edfb09
	Namespace: zm_island_power
	Checksum: 0x327EC5F5
	Offset: 0x2280
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_c1edfb09(a_ents)
{
	a_ents["power_plant_water"] waittill(#"hash_2acd8021");
	exploder::exploder(self.str_exploder);
	self thread function_b3c3fdca();
	a_ents["power_plant"] clientfield::set("power_plant_glow", 1);
	wait(4);
	exploder::exploder_stop(self.str_exploder);
}

/*
	Name: function_b3c3fdca
	Namespace: zm_island_power
	Checksum: 0x52B58850
	Offset: 0x2330
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function function_b3c3fdca()
{
	wait(2);
	self notify(#"hash_26b8743e");
}

/*
	Name: function_e2e52f31
	Namespace: zm_island_power
	Checksum: 0xFAEFE4CC
	Offset: 0x2358
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_e2e52f31()
{
	var_e2e52f31 = spawn("script_origin", self.origin);
	var_e2e52f31 playloopsound("zmb_temp_power_loop", 1.5);
	self waittill(#"hash_42c31433");
	self playsoundwithnotify("zmb_temp_power_off", "sounddone");
	var_e2e52f31 stoploopsound(2);
	self waittill(#"sounddone");
	var_e2e52f31 delete();
}

/*
	Name: function_7963db9c
	Namespace: zm_island_power
	Checksum: 0xD662BDEF
	Offset: 0x2420
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function function_7963db9c(var_fb491867)
{
	var_6575d157 = spawn("script_origin", var_fb491867);
	var_6575d157 playloopsound("amb_mini_generator", 1.5);
	var_6575d157 playsound("amb_gen_start");
	self waittill(#"hash_42c31433");
	var_6575d157 stoploopsound(2);
	var_6575d157 playsoundwithnotify("amb_gen_stop", "snd_done");
	var_6575d157 waittill(#"snd_done");
	var_6575d157 delete();
}

/*
	Name: function_53f26a4c
	Namespace: zm_island_power
	Checksum: 0xEE3CBB7C
	Offset: 0x2520
	Size: 0x202
	Parameters: 0
	Flags: Linked
*/
function function_53f26a4c()
{
	if(!isdefined(self.var_bb2fd41c))
	{
		return;
	}
	if(self.var_bb2fd41c === 3)
	{
		foreach(var_5972e249 in level.var_769c0729)
		{
			if(isdefined(var_5972e249))
			{
				var_5972e249 sethintstringforplayer(self, &"ZOMBIE_ELECTRIC_SWITCH");
			}
		}
	}
	else
	{
		if(self.var_bb2fd41c > 0)
		{
			foreach(var_5972e249 in level.var_769c0729)
			{
				if(isdefined(var_5972e249))
				{
					var_5972e249 sethintstringforplayer(self, &"ZM_ISLAND_POWER_SWITCH_NEEEDS_MORE_WATER");
				}
			}
		}
		else
		{
			foreach(var_5972e249 in level.var_769c0729)
			{
				if(isdefined(var_5972e249))
				{
					var_5972e249 sethintstringforplayer(self, &"ZM_ISLAND_POWER_SWITCH_NEEEDS_WATER");
				}
			}
		}
	}
}

/*
	Name: function_2b5b24e9
	Namespace: zm_island_power
	Checksum: 0x743936C2
	Offset: 0x2730
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_2b5b24e9()
{
	var_849a6e56 = struct::get("swamp_lab_power_plant", "targetname");
	if(!var_849a6e56 scene::is_active())
	{
		var_849a6e56 thread scene::play();
	}
	var_474567d = struct::get("jungle_lab_power_plant", "targetname");
	if(!var_474567d scene::is_active())
	{
		var_474567d thread scene::play();
	}
}

/*
	Name: function_5144d0ee
	Namespace: zm_island_power
	Checksum: 0xFB412D54
	Offset: 0x27F0
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function function_5144d0ee()
{
	var_e43d9cdb = struct::get_array("bunker_door_open_spawners", "targetname");
	var_e43d9cdb = array::randomize(var_e43d9cdb);
	var_7809d454 = [];
	for(i = 0; i < var_e43d9cdb.size; i++)
	{
		while(getfreeactorcount() < 1)
		{
			wait(0.05);
		}
		s_loc = var_e43d9cdb[i];
		ai_zombie = zombie_utility::spawn_zombie(level.zombie_spawners[0], "bunker_entrance_zombie", s_loc);
		if(!isdefined(var_7809d454))
		{
			var_7809d454 = [];
		}
		else if(!isarray(var_7809d454))
		{
			var_7809d454 = array(var_7809d454);
		}
		var_7809d454[var_7809d454.size] = ai_zombie;
		wait(0.25);
	}
	level thread function_5c09306d(var_7809d454);
	function_3d11144a();
}

/*
	Name: function_3d11144a
	Namespace: zm_island_power
	Checksum: 0x6C07E849
	Offset: 0x2980
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_3d11144a()
{
	level thread util::delayed_notify("spawn_bunker_thrasher", 2.5);
	var_1e9b1719 = getent("fxanim_bunker_door_main", "targetname");
	var_c0abb8f1 = getent("bunker_door_clip_left", "targetname");
	var_c0abb8f1 linkto(var_1e9b1719, "door_lft_jnt");
	level thread zm_island_vo::function_3bf2d62a("bunker_open", 1, 1, 1);
	var_83cb019c = getent("bunker_door_clip_right", "targetname");
	var_83cb019c linkto(var_1e9b1719, "door_rt_jnt");
	e_closest_player = arraygetclosest(var_c0abb8f1.origin, level.activeplayers);
	e_closest_player notify(#"player_opened_bunker");
	level scene::play("p7_fxanim_zm_island_bunker_door_main_bundle");
	var_c0abb8f1 delete();
	var_83cb019c delete();
}

/*
	Name: function_5c09306d
	Namespace: zm_island_power
	Checksum: 0xF2939284
	Offset: 0x2B40
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function function_5c09306d(a_ai_zombies)
{
	foreach(ai_zombie in a_ai_zombies)
	{
		ai_zombie.var_cbbe29a9 = 1;
	}
	if(level flag::get("power_on" + 4))
	{
		return;
	}
	level waittill(#"spawn_bunker_thrasher");
	var_4703465a = struct::get("spore_bunker_guarantee_convert", "targetname");
	var_75e02ae0 = arraygetclosest(var_4703465a.origin, a_ai_zombies);
	var_75e02ae0.var_cbbe29a9 = 0;
	zm_ai_thrasher::function_8b323113(var_75e02ae0, 0, 0);
}

/*
	Name: function_83ead54e
	Namespace: zm_island_power
	Checksum: 0x38B98168
	Offset: 0x2C90
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_83ead54e()
{
	/#
		level waittill(#"open_sesame");
		level.var_1dbad94a = 1;
		zm_island_ww_quest::function_23d17338(level.var_1dbad94a);
		level.var_2e16e689 = 1;
		zm_island_ww_quest::function_1dc42fdf(level.var_2e16e689);
		level thread function_21e3b61f();
		level flag::set("" + 4);
	#/
}

/*
	Name: function_21e3b61f
	Namespace: zm_island_power
	Checksum: 0xACE18FE
	Offset: 0x2D38
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_21e3b61f()
{
	/#
		level clientfield::set("", 1);
		wait(3);
		level clientfield::set("", 2);
		wait(3);
		level clientfield::set("", 3);
		level flag::set("");
	#/
}

/*
	Name: function_45585311
	Namespace: zm_island_power
	Checksum: 0x4AE211B2
	Offset: 0x2DE0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_45585311()
{
	if(isdefined(self.var_6fd3d65c) && self.var_6fd3d65c)
	{
		self clientfield::set_to_player("bucket_held", 1);
		if(!(isdefined(self.var_b6a244f9) && self.var_b6a244f9))
		{
			self.var_bb2fd41c = 0;
			self.var_c6cad973 = 0;
		}
		else
		{
			self clientfield::set_to_player("bucket_held", 2);
		}
		self function_ef097ea(self.var_c6cad973, self.var_bb2fd41c, self function_89538fbb(), 0);
	}
}

/*
	Name: function_662fba30
	Namespace: zm_island_power
	Checksum: 0x16F29A43
	Offset: 0x2EB0
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function function_662fba30()
{
	level flag::init("any_player_has_bucket");
	var_c66f413a = struct::get_array("water_bucket_location", "targetname");
	for(i = 1; i < 5; i++)
	{
		a_temp = [];
		foreach(var_991ffe1 in var_c66f413a)
		{
			if(var_991ffe1.script_int === i)
			{
				a_temp[a_temp.size] = var_991ffe1;
			}
		}
		var_623d6569 = array::random(a_temp);
		var_623d6569 thread function_75656c0a();
	}
}

/*
	Name: function_75656c0a
	Namespace: zm_island_power
	Checksum: 0x1D584149
	Offset: 0x3010
	Size: 0x2F8
	Parameters: 0
	Flags: Linked, Private
*/
function private function_75656c0a()
{
	while(true)
	{
		self.model = util::spawn_model("p7_zm_isl_bucket_115", self.origin, self.angles);
		self.trigger = zm_island_util::spawn_trigger_radius(self.origin, 50, 1, &function_16434440);
		self.model clientfield::set("bucket_fx", 1);
		while(!isdefined(self.trigger))
		{
			wait(0.05);
		}
		while(true)
		{
			self.trigger waittill(#"trigger", e_who);
			if(e_who clientfield::get_to_player("bucket_held"))
			{
				continue;
			}
			e_who thread zm_audio::create_and_play_dialog("bucket", "pickup");
			e_who clientfield::set_to_player("bucket_held", 1);
			e_who.var_6fd3d65c = 1;
			e_who playsound("zmb_bucket_pickup");
			if(self.script_int === 1)
			{
				e_who.var_bb2fd41c = 1;
				e_who.var_c6cad973 = randomintrange(1, 4);
				/#
					println("" + e_who.var_c6cad973);
				#/
			}
			else
			{
				e_who.var_bb2fd41c = 0;
				e_who.var_c6cad973 = 0;
			}
			e_who thread function_ef097ea(e_who.var_c6cad973, e_who.var_bb2fd41c, e_who function_89538fbb(), 1);
			self.model clientfield::set("bucket_fx", 0);
			self.model delete();
			zm_unitrigger::unregister_unitrigger(self.trigger);
			self.trigger = undefined;
			level flag::set("any_player_has_bucket");
			break;
		}
		e_who util::waittill_any("clone_plant_bucket_lost", "disconnect");
	}
}

/*
	Name: function_4b057b64
	Namespace: zm_island_power
	Checksum: 0x41EDFB9D
	Offset: 0x3310
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_4b057b64()
{
	self endon(#"disconnect");
	self clientfield::set_to_player("bucket_held", 0);
	self.var_6fd3d65c = 0;
	self.var_bb2fd41c = 0;
	self.var_c6cad973 = 0;
	self function_ef097ea(self.var_c6cad973, self.var_bb2fd41c, 0, 0);
}

/*
	Name: function_16434440
	Namespace: zm_island_power
	Checksum: 0x344BB8A9
	Offset: 0x3398
	Size: 0x42
	Parameters: 1
	Flags: Linked, Private
*/
function private function_16434440(e_player)
{
	if(e_player clientfield::get_to_player("bucket_held"))
	{
		return &"";
	}
	return &"ZM_ISLAND_PICKUP_BUCKET";
}

/*
	Name: function_a84a1aec
	Namespace: zm_island_power
	Checksum: 0x248A1021
	Offset: 0x33E8
	Size: 0x17C
	Parameters: 2
	Flags: Linked
*/
function function_a84a1aec(var_c6cad973, var_350cfc56)
{
	if(!self clientfield::get_to_player("bucket_held"))
	{
		return;
	}
	if(isdefined(var_c6cad973))
	{
		self.var_bb2fd41c = 3;
		self playsound("zmb_bucket_water_pickup");
		self.var_c6cad973 = var_c6cad973;
		self thread function_ef097ea(self.var_c6cad973, self.var_bb2fd41c, self function_89538fbb(), 1);
	}
	else
	{
		if(isdefined(var_350cfc56) && var_350cfc56)
		{
			self.var_bb2fd41c = self.var_bb2fd41c - 3;
		}
		else
		{
			self.var_bb2fd41c = self.var_bb2fd41c - 1;
		}
		if(isdefined(self.var_b6a244f9) && self.var_b6a244f9)
		{
			self.var_bb2fd41c = 3;
		}
		if(self.var_bb2fd41c <= 0)
		{
			self.var_bb2fd41c = 0;
			self.var_c6cad973 = 0;
		}
		self thread function_ef097ea(self.var_c6cad973, self.var_bb2fd41c, self function_89538fbb(), 1);
	}
}

/*
	Name: function_89538fbb
	Namespace: zm_island_power
	Checksum: 0x4C5FFCAF
	Offset: 0x3570
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_89538fbb()
{
	if(isdefined(self.var_6fd3d65c) && self.var_6fd3d65c && (isdefined(self.var_b6a244f9) && self.var_b6a244f9))
	{
		return 2;
	}
	if(isdefined(self.var_6fd3d65c) && self.var_6fd3d65c && (!(isdefined(self.var_b6a244f9) && self.var_b6a244f9)))
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_ef097ea
	Namespace: zm_island_power
	Checksum: 0x430A761A
	Offset: 0x35F0
	Size: 0xC4
	Parameters: 4
	Flags: Linked
*/
function function_ef097ea(var_c6cad973 = 0, var_44bdb80e = 0, var_3f242b55 = 0, var_b89973c8 = 0)
{
	self thread function_3945e60c(var_c6cad973, var_44bdb80e, var_3f242b55, var_b89973c8);
	self thread function_16ae5bf5();
	self thread function_53f26a4c();
}

/*
	Name: function_3945e60c
	Namespace: zm_island_power
	Checksum: 0xAD6E75B
	Offset: 0x36C0
	Size: 0xDC
	Parameters: 4
	Flags: Linked
*/
function function_3945e60c(var_c6cad973, var_44bdb80e, var_3f242b55, var_b89973c8)
{
	self clientfield::set_to_player("bucket_held", var_3f242b55);
	self clientfield::set_to_player("bucket_bucket_type", var_3f242b55);
	if(var_c6cad973 > 0)
	{
		self clientfield::set_to_player("bucket_bucket_water_type", var_c6cad973 - 1);
	}
	self clientfield::set_to_player("bucket_bucket_water_level", var_44bdb80e);
	if(var_b89973c8)
	{
		self thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.widget_bucket_parts", 0);
	}
}

/*
	Name: function_d570abb
	Namespace: zm_island_power
	Checksum: 0x7DDB49C1
	Offset: 0x37A8
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_d570abb()
{
	if(!self clientfield::get_to_player("bucket_held"))
	{
		self clientfield::set_to_player("bucket_held", 1);
		self.var_6fd3d65c = 1;
	}
	if(isdefined(self.var_b6a244f9) && self.var_b6a244f9)
	{
		self clientfield::set_to_player("bucket_held", 2);
		self.var_bb2fd41c = 3;
		self.var_c6cad973 = 1;
	}
	else
	{
		self.var_bb2fd41c = 0;
		self.var_c6cad973 = 0;
	}
	self thread function_ef097ea(self.var_c6cad973, self.var_bb2fd41c, self function_89538fbb(), 1);
}

/*
	Name: function_c5751341
	Namespace: zm_island_power
	Checksum: 0x39E31ACB
	Offset: 0x38A8
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_c5751341()
{
	level.var_4a0060c0 = getentarray("water_source", "targetname");
	foreach(var_7e208829 in level.var_4a0060c0)
	{
		var_7e208829 thread function_3e519f17();
	}
	var_72b16720 = getent("water_source_ee", "targetname");
	var_72b16720 thread function_d99ed9ac();
}

/*
	Name: function_3e519f17
	Namespace: zm_island_power
	Checksum: 0x74A23E18
	Offset: 0x39A8
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function function_3e519f17()
{
	self setinvisibletoall();
	self sethintstring(&"ZM_ISLAND_FILL_BUCKET");
	self setcursorhint("HINT_NOICON");
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(!e_who clientfield::get_to_player("bucket_held"))
		{
			continue;
		}
		e_who thread function_a84a1aec(self.script_int);
		e_who notify(#"player_filled_bucket");
		/#
			if(isdefined(e_who.playernum))
			{
				println(("" + e_who.playernum) + "");
			}
		#/
	}
}

/*
	Name: function_d99ed9ac
	Namespace: zm_island_power
	Checksum: 0xAC039A8B
	Offset: 0x3AC8
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function function_d99ed9ac()
{
	self sethintstring(&"");
	while(true)
	{
		self waittill(#"touch", e_who);
		if(isvehicle(e_who))
		{
			e_player = e_who.e_parent;
		}
		else
		{
			continue;
		}
		if(!e_player clientfield::get_to_player("bucket_held"))
		{
			continue;
		}
		if(e_player util::use_button_held())
		{
			continue;
		}
		if(e_player usebuttonpressed())
		{
			e_player.var_7621b9dd = gettime();
			if(isdefined(e_player.var_57db2550) && (e_player.var_7621b9dd - e_player.var_57db2550) > 250)
			{
				e_player thread function_a84a1aec(self.script_int);
				/#
					println(("" + e_player.playernum) + "");
				#/
			}
		}
	}
}

/*
	Name: function_a7a30925
	Namespace: zm_island_power
	Checksum: 0x9FC03C8F
	Offset: 0x3C50
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_a7a30925()
{
	self endon(#"death");
	self endon(#"sewer_over");
	var_72b16720 = getent("water_source_ee", "targetname");
	while(true)
	{
		self util::waittill_use_button_pressed();
		if(!self istouching(var_72b16720))
		{
			self.var_57db2550 = gettime();
		}
		wait(0.05);
	}
}

/*
	Name: function_16ae5bf5
	Namespace: zm_island_power
	Checksum: 0xEFFEE67
	Offset: 0x3CF0
	Size: 0x182
	Parameters: 0
	Flags: Linked
*/
function function_16ae5bf5()
{
	if(!self clientfield::get_to_player("bucket_held"))
	{
		foreach(var_7e208829 in level.var_4a0060c0)
		{
			var_7e208829 setinvisibletoplayer(self);
		}
		return;
	}
	foreach(var_7e208829 in level.var_4a0060c0)
	{
		if(self.var_bb2fd41c == 3 && self.var_c6cad973 == var_7e208829.script_int)
		{
			var_7e208829 setinvisibletoplayer(self);
			continue;
		}
		var_7e208829 setvisibletoplayer(self);
	}
}

/*
	Name: function_5b3bc8
	Namespace: zm_island_power
	Checksum: 0x12899B10
	Offset: 0x3E80
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_5b3bc8()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_d8d81d72);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: function_d8d81d72
	Namespace: zm_island_power
	Checksum: 0x84C71926
	Offset: 0x3F60
	Size: 0x454
	Parameters: 1
	Flags: Linked
*/
function function_d8d81d72(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				foreach(player in level.players)
				{
					if(player clientfield::get_to_player(""))
					{
						continue;
					}
					player clientfield::set_to_player("", 1);
					player.var_6fd3d65c = 1;
					player.var_bb2fd41c = 0;
					player.var_c6cad973 = 0;
					player thread function_ef097ea(player.var_c6cad973, player.var_bb2fd41c, player function_89538fbb(), 1);
				}
				return true;
			}
			case "":
			{
				foreach(player in level.players)
				{
					player thread function_a84a1aec(1);
				}
				return true;
			}
			case "":
			{
				foreach(player in level.players)
				{
					player thread function_a84a1aec(2);
				}
				return true;
			}
			case "":
			{
				foreach(player in level.players)
				{
					player thread function_a84a1aec(3);
				}
				return true;
			}
			case "":
			{
				foreach(player in level.players)
				{
					player thread function_a84a1aec(4);
				}
				return true;
			}
			case "":
			{
				foreach(player in level.players)
				{
					player thread function_a84a1aec(undefined, 1);
				}
				return true;
			}
			case "":
			{
				level thread function_1b3134ae();
				return true;
			}
		}
		return false;
	#/
}

/*
	Name: function_1b3134ae
	Namespace: zm_island_power
	Checksum: 0x429C8349
	Offset: 0x43C0
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function function_1b3134ae()
{
	/#
		var_5646068 = struct::get_array("", "");
		foreach(var_991ffe1 in var_5646068)
		{
			if(isdefined(var_991ffe1.trigger))
			{
				continue;
			}
			var_991ffe1 thread function_75656c0a();
		}
	#/
}

