// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;

#namespace exploder;

/*
	Name: __init__sytem__
	Namespace: exploder
	Checksum: 0xFB0C9846
	Offset: 0x2E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("exploder", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: exploder
	Checksum: 0xD8E5AFEF
	Offset: 0x328
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(sessionmodeiscampaigngame())
	{
		callback::on_localclient_connect(&player_init);
	}
}

/*
	Name: player_init
	Namespace: exploder
	Checksum: 0x41006843
	Offset: 0x368
	Size: 0xC24
	Parameters: 1
	Flags: Linked
*/
function player_init(clientnum)
{
	script_exploders = [];
	ents = struct::get_array("script_brushmodel", "classname");
	smodels = struct::get_array("script_model", "classname");
	for(i = 0; i < smodels.size; i++)
	{
		ents[ents.size] = smodels[i];
	}
	for(i = 0; i < ents.size; i++)
	{
		if(isdefined(ents[i].script_prefab_exploder))
		{
			ents[i].script_exploder = ents[i].script_prefab_exploder;
		}
	}
	potentialexploders = struct::get_array("script_brushmodel", "classname");
	for(i = 0; i < potentialexploders.size; i++)
	{
		if(isdefined(potentialexploders[i].script_prefab_exploder))
		{
			potentialexploders[i].script_exploder = potentialexploders[i].script_prefab_exploder;
		}
		if(isdefined(potentialexploders[i].script_exploder))
		{
			script_exploders[script_exploders.size] = potentialexploders[i];
		}
	}
	potentialexploders = struct::get_array("script_model", "classname");
	for(i = 0; i < potentialexploders.size; i++)
	{
		if(isdefined(potentialexploders[i].script_prefab_exploder))
		{
			potentialexploders[i].script_exploder = potentialexploders[i].script_prefab_exploder;
		}
		if(isdefined(potentialexploders[i].script_exploder))
		{
			script_exploders[script_exploders.size] = potentialexploders[i];
		}
	}
	for(i = 0; i < level.struct.size; i++)
	{
		if(isdefined(level.struct[i].script_prefab_exploder))
		{
			level.struct[i].script_exploder = level.struct[i].script_prefab_exploder;
		}
		if(isdefined(level.struct[i].script_exploder))
		{
			script_exploders[script_exploders.size] = level.struct[i];
		}
	}
	if(!isdefined(level.createfxent))
	{
		level.createfxent = [];
	}
	acceptabletargetnames = [];
	acceptabletargetnames["exploderchunk visible"] = 1;
	acceptabletargetnames["exploderchunk"] = 1;
	acceptabletargetnames["exploder"] = 1;
	exploder_id = 1;
	for(i = 0; i < script_exploders.size; i++)
	{
		exploder = script_exploders[i];
		ent = createexploder(exploder.script_fxid);
		ent.v = [];
		ent.v["origin"] = exploder.origin;
		ent.v["angles"] = exploder.angles;
		ent.v["delay"] = exploder.script_delay;
		ent.v["firefx"] = exploder.script_firefx;
		ent.v["firefxdelay"] = exploder.script_firefxdelay;
		ent.v["firefxsound"] = exploder.script_firefxsound;
		ent.v["firefxtimeout"] = exploder.script_firefxtimeout;
		ent.v["trailfx"] = exploder.script_trailfx;
		ent.v["trailfxtag"] = exploder.script_trailfxtag;
		ent.v["trailfxdelay"] = exploder.script_trailfxdelay;
		ent.v["trailfxsound"] = exploder.script_trailfxsound;
		ent.v["trailfxtimeout"] = exploder.script_firefxtimeout;
		ent.v["earthquake"] = exploder.script_earthquake;
		ent.v["rumble"] = exploder.script_rumble;
		ent.v["damage"] = exploder.script_damage;
		ent.v["damage_radius"] = exploder.script_radius;
		ent.v["repeat"] = exploder.script_repeat;
		ent.v["delay_min"] = exploder.script_delay_min;
		ent.v["delay_max"] = exploder.script_delay_max;
		ent.v["target"] = exploder.target;
		ent.v["ender"] = exploder.script_ender;
		ent.v["physics"] = exploder.script_physics;
		ent.v["type"] = "exploder";
		if(!isdefined(exploder.script_fxid))
		{
			ent.v["fxid"] = "No FX";
		}
		else
		{
			ent.v["fxid"] = exploder.script_fxid;
		}
		ent.v["exploder"] = exploder.script_exploder;
		if(!isdefined(ent.v["delay"]))
		{
			ent.v["delay"] = 0;
		}
		if(isdefined(exploder.script_sound))
		{
			ent.v["soundalias"] = exploder.script_sound;
		}
		else if(ent.v["fxid"] != "No FX")
		{
			if(isdefined(level.scr_sound) && isdefined(level.scr_sound[ent.v["fxid"]]))
			{
				ent.v["soundalias"] = level.scr_sound[ent.v["fxid"]];
			}
		}
		fixup_set = 0;
		if(isdefined(ent.v["target"]))
		{
			ent.needs_fixup = exploder_id;
			exploder_id++;
			fixup_set = 1;
			temp_ent = struct::get(ent.v["target"], "targetname");
			if(isdefined(temp_ent))
			{
				org = temp_ent.origin;
			}
			if(isdefined(org))
			{
				ent.v["angles"] = vectortoangles(org - ent.v["origin"]);
			}
			if(isdefined(ent.v["angles"]))
			{
				ent fx::set_forward_and_up_vectors();
			}
		}
		if(isdefined(exploder.classname) && exploder.classname == "script_brushmodel" || isdefined(exploder.model))
		{
			ent.model = exploder;
			if(fixup_set == 0)
			{
				ent.needs_fixup = exploder_id;
				exploder_id++;
			}
		}
		if(isdefined(exploder.targetname) && isdefined(acceptabletargetnames[exploder.targetname]))
		{
			ent.v["exploder_type"] = exploder.targetname;
			continue;
		}
		ent.v["exploder_type"] = "normal";
	}
	level.createfxexploders = [];
	for(i = 0; i < level.createfxent.size; i++)
	{
		ent = level.createfxent[i];
		if(ent.v["type"] != "exploder")
		{
			continue;
		}
		ent.v["exploder_id"] = getexploderid(ent);
		if(!isdefined(level.createfxexploders[ent.v["exploder"]]))
		{
			level.createfxexploders[ent.v["exploder"]] = [];
		}
		level.createfxexploders[ent.v["exploder"]][level.createfxexploders[ent.v["exploder"]].size] = ent;
	}
	reportexploderids();
}

/*
	Name: getexploderid
	Namespace: exploder
	Checksum: 0x6418F9DE
	Offset: 0xF98
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function getexploderid(ent)
{
	if(!isdefined(level._exploder_ids))
	{
		level._exploder_ids = [];
		level._exploder_id = 1;
	}
	if(!isdefined(level._exploder_ids[ent.v["exploder"]]))
	{
		level._exploder_ids[ent.v["exploder"]] = level._exploder_id;
		level._exploder_id++;
	}
	return level._exploder_ids[ent.v["exploder"]];
}

/*
	Name: reportexploderids
	Namespace: exploder
	Checksum: 0x8C320123
	Offset: 0x1040
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function reportexploderids()
{
	if(!isdefined(level._exploder_ids))
	{
		return;
	}
	keys = getarraykeys(level._exploder_ids);
}

/*
	Name: exploder
	Namespace: exploder
	Checksum: 0x4A12393A
	Offset: 0x1080
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function exploder(exploder_id, n_localclientnumber)
{
	if(isint(exploder_id))
	{
		activate_exploder(exploder_id);
	}
	else
	{
		activate_radiant_exploder(exploder_id, n_localclientnumber);
	}
}

/*
	Name: activate_exploder
	Namespace: exploder
	Checksum: 0x6D5F153C
	Offset: 0x10F0
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function activate_exploder(num)
{
	num = int(num);
	if(isdefined(level.createfxexploders) && isdefined(level.createfxexploders[num]))
	{
		for(i = 0; i < level.createfxexploders[num].size; i++)
		{
			level.createfxexploders[num][i] activate_individual_exploder();
		}
	}
	if(exploder_is_lightning_exploder(num))
	{
		if(isdefined(level.lightningnormalfunc) && isdefined(level.lightningflashfunc))
		{
			thread fx::lightning(level.lightningnormalfunc, level.lightningflashfunc);
		}
	}
}

/*
	Name: activate_individual_exploder
	Namespace: exploder
	Checksum: 0x18524AF9
	Offset: 0x11F0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function activate_individual_exploder()
{
	if(!isdefined(self.v["angles"]))
	{
		self.v["angles"] = (0, 0, 0);
		self fx::set_forward_and_up_vectors();
	}
	if(isdefined(self.v["firefx"]))
	{
		self thread fire_effect();
	}
	if(isdefined(self.v["fxid"]) && self.v["fxid"] != "No FX")
	{
		self thread cannon_effect();
	}
	if(isdefined(self.v["earthquake"]))
	{
		self thread exploder_earthquake();
	}
}

/*
	Name: activate_radiant_exploder
	Namespace: exploder
	Checksum: 0xA54FCEF2
	Offset: 0x12D8
	Size: 0x86
	Parameters: 2
	Flags: Linked
*/
function activate_radiant_exploder(string, n_localclientnumber)
{
	if(isdefined(n_localclientnumber))
	{
		playradiantexploder(n_localclientnumber, string);
	}
	else
	{
		for(localclientnum = 0; localclientnum < level.localplayers.size; localclientnum++)
		{
			playradiantexploder(localclientnum, string);
		}
	}
}

/*
	Name: stop_exploder
	Namespace: exploder
	Checksum: 0xE5868DCF
	Offset: 0x1368
	Size: 0x1D6
	Parameters: 2
	Flags: Linked
*/
function stop_exploder(exploder_id, n_localclientnumber)
{
	if(isstring(exploder_id))
	{
		if(isdefined(n_localclientnumber))
		{
			stopradiantexploder(n_localclientnumber, exploder_id);
		}
		else
		{
			for(localclientnum = 0; localclientnum < level.localplayers.size; localclientnum++)
			{
				stopradiantexploder(localclientnum, exploder_id);
			}
		}
		return;
	}
	num = int(exploder_id);
	if(isdefined(level.createfxexploders[exploder_id]))
	{
		for(i = 0; i < level.createfxexploders[exploder_id].size; i++)
		{
			ent = level.createfxexploders[exploder_id][i];
			if(isdefined(ent.loopfx))
			{
				for(j = 0; j < ent.loopfx.size; j++)
				{
					if(isdefined(ent.loopfx[j]))
					{
						stopfx(j, ent.loopfx[j]);
						ent.loopfx[j] = undefined;
					}
				}
				ent.loopfx = [];
			}
		}
	}
}

/*
	Name: kill_exploder
	Namespace: exploder
	Checksum: 0x17D07FD4
	Offset: 0x1548
	Size: 0x94
	Parameters: 1
	Flags: None
*/
function kill_exploder(exploder_id)
{
	if(isstring(exploder_id))
	{
		for(localclientnum = 0; localclientnum < level.localplayers.size; localclientnum++)
		{
			killradiantexploder(localclientnum, exploder_id);
		}
		return;
	}
	/#
		assertmsg("" + exploder_id);
	#/
}

/*
	Name: exploder_delay
	Namespace: exploder
	Checksum: 0xDC3E1AE6
	Offset: 0x15E8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function exploder_delay()
{
	if(!isdefined(self.v["delay"]))
	{
		self.v["delay"] = 0;
	}
	min_delay = self.v["delay"];
	max_delay = self.v["delay"] + 0.001;
	if(isdefined(self.v["delay_min"]))
	{
		min_delay = self.v["delay_min"];
	}
	if(isdefined(self.v["delay_max"]))
	{
		max_delay = self.v["delay_max"];
	}
	if(min_delay > 0)
	{
		waitrealtime(randomfloatrange(min_delay, max_delay));
	}
}

/*
	Name: exploder_playsound
	Namespace: exploder
	Checksum: 0xEB00B34F
	Offset: 0x16F0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function exploder_playsound()
{
	if(!isdefined(self.v["soundalias"]) || self.v["soundalias"] == "nil")
	{
		return;
	}
	sound::play_in_space(0, self.v["soundalias"], self.v["origin"]);
}

/*
	Name: exploder_earthquake
	Namespace: exploder
	Checksum: 0xE92537B5
	Offset: 0x1768
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function exploder_earthquake()
{
	self exploder_delay();
	eq = level.earthquake[self.v["earthquake"]];
	if(isdefined(eq))
	{
		getlocalplayers()[0] earthquake(eq["magnitude"], eq["duration"], self.v["origin"], eq["radius"]);
	}
}

/*
	Name: exploder_is_lightning_exploder
	Namespace: exploder
	Checksum: 0x5679A701
	Offset: 0x1820
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function exploder_is_lightning_exploder(num)
{
	if(isdefined(level.lightningexploder))
	{
		for(i = 0; i < level.lightningexploder.size; i++)
		{
			if(level.lightningexploder[i] == num)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: stoplightloopexploder
	Namespace: exploder
	Checksum: 0x82F5049D
	Offset: 0x1890
	Size: 0x1A2
	Parameters: 1
	Flags: None
*/
function stoplightloopexploder(exploderindex)
{
	num = int(exploderindex);
	if(isdefined(level.createfxexploders[num]))
	{
		for(i = 0; i < level.createfxexploders[num].size; i++)
		{
			ent = level.createfxexploders[num][i];
			if(!isdefined(ent.looperfx))
			{
				ent.looperfx = [];
			}
			for(clientnum = 0; clientnum < level.max_local_clients; clientnum++)
			{
				if(localclientactive(clientnum))
				{
					if(isdefined(ent.looperfx[clientnum]))
					{
						for(looperfxcount = 0; looperfxcount < ent.looperfx[clientnum].size; looperfxcount++)
						{
							deletefx(clientnum, ent.looperfx[clientnum][looperfxcount]);
						}
					}
				}
				ent.looperfx[clientnum] = [];
			}
			ent.looperfx = [];
		}
	}
}

/*
	Name: playlightloopexploder
	Namespace: exploder
	Checksum: 0x32E63AF2
	Offset: 0x1A40
	Size: 0x170
	Parameters: 1
	Flags: Linked
*/
function playlightloopexploder(exploderindex)
{
	num = int(exploderindex);
	if(isdefined(level.createfxexploders[num]))
	{
		for(i = 0; i < level.createfxexploders[num].size; i++)
		{
			ent = level.createfxexploders[num][i];
			if(!isdefined(ent.looperfx))
			{
				ent.looperfx = [];
			}
			for(clientnum = 0; clientnum < level.max_local_clients; clientnum++)
			{
				if(localclientactive(clientnum))
				{
					if(!isdefined(ent.looperfx[clientnum]))
					{
						ent.looperfx[clientnum] = [];
					}
					ent.looperfx[clientnum][ent.looperfx[clientnum].size] = ent playexploderfx(clientnum);
				}
			}
		}
	}
}

/*
	Name: createexploder
	Namespace: exploder
	Checksum: 0x992D271E
	Offset: 0x1BB8
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function createexploder(fxid)
{
	ent = fx::create_effect("exploder", fxid);
	ent.v["delay"] = 0;
	ent.v["exploder_type"] = "normal";
	return ent;
}

/*
	Name: cannon_effect
	Namespace: exploder
	Checksum: 0xB1CCC439
	Offset: 0x1C38
	Size: 0x2D4
	Parameters: 0
	Flags: Linked
*/
function cannon_effect()
{
	if(isdefined(self.v["repeat"]))
	{
		for(i = 0; i < self.v["repeat"]; i++)
		{
			players = getlocalplayers();
			for(player = 0; player < players.size; player++)
			{
				playfx(player, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"]);
			}
			self exploder_delay();
		}
		return;
	}
	self exploder_delay();
	players = getlocalplayers();
	if(isdefined(self.loopfx))
	{
		for(i = 0; i < self.loopfx.size; i++)
		{
			stopfx(i, self.loopfx[i]);
		}
		self.loopfx = [];
	}
	if(!isdefined(self.loopfx))
	{
		self.loopfx = [];
	}
	if(!isdefined(level._effect[self.v["fxid"]]))
	{
		/#
			assertmsg(("" + self.v[""]) + "");
		#/
		return;
	}
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(self.v["fxid"]))
		{
			self.loopfx[i] = playfx(i, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"]);
		}
	}
	self exploder_playsound();
}

/*
	Name: fire_effect
	Namespace: exploder
	Checksum: 0x753B1149
	Offset: 0x1F18
	Size: 0x266
	Parameters: 0
	Flags: Linked
*/
function fire_effect()
{
	forward = self.v["forward"];
	if(!isdefined(forward))
	{
		forward = anglestoforward(self.v["angles"]);
	}
	up = self.v["up"];
	if(!isdefined(up))
	{
		up = anglestoup(self.v["angles"]);
	}
	firefxsound = self.v["firefxsound"];
	origin = self.v["origin"];
	firefx = self.v["firefx"];
	ender = self.v["ender"];
	if(!isdefined(ender))
	{
		ender = "createfx_effectStopper";
	}
	firefxdelay = 0.5;
	if(isdefined(self.v["firefxdelay"]))
	{
		firefxdelay = self.v["firefxdelay"];
	}
	self exploder_delay();
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(firefxsound))
		{
			level thread sound::loop_fx_sound(i, firefxsound, origin, ender);
		}
		playfx(i, level._effect[firefx], self.v["origin"], forward, up, 0, self.v["primlightfrac"], self.v["lightoriginoffs"]);
	}
}

/*
	Name: playexploderfx
	Namespace: exploder
	Checksum: 0x618CEF46
	Offset: 0x2188
	Size: 0xDA
	Parameters: 1
	Flags: Linked
*/
function playexploderfx(clientnum)
{
	/#
		if(!isdefined(self.v[""]))
		{
			return;
		}
		if(!isdefined(self.v[""]))
		{
			return;
		}
		if(!isdefined(self.v[""]))
		{
			return;
		}
	#/
	return playfx(clientnum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], 0, self.v["primlightfrac"], self.v["lightoriginoffs"]);
}

/*
	Name: stop_after_duration
	Namespace: exploder
	Checksum: 0xF119375B
	Offset: 0x2270
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function stop_after_duration(name, duration)
{
	wait(duration);
	stop_exploder(name);
}

/*
	Name: exploder_duration
	Namespace: exploder
	Checksum: 0xB6CD25A1
	Offset: 0x22B0
	Size: 0x5C
	Parameters: 2
	Flags: None
*/
function exploder_duration(name, duration)
{
	if(!(isdefined(duration) && duration))
	{
		return;
	}
	exploder(name);
	level thread stop_after_duration(name, duration);
}

