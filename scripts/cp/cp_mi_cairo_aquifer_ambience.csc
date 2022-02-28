// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_load;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;

#namespace namespace_1254c007;

/*
	Name: __init__sytem__
	Namespace: namespace_1254c007
	Checksum: 0x192961E2
	Offset: 0x430
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("aquifer_ambience", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: namespace_1254c007
	Checksum: 0xAF1E6420
	Offset: 0x470
	Size: 0x1CC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "show_sand_storm", 1, 1, "int", &function_7ddc918d, 0, 0);
	clientfield::register("world", "hide_sand_storm", 1, 1, "int", &function_e5def758, 0, 0);
	clientfield::register("world", "play_trucks", 1, 1, "int", &function_91528afa, 0, 0);
	clientfield::register("world", "start_ambience", 1, 1, "int", &function_134f3566, 0, 0);
	clientfield::register("world", "stop_ambience", 1, 1, "int", &function_ad396d58, 0, 0);
	clientfield::register("world", "kill_ambience", 1, 1, "int", &function_9ba61e20, 0, 0);
	level thread function_89b52898();
}

/*
	Name: main
	Namespace: namespace_1254c007
	Checksum: 0xD226EEAF
	Offset: 0x648
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function main(localclientnum)
{
}

/*
	Name: function_134f3566
	Namespace: namespace_1254c007
	Checksum: 0x6D3A76B3
	Offset: 0x660
	Size: 0x172
	Parameters: 7
	Flags: Linked
*/
function function_134f3566(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.scriptbundles["scene"]["p7_fxanim_cp_aqu_war_dogfight_main_loop_a_bundle_client"]))
	{
		return;
	}
	thread function_ca056d7e();
	var_acfd8784 = struct::get_array("p7_fxanim_cp_aqu_war_dogfight_main_loop_a_bundle_client", "scriptbundlename");
	var_7056bf21 = struct::get("p7_fxanim_cp_aqu_war_dogfight_a_jet_vtol_bundle", "scriptbundlename");
	array::add(var_acfd8784, var_7056bf21);
	foreach(var_3668f67c in var_acfd8784)
	{
		var_3668f67c thread scene::play();
	}
}

/*
	Name: function_ad396d58
	Namespace: namespace_1254c007
	Checksum: 0x385F71EC
	Offset: 0x7E0
	Size: 0x2CC
	Parameters: 7
	Flags: Linked
*/
function function_ad396d58(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level notify(#"hash_9e245bdd");
	if(!isdefined(level.var_c2750169))
	{
		level.var_c2750169 = [];
	}
	foreach(jet in level.var_c2750169)
	{
		jet thread scene::stop(1);
		jet.scene_played = 0;
	}
	var_acfd8784 = struct::get_array("p7_fxanim_cp_aqu_war_dogfight_main_loop_a_bundle_client", "scriptbundlename");
	var_7056bf21 = struct::get("p7_fxanim_cp_aqu_war_dogfight_a_jet_vtol_bundle", "scriptbundlename");
	var_ffd496bd = struct::get("p7_fxanim_cp_aqu_war_patrol_a_vtol_nrc_bundle", "scriptbundlename");
	var_63f986ef = struct::get("p7_fxanim_cp_aqu_war_patrol_a_vtol_egypt_bundle", "scriptbundlename");
	array::add(var_acfd8784, var_7056bf21);
	array::add(var_acfd8784, var_ffd496bd);
	array::add(var_acfd8784, var_63f986ef);
	foreach(var_3668f67c in var_acfd8784)
	{
		var_3668f67c thread scene::stop(1);
		var_3668f67c.scene_played = 0;
	}
	array::run_all(level.var_c2750169, &scene::stop, 1);
}

/*
	Name: function_9ba61e20
	Namespace: namespace_1254c007
	Checksum: 0x91E51F21
	Offset: 0xAB8
	Size: 0x344
	Parameters: 7
	Flags: Linked
*/
function function_9ba61e20(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level notify(#"hash_9e245bdd");
	if(isdefined(level.var_c2750169))
	{
		foreach(jet in level.var_c2750169)
		{
			jet thread scene::stop(1);
			jet.scene_played = 0;
		}
	}
	var_acfd8784 = struct::get_array("p7_fxanim_cp_aqu_war_dogfight_main_loop_a_bundle_client", "scriptbundlename");
	var_7056bf21 = struct::get("p7_fxanim_cp_aqu_war_dogfight_a_jet_vtol_bundle", "scriptbundlename");
	var_ffd496bd = struct::get("p7_fxanim_cp_aqu_war_patrol_a_vtol_nrc_bundle", "scriptbundlename");
	var_63f986ef = struct::get("p7_fxanim_cp_aqu_war_patrol_a_vtol_egypt_bundle", "scriptbundlename");
	array::add(var_acfd8784, var_7056bf21);
	array::add(var_acfd8784, var_ffd496bd);
	array::add(var_acfd8784, var_63f986ef);
	foreach(var_3668f67c in var_acfd8784)
	{
		var_3668f67c thread scene::stop(1);
	}
	waittillframeend();
	struct::delete_script_bundle("scene", "p7_fxanim_cp_aqu_war_dogfight_main_loop_a_bundle_client");
	struct::delete_script_bundle("scene", "p7_fxanim_cp_aqu_war_dogfight_a_jet_vtol_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_cp_aqu_warpatrol_a_vtol_nrc_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_cp_aqu_warpatrol_a_vtol_egypt_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_cp_aqu_war_flyover_a_jet_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_cp_aqu_war_flyover_b_jet_bundle");
}

/*
	Name: function_ca056d7e
	Namespace: namespace_1254c007
	Checksum: 0x97E01C72
	Offset: 0xE08
	Size: 0x23E
	Parameters: 0
	Flags: Linked
*/
function function_ca056d7e()
{
	a_pos = struct::get_array("jet_flyover_pos", "targetname");
	if(a_pos.size == 0)
	{
		return;
	}
	var_ed7818f9 = [];
	array::add(var_ed7818f9, "p7_fxanim_cp_aqu_war_flyover_a_jet_bundle");
	array::add(var_ed7818f9, "p7_fxanim_cp_aqu_war_flyover_b_jet_bundle");
	if(isdefined(level.var_c2750169))
	{
		foreach(jet in level.var_c2750169)
		{
			if(jet scene::is_playing())
			{
				jet scene::stop();
			}
		}
	}
	level notify(#"hash_9e245bdd");
	if(!isdefined(level.var_c2750169))
	{
		level.var_c2750169 = [];
		for(i = 0; i < 12; i++)
		{
			level.var_c2750169[level.var_c2750169.size] = struct::spawn(a_pos[i].origin, a_pos[i].angles);
		}
	}
	for(i = 0; i < 12; i++)
	{
		level.var_c2750169[i] thread function_5794dab9(var_ed7818f9[i % 2], randomfloatrange(0, 20));
	}
}

/*
	Name: function_5794dab9
	Namespace: namespace_1254c007
	Checksum: 0x127D9830
	Offset: 0x1050
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function function_5794dab9(s_bundle, delay)
{
	level endon(#"hash_9e245bdd");
	level endon(#"inside_aquifer");
	level endon(#"hash_c2988129");
	wait(delay);
	self thread scene::play(s_bundle);
}

/*
	Name: function_e5def758
	Namespace: namespace_1254c007
	Checksum: 0x3110C74D
	Offset: 0x10B0
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_e5def758(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_76968f56 = getentarray(localclientnum, "sand_storm", "targetname");
	if(var_76968f56.size > 0)
	{
		array::run_all(var_76968f56, &visible, 0);
	}
}

/*
	Name: function_7ddc918d
	Namespace: namespace_1254c007
	Checksum: 0x4D1AD5DD
	Offset: 0x1160
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_7ddc918d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_76968f56 = getentarray(localclientnum, "sand_storm", "targetname");
	if(var_76968f56.size > 0)
	{
		array::run_all(var_76968f56, &visible, 1);
	}
}

/*
	Name: visible
	Namespace: namespace_1254c007
	Checksum: 0x802451D1
	Offset: 0x1210
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function visible(bool)
{
	if(bool)
	{
		self show();
	}
	else
	{
		self hide();
	}
}

/*
	Name: function_91528afa
	Namespace: namespace_1254c007
	Checksum: 0x8A4A502
	Offset: 0x1260
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function function_91528afa(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.scriptbundles["scene"]["p7_fxanim_cp_aqu_war_groundassault_bundle"]))
	{
		return;
	}
	pos = getent(localclientnum, "dogfighting_scene_client_side", "targetname");
	pos scene::play("p7_fxanim_cp_aqu_war_groundassault_bundle");
	pos scene::stop("p7_fxanim_cp_aqu_war_groundassault_bundle", 1);
	waittillframeend();
	struct::delete_script_bundle("scene", "p7_fxanim_cp_aqu_war_groundassault_bundle");
}

/*
	Name: function_89b52898
	Namespace: namespace_1254c007
	Checksum: 0x33E438B1
	Offset: 0x1358
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_89b52898()
{
	level waittill(#"hash_496d3ee1");
	audio::playloopat("amb_postwateroom_weird_lp", (12618, 1364, 2949));
}

