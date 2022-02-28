// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\cybercom\_cybercom;
#using scripts\shared\_oob;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\load_shared;
#using scripts\shared\music_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_satchel_charge;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\antipersonnelguidance;
#using scripts\shared\weapons\multilockapguidance;

#namespace bonuszm;

/*
	Name: __init__sytem__
	Namespace: bonuszm
	Checksum: 0xAF343790
	Offset: 0x1040
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bonuszm", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bonuszm
	Checksum: 0x1932FF8
	Offset: 0x1080
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	setupstaticmodelsforthemode();
	function_e6a554ef();
	if(!sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	register_clientfields();
	init_fx();
	setdvar("bg_friendlyFireMode", 0);
	level.setgibfxtoignorepause = 1;
	callback::on_spawned(&on_player_spawned);
	function_aea4686a();
	vehicle::add_vehicletype_callback("raps", &function_938d1a68);
}

/*
	Name: function_938d1a68
	Namespace: bonuszm
	Checksum: 0x657A316B
	Offset: 0x1168
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_938d1a68(localclientnum)
{
	self setanim("ai_zombie_zod_insanity_elemental_idle", 1);
}

/*
	Name: function_4d5aa4f3
	Namespace: bonuszm
	Checksum: 0x99EC1590
	Offset: 0x11A8
	Size: 0x4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_4d5aa4f3()
{
}

/*
	Name: on_player_spawned
	Namespace: bonuszm
	Checksum: 0x991479E1
	Offset: 0x11B8
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private on_player_spawned(localclientnum)
{
	self tmodeenable(0);
	setdvar("r_bloomUseLutALT", 1);
	function_8cf4b0ee(localclientnum);
}

/*
	Name: setupstaticmodelsforthemode
	Namespace: bonuszm
	Checksum: 0x29A414AF
	Offset: 0x1220
	Size: 0xDE
	Parameters: 0
	Flags: Linked
*/
function setupstaticmodelsforthemode()
{
	a_misc_models = findstaticmodelindexarray("zombie_misc_model");
	if(!sessionmodeiscampaignzombiesgame() || !util::is_mature())
	{
		foreach(a_misc_model in a_misc_models)
		{
			hidestaticmodel(a_misc_model);
		}
	}
}

/*
	Name: function_e6a554ef
	Namespace: bonuszm
	Checksum: 0x11C0A14
	Offset: 0x1308
	Size: 0xDE
	Parameters: 0
	Flags: Linked
*/
function function_e6a554ef()
{
	var_9302fbfc = findvolumedecalindexarray("zombie_volume_decal");
	if(!sessionmodeiscampaignzombiesgame() || !util::is_mature())
	{
		foreach(var_da4e043d in var_9302fbfc)
		{
			hidevolumedecal(var_da4e043d);
		}
	}
}

/*
	Name: function_9f75e681
	Namespace: bonuszm
	Checksum: 0xF5499CA2
	Offset: 0x13F0
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function function_9f75e681()
{
	mapname = getdvarstring("mapname");
	if(mapname != "cp_mi_sing_sgen" || mapname != "cp_mi_cairo_lotus2")
	{
		audio::playloopat("mus_bonuszm_underscore", (0, 0, 0));
	}
}

/*
	Name: register_clientfields
	Namespace: bonuszm
	Checksum: 0xAF630F02
	Offset: 0x1460
	Size: 0x694
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int", &handle_zombie_risers, 0, 1);
	clientfield::register("actor", "bonus_zombie_eye_color", 1, 3, "int", &zombie_eyes_clientfield_cb2, 0, 1);
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int", &zombie_eyes_clientfield_cb, 0, 1);
	clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int", &zombie_gut_explosion_cb, 0, 1);
	clientfield::register("actor", "bonuszm_zombie_on_fire_fx", 1, getminbitcountfornum(3), "int", &function_f83377d6, 0, 1);
	clientfield::register("actor", "bonuszm_zombie_spark_fx", 1, getminbitcountfornum(2), "int", &function_4b335db, 0, 1);
	clientfield::register("actor", "bonuszm_zombie_deimos_fx", 1, getminbitcountfornum(1), "int", &function_225fae17, 0, 1);
	clientfield::register("vehicle", "bonuszm_meatball_death", 1, 1, "int", &function_1f4cd60d, 0, 1);
	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int", &handle_zombie_risers, 0, 1);
	clientfield::register("actor", "bonuszm_zombie_death_fx", 1, getminbitcountfornum(5), "int", &function_e4d833e, 0, 1);
	clientfield::register("actor", "zombie_appear_vanish_fx", 1, getminbitcountfornum(3), "int", &function_7fc0e06, 0, 1);
	clientfield::register("scriptmover", "powerup_on_fx", 1, getminbitcountfornum(3), "int", &callback_powerup_on_fx, 0, 0);
	clientfield::register("scriptmover", "powerup_grabbed_fx", 1, 1, "int", &function_50779600, 0, 0);
	clientfield::register("scriptmover", "weapon_disappear_fx", 1, 1, "int", &function_42f6f16e, 0, 0);
	clientfield::register("scriptmover", "sparky_trail_fx", 1, 1, "int", &function_ab68bae5, 0, 0);
	clientfield::register("scriptmover", "sparky_attack_fx", 1, 1, "counter", &function_14312cfd, 0, 0);
	clientfield::register("actor", "sparky_damaged_fx", 1, 1, "counter", &function_97590d4, 0, 0);
	clientfield::register("actor", "fire_damaged_fx", 1, 1, "counter", &function_780c0a4, 0, 0);
	clientfield::register("zbarrier", "magicbox_open_glow", 1, 1, "int", &magicbox_open_glow_callback, 0, 0);
	clientfield::register("zbarrier", "magicbox_closed_glow", 1, 1, "int", &magicbox_closed_glow_callback, 0, 0);
	clientfield::register("toplayer", "bonuszm_player_instakill_active_fx", 1, 1, "int", &function_bba3723b, 0, 0);
	clientfield::register("world", "cpzm_song_suppression", 1, 1, "int", &function_2122d6fd, 0, 0);
}

/*
	Name: init_fx
	Namespace: bonuszm
	Checksum: 0xE875C8B8
	Offset: 0x1B00
	Size: 0x32E
	Parameters: 0
	Flags: Linked
*/
function init_fx()
{
	level._effect["eye_glow_o"] = "zombie/fx_glow_eye_orange";
	level._effect["eye_glow_b"] = "zombie/fx_glow_eye_blue";
	level._effect["eye_glow_g"] = "zombie/fx_glow_eye_green";
	level._effect["eye_glow_r"] = "zombie/fx_glow_eye_red";
	level._effect["rise_burst"] = "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow"] = "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust"] = "zombie/fx_spawn_dirt_body_dustfalling_zmb";
	level._effect["powerup_on"] = "zombie/fx_powerup_on_solo_zmb";
	level._effect["powerup_on_upgraded"] = "zombie/fx_powerup_on_green_zmb";
	level._effect["powerup_on_upgraded_all"] = "zombie/fx_powerup_on_caution_zmb";
	level._effect["chest_light"] = "zombie/fx_weapon_box_open_glow_zmb";
	level._effect["chest_light_closed"] = "zombie/fx_weapon_box_closed_glow_zmb";
	level._effect["zombie_spawn"] = "zombie/fx_spawn_body_cp_zmb";
	level._effect["zombie_sparky"] = "electric/fx_ability_elec_surge_short_robot";
	level._effect["zombie_sparky_death"] = "explosions/fx_ability_exp_ravage_core";
	level._effect["zombie_sparky_trail"] = "electric/fx_ability_elec_strike_trail";
	level._effect["zombie_sparky_impact"] = "electric/fx_ability_elec_strike_impact";
	level._effect["zombie_sparky_attack_death"] = "electric/fx_ability_elec_strike_short_human";
	level._effect["zombie_sparky_left_hand"] = "weapon/fx_hero_lightning_gun_death_hands_lft";
	level._effect["zombie_sparky_right_hand"] = "weapon/fx_hero_lightning_gun_death_hands";
	level._effect["zombie_fire_damage"] = "fire/fx_embers_burst";
	level._effect["zombie_on_fire_suicide"] = "explosions/fx_exp_dest_barrel_concussion_sm";
	level._effect["zombie_fire_light"] = "light/fx_light_fire_chest_zombie";
	level._effect["zombie_spark_light"] = "light/fx_light_spark_chest_zombie";
	level._effect["electric_spark"] = "electric/fx_elec_sparks_burst_blue";
	level._effect["deimos_zombie"] = "player/fx_ai_corvus_torso_loop";
	level._effect["deimos_zombie_le"] = "player/fx_ai_raven_teleport_out_arm_le";
	level._effect["deimos_zombie_ri"] = "player/fx_ai_raven_teleport_out_arm_ri";
	level._effect["deimos_zombie_death"] = "player/fx_ai_raven_dissolve_torso";
}

/*
	Name: handle_zombie_risers
	Namespace: bonuszm
	Checksum: 0x2CB9B567
	Offset: 0x1E38
	Size: 0x174
	Parameters: 7
	Flags: Linked
*/
function handle_zombie_risers(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level endon(#"demo_jump");
	self endon(#"entityshutdown");
	if(newval)
	{
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst"];
		billow_fx = level._effect["rise_billow"];
		type = "dirt";
		if(isdefined(level.riser_type) && level.riser_type == "snow")
		{
			sound = "zmb_zombie_spawn";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}
		playsound(0, sound, self.origin);
		self thread rise_dust_fx(localclientnum, type, billow_fx, burst_fx);
	}
}

/*
	Name: rise_dust_fx
	Namespace: bonuszm
	Checksum: 0x6B4C622D
	Offset: 0x1FB8
	Size: 0x29E
	Parameters: 4
	Flags: Linked
*/
function rise_dust_fx(localclientnum, type, billow_fx, burst_fx)
{
	dust_tag = "J_SpineUpper";
	self endon(#"entityshutdown");
	level endon(#"demo_jump");
	if(isdefined(burst_fx))
	{
		fx = playfx(localclientnum, burst_fx, self.origin + (0, 0, randomintrange(5, 10)));
		setfxignorepause(localclientnum, fx, 1);
	}
	wait(0.25);
	if(isdefined(billow_fx))
	{
		fx = playfx(localclientnum, billow_fx, self.origin + (randomintrange(-10, 10), randomintrange(-10, 10), randomintrange(5, 10)));
		setfxignorepause(localclientnum, fx, 1);
	}
	wait(2);
	dust_time = 5.5;
	dust_interval = 0.3;
	player = level.localplayers[localclientnum];
	effect = level._effect["rise_dust"];
	if(type == "snow")
	{
		effect = level._effect["rise_dust_snow"];
	}
	else if(type == "none")
	{
		return;
	}
	self util::waittill_dobj(localclientnum);
	t = 0;
	while(t < dust_time)
	{
		fx = playfxontag(localclientnum, effect, self, dust_tag);
		setfxignorepause(localclientnum, fx, 1);
		wait(dust_interval);
		t = t + dust_interval;
	}
}

/*
	Name: zombie_eyes_clientfield_cb2
	Namespace: bonuszm
	Checksum: 0xD7DB59F0
	Offset: 0x2260
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function zombie_eyes_clientfield_cb2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	self.eyecol = newval;
}

/*
	Name: zombie_eyes_clientfield_cb
	Namespace: bonuszm
	Checksum: 0x59D70D3
	Offset: 0x22C0
	Size: 0x17C
	Parameters: 7
	Flags: Linked
*/
function zombie_eyes_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		self createzombieeyesinternal(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color());
	}
	else
	{
		self deletezombieeyes(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
	}
	if(isdefined(level.zombie_eyes_clientfield_cb_additional))
	{
		self [[level.zombie_eyes_clientfield_cb_additional]](localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
	}
}

/*
	Name: createzombieeyesinternal
	Namespace: bonuszm
	Checksum: 0x67DDEB08
	Offset: 0x2448
	Size: 0x1AA
	Parameters: 1
	Flags: Linked
*/
function createzombieeyesinternal(localclientnum)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self._eyearray))
	{
		self._eyearray = [];
	}
	if(!isdefined(self._eyearray[localclientnum]))
	{
		linktag = "j_eyeball_le";
		if(!isdefined(self.eyecol))
		{
			return;
		}
		if(self.eyecol == 0)
		{
			effect = level._effect["eye_glow_o"];
		}
		else
		{
			if(self.eyecol == 1)
			{
				effect = level._effect["eye_glow_b"];
			}
			else
			{
				if(self.eyecol == 2)
				{
					effect = level._effect["eye_glow_g"];
				}
				else
				{
					if(self.eyecol == 3)
					{
						effect = level._effect["eye_glow_r"];
					}
					else
					{
						return;
					}
				}
			}
		}
		if(isdefined(level._override_eye_fx))
		{
			effect = level._override_eye_fx;
		}
		if(isdefined(self._eyeglow_fx_override))
		{
			effect = self._eyeglow_fx_override;
		}
		if(isdefined(self._eyeglow_tag_override))
		{
			linktag = self._eyeglow_tag_override;
		}
		self._eyearray[localclientnum] = playfxontag(localclientnum, effect, self, linktag);
	}
}

/*
	Name: get_eyeball_on_luminance
	Namespace: bonuszm
	Checksum: 0x4E4FA3BB
	Offset: 0x2600
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_on_luminance()
{
	if(isdefined(level.eyeball_on_luminance_override))
	{
		return level.eyeball_on_luminance_override;
	}
	return 1;
}

/*
	Name: get_eyeball_off_luminance
	Namespace: bonuszm
	Checksum: 0x4F1D99F2
	Offset: 0x2628
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_off_luminance()
{
	if(isdefined(level.eyeball_off_luminance_override))
	{
		return level.eyeball_off_luminance_override;
	}
	return 0;
}

/*
	Name: get_eyeball_color
	Namespace: bonuszm
	Checksum: 0xEEE6B837
	Offset: 0x2650
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_color()
{
	val = 0;
	if(isdefined(level.zombie_eyeball_color_override))
	{
		val = level.zombie_eyeball_color_override;
	}
	if(isdefined(self.zombie_eyeball_color_override))
	{
		val = self.zombie_eyeball_color_override;
	}
	return val;
}

/*
	Name: deletezombieeyes
	Namespace: bonuszm
	Checksum: 0xCB39911E
	Offset: 0x26A0
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function deletezombieeyes(localclientnum)
{
	if(isdefined(self._eyearray))
	{
		if(isdefined(self._eyearray[localclientnum]))
		{
			deletefx(localclientnum, self._eyearray[localclientnum], 1);
			self._eyearray[localclientnum] = undefined;
		}
	}
}

/*
	Name: callback_powerup_on_fx
	Namespace: bonuszm
	Checksum: 0x1718EB21
	Offset: 0x2708
	Size: 0x2CC
	Parameters: 7
	Flags: Linked
*/
function callback_powerup_on_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(newval == 3)
		{
			self.pwr_fx = playfxontag(localclientnum, level._effect["powerup_on_upgraded_all"], self, "tag_origin");
		}
		else
		{
			if(newval == 2)
			{
				self.pwr_fx = playfxontag(localclientnum, level._effect["powerup_on_upgraded"], self, "tag_origin");
			}
			else
			{
				self.pwr_fx = playfxontag(localclientnum, level._effect["powerup_on"], self, "tag_origin");
			}
		}
		setfxignorepause(localclientnum, self.pwr_fx, 1);
		if(self.model === "p7_zm_teddybear_sitting")
		{
		}
		else
		{
			playsound(localclientnum, "zmb_spawn_powerup", self.origin);
			self playloopsound("zmb_spawn_powerup_loop", 0.5);
		}
	}
	else if(isdefined(self.pwr_fx))
	{
		self stopallloopsounds();
		deletefx(localclientnum, self.pwr_fx, 1);
		self.pwr_fx = undefined;
		fx = playfxontag(localclientnum, level._effect["electric_spark"], self, "tag_origin");
		setfxignorepause(localclientnum, fx, 1);
		playsound(localclientnum, "zmb_box_timeout_poof", self.origin);
		playrumbleonposition(localclientnum, "damage_light", self.origin);
	}
}

/*
	Name: function_50779600
	Namespace: bonuszm
	Checksum: 0x501DD6E2
	Offset: 0x29E0
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_50779600(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	if(newval)
	{
		playsound(localclientnum, "zmb_powerup_grabbed", self.origin);
	}
}

/*
	Name: function_f83377d6
	Namespace: bonuszm
	Checksum: 0x3F7BABF3
	Offset: 0x2A60
	Size: 0x18C
	Parameters: 7
	Flags: Linked
*/
function function_f83377d6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval == 1 || newval == 2)
	{
		if(!isdefined(self.var_6044d98e))
		{
			self.var_6044d98e = self playloopsound("zmb_fire_burn_loop", 0.2);
		}
		if(newval == 2)
		{
			fx = playfxontag(localclientnum, level._effect["zombie_fire_light"], self, "J_SpineUpper");
			setfxignorepause(localclientnum, fx, 1);
			self function_d8c8d819(localclientnum, "fire");
		}
	}
	else if(newval == 3)
	{
		playsound(localclientnum, "zmb_fire_charge_up", self.origin);
	}
}

/*
	Name: function_780c0a4
	Namespace: bonuszm
	Checksum: 0x3C26067E
	Offset: 0x2BF8
	Size: 0x144
	Parameters: 7
	Flags: Linked
*/
function function_780c0a4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(isdefined(level._effect["zombie_fire_damage"]))
		{
			playsound(localclientnum, "gdt_electro_bounce", self.origin);
			locs = array("j_wrist_le", "j_wrist_ri");
			fx = playfxontag(localclientnum, level._effect["zombie_fire_damage"], self, array::random(locs));
			setfxignorepause(localclientnum, fx, 1);
		}
	}
}

/*
	Name: function_4b335db
	Namespace: bonuszm
	Checksum: 0xB85B9C29
	Offset: 0x2D48
	Size: 0x194
	Parameters: 7
	Flags: Linked
*/
function function_4b335db(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval >= 1)
	{
		if(!isdefined(self.var_6044d98e))
		{
			self.var_6044d98e = self playloopsound("zmb_electrozomb_lp", 0.2);
		}
		fx = playfxontag(localclientnum, level._effect["zombie_sparky"], self, "J_SpineUpper");
		setfxignorepause(localclientnum, fx, 1);
		if(newval == 2)
		{
			fx = playfxontag(localclientnum, level._effect["zombie_spark_light"], self, "J_SpineUpper");
			setfxignorepause(localclientnum, fx, 1);
			self function_d8c8d819(localclientnum, "sparky");
		}
	}
}

/*
	Name: function_225fae17
	Namespace: bonuszm
	Checksum: 0x909A4F98
	Offset: 0x2EE8
	Size: 0x1B4
	Parameters: 7
	Flags: Linked
*/
function function_225fae17(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(!isdefined(self.var_6044d98e))
		{
			self.var_6044d98e = self playloopsound("zmb_deimoszomb_lp", 0.2);
		}
		fx = playfxontag(localclientnum, level._effect["deimos_zombie"], self, "J_SpineUpper");
		setfxignorepause(localclientnum, fx, 1);
		fx = playfxontag(localclientnum, level._effect["deimos_zombie_le"], self, "j_wrist_le");
		setfxignorepause(localclientnum, fx, 1);
		fx = playfxontag(localclientnum, level._effect["deimos_zombie_ri"], self, "j_wrist_ri");
		setfxignorepause(localclientnum, fx, 1);
	}
}

/*
	Name: function_1f4cd60d
	Namespace: bonuszm
	Checksum: 0xBAC70891
	Offset: 0x30A8
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function function_1f4cd60d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval == 1)
	{
		fx = playfxontag(localclientnum, level._effect["zombie_on_fire_suicide"], self, "tag_origin");
		setfxignorepause(localclientnum, fx, 1);
		playsound(localclientnum, "zmb_fire_explode", self.origin);
	}
}

/*
	Name: function_bba3723b
	Namespace: bonuszm
	Checksum: 0x79D741A7
	Offset: 0x31B8
	Size: 0xF4
	Parameters: 7
	Flags: Linked
*/
function function_bba3723b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.var_dedf9511 = self playloopsound("zmb_insta_kill_loop", 2);
		self thread function_69f683e7(localclientnum, 1);
	}
	else
	{
		self notify(#"hash_eb366021");
		playsound(localclientnum, "zmb_insta_kill_loop_off", (0, 0, 0));
		self stoploopsound(self.var_dedf9511);
		self thread function_69f683e7(localclientnum, 0);
	}
}

/*
	Name: function_4778b020
	Namespace: bonuszm
	Checksum: 0xC192107B
	Offset: 0x32B8
	Size: 0x96
	Parameters: 2
	Flags: Linked
*/
function function_4778b020(lo, hi)
{
	color = (randomfloatrange(lo[0], hi[0]), randomfloatrange(lo[1], hi[1]), randomfloatrange(lo[2], hi[2]));
	return color;
}

/*
	Name: function_4b2bbece
	Namespace: bonuszm
	Checksum: 0xB72A031B
	Offset: 0x3358
	Size: 0xAA
	Parameters: 3
	Flags: Linked
*/
function function_4b2bbece(var_3ae5c24, var_1bfa7cb7, frac)
{
	frac0 = 1 - frac;
	color = ((frac0 * var_3ae5c24[0]) + (frac * var_1bfa7cb7[0]), (frac0 * var_3ae5c24[1]) + (frac * var_1bfa7cb7[1]), (frac0 * var_3ae5c24[2]) + (frac * var_1bfa7cb7[2]));
	return color;
}

/*
	Name: function_69f683e7
	Namespace: bonuszm
	Checksum: 0x3880A36A
	Offset: 0x3410
	Size: 0x1AE
	Parameters: 2
	Flags: Linked
*/
function function_69f683e7(localclientnum, onoff)
{
	self notify(#"hash_bc7b7772");
	self endon(#"hash_bc7b7772");
	if(!onoff)
	{
		self setcontrollerlightbarcolor(localclientnum);
		return;
	}
	var_781fc232 = (63, 103, 4) / 255;
	var_27745be8 = (105, 148, 24) / 255;
	var_d7805253 = 2;
	var_ec055171 = 0.25;
	cycle_time = var_d7805253;
	old_color = function_4778b020(var_781fc232, var_27745be8);
	new_color = old_color;
	while(isdefined(self))
	{
		if(cycle_time >= var_d7805253)
		{
			old_color = new_color;
			new_color = function_4778b020(var_781fc232, var_27745be8);
			cycle_time = 0;
		}
		color = function_4b2bbece(old_color, new_color, cycle_time / var_d7805253);
		self setcontrollerlightbarcolor(localclientnum, color);
		cycle_time = cycle_time + var_ec055171;
		wait(var_ec055171);
	}
}

/*
	Name: function_d8c8d819
	Namespace: bonuszm
	Checksum: 0x7EF3272B
	Offset: 0x35C8
	Size: 0x1F4
	Parameters: 2
	Flags: Linked
*/
function function_d8c8d819(localclientnum, var_d6ae4487)
{
	self endon(#"entityshutdown");
	self.var_13f5905e = 1;
	self duplicate_render::set_dr_flag("armor_on", 1);
	self duplicate_render::update_dr_filters(localclientnum);
	var_aa5d763a = "scriptVector3";
	var_fc81e73c = 0.1;
	colortintvaluey = 0.56;
	colortintvaluez = 0.92;
	colortintvaluew = 1;
	var_93429fd9 = 0.2;
	if(var_d6ae4487 == "sparky")
	{
		var_754d7044 = 0.15;
		var_e754df7f = 0.5;
		var_595c4eba = 0.4;
		var_93429fd9 = 0.2;
	}
	if(var_d6ae4487 == "fire")
	{
		var_754d7044 = 0.6;
		var_e754df7f = 0.45;
		var_595c4eba = 0;
		var_93429fd9 = 0.2;
	}
	var_6c5c3132 = "scriptVector4";
	self mapshaderconstant(localclientnum, 0, var_aa5d763a, var_fc81e73c, var_754d7044, var_e754df7f, var_595c4eba);
	self mapshaderconstant(localclientnum, 0, var_6c5c3132, var_93429fd9, 0, 0, 0);
	self tmodesetflag(10);
}

/*
	Name: function_e4d833e
	Namespace: bonuszm
	Checksum: 0xB848D41
	Offset: 0x37C8
	Size: 0x4C4
	Parameters: 7
	Flags: Linked
*/
function function_e4d833e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval == 5)
	{
		if(getdvarstring("mapname") != "cp_mi_zurich_coalescence")
		{
			self stopallloopsounds(1);
			fx = playfx(localclientnum, level._effect["deimos_zombie_death"], self.origin + vectorscale((0, 0, 1), 35));
			setfxignorepause(localclientnum, fx, 1);
			fx = playfx(localclientnum, level._effect["zombie_sparky_death"], self.origin + vectorscale((0, 0, 1), 35));
			setfxignorepause(localclientnum, fx, 1);
			playsound(localclientnum, "zmb_deimoszomb_explo", self.origin);
			playrumbleonposition(localclientnum, "damage_light", self.origin);
		}
	}
	if(newval == 4)
	{
		self stopallloopsounds(1);
		fx = playfx(localclientnum, level._effect["zombie_sparky_attack_death"], self.origin + vectorscale((0, 0, 1), 35));
		setfxignorepause(localclientnum, fx, 1);
		playsound(localclientnum, "zmb_electrozomb_explo_small", self.origin);
		playrumbleonposition(localclientnum, "damage_light", self.origin);
	}
	if(newval == 3)
	{
		self stopallloopsounds(1);
		fx = playfx(localclientnum, level._effect["zombie_sparky_death"], self.origin + vectorscale((0, 0, 1), 35));
		setfxignorepause(localclientnum, fx, 1);
		playsound(localclientnum, "zmb_electrozomb_explo_large", self.origin);
		playrumbleonposition(localclientnum, "damage_light", self.origin);
	}
	if(newval == 2)
	{
		self stopallloopsounds(1);
		fx = playfx(localclientnum, level._effect["zombie_on_fire_suicide"], self.origin + vectorscale((0, 0, 1), 35));
		setfxignorepause(localclientnum, fx, 1);
		playsound(localclientnum, "zmb_fire_explode", self.origin);
		playrumbleonposition(localclientnum, "damage_light", self.origin);
	}
	if(newval > 0)
	{
		fxobj = util::spawn_model(localclientnum, "tag_origin", self.origin, self.angles);
		fxobj thread function_10dcbf51(localclientnum, fxobj);
	}
}

/*
	Name: function_10dcbf51
	Namespace: bonuszm
	Checksum: 0xFE64B1BD
	Offset: 0x3C98
	Size: 0x54
	Parameters: 2
	Flags: Linked, Private
*/
function private function_10dcbf51(localclientnum, fxobj)
{
	fxobj playsound(localclientnum, "evt_ai_insta_explode");
	wait(1);
	fxobj delete();
}

/*
	Name: zombie_gut_explosion_cb
	Namespace: bonuszm
	Checksum: 0x817D02BD
	Offset: 0x3CF8
	Size: 0x10C
	Parameters: 7
	Flags: Linked
*/
function zombie_gut_explosion_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(isdefined(level._effect["zombie_guts_explosion"]))
		{
			org = self gettagorigin("J_SpineLower");
			if(isdefined(org))
			{
				fx = playfx(localclientnum, level._effect["zombie_guts_explosion"], org);
				setfxignorepause(localclientnum, fx, 1);
			}
		}
	}
}

/*
	Name: function_ab68bae5
	Namespace: bonuszm
	Checksum: 0x34DD33E1
	Offset: 0x3E10
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function function_ab68bae5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(isdefined(level._effect["zombie_sparky_trail"]))
		{
			self playloopsound("zmb_fire_burn_loop", 0.1);
			fx = playfxontag(localclientnum, level._effect["zombie_sparky_trail"], self, "tag_origin");
			setfxignorepause(localclientnum, fx, 1);
		}
	}
}

/*
	Name: function_14312cfd
	Namespace: bonuszm
	Checksum: 0xBB5791E8
	Offset: 0x3F20
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function function_14312cfd(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(isdefined(level._effect["zombie_sparky_impact"]))
		{
			fx = playfx(localclientnum, level._effect["zombie_sparky_impact"], self.origin);
			setfxignorepause(localclientnum, fx, 1);
		}
	}
}

/*
	Name: function_97590d4
	Namespace: bonuszm
	Checksum: 0x6D6773BC
	Offset: 0x4008
	Size: 0x154
	Parameters: 7
	Flags: Linked
*/
function function_97590d4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(isdefined(level._effect["zombie_sparky_left_hand"]))
		{
			playsound(localclientnum, "gdt_electro_bounce", self.origin);
			fx = playfxontag(localclientnum, level._effect["zombie_sparky_left_hand"], self, "j_wrist_le");
			setfxignorepause(localclientnum, fx, 1);
			fx = playfxontag(localclientnum, level._effect["zombie_sparky_right_hand"], self, "j_wrist_ri");
			setfxignorepause(localclientnum, fx, 1);
		}
	}
}

/*
	Name: function_42f6f16e
	Namespace: bonuszm
	Checksum: 0x5806B800
	Offset: 0x4168
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function function_42f6f16e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(isdefined(level._effect["zombie_spawn"]))
		{
			playsound(localclientnum, "zmb_box_timeout_poof", self.origin);
			fx = playfx(localclientnum, level._effect["electric_spark"], self.origin);
			setfxignorepause(localclientnum, fx, 1);
		}
	}
}

/*
	Name: magicbox_open_glow_callback
	Namespace: bonuszm
	Checksum: 0x28AF7915
	Offset: 0x4278
	Size: 0x1DC
	Parameters: 7
	Flags: Linked
*/
function magicbox_open_glow_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.open_glow_obj_array))
	{
		self.open_glow_obj_array = [];
	}
	if(newval && !isdefined(self.open_glow_obj_array[localclientnum]))
	{
		fx_obj = spawn(localclientnum, self.origin, "script_model");
		fx_obj setmodel("tag_origin");
		fx_obj.angles = self.angles;
		fx = playfxontag(localclientnum, level._effect["chest_light"], fx_obj, "tag_origin");
		setfxignorepause(localclientnum, fx, 1);
		playsound(localclientnum, "zmb_lid_open", self.origin);
		playsound(localclientnum, "zmb_music_box", self.origin);
		self.open_glow_obj_array[localclientnum] = fx_obj;
		self open_glow_obj_demo_jump_listener(localclientnum);
	}
	else if(!newval && isdefined(self.open_glow_obj_array[localclientnum]))
	{
		self open_glow_obj_cleanup(localclientnum);
	}
}

/*
	Name: open_glow_obj_demo_jump_listener
	Namespace: bonuszm
	Checksum: 0xBAE9B0E7
	Offset: 0x4460
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function open_glow_obj_demo_jump_listener(localclientnum)
{
	self endon(#"end_demo_jump_listener");
	level waittill(#"demo_jump");
	self open_glow_obj_cleanup(localclientnum);
}

/*
	Name: open_glow_obj_cleanup
	Namespace: bonuszm
	Checksum: 0x14A01640
	Offset: 0x44A8
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function open_glow_obj_cleanup(localclientnum)
{
	self.open_glow_obj_array[localclientnum] delete();
	self.open_glow_obj_array[localclientnum] = undefined;
	self notify(#"end_demo_jump_listener");
}

/*
	Name: magicbox_closed_glow_callback
	Namespace: bonuszm
	Checksum: 0x13912F4B
	Offset: 0x44F8
	Size: 0x1E4
	Parameters: 7
	Flags: Linked
*/
function magicbox_closed_glow_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(!isdefined(self.closed_glow_obj_array))
	{
		self.closed_glow_obj_array = [];
	}
	if(newval && !isdefined(self.closed_glow_obj_array[localclientnum]))
	{
		fx_obj = spawn(localclientnum, self.origin, "script_model");
		fx_obj setmodel("tag_origin");
		fx_obj.angles = self.angles;
		fx = playfxontag(localclientnum, level._effect["chest_light_closed"], fx_obj, "tag_origin");
		setfxignorepause(localclientnum, fx, 1);
		playsound(localclientnum, "zmb_lid_close", self.origin);
		self.closed_glow_obj_array[localclientnum] = fx_obj;
		self closed_glow_obj_demo_jump_listener(localclientnum);
	}
	else if(!newval && isdefined(self.closed_glow_obj_array[localclientnum]))
	{
		self closed_glow_obj_cleanup(localclientnum);
	}
}

/*
	Name: closed_glow_obj_demo_jump_listener
	Namespace: bonuszm
	Checksum: 0xAC813D0C
	Offset: 0x46E8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function closed_glow_obj_demo_jump_listener(localclientnum)
{
	self endon(#"end_demo_jump_listener");
	level waittill(#"demo_jump");
	self closed_glow_obj_cleanup(localclientnum);
}

/*
	Name: closed_glow_obj_cleanup
	Namespace: bonuszm
	Checksum: 0x50AD788A
	Offset: 0x4730
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function closed_glow_obj_cleanup(localclientnum)
{
	self.closed_glow_obj_array[localclientnum] delete();
	self.closed_glow_obj_array[localclientnum] = undefined;
	self notify(#"end_demo_jump_listener");
}

/*
	Name: function_aea4686a
	Namespace: bonuszm
	Checksum: 0xF6E308F2
	Offset: 0x4780
	Size: 0x17E
	Parameters: 0
	Flags: Linked
*/
function function_aea4686a()
{
	var_6a173bd1 = ("gamedata/tables/cpzm/") + "cpzm_weapons_sgen.csv";
	var_adeb478a = tablelookuprowcount(var_6a173bd1);
	var_709de245 = [];
	for(i = 0; i < var_adeb478a; i++)
	{
		weaponname = tablelookupcolumnforrow(var_6a173bd1, i, 0);
		array::add(var_709de245, weaponname);
	}
	var_709de245 = array::randomize(var_709de245);
	for(i = 0; i < var_709de245.size; i++)
	{
		if(i >= 30)
		{
			break;
		}
		weapon = getweapon(var_709de245[i]);
		if(!isdefined(weapon))
		{
			continue;
		}
		if(isdefined(weapon.worldmodel))
		{
			addzombieboxweapon(weapon, weapon.worldmodel, 0);
		}
	}
}

/*
	Name: function_8cf4b0ee
	Namespace: bonuszm
	Checksum: 0xF5112E3B
	Offset: 0x4908
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_8cf4b0ee(localclientnum)
{
	filter::map_material_helper(self, "generic_zombie_bblend_vignette");
	setfilterpassmaterial(self.localclientnum, 7, 0, filter::mapped_material_id("generic_zombie_bblend_vignette"));
	setfilterpassenabled(self.localclientnum, 7, 0, 1);
	setfilterpassconstant(self.localclientnum, 7, 0, 0, 1);
	setfilterpassconstant(self.localclientnum, 7, 0, 1, 0);
}

/*
	Name: function_7fc0e06
	Namespace: bonuszm
	Checksum: 0xA993F20A
	Offset: 0x49E0
	Size: 0x1CC
	Parameters: 7
	Flags: Linked
*/
function function_7fc0e06(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval == 1)
	{
		playsound(localclientnum, "zmb_flashback_disappear_npc", self.origin);
		playfx(localclientnum, level._effect["zombie_spawn"], self.origin + vectorscale((0, 0, 1), 35));
	}
	else
	{
		if(newval == 2)
		{
			playsound(localclientnum, "zmb_flashback_reappear_npc", self.origin);
			playfx(localclientnum, level._effect["zombie_spawn"], self.origin + vectorscale((0, 0, 1), 35));
		}
		else if(newval == 3)
		{
			playsound(localclientnum, "zmb_flashback_reappear_npc", self.origin);
			playfx(localclientnum, level._effect["zombie_spawn"], self.origin + vectorscale((0, 0, 1), 35));
		}
	}
}

/*
	Name: function_2122d6fd
	Namespace: bonuszm
	Checksum: 0xA8ABE6BB
	Offset: 0x4BB8
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function function_2122d6fd(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.var_673a9a22))
	{
		level.var_673a9a22 = spawn(0, (0, 0, 0), "script_origin");
	}
	if(newval)
	{
		level.var_ed1ec8bc = level.var_673a9a22 playloopsound("zmb_cp_song_suppress");
	}
	else if(isdefined(level.var_ed1ec8bc))
	{
		level.var_673a9a22 stoploopsound(level.var_ed1ec8bc);
	}
}

