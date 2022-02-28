// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace shellshock;

/*
	Name: __init__sytem__
	Namespace: shellshock
	Checksum: 0x6B716A28
	Offset: 0x1D0
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
	Checksum: 0x4C9508AD
	Offset: 0x210
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	level.shellshockonplayerdamage = &on_damage;
}

/*
	Name: init
	Namespace: shellshock
	Checksum: 0x99EC1590
	Offset: 0x258
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: on_damage
	Namespace: shellshock
	Checksum: 0x68B3C5A9
	Offset: 0x268
	Size: 0x1AC
	Parameters: 3
	Flags: Linked
*/
function on_damage(cause, damage, weapon)
{
	if(self util::isflashbanged())
	{
		return;
	}
	if(self.health <= 0)
	{
		self clientfield::set_to_player("sndMelee", 0);
	}
	if(cause == "MOD_EXPLOSIVE" || cause == "MOD_GRENADE" || cause == "MOD_GRENADE_SPLASH" || cause == "MOD_PROJECTILE" || cause == "MOD_PROJECTILE_SPLASH")
	{
		if(weapon.explosionradius == 0)
		{
			return;
		}
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
			if(self util::mayapplyscreeneffect() && self hasperk("specialty_flakjacket") == 0)
			{
				self shellshock("frag_grenade_mp", 0.5);
			}
		}
	}
}

/*
	Name: end_on_death
	Namespace: shellshock
	Checksum: 0x2EF22436
	Offset: 0x420
	Size: 0x1E
	Parameters: 0
	Flags: None
*/
function end_on_death()
{
	self waittill(#"death");
	waittillframeend();
	self notify(#"end_explode");
}

/*
	Name: end_on_timer
	Namespace: shellshock
	Checksum: 0xB8035DC8
	Offset: 0x448
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function end_on_timer(timer)
{
	self endon(#"disconnect");
	wait(timer);
	self notify(#"end_on_timer");
}

/*
	Name: rcbomb_earthquake
	Namespace: shellshock
	Checksum: 0x18D4F868
	Offset: 0x480
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function rcbomb_earthquake(position)
{
	playrumbleonposition("grenade_rumble", position);
	earthquake(0.5, 0.5, self.origin, 512);
}

/*
	Name: reset_meleesnd
	Namespace: shellshock
	Checksum: 0x98F6327F
	Offset: 0x4E8
	Size: 0x42
	Parameters: 0
	Flags: None
*/
function reset_meleesnd()
{
	self endon(#"death");
	wait(6);
	self clientfield::set_to_player("sndMelee", 0);
	self notify(#"snd_melee_end");
}

