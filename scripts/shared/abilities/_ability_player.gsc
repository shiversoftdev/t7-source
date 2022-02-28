// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\abilities\gadgets\_gadget_active_camo;
#using scripts\shared\abilities\gadgets\_gadget_armor;
#using scripts\shared\abilities\gadgets\_gadget_cacophany;
#using scripts\shared\abilities\gadgets\_gadget_camo;
#using scripts\shared\abilities\gadgets\_gadget_cleanse;
#using scripts\shared\abilities\gadgets\_gadget_clone;
#using scripts\shared\abilities\gadgets\_gadget_combat_efficiency;
#using scripts\shared\abilities\gadgets\_gadget_concussive_wave;
#using scripts\shared\abilities\gadgets\_gadget_es_strike;
#using scripts\shared\abilities\gadgets\_gadget_exo_breakdown;
#using scripts\shared\abilities\gadgets\_gadget_firefly_swarm;
#using scripts\shared\abilities\gadgets\_gadget_flashback;
#using scripts\shared\abilities\gadgets\_gadget_forced_malfunction;
#using scripts\shared\abilities\gadgets\_gadget_heat_wave;
#using scripts\shared\abilities\gadgets\_gadget_hero_weapon;
#using scripts\shared\abilities\gadgets\_gadget_iff_override;
#using scripts\shared\abilities\gadgets\_gadget_immolation;
#using scripts\shared\abilities\gadgets\_gadget_misdirection;
#using scripts\shared\abilities\gadgets\_gadget_mrpukey;
#using scripts\shared\abilities\gadgets\_gadget_other;
#using scripts\shared\abilities\gadgets\_gadget_overdrive;
#using scripts\shared\abilities\gadgets\_gadget_rapid_strike;
#using scripts\shared\abilities\gadgets\_gadget_ravage_core;
#using scripts\shared\abilities\gadgets\_gadget_resurrect;
#using scripts\shared\abilities\gadgets\_gadget_roulette;
#using scripts\shared\abilities\gadgets\_gadget_security_breach;
#using scripts\shared\abilities\gadgets\_gadget_sensory_overload;
#using scripts\shared\abilities\gadgets\_gadget_servo_shortout;
#using scripts\shared\abilities\gadgets\_gadget_shock_field;
#using scripts\shared\abilities\gadgets\_gadget_smokescreen;
#using scripts\shared\abilities\gadgets\_gadget_speed_burst;
#using scripts\shared\abilities\gadgets\_gadget_surge;
#using scripts\shared\abilities\gadgets\_gadget_system_overload;
#using scripts\shared\abilities\gadgets\_gadget_thief;
#using scripts\shared\abilities\gadgets\_gadget_unstoppable_force;
#using scripts\shared\abilities\gadgets\_gadget_vision_pulse;
#using scripts\shared\array_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\replay_gun;

#namespace ability_player;

/*
	Name: __init__sytem__
	Namespace: ability_player
	Checksum: 0x15DADA27
	Offset: 0xBA8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ability_player", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ability_player
	Checksum: 0x1171DEF3
	Offset: 0xBE8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_abilities();
	setup_clientfields();
	level thread gadgets_wait_for_game_end();
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	callback::on_disconnect(&on_player_disconnect);
	if(!isdefined(level._gadgets_level))
	{
		level._gadgets_level = [];
	}
	/#
		level thread abilities_devgui_init();
	#/
}

/*
	Name: init_abilities
	Namespace: ability_player
	Checksum: 0x99EC1590
	Offset: 0xCC0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init_abilities()
{
}

/*
	Name: setup_clientfields
	Namespace: ability_player
	Checksum: 0x99EC1590
	Offset: 0xCD0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function setup_clientfields()
{
}

/*
	Name: on_player_connect
	Namespace: ability_player
	Checksum: 0x47B2A0B0
	Offset: 0xCE0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	if(!isdefined(self._gadgets_player))
	{
		self._gadgets_player = [];
	}
	/#
		self thread abilities_devgui_player_connect();
	#/
}

/*
	Name: on_player_spawned
	Namespace: ability_player
	Checksum: 0xC335CAFA
	Offset: 0xD20
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread gadgets_wait_for_death();
	self.heroabilityactivatetime = undefined;
	self.heroabilitydectivatetime = undefined;
	self.heroabilityactive = undefined;
}

/*
	Name: on_player_disconnect
	Namespace: ability_player
	Checksum: 0x2BD5899D
	Offset: 0xD60
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_disconnect()
{
	/#
		self thread abilities_devgui_player_disconnect();
	#/
}

/*
	Name: is_using_any_gadget
	Namespace: ability_player
	Checksum: 0x67E528A2
	Offset: 0xD88
	Size: 0x70
	Parameters: 0
	Flags: None
*/
function is_using_any_gadget()
{
	if(!isplayer(self))
	{
		return false;
	}
	for(i = 0; i < 3; i++)
	{
		if(self gadget_is_in_use(i))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: gadgets_save_power
	Namespace: ability_player
	Checksum: 0xFDECCBA7
	Offset: 0xE00
	Size: 0x136
	Parameters: 1
	Flags: Linked
*/
function gadgets_save_power(game_ended)
{
	for(slot = 0; slot < 3; slot++)
	{
		if(!isdefined(self._gadgets_player[slot]))
		{
			continue;
		}
		gadgetweapon = self._gadgets_player[slot];
		powerleft = self gadgetpowerchange(slot, 0);
		if(game_ended && gadget_is_in_use(slot))
		{
			self gadgetdeactivate(slot, gadgetweapon);
			if(gadgetweapon.gadget_power_round_end_active_penalty > 0)
			{
				powerleft = powerleft - gadgetweapon.gadget_power_round_end_active_penalty;
				powerleft = max(0, powerleft);
			}
		}
		self.pers["held_gadgets_power"][gadgetweapon] = powerleft;
	}
}

/*
	Name: gadgets_wait_for_death
	Namespace: ability_player
	Checksum: 0x31CAD955
	Offset: 0xF40
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function gadgets_wait_for_death()
{
	self endon(#"disconnect");
	self.pers["held_gadgets_power"] = [];
	self waittill(#"death");
	if(!isdefined(self._gadgets_player))
	{
		return;
	}
	self gadgets_save_power(0);
}

/*
	Name: gadgets_wait_for_game_end
	Namespace: ability_player
	Checksum: 0xAAE251B8
	Offset: 0xFA0
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function gadgets_wait_for_game_end()
{
	level waittill(#"game_ended");
	players = getplayers();
	foreach(player in players)
	{
		if(!isalive(player))
		{
			continue;
		}
		if(!isdefined(player._gadgets_player))
		{
			continue;
		}
		player gadgets_save_power(1);
	}
}

/*
	Name: script_set_cclass
	Namespace: ability_player
	Checksum: 0x4E354DAC
	Offset: 0x1098
	Size: 0x28
	Parameters: 2
	Flags: None
*/
function script_set_cclass(cclass, save = 1)
{
}

/*
	Name: update_gadget
	Namespace: ability_player
	Checksum: 0xEAA6C6C6
	Offset: 0x10C8
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function update_gadget(weapon)
{
}

/*
	Name: register_gadget
	Namespace: ability_player
	Checksum: 0x6C63B481
	Offset: 0x10E0
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function register_gadget(type)
{
	if(!isdefined(level._gadgets_level))
	{
		level._gadgets_level = [];
	}
	if(!isdefined(level._gadgets_level[type]))
	{
		level._gadgets_level[type] = spawnstruct();
		level._gadgets_level[type].should_notify = 1;
	}
}

/*
	Name: register_gadget_should_notify
	Namespace: ability_player
	Checksum: 0x58A8BC5D
	Offset: 0x1160
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function register_gadget_should_notify(type, should_notify)
{
	register_gadget(type);
	if(isdefined(should_notify))
	{
		level._gadgets_level[type].should_notify = should_notify;
	}
}

/*
	Name: register_gadget_possession_callbacks
	Namespace: ability_player
	Checksum: 0x16CF01D6
	Offset: 0x11C0
	Size: 0x272
	Parameters: 3
	Flags: Linked
*/
function register_gadget_possession_callbacks(type, on_give, on_take)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].on_give))
	{
		level._gadgets_level[type].on_give = [];
	}
	if(!isdefined(level._gadgets_level[type].on_take))
	{
		level._gadgets_level[type].on_take = [];
	}
	if(isdefined(on_give))
	{
		if(!isdefined(level._gadgets_level[type].on_give))
		{
			level._gadgets_level[type].on_give = [];
		}
		else if(!isarray(level._gadgets_level[type].on_give))
		{
			level._gadgets_level[type].on_give = array(level._gadgets_level[type].on_give);
		}
		level._gadgets_level[type].on_give[level._gadgets_level[type].on_give.size] = on_give;
	}
	if(isdefined(on_take))
	{
		if(!isdefined(level._gadgets_level[type].on_take))
		{
			level._gadgets_level[type].on_take = [];
		}
		else if(!isarray(level._gadgets_level[type].on_take))
		{
			level._gadgets_level[type].on_take = array(level._gadgets_level[type].on_take);
		}
		level._gadgets_level[type].on_take[level._gadgets_level[type].on_take.size] = on_take;
	}
}

/*
	Name: register_gadget_activation_callbacks
	Namespace: ability_player
	Checksum: 0x39D1228D
	Offset: 0x1440
	Size: 0x272
	Parameters: 3
	Flags: Linked
*/
function register_gadget_activation_callbacks(type, turn_on, turn_off)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].turn_on))
	{
		level._gadgets_level[type].turn_on = [];
	}
	if(!isdefined(level._gadgets_level[type].turn_off))
	{
		level._gadgets_level[type].turn_off = [];
	}
	if(isdefined(turn_on))
	{
		if(!isdefined(level._gadgets_level[type].turn_on))
		{
			level._gadgets_level[type].turn_on = [];
		}
		else if(!isarray(level._gadgets_level[type].turn_on))
		{
			level._gadgets_level[type].turn_on = array(level._gadgets_level[type].turn_on);
		}
		level._gadgets_level[type].turn_on[level._gadgets_level[type].turn_on.size] = turn_on;
	}
	if(isdefined(turn_off))
	{
		if(!isdefined(level._gadgets_level[type].turn_off))
		{
			level._gadgets_level[type].turn_off = [];
		}
		else if(!isarray(level._gadgets_level[type].turn_off))
		{
			level._gadgets_level[type].turn_off = array(level._gadgets_level[type].turn_off);
		}
		level._gadgets_level[type].turn_off[level._gadgets_level[type].turn_off.size] = turn_off;
	}
}

/*
	Name: register_gadget_flicker_callbacks
	Namespace: ability_player
	Checksum: 0x4130076E
	Offset: 0x16C0
	Size: 0x14A
	Parameters: 2
	Flags: Linked
*/
function register_gadget_flicker_callbacks(type, on_flicker)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].on_flicker))
	{
		level._gadgets_level[type].on_flicker = [];
	}
	if(isdefined(on_flicker))
	{
		if(!isdefined(level._gadgets_level[type].on_flicker))
		{
			level._gadgets_level[type].on_flicker = [];
		}
		else if(!isarray(level._gadgets_level[type].on_flicker))
		{
			level._gadgets_level[type].on_flicker = array(level._gadgets_level[type].on_flicker);
		}
		level._gadgets_level[type].on_flicker[level._gadgets_level[type].on_flicker.size] = on_flicker;
	}
}

/*
	Name: register_gadget_ready_callbacks
	Namespace: ability_player
	Checksum: 0xD6638E12
	Offset: 0x1818
	Size: 0x14A
	Parameters: 2
	Flags: Linked
*/
function register_gadget_ready_callbacks(type, ready_func)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].on_ready))
	{
		level._gadgets_level[type].on_ready = [];
	}
	if(isdefined(ready_func))
	{
		if(!isdefined(level._gadgets_level[type].on_ready))
		{
			level._gadgets_level[type].on_ready = [];
		}
		else if(!isarray(level._gadgets_level[type].on_ready))
		{
			level._gadgets_level[type].on_ready = array(level._gadgets_level[type].on_ready);
		}
		level._gadgets_level[type].on_ready[level._gadgets_level[type].on_ready.size] = ready_func;
	}
}

/*
	Name: register_gadget_primed_callbacks
	Namespace: ability_player
	Checksum: 0x5425F352
	Offset: 0x1970
	Size: 0x14A
	Parameters: 2
	Flags: Linked
*/
function register_gadget_primed_callbacks(type, primed_func)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].on_primed))
	{
		level._gadgets_level[type].on_primed = [];
	}
	if(isdefined(primed_func))
	{
		if(!isdefined(level._gadgets_level[type].on_primed))
		{
			level._gadgets_level[type].on_primed = [];
		}
		else if(!isarray(level._gadgets_level[type].on_primed))
		{
			level._gadgets_level[type].on_primed = array(level._gadgets_level[type].on_primed);
		}
		level._gadgets_level[type].on_primed[level._gadgets_level[type].on_primed.size] = primed_func;
	}
}

/*
	Name: register_gadget_is_inuse_callbacks
	Namespace: ability_player
	Checksum: 0x5FD2674E
	Offset: 0x1AC8
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function register_gadget_is_inuse_callbacks(type, inuse_func)
{
	register_gadget(type);
	if(isdefined(inuse_func))
	{
		level._gadgets_level[type].isinuse = inuse_func;
	}
}

/*
	Name: register_gadget_is_flickering_callbacks
	Namespace: ability_player
	Checksum: 0x7814EF64
	Offset: 0x1B28
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function register_gadget_is_flickering_callbacks(type, flickering_func)
{
	register_gadget(type);
	if(isdefined(flickering_func))
	{
		level._gadgets_level[type].isflickering = flickering_func;
	}
}

/*
	Name: register_gadget_failed_activate_callback
	Namespace: ability_player
	Checksum: 0x871D9F5E
	Offset: 0x1B88
	Size: 0x14A
	Parameters: 2
	Flags: None
*/
function register_gadget_failed_activate_callback(type, failed_activate)
{
	register_gadget(type);
	if(!isdefined(level._gadgets_level[type].failed_activate))
	{
		level._gadgets_level[type].failed_activate = [];
	}
	if(isdefined(failed_activate))
	{
		if(!isdefined(level._gadgets_level[type].failed_activate))
		{
			level._gadgets_level[type].failed_activate = [];
		}
		else if(!isarray(level._gadgets_level[type].failed_activate))
		{
			level._gadgets_level[type].failed_activate = array(level._gadgets_level[type].failed_activate);
		}
		level._gadgets_level[type].failed_activate[level._gadgets_level[type].failed_activate.size] = failed_activate;
	}
}

/*
	Name: gadget_is_in_use
	Namespace: ability_player
	Checksum: 0x4336353A
	Offset: 0x1CE0
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function gadget_is_in_use(slot)
{
	if(isdefined(self._gadgets_player[slot]))
	{
		if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
		{
			if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].isinuse))
			{
				return self [[level._gadgets_level[self._gadgets_player[slot].gadget_type].isinuse]](slot);
			}
		}
	}
	return self gadgetisactive(slot);
}

/*
	Name: gadget_is_flickering
	Namespace: ability_player
	Checksum: 0xCCC9FBCA
	Offset: 0x1DB8
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function gadget_is_flickering(slot)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return 0;
	}
	if(!isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].isflickering))
	{
		return 0;
	}
	return self [[level._gadgets_level[self._gadgets_player[slot].gadget_type].isflickering]](slot);
}

/*
	Name: give_gadget
	Namespace: ability_player
	Checksum: 0x92DF06EF
	Offset: 0x1E50
	Size: 0x22C
	Parameters: 2
	Flags: Linked
*/
function give_gadget(slot, weapon)
{
	if(isdefined(self._gadgets_player[slot]))
	{
		self take_gadget(slot, self._gadgets_player[slot]);
	}
	for(eslot = 0; eslot < 3; eslot++)
	{
		existinggadget = self._gadgets_player[eslot];
		if(isdefined(existinggadget) && existinggadget == weapon)
		{
			self take_gadget(eslot, existinggadget);
		}
	}
	self._gadgets_player[slot] = weapon;
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].on_give))
		{
			foreach(on_give in level._gadgets_level[self._gadgets_player[slot].gadget_type].on_give)
			{
				self [[on_give]](slot, weapon);
			}
		}
	}
	if(sessionmodeismultiplayergame())
	{
		self.heroabilityname = (isdefined(weapon) ? weapon.name : undefined);
	}
}

/*
	Name: take_gadget
	Namespace: ability_player
	Checksum: 0x673409B5
	Offset: 0x2088
	Size: 0x138
	Parameters: 2
	Flags: Linked
*/
function take_gadget(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].on_take))
		{
			foreach(on_take in level._gadgets_level[self._gadgets_player[slot].gadget_type].on_take)
			{
				self [[on_take]](slot, weapon);
			}
		}
	}
	self._gadgets_player[slot] = undefined;
}

/*
	Name: turn_gadget_on
	Namespace: ability_player
	Checksum: 0x9EEFB215
	Offset: 0x21C8
	Size: 0x304
	Parameters: 2
	Flags: Linked
*/
function turn_gadget_on(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	self.playedgadgetsuccess = 0;
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].turn_on))
		{
			foreach(turn_on in level._gadgets_level[self._gadgets_player[slot].gadget_type].turn_on)
			{
				self [[turn_on]](slot, weapon);
				self trackheropoweractivated(game["timepassed"]);
				level notify(#"hero_gadget_activated", self, weapon);
				self notify(#"hero_gadget_activated", weapon);
			}
		}
	}
	if(isdefined(level.cybercom) && isdefined(level.cybercom._ability_turn_on))
	{
		self [[level.cybercom._ability_turn_on]](slot, weapon);
	}
	self.pers["heroGadgetNotified"] = 0;
	xuid = self getxuid();
	bbprint("mpheropowerevents", "spawnid %d gametime %d name %s powerstate %s playername %s xuid %s", getplayerspawnid(self), gettime(), self._gadgets_player[slot].name, "activated", self.name, xuid);
	if(isdefined(level.playgadgetactivate))
	{
		self [[level.playgadgetactivate]](weapon);
	}
	if(weapon.gadget_type != 14)
	{
		if(isdefined(self.isneardeath) && self.isneardeath == 1)
		{
			if(isdefined(level.heroabilityactivateneardeath))
			{
				[[level.heroabilityactivateneardeath]]();
			}
		}
		self.heroabilityactivatetime = gettime();
		self.heroabilityactive = 1;
		self.heroability = weapon;
	}
	self thread ability_power::power_consume_timer_think(slot, weapon);
}

/*
	Name: turn_gadget_off
	Namespace: ability_player
	Checksum: 0xA9A853A1
	Offset: 0x24D8
	Size: 0x33C
	Parameters: 2
	Flags: Linked
*/
function turn_gadget_off(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(!isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].turn_off))
	{
		foreach(turn_off in level._gadgets_level[self._gadgets_player[slot].gadget_type].turn_off)
		{
			self [[turn_off]](slot, weapon);
			dead = self.health <= 0;
			self trackheropowerexpired(game["timepassed"], dead, self.heroweaponshots, self.heroweaponhits);
		}
	}
	if(isdefined(level.cybercom) && isdefined(level.cybercom._ability_turn_off))
	{
		self [[level.cybercom._ability_turn_off]](slot, weapon);
	}
	if(weapon.gadget_type != 14)
	{
		if(self isempjammed() == 1)
		{
			self gadgettargetresult(0);
			if(isdefined(level.callbackendherospecialistemp))
			{
				if(isdefined(weapon.gadget_turnoff_onempjammed) && weapon.gadget_turnoff_onempjammed == 1)
				{
					self thread [[level.callbackendherospecialistemp]]();
				}
			}
		}
		self.heroabilitydectivatetime = gettime();
		self.heroabilityactive = undefined;
		self.heroability = weapon;
	}
	self notify(#"heroability_off", weapon);
	xuid = self getxuid();
	bbprint("mpheropowerevents", "spawnid %d gametime %d name %s powerstate %s playername %s xuid %s", getplayerspawnid(self), gettime(), self._gadgets_player[slot].name, "expired", self.name, xuid);
	if(isdefined(level.oldschool) && level.oldschool)
	{
		self takeweapon(weapon);
	}
}

/*
	Name: gadget_checkheroabilitykill
	Namespace: ability_player
	Checksum: 0x884ADF33
	Offset: 0x2820
	Size: 0x282
	Parameters: 1
	Flags: Linked
*/
function gadget_checkheroabilitykill(attacker)
{
	heroabilitystat = 0;
	if(isdefined(attacker.heroability))
	{
		switch(attacker.heroability.name)
		{
			case "gadget_armor":
			case "gadget_clone":
			case "gadget_heat_wave":
			case "gadget_speed_burst":
			{
				if(isdefined(attacker.heroabilityactive) || (isdefined(attacker.heroabilitydectivatetime) && attacker.heroabilitydectivatetime > (gettime() - 100)))
				{
					heroabilitystat = 1;
				}
				break;
			}
			case "gadget_camo":
			case "gadget_flashback":
			case "gadget_resurrect":
			{
				if(isdefined(attacker.heroabilityactive) || (isdefined(attacker.heroabilitydectivatetime) && attacker.heroabilitydectivatetime > (gettime() - 6000)))
				{
					heroabilitystat = 1;
				}
				break;
			}
			case "gadget_vision_pulse":
			{
				if(isdefined(attacker.visionpulsespottedenemytime))
				{
					timecutoff = gettime();
					if((attacker.visionpulsespottedenemytime + 10000) > timecutoff)
					{
						for(i = 0; i < attacker.visionpulsespottedenemy.size; i++)
						{
							spottedenemy = attacker.visionpulsespottedenemy[i];
							if(spottedenemy == self)
							{
								if(self.lastspawntime < attacker.visionpulsespottedenemytime)
								{
									heroabilitystat = 1;
									break;
								}
							}
						}
					}
				}
			}
			case "gadget_combat_efficiency":
			{
				if(isdefined(attacker._gadget_combat_efficiency) && attacker._gadget_combat_efficiency == 1)
				{
					heroabilitystat = 1;
					break;
				}
				else if(isdefined(attacker.combatefficiencylastontime) && attacker.combatefficiencylastontime > (gettime() - 100))
				{
					heroabilitystat = 1;
					break;
				}
			}
		}
	}
	return heroabilitystat;
}

/*
	Name: gadget_flicker
	Namespace: ability_player
	Checksum: 0xE69D06FC
	Offset: 0x2AB0
	Size: 0x12A
	Parameters: 2
	Flags: Linked
*/
function gadget_flicker(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(!isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].on_flicker))
	{
		foreach(on_flicker in level._gadgets_level[self._gadgets_player[slot].gadget_type].on_flicker)
		{
			self [[on_flicker]](slot, weapon);
		}
	}
}

/*
	Name: gadget_ready
	Namespace: ability_player
	Checksum: 0x91D0226A
	Offset: 0x2BE8
	Size: 0x3AE
	Parameters: 2
	Flags: Linked
*/
function gadget_ready(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(!isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].should_notify) && level._gadgets_level[self._gadgets_player[slot].gadget_type].should_notify)
	{
		if(isdefined(level.statstableid))
		{
			itemrow = tablelookuprownum(level.statstableid, 4, self._gadgets_player[slot].name);
			if(itemrow > -1)
			{
				index = int(tablelookupcolumnforrow(level.statstableid, itemrow, 0));
				if(index != 0)
				{
					self luinotifyevent(&"hero_weapon_received", 1, index);
					self luinotifyeventtospectators(&"hero_weapon_received", 1, index);
				}
			}
		}
		if(!isdefined(level.gameended) || !level.gameended)
		{
			if(!isdefined(self.pers["heroGadgetNotified"]) || !self.pers["heroGadgetNotified"])
			{
				self.pers["heroGadgetNotified"] = 1;
				if(isdefined(level.playgadgetready))
				{
					self [[level.playgadgetready]](weapon);
				}
				self trackheropoweravailable(game["timepassed"]);
			}
		}
	}
	xuid = self getxuid();
	bbprint("mpheropowerevents", "spawnid %d gametime %d name %s powerstate %s playername %s xuid %s", getplayerspawnid(self), gettime(), self._gadgets_player[slot].name, "ready", self.name, xuid);
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].on_ready))
	{
		foreach(on_ready in level._gadgets_level[self._gadgets_player[slot].gadget_type].on_ready)
		{
			self [[on_ready]](slot, weapon);
		}
	}
}

/*
	Name: gadget_primed
	Namespace: ability_player
	Checksum: 0x8CA4D2AE
	Offset: 0x2FA0
	Size: 0x12A
	Parameters: 2
	Flags: Linked
*/
function gadget_primed(slot, weapon)
{
	if(!isdefined(self._gadgets_player[slot]))
	{
		return;
	}
	if(!isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type]))
	{
		return;
	}
	if(isdefined(level._gadgets_level[self._gadgets_player[slot].gadget_type].on_primed))
	{
		foreach(on_primed in level._gadgets_level[self._gadgets_player[slot].gadget_type].on_primed)
		{
			self [[on_primed]](slot, weapon);
		}
	}
}

/*
	Name: abilities_print
	Namespace: ability_player
	Checksum: 0x99DAABCB
	Offset: 0x30D8
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function abilities_print(str)
{
	/#
		toprint = "" + str;
		println(toprint);
	#/
}

/*
	Name: abilities_devgui_init
	Namespace: ability_player
	Checksum: 0x2504E69E
	Offset: 0x3128
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function abilities_devgui_init()
{
	/#
		setdvar("", "");
		setdvar("", "");
		setdvar("", 0);
		if(isdedicated())
		{
			return;
		}
		level.abilities_devgui_base = "";
		level thread abilities_devgui_think();
	#/
}

/*
	Name: abilities_devgui_player_connect
	Namespace: ability_player
	Checksum: 0x5774A221
	Offset: 0x31D0
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function abilities_devgui_player_connect()
{
	/#
		if(!isdefined(level.abilities_devgui_base))
		{
			return;
		}
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i] != self)
			{
				continue;
			}
			abilities_devgui_add_player_commands(level.abilities_devgui_base, players[i].playername, i + 1);
			return;
		}
	#/
}

/*
	Name: abilities_devgui_add_player_commands
	Namespace: ability_player
	Checksum: 0x8AF9FB44
	Offset: 0x3288
	Size: 0xB8
	Parameters: 3
	Flags: Linked
*/
function abilities_devgui_add_player_commands(root, pname, index)
{
	/#
		add_cmd_with_root = (("" + root) + pname) + "";
		pid = "" + index;
		menu_index = 1;
		menu_index = abilities_devgui_add_gadgets(add_cmd_with_root, pid, menu_index);
		menu_index = abilities_devgui_add_power(add_cmd_with_root, pid, menu_index);
	#/
}

/*
	Name: abilities_devgui_add_player_command
	Namespace: ability_player
	Checksum: 0x10C2ECE4
	Offset: 0x3348
	Size: 0xD4
	Parameters: 6
	Flags: Linked
*/
function abilities_devgui_add_player_command(root, pid, cmdname, menu_index, cmddvar, argdvar)
{
	/#
		if(!isdefined(argdvar))
		{
			argdvar = "";
		}
		adddebugcommand((((((((((((((root + cmdname) + "") + "") + "") + pid) + "") + "") + "") + cmddvar) + "") + "") + "") + argdvar) + "");
	#/
}

/*
	Name: abilities_devgui_add_power
	Namespace: ability_player
	Checksum: 0xB088DF98
	Offset: 0x3428
	Size: 0xBE
	Parameters: 3
	Flags: Linked
*/
function abilities_devgui_add_power(add_cmd_with_root, pid, menu_index)
{
	/#
		root = ((add_cmd_with_root + "") + menu_index) + "";
		abilities_devgui_add_player_command(root, pid, "", 1, "", "");
		abilities_devgui_add_player_command(root, pid, "", 2, "", "");
		menu_index++;
		return menu_index;
	#/
}

/*
	Name: abilities_devgui_add_gadgets
	Namespace: ability_player
	Checksum: 0x4550D7DC
	Offset: 0x34F0
	Size: 0x176
	Parameters: 3
	Flags: Linked
*/
function abilities_devgui_add_gadgets(add_cmd_with_root, pid, menu_index)
{
	/#
		a_weapons = enumerateweapons("");
		a_hero = [];
		a_abilities = [];
		for(i = 0; i < a_weapons.size; i++)
		{
			if(a_weapons[i].isgadget)
			{
				if(a_weapons[i].inventorytype == "")
				{
					arrayinsert(a_hero, a_weapons[i], 0);
					continue;
				}
				arrayinsert(a_abilities, a_weapons[i], 0);
			}
		}
		abilities_devgui_add_player_weapons(add_cmd_with_root, pid, a_abilities, "", menu_index);
		menu_index++;
		abilities_devgui_add_player_weapons(add_cmd_with_root, pid, a_hero, "", menu_index);
		menu_index++;
		return menu_index;
	#/
}

/*
	Name: abilities_devgui_add_player_weapons
	Namespace: ability_player
	Checksum: 0x1B3BA78A
	Offset: 0x3670
	Size: 0xC6
	Parameters: 5
	Flags: Linked
*/
function abilities_devgui_add_player_weapons(root, pid, a_weapons, weapon_type, menu_index)
{
	/#
		if(isdefined(a_weapons))
		{
			player_devgui_root = (root + weapon_type) + "";
			for(i = 0; i < a_weapons.size; i++)
			{
				abilities_devgui_add_player_weap_command(player_devgui_root, pid, a_weapons[i].name, i + 1);
				wait(0.05);
			}
		}
	#/
}

/*
	Name: abilities_devgui_add_player_weap_command
	Namespace: ability_player
	Checksum: 0xE2DAE482
	Offset: 0x3740
	Size: 0xAC
	Parameters: 4
	Flags: Linked
*/
function abilities_devgui_add_player_weap_command(root, pid, weap_name, cmdindex)
{
	/#
		adddebugcommand((((((((((((((root + weap_name) + "") + "") + "") + pid) + "") + "") + "") + "") + "") + "") + "") + weap_name) + "");
	#/
}

/*
	Name: abilities_devgui_player_disconnect
	Namespace: ability_player
	Checksum: 0x6FAD21CC
	Offset: 0x37F8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function abilities_devgui_player_disconnect()
{
	/#
		if(!isdefined(level.abilities_devgui_base))
		{
			return;
		}
		remove_cmd_with_root = (("" + level.abilities_devgui_base) + self.playername) + "";
		util::add_queued_debug_command(remove_cmd_with_root);
	#/
}

/*
	Name: abilities_devgui_think
	Namespace: ability_player
	Checksum: 0x4528A55A
	Offset: 0x3860
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function abilities_devgui_think()
{
	/#
		for(;;)
		{
			cmd = getdvarstring("");
			if(cmd == "")
			{
				wait(0.05);
				continue;
			}
			arg = getdvarstring("");
			switch(cmd)
			{
				case "":
				{
					abilities_devgui_handle_player_command(cmd, &abilities_devgui_power_fill);
					break;
				}
				case "":
				{
					abilities_devgui_handle_player_command(cmd, &abilities_devgui_power_toggle_auto_fill);
					break;
				}
				case "":
				{
					abilities_devgui_handle_player_command(cmd, &abilities_devgui_give, arg);
				}
				case "":
				{
					break;
				}
				default:
				{
					break;
				}
			}
			setdvar("", "");
			wait(0.5);
		}
	#/
}

/*
	Name: abilities_devgui_give
	Namespace: ability_player
	Checksum: 0x91375EF0
	Offset: 0x39B8
	Size: 0x146
	Parameters: 1
	Flags: Linked
*/
function abilities_devgui_give(weapon_name)
{
	/#
		level.devgui_giving_abilities = 1;
		for(i = 0; i < 3; i++)
		{
			if(isdefined(self._gadgets_player[i]))
			{
				self takeweapon(self._gadgets_player[i]);
			}
		}
		self notify(#"gadget_devgui_give");
		weapon = getweapon(weapon_name);
		self giveweapon(weapon);
		if(self util::is_bot())
		{
			slot = self gadgetgetslot(weapon);
			self gadgetpowerset(slot, 100);
			self bot::activate_hero_gadget(weapon);
		}
		level.devgui_giving_abilities = undefined;
	#/
}

/*
	Name: abilities_devgui_handle_player_command
	Namespace: ability_player
	Checksum: 0xAC66A026
	Offset: 0x3B08
	Size: 0x10C
	Parameters: 3
	Flags: Linked
*/
function abilities_devgui_handle_player_command(cmd, playercallback, pcb_param)
{
	/#
		pid = getdvarint("");
		if(pid > 0)
		{
			player = getplayers()[pid - 1];
			if(isdefined(player))
			{
				if(isdefined(pcb_param))
				{
					player thread [[playercallback]](pcb_param);
				}
				else
				{
					player thread [[playercallback]]();
				}
			}
		}
		else
		{
			array::thread_all(getplayers(), playercallback, pcb_param);
		}
		setdvar("", "");
	#/
}

/*
	Name: abilities_devgui_power_fill
	Namespace: ability_player
	Checksum: 0xE1EABF1B
	Offset: 0x3C20
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function abilities_devgui_power_fill()
{
	/#
		if(!isdefined(self) || !isdefined(self._gadgets_player))
		{
			return;
		}
		for(i = 0; i < 3; i++)
		{
			if(isdefined(self._gadgets_player[i]))
			{
				self gadgetpowerset(i, self._gadgets_player[i].gadget_powermax);
			}
		}
	#/
}

/*
	Name: abilities_devgui_power_toggle_auto_fill
	Namespace: ability_player
	Checksum: 0x24513600
	Offset: 0x3CB8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function abilities_devgui_power_toggle_auto_fill()
{
	/#
		if(!isdefined(self) || !isdefined(self._gadgets_player))
		{
			return;
		}
		self.abilities_devgui_power_toggle_auto_fill = !(isdefined(self.abilities_devgui_power_toggle_auto_fill) && self.abilities_devgui_power_toggle_auto_fill);
		self thread abilities_devgui_power_toggle_auto_fill_think();
	#/
}

/*
	Name: abilities_devgui_power_toggle_auto_fill_think
	Namespace: ability_player
	Checksum: 0xC26C35E5
	Offset: 0x3D18
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function abilities_devgui_power_toggle_auto_fill_think()
{
	/#
		self endon(#"disconnect");
		self notify(#"auto_fill_think");
		self endon(#"auto_fill_think");
		for(;;)
		{
			if(!isdefined(self) || !isdefined(self._gadgets_player))
			{
				return;
			}
			if(!(isdefined(self.abilities_devgui_power_toggle_auto_fill) && self.abilities_devgui_power_toggle_auto_fill))
			{
				return;
			}
			for(i = 0; i < 3; i++)
			{
				if(isdefined(self._gadgets_player[i]))
				{
					if(!self gadget_is_in_use(i) && self gadgetcharging(i))
					{
						self gadgetpowerset(i, self._gadgets_player[i].gadget_powermax);
					}
				}
			}
			wait(1);
		}
	#/
}

