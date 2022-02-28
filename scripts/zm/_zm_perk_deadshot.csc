// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_deadshot;

/*
	Name: __init__sytem__
	Namespace: zm_perk_deadshot
	Checksum: 0x65214387
	Offset: 0x1B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_deadshot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_deadshot
	Checksum: 0x7EC0D287
	Offset: 0x1F0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	enable_deadshot_perk_for_level();
}

/*
	Name: enable_deadshot_perk_for_level
	Namespace: zm_perk_deadshot
	Checksum: 0x3F1C0ACC
	Offset: 0x210
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function enable_deadshot_perk_for_level()
{
	zm_perks::register_perk_clientfields("specialty_deadshot", &deadshot_client_field_func, &deadshot_code_callback_func);
	zm_perks::register_perk_effects("specialty_deadshot", "deadshot_light");
	zm_perks::register_perk_init_thread("specialty_deadshot", &init_deadshot);
}

/*
	Name: init_deadshot
	Namespace: zm_perk_deadshot
	Checksum: 0x9787AF99
	Offset: 0x2A0
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function init_deadshot()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["deadshot_light"] = "_t6/misc/fx_zombie_cola_dtap_on";
	}
}

/*
	Name: deadshot_client_field_func
	Namespace: zm_perk_deadshot
	Checksum: 0x9687A3FF
	Offset: 0x2E0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function deadshot_client_field_func()
{
	clientfield::register("toplayer", "deadshot_perk", 1, 1, "int", &player_deadshot_perk_handler, 0, 1);
	clientfield::register("clientuimodel", "hudItems.perks.dead_shot", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: deadshot_code_callback_func
	Namespace: zm_perk_deadshot
	Checksum: 0x99EC1590
	Offset: 0x370
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function deadshot_code_callback_func()
{
}

/*
	Name: player_deadshot_perk_handler
	Namespace: zm_perk_deadshot
	Checksum: 0x390B9959
	Offset: 0x380
	Size: 0xF4
	Parameters: 7
	Flags: Linked
*/
function player_deadshot_perk_handler(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!self islocalplayer() || isspectating(localclientnum, 0) || (isdefined(level.localplayers[localclientnum]) && self getentitynumber() != level.localplayers[localclientnum] getentitynumber()))
	{
		return;
	}
	if(newval)
	{
		self usealternateaimparams();
	}
	else
	{
		self clearalternateaimparams();
	}
}

