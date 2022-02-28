// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace audio;

/*
	Name: __init__sytem__
	Namespace: audio
	Checksum: 0x54EB2526
	Offset: 0x8C0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: audio
	Checksum: 0x6C48B937
	Offset: 0x900
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	snd_snapshot_init();
	callback::on_localclient_connect(&player_init);
	callback::on_localplayer_spawned(&local_player_spawn);
	level thread register_clientfields();
	level thread sndkillcam();
	level thread setpfxcontext();
	setsoundcontext("foley", "normal");
	setsoundcontext("plr_impact", "");
}

/*
	Name: register_clientfields
	Namespace: audio
	Checksum: 0x68AE4611
	Offset: 0x9E8
	Size: 0x31C
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("world", "sndMatchSnapshot", 1, 2, "int", &sndmatchsnapshot, 1, 0);
	clientfield::register("world", "sndFoleyContext", 1, 1, "int", &sndfoleycontext, 0, 0);
	clientfield::register("scriptmover", "sndRattle", 1, 1, "int", &sndrattle_server, 1, 0);
	clientfield::register("toplayer", "sndMelee", 1, 1, "int", &weapon_butt_sounds, 1, 1);
	clientfield::register("vehicle", "sndSwitchVehicleContext", 1, 3, "int", &sndswitchvehiclecontext, 0, 0);
	clientfield::register("toplayer", "sndCCHacking", 1, 2, "int", &sndcchacking, 1, 1);
	clientfield::register("toplayer", "sndTacRig", 1, 1, "int", &sndtacrig, 0, 1);
	clientfield::register("toplayer", "sndLevelStartSnapOff", 1, 1, "int", &sndlevelstartsnapoff, 0, 1);
	clientfield::register("world", "sndIGCsnapshot", 1, 4, "int", &sndigcsnapshot, 1, 0);
	clientfield::register("world", "sndChyronLoop", 1, 1, "int", &sndchyronloop, 0, 0);
	clientfield::register("world", "sndZMBFadeIn", 1, 1, "int", &sndzmbfadein, 1, 0);
}

/*
	Name: local_player_spawn
	Namespace: audio
	Checksum: 0x11EFE10D
	Offset: 0xD10
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function local_player_spawn(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	setsoundcontext("foley", "normal");
	if(!sessionmodeismultiplayergame())
	{
		if(isdefined(level._lastmusicstate))
		{
			soundsetmusicstate(level._lastmusicstate);
		}
		self thread sndmusicdeathwatcher();
	}
	self thread isplayerinfected();
	self thread snd_underwater(localclientnum);
	self thread clientvoicesetup(localclientnum);
}

/*
	Name: player_init
	Namespace: audio
	Checksum: 0x4C35C6D5
	Offset: 0xE00
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function player_init(localclientnum)
{
	if(issplitscreenhost(localclientnum))
	{
		level thread bump_trigger_start(localclientnum);
		level thread init_audio_triggers(localclientnum);
		level thread sndrattle_grenade_client();
		startsoundrandoms(localclientnum);
		startsoundloops();
		startlineemitters();
		startrattles();
	}
}

/*
	Name: snddoublejump_watcher
	Namespace: audio
	Checksum: 0xC76A7CD3
	Offset: 0xEC0
	Size: 0xF0
	Parameters: 0
	Flags: None
*/
function snddoublejump_watcher()
{
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"doublejump_start");
		trace = tracepoint(self.origin, self.origin - vectorscale((0, 0, 1), 100000));
		trace_surface_type = trace["surfacetype"];
		trace_origin = trace["position"];
		if(!isdefined(trace) || !isdefined(trace_origin))
		{
			continue;
		}
		if(!isdefined(trace_surface_type))
		{
			trace_surface_type = "default";
		}
		playsound(0, "veh_jetpack_surface_" + trace_surface_type, trace_origin);
	}
}

/*
	Name: clientvoicesetup
	Namespace: audio
	Checksum: 0x608F7998
	Offset: 0xFB8
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function clientvoicesetup(localclientnum)
{
	self endon(#"entityshutdown");
	if(isdefined(level.clientvoicesetup))
	{
		[[level.clientvoicesetup]](localclientnum);
		return;
	}
	self.teamclientprefix = "vox_gen";
	self thread sndvonotify("playerbreathinsound", "sinper_hold");
	self thread sndvonotify("playerbreathoutsound", "sinper_exhale");
	self thread sndvonotify("playerbreathgaspsound", "sinper_gasp");
}

/*
	Name: sndvonotify
	Namespace: audio
	Checksum: 0xC65C6F96
	Offset: 0x1088
	Size: 0x68
	Parameters: 2
	Flags: Linked
*/
function sndvonotify(notifystring, dialog)
{
	self endon(#"entityshutdown");
	for(;;)
	{
		self waittill(notifystring);
		soundalias = (self.teamclientprefix + "_") + dialog;
		self playsound(0, soundalias);
	}
}

/*
	Name: snd_snapshot_init
	Namespace: audio
	Checksum: 0xB9451265
	Offset: 0x10F8
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function snd_snapshot_init()
{
	level._sndactivesnapshot = "default";
	level._sndnextsnapshot = "default";
	mapname = getdvarstring("mapname");
	if(mapname !== "core_frontend")
	{
		if(sessionmodeiscampaigngame())
		{
			level._sndactivesnapshot = "cmn_level_start";
			level._sndnextsnapshot = "cmn_level_start";
		}
		if(sessionmodeiszombiesgame())
		{
			if(mapname !== "zm_cosmodrome" && mapname !== "zm_prototype" && mapname !== "zm_moon" && mapname !== "zm_sumpf" && mapname !== "zm_asylum" && mapname !== "zm_temple" && mapname !== "zm_theater" && mapname !== "zm_tomb")
			{
				level._sndactivesnapshot = "zmb_game_start_nofade";
				level._sndnextsnapshot = "zmb_game_start_nofade";
			}
			else
			{
				level._sndactivesnapshot = "zmb_hd_game_start_nofade";
				level._sndnextsnapshot = "zmb_hd_game_start_nofade";
			}
		}
	}
	setgroupsnapshot(level._sndactivesnapshot);
	thread snd_snapshot_think();
}

/*
	Name: sndonwait
	Namespace: audio
	Checksum: 0xF6E0D08A
	Offset: 0x1298
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function sndonwait()
{
	level endon(#"sndonoverride");
	level util::waittill_any_timeout(20, "sndOn", "sndOnOverride");
}

/*
	Name: snd_set_snapshot
	Namespace: audio
	Checksum: 0xC112AA88
	Offset: 0x12D8
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function snd_set_snapshot(state)
{
	level._sndnextsnapshot = state;
	/#
		println(("" + state) + "");
	#/
	level notify(#"new_bus");
}

/*
	Name: snd_snapshot_think
	Namespace: audio
	Checksum: 0x2776E79
	Offset: 0x1338
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function snd_snapshot_think()
{
	for(;;)
	{
		if(level._sndactivesnapshot == level._sndnextsnapshot)
		{
			level waittill(#"new_bus");
		}
		if(level._sndactivesnapshot == level._sndnextsnapshot)
		{
			continue;
		}
		/#
			assert(isdefined(level._sndnextsnapshot));
		#/
		/#
			assert(isdefined(level._sndactivesnapshot));
		#/
		setgroupsnapshot(level._sndnextsnapshot);
		level._sndactivesnapshot = level._sndnextsnapshot;
	}
}

/*
	Name: soundrandom_thread
	Namespace: audio
	Checksum: 0xE652ED17
	Offset: 0x13E8
	Size: 0x230
	Parameters: 2
	Flags: Linked
*/
function soundrandom_thread(localclientnum, randsound)
{
	if(!isdefined(randsound.script_wait_min))
	{
		randsound.script_wait_min = 1;
	}
	if(!isdefined(randsound.script_wait_max))
	{
		randsound.script_wait_max = 3;
	}
	notify_name = undefined;
	if(isdefined(randsound.script_string))
	{
		notify_name = randsound.script_string;
	}
	if(!isdefined(notify_name) && isdefined(randsound.script_sound))
	{
		createsoundrandom(randsound.origin, randsound.script_sound, randsound.script_wait_min, randsound.script_wait_max);
		return;
	}
	randsound.playing = 1;
	level thread soundrandom_notifywait(notify_name, randsound);
	while(true)
	{
		wait(randomfloatrange(randsound.script_wait_min, randsound.script_wait_max));
		if(isdefined(randsound.script_sound) && (isdefined(randsound.playing) && randsound.playing))
		{
			playsound(localclientnum, randsound.script_sound, randsound.origin);
		}
		/#
			if(getdvarint("") > 0)
			{
				print3d(randsound.origin, randsound.script_sound, vectorscale((0, 1, 0), 0.8), 1, 3, 45);
			}
		#/
	}
}

/*
	Name: soundrandom_notifywait
	Namespace: audio
	Checksum: 0x20CBADEC
	Offset: 0x1620
	Size: 0x78
	Parameters: 2
	Flags: Linked
*/
function soundrandom_notifywait(notify_name, randsound)
{
	while(true)
	{
		level waittill(notify_name);
		if(isdefined(randsound.playing) && randsound.playing)
		{
			randsound.playing = 0;
		}
		else
		{
			randsound.playing = 1;
		}
	}
}

/*
	Name: startsoundrandoms
	Namespace: audio
	Checksum: 0x68CC2D7A
	Offset: 0x16A0
	Size: 0x106
	Parameters: 1
	Flags: Linked
*/
function startsoundrandoms(localclientnum)
{
	randoms = struct::get_array("random", "script_label");
	if(isdefined(randoms) && randoms.size > 0)
	{
		nscriptthreadedrandoms = 0;
		for(i = 0; i < randoms.size; i++)
		{
			if(isdefined(randoms[i].script_scripted))
			{
				nscriptthreadedrandoms++;
			}
		}
		allocatesoundrandoms(randoms.size - nscriptthreadedrandoms);
		for(i = 0; i < randoms.size; i++)
		{
			thread soundrandom_thread(localclientnum, randoms[i]);
		}
	}
}

/*
	Name: soundloopthink
	Namespace: audio
	Checksum: 0x2E62BC1F
	Offset: 0x17B0
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function soundloopthink()
{
	if(!isdefined(self.script_sound))
	{
		return;
	}
	if(!isdefined(self.origin))
	{
		return;
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
				self thread soundloopcheckpointrestore();
			}
			else
			{
				soundloopemitter(self.script_sound, self.origin);
			}
			started = !started;
		}
	}
}

/*
	Name: soundloopcheckpointrestore
	Namespace: audio
	Checksum: 0xF608BA75
	Offset: 0x1930
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function soundloopcheckpointrestore()
{
	level waittill(#"save_restore");
	soundloopemitter(self.script_sound, self.origin);
}

/*
	Name: soundlinethink
	Namespace: audio
	Checksum: 0x4BE6950B
	Offset: 0x1970
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function soundlinethink()
{
	if(!isdefined(self.target))
	{
		return;
	}
	target = struct::get(self.target, "targetname");
	if(!isdefined(target))
	{
		return;
	}
	notifyname = "";
	if(isdefined(self.script_string))
	{
		notifyname = self.script_string;
	}
	started = 1;
	if(isdefined(self.script_int))
	{
		started = self.script_int != 0;
	}
	if(started)
	{
		soundlineemitter(self.script_sound, self.origin, target.origin);
	}
	if(notifyname != "")
	{
		for(;;)
		{
			level waittill(notifyname);
			if(started)
			{
				soundstoplineemitter(self.script_sound, self.origin, target.origin);
				self thread soundlinecheckpointrestore(target);
			}
			else
			{
				soundlineemitter(self.script_sound, self.origin, target.origin);
			}
			started = !started;
		}
	}
}

/*
	Name: soundlinecheckpointrestore
	Namespace: audio
	Checksum: 0xACAC1318
	Offset: 0x1B00
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function soundlinecheckpointrestore(target)
{
	level waittill(#"save_restore");
	soundlineemitter(self.script_sound, self.origin, target.origin);
}

/*
	Name: startsoundloops
	Namespace: audio
	Checksum: 0x89DB718
	Offset: 0x1B50
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function startsoundloops()
{
	loopers = struct::get_array("looper", "script_label");
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
	Name: startlineemitters
	Namespace: audio
	Checksum: 0xD40546B8
	Offset: 0x1CB8
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function startlineemitters()
{
	lineemitters = struct::get_array("line_emitter", "script_label");
	if(isdefined(lineemitters) && lineemitters.size > 0)
	{
		delay = 0;
		/#
			if(getdvarint("") > 0)
			{
				println(("" + lineemitters.size) + "");
			}
		#/
		for(i = 0; i < lineemitters.size; i++)
		{
			lineemitters[i] thread soundlinethink();
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
	Name: startrattles
	Namespace: audio
	Checksum: 0x252C16D3
	Offset: 0x1E20
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function startrattles()
{
	rattles = struct::get_array("sound_rattle", "script_label");
	if(isdefined(rattles))
	{
		/#
			println(("" + rattles.size) + "");
		#/
		delay = 0;
		for(i = 0; i < rattles.size; i++)
		{
			soundrattlesetup(rattles[i].script_sound, rattles[i].origin);
			delay = delay + 1;
			if((delay % 20) == 0)
			{
				wait(0.016);
			}
		}
	}
}

/*
	Name: init_audio_triggers
	Namespace: audio
	Checksum: 0x7A647695
	Offset: 0x1F38
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function init_audio_triggers(localclientnum)
{
	util::waitforclient(localclientnum);
	steptrigs = getentarray(localclientnum, "audio_step_trigger", "targetname");
	materialtrigs = getentarray(localclientnum, "audio_material_trigger", "targetname");
	/#
		if(getdvarint("") > 0)
		{
			println(("" + steptrigs.size) + "");
			println(("" + materialtrigs.size) + "");
		}
	#/
	array::thread_all(steptrigs, &audio_step_trigger, localclientnum);
	array::thread_all(materialtrigs, &audio_material_trigger, localclientnum);
}

/*
	Name: audio_step_trigger
	Namespace: audio
	Checksum: 0x59471705
	Offset: 0x2098
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function audio_step_trigger(localclientnum)
{
	self._localclientnum = localclientnum;
	for(;;)
	{
		self waittill(#"trigger", trigplayer);
		self thread trigger::function_d1278be0(trigplayer, &trig_enter_audio_step_trigger, &trig_leave_audio_step_trigger);
	}
}

/*
	Name: audio_material_trigger
	Namespace: audio
	Checksum: 0x82801E2C
	Offset: 0x2110
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function audio_material_trigger(trig)
{
	for(;;)
	{
		self waittill(#"trigger", trigplayer);
		self thread trigger::function_d1278be0(trigplayer, &trig_enter_audio_material_trigger, &trig_leave_audio_material_trigger);
	}
}

/*
	Name: trig_enter_audio_material_trigger
	Namespace: audio
	Checksum: 0xA3C81852
	Offset: 0x2178
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function trig_enter_audio_material_trigger(player)
{
	if(!isdefined(player.inmaterialoverridetrigger))
	{
		player.inmaterialoverridetrigger = 0;
	}
	if(isdefined(self.script_label))
	{
		player.inmaterialoverridetrigger++;
		player.audiomaterialoverride = self.script_label;
		player setmaterialoverride(self.script_label);
	}
}

/*
	Name: trig_leave_audio_material_trigger
	Namespace: audio
	Checksum: 0x3B91A333
	Offset: 0x2200
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function trig_leave_audio_material_trigger(player)
{
	if(isdefined(self.script_label))
	{
		player.inmaterialoverridetrigger--;
		/#
			/#
				assert(player.inmaterialoverridetrigger >= 0);
			#/
		#/
		if(player.inmaterialoverridetrigger <= 0)
		{
			player.audiomaterialoverride = undefined;
			player.inmaterialoverridetrigger = 0;
			player clearmaterialoverride();
		}
	}
}

/*
	Name: trig_enter_audio_step_trigger
	Namespace: audio
	Checksum: 0x2DC37895
	Offset: 0x22A8
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function trig_enter_audio_step_trigger(trigplayer)
{
	localclientnum = self._localclientnum;
	if(!isdefined(trigplayer.insteptrigger))
	{
		trigplayer.insteptrigger = 0;
	}
	suffix = "_npc";
	if(trigplayer islocalplayer())
	{
		suffix = "_plr";
	}
	if(isdefined(self.script_label))
	{
		trigplayer.step_sound = self.script_label;
		trigplayer.insteptrigger = trigplayer.insteptrigger + 1;
		trigplayer setsteptriggersound(self.script_label + suffix);
	}
	if(isdefined(self.script_sound) && trigplayer getmovementtype() == "sprint")
	{
		volume = get_vol_from_speed(trigplayer);
		trigplayer playsound(localclientnum, self.script_sound + suffix, self.origin, volume);
	}
}

/*
	Name: trig_leave_audio_step_trigger
	Namespace: audio
	Checksum: 0x9185709D
	Offset: 0x2418
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function trig_leave_audio_step_trigger(trigplayer)
{
	localclientnum = self._localclientnum;
	suffix = "_npc";
	if(trigplayer islocalplayer())
	{
		suffix = "_plr";
	}
	if(isdefined(self.script_noteworthy) && trigplayer getmovementtype() == "sprint")
	{
		volume = get_vol_from_speed(trigplayer);
		trigplayer playsound(localclientnum, self.script_noteworthy + suffix, self.origin, volume);
	}
	if(isdefined(self.script_label))
	{
		trigplayer.insteptrigger = trigplayer.insteptrigger - 1;
	}
	if(trigplayer.insteptrigger < 0)
	{
		/#
			println("");
		#/
		trigplayer.insteptrigger = 0;
	}
	if(trigplayer.insteptrigger == 0)
	{
		trigplayer.step_sound = "none";
		trigplayer clearsteptriggersound();
	}
}

/*
	Name: bump_trigger_start
	Namespace: audio
	Checksum: 0xCF03E099
	Offset: 0x25B0
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function bump_trigger_start(localclientnum)
{
	bump_trigs = getentarray(localclientnum, "audio_bump_trigger", "targetname");
	for(i = 0; i < bump_trigs.size; i++)
	{
		bump_trigs[i] thread thread_bump_trigger(localclientnum);
	}
}

/*
	Name: thread_bump_trigger
	Namespace: audio
	Checksum: 0x255F20E3
	Offset: 0x2648
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function thread_bump_trigger(localclientnum)
{
	self thread bump_trigger_listener();
	if(!isdefined(self.script_activated))
	{
		self.script_activated = 1;
	}
	self._localclientnum = localclientnum;
	for(;;)
	{
		self waittill(#"trigger", trigplayer);
		self thread trigger::function_d1278be0(trigplayer, &trig_enter_bump, &trig_leave_bump);
	}
}

/*
	Name: trig_enter_bump
	Namespace: audio
	Checksum: 0x92F611CB
	Offset: 0x26F0
	Size: 0x1E4
	Parameters: 1
	Flags: Linked
*/
function trig_enter_bump(ent)
{
	if(!isdefined(ent))
	{
		return;
	}
	localclientnum = self._localclientnum;
	volume = get_vol_from_speed(ent);
	if(!sessionmodeiszombiesgame())
	{
		if(ent isplayer() && ent hasperk(localclientnum, "specialty_quieter"))
		{
			volume = volume / 2;
		}
	}
	if(isdefined(self.script_sound) && self.script_activated)
	{
		if(isdefined(self.script_noteworthy) && self.script_wait > volume)
		{
			test_id = ent playsound(localclientnum, self.script_noteworthy, self.origin, volume);
		}
		if(isdefined(self.script_parameters))
		{
			test_id = ent playsound(localclientnum, self.script_parameters, self.origin, volume);
		}
		if(!isdefined(self.script_wait) || self.script_wait <= volume)
		{
			test_id = ent playsound(localclientnum, self.script_sound, self.origin, volume);
		}
	}
	if(isdefined(self.script_location) && self.script_activated)
	{
		ent thread mantle_wait(self.script_location, localclientnum);
	}
}

/*
	Name: mantle_wait
	Namespace: audio
	Checksum: 0x30FEDEE1
	Offset: 0x28E0
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function mantle_wait(alias, localclientnum)
{
	self endon(#"death");
	self endon(#"left_mantle");
	self waittill(#"traversesound");
	self playsound(localclientnum, alias, self.origin, 1);
}

/*
	Name: trig_leave_bump
	Namespace: audio
	Checksum: 0x3B71DE64
	Offset: 0x2950
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function trig_leave_bump(ent)
{
	wait(1);
	ent notify(#"left_mantle");
}

/*
	Name: bump_trigger_listener
	Namespace: audio
	Checksum: 0x5DD2AAA6
	Offset: 0x2978
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function bump_trigger_listener()
{
	if(isdefined(self.script_label))
	{
		level waittill(self.script_label);
		self.script_activated = 0;
	}
}

/*
	Name: scale_speed
	Namespace: audio
	Checksum: 0x3E3DD149
	Offset: 0x29A8
	Size: 0xCC
	Parameters: 5
	Flags: Linked
*/
function scale_speed(x1, x2, y1, y2, z)
{
	if(z < x1)
	{
		z = x1;
	}
	if(z > x2)
	{
		z = x2;
	}
	dx = x2 - x1;
	n = (z - x1) / dx;
	dy = y2 - y1;
	w = (n * dy) + y1;
	return w;
}

/*
	Name: get_vol_from_speed
	Namespace: audio
	Checksum: 0x74D0A80D
	Offset: 0x2A80
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function get_vol_from_speed(player)
{
	min_speed = 21;
	max_speed = 285;
	max_vol = 1;
	min_vol = 0.1;
	speed = player getspeed();
	abs_speed = absolute_value(int(speed));
	volume = scale_speed(min_speed, max_speed, min_vol, max_vol, abs_speed);
	return volume;
}

/*
	Name: absolute_value
	Namespace: audio
	Checksum: 0x9DE1AA44
	Offset: 0x2B70
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function absolute_value(fowd)
{
	if(fowd < 0)
	{
		return fowd * -1;
	}
	return fowd;
}

/*
	Name: closest_point_on_line_to_point
	Namespace: audio
	Checksum: 0xE9CC5EB
	Offset: 0x2BA8
	Size: 0x1E0
	Parameters: 3
	Flags: Linked
*/
function closest_point_on_line_to_point(point, linestart, lineend)
{
	self endon(#"hash_18e2bbbb");
	linemagsqrd = lengthsquared(lineend - linestart);
	t = (point[0] - linestart[0]) * (lineend[0] - linestart[0]) + (point[1] - linestart[1]) * (lineend[1] - linestart[1]) + (point[2] - linestart[2]) * (lineend[2] - linestart[2]) / linemagsqrd;
	if(t < 0)
	{
		self.origin = linestart;
	}
	else
	{
		if(t > 1)
		{
			self.origin = lineend;
		}
		else
		{
			start_x = linestart[0] + (t * (lineend[0] - linestart[0]));
			start_y = linestart[1] + (t * (lineend[1] - linestart[1]));
			start_z = linestart[2] + (t * (lineend[2] - linestart[2]));
			self.origin = (start_x, start_y, start_z);
		}
	}
}

/*
	Name: snd_play_auto_fx
	Namespace: audio
	Checksum: 0x877405E1
	Offset: 0x2D90
	Size: 0x84
	Parameters: 9
	Flags: None
*/
function snd_play_auto_fx(fxid, alias, offsetx, offsety, offsetz, onground, area, threshold, alias_override)
{
	soundplayautofx(fxid, alias, offsetx, offsety, offsetz, onground, area, threshold, alias_override);
}

/*
	Name: snd_print_fx_id
	Namespace: audio
	Checksum: 0x4D2D743B
	Offset: 0x2E20
	Size: 0x6C
	Parameters: 3
	Flags: None
*/
function snd_print_fx_id(fxid, type, ent)
{
	/#
		if(getdvarint("") > 0)
		{
			println((("" + fxid) + "") + type);
		}
	#/
}

/*
	Name: debug_line_emitter
	Namespace: audio
	Checksum: 0xD6BD2BF
	Offset: 0x2E98
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function debug_line_emitter()
{
	while(true)
	{
		/#
			if(getdvarint("") > 0)
			{
				line(self.start, self.end, (0, 1, 0));
				print3d(self.start, "", vectorscale((0, 1, 0), 0.8), 1, 3, 1);
				print3d(self.end, "", vectorscale((0, 1, 0), 0.8), 1, 3, 1);
				print3d(self.origin, self.script_sound, vectorscale((0, 1, 0), 0.8), 1, 3, 1);
			}
			wait(0.016);
		#/
	}
}

/*
	Name: move_sound_along_line
	Namespace: audio
	Checksum: 0xD24E6C50
	Offset: 0x2FA8
	Size: 0x104
	Parameters: 0
	Flags: None
*/
function move_sound_along_line()
{
	closest_dist = undefined;
	/#
		self thread debug_line_emitter();
	#/
	while(true)
	{
		self closest_point_on_line_to_point(getlocalclientpos(0), self.start, self.end);
		if(isdefined(self.fake_ent))
		{
			self.fake_ent.origin = self.origin;
		}
		closest_dist = distancesquared(getlocalclientpos(0), self.origin);
		if(closest_dist > 1048576)
		{
			wait(2);
		}
		else
		{
			if(closest_dist > 262144)
			{
				wait(0.2);
			}
			else
			{
				wait(0.05);
			}
		}
	}
}

/*
	Name: playloopat
	Namespace: audio
	Checksum: 0xB5F6B6FB
	Offset: 0x30B8
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function playloopat(aliasname, origin)
{
	soundloopemitter(aliasname, origin);
}

/*
	Name: stoploopat
	Namespace: audio
	Checksum: 0xA502F2A1
	Offset: 0x30F0
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function stoploopat(aliasname, origin)
{
	soundstoploopemitter(aliasname, origin);
}

/*
	Name: soundwait
	Namespace: audio
	Checksum: 0x9995F98A
	Offset: 0x3128
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function soundwait(id)
{
	while(soundplaying(id))
	{
		wait(0.1);
	}
}

/*
	Name: snd_underwater
	Namespace: audio
	Checksum: 0xFF65BE16
	Offset: 0x3168
	Size: 0x300
	Parameters: 1
	Flags: Linked
*/
function snd_underwater(localclientnum)
{
	level endon(#"demo_jump");
	self endon(#"entityshutdown");
	level endon("killcam_begin" + localclientnum);
	level endon("killcam_end" + localclientnum);
	self endon(#"sndenduwwatcher");
	if(!isdefined(level.audiosharedswimming))
	{
		level.audiosharedswimming = 0;
	}
	if(!isdefined(level.audiosharedunderwater))
	{
		level.audiosharedunderwater = 0;
	}
	if(level.audiosharedswimming != isswimming(localclientnum))
	{
		level.audiosharedswimming = isswimming(localclientnum);
		if(level.audiosharedswimming)
		{
			swimbegin();
		}
		else
		{
			swimcancel(localclientnum);
		}
	}
	if(level.audiosharedunderwater != isunderwater(localclientnum))
	{
		level.audiosharedunderwater = isunderwater(localclientnum);
		if(level.audiosharedunderwater)
		{
			self underwaterbegin();
		}
		else
		{
			self underwaterend();
		}
	}
	while(true)
	{
		underwaternotify = self util::waittill_any_ex("underwater_begin", "underwater_end", "swimming_begin", "swimming_end", "death", "entityshutdown", "sndEndUWWatcher", level, "demo_jump", "killcam_begin" + localclientnum, "killcam_end" + localclientnum);
		if(underwaternotify == "death")
		{
			self underwaterend();
			self swimend(localclientnum);
		}
		if(underwaternotify == "underwater_begin")
		{
			self underwaterbegin();
		}
		else
		{
			if(underwaternotify == "underwater_end")
			{
				self underwaterend();
			}
			else
			{
				if(underwaternotify == "swimming_begin")
				{
					self swimbegin();
				}
				else if(underwaternotify == "swimming_end" && self isplayer() && isalive(self))
				{
					self swimend(localclientnum);
				}
			}
		}
	}
}

/*
	Name: underwaterbegin
	Namespace: audio
	Checksum: 0x906D07C7
	Offset: 0x3470
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function underwaterbegin()
{
	level.audiosharedunderwater = 1;
}

/*
	Name: underwaterend
	Namespace: audio
	Checksum: 0x51736077
	Offset: 0x3488
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function underwaterend()
{
	level.audiosharedunderwater = 0;
}

/*
	Name: setpfxcontext
	Namespace: audio
	Checksum: 0x26847F8B
	Offset: 0x34A0
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function setpfxcontext()
{
	level waittill(#"pfx_igc_on");
	setsoundcontext("igc", "on");
	level waittill(#"pfx_igc_off");
	setsoundcontext("igc", "");
	return;
}

/*
	Name: swimbegin
	Namespace: audio
	Checksum: 0x5FD64260
	Offset: 0x3510
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function swimbegin()
{
	self.audiosharedswimming = 1;
}

/*
	Name: swimend
	Namespace: audio
	Checksum: 0x930BD3D2
	Offset: 0x3528
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function swimend(localclientnum)
{
	self.audiosharedswimming = 0;
}

/*
	Name: swimcancel
	Namespace: audio
	Checksum: 0x63377CA4
	Offset: 0x3548
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function swimcancel(localclientnum)
{
	self.audiosharedswimming = 0;
}

/*
	Name: soundplayuidecodeloop
	Namespace: audio
	Checksum: 0xE3987C19
	Offset: 0x3568
	Size: 0xBE
	Parameters: 2
	Flags: Linked
*/
function soundplayuidecodeloop(decodestring, playtimems)
{
	if(!isdefined(level.playinguidecodeloop) || !level.playinguidecodeloop)
	{
		level.playinguidecodeloop = 1;
		fake_ent = spawn(0, (0, 0, 0), "script_origin");
		if(isdefined(fake_ent))
		{
			fake_ent playloopsound("uin_notify_data_loop");
			wait(playtimems / 1000);
			fake_ent stopallloopsounds(0);
		}
		level.playinguidecodeloop = undefined;
	}
}

/*
	Name: setcurrentambientstate
	Namespace: audio
	Checksum: 0xBBFB71E9
	Offset: 0x3630
	Size: 0x54
	Parameters: 5
	Flags: Linked
*/
function setcurrentambientstate(ambientroom, ambientpackage, roomcollidercent, packagecollidercent, defaultroom)
{
	if(isdefined(level._sndambientstatecallback))
	{
		level thread [[level._sndambientstatecallback]](ambientroom, ambientpackage, roomcollidercent);
	}
}

/*
	Name: isplayerinfected
	Namespace: audio
	Checksum: 0x322A951E
	Offset: 0x3690
	Size: 0x2C6
	Parameters: 0
	Flags: Linked
*/
function isplayerinfected()
{
	self endon(#"entityshutdown");
	mapname = getdvarstring("mapname");
	if(!isdefined(mapname))
	{
		mapname = "cp_mi_eth_prologue";
	}
	if(isdefined(self))
	{
		switch(mapname)
		{
			case "cp_mi_eth_prologue":
			{
				self.isinfected = 0;
				setsoundcontext("healthstate", "human");
				break;
			}
			case "cp_mi_cairo_infection2":
			{
				self.isinfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_cairo_infection3":
			{
				self.isinfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_cairo_aquifer":
			{
				self.isinfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_cairo_lotus":
			{
				self.isinfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_cairo_lotus2":
			{
				self.isinfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_cairo_lotus3":
			{
				self.isinfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "cp_mi_zurich_coalescence":
			{
				self.isinfected = 1;
				setsoundcontext("healthstate", "infected");
				break;
			}
			case "zm_zod":
			{
				self.isinfected = 0;
				setsoundcontext("healthstate", "human");
				break;
			}
			case "zm_factory":
			{
				self.isinfected = 0;
				setsoundcontext("healthstate", "human");
				break;
			}
			default:
			{
				self.isinfected = 0;
				setsoundcontext("healthstate", "cyber");
				break;
			}
		}
	}
}

/*
	Name: sndhealthsystem
	Namespace: audio
	Checksum: 0x2BC52004
	Offset: 0x3960
	Size: 0x33E
	Parameters: 7
	Flags: None
*/
function sndhealthsystem(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	lowhealthenteralias = "chr_health_lowhealth_enter";
	lowhealthexitalias = "chr_health_lowhealth_exit";
	laststandexitalias = "chr_health_laststand_exit";
	dnireparalais = "chr_health_dni_repair";
	if(newval)
	{
		switch(newval)
		{
			case 1:
			{
				self.lowhealth = 1;
				playsound(localclientnum, lowhealthenteralias, (0, 0, 0));
				forceambientroom("sndHealth_LowHealth");
				self thread snddnirepair(localclientnum, dnireparalais, 0.4, 0.8);
				break;
			}
			case 2:
			{
				playsound(localclientnum, lowhealthexitalias, (0, 0, 0));
				forceambientroom("sndHealth_LastStand");
				self notify(#"snddnirepairdone");
				setsoundcontext("laststand", "active");
				break;
			}
		}
	}
	else
	{
		self.lowhealth = 0;
		setsoundcontext("laststand", "");
		if(sessionmodeiscampaigngame() && (isdefined(level.audiosharedunderwater) && level.audiosharedunderwater))
		{
			mapname = getdvarstring("mapname");
			if(mapname == "cp_mi_sing_sgen")
			{
				forceambientroom("");
			}
			else
			{
				forceambientroom("");
			}
		}
		else
		{
			forceambientroom("");
		}
		if(oldval == 1)
		{
			playsound(localclientnum, lowhealthexitalias, (0, 0, 0));
			self notify(#"snddnirepairdone");
		}
		else
		{
			if(isalive(self))
			{
				playsound(localclientnum, laststandexitalias, (0, 0, 0));
				if(isdefined(self.sndtacrigemergencyreserve) && self.sndtacrigemergencyreserve)
				{
					playsound(localclientnum, "gdt_cybercore_regen_complete", (0, 0, 0));
				}
			}
			self notify(#"snddnirepairdone");
		}
		return;
	}
}

/*
	Name: snddnirepair
	Namespace: audio
	Checksum: 0xF588A7EA
	Offset: 0x3CA8
	Size: 0xB8
	Parameters: 4
	Flags: Linked
*/
function snddnirepair(localclientnum, alais, min, max)
{
	self endon(#"snddnirepairdone");
	wait(0.5);
	if(isdefined(self) && isdefined(self.isinfected))
	{
		if(self.isinfected)
		{
			playsound(localclientnum, "vox_dying_infected_after", (0, 0, 0));
		}
		while(isdefined(self))
		{
			playsound(localclientnum, alais, (0, 0, 0));
			wait(randomfloatrange(min, max));
		}
	}
}

/*
	Name: sndtacrig
	Namespace: audio
	Checksum: 0x967DC574
	Offset: 0x3D68
	Size: 0x60
	Parameters: 7
	Flags: Linked
*/
function sndtacrig(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.sndtacrigemergencyreserve = 1;
	}
	else
	{
		self.sndtacrigemergencyreserve = 0;
	}
}

/*
	Name: dorattle
	Namespace: audio
	Checksum: 0x8C26F403
	Offset: 0x3DD0
	Size: 0x6C
	Parameters: 3
	Flags: Linked
*/
function dorattle(origin, min, max)
{
	if(isdefined(min) && min > 0)
	{
		if(isdefined(max) && max <= 0)
		{
			max = undefined;
		}
		soundrattle(origin, min, max);
	}
}

/*
	Name: sndrattle_server
	Namespace: audio
	Checksum: 0xFBC8F75
	Offset: 0x3E48
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function sndrattle_server(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(self.model == "wpn_t7_bouncing_betty_world")
		{
			betty = getweapon("bouncingbetty");
			level thread dorattle(self.origin, betty.soundrattlerangemin, betty.soundrattlerangemax);
		}
		else
		{
			level thread dorattle(self.origin, 25, 600);
		}
	}
}

/*
	Name: sndrattle_grenade_client
	Namespace: audio
	Checksum: 0xE193693
	Offset: 0x3F30
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function sndrattle_grenade_client()
{
	while(true)
	{
		level waittill(#"explode", localclientnum, position, mod, weapon, owner_cent);
		level thread dorattle(position, weapon.soundrattlerangemin, weapon.soundrattlerangemax);
	}
}

/*
	Name: weapon_butt_sounds
	Namespace: audio
	Checksum: 0xAE004963
	Offset: 0x3FC0
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function weapon_butt_sounds(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.meleed = 1;
		level.mysnd = playsound(localclientnum, "chr_melee_tinitus", (0, 0, 0));
		forceambientroom("sndHealth_Melee");
	}
	else
	{
		self.meleed = 0;
		forceambientroom("");
		if(isdefined(level.mysnd))
		{
			stopsound(level.mysnd);
		}
	}
}

/*
	Name: set_sound_context_defaults
	Namespace: audio
	Checksum: 0x4EC4661C
	Offset: 0x40B0
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function set_sound_context_defaults()
{
	wait(2);
	setsoundcontext("foley", "normal");
}

/*
	Name: sndmatchsnapshot
	Namespace: audio
	Checksum: 0x86915F80
	Offset: 0x40E8
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function sndmatchsnapshot(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		switch(newval)
		{
			case 1:
			{
				snd_set_snapshot("mpl_prematch");
				break;
			}
			case 2:
			{
				snd_set_snapshot("mpl_postmatch");
				break;
			}
			case 3:
			{
				snd_set_snapshot("mpl_endmatch");
				break;
			}
		}
	}
	else
	{
		snd_set_snapshot("default");
	}
}

/*
	Name: sndfoleycontext
	Namespace: audio
	Checksum: 0xB8467FD6
	Offset: 0x41D8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function sndfoleycontext(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setsoundcontext("foley", "normal");
}

/*
	Name: sndkillcam
	Namespace: audio
	Checksum: 0x9F8EAA81
	Offset: 0x4240
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function sndkillcam()
{
	level thread sndfinalkillcam_slowdown();
	level thread sndfinalkillcam_deactivate();
}

/*
	Name: snddeath_activate
	Namespace: audio
	Checksum: 0xF32B5731
	Offset: 0x4280
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function snddeath_activate()
{
	while(true)
	{
		level waittill(#"sndded");
		snd_set_snapshot("mpl_death");
	}
}

/*
	Name: snddeath_deactivate
	Namespace: audio
	Checksum: 0x911BE21
	Offset: 0x42C0
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function snddeath_deactivate()
{
	while(true)
	{
		level waittill(#"snddede");
		snd_set_snapshot("default");
	}
}

/*
	Name: sndfinalkillcam_activate
	Namespace: audio
	Checksum: 0x4F3E54A
	Offset: 0x4300
	Size: 0x58
	Parameters: 0
	Flags: None
*/
function sndfinalkillcam_activate()
{
	while(true)
	{
		level waittill(#"sndfks");
		playsound(0, "mpl_final_killcam_enter", (0, 0, 0));
		snd_set_snapshot("mpl_final_killcam");
	}
}

/*
	Name: sndfinalkillcam_slowdown
	Namespace: audio
	Checksum: 0x7B44CEA0
	Offset: 0x4360
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function sndfinalkillcam_slowdown()
{
	while(true)
	{
		level waittill(#"sndfksl");
		playsound(0, "mpl_final_killcam_enter", (0, 0, 0));
		playsound(0, "mpl_final_killcam_slowdown", (0, 0, 0));
		snd_set_snapshot("mpl_final_killcam_slowdown");
	}
}

/*
	Name: sndfinalkillcam_deactivate
	Namespace: audio
	Checksum: 0x15E09478
	Offset: 0x43E0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function sndfinalkillcam_deactivate()
{
	while(true)
	{
		level waittill(#"sndfke");
		snd_set_snapshot("default");
	}
}

/*
	Name: sndswitchvehiclecontext
	Namespace: audio
	Checksum: 0x8E4EE317
	Offset: 0x4420
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function sndswitchvehiclecontext(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(self islocalclientdriver(localclientnum))
	{
		setsoundcontext("plr_impact", "veh");
	}
	else
	{
		setsoundcontext("plr_impact", "");
	}
}

/*
	Name: sndmusicdeathwatcher
	Namespace: audio
	Checksum: 0x44883A53
	Offset: 0x44C8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function sndmusicdeathwatcher()
{
	self waittill(#"death");
	soundsetmusicstate("death");
}

/*
	Name: sndcchacking
	Namespace: audio
	Checksum: 0xA9F834B
	Offset: 0x4500
	Size: 0x1A4
	Parameters: 7
	Flags: Linked
*/
function sndcchacking(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		switch(newval)
		{
			case 1:
			{
				playsound(0, "gdt_cybercore_hack_start_plr", (0, 0, 0));
				self.hsnd = self playloopsound("gdt_cybercore_hack_lp_plr", 0.5);
				break;
			}
			case 2:
			{
				playsound(0, "gdt_cybercore_prime_upg_plr", (0, 0, 0));
				self.hsnd = self playloopsound("gdt_cybercore_prime_loop_plr", 0.5);
				break;
			}
		}
	}
	else
	{
		if(isdefined(self.hsnd))
		{
			self stoploopsound(self.hsnd, 0.5);
		}
		if(oldval == 1)
		{
			playsound(0, "gdt_cybercore_hack_success_plr", (0, 0, 0));
		}
		else if(oldval == 2)
		{
			playsound(0, "gdt_cybercore_activate_fail_plr", (0, 0, 0));
		}
	}
}

/*
	Name: sndigcsnapshot
	Namespace: audio
	Checksum: 0x629AC3F6
	Offset: 0x46B0
	Size: 0x16C
	Parameters: 7
	Flags: Linked
*/
function sndigcsnapshot(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		switch(newval)
		{
			case 1:
			{
				snd_set_snapshot("cmn_igc_bg_lower");
				level.sndigcsnapshotoverride = 0;
				break;
			}
			case 2:
			{
				snd_set_snapshot("cmn_igc_amb_silent");
				level.sndigcsnapshotoverride = 1;
				break;
			}
			case 3:
			{
				snd_set_snapshot("cmn_igc_foley_lower");
				level.sndigcsnapshotoverride = 0;
				break;
			}
			case 4:
			{
				snd_set_snapshot("cmn_level_fadeout");
				level.sndigcsnapshotoverride = 0;
				break;
			}
			case 5:
			{
				snd_set_snapshot("cmn_level_fade_immediate");
				level.sndigcsnapshotoverride = 0;
				break;
			}
		}
	}
	else
	{
		level.sndigcsnapshotoverride = 0;
		snd_set_snapshot("default");
	}
}

/*
	Name: sndlevelstartsnapoff
	Namespace: audio
	Checksum: 0x2D38D683
	Offset: 0x4828
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function sndlevelstartsnapoff(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(!(isdefined(level.sndigcsnapshotoverride) && level.sndigcsnapshotoverride))
		{
			snd_set_snapshot("default");
		}
	}
}

/*
	Name: sndzmbfadein
	Namespace: audio
	Checksum: 0x2DF9160D
	Offset: 0x48A8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function sndzmbfadein(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		snd_set_snapshot("default");
	}
}

/*
	Name: sndchyronloop
	Namespace: audio
	Checksum: 0xCD94760E
	Offset: 0x4910
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function sndchyronloop(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(!isdefined(level.chyronloop))
		{
			level.chyronloop = spawn(0, (0, 0, 0), "script_origin");
			level.chyronloop playloopsound("uin_chyron_loop");
		}
	}
	else if(isdefined(level.chyronloop))
	{
		level.chyronloop delete();
	}
}

