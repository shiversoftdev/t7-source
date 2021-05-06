// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_temple_sq;
#using scripts\zm\zm_temple_sq_brock;
#using scripts\zm\zm_temple_sq_skits;

#namespace zm_temple_sq_std;

/*
	Name: init
	Namespace: zm_temple_sq_std
	Checksum: 0x592DC8DB
	Offset: 0x2F8
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function init()
{
	zm_sidequests::declare_sidequest_stage("sq", "StD", &init_stage, &stage_logic, &exit_stage);
	zm_sidequests::set_stage_time_limit("sq", "StD", 300);
	zm_sidequests::declare_stage_asset_from_struct("sq", "StD", "sq_sad_trig", &function_3ea85f63);
	level flag::init("std_target_1");
	level flag::init("std_target_2");
	level flag::init("std_target_3");
	level flag::init("std_target_4");
	level flag::init("std_plot_vo_done");
}

/*
	Name: init_stage
	Namespace: zm_temple_sq_std
	Checksum: 0x115D0CAC
	Offset: 0x458
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function init_stage()
{
	util::clientnotify("SR");
	level flag::clear("std_target_1");
	level flag::clear("std_target_2");
	level flag::clear("std_target_3");
	level flag::clear("std_target_4");
	level flag::clear("std_plot_vo_done");
	level thread delayed_start_skit();
	level thread play_waterthrash_loop();
	zm_temple_sq_brock::delete_radio();
}

/*
	Name: delayed_start_skit
	Namespace: zm_temple_sq_std
	Checksum: 0xB0791AC9
	Offset: 0x560
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function delayed_start_skit()
{
	wait(0.5);
	level thread zm_temple_sq_skits::start_skit("tt5");
}

/*
	Name: play_waterthrash_loop
	Namespace: zm_temple_sq_std
	Checksum: 0xADF62339
	Offset: 0x598
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function play_waterthrash_loop()
{
	level endon(#"sq_std_over");
	struct = struct::get("sq_location_std", "targetname");
	if(!isdefined(struct))
	{
		return;
	}
	level._std_sound_waterthrash_ent = spawn("script_origin", struct.origin);
	level._std_sound_waterthrash_ent playloopsound("evt_sq_std_waterthrash_loop", 2);
	level waittill(#"sq_std_story_vox_begun");
	level._std_sound_waterthrash_ent stoploopsound(5);
	wait(5);
	level._std_sound_waterthrash_ent delete();
	level._std_sound_waterthrash_ent = undefined;
}

/*
	Name: target_debug
	Namespace: zm_temple_sq_std
	Checksum: 0xDB4BC310
	Offset: 0x690
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function target_debug()
{
	/#
		self endon(#"death");
		self endon(#"spiked");
		while(!(isdefined(level.disable_print3d_ent) && level.disable_print3d_ent))
		{
			print3d(self.origin, "", vectorscale((0, 1, 0), 255), 1);
			wait(0.1);
		}
	#/
}

/*
	Name: function_3ea85f63
	Namespace: zm_temple_sq_std
	Checksum: 0x8F3A812
	Offset: 0x708
	Size: 0x31C
	Parameters: 0
	Flags: Linked
*/
function function_3ea85f63()
{
	if(!isdefined(level.var_b19e3661))
	{
		level.var_b19e3661 = 0;
	}
	level.var_68e59898 = 1;
	self thread target_debug();
	self thread begin_std_story_vox();
	self thread player_hint_line();
	self thread player_first_success();
	self playsound("evt_sq_std_spray_start");
	self playloopsound("evt_sq_std_spray_loop", 1);
	trigger = spawn("trigger_damage", self.origin, 0, 32, 32);
	trigger.angles = self.angles + (0, 90, 90);
	var_a4ff74b9 = getweapon("bouncingbetty");
	attacker = undefined;
	while(true)
	{
		trigger waittill(#"damage", amount, attacker, dir, point, mod, tagname, modelname, partname, weaponname, dflags, inflictor, chargelevel);
		if(weaponname == var_a4ff74b9 && !level.var_b19e3661)
		{
			level.var_b19e3661 = 1;
			break;
		}
	}
	if(!isdefined(attacker))
	{
		attacker = getplayers()[0];
	}
	self notify(#"spiked", attacker);
	self stoploopsound(1);
	self playsound("evt_sq_std_spray_stop");
	level flag::set("std_target_" + self.script_int);
	util::clientnotify("S" + self.script_int);
	util::delay(0.1, undefined, &function_4fdfc508);
	trigger delete();
}

/*
	Name: function_4fdfc508
	Namespace: zm_temple_sq_std
	Checksum: 0x123E5142
	Offset: 0xA30
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function function_4fdfc508()
{
	level.var_b19e3661 = 0;
}

/*
	Name: player_first_success
	Namespace: zm_temple_sq_std
	Checksum: 0xB7A882CC
	Offset: 0xA48
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function player_first_success()
{
	self endon(#"death");
	level endon(#"sq_std_first");
	self waittill(#"spiked", who);
	who thread zm_audio::create_and_play_dialog("eggs", "quest5", 1);
	level notify(#"sq_std_first");
}

/*
	Name: player_hint_line
	Namespace: zm_temple_sq_std
	Checksum: 0x58E86079
	Offset: 0xAC0
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function player_hint_line()
{
	self endon(#"death");
	level endon(#"sq_std_hint_given");
	level waittill(#"sq_std_hint_line");
	while(true)
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(self.origin) && distancesquared(self.origin, players[i].origin) <= 10000)
			{
				players[i] thread zm_audio::create_and_play_dialog("eggs", "quest5", 0);
				level notify(#"sq_std_hint_given");
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: begin_std_story_vox
	Namespace: zm_temple_sq_std
	Checksum: 0xCD7642DD
	Offset: 0xBD8
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function begin_std_story_vox()
{
	self endon(#"death");
	level endon(#"sq_std_story_vox_begun");
	while(true)
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(distancesquared(self.origin, players[i].origin) <= 10000)
			{
				level thread std_story_vox(players[i]);
				level notify(#"sq_std_story_vox_begun");
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: stage_logic
	Namespace: zm_temple_sq_std
	Checksum: 0xBDE3FCB0
	Offset: 0xCC0
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function stage_logic()
{
	level flag::wait_till("std_target_1");
	level flag::wait_till("std_target_2");
	level flag::wait_till("std_target_3");
	level flag::wait_till("std_target_4");
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("eggs", "quest5", 2);
	level waittill(#"waterfall");
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].used_waterfall) && players[i].used_waterfall == 1)
		{
			players[i] thread zm_audio::create_and_play_dialog("eggs", "quest5", 3);
		}
	}
	level notify(#"suspend_timer");
	level notify(#"raise_crystal_1");
	level notify(#"raise_crystal_2");
	level notify(#"raise_crystal_3");
	level notify(#"raise_crystal_4");
	level notify(#"raise_crystal_5", 1);
	level waittill(#"hash_ccdffdea");
	level flag::wait_till("std_plot_vo_done");
	wait(5);
	zm_sidequests::stage_completed("sq", "StD");
}

/*
	Name: exit_stage
	Namespace: zm_temple_sq_std
	Checksum: 0xEC8BA215
	Offset: 0xF08
	Size: 0x196
	Parameters: 1
	Flags: Linked
*/
function exit_stage(success)
{
	targs = getentarray("sq_sad", "targetname");
	util::clientnotify("ksd");
	level flag::clear("std_target_1");
	level flag::clear("std_target_2");
	level flag::clear("std_target_3");
	level flag::clear("std_target_4");
	if(success)
	{
		zm_temple_sq_brock::create_radio(6);
		zm_temple_sq::spawn_skel();
	}
	else
	{
		zm_temple_sq_brock::create_radio(5);
		level thread zm_temple_sq_skits::fail_skit();
	}
	if(isdefined(level._std_sound_ent))
	{
		level._std_sound_ent delete();
		level._std_sound_ent = undefined;
	}
	if(isdefined(level._std_sound_waterthrash_ent))
	{
		level._std_sound_waterthrash_ent delete();
		level._std_sound_waterthrash_ent = undefined;
	}
}

/*
	Name: std_story_vox
	Namespace: zm_temple_sq_std
	Checksum: 0xE3C52305
	Offset: 0x10A8
	Size: 0x152
	Parameters: 1
	Flags: Linked
*/
function std_story_vox(player)
{
	level endon(#"sq_std_over");
	struct = struct::get("sq_location_std", "targetname");
	if(!isdefined(struct))
	{
		return;
	}
	level._std_sound_ent = spawn("script_origin", struct.origin);
	level thread std_story_vox_wait_for_finish();
	level._std_sound_ent playsoundwithnotify("vox_egg_story_4_0", "sounddone");
	level._std_sound_ent waittill(#"sounddone");
	if(isdefined(player))
	{
		level.skit_vox_override = 1;
		player playsoundwithnotify("vox_egg_story_4_1" + zm_temple_sq::function_26186755(player.characterindex), "vox_egg_sounddone");
		player waittill(#"vox_egg_sounddone");
		level.skit_vox_override = 0;
	}
	level notify(#"sq_std_hint_line");
}

/*
	Name: std_story_vox_wait_for_finish
	Namespace: zm_temple_sq_std
	Checksum: 0xAD7B3BCB
	Offset: 0x1208
	Size: 0x18E
	Parameters: 0
	Flags: Linked
*/
function std_story_vox_wait_for_finish()
{
	level endon(#"sq_std_over");
	count = 0;
	while(true)
	{
		level waittill(#"waterfall");
		if(!level flag::get("std_target_1") || !level flag::get("std_target_2") || !level flag::get("std_target_3") || !level flag::get("std_target_4"))
		{
			if(count < 1)
			{
				level._std_sound_ent playsoundwithnotify("vox_egg_story_4_2", "sounddone");
				level._std_sound_ent waittill(#"sounddone");
				count++;
			}
		}
		else
		{
			level._std_sound_ent playsoundwithnotify("vox_egg_story_4_3", "sounddone");
			level._std_sound_ent waittill(#"sounddone");
			break;
		}
	}
	level flag::set("std_plot_vo_done");
	level._std_sound_ent delete();
	level._std_sound_ent = undefined;
}

