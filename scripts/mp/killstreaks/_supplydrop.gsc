// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\killstreaks\_ai_tank;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_combat_robot;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreak_weapons;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_supplydrop;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_smokegrenade;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_weapons;

#using_animtree("mp_vehicles");

#namespace supplydrop;

/*
	Name: init
	Namespace: supplydrop
	Checksum: 0x6F79795A
	Offset: 0x1670
	Size: 0x12DC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.cratemodelfriendly = "wpn_t7_care_package_world";
	level.cratemodelenemy = "wpn_t7_care_package_world";
	level.cratemodeltank = "wpn_t7_drop_box";
	level.cratemodelboobytrapped = "wpn_t7_care_package_world";
	level.vtoldrophelicoptervehicleinfo = "vtol_supplydrop_mp";
	level.crateownerusetime = 500;
	level.cratenonownerusetime = getgametypesetting("crateCaptureTime") * 1000;
	level.crate_headicon_offset = vectorscale((0, 0, 1), 15);
	level.supplydropdisarmcrate = &"KILLSTREAK_SUPPLY_DROP_DISARM_HINT";
	level.disarmingcrate = &"KILLSTREAK_SUPPLY_DROP_DISARMING_CRATE";
	level.supplydropcarepackageidleanim = %mp_vehicles::o_drone_supply_care_idle;
	level.supplydropcarepackagedropanim = %mp_vehicles::o_drone_supply_care_drop;
	level.supplydropaitankidleanim = %mp_vehicles::o_drone_supply_agr_idle;
	level.supplydropaitankdropanim = %mp_vehicles::o_drone_supply_agr_drop;
	clientfield::register("helicopter", "supplydrop_care_package_state", 1, 1, "int");
	clientfield::register("helicopter", "supplydrop_ai_tank_state", 1, 1, "int");
	clientfield::register("vehicle", "supplydrop_care_package_state", 1, 1, "int");
	clientfield::register("vehicle", "supplydrop_ai_tank_state", 1, 1, "int");
	clientfield::register("scriptmover", "supplydrop_thrusters_state", 1, 1, "int");
	clientfield::register("scriptmover", "aitank_thrusters_state", 1, 1, "int");
	clientfield::register("toplayer", "marker_state", 1, 2, "int");
	level._supply_drop_smoke_fx = "killstreaks/fx_supply_drop_smoke";
	level._supply_drop_explosion_fx = "explosions/fx_exp_grenade_default";
	killstreaks::register("supply_drop", "supplydrop_marker", "killstreak_supply_drop", "supply_drop_used", &usekillstreaksupplydrop, undefined, 1);
	killstreaks::register_strings("supply_drop", &"KILLSTREAK_EARNED_SUPPLY_DROP", &"KILLSTREAK_AIRSPACE_FULL", &"KILLSTREAK_SUPPLY_DROP_INBOUND", undefined, &"KILLSTREAK_SUPPLY_DROP_HACKED");
	killstreaks::register_dialog("supply_drop", "mpl_killstreak_supply", "supplyDropDialogBundle", "supplyDropPilotDialogBundle", "friendlySupplyDrop", "enemySupplyDrop", "enemySupplyDropMultiple", "friendlySupplyDropHacked", "enemySupplyDropHacked", "requestSupplyDrop", "threatSupplyDrop");
	killstreaks::register_alt_weapon("supply_drop", "mp40_blinged");
	killstreaks::register_alt_weapon("supply_drop", "supplydrop");
	killstreaks::allow_assists("supply_drop", 1);
	killstreaks::devgui_scorestreak_command("supply_drop", "Random", "set scr_supply_drop_gui random; set scr_supply_drop_give 1");
	killstreaks::devgui_scorestreak_command("supply_drop", "Random Ally Crate", "set scr_supply_drop_gui random; set scr_givetestsupplydrop 1");
	killstreaks::devgui_scorestreak_command("supply_drop", "Random Enemy Crate", "set scr_supply_drop_gui random; set scr_givetestsupplydrop 2");
	killstreak_bundles::register_killstreak_bundle("supply_drop_ai_tank");
	killstreak_bundles::register_killstreak_bundle("supply_drop_combat_robot");
	level.cratetypes = [];
	level.categorytypeweight = [];
	registercratetype("supplydrop", "killstreak", "uav", 125, &"KILLSTREAK_RADAR_CRATE", &"PLATFORM_RADAR_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "rcbomb", 105, &"KILLSTREAK_RCBOMB_CRATE", &"PLATFORM_RCBOMB_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "counteruav", 115, &"KILLSTREAK_COUNTERU2_CRATE", &"PLATFORM_COUNTERU2_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "remote_missile", 90, &"KILLSTREAK_REMOTE_MISSILE_CRATE", &"PLATFORM_REMOTE_MISSILE_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "planemortar", 80, &"KILLSTREAK_PLANE_MORTAR_CRATE", &"PLATFORM_PLANE_MORTAR_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "autoturret", 90, &"KILLSTREAK_AUTO_TURRET_CRATE", &"PLATFORM_AUTO_TURRET_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "microwave_turret", 120, &"KILLSTREAK_MICROWAVE_TURRET_CRATE", &"PLATFORM_MICROWAVE_TURRET_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "satellite", 20, &"KILLSTREAK_SATELLITE_CRATE", &"PLATFORM_SATELLITE_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "drone_strike", 75, &"KILLSTREAK_DRONE_STRIKE_CRATE", &"PLATFORM_DRONE_STRIKE_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "helicopter_comlink", 30, &"KILLSTREAK_HELICOPTER_CRATE", &"PLATFORM_HELICOPTER_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "emp", 5, &"KILLSTREAK_EMP_CRATE", &"PLATFORM_EMP_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "raps", 20, &"KILLSTREAK_RAPS_CRATE", &"PLATFORM_RAPS_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "dart", 75, &"KILLSTREAK_DART_CRATE", &"PLATFORM_DART_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "sentinel", 20, &"KILLSTREAK_SENTINEL_CRATE", &"PLATFORM_SENTINEL_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "combat_robot", 5, &"KILLSTREAK_COMBAT_ROBOT_CRATE", &"PLATFORM_COMBAT_ROBOT_GAMBLER", &givecratekillstreak);
	registercratetype("supplydrop", "killstreak", "ai_tank_drop", 25, &"KILLSTREAK_AI_TANK_CRATE", &"PLATFORM_AI_TANK_CRATE_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "uav", 125, &"KILLSTREAK_RADAR_CRATE", &"PLATFORM_RADAR_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "counteruav", 115, &"KILLSTREAK_COUNTERU2_CRATE", &"PLATFORM_COUNTERU2_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "rcbomb", 105, &"KILLSTREAK_RCBOMB_CRATE", &"PLATFORM_RCBOMB_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "remote_missile", 90, &"KILLSTREAK_REMOTE_MISSILE_CRATE", &"PLATFORM_REMOTE_MISSILE_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "planemortar", 80, &"KILLSTREAK_PLANE_MORTAR_CRATE", &"PLATFORM_PLANE_MORTAR_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "autoturret", 90, &"KILLSTREAK_AUTO_TURRET_CRATE", &"PLATFORM_AUTO_TURRET_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "microwave_turret", 120, &"KILLSTREAK_MICROWAVE_TURRET_CRATE", &"PLATFORM_MICROWAVE_TURRET_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "satellite", 20, &"KILLSTREAK_SATELLITE_CRATE", &"PLATFORM_SATELLITE_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "helicopter_comlink", 30, &"KILLSTREAK_HELICOPTER_CRATE", &"PLATFORM_HELICOPTER_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "emp", 5, &"KILLSTREAK_EMP_CRATE", &"PLATFORM_EMP_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "raps", 20, &"KILLSTREAK_RAPS_CRATE", &"PLATFORM_RAPS_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "dart", 75, &"KILLSTREAK_DART_CRATE", &"PLATFORM_DART_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "sentinel", 20, &"KILLSTREAK_SENTINEL_CRATE", &"PLATFORM_SENTINEL_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "combat_robot", 5, &"KILLSTREAK_COMBAT_ROBOT_CRATE", &"PLATFORM_COMBAT_ROBOT_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "ai_tank_drop", 25, &"KILLSTREAK_AI_TANK_CRATE", &"PLATFORM_AI_TANK_CRATE_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_supplydrop", "killstreak", "drone_strike", 75, &"KILLSTREAK_DRONE_STRIKE_CRATE", &"PLATFORM_DRONE_STRIKE_GAMBLER", &givecratekillstreak);
	registercratetype("inventory_ai_tank_drop", "killstreak", "ai_tank_drop", 75, &"KILLSTREAK_AI_TANK_CRATE", undefined, undefined, &ai_tank::crateland);
	registercratetype("ai_tank_drop", "killstreak", "ai_tank_drop", 75, &"KILLSTREAK_AI_TANK_CRATE", undefined, undefined, &ai_tank::crateland);
	registercratetype("gambler", "killstreak", "uav", 95, &"KILLSTREAK_RADAR_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "counteruav", 85, &"KILLSTREAK_COUNTERU2_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "rcbomb", 75, &"KILLSTREAK_RCBOMB_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "microwave_turret", 110, &"KILLSTREAK_MICROWAVE_TURRET_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "remote_missile", 100, &"KILLSTREAK_REMOTE_MISSILE_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "planemortar", 80, &"KILLSTREAK_PLANE_MORTAR_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "autoturret", 100, &"KILLSTREAK_AUTO_TURRET_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "satellite", 30, &"KILLSTREAK_SATELLITE_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "ai_tank_drop", 40, &"KILLSTREAK_AI_TANK_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "helicopter_comlink", 45, &"KILLSTREAK_HELICOPTER_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "emp", 10, &"KILLSTREAK_EMP_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "raps", 35, &"KILLSTREAK_RAPS_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "dart", 75, &"KILLSTREAK_DART_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "sentinel", 35, &"KILLSTREAK_SENTINEL_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "combat_robot", 10, &"KILLSTREAK_COMBAT_ROBOT_CRATE", undefined, &givecratekillstreak);
	registercratetype("gambler", "killstreak", "drone_strike", 75, &"KILLSTREAK_DRONE_STRIKE_CRATE", undefined, &givecratekillstreak);
	level.cratecategoryweights = [];
	level.cratecategorytypeweights = [];
	foreach(categorykey, category in level.cratetypes)
	{
		finalizecratecategory(categorykey);
	}
	/#
		level thread supply_drop_dev_gui();
	#/
}

/*
	Name: finalizecratecategory
	Namespace: supplydrop
	Checksum: 0xF03BDACF
	Offset: 0x2958
	Size: 0x112
	Parameters: 1
	Flags: Linked
*/
function finalizecratecategory(category)
{
	level.cratecategoryweights[category] = 0;
	cratetypekeys = getarraykeys(level.cratetypes[category]);
	for(cratetype = 0; cratetype < cratetypekeys.size; cratetype++)
	{
		typekey = cratetypekeys[cratetype];
		level.cratetypes[category][typekey].previousweight = level.cratecategoryweights[category];
		level.cratecategoryweights[category] = level.cratecategoryweights[category] + level.cratetypes[category][typekey].weight;
		level.cratetypes[category][typekey].weight = level.cratecategoryweights[category];
	}
}

/*
	Name: advancedfinalizecratecategory
	Namespace: supplydrop
	Checksum: 0x9E5D4A55
	Offset: 0x2A78
	Size: 0x104
	Parameters: 1
	Flags: None
*/
function advancedfinalizecratecategory(category)
{
	level.cratecategorytypeweights[category] = 0;
	cratetypekeys = getarraykeys(level.categorytypeweight[category]);
	for(cratetype = 0; cratetype < cratetypekeys.size; cratetype++)
	{
		typekey = cratetypekeys[cratetype];
		level.cratecategorytypeweights[category] = level.cratecategorytypeweights[category] + level.categorytypeweight[category][typekey].weight;
		level.categorytypeweight[category][typekey].weight = level.cratecategorytypeweights[category];
	}
	finalizecratecategory(category);
}

/*
	Name: setcategorytypeweight
	Namespace: supplydrop
	Checksum: 0x1E1ADEE1
	Offset: 0x2B88
	Size: 0x27C
	Parameters: 3
	Flags: None
*/
function setcategorytypeweight(category, type, weight)
{
	if(!isdefined(level.categorytypeweight[category]))
	{
		level.categorytypeweight[category] = [];
	}
	level.categorytypeweight[category][type] = spawnstruct();
	level.categorytypeweight[category][type].weight = weight;
	count = 0;
	totalweight = 0;
	startindex = undefined;
	finalindex = undefined;
	cratenamekeys = getarraykeys(level.cratetypes[category]);
	for(cratename = 0; cratename < cratenamekeys.size; cratename++)
	{
		namekey = cratenamekeys[cratename];
		if(level.cratetypes[category][namekey].type == type)
		{
			count++;
			totalweight = totalweight + level.cratetypes[category][namekey].weight;
			if(!isdefined(startindex))
			{
				startindex = cratename;
			}
			if(isdefined(finalindex) && (finalindex + 1) != cratename)
			{
				/#
					util::error("");
				#/
				callback::abort_level();
				return;
			}
			finalindex = cratename;
		}
	}
	level.categorytypeweight[category][type].totalcrateweight = totalweight;
	level.categorytypeweight[category][type].cratecount = count;
	level.categorytypeweight[category][type].startindex = startindex;
	level.categorytypeweight[category][type].finalindex = finalindex;
}

/*
	Name: registercratetype
	Namespace: supplydrop
	Checksum: 0x8B4BB121
	Offset: 0x2E10
	Size: 0x204
	Parameters: 8
	Flags: Linked
*/
function registercratetype(category, type, name, weight, hint, hint_gambler, givefunction, landfunctionoverride)
{
	/#
	#/
	itemname = level.killstreaks[name].menuname;
	if(isitemrestricted(itemname))
	{
		return;
	}
	if(!isdefined(level.cratetypes[category]))
	{
		level.cratetypes[category] = [];
	}
	cratetype = spawnstruct();
	cratetype.type = type;
	cratetype.name = name;
	cratetype.weight = weight;
	cratetype.hint = hint;
	cratetype.hint_gambler = hint_gambler;
	cratetype.givefunction = givefunction;
	crateweapon = killstreaks::get_killstreak_weapon(name);
	if(isdefined(crateweapon))
	{
		cratetype.objective = getcrateheadobjective(crateweapon);
	}
	if(isdefined(landfunctionoverride))
	{
		cratetype.landfunctionoverride = landfunctionoverride;
	}
	level.cratetypes[category][name] = cratetype;
	game["strings"][name + "_hint"] = hint;
	/#
		level thread add_devgui_command(category, name);
	#/
}

/*
	Name: add_devgui_command
	Namespace: supplydrop
	Checksum: 0x32EEE0A1
	Offset: 0x3020
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function add_devgui_command(category, name)
{
	/#
		level endon(#"game_ended");
		wait(0.1);
		wait(randomintrange(2, 10) * 0.05);
		if(category == "" && killstreaks::is_registered(name))
		{
			killstreaks::devgui_scorestreak_command(name, "", ("" + name) + "");
		}
	#/
}

/*
	Name: getrandomcratetype
	Namespace: supplydrop
	Checksum: 0xDF8A6084
	Offset: 0x30D0
	Size: 0x3CE
	Parameters: 2
	Flags: Linked
*/
function getrandomcratetype(category, gambler_crate_name)
{
	if(!isdefined(level.cratetypes) || !isdefined(level.cratetypes[category]))
	{
		return;
	}
	/#
		assert(isdefined(level.cratetypes));
	#/
	/#
		assert(isdefined(level.cratetypes[category]));
	#/
	/#
		assert(isdefined(level.cratecategoryweights[category]));
	#/
	typekey = undefined;
	cratetypestart = 0;
	randomweightend = randomintrange(1, level.cratecategoryweights[category] + 1);
	find_another = 0;
	cratenamekeys = getarraykeys(level.cratetypes[category]);
	if(isdefined(level.categorytypeweight[category]))
	{
		randomweightend = randomint(level.cratecategorytypeweights[category]) + 1;
		cratetypekeys = getarraykeys(level.categorytypeweight[category]);
		for(cratetype = 0; cratetype < cratetypekeys.size; cratetype++)
		{
			typekey = cratetypekeys[cratetype];
			if(level.categorytypeweight[category][typekey].weight < randomweightend)
			{
				continue;
			}
			cratetypestart = level.categorytypeweight[category][typekey].startindex;
			randomweightend = randomint(level.categorytypeweight[category][typekey].totalcrateweight) + 1;
			randomweightend = randomweightend + level.cratetypes[category][cratenamekeys[cratetypestart]].previousweight;
			break;
		}
	}
	for(cratetype = cratetypestart; cratetype < cratenamekeys.size; cratetype++)
	{
		typekey = cratenamekeys[cratetype];
		if(level.cratetypes[category][typekey].weight < randomweightend)
		{
			continue;
		}
		if(isdefined(gambler_crate_name) && level.cratetypes[category][typekey].name == gambler_crate_name)
		{
			find_another = 1;
		}
		if(find_another)
		{
			if(cratetype < (cratenamekeys.size - 1))
			{
				cratetype++;
			}
			else if(cratetype > 0)
			{
				cratetype--;
			}
			typekey = cratenamekeys[cratetype];
		}
		break;
	}
	/#
		if(isdefined(level.dev_gui_supply_drop) && level.dev_gui_supply_drop != "" && level.dev_gui_supply_drop != "")
		{
			typekey = level.dev_gui_supply_drop;
		}
	#/
	return level.cratetypes[category][typekey];
}

/*
	Name: givecrateitem
	Namespace: supplydrop
	Checksum: 0x8E8DFC79
	Offset: 0x34A8
	Size: 0xC6
	Parameters: 1
	Flags: Linked
*/
function givecrateitem(crate)
{
	if(!isalive(self) || !isdefined(crate.cratetype))
	{
		return;
	}
	/#
		assert(isdefined(crate.cratetype.givefunction), "" + crate.cratetype.name);
	#/
	return [[crate.cratetype.givefunction]]("inventory_" + crate.cratetype.name);
}

/*
	Name: givecratekillstreakwaiter
	Namespace: supplydrop
	Checksum: 0xEB84B8EA
	Offset: 0x3578
	Size: 0x52
	Parameters: 3
	Flags: None
*/
function givecratekillstreakwaiter(event, removecrate, extraendon)
{
	self endon(#"give_crate_killstreak_done");
	if(isdefined(extraendon))
	{
		self endon(extraendon);
	}
	self waittill(event);
	self notify(#"give_crate_killstreak_done", removecrate);
}

/*
	Name: givecratekillstreak
	Namespace: supplydrop
	Checksum: 0x991A1255
	Offset: 0x35D8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function givecratekillstreak(killstreak)
{
	self killstreaks::give(killstreak);
}

/*
	Name: givespecializedcrateweapon
	Namespace: supplydrop
	Checksum: 0x384D2FF1
	Offset: 0x3608
	Size: 0x1A2
	Parameters: 1
	Flags: Linked
*/
function givespecializedcrateweapon(weapon)
{
	switch(weapon.name)
	{
		case "minigun":
		{
			level thread popups::displayteammessagetoall(&"KILLSTREAK_MINIGUN_INBOUND", self);
			level weapons::add_limited_weapon(weapon, self, 3);
			break;
		}
		case "m32":
		{
			level thread popups::displayteammessagetoall(&"KILLSTREAK_M32_INBOUND", self);
			level weapons::add_limited_weapon(weapon, self, 3);
			break;
		}
		case "m202_flash":
		{
			level thread popups::displayteammessagetoall(&"KILLSTREAK_M202_FLASH_INBOUND", self);
			level weapons::add_limited_weapon(weapon, self, 3);
			break;
		}
		case "m220_tow":
		{
			level thread popups::displayteammessagetoall(&"KILLSTREAK_M220_TOW_INBOUND", self);
			level weapons::add_limited_weapon(weapon, self, 3);
			break;
		}
		case "mp40_blinged":
		{
			level thread popups::displayteammessagetoall(&"KILLSTREAK_MP40_INBOUND", self);
			level weapons::add_limited_weapon(weapon, self, 3);
			break;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: givecrateweapon
	Namespace: supplydrop
	Checksum: 0x323F7BA
	Offset: 0x37B8
	Size: 0x1C8
	Parameters: 1
	Flags: None
*/
function givecrateweapon(weapon_name)
{
	weapon = getweapon(weapon_name);
	if(weapon == level.weaponnone)
	{
		return;
	}
	currentweapon = self getcurrentweapon();
	if(currentweapon == weapon || self hasweapon(weapon))
	{
		self givemaxammo(weapon);
		return true;
	}
	if(currentweapon.issupplydropweapon || isdefined(level.grenade_array[currentweapon]) || isdefined(level.inventory_array[currentweapon]))
	{
		self takeweapon(self.lastdroppableweapon);
		self giveweapon(weapon);
		self switchtoweapon(weapon);
		return true;
	}
	self addweaponstat(weapon, "used", 1);
	givespecializedcrateweapon(weapon);
	self giveweapon(weapon);
	self switchtoweapon(weapon);
	self waittill(#"weapon_change", newweapon);
	self killstreak_weapons::usekillstreakweaponfromcrate(weapon);
	return true;
}

/*
	Name: usesupplydropmarker
	Namespace: supplydrop
	Checksum: 0x88A32571
	Offset: 0x3988
	Size: 0x2CC
	Parameters: 2
	Flags: Linked
*/
function usesupplydropmarker(package_contents_id, context)
{
	player = self;
	self endon(#"disconnect");
	self endon(#"spawned_player");
	supplydropweapon = level.weaponnone;
	currentweapon = self getcurrentweapon();
	prevweapon = currentweapon;
	if(currentweapon.issupplydropweapon)
	{
		supplydropweapon = currentweapon;
	}
	if(supplydropweapon.isgrenadeweapon)
	{
		trigger_event = "grenade_fire";
	}
	else
	{
		trigger_event = "weapon_fired";
	}
	self thread supplydropwatcher(package_contents_id, trigger_event, supplydropweapon, context);
	self.supplygrenadedeathdrop = 0;
	while(true)
	{
		player allowmelee(0);
		notifystring = self util::waittill_any_return("weapon_change", trigger_event, "disconnect", "spawned_player");
		player allowmelee(1);
		if(!isdefined(notifystring) || notifystring != trigger_event)
		{
			cleanup(context, player);
			return false;
		}
		if(isdefined(player.markerposition))
		{
			break;
		}
	}
	self notify(#"trigger_weapon_shutdown");
	if(supplydropweapon == level.weaponnone)
	{
		cleanup(context, player);
		return false;
	}
	if(isdefined(self))
	{
		notifystring = self util::waittill_any_return("weapon_change", "death", "disconnect", "spawned_player");
		self takeweapon(supplydropweapon);
		if(self hasweapon(supplydropweapon) || self getammocount(supplydropweapon))
		{
			cleanup(context, player);
			return false;
		}
	}
	return true;
}

/*
	Name: issupplydropgrenadeallowed
	Namespace: supplydrop
	Checksum: 0xCDF06DF4
	Offset: 0x3C60
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function issupplydropgrenadeallowed(killstreak)
{
	if(!self killstreakrules::iskillstreakallowed(killstreak, self.team))
	{
		self killstreaks::switch_to_last_non_killstreak_weapon();
		return false;
	}
	return true;
}

/*
	Name: adddroplocation
	Namespace: supplydrop
	Checksum: 0x9E7DFBE0
	Offset: 0x3CB8
	Size: 0x26
	Parameters: 2
	Flags: Linked
*/
function adddroplocation(killstreak_id, location)
{
	level.droplocations[killstreak_id] = location;
}

/*
	Name: deldroplocation
	Namespace: supplydrop
	Checksum: 0xC17ED8AB
	Offset: 0x3CE8
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function deldroplocation(killstreak_id)
{
	level.droplocations[killstreak_id] = undefined;
}

/*
	Name: islocationgood
	Namespace: supplydrop
	Checksum: 0x98814C5C
	Offset: 0x3D08
	Size: 0x3F0
	Parameters: 2
	Flags: Linked
*/
function islocationgood(location, context)
{
	foreach(droplocation in level.droplocations)
	{
		if(distance2dsquared(droplocation, location) < 3600)
		{
			return 0;
		}
	}
	if(context.perform_physics_trace === 1)
	{
		mask = 1;
		if(isdefined(context.tracemask))
		{
			mask = context.tracemask;
		}
		radius = context.radius;
		trace = physicstrace(location + vectorscale((0, 0, 1), 5000), location + vectorscale((0, 0, 1), 10), (radius * -1, radius * -1, 0), (radius, radius, 2 * radius), undefined, mask);
		if(trace["fraction"] < 1)
		{
			return 0;
		}
	}
	closestpoint = getclosestpointonnavmesh(location, max(context.max_dist_from_location, 24), context.dist_from_boundary);
	isvalidpoint = isdefined(closestpoint);
	if(isvalidpoint && context.check_same_floor === 1 && (abs(location[2] - closestpoint[2])) > 96)
	{
		isvalidpoint = 0;
	}
	if(isvalidpoint && distance2dsquared(location, closestpoint) > (context.max_dist_from_location * context.max_dist_from_location))
	{
		isvalidpoint = 0;
	}
	/#
		if(getdvarint("", 0))
		{
			if(!isvalidpoint)
			{
				otherclosestpoint = getclosestpointonnavmesh(location, getdvarfloat("", 96), context.dist_from_boundary);
				if(isdefined(otherclosestpoint))
				{
					sphere(otherclosestpoint, context.max_dist_from_location, (1, 0, 0), 0.8, 0, 20, 1);
				}
			}
			else
			{
				sphere(closestpoint, context.max_dist_from_location, (0, 1, 0), 0.8, 0, 20, 1);
				util::drawcylinder(closestpoint, context.radius, 8000, 0.01666667, undefined, vectorscale((0, 1, 0), 0.9), 0.7);
			}
		}
	#/
	return isvalidpoint;
}

/*
	Name: usekillstreaksupplydrop
	Namespace: supplydrop
	Checksum: 0x6F11E84A
	Offset: 0x4100
	Size: 0x1AE
	Parameters: 1
	Flags: Linked
*/
function usekillstreaksupplydrop(killstreak)
{
	player = self;
	if(!player issupplydropgrenadeallowed(killstreak))
	{
		return 0;
	}
	context = spawnstruct();
	context.radius = level.killstreakcorebundle.ksairdropsupplydropradius;
	context.dist_from_boundary = 12;
	context.max_dist_from_location = 4;
	context.perform_physics_trace = 1;
	context.islocationgood = &islocationgood;
	context.objective = &"airdrop_supplydrop";
	context.validlocationsound = level.killstreakcorebundle.ksvalidcarepackagelocationsound;
	context.tracemask = 1 | 4;
	context.droptag = "tag_attach";
	context.droptagoffset = (-32, 0, 23);
	context.killstreaktype = killstreak;
	result = player usesupplydropmarker(undefined, context);
	player notify(#"supply_drop_marker_done");
	if(!isdefined(result) || !result)
	{
		return 0;
	}
	return result;
}

/*
	Name: use_killstreak_death_machine
	Namespace: supplydrop
	Checksum: 0xF9C15CCA
	Offset: 0x42B8
	Size: 0x1D0
	Parameters: 1
	Flags: None
*/
function use_killstreak_death_machine(killstreak)
{
	if(!self killstreakrules::iskillstreakallowed(killstreak, self.team))
	{
		return false;
	}
	weapon = getweapon("minigun");
	currentweapon = self getcurrentweapon();
	if(currentweapon.issupplydropweapon || isdefined(level.grenade_array[currentweapon]) || isdefined(level.inventory_array[currentweapon]))
	{
		self takeweapon(self.lastdroppableweapon);
		self giveweapon(weapon);
		self switchtoweapon(weapon);
		self setblockweaponpickup(weapon, 1);
		return true;
	}
	level thread popups::displayteammessagetoall(&"KILLSTREAK_MINIGUN_INBOUND", self);
	level weapons::add_limited_weapon(weapon, self, 3);
	self takeweapon(currentweapon);
	self giveweapon(weapon);
	self switchtoweapon(weapon);
	self setblockweaponpickup(weapon, 1);
	return true;
}

/*
	Name: use_killstreak_grim_reaper
	Namespace: supplydrop
	Checksum: 0xFE8C92B0
	Offset: 0x4490
	Size: 0x1D0
	Parameters: 1
	Flags: None
*/
function use_killstreak_grim_reaper(killstreak)
{
	if(!self killstreakrules::iskillstreakallowed(killstreak, self.team))
	{
		return false;
	}
	weapon = getweapon("m202_flash");
	currentweapon = self getcurrentweapon();
	if(currentweapon.issupplydropweapon || isdefined(level.grenade_array[currentweapon]) || isdefined(level.inventory_array[currentweapon]))
	{
		self takeweapon(self.lastdroppableweapon);
		self giveweapon(weapon);
		self switchtoweapon(weapon);
		self setblockweaponpickup(weapon, 1);
		return true;
	}
	level thread popups::displayteammessagetoall(&"KILLSTREAK_M202_FLASH_INBOUND", self);
	level weapons::add_limited_weapon(weapon, self, 3);
	self takeweapon(currentweapon);
	self giveweapon(weapon);
	self switchtoweapon(weapon);
	self setblockweaponpickup(weapon, 1);
	return true;
}

/*
	Name: use_killstreak_tv_guided_missile
	Namespace: supplydrop
	Checksum: 0x1443F187
	Offset: 0x4668
	Size: 0x200
	Parameters: 1
	Flags: None
*/
function use_killstreak_tv_guided_missile(killstreak)
{
	if(!killstreakrules::iskillstreakallowed(killstreak, self.team))
	{
		self iprintlnbold(level.killstreaks[killstreak].notavailabletext);
		return false;
	}
	weapon = getweapon("m220_tow");
	currentweapon = self getcurrentweapon();
	if(currentweapon.issupplydropweapon || isdefined(level.grenade_array[currentweapon]) || isdefined(level.inventory_array[currentweapon]))
	{
		self takeweapon(self.lastdroppableweapon);
		self giveweapon(weapon);
		self switchtoweapon(weapon);
		self setblockweaponpickup(weapon, 1);
		return true;
	}
	level thread popups::displayteammessagetoall(&"KILLSTREAK_M220_TOW_INBOUND", self);
	level weapons::add_limited_weapon(weapon, self, 3);
	self takeweapon(currentweapon);
	self giveweapon(weapon);
	self switchtoweapon(weapon);
	self setblockweaponpickup(weapon, 1);
	return true;
}

/*
	Name: use_killstreak_mp40
	Namespace: supplydrop
	Checksum: 0x86EB188C
	Offset: 0x4870
	Size: 0x200
	Parameters: 1
	Flags: None
*/
function use_killstreak_mp40(killstreak)
{
	if(!killstreakrules::iskillstreakallowed(killstreak, self.team))
	{
		self iprintlnbold(level.killstreaks[killstreak].notavailabletext);
		return false;
	}
	weapon = getweapon("mp40_blinged");
	currentweapon = self getcurrentweapon();
	if(currentweapon.issupplydropweapon || isdefined(level.grenade_array[currentweapon]) || isdefined(level.inventory_array[currentweapon]))
	{
		self takeweapon(self.lastdroppableweapon);
		self giveweapon(weapon);
		self switchtoweapon(weapon);
		self setblockweaponpickup(weapon, 1);
		return true;
	}
	level thread popups::displayteammessagetoall(&"KILLSTREAK_MP40_INBOUND", self);
	level weapons::add_limited_weapon(weapon, self, 3);
	self takeweapon(currentweapon);
	self giveweapon(weapon);
	self switchtoweapon(weapon);
	self setblockweaponpickup(weapon, 1);
	return true;
}

/*
	Name: cleanupwatcherondeath
	Namespace: supplydrop
	Checksum: 0x760FFF8A
	Offset: 0x4A78
	Size: 0xBA
	Parameters: 2
	Flags: Linked
*/
function cleanupwatcherondeath(team, killstreak_id)
{
	player = self;
	self endon(#"disconnect");
	self endon(#"supplydropwatcher");
	self endon(#"trigger_weapon_shutdown");
	self endon(#"spawned_player");
	self endon(#"weapon_change");
	self util::waittill_any("death", "joined_team", "joined_spectators");
	killstreakrules::killstreakstop("supply_drop", team, killstreak_id);
	self notify(#"cleanup_marker");
}

/*
	Name: cleanup
	Namespace: supplydrop
	Checksum: 0x8466F01B
	Offset: 0x4B40
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function cleanup(context, player)
{
	if(isdefined(context) && isdefined(context.marker))
	{
		context.marker delete();
		context.marker = undefined;
		if(isdefined(context.markerfxhandle))
		{
			context.markerfxhandle delete();
			context.markerfxhandle = undefined;
		}
		if(isdefined(player))
		{
			player clientfield::set_to_player("marker_state", 0);
		}
		deldroplocation(context.killstreak_id);
	}
}

/*
	Name: markerupdatethread
	Namespace: supplydrop
	Checksum: 0xD069746B
	Offset: 0x4C30
	Size: 0x358
	Parameters: 1
	Flags: Linked
*/
function markerupdatethread(context)
{
	player = self;
	player endon(#"supplydropwatcher");
	player endon(#"spawned_player");
	player endon(#"disconnect");
	player endon(#"weapon_change");
	player endon(#"death");
	markermodel = spawn("script_model", (0, 0, 0));
	context.marker = markermodel;
	player thread markercleanupthread(context);
	while(true)
	{
		if(player flagsys::get("marking_done"))
		{
			break;
		}
		minrange = level.killstreakcorebundle.ksminairdroptargetrange;
		maxrange = level.killstreakcorebundle.ksmaxairdroptargetrange;
		forwardvector = vectorscale(anglestoforward(player getplayerangles()), maxrange);
		mask = 1;
		if(isdefined(context.tracemask))
		{
			mask = context.tracemask;
		}
		radius = 2;
		results = physicstrace(player geteye(), player geteye() + forwardvector, (radius * -1, radius * -1, 0), (radius, radius, 2 * radius), player, mask);
		markermodel.origin = results["position"];
		tooclose = distancesquared(markermodel.origin, player.origin) < (minrange * minrange);
		if(results["normal"][2] > 0.7 && !tooclose && isdefined(context.islocationgood) && [[context.islocationgood]](markermodel.origin, context))
		{
			player.markerposition = markermodel.origin;
			player clientfield::set_to_player("marker_state", 1);
		}
		else
		{
			player.markerposition = undefined;
			player clientfield::set_to_player("marker_state", 2);
		}
		wait(0.05);
	}
}

/*
	Name: supplydropwatcher
	Namespace: supplydrop
	Checksum: 0xE7321242
	Offset: 0x4F90
	Size: 0x424
	Parameters: 4
	Flags: Linked
*/
function supplydropwatcher(package_contents_id, trigger_event, supplydropweapon, context)
{
	player = self;
	self notify(#"supplydropwatcher");
	self endon(#"supplydropwatcher");
	self endon(#"spawned_player");
	self endon(#"disconnect");
	self endon(#"weapon_change");
	team = self.team;
	killstreak_id = killstreakrules::killstreakstart("supply_drop", team, 0, 0);
	if(killstreak_id == -1)
	{
		return;
	}
	context.killstreak_id = killstreak_id;
	player flagsys::clear("marking_done");
	if(!supplydropweapon.isgrenadeweapon)
	{
		self thread markerupdatethread(context);
	}
	self thread checkforemp();
	self thread checkweaponchange(team, killstreak_id);
	self thread cleanupwatcherondeath(team, killstreak_id);
	while(true)
	{
		self waittill(trigger_event, weapon_instance, weapon);
		issupplydropweapon = 1;
		if(trigger_event == "grenade_fire")
		{
			issupplydropweapon = weapon.issupplydropweapon;
		}
		if(isdefined(self) && issupplydropweapon)
		{
			if(isdefined(context))
			{
				if(!isdefined(player.markerposition) || !islocationgood(player.markerposition, context))
				{
					if(isdefined(level.killstreakcorebundle.ksinvalidlocationsound))
					{
						player playsoundtoplayer(level.killstreakcorebundle.ksinvalidlocationsound, player);
					}
					if(isdefined(level.killstreakcorebundle.ksinvalidlocationstring))
					{
						player iprintlnbold(istring(level.killstreakcorebundle.ksinvalidlocationstring));
					}
					continue;
				}
				if(isdefined(context.validlocationsound))
				{
					player playsoundtoplayer(context.validlocationsound, player);
				}
				self thread helidelivercrate(player.markerposition, weapon_instance, self, team, killstreak_id, package_contents_id, context);
			}
			else
			{
				self thread dosupplydrop(weapon_instance, weapon, self, killstreak_id, package_contents_id);
				weapon_instance thread do_supply_drop_detonation(weapon, self);
				weapon_instance thread supplydropgrenadetimeout(team, killstreak_id, weapon);
			}
			self killstreaks::switch_to_last_non_killstreak_weapon();
		}
		else
		{
			killstreakrules::killstreakstop("supply_drop", team, killstreak_id);
			self notify(#"cleanup_marker");
		}
		break;
	}
	player flagsys::set("marking_done");
	player clientfield::set_to_player("marker_state", 0);
}

/*
	Name: checkforemp
	Namespace: supplydrop
	Checksum: 0x758CF3C
	Offset: 0x53C0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function checkforemp()
{
	self endon(#"supplydropwatcher");
	self endon(#"spawned_player");
	self endon(#"disconnect");
	self endon(#"weapon_change");
	self endon(#"death");
	self endon(#"trigger_weapon_shutdown");
	self waittill(#"emp_jammed");
	self killstreaks::switch_to_last_non_killstreak_weapon();
}

/*
	Name: supplydropgrenadetimeout
	Namespace: supplydrop
	Checksum: 0xFE78D1C1
	Offset: 0x5438
	Size: 0x1D4
	Parameters: 3
	Flags: Linked
*/
function supplydropgrenadetimeout(team, killstreak_id, weapon)
{
	self endon(#"death");
	self endon(#"stationary");
	grenade_lifetime = 10;
	wait(grenade_lifetime);
	if(!isdefined(self))
	{
		return;
	}
	self notify(#"grenade_timeout");
	killstreakrules::killstreakstop("supply_drop", team, killstreak_id);
	if(weapon.name == "ai_tank_drop")
	{
		killstreakrules::killstreakstop("ai_tank_drop", team, killstreak_id);
		self notify(#"cleanup_marker");
	}
	else
	{
		if(weapon.name == "inventory_ai_tank_drop")
		{
			killstreakrules::killstreakstop("inventory_ai_tank_drop", team, killstreak_id);
			self notify(#"cleanup_marker");
		}
		else
		{
			if(weapon.name == "combat_robot_drop")
			{
				killstreakrules::killstreakstop("combat_robot_drop", team, killstreak_id);
				self notify(#"cleanup_marker");
			}
			else if(weapon.name == "inventory_combat_robot_drop")
			{
				killstreakrules::killstreakstop("inventory_combat_robot_drop", team, killstreak_id);
				self notify(#"cleanup_marker");
			}
		}
	}
	self delete();
}

/*
	Name: checkweaponchange
	Namespace: supplydrop
	Checksum: 0xD4564F17
	Offset: 0x5618
	Size: 0x8A
	Parameters: 2
	Flags: Linked
*/
function checkweaponchange(team, killstreak_id)
{
	self endon(#"supplydropwatcher");
	self endon(#"spawned_player");
	self endon(#"disconnect");
	self endon(#"trigger_weapon_shutdown");
	self endon(#"death");
	self waittill(#"weapon_change");
	killstreakrules::killstreakstop("supply_drop", team, killstreak_id);
	self notify(#"cleanup_marker");
}

/*
	Name: supplydropgrenadepullwatcher
	Namespace: supplydrop
	Checksum: 0x93B37467
	Offset: 0x56B0
	Size: 0x11C
	Parameters: 1
	Flags: None
*/
function supplydropgrenadepullwatcher(killstreak_id)
{
	self endon(#"disconnect");
	self endon(#"weapon_change");
	self waittill(#"grenade_pullback", weapon);
	self util::_disableusability();
	self thread watchforgrenadeputdown();
	self waittill(#"death");
	killstreak = "supply_drop";
	self.supplygrenadedeathdrop = 1;
	if(weapon.issupplydropweapon)
	{
		killstreak = killstreaks::get_killstreak_for_weapon(weapon);
	}
	if(!(isdefined(self.usingkillstreakfrominventory) && self.usingkillstreakfrominventory))
	{
		self killstreaks::change_killstreak_quantity(weapon, -1);
	}
	else
	{
		killstreaks::remove_used_killstreak(killstreak, killstreak_id);
	}
}

/*
	Name: watchforgrenadeputdown
	Namespace: supplydrop
	Checksum: 0x5919CF2B
	Offset: 0x57D8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function watchforgrenadeputdown()
{
	self notify(#"watchforgrenadeputdown");
	self endon(#"watchforgrenadeputdown");
	self endon(#"death");
	self endon(#"disconnect");
	self util::waittill_any("grenade_fire", "weapon_change");
	self notify(#"trigger_weapon_shutdown");
	self util::_enableusability();
}

/*
	Name: playerchangeweaponwaiter
	Namespace: supplydrop
	Checksum: 0x854CD560
	Offset: 0x5860
	Size: 0x7E
	Parameters: 0
	Flags: None
*/
function playerchangeweaponwaiter()
{
	self endon(#"supply_drop_marker_done");
	self endon(#"disconnect");
	self endon(#"spawned_player");
	currentweapon = self getcurrentweapon();
	while(currentweapon.issupplydropweapon)
	{
		self waittill(#"weapon_change", currentweapon);
	}
	waittillframeend();
	self notify(#"supply_drop_marker_done");
}

/*
	Name: geticonforcrate
	Namespace: supplydrop
	Checksum: 0xD8AC150B
	Offset: 0x58E8
	Size: 0x1C8
	Parameters: 0
	Flags: Linked
*/
function geticonforcrate()
{
	icon = undefined;
	switch(self.cratetype.type)
	{
		case "killstreak":
		{
			if(isdefined(self.cratetype.objective))
			{
				return self.cratetype.objective;
			}
			else
			{
				if(self.cratetype.name == "inventory_ai_tank_drop")
				{
					icon = "t7_hud_ks_drone_amws";
				}
				else
				{
					killstreak = killstreaks::get_menu_name(self.cratetype.name);
					icon = level.killstreakicons[killstreak];
				}
			}
			jump loc_00005A5C;
		}
		case "weapon":
		{
			switch(self.cratetype.name)
			{
				case "minigun":
				{
					icon = "hud_ks_minigun";
					break;
				}
				case "m32":
				{
					icon = "hud_ks_m32";
					break;
				}
				case "m202_flash":
				{
					icon = "hud_ks_m202";
					break;
				}
				case "m220_tow":
				{
					icon = "hud_ks_tv_guided_missile";
					break;
				}
				case "mp40_drop":
				{
					icon = "hud_mp40";
					break;
				}
				default:
				{
					icon = "waypoint_recon_artillery_strike";
					break;
				}
			}
			loc_00005A5C:
			break;
		}
		case "ammo":
		{
			icon = "hud_ammo_refill";
			break;
		}
		default:
		{
			return undefined;
			break;
		}
	}
	return icon + "_drop";
}

/*
	Name: crateactivate
	Namespace: supplydrop
	Checksum: 0x8871838D
	Offset: 0x5AB8
	Size: 0x6E4
	Parameters: 1
	Flags: Linked
*/
function crateactivate(hacker)
{
	self makeusable();
	self setcursorhint("HINT_NOICON");
	if(!isdefined(self.cratetype))
	{
		return;
	}
	self sethintstring(self.cratetype.hint);
	if(isdefined(self.cratetype.hint_gambler))
	{
		self sethintstringforperk("specialty_showenemyequipment", self.cratetype.hint_gambler);
	}
	crateobjid = gameobjects::get_next_obj_id();
	objective_add(crateobjid, "invisible", self.origin);
	objective_icon(crateobjid, "compass_supply_drop_white");
	objective_setcolor(crateobjid, &"FriendlyBlue");
	objective_state(crateobjid, "active");
	self.friendlyobjid = crateobjid;
	self.enemyobjid = [];
	icon = self geticonforcrate();
	if(isdefined(hacker))
	{
		self clientfield::set("enemyequip", 0);
	}
	if(level.teambased)
	{
		objective_team(crateobjid, self.team);
		foreach(team in level.teams)
		{
			if(self.team == team)
			{
				continue;
			}
			crateobjid = gameobjects::get_next_obj_id();
			objective_add(crateobjid, "invisible", self.origin);
			if(isdefined(self.hacker))
			{
				objective_icon(crateobjid, "compass_supply_drop_black");
			}
			else
			{
				objective_icon(crateobjid, "compass_supply_drop_white");
				objective_setcolor(crateobjid, &"EnemyOrange");
			}
			objective_team(crateobjid, team);
			objective_state(crateobjid, "active");
			self.enemyobjid[self.enemyobjid.size] = crateobjid;
		}
	}
	else
	{
		if(!self.visibletoall)
		{
			objective_setinvisibletoall(crateobjid);
			enemycrateobjid = gameobjects::get_next_obj_id();
			objective_add(enemycrateobjid, "invisible", self.origin);
			objective_icon(enemycrateobjid, "compass_supply_drop_white");
			objective_setcolor(enemycrateobjid, &"EnemyOrange");
			objective_state(enemycrateobjid, "active");
			if(isplayer(self.owner))
			{
				objective_setinvisibletoplayer(enemycrateobjid, self.owner);
			}
			self.enemyobjid[self.enemyobjid.size] = enemycrateobjid;
		}
		if(isplayer(self.owner))
		{
			objective_setvisibletoplayer(crateobjid, self.owner);
		}
		if(isdefined(self.hacker))
		{
			objective_setinvisibletoplayer(crateobjid, self.hacker);
			crateobjid = gameobjects::get_next_obj_id();
			objective_add(crateobjid, "invisible", self.origin);
			objective_icon(crateobjid, "compass_supply_drop_black");
			objective_state(crateobjid, "active");
			objective_setinvisibletoall(crateobjid);
			objective_setvisibletoplayer(crateobjid, self.hacker);
			self.hackerobjid = crateobjid;
		}
	}
	if(!self.visibletoall && isdefined(icon))
	{
		self entityheadicons::setentityheadicon(self.team, self, level.crate_headicon_offset, icon, 1);
		if(self.entityheadobjectives.size > 0)
		{
			objectiveid = self.entityheadobjectives[self.entityheadobjectives.size - 1];
			if(isdefined(objectiveid))
			{
				objective_setinvisibletoall(objectiveid);
				objective_setvisibletoplayer(objectiveid, self.owner);
			}
		}
	}
	if(isdefined(self.owner) && isplayer(self.owner) && self.owner util::is_bot())
	{
		self.owner notify(#"bot_crate_landed", self);
	}
	if(isdefined(self.owner))
	{
		self.owner notify(#"crate_landed", self);
		setricochetprotectionendtime("supply_drop", self.killstreak_id, self.owner);
	}
}

/*
	Name: setricochetprotectionendtime
	Namespace: supplydrop
	Checksum: 0xF5820818
	Offset: 0x61A8
	Size: 0xAC
	Parameters: 3
	Flags: Linked
*/
function setricochetprotectionendtime(killstreak, killstreak_id, owner)
{
	ksbundle = level.killstreakbundle[killstreak];
	if(isdefined(ksbundle) && isdefined(ksbundle.ksricochetpostlandduration) && ksbundle.ksricochetpostlandduration > 0)
	{
		endtime = gettime() + (ksbundle.ksricochetpostlandduration * 1000);
		killstreaks::set_ricochet_protection_endtime(killstreak_id, owner, endtime);
	}
}

/*
	Name: cratedeactivate
	Namespace: supplydrop
	Checksum: 0x79326374
	Offset: 0x6260
	Size: 0x166
	Parameters: 0
	Flags: Linked
*/
function cratedeactivate()
{
	self makeunusable();
	if(isdefined(self.friendlyobjid))
	{
		objective_delete(self.friendlyobjid);
		gameobjects::release_obj_id(self.friendlyobjid);
		self.friendlyobjid = undefined;
	}
	if(isdefined(self.enemyobjid))
	{
		foreach(objid in self.enemyobjid)
		{
			objective_delete(objid);
			gameobjects::release_obj_id(objid);
		}
		self.enemyobjid = [];
	}
	if(isdefined(self.hackerobjid))
	{
		objective_delete(self.hackerobjid);
		gameobjects::release_obj_id(self.hackerobjid);
		self.hackerobjid = undefined;
	}
}

/*
	Name: ownerteamchangewatcher
	Namespace: supplydrop
	Checksum: 0xAAE377AF
	Offset: 0x63D0
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function ownerteamchangewatcher()
{
	self notify(#"ownerteamchangewatcher_singleton");
	self endon(#"ownerteamchangewatcher_singleton");
	self endon(#"death");
	if(!level.teambased || !isdefined(self.owner))
	{
		return;
	}
	self.owner waittill(#"joined_team");
	self.owner = undefined;
}

/*
	Name: dropalltoground
	Namespace: supplydrop
	Checksum: 0x85F3E630
	Offset: 0x6440
	Size: 0x8A
	Parameters: 3
	Flags: Linked
*/
function dropalltoground(origin, radius, stickyobjectradius)
{
	physicsexplosionsphere(origin, radius, radius, 0);
	wait(0.05);
	weapons::drop_all_to_ground(origin, radius);
	dropcratestoground(origin, radius);
	level notify(#"drop_objects_to_ground", origin, stickyobjectradius);
}

/*
	Name: dropeverythingtouchingcrate
	Namespace: supplydrop
	Checksum: 0x6935091F
	Offset: 0x64D8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function dropeverythingtouchingcrate(origin)
{
	dropalltoground(origin, 70, 70);
}

/*
	Name: dropalltogroundaftercratedelete
	Namespace: supplydrop
	Checksum: 0x87D980B4
	Offset: 0x6510
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function dropalltogroundaftercratedelete(crate, crate_origin)
{
	crate waittill(#"death");
	wait(0.1);
	crate dropeverythingtouchingcrate(crate_origin);
}

/*
	Name: dropcratestoground
	Namespace: supplydrop
	Checksum: 0x3C9EC5E7
	Offset: 0x6560
	Size: 0xD6
	Parameters: 2
	Flags: Linked
*/
function dropcratestoground(origin, radius)
{
	crate_ents = getentarray("care_package", "script_noteworthy");
	radius_sq = radius * radius;
	for(i = 0; i < crate_ents.size; i++)
	{
		if(distancesquared(origin, crate_ents[i].origin) < radius_sq)
		{
			crate_ents[i] thread dropcratetoground();
		}
	}
}

/*
	Name: dropcratetoground
	Namespace: supplydrop
	Checksum: 0x811C8674
	Offset: 0x6640
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function dropcratetoground()
{
	self endon(#"death");
	if(isdefined(self.droppingtoground))
	{
		return;
	}
	self.droppingtoground = 1;
	dropeverythingtouchingcrate(self.origin);
	self cratedeactivate();
	self thread cratedroptogroundkill();
	self crateredophysics();
	self crateactivate();
	self.droppingtoground = undefined;
}

/*
	Name: configureteampost
	Namespace: supplydrop
	Checksum: 0xE0A882FE
	Offset: 0x66F8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function configureteampost(owner)
{
	crate = self;
	crate thread ownerteamchangewatcher();
}

/*
	Name: cratespawn
	Namespace: supplydrop
	Checksum: 0x93D38E60
	Offset: 0x6738
	Size: 0x326
	Parameters: 6
	Flags: Linked
*/
function cratespawn(killstreak, killstreakid, owner, team, drop_origin, drop_angle)
{
	crate = spawn("script_model", drop_origin, 1);
	crate killstreaks::configure_team(killstreak, killstreakid, owner, undefined, undefined, &configureteampost);
	crate.angles = drop_angle;
	crate.visibletoall = 0;
	crate.script_noteworthy = "care_package";
	crate clientfield::set("enemyequip", 1);
	if(killstreak == "ai_tank_drop" || killstreak == "inventory_ai_tank_drop")
	{
		crate setmodel(level.cratemodeltank);
		crate setenemymodel(level.cratemodeltank);
	}
	else
	{
		crate setmodel(level.cratemodelfriendly);
		crate setenemymodel(level.cratemodelenemy);
	}
	crate disconnectpaths();
	switch(killstreak)
	{
		case "turret_drop":
		{
			crate.cratetype = level.cratetypes[killstreak]["autoturret"];
			break;
		}
		case "tow_turret_drop":
		{
			crate.cratetype = level.cratetypes[killstreak]["auto_tow"];
			break;
		}
		case "m220_tow_drop":
		{
			crate.cratetype = level.cratetypes[killstreak]["m220_tow"];
			break;
		}
		case "ai_tank_drop":
		case "inventory_ai_tank_drop":
		{
			crate.cratetype = level.cratetypes[killstreak]["ai_tank_drop"];
			break;
		}
		case "inventory_minigun_drop":
		case "minigun_drop":
		{
			crate.cratetype = level.cratetypes[killstreak]["minigun"];
			break;
		}
		case "inventory_m32_drop":
		case "m32_drop":
		{
			crate.cratetype = level.cratetypes[killstreak]["m32"];
			break;
		}
		default:
		{
			crate.cratetype = getrandomcratetype("supplydrop");
			break;
		}
	}
	return crate;
}

/*
	Name: cratedelete
	Namespace: supplydrop
	Checksum: 0xCCCAD795
	Offset: 0x6A68
	Size: 0x1F4
	Parameters: 1
	Flags: Linked
*/
function cratedelete(drop_all_to_ground)
{
	if(!isdefined(self))
	{
		return;
	}
	killstreaks::remove_ricochet_protection(self.killstreak_id, self.originalowner);
	if(!isdefined(drop_all_to_ground))
	{
		drop_all_to_ground = 1;
	}
	if(isdefined(self.friendlyobjid))
	{
		objective_delete(self.friendlyobjid);
		gameobjects::release_obj_id(self.friendlyobjid);
		self.friendlyobjid = undefined;
	}
	if(isdefined(self.enemyobjid))
	{
		foreach(objid in self.enemyobjid)
		{
			objective_delete(objid);
			gameobjects::release_obj_id(objid);
		}
		self.enemyobjid = undefined;
	}
	if(isdefined(self.hackerobjid))
	{
		objective_delete(self.hackerobjid);
		gameobjects::release_obj_id(self.hackerobjid);
		self.hackerobjid = undefined;
	}
	if(drop_all_to_ground)
	{
		level thread dropalltogroundaftercratedelete(self, self.origin);
	}
	if(isdefined(self.killcament))
	{
		self.killcament thread util::deleteaftertime(5);
	}
	self delete();
}

/*
	Name: stationarycrateoverride
	Namespace: supplydrop
	Checksum: 0x12220DF6
	Offset: 0x6C68
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function stationarycrateoverride()
{
	self endon(#"death");
	self endon(#"stationary");
	wait(3);
	self.angles = self.angles;
	self.origin = self.origin;
	self notify(#"stationary");
}

/*
	Name: timeoutcratewaiter
	Namespace: supplydrop
	Checksum: 0xF4DED14B
	Offset: 0x6CC0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function timeoutcratewaiter()
{
	self endon(#"death");
	self endon(#"stationary");
	wait(20);
	self cratedelete(1);
}

/*
	Name: cratephysics
	Namespace: supplydrop
	Checksum: 0x29695EB8
	Offset: 0x6D08
	Size: 0x110
	Parameters: 0
	Flags: Linked
*/
function cratephysics()
{
	forcepoint = self.origin;
	params = level.killstreakbundle["supply_drop"];
	if(!isdefined(params.kslandingvelocity))
	{
		params.kslandingvelocity = 100;
	}
	initialvelocity = (0, 0, (params.kslandingvelocity * -1) / 40);
	self physicslaunch(forcepoint, initialvelocity);
	self thread timeoutcratewaiter();
	self thread stationarycrateoverride();
	self thread update_crate_velocity();
	self thread play_impact_sound();
	self waittill(#"stationary");
}

/*
	Name: get_height
	Namespace: supplydrop
	Checksum: 0x47657ED9
	Offset: 0x6E20
	Size: 0xEA
	Parameters: 1
	Flags: None
*/
function get_height(e_ignore = self)
{
	trace = groundtrace(self.origin + (0, 0, 10), self.origin + (vectorscale((0, 0, -1), 10000)), 0, e_ignore, 0);
	/#
		recordline(self.origin + (0, 0, 10), trace[""], (1, 0.5, 0), "", self);
	#/
	return distance(self.origin, trace["position"]);
}

/*
	Name: cratecontrolleddrop
	Namespace: supplydrop
	Checksum: 0xDF961C5E
	Offset: 0x6F18
	Size: 0x304
	Parameters: 2
	Flags: Linked
*/
function cratecontrolleddrop(killstreak, v_target_location)
{
	crate = self;
	supplydrop = 1;
	if(killstreak == "ai_tank_drop")
	{
		supplydrop = 0;
	}
	if(supplydrop)
	{
		params = level.killstreakbundle["supply_drop"];
	}
	else
	{
		params = level.killstreakbundle["ai_tank_drop"];
	}
	if(!isdefined(params.ksthrustersoffheight))
	{
		params.ksthrustersoffheight = 100;
	}
	if(!isdefined(params.kstotaldroptime))
	{
		params.kstotaldroptime = 4;
	}
	if(!isdefined(params.ksacceltimepercentage))
	{
		params.ksacceltimepercentage = 0.65;
	}
	acceltime = params.kstotaldroptime * params.ksacceltimepercentage;
	deceltime = params.kstotaldroptime - acceltime;
	target = (v_target_location[0], v_target_location[1], v_target_location[2] + params.ksthrustersoffheight);
	hostmigration::waittillhostmigrationdone();
	crate moveto(target, params.kstotaldroptime, acceltime, deceltime);
	crate thread watchforcratekill(v_target_location[2] + (isdefined(params.ksstartcratekillheightfromground) ? params.ksstartcratekillheightfromground : 200));
	wait(acceltime - 0.05);
	if(supplydrop)
	{
		crate clientfield::set("supplydrop_thrusters_state", 1);
	}
	else
	{
		crate clientfield::set("aitank_thrusters_state", 1);
	}
	crate waittill(#"movedone");
	hostmigration::waittillhostmigrationdone();
	if(supplydrop)
	{
		crate clientfield::set("supplydrop_thrusters_state", 0);
	}
	else
	{
		crate clientfield::set("aitank_thrusters_state", 0);
	}
	crate cratephysics();
}

/*
	Name: play_impact_sound
	Namespace: supplydrop
	Checksum: 0x701E8961
	Offset: 0x7228
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function play_impact_sound()
{
	self endon(#"entityshutdown");
	self endon(#"stationary");
	self endon(#"death");
	wait(0.5);
	while(abs(self.velocity[2]) > 5)
	{
		wait(0.1);
	}
	self playsound("phy_impact_supply");
}

/*
	Name: update_crate_velocity
	Namespace: supplydrop
	Checksum: 0x75D17FBF
	Offset: 0x72B8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function update_crate_velocity()
{
	self endon(#"entityshutdown");
	self endon(#"stationary");
	self.velocity = (0, 0, 0);
	self.old_origin = self.origin;
	while(isdefined(self))
	{
		self.velocity = self.origin - self.old_origin;
		self.old_origin = self.origin;
		wait(0.05);
	}
}

/*
	Name: crateredophysics
	Namespace: supplydrop
	Checksum: 0xB63B7A8
	Offset: 0x7338
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function crateredophysics()
{
	forcepoint = self.origin;
	initialvelocity = (0, 0, 0);
	self physicslaunch(forcepoint, initialvelocity);
	self thread timeoutcratewaiter();
	self thread stationarycrateoverride();
	self waittill(#"stationary");
}

/*
	Name: do_supply_drop_detonation
	Namespace: supplydrop
	Checksum: 0x73899FB
	Offset: 0x73C0
	Size: 0x184
	Parameters: 2
	Flags: Linked
*/
function do_supply_drop_detonation(weapon, owner)
{
	self notify(#"supplydropwatcher");
	self endon(#"supplydropwatcher");
	self endon(#"spawned_player");
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"grenade_timeout");
	self util::waittillnotmoving();
	self.angles = (0, self.angles[1], 90);
	fuse_time = weapon.fusetime / 1000;
	wait(fuse_time);
	if(!isdefined(owner) || !owner emp::enemyempactive())
	{
		thread smokegrenade::playsmokesound(self.origin, 6, level.sound_smoke_start, level.sound_smoke_stop, level.sound_smoke_loop);
		playfxontag(level._supply_drop_smoke_fx, self, "tag_fx");
		proj_explosion_sound = weapon.projexplosionsound;
		sound::play_in_space(proj_explosion_sound, self.origin);
	}
	wait(3);
	self delete();
}

/*
	Name: dosupplydrop
	Namespace: supplydrop
	Checksum: 0xFD6A2B70
	Offset: 0x7550
	Size: 0xF4
	Parameters: 6
	Flags: Linked
*/
function dosupplydrop(weapon_instance, weapon, owner, killstreak_id, package_contents_id, context)
{
	weapon endon(#"explode");
	weapon endon(#"grenade_timeout");
	self endon(#"disconnect");
	team = owner.team;
	weapon_instance thread watchexplode(weapon, owner, killstreak_id, package_contents_id);
	weapon_instance util::waittillnotmoving();
	weapon_instance notify(#"stoppedmoving");
	self thread helidelivercrate(weapon_instance.origin, weapon, owner, team, killstreak_id, package_contents_id, context);
}

/*
	Name: watchexplode
	Namespace: supplydrop
	Checksum: 0x181D4617
	Offset: 0x7650
	Size: 0x8C
	Parameters: 4
	Flags: Linked
*/
function watchexplode(weapon, owner, killstreak_id, package_contents_id)
{
	self endon(#"stoppedmoving");
	team = owner.team;
	self waittill(#"explode", position);
	owner thread helidelivercrate(position, weapon, owner, team, killstreak_id, package_contents_id);
}

/*
	Name: cratetimeoutthreader
	Namespace: supplydrop
	Checksum: 0xBD2C81CF
	Offset: 0x76E8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function cratetimeoutthreader()
{
	crate = self;
	cratetimeout(90);
	crate thread deleteonownerleave();
}

/*
	Name: cratetimeout
	Namespace: supplydrop
	Checksum: 0xD13A5FFB
	Offset: 0x7738
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function cratetimeout(time)
{
	crate = self;
	self thread killstreaks::waitfortimeout("inventory_supply_drop", 90000, &cratedelete, "death");
}

/*
	Name: deleteonownerleave
	Namespace: supplydrop
	Checksum: 0x262852A5
	Offset: 0x7798
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function deleteonownerleave()
{
	crate = self;
	crate endon(#"death");
	crate.owner util::waittill_any("joined_team", "joined_spectators", "disconnect");
	crate cratedelete(1);
}

/*
	Name: waitanddelete
	Namespace: supplydrop
	Checksum: 0xFDA33AD3
	Offset: 0x7810
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function waitanddelete(time)
{
	self endon(#"death");
	wait(time);
	self delete();
}

/*
	Name: dropcrate
	Namespace: supplydrop
	Checksum: 0x7F53F382
	Offset: 0x7850
	Size: 0x424
	Parameters: 10
	Flags: Linked
*/
function dropcrate(origin, angle, killstreak, owner, team, killcament, killstreak_id, package_contents_id, crate_, context)
{
	angle = (angle[0] * 0.5, angle[1] * 0.5, angle[2] * 0.5);
	if(isdefined(crate_))
	{
		origin = crate_.origin;
		angle = crate_.angles;
		crate_ thread waitanddelete(0.1);
	}
	crate = cratespawn(killstreak, killstreak_id, owner, team, origin, angle);
	killcament unlink();
	killcament linkto(crate);
	crate.killcament = killcament;
	crate.killstreak_id = killstreak_id;
	crate.package_contents_id = package_contents_id;
	killcament thread util::deleteaftertime(15);
	killcament thread unlinkonrotation(crate);
	crate endon(#"death");
	crate cratetimeoutthreader();
	trace = groundtrace(crate.origin + (vectorscale((0, 0, -1), 100)), crate.origin + (vectorscale((0, 0, -1), 10000)), 0, crate, 0);
	v_target_location = trace["position"];
	/#
		if(getdvarint("", 0))
		{
			util::drawcylinder(v_target_location, context.radius, 8000, 99999999, "", vectorscale((0, 0, 1), 0.9), 0.8);
		}
	#/
	crate cratecontrolleddrop(killstreak, v_target_location);
	crate thread hacker_tool::registerwithhackertool(level.carepackagehackertoolradius, level.carepackagehackertooltimems);
	cleanup(context, owner);
	if(isdefined(crate.cratetype) && isdefined(crate.cratetype.landfunctionoverride))
	{
		[[crate.cratetype.landfunctionoverride]](crate, killstreak, owner, team, context);
	}
	else
	{
		crate crateactivate();
		crate thread crateusethink();
		crate thread crateusethinkowner();
		if(isdefined(crate.cratetype) && isdefined(crate.cratetype.hint_gambler))
		{
			crate thread crategamblerthink();
		}
		default_land_function(crate, killstreak, owner, team);
	}
}

/*
	Name: unlinkonrotation
	Namespace: supplydrop
	Checksum: 0xCBD2C630
	Offset: 0x7C80
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function unlinkonrotation(crate)
{
	self endon(#"delete");
	crate endon(#"death");
	crate endon(#"entityshutdown");
	crate endon(#"stationary");
	waitbeforerotationcheck = getdvarfloat("scr_supplydrop_killcam_rot_wait", 0.5);
	wait(waitbeforerotationcheck);
	mincos = getdvarfloat("scr_supplydrop_killcam_max_rot", 0.999);
	cosine = 1;
	currentdirection = vectornormalize(anglestoforward(crate.angles));
	while(cosine > mincos)
	{
		olddirection = currentdirection;
		wait(0.05);
		currentdirection = vectornormalize(anglestoforward(crate.angles));
		cosine = vectordot(olddirection, currentdirection);
	}
	self unlink();
}

/*
	Name: default_land_function
	Namespace: supplydrop
	Checksum: 0x607ED3A
	Offset: 0x7E10
	Size: 0x1C2
	Parameters: 4
	Flags: Linked
*/
function default_land_function(crate, category, owner, team)
{
	if(1)
	{
		for(;;)
		{
			crate waittill(#"captured", player, remote_hack);
			player challenges::capturedcrate(owner);
			deletecrate = player givecrateitem(crate);
		}
		if(isdefined(deletecrate) && !deletecrate)
		{
		}
		playerhasengineerperk = player hasperk("specialty_showenemyequipment");
		if(playerhasengineerperk || remote_hack == 1 && owner != player && (level.teambased && team != player.team || !level.teambased))
		{
			spawn_explosive_crate(crate.origin, crate.angles, category, owner, team, player, playerhasengineerperk);
			crate makeunusable();
			util::wait_network_frame();
			crate cratedelete(0);
		}
		else
		{
			crate cratedelete(1);
		}
		return;
	}
}

/*
	Name: spawn_explosive_crate
	Namespace: supplydrop
	Checksum: 0x16E18538
	Offset: 0x7FE0
	Size: 0x1E0
	Parameters: 7
	Flags: Linked
*/
function spawn_explosive_crate(origin, angle, killstreak, owner, team, hacker, playerhasengineerperk)
{
	crate = cratespawn(killstreak, undefined, owner, team, origin, angle);
	crate setowner(owner);
	crate setteam(team);
	if(level.teambased)
	{
		crate setenemymodel(level.cratemodelboobytrapped);
		crate makeusable(team);
	}
	else
	{
		crate setenemymodel(level.cratemodelenemy);
	}
	crate.hacker = hacker;
	crate.visibletoall = 0;
	crate crateactivate(hacker);
	crate sethintstringforperk("specialty_showenemyequipment", level.supplydropdisarmcrate);
	crate thread crateusethink();
	crate thread crateusethinkowner();
	crate thread watch_explosive_crate();
	crate cratetimeoutthreader();
	crate.playerhasengineerperk = playerhasengineerperk;
}

/*
	Name: watch_explosive_crate
	Namespace: supplydrop
	Checksum: 0xCEC43876
	Offset: 0x81C8
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function watch_explosive_crate()
{
	killcament = spawn("script_model", self.origin + vectorscale((0, 0, 1), 60));
	self.killcament = killcament;
	self waittill(#"captured", player, remote_hack);
	if(!player hasperk("specialty_showenemyequipment") && !remote_hack)
	{
		self thread entityheadicons::setentityheadicon(player.team, player, level.crate_headicon_offset, "headicon_dead", 1);
		self loop_sound("wpn_semtex_alert", 0.15);
		if(!isdefined(self.hacker))
		{
			self.hacker = self;
		}
		self radiusdamage(self.origin, 256, 300, 75, self.hacker, "MOD_EXPLOSIVE", getweapon("supplydrop"));
		playfx(level._supply_drop_explosion_fx, self.origin);
		playsoundatposition("wpn_grenade_explode", self.origin);
	}
	else
	{
		playsoundatposition("mpl_turret_alert", self.origin);
		scoreevents::processscoreevent("disarm_hacked_care_package", player);
		player challenges::disarmedhackedcarepackage();
	}
	wait(0.1);
	self cratedelete();
	killcament thread util::deleteaftertime(5);
}

/*
	Name: loop_sound
	Namespace: supplydrop
	Checksum: 0x24326B77
	Offset: 0x8410
	Size: 0x78
	Parameters: 2
	Flags: Linked
*/
function loop_sound(alias, interval)
{
	self endon(#"death");
	while(true)
	{
		playsoundatposition(alias, self.origin);
		wait(interval);
		interval = interval / 1.2;
		if(interval < 0.08)
		{
			break;
		}
	}
}

/*
	Name: watchforcratekill
	Namespace: supplydrop
	Checksum: 0xD56D0635
	Offset: 0x8490
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function watchforcratekill(start_kill_watch_z_threshold)
{
	crate = self;
	crate endon(#"death");
	crate endon(#"stationary");
	while(crate.origin[2] > start_kill_watch_z_threshold)
	{
		wait(0.05);
	}
	stationarythreshold = 2;
	killthreshold = 15;
	maxframestillstationary = 20;
	numframesstationary = 0;
	while(true)
	{
		vel = 0;
		if(isdefined(self.velocity))
		{
			vel = abs(self.velocity[2]);
		}
		if(vel > killthreshold)
		{
			crate is_touching_crate();
			crate is_clone_touching_crate();
		}
		if(vel < stationarythreshold)
		{
			numframesstationary++;
		}
		else
		{
			numframesstationary = 0;
		}
		if(numframesstationary >= maxframestillstationary)
		{
			break;
		}
		wait(0.05);
	}
}

/*
	Name: cratekill
	Namespace: supplydrop
	Checksum: 0xD75B512C
	Offset: 0x8608
	Size: 0x11C
	Parameters: 0
	Flags: None
*/
function cratekill()
{
	self endon(#"death");
	stationarythreshold = 2;
	killthreshold = 15;
	maxframestillstationary = 20;
	numframesstationary = 0;
	while(true)
	{
		vel = 0;
		if(isdefined(self.velocity))
		{
			vel = abs(self.velocity[2]);
		}
		if(vel > killthreshold)
		{
			self is_touching_crate();
			self is_clone_touching_crate();
		}
		if(vel < stationarythreshold)
		{
			numframesstationary++;
		}
		else
		{
			numframesstationary = 0;
		}
		if(numframesstationary >= maxframestillstationary)
		{
			break;
		}
		wait(0.01);
	}
}

/*
	Name: cratedroptogroundkill
	Namespace: supplydrop
	Checksum: 0xDFFB5DAF
	Offset: 0x8730
	Size: 0x42C
	Parameters: 0
	Flags: Linked
*/
function cratedroptogroundkill()
{
	self endon(#"death");
	self endon(#"stationary");
	for(;;)
	{
		players = getplayers();
		dotrace = 0;
		for(i = 0; i < players.size; i++)
		{
			if(players[i].sessionstate != "playing")
			{
				continue;
			}
			if(players[i].team == "spectator")
			{
				continue;
			}
			self is_equipment_touching_crate(players[i]);
			if(!isalive(players[i]))
			{
				continue;
			}
			flattenedselforigin = (self.origin[0], self.origin[1], 0);
			flattenedplayerorigin = (players[i].origin[0], players[i].origin[1], 0);
			if(distancesquared(flattenedselforigin, flattenedplayerorigin) > 4096)
			{
				continue;
			}
			dotrace = 1;
			break;
		}
		if(dotrace)
		{
			start = self.origin;
			cratedroptogroundtrace(start);
			start = self getpointinbounds(1, 0, 0);
			cratedroptogroundtrace(start);
			start = self getpointinbounds(-1, 0, 0);
			cratedroptogroundtrace(start);
			start = self getpointinbounds(0, -1, 0);
			cratedroptogroundtrace(start);
			start = self getpointinbounds(0, 1, 0);
			cratedroptogroundtrace(start);
			start = self getpointinbounds(1, 1, 0);
			cratedroptogroundtrace(start);
			start = self getpointinbounds(-1, 1, 0);
			cratedroptogroundtrace(start);
			start = self getpointinbounds(1, -1, 0);
			cratedroptogroundtrace(start);
			start = self getpointinbounds(-1, -1, 0);
			cratedroptogroundtrace(start);
			wait(0.2);
			continue;
		}
		wait(0.5);
	}
}

/*
	Name: cratedroptogroundtrace
	Namespace: supplydrop
	Checksum: 0x646750B4
	Offset: 0x8B68
	Size: 0x1F4
	Parameters: 1
	Flags: Linked
*/
function cratedroptogroundtrace(start)
{
	end = start + (vectorscale((0, 0, -1), 8000));
	trace = bullettrace(start, end, 1, self, 1, 1);
	if(isdefined(trace["entity"]) && isplayer(trace["entity"]) && isalive(trace["entity"]))
	{
		player = trace["entity"];
		if(player.sessionstate != "playing")
		{
			return;
		}
		if(player.team == "spectator")
		{
			return;
		}
		if(distancesquared(start, trace["position"]) < 144 || self istouching(player))
		{
			player dodamage(player.health + 1, player.origin, self.owner, self, "none", "MOD_HIT_BY_OBJECT", 0, getweapon("supplydrop"));
			player playsound("mpl_supply_crush");
			player playsound("phy_impact_supply");
		}
	}
}

/*
	Name: is_touching_crate
	Namespace: supplydrop
	Checksum: 0x108E0021
	Offset: 0x8D68
	Size: 0x3BA
	Parameters: 0
	Flags: Linked
*/
function is_touching_crate()
{
	if(!isdefined(self))
	{
		return;
	}
	crate = self;
	extraboundary = vectorscale((1, 1, 1), 10);
	players = getplayers();
	crate_bottom_point = self.origin;
	foreach(player in level.players)
	{
		if(isdefined(player) && isalive(player))
		{
			stance = player getstance();
			stance_z_offset = (stance == "stand" ? 40 : (stance == "crouch" ? 18 : 6));
			player_test_point = player.origin + (0, 0, stance_z_offset);
			if(player_test_point[2] < crate_bottom_point[2] && self istouching(player, extraboundary))
			{
				attacker = (isdefined(self.owner) ? self.owner : self);
				player dodamage(player.health + 1, player.origin, attacker, self, "none", "MOD_HIT_BY_OBJECT", 0, getweapon("supplydrop"));
				player playsound("mpl_supply_crush");
				player playsound("phy_impact_supply");
			}
		}
		self is_equipment_touching_crate(player);
	}
	vehicles = getentarray("script_vehicle", "classname");
	foreach(vehicle in vehicles)
	{
		if(isvehicle(vehicle))
		{
			if(isdefined(vehicle.archetype) && vehicle.archetype == "wasp")
			{
				if(crate istouching(vehicle, vectorscale((1, 1, 1), 2)))
				{
					vehicle notify(#"sentinel_shutdown");
				}
			}
		}
	}
}

/*
	Name: is_clone_touching_crate
	Namespace: supplydrop
	Checksum: 0x1440CC0F
	Offset: 0x9130
	Size: 0x1F6
	Parameters: 0
	Flags: Linked
*/
function is_clone_touching_crate()
{
	if(!isdefined(self))
	{
		return;
	}
	extraboundary = vectorscale((1, 1, 1), 10);
	actors = getactorarray();
	for(i = 0; i < actors.size; i++)
	{
		if(isdefined(actors[i]) && isdefined(actors[i].isaiclone) && isalive(actors[i]) && actors[i].origin[2] < self.origin[2] && self istouching(actors[i], extraboundary))
		{
			attacker = (isdefined(self.owner) ? self.owner : self);
			actors[i] dodamage(actors[i].health + 1, actors[i].origin, attacker, self, "none", "MOD_HIT_BY_OBJECT", 0, getweapon("supplydrop"));
			actors[i] playsound("mpl_supply_crush");
			actors[i] playsound("phy_impact_supply");
		}
	}
}

/*
	Name: is_equipment_touching_crate
	Namespace: supplydrop
	Checksum: 0xDC00F327
	Offset: 0x9330
	Size: 0x1EC
	Parameters: 1
	Flags: Linked
*/
function is_equipment_touching_crate(player)
{
	extraboundary = vectorscale((1, 1, 1), 10);
	if(isdefined(player) && isdefined(player.weaponobjectwatcherarray))
	{
		for(watcher = 0; watcher < player.weaponobjectwatcherarray.size; watcher++)
		{
			objectwatcher = player.weaponobjectwatcherarray[watcher];
			objectarray = objectwatcher.objectarray;
			if(isdefined(objectarray))
			{
				for(weaponobject = 0; weaponobject < objectarray.size; weaponobject++)
				{
					if(isdefined(objectarray[weaponobject]) && self istouching(objectarray[weaponobject], extraboundary))
					{
						if(isdefined(objectwatcher.ondetonatecallback))
						{
							objectwatcher thread weaponobjects::waitanddetonate(objectarray[weaponobject], 0);
							continue;
						}
						weaponobjects::removeweaponobject(objectwatcher, objectarray[weaponobject]);
					}
				}
			}
		}
	}
	extraboundary = vectorscale((1, 1, 1), 15);
	if(isdefined(player) && isdefined(player.tacticalinsertion) && self istouching(player.tacticalinsertion, extraboundary))
	{
		player.tacticalinsertion thread tacticalinsertion::fizzle();
	}
}

/*
	Name: spawnuseent
	Namespace: supplydrop
	Checksum: 0x95B27F0A
	Offset: 0x9528
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function spawnuseent()
{
	useent = spawn("script_origin", self.origin);
	useent.curprogress = 0;
	useent.inuse = 0;
	useent.userate = 0;
	useent.usetime = 0;
	useent.owner = self;
	useent thread useentownerdeathwaiter(self);
	return useent;
}

/*
	Name: useentownerdeathwaiter
	Namespace: supplydrop
	Checksum: 0x2506AB40
	Offset: 0x95D0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function useentownerdeathwaiter(owner)
{
	self endon(#"death");
	owner waittill(#"death");
	self delete();
}

/*
	Name: crateusethink
	Namespace: supplydrop
	Checksum: 0xE4383EFA
	Offset: 0x9618
	Size: 0x172
	Parameters: 0
	Flags: Linked
*/
function crateusethink()
{
	while(isdefined(self))
	{
		self waittill(#"trigger", player);
		if(!isdefined(self))
		{
			break;
		}
		if(!isalive(player))
		{
			continue;
		}
		if(!player isonground())
		{
			continue;
		}
		if(isdefined(self.owner) && self.owner == player)
		{
			continue;
		}
		useent = self spawnuseent();
		result = 0;
		if(isdefined(self.hacker))
		{
			useent.hacker = self.hacker;
		}
		self.useent = useent;
		result = useent useholdthink(player, level.cratenonownerusetime);
		if(isdefined(useent))
		{
			useent delete();
		}
		if(result && isdefined(self))
		{
			scoreevents::givecratecapturemedal(self, player);
			self notify(#"captured", player, 0);
		}
	}
}

/*
	Name: crateusethinkowner
	Namespace: supplydrop
	Checksum: 0x6FAAF267
	Offset: 0x9798
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function crateusethinkowner()
{
	self endon(#"joined_team");
	while(isdefined(self))
	{
		self waittill(#"trigger", player);
		if(!isdefined(self))
		{
			break;
		}
		if(!isalive(player))
		{
			continue;
		}
		if(!isdefined(self.owner))
		{
			continue;
		}
		if(self.owner != player)
		{
			continue;
		}
		result = self useholdthink(player, level.crateownerusetime);
		if(result && isdefined(self) && isdefined(player))
		{
			self notify(#"captured", player, 0);
		}
	}
}

/*
	Name: useholdthink
	Namespace: supplydrop
	Checksum: 0x832D62AD
	Offset: 0x9888
	Size: 0x15A
	Parameters: 2
	Flags: Linked
*/
function useholdthink(player, usetime)
{
	player notify(#"use_hold");
	player util::freeze_player_controls(1);
	player util::_disableweapon();
	self.curprogress = 0;
	self.inuse = 1;
	self.userate = 0;
	self.usetime = usetime;
	player thread personalusebar(self);
	result = useholdthinkloop(player);
	if(isdefined(player))
	{
		player notify(#"done_using");
	}
	if(isdefined(player))
	{
		if(isalive(player))
		{
			player util::_enableweapon();
			player util::freeze_player_controls(0);
		}
	}
	if(isdefined(self))
	{
		self.inuse = 0;
	}
	if(isdefined(result) && result)
	{
		return true;
	}
	return false;
}

/*
	Name: continueholdthinkloop
	Namespace: supplydrop
	Checksum: 0x39999FAC
	Offset: 0x99F0
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function continueholdthinkloop(player)
{
	if(!isdefined(self))
	{
		return false;
	}
	if(self.curprogress >= self.usetime)
	{
		return false;
	}
	if(!isalive(player))
	{
		return false;
	}
	if(player.throwinggrenade)
	{
		return false;
	}
	if(!player usebuttonpressed())
	{
		return false;
	}
	if(player meleebuttonpressed())
	{
		return false;
	}
	if(player isinvehicle())
	{
		return false;
	}
	if(player isweaponviewonlylinked())
	{
		return false;
	}
	if(player isremotecontrolling())
	{
		return false;
	}
	return true;
}

/*
	Name: useholdthinkloop
	Namespace: supplydrop
	Checksum: 0xCAE826B8
	Offset: 0x9AF8
	Size: 0xFA
	Parameters: 1
	Flags: Linked
*/
function useholdthinkloop(player)
{
	level endon(#"game_ended");
	self endon(#"disabled");
	self.owner endon(#"crate_use_interrupt");
	timedout = 0;
	while(self continueholdthinkloop(player))
	{
		timedout = timedout + 0.05;
		self.curprogress = self.curprogress + (50 * self.userate);
		self.userate = 1;
		if(self.curprogress >= self.usetime)
		{
			self.inuse = 0;
			wait(0.05);
			return isalive(player);
		}
		wait(0.05);
		hostmigration::waittillhostmigrationdone();
	}
	return 0;
}

/*
	Name: crategamblerthink
	Namespace: supplydrop
	Checksum: 0xADD1C8BE
	Offset: 0x9C00
	Size: 0x148
	Parameters: 0
	Flags: Linked
*/
function crategamblerthink()
{
	self endon(#"death");
	for(;;)
	{
		self waittill(#"trigger_use_doubletap", player);
		if(!player hasperk("specialty_showenemyequipment"))
		{
			continue;
		}
		if(isdefined(self.useent) && self.useent.inuse)
		{
			if(isdefined(self.owner) && self.owner != player)
			{
				continue;
			}
		}
		player playlocalsound("uin_gamble_perk");
		self.cratetype = getrandomcratetype("gambler", self.cratetype.name);
		self cratereactivate();
		self sethintstringforperk("specialty_showenemyequipment", self.cratetype.hint);
		self notify(#"crate_use_interrupt");
		level notify(#"use_interrupt", self);
		return;
	}
}

/*
	Name: cratereactivate
	Namespace: supplydrop
	Checksum: 0x1A7F17FB
	Offset: 0x9D50
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function cratereactivate()
{
	self sethintstring(self.cratetype.hint);
	icon = self geticonforcrate();
	self thread entityheadicons::setentityheadicon(self.team, self, level.crate_headicon_offset, icon, 1);
}

/*
	Name: personalusebar
	Namespace: supplydrop
	Checksum: 0x38EA0A6F
	Offset: 0x9DD8
	Size: 0x3F4
	Parameters: 1
	Flags: Linked
*/
function personalusebar(object)
{
	self endon(#"disconnect");
	capturecratestate = 0;
	if(self hasperk("specialty_showenemyequipment") && object.owner != self && !isdefined(object.hacker) && (level.teambased && object.owner.team != self.team || !level.teambased))
	{
		capturecratestate = 2;
		self playlocalsound("evt_hacker_hacking");
	}
	else
	{
		if(self hasperk("specialty_showenemyequipment") && isdefined(object.hacker) && (object.owner == self || (level.teambased && object.owner.team == self.team)))
		{
			capturecratestate = 3;
			self playlocalsound("evt_hacker_hacking");
		}
		else
		{
			capturecratestate = 1;
			self.is_capturing_own_supply_drop = object.owner === self && (!isdefined(object.originalowner) || object.originalowner == self);
		}
	}
	lastrate = -1;
	while(isalive(self) && isdefined(object) && object.inuse && !level.gameended)
	{
		if(lastrate != object.userate)
		{
			if(object.curprogress > object.usetime)
			{
				object.curprogress = object.usetime;
			}
			if(!object.userate)
			{
				self clientfield::set_player_uimodel("hudItems.captureCrateTotalTime", 0);
				self clientfield::set_player_uimodel("hudItems.captureCrateState", 0);
			}
			else
			{
				barfrac = object.curprogress / object.usetime;
				rateofchange = object.userate / object.usetime;
				capturecratetotaltime = 0;
				if(rateofchange > 0)
				{
					capturecratetotaltime = (1 - barfrac) / rateofchange;
				}
				self clientfield::set_player_uimodel("hudItems.captureCrateTotalTime", int(capturecratetotaltime));
				self clientfield::set_player_uimodel("hudItems.captureCrateState", capturecratestate);
			}
		}
		lastrate = object.userate;
		wait(0.05);
	}
	self.is_capturing_own_supply_drop = 0;
	self clientfield::set_player_uimodel("hudItems.captureCrateTotalTime", 0);
	self clientfield::set_player_uimodel("hudItems.captureCrateState", 0);
}

/*
	Name: spawn_helicopter
	Namespace: supplydrop
	Checksum: 0xA76C288A
	Offset: 0xA1D8
	Size: 0x3D8
	Parameters: 8
	Flags: Linked
*/
function spawn_helicopter(owner, team, origin, angles, model, targetname, killstreak_id, context)
{
	chopper = spawnhelicopter(owner, origin, angles, model, targetname);
	if(!isdefined(chopper))
	{
		if(isplayer(owner))
		{
			killstreakrules::killstreakstop("supply_drop", team, killstreak_id);
			self notify(#"cleanup_marker");
		}
		return undefined;
	}
	chopper killstreaks::configure_team("supply_drop", killstreak_id, owner);
	chopper.maxhealth = level.heli_maxhealth;
	chopper.rocketdamageoneshot = chopper.maxhealth + 1;
	chopper.damagetaken = 0;
	hardpointtypefordamage = "supply_drop";
	if(context.killstreakref === "inventory_ai_tank_drop" || context.killstreakref === "ai_tank_drop")
	{
		hardpointtypefordamage = "supply_drop_ai_tank";
	}
	else if(context.killstreakref === "inventory_combat_robot" || context.killstreakref === "combat_robot")
	{
		hardpointtypefordamage = "supply_drop_combat_robot";
	}
	chopper thread helicopter::heli_damage_monitor(hardpointtypefordamage);
	chopper thread heatseekingmissile::missiletarget_proximitydetonateincomingmissile("crashing", "death");
	chopper.spawntime = gettime();
	chopper clientfield::set("enemyvehicle", 1);
	supplydropspeed = getdvarint("scr_supplydropSpeedStarting", 250);
	supplydropaccel = getdvarint("scr_supplydropAccelStarting", 100);
	chopper setspeed(supplydropspeed, supplydropaccel);
	/#
		chopper util::debug_slow_heli_speed();
	#/
	maxpitch = getdvarint("scr_supplydropMaxPitch", 25);
	maxroll = getdvarint("scr_supplydropMaxRoll", 45);
	chopper setmaxpitchroll(0, maxroll);
	chopper setdrawinfrared(1);
	target_set(chopper, vectorscale((0, 0, -1), 25));
	if(isplayer(owner))
	{
		chopper thread refcountdecchopper(team, killstreak_id);
	}
	chopper thread helidestroyed();
	return chopper;
}

/*
	Name: getdropheight
	Namespace: supplydrop
	Checksum: 0x93563A49
	Offset: 0xA5B8
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function getdropheight(origin)
{
	return airsupport::getminimumflyheight();
}

/*
	Name: getdropdirection
	Namespace: supplydrop
	Checksum: 0x5E75CE89
	Offset: 0xA5E0
	Size: 0x1E
	Parameters: 0
	Flags: Linked
*/
function getdropdirection()
{
	return (0, randomint(360), 0);
}

/*
	Name: getnextdropdirection
	Namespace: supplydrop
	Checksum: 0x3D4B4522
	Offset: 0xA608
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function getnextdropdirection(drop_direction, degrees)
{
	drop_direction = (0, drop_direction[1] + degrees, 0);
	if(drop_direction[1] >= 360)
	{
		drop_direction = (0, drop_direction[1] - 360, 0);
	}
	return drop_direction;
}

/*
	Name: gethelistart
	Namespace: supplydrop
	Checksum: 0xF70C0456
	Offset: 0xA678
	Size: 0x20A
	Parameters: 2
	Flags: Linked
*/
function gethelistart(drop_origin, drop_direction)
{
	dist = -1 * getdvarint("scr_supplydropIncomingDistance", 15000);
	pathrandomness = 100;
	direction = drop_direction + (0, randomintrange(-2, 3), 0);
	start_origin = drop_origin + (anglestoforward(direction) * dist);
	start_origin = start_origin + ((randomfloat(2) - 1) * pathrandomness, (randomfloat(2) - 1) * pathrandomness, 0);
	/#
		if(getdvarint("", 0))
		{
			if(level.noflyzones.size)
			{
				index = randomintrange(0, level.noflyzones.size);
				delta = drop_origin - level.noflyzones[index].origin;
				delta = (delta[0] + randomint(10), delta[1] + randomint(10), 0);
				delta = vectornormalize(delta);
				start_origin = drop_origin + (delta * dist);
			}
		}
	#/
	return start_origin;
}

/*
	Name: getheliend
	Namespace: supplydrop
	Checksum: 0xC6EF3487
	Offset: 0xA890
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function getheliend(drop_origin, drop_direction)
{
	pathrandomness = 150;
	dist = -1 * getdvarint("scr_supplydropOutgoingDistance", 15000);
	if(randomintrange(0, 2) == 0)
	{
		turn = randomintrange(60, 121);
	}
	else
	{
		turn = -1 * randomintrange(60, 121);
	}
	direction = drop_direction + (0, turn, 0);
	end_origin = drop_origin + (anglestoforward(direction) * dist);
	end_origin = end_origin + ((randomfloat(2) - 1) * pathrandomness, (randomfloat(2) - 1) * pathrandomness, 0);
	return end_origin;
}

/*
	Name: addoffsetontopoint
	Namespace: supplydrop
	Checksum: 0x988B17A2
	Offset: 0xAA00
	Size: 0x82
	Parameters: 3
	Flags: Linked
*/
function addoffsetontopoint(point, direction, offset)
{
	angles = vectortoangles((direction[0], direction[1], 0));
	offset_world = rotatepoint(offset, angles);
	return point + offset_world;
}

/*
	Name: supplydrophelistartpath_v2_setup
	Namespace: supplydrop
	Checksum: 0xDC08698F
	Offset: 0xAA90
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function supplydrophelistartpath_v2_setup(goal, goal_offset)
{
	goalpath = spawnstruct();
	goalpath.start = helicopter::getvalidrandomstartnode(goal).origin;
	return goalpath;
}

/*
	Name: supplydrophelistartpath_v2_part2_local
	Namespace: supplydrop
	Checksum: 0xD9DD0721
	Offset: 0xAAF8
	Size: 0x7E
	Parameters: 3
	Flags: Linked
*/
function supplydrophelistartpath_v2_part2_local(goal, goalpath, goal_local_offset)
{
	direction = goal - goalpath.start;
	goalpath.path = [];
	goalpath.path[0] = addoffsetontopoint(goal, direction, goal_local_offset);
}

/*
	Name: supplydrophelistartpath_v2_part2
	Namespace: supplydrop
	Checksum: 0x261F1A24
	Offset: 0xAB80
	Size: 0x4A
	Parameters: 3
	Flags: Linked
*/
function supplydrophelistartpath_v2_part2(goal, goalpath, goal_world_offset)
{
	goalpath.path = [];
	goalpath.path[0] = goal + goal_world_offset;
}

/*
	Name: supplydrophelistartpath
	Namespace: supplydrop
	Checksum: 0x213E8454
	Offset: 0xABD8
	Size: 0x362
	Parameters: 2
	Flags: None
*/
function supplydrophelistartpath(goal, goal_offset)
{
	total_tries = 12;
	tries = 0;
	goalpath = spawnstruct();
	drop_direction = getdropdirection();
	while(tries < total_tries)
	{
		goalpath.start = gethelistart(goal, drop_direction);
		goalpath.path = airsupport::gethelipath(goalpath.start, goal);
		startnoflyzones = airsupport::insidenoflyzones(goalpath.start, 0);
		if(isdefined(goalpath.path) && startnoflyzones.size == 0)
		{
			if(goalpath.path.size > 1)
			{
				direction = (goalpath.path[goalpath.path.size - 1]) - (goalpath.path[goalpath.path.size - 2]);
			}
			else
			{
				direction = (goalpath.path[goalpath.path.size - 1]) - goalpath.start;
			}
			goalpath.path[goalpath.path.size - 1] = addoffsetontopoint(goalpath.path[goalpath.path.size - 1], direction, goal_offset);
			/#
				sphere(goalpath.path[goalpath.path.size - 1], 10, (0, 0, 1), 1, 1, 10, 1000);
			#/
			return goalpath;
		}
		drop_direction = getnextdropdirection(drop_direction, 30);
		tries++;
	}
	drop_direction = getdropdirection();
	goalpath.start = gethelistart(goal, drop_direction);
	direction = goal - goalpath.start;
	goalpath.path = [];
	goalpath.path[0] = addoffsetontopoint(goal, direction, goal_offset);
	return goalpath;
}

/*
	Name: supplydropheliendpath_v2
	Namespace: supplydrop
	Checksum: 0xCA88B311
	Offset: 0xAF48
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function supplydropheliendpath_v2(start)
{
	goalpath = spawnstruct();
	goalpath.start = start;
	goal = helicopter::getvalidrandomleavenode(start).origin;
	goalpath.path = [];
	goalpath.path[0] = goal;
	return goalpath;
}

/*
	Name: supplydropheliendpath
	Namespace: supplydrop
	Checksum: 0x50BEF97
	Offset: 0xAFE8
	Size: 0x202
	Parameters: 2
	Flags: None
*/
function supplydropheliendpath(origin, drop_direction)
{
	total_tries = 5;
	tries = 0;
	goalpath = spawnstruct();
	while(tries < total_tries)
	{
		goal = getheliend(origin, drop_direction);
		goalpath.path = airsupport::gethelipath(origin, goal);
		if(isdefined(goalpath.path))
		{
			return goalpath;
		}
		tries++;
	}
	leave_nodes = getentarray("heli_leave", "targetname");
	foreach(node in leave_nodes)
	{
		goalpath.path = airsupport::gethelipath(origin, node.origin);
		if(isdefined(goalpath.path))
		{
			return goalpath;
		}
	}
	goalpath.path = [];
	goalpath.path[0] = getheliend(origin, drop_direction);
	return goalpath;
}

/*
	Name: inccratekillstreakusagestat
	Namespace: supplydrop
	Checksum: 0xAC7C01E0
	Offset: 0xB1F8
	Size: 0x2CE
	Parameters: 2
	Flags: Linked
*/
function inccratekillstreakusagestat(weapon, killstreak_id)
{
	if(weapon == level.weaponnone)
	{
		return;
	}
	switch(weapon.name)
	{
		case "turret_drop":
		{
			self killstreaks::play_killstreak_start_dialog("turret_drop", self.pers["team"], killstreak_id);
			break;
		}
		case "tow_turret_drop":
		{
			self killstreaks::play_killstreak_start_dialog("tow_turret_drop", self.pers["team"], killstreak_id);
			break;
		}
		case "inventory_supplydrop_marker":
		case "supplydrop_marker":
		{
			self killstreaks::play_killstreak_start_dialog("supply_drop", self.pers["team"], killstreak_id);
			level thread popups::displaykillstreakteammessagetoall("supply_drop", self);
			self challenges::calledincarepackage();
			self addweaponstat(getweapon("supplydrop"), "used", 1);
			break;
		}
		case "ai_tank_drop":
		case "inventory_ai_tank_drop":
		{
			self killstreaks::play_killstreak_start_dialog("ai_tank_drop", self.pers["team"], killstreak_id);
			level thread popups::displaykillstreakteammessagetoall("ai_tank_drop", self);
			self addweaponstat(getweapon("ai_tank_drop"), "used", 1);
			break;
		}
		case "inventory_minigun_drop":
		case "minigun_drop":
		{
			self killstreaks::play_killstreak_start_dialog("minigun", self.pers["team"], killstreak_id);
			break;
		}
		case "inventory_m32_drop":
		case "m32_drop":
		{
			self killstreaks::play_killstreak_start_dialog("m32", self.pers["team"], killstreak_id);
			break;
		}
		case "combat_robot_drop":
		{
			level thread popups::displaykillstreakteammessagetoall("combat_robot", self);
			break;
		}
	}
}

/*
	Name: markercleanupthread
	Namespace: supplydrop
	Checksum: 0xAC0B42BA
	Offset: 0xB4D0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function markercleanupthread(context)
{
	player = self;
	player util::waittill_any("death", "disconnect", "joined_team", "joined_spectators", "cleanup_marker");
	cleanup(context, player);
}

/*
	Name: getchopperdroppoint
	Namespace: supplydrop
	Checksum: 0x29FBB0CD
	Offset: 0xB550
	Size: 0xAE
	Parameters: 1
	Flags: Linked
*/
function getchopperdroppoint(context)
{
	chopper = self;
	return (isdefined(context.droptag) ? chopper gettagorigin(context.droptag) + rotatepoint((isdefined(context.droptagoffset) ? context.droptagoffset : (0, 0, 0)), chopper.angles) : chopper.origin);
}

/*
	Name: helidelivercrate
	Namespace: supplydrop
	Checksum: 0xE922D23D
	Offset: 0xB608
	Size: 0xFEC
	Parameters: 7
	Flags: Linked
*/
function helidelivercrate(origin, weapon, owner, team, killstreak_id, package_contents_id, context)
{
	if(owner emp::enemyempactive() && !owner hasperk("specialty_immuneemp"))
	{
		killstreakrules::killstreakstop("supply_drop", team, killstreak_id);
		self notify(#"cleanup_marker");
		return;
	}
	/#
		if(getdvarint("", 0))
		{
			level notify(#"stop_heli_drop_valid_location_marked_cylinder");
			level notify(#"stop_heli_drop_valid_location_arrived_at_goal_cylinder");
			level notify(#"stop_heli_drop_valid_location_dropped_cylinder");
			util::drawcylinder(origin, context.radius, 8000, 99999999, "", vectorscale((1, 0, 1), 0.4), 0.8);
		}
	#/
	if(!isdefined(context.marker))
	{
		return;
	}
	context.markerfxhandle = spawnfx(level.killstreakcorebundle.fxmarkedlocation, context.marker.origin + vectorscale((0, 0, 1), 5), (0, 0, 1), (1, 0, 0));
	context.markerfxhandle.team = owner.team;
	triggerfx(context.markerfxhandle);
	adddroplocation(killstreak_id, context.marker.origin);
	killstreakbundle = (isdefined(context.killstreaktype) ? level.killstreakbundle[context.killstreaktype] : undefined);
	ricochetdistance = (isdefined(killstreakbundle) ? killstreakbundle.ksricochetdistance : undefined);
	killstreaks::add_ricochet_protection(killstreak_id, owner, context.marker.origin, ricochetdistance);
	context.marker.team = owner.team;
	context.marker entityheadicons::destroyentityheadicons();
	context.marker entityheadicons::setentityheadicon(owner.pers["team"], owner, undefined, context.objective);
	if(isdefined(weapon))
	{
		inccratekillstreakusagestat(weapon, killstreak_id);
	}
	rear_hatch_offset_local = getdvarint("scr_supplydropOffset", 0);
	drop_origin = origin;
	drop_height = getdropheight(drop_origin);
	drop_height = drop_height + (level.zoffsetcounter * 350);
	level.zoffsetcounter++;
	if(level.zoffsetcounter >= 5)
	{
		level.zoffsetcounter = 0;
	}
	heli_drop_goal = (drop_origin[0], drop_origin[1], drop_height);
	/#
		sphere(heli_drop_goal, 10, (0, 1, 0), 1, 1, 10, 1000);
	#/
	goalpath = undefined;
	if(isdefined(context.dropoffset))
	{
		goalpath = supplydrophelistartpath_v2_setup(heli_drop_goal, context.dropoffset);
		supplydrophelistartpath_v2_part2_local(heli_drop_goal, goalpath, context.dropoffset);
	}
	else
	{
		goalpath = supplydrophelistartpath_v2_setup(heli_drop_goal, (rear_hatch_offset_local, 0, 0));
		goal_path_setup_needs_finishing = 1;
	}
	drop_direction = vectortoangles((heli_drop_goal[0], heli_drop_goal[1], 0) - (goalpath.start[0], goalpath.start[1], 0));
	if(isdefined(context.vehiclename))
	{
		helicoptervehicleinfo = context.vehiclename;
	}
	else
	{
		helicoptervehicleinfo = level.vtoldrophelicoptervehicleinfo;
	}
	chopper = spawn_helicopter(owner, team, goalpath.start, drop_direction, helicoptervehicleinfo, "", killstreak_id, context);
	if(goal_path_setup_needs_finishing === 1)
	{
		goal_world_offset = chopper.origin - chopper getchopperdroppoint(context);
		supplydrophelistartpath_v2_part2(heli_drop_goal, goalpath, goal_world_offset);
		goal_path_setup_needs_finishing = 0;
	}
	waitforonlyonedroplocation = 0;
	while(level.droplocations.size > 1 && waitforonlyonedroplocation)
	{
		arrayremovevalue(level.droplocations, undefined);
		wait_for_drop = 0;
		foreach(id, droplocation in level.droplocations)
		{
			if(id < killstreak_id)
			{
				wait_for_drop = 1;
				break;
			}
		}
		if(wait_for_drop)
		{
			wait(0.5);
		}
		else
		{
			break;
		}
	}
	chopper.killstreakweaponname = weapon.name;
	if(isdefined(context) && isdefined(context.hasflares))
	{
		chopper.numflares = 3;
		chopper.flareoffset = (0, 0, 0);
		chopper thread helicopter::create_flare_ent(vectorscale((0, 0, -1), 50));
	}
	else
	{
		chopper.numflares = 0;
	}
	killcament = spawn("script_model", chopper.origin + vectorscale((0, 0, 1), 800));
	killcament.angles = (100, chopper.angles[1], chopper.angles[2]);
	killcament.starttime = gettime();
	killcament linkto(chopper);
	if(isplayer(owner))
	{
		target_setturretaquire(self, 0);
		chopper thread samturretwatcher(drop_origin);
	}
	if(!isdefined(chopper))
	{
		return;
	}
	if(isdefined(context) && isdefined(context.prolog))
	{
		chopper [[context.prolog]](context);
	}
	else
	{
		chopper thread helidropcrate(level.killstreakweapons[weapon], owner, rear_hatch_offset_local, killcament, killstreak_id, package_contents_id, context);
	}
	chopper endon(#"death");
	chopper thread airsupport::followpath(goalpath.path, "drop_goal", 1);
	chopper thread speedregulator(heli_drop_goal);
	chopper waittill(#"drop_goal");
	if(isdefined(context) && isdefined(context.epilog))
	{
		chopper [[context.epilog]](context);
	}
	/#
		println("" + (gettime() - chopper.spawntime));
	#/
	/#
		if(getdvarint("", 0))
		{
			if(isdefined(context.dropoffset))
			{
				chopper_drop_point = chopper.origin - rotatepoint(context.dropoffset, chopper.angles);
			}
			else
			{
				chopper_drop_point = chopper getchopperdroppoint(context);
			}
			trace = groundtrace(chopper_drop_point + (vectorscale((0, 0, -1), 100)), chopper_drop_point + (vectorscale((0, 0, -1), 10000)), 0, undefined, 0);
			debug_drop_location = trace[""];
			util::drawcylinder(debug_drop_location, context.radius, 8000, 99999999, "", (1, 0.6, 0), 0.9);
			iprintln("" + distance2d(chopper_drop_point, heli_drop_goal));
		}
	#/
	on_target = 0;
	last_distance_from_goal_squared = 9999999 * 9999999;
	continue_waiting = 1;
	for(remaining_tries = 30; continue_waiting && remaining_tries > 0; remaining_tries--)
	{
		if(isdefined(context.dropoffset))
		{
			chopper_drop_point = chopper.origin - rotatepoint(context.dropoffset, chopper.angles);
		}
		else
		{
			chopper_drop_point = chopper getchopperdroppoint(context);
		}
		current_distance_from_goal_squared = distance2dsquared(chopper_drop_point, heli_drop_goal);
		continue_waiting = current_distance_from_goal_squared < last_distance_from_goal_squared && current_distance_from_goal_squared > (3.7 * 3.7);
		last_distance_from_goal_squared = current_distance_from_goal_squared;
		/#
			if(getdvarint("", 0))
			{
				sphere(chopper_drop_point, 8, (1, 0, 0), 0.9, 0, 20, 1);
			}
		#/
		if(continue_waiting)
		{
			/#
				if(getdvarint("", 0))
				{
					iprintln("" + distance2d(chopper_drop_point, heli_drop_goal));
				}
			#/
			wait(0.05);
		}
	}
	/#
		if(getdvarint("", 0))
		{
			iprintln("" + distance2d(chopper_drop_point, heli_drop_goal));
		}
	#/
	chopper notify(#"drop_crate", chopper.origin, chopper.angles, chopper.owner);
	chopper.droptime = gettime();
	chopper playsound("veh_supply_drop");
	wait(0.7);
	if(isdefined(level.killstreakweapons[weapon]))
	{
		chopper killstreaks::play_pilot_dialog_on_owner("waveStartFinal", level.killstreakweapons[weapon], chopper.killstreak_id);
	}
	supplydropspeed = getdvarint("scr_supplydropSpeedLeaving", 250);
	supplydropaccel = getdvarint("scr_supplydropAccelLeaving", 60);
	chopper setspeed(supplydropspeed, supplydropaccel);
	/#
		chopper util::debug_slow_heli_speed();
	#/
	goalpath = supplydropheliendpath_v2(chopper.origin);
	chopper airsupport::followpath(goalpath.path, undefined, 0);
	/#
		println("" + (gettime() - chopper.droptime));
	#/
	chopper notify(#"leaving");
	chopper delete();
}

/*
	Name: samturretwatcher
	Namespace: supplydrop
	Checksum: 0x48B3EB3E
	Offset: 0xC600
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function samturretwatcher(destination)
{
	self endon(#"leaving");
	self endon(#"helicopter_gone");
	self endon(#"death");
	sam_turret_aquire_dist = 1500;
	while(true)
	{
		if(distance(destination, self.origin) < sam_turret_aquire_dist)
		{
			break;
		}
		if(self.origin[0] > level.spawnmins[0] && self.origin[0] < level.spawnmaxs[0] && self.origin[1] > level.spawnmins[1] && self.origin[1] < level.spawnmaxs[1])
		{
			break;
		}
		wait(0.1);
	}
	target_setturretaquire(self, 1);
}

/*
	Name: speedregulator
	Namespace: supplydrop
	Checksum: 0xC72677ED
	Offset: 0xC720
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function speedregulator(goal)
{
	self endon(#"drop_goal");
	self endon(#"death");
	wait(3);
	supplydropspeed = getdvarint("scr_supplydropSpeed", 400);
	supplydropaccel = getdvarint("scr_supplydropAccel", 60);
	self setyawspeed(100, 60, 60);
	self setspeed(supplydropspeed, supplydropaccel);
	/#
		self util::debug_slow_heli_speed();
	#/
	wait(1);
	maxpitch = getdvarint("scr_supplydropMaxPitch", 25);
	maxroll = getdvarint("scr_supplydropMaxRoll", 35);
	self setmaxpitchroll(maxpitch, maxroll);
}

/*
	Name: helidropcrate
	Namespace: supplydrop
	Checksum: 0xC8C97A39
	Offset: 0xC870
	Size: 0x4D4
	Parameters: 7
	Flags: Linked
*/
function helidropcrate(killstreak, originalowner, offset, killcament, killstreak_id, package_contents_id, context)
{
	helicopter = self;
	originalowner endon(#"disconnect");
	crate = cratespawn(killstreak, killstreak_id, originalowner, self.team, self.origin, self.angles);
	if(killstreak == "inventory_supply_drop" || killstreak == "supply_drop")
	{
		loc_0000C9A0:
		crate linkto(helicopter, (isdefined(context.droptag) ? context.droptag : "tag_origin"), (isdefined(context.droptagoffset) ? context.droptagoffset : (0, 0, 0)));
		helicopter clientfield::set("supplydrop_care_package_state", 1);
	}
	else if(killstreak == "inventory_ai_tank_drop" || killstreak == "ai_tank_drop" || killstreak == "ai_tank_marker")
	{
		loc_0000CA60:
		crate linkto(helicopter, (isdefined(context.droptag) ? context.droptag : "tag_origin"), (isdefined(context.droptagoffset) ? context.droptagoffset : (0, 0, 0)));
		helicopter clientfield::set("supplydrop_ai_tank_state", 1);
	}
	team = self.team;
	helicopter waittill(#"drop_crate", origin, angles, chopperowner);
	if(isdefined(chopperowner))
	{
		owner = chopperowner;
		if(owner != originalowner)
		{
			crate killstreaks::configure_team(killstreak, owner);
			killstreaks::remove_ricochet_protection(killstreak_id, owner);
		}
	}
	else
	{
		owner = originalowner;
	}
	if(isdefined(self))
	{
		team = self.team;
		if(killstreak == "inventory_supply_drop" || killstreak == "supply_drop")
		{
			helicopter clientfield::set("supplydrop_care_package_state", 0);
		}
		else if(killstreak == "inventory_ai_tank_drop" || killstreak == "ai_tank_drop")
		{
			helicopter clientfield::set("supplydrop_ai_tank_state", 0);
		}
		enemy = helicopter.owner battlechatter::get_closest_player_enemy(helicopter.origin, 1);
		enemyradius = battlechatter::mpdialog_value("supplyDropRadius", 0);
		if(isdefined(enemy) && distance2dsquared(origin, enemy.origin) < (enemyradius * enemyradius))
		{
			enemy battlechatter::play_killstreak_threat(killstreak);
		}
	}
	if(team == owner.team)
	{
		rear_hatch_offset_height = getdvarint("scr_supplydropOffsetHeight", 200);
		rear_hatch_offset_world = rotatepoint((offset, 0, 0), angles);
		drop_origin = (origin - (0, 0, rear_hatch_offset_height)) - rear_hatch_offset_world;
		thread dropcrate(drop_origin, angles, killstreak, owner, team, killcament, killstreak_id, package_contents_id, crate, context);
	}
}

/*
	Name: helidestroyed
	Namespace: supplydrop
	Checksum: 0x1E44AA78
	Offset: 0xCD50
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function helidestroyed()
{
	self endon(#"leaving");
	self endon(#"helicopter_gone");
	self endon(#"death");
	while(true)
	{
		if(self.damagetaken > self.maxhealth)
		{
			break;
		}
		wait(0.05);
	}
	if(!isdefined(self))
	{
		return;
	}
	self setspeed(25, 5);
	self thread lbspin(randomintrange(180, 220));
	wait(randomfloatrange(0.5, 1.5));
	self notify(#"drop_crate", self.origin, self.angles, self.owner);
	lbexplode();
}

/*
	Name: lbexplode
	Namespace: supplydrop
	Checksum: 0xDADBD483
	Offset: 0xCE60
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function lbexplode()
{
	forward = (self.origin + (0, 0, 1)) - self.origin;
	playfx(level.chopper_fx["explode"]["death"], self.origin, forward);
	self playsound(level.heli_sound["crash"]);
	self notify(#"explode");
	if(isdefined(self.delete_after_destruction_wait_time))
	{
		self hide();
		self waitanddelete(self.delete_after_destruction_wait_time);
	}
	else
	{
		self delete();
	}
}

/*
	Name: lbspin
	Namespace: supplydrop
	Checksum: 0x4B6534FD
	Offset: 0xCF58
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function lbspin(speed)
{
	self endon(#"explode");
	playfxontag(level.chopper_fx["explode"]["large"], self, "tail_rotor_jnt");
	playfxontag(level.chopper_fx["fire"]["trail"]["large"], self, "tail_rotor_jnt");
	self setyawspeed(speed, speed, speed);
	while(isdefined(self))
	{
		self settargetyaw(self.angles[1] + (speed * 0.9));
		wait(1);
	}
}

/*
	Name: refcountdecchopper
	Namespace: supplydrop
	Checksum: 0x98D8B603
	Offset: 0xD050
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function refcountdecchopper(team, killstreak_id)
{
	self waittill(#"death");
	killstreakrules::killstreakstop("supply_drop", team, killstreak_id);
	self notify(#"cleanup_marker");
}

/*
	Name: supply_drop_dev_gui
	Namespace: supplydrop
	Checksum: 0x48101EBA
	Offset: 0xD0B0
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function supply_drop_dev_gui()
{
	/#
		setdvar("", "");
		while(true)
		{
			wait(0.5);
			devgui_string = getdvarstring("");
			level.dev_gui_supply_drop = devgui_string;
		}
	#/
}

