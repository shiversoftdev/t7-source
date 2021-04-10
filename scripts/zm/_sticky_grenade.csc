// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace _sticky_grenade;

/*
	Name: main
	Namespace: _sticky_grenade
	Checksum: 0xE389EF65
	Offset: 0x128
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level._effect["grenade_light"] = "weapon/fx_equip_light_os";
}

/*
	Name: spawned
	Namespace: _sticky_grenade
	Checksum: 0x14E3A2CB
	Offset: 0x150
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
	Namespace: _sticky_grenade
	Checksum: 0x39E3A1FC
	Offset: 0x1A0
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
		util::server_wait(localclientnum, interval, 0.01, "player_switch");
		interval = math::clamp(interval / 1.2, 0.08, 0.3);
	}
}

/*
	Name: start_light_fx
	Namespace: _sticky_grenade
	Checksum: 0x2D1DDC93
	Offset: 0x2D8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function start_light_fx(localclientnum)
{
	player = getlocalplayer(localclientnum);
	self.fx = playfxontag(localclientnum, level._effect["grenade_light"], self, "tag_fx");
}

/*
	Name: stop_light_fx
	Namespace: _sticky_grenade
	Checksum: 0xBD4EAE3A
	Offset: 0x350
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
	Namespace: _sticky_grenade
	Checksum: 0xB8BF10A4
	Offset: 0x3A8
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

