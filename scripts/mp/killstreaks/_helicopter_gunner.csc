// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace helicopter_gunner;

/*
	Name: __init__sytem__
	Namespace: helicopter_gunner
	Checksum: 0x28E0E411
	Offset: 0x208
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("helicopter_gunner", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: helicopter_gunner
	Checksum: 0x7788C6EC
	Offset: 0x248
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("vehicle", "vtol_turret_destroyed_0", 1, 1, "int", &turret_destroyed_0, 0, 0);
	clientfield::register("vehicle", "vtol_turret_destroyed_1", 1, 1, "int", &turret_destroyed_1, 0, 0);
	clientfield::register("toplayer", "vtol_update_client", 1, 1, "counter", &update_client, 0, 0);
	clientfield::register("toplayer", "fog_bank_2", 1, 1, "int", &fog_bank_2_callback, 0, 0);
	visionset_mgr::register_visionset_info("mothership_visionset", 1, 1, undefined, "mp_vehicles_mothership");
}

/*
	Name: turret_destroyed_0
	Namespace: helicopter_gunner
	Checksum: 0x66DF3794
	Offset: 0x3A0
	Size: 0x3C
	Parameters: 7
	Flags: Linked
*/
function turret_destroyed_0(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
}

/*
	Name: turret_destroyed_1
	Namespace: helicopter_gunner
	Checksum: 0x2E0E26AB
	Offset: 0x3E8
	Size: 0x3C
	Parameters: 7
	Flags: Linked
*/
function turret_destroyed_1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
}

/*
	Name: update_turret_destroyed
	Namespace: helicopter_gunner
	Checksum: 0x8D02CAA7
	Offset: 0x430
	Size: 0x7C
	Parameters: 3
	Flags: Linked
*/
function update_turret_destroyed(localclientnum, ui_model_name, new_value)
{
	part_destroyed_ui_model = getuimodel(getuimodelforcontroller(localclientnum), ui_model_name);
	if(isdefined(part_destroyed_ui_model))
	{
		setuimodelvalue(part_destroyed_ui_model, new_value);
	}
}

/*
	Name: update_client
	Namespace: helicopter_gunner
	Checksum: 0x4F474745
	Offset: 0x4B8
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function update_client(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	veh = getplayervehicle(self);
	if(isdefined(veh))
	{
		update_turret_destroyed(localclientnum, "vehicle.partDestroyed.0", veh clientfield::get("vtol_turret_destroyed_0"));
		update_turret_destroyed(localclientnum, "vehicle.partDestroyed.1", veh clientfield::get("vtol_turret_destroyed_1"));
	}
}

/*
	Name: fog_bank_2_callback
	Namespace: helicopter_gunner
	Checksum: 0xEB96673E
	Offset: 0x5A0
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function fog_bank_2_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(oldval != newval)
	{
		if(newval == 1)
		{
			setlitfogbank(localclientnum, -1, 1, 0);
		}
		else
		{
			setlitfogbank(localclientnum, -1, 0, 0);
		}
	}
}

