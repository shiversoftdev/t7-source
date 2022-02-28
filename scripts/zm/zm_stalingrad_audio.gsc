// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\music_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_stalingrad_dragon;

#namespace zm_stalingrad_audio;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_audio
	Checksum: 0x7AFF6E3C
	Offset: 0x600
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_audio
	Checksum: 0x72913155
	Offset: 0x640
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "ee_anthem_pa", 12000, 1, "int");
	clientfield::register("scriptmover", "ee_ballerina", 12000, 2, "int");
	level flag::init("ballerina_ready");
	level.var_bf88fef7 = 0;
	level.var_a31a784f = [];
	level.monkey_song_override = &function_24ff7a78;
}

/*
	Name: main
	Namespace: zm_stalingrad_audio
	Checksum: 0x3366125F
	Offset: 0x700
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_af4c67d();
	level thread function_41f49ee8();
	level thread function_5c7f73da();
	level thread function_7584d453();
	level thread function_663128e3();
	level thread function_ae93bb6d();
}

/*
	Name: on_player_spawned
	Namespace: zm_stalingrad_audio
	Checksum: 0x99EC1590
	Offset: 0x7A0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
}

/*
	Name: function_af4c67d
	Namespace: zm_stalingrad_audio
	Checksum: 0xD965837F
	Offset: 0x7B0
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_af4c67d()
{
	level.var_c128c3f5 = 0;
	level.var_9d74f1a7 = struct::get_array("side_ee_song_vodka", "targetname");
	array::thread_all(level.var_9d74f1a7, &function_5583a127);
	while(true)
	{
		level waittill(#"hash_9727ab41");
		if(level.var_c128c3f5 == level.var_9d74f1a7.size)
		{
			break;
		}
	}
	level thread zm_audio::sndmusicsystem_playstate("dead_ended");
}

/*
	Name: function_5583a127
	Namespace: zm_stalingrad_audio
	Checksum: 0x8026E513
	Offset: 0x870
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function function_5583a127()
{
	e_origin = spawn("script_origin", self.origin);
	e_origin zm_unitrigger::create_unitrigger();
	e_origin playloopsound("zmb_ee_mus_lp", 1);
	/#
		e_origin thread function_8faf1d24(vectorscale((0, 0, 1), 255), "");
	#/
	while(!(isdefined(e_origin.b_activated) && e_origin.b_activated))
	{
		e_origin waittill(#"trigger_activated");
		if(isdefined(level.musicsystem.currentplaytype) && level.musicsystem.currentplaytype >= 4 || (isdefined(level.musicsystemoverride) && level.musicsystemoverride))
		{
			continue;
		}
		e_origin function_81b46338();
	}
	zm_unitrigger::unregister_unitrigger(e_origin.s_unitrigger);
	e_origin delete();
}

/*
	Name: function_81b46338
	Namespace: zm_stalingrad_audio
	Checksum: 0x55C80692
	Offset: 0x9E0
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_81b46338()
{
	if(!(isdefined(self.b_activated) && self.b_activated))
	{
		self.b_activated = 1;
		level.var_c128c3f5++;
		level notify(#"hash_9727ab41");
		self stoploopsound(0.2);
	}
	self playsound("zmb_ee_mus_activate");
}

/*
	Name: function_41f49ee8
	Namespace: zm_stalingrad_audio
	Checksum: 0x830AAAA4
	Offset: 0xA68
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_41f49ee8()
{
	level.var_62e63d78 = 0;
	level.var_68982832 = struct::get_array("side_ee_song_card", "targetname");
	array::thread_all(level.var_68982832, &function_f021c688);
	while(true)
	{
		level waittill(#"hash_ce64d360");
		if(level.var_62e63d78 == level.var_68982832.size)
		{
			break;
		}
	}
	level thread zm_audio::sndmusicsystem_playstate("ace_of_spades");
}

/*
	Name: function_f021c688
	Namespace: zm_stalingrad_audio
	Checksum: 0x5C9A900A
	Offset: 0xB28
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_f021c688()
{
	self zm_unitrigger::create_unitrigger();
	/#
		self thread function_8faf1d24(vectorscale((0, 0, 1), 255), "");
	#/
	while(!(isdefined(self.b_activated) && self.b_activated))
	{
		self waittill(#"trigger_activated");
		if(isdefined(level.musicsystem.currentplaytype) && level.musicsystem.currentplaytype >= 4 || (isdefined(level.musicsystemoverride) && level.musicsystemoverride))
		{
			continue;
		}
		self.b_activated = 1;
		level.var_62e63d78++;
		level notify(#"hash_ce64d360");
		playsoundatposition("zmb_card_activate", self.origin);
	}
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
}

/*
	Name: function_8faf1d24
	Namespace: zm_stalingrad_audio
	Checksum: 0x566FD8DD
	Offset: 0xC50
	Size: 0x108
	Parameters: 4
	Flags: Linked
*/
function function_8faf1d24(v_color, var_8882142e, n_scale, str_endon)
{
	/#
		if(!isdefined(v_color))
		{
			v_color = vectorscale((0, 0, 1), 255);
		}
		if(!isdefined(var_8882142e))
		{
			var_8882142e = "";
		}
		if(!isdefined(n_scale))
		{
			n_scale = 0.25;
		}
		if(!isdefined(str_endon))
		{
			str_endon = "";
		}
		if(getdvarint("") == 0)
		{
			return;
		}
		if(isdefined(str_endon))
		{
			self endon(str_endon);
		}
		origin = self.origin;
		while(true)
		{
			print3d(origin, var_8882142e, v_color, n_scale);
			wait(0.1);
		}
	#/
}

/*
	Name: function_ae93bb6d
	Namespace: zm_stalingrad_audio
	Checksum: 0xC396D92E
	Offset: 0xD60
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_ae93bb6d()
{
	var_8e47507d = struct::get_array("creepyyuse", "targetname");
	if(!isdefined(var_8e47507d))
	{
		return;
	}
	array::thread_all(var_8e47507d, &function_d75eac4e);
}

/*
	Name: function_d75eac4e
	Namespace: zm_stalingrad_audio
	Checksum: 0xC29EAA49
	Offset: 0xDC8
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function function_d75eac4e()
{
	self zm_unitrigger::create_unitrigger(undefined, 50);
	while(true)
	{
		self waittill(#"trigger_activated");
		playsoundatposition(self.script_sound, self.origin);
		wait(200);
	}
}

/*
	Name: function_e01c1b04
	Namespace: zm_stalingrad_audio
	Checksum: 0x1371CEDF
	Offset: 0xE30
	Size: 0xEE
	Parameters: 1
	Flags: None
*/
function function_e01c1b04(var_99ad39b9)
{
	if(var_99ad39b9.size <= 0)
	{
		return;
	}
	while(true)
	{
		var_4237d65e = randomintrange(0, var_99ad39b9.size);
		var_99ad39b9[var_4237d65e] zm_unitrigger::create_unitrigger(undefined, 24);
		var_99ad39b9[var_4237d65e] waittill(#"trigger_activated");
		playsoundatposition(var_99ad39b9[var_4237d65e].script_sound, var_99ad39b9[var_4237d65e].origin);
		zm_unitrigger::unregister_unitrigger(var_99ad39b9[var_4237d65e].unitrigger);
		wait(150);
	}
}

/*
	Name: function_5c7f73da
	Namespace: zm_stalingrad_audio
	Checksum: 0x2662E74E
	Offset: 0xF28
	Size: 0x19E
	Parameters: 0
	Flags: Linked
*/
function function_5c7f73da()
{
	for(i = 1; i < 6; i++)
	{
		var_2de8cf5e = struct::get_array("ee_sophia_reels_" + i, "targetname");
		if(var_2de8cf5e.size <= 0)
		{
			return;
		}
		foreach(s_reel in var_2de8cf5e)
		{
			var_de6d4fc0 = util::spawn_model(s_reel.model, s_reel.origin, s_reel.angles);
			s_reel.var_de6d4fc0 = var_de6d4fc0;
			s_reel.var_de6d4fc0 thread function_e464aa51();
		}
		if(i == 5)
		{
			level thread function_8c75c164(var_2de8cf5e, i);
			continue;
		}
		level thread function_ab32c346(var_2de8cf5e, i);
	}
}

/*
	Name: function_ab32c346
	Namespace: zm_stalingrad_audio
	Checksum: 0xBB3FC38
	Offset: 0x10D0
	Size: 0xE0
	Parameters: 2
	Flags: Linked
*/
function function_ab32c346(var_2de8cf5e, var_bee8e45)
{
	var_2de8cf5e[0] zm_unitrigger::create_unitrigger();
	while(true)
	{
		var_2de8cf5e[0] waittill(#"trigger_activated", who);
		if(!who zm_utility::is_player_looking_at(var_2de8cf5e[0].origin))
		{
			continue;
		}
		function_ccdb680e(var_2de8cf5e, 1);
		var_2de8cf5e[0].var_de6d4fc0 function_8e130ce5(var_bee8e45);
		function_ccdb680e(var_2de8cf5e, 0);
	}
}

/*
	Name: function_8c75c164
	Namespace: zm_stalingrad_audio
	Checksum: 0x58FBBAAA
	Offset: 0x11B8
	Size: 0x180
	Parameters: 2
	Flags: Linked
*/
function function_8c75c164(var_2de8cf5e, var_bee8e45)
{
	var_2de8cf5e[0].var_de6d4fc0 setcandamage(1);
	while(true)
	{
		var_2de8cf5e[0].var_de6d4fc0.health = 1000000;
		var_2de8cf5e[0].var_de6d4fc0 waittill(#"damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(!isdefined(attacker) || !isplayer(attacker))
		{
			continue;
		}
		function_ccdb680e(var_2de8cf5e, 1);
		var_2de8cf5e[0].var_de6d4fc0 function_8e130ce5(var_bee8e45);
		function_ccdb680e(var_2de8cf5e, 0);
	}
}

/*
	Name: function_8e130ce5
	Namespace: zm_stalingrad_audio
	Checksum: 0xE4BDF452
	Offset: 0x1340
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function function_8e130ce5(var_bee8e45)
{
	self playsoundwithnotify("vox_soph_sophia_log_" + var_bee8e45, "sounddone");
	if(var_bee8e45 == 2)
	{
		self playsound("zmb_sophia_log_2_sfx");
	}
	self waittill(#"sounddone");
}

/*
	Name: function_ccdb680e
	Namespace: zm_stalingrad_audio
	Checksum: 0xF25FDBE1
	Offset: 0x13B0
	Size: 0xB2
	Parameters: 2
	Flags: Linked
*/
function function_ccdb680e(var_2de8cf5e, b_on)
{
	foreach(s_reel in var_2de8cf5e)
	{
		if(isdefined(s_reel.var_de6d4fc0))
		{
			s_reel.var_de6d4fc0.var_a02b0d5a = b_on;
		}
	}
}

/*
	Name: function_e464aa51
	Namespace: zm_stalingrad_audio
	Checksum: 0xF8C30B1A
	Offset: 0x1470
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_e464aa51()
{
	while(true)
	{
		if(isdefined(self.var_a02b0d5a) && self.var_a02b0d5a)
		{
			self rotateroll(-30, 0.2);
		}
		wait(0.2);
	}
}

/*
	Name: function_7584d453
	Namespace: zm_stalingrad_audio
	Checksum: 0x95EA34CB
	Offset: 0x14C8
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_7584d453()
{
	level waittill(#"hash_9b1cee4c");
	var_18b908ea = spawn("script_origin", (0, 0, 0));
	var_18b908ea playloopsound("zmb_outro_battle_bg", 1);
	level waittill(#"hash_846351df");
	var_18b908ea stoploopsound(1);
	var_18b908ea delete();
}

/*
	Name: function_f1ce2a9a
	Namespace: zm_stalingrad_audio
	Checksum: 0xD231F800
	Offset: 0x1570
	Size: 0x152
	Parameters: 1
	Flags: Linked
*/
function function_f1ce2a9a(state = 0)
{
	level endon(#"end_game");
	switch(state)
	{
		case 1:
		{
			level.musicsystemoverride = 1;
			music::setmusicstate("none");
			level thread function_61c5cb4e();
			break;
		}
		case 2:
		{
			level thread function_9fa22cf7();
			music::setmusicstate("ace_of_spades");
			level thread function_d0e8b85d();
			break;
		}
		case 3:
		{
			level thread function_9fa22cf7();
			music::setmusicstate("nikolai_fight");
			break;
		}
		case 4:
		{
			level thread function_9fa22cf7();
			music::setmusicstate("none");
			level.musicsystemoverride = 0;
			break;
		}
	}
}

/*
	Name: function_61c5cb4e
	Namespace: zm_stalingrad_audio
	Checksum: 0x915AE2EB
	Offset: 0x16D0
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_61c5cb4e()
{
	level endon(#"hash_787a404e");
	var_4540293a = struct::get_array("s_anthem_array", "targetname");
	level.var_96d76bfc = 0;
	level.var_c9c5dfcc = var_4540293a.size;
	foreach(var_71f55e40 in var_4540293a)
	{
		var_71f55e40 thread function_3b8ba4e9();
	}
	wait(68.7);
	level thread function_f1ce2a9a(3);
}

/*
	Name: function_3b8ba4e9
	Namespace: zm_stalingrad_audio
	Checksum: 0xCADCEC43
	Offset: 0x17D8
	Size: 0x20A
	Parameters: 0
	Flags: Linked
*/
function function_3b8ba4e9()
{
	level endon(#"hash_787a404e");
	self.var_1431218c = util::spawn_model(self.model, self.origin, self.angles);
	self.var_1431218c clientfield::set("ee_anthem_pa", 1);
	self.var_1431218c setcandamage(1);
	if(1)
	{
		for(;;)
		{
			self.var_1431218c.health = 1000000;
			self.var_1431218c waittill(#"damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		}
		if(!isdefined(attacker) || !isplayer(attacker))
		{
		}
		self.var_1431218c clientfield::set("ee_anthem_pa", 0);
		self.var_1431218c playsound("zmb_nikolai_mus_pa_destruct");
		util::wait_network_frame();
		self.var_1431218c delete();
		self.var_1431218c = undefined;
		level.var_96d76bfc++;
		if(level.var_96d76bfc >= level.var_c9c5dfcc)
		{
			level thread function_f1ce2a9a(2);
		}
		return;
	}
}

/*
	Name: function_9fa22cf7
	Namespace: zm_stalingrad_audio
	Checksum: 0x425D82AF
	Offset: 0x19F0
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function function_9fa22cf7()
{
	level notify(#"hash_787a404e");
	var_4540293a = struct::get_array("s_anthem_array", "targetname");
	foreach(var_71f55e40 in var_4540293a)
	{
		if(isdefined(var_71f55e40.var_1431218c))
		{
			var_71f55e40.var_1431218c clientfield::set("ee_anthem_pa", 0);
			util::wait_network_frame();
			var_71f55e40.var_1431218c delete();
			var_71f55e40.var_1431218c = undefined;
		}
	}
}

/*
	Name: function_d0e8b85d
	Namespace: zm_stalingrad_audio
	Checksum: 0x5C143296
	Offset: 0x1B20
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_d0e8b85d()
{
	level endon(#"hash_787a404e");
	level endon(#"end_game");
	wait(170);
	music::setmusicstate("nikolai_fight");
}

/*
	Name: function_663128e3
	Namespace: zm_stalingrad_audio
	Checksum: 0x5073DE6B
	Offset: 0x1B68
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_663128e3()
{
	level flag::wait_till("ballerina_ready");
	wait(8);
	level function_6b495bd6();
	while(true)
	{
		success = level function_4c503dc7();
		if(!(isdefined(success) && success))
		{
			level function_6b495bd6(1);
			continue;
		}
		level function_d64d6d35();
		break;
	}
	level thread zm_audio::sndmusicsystem_playstate("sam");
}

/*
	Name: function_6b495bd6
	Namespace: zm_stalingrad_audio
	Checksum: 0x1238579D
	Offset: 0x1C48
	Size: 0x23C
	Parameters: 1
	Flags: Linked
*/
function function_6b495bd6(restart = 0)
{
	s_ballerina_start = struct::get("s_ballerina_start", "targetname");
	if(!(isdefined(restart) && restart))
	{
		playsoundatposition("zmb_sam_egg_success", (0, 0, 0));
		var_ac086ffb = util::spawn_model(s_ballerina_start.model, s_ballerina_start.origin - vectorscale((0, 0, 1), 20), s_ballerina_start.angles);
		var_ac086ffb clientfield::set("ee_ballerina", 2);
		var_ac086ffb moveto(s_ballerina_start.origin, 2);
		var_ac086ffb waittill(#"movedone");
	}
	else
	{
		playsoundatposition("zmb_sam_egg_fail", (0, 0, 0));
		var_ac086ffb = util::spawn_model(s_ballerina_start.model, s_ballerina_start.origin, s_ballerina_start.angles);
		var_ac086ffb clientfield::set("ee_ballerina", 1);
	}
	s_ballerina_start zm_unitrigger::create_unitrigger(undefined, 24);
	s_ballerina_start waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(s_ballerina_start.unitrigger);
	var_ac086ffb clientfield::set("ee_ballerina", 0);
	util::wait_network_frame();
	var_ac086ffb delete();
}

/*
	Name: function_4c503dc7
	Namespace: zm_stalingrad_audio
	Checksum: 0xAB83C220
	Offset: 0x1E90
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_4c503dc7()
{
	var_d1f154fd = struct::get_array("s_ballerina_timed", "targetname");
	var_d1f154fd = array::randomize(var_d1f154fd);
	for(i = 0; i < 5; i++)
	{
		success = var_d1f154fd[i] function_dc391fc3();
		if(!(isdefined(success) && success))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_dc391fc3
	Namespace: zm_stalingrad_audio
	Checksum: 0x5121DEC4
	Offset: 0x1F50
	Size: 0x19A
	Parameters: 0
	Flags: Linked
*/
function function_dc391fc3()
{
	self.var_ac086ffb = util::spawn_model(self.model, self.origin, self.angles);
	self.var_ac086ffb clientfield::set("ee_ballerina", 1);
	self.var_ac086ffb playloopsound("mus_stalingrad_musicbox_lp", 2);
	self.success = 0;
	self thread function_631d8c1();
	self thread function_75442852();
	self thread function_db914e();
	/#
		self.var_ac086ffb thread zm_utility::print3d_ent("", (0, 1, 0), 3, vectorscale((0, 0, 1), 24));
	#/
	self util::waittill_any("ballerina_destroyed", "ballerina_timeout");
	/#
		self.var_ac086ffb notify(#"end_print3d");
	#/
	self.var_ac086ffb clientfield::set("ee_ballerina", 0);
	util::wait_network_frame();
	self.var_ac086ffb delete();
	return self.success;
}

/*
	Name: function_631d8c1
	Namespace: zm_stalingrad_audio
	Checksum: 0x19790812
	Offset: 0x20F8
	Size: 0x66
	Parameters: 0
	Flags: Linked
*/
function function_631d8c1()
{
	self.var_ac086ffb endon(#"death");
	self endon(#"hash_636d801f");
	self endon(#"ballerina_destroyed");
	self endon(#"ballerina_timeout");
	while(true)
	{
		self.var_ac086ffb rotateyaw(360, 4);
		wait(4);
	}
}

/*
	Name: function_75442852
	Namespace: zm_stalingrad_audio
	Checksum: 0x2A5EA599
	Offset: 0x2168
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function function_75442852()
{
	self endon(#"ballerina_timeout");
	self.var_ac086ffb setcandamage(1);
	self.var_ac086ffb.health = 1000000;
	while(true)
	{
		self.var_ac086ffb waittill(#"damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(!isdefined(attacker) || !isplayer(attacker))
		{
			continue;
		}
		self.success = 1;
		self notify(#"ballerina_destroyed");
		break;
	}
}

/*
	Name: function_db914e
	Namespace: zm_stalingrad_audio
	Checksum: 0xCF26EF3F
	Offset: 0x2298
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function function_db914e()
{
	self endon(#"ballerina_destroyed");
	if(level.players.size > 1)
	{
		wait(90 - (15 * level.players.size));
	}
	else
	{
		wait(90);
	}
	self notify(#"ballerina_timeout");
}

/*
	Name: function_d64d6d35
	Namespace: zm_stalingrad_audio
	Checksum: 0xFEBB029
	Offset: 0x22F8
	Size: 0x534
	Parameters: 0
	Flags: Linked
*/
function function_d64d6d35()
{
	playsoundatposition("zmb_sam_egg_success", (0, 0, 0));
	s_ballerina_end = struct::get("s_ballerina_end", "targetname");
	s_ballerina_end.var_ac086ffb = util::spawn_model(s_ballerina_end.model, s_ballerina_end.origin, s_ballerina_end.angles);
	s_ballerina_end.var_ac086ffb clientfield::set("ee_ballerina", 1);
	s_ballerina_end.var_ac086ffb playloopsound("mus_stalingrad_musicbox_lp", 2);
	s_ballerina_end thread function_631d8c1();
	s_ballerina_end zm_unitrigger::create_unitrigger(undefined, 65);
	s_ballerina_end waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(s_ballerina_end.unitrigger);
	s_ballerina_end notify(#"hash_636d801f");
	s_ballerina_end.var_ac086ffb stoploopsound(0.5);
	s_ballerina_end.var_ac086ffb playsound("zmb_challenge_skel_arm_up");
	var_f6c28cea = (2, 0, -6.5);
	var_e97ebb83 = (3.5, 0, -18.5);
	s_ballerina_end.var_3609adde = util::spawn_model("c_zom_dlc1_skeleton_zombie_body_s_rarm", s_ballerina_end.origin, s_ballerina_end.angles);
	s_ballerina_end.var_2a9b65c7 = util::spawn_model("p7_skulls_bones_arm_lower", s_ballerina_end.origin + var_f6c28cea, vectorscale((1, 0, 0), 180));
	s_ballerina_end.var_79dc7980 = util::spawn_model("p7_skulls_bones_arm_lower", s_ballerina_end.origin + var_e97ebb83, vectorscale((1, 0, 0), 180));
	s_ballerina_end.var_ac086ffb movez(20, 0.5);
	s_ballerina_end.var_3609adde movez(20, 0.5);
	s_ballerina_end.var_2a9b65c7 movez(20, 0.5);
	s_ballerina_end.var_79dc7980 movez(20, 0.5);
	wait(0.05);
	s_ballerina_end.var_3609adde clientfield::increment("challenge_arm_reveal");
	s_ballerina_end.var_3609adde waittill(#"movedone");
	wait(1);
	s_ballerina_end.var_ac086ffb playloopsound("zmb_challenge_skel_arm_lp", 0.25);
	s_ballerina_end.var_ac086ffb movez(-30, 1.5);
	s_ballerina_end.var_3609adde movez(-30, 1.5);
	s_ballerina_end.var_2a9b65c7 movez(-30, 1.5);
	s_ballerina_end.var_79dc7980 movez(-30, 1.5);
	s_ballerina_end.var_ac086ffb waittill(#"movedone");
	zm_powerups::specific_powerup_drop("full_ammo", s_ballerina_end.origin);
	s_ballerina_end.var_ac086ffb delete();
	s_ballerina_end.var_3609adde delete();
	s_ballerina_end.var_2a9b65c7 delete();
	s_ballerina_end.var_79dc7980 delete();
}

/*
	Name: function_24ff7a78
	Namespace: zm_stalingrad_audio
	Checksum: 0x842C09E2
	Offset: 0x2838
	Size: 0x13C
	Parameters: 2
	Flags: Linked
*/
function function_24ff7a78(owner, weapon)
{
	var_c4311d6f = dragon::function_69a0541c();
	if(isdefined(var_c4311d6f))
	{
		if(array::contains(level.var_a31a784f, var_c4311d6f))
		{
			return false;
		}
		var_12bd8497 = getent(var_c4311d6f + "_1_damage", "targetname");
		if(isdefined(var_12bd8497.var_3eb19318) && var_12bd8497.var_3eb19318 && self istouching(var_12bd8497))
		{
			array::add(level.var_a31a784f, var_c4311d6f);
			level.var_bf88fef7++;
			if(level.var_bf88fef7 >= 3)
			{
				level flag::set("ballerina_ready");
				level.monkey_song_override = undefined;
				return true;
			}
			return true;
		}
	}
	return false;
}

