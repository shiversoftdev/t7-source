// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_craftables;
#using scripts\zm\zm_island_util;
#using scripts\zm\zm_island_vo;

#namespace zm_island_pap_quest;

/*
	Name: main
	Namespace: zm_island_pap_quest
	Checksum: 0x1D8A6296
	Offset: 0x9E0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function main()
{
	function_16f0344e();
	function_d0901c34();
	function_f4a071bb();
	function_4fdc8e70();
}

/*
	Name: init
	Namespace: zm_island_pap_quest
	Checksum: 0xCE15CEEC
	Offset: 0xA30
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("scriptmover", "show_part", 9000, 1, "int");
	clientfield::register("actor", "zombie_splash", 9000, 1, "int");
	clientfield::register("world", "lower_pap_water", 9000, 2, "int");
	/#
		function_7cd896fc();
	#/
}

/*
	Name: function_16f0344e
	Namespace: zm_island_pap_quest
	Checksum: 0x8D3E8B21
	Offset: 0xAE8
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function function_16f0344e()
{
	level flag::init("valve1_found");
	level flag::init("valve2_found");
	level flag::init("valve3_found");
	level flag::init("defend_success");
	level flag::init("pap_water_is_draining");
	level flag::init("pap_water_drained");
	level flag::init("pap_gauge");
	level flag::init("pap_whistle");
	level flag::init("pap_wheel");
	level.var_12542033 = 0;
	foreach(s_valve in struct::get_array("pap_water_control"))
	{
		s_valve thread function_dd9ccb8(s_valve.script_int);
	}
	level thread function_aa37ce2d();
	level scene::add_scene_func("p7_fxanim_zm_island_pap_elements_gauge_bundle", &function_b6d4787d, "init");
	level scene::add_scene_func("p7_fxanim_zm_island_pap_elements_whistle_bundle", &function_e0bc0bdc, "init");
	level scene::add_scene_func("p7_fxanim_zm_island_pap_elements_wheel_bundle", &function_f7c8e279, "init");
	level scene::init("p7_fxanim_zm_island_pap_elements_gauge_bundle");
	level scene::init("p7_fxanim_zm_island_pap_elements_whistle_bundle");
	level scene::init("p7_fxanim_zm_island_pap_elements_wheel_bundle");
	level thread function_851f0b97();
}

/*
	Name: on_player_spawned
	Namespace: zm_island_pap_quest
	Checksum: 0x88DDB86C
	Offset: 0xDE8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread function_145f4b1a();
}

/*
	Name: function_b6d4787d
	Namespace: zm_island_pap_quest
	Checksum: 0xEEB98FA5
	Offset: 0xE10
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_b6d4787d(a_ents)
{
	mdl_part = a_ents["fxanim_pap_elements"];
	mdl_part hidepart("p7_zm_isl_pap_elements_gauge_jnt");
	level flag::wait_till("pap_gauge");
	mdl_part showpart("p7_zm_isl_pap_elements_gauge_jnt");
	wait(1);
	level scene::play("p7_fxanim_zm_island_pap_elements_gauge_bundle");
}

/*
	Name: function_e0bc0bdc
	Namespace: zm_island_pap_quest
	Checksum: 0xB7502AB1
	Offset: 0xEC0
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_e0bc0bdc(a_ents)
{
	mdl_part = a_ents["fxanim_pap_elements"];
	mdl_part hidepart("p7_zm_isl_pap_elements_whistle_jnt");
	level flag::wait_till("pap_whistle");
	mdl_part showpart("p7_zm_isl_pap_elements_whistle_jnt");
	wait(1);
	level scene::play("p7_fxanim_zm_island_pap_elements_whistle_bundle");
}

/*
	Name: function_f7c8e279
	Namespace: zm_island_pap_quest
	Checksum: 0x89649A30
	Offset: 0xF70
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_f7c8e279(a_ents)
{
	mdl_part = a_ents["fxanim_pap_elements"];
	mdl_part hidepart("p7_zm_isl_pap_elements_wheel_jnt");
	level flag::wait_till("pap_wheel");
	mdl_part showpart("p7_zm_isl_pap_elements_wheel_jnt");
	wait(1);
	level scene::play("p7_fxanim_zm_island_pap_elements_wheel_bundle");
}

/*
	Name: function_aa37ce2d
	Namespace: zm_island_pap_quest
	Checksum: 0x1333E8E
	Offset: 0x1020
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function function_aa37ce2d()
{
	var_b1e70b95 = getent("trigger_pap_hint", "targetname");
	var_b1e70b95 setcursorhint("HINT_NOICON");
	var_b1e70b95 sethintstring("");
	mdl_gate = getent("pap_gate", "targetname");
	mdl_gate.s_pos = struct::get(mdl_gate.target);
	level flag::wait_till("pap_water_drained");
	if(zm_utility::is_player_valid(level.var_16e32c2f))
	{
		level.var_16e32c2f notify(#"player_opened_pap");
	}
	mdl_gate moveto(mdl_gate.s_pos.origin, 3);
	mdl_gate playsound("zmb_papquest_gate_move");
	level thread zm_island_vo::function_3bf2d62a("pap_opens", 0, 1, 0);
	mdl_gate waittill(#"movedone");
	level flag::set("pap_open");
	var_b1e70b95 delete();
	t_door = getent("trigger_pap", "script_noteworthy");
	t_door zm_blockers::door_opened(0);
}

/*
	Name: function_4c046b1b
	Namespace: zm_island_pap_quest
	Checksum: 0x46C3C586
	Offset: 0x1238
	Size: 0x256
	Parameters: 0
	Flags: Linked
*/
function function_4c046b1b()
{
	level flag::wait_till_clear("pap_water_is_draining");
	level.var_12542033++;
	switch(level.var_12542033)
	{
		case 1:
		{
			exploder::exploder("fxexp_300");
			break;
		}
		case 2:
		{
			exploder::exploder("fxexp_301");
			break;
		}
		case 3:
		{
			exploder::exploder("fxexp_302");
			level flag::set("pap_water_drained");
			break;
		}
		default:
		{
			break;
		}
	}
	level.pack_a_punch.triggers[0] playsound("zmb_papquest_drain_oneshot");
	level flag::set("pap_water_is_draining");
	level clientfield::set("lower_pap_water", level.var_12542033);
	wait(3);
	level flag::clear("pap_water_is_draining");
	switch(level.var_12542033)
	{
		case 1:
		{
			exploder::exploder_stop("fxexp_300");
			level thread zm_island_vo::function_3bf2d62a("drain_pap", 0, 1, 0);
			break;
		}
		case 2:
		{
			exploder::exploder_stop("fxexp_301");
			level thread zm_island_vo::function_3bf2d62a("drain_pap", 0, 1, 0);
			break;
		}
		case 3:
		{
			exploder::exploder_stop("fxexp_302");
			break;
		}
	}
}

/*
	Name: function_dd9ccb8
	Namespace: zm_island_pap_quest
	Checksum: 0x90894943
	Offset: 0x1498
	Size: 0x224
	Parameters: 1
	Flags: Linked
*/
function function_dd9ccb8(n_id)
{
	if(n_id == 1)
	{
		self.trigger = zm_island_util::spawn_trigger_radius(self.origin, 50, 1, &function_72a105ff);
	}
	else
	{
		if(n_id == 2)
		{
			self.trigger = zm_island_util::spawn_trigger_radius(self.origin, 50, 1, &function_e35907c);
		}
		else
		{
			self.trigger = zm_island_util::spawn_trigger_radius(self.origin, 50, 1, &function_578e801d);
		}
	}
	while(true)
	{
		self.trigger waittill(#"trigger", player);
		if(zm_utility::is_player_valid(player) && level flag::get(self.script_noteworthy))
		{
			zm_unitrigger::unregister_unitrigger(self.trigger);
			self.trigger = undefined;
			player playsound("zmb_papquest_valve_replace");
			level thread function_4c046b1b();
			level.var_16e32c2f = player;
			if(n_id == 1)
			{
				level flag::set("pap_gauge");
			}
			else
			{
				if(n_id == 2)
				{
					level flag::set("pap_wheel");
				}
				else
				{
					level flag::set("pap_whistle");
				}
			}
			break;
		}
	}
}

/*
	Name: function_72a105ff
	Namespace: zm_island_pap_quest
	Checksum: 0xD6F40F17
	Offset: 0x16C8
	Size: 0x42
	Parameters: 1
	Flags: Linked, Private
*/
function private function_72a105ff(e_player)
{
	if(level flag::get("valve1_found"))
	{
		return &"ZM_ISLAND_DRAIN_WATER";
	}
	return &"ZOMBIE_BUILD_PIECE_MORE";
}

/*
	Name: function_e35907c
	Namespace: zm_island_pap_quest
	Checksum: 0xEDF00CBE
	Offset: 0x1718
	Size: 0x42
	Parameters: 1
	Flags: Linked, Private
*/
function private function_e35907c(e_player)
{
	if(level flag::get("valve2_found"))
	{
		return &"ZM_ISLAND_DRAIN_WATER";
	}
	return &"ZOMBIE_BUILD_PIECE_MORE";
}

/*
	Name: function_578e801d
	Namespace: zm_island_pap_quest
	Checksum: 0x14C0791
	Offset: 0x1768
	Size: 0x42
	Parameters: 1
	Flags: Linked, Private
*/
function private function_578e801d(e_player)
{
	if(level flag::get("valve3_found"))
	{
		return &"ZM_ISLAND_DRAIN_WATER";
	}
	return &"ZOMBIE_BUILD_PIECE_MORE";
}

/*
	Name: function_1a519eae
	Namespace: zm_island_pap_quest
	Checksum: 0xAF5617AE
	Offset: 0x17B8
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function function_1a519eae(str_flag)
{
	while(true)
	{
		self.trigger waittill(#"trigger", player);
		if(zm_utility::is_player_valid(player))
		{
			player notify(#"player_got_valve_part");
			zm_unitrigger::unregister_unitrigger(self.trigger);
			player playsound("zmb_valve_pickup");
			level flag::set(str_flag);
			self.trigger = undefined;
			self delete();
			level thread function_90913542(str_flag);
			break;
		}
	}
}

/*
	Name: function_90913542
	Namespace: zm_island_pap_quest
	Checksum: 0x81644225
	Offset: 0x18B0
	Size: 0x2B6
	Parameters: 1
	Flags: Linked
*/
function function_90913542(str_flag)
{
	a_players = [];
	if(self == level)
	{
		a_players = level.players;
	}
	else
	{
		if(isplayer(self))
		{
			a_players = array(self);
		}
		else
		{
			return;
		}
	}
	switch(str_flag)
	{
		case "valve1_found":
		{
			foreach(player in a_players)
			{
				player clientfield::set_to_player("valvethree_part_lever", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.valveone_part_lever", "zmInventory.widget_machinetools_parts", 0);
			}
			break;
		}
		case "valve2_found":
		{
			foreach(player in a_players)
			{
				player clientfield::set_to_player("valveone_part_lever", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.valvetwo_part_lever", "zmInventory.widget_machinetools_parts", 0);
			}
			break;
		}
		case "valve3_found":
		{
			foreach(player in a_players)
			{
				player clientfield::set_to_player("valvetwo_part_lever", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.valvethree_part_lever", "zmInventory.widget_machinetools_parts", 0);
			}
			break;
		}
	}
}

/*
	Name: function_d0901c34
	Namespace: zm_island_pap_quest
	Checksum: 0x539D5C33
	Offset: 0x1B70
	Size: 0x1A2
	Parameters: 0
	Flags: Linked
*/
function function_d0901c34()
{
	level.var_e1bb72d5 = 0;
	level.var_69ca3c45 = 0;
	var_1daee2f1 = getentarray("cocoon_bunker", "targetname");
	foreach(mdl_cocoon in var_1daee2f1)
	{
		mdl_cocoon.is_open = 0;
		mdl_cocoon.clip = getent(mdl_cocoon.target, "targetname");
		mdl_cocoon.var_aa12511 = struct::get(mdl_cocoon.clip.target);
		mdl_cocoon.clip setcandamage(1);
		mdl_cocoon.clip.health = 100000;
		mdl_cocoon scene::init("p7_fxanim_zm_island_cocoon_open_bundle", mdl_cocoon);
		mdl_cocoon thread function_c762197b();
	}
}

/*
	Name: function_c762197b
	Namespace: zm_island_pap_quest
	Checksum: 0x12AE27A
	Offset: 0x1D20
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_c762197b()
{
	self waittill(#"opened");
	if(isdefined(self.clip))
	{
		self.clip connectpaths();
		self.clip delete();
	}
	self.is_open = 1;
	self thread function_7a0ede5();
	var_aa12511 = self.var_aa12511;
	ai_zombie = zombie_utility::spawn_zombie(level.zombie_spawners[0], "cocoon_zombie", var_aa12511);
	if(isdefined(ai_zombie))
	{
		ai_zombie.b_ignore_cleanup = 1;
		ai_zombie.no_damage_points = 1;
		ai_zombie.deathpoints_already_given = 1;
		ai_zombie thread zm_island_util::function_acd04dc9();
		wait(0.1);
		self thread scene::play("zm_dlc2_zombie_spawn_cocoon_v" + (randomint(3) + 1), ai_zombie);
	}
}

/*
	Name: function_bd8082d1
	Namespace: zm_island_pap_quest
	Checksum: 0xDA978203
	Offset: 0x1E88
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_bd8082d1()
{
	var_1daee2f1 = getentarray("cocoon_bunker", "targetname");
	var_d43245b8 = [];
	foreach(mdl_cocoon in var_1daee2f1)
	{
		if(!mdl_cocoon.is_open)
		{
			if(!isdefined(var_d43245b8))
			{
				var_d43245b8 = [];
			}
			else if(!isarray(var_d43245b8))
			{
				var_d43245b8 = array(var_d43245b8);
			}
			var_d43245b8[var_d43245b8.size] = mdl_cocoon;
		}
	}
	var_696dc555 = array::random(var_d43245b8);
	var_696dc555.var_166a0518 = 1;
}

/*
	Name: function_7a0ede5
	Namespace: zm_island_pap_quest
	Checksum: 0x5270CDAF
	Offset: 0x1FE0
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_7a0ede5()
{
	self playloopsound("zmb_cocoon_lp", 1);
	playsoundatposition("evt_cocoon_explode", self.origin + (vectorscale((0, 0, -1), 100)));
	self stoploopsound();
	if(isdefined(self.var_166a0518))
	{
		self function_14c57bc9();
	}
	level.var_e1bb72d5++;
	if(level.var_e1bb72d5 >= 3 && !level.var_69ca3c45)
	{
		level.var_69ca3c45 = 1;
		function_bd8082d1();
	}
}

/*
	Name: function_b09adc86
	Namespace: zm_island_pap_quest
	Checksum: 0xB66053A7
	Offset: 0x20B8
	Size: 0x3E
	Parameters: 1
	Flags: None
*/
function function_b09adc86(str_mod)
{
	if(str_mod == "MOD_MELEE" || zm_utility::is_explosive_damage(str_mod))
	{
		return true;
	}
	return false;
}

/*
	Name: function_14c57bc9
	Namespace: zm_island_pap_quest
	Checksum: 0x43D790DA
	Offset: 0x2100
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_14c57bc9()
{
	mdl_part = util::spawn_model("p7_zm_isl_pap_elements_gauge", self.origin + (vectorscale((0, 0, -1), 154)));
	mdl_part clientfield::set("show_part", 1);
	mdl_part setscale(1.5);
	mdl_part.trigger = zm_island_util::spawn_trigger_radius(mdl_part.origin, 50, 1, &function_9bd3096f);
	mdl_part thread function_1a519eae("valve1_found");
}

/*
	Name: function_9bd3096f
	Namespace: zm_island_pap_quest
	Checksum: 0x37B09B4
	Offset: 0x21E8
	Size: 0x12
	Parameters: 1
	Flags: Linked, Private
*/
function private function_9bd3096f(player)
{
	return &"ZOMBIE_BUILD_PIECE_GRAB";
}

/*
	Name: function_f4a071bb
	Namespace: zm_island_pap_quest
	Checksum: 0x6353BA5
	Offset: 0x2208
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function function_f4a071bb()
{
	level flag::init("defend_over");
	level.mdl_gate = getent("defend_gate", "targetname");
	level.mdl_clip = getent("defend_clip", "targetname");
	level.mdl_clip notsolid();
	level.mdl_clip connectpaths();
	s_part = struct::get("valvethree_part_lever");
	s_pos = struct::get(s_part.target);
	level.var_ced49fc = util::spawn_model("p7_zm_isl_pap_elements_whistle", s_part.origin, s_part.angles);
	level.var_ced49fc setscale(1.5);
	level.var_ced49fc.v_org = s_pos.origin;
	level.var_ced49fc.v_ang = s_pos.angles;
	level.var_ced49fc clientfield::set("show_part", 1);
	level thread defend_start();
}

/*
	Name: defend_start
	Namespace: zm_island_pap_quest
	Checksum: 0x95B89443
	Offset: 0x23E0
	Size: 0x398
	Parameters: 0
	Flags: Linked
*/
function defend_start()
{
	while(!level flag::exists("penstock_debris_cleared"))
	{
		wait(1);
	}
	var_44f2dff7 = struct::get_array("defend_valve_spawnpt");
	level.var_74049442 = 0;
	switch(level.players.size)
	{
		case 1:
		{
			var_4cf30066 = 8;
			break;
		}
		case 2:
		{
			var_4cf30066 = 10;
			break;
		}
		case 3:
		{
			var_4cf30066 = 14;
			break;
		}
		case 4:
		{
			var_4cf30066 = 18;
			break;
		}
	}
	level flag::wait_till("penstock_debris_cleared");
	level.mdl_gate.v_org = level.mdl_gate.origin;
	level.mdl_gate.v_pos = struct::get(level.mdl_gate.target).origin;
	level.mdl_clip solid();
	level.mdl_clip disconnectpaths();
	level.mdl_gate moveto(level.mdl_gate.v_pos, 3);
	level.mdl_gate playsound("zmb_papquest_defend_gate_close");
	exploder::exploder("fxexp_202");
	level.disable_nuke_delay_spawning = 1;
	level flag::clear("spawn_zombies");
	level thread function_3d4e00c();
	exploder::exploder("lgt_penstock_event");
	while(level.var_74049442 < 13)
	{
		var_44f2dff7 = array::randomize(var_44f2dff7);
		for(i = 0; i < var_44f2dff7.size; i++)
		{
			while(getfreeactorcount() < 1)
			{
				wait(0.05);
			}
			while(function_a3ebebe() >= var_4cf30066)
			{
				wait(0.05);
			}
			ai_zombie = zombie_utility::spawn_zombie(level.zombie_spawners[0], "defend_zombie", var_44f2dff7[i]);
			if(isdefined(ai_zombie))
			{
				if(isdefined(var_44f2dff7[i].script_int))
				{
					ai_zombie.var_57b55f08 = 1;
				}
				ai_zombie thread function_2392e644();
				level.var_74049442++;
				if(level.var_74049442 >= 13)
				{
					break;
				}
				wait(1.5);
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_3d4e00c
	Namespace: zm_island_pap_quest
	Checksum: 0x8663754
	Offset: 0x2780
	Size: 0xE6
	Parameters: 0
	Flags: Linked
*/
function function_3d4e00c()
{
	level endon(#"defend_over");
	wait(5);
	while(true)
	{
		n_zombies = function_a3ebebe();
		var_4cba8874 = function_2870b97d();
		if(!n_zombies && level.var_74049442 >= 13 || var_4cba8874.size == 0)
		{
			level thread function_9fcd89f7();
			level.disable_nuke_delay_spawning = 0;
			level flag::set("spawn_zombies");
			level flag::set("defend_over");
		}
		wait(1);
	}
}

/*
	Name: function_9fcd89f7
	Namespace: zm_island_pap_quest
	Checksum: 0xF0570E49
	Offset: 0x2870
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function function_9fcd89f7()
{
	level notify(#"defend_success");
	exploder::exploder("fxexp_201");
	exploder::exploder_stop("lgt_penstock_event");
	level.var_ced49fc moveto(level.var_ced49fc.v_org, 3);
	level.var_ced49fc rotateto(level.var_ced49fc.v_ang, 3);
	level.var_ced49fc waittill(#"movedone");
	level.var_ced49fc.trigger = zm_island_util::spawn_trigger_radius(level.var_ced49fc.origin, 50, 1, &function_9bd3096f);
	level.var_ced49fc thread function_1a519eae("valve3_found");
	level flag::set("defend_success");
	level.mdl_gate moveto(level.mdl_gate.v_org, 3);
	level.mdl_gate playsound("zmb_papquest_defend_gate_open");
	exploder::exploder("fxexp_202");
	level.mdl_gate waittill(#"movedone");
	level.mdl_clip delete();
}

/*
	Name: function_a3ebebe
	Namespace: zm_island_pap_quest
	Checksum: 0xE042DA91
	Offset: 0x2A48
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function function_a3ebebe()
{
	var_ca238230 = 0;
	var_34dc7362 = getent("penstock_defend", "script_noteworthy");
	a_ai_zombies = getaiteamarray(level.zombie_team);
	foreach(ai_zombie in a_ai_zombies)
	{
		if(ai_zombie istouching(var_34dc7362) && isalive(ai_zombie) && ai_zombie.var_6eb9188d === 1)
		{
			var_ca238230++;
		}
	}
	return var_ca238230;
}

/*
	Name: function_2870b97d
	Namespace: zm_island_pap_quest
	Checksum: 0xD744BA4B
	Offset: 0x2B80
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function function_2870b97d()
{
	var_4399a34 = [];
	var_34dc7362 = getent("penstock_defend", "script_noteworthy");
	foreach(player in level.players)
	{
		if(player istouching(var_34dc7362) && zm_utility::is_player_valid(player) && !player laststand::player_is_in_laststand())
		{
			if(!isdefined(var_4399a34))
			{
				var_4399a34 = [];
			}
			else if(!isarray(var_4399a34))
			{
				var_4399a34 = array(var_4399a34);
			}
			var_4399a34[var_4399a34.size] = player;
		}
	}
	return var_4399a34;
}

/*
	Name: function_55dac330
	Namespace: zm_island_pap_quest
	Checksum: 0xC19922
	Offset: 0x2CE8
	Size: 0x15C
	Parameters: 0
	Flags: None
*/
function function_55dac330()
{
	foreach(ai_zombie in getaiteamarray(level.zombie_team))
	{
		ai_zombie ai::set_ignoreall(0);
	}
	iprintlnbold("DEFEND FAILED");
	level.mdl_gate movez(96, 3);
	level.mdl_gate playsound("zmb_papquest_defend_gate_open");
	level.mdl_gate waittill(#"movedone");
	level.mdl_clip movez(96, 3);
	level thread defend_start();
	level flag::set("spawn_zombies");
}

/*
	Name: function_2392e644
	Namespace: zm_island_pap_quest
	Checksum: 0x1AE44FB1
	Offset: 0x2E50
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_2392e644()
{
	self endon(#"death");
	self.var_6eb9188d = 1;
	if(isdefined(self.var_57b55f08))
	{
		self thread function_318ec9ba();
	}
	self waittill(#"completed_emerging_into_playable_area");
	self.no_damage_points = 1;
	self.deathpoints_already_given = 1;
	self.no_powerups = 1;
	self.ignore_enemy_count = 1;
	self.script_string = "find_flesh";
}

/*
	Name: function_318ec9ba
	Namespace: zm_island_pap_quest
	Checksum: 0x2049C179
	Offset: 0x2EE0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_318ec9ba()
{
	self endon(#"death");
	trigger::wait_till("trigger_penstock_water", "targetname", self);
	self clientfield::set("zombie_splash", 1);
}

/*
	Name: function_83af0b87
	Namespace: zm_island_pap_quest
	Checksum: 0xD7D0724A
	Offset: 0x2F40
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function function_83af0b87(t_water)
{
	self endon(#"death");
	while(true)
	{
		while(!self istouching(t_water))
		{
			wait(0.1);
		}
		if(!self.is_underwater)
		{
			self.is_underwater = 1;
			self asmsetanimationrate(0.8);
		}
		while(self istouching(t_water))
		{
			wait(0.1);
		}
		self.is_underwater = 0;
		self asmsetanimationrate(1);
		wait(0.1);
	}
}

/*
	Name: function_4fdc8e70
	Namespace: zm_island_pap_quest
	Checksum: 0x33717E3C
	Offset: 0x3020
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function function_4fdc8e70()
{
	level flag::wait_till("connect_bunker_exterior_to_bunker_interior");
	var_f89319f8 = struct::get_array("valvetwo_part_lever");
	mdl_part = util::spawn_model("p7_zm_isl_pap_elements_wheel", array::random(var_f89319f8).origin);
	mdl_part clientfield::set("show_part", 1);
	mdl_part setscale(1.5);
	mdl_part.trigger = zm_island_util::spawn_trigger_radius(mdl_part.origin, 50, 1, &function_9bd3096f);
	mdl_part thread function_1a519eae("valve2_found");
}

/*
	Name: function_851f0b97
	Namespace: zm_island_pap_quest
	Checksum: 0xDAC05AF1
	Offset: 0x3158
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_851f0b97()
{
	var_1af0fcd8 = getent("bunker_penstock_blue_sign_reveal", "targetname");
	var_1af0fcd8 clientfield::set("do_emissive_material", 0);
}

/*
	Name: function_145f4b1a
	Namespace: zm_island_pap_quest
	Checksum: 0x1332F842
	Offset: 0x31B0
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_145f4b1a()
{
	self endon(#"disconnect");
	level endon(#"hash_62f73de6");
	var_1af0fcd8 = getent("bunker_penstock_blue_sign_reveal", "targetname");
	self zm_island_util::function_7448e472(var_1af0fcd8);
	var_1af0fcd8 thread function_336744d2();
}

/*
	Name: function_336744d2
	Namespace: zm_island_pap_quest
	Checksum: 0x51C31969
	Offset: 0x3238
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_336744d2()
{
	callback::remove_on_spawned(&on_player_spawned);
	level notify(#"hash_62f73de6");
	self clientfield::set("do_emissive_material", 1);
}

/*
	Name: function_7cd896fc
	Namespace: zm_island_pap_quest
	Checksum: 0xBA8B39B2
	Offset: 0x3298
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_7cd896fc()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_9e3140d6);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: function_9e3140d6
	Namespace: zm_island_pap_quest
	Checksum: 0x76A27351
	Offset: 0x3318
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_9e3140d6(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				level flag::set("");
				level thread function_90913542("");
				return true;
			}
			case "":
			{
				level flag::set("");
				level thread function_90913542("");
				return true;
			}
			case "":
			{
				level flag::set("");
				level thread function_90913542("");
				return true;
			}
		}
		return false;
	#/
}

