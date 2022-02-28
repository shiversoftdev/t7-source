// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_sleight_of_hand;

/*
	Name: __init__sytem__
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0x513E051C
	Offset: 0x1B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_sleight_of_hand", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0xC92504B5
	Offset: 0x1F0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	enable_sleight_of_hand_perk_for_level();
}

/*
	Name: enable_sleight_of_hand_perk_for_level
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0x4B590523
	Offset: 0x210
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function enable_sleight_of_hand_perk_for_level()
{
	zm_perks::register_perk_clientfields("specialty_fastreload", &sleight_of_hand_client_field_func, &sleight_of_hand_code_callback_func);
	zm_perks::register_perk_effects("specialty_fastreload", "sleight_light");
	zm_perks::register_perk_init_thread("specialty_fastreload", &init_sleight_of_hand);
}

/*
	Name: init_sleight_of_hand
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0xC6A7A0D0
	Offset: 0x2A0
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function init_sleight_of_hand()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["sleight_light"] = "zombie/fx_perk_sleight_of_hand_zmb";
	}
}

/*
	Name: sleight_of_hand_client_field_func
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0x960F7CE2
	Offset: 0x2E0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function sleight_of_hand_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.sleight_of_hand", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: sleight_of_hand_code_callback_func
	Namespace: zm_perk_sleight_of_hand
	Checksum: 0x99EC1590
	Offset: 0x328
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function sleight_of_hand_code_callback_func()
{
}

