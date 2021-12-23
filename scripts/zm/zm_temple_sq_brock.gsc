// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\zm_temple_sq;

#namespace zm_temple_sq_brock;

/*
	Name: init
	Namespace: zm_temple_sq_brock
	Checksum: 0x50D3E64C
	Offset: 0x208
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level flag::init("radio_4_played");
	level._brock_naglines = [];
	level._brock_corpse_locations = [];
	level._radio_structs = struct::get_array("sq_radios", "targetname");
}

/*
	Name: delete_radio_internal
	Namespace: zm_temple_sq_brock
	Checksum: 0xB7C30401
	Offset: 0x278
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function delete_radio_internal()
{
	if(isdefined(level._active_sq_radio))
	{
		level._active_sq_radio.trigger delete();
		level._active_sq_radio stopsounds();
		util::wait_network_frame();
		level._active_sq_radio delete();
		level._active_sq_radio = undefined;
	}
}

/*
	Name: delete_radio
	Namespace: zm_temple_sq_brock
	Checksum: 0x962B93F3
	Offset: 0x300
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function delete_radio()
{
	level thread delete_radio_internal();
}

/*
	Name: trig_thread
	Namespace: zm_temple_sq_brock
	Checksum: 0x68F4C0AA
	Offset: 0x328
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function trig_thread()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger");
		self.owner_ent notify(#"triggered");
	}
}

/*
	Name: radio_debug
	Namespace: zm_temple_sq_brock
	Checksum: 0x315FE699
	Offset: 0x370
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function radio_debug()
{
	self endon(#"death");
	level endon(#"radio_7_played");
	/#
		while(!(isdefined(level.disable_print3d_ent) && level.disable_print3d_ent))
		{
			print3d(self.origin, "", (0, 255, 255), 1);
			wait(1);
		}
	#/
}

/*
	Name: radio9_override
	Namespace: zm_temple_sq_brock
	Checksum: 0xCA01E1D0
	Offset: 0x3E8
	Size: 0x304
	Parameters: 1
	Flags: Linked
*/
function radio9_override(struct)
{
	self notify(#"overridden");
	self endon(#"death");
	self.trigger delete();
	self ghost();
	sidequest = level._zombie_sidequests["sq"];
	if(sidequest.num_reps >= 3)
	{
		return;
	}
	level waittill(#"picked_up");
	level waittill(#"flush_done");
	self show();
	target = struct.target;
	while(isdefined(target))
	{
		struct = struct::get(target, "targetname");
		time = struct.script_float;
		if(!isdefined(time))
		{
			time = 1;
		}
		self moveto(struct.origin, time, time / 10);
		self waittill(#"movedone");
		target = struct.target;
	}
	self.trigger = spawn("trigger_radius_use", self.origin + vectorscale((0, 0, 1), 12), 0, 64, 72);
	self.trigger triggerignoreteam();
	self.trigger.radius = 64;
	self.trigger.height = 72;
	self.trigger setcursorhint("HINT_NOICON");
	self.trigger.owner_ent = self;
	self.trigger thread trig_thread();
	self waittill(#"triggered");
	snd = "vox_radio_egg_" + (self.script_int - 1);
	self playsound(snd);
	self playloopsound("vox_radio_egg_snapshot", 1);
	wait(self.manual_wait);
	self stoploopsound(1);
	level flag::set("radio_9_played");
}

/*
	Name: radio7_override
	Namespace: zm_temple_sq_brock
	Checksum: 0xAF8CD1C8
	Offset: 0x6F8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function radio7_override(struct)
{
	self endon(#"death");
	self waittill(#"triggered");
	level flag::set("radio_7_played");
}

/*
	Name: radio4_override
	Namespace: zm_temple_sq_brock
	Checksum: 0x7F699553
	Offset: 0x748
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function radio4_override(struct)
{
	self endon(#"death");
	self waittill(#"triggered");
	level flag::set("radio_4_played");
}

/*
	Name: radio2_override
	Namespace: zm_temple_sq_brock
	Checksum: 0x62D263E3
	Offset: 0x798
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function radio2_override(struct)
{
	self endon(#"death");
	self notify(#"overridden");
	self waittill(#"triggered");
	var_8e0fe378 = level._player_who_pressed_the_switch.characterindex;
	if(!isdefined(var_8e0fe378))
	{
		var_8e0fe378 = 0;
	}
	var_bc7547cb = "a";
	switch(var_8e0fe378)
	{
		case 0:
		{
			var_bc7547cb = "a";
			break;
		}
		case 1:
		{
			var_bc7547cb = "b";
			break;
		}
		case 2:
		{
			var_bc7547cb = "d";
			break;
		}
		case 3:
		{
			var_bc7547cb = "c";
			break;
		}
	}
	snd = (("vox_radio_egg_" + (self.script_int - 1)) + "") + var_bc7547cb;
	self playsoundwithnotify(snd, "radiodone");
	self playloopsound("vox_radio_egg_snapshot", 1);
	self waittill(#"radiodone");
	self stoploopsound(1);
}

/*
	Name: radio_thread
	Namespace: zm_temple_sq_brock
	Checksum: 0xEBE5CDEF
	Offset: 0x928
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function radio_thread()
{
	self endon(#"death");
	self endon(#"overridden");
	self thread radio_debug();
	self waittill(#"triggered");
	snd = "vox_radio_egg_" + (self.script_int - 1);
	self playsound(snd);
	self playloopsound("vox_radio_egg_snapshot", 1);
	wait(self.manual_wait);
	self stoploopsound(1);
}

/*
	Name: create_radio
	Namespace: zm_temple_sq_brock
	Checksum: 0x87564AF8
	Offset: 0x9E8
	Size: 0x2C8
	Parameters: 2
	Flags: Linked
*/
function create_radio(radio_num, thread_func)
{
	delete_radio();
	radio_struct = undefined;
	for(i = 0; i < level._radio_structs.size; i++)
	{
		if(level._radio_structs[i].script_int == radio_num)
		{
			radio_struct = level._radio_structs[i];
			break;
		}
	}
	if(!isdefined(radio_struct))
	{
		/#
			println("" + radio_num);
		#/
		return;
	}
	radio = spawn("script_model", radio_struct.origin);
	radio.angles = radio_struct.angles;
	radio setmodel("p7_zm_sha_recorder_digital");
	radio.script_int = radio_struct.script_int;
	radio.script_noteworthy = radio_struct.script_noteworthy;
	radio set_manual_wait_time(radio_num);
	radio.trigger = spawn("trigger_radius_use", radio.origin + vectorscale((0, 0, 1), 12), 0, 64, 72);
	radio.trigger triggerignoreteam();
	radio.trigger.radius = 64;
	radio.trigger.height = 72;
	radio.trigger setcursorhint("HINT_NOICON");
	radio.trigger.owner_ent = radio;
	radio.trigger thread trig_thread();
	radio thread radio_thread();
	if(isdefined(thread_func))
	{
		radio thread [[thread_func]](radio_struct);
	}
	level._active_sq_radio = radio;
}

/*
	Name: set_manual_wait_time
	Namespace: zm_temple_sq_brock
	Checksum: 0xCE6D9FCC
	Offset: 0xCB8
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function set_manual_wait_time(num = 1)
{
	waittime = 45;
	switch(num)
	{
		case 1:
		{
			waittime = 113;
			break;
		}
		case 2:
		{
			waittime = 95;
			break;
		}
		case 3:
		{
			waittime = 20;
			break;
		}
		case 4:
		{
			waittime = 58;
			break;
		}
		case 5:
		{
			waittime = 74;
			break;
		}
		case 6:
		{
			waittime = 35;
			break;
		}
		case 7:
		{
			waittime = 40;
			break;
		}
		case 8:
		{
			waittime = 39;
			break;
		}
		case 9:
		{
			waittime = 76;
			break;
		}
	}
	self.manual_wait = waittime;
}

