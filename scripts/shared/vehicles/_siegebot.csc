// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons\spike_charge_siegebot;

#namespace siegebot;

/*
	Name: main
	Namespace: siegebot
	Checksum: 0x17543661
	Offset: 0x178
	Size: 0x2C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	vehicle::add_vehicletype_callback("siegebot", &_setup_);
}

/*
	Name: _setup_
	Namespace: siegebot
	Checksum: 0x905B8876
	Offset: 0x1B0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function _setup_(localclientnum)
{
	if(isdefined(self.scriptbundlesettings))
	{
		settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	}
	if(!isdefined(settings))
	{
		return;
	}
}

