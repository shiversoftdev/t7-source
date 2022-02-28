// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\killstreaks\_ai_tank;
#using scripts\mp\killstreaks\_qrdrone;
#using scripts\mp\killstreaks\_rcbomb;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace vehicle;

/*
	Name: __init__sytem__
	Namespace: vehicle
	Checksum: 0xE710735F
	Offset: 0x198
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("vehicle", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: vehicle
	Checksum: 0xE76DF173
	Offset: 0x1D8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!isdefined(level._effect))
	{
		level._effect = [];
	}
	level.vehicles_inited = 1;
	clientfield::register("vehicle", "timeout_beep", 1, 2, "int", &timeout_beep, 0, 0);
}

/*
	Name: vehicle_rumble
	Namespace: vehicle
	Checksum: 0x2DD0F302
	Offset: 0x250
	Size: 0x3A0
	Parameters: 1
	Flags: Linked
*/
function vehicle_rumble(localclientnum)
{
	self endon(#"entityshutdown");
	if(!isdefined(level.vehicle_rumble))
	{
		return;
	}
	type = self.vehicletype;
	if(!isdefined(level.vehicle_rumble[type]))
	{
		return;
	}
	rumblestruct = level.vehicle_rumble[type];
	height = rumblestruct.radius * 2;
	zoffset = -1 * rumblestruct.radius;
	if(!isdefined(self.rumbleon))
	{
		self.rumbleon = 1;
	}
	if(isdefined(rumblestruct.scale))
	{
		self.rumble_scale = rumblestruct.scale;
	}
	else
	{
		self.rumble_scale = 0.15;
	}
	if(isdefined(rumblestruct.duration))
	{
		self.rumble_duration = rumblestruct.duration;
	}
	else
	{
		self.rumble_duration = 4.5;
	}
	if(isdefined(rumblestruct.radius))
	{
		self.rumble_radius = rumblestruct.radius;
	}
	else
	{
		self.rumble_radius = 600;
	}
	if(isdefined(rumblestruct.basetime))
	{
		self.rumble_basetime = rumblestruct.basetime;
	}
	else
	{
		self.rumble_basetime = 1;
	}
	if(isdefined(rumblestruct.randomaditionaltime))
	{
		self.rumble_randomaditionaltime = rumblestruct.randomaditionaltime;
	}
	else
	{
		self.rumble_randomaditionaltime = 1;
	}
	self.player_touching = 0;
	radius_squared = rumblestruct.radius * rumblestruct.radius;
	while(true)
	{
		if(distancesquared(self.origin, level.localplayers[localclientnum].origin) > radius_squared || self getspeed() < 35)
		{
			wait(0.2);
			continue;
		}
		if(isdefined(self.rumbleon) && !self.rumbleon)
		{
			wait(0.2);
			continue;
		}
		self playrumblelooponentity(localclientnum, level.vehicle_rumble[type].rumble);
		while(distancesquared(self.origin, level.localplayers[localclientnum].origin) < radius_squared && self getspeed() > 5)
		{
			wait(self.rumble_basetime + randomfloat(self.rumble_randomaditionaltime));
		}
		self stoprumble(localclientnum, level.vehicle_rumble[type].rumble);
	}
}

/*
	Name: set_static_amount
	Namespace: vehicle
	Checksum: 0x2D473C90
	Offset: 0x5F8
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function set_static_amount(staticamount)
{
	driverlocalclient = self getlocalclientdriver();
	if(isdefined(driverlocalclient))
	{
		driver = getlocalplayer(driverlocalclient);
		if(isdefined(driver))
		{
			setfilterpassconstant(driver.localclientnum, 4, 0, 1, staticamount);
		}
	}
}

/*
	Name: vehicle_variants
	Namespace: vehicle
	Checksum: 0x69678AE2
	Offset: 0x698
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function vehicle_variants(localclientnum)
{
}

/*
	Name: timeout_beep
	Namespace: vehicle
	Checksum: 0x9C8D31E5
	Offset: 0x6B0
	Size: 0x19C
	Parameters: 7
	Flags: Linked
*/
function timeout_beep(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self notify(#"timeout_beep");
	if(!newval)
	{
		return;
	}
	if(isdefined(self.killstreakbundle))
	{
		beepalias = self.killstreakbundle.kstimeoutbeepalias;
	}
	self endon(#"entityshutdown");
	self endon(#"timeout_beep");
	interval = 1;
	if(newval == 2)
	{
		interval = 0.133;
	}
	while(true)
	{
		if(isdefined(beepalias))
		{
			self playsound(localclientnum, beepalias);
		}
		if(self.timeoutlightsoff === 1)
		{
			self lights_on(localclientnum);
			self.timeoutlightsoff = 0;
		}
		else
		{
			self lights_off(localclientnum);
			self.timeoutlightsoff = 1;
		}
		util::server_wait(localclientnum, interval);
		interval = math::clamp(interval / 1.17, 0.1, 1);
	}
}

