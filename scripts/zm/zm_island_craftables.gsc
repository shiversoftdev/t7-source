// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_island;
#using scripts\zm\zm_island_main_ee_quest;
#using scripts\zm\zm_island_pap_quest;

#namespace zm_island_craftables;

/*
	Name: include_craftables
	Namespace: zm_island_craftables
	Checksum: 0x8C92131D
	Offset: 0x538
	Size: 0x35C
	Parameters: 0
	Flags: Linked
*/
function include_craftables()
{
	level.craftable_piece_swap_allowed = 0;
	shared_pieces = getnumexpectedplayers() == 1;
	craftable_name = "gasmask";
	var_a2709918 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_visor", 32, 64, 0, undefined, &function_aef4c63, undefined, &function_3e3b2e02, undefined, undefined, undefined, ("gasmask" + "_") + "part_visor", 1, undefined, undefined, &"ZOMBIE_BUILD_PIECE_GRAB", 0);
	var_f113dd3d = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_filter", 32, 64, 0, undefined, &function_aef4c63, undefined, &function_3e3b2e02, undefined, undefined, undefined, ("gasmask" + "_") + "part_filter", 1, undefined, undefined, &"ZOMBIE_BUILD_PIECE_GRAB", 0);
	var_c4ee7b63 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_strap", 32, 64, 0, undefined, &function_aef4c63, undefined, &function_3e3b2e02, undefined, undefined, undefined, ("gasmask" + "_") + "part_strap", 1, undefined, undefined, &"ZOMBIE_BUILD_PIECE_GRAB", 0);
	var_a2709918.client_field_state = undefined;
	var_f113dd3d.client_field_state = undefined;
	var_c4ee7b63.client_field_state = undefined;
	gasmask = spawnstruct();
	gasmask.name = craftable_name;
	gasmask zm_craftables::add_craftable_piece(var_a2709918);
	gasmask zm_craftables::add_craftable_piece(var_f113dd3d);
	gasmask zm_craftables::add_craftable_piece(var_c4ee7b63);
	gasmask.triggerthink = &function_d2d29a1b;
	gasmask.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(gasmask);
	level flag::init(((craftable_name + "_") + "part_visor") + "_found");
	level flag::init(((craftable_name + "_") + "part_filter") + "_found");
	level flag::init(((craftable_name + "_") + "part_strap") + "_found");
}

/*
	Name: init_craftables
	Namespace: zm_island_craftables
	Checksum: 0x93CA2058
	Offset: 0x8A0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function init_craftables()
{
	register_clientfields();
	zm_craftables::add_zombie_craftable("gasmask", &"ZM_ISLAND_CRAFT_GASMASK", "", &"ZM_ISLAND_TOOK_GASMASK", &function_4e02c665, 1);
	zm_craftables::make_zombie_craftable_open("gasmask", "", vectorscale((0, -1, 0), 90), (0, 0, 0));
}

/*
	Name: register_clientfields
	Namespace: zm_island_craftables
	Checksum: 0x8CE9A776
	Offset: 0x938
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	shared_bits = 1;
	registerclientfield("world", ("gasmask" + "_") + "part_visor", 9000, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("gasmask" + "_") + "part_filter", 9000, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("gasmask" + "_") + "part_strap", 9000, shared_bits, "int", undefined, 0);
	clientfield::register("toplayer", "ZMUI_GRAVITYSPIKE_PART_PICKUP", 9000, 1, "int");
	clientfield::register("toplayer", "ZMUI_GRAVITYSPIKE_CRAFTED", 9000, 1, "int");
}

/*
	Name: ondrop_common
	Namespace: zm_island_craftables
	Checksum: 0x79ED71D7
	Offset: 0xA90
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
	Namespace: zm_island_craftables
	Checksum: 0x7B96132A
	Offset: 0xAB0
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
	Name: function_9708cb71
	Namespace: zm_island_craftables
	Checksum: 0x25384B93
	Offset: 0xAF0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_9708cb71(piecename)
{
	var_983a0e9b = "zmb_craftable_pickup";
	switch(piecename)
	{
		default:
		{
			var_983a0e9b = "zmb_craftable_pickup";
			break;
		}
	}
	self playsound(var_983a0e9b);
}

/*
	Name: show_infotext_for_duration
	Namespace: zm_island_craftables
	Checksum: 0x184FA016
	Offset: 0xB60
	Size: 0x54
	Parameters: 2
	Flags: None
*/
function show_infotext_for_duration(str_infotext, n_duration)
{
	self clientfield::set_to_player(str_infotext, 1);
	wait(n_duration);
	self clientfield::set_to_player(str_infotext, 0);
}

/*
	Name: function_aef4c63
	Namespace: zm_island_craftables
	Checksum: 0x2E18B0BB
	Offset: 0xBC0
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_aef4c63(player)
{
	str_piece = (self.craftablename + "_") + self.piecename;
	level flag::set(str_piece + "_found");
	player thread function_9708cb71(self.piecename);
	player notify(#"player_got_gasmask_part");
	level thread function_f34bd805(str_piece);
}

/*
	Name: function_f34bd805
	Namespace: zm_island_craftables
	Checksum: 0x6A4DB877
	Offset: 0xC68
	Size: 0x2B6
	Parameters: 1
	Flags: Linked
*/
function function_f34bd805(str_piece)
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
	switch(str_piece)
	{
		case "gasmask_part_visor":
		{
			foreach(player in a_players)
			{
				player thread clientfield::set_to_player("gaskmask_part_visor", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.gaskmask_part_visor", "zmInventory.widget_gasmask_parts", 0);
			}
			break;
		}
		case "gasmask_part_strap":
		{
			foreach(player in a_players)
			{
				player thread clientfield::set_to_player("gaskmask_part_strap", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.gaskmask_part_strap", "zmInventory.widget_gasmask_parts", 0);
			}
			break;
		}
		case "gasmask_part_filter":
		{
			foreach(player in a_players)
			{
				player thread clientfield::set_to_player("gaskmask_part_filter", 1);
				player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.gaskmask_part_filter", "zmInventory.widget_gasmask_parts", 0);
			}
			break;
		}
	}
}

/*
	Name: function_3e3b2e02
	Namespace: zm_island_craftables
	Checksum: 0xC944DA77
	Offset: 0xF28
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function function_3e3b2e02(player)
{
	iprintlnbold(((self.craftablename + "_") + self.piecename) + "_crafted");
}

/*
	Name: function_4e02c665
	Namespace: zm_island_craftables
	Checksum: 0xA4D1C662
	Offset: 0xF78
	Size: 0x106
	Parameters: 1
	Flags: Linked
*/
function function_4e02c665(player)
{
	function_aa4f440c(self.origin, self.angles);
	var_6796a7a4 = getent("mask_display", "targetname");
	var_6796a7a4 setscale(1.5);
	var_6796a7a4 moveto((self.origin + anglestoforward(self.angles)) + (-5, 0, -105), 0.05);
	var_6796a7a4 rotateto(self.angles + vectorscale((0, 1, 0), 90), 0.05);
	var_6796a7a4 waittill(#"movedone");
	return true;
}

/*
	Name: function_aa4f440c
	Namespace: zm_island_craftables
	Checksum: 0xA0452C9B
	Offset: 0x1088
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function function_aa4f440c(v_origin, v_angles)
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
	unitrigger_stub.prompt_and_visibility_func = &function_dbc8e9c0;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_272fcc74);
}

/*
	Name: function_dbc8e9c0
	Namespace: zm_island_craftables
	Checksum: 0x48AFEB90
	Offset: 0x11D8
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function function_dbc8e9c0(player)
{
	if(!player.var_df4182b1)
	{
		self sethintstring(&"ZM_ISLAND_GASMASK_PICKUP");
	}
	else
	{
		self sethintstring(&"ZOMBIE_BUILD_PIECE_HAVE_ONE");
	}
	return true;
}

/*
	Name: function_272fcc74
	Namespace: zm_island_craftables
	Checksum: 0x5D1C85BE
	Offset: 0x1240
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_272fcc74()
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
		if(!player.var_df4182b1)
		{
			level thread function_b4c30297(self.stub, player);
		}
		break;
	}
}

/*
	Name: function_b4c30297
	Namespace: zm_island_craftables
	Checksum: 0x3924419A
	Offset: 0x1300
	Size: 0x38
	Parameters: 2
	Flags: Linked
*/
function function_b4c30297(trig_stub, player)
{
	player.var_df4182b1 = 1;
	player notify(#"player_has_gasmask");
}

/*
	Name: init_craftable_choke
	Namespace: zm_island_craftables
	Checksum: 0xEC9EDBC6
	Offset: 0x1340
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
	Namespace: zm_island_craftables
	Checksum: 0xCFE38987
	Offset: 0x1388
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
	Name: function_d2d29a1b
	Namespace: zm_island_craftables
	Checksum: 0xC5314377
	Offset: 0x13E8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_d2d29a1b()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("gasmask_zm_craftable_trigger", "gasmask", "gasmask", "", 1, 0);
}

/*
	Name: in_game_map_quest_item_picked_up
	Namespace: zm_island_craftables
	Checksum: 0x26509514
	Offset: 0x1440
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function in_game_map_quest_item_picked_up(str_partname)
{
}

/*
	Name: in_game_map_quest_item_dropped
	Namespace: zm_island_craftables
	Checksum: 0x7EA55EC1
	Offset: 0x1458
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function in_game_map_quest_item_dropped(str_partname)
{
}

