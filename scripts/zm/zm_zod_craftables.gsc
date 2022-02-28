// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
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
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_util;
#using scripts\zm\zm_zod_vo;

#namespace zm_zod_craftables;

/*
	Name: randomize_craftable_spawns
	Namespace: zm_zod_craftables
	Checksum: 0x99EC1590
	Offset: 0xB48
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function randomize_craftable_spawns()
{
}

/*
	Name: include_craftables
	Namespace: zm_zod_craftables
	Checksum: 0x1F7879F7
	Offset: 0xB58
	Size: 0x12EC
	Parameters: 0
	Flags: Linked
*/
function include_craftables()
{
	level.craftable_piece_swap_allowed = 0;
	shared_pieces = getnumexpectedplayers() == 1;
	var_16b36a95 = 1;
	craftable_name = "police_box";
	var_c157a58b = zm_craftables::generate_zombie_craftable_piece(craftable_name, "fuse_01", 32, 64, 0, undefined, &function_27ef9857, undefined, &function_6c41d7f2, undefined, undefined, undefined, ("police_box" + "_") + "fuse_01", 1, undefined, undefined, &"ZM_ZOD_POLICE_BOX_PICKUP_FUSE", 4);
	var_4f503650 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "fuse_02", 32, 64, 0, undefined, &function_27ef9857, undefined, &function_6c41d7f2, undefined, undefined, undefined, ("police_box" + "_") + "fuse_02", 1, undefined, undefined, &"ZM_ZOD_POLICE_BOX_PICKUP_FUSE", 4);
	var_7552b0b9 = zm_craftables::generate_zombie_craftable_piece(craftable_name, "fuse_03", 32, 64, 0, undefined, &function_27ef9857, undefined, &function_6c41d7f2, undefined, undefined, undefined, ("police_box" + "_") + "fuse_03", 1, undefined, undefined, &"ZM_ZOD_POLICE_BOX_PICKUP_FUSE", 4);
	if(shared_pieces)
	{
		var_c157a58b.is_shared = 1;
		var_4f503650.is_shared = 1;
		var_7552b0b9.is_shared = 1;
		var_c157a58b.client_field_state = undefined;
		var_4f503650.client_field_state = undefined;
		var_7552b0b9.client_field_state = undefined;
	}
	police_box = spawnstruct();
	police_box.name = craftable_name;
	police_box zm_craftables::add_craftable_piece(var_c157a58b, "j_fuse_01");
	police_box zm_craftables::add_craftable_piece(var_4f503650, "j_fuse_02");
	police_box zm_craftables::add_craftable_piece(var_7552b0b9, "j_fuse_03");
	police_box.triggerthink = &function_141a8c6e;
	police_box.no_challenge_stat = 1;
	level flag::init("fuse_01" + "_found");
	level flag::init("fuse_02" + "_found");
	level flag::init("fuse_03" + "_found");
	level flag::init("police_box_fuse_place");
	zm_craftables::include_zombie_craftable(police_box);
	craftable_name = "idgun";
	idgun_part_heart = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_heart", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, ("idgun" + "_") + "part_heart", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_HEART", 2);
	idgun_part_skeleton = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_skeleton", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, ("idgun" + "_") + "part_skeleton", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_SKELETON", 2);
	idgun_part_xenomatter = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_xenomatter", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, ("idgun" + "_") + "part_xenomatter", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_XENOMATTER", 2);
	idgun_part_heart.client_field_state = undefined;
	idgun_part_skeleton.client_field_state = undefined;
	idgun_part_xenomatter.client_field_state = undefined;
	idgun = spawnstruct();
	idgun.name = craftable_name;
	idgun zm_craftables::add_craftable_piece(idgun_part_heart);
	idgun zm_craftables::add_craftable_piece(idgun_part_skeleton);
	idgun zm_craftables::add_craftable_piece(idgun_part_xenomatter);
	idgun.onbuyweapon = &function_57f30dec;
	idgun.triggerthink = &idgun_craftable;
	zm_craftables::include_zombie_craftable(idgun);
	level flag::init("part_heart" + "_found");
	level flag::init("part_skeleton" + "_found");
	level flag::init("part_xenomatter" + "_found");
	craftable_name = "second_idgun";
	var_62ffc1ec = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_heart", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, ("second_idgun" + "_") + "part_heart", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_HEART", 3);
	var_50a8320d = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_skeleton", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, ("second_idgun" + "_") + "part_skeleton", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_SKELETON", 3);
	var_fa9ad3bb = zm_craftables::generate_zombie_craftable_piece(craftable_name, "part_xenomatter", 32, 64, 0, undefined, &onpickup_idgun_piece, undefined, undefined, undefined, undefined, undefined, ("second_idgun" + "_") + "part_xenomatter", 1, undefined, undefined, &"ZM_ZOD_IDGUN_PART_XENOMATTER", 3);
	var_62ffc1ec.client_field_state = undefined;
	var_50a8320d.client_field_state = undefined;
	var_fa9ad3bb.client_field_state = undefined;
	second_idgun = spawnstruct();
	second_idgun.name = craftable_name;
	second_idgun zm_craftables::add_craftable_piece(var_62ffc1ec);
	second_idgun zm_craftables::add_craftable_piece(var_50a8320d);
	second_idgun zm_craftables::add_craftable_piece(var_fa9ad3bb);
	second_idgun.triggerthink = &function_ee72d458;
	zm_craftables::include_zombie_craftable(second_idgun);
	level flag::init("part_heart" + "_found");
	level flag::init("part_skeleton" + "_found");
	level flag::init("part_xenomatter" + "_found");
	craftable_name = "ritual_boxer";
	ritual_boxer_memento = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_boxer", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 1, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_BOXER", 0);
	if(var_16b36a95)
	{
		ritual_boxer_memento.is_shared = 1;
		ritual_boxer_memento.client_field_state = undefined;
	}
	ritual_boxer = spawnstruct();
	ritual_boxer.name = craftable_name;
	ritual_boxer zm_craftables::add_craftable_piece(ritual_boxer_memento);
	ritual_boxer.triggerthink = &ritual_boxer_craftable;
	ritual_boxer.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(ritual_boxer);
	level flag::init("memento_boxer" + "_found");
	craftable_name = "ritual_detective";
	ritual_detective_memento = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_detective", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 2, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_DETECTIVE", 0);
	if(var_16b36a95)
	{
		ritual_detective_memento.is_shared = 1;
		ritual_detective_memento.client_field_state = undefined;
	}
	ritual_detective = spawnstruct();
	ritual_detective.name = craftable_name;
	ritual_detective zm_craftables::add_craftable_piece(ritual_detective_memento);
	ritual_detective.triggerthink = &ritual_detective_craftable;
	ritual_detective.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(ritual_detective);
	level flag::init("memento_detective" + "_found");
	craftable_name = "ritual_femme";
	ritual_femme_memento = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_femme", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 3, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_FEMME", 0);
	if(var_16b36a95)
	{
		ritual_femme_memento.is_shared = 1;
		ritual_femme_memento.client_field_state = undefined;
	}
	ritual_femme = spawnstruct();
	ritual_femme.name = craftable_name;
	ritual_femme zm_craftables::add_craftable_piece(ritual_femme_memento);
	ritual_femme.triggerthink = &ritual_femme_craftable;
	ritual_femme.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(ritual_femme);
	level flag::init("memento_femme" + "_found");
	craftable_name = "ritual_magician";
	ritual_magician_memento = zm_craftables::generate_zombie_craftable_piece(craftable_name, "memento_magician", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 4, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_ITEM_MAGICIAN", 0);
	if(var_16b36a95)
	{
		ritual_magician_memento.is_shared = 1;
		ritual_magician_memento.client_field_state = undefined;
	}
	ritual_magician = spawnstruct();
	ritual_magician.name = craftable_name;
	ritual_magician zm_craftables::add_craftable_piece(ritual_magician_memento);
	ritual_magician.triggerthink = &ritual_magician_craftable;
	ritual_magician.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(ritual_magician);
	level flag::init("memento_magician" + "_found");
	craftable_name = "ritual_pap";
	relic_boxer = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_boxer", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 1, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	relic_detective = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_detective", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 2, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	relic_femme = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_femme", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 3, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	relic_magician = zm_craftables::generate_zombie_craftable_piece(craftable_name, "relic_magician", 32, 64, 0, undefined, &onpickup_ritual_piece, undefined, &oncrafted_ritual_piece, undefined, undefined, undefined, 4, undefined, undefined, undefined, &"ZM_ZOD_QUEST_RITUAL_PICKUP_RELIC", 1);
	if(var_16b36a95)
	{
		relic_boxer.is_shared = 1;
		relic_detective.is_shared = 1;
		relic_femme.is_shared = 1;
		relic_magician.is_shared = 1;
		relic_boxer.client_field_state = undefined;
		relic_detective.client_field_state = undefined;
		relic_femme.client_field_state = undefined;
		relic_magician.client_field_state = undefined;
	}
	ritual_pap = spawnstruct();
	ritual_pap.name = craftable_name;
	ritual_pap zm_craftables::add_craftable_piece(relic_boxer);
	ritual_pap zm_craftables::add_craftable_piece(relic_detective);
	ritual_pap zm_craftables::add_craftable_piece(relic_femme);
	ritual_pap zm_craftables::add_craftable_piece(relic_magician);
	ritual_pap.triggerthink = &ritual_pap_craftable;
	ritual_pap.no_challenge_stat = 1;
	zm_craftables::include_zombie_craftable(ritual_pap);
	level flag::init("relic_boxer" + "_found");
	level flag::init("relic_detective" + "_found");
	level flag::init("relic_femme" + "_found");
	level flag::init("relic_magician" + "_found");
}

/*
	Name: init_craftables
	Namespace: zm_zod_craftables
	Checksum: 0x7E82C3F1
	Offset: 0x1E50
	Size: 0x32C
	Parameters: 0
	Flags: Linked
*/
function init_craftables()
{
	level.custom_craftable_validation = &zod_player_can_craft;
	register_clientfields();
	zm_craftables::add_zombie_craftable("police_box", &"ZM_ZOD_POLICE_BOX_PLACE_FUSE", &"ZM_ZOD_POLICE_BOX_PLACE_FUSE", &"ZM_ZOD_POLICE_BOX_POWER_ON", &function_c6c55eb6);
	zm_craftables::add_zombie_craftable("idgun", &"ZM_ZOD_CRAFT_IDGUN", "", &"ZM_ZOD_PICKUP_IDGUN", &onfullycrafted_idgun, 1);
	zm_craftables::make_zombie_craftable_open("idgun", "", vectorscale((0, -1, 0), 90), (0, 0, 0));
	zm_craftables::add_zombie_craftable("second_idgun", &"ZM_ZOD_CRAFT_IDGUN", "", &"ZM_ZOD_PICKUP_IDGUN", &function_d80876ac, 1);
	zm_craftables::make_zombie_craftable_open("second_idgun", "", vectorscale((0, -1, 0), 90), (0, 0, 0));
	zm_craftables::add_zombie_craftable("ritual_boxer", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_BOXER", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &onfullycrafted_ritual);
	zm_craftables::add_zombie_craftable("ritual_detective", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_DETECTIVE", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_DETECTIVE", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &onfullycrafted_ritual);
	zm_craftables::add_zombie_craftable("ritual_femme", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_FEMME", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_FEMME", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &onfullycrafted_ritual);
	zm_craftables::add_zombie_craftable("ritual_magician", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_MAGICIAN", &"ZM_ZOD_QUEST_RITUAL_PLACE_ITEM_MAGICIAN", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &onfullycrafted_ritual);
	zm_craftables::add_zombie_craftable("ritual_pap", &"ZM_ZOD_QUEST_RITUAL_PLACE_RELIC", &"ZM_ZOD_QUEST_RITUAL_PLACE_RELIC", &"ZM_ZOD_QUEST_RITUAL_INITIATE", &onfullycrafted_ritual);
	zm_craftables::set_build_time("police_box", 0);
	zm_craftables::set_build_time("ritual_boxer", 0);
	zm_craftables::set_build_time("ritual_detective", 0);
	zm_craftables::set_build_time("ritual_femme", 0);
	zm_craftables::set_build_time("ritual_magician", 0);
	zm_craftables::set_build_time("ritual_pap", 0);
}

/*
	Name: register_clientfields
	Namespace: zm_zod_craftables
	Checksum: 0x643FD861
	Offset: 0x2188
	Size: 0x624
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	shared_bits = 1;
	registerclientfield("world", ("police_box" + "_") + "fuse_01", 1, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("police_box" + "_") + "fuse_02", 1, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("police_box" + "_") + "fuse_03", 1, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("idgun" + "_") + "part_heart", 1, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("idgun" + "_") + "part_skeleton", 1, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("idgun" + "_") + "part_xenomatter", 1, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("second_idgun" + "_") + "part_heart", 1, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("second_idgun" + "_") + "part_skeleton", 1, shared_bits, "int", undefined, 0);
	registerclientfield("world", ("second_idgun" + "_") + "part_xenomatter", 1, shared_bits, "int", undefined, 0);
	foreach(character_name in level.zod_character_names)
	{
		registerclientfield("world", "holder_of_" + character_name, 1, 3, "int", undefined, 0);
	}
	foreach(character_name in level.zod_character_names)
	{
		registerclientfield("world", "quest_state_" + character_name, 1, 3, "int", undefined, 0);
	}
	clientfield::register("toplayer", "ZM_ZOD_UI_FUSE_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_FUSE_PLACED", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_FUSE_CRAFTED", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_HEART_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_TENTACLE_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_XENOMATTER_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_CRAFTED", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_BOXER_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_DETECTIVE_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_FEMME_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_MAGICIAN_PICKUP", 1, 1, "int");
	clientfield::register("toplayer", "ZM_ZOD_UI_GATEWORM_PICKUP", 1, 1, "int");
}

/*
	Name: craftable_add_glow_fx
	Namespace: zm_zod_craftables
	Checksum: 0xFBB6AF44
	Offset: 0x27B8
	Size: 0x120
	Parameters: 0
	Flags: None
*/
function craftable_add_glow_fx()
{
	level flag::wait_till("start_zombie_round_logic");
	foreach(s_craftable in level.zombie_include_craftables)
	{
		foreach(s_piece in s_craftable.a_piecestubs)
		{
			s_piece craftable_waittill_spawned();
		}
	}
}

/*
	Name: craftable_waittill_spawned
	Namespace: zm_zod_craftables
	Checksum: 0xD4F99449
	Offset: 0x28E0
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function craftable_waittill_spawned()
{
	while(!isdefined(self.piecespawn))
	{
		util::wait_network_frame();
	}
}

/*
	Name: ondrop_common
	Namespace: zm_zod_craftables
	Checksum: 0x9D8CD50C
	Offset: 0x2910
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
	Namespace: zm_zod_craftables
	Checksum: 0x7EB1CD68
	Offset: 0x2930
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
	Name: ondisconnect_common
	Namespace: zm_zod_craftables
	Checksum: 0x97777BD
	Offset: 0x2970
	Size: 0x254
	Parameters: 1
	Flags: Linked
*/
function ondisconnect_common(player)
{
	level endon("crafted_" + self.piecename);
	level endon("dropped_" + self.piecename);
	player waittill(#"disconnect");
	if(self.is_shared)
	{
		return;
	}
	var_c0262163 = level clientfield::get("quest_state_" + get_character_name_from_value(self.piecename));
	if(is_piece_a_memento(self.piecename) && var_c0262163 < 3)
	{
		level clientfield::set("quest_state_" + get_character_name_from_value(self.piecename), 0);
		self.model clientfield::set("set_fade_material", 1);
		self.model clientfield::set("item_glow_fx", 3);
		level clientfield::set("holder_of_" + get_character_name_from_value(self.piecename), 0);
	}
	else if(is_piece_a_relic(self.piecename) && !level flag::get("ritual_pap_complete"))
	{
		level clientfield::set("quest_state_" + get_character_name_from_value(self.piecename), 3);
		self.model setvisibletoall();
		self.model clientfield::set("item_glow_fx", 2);
		level clientfield::set("holder_of_" + get_character_name_from_value(self.piecename), 0);
	}
}

/*
	Name: function_27ef9857
	Namespace: zm_zod_craftables
	Checksum: 0xAC1B939B
	Offset: 0x2BD0
	Size: 0x112
	Parameters: 1
	Flags: Linked
*/
function function_27ef9857(player)
{
	level flag::set(self.piecename + "_found");
	player thread function_9708cb71(self.piecename);
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_fusebox", "zmInventory.widget_fuses", 0);
		e_player thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_FUSE_PICKUP", 3.5);
	}
}

/*
	Name: function_6c41d7f2
	Namespace: zm_zod_craftables
	Checksum: 0xF8CFC1C0
	Offset: 0x2CF0
	Size: 0x11A
	Parameters: 1
	Flags: Linked
*/
function function_6c41d7f2(player)
{
	var_6f73bd35 = getent("police_box", "targetname");
	if(isdefined(var_6f73bd35))
	{
		var_6f73bd35 playsound("zmb_zod_fuse_place");
	}
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_fusebox", "zmInventory.widget_fuses", 0);
		e_player thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_FUSE_PLACED", 3.5);
	}
}

/*
	Name: ondrop_ritual_piece
	Namespace: zm_zod_craftables
	Checksum: 0x50AE9A8A
	Offset: 0x2E18
	Size: 0x1FC
	Parameters: 1
	Flags: None
*/
function ondrop_ritual_piece(player)
{
	/#
		println("");
	#/
	level notify("dropped_" + self.piecename);
	self droponmover(player);
	self.piece_owner = undefined;
	if(is_piece_a_memento(self.piecename))
	{
		level.mementos_picked_up--;
		level clientfield::set("quest_state_" + get_character_name_from_value(self.piecename), 0);
		self.model clientfield::set("set_fade_material", 1);
		self.model clientfield::set("item_glow_fx", 3);
	}
	else if(is_piece_a_relic(self.piecename))
	{
		level.relics_picked_up--;
		level clientfield::set("quest_state_" + get_character_name_from_value(self.piecename), 3);
		self.model clientfield::set("item_glow_fx", 2);
	}
	self.model.origin = player.origin;
	self.model setvisibletoall();
	level clientfield::set("holder_of_" + get_character_name_from_value(self.piecename), 0);
}

/*
	Name: onpickup_ritual_piece
	Namespace: zm_zod_craftables
	Checksum: 0xF138CF8C
	Offset: 0x3020
	Size: 0x474
	Parameters: 1
	Flags: Linked
*/
function onpickup_ritual_piece(player)
{
	/#
		println("");
	#/
	if(!isdefined(level.mementos_picked_up))
	{
		level.mementos_picked_up = 0;
		level.relics_picked_up = 0;
		level.sndritualmementos = 1;
	}
	if(!(isdefined(self.var_34db6ce0) && self.var_34db6ce0))
	{
		self.var_34db6ce0 = 1;
		self.start_origin = self.model.origin;
		self.start_angles = self.model.angles;
	}
	self pickupfrommover();
	self.piece_owner = player;
	level flag::set(self.piecename + "_found");
	if(is_piece_a_memento(self.piecename))
	{
		level.mementos_picked_up++;
		level clientfield::set("quest_state_" + get_character_name_from_value(self.piecename), 1);
		player thread zm_zod_vo::function_32c9e1d9(self.piecename);
	}
	else if(is_piece_a_relic(self.piecename))
	{
		level.relics_picked_up++;
		level clientfield::set("quest_state_" + get_character_name_from_value(self.piecename), 4);
		str_name = get_character_name_from_value(self.piecename);
		level clientfield::set("ritual_state_" + str_name, 4);
		level thread exploder::stop_exploder(("ritual_light_" + str_name) + "_fin");
		player thread zm_zod_vo::function_2e3f1a98();
	}
	switch(self.piecename)
	{
		case "memento_boxer":
		{
			str_infotext = "ZM_ZOD_UI_MEMENTO_BOXER_PICKUP";
			break;
		}
		case "memento_detective":
		{
			str_infotext = "ZM_ZOD_UI_MEMENTO_DETECTIVE_PICKUP";
			break;
		}
		case "memento_femme":
		{
			str_infotext = "ZM_ZOD_UI_MEMENTO_FEMME_PICKUP";
			break;
		}
		case "memento_magician":
		{
			str_infotext = "ZM_ZOD_UI_MEMENTO_MAGICIAN_PICKUP";
			break;
		}
		case "relic_boxer":
		case "relic_detective":
		case "relic_femme":
		case "relic_magician":
		{
			str_infotext = "ZM_ZOD_UI_GATEWORM_PICKUP";
			break;
		}
	}
	var_e85b4e8 = 0;
	switch(player.characterindex)
	{
		case 0:
		{
			var_e85b4e8 = 1;
			break;
		}
		case 1:
		{
			var_e85b4e8 = 2;
			break;
		}
		case 2:
		{
			var_e85b4e8 = 3;
			break;
		}
		case 3:
		{
			var_e85b4e8 = 4;
			break;
		}
	}
	level clientfield::set("holder_of_" + get_character_name_from_value(self.piecename), var_e85b4e8);
	if(level.sndritualmementos == level.mementos_picked_up)
	{
		level thread zm_audio::sndmusicsystem_playstate("piece_" + level.sndritualmementos);
		level.sndritualmementos++;
	}
	player thread function_9708cb71(self.piecename);
	player thread zm_craftables::player_show_craftable_parts_ui(undefined, "zmInventory.widget_quest_items", 0);
	player thread zm_zod_util::show_infotext_for_duration(str_infotext, 3.5);
	self thread ondisconnect_common(player);
}

/*
	Name: onpickup_idgun_piece
	Namespace: zm_zod_craftables
	Checksum: 0xB8F441F2
	Offset: 0x34A0
	Size: 0x17A
	Parameters: 1
	Flags: Linked
*/
function onpickup_idgun_piece(player)
{
	level flag::set(self.piecename + "_found");
	level notify(#"idgun_part_found");
	player thread function_9708cb71(self.piecename);
	switch(self.piecename)
	{
		case "part_heart":
		{
			str_part = "ZM_ZOD_UI_IDGUN_HEART_PICKUP";
			break;
		}
		case "part_skeleton":
		{
			str_part = "ZM_ZOD_UI_IDGUN_TENTACLE_PICKUP";
			break;
		}
		case "part_xenomatter":
		{
			str_part = "ZM_ZOD_UI_IDGUN_XENOMATTER_PICKUP";
			break;
		}
	}
	foreach(e_player in level.players)
	{
		e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_idgun", "zmInventory.widget_idgun_parts", 0);
		e_player thread zm_zod_util::show_infotext_for_duration(str_part, 3.5);
	}
}

/*
	Name: function_9708cb71
	Namespace: zm_zod_craftables
	Checksum: 0x80DE0767
	Offset: 0x3628
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_9708cb71(piecename)
{
	var_983a0e9b = "zmb_zod_craftable_pickup";
	switch(piecename)
	{
		case "memento_boxer":
		case "memento_detective":
		case "memento_femme":
		case "memento_magician":
		{
			var_983a0e9b = "zmb_zod_memento_pickup";
			break;
		}
		case "relic_boxer":
		case "relic_detective":
		case "relic_femme":
		case "relic_magician":
		{
			var_983a0e9b = "zmb_zod_ritual_worm_pickup";
			break;
		}
		case "part_heart":
		case "part_heart":
		case "part_skeleton":
		case "part_skeleton":
		case "part_xenomatter":
		case "part_xenomatter":
		{
			var_983a0e9b = "zmb_zod_idgunpiece_pickup";
			break;
		}
		case "fuse_01":
		case "fuse_02":
		case "fuse_03":
		{
			var_983a0e9b = "zmb_zod_fuse_pickup";
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
	Name: function_c6c55eb6
	Namespace: zm_zod_craftables
	Checksum: 0xC8D7D462
	Offset: 0x3760
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function function_c6c55eb6(e_player)
{
	level notify(#"hash_5b9acfd8");
	foreach(e_player in level.players)
	{
		if(zm_utility::is_player_valid(e_player))
		{
			e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_fusebox", "zmInventory.widget_fuses", 1);
			e_player thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_FUSE_CRAFTED", 3.5);
		}
	}
	return true;
}

/*
	Name: oncrafted_ritual_piece
	Namespace: zm_zod_craftables
	Checksum: 0x7FC7A923
	Offset: 0x3858
	Size: 0x13C
	Parameters: 1
	Flags: Linked
*/
function oncrafted_ritual_piece(player)
{
	if(is_piece_a_memento(self.piecename))
	{
		level clientfield::set("quest_state_" + get_character_name_from_value(self.piecename), 2);
		player zm_zod_vo::function_c41d3e2e(self.piecename);
	}
	else
	{
		level clientfield::set("quest_state_" + get_character_name_from_value(self.piecename), 5);
		quest_ritual_relic_placed = getent("quest_ritual_relic_placed_" + get_character_name_from_value(self.piecename), "targetname");
		quest_ritual_relic_placed show();
	}
	level clientfield::set("holder_of_" + get_character_name_from_value(self.piecename), 0);
}

/*
	Name: onfullycrafted_ritual
	Namespace: zm_zod_craftables
	Checksum: 0x8B0F08D9
	Offset: 0x39A0
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function onfullycrafted_ritual(player)
{
	if(self.equipname != "ritual_pap")
	{
		str_character_name = get_character_name_from_value(self.equipname);
		onfullycrafted_ritual_internal(str_character_name);
		[[ level.a_o_defend_areas[str_character_name] ]]->start();
	}
	else
	{
		level flag::set("ritual_pap_ready");
		level clientfield::set("ritual_state_pap", 1);
		[[ level.a_o_defend_areas["pap"] ]]->start();
	}
	return true;
}

/*
	Name: onfullycrafted_ritual_internal
	Namespace: zm_zod_craftables
	Checksum: 0xE92FB643
	Offset: 0x3A88
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function onfullycrafted_ritual_internal(name)
{
	level flag::set(("ritual_" + name) + "_ready");
	level clientfield::set("ritual_state_" + name, 1);
	level clientfield::set("quest_state_" + name, 2);
}

/*
	Name: onfullycrafted_idgun
	Namespace: zm_zod_craftables
	Checksum: 0xBF0435A4
	Offset: 0x3B18
	Size: 0x1D8
	Parameters: 1
	Flags: Linked
*/
function onfullycrafted_idgun(player)
{
	if(!(isdefined(self.var_5449dda7) && self.var_5449dda7))
	{
		self.var_5449dda7 = 1;
		players = level.players;
		foreach(e_player in players)
		{
			if(zm_utility::is_player_valid(e_player))
			{
				e_player thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_IDGUN_CRAFTED", 3.5);
				e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_idgun", "zmInventory.widget_idgun_parts", 1);
			}
		}
		self.model.origin = self.origin;
		self.model.angles = self.angles + (vectorscale((0, -1, 0), 90));
		self.model setmodel("wpn_t7_zmb_zod_idg_world");
		self.n_gun_index = level.idgun[0].n_gun_index;
		self.weaponname = getweapon(level.idgun[self.n_gun_index].str_wpnname);
	}
	return true;
}

/*
	Name: function_57f30dec
	Namespace: zm_zod_craftables
	Checksum: 0xE7BD476A
	Offset: 0x3CF8
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_57f30dec(player)
{
	level.idgun[self.stub.n_gun_index].owner = player;
	level clientfield::set("add_idgun_to_box", level.idgun[self.stub.n_gun_index].var_e787e99a);
	level.zombie_weapons[self.stub.weaponname].is_in_box = 1;
	player zm_zod_vo::function_aca1bc0c(self.stub.n_gun_index);
}

/*
	Name: function_d80876ac
	Namespace: zm_zod_craftables
	Checksum: 0xA2E588AF
	Offset: 0x3DC8
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function function_d80876ac(player)
{
	players = level.players;
	foreach(e_player in players)
	{
		if(zm_utility::is_player_valid(e_player))
		{
			e_player thread zm_zod_util::show_infotext_for_duration("ZM_ZOD_UI_IDGUN_CRAFTED", 3.5);
			e_player thread zm_craftables::player_show_craftable_parts_ui("zmInventory.player_crafted_idgun", "zmInventory.widget_idgun_parts", 1);
		}
	}
	function_a0e4fb00(self.origin, self.origin, level.idgun[1].n_gun_index);
	return true;
}

/*
	Name: function_a0e4fb00
	Namespace: zm_zod_craftables
	Checksum: 0xBD189B4D
	Offset: 0x3F00
	Size: 0x1AC
	Parameters: 3
	Flags: Linked
*/
function function_a0e4fb00(v_origin, v_angles, n_gun_index)
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
	unitrigger_stub.require_look_at = 0;
	unitrigger_stub.n_gun_index = n_gun_index;
	unitrigger_stub.var_193180cc = spawn("script_model", v_origin);
	unitrigger_stub.var_193180cc setmodel("wpn_t7_zmb_zod_idg_world");
	unitrigger_stub.prompt_and_visibility_func = &function_e983d2a0;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &function_bae02fd4);
}

/*
	Name: function_e983d2a0
	Namespace: zm_zod_craftables
	Checksum: 0x8ADA4811
	Offset: 0x40B8
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function function_e983d2a0(player)
{
	n_gun_index = self.stub.n_gun_index;
	self sethintstring(&"ZM_ZOD_PICKUP_IDGUN");
	b_is_invis = isdefined(player.beastmode) && player.beastmode;
	self setinvisibletoplayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_bae02fd4
	Namespace: zm_zod_craftables
	Checksum: 0xBEF0210B
	Offset: 0x4160
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_bae02fd4()
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
		level thread function_3071ed77(self.stub, player);
		break;
	}
}

/*
	Name: function_3071ed77
	Namespace: zm_zod_craftables
	Checksum: 0x575A1ADB
	Offset: 0x4210
	Size: 0x104
	Parameters: 2
	Flags: Linked
*/
function function_3071ed77(trig_stub, player)
{
	level.idgun[trig_stub.n_gun_index].owner = player;
	trig_stub.var_193180cc setinvisibletoall();
	wpn_idgun = getweapon(level.idgun[trig_stub.n_gun_index].str_wpnname);
	player zm_weapons::weapon_give(wpn_idgun, 0, 0);
	player switchtoweapon(wpn_idgun);
	player zm_zod_vo::function_aca1bc0c(trig_stub.n_gun_index);
	zm_unitrigger::unregister_unitrigger(trig_stub);
}

/*
	Name: init_craftable_choke
	Namespace: zm_zod_craftables
	Checksum: 0x4752E9F9
	Offset: 0x4320
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
	Namespace: zm_zod_craftables
	Checksum: 0x4322F490
	Offset: 0x4368
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
	Name: zod_player_can_craft
	Namespace: zm_zod_craftables
	Checksum: 0x6A596135
	Offset: 0x43C8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function zod_player_can_craft(player)
{
	if(isdefined(player.beastmode) && player.beastmode)
	{
		return false;
	}
	return true;
}

/*
	Name: function_141a8c6e
	Namespace: zm_zod_craftables
	Checksum: 0xED6D56EC
	Offset: 0x4410
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_141a8c6e()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("police_box_usetrigger", "police_box", "police_box", "", 1, 0);
}

/*
	Name: ritual_boxer_craftable
	Namespace: zm_zod_craftables
	Checksum: 0xD6929ED7
	Offset: 0x4468
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function ritual_boxer_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_boxer", "ritual_boxer", "ritual_boxer", "", 1, 0);
}

/*
	Name: ritual_detective_craftable
	Namespace: zm_zod_craftables
	Checksum: 0x23A1DFEB
	Offset: 0x44C0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function ritual_detective_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_detective", "ritual_detective", "ritual_detective", "", 1, 0);
}

/*
	Name: ritual_femme_craftable
	Namespace: zm_zod_craftables
	Checksum: 0xFECAD039
	Offset: 0x4518
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function ritual_femme_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_femme", "ritual_femme", "ritual_femme", "", 1, 0);
}

/*
	Name: ritual_magician_craftable
	Namespace: zm_zod_craftables
	Checksum: 0x8B32E041
	Offset: 0x4570
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function ritual_magician_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_magician", "ritual_magician", "ritual_magician", "", 1, 0);
}

/*
	Name: ritual_pap_craftable
	Namespace: zm_zod_craftables
	Checksum: 0x2EBED938
	Offset: 0x45C8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function ritual_pap_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("quest_ritual_usetrigger_pap", "ritual_pap", "ritual_pap", "", 1, 0);
}

/*
	Name: idgun_craftable
	Namespace: zm_zod_craftables
	Checksum: 0xDCEB045
	Offset: 0x4620
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function idgun_craftable()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("idgun_zm_craftable_trigger", "idgun", "idgun", &"ZM_ZOD_PICKUP_IDGUN", 1, 2);
}

/*
	Name: function_ee72d458
	Namespace: zm_zod_craftables
	Checksum: 0x38ABF079
	Offset: 0x4678
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_ee72d458()
{
	craftable_wait_your_turn();
	zm_craftables::craftable_trigger_think("second_idgun_zm_craftable_trigger", "second_idgun", "second_idgun", "", 1, 0);
}

/*
	Name: get_character_name_from_value
	Namespace: zm_zod_craftables
	Checksum: 0x397D315D
	Offset: 0x46D0
	Size: 0xDA
	Parameters: 1
	Flags: Linked
*/
function get_character_name_from_value(name)
{
	a_character_names = array("boxer", "detective", "femme", "magician");
	foreach(character_name in a_character_names)
	{
		if(issubstr(name, character_name))
		{
			return character_name;
		}
	}
}

/*
	Name: is_piece_a_memento
	Namespace: zm_zod_craftables
	Checksum: 0xB7194709
	Offset: 0x47B8
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function is_piece_a_memento(name)
{
	a_memento_names = array("memento_boxer", "memento_detective", "memento_femme", "memento_magician");
	if(isinarray(a_memento_names, name))
	{
		return true;
	}
	return false;
}

/*
	Name: is_piece_a_relic
	Namespace: zm_zod_craftables
	Checksum: 0x2199FBA1
	Offset: 0x4830
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function is_piece_a_relic(name)
{
	if(name == "relic_boxer" || name == "relic_detective" || name == "relic_femme" || name == "relic_magician")
	{
		return true;
	}
	return false;
}

/*
	Name: droponmover
	Namespace: zm_zod_craftables
	Checksum: 0xEC3C1F8D
	Offset: 0x4898
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function droponmover(player)
{
}

/*
	Name: pickupfrommover
	Namespace: zm_zod_craftables
	Checksum: 0x99EC1590
	Offset: 0x48B0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function pickupfrommover()
{
}

