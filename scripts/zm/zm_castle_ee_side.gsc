// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_castle_ee;
#using scripts\zm\zm_castle_teleporter;
#using scripts\zm\zm_castle_util;

#using_animtree("zm_castle");

class class_66e46dd 
{
	var var_16cc14d0;
	var var_41660b94;
	var var_a802d3d9;
	var var_2eb50ca2;
	var var_11a8191e;
	var var_5ae81506;
	var var_b548cd69;
	var var_f35c15fb;
	var var_c86771bb;
	var var_9abb59c4;
	var var_90e84049;
	var var_d6478e9;
	var var_d502c153;
	var var_95126c9c;

	/*
		Name: constructor
		Namespace: namespace_66e46dd
		Checksum: 0x99EC1590
		Offset: 0x2A40
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: namespace_66e46dd
		Checksum: 0x99EC1590
		Offset: 0x2A50
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: function_4217f0a1
		Namespace: namespace_66e46dd
		Checksum: 0x387BEDB3
		Offset: 0x2998
		Size: 0xA0
		Parameters: 0
		Flags: Linked
	*/
	function function_4217f0a1()
	{
		var_16cc14d0 setcandamage(1);
		while(true)
		{
			var_16cc14d0.health = 1000000;
			var_16cc14d0 waittill(#"damage", damage, attacker);
			if(!var_41660b94)
			{
				continue;
			}
			var_a802d3d9 = 0;
			wait(3);
			var_a802d3d9 = 1;
		}
	}

	/*
		Name: function_1a856336
		Namespace: namespace_66e46dd
		Checksum: 0xEFBEE88A
		Offset: 0x28F0
		Size: 0xA0
		Parameters: 0
		Flags: Linked
	*/
	function function_1a856336()
	{
		var_2eb50ca2 setcandamage(1);
		while(true)
		{
			var_2eb50ca2.health = 1000000;
			var_2eb50ca2 waittill(#"damage", damage, attacker);
			if(!var_41660b94)
			{
				continue;
			}
			var_11a8191e = 0;
			wait(3);
			var_11a8191e = 1;
		}
	}

	/*
		Name: function_1401a672
		Namespace: namespace_66e46dd
		Checksum: 0xD8F70D5
		Offset: 0x28D0
		Size: 0x18
		Parameters: 1
		Flags: Linked
	*/
	function function_1401a672(var_fc7b760)
	{
		var_41660b94 = var_fc7b760;
	}

	/*
		Name: function_755ccf7d
		Namespace: namespace_66e46dd
		Checksum: 0xBB7F0504
		Offset: 0x27E0
		Size: 0xE4
		Parameters: 0
		Flags: Linked
	*/
	function function_755ccf7d()
	{
		var_8b79520 = array("zone_great_hall", "zone_great_hall_upper", "zone_great_hall_upper_left", "zone_armory", "zone_undercroft_chapel", "zone_courtyard", "zone_courtyard_edge");
		foreach(var_348ee409 in var_8b79520)
		{
			if(zm_zonemgr::any_player_in_zone(var_348ee409))
			{
				return true;
			}
		}
		return false;
	}

	/*
		Name: function_290563e9
		Namespace: namespace_66e46dd
		Checksum: 0x2F030FCA
		Offset: 0x2448
		Size: 0x390
		Parameters: 0
		Flags: Linked
	*/
	function function_290563e9()
	{
		while(true)
		{
			if(!function_755ccf7d())
			{
				wait(0.5);
				continue;
			}
			if(level flag::get("ee_disco_inferno") == 1)
			{
				var_5ae81506 = 4;
			}
			else
			{
				var_5ae81506 = 1;
			}
			var_c86771bb rotateyaw((var_b548cd69 * var_f35c15fb) * var_5ae81506, 0.5);
			var_d6478e9 rotateyaw(((var_b548cd69 * var_9abb59c4) * var_90e84049) * var_5ae81506, 0.5);
			if(var_11a8191e)
			{
				var_d502c153 rotateyaw((var_b548cd69 * var_9abb59c4) * var_5ae81506, 0.5);
				var_2eb50ca2 rotateyaw((var_b548cd69 * var_9abb59c4) * var_5ae81506, 0.5);
			}
			if(var_a802d3d9)
			{
				var_16cc14d0 rotateyaw(((var_b548cd69 * var_f35c15fb) * var_95126c9c) * var_5ae81506, 0.5);
			}
			if(!var_11a8191e && !var_a802d3d9)
			{
				var_d536dea5 = var_d502c153.angles;
				var_74c90acc = var_16cc14d0.angles;
				var_5375e06e = abs((int(var_d536dea5[1] + 142)) % 360);
				var_7b4ccc8b = int(abs(var_74c90acc[1])) % 360;
				if(var_74c90acc[1] < 0)
				{
					var_15a04435 = 360 - var_7b4ccc8b;
				}
				else
				{
					var_15a04435 = var_7b4ccc8b;
				}
				var_a0dd62e5 = abs(var_5375e06e - var_15a04435);
				if(var_a0dd62e5 > 180)
				{
					var_a0dd62e5 = 360 - var_a0dd62e5;
				}
				/#
					iprintlnbold((((("" + var_5375e06e) + "") + var_15a04435) + "") + var_a0dd62e5);
				#/
				if(var_a0dd62e5 <= 45)
				{
					level flag::set("ee_disco_inferno");
					var_11a8191e = 1;
					var_a802d3d9 = 1;
				}
			}
			wait(0.5);
		}
	}

	/*
		Name: start
		Namespace: namespace_66e46dd
		Checksum: 0xC0211716
		Offset: 0x23F0
		Size: 0x4C
		Parameters: 0
		Flags: Linked
	*/
	function start()
	{
		self thread function_290563e9();
		self thread function_1a856336();
		self thread function_4217f0a1();
	}

	/*
		Name: init
		Namespace: namespace_66e46dd
		Checksum: 0x9B45F11E
		Offset: 0x2268
		Size: 0x180
		Parameters: 0
		Flags: Linked
	*/
	function init()
	{
		var_41660b94 = 1;
		var_11a8191e = 1;
		var_a802d3d9 = 1;
		var_c86771bb = getent("ee_disco_earth", "targetname");
		var_d502c153 = getent("ee_disco_arm_moon", "targetname");
		var_16cc14d0 = getent("ee_disco_arm_rocket", "targetname");
		var_2eb50ca2 = getent("ee_disco_moon", "targetname");
		var_d6478e9 = getent("ee_disco_moon_rocket", "targetname");
		var_2eb50ca2 linkto(var_d502c153, "tag_moon");
		var_d6478e9 linkto(var_d502c153, "tag_moon");
		var_b548cd69 = 5;
		var_f35c15fb = 1;
		var_95126c9c = -3;
		var_9abb59c4 = 2;
		var_90e84049 = 3;
	}

}

class class_d7100ae3 
{
	var var_f3797cc9;
	var m_b_active;
	var var_2ed6212f;
	var m_mdl_switch;
	var var_23036e82;
	var var_a117a15d;
	var var_246b41b3;
	var var_1ed02f45;
	var var_5c546253;

	/*
		Name: constructor
		Namespace: namespace_d7100ae3
		Checksum: 0x99EC1590
		Offset: 0x46C8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: namespace_d7100ae3
		Checksum: 0x99EC1590
		Offset: 0x46D8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: function_4db73fa1
		Namespace: namespace_d7100ae3
		Checksum: 0x4E5FF5A
		Offset: 0x4660
		Size: 0x5C
		Parameters: 0
		Flags: Linked
	*/
	function function_4db73fa1()
	{
		var_f3797cc9 = !var_f3797cc9;
		/#
			if(var_f3797cc9)
			{
				iprintlnbold("");
			}
			else
			{
				iprintlnbold("");
			}
		#/
	}

	/*
		Name: function_aa7c5ce2
		Namespace: namespace_d7100ae3
		Checksum: 0xE49F8012
		Offset: 0x4640
		Size: 0x14
		Parameters: 0
		Flags: Linked
	*/
	function function_aa7c5ce2()
	{
		m_b_active = !m_b_active;
	}

	/*
		Name: set_active
		Namespace: namespace_d7100ae3
		Checksum: 0xB5DBCF55
		Offset: 0x4610
		Size: 0x24
		Parameters: 1
		Flags: Linked
	*/
	function set_active(b_on)
	{
		if(var_2ed6212f)
		{
			return;
		}
		m_b_active = b_on;
	}

	/*
		Name: function_719601e4
		Namespace: namespace_d7100ae3
		Checksum: 0xE06F50EB
		Offset: 0x4518
		Size: 0xF0
		Parameters: 0
		Flags: Linked
	*/
	function function_719601e4()
	{
		m_mdl_switch zm_castle_util::create_unitrigger();
		while(true)
		{
			m_mdl_switch waittill(#"trigger_activated");
			self function_aa7c5ce2();
			m_mdl_switch playsound("evt_lever");
			if(m_b_active)
			{
				self notify(#"lightning_strikes");
				var_23036e82 = 0;
			}
			m_mdl_switch rotatepitch(60, 0.333);
			wait(0.333);
			m_mdl_switch rotatepitch(-60, 0.2);
			wait(0.2);
		}
	}

	/*
		Name: function_1f5408aa
		Namespace: namespace_d7100ae3
		Checksum: 0xAA89D86A
		Offset: 0x44E0
		Size: 0x2C
		Parameters: 0
		Flags: Linked
	*/
	function function_1f5408aa()
	{
		if(var_a117a15d == 9 && var_246b41b3 == 35)
		{
			return true;
		}
		return false;
	}

	/*
		Name: lightning_strikes
		Namespace: namespace_d7100ae3
		Checksum: 0xA71F706E
		Offset: 0x4400
		Size: 0xD8
		Parameters: 0
		Flags: Linked
	*/
	function lightning_strikes()
	{
		self notify(#"lightning_strikes");
		self endon(#"lightning_strikes");
		var_23036e82 = 1;
		while(true)
		{
			var_6443dac9 = randomfloatrange(5, 15);
			wait(var_6443dac9);
			level clientfield::increment("clocktower_flash");
			if(function_1f5408aa())
			{
				zm_castle_ee_side::function_779bfe1e();
				var_1ed02f45 playsound("evt_clock_comp");
				function_614407e2();
			}
		}
	}

	/*
		Name: function_614407e2
		Namespace: namespace_d7100ae3
		Checksum: 0x3B3523D
		Offset: 0x42D0
		Size: 0x124
		Parameters: 0
		Flags: Linked
	*/
	function function_614407e2()
	{
		var_246b41b3++;
		if(var_246b41b3 == 60)
		{
			var_246b41b3 = 0;
			var_a117a15d++;
		}
		if(var_a117a15d == 12)
		{
			var_a117a15d = 0;
		}
		var_5c546253 rotatepitch(-6, 0.05);
		var_5c546253 playsound("evt_min_hand");
		if((var_246b41b3 % 12) == 0)
		{
			var_1ed02f45 rotatepitch(-6, 0.05);
			var_1ed02f45 playsound("evt_hour_hand");
		}
		if(var_f3797cc9 && function_1f5408aa())
		{
			self set_active(0);
		}
	}

	/*
		Name: function_ec1f5e9
		Namespace: namespace_d7100ae3
		Checksum: 0xFB054445
		Offset: 0x40C8
		Size: 0x1FC
		Parameters: 3
		Flags: Linked
	*/
	function function_ec1f5e9(var_8deda1b1, n_minutes, var_1133e63b = 20)
	{
		var_3e7e6c38 = m_b_active;
		self set_active(0);
		var_2ed6212f = 1;
		var_16c3da4f = n_minutes - var_246b41b3;
		if(var_16c3da4f < 0)
		{
			var_16c3da4f = 60 + var_16c3da4f;
		}
		var_2dc617a1 = var_8deda1b1 - var_a117a15d;
		if(var_2dc617a1 < 0)
		{
			var_2dc617a1 = 12 + var_2dc617a1;
		}
		/#
			iprintln((("" + var_2dc617a1) + "") + var_16c3da4f);
		#/
		var_5c546253 rotatepitch(-6 * var_16c3da4f, (0.05 * var_16c3da4f) * (1 / var_1133e63b));
		var_1ed02f45 rotatepitch(-30 * var_2dc617a1, (0.05 * var_2dc617a1) * (1 / var_1133e63b));
		var_246b41b3 = n_minutes;
		var_a117a15d = var_8deda1b1;
		/#
			iprintln((("" + var_a117a15d) + "") + var_246b41b3);
		#/
		var_2ed6212f = 0;
		self set_active(var_3e7e6c38);
	}

	/*
		Name: start
		Namespace: namespace_d7100ae3
		Checksum: 0x30C25BE8
		Offset: 0x4048
		Size: 0x78
		Parameters: 0
		Flags: Linked
	*/
	function start()
	{
		self thread function_719601e4();
		while(true)
		{
			if(m_b_active)
			{
				function_614407e2();
			}
			if(!m_b_active)
			{
				if(!var_23036e82)
				{
					self thread lightning_strikes();
				}
			}
			wait(0.4);
		}
	}

	/*
		Name: init
		Namespace: namespace_d7100ae3
		Checksum: 0xDE192AD0
		Offset: 0x3F78
		Size: 0xC4
		Parameters: 0
		Flags: Linked
	*/
	function init()
	{
		var_5c546253 = getent("ee_clocktower_minute_hand", "targetname");
		var_1ed02f45 = getent("ee_clocktower_hour_hand", "targetname");
		m_mdl_switch = getent("ee_clocktower_activation_switch", "targetname");
		m_b_active = 0;
		var_246b41b3 = 0;
		var_a117a15d = 0;
		var_23036e82 = 0;
		var_f3797cc9 = 0;
		var_2ed6212f = 0;
	}

}

#namespace zm_castle_ee_side;

/*
	Name: __init__sytem__
	Namespace: zm_castle_ee_side
	Checksum: 0xFF5BC96E
	Offset: 0xCD8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_ee_side", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_castle_ee_side
	Checksum: 0x4C371D8F
	Offset: 0xD18
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["def_explode"] = "explosions/fx_exp_grenade_default";
	level._effect["mechz_rocket_punch"] = "dlc1/castle/fx_mech_jump_booster_loop";
	clientfield::register("world", "clocktower_flash", 5000, 1, "counter");
	clientfield::register("world", "sndUEB", 5000, 1, "int");
	clientfield::register("actor", "plunger_exploding_ai", 5000, 1, "int");
	clientfield::register("toplayer", "plunger_charged_strike", 5000, 1, "counter");
	zm::register_player_damage_callback(&function_b98927d4);
	zm::register_actor_damage_callback(&function_f10f1879);
}

/*
	Name: main
	Namespace: zm_castle_ee_side
	Checksum: 0x98420F2A
	Offset: 0xE60
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level.gravity_trap_spike_watcher = &gravity_trap_spike_watcher;
	level thread function_e437a08f();
	init_flags();
	level waittill(#"start_zombie_round_logic");
	level thread function_452b0b5a();
	function_70b74a2d();
	function_b8645c20();
	function_fd2e0e37();
	function_769b2ff();
	function_7998107();
	function_9e325d85();
	/#
		if(getdvarint("") > 0)
		{
			level thread function_d6026710();
		}
	#/
}

/*
	Name: init_flags
	Namespace: zm_castle_ee_side
	Checksum: 0xCA197EF6
	Offset: 0xF68
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function init_flags()
{
	level flag::init("play_vocals");
	level flag::init("ee_power_clocktower");
	level flag::init("ee_claw_hat");
	level flag::init("ee_disco_inferno");
	level flag::init("ee_power_wallrun_teleport");
	level flag::init("ee_music_box_turning");
	level flag::init("plunger_teleport_on");
}

/*
	Name: function_452b0b5a
	Namespace: zm_castle_ee_side
	Checksum: 0x53763BA3
	Offset: 0x1058
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_452b0b5a()
{
	level.var_818b7815 = new class_66e46dd();
	[[ level.var_818b7815 ]]->init();
	level thread function_e3163325();
	level.var_9f94326b = new class_d7100ae3();
	[[ level.var_9f94326b ]]->init();
	[[ level.var_9f94326b ]]->function_ec1f5e9(1, 15);
	level flag::wait_till("ee_power_clocktower");
	[[ level.var_9f94326b ]]->start();
}

/*
	Name: function_70b74a2d
	Namespace: zm_castle_ee_side
	Checksum: 0xB5A0AEA7
	Offset: 0x1120
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_70b74a2d()
{
	level thread function_5c600852();
	level thread function_553b8e23();
	level thread spare_change();
	level thread function_7c237ecb();
	level thread function_52c08eab();
	level thread function_4eb3851();
	level thread function_c691b60();
}

/*
	Name: function_e3163325
	Namespace: zm_castle_ee_side
	Checksum: 0x2D50199C
	Offset: 0x11D8
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function function_e3163325()
{
	level flag::wait_till("power_on");
	[[ level.var_818b7815 ]]->start();
}

/*
	Name: function_c691b60
	Namespace: zm_castle_ee_side
	Checksum: 0xDED9D366
	Offset: 0x1218
	Size: 0x18E
	Parameters: 0
	Flags: Linked
*/
function function_c691b60()
{
	for(i = 0; i < 5; i++)
	{
		var_2de8cf5e = struct::get_array("ee_groph_reels_" + i, "targetname");
		foreach(s_reel in var_2de8cf5e)
		{
			var_df5776d8 = util::spawn_model(s_reel.model, s_reel.origin, s_reel.angles);
			s_reel.var_df5776d8 = var_df5776d8;
			s_reel.var_df5776d8 thread function_2db2bf79();
		}
		if(i == 0)
		{
			level thread function_374ac18c(var_2de8cf5e, i);
			continue;
		}
		level thread function_6bf381de(var_2de8cf5e, i);
	}
}

/*
	Name: function_6bf381de
	Namespace: zm_castle_ee_side
	Checksum: 0xE6EF533
	Offset: 0x13B0
	Size: 0xA8
	Parameters: 2
	Flags: Linked
*/
function function_6bf381de(var_2de8cf5e, var_bee8e45)
{
	while(true)
	{
		var_2de8cf5e[0] zm_castle_util::create_unitrigger();
		var_2de8cf5e[0] waittill(#"trigger_activated");
		function_972992c4(var_2de8cf5e, 1);
		var_2de8cf5e[0].var_df5776d8 function_ffa9011b(var_bee8e45);
		function_972992c4(var_2de8cf5e, 0);
	}
}

/*
	Name: function_374ac18c
	Namespace: zm_castle_ee_side
	Checksum: 0x1390ECB1
	Offset: 0x1460
	Size: 0x180
	Parameters: 2
	Flags: Linked
*/
function function_374ac18c(var_2de8cf5e, var_bee8e45)
{
	var_2de8cf5e[0].var_df5776d8 setcandamage(1);
	while(true)
	{
		var_2de8cf5e[0].var_df5776d8.health = 1000000;
		var_2de8cf5e[0].var_df5776d8 waittill(#"damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(!isdefined(attacker) || !isplayer(attacker))
		{
			continue;
		}
		function_972992c4(var_2de8cf5e, 1);
		var_2de8cf5e[0].var_df5776d8 function_ffa9011b(var_bee8e45);
		function_972992c4(var_2de8cf5e, 0);
	}
}

/*
	Name: function_ffa9011b
	Namespace: zm_castle_ee_side
	Checksum: 0x4B3C2788
	Offset: 0x15E8
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function function_ffa9011b(var_bee8e45)
{
	self playsoundwithnotify("vox_grop_groph_radio_stem_" + (var_bee8e45 + 1), "sounddone");
	self waittill(#"sounddone");
}

/*
	Name: function_972992c4
	Namespace: zm_castle_ee_side
	Checksum: 0xC73B926E
	Offset: 0x1638
	Size: 0xB2
	Parameters: 2
	Flags: Linked
*/
function function_972992c4(var_2de8cf5e, b_on)
{
	foreach(s_reel in var_2de8cf5e)
	{
		if(isdefined(s_reel.var_df5776d8))
		{
			s_reel.var_df5776d8.var_a02b0d5a = b_on;
		}
	}
}

/*
	Name: function_2db2bf79
	Namespace: zm_castle_ee_side
	Checksum: 0xE95EA75C
	Offset: 0x16F8
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_2db2bf79()
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
	Name: function_e437a08f
	Namespace: zm_castle_ee_side
	Checksum: 0x22706CC0
	Offset: 0x1750
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_e437a08f()
{
	var_2c4303b6 = struct::get("ee_music_box");
	level.var_6d5fd229 = util::spawn_model("p7_fxanim_zm_castle_music_box_mod", var_2c4303b6.origin, var_2c4303b6.angles);
	level.var_6d5fd229 useanimtree($zm_castle);
}

/*
	Name: function_4eb3851
	Namespace: zm_castle_ee_side
	Checksum: 0x2F39159C
	Offset: 0x17E0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_4eb3851()
{
	level thread function_4e9df779();
	while(true)
	{
		level.var_6d5fd229 zm_castle_util::create_unitrigger();
		level.var_6d5fd229 waittill(#"trigger_activated");
		level flag::set("ee_music_box_turning");
		zm_unitrigger::unregister_unitrigger(level.var_6d5fd229.s_unitrigger);
		level.var_6d5fd229 playsound("mus_samantha_musicbox");
		wait(36);
		level flag::clear("ee_music_box_turning");
		level waittill(#"hash_22c84c8b");
	}
}

/*
	Name: function_4e9df779
	Namespace: zm_castle_ee_side
	Checksum: 0x9E51227F
	Offset: 0x18C8
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function function_4e9df779()
{
	while(true)
	{
		level.var_6d5fd229 animation::first_frame("p7_fxanim_zm_castle_music_box_anim");
		level flag::wait_till("ee_music_box_turning");
		while(level flag::get("ee_music_box_turning"))
		{
			level.var_6d5fd229 animation::play("p7_fxanim_zm_castle_music_box_anim");
		}
		level notify(#"hash_22c84c8b");
	}
}

/*
	Name: function_7998107
	Namespace: zm_castle_ee_side
	Checksum: 0xF2F35ABC
	Offset: 0x1978
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function function_7998107()
{
	level.var_37c0c840 = [];
	for(i = 0; i < 3; i++)
	{
		var_d5409ac0 = struct::get("ee_flying_skull_" + i);
		level.var_37c0c840[i] = util::spawn_model("rune_prison_death_skull", var_d5409ac0.origin, var_d5409ac0.angles);
		level.var_37c0c840[i] flag::init("skull_revealed");
		level.var_37c0c840[i] setcandamage(1);
		level.var_37c0c840[i] thread function_e26b6053();
		level.var_37c0c840[i] thread function_27da29cb();
		level.var_37c0c840[i] setinvisibletoall();
	}
	players = level.activeplayers;
	foreach(player in players)
	{
		player thread function_5c351802();
	}
	callback::on_spawned(&function_5c351802);
}

/*
	Name: function_5c351802
	Namespace: zm_castle_ee_side
	Checksum: 0xC07DDFFD
	Offset: 0x1B98
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function function_5c351802()
{
	for(i = 0; i < 3; i++)
	{
		self thread function_2f183e13(i);
	}
}

/*
	Name: function_2f183e13
	Namespace: zm_castle_ee_side
	Checksum: 0x6397B2D1
	Offset: 0x1BE8
	Size: 0xF8
	Parameters: 1
	Flags: Linked
*/
function function_2f183e13(n_index)
{
	level.var_37c0c840[n_index] endon(#"skull_revealed");
	if(!isdefined(level.var_37c0c840[n_index]))
	{
		return;
	}
	if(level.var_37c0c840[n_index] flag::get("skull_revealed"))
	{
		return;
	}
	while(true)
	{
		self waittill(#"bgb_bubble_blow_complete");
		if(self bgb::is_active("zm_bgb_in_plain_sight"))
		{
			level.var_37c0c840[n_index] setvisibletoplayer(self);
			self waittill(#"activation_complete");
			level.var_37c0c840[n_index] setinvisibletoplayer(self);
		}
	}
}

/*
	Name: function_e26b6053
	Namespace: zm_castle_ee_side
	Checksum: 0x8B9C5715
	Offset: 0x1CE8
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function function_e26b6053()
{
	b_shot = 0;
	while(!b_shot)
	{
		self.health = 1000000;
		self waittill(#"damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
		if(isdefined(attacker) && isplayer(attacker) && attacker bgb::is_active("zm_bgb_in_plain_sight"))
		{
			if(function_ab61ab31(weapon))
			{
				b_shot = 1;
			}
		}
	}
	function_44ea752c();
	self flag::set("skull_revealed");
	playfx(level._effect["def_explode"], self.origin);
	self delete();
}

/*
	Name: function_ab61ab31
	Namespace: zm_castle_ee_side
	Checksum: 0xB23CBD68
	Offset: 0x1E88
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function function_ab61ab31(weapon)
{
	return issubstr(weapon.name, "elemental_bow");
}

/*
	Name: function_44ea752c
	Namespace: zm_castle_ee_side
	Checksum: 0xAE669535
	Offset: 0x1EC8
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function function_44ea752c()
{
	if(!isdefined(level.var_a0554b26))
	{
		level.var_a0554b26 = 0;
	}
	function_dbc1fb93(level.var_a0554b26);
	level.var_a0554b26++;
	playsoundatposition("zmb_ee_skpower_" + level.var_a0554b26, (0, 0, 0));
	if(level.var_a0554b26 == 3)
	{
		level.var_9bf9e084 = 1;
	}
}

/*
	Name: function_dbc1fb93
	Namespace: zm_castle_ee_side
	Checksum: 0xEC4A9F21
	Offset: 0x1F50
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_dbc1fb93(var_d237c2be)
{
	if(!isdefined(level.var_478986c0))
	{
		level.var_478986c0 = [];
	}
	var_fff40961 = struct::get("ee_skull_pile_" + var_d237c2be);
	level.var_478986c0[var_d237c2be] = util::spawn_model("rune_prison_death_skull", var_fff40961.origin, var_fff40961.angles);
	if(var_d237c2be == 2)
	{
		level.var_478986c0[var_d237c2be] thread function_67a47b1c();
	}
}

/*
	Name: function_67a47b1c
	Namespace: zm_castle_ee_side
	Checksum: 0x4330D5EA
	Offset: 0x2020
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_67a47b1c()
{
	self zm_castle_util::create_unitrigger();
	self waittill(#"trigger_activated");
	if(level.var_9bf9e084 == 0)
	{
		return;
	}
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
	level.var_9bf9e084 = 0;
	playsoundatposition("zmb_ee_skpower_deactivate", (0, 0, 0));
	for(i = 0; i < 3; i++)
	{
		if(isdefined(level.var_478986c0[i]))
		{
			playfx(level._effect["def_explode"], level.var_478986c0[i].origin);
			level.var_478986c0[i] delete();
		}
		wait(0.5);
	}
	level thread function_3c992a71();
}

/*
	Name: function_3c992a71
	Namespace: zm_castle_ee_side
	Checksum: 0x95B80BE4
	Offset: 0x2160
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_3c992a71()
{
	level.var_a0554b26 = 0;
	level.var_478986c0 = [];
	level thread function_7998107();
}

/*
	Name: function_27da29cb
	Namespace: zm_castle_ee_side
	Checksum: 0xA1D4FCA8
	Offset: 0x21A0
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_27da29cb()
{
	self endon(#"skull_revealed");
	var_43af6ca7 = self.origin[2];
	while(true)
	{
		n_current_time = gettime();
		n_offset = (sin(n_current_time * 0.1)) * 16;
		v_origin = self.origin;
		self.origin = (v_origin[0], v_origin[1], var_43af6ca7 + n_offset);
		wait(0.05);
	}
}

/*
	Name: function_769b2ff
	Namespace: zm_castle_ee_side
	Checksum: 0xAE1AFFDF
	Offset: 0x2C40
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function function_769b2ff()
{
	level.var_23825200 = [];
	for(i = 0; i < 3; i++)
	{
		var_95164560 = struct::get(("ee_claw_" + i) + "_start");
		level.var_23825200[i] = util::spawn_model("c_t6_zom_mech_claw", var_95164560.origin, var_95164560.angles);
		level.var_23825200[i] flag::init("mechz_claw_revealed");
		level.var_23825200[i] setcandamage(1);
		level.var_23825200[i] thread function_e249cd7(i);
	}
}

/*
	Name: function_5d2ff09a
	Namespace: zm_castle_ee_side
	Checksum: 0x500AA027
	Offset: 0x2D70
	Size: 0x46
	Parameters: 0
	Flags: None
*/
function function_5d2ff09a()
{
	for(i = 0; i < 3; i++)
	{
		function_c02b51fb(i);
	}
}

/*
	Name: function_c02b51fb
	Namespace: zm_castle_ee_side
	Checksum: 0x4C39FAC6
	Offset: 0x2DC0
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function function_c02b51fb(n_index)
{
	level.var_23825200[n_index] endon(#"mechz_claw_revealed");
	if(level.var_23825200[n_index] flag::get("mechz_claw_revealed"))
	{
		return;
	}
	while(true)
	{
		self waittill(#"bgb_bubble_blow_complete");
		if(self bgb::is_active("zm_bgb_in_plain_sight"))
		{
			level.var_23825200[n_index] setvisibletoplayer(self);
			self waittill(#"activation_complete");
			level.var_23825200[n_index] setinvisibletoplayer(self);
		}
	}
}

/*
	Name: function_e249cd7
	Namespace: zm_castle_ee_side
	Checksum: 0xCC789A3E
	Offset: 0x2EA8
	Size: 0x32C
	Parameters: 1
	Flags: Linked
*/
function function_e249cd7(n_index)
{
	var_8b9b7897 = 0;
	while(!var_8b9b7897)
	{
		self.health = 1000000;
		var_354439b5 = self function_64e6de56();
		if(!var_354439b5)
		{
			continue;
		}
		var_8b9b7897 = 1;
		self playsound("zmb_ee_mechz_imp");
		self setcandamage(0);
	}
	self flag::set("mechz_claw_revealed");
	self setvisibletoall();
	var_7ddcf23 = struct::get(("ee_claw_" + n_index) + "_fell");
	self moveto(var_7ddcf23.origin, 0.333);
	self thread function_4767e6ca();
	wait(0.333);
	self setcandamage(1);
	var_f9f3d790 = 0;
	while(!var_f9f3d790)
	{
		self.health = 1000000;
		var_354439b5 = self function_64e6de56();
		if(!var_354439b5)
		{
			continue;
		}
		var_f9f3d790 = 1;
		self playsound("zmb_ee_mechz_activate");
		self playloopsound("zmb_ee_mechz_fire_lp", 0.1);
	}
	s_end_point = struct::get(("ee_claw_" + n_index) + "_shot");
	self thread function_d23efff2();
	playfxontag(level._effect["mechz_rocket_punch"], self, "fx_rocket");
	self moveto(s_end_point.origin, 1);
	wait(1);
	self playsound("zmb_ee_mechz_explode");
	playfx(level._effect["def_explode"], self.origin);
	self notify(#"hash_d23efff2");
	self delete();
}

/*
	Name: function_4767e6ca
	Namespace: zm_castle_ee_side
	Checksum: 0xD82E44B2
	Offset: 0x31E0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_4767e6ca()
{
	self waittill(#"movedone");
	self playsound("zmb_ee_mechz_fallimp");
}

/*
	Name: function_64e6de56
	Namespace: zm_castle_ee_side
	Checksum: 0x7840601E
	Offset: 0x3218
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function function_64e6de56()
{
	self waittill(#"damage", damage, attacker, direction_vec, point, type, tagname, modelname, partname, weapon, inflictor);
	if(type === "MOD_GRENADE" || type === "MOD_GRENADE_SPLASH" || type === "MOD_EXPLOSIVE" || type === "MOD_EXPLOSIVE_SPLASH")
	{
		return false;
	}
	if(function_ab61ab31(weapon))
	{
		e_impact = spawn("script_origin", point);
		if(!e_impact istouching(self))
		{
			e_impact delete();
			return false;
		}
		e_impact delete();
	}
	if(!isdefined(attacker) || !isplayer(attacker))
	{
		return false;
	}
	return true;
}

/*
	Name: function_d23efff2
	Namespace: zm_castle_ee_side
	Checksum: 0x484E73D4
	Offset: 0x33A8
	Size: 0x200
	Parameters: 0
	Flags: Linked
*/
function function_d23efff2()
{
	self endon(#"hash_d23efff2");
	while(true)
	{
		a_enemies = getactorteamarray("axis");
		foreach(e_enemy in a_enemies)
		{
			dist2 = distancesquared(self.origin, e_enemy.origin);
			if(dist2 < 16384)
			{
				if(isdefined(e_enemy) && isalive(e_enemy))
				{
					if(isdefined(e_enemy.archetype) && e_enemy.archetype == "mechz")
					{
						e_enemy dodamage(self.health * 777, e_enemy.origin);
						if(!isdefined(level.var_708b5a49))
						{
							level.var_708b5a49 = 1;
						}
						else
						{
							level.var_708b5a49++;
						}
						if(level.var_708b5a49 == 3)
						{
							function_90b13c3d();
						}
						continue;
					}
					if(isdefined(e_enemy.archetype) && e_enemy.archetype == "zombie")
					{
						e_enemy thread zombie_death::do_gib();
					}
				}
			}
		}
		wait(0.2);
	}
}

/*
	Name: function_d249c76c
	Namespace: zm_castle_ee_side
	Checksum: 0xCCB5559C
	Offset: 0x35B0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_d249c76c()
{
	self attach("c_t6_zom_mech_claw_hat", "j_head");
}

/*
	Name: function_90b13c3d
	Namespace: zm_castle_ee_side
	Checksum: 0xA2FF3FA6
	Offset: 0x35E8
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_90b13c3d()
{
	players = level.activeplayers;
	foreach(player in players)
	{
		player function_d249c76c();
	}
	level flag::set("ee_claw_hat");
	callback::on_spawned(&function_d249c76c);
}

/*
	Name: function_b8645c20
	Namespace: zm_castle_ee_side
	Checksum: 0x9E344412
	Offset: 0x36C8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_b8645c20()
{
	level.var_91b525ed = 0;
	function_79e1bd74(0);
}

/*
	Name: function_79e1bd74
	Namespace: zm_castle_ee_side
	Checksum: 0x5D134458
	Offset: 0x36F8
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_79e1bd74(n_level)
{
	var_5824233 = array("p7_zm_ctl_newspaper_01_parade", "p7_zm_ctl_newspaper_01_attacks", "p7_zm_ctl_newspaper_01_outbreak");
	str_model = var_5824233[n_level];
	if(!isdefined(level.var_31e6a027))
	{
		var_21231084 = struct::get("ee_newspaper");
		level.var_31e6a027 = util::spawn_model(str_model, var_21231084.origin, var_21231084.angles);
	}
	else
	{
		level.var_31e6a027 setmodel(str_model);
	}
}

/*
	Name: function_fd2e0e37
	Namespace: zm_castle_ee_side
	Checksum: 0x21CE5A87
	Offset: 0x37E0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_fd2e0e37()
{
	level.var_f4166c4f = 0;
	s_loc = struct::get("ee_plunger_pickup");
	level.var_163864b7 = util::spawn_model("wpn_t7_zmb_dlc1_plunger_world", s_loc.origin, s_loc.angles);
	level thread function_4811d22b();
	function_56e07512(s_loc);
}

/*
	Name: function_4811d22b
	Namespace: zm_castle_ee_side
	Checksum: 0x825CDAD9
	Offset: 0x3890
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_4811d22b()
{
	level endon(#"hash_4811d22b");
	level.var_163864b7 setinvisibletoall();
	while(true)
	{
		level flag::wait_till("plunger_teleport_on");
		level.var_163864b7 setvisibletoall();
		level flag::wait_till_clear("plunger_teleport_on");
		level.var_163864b7 setinvisibletoall();
	}
}

/*
	Name: function_b98927d4
	Namespace: zm_castle_ee_side
	Checksum: 0x5D0E4394
	Offset: 0x3938
	Size: 0x12A
	Parameters: 10
	Flags: Linked
*/
function function_b98927d4(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	if(level flag::get("ee_claw_hat") && eattacker.archetype == "mechz")
	{
		switch(smeansofdeath)
		{
			case "MOD_MELEE":
			{
				idamage = idamage * 0.5;
				break;
			}
			case "MOD_BURNED":
			{
				idamage = idamage * 0.5;
				break;
			}
			case "MOD_PROJECTILE_SPLASH":
			{
				idamage = idamage * 0.5;
				break;
			}
		}
		idamage = int(idamage);
		return idamage;
	}
	return -1;
}

/*
	Name: function_52c08eab
	Namespace: zm_castle_ee_side
	Checksum: 0x76EE9B6E
	Offset: 0x3A70
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function function_52c08eab()
{
	while(true)
	{
		level flag::wait_till("ee_disco_inferno");
		[[ level.var_818b7815 ]]->function_1401a672(0);
		level.var_818b7815.var_c86771bb playsound("mus_ee_disco");
		level thread lui::screen_flash(0.15, 0.1, 0.5, 1, "white");
		wait(0.15);
		exploder::exploder("disco_lgt");
		wait(52);
		exploder::exploder_stop("disco_lgt");
		level flag::clear("ee_disco_inferno");
		[[ level.var_818b7815 ]]->function_1401a672(1);
	}
}

/*
	Name: function_7c237ecb
	Namespace: zm_castle_ee_side
	Checksum: 0xF1FF9847
	Offset: 0x3BA0
	Size: 0x314
	Parameters: 1
	Flags: Linked
*/
function function_7c237ecb(var_f00386ff = 0)
{
	if(!sessionmodeisonlinegame() && !var_f00386ff)
	{
		return;
	}
	var_c27c9236 = struct::get("ee_plant_present");
	var_15cfdc94 = util::spawn_model("p7_zm_ctl_plant_decor_sprout", var_c27c9236.origin, var_c27c9236.angles);
	var_15cfdc94 zm_castle_util::create_unitrigger();
	var_15cfdc94 waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(var_15cfdc94.s_unitrigger);
	var_15cfdc94 hide();
	var_1f6712bd = struct::get("ee_plant_past");
	var_4bb0e877 = util::spawn_model("p7_zm_ctl_plant_decor_sprout", var_1f6712bd.origin, var_1f6712bd.angles);
	var_4bb0e877 hide();
	var_1f6712bd zm_castle_util::create_unitrigger();
	var_1f6712bd waittill(#"trigger_activated");
	zm_unitrigger::unregister_unitrigger(var_1f6712bd.s_unitrigger);
	var_4bb0e877 show();
	var_f6cbed0f = struct::get("ee_plant_gobblegum");
	var_15cfdc94 setmodel("p7_zm_ctl_plant_decor_grown");
	var_15cfdc94 show();
	var_acadbb15 = util::spawn_model("p7_zm_zod_bubblegum_machine_gumball_white", var_f6cbed0f.origin, var_f6cbed0f.angles);
	var_15cfdc94 zm_castle_util::create_unitrigger();
	var_15cfdc94 waittill(#"trigger_activated", player);
	zm_unitrigger::unregister_unitrigger(var_15cfdc94.s_unitrigger);
	var_acadbb15 delete();
	player.selected_bgb = bgb::function_d51db887();
	player thread bgb::bgb_gumball_anim(player.selected_bgb, 0);
}

/*
	Name: gravity_trap_spike_watcher
	Namespace: zm_castle_ee_side
	Checksum: 0xFCD423D3
	Offset: 0x3EC0
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function gravity_trap_spike_watcher(mdl_spike)
{
	if(isdefined(level.var_714fae39) && level.var_714fae39 && level flag::get("ee_power_clocktower") == 0)
	{
		var_3d98ac09 = getent("clocktower_power_trig", "targetname");
		if(mdl_spike istouching(var_3d98ac09))
		{
			level flag::set("ee_power_clocktower");
		}
	}
}

/*
	Name: function_9e325d85
	Namespace: zm_castle_ee_side
	Checksum: 0xB7E8C520
	Offset: 0x4958
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_9e325d85()
{
	for(i = 0; i < 4; i++)
	{
		t_wallrun = getent("ee_undercroft_wallrun_" + i, "targetname");
		t_wallrun thread function_81d41eb8(i);
	}
	var_3294f1d9 = getent("ee_undercroft_wallrun_reset", "targetname");
	var_3294f1d9 thread function_8d508e48();
}

/*
	Name: function_779bfe1e
	Namespace: zm_castle_ee_side
	Checksum: 0xB37DED2F
	Offset: 0x4A20
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_779bfe1e()
{
	exploder::exploder("fxexp_600");
	level flag::set("ee_power_wallrun_teleport");
	level clientfield::set("sndUEB", 1);
}

/*
	Name: function_421bb7db
	Namespace: zm_castle_ee_side
	Checksum: 0xCB055D2A
	Offset: 0x4A88
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_421bb7db()
{
	exploder::stop_exploder("fxexp_600");
	level flag::clear("ee_power_wallrun_teleport");
	level clientfield::set("sndUEB", 0);
}

/*
	Name: function_81d41eb8
	Namespace: zm_castle_ee_side
	Checksum: 0x54721A85
	Offset: 0x4AF0
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function function_81d41eb8(var_7f701981)
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(level flag::get("ee_power_wallrun_teleport") == 0)
		{
			continue;
		}
		if(isdefined(player.var_48391945) && var_7f701981 != player.var_48391945)
		{
			var_32ceceb2 = function_6ad38393(player, var_7f701981);
			if(isdefined(player.var_6670513f) && player.var_6670513f == var_32ceceb2)
			{
				player.var_130b9781++;
			}
			else if(!isdefined(player.var_6670513f))
			{
				player.var_130b9781 = 1;
			}
			player.var_6670513f = var_32ceceb2;
		}
		if(player.var_130b9781 === 8)
		{
			function_27b3a99c(player);
		}
		player.var_48391945 = var_7f701981;
	}
}

/*
	Name: function_8d508e48
	Namespace: zm_castle_ee_side
	Checksum: 0x651F1ACA
	Offset: 0x4C68
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function function_8d508e48()
{
	while(true)
	{
		self waittill(#"trigger", player);
		player.var_130b9781 = 0;
		player.var_48391945 = undefined;
	}
}

/*
	Name: function_6ad38393
	Namespace: zm_castle_ee_side
	Checksum: 0x38191CCD
	Offset: 0x4CB8
	Size: 0x98
	Parameters: 2
	Flags: Linked
*/
function function_6ad38393(player, var_7f701981)
{
	if(player.var_48391945 > var_7f701981 || (player.var_48391945 == 0 && var_7f701981 == 3))
	{
		return true;
	}
	if(player.var_48391945 < var_7f701981 || (var_7f701981 == 0 && player.var_48391945 == 3))
	{
		return false;
	}
}

/*
	Name: function_27b3a99c
	Namespace: zm_castle_ee_side
	Checksum: 0x17951D21
	Offset: 0x4D58
	Size: 0x224
	Parameters: 1
	Flags: Linked
*/
function function_27b3a99c(player)
{
	level.var_f4166c4f++;
	level flag::set("plunger_teleport_on");
	zm_zonemgr::enable_zone("zone_past_laboratory");
	visionset_mgr::activate("overlay", "zm_factory_teleport", player, level.n_teleport_delay, level.n_teleport_delay);
	s_dest = struct::get("ee_teleport_to_plunger_" + player.characterindex, "targetname");
	function_aaacffb2(player, s_dest);
	wait(0.05);
	player clientfield::set_to_player("ee_quest_back_in_time_postfx", 1);
	var_f9d5e23a = player hasweapon(getweapon("knife_plunger"));
	wait(10);
	s_return = struct::get("ee_teleport_return_from_plunger_" + player.characterindex, "targetname");
	player clientfield::set_to_player("ee_quest_back_in_time_postfx", 0);
	visionset_mgr::activate("overlay", "zm_factory_teleport", player, level.n_teleport_delay, level.n_teleport_delay);
	function_aaacffb2(player, s_return);
	level.var_f4166c4f--;
	if(level.var_f4166c4f == 0)
	{
		level flag::clear("plunger_teleport_on");
	}
	function_421bb7db();
}

/*
	Name: function_aaacffb2
	Namespace: zm_castle_ee_side
	Checksum: 0x9DA8FF6F
	Offset: 0x4F88
	Size: 0x4D4
	Parameters: 2
	Flags: Linked
*/
function function_aaacffb2(player, s_dest)
{
	var_daad3c3c = vectorscale((0, 0, 1), 49);
	var_6b55b1c4 = vectorscale((0, 0, 1), 20);
	var_3abe10e2 = (0, 0, 0);
	var_d3263bfe = getent("teleport_room_" + player.characterindex, "targetname");
	player zm_utility::create_streamer_hint(s_dest.origin, s_dest.angles, 0.25);
	if(isdefined(var_d3263bfe))
	{
		visionset_mgr::deactivate("overlay", "zm_trap_electric", player);
		visionset_mgr::activate("overlay", "zm_factory_teleport", player);
		player disableoffhandweapons();
		player disableweapons();
		if(player getstance() == "prone")
		{
			desired_origin = var_d3263bfe.origin + var_daad3c3c;
		}
		else
		{
			if(player getstance() == "crouch")
			{
				desired_origin = var_d3263bfe.origin + var_6b55b1c4;
			}
			else
			{
				desired_origin = var_d3263bfe.origin + var_3abe10e2;
			}
		}
		player.var_39386de = spawn("script_origin", player.origin);
		player.var_39386de.angles = player.angles;
		player linkto(player.var_39386de);
		player.var_39386de.origin = desired_origin;
		player freezecontrols(1);
		util::wait_network_frame();
		if(isdefined(player))
		{
			util::setclientsysstate("levelNotify", "black_box_start", player);
			player.var_39386de.angles = var_d3263bfe.angles;
		}
	}
	wait(2);
	s_dest thread zm_castle_teleporter::teleport_nuke(undefined, 300);
	for(i = 0; i < level.activeplayers.size; i++)
	{
		util::setclientsysstate("levelNotify", "black_box_end", level.activeplayers[i]);
	}
	util::wait_network_frame();
	if(!isdefined(player))
	{
		return;
	}
	player unlink();
	if(isdefined(player.var_39386de))
	{
		player.var_39386de delete();
		player.var_39386de = undefined;
	}
	visionset_mgr::deactivate("overlay", "zm_factory_teleport", player);
	player enableweapons();
	player enableoffhandweapons();
	player setorigin(s_dest.origin);
	player setplayerangles(s_dest.angles);
	player freezecontrols(0);
	player thread zm_castle_teleporter::teleport_aftereffects();
	player zm_utility::clear_streamer_hint();
}

/*
	Name: function_56e07512
	Namespace: zm_castle_ee_side
	Checksum: 0xB2CA3B4A
	Offset: 0x5468
	Size: 0x17C
	Parameters: 1
	Flags: Linked
*/
function function_56e07512(s_loc)
{
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = 128;
	s_loc.unitrigger_stub.script_height = 128;
	s_loc.unitrigger_stub.script_length = 128;
	s_loc.unitrigger_stub.require_look_at = 1;
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_dbab79d5;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_6527501a);
}

/*
	Name: function_dbab79d5
	Namespace: zm_castle_ee_side
	Checksum: 0x18475529
	Offset: 0x55F0
	Size: 0xA2
	Parameters: 1
	Flags: Linked
*/
function function_dbab79d5(player)
{
	b_is_invis = 0;
	var_f9d5e23a = player hasweapon(getweapon("knife_plunger"));
	if(var_f9d5e23a)
	{
		b_is_invis = 1;
	}
	if(level.var_f4166c4f == 0)
	{
		b_is_invis = 1;
	}
	self setinvisibletoplayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_6527501a
	Namespace: zm_castle_ee_side
	Checksum: 0x76852C8D
	Offset: 0x56A0
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_6527501a()
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.is_drinking > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		var_f9d5e23a = player hasweapon(getweapon("knife_plunger"));
		if(var_f9d5e23a)
		{
			continue;
		}
		if(level.var_f4166c4f == 0)
		{
			continue;
		}
		level thread function_b7365949(self.stub, player);
		break;
	}
}

/*
	Name: function_b7365949
	Namespace: zm_castle_ee_side
	Checksum: 0x41B461DF
	Offset: 0x57A0
	Size: 0x15C
	Parameters: 2
	Flags: Linked
*/
function function_b7365949(trig_stub, player)
{
	level notify(#"hash_4811d22b");
	level.var_163864b7 delete();
	function_421bb7db();
	zm_spawner::register_zombie_death_event_callback(&function_8d95ec46);
	players = level.activeplayers;
	foreach(player in level.activeplayers)
	{
		if(isdefined(player) && isalive(player))
		{
			player thread function_45b9eba4();
		}
	}
	callback::on_spawned(&function_45b9eba4);
	trig_stub zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_45b9eba4
	Namespace: zm_castle_ee_side
	Checksum: 0xE1993545
	Offset: 0x5908
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_45b9eba4()
{
	self.widows_wine_knife_override = &function_9ce92341;
	self zm_melee_weapon::award_melee_weapon("knife_plunger");
	self thread function_9daec9e3();
	self thread function_1fcb04d7();
}

/*
	Name: function_9ce92341
	Namespace: zm_castle_ee_side
	Checksum: 0x99EC1590
	Offset: 0x5980
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_9ce92341()
{
}

/*
	Name: function_1fcb04d7
	Namespace: zm_castle_ee_side
	Checksum: 0xA7186F86
	Offset: 0x5990
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function function_1fcb04d7()
{
	self endon(#"disconnect");
	self waittill(#"bled_out");
	self.widows_wine_knife_override = undefined;
}

/*
	Name: function_9daec9e3
	Namespace: zm_castle_ee_side
	Checksum: 0xD78FFA30
	Offset: 0x59C0
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function function_9daec9e3()
{
	self endon(#"disconnect");
	var_7c4fe278 = getweapon("knife_plunger");
	while(true)
	{
		self waittill(#"weapon_melee", weapon);
		if(weapon == var_7c4fe278 && isdefined(self.var_ea5424ae) && self.var_ea5424ae > 0)
		{
			self clientfield::increment_to_player("plunger_charged_strike");
		}
	}
}

/*
	Name: function_c7bb86e5
	Namespace: zm_castle_ee_side
	Checksum: 0x51532645
	Offset: 0x5A60
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_c7bb86e5(attacker)
{
	if(!isdefined(attacker.var_ea5424ae))
	{
		attacker.var_ea5424ae = 0;
	}
	attacker.var_ea5424ae++;
	/#
		iprintln("" + attacker.var_ea5424ae);
	#/
	wait(60);
	attacker.var_ea5424ae--;
	/#
		iprintln("" + attacker.var_ea5424ae);
	#/
}

/*
	Name: function_8d95ec46
	Namespace: zm_castle_ee_side
	Checksum: 0x671EA8A3
	Offset: 0x5B18
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_8d95ec46(e_attacker)
{
	var_7c4fe278 = getweapon("knife_plunger");
	if(var_7c4fe278 == self.damageweapon)
	{
		self zombie_utility::zombie_head_gib();
		return true;
	}
	return false;
}

/*
	Name: function_f10f1879
	Namespace: zm_castle_ee_side
	Checksum: 0x6770BACD
	Offset: 0x5B80
	Size: 0x16E
	Parameters: 12
	Flags: Linked
*/
function function_f10f1879(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	var_7c4fe278 = getweapon("knife_plunger");
	if(weapon == var_7c4fe278 && isdefined(attacker) && isplayer(attacker) && isdefined(attacker.var_ea5424ae) && attacker.var_ea5424ae > 0)
	{
		damage = 777 * self.health;
		if(isdefined(self))
		{
			self thread function_beeeab78();
		}
		level.var_91b525ed++;
		if(level.var_91b525ed >= 16)
		{
			function_79e1bd74(2);
		}
		else if(level.var_91b525ed >= 4)
		{
			function_79e1bd74(1);
		}
		return damage;
	}
	return -1;
}

/*
	Name: function_beeeab78
	Namespace: zm_castle_ee_side
	Checksum: 0x5FE2D3ED
	Offset: 0x5CF8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_beeeab78()
{
	self clientfield::set("plunger_exploding_ai", 1);
	self zombie_utility::zombie_eye_glow_stop();
	wait(0.15);
	self ghost();
	self util::delay(0.15, undefined, &zm_utility::self_delete);
}

/*
	Name: function_5c600852
	Namespace: zm_castle_ee_side
	Checksum: 0x74117F31
	Offset: 0x5D88
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_5c600852()
{
	level.var_89ad28cd = 0;
	var_d959ac05 = getentarray("hs_gramophone", "targetname");
	array::thread_all(var_d959ac05, &function_db46cccd);
	while(true)
	{
		level waittill(#"hash_9c9fb305");
		if(level.var_89ad28cd == var_d959ac05.size)
		{
			break;
		}
	}
	level thread zm_audio::sndmusicsystem_playstate("requiem");
}

/*
	Name: function_db46cccd
	Namespace: zm_castle_ee_side
	Checksum: 0xAADA0F17
	Offset: 0x5E40
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function function_db46cccd()
{
	self zm_castle_util::create_unitrigger();
	self playloopsound("zmb_ee_gramophone_lp", 1);
	/#
		self thread zm_castle_util::function_8faf1d24(vectorscale((0, 0, 1), 255), "");
	#/
	while(!(isdefined(self.b_activated) && self.b_activated))
	{
		self waittill(#"trigger_activated");
		if(isdefined(level.musicsystem.currentplaytype) && level.musicsystem.currentplaytype >= 4 || (isdefined(level.musicsystemoverride) && level.musicsystemoverride))
		{
			continue;
		}
		if(!(isdefined(self.b_activated) && self.b_activated))
		{
			self.b_activated = 1;
			level.var_89ad28cd++;
			level notify(#"hash_9c9fb305");
			self stoploopsound(0.2);
		}
		self playsound("zmb_ee_gramophone_activate");
	}
	zm_unitrigger::unregister_unitrigger(self.s_unitrigger);
}

/*
	Name: function_553b8e23
	Namespace: zm_castle_ee_side
	Checksum: 0xCBF24F7A
	Offset: 0x5FB8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_553b8e23()
{
	level.var_51d5c50c = 0;
	var_c911c0a2 = struct::get_array("hs_bear", "targetname");
	array::thread_all(var_c911c0a2, &function_4b02c768);
	while(true)
	{
		level waittill(#"hash_c3f82290");
		if(level.var_51d5c50c == var_c911c0a2.size)
		{
			break;
		}
	}
	level thread zm_audio::sndmusicsystem_playstate("dead_again");
	level thread audio::unlockfrontendmusic("mus_dead_again_intro");
}

/*
	Name: function_4b02c768
	Namespace: zm_castle_ee_side
	Checksum: 0xD3BAD858
	Offset: 0x6090
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function function_4b02c768()
{
	e_origin = spawn("script_origin", self.origin);
	e_origin zm_castle_util::create_unitrigger();
	e_origin playloopsound("zmb_ee_bear_lp", 1);
	/#
		e_origin thread zm_castle_util::function_8faf1d24(vectorscale((0, 0, 1), 255), "");
	#/
	while(!(isdefined(e_origin.b_activated) && e_origin.b_activated))
	{
		e_origin waittill(#"trigger_activated");
		if(isdefined(level.musicsystem.currentplaytype) && level.musicsystem.currentplaytype >= 4 || (isdefined(level.musicsystemoverride) && level.musicsystemoverride))
		{
			continue;
		}
		if(!(isdefined(e_origin.b_activated) && e_origin.b_activated))
		{
			e_origin.b_activated = 1;
			level.var_51d5c50c++;
			level notify(#"hash_c3f82290");
			e_origin stoploopsound(0.2);
		}
		e_origin playsound("zmb_ee_bear_activate");
	}
	zm_unitrigger::unregister_unitrigger(e_origin.s_unitrigger);
}

/*
	Name: spare_change
	Namespace: zm_castle_ee_side
	Checksum: 0xFE7F2D97
	Offset: 0x6258
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function spare_change()
{
	a_triggers = getentarray("audio_bump_trigger", "targetname");
	foreach(t_audio_bump in a_triggers)
	{
		if(t_audio_bump.script_sound === "zmb_perks_bump_bottle")
		{
			t_audio_bump thread check_for_change();
		}
	}
}

/*
	Name: check_for_change
	Namespace: zm_castle_ee_side
	Checksum: 0x7E6CF6A0
	Offset: 0x6338
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function check_for_change()
{
	while(true)
	{
		self waittill(#"trigger", e_player);
		if(e_player getstance() == "prone")
		{
			e_player zm_score::add_to_player_score(100);
			zm_utility::play_sound_at_pos("purchase", e_player.origin);
			break;
		}
		wait(0.15);
	}
}

/*
	Name: function_d6026710
	Namespace: zm_castle_ee_side
	Checksum: 0x7DD7519A
	Offset: 0x63E0
	Size: 0x3BC
	Parameters: 0
	Flags: Linked
*/
function function_d6026710()
{
	/#
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_3d627178);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_f0dc1bf3);
		level thread zm_castle_util::setup_devgui_func("", "", 0, &function_3388f3a3);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_3388f3a3);
		level thread zm_castle_util::setup_devgui_func("", "", 2, &function_3388f3a3);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_239f31ac);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_8f84cfff);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_e6679107);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_71626c1a);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_c8b68402);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_14004ce0);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_5b000c75);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_4e8ebeb2);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_d40e8eab);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_ce8b131c);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_71bd024b);
		level thread zm_castle_util::setup_devgui_func("", "", 1, &function_ad9da95f);
	#/
}

/*
	Name: function_f0dc1bf3
	Namespace: zm_castle_ee_side
	Checksum: 0xB21BB1DB
	Offset: 0x67A8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_f0dc1bf3(n_val)
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_3d627178
	Namespace: zm_castle_ee_side
	Checksum: 0xC1D2CE0F
	Offset: 0x67E0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_3d627178(n_val)
{
	/#
		function_90b13c3d();
	#/
}

/*
	Name: function_ce8b131c
	Namespace: zm_castle_ee_side
	Checksum: 0xE52DE3C4
	Offset: 0x6810
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function function_ce8b131c(n_val)
{
	/#
		zm_spawner::register_zombie_death_event_callback(&function_8d95ec46);
		players = level.activeplayers;
		foreach(player in players)
		{
			player thread function_45b9eba4();
		}
	#/
}

/*
	Name: function_3388f3a3
	Namespace: zm_castle_ee_side
	Checksum: 0x352C00E0
	Offset: 0x68E8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_3388f3a3(n_val)
{
	/#
		function_79e1bd74(n_val);
	#/
}

/*
	Name: function_14004ce0
	Namespace: zm_castle_ee_side
	Checksum: 0x154CF854
	Offset: 0x6918
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_14004ce0(n_val)
{
	/#
		function_779bfe1e();
	#/
}

/*
	Name: function_5b000c75
	Namespace: zm_castle_ee_side
	Checksum: 0xE7B76203
	Offset: 0x6948
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_5b000c75(n_val)
{
	/#
		function_421bb7db();
	#/
}

/*
	Name: function_ad9da95f
	Namespace: zm_castle_ee_side
	Checksum: 0x92D0E1DE
	Offset: 0x6978
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_ad9da95f(n_val)
{
	/#
		zm_zonemgr::enable_zone("");
	#/
}

/*
	Name: function_4e8ebeb2
	Namespace: zm_castle_ee_side
	Checksum: 0x6A12EBDD
	Offset: 0x69B0
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function function_4e8ebeb2(n_val)
{
	/#
		players = level.activeplayers;
		foreach(player in players)
		{
			level thread function_27b3a99c(player);
		}
	#/
}

/*
	Name: function_d40e8eab
	Namespace: zm_castle_ee_side
	Checksum: 0x249B36F8
	Offset: 0x6A68
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function function_d40e8eab(n_val)
{
	/#
		players = level.activeplayers;
		foreach(player in players)
		{
			level thread function_c7bb86e5(player);
		}
	#/
}

/*
	Name: function_71bd024b
	Namespace: zm_castle_ee_side
	Checksum: 0x2F8A9BBA
	Offset: 0x6B20
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_71bd024b(n_val)
{
	/#
		level thread function_7c237ecb(1);
	#/
}

/*
	Name: function_239f31ac
	Namespace: zm_castle_ee_side
	Checksum: 0xABDEC8A7
	Offset: 0x6B58
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_239f31ac(n_val)
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_8f84cfff
	Namespace: zm_castle_ee_side
	Checksum: 0x9241B1AE
	Offset: 0x6B90
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_8f84cfff(n_val)
{
	/#
		[[ level.var_9f94326b ]]->function_aa7c5ce2();
	#/
}

/*
	Name: function_e6679107
	Namespace: zm_castle_ee_side
	Checksum: 0xE3690858
	Offset: 0x6BC0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_e6679107(n_val)
{
	/#
		[[ level.var_9f94326b ]]->function_4db73fa1();
	#/
}

/*
	Name: function_71626c1a
	Namespace: zm_castle_ee_side
	Checksum: 0xC2A0917F
	Offset: 0x6BF0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_71626c1a(n_val)
{
	/#
		[[ level.var_9f94326b ]]->function_ec1f5e9(1, 15);
	#/
}

/*
	Name: function_c8b68402
	Namespace: zm_castle_ee_side
	Checksum: 0xC689DB41
	Offset: 0x6C28
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_c8b68402(n_val)
{
	/#
		[[ level.var_9f94326b ]]->function_ec1f5e9(9, 35);
	#/
}

