// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_load;
#using scripts\cp\_safehouse;
#using scripts\cp\_util;
#using scripts\cp\cp_sh_singapore_fx;
#using scripts\cp\cp_sh_singapore_sound;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace cp_sh_singapore;

/*
	Name: main
	Namespace: cp_sh_singapore
	Checksum: 0x440B5D99
	Offset: 0x350
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function main()
{
	namespace_e4ce27de::main();
	namespace_d3b26b91::main();
	load::main();
	level thread set_ambient_state();
	level thread setup_vignettes();
}

/*
	Name: set_ambient_state
	Namespace: cp_sh_singapore
	Checksum: 0x43E00092
	Offset: 0x3C0
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function set_ambient_state()
{
	level flag::wait_till("all_players_connected");
	switch(level.next_map)
	{
		case "cp_mi_sing_blackstation":
		{
			level util::set_lighting_state(0);
			break;
		}
		case "cp_mi_sing_biodomes":
		case "cp_mi_sing_biodomes2":
		{
			level util::set_lighting_state(1);
			break;
		}
		case "cp_mi_sing_sgen":
		{
			level util::set_lighting_state(0);
			break;
		}
		case "cp_mi_sing_vengeance":
		{
			level util::set_lighting_state(2);
			break;
		}
	}
}

/*
	Name: setup_vignettes
	Namespace: cp_sh_singapore
	Checksum: 0xF5129561
	Offset: 0x4A0
	Size: 0x346
	Parameters: 0
	Flags: Linked
*/
function setup_vignettes()
{
	function_82dd4dd2("cin_ram_02_03_station_vign_readingipad_guy01");
	a_str_scenes = [];
	if(!isdefined(a_str_scenes))
	{
		a_str_scenes = [];
	}
	else if(!isarray(a_str_scenes))
	{
		a_str_scenes = array(a_str_scenes);
	}
	a_str_scenes[a_str_scenes.size] = "cin_ram_02_03_station_vign_bloodmopping_clean";
	if(!isdefined(a_str_scenes))
	{
		a_str_scenes = [];
	}
	else if(!isarray(a_str_scenes))
	{
		a_str_scenes = array(a_str_scenes);
	}
	a_str_scenes[a_str_scenes.size] = "cin_ram_02_03_station_vign_balcony_surveying_guy01";
	if(!isdefined(a_str_scenes))
	{
		a_str_scenes = [];
	}
	else if(!isarray(a_str_scenes))
	{
		a_str_scenes = array(a_str_scenes);
	}
	a_str_scenes[a_str_scenes.size] = "cin_ram_02_03_station_vign_balcony_surveying_guy02";
	if(!isdefined(a_str_scenes))
	{
		a_str_scenes = [];
	}
	else if(!isarray(a_str_scenes))
	{
		a_str_scenes = array(a_str_scenes);
	}
	a_str_scenes[a_str_scenes.size] = "cin_ram_02_03_station_vign_scaffold_inspecting";
	if(!isdefined(a_str_scenes))
	{
		a_str_scenes = [];
	}
	else if(!isarray(a_str_scenes))
	{
		a_str_scenes = array(a_str_scenes);
	}
	a_str_scenes[a_str_scenes.size] = "cin_ram_02_03_station_vign_readingipad_guy01";
	if(!isdefined(a_str_scenes))
	{
		a_str_scenes = [];
	}
	else if(!isarray(a_str_scenes))
	{
		a_str_scenes = array(a_str_scenes);
	}
	a_str_scenes[a_str_scenes.size] = "cin_saf_bla_armory_vign_repair_3dprinter";
	e_spawner = getent("worker_spawner", "targetname");
	a_str_scenes = array::randomize(a_str_scenes);
	n_vign_total = randomintrange(3, 4);
	/#
	#/
	for(n_vign_index = 0; n_vign_index < n_vign_total; n_vign_index++)
	{
		str_scene = a_str_scenes[n_vign_index];
		level thread scene::play(str_scene, e_spawner);
	}
}

/*
	Name: function_82dd4dd2
	Namespace: cp_sh_singapore
	Checksum: 0xE894CE9D
	Offset: 0x7F0
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function function_82dd4dd2(str_scene)
{
	foreach(s_scenedef in struct::get_script_bundles("scene"))
	{
		if(s_scenedef.name === str_scene)
		{
			s_scenedef.aligntarget = undefined;
		}
	}
}

