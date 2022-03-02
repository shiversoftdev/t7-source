// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod_craftables;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_smashables;
#using scripts\zm\zm_zod_util;

#namespace zm_zod_vo;

/*
	Name: __init__sytem__
	Namespace: zm_zod_vo
	Checksum: 0x544BDDE9
	Offset: 0x1DD0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_vo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_vo
	Checksum: 0x48F37315
	Offset: 0x1E10
	Size: 0x43C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	level.a_e_speakers = [];
	level flag::init("story_vo_playing");
	level thread function_50460ed1();
	level thread function_7884e6b8();
	level.var_95981590 = undefined;
	level thread function_2cc571f6();
	level thread function_f8939df5();
	level thread function_f9003879("visited_workshop");
	level thread function_f9003879("visited_gym");
	level thread function_f9003879("visited_burlesque");
	level thread function_f9003879("visited_ruby");
	level thread function_e8972612();
	level.var_f8b68299 = [];
	if(!isdefined(level.var_f8b68299))
	{
		level.var_f8b68299 = [];
	}
	else if(!isarray(level.var_f8b68299))
	{
		level.var_f8b68299 = array(level.var_f8b68299);
	}
	level.var_f8b68299[level.var_f8b68299.size] = "vox_shad_keepers_defeated_0";
	if(!isdefined(level.var_f8b68299))
	{
		level.var_f8b68299 = [];
	}
	else if(!isarray(level.var_f8b68299))
	{
		level.var_f8b68299 = array(level.var_f8b68299);
	}
	level.var_f8b68299[level.var_f8b68299.size] = "vox_shad_keepers_defeated_1";
	if(!isdefined(level.var_f8b68299))
	{
		level.var_f8b68299 = [];
	}
	else if(!isarray(level.var_f8b68299))
	{
		level.var_f8b68299 = array(level.var_f8b68299);
	}
	level.var_f8b68299[level.var_f8b68299.size] = "vox_shad_keepers_defeated_2";
	if(!isdefined(level.var_f8b68299))
	{
		level.var_f8b68299 = [];
	}
	else if(!isarray(level.var_f8b68299))
	{
		level.var_f8b68299 = array(level.var_f8b68299);
	}
	level.var_f8b68299[level.var_f8b68299.size] = "vox_shad_keepers_defeated_3";
	if(!isdefined(level.var_f8b68299))
	{
		level.var_f8b68299 = [];
	}
	else if(!isarray(level.var_f8b68299))
	{
		level.var_f8b68299 = array(level.var_f8b68299);
	}
	level.var_f8b68299[level.var_f8b68299.size] = "vox_shad_keepers_defeated_4";
	level flag::init("vo_beastmode_hint");
	level thread vo_beastmode_hint();
	level thread vo_placeworm_hint();
	level.audio_get_mod_type = &custom_get_mod_type;
	level.custom_door_deny_vo_func = &function_33bc3cb3;
	level._magic_box_used_vo = &zod_magic_box_used_vo;
}

/*
	Name: on_player_spawned
	Namespace: zm_zod_vo
	Checksum: 0xDC08B239
	Offset: 0x2258
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self.isspeaking = 0;
	self.n_vo_priority = 0;
	self.var_aefa986d = 0;
	self.var_5a34308d = array(0, 1, 2, 3, 4);
	self.var_5a34308d = array::randomize(self.var_5a34308d);
	self.var_f5df7d5f = 0;
}

/*
	Name: on_player_connect
	Namespace: zm_zod_vo
	Checksum: 0x99EC1590
	Offset: 0x22E0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: function_aca1bc0c
	Namespace: zm_zod_vo
	Checksum: 0x60FD9E5E
	Offset: 0x22F0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_aca1bc0c(n_gun_index)
{
	var_af1cee3 = function_766f6914(n_gun_index);
	str_line = "vox_idgun_greet_player_" + var_af1cee3;
	self function_1a180bd3(str_line);
}

/*
	Name: function_1a180bd3
	Namespace: zm_zod_vo
	Checksum: 0x12225766
	Offset: 0x2360
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_1a180bd3(str_line)
{
	function_a59cecd7();
	self function_cf8fccfe(1);
	self function_7b697614(str_line);
}

/*
	Name: function_1f2b0c20
	Namespace: zm_zod_vo
	Checksum: 0x1669FE0E
	Offset: 0x23B8
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function function_1f2b0c20(var_5140f86e, n_sword_level)
{
	function_a59cecd7();
	self function_cf8fccfe(1);
	str_vo = (("vox_sword" + n_sword_level) + "_greet_player_") + var_5140f86e;
	self function_7b697614(str_vo, 0, 1);
}

/*
	Name: function_766f6914
	Namespace: zm_zod_vo
	Checksum: 0x6406066A
	Offset: 0x2448
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function function_766f6914(n_gun_index)
{
	switch(level.idgun[n_gun_index].str_wpnname)
	{
		case "idgun_0":
		{
			return 0;
		}
		case "idgun_1":
		{
			return 1;
		}
		case "idgun_2":
		{
			return 2;
		}
		case "idgun_3":
		{
			return 3;
		}
	}
}

/*
	Name: function_a59cecd7
	Namespace: zm_zod_vo
	Checksum: 0x156BD007
	Offset: 0x24B8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_a59cecd7()
{
	while(level flag::get("story_vo_playing"))
	{
		wait(0.1);
	}
}

/*
	Name: function_218256bd
	Namespace: zm_zod_vo
	Checksum: 0xB45D5EFB
	Offset: 0x24F8
	Size: 0x16A
	Parameters: 1
	Flags: Linked
*/
function function_218256bd(var_eca8128e)
{
	foreach(player in level.activeplayers)
	{
		if(isdefined(player))
		{
			player.dontspeak = var_eca8128e;
			player clientfield::set_to_player("isspeaking", var_eca8128e);
		}
	}
	if(var_eca8128e)
	{
		foreach(player in level.activeplayers)
		{
			while(isdefined(player) && (isdefined(player.isspeaking) && player.isspeaking))
			{
				wait(0.1);
			}
		}
	}
}

/*
	Name: function_cf8fccfe
	Namespace: zm_zod_vo
	Checksum: 0xDE886181
	Offset: 0x2670
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function function_cf8fccfe(var_eca8128e)
{
	self.dontspeak = var_eca8128e;
	self clientfield::set_to_player("isspeaking", var_eca8128e);
	if(var_eca8128e)
	{
		while(isdefined(self) && (isdefined(self.isspeaking) && self.isspeaking))
		{
			wait(0.1);
		}
	}
}

/*
	Name: function_7b697614
	Namespace: zm_zod_vo
	Checksum: 0x2F0F4BC0
	Offset: 0x26E8
	Size: 0x30C
	Parameters: 5
	Flags: Linked
*/
function function_7b697614(str_vo_alias, n_delay = 0, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!self flag::exists("in_beastmode") || !self flag::get("in_beastmode"))
	{
		if(zm_audio::arenearbyspeakersactive(10000) && (!(isdefined(var_d1295208) && var_d1295208)))
		{
			return;
		}
		if(isdefined(self.isspeaking) && self.isspeaking || (isdefined(level.sndvoxoverride) && level.sndvoxoverride))
		{
			if(isdefined(b_wait_if_busy) && b_wait_if_busy)
			{
				while(self.isspeaking || (isdefined(level.sndvoxoverride) && level.sndvoxoverride))
				{
					wait(0.1);
				}
				wait(0.35);
			}
			else
			{
				return;
			}
		}
		if(n_delay > 0)
		{
			wait(n_delay);
		}
		if(isdefined(self.isspeaking) && self.isspeaking && (isdefined(self.b_wait_if_busy) && self.b_wait_if_busy))
		{
			while(self.isspeaking)
			{
				wait(0.1);
			}
		}
		else if(isdefined(self.isspeaking) && self.isspeaking && (!(isdefined(self.b_wait_if_busy) && self.b_wait_if_busy)) || (isdefined(level.sndvoxoverride) && level.sndvoxoverride))
		{
			return;
		}
		self.isspeaking = 1;
		self.n_vo_priority = n_priority;
		self.str_vo_being_spoken = str_vo_alias;
		array::add(level.a_e_speakers, self, 1);
		var_2df3d133 = str_vo_alias + "_vo_done";
		if(isactor(self) || isplayer(self))
		{
			self playsoundwithnotify(str_vo_alias, var_2df3d133, "J_head");
		}
		else
		{
			self playsoundwithnotify(str_vo_alias, var_2df3d133);
		}
		self waittill(var_2df3d133);
		self vo_clear();
	}
}

/*
	Name: vo_clear
	Namespace: zm_zod_vo
	Checksum: 0x96FA48F1
	Offset: 0x2A00
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function vo_clear()
{
	self.str_vo_being_spoken = "";
	self.n_vo_priority = 0;
	self.isspeaking = 0;
	b_in_a_e_speakers = 0;
	foreach(e_checkme in level.a_e_speakers)
	{
		if(e_checkme == self)
		{
			b_in_a_e_speakers = 1;
			break;
		}
	}
	if(isdefined(b_in_a_e_speakers) && b_in_a_e_speakers)
	{
		arrayremovevalue(level.a_e_speakers, self);
	}
}

/*
	Name: function_502f946b
	Namespace: zm_zod_vo
	Checksum: 0xAB8CAA1F
	Offset: 0x2B00
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_502f946b()
{
	self endon(#"death");
	if(isdefined(self.str_vo_being_spoken) && self.str_vo_being_spoken != "")
	{
		self stopsound(self.str_vo_being_spoken);
	}
	vo_clear();
}

/*
	Name: function_2426269b
	Namespace: zm_zod_vo
	Checksum: 0x85BEBBC3
	Offset: 0x2B68
	Size: 0x232
	Parameters: 2
	Flags: None
*/
function function_2426269b(v_pos, n_range = 1000)
{
	if(isdefined(level.a_e_speakers))
	{
		foreach(var_d211180f in level.a_e_speakers)
		{
			if(!isdefined(var_d211180f))
			{
				continue;
			}
			if(!isdefined(v_pos) || distancesquared(var_d211180f.origin, v_pos) <= (n_range * n_range))
			{
				if(isdefined(var_d211180f.str_vo_being_spoken) && var_d211180f.str_vo_being_spoken != "")
				{
					var_d211180f stopsound(var_d211180f.str_vo_being_spoken);
				}
				var_d211180f.deleteme = 1;
				var_d211180f.str_vo_being_spoken = "";
				var_d211180f.n_vo_priority = 0;
				var_d211180f.isspeaking = 0;
			}
		}
		i = 0;
		while(isdefined(level.a_e_speakers) && i < level.a_e_speakers.size)
		{
			if(isdefined(level.a_e_speakers[i].deleteme) && level.a_e_speakers[i].deleteme == 1)
			{
				arrayremovevalue(level.a_e_speakers, level.a_e_speakers[i]);
				i = 0;
			}
			else
			{
				i++;
			}
		}
	}
}

/*
	Name: function_897246e4
	Namespace: zm_zod_vo
	Checksum: 0x42E08CE2
	Offset: 0x2DA8
	Size: 0x1C4
	Parameters: 5
	Flags: Linked
*/
function function_897246e4(str_vo_alias, n_wait = 0, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	var_81132431 = strtok(str_vo_alias, "_");
	if(var_81132431[1] === "plr")
	{
		var_edf0b06 = int(var_81132431[2]);
		e_speaker = zm_utility::get_specific_character(var_edf0b06);
	}
	else
	{
		if(var_81132431[1] === "shad")
		{
			e_speaker = undefined;
			level function_b2392771(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
		}
		else
		{
			e_speaker = undefined;
			/#
				assert(0, ("" + str_vo_alias) + "");
			#/
		}
	}
	if(zm_utility::is_player_valid(e_speaker))
	{
		e_speaker function_7b697614(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
}

/*
	Name: function_b2392771
	Namespace: zm_zod_vo
	Checksum: 0xEE47E853
	Offset: 0x2F78
	Size: 0x10C
	Parameters: 4
	Flags: Linked
*/
function function_b2392771(str_dialog, var_853e20ac = 0, b_wait_if_busy, n_priority = 0)
{
	function_218256bd(1);
	for(i = 1; i < level.activeplayers.size; i++)
	{
		level.activeplayers[i] thread function_7b697614(str_dialog, var_853e20ac + 0.1, b_wait_if_busy, n_priority);
	}
	level.activeplayers[0] function_7b697614(str_dialog, var_853e20ac, b_wait_if_busy, n_priority);
	function_218256bd(0);
}

/*
	Name: function_63c44c5a
	Namespace: zm_zod_vo
	Checksum: 0x8525C49E
	Offset: 0x3090
	Size: 0x11C
	Parameters: 5
	Flags: None
*/
function function_63c44c5a(var_cbd11028, var_e21e86b8, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	function_218256bd(1);
	for(i = 0; i < var_cbd11028.size; i++)
	{
		if(isdefined(var_e21e86b8))
		{
			var_e27770b1 = var_e21e86b8[i];
		}
		else
		{
			var_e27770b1 = 0;
		}
		self function_7b697614(var_cbd11028[i], var_e27770b1, b_wait_if_busy, n_priority, var_d1295208);
	}
	function_218256bd(0);
}

/*
	Name: function_7aa5324a
	Namespace: zm_zod_vo
	Checksum: 0x4C7B9347
	Offset: 0x31B8
	Size: 0x114
	Parameters: 5
	Flags: Linked
*/
function function_7aa5324a(var_cbd11028, var_e21e86b8, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	function_218256bd(1);
	for(i = 0; i < var_cbd11028.size; i++)
	{
		if(isdefined(var_e21e86b8))
		{
			var_e27770b1 = var_e21e86b8[i];
		}
		else
		{
			var_e27770b1 = 0;
		}
		function_897246e4(var_cbd11028[i], var_e27770b1, b_wait_if_busy, n_priority, var_d1295208);
	}
	function_218256bd(0);
}

/*
	Name: function_c23e3a71
	Namespace: zm_zod_vo
	Checksum: 0x7CDF6FD
	Offset: 0x32D8
	Size: 0x144
	Parameters: 6
	Flags: Linked
*/
function function_c23e3a71(var_49fefccd, n_index, var_f781d8ce, b_wait_if_busy = 0, var_7e649f23 = 0, var_d1295208 = 0)
{
	/#
		assert(isdefined(var_49fefccd), "");
	#/
	/#
		assert(n_index < var_49fefccd.size, "");
	#/
	var_3b5e4c24 = var_49fefccd[n_index];
	var_123bfae = undefined;
	if(isdefined(var_f781d8ce))
	{
		/#
			assert(n_index < var_f781d8ce.size, "");
		#/
		var_123bfae = var_f781d8ce[n_index];
	}
	function_7aa5324a(var_3b5e4c24, var_123bfae, b_wait_if_busy, var_7e649f23, var_d1295208);
}

/*
	Name: custom_get_mod_type
	Namespace: zm_zod_vo
	Checksum: 0x47841880
	Offset: 0x3428
	Size: 0x4A2
	Parameters: 7
	Flags: Linked
*/
function custom_get_mod_type(impact, mod, weapon, zombie, instakill, dist, player)
{
	close_dist = 4096;
	med_dist = 15376;
	far_dist = 160000;
	if(zombie.damageweapon.name == "sticky_grenade_widows_wine")
	{
		return "default";
	}
	if(zm_utility::is_placeable_mine(weapon))
	{
		if(!instakill)
		{
			return "betty";
		}
		return "weapon_instakill";
	}
	if(zombie.damageweapon.name == "cymbal_monkey")
	{
		if(instakill)
		{
			return "weapon_instakill";
		}
		return "monkey";
	}
	if(weapon.name == "ray_gun" && dist > far_dist)
	{
		if(!instakill)
		{
			return "raygun";
		}
		return "weapon_instakill";
	}
	if(zm_utility::is_headshot(weapon, impact, mod) && dist >= far_dist)
	{
		return "headshot";
	}
	if(mod == "MOD_MELEE" || mod == "MOD_UNKNOWN" && dist < med_dist)
	{
		foreach(var_61254add in level.sword_quest.weapons)
		{
			foreach(var_162382f2 in var_61254add)
			{
				if(weapon == var_162382f2)
				{
					return "sword_slash";
				}
			}
		}
	}
	if(mod == "MOD_MELEE" || mod == "MOD_UNKNOWN" && dist < close_dist)
	{
		if(!instakill)
		{
			return "melee";
		}
		return "melee_instakill";
	}
	if(zm_utility::is_explosive_damage(mod) && weapon.name != "ray_gun" && (!(isdefined(zombie.is_on_fire) && zombie.is_on_fire)))
	{
		if(!instakill)
		{
			return "explosive";
		}
		return "weapon_instakill";
	}
	if(weapon.doesfiredamage && (mod == "MOD_BURNED" || mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH"))
	{
		if(!instakill)
		{
			return "flame";
		}
		return "weapon_instakill";
	}
	if(!isdefined(impact))
	{
		impact = "";
	}
	if(mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET")
	{
		if(!instakill)
		{
			return "bullet";
		}
		return "weapon_instakill";
	}
	if(instakill)
	{
		return "default";
	}
	if(mod != "MOD_MELEE" && zombie.missinglegs)
	{
		return "crawler";
	}
	if(mod != "MOD_BURNED" && dist < close_dist)
	{
		return "close";
	}
	return "default";
}

/*
	Name: function_6bccb368
	Namespace: zm_zod_vo
	Checksum: 0x5337CB0A
	Offset: 0x38D8
	Size: 0x218
	Parameters: 0
	Flags: Linked
*/
function function_6bccb368()
{
	self endon(#"_zombie_game_over");
	self endon(#"disconnect");
	if(!level flag::exists("someone_saw_zombie"))
	{
		level flag::init("someone_saw_zombie");
	}
	while(!level flag::get("someone_saw_zombie"))
	{
		a_enemies = zombie_utility::get_round_enemy_array();
		if(!self flag::get("in_beastmode") && isdefined(a_enemies) && a_enemies.size > 0)
		{
			var_670979e7 = undefined;
			for(i = 0; !isdefined(var_670979e7) && i < a_enemies.size; i++)
			{
				if(self function_2d942575(a_enemies[i], 300))
				{
					var_670979e7 = a_enemies[i];
				}
			}
			if(isdefined(var_670979e7))
			{
				var_43c4688f = (("vox_plr_" + self.characterindex) + "_first_encounter_") + randomint(2);
				self thread function_7b697614(var_43c4688f);
				level flag::set("someone_saw_zombie");
			}
		}
		if(self flag::get("in_beastmode"))
		{
			wait(1.5);
		}
		else
		{
			wait(0.5);
		}
	}
}

/*
	Name: function_2d942575
	Namespace: zm_zod_vo
	Checksum: 0xB6ECBD40
	Offset: 0x3AF8
	Size: 0x70
	Parameters: 2
	Flags: Linked
*/
function function_2d942575(var_47db2fcf, var_72259a3d)
{
	if(isdefined(self) && isdefined(var_47db2fcf))
	{
		return self zm_sidequests::is_facing(var_47db2fcf) && distance(self.origin, var_47db2fcf.origin) < var_72259a3d;
	}
	return 0;
}

/*
	Name: function_7884e6b8
	Namespace: zm_zod_vo
	Checksum: 0x7558622E
	Offset: 0x3B78
	Size: 0x1D7A
	Parameters: 0
	Flags: Linked
*/
function function_7884e6b8()
{
	self endon(#"_zombie_game_over");
	var_2aceef24 = [];
	var_2aceef24[0] = array("vox_plr_3_interaction_nero_rose_1_0", "vox_plr_2_interaction_nero_rose_1_0");
	var_2aceef24[1] = array("vox_plr_3_interaction_nero_rose_2_0", "vox_plr_2_interaction_nero_rose_2_0");
	var_2aceef24[2] = array("vox_plr_3_interaction_nero_rose_3_0", "vox_plr_2_interaction_nero_rose_3_0");
	var_2aceef24[3] = array("vox_plr_2_interaction_nero_rose_4_0", "vox_plr_3_interaction_nero_rose_4_0");
	var_2aceef24[4] = array("vox_plr_3_interaction_nero_rose_5_0", "vox_plr_2_interaction_nero_rose_5_0");
	var_2e0bdd7c = [];
	var_2e0bdd7c[0] = array(0, 0.5);
	var_2e0bdd7c[1] = array(0, 0.5);
	var_2e0bdd7c[2] = array(0, 0.5);
	var_2e0bdd7c[3] = array(0, 0.5);
	var_2e0bdd7c[4] = array(0, 0.5);
	var_cd89e034 = 0;
	var_a6212a19 = [];
	var_a6212a19[0] = array("vox_plr_3_interaction_nero_floyd_1_0", "vox_plr_0_interaction_nero_floyd_1_0");
	var_a6212a19[1] = array("vox_plr_3_interaction_nero_floyd_2_0", "vox_plr_0_interaction_nero_floyd_2_0");
	var_a6212a19[2] = array("vox_plr_3_interaction_nero_floyd_3_0", "vox_plr_0_interaction_nero_floyd_3_0");
	var_a6212a19[3] = array("vox_plr_3_interaction_nero_floyd_4_0", "vox_plr_0_interaction_nero_floyd_4_0");
	var_a6212a19[4] = array("vox_plr_3_interaction_nero_floyd_5_0", "vox_plr_0_interaction_nero_floyd_5_0");
	var_89c75715 = [];
	var_89c75715[0] = array(0, 0.5);
	var_89c75715[1] = array(0, 0.5);
	var_89c75715[2] = array(0, 0.5);
	var_89c75715[3] = array(0, 0.5);
	var_89c75715[4] = array(0, 0.5);
	var_13c9923f = 0;
	var_9c641b00 = [];
	var_9c641b00[0] = array("vox_plr_1_interaction_nero_jack_1_0", "vox_plr_3_interaction_nero_jack_1_0");
	var_9c641b00[1] = array("vox_plr_3_interaction_nero_jack_2_0", "vox_plr_1_interaction_nero_jack_2_0");
	var_9c641b00[2] = array("vox_plr_3_interaction_nero_jack_3_0", "vox_plr_1_interaction_nero_jack_3_0", "vox_plr_3_interaction_nero_jack_3_1");
	var_9c641b00[3] = array("vox_plr_1_interaction_nero_jack_4_0", "vox_plr_3_interaction_nero_jack_4_0");
	var_9c641b00[4] = array("vox_plr_3_interaction_nero_jack_5_0", "vox_plr_1_interaction_nero_jack_5_0");
	var_ed6dbab8 = [];
	var_ed6dbab8[0] = array(0, 0.5);
	var_ed6dbab8[1] = array(0, 0.5);
	var_ed6dbab8[2] = array(0, 0.5, 0.5);
	var_ed6dbab8[3] = array(0, 0.5);
	var_ed6dbab8[4] = array(0, 0.5);
	var_6c01a9d8 = 0;
	var_80d70a6a = [];
	var_80d70a6a[0] = array("vox_plr_2_interaction_rose_floyd_1_0", "vox_plr_0_interaction_rose_floyd_1_0");
	var_80d70a6a[1] = array("vox_plr_0_interaction_rose_floyd_2_0", "vox_plr_2_interaction_rose_floyd_2_0");
	var_80d70a6a[2] = array("vox_plr_2_interaction_rose_floyd_3_0", "vox_plr_0_interaction_rose_floyd_3_0");
	var_80d70a6a[3] = array("vox_plr_0_interaction_rose_floyd_4_0", "vox_plr_2_interaction_rose_floyd_4_0");
	var_80d70a6a[4] = array("vox_plr_0_interaction_rose_floyd_5_0", "vox_plr_2_interaction_rose_floyd_5_0");
	var_71f5a15c = [];
	var_71f5a15c[0] = array(0, 0.5);
	var_71f5a15c[1] = array(0, 0.5);
	var_71f5a15c[2] = array(0, 0.5);
	var_71f5a15c[3] = array(0, 0.5);
	var_71f5a15c[4] = array(0, 0.5);
	var_78e21714 = 0;
	var_c92f1b5 = [];
	var_c92f1b5[0] = array("vox_plr_1_interaction_rose_jack_1_0", "vox_plr_2_interaction_rose_jack_1_0");
	var_c92f1b5[1] = array("vox_plr_1_interaction_rose_jack_2_0", "vox_plr_2_interaction_rose_jack_2_0");
	var_c92f1b5[2] = array("vox_plr_1_interaction_rose_jack_3_0", "vox_plr_2_interaction_rose_jack_3_0");
	var_c92f1b5[3] = array("vox_plr_2_interaction_rose_jack_4_0", "vox_plr_1_interaction_rose_jack_4_0");
	var_c92f1b5[4] = array("vox_plr_2_interaction_rose_jack_5_0", "vox_plr_1_interaction_rose_jack_5_0");
	var_abdc92f = [];
	var_abdc92f[0] = array(0, 0.5);
	var_abdc92f[1] = array(0, 0.5);
	var_abdc92f[2] = array(0, 0.5);
	var_abdc92f[3] = array(0, 0.5);
	var_abdc92f[4] = array(0, 0.5);
	var_153b39c5 = 0;
	var_74dec714 = [];
	var_74dec714[0] = array("vox_plr_1_interaction_floyd_jack_1_0", "vox_plr_0_interaction_floyd_jack_1_0");
	var_74dec714[1] = array("vox_plr_1_interaction_floyd_jack_2_0", "vox_plr_0_interaction_floyd_jack_2_0");
	var_74dec714[2] = array("vox_plr_1_interaction_floyd_jack_3_0", "vox_plr_0_interaction_floyd_jack_3_0");
	var_74dec714[3] = array("vox_plr_1_interaction_floyd_jack_4_0", "vox_plr_0_interaction_floyd_jack_4_0");
	var_74dec714[4] = array("vox_plr_0_interaction_floyd_jack_5_0", "vox_plr_1_interaction_floyd_jack_5_0");
	var_8c491a82 = [];
	var_8c491a82[0] = array(0, 0.5);
	var_8c491a82[1] = array(0, 0.5);
	var_8c491a82[2] = array(0, 0.5);
	var_8c491a82[3] = array(0, 0.5);
	var_8c491a82[4] = array(0, 0.5);
	var_8e5923d6 = 0;
	var_7e83078b = [];
	var_7e83078b[0] = array("vox_shad_convo_shadowman_1_0", "vox_plr_0_convo_shadowman_1_0");
	var_7e83078b[1] = array("vox_shad_convo_shadowman_2_0");
	var_7e83078b[2] = array("vox_shad_convo_shadowman_3_0", "vox_plr_0_convo_shadowman_3_0");
	var_ada1803 = 0;
	var_8bc75ab1 = [];
	var_8bc75ab1[0] = array(0, 0.5);
	var_8bc75ab1[1] = array(0);
	var_8bc75ab1[2] = array(0, 0.5);
	var_9abcfc3a = [];
	var_9abcfc3a[0] = array("vox_shad_convo_shadowman_1_0", "vox_plr_1_convo_shadowman_1_0");
	var_9abcfc3a[1] = array("vox_shad_convo_shadowman_2_0");
	var_9abcfc3a[2] = array("vox_shad_convo_shadowman_3_0", "vox_plr_1_convo_shadowman_3_0");
	var_2fe96e24 = 0;
	var_77205e6c = [];
	var_77205e6c[0] = array(0, 0.5);
	var_77205e6c[1] = array(0);
	var_77205e6c[2] = array(0, 0.5);
	var_580b69be = [];
	var_580b69be[0] = array("vox_shad_convo_shadowman_1_0", "vox_plr_2_convo_shadowman_1_0");
	var_580b69be[1] = array("vox_shad_convo_shadowman_2_0");
	var_580b69be[2] = array("vox_shad_convo_shadowman_3_0", "vox_plr_2_convo_shadowman_3_0");
	var_79fa2e10 = 0;
	var_15769b50 = [];
	var_15769b50[0] = array(0, 0.5);
	var_15769b50[1] = array(0);
	var_15769b50[2] = array(0, 0.5);
	var_6d5a2d1 = [];
	var_6d5a2d1[0] = array("vox_shad_convo_shadowman_1_0", "vox_plr_3_convo_shadowman_1_0");
	var_6d5a2d1[1] = array("vox_shad_convo_shadowman_2_0");
	var_6d5a2d1[2] = array("vox_shad_convo_shadowman_3_0", "vox_plr_3_convo_shadowman_3_0");
	var_427d9c1f = 0;
	var_561dc75 = [];
	var_561dc75[0] = array(0, 0.5);
	var_561dc75[1] = array(0);
	var_561dc75[2] = array(0, 0.5);
	level waittill(#"all_players_spawned");
	wait(1);
	level flag::init("someone_saw_1st_zombie");
	foreach(dude in level.activeplayers)
	{
		dude thread function_6bccb368();
	}
	while(true)
	{
		var_4a606162 = 0;
		if(level.round_number <= 4)
		{
			if(level.round_number == 1)
			{
				function_5a3465d8();
				continue;
			}
			if(level.round_number > 1)
			{
				level waittill(#"start_of_round");
			}
			if(!level flag::get("ritual_in_progress"))
			{
				function_218256bd(1);
				var_95496ba8 = ("vox_shad_round" + level.round_number) + "_start_0";
				var_5bc4a435 = array::random(level.activeplayers);
				var_58d3f663 = ((("vox_plr_" + var_5bc4a435.characterindex) + "_round") + level.round_number) + "_start_0";
				if(level.round_number < 4)
				{
					var_308b02ed = array(var_95496ba8, var_58d3f663);
				}
				else
				{
					var_308b02ed = array("vox_shad_round4_start_0", var_58d3f663, "vox_shad_round4_start_1");
				}
				var_4d029563 = array(0, 0.5);
				function_7aa5324a(var_308b02ed, var_4d029563, 1);
				function_218256bd(0);
				level waittill(#"end_of_round");
				if(!level flag::get("ritual_in_progress"))
				{
					var_e09cb16 = level.round_number - 1;
					var_5bc4a435 = array::random(level.activeplayers);
					if(level flag::get("vo_beastmode_hint"))
					{
						function_218256bd(1);
						function_897246e4("vox_shad_hints_beastmode_0", 0, 1);
						level flag::clear("vo_beastmode_hint");
						function_218256bd(0);
					}
					else
					{
						if(var_e09cb16 < 2)
						{
							var_76393213 = ((("vox_plr_" + var_5bc4a435.characterindex) + "_round") + var_e09cb16) + "_end_0";
							function_218256bd(1);
							if(isdefined(var_5bc4a435))
							{
								var_5bc4a435 function_7b697614(var_76393213, 0, 1);
							}
							function_218256bd(0);
						}
						else
						{
							if(var_e09cb16 == 2)
							{
								function_218256bd(1);
								function_897246e4("vox_shad_keepers_ritual_0", 0, 1);
								function_218256bd(0);
							}
							else
							{
								var_5bc4a435 function_b19fc986("positive", 0, 1);
							}
						}
					}
				}
			}
		}
		else
		{
			level waittill(#"start_of_round");
			if(!level flag::get("ritual_in_progress"))
			{
				e_speaker = array::random(level.activeplayers);
				if(level flag::exists("wasp_round") && level flag::get("wasp_round"))
				{
					do
					{
						var_26378eb = randomint(3);
					}
					while(var_26378eb === self.var_e3244016);
					var_d485f9b4 = (("vox_plr_" + e_speaker.characterindex) + "_round_parasite_") + var_26378eb;
					e_speaker.var_e3244016 = var_26378eb;
					e_speaker function_7b697614(var_d485f9b4, 2.5);
				}
				else if(level flag::exists("raps_round") && level flag::get("raps_round"))
				{
					do
					{
						var_26378eb = randomint(5);
					}
					while(var_26378eb === e_speaker.var_465e4929);
					var_9f08831f = (("vox_plr_" + e_speaker.characterindex) + "_round_elemental_") + var_26378eb;
					e_speaker.var_796f13cd = var_26378eb;
					e_speaker function_7b697614(var_9f08831f, 1.5);
				}
				level waittill(#"end_of_round");
				if(level.activeplayers.size > 1 && !level flag::get("ritual_in_progress"))
				{
					n_player_index = randomint(level.activeplayers.size);
					var_e8669 = level.activeplayers[n_player_index];
					var_a68de872 = array::remove_index(level.activeplayers, n_player_index);
					var_261100d2 = arraygetclosest(var_e8669.origin, var_a68de872);
					if(zm_utility::is_player_valid(var_e8669) && zm_utility::is_player_valid(var_261100d2) && distance(var_e8669.origin, var_261100d2.origin) <= 900)
					{
						var_3b5e4c24 = undefined;
						var_123bfae = array(0, 0);
						if(var_e8669.characterindex == 3 && var_261100d2.characterindex == 2 || (var_261100d2.characterindex == 3 && var_e8669.characterindex == 2))
						{
							if(var_cd89e034 < var_2aceef24.size)
							{
								function_c23e3a71(var_2aceef24, var_cd89e034, var_2e0bdd7c, 1);
								var_cd89e034++;
							}
							else
							{
								var_4a606162 = 1;
							}
						}
						else
						{
							if(var_e8669.characterindex == 3 && var_261100d2.characterindex == 0 || (var_261100d2.characterindex == 3 && var_e8669.characterindex == 0))
							{
								if(var_13c9923f < var_a6212a19.size)
								{
									function_c23e3a71(var_a6212a19, var_13c9923f, var_89c75715, 1);
									var_13c9923f++;
								}
								else
								{
									var_4a606162 = 1;
								}
							}
							else
							{
								if(var_e8669.characterindex == 3 && var_261100d2.characterindex == 1 || (var_261100d2.characterindex == 3 && var_e8669.characterindex == 1))
								{
									if(var_6c01a9d8 < var_9c641b00.size)
									{
										function_c23e3a71(var_9c641b00, var_6c01a9d8, var_ed6dbab8, 1);
										var_6c01a9d8++;
									}
									else
									{
										var_4a606162 = 1;
									}
								}
								else
								{
									if(var_e8669.characterindex == 2 && var_261100d2.characterindex == 0 || (var_261100d2.characterindex == 2 && var_e8669.characterindex == 0))
									{
										if(var_78e21714 < var_80d70a6a.size)
										{
											function_c23e3a71(var_80d70a6a, var_78e21714, var_71f5a15c, 1);
											var_78e21714++;
										}
										else
										{
											var_4a606162 = 1;
										}
									}
									else
									{
										if(var_e8669.characterindex == 2 && var_261100d2.characterindex == 1 || (var_261100d2.characterindex == 2 && var_e8669.characterindex == 1))
										{
											if(var_153b39c5 < var_c92f1b5.size)
											{
												function_c23e3a71(var_c92f1b5, var_153b39c5, var_abdc92f, 1);
												var_153b39c5++;
											}
											else
											{
												var_4a606162 = 1;
											}
										}
										else if(var_e8669.characterindex == 0 && var_261100d2.characterindex == 1 || (var_261100d2.characterindex == 0 && var_e8669.characterindex == 1))
										{
											if(var_8e5923d6 < var_74dec714.size)
											{
												function_c23e3a71(var_74dec714, var_8e5923d6, var_8c491a82, 1);
												var_8e5923d6++;
											}
											else
											{
												var_4a606162 = 1;
											}
										}
									}
								}
							}
						}
					}
				}
				else
				{
					var_4a606162 = 1;
				}
			}
		}
		if(var_4a606162 && !level flag::get("ritual_in_progress"))
		{
			var_5bc4a435 = array::random(level.activeplayers);
			switch(var_5bc4a435.characterindex)
			{
				case 0:
				{
					if(var_ada1803 < var_7e83078b.size)
					{
						function_7aa5324a(var_7e83078b[var_ada1803], var_8bc75ab1[var_ada1803], 1);
						var_ada1803++;
					}
					else
					{
						var_5bc4a435 function_b19fc986("positive", 0, 1);
					}
					break;
				}
				case 1:
				{
					if(var_2fe96e24 < var_9abcfc3a.size)
					{
						function_7aa5324a(var_9abcfc3a[var_2fe96e24], var_77205e6c[var_2fe96e24], 1);
						var_2fe96e24++;
					}
					else
					{
						var_5bc4a435 function_b19fc986("positive", 0, 1);
					}
					break;
				}
				case 2:
				{
					if(var_79fa2e10 < var_580b69be.size)
					{
						function_7aa5324a(var_580b69be[var_79fa2e10], var_15769b50[var_79fa2e10], 1);
						var_79fa2e10++;
					}
					else
					{
						var_5bc4a435 function_b19fc986("positive", 0, 1);
					}
					break;
				}
				case 3:
				{
					if(var_427d9c1f < var_6d5a2d1.size)
					{
						function_7aa5324a(var_6d5a2d1[var_427d9c1f], var_561dc75[var_427d9c1f], 1);
						var_427d9c1f++;
					}
					else
					{
						var_5bc4a435 function_b19fc986("positive", 0, 1);
					}
					break;
				}
			}
		}
	}
}

/*
	Name: function_5a3465d8
	Namespace: zm_zod_vo
	Checksum: 0x3B094853
	Offset: 0x5900
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function function_5a3465d8()
{
	level flag::wait_till("start_zombie_round_logic");
	function_218256bd(1);
	var_f7ea4005 = ("vox_shad_round" + level.round_number) + "_start_0";
	level function_b2392771(var_f7ea4005, 0.5, 0, 99);
	wait(0.5);
	foreach(e_player in level.players)
	{
		var_b48c1dda = ("vox_plr_" + e_player.characterindex) + "_round1_start_0";
		e_player playsoundtoplayer(var_b48c1dda, e_player);
	}
	wait(5.5);
	function_218256bd(0);
	level waittill(#"end_of_round");
}

/*
	Name: vo_beastmode_hint
	Namespace: zm_zod_vo
	Checksum: 0xF75BF30
	Offset: 0x5A90
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function vo_beastmode_hint()
{
	self endon(#"_zombie_game_over");
	level endon(#"hash_571c8e3c");
	level waittill(#"end_of_round");
	level flag::set("vo_beastmode_hint");
}

/*
	Name: function_50460ed1
	Namespace: zm_zod_vo
	Checksum: 0x238E4AA7
	Offset: 0x5AE0
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function function_50460ed1()
{
	self endon(#"_zombie_game_over");
	level waittill(#"hash_571c8e3c");
	if(level.activeplayers.size > 1)
	{
		var_4993c84e = zm_utility::get_specific_character(level.n_first_beast_mode_player_index);
		var_2a7f708 = [];
		for(i = 0; i < level.players.size; i++)
		{
			if(level.players[i] !== var_4993c84e && level.players[i].beastmode !== 1)
			{
				array::add(var_2a7f708, level.players[i]);
			}
		}
		if(isdefined(var_2a7f708) && var_2a7f708.size != 0)
		{
			e_closest_player = arraygetclosest(var_4993c84e.origin, var_2a7f708);
			if(zm_utility::is_player_valid(e_closest_player) && e_closest_player.beastmode !== 1 && distance(e_closest_player.origin, var_4993c84e.origin) <= 900)
			{
				var_f8ca415d = ("vox_plr_" + e_closest_player.characterindex) + "_transform_beast_0";
				function_897246e4(var_f8ca415d, 0.75, 1);
			}
		}
	}
}

/*
	Name: function_32c9e1d9
	Namespace: zm_zod_vo
	Checksum: 0x2EAEBEED
	Offset: 0x5CD0
	Size: 0x7AE
	Parameters: 1
	Flags: Linked
*/
function function_32c9e1d9(str_item)
{
	var_5f56f0a = [];
	var_5f56f0a[0] = array("vox_plr_0_pickup_badge_0", "vox_plr_0_pickup_badge_1", "vox_plr_0_pickup_badge_2");
	var_5f56f0a[1] = array("vox_plr_1_pickup_badge_0", "vox_plr_1_pickup_badge_1", "vox_plr_1_pickup_badge_2");
	var_5f56f0a[2] = array("vox_plr_2_pickup_badge_0", "vox_plr_2_pickup_badge_1", "vox_plr_2_pickup_badge_2");
	var_5f56f0a[3] = array("vox_plr_3_pickup_badge_0", "vox_plr_3_pickup_badge_1", "vox_plr_3_pickup_badge_2");
	var_fe25e09 = [];
	var_452c2069[0] = array(0, 0, 0);
	var_452c2069[1] = array(0, 0, 0);
	var_452c2069[2] = array(0, 0, 0);
	var_452c2069[3] = array(0, 0, 0);
	var_f562c91a = [];
	var_f562c91a[0] = array("vox_plr_0_pickup_belt_0", "vox_plr_0_pickup_belt_1", "vox_plr_0_pickup_belt_2");
	var_f562c91a[1] = array("vox_plr_1_pickup_belt_0", "vox_plr_1_pickup_belt_1", "vox_plr_1_pickup_belt_2");
	var_f562c91a[2] = array("vox_plr_2_pickup_belt_0", "vox_plr_2_pickup_belt_1", "vox_plr_2_pickup_belt_2");
	var_f562c91a[3] = array("vox_plr_3_pickup_belt_0", "vox_plr_3_pickup_belt_1", "vox_plr_3_pickup_belt_2");
	var_28b212db = [];
	var_d9fec6bf[0] = array(0, 0, 0);
	var_d9fec6bf[1] = array(0, 0, 0);
	var_d9fec6bf[2] = array(0, 0, 0);
	var_d9fec6bf[3] = array(0, 0, 0);
	var_a289b84d = [];
	var_a289b84d[0] = array("vox_plr_0_pickup_hairpiece_0", "vox_plr_0_pickup_hairpiece_1", "vox_plr_0_pickup_hairpiece_2");
	var_a289b84d[1] = array("vox_plr_1_pickup_hairpiece_0", "vox_plr_1_pickup_hairpiece_1", "vox_plr_1_pickup_hairpiece_2", "vo_options_plr_1_pickup_hairpiece_3");
	var_a289b84d[2] = array("vox_plr_2_pickup_hairpiece_0", "vox_plr_2_pickup_hairpiece_1", "vox_plr_2_pickup_hairpiece_2");
	var_a289b84d[3] = array("vox_plr_3_pickup_hairpiece_0", "vox_plr_3_pickup_hairpiece_1", "vox_plr_3_pickup_hairpiece_2");
	var_72506842 = [];
	var_838979be[0] = array(0, 0, 0);
	var_838979be[1] = array(0, 0, 0);
	var_838979be[2] = array(0, 0, 0);
	var_838979be[3] = array(0, 0, 0);
	var_a545e2b6 = [];
	var_a545e2b6[0] = array("vox_plr_0_pickup_pen_0", "vox_plr_0_pickup_pen_1", "vox_plr_0_pickup_pen_2");
	var_a545e2b6[1] = array("vox_plr_1_pickup_pen_0", "vox_plr_1_pickup_pen_2", "vox_plr_1_pickup_pen_3");
	var_a545e2b6[2] = array("vox_plr_2_pickup_pen_0", "vox_plr_2_pickup_pen_1", "vox_plr_2_pickup_pen_2");
	var_a545e2b6[3] = array("vox_plr_3_pickup_pen_0", "vox_plr_3_pickup_pen_1", "vox_plr_3_pickup_pen_2");
	var_1d235ae1 = [];
	var_5af762b1[0] = array(0, 0, 0);
	var_5af762b1[1] = array(0, 0, 0);
	var_5af762b1[2] = array(0, 0, 0);
	var_5af762b1[3] = array(0, 0, 0);
	switch(str_item)
	{
		case "memento_boxer":
		{
			var_c62848ef = randomint(var_f562c91a[self.characterindex].size);
			self function_7b697614(var_f562c91a[self.characterindex][var_c62848ef], var_d9fec6bf[self.characterindex][var_c62848ef], 1);
			break;
		}
		case "memento_detective":
		{
			var_c62848ef = randomint(var_5f56f0a[self.characterindex].size);
			self function_7b697614(var_5f56f0a[self.characterindex][var_c62848ef], var_452c2069[self.characterindex][var_c62848ef], 1);
			break;
		}
		case "memento_femme":
		{
			var_c62848ef = randomint(var_a289b84d[self.characterindex].size);
			self function_7b697614(var_a289b84d[self.characterindex][var_c62848ef], var_838979be[self.characterindex][var_c62848ef], 1);
			break;
		}
		case "memento_magician":
		{
			var_c62848ef = randomint(var_a545e2b6[self.characterindex].size);
			self function_7b697614(var_a545e2b6[self.characterindex][var_c62848ef], var_5af762b1[self.characterindex][var_c62848ef], 1);
			break;
		}
	}
}

/*
	Name: function_2e3f1a98
	Namespace: zm_zod_vo
	Checksum: 0xD81C4748
	Offset: 0x6488
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function function_2e3f1a98()
{
	if(zm_utility::is_player_valid(self) && !isdefined(self.var_f5d71a04))
	{
		var_f7937450 = ("vox_plr_" + self.characterindex) + "_ritual_end_0_0";
		self function_7b697614(var_f7937450);
		function_b2392771("vox_shad_ritual_end_1_0");
		var_f7937450 = ("vox_plr_" + self.characterindex) + "_ritual_end_2_0";
		self function_7b697614(var_f7937450);
		function_b2392771("vox_shad_ritual_end_3_0");
		self.var_f5d71a04 = 1;
	}
}

/*
	Name: function_53b96c8f
	Namespace: zm_zod_vo
	Checksum: 0x55A8CF21
	Offset: 0x6570
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_53b96c8f()
{
	if(zm_utility::is_player_valid(self))
	{
		if(!isdefined(level.var_dff34a19))
		{
			level.var_2294b9be = array(0, 1, 2, 3, 4, 5);
			level.var_2294b9be = array::randomize(level.var_2294b9be);
		}
		if(!isdefined(level.var_f05f7ce3))
		{
			level.var_f05f7ce3 = 0;
		}
		else
		{
			level.var_f05f7ce3++;
		}
		if(!isdefined(self.var_eaf7c404))
		{
			self.var_eaf7c404 = 0;
		}
		else
		{
			self.var_eaf7c404++;
		}
		if(self.var_eaf7c404 < self.var_5a34308d.size)
		{
			var_3dbab226 = (("vox_plr_" + self.characterindex) + "_pickup_key_") + self.var_5a34308d[self.var_eaf7c404];
			var_597589b9 = array(var_3dbab226);
		}
		if(level.var_f05f7ce3 < level.var_2294b9be.size)
		{
			var_3dbab226 = "vox_shad_pickup_key_response_" + level.var_2294b9be[level.var_f05f7ce3];
			array::add(var_597589b9, var_3dbab226);
		}
		function_7aa5324a(var_597589b9, undefined, 1);
	}
}

/*
	Name: vo_placeworm_hint
	Namespace: zm_zod_vo
	Checksum: 0x9FA37EEE
	Offset: 0x6730
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function vo_placeworm_hint()
{
	self endon(#"_zombie_game_over");
	flag::wait_till("vo_placeworm_hint");
	function_897246e4("vox_shad_place_worms_0", 0, 1);
}

/*
	Name: function_4de46cf5
	Namespace: zm_zod_vo
	Checksum: 0xC13153A9
	Offset: 0x6780
	Size: 0x7E
	Parameters: 1
	Flags: None
*/
function function_4de46cf5(var_559a3756)
{
	switch(var_559a3756)
	{
		case "pickup":
		{
			self zm_audio::create_and_play_dialog("sprayer", "pickup");
			break;
		}
		case "use":
		{
			self zm_audio::create_and_play_dialog("sprayer", "use");
			break;
		}
	}
}

/*
	Name: function_bcf7d3ea
	Namespace: zm_zod_vo
	Checksum: 0xB479E380
	Offset: 0x6808
	Size: 0x164
	Parameters: 1
	Flags: Linked
*/
function function_bcf7d3ea(a_spawners)
{
	var_ec05e7d4 = (0, 0, 0);
	if(isdefined(a_spawners) && a_spawners.size > 0)
	{
		foreach(x in a_spawners)
		{
			var_ec05e7d4 = var_ec05e7d4 + x.origin;
		}
		var_ec05e7d4 = var_ec05e7d4 / a_spawners.size;
	}
	e_closest_player = arraygetclosest(var_ec05e7d4, level.activeplayers);
	var_d84d185d = (("vox_plr_" + e_closest_player.characterindex) + "_keepers_arrive_") + randomint(3);
	function_897246e4(var_d84d185d, 1, 1);
}

/*
	Name: function_93f0e7bd
	Namespace: zm_zod_vo
	Checksum: 0x9EF5D9CC
	Offset: 0x6978
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_93f0e7bd()
{
	if(level.var_f8b68299.size > 0)
	{
		var_f7937450 = array::random(level.var_f8b68299);
		arrayremovevalue(level.var_f8b68299, var_f7937450);
	}
	function_b2392771(var_f7937450);
}

/*
	Name: function_f9003879
	Namespace: zm_zod_vo
	Checksum: 0x43670E54
	Offset: 0x69F0
	Size: 0x238
	Parameters: 1
	Flags: Linked
*/
function function_f9003879(var_d3be01d9)
{
	self endon(#"_zombie_game_over");
	self endon(var_d3be01d9 + "_done");
	e_trig = getent(var_d3be01d9, "targetname");
	var_6afd6b = undefined;
	while(!zombie_utility::is_player_valid(var_6afd6b))
	{
		e_trig waittill(#"trigger", var_6afd6b);
		if(var_6afd6b flag::get("in_beastmode"))
		{
			var_6afd6b = undefined;
		}
	}
	if(zm_utility::is_player_valid(var_6afd6b))
	{
		switch(var_d3be01d9)
		{
			case "visited_burlesque":
			{
				var_71d49619 = "vox_shad_shadowman_burl_appears_0";
				str_response = ("vox_plr_" + var_6afd6b.characterindex) + "_shadowman_burl_appears_response_0";
				break;
			}
			case "visited_gym":
			{
				var_71d49619 = "vox_shad_shadowman_gym_appears_0";
				str_response = ("vox_plr_" + var_6afd6b.characterindex) + "_shadowman_gym_appears_response_0";
				break;
			}
			case "visited_ruby":
			{
				var_71d49619 = "vox_shad_shadowman_ruby_appears_0";
				str_response = ("vox_plr_" + var_6afd6b.characterindex) + "_shadowman_ruby_appears_response_0";
				break;
			}
			case "visited_workshop":
			{
				var_71d49619 = "vox_shad_shadowman_workshop_appears_0";
				str_response = ("vox_plr_" + var_6afd6b.characterindex) + "_shadowman_workshop_appears_response_0";
				break;
			}
		}
		level function_b2392771(var_71d49619, 0, 1);
		var_6afd6b function_7b697614(str_response, 1, 1);
		level notify(var_d3be01d9 + "_done");
	}
}

/*
	Name: function_c41d3e2e
	Namespace: zm_zod_vo
	Checksum: 0xA168EAEA
	Offset: 0x6C30
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_c41d3e2e(var_1e0c5b50)
{
	var_93173b64 = [];
	var_93173b64["memento_boxer"] = "gym";
	var_93173b64["memento_detective"] = "ruby";
	var_93173b64["memento_femme"] = "burlesque";
	var_93173b64["memento_magician"] = "workshop";
	if(randomint(100) < 60)
	{
		var_5eb0b65c = ((("vox_plr_" + self.characterindex) + "_place_item_") + var_93173b64[var_1e0c5b50]) + "_0";
		self function_7b697614(var_5eb0b65c, 0, 0);
	}
}

/*
	Name: function_24b80509
	Namespace: zm_zod_vo
	Checksum: 0xF9D3D01C
	Offset: 0x6D38
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_24b80509()
{
	var_7cd0d = (("vox_plr_" + self.characterindex) + "_place_worms_response_") + self.var_aefa986d;
	self function_7b697614(var_7cd0d, 1, 1);
	self.var_aefa986d++;
}

/*
	Name: function_658d89a3
	Namespace: zm_zod_vo
	Checksum: 0x2E99663E
	Offset: 0x6DA0
	Size: 0x244
	Parameters: 1
	Flags: Linked
*/
function function_658d89a3(var_6a363796)
{
	if(!isdefined(level.var_6a0fa91e))
	{
		level.var_6a0fa91e = 1;
		var_71d49619 = "vox_shad_ritual_start_0";
		var_e5924747 = "altar_pos_" + var_6a363796;
		var_9c058564 = getent(var_e5924747, "targetname");
		/#
			assert(isdefined(var_e5924747), ("" + var_e5924747) + "");
		#/
		var_5d92c9b8 = arraygetclosest(var_9c058564.origin, level.activeplayers);
		var_5605fb9 = ("vox_plr_" + var_5d92c9b8.characterindex) + "_ritual_start_response_0";
	}
	else
	{
		var_71d49619 = "vox_shad_ritual_start_response_0";
		var_e5924747 = "altar_pos_" + var_6a363796;
		var_9c058564 = getent(var_e5924747, "targetname");
		/#
			assert(isdefined(var_e5924747), ("" + var_e5924747) + "");
		#/
		var_5d92c9b8 = arraygetclosest(var_9c058564.origin, level.activeplayers);
		var_5605fb9 = (("vox_plr_" + var_5d92c9b8.characterindex) + "_keepers_ritual_response_") + randomint(3);
	}
	level function_b2392771(var_71d49619, 0, 1);
	if(isdefined(var_5605fb9))
	{
		var_5d92c9b8 function_7b697614(var_5605fb9, 0.5, 1);
	}
}

/*
	Name: function_e8972612
	Namespace: zm_zod_vo
	Checksum: 0x891CCCFC
	Offset: 0x6FF0
	Size: 0x21E
	Parameters: 0
	Flags: Linked
*/
function function_e8972612()
{
	level.var_fdb003be = [];
	level.var_fdb003be["boxer"] = array("vox_prom_victim_promoter_0", "vox_prom_victim_promoter_1", "vox_prom_victim_promoter_2", "vox_prom_victim_promoter_3", "vox_prom_victim_promoter_4", "vox_prom_victim_promoter_5");
	level.var_fdb003be["detective"] = array("vox_part_victim_partner_0", "vox_part_victim_partner_1", "vox_part_victim_partner_2", "vox_part_victim_partner_3", "vox_part_victim_partner_5", "vox_part_victim_partner_6");
	level.var_fdb003be["femme"] = array("vox_prod_victim_producer_0", "vox_prom_victim_producer_1", "vox_prod_victim_producer_2", "vox_prod_victim_producer_3", "vox_prod_victim_producer_4", "vox_prod_victim_producer_5");
	level.var_fdb003be["magician"] = array("vox_lawy_victim_lawyer_0", "vox_lawy_victim_lawyer_1", "vox_lawy_victim_lawyer_2", "vox_lawy_victim_lawyer_3", "vox_lawy_victim_lawyer_4", "vox_lawy_victim_lawyer_5");
	level.var_6cef52da = [];
	level.var_6cef52da["boxer"] = array(3, 4);
	level.var_6cef52da["detective"] = array(3, 5);
	level.var_6cef52da["femme"] = array(3, 4);
	level.var_6cef52da["magician"] = array(3, 4);
}

/*
	Name: function_335f3a81
	Namespace: zm_zod_vo
	Checksum: 0xC73506D
	Offset: 0x7218
	Size: 0x1A8
	Parameters: 2
	Flags: Linked
*/
function function_335f3a81(var_13a31044 = 0, var_8df092ed = 0)
{
	if(isdefined(level.var_9bc9c61f) && var_13a31044 < level.var_fdb003be[level.var_9bc9c61f].size)
	{
		var_c404914c = "altar_pos_" + level.var_9bc9c61f;
		level.var_d344b932 = getent(var_c404914c, "targetname");
		switch(var_13a31044)
		{
			case 0:
			{
				str_vo_line = level.var_fdb003be[level.var_9bc9c61f][0];
				break;
			}
			case 3:
			{
				var_5557a55d = level.var_fdb003be[level.var_9bc9c61f].size - 1;
				str_vo_line = level.var_fdb003be[level.var_9bc9c61f][var_5557a55d];
				break;
			}
			default:
			{
				if(var_8df092ed)
				{
					var_13a31044 = var_13a31044 + 2;
				}
				str_vo_line = level.var_fdb003be[level.var_9bc9c61f][var_13a31044];
				break;
			}
		}
		level.var_d344b932 thread function_7b697614(str_vo_line, 0, 1, 0, 1);
		return true;
	}
	return false;
}

/*
	Name: function_17f92643
	Namespace: zm_zod_vo
	Checksum: 0xB5AA32AA
	Offset: 0x73D0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function function_17f92643()
{
	function_7a64d508();
}

/*
	Name: function_7a64d508
	Namespace: zm_zod_vo
	Checksum: 0x860A1AC
	Offset: 0x73F0
	Size: 0x3CC
	Parameters: 0
	Flags: Linked
*/
function function_7a64d508()
{
	switch(level.var_8280ab5f)
	{
		case "boxer":
		{
			var_76541c53 = 0;
			break;
		}
		case "detective":
		{
			var_76541c53 = 1;
			break;
		}
		case "femme":
		{
			var_76541c53 = 2;
			break;
		}
		case "magician":
		{
			var_76541c53 = 3;
			break;
		}
	}
	var_f3aa6934 = [];
	foreach(plr in level.activeplayers)
	{
		array::add(var_f3aa6934, plr.characterindex);
	}
	var_3352e74 = 0;
	foreach(n_index in var_f3aa6934)
	{
		if(n_index == var_76541c53)
		{
			var_3352e74 = 1;
			break;
		}
	}
	if(isdefined(var_3352e74) && var_3352e74)
	{
		var_90461c29 = [];
		var_90461c29[0] = "floyd";
		var_90461c29[1] = "jack";
		var_90461c29[2] = "rose";
		var_90461c29[3] = "nero";
		var_f42a2187 = randomint(3) + 1;
		var_5a4782f7 = ((((("vox_plr_" + var_76541c53) + "_confession_") + var_90461c29[var_76541c53]) + "_") + var_f42a2187) + "_0";
		var_90788992 = array(var_5a4782f7);
		var_678774f0 = array(0);
		if(var_f3aa6934.size > 1)
		{
			do
			{
				var_2789c6f = array::random(var_f3aa6934);
			}
			while(var_2789c6f == var_76541c53);
			var_e84013bc = ((((("vox_plr_" + var_2789c6f) + "_confession_") + var_90461c29[var_76541c53]) + "_response_") + var_f42a2187) + "_0";
			array::add(var_90788992, var_e84013bc);
			array::add(var_678774f0, 0.5);
		}
		function_7aa5324a(var_90788992, var_678774f0, 1, 0, 1);
	}
}

/*
	Name: function_edca6dc9
	Namespace: zm_zod_vo
	Checksum: 0x9DC1542
	Offset: 0x77C8
	Size: 0x16A
	Parameters: 0
	Flags: Linked
*/
function function_edca6dc9()
{
	wait(2);
	var_daf99a63 = array("vox_shad_ritual_complete_0");
	var_ceb8ae25 = array::random(level.activeplayers);
	var_49617378 = ("vox_plr_" + var_ceb8ae25.characterindex) + "_ritual_complete_response_0";
	var_6f63ede1 = ("vox_plr_" + var_ceb8ae25.characterindex) + "_ritual_complete_response_1";
	array::add(var_daf99a63, var_49617378);
	array::add(var_daf99a63, var_6f63ede1);
	function_7aa5324a(var_daf99a63, undefined, 0);
	mdl_key = getent("quest_key_pickup", "targetname");
	mdl_key hide();
	mdl_key clientfield::set("shadowman_fx", 2);
	level notify(#"vo_ritual_pap_succeed_done");
}

/*
	Name: function_b19fc986
	Namespace: zm_zod_vo
	Checksum: 0x8B322788
	Offset: 0x7940
	Size: 0x14C
	Parameters: 3
	Flags: Linked
*/
function function_b19fc986(var_93447b81 = "positive", n_delay = 0, b_wait_if_busy = 0)
{
	if(var_93447b81 == "positive")
	{
		str_suffix = "_generic_responses_positive_";
		n_vo_index = function_5803cf05(3, self.var_4d38f64b);
		self.var_4d38f64b = n_vo_index;
	}
	else
	{
		str_suffix = "_generic_responses_negative_";
		n_vo_index = function_5803cf05(3, self.var_f7882113);
		self.var_b06d973b = n_vo_index;
	}
	var_c2e1519d = (("vox_plr_" + self.characterindex) + str_suffix) + n_vo_index;
	self function_7b697614(var_c2e1519d, n_delay, b_wait_if_busy);
}

/*
	Name: function_d33751d
	Namespace: zm_zod_vo
	Checksum: 0x437EA3BD
	Offset: 0x7A98
	Size: 0xD4
	Parameters: 2
	Flags: None
*/
function function_d33751d(n_delay = 0, b_wait_if_busy = 0)
{
	str_suffix = "_pickup_generic_";
	n_vo_index = function_5803cf05(3, self.var_bd5e7320);
	self.var_bd5e7320 = n_vo_index;
	var_b0415d5f = (("vox_plr_" + self.characterindex) + str_suffix) + n_vo_index;
	self function_7b697614(var_b0415d5f, n_delay, b_wait_if_busy);
}

/*
	Name: function_2cc571f6
	Namespace: zm_zod_vo
	Checksum: 0x3B6DFCA3
	Offset: 0x7B78
	Size: 0x2B4
	Parameters: 0
	Flags: Linked
*/
function function_2cc571f6()
{
	self endon(#"_zombie_game_over");
	while(true)
	{
		level waittill(#"hash_c484afcb");
		if(isdefined(level.var_95981590))
		{
			var_d708b800 = undefined;
			while(!zombie_utility::is_player_valid(var_d708b800))
			{
				wait(0.5);
				foreach(plr in level.activeplayers)
				{
					if(!plr flag::get("in_beastmode") && plr function_2d942575(level.var_95981590, 660) && zm_utility::is_player_valid(plr))
					{
						var_d708b800 = plr;
					}
				}
			}
			if(!isdefined(var_d708b800.var_a57f7e6c))
			{
				var_4443c4b2 = ("vox_plr_" + var_d708b800.characterindex) + "_margwar_spotted_1st_0";
				var_d708b800.var_a57f7e6c = randomint(3);
			}
			else
			{
				var_a8056961 = function_5803cf05(3, var_d708b800.var_a57f7e6c);
				var_d708b800.var_a57f7e6c = var_a8056961;
				var_4443c4b2 = (("vox_plr_" + var_d708b800.characterindex) + "_margwar_spotted_again_") + var_a8056961;
			}
			var_d708b800 function_502f946b();
			if(!(isdefined(var_d708b800.isspeaking) && var_d708b800.isspeaking) && (!(isdefined(level.sndvoxoverride) && level.sndvoxoverride)))
			{
				var_d708b800 function_7b697614(var_4443c4b2, 0, 1);
			}
			level notify(#"hash_aaa21b88");
		}
		wait(10);
	}
}

/*
	Name: function_f8939df5
	Namespace: zm_zod_vo
	Checksum: 0x9F2F4E2A
	Offset: 0x7E38
	Size: 0x120
	Parameters: 0
	Flags: Linked
*/
function function_f8939df5()
{
	self endon(#"_zombie_game_over");
	var_25322547 = randomfloatrange(15, 20);
	while(true)
	{
		level waittill(#"hash_aaa21b88");
		while(level.var_6e63e659 > 0)
		{
			wait(var_25322547);
			e_player = function_43b03c7f(5000);
			if(zm_utility::is_player_valid(e_player))
			{
				e_player zm_audio::create_and_play_dialog("margwa", "fight");
				var_25322547 = randomfloatrange(15, 20);
			}
			else
			{
				var_25322547 = 1;
			}
		}
	}
}

/*
	Name: function_43b03c7f
	Namespace: zm_zod_vo
	Checksum: 0xBA7B6C95
	Offset: 0x7F60
	Size: 0x2D4
	Parameters: 1
	Flags: Linked
*/
function function_43b03c7f(var_f30428a8)
{
	self endon(#"_zombie_game_over");
	var_d8dc8b3c = 0;
	var_e1b29e02 = undefined;
	while(!var_d8dc8b3c)
	{
		var_60852196 = getaiarchetypearray("margwa");
		var_9f338373 = [];
		a_e_players = getplayers();
		i = 0;
		foreach(var_4ef2ab6 in var_60852196)
		{
			var_9f338373[i] = arraysortclosest(a_e_players, var_4ef2ab6.origin, a_e_players.size, 0, var_f30428a8);
			i++;
		}
		if(var_9f338373.size == 1)
		{
			var_e1b29e02 = array::random(var_9f338373[0]);
		}
		if(var_9f338373.size > 1)
		{
			var_12e29d53 = [];
			for(i = 0; i < var_9f338373.size; i++)
			{
				arraycombine(var_12e29d53, var_9f338373[i], 0, 0);
			}
			var_e1b29e02 = array::random(var_12e29d53);
		}
		if(var_9f338373.size > 0)
		{
			foreach(var_4ef2ab6 in var_60852196)
			{
				if(isdefined(var_e1b29e02) && var_e1b29e02 function_2d942575(var_4ef2ab6, var_f30428a8) && !var_e1b29e02 flag::get("in_beastmode"))
				{
					var_d8dc8b3c = 1;
					break;
				}
			}
		}
		wait(0.1);
	}
	return var_e1b29e02;
}

/*
	Name: function_7e398d3
	Namespace: zm_zod_vo
	Checksum: 0x3C5D1C8D
	Offset: 0x8240
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_7e398d3()
{
	self endon(#"_zombie_game_over");
	self endon(#"disconnect");
	self zm_audio::create_and_play_dialog("margwa", "headshot");
}

/*
	Name: function_c11b8117
	Namespace: zm_zod_vo
	Checksum: 0xFC462373
	Offset: 0x8288
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_c11b8117(var_e02e9917)
{
	self endon(#"_zombie_game_over");
	e_closest_player = arraygetclosest(var_e02e9917, level.activeplayers);
	if(zm_utility::is_player_valid(e_closest_player))
	{
		var_887dbc1f = function_5803cf05(3, e_closest_player.var_3cf58348);
		e_closest_player.var_3cf58348 = var_887dbc1f;
		var_9dfd6beb = (("vox_plr_" + e_closest_player.characterindex) + "_margwar_dead_") + var_887dbc1f;
		e_closest_player function_7b697614(var_9dfd6beb, 0.5, 1);
	}
}

/*
	Name: function_9bd30516
	Namespace: zm_zod_vo
	Checksum: 0x1C11D37A
	Offset: 0x8390
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_9bd30516()
{
	self endon(#"_zombie_game_over");
	self endon(#"death");
	self endon(#"disconnect");
	if(!isdefined(self.var_74a00938))
	{
		str_vo = (("vox_plr_" + self.characterindex) + "_pickup_egg_") + randomint(3);
		self.var_74a00938 = 0;
	}
	else
	{
		str_vo = (("vox_plr_" + self.characterindex) + "_pickup_egg_charged_") + self.var_74a00938;
		self.var_74a00938++;
	}
	self function_7b697614(str_vo, 0, 1);
}

/*
	Name: function_c10cc6c5
	Namespace: zm_zod_vo
	Checksum: 0x15C49AF0
	Offset: 0x8470
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_c10cc6c5()
{
	self endon(#"_zombie_game_over");
	self endon(#"death");
	self endon(#"disconnect");
	if(!isdefined(self.var_d094704f))
	{
		self.var_d094704f = 0;
	}
	if(self.var_d094704f < 3)
	{
		str_vo = (("vox_plr_" + self.characterindex) + "_place_egg_") + self.var_d094704f;
		self.var_d094704f++;
	}
	else
	{
		str_vo = (("vox_plr_" + self.characterindex) + "_place_egg_sword_") + randomint(3);
	}
	self function_7b697614(str_vo, 0, 1);
}

/*
	Name: function_da45447a
	Namespace: zm_zod_vo
	Checksum: 0xA87F3BEC
	Offset: 0x8578
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function function_da45447a()
{
	self endon(#"_zombie_game_over");
	self endon(#"disconnect");
	var_86757168 = function_5803cf05(3, self.var_8faf79c9);
	self.var_8faf79c9 = var_86757168;
	str_vo = (("vox_plr_" + self.characterindex) + "_charge_egg_") + var_86757168;
	self function_7b697614(str_vo);
}

/*
	Name: function_a543408d
	Namespace: zm_zod_vo
	Checksum: 0x3186C349
	Offset: 0x8620
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_a543408d()
{
	self endon(#"_zombie_game_over");
	self endon(#"disconnect");
	var_6c37d9ef = function_5803cf05(3, self.var_106675e6);
	self.var_106675e6 = var_6c37d9ef;
	str_vo = (("vox_plr_" + self.characterindex) + "_take_sword_") + var_6c37d9ef;
	self function_7b697614(str_vo);
}

/*
	Name: function_81ba60e2
	Namespace: zm_zod_vo
	Checksum: 0x3F91F979
	Offset: 0x86C8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_81ba60e2()
{
	var_b00cc93b = (("vox_plr_" + self.characterindex) + "_power_on_") + randomint(2);
	self function_7b697614(var_b00cc93b);
}

/*
	Name: function_5803cf05
	Namespace: zm_zod_vo
	Checksum: 0x475AF358
	Offset: 0x8738
	Size: 0x82
	Parameters: 2
	Flags: Linked
*/
function function_5803cf05(n_max, var_6e653641)
{
	/#
		assert(!isdefined(var_6e653641) || var_6e653641 < n_max, "");
	#/
	do
	{
		n_new_value = randomint(n_max);
	}
	while(n_new_value === var_6e653641);
	return n_new_value;
}

/*
	Name: function_82091017
	Namespace: zm_zod_vo
	Checksum: 0x1CAEE9E4
	Offset: 0x87C8
	Size: 0x94
	Parameters: 2
	Flags: None
*/
function function_82091017(str_name, var_cbd11028)
{
	level zm_audio::sndconversation_init(str_name);
	for(i = 0; i < var_cbd11028.size; i++)
	{
		level zm_audio::sndconversation_addline(str_name, var_cbd11028[i], self.characterindex);
	}
	level zm_audio::sndconversation_play(str_name);
}

/*
	Name: function_33bc3cb3
	Namespace: zm_zod_vo
	Checksum: 0x364F1440
	Offset: 0x8868
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_33bc3cb3()
{
	zm_audio::create_and_play_dialog("general", "outofmoney_gate");
}

/*
	Name: zod_magic_box_used_vo
	Namespace: zm_zod_vo
	Checksum: 0xB52F240E
	Offset: 0x8898
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function zod_magic_box_used_vo()
{
	if(!isdefined(self.var_7e6819c4))
	{
		self.var_7e6819c4 = 1;
		self zm_audio::create_and_play_dialog("box", "first_use");
	}
}

