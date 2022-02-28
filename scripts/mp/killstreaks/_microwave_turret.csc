// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("mp_microwaveturret");

#namespace microwave_turret;

/*
	Name: __init__sytem__
	Namespace: microwave_turret
	Checksum: 0xD7D2C368
	Offset: 0x330
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("microwave_turret", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: microwave_turret
	Checksum: 0xCF9F7773
	Offset: 0x370
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("vehicle", "turret_microwave_open", 1, 1, "int", &microwave_open, 0, 0);
	clientfield::register("scriptmover", "turret_microwave_init", 1, 1, "int", &microwave_init_anim, 0, 0);
	clientfield::register("scriptmover", "turret_microwave_close", 1, 1, "int", &microwave_close_anim, 0, 0);
}

/*
	Name: turret_microwave_sounds
	Namespace: microwave_turret
	Checksum: 0xB1EDB07F
	Offset: 0x458
	Size: 0x82
	Parameters: 7
	Flags: None
*/
function turret_microwave_sounds(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self thread turret_microwave_sound_start(localclientnum);
	}
	else if(newval == 0)
	{
		self notify(#"sound_stop");
	}
}

/*
	Name: turret_microwave_sound_start
	Namespace: microwave_turret
	Checksum: 0xA607F580
	Offset: 0x4E8
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function turret_microwave_sound_start(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"sound_stop");
	if(isdefined(self.sound_loop_enabled) && self.sound_loop_enabled)
	{
		return;
	}
	self playsound(0, "wpn_micro_turret_start");
	wait(0.7);
	origin = self gettagorigin("tag_flash");
	angles = self gettagangles("tag_flash");
	forward = anglestoforward(angles);
	forward = vectorscale(forward, 750);
	trace = bullettrace(origin, origin + forward, 0, self);
	start = origin;
	end = trace["position"];
	self.microwave_audio_start = start;
	self.microwave_audio_end = end;
	self thread turret_microwave_sound_updater();
	if(!(isdefined(self.sound_loop_enabled) && self.sound_loop_enabled))
	{
		self.sound_loop_enabled = 1;
		soundlineemitter("wpn_micro_turret_loop", self.microwave_audio_start, self.microwave_audio_end);
		self thread turret_microwave_sound_off_waiter(localclientnum);
	}
}

/*
	Name: turret_microwave_sound_off_waiter
	Namespace: microwave_turret
	Checksum: 0x81BB1A26
	Offset: 0x6D0
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function turret_microwave_sound_off_waiter(localclientnum)
{
	msg = self util::waittill_any("sound_stop", "entityshutdown");
	if(msg === "sound_stop")
	{
		playsound(0, "wpn_micro_turret_stop", self.microwave_audio_start);
	}
	soundstoplineemitter("wpn_micro_turret_loop", self.microwave_audio_start, self.microwave_audio_end);
	if(isdefined(self))
	{
		self.sound_loop_enabled = 0;
	}
}

/*
	Name: turret_microwave_sound_updater
	Namespace: microwave_turret
	Checksum: 0x6E79F062
	Offset: 0x788
	Size: 0x1B0
	Parameters: 0
	Flags: Linked
*/
function turret_microwave_sound_updater()
{
	self endon(#"beam_stop");
	self endon(#"entityshutdown");
	while(true)
	{
		origin = self gettagorigin("tag_flash");
		if(origin[0] != self.microwave_audio_start[0] || origin[1] != self.microwave_audio_start[1] || origin[2] != self.microwave_audio_start[2])
		{
			previousstart = self.microwave_audio_start;
			previousend = self.microwave_audio_end;
			angles = self gettagangles("tag_flash");
			forward = anglestoforward(angles);
			forward = vectorscale(forward, 750);
			trace = bullettrace(origin, origin + forward, 0, self);
			self.microwave_audio_start = origin;
			self.microwave_audio_end = trace["position"];
			soundupdatelineemitter("wpn_micro_turret_loop", previousstart, previousend, self.microwave_audio_start, self.microwave_audio_end);
		}
		wait(0.1);
	}
}

/*
	Name: microwave_init_anim
	Namespace: microwave_turret
	Checksum: 0x9B853A42
	Offset: 0x940
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function microwave_init_anim(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	self useanimtree($mp_microwaveturret);
	self setanimrestart(%mp_microwaveturret::o_turret_guardian_close, 1, 0, 1);
	self setanimtime(%mp_microwaveturret::o_turret_guardian_close, 1);
}

/*
	Name: microwave_open
	Namespace: microwave_turret
	Checksum: 0xD2BA839F
	Offset: 0xA10
	Size: 0x174
	Parameters: 7
	Flags: Linked
*/
function microwave_open(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		self useanimtree($mp_microwaveturret);
		self setanim(%mp_microwaveturret::o_turret_guardian_open, 0);
		self setanimrestart(%mp_microwaveturret::o_turret_guardian_close, 1, 0, 1);
		self notify(#"beam_stop");
		self notify(#"sound_stop");
		return;
	}
	self useanimtree($mp_microwaveturret);
	self setanim(%mp_microwaveturret::o_turret_guardian_close, 0);
	self setanimrestart(%mp_microwaveturret::o_turret_guardian_open, 1, 0, 1);
	self thread startmicrowavefx(localclientnum);
}

/*
	Name: microwave_close_anim
	Namespace: microwave_turret
	Checksum: 0xBB798C7F
	Offset: 0xB90
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function microwave_close_anim(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	self useanimtree($mp_microwaveturret);
	self setanimrestart(%mp_microwaveturret::o_turret_guardian_close, 1, 0, 1);
}

/*
	Name: debug_trace
	Namespace: microwave_turret
	Checksum: 0xF6E859B
	Offset: 0xC38
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function debug_trace(origin, trace)
{
	/#
		if(trace[""] < 1)
		{
			color = (0.95, 0.05, 0.05);
		}
		else
		{
			color = (0.05, 0.95, 0.05);
		}
		sphere(trace[""], 5, color, 0.75, 1, 10, 100);
		util::debug_line(origin, trace[""], color, 100);
	#/
}

/*
	Name: startmicrowavefx
	Namespace: microwave_turret
	Checksum: 0xF33C3A60
	Offset: 0xD28
	Size: 0x558
	Parameters: 1
	Flags: Linked
*/
function startmicrowavefx(localclientnum)
{
	turret = self;
	turret endon(#"entityshutdown");
	turret endon(#"beam_stop");
	turret.should_update_fx = 1;
	self thread turret_microwave_sound_start(localclientnum);
	origin = turret gettagorigin("tag_flash");
	angles = turret gettagangles("tag_flash");
	microwavefxent = spawn(localclientnum, origin, "script_model");
	microwavefxent setmodel("tag_microwavefx");
	microwavefxent.angles = angles;
	microwavefxent linkto(turret, "tag_flash");
	microwavefxent.fxhandles = [];
	microwavefxent.fxnames = [];
	microwavefxent.fxhashs = [];
	self thread updatemicrowaveaim(microwavefxent);
	self thread cleanupfx(localclientnum, microwavefxent);
	wait(0.3);
	while(true)
	{
		/#
			if(getdvarint(""))
			{
				turret.should_update_fx = 1;
				microwavefxent.fxhashs[""] = 0;
			}
		#/
		if(turret.should_update_fx == 0)
		{
			wait(1);
			continue;
		}
		if(isdefined(level.last_microwave_turret_fx_trace) && level.last_microwave_turret_fx_trace == gettime())
		{
			wait(0.05);
			continue;
		}
		angles = turret gettagangles("tag_flash");
		origin = turret gettagorigin("tag_flash");
		forward = anglestoforward(angles);
		forward = vectorscale(forward, 750 + 40);
		forwardright = anglestoforward(angles - (0, 55 / 3, 0));
		forwardright = vectorscale(forwardright, 750 + 40);
		forwardleft = anglestoforward(angles + (0, 55 / 3, 0));
		forwardleft = vectorscale(forwardleft, 750 + 40);
		trace = bullettrace(origin, origin + forward, 0, turret);
		traceright = bullettrace(origin, origin + forwardright, 0, turret);
		traceleft = bullettrace(origin, origin + forwardleft, 0, turret);
		/#
			if(getdvarint(""))
			{
				debug_trace(origin, trace);
				debug_trace(origin, traceright);
				debug_trace(origin, traceleft);
			}
		#/
		need_to_rebuild = microwavefxent microwavefxhash(trace, origin, "center");
		need_to_rebuild = need_to_rebuild | microwavefxent microwavefxhash(traceright, origin, "right");
		need_to_rebuild = need_to_rebuild | microwavefxent microwavefxhash(traceleft, origin, "left");
		level.last_microwave_turret_fx_trace = gettime();
		if(!need_to_rebuild)
		{
			wait(1);
			continue;
		}
		wait(0.1);
		microwavefxent playmicrowavefx(localclientnum, trace, traceright, traceleft, origin);
		turret.should_update_fx = 0;
		wait(1);
	}
}

/*
	Name: updatemicrowaveaim
	Namespace: microwave_turret
	Checksum: 0x68430413
	Offset: 0x1288
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function updatemicrowaveaim(microwavefxent)
{
	turret = self;
	turret endon(#"entityshutdown");
	turret endon(#"beam_stop");
	last_angles = turret gettagangles("tag_flash");
	while(true)
	{
		angles = turret gettagangles("tag_flash");
		if(last_angles != angles)
		{
			turret.should_update_fx = 1;
			last_angles = angles;
		}
		wait(0.1);
	}
}

/*
	Name: microwavefxhash
	Namespace: microwave_turret
	Checksum: 0x57537D11
	Offset: 0x1358
	Size: 0x1B4
	Parameters: 3
	Flags: Linked
*/
function microwavefxhash(trace, origin, name)
{
	hash = 0;
	counter = 2;
	for(i = 0; i < 5; i++)
	{
		endofhalffxsq = ((i * 150) + 125) * ((i * 150) + 125);
		endoffullfxsq = ((i * 150) + 200) * ((i * 150) + 200);
		tracedistsq = distancesquared(origin, trace["position"]);
		if(tracedistsq >= endofhalffxsq || i == 0)
		{
			if(tracedistsq < endoffullfxsq)
			{
				hash = hash + 1;
			}
			else
			{
				hash = hash + counter;
			}
		}
		counter = counter * 2;
	}
	if(!isdefined(self.fxhashs[name]))
	{
		self.fxhashs[name] = 0;
	}
	last_hash = self.fxhashs[name];
	self.fxhashs[name] = hash;
	return last_hash != hash;
}

/*
	Name: cleanupfx
	Namespace: microwave_turret
	Checksum: 0xF5553194
	Offset: 0x1518
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function cleanupfx(localclientnum, microwavefxent)
{
	self util::waittill_any("entityshutdown", "beam_stop");
	foreach(handle in microwavefxent.fxhandles)
	{
		if(isdefined(handle))
		{
			stopfx(localclientnum, handle);
		}
	}
	microwavefxent delete();
}

/*
	Name: play_fx_on_tag
	Namespace: microwave_turret
	Checksum: 0x7047121F
	Offset: 0x1618
	Size: 0xA2
	Parameters: 3
	Flags: Linked
*/
function play_fx_on_tag(localclientnum, fxname, tag)
{
	if(!isdefined(self.fxhandles[tag]) || fxname != self.fxnames[tag])
	{
		stop_fx_on_tag(localclientnum, fxname, tag);
		self.fxnames[tag] = fxname;
		self.fxhandles[tag] = playfxontag(localclientnum, fxname, self, tag);
	}
}

/*
	Name: stop_fx_on_tag
	Namespace: microwave_turret
	Checksum: 0xD1259275
	Offset: 0x16C8
	Size: 0x6C
	Parameters: 3
	Flags: Linked
*/
function stop_fx_on_tag(localclientnum, fxname, tag)
{
	if(isdefined(self.fxhandles[tag]))
	{
		stopfx(localclientnum, self.fxhandles[tag]);
		self.fxhandles[tag] = undefined;
		self.fxnames[tag] = undefined;
	}
}

/*
	Name: render_debug_sphere
	Namespace: microwave_turret
	Checksum: 0x1BA56
	Offset: 0x1740
	Size: 0x94
	Parameters: 3
	Flags: Linked
*/
function render_debug_sphere(tag, color, fxname)
{
	/#
		if(getdvarint(""))
		{
			origin = self gettagorigin(tag);
			sphere(origin, 2, color, 0.75, 1, 10, 100);
		}
	#/
}

/*
	Name: stop_or_start_fx
	Namespace: microwave_turret
	Checksum: 0x530B1B3D
	Offset: 0x17E0
	Size: 0xEC
	Parameters: 4
	Flags: Linked
*/
function stop_or_start_fx(localclientnum, fxname, tag, start)
{
	if(start)
	{
		self play_fx_on_tag(localclientnum, fxname, tag);
		/#
			if(fxname == "")
			{
				render_debug_sphere(tag, vectorscale((1, 1, 0), 0.5), fxname);
			}
			else
			{
				render_debug_sphere(tag, (0, 1, 0), fxname);
			}
		#/
	}
	else
	{
		stop_fx_on_tag(localclientnum, fxname, tag);
		/#
			render_debug_sphere(tag, (1, 0, 0), fxname);
		#/
	}
}

/*
	Name: playmicrowavefx
	Namespace: microwave_turret
	Checksum: 0x8F3BDE0D
	Offset: 0x18D8
	Size: 0x568
	Parameters: 5
	Flags: Linked
*/
function playmicrowavefx(localclientnum, trace, traceright, traceleft, origin)
{
	rows = 5;
	for(i = 0; i < rows; i++)
	{
		endofhalffxsq = ((i * 150) + 125) * ((i * 150) + 125);
		endoffullfxsq = ((i * 150) + 200) * ((i * 150) + 200);
		tracedistsq = distancesquared(origin, trace["position"]);
		startfx = tracedistsq >= endofhalffxsq || i == 0;
		fxname = (tracedistsq < endoffullfxsq ? "killstreaks/fx_sg_distortion_cone_ash_sm" : "killstreaks/fx_sg_distortion_cone_ash");
		switch(i)
		{
			case 0:
			{
				self play_fx_on_tag(localclientnum, fxname, "tag_fx11");
				break;
			}
			case 1:
			{
				break;
			}
			case 2:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx32", startfx);
				break;
			}
			case 3:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx42", startfx);
				self stop_or_start_fx(localclientnum, fxname, "tag_fx43", startfx);
				break;
			}
			case 4:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx53", startfx);
				break;
			}
		}
		tracedistsq = distancesquared(origin, traceleft["position"]);
		startfx = tracedistsq >= endofhalffxsq;
		fxname = (tracedistsq < endoffullfxsq ? "killstreaks/fx_sg_distortion_cone_ash_sm" : "killstreaks/fx_sg_distortion_cone_ash");
		switch(i)
		{
			case 0:
			{
				break;
			}
			case 1:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx22", startfx);
				break;
			}
			case 2:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx33", startfx);
				break;
			}
			case 3:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx44", startfx);
				break;
			}
			case 4:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx54", startfx);
				self stop_or_start_fx(localclientnum, fxname, "tag_fx55", startfx);
				break;
			}
		}
		tracedistsq = distancesquared(origin, traceright["position"]);
		startfx = tracedistsq >= endofhalffxsq;
		fxname = (tracedistsq < endoffullfxsq ? "killstreaks/fx_sg_distortion_cone_ash_sm" : "killstreaks/fx_sg_distortion_cone_ash");
		switch(i)
		{
			case 0:
			{
				break;
			}
			case 1:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx21", startfx);
				break;
			}
			case 2:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx31", startfx);
				break;
			}
			case 3:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx41", startfx);
				break;
			}
			case 4:
			{
				self stop_or_start_fx(localclientnum, fxname, "tag_fx51", startfx);
				self stop_or_start_fx(localclientnum, fxname, "tag_fx52", startfx);
				break;
			}
		}
	}
}

