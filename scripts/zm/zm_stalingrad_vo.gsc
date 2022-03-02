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
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_stalingrad_util;

#namespace zm_stalingrad_vo;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_vo
	Checksum: 0xF00DE908
	Offset: 0x1C78
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_vo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_vo
	Checksum: 0x7C3B7367
	Offset: 0x1CB8
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	level.a_e_speakers = [];
	level.audio_get_mod_type = &custom_get_mod_type;
	level thread function_772aa229();
	level.var_bac3b790 = [];
	level.var_38d92be7 = [];
	level.var_c6455b5 = [];
	level.var_2c67f767 = [];
	level.var_4b332a77 = [];
	level.var_bc80de72 = [];
	level.var_9c6abc49 = [];
	level.var_caa91bc0 = [];
	level flag::init("story_playing");
	level flag::init("abcd_speaking");
	level thread function_e84d923f();
	level.sndtrapfunc = &function_643d8310;
	level.var_71ab2462 = &function_df1536ac;
	level.var_ae95a175 = &function_999cab02;
	level thread main();
}

/*
	Name: on_player_spawned
	Namespace: zm_stalingrad_vo
	Checksum: 0x9BF31300
	Offset: 0x1E58
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self.var_10f58653 = [];
	self.var_bac3b790 = [];
	self.var_38d92be7 = [];
	self.var_c6455b5 = [];
	self.var_2c67f767 = [];
	self.var_4b332a77 = [];
	self.var_bc80de72 = [];
	self.var_9c6abc49 = [];
	self.var_caa91bc0 = [];
	self.isspeaking = 0;
	self.n_vo_priority = 0;
	self thread zm_audio::water_vox();
	self thread function_81d644a1();
}

/*
	Name: main
	Namespace: zm_stalingrad_vo
	Checksum: 0xE633199F
	Offset: 0x1F18
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_267933e4();
	level thread function_99a382c3();
	level.craft_shield_piece_pickup_vo_override = &function_5adc22c7;
}

/*
	Name: on_player_connect
	Namespace: zm_stalingrad_vo
	Checksum: 0x840570CF
	Offset: 0x1F70
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread function_9bdbe3a4();
}

/*
	Name: function_99a382c3
	Namespace: zm_stalingrad_vo
	Checksum: 0xBB6EBEB4
	Offset: 0x1F98
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_99a382c3()
{
	level waittill(#"start_zombie_round_logic");
	var_1f76714 = [];
	var_1f76714[0] = "vox_nik1_intro_intro_0";
	var_1f76714[1] = "vox_nik1_intro_intro_1";
	level function_7aa5324a(var_1f76714, undefined, 1);
}

/*
	Name: function_218256bd
	Namespace: zm_stalingrad_vo
	Checksum: 0x35A60362
	Offset: 0x2008
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
	Namespace: zm_stalingrad_vo
	Checksum: 0xB21F8DA7
	Offset: 0x2180
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
	Name: function_8ac5430
	Namespace: zm_stalingrad_vo
	Checksum: 0xCB16FD62
	Offset: 0x21F8
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function function_8ac5430(var_b20e186c = 0, v_position = (0, 0, 0))
{
	if(var_b20e186c)
	{
		level.sndvoxoverride = 1;
		level flag::set("story_playing");
		function_2426269b(v_position, 9999);
	}
	else
	{
		level flag::clear("story_playing");
		level.sndvoxoverride = 0;
	}
}

/*
	Name: function_5eded46b
	Namespace: zm_stalingrad_vo
	Checksum: 0x7B6DE540
	Offset: 0x22B0
	Size: 0x118
	Parameters: 4
	Flags: Linked
*/
function function_5eded46b(str_vo_line, n_wait = 0, b_wait_if_busy, n_priority = 0)
{
	function_218256bd(1);
	for(i = 1; i < level.activeplayers.size; i++)
	{
		level.activeplayers[i] thread function_7b697614(str_vo_line, n_wait + 0.1, b_wait_if_busy, n_priority);
	}
	var_f77c6353 = level.activeplayers[0] function_7b697614(str_vo_line, n_wait, b_wait_if_busy, n_priority);
	function_218256bd(0);
	return var_f77c6353;
}

/*
	Name: function_7b697614
	Namespace: zm_stalingrad_vo
	Checksum: 0x6668EFF3
	Offset: 0x23D0
	Size: 0x430
	Parameters: 5
	Flags: Linked
*/
function function_7b697614(str_vo_alias, n_delay = 0, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"stop_vo_convo");
	if(level flag::get("story_playing"))
	{
		return false;
	}
	if(zm_audio::arenearbyspeakersactive(10000) && (!(isdefined(var_d1295208) && var_d1295208)))
	{
		return false;
	}
	if(isdefined(self.isspeaking) && self.isspeaking || (isdefined(level.sndvoxoverride) && level.sndvoxoverride) || (isplayer(self) && self isplayerunderwater() && !level flag::get("abcd_speaking")))
	{
		if(isdefined(b_wait_if_busy) && b_wait_if_busy)
		{
			while(isdefined(self.isspeaking) && self.isspeaking || (isdefined(level.sndvoxoverride) && level.sndvoxoverride) || (isplayer(self) && self isplayerunderwater()))
			{
				wait(0.1);
			}
			wait(0.35);
		}
		else
		{
			return false;
		}
	}
	if(n_delay > 0)
	{
		wait(n_delay);
	}
	if(isdefined(self.isspeaking) && self.isspeaking && (isdefined(self.b_wait_if_busy) && self.b_wait_if_busy))
	{
		while(isdefined(self.isspeaking) && self.isspeaking)
		{
			wait(0.1);
		}
	}
	else if(isdefined(self.isspeaking) && self.isspeaking && (!(isdefined(self.b_wait_if_busy) && self.b_wait_if_busy)) || (isdefined(level.sndvoxoverride) && level.sndvoxoverride) || (isplayer(self) && self isplayerunderwater() && !level flag::get("abcd_speaking")))
	{
		return false;
	}
	self notify(str_vo_alias + "_vo_started");
	self.isspeaking = 1;
	level.sndvoxoverride = 1;
	self thread function_b3baa665();
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
	return true;
}

/*
	Name: function_b3baa665
	Namespace: zm_stalingrad_vo
	Checksum: 0x502E2526
	Offset: 0x2808
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_b3baa665()
{
	self endon(#"hash_2f69a80e");
	self util::waittill_any("death", "disconnect");
	level.sndvoxoverride = 0;
}

/*
	Name: vo_clear
	Namespace: zm_stalingrad_vo
	Checksum: 0x1B9670C
	Offset: 0x2850
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function vo_clear()
{
	self notify(#"hash_2f69a80e");
	self.str_vo_being_spoken = "";
	self.n_vo_priority = 0;
	self.isspeaking = 0;
	level.sndvoxoverride = 0;
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
	Namespace: zm_stalingrad_vo
	Checksum: 0x45AF691
	Offset: 0x2968
	Size: 0x5C
	Parameters: 0
	Flags: None
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
	Namespace: zm_stalingrad_vo
	Checksum: 0x95BBDF5A
	Offset: 0x29D0
	Size: 0x23A
	Parameters: 2
	Flags: Linked
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
		level.sndvoxoverride = 0;
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
	Name: function_cf763858
	Namespace: zm_stalingrad_vo
	Checksum: 0xD11482F2
	Offset: 0x2C18
	Size: 0xB4
	Parameters: 0
	Flags: None
*/
function function_cf763858()
{
	if(isdefined(self.speakingline) && self.speakingline != "")
	{
		self stopsound(self.speakingline);
		self.speakingline = "";
		self.isspeaking = 0;
	}
	if(isdefined(self.str_vo_being_spoken) && self.str_vo_being_spoken != "")
	{
		self stopsound(self.str_vo_being_spoken);
		self vo_clear();
	}
}

/*
	Name: function_897246e4
	Namespace: zm_stalingrad_vo
	Checksum: 0xBCCB65EA
	Offset: 0x2CD8
	Size: 0x274
	Parameters: 5
	Flags: Linked
*/
function function_897246e4(str_vo_alias, n_wait = 0, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	a_str_tokens = strtok(str_vo_alias, "_");
	if(a_str_tokens[1] === "soph")
	{
		return function_f3477ddd(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
	if(a_str_tokens[1] === "abcd")
	{
		return function_b120c9e8(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
	if(a_str_tokens[1] === "nik1")
	{
		return function_5eded46b(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
	if(a_str_tokens[1] === "gers")
	{
		return function_84afa6c(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
	if(a_str_tokens[1] === "plr")
	{
		var_edf0b06 = int(a_str_tokens[2]);
		e_speaker = zm_utility::get_specific_character(var_edf0b06);
		if(zm_utility::is_player_valid(e_speaker))
		{
			return e_speaker function_7b697614(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
		}
	}
	else
	{
		e_speaker = undefined;
		/#
			assert(0, ("" + str_vo_alias) + "");
		#/
	}
}

/*
	Name: function_63c44c5a
	Namespace: zm_stalingrad_vo
	Checksum: 0x1B800079
	Offset: 0x2F58
	Size: 0x14C
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
		var_8cdf35ce = self function_7b697614(var_cbd11028[i], var_e27770b1, b_wait_if_busy, n_priority, var_d1295208);
		if(!(isdefined(var_8cdf35ce) && var_8cdf35ce))
		{
			function_218256bd(0);
			return;
		}
	}
	function_218256bd(0);
}

/*
	Name: function_7aa5324a
	Namespace: zm_stalingrad_vo
	Checksum: 0x54F0E094
	Offset: 0x30B0
	Size: 0x1F4
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
			var_e27770b1 = 0.5;
		}
		a_str_tokens = strtok(var_cbd11028[i], "_");
		if(a_str_tokens[1] === "abcd")
		{
			level flag::set("abcd_speaking");
		}
		var_8cdf35ce = function_897246e4(var_cbd11028[i], var_e27770b1, b_wait_if_busy, n_priority, var_d1295208);
		if(!(isdefined(var_8cdf35ce) && var_8cdf35ce))
		{
			function_218256bd(0);
			level flag::clear("abcd_speaking");
			return;
		}
	}
	function_218256bd(0);
	level flag::clear("abcd_speaking");
}

/*
	Name: function_e4acaa37
	Namespace: zm_stalingrad_vo
	Checksum: 0x16CC1A0E
	Offset: 0x32B0
	Size: 0x14C
	Parameters: 5
	Flags: Linked
*/
function function_e4acaa37(str_vo, n_delay = undefined, b_wait_if_busy = 1, n_priority = 0, var_d1295208 = 0)
{
	function_218256bd(1);
	if(!(isdefined(level.var_49d419a3) && level.var_49d419a3))
	{
		if(isdefined(self))
		{
			function_2426269b(self.origin);
		}
	}
	else
	{
		if(!b_wait_if_busy)
		{
			return;
		}
		while(isdefined(level.var_49d419a3) && level.var_49d419a3)
		{
			wait(1);
		}
	}
	level.var_49d419a3 = 1;
	self function_897246e4(str_vo, n_delay, b_wait_if_busy, n_priority, var_d1295208);
	level.var_49d419a3 = 0;
	function_218256bd(0);
}

/*
	Name: function_280223ba
	Namespace: zm_stalingrad_vo
	Checksum: 0xD77D8E37
	Offset: 0x3408
	Size: 0x134
	Parameters: 5
	Flags: Linked
*/
function function_280223ba(var_d44b84c3, var_12fe9129 = undefined, b_wait_if_busy = 1, n_priority = 0, var_d1295208 = 0)
{
	function_218256bd(1);
	if(!(isdefined(level.var_49d419a3) && level.var_49d419a3))
	{
		function_2426269b(self.origin, 10000);
	}
	else
	{
		while(isdefined(level.var_49d419a3) && level.var_49d419a3)
		{
			wait(1);
		}
	}
	level.var_49d419a3 = 1;
	self function_7aa5324a(var_d44b84c3, var_12fe9129, b_wait_if_busy, n_priority, var_d1295208);
	level.var_49d419a3 = 0;
	function_218256bd(0);
}

/*
	Name: function_6f2aecbd
	Namespace: zm_stalingrad_vo
	Checksum: 0x4D3B7FCC
	Offset: 0x3548
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_6f2aecbd()
{
	while(isdefined(level.var_49d419a3) && level.var_49d419a3)
	{
		wait(1);
	}
}

/*
	Name: custom_get_mod_type
	Namespace: zm_stalingrad_vo
	Checksum: 0x38789A7C
	Offset: 0x3578
	Size: 0x4E6
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
	if(weapon.name == "launcher_multi")
	{
		return "default";
	}
	if(weapon.name == "dragonshield" || weapon.name == "dragonshield_upgraded" && mod == "MOD_UNKNOWN")
	{
		if(!instakill)
		{
			return "dragon_shield";
		}
		return "weapon_instakill";
	}
	if(weapon.name == "raygun_mark3" || weapon.name == "raygun_mark3_upgraded")
	{
		if(!instakill)
		{
			if(mod == "MOD_GRENADE" || mod == "MOD_UNKNOWN")
			{
				return "raygun3_singularity";
			}
			return "raygun3";
		}
		return "weapon_instakill";
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
	if(weapon.name == "ray_gun" || weapon.name == "ray_gun_upgraded" && dist > far_dist)
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
	if(mod == "MOD_MELEE" || mod == "MOD_UNKNOWN" && dist < close_dist)
	{
		if(!instakill)
		{
			return "melee";
		}
		return "melee_instakill";
	}
	if(zm_utility::is_explosive_damage(mod) && weapon.name != "ray_gun" && weapon.name != "ray_gun_upgraded" && (!(isdefined(zombie.is_on_fire) && zombie.is_on_fire)) && weapon.name != "raygun_mark3" && weapon.name != "raygun_mark3_upgraded")
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
	if(mod != "MOD_MELEE" && zombie.missinglegs)
	{
		return "crawler";
	}
	if(mod != "MOD_BURNED" && dist < close_dist)
	{
		return "close";
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
	return "default";
}

/*
	Name: function_f3477ddd
	Namespace: zm_stalingrad_vo
	Checksum: 0xBD038B87
	Offset: 0x3A68
	Size: 0xB0
	Parameters: 4
	Flags: Linked
*/
function function_f3477ddd(str_vo_alias, n_wait, b_wait_if_busy, n_priority)
{
	if(!level flag::get("power_on"))
	{
		return 0;
	}
	self function_8e20db7c(1);
	b_result = level.var_a090a655 function_7b697614(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	self function_8e20db7c(0);
	return b_result;
}

/*
	Name: function_8e20db7c
	Namespace: zm_stalingrad_vo
	Checksum: 0xC5B35DC3
	Offset: 0x3B20
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function function_8e20db7c(var_9773d40e)
{
	if(self == level)
	{
		var_358abd8e = getentarray("sophia_vo_eye", "script_noteworthy");
		foreach(var_1c7b6837 in var_358abd8e)
		{
			var_1c7b6837 function_a80e8dfb(var_9773d40e);
		}
		if(!level flag::get("sophia_escaped"))
		{
			level clientfield::set("sophia_main_waveform", var_9773d40e);
		}
	}
	else
	{
		if(self == level.var_a090a655)
		{
			if(!level flag::get("sophia_escaped"))
			{
				level clientfield::set("sophia_main_waveform", var_9773d40e);
			}
		}
		else
		{
			self function_a80e8dfb(var_9773d40e);
		}
	}
}

/*
	Name: function_a80e8dfb
	Namespace: zm_stalingrad_vo
	Checksum: 0x484DA2E4
	Offset: 0x3CA0
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function function_a80e8dfb(var_9773d40e)
{
	switch(self.model)
	{
		case "p7_zm_sta_drop_pod_console_blue":
		case "p7_zm_sta_drop_pod_console_red":
		case "p7_zm_sta_drop_pod_console_yellow":
		{
			var_cc8e7aaf = "tag_screen_eye_bg";
			var_f329b7ad = "tag_screen_eye_flatline";
			break;
		}
		case "p7_zm_sta_dragon_console":
		{
			var_cc8e7aaf = "tag_eye_bg_animate";
			var_f329b7ad = "tag_eye_flatline_animate";
			break;
		}
		default:
		{
			return;
		}
	}
	if(var_9773d40e)
	{
		self showpart(var_cc8e7aaf);
		self hidepart(var_f329b7ad);
	}
	else
	{
		self hidepart(var_cc8e7aaf);
		self showpart(var_f329b7ad);
	}
}

/*
	Name: function_84afa6c
	Namespace: zm_stalingrad_vo
	Checksum: 0xE16BA05F
	Offset: 0x3DB0
	Size: 0x94
	Parameters: 4
	Flags: Linked
*/
function function_84afa6c(str_vo_alias, n_wait, b_wait_if_busy, n_priority)
{
	if(self == level)
	{
		b_result = function_5eded46b(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
	else
	{
		b_result = self function_7b697614(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
	return b_result;
}

/*
	Name: function_772aa229
	Namespace: zm_stalingrad_vo
	Checksum: 0xF6818CD3
	Offset: 0x3E50
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function function_772aa229()
{
	self endon(#"_zombie_game_over");
	while(true)
	{
		level waittill(#"start_of_round");
		if(level.activeplayers.size == 1)
		{
			level thread function_54cd030a();
		}
		else
		{
			level thread function_cc4d4a7c();
		}
		level waittill(#"end_of_round");
		if(level.activeplayers.size == 1)
		{
			level thread function_340dc03();
		}
		else
		{
			level thread function_7ca05725();
		}
	}
}

/*
	Name: function_54cd030a
	Namespace: zm_stalingrad_vo
	Checksum: 0xB2499C2B
	Offset: 0x3F08
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function function_54cd030a()
{
	if(level.round_number <= 1)
	{
		e_speaker = level.players[0];
		var_9b0dffc6 = [];
		if(!isdefined(var_9b0dffc6))
		{
			var_9b0dffc6 = [];
		}
		else if(!isarray(var_9b0dffc6))
		{
			var_9b0dffc6 = array(var_9b0dffc6);
		}
		var_9b0dffc6[var_9b0dffc6.size] = function_11b41a76(e_speaker.characterindex, "round_start_solo", level.round_number);
		if(level.round_number == 1 && (e_speaker.characterindex == 1 || e_speaker.characterindex == 0))
		{
			var_12fe9129 = [];
			if(!isdefined(var_12fe9129))
			{
				var_12fe9129 = [];
			}
			else if(!isarray(var_12fe9129))
			{
				var_12fe9129 = array(var_12fe9129);
			}
			var_12fe9129[var_12fe9129.size] = 0.5;
			if(!isdefined(var_12fe9129))
			{
				var_12fe9129 = [];
			}
			else if(!isarray(var_12fe9129))
			{
				var_12fe9129 = array(var_12fe9129);
			}
			var_12fe9129[var_12fe9129.size] = 1;
			if(!isdefined(var_9b0dffc6))
			{
				var_9b0dffc6 = [];
			}
			else if(!isarray(var_9b0dffc6))
			{
				var_9b0dffc6 = array(var_9b0dffc6);
			}
			var_9b0dffc6[var_9b0dffc6.size] = function_11b41a76(e_speaker.characterindex, "round", level.round_number, "start_solo_1");
		}
		e_speaker thread function_280223ba(var_9b0dffc6, var_12fe9129);
	}
}

/*
	Name: function_340dc03
	Namespace: zm_stalingrad_vo
	Checksum: 0x30603CA1
	Offset: 0x4188
	Size: 0xFE
	Parameters: 0
	Flags: Linked
*/
function function_340dc03()
{
	var_5df8c4ee = level.round_number - 1;
	if(var_5df8c4ee <= 3)
	{
		e_speaker = level.players[0];
		switch(var_5df8c4ee)
		{
			case 2:
			{
				e_speaker thread function_548ee78b();
				break;
			}
			case 3:
			{
				e_speaker thread function_9430edac();
				break;
			}
			default:
			{
				var_380dee9e = function_11b41a76(e_speaker.characterindex, "round_end_solo", var_5df8c4ee);
				e_speaker function_e4acaa37(var_380dee9e);
				break;
			}
		}
	}
}

/*
	Name: function_548ee78b
	Namespace: zm_stalingrad_vo
	Checksum: 0xF2EEAA2C
	Offset: 0x4290
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function function_548ee78b()
{
	var_5df8c4ee = level.round_number - 1;
	var_569a64cf = [];
	if(!isdefined(var_569a64cf))
	{
		var_569a64cf = [];
	}
	else if(!isarray(var_569a64cf))
	{
		var_569a64cf = array(var_569a64cf);
	}
	var_569a64cf[var_569a64cf.size] = "vox_nik1_round2_end_0";
	if(self.characterindex == 3)
	{
		for(i = 0; i < 3; i++)
		{
			if(!isdefined(var_569a64cf))
			{
				var_569a64cf = [];
			}
			else if(!isarray(var_569a64cf))
			{
				var_569a64cf = array(var_569a64cf);
			}
			var_569a64cf[var_569a64cf.size] = function_11b41a76(self.characterindex, "round", var_5df8c4ee, "end_solo_" + i);
		}
	}
	else
	{
		if(!isdefined(var_569a64cf))
		{
			var_569a64cf = [];
		}
		else if(!isarray(var_569a64cf))
		{
			var_569a64cf = array(var_569a64cf);
		}
		var_569a64cf[var_569a64cf.size] = function_11b41a76(self.characterindex, "round_end_solo", var_5df8c4ee);
	}
	self function_280223ba(var_569a64cf);
}

/*
	Name: function_9430edac
	Namespace: zm_stalingrad_vo
	Checksum: 0x93FBDE6
	Offset: 0x4480
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_9430edac()
{
	var_3097ea66 = [];
	if(!isdefined(var_3097ea66))
	{
		var_3097ea66 = [];
	}
	else if(!isarray(var_3097ea66))
	{
		var_3097ea66 = array(var_3097ea66);
	}
	var_3097ea66[var_3097ea66.size] = "vox_nik1_round3_end_1";
	if(self.characterindex == 2)
	{
		if(!isdefined(var_3097ea66))
		{
			var_3097ea66 = [];
		}
		else if(!isarray(var_3097ea66))
		{
			var_3097ea66 = array(var_3097ea66);
		}
		var_3097ea66[var_3097ea66.size] = ("vox_plr_" + 2) + "_round3_end_response_1_0";
	}
	else
	{
		if(!isdefined(var_3097ea66))
		{
			var_3097ea66 = [];
		}
		else if(!isarray(var_3097ea66))
		{
			var_3097ea66 = array(var_3097ea66);
		}
		var_3097ea66[var_3097ea66.size] = ("vox_plr_" + self.characterindex) + "_round3_end_response_0_0";
	}
	self function_280223ba(var_3097ea66);
}

/*
	Name: function_cc4d4a7c
	Namespace: zm_stalingrad_vo
	Checksum: 0xDE40FAFB
	Offset: 0x4608
	Size: 0x484
	Parameters: 0
	Flags: Linked
*/
function function_cc4d4a7c()
{
	a_players = arraycopy(level.activeplayers);
	var_ec0ce895 = function_fcea1c5c();
	if(level.round_number == 1)
	{
		if(isdefined(var_ec0ce895))
		{
			var_1f76714 = [];
			var_12fe9129 = [];
			var_261100d2 = function_4bf4ac40(var_ec0ce895.origin, 2);
			if(!isdefined(var_12fe9129))
			{
				var_12fe9129 = [];
			}
			else if(!isarray(var_12fe9129))
			{
				var_12fe9129 = array(var_12fe9129);
			}
			var_12fe9129[var_12fe9129.size] = 0.5;
			if(!isdefined(var_1f76714))
			{
				var_1f76714 = [];
			}
			else if(!isarray(var_1f76714))
			{
				var_1f76714 = array(var_1f76714);
			}
			var_1f76714[var_1f76714.size] = function_11b41a76(var_261100d2.characterindex, "round_start_coop", level.round_number);
			if(!isdefined(var_12fe9129))
			{
				var_12fe9129 = [];
			}
			else if(!isarray(var_12fe9129))
			{
				var_12fe9129 = array(var_12fe9129);
			}
			var_12fe9129[var_12fe9129.size] = 0.5;
			if(!isdefined(var_1f76714))
			{
				var_1f76714 = [];
			}
			else if(!isarray(var_1f76714))
			{
				var_1f76714 = array(var_1f76714);
			}
			var_1f76714[var_1f76714.size] = "vox_plr_2_round1_start_response_0_0";
			if(!isdefined(var_12fe9129))
			{
				var_12fe9129 = [];
			}
			else if(!isarray(var_12fe9129))
			{
				var_12fe9129 = array(var_12fe9129);
			}
			var_12fe9129[var_12fe9129.size] = 3;
			var_4c137b3b = function_4bf4ac40(var_ec0ce895.origin, 2);
			if(!isdefined(var_1f76714))
			{
				var_1f76714 = [];
			}
			else if(!isarray(var_1f76714))
			{
				var_1f76714 = array(var_1f76714);
			}
			var_1f76714[var_1f76714.size] = ("vox_plr_" + var_4c137b3b.characterindex) + "_see_dragon_0";
			if(!isdefined(var_12fe9129))
			{
				var_12fe9129 = [];
			}
			else if(!isarray(var_12fe9129))
			{
				var_12fe9129 = array(var_12fe9129);
			}
			var_12fe9129[var_12fe9129.size] = 0.5;
			if(!isdefined(var_1f76714))
			{
				var_1f76714 = [];
			}
			else if(!isarray(var_1f76714))
			{
				var_1f76714 = array(var_1f76714);
			}
			var_1f76714[var_1f76714.size] = "vox_plr_2_see_dragon_0";
			var_ec0ce895 thread function_280223ba(var_1f76714);
		}
		else
		{
			e_speaker = array::random(a_players);
			str_vo_line = ("vox_plr_" + var_ec0ce895.characterindex) + "_see_dragon_0";
			e_speaker function_897246e4(str_vo_line);
		}
	}
}

/*
	Name: function_7ca05725
	Namespace: zm_stalingrad_vo
	Checksum: 0xBBF910E4
	Offset: 0x4A98
	Size: 0x40C
	Parameters: 0
	Flags: Linked
*/
function function_7ca05725()
{
	var_5df8c4ee = level.round_number - 1;
	if(var_5df8c4ee <= 3)
	{
		var_40f9ef55 = [];
		if(var_5df8c4ee == 2)
		{
			if(!isdefined(var_40f9ef55))
			{
				var_40f9ef55 = [];
			}
			else if(!isarray(var_40f9ef55))
			{
				var_40f9ef55 = array(var_40f9ef55);
			}
			var_40f9ef55[var_40f9ef55.size] = "vox_nik1_round2_end_0";
		}
		else if(var_5df8c4ee == 3)
		{
			if(!isdefined(var_40f9ef55))
			{
				var_40f9ef55 = [];
			}
			else if(!isarray(var_40f9ef55))
			{
				var_40f9ef55 = array(var_40f9ef55);
			}
			var_40f9ef55[var_40f9ef55.size] = "vox_nik1_round3_end_1";
		}
		var_ec0ce895 = function_fcea1c5c();
		if(isdefined(var_ec0ce895))
		{
			var_4744223c = function_4bf4ac40(var_ec0ce895.origin, 2);
			if(isdefined(var_4744223c))
			{
				switch(var_5df8c4ee)
				{
					case 1:
					{
						if(!isdefined(var_40f9ef55))
						{
							var_40f9ef55 = [];
						}
						else if(!isarray(var_40f9ef55))
						{
							var_40f9ef55 = array(var_40f9ef55);
						}
						var_40f9ef55[var_40f9ef55.size] = function_11b41a76(var_4744223c.characterindex, "round_end_coop", var_5df8c4ee);
						if(!isdefined(var_40f9ef55))
						{
							var_40f9ef55 = [];
						}
						else if(!isarray(var_40f9ef55))
						{
							var_40f9ef55 = array(var_40f9ef55);
						}
						var_40f9ef55[var_40f9ef55.size] = function_11b41a76(var_ec0ce895.characterindex, "round", var_5df8c4ee, "end_response_0_0");
						break;
					}
					case 2:
					case 3:
					{
						if(!isdefined(var_40f9ef55))
						{
							var_40f9ef55 = [];
						}
						else if(!isarray(var_40f9ef55))
						{
							var_40f9ef55 = array(var_40f9ef55);
						}
						var_40f9ef55[var_40f9ef55.size] = function_11b41a76(var_4744223c.characterindex, "round", var_5df8c4ee, "end_response_0_0");
						if(!isdefined(var_40f9ef55))
						{
							var_40f9ef55 = [];
						}
						else if(!isarray(var_40f9ef55))
						{
							var_40f9ef55 = array(var_40f9ef55);
						}
						var_40f9ef55[var_40f9ef55.size] = function_11b41a76(var_ec0ce895.characterindex, "round", var_5df8c4ee, "end_response_1_0");
						break;
					}
				}
			}
		}
		if(var_40f9ef55.size)
		{
			level thread function_280223ba(var_40f9ef55);
		}
	}
	else if(level.round_number >= 5)
	{
		level thread function_3cdbc215();
	}
}

/*
	Name: function_267933e4
	Namespace: zm_stalingrad_vo
	Checksum: 0x22371D04
	Offset: 0x4EB0
	Size: 0x7E6
	Parameters: 0
	Flags: Linked
*/
function function_267933e4()
{
	level.var_b7e67f82 = array(0, 0, 0, 0);
	var_85fdde46 = [];
	var_85fdde46[0] = array("vox_plr_0_interaction_demp_niko_1_0", "vox_plr_1_interaction_demp_niko_1_0");
	var_85fdde46[1] = array("vox_plr_0_interaction_demp_niko_2_0", "vox_plr_1_interaction_demp_niko_2_0");
	var_85fdde46[2] = array("vox_plr_0_interaction_demp_niko_3_0", "vox_plr_1_interaction_demp_niko_3_0");
	var_85fdde46[3] = array("vox_plr_0_interaction_demp_niko_4_0", "vox_plr_1_interaction_demp_niko_4_0");
	var_85fdde46[4] = array("vox_plr_0_interaction_demp_niko_5_0", "vox_plr_1_interaction_demp_niko_5_0");
	level.var_85fdde46 = var_85fdde46;
	level.var_5705772e = 0;
	level.var_b7e67f82[0] = level.var_b7e67f82[0] + var_85fdde46.size;
	level.var_b7e67f82[1] = level.var_b7e67f82[1] + var_85fdde46.size;
	var_559f698d = [];
	var_559f698d[0] = array("vox_plr_0_interaction_rich_demp_1_0", "vox_plr_2_interaction_rich_demp_1_0");
	var_559f698d[1] = array("vox_plr_0_interaction_rich_demp_2_0", "vox_plr_2_interaction_rich_demp_2_0");
	var_559f698d[2] = array("vox_plr_0_interaction_rich_demp_3_0", "vox_plr_2_interaction_rich_demp_3_0");
	var_559f698d[3] = array("vox_plr_0_interaction_rich_demp_4_0", "vox_plr_2_interaction_rich_demp_4_0");
	var_559f698d[4] = array("vox_plr_0_interaction_rich_demp_5_0", "vox_plr_2_interaction_rich_demp_5_0");
	level.var_559f698d = var_559f698d;
	level.var_d9e67775 = 0;
	level.var_b7e67f82[0] = level.var_b7e67f82[0] + var_559f698d.size;
	level.var_b7e67f82[2] = level.var_b7e67f82[2] + var_559f698d.size;
	var_b16db601 = [];
	var_b16db601[0] = array("vox_plr_0_interaction_demp_takeo_1_0", "vox_plr_3_interaction_demp_takeo_1_0");
	var_b16db601[1] = array("vox_plr_0_interaction_demp_takeo_2_0", "vox_plr_3_interaction_demp_takeo_2_0");
	var_b16db601[2] = array("vox_plr_0_interaction_demp_takeo_3_0", "vox_plr_3_interaction_demp_takeo_3_0");
	var_b16db601[3] = array("vox_plr_0_interaction_demp_takeo_4_0", "vox_plr_3_interaction_demp_takeo_4_0");
	var_b16db601[4] = array("vox_plr_0_interaction_demp_takeo_5_0", "vox_plr_3_interaction_demp_takeo_5_0");
	level.var_b16db601 = var_b16db601;
	level.var_a47c9479 = 0;
	level.var_b7e67f82[0] = level.var_b7e67f82[0] + var_b16db601.size;
	level.var_b7e67f82[3] = level.var_b7e67f82[3] + var_b16db601.size;
	var_4d918dae = [];
	var_4d918dae[0] = array("vox_plr_2_interaction_rich_niko_1_0", "vox_plr_1_interaction_rich_niko_1_0");
	var_4d918dae[1] = array("vox_plr_2_interaction_rich_niko_2_0", "vox_plr_1_interaction_rich_niko_2_0");
	var_4d918dae[2] = array("vox_plr_2_interaction_rich_niko_3_0", "vox_plr_1_interaction_rich_niko_3_0");
	var_4d918dae[3] = array("vox_plr_1_interaction_rich_niko_4_0", "vox_plr_2_interaction_rich_niko_4_0");
	var_4d918dae[4] = array("vox_plr_1_interaction_rich_niko_5_0", "vox_plr_2_interaction_rich_niko_5_0");
	level.var_4d918dae = var_4d918dae;
	level.var_2ed438a6 = 0;
	level.var_b7e67f82[1] = level.var_b7e67f82[1] + var_4d918dae.size;
	level.var_b7e67f82[2] = level.var_b7e67f82[2] + var_4d918dae.size;
	var_ec060c98 = [];
	var_ec060c98[0] = array("vox_plr_3_interaction_takeo_niko_1_0", "vox_plr_1_interaction_takeo_niko_1_0");
	var_ec060c98[1] = array("vox_plr_1_interaction_takeo_niko_2_0", "vox_plr_3_interaction_takeo_niko_2_0");
	var_ec060c98[2] = array("vox_plr_3_interaction_takeo_niko_3_0", "vox_plr_1_interaction_takeo_niko_3_0");
	var_ec060c98[3] = array("vox_plr_1_interaction_takeo_niko_4_0", "vox_plr_3_interaction_takeo_niko_4_0");
	var_ec060c98[4] = array("vox_plr_1_interaction_takeo_niko_5_0", "vox_plr_3_interaction_takeo_niko_5_0");
	level.var_ec060c98 = var_ec060c98;
	level.var_e06e7300 = 0;
	level.var_b7e67f82[1] = level.var_b7e67f82[1] + var_ec060c98.size;
	level.var_b7e67f82[3] = level.var_b7e67f82[3] + var_ec060c98.size;
	var_4303fff9 = [];
	var_4303fff9[0] = array("vox_plr_3_interaction_rich_takeo_1_0", "vox_plr_2_interaction_rich_takeo_1_0");
	var_4303fff9[1] = array("vox_plr_3_interaction_rich_takeo_2_0", "vox_plr_2_interaction_rich_takeo_2_0");
	var_4303fff9[2] = array("vox_plr_3_interaction_rich_takeo_3_0", "vox_plr_2_interaction_rich_takeo_3_0");
	var_4303fff9[3] = array("vox_plr_3_interaction_rich_takeo_4_0", "vox_plr_2_interaction_rich_takeo_4_0");
	var_4303fff9[4] = array("vox_plr_3_interaction_rich_takeo_5_0", "vox_plr_2_interaction_rich_takeo_5_0");
	level.var_4303fff9 = var_4303fff9;
	level.var_2e004fe1 = 0;
	level.var_b7e67f82[2] = level.var_b7e67f82[2] + var_4303fff9.size;
	level.var_b7e67f82[3] = level.var_b7e67f82[3] + var_4303fff9.size;
	var_312fb587 = 11;
	var_7ccadaab = getdvarint("loc_language");
	if(var_7ccadaab === var_312fb587)
	{
		var_4303fff9[2] = array("vox_plr_3_interaction_rich_takeo_3_jap_alt_0", "vox_plr_2_interaction_rich_takeo_3_japalt_0");
	}
}

/*
	Name: function_3cdbc215
	Namespace: zm_stalingrad_vo
	Checksum: 0x89C96D94
	Offset: 0x56A0
	Size: 0x684
	Parameters: 0
	Flags: Linked
*/
function function_3cdbc215()
{
	if(level.activeplayers.size > 1)
	{
		a_players = array::randomize(level.activeplayers);
		var_e8669 = undefined;
		var_261100d2 = undefined;
		do
		{
			var_e8669 = a_players[0];
			arrayremovevalue(a_players, var_e8669);
		}
		while(a_players.size > 0 && level.var_b7e67f82[var_e8669.characterindex] === 0);
		if(level.var_b7e67f82[var_e8669.characterindex] > 0)
		{
			do
			{
				var_261100d2 = arraygetclosest(var_e8669.origin, a_players, 1000);
				arrayremovevalue(a_players, var_261100d2);
			}
			while(a_players.size > 0 && isdefined(var_261100d2) && level.var_b7e67f82[var_261100d2.characterindex] === 0);
		}
		var_a40c0bd2 = 0;
		var_b89804c3 = 0;
		if(isdefined(var_e8669))
		{
			var_a40c0bd2 = level.var_b7e67f82[var_e8669.characterindex];
		}
		if(isdefined(var_261100d2))
		{
			var_b89804c3 = level.var_b7e67f82[var_261100d2.characterindex];
		}
		if(var_a40c0bd2 > 0 && var_b89804c3 > 0)
		{
			if(var_e8669.characterindex == 0 && var_261100d2.characterindex == 1 || (var_261100d2.characterindex == 0 && var_e8669.characterindex == 1))
			{
				if(level.var_5705772e < level.var_85fdde46.size)
				{
					var_e8669 thread function_280223ba(level.var_85fdde46[level.var_5705772e]);
					level.var_5705772e++;
					level.var_b7e67f82[0]--;
					level.var_b7e67f82[1]--;
				}
			}
			else
			{
				if(var_e8669.characterindex == 0 && var_261100d2.characterindex == 2 || (var_261100d2.characterindex == 0 && var_e8669.characterindex == 2))
				{
					if(level.var_d9e67775 < level.var_559f698d.size)
					{
						var_e8669 thread function_280223ba(level.var_559f698d[level.var_d9e67775]);
						level.var_d9e67775++;
						level.var_b7e67f82[0]--;
						level.var_b7e67f82[2]--;
					}
				}
				else
				{
					if(var_e8669.characterindex == 0 && var_261100d2.characterindex == 3 || (var_261100d2.characterindex == 0 && var_e8669.characterindex == 3))
					{
						if(level.var_a47c9479 < level.var_b16db601.size)
						{
							var_e8669 thread function_280223ba(level.var_b16db601[level.var_a47c9479]);
							level.var_a47c9479++;
							level.var_b7e67f82[0]--;
							level.var_b7e67f82[3]--;
						}
					}
					else
					{
						if(var_e8669.characterindex == 1 && var_261100d2.characterindex == 2 || (var_261100d2.characterindex == 1 && var_e8669.characterindex == 2))
						{
							if(level.var_2ed438a6 < level.var_4d918dae.size)
							{
								var_e8669 thread function_280223ba(level.var_4d918dae[level.var_2ed438a6]);
								level.var_2ed438a6++;
								level.var_b7e67f82[1]--;
								level.var_b7e67f82[2]--;
							}
						}
						else
						{
							if(var_e8669.characterindex == 1 && var_261100d2.characterindex == 3 || (var_261100d2.characterindex == 1 && var_e8669.characterindex == 3))
							{
								if(level.var_e06e7300 < level.var_ec060c98.size)
								{
									var_e8669 thread function_280223ba(level.var_ec060c98[level.var_e06e7300]);
									level.var_e06e7300++;
									level.var_b7e67f82[1]--;
									level.var_b7e67f82[3]--;
								}
							}
							else if(var_e8669.characterindex == 2 && var_261100d2.characterindex == 3 || (var_261100d2.characterindex == 2 && var_e8669.characterindex == 3))
							{
								if(level.var_2e004fe1 < level.var_4303fff9.size)
								{
									var_e8669 thread function_280223ba(level.var_4303fff9[level.var_2e004fe1]);
									level.var_2e004fe1++;
									level.var_b7e67f82[2]--;
									level.var_b7e67f82[3]--;
								}
							}
						}
					}
				}
			}
		}
		else
		{
			/#
				iprintln("");
			#/
		}
	}
}

/*
	Name: function_3a92f7f
	Namespace: zm_stalingrad_vo
	Checksum: 0x91E0681D
	Offset: 0x5D30
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_3a92f7f()
{
	var_4355dfed = function_2889c0e9("vox_soph_module_deployed_", 5);
	level function_897246e4(var_4355dfed);
}

/*
	Name: function_90ce0342
	Namespace: zm_stalingrad_vo
	Checksum: 0x4B9BBEE7
	Offset: 0x5D88
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_90ce0342()
{
	var_9a1a15df = function_2889c0e9("vox_soph_module_attacked_", 5);
	level function_897246e4(var_9a1a15df);
}

/*
	Name: function_2b34512a
	Namespace: zm_stalingrad_vo
	Checksum: 0x9005A3FE
	Offset: 0x5DE0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_2b34512a(var_be294ae5)
{
	wait(1);
	var_c180c43f = function_2889c0e9("vox_soph_module_destroyed_", 5);
	level function_897246e4(var_c180c43f);
	level function_233dcc5d(var_be294ae5);
}

/*
	Name: function_eaf2cef3
	Namespace: zm_stalingrad_vo
	Checksum: 0x934259AD
	Offset: 0x5E58
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_eaf2cef3()
{
	if(function_e9a29b5(level.var_e8b08c25))
	{
		return;
	}
	var_dd03e3f6 = function_2889c0e9("vox_soph_code_required_", 5);
	level function_897246e4(var_dd03e3f6);
	level.var_e8b08c25 = gettime() + 10000;
}

/*
	Name: function_c0135bef
	Namespace: zm_stalingrad_vo
	Checksum: 0xEE5CD5BB
	Offset: 0x5ED8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_c0135bef()
{
	if(function_e9a29b5(level.var_e8b08c25))
	{
		return;
	}
	var_b2861b18 = function_2889c0e9("vox_soph_code_incorrect_", 5);
	level function_897246e4(var_b2861b18);
	level.var_e8b08c25 = gettime() + 10000;
}

/*
	Name: function_cfb82bef
	Namespace: zm_stalingrad_vo
	Checksum: 0x57E7BCCA
	Offset: 0x5F58
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_cfb82bef()
{
	if(!isdefined(level.var_e9a8158b))
	{
		level.var_e9a8158b = array("vox_soph_dragon_control_non_op_0", "vox_soph_dragon_control_non_op_1", "vox_soph_dragon_control_non_op_2");
	}
	else if(level.var_e9a8158b.size == 0)
	{
		return;
	}
	if(function_e9a29b5(level.var_3275e4b))
	{
		return;
	}
	str_vo_line = array::random(level.var_e9a8158b);
	level function_897246e4(str_vo_line);
	arrayremovevalue(level.var_e9a8158b, str_vo_line);
	level.var_3275e4b = gettime() + 10000;
}

/*
	Name: function_6576bb4b
	Namespace: zm_stalingrad_vo
	Checksum: 0xB32930A9
	Offset: 0x6050
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_6576bb4b()
{
	level function_e4acaa37("vox_soph_pap_quest_activate_0");
}

/*
	Name: function_902b2a27
	Namespace: zm_stalingrad_vo
	Checksum: 0x7D3E4139
	Offset: 0x6080
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_902b2a27()
{
	if(!isdefined(level.var_72dfb1e3))
	{
		level.var_72dfb1e3 = array("vox_soph_dragon_unavailable_0", "vox_soph_dragon_unavailable_1", "vox_soph_dragon_unavailable_2");
	}
	else if(level.var_72dfb1e3.size == 0)
	{
		return;
	}
	if(function_e9a29b5(level.var_3275e4b))
	{
		return;
	}
	str_vo_line = array::random(level.var_72dfb1e3);
	level function_897246e4(str_vo_line);
	arrayremovevalue(level.var_72dfb1e3, str_vo_line);
	level.var_3275e4b = gettime() + 10000;
}

/*
	Name: function_4311e03d
	Namespace: zm_stalingrad_vo
	Checksum: 0xD7B3B7D4
	Offset: 0x6178
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_4311e03d()
{
	var_3df7a35d = function_2889c0e9("vox_soph_dragon_summon_", 5);
	level function_897246e4(var_3df7a35d);
}

/*
	Name: function_c9fde593
	Namespace: zm_stalingrad_vo
	Checksum: 0x1FD26E12
	Offset: 0x61D0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_c9fde593()
{
	var_cf1b033 = function_2889c0e9("vox_soph_dragon_departing_", 5);
	level function_897246e4(var_cf1b033);
}

/*
	Name: function_3800b6e0
	Namespace: zm_stalingrad_vo
	Checksum: 0x5B753989
	Offset: 0x6228
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_3800b6e0()
{
	var_38af3ce3 = function_2889c0e9("vox_soph_drone_round_", 5);
	level function_897246e4(var_38af3ce3);
}

/*
	Name: function_d2ea8c30
	Namespace: zm_stalingrad_vo
	Checksum: 0x1CBDB725
	Offset: 0x6288
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_d2ea8c30()
{
	level function_e4acaa37("vox_soph_controller_quest_lockdown_end_3");
	level function_73928e79();
}

/*
	Name: function_b86ec8c9
	Namespace: zm_stalingrad_vo
	Checksum: 0x3AA2F7ED
	Offset: 0x62D0
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function function_b86ec8c9()
{
	if(!isdefined(self.var_22e4c94d))
	{
		self.var_22e4c94d = [];
		for(i = 0; i < 4; i++)
		{
			if(!isdefined(self.var_22e4c94d))
			{
				self.var_22e4c94d = [];
			}
			else if(!isarray(self.var_22e4c94d))
			{
				self.var_22e4c94d = array(self.var_22e4c94d);
			}
			self.var_22e4c94d[self.var_22e4c94d.size] = i;
		}
		if(self.characterindex != 0)
		{
			if(!isdefined(self.var_22e4c94d))
			{
				self.var_22e4c94d = [];
			}
			else if(!isarray(self.var_22e4c94d))
			{
				self.var_22e4c94d = array(self.var_22e4c94d);
			}
			self.var_22e4c94d[self.var_22e4c94d.size] = 4;
		}
	}
	if(isalive(self) && !self laststand::player_is_in_laststand())
	{
		n_line = array::random(self.var_22e4c94d);
		arrayremovevalue(self.var_22e4c94d, n_line);
		str_vo = (("vox_plr_" + self.characterindex) + "_dragon_attack_") + n_line;
		self thread function_897246e4(str_vo);
	}
}

/*
	Name: function_44c4e12c
	Namespace: zm_stalingrad_vo
	Checksum: 0x3B57FA2A
	Offset: 0x64C8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_44c4e12c()
{
	self thread function_897246e4(("vox_plr_" + self.characterindex) + "_weap_quest_egg_0");
	level thread function_591500ac();
}

/*
	Name: function_591500ac
	Namespace: zm_stalingrad_vo
	Checksum: 0xD95C86D9
	Offset: 0x6520
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_591500ac()
{
	level flag::wait_till("gauntlet_step_2_complete");
	e_speaker = function_4bf4ac40();
	e_speaker thread function_897246e4(("vox_plr_" + e_speaker.characterindex) + "_challenge_headshots_0");
	level flag::wait_till("gauntlet_step_3_complete");
	e_speaker = function_4bf4ac40();
	e_speaker thread function_897246e4(("vox_plr_" + e_speaker.characterindex) + "_challenge_penetrating_0");
	level flag::wait_till("gauntlet_step_4_complete");
	e_speaker = function_4bf4ac40();
	e_speaker thread function_897246e4(("vox_plr_" + e_speaker.characterindex) + "_challenge_melee_0");
}

/*
	Name: function_e068138
	Namespace: zm_stalingrad_vo
	Checksum: 0xD0CE494B
	Offset: 0x6670
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_e068138()
{
	var_daf4b487 = ("vox_plr_" + self.characterindex) + "_egg_incubator_0";
	var_1f76714 = array(var_daf4b487, "vox_soph_whelp_quest_incubation_0", "vox_soph_whelp_quest_lockdown_0");
	level function_280223ba(var_1f76714);
}

/*
	Name: function_9bdbe3a4
	Namespace: zm_stalingrad_vo
	Checksum: 0xB174FB45
	Offset: 0x66F0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_9bdbe3a4()
{
	level endon(#"_zombie_game_over");
	while(true)
	{
		self waittill(#"weapon_give", w_weapon);
		if(w_weapon == self.weapon_dragon_gauntlet)
		{
			self thread function_897246e4(("vox_plr_" + self.characterindex) + "_dragon_glove_aquire_0");
			break;
		}
	}
}

/*
	Name: function_8141c730
	Namespace: zm_stalingrad_vo
	Checksum: 0xA43D54D2
	Offset: 0x6770
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_8141c730()
{
	var_765a3ab1 = level function_1cbd9399();
	var_f18ce775 = "vox_soph_main_ee_power_on_0_0";
	level function_e4acaa37(var_f18ce775);
	str_response = ("vox_plr_" + var_765a3ab1) + "_main_ee_power_on_1_0";
	level thread function_e4acaa37(str_response);
}

/*
	Name: function_1f1e411c
	Namespace: zm_stalingrad_vo
	Checksum: 0x244510D1
	Offset: 0x6808
	Size: 0x28C
	Parameters: 0
	Flags: Linked
*/
function function_1f1e411c()
{
	var_fed9d833 = ("vox_plr_" + self.characterindex) + "_sophia_first_interact_0_0";
	var_ba3dd1ed = "vox_soph_sophia_first_interact_1_0";
	var_1f76714 = array(var_fed9d833, var_ba3dd1ed);
	var_7995e0ad = function_fcea1c5c();
	if(isdefined(var_7995e0ad))
	{
		if(level.activeplayers.size > 1)
		{
			var_e46c32b9 = function_1cbd9399(var_7995e0ad.origin, 2);
			if(isdefined(var_e46c32b9))
			{
				var_ef7939f4 = ("vox_plr_" + var_e46c32b9) + "_sophia_first_interact_2_0";
				if(!isdefined(var_1f76714))
				{
					var_1f76714 = [];
				}
				else if(!isarray(var_1f76714))
				{
					var_1f76714 = array(var_1f76714);
				}
				var_1f76714[var_1f76714.size] = var_ef7939f4;
			}
		}
		var_326fc573 = "vox_plr_2_sophia_first_interact_3_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = var_326fc573;
	}
	else
	{
		var_e46c32b9 = function_1cbd9399(undefined, 2);
		if(isdefined(var_e46c32b9))
		{
			var_ef7939f4 = ("vox_plr_" + var_e46c32b9) + "_sophia_first_interact_2_0";
			if(!isdefined(var_1f76714))
			{
				var_1f76714 = [];
			}
			else if(!isarray(var_1f76714))
			{
				var_1f76714 = array(var_1f76714);
			}
			var_1f76714[var_1f76714.size] = var_ef7939f4;
		}
	}
	level.var_a090a655 function_280223ba(var_1f76714);
}

/*
	Name: function_19d97b43
	Namespace: zm_stalingrad_vo
	Checksum: 0xDB750994
	Offset: 0x6AA0
	Size: 0x24C
	Parameters: 0
	Flags: Linked
*/
function function_19d97b43()
{
	var_1f76714 = array("vox_nik1_sophia_first_interact_4_0");
	var_7995e0ad = function_fcea1c5c();
	if(isdefined(var_7995e0ad))
	{
		if(level.activeplayers.size > 1)
		{
			var_e46c32b9 = function_1cbd9399(var_7995e0ad.origin, 2);
			if(isdefined(var_e46c32b9))
			{
				var_ef7939f4 = ("vox_plr_" + var_e46c32b9) + "_sophia_first_interact_5_0";
				if(!isdefined(var_1f76714))
				{
					var_1f76714 = [];
				}
				else if(!isarray(var_1f76714))
				{
					var_1f76714 = array(var_1f76714);
				}
				var_1f76714[var_1f76714.size] = var_ef7939f4;
			}
		}
		var_326fc573 = "vox_plr_2_sophia_first_interact_6_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = var_326fc573;
	}
	else
	{
		var_e46c32b9 = function_1cbd9399(undefined, 2);
		if(isdefined(var_e46c32b9))
		{
			var_ef7939f4 = ("vox_plr_" + var_e46c32b9) + "_sophia_first_interact_5_0";
			if(!isdefined(var_1f76714))
			{
				var_1f76714 = [];
			}
			else if(!isarray(var_1f76714))
			{
				var_1f76714 = array(var_1f76714);
			}
			var_1f76714[var_1f76714.size] = var_ef7939f4;
		}
	}
	level function_280223ba(var_1f76714);
}

/*
	Name: function_85b7d5f1
	Namespace: zm_stalingrad_vo
	Checksum: 0x7E59F1CF
	Offset: 0x6CF8
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function function_85b7d5f1()
{
	var_1f76714 = array("vox_soph_amsel_correct_0");
	var_765a3ab1 = level function_1cbd9399(level.var_a090a655.origin);
	if(isdefined(var_765a3ab1))
	{
		str_response = ("vox_plr_" + var_765a3ab1) + "_amsel_resp_0_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = str_response;
	}
	if(!isdefined(var_1f76714))
	{
		var_1f76714 = [];
	}
	else if(!isarray(var_1f76714))
	{
		var_1f76714 = array(var_1f76714);
	}
	var_1f76714[var_1f76714.size] = "vox_soph_amsel_resp_1_0";
	level function_280223ba(var_1f76714, undefined, 1, 0, 1);
}

/*
	Name: function_38bc572f
	Namespace: zm_stalingrad_vo
	Checksum: 0x452DA7F
	Offset: 0x6E68
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_38bc572f()
{
	var_1f76714 = array("vox_soph_phase1_resp_0_0");
	var_765a3ab1 = level function_1cbd9399(level.var_a090a655.origin);
	if(isdefined(var_765a3ab1))
	{
		str_response = ("vox_plr_" + var_765a3ab1) + "_phase1_resp_1_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = str_response;
	}
	level function_280223ba(var_1f76714, undefined, 1, 0, 1);
}

/*
	Name: function_931a3024
	Namespace: zm_stalingrad_vo
	Checksum: 0xB6EDE2F4
	Offset: 0x6F78
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_931a3024()
{
	var_1f76714 = array("vox_soph_phase1_resp_2_0");
	var_765a3ab1 = level function_1cbd9399();
	if(isdefined(var_765a3ab1))
	{
		str_response = ("vox_plr_" + var_765a3ab1) + "_phase1_resp_3_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = str_response;
	}
	level function_280223ba(var_1f76714, undefined, 1, 0, 1);
}

/*
	Name: function_3a7b7b7b
	Namespace: zm_stalingrad_vo
	Checksum: 0x2B890439
	Offset: 0x7078
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_3a7b7b7b()
{
	var_1f76714 = array("vox_soph_phase2_intro_0");
	var_765a3ab1 = level function_1cbd9399(level.var_a090a655.origin);
	if(isdefined(var_765a3ab1))
	{
		str_response = ("vox_plr_" + var_765a3ab1) + "_phase2_intro_resp_1_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = str_response;
	}
	level function_280223ba(var_1f76714, undefined, 1, 0, 1);
}

/*
	Name: function_460341f9
	Namespace: zm_stalingrad_vo
	Checksum: 0x24982451
	Offset: 0x7188
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function function_460341f9()
{
	var_1f76714 = array("vox_gers_anomaly_shoot_third_0");
	var_765a3ab1 = level function_1cbd9399(level.var_a5fb1d00.origin);
	if(isdefined(var_765a3ab1))
	{
		str_response = ("vox_plr_" + var_765a3ab1) + "_anomaly_shoot_third_resp_0_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = str_response;
		if(level.players.size == 1 && (isdefined(level.has_richtofen) && level.has_richtofen))
		{
			if(!isdefined(var_1f76714))
			{
				var_1f76714 = [];
			}
			else if(!isarray(var_1f76714))
			{
				var_1f76714 = array(var_1f76714);
			}
			var_1f76714[var_1f76714.size] = "vox_gers_anomaly_shoot_third_resp_1_1";
		}
		else
		{
			if(!isdefined(var_1f76714))
			{
				var_1f76714 = [];
			}
			else if(!isarray(var_1f76714))
			{
				var_1f76714 = array(var_1f76714);
			}
			var_1f76714[var_1f76714.size] = "vox_gers_anomaly_shoot_third_resp_1_0";
		}
	}
	level function_280223ba(var_1f76714, undefined, 1, 0, 1);
}

/*
	Name: function_7c3ff8b2
	Namespace: zm_stalingrad_vo
	Checksum: 0xB9170C9A
	Offset: 0x7388
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_7c3ff8b2()
{
	var_1f76714 = array("vox_soph_anomaly_returned_0", "vox_gers_anomaly_returned_resp_0_0", "vox_soph_anomaly_returned_resp_1_0", "vox_gers_anomaly_trapped_0");
	var_765a3ab1 = level function_1cbd9399(level.var_a090a655.origin);
	if(isdefined(var_765a3ab1))
	{
		str_response = ("vox_plr_" + var_765a3ab1) + "_anomaly_trapped_resp_0_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = str_response;
	}
	level function_280223ba(var_1f76714, undefined, 1, 0, 1);
}

/*
	Name: function_ececbc4b
	Namespace: zm_stalingrad_vo
	Checksum: 0xC6C39796
	Offset: 0x74B0
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_ececbc4b()
{
	var_1f76714 = array("vox_soph_ascension_complete_0");
	var_765a3ab1 = level function_1cbd9399(level.var_a090a655.origin);
	if(isdefined(var_765a3ab1))
	{
		str_response = ("vox_plr_" + var_765a3ab1) + "_ascension_complete_resp_0_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = str_response;
	}
	level function_280223ba(var_1f76714, undefined, 1, 0, 1);
}

/*
	Name: function_732b874f
	Namespace: zm_stalingrad_vo
	Checksum: 0x9B0552F0
	Offset: 0x75C0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_732b874f()
{
	level function_e4acaa37("vox_nik1_help_nikolai_cores_0");
	wait(0.5);
	level function_e4acaa37("vox_nik1_help_nikolai_complete_0");
}

/*
	Name: function_ea234d37
	Namespace: zm_stalingrad_vo
	Checksum: 0x1F671BD1
	Offset: 0x7618
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function function_ea234d37()
{
	wait(1);
	var_1f76714 = array("vox_soph_sophia_depart_0", "vox_soph_sophia_depart_1", "vox_soph_sophia_depart_2", "vox_soph_sophia_depart_3");
	level.var_a090a655 function_280223ba(var_1f76714, undefined, 1, 0, 1);
	level notify(#"hash_34e4b03f");
	wait(1.5);
	var_7995e0ad = function_fcea1c5c();
	if(isdefined(var_7995e0ad))
	{
		var_1f76714 = [];
		if(level.activeplayers.size > 1)
		{
			var_e46c32b9 = function_1cbd9399(var_7995e0ad.origin, 2);
			if(isdefined(var_e46c32b9))
			{
				var_ef7939f4 = ("vox_plr_" + var_e46c32b9) + "_sophia_depart_resp_0_0";
				if(!isdefined(var_1f76714))
				{
					var_1f76714 = [];
				}
				else if(!isarray(var_1f76714))
				{
					var_1f76714 = array(var_1f76714);
				}
				var_1f76714[var_1f76714.size] = var_ef7939f4;
			}
		}
		var_326fc573 = "vox_plr_2_sophia_depart_resp_1_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = var_326fc573;
		level function_280223ba(var_1f76714);
	}
	else
	{
		var_e46c32b9 = function_1cbd9399(undefined, 2);
		if(isdefined(var_e46c32b9))
		{
			var_ef7939f4 = ("vox_plr_" + var_e46c32b9) + "_sophia_depart_resp_0_0";
			level function_e4acaa37(var_ef7939f4);
		}
	}
}

/*
	Name: function_e8e9cba8
	Namespace: zm_stalingrad_vo
	Checksum: 0xD4EF153C
	Offset: 0x7898
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_e8e9cba8()
{
	var_1f76714 = array("vox_nik1_ee_end_0", "vox_nik1_ee_end_1");
	var_765a3ab1 = level function_1cbd9399();
	if(isdefined(var_765a3ab1))
	{
		str_response = ("vox_plr_" + var_765a3ab1) + "_ee_end_resp_0_0";
		if(!isdefined(var_1f76714))
		{
			var_1f76714 = [];
		}
		else if(!isarray(var_1f76714))
		{
			var_1f76714 = array(var_1f76714);
		}
		var_1f76714[var_1f76714.size] = str_response;
	}
	if(!isdefined(var_1f76714))
	{
		var_1f76714 = [];
	}
	else if(!isarray(var_1f76714))
	{
		var_1f76714 = array(var_1f76714);
	}
	var_1f76714[var_1f76714.size] = "vox_nik1_ee_end_resp_1_0";
	level function_280223ba(var_1f76714);
}

/*
	Name: function_dd5e5b43
	Namespace: zm_stalingrad_vo
	Checksum: 0x4E36713
	Offset: 0x79F0
	Size: 0x364
	Parameters: 2
	Flags: Linked
*/
function function_dd5e5b43(var_47f85056, var_fd6599b7 = 0)
{
	if(!isdefined(level.var_40917b16))
	{
		level.var_40917b16 = [];
		level.var_40917b16[0] = array::randomize(array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9));
		level.var_40917b16[1] = array::randomize(array(0, 1, 2, 3, 4));
		level.var_40917b16[2] = array::randomize(array(0, 1, 2, 3, 4));
	}
	if(!isdefined(level.var_49799ac6))
	{
		level.var_49799ac6 = 0;
	}
	if(var_fd6599b7 && level.var_49799ac6 < 3)
	{
		level function_e4acaa37("vox_soph_security_system_fail_" + level.var_49799ac6, 0, 1, 0, 1);
		level.var_49799ac6++;
	}
	else
	{
		if(var_47f85056 > 10)
		{
			return;
		}
		if(var_47f85056 == 10)
		{
			level function_e4acaa37("vox_soph_fail_final_0", 1, 1, 0, 1);
		}
		else
		{
			if(var_47f85056 > 6)
			{
				n_vo = array::pop_front(level.var_40917b16[2], 0);
				level function_e4acaa37("vox_soph_fail_level_3_" + n_vo, 1, 1, 0, 1);
			}
			else
			{
				if(var_47f85056 > 3)
				{
					n_vo = array::pop_front(level.var_40917b16[1], 0);
					level function_e4acaa37("vox_soph_fail_level_2_" + n_vo, 1, 1, 0, 1);
				}
				else
				{
					n_vo = array::pop_front(level.var_40917b16[0], 0);
					level function_e4acaa37("vox_soph_fail_level_1_" + n_vo, 1, 1, 0, 1);
				}
			}
		}
	}
	if(var_47f85056 < 6)
	{
		level thread function_233dcc5d();
	}
}

/*
	Name: function_b120c9e8
	Namespace: zm_stalingrad_vo
	Checksum: 0x4F3E6CE3
	Offset: 0x7D60
	Size: 0x94
	Parameters: 4
	Flags: Linked
*/
function function_b120c9e8(str_vo_alias, n_wait, b_wait_if_busy, n_priority)
{
	if(self == level)
	{
		b_result = function_5eded46b(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
	else
	{
		b_result = self function_7b697614(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
	return b_result;
}

/*
	Name: function_8c6e04dc
	Namespace: zm_stalingrad_vo
	Checksum: 0xE2F334FF
	Offset: 0x7E00
	Size: 0x1A4
	Parameters: 3
	Flags: Linked
*/
function function_8c6e04dc(var_30874640, var_4c5a66ad, b_wait_if_busy = 1)
{
	var_cbd11028 = [];
	for(i = 0; i < var_4c5a66ad; i++)
	{
		if(!isdefined(var_cbd11028))
		{
			var_cbd11028 = [];
		}
		else if(!isarray(var_cbd11028))
		{
			var_cbd11028 = array(var_cbd11028);
		}
		var_cbd11028[var_cbd11028.size] = (("vox_abcd_" + var_30874640) + "_") + i;
	}
	var_12fe9129 = [];
	var_12fe9129[0] = 2;
	if(var_4c5a66ad > 1)
	{
		for(i = 1; i < var_4c5a66ad; i++)
		{
			if(!isdefined(var_12fe9129))
			{
				var_12fe9129 = [];
			}
			else if(!isarray(var_12fe9129))
			{
				var_12fe9129 = array(var_12fe9129);
			}
			var_12fe9129[var_12fe9129.size] = 0;
		}
	}
	self function_280223ba(var_cbd11028, var_12fe9129, b_wait_if_busy);
}

/*
	Name: function_fffcd12a
	Namespace: zm_stalingrad_vo
	Checksum: 0x843A603B
	Offset: 0x7FB0
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function function_fffcd12a(var_30874640)
{
	level function_e4acaa37(var_30874640);
}

/*
	Name: function_1033e5c6
	Namespace: zm_stalingrad_vo
	Checksum: 0xC1C3C385
	Offset: 0x7FE0
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function function_1033e5c6(var_30874640, var_4c5a66ad)
{
	self.mdl_fx = util::spawn_model("tag_origin", self.origin, self.angles);
	self.mdl_fx.targetname = self.targetname + "_fx";
	self.mdl_fx clientfield::set("ethereal_audio_log_fx", 1);
	self.takedamage = 1;
	self waittill(#"damage");
	self.mdl_fx clientfield::set("ethereal_audio_log_fx", 0);
	level function_8c6e04dc(var_30874640, var_4c5a66ad);
	self.mdl_fx delete();
	self delete();
}

/*
	Name: function_ffc15961
	Namespace: zm_stalingrad_vo
	Checksum: 0xCF7802E
	Offset: 0x8100
	Size: 0x154
	Parameters: 2
	Flags: None
*/
function function_ffc15961(var_30874640, var_4c5a66ad)
{
	self zm_unitrigger::create_unitrigger("");
	self.mdl_fx = util::spawn_model("tag_origin", self.origin, self.angles);
	self.mdl_fx.targetname = self.targetname + "_fx";
	self.mdl_fx clientfield::set("ethereal_audio_log_fx", 1);
	self waittill(#"trigger_activated", e_who);
	e_who clientfield::increment_to_player("interact_rumble");
	self.mdl_fx clientfield::set("ethereal_audio_log_fx", 0);
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	level function_8c6e04dc(var_30874640, var_4c5a66ad);
	self.mdl_fx delete();
}

/*
	Name: function_e84d923f
	Namespace: zm_stalingrad_vo
	Checksum: 0x1666FE98
	Offset: 0x8260
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function function_e84d923f()
{
	level function_13ea746c();
	level function_d5f6780();
	level function_74602567();
	level function_258b62c();
	level function_285b3095();
	/#
		iprintlnbold("");
	#/
	array::thread_all(level.players, &function_e12b1498);
	callback::on_connect(&function_4534864d);
	level function_ea43145d();
	level function_7e60bca8();
	level function_55eb82ac();
	level function_c7f2f1e7();
	level function_a1f0777e();
	level function_890ad0cd();
	level function_af0d4b36();
}

/*
	Name: function_13ea746c
	Namespace: zm_stalingrad_vo
	Checksum: 0xC0CA21A3
	Offset: 0x83F8
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function function_13ea746c()
{
	/#
		level endon(#"hash_2b2c1420");
	#/
	level endon(#"_zombie_game_over");
	while(true)
	{
		level waittill(#"end_of_round");
		if(level.round_number >= 14)
		{
			if(isdefined(level.var_49d419a3) && level.var_49d419a3)
			{
				wait(10);
			}
			if(!(isdefined(level.var_49d419a3) && level.var_49d419a3))
			{
				level function_8c6e04dc("first_contact", 2);
				return;
			}
		}
	}
}

/*
	Name: function_d5f6780
	Namespace: zm_stalingrad_vo
	Checksum: 0xA037ED7A
	Offset: 0x84A8
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_d5f6780()
{
	/#
		level endon(#"hash_2b2c1420");
		iprintlnbold("");
	#/
	level endon(#"_zombie_game_over");
	while(true)
	{
		level waittill(#"end_of_round");
		if(isdefined(level.var_49d419a3) && level.var_49d419a3)
		{
			wait(10);
		}
		if(!(isdefined(level.var_49d419a3) && level.var_49d419a3))
		{
			level function_8c6e04dc("second_contact", 2);
			return;
		}
	}
}

/*
	Name: function_74602567
	Namespace: zm_stalingrad_vo
	Checksum: 0x63BE4FB4
	Offset: 0x8560
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_74602567()
{
	/#
		level endon(#"hash_2b2c1420");
		iprintlnbold("");
	#/
	var_561743c9 = getent("log_bw_1", "targetname");
	var_561743c9 function_1033e5c6("broken_world_1", 6);
}

/*
	Name: function_258b62c
	Namespace: zm_stalingrad_vo
	Checksum: 0x50D85675
	Offset: 0x85F0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_258b62c()
{
	/#
		level endon(#"hash_2b2c1420");
		iprintlnbold("");
	#/
	var_561743c9 = getent("log_bw_2", "targetname");
	var_561743c9 function_1033e5c6("broken_world_2", 1);
}

/*
	Name: function_285b3095
	Namespace: zm_stalingrad_vo
	Checksum: 0x3620F3CF
	Offset: 0x8680
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_285b3095()
{
	/#
		level endon(#"hash_2b2c1420");
		iprintlnbold("");
	#/
	var_561743c9 = getent("log_bw_3", "targetname");
	var_561743c9 function_1033e5c6("broken_world_3", 4);
}

/*
	Name: function_ea43145d
	Namespace: zm_stalingrad_vo
	Checksum: 0x4800BD33
	Offset: 0x8710
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_ea43145d()
{
	/#
		level endon(#"hash_2b2c1420");
	#/
	var_561743c9 = getent("log_m", "targetname");
	var_561743c9 function_1033e5c6("maxis_maxis", 3);
}

/*
	Name: function_7e60bca8
	Namespace: zm_stalingrad_vo
	Checksum: 0x5143AFD7
	Offset: 0x8788
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_7e60bca8()
{
	/#
		level endon(#"hash_2b2c1420");
		iprintlnbold("");
	#/
	var_561743c9 = getent("log_s", "targetname");
	var_561743c9 function_1033e5c6("samantha_samantha", 4);
}

/*
	Name: function_55eb82ac
	Namespace: zm_stalingrad_vo
	Checksum: 0x5B906C75
	Offset: 0x8818
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_55eb82ac()
{
	/#
		level endon(#"hash_2b2c1420");
		iprintlnbold("");
	#/
	var_561743c9 = getent("log_u_1", "targetname");
	var_561743c9 function_1033e5c6("multiple_versions_1", 3);
}

/*
	Name: function_c7f2f1e7
	Namespace: zm_stalingrad_vo
	Checksum: 0x8600C513
	Offset: 0x88A8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_c7f2f1e7()
{
	/#
		level endon(#"hash_2b2c1420");
		iprintlnbold("");
	#/
	var_561743c9 = getent("log_u_2", "targetname");
	var_561743c9 function_1033e5c6("multiple_versions_2", 8);
}

/*
	Name: function_a1f0777e
	Namespace: zm_stalingrad_vo
	Checksum: 0xA6DF1998
	Offset: 0x8938
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_a1f0777e()
{
	/#
		level endon(#"hash_2b2c1420");
		iprintlnbold("");
	#/
	var_561743c9 = getent("log_u_3", "targetname");
	var_561743c9 function_1033e5c6("multiple_versions_3", 3);
}

/*
	Name: function_890ad0cd
	Namespace: zm_stalingrad_vo
	Checksum: 0xBEE26CB4
	Offset: 0x89C8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_890ad0cd()
{
	/#
		level endon(#"hash_2b2c1420");
		iprintlnbold("");
	#/
	var_561743c9 = getent("log_be_1", "targetname");
	var_561743c9 function_1033e5c6("before_ee_complete_1", 2);
}

/*
	Name: function_af0d4b36
	Namespace: zm_stalingrad_vo
	Checksum: 0x10ADC610
	Offset: 0x8A58
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_af0d4b36()
{
	/#
		level endon(#"hash_2b2c1420");
		iprintlnbold("");
	#/
	var_561743c9 = getent("log_be_2", "targetname");
	var_561743c9 function_1033e5c6("before_ee_complete_2", 2);
}

/*
	Name: function_e12b1498
	Namespace: zm_stalingrad_vo
	Checksum: 0xF706A67E
	Offset: 0x8AE8
	Size: 0x32E
	Parameters: 0
	Flags: Linked
*/
function function_e12b1498()
{
	level endon(#"_zombie_game_over");
	self endon(#"disconnect");
	var_c041bd97 = [];
	switch(self.characterindex)
	{
		case 0:
		{
			str_player = "dempsey";
			var_c041bd97[1] = 2;
			var_c041bd97[2] = 2;
			var_c041bd97[3] = 1;
			break;
		}
		case 1:
		{
			str_player = "nikolai";
			var_c041bd97[1] = 2;
			var_c041bd97[2] = 3;
			var_c041bd97[3] = 1;
			break;
		}
		case 2:
		{
			str_player = "richtofen";
			var_c041bd97[1] = 2;
			var_c041bd97[2] = 1;
			var_c041bd97[3] = 1;
			break;
		}
		case 3:
		{
			str_player = "takeo";
			var_c041bd97[1] = 2;
			var_c041bd97[2] = 2;
			var_c041bd97[3] = 2;
			break;
		}
	}
	var_816a0127 = 1;
	while(var_816a0127 <= 3)
	{
		self waittill(#"player_downed");
		if(self hasperk("specialty_quickrevive") && level.players.size > 1)
		{
			continue;
		}
		else
		{
			while(isdefined(self.isspeaking) && self.isspeaking || (isdefined(level.sndvoxoverride) && level.sndvoxoverride))
			{
				wait(0.1);
			}
			self.isspeaking = 1;
			level.sndvoxoverride = 1;
			self thread function_b3baa665();
			for(i = 0; i < var_c041bd97[var_816a0127]; i++)
			{
				str_vo = (((("vox_abcd_talk_" + str_player) + "_") + var_816a0127) + "_") + i;
				self playsoundtoplayer(str_vo, self);
				var_5cd02106 = soundgetplaybacktime(str_vo);
				var_269117b2 = var_5cd02106 / 1000;
				wait(var_269117b2 + 0.5);
			}
			self vo_clear();
			var_816a0127++;
		}
	}
}

/*
	Name: function_4534864d
	Namespace: zm_stalingrad_vo
	Checksum: 0x5F9D641C
	Offset: 0x8E20
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_4534864d()
{
	self thread function_e12b1498();
}

/*
	Name: function_568549ce
	Namespace: zm_stalingrad_vo
	Checksum: 0x5C09752C
	Offset: 0x8E48
	Size: 0x1E6
	Parameters: 0
	Flags: Linked
*/
function function_568549ce()
{
	var_25af0243 = [];
	foreach(e_player in level.activeplayers)
	{
		if(isalive(e_player) && e_player.characterindex != 2)
		{
			if(!isdefined(var_25af0243))
			{
				var_25af0243 = [];
			}
			else if(!isarray(var_25af0243))
			{
				var_25af0243 = array(var_25af0243);
			}
			var_25af0243[var_25af0243.size] = e_player;
			if(isdefined(level.splitscreen) && level.splitscreen)
			{
				break;
			}
		}
	}
	if(var_25af0243.size)
	{
		level function_8ac5430(1);
		for(i = 1; i < var_25af0243.size; i++)
		{
			var_25af0243[i] thread function_8eafdf30(7);
		}
		var_25af0243[0] function_8eafdf30(7);
		level function_8ac5430(0);
	}
	else
	{
		wait(15);
	}
}

/*
	Name: function_8eafdf30
	Namespace: zm_stalingrad_vo
	Checksum: 0xC4E1FEC0
	Offset: 0x9038
	Size: 0x16A
	Parameters: 1
	Flags: Linked
*/
function function_8eafdf30(var_4c5a66ad)
{
	self endon(#"death");
	var_cbd11028 = [];
	for(i = 0; i < var_4c5a66ad; i++)
	{
		if(!isdefined(var_cbd11028))
		{
			var_cbd11028 = [];
		}
		else if(!isarray(var_cbd11028))
		{
			var_cbd11028 = array(var_cbd11028);
		}
		var_cbd11028[var_cbd11028.size] = "vox_abcd_introduction_x_" + i;
	}
	foreach(str_vo in var_cbd11028)
	{
		self playsoundtoplayer(str_vo, self);
		n_duration = soundgetplaybacktime(str_vo);
		wait(n_duration / 1000);
	}
}

/*
	Name: function_df1536ac
	Namespace: zm_stalingrad_vo
	Checksum: 0x6F2D496D
	Offset: 0x91B0
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function function_df1536ac()
{
	self endon(#"death");
	level endon(#"hash_df1536ac");
	e_speaker = undefined;
	while(!isdefined(e_speaker))
	{
		foreach(e_player in level.activeplayers)
		{
			if(zm_utility::is_player_valid(e_player) && e_player function_2d942575(self, 500))
			{
				if(isdefined(level.var_99d1f06b) && (gettime() - level.var_99d1f06b) < 400000 || (isdefined(e_player.var_8afab9d9) && e_player.var_8afab9d9.size <= 0))
				{
					continue;
				}
				wait(1.5);
				if(zm_utility::is_player_valid(e_player) && e_player function_2d942575(self, 500))
				{
					e_speaker = e_player;
					break;
				}
			}
		}
		wait(0.25);
	}
	e_speaker thread function_2854be75();
}

/*
	Name: function_2854be75
	Namespace: zm_stalingrad_vo
	Checksum: 0x2A953749
	Offset: 0x9360
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_2854be75()
{
	if(!isdefined(self.var_8afab9d9))
	{
		self.var_8afab9d9 = [];
		for(i = 0; i < 5; i++)
		{
			self.var_8afab9d9[i] = (("vox_plr_" + self.characterindex) + "_mangler_appears_") + i;
		}
	}
	str_vo_line = array::random(self.var_8afab9d9);
	b_success = self function_7b697614(str_vo_line);
	if(isdefined(b_success) && b_success)
	{
		level notify(#"hash_df1536ac");
		level.var_99d1f06b = gettime();
		arrayremovevalue(self.var_8afab9d9, str_vo_line);
	}
}

/*
	Name: function_999cab02
	Namespace: zm_stalingrad_vo
	Checksum: 0xD144A2B9
	Offset: 0x9470
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_999cab02()
{
	self endon(#"death");
	self waittill(#"raz_arm_detach", e_speaker);
	if(!zm_utility::is_player_valid(e_speaker))
	{
		return;
	}
	if(!isdefined(level.var_e7ee5240) || !isdefined(level.var_e7ee5240[e_speaker.characterindex]) || (gettime() - level.var_e7ee5240[e_speaker.characterindex]) > 400000)
	{
		if(isdefined(e_speaker.var_6f8da805) && e_speaker.var_6f8da805.size <= 0)
		{
			return;
		}
		e_speaker thread function_bd5c5b53();
	}
}

/*
	Name: function_bd5c5b53
	Namespace: zm_stalingrad_vo
	Checksum: 0x3654A501
	Offset: 0x9558
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_bd5c5b53()
{
	if(!isdefined(self.var_6f8da805))
	{
		self.var_6f8da805 = [];
		for(i = 0; i < 3; i++)
		{
			self.var_6f8da805[i] = (("vox_plr_" + self.characterindex) + "_regulator_destroyed_") + i;
		}
	}
	str_vo_line = array::random(self.var_6f8da805);
	b_success = self function_7b697614(str_vo_line, 1);
	if(isdefined(b_success) && b_success)
	{
		level.var_e7ee5240[self.characterindex] = gettime();
		arrayremovevalue(self.var_6f8da805, str_vo_line);
	}
}

/*
	Name: function_90f2084c
	Namespace: zm_stalingrad_vo
	Checksum: 0x3853587F
	Offset: 0x9670
	Size: 0x26C
	Parameters: 0
	Flags: Linked
*/
function function_90f2084c()
{
	if(!isdefined(self.var_123d0a2b))
	{
		self.var_123d0a2b = [];
		for(i = 0; i < 9; i++)
		{
			self.var_123d0a2b[i] = [];
			self.var_123d0a2b[i][0] = ("vox_nik1_nikolai_battle_" + (i + 1)) + "_0";
			for(j = 1; j < 5; j++)
			{
				self.var_123d0a2b[i][j] = (("vox_plr_" + (j - 1)) + "_nikolai_battle_") + (i + 1) + "_0";
			}
		}
		level.var_70baaca6 = 0;
	}
	if(level.var_70baaca6 >= 9)
	{
		return;
	}
	var_1f76714 = [];
	if(level.var_70baaca6 == 4)
	{
		level.var_70baaca6++;
	}
	if(!isdefined(var_1f76714))
	{
		var_1f76714 = [];
	}
	else if(!isarray(var_1f76714))
	{
		var_1f76714 = array(var_1f76714);
	}
	var_1f76714[var_1f76714.size] = self.var_123d0a2b[level.var_70baaca6][0];
	n_player = function_1cbd9399(self.origin);
	if(!isdefined(var_1f76714))
	{
		var_1f76714 = [];
	}
	else if(!isarray(var_1f76714))
	{
		var_1f76714 = array(var_1f76714);
	}
	var_1f76714[var_1f76714.size] = self.var_123d0a2b[level.var_70baaca6][n_player + 1];
	level.var_70baaca6++;
	self.var_fa4643fb function_7aa5324a(var_1f76714);
}

/*
	Name: function_6d6eb04e
	Namespace: zm_stalingrad_vo
	Checksum: 0x89E83A34
	Offset: 0x98E8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_6d6eb04e()
{
	self thread function_897246e4("vox_nik1_nikolai_anthem_0");
}

/*
	Name: function_cd0b1f13
	Namespace: zm_stalingrad_vo
	Checksum: 0x364929BE
	Offset: 0x9918
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function function_cd0b1f13()
{
	level endon(#"_zombie_game_over");
	self endon(#"death");
	level endon(#"hash_6460283a");
	for(i = 0; i < 4; i++)
	{
		self.var_b5cc11cd[i] = "vox_nik1_nikolai_weak_first_" + i;
	}
	for(i = 0; i < 6; i++)
	{
		self.var_dbce8c36[i] = "vox_nik1_nikolai_weak_second_" + i;
	}
	arrayremovevalue(self.var_dbce8c36, "vox_nik1_nikolai_weak_second_3");
	for(i = 0; i < 2; i++)
	{
		self.var_11487539[i] = "vox_nik1_nikolai_weak_third_" + i;
	}
	for(i = 0; i < 2; i++)
	{
		self waittill(#"nikolai_weakpoint_destroyed");
		str_vo_line = array::random(self.var_b5cc11cd);
		self.var_fa4643fb thread function_897246e4(str_vo_line, 1);
		arrayremovevalue(self.var_b5cc11cd, str_vo_line);
	}
	for(i = 0; i < 2; i++)
	{
		self waittill(#"nikolai_weakpoint_destroyed");
		str_vo_line = array::random(self.var_dbce8c36);
		self.var_fa4643fb thread function_897246e4(str_vo_line, 1);
		arrayremovevalue(self.var_dbce8c36, str_vo_line);
	}
	level flag::wait_till("nikolai_complete");
	str_vo_line = array::random(self.var_11487539);
	self.var_fa4643fb thread function_e4acaa37(str_vo_line, 0, 0);
}

/*
	Name: function_176ac3fa
	Namespace: zm_stalingrad_vo
	Checksum: 0xCF8DB343
	Offset: 0x9BA8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_176ac3fa()
{
	if(!isdefined(self.var_7924724e))
	{
		self.var_7924724e = [];
		for(i = 0; i < 5; i++)
		{
			self.var_7924724e[i] = (("vox_plr_" + self.characterindex) + "_trap_eye_activate_") + i;
		}
	}
	if(self.var_7924724e.size <= 0)
	{
		return;
	}
	var_4c9402b3 = array::random(self.var_7924724e);
	var_871a3334 = self function_897246e4(var_4c9402b3);
	if(isdefined(var_871a3334) && var_871a3334)
	{
		arrayremovevalue(self.var_7924724e, var_4c9402b3, 0);
	}
}

/*
	Name: function_c0914f1b
	Namespace: zm_stalingrad_vo
	Checksum: 0x315376A2
	Offset: 0x9CB8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_c0914f1b()
{
	if(!isdefined(self.var_e074d477))
	{
		self.var_e074d477 = [];
		for(i = 0; i < 5; i++)
		{
			self.var_e074d477[i] = (("vox_plr_" + self.characterindex) + "_trap_claw_activate_") + i;
		}
	}
	if(self.var_e074d477.size <= 0)
	{
		return;
	}
	var_4c9402b3 = array::random(self.var_e074d477);
	var_871a3334 = self function_897246e4(var_4c9402b3);
	if(isdefined(var_871a3334) && var_871a3334)
	{
		arrayremovevalue(self.var_e074d477, var_4c9402b3, 0);
	}
}

/*
	Name: function_96153834
	Namespace: zm_stalingrad_vo
	Checksum: 0x60243488
	Offset: 0x9DC8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_96153834()
{
	if(!isdefined(self.var_68076bf0))
	{
		self.var_68076bf0 = [];
		for(i = 0; i < 5; i++)
		{
			self.var_68076bf0[i] = (("vox_plr_" + self.characterindex) + "_trap_flinger_activate_") + i;
		}
	}
	if(self.var_68076bf0.size <= 0)
	{
		return;
	}
	var_4c9402b3 = array::random(self.var_68076bf0);
	var_871a3334 = self function_897246e4(var_4c9402b3);
	if(isdefined(var_871a3334) && var_871a3334)
	{
		arrayremovevalue(self.var_68076bf0, var_4c9402b3, 0);
	}
}

/*
	Name: function_643d8310
	Namespace: zm_stalingrad_vo
	Checksum: 0x403BFB8F
	Offset: 0x9ED8
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function function_643d8310(e_trap, n_stage)
{
	if(n_stage == 0)
	{
		return;
	}
	var_3778532a = e_trap.activated_by_player;
	if(!isdefined(var_3778532a.var_846662dc))
	{
		var_3778532a.var_846662dc = [];
		for(i = 0; i < 5; i++)
		{
			var_3778532a.var_846662dc[i] = (("vox_plr_" + var_3778532a.characterindex) + "_trap_electric_activate_") + i;
		}
	}
	if(var_3778532a.var_846662dc.size <= 0)
	{
		return;
	}
	var_4c9402b3 = array::random(var_3778532a.var_846662dc);
	var_871a3334 = self function_897246e4(var_4c9402b3);
	if(isdefined(var_871a3334) && var_871a3334)
	{
		arrayremovevalue(var_3778532a.var_846662dc, var_4c9402b3, 0);
	}
}

/*
	Name: function_32f35525
	Namespace: zm_stalingrad_vo
	Checksum: 0x811C5A22
	Offset: 0xA048
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_32f35525()
{
	if(!isdefined(self.var_8444411))
	{
		self.var_8444411 = [];
		for(i = 0; i < 5; i++)
		{
			self.var_8444411[i] = (("vox_plr_" + self.characterindex) + "_mg42_use_") + i;
		}
	}
	if(self.var_8444411.size <= 0)
	{
		return;
	}
	var_4c9402b3 = array::random(self.var_8444411);
	var_871a3334 = self function_897246e4(var_4c9402b3);
	if(isdefined(var_871a3334) && var_871a3334)
	{
		arrayremovevalue(self.var_8444411, var_4c9402b3, 0);
	}
}

/*
	Name: function_5adc22c7
	Namespace: zm_stalingrad_vo
	Checksum: 0x690F03D8
	Offset: 0xA158
	Size: 0x1D4
	Parameters: 1
	Flags: Linked
*/
function function_5adc22c7(v_source = undefined)
{
	if(!isdefined(level.var_b946513b))
	{
		level.var_b946513b = [];
		for(n_id = 0; n_id < 4; n_id++)
		{
			level.var_b946513b[n_id] = [];
			for(i = 0; i < 9; i++)
			{
				level.var_b946513b[n_id][i] = function_11b41a76(n_id, "pickup_generic", i);
			}
		}
	}
	if(isplayer(self) && zm_utility::is_player_valid(self))
	{
		e_speaker = self;
	}
	else
	{
		e_speaker = function_4bf4ac40(v_source);
	}
	if(!isdefined(e_speaker.var_c192cfcb))
	{
		e_speaker.var_c192cfcb = -1;
	}
	do
	{
		n_line = randomint(9);
	}
	while(e_speaker.var_c192cfcb == n_line);
	e_speaker.var_c192cfcb = n_line;
	e_speaker thread function_897246e4(level.var_b946513b[e_speaker.characterindex][n_line]);
}

/*
	Name: function_73928e79
	Namespace: zm_stalingrad_vo
	Checksum: 0xEB128574
	Offset: 0xA338
	Size: 0x1D4
	Parameters: 1
	Flags: Linked
*/
function function_73928e79(v_source = undefined)
{
	if(!isdefined(level.var_bb3e9bbd))
	{
		level.var_bb3e9bbd = [];
		for(n_id = 0; n_id < 4; n_id++)
		{
			level.var_bb3e9bbd[n_id] = [];
			for(i = 0; i < 9; i++)
			{
				level.var_bb3e9bbd[n_id][i] = function_11b41a76(n_id, "response_positive", i);
			}
		}
	}
	if(isplayer(self) && zm_utility::is_player_valid(self))
	{
		e_speaker = self;
	}
	else
	{
		e_speaker = function_4bf4ac40(v_source);
	}
	if(!isdefined(e_speaker.var_d2773c98))
	{
		e_speaker.var_d2773c98 = -1;
	}
	do
	{
		n_line = randomint(9);
	}
	while(e_speaker.var_d2773c98 == n_line);
	e_speaker.var_d2773c98 = n_line;
	e_speaker thread function_897246e4(level.var_bb3e9bbd[e_speaker.characterindex][n_line]);
}

/*
	Name: function_233dcc5d
	Namespace: zm_stalingrad_vo
	Checksum: 0x6B54283A
	Offset: 0xA518
	Size: 0x1D4
	Parameters: 1
	Flags: Linked
*/
function function_233dcc5d(v_source = undefined)
{
	if(!isdefined(level.var_7446abe1))
	{
		level.var_7446abe1 = [];
		for(n_id = 0; n_id < 4; n_id++)
		{
			level.var_7446abe1[n_id] = [];
			for(i = 0; i < 9; i++)
			{
				level.var_7446abe1[n_id][i] = function_11b41a76(n_id, "response_negative", i);
			}
		}
	}
	if(isplayer(self) && zm_utility::is_player_valid(self))
	{
		e_speaker = self;
	}
	else
	{
		e_speaker = function_4bf4ac40(v_source);
	}
	if(!isdefined(e_speaker.var_e2a5b718))
	{
		e_speaker.var_e2a5b718 = -1;
	}
	do
	{
		n_line = randomint(9);
	}
	while(e_speaker.var_e2a5b718 == n_line);
	e_speaker.var_e2a5b718 = n_line;
	e_speaker thread function_897246e4(level.var_7446abe1[e_speaker.characterindex][n_line]);
}

/*
	Name: function_1e767f71
	Namespace: zm_stalingrad_vo
	Checksum: 0x1778305A
	Offset: 0xA6F8
	Size: 0x238
	Parameters: 7
	Flags: None
*/
function function_1e767f71(e_target, n_min_dist = 600, var_79d0b667, var_b03cc213, var_a099ce87 = 1, var_ac3beede = 0, n_duration = 0)
{
	e_target endon(#"hash_9ed7f404");
	e_target endon(#"death");
	while(true)
	{
		var_45edf029 = arraysortclosest(level.players, e_target.origin);
		foreach(player in var_45edf029)
		{
			if(zm_utility::is_player_valid(player) && player util::is_player_looking_at(e_target getcentroid(), 0.5, 1, e_target) && distance2dsquared(player.origin, e_target.origin) <= (n_min_dist * n_min_dist))
			{
				player thread function_1881817(var_79d0b667, var_b03cc213, var_a099ce87, var_ac3beede);
				return;
			}
		}
		if(n_duration > 0)
		{
			n_duration--;
		}
		else
		{
			if(n_duration < 0)
			{
				wait(1);
				continue;
			}
			else
			{
				return;
			}
		}
		wait(1);
	}
}

/*
	Name: function_65f8953a
	Namespace: zm_stalingrad_vo
	Checksum: 0xD86D5FD5
	Offset: 0xA938
	Size: 0x13E
	Parameters: 8
	Flags: None
*/
function function_65f8953a(str_event, var_79d0b667, var_b03cc213, var_a099ce87 = 10, var_32802234 = 0, n_delay = 0, v_loc, var_c2a3d8e1 = 1)
{
	if(isdefined(str_event))
	{
		array::add(self.var_bac3b790, str_event);
		self.var_38d92be7[str_event] = var_79d0b667;
		self.var_8bcf7c3a[str_event] = var_b03cc213;
		self.var_2c67f767[str_event] = var_a099ce87;
		self.var_4b332a77[str_event] = var_32802234;
		self.var_bc80de72[str_event] = n_delay;
		self.var_9c6abc49[str_event] = v_loc;
		self.var_caa91bc0[str_event] = var_c2a3d8e1;
	}
}

/*
	Name: function_81d644a1
	Namespace: zm_stalingrad_vo
	Checksum: 0x47EEE74E
	Offset: 0xAA80
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function function_81d644a1()
{
	self endon(#"death");
	array::add(self.var_bac3b790, "death");
	array::add(self.var_bac3b790, "disconnect");
	while(true)
	{
		str_event = self util::waittill_any_array_return(self.var_bac3b790);
		if(self.var_bc80de72[str_event] > 0)
		{
			wait(self.var_bc80de72[str_event]);
		}
		if(zm_utility::is_player_valid(self) || (!(isdefined(self.var_caa91bc0[str_event]) && self.var_caa91bc0[str_event])))
		{
			self function_1881817(self.var_38d92be7[str_event], self.var_8bcf7c3a[str_event], self.var_2c67f767[str_event], self.var_4b332a77[str_event]);
		}
	}
}

/*
	Name: function_c261e8aa
	Namespace: zm_stalingrad_vo
	Checksum: 0xA958E4D6
	Offset: 0xABB0
	Size: 0xE8
	Parameters: 0
	Flags: None
*/
function function_c261e8aa()
{
	while(true)
	{
		str_event = level util::waittill_any_array_return(level.var_bac3b790);
		if(level.var_bc80de72[str_event] > 0)
		{
			wait(level.var_bc80de72[str_event]);
		}
		e_player = function_4bf4ac40(level.var_9c6abc49[str_event]);
		if(zm_utility::is_player_valid(e_player))
		{
			e_player function_1881817(level.var_38d92be7[str_event], level.var_8bcf7c3a[str_event], level.var_2c67f767[str_event], level.var_4b332a77[str_event]);
		}
	}
}

/*
	Name: function_1881817
	Namespace: zm_stalingrad_vo
	Checksum: 0x6C12FFDD
	Offset: 0xACA0
	Size: 0x198
	Parameters: 4
	Flags: Linked
*/
function function_1881817(var_79d0b667, var_b03cc213, var_a099ce87 = 10, var_32802234 = 0)
{
	self endon(#"death");
	var_4aa3754 = 0;
	if(zm_utility::is_player_valid(self) && (!(isdefined(self.var_e1f8edd6) && self.var_e1f8edd6)))
	{
		var_346d981 = (var_79d0b667 + var_b03cc213) + "_vo";
		if(!self flag::exists(var_346d981))
		{
			self flag::init(var_346d981);
		}
		if(!self flag::get(var_346d981))
		{
			self flag::set(var_346d981);
			if(var_32802234 == 0)
			{
				self thread zm_audio::create_and_play_dialog(var_79d0b667, var_b03cc213);
			}
			else
			{
				self thread function_7f4cb4c(var_79d0b667, var_b03cc213, var_32802234);
			}
			var_4aa3754 = 1;
			self thread function_ecc335b6(var_346d981, var_a099ce87);
		}
	}
	return var_4aa3754;
}

/*
	Name: function_ecc335b6
	Namespace: zm_stalingrad_vo
	Checksum: 0xA6ABB78A
	Offset: 0xAE40
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function function_ecc335b6(var_346d981, var_a099ce87)
{
	self endon(#"disconnect");
	wait(var_a099ce87);
	self flag::clear(var_346d981);
}

/*
	Name: function_7f4cb4c
	Namespace: zm_stalingrad_vo
	Checksum: 0x48C1BF80
	Offset: 0xAE88
	Size: 0xB2
	Parameters: 3
	Flags: Linked
*/
function function_7f4cb4c(var_79d0b667, var_b03cc213, var_41d7d192 = 3)
{
	str_index = (var_79d0b667 + "_") + var_b03cc213;
	if(!isdefined(self.var_10f58653[str_index]))
	{
		self.var_10f58653[str_index] = 0;
	}
	if(self.var_10f58653[str_index] < var_41d7d192)
	{
		self thread zm_audio::create_and_play_dialog(var_79d0b667, var_b03cc213);
		self.var_10f58653[str_index]++;
	}
}

/*
	Name: function_11b41a76
	Namespace: zm_stalingrad_vo
	Checksum: 0x5E8411A7
	Offset: 0xAF48
	Size: 0x212
	Parameters: 5
	Flags: Linked
*/
function function_11b41a76(n_player_index, str_type, var_f73f0bfc, var_69467b37 = 0, var_434400ce = 0)
{
	switch(str_type)
	{
		case "round_start_solo":
		{
			str_vo = ((("vox_plr_" + n_player_index) + "_round") + var_f73f0bfc) + "_start_solo_0";
			break;
		}
		case "round_end_solo":
		{
			str_vo = ((("vox_plr_" + n_player_index) + "_round") + var_f73f0bfc) + "_end_solo_0";
			break;
		}
		case "round_start_coop":
		{
			str_vo = ((("vox_plr_" + n_player_index) + "_round") + var_f73f0bfc) + "_start_0";
			break;
		}
		case "round_end_coop":
		{
			str_vo = ((("vox_plr_" + n_player_index) + "_round") + var_f73f0bfc) + "_end_0";
			break;
		}
		case "pickup_generic":
		{
			str_vo = (("vox_plr_" + n_player_index) + "_pickup_generic_") + var_f73f0bfc;
			break;
		}
		case "response_positive":
		{
			str_vo = (("vox_plr_" + n_player_index) + "_response_positive_") + var_f73f0bfc;
			break;
		}
		case "response_negative":
		{
			str_vo = (("vox_plr_" + n_player_index) + "_response_negative_") + var_f73f0bfc;
			break;
		}
		default:
		{
			str_vo = ((((("vox_plr_" + n_player_index) + "_") + str_type) + var_f73f0bfc) + "_") + var_69467b37;
			break;
		}
	}
	return str_vo;
}

/*
	Name: function_5803cf05
	Namespace: zm_stalingrad_vo
	Checksum: 0xD66F1E6D
	Offset: 0xB168
	Size: 0x82
	Parameters: 2
	Flags: None
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
	Name: function_53a5b746
	Namespace: zm_stalingrad_vo
	Checksum: 0x345343EF
	Offset: 0xB1F8
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function function_53a5b746(n_char_index)
{
	return zm_utility::get_specific_character(n_char_index);
}

/*
	Name: function_1cbd9399
	Namespace: zm_stalingrad_vo
	Checksum: 0x95AEEED
	Offset: 0xB228
	Size: 0x7A
	Parameters: 2
	Flags: Linked
*/
function function_1cbd9399(v_location = undefined, var_7b2f88c6 = undefined)
{
	e_player = function_4bf4ac40(v_location, var_7b2f88c6);
	if(!isdefined(e_player))
	{
		return undefined;
	}
	return e_player.characterindex;
}

/*
	Name: function_4bf4ac40
	Namespace: zm_stalingrad_vo
	Checksum: 0xD72CD7CF
	Offset: 0xB2B0
	Size: 0x1D2
	Parameters: 2
	Flags: Linked
*/
function function_4bf4ac40(v_location = undefined, var_7b2f88c6 = undefined)
{
	a_e_players = array::randomize(level.activeplayers);
	if(isdefined(var_7b2f88c6))
	{
		foreach(e_player in level.activeplayers)
		{
			if(e_player.characterindex == var_7b2f88c6)
			{
				arrayremovevalue(a_e_players, e_player, 0);
			}
		}
	}
	if(a_e_players.size == 0)
	{
		return undefined;
	}
	do
	{
		if(isdefined(v_location))
		{
			e_player = arraygetclosest(v_location, a_e_players);
		}
		else
		{
			e_player = array::random(a_e_players);
		}
		arrayremovevalue(a_e_players, e_player);
	}
	while(a_e_players.size > 0 && (!zm_utility::is_player_valid(e_player) || e_player isplayerunderwater()));
	return e_player;
}

/*
	Name: function_fcea1c5c
	Namespace: zm_stalingrad_vo
	Checksum: 0xE58E3F9A
	Offset: 0xB490
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_fcea1c5c()
{
	foreach(e_player in level.activeplayers)
	{
		if(e_player.characterindex == 2 && zm_utility::is_player_valid(e_player))
		{
			return e_player;
		}
	}
	return undefined;
}

/*
	Name: function_2d942575
	Namespace: zm_stalingrad_vo
	Checksum: 0xC534B08E
	Offset: 0xB548
	Size: 0xD2
	Parameters: 2
	Flags: Linked
*/
function function_2d942575(var_47db2fcf, var_72259a3d)
{
	if(isdefined(self) && isdefined(var_47db2fcf))
	{
		return self zm_sidequests::is_facing(var_47db2fcf) && (distancesquared(self.origin + vectorscale((0, 0, 1), 64), var_47db2fcf.origin + vectorscale((0, 0, 1), 64))) < zombie_utility::squared(var_72259a3d) && bullettracepassed(self.origin, var_47db2fcf.origin, 0, self, var_47db2fcf);
	}
	return 0;
}

/*
	Name: function_e9a29b5
	Namespace: zm_stalingrad_vo
	Checksum: 0x717E7C2F
	Offset: 0xB628
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function function_e9a29b5(var_d7e21dec)
{
	if(isdefined(var_d7e21dec))
	{
		if(gettime() < var_d7e21dec)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_2889c0e9
	Namespace: zm_stalingrad_vo
	Checksum: 0x732ABF25
	Offset: 0xB660
	Size: 0x7A
	Parameters: 2
	Flags: Linked
*/
function function_2889c0e9(str_vox, var_4c5a66ad)
{
	a_str_lines = [];
	for(i = 0; i < var_4c5a66ad; i++)
	{
		a_str_lines[i] = str_vox + i;
	}
	return array::random(a_str_lines);
}

