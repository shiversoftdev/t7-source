// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_staminup;

/*
	Name: __init__sytem__
	Namespace: zm_perk_staminup
	Checksum: 0xF0DD807E
	Offset: 0x198
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_staminup", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_staminup
	Checksum: 0x94B9FDD4
	Offset: 0x1D8
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	enable_staminup_perk_for_level();
}

/*
	Name: enable_staminup_perk_for_level
	Namespace: zm_perk_staminup
	Checksum: 0x55D9FB82
	Offset: 0x1F8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function enable_staminup_perk_for_level()
{
	zm_perks::register_perk_clientfields("specialty_staminup", &staminup_client_field_func, &staminup_callback_func);
	zm_perks::register_perk_effects("specialty_staminup", "marathon_light");
	zm_perks::register_perk_init_thread("specialty_staminup", &init_staminup);
}

/*
	Name: init_staminup
	Namespace: zm_perk_staminup
	Checksum: 0xAA274B19
	Offset: 0x288
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function init_staminup()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["marathon_light"] = "zombie/fx_perk_stamin_up_zmb";
	}
}

/*
	Name: staminup_client_field_func
	Namespace: zm_perk_staminup
	Checksum: 0x79C2E58E
	Offset: 0x2C8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function staminup_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.marathon", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: staminup_callback_func
	Namespace: zm_perk_staminup
	Checksum: 0x99EC1590
	Offset: 0x310
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function staminup_callback_func()
{
}

