// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_genesis_pap_quest;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_apothicon_god;

/*
	Name: main
	Namespace: zm_genesis_apothicon_god
	Checksum: 0xD27640A5
	Offset: 0x550
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level flag::init("apothicon_near_trap");
	level flag::init("apothicon_trapped");
	level flag::init("pap_room_open");
	level thread function_e30ec73e();
}

/*
	Name: function_6dd507bc
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x49463E
	Offset: 0x5D8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_6dd507bc()
{
	self endon(#"death");
	level endon(#"apothicon_trapped");
	while(true)
	{
		if(isdefined(level.hostmigrationtimer) && level.hostmigrationtimer)
		{
			util::wait_network_frame();
			continue;
		}
		self function_3dd4e95e("zm_genesis_apothicon_rumble");
		wait(0.1);
		while(level flag::get("apothicon_near_trap"))
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: function_16364bba
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x28B39E5D
	Offset: 0x6A0
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function function_16364bba()
{
	for(i = 0; i < 5; i++)
	{
		self waittill(#"hash_b58a19d3");
		self function_3dd4e95e("zm_genesis_apothicon_roar");
	}
	self waittill(#"hash_c091a029");
	while(!level flag::get("pap_room_open"))
	{
		self function_3dd4e95e("zm_genesis_apothicon_rumble");
		wait(0.1);
	}
}

/*
	Name: function_3dd4e95e
	Namespace: zm_genesis_apothicon_god
	Checksum: 0xA89A3415
	Offset: 0x758
	Size: 0x10A
	Parameters: 1
	Flags: Linked
*/
function function_3dd4e95e(str_rumble)
{
	self endon(#"death");
	level endon(#"apothicon_trapped");
	n_max_dist_sq = 5000 * 5000;
	foreach(e_player in level.activeplayers)
	{
		n_dist = distancesquared(e_player.origin, self.origin);
		if(n_dist < n_max_dist_sq)
		{
			self playrumbleonentity(str_rumble);
		}
	}
}

/*
	Name: function_e30ec73e
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x306AE56A
	Offset: 0x870
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_e30ec73e()
{
	s_start = struct::get("apothicon_intro_bundle");
	scene::add_scene_func("cin_genesis_apothicon_papintro", &function_860971ff, "play");
	scene::add_scene_func("cin_genesis_apothicon_papintro", &function_a2294b99, "done");
	level thread scene::init("cin_genesis_apothicon_papintro");
	level waittill(#"start_zombie_round_logic");
	level thread function_4fa16b52();
	wait(3);
	level thread scene::play("cin_genesis_apothicon_papintro");
}

/*
	Name: function_860971ff
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x35CD083C
	Offset: 0x968
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_860971ff(a_ents)
{
	level.var_e7e8e5d6 = a_ents["zm_apothicon_god"];
	level.var_e7e8e5d6 thread function_6dd507bc();
}

/*
	Name: function_a2294b99
	Namespace: zm_genesis_apothicon_god
	Checksum: 0xCC3DDABA
	Offset: 0x9B0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_a2294b99(a_ents)
{
	a_ents["zm_apothicon_god"] thread function_65305393();
}

/*
	Name: function_4fa16b52
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x9D72E5E1
	Offset: 0x9E8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_4fa16b52()
{
	var_446599c2 = struct::get("apothicon_trap_trig", "targetname");
	var_e80ed647 = struct::get("apothicon_trap_door", "targetname");
	if(isdefined(var_446599c2.script_flag) && !isdefined(level.flag[var_446599c2.script_flag]))
	{
		level flag::init(var_446599c2.script_flag);
	}
	var_446599c2 thread function_d5419c08();
	var_cf61f0f8 = var_e80ed647 zm_unitrigger::create_unitrigger(&"ZM_GENESIS_APOTHICON_DOOR", 128, &function_d9879865, undefined, "unitrigger_radius");
	var_cf61f0f8 thread function_16d77af();
}

/*
	Name: function_d5419c08
	Namespace: zm_genesis_apothicon_god
	Checksum: 0xFAA8D5D
	Offset: 0xB18
	Size: 0x21A
	Parameters: 0
	Flags: Linked
*/
function function_d5419c08()
{
	s_unitrigger = self zm_unitrigger::create_dyn_unitrigger(&"ZM_GENESIS_APOTHICON_TRAP_READY", undefined, &function_f94d9124);
	s_unitrigger.inactive_reassess_time = 0.1;
	a_e_parts = getentarray(self.target, "targetname");
	foreach(e_part in a_e_parts)
	{
		if(e_part.script_noteworthy === "clip")
		{
			s_unitrigger.e_clip = e_part;
			continue;
		}
		s_unitrigger.e_door = e_part;
	}
	self thread function_a15e0860(s_unitrigger);
	if(1)
	{
		for(;;)
		{
			self waittill(#"trigger_activated", e_player);
		}
		if(!level flag::get("apothicon_near_trap"))
		{
		}
		playsoundatposition("zmb_deathray_activate_console", self.origin);
		exploder::exploder("fxexp_361");
		level function_73f1531();
		e_player notify(#"gen_pos");
		if(isdefined(self.script_flag))
		{
			level flag::set(self.script_flag);
		}
		return;
	}
}

/*
	Name: function_a15e0860
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x71C7CC51
	Offset: 0xD40
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_a15e0860(s_unitrigger)
{
	level flag::wait_till(self.script_flag);
	s_unitrigger.e_clip delete();
	zm_unitrigger::unregister_unitrigger(s_unitrigger);
}

/*
	Name: function_f94d9124
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x8A6AA93
	Offset: 0xDB0
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function function_f94d9124(e_player)
{
	if(level flag::get("apothicon_trapped") || !level flag::get("apothicon_near_trap"))
	{
		self sethintstring(&"");
		return false;
	}
	self sethintstring(&"ZM_GENESIS_APOTHICON_TRAP_READY");
	return true;
}

/*
	Name: function_d9879865
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x2D596DDD
	Offset: 0xE48
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function function_d9879865(e_player)
{
	if(level flag::get("apothicon_trapped"))
	{
		self sethintstring(&"");
		return false;
	}
	self sethintstring(&"ZM_GENESIS_APOTHICON_DOOR");
	return true;
}

/*
	Name: function_16d77af
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x147F592D
	Offset: 0xEC0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_16d77af()
{
	level flag::wait_till("apothicon_trapped");
	zm_unitrigger::unregister_unitrigger(self);
}

/*
	Name: function_65305393
	Namespace: zm_genesis_apothicon_god
	Checksum: 0xC232F695
	Offset: 0xF08
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_65305393()
{
	self thread function_3187e8a6();
	function_d6eeedf0(0);
	level flag::wait_till("all_power_on");
	self thread function_b89b1260();
}

/*
	Name: function_d6eeedf0
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x9B67BF19
	Offset: 0xF80
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_d6eeedf0(n_state)
{
	var_329d83b2 = getent("tesla_trap_console", "targetname");
	if(n_state == 0)
	{
		var_329d83b2 showpart("j_flash_off");
		var_329d83b2 hidepart("j_flash_on");
	}
	else
	{
		var_329d83b2 showpart("j_flash_off");
		var_329d83b2 hidepart("j_flash_on");
	}
}

/*
	Name: function_81a3e18f
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x64C2FEFF
	Offset: 0x1050
	Size: 0xC6
	Parameters: 1
	Flags: Linked
*/
function function_81a3e18f(b_on)
{
	for(i = 1; i <= 4; i++)
	{
		if(b_on)
		{
			self showpart("j_flash_0" + i);
			self hidepart("j_green_0" + i);
			continue;
		}
		self hidepart("j_flash_0" + i);
		self showpart("j_green_0" + i);
	}
}

/*
	Name: function_78f98ad9
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x12A52B91
	Offset: 0x1120
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function function_78f98ad9()
{
	var_329d83b2 = getent("tesla_trap_console", "targetname");
	var_329d83b2 function_81a3e18f(1);
	var_329d83b2 function_d6eeedf0(1);
	var_329d83b2 playsound("zmb_deathray_console_ready");
	while(level flag::get("apothicon_near_trap"))
	{
		for(i = 1; i < 5; i++)
		{
			hidemiscmodels("apothicon_trap_power_on" + i);
			showmiscmodels("apothicon_trap_power_off" + i);
		}
		wait(0.2);
		for(i = 1; i < 5; i++)
		{
			hidemiscmodels("apothicon_trap_power_off" + i);
			showmiscmodels("apothicon_trap_power_on" + i);
		}
		wait(0.2);
		if(level flag::get("apothicon_trapped"))
		{
			break;
		}
	}
	var_329d83b2 function_d6eeedf0(0);
	var_329d83b2 function_81a3e18f(0);
	var_329d83b2 playsound("zmb_deathray_console_unavailable");
}

/*
	Name: function_b89b1260
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x901D033E
	Offset: 0x1328
	Size: 0x18A
	Parameters: 0
	Flags: Linked
*/
function function_b89b1260()
{
	level endon(#"hash_b89b1260");
	level endon(#"apothicon_trapped");
	var_217ba6c8 = struct::get("apothicon_approach_tesla", "targetname");
	var_329d83b2 = getent("tesla_trap_console", "targetname");
	while(true)
	{
		level waittill(#"hash_864571db");
		playsoundatposition("evt_apothicon_alarm", (714, 303, 91));
		level flag::set("apothicon_near_trap");
		level thread function_78f98ad9();
		/#
		#/
		level waittill(#"hash_53fb6fd3");
		level flag::clear("apothicon_near_trap");
		for(i = 1; i < 5; i++)
		{
			hidemiscmodels("apothicon_trap_power_off" + i);
			showmiscmodels("apothicon_trap_power_on" + i);
		}
	}
}

/*
	Name: function_3187e8a6
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x96138B2A
	Offset: 0x14C0
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_3187e8a6()
{
	level endon(#"apothicon_trapped");
	while(true)
	{
		level scene::play("cin_genesis_apothicon_flightpath", self);
		level function_1ff56fb0("cin_genesis_apothicon_flightpath");
	}
}

/*
	Name: function_73f1531
	Namespace: zm_genesis_apothicon_god
	Checksum: 0xE147CB38
	Offset: 0x1520
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_73f1531()
{
	level flag::set("apothicon_trapped");
	for(i = 1; i < 5; i++)
	{
		hidemiscmodels("apothicon_trap_power_off" + i);
		showmiscmodels("apothicon_trap_power_on" + i);
	}
	level notify(#"hash_b89b1260");
	level.var_e7e8e5d6 thread function_3dd4e95e("zm_genesis_apothicon_roar");
	level waittill(#"hash_18a15850");
	level.var_e7e8e5d6 thread function_16364bba();
	level scene::play("cin_genesis_apothicon_electrocution_trap", level.var_e7e8e5d6);
	level flag::set("pap_room_open");
	namespace_3ddd867f::function_8d5c3682();
}

/*
	Name: function_1ff56fb0
	Namespace: zm_genesis_apothicon_god
	Checksum: 0x60042743
	Offset: 0x1668
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_1ff56fb0(str_scene)
{
	s_scene = struct::get(str_scene, "scriptbundlename");
	if(isdefined(s_scene))
	{
		s_scene.scene_played = 0;
	}
}

