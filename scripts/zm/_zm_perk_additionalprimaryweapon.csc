// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_additionalprimaryweapon;

/*
	Name: __init__sytem__
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0xC1B44C95
	Offset: 0x1E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_additionalprimaryweapon", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0x5DD1B996
	Offset: 0x220
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	enable_additional_primary_weapon_perk_for_level();
}

/*
	Name: enable_additional_primary_weapon_perk_for_level
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0x5F2A17F1
	Offset: 0x240
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function enable_additional_primary_weapon_perk_for_level()
{
	zm_perks::register_perk_clientfields("specialty_additionalprimaryweapon", &additional_primary_weapon_client_field_func, &additional_primary_weapon_code_callback_func);
	zm_perks::register_perk_effects("specialty_additionalprimaryweapon", "additionalprimaryweapon_light");
	zm_perks::register_perk_init_thread("specialty_additionalprimaryweapon", &init_additional_primary_weapon);
}

/*
	Name: init_additional_primary_weapon
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0xA854C5E6
	Offset: 0x2D0
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function init_additional_primary_weapon()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["additionalprimaryweapon_light"] = "zombie/fx_perk_mule_kick_zmb";
	}
}

/*
	Name: additional_primary_weapon_client_field_func
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0x79DB82B4
	Offset: 0x310
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function additional_primary_weapon_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.additional_primary_weapon", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: additional_primary_weapon_code_callback_func
	Namespace: zm_perk_additionalprimaryweapon
	Checksum: 0x99EC1590
	Offset: 0x358
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function additional_primary_weapon_code_callback_func()
{
}

