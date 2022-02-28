// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_bb;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_globallogic_spawn;
#using scripts\cp\gametypes\_healthoverlay;
#using scripts\cp\gametypes\coop;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace laststand;

/*
	Name: __init__sytem__
	Namespace: laststand
	Checksum: 0x1688B90
	Offset: 0x6B8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("laststand", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: laststand
	Checksum: 0x7BBF750C
	Offset: 0x6F8
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(level.script == "frontend")
	{
		return;
	}
	level.laststand_update_clientfields = [];
	for(i = 0; i < 4; i++)
	{
		level.laststand_update_clientfields[i] = "laststand_update" + i;
		clientfield::register("world", level.laststand_update_clientfields[i], 1, 5, "counter");
	}
	if(!isdefined(level.playerlaststand_func))
	{
		level.playerlaststand_func = &player_laststand;
	}
	level.weaponrevivetool = getweapon("syrette");
	if(!isdefined(level.laststandpistol))
	{
		level.laststandpistol = getweapon("noweapon");
	}
	level thread revive_hud_think();
	level.primaryprogressbarx = 0;
	level.primaryprogressbary = 110;
	level.primaryprogressbarheight = 4;
	level.primaryprogressbarwidth = 120;
	level.primaryprogressbary_ss = 280;
	if(getdvarstring("revive_trigger_radius") == "")
	{
		setdvar("revive_trigger_radius", "100");
	}
	level.laststandgetupallowed = 0;
	if(isdefined(level.var_be177839))
	{
		visionsetlaststand(level.var_be177839);
	}
	else
	{
		visionsetlaststand("zombie_last_stand");
	}
}

/*
	Name: player_last_stand_stats
	Namespace: laststand
	Checksum: 0x90D7B20F
	Offset: 0x908
	Size: 0xE4
	Parameters: 9
	Flags: Linked
*/
function player_last_stand_stats(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	if(isdefined(attacker) && isplayer(attacker) && attacker != self)
	{
		attacker.kills++;
		if(isdefined(weapon))
		{
			dmgweapon = weapon;
			attacker addweaponstat(dmgweapon, "kills", 1);
		}
	}
	self increment_downed_stat();
}

/*
	Name: increment_downed_stat
	Namespace: laststand
	Checksum: 0x5E2815BC
	Offset: 0x9F8
	Size: 0x11E
	Parameters: 0
	Flags: Linked
*/
function increment_downed_stat()
{
	self.downs++;
	self addplayerstat("INCAPS", 1);
	if(isdefined(getrootmapname()))
	{
		var_e7ce5f85 = self getdstat("PlayerStatsList", "INCAPS", "statValue");
		self setnoncheckpointdata("INCAPS", var_e7ce5f85);
		self.incaps = var_e7ce5f85 - self getdstat("PlayerStatsByMap", getrootmapname(), "currentStats", "INCAPS");
		/#
			assert(self.incaps > 0);
		#/
		self.pers["incaps"] = self.incaps;
	}
}

/*
	Name: function_51061490
	Namespace: laststand
	Checksum: 0x29164F23
	Offset: 0xB20
	Size: 0x38
	Parameters: 0
	Flags: Linked, Private
*/
function private function_51061490()
{
	/#
		if(getdvarstring("") == "")
		{
			return true;
		}
	#/
	return false;
}

/*
	Name: playerlaststand
	Namespace: laststand
	Checksum: 0x440C5589
	Offset: 0xB60
	Size: 0x6A4
	Parameters: 9
	Flags: Linked
*/
function playerlaststand(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, delayoverride)
{
	if(isdefined(self.var_32218fc7) && self.var_32218fc7)
	{
		return;
	}
	self notify(#"entering_last_stand");
	if(isdefined(level._game_module_player_laststand_callback))
	{
		self [[level._game_module_player_laststand_callback]](einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, delayoverride);
	}
	if(self player_is_in_laststand())
	{
		return;
	}
	if(level.players.size == 1 && self.lives == 0 && !function_51061490())
	{
		return;
	}
	self closemenu(game["menu_changeclass"]);
	self clientfield::set_to_player("mobile_armory_cac", 0);
	if(!self util::isweaponenabled())
	{
		self util::_enableweapon();
	}
	self.laststandparams = spawnstruct();
	self.var_afe5253c = spawnstruct();
	self.laststandparams.einflictor = einflictor;
	self.var_afe5253c.var_a21e8eb8 = -1;
	if(isdefined(einflictor))
	{
		self.var_afe5253c.var_a21e8eb8 = einflictor getentitynumber();
	}
	self.var_afe5253c.attackernum = -1;
	if(isdefined(attacker))
	{
		self.var_afe5253c.attackernum = einflictor getentitynumber();
	}
	self.laststandparams.attacker = attacker;
	self.laststandparams.idamage = idamage;
	self.laststandparams.smeansofdeath = smeansofdeath;
	self.laststandparams.sweapon = weapon;
	self.laststandparams.vdir = vdir;
	self.laststandparams.shitloc = shitloc;
	self.laststandparams.laststandstarttime = gettime();
	self thread player_last_stand_stats(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, delayoverride);
	bb::logplayermapnotification("enter_last_stand", self);
	self recordmapevent(1, gettime(), self.origin, skipto::function_52c50cb8());
	if(isdefined(level.playerlaststand_func))
	{
		[[level.playerlaststand_func]](einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, delayoverride);
	}
	self.health = 1;
	self.laststand = 1;
	self.ignoreme = 1;
	self enableinvulnerability();
	self.meleeattackers = undefined;
	self util::show_hud(0);
	callback::callback(#"hash_6751ab5b");
	if(!(isdefined(self.no_revive_trigger) && self.no_revive_trigger))
	{
		self revive_trigger_spawn();
	}
	else
	{
		self undolaststand();
	}
	if(!isdefined(level.var_83405e54) || !level.var_83405e54)
	{
		self thread laststand_watch_weapon_switch();
	}
	self laststand_disable_player_weapons();
	if(!isdefined(level.var_83405e54) || !level.var_83405e54)
	{
		self laststand_give_pistol();
	}
	if(isdefined(level.playersuicideallowed) && level.playersuicideallowed && getplayers().size > 1)
	{
		if(!isdefined(level.canplayersuicide) || self [[level.canplayersuicide]]())
		{
			self thread suicide_trigger_spawn();
		}
	}
	if(isdefined(self.disabled_perks))
	{
		self.disabled_perks = [];
	}
	if(level.laststandgetupallowed && delayoverride != -1)
	{
		self thread laststand_getup();
	}
	else
	{
		bleedout_time = getdvarfloat("player_lastStandBleedoutTime");
		if(delayoverride != 0)
		{
			if(delayoverride == -1)
			{
				delayoverride = 0;
			}
			bleedout_time = delayoverride;
		}
		level clientfield::increment("laststand_update" + self getentitynumber(), 30);
		self thread laststand_bleedout(bleedout_time);
	}
	demo::bookmark("player_downed", gettime(), self);
	self notify(#"player_downed");
	self thread refire_player_downed();
	self thread cleanup_laststand_on_disconnect();
	self thread auto_revive_on_notify();
	self thread function_fb3dd978();
}

/*
	Name: function_fb3dd978
	Namespace: laststand
	Checksum: 0x94689A8A
	Offset: 0x1210
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_fb3dd978()
{
	self endon(#"player_revived");
	self endon(#"disconnect");
	self waittill(#"death");
	self undolaststand();
}

/*
	Name: refire_player_downed
	Namespace: laststand
	Checksum: 0x1D5A518F
	Offset: 0x1258
	Size: 0x3E
	Parameters: 0
	Flags: Linked
*/
function refire_player_downed()
{
	self endon(#"player_revived");
	self endon(#"death");
	self endon(#"disconnect");
	wait(1);
	self notify(#"player_downed");
}

/*
	Name: wait_for_weapon_pullout
	Namespace: laststand
	Checksum: 0x9034C2EC
	Offset: 0x12A0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function wait_for_weapon_pullout()
{
	self endon(#"weapon_change");
	while(!self attackbuttonpressed())
	{
		wait(0.05);
	}
}

/*
	Name: laststand_watch_weapon_switch
	Namespace: laststand
	Checksum: 0x4711B1ED
	Offset: 0x12E0
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function laststand_watch_weapon_switch()
{
	self endon(#"bled_out");
	self endon(#"disconnect");
	self endon(#"player_revived");
	while(true)
	{
		self waittill(#"weapon_change", newweapon);
		/#
			assert(isdefined(self.laststandpistol));
		#/
		/#
			assert(self.laststandpistol != level.weaponnone);
		#/
		if(newweapon == self.laststandpistol)
		{
			break;
		}
		else
		{
			weaponinventory = self getweaponslist(1);
			self.lastactiveweapon = self getcurrentweapon();
			if(self isthrowinggrenade() || self cybercom::function_1be27df7())
			{
				primaryweapons = self getweaponslistprimaries();
				if(isdefined(primaryweapons) && primaryweapons.size > 0)
				{
					self.lastactiveweapon = primaryweapons[0];
					self switchtoweaponimmediate(self.lastactiveweapon);
				}
			}
			self setlaststandprevweap(self.lastactiveweapon);
		}
	}
	self wait_for_weapon_pullout();
	self laststand_enable_player_weapons(0);
	self.ignoreme = 0;
	self disableinvulnerability();
	self util::show_hud(1);
}

/*
	Name: laststand_disable_player_weapons
	Namespace: laststand
	Checksum: 0x994AC592
	Offset: 0x14F8
	Size: 0x16A
	Parameters: 0
	Flags: Linked
*/
function laststand_disable_player_weapons()
{
	weaponinventory = self getweaponslist(1);
	self.lastactiveweapon = self getcurrentweapon();
	if(self isthrowinggrenade() || self cybercom::function_1be27df7())
	{
		primaryweapons = self getweaponslistprimaries();
		if(isdefined(primaryweapons) && primaryweapons.size > 0)
		{
			self.lastactiveweapon = primaryweapons[0];
			self switchtoweaponimmediate(self.lastactiveweapon);
		}
	}
	self setlaststandprevweap(self.lastactiveweapon);
	self.laststandpistol = undefined;
	if(!isdefined(self.laststandpistol))
	{
		self.laststandpistol = level.laststandpistol;
	}
	if(isdefined(self.laststandpistoloverride))
	{
		self.laststandpistol = self.laststandpistoloverride;
	}
	if(isdefined(level.laststandweaponoverride))
	{
		[[level.laststandweaponoverride]]();
	}
	self notify(#"weapons_taken_for_last_stand");
}

/*
	Name: laststand_enable_player_weapons
	Namespace: laststand
	Checksum: 0x97EE6C0C
	Offset: 0x1670
	Size: 0x170
	Parameters: 1
	Flags: Linked
*/
function laststand_enable_player_weapons(b_allow_grenades = 1)
{
	if(isdefined(self.laststandpistol))
	{
		self takeweapon(self.laststandpistol);
	}
	self setlowready(0);
	self enableweaponcycling();
	if(b_allow_grenades)
	{
		self enableoffhandweapons();
	}
	if(isdefined(self.lastactiveweapon) && self.lastactiveweapon != level.weaponnone && self hasweapon(self.lastactiveweapon))
	{
		self switchtoweapon(self.lastactiveweapon);
	}
	else
	{
		primaryweapons = self getweaponslistprimaries();
		if(isdefined(primaryweapons) && primaryweapons.size > 0)
		{
			self switchtoweapon(primaryweapons[0]);
		}
	}
	if(isdefined(level.laststandweaponreturnedoverride))
	{
		[[level.laststandweaponreturnedoverride]]();
	}
}

/*
	Name: laststand_clean_up_on_interrupt
	Namespace: laststand
	Checksum: 0x53493740
	Offset: 0x17E8
	Size: 0x104
	Parameters: 2
	Flags: Linked
*/
function laststand_clean_up_on_interrupt(playerbeingrevived, revivergun)
{
	self endon(#"do_revive_ended_normally");
	revivetrigger = playerbeingrevived.revivetrigger;
	playerbeingrevived util::waittill_any("disconnect", "game_ended", "death");
	if(isdefined(revivetrigger))
	{
		revivetrigger delete();
	}
	self cleanup_suicide_hud();
	if(isdefined(self.reviveprogressbar))
	{
		self.reviveprogressbar hud::destroyelem();
	}
	if(isdefined(self.revivetexthud))
	{
		self.revivetexthud destroy();
	}
	self revive_give_back_weapons(revivergun);
}

/*
	Name: laststand_clean_up_reviving_any
	Namespace: laststand
	Checksum: 0x622E8813
	Offset: 0x18F8
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function laststand_clean_up_reviving_any(playerbeingrevived)
{
	self endon(#"do_revive_ended_normally");
	playerbeingrevived util::waittill_any("disconnect", "zombified", "stop_revive_trigger");
	self.is_reviving_any--;
	if(0 > self.is_reviving_any)
	{
		self.is_reviving_any = 0;
	}
}

/*
	Name: laststand_give_pistol
	Namespace: laststand
	Checksum: 0x854E5097
	Offset: 0x1968
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function laststand_give_pistol()
{
	/#
		assert(isdefined(self.laststandpistol));
	#/
	/#
		assert(self.laststandpistol != level.weaponnone);
	#/
	self giveweapon(self.laststandpistol);
	self givemaxammo(self.laststandpistol);
	self switchtoweapon(self.laststandpistol);
	if(isdefined(level.laststandweapongivenoverride))
	{
		[[level.laststandweapongivenoverride]]();
	}
}

/*
	Name: laststand_bleedout_decrement
	Namespace: laststand
	Checksum: 0x7D270D12
	Offset: 0x1A38
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function laststand_bleedout_decrement()
{
	self.bleedout_time = self.bleedout_time - 1;
	wait(1);
	while(isdefined(self.revivetrigger) && isdefined(self.revivetrigger.beingrevived) && self.revivetrigger.beingrevived == 1)
	{
		wait(0.1);
	}
}

/*
	Name: check_early_bleedout
	Namespace: laststand
	Checksum: 0xDBB93507
	Offset: 0x1AA8
	Size: 0x1C6
	Parameters: 0
	Flags: Linked, Private
*/
function private check_early_bleedout()
{
	players = getplayers();
	if(players.size == 1)
	{
		if(self.lives == 0)
		{
			self.bleedout_time = 3;
		}
	}
	else
	{
		b_any_standing = 0;
		foreach(player in players)
		{
			if(isalive(player) && (!(isdefined(player.laststand) && player.laststand) || player.lives > 0))
			{
				b_any_standing = 1;
				break;
			}
		}
		if(!b_any_standing)
		{
			level.var_ee7cb602 = 1;
			foreach(player in players)
			{
				player.bleedout_time = 3;
			}
		}
	}
}

/*
	Name: laststand_bleedout_damage
	Namespace: laststand
	Checksum: 0x4E1B4267
	Offset: 0x1C78
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function laststand_bleedout_damage()
{
	self endon(#"player_revived");
	self endon(#"player_suicide");
	self endon(#"disconnect");
	self endon(#"bled_out");
	if(level.players.size == 1)
	{
		return;
	}
	while(true)
	{
		self waittill(#"laststand_damage", amt);
		if(!self.ignoreme)
		{
			self.bleedout_time = self.bleedout_time - (0.02 * amt);
		}
	}
}

/*
	Name: laststand_bleedout
	Namespace: laststand
	Checksum: 0x17C3DA39
	Offset: 0x1D18
	Size: 0x19C
	Parameters: 1
	Flags: Linked
*/
function laststand_bleedout(delay)
{
	self endon(#"player_revived");
	self endon(#"player_suicide");
	self endon(#"disconnect");
	self endon(#"death");
	self clientfield::set_to_player("sndHealth", 2);
	self.var_320b6880 = delay;
	self.bleedout_time = delay;
	if(delay != 0 && !function_51061490())
	{
		check_early_bleedout();
	}
	if(isdefined(level.var_ee7cb602) && level.var_ee7cb602)
	{
		playsoundatposition("evt_death_down", (0, 0, 0));
	}
	self thread laststand_bleedout_damage();
	do
	{
		laststand_bleedout_decrement();
		level clientfield::increment("laststand_update" + self getentitynumber(), self.bleedout_time + 1);
	}
	while(self.bleedout_time > 0);
	self notify(#"bled_out");
	bb::logplayermapnotification("player_bled_out", self);
	util::wait_network_frame();
	self bleed_out();
}

/*
	Name: ensurelaststandparamsvalidity
	Namespace: laststand
	Checksum: 0x25D88984
	Offset: 0x1EC0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function ensurelaststandparamsvalidity()
{
	if(!isdefined(self.laststandparams.attacker))
	{
		self.laststandparams.attacker = self;
	}
}

/*
	Name: bleed_out
	Namespace: laststand
	Checksum: 0xD0CD3520
	Offset: 0x1EF8
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function bleed_out()
{
	if(getdvarint("enable_new_death_cam", 1))
	{
		var_6afb4351 = getdvarfloat("bleed_out_screen_fade_speed", 1.5);
		self playlocalsound("chr_health_laststand_bleedout");
		self lui::screen_fade(var_6afb4351, 1, 0, "black", 0);
		wait(var_6afb4351 + 0.2);
	}
	self cleanup_suicide_hud();
	if(isdefined(self.revivetrigger))
	{
		self.revivetrigger delete();
	}
	self.revivetrigger = undefined;
	self clientfield::set_to_player("sndHealth", 0);
	level clientfield::increment("laststand_update" + self getentitynumber(), 1);
	demo::bookmark("player_bledout", gettime(), self, undefined, 1);
	level notify(#"bleed_out", self.characterindex);
	self notify(#"hash_a31e5729");
	self coop::onplayerbleedout();
	self undolaststand();
	self.ignoreme = 0;
	self util::show_hud(1);
	self.uselaststandparams = 1;
	self ensurelaststandparamsvalidity();
	self suicide();
	self thread respawn_player_after_time(15);
}

/*
	Name: respawn_player_after_time
	Namespace: laststand
	Checksum: 0x29E1B9EF
	Offset: 0x2128
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function respawn_player_after_time(n_time_seconds)
{
	self endon(#"disconnect");
	players = getplayers();
	if(players.size == 1)
	{
		return;
	}
	self waittill(#"spawned_spectator");
	self endon(#"spawned");
	level endon(#"objective_changed");
	wait(n_time_seconds);
	if(self.sessionstate == "spectator")
	{
		self thread globallogic_spawn::waitandspawnclient();
	}
}

/*
	Name: suicide_trigger_spawn
	Namespace: laststand
	Checksum: 0x5A265427
	Offset: 0x21D0
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function suicide_trigger_spawn()
{
	self.suicideprompt = newclienthudelem(self);
	self.suicideprompt.alignx = "center";
	self.suicideprompt.aligny = "middle";
	self.suicideprompt.horzalign = "center";
	self.suicideprompt.vertalign = "bottom";
	self.suicideprompt.y = -170;
	if(self issplitscreen())
	{
		self.suicideprompt.y = -132;
	}
	self.suicideprompt.foreground = 1;
	self.suicideprompt.font = "default";
	self.suicideprompt.fontscale = 1.5;
	self.suicideprompt.alpha = 1;
	self.suicideprompt.color = (1, 1, 1);
	self.suicideprompt.hidewheninmenu = 1;
	self thread suicide_trigger_think();
}

/*
	Name: suicide_trigger_think
	Namespace: laststand
	Checksum: 0x9DAEF907
	Offset: 0x2338
	Size: 0x24A
	Parameters: 0
	Flags: Linked
*/
function suicide_trigger_think()
{
	self endon(#"disconnect");
	self endon(#"stop_revive_trigger");
	self endon(#"player_revived");
	self endon(#"bled_out");
	self endon(#"fake_death");
	level endon(#"game_ended");
	level endon(#"stop_suicide_trigger");
	self thread clean_up_suicide_hud_on_end_game();
	self thread clean_up_suicide_hud_on_bled_out();
	while(self usebuttonpressed())
	{
		wait(1);
	}
	if(!isdefined(self.suicideprompt))
	{
		return;
	}
	while(true)
	{
		wait(0.1);
		if(!isdefined(self.suicideprompt))
		{
			continue;
		}
		self.suicideprompt settext(&"COOP_BUTTON_TO_SUICIDE");
		if(!self is_suiciding())
		{
			continue;
		}
		self.pre_suicide_weapon = self getcurrentweapon();
		self giveweapon(level.suicide_weapon);
		self switchtoweapon(level.suicide_weapon);
		duration = self docowardswayanims();
		suicide_success = suicide_do_suicide(duration);
		self.laststand = undefined;
		self takeweapon(level.suicide_weapon);
		if(suicide_success)
		{
			self notify(#"player_suicide");
			util::wait_network_frame();
			self bleed_out();
			return;
		}
		self switchtoweapon(self.pre_suicide_weapon);
		self.pre_suicide_weapon = undefined;
	}
}

/*
	Name: suicide_do_suicide
	Namespace: laststand
	Checksum: 0xAE46B3E2
	Offset: 0x2590
	Size: 0x320
	Parameters: 1
	Flags: Linked
*/
function suicide_do_suicide(duration)
{
	level endon(#"game_ended");
	level endon(#"stop_suicide_trigger");
	suicidetime = duration;
	timer = 0;
	suicided = 0;
	self.suicideprompt settext("");
	if(!isdefined(self.suicideprogressbar))
	{
		self.suicideprogressbar = self hud::createprimaryprogressbar();
	}
	if(!isdefined(self.suicidetexthud))
	{
		self.suicidetexthud = newclienthudelem(self);
	}
	self.suicideprogressbar hud::updatebar(0.01, 1 / suicidetime);
	self.suicidetexthud.alignx = "center";
	self.suicidetexthud.aligny = "middle";
	self.suicidetexthud.horzalign = "center";
	self.suicidetexthud.vertalign = "bottom";
	self.suicidetexthud.y = -173;
	if(self issplitscreen())
	{
		self.suicidetexthud.y = -147;
	}
	self.suicidetexthud.foreground = 1;
	self.suicidetexthud.font = "default";
	self.suicidetexthud.fontscale = 1.8;
	self.suicidetexthud.alpha = 1;
	self.suicidetexthud.color = (1, 1, 1);
	self.suicidetexthud.hidewheninmenu = 1;
	self.suicidetexthud settext(&"COOP_SUICIDING");
	bb::logplayermapnotification("last_stand_suicide", self);
	while(self is_suiciding())
	{
		wait(0.05);
		timer = timer + 0.05;
		if(timer >= suicidetime)
		{
			suicided = 1;
			break;
		}
	}
	if(isdefined(self.suicideprogressbar))
	{
		self.suicideprogressbar hud::destroyelem();
	}
	if(isdefined(self.suicidetexthud))
	{
		self.suicidetexthud destroy();
	}
	if(isdefined(self.suicideprompt))
	{
		self.suicideprompt settext(&"COOP_BUTTON_TO_SUICIDE");
	}
	return suicided;
}

/*
	Name: can_suicide
	Namespace: laststand
	Checksum: 0x68BEEDA0
	Offset: 0x28B8
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function can_suicide()
{
	if(!isalive(self))
	{
		return false;
	}
	if(!self player_is_in_laststand())
	{
		return false;
	}
	if(!isdefined(self.suicideprompt))
	{
		return false;
	}
	if(isdefined(level.intermission) && level.intermission)
	{
		return false;
	}
	return true;
}

/*
	Name: is_suiciding
	Namespace: laststand
	Checksum: 0x8BC5549B
	Offset: 0x2930
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function is_suiciding(revivee)
{
	return self usebuttonpressed() && can_suicide();
}

/*
	Name: revive_trigger_spawn
	Namespace: laststand
	Checksum: 0x92960DA2
	Offset: 0x2978
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function revive_trigger_spawn()
{
	if(isdefined(level.revive_trigger_spawn_override_link))
	{
		[[level.revive_trigger_spawn_override_link]](self);
	}
	else
	{
		radius = getdvarint("revive_trigger_radius");
		self.revivetrigger = spawn("trigger_radius", (0, 0, 0), 0, radius, radius);
		self.revivetrigger sethintstring("");
		self.revivetrigger setcursorhint("HINT_NOICON");
		self.revivetrigger setmovingplatformenabled(1);
		self.revivetrigger enablelinkto();
		self.revivetrigger.origin = self.origin;
		self.revivetrigger linkto(self);
		self.revivetrigger.beingrevived = 0;
		self.revivetrigger.createtime = gettime();
	}
	self thread revive_trigger_think();
}

/*
	Name: revive_trigger_think
	Namespace: laststand
	Checksum: 0x56017297
	Offset: 0x2AE0
	Size: 0x304
	Parameters: 0
	Flags: Linked
*/
function revive_trigger_think()
{
	self endon(#"disconnect");
	self endon(#"stop_revive_trigger");
	level endon(#"game_ended");
	self endon(#"death");
	while(true)
	{
		wait(0.1);
		if(!isdefined(self.revivetrigger))
		{
			self notify(#"stop_revive_trigger");
		}
		self.revivetrigger sethintstring("");
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i] can_revive(self))
			{
				self.revivetrigger setrevivehintstring(&"COOP_BUTTON_TO_REVIVE_PLAYER", self.team);
				break;
			}
		}
		for(i = 0; i < players.size; i++)
		{
			reviver = players[i];
			if(self == reviver || !reviver is_reviving(self))
			{
				continue;
			}
			gun = reviver getcurrentweapon();
			/#
				assert(isdefined(gun));
			#/
			if(gun == level.weaponrevivetool)
			{
				continue;
			}
			reviver giveweapon(level.weaponrevivetool);
			reviver switchtoweapon(level.weaponrevivetool);
			reviver setweaponammostock(level.weaponrevivetool, 1);
			reviver disableweaponfire();
			reviver disableweaponcycling();
			reviver disableusability();
			reviver disableoffhandweapons();
			revive_success = reviver revive_do_revive(self, gun);
			reviver revive_give_back_weapons(gun);
			if(revive_success)
			{
				self thread revive_success(reviver);
				self cleanup_suicide_hud();
				return;
			}
		}
	}
}

/*
	Name: revive_give_back_weapons
	Namespace: laststand
	Checksum: 0xDE8F2A50
	Offset: 0x2DF0
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function revive_give_back_weapons(gun)
{
	self takeweapon(level.weaponrevivetool);
	self enableweaponfire();
	self enableweaponcycling();
	self enableusability();
	self enableoffhandweapons();
	if(self player_is_in_laststand())
	{
		return;
	}
	if(self hasweapon(gun))
	{
		self switchtoweapon(gun);
	}
	else
	{
		primaryweapons = self getweaponslistprimaries();
		if(isdefined(primaryweapons) && primaryweapons.size > 0)
		{
			self switchtoweapon(primaryweapons[0]);
		}
	}
}

/*
	Name: can_revive
	Namespace: laststand
	Checksum: 0x5451A421
	Offset: 0x2F30
	Size: 0x25E
	Parameters: 1
	Flags: Linked
*/
function can_revive(revivee)
{
	if(!isdefined(revivee.revivetrigger))
	{
		return false;
	}
	if(!isalive(self))
	{
		return false;
	}
	if(self player_is_in_laststand())
	{
		return false;
	}
	if(self.team != revivee.team)
	{
		return false;
	}
	if(isdefined(level.can_revive) && ![[level.can_revive]](revivee))
	{
		return false;
	}
	if(isdefined(level.can_revive_game_module) && ![[level.can_revive_game_module]](revivee))
	{
		return false;
	}
	ignore_sight_checks = 0;
	ignore_touch_checks = 0;
	if(isdefined(level.revive_trigger_should_ignore_sight_checks))
	{
		ignore_sight_checks = [[level.revive_trigger_should_ignore_sight_checks]](self);
		if(ignore_sight_checks && isdefined(revivee.revivetrigger.beingrevived) && revivee.revivetrigger.beingrevived == 1)
		{
			ignore_touch_checks = 1;
		}
	}
	if(!ignore_touch_checks)
	{
		if(!self istouching(revivee.revivetrigger))
		{
			return false;
		}
	}
	if(!ignore_sight_checks)
	{
		if(!self is_facing(revivee, 0.8))
		{
			return false;
		}
		if(!sighttracepassed(self.origin + vectorscale((0, 0, 1), 50), revivee.origin + vectorscale((0, 0, 1), 30), 0, undefined))
		{
			return false;
		}
		if(!bullettracepassed(self.origin + vectorscale((0, 0, 1), 50), revivee.origin + vectorscale((0, 0, 1), 30), 0, undefined))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: is_reviving
	Namespace: laststand
	Checksum: 0x59900967
	Offset: 0x3198
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function is_reviving(revivee)
{
	return self usebuttonpressed() && can_revive(revivee);
}

/*
	Name: is_reviving_any
	Namespace: laststand
	Checksum: 0x5FE0804A
	Offset: 0x31E0
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function is_reviving_any()
{
	return isdefined(self.is_reviving_any) && self.is_reviving_any;
}

/*
	Name: revive_do_revive
	Namespace: laststand
	Checksum: 0x89711EBD
	Offset: 0x3200
	Size: 0x638
	Parameters: 2
	Flags: Linked
*/
function revive_do_revive(playerbeingrevived, revivergun)
{
	/#
		assert(self is_reviving(playerbeingrevived));
	#/
	revivetime = getdvarfloat("g_reviveTime", 3);
	if(self hasperk("specialty_quickrevive"))
	{
		revivetime = revivetime / 2;
	}
	timer = 0;
	revived = 0;
	playerbeingrevived.revivetrigger.beingrevived = 1;
	playerbeingrevived.revive_hud settext(&"COOP_PLAYER_IS_REVIVING_YOU", self);
	playerbeingrevived revive_hud_show_n_fade(3);
	playerbeingrevived.revivetrigger sethintstring("");
	if(isplayer(playerbeingrevived))
	{
		playerbeingrevived startrevive(self);
	}
	if(0 && !isdefined(self.reviveprogressbar))
	{
		self.reviveprogressbar = self hud::createprimaryprogressbar();
	}
	if(!isdefined(self.revivetexthud))
	{
		self.revivetexthud = newclienthudelem(self);
	}
	self cybercom::cybercom_armpulse(2);
	self thread laststand_clean_up_on_interrupt(playerbeingrevived, revivergun);
	if(!isdefined(self.is_reviving_any))
	{
		self.is_reviving_any = 0;
	}
	self.is_reviving_any++;
	self thread laststand_clean_up_reviving_any(playerbeingrevived);
	if(isdefined(self.reviveprogressbar))
	{
		self.reviveprogressbar hud::updatebar(0.01, 1 / revivetime);
	}
	self.revivetexthud.alignx = "center";
	self.revivetexthud.aligny = "middle";
	self.revivetexthud.horzalign = "center";
	self.revivetexthud.vertalign = "bottom";
	self.revivetexthud.y = -113;
	if(self issplitscreen())
	{
		self.revivetexthud.y = -347;
	}
	self.revivetexthud.foreground = 1;
	self.revivetexthud.font = "default";
	self.revivetexthud.fontscale = 1.8;
	self.revivetexthud.alpha = 1;
	self.revivetexthud.color = (1, 1, 1);
	self.revivetexthud.hidewheninmenu = 1;
	self.revivetexthud settext(&"COOP_REVIVING");
	self thread check_for_failed_revive(playerbeingrevived);
	self playlocalsound("chr_revive_start");
	while(self is_reviving(playerbeingrevived))
	{
		wait(0.05);
		timer = timer + 0.05;
		if(self player_is_in_laststand())
		{
			break;
		}
		if(isdefined(playerbeingrevived.revivetrigger.auto_revive) && playerbeingrevived.revivetrigger.auto_revive == 1)
		{
			break;
		}
		if(timer >= revivetime)
		{
			revived = 1;
			if(!isdefined(self.revives) || self.revives <= 10)
			{
				scoreevents::processscoreevent("player_did_revived", self);
			}
			break;
		}
	}
	self playlocalsound("chr_revive_end");
	if(isdefined(self.reviveprogressbar))
	{
		self.reviveprogressbar hud::destroyelem();
	}
	if(isdefined(self.revivetexthud))
	{
		self.revivetexthud destroy();
	}
	if(isdefined(playerbeingrevived.revivetrigger.auto_revive) && playerbeingrevived.revivetrigger.auto_revive == 1)
	{
	}
	else if(!revived)
	{
		if(isplayer(playerbeingrevived))
		{
			playerbeingrevived stoprevive(self);
		}
	}
	playerbeingrevived.revivetrigger sethintstring(&"COOP_BUTTON_TO_REVIVE_PLAYER");
	playerbeingrevived.revivetrigger.beingrevived = 0;
	self notify(#"do_revive_ended_normally");
	self.is_reviving_any--;
	if(!revived)
	{
		playerbeingrevived thread checkforbleedout(self);
	}
	return revived;
}

/*
	Name: checkforbleedout
	Namespace: laststand
	Checksum: 0x7FA89FF8
	Offset: 0x3840
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function checkforbleedout(player)
{
	self endon(#"player_revived");
	self endon(#"player_suicide");
	self endon(#"disconnect");
	player endon(#"disconnect");
	player notify(#"player_failed_revive");
}

/*
	Name: auto_revive_on_notify
	Namespace: laststand
	Checksum: 0xCCCB16AA
	Offset: 0x3898
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function auto_revive_on_notify()
{
	self endon(#"player_revived");
	self waittill(#"auto_revive", reviver, dont_enable_weapons);
	auto_revive(reviver, dont_enable_weapons);
}

/*
	Name: auto_revive
	Namespace: laststand
	Checksum: 0xDF95879E
	Offset: 0x38F0
	Size: 0x352
	Parameters: 2
	Flags: Linked
*/
function auto_revive(reviver, dont_enable_weapons)
{
	if(isdefined(self.revivetrigger))
	{
		self.revivetrigger.auto_revive = 1;
		if(self.revivetrigger.beingrevived == 1)
		{
			while(true)
			{
				if(self.revivetrigger.beingrevived == 0)
				{
					break;
				}
				util::wait_network_frame();
			}
		}
		self.revivetrigger.auto_trigger = 0;
	}
	self reviveplayer();
	self clientfield::set_to_player("sndHealth", 0);
	self notify(#"stop_revive_trigger");
	if(isdefined(self.revivetrigger))
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}
	self cleanup_suicide_hud();
	if(!isdefined(dont_enable_weapons) || dont_enable_weapons == 0)
	{
		self laststand_enable_player_weapons();
	}
	self allowjump(1);
	self.ignoreme = 0;
	self disableinvulnerability();
	self.laststand = undefined;
	self util::show_hud(1);
	self lui::screen_close_menu();
	if(!(isdefined(level.isresetting_grief) && level.isresetting_grief))
	{
		if(isdefined(reviver))
		{
			if(isplayer(reviver) && isdefined(getrootmapname()))
			{
				reviver addplayerstat("REVIVES", 1);
				var_8642deaf = reviver getdstat("PlayerStatsList", "REVIVES", "statValue");
				reviver setnoncheckpointdata("REVIVES", var_8642deaf);
				reviver.revives = var_8642deaf - reviver getdstat("PlayerStatsByMap", getrootmapname(), "currentStats", "REVIVES");
				/#
					assert(reviver.revives > 0);
				#/
				reviver.pers["revives"] = reviver.revives;
			}
		}
	}
	self notify(#"player_revived", reviver);
}

/*
	Name: remote_revive
	Namespace: laststand
	Checksum: 0x7C831957
	Offset: 0x3C50
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function remote_revive(reviver)
{
	if(!self player_is_in_laststand())
	{
		return;
	}
	self auto_revive(reviver);
}

/*
	Name: revive_success
	Namespace: laststand
	Checksum: 0x8B1AB81E
	Offset: 0x3CA0
	Size: 0x364
	Parameters: 2
	Flags: Linked
*/
function revive_success(reviver, b_track_stats = 1)
{
	if(!isplayer(self))
	{
		self notify(#"player_revived", reviver);
		return;
	}
	if(isdefined(b_track_stats) && b_track_stats)
	{
		demo::bookmark("player_revived", gettime(), reviver, self);
	}
	if(isplayer(self))
	{
		self allowjump(1);
	}
	self.laststand = undefined;
	self notify(#"player_revived", reviver);
	bb::logplayermapnotification("player_revived", self);
	self reviveplayer();
	if(isplayer(reviver) && isdefined(getrootmapname()))
	{
		reviver addplayerstat("REVIVES", 1);
		var_8642deaf = reviver getdstat("PlayerStatsList", "REVIVES", "statValue");
		reviver setnoncheckpointdata("REVIVES", var_8642deaf);
		reviver.revives = var_8642deaf - reviver getdstat("PlayerStatsByMap", getrootmapname(), "currentStats", "REVIVES");
		/#
			assert(reviver.revives > 0);
		#/
		reviver.pers["revives"] = reviver.revives;
	}
	reviver.upgrade_fx_origin = self.origin;
	if(isdefined(b_track_stats) && b_track_stats)
	{
		reviver thread check_for_sacrifice();
	}
	self clientfield::set_to_player("sndHealth", 0);
	self.revivetrigger delete();
	self.revivetrigger = undefined;
	self cleanup_suicide_hud();
	self laststand_enable_player_weapons();
	self lui::screen_close_menu();
	self.ignoreme = 0;
	self disableinvulnerability();
	self util::show_hud(1);
}

/*
	Name: revive_force_revive
	Namespace: laststand
	Checksum: 0xB644743C
	Offset: 0x4010
	Size: 0x8C
	Parameters: 1
	Flags: None
*/
function revive_force_revive(reviver)
{
	/#
		assert(isdefined(self));
	#/
	/#
		assert(isplayer(self));
	#/
	/#
		assert(self player_is_in_laststand());
	#/
	self thread revive_success(reviver);
}

/*
	Name: revive_hud_think
	Namespace: laststand
	Checksum: 0x3C63FE80
	Offset: 0x40A8
	Size: 0x2AC
	Parameters: 0
	Flags: Linked
*/
function revive_hud_think()
{
	level endon(#"game_ended");
	while(true)
	{
		wait(0.1);
		if(!player_any_player_in_laststand())
		{
			continue;
		}
		revived = 0;
		foreach(team in level.teams)
		{
			playertorevive = undefined;
			foreach(player in level.aliveplayers[team])
			{
				if(!isdefined(player.revivetrigger) || !isdefined(player.revivetrigger.createtime))
				{
					continue;
				}
				if(!isdefined(playertorevive) || playertorevive.revivetrigger.createtime > player.revivetrigger.createtime)
				{
					playertorevive = player;
				}
			}
			if(isdefined(playertorevive))
			{
				foreach(player in level.aliveplayers[team])
				{
					if(player player_is_in_laststand())
					{
						continue;
					}
					player thread faderevivemessageover(playertorevive, 3);
				}
				playertorevive.revivetrigger.createtime = undefined;
				revived = 1;
			}
		}
		if(revived)
		{
			wait(3.5);
		}
	}
}

/*
	Name: faderevivemessageover
	Namespace: laststand
	Checksum: 0xD3AE4C7E
	Offset: 0x4360
	Size: 0x90
	Parameters: 2
	Flags: Linked
*/
function faderevivemessageover(playertorevive, time)
{
	revive_hud_show();
	self.revive_hud.hidewheninkillcam = 1;
	self.revive_hud settext(&"COOP_PLAYER_NEEDS_TO_BE_REVIVED", playertorevive);
	self.revive_hud fadeovertime(time);
	self.revive_hud.alpha = 0;
}

/*
	Name: laststand_getup
	Namespace: laststand
	Checksum: 0x8FD0A96
	Offset: 0x43F8
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function laststand_getup()
{
	self endon(#"player_revived");
	self endon(#"disconnect");
	/#
		println("");
	#/
	self update_lives_remaining(0);
	self clientfield::set_to_player("sndHealth", 2);
	self.laststand_info.getup_bar_value = 0.5;
	self thread laststand_getup_hud();
	self thread laststand_getup_damage_watcher();
	while(self.laststand_info.getup_bar_value < 1)
	{
		self.laststand_info.getup_bar_value = self.laststand_info.getup_bar_value + 0.0025;
		wait(0.05);
	}
	self auto_revive(self);
	bb::logplayermapnotification("last_stand_getup", self);
	self clientfield::set_to_player("sndHealth", 0);
}

/*
	Name: check_for_sacrifice
	Namespace: laststand
	Checksum: 0x5FFC96A5
	Offset: 0x4550
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function check_for_sacrifice()
{
	self util::delay_notify("sacrifice_denied", 1);
	self endon(#"sacrifice_denied");
	self waittill(#"player_downed");
}

/*
	Name: check_for_failed_revive
	Namespace: laststand
	Checksum: 0xF15870C9
	Offset: 0x4598
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function check_for_failed_revive(playerbeingrevived)
{
	self endon(#"disconnect");
	playerbeingrevived endon(#"disconnect");
	playerbeingrevived endon(#"player_suicide");
	self notify(#"checking_for_failed_revive");
	self endon(#"checking_for_failed_revive");
	playerbeingrevived endon(#"player_revived");
	playerbeingrevived waittill(#"bled_out");
}

/*
	Name: add_weighted_down
	Namespace: laststand
	Checksum: 0x98B22813
	Offset: 0x4608
	Size: 0x8C
	Parameters: 0
	Flags: None
*/
function add_weighted_down()
{
	weighted_down = 1000;
	if(level.round_number > 0)
	{
		weighted_down = int(1000 / (ceil(level.round_number / 5)));
	}
	self addplayerstat("weighted_downs", weighted_down);
}

/*
	Name: update_regen_widget
	Namespace: laststand
	Checksum: 0xDD41C149
	Offset: 0x46A0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function update_regen_widget(duration, eventtoendon)
{
	level endon(eventtoendon);
	self healthoverlay::update_regen_delay_progress(duration);
}

/*
	Name: wait_and_revive
	Namespace: laststand
	Checksum: 0x1A2B9B7D
	Offset: 0x46E0
	Size: 0x2BC
	Parameters: 1
	Flags: Linked
*/
function wait_and_revive(emergency_reserve = 0)
{
	self endon(#"disconnect");
	self endon(#"death");
	level flag::set("wait_and_revive");
	if(isdefined(self.waiting_to_revive) && self.waiting_to_revive == 1)
	{
		return;
	}
	self.waiting_to_revive = 1;
	solo_revive_time = 10;
	bleedout_time = getdvarfloat("player_lastStandBleedoutTime");
	if(bleedout_time <= solo_revive_time)
	{
		solo_revive_time = bleedout_time * 0.5;
	}
	if(isdefined(emergency_reserve) && emergency_reserve)
	{
		if(level.players.size == 1)
		{
			self.revive_hud settext(&"COOP_REVIVE_EMERGENCY_RESERVE_ONCE");
		}
		else
		{
			self.revive_hud settext(&"COOP_REVIVE_EMERGENCY_RESERVE");
		}
	}
	self startrevive(self);
	self revive_hud_show_n_fade(solo_revive_time);
	self thread update_regen_widget(solo_revive_time, "instant_revive");
	level flag::wait_till_timeout(solo_revive_time, "instant_revive");
	self stoprevive(self);
	self.lastregendelayprogress = 1;
	self setcontrolleruimodelvalue("hudItems.regenDelayProgress", 1);
	if(level flag::get("instant_revive"))
	{
		self revive_hud_show_n_fade(1);
	}
	level flag::clear("wait_and_revive");
	self auto_revive(self);
	self.lives--;
	/#
		if(isdefined(self.infinite_solo_revives) && self.infinite_solo_revives)
		{
			self.lives = level.numlives;
		}
	#/
	self.waiting_to_revive = 0;
}

/*
	Name: remote_revive_watch
	Namespace: laststand
	Checksum: 0xB07D7281
	Offset: 0x49A8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function remote_revive_watch()
{
	self endon(#"death");
	self endon(#"player_revived");
	keep_checking = 1;
	while(keep_checking)
	{
		self waittill(#"remote_revive", reviver);
		if(reviver.team == self.team)
		{
			keep_checking = 0;
		}
	}
	self remote_revive(reviver);
}

/*
	Name: player_laststand
	Namespace: laststand
	Checksum: 0xA444627F
	Offset: 0x4A40
	Size: 0x12C
	Parameters: 9
	Flags: Linked
*/
function player_laststand(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	b_alt_visionset = 0;
	self allowjump(0);
	currweapon = self getcurrentweapon();
	statweapon = currweapon;
	if(isdefined(self.lives) && self.lives > 0)
	{
		self thread wait_and_revive(self hascybercomrig("cybercom_emergencyreserve") != 0);
	}
	self thread remote_revive_watch();
	self disableoffhandweapons();
}

