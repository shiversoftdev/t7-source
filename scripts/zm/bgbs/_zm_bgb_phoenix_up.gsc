// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_phoenix_up;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_phoenix_up
	Checksum: 0x1A7644A8
	Offset: 0x1E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_phoenix_up", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_phoenix_up
	Checksum: 0x74FCAAC7
	Offset: 0x228
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_phoenix_up", "activated", 1, undefined, undefined, &validation, &activation);
	bgb::register_lost_perk_override("zm_bgb_phoenix_up", &lost_perk_override, 1);
}

/*
	Name: validation
	Namespace: zm_bgb_phoenix_up
	Checksum: 0xCC00651F
	Offset: 0x2C8
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function validation()
{
	players = level.players;
	foreach(player in players)
	{
		if(isdefined(player.var_df0decf1) && player.var_df0decf1)
		{
			return false;
		}
		if(isdefined(level.var_11b06c2f) && self [[level.var_11b06c2f]](player, 1, 1))
		{
			return true;
		}
		if(self zm_laststand::can_revive(player, 1, 1))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: activation
	Namespace: zm_bgb_phoenix_up
	Checksum: 0xB1AA846B
	Offset: 0x3E8
	Size: 0x172
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	playsoundatposition("zmb_bgb_phoenix_activate", (0, 0, 0));
	players = level.players;
	foreach(player in players)
	{
		can_revive = 0;
		if(isdefined(level.var_11b06c2f) && self [[level.var_11b06c2f]](player, 1, 1))
		{
			can_revive = 1;
		}
		else if(self zm_laststand::can_revive(player, 1, 1))
		{
			can_revive = 1;
		}
		if(can_revive)
		{
			player thread bgb::bgb_revive_watcher();
			player zm_laststand::auto_revive(self, 0);
			self zm_stats::increment_challenge_stat("GUM_GOBBLER_PHOENIX_UP");
		}
	}
}

/*
	Name: lost_perk_override
	Namespace: zm_bgb_phoenix_up
	Checksum: 0xD209B7EB
	Offset: 0x568
	Size: 0x5E
	Parameters: 3
	Flags: Linked
*/
function lost_perk_override(perk, var_2488e46a = undefined, var_24df4040 = undefined)
{
	self thread bgb::revive_and_return_perk_on_bgb_activation(perk);
	return false;
}

