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
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_moon_amb;
#using scripts\zm\zm_moon_sq;

#namespace zm_moon_sq_ctt;

/*
	Name: init_1
	Namespace: zm_moon_sq_ctt
	Checksum: 0x337D1609
	Offset: 0x538
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function init_1()
{
	level._active_tanks = [];
	zm_spawner::add_custom_zombie_spawn_logic(&tank_volume_death_check);
	zm_sidequests::declare_sidequest_stage("tanks", "ctt1", &init_stage_1, &stage_logic, &exit_stage_1);
}

/*
	Name: init_stage_1
	Namespace: zm_moon_sq_ctt
	Checksum: 0xCD29E1B
	Offset: 0x5C8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function init_stage_1()
{
	level._active_tanks = [];
	level._cur_stage_name = "ctt1";
	level._ctt_pause_flag = "sam_switch_thrown";
	level._charge_flag = "first_tanks_charged";
	add_tank("sq_first_tank");
	level clientfield::increment("charge_tank_1");
	level thread setup_and_play_ctt1_vox();
}

/*
	Name: exit_stage_1
	Namespace: zm_moon_sq_ctt
	Checksum: 0x8A1BFB0F
	Offset: 0x668
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function exit_stage_1(success)
{
	kill_tanks();
}

/*
	Name: init_2
	Namespace: zm_moon_sq_ctt
	Checksum: 0x9612A6AA
	Offset: 0x690
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function init_2()
{
	zm_sidequests::declare_sidequest_stage("tanks", "ctt2", &init_stage_2, &stage_logic, &exit_stage_2);
}

/*
	Name: init_stage_2
	Namespace: zm_moon_sq_ctt
	Checksum: 0x93C696DC
	Offset: 0x6F0
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function init_stage_2()
{
	level._active_tanks = [];
	level._cur_stage_name = "ctt2";
	level._ctt_pause_flag = "cvg_placed";
	level._charge_flag = "second_tanks_charged";
}

/*
	Name: exit_stage_2
	Namespace: zm_moon_sq_ctt
	Checksum: 0xB398749C
	Offset: 0x738
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function exit_stage_2(success)
{
	level flag::set("second_tanks_charged");
	kill_tanks();
}

/*
	Name: stage_logic
	Namespace: zm_moon_sq_ctt
	Checksum: 0x4815D848
	Offset: 0x780
	Size: 0x4D4
	Parameters: 0
	Flags: Linked
*/
function stage_logic()
{
	if(level._cur_stage_name == "ctt2")
	{
		s = struct::get("sq_vg_final", "targetname");
		r_close = 0;
		while(!r_close)
		{
			players = getplayers();
			for(i = 0; i < players.size; i++)
			{
				ent_num = players[i].characterindex;
				if(isdefined(players[i].zm_random_char))
				{
					ent_num = players[i].zm_random_char;
				}
				if(ent_num == 2)
				{
					d = distancesquared(players[i].origin, s.origin);
					if(d < 57600)
					{
						r_close = 1;
						players[i] playsound("vox_plr_2_quest_step6_0");
						break;
					}
				}
			}
			wait(0.1);
		}
		add_tank("sq_first_tank", "sq_second_tank");
		level clientfield::increment("charge_tank_2");
		level thread setup_and_play_ctt2_vox();
		level thread hit_sam();
	}
	while(true)
	{
		if(all_tanks_full())
		{
			sound::play_in_space("zmb_squest_all_souls_full", (0, 0, 0));
			level notify(#"ctt_aud_note");
			break;
		}
		wait(0.1);
	}
	level clientfield::increment("charge_tank_cleanup");
	level flag::set(level._charge_flag);
	level flag::wait_till(level._ctt_pause_flag);
	drain_tanks();
	for(i = 0; i < level._active_tanks.size; i++)
	{
		tank = level._active_tanks[i];
		tank.capacitor moveto(tank.capacitor.origin + vectorscale((0, 0, 1), 12), 2);
		tank.tank moveto(tank.tank.origin - vectorscale((0, 0, 1), 57.156), 2);
		tank.tank playsound("evt_tube_move_down");
		tank.tank util::delay(2, undefined, &exploder::stop_exploder, "canister_light_0" + tank.tank.script_int);
		tank.tank thread play_delayed_stop_sound(2);
		tank triggerenable(0);
	}
	wait(2);
	if(level._cur_stage_name == "ctt2")
	{
		level flag::set("second_tanks_drained");
	}
	else
	{
		level flag::set("first_tanks_drained");
	}
	zm_sidequests::stage_completed("tanks", level._cur_stage_name);
}

/*
	Name: play_delayed_stop_sound
	Namespace: zm_moon_sq_ctt
	Checksum: 0xB96228C4
	Offset: 0xC60
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function play_delayed_stop_sound(time)
{
	wait(time);
	self playsound("evt_tube_stop");
}

/*
	Name: build_sam_stage
	Namespace: zm_moon_sq_ctt
	Checksum: 0xC58B1661
	Offset: 0xC98
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function build_sam_stage(percent, l)
{
	s = spawnstruct();
	s.percent = percent;
	s.line = l;
	return s;
}

/*
	Name: percent_full
	Namespace: zm_moon_sq_ctt
	Checksum: 0x45160E2C
	Offset: 0xD00
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function percent_full()
{
	max_fill = 0;
	fill = 0;
	for(i = 0; i < level._active_tanks.size; i++)
	{
		max_fill = max_fill + level._active_tanks[i].max_fill;
		fill = fill + level._active_tanks[i].fill;
	}
	return fill / max_fill;
}

/*
	Name: hit_sam
	Namespace: zm_moon_sq_ctt
	Checksum: 0xFA4524AF
	Offset: 0xDB0
	Size: 0x242
	Parameters: 0
	Flags: Linked
*/
function hit_sam()
{
	level endon(#"tanks_ctt2_over");
	stages = array(build_sam_stage(0.1, "vox_plr_4_quest_step6_1"), build_sam_stage(0.2, "vox_plr_4_quest_step6_1a"), build_sam_stage(0.3, "vox_plr_4_quest_step6_2"), build_sam_stage(0.4, "vox_plr_4_quest_step6_2a"), build_sam_stage(0.5, "vox_plr_4_quest_step6_3"), build_sam_stage(0.6, "vox_plr_4_quest_step6_3a"), build_sam_stage(0.7, "vox_plr_4_quest_step6_4"), build_sam_stage(0.9, "vox_plr_4_quest_step6_5"));
	index = 0;
	targ = struct::get("sq_sam", "targetname");
	targ = struct::get(targ.target, "targetname");
	while(index < stages.size)
	{
		stage = stages[index];
		while(percent_full() < stage.percent)
		{
			wait(0.1);
		}
		level.skit_vox_override = 1;
		level thread play_sam_vo(stage.line, targ.origin, index);
		level.skit_vox_override = 0;
		index++;
	}
}

/*
	Name: play_sam_vo
	Namespace: zm_moon_sq_ctt
	Checksum: 0x1A262E13
	Offset: 0x1000
	Size: 0xDC
	Parameters: 3
	Flags: Linked
*/
function play_sam_vo(_line, origin, index)
{
	level clientfield::set("sam_vo_rumble", 1);
	snd_ent = spawn("script_origin", origin);
	snd_ent playsoundwithnotify(_line, index + "_snddone");
	snd_ent waittill(index + "_snddone");
	level clientfield::set("sam_vo_rumble", 0);
	snd_ent delete();
}

/*
	Name: drain_tanks
	Namespace: zm_moon_sq_ctt
	Checksum: 0xA83BA7D4
	Offset: 0x10E8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function drain_tanks()
{
	for(i = 0; i < level._active_tanks.size; i++)
	{
		tank = level._active_tanks[i];
		tank.fill_model moveto(tank.fill_model.origin - vectorscale((0, 0, 1), 65), 1.5, 0.1, 0.1);
		tank.tank stoploopsound(1);
		tank.tank playsound("evt_souls_flush");
		tank.fill_model thread delay_hide();
		tank.fill = 0;
	}
	wait(2);
}

/*
	Name: delay_hide
	Namespace: zm_moon_sq_ctt
	Checksum: 0xEB9ABC9C
	Offset: 0x1218
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function delay_hide()
{
	wait(2);
	self ghost();
}

/*
	Name: all_tanks_full
	Namespace: zm_moon_sq_ctt
	Checksum: 0x526F6BF4
	Offset: 0x1240
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function all_tanks_full()
{
	if(level._active_tanks.size == 0)
	{
		return false;
	}
	for(i = 0; i < level._active_tanks.size; i++)
	{
		tank = level._active_tanks[i];
		if(tank.fill < tank.max_fill)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: kill_tanks
	Namespace: zm_moon_sq_ctt
	Checksum: 0xE384C598
	Offset: 0x12D0
	Size: 0x10E
	Parameters: 0
	Flags: Linked
*/
function kill_tanks()
{
	level clientfield::increment("charge_tank_cleanup");
	tanks = getentarray("ctt_tank", "script_noteworthy");
	for(i = 0; i < tanks.size; i++)
	{
		tank = tanks[i];
		tank.capacitor delete();
		tank.capacitor = undefined;
		tank.tank = undefined;
		tank.fill_model delete();
		tank.fill_model = undefined;
		tank delete();
	}
}

/*
	Name: movetopos
	Namespace: zm_moon_sq_ctt
	Checksum: 0x5917EF7C
	Offset: 0x13E8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function movetopos(pos)
{
	self moveto(pos, 1);
}

/*
	Name: add_tank
	Namespace: zm_moon_sq_ctt
	Checksum: 0x7654CBF2
	Offset: 0x1420
	Size: 0x500
	Parameters: 2
	Flags: Linked
*/
function add_tank(tank_name, other_tank_name)
{
	tanks = struct::get_array(tank_name, "targetname");
	if(isdefined(other_tank_name))
	{
		tanks = arraycombine(tanks, struct::get_array(other_tank_name, "targetname"), 0, 0);
	}
	for(i = 0; i < tanks.size; i++)
	{
		tank = tanks[i];
		radius = 32;
		if(isdefined(tank.radius))
		{
			radius = tank.radius;
		}
		height = 72;
		if(isdefined(tank.height))
		{
			height = tank.height;
		}
		tank_trigger = spawn("trigger_radius", tank.origin, 1, radius, height);
		tank_trigger.script_noteworthy = "ctt_tank";
		capacitor_struct = struct::get(tank.target, "targetname");
		capacitor_model = spawn("script_model", capacitor_struct.origin + vectorscale((0, 0, 1), 18));
		capacitor_model.angles = capacitor_struct.angles;
		capacitor_model setmodel(capacitor_struct.model);
		capacitor_model thread movetopos(capacitor_struct.origin);
		tank_trigger.capacitor = capacitor_model;
		tank_model = getent(capacitor_struct.target, "targetname");
		tank_model thread movetopos(tank_model.origin + (0, 0, 57.156));
		tank_model playsound("evt_tube_move_up");
		tank_model util::delay(2, undefined, &exploder::exploder, "canister_light_0" + tank_model.script_int);
		tank_model thread play_delayed_stop_sound(1);
		tank_trigger.tank = tank_model;
		tank_trigger.fill = 0;
		scalar = 1;
		scalar = scalar + ((getplayers().size - 1) * 0.33);
		tank_trigger.max_fill = int(25 * scalar);
		max_fill = struct::get(tank_model.target, "targetname");
		tank_trigger.tank.fill_step = (max_fill.origin[2] - (tank_model.origin[2] + 53)) / tank_trigger.max_fill;
		tank_fill_model = util::spawn_model(max_fill.model, tank_trigger.tank.origin + vectorscale((0, 0, 1), 2));
		tank_fill_model ghost();
		tank_trigger.fill_model = tank_fill_model;
		level._active_tanks[level._active_tanks.size] = tank_trigger;
	}
}

/*
	Name: do_tank_fill
	Namespace: zm_moon_sq_ctt
	Checksum: 0x352F58A
	Offset: 0x1928
	Size: 0x18C
	Parameters: 2
	Flags: Linked
*/
function do_tank_fill(actor, tank)
{
	if(tank.fill >= tank.max_fill)
	{
		return;
	}
	actor clientfield::set("ctt", 1);
	wait(0.5);
	if(tank.fill <= 0)
	{
		level notify(#"ctt_first_kill");
	}
	if(isdefined(tank) && tank.fill < tank.max_fill)
	{
		tank.fill++;
		tank.fill_model.origin = tank.fill_model.origin + (0, 0, tank.tank.fill_step);
		tank.fill_model show();
	}
	if(tank.fill >= tank.max_fill)
	{
		tank.tank playsound("zmb_squest_tank_full");
		tank.tank playloopsound("zmb_squest_tank_full_lp", 1);
	}
}

/*
	Name: tank_volume_death_check
	Namespace: zm_moon_sq_ctt
	Checksum: 0x8BF8C164
	Offset: 0x1AC0
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function tank_volume_death_check()
{
	self waittill(#"death", attacker);
	if(!isplayer(attacker))
	{
		return;
	}
	if(!isdefined(self))
	{
		return;
	}
	for(i = 0; i < level._active_tanks.size; i++)
	{
		if(isdefined(level._active_tanks[i]))
		{
			if(self istouching(level._active_tanks[i]))
			{
				level thread do_tank_fill(self, level._active_tanks[i]);
				return;
			}
		}
	}
}

/*
	Name: setup_and_play_ctt1_vox
	Namespace: zm_moon_sq_ctt
	Checksum: 0xF4ECF994
	Offset: 0x1B98
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function setup_and_play_ctt1_vox()
{
	level thread ctt1_first_kill_vox();
	level thread ctt1_full_vox();
	level thread vox_override_while_near_tank();
	level thread ctt1_fifty_percent_vox();
}

/*
	Name: ctt1_first_kill_vox
	Namespace: zm_moon_sq_ctt
	Checksum: 0x24E56F2B
	Offset: 0x1C08
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function ctt1_first_kill_vox()
{
	level waittill(#"ctt_first_kill");
	for(i = 0; i < level._active_tanks.size; i++)
	{
		player = zm_utility::get_closest_player(level._active_tanks[i].origin);
		if(isdefined(player))
		{
			player thread zm_audio::create_and_play_dialog("eggs", "quest4", 0);
			return;
		}
	}
}

/*
	Name: ctt1_fifty_percent_vox
	Namespace: zm_moon_sq_ctt
	Checksum: 0x93A9A390
	Offset: 0x1CB8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function ctt1_fifty_percent_vox()
{
	while(percent_full() < 0.5)
	{
		wait(0.5);
	}
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("eggs", "quest4", 1);
}

/*
	Name: ctt1_full_vox
	Namespace: zm_moon_sq_ctt
	Checksum: 0x7FC3FA28
	Offset: 0x1D58
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function ctt1_full_vox()
{
	level waittill(#"ctt_aud_note");
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("eggs", "quest4", 2);
}

/*
	Name: vox_override_while_near_tank
	Namespace: zm_moon_sq_ctt
	Checksum: 0x22067188
	Offset: 0x1DE0
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function vox_override_while_near_tank()
{
	while(!level flag::get("sam_switch_thrown"))
	{
		while(level.zones["generator_zone"].is_occupied)
		{
			level.skit_vox_override = 1;
			if(level flag::get("sam_switch_thrown"))
			{
				break;
			}
			wait(1);
		}
		level.skit_vox_override = 0;
		wait(1);
	}
	level.skit_vox_override = 1;
	wait(10);
	level.skit_vox_override = 0;
}

/*
	Name: setup_and_play_ctt2_vox
	Namespace: zm_moon_sq_ctt
	Checksum: 0x56845241
	Offset: 0x1EA0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function setup_and_play_ctt2_vox()
{
	level thread vox_override_while_near_tank2();
}

/*
	Name: ctt2_full_vox
	Namespace: zm_moon_sq_ctt
	Checksum: 0x42D16C78
	Offset: 0x1EC8
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function ctt2_full_vox()
{
	level waittill(#"ctt_aud_note");
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("eggs", "quest6", 6);
}

/*
	Name: vox_override_while_near_tank2
	Namespace: zm_moon_sq_ctt
	Checksum: 0x5C7DB4F0
	Offset: 0x1F50
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function vox_override_while_near_tank2()
{
	while(!level flag::get("cvg_placed"))
	{
		while(level.zones["generator_zone"].is_occupied)
		{
			level.skit_vox_override = 1;
			if(level flag::get("cvg_placed"))
			{
				break;
			}
			wait(1);
		}
		level.skit_vox_override = 0;
		wait(1);
	}
	level.skit_vox_override = 1;
	wait(10);
	level.skit_vox_override = 0;
}

