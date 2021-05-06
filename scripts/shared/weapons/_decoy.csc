// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace decoy;

/*
	Name: init_shared
	Namespace: decoy
	Checksum: 0x9C1B8C04
	Offset: 0xF8
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level thread level_watch_for_fake_fire();
	callback::add_weapon_type("nightingale", &spawned);
}

/*
	Name: spawned
	Namespace: decoy
	Checksum: 0x32F989BD
	Offset: 0x148
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function spawned(localclientnum)
{
	self thread watch_for_fake_fire(localclientnum);
}

/*
	Name: watch_for_fake_fire
	Namespace: decoy
	Checksum: 0x346133B7
	Offset: 0x178
	Size: 0x60
	Parameters: 1
	Flags: None
*/
function watch_for_fake_fire(localclientnum)
{
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"fake_fire");
		playfxontag(localclientnum, level._effect["decoy_fire"], self, "tag_origin");
	}
}

/*
	Name: level_watch_for_fake_fire
	Namespace: decoy
	Checksum: 0xECBE9D4F
	Offset: 0x1E0
	Size: 0x28
	Parameters: 0
	Flags: None
*/
function level_watch_for_fake_fire()
{
	while(true)
	{
		self waittill(#"fake_fire", origin);
	}
}

