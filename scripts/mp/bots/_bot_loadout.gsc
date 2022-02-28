// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\bots\_bot;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\array_shared;
#using scripts\shared\rank_shared;

#namespace bot_loadout;

/*
	Name: in_whitelist
	Namespace: bot_loadout
	Checksum: 0x4F6F1C28
	Offset: 0x770
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function in_whitelist(itemname)
{
	if(!isdefined(itemname))
	{
		return false;
	}
	switch(itemname)
	{
		case "KILLSTREAK_COUNTER_UAV":
		case "KILLSTREAK_RAPS":
		case "KILLSTREAK_RECON":
		case "KILLSTREAK_SATELLITE":
		case "KILLSTREAK_SENTINEL":
		case "WEAPON_AR_ACCURATE":
		case "WEAPON_AR_CQB":
		case "WEAPON_AR_DAMAGE":
		case "WEAPON_AR_FASTBURST":
		case "WEAPON_AR_LONGBURST":
		case "WEAPON_AR_MARKSMAN":
		case "WEAPON_AR_STANDARD":
		case "WEAPON_BOUNCINGBETTY":
		case "WEAPON_EMPGRENADE":
		case "WEAPON_FLASHBANG":
		case "WEAPON_FRAGGRENADE":
		case "WEAPON_HATCHET":
		case "WEAPON_INCENDIARY_GRENADE":
		case "WEAPON_KNIFE_LOADOUT":
		case "WEAPON_LAUNCHER_LOCKONLY":
		case "WEAPON_LAUNCHER_STANDARD":
		case "WEAPON_LMG_CQB":
		case "WEAPON_LMG_HEAVY":
		case "WEAPON_LMG_LIGHT":
		case "WEAPON_LMG_SLOWFIRE":
		case "WEAPON_PISTOL_BURST":
		case "WEAPON_PISTOL_FULLAUTO":
		case "WEAPON_PISTOL_STANDARD":
		case "WEAPON_PROXIMITY_GRENADE":
		case "WEAPON_SHOTGUN_FULLAUTO":
		case "WEAPON_SHOTGUN_PRECISION":
		case "WEAPON_SHOTGUN_PUMP":
		case "WEAPON_SHOTGUN_SEMIAUTO":
		case "WEAPON_SMG_BURST":
		case "WEAPON_SMG_CAPACITY":
		case "WEAPON_SMG_FASTFIRE":
		case "WEAPON_SMG_LONGRANGE":
		case "WEAPON_SMG_STANDARD":
		case "WEAPON_SMG_VERSATILE":
		case "WEAPON_SNIPER_CHARGESHOT":
		case "WEAPON_SNIPER_FASTBOLT":
		case "WEAPON_SNIPER_FASTSEMI":
		case "WEAPON_SNIPER_POWERBOLT":
		case "WEAPON_STICKY_GRENADE":
		case "WEAPON_STUN_GRENADE":
		case "WEAPON_WILLY_PETE":
		{
			return true;
		}
	}
	return false;
}

/*
	Name: build_classes
	Namespace: bot_loadout
	Checksum: 0x60ECC715
	Offset: 0x920
	Size: 0x34C
	Parameters: 0
	Flags: Linked
*/
function build_classes()
{
	primaryweapons = self get_available_items(undefined, "primary");
	secondaryweapons = self get_available_items(undefined, "secondary");
	lethals = self get_available_items(undefined, "primarygadget");
	tacticals = self get_available_items(undefined, "secondarygadget");
	if(isdefined(level.perksenabled) && level.perksenabled)
	{
		specialties1 = self get_available_items(undefined, "specialty1");
		specialties2 = self get_available_items(undefined, "specialty2");
		specialties3 = self get_available_items(undefined, "specialty3");
	}
	foreach(classname, classvalue in level.classmap)
	{
		if(!issubstr(classname, "custom"))
		{
			continue;
		}
		classindex = int(classname[classname.size - 1]);
		pickeditems = [];
		pick_item(pickeditems, primaryweapons);
		if(randomint(100) < 95)
		{
			pick_item(pickeditems, secondaryweapons);
		}
		otheritems = array(lethals, tacticals, specialties1, specialties2, specialties3);
		otheritems = array::randomize(otheritems);
		for(i = 0; i < otheritems.size; i++)
		{
			pick_item(pickeditems, otheritems[i]);
		}
		for(i = 0; i < pickeditems.size && i < level.maxallocation; i++)
		{
			self botclassadditem(classindex, pickeditems[i]);
		}
	}
}

/*
	Name: pick_item
	Namespace: bot_loadout
	Checksum: 0xC548C3A2
	Offset: 0xC78
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function pick_item(&pickeditems, items)
{
	if(!isdefined(items) || items.size <= 0)
	{
		return;
	}
	pickeditems[pickeditems.size] = array::random(items);
}

/*
	Name: pick_classes
	Namespace: bot_loadout
	Checksum: 0x5E87039B
	Offset: 0xCD0
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function pick_classes()
{
	self.loadoutclasses = [];
	self.launcherclasscount = 0;
	foreach(classname, classvalue in level.classmap)
	{
		if(issubstr(classname, "custom"))
		{
			if(level.disablecac)
			{
				continue;
			}
			classindex = int(classname[classname.size - 1]);
		}
		else
		{
			classindex = level.classtoclassnum[classvalue];
		}
		primary = self getloadoutweapon(classindex, "primary");
		secondary = self getloadoutweapon(classindex, "secondary");
		botclass = spawnstruct();
		botclass.name = classname;
		botclass.index = classindex;
		botclass.value = classvalue;
		botclass.primary = primary;
		botclass.secondary = secondary;
		if(botclass.secondary.isrocketlauncher)
		{
			self.launcherclasscount++;
		}
		self.loadoutclasses[self.loadoutclasses.size] = botclass;
	}
}

/*
	Name: get_current_class
	Namespace: bot_loadout
	Checksum: 0xA67509B0
	Offset: 0xEF8
	Size: 0xBE
	Parameters: 0
	Flags: Linked
*/
function get_current_class()
{
	currvalue = self.pers["class"];
	if(!isdefined(currvalue))
	{
		return undefined;
	}
	foreach(botclass in self.loadoutclasses)
	{
		if(botclass.value == currvalue)
		{
			return botclass;
		}
	}
	return undefined;
}

/*
	Name: pick_hero_gadget
	Namespace: bot_loadout
	Checksum: 0x3FE36144
	Offset: 0xFC0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function pick_hero_gadget()
{
	if(randomint(2) < 1 || !self pick_hero_ability())
	{
		self pick_hero_weapon();
	}
}

/*
	Name: pick_hero_weapon
	Namespace: bot_loadout
	Checksum: 0xFB3F3453
	Offset: 0x1020
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function pick_hero_weapon()
{
	heroweaponref = self getheroweaponname();
	if(isitemrestricted(heroweaponref))
	{
		return false;
	}
	heroweaponname = self get_item_name(heroweaponref);
	self botclassadditem(0, heroweaponname);
	return true;
}

/*
	Name: pick_hero_ability
	Namespace: bot_loadout
	Checksum: 0x717F0A5F
	Offset: 0x10B0
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function pick_hero_ability()
{
	heroabilityref = self getheroabilityname();
	if(isitemrestricted(heroabilityref))
	{
		return false;
	}
	heroabilityname = self get_item_name(heroabilityref);
	self botclassadditem(0, heroabilityname);
	return true;
}

/*
	Name: pick_killstreaks
	Namespace: bot_loadout
	Checksum: 0x45716EA
	Offset: 0x1140
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function pick_killstreaks()
{
	killstreaks = array::randomize(self get_available_items("killstreak"));
	for(i = 0; i < 3 && i < killstreaks.size; i++)
	{
		self botclassadditem(0, killstreaks[i]);
	}
}

/*
	Name: get_available_items
	Namespace: bot_loadout
	Checksum: 0x340BA847
	Offset: 0x11E0
	Size: 0x29A
	Parameters: 2
	Flags: Linked
*/
function get_available_items(filtergroup, filterslot)
{
	items = [];
	for(i = 0; i < 256; i++)
	{
		row = tablelookuprownum(level.statstableid, 0, i);
		if(row < 0)
		{
			continue;
		}
		name = tablelookupcolumnforrow(level.statstableid, row, 3);
		if(name == "" || !in_whitelist(name))
		{
			continue;
		}
		allocation = int(tablelookupcolumnforrow(level.statstableid, row, 12));
		if(allocation < 0)
		{
			continue;
		}
		ref = tablelookupcolumnforrow(level.statstableid, row, 4);
		if(isitemrestricted(ref))
		{
			continue;
		}
		number = int(tablelookupcolumnforrow(level.statstableid, row, 0));
		if(!sessionmodeisprivate() && self isitemlocked(number))
		{
			continue;
		}
		if(isdefined(filtergroup))
		{
			group = tablelookupcolumnforrow(level.statstableid, row, 2);
			if(group != filtergroup)
			{
				continue;
			}
		}
		if(isdefined(filterslot))
		{
			slot = tablelookupcolumnforrow(level.statstableid, row, 13);
			if(slot != filterslot)
			{
				continue;
			}
		}
		items[items.size] = name;
	}
	return items;
}

/*
	Name: get_item_name
	Namespace: bot_loadout
	Checksum: 0xCB15DCC1
	Offset: 0x1488
	Size: 0xEA
	Parameters: 1
	Flags: Linked
*/
function get_item_name(itemreference)
{
	for(i = 0; i < 256; i++)
	{
		row = tablelookuprownum(level.statstableid, 0, i);
		if(row < 0)
		{
			continue;
		}
		reference = tablelookupcolumnforrow(level.statstableid, row, 4);
		if(reference != itemreference)
		{
			continue;
		}
		name = tablelookupcolumnforrow(level.statstableid, row, 3);
		return name;
	}
	return undefined;
}

/*
	Name: init
	Namespace: bot_loadout
	Checksum: 0x4156CB7D
	Offset: 0x1580
	Size: 0xA0
	Parameters: 0
	Flags: None
*/
function init()
{
	level endon(#"game_ended");
	level.bot_banned_killstreaks = array("KILLSTREAK_RCBOMB", "KILLSTREAK_QRDRONE", "KILLSTREAK_REMOTE_MISSILE", "KILLSTREAK_REMOTE_MORTAR", "KILLSTREAK_HELICOPTER_GUNNER");
	for(;;)
	{
		level waittill(#"connected", player);
		if(!player istestclient())
		{
			continue;
		}
		player thread on_bot_connect();
	}
}

/*
	Name: on_bot_connect
	Namespace: bot_loadout
	Checksum: 0xC44BC5DC
	Offset: 0x1628
	Size: 0x2B2
	Parameters: 0
	Flags: Linked
*/
function on_bot_connect()
{
	self endon(#"disconnect");
	if(isdefined(self.pers["bot_loadout"]))
	{
		return;
	}
	wait(0.1);
	if((self getentitynumber() % 2) == 0)
	{
		wait(0.05);
	}
	self bot::set_rank();
	self botsetrandomcharactercustomization();
	if(level.onlinegame && !sessionmodeisprivate())
	{
		self botsetdefaultclass(5, "class_assault");
		self botsetdefaultclass(6, "class_smg");
		self botsetdefaultclass(7, "class_lmg");
		self botsetdefaultclass(8, "class_cqb");
		self botsetdefaultclass(9, "class_sniper");
	}
	else
	{
		self botsetdefaultclass(5, "class_assault");
		self botsetdefaultclass(6, "class_smg");
		self botsetdefaultclass(7, "class_lmg");
		self botsetdefaultclass(8, "class_cqb");
		self botsetdefaultclass(9, "class_sniper");
	}
	max_allocation = 10;
	if(!sessionmodeisprivate())
	{
		for(i = 1; i <= 3; i++)
		{
			if(self isitemlocked(rank::getitemindex("feature_allocation_slot_" + i)))
			{
				max_allocation--;
			}
		}
	}
	self construct_loadout(max_allocation);
	self.pers["bot_loadout"] = 1;
}

/*
	Name: construct_loadout
	Namespace: bot_loadout
	Checksum: 0xFC2ED9C4
	Offset: 0x18E8
	Size: 0x23C
	Parameters: 1
	Flags: Linked
*/
function construct_loadout(allocation_max)
{
	if(!sessionmodeisprivate() && self isitemlocked(rank::getitemindex("feature_cac")))
	{
		return;
	}
	pixbeginevent("bot_construct_loadout");
	item_list = build_item_list();
	construct_class(0, item_list, allocation_max);
	construct_class(1, item_list, allocation_max);
	construct_class(2, item_list, allocation_max);
	construct_class(3, item_list, allocation_max);
	construct_class(4, item_list, allocation_max);
	killstreaks = item_list["killstreak1"];
	if(isdefined(item_list["killstreak2"]))
	{
		killstreaks = arraycombine(killstreaks, item_list["killstreak2"], 1, 0);
	}
	if(isdefined(item_list["killstreak3"]))
	{
		killstreaks = arraycombine(killstreaks, item_list["killstreak3"], 1, 0);
	}
	if(isdefined(killstreaks) && killstreaks.size)
	{
		choose_weapon(0, killstreaks);
		choose_weapon(0, killstreaks);
		choose_weapon(0, killstreaks);
	}
	self.claimed_items = undefined;
	pixendevent();
}

/*
	Name: construct_class
	Namespace: bot_loadout
	Checksum: 0x5D7D2BB3
	Offset: 0x1B30
	Size: 0xF4
	Parameters: 3
	Flags: Linked
*/
function construct_class(constructclass, items, allocation_max)
{
	allocation = 0;
	claimed_count = build_claimed_list(items);
	self.claimed_items = [];
	weapon = choose_weapon(constructclass, items["primary"]);
	claimed_count["primary"]++;
	allocation++;
	weapon = choose_weapon(constructclass, items["secondary"]);
	choose_weapon_option(constructclass, "camo", 1);
}

/*
	Name: make_choice
	Namespace: bot_loadout
	Checksum: 0xA4402C5
	Offset: 0x1C30
	Size: 0x48
	Parameters: 3
	Flags: None
*/
function make_choice(chance, claimed, max_claim)
{
	return claimed < max_claim && randomint(100) < chance;
}

/*
	Name: chose_action
	Namespace: bot_loadout
	Checksum: 0xFD0B675E
	Offset: 0x1C80
	Size: 0x1BA
	Parameters: 8
	Flags: Linked
*/
function chose_action(action1, chance1, action2, chance2, action3, chance3, action4, chance4)
{
	chance1 = int(chance1 / 10);
	chance2 = int(chance2 / 10);
	chance3 = int(chance3 / 10);
	chance4 = int(chance4 / 10);
	actions = [];
	for(i = 0; i < chance1; i++)
	{
		actions[actions.size] = action1;
	}
	for(i = 0; i < chance2; i++)
	{
		actions[actions.size] = action2;
	}
	for(i = 0; i < chance3; i++)
	{
		actions[actions.size] = action3;
	}
	for(i = 0; i < chance4; i++)
	{
		actions[actions.size] = action4;
	}
	return array::random(actions);
}

/*
	Name: item_is_claimed
	Namespace: bot_loadout
	Checksum: 0x71641025
	Offset: 0x1E48
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function item_is_claimed(item)
{
	foreach(claim in self.claimed_items)
	{
		if(claim == item)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: choose_weapon
	Namespace: bot_loadout
	Checksum: 0x6B3A7BB0
	Offset: 0x1EE8
	Size: 0x100
	Parameters: 2
	Flags: Linked
*/
function choose_weapon(weaponclass, items)
{
	if(!isdefined(items) || !items.size)
	{
		return undefined;
	}
	start = randomint(items.size);
	for(i = 0; i < items.size; i++)
	{
		weapon = items[start];
		if(!item_is_claimed(weapon))
		{
			break;
		}
		start = (start + 1) % items.size;
	}
	self.claimed_items[self.claimed_items.size] = weapon;
	self botclassadditem(weaponclass, weapon);
	return weapon;
}

/*
	Name: build_weapon_options_list
	Namespace: bot_loadout
	Checksum: 0x6CE69247
	Offset: 0x1FF0
	Size: 0x156
	Parameters: 1
	Flags: Linked
*/
function build_weapon_options_list(optiontype)
{
	level.botweaponoptionsid[optiontype] = [];
	level.botweaponoptionsprob[optiontype] = [];
	csv_filename = "gamedata/weapons/common/attachmentTable.csv";
	prob = 0;
	for(row = 0; row < 255; row++)
	{
		if(tablelookupcolumnforrow(csv_filename, row, 1) == optiontype)
		{
			index = level.botweaponoptionsid[optiontype].size;
			level.botweaponoptionsid[optiontype][index] = int(tablelookupcolumnforrow(csv_filename, row, 0));
			prob = prob + int(tablelookupcolumnforrow(csv_filename, row, 15));
			level.botweaponoptionsprob[optiontype][index] = prob;
		}
	}
}

/*
	Name: choose_weapon_option
	Namespace: bot_loadout
	Checksum: 0x5EAE2958
	Offset: 0x2150
	Size: 0x1E2
	Parameters: 3
	Flags: Linked
*/
function choose_weapon_option(weaponclass, optiontype, primary)
{
	if(!isdefined(level.botweaponoptionsid))
	{
		level.botweaponoptionsid = [];
		level.botweaponoptionsprob = [];
		build_weapon_options_list("camo");
		build_weapon_options_list("reticle");
	}
	if(!level.onlinegame && !level.systemlink)
	{
		return;
	}
	numoptions = level.botweaponoptionsprob[optiontype].size;
	maxprob = level.botweaponoptionsprob[optiontype][numoptions - 1];
	if(!level.systemlink && self.pers["rank"] < 20)
	{
		maxprob = maxprob + (4 * maxprob) * ((20 - self.pers["rank"]) / 20);
	}
	rnd = randomint(int(maxprob));
	for(i = 0; i < numoptions; i++)
	{
		if(level.botweaponoptionsprob[optiontype][i] > rnd)
		{
			self botclasssetweaponoption(weaponclass, primary, optiontype, level.botweaponoptionsid[optiontype][i]);
			break;
		}
	}
}

/*
	Name: choose_primary_attachments
	Namespace: bot_loadout
	Checksum: 0x3A6DBFDA
	Offset: 0x2340
	Size: 0x3D4
	Parameters: 4
	Flags: None
*/
function choose_primary_attachments(weaponclass, weapon, allocation, allocation_max)
{
	attachments = weapon.supportedattachments;
	remaining = allocation_max - allocation;
	if(!attachments.size || !remaining)
	{
		return 0;
	}
	attachment_action = chose_action("3_attachments", 25, "2_attachments", 35, "1_attachments", 35, "none", 5);
	if(remaining >= 4 && attachment_action == "3_attachments")
	{
		a1 = array::random(attachments);
		self botclassaddattachment(weaponclass, weapon, a1, "primaryattachment1");
		count = 1;
		attachments = getweaponattachments(weapon, a1);
		if(attachments.size)
		{
			a2 = array::random(attachments);
			self botclassaddattachment(weaponclass, weapon, a2, "primaryattachment2");
			count++;
			attachments = getweaponattachments(weapon, a1, a2);
			if(attachments.size)
			{
				a3 = array::random(attachments);
				self botclassadditem(weaponclass, "BONUSCARD_PRIMARY_GUNFIGHTER");
				self botclassaddattachment(weaponclass, weapon, a3, "primaryattachment3");
				return 4;
			}
		}
		return count;
	}
	if(remaining >= 2 && attachment_action == "2_attachments")
	{
		a1 = array::random(attachments);
		self botclassaddattachment(weaponclass, weapon, a1, "primaryattachment1");
		attachments = getweaponattachments(weapon, a1);
		if(attachments.size)
		{
			a2 = array::random(attachments);
			self botclassaddattachment(weaponclass, weapon, a2, "primaryattachment2");
			return 2;
		}
		return 1;
	}
	if(remaining >= 1 && attachment_action == "1_attachments")
	{
		a = array::random(attachments);
		self botclassaddattachment(weaponclass, weapon, a, "primaryattachment1");
		return 1;
	}
	return 0;
}

/*
	Name: choose_secondary_attachments
	Namespace: bot_loadout
	Checksum: 0xF3B6655B
	Offset: 0x2720
	Size: 0x24C
	Parameters: 4
	Flags: None
*/
function choose_secondary_attachments(weaponclass, weapon, allocation, allocation_max)
{
	attachments = weapon.supportedattachments;
	remaining = allocation_max - allocation;
	if(!attachments.size || !remaining)
	{
		return 0;
	}
	attachment_action = chose_action("2_attachments", 10, "1_attachments", 40, "none", 50, "none", 0);
	if(remaining >= 3 && attachment_action == "2_attachments")
	{
		a1 = array::random(attachments);
		self botclassaddattachment(weaponclass, weapon, a1, "secondaryattachment1");
		attachments = getweaponattachments(weapon, a1);
		if(attachments.size)
		{
			a2 = array::random(attachments);
			self botclassadditem(weaponclass, "BONUSCARD_SECONDARY_GUNFIGHTER");
			self botclassaddattachment(weaponclass, weapon, a2, "secondaryattachment2");
			return 3;
		}
		return 1;
	}
	if(remaining >= 1 && attachment_action == "1_attachments")
	{
		a = array::random(attachments);
		self botclassaddattachment(weaponclass, weapon, a, "secondaryattachment1");
		return 1;
	}
	return 0;
}

/*
	Name: build_item_list
	Namespace: bot_loadout
	Checksum: 0x88FD08C2
	Offset: 0x2978
	Size: 0x1EA
	Parameters: 0
	Flags: Linked
*/
function build_item_list()
{
	items = [];
	for(i = 0; i < 256; i++)
	{
		row = tablelookuprownum(level.statstableid, 0, i);
		if(row > -1)
		{
			slot = tablelookupcolumnforrow(level.statstableid, row, 13);
			if(slot == "")
			{
				continue;
			}
			number = int(tablelookupcolumnforrow(level.statstableid, row, 0));
			if(!sessionmodeisprivate() && self isitemlocked(number))
			{
				continue;
			}
			allocation = int(tablelookupcolumnforrow(level.statstableid, row, 12));
			if(allocation < 0)
			{
				continue;
			}
			name = tablelookupcolumnforrow(level.statstableid, row, 3);
			if(!isdefined(items[slot]))
			{
				items[slot] = [];
			}
			items[slot][items[slot].size] = name;
		}
	}
	return items;
}

/*
	Name: item_is_banned
	Namespace: bot_loadout
	Checksum: 0xADE4D8EE
	Offset: 0x2B70
	Size: 0x11E
	Parameters: 2
	Flags: None
*/
function item_is_banned(slot, item)
{
	if(item == "WEAPON_KNIFE_BALLISTIC")
	{
		return true;
	}
	if(getdvarint("tu6_enableDLCWeapons") == 0 && item == "WEAPON_PEACEKEEPER")
	{
		return true;
	}
	if(slot != "killstreak1" && slot != "killstreak2" && slot != "killstreak3")
	{
		return false;
	}
	foreach(banned in level.bot_banned_killstreaks)
	{
		if(item == banned)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: build_claimed_list
	Namespace: bot_loadout
	Checksum: 0xBF7B3171
	Offset: 0x2C98
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function build_claimed_list(items)
{
	claimed = [];
	keys = getarraykeys(items);
	foreach(key in keys)
	{
		claimed[key] = 0;
	}
	return claimed;
}

