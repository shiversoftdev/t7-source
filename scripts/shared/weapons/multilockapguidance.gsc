// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace multilockap_guidance;

/*
	Name: __init__sytem__
	Namespace: multilockap_guidance
	Checksum: 0xCA70156D
	Offset: 0x230
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("multilockap_guidance", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: multilockap_guidance
	Checksum: 0x2A44ABA0
	Offset: 0x270
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_spawned(&on_player_spawned);
	setdvar("scr_max_simLocks", 3);
}

/*
	Name: on_player_spawned
	Namespace: multilockap_guidance
	Checksum: 0xAA6F7EBE
	Offset: 0x2C0
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function on_player_spawned()
{
	self endon(#"disconnect");
	self clearaptarget();
	thread aptoggleloop();
	self thread apfirednotify();
}

/*
	Name: clearaptarget
	Namespace: multilockap_guidance
	Checksum: 0xBAB8300C
	Offset: 0x318
	Size: 0x27C
	Parameters: 2
	Flags: None
*/
function clearaptarget(weapon, whom)
{
	if(!isdefined(self.multilocklist))
	{
		self.multilocklist = [];
	}
	if(isdefined(whom))
	{
		for(i = 0; i < self.multilocklist.size; i++)
		{
			if(whom.aptarget == self.multilocklist[i].aptarget)
			{
				if(isdefined(self.multilocklist[i].aptarget))
				{
					self.multilocklist[i].aptarget notify(#"missile_unlocked");
				}
				self notify("stop_sound" + whom.apsoundid);
				self weaponlockremoveslot(i);
				arrayremovevalue(self.multilocklist, whom, 0);
				break;
			}
		}
	}
	else
	{
		for(i = 0; i < self.multilocklist.size; i++)
		{
			self.multilocklist[i].aptarget notify(#"missile_unlocked");
			self notify("stop_sound" + self.multilocklist[i].apsoundid);
		}
		self.multilocklist = [];
	}
	if(self.multilocklist.size == 0)
	{
		self stoprumble("stinger_lock_rumble");
		self weaponlockremoveslot(-1);
		if(isdefined(weapon))
		{
			if(isdefined(weapon.lockonseekersearchsound))
			{
				self stoplocalsound(weapon.lockonseekersearchsound);
			}
			if(isdefined(weapon.lockonseekerlockedsound))
			{
				self stoplocalsound(weapon.lockonseekerlockedsound);
			}
		}
		self destroylockoncanceledmessage();
	}
}

/*
	Name: apfirednotify
	Namespace: multilockap_guidance
	Checksum: 0x5071D4FB
	Offset: 0x5A0
	Size: 0x11E
	Parameters: 0
	Flags: None
*/
function apfirednotify()
{
	self endon(#"disconnect");
	self endon(#"death");
	while(true)
	{
		self waittill(#"missile_fire", missile, weapon);
		if(weapon.lockontype == "AP Multi")
		{
			foreach(target in self.multilocklist)
			{
				if(isdefined(target.aptarget) && target.aplockfinalized)
				{
					target.aptarget notify(#"stinger_fired_at_me", missile, weapon, self);
				}
			}
		}
	}
}

/*
	Name: aptoggleloop
	Namespace: multilockap_guidance
	Checksum: 0xD5937D3
	Offset: 0x6C8
	Size: 0x178
	Parameters: 0
	Flags: None
*/
function aptoggleloop()
{
	self endon(#"disconnect");
	self endon(#"death");
	for(;;)
	{
		self waittill(#"weapon_change", weapon);
		while(weapon.lockontype == "AP Multi")
		{
			abort = 0;
			while(!self playerads() == 1)
			{
				wait(0.05);
				currentweapon = self getcurrentweapon();
				if(currentweapon.lockontype != "AP Multi")
				{
					abort = 1;
					break;
				}
			}
			if(abort)
			{
				break;
			}
			self thread aplockloop(weapon);
			while(self playerads() == 1)
			{
				wait(0.05);
			}
			self notify(#"ap_off");
			self clearaptarget(weapon);
			weapon = self getcurrentweapon();
		}
	}
}

/*
	Name: aplockloop
	Namespace: multilockap_guidance
	Checksum: 0x293136A1
	Offset: 0x848
	Size: 0x5B6
	Parameters: 1
	Flags: None
*/
function aplockloop(weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"ap_off");
	locklength = self getlockonspeed();
	self.multilocklist = [];
	for(;;)
	{
		wait(0.05);
		do
		{
			done = 1;
			foreach(target in self.multilocklist)
			{
				if(target.aplockfinalized)
				{
					if(!isstillvalidtarget(weapon, target.aptarget))
					{
						self clearaptarget(weapon, target);
						done = 0;
						break;
					}
				}
			}
		}
		while(!done);
		inlockingstate = 0;
		do
		{
			done = 1;
			for(i = 0; i < self.multilocklist.size; i++)
			{
				target = self.multilocklist[i];
				if(target.aplocking)
				{
					if(!isstillvalidtarget(weapon, target.aptarget))
					{
						self clearaptarget(weapon, target);
						done = 0;
						break;
					}
					inlockingstate = 1;
					timepassed = gettime() - target.aplockstarttime;
					if(timepassed < locklength)
					{
						continue;
					}
					/#
						assert(isdefined(target.aptarget));
					#/
					target.aplockfinalized = 1;
					target.aplocking = 0;
					target.aplockpending = 0;
					self weaponlockfinalize(target.aptarget, i);
					self thread seekersound(weapon.lockonseekerlockedsound, weapon.lockonseekerlockedsoundloops, target.apsoundid);
					target.aptarget notify(#"missile_lock", self, weapon);
				}
			}
		}
		while(!done);
		if(!inlockingstate)
		{
			do
			{
				done = 1;
				for(i = 0; i < self.multilocklist.size; i++)
				{
					target = self.multilocklist[i];
					if(target.aplockpending)
					{
						if(!isstillvalidtarget(weapon, target.aptarget))
						{
							self clearaptarget(weapon, target);
							done = 0;
							break;
						}
						target.aplockstarttime = gettime();
						target.aplockfinalized = 0;
						target.aplockpending = 0;
						target.aplocking = 1;
						self thread seekersound(weapon.lockonseekersearchsound, weapon.lockonseekersearchsoundloops, target.apsoundid);
						done = 1;
						break;
					}
				}
			}
			while(!done);
		}
		if(self.multilocklist.size >= getdvarint("scr_max_simLocks") || self.multilocklist.size >= self getweaponammoclip(weapon))
		{
			continue;
		}
		besttarget = self getbesttarget(weapon);
		if(!isdefined(besttarget) && self.multilocklist.size == 0)
		{
			self destroylockoncanceledmessage();
			continue;
		}
		if(isdefined(besttarget) && self.multilocklist.size < getdvarint("scr_max_simLocks") && self.multilocklist.size < self getweaponammoclip(weapon))
		{
			self weaponlockstart(besttarget.aptarget, self.multilocklist.size);
			self.multilocklist[self.multilocklist.size] = besttarget;
		}
	}
}

/*
	Name: destroylockoncanceledmessage
	Namespace: multilockap_guidance
	Checksum: 0x73D61FBC
	Offset: 0xE08
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function destroylockoncanceledmessage()
{
	if(isdefined(self.lockoncanceledmessage))
	{
		self.lockoncanceledmessage destroy();
	}
}

/*
	Name: displaylockoncanceledmessage
	Namespace: multilockap_guidance
	Checksum: 0x61279067
	Offset: 0xE40
	Size: 0x154
	Parameters: 0
	Flags: None
*/
function displaylockoncanceledmessage()
{
	if(isdefined(self.lockoncanceledmessage))
	{
		return;
	}
	self.lockoncanceledmessage = newclienthudelem(self);
	self.lockoncanceledmessage.fontscale = 1.25;
	self.lockoncanceledmessage.x = 0;
	self.lockoncanceledmessage.y = 50;
	self.lockoncanceledmessage.alignx = "center";
	self.lockoncanceledmessage.aligny = "top";
	self.lockoncanceledmessage.horzalign = "center";
	self.lockoncanceledmessage.vertalign = "top";
	self.lockoncanceledmessage.foreground = 1;
	self.lockoncanceledmessage.hidewhendead = 0;
	self.lockoncanceledmessage.hidewheninmenu = 1;
	self.lockoncanceledmessage.archived = 0;
	self.lockoncanceledmessage.alpha = 1;
	self.lockoncanceledmessage settext(&"MP_CANNOT_LOCKON_TO_TARGET");
}

/*
	Name: getbesttarget
	Namespace: multilockap_guidance
	Checksum: 0xAF268941
	Offset: 0xFA0
	Size: 0x53E
	Parameters: 1
	Flags: None
*/
function getbesttarget(weapon)
{
	playertargets = getplayers();
	vehicletargets = target_getarray();
	targetsall = getaiteamarray();
	targetsall = arraycombine(targetsall, playertargets, 0, 0);
	targetsall = arraycombine(targetsall, vehicletargets, 0, 0);
	targetsvalid = [];
	for(idx = 0; idx < targetsall.size; idx++)
	{
		if(level.teambased)
		{
			if(isdefined(targetsall[idx].team) && targetsall[idx].team != self.team)
			{
				if(self insideapreticlenolock(targetsall[idx]))
				{
					if(self locksighttest(targetsall[idx]))
					{
						targetsvalid[targetsvalid.size] = targetsall[idx];
					}
				}
			}
			continue;
		}
		if(self insideapreticlenolock(targetsall[idx]))
		{
			if(isdefined(targetsall[idx].owner) && self != targetsall[idx].owner)
			{
				if(self locksighttest(targetsall[idx]))
				{
					targetsvalid[targetsvalid.size] = targetsall[idx];
				}
			}
		}
	}
	if(targetsvalid.size == 0)
	{
		return undefined;
	}
	playerforward = anglestoforward(self getplayerangles());
	dots = [];
	for(i = 0; i < targetsvalid.size; i++)
	{
		newitem = spawnstruct();
		newitem.index = i;
		newitem.dot = vectordot(playerforward, vectornormalize(targetsvalid[i].origin - self.origin));
		array::insertion_sort(dots, &targetinsertionsortcompare, newitem);
	}
	index = 0;
	foreach(dot in dots)
	{
		found = 0;
		foreach(lock in self.multilocklist)
		{
			if(lock.aptarget == targetsvalid[dot.index])
			{
				found = 1;
			}
		}
		if(found)
		{
			continue;
		}
		newentry = spawnstruct();
		newentry.aptarget = targetsvalid[dot.index];
		newentry.aplockstarttime = gettime();
		newentry.aplockpending = 1;
		newentry.aplocking = 0;
		newentry.aplockfinalized = 0;
		newentry.aplostsightlinetime = 0;
		newentry.apsoundid = randomint(2147483647);
		return newentry;
	}
	return undefined;
}

/*
	Name: targetinsertionsortcompare
	Namespace: multilockap_guidance
	Checksum: 0xE4A4B175
	Offset: 0x14E8
	Size: 0x60
	Parameters: 2
	Flags: None
*/
function targetinsertionsortcompare(a, b)
{
	if(a.dot < b.dot)
	{
		return -1;
	}
	if(a.dot > b.dot)
	{
		return 1;
	}
	return 0;
}

/*
	Name: insideapreticlenolock
	Namespace: multilockap_guidance
	Checksum: 0x5B2AD39B
	Offset: 0x1550
	Size: 0x52
	Parameters: 1
	Flags: None
*/
function insideapreticlenolock(target)
{
	radius = self getlockonradius();
	return target_isincircle(target, self, 65, radius);
}

/*
	Name: insideapreticlelocked
	Namespace: multilockap_guidance
	Checksum: 0xAEC77ABA
	Offset: 0x15B0
	Size: 0x52
	Parameters: 1
	Flags: None
*/
function insideapreticlelocked(target)
{
	radius = self getlockonlossradius();
	return target_isincircle(target, self, 65, radius);
}

/*
	Name: isstillvalidtarget
	Namespace: multilockap_guidance
	Checksum: 0xEC082C7B
	Offset: 0x1610
	Size: 0x86
	Parameters: 2
	Flags: None
*/
function isstillvalidtarget(weapon, ent)
{
	if(!isdefined(ent))
	{
		return false;
	}
	if(!insideapreticlelocked(ent))
	{
		return false;
	}
	if(!isalive(ent))
	{
		return false;
	}
	if(!locksighttest(ent))
	{
		return false;
	}
	return true;
}

/*
	Name: seekersound
	Namespace: multilockap_guidance
	Checksum: 0x99F29F6B
	Offset: 0x16A0
	Size: 0xEC
	Parameters: 3
	Flags: None
*/
function seekersound(alias, looping, id)
{
	self notify("stop_sound" + id);
	self endon("stop_sound" + id);
	self endon(#"disconnect");
	self endon(#"death");
	if(isdefined(alias))
	{
		self playrumbleonentity("stinger_lock_rumble");
		time = soundgetplaybacktime(alias) * 0.001;
		do
		{
			self playlocalsound(alias);
			wait(time);
		}
		while(looping);
		self stoprumble("stinger_lock_rumble");
	}
}

/*
	Name: locksighttest
	Namespace: multilockap_guidance
	Checksum: 0x853466A8
	Offset: 0x1798
	Size: 0x180
	Parameters: 1
	Flags: None
*/
function locksighttest(target)
{
	eyepos = self geteye();
	if(!isdefined(target))
	{
		return false;
	}
	if(!isalive(target))
	{
		return false;
	}
	pos = target getshootatpos();
	if(isdefined(pos))
	{
		passed = bullettracepassed(eyepos, pos, 0, target, undefined, 1, 1);
		if(passed)
		{
			return true;
		}
	}
	pos = target getcentroid();
	if(isdefined(pos))
	{
		passed = bullettracepassed(eyepos, pos, 0, target, undefined, 1, 1);
		if(passed)
		{
			return true;
		}
	}
	pos = target.origin;
	passed = bullettracepassed(eyepos, pos, 0, target, undefined, 1, 1);
	if(passed)
	{
		return true;
	}
	return false;
}

