// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\margwa;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_margwa;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_glaive;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_zod_smashables;
#using scripts\zm\zm_zod_util;
#using scripts\zm\zm_zod_vo;

#using_animtree("generic");

#namespace zm_zod_sword;

/*
	Name: __init__sytem__
	Namespace: zm_zod_sword
	Checksum: 0x9E699491
	Offset: 0xDF0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_sword", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_sword
	Checksum: 0x48242844
	Offset: 0xE38
	Size: 0x4B4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "zod_egg_glow", 1, 1, "int");
	clientfield::register("scriptmover", "zod_egg_soul", 1, 1, "int");
	clientfield::register("scriptmover", "sword_statue_glow", 1, 1, "int");
	n_bits = getminbitcountfornum(5);
	clientfield::register("toplayer", "magic_circle_state_0", 1, n_bits, "int");
	clientfield::register("toplayer", "magic_circle_state_1", 1, n_bits, "int");
	clientfield::register("toplayer", "magic_circle_state_2", 1, n_bits, "int");
	clientfield::register("toplayer", "magic_circle_state_3", 1, n_bits, "int");
	n_bits = getminbitcountfornum(9);
	clientfield::register("world", "keeper_quest_state_0", 1, n_bits, "int");
	clientfield::register("world", "keeper_quest_state_1", 1, n_bits, "int");
	clientfield::register("world", "keeper_quest_state_2", 1, n_bits, "int");
	clientfield::register("world", "keeper_quest_state_3", 1, n_bits, "int");
	n_bits = getminbitcountfornum(4);
	clientfield::register("world", "keeper_egg_location_0", 1, n_bits, "int");
	clientfield::register("world", "keeper_egg_location_1", 1, n_bits, "int");
	clientfield::register("world", "keeper_egg_location_2", 1, n_bits, "int");
	clientfield::register("world", "keeper_egg_location_3", 1, n_bits, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL1_SWORD_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL1_EGG_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL2_SWORD_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_LVL2_EGG_PICKUP", 1, 1, "int");
	callback::on_connect(&on_player_connect);
	callback::on_disconnect(&on_player_disconnect);
	callback::on_spawned(&on_player_spawned);
	zm_zod_util::on_zombie_killed(&on_zombie_killed);
	zm_zod_util::on_player_bled_out(&on_bled_out);
	/#
		level thread sword_devgui();
	#/
}

/*
	Name: function_541cb3c4
	Namespace: zm_zod_sword
	Checksum: 0x53C95607
	Offset: 0x12F8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_541cb3c4()
{
	s_initial = getent("initial_egg_statue", "script_noteworthy");
	level.sword_quest.eggs[self.characterindex] setmodel(level.sword_quest.egg_models[0]);
	self function_abf3df35(s_initial.statue_id);
	self clientfield::set_player_uimodel("zmInventory.player_sword_quest_egg_state", 0);
}

/*
	Name: function_7f334fcd
	Namespace: zm_zod_sword
	Checksum: 0x30CEDE2D
	Offset: 0x13B0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function function_7f334fcd()
{
	self clientfield::set_player_uimodel("zmInventory.player_sword_quest_egg_state", 0);
}

/*
	Name: reset_sword
	Namespace: zm_zod_sword
	Checksum: 0x97DE3266
	Offset: 0x13E0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function reset_sword(b_show)
{
	level.sword_quest.swords[self.characterindex] show();
}

/*
	Name: __main__
	Namespace: zm_zod_sword
	Checksum: 0x738C8EBC
	Offset: 0x1428
	Size: 0x76C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level.sword_quest = spawnstruct();
	level.sword_quest.weapons = [];
	for(i = 0; i < 4; i++)
	{
		level.sword_quest.weapons[i] = [];
		level.sword_quest.weapons[i][1] = getweapon(("glaive_apothicon" + "_") + i);
		level.sword_quest.weapons[i][2] = getweapon(("glaive_keeper" + "_") + i);
		foreach(wpn in level.sword_quest.weapons[i])
		{
			/#
				assert(wpn != level.weaponnone);
			#/
		}
	}
	level.sword_quest.statues = getentarray("sword_upgrade_statue", "targetname");
	level.sword_quest.var_e91b9e85 = [];
	level.sword_quest.var_e91b9e85[0] = "wpn_t7_zmb_zod_sword1_box_no_egg_world";
	level.sword_quest.var_e91b9e85[1] = "wpn_t7_zmb_zod_sword1_det_no_egg_world";
	level.sword_quest.var_e91b9e85[2] = "wpn_t7_zmb_zod_sword1_fem_no_egg_world";
	level.sword_quest.var_e91b9e85[3] = "wpn_t7_zmb_zod_sword1_mag_no_egg_world";
	level.sword_quest.egg_models = array("zm_zod_sword_egg_apothicon_s1", "zm_zod_sword_egg_apothicon_s2", "zm_zod_sword_egg_apothicon_s3", "zm_zod_sword_egg_apothicon_s4", "zm_zod_sword_egg_apothicon_s5");
	for(statue_id = 0; statue_id < level.sword_quest.statues.size; statue_id++)
	{
		e_statue = level.sword_quest.statues[statue_id];
		if(e_statue.script_noteworthy === "initial_egg_statue")
		{
			e_statue.egg_tags = array("j_egg_location_01", "j_egg_location_02", "j_egg_location_03", "j_egg_location_04");
			e_statue.sword_tags = array("j_sword_location_01", "j_sword_location_02", "j_sword_location_03", "j_sword_location_04");
			level.sword_quest.eggs = [];
			foreach(str_tag in e_statue.egg_tags)
			{
				v_origin = e_statue gettagorigin(str_tag);
				v_angles = e_statue gettagangles(str_tag);
				e_egg = util::spawn_model(level.sword_quest.egg_models[0], v_origin, v_angles);
				if(!isdefined(level.sword_quest.eggs))
				{
					level.sword_quest.eggs = [];
				}
				else if(!isarray(level.sword_quest.eggs))
				{
					level.sword_quest.eggs = array(level.sword_quest.eggs);
				}
				level.sword_quest.eggs[level.sword_quest.eggs.size] = e_egg;
			}
			level.sword_quest.swords = [];
			for(i = 0; i < e_statue.sword_tags.size; i++)
			{
				v_origin = e_statue gettagorigin(e_statue.sword_tags[i]);
				v_angles = e_statue gettagangles(e_statue.sword_tags[i]);
				e_sword = util::spawn_model(level.sword_quest.var_e91b9e85[i], v_origin, v_angles);
				level.sword_quest.swords[i] = e_sword;
				level.sword_quest.swords[i].var_c9c683e8 = 0;
			}
		}
		else
		{
			e_statue.egg_tags = array("j_sword_egg_01", "j_sword_egg_02", "j_sword_egg_03", "j_sword_egg_04");
		}
		e_statue.statue_id = statue_id;
		s_trigger_pos = struct::get(e_statue.target, "targetname");
		if(isdefined(s_trigger_pos.target))
		{
			zm_zod_smashables::add_callback(s_trigger_pos.target, &function_2c009d2e, e_statue);
			continue;
		}
		level thread function_2c009d2e(e_statue);
	}
	level thread second_sword_quest();
}

/*
	Name: second_sword_quest
	Namespace: zm_zod_sword
	Checksum: 0x8C4B985D
	Offset: 0x1BA0
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function second_sword_quest()
{
	level.sword_quest_2 = spawnstruct();
	level.sword_quest_2.var_765ff5d4 = [];
	level.sword_quest_2.var_765ff5d4 = struct::get_array("sword_quest_magic_circle_place", "targetname");
	level flag::wait_till("ritual_pap_complete");
	for(i = 0; i < 4; i++)
	{
		foreach(player in level.players)
		{
			player clientfield::set_to_player("magic_circle_state_" + i, 1);
		}
		s_loc = struct::get("keeper_spirit_" + i, "targetname");
		function_aa4e4fa4(s_loc, i);
	}
	level flag::init("magic_circle_in_progress");
	var_5306b772 = struct::get_array("sword_quest_magic_circle_place", "targetname");
	foreach(var_768e52e3 in var_5306b772)
	{
		create_magic_circle_unitrigger(var_768e52e3, var_768e52e3.script_int);
	}
	level thread function_e9bb9efa();
}

/*
	Name: function_e9bb9efa
	Namespace: zm_zod_sword
	Checksum: 0x4D640BBC
	Offset: 0x1E30
	Size: 0x19E
	Parameters: 0
	Flags: Linked
*/
function function_e9bb9efa()
{
	while(true)
	{
		level util::waittill_any("between_round_over", "magic_circle_failed");
		foreach(player in level.players)
		{
			for(i = 0; i < 4; i++)
			{
				n_quest_state = player clientfield::get_to_player("magic_circle_state_" + i);
				if(n_quest_state === 0 && !player function_a7e71a86(i))
				{
					player clientfield::set_to_player("magic_circle_state_" + i, 1);
					continue;
				}
				player clientfield::set_to_player("magic_circle_state_" + i, 0);
			}
			player flag::clear("magic_circle_wait_for_round_completed");
		}
	}
}

/*
	Name: function_2f36dd89
	Namespace: zm_zod_sword
	Checksum: 0x6CA21D4B
	Offset: 0x1FD8
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function function_2f36dd89(var_6b55cb3b)
{
	if(!isdefined(var_6b55cb3b))
	{
		self flag::set("magic_circle_wait_for_round_completed");
	}
	for(i = 0; i < 4; i++)
	{
		if(var_6b55cb3b !== i)
		{
			self clientfield::set_to_player("magic_circle_state_" + i, 0);
		}
	}
}

/*
	Name: function_ed28cc7
	Namespace: zm_zod_sword
	Checksum: 0xAFB02534
	Offset: 0x2070
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_ed28cc7()
{
	self endon(#"disconnect");
	level clientfield::set("keeper_quest_state_" + self.characterindex, 0);
	self waittill(#"hash_1867e603");
	level flag::wait_till("ritual_pap_complete");
	level clientfield::set("keeper_quest_state_" + self.characterindex, 1);
}

/*
	Name: function_6c2f52e5
	Namespace: zm_zod_sword
	Checksum: 0x3CDF4341
	Offset: 0x2100
	Size: 0xB4
	Parameters: 1
	Flags: None
*/
function function_6c2f52e5(n_char_index)
{
	players = getplayers();
	foreach(player in players)
	{
		if(player.characterindex === n_char_index)
		{
			return player;
		}
	}
}

/*
	Name: function_aa4e4fa4
	Namespace: zm_zod_sword
	Checksum: 0x47345C5B
	Offset: 0x21C0
	Size: 0x1E4
	Parameters: 2
	Flags: Linked
*/
function function_aa4e4fa4(s_loc, n_char_index)
{
	width = 128;
	height = 128;
	length = 128;
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = width;
	s_loc.unitrigger_stub.script_height = height;
	s_loc.unitrigger_stub.script_length = length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.n_char_index = n_char_index;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_loc.unitrigger_stub, 1);
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_ac03c228;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_4a3c552c);
}

/*
	Name: function_ac03c228
	Namespace: zm_zod_sword
	Checksum: 0x9454219E
	Offset: 0x23B0
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function function_ac03c228(player)
{
	b_can_see = 1;
	if(isdefined(player.beastmode) && player.beastmode)
	{
		b_can_see = 0;
	}
	if(b_can_see)
	{
		self setvisibletoplayer(player);
	}
	else
	{
		self setinvisibletoplayer(player);
	}
	var_a3338832 = self function_4a703d7c(player);
	if(isdefined(self.hint_string))
	{
		self sethintstring(self.hint_string);
	}
	return var_a3338832;
}

/*
	Name: function_4a703d7c
	Namespace: zm_zod_sword
	Checksum: 0x400F16B8
	Offset: 0x2498
	Size: 0x146
	Parameters: 1
	Flags: Linked
*/
function function_4a703d7c(player)
{
	n_char_index = self.stub.n_char_index;
	n_quest_state = level clientfield::get("keeper_quest_state_" + n_char_index);
	b_result = 0;
	if(isdefined(player.beastmode) && player.beastmode)
	{
		self.hint_string = &"";
	}
	else
	{
		if(n_quest_state === 2 || n_quest_state === 3)
		{
			self.hint_string = &"";
		}
		else
		{
			if(player.characterindex !== n_char_index)
			{
				self.hint_string = &"ZM_ZOD_KEEPER_EGG_CANNOT_PICKUP";
			}
			else if(n_quest_state === 1 && player has_sword())
			{
				self.hint_string = &"ZM_ZOD_KEEPER_EGG_PICKUP";
				b_result = 1;
			}
		}
	}
	return b_result;
}

/*
	Name: function_4a3c552c
	Namespace: zm_zod_sword
	Checksum: 0x10E50846
	Offset: 0x25E8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_4a3c552c()
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
		if(player.characterindex !== self.stub.n_char_index)
		{
			continue;
		}
		level thread function_5356f68f(self, player);
		break;
	}
}

/*
	Name: function_5356f68f
	Namespace: zm_zod_sword
	Checksum: 0xC2486F8C
	Offset: 0x26B8
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function function_5356f68f(trig, player)
{
	level clientfield::set("keeper_quest_state_" + trig.stub.n_char_index, 2);
	trig zm_zod_util::unitrigger_refresh_message();
	player clientfield::set_player_uimodel("zmInventory.player_sword_quest_completed_level_1", 1);
	player clientfield::set_player_uimodel("zmInventory.player_sword_quest_egg_state", 1);
	player thread zm_zod_util::function_55f114f9("zmInventory.widget_egg", 3.5);
	player thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_LVL2_EGG_PICKUP", 3.5);
	player playsound("zmb_zod_egg2_pickup");
	player thread zm_zod_vo::function_9bd30516();
}

/*
	Name: create_magic_circle_unitrigger
	Namespace: zm_zod_sword
	Checksum: 0x685ECC7E
	Offset: 0x27F0
	Size: 0x1E4
	Parameters: 2
	Flags: Linked
*/
function create_magic_circle_unitrigger(s_loc, n_char_index)
{
	width = 128;
	height = 128;
	length = 128;
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = width;
	s_loc.unitrigger_stub.script_height = height;
	s_loc.unitrigger_stub.script_length = length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.n_char_index = n_char_index;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_loc.unitrigger_stub, 1);
	s_loc.unitrigger_stub.prompt_and_visibility_func = &magic_circle_trigger_visibility;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &magic_circle_trigger_think);
}

/*
	Name: magic_circle_trigger_visibility
	Namespace: zm_zod_sword
	Checksum: 0xC211E321
	Offset: 0x29E0
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function magic_circle_trigger_visibility(player)
{
	self setinvisibletoplayer(player);
	if(isdefined(self.stub.activated) && self.stub.activated || !player has_sword())
	{
		return 0;
	}
	var_a3338832 = self function_74e5c19(player);
	if(isdefined(self.hint_string))
	{
		self sethintstring(self.hint_string);
	}
	return var_a3338832;
}

/*
	Name: function_74e5c19
	Namespace: zm_zod_sword
	Checksum: 0xD9ABC4AB
	Offset: 0x2AA8
	Size: 0x1D0
	Parameters: 1
	Flags: Linked
*/
function function_74e5c19(player)
{
	n_char_index = self.stub.n_char_index;
	var_2ce85e2b = player function_a7e71a86(n_char_index);
	var_efb73168 = 1;
	var_bca28fa8 = 0;
	n_quest_state = level clientfield::get("keeper_quest_state_" + player.characterindex);
	if(n_quest_state === 2 || n_quest_state === 3)
	{
		var_bca28fa8 = 1;
	}
	if(var_2ce85e2b)
	{
		var_efb73168 = 0;
	}
	if(!var_bca28fa8)
	{
		var_efb73168 = 0;
	}
	if(isdefined(player.beastmode) && player.beastmode)
	{
		var_efb73168 = 0;
	}
	if(level flag::get("magic_circle_in_progress"))
	{
		var_efb73168 = 0;
	}
	if(player flag::get("magic_circle_wait_for_round_completed"))
	{
		var_efb73168 = 0;
	}
	if(var_efb73168)
	{
		self.hint_string = &"ZM_ZOD_SWORD_DEFEND_PLACE";
		self setvisibletoplayer(player);
	}
	else
	{
		self.hint_string = "";
		self setinvisibletoplayer(player);
	}
	return var_efb73168;
}

/*
	Name: magic_circle_trigger_think
	Namespace: zm_zod_sword
	Checksum: 0x949973BE
	Offset: 0x2C80
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function magic_circle_trigger_think()
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
		if(isdefined(self.stub.activated) && self.stub.activated)
		{
			continue;
		}
		if(level flag::get("magic_circle_in_progress"))
		{
			continue;
		}
		level thread magic_circle_trigger_activate(self.stub, player);
		break;
	}
}

/*
	Name: magic_circle_trigger_activate
	Namespace: zm_zod_sword
	Checksum: 0x586180F6
	Offset: 0x2D80
	Size: 0x732
	Parameters: 2
	Flags: Linked
*/
function magic_circle_trigger_activate(trig_stub, player)
{
	level flag::set("magic_circle_in_progress");
	trig_stub notify(#"hash_15d0dfe4");
	trig_stub endon(#"hash_15d0dfe4");
	level endon(#"magic_circle_failed");
	trig_stub.activated = 1;
	var_181b74a5 = trig_stub.n_char_index;
	trig_stub.player = player;
	foreach(e_player in level.players)
	{
		e_player function_2f36dd89(var_181b74a5);
	}
	level clientfield::set("keeper_egg_location_" + player.characterindex, var_181b74a5);
	level clientfield::set("keeper_quest_state_" + player.characterindex, 4);
	foreach(e_player in level.players)
	{
		e_player clientfield::set_to_player("magic_circle_state_" + var_181b74a5, 2);
	}
	zm_unitrigger::run_visibility_function_for_all_triggers();
	player playsound("zmb_zod_egg_place");
	player clientfield::set_player_uimodel("zmInventory.widget_egg", 0);
	str_endon = ("magic_circle_" + var_181b74a5) + "_off";
	player thread function_278154b(trig_stub.origin, var_181b74a5, 32, 0.01, str_endon);
	level thread function_47563199(trig_stub, player, str_endon);
	level thread function_413de655(trig_stub, player, str_endon);
	n_charges = player function_b7af29e0();
	if(n_charges == 0)
	{
		n_kills_needed = 1;
	}
	else
	{
		n_kills_needed = 2;
	}
	var_73fc403f = 0;
	trig_stub.var_87b7360 = 0;
	var_fb35e9c2 = struct::get_array("sword_quest_margwa_spawnpoint", "targetname");
	player.sword_power = 1;
	player clientfield::set_player_uimodel("zmhud.swordEnergy", player.sword_power);
	player gadgetpowerset(0, 100);
	player clientfield::increment_uimodel("zmhud.swordChargeUpdate");
	while(true)
	{
		trig_stub.ai_defender = [];
		trig_stub.var_2330d68c = array::filter(var_fb35e9c2, 0, &function_ed69c2a1, var_181b74a5);
		var_90e5cd72 = 0;
		while(var_90e5cd72 < 2 && var_73fc403f < n_kills_needed)
		{
			trig_stub.var_87b7360++;
			level thread function_7922af5f(player, trig_stub, var_90e5cd72, str_endon);
			var_90e5cd72++;
			var_73fc403f++;
			wait(0.05);
		}
		while(trig_stub.var_87b7360 > 0)
		{
			wait(0.05);
		}
		if(player.sword_quest_2.kills[var_181b74a5] == n_kills_needed)
		{
			level notify(str_endon);
			player.sword_quest_2.var_db999762[var_181b74a5] = n_kills_needed;
			n_charges = player function_b7af29e0();
			player clientfield::set_player_uimodel("zmInventory.player_sword_quest_egg_state", 1 + n_charges);
			player thread zm_zod_util::function_55f114f9("zmInventory.widget_egg", 3.5);
			player function_2f36dd89();
			level flag::clear("magic_circle_in_progress");
			if(n_charges == 4)
			{
				player.sword_quest_2.all_kills_completed = 1;
				level clientfield::set("keeper_quest_state_" + player.characterindex, 5);
				wait(1);
				level clientfield::set("keeper_quest_state_" + player.characterindex, 6);
				wait(1);
				s_loc = struct::get("keeper_spirit_" + player.characterindex, "targetname");
				function_6f69a416(s_loc, player.characterindex);
			}
			else
			{
				level clientfield::set("keeper_quest_state_" + player.characterindex, 3);
			}
			trig_stub.activated = 0;
			return;
		}
	}
}

/*
	Name: function_7922af5f
	Namespace: zm_zod_sword
	Checksum: 0x3DCF4E16
	Offset: 0x34C0
	Size: 0x2CC
	Parameters: 4
	Flags: Linked
*/
function function_7922af5f(player, trig_stub, index, str_endon)
{
	level endon(str_endon);
	level endon(#"magic_circle_failed");
	var_181b74a5 = trig_stub.n_char_index;
	while(true)
	{
		var_cf8830de = array::random(trig_stub.var_2330d68c);
		arrayremovevalue(trig_stub.var_2330d68c, var_cf8830de);
		trig_stub.ai_defender[index] = zm_ai_margwa::function_8a0708c2(var_cf8830de);
		trig_stub.ai_defender[index].no_powerups = 1;
		trig_stub.ai_defender[index].var_89905c65 = 1;
		trig_stub.ai_defender[index].deathpoints_already_given = 1;
		trig_stub.ai_defender[index].var_2d5d7413 = 1;
		trig_stub.ai_defender[index].var_de609f65 = player;
		trig_stub.ai_defender[index] waittill(#"death", attacker, mod, var_13b27531);
		if(isdefined(var_13b27531 === level.sword_quest.weapons[player.characterindex][1]))
		{
			player.sword_quest_2.kills[var_181b74a5]++;
			trig_stub.var_87b7360--;
			break;
		}
		else
		{
			if(!isdefined(trig_stub.var_2330d68c))
			{
				trig_stub.var_2330d68c = [];
			}
			else if(!isarray(trig_stub.var_2330d68c))
			{
				trig_stub.var_2330d68c = array(trig_stub.var_2330d68c);
			}
			trig_stub.var_2330d68c[trig_stub.var_2330d68c.size] = var_cf8830de;
			wait(4);
		}
	}
}

/*
	Name: function_47563199
	Namespace: zm_zod_sword
	Checksum: 0x8D107198
	Offset: 0x3798
	Size: 0x20C
	Parameters: 3
	Flags: Linked
*/
function function_47563199(trig_stub, player, str_endon)
{
	level endon(str_endon);
	var_9c7aaa62 = player function_b7af29e0();
	var_181b74a5 = trig_stub.n_char_index;
	n_char_index = player.characterindex;
	player util::waittill_any("entering_last_stand", "disconnect");
	level notify(#"hash_278154b");
	level notify(#"magic_circle_failed");
	for(i = 0; i < trig_stub.ai_defender.size; i++)
	{
		if(isalive(trig_stub.ai_defender[i]))
		{
			trig_stub.ai_defender[i] kill();
		}
	}
	level flag::clear("magic_circle_in_progress");
	level clientfield::set("keeper_egg_location_" + n_char_index, var_181b74a5);
	level clientfield::set("keeper_quest_state_" + n_char_index, 3);
	player.sword_quest_2.kills[var_181b74a5] = 0;
	trig_stub.activated = 0;
	trig_stub.player = 0;
	level flag::clear("magic_circle_in_progress");
}

/*
	Name: function_413de655
	Namespace: zm_zod_sword
	Checksum: 0x7B1F5775
	Offset: 0x39B0
	Size: 0xAC
	Parameters: 3
	Flags: Linked
*/
function function_413de655(trig_stub, player, str_endon)
{
	player endon(#"disconnect");
	level endon(str_endon);
	player waittill(#"bled_out");
	n_charges = player function_b7af29e0();
	player clientfield::set_player_uimodel("zmInventory.player_sword_quest_egg_state", 1 + n_charges);
	player thread zm_zod_util::function_55f114f9("zmInventory.widget_egg", 3.5);
}

/*
	Name: function_278154b
	Namespace: zm_zod_sword
	Checksum: 0x41B10A0D
	Offset: 0x3A68
	Size: 0x3A0
	Parameters: 5
	Flags: Linked
*/
function function_278154b(var_a246d2ec, var_181b74a5, n_radius, n_rate, str_endon)
{
	level notify(#"hash_278154b");
	level endon(#"hash_278154b");
	level endon(str_endon);
	n_dist_max = n_radius * n_radius;
	while(true)
	{
		var_2108630b = 0;
		if(isdefined(self.sword_power))
		{
			v_player_origin = self getorigin();
			if(isdefined(v_player_origin))
			{
				n_dist_2 = distancesquared(var_a246d2ec, v_player_origin);
				if(n_dist_2 <= n_dist_max)
				{
					var_2108630b = 1;
					wpn_excalibur = self zm_weap_glaive::get_correct_sword_for_player_character_at_level(1);
					slot = self gadgetgetslot(wpn_excalibur);
					temp = self gadgetpowerget(slot) / 100;
					temp = temp + 0.01;
					temp = math::clamp(temp, 0, 1);
					self gadgetpowerset(slot, 100 * temp);
					self.sword_power = temp;
					self clientfield::set_player_uimodel("zmhud.swordEnergy", self.sword_power);
					if(!isdefined(self.var_88d65f) || (!(isdefined(self.var_88d65f) && self.var_88d65f)))
					{
						self.var_88d65f = 1;
						self thread function_9867bf60(var_a246d2ec, n_dist_max, str_endon);
					}
				}
			}
		}
		if(var_2108630b)
		{
			foreach(e_player in level.players)
			{
				e_player clientfield::set_to_player("magic_circle_state_" + var_181b74a5, 3);
			}
			var_2108630b = 0;
		}
		else
		{
			foreach(e_player in level.players)
			{
				e_player clientfield::set_to_player("magic_circle_state_" + var_181b74a5, 2);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_9867bf60
	Namespace: zm_zod_sword
	Checksum: 0xE81F5E02
	Offset: 0x3E10
	Size: 0xA4
	Parameters: 3
	Flags: Linked
*/
function function_9867bf60(var_a246d2ec, n_dist_max, str_endon)
{
	self endon(#"disconnect");
	level endon(#"hash_278154b");
	level endon(str_endon);
	self playsoundtoplayer("zmb_zod_sword2_charge", self);
	while(distancesquared(var_a246d2ec, self.origin) <= n_dist_max)
	{
		wait(0.1);
		if(!isdefined(self))
		{
			return;
		}
	}
	self.var_88d65f = 0;
}

/*
	Name: function_ed69c2a1
	Namespace: zm_zod_sword
	Checksum: 0x225976B3
	Offset: 0x3EC0
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function function_ed69c2a1(e_entity, n_script_int)
{
	if(!isdefined(e_entity.script_int) || e_entity.script_int != n_script_int)
	{
		return false;
	}
	return true;
}

/*
	Name: function_b7af29e0
	Namespace: zm_zod_sword
	Checksum: 0x936C4F65
	Offset: 0x3F10
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_b7af29e0()
{
	n_charges = 0;
	for(i = 0; i < 4; i++)
	{
		if(self function_a7e71a86(i))
		{
			n_charges = n_charges + 1;
		}
	}
	return n_charges;
}

/*
	Name: function_59d9e12a
	Namespace: zm_zod_sword
	Checksum: 0xE02478B5
	Offset: 0x3F88
	Size: 0xC4
	Parameters: 1
	Flags: None
*/
function function_59d9e12a(n_index)
{
	var_5306b772 = struct::get_array("sword_quest_magic_circle_place", "targetname");
	foreach(var_768e52e3 in var_5306b772)
	{
		if(var_768e52e3.script_int === n_index)
		{
			return var_768e52e3;
		}
	}
}

/*
	Name: function_96ae1a10
	Namespace: zm_zod_sword
	Checksum: 0x7F90678A
	Offset: 0x4058
	Size: 0xD4
	Parameters: 2
	Flags: None
*/
function function_96ae1a10(var_181b74a5, n_character_index)
{
	var_79d1dcf6 = struct::get_array("sword_quest_magic_circle_player_" + n_character_index, "targetname");
	foreach(var_87367d4f in var_79d1dcf6)
	{
		if(var_87367d4f.script_int === var_181b74a5)
		{
			return var_87367d4f;
		}
	}
}

/*
	Name: function_6f69a416
	Namespace: zm_zod_sword
	Checksum: 0xB76B1C7C
	Offset: 0x4138
	Size: 0x1E4
	Parameters: 2
	Flags: Linked
*/
function function_6f69a416(s_loc, n_char_index)
{
	width = 128;
	height = 128;
	length = 128;
	s_loc.unitrigger_stub = spawnstruct();
	s_loc.unitrigger_stub.origin = s_loc.origin;
	s_loc.unitrigger_stub.angles = s_loc.angles;
	s_loc.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	s_loc.unitrigger_stub.cursor_hint = "HINT_NOICON";
	s_loc.unitrigger_stub.script_width = width;
	s_loc.unitrigger_stub.script_height = height;
	s_loc.unitrigger_stub.script_length = length;
	s_loc.unitrigger_stub.require_look_at = 0;
	s_loc.unitrigger_stub.n_char_index = n_char_index;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_loc.unitrigger_stub, 1);
	s_loc.unitrigger_stub.prompt_and_visibility_func = &function_8ca48fdc;
	zm_unitrigger::register_static_unitrigger(s_loc.unitrigger_stub, &function_2bca570);
}

/*
	Name: function_8ca48fdc
	Namespace: zm_zod_sword
	Checksum: 0x3D7B4DBD
	Offset: 0x4328
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function function_8ca48fdc(player)
{
	self setinvisibletoplayer(player);
	var_a3338832 = self function_c722bbbb(player);
	if(isdefined(self.hint_string))
	{
		self sethintstring(self.hint_string);
	}
	if(var_a3338832)
	{
		self setvisibletoplayer(player);
	}
	return var_a3338832;
}

/*
	Name: function_c722bbbb
	Namespace: zm_zod_sword
	Checksum: 0x48006EF4
	Offset: 0x43C8
	Size: 0x156
	Parameters: 1
	Flags: Linked
*/
function function_c722bbbb(player)
{
	if(isdefined(player.beastmode) && player.beastmode || player flag::get("waiting_for_upgraded_sword"))
	{
		self.hint_string = &"";
		return false;
	}
	n_char_index = self.stub.n_char_index;
	n_quest_state = level clientfield::get("keeper_quest_state_" + n_char_index);
	if(n_quest_state === 6 && player has_sword(1))
	{
		self.hint_string = &"ZM_ZOD_KEEPER_SWORD_PLACE";
		return true;
	}
	if(n_quest_state === 7)
	{
		self.hint_string = &"ZM_ZOD_KEEPER_SWORD_PICKUP";
		return true;
	}
	if(player.characterindex === n_char_index)
	{
		self.hint_string = &"ZM_ZOD_KEEPER_EGG_CANNOT_PICKUP";
		return false;
	}
	self.hint_string = &"";
	return false;
}

/*
	Name: function_2bca570
	Namespace: zm_zod_sword
	Checksum: 0x4806E752
	Offset: 0x4528
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_2bca570()
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
		if(player.characterindex !== self.stub.n_char_index)
		{
			continue;
		}
		n_quest_state = level clientfield::get("keeper_quest_state_" + self.stub.n_char_index);
		if(n_quest_state !== 6 && n_quest_state !== 7)
		{
			continue;
		}
		if(player flag::get("waiting_for_upgraded_sword"))
		{
			continue;
		}
		level thread function_e5a7a0eb(self.stub, player, n_quest_state);
		break;
	}
}

/*
	Name: function_e5a7a0eb
	Namespace: zm_zod_sword
	Checksum: 0x9D5352C0
	Offset: 0x4678
	Size: 0x2CE
	Parameters: 3
	Flags: Linked
*/
function function_e5a7a0eb(stub, player, n_quest_state)
{
	if(n_quest_state == 6)
	{
		player take_sword();
		player clientfield::set_player_uimodel("zmInventory.widget_egg", 0);
		level clientfield::set("keeper_quest_state_" + player.characterindex, 7);
		player flag::set("waiting_for_upgraded_sword");
		stub zm_zod_util::unitrigger_refresh_message();
		wait(2);
		player flag::clear("waiting_for_upgraded_sword");
		stub zm_zod_util::unitrigger_refresh_message();
	}
	else if(n_quest_state == 7)
	{
		level clientfield::set("keeper_quest_state_" + player.characterindex, 8);
		player thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_LVL2_SWORD_PICKUP", 3.5);
		player give_sword(2, 1);
		switch(player.characterindex)
		{
			case 0:
			{
				level.sword_quest.swords[player.characterindex] setmodel("wpn_t7_zmb_zod_sword2_box_world");
				break;
			}
			case 1:
			{
				level.sword_quest.swords[player.characterindex] setmodel("wpn_t7_zmb_zod_sword2_det_world");
				break;
			}
			case 2:
			{
				level.sword_quest.swords[player.characterindex] setmodel("wpn_t7_zmb_zod_sword2_fem_world");
				break;
			}
			case 3:
			{
				level.sword_quest.swords[player.characterindex] setmodel("wpn_t7_zmb_zod_sword2_mag_world");
				break;
			}
		}
	}
}

/*
	Name: function_2f31f931
	Namespace: zm_zod_sword
	Checksum: 0x990A4625
	Offset: 0x4950
	Size: 0x34E
	Parameters: 1
	Flags: Linked
*/
function function_2f31f931(e_player)
{
	self setinvisibletoplayer(e_player);
	n_statue = self.stub.statue_id;
	e_statue = level.sword_quest.statues[n_statue];
	b_inventory = !isdefined(e_player.sword_quest.egg_placement);
	b_satisfied = e_player function_24978bad(n_statue);
	b_here = e_player function_6dc5b484(n_statue);
	b_sword_rock = e_statue.script_noteworthy === "initial_egg_statue";
	var_c9c683e8 = level.sword_quest.swords[e_player.characterindex].var_c9c683e8;
	var_5f66b0c7 = level clientfield::get("ee_quest_state");
	n_quest_state = level clientfield::get("keeper_quest_state_" + e_player.characterindex);
	if(n_quest_state === 7)
	{
		self.hint_string = &"";
	}
	else
	{
		if(e_player.sword_quest.upgrade_stage >= 1)
		{
			if(b_sword_rock && !e_player has_sword() && !var_c9c683e8)
			{
				if(b_inventory && e_player.var_b170d6d6 === 0)
				{
					self setvisibletoplayer(e_player);
					self.hint_string = &"ZM_ZOD_SWORD_EGG_PLACE";
				}
				else
				{
					if(var_5f66b0c7 < 1)
					{
						self setvisibletoplayer(e_player);
						self.hint_string = &"ZM_ZOD_SWORD_EGG_RETRIEVE";
					}
					else
					{
						self.hint_string = &"";
					}
				}
			}
			else
			{
				self.hint_string = &"";
			}
		}
		else
		{
			if(b_here && b_satisfied)
			{
				self setvisibletoplayer(e_player);
				self.hint_string = &"ZM_ZOD_X_TO_PICK_UP_EGG";
			}
			else
			{
				if(!b_here && !b_satisfied && b_inventory)
				{
					self setvisibletoplayer(e_player);
					self.hint_string = &"ZM_ZOD_SWORD_EGG_PLACE";
				}
				else
				{
					self.hint_string = &"";
				}
			}
		}
	}
	return self.hint_string;
}

/*
	Name: reset_hud
	Namespace: zm_zod_sword
	Checksum: 0x981A10F1
	Offset: 0x4CA8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function reset_hud()
{
	self clientfield::set_player_uimodel("zmInventory.player_sword_quest_egg_state", 0);
	self clientfield::set_player_uimodel("zmInventory.widget_egg", 0);
	self clientfield::set_player_uimodel("zmInventory.widget_sprayer", 0);
}

/*
	Name: on_player_connect
	Namespace: zm_zod_sword
	Checksum: 0x390CAD7
	Offset: 0x4D18
	Size: 0x2FC
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self reset_hud();
	self.var_b170d6d6 = 0;
	self.sword_quest = spawnstruct();
	self.sword_quest.kills = [];
	self.sword_quest.all_kills_completed = 0;
	self.sword_quest_2 = spawnstruct();
	self.sword_quest_2.kills = [];
	self.sword_quest_2.all_kills_completed = 0;
	self.sword_quest_2.var_db999762 = [];
	self.sword_quest.upgrade_stage = 0;
	self flag::init("waiting_for_upgraded_sword");
	self flag::init("magic_circle_wait_for_round_completed");
	a_statues = getentarray("sword_upgrade_statue", "targetname");
	foreach(e_statue in a_statues)
	{
		self.sword_quest.kills[e_statue.statue_id] = 0;
		if(e_statue.script_noteworthy === "initial_egg_statue")
		{
			self.sword_quest.kills[e_statue.statue_id] = 12;
		}
	}
	self waittill(#"spawned_player");
	function_541cb3c4();
	var_5306b772 = struct::get_array("sword_quest_magic_circle_place", "targetname");
	foreach(var_768e52e3 in var_5306b772)
	{
		self.sword_quest_2.kills[var_768e52e3.script_int] = 0;
	}
	self thread function_ed28cc7();
}

/*
	Name: on_player_spawned
	Namespace: zm_zod_sword
	Checksum: 0x8F298363
	Offset: 0x5020
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	if(isdefined(self.sword_quest) && self.sword_quest.upgrade_stage < 1)
	{
		self function_abf3df35(self.sword_quest.egg_placement);
	}
	self reset_hud();
	n_quest_state = level clientfield::get("keeper_quest_state_" + self.characterindex);
	if(n_quest_state !== 7)
	{
		reset_sword();
	}
	if(isdefined(self.sword_quest) && self.sword_quest.upgrade_stage < 1)
	{
		function_541cb3c4();
	}
	if(self clientfield::get_to_player("pod_sprayer_held"))
	{
	}
	else
	{
		self clientfield::set_player_uimodel("zmInventory.widget_sprayer", 0);
	}
}

/*
	Name: on_player_disconnect
	Namespace: zm_zod_sword
	Checksum: 0x65E1C290
	Offset: 0x5168
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function on_player_disconnect()
{
	var_d95a0cf3 = self.characterindex;
	s_initial = getent("initial_egg_statue", "script_noteworthy");
	level.sword_quest.eggs[var_d95a0cf3] setmodel(level.sword_quest.egg_models[0]);
	level.sword_quest.swords[var_d95a0cf3] show();
}

/*
	Name: on_bled_out
	Namespace: zm_zod_sword
	Checksum: 0x21D0B399
	Offset: 0x5220
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function on_bled_out()
{
	if(!isdefined(self.var_b170d6d6) && level flag::get("keeper_sword_locker"))
	{
		self.var_b170d6d6 = 1;
	}
}

/*
	Name: on_zombie_killed
	Namespace: zm_zod_sword
	Checksum: 0xADC16C5
	Offset: 0x5268
	Size: 0x1D2
	Parameters: 0
	Flags: Linked
*/
function on_zombie_killed()
{
	foreach(e_statue in level.sword_quest.statues)
	{
		dist_sq = distancesquared(self.origin, e_statue.origin);
		if(isdefined(e_statue.radius))
		{
			var_d41ef8d1 = e_statue.radius * e_statue.radius;
		}
		else
		{
			var_d41ef8d1 = 589294;
		}
		if(dist_sq < var_d41ef8d1)
		{
			if(isdefined(self.attacker) && isplayer(self.attacker))
			{
				if(self.attacker function_6dc5b484(e_statue.statue_id) && !self.attacker function_24978bad(e_statue.statue_id) && !self.attacker flag::get("in_beastmode"))
				{
					self bank_zombie_kill(self.attacker, e_statue);
				}
			}
		}
	}
}

/*
	Name: bank_zombie_kill
	Namespace: zm_zod_sword
	Checksum: 0x2E1D2337
	Offset: 0x5448
	Size: 0x344
	Parameters: 2
	Flags: Linked, Private
*/
function private bank_zombie_kill(e_player, e_statue)
{
	e_player.sword_quest.kills[e_statue.statue_id]++;
	e_player function_67bcb9d9();
	/#
		if(isdefined(e_player.sword_quest.cheat) && e_player.sword_quest.cheat)
		{
			e_player.sword_quest.kills[e_statue.statue_id] = 12;
		}
	#/
	if(e_player function_24978bad(e_statue.statue_id))
	{
		e_statue thread function_ce7bc2ba();
		e_player.sword_quest.all_kills_completed = 1;
		n_statues_complete = 0;
		foreach(e_statue in level.sword_quest.statues)
		{
			n_kills = e_player.sword_quest.kills[e_statue.statue_id];
			if(n_kills < 12)
			{
				e_player.sword_quest.all_kills_completed = 0;
				continue;
			}
			if(!e_statue.script_noteworthy === "initial_egg_statue")
			{
				n_statues_complete++;
			}
		}
		str_model = level.sword_quest.egg_models[n_statues_complete];
		e_model = level.sword_quest.eggs[e_player.characterindex];
		e_model setmodel(str_model);
		e_model clientfield::set("zod_egg_glow", 1);
		e_model playloopsound("zmb_zod_egg_glow_ready", 3);
		if(n_statues_complete < 4)
		{
			e_model playsound("zmb_zod_soul_full");
		}
		else
		{
			e_model playsound("zmb_zod_soul_full_final");
		}
	}
	self thread zombie_blood_soul_streak_fx(e_statue, e_player);
	e_player thread zm_audio::create_and_play_dialog("sword_quest", "charge_egg");
}

/*
	Name: function_6dc5b484
	Namespace: zm_zod_sword
	Checksum: 0x9439D2C0
	Offset: 0x5798
	Size: 0x38
	Parameters: 1
	Flags: Linked, Private
*/
function private function_6dc5b484(statue_id)
{
	if(!isdefined(self.sword_quest.egg_placement))
	{
		return 0;
	}
	return self.sword_quest.egg_placement == statue_id;
}

/*
	Name: function_24978bad
	Namespace: zm_zod_sword
	Checksum: 0xE4083AC
	Offset: 0x57D8
	Size: 0x26
	Parameters: 1
	Flags: Linked, Private
*/
function private function_24978bad(statue_id)
{
	return self.sword_quest.kills[statue_id] >= 12;
}

/*
	Name: function_5fd6959f
	Namespace: zm_zod_sword
	Checksum: 0x8CA1B12D
	Offset: 0x5808
	Size: 0x4A
	Parameters: 1
	Flags: Private
*/
function private function_5fd6959f(var_a94aa7ef)
{
	var_181b74a5 = level clientfield::get("keeper_egg_location_" + self.characterindex);
	return var_181b74a5 === var_a94aa7ef;
}

/*
	Name: function_a7e71a86
	Namespace: zm_zod_sword
	Checksum: 0xF52F245C
	Offset: 0x5860
	Size: 0x22
	Parameters: 1
	Flags: Linked, Private
*/
function private function_a7e71a86(var_a94aa7ef)
{
	return isdefined(self.sword_quest_2.var_db999762[var_a94aa7ef]);
}

/*
	Name: zombie_blood_soul_streak_fx
	Namespace: zm_zod_sword
	Checksum: 0xC61B6DAB
	Offset: 0x5890
	Size: 0x174
	Parameters: 2
	Flags: Linked, Private
*/
function private zombie_blood_soul_streak_fx(e_statue, e_killer)
{
	v_start = self gettagorigin("J_SpineLower");
	e_fx = zm_zod_util::tag_origin_allocate(v_start, self.angles);
	e_fx clientfield::set("zod_egg_soul", 1);
	e_fx playsound("zmb_zod_soul_release");
	v_endpos = e_statue gettagorigin(e_statue.egg_tags[e_killer.characterindex]);
	e_fx moveto(v_endpos, 1);
	e_fx waittill(#"movedone");
	e_fx playsound("zmb_zod_soul_impact");
	wait(0.25);
	e_fx clientfield::set("zod_egg_soul", 0);
	e_fx zm_zod_util::tag_origin_free();
}

/*
	Name: spawn_zombie_clone
	Namespace: zm_zod_sword
	Checksum: 0x960E980D
	Offset: 0x5A10
	Size: 0xB8
	Parameters: 0
	Flags: Private
*/
function private spawn_zombie_clone()
{
	clone = spawn("script_model", self.origin);
	clone.angles = self.angles;
	clone setmodel(self.model);
	if(isdefined(self.headmodel))
	{
		clone.headmodel = self.headmodel;
		clone attach(clone.headmodel, "", 1);
	}
	return clone;
}

/*
	Name: function_67bcb9d9
	Namespace: zm_zod_sword
	Checksum: 0xC5EB065B
	Offset: 0x5AD0
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_67bcb9d9()
{
	if(self.sword_quest.upgrade_stage == 0)
	{
		n_charges = 0;
		foreach(e_statue in level.sword_quest.statues)
		{
			if(e_statue.script_noteworthy === "initial_egg_statue")
			{
				continue;
			}
			statue_id = e_statue.statue_id;
			var_74ff1ab4 = self.sword_quest.kills[statue_id];
			if(var_74ff1ab4 >= 12)
			{
				n_charges = n_charges + 1;
			}
		}
	}
	else if(self.sword_quest.upgrade_stage == 1)
	{
		n_charges = self function_b7af29e0();
	}
	self clientfield::set_player_uimodel("zmInventory.player_sword_quest_egg_state", 1 + n_charges);
}

/*
	Name: function_abf3df35
	Namespace: zm_zod_sword
	Checksum: 0xEB40E810
	Offset: 0x5C58
	Size: 0x1EC
	Parameters: 2
	Flags: Linked
*/
function function_abf3df35(n_egg_placement, b_completed = 0)
{
	self.sword_quest.egg_placement = n_egg_placement;
	self.sword_quest.egg_placement_time = gettime();
	e_egg = level.sword_quest.eggs[self.characterindex];
	if(!isdefined(n_egg_placement))
	{
		self thread zm_zod_util::function_55f114f9("zmInventory.widget_egg", 3.5);
		e_egg ghost();
		e_egg clientfield::set("zod_egg_glow", 0);
		e_egg stoploopsound(1);
	}
	else
	{
		e_statue = level.sword_quest.statues[n_egg_placement];
		e_egg.origin = e_statue gettagorigin(e_statue.egg_tags[self.characterindex]);
		e_egg.angles = e_statue gettagangles(e_statue.egg_tags[self.characterindex]);
		e_egg show();
		e_statue thread function_ce7bc2ba();
		if(!e_statue.script_noteworthy === "initial_egg_statue")
		{
			self clientfield::set_player_uimodel("zmInventory.widget_egg", 0);
		}
	}
}

/*
	Name: function_ce7bc2ba
	Namespace: zm_zod_sword
	Checksum: 0x5EEA0F2F
	Offset: 0x5E50
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_ce7bc2ba()
{
	self notify(#"hash_ce7bc2ba");
	self endon(#"hash_ce7bc2ba");
	b_is_active = 0;
	foreach(player in level.activeplayers)
	{
		if(player function_6dc5b484(self.statue_id) && !player function_24978bad(self.statue_id))
		{
			b_is_active = 1;
		}
	}
	self thread function_3608024(b_is_active);
}

/*
	Name: function_3608024
	Namespace: zm_zod_sword
	Checksum: 0x57998C2A
	Offset: 0x5F60
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function function_3608024(b_is_active)
{
	self useanimtree($generic);
	if(b_is_active)
	{
		self animation::play("p7_fxanim_zm_zod_statue_apothicon_start_anim", undefined, undefined, 1);
		self thread animation::play("p7_fxanim_zm_zod_statue_apothicon_idle_anim", undefined, undefined, 1);
	}
	else
	{
		self clearanim("p7_fxanim_zm_zod_statue_apothicon_start_anim", 0);
		self clearanim("p7_fxanim_zm_zod_statue_apothicon_idle_anim", 0);
	}
}

/*
	Name: defend_player_message
	Namespace: zm_zod_sword
	Checksum: 0x7FD0F50A
	Offset: 0x6040
	Size: 0xB2
	Parameters: 1
	Flags: None
*/
function defend_player_message(e_player)
{
	s_placement = level.sword_quest.defend.a_placement[e_player.characterindex];
	if(e_player has_sword(1))
	{
		return &"ZM_ZOD_SWORD_DEFEND_PLACE";
	}
	if(isdefined(s_placement.sword_model) && e_player.sword_quest.upgrade_stage == 2)
	{
		return &"ZM_ZOD_SWORD_DEFEND_RETRIEVE";
	}
	return &"";
}

/*
	Name: give_sword
	Namespace: zm_zod_sword
	Checksum: 0xD5BC8817
	Offset: 0x6100
	Size: 0x2AC
	Parameters: 2
	Flags: Linked
*/
function give_sword(n_sword_level, var_74719138 = 0)
{
	self endon(#"disconnect");
	self set_sword_upgrade_level(n_sword_level);
	self notify(#"hash_b29853d8");
	wait(0.1);
	wpn_sword = level.sword_quest.weapons[self.characterindex][n_sword_level];
	/#
		assert(isdefined(wpn_sword));
	#/
	if(self has_sword())
	{
		self take_sword();
	}
	prev_weapon = self getcurrentweapon();
	self zm_weapons::weapon_give(wpn_sword, 0, 0, 1);
	self.current_sword = self.current_hero_weapon;
	self.sword_power = 1;
	self gadgetpowerset(0, 100);
	self switchtoweapon(wpn_sword);
	self waittill(#"weapon_change_complete");
	self thread sword_use_hint(n_sword_level, var_74719138);
	if(var_74719138)
	{
		self setlowready(1);
		self switchtoweapon(prev_weapon);
		self util::waittill_any_timeout(1, "weapon_change_complete", "disconnect");
		self setlowready(0);
		self.sword_power = 1;
		self clientfield::set_player_uimodel("zmhud.swordEnergy", self.sword_power);
		self gadgetpowerset(0, 100);
		self clientfield::increment_uimodel("zmhud.swordChargeUpdate");
	}
	self thread function_40f1b35b(wpn_sword, n_sword_level);
}

/*
	Name: function_40f1b35b
	Namespace: zm_zod_sword
	Checksum: 0xAB7A6064
	Offset: 0x63B8
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function function_40f1b35b(wpn_sword, n_sword_level)
{
	self endon(#"disconnect");
	var_6f140d05 = 0;
	while(!var_6f140d05)
	{
		self waittill(#"weapon_change_complete");
		weapon = self getcurrentweapon();
		if(weapon === wpn_sword)
		{
			var_6f140d05 = 1;
		}
	}
	zm_zod_vo::function_1f2b0c20(self.characterindex, n_sword_level);
	self thread zm_zod_vo::function_a543408d();
}

/*
	Name: take_sword
	Namespace: zm_zod_sword
	Checksum: 0xD21391D0
	Offset: 0x6480
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function take_sword()
{
	var_d53298a1 = self zm_utility::get_player_hero_weapon();
	self zm_weapons::weapon_take(var_d53298a1);
	self.current_hero_weapon = undefined;
	self.current_sword = undefined;
	self.sword_power = 0;
}

/*
	Name: has_sword
	Namespace: zm_zod_sword
	Checksum: 0xED8D695C
	Offset: 0x64F0
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function has_sword(n_sword_level = self.sword_quest.upgrade_stage)
{
	if(!isdefined(level.sword_quest.weapons[self.characterindex][n_sword_level]))
	{
		return false;
	}
	if(self zm_utility::get_player_hero_weapon() === level.sword_quest.weapons[self.characterindex][n_sword_level])
	{
		return true;
	}
	return false;
}

/*
	Name: sword_equipped
	Namespace: zm_zod_sword
	Checksum: 0xD7A7635D
	Offset: 0x6590
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function sword_equipped(n_sword_level = self.sword_quest.upgrade_stage)
{
	return self getcurrentweapon() == level.sword_quest.weapons[self.characterindex][n_sword_level];
}

/*
	Name: sword_use_hint
	Namespace: zm_zod_sword
	Checksum: 0xE523132F
	Offset: 0x6600
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function sword_use_hint(n_sword_level, var_74719138)
{
	if(!isdefined(self.var_75dcfb99))
	{
		self.var_75dcfb99 = 0;
	}
	if(self.var_75dcfb99 >= n_sword_level)
	{
		return;
	}
	self.var_75dcfb99++;
	if(var_74719138)
	{
		while(self sword_equipped())
		{
			self waittill(#"weapon_change_complete", weapon);
		}
	}
	while(!self sword_equipped())
	{
		self waittill(#"weapon_change_complete", weapon);
	}
	if(n_sword_level == 1)
	{
		zm_equipment::show_hint_text(&"ZM_ZOD_SWORD_1_INSTRUCTIONS", 5);
	}
	else
	{
		zm_equipment::show_hint_text(&"ZM_ZOD_SWORD_2_INSTRUCTIONS", 5);
	}
}

/*
	Name: function_2c009d2e
	Namespace: zm_zod_sword
	Checksum: 0x40215594
	Offset: 0x6708
	Size: 0x7A0
	Parameters: 1
	Flags: Linked
*/
function function_2c009d2e(e_statue)
{
	if(isdefined(e_statue.trigger))
	{
		return;
	}
	s_trigger_pos = struct::get(e_statue.target, "targetname");
	e_statue.trigger = zm_zod_util::spawn_trigger_radius(s_trigger_pos.origin, 64, 1, &function_2f31f931);
	e_statue.trigger.statue_id = e_statue.statue_id;
	while(true)
	{
		e_statue.trigger zm_zod_util::unitrigger_refresh_message();
		e_statue.trigger waittill(#"trigger", e_who);
		if(!isdefined(e_who.var_b170d6d6) && !level flag::get("keeper_sword_locker"))
		{
			continue;
		}
		if(isdefined(e_who.sword_quest.egg_placement))
		{
			if(e_who.sword_quest.egg_placement == e_statue.statue_id)
			{
				if(e_who.sword_quest.kills[e_statue.statue_id] >= 12)
				{
					e_who function_abf3df35(undefined);
					e_who thread zm_zod_vo::function_9bd30516();
					e_who playsound("zmb_zod_egg_pickup");
					if(e_statue.script_noteworthy === "initial_egg_statue")
					{
						wait(0.1);
						e_who clientfield::set_player_uimodel("zmInventory.player_sword_quest_egg_state", 1);
						e_who thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_LVL1_EGG_PICKUP", 3.5);
					}
					else
					{
						e_who function_67bcb9d9();
					}
					if(e_who.sword_quest.all_kills_completed)
					{
						e_who set_sword_upgrade_level(1);
					}
				}
			}
		}
		else
		{
			if(e_who.sword_quest.kills[e_statue.statue_id] < 12)
			{
				e_who function_abf3df35(e_statue.statue_id);
				e_who playsound("zmb_zod_egg_place");
				e_who clientfield::set_player_uimodel("zmInventory.widget_egg", 0);
				e_who thread zm_zod_vo::function_c10cc6c5();
			}
			else
			{
				if(e_who.sword_quest.upgrade_stage > 0 && e_statue.script_noteworthy === "initial_egg_statue" && e_who.var_b170d6d6 === 0)
				{
					e_who playsound("zmb_zod_egg_place");
					e_who clientfield::set_player_uimodel("zmInventory.widget_egg", 0);
					e_who.var_b170d6d6 = 1;
					e_who thread zm_zod_vo::function_c10cc6c5();
					e_who.sword_quest.egg_placement = undefined;
					switch(e_who.characterindex)
					{
						case 0:
						{
							level.sword_quest.swords[e_who.characterindex] setmodel("wpn_t7_zmb_zod_sword1_box_world");
							break;
						}
						case 1:
						{
							level.sword_quest.swords[e_who.characterindex] setmodel("wpn_t7_zmb_zod_sword1_det_world");
							break;
						}
						case 2:
						{
							level.sword_quest.swords[e_who.characterindex] setmodel("wpn_t7_zmb_zod_sword1_fem_world");
							break;
						}
						case 3:
						{
							level.sword_quest.swords[e_who.characterindex] setmodel("wpn_t7_zmb_zod_sword1_mag_world");
							break;
						}
					}
					level.sword_quest.swords[e_who.characterindex].var_c9c683e8 = 1;
					e_statue.trigger zm_zod_util::unitrigger_refresh_message();
					wait(0.75);
					level.sword_quest.swords[e_who.characterindex] thread clientfield::set("sword_statue_glow", 1);
					wait(0.75);
					level.sword_quest.swords[e_who.characterindex].var_c9c683e8 = 0;
				}
				else if(e_who.sword_quest.upgrade_stage > 0 && e_statue.script_noteworthy === "initial_egg_statue" && e_who.var_b170d6d6 === 1)
				{
					e_who.var_b170d6d6 = undefined;
					level.sword_quest.swords[e_who.characterindex] thread clientfield::set("sword_statue_glow", 0);
					level.sword_quest.swords[e_who.characterindex] ghost();
					e_who give_sword(e_who.sword_quest.upgrade_stage, 1);
					if(e_who.sword_quest.upgrade_stage != 2)
					{
						e_who notify(#"hash_1867e603");
						e_who thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_LVL1_SWORD_PICKUP", 3.5);
						e_who function_67bcb9d9();
					}
				}
			}
		}
	}
}

/*
	Name: set_sword_upgrade_level
	Namespace: zm_zod_sword
	Checksum: 0xFA6A2D50
	Offset: 0x6EB0
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function set_sword_upgrade_level(n_level)
{
	if(self.sword_quest.upgrade_stage == n_level)
	{
		return;
	}
	switch(self.sword_quest.upgrade_stage)
	{
		case 1:
		{
			break;
		}
	}
	self.sword_quest.upgrade_stage = n_level;
}

/*
	Name: sword_devgui
	Namespace: zm_zod_sword
	Checksum: 0x1FFA3F48
	Offset: 0x6F20
	Size: 0x790
	Parameters: 0
	Flags: Linked
*/
function sword_devgui()
{
	/#
		setdvar("", 0);
		setdvar("", "");
		setdvar("", "");
		setdvar("", 0);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		level thread zm_zod_util::setup_devgui_func("", "", 0, &function_b3babd8c);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_b3babd8c);
		level thread zm_zod_util::setup_devgui_func("", "", 2, &function_b3babd8c);
		level thread zm_zod_util::setup_devgui_func("", "", 4, &function_b3babd8c);
		n_sword_level = 0;
		var_47719d0d = 0;
		s_sword_rock = getent("", "");
		while(true)
		{
			n_level = getdvarint("");
			if(n_level == 1)
			{
				foreach(e_player in level.activeplayers)
				{
					e_player.usingsword = 0;
					e_player zm_weap_glaive::disabled_sword();
					e_player notify(#"hash_b29853d8");
					if(isdefined(e_player.var_c0d25105))
					{
						e_player.var_c0d25105 notify(#"returned_to_owner");
					}
					e_player give_sword(n_level, 1);
					e_player.sword_allowed = 1;
					e_player notify(#"hash_1867e603");
					setdvar("", "");
				}
			}
			else if(n_level == 2)
			{
				foreach(e_player in level.activeplayers)
				{
					e_player.usingsword = 0;
					e_player zm_weap_glaive::disabled_sword();
					e_player notify(#"hash_b29853d8");
					if(isdefined(e_player.var_c0d25105))
					{
						e_player.var_c0d25105 notify(#"returned_to_owner");
					}
					e_player give_sword(n_level, 1);
					e_player.sword_allowed = 1;
					setdvar("", "");
				}
			}
			str_cheat = getdvarstring("");
			switch(str_cheat)
			{
				case "":
				{
					foreach(e_player in level.players)
					{
						e_player.sword_quest.cheat = 1;
					}
					break;
				}
				default:
				{
					break;
				}
			}
			str_cheat = getdvarstring("");
			switch(str_cheat)
			{
				case "":
				{
					foreach(e_player in level.players)
					{
						if(!isdefined(e_player.swordpreserve))
						{
							e_player.swordpreserve = 1;
							continue;
						}
						e_player.swordpreserve = !e_player.swordpreserve;
					}
					break;
				}
				default:
				{
					break;
				}
			}
			setdvar("", "");
			var_e4b329eb = getdvarint("");
			if(var_e4b329eb > 0)
			{
				foreach(e_player in level.players)
				{
					zm_weap_glaive::function_7855de72(e_player);
				}
			}
			setdvar("", "");
			util::wait_network_frame();
		}
	#/
}

/*
	Name: function_31880c32
	Namespace: zm_zod_sword
	Checksum: 0xB29F2A65
	Offset: 0x76B8
	Size: 0x10
	Parameters: 1
	Flags: None
*/
function function_31880c32(var_27b0f0e4)
{
	/#
	#/
}

/*
	Name: function_b3babd8c
	Namespace: zm_zod_sword
	Checksum: 0x66881435
	Offset: 0x76D0
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function function_b3babd8c(var_5df86706)
{
	/#
		foreach(player in level.players)
		{
			for(i = 0; i < 4; i++)
			{
				player clientfield::set_to_player("" + i, var_5df86706);
			}
		}
	#/
}

