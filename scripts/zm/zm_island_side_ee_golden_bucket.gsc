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
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_attackables;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_keeper_skull;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\bgbs\_zm_bgb_anywhere_but_here;
#using scripts\zm\bgbs\_zm_bgb_pop_shocks;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island_perks;
#using scripts\zm\zm_island_planting;
#using scripts\zm\zm_island_power;
#using scripts\zm\zm_island_util;

#namespace namespace_d9f30fb4;

/*
	Name: init
	Namespace: namespace_d9f30fb4
	Checksum: 0x2B91F652
	Offset: 0x988
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	register_clientfields();
	/#
		function_66eeac50();
	#/
}

/*
	Name: register_clientfields
	Namespace: namespace_d9f30fb4
	Checksum: 0x20759AC0
	Offset: 0x9C0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("world", "reveal_golden_bucket_planting_location", 9000, 1, "int");
	clientfield::register("scriptmover", "golden_bucket_glow_fx", 9000, 1, "int");
}

/*
	Name: main
	Namespace: namespace_d9f30fb4
	Checksum: 0x7F8014D0
	Offset: 0xA30
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_ee79f2bd();
}

/*
	Name: function_ee79f2bd
	Namespace: namespace_d9f30fb4
	Checksum: 0xA62E7D02
	Offset: 0xA58
	Size: 0x234
	Parameters: 0
	Flags: Linked
*/
function function_ee79f2bd()
{
	level flag::init("prereq_plants_grown_golden_bucket_ee");
	level flag::init("bucket_planted");
	level flag::init("golden_bucket_ee_completed");
	level thread function_8db1ed35();
	s_planting_spot = struct::get("planting_spot_golden_bucket", "targetname");
	s_planting_spot.model = util::spawn_model("p7_zm_isl_plant_planter", s_planting_spot.origin, s_planting_spot.angles);
	s_planting_spot.s_plant = spawnstruct();
	s_planting_spot.s_plant.model = util::spawn_model("tag_origin", s_planting_spot.origin, s_planting_spot.angles);
	level flag::wait_till("skull_quest_complete");
	level flag::wait_till("prereq_plants_grown_golden_bucket_ee");
	foreach(player in level.players)
	{
		player thread function_e6cfa209();
	}
	callback::on_spawned(&function_e6cfa209);
}

/*
	Name: function_8db1ed35
	Namespace: namespace_d9f30fb4
	Checksum: 0x516ACECE
	Offset: 0xC98
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_8db1ed35()
{
	level util::waittill_multiple("minor_cache_plant_spawned", "major_cache_plant_spawned", "babysitter_plant_spawned", "trap_plant_spawned", "fruit_plant_spawned");
	level flag::set("prereq_plants_grown_golden_bucket_ee");
}

/*
	Name: function_e6cfa209
	Namespace: namespace_d9f30fb4
	Checksum: 0x6EB61B13
	Offset: 0xD08
	Size: 0x15A
	Parameters: 0
	Flags: Linked
*/
function function_e6cfa209()
{
	self endon(#"disconnect");
	level endon(#"hash_e6cfa209");
	e_clip = getent("swamp_planter_skull_reveal", "targetname");
	while(true)
	{
		if(self util::ads_button_held())
		{
			if(self getcurrentweapon() !== level.var_c003f5b)
			{
				while(self adsbuttonpressed())
				{
					wait(0.05);
				}
			}
			else if(self getammocount(level.var_c003f5b))
			{
				if(self keeper_skull::function_3f3f64e9(e_clip) && self keeper_skull::function_5fa274c1(e_clip))
				{
					break;
				}
			}
		}
		wait(0.1);
	}
	level thread function_26f677a6(e_clip);
	callback::remove_on_spawned(&function_e6cfa209);
	level notify(#"hash_e6cfa209");
}

/*
	Name: function_26f677a6
	Namespace: namespace_d9f30fb4
	Checksum: 0x36C28675
	Offset: 0xE70
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function function_26f677a6(e_clip)
{
	level clientfield::set("reveal_golden_bucket_planting_location", 1);
	playsoundatposition("zmb_wpn_skullgun_discover", e_clip.origin);
	exploder::exploder("fxexp_515");
	wait(3);
	e_clip delete();
	s_planting_spot = struct::get("planting_spot_golden_bucket", "targetname");
	s_planting_spot.script_unitrigger_type = "unitrigger_box_use";
	s_planting_spot.cursor_hint = "HINT_NOICON";
	s_planting_spot.script_width = 128;
	s_planting_spot.script_height = 128;
	s_planting_spot.script_length = 128;
	s_planting_spot.require_look_at = 1;
	s_planting_spot.prompt_and_visibility_func = &function_4fd948c5;
	zm_unitrigger::register_static_unitrigger(s_planting_spot, &function_870bdfee);
	level flag::wait_till("bucket_planted");
	zm_unitrigger::unregister_unitrigger(s_planting_spot);
}

/*
	Name: function_4fd948c5
	Namespace: namespace_d9f30fb4
	Checksum: 0x77FA9D63
	Offset: 0x1020
	Size: 0x96
	Parameters: 1
	Flags: Linked
*/
function function_4fd948c5(player)
{
	if(player clientfield::get_to_player("bucket_held") && !level flag::get("bucket_planted"))
	{
		self sethintstring(&"ZM_ISLAND_PLANT_BUCKET");
		return true;
	}
	self sethintstring("");
	return false;
}

/*
	Name: function_870bdfee
	Namespace: namespace_d9f30fb4
	Checksum: 0x845ACC53
	Offset: 0x10C0
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function function_870bdfee()
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
		if(player clientfield::get_to_player("bucket_held"))
		{
			self thread function_9b3bd7c4(player);
		}
	}
}

/*
	Name: function_9b3bd7c4
	Namespace: namespace_d9f30fb4
	Checksum: 0xB891E83F
	Offset: 0x1178
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function function_9b3bd7c4(e_player)
{
	level flag::set("bucket_planted");
	e_player thread zm_island_power::function_4b057b64();
	self.stub.s_plant.model setmodel("p7_fxanim_zm_island_plant_seed_mod");
	self.stub.s_plant.model show();
	self.stub.s_plant.model notsolid();
	self scene::init("p7_fxanim_zm_island_plant_stage1_bundle", self.stub.s_plant.model);
	self.stub.s_plant.model playsound("evt_island_seed_grow_stage_1");
	level thread function_4cebde70();
}

/*
	Name: function_4cebde70
	Namespace: namespace_d9f30fb4
	Checksum: 0xD2A330AC
	Offset: 0x12C8
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function function_4cebde70()
{
	level thread function_c2dab6c5();
	exploder::exploder("fxexp_800");
	wait(2);
	var_fc72ce0a = struct::get_array("planting_spot_golden_bucket_challenge", "targetname");
	foreach(s_planting_spot in var_fc72ce0a)
	{
		s_planting_spot.model = util::spawn_model("p7_zm_isl_plant_planter", s_planting_spot.origin, s_planting_spot.angles);
		s_planting_spot.model movez(16, 2);
		playsoundatposition("zmb_planters_appear", s_planting_spot.origin);
	}
	s_planting_spot.model waittill(#"movedone");
	level thread function_152720d8(var_fc72ce0a);
}

/*
	Name: function_152720d8
	Namespace: namespace_d9f30fb4
	Checksum: 0x1B6AC74B
	Offset: 0x1468
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function function_152720d8(var_fc72ce0a)
{
	foreach(var_8c46024b in var_fc72ce0a)
	{
		var_8c46024b.origin = var_8c46024b.model.origin;
		var_8c46024b zm_island_planting::function_fedc998b(1);
	}
	level.a_s_planting_spots = arraycombine(level.a_s_planting_spots, var_fc72ce0a, 0, 0);
}

/*
	Name: function_c2dab6c5
	Namespace: namespace_d9f30fb4
	Checksum: 0x559CE7C0
	Offset: 0x1558
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function function_c2dab6c5()
{
	e_volume = getent("golden_bucket_ee_volume", "targetname");
	while(!level flag::get("golden_bucket_ee_completed"))
	{
		while(true)
		{
			if(function_9a2f5188(e_volume) && function_e630b27f())
			{
				break;
			}
			wait(1);
		}
		level thread function_64b86454();
		level thread function_738acad6();
		level thread function_f0d8de1d();
		function_21bde96b();
	}
}

/*
	Name: function_21bde96b
	Namespace: namespace_d9f30fb4
	Checksum: 0x9C7AB744
	Offset: 0x1650
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_21bde96b()
{
	level endon(#"hash_247c3608");
	for(var_79f8fdda = 0; var_79f8fdda < 50; var_79f8fdda++)
	{
		level waittill(#"hash_8c54f723");
	}
	level flag::set("golden_bucket_ee_completed");
	level notify(#"hash_4d1841e4");
	level thread function_4d1841e4();
}

/*
	Name: function_64b86454
	Namespace: namespace_d9f30fb4
	Checksum: 0xBEA4E365
	Offset: 0x16D8
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function function_64b86454()
{
	level endon(#"hash_4d1841e4");
	while(true)
	{
		if(!function_e630b27f())
		{
			break;
		}
		wait(1);
	}
	level notify(#"hash_247c3608");
}

/*
	Name: function_738acad6
	Namespace: namespace_d9f30fb4
	Checksum: 0x1340E0CC
	Offset: 0x1730
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_738acad6()
{
	level endon(#"hash_247c3608");
	level endon(#"hash_4d1841e4");
	wait(600);
	level thread function_72c0a344();
}

/*
	Name: function_f0d8de1d
	Namespace: namespace_d9f30fb4
	Checksum: 0x8524D8AC
	Offset: 0x1770
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_f0d8de1d()
{
	level endon(#"hash_247c3608");
	level endon(#"hash_62e8dbc1");
	level endon(#"hash_4d1841e4");
	e_volume = getent("golden_bucket_ee_volume", "targetname");
	n_timeout = 120;
	while(true)
	{
		n_counter = n_timeout;
		while(!function_9a2f5188(e_volume))
		{
			n_counter = n_counter - 1;
			if(n_counter == 0)
			{
				level thread function_72c0a344();
				level notify(#"hash_62e8dbc1");
			}
			wait(1);
		}
		wait(0.05);
	}
}

/*
	Name: function_72c0a344
	Namespace: namespace_d9f30fb4
	Checksum: 0xB928972C
	Offset: 0x1860
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_72c0a344()
{
	var_fc72ce0a = struct::get_array("planting_spot_golden_bucket_challenge", "targetname");
	foreach(var_8c46024b in var_fc72ce0a)
	{
		var_8c46024b thread function_c1f64636(0);
		wait(0.05);
	}
}

/*
	Name: function_9a2f5188
	Namespace: namespace_d9f30fb4
	Checksum: 0x9AAC77A1
	Offset: 0x1930
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function function_9a2f5188(e_volume)
{
	a_players = getplayers();
	foreach(player in a_players)
	{
		if(player istouching(e_volume))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_e630b27f
	Namespace: namespace_d9f30fb4
	Checksum: 0x28BC77BD
	Offset: 0x19F8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_e630b27f()
{
	var_fc72ce0a = struct::get_array("planting_spot_golden_bucket_challenge", "targetname");
	foreach(var_8c46024b in var_fc72ce0a)
	{
		if(isdefined(var_8c46024b.s_plant) && isdefined(var_8c46024b.s_plant.var_b454101b) && var_8c46024b.s_plant.var_b454101b.health > 0)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_4d1841e4
	Namespace: namespace_d9f30fb4
	Checksum: 0xC87A7D21
	Offset: 0x1B00
	Size: 0x62C
	Parameters: 0
	Flags: Linked
*/
function function_4d1841e4()
{
	level flag::init("golden_bucket_cache_plant_opened");
	level flag::init("golden_bucket_planters_empty");
	playsoundatposition("zmb_golden_bucket_success", (0, 0, 0));
	level thread function_6742be8f();
	var_fc72ce0a = struct::get_array("planting_spot_golden_bucket_challenge", "targetname");
	foreach(var_8c46024b in var_fc72ce0a)
	{
		var_8c46024b thread function_c1f64636(1);
		wait(0.05);
	}
	level flag::wait_till("golden_bucket_planters_empty");
	function_41280a71();
	s_planting_spot = struct::get("planting_spot_golden_bucket", "targetname");
	s_planting_spot.s_plant.model clientfield::set("plant_growth_siege_anims", 1);
	s_planting_spot scene::play("p7_fxanim_zm_island_plant_stage1_bundle", s_planting_spot.s_plant.model);
	s_planting_spot.s_plant.model playsound("evt_island_seed_grow_stage_2");
	wait(2);
	s_planting_spot.s_plant.model solid();
	s_planting_spot.s_plant.model disconnectpaths();
	s_planting_spot.s_plant.model clientfield::set("plant_growth_siege_anims", 2);
	s_planting_spot scene::play("p7_fxanim_zm_island_plant_stage2_bundle", s_planting_spot.s_plant.model);
	s_planting_spot.s_plant.model playsound("evt_island_seed_grow_stage_3");
	wait(2);
	s_planting_spot.s_plant.model clientfield::set("plant_growth_siege_anims", 3);
	s_planting_spot thread scene::play("p7_fxanim_zm_island_plant_stage3_bundle", s_planting_spot.s_plant.model);
	s_planting_spot.s_plant.model waittill(#"hash_116e737b");
	s_planting_spot.s_plant.model setmodel("p7_fxanim_zm_island_plant_cache_major_glow_mod");
	s_planting_spot.s_plant.model clientfield::set("cache_plant_interact_fx", 1);
	s_planting_spot.s_plant.model disconnectpaths();
	s_planting_spot thread scene::init("p7_fxanim_zm_island_plant_cache_major_bundle", s_planting_spot.s_plant.model);
	s_planting_spot.s_plant.model waittill(#"hash_aa2731d8");
	s_planting_spot.prompt_and_visibility_func = &function_53296cde;
	zm_unitrigger::register_static_unitrigger(s_planting_spot, &function_30804104);
	level flag::wait_till("golden_bucket_cache_plant_opened");
	s_planting_spot.s_plant.model clientfield::set("cache_plant_interact_fx", 0);
	zm_unitrigger::unregister_unitrigger(s_planting_spot);
	s_planting_spot scene::play("p7_fxanim_zm_island_plant_cache_major_bundle", s_planting_spot.s_plant.model);
	m_reward = util::spawn_model("p7_zm_isl_bucket_115_gold", s_planting_spot.origin + vectorscale((0, 0, 1), 36), s_planting_spot.angles);
	m_reward clientfield::set("golden_bucket_glow_fx", 1);
	playsoundatposition("zmb_golden_bucket_appear", s_planting_spot.origin + vectorscale((0, 0, 1), 36));
	wait(1);
	s_planting_spot.prompt_and_visibility_func = &function_53296cde;
	zm_unitrigger::register_static_unitrigger(s_planting_spot, &function_da9c118b);
}

/*
	Name: function_c1f64636
	Namespace: namespace_d9f30fb4
	Checksum: 0xDA7BD2CA
	Offset: 0x2138
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function function_c1f64636(b_completed)
{
	if(b_completed)
	{
		zm_unitrigger::unregister_unitrigger(self.s_plant_unitrigger);
		if(isdefined(self.s_plant.var_b454101b))
		{
			self.s_plant.var_b454101b zm_attackables::deactivate();
			self notify(#"hash_4729ad2");
		}
		wait(3);
		while(true)
		{
			if(isdefined(self.s_plant) && isdefined(self.s_plant.var_b454101b))
			{
				self.s_plant.var_b454101b zm_attackables::do_damage(self.s_plant.var_b454101b.health);
			}
			if(self.var_75c7a97e == 0)
			{
				self notify(#"hash_7a0cef7b");
				break;
			}
			wait(0.1);
		}
		level notify(#"hash_46080242");
		arrayremovevalue(level.a_s_planting_spots, self);
	}
	else if(isdefined(self.s_plant) && isdefined(self.s_plant.var_b454101b))
	{
		self.s_plant.var_b454101b zm_attackables::do_damage(self.s_plant.var_b454101b.health);
	}
}

/*
	Name: function_6742be8f
	Namespace: namespace_d9f30fb4
	Checksum: 0x6A3D31DD
	Offset: 0x22D8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_6742be8f()
{
	for(i = 0; i < 3; i++)
	{
		level waittill(#"hash_46080242");
	}
	level flag::set("golden_bucket_planters_empty");
}

/*
	Name: function_41280a71
	Namespace: namespace_d9f30fb4
	Checksum: 0x94CB8FF8
	Offset: 0x2338
	Size: 0x202
	Parameters: 0
	Flags: Linked
*/
function function_41280a71()
{
	exploder::exploder("fxexp_801");
	var_fc72ce0a = struct::get_array("planting_spot_golden_bucket_challenge", "targetname");
	foreach(s_planting_spot in var_fc72ce0a)
	{
		s_planting_spot.s_plant.model linkto(s_planting_spot.model);
		s_planting_spot.model movez(-16, 2);
		playsoundatposition("zmb_planters_disappear", s_planting_spot.origin);
	}
	s_planting_spot.model waittill(#"movedone");
	foreach(s_planting_spot in var_fc72ce0a)
	{
		s_planting_spot.s_plant.model delete();
		s_planting_spot.model delete();
	}
}

/*
	Name: function_53296cde
	Namespace: namespace_d9f30fb4
	Checksum: 0x223011B1
	Offset: 0x2548
	Size: 0xBE
	Parameters: 1
	Flags: Linked
*/
function function_53296cde(player)
{
	if(!level flag::get("golden_bucket_cache_plant_opened"))
	{
		self sethintstring(&"ZM_ISLAND_CACHE_PLANT");
		return true;
	}
	if(!(isdefined(player.var_b6a244f9) && player.var_b6a244f9))
	{
		self sethintstring(&"ZM_ISLAND_PICKUP_GOLDEN_BUCKET");
		return true;
	}
	self sethintstring("");
	return false;
}

/*
	Name: function_30804104
	Namespace: namespace_d9f30fb4
	Checksum: 0x1B79BF1C
	Offset: 0x2610
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function function_30804104()
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
		level flag::set("golden_bucket_cache_plant_opened");
	}
}

/*
	Name: function_da9c118b
	Namespace: namespace_d9f30fb4
	Checksum: 0xF5A6DE40
	Offset: 0x26B0
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function function_da9c118b()
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
		if(!(isdefined(player.var_b6a244f9) && player.var_b6a244f9))
		{
			player thread function_bbd146a7();
			player notify(#"player_got_gold_bucket");
		}
	}
}

/*
	Name: function_bbd146a7
	Namespace: namespace_d9f30fb4
	Checksum: 0x9159FCC8
	Offset: 0x2780
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_bbd146a7()
{
	self endon(#"disconnect");
	self.var_b6a244f9 = 1;
	self zm_island_power::function_d570abb();
	self thread function_da0bbc71();
}

/*
	Name: function_da0bbc71
	Namespace: namespace_d9f30fb4
	Checksum: 0x67A5312C
	Offset: 0x27D8
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_da0bbc71()
{
	self endon(#"disconnect");
	wait(3.75);
	while(true)
	{
		if(self meleebuttonpressed() && self sprintbuttonpressed())
		{
			if(self zm_utility::in_revive_trigger())
			{
				wait(0.1);
				continue;
			}
			if(self.is_drinking > 0)
			{
				wait(0.1);
				continue;
			}
			if(!zm_utility::is_player_valid(self))
			{
				wait(0.1);
				continue;
			}
			self.var_c6cad973 = self.var_c6cad973 + 1;
			if(self.var_c6cad973 > 3)
			{
				self.var_c6cad973 = 1;
			}
			self thread zm_island_power::function_a84a1aec(self.var_c6cad973, 0);
			wait(3.75);
		}
		else
		{
			wait(0.1);
		}
	}
}

/*
	Name: function_66eeac50
	Namespace: namespace_d9f30fb4
	Checksum: 0x587EA36C
	Offset: 0x2900
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_66eeac50()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_3655d28a);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: function_3655d28a
	Namespace: namespace_d9f30fb4
	Checksum: 0xE3F9E170
	Offset: 0x2980
	Size: 0x1A0
	Parameters: 1
	Flags: Linked
*/
function function_3655d28a(cmd)
{
	/#
		switch(cmd)
		{
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
				e_clip = getent("", "");
				level thread function_26f677a6(e_clip);
				level notify(#"hash_e6cfa209");
				return true;
			}
			case "":
			{
				foreach(player in level.players)
				{
					player thread function_bbd146a7();
				}
				return true;
			}
		}
		return false;
	#/
}

