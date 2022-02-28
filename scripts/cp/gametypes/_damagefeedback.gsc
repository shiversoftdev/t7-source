// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace damagefeedback;

/*
	Name: __init__sytem__
	Namespace: damagefeedback
	Checksum: 0x33BED38C
	Offset: 0x218
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("damagefeedback", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: damagefeedback
	Checksum: 0x84DE7FEC
	Offset: 0x258
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function __init__()
{
	callback::on_start_gametype(&init);
	callback::on_connect(&on_player_connect);
}

/*
	Name: init
	Namespace: damagefeedback
	Checksum: 0x99EC1590
	Offset: 0x2A8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function init()
{
}

/*
	Name: on_player_connect
	Namespace: damagefeedback
	Checksum: 0xE54991A1
	Offset: 0x2B8
	Size: 0xD8
	Parameters: 0
	Flags: None
*/
function on_player_connect()
{
	self.hud_damagefeedback = newdamageindicatorhudelem(self);
	self.hud_damagefeedback.horzalign = "center";
	self.hud_damagefeedback.vertalign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = 1;
	self.hud_damagefeedback setshader("damage_feedback", 24, 48);
	self.hitsoundtracker = 1;
}

/*
	Name: should_play_sound
	Namespace: damagefeedback
	Checksum: 0xB9B79E31
	Offset: 0x398
	Size: 0x66
	Parameters: 1
	Flags: None
*/
function should_play_sound(mod)
{
	if(!isdefined(mod))
	{
		return false;
	}
	switch(mod)
	{
		case "MOD_CRUSH":
		case "MOD_GRENADE_SPLASH":
		case "MOD_HIT_BY_OBJECT":
		case "MOD_MELEE":
		case "MOD_MELEE_ASSASSINATE":
		case "MOD_MELEE_WEAPON_BUTT":
		{
			return false;
		}
	}
	return true;
}

/*
	Name: update
	Namespace: damagefeedback
	Checksum: 0x8FD6A397
	Offset: 0x408
	Size: 0x260
	Parameters: 3
	Flags: None
*/
function update(mod, inflictor, perkfeedback)
{
	if(!isplayer(self) || sessionmodeiszombiesgame())
	{
		return;
	}
	if(should_play_sound(mod))
	{
		if(isdefined(inflictor) && isdefined(inflictor.soundmod))
		{
			switch(inflictor.soundmod)
			{
				case "player":
				{
					self playlocalsound("mpl_hit_alert");
					break;
				}
				case "heli":
				{
					self thread play_hit_sound(mod, "mpl_hit_alert_air");
					break;
				}
				case "hpm":
				{
					self thread play_hit_sound(mod, "mpl_hit_alert_hpm");
					break;
				}
				case "taser_spike":
				{
					self thread play_hit_sound(mod, "mpl_hit_alert_taser_spike");
					break;
				}
				case "dog":
				case "straferun":
				{
					break;
				}
				case "default_loud":
				{
					self thread play_hit_sound(mod, "mpl_hit_heli_gunner");
					break;
				}
				default:
				{
					self thread play_hit_sound(mod, "mpl_hit_alert_low");
					break;
				}
			}
		}
		else
		{
			self playlocalsound("mpl_hit_alert_low");
		}
	}
	if(isdefined(perkfeedback))
	{
	}
	else
	{
		self.hud_damagefeedback setshader("damage_feedback", 24, 48);
	}
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeovertime(1);
	self.hud_damagefeedback.alpha = 0;
}

/*
	Name: play_hit_sound
	Namespace: damagefeedback
	Checksum: 0x83D2869B
	Offset: 0x670
	Size: 0x60
	Parameters: 2
	Flags: None
*/
function play_hit_sound(mod, alert)
{
	self endon(#"disconnect");
	if(self.hitsoundtracker)
	{
		self.hitsoundtracker = 0;
		self playlocalsound(alert);
		wait(0.05);
		self.hitsoundtracker = 1;
	}
}

/*
	Name: update_special
	Namespace: damagefeedback
	Checksum: 0x67A874E3
	Offset: 0x6D8
	Size: 0xEA
	Parameters: 1
	Flags: None
*/
function update_special(hitent)
{
	if(!isplayer(self))
	{
		return;
	}
	if(!isdefined(hitent))
	{
		return;
	}
	if(!isplayer(hitent))
	{
		return;
	}
	wait(0.05);
	if(!isdefined(self.directionalhitarray))
	{
		self.directionalhitarray = [];
		hitentnum = hitent getentitynumber();
		self.directionalhitarray[hitentnum] = 1;
		self thread send_hit_special_event_at_frame_end(hitent);
	}
	else
	{
		hitentnum = hitent getentitynumber();
		self.directionalhitarray[hitentnum] = 1;
	}
}

/*
	Name: send_hit_special_event_at_frame_end
	Namespace: damagefeedback
	Checksum: 0x4C16DB74
	Offset: 0x7D0
	Size: 0x17E
	Parameters: 1
	Flags: None
*/
function send_hit_special_event_at_frame_end(hitent)
{
	self endon(#"disconnect");
	waittillframeend();
	enemyshit = 0;
	value = 1;
	entbitarray0 = 0;
	for(i = 0; i < 32; i++)
	{
		if(isdefined(self.directionalhitarray[i]) && self.directionalhitarray[i] != 0)
		{
			entbitarray0 = entbitarray0 + value;
			enemyshit++;
		}
		value = value * 2;
	}
	entbitarray1 = 0;
	for(i = 33; i < 64; i++)
	{
		if(isdefined(self.directionalhitarray[i]) && self.directionalhitarray[i] != 0)
		{
			entbitarray1 = entbitarray1 + value;
			enemyshit++;
		}
		value = value * 2;
	}
	if(enemyshit)
	{
		self directionalhitindicator(entbitarray0, entbitarray1);
	}
	self.directionalhitarray = undefined;
	entbitarray0 = 0;
	entbitarray1 = 0;
}

