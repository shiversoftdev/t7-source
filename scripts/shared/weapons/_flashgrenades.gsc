// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace flashgrenades;

/*
	Name: init_shared
	Namespace: flashgrenades
	Checksum: 0xD8FAFA1F
	Offset: 0x180
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.sound_flash_start = "";
	level.sound_flash_loop = "";
	level.sound_flash_stop = "";
	callback::on_connect(&monitorflash);
}

/*
	Name: flashrumbleloop
	Namespace: flashgrenades
	Checksum: 0xFF5C74E
	Offset: 0x1E0
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function flashrumbleloop(duration)
{
	self endon(#"stop_monitoring_flash");
	self endon(#"flash_rumble_loop");
	self notify(#"flash_rumble_loop");
	goaltime = gettime() + (duration * 1000);
	while(gettime() < goaltime)
	{
		self playrumbleonentity("damage_heavy");
		wait(0.05);
	}
}

/*
	Name: monitorflash_internal
	Namespace: flashgrenades
	Checksum: 0xEFAB220D
	Offset: 0x268
	Size: 0x3E4
	Parameters: 4
	Flags: Linked
*/
function monitorflash_internal(amount_distance, amount_angle, attacker, direct_on_player)
{
	hurtattacker = 0;
	hurtvictim = 1;
	duration = amount_distance * 3.5;
	min_duration = 2.5;
	max_self_duration = 2.5;
	if(duration < min_duration)
	{
		duration = min_duration;
	}
	if(isdefined(attacker) && attacker == self)
	{
		duration = duration / 3;
	}
	if(duration < 0.25)
	{
		return;
	}
	rumbleduration = undefined;
	if(duration > 2)
	{
		rumbleduration = 0.75;
	}
	else
	{
		rumbleduration = 0.25;
	}
	/#
		assert(isdefined(self.team));
	#/
	if(level.teambased && isdefined(attacker) && isdefined(attacker.team) && attacker.team == self.team && attacker != self)
	{
		friendlyfire = [[level.figure_out_friendly_fire]](self);
		if(friendlyfire == 0)
		{
			return;
		}
		if(friendlyfire == 1)
		{
		}
		else
		{
			if(friendlyfire == 2)
			{
				duration = duration * 0.5;
				rumbleduration = rumbleduration * 0.5;
				hurtvictim = 0;
				hurtattacker = 1;
			}
			else if(friendlyfire == 3)
			{
				duration = duration * 0.5;
				rumbleduration = rumbleduration * 0.5;
				hurtattacker = 1;
			}
		}
	}
	if(self hasperk("specialty_flashprotection"))
	{
		duration = duration * 0.1;
		rumbleduration = rumbleduration * 0.1;
	}
	if(hurtvictim)
	{
		if(self util::mayapplyscreeneffect() || (!direct_on_player && self isremotecontrolling()))
		{
			if(isdefined(attacker) && self != attacker && isplayer(attacker))
			{
				attacker addweaponstat(getweapon("flash_grenade"), "hits", 1);
				attacker addweaponstat(getweapon("flash_grenade"), "used", 1);
			}
			self thread applyflash(duration, rumbleduration, attacker);
		}
	}
	if(hurtattacker)
	{
		if(attacker util::mayapplyscreeneffect())
		{
			attacker thread applyflash(duration, rumbleduration, attacker);
		}
	}
}

/*
	Name: monitorflash
	Namespace: flashgrenades
	Checksum: 0x2F99D114
	Offset: 0x658
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function monitorflash()
{
	self endon(#"disconnect");
	self endon(#"killflashmonitor");
	self.flashendtime = 0;
	while(true)
	{
		self waittill(#"flashbang", amount_distance, amount_angle, attacker);
		if(!isalive(self))
		{
			continue;
		}
		self monitorflash_internal(amount_distance, amount_angle, attacker, 1);
	}
}

/*
	Name: monitorrcbombflash
	Namespace: flashgrenades
	Checksum: 0xF4FE401A
	Offset: 0x700
	Size: 0xC8
	Parameters: 0
	Flags: None
*/
function monitorrcbombflash()
{
	self endon(#"death");
	self.flashendtime = 0;
	while(true)
	{
		self waittill(#"flashbang", amount_distance, amount_angle, attacker);
		driver = self getseatoccupant(0);
		if(!isdefined(driver) || !isalive(driver))
		{
			continue;
		}
		driver monitorflash_internal(amount_distance, amount_angle, attacker, 0);
	}
}

/*
	Name: applyflash
	Namespace: flashgrenades
	Checksum: 0x5E910E82
	Offset: 0x7D0
	Size: 0x14E
	Parameters: 3
	Flags: Linked
*/
function applyflash(duration, rumbleduration, attacker)
{
	if(!isdefined(self.flashduration) || duration > self.flashduration)
	{
		self.flashduration = duration;
	}
	if(!isdefined(self.flashrumbleduration) || rumbleduration > self.flashrumbleduration)
	{
		self.flashrumbleduration = rumbleduration;
	}
	self thread playflashsound(duration);
	wait(0.05);
	if(isdefined(self.flashduration))
	{
		if(self hasperk("specialty_flashprotection") == 0)
		{
			self shellshock("flashbang", self.flashduration, 0);
		}
		self.flashendtime = gettime() + (self.flashduration * 1000);
		self.lastflashedby = attacker;
	}
	if(isdefined(self.flashrumbleduration))
	{
		self thread flashrumbleloop(self.flashrumbleduration);
	}
	self.flashduration = undefined;
	self.flashrumbleduration = undefined;
}

/*
	Name: playflashsound
	Namespace: flashgrenades
	Checksum: 0xB469A9EE
	Offset: 0x928
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function playflashsound(duration)
{
	self endon(#"death");
	self endon(#"disconnect");
	flashsound = spawn("script_origin", (0, 0, 1));
	flashsound.origin = self.origin;
	flashsound linkto(self);
	flashsound thread deleteentonownerdeath(self);
	flashsound playsound(level.sound_flash_start);
	flashsound playloopsound(level.sound_flash_loop);
	if(duration > 0.5)
	{
		wait(duration - 0.5);
	}
	flashsound playsound(level.sound_flash_start);
	flashsound stoploopsound(0.5);
	wait(0.5);
	flashsound notify(#"delete");
	flashsound delete();
}

/*
	Name: deleteentonownerdeath
	Namespace: flashgrenades
	Checksum: 0x4D8194B
	Offset: 0xA88
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function deleteentonownerdeath(owner)
{
	self endon(#"delete");
	owner waittill(#"death");
	self delete();
}

