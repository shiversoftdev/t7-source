// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;

#namespace explosive_bolt;

/*
	Name: __init__sytem__
	Namespace: explosive_bolt
	Checksum: 0xC651F55F
	Offset: 0x140
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("explosive_bolt", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: explosive_bolt
	Checksum: 0xF806A4A7
	Offset: 0x180
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: explosive_bolt
	Checksum: 0xEC314C6C
	Offset: 0x1B0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread begin_other_grenade_tracking();
}

/*
	Name: begin_other_grenade_tracking
	Namespace: explosive_bolt
	Checksum: 0x355C3886
	Offset: 0x1D8
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function begin_other_grenade_tracking()
{
	self endon(#"death");
	self endon(#"disconnect");
	self notify(#"bolttrackingstart");
	self endon(#"bolttrackingstart");
	weapon_bolt = getweapon("explosive_bolt");
	for(;;)
	{
		self waittill(#"grenade_fire", grenade, weapon, cooktime);
		if(grenade util::ishacked())
		{
			continue;
		}
		if(weapon == weapon_bolt)
		{
			grenade.ownerweaponatlaunch = self.currentweapon;
			grenade.owneradsatlaunch = (self playerads() == 1 ? 1 : 0);
			grenade thread watch_bolt_detonation(self);
			grenade thread weapons::check_stuck_to_player(1, 0, weapon);
		}
	}
}

/*
	Name: watch_bolt_detonation
	Namespace: explosive_bolt
	Checksum: 0xCB036AF0
	Offset: 0x318
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function watch_bolt_detonation(owner)
{
}

