// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\_oob;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_smokegrenade;

#namespace resurrect;

/*
	Name: __init__sytem__
	Namespace: resurrect
	Checksum: 0x1B73E12D
	Offset: 0x4C8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_resurrect", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: resurrect
	Checksum: 0x600F0A12
	Offset: 0x508
	Size: 0x2B4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "resurrecting", 1, 1, "int");
	clientfield::register("toplayer", "resurrect_state", 1, 2, "int");
	clientfield::register("clientuimodel", "hudItems.rejack.activationWindowEntered", 1, 1, "int");
	clientfield::register("clientuimodel", "hudItems.rejack.rejackActivated", 1, 1, "int");
	ability_player::register_gadget_activation_callbacks(40, &gadget_resurrect_on, &gadget_resurrect_off);
	ability_player::register_gadget_possession_callbacks(40, &gadget_resurrect_on_give, &gadget_resurrect_on_take);
	ability_player::register_gadget_flicker_callbacks(40, &gadget_resurrect_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(40, &gadget_resurrect_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(40, &gadget_resurrect_is_flickering);
	ability_player::register_gadget_primed_callbacks(40, &gadget_resurrect_is_primed);
	ability_player::register_gadget_ready_callbacks(40, &gadget_resurrect_is_ready);
	callback::on_connect(&gadget_resurrect_on_connect);
	callback::on_spawned(&gadget_resurrect_on_spawned);
	if(!isdefined(level.vsmgr_prio_visionset_resurrect))
	{
		level.vsmgr_prio_visionset_resurrect = 62;
	}
	if(!isdefined(level.vsmgr_prio_visionset_resurrect_up))
	{
		level.vsmgr_prio_visionset_resurrect_up = 63;
	}
	visionset_mgr::register_info("visionset", "resurrect", 1, level.vsmgr_prio_visionset_resurrect, 16, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
	visionset_mgr::register_info("visionset", "resurrect_up", 1, level.vsmgr_prio_visionset_resurrect_up, 16, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
}

/*
	Name: gadget_resurrect_is_inuse
	Namespace: resurrect
	Checksum: 0xB640E3A
	Offset: 0x7C8
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_resurrect_is_inuse(slot)
{
	return self gadgetisactive(slot);
}

/*
	Name: gadget_resurrect_is_flickering
	Namespace: resurrect
	Checksum: 0x72462163
	Offset: 0x7F8
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_resurrect_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: gadget_resurrect_on_flicker
	Namespace: resurrect
	Checksum: 0x8C03C3A9
	Offset: 0x828
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_resurrect_on_flicker(slot, weapon)
{
}

/*
	Name: gadget_resurrect_on_give
	Namespace: resurrect
	Checksum: 0x64C8AC0E
	Offset: 0x848
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function gadget_resurrect_on_give(slot, weapon)
{
	self.usedresurrect = 0;
	self.resurrect_weapon = weapon;
}

/*
	Name: gadget_resurrect_on_take
	Namespace: resurrect
	Checksum: 0xEE7E0715
	Offset: 0x880
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function gadget_resurrect_on_take(slot, weapon)
{
	self.overrideplayerdeadstatus = undefined;
	self.resurrect_weapon = undefined;
	self.secondarydeathcamtime = undefined;
	self notify(#"resurrect_taken");
}

/*
	Name: gadget_resurrect_on_spawned
	Namespace: resurrect
	Checksum: 0xC8E4F6EC
	Offset: 0x8C8
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function gadget_resurrect_on_spawned()
{
	self clientfield::set_player_uimodel("hudItems.rejack.activationWindowEntered", 0);
	self util::show_hud(1);
	self._disable_proximity_alarms = 0;
	self flagsys::clear("gadget_resurrect_ready");
	self flagsys::clear("gadget_resurrect_pending");
	if(self flagsys::get("gadget_resurrect_activated"))
	{
		self thread do_resurrected_on_spawned_player_fx();
		self thread resurrect_drain_power();
		self flagsys::clear("gadget_resurrect_activated");
	}
}

/*
	Name: resurrect_drain_power
	Namespace: resurrect
	Checksum: 0x62A9156A
	Offset: 0x9C8
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function resurrect_drain_power(amount)
{
	if(isdefined(self.resurrect_weapon))
	{
		slot = self gadgetgetslot(self.resurrect_weapon);
		if(slot >= 0 && slot < 3)
		{
			if(isdefined(amount))
			{
				self gadgetpowerchange(slot, amount);
			}
			else
			{
				self gadgetstatechange(slot, self.resurrect_weapon, 3);
			}
		}
	}
}

/*
	Name: gadget_resurrect_on_connect
	Namespace: resurrect
	Checksum: 0x99EC1590
	Offset: 0xA80
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function gadget_resurrect_on_connect()
{
}

/*
	Name: gadget_resurrect_on
	Namespace: resurrect
	Checksum: 0x2FE851A7
	Offset: 0xA90
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_resurrect_on(slot, weapon)
{
}

/*
	Name: watch_smoke_detonate
	Namespace: resurrect
	Checksum: 0xABD75B48
	Offset: 0xAB0
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function watch_smoke_detonate()
{
	self endon(#"player_input_suicide");
	self endon(#"player_input_revive");
	self endon(#"disconnect");
	self endon(#"death");
	level endon(#"game_ended");
	while(true)
	{
		if(self isplayerswimming() || self isonground() && !self iswallrunning() && !self istraversing())
		{
			smoke_weapon = getweapon("gadget_resurrect_smoke_grenade");
			stat_weapon = getweapon("gadget_resurrect");
			smokeeffect = smokegrenade::smokedetonate(self, stat_weapon, smoke_weapon, self.origin, 128, 5, 4);
			smokeeffect thread watch_smoke_effect_watch_suicide(self);
			smokeeffect thread watch_smoke_effect_watch_resurrect(self);
			smokeeffect thread watch_smoke_death(self);
			return;
		}
		wait(0.05);
	}
}

/*
	Name: watch_smoke_death
	Namespace: resurrect
	Checksum: 0xE13C0E20
	Offset: 0xC50
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function watch_smoke_death(player)
{
	self endon(#"death");
	player util::waittill_any_timeout(5, "disconnect", "death");
	self delete();
}

/*
	Name: watch_smoke_effect_watch_suicide
	Namespace: resurrect
	Checksum: 0x7C758B5C
	Offset: 0xCB0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function watch_smoke_effect_watch_suicide(player)
{
	self endon(#"death");
	player waittill(#"player_input_suicide");
	self delete();
}

/*
	Name: watch_smoke_effect_watch_resurrect
	Namespace: resurrect
	Checksum: 0x47E7833
	Offset: 0xCF8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function watch_smoke_effect_watch_resurrect(player)
{
	self endon(#"death");
	player waittill(#"player_input_revive");
	wait(0.5);
	self delete();
}

/*
	Name: gadget_resurrect_is_primed
	Namespace: resurrect
	Checksum: 0x4DFBA0D8
	Offset: 0xD48
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function gadget_resurrect_is_primed(slot, weapon)
{
	if(isdefined(self.resurrect_not_allowed_by))
	{
		return;
	}
	self startresurrectviewangletransition();
	self.lastwaterdamagetime = gettime();
	self._disable_proximity_alarms = 1;
	self thread watch_smoke_detonate();
	self util::show_hud(0);
	visionset_mgr::activate("visionset", "resurrect", self, 1.4, 4, 0.25);
	self clientfield::set_to_player("resurrect_state", 1);
	self shellshock("resurrect", 5.4, 0);
}

/*
	Name: gadget_resurrect_is_ready
	Namespace: resurrect
	Checksum: 0x9B22978C
	Offset: 0xE50
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_resurrect_is_ready(slot, weapon)
{
}

/*
	Name: gadget_resurrect_start
	Namespace: resurrect
	Checksum: 0x77D530BE
	Offset: 0xEC8
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function gadget_resurrect_start(slot, weapon)
{
	wait(0.1);
	self gadgetsetactivatetime(slot, gettime());
	self thread resurrect_delay(weapon);
}

/*
	Name: gadget_resurrect_off
	Namespace: resurrect
	Checksum: 0x7A8A4A47
	Offset: 0xF20
	Size: 0x22
	Parameters: 2
	Flags: Linked
*/
function gadget_resurrect_off(slot, weapon)
{
	self notify(#"gadget_resurrect_off");
}

/*
	Name: resurrect_delay
	Namespace: resurrect
	Checksum: 0xFE444CCC
	Offset: 0xF50
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function resurrect_delay(weapon)
{
	self endon(#"disconnect");
	self endon(#"game_ended");
	self endon(#"death");
	self notify(#"resurrect_delay");
	self endon(#"resurrect_delay");
}

/*
	Name: overridespawn
	Namespace: resurrect
	Checksum: 0x47B37B66
	Offset: 0xFA0
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function overridespawn(ispredictedspawn)
{
	if(!self flagsys::get("gadget_resurrect_ready"))
	{
		return false;
	}
	if(!self flagsys::get("gadget_resurrect_activated"))
	{
		return false;
	}
	if(!isdefined(self.resurrect_origin))
	{
		self.resurrect_origin = self.origin;
		self.resurrect_angles = self.angles;
	}
	return true;
}

/*
	Name: is_jumping
	Namespace: resurrect
	Checksum: 0xFD6AC5A1
	Offset: 0x1030
	Size: 0x30
	Parameters: 0
	Flags: None
*/
function is_jumping()
{
	ground_ent = self getgroundent();
	return !isdefined(ground_ent);
}

/*
	Name: player_position_valid
	Namespace: resurrect
	Checksum: 0x9BFEA20F
	Offset: 0x1068
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function player_position_valid()
{
	if(self clientfield::get_to_player("out_of_bounds"))
	{
		return false;
	}
	return true;
}

/*
	Name: resurrect_breadcrumbs
	Namespace: resurrect
	Checksum: 0xBDA7E0BB
	Offset: 0x10A0
	Size: 0xA2
	Parameters: 1
	Flags: Linked
*/
function resurrect_breadcrumbs(slot)
{
	self endon(#"disconnect");
	self endon(#"game_ended");
	self endon(#"resurrect_taken");
	self.resurrect_slot = slot;
	while(true)
	{
		if(isalive(self) && self player_position_valid())
		{
			self.resurrect_origin = self.origin;
			self.resurrect_angles = self.angles;
		}
		wait(1);
	}
}

/*
	Name: glow_for_time
	Namespace: resurrect
	Checksum: 0x59780211
	Offset: 0x1150
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function glow_for_time(time)
{
	self endon(#"disconnect");
	self clientfield::set("resurrecting", 1);
	wait(time);
	self clientfield::set("resurrecting", 0);
}

/*
	Name: wait_for_time
	Namespace: resurrect
	Checksum: 0x69B07D84
	Offset: 0x11B8
	Size: 0x42
	Parameters: 2
	Flags: Linked
*/
function wait_for_time(time, msg)
{
	self endon(#"disconnect");
	self endon(#"game_ended");
	self endon(msg);
	wait(time);
	self notify(msg);
}

/*
	Name: wait_for_activate
	Namespace: resurrect
	Checksum: 0x1C7B62DC
	Offset: 0x1208
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function wait_for_activate(msg)
{
	self endon(#"disconnect");
	self endon(#"game_ended");
	self endon(msg);
	while(true)
	{
		if(self offhandspecialbuttonpressed())
		{
			self flagsys::set("gadget_resurrect_activated");
			self notify(msg);
		}
		wait(0.05);
	}
}

/*
	Name: bot_wait_for_activate
	Namespace: resurrect
	Checksum: 0x657EAD84
	Offset: 0x1290
	Size: 0xB6
	Parameters: 2
	Flags: Linked
*/
function bot_wait_for_activate(msg, time)
{
	self endon(#"disconnect");
	self endon(#"game_ended");
	self endon(msg);
	if(!self util::is_bot())
	{
		return;
	}
	time = int(time + 1);
	randwait = randomint(time);
	wait(randwait);
	self flagsys::set("gadget_resurrect_activated");
	self notify(msg);
}

/*
	Name: do_resurrect_hint_fx
	Namespace: resurrect
	Checksum: 0xE02286C8
	Offset: 0x1350
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function do_resurrect_hint_fx()
{
	offset = vectorscale((0, 0, 1), 40);
	fxorg = spawn("script_model", self.resurrect_origin + offset);
	fxorg setmodel("tag_origin");
	fx = playfxontag("player/fx_plyr_revive", fxorg, "tag_origin");
	self waittill(#"resurrect_time_or_activate");
	fxorg delete();
}

/*
	Name: do_resurrected_on_dead_body_fx
	Namespace: resurrect
	Checksum: 0x4AB8B8B9
	Offset: 0x1420
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function do_resurrected_on_dead_body_fx()
{
	if(isdefined(self.body))
	{
		fx = playfx("player/fx_plyr_revive_demat", self.body.origin);
		self.body notsolid();
		self.body ghost();
	}
}

/*
	Name: do_resurrected_on_spawned_player_fx
	Namespace: resurrect
	Checksum: 0xA59962FC
	Offset: 0x14A8
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function do_resurrected_on_spawned_player_fx()
{
	playsoundatposition("mpl_resurrect_npc", self.origin);
	fx = playfx("player/fx_plyr_rejack_light", self.origin);
}

/*
	Name: resurrect_watch_for_death
	Namespace: resurrect
	Checksum: 0x58DA8D16
	Offset: 0x1500
	Size: 0x24C
	Parameters: 2
	Flags: Linked
*/
function resurrect_watch_for_death(slot, weapon)
{
	self endon(#"disconnect");
	self endon(#"game_ended");
	self waittill(#"death");
	resurrect_time = 3;
	if(isdefined(weapon.gadget_resurrect_duration))
	{
		resurrect_time = weapon.gadget_resurrect_duration / 1000;
	}
	self.usedresurrect = 0;
	self flagsys::clear("gadget_resurrect_activated");
	self flagsys::set("gadget_resurrect_pending");
	self.resurrect_available_time = gettime();
	self thread wait_for_time(resurrect_time, "resurrect_time_or_activate");
	self thread wait_for_activate("resurrect_time_or_activate");
	self thread bot_wait_for_activate("resurrect_time_or_activate", resurrect_time);
	self thread do_resurrect_hint_fx();
	self waittill(#"resurrect_time_or_activate");
	self flagsys::clear("gadget_resurrect_pending");
	if(self flagsys::get("gadget_resurrect_activated"))
	{
		self thread do_resurrected_on_dead_body_fx();
		self notify(#"end_death_delay");
		self notify(#"end_killcam");
		self.cancelkillcam = 1;
		self.usedresurrect = 1;
		self notify(#"end_death_delay");
		self notify(#"force_spawn");
		if(!(isdefined(1) && 1))
		{
			self.pers["resetMomentumOnSpawn"] = 0;
		}
		if(isdefined(level.playgadgetsuccess))
		{
			self [[level.playgadgetsuccess]](weapon, "resurrectSuccessDelay");
		}
	}
}

/*
	Name: gadget_resurrect_delay_updateteamstatus
	Namespace: resurrect
	Checksum: 0x56AE792E
	Offset: 0x1758
	Size: 0x2E
	Parameters: 0
	Flags: None
*/
function gadget_resurrect_delay_updateteamstatus()
{
	if(self flagsys::get("gadget_resurrect_ready"))
	{
		return true;
	}
	return false;
}

/*
	Name: gadget_resurrect_is_player_predead
	Namespace: resurrect
	Checksum: 0x5DF29CD7
	Offset: 0x1790
	Size: 0x70
	Parameters: 0
	Flags: None
*/
function gadget_resurrect_is_player_predead()
{
	should_not_be_dead = 0;
	if(self.sessionstate == "playing" && isalive(self))
	{
		should_not_be_dead = 1;
	}
	if(self flagsys::get("gadget_resurrect_pending"))
	{
		return 1;
	}
	return should_not_be_dead;
}

/*
	Name: gadget_resurrect_secondary_deathcam_time
	Namespace: resurrect
	Checksum: 0x321FC7D4
	Offset: 0x1808
	Size: 0xC6
	Parameters: 0
	Flags: None
*/
function gadget_resurrect_secondary_deathcam_time()
{
	if(self flagsys::get("gadget_resurrect_pending") && isdefined(self.resurrect_available_time))
	{
		resurrect_time = 3000;
		weapon = self.resurrect_weapon;
		if(isdefined(weapon.gadget_resurrect_duration))
		{
			resurrect_time = weapon.gadget_resurrect_duration;
		}
		time_left = resurrect_time - (gettime() - self.resurrect_available_time);
		if(time_left > 0)
		{
			return time_left / 1000;
		}
	}
	return 0;
}

/*
	Name: enter_rejack_standby
	Namespace: resurrect
	Checksum: 0x7F3FFE10
	Offset: 0x18D8
	Size: 0xE4
	Parameters: 0
	Flags: None
*/
function enter_rejack_standby()
{
	self endon(#"disconnect");
	self endon(#"death");
	level endon(#"game_ended");
	self.rejack_activate_requested = 0;
	if(isdefined(level.resetplayerscorestreaks))
	{
		[[level.resetplayerscorestreaks]](self);
	}
	self init_rejack_ui();
	self thread watch_rejack_activate_requested();
	self thread watch_rejack_suicide();
	wait(1.4);
	self thread watch_rejack_activate();
	self thread watch_rejack_timeout();
	self thread watch_bad_trigger_touch();
}

/*
	Name: rejack_suicide
	Namespace: resurrect
	Checksum: 0x83FEA633
	Offset: 0x19C8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function rejack_suicide()
{
	self notify(#"heroability_off");
	visionset_mgr::deactivate("visionset", "resurrect", self);
	self thread remove_rejack_ui();
	self util::show_hud(1);
	player_suicide();
}

/*
	Name: watch_bad_trigger_touch
	Namespace: resurrect
	Checksum: 0x52A3AB80
	Offset: 0x1A48
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function watch_bad_trigger_touch()
{
	self endon(#"player_input_revive");
	self endon(#"player_input_suicide");
	self endon(#"disconnect");
	self endon(#"death");
	level endon(#"game_ended");
	a_killbrushes = getentarray("trigger_hurt", "classname");
	while(true)
	{
		a_killbrushes = getentarray("trigger_hurt", "classname");
		for(i = 0; i < a_killbrushes.size; i++)
		{
			if(self istouching(a_killbrushes[i]))
			{
				if(!a_killbrushes[i] istriggerenabled())
				{
					continue;
				}
				self rejack_suicide();
			}
		}
		if(self oob::istouchinganyoobtrigger())
		{
			self rejack_suicide();
		}
		wait(0.05);
	}
}

/*
	Name: watch_rejack_timeout
	Namespace: resurrect
	Checksum: 0x14DFFD70
	Offset: 0x1BA0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function watch_rejack_timeout()
{
	self endon(#"player_input_revive");
	self endon(#"player_input_suicide");
	self endon(#"disconnect");
	self endon(#"death");
	level endon(#"game_ended");
	wait(4);
	self playsound("mpl_rejack_suicide_timeout");
	self thread resurrect_drain_power(-30);
	self rejack_suicide();
}

/*
	Name: watch_rejack_suicide
	Namespace: resurrect
	Checksum: 0x55E1536B
	Offset: 0x1C40
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function watch_rejack_suicide()
{
	self endon(#"player_input_revive");
	self endon(#"disconnect");
	self endon(#"death");
	level endon(#"game_ended");
	while(self usebuttonpressed())
	{
		wait(1);
	}
	if(isdefined(self.laststand) && self.laststand)
	{
		starttime = gettime();
		while(true)
		{
			if(!self usebuttonpressed())
			{
				starttime = gettime();
			}
			if((starttime + 500) < gettime())
			{
				self rejack_suicide();
				self playsound("mpl_rejack_suicide");
				return;
			}
			wait(0.01);
		}
	}
}

/*
	Name: reload_clip_on_stand
	Namespace: resurrect
	Checksum: 0xBD00A791
	Offset: 0x1D40
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function reload_clip_on_stand()
{
	weapons = self getweaponslistprimaries();
	for(i = 0; i < weapons.size; i++)
	{
		self reloadweaponammo(weapons[i]);
	}
}

/*
	Name: watch_rejack_activate_requested
	Namespace: resurrect
	Checksum: 0x6D975005
	Offset: 0x1DB8
	Size: 0xA8
	Parameters: 0
	Flags: Linked
*/
function watch_rejack_activate_requested()
{
	self endon(#"player_input_suicide");
	self endon(#"player_input_revive");
	self endon(#"disconnect");
	self endon(#"death");
	level endon(#"game_ended");
	while(self offhandspecialbuttonpressed())
	{
		wait(0.05);
	}
	self.rejack_activate_requested = 0;
	while(!self.rejack_activate_requested)
	{
		if(self offhandspecialbuttonpressed())
		{
			self.rejack_activate_requested = 1;
		}
		wait(0.05);
	}
}

/*
	Name: watch_rejack_activate
	Namespace: resurrect
	Checksum: 0x63E5F954
	Offset: 0x1E68
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function watch_rejack_activate()
{
	self endon(#"player_input_suicide");
	self endon(#"disconnect");
	self endon(#"death");
	level endon(#"game_ended");
	if(isdefined(self.laststand) && self.laststand)
	{
		while(true)
		{
			wait(0.05);
			if(isdefined(self.rejack_activate_requested) && self.rejack_activate_requested)
			{
				self notify(#"player_input_revive");
				if(isdefined(level.start_player_health_regen))
				{
					self thread [[level.start_player_health_regen]]();
				}
				self._disable_proximity_alarms = 0;
				self thread do_resurrected_on_spawned_player_fx();
				self thread resurrect_drain_power();
				self thread rejack_ui_activate();
				visionset_mgr::deactivate("visionset", "resurrect", self);
				visionset_mgr::activate("visionset", "resurrect_up", self, 0.35, 0.1, 0.2);
				self clientfield::set_to_player("resurrect_state", 2);
				self stopshellshock();
				self reload_clip_on_stand();
				level notify(#"hero_gadget_activated", self);
				self notify(#"hero_gadget_activated");
				return;
			}
		}
	}
}

/*
	Name: init_rejack_ui
	Namespace: resurrect
	Checksum: 0xDB866984
	Offset: 0x2028
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function init_rejack_ui()
{
	self clientfield::set_player_uimodel("hudItems.rejack.activationWindowEntered", 1);
	self luinotifyevent(&"create_rejack_timer", 1, gettime() + int(4000));
	self clientfield::set_player_uimodel("hudItems.rejack.rejackActivated", 0);
}

/*
	Name: remove_rejack_ui
	Namespace: resurrect
	Checksum: 0xEB13BBE8
	Offset: 0x20B8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function remove_rejack_ui()
{
	self endon(#"disconnect");
	wait(1.5);
	self clientfield::set_player_uimodel("hudItems.rejack.activationWindowEntered", 0);
	self util::show_hud(1);
}

/*
	Name: rejack_ui_activate
	Namespace: resurrect
	Checksum: 0x5EAC87A
	Offset: 0x2110
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function rejack_ui_activate()
{
	self clientfield::set_player_uimodel("hudItems.rejack.rejackActivated", 1);
	self thread remove_rejack_ui();
}

/*
	Name: player_suicide
	Namespace: resurrect
	Checksum: 0x4628CC1E
	Offset: 0x2158
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function player_suicide()
{
	self._disable_proximity_alarms = 0;
	self notify(#"player_input_suicide");
	self clientfield::set_to_player("resurrect_state", 0);
	self thread resurrect_drain_power(-30);
}

