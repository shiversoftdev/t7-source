// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

#namespace _claymore;

/*
	Name: init
	Namespace: _claymore
	Checksum: 0xE5F27E9E
	Offset: 0xE8
	Size: 0x26
	Parameters: 1
	Flags: None
*/
function init(localclientnum)
{
	level._effect["fx_claymore_laser"] = "_t6/weapon/claymore/fx_claymore_laser";
}

/*
	Name: spawned
	Namespace: _claymore
	Checksum: 0x61696D2D
	Offset: 0x118
	Size: 0xC0
	Parameters: 1
	Flags: None
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

