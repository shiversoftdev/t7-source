// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\gadgets\_gadget_armor;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons_shared;

#namespace damagefeedback;

/*
	Name: __init__sytem__
	Namespace: damagefeedback
	Checksum: 0xCC0BE710
	Offset: 0x460
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
	Checksum: 0x512F8A1A
	Offset: 0x4A0
	Size: 0x44
	Parameters: 0
	Flags: Linked
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
	Offset: 0x4F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: on_player_connect
	Namespace: damagefeedback
	Checksum: 0xAEE135B6
	Offset: 0x500
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	if(!sessionmodeismultiplayergame())
	{
		self.hud_damagefeedback = newdamageindicatorhudelem(self);
		self.hud_damagefeedback.horzalign = "center";
		self.hud_damagefeedback.vertalign = "middle";
		self.hud_damagefeedback.x = -11;
		self.hud_damagefeedback.y = -11;
		self.hud_damagefeedback.alpha = 0;
		self.hud_damagefeedback.archived = 1;
		self.hud_damagefeedback setshader("damage_feedback", 22, 44);
		self.hud_damagefeedback_additional = newdamageindicatorhudelem(self);
		self.hud_damagefeedback_additional.horzalign = "center";
		self.hud_damagefeedback_additional.vertalign = "middle";
		self.hud_damagefeedback_additional.x = -12;
		self.hud_damagefeedback_additional.y = -12;
		self.hud_damagefeedback_additional.alpha = 0;
		self.hud_damagefeedback_additional.archived = 1;
		self.hud_damagefeedback_additional setshader("damage_feedback", 24, 48);
	}
}

/*
	Name: should_play_sound
	Namespace: damagefeedback
	Checksum: 0x2C4EF333
	Offset: 0x6B0
	Size: 0x66
	Parameters: 1
	Flags: Linked
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
	Checksum: 0xD46F59FF
	Offset: 0x720
	Size: 0x810
	Parameters: 7
	Flags: Linked
*/
function update(mod, inflictor, perkfeedback, weapon, victim, psoffsettime, shitloc)
{
	if(!isplayer(self))
	{
		return;
	}
	if(isdefined(self.nohitmarkers) && self.nohitmarkers)
	{
		return false;
	}
	if(isdefined(weapon) && (isdefined(weapon.nohitmarker) && weapon.nohitmarker))
	{
		return;
	}
	if(!isdefined(self.lasthitmarkertime))
	{
		self.lasthitmarkertimes = [];
		self.lasthitmarkertime = 0;
		self.lasthitmarkeroffsettime = 0;
	}
	if(isdefined(psoffsettime))
	{
		victim_id = victim getentitynumber();
		if(!isdefined(self.lasthitmarkertimes[victim_id]))
		{
			self.lasthitmarkertimes[victim_id] = 0;
		}
		if(self.lasthitmarkertime == gettime())
		{
			if(self.lasthitmarkertimes[victim_id] === psoffsettime)
			{
				return;
			}
		}
		self.lasthitmarkeroffsettime = psoffsettime;
		self.lasthitmarkertimes[victim_id] = psoffsettime;
	}
	else if(self.lasthitmarkertime == gettime())
	{
		return;
	}
	self.lasthitmarkertime = gettime();
	hitalias = undefined;
	if(should_play_sound(mod))
	{
		if(isdefined(victim) && isdefined(victim.victimsoundmod))
		{
			switch(victim.victimsoundmod)
			{
				case "safeguard_robot":
				{
					hitalias = "mpl_hit_alert_escort";
					break;
				}
				default:
				{
					hitalias = "mpl_hit_alert";
					break;
				}
			}
		}
		else
		{
			if(isdefined(inflictor) && isdefined(inflictor.soundmod))
			{
				switch(inflictor.soundmod)
				{
					case "player":
					{
						if(isdefined(victim) && (isdefined(victim.isaiclone) && victim.isaiclone))
						{
							hitalias = "mpl_hit_alert_clone";
						}
						else
						{
							if(isdefined(victim) && isplayer(victim) && victim flagsys::get("gadget_armor_on") && armor::armor_should_take_damage(inflictor, weapon, mod, shitloc))
							{
								hitalias = "mpl_hit_alert_armor";
							}
							else
							{
								if(isdefined(victim) && isplayer(victim) && isdefined(victim.carryobject) && isdefined(victim.carryobject.hitsound) && isdefined(perkfeedback) && perkfeedback == "armor")
								{
									hitalias = victim.carryobject.hitsound;
								}
								else
								{
									if(mod == "MOD_BURNED")
									{
										hitalias = "mpl_hit_alert_burn";
									}
									else
									{
										hitalias = "mpl_hit_alert";
									}
								}
							}
						}
						break;
					}
					case "heatwave":
					{
						hitalias = "mpl_hit_alert_heatwave";
						break;
					}
					case "heli":
					{
						hitalias = "mpl_hit_alert_air";
						break;
					}
					case "hpm":
					{
						hitalias = "mpl_hit_alert_hpm";
						break;
					}
					case "taser_spike":
					{
						hitalias = "mpl_hit_alert_taser_spike";
						break;
					}
					case "dog":
					case "straferun":
					{
						break;
					}
					case "firefly":
					{
						hitalias = "mpl_hit_alert_firefly";
						break;
					}
					case "drone_land":
					{
						hitalias = "mpl_hit_alert_air";
						break;
					}
					case "raps":
					{
						hitalias = "mpl_hit_alert_air";
						break;
					}
					case "default_loud":
					{
						hitalias = "mpl_hit_heli_gunner";
						break;
					}
					default:
					{
						hitalias = "mpl_hit_alert";
						break;
					}
				}
			}
			else
			{
				if(mod == "MOD_BURNED")
				{
					hitalias = "mpl_hit_alert_burn";
				}
				else
				{
					hitalias = "mpl_hit_alert";
				}
			}
		}
	}
	if(isdefined(victim) && (isdefined(victim.isaiclone) && victim.isaiclone))
	{
		self playhitmarker(hitalias);
		return;
	}
	damagestage = 1;
	if(isdefined(level.growing_hitmarker) && isdefined(victim) && isplayer(victim))
	{
		damagestage = damage_feedback_get_stage(victim);
	}
	self playhitmarker(hitalias, damagestage, perkfeedback, damage_feedback_get_dead(victim, mod, weapon, damagestage));
	if(isdefined(perkfeedback))
	{
		if(isdefined(self.hud_damagefeedback_additional))
		{
			switch(perkfeedback)
			{
				case "flakjacket":
				{
					self.hud_damagefeedback_additional setshader("damage_feedback_flak", 24, 48);
					break;
				}
				case "tacticalMask":
				{
					self.hud_damagefeedback_additional setshader("damage_feedback_tac", 24, 48);
					break;
				}
				case "armor":
				{
					self.hud_damagefeedback_additional setshader("damage_feedback_armor", 24, 48);
					break;
				}
			}
			self.hud_damagefeedback_additional.alpha = 1;
			self.hud_damagefeedback_additional fadeovertime(1);
			self.hud_damagefeedback_additional.alpha = 0;
		}
	}
	else if(isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback setshader("damage_feedback", 24, 48);
	}
	if(isdefined(self.hud_damagefeedback) && isdefined(level.growing_hitmarker) && isdefined(victim) && isplayer(victim))
	{
		self thread damage_feedback_growth(victim, mod, weapon);
	}
	else if(isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback.x = -12;
		self.hud_damagefeedback.y = -12;
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeovertime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

/*
	Name: damage_feedback_get_stage
	Namespace: damagefeedback
	Checksum: 0x84FEB203
	Offset: 0xF38
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function damage_feedback_get_stage(victim)
{
	if(isdefined(victim.laststand) && victim.laststand)
	{
		return 5;
	}
	if((victim.health / victim.maxhealth) > 0.74)
	{
		return 1;
	}
	if((victim.health / victim.maxhealth) > 0.49)
	{
		return 2;
	}
	if((victim.health / victim.maxhealth) > 0.24)
	{
		return 3;
	}
	if(victim.health > 0)
	{
		return 4;
	}
	return 5;
}

/*
	Name: damage_feedback_get_dead
	Namespace: damagefeedback
	Checksum: 0x9EF09F7C
	Offset: 0x1038
	Size: 0xEE
	Parameters: 4
	Flags: Linked
*/
function damage_feedback_get_dead(victim, mod, weapon, stage)
{
	return stage == 5 && (mod == "MOD_BULLET" || mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET" || mod == "MOD_HEAD_SHOT") && (isdefined(weapon.isheroweapon) && !weapon.isheroweapon) && !killstreaks::is_killstreak_weapon(weapon) && !weapon.name === "siegebot_gun_turret" && !weapon.name === "siegebot_launcher_turret";
}

/*
	Name: damage_feedback_growth
	Namespace: damagefeedback
	Checksum: 0x124420A5
	Offset: 0x1130
	Size: 0x1B8
	Parameters: 3
	Flags: Linked
*/
function damage_feedback_growth(victim, mod, weapon)
{
	if(isdefined(self.hud_damagefeedback))
	{
		stage = damage_feedback_get_stage(victim);
		self.hud_damagefeedback.x = -11 + -1 * stage;
		self.hud_damagefeedback.y = -11 + -1 * stage;
		size_x = 22 + (2 * stage);
		size_y = size_x * 2;
		self.hud_damagefeedback setshader("damage_feedback", size_x, size_y);
		if(damage_feedback_get_dead(victim, mod, weapon, stage))
		{
			self.hud_damagefeedback setshader("damage_feedback_glow_orange", size_x, size_y);
			self thread kill_hitmarker_fade();
		}
		else
		{
			self.hud_damagefeedback setshader("damage_feedback", size_x, size_y);
			self.hud_damagefeedback.alpha = 1;
			self.hud_damagefeedback fadeovertime(1);
			self.hud_damagefeedback.alpha = 0;
		}
	}
}

/*
	Name: kill_hitmarker_fade
	Namespace: damagefeedback
	Checksum: 0x9954625D
	Offset: 0x12F0
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function kill_hitmarker_fade()
{
	self notify(#"kill_hitmarker_fade");
	self endon(#"kill_hitmarker_fade");
	self endon(#"disconnect");
	self.hud_damagefeedback.alpha = 1;
	wait(0.25);
	self.hud_damagefeedback fadeovertime(0.3);
	self.hud_damagefeedback.alpha = 0;
}

/*
	Name: update_override
	Namespace: damagefeedback
	Checksum: 0x96FDE0
	Offset: 0x1378
	Size: 0x160
	Parameters: 3
	Flags: Linked
*/
function update_override(icon, sound, additional_icon)
{
	if(!isplayer(self))
	{
		return;
	}
	self playlocalsound(sound);
	if(isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback setshader(icon, 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeovertime(1);
		self.hud_damagefeedback.alpha = 0;
	}
	if(isdefined(self.hud_damagefeedback_additional))
	{
		if(!isdefined(additional_icon))
		{
			self.hud_damagefeedback_additional.alpha = 0;
		}
		else
		{
			self.hud_damagefeedback_additional setshader(additional_icon, 24, 48);
			self.hud_damagefeedback_additional.alpha = 1;
			self.hud_damagefeedback_additional fadeovertime(1);
			self.hud_damagefeedback_additional.alpha = 0;
		}
	}
}

/*
	Name: update_special
	Namespace: damagefeedback
	Checksum: 0x53EFD249
	Offset: 0x14E0
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
	Checksum: 0xA662C161
	Offset: 0x15D8
	Size: 0x17E
	Parameters: 1
	Flags: Linked
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

/*
	Name: dodamagefeedback
	Namespace: damagefeedback
	Checksum: 0x9AD3C964
	Offset: 0x1760
	Size: 0xBE
	Parameters: 4
	Flags: Linked
*/
function dodamagefeedback(weapon, einflictor, idamage, smeansofdeath)
{
	if(!isdefined(weapon))
	{
		return false;
	}
	if(isdefined(weapon.nohitmarker) && weapon.nohitmarker)
	{
		return false;
	}
	if(level.allowhitmarkers == 0)
	{
		return false;
	}
	if(level.allowhitmarkers == 1)
	{
		if(isdefined(smeansofdeath) && isdefined(idamage))
		{
			if(istacticalhitmarker(weapon, smeansofdeath, idamage))
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: istacticalhitmarker
	Namespace: damagefeedback
	Checksum: 0xFC86BB54
	Offset: 0x1828
	Size: 0x80
	Parameters: 3
	Flags: Linked
*/
function istacticalhitmarker(weapon, smeansofdeath, idamage)
{
	if(weapons::is_grenade(weapon))
	{
		if("Smoke Grenade" == weapon.offhandclass)
		{
			if(smeansofdeath == "MOD_GRENADE_SPLASH")
			{
				return true;
			}
		}
		else if(idamage == 1)
		{
			return true;
		}
	}
	return false;
}

