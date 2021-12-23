// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_temple_sq;
#using scripts\zm\zm_temple_sq_brock;
#using scripts\zm\zm_temple_sq_skits;

#namespace zm_temple_sq_dgcwf;

/*
	Name: init
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0x329C5C52
	Offset: 0x300
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level flag::init("dgcwf_on_plate");
	level flag::init("dgcwf_sw1_pressed");
	level flag::init("dgcwf_plot_vo_done");
	level._on_plate = 0;
	zm_sidequests::declare_sidequest_stage("sq", "DgCWf", &init_stage, &stage_logic, &exit_stage);
	zm_sidequests::set_stage_time_limit("sq", "DgCWf", 300);
	zm_sidequests::declare_stage_asset_from_struct("sq", "DgCWf", "sq_dgcwf_sw1", &function_3ab2e3c3, &function_375f6cbc);
	zm_sidequests::declare_stage_asset("sq", "DgCWf", "sq_dgcwf_trig", &plate_trigger);
}

/*
	Name: plate_counter
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0xC2D122C7
	Offset: 0x478
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function plate_counter()
{
	self endon(#"death");
	var_b4264aa6 = 4;
	/#
		if(getdvarint("") >= 2)
		{
			var_b4264aa6 = getplayers().size;
		}
	#/
	while(true)
	{
		if(level._on_plate >= (var_b4264aa6 - 1) && !level flag::get("dgcwf_on_plate"))
		{
			level flag::set("dgcwf_on_plate");
		}
		else if(level flag::get("dgcwf_on_plate") && level._on_plate < (var_b4264aa6 - 1))
		{
			level flag::clear("dgcwf_on_plate");
		}
		wait(0.05);
	}
}

/*
	Name: plate_debug
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0x97D334A5
	Offset: 0x598
	Size: 0x2A0
	Parameters: 0
	Flags: Linked
*/
function plate_debug()
{
	/#
		level endon(#"sq_dgcwf_over");
		if(!isdefined(level._debug_plate))
		{
			level._debug_plate = 1;
			level.on_plate_val = newdebughudelem();
			level.on_plate_val.location = 0;
			level.on_plate_val.alignx = "";
			level.on_plate_val.aligny = "";
			level.on_plate_val.foreground = 1;
			level.on_plate_val.fontscale = 1.3;
			level.on_plate_val.sort = 20;
			level.on_plate_val.x = 10;
			level.on_plate_val.y = 240;
			level.on_plate_val.og_scale = 1;
			level.on_plate_val.color = vectorscale((1, 1, 1), 255);
			level.on_plate_val.alpha = 1;
			level.on_plate_text = newdebughudelem();
			level.on_plate_text.location = 0;
			level.on_plate_text.alignx = "";
			level.on_plate_text.aligny = "";
			level.on_plate_text.foreground = 1;
			level.on_plate_text.fontscale = 1.3;
			level.on_plate_text.sort = 20;
			level.on_plate_text.x = 0;
			level.on_plate_text.y = 240;
			level.on_plate_text.og_scale = 1;
			level.on_plate_text.color = vectorscale((1, 1, 1), 255);
			level.on_plate_text.alpha = 1;
			level.on_plate_text settext("");
		}
		while(true)
		{
			if(isdefined(level._on_plate))
			{
				level.on_plate_val setvalue(level._on_plate);
			}
			wait(0.1);
		}
	#/
}

/*
	Name: restart_plate_mon
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0x4103D1E7
	Offset: 0x840
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function restart_plate_mon(trig)
{
	trig endon(#"death");
	level endon(#"sq_dgcwf_over");
	self waittill(#"spawned_player");
	self thread plate_monitor(trig);
}

/*
	Name: plate_monitor
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0xA21B044D
	Offset: 0x898
	Size: 0x208
	Parameters: 1
	Flags: Linked
*/
function plate_monitor(trig)
{
	self endon(#"disconnect");
	trig endon(#"death");
	level endon(#"sq_dgcwf_over");
	while(true)
	{
		while(!self istouching(trig))
		{
			wait(0.1);
		}
		if(level._on_plate < 4)
		{
			level._on_plate++;
		}
		trig playsound("evt_sq_dgcwf_plate_" + level._on_plate);
		if(level._on_plate <= 2 && !level flag::get("dgcwf_sw1_pressed"))
		{
			self thread zm_audio::create_and_play_dialog("eggs", "quest2", 0);
		}
		else
		{
			self thread zm_audio::create_and_play_dialog("eggs", "quest2", 1);
		}
		while(self istouching(trig) && self.sessionstate != "spectator")
		{
			wait(0.05);
		}
		if(level._on_plate >= 0)
		{
			level._on_plate--;
		}
		if(self.sessionstate == "spectator")
		{
			self thread restart_plate_mon(trig);
			return;
		}
		if(level._on_plate < 3 && !level flag::get("dgcwf_sw1_pressed"))
		{
			self thread zm_audio::create_and_play_dialog("eggs", "quest2", 2);
		}
	}
}

/*
	Name: plate_trigger
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0x2F1A3392
	Offset: 0xAA8
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function plate_trigger()
{
	self endon(#"death");
	self thread play_success_audio();
	self thread begin_dgcwf_vox();
	level.var_9fb9bcda = spawn("script_origin", self.origin);
	level.var_9fb9bcda playloopsound("evt_sq_dgcwf_waterthrash_loop", 2);
	if(getplayers().size == 1)
	{
		level flag::set("dgcwf_on_plate");
		return;
	}
	/#
		level thread plate_debug();
	#/
	self thread plate_counter();
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] thread plate_monitor(self);
	}
}

/*
	Name: begin_dgcwf_vox
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0xFE06B850
	Offset: 0xC08
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function begin_dgcwf_vox()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", who);
		if(isplayer(who))
		{
			self stoploopsound(1);
			level.var_9fb9bcda stoploopsound(1);
			level.var_9fb9bcda delete();
			who thread dgcwf_story_vox();
			return;
		}
		wait(0.05);
	}
}

/*
	Name: function_375f6cbc
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0xE818E930
	Offset: 0xCD0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_375f6cbc()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", who);
		who thread zm_audio::create_and_play_dialog("eggs", "quest2", 3);
		self.owner_ent.pressed = 1;
	}
}

/*
	Name: function_3ab2e3c3
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0x601E4E8E
	Offset: 0xD50
	Size: 0x298
	Parameters: 0
	Flags: Linked
*/
function function_3ab2e3c3()
{
	self endon(#"death");
	self show();
	self.on_pos = self.origin;
	self.off_pos = self.on_pos - (anglestoright(self.angles) * 36);
	self.origin = self.off_pos;
	self.trigger triggerenable(0);
	self.pressed = 0;
	while(true)
	{
		if(level flag::get("dgcwf_on_plate"))
		{
			self.pressed = 0;
			self moveto(self.on_pos, 0.25);
			self playsound("evt_sq_dgcwf_lever_kachunk");
			self waittill(#"movedone");
			self.trigger triggerenable(1);
			while(level flag::get("dgcwf_on_plate"))
			{
				if(self.pressed)
				{
					self playsound("evt_sq_dgcwf_lever_success");
					self rotateroll(75, 0.15);
					self.trigger triggerenable(0);
					level flag::set("dgcwf_sw1_pressed");
					return;
				}
				wait(0.05);
			}
		}
		else
		{
			self.pressed = 0;
			self.trigger triggerenable(0);
			self playsound("evt_sq_dgcwf_lever_dechunk");
			self moveto(self.off_pos, 0.25);
			self waittill(#"movedone");
			while(!level flag::get("dgcwf_on_plate"))
			{
				wait(0.05);
			}
		}
		wait(0.05);
	}
}

/*
	Name: init_stage
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0xCE4E2D48
	Offset: 0xFF0
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function init_stage()
{
	level._on_plate = 0;
	if(getplayers().size > 1)
	{
		level flag::clear("dgcwf_on_plate");
	}
	level flag::clear("dgcwf_sw1_pressed");
	level flag::clear("dgcwf_plot_vo_done");
	trig = getent("sq_dgcwf_trig", "targetname");
	trig triggerenable(1);
	zm_temple_sq_brock::delete_radio();
	level thread delayed_start_skit();
}

/*
	Name: delayed_start_skit
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0x550DC9DC
	Offset: 0x10F8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function delayed_start_skit()
{
	wait(0.5);
	level thread zm_temple_sq_skits::start_skit("tt2");
}

/*
	Name: stage_logic
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0xAA48FEC
	Offset: 0x1130
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function stage_logic()
{
	level endon(#"sq_dgcwf_over");
	level flag::wait_till("dgcwf_on_plate");
	level flag::wait_till("dgcwf_sw1_pressed");
	level notify(#"suspend_timer");
	level notify(#"raise_crystal_1");
	level notify(#"raise_crystal_2", 1);
	level thread slightly_delayed_player_response();
	level waittill(#"hash_3ee76d25");
	level flag::wait_till("dgcwf_plot_vo_done");
	wait(5);
	level thread zm_sidequests::stage_completed("sq", "DgCWf");
}

/*
	Name: slightly_delayed_player_response
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0xF9118EB3
	Offset: 0x1218
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function slightly_delayed_player_response()
{
	wait(2.5);
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("eggs", "quest2", 4);
}

/*
	Name: play_success_audio
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0x416F13FD
	Offset: 0x1298
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function play_success_audio()
{
	level endon(#"sq_dgcwf_over");
	level flag::wait_till("dgcwf_on_plate");
	level flag::wait_till("dgcwf_sw1_pressed");
	playsoundatposition("evt_sq_dgcwf_gears", self.origin);
}

/*
	Name: exit_stage
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0x72A047BF
	Offset: 0x1310
	Size: 0x146
	Parameters: 1
	Flags: Linked
*/
function exit_stage(success)
{
	if(isdefined(level._debug_plate))
	{
		level._debug_plate = undefined;
		level.on_plate_val destroy();
		level.on_plate_val = undefined;
		level.on_plate_text destroy();
		level.on_plate_text = undefined;
	}
	trig = getent("sq_dgcwf_trig", "targetname");
	trig triggerenable(0);
	if(success)
	{
		zm_temple_sq_brock::create_radio(3);
	}
	else
	{
		zm_temple_sq_brock::create_radio(2, &zm_temple_sq_brock::radio2_override);
		level thread zm_temple_sq_skits::fail_skit();
	}
	level.skit_vox_override = 0;
	if(isdefined(level._dgcwf_sound_ent))
	{
		level._dgcwf_sound_ent delete();
		level._dgcwf_sound_ent = undefined;
	}
}

/*
	Name: dgcwf_story_vox
	Namespace: zm_temple_sq_dgcwf
	Checksum: 0x34821354
	Offset: 0x1460
	Size: 0x216
	Parameters: 0
	Flags: Linked
*/
function dgcwf_story_vox()
{
	level endon(#"sq_dgcwf_over");
	struct = struct::get("sq_location_dgcwf", "targetname");
	if(!isdefined(struct))
	{
		return;
	}
	level._dgcwf_sound_ent = spawn("script_origin", struct.origin);
	if(isdefined(self))
	{
		level.skit_vox_override = 1;
		self playsoundwithnotify("vox_egg_story_2_0" + zm_temple_sq::function_26186755(self.characterindex), "vox_egg_sounddone");
		self waittill(#"vox_egg_sounddone");
		level.skit_vox_override = 0;
	}
	level._dgcwf_sound_ent playsoundwithnotify("vox_egg_story_2_1", "sounddone");
	level._dgcwf_sound_ent waittill(#"sounddone");
	if(isdefined(self))
	{
		level.skit_vox_override = 1;
		self playsoundwithnotify("vox_egg_story_2_2" + zm_temple_sq::function_26186755(self.characterindex), "vox_egg_sounddone");
		self waittill(#"vox_egg_sounddone");
		level.skit_vox_override = 0;
	}
	level flag::wait_till("dgcwf_sw1_pressed");
	level._dgcwf_sound_ent playsoundwithnotify("vox_egg_story_2_3", "sounddone");
	level._dgcwf_sound_ent waittill(#"sounddone");
	level flag::set("dgcwf_plot_vo_done");
	level._dgcwf_sound_ent delete();
	level._dgcwf_sound_ent = undefined;
}

