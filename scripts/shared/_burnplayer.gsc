// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace burnplayer;

/*
	Name: __init__sytem__
	Namespace: burnplayer
	Checksum: 0xFDDB2FCD
	Offset: 0x190
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("burnplayer", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: burnplayer
	Checksum: 0x6B2ED257
	Offset: 0x1D0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "burn", 1, 1, "int");
	clientfield::register("playercorpse", "burned_effect", 1, 1, "int");
}

/*
	Name: setplayerburning
	Namespace: burnplayer
	Checksum: 0x580DCDD8
	Offset: 0x240
	Size: 0xDC
	Parameters: 5
	Flags: Linked
*/
function setplayerburning(duration, interval, damageperinterval, attacker, weapon)
{
	self clientfield::set("burn", 1);
	self thread watchburntimer(duration);
	self thread watchburndamage(interval, damageperinterval, attacker, weapon);
	self thread watchforwater();
	self thread watchburnfinished();
	self playloopsound("chr_burn_loop_overlay");
}

/*
	Name: takingburndamage
	Namespace: burnplayer
	Checksum: 0x2A0C6C92
	Offset: 0x328
	Size: 0xAC
	Parameters: 3
	Flags: None
*/
function takingburndamage(eattacker, weapon, smeansofdeath)
{
	if(isdefined(self.doing_scripted_burn_damage))
	{
		self.doing_scripted_burn_damage = undefined;
		return;
	}
	if(weapon == level.weaponnone)
	{
		return;
	}
	if(weapon.burnduration == 0)
	{
		return;
	}
	self setplayerburning(weapon.burnduration / 1000, weapon.burndamageinterval / 1000, weapon.burndamage, eattacker, weapon);
}

/*
	Name: watchburnfinished
	Namespace: burnplayer
	Checksum: 0xA5DF9B0B
	Offset: 0x3E0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function watchburnfinished()
{
	self endon(#"disconnect");
	self util::waittill_any("death", "burn_finished");
	self clientfield::set("burn", 0);
	self stoploopsound(1);
}

/*
	Name: watchburntimer
	Namespace: burnplayer
	Checksum: 0x911E5ABE
	Offset: 0x458
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function watchburntimer(duration)
{
	self notify(#"burnplayer_watchburntimer");
	self endon(#"burnplayer_watchburntimer");
	self endon(#"disconnect");
	self endon(#"death");
	wait(duration);
	self notify(#"burn_finished");
}

/*
	Name: watchburndamage
	Namespace: burnplayer
	Checksum: 0xBEAC297D
	Offset: 0x4B8
	Size: 0xC2
	Parameters: 4
	Flags: Linked
*/
function watchburndamage(interval, damage, attacker, weapon)
{
	if(damage == 0)
	{
		return;
	}
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"burnplayer_watchburntimer");
	self endon(#"burn_finished");
	while(true)
	{
		wait(interval);
		self.doing_scripted_burn_damage = 1;
		self dodamage(damage, self.origin, attacker, undefined, undefined, "MOD_BURNED", 0, weapon);
		self.doing_scripted_burn_damage = undefined;
	}
}

/*
	Name: watchforwater
	Namespace: burnplayer
	Checksum: 0x46395752
	Offset: 0x588
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function watchforwater()
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"burn_finished");
	while(true)
	{
		if(self isplayerunderwater())
		{
			self notify(#"burn_finished");
		}
		wait(0.05);
	}
}

