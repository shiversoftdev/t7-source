// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_stalingrad_mounted_mg;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_mounted_mg
	Checksum: 0x8989E3B4
	Offset: 0x190
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_mounted_mg", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_mounted_mg
	Checksum: 0xFDC67FFC
	Offset: 0x1D0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["mounted_mg_overheat"] = "dlc3/stalingrad/fx_mg42_over_heat";
	clientfield::register("vehicle", "overheat_fx", 12000, 1, "int", &function_c71f5e4a, 0, 0);
}

/*
	Name: function_c71f5e4a
	Namespace: zm_stalingrad_mounted_mg
	Checksum: 0xC81E841F
	Offset: 0x240
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function function_c71f5e4a(n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump)
{
	if(n_new)
	{
		self.var_b4b6b5a6 = playfxontag(n_local_client, level._effect["mounted_mg_overheat"], self, "tag_flash");
	}
	else if(isdefined(self.var_b4b6b5a6))
	{
		stopfx(n_local_client, self.var_b4b6b5a6);
	}
}

