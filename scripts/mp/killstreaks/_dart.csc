// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace dart;

/*
	Name: __init__sytem__
	Namespace: dart
	Checksum: 0xE544E108
	Offset: 0x208
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("dart", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: dart
	Checksum: 0xBBB97268
	Offset: 0x248
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "dart_update_ammo", 1, 2, "int", &update_ammo, 0, 0);
	clientfield::register("toplayer", "fog_bank_3", 1, 1, "int", &fog_bank_3_callback, 0, 0);
	level.dartbundle = struct::get_script_bundle("killstreak", "killstreak_dart");
	vehicle::add_vehicletype_callback(level.dartbundle.ksdartvehicle, &spawned);
	visionset_mgr::register_visionset_info("dart_visionset", 1, 1, undefined, "mp_vehicles_dart");
	visionset_mgr::register_visionset_info("sentinel_visionset", 1, 1, undefined, "mp_vehicles_sentinel");
	visionset_mgr::register_visionset_info("remote_missile_visionset", 1, 1, undefined, "mp_hellstorm");
}

/*
	Name: update_ammo
	Namespace: dart
	Checksum: 0xD0347FA9
	Offset: 0x3B8
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function update_ammo(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(getuimodel(getuimodelforcontroller(localclientnum), "vehicle.ammo"), newval);
}

/*
	Name: spawned
	Namespace: dart
	Checksum: 0xA9F51688
	Offset: 0x448
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function spawned(localclientnum)
{
	self.killstreakbundle = level.dartbundle;
}

/*
	Name: fog_bank_3_callback
	Namespace: dart
	Checksum: 0x6C32DA11
	Offset: 0x470
	Size: 0x94
	Parameters: 7
	Flags: Linked
*/
function fog_bank_3_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(oldval != newval)
	{
		if(newval == 1)
		{
			setworldfogactivebank(localclientnum, 4);
		}
		else
		{
			setworldfogactivebank(localclientnum, 1);
		}
	}
}

