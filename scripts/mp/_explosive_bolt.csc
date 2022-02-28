// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace explosive_bolt;

/*
	Name: __init__sytem__
	Namespace: explosive_bolt
	Checksum: 0xC1E203E4
	Offset: 0x198
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("explosive_bolt", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: explosive_bolt
	Checksum: 0x290DDBCE
	Offset: 0x1D8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["crossbow_light"] = "weapon/fx_equip_light_os";
	callback::add_weapon_type("explosive_bolt", &spawned);
}

/*
	Name: spawned
	Namespace: explosive_bolt
	Checksum: 0xF601C4DC
	Offset: 0x228
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function spawned(localclientnum)
{
	if(self isgrenadedud())
	{
		return;
	}
	self thread fx_think(localclientnum);
}

/*
	Name: fx_think
	Namespace: explosive_bolt
	Checksum: 0x75F6E4F4
	Offset: 0x278
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function fx_think(localclientnum)
{
	self notify(#"light_disable");
	self endon(#"entityshutdown");
	self endon(#"light_disable");
	self util::waittill_dobj(localclientnum);
	interval = 0.3;
	for(;;)
	{
		self stop_light_fx(localclientnum);
		self start_light_fx(localclientnum);
		self fullscreen_fx(localclientnum);
		self playsound(localclientnum, "wpn_semtex_alert");
		util::server_wait(localclientnum, interval, 0.016, "player_switch");
		interval = math::clamp(interval / 1.2, 0.08, 0.3);
	}
}

/*
	Name: start_light_fx
	Namespace: explosive_bolt
	Checksum: 0xBB1685E5
	Offset: 0x3B0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function start_light_fx(localclientnum)
{
	player = getlocalplayer(localclientnum);
	self.fx = playfxontag(localclientnum, level._effect["crossbow_light"], self, "tag_origin");
}

/*
	Name: stop_light_fx
	Namespace: explosive_bolt
	Checksum: 0xF4662D04
	Offset: 0x428
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function stop_light_fx(localclientnum)
{
	if(isdefined(self.fx) && self.fx != 0)
	{
		stopfx(localclientnum, self.fx);
		self.fx = undefined;
	}
}

/*
	Name: fullscreen_fx
	Namespace: explosive_bolt
	Checksum: 0x6213BCBD
	Offset: 0x480
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function fullscreen_fx(localclientnum)
{
	player = getlocalplayer(localclientnum);
	if(isdefined(player))
	{
		if(player getinkillcam(localclientnum))
		{
			return;
		}
		if(player util::is_player_view_linked_to_entity(localclientnum))
		{
			return;
		}
	}
	if(self util::friend_not_foe(localclientnum))
	{
		return;
	}
	parent = self getparententity();
	if(isdefined(parent) && parent == player)
	{
		parent playrumbleonentity(localclientnum, "buzz_high");
	}
}

