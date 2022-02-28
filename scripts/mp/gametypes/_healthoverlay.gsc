// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\gametypes\_globallogic_player;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace healthoverlay;

/*
	Name: __init__sytem__
	Namespace: healthoverlay
	Checksum: 0x7FDA6DE4
	Offset: 0x180
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("healthoverlay", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: healthoverlay
	Checksum: 0xA5BCC2EE
	Offset: 0x1C0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_joined_team(&end_health_regen);
	callback::on_joined_spectate(&end_health_regen);
	callback::on_spawned(&player_health_regen);
	callback::on_disconnect(&end_health_regen);
	callback::on_player_killed(&end_health_regen);
	level.start_player_health_regen = &player_health_regen;
}

/*
	Name: init
	Namespace: healthoverlay
	Checksum: 0x753D1A33
	Offset: 0x2A8
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.healthoverlaycutoff = 0.55;
	regentime = level.playerhealthregentime;
	level.playerhealth_regularregendelay = regentime * 1000;
	level.healthregendisabled = level.playerhealth_regularregendelay <= 0;
}

/*
	Name: end_health_regen
	Namespace: healthoverlay
	Checksum: 0x23849C3
	Offset: 0x300
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function end_health_regen()
{
	self notify(#"end_healthregen");
}

/*
	Name: player_health_regen
	Namespace: healthoverlay
	Checksum: 0xE47586D5
	Offset: 0x320
	Size: 0x554
	Parameters: 0
	Flags: Linked
*/
function player_health_regen()
{
	self endon(#"end_healthregen");
	if(self.health <= 0)
	{
		/#
			assert(!isalive(self));
		#/
		return;
	}
	maxhealth = self.health;
	oldhealth = maxhealth;
	player = self;
	health_add = 0;
	regenrate = 0.1;
	usetrueregen = 0;
	veryhurt = 0;
	player.breathingstoptime = -10000;
	thread player_breathing_sound(maxhealth * 0.35);
	thread player_heartbeat_sound(maxhealth * 0.35);
	lastsoundtime_recover = 0;
	hurttime = 0;
	newhealth = 0;
	for(;;)
	{
		wait(0.05);
		if(isdefined(self.healthregendisabled) && self.healthregendisabled)
		{
			continue;
		}
		if(isdefined(player.regenrate))
		{
			regenrate = player.regenrate;
			usetrueregen = 1;
		}
		if(player.health == maxhealth)
		{
			veryhurt = 0;
			if(isdefined(self.atbrinkofdeath) && self.atbrinkofdeath == 1)
			{
				self notify(#"challenge_survived_from_death");
			}
			self.atbrinkofdeath = 0;
			continue;
		}
		if(player.health <= 0)
		{
			return;
		}
		if(isdefined(player.laststand) && player.laststand)
		{
			continue;
		}
		wasveryhurt = veryhurt;
		ratio = player.health / maxhealth;
		if(ratio <= level.healthoverlaycutoff)
		{
			veryhurt = 1;
			self.atbrinkofdeath = 1;
			self.isneardeath = 1;
			if(!wasveryhurt)
			{
				hurttime = gettime();
			}
		}
		else
		{
			self.isneardeath = 0;
		}
		if(player.health >= oldhealth)
		{
			regentime = level.playerhealth_regularregendelay;
			if(player hasperk("specialty_healthregen"))
			{
				regentime = int(regentime / getdvarfloat("perk_healthRegenMultiplier"));
			}
			if((gettime() - hurttime) < regentime)
			{
				continue;
			}
			if(level.healthregendisabled)
			{
				continue;
			}
			if((gettime() - lastsoundtime_recover) > regentime)
			{
				lastsoundtime_recover = gettime();
				self notify(#"snd_breathing_better");
			}
			if(veryhurt)
			{
				newhealth = ratio;
				veryhurttime = 3000;
				if(player hasperk("specialty_healthregen"))
				{
					veryhurttime = int(veryhurttime / getdvarfloat("perk_healthRegenMultiplier"));
				}
				if(gettime() > (hurttime + veryhurttime))
				{
					newhealth = newhealth + regenrate;
				}
			}
			else
			{
				if(usetrueregen)
				{
					newhealth = ratio + regenrate;
				}
				else
				{
					newhealth = 1;
				}
			}
			if(newhealth >= 1)
			{
				self globallogic_player::resetattackerlist();
				newhealth = 1;
			}
			if(newhealth <= 0)
			{
				return;
			}
			player setnormalhealth(newhealth);
			change = player.health - oldhealth;
			if(change > 0)
			{
				player decay_player_damages(change);
			}
			oldhealth = player.health;
			continue;
		}
		oldhealth = player.health;
		health_add = 0;
		hurttime = gettime();
		player.breathingstoptime = hurttime + 6000;
	}
}

/*
	Name: decay_player_damages
	Namespace: healthoverlay
	Checksum: 0xCCA4F381
	Offset: 0x880
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function decay_player_damages(decay)
{
	if(!isdefined(self.attackerdamage))
	{
		return;
	}
	for(i = 0; i < self.attackerdamage.size; i++)
	{
		if(!isdefined(self.attackerdamage[i]) || !isdefined(self.attackerdamage[i].damage))
		{
			continue;
		}
		self.attackerdamage[i].damage = self.attackerdamage[i].damage - decay;
		if(self.attackerdamage[i].damage < 0)
		{
			self.attackerdamage[i].damage = 0;
		}
	}
}

/*
	Name: player_breathing_sound
	Namespace: healthoverlay
	Checksum: 0xF1256A44
	Offset: 0x978
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function player_breathing_sound(healthcap)
{
	self endon(#"end_healthregen");
	wait(2);
	player = self;
	for(;;)
	{
		wait(0.2);
		if(player.health <= 0)
		{
			return;
		}
		if(player util::isusingremote())
		{
			continue;
		}
		if(player.health >= healthcap)
		{
			continue;
		}
		if(level.healthregendisabled && gettime() > player.breathingstoptime)
		{
			continue;
		}
		player notify(#"snd_breathing_hurt");
		wait(0.784);
		wait(0.1 + randomfloat(0.8));
	}
}

/*
	Name: player_heartbeat_sound
	Namespace: healthoverlay
	Checksum: 0x51DACD77
	Offset: 0xA68
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function player_heartbeat_sound(healthcap)
{
	self endon(#"end_healthregen");
	self.hearbeatwait = 0.2;
	wait(2);
	player = self;
	for(;;)
	{
		wait(0.2);
		if(player.health <= 0)
		{
			return;
		}
		if(player util::isusingremote())
		{
			continue;
		}
		if(player.health >= healthcap)
		{
			self.hearbeatwait = 0.3;
			continue;
		}
		if(level.healthregendisabled && gettime() > player.breathingstoptime)
		{
			self.hearbeatwait = 0.3;
			continue;
		}
		player playlocalsound("mpl_player_heartbeat");
		wait(self.hearbeatwait);
		if(self.hearbeatwait <= 0.6)
		{
			self.hearbeatwait = self.hearbeatwait + 0.1;
		}
	}
}

