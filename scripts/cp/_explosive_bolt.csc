// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace _explosive_bolt;

/*
	Name: main
	Namespace: _explosive_bolt
	Checksum: 0x8A023D93
	Offset: 0x128
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level._effect["crossbow_light"] = "weapon/fx_equip_light_os";
}

/*
	Name: spawned
	Namespace: _explosive_bolt
	Checksum: 0x439528B7
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
	Namespace: _explosive_bolt
	Checksum: 0x350353A4
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
	Namespace: _explosive_bolt
	Checksum: 0xBFC8117E
	Offset: 0x2D8
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
	Namespace: _explosive_bolt
	Checksum: 0xDB6B62D7
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
	Namespace: _explosive_bolt
	Checksum: 0x17A0A744
	Offset: 0x3A8
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function fullscreen_fx(localclientnum)
{
	player = getlocalplayer(localclientnum);
	if(isdefined(player))
	{
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

