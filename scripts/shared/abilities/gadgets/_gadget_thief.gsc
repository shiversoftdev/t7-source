// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace thief;

/*
	Name: __init__sytem__
	Namespace: thief
	Checksum: 0x645AFB8D
	Offset: 0x868
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_thief", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: thief
	Checksum: 0x6C13FA14
	Offset: 0x8A8
	Size: 0x26C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "thief_state", 11000, 2, "int");
	clientfield::register("toplayer", "thief_weapon_option", 11000, 4, "int");
	ability_player::register_gadget_activation_callbacks(44, &gadget_thief_on_activate, &gadget_thief_on_deactivate);
	ability_player::register_gadget_possession_callbacks(44, &gadget_thief_on_give, &gadget_thief_on_take);
	ability_player::register_gadget_flicker_callbacks(44, &gadget_thief_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(44, &gadget_thief_is_inuse);
	ability_player::register_gadget_ready_callbacks(44, &gadget_thief_is_ready);
	ability_player::register_gadget_is_flickering_callbacks(44, &gadget_thief_is_flickering);
	clientfield::register("scriptmover", "gadget_thief_fx", 11000, 1, "int");
	clientfield::register("clientuimodel", "playerAbilities.playerGadget3.flashStart", 11000, 3, "int");
	clientfield::register("clientuimodel", "playerAbilities.playerGadget3.flashEnd", 11000, 3, "int");
	callback::on_connect(&gadget_thief_on_connect);
	callback::on_spawned(&gadget_thief_on_player_spawn);
	setup_gadget_thief_array();
	level.gadgetthieftimecharge = 0;
	level.gadgetthiefshutdownfullcharge = getdvarint("gadgetThiefShutdownFullCharge", 1);
	/#
		level thread updatedvars();
	#/
}

/*
	Name: updatedvars
	Namespace: thief
	Checksum: 0xF51BB4D
	Offset: 0xB20
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function updatedvars()
{
	/#
		while(true)
		{
			level.gadgetthieftimecharge = getdvarint("", 0);
			wait(1);
		}
	#/
}

/*
	Name: setup_gadget_thief_array
	Namespace: thief
	Checksum: 0xB755B5E2
	Offset: 0xB68
	Size: 0x1D6
	Parameters: 0
	Flags: Linked
*/
function setup_gadget_thief_array()
{
	weapons = enumerateweapons("weapon");
	level.gadgetthiefarray = [];
	for(i = 0; i < weapons.size; i++)
	{
		if(weapons[i].isgadget && weapons[i].isheroweapon == 1)
		{
			if(weapons[i].name != "gadget_thief" && weapons[i].name != "gadget_roulette" && weapons[i].name != "hero_bowlauncher2" && weapons[i].name != "hero_bowlauncher3" && weapons[i].name != "hero_bowlauncher4" && weapons[i].name != "hero_pineapple_grenade" && weapons[i].name != "gadget_speed_burst" && weapons[i].name != "hero_minigun_body3" && weapons[i].name != "hero_lightninggun_arc")
			{
				arrayinsert(level.gadgetthiefarray, weapons[i], 0);
			}
		}
	}
}

/*
	Name: gadget_thief_is_inuse
	Namespace: thief
	Checksum: 0x86FDE913
	Offset: 0xD48
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_thief_is_inuse(slot)
{
	return self gadgetisactive(slot);
}

/*
	Name: gadget_thief_is_flickering
	Namespace: thief
	Checksum: 0x32161E00
	Offset: 0xD78
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_thief_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: gadget_thief_on_flicker
	Namespace: thief
	Checksum: 0xB1063DE9
	Offset: 0xDA8
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_thief_on_flicker(slot, weapon)
{
	self thread gadget_thief_flicker(slot, weapon);
}

/*
	Name: gadget_thief_on_give
	Namespace: thief
	Checksum: 0x32653016
	Offset: 0xDE8
	Size: 0x1A4
	Parameters: 2
	Flags: Linked
*/
function gadget_thief_on_give(slot, weapon)
{
	self.gadget_thief_kill_callback = &gadget_thief_kill_callback;
	self.gadget_thief_slot = slot;
	self thread gadget_thief_active(slot, weapon);
	if(sessionmodeismultiplayergame())
	{
		self.isthief = 1;
	}
	self clientfield::set_to_player("thief_state", 0);
	currentpower = (isdefined(self gadgetpowerget(slot)) ? self gadgetpowerget(slot) : 0);
	savedpower = 0;
	if(isdefined(self.pers["held_gadgets_power"]) && isdefined(self.pers[#"hash_c35f137f"]) && isdefined(self.pers["held_gadgets_power"][self.pers[#"hash_c35f137f"]]))
	{
		savedpower = self.pers["held_gadgets_power"][self.pers[#"hash_c35f137f"]];
	}
	if(currentpower >= 100 || savedpower >= 100)
	{
		self.givestolenweapononspawn = 1;
		self.givestolenweaponslot = slot;
	}
}

/*
	Name: gadget_thief_kill_callback
	Namespace: thief
	Checksum: 0x56A2A451
	Offset: 0xF98
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function gadget_thief_kill_callback(victim, weapon)
{
	/#
		assert(isdefined(self.gadget_thief_slot));
	#/
	self thread handlethiefkill(self.gadget_thief_slot, weapon, victim);
}

/*
	Name: gadget_thief_on_take
	Namespace: thief
	Checksum: 0xA7A1FFAA
	Offset: 0x1000
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_thief_on_take(slot, weapon)
{
	/#
		if(level.devgui_giving_abilities === 1)
		{
			self.isthief = 0;
		}
	#/
}

/*
	Name: gadget_thief_on_connect
	Namespace: thief
	Checksum: 0xE4040F63
	Offset: 0x1040
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function gadget_thief_on_connect()
{
	self.pers[#"hash_c5c4a13f"] = 1;
	/#
		level.gadgetthieftforcebeam = getdvarint("", 0);
		if(level.gadgetthieftforcebeam)
		{
			self thread watchforallkillsdebug();
		}
	#/
}

/*
	Name: gadget_thief_on_player_spawn
	Namespace: thief
	Checksum: 0x3DF4EBFF
	Offset: 0x10B0
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function gadget_thief_on_player_spawn()
{
	if(self.isthief === 1)
	{
		self thread watchheroweaponchanged();
		if(self.givestolenweapononspawn === 1)
		{
			self givepreviouslyearnedspecialistweapon(self.givestolenweaponslot, 1);
			self gadgetpowerset(self.givestolenweaponslot, 100);
			self.givestolenweapononspawn = undefined;
			self.givestolenweaponslot = undefined;
		}
	}
}

/*
	Name: watch_entity_shutdown
	Namespace: thief
	Checksum: 0x99EC1590
	Offset: 0x1148
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function watch_entity_shutdown()
{
}

/*
	Name: gadget_thief_on_activate
	Namespace: thief
	Checksum: 0xE299EC34
	Offset: 0x1158
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_thief_on_activate(slot, weapon)
{
}

/*
	Name: gadget_thief_is_ready
	Namespace: thief
	Checksum: 0x21A9851
	Offset: 0x1178
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_thief_is_ready(slot, weapon)
{
}

/*
	Name: gadget_thief_active
	Namespace: thief
	Checksum: 0xE407A7C
	Offset: 0x1198
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function gadget_thief_active(slot, weapon)
{
	waittillframeend();
	if(isdefined(self.pers[#"hash_c35f137f"]) && weapon.name != "gadget_thief")
	{
		self thread gadget_give_random_gadget(slot, weapon, self.pers[#"hash_476984c8"]);
	}
	self thread watchforherokill(slot);
}

/*
	Name: getstolenheroweapon
	Namespace: thief
	Checksum: 0x5B807518
	Offset: 0x1230
	Size: 0x172
	Parameters: 1
	Flags: Linked
*/
function getstolenheroweapon(gadget)
{
	if(gadget.isheroweapon == 0)
	{
		heroweaponequivalent = "";
		switch(gadget.name)
		{
			case "gadget_flashback":
			{
				heroweaponequivalent = "hero_lightninggun";
				break;
			}
			case "gadget_combat_efficiency":
			{
				heroweaponequivalent = "hero_annihilator";
				break;
			}
			case "gadget_heat_wave":
			{
				heroweaponequivalent = "hero_flamethrower";
				break;
			}
			case "gadget_vision_pulse":
			{
				heroweaponequivalent = "hero_bowlauncher";
				break;
			}
			case "gadget_speed_burst":
			{
				heroweaponequivalent = "hero_gravityspikes";
				break;
			}
			case "gadget_camo":
			{
				heroweaponequivalent = "hero_armblade";
				break;
			}
			case "gadget_armor":
			{
				heroweaponequivalent = "hero_pineapplegun";
				break;
			}
			case "gadget_resurrect":
			{
				heroweaponequivalent = "hero_chemicalgelgun";
				break;
			}
			case "gadget_clone":
			{
				heroweaponequivalent = "hero_minigun";
				break;
			}
		}
		if(heroweaponequivalent != "")
		{
			heroweapon = getweapon(heroweaponequivalent);
		}
	}
	else
	{
		heroweapon = gadget;
	}
	return heroweapon;
}

/*
	Name: resetflashstartandendafterdelay
	Namespace: thief
	Checksum: 0xD99D4A12
	Offset: 0x13B0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function resetflashstartandendafterdelay(delay)
{
	self notify(#"resetflashstartandend");
	self endon(#"resetflashstartandend");
	wait(delay);
	self clientfield::set_player_uimodel("playerAbilities.playerGadget3.flashStart", 0);
	self clientfield::set_player_uimodel("playerAbilities.playerGadget3.flashEnd", 0);
}

/*
	Name: getthiefpowergain
	Namespace: thief
	Checksum: 0xCE642199
	Offset: 0x1428
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function getthiefpowergain()
{
	gadgetthiefkillpowergain = getdvarfloat("gadgetThiefKillPowerGain", 12.5);
	thiefgametypefactor = (isdefined(getgametypesetting("scoreThiefPowerGainFactor")) ? getgametypesetting("scoreThiefPowerGainFactor") : 1);
	gadgetthiefkillpowergain = gadgetthiefkillpowergain * thiefgametypefactor;
	return gadgetthiefkillpowergain;
}

/*
	Name: handlethiefkill
	Namespace: thief
	Checksum: 0xDF54EDC8
	Offset: 0x14C8
	Size: 0x384
	Parameters: 3
	Flags: Linked
*/
function handlethiefkill(slot, weapon, victim)
{
	if(isdefined(weapon) && !killstreaks::is_killstreak_weapon(weapon) && !weapon.isheroweapon && isalive(self))
	{
		if(self gadgetisactive(slot) == 0)
		{
			power = self gadgetpowerget(slot);
			gadgetthiefkillpowergain = getthiefpowergain();
			gadgetthiefkillpowergainwithoutmultiplier = getthiefpowergain();
			victimgadgetpower = (isdefined(victim gadgetpowerget(0)) ? victim gadgetpowerget(0) : 0);
			alwaysperformgain = 0;
			if(alwaysperformgain || power < 100)
			{
				if(victimgadgetpower == 100)
				{
					self playsoundtoplayer("mpl_bm_specialist_bar_thief", self);
				}
				else
				{
					self playsoundtoplayer("mpl_bm_specialist_bar_thief", self);
				}
			}
			currentpower = power + gadgetthiefkillpowergain;
			if(power < 80 && currentpower >= 80 && currentpower < 100)
			{
				if(self hasperk("specialty_overcharge"))
				{
					currentpower = 100;
				}
			}
			if(currentpower >= 100)
			{
				wasfullycharged = power >= 100;
				self earnedspecialistweapon(victim, slot, wasfullycharged);
			}
			self clientfield::set_player_uimodel("playerAbilities.playerGadget3.flashStart", int(power / gadgetthiefkillpowergainwithoutmultiplier));
			self clientfield::set_player_uimodel("playerAbilities.playerGadget3.flashEnd", int(currentpower / gadgetthiefkillpowergainwithoutmultiplier));
			self thread resetflashstartandendafterdelay(3);
			self gadgetpowerset(slot, currentpower);
		}
		else if(isplayer(victim) && self.pers[#"hash_476984c8"] === victim.entnum && weapon.isheroweapon)
		{
			scoreevents::processscoreevent("kill_enemy_with_their_hero_weapon", self);
		}
	}
}

/*
	Name: earnedspecialistweapon
	Namespace: thief
	Checksum: 0x9BB3AF16
	Offset: 0x1858
	Size: 0x304
	Parameters: 4
	Flags: Linked
*/
function earnedspecialistweapon(victim, slot, wasfullycharged, stolenheroweapon)
{
	if(!isdefined(victim))
	{
		return;
	}
	heroweapon = undefined;
	victimisblackjack = victim.isthief === 1 || victim.isroulette === 1;
	if(victimisblackjack)
	{
		if(isdefined(stolenheroweapon))
		{
			heroweapon = stolenheroweapon;
		}
		else if(isdefined(victim.pers[#"hash_c35f137f"]) && victim.pers[#"hash_c35f137f"].isheroweapon === 1)
		{
			heroweapon = victim.pers[#"hash_c35f137f"];
		}
	}
	if(!isdefined(heroweapon))
	{
		victimgadget = victim._gadgets_player[0];
		heroweapon = getstolenheroweapon(victimgadget);
	}
	if(wasfullycharged)
	{
		if(isdefined(heroweapon) && isdefined(self.pers[#"hash_c35f137f"]) && heroweapon != self.pers[#"hash_c35f137f"] && (!isdefined(self.pers[#"hash_5c5e3658"]) || heroweapon != self.pers[#"hash_5c5e3658"]) && self.pers[#"hash_c5c4a13f"])
		{
			self thread giveflipweapon(slot, victim, heroweapon);
		}
	}
	else
	{
		self clientfield::set_to_player("thief_state", 1);
		self clientfield::set_to_player("thief_weapon_option", 0);
		self thread gadget_give_random_gadget(slot, heroweapon, victim.entnum);
		self.pers[#"hash_5c5e3658"] = undefined;
		self.thief_new_gadget_time = gettime();
		if(isdefined(self.pers[#"hash_c35f137f"]) && self.pers[#"hash_c35f137f"].isheroweapon === 1)
		{
			self handlestolenscoreevent(self.pers[#"hash_c35f137f"]);
		}
		self playsoundtoplayer("mpl_bm_specialist_bar_filled", self);
	}
}

/*
	Name: giveflipweapon
	Namespace: thief
	Checksum: 0xA8AAD111
	Offset: 0x1B68
	Size: 0x1BC
	Parameters: 3
	Flags: Linked
*/
function giveflipweapon(slot, victim, heroweapon)
{
	self notify(#"give_flip_weapon_singleton");
	self endon(#"give_flip_weapon_singleton");
	previousgivefliptime = (isdefined(self.last_thief_give_flip_time) ? self.last_thief_give_flip_time : 0);
	self.last_thief_give_flip_time = gettime();
	alreadygivenflipthisframe = previousgivefliptime == self.last_thief_give_flip_time;
	self.pers[#"hash_5c5e3658"] = heroweapon;
	victimbodyindex = getvictimbodyindex(victim, heroweapon);
	self handlestolenscoreevent(heroweapon);
	self notify(#"thief_flip_activated");
	if((self.last_thief_give_flip_time - previousgivefliptime) > 99)
	{
		self playsoundtoplayer("mpl_bm_specialist_coin_place", self);
	}
	elapsed_time = (gettime() - (isdefined(self.thief_new_gadget_time) ? self.thief_new_gadget_time : 0)) * 0.001;
	if(elapsed_time < 0.75)
	{
		wait(0.75 - elapsed_time);
	}
	self clientfield::set_to_player("thief_state", 2);
	self thread watchforoptionuse(slot, victimbodyindex, 0);
}

/*
	Name: givepreviouslyearnedspecialistweapon
	Namespace: thief
	Checksum: 0x25FE5033
	Offset: 0x1D30
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function givepreviouslyearnedspecialistweapon(slot, justspawned)
{
	if(isdefined(self.pers[#"hash_c35f137f"]))
	{
		self thread gadget_give_random_gadget(slot, self.pers[#"hash_c35f137f"], self.pers[#"hash_476984c8"], justspawned);
		if(isdefined(self.pers[#"hash_5c5e3658"]))
		{
			self thread watchforoptionuse(slot, self.pers[#"hash_6de3aefa"], justspawned);
		}
	}
}

/*
	Name: disable_hero_gadget_activation
	Namespace: thief
	Checksum: 0xA1081A37
	Offset: 0x1DE0
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function disable_hero_gadget_activation(duration)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"thief_flip_activated");
	self disableoffhandspecial();
	wait(duration);
	self enableoffhandspecial();
}

/*
	Name: failsafe_reenable_offhand_special
	Namespace: thief
	Checksum: 0x39F462E5
	Offset: 0x1E48
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function failsafe_reenable_offhand_special()
{
	self endon(#"end_failsafe_reenable_offhand_special");
	wait(3);
	if(isdefined(self))
	{
		self enableoffhandspecial();
	}
}

/*
	Name: handlestolenscoreevent
	Namespace: thief
	Checksum: 0x27CFB19F
	Offset: 0x1E88
	Size: 0x204
	Parameters: 1
	Flags: Linked
*/
function handlestolenscoreevent(heroweapon)
{
	switch(heroweapon.name)
	{
		case "hero_minigun":
		case "hero_minigun_body3":
		{
			event = "minigun_stolen";
			label = "SCORE_MINIGUN_STOLEN";
			break;
		}
		case "hero_flamethrower":
		{
			event = "flamethrower_stolen";
			label = "SCORE_FLAMETHROWER_STOLEN";
			break;
		}
		case "hero_lightninggun":
		case "hero_lightninggun_arc":
		{
			event = "lightninggun_stolen";
			label = "SCORE_LIGHTNINGGUN_STOLEN";
			break;
		}
		case "hero_chemicalgelgun":
		case "hero_firefly_swarm":
		{
			event = "gelgun_stolen";
			label = "SCORE_GELGUN_STOLEN";
			break;
		}
		case "hero_pineapple_grenade":
		case "hero_pineapplegun":
		{
			event = "pineapple_stolen";
			label = "SCORE_PINEAPPLE_STOLEN";
			break;
		}
		case "hero_armblade":
		{
			event = "armblades_stolen";
			label = "SCORE_ARMBLADES_STOLEN";
			break;
		}
		case "hero_bowlauncher":
		case "hero_bowlauncher2":
		case "hero_bowlauncher3":
		case "hero_bowlauncher4":
		{
			event = "bowlauncher_stolen";
			label = "SCORE_BOWLAUNCHER_STOLEN";
			break;
		}
		case "hero_gravityspikes":
		{
			event = "gravityspikes_stolen";
			label = "SCORE_GRAVITYSPIKES_STOLEN";
			break;
		}
		case "hero_annihilator":
		{
			event = "annihilator_stolen";
			label = "SCORE_ANNIHILATOR_STOLEN";
			break;
		}
		default:
		{
			return;
		}
	}
	self luinotifyevent(&"score_event", 5, istring(label), 0, 0, 0, 1);
}

/*
	Name: watchforherokill
	Namespace: thief
	Checksum: 0x9603C5FB
	Offset: 0x2098
	Size: 0x208
	Parameters: 1
	Flags: Linked
*/
function watchforherokill(slot)
{
	self notify(#"watchforthiefkill_singleton");
	self endon(#"watchforthiefkill_singleton");
	self.gadgetthiefactive = 1;
	while(true)
	{
		self waittill(#"hero_shutdown_gadget", herogadget, victim);
		stolenheroweapon = getstolenheroweapon(herogadget);
		performclientsideeffect = 0;
		if(performclientsideeffect)
		{
			self spawnthiefbeameffect(victim.origin);
			clientsideeffect = spawn("script_model", victim.origin);
			clientsideeffect clientfield::set("gadget_thief_fx", 1);
			clientsideeffect thread waitthendelete(5);
		}
		if(isdefined(level.gadgetthiefshutdownfullcharge) && level.gadgetthiefshutdownfullcharge)
		{
			if(self gadgetisactive(slot) == 0)
			{
				scoreevents::processscoreevent("thief_shutdown_enemy", self);
				power = self gadgetpowerget(slot);
				self gadgetpowerset(slot, 100);
				wasfullycharged = power >= 100;
				self earnedspecialistweapon(victim, slot, wasfullycharged, stolenheroweapon);
			}
		}
	}
}

/*
	Name: spawnthiefbeameffect
	Namespace: thief
	Checksum: 0xB9CBEDA
	Offset: 0x22A8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function spawnthiefbeameffect(origin)
{
	clientsideeffect = spawn("script_model", origin);
	clientsideeffect clientfield::set("gadget_thief_fx", 1);
	clientsideeffect thread waitthendelete(5);
}

/*
	Name: watchforallkillsdebug
	Namespace: thief
	Checksum: 0x76089856
	Offset: 0x2328
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function watchforallkillsdebug()
{
	/#
		while(true)
		{
			self waittill(#"killed_enemy_player", victim);
			self spawnthiefbeameffect(victim.origin);
			clientsideeffect = spawn("", victim.origin);
			clientsideeffect clientfield::set("", 1);
			clientsideeffect thread waitthendelete(5);
		}
	#/
}

/*
	Name: waitthendelete
	Namespace: thief
	Checksum: 0x5D3F197C
	Offset: 0x23F0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function waitthendelete(time)
{
	wait(time);
	self delete();
}

/*
	Name: gadget_give_random_gadget
	Namespace: thief
	Checksum: 0x7274BF44
	Offset: 0x2420
	Size: 0x20C
	Parameters: 4
	Flags: Linked
*/
function gadget_give_random_gadget(slot, weapon, weaponstolenfromentnum, justspawned = 0)
{
	previousgadget = undefined;
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self._gadgets_player[i]))
		{
			if(!isdefined(previousgadget))
			{
				previousgadget = self._gadgets_player[i];
			}
			self takeweapon(self._gadgets_player[i]);
		}
	}
	if(!isdefined(weapon))
	{
		weapon = array::random(level.gadgetthiefarray);
	}
	selectedweapon = weapon;
	/#
		if((getdvarint("", -1)) != -1)
		{
			selectedweapon = level.gadgetthiefarray[getdvarint("", -1)];
		}
	#/
	self giveweapon(selectedweapon);
	self gadgetcharging(slot, level.gadgetthieftimecharge);
	self.gadgetthiefchargingslot = slot;
	self.pers[#"hash_c35f137f"] = selectedweapon;
	self.pers[#"hash_476984c8"] = weaponstolenfromentnum;
	if(!isdefined(previousgadget) || previousgadget != selectedweapon)
	{
		self notify(#"thief_hero_weapon_changed", justspawned, selectedweapon);
	}
	self thread watchgadgetactivated(slot);
}

/*
	Name: watchforoptionuse
	Namespace: thief
	Checksum: 0xBFCC443B
	Offset: 0x2638
	Size: 0x1F8
	Parameters: 3
	Flags: Linked
*/
function watchforoptionuse(slot, victimbodyindex, justspawned)
{
	self endon(#"death");
	self endon(#"hero_gadget_activated");
	self notify(#"watchforoptionuse_thief_singleton");
	self endon(#"watchforoptionuse_thief_singleton");
	if(self.pers[#"hash_c5c4a13f"] == 0)
	{
		return;
	}
	self clientfield::set_to_player("thief_weapon_option", victimbodyindex + 1);
	self.pers[#"hash_6de3aefa"] = victimbodyindex;
	if(!justspawned)
	{
		wait(0.85);
		self enableoffhandspecial();
		self notify(#"end_failsafe_reenable_offhand_special");
	}
	while(true)
	{
		if(self dpad_left_pressed())
		{
			self clientfield::set_to_player("thief_state", 1);
			self clientfield::set_to_player("thief_weapon_option", 0);
			self.pers[#"hash_c35f137f"] = self.pers[#"hash_5c5e3658"];
			self.pers[#"hash_5c5e3658"] = undefined;
			self.pers[#"hash_c5c4a13f"] = 0;
			self thread gadget_give_random_gadget(slot, self.pers[#"hash_c35f137f"], self.pers[#"hash_476984c8"]);
			if(isdefined(level.playgadgetready))
			{
				self thread [[level.playgadgetready]](self.pers[#"hash_c35f137f"], 1);
			}
			return;
		}
		wait(0.05);
	}
}

/*
	Name: dpad_left_pressed
	Namespace: thief
	Checksum: 0x4596C014
	Offset: 0x2838
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function dpad_left_pressed()
{
	return self actionslotthreebuttonpressed();
}

/*
	Name: watchheroweaponchanged
	Namespace: thief
	Checksum: 0x9C74B7FC
	Offset: 0x2860
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function watchheroweaponchanged()
{
	self notify(#"watchheroweaponchanged_singleton");
	self endon(#"watchheroweaponchanged_singleton");
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"thief_hero_weapon_changed", justspawned, newweapon);
		if(justspawned)
		{
			if(isdefined(newweapon) && isdefined(newweapon.gadgetreadysoundplayer))
			{
				self playsoundtoplayer(newweapon.gadgetreadysoundplayer, self);
			}
		}
		else
		{
			self playsoundtoplayer("mpl_bm_specialist_thief", self);
		}
	}
}

/*
	Name: watchgadgetactivated
	Namespace: thief
	Checksum: 0x13B99CCD
	Offset: 0x2938
	Size: 0x1C4
	Parameters: 1
	Flags: Linked
*/
function watchgadgetactivated(slot)
{
	self notify(#"watchgadgetactivated_singleton");
	self endon(#"watchgadgetactivated_singleton");
	self waittill(#"hero_gadget_activated");
	self clientfield::set_to_player("thief_weapon_option", 0);
	self.pers[#"hash_c35f137f"] = undefined;
	self.pers[#"hash_5c5e3658"] = undefined;
	self.pers[#"hash_c5c4a13f"] = 1;
	self waittill(#"heroability_off");
	power = self gadgetpowerget(slot);
	power = (int(power / getthiefpowergain())) * getthiefpowergain();
	self gadgetpowerset(slot, power);
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self._gadgets_player[i]))
		{
			self takeweapon(self._gadgets_player[i]);
		}
	}
	self giveweapon(getweapon("gadget_thief"));
	self clientfield::set_to_player("thief_state", 0);
}

/*
	Name: gadget_thief_on_deactivate
	Namespace: thief
	Checksum: 0x8CC4CF03
	Offset: 0x2B08
	Size: 0xC0
	Parameters: 2
	Flags: Linked
*/
function gadget_thief_on_deactivate(slot, weapon)
{
	self waittill(#"heroability_off");
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self._gadgets_player[i]))
		{
			self takeweapon(self._gadgets_player[i]);
		}
	}
	self giveweapon(weapon);
	self gadgetcharging(slot, level.gadgetthieftimecharge);
	self.gadgetthiefchargingslot = slot;
}

/*
	Name: gadget_thief_flicker
	Namespace: thief
	Checksum: 0x2DFC9126
	Offset: 0x2BD0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_thief_flicker(slot, weapon)
{
}

/*
	Name: set_gadget_status
	Namespace: thief
	Checksum: 0x10A85E9A
	Offset: 0x2BF0
	Size: 0x9C
	Parameters: 2
	Flags: None
*/
function set_gadget_status(status, time)
{
	timestr = "";
	if(isdefined(time))
	{
		timestr = (("^3") + ", time: ") + time;
	}
	if(getdvarint("scr_cpower_debug_prints") > 0)
	{
		self iprintlnbold(("Gadget thief: " + status) + timestr);
	}
}

/*
	Name: getvictimbodyindex
	Namespace: thief
	Checksum: 0x88CA1205
	Offset: 0x2C98
	Size: 0x152
	Parameters: 2
	Flags: Linked
*/
function getvictimbodyindex(victim, heroweapon)
{
	bodyindex = victim getcharacterbodytype();
	if(bodyindex == 9)
	{
		switch(heroweapon.name)
		{
			case "hero_minigun":
			case "hero_minigun_body3":
			{
				bodyindex = 6;
				break;
			}
			case "hero_flamethrower":
			{
				bodyindex = 8;
				break;
			}
			case "hero_lightninggun":
			{
				bodyindex = 2;
				break;
			}
			case "hero_chemicalgelgun":
			{
				bodyindex = 5;
				break;
			}
			case "hero_pineapplegun":
			{
				bodyindex = 3;
				break;
			}
			case "hero_armblade":
			{
				bodyindex = 7;
				break;
			}
			case "hero_bowlauncher":
			case "hero_bowlauncher2":
			case "hero_bowlauncher3":
			case "hero_bowlauncher4":
			{
				bodyindex = 1;
				break;
			}
			case "hero_gravityspikes":
			{
				bodyindex = 0;
				break;
			}
			case "hero_annihilator":
			default:
			{
				bodyindex = 4;
				break;
			}
		}
	}
	return bodyindex;
}

