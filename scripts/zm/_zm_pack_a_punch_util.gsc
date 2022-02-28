// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_weapons;

#namespace zm_pap_util;

/*
	Name: init_parameters
	Namespace: zm_pap_util
	Checksum: 0x3957C30
	Offset: 0x1C8
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function init_parameters()
{
	if(!isdefined(level.pack_a_punch))
	{
		level.pack_a_punch = spawnstruct();
		level.pack_a_punch.timeout = 15;
		level.pack_a_punch.interaction_height = 35;
		level.pack_a_punch.move_in_func = &pap_weapon_move_in;
		level.pack_a_punch.move_out_func = &pap_weapon_move_out;
		level.pack_a_punch.grabbable_by_anyone = 0;
		level.pack_a_punch.swap_attachments_on_reuse = 0;
		level.pack_a_punch.triggers = [];
	}
}

/*
	Name: set_timeout
	Namespace: zm_pap_util
	Checksum: 0xC5406EE
	Offset: 0x2A0
	Size: 0x30
	Parameters: 1
	Flags: None
*/
function set_timeout(n_timeout_s)
{
	init_parameters();
	level.pack_a_punch.timeout = n_timeout_s;
}

/*
	Name: set_interaction_height
	Namespace: zm_pap_util
	Checksum: 0x96194044
	Offset: 0x2D8
	Size: 0x30
	Parameters: 1
	Flags: None
*/
function set_interaction_height(n_height)
{
	init_parameters();
	level.pack_a_punch.interaction_height = n_height;
}

/*
	Name: set_interaction_trigger_radius
	Namespace: zm_pap_util
	Checksum: 0x4C8F716F
	Offset: 0x310
	Size: 0x30
	Parameters: 1
	Flags: None
*/
function set_interaction_trigger_radius(n_radius)
{
	init_parameters();
	level.pack_a_punch.interaction_trigger_radius = n_radius;
}

/*
	Name: set_interaction_trigger_height
	Namespace: zm_pap_util
	Checksum: 0x886743A0
	Offset: 0x348
	Size: 0x30
	Parameters: 1
	Flags: None
*/
function set_interaction_trigger_height(n_height)
{
	init_parameters();
	level.pack_a_punch.set_interaction_trigger_height = n_height;
}

/*
	Name: set_move_in_func
	Namespace: zm_pap_util
	Checksum: 0xEDBB23F2
	Offset: 0x380
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function set_move_in_func(fn_move_weapon_in)
{
	init_parameters();
	level.pack_a_punch.move_in_func = fn_move_weapon_in;
}

/*
	Name: set_move_out_func
	Namespace: zm_pap_util
	Checksum: 0xE67B1492
	Offset: 0x3B8
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function set_move_out_func(fn_move_weapon_out)
{
	init_parameters();
	level.pack_a_punch.move_out_func = fn_move_weapon_out;
}

/*
	Name: set_grabbable_by_anyone
	Namespace: zm_pap_util
	Checksum: 0x7810669
	Offset: 0x3F0
	Size: 0x28
	Parameters: 0
	Flags: None
*/
function set_grabbable_by_anyone()
{
	init_parameters();
	level.pack_a_punch.grabbable_by_anyone = 1;
}

/*
	Name: get_triggers
	Namespace: zm_pap_util
	Checksum: 0xC46C6DC2
	Offset: 0x420
	Size: 0x5A
	Parameters: 0
	Flags: Linked
*/
function get_triggers()
{
	init_parameters();
	/#
		if(level.pack_a_punch.triggers.size == 0)
		{
			println("");
		}
	#/
	return level.pack_a_punch.triggers;
}

/*
	Name: is_pap_trigger
	Namespace: zm_pap_util
	Checksum: 0xE345596F
	Offset: 0x488
	Size: 0x20
	Parameters: 0
	Flags: None
*/
function is_pap_trigger()
{
	return isdefined(self.script_noteworthy) && self.script_noteworthy == "pack_a_punch";
}

/*
	Name: enable_swap_attachments
	Namespace: zm_pap_util
	Checksum: 0xCB916BEC
	Offset: 0x4B0
	Size: 0x28
	Parameters: 0
	Flags: None
*/
function enable_swap_attachments()
{
	init_parameters();
	level.pack_a_punch.swap_attachments_on_reuse = 1;
}

/*
	Name: can_swap_attachments
	Namespace: zm_pap_util
	Checksum: 0x1612C03A
	Offset: 0x4E0
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function can_swap_attachments()
{
	if(!isdefined(level.pack_a_punch))
	{
		return 0;
	}
	return level.pack_a_punch.swap_attachments_on_reuse;
}

/*
	Name: update_hint_string
	Namespace: zm_pap_util
	Checksum: 0x19B2F724
	Offset: 0x510
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function update_hint_string(player)
{
	if(self flag::get("pap_offering_gun"))
	{
		self sethintstring(&"ZOMBIE_GET_UPGRADED_FILL");
		return;
	}
	w_curr_player_weapon = player getcurrentweapon();
	if(zm_weapons::is_weapon_upgraded(w_curr_player_weapon))
	{
		self sethintstring(&"ZOMBIE_PERK_PACKAPUNCH_AAT", self.aat_cost);
	}
	else
	{
		self sethintstring(&"ZOMBIE_PERK_PACKAPUNCH", self.cost);
	}
}

/*
	Name: pap_weapon_move_in
	Namespace: zm_pap_util
	Checksum: 0xBD47D2AC
	Offset: 0x5F0
	Size: 0x3C
	Parameters: 4
	Flags: Linked, Private
*/
function private pap_weapon_move_in(player, trigger, origin_offset, angles_offset)
{
	level endon(#"pack_a_punch_off");
	trigger endon(#"pap_player_disconnected");
}

/*
	Name: pap_weapon_move_out
	Namespace: zm_pap_util
	Checksum: 0xFD97FA57
	Offset: 0x638
	Size: 0x3C
	Parameters: 4
	Flags: Linked, Private
*/
function private pap_weapon_move_out(player, trigger, origin_offset, interact_offset)
{
	level endon(#"pack_a_punch_off");
	trigger endon(#"pap_player_disconnected");
}

