// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\aat_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_aat_dead_wire;

/*
	Name: __init__sytem__
	Namespace: zm_aat_dead_wire
	Checksum: 0x9CFEEB5E
	Offset: 0x180
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_dead_wire", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_aat_dead_wire
	Checksum: 0x5B92A17
	Offset: 0x1C0
	Size: 0xFE
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	aat::register("zm_aat_dead_wire", "zmui_zm_aat_dead_wire", "t7_icon_zm_aat_dead_wire");
	clientfield::register("actor", "zm_aat_dead_wire" + "_zap", 1, 1, "int", &zm_aat_dead_wire_zap, 0, 0);
	clientfield::register("vehicle", "zm_aat_dead_wire" + "_zap_vehicle", 1, 1, "int", &zm_aat_dead_wire_zap_vehicle, 0, 0);
	level._effect["zm_aat_dead_wire"] = "zombie/fx_tesla_shock_zmb";
}

/*
	Name: zm_aat_dead_wire_zap
	Namespace: zm_aat_dead_wire
	Checksum: 0xBD3E1B38
	Offset: 0x2C8
	Size: 0xAE
	Parameters: 7
	Flags: Linked
*/
function zm_aat_dead_wire_zap(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.fx_aat_dead_wire_zap = playfxontag(localclientnum, "zombie/fx_tesla_shock_zmb", self, "J_SpineUpper");
	}
	else if(isdefined(self.fx_aat_dead_wire_zap))
	{
		stopfx(localclientnum, self.fx_aat_dead_wire_zap);
		self.fx_aat_dead_wire_zap = undefined;
	}
}

/*
	Name: zm_aat_dead_wire_zap_vehicle
	Namespace: zm_aat_dead_wire
	Checksum: 0x2930A5A2
	Offset: 0x380
	Size: 0xFE
	Parameters: 7
	Flags: Linked
*/
function zm_aat_dead_wire_zap_vehicle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		tag = "tag_body";
		v_tag = self gettagorigin(tag);
		if(!isdefined(v_tag))
		{
			tag = "tag_origin";
		}
		self.fx_aat_dead_wire_zap = playfxontag(localclientnum, "zombie/fx_tesla_shock_zmb", self, tag);
	}
	else if(isdefined(self.fx_aat_dead_wire_zap))
	{
		stopfx(localclientnum, self.fx_aat_dead_wire_zap);
		self.fx_aat_dead_wire_zap = undefined;
	}
}

