// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace fx;

/*
	Name: __init__sytem__
	Namespace: fx
	Checksum: 0x324888C6
	Offset: 0x1C8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("fx", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: fx
	Checksum: 0x8A558064
	Offset: 0x208
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_localclient_connect(&player_init);
}

/*
	Name: player_init
	Namespace: fx
	Checksum: 0x84565917
	Offset: 0x238
	Size: 0x258
	Parameters: 1
	Flags: Linked
*/
function player_init(clientnum)
{
	if(!isdefined(level.createfxent))
	{
		return;
	}
	creatingexploderarray = 0;
	if(!isdefined(level.createfxexploders))
	{
		creatingexploderarray = 1;
		level.createfxexploders = [];
	}
	for(i = 0; i < level.createfxent.size; i++)
	{
		ent = level.createfxent[i];
		if(!isdefined(level._createfxforwardandupset))
		{
			if(!isdefined(level._createfxforwardandupset))
			{
				ent set_forward_and_up_vectors();
			}
		}
		if(ent.v["type"] == "loopfx")
		{
			ent thread loop_thread(clientnum);
		}
		if(ent.v["type"] == "oneshotfx")
		{
			ent thread oneshot_thread(clientnum);
		}
		if(ent.v["type"] == "soundfx")
		{
			ent thread loop_sound(clientnum);
		}
		if(creatingexploderarray && ent.v["type"] == "exploder")
		{
			if(!isdefined(level.createfxexploders[ent.v["exploder"]]))
			{
				level.createfxexploders[ent.v["exploder"]] = [];
			}
			ent.v["exploder_id"] = exploder::getexploderid(ent);
			level.createfxexploders[ent.v["exploder"]][level.createfxexploders[ent.v["exploder"]].size] = ent;
		}
	}
	level._createfxforwardandupset = 1;
}

/*
	Name: validate
	Namespace: fx
	Checksum: 0x9D50E50D
	Offset: 0x498
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function validate(fxid, origin)
{
	/#
		if(!isdefined(level._effect[fxid]))
		{
			/#
				assertmsg((("" + fxid) + "") + origin);
			#/
		}
	#/
}

/*
	Name: create_loop_sound
	Namespace: fx
	Checksum: 0xE3213726
	Offset: 0x500
	Size: 0x10C
	Parameters: 0
	Flags: None
*/
function create_loop_sound()
{
	ent = spawnstruct();
	if(!isdefined(level.createfxent))
	{
		level.createfxent = [];
	}
	level.createfxent[level.createfxent.size] = ent;
	ent.v = [];
	ent.v["type"] = "soundfx";
	ent.v["fxid"] = "No FX";
	ent.v["soundalias"] = "nil";
	ent.v["angles"] = (0, 0, 0);
	ent.v["origin"] = (0, 0, 0);
	ent.drawn = 1;
	return ent;
}

/*
	Name: create_effect
	Namespace: fx
	Checksum: 0x5933BEFF
	Offset: 0x618
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function create_effect(type, fxid)
{
	ent = spawnstruct();
	if(!isdefined(level.createfxent))
	{
		level.createfxent = [];
	}
	level.createfxent[level.createfxent.size] = ent;
	ent.v = [];
	ent.v["type"] = type;
	ent.v["fxid"] = fxid;
	ent.v["angles"] = (0, 0, 0);
	ent.v["origin"] = (0, 0, 0);
	ent.drawn = 1;
	return ent;
}

/*
	Name: create_oneshot_effect
	Namespace: fx
	Checksum: 0x34FAADD4
	Offset: 0x718
	Size: 0x56
	Parameters: 1
	Flags: None
*/
function create_oneshot_effect(fxid)
{
	ent = create_effect("oneshotfx", fxid);
	ent.v["delay"] = -15;
	return ent;
}

/*
	Name: create_loop_effect
	Namespace: fx
	Checksum: 0x15C625AC
	Offset: 0x778
	Size: 0x5A
	Parameters: 1
	Flags: None
*/
function create_loop_effect(fxid)
{
	ent = create_effect("loopfx", fxid);
	ent.v["delay"] = 0.5;
	return ent;
}

/*
	Name: set_forward_and_up_vectors
	Namespace: fx
	Checksum: 0xB2A3D3DD
	Offset: 0x7E0
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function set_forward_and_up_vectors()
{
	self.v["up"] = anglestoup(self.v["angles"]);
	self.v["forward"] = anglestoforward(self.v["angles"]);
}

/*
	Name: oneshot_thread
	Namespace: fx
	Checksum: 0xAE8EBC44
	Offset: 0x860
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function oneshot_thread(clientnum)
{
	if(self.v["delay"] > 0)
	{
		waitrealtime(self.v["delay"]);
	}
	create_trigger(clientnum);
}

/*
	Name: report_num_effects
	Namespace: fx
	Checksum: 0xEB8FACF
	Offset: 0x8B8
	Size: 0x8
	Parameters: 0
	Flags: None
*/
function report_num_effects()
{
	/#
	#/
}

/*
	Name: loop_sound
	Namespace: fx
	Checksum: 0x4DCBE226
	Offset: 0x8C8
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function loop_sound(clientnum)
{
	if(clientnum != 0)
	{
		return;
	}
	self notify(#"stop_loop");
	if(isdefined(self.v["soundalias"]) && self.v["soundalias"] != "nil")
	{
		if(isdefined(self.v["stopable"]) && self.v["stopable"])
		{
			thread sound::loop_fx_sound(clientnum, self.v["soundalias"], self.v["origin"], "stop_loop");
		}
		else
		{
			thread sound::loop_fx_sound(clientnum, self.v["soundalias"], self.v["origin"]);
		}
	}
}

/*
	Name: lightning
	Namespace: fx
	Checksum: 0x4B028E2C
	Offset: 0x9E0
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function lightning(normalfunc, flashfunc)
{
	[[flashfunc]]();
	waitrealtime(randomfloatrange(0.05, 0.1));
	[[normalfunc]]();
}

/*
	Name: loop_thread
	Namespace: fx
	Checksum: 0x4B1C7F3E
	Offset: 0xA38
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function loop_thread(clientnum)
{
	if(isdefined(self.fxstart))
	{
		level waittill("start fx" + self.fxstart);
	}
	while(true)
	{
		create_looper(clientnum);
		if(isdefined(self.timeout))
		{
			thread loop_stop(clientnum, self.timeout);
		}
		if(isdefined(self.fxstop))
		{
			level waittill("stop fx" + self.fxstop);
		}
		else
		{
			return;
		}
		if(isdefined(self.looperfx))
		{
			deletefx(clientnum, self.looperfx);
		}
		if(isdefined(self.fxstart))
		{
			level waittill("start fx" + self.fxstart);
		}
		else
		{
			return;
		}
	}
}

/*
	Name: loop_stop
	Namespace: fx
	Checksum: 0x7638ACE2
	Offset: 0xB30
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function loop_stop(clientnum, timeout)
{
	self endon(#"death");
	wait(timeout);
	if(isdefined(self.looper))
	{
		deletefx(clientnum, self.looper);
	}
}

/*
	Name: create_looper
	Namespace: fx
	Checksum: 0x7C655DB0
	Offset: 0xB88
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function create_looper(clientnum)
{
	self thread loop(clientnum);
	loop_sound(clientnum);
}

/*
	Name: loop
	Namespace: fx
	Checksum: 0xF1CD1AA5
	Offset: 0xBD0
	Size: 0x1D0
	Parameters: 1
	Flags: Linked
*/
function loop(clientnum)
{
	validate(self.v["fxid"], self.v["origin"]);
	self.looperfx = playfx(clientnum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], self.v["delay"], self.v["primlightfrac"], self.v["lightoriginoffs"]);
	while(true)
	{
		if(isdefined(self.v["delay"]))
		{
			waitrealtime(self.v["delay"]);
		}
		while(isfxplaying(clientnum, self.looperfx))
		{
			wait(0.25);
		}
		self.looperfx = playfx(clientnum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], 0, self.v["primlightfrac"], self.v["lightoriginoffs"]);
	}
}

/*
	Name: create_trigger
	Namespace: fx
	Checksum: 0x78622461
	Offset: 0xDA8
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function create_trigger(clientnum)
{
	validate(self.v["fxid"], self.v["origin"]);
	/#
		if(getdvarint("") > 0)
		{
			println("" + self.v[""]);
		}
	#/
	self.looperfx = playfx(clientnum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], self.v["delay"], self.v["primlightfrac"], self.v["lightoriginoffs"]);
	loop_sound(clientnum);
}

/*
	Name: blinky_light
	Namespace: fx
	Checksum: 0xA68D7FB0
	Offset: 0xEF8
	Size: 0x150
	Parameters: 4
	Flags: None
*/
function blinky_light(localclientnum, tagname, friendlyfx, enemyfx)
{
	self endon(#"entityshutdown");
	self endon(#"stop_blinky_light");
	self.lighttagname = tagname;
	self util::waittill_dobj(localclientnum);
	self thread blinky_emp_wait(localclientnum);
	while(true)
	{
		if(isdefined(self.stunned) && self.stunned)
		{
			wait(0.1);
			continue;
		}
		if(isdefined(self))
		{
			if(util::friend_not_foe(localclientnum))
			{
				self.blinkylightfx = playfxontag(localclientnum, friendlyfx, self, self.lighttagname);
			}
			else
			{
				self.blinkylightfx = playfxontag(localclientnum, enemyfx, self, self.lighttagname);
			}
		}
		util::server_wait(localclientnum, 0.5, 0.016);
	}
}

/*
	Name: stop_blinky_light
	Namespace: fx
	Checksum: 0xFE4BAD2E
	Offset: 0x1050
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function stop_blinky_light(localclientnum)
{
	self notify(#"stop_blinky_light");
	if(!isdefined(self.blinkylightfx))
	{
		return;
	}
	stopfx(localclientnum, self.blinkylightfx);
	self.blinkylightfx = undefined;
}

/*
	Name: blinky_emp_wait
	Namespace: fx
	Checksum: 0x28BF7038
	Offset: 0x10A8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function blinky_emp_wait(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"stop_blinky_light");
	self waittill(#"emp");
	self stop_blinky_light(localclientnum);
}

