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
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace roulette;

/*
	Name: __init__sytem__
	Namespace: roulette
	Checksum: 0x5E5EDD60
	Offset: 0x3F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_roulette", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: roulette
	Checksum: 0xBBB057EB
	Offset: 0x438
	Size: 0x308
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "roulette_state", 11000, 2, "int");
	ability_player::register_gadget_activation_callbacks(43, &gadget_roulette_on_activate, &gadget_roulette_on_deactivate);
	ability_player::register_gadget_possession_callbacks(43, &gadget_roulette_on_give, &gadget_roulette_on_take);
	ability_player::register_gadget_flicker_callbacks(43, &gadget_roulette_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(43, &gadget_roulette_is_inuse);
	ability_player::register_gadget_ready_callbacks(43, &gadget_roulette_is_ready);
	ability_player::register_gadget_is_flickering_callbacks(43, &gadget_roulette_is_flickering);
	ability_player::register_gadget_should_notify(43, 0);
	callback::on_connect(&gadget_roulette_on_connect);
	callback::on_spawned(&gadget_roulette_on_player_spawn);
	if(sessionmodeismultiplayergame())
	{
		level.gadgetrouletteprobabilities = [];
		level.gadgetrouletteprobabilities[0] = 0;
		level.gadgetrouletteprobabilities[1] = 0;
		level.weaponnone = getweapon("none");
		level.gadget_roulette = getweapon("gadget_roulette");
		registergadgettype("gadget_flashback", 1, 1);
		registergadgettype("gadget_combat_efficiency", 1, 1);
		registergadgettype("gadget_heat_wave", 1, 1);
		registergadgettype("gadget_vision_pulse", 1, 1);
		registergadgettype("gadget_speed_burst", 1, 1);
		registergadgettype("gadget_camo", 1, 1);
		registergadgettype("gadget_armor", 1, 1);
		registergadgettype("gadget_resurrect", 1, 1);
		registergadgettype("gadget_clone", 1, 1);
	}
	/#
	#/
}

/*
	Name: updatedvars
	Namespace: roulette
	Checksum: 0xA669FB93
	Offset: 0x748
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function updatedvars()
{
	/#
		while(true)
		{
			wait(1);
		}
	#/
}

/*
	Name: gadget_roulette_is_inuse
	Namespace: roulette
	Checksum: 0xCF390DEE
	Offset: 0x770
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_roulette_is_inuse(slot)
{
	return self gadgetisactive(slot);
}

/*
	Name: gadget_roulette_is_flickering
	Namespace: roulette
	Checksum: 0xEFC80A36
	Offset: 0x7A0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_roulette_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: gadget_roulette_on_flicker
	Namespace: roulette
	Checksum: 0xF7719FE7
	Offset: 0x7D0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_roulette_on_flicker(slot, weapon)
{
	self thread gadget_roulette_flicker(slot, weapon);
}

/*
	Name: gadget_roulette_on_give
	Namespace: roulette
	Checksum: 0x58E8B84D
	Offset: 0x810
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function gadget_roulette_on_give(slot, weapon)
{
	self clientfield::set_to_player("roulette_state", 0);
	if(sessionmodeismultiplayergame())
	{
		self.isroulette = 1;
	}
}

/*
	Name: gadget_roulette_on_take
	Namespace: roulette
	Checksum: 0x10114E8E
	Offset: 0x870
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_roulette_on_take(slot, weapon)
{
	/#
		if(level.devgui_giving_abilities === 1)
		{
			self.isroulette = 0;
		}
	#/
}

/*
	Name: gadget_roulette_on_connect
	Namespace: roulette
	Checksum: 0x6B12EDDB
	Offset: 0x8B0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function gadget_roulette_on_connect()
{
	roulette_init_allow_spin();
}

/*
	Name: roulette_init_allow_spin
	Namespace: roulette
	Checksum: 0x2172C970
	Offset: 0x8D0
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function roulette_init_allow_spin()
{
	if(self.isroulette === 1)
	{
		if(!isdefined(self.pers[#"hash_9f129a92"]))
		{
			self.pers[#"hash_9f129a92"] = 1;
		}
	}
}

/*
	Name: gadget_roulette_on_player_spawn
	Namespace: roulette
	Checksum: 0xA0D5FA2F
	Offset: 0x920
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function gadget_roulette_on_player_spawn()
{
	roulette_init_allow_spin();
}

/*
	Name: watch_entity_shutdown
	Namespace: roulette
	Checksum: 0x99EC1590
	Offset: 0x940
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function watch_entity_shutdown()
{
}

/*
	Name: gadget_roulette_on_activate
	Namespace: roulette
	Checksum: 0xEF5FFB71
	Offset: 0x950
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function gadget_roulette_on_activate(slot, weapon)
{
	gadget_roulette_give_earned_specialist(weapon, 1);
}

/*
	Name: gadget_roulette_is_ready
	Namespace: roulette
	Checksum: 0x1974859B
	Offset: 0x988
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function gadget_roulette_is_ready(slot, weapon)
{
	if(self gadgetisactive(slot))
	{
		return;
	}
	gadget_roulette_give_earned_specialist(weapon, 0);
}

/*
	Name: gadget_roulette_give_earned_specialist
	Namespace: roulette
	Checksum: 0x7FA172B2
	Offset: 0x9E0
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function gadget_roulette_give_earned_specialist(weapon, playsound)
{
	self giverandomweapon(weapon, 1);
	if(playsound)
	{
		self playsoundtoplayer("mpl_bm_specialist_roulette", self);
	}
	self thread watchgadgetactivated(weapon);
	self thread watchrespin(weapon);
}

/*
	Name: disable_hero_gadget_activation
	Namespace: roulette
	Checksum: 0xCDA3E507
	Offset: 0xA78
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function disable_hero_gadget_activation(duration)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"roulette_respin_activate");
	self disableoffhandspecial();
	wait(duration);
	self enableoffhandspecial();
}

/*
	Name: watchrespingadgetactivated
	Namespace: roulette
	Checksum: 0x881435A2
	Offset: 0xAE0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function watchrespingadgetactivated()
{
	self endon(#"watchrespingadgetactivated");
	self endon(#"death");
	self endon(#"disconnect");
	self waittill(#"hero_gadget_activated");
	self clientfield::set_to_player("roulette_state", 0);
}

/*
	Name: watchrespin
	Namespace: roulette
	Checksum: 0xBED0D6BE
	Offset: 0xB40
	Size: 0x1BA
	Parameters: 1
	Flags: Linked
*/
function watchrespin(weapon)
{
	self endon(#"hero_gadget_activated");
	self notify(#"watchrespin");
	self endon(#"watchrespin");
	if(!isdefined(self.pers[#"hash_9f129a92"]) || self.pers[#"hash_9f129a92"] == 0)
	{
		return;
	}
	self thread watchrespingadgetactivated();
	self clientfield::set_to_player("roulette_state", 1);
	wait(getdvarfloat("scr_roulette_pre_respin_wait_time", 1.3));
	while(true)
	{
		if(!isdefined(self))
		{
			break;
		}
		if(self dpad_left_pressed())
		{
			self.pers[#"hash_65987563"] = undefined;
			self giverandomweapon(weapon, 0);
			self.pers[#"hash_9f129a92"] = 0;
			self notify(#"watchrespingadgetactivated");
			self notify(#"roulette_respin_activate");
			self clientfield::set_to_player("roulette_state", 2);
			self playsoundtoplayer("mpl_bm_specialist_roulette", self);
			self thread reset_roulette_state_to_default();
			break;
		}
		wait(0.05);
	}
	if(isdefined(self))
	{
		self notify(#"watchrespingadgetactivated");
	}
}

/*
	Name: failsafe_reenable_offhand_special
	Namespace: roulette
	Checksum: 0x204F4D19
	Offset: 0xD08
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
	Name: reset_roulette_state_to_default
	Namespace: roulette
	Checksum: 0x548918D1
	Offset: 0xD48
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function reset_roulette_state_to_default()
{
	self endon(#"death");
	self endon(#"disconnect");
	wait(0.5);
	self clientfield::set_to_player("roulette_state", 0);
}

/*
	Name: watchgadgetactivated
	Namespace: roulette
	Checksum: 0x79BBB368
	Offset: 0xD98
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function watchgadgetactivated(weapon)
{
	self endon(#"death");
	self notify(#"watchgadgetactivated");
	self endon(#"watchgadgetactivated");
	self waittill(#"hero_gadget_activated");
	self.pers[#"hash_9f129a92"] = 1;
	if(isdefined(weapon) || weapon.name != "gadget_roulette")
	{
		self clientfield::set_to_player("roulette_state", 0);
	}
}

/*
	Name: giverandomweapon
	Namespace: roulette
	Checksum: 0xF0C00B47
	Offset: 0xE38
	Size: 0x23E
	Parameters: 2
	Flags: Linked
*/
function giverandomweapon(weapon, isprimaryroll)
{
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self._gadgets_player[i]))
		{
			self takeweapon(self._gadgets_player[i]);
		}
	}
	randomweapon = weapon;
	if(isdefined(self.pers[#"hash_65987563"]))
	{
		randomweapon = self.pers[#"hash_65987563"];
	}
	else
	{
		if(isdefined(self.pers[#"hash_cbcfa831"]) || isdefined(self.pers[#"hash_cbcfa832"]))
		{
			randomweapon = getrandomgadget(isprimaryroll);
			while(randomweapon == self.pers[#"hash_cbcfa831"] || (isdefined(self.pers[#"hash_cbcfa832"]) && randomweapon == self.pers[#"hash_cbcfa832"]))
			{
				randomweapon = getrandomgadget(isprimaryroll);
			}
		}
		else
		{
			randomweapon = getrandomgadget(isprimaryroll);
		}
	}
	if(isdefined(level.playgadgetready) && !isprimaryroll)
	{
		self thread [[level.playgadgetready]](randomweapon, !isprimaryroll);
	}
	self thread gadget_roulette_on_deactivate_helper(weapon);
	self giveweapon(randomweapon);
	self.pers[#"hash_65987563"] = randomweapon;
	self.pers[#"hash_cbcfa832"] = self.pers[#"hash_cbcfa831"];
	self.pers[#"hash_cbcfa831"] = randomweapon;
}

/*
	Name: gadget_roulette_on_deactivate
	Namespace: roulette
	Checksum: 0x6B212ACD
	Offset: 0x1080
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function gadget_roulette_on_deactivate(slot, weapon)
{
	thread gadget_roulette_on_deactivate_helper(weapon);
}

/*
	Name: gadget_roulette_on_deactivate_helper
	Namespace: roulette
	Checksum: 0x123A51E0
	Offset: 0x10B8
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function gadget_roulette_on_deactivate_helper(weapon)
{
	self notify(#"gadget_roulette_on_deactivate_helper");
	self endon(#"gadget_roulette_on_deactivate_helper");
	self waittill(#"heroability_off", weapon_off);
	if(isdefined(weapon_off) && weapon_off.name == "gadget_speed_burst")
	{
		self waittill(#"heroability_off", weapon_off);
	}
	for(i = 0; i < 3; i++)
	{
		if(isdefined(self) && isdefined(self._gadgets_player[i]))
		{
			self takeweapon(self._gadgets_player[i]);
		}
	}
	if(isdefined(self))
	{
		self giveweapon(level.gadget_roulette);
		self.pers[#"hash_65987563"] = undefined;
	}
}

/*
	Name: gadget_roulette_flicker
	Namespace: roulette
	Checksum: 0xE7AC1E92
	Offset: 0x11D0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_roulette_flicker(slot, weapon)
{
}

/*
	Name: set_gadget_status
	Namespace: roulette
	Checksum: 0x42E32B14
	Offset: 0x11F0
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
		self iprintlnbold(("Gadget Roulette: " + status) + timestr);
	}
}

/*
	Name: dpad_left_pressed
	Namespace: roulette
	Checksum: 0x786CCAB
	Offset: 0x1298
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function dpad_left_pressed()
{
	return self actionslotthreebuttonpressed();
}

/*
	Name: getrandomgadget
	Namespace: roulette
	Checksum: 0xB828D0D1
	Offset: 0x12C0
	Size: 0x166
	Parameters: 1
	Flags: Linked
*/
function getrandomgadget(isprimaryroll)
{
	if(isprimaryroll)
	{
		category = 0;
		totalcategory = 0;
	}
	else
	{
		category = 1;
		totalcategory = 1;
	}
	randomgadgetnumber = randomintrange(1, level.gadgetrouletteprobabilities[totalcategory] + 1);
	gadgetnames = getarraykeys(level.gadgetrouletteprobabilities);
	selectedgadget = "";
	foreach(gadget in gadgetnames)
	{
		randomgadgetnumber = randomgadgetnumber - level.gadgetrouletteprobabilities[gadget][category];
		if(randomgadgetnumber <= 0)
		{
			selectedgadget = gadget;
			break;
		}
	}
	return selectedgadget;
}

/*
	Name: registergadgettype
	Namespace: roulette
	Checksum: 0xF54AEB64
	Offset: 0x1430
	Size: 0x126
	Parameters: 3
	Flags: Linked
*/
function registergadgettype(gadgetnamestring, primaryweight, secondaryweight)
{
	gadgetweapon = getweapon(gadgetnamestring);
	/#
		assert(isdefined(gadgetweapon));
	#/
	if(gadgetweapon == level.weaponnone)
	{
		/#
			assertmsg(gadgetnamestring + "");
		#/
	}
	if(!isdefined(level.gadgetrouletteprobabilities[gadgetweapon]))
	{
		level.gadgetrouletteprobabilities[gadgetweapon] = [];
	}
	level.gadgetrouletteprobabilities[gadgetweapon][0] = primaryweight;
	level.gadgetrouletteprobabilities[gadgetweapon][1] = secondaryweight;
	level.gadgetrouletteprobabilities[0] = level.gadgetrouletteprobabilities[0] + primaryweight;
	level.gadgetrouletteprobabilities[1] = level.gadgetrouletteprobabilities[1] + secondaryweight;
}

