// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_tomb_amb;

/*
	Name: init
	Namespace: zm_tomb_amb
	Checksum: 0xBCD9BC1
	Offset: 0x478
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("toplayer", "sndEggElements", 21000, 1, "int");
	level.var_61f315ab = &function_3630300b;
	level.var_8229c449 = &function_231d9741;
	level.zmannouncerprefix = "vox_zmbat_";
}

/*
	Name: main
	Namespace: zm_tomb_amb
	Checksum: 0x36521491
	Offset: 0x4F8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread sndmusicegg();
	level thread snd115egg();
	level thread sndstingersetup();
	level thread sndmaelstrom();
	level thread function_45b4acf2();
}

/*
	Name: sndstingersetup
	Namespace: zm_tomb_amb
	Checksum: 0xB22D4C26
	Offset: 0x580
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function sndstingersetup()
{
	level.sndroundwait = 1;
	level flag::wait_till("start_zombie_round_logic");
	level thread sndstingerroundwait();
	level thread locationstingerwait();
	level thread snddoormusictrigs();
}

/*
	Name: sndstingersetupstates
	Namespace: zm_tomb_amb
	Checksum: 0x99EC1590
	Offset: 0x600
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function sndstingersetupstates()
{
}

/*
	Name: locationstingerwait
	Namespace: zm_tomb_amb
	Checksum: 0xD1743BDC
	Offset: 0x610
	Size: 0x194
	Parameters: 2
	Flags: Linked
*/
function locationstingerwait(zone_name, type)
{
	array = sndlocationsarray();
	sndnorepeats = 3;
	numcut = 0;
	level.sndlastzone = undefined;
	level.sndlocationplayed = 0;
	level thread sndlocationbetweenroundswait();
	while(true)
	{
		level waittill(#"newzoneactive", activezone);
		wait(0.1);
		if(!sndlocationshouldplay(array, activezone))
		{
			continue;
		}
		if(isdefined(level.sndroundwait) && level.sndroundwait)
		{
			continue;
		}
		level thread sndplaystinger(activezone);
		level.sndlocationplayed = 1;
		array = sndcurrentlocationarray(array, activezone, numcut, sndnorepeats);
		level.sndlastzone = activezone;
		if(numcut >= sndnorepeats)
		{
			numcut = 0;
		}
		else
		{
			numcut++;
		}
		level waittill(#"between_round_over");
		while(isdefined(level.sndroundwait) && level.sndroundwait)
		{
			wait(0.1);
		}
		level.sndlocationplayed = 0;
	}
}

/*
	Name: sndlocationsarray
	Namespace: zm_tomb_amb
	Checksum: 0x72CE64E3
	Offset: 0x7B0
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function sndlocationsarray()
{
	array = [];
	array[0] = "zone_nml_18";
	array[1] = "zone_village_2";
	array[2] = "ug_bottom_zone";
	array[3] = "zone_air_stairs";
	array[4] = "zone_fire_stairs";
	array[5] = "zone_bolt_stairs";
	array[6] = "zone_ice_stairs";
	return array;
}

/*
	Name: sndlocationshouldplay
	Namespace: zm_tomb_amb
	Checksum: 0x93B8378F
	Offset: 0x858
	Size: 0x1DE
	Parameters: 2
	Flags: Linked
*/
function sndlocationshouldplay(array, activezone)
{
	shouldplay = 0;
	if(!zm_audio_zhd::function_8090042c())
	{
		return shouldplay;
	}
	foreach(place in array)
	{
		if(place == activezone)
		{
			shouldplay = 1;
		}
	}
	if(shouldplay == 0)
	{
		return shouldplay;
	}
	playersinlocal = 0;
	players = getplayers();
	foreach(player in players)
	{
		if(player zm_zonemgr::entity_in_zone(activezone))
		{
			if(!(isdefined(player.afterlife) && player.afterlife))
			{
				playersinlocal++;
			}
		}
	}
	if(playersinlocal >= 1)
	{
		shouldplay = 1;
	}
	else
	{
		shouldplay = 0;
	}
	return shouldplay;
}

/*
	Name: sndstingerroundwait
	Namespace: zm_tomb_amb
	Checksum: 0x4797A58D
	Offset: 0xA40
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function sndstingerroundwait()
{
	wait(25);
	level.sndroundwait = 0;
	while(true)
	{
		level waittill(#"end_of_round");
		level thread sndstingerroundwait_start();
	}
}

/*
	Name: sndstingerroundwait_start
	Namespace: zm_tomb_amb
	Checksum: 0xD29B1E9E
	Offset: 0xA88
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function sndstingerroundwait_start()
{
	level.sndroundwait = 1;
	wait(0.05);
	level thread sndstingerroundwait_end();
}

/*
	Name: sndstingerroundwait_end
	Namespace: zm_tomb_amb
	Checksum: 0x48BAAB53
	Offset: 0xAC0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function sndstingerroundwait_end()
{
	level endon(#"end_of_round");
	level waittill(#"between_round_over");
	wait(28);
	level.sndroundwait = 0;
}

/*
	Name: sndcurrentlocationarray
	Namespace: zm_tomb_amb
	Checksum: 0x971B12B
	Offset: 0xAF8
	Size: 0xEA
	Parameters: 4
	Flags: Linked
*/
function sndcurrentlocationarray(current_array, activezone, numcut, max_num_removed)
{
	if(numcut >= max_num_removed)
	{
		current_array = sndlocationsarray();
	}
	foreach(place in current_array)
	{
		if(place == activezone)
		{
			arrayremovevalue(current_array, place);
			break;
		}
	}
	return current_array;
}

/*
	Name: sndlocationbetweenrounds
	Namespace: zm_tomb_amb
	Checksum: 0x795379FD
	Offset: 0xBF0
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function sndlocationbetweenrounds()
{
	level endon(#"newzoneactive");
	activezones = zm_zonemgr::get_active_zone_names();
	foreach(zone in activezones)
	{
		if(isdefined(level.sndlastzone) && zone == level.sndlastzone)
		{
			continue;
		}
		players = getplayers();
		foreach(player in players)
		{
			if(player zm_zonemgr::entity_in_zone(zone))
			{
				wait(0.1);
				level notify(#"newzoneactive", zone);
				return;
			}
		}
	}
}

/*
	Name: sndlocationbetweenroundswait
	Namespace: zm_tomb_amb
	Checksum: 0x39759D54
	Offset: 0xD80
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function sndlocationbetweenroundswait()
{
	while(isdefined(level.sndroundwait) && level.sndroundwait)
	{
		wait(0.1);
	}
	while(true)
	{
		level thread sndlocationbetweenrounds();
		level waittill(#"between_round_over");
		while(isdefined(level.sndroundwait) && level.sndroundwait)
		{
			wait(0.1);
		}
	}
}

/*
	Name: sndplaystinger
	Namespace: zm_tomb_amb
	Checksum: 0x1AAFB04
	Offset: 0xE00
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function sndplaystinger(state)
{
	if(!zm_audio_zhd::function_8090042c())
	{
		return;
	}
	level thread zm_audio::sndmusicsystem_playstate(state);
}

/*
	Name: sndplaystingerwithoverride
	Namespace: zm_tomb_amb
	Checksum: 0xB9C56077
	Offset: 0xE48
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function sndplaystingerwithoverride(state, var_70f98722)
{
	if(!zm_audio_zhd::function_8090042c())
	{
		return;
	}
	level thread zm_audio::sndmusicsystem_playstate(state);
}

/*
	Name: snddoormusictrigs
	Namespace: zm_tomb_amb
	Checksum: 0x5FA32EB9
	Offset: 0xE98
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function snddoormusictrigs()
{
	trigs = getentarray("sndMusicDoor", "script_noteworthy");
	foreach(trig in trigs)
	{
		trig thread snddoormusic();
	}
}

/*
	Name: snddoormusic
	Namespace: zm_tomb_amb
	Checksum: 0x701CF535
	Offset: 0xF58
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function snddoormusic()
{
	self endon(#"snddoormusic_triggered");
	while(true)
	{
		self waittill(#"trigger");
		if(!zm_audio_zhd::function_8090042c())
		{
			wait(0.1);
			continue;
		}
		else
		{
			break;
		}
	}
	if(isdefined(self.target))
	{
		ent = getent(self.target, "targetname");
		ent notify(#"snddoormusic_triggered");
	}
	level thread sndplaystingerwithoverride(self.script_sound);
}

/*
	Name: sndmaelstrom
	Namespace: zm_tomb_amb
	Checksum: 0xF021D8B9
	Offset: 0x1018
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function sndmaelstrom()
{
	trig = getent("sndMaelstrom", "targetname");
	if(!isdefined(trig))
	{
		return;
	}
	while(true)
	{
		trig waittill(#"trigger", who);
		if(isplayer(who) && (!(isdefined(who.sndmaelstrom) && who.sndmaelstrom)))
		{
			who.sndmaelstrom = 1;
			who clientfield::set_to_player("sndMaelstrom", 1);
		}
		who thread sndmaelstrom_timeout();
		wait(0.1);
	}
}

/*
	Name: sndmaelstrom_timeout
	Namespace: zm_tomb_amb
	Checksum: 0x65FDA3AF
	Offset: 0x1118
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function sndmaelstrom_timeout()
{
	self notify(#"sndmaelstrom_timeout");
	self endon(#"sndmaelstrom_timeout");
	self endon(#"disconnect");
	wait(2);
	self.sndmaelstrom = 0;
	self clientfield::set_to_player("sndMaelstrom", 0);
}

/*
	Name: sndmusicegg
	Namespace: zm_tomb_amb
	Checksum: 0x104BDC26
	Offset: 0x1180
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function sndmusicegg()
{
	level thread zm_audio_zhd::function_e753d4f();
	level flag::wait_till("snd_song_completed");
	level thread zm_audio::sndmusicsystem_playstate("archangel");
}

/*
	Name: snd115egg
	Namespace: zm_tomb_amb
	Checksum: 0x74530A74
	Offset: 0x11E8
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function snd115egg()
{
	n_count = 0;
	level.var_69a8687 = 0;
	var_8bd44282 = struct::get_array("mus115", "targetname");
	array::thread_all(var_8bd44282, &function_89a607c3);
	while(n_count < 3)
	{
		level waittill(#"hash_34d7d690");
		n_count++;
	}
	level thread zm_audio::sndmusicsystem_playstate("aether");
	level notify(#"hash_c598ee9d");
}

/*
	Name: function_89a607c3
	Namespace: zm_tomb_amb
	Checksum: 0xD09253E1
	Offset: 0x12B8
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_89a607c3()
{
	level endon(#"hash_c598ee9d");
	var_169695f4 = array(1, 1, 5);
	self thread zm_sidequests::fake_use("115_trig_activated", &function_f36e092d);
	self waittill(#"115_trig_activated");
	playsoundatposition("zmb_ee_mus_activate", self.origin);
	level.var_69a8687++;
	level notify(#"hash_34d7d690");
}

/*
	Name: function_f36e092d
	Namespace: zm_tomb_amb
	Checksum: 0x4DF83568
	Offset: 0x1370
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_f36e092d()
{
	if(!zm_audio_zhd::function_8090042c())
	{
		return false;
	}
	if(self getstance() != "prone")
	{
		return false;
	}
	return true;
}

/*
	Name: function_45b4acf2
	Namespace: zm_tomb_amb
	Checksum: 0x8C8E873A
	Offset: 0x13B8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_45b4acf2()
{
	level thread function_ada4c741();
	level thread function_87c575b6();
}

/*
	Name: function_ada4c741
	Namespace: zm_tomb_amb
	Checksum: 0xE67A7B3C
	Offset: 0x13F8
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function function_ada4c741()
{
	level endon(#"snd_zhdegg_activate");
	while(true)
	{
		level waittill(#"player_zombie_blood", e_player);
		e_player clientfield::set_to_player("sndEggElements", 1);
		e_player thread function_42354338();
	}
}

/*
	Name: function_42354338
	Namespace: zm_tomb_amb
	Checksum: 0xB60AFC3C
	Offset: 0x1470
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_42354338()
{
	self endon(#"death");
	self endon(#"disconnect");
	self waittill(#"zombie_blood_over");
	self clientfield::set_to_player("sndEggElements", 0);
}

/*
	Name: function_87c575b6
	Namespace: zm_tomb_amb
	Checksum: 0xD77D938E
	Offset: 0x14C0
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_87c575b6()
{
	var_e5e0779d = struct::get_array("s_zhdegg_elements", "targetname");
	if(var_e5e0779d.size <= 0)
	{
		return;
	}
	array::thread_all(var_e5e0779d, &function_66aff463);
	for(var_f2633d7f = 0; var_f2633d7f < var_e5e0779d.size; var_f2633d7f++)
	{
		level waittill(#"hash_556250a8");
	}
	level flag::set("snd_zhdegg_activate");
}

/*
	Name: function_66aff463
	Namespace: zm_tomb_amb
	Checksum: 0x368162B6
	Offset: 0x1580
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function function_66aff463()
{
	var_8e7ce497 = spawn("trigger_damage", self.origin, 0, 15, 50);
	while(true)
	{
		var_8e7ce497 waittill(#"damage", amount, inflictor, direction, point, type, tagname, modelname, partname, weapon);
		if(isplayer(inflictor) && issubstr(weapon.name, "staff_" + self.script_string))
		{
			level notify(#"hash_556250a8");
			level util::clientnotify("snd" + self.script_string);
			break;
		}
	}
	var_8e7ce497 delete();
}

/*
	Name: function_3630300b
	Namespace: zm_tomb_amb
	Checksum: 0x23EF15BC
	Offset: 0x16E0
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function function_3630300b()
{
	var_d1f154fd = struct::get_array("s_ballerina_timed", "targetname");
	var_d1f154fd = array::sort_by_script_int(var_d1f154fd, 1);
	level.var_aa39de8 = 0;
	wait(1);
	foreach(var_6d450235 in var_d1f154fd)
	{
		var_6d450235 thread function_b8227f87();
		wait(1);
	}
	while(level.var_aa39de8 < var_d1f154fd.size)
	{
		wait(0.1);
	}
	wait(1);
	return true;
}

/*
	Name: function_b8227f87
	Namespace: zm_tomb_amb
	Checksum: 0x93968A68
	Offset: 0x1808
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_b8227f87()
{
	self.var_ac086ffb = util::spawn_model(self.model, self.origin, self.angles);
	self.var_ac086ffb clientfield::set("snd_zhdegg", 1);
	self.var_ac086ffb playloopsound("mus_musicbox_lp", 2);
	self thread zm_audio_zhd::function_9d55fd08();
	self thread zm_audio_zhd::function_2fdaabf3();
	self util::waittill_any("ballerina_destroyed");
	level.var_aa39de8++;
	self.var_ac086ffb clientfield::set("snd_zhdegg", 0);
	util::wait_network_frame();
	self.var_ac086ffb delete();
}

/*
	Name: function_231d9741
	Namespace: zm_tomb_amb
	Checksum: 0x939FF91D
	Offset: 0x1938
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_231d9741()
{
	playsoundatposition("zmb_sam_egg_success", (0, 0, 0));
	wait(3);
	s_ballerina_end = struct::get("s_ballerina_end", "targetname");
	s_ballerina_end thread function_69f032ca();
	s_ballerina_end waittill(#"hash_3a53ac43");
	zm_powerups::specific_powerup_drop("full_ammo", s_ballerina_end.origin);
	level flag::set("snd_zhdegg_completed");
}

/*
	Name: function_69f032ca
	Namespace: zm_tomb_amb
	Checksum: 0x17910BF8
	Offset: 0x1A08
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_69f032ca()
{
	self endon(#"hash_34014bea");
	self.var_ac086ffb = util::spawn_model(self.model, self.origin, self.angles);
	self.var_ac086ffb clientfield::set("snd_zhdegg", 1);
	self thread zm_audio_zhd::function_9d55fd08();
	self.var_ac086ffb playloopsound("mus_musicbox_lp", 2);
	var_209d26c2 = struct::get(self.target, "targetname");
	self thread function_bec55ee6();
	self.var_ac086ffb moveto(var_209d26c2.origin, 25, 10);
	self.var_ac086ffb waittill(#"movedone");
	self notify(#"hash_3a53ac43");
	self.var_ac086ffb clientfield::set("snd_zhdegg", 0);
	util::wait_network_frame();
	self.var_ac086ffb delete();
}

/*
	Name: function_bec55ee6
	Namespace: zm_tomb_amb
	Checksum: 0xF34F6004
	Offset: 0x1B90
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function function_bec55ee6()
{
	self endon(#"hash_3a53ac43");
	self.var_ac086ffb setcandamage(1);
	self.var_ac086ffb.health = 1000000;
	while(true)
	{
		self.var_ac086ffb waittill(#"damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(!isdefined(attacker) || !isplayer(attacker))
		{
			continue;
		}
		if(type == "MOD_PROJECTILE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_GRENADE" || type == "MOD_EXPLOSIVE")
		{
			continue;
		}
		self notify(#"hash_34014bea");
		self.var_ac086ffb clientfield::set("snd_zhdegg", 0);
		util::wait_network_frame();
		self.var_ac086ffb delete();
		self thread function_69f032ca();
		break;
	}
}

