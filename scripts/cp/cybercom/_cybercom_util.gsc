// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_bb;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_tactical_rig_emergencyreserve;
#using scripts\cp\gametypes\_save;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace cybercom;

/*
	Name: wait_to_load
	Namespace: cybercom
	Checksum: 0x4145CA4F
	Offset: 0x808
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function wait_to_load()
{
	level flagsys::wait_till("load_main_complete");
	/#
		level thread cybercom_dev::cybercom_setupdevgui();
	#/
	setdvar("scr_max_simLocks", 5);
}

/*
	Name: vehicle_init_cybercom
	Namespace: cybercom
	Checksum: 0xFB05D0E3
	Offset: 0x870
	Size: 0x2EA
	Parameters: 1
	Flags: Linked
*/
function vehicle_init_cybercom(vehicle)
{
	if(isdefined(vehicle.archetype))
	{
		vehicle.var_9147087d = [];
		switch(vehicle.archetype)
		{
			case "hunter":
			{
				vehicle.nocybercom = 1;
				break;
			}
			case "quadtank":
			{
				vehicle cybercom_aioptout("cybercom_surge");
				vehicle cybercom_aioptout("cybercom_servoshortout");
				vehicle cybercom_aioptout("cybercom_systemoverload");
				vehicle cybercom_aioptout("cybercom_smokescreen");
				vehicle cybercom_aioptout("cybercom_immolate");
				vehicle.var_9147087d["cybercom_hijack"] = getdvarint("scr_hacktime_quadtank", 11);
				vehicle.var_9147087d["cybercom_iffoverride"] = getdvarint("scr_hacktime_quadtank", 11);
				vehicle.var_6c8af4c4 = 0;
				vehicle.var_ced13b2f = 1;
				break;
			}
			case "siegebot":
			{
				vehicle cybercom_aioptout("cybercom_surge");
				vehicle cybercom_aioptout("cybercom_servoshortout");
				vehicle cybercom_aioptout("cybercom_smokescreen");
				vehicle cybercom_aioptout("cybercom_immolate");
				vehicle.var_9147087d["cybercom_hijack"] = getdvarint("scr_hacktime_siegebot", 9);
				vehicle.var_9147087d["cybercom_iffoverride"] = getdvarint("scr_hacktime_siegebot", 9);
				vehicle.var_6c8af4c4 = 0;
				vehicle.var_ced13b2f = 1;
				break;
			}
			case "glaive":
			case "parasite":
			{
				vehicle.nocybercom = 1;
			}
			default:
			{
				break;
			}
		}
	}
}

/*
	Name: function_79bafe1d
	Namespace: cybercom
	Checksum: 0x6561C314
	Offset: 0xB68
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_79bafe1d(vehicle)
{
	vehicle clientfield::set("cybercom_shortout", 0);
	vehicle clientfield::set("cybercom_surge", 0);
}

/*
	Name: function_fabadf47
	Namespace: cybercom
	Checksum: 0x8B6F84FA
	Offset: 0xBC0
	Size: 0x4E
	Parameters: 2
	Flags: Linked
*/
function function_fabadf47(vehicle, issystemup)
{
	if(issystemup)
	{
		vehicle.var_f40d252c = 1;
	}
	else
	{
		vehicle.var_d3f57f67 = undefined;
		vehicle.var_f40d252c = undefined;
	}
}

/*
	Name: getcybercomflags
	Namespace: cybercom
	Checksum: 0x83C8EF19
	Offset: 0xC18
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function getcybercomflags()
{
	self.cybercom.flags.tacrigs = self getcybercomrigs();
	self populatecybercomunlocks();
	self.cybercom.flags.type = self getcybercomactivetype();
	self.cybercom.flags.abilities = [];
	self.cybercom.flags.upgrades = [];
	for(i = 0; i <= 2; i++)
	{
		self.cybercom.flags.abilities[i] = self getcybercomabilities(i);
		self.cybercom.flags.upgrades[i] = self getcybercomupgrades(i);
	}
}

/*
	Name: updatecybercomflags
	Namespace: cybercom
	Checksum: 0xEA6ACD9D
	Offset: 0xD70
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function updatecybercomflags()
{
	self getcybercomflags();
	self.cybercom.ccom_abilities = self cybercom_gadget::getavailableabilities();
	self.cybercom.menu = "AbilityWheel";
	self.pers["cybercom_flags"] = self.cybercom.flags;
}

/*
	Name: setcybercomflags
	Namespace: cybercom
	Checksum: 0xDA0CE597
	Offset: 0xDF8
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function setcybercomflags()
{
	self setcybercomrigsflags(self.cybercom.flags.tacrigs);
	self setcybercomactivetype(self.cybercom.flags.type);
	for(i = 0; i <= 2; i++)
	{
		self setcybercomabilityflags(self.cybercom.flags.abilities[i], i);
		self setcybercomupgradeflags(self.cybercom.flags.upgrades[i], i);
	}
}

/*
	Name: setabilitiesbyflags
	Namespace: cybercom
	Checksum: 0x72C9F525
	Offset: 0xEF8
	Size: 0x20A
	Parameters: 1
	Flags: Linked
*/
function setabilitiesbyflags(flags)
{
	if(isdefined(flags))
	{
		self.cybercom.flags = flags;
	}
	self setcybercomflags();
	self updatecybercomflags();
	foreach(ability in self.cybercom.ccom_abilities)
	{
		status = self hascybercomability(ability.name);
		if(status == 0)
		{
			continue;
		}
		self cybercom_gadget::meleeabilitygiven(ability, status == 2);
	}
	foreach(ability in level._cybercom_rig_ability)
	{
		status = self hascybercomrig(ability.name);
		if(status == 0)
		{
			continue;
		}
		self cybercom_tacrig::rigabilitygiven(ability.name, status == 2);
	}
}

/*
	Name: function_cc812e3b
	Namespace: cybercom
	Checksum: 0xDC551EBC
	Offset: 0x1110
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function function_cc812e3b(var_632e4fca)
{
	itemindex = getitemindexfromref(var_632e4fca + "_pro");
	if(itemindex != -1)
	{
		return self isitempurchased(itemindex);
	}
	return 0;
}

/*
	Name: function_8b088b97
	Namespace: cybercom
	Checksum: 0x8BA64885
	Offset: 0x1178
	Size: 0x1BA
	Parameters: 1
	Flags: Linked
*/
function function_8b088b97(cybercore_type)
{
	debugmsg("CYBERCORE: " + cybercore_type);
	abilities = cybercom_gadget::getabilitiesfortype(cybercore_type);
	foreach(ability in abilities)
	{
		itemindex = getitemindexfromref(ability.name);
		if(self isitempurchased(itemindex))
		{
			upgraded = self function_cc812e3b(ability.name);
			self setcybercomability(ability.name, upgraded);
			debugmsg((ability.name + " UPGRADED: ") + upgraded);
			continue;
		}
		debugmsg(ability.name + " NOT INSTALLED");
	}
}

/*
	Name: function_1e4531c7
	Namespace: cybercom
	Checksum: 0x9F684B2C
	Offset: 0x1340
	Size: 0xC6
	Parameters: 1
	Flags: Linked
*/
function function_1e4531c7(var_e4230c26)
{
	switch(var_e4230c26)
	{
		case 0:
		{
			self cybercom_gadget::meleeabilitygiven(cybercom_gadget::getabilitybyname("cybercom_ravagecore"));
			break;
		}
		case 1:
		{
			self cybercom_gadget::meleeabilitygiven(cybercom_gadget::getabilitybyname("cybercom_rapidstrike"));
			break;
		}
		case 2:
		{
			self cybercom_gadget::meleeabilitygiven(cybercom_gadget::getabilitybyname("cybercom_es_strike"));
			break;
		}
	}
}

/*
	Name: function_1adaa876
	Namespace: cybercom
	Checksum: 0xAC7A0738
	Offset: 0x1410
	Size: 0x3AA
	Parameters: 2
	Flags: Linked
*/
function function_1adaa876(var_e4230c26, var_f4132a83)
{
	if(sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	var_d66f8a9e = int(self getdstat("PlayerStatsList", "LAST_CYBERCOM_EQUIPPED", "statValue"));
	var_2324b7c = var_d66f8a9e & (1024 - 1);
	var_768ee804 = var_d66f8a9e >> 10;
	self function_1e4531c7(var_e4230c26);
	if(isdefined(var_f4132a83) && var_f4132a83 && var_2324b7c > 99 && var_2324b7c < 142)
	{
		var_cac3be21 = tablelookup("gamedata/stats/cp/cp_statstable.csv", 0, var_2324b7c, 4);
		var_b5725157 = cybercom_gadget::getabilitybyname(var_cac3be21);
		if(self hascybercomability(var_b5725157.name))
		{
			if(var_e4230c26 == var_b5725157.type || self function_6e0bf068() || (isdefined(self.cybercoreselectmenudisabled) && self.cybercoreselectmenudisabled == 1))
			{
				self setcybercomactivetype(var_b5725157.type);
				self.var_768ee804 = var_768ee804;
				self cybercom_gadget::equipability(var_b5725157.name, 0);
				self setcontrolleruimodelvalue("AbilityWheel.Selected" + (var_b5725157.type + 1), self.var_768ee804);
				return;
			}
		}
	}
	self clientfield::set_to_player("resetAbilityWheel", 1);
	self setcybercomactivetype(var_e4230c26);
	abilities = cybercom_gadget::getabilitiesfortype(var_e4230c26);
	abilityindex = 1;
	foreach(ability in abilities)
	{
		if(self hascybercomability(ability.name))
		{
			self.var_768ee804 = abilityindex;
			self cybercom_gadget::equipability(ability.name, 0);
			self setcontrolleruimodelvalue("AbilityWheel.Selected" + (ability.type + 1), abilityindex);
			return;
		}
		abilityindex++;
	}
}

/*
	Name: function_6e0bf068
	Namespace: cybercom
	Checksum: 0xB6C787F1
	Offset: 0x17C8
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function function_6e0bf068()
{
	return (self.cur_ranknum + 1) >= 20 || (isdefined(self.var_8201758a) && (isdefined(self.var_8201758a) && self.var_8201758a));
}

/*
	Name: function_674d724c
	Namespace: cybercom
	Checksum: 0x1576CD02
	Offset: 0x1810
	Size: 0x1DC
	Parameters: 3
	Flags: Linked
*/
function function_674d724c(class_num_for_global_weapons, var_f4132a83, var_f69e782a = 1)
{
	self endon(#"death_or_disconnect");
	if(!isdefined(self.cybercoreselectmenudisabled) || self.cybercoreselectmenudisabled != 1)
	{
		for(cybercore_type = 0; cybercore_type <= 2; cybercore_type++)
		{
			self function_8b088b97(cybercore_type);
		}
	}
	var_d1833846["cybercore_control"] = 0;
	var_d1833846["cybercore_martial"] = 1;
	var_d1833846["cybercore_chaos"] = 2;
	var_fb135494 = self getloadoutitemref(0, "cybercore");
	if(var_fb135494 != "weapon_null" && var_fb135494 != "weapon_null_cp" && isdefined(var_d1833846[var_fb135494]))
	{
		self function_1adaa876(var_d1833846[var_fb135494], var_f4132a83);
		self updatecybercomflags();
	}
	if(var_f69e782a)
	{
		ret = self util::waittill_any_timeout(7, "loadout_changed");
		if(ret != "timeout")
		{
			function_674d724c(class_num_for_global_weapons, var_f4132a83, 0);
		}
	}
}

/*
	Name: function_4b8ac464
	Namespace: cybercom
	Checksum: 0x7B0D5022
	Offset: 0x19F8
	Size: 0x51C
	Parameters: 4
	Flags: Linked
*/
function function_4b8ac464(class_num, class_num_for_global_weapons, var_f4132a83, altplayer)
{
	self clearcybercomability();
	rig1 = self getloadoutitemref(class_num, "cybercom_tacrig1");
	rig2 = self getloadoutitemref(class_num, "cybercom_tacrig2");
	if(isdefined(altplayer))
	{
		rig1 = altplayer getloadoutitemref(class_num, "cybercom_tacrig1");
		rig2 = altplayer getloadoutitemref(class_num, "cybercom_tacrig2");
	}
	if(strendswith(rig1, "_pro"))
	{
		rig1 = getsubstr(rig1, 0, rig1.size - 4);
		rig1_upgraded = 1;
	}
	else
	{
		rig1_upgraded = 0;
	}
	if(strendswith(rig2, "_pro"))
	{
		rig2 = getsubstr(rig2, 0, rig2.size - 4);
		rig2_upgraded = 1;
	}
	else
	{
		rig2_upgraded = 0;
	}
	if(isdefined(self.var_8201758a) && self.var_8201758a)
	{
		rig1_upgraded = 1;
		rig2_upgraded = 1;
	}
	else if(class_num < 5)
	{
		rig1_upgraded = self function_cc812e3b(rig1);
		rig2_upgraded = self function_cc812e3b(rig2);
		if(isdefined(altplayer))
		{
			rig1_upgraded = altplayer function_cc812e3b(rig1);
			rig2_upgraded = altplayer function_cc812e3b(rig2);
		}
	}
	self cybercom_tacrig::takeallrigabilities();
	if(!self flag::exists("in_training_sim") || !self flag::get("in_training_sim"))
	{
		saved_rig1 = self savegame::get_player_data("saved_rig1", undefined);
		if(isdefined(saved_rig1))
		{
			rig1 = saved_rig1;
			rig1_upgraded = self savegame::get_player_data("saved_rig1_upgraded", undefined);
			rig2 = self savegame::get_player_data("saved_rig2", undefined);
			rig2_upgraded = self savegame::get_player_data("saved_rig2_upgraded", undefined);
			/#
				assert(isdefined(rig1_upgraded));
			#/
		}
	}
	self cybercom_tacrig::giverigability(rig1, rig1_upgraded, 0, 0);
	self cybercom_tacrig::giverigability(rig2, rig2_upgraded, 1, 0);
	if(!self flag::exists("in_training_sim") || !self flag::get("in_training_sim"))
	{
		self savegame::set_player_data("saved_rig1", rig1);
		self savegame::set_player_data("saved_rig1_upgraded", rig1_upgraded);
		self savegame::set_player_data("saved_rig2", rig2);
		self savegame::set_player_data("saved_rig2_upgraded", rig2_upgraded);
	}
	debugmsg((("RIG1: " + rig1) + " UPGRADED:") + rig1_upgraded);
	debugmsg((("RIG2: " + rig2) + " UPGRADED:") + rig2_upgraded);
	self thread function_674d724c(class_num_for_global_weapons, var_f4132a83);
}

/*
	Name: weaponlockwatcher
	Namespace: cybercom
	Checksum: 0xF4EED652
	Offset: 0x1F20
	Size: 0x12C
	Parameters: 3
	Flags: Linked
*/
function weaponlockwatcher(slot, weapon, maxlocks)
{
	self endon(#"disconnect");
	self endon(#"death");
	self cybercom_initentityfields();
	if(!isdefined(self.cybercom.lock_targets))
	{
		self.cybercom.lock_targets = [];
	}
	locks = (isdefined(maxlocks) ? maxlocks : getdvarint("scr_max_simLocks"));
	/#
		assert(locks <= 5, "");
	#/
	self thread function_17fea3ed(slot, weapon, locks);
	self thread function_d4f9f451(slot, weapon);
	self thread function_348de0be(slot, weapon);
}

/*
	Name: function_348de0be
	Namespace: cybercom
	Checksum: 0x349145F9
	Offset: 0x2058
	Size: 0x234
	Parameters: 2
	Flags: Linked
*/
function function_348de0be(slot, weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"weaponendlockwatcher");
	self endon(#"ccom_stop_lock_on");
	self notify(#"hash_348de0be");
	self endon(#"hash_348de0be");
	if(!isdefined(self.cybercom.var_46483c8f))
	{
		return;
	}
	if(self.cybercom.var_46483c8f & 1)
	{
		self thread function_86113d72("weapon_change");
	}
	if(self.cybercom.var_46483c8f & 2)
	{
		self thread function_86113d72("reload");
	}
	if(self.cybercom.var_46483c8f & 4)
	{
		self thread function_86113d72("weapon_fired");
	}
	if(self.cybercom.var_46483c8f & 8)
	{
		self thread function_86113d72("weapon_melee");
		self thread function_86113d72("melee_end");
	}
	if(self.cybercom.var_46483c8f & 16)
	{
		self thread function_86113d72("weapon_ads");
	}
	if(self.cybercom.var_46483c8f & 32)
	{
		self thread function_86113d72("damage");
	}
	self waittill(#"hash_3b3a12de", reason);
	self function_29bf9dee(undefined, 8);
	self gadgetdeactivate(slot, weapon, 1);
}

/*
	Name: function_86113d72
	Namespace: cybercom
	Checksum: 0x2E07B05E
	Offset: 0x2298
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function function_86113d72(note)
{
	self endon(#"ccom_stop_lock_on");
	self endon(#"hash_3b3a12de");
	self waittill(note);
	self notify(#"hash_3b3a12de", note);
}

/*
	Name: function_d4f9f451
	Namespace: cybercom
	Checksum: 0x99A54AB2
	Offset: 0x22E0
	Size: 0x1E4
	Parameters: 2
	Flags: Linked
*/
function function_d4f9f451(slot, weapon)
{
	self notify(#"hash_d4f9f451");
	self endon(#"hash_d4f9f451");
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"weaponendlockwatcher");
	self endon(#"ccom_stop_lock_on");
	while(true)
	{
		for(i = 0; i < self.cybercom.lock_targets.size; i++)
		{
			if(!isdefined(self.cybercom.lock_targets[i].target))
			{
				continue;
			}
			if(!isdefined(self.cybercom.lock_targets[i].target.lockon_owner) || self.cybercom.lock_targets[i].target.lockon_owner != self)
			{
				continue;
			}
			if(isdefined(self.cybercom.lock_targets[i].target.var_1e1a5e6f) && self.cybercom.lock_targets[i].target.var_1e1a5e6f != 1)
			{
				continue;
			}
			if(isdefined(self.cybercom.var_73d069a7))
			{
				function_c5b2f654(self);
				[[self.cybercom.var_73d069a7]](slot, weapon);
				return;
			}
		}
		wait(0.05);
	}
}

/*
	Name: weaponendlockwatcher
	Namespace: cybercom
	Checksum: 0x220A16AA
	Offset: 0x24D0
	Size: 0x62
	Parameters: 1
	Flags: Linked
*/
function weaponendlockwatcher(weapon)
{
	self function_a3e55896(weapon);
	waittillframeend();
	weapon_lock_clearslots(1);
	self function_f5799ee1();
	self notify(#"ccom_stop_lock_on");
}

/*
	Name: function_f5c296aa
	Namespace: cybercom
	Checksum: 0xDB7C2801
	Offset: 0x2540
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_f5c296aa(weapon)
{
	self notify(#"weaponendlockwatcher");
	self endon(#"weaponendlockwatcher");
	self endon(#"ccom_stop_lock_on");
	self waittill(#"gadget_forced_off", slot, var_188a4cc0);
	if(weapon == var_188a4cc0)
	{
		self weaponendlockwatcher(weapon);
	}
	else
	{
		self thread function_f5c296aa(weapon);
	}
}

/*
	Name: _lock_fired_watcher
	Namespace: cybercom
	Checksum: 0x944238D
	Offset: 0x25E8
	Size: 0x18C
	Parameters: 1
	Flags: Linked, Private
*/
function private _lock_fired_watcher(weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"ccom_stop_lock_on");
	event = self util::waittill_any_return(weapon.name + "_fired");
	level notify(#"ccom_lock_fired", self, weapon);
	foreach(item in self.cybercom.lock_targets)
	{
		if(isdefined(item.target))
		{
			item.target notify(#"ccom_lock_fired", self, weapon);
			if(isdefined(item.target.lockon_owner) && item.target.lockon_owner == self)
			{
				item.target.lockon_owner = undefined;
			}
		}
	}
	self weaponendlockwatcher(weapon);
}

/*
	Name: _lock_sighttest
	Namespace: cybercom
	Checksum: 0x9030ED22
	Offset: 0x2780
	Size: 0x570
	Parameters: 2
	Flags: Linked, Private
*/
function private _lock_sighttest(target, var_b3464abe = 1)
{
	eyepos = self geteye();
	if(!isdefined(target))
	{
		return 0;
	}
	if(!isalive(target))
	{
		return 0;
	}
	if(target isragdoll())
	{
		return 0;
	}
	if(!isdefined(target.cybercom))
	{
		target.cybercom = spawnstruct();
	}
	if(!isdefined(target.cybercom.var_8d2f4636))
	{
		target.cybercom.var_8d2f4636 = [];
	}
	pos = target getshootatpos();
	if(isdefined(pos))
	{
		passed = bullettracepassed(eyepos, pos, 0, target, undefined, 1, 1);
		if(passed)
		{
			target.cybercom.var_8d2f4636[self getentitynumber()] = gettime();
			return 1;
		}
	}
	pos = target getcentroid();
	if(isdefined(pos))
	{
		passed = bullettracepassed(eyepos, pos, 0, target, undefined, 1, 1);
		if(passed)
		{
			target.cybercom.var_8d2f4636[self getentitynumber()] = gettime();
			return 1;
		}
	}
	if(var_b3464abe)
	{
		mins = target getmins();
		maxs = target getmaxs();
		var_d11e725f = (maxs[2] - mins[2]) / 4;
		for(i = 0; i <= 4; i++)
		{
			pos = target.origin + (0, 0, var_d11e725f * i);
			passed = bullettracepassed(eyepos, pos, 0, target, undefined, 1, 1);
			if(passed)
			{
				target.cybercom.var_8d2f4636[self getentitynumber()] = gettime();
				return 1;
			}
			pos = target.origin + (mins[0], mins[1], var_d11e725f * i);
			passed = bullettracepassed(eyepos, pos, 0, target, undefined, 1, 1);
			if(passed)
			{
				target.cybercom.var_8d2f4636[self getentitynumber()] = gettime();
				return 1;
			}
			pos = target.origin + (maxs[0], maxs[1], var_d11e725f * i);
			passed = bullettracepassed(eyepos, pos, 0, target, undefined, 1, 1);
			if(passed)
			{
				target.cybercom.var_8d2f4636[self getentitynumber()] = gettime();
				return 1;
			}
		}
		var_cb365fdc = target.cybercom.var_8d2f4636[self getentitynumber()];
		if(isdefined(var_cb365fdc) && (var_cb365fdc + getdvarint("scr_los_latency", 3000)) > gettime())
		{
			trace = bullettrace(eyepos, pos, 0, target);
			distsq = distancesquared(pos, trace["position"]);
			if(distsq <= (getdvarint("scr_cached_dist_threshhold", 315 * 315)))
			{
				return 2;
			}
			return 0;
		}
	}
	return 0;
}

/*
	Name: targetisvalid
	Namespace: cybercom
	Checksum: 0x682E7666
	Offset: 0x2CF8
	Size: 0x318
	Parameters: 3
	Flags: Linked
*/
function targetisvalid(target, weapon, lockreq = 1)
{
	result = 1;
	if(!isdefined(target))
	{
		return 0;
	}
	if(!isalive(target))
	{
		return 0;
	}
	if(target isragdoll())
	{
		return 0;
	}
	if(isdefined(target.is_disabled) && target.is_disabled)
	{
		return 0;
	}
	if(!(isdefined(target.takedamage) && target.takedamage))
	{
		return 0;
	}
	if(isdefined(target._ai_melee_opponent))
	{
		return 0;
	}
	if(isactor(target) && (!target isonground() || isdefined(target.traversestartnode)))
	{
		return 0;
	}
	if(isdefined(target.cybercomtargetstatusoverride))
	{
		if(target.cybercomtargetstatusoverride == 0)
		{
			return 0;
		}
	}
	else
	{
		if(isdefined(target.magic_bullet_shield) && target.magic_bullet_shield)
		{
			return 0;
		}
		if(isactor(target) && target isinscriptedstate())
		{
			if(isdefined(self.rider_info))
			{
				if(isdefined(self.rider_info.position) && issubstr(self.rider_info.position, "gunner"))
				{
					return 1;
				}
			}
		}
		if(isdefined(target.allowdeath) && !target.allowdeath)
		{
			return 0;
		}
	}
	if(lockreq && isdefined(self.cybercom) && isdefined(self.cybercom.targetlockrequirementcb))
	{
		result = self [[self.cybercom.targetlockrequirementcb]](target);
	}
	if(result && isdefined(level.var_732e9c7d))
	{
		result = result & [[level.var_732e9c7d]](self, target, weapon);
	}
	if(isdefined(target.var_fb7ce72a))
	{
		temp_result = target [[target.var_fb7ce72a]](self, weapon);
		if(isdefined(temp_result))
		{
			return temp_result;
		}
	}
	return result;
}

/*
	Name: weapon_lock_meetsrangerequirement
	Namespace: cybercom
	Checksum: 0xF31E072
	Offset: 0x3018
	Size: 0xC4
	Parameters: 3
	Flags: Linked
*/
function weapon_lock_meetsrangerequirement(target, maxrange, weapon)
{
	if(isdefined(target.var_fb7ce72a))
	{
		var_a3ded052 = target [[target.var_fb7ce72a]](self, weapon);
		if(isdefined(var_a3ded052))
		{
			return var_a3ded052;
		}
	}
	if(isdefined(maxrange))
	{
		distancesqr = distancesquared(target.origin, self.origin);
		if(distancesqr > (maxrange * maxrange))
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: weapon_lock_meetsrequirement
	Namespace: cybercom
	Checksum: 0xD6AC58B7
	Offset: 0x30E8
	Size: 0x268
	Parameters: 4
	Flags: Linked
*/
function weapon_lock_meetsrequirement(target, radius, weapon, maxrange)
{
	result = 1;
	if(isdefined(target.var_fb7ce72a))
	{
		var_a3ded052 = target [[target.var_fb7ce72a]](self, weapon);
		if(isdefined(var_a3ded052))
		{
			return var_a3ded052;
		}
	}
	isvalid = self targetisvalid(target, weapon);
	if(!(isdefined(isvalid) && isvalid))
	{
		self function_29bf9dee(target, 1);
		return 0;
	}
	if(isdefined(maxrange))
	{
		distancesqr = distancesquared(target.origin, self.origin);
		if(distancesqr > (maxrange * maxrange))
		{
			self function_29bf9dee(target, 3);
			return 0;
		}
	}
	var_edc325e = self _lock_sighttest(target);
	if(var_edc325e == 0)
	{
		self function_29bf9dee(target, 5);
		return 0;
	}
	if(var_edc325e == 2)
	{
		radius = radius * 2;
	}
	if(isdefined(radius))
	{
		distsq = distancesquared(self.origin, target.origin);
		if(distsq > (144 * 144))
		{
			result = target_isincircle(target, self, 65, radius);
		}
	}
	if(result == 0)
	{
		self function_29bf9dee(target, 1);
	}
	return result;
}

/*
	Name: targetinsertionsortcompare
	Namespace: cybercom
	Checksum: 0x39735DC
	Offset: 0x3358
	Size: 0x60
	Parameters: 2
	Flags: Linked
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
	Name: function_18d9de78
	Namespace: cybercom
	Checksum: 0xCFAB4795
	Offset: 0x33C0
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function function_18d9de78(target)
{
	if(isdefined(target.lockon_owner) && target.lockon_owner == self)
	{
		function_c5b2f654(self);
		target.var_6c8af4c4 = gettime() - target.var_9d876bed;
		target thread function_5ad57748();
		target.var_9d876bed = undefined;
		target.var_87aa3c26 = gettime() + 150;
		target.lockon_owner = undefined;
		target.var_9d876bed = undefined;
		target.var_1e1a5e6f = undefined;
		self notify(#"hash_9641f650");
		self notify(#"ccom_lost_lock", target);
	}
}

/*
	Name: weapon_lock_clearslot
	Namespace: cybercom
	Checksum: 0xBB559609
	Offset: 0x34B8
	Size: 0x112
	Parameters: 3
	Flags: Linked
*/
function weapon_lock_clearslot(slot, note, clearprogress)
{
	if(isdefined(self.cybercom.lock_targets[slot]))
	{
		item = self.cybercom.lock_targets[slot];
		if(isdefined(item.target))
		{
			if(isdefined(note))
			{
				item.target notify(note);
			}
			self weaponlocknoclearance(0, item.lockslot);
			self weaponlockremoveslot(item.lockslot);
			if(isdefined(clearprogress) && clearprogress)
			{
				self function_18d9de78(item.target);
			}
			item.target = undefined;
		}
	}
}

/*
	Name: _weapon_lock_targetwatchfordeath
	Namespace: cybercom
	Checksum: 0x139CCEE0
	Offset: 0x35D8
	Size: 0xB4
	Parameters: 1
	Flags: Linked, Private
*/
function private _weapon_lock_targetwatchfordeath(player)
{
	self endon(#"ccom_lost_lock");
	self notify(#"_weapon_lock_targetwatchfordeath");
	self endon(#"_weapon_lock_targetwatchfordeath");
	slot = player weapon_lock_alreadylocked(self);
	self util::waittill_any("death", "ccom_lock_fired", "ccom_lock_aborted_unique");
	player weaponlocknoclearance(0, slot);
	player weaponlockremoveslot(slot);
}

/*
	Name: weapon_lock_settargettoslot
	Namespace: cybercom
	Checksum: 0xCD9A3CF8
	Offset: 0x3698
	Size: 0x5E4
	Parameters: 4
	Flags: Linked
*/
function weapon_lock_settargettoslot(slot, target, maxrange, weapon)
{
	if(slot == -1 || slot >= getdvarint("scr_max_simLocks"))
	{
		return;
	}
	if(isdefined(target.var_87aa3c26) && gettime() < target.var_87aa3c26)
	{
		return;
	}
	if(isdefined(self.cybercom.lock_targets[slot]))
	{
		self weapon_lock_clearslot(slot, "ccom_lost_lock");
		newitem = self.cybercom.lock_targets[slot];
		newitem.target = target;
	}
	else
	{
		newitem = spawnstruct();
		newitem.target = target;
		newitem.lockslot = slot;
		self.cybercom.lock_targets[slot] = newitem;
	}
	if(isdefined(newitem.target))
	{
		if(isdefined(newitem.target.var_9147087d) && isdefined(newitem.target.var_9147087d[self.cybercom.lastequipped.name]))
		{
			if(!isdefined(newitem.target.lockon_owner))
			{
				newitem.target.var_9d876bed = gettime() - newitem.target.var_6c8af4c4;
				newitem.target.lockon_owner = self;
				newitem.target notify(#"hash_1bf7ef5");
				var_9df7c303 = newitem.target.var_6c8af4c4 / (newitem.target.var_9147087d[self.cybercom.lastequipped.name] * 1000);
				function_eae88e7f(self, newitem.target.var_9147087d[self.cybercom.lastequipped.name], var_9df7c303);
				level thread function_9641f650(self);
			}
			if(isdefined(newitem.target.lockon_owner) && newitem.target.lockon_owner == self)
			{
				newitem.target.var_1e1a5e6f = math::clamp((gettime() - newitem.target.var_9d876bed) / (newitem.target.var_9147087d[self.cybercom.lastequipped.name] * 1000), 0, 1);
			}
		}
		self weaponlockstart(newitem.target, newitem.lockslot);
		newitem.inrange = 1;
		if(!self weapon_lock_meetsrangerequirement(newitem.target, maxrange, weapon))
		{
			newitem.inrange = 0;
			self weaponlocknoclearance(1, slot);
		}
		if(isdefined(newitem.target.var_1e1a5e6f))
		{
			if(newitem.target.lockon_owner == self)
			{
				if(newitem.target.var_1e1a5e6f != 1)
				{
					newitem.inrange = 2;
					self weaponlocknoclearance(1, slot);
				}
			}
			else
			{
				newitem.inrange = 0;
				self weaponlocknoclearance(1, slot);
			}
		}
		if(newitem.inrange == 1)
		{
			function_c5b2f654(self);
			self weaponlocknoclearance(0, slot);
			self weaponlockfinalize(newitem.target, newitem.lockslot);
			newitem.target notify(#"ccom_locked_on", self);
			level notify(#"ccom_locked_on", newitem.target, self);
		}
		else
		{
			newitem.target notify(#"ccom_lock_being_targeted", self);
			level notify(#"ccom_lock_being_targeted", newitem.target, self);
		}
		newitem.target thread _weapon_lock_targetwatchfordeath(self);
	}
}

/*
	Name: function_eae88e7f
	Namespace: cybercom
	Checksum: 0x75E99DFA
	Offset: 0x3C88
	Size: 0xE4
	Parameters: 3
	Flags: Linked
*/
function function_eae88e7f(hacker, duration, startratio)
{
	val = duration & 31;
	if(startratio > 0)
	{
		cur = math::clamp(startratio, 0, 1);
		offset = (int(cur * 128)) << 5;
		val = val + offset;
	}
	hacker clientfield::set_to_player("hacking_progress", val);
	hacker clientfield::set_to_player("sndCCHacking", 1);
}

/*
	Name: function_c5b2f654
	Namespace: cybercom
	Checksum: 0xDC432AEA
	Offset: 0x3D78
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_c5b2f654(hacker)
{
	if(isdefined(hacker))
	{
		hacker clientfield::set_to_player("hacking_progress", 0);
		hacker clientfield::set_to_player("sndCCHacking", 0);
	}
}

/*
	Name: function_9641f650
	Namespace: cybercom
	Checksum: 0xEF551414
	Offset: 0x3DD8
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_9641f650(hacker)
{
	hacker endon(#"disconnect");
	hacker notify(#"hash_9641f650");
	hacker endon(#"hash_9641f650");
	hacker util::waittill_any("death", "ccom_lockOnProgress_Cleared", "ccom_lost_lock", "ccom_locked_on");
	function_c5b2f654(hacker);
}

/*
	Name: weapon_lock_alreadylocked
	Namespace: cybercom
	Checksum: 0xF74302BD
	Offset: 0x3E68
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function weapon_lock_alreadylocked(target)
{
	for(i = 0; i < self.cybercom.lock_targets.size; i++)
	{
		if(!isdefined(self.cybercom.lock_targets[i].target))
		{
			continue;
		}
		if(self.cybercom.lock_targets[i].target == target)
		{
			return i;
		}
	}
	return -1;
}

/*
	Name: weapon_lock_getlockedontargets
	Namespace: cybercom
	Checksum: 0x717D8181
	Offset: 0x3F10
	Size: 0xA2
	Parameters: 0
	Flags: None
*/
function weapon_lock_getlockedontargets()
{
	targets = [];
	for(i = 0; i < self.cybercom.lock_targets.size; i++)
	{
		if(!isdefined(self.cybercom.lock_targets[i].target))
		{
			continue;
		}
		targets[targets.size] = self.cybercom.lock_targets[i].target;
	}
	return targets;
}

/*
	Name: weapon_lock_getslot
	Namespace: cybercom
	Checksum: 0xEE1FA0CB
	Offset: 0x3FC0
	Size: 0x362
	Parameters: 2
	Flags: Linked
*/
function weapon_lock_getslot(target, force = 0)
{
	if(self.cybercom.lock_targets.size < getdvarint("scr_max_simLocks"))
	{
		return self.cybercom.lock_targets.size;
	}
	alreadyinslot = self weapon_lock_alreadylocked(target);
	if(alreadyinslot != -1)
	{
		return alreadyinslot;
	}
	slot = -1;
	playerforward = anglestoforward(self getplayerangles());
	dots = [];
	for(i = 0; i < self.cybercom.lock_targets.size; i++)
	{
		locktarget = self.cybercom.lock_targets[i].target;
		if(!isdefined(locktarget))
		{
			return i;
		}
		newitem = spawnstruct();
		newitem.dot = vectordot(playerforward, vectornormalize(locktarget.origin - self.origin));
		var_f72b478f = (isdefined(self.cybercom.var_f72b478f) ? self.cybercom.var_f72b478f : 0.83);
		if(newitem.dot > var_f72b478f)
		{
			newitem.target = locktarget;
			array::insertion_sort(dots, &targetinsertionsortcompare, newitem);
		}
	}
	newitem = spawnstruct();
	newitem.dot = vectordot(playerforward, vectornormalize(target.origin - self.origin));
	newitem.target = target;
	array::insertion_sort(dots, &targetinsertionsortcompare, newitem);
	worsttarget = dots[dots.size - 1].target;
	if(!force && worsttarget == target)
	{
		return -1;
	}
	return self weapon_lock_alreadylocked(worsttarget);
}

/*
	Name: weapon_lock_clearslots
	Namespace: cybercom
	Checksum: 0xC6E9F9CF
	Offset: 0x4330
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function weapon_lock_clearslots(clearprogress = 0)
{
	if(isdefined(self.cybercom) && isdefined(self.cybercom.lock_targets))
	{
		for(i = 0; i < self.cybercom.lock_targets.size; i++)
		{
			self weapon_lock_clearslot(i, undefined, clearprogress);
		}
	}
	self weaponlockremoveslot(-1);
	self.cybercom.lock_targets = [];
}

/*
	Name: function_b5f4e597
	Namespace: cybercom
	Checksum: 0x6EFEC0A0
	Offset: 0x43F8
	Size: 0x304
	Parameters: 1
	Flags: Linked
*/
function function_b5f4e597(weapon)
{
	self endon(#"disconnect");
	self notify(#"hash_b5f4e597");
	self endon(#"hash_b5f4e597");
	if(weapon.requirelockontofire)
	{
		maxrange = 1500;
		if(isdefined(weapon.lockonmaxrange))
		{
			maxrange = weapon.lockonmaxrange;
		}
		maxrangesqr = maxrange * maxrange;
	}
	else
	{
		maxrangesqr = 0;
	}
	var_6f023b72 = 0;
	while(self hasweapon(weapon))
	{
		if(maxrangesqr > 0)
		{
			if(isdefined(self.cybercom.targetlockcb))
			{
				enemies = self [[self.cybercom.targetlockcb]](weapon);
			}
			else
			{
				enemies = arraycombine(getaiteamarray("axis"), getaiteamarray("team3"), 0, 0);
			}
			foreach(enemy in enemies)
			{
				distsq = distancesquared(self.origin, enemy.origin);
				if(distsq > maxrangesqr)
				{
					continue;
				}
				var_b766574c = self.cybercom.var_b766574c;
				var_42d20903 = self.cybercom.var_42d20903;
				if(!targetisvalid(enemy, weapon))
				{
					self.cybercom.var_b766574c = var_b766574c;
					self.cybercom.var_42d20903 = var_42d20903;
					continue;
				}
				var_6f023b72 = 1;
				break;
			}
		}
		else
		{
			var_6f023b72 = 1;
		}
		self clientfield::set_player_uimodel("playerAbilities.inRange", var_6f023b72);
		wait(0.05);
	}
	var_6f023b72 = 0;
	self clientfield::set_player_uimodel("playerAbilities.inRange", var_6f023b72);
}

/*
	Name: function_5ad57748
	Namespace: cybercom
	Checksum: 0x61CAC150
	Offset: 0x4708
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_5ad57748()
{
	self endon(#"death");
	self notify(#"hash_5ad57748");
	self endon(#"hash_5ad57748");
	self endon(#"hash_1bf7ef5");
	var_82361971 = int((getdvarfloat("scr_hacktime_decay_rate", 0.25) / 20) * 1000);
	while(self.var_6c8af4c4 > 0)
	{
		wait(0.05);
		self.var_6c8af4c4 = self.var_6c8af4c4 - var_82361971;
		if(self.var_6c8af4c4 < 0)
		{
			self.var_6c8af4c4 = 0;
		}
	}
}

/*
	Name: function_f5799ee1
	Namespace: cybercom
	Checksum: 0xF4FE5F35
	Offset: 0x47D0
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function function_f5799ee1()
{
	if(!isdefined(self.cybercom.var_4eb8cd67) || self.cybercom.var_4eb8cd67.size == 0)
	{
		return;
	}
	var_4eb8cd67 = [];
	foreach(target in self.cybercom.var_4eb8cd67)
	{
		if(!isdefined(target))
		{
			continue;
		}
		found = 0;
		if(self.cybercom.lock_targets.size)
		{
			foreach(var_9ddde835 in self.cybercom.lock_targets)
			{
				if(!isdefined(var_9ddde835.target))
				{
					continue;
				}
				if(var_9ddde835.target == target)
				{
					found = 1;
					break;
				}
			}
		}
		if(!found)
		{
			target notify(#"ccom_lost_lock", self);
			level notify(#"ccom_lost_lock", target, self);
			self function_18d9de78(target);
			continue;
		}
		var_4eb8cd67[var_4eb8cd67.size] = target;
	}
	self.cybercom.var_4eb8cd67 = var_4eb8cd67;
}

/*
	Name: function_17fea3ed
	Namespace: cybercom
	Checksum: 0xEE5F5D4A
	Offset: 0x49F0
	Size: 0x9A6
	Parameters: 3
	Flags: Linked
*/
function function_17fea3ed(slot, weapon, maxtargets)
{
	self notify(#"ccom_stop_lock_on");
	self endon(#"ccom_stop_lock_on");
	self endon(#"weapon_change");
	self endon(#"disconnect");
	self endon(#"death");
	radius = (isdefined(self.cybercom.var_23d4a73a) ? self.cybercom.var_23d4a73a : 130);
	if(!isdefined(maxtargets))
	{
		maxtargets = 3;
	}
	self thread _lock_fired_watcher(weapon);
	self thread function_f5c296aa(weapon);
	if(maxtargets < 1)
	{
		maxtargets = 1;
	}
	if(maxtargets > 5)
	{
		maxtargets = 5;
	}
	maxrange = 1500;
	if(isdefined(weapon.lockonmaxrange))
	{
		maxrange = weapon.lockonmaxrange;
	}
	validtargets = [];
	dots = [];
	while(self hasweapon(weapon))
	{
		wait(0.05);
		self function_f5799ee1();
		self weapon_lock_clearslots();
		self.cybercom.var_b766574c = 0;
		if(isdefined(self.cybercom.targetlockcb))
		{
			enemies = self [[self.cybercom.targetlockcb]](weapon);
		}
		else
		{
			enemies = arraycombine(getaiteamarray("axis"), getaiteamarray("team3"), 0, 0);
		}
		if(enemies.size == 0)
		{
			self function_29bf9dee(undefined, 1);
		}
		var_ab2554ab = [];
		playerforward = anglestoforward(self getplayerangles());
		var_6f14dd02 = self gettagorigin("tag_aim");
		foreach(enemy in enemies)
		{
			center = enemy getcentroid();
			dirtotarget = vectornormalize(center - var_6f14dd02);
			enemy.var_4ddba9ea = vectordot(dirtotarget, playerforward);
			if(isdefined(enemy.var_fb7ce72a))
			{
				result = enemy [[enemy.var_fb7ce72a]](self, weapon);
				if(isdefined(result) && result)
				{
					var_ab2554ab[var_ab2554ab.size] = enemy;
					continue;
				}
			}
			var_f72b478f = (isdefined(self.cybercom.var_f72b478f) ? self.cybercom.var_f72b478f : 0.83);
			if(enemy.var_4ddba9ea > var_f72b478f)
			{
				var_ab2554ab[var_ab2554ab.size] = enemy;
			}
		}
		if(var_ab2554ab.size == 0)
		{
			self function_29bf9dee(undefined, 1);
			continue;
		}
		validtargets = [];
		potentialtargets = [];
		foreach(enemy in var_ab2554ab)
		{
			if(!isdefined(enemy))
			{
				continue;
			}
			if(!self weapon_lock_meetsrequirement(enemy, radius, weapon, maxrange))
			{
				continue;
			}
			validtargets[validtargets.size] = enemy;
		}
		var_304647c9 = dots.size;
		dots = [];
		foreach(target in validtargets)
		{
			newitem = spawnstruct();
			newitem.dot = target.var_4ddba9ea;
			newitem.target = target;
			array::insertion_sort(dots, &targetinsertionsortcompare, newitem);
		}
		if(dots.size)
		{
			i = 0;
			foreach(item in dots)
			{
				i++;
				if(i > maxtargets)
				{
					break;
				}
				if(isdefined(item.target))
				{
					if(isdefined(item.target.var_ced13b2f) && item.target.var_ced13b2f && self weapon_lock_alreadylocked(item.target) == -1)
					{
						foreach(other in self.cybercom.var_4eb8cd67)
						{
							if(other == item.target)
							{
								continue;
							}
							if(isdefined(other.var_ced13b2f) && other.var_ced13b2f)
							{
								item.target = undefined;
								break;
							}
						}
					}
					if(!isdefined(item.target))
					{
						continue;
					}
					if(self weapon_lock_alreadylocked(item.target) != -1)
					{
						continue;
					}
					slot = self weapon_lock_getslot(item.target);
					if(slot == -1)
					{
						continue;
					}
					if(!isinarray(self.cybercom.var_4eb8cd67, item.target))
					{
						self.cybercom.var_4eb8cd67[self.cybercom.var_4eb8cd67.size] = item.target;
					}
					self weapon_lock_settargettoslot(slot, item.target, maxrange, weapon);
				}
			}
			self playrumbleonentity("damage_light");
		}
	}
	self notify(#"ccom_stop_lock_on");
}

/*
	Name: draworiginforever
	Namespace: cybercom
	Checksum: 0x5441E03A
	Offset: 0x53A0
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function draworiginforever()
{
	/#
		self endon(#"death");
		for(;;)
		{
			debug_arrow(self.origin, self.angles);
			wait(0.05);
		}
	#/
}

/*
	Name: debug_arrow
	Namespace: cybercom
	Checksum: 0xAECE29D4
	Offset: 0x53E8
	Size: 0x2BC
	Parameters: 3
	Flags: Linked
*/
function debug_arrow(org, ang, opcolor)
{
	/#
		forward = anglestoforward(ang);
		forwardfar = vectorscale(forward, 50);
		forwardclose = vectorscale(forward, 50 * 0.8);
		right = anglestoright(ang);
		leftdraw = vectorscale(right, 50 * -0.2);
		rightdraw = vectorscale(right, 50 * 0.2);
		up = anglestoup(ang);
		right = vectorscale(right, 50);
		up = vectorscale(up, 50);
		red = (0.9, 0.2, 0.2);
		green = (0.2, 0.9, 0.2);
		blue = (0.2, 0.2, 0.9);
		if(isdefined(opcolor))
		{
			red = opcolor;
			green = opcolor;
			blue = opcolor;
		}
		line(org, org + forwardfar, red, 0.9);
		line(org + forwardfar, (org + forwardclose) + rightdraw, red, 0.9);
		line(org + forwardfar, (org + forwardclose) + leftdraw, red, 0.9);
		line(org, org + right, blue, 0.9);
		line(org, org + up, green, 0.9);
	#/
}

/*
	Name: debug_circle
	Namespace: cybercom
	Checksum: 0xBDA5FF5
	Offset: 0x56B0
	Size: 0xA4
	Parameters: 4
	Flags: Linked
*/
function debug_circle(origin, radius, seconds, color)
{
	/#
		if(!isdefined(seconds))
		{
			seconds = 1;
		}
		if(!isdefined(color))
		{
			color = (1, 0, 0);
		}
		frames = int(20 * seconds);
		circle(origin, radius, color, 0, 1, frames);
	#/
}

/*
	Name: getclosestto
	Namespace: cybercom
	Checksum: 0xE137CF18
	Offset: 0x5760
	Size: 0x74
	Parameters: 3
	Flags: Linked
*/
function getclosestto(origin, entarray, max)
{
	if(!isdefined(entarray))
	{
		return;
	}
	if(entarray.size == 0)
	{
		return;
	}
	arraysortclosest(entarray, origin, 1, 0, (isdefined(max) ? max : 2048));
	return entarray[0];
}

/*
	Name: cybercom_aioptoutgetflag
	Namespace: cybercom
	Checksum: 0x689E4A2C
	Offset: 0x57E0
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function cybercom_aioptoutgetflag(name)
{
	ability = cybercom_gadget::getabilitybyname(name);
	if(isdefined(ability))
	{
		shift = 8 * ability.type;
		return ability.flag << shift;
	}
	if(isdefined(level._cybercom_rig_ability[name]))
	{
		return 1 << (24 + level._cybercom_rig_ability[name].type);
	}
}

/*
	Name: function_58c312f2
	Namespace: cybercom
	Checksum: 0xDBC7E41
	Offset: 0x58A0
	Size: 0x106
	Parameters: 0
	Flags: None
*/
function function_58c312f2()
{
	if(!isdefined(self))
	{
		return;
	}
	self cybercom_initentityfields();
	foreach(ability in level.cybercom.abilities)
	{
		if(!isdefined(ability))
		{
			continue;
		}
		flag = cybercom_aioptoutgetflag(ability.name);
		if(isdefined(flag))
		{
			self.cybercom.optoutflags = self.cybercom.optoutflags | flag;
		}
	}
}

/*
	Name: cybercom_aioptout
	Namespace: cybercom
	Checksum: 0xA21D9079
	Offset: 0x59B0
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function cybercom_aioptout(name)
{
	if(!isdefined(self))
	{
		return;
	}
	flag = cybercom_aioptoutgetflag(name);
	if(!isdefined(flag))
	{
		return;
	}
	self cybercom_initentityfields();
	self.cybercom.optoutflags = self.cybercom.optoutflags | flag;
}

/*
	Name: cybercom_aiclearoptout
	Namespace: cybercom
	Checksum: 0x2060018B
	Offset: 0x5A38
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function cybercom_aiclearoptout(name)
{
	if(!isdefined(self))
	{
		return;
	}
	self cybercom_initentityfields();
	flag = cybercom_aioptoutgetflag(name);
	if(!isdefined(flag))
	{
		return;
	}
	self.cybercom.optoutflags = self.cybercom.optoutflags & (~flag);
}

/*
	Name: cybercom_aicheckoptout
	Namespace: cybercom
	Checksum: 0xA112F33
	Offset: 0x5AC8
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function cybercom_aicheckoptout(name)
{
	if(!isdefined(self))
	{
		return false;
	}
	if(isdefined(self.nocybercom) && self.nocybercom)
	{
		return true;
	}
	self cybercom_initentityfields();
	flag = cybercom_aioptoutgetflag(name);
	if(!isdefined(flag))
	{
		return false;
	}
	if(self.cybercom.optoutflags & flag)
	{
		return true;
	}
	return false;
}

/*
	Name: cybercom_initentityfields
	Namespace: cybercom
	Checksum: 0xD2BFAEAC
	Offset: 0x5B70
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function cybercom_initentityfields()
{
	if(!isdefined(self.cybercom))
	{
		self.cybercom = spawnstruct();
	}
	if(!isdefined(self.cybercom.optoutflags))
	{
		self.cybercom.optoutflags = 0;
	}
}

/*
	Name: notifymeonmatchend
	Namespace: cybercom
	Checksum: 0x179C50D2
	Offset: 0x5BD0
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function notifymeonmatchend(note, animname)
{
	self endon(note);
	self endon(#"death");
	self waittillmatch(animname);
	self notify(note, "end");
}

/*
	Name: stopanimscriptedonnotify
	Namespace: cybercom
	Checksum: 0x4E962AAC
	Offset: 0x5C20
	Size: 0x164
	Parameters: 5
	Flags: Linked
*/
function stopanimscriptedonnotify(note, animname, kill = 0, attacker, weapon)
{
	self notify(("stopOnNotify" + note) + animname);
	self endon(("stopOnNotify" + note) + animname);
	if(isdefined(animname))
	{
		self thread notifymeonmatchend(("stopOnNotify" + note) + animname, animname);
	}
	self util::waittill_any_return(note, "death");
	if(isdefined(self) && self isinscriptedstate())
	{
		self stopanimscripted(0.3);
	}
	if(isalive(self) && (isdefined(kill) && kill))
	{
		self kill(self.origin, (isdefined(attacker) ? attacker : undefined), undefined, weapon);
	}
}

/*
	Name: function_421746e0
	Namespace: cybercom
	Checksum: 0x8221DF29
	Offset: 0x5D90
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function function_421746e0()
{
	if(isdefined(self.allowdeath))
	{
		if(self.allowdeath == 0)
		{
			return false;
		}
	}
	if(isdefined(self.var_770a8906) && self.var_770a8906)
	{
		return true;
	}
	if(isdefined(self.rider_info))
	{
		return true;
	}
	if(isdefined(self.archetype) && self.archetype == "robot" && !function_76e3026d(self))
	{
		return true;
	}
	if(isactor(self) && !self isonground())
	{
		return true;
	}
	return false;
}

/*
	Name: islinked
	Namespace: cybercom
	Checksum: 0x154C4168
	Offset: 0x5E68
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function islinked()
{
	return isdefined(self getlinkedent());
}

/*
	Name: function_8257bcb3
	Namespace: cybercom
	Checksum: 0x10157C9F
	Offset: 0x5E90
	Size: 0xF0
	Parameters: 2
	Flags: Linked
*/
function function_8257bcb3(context, max = 2)
{
	if(!isdefined(self.cybercom.variants))
	{
		self.cybercom.variants = [];
	}
	if(isdefined(self.cybercom.variants[context]))
	{
		self.cybercom.variants[context] = undefined;
	}
	self.cybercom.variants[context] = spawnstruct();
	self.cybercom.variants[context].var_9689b47c = 0;
	self.cybercom.variants[context].var_51b4aeb8 = max;
}

/*
	Name: getanimationvariant
	Namespace: cybercom
	Checksum: 0x87E89E14
	Offset: 0x5F88
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function getanimationvariant(context)
{
	if(!isdefined(self.cybercom) || !isdefined(self.cybercom.variants) || !isdefined(self.cybercom.variants[context]))
	{
		return "";
	}
	cur = self.cybercom.variants[context].var_9689b47c;
	self.cybercom.variants[context].var_9689b47c++;
	if(self.cybercom.variants[context].var_9689b47c > self.cybercom.variants[context].var_51b4aeb8)
	{
		self.cybercom.variants[context].var_9689b47c = 0;
	}
	if(cur == 0)
	{
		return "";
	}
	return "_" + cur;
}

/*
	Name: debug_box
	Namespace: cybercom
	Checksum: 0xF70E5F51
	Offset: 0x60C8
	Size: 0xA4
	Parameters: 6
	Flags: None
*/
function debug_box(origin, mins, maxs, yaw = 0, frames = 20, color = (1, 0, 0))
{
	/#
		box(origin, mins, maxs, yaw, color, 1, 0, frames);
	#/
}

/*
	Name: debug_sphere
	Namespace: cybercom
	Checksum: 0xF77BD5EE
	Offset: 0x6178
	Size: 0xE4
	Parameters: 5
	Flags: Linked
*/
function debug_sphere(origin, radius, color = (1, 0, 0), alpha = 0.1, timeframes = 1)
{
	/#
		sides = int(10 * (1 + (int(radius) % 100)));
		sphere(origin, radius, color, alpha, 1, sides, timeframes);
	#/
}

/*
	Name: notifymeinnsec
	Namespace: cybercom
	Checksum: 0xD840CE16
	Offset: 0x6268
	Size: 0x36
	Parameters: 2
	Flags: None
*/
function notifymeinnsec(note, seconds)
{
	self endon(note);
	self endon(#"death");
	wait(seconds);
	self notify(note);
}

/*
	Name: notifymeonnote
	Namespace: cybercom
	Checksum: 0xFBCD0FC8
	Offset: 0x62A8
	Size: 0x3A
	Parameters: 2
	Flags: None
*/
function notifymeonnote(note, waitnote)
{
	self endon(note);
	self endon(#"death");
	self waittill(waitnote);
	self notify(note);
}

/*
	Name: deleteentonnote
	Namespace: cybercom
	Checksum: 0xE2091ED3
	Offset: 0x62F0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function deleteentonnote(note, ent)
{
	ent endon(#"death");
	self waittill(note);
	if(isdefined(ent))
	{
		ent delete();
	}
}

/*
	Name: cybercom_armpulse
	Namespace: cybercom
	Checksum: 0x382F8377
	Offset: 0x6348
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function cybercom_armpulse(e_pulse_type)
{
	clientfield::increment("cyber_arm_pulse", e_pulse_type);
}

/*
	Name: function_78525729
	Namespace: cybercom
	Checksum: 0x99770FB6
	Offset: 0x6380
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function function_78525729()
{
	/#
		assert(isactor(self), "");
	#/
	return blackboard::getblackboardattribute(self, "_stance");
}

/*
	Name: function_5e3d3aa
	Namespace: cybercom
	Checksum: 0xF4EEEFAE
	Offset: 0x63E0
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function function_5e3d3aa()
{
	/#
		assert(isactor(self), "");
	#/
	stance = self function_78525729();
	if(stance == "stand")
	{
		return "stn";
	}
	if(stance == "crouch")
	{
		return "crc";
	}
	return "";
}

/*
	Name: debugmsg
	Namespace: cybercom
	Checksum: 0xD5D761FD
	Offset: 0x6478
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function debugmsg(txt)
{
	/#
		println("" + txt);
	#/
}

/*
	Name: function_76e3026d
	Namespace: cybercom
	Checksum: 0x7C69E97B
	Offset: 0x64B8
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_76e3026d(entity)
{
	if(isdefined(entity.missinglegs) && entity.missinglegs)
	{
		return false;
	}
	if(isdefined(entity.iscrawler) && entity.iscrawler)
	{
		return false;
	}
	return true;
}

/*
	Name: function_c3c6aff4
	Namespace: cybercom
	Checksum: 0x45ED2F18
	Offset: 0x6550
	Size: 0x5C
	Parameters: 4
	Flags: Linked
*/
function function_c3c6aff4(slot, weapon, var_ecc9d566, endnote)
{
	self endon(#"death");
	self endon(endnote);
	self waittill(var_ecc9d566);
	self gadgetdeactivate(slot, weapon);
}

/*
	Name: function_adc40f11
	Namespace: cybercom
	Checksum: 0x9A705051
	Offset: 0x65B8
	Size: 0xC6
	Parameters: 2
	Flags: Linked
*/
function function_adc40f11(weapon, fired)
{
	if(fired)
	{
		self notify(weapon.name + "_fired");
		level notify(weapon.name + "_fired");
		self notify(#"hash_81c0052c", weapon);
		bb::logcybercomevent(self, "fired", weapon);
		self gadgettargetresult(1);
	}
	else
	{
		self gadgettargetresult(0);
		self notify(#"hash_2bc5d416", weapon);
	}
}

/*
	Name: function_a3e55896
	Namespace: cybercom
	Checksum: 0x75A0197C
	Offset: 0x6688
	Size: 0x270
	Parameters: 1
	Flags: Linked
*/
function function_a3e55896(weapon)
{
	if(self.cybercom.var_b766574c != 0 && (self.cybercom.lock_targets.size == 0 || self.cybercom.var_b766574c == 8))
	{
		if(self.cybercom.var_b766574c == 2 && isdefined(self.cybercom.var_42d20903))
		{
			var_edc325e = self _lock_sighttest(self.cybercom.var_42d20903, 0);
			if(var_edc325e == 0)
			{
				self.cybercom.var_b766574c = 1;
			}
		}
		switch(self.cybercom.var_b766574c)
		{
			case 2:
			{
				self settargetwrongtypehint(weapon);
				break;
			}
			case 3:
			{
				self settargetoorhint(weapon);
				break;
			}
			case 4:
			{
				self settargetalreadyinusehint(weapon);
				break;
			}
			case 1:
			{
				self setnotargetshint(weapon);
				break;
			}
			case 5:
			{
				self setnolosontargetshint(weapon);
				break;
			}
			case 6:
			{
				self setdisabledtargethint(weapon);
				break;
			}
			case 7:
			{
				self settargetalreadytargetedhint(weapon);
				break;
			}
			case 8:
			{
				self settargetingabortedhint(weapon);
				break;
			}
		}
		level notify(#"hash_dce473f9", self, self.cybercom.var_b766574c);
		self notify(#"hash_dce473f9", self.cybercom.var_b766574c);
		self.cybercom.var_b766574c = 0;
	}
}

/*
	Name: function_29bf9dee
	Namespace: cybercom
	Checksum: 0xAD17D725
	Offset: 0x6900
	Size: 0x148
	Parameters: 4
	Flags: Linked
*/
function function_29bf9dee(var_42d20903, var_b766574c, var_10853dc3 = 1, priority = 1)
{
	if(!isplayer(self) || !isdefined(self.cybercom))
	{
		return;
	}
	if(var_10853dc3 && (!(isdefined(self.cybercom.is_primed) && self.cybercom.is_primed)))
	{
		return;
	}
	if(!(isdefined(self.cybercom.var_8967863e) && self.cybercom.var_8967863e))
	{
		return;
	}
	if(priority)
	{
		if(var_b766574c > self.cybercom.var_b766574c)
		{
			self.cybercom.var_b766574c = var_b766574c;
			self.cybercom.var_42d20903 = var_42d20903;
		}
	}
	else
	{
		self.cybercom.var_b766574c = var_b766574c;
		self.cybercom.var_42d20903 = var_42d20903;
	}
}

/*
	Name: getyawtospot
	Namespace: cybercom
	Checksum: 0x81828564
	Offset: 0x6A50
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function getyawtospot(spot)
{
	pos = spot;
	yaw = self.angles[1] - getyaw(pos);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: getyaw
	Namespace: cybercom
	Checksum: 0x9BF0CA
	Offset: 0x6AD0
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function getyaw(org)
{
	angles = vectortoangles(org - self.origin);
	return angles[1];
}

/*
	Name: function_5ad6b98d
	Namespace: cybercom
	Checksum: 0xB46EB2C0
	Offset: 0x6B20
	Size: 0x196
	Parameters: 3
	Flags: Linked
*/
function function_5ad6b98d(eattacker, eplayer, idamage)
{
	if(!isplayer(eplayer) || !isdefined(eattacker) || !isdefined(eattacker.aitype))
	{
		return idamage;
	}
	if(!isdefined(eplayer.cybercom.var_5e76d31b) || !eplayer.cybercom.var_5e76d31b)
	{
		return idamage;
	}
	var_31dd08f5 = level.var_e4e6dd84[eattacker.aitype];
	if(!isdefined(var_31dd08f5))
	{
		var_31dd08f5 = level.var_e4e6dd84["default"];
	}
	damage_scale = 1;
	distancetoplayer = distance(eattacker.origin, eplayer.origin);
	if(distancetoplayer < 750)
	{
		damage_scale = var_31dd08f5.var_974cd16f;
	}
	else
	{
		if(distancetoplayer < 1500)
		{
			damage_scale = var_31dd08f5.var_e909f6f0;
		}
		else
		{
			damage_scale = var_31dd08f5.var_3d1b9c0c;
		}
	}
	return idamage * damage_scale;
}

/*
	Name: function_1be27df7
	Namespace: cybercom
	Checksum: 0xA4FB3533
	Offset: 0x6CC0
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_1be27df7()
{
	if(isdefined(self.currentweapon) && (self.currentweapon == getweapon("gadget_unstoppable_force") || self.currentweapon == getweapon("gadget_unstoppable_force_upgraded")))
	{
		return true;
	}
	return false;
}

