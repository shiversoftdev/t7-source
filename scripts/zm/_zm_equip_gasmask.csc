// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_equipment;

#namespace zm_equip_gasmask;

/*
	Name: __init__sytem__
	Namespace: zm_equip_gasmask
	Checksum: 0x712E7161
	Offset: 0x1D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_equip_gasmask", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_equip_gasmask
	Checksum: 0xB327CC4B
	Offset: 0x218
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_equipment::include("equip_gasmask");
	clientfield::register("toplayer", "gasmaskoverlay", 21000, 1, "int", &gasmask_overlay_handler, 0, 0);
	clientfield::register("clientuimodel", "hudItems.showDpadDown_PES", 21000, 1, "int", undefined, 0, 0);
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_gasmask_postfx", 21000, 32, "pstfx_moon_helmet", 3);
}

/*
	Name: gasmask_overlay_handler
	Namespace: zm_equip_gasmask
	Checksum: 0xB643961
	Offset: 0x2F0
	Size: 0x146
	Parameters: 7
	Flags: Linked
*/
function gasmask_overlay_handler(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(!self islocalplayer() || isspectating(localclientnum, 0) || (isdefined(level.localplayers[localclientnum]) && self getentitynumber() != level.localplayers[localclientnum] getentitynumber()))
	{
		return;
	}
	if(newval)
	{
		if(!isdefined(self.var_cf129735))
		{
			self.var_cf129735 = self playloopsound("evt_gasmask_loop", 0.5);
		}
	}
	else if(isdefined(self.var_cf129735))
	{
		self stoploopsound(self.var_cf129735, 0.5);
		self.var_cf129735 = undefined;
	}
}

