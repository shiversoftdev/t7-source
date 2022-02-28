// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_burnplayer;
#using scripts\cp\_callbacks;
#using scripts\cp\_claymore;
#using scripts\cp\_explosive_bolt;
#using scripts\shared\ai_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_driving_fx;
#using scripts\shared\weapons\_sticky_grenade;

#namespace callback;

/*
	Name: __init__sytem__
	Namespace: callback
	Checksum: 0xA6D82ACF
	Offset: 0x2A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("callback", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: callback
	Checksum: 0x9BEDC0D2
	Offset: 0x2E0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level thread set_default_callbacks();
}

/*
	Name: set_default_callbacks
	Namespace: callback
	Checksum: 0x730783FA
	Offset: 0x308
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function set_default_callbacks()
{
	level.callbackplayerspawned = &playerspawned;
	level.callbacklocalclientconnect = &localclientconnect;
	level.callbackcreatingcorpse = &creating_corpse;
	level.callbackentityspawned = &entityspawned;
	level.callbackplayaifootstep = &footsteps::playaifootstep;
	level.callbackplaylightloopexploder = &exploder::playlightloopexploder;
	level._custom_weapon_cb_func = &spawned_weapon_type;
}

/*
	Name: localclientconnect
	Namespace: callback
	Checksum: 0x88DC56C9
	Offset: 0x3C0
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function localclientconnect(localclientnum)
{
	/#
		println("" + localclientnum);
	#/
	if(isdefined(level.charactercustomizationsetup))
	{
		[[level.charactercustomizationsetup]](localclientnum);
	}
	if(isdefined(level.weaponcustomizationiconsetup))
	{
		[[level.weaponcustomizationiconsetup]](localclientnum);
	}
	callback(#"hash_da8d7d74", localclientnum);
}

/*
	Name: playerspawned
	Namespace: callback
	Checksum: 0xA79090FD
	Offset: 0x460
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function playerspawned(localclientnum)
{
	self endon(#"entityshutdown");
	player = getlocalplayer(localclientnum);
	/#
		assert(isdefined(player));
	#/
	if(isdefined(level.infraredvisionset))
	{
		player setinfraredvisionset(level.infraredvisionset);
	}
	if(self islocalplayer())
	{
		callback(#"hash_842e788a", localclientnum);
	}
	callback(#"hash_bc12b61f", localclientnum);
}

/*
	Name: entityspawned
	Namespace: callback
	Checksum: 0xAE349612
	Offset: 0x540
	Size: 0x28C
	Parameters: 1
	Flags: Linked
*/
function entityspawned(localclientnum)
{
	self endon(#"entityshutdown");
	if(!isdefined(self.type))
	{
		/#
			println("");
		#/
		return;
	}
	if(self isplayer())
	{
		if(isdefined(level._clientfaceanimonplayerspawned))
		{
			self thread [[level._clientfaceanimonplayerspawned]](localclientnum);
		}
	}
	if(self.type == "missile")
	{
		if(isdefined(level._custom_weapon_cb_func))
		{
			self thread [[level._custom_weapon_cb_func]](localclientnum);
		}
		switch(self.weapon.name)
		{
			case "explosive_bolt":
			{
				self thread _explosive_bolt::spawned(localclientnum);
				break;
			}
			case "claymore":
			{
				self thread _claymore::spawned(localclientnum);
				break;
			}
		}
	}
	else
	{
		if(self.type == "vehicle" || self.type == "helicopter" || self.type == "plane")
		{
			if(isdefined(level._customvehiclecbfunc))
			{
				self thread [[level._customvehiclecbfunc]](localclientnum);
			}
			self thread vehicle::field_toggle_exhaustfx_handler(localclientnum, undefined, 0, 1);
			self thread vehicle::field_toggle_lights_handler(localclientnum, undefined, 0, 1);
			if(self.vehicleclass == "plane" || self.vehicleclass == "helicopter")
			{
				self thread vehicle::aircraft_dustkick();
			}
			else
			{
				self thread driving_fx::play_driving_fx(localclientnum);
				self thread vehicle::rumble(localclientnum);
			}
		}
		else if(self.type == "actor")
		{
			self enableonradar();
			if(isdefined(level._customactorcbfunc))
			{
				self thread [[level._customactorcbfunc]](localclientnum);
			}
		}
	}
}

/*
	Name: creating_corpse
	Namespace: callback
	Checksum: 0x27C5D29E
	Offset: 0x7D8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function creating_corpse(localclientnum, player)
{
}

/*
	Name: callback_stunned
	Namespace: callback
	Checksum: 0x9692397E
	Offset: 0x7F8
	Size: 0x8A
	Parameters: 7
	Flags: None
*/
function callback_stunned(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self.stunned = newval;
	/#
		println("");
	#/
	if(newval)
	{
		self notify(#"stunned");
	}
	else
	{
		self notify(#"not_stunned");
	}
}

/*
	Name: callback_emp
	Namespace: callback
	Checksum: 0x6D02779B
	Offset: 0x890
	Size: 0x8A
	Parameters: 7
	Flags: None
*/
function callback_emp(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self.emp = newval;
	/#
		println("");
	#/
	if(newval)
	{
		self notify(#"emp");
	}
	else
	{
		self notify(#"not_emp");
	}
}

/*
	Name: callback_proximity
	Namespace: callback
	Checksum: 0x6E137C89
	Offset: 0x928
	Size: 0x48
	Parameters: 7
	Flags: None
*/
function callback_proximity(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self.enemyinproximity = newval;
}

