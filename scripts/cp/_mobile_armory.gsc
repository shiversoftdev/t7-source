// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_bb;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_save;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;

class cmobilearmory 
{
	var gameobject;
	var target;
	var var_ab455203;
	var var_3df2554f;

	/*
		Name: constructor
		Namespace: cmobilearmory
		Checksum: 0x99EC1590
		Offset: 0x748
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: cmobilearmory
		Checksum: 0x99EC1590
		Offset: 0x758
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: function_71f6269a
		Namespace: cmobilearmory
		Checksum: 0x41601D6A
		Offset: 0x1C48
		Size: 0xCC
		Parameters: 1
		Flags: Linked
	*/
	function function_71f6269a(var_bd13c94b)
	{
		self waittill(#"death");
		gameobject gameobjects::destroy_object(1);
		gameobject delete();
		if(isdefined(target))
		{
			var_5ba2ceb4 = getent(target, "targetname");
			if(isdefined(var_5ba2ceb4))
			{
				var_5ba2ceb4 delete();
			}
		}
		if(isdefined(var_bd13c94b))
		{
			var_bd13c94b delete();
		}
	}

	/*
		Name: function_69cca2a0
		Namespace: cmobilearmory
		Checksum: 0x6F2CD033
		Offset: 0x19B8
		Size: 0x284
		Parameters: 1
		Flags: Linked
	*/
	function function_69cca2a0(var_ab455203)
	{
		if(var_ab455203.var_ce22f999)
		{
			return;
		}
		var_ab455203.var_ce22f999 = 1;
		var_ab455203 showpart("tag_weapons_01_jnt");
		var_ab455203 showpart("tag_weapons_02_jnt");
		var_ab455203 showpart("tag_weapons_03_jnt");
		var_ab455203 showpart("tag_weapons_04_jnt");
		var_ab455203 scene::play("p7_fxanim_gp_mobile_armory_open_bundle", var_ab455203);
		wait(1);
		var_d3571721 = 1;
		while(var_d3571721 > 0)
		{
			var_d3571721 = 0;
			foreach(e_player in level.players)
			{
				dist_sq = distancesquared(e_player.origin, var_ab455203.origin);
				if(dist_sq <= 15400)
				{
					var_d3571721++;
				}
			}
			wait(0.5);
		}
		var_ab455203 scene::play("p7_fxanim_gp_mobile_armory_close_bundle", var_ab455203);
		var_ab455203 hidepart("tag_weapons_01_jnt");
		var_ab455203 hidepart("tag_weapons_02_jnt");
		var_ab455203 hidepart("tag_weapons_03_jnt");
		var_ab455203 hidepart("tag_weapons_04_jnt");
		var_ab455203.var_ce22f999 = 0;
	}

	/*
		Name: function_e76edd0b
		Namespace: cmobilearmory
		Checksum: 0x958274B8
		Offset: 0x1928
		Size: 0x88
		Parameters: 1
		Flags: Linked
	*/
	function function_e76edd0b(var_ab455203)
	{
		self endon(#"death");
		var_ab455203 endon(#"death");
		while(true)
		{
			self waittill(#"trigger", entity);
			if(!isdefined(var_ab455203))
			{
				break;
			}
			if(isplayer(entity))
			{
				function_69cca2a0(var_ab455203);
			}
		}
	}

	/*
		Name: function_6b1fa4df
		Namespace: cmobilearmory
		Checksum: 0xA5AC5582
		Offset: 0x17A8
		Size: 0x174
		Parameters: 1
		Flags: Linked
	*/
	function function_6b1fa4df(weapon)
	{
		clipammo = self getweaponammoclip(weapon);
		stockammo = self getweaponammostock(weapon);
		stockmax = weapon.maxammo;
		if(stockammo > stockmax)
		{
			stockammo = stockmax;
		}
		item = self dropitem(weapon, "tag_origin");
		if(!isdefined(item))
		{
			/#
				iprintlnbold(("" + weapon.name) + "");
			#/
			return;
		}
		level weapons::drop_limited_weapon(weapon, self, item);
		item itemweaponsetammo(clipammo, stockammo);
		item.owner = self;
		item thread weapons::watch_pickup();
		item thread weapons::delete_pickup_after_awhile();
	}

	/*
		Name: function_afd39ac7
		Namespace: cmobilearmory
		Checksum: 0x90B7FA8A
		Offset: 0x1730
		Size: 0x6E
		Parameters: 1
		Flags: Linked
	*/
	function function_afd39ac7(e_player)
	{
		var_ab455203.gameobject.caninteractwithplayer = &function_66708329;
		var_ab455203.gameobject.var_3df2554f = e_player;
		wait(0.25);
		var_ab455203.gameobject.caninteractwithplayer = undefined;
	}

	/*
		Name: function_66708329
		Namespace: cmobilearmory
		Checksum: 0x9ADEB507
		Offset: 0x1700
		Size: 0x24
		Parameters: 1
		Flags: Linked
	*/
	function function_66708329(e_player)
	{
		if(var_3df2554f === e_player)
		{
			return false;
		}
		return true;
	}

	/*
		Name: function_ecdbdfeb
		Namespace: cmobilearmory
		Checksum: 0x2B3EAF8D
		Offset: 0xD60
		Size: 0x994
		Parameters: 1
		Flags: Linked
	*/
	function function_ecdbdfeb(e_player)
	{
		e_player endon(#"death");
		e_player endon(#"entering_last_stand");
		e_player flagsys::clear("mobile_armory_begin_use");
		var_9cba4a73 = 1;
		if(isdefined(var_ab455203.script_int))
		{
			var_9cba4a73 = 3;
			var_9cba4a73 = var_9cba4a73 + ((var_ab455203.script_int - 6) << 2);
		}
		e_player clientfield::set_to_player("mobile_armory_cac", var_9cba4a73);
		e_player flagsys::set("mobile_armory_in_use");
		var_eb5bcea7 = e_player getloadoutitemref(0, "cybercore");
		e_player waittill(#"menuresponse", str_menu, response);
		a_weaponlist = e_player getweaponslist();
		var_5b2a650 = e_player getloadoutweapon(e_player.class_num, "primary");
		var_95cf88cc = e_player getloadoutweapon(e_player.class_num, "secondary");
		a_heroweapons = [];
		foreach(weapon in a_weaponlist)
		{
			if(isdefined(weapon.isheroweapon) && weapon.isheroweapon)
			{
				if(!isdefined(a_heroweapons))
				{
					a_heroweapons = [];
				}
				else if(!isarray(a_heroweapons))
				{
					a_heroweapons = array(a_heroweapons);
				}
				a_heroweapons[a_heroweapons.size] = weapon;
				continue;
			}
			if(e_player hascybercomrig("cybercom_copycat") && (weapon.inventorytype == "primary" || weapon.inventorytype == "secondary") && (weapon != var_5b2a650 && weapon != var_95cf88cc))
			{
				/#
					iprintln("");
				#/
				if(response != "cancel")
				{
					e_player function_6b1fa4df(weapon);
				}
			}
		}
		if(str_menu == "ChooseClass_InGame")
		{
			var_d3a640a8 = e_player getloadoutitemref(0, "cybercore");
			var_63a103f4 = var_d3a640a8 == var_eb5bcea7 || e_player cybercom::function_6e0bf068();
			e_player savegame::set_player_data("lives", undefined);
			if(response == "cancel")
			{
				e_player loadout::function_db96b564(!(isdefined(var_63a103f4) && var_63a103f4));
			}
			else
			{
				responsearray = strtok(response, ",");
				if(responsearray.size > 1)
				{
					str_class_chosen = responsearray[0];
					clientnum = int(responsearray[1]);
					altplayer = util::getplayerfromclientnum(clientnum);
				}
				else
				{
					str_class_chosen = response;
				}
				playerclass = e_player loadout::getclasschoice(str_class_chosen);
				e_player savegame::set_player_data("playerClass", playerclass);
				if(isdefined(altplayer))
				{
					xuid = altplayer getxuid();
					e_player savegame::set_player_data("altPlayerID", xuid);
				}
				else
				{
					e_player savegame::set_player_data("altPlayerID", undefined);
				}
				e_player savegame::set_player_data("saved_weapon", undefined);
				e_player savegame::set_player_data("saved_weapondata", undefined);
				e_player savegame::set_player_data("saved_rig1", undefined);
				e_player savegame::set_player_data("saved_rig1_upgraded", undefined);
				e_player savegame::set_player_data("saved_rig2", undefined);
				e_player savegame::set_player_data("saved_rig2_upgraded", undefined);
				e_player loadout::setclass(playerclass);
				e_player.tag_stowed_back = undefined;
				e_player.tag_stowed_hip = undefined;
				e_player loadout::giveloadout(e_player.pers["team"], playerclass, !(isdefined(var_63a103f4) && var_63a103f4), altplayer);
			}
		}
		foreach(weapon in a_heroweapons)
		{
			e_player giveweapon(weapon);
		}
		a_weapons = e_player getweaponslist();
		foreach(weapon in a_weapons)
		{
			e_player givemaxammo(weapon);
			e_player setweaponammoclip(weapon, weapon.clipsize);
		}
		if(e_player flagsys::get("cancel_mobile_armory"))
		{
			e_player flagsys::clear("cancel_mobile_armory");
			e_player util::_enableweapon();
		}
		else
		{
			self thread function_afd39ac7(e_player);
			e_player hideviewmodel();
			e_player disableweapons(1);
			wait(0.5);
			e_player showviewmodel();
			e_player util::_enableweapon();
		}
		e_player clientfield::set_to_player("mobile_armory_cac", 0);
		bb::logplayermapnotification("mobile_armory_used", e_player);
		e_player matchrecordincrementcheckpointstat(skipto::function_52c50cb8(), "mobileArmoryUsedCount");
		waittillframeend();
		e_player flagsys::clear("mobile_armory_in_use");
	}

	/*
		Name: onuse
		Namespace: cmobilearmory
		Checksum: 0xD34DBD72
		Offset: 0xD30
		Size: 0x24
		Parameters: 1
		Flags: Linked
	*/
	function onuse(e_player)
	{
		self thread function_ecdbdfeb(e_player);
	}

	/*
		Name: onenduse
		Namespace: cmobilearmory
		Checksum: 0x5C5F10D9
		Offset: 0xCE8
		Size: 0x3C
		Parameters: 3
		Flags: Linked
	*/
	function onenduse(team, e_player, b_result)
	{
		if(!b_result)
		{
			e_player util::_enableweapon();
		}
	}

	/*
		Name: onbeginuse
		Namespace: cmobilearmory
		Checksum: 0x7389B2E6
		Offset: 0xC78
		Size: 0x64
		Parameters: 1
		Flags: Linked
	*/
	function onbeginuse(e_player)
	{
		e_player playsound("fly_ammo_crate_refill");
		e_player util::_disableweapon();
		e_player flagsys::set("mobile_armory_begin_use");
	}

	/*
		Name: init_mobile_armory
		Namespace: cmobilearmory
		Checksum: 0x50923CCC
		Offset: 0x768
		Size: 0x504
		Parameters: 1
		Flags: Linked
	*/
	function init_mobile_armory(mdl_mobile_armory)
	{
		t_use = spawn("trigger_radius_use", mdl_mobile_armory.origin + vectorscale((0, 0, 1), 24), 0, 94, 64);
		t_use triggerignoreteam();
		t_use setvisibletoall();
		t_use usetriggerrequirelookat();
		t_use setteamfortrigger("none");
		t_use setcursorhint("HINT_INTERACTIVE_PROMPT");
		t_use sethintstring(&"COOP_SELECT_LOADOUT");
		if(isdefined(mdl_mobile_armory.script_linkto))
		{
			moving_platform = getent(mdl_mobile_armory.script_linkto, "targetname");
			mdl_mobile_armory linkto(moving_platform);
			t_use enablelinkto();
			t_use linkto(moving_platform);
		}
		mdl_mobile_armory oed::enable_keyline(1);
		mdl_mobile_armory hidepart("tag_weapons_01_jnt");
		mdl_mobile_armory hidepart("tag_weapons_02_jnt");
		mdl_mobile_armory hidepart("tag_weapons_03_jnt");
		mdl_mobile_armory hidepart("tag_weapons_04_jnt");
		s_mobile_armory_object = gameobjects::create_use_object("any", t_use, array(mdl_mobile_armory), vectorscale((0, 0, 1), 68), &"cp_mobile_armory");
		s_mobile_armory_object gameobjects::allow_use("any");
		s_mobile_armory_object gameobjects::set_use_time(0.35);
		s_mobile_armory_object gameobjects::set_use_text(&"COOP_SELECT_LOADOUT");
		s_mobile_armory_object gameobjects::set_owner_team("allies");
		s_mobile_armory_object gameobjects::set_visible_team("any");
		s_mobile_armory_object.onuse = &onuse;
		s_mobile_armory_object.onbeginuse = &onbeginuse;
		s_mobile_armory_object.onenduse = &onenduse;
		s_mobile_armory_object.onuse_thread = 1;
		s_mobile_armory_object.useweapon = undefined;
		s_mobile_armory_object.single_use = 0;
		s_mobile_armory_object.classobj = self;
		s_mobile_armory_object.origin = mdl_mobile_armory.origin;
		s_mobile_armory_object.angles = s_mobile_armory_object.angles;
		if(!isdefined(mdl_mobile_armory.script_linkto))
		{
			s_mobile_armory_object enablelinkto();
			s_mobile_armory_object linkto(t_use);
		}
		mdl_mobile_armory.gameobject = s_mobile_armory_object;
		var_ab455203 = mdl_mobile_armory;
		var_ab455203.var_ce22f999 = 0;
		var_bd13c94b = spawn("trigger_radius", t_use.origin, 0, 94, 64);
		var_bd13c94b setvisibletoall();
		var_bd13c94b setteamfortrigger("allies");
		var_bd13c94b thread function_e76edd0b(var_ab455203);
		var_ab455203 thread function_71f6269a(var_bd13c94b);
	}

}

#namespace mobile_armory;

/*
	Name: __init__sytem__
	Namespace: mobile_armory
	Checksum: 0x6A74FB30
	Offset: 0x5A0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("cp_mobile_armory", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: mobile_armory
	Checksum: 0x811C6AA6
	Offset: 0x5E8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "mobile_armory_cac", 1, 4, "int");
}

/*
	Name: __main__
	Namespace: mobile_armory
	Checksum: 0x97DB59A0
	Offset: 0x628
	Size: 0x112
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	if(sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	if(isdefined(level.var_40b3237f))
	{
		[[level.var_40b3237f]]();
	}
	wait(0.05);
	a_mdl_mobile_armory = getentarray("mobile_armory", "script_noteworthy");
	foreach(mdl_mobile_armory in a_mdl_mobile_armory)
	{
		mobile_armory = new cmobilearmory();
		[[ mobile_armory ]]->init_mobile_armory(mdl_mobile_armory);
	}
}

