// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_genesis_timer;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_timer
	Checksum: 0x7D77C56C
	Offset: 0x1D8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_timer", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_timer
	Checksum: 0x99EC1590
	Offset: 0x220
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: zm_genesis_timer
	Checksum: 0x393961B1
	Offset: 0x230
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	clientfield::register("world", "time_attack_reward", 12000, 3, "int", &function_b94ee48a, 0, 0);
	level.wallbuy_callback_hack_override = &function_3ec869e2;
}

/*
	Name: function_b94ee48a
	Namespace: zm_genesis_timer
	Checksum: 0x10087577
	Offset: 0x2A0
	Size: 0x48
	Parameters: 7
	Flags: Linked
*/
function function_b94ee48a(n_local_client, var_3bf16bb3, var_6998917a, b_new_ent, var_b54312de, str_field_name, b_was_time_jump)
{
	level.var_dd724c18 = var_6998917a;
}

/*
	Name: function_3ec869e2
	Namespace: zm_genesis_timer
	Checksum: 0x5C64D2C9
	Offset: 0x2F0
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function function_3ec869e2()
{
	s_parent = self.parent_struct;
	if(!isdefined(s_parent.var_67b0ba8d))
	{
		s_parent.var_67b0ba8d = s_parent.origin;
	}
	if(!isdefined(self.var_cd859c93))
	{
		self.var_cd859c93 = self.angles;
	}
	v_offset_origin = (0, 0, 0);
	var_5c51aae8 = (0, 0, 0);
	switch(level.var_dd724c18)
	{
		case 1:
		{
			self setmodel("wpn_t7_loot_nunchucks_world");
			break;
		}
		case 2:
		{
			self setmodel("wpn_t7_loot_mace_world");
			var_5c51aae8 = vectorscale((1, 0, 0), 90);
			break;
		}
		case 3:
		{
			self setmodel("wpn_t7_loot_improvise_world");
			v_offset_origin = vectorscale((0, -1, 0), 3);
			var_5c51aae8 = vectorscale((1, 0, 0), 90);
			break;
		}
		case 4:
		{
			self setmodel("wpn_t7_loot_boneglass_world");
			v_offset_origin = (0, -6, 1);
			var_5c51aae8 = vectorscale((-1, 0, 0), 15);
			break;
		}
		case 5:
		{
			self setmodel("wpn_t7_loot_melee_katana_world");
			v_offset_origin = (1, -22, 0);
			var_5c51aae8 = vectorscale((-1, 0, 0), 88);
			break;
		}
	}
	s_parent.origin = s_parent.var_67b0ba8d + v_offset_origin;
	self.angles = self.var_cd859c93 + var_5c51aae8;
}

