// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;

#namespace ability_power;

/*
	Name: __init__sytem__
	Namespace: ability_power
	Checksum: 0x46D4B0BD
	Offset: 0x288
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ability_power", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ability_power
	Checksum: 0xCB703D1D
	Offset: 0x2C8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
}

/*
	Name: cpower_print
	Namespace: ability_power
	Checksum: 0x8576C243
	Offset: 0x2F8
	Size: 0x10C
	Parameters: 2
	Flags: Linked
*/
function cpower_print(slot, str)
{
	/#
		color = "";
		toprint = (color + "") + str;
		weaponname = "";
		if(isdefined(self._gadgets_player[slot]))
		{
			weaponname = self._gadgets_player[slot].name;
		}
		if(getdvarint("") > 0)
		{
			self iprintlnbold(toprint);
		}
		else
		{
			println((((self.playername + "") + weaponname) + "") + toprint);
		}
	#/
}

/*
	Name: on_player_connect
	Namespace: ability_power
	Checksum: 0x99EC1590
	Offset: 0x410
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: power_is_hero_ability
	Namespace: ability_power
	Checksum: 0xFA7262E4
	Offset: 0x420
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function power_is_hero_ability(gadget)
{
	return gadget.gadget_type != 0;
}

/*
	Name: is_weapon_or_variant_same_as_gadget
	Namespace: ability_power
	Checksum: 0x80A20107
	Offset: 0x448
	Size: 0x68
	Parameters: 2
	Flags: Linked
*/
function is_weapon_or_variant_same_as_gadget(weapon, gadget)
{
	if(weapon == gadget)
	{
		return true;
	}
	if(isdefined(level.weaponlightninggun) && gadget == level.weaponlightninggun)
	{
		if(isdefined(level.weaponlightninggunarc) && weapon == level.weaponlightninggunarc)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: power_gain_event_score
	Namespace: ability_power
	Checksum: 0xDCED7892
	Offset: 0x4B8
	Size: 0x24E
	Parameters: 4
	Flags: Linked
*/
function power_gain_event_score(eattacker, score, weapon, hero_restricted)
{
	if(score > 0)
	{
		for(slot = 0; slot < 3; slot++)
		{
			gadget = self._gadgets_player[slot];
			if(isdefined(gadget))
			{
				ignoreself = gadget.gadget_powergainscoreignoreself;
				if(isdefined(weapon) && ignoreself && is_weapon_or_variant_same_as_gadget(weapon, gadget))
				{
					continue;
				}
				ignorewhenactive = gadget.gadget_powergainscoreignorewhenactive;
				if(ignorewhenactive && self gadgetisactive(slot))
				{
					continue;
				}
				if(isdefined(hero_restricted) && hero_restricted && power_is_hero_ability(gadget))
				{
					continue;
				}
				scorefactor = gadget.gadget_powergainscorefactor;
				if(isdefined(self.gadgetthiefactive) && self.gadgetthiefactive == 1)
				{
					continue;
				}
				gametypefactor = getgametypesetting("scoreHeroPowerGainFactor");
				perkfactor = 1;
				if(self hasperk("specialty_overcharge"))
				{
					perkfactor = getdvarfloat("gadgetPowerOverchargePerkScoreFactor");
				}
				if(scorefactor > 0 && gametypefactor > 0)
				{
					gaintoadd = ((score * scorefactor) * gametypefactor) * perkfactor;
					self power_gain_event(slot, eattacker, gaintoadd, "score");
				}
			}
		}
	}
}

/*
	Name: power_gain_event_damage_actor
	Namespace: ability_power
	Checksum: 0xCACA1B14
	Offset: 0x710
	Size: 0x8E
	Parameters: 1
	Flags: None
*/
function power_gain_event_damage_actor(eattacker)
{
	basegain = 0;
	if(basegain > 0)
	{
		for(slot = 0; slot < 3; slot++)
		{
			if(isdefined(self._gadgets_player[slot]))
			{
				self power_gain_event(slot, eattacker, basegain, "damaged actor");
			}
		}
	}
}

/*
	Name: power_gain_event_killed_actor
	Namespace: ability_power
	Checksum: 0x3EDEDDCE
	Offset: 0x7A8
	Size: 0x186
	Parameters: 2
	Flags: None
*/
function power_gain_event_killed_actor(eattacker, meansofdeath)
{
	basegain = 5;
	for(slot = 0; slot < 3; slot++)
	{
		if(isdefined(self._gadgets_player[slot]))
		{
			if(meansofdeath == "MOD_MELEE_ASSASSINATE" && self ability_util::gadget_is_camo_suit_on())
			{
				if(self._gadgets_player[slot].gadget_powertakedowngain > 0)
				{
					source = "assassinate actor";
					self power_gain_event(slot, eattacker, self._gadgets_player[slot].gadget_powertakedowngain, source);
				}
			}
			if(self._gadgets_player[slot].gadget_powerreplenishfactor > 0)
			{
				gaintoadd = basegain * self._gadgets_player[slot].gadget_powerreplenishfactor;
				if(gaintoadd > 0)
				{
					source = "killed actor";
					self power_gain_event(slot, eattacker, gaintoadd, source);
				}
			}
		}
	}
}

/*
	Name: power_gain_event
	Namespace: ability_power
	Checksum: 0x637B828A
	Offset: 0x938
	Size: 0xF4
	Parameters: 4
	Flags: Linked
*/
function power_gain_event(slot, eattacker, val, source)
{
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	powertoadd = val;
	if(powertoadd > 0.1 || powertoadd < -0.1)
	{
		powerleft = self gadgetpowerchange(slot, powertoadd);
		/#
			self cpower_print(slot, (((("" + powertoadd) + "") + source) + "") + powerleft);
		#/
	}
}

/*
	Name: power_loss_event_took_damage
	Namespace: ability_power
	Checksum: 0xEF257ACE
	Offset: 0xA38
	Size: 0x196
	Parameters: 5
	Flags: Linked
*/
function power_loss_event_took_damage(eattacker, einflictor, weapon, smeansofdeath, idamage)
{
	baseloss = idamage;
	for(slot = 0; slot < 3; slot++)
	{
		if(isdefined(self._gadgets_player[slot]))
		{
			if(self gadgetisactive(slot))
			{
				powerloss = baseloss * self._gadgets_player[slot].gadget_poweronlossondamage;
				if(powerloss > 0)
				{
					self power_loss_event(slot, eattacker, powerloss, "took damage with power on");
				}
				if(self._gadgets_player[slot].gadget_flickerondamage > 0)
				{
					self ability_gadgets::setflickering(slot, self._gadgets_player[slot].gadget_flickerondamage);
				}
				continue;
			}
			powerloss = baseloss * self._gadgets_player[slot].gadget_powerofflossondamage;
			if(powerloss > 0)
			{
				self power_loss_event(slot, eattacker, powerloss, "took damage");
			}
		}
	}
}

/*
	Name: power_loss_event
	Namespace: ability_power
	Checksum: 0xA4806B6F
	Offset: 0xBD8
	Size: 0xD4
	Parameters: 4
	Flags: Linked
*/
function power_loss_event(slot, eattacker, val, source)
{
	powertoremove = val * -1;
	if(powertoremove > 0.1 || powertoremove < -0.1)
	{
		powerleft = self gadgetpowerchange(slot, powertoremove);
		/#
			self cpower_print(slot, (((("" + powertoremove) + "") + source) + "") + powerleft);
		#/
	}
}

/*
	Name: power_drain_completely
	Namespace: ability_power
	Checksum: 0x3FB9A5D0
	Offset: 0xCB8
	Size: 0x58
	Parameters: 1
	Flags: None
*/
function power_drain_completely(slot)
{
	powerleft = self gadgetpowerchange(slot, 0);
	powerleft = self gadgetpowerchange(slot, powerleft * -1);
}

/*
	Name: ismovingpowerloss
	Namespace: ability_power
	Checksum: 0xA06FE933
	Offset: 0xD18
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function ismovingpowerloss()
{
	velocity = self getvelocity();
	speedsq = lengthsquared(velocity);
	return speedsq > (self._gadgets_player.gadget_powermovespeed * self._gadgets_player.gadget_powermovespeed);
}

/*
	Name: power_consume_timer_think
	Namespace: ability_power
	Checksum: 0x9750AEA3
	Offset: 0xD90
	Size: 0x240
	Parameters: 2
	Flags: Linked
*/
function power_consume_timer_think(slot, weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	time = gettime();
	while(true)
	{
		wait(0.1);
		if(!isdefined(self._gadgets_player[slot]))
		{
			return;
		}
		if(!self gadgetisactive(slot))
		{
			return;
		}
		currenttime = gettime();
		interval = currenttime - time;
		time = currenttime;
		powerconsumpted = 0;
		if(self isonground())
		{
			if(self._gadgets_player[slot].gadget_powersprintloss > 0 && self issprinting())
			{
				powerconsumpted = powerconsumpted + (((1 * interval) / 1000) * self._gadgets_player[slot].gadget_powersprintloss);
			}
			else if(self._gadgets_player[slot].gadget_powermoveloss && self ismovingpowerloss())
			{
				powerconsumpted = powerconsumpted + (((1 * interval) / 1000) * self._gadgets_player[slot].gadget_powermoveloss);
			}
		}
		if(powerconsumpted > 0.1)
		{
			self power_loss_event(slot, self, powerconsumpted, "consume");
			if(self._gadgets_player[slot].gadget_flickeronpowerloss > 0)
			{
				self ability_gadgets::setflickering(slot, self._gadgets_player[slot].gadget_flickeronpowerloss);
			}
		}
	}
}

