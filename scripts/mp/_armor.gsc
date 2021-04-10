// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace armor;

/*
	Name: setlightarmorhp
	Namespace: armor
	Checksum: 0xC4148B87
	Offset: 0x148
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function setlightarmorhp(newvalue)
{
	if(isdefined(newvalue))
	{
		self.lightarmorhp = newvalue;
		if(isplayer(self) && isdefined(self.maxlightarmorhp) && self.maxlightarmorhp > 0)
		{
			lightarmorpercent = math::clamp(self.lightarmorhp / self.maxlightarmorhp, 0, 1);
			self setcontrolleruimodelvalue("hudItems.armorPercent", lightarmorpercent);
		}
	}
	else
	{
		self.lightarmorhp = undefined;
		self.maxlightarmorhp = undefined;
		self setcontrolleruimodelvalue("hudItems.armorPercent", 0);
	}
}

/*
	Name: setlightarmor
	Namespace: armor
	Checksum: 0x8C781C9F
	Offset: 0x240
	Size: 0xB4
	Parameters: 1
	Flags: None
*/
function setlightarmor(optionalarmorvalue)
{
	self notify(#"give_light_armor");
	if(isdefined(self.lightarmorhp))
	{
		unsetlightarmor();
	}
	self thread removelightarmorondeath();
	self thread removelightarmoronmatchend();
	if(isdefined(optionalarmorvalue))
	{
		self.maxlightarmorhp = optionalarmorvalue;
	}
	else
	{
		self.maxlightarmorhp = 150;
	}
	self setlightarmorhp(self.maxlightarmorhp);
}

/*
	Name: removelightarmorondeath
	Namespace: armor
	Checksum: 0xBA7EC9F2
	Offset: 0x300
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function removelightarmorondeath()
{
	self endon(#"disconnect");
	self endon(#"give_light_armor");
	self endon(#"remove_light_armor");
	self waittill(#"death");
	unsetlightarmor();
}

/*
	Name: unsetlightarmor
	Namespace: armor
	Checksum: 0x602433BD
	Offset: 0x350
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function unsetlightarmor()
{
	self setlightarmorhp(undefined);
	self notify(#"remove_light_armor");
}

/*
	Name: removelightarmoronmatchend
	Namespace: armor
	Checksum: 0x2BF70C92
	Offset: 0x388
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function removelightarmoronmatchend()
{
	self endon(#"disconnect");
	self endon(#"remove_light_armor");
	level waittill(#"game_ended");
	self thread unsetlightarmor();
}

/*
	Name: haslightarmor
	Namespace: armor
	Checksum: 0x62D02B25
	Offset: 0x3D0
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function haslightarmor()
{
	return isdefined(self.lightarmorhp) && self.lightarmorhp > 0;
}

/*
	Name: getarmor
	Namespace: armor
	Checksum: 0x5530D2F0
	Offset: 0x3F8
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function getarmor()
{
	if(isdefined(self.lightarmorhp))
	{
		return self.lightarmorhp;
	}
	return 0;
}

