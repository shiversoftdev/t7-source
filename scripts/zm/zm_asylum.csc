// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\music_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_random;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;
#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_radio;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_asylum_ffotd;
#using scripts\zm\zm_asylum_fx;

#namespace zm_asylum;

/*
	Name: function_d9af860b
	Namespace: zm_asylum
	Checksum: 0x19709FFF
	Offset: 0x6D0
	Size: 0x1C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec function_d9af860b()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
}

/*
	Name: main
	Namespace: zm_asylum
	Checksum: 0x2EAA74FD
	Offset: 0x6F8
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_asylum_ffotd::main_start();
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	start_zombie_stuff();
	zm_asylum_fx::main();
	visionset_mgr::register_visionset_info("zm_showerhead", 21000, 31, undefined, "zm_bloodwash_red");
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_showerhead_postfx", 21000, 32, "pstfx_blood_wash", 3);
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_waterfall_postfx", 21000, 32, "pstfx_shower_wash", 3);
	level._uses_sticky_grenades = 1;
	init_clientfields();
	load::main();
	_zm_weap_cymbal_monkey::init();
	_zm_weap_tesla::init();
	util::waitforclient(0);
	level thread function_d87a7dcc();
	level thread function_c9207335();
	level thread function_d19cb2f8();
	/#
		println("");
	#/
	zm_asylum_ffotd::main_end();
}

/*
	Name: init_clientfields
	Namespace: zm_asylum
	Checksum: 0x217B1330
	Offset: 0x8C0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("world", "asylum_trap_fx_north", 21000, 1, "int", &zm_asylum_fx::function_93f91575, 0, 0);
	clientfield::register("world", "asylum_trap_fx_south", 21000, 1, "int", &zm_asylum_fx::function_4c17ba1b, 0, 0);
	clientfield::register("world", "asylum_generator_state", 21000, 1, "int", &function_d56a2c4b, 0, 0);
}

/*
	Name: start_zombie_stuff
	Namespace: zm_asylum
	Checksum: 0x7FD86DA
	Offset: 0x9A8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function start_zombie_stuff()
{
	include_weapons();
	_zm_weap_cymbal_monkey::init();
}

/*
	Name: include_weapons
	Namespace: zm_asylum
	Checksum: 0xA780EA69
	Offset: 0x9D8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_asylum_weapons.csv", 1);
}

/*
	Name: function_d87a7dcc
	Namespace: zm_asylum
	Checksum: 0xBAE1FC32
	Offset: 0xA08
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function function_d87a7dcc()
{
	var_bd7ba30 = 0;
	while(true)
	{
		if(!level clientfield::get("zombie_power_on"))
		{
			level.power_on = 0;
			if(var_bd7ba30)
			{
				level notify(#"power_controlled_light");
			}
			level util::waittill_any("power_on", "pwr", "ZPO");
		}
		level notify(#"power_controlled_light");
		level util::waittill_any("pwo", "ZPOff");
		var_bd7ba30 = 1;
	}
}

/*
	Name: function_d56a2c4b
	Namespace: zm_asylum
	Checksum: 0x61FE4A2C
	Offset: 0xAE0
	Size: 0x88
	Parameters: 7
	Flags: Linked
*/
function function_d56a2c4b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		level.var_c4ea7bb2 = 1;
		level thread play_random_generator_sparks();
	}
	else if(isdefined(level.var_c4ea7bb2) && level.var_c4ea7bb2)
	{
		level.var_c4ea7bb2 = 0;
	}
}

/*
	Name: play_random_generator_sparks
	Namespace: zm_asylum
	Checksum: 0x43D15260
	Offset: 0xB70
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function play_random_generator_sparks()
{
	while(level.var_c4ea7bb2)
	{
		wait(randomfloatrange(0.45, 0.85));
		playsound(0, "amb_elec_arc_generator", (-672, -264, 296));
	}
}

/*
	Name: function_c9207335
	Namespace: zm_asylum
	Checksum: 0x697CAB3F
	Offset: 0xBD0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_c9207335()
{
	wait(3);
	level thread function_d667714e();
	var_13a52dfe = getentarray(0, "sndMusicTrig", "targetname");
	array::thread_all(var_13a52dfe, &function_60a32834);
}

/*
	Name: function_60a32834
	Namespace: zm_asylum
	Checksum: 0xDAB0934B
	Offset: 0xC50
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_60a32834()
{
	while(true)
	{
		self waittill(#"trigger", trigplayer);
		if(trigplayer islocalplayer())
		{
			level notify(#"hash_51d7bc7c", self.script_sound);
			while(isdefined(trigplayer) && trigplayer istouching(self))
			{
				wait(0.016);
			}
		}
		else
		{
			wait(0.016);
		}
	}
}

/*
	Name: function_d667714e
	Namespace: zm_asylum
	Checksum: 0x84694B1B
	Offset: 0xCF0
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function function_d667714e()
{
	level.var_b6342abd = "mus_asylum_underscore_default";
	level.var_6d9d81aa = "mus_asylum_underscore_default";
	level.var_eb526c90 = spawn(0, (0, 0, 0), "script_origin");
	level.var_9433cf5a = level.var_eb526c90 playloopsound(level.var_b6342abd, 2);
	while(true)
	{
		level waittill(#"hash_51d7bc7c", location);
		level.var_6d9d81aa = "mus_asylum_underscore_" + location;
		if(level.var_6d9d81aa != level.var_b6342abd)
		{
			level thread function_b234849(level.var_6d9d81aa);
			level.var_b6342abd = level.var_6d9d81aa;
		}
	}
}

/*
	Name: function_b234849
	Namespace: zm_asylum
	Checksum: 0x3A920E5B
	Offset: 0xDF0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_b234849(var_6d9d81aa)
{
	level endon(#"hash_51d7bc7c");
	level.var_eb526c90 stopallloopsounds(2);
	wait(1);
	level.var_9433cf5a = level.var_eb526c90 playloopsound(var_6d9d81aa, 2);
}

/*
	Name: function_d19cb2f8
	Namespace: zm_asylum
	Checksum: 0xCC7C49F1
	Offset: 0xE60
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_d19cb2f8()
{
	loopers = struct::get_array("exterior_goal", "targetname");
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
	Name: soundloopthink
	Namespace: zm_asylum
	Checksum: 0x1D058ADC
	Offset: 0xFC8
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function soundloopthink()
{
	if(!isdefined(self.origin))
	{
		return;
	}
	if(!isdefined(self.script_sound))
	{
		self.script_sound = "zmb_spawn_walla";
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
			}
			else
			{
				soundloopemitter(self.script_sound, self.origin);
			}
			started = !started;
		}
	}
}

