// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_driving_fx;
#using scripts\zm\_filter;
#using scripts\zm\_sticky_grenade;

#namespace callback;

/*
	Name: __init__sytem__
	Namespace: callback
	Checksum: 0x5AD5873D
	Offset: 0x238
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
	Checksum: 0x5D7E15A0
	Offset: 0x278
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
	Checksum: 0xCBF53703
	Offset: 0x2A0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function set_default_callbacks()
{
	level.callbackplayerspawned = &playerspawned;
	level.callbacklocalclientconnect = &localclientconnect;
	level.callbackentityspawned = &entityspawned;
	level.callbackhostmigration = &host_migration;
	level.callbackplayaifootstep = &footsteps::playaifootstep;
	level.callbackplaylightloopexploder = &exploder::playlightloopexploder;
	level._custom_weapon_cb_func = &spawned_weapon_type;
}

/*
	Name: localclientconnect
	Namespace: callback
	Checksum: 0x4A89D19C
	Offset: 0x358
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function localclientconnect(localclientnum)
{
	/#
		println("" + localclientnum);
	#/
	callback(#"hash_da8d7d74", localclientnum);
	if(isdefined(level.charactercustomizationsetup))
	{
		[[level.charactercustomizationsetup]](localclientnum);
	}
}

/*
	Name: playerspawned
	Namespace: callback
	Checksum: 0xDE18DDED
	Offset: 0x3D8
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function playerspawned(localclientnum)
{
	self endon(#"entityshutdown");
	if(isdefined(level._playerspawned_override))
	{
		self thread [[level._playerspawned_override]](localclientnum);
		return;
	}
	/#
		println("");
	#/
	if(self islocalplayer())
	{
		callback(#"hash_842e788a", localclientnum);
	}
	callback(#"hash_bc12b61f", localclientnum);
	level.localplayers = getlocalplayers();
}

/*
	Name: entityspawned
	Namespace: callback
	Checksum: 0xE536F726
	Offset: 0x4A8
	Size: 0x268
	Parameters: 1
	Flags: Linked
*/
function entityspawned(localclientnum)
{
	self endon(#"entityshutdown");
	if(self isplayer())
	{
		if(isdefined(level._clientfaceanimonplayerspawned))
		{
			self thread [[level._clientfaceanimonplayerspawned]](localclientnum);
		}
	}
	if(isdefined(level._entityspawned_override))
	{
		self thread [[level._entityspawned_override]](localclientnum);
		return;
	}
	if(!isdefined(self.type))
	{
		/#
			println("");
		#/
		return;
	}
	if(self.type == "missile")
	{
		if(isdefined(level._custom_weapon_cb_func))
		{
			self thread [[level._custom_weapon_cb_func]](localclientnum);
		}
		switch(self.weapon.name)
		{
			case "sticky_grenade":
			{
				self thread _sticky_grenade::spawned(localclientnum);
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
			if(self.type == "plane" || self.type == "helicopter")
			{
				self thread vehicle::aircraft_dustkick();
			}
			else
			{
				self thread driving_fx::play_driving_fx(localclientnum);
			}
		}
		else if(self.type == "actor")
		{
			if(isdefined(level._customactorcbfunc))
			{
				self thread [[level._customactorcbfunc]](localclientnum);
			}
		}
	}
}

/*
	Name: host_migration
	Namespace: callback
	Checksum: 0x8E874C0B
	Offset: 0x718
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function host_migration(localclientnum)
{
	level thread prevent_round_switch_animation();
}

/*
	Name: prevent_round_switch_animation
	Namespace: callback
	Checksum: 0xCFCD975C
	Offset: 0x748
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function prevent_round_switch_animation()
{
	wait(3);
}

