// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace claymore;

/*
	Name: __init__sytem__
	Namespace: claymore
	Checksum: 0x15CB0E3C
	Offset: 0x150
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("claymore", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: claymore
	Checksum: 0xBBFE6F3F
	Offset: 0x190
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function __init__(localclientnum)
{
	level._effect["fx_claymore_laser"] = "_t6/weapon/claymore/fx_claymore_laser";
	callback::add_weapon_type("claymore", &spawned);
}

/*
	Name: spawned
	Namespace: claymore
	Checksum: 0xE5F36BDA
	Offset: 0x1E8
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function spawned(localclientnum)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	while(true)
	{
		if(isdefined(self.stunned) && self.stunned)
		{
			wait(0.1);
			continue;
		}
		self.claymorelaserfxid = playfxontag(localclientnum, level._effect["fx_claymore_laser"], self, "tag_fx");
		self waittill(#"stunned");
		stopfx(localclientnum, self.claymorelaserfxid);
	}
}

