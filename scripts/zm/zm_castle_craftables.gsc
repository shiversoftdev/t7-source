// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_elemental_zombies;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_gravityspikes;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_castle_vo;
#using scripts\zm\zm_castle_zones;

#namespace zm_castle_craftables;

/*
	Name: randomize_craftable_spawns
	Namespace: zm_castle_craftables
	Checksum: 0x99EC1590
	Offset: 0x910
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function randomize_craftable_spawns()
{
}

/*
	Name: include_craftables
	Namespace: zm_castle_craftables
	Checksum: 0x3EB2BA9B
	Offset: 0x920
	Size: 0x364
	Parameters: 0
	Flags: Linked
*/
function include_craftables()
{
	level.craftable_piece_swap_allowed = 0;
	shared_pieces = getnumexpectedplayers() == 1;
	craftable_name = "gravityspike";
	var_2f18d6d0 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_body", 32, 64, 0, undefined, &function_c1e52ea6, undefined, undefined, undefined, undefined, undefined, ("gravityspike" + "_") + "part_body", 1, undefined, undefined, "", 0);
	var_3b105a = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_guards", 32, 64, 0, undefined, &function_c1e52ea6, undefined, undefined, undefined, undefined, undefined, ("gravityspike" + "_") + "part_guards", 1, undefined, undefined, "", 0);
	var_2e6bf9ce = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_handle", 32, 64, 0, undefined, &function_c1e52ea6, undefined, undefined, undefined, undefined, undefined, ("gravityspike" + "_") + "part_handle", 1, undefined, undefined, "", 0);
	var_2f18d6d0.special_spawn_func = &function_68b89800;
	var_3b105a.special_spawn_func = &function_e8931ee2;
	var_2e6bf9ce.special_spawn_func = &function_436d6e8e;
	var_2f18d6d0.client_field_state = undefined;
	var_3b105a.client_field_state = undefined;
	var_2e6bf9ce.client_field_state = undefined;
	gravityspike = spawnstruct();
	gravityspike.name = craftable_name;
	gravityspike zm_craftables::add_craftable_piece(var_2f18d6d0);
	gravityspike zm_craftables::add_craftable_piece(var_3b105a);
	gravityspike zm_craftables::add_craftable_piece(var_2e6bf9ce);
	gravityspike.triggerthink = &function_d8efa7d6;
	zm_craftables::include_zombie_craftable(gravityspike);
	level flag::init(((craftable_name + "_") + "part_body") + "_found");
	level flag::init(((craftable_name + "_") + "part_guards") + "_found");
	level flag::init(((craftable_name + "_") + "part_handle") + "_found");
}

/*
	Name: init_craftables
	Namespace: zm_castle_craftables
	Checksum: 0xE80DF356
	Offset: 0xC90
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function init_craftables()
{
	register_clientfields();
	zm_craftables::add_zombie_craftable("gravityspike", &"ZM_CASTLE_GRAVITYSPIKE_CRAFT", "", &"ZM_CASTLE_GRAVITYSPIKE_PICKUP", &function_61ac1c22, 1);
	zm_craftables::make_zombie_craftable_open("gravityspike", "", vectorscale((0, -1, 0), 90), (0, 0, 0));
	level._effect["craftable_powerup_grabbed"] = "dlc1/castle/fx_talon_spike_grab_castle";
}

/*
	Name: register_clientfields
	Namespace: zm_castle_craftables
	Checksum: 0x8F5BDEB9
	Offset: 0xD40
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	shared_bits = 1;
	registerclientfield("world", ("gravityspike" + "_") + "part_body", 1, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("gravityspike" + "_") + "part_guards", 1, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("gravityspike" + "_") + "part_handle", 1, shared_bits, "int", undefined, 0);
	clientfield::register("scriptmover", "craftable_powerup_fx", 1, 1, "int");
	clientfield::register("scriptmover", "craftable_teleport_fx", 1, 1, "int");
	clientfield::register("toplayer", "ZMUI_GRAVITYSPIKE_PART_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZMUI_GRAVITYSPIKE_CRAFTED", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.widget_gravityspike_parts", 1, 1, "int");
	clientfield::register("clientuimodel", "zmInventory.player_crafted_gravityspikes", 1, 1, "int");
}

/*
	Name: function_68b89800
	Namespace: zm_castle_craftables
	Checksum: 0x9210A937
	Offset: 0xF58
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_68b89800(piecestub)
{
	self thread function_38b275a8(piecestub);
}

/*
	Name: function_38b275a8
	Namespace: zm_castle_craftables
	Checksum: 0xBA97C018
	Offset: 0xF88
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function function_38b275a8(var_d97c08b2)
{
	self endon(#"hash_92009fcb");
	self function_9980920d(var_d97c08b2);
	while(true)
	{
		level waittill(#"hash_b650259c", v_pos);
		self function_2742ffd4(var_d97c08b2, 0, v_pos);
		self waittill(#"hash_750017bb");
		self zm_craftables::piece_pick_random_spawn();
	}
}

/*
	Name: function_436d6e8e
	Namespace: zm_castle_craftables
	Checksum: 0x9FE4FF1E
	Offset: 0x1020
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_436d6e8e(piecestub)
{
	self thread function_1e020746(piecestub);
}

/*
	Name: function_1e020746
	Namespace: zm_castle_craftables
	Checksum: 0x6212B0AB
	Offset: 0x1050
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function function_1e020746(var_d97c08b2)
{
	self endon(#"hash_92009fcb");
	self function_9980920d(var_d97c08b2);
	while(true)
	{
		level flag::wait_till("tesla_coil_on");
		level flag::wait_till_clear("tesla_coil_on");
		self function_2742ffd4(var_d97c08b2, 1, undefined, 115);
		array::thread_all(level.activeplayers, &function_31bdb575, self);
		self waittill(#"hash_750017bb");
		self zm_craftables::piece_pick_random_spawn();
	}
}

/*
	Name: function_31bdb575
	Namespace: zm_castle_craftables
	Checksum: 0x41E5FA84
	Offset: 0x1140
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function function_31bdb575(var_6aeefdcb)
{
	var_6aeefdcb endon(#"hash_92009fcb");
	var_6aeefdcb endon(#"hash_750017bb");
	n_distance_sq = 16384;
	while(isdefined(self) && isdefined(var_6aeefdcb.model))
	{
		var_317739a1 = distancesquared(self.origin, var_6aeefdcb.model.origin);
		if(var_317739a1 <= n_distance_sq)
		{
			var_6aeefdcb.unitrigger notify(#"trigger", self);
			self thread zm_craftables::player_take_piece(var_6aeefdcb);
		}
		util::wait_network_frame();
	}
}

/*
	Name: function_e8931ee2
	Namespace: zm_castle_craftables
	Checksum: 0x3A577600
	Offset: 0x1228
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function function_e8931ee2(piecestub)
{
	var_309c2973 = getent("spike_quest_console_switch", "targetname");
	var_309c2973.unitrigger = var_309c2973 function_ab1218c8();
	var_85a409cc = getent("spike_quest_wall_switch", "targetname");
	var_85a409cc.unitrigger = var_85a409cc function_af32bcac();
	self thread function_bf54e556(piecestub, var_85a409cc);
	self thread function_cecf7412(piecestub, var_309c2973);
}

/*
	Name: function_af32bcac
	Namespace: zm_castle_craftables
	Checksum: 0x12C2EA7C
	Offset: 0x1318
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_af32bcac()
{
	level flag::init("rocket_pad_trigger_available");
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = self.origin;
	unitrigger_stub.angles = self.angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.radius = 64;
	unitrigger_stub.prompt_and_visibility_func = &function_daa4f9c9;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_7d712d6a);
	return unitrigger_stub;
}

/*
	Name: function_daa4f9c9
	Namespace: zm_castle_craftables
	Checksum: 0x99BBCED0
	Offset: 0x1408
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function function_daa4f9c9(player)
{
	if(level flag::get("rocket_pad_trigger_available") && (!(isdefined(level.var_ddbeeb3f) && level.var_ddbeeb3f)))
	{
		self sethintstring(&"ZM_CASTLE_GRAVITYSPIKE_A10_SWITCH");
		return true;
	}
	self sethintstring("");
	return false;
}

/*
	Name: function_7d712d6a
	Namespace: zm_castle_craftables
	Checksum: 0x41263E8C
	Offset: 0x14A0
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function function_7d712d6a()
{
	self endon(#"kill_trigger");
	self.stub thread zm_unitrigger::run_visibility_function_for_all_triggers();
	while(!level flag::get("gravityspike_part_guards_found"))
	{
		self waittill(#"trigger", e_who);
		self.stub notify(#"trigger", e_who);
		level notify(#"a10_wall_switch_activated");
		level thread function_f387f091();
		level flag::wait_till_clear("rocket_firing");
	}
	zm_unitrigger::unregister_unitrigger(self);
}

/*
	Name: function_bf54e556
	Namespace: zm_castle_craftables
	Checksum: 0xD949A479
	Offset: 0x1580
	Size: 0x260
	Parameters: 2
	Flags: Linked
*/
function function_bf54e556(var_d97c08b2, var_85a409cc)
{
	var_85a409cc playsound("evt_tram_lever");
	exploder::exploder("lgt_gs_console_red_0");
	var_d5793a57 = getent("spike_quest_wall_door", "targetname");
	while(!level flag::get("gravityspike_part_guards_found"))
	{
		level flag::wait_till("rocket_firing");
		wait(6);
		level flag::set("rocket_pad_trigger_available");
		exploder::exploder("lgt_gs_console_grn_0");
		exploder::stop_exploder("lgt_gs_console_red_0");
		var_85a409cc rotateroll(-120, 0.5);
		var_d5793a57 rotateyaw(-120, 0.25);
		var_85a409cc playsound("evt_tram_lever");
		level util::waittill_either("a10_wall_switch_activated", "open_a10_doors");
		level flag::clear("rocket_pad_trigger_available");
		exploder::exploder("lgt_gs_console_red_0");
		exploder::stop_exploder("lgt_gs_console_grn_0");
		var_85a409cc rotateroll(120, 0.5);
		var_85a409cc playsound("evt_tram_lever");
		level flag::wait_till_clear("rocket_firing");
		var_d5793a57 rotateyaw(120, 0.25);
	}
}

/*
	Name: function_ab1218c8
	Namespace: zm_castle_craftables
	Checksum: 0x8C89F27A
	Offset: 0x17E8
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function function_ab1218c8()
{
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = self.origin;
	unitrigger_stub.angles = self.angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.radius = 64;
	unitrigger_stub.prompt_and_visibility_func = &function_26a928fd;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_ef8e1546);
	return unitrigger_stub;
}

/*
	Name: function_cecf7412
	Namespace: zm_castle_craftables
	Checksum: 0x1CA688C2
	Offset: 0x18B8
	Size: 0x442
	Parameters: 2
	Flags: Linked
*/
function function_cecf7412(var_d97c08b2, var_309c2973)
{
	self function_9980920d(var_d97c08b2);
	var_586d1d4f = getent("spike_quest_console", "targetname");
	var_586d1d4f clientfield::set("death_ray_status_light", 2);
	var_309c2973 rotateroll(-120, 0.5);
	var_309c2973 playsound("evt_tram_lever");
	exploder::exploder("lgt_gs_console_red_1");
	exploder::exploder("lgt_gs_console_red_2");
	exploder::exploder("lgt_gs_console_red_3");
	while(!level flag::get("gravityspike_part_guards_found"))
	{
		level waittill(#"a10_wall_switch_activated");
		exploder::stop_exploder("lgt_gs_console_red_1");
		level function_ff4c7ead("lgt_gs_console_grn_1");
		var_586d1d4f playsound("zmb_console_light");
		exploder::stop_exploder("lgt_gs_console_red_2");
		level function_ff4c7ead("lgt_gs_console_grn_2");
		var_586d1d4f playsound("zmb_console_light");
		exploder::stop_exploder("lgt_gs_console_red_3");
		level function_ff4c7ead("lgt_gs_console_grn_3");
		var_586d1d4f playsound("zmb_console_light_completed");
		level.var_d73f1734 = 1;
		var_586d1d4f clientfield::set("death_ray_status_light", 1);
		var_309c2973 rotateroll(120, 0.5);
		var_309c2973 playsound("evt_tram_lever");
		level util::waittill_any_timeout(4, "a10_switch_activated");
		var_586d1d4f playsound("zmb_console_light_reset");
		level.var_d73f1734 = undefined;
		var_586d1d4f clientfield::set("death_ray_status_light", 2);
		var_309c2973 rotateroll(-120, 0.5);
		var_309c2973 playsound("evt_tram_lever");
		exploder::exploder("lgt_gs_console_red_1");
		exploder::exploder("lgt_gs_console_red_2");
		exploder::exploder("lgt_gs_console_red_3");
		exploder::stop_exploder("lgt_gs_console_grn_1");
		exploder::stop_exploder("lgt_gs_console_grn_2");
		exploder::stop_exploder("lgt_gs_console_grn_3");
		if(isdefined(level.var_ddbeeb3f) && level.var_ddbeeb3f)
		{
			self function_2742ffd4(var_d97c08b2, 1);
		}
		level flag::wait_till_clear("rocket_firing");
		level.var_ddbeeb3f = undefined;
	}
}

/*
	Name: function_ff4c7ead
	Namespace: zm_castle_craftables
	Checksum: 0x7A814AEB
	Offset: 0x1D08
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_ff4c7ead(str_exploder)
{
	n_start_time = gettime();
	n_total_time = 0;
	while(n_total_time < 11)
	{
		exploder::exploder(str_exploder);
		wait(0.2);
		exploder::stop_exploder(str_exploder);
		wait(0.2);
		n_total_time = (gettime() - n_start_time) / 1000;
	}
	exploder::exploder(str_exploder);
}

/*
	Name: function_26a928fd
	Namespace: zm_castle_craftables
	Checksum: 0x562FE7D3
	Offset: 0x1DC0
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function function_26a928fd(player)
{
	if(!(isdefined(level.var_ddbeeb3f) && level.var_ddbeeb3f) && (isdefined(level.var_d73f1734) && level.var_d73f1734))
	{
		self sethintstring(&"ZM_CASTLE_GRAVITYSPIKE_A10_CONSOLE");
		return true;
	}
	self sethintstring("");
	return false;
}

/*
	Name: function_ef8e1546
	Namespace: zm_castle_craftables
	Checksum: 0x5DE309A8
	Offset: 0x1E48
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_ef8e1546()
{
	self endon(#"kill_trigger");
	self.stub thread zm_unitrigger::run_visibility_function_for_all_triggers();
	while(!level flag::get("gravityspike_part_guards_found"))
	{
		self waittill(#"trigger", e_who);
		self.stub notify(#"trigger", e_who);
		level notify(#"a10_switch_activated");
		level.var_ddbeeb3f = 1;
		level flag::wait_till_clear("rocket_firing");
	}
	zm_unitrigger::unregister_unitrigger(self);
}

/*
	Name: function_f387f091
	Namespace: zm_castle_craftables
	Checksum: 0x89DC090E
	Offset: 0x1F20
	Size: 0x26E
	Parameters: 0
	Flags: Linked
*/
function function_f387f091()
{
	level endon(#"a10_switch_activated");
	level endon(#"open_a10_doors");
	while(true)
	{
		n_round_zombies = zombie_utility::get_current_zombie_count();
		var_bf9f0aee = 0;
		a_zombies = getaiteamarray(level.zombie_team);
		foreach(e_zombie in a_zombies)
		{
			if(e_zombie.targetname == "a10_zombie")
			{
				var_bf9f0aee++;
			}
		}
		var_f61ca199 = n_round_zombies + var_bf9f0aee;
		if(var_f61ca199 < level.zombie_vars["zombie_max_ai"] && var_bf9f0aee <= 10)
		{
			s_spawn_pos = function_1b872af("zone_v10_pad");
			if(isdefined(s_spawn_pos))
			{
				ai_zombie = zombie_utility::spawn_zombie(level.zombie_spawners[0], "a10_zombie", s_spawn_pos);
				if(isdefined(ai_zombie))
				{
					ai_zombie.no_powerups = 1;
					ai_zombie.no_damage_points = 1;
					ai_zombie.deathpoints_already_given = 1;
					ai_zombie.ignore_enemy_count = 1;
					ai_zombie.exclude_cleanup_adding_to_total = 1;
					playfx(level._effect["lightning_dog_spawn"], ai_zombie.origin);
					ai_zombie thread function_f6e272db();
				}
			}
		}
		wait(3);
	}
}

/*
	Name: function_f6e272db
	Namespace: zm_castle_craftables
	Checksum: 0xA32EC07E
	Offset: 0x2198
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_f6e272db()
{
	wait(0.05);
	n_randy = randomint(100);
	if(n_randy <= 25)
	{
		return;
	}
	if(math::cointoss())
	{
		self thread zm_elemental_zombie::function_1b1bb1b();
	}
	else
	{
		self thread zm_elemental_zombie::function_f4defbc2();
	}
}

/*
	Name: function_1b872af
	Namespace: zm_castle_craftables
	Checksum: 0x505CF62F
	Offset: 0x2228
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function function_1b872af(str_zone)
{
	a_e_volumes = getentarray(str_zone, "targetname");
	a_s_pos = [];
	a_s_spots = struct::get_array(a_e_volumes[0].target, "targetname");
	for(i = 0; i < a_s_spots.size; i++)
	{
		if(a_s_spots[i].script_noteworthy === "spawn_location" || a_s_spots[i].script_noteworthy === "riser_location")
		{
			array::add(a_s_pos, a_s_spots[i], 0);
		}
	}
	if(a_s_pos.size > 0)
	{
		return array::random(a_s_pos);
	}
}

/*
	Name: function_9980920d
	Namespace: zm_castle_craftables
	Checksum: 0x2229DF92
	Offset: 0x2368
	Size: 0x120
	Parameters: 1
	Flags: Linked
*/
function function_9980920d(var_d97c08b2)
{
	self.piecestub = var_d97c08b2;
	self.radius = var_d97c08b2.radius;
	self.height = var_d97c08b2.height;
	self.craftablename = var_d97c08b2.craftablename;
	self.piecename = var_d97c08b2.piecename;
	self.modelname = var_d97c08b2.modelname;
	self.hud_icon = var_d97c08b2.hud_icon;
	self.tag_name = var_d97c08b2.tag_name;
	self.drop_offset = var_d97c08b2.drop_offset;
	self.client_field_state = var_d97c08b2.client_field_state;
	self.is_shared = var_d97c08b2.is_shared;
	self.inventory_slot = var_d97c08b2.inventory_slot;
}

/*
	Name: function_2742ffd4
	Namespace: zm_castle_craftables
	Checksum: 0xC1A43787
	Offset: 0x2490
	Size: 0x24C
	Parameters: 4
	Flags: Linked
*/
function function_2742ffd4(var_d97c08b2, b_teleported, v_position, var_dc35eb29)
{
	if(self.spawns.size < 1)
	{
		return;
	}
	if(!isdefined(self.current_spawn))
	{
		self.current_spawn = 0;
	}
	spawndef = self.spawns[self.current_spawn];
	if(!isdefined(v_position))
	{
		v_position = spawndef.origin;
	}
	self.unitrigger = zm_craftables::generate_piece_unitrigger("trigger_radius", v_position + vectorscale((0, 0, 1), 32), spawndef.angles, 0, self.radius, self.height, var_d97c08b2.hint_string, 0, spawndef.script_string);
	self.unitrigger.piece = self;
	self.start_origin = v_position;
	self.start_angles = spawndef.angles;
	self.model = spawn("script_model", self.start_origin + vectorscale((0, 0, 1), 32));
	if(isdefined(self.start_angles))
	{
		self.model.angles = self.start_angles;
	}
	self.model setmodel(self.modelname);
	if(isdefined(var_d97c08b2.onspawn))
	{
		self [[var_d97c08b2.onspawn]]();
	}
	self.model ghostindemo();
	self.model.hud_icon = self.hud_icon;
	self.unitrigger.origin_parent = self.model;
	self thread function_1f778391(b_teleported, var_dc35eb29);
}

/*
	Name: function_1f778391
	Namespace: zm_castle_craftables
	Checksum: 0x6558DE9C
	Offset: 0x26E8
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function function_1f778391(b_teleported, var_dc35eb29)
{
	self endon(#"hash_750017bb");
	self thread function_e5b369e4(b_teleported);
	self thread function_650a28f4(var_dc35eb29);
	self.unitrigger waittill(#"trigger", e_who);
	self notify(#"hash_92009fcb");
	if(isdefined(self))
	{
		zm_unitrigger::unregister_unitrigger(self.unitrigger);
		self.unitrigger = undefined;
	}
	if(isdefined(self.model))
	{
		playfx(level._effect["craftable_powerup_grabbed"], self.model.origin);
		self.model delete();
	}
}

/*
	Name: function_e5b369e4
	Namespace: zm_castle_craftables
	Checksum: 0x77BCCDB3
	Offset: 0x27F0
	Size: 0x1C8
	Parameters: 1
	Flags: Linked
*/
function function_e5b369e4(b_teleported)
{
	self endon(#"hash_92009fcb");
	self endon(#"hash_750017bb");
	self.model clientfield::set("craftable_powerup_fx", 1);
	if(isdefined(b_teleported) && b_teleported)
	{
		self.model clientfield::set("craftable_teleport_fx", 1);
	}
	while(isdefined(self.model))
	{
		waittime = randomfloatrange(2.5, 5);
		yaw = randomint(360);
		if(yaw > 300)
		{
			yaw = 300;
		}
		else if(yaw < 60)
		{
			yaw = 60;
		}
		yaw = self.model.angles[1] + yaw;
		new_angles = (-60 + randomint(120), yaw, -45 + randomint(90));
		self.model rotateto(new_angles, waittime, waittime * 0.5, waittime * 0.5);
		wait(randomfloat(waittime - 0.1));
	}
}

/*
	Name: function_650a28f4
	Namespace: zm_castle_craftables
	Checksum: 0xA8D9B681
	Offset: 0x29C0
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function function_650a28f4(var_dc35eb29)
{
	self endon(#"hash_92009fcb");
	self.model zm_powerups::powerup_show(1);
	if(!isdefined(var_dc35eb29))
	{
		wait(15);
	}
	else
	{
		wait(var_dc35eb29);
	}
	for(i = 0; i < 40; i++)
	{
		if(i % 2)
		{
			self.model zm_powerups::powerup_show(0);
		}
		else
		{
			self.model zm_powerups::powerup_show(1);
		}
		if(i < 15)
		{
			wait(0.5);
			continue;
		}
		if(i < 25)
		{
			wait(0.25);
			continue;
		}
		wait(0.1);
	}
	self notify(#"hash_750017bb");
	if(isdefined(self.unitrigger))
	{
		zm_unitrigger::unregister_unitrigger(self.unitrigger);
		self.unitrigger = undefined;
	}
	if(isdefined(self.model))
	{
		playfx(level._effect["craftable_powerup_grabbed"], self.model.origin);
		self.model delete();
	}
}

/*
	Name: ondrop_common
	Namespace: zm_castle_craftables
	Checksum: 0xA5754885
	Offset: 0x2B70
	Size: 0x16
	Parameters: 1
	Flags: None
*/
function ondrop_common(player)
{
	self.piece_owner = undefined;
}

/*
	Name: onpickup_common
	Namespace: zm_castle_craftables
	Checksum: 0xFDA2DA59
	Offset: 0x2B90
	Size: 0x38
	Parameters: 1
	Flags: None
*/
function onpickup_common(player)
{
	player thread function_9708cb71(self.piecename);
	self.piece_owner = player;
}

/*
	Name: play_vo_if_newly_found
	Namespace: zm_castle_craftables
	Checksum: 0x860B0A7C
	Offset: 0x2BD0
	Size: 0xCE
	Parameters: 0
	Flags: None
*/
function play_vo_if_newly_found()
{
	if(!level flag::get(((self.craftablename + "_") + self.piecename) + "_found"))
	{
		vo_alias_call = undefined;
		switch(self.piecename)
		{
			case "part_body":
			case "part_guards":
			case "part_handle":
			{
				break;
			}
			default:
			{
				break;
			}
		}
		level flag::set(((self.craftablename + "_") + self.piecename) + "_found");
	}
}

/*
	Name: function_9708cb71
	Namespace: zm_castle_craftables
	Checksum: 0xA9C7ED20
	Offset: 0x2CA8
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_9708cb71(piecename)
{
	var_983a0e9b = "zmb_zod_craftable_pickup";
	switch(piecename)
	{
		case "part_body":
		case "part_guards":
		case "part_handle":
		{
			var_983a0e9b = "zmb_zod_idgunpiece_pickup";
			break;
		}
		default:
		{
			var_983a0e9b = "zmb_zod_craftable_pickup";
			break;
		}
	}
	self playsound(var_983a0e9b);
}

/*
	Name: show_infotext_for_duration
	Namespace: zm_castle_craftables
	Checksum: 0x269D0D42
	Offset: 0x2D40
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function show_infotext_for_duration(str_infotext, n_duration)
{
	self clientfield::set_to_player(str_infotext, 1);
	wait(n_duration);
	self clientfield::set_to_player(str_infotext, 0);
}

/*
	Name: function_c1e52ea6
	Namespace: zm_castle_craftables
	Checksum: 0x6CCD0C9A
	Offset: 0x2DA0
	Size: 0x14A
	Parameters: 1
	Flags: Linked
*/
function function_c1e52ea6(player)
{
	level flag::set(((self.craftablename + "_") + self.piecename) + "_found");
	player thread function_9708cb71(self.piecename);
	player thread zm_castle_vo::function_43b44df3();
	level notify(#"widget_ui_override");
	foreach(e_player in level.players)
	{
		e_player thread function_c1727537("zmInventory.player_crafted_gravityspikes", "zmInventory.widget_gravityspike_parts", 0);
		e_player thread show_infotext_for_duration("ZMUI_GRAVITYSPIKE_PART_PICKUP", 3.5);
	}
}

/*
	Name: function_61ac1c22
	Namespace: zm_castle_craftables
	Checksum: 0xD4AE5B7
	Offset: 0x2EF8
	Size: 0x126
	Parameters: 1
	Flags: Linked
*/
function function_61ac1c22(player)
{
	level notify(#"widget_ui_override");
	foreach(e_player in level.players)
	{
		if(zm_utility::is_player_valid(e_player))
		{
			e_player thread function_c1727537("zmInventory.player_crafted_gravityspikes", "zmInventory.widget_gravityspike_parts", 1);
			e_player thread show_infotext_for_duration("ZMUI_GRAVITYSPIKE_CRAFTED", 3.5);
		}
	}
	self function_98c7dfa5(self.origin, self.angles);
	level notify(#"hash_71de5140");
	return true;
}

/*
	Name: function_c1727537
	Namespace: zm_castle_craftables
	Checksum: 0x5685AE0A
	Offset: 0x3028
	Size: 0xD4
	Parameters: 3
	Flags: Linked, Private
*/
function private function_c1727537(str_crafted_clientuimodel, str_widget_clientuimodel, b_is_crafted)
{
	self endon(#"disconnect");
	if(b_is_crafted)
	{
		if(isdefined(str_crafted_clientuimodel))
		{
			self thread clientfield::set_player_uimodel(str_crafted_clientuimodel, 1);
		}
		n_show_ui_duration = 3.5;
	}
	else
	{
		n_show_ui_duration = 3.5;
	}
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 1);
	level util::waittill_any_ex(n_show_ui_duration, "widget_ui_override", self, "disconnect");
	self thread clientfield::set_player_uimodel(str_widget_clientuimodel, 0);
}

/*
	Name: function_98c7dfa5
	Namespace: zm_castle_craftables
	Checksum: 0xA2F5334C
	Offset: 0x3108
	Size: 0x1D4
	Parameters: 2
	Flags: Linked
*/
function function_98c7dfa5(v_origin, v_angles)
{
	width = 128;
	height = 128;
	length = 128;
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = v_origin;
	unitrigger_stub.angles = v_angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.script_width = width;
	unitrigger_stub.script_height = height;
	unitrigger_stub.script_length = length;
	unitrigger_stub.require_look_at = 1;
	s_align = struct::get(self.target, "targetname");
	unitrigger_stub.var_c06b40f5 = util::spawn_model("wpn_zmb_dlc1_talon_spikes_world", s_align.origin + vectorscale((0, 0, 1), 25), s_align.angles + (vectorscale((0, -1, 0), 90)));
	unitrigger_stub.prompt_and_visibility_func = &function_4ae7dabf;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_f2c00181);
}

/*
	Name: function_4ae7dabf
	Namespace: zm_castle_craftables
	Checksum: 0x7002DC1C
	Offset: 0x32E8
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function function_4ae7dabf(player)
{
	wpn_gravityspikes = getweapon("hero_gravityspikes_melee");
	if(player.gravityspikes_state == 0)
	{
		self sethintstring(&"ZM_CASTLE_GRAVITYSPIKE_PICKUP");
		return true;
	}
	self sethintstring(&"ZM_CASTLE_GRAVITYSPIKE_ALREADY_HAVE");
	return false;
}

/*
	Name: function_f2c00181
	Namespace: zm_castle_craftables
	Checksum: 0x15F2706C
	Offset: 0x3380
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_f2c00181()
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
		level thread function_adbf2990(self.stub, player);
		break;
	}
}

/*
	Name: function_adbf2990
	Namespace: zm_castle_craftables
	Checksum: 0xB537C34
	Offset: 0x3430
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function function_adbf2990(trig_stub, player)
{
	if(player.gravityspikes_state == 0)
	{
		wpn_gravityspikes = getweapon("hero_gravityspikes_melee");
		player zm_weapons::weapon_give(wpn_gravityspikes, 0, 1);
		player thread zm_equipment::show_hint_text(&"ZM_CASTLE_GRAVITYSPIKE_USE_HINT", 3);
		player thread zm_castle_vo::function_4e11dfdc();
		player gadgetpowerset(player gadgetgetslot(wpn_gravityspikes), 100);
		player zm_weap_gravityspikes::update_gravityspikes_state(2);
		player playrumbleonentity("zm_castle_interact_rumble");
	}
}

/*
	Name: init_craftable_choke
	Namespace: zm_castle_craftables
	Checksum: 0xD036B04D
	Offset: 0x3550
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function init_craftable_choke()
{
	level.craftables_spawned_this_frame = 0;
	while(true)
	{
		util::wait_network_frame();
		level.craftables_spawned_this_frame = 0;
	}
}

/*
	Name: craftable_wait_your_turn
	Namespace: zm_castle_craftables
	Checksum: 0x28A8A558
	Offset: 0x3598
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function craftable_wait_your_turn()
{
	if(!isdefined(level.craftables_spawned_this_frame))
	{
		level thread init_craftable_choke();
	}
	while(level.craftables_spawned_this_frame >= 2)
	{
		util::wait_network_frame();
	}
	level.craftables_spawned_this_frame++;
}

/*
	Name: function_d8efa7d6
	Namespace: zm_castle_craftables
	Checksum: 0xD6136950
	Offset: 0x35F8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_d8efa7d6()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("gravityspike_zm_craftable_trigger", "gravityspike", "hero_gravityspikes_melee", "", 1, 0);
}

/*
	Name: in_game_map_quest_item_picked_up
	Namespace: zm_castle_craftables
	Checksum: 0x30E66338
	Offset: 0x3650
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function in_game_map_quest_item_picked_up(str_partname)
{
}

/*
	Name: in_game_map_quest_item_dropped
	Namespace: zm_castle_craftables
	Checksum: 0xE2D3965D
	Offset: 0x3668
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function in_game_map_quest_item_dropped(str_partname)
{
}

