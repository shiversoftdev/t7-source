// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod_quest;

#namespace zm_zod_craftables;

/*
	Name: init_craftables
	Namespace: zm_zod_craftables
	Checksum: 0x982E5774
	Offset: 0x340
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function init_craftables()
{
	register_clientfields();
	zm_craftables::add_zombie_craftable("police_box");
	zm_craftables::add_zombie_craftable("idgun");
	zm_craftables::add_zombie_craftable("second_idgun");
	zm_craftables::add_zombie_craftable("ritual_boxer");
	zm_craftables::add_zombie_craftable("ritual_detective");
	zm_craftables::add_zombie_craftable("ritual_femme");
	zm_craftables::add_zombie_craftable("ritual_magician");
	zm_craftables::add_zombie_craftable("ritual_pap");
	level thread zm_craftables::set_clientfield_craftables_code_callbacks();
}

/*
	Name: include_craftables
	Namespace: zm_zod_craftables
	Checksum: 0x38FA2F07
	Offset: 0x438
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function include_craftables()
{
	zm_craftables::include_zombie_craftable("police_box");
	zm_craftables::include_zombie_craftable("idgun");
	zm_craftables::include_zombie_craftable("second_idgun");
	zm_craftables::include_zombie_craftable("ritual_boxer");
	zm_craftables::include_zombie_craftable("ritual_detective");
	zm_craftables::include_zombie_craftable("ritual_femme");
	zm_craftables::include_zombie_craftable("ritual_magician");
	zm_craftables::include_zombie_craftable("ritual_pap");
}

/*
	Name: register_clientfields
	Namespace: zm_zod_craftables
	Checksum: 0x92DEA793
	Offset: 0x508
	Size: 0x874
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	shared_bits = 1;
	registerclientfield("world", ("police_box" + "_") + "fuse_01", 1, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0);
	registerclientfield("world", ("police_box" + "_") + "fuse_02", 1, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0);
	registerclientfield("world", ("police_box" + "_") + "fuse_03", 1, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0);
	registerclientfield("world", ("idgun" + "_") + "part_heart", 1, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	registerclientfield("world", ("idgun" + "_") + "part_skeleton", 1, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	registerclientfield("world", ("idgun" + "_") + "part_xenomatter", 1, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	registerclientfield("world", ("second_idgun" + "_") + "part_heart", 1, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	registerclientfield("world", ("second_idgun" + "_") + "part_skeleton", 1, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	registerclientfield("world", ("second_idgun" + "_") + "part_xenomatter", 1, shared_bits, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	foreach(character_name in level.zod_character_names)
	{
		registerclientfield("world", "holder_of_" + character_name, 1, 3, "int", &zm_utility::setsharedinventoryuimodels, 0, 1);
	}
	registerclientfield("world", "quest_state_" + "boxer", 1, 3, "int", &zm_zod_quest::quest_state_boxer, 0, 1);
	registerclientfield("world", "quest_state_" + "detective", 1, 3, "int", &zm_zod_quest::quest_state_detective, 0, 1);
	registerclientfield("world", "quest_state_" + "femme", 1, 3, "int", &zm_zod_quest::quest_state_femme, 0, 1);
	registerclientfield("world", "quest_state_" + "magician", 1, 3, "int", &zm_zod_quest::quest_state_magician, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_FUSE_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_FUSE_PLACED", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_FUSE_CRAFTED", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_HEART_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_TENTACLE_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_XENOMATTER_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_IDGUN_CRAFTED", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_BOXER_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_DETECTIVE_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_FEMME_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_MEMENTO_MAGICIAN_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
	clientfield::register("toplayer", "ZM_ZOD_UI_GATEWORM_PICKUP", 1, 1, "int", &zm_utility::zm_ui_infotext, 0, 1);
}

