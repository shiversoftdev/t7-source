// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;

#namespace shellshock;

/*
	Name: __init__sytem__
	Namespace: shellshock
	Checksum: 0x4A66FD99
	Offset: 0x190
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("shellshock", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: shellshock
	Checksum: 0x678FD677
	Offset: 0x1D0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&main);
	level.shellshockonplayerdamage = &on_damage;
}

/*
	Name: main
	Namespace: shellshock
	Checksum: 0x99EC1590
	Offset: 0x218
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function main()
{
}

/*
	Name: on_damage
	Namespace: shellshock
	Checksum: 0x11E3D09B
	Offset: 0x228
	Size: 0x12C
	Parameters: 3
	Flags: Linked
*/
function on_damage(cause, damage, weapon)
{
	if(cause == "MOD_EXPLOSIVE" || cause == "MOD_GRENADE" || cause == "MOD_GRENADE_SPLASH" || cause == "MOD_PROJECTILE" || cause == "MOD_PROJECTILE_SPLASH")
	{
		time = 0;
		if(damage >= 90)
		{
			time = 4;
		}
		else
		{
			if(damage >= 50)
			{
				time = 3;
			}
			else
			{
				if(damage >= 25)
				{
					time = 2;
				}
				else if(damage > 10)
				{
					time = 2;
				}
			}
		}
		if(time)
		{
			if(self util::mayapplyscreeneffect())
			{
				self shellshock("frag_grenade_mp", 0.5);
			}
		}
	}
}

/*
	Name: endondeath
	Namespace: shellshock
	Checksum: 0xC743EBEF
	Offset: 0x360
	Size: 0x1E
	Parameters: 0
	Flags: None
*/
function endondeath()
{
	self waittill(#"death");
	waittillframeend();
	self notify(#"end_explode");
}

/*
	Name: endontimer
	Namespace: shellshock
	Checksum: 0xD63B1C15
	Offset: 0x388
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function endontimer(timer)
{
	self endon(#"disconnect");
	wait(timer);
	self notify(#"end_on_timer");
}

/*
	Name: rcbomb_earthquake
	Namespace: shellshock
	Checksum: 0x3982C13D
	Offset: 0x3C0
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function rcbomb_earthquake(position)
{
	playrumbleonposition("grenade_rumble", position);
	earthquake(0.5, 0.5, self.origin, 512);
}

