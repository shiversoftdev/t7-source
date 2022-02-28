// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_dragon_strike;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_stalingrad_dragon;
#using scripts\zm\zm_stalingrad_dragon_strike;
#using scripts\zm\zm_stalingrad_drop_pods;
#using scripts\zm\zm_stalingrad_ee_main;
#using scripts\zm\zm_stalingrad_finger_trap;
#using scripts\zm\zm_stalingrad_pap_quest;
#using scripts\zm\zm_stalingrad_util;

#namespace zm_stalingrad_devgui;

/*
	Name: function_91912a79
	Namespace: zm_stalingrad_devgui
	Checksum: 0xA3B3488F
	Offset: 0x338
	Size: 0x434
	Parameters: 0
	Flags: Linked
*/
function function_91912a79()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_17d8768b);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		if(getdvarint("") > 0)
		{
			level thread function_867cb8b1();
		}
	#/
}

/*
	Name: function_867cb8b1
	Namespace: zm_stalingrad_devgui
	Checksum: 0xB8C147CA
	Offset: 0x778
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function function_867cb8b1()
{
	/#
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: function_17d8768b
	Namespace: zm_stalingrad_devgui
	Checksum: 0xE0E6B68
	Offset: 0x910
	Size: 0x7AE
	Parameters: 1
	Flags: Linked
*/
function function_17d8768b(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				level thread function_2b22d1f9();
				return true;
			}
			case "":
			{
				level thread function_a7e8b47b();
				return true;
			}
			case "":
			{
				level thread function_31f1d173(0);
				return true;
			}
			case "":
			{
				level thread function_31f1d173(1);
				return true;
			}
			case "":
			{
				level thread function_31f1d173(2);
				return true;
			}
			case "":
			{
				level thread function_31f1d173(3);
				return true;
			}
			case "":
			{
				level thread function_cc40b263();
				return true;
			}
			case "":
			case "":
			case "":
			case "":
			case "":
			case "":
			case "":
			case "":
			case "":
			case "":
			case "":
			case "":
			{
				level.var_8cc024f2 = level.var_583e4a97.var_5d8406ed[cmd];
				level thread namespace_2e6e7fce::function_d1a91c4f(level.var_8cc024f2);
				return true;
			}
			case "":
			{
				level thread dragon::function_16734812();
				return true;
			}
			case "":
			{
				level thread dragon::function_e7982921();
				return true;
			}
			case "":
			{
				level thread dragon::function_cfe0d523();
				return true;
			}
			case "":
			{
				level thread dragon::function_5f0cb06e();
				return true;
			}
			case "":
			{
				level thread dragon::function_84bd37c8();
				return true;
			}
			case "":
			{
				level thread dragon::dragon_hazard_library();
				return true;
			}
			case "":
			{
				level thread dragon::function_7977857();
				return true;
			}
			case "":
			{
				level thread dragon::function_b8de630a();
				return true;
			}
			case "":
			{
				level thread dragon::function_941c2339();
				return true;
			}
			case "":
			{
				level thread dragon::function_ef4a09c3();
				return true;
			}
			case "":
			{
				level thread dragon::function_c09859f();
				return true;
			}
			case "":
			{
				level thread dragon::function_372d0868();
				break;
			}
			case "":
			{
				level thread dragon::function_21b70393();
				break;
			}
			case "":
			{
				level thread dragon::function_482eea0f(1);
				break;
			}
			case "":
			{
				level thread dragon::function_482eea0f(2);
				break;
			}
			case "":
			{
				level thread dragon::function_482eea0f(3);
				break;
			}
			case "":
			{
				level thread dragon::function_482eea0f(4);
				break;
			}
			case "":
			{
				level notify(#"hash_2b2c1420");
				break;
			}
			case "":
			{
				level thread function_4b210fe6();
				return true;
			}
			case "":
			{
				level thread function_4b210fe6("");
				return true;
			}
			case "":
			{
				level thread function_4b210fe6("");
				return true;
			}
			case "":
			{
				level thread function_4b210fe6("");
				return true;
			}
			case "":
			{
				level thread function_a5a0adb4();
				return true;
			}
			case "":
			{
				level thread function_bf490b3c();
				return true;
			}
			case "":
			{
				level thread function_1b0d61c5();
				return true;
			}
			case "":
			{
				level thread function_fd68eee0();
				return true;
			}
			case "":
			{
				level thread zm_stalingrad_finger_trap::function_ddb9991b();
				return true;
			}
			case "":
			{
				level thread zm_stalingrad_finger_trap::function_fc99caf5();
				return true;
			}
			case "":
			{
				level flag::set("");
				level flag::set("");
				util::wait_network_frame();
				level notify(#"hash_68bf9f79");
				util::wait_network_frame();
				level notify(#"hash_b227a45b");
				util::wait_network_frame();
				level notify(#"hash_9b46a273");
				return true;
			}
			case "":
			{
				level flag::set("");
				level flag::set("");
				return true;
			}
			case "":
			{
				level flag::set("");
				level flag::set("");
				return true;
			}
			case "":
			{
				level flag::set("");
				level flag::set("");
				level notify(#"hash_b7bed0ed");
				return true;
			}
			case "":
			{
				function_c072d3dc();
				return true;
			}
			case "":
			{
				function_4be43f4d();
				return true;
			}
			case "":
			{
				function_354ff582();
				return true;
			}
			case "":
			{
				function_f0aaa402();
				return true;
			}
			case "":
			{
				function_b221d46();
				return true;
			}
			default:
			{
				return false;
			}
		}
	#/
}

/*
	Name: function_2b22d1f9
	Namespace: zm_stalingrad_devgui
	Checksum: 0x39A2B7B6
	Offset: 0x10C8
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_2b22d1f9()
{
	/#
		level flag::set("");
		s_pavlov_player = struct::get_array("", "");
		var_9544a498 = 0;
		foreach(player in level.activeplayers)
		{
			player setorigin(s_pavlov_player[var_9544a498].origin);
			player setplayerangles(s_pavlov_player[var_9544a498].angles);
		}
		level flag::set("");
	#/
}

/*
	Name: function_cc40b263
	Namespace: zm_stalingrad_devgui
	Checksum: 0xCF7324AB
	Offset: 0x1210
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_cc40b263()
{
	/#
		if(isdefined(level.var_8cc024f2))
		{
			iprintlnbold("");
			return false;
		}
		level zm_stalingrad_pap::function_809fbbff();
	#/
}

/*
	Name: function_a7e8b47b
	Namespace: zm_stalingrad_devgui
	Checksum: 0x794C1EE5
	Offset: 0x1260
	Size: 0x7D8
	Parameters: 0
	Flags: Linked
*/
function function_a7e8b47b()
{
	/#
		var_1a0a3da9 = getentarray("", "");
		var_ff1b68c0 = getent("", "");
		a_e_collision = getentarray("", "");
		var_50e0150f = getentarray("", "");
		var_b9e116c5 = getentarray("", "");
		var_6f3f4356 = getnodearray("", "");
		if(level.var_de98e3ce.gates_open)
		{
			level.var_de98e3ce.gates_open = 0;
			foreach(e_collision in a_e_collision)
			{
				e_collision movez(600, 0.1);
				e_collision disconnectpaths();
			}
			foreach(e_gate in var_50e0150f)
			{
				e_gate movez(600, 0.25);
			}
			foreach(e_door in var_1a0a3da9)
			{
				e_door movex(114, 1);
				e_door disconnectpaths();
			}
			foreach(e_hatch in var_b9e116c5)
			{
				e_hatch rotateroll(-90, 1);
			}
			foreach(var_b0a376a4 in var_6f3f4356)
			{
				unlinktraversal(var_b0a376a4);
			}
			var_ff1b68c0 movey(-84, 1);
			level thread scene::play("");
		}
		else
		{
			level.var_de98e3ce.gates_open = 1;
			foreach(e_collision in a_e_collision)
			{
				e_collision connectpaths();
				e_collision movez(-600, 0.1);
			}
			foreach(e_gate in var_50e0150f)
			{
				e_gate movez(-600, 0.25);
			}
			foreach(e_door in var_1a0a3da9)
			{
				e_door movex(-114, 1);
				e_door connectpaths();
			}
			foreach(e_hatch in var_b9e116c5)
			{
				e_hatch rotateroll(90, 1);
			}
			foreach(var_b0a376a4 in var_6f3f4356)
			{
				linktraversal(var_b0a376a4);
			}
			var_ff1b68c0 movey(84, 1);
			var_21ce8765 = getent("", "");
			var_21ce8765 thread scene::play("");
		}
		return true;
	#/
}

/*
	Name: function_31f1d173
	Namespace: zm_stalingrad_devgui
	Checksum: 0xC241E14C
	Offset: 0x1A48
	Size: 0x234
	Parameters: 1
	Flags: Linked
*/
function function_31f1d173(var_41ef115f)
{
	/#
		level notify(#"hash_31f1d173");
		wait(1);
		switch(var_41ef115f)
		{
			case 0:
			{
				var_e0320b0b = 1;
				var_6e2a9bd0 = 2;
				n_exploder = 1;
				break;
			}
			case 1:
			{
				var_e0320b0b = 0;
				var_6e2a9bd0 = 2;
				n_exploder = 2;
				break;
			}
			case 2:
			{
				var_e0320b0b = 0;
				var_6e2a9bd0 = 1;
				n_exploder = 3;
				break;
			}
			case 3:
			{
				var_e0320b0b = 0;
				var_6e2a9bd0 = 1;
				var_942d1639 = 2;
				n_exploder = 4;
				break;
			}
		}
		level thread zm_stalingrad_pap::function_187a933f(var_e0320b0b);
		level thread zm_stalingrad_pap::function_187a933f(var_6e2a9bd0);
		if(isdefined(var_942d1639))
		{
			level thread zm_stalingrad_pap::function_187a933f(var_942d1639);
		}
		exploder::exploder("");
		exploder::exploder("" + n_exploder);
		level util::waittill_any_timeout(20, "");
		level thread zm_stalingrad_pap::function_a71517e1(var_e0320b0b);
		level thread zm_stalingrad_pap::function_a71517e1(var_6e2a9bd0);
		if(isdefined(var_942d1639))
		{
			level thread zm_stalingrad_pap::function_a71517e1(var_942d1639);
		}
		exploder::kill_exploder("" + n_exploder);
		exploder::kill_exploder("");
	#/
}

/*
	Name: function_4b210fe6
	Namespace: zm_stalingrad_devgui
	Checksum: 0xBA4A5A60
	Offset: 0x1C88
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function function_4b210fe6(var_b87a2184)
{
	/#
		dragon::function_30560c4b();
		dragon::function_cf119cfd();
		level flag::set("");
		level zm_stalingrad_util::function_3804dbf1();
		zm_stalingrad_util::function_adf4d1d0();
		if(isdefined(level.var_ef9c43d7))
		{
			if(isdefined(level.var_ef9c43d7.var_fa4643fb))
			{
				level.var_ef9c43d7.var_fa4643fb delete();
			}
			level.var_ef9c43d7 delete();
			level.var_ef9c43d7 = undefined;
		}
		level zm_zonemgr::enable_zone("");
		if(isdefined(var_b87a2184))
		{
			level flag::init("");
			level flag::init(var_b87a2184, 1);
		}
	#/
}

/*
	Name: function_a5a0adb4
	Namespace: zm_stalingrad_devgui
	Checksum: 0x63B0C4F2
	Offset: 0x1DD8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_a5a0adb4()
{
	/#
		if(level flag::get(""))
		{
			level zm_ai_raps::special_raps_spawn(6);
		}
		else
		{
			iprintlnbold("");
		}
	#/
}

/*
	Name: function_bf490b3c
	Namespace: zm_stalingrad_devgui
	Checksum: 0x1EF3FC2C
	Offset: 0x1E40
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_bf490b3c()
{
	/#
		level endon(#"_zombie_game_over");
		level flag::wait_till("");
		while(!isdefined(level.var_cf6e9729))
		{
			wait(0.05);
		}
		level.var_cf6e9729.var_65850094[1] = 1;
		level.var_cf6e9729.var_65850094[2] = 1;
		level.var_cf6e9729.var_65850094[3] = 1;
		level.var_cf6e9729.var_65850094[4] = 1;
		level.var_cf6e9729.var_65850094[5] = 1;
		level.var_cf6e9729.var_dad3d9bd = 9999999;
	#/
}

/*
	Name: function_1b0d61c5
	Namespace: zm_stalingrad_devgui
	Checksum: 0xF200CBC8
	Offset: 0x1F30
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_1b0d61c5()
{
	/#
		level flag::clear("");
		foreach(e_player in level.players)
		{
			e_player namespace_19e79ea1::function_8258d71c();
		}
	#/
}

/*
	Name: function_fd68eee0
	Namespace: zm_stalingrad_devgui
	Checksum: 0x3CBDE1E7
	Offset: 0x1FE8
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function function_fd68eee0()
{
	/#
		level flag::set("");
		foreach(e_player in level.players)
		{
			e_player namespace_19e79ea1::function_8258d71c();
		}
	#/
}

/*
	Name: function_c072d3dc
	Namespace: zm_stalingrad_devgui
	Checksum: 0xCE313653
	Offset: 0x20A0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_c072d3dc()
{
	/#
		luinotifyevent(&"", 1, 1);
	#/
}

/*
	Name: function_4be43f4d
	Namespace: zm_stalingrad_devgui
	Checksum: 0x9F30D1CD
	Offset: 0x20D8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_4be43f4d()
{
	/#
		luinotifyevent(&"", 1, 0);
	#/
}

/*
	Name: function_354ff582
	Namespace: zm_stalingrad_devgui
	Checksum: 0xACB0A3F5
	Offset: 0x2108
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_354ff582()
{
	/#
		level clientfield::set("", int(((level.time - level.n_gameplay_start_time) + 500) / 1000));
		level clientfield::set("", level.round_number);
	#/
}

/*
	Name: function_f0aaa402
	Namespace: zm_stalingrad_devgui
	Checksum: 0xCBAAFD63
	Offset: 0x2190
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_f0aaa402()
{
	/#
		level clientfield::set("", int(((level.time - level.n_gameplay_start_time) + 500) / 1000));
	#/
}

/*
	Name: function_b221d46
	Namespace: zm_stalingrad_devgui
	Checksum: 0x27E7B5A8
	Offset: 0x21F0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_b221d46()
{
	/#
		level clientfield::set("", int(((level.time - level.n_gameplay_start_time) + 500) / 1000));
	#/
}

