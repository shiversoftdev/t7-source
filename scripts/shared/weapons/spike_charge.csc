// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace sticky_grenade;

/*
	Name: __init__sytem__
	Namespace: sticky_grenade
	Checksum: 0xF63BFE3B
	Offset: 0x1D0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spike_charge", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: sticky_grenade
	Checksum: 0xBA7CF905
	Offset: 0x210
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["spike_light"] = "weapon/fx_light_spike_launcher";
	callback::add_weapon_type("spike_launcher", &spawned);
	callback::add_weapon_type("spike_launcher_cpzm", &spawned);
	callback::add_weapon_type("spike_charge", &spawned_spike_charge);
}

/*
	Name: spawned
	Namespace: sticky_grenade
	Checksum: 0xD5BF0BF6
	Offset: 0x2B0
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function spawned(localclientnum)
{
	self thread fx_think(localclientnum);
}

/*
	Name: spawned_spike_charge
	Namespace: sticky_grenade
	Checksum: 0xF6DA891F
	Offset: 0x2E0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function spawned_spike_charge(localclientnum)
{
	self thread fx_think(localclientnum);
	self thread spike_detonation(localclientnum);
}

/*
	Name: fx_think
	Namespace: sticky_grenade
	Checksum: 0x59FF6660
	Offset: 0x328
	Size: 0x10C
	Parameters: 1
	Flags: None
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
		util::server_wait(localclientnum, interval, 0.01, "player_switch");
		self util::waittill_dobj(localclientnum);
		interval = math::clamp(interval / 1.2, 0.08, 0.3);
	}
}

/*
	Name: start_light_fx
	Namespace: sticky_grenade
	Checksum: 0x4AD23D31
	Offset: 0x440
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function start_light_fx(localclientnum)
{
	player = getlocalplayer(localclientnum);
	self.fx = playfxontag(localclientnum, level._effect["spike_light"], self, "tag_fx");
}

/*
	Name: stop_light_fx
	Namespace: sticky_grenade
	Checksum: 0x37EDC037
	Offset: 0x4B8
	Size: 0x4E
	Parameters: 1
	Flags: None
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
	Name: spike_detonation
	Namespace: sticky_grenade
	Checksum: 0x501C98EF
	Offset: 0x510
	Size: 0x104
	Parameters: 1
	Flags: None
*/
function spike_detonation(localclientnum)
{
	spike_position = self.origin;
	while(isdefined(self))
	{
		wait(0.016);
	}
	if(!isigcactive(localclientnum))
	{
		player = getlocalplayer(localclientnum);
		explosion_distance = distancesquared(spike_position, player.origin);
		if(explosion_distance <= (450 * 450))
		{
			player thread postfx::playpostfxbundle("pstfx_dust_chalk");
		}
		if(explosion_distance <= (300 * 300))
		{
			player thread postfx::playpostfxbundle("pstfx_dust_concrete");
		}
	}
}

