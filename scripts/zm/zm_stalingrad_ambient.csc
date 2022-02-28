// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_stalingrad_ambient;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_ambient
	Checksum: 0x321BCE00
	Offset: 0x360
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_ambient", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_ambient
	Checksum: 0x2C9D783D
	Offset: 0x3A0
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "ambient_mortar_strike", 12000, 2, "int", &ambient_mortar_strike, 0, 0);
	clientfield::register("scriptmover", "ambient_artillery_strike", 12000, 2, "int", &ambient_artillery_strike, 0, 0);
	clientfield::register("world", "power_on_level", 12000, 1, "int", &power_on_level, 0, 0);
	level thread function_866a2751();
	level thread function_a8bcf075();
	level thread function_1eb91e4b();
	level thread function_b833e317();
	level thread function_65c51e85();
}

/*
	Name: ambient_mortar_strike
	Namespace: zm_stalingrad_ambient
	Checksum: 0xBDBEBA14
	Offset: 0x500
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function ambient_mortar_strike(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 1:
		{
			var_df2299f9 = "ambient_mortar_small";
			break;
		}
		case 2:
		{
			var_df2299f9 = "ambient_mortar_medium";
			break;
		}
		case 3:
		{
			var_df2299f9 = "ambient_mortar_large";
			break;
		}
		default:
		{
			return;
		}
	}
	self thread function_a7d3e4ff(localclientnum, var_df2299f9);
}

/*
	Name: ambient_artillery_strike
	Namespace: zm_stalingrad_ambient
	Checksum: 0xA0BF571E
	Offset: 0x5D0
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function ambient_artillery_strike(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 1:
		{
			var_df2299f9 = "ambient_artillery_small";
			break;
		}
		case 2:
		{
			var_df2299f9 = "ambient_artillery_medium";
			break;
		}
		case 3:
		{
			var_df2299f9 = "ambient_artillery_large";
			break;
		}
		default:
		{
			return;
		}
	}
	self thread function_a7d3e4ff(localclientnum, var_df2299f9);
}

/*
	Name: function_a7d3e4ff
	Namespace: zm_stalingrad_ambient
	Checksum: 0xB40305A0
	Offset: 0x6A0
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function function_a7d3e4ff(localclientnum, var_df2299f9)
{
	level endon(#"demo_jump");
	playsound(localclientnum, "prj_mortar_incoming", self.origin);
	wait(1);
	playsound(localclientnum, "exp_mortar", self.origin);
	playfx(localclientnum, level._effect[var_df2299f9], self.origin);
	playrumbleonposition(localclientnum, "artillery_rumble", self.origin);
}

/*
	Name: power_on_level
	Namespace: zm_stalingrad_ambient
	Checksum: 0x2024E277
	Offset: 0x778
	Size: 0x52
	Parameters: 7
	Flags: Linked
*/
function power_on_level(n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump)
{
	if(n_new)
	{
		level notify(#"power_on_level");
	}
}

/*
	Name: function_866a2751
	Namespace: zm_stalingrad_ambient
	Checksum: 0x4636F9D7
	Offset: 0x7D8
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function function_866a2751()
{
	level thread function_916d6917("comm_monitor_lrg_combined");
	level thread function_916d6917("comm_equip_top_01");
	level thread function_916d6917("comm_equip_top_02");
	level thread function_916d6917("comm_equip_top_03");
	level thread function_916d6917("comm_equip_top_04");
	level thread function_916d6917("comm_equip_base_02");
	level waittill(#"power_on_level");
	function_4820908f("comm_monitor_lrg_combined_off");
	function_4820908f("comm_equip_top_01_off");
	function_4820908f("comm_equip_top_02_off");
	function_4820908f("comm_equip_top_03_off");
	function_4820908f("comm_equip_top_04_off");
	function_4820908f("comm_equip_base_02_off");
}

/*
	Name: function_916d6917
	Namespace: zm_stalingrad_ambient
	Checksum: 0x736496A9
	Offset: 0x948
	Size: 0x13A
	Parameters: 1
	Flags: Linked
*/
function function_916d6917(str_targetname)
{
	var_1bbd14fd = findstaticmodelindexarray(str_targetname);
	foreach(n_model_index in var_1bbd14fd)
	{
		hidestaticmodel(n_model_index);
	}
	level waittill(#"power_on_level");
	foreach(n_model_index in var_1bbd14fd)
	{
		unhidestaticmodel(n_model_index);
	}
}

/*
	Name: function_4820908f
	Namespace: zm_stalingrad_ambient
	Checksum: 0x7602F239
	Offset: 0xA90
	Size: 0x13A
	Parameters: 1
	Flags: Linked
*/
function function_4820908f(str_targetname)
{
	var_1bbd14fd = findstaticmodelindexarray(str_targetname);
	foreach(n_model_index in var_1bbd14fd)
	{
		unhidestaticmodel(n_model_index);
	}
	level waittill(#"power_on_level");
	foreach(n_model_index in var_1bbd14fd)
	{
		hidestaticmodel(n_model_index);
	}
}

/*
	Name: function_a8bcf075
	Namespace: zm_stalingrad_ambient
	Checksum: 0x89A66A65
	Offset: 0xBD8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_a8bcf075()
{
	level waittill(#"nbs");
	audio::snd_set_snapshot("zmb_stal_boss_fight");
}

/*
	Name: function_1eb91e4b
	Namespace: zm_stalingrad_ambient
	Checksum: 0xC24BAAC2
	Offset: 0xC10
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_1eb91e4b()
{
	level waittill(#"nbstp");
	audio::snd_set_snapshot("default");
}

/*
	Name: function_b833e317
	Namespace: zm_stalingrad_ambient
	Checksum: 0x30FAB8DC
	Offset: 0xC48
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_b833e317()
{
	level waittill(#"dfs");
	audio::snd_set_snapshot("zmb_stal_dragon_fight");
}

/*
	Name: function_b6e2489
	Namespace: zm_stalingrad_ambient
	Checksum: 0x47AB23DC
	Offset: 0xC80
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function function_b6e2489()
{
	level waittill(#"dfss");
	audio::snd_set_snapshot("default");
}

/*
	Name: function_65c51e85
	Namespace: zm_stalingrad_ambient
	Checksum: 0xB0BEC197
	Offset: 0xCB8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_65c51e85()
{
	audio::playloopat("amb_air_raid", (-1819, 2705, 1167));
}

