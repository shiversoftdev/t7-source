// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_audio;

/*
	Name: __init__sytem__
	Namespace: zm_audio
	Checksum: 0x70FF34DC
	Offset: 0x460
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_audio
	Checksum: 0x3F5A4146
	Offset: 0x4A0
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "charindex", 1, 3, "int", &charindex_cb, 0, 1);
	clientfield::register("toplayer", "isspeaking", 1, 1, "int", &isspeaking_cb, 0, 1);
	if(!isdefined(level.exert_sounds))
	{
		level.exert_sounds = [];
	}
	level.exert_sounds[0]["playerbreathinsound"] = "vox_exert_generic_inhale";
	level.exert_sounds[0]["playerbreathoutsound"] = "vox_exert_generic_exhale";
	level.exert_sounds[0]["playerbreathgaspsound"] = "vox_exert_generic_exhale";
	level.exert_sounds[0]["falldamage"] = "vox_exert_generic_pain";
	level.exert_sounds[0]["mantlesoundplayer"] = "vox_exert_generic_mantle";
	level.exert_sounds[0]["meleeswipesoundplayer"] = "vox_exert_generic_knifeswipe";
	level.exert_sounds[0]["dtplandsoundplayer"] = "vox_exert_generic_pain";
	level thread gameover_snapshot();
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: zm_audio
	Checksum: 0x2B6B900C
	Offset: 0x650
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function on_player_spawned(localclientnum)
{
}

/*
	Name: delay_set_exert_id
	Namespace: zm_audio
	Checksum: 0x7E39EB96
	Offset: 0x668
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function delay_set_exert_id(newval)
{
	self endon(#"entityshutdown");
	self endon(#"sndendexertoverride");
	wait(0.5);
	self.player_exert_id = newval;
}

/*
	Name: charindex_cb
	Namespace: zm_audio
	Checksum: 0x29D2394A
	Offset: 0x6A8
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function charindex_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!bnewent)
	{
		self.player_exert_id = newval;
		self._first_frame_exert_id_recieved = 1;
		self notify(#"sndendexertoverride");
	}
	else if(!isdefined(self._first_frame_exert_id_recieved))
	{
		self._first_frame_exert_id_recieved = 1;
		self thread delay_set_exert_id(newval);
	}
}

/*
	Name: isspeaking_cb
	Namespace: zm_audio
	Checksum: 0x873C8808
	Offset: 0x758
	Size: 0x60
	Parameters: 7
	Flags: Linked
*/
function isspeaking_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!bnewent)
	{
		self.isspeaking = newval;
	}
	else
	{
		self.isspeaking = 0;
	}
}

/*
	Name: zmbmuslooper
	Namespace: zm_audio
	Checksum: 0xA67FE2BE
	Offset: 0x7C0
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function zmbmuslooper()
{
	ent = spawn(0, (0, 0, 0), "script_origin");
	playsound(0, "mus_zmb_gamemode_start", (0, 0, 0));
	wait(10);
	ent playloopsound("mus_zmb_gamemode_loop", 0.05);
	ent thread waitfor_music_stop();
}

/*
	Name: waitfor_music_stop
	Namespace: zm_audio
	Checksum: 0xA05676DE
	Offset: 0x860
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function waitfor_music_stop()
{
	level waittill(#"stpm");
	self stopallloopsounds(0.1);
	playsound(0, "mus_zmb_gamemode_end", (0, 0, 0));
	wait(1);
	self delete();
}

/*
	Name: playerfalldamagesound
	Namespace: zm_audio
	Checksum: 0x1C1044F8
	Offset: 0x8D0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function playerfalldamagesound(client_num, firstperson)
{
	self playerexert(client_num, "falldamage");
}

/*
	Name: clientvoicesetup
	Namespace: zm_audio
	Checksum: 0xFC787F59
	Offset: 0x910
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function clientvoicesetup()
{
	callback::on_localclient_connect(&audio_player_connect);
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		thread audio_player_connect(i);
	}
}

/*
	Name: audio_player_connect
	Namespace: zm_audio
	Checksum: 0xAD186B6F
	Offset: 0x998
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function audio_player_connect(localclientnum)
{
	thread sndvonotifyplain(localclientnum, "playerbreathinsound");
	thread sndvonotifyplain(localclientnum, "playerbreathoutsound");
	thread sndvonotifyplain(localclientnum, "playerbreathgaspsound");
	thread sndvonotifyplain(localclientnum, "mantlesoundplayer");
	thread sndvonotifyplain(localclientnum, "meleeswipesoundplayer");
	thread sndvonotifydtp(localclientnum, "dtplandsoundplayer");
}

/*
	Name: playerexert
	Namespace: zm_audio
	Checksum: 0x2DDB3A68
	Offset: 0xA70
	Size: 0x15C
	Parameters: 2
	Flags: Linked
*/
function playerexert(localclientnum, exert)
{
	if(isdefined(self.isspeaking) && self.isspeaking == 1)
	{
		return;
	}
	if(isdefined(self.beast_mode) && self.beast_mode)
	{
		return;
	}
	id = level.exert_sounds[0][exert];
	if(isarray(level.exert_sounds[0][exert]))
	{
		id = array::random(level.exert_sounds[0][exert]);
	}
	if(isdefined(self.player_exert_id))
	{
		if(isarray(level.exert_sounds[self.player_exert_id][exert]))
		{
			id = array::random(level.exert_sounds[self.player_exert_id][exert]);
		}
		else
		{
			id = level.exert_sounds[self.player_exert_id][exert];
		}
	}
	if(isdefined(id))
	{
		self playsound(localclientnum, id);
	}
}

/*
	Name: sndvonotifydtp
	Namespace: zm_audio
	Checksum: 0x5618D8BD
	Offset: 0xBD8
	Size: 0xC8
	Parameters: 2
	Flags: Linked
*/
function sndvonotifydtp(localclientnum, notifystring)
{
	level notify(("kill_sndVoNotifyDTP" + localclientnum) + notifystring);
	level endon(("kill_sndVoNotifyDTP" + localclientnum) + notifystring);
	player = undefined;
	while(!isdefined(player))
	{
		player = getnonpredictedlocalplayer(localclientnum);
		wait(0.05);
	}
	player endon(#"disconnect");
	for(;;)
	{
		player waittill(notifystring, surfacetype);
		player playerexert(localclientnum, notifystring);
	}
}

/*
	Name: sndmeleeswipe
	Namespace: zm_audio
	Checksum: 0xDFC6F3A5
	Offset: 0xCA8
	Size: 0x208
	Parameters: 2
	Flags: None
*/
function sndmeleeswipe(localclientnum, notifystring)
{
	player = undefined;
	while(!isdefined(player))
	{
		player = getnonpredictedlocalplayer(localclientnum);
		wait(0.05);
	}
	player endon(#"disconnect");
	for(;;)
	{
		player waittill(notifystring);
		currentweapon = getcurrentweapon(localclientnum);
		if(isdefined(level.sndnomeleeonclient) && level.sndnomeleeonclient)
		{
			return;
		}
		if(isdefined(player.is_player_zombie) && player.is_player_zombie)
		{
			playsound(0, "zmb_melee_whoosh_zmb_plr", player.origin);
			continue;
		}
		if(currentweapon.name == "bowie_knife")
		{
			playsound(0, "zmb_bowie_swing_plr", player.origin);
			continue;
		}
		if(currentweapon.name == "spoon_zm_alcatraz")
		{
			playsound(0, "zmb_spoon_swing_plr", player.origin);
			continue;
		}
		if(currentweapon.name == "spork_zm_alcatraz")
		{
			playsound(0, "zmb_spork_swing_plr", player.origin);
			continue;
		}
		playsound(0, "zmb_melee_whoosh_plr", player.origin);
	}
}

/*
	Name: sndvonotifyplain
	Namespace: zm_audio
	Checksum: 0x6C31D1F8
	Offset: 0xEB8
	Size: 0xE8
	Parameters: 2
	Flags: Linked
*/
function sndvonotifyplain(localclientnum, notifystring)
{
	level notify(("kill_sndVoNotifyPlain" + localclientnum) + notifystring);
	level endon(("kill_sndVoNotifyPlain" + localclientnum) + notifystring);
	player = undefined;
	while(!isdefined(player))
	{
		player = getnonpredictedlocalplayer(localclientnum);
		wait(0.05);
	}
	player endon(#"disconnect");
	for(;;)
	{
		player waittill(notifystring);
		if(isdefined(player.is_player_zombie) && player.is_player_zombie)
		{
			continue;
		}
		player playerexert(localclientnum, notifystring);
	}
}

/*
	Name: end_gameover_snapshot
	Namespace: zm_audio
	Checksum: 0xFD5EF33E
	Offset: 0xFA8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function end_gameover_snapshot()
{
	level util::waittill_any("demo_jump", "demo_player_switch", "snd_clear_script_duck");
	wait(1);
	audio::snd_set_snapshot("default");
	level thread gameover_snapshot();
}

/*
	Name: gameover_snapshot
	Namespace: zm_audio
	Checksum: 0x5E058B09
	Offset: 0x1020
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function gameover_snapshot()
{
	level waittill(#"zesn");
	audio::snd_set_snapshot("zmb_game_over");
	level thread end_gameover_snapshot();
}

/*
	Name: sndsetzombiecontext
	Namespace: zm_audio
	Checksum: 0xFF5BBEFA
	Offset: 0x1070
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function sndsetzombiecontext(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self setsoundentcontext("grass", "no_grass");
	}
	else
	{
		self setsoundentcontext("grass", "in_grass");
	}
}

/*
	Name: sndzmblaststand
	Namespace: zm_audio
	Checksum: 0x8B345A0C
	Offset: 0x1110
	Size: 0x14C
	Parameters: 7
	Flags: Linked
*/
function sndzmblaststand(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playsound(localclientnum, "chr_health_laststand_enter", (0, 0, 0));
		self.inlaststand = 1;
		setsoundcontext("laststand", "active");
		if(!issplitscreen())
		{
			forceambientroom("sndHealth_LastStand");
		}
	}
	else
	{
		if(isdefined(self.inlaststand) && self.inlaststand)
		{
			playsound(localclientnum, "chr_health_laststand_exit", (0, 0, 0));
			self.inlaststand = 0;
			if(!issplitscreen())
			{
				forceambientroom("");
			}
		}
		setsoundcontext("laststand", "");
	}
}

