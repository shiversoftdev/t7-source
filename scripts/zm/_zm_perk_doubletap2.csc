// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_doubletap2;

/*
	Name: __init__sytem__
	Namespace: zm_perk_doubletap2
	Checksum: 0x1D225CCE
	Offset: 0x1A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_doubletap2", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_doubletap2
	Checksum: 0xE6B7D0F8
	Offset: 0x1E0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	enable_doubletap2_perk_for_level();
}

/*
	Name: enable_doubletap2_perk_for_level
	Namespace: zm_perk_doubletap2
	Checksum: 0x736F2AE
	Offset: 0x200
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function enable_doubletap2_perk_for_level()
{
	zm_perks::register_perk_clientfields("specialty_doubletap2", &doubletap2_client_field_func, &doubletap2_code_callback_func);
	zm_perks::register_perk_effects("specialty_doubletap2", "doubletap2_light");
	zm_perks::register_perk_init_thread("specialty_doubletap2", &init_doubletap2);
}

/*
	Name: init_doubletap2
	Namespace: zm_perk_doubletap2
	Checksum: 0x663EAA6A
	Offset: 0x290
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function init_doubletap2()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["doubletap2_light"] = "zombie/fx_perk_doubletap2_zmb";
	}
}

/*
	Name: doubletap2_client_field_func
	Namespace: zm_perk_doubletap2
	Checksum: 0x8E0CBD4B
	Offset: 0x2D0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function doubletap2_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.doubletap2", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: doubletap2_code_callback_func
	Namespace: zm_perk_doubletap2
	Checksum: 0x99EC1590
	Offset: 0x318
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function doubletap2_code_callback_func()
{
}

