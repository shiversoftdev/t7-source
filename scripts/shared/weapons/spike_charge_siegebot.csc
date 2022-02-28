// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace spike_charge_siegebot;

/*
	Name: __init__sytem__
	Namespace: spike_charge_siegebot
	Checksum: 0x1AB6F6E8
	Offset: 0x210
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("spike_charge_siegebot", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: spike_charge_siegebot
	Checksum: 0xE9FE437F
	Offset: 0x250
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["spike_charge_siegebot_light"] = "light/fx_light_red_spike_charge_os";
	callback::add_weapon_type("spike_charge_siegebot", &spawned);
	callback::add_weapon_type("spike_charge_siegebot_theia", &spawned);
	callback::add_weapon_type("siegebot_launcher_turret", &spawned);
	callback::add_weapon_type("siegebot_launcher_turret_theia", &spawned);
	callback::add_weapon_type("siegebot_javelin_turret", &spawned);
}

/*
	Name: spawned
	Namespace: spike_charge_siegebot
	Checksum: 0x2589692D
	Offset: 0x340
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function spawned(localclientnum)
{
	self thread fx_think(localclientnum);
}

/*
	Name: fx_think
	Namespace: spike_charge_siegebot
	Checksum: 0x52FF7FB3
	Offset: 0x370
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
		self playsound(localclientnum, "wpn_semtex_alert");
		util::server_wait(localclientnum, interval, 0.01, "player_switch");
		self util::waittill_dobj(localclientnum);
		interval = math::clamp(interval / 1.2, 0.08, 0.3);
	}
}

/*
	Name: start_light_fx
	Namespace: spike_charge_siegebot
	Checksum: 0xB2ADAA4C
	Offset: 0x4A8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function start_light_fx(localclientnum)
{
	player = getlocalplayer(localclientnum);
	self.fx = playfxontag(localclientnum, level._effect["spike_charge_siegebot_light"], self, "tag_fx");
}

/*
	Name: stop_light_fx
	Namespace: spike_charge_siegebot
	Checksum: 0x8BFB3149
	Offset: 0x520
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

