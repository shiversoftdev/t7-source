// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_shock_field;

/*
	Name: __init__sytem__
	Namespace: _gadget_shock_field
	Checksum: 0xED55D009
	Offset: 0x2A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_shock_field", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_shock_field
	Checksum: 0xF1C73C81
	Offset: 0x2E0
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "shock_field", 1, 1, "int", &player_shock_changed, 0, 1);
	level.shock_field_fx = [];
}

/*
	Name: is_local_player
	Namespace: _gadget_shock_field
	Checksum: 0x73CF8C00
	Offset: 0x340
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function is_local_player(localclientnum)
{
	player_view = getlocalplayer(localclientnum);
	if(!isdefined(player_view))
	{
		return 0;
	}
	sameentity = self == player_view;
	return sameentity;
}

/*
	Name: player_shock_changed
	Namespace: _gadget_shock_field
	Checksum: 0x1F156B61
	Offset: 0x3A0
	Size: 0x150
	Parameters: 7
	Flags: Linked
*/
function player_shock_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	entid = getlocalplayer(localclientnum) getentitynumber();
	if(newval)
	{
		if(!isdefined(level.shock_field_fx[entid]))
		{
			fx = "player/fx_plyr_shock_field";
			if(is_local_player(localclientnum))
			{
				fx = "player/fx_plyr_shock_field_1p";
			}
			tag = "j_spinelower";
			level.shock_field_fx[entid] = playfxontag(localclientnum, fx, self, tag);
		}
	}
	else if(isdefined(level.shock_field_fx[entid]))
	{
		stopfx(localclientnum, level.shock_field_fx[entid]);
		level.shock_field_fx[entid] = undefined;
	}
}

