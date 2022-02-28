// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_monkey;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_audio_zhd;
#using scripts\zm\_zm_pack_a_punch;
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
#using scripts\zm\_zm_trap_fire;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_black_hole_bomb;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_cosmodrome_amb;
#using scripts\zm\zm_cosmodrome_ffotd;
#using scripts\zm\zm_cosmodrome_fx;

#namespace zm_cosmodrome;

/*
	Name: opt_in
	Namespace: zm_cosmodrome
	Checksum: 0xBC6FD27B
	Offset: 0x1E08
	Size: 0x1C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec opt_in()
{
	level.aat_in_use = 1;
	level.bgb_in_use = 1;
}

/*
	Name: main
	Namespace: zm_cosmodrome
	Checksum: 0x1D5A3D1A
	Offset: 0x1E30
	Size: 0x28C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	zm_cosmodrome_ffotd::main_start();
	level.default_game_mode = "zclassic";
	level.default_start_location = "default";
	level._power_on = 0;
	level.rocket_num = 0;
	level.var_f2fba834 = 0;
	level.var_90e9447c = 0;
	level.intro_done = 0;
	include_weapons();
	callback::on_localclient_connect(&function_82a94b2c);
	register_client_fields();
	zm_cosmodrome_fx::main();
	level thread zm_cosmodrome_amb::main();
	level.setupcustomcharacterexerts = &setup_personality_character_exerts;
	visionset_mgr::register_visionset_info("zm_cosmodrome_no_power", 21000, 31, undefined, "zombie_cosmodrome_nopower");
	visionset_mgr::register_visionset_info("zm_cosmodrome_power_antic", 21000, 31, undefined, "zombie_cosmodrome_power_antic");
	visionset_mgr::register_visionset_info("zm_cosmodrome_power_flare", 21000, 31, undefined, "zombie_cosmodrome_power_flare");
	visionset_mgr::register_visionset_info("zm_cosmodrome_monkey_on", 21000, 31, undefined, "zombie_cosmodrome_monkey");
	visionset_mgr::register_visionset_info("zm_cosmodrome_monkey_off", 21000, 31, undefined, "zombie_cosmodrome_monkey");
	load::main();
	level thread setup_fog();
	level init_cosmodrome_box_screens();
	util::waitforclient(0);
	level thread radar_dish_init();
	level.nml_spark_pull = struct::get("nml_spark_pull", "targetname");
	function_6ac83719();
	level thread function_d87a7dcc();
	zm_cosmodrome_ffotd::main_end();
}

/*
	Name: function_82a94b2c
	Namespace: zm_cosmodrome
	Checksum: 0x1BF86409
	Offset: 0x20C8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_82a94b2c(localclientnum)
{
	setsaveddvar("phys_buoyancy", 1);
	level thread function_85c8e13c(localclientnum);
}

/*
	Name: function_85c8e13c
	Namespace: zm_cosmodrome
	Checksum: 0x5DACB551
	Offset: 0x2118
	Size: 0xA32
	Parameters: 1
	Flags: Linked
*/
function function_85c8e13c(localclientnum)
{
	self endon(#"disconnect");
	while(true)
	{
		var_f4570d42 = randomint(5);
		switch(var_f4570d42)
		{
			case 0:
			{
				exploder::exploder("fxexp_4100", localclientnum);
				setukkoscriptindex(localclientnum, 2, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 3, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 4, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 5, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 4, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 3, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 4, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 3, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 4, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 6, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 4, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 5, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 6, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 7, 1);
				wait(0.05);
				break;
			}
			case 1:
			{
				exploder::exploder("fxexp_4200", localclientnum);
				setukkoscriptindex(localclientnum, 8, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 9, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 10, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 11, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 10, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 11, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 12, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 13, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 14, 1);
				wait(0.1);
				break;
			}
			case 2:
			{
				exploder::exploder("fxexp_4300", localclientnum);
				setukkoscriptindex(localclientnum, 15, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 16, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 17, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 18, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 19, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 20, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 21, 1);
				wait(0.1);
				break;
			}
			case 3:
			{
				exploder::exploder("fxexp_4400", localclientnum);
				setukkoscriptindex(localclientnum, 22, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 23, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 24, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 25, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 26, 1);
				wait(0.1);
				break;
			}
			case 4:
			{
				exploder::exploder("fxexp_4500", localclientnum);
				setukkoscriptindex(localclientnum, 29, 1);
				wait(0.15);
				setukkoscriptindex(localclientnum, 30, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 29, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 31, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 30, 1);
				wait(0.15);
				setukkoscriptindex(localclientnum, 29, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 30, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 29, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 31, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 27, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 28, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 29, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 30, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 29, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 31, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 30, 1);
				wait(0.15);
				setukkoscriptindex(localclientnum, 29, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 30, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 29, 1);
				wait(0.1);
				setukkoscriptindex(localclientnum, 31, 1);
				wait(0.05);
				setukkoscriptindex(localclientnum, 32, 1);
				wait(0.05);
				break;
			}
			default:
			{
				break;
			}
		}
		setukkoscriptindex(localclientnum, 1, 1);
		n_wait_time = randomintrange(2, 4);
		wait(n_wait_time);
	}
}

/*
	Name: function_6ac83719
	Namespace: zm_cosmodrome
	Checksum: 0x3AD0C86
	Offset: 0x2B58
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_6ac83719()
{
	visionset_mgr::init_fog_vol_to_visionset_monitor("zombie_cosmodrome", 0.01);
	visionset_mgr::fog_vol_to_visionset_set_suffix("");
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome");
}

/*
	Name: function_c07d3f2c
	Namespace: zm_cosmodrome
	Checksum: 0x713CFB03
	Offset: 0x2BC0
	Size: 0xD0
	Parameters: 7
	Flags: Linked
*/
function function_c07d3f2c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		player = getlocalplayers()[localclientnum];
		player set_fog("normal");
		visionset_mgr::fog_vol_to_visionset_set_suffix("_nopower");
		visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", 8.5);
		level.intro_done = 1;
	}
}

/*
	Name: function_d0429093
	Namespace: zm_cosmodrome
	Checksum: 0xC240C67A
	Offset: 0x2C98
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function function_d0429093(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		if(isdefined(level.intro_done) && !level.intro_done)
		{
			level.intro_done = 1;
			player = getlocalplayers()[localclientnum];
			player set_fog("normal");
			wait(0.01);
			visionset_mgr::fog_vol_to_visionset_set_suffix("_nopower");
			visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", 0.01);
		}
	}
}

/*
	Name: function_e470dce
	Namespace: zm_cosmodrome
	Checksum: 0xC71C2EAD
	Offset: 0x2D90
	Size: 0x16C
	Parameters: 7
	Flags: Linked
*/
function function_e470dce(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		level.var_f2fba834 = 1;
		if(isdefined(level._power_on) && !level._power_on)
		{
			level._power_on = 1;
			level thread setup_lander_screens(localclientnum);
		}
		player = getlocalplayers()[localclientnum];
		player earthquake(0.2, 5, player.origin, 20000);
		playsound(0, "zmb_ape_intro_sonicboom_fnt", (0, 0, 0));
		level._effect["eye_glow"] = level._effect["monkey_eye_glow"];
		e_player = getlocalplayers()[localclientnum];
		e_player set_fog("monkey");
	}
}

/*
	Name: function_87f08b47
	Namespace: zm_cosmodrome
	Checksum: 0xAE75706D
	Offset: 0x2F08
	Size: 0x136
	Parameters: 7
	Flags: Linked
*/
function function_87f08b47(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		level.var_f2fba834 = 0;
		if(isdefined(level._power_on) && !level._power_on)
		{
			level._power_on = 1;
			level thread setup_lander_screens(localclientnum);
		}
		player = getlocalplayers()[localclientnum];
		player set_fog("normal");
		wait(0.01);
		visionset_mgr::fog_vol_to_visionset_set_suffix("_poweron");
		visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", 0.01);
		level._effect["eye_glow"] = level._effect["zombie_eye_glow"];
	}
}

/*
	Name: function_2f143630
	Namespace: zm_cosmodrome
	Checksum: 0x88099171
	Offset: 0x3048
	Size: 0xA4
	Parameters: 5
	Flags: Linked
*/
function function_2f143630(var_54168c72, var_f8308617, n_wait, var_2e141209, var_862916dc)
{
	visionset_mgr::fog_vol_to_visionset_set_suffix(var_54168c72);
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", var_f8308617);
	wait(n_wait);
	visionset_mgr::fog_vol_to_visionset_set_suffix(var_2e141209);
	visionset_mgr::fog_vol_to_visionset_set_info(0, "zombie_cosmodrome", var_862916dc);
}

/*
	Name: function_ea758913
	Namespace: zm_cosmodrome
	Checksum: 0x79FA4513
	Offset: 0x30F8
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_ea758913()
{
	if(isdefined(level.var_f2fba834) && level.var_f2fba834 && isdefined(level.var_90e9447c) && !level.var_90e9447c)
	{
		level.var_90e9447c = 1;
		self function_2f143630("_monkey_flare", 0.5, 0.5, "_monkey", 3);
		level.var_90e9447c = 0;
	}
}

/*
	Name: register_client_fields
	Namespace: zm_cosmodrome
	Checksum: 0x85555357
	Offset: 0x3188
	Size: 0x754
	Parameters: 0
	Flags: Linked
*/
function register_client_fields()
{
	clientfield::register("scriptmover", "zombie_has_eyes", 21000, 1, "int", &zm::zombie_eyes_clientfield_cb, 0, 0);
	clientfield::register("actor", "COSMO_SOULPULL", 21000, 1, "int", &actor_flag_soulpull_handler, 0, 0);
	clientfield::register("scriptmover", "COSMO_ROCKET_FX", 21000, 1, "int", &rocket_fx, 0, 0);
	clientfield::register("scriptmover", "COSMO_MONKEY_LANDER_FX", 21000, 1, "int", &monkey_lander_fx, 0, 0);
	clientfield::register("world", "COSMO_EGG_SAM_ANGRY", 21000, 1, "int", &samantha_is_angry, 0, 0);
	clientfield::register("scriptmover", "COSMO_LANDER_ENGINE_FX", 21000, 1, "int", &lander_engine_fx, 0, 0);
	clientfield::register("allplayers", "COSMO_PLAYER_LANDER_FOG", 21000, 1, "int", &player_lander_fog, 0, 0);
	clientfield::register("scriptmover", "COSMO_LANDER_MOVE_FX", 21000, 1, "int", &lander_move_fx, 0, 0);
	clientfield::register("scriptmover", "COSMO_LANDER_RUMBLE_AND_QUAKE", 21000, 1, "int", &lander_rumble_and_quake, 0, 0);
	clientfield::register("world", "COSMO_LANDER_STATUS_LIGHTS", 21000, 2, "int", &function_32db5393, 0, 0);
	clientfield::register("world", "COSMO_LANDER_STATION", 21000, 3, "int", &function_446c53e5, 0, 0);
	clientfield::register("world", "COSMO_LANDER_DEST", 21000, 3, "int", &function_f6ffc831, 0, 0);
	clientfield::register("world", "COSMO_LANDER_CATWALK_BAY", 21000, 3, "int", &function_89e03497, 0, 0);
	clientfield::register("world", "COSMO_LANDER_BASE_ENTRY_BAY", 21000, 3, "int", &function_429d7872, 0, 0);
	clientfield::register("world", "COSMO_LANDER_CENTRIFUGE_BAY", 21000, 3, "int", &function_7eaa1812, 0, 0);
	clientfield::register("world", "COSMO_LANDER_STORAGE_BAY", 21000, 3, "int", &function_686d40af, 0, 0);
	clientfield::register("scriptmover", "COSMO_LAUNCH_PANEL_CENTRIFUGE_STATUS", 21000, 1, "int", &launch_panel_centrifuge_status, 0, 0);
	clientfield::register("scriptmover", "COSMO_LAUNCH_PANEL_BASEENTRY_STATUS", 21000, 1, "int", &launch_panel_baseentry_status, 0, 0);
	clientfield::register("scriptmover", "COSMO_LAUNCH_PANEL_STORAGE_STATUS", 21000, 1, "int", &launch_panel_storage_status, 0, 0);
	clientfield::register("scriptmover", "COSMO_LAUNCH_PANEL_CATWALK_STATUS", 21000, 1, "int", &launch_panel_catwalk_status, 0, 0);
	clientfield::register("scriptmover", "COSMO_CENTRIFUGE_RUMBLE", 21000, 1, "int", &centrifuge_rumble_control, 0, 0);
	clientfield::register("scriptmover", "COSMO_CENTRIFUGE_LIGHTS", 21000, 1, "int", &centrifuge_warning_lights_init, 0, 0);
	clientfield::register("world", "COSMO_VISIONSET_BEGIN", 21000, 1, "int", &function_c07d3f2c, 0, 0);
	clientfield::register("world", "COSMO_VISIONSET_NOPOWER", 21000, 1, "int", &function_d0429093, 0, 0);
	clientfield::register("world", "COSMO_VISIONSET_POWERON", 21000, 1, "int", &function_87f08b47, 0, 0);
	clientfield::register("world", "COSMO_VISIONSET_MONKEY", 21000, 1, "int", &function_e470dce, 0, 0);
}

/*
	Name: function_d87a7dcc
	Namespace: zm_cosmodrome
	Checksum: 0xC4372349
	Offset: 0x38E8
	Size: 0x16A
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
			if(var_bd7ba30)
			{
				level notify(#"power_controlled_light");
			}
			level util::waittill_any("power_on", "pwr", "ZPO");
		}
		level._power_on = 1;
		level notify(#"power_controlled_light");
		players = getlocalplayers();
		for(i = 0; i < players.size; i++)
		{
			level thread setup_lander_screens(i);
		}
		level function_2f143630("_powerup", 0.1, 1, "_poweron", 2.5);
		level util::waittill_any("pwo", "ZPOff");
		var_bd7ba30 = 1;
	}
}

/*
	Name: include_weapons
	Namespace: zm_cosmodrome
	Checksum: 0x6BD479AB
	Offset: 0x3A60
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_cosmodrome_weapons.csv", 1);
}

/*
	Name: radar_dish_init
	Namespace: zm_cosmodrome
	Checksum: 0x43888848
	Offset: 0x3A90
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function radar_dish_init()
{
	radar_dish = getentarray(0, "zombie_cosmodrome_radar_dish", "targetname");
	if(isdefined(radar_dish))
	{
		for(i = 0; i < radar_dish.size; i++)
		{
			radar_dish[i] thread radar_dish_rotate();
		}
	}
}

/*
	Name: radar_dish_rotate
	Namespace: zm_cosmodrome
	Checksum: 0xFF82D4B5
	Offset: 0x3B20
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function radar_dish_rotate()
{
	wait(0.1);
	while(true)
	{
		self rotateyaw(360, 10);
		self waittill(#"rotatedone");
	}
}

/*
	Name: perk_wire_fx_client
	Namespace: zm_cosmodrome
	Checksum: 0x1B4BD602
	Offset: 0x3B70
	Size: 0x20E
	Parameters: 2
	Flags: None
*/
function perk_wire_fx_client(client_num, done_notify)
{
	/#
		println("" + client_num);
	#/
	targ = struct::get(self.target, "targetname");
	if(!isdefined(targ))
	{
		return;
	}
	mover = spawn(client_num, targ.origin, "script_model");
	mover setmodel("tag_origin");
	fx = playfxontag(client_num, level._effect["wire_spark"], mover, "tag_origin");
	while(isdefined(targ))
	{
		if(isdefined(targ.target))
		{
			/#
				println((("" + client_num) + "") + targ.target);
			#/
			target = struct::get(targ.target, "targetname");
			mover moveto(target.origin, 0.5);
			wait(0.5);
			targ = target;
		}
		else
		{
			break;
		}
	}
	level notify(#"spark_done");
	mover delete();
	level notify(done_notify);
}

/*
	Name: tele_spark_audio_mover
	Namespace: zm_cosmodrome
	Checksum: 0x2AD100BD
	Offset: 0x3D88
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function tele_spark_audio_mover(fake_ent)
{
	level endon(#"spark_done");
	while(true)
	{
		wait(0.05);
	}
}

/*
	Name: actor_flag_soulpull_handler
	Namespace: zm_cosmodrome
	Checksum: 0xE15CC649
	Offset: 0x3DC0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function actor_flag_soulpull_handler(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self thread soul_pull(localclientnum);
	}
}

/*
	Name: soul_pull
	Namespace: zm_cosmodrome
	Checksum: 0xF1EC976F
	Offset: 0x3E28
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function soul_pull(client_num)
{
	/#
		println((("" + self.origin) + "") + level.nml_spark_pull.origin);
	#/
	mover = spawn(client_num, self.origin, "script_model");
	mover setmodel("tag_origin");
	fx = playfxontag(client_num, level._effect["soul_spark"], mover, "tag_origin");
	wait(1);
	mover moveto(level.nml_spark_pull.origin, 3);
	wait(3);
	mover delete();
}

/*
	Name: init_cosmodrome_box_screens
	Namespace: zm_cosmodrome
	Checksum: 0xBB09FE26
	Offset: 0x3F68
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function init_cosmodrome_box_screens()
{
	level._cosmodrome_fire_sale = array("p7_zm_asc_cam_monitor_screen_fsale1", "p7_zm_asc_cam_monitor_screen_fsale2");
	level.magic_box_tv_off = array("p7_zm_asc_cam_monitor_screen_off");
	level.magic_box_tv_on = array("p7_zm_asc_cam_monitor_screen_on");
	level.magic_box_tv_start_1 = array("p7_zm_asc_cam_monitor_screen_obsdeck");
	level.magic_box_tv_roof_connector = array("p7_zm_asc_cam_monitor_screen_labs");
	level.magic_box_tv_centrifuge = array("p7_zm_asc_cam_monitor_screen_centrifuge");
	level.magic_box_tv_base_entry = array("p7_zm_asc_cam_monitor_screen_enter");
	level.magic_box_tv_storage = array("p7_zm_asc_cam_monitor_screen_storage");
	level.magic_box_tv_catwalks = array("p7_zm_asc_cam_monitor_screen_catwalk");
	level.magic_box_tv_north_pass = array("p7_zm_asc_cam_monitor_screen_topack");
	level.magic_box_tv_warehouse = array("p7_zm_asc_cam_monitor_screen_warehouse");
	level.magic_box_tv_random = array("p7_zm_asc_cam_monitor_screen_logo");
	level._box_locations = array(level.magic_box_tv_start_1, level.magic_box_tv_roof_connector, level.magic_box_tv_centrifuge, level.magic_box_tv_base_entry, level.magic_box_tv_storage, level.magic_box_tv_catwalks, level.magic_box_tv_north_pass, level.magic_box_tv_warehouse);
	level._custom_box_monitor = &cosmodrome_screen_switch;
}

/*
	Name: cosmodrome_screen_switch
	Namespace: zm_cosmodrome
	Checksum: 0x42D04C78
	Offset: 0x4170
	Size: 0x186
	Parameters: 3
	Flags: Linked
*/
function cosmodrome_screen_switch(client_num, state, oldstate)
{
	cosmodrome_tv_init(client_num);
	if(state == "n")
	{
		if(level._power_on == 0)
		{
			screen_to_display = level.magic_box_tv_off;
		}
		else
		{
			screen_to_display = level.magic_box_tv_on;
		}
	}
	else
	{
		if(state == "f")
		{
			screen_to_display = level._cosmodrome_fire_sale;
		}
		else
		{
			array_number = int(state);
			screen_to_display = level._box_locations[array_number];
		}
	}
	stop_notify = "stop_tv_swap";
	for(i = 0; i < level.cosmodrome_tvs[client_num].size; i++)
	{
		tele = level.cosmodrome_tvs[client_num][i];
		tele notify(stop_notify);
		wait(0.2);
		tele thread magic_box_screen_swap(screen_to_display, "stop_tv_swap");
		tele thread play_magic_box_tv_audio(state);
	}
}

/*
	Name: cosmodrome_tv_init
	Namespace: zm_cosmodrome
	Checksum: 0xBD2C2496
	Offset: 0x4300
	Size: 0xE6
	Parameters: 1
	Flags: Linked
*/
function cosmodrome_tv_init(client_num)
{
	if(!isdefined(level.cosmodrome_tvs))
	{
		level.cosmodrome_tvs = [];
	}
	if(isdefined(level.cosmodrome_tvs[client_num]))
	{
		return;
	}
	level.cosmodrome_tvs[client_num] = getentarray(client_num, "model_cosmodrome_box_screens", "targetname");
	for(i = 0; i < level.cosmodrome_tvs[client_num].size; i++)
	{
		tele = level.cosmodrome_tvs[client_num][i];
		tele setmodel(level.magic_box_tv_off[0]);
		wait(0.1);
	}
}

/*
	Name: magic_box_screen_swap
	Namespace: zm_cosmodrome
	Checksum: 0xC3B74BFB
	Offset: 0x43F0
	Size: 0xF0
	Parameters: 2
	Flags: Linked
*/
function magic_box_screen_swap(model_array, endon_notify)
{
	self endon(endon_notify);
	while(true)
	{
		for(i = 0; i < model_array.size; i++)
		{
			self setmodel(model_array[i]);
			wait(3);
		}
		if(3 > randomint(100) && isdefined(level.magic_box_tv_random))
		{
			self setmodel(level.magic_box_tv_random[randomint(level.magic_box_tv_random.size)]);
			wait(2);
		}
		wait(1);
	}
}

/*
	Name: play_magic_box_tv_audio
	Namespace: zm_cosmodrome
	Checksum: 0xDD23B5A4
	Offset: 0x44E8
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function play_magic_box_tv_audio(state)
{
	self.alias = "amb_tv_static";
	if(state == "n")
	{
		if(level._power_on == 0)
		{
			self.alias = undefined;
		}
		else
		{
			self.alias = "amb_tv_static";
		}
	}
	else
	{
		if(state == "f")
		{
		}
		else
		{
			self.alias = "amb_tv_static";
		}
	}
	if(!isdefined(self.alias))
	{
	}
	else
	{
		self playloopsound(self.alias, 0.5);
	}
}

/*
	Name: function_89e03497
	Namespace: zm_cosmodrome
	Checksum: 0xA80DDED4
	Offset: 0x45A8
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_89e03497(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level function_18769931(localclientnum, newval, "catwalk_zip_door");
}

/*
	Name: function_429d7872
	Namespace: zm_cosmodrome
	Checksum: 0xF82369D3
	Offset: 0x4618
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_429d7872(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level function_18769931(localclientnum, newval, "base_entry_zip_door");
}

/*
	Name: function_7eaa1812
	Namespace: zm_cosmodrome
	Checksum: 0x75A39D3E
	Offset: 0x4688
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_7eaa1812(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level function_18769931(localclientnum, newval, "centrifuge_zip_door");
}

/*
	Name: function_686d40af
	Namespace: zm_cosmodrome
	Checksum: 0x9E4F3075
	Offset: 0x46F8
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_686d40af(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level function_18769931(localclientnum, newval, "storage_zip_door");
}

/*
	Name: function_18769931
	Namespace: zm_cosmodrome
	Checksum: 0x929F070A
	Offset: 0x4768
	Size: 0x18C
	Parameters: 3
	Flags: Linked
*/
function function_18769931(localclientnum, n_state, door_name)
{
	sound_count = 0;
	doors = getentarray(localclientnum, door_name, "targetname");
	for(i = 0; i < doors.size; i++)
	{
		var_1f9cab23 = doors[i] function_b2c64ce4(n_state);
		v_move_pos = doors[i] function_b27e98c0(var_1f9cab23);
		b_move = doors[i] function_53c16d30(v_move_pos);
		if(b_move)
		{
			doors[i] moveto(v_move_pos, 1);
			if(sound_count == 0)
			{
				playsound(0, "zmb_lander_door", doors[i].origin);
				sound_count++;
			}
		}
	}
}

/*
	Name: function_b2c64ce4
	Namespace: zm_cosmodrome
	Checksum: 0xD7589C4C
	Offset: 0x4900
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function function_b2c64ce4(n_state)
{
	switch(n_state)
	{
		case 1:
		{
			return true;
		}
		case 2:
		{
			if(!isdefined(self.script_noteworthy))
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		case 3:
		{
			return false;
		}
		case 0:
		{
			if(!isdefined(self.script_noteworthy))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}

/*
	Name: function_b27e98c0
	Namespace: zm_cosmodrome
	Checksum: 0x9C4D7931
	Offset: 0x4988
	Size: 0xCE
	Parameters: 1
	Flags: Linked
*/
function function_b27e98c0(var_2291984a)
{
	open_pos = struct::get(self.target, "targetname");
	start_pos = struct::get(open_pos.target, "targetname");
	if(!isdefined(self.script_noteworthy))
	{
		if(var_2291984a)
		{
			return start_pos.origin;
		}
		return open_pos.origin;
	}
	if(var_2291984a)
	{
		return open_pos.origin;
	}
	return start_pos.origin;
}

/*
	Name: function_53c16d30
	Namespace: zm_cosmodrome
	Checksum: 0xBECAF23C
	Offset: 0x4A60
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function function_53c16d30(v_pos)
{
	if(self.origin != v_pos)
	{
		return true;
	}
	return false;
}

/*
	Name: rocket_fx
	Namespace: zm_cosmodrome
	Checksum: 0x476904E8
	Offset: 0x4A98
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function rocket_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self.var_a13e8509 = playfxontag(localclientnum, level._effect["rocket_blast_trail"], self, "tag_engine");
	}
	else if(isdefined(self.var_a13e8509))
	{
		killfx(localclientnum, self.var_a13e8509);
	}
}

/*
	Name: lander_engine_fx
	Namespace: zm_cosmodrome
	Checksum: 0xBE5A646
	Offset: 0x4B50
	Size: 0x3CC
	Parameters: 7
	Flags: Linked
*/
function lander_engine_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	player = getlocalplayers()[localclientnum];
	if(newval)
	{
		if(isdefined(player.lander_fx))
		{
			stopfx(localclientnum, player.lander_fx);
			stopfx(localclientnum, player.lander_fx1);
			stopfx(localclientnum, player.lander_fx2);
			stopfx(localclientnum, player.lander_fx3);
			stopfx(localclientnum, player.lander_fx4);
		}
		player.lander_fx = playfxontag(localclientnum, level._effect["lunar_lander_thruster_leg"], self, "tag_engine01");
		setfxignorepause(localclientnum, player.lander_fx, 1);
		player.lander_fx1 = playfxontag(localclientnum, level._effect["lunar_lander_thruster_leg"], self, "tag_engine02");
		setfxignorepause(localclientnum, player.lander_fx1, 1);
		player.lander_fx2 = playfxontag(localclientnum, level._effect["lunar_lander_thruster_leg"], self, "tag_engine03");
		setfxignorepause(localclientnum, player.lander_fx2, 1);
		player.lander_fx3 = playfxontag(localclientnum, level._effect["lunar_lander_thruster_leg"], self, "tag_engine04");
		setfxignorepause(localclientnum, player.lander_fx3, 1);
		player.lander_fx4 = playfxontag(localclientnum, level._effect["lunar_lander_thruster_bellow"], self, "tag_bellow");
		setfxignorepause(localclientnum, player.lander_fx4, 1);
		self thread start_ground_sounds();
	}
	else if(isdefined(player.lander_fx))
	{
		stopfx(localclientnum, player.lander_fx);
		stopfx(localclientnum, player.lander_fx1);
		stopfx(localclientnum, player.lander_fx2);
		stopfx(localclientnum, player.lander_fx3);
		stopfx(localclientnum, player.lander_fx4);
	}
}

/*
	Name: start_ground_sounds
	Namespace: zm_cosmodrome
	Checksum: 0xA3CFF149
	Offset: 0x4F28
	Size: 0x248
	Parameters: 0
	Flags: Linked
*/
function start_ground_sounds()
{
	self endon(#"entityshutdown");
	level endon(#"save_restore");
	self notify(#"start_ground_sounds");
	self.stop_ground_sounds = 0;
	trace = undefined;
	self.ground_sound_ent = spawn(0, (0, 0, 0), "script_origin");
	self.ground_sound_ent thread function_fb377b79();
	pre_origin = vectorscale((1, 1, 1), 100000);
	while(isdefined(self))
	{
		wait(0.15);
		if(isdefined(self.stop_ground_sounds) && self.stop_ground_sounds)
		{
			if(isdefined(self.ground_sound_ent))
			{
				self.ground_sound_ent stoploopsound(2);
			}
			return;
		}
		if(distancesquared(pre_origin, self gettagorigin("tag_bellow")) < 144)
		{
			continue;
		}
		pre_origin = self gettagorigin("tag_bellow");
		trace = bullettrace(self gettagorigin("tag_bellow"), self gettagorigin("tag_bellow") - vectorscale((0, 0, 1), 100000), 0, undefined);
		if(!isdefined(trace))
		{
			continue;
		}
		if(!isdefined(trace["position"]))
		{
			self.ground_sound_ent stoploopsound(2);
			continue;
		}
		self.ground_sound_ent.origin = trace["position"] + vectorscale((0, 0, 1), 30);
		self.ground_sound_ent playloopsound("zmb_lander_ground_sounds", 3);
	}
}

/*
	Name: function_fb377b79
	Namespace: zm_cosmodrome
	Checksum: 0x91F5669C
	Offset: 0x5178
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_fb377b79()
{
	self endon(#"entityshutdown");
	level waittill(#"demo_jump");
	self delete();
}

/*
	Name: end_ground_sounds
	Namespace: zm_cosmodrome
	Checksum: 0x87EF6250
	Offset: 0x51B8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function end_ground_sounds()
{
	self endon(#"start_ground_sounds");
	self.stop_ground_sounds = 1;
	wait(3);
	if(isdefined(self) && isdefined(self.ground_sound_ent))
	{
		self.ground_sound_ent delete();
	}
}

/*
	Name: get_random_spot_in_player_view
	Namespace: zm_cosmodrome
	Checksum: 0xC2265FA3
	Offset: 0x5218
	Size: 0x1CC
	Parameters: 4
	Flags: None
*/
function get_random_spot_in_player_view(fwd_min, fwd_max, side_min, side_max)
{
	fwd = anglestoforward(self.angles);
	scale = randomintrange(fwd_min, fwd_max);
	fwd = (fwd[0] * scale, fwd[1] * scale, fwd[2] * scale);
	if(randomint(100) > 50)
	{
		side = anglestoright(self.angles);
	}
	else
	{
		side = anglestoright(self.angles) * -1;
	}
	scale = randomintrange(side_min, side_max);
	side = (side[0] * scale, side[1] * scale, side[2] * scale);
	point = (self.origin + fwd) + side;
	trace = bullettrace(point, point + (vectorscale((0, 0, -1), 10000)), 0, undefined);
	return trace["position"];
}

/*
	Name: debris_crash_and_burn
	Namespace: zm_cosmodrome
	Checksum: 0xC6274AA4
	Offset: 0x53F0
	Size: 0x184
	Parameters: 3
	Flags: None
*/
function debris_crash_and_burn(spot, client, player)
{
	playfxontag(client, level._effect["debris_trail"], self, "tag_origin");
	self moveto(spot, 3.1);
	for(i = 0; i < 10; i++)
	{
		self rotateto((randomint(360), randomint(360), randomint(360)), 0.3);
		wait(0.3);
	}
	wait(3.1);
	player earthquake(0.4, 0.5, self.origin, 1200);
	playfx(client, level._effect["debris_hit"], self.origin);
	wait(1);
	self delete();
}

/*
	Name: setup_lander_screens
	Namespace: zm_cosmodrome
	Checksum: 0x5EEE3233
	Offset: 0x5580
	Size: 0xA6
	Parameters: 1
	Flags: Linked
*/
function setup_lander_screens(clientnum)
{
	screens = getentarray(clientnum, "lander_screens", "targetname");
	for(i = 0; i < screens.size; i++)
	{
		if(isdefined(screens[i].model))
		{
			screens[i] setmodel("p7_zm_asc_control_panel_lunar");
		}
	}
}

/*
	Name: lander_at_station
	Namespace: zm_cosmodrome
	Checksum: 0xFA38BB0E
	Offset: 0x5630
	Size: 0x366
	Parameters: 2
	Flags: Linked
*/
function lander_at_station(station, clientnum)
{
	self util::waittill_dobj(clientnum);
	if(isdefined(self.panel_fx))
	{
		stopfx(clientnum, self.panel_fx);
	}
	if(isdefined(self.lander_fx))
	{
		stopfx(clientnum, self.lander_fx);
	}
	switch(station)
	{
		case 3:
		{
			self.panel_fx = playfxontag(clientnum, level._effect["panel_green"], self, "tag_location_3");
			self.lander_location = self gettagorigin("tag_location_3");
			self.lander_location_angles = self gettagangles("tag_location_3");
			setfxignorepause(clientnum, self.panel_fx, 1);
			break;
		}
		case 1:
		{
			self.panel_fx = playfxontag(clientnum, level._effect["panel_green"], self, "tag_location_1");
			self.lander_location = self gettagorigin("tag_location_1");
			self.lander_location_angles = self gettagangles("tag_location_1");
			setfxignorepause(clientnum, self.panel_fx, 1);
			break;
		}
		case 2:
		{
			self.panel_fx = playfxontag(clientnum, level._effect["panel_green"], self, "tag_location_2");
			self.lander_location = self gettagorigin("tag_location_2");
			self.lander_location_angles = self gettagangles("tag_location_2");
			setfxignorepause(clientnum, self.panel_fx, 1);
			break;
		}
		case 4:
		{
			self.panel_fx = playfxontag(clientnum, level._effect["panel_green"], self, "tag_home");
			self.lander_location = self gettagorigin("tag_home");
			self.lander_location_angles = self gettagangles("tag_home");
			setfxignorepause(clientnum, self.panel_fx, 1);
			break;
		}
	}
}

/*
	Name: lander_move_fx
	Namespace: zm_cosmodrome
	Checksum: 0x36A6B08F
	Offset: 0x59A0
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function lander_move_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		player = getlocalplayers()[localclientnum];
		player thread lander_station_move_lander_marker(localclientnum);
	}
}

/*
	Name: lander_station_move_lander_marker
	Namespace: zm_cosmodrome
	Checksum: 0x7938D34E
	Offset: 0x5A30
	Size: 0x306
	Parameters: 1
	Flags: Linked
*/
function lander_station_move_lander_marker(localclientnum)
{
	dest = undefined;
	x = localclientnum;
	screens = getentarray(x, "lander_screens", "targetname");
	for(i = 0; i < screens.size; i++)
	{
		screen = screens[i];
		if(isdefined(screen.lander_fx))
		{
			stopfx(x, screen.lander_fx);
		}
		if(isdefined(screen.panel_fx))
		{
			stopfx(x, screen.panel_fx);
		}
		if(!isdefined(screen.lander_fx_ent))
		{
			screen.lander_fx_ent = spawn(x, screen.lander_location, "script_origin");
			screen.lander_fx_ent setmodel("tag_origin");
			screen.lander_fx_ent.angles = screen.lander_location_angles;
		}
		screen.lander_fx = playfxontag(x, level._effect["panel_green"], screen.lander_fx_ent, "tag_origin");
		setfxignorepause(x, screen.lander_fx, 1);
		switch(level.lander_dest_station)
		{
			case "base":
			{
				dest = screen gettagorigin("tag_location_3");
				break;
			}
			case "storage":
			{
				dest = screen gettagorigin("tag_location_1");
				break;
			}
			case "centrifuge":
			{
				dest = screen gettagorigin("tag_home");
				break;
			}
			case "catwalk":
			{
				dest = screen gettagorigin("tag_location_2");
				break;
			}
		}
		screen.lander_fx_ent moveto(dest, 10);
	}
}

/*
	Name: function_446c53e5
	Namespace: zm_cosmodrome
	Checksum: 0xD10401BB
	Offset: 0x5D40
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function function_446c53e5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	screens = getentarray(localclientnum, "lander_screens", "targetname");
	for(i = 0; i < screens.size; i++)
	{
		screens[i] thread lander_at_station(newval, localclientnum);
	}
}

/*
	Name: function_32db5393
	Namespace: zm_cosmodrome
	Checksum: 0xBB11744C
	Offset: 0x5E08
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function function_32db5393(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		level zm_cosmodrome_fx::toggle_lander_lights("red", localclientnum);
	}
	else if(newval == 2)
	{
		level zm_cosmodrome_fx::toggle_lander_lights("green", localclientnum);
	}
}

/*
	Name: function_f6ffc831
	Namespace: zm_cosmodrome
	Checksum: 0xA7C6A36F
	Offset: 0x5EB0
	Size: 0xBE
	Parameters: 7
	Flags: Linked
*/
function function_f6ffc831(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	switch(newval)
	{
		case 2:
		{
			level.lander_dest_station = "catwalk";
			break;
		}
		case 3:
		{
			level.lander_dest_station = "base";
			break;
		}
		case 4:
		{
			level.lander_dest_station = "centrifuge";
			break;
		}
		case 1:
		{
			level.lander_dest_station = "storage";
			break;
		}
	}
}

/*
	Name: launch_panel_centrifuge_status
	Namespace: zm_cosmodrome
	Checksum: 0x259F582C
	Offset: 0x5F78
	Size: 0x14C
	Parameters: 7
	Flags: Linked
*/
function launch_panel_centrifuge_status(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		if(isdefined(self.centrifuge_status))
		{
			stopfx(localclientnum, self.centrifuge_status);
		}
		self.centrifuge_status = playfxontag(localclientnum, level._effect["panel_red"], self, "tag_home");
		setfxignorepause(localclientnum, self.centrifuge_status, 1);
	}
	else
	{
		if(isdefined(self.centrifuge_status))
		{
			stopfx(localclientnum, self.centrifuge_status);
		}
		self.centrifuge_status = playfxontag(localclientnum, level._effect["panel_green"], self, "tag_home");
		setfxignorepause(localclientnum, self.centrifuge_status, 1);
	}
}

/*
	Name: launch_panel_storage_status
	Namespace: zm_cosmodrome
	Checksum: 0xD9A399A
	Offset: 0x60D0
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function launch_panel_storage_status(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		if(localclientnum == 0)
		{
			level.rocket_num++;
		}
		level thread rocket_launch_display(localclientnum);
	}
}

/*
	Name: launch_panel_baseentry_status
	Namespace: zm_cosmodrome
	Checksum: 0x760147DC
	Offset: 0x6150
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function launch_panel_baseentry_status(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		if(localclientnum == 0)
		{
			level.rocket_num++;
		}
		level thread rocket_launch_display(localclientnum);
	}
}

/*
	Name: launch_panel_catwalk_status
	Namespace: zm_cosmodrome
	Checksum: 0xD33B1D3B
	Offset: 0x61D0
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function launch_panel_catwalk_status(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		if(localclientnum == 0)
		{
			level.rocket_num++;
		}
		level thread rocket_launch_display(localclientnum);
	}
}

/*
	Name: rocket_launch_display
	Namespace: zm_cosmodrome
	Checksum: 0xECFF03A
	Offset: 0x6250
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function rocket_launch_display(localclientnum)
{
	wait(1);
	rocket_screens = getentarray(localclientnum, "rocket_launch_sign", "targetname");
	model = rocket_screens[0].model;
	switch(level.rocket_num)
	{
		case 1:
		{
			model = "p7_zm_asc_sign_rocket_02";
			break;
		}
		case 2:
		{
			model = "p7_zm_asc_sign_rocket_03";
			break;
		}
		case 3:
		{
			model = "p7_zm_asc_sign_rocket_04";
			break;
		}
	}
	array::thread_all(rocket_screens, &update_rocket_display, model);
}

/*
	Name: update_rocket_display
	Namespace: zm_cosmodrome
	Checksum: 0x1409F8E6
	Offset: 0x6348
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function update_rocket_display(on_model)
{
	old_model = self.model;
	for(i = 0; i < 3; i++)
	{
		self setmodel(on_model);
		wait(0.35);
		self setmodel(old_model);
		wait(0.35);
	}
	self setmodel(on_model);
}

/*
	Name: lander_rumble_and_quake
	Namespace: zm_cosmodrome
	Checksum: 0xA55E390
	Offset: 0x63F0
	Size: 0x232
	Parameters: 7
	Flags: Linked
*/
function lander_rumble_and_quake(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	player = getlocalplayers()[localclientnum];
	player endon(#"death");
	player endon(#"disconnect");
	if(isspectating(localclientnum, 0))
	{
		return;
	}
	if(newval)
	{
		player earthquake(randomfloatrange(0.2, 0.3), randomfloatrange(2, 2.5), player.origin, 150);
		player playrumbleonentity(localclientnum, "artillery_rumble");
		self thread do_lander_rumble_quake(localclientnum);
	}
	else
	{
		self thread end_ground_sounds();
		player earthquake(randomfloatrange(0.3, 0.4), randomfloatrange(0.5, 0.6), self.origin, 150);
		wait(0.6);
		if(isdefined(player) && isdefined(self))
		{
			player earthquake(randomfloatrange(0.1, 0.2), randomfloatrange(0.2, 0.3), self.origin, 150);
		}
		level notify(#"stop_lander_rumble");
	}
}

/*
	Name: do_lander_rumble_quake
	Namespace: zm_cosmodrome
	Checksum: 0x7BD758C6
	Offset: 0x6630
	Size: 0x218
	Parameters: 1
	Flags: Linked
*/
function do_lander_rumble_quake(localclientnum)
{
	level endon(#"stop_lander_rumble");
	player = getlocalplayers()[localclientnum];
	player endon(#"entityshutdown");
	player endon(#"disconnect");
	while(true)
	{
		if(!isdefined(self.origin) || !isdefined(player.origin))
		{
			wait(0.05);
			continue;
		}
		if(distancesquared(player.origin, self.origin) > 2250000)
		{
			wait(0.1);
			continue;
		}
		dist = distancesquared(player.origin, self.origin);
		if(dist > 562500)
		{
			player earthquake(randomfloatrange(0.1, 0.15), randomfloatrange(0.15, 0.16), self.origin, 1000);
			rumble = "slide_rumble";
		}
		else
		{
			player earthquake(randomfloatrange(0.15, 0.2), randomfloatrange(0.15, 0.16), self.origin, 750);
			rumble = "damage_light";
		}
		player playrumbleonentity(localclientnum, rumble);
		wait(0.1);
	}
}

/*
	Name: centrifuge_rumble_control
	Namespace: zm_cosmodrome
	Checksum: 0xC654BEE3
	Offset: 0x6850
	Size: 0xCE
	Parameters: 7
	Flags: Linked
*/
function centrifuge_rumble_control(local_client_num, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(local_client_num != 0)
	{
		return;
	}
	if(newval)
	{
		players = getlocalplayers();
		for(i = 0; i < players.size; i++)
		{
			players[i] thread centrifuge_rumble_when_close(self, i);
		}
	}
	else
	{
		level notify(#"centrifuge_rumble_done");
	}
}

/*
	Name: centrifuge_rumble_when_close
	Namespace: zm_cosmodrome
	Checksum: 0x38B7CA80
	Offset: 0x6928
	Size: 0x130
	Parameters: 2
	Flags: Linked
*/
function centrifuge_rumble_when_close(ent_centrifuge, int_client_num)
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"centrifuge_rumble_done");
	rumble_range = 360000;
	centrifuge_rumble = "damage_heavy";
	client_num = undefined;
	while(isdefined(self))
	{
		distance_to_centrifuge = distancesquared(self.origin, ent_centrifuge.origin);
		if(distance_to_centrifuge < rumble_range && isdefined(self))
		{
			if(isdefined(int_client_num))
			{
				self playrumbleonentity(int_client_num, centrifuge_rumble);
			}
		}
		if(distance_to_centrifuge > rumble_range)
		{
			if(isdefined(int_client_num) && isdefined(self))
			{
				self stoprumble(int_client_num, centrifuge_rumble);
			}
		}
		wait(0.1);
	}
}

/*
	Name: centrifuge_clean_rumble
	Namespace: zm_cosmodrome
	Checksum: 0x45B603F
	Offset: 0x6A60
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function centrifuge_clean_rumble(int_client_num)
{
	self endon(#"death");
	self endon(#"disconnect");
	self stoprumble(int_client_num, "damage_heavy");
}

/*
	Name: centrifuge_warning_lights_init
	Namespace: zm_cosmodrome
	Checksum: 0x989AF7C1
	Offset: 0x6AB0
	Size: 0x14E
	Parameters: 7
	Flags: Linked
*/
function centrifuge_warning_lights_init(local_client_num, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	while(!self hasdobj(local_client_num))
	{
		wait(0.1);
	}
	if(local_client_num != 0)
	{
		return;
	}
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		self centrifuge_warning_lights_off(i);
	}
	if(newval)
	{
		players = getlocalplayers();
		for(i = 0; i < players.size; i++)
		{
			self centrifuge_fx_spot_init(i);
			self centrifuge_warning_lights_on(i);
		}
	}
}

/*
	Name: monkey_lander_fx_on
	Namespace: zm_cosmodrome
	Checksum: 0x620C3B69
	Offset: 0x6C08
	Size: 0x1C6
	Parameters: 0
	Flags: Linked
*/
function monkey_lander_fx_on()
{
	self endon(#"switch_off_monkey_lander_fx");
	playsound(0, "zmb_ape_intro_whoosh", self.origin);
	wait(2.5);
	if(isdefined(self))
	{
		self.fx = [];
		players = getlocalplayers();
		ent_num = self getentitynumber();
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			if(!isdefined(player._monkey_lander_fx))
			{
				player._monkey_lander_fx = [];
			}
			if(isdefined(player._monkey_lander_fx[ent_num]))
			{
				deletefx(i, player._monkey_lander_fx[ent_num]);
				player._monkey_lander_fx[ent_num] = undefined;
			}
			player._monkey_lander_fx[ent_num] = playfxontag(i, level._effect["monkey_trail"], self, "tag_origin");
			setfxignorepause(i, player._monkey_lander_fx[ent_num], 1);
		}
	}
}

/*
	Name: monkey_lander_fx_off
	Namespace: zm_cosmodrome
	Checksum: 0xCBFA65BB
	Offset: 0x6DD8
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function monkey_lander_fx_off()
{
	players = getlocalplayers();
	ent_num = self getentitynumber();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		playfx(i, level._effect["monkey_spawn"], self.origin);
		playrumbleonposition(i, "explosion_generic", self.origin);
		player earthquake(0.5, 0.5, player.origin, 1000);
	}
	playsound(0, "zmb_ape_intro_land", self.origin);
}

/*
	Name: monkey_lander_fx
	Namespace: zm_cosmodrome
	Checksum: 0x88624C57
	Offset: 0x6F20
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function monkey_lander_fx(local_client_num, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(local_client_num != 0)
	{
		return;
	}
	while(!self hasdobj(local_client_num))
	{
		wait(0.1);
	}
	if(newval)
	{
		self thread monkey_lander_fx_on();
		level thread function_ea758913();
	}
	else
	{
		self thread monkey_lander_fx_off();
	}
}

/*
	Name: samantha_is_angry
	Namespace: zm_cosmodrome
	Checksum: 0x16AE9243
	Offset: 0x6FF0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function samantha_is_angry(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		zm_cosmodrome_amb::samantha_is_angry_earthquake_and_rumbles(localclientnum);
	}
}

/*
	Name: centrifuge_fx_spot_init
	Namespace: zm_cosmodrome
	Checksum: 0xEAB403BA
	Offset: 0x7058
	Size: 0x220
	Parameters: 1
	Flags: Linked
*/
function centrifuge_fx_spot_init(int_client_num)
{
	self._centrifuge_lights_[int_client_num] = [];
	self._centrifuge_lights_[int_client_num] = array::add(self._centrifuge_lights_[int_client_num], "tag_light_bk_top", 0);
	self._centrifuge_lights_[int_client_num] = array::add(self._centrifuge_lights_[int_client_num], "tag_light_fnt_top", 0);
	self._centrifuge_lights_[int_client_num] = array::add(self._centrifuge_lights_[int_client_num], "tag_light_fnt_bttm", 0);
	self._centrifuge_lights_[int_client_num] = array::add(self._centrifuge_lights_[int_client_num], "tag_light_bk_bttm", 0);
	self._centrifuge_sparks_[int_client_num] = [];
	self._centrifuge_sparks_[int_client_num] = array::add(self._centrifuge_sparks_[int_client_num], "tag_light_bk_bttm", 0);
	self._centrifuge_sparks_[int_client_num] = array::add(self._centrifuge_sparks_[int_client_num], "tag_light_fnt_bttm", 0);
	self._centrifuge_steams_[int_client_num] = [];
	self._centrifuge_steams_[int_client_num] = array::add(self._centrifuge_steams_[int_client_num], "tag_vent_bk_btm", 0);
	self._centrifuge_steams_[int_client_num] = array::add(self._centrifuge_steams_[int_client_num], "tag_vent_top_btm", 0);
	self._centrifuge_light_mdls_[int_client_num] = [];
	self._centrifuge_fx_setup = 1;
}

/*
	Name: centrifuge_warning_lights_on
	Namespace: zm_cosmodrome
	Checksum: 0xAE25F620
	Offset: 0x7280
	Size: 0x34C
	Parameters: 1
	Flags: Linked
*/
function centrifuge_warning_lights_on(client_num)
{
	for(i = 0; i < self._centrifuge_lights_[client_num].size; i++)
	{
		temp_mdl = spawn(client_num, self gettagorigin(self._centrifuge_lights_[client_num][i]), "script_model");
		temp_mdl.angles = self gettagangles(self._centrifuge_lights_[client_num][i]);
		if(issubstr(self._centrifuge_lights_[client_num][i], "_bttm"))
		{
			temp_mdl.angles = temp_mdl.angles + vectorscale((1, 0, 0), 180);
		}
		temp_mdl setmodel("tag_origin");
		temp_mdl linkto(self, self._centrifuge_lights_[client_num][i]);
		playfxontag(client_num, level._effect["centrifuge_warning_light"], temp_mdl, "tag_origin");
		self._centrifuge_light_mdls_[client_num] = array::add(self._centrifuge_light_mdls_[client_num], temp_mdl, 0);
	}
	for(i = 0; i < self._centrifuge_sparks_[client_num].size; i++)
	{
		temp_mdl = spawn(client_num, self gettagorigin(self._centrifuge_sparks_[client_num][i]), "script_model");
		temp_mdl.angles = self gettagangles(self._centrifuge_sparks_[client_num][i]);
		temp_mdl setmodel("tag_origin");
		temp_mdl linkto(self, self._centrifuge_sparks_[client_num][i]);
		playfxontag(client_num, level._effect["centrifuge_light_spark"], temp_mdl, "tag_origin");
		self._centrifuge_light_mdls_[client_num] = array::add(self._centrifuge_light_mdls_[client_num], temp_mdl, 0);
	}
	self thread centrifuge_steam_warning(client_num);
}

/*
	Name: centrifuge_steam_warning
	Namespace: zm_cosmodrome
	Checksum: 0xFC9C33CB
	Offset: 0x75D8
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function centrifuge_steam_warning(client_num)
{
	self endon(#"entityshutdown");
	wait(1);
	for(i = 0; i < self._centrifuge_steams_[client_num].size; i++)
	{
		playfxontag(client_num, level._effect["centrifuge_start_steam"], self, self._centrifuge_steams_[client_num][i]);
	}
}

/*
	Name: centrifuge_warning_lights_off
	Namespace: zm_cosmodrome
	Checksum: 0x60F8A9E3
	Offset: 0x7670
	Size: 0xC6
	Parameters: 1
	Flags: Linked
*/
function centrifuge_warning_lights_off(client_num)
{
	if(!isdefined(self._centrifuge_fx_setup))
	{
		return;
	}
	wait(0.2);
	for(i = 0; i < self._centrifuge_light_mdls_[client_num].size; i++)
	{
		if(isdefined(self._centrifuge_light_mdls_[client_num][i]))
		{
			self._centrifuge_light_mdls_[client_num][i] unlink();
		}
	}
	array::delete_all(self._centrifuge_light_mdls_[client_num]);
	self._centrifuge_light_mdls_[client_num] = [];
}

/*
	Name: fog_apply
	Namespace: zm_cosmodrome
	Checksum: 0x2884C846
	Offset: 0x7740
	Size: 0x1DC
	Parameters: 2
	Flags: Linked
*/
function fog_apply(str_fog, int_priority)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!isdefined(self._zombie_fog_list))
	{
		self._zombie_fog_list = [];
	}
	if(!isdefined(str_fog) || !isdefined(int_priority))
	{
		return;
	}
	already_in_array = 0;
	if(self._zombie_fog_list.size != 0)
	{
		for(i = 0; i < self._zombie_fog_list.size; i++)
		{
			if(isdefined(self._zombie_fog_list[i].fog_setting) && self._zombie_fog_list[i].fog_setting == str_fog)
			{
				already_in_array = 1;
				if(self._zombie_fog_list[i].priority != int_priority)
				{
					self._zombie_fog_list[i].priority = int_priority;
				}
				break;
			}
		}
	}
	if(!already_in_array)
	{
		temp_struct = spawnstruct();
		temp_struct.fog_setting = str_fog;
		temp_struct.priority = int_priority;
		self._zombie_fog_list = array::add(self._zombie_fog_list, temp_struct, 0);
	}
	fog_to_set = get_fog_by_priority();
	set_fog(fog_to_set);
}

/*
	Name: fog_remove
	Namespace: zm_cosmodrome
	Checksum: 0x730742D1
	Offset: 0x7928
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function fog_remove(str_fog)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!isdefined(str_fog))
	{
		return;
	}
	if(!isdefined(self._zombie_fog_list))
	{
		self._zombie_fog_list = [];
	}
	temp_struct = undefined;
	for(i = 0; i < self._zombie_fog_list.size; i++)
	{
		if(isdefined(self._zombie_fog_list[i].fog_setting) && self._zombie_fog_list[i].fog_setting == str_fog)
		{
			temp_struct = self._zombie_fog_list[i];
		}
	}
	if(isdefined(temp_struct))
	{
		for(i = 0; i < self._zombie_fog_list.size; i++)
		{
			if(self._zombie_fog_list[i] == temp_struct)
			{
				self._zombie_fog_list[i] = undefined;
			}
		}
		array::remove_undefined(self._zombie_fog_list);
	}
	fog_to_set = get_fog_by_priority();
	set_fog(fog_to_set);
}

/*
	Name: get_fog_by_priority
	Namespace: zm_cosmodrome
	Checksum: 0x555917E8
	Offset: 0x7AA8
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function get_fog_by_priority()
{
	if(!isdefined(self._zombie_fog_list))
	{
		return;
	}
	highest_score = 0;
	highest_score_fog = undefined;
	for(i = 0; i < self._zombie_fog_list.size; i++)
	{
		if(isdefined(self._zombie_fog_list[i].priority) && self._zombie_fog_list[i].priority > highest_score)
		{
			highest_score = self._zombie_fog_list[i].priority;
			highest_score_fog = self._zombie_fog_list[i].fog_setting;
		}
	}
	return highest_score_fog;
}

/*
	Name: setup_fog
	Namespace: zm_cosmodrome
	Checksum: 0xA0A37002
	Offset: 0x7B90
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function setup_fog()
{
	util::waitforclient(0);
	wait(1);
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] fog_apply("normal", level._fog_settings_default_priority);
	}
}

/*
	Name: set_fog
	Namespace: zm_cosmodrome
	Checksum: 0x8BFD1CF6
	Offset: 0x7C30
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function set_fog(fog_type)
{
	util::waitforclient(0);
	if(!isdefined(fog_type))
	{
		return;
	}
	switch(fog_type)
	{
		case "normal":
		{
			setworldfogactivebank(self getlocalclientnumber(), 1);
			break;
		}
		case "monkey":
		{
			setworldfogactivebank(self getlocalclientnumber(), 2);
			break;
		}
		case "lander":
		{
			break;
		}
	}
}

/*
	Name: player_lander_fog
	Namespace: zm_cosmodrome
	Checksum: 0x312BACC1
	Offset: 0x7CF8
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function player_lander_fog(local_client_num, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	player = getlocalplayers()[local_client_num];
	if(newval)
	{
		player thread fog_apply("lander", level._fog_settings_lander_priority);
	}
	else
	{
		player thread fog_remove("lander");
	}
}

/*
	Name: setup_personality_character_exerts
	Namespace: zm_cosmodrome
	Checksum: 0xD318A0FF
	Offset: 0x7DB0
	Size: 0x1482
	Parameters: 0
	Flags: Linked
*/
function setup_personality_character_exerts()
{
	level.exert_sounds[1]["playerbreathinsound"][0] = "vox_plr_0_exert_inhale_0";
	level.exert_sounds[1]["playerbreathinsound"][1] = "vox_plr_0_exert_inhale_1";
	level.exert_sounds[1]["playerbreathinsound"][2] = "vox_plr_0_exert_inhale_2";
	level.exert_sounds[2]["playerbreathinsound"][0] = "vox_plr_1_exert_inhale_0";
	level.exert_sounds[2]["playerbreathinsound"][1] = "vox_plr_1_exert_inhale_1";
	level.exert_sounds[2]["playerbreathinsound"][2] = "vox_plr_1_exert_inhale_2";
	level.exert_sounds[3]["playerbreathinsound"][0] = "vox_plr_2_exert_inhale_0";
	level.exert_sounds[3]["playerbreathinsound"][1] = "vox_plr_2_exert_inhale_1";
	level.exert_sounds[3]["playerbreathinsound"][2] = "vox_plr_2_exert_inhale_2";
	level.exert_sounds[4]["playerbreathinsound"][0] = "vox_plr_3_exert_inhale_0";
	level.exert_sounds[4]["playerbreathinsound"][1] = "vox_plr_3_exert_inhale_1";
	level.exert_sounds[4]["playerbreathinsound"][2] = "vox_plr_3_exert_inhale_2";
	level.exert_sounds[1]["playerbreathoutsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[1]["playerbreathoutsound"][1] = "vox_plr_0_exert_exhale_1";
	level.exert_sounds[1]["playerbreathoutsound"][2] = "vox_plr_0_exert_exhale_2";
	level.exert_sounds[2]["playerbreathoutsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[2]["playerbreathoutsound"][1] = "vox_plr_1_exert_exhale_1";
	level.exert_sounds[2]["playerbreathoutsound"][2] = "vox_plr_1_exert_exhale_2";
	level.exert_sounds[3]["playerbreathoutsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[3]["playerbreathoutsound"][1] = "vox_plr_2_exert_exhale_1";
	level.exert_sounds[3]["playerbreathoutsound"][2] = "vox_plr_2_exert_exhale_2";
	level.exert_sounds[4]["playerbreathoutsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[4]["playerbreathoutsound"][1] = "vox_plr_3_exert_exhale_1";
	level.exert_sounds[4]["playerbreathoutsound"][2] = "vox_plr_3_exert_exhale_2";
	level.exert_sounds[1]["playerbreathgaspsound"][0] = "vox_plr_0_exert_exhale_0";
	level.exert_sounds[1]["playerbreathgaspsound"][1] = "vox_plr_0_exert_exhale_1";
	level.exert_sounds[1]["playerbreathgaspsound"][2] = "vox_plr_0_exert_exhale_2";
	level.exert_sounds[2]["playerbreathgaspsound"][0] = "vox_plr_1_exert_exhale_0";
	level.exert_sounds[2]["playerbreathgaspsound"][1] = "vox_plr_1_exert_exhale_1";
	level.exert_sounds[2]["playerbreathgaspsound"][2] = "vox_plr_1_exert_exhale_2";
	level.exert_sounds[3]["playerbreathgaspsound"][0] = "vox_plr_2_exert_exhale_0";
	level.exert_sounds[3]["playerbreathgaspsound"][1] = "vox_plr_2_exert_exhale_1";
	level.exert_sounds[3]["playerbreathgaspsound"][2] = "vox_plr_2_exert_exhale_2";
	level.exert_sounds[4]["playerbreathgaspsound"][0] = "vox_plr_3_exert_exhale_0";
	level.exert_sounds[4]["playerbreathgaspsound"][1] = "vox_plr_3_exert_exhale_1";
	level.exert_sounds[4]["playerbreathgaspsound"][2] = "vox_plr_3_exert_exhale_2";
	level.exert_sounds[1]["falldamage"][0] = "vox_plr_0_exert_pain_low_0";
	level.exert_sounds[1]["falldamage"][1] = "vox_plr_0_exert_pain_low_1";
	level.exert_sounds[1]["falldamage"][2] = "vox_plr_0_exert_pain_low_2";
	level.exert_sounds[1]["falldamage"][3] = "vox_plr_0_exert_pain_low_3";
	level.exert_sounds[1]["falldamage"][4] = "vox_plr_0_exert_pain_low_4";
	level.exert_sounds[1]["falldamage"][5] = "vox_plr_0_exert_pain_low_5";
	level.exert_sounds[1]["falldamage"][6] = "vox_plr_0_exert_pain_low_6";
	level.exert_sounds[1]["falldamage"][7] = "vox_plr_0_exert_pain_low_7";
	level.exert_sounds[2]["falldamage"][0] = "vox_plr_1_exert_pain_low_0";
	level.exert_sounds[2]["falldamage"][1] = "vox_plr_1_exert_pain_low_1";
	level.exert_sounds[2]["falldamage"][2] = "vox_plr_1_exert_pain_low_2";
	level.exert_sounds[2]["falldamage"][3] = "vox_plr_1_exert_pain_low_3";
	level.exert_sounds[2]["falldamage"][4] = "vox_plr_1_exert_pain_low_4";
	level.exert_sounds[2]["falldamage"][5] = "vox_plr_1_exert_pain_low_5";
	level.exert_sounds[2]["falldamage"][6] = "vox_plr_1_exert_pain_low_6";
	level.exert_sounds[2]["falldamage"][7] = "vox_plr_1_exert_pain_low_7";
	level.exert_sounds[3]["falldamage"][0] = "vox_plr_2_exert_pain_low_0";
	level.exert_sounds[3]["falldamage"][1] = "vox_plr_2_exert_pain_low_1";
	level.exert_sounds[3]["falldamage"][2] = "vox_plr_2_exert_pain_low_2";
	level.exert_sounds[3]["falldamage"][3] = "vox_plr_2_exert_pain_low_3";
	level.exert_sounds[3]["falldamage"][4] = "vox_plr_2_exert_pain_low_4";
	level.exert_sounds[3]["falldamage"][5] = "vox_plr_2_exert_pain_low_5";
	level.exert_sounds[3]["falldamage"][6] = "vox_plr_2_exert_pain_low_6";
	level.exert_sounds[3]["falldamage"][7] = "vox_plr_2_exert_pain_low_7";
	level.exert_sounds[4]["falldamage"][0] = "vox_plr_3_exert_pain_low_0";
	level.exert_sounds[4]["falldamage"][1] = "vox_plr_3_exert_pain_low_1";
	level.exert_sounds[4]["falldamage"][2] = "vox_plr_3_exert_pain_low_2";
	level.exert_sounds[4]["falldamage"][3] = "vox_plr_3_exert_pain_low_3";
	level.exert_sounds[4]["falldamage"][4] = "vox_plr_3_exert_pain_low_4";
	level.exert_sounds[4]["falldamage"][5] = "vox_plr_3_exert_pain_low_5";
	level.exert_sounds[4]["falldamage"][6] = "vox_plr_3_exert_pain_low_6";
	level.exert_sounds[4]["falldamage"][7] = "vox_plr_3_exert_pain_low_7";
	level.exert_sounds[1]["mantlesoundplayer"][0] = "vox_plr_0_exert_grunt_0";
	level.exert_sounds[1]["mantlesoundplayer"][1] = "vox_plr_0_exert_grunt_1";
	level.exert_sounds[1]["mantlesoundplayer"][2] = "vox_plr_0_exert_grunt_2";
	level.exert_sounds[1]["mantlesoundplayer"][3] = "vox_plr_0_exert_grunt_3";
	level.exert_sounds[1]["mantlesoundplayer"][4] = "vox_plr_0_exert_grunt_4";
	level.exert_sounds[1]["mantlesoundplayer"][5] = "vox_plr_0_exert_grunt_5";
	level.exert_sounds[1]["mantlesoundplayer"][6] = "vox_plr_0_exert_grunt_6";
	level.exert_sounds[2]["mantlesoundplayer"][0] = "vox_plr_1_exert_grunt_0";
	level.exert_sounds[2]["mantlesoundplayer"][1] = "vox_plr_1_exert_grunt_1";
	level.exert_sounds[2]["mantlesoundplayer"][2] = "vox_plr_1_exert_grunt_2";
	level.exert_sounds[2]["mantlesoundplayer"][3] = "vox_plr_1_exert_grunt_3";
	level.exert_sounds[2]["mantlesoundplayer"][4] = "vox_plr_1_exert_grunt_4";
	level.exert_sounds[2]["mantlesoundplayer"][5] = "vox_plr_1_exert_grunt_5";
	level.exert_sounds[3]["mantlesoundplayer"][0] = "vox_plr_2_exert_grunt_0";
	level.exert_sounds[3]["mantlesoundplayer"][1] = "vox_plr_2_exert_grunt_1";
	level.exert_sounds[3]["mantlesoundplayer"][2] = "vox_plr_2_exert_grunt_2";
	level.exert_sounds[3]["mantlesoundplayer"][3] = "vox_plr_2_exert_grunt_3";
	level.exert_sounds[3]["mantlesoundplayer"][4] = "vox_plr_2_exert_grunt_4";
	level.exert_sounds[3]["mantlesoundplayer"][5] = "vox_plr_2_exert_grunt_5";
	level.exert_sounds[3]["mantlesoundplayer"][6] = "vox_plr_2_exert_grunt_6";
	level.exert_sounds[4]["mantlesoundplayer"][0] = "vox_plr_3_exert_grunt_0";
	level.exert_sounds[4]["mantlesoundplayer"][1] = "vox_plr_3_exert_grunt_1";
	level.exert_sounds[4]["mantlesoundplayer"][2] = "vox_plr_3_exert_grunt_2";
	level.exert_sounds[4]["mantlesoundplayer"][3] = "vox_plr_3_exert_grunt_4";
	level.exert_sounds[4]["mantlesoundplayer"][4] = "vox_plr_3_exert_grunt_5";
	level.exert_sounds[4]["mantlesoundplayer"][5] = "vox_plr_3_exert_grunt_6";
	level.exert_sounds[1]["meleeswipesoundplayer"][0] = "vox_plr_0_exert_knife_swipe_0";
	level.exert_sounds[1]["meleeswipesoundplayer"][1] = "vox_plr_0_exert_knife_swipe_1";
	level.exert_sounds[1]["meleeswipesoundplayer"][2] = "vox_plr_0_exert_knife_swipe_2";
	level.exert_sounds[1]["meleeswipesoundplayer"][3] = "vox_plr_0_exert_knife_swipe_3";
	level.exert_sounds[1]["meleeswipesoundplayer"][4] = "vox_plr_0_exert_knife_swipe_4";
	level.exert_sounds[1]["meleeswipesoundplayer"][5] = "vox_plr_0_exert_knife_swipe_5";
	level.exert_sounds[2]["meleeswipesoundplayer"][0] = "vox_plr_1_exert_knife_swipe_0";
	level.exert_sounds[2]["meleeswipesoundplayer"][1] = "vox_plr_1_exert_knife_swipe_1";
	level.exert_sounds[2]["meleeswipesoundplayer"][2] = "vox_plr_1_exert_knife_swipe_2";
	level.exert_sounds[2]["meleeswipesoundplayer"][3] = "vox_plr_1_exert_knife_swipe_3";
	level.exert_sounds[2]["meleeswipesoundplayer"][4] = "vox_plr_1_exert_knife_swipe_4";
	level.exert_sounds[2]["meleeswipesoundplayer"][5] = "vox_plr_1_exert_knife_swipe_5";
	level.exert_sounds[3]["meleeswipesoundplayer"][0] = "vox_plr_2_exert_knife_swipe_0";
	level.exert_sounds[3]["meleeswipesoundplayer"][1] = "vox_plr_2_exert_knife_swipe_1";
	level.exert_sounds[3]["meleeswipesoundplayer"][2] = "vox_plr_2_exert_knife_swipe_2";
	level.exert_sounds[3]["meleeswipesoundplayer"][3] = "vox_plr_2_exert_knife_swipe_3";
	level.exert_sounds[3]["meleeswipesoundplayer"][4] = "vox_plr_2_exert_knife_swipe_4";
	level.exert_sounds[3]["meleeswipesoundplayer"][5] = "vox_plr_2_exert_knife_swipe_5";
	level.exert_sounds[4]["meleeswipesoundplayer"][0] = "vox_plr_3_exert_knife_swipe_0";
	level.exert_sounds[4]["meleeswipesoundplayer"][1] = "vox_plr_3_exert_knife_swipe_1";
	level.exert_sounds[4]["meleeswipesoundplayer"][2] = "vox_plr_3_exert_knife_swipe_2";
	level.exert_sounds[4]["meleeswipesoundplayer"][3] = "vox_plr_3_exert_knife_swipe_3";
	level.exert_sounds[4]["meleeswipesoundplayer"][4] = "vox_plr_3_exert_knife_swipe_4";
	level.exert_sounds[4]["meleeswipesoundplayer"][5] = "vox_plr_3_exert_knife_swipe_5";
	level.exert_sounds[1]["dtplandsoundplayer"][0] = "vox_plr_0_exert_pain_medium_0";
	level.exert_sounds[1]["dtplandsoundplayer"][1] = "vox_plr_0_exert_pain_medium_1";
	level.exert_sounds[1]["dtplandsoundplayer"][2] = "vox_plr_0_exert_pain_medium_2";
	level.exert_sounds[1]["dtplandsoundplayer"][3] = "vox_plr_0_exert_pain_medium_3";
	level.exert_sounds[2]["dtplandsoundplayer"][0] = "vox_plr_1_exert_pain_medium_0";
	level.exert_sounds[2]["dtplandsoundplayer"][1] = "vox_plr_1_exert_pain_medium_1";
	level.exert_sounds[2]["dtplandsoundplayer"][2] = "vox_plr_1_exert_pain_medium_2";
	level.exert_sounds[2]["dtplandsoundplayer"][3] = "vox_plr_1_exert_pain_medium_3";
	level.exert_sounds[3]["dtplandsoundplayer"][0] = "vox_plr_2_exert_pain_medium_0";
	level.exert_sounds[3]["dtplandsoundplayer"][1] = "vox_plr_2_exert_pain_medium_1";
	level.exert_sounds[3]["dtplandsoundplayer"][2] = "vox_plr_2_exert_pain_medium_2";
	level.exert_sounds[3]["dtplandsoundplayer"][3] = "vox_plr_2_exert_pain_medium_3";
	level.exert_sounds[4]["dtplandsoundplayer"][0] = "vox_plr_3_exert_pain_medium_0";
	level.exert_sounds[4]["dtplandsoundplayer"][1] = "vox_plr_3_exert_pain_medium_1";
	level.exert_sounds[4]["dtplandsoundplayer"][2] = "vox_plr_3_exert_pain_medium_2";
	level.exert_sounds[4]["dtplandsoundplayer"][3] = "vox_plr_3_exert_pain_medium_3";
}

