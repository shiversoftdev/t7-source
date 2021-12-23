// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_equip_hacker;

#namespace zm_hackables_packapunch;

/*
	Name: hack_packapunch
	Namespace: zm_hackables_packapunch
	Checksum: 0x6A95005A
	Offset: 0x150
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function hack_packapunch()
{
	vending_weapon_upgrade_trigger = getentarray("pack_a_punch", "script_noteworthy");
	perk = getent(vending_weapon_upgrade_trigger[0].target, "targetname");
	if(isdefined(perk))
	{
		struct = spawnstruct();
		struct.origin = (perk.origin + (anglestoright(perk.angles) * 26)) + vectorscale((0, 0, 1), 48);
		struct.radius = 48;
		struct.height = 48;
		struct.script_float = 5;
		struct.script_int = -1000;
		level._pack_hack_struct = struct;
		zm_equip_hacker::register_pooled_hackable_struct(level._pack_hack_struct, &packapunch_hack);
		level._pack_hack_struct pack_trigger_think();
	}
}

/*
	Name: pack_trigger_think
	Namespace: zm_hackables_packapunch
	Checksum: 0x3EA69EAD
	Offset: 0x2D8
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function pack_trigger_think()
{
	if(!level flag::exists("enter_nml"))
	{
		return;
	}
	while(true)
	{
		level flag::wait_till("enter_nml");
		self.script_int = -1000;
		while(level flag::get("enter_nml"))
		{
			wait(1);
		}
	}
}

/*
	Name: packapunch_hack
	Namespace: zm_hackables_packapunch
	Checksum: 0x73D40910
	Offset: 0x368
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function packapunch_hack(hacker)
{
	zm_equip_hacker::deregister_hackable_struct(level._pack_hack_struct);
	level._pack_hack_struct.script_int = 0;
	level notify(#"packapunch_hacked");
}

