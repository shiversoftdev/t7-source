// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_apothican;
#using scripts\zm\zm_genesis_ee_quest;
#using scripts\zm\zm_genesis_portals;
#using scripts\zm\zm_genesis_sound;
#using scripts\zm\zm_genesis_util;

#namespace zm_genesis_minor_ee;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_minor_ee
	Checksum: 0xA11127F7
	Offset: 0x8B0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_minor_ee", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_minor_ee
	Checksum: 0x2C47C832
	Offset: 0x8F8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level flag::init("old_school_activated");
	level.func_override_wallbuy_prompt = &function_bc56f047;
}

/*
	Name: __main__
	Namespace: zm_genesis_minor_ee
	Checksum: 0x35A8E12C
	Offset: 0x940
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	/#
		if(getdvarint("") > 0)
		{
			level thread function_1d13619e();
		}
	#/
	level waittill(#"start_zombie_round_logic");
	if(getdvarint("splitscreen_playerCount") > 2)
	{
		return;
	}
	level thread lil_arnie_upgrade();
	level thread function_be8c2f38();
	level thread function_5af98f35();
	level thread function_45bc2e15();
	level thread function_92b4b156();
}

/*
	Name: function_45bc2e15
	Namespace: zm_genesis_minor_ee
	Checksum: 0xF9EA010F
	Offset: 0xA30
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_45bc2e15()
{
	level flag::init("writing_on_the_wall_complete");
}

/*
	Name: function_92b4b156
	Namespace: zm_genesis_minor_ee
	Checksum: 0x23A27E30
	Offset: 0xA60
	Size: 0x7C4
	Parameters: 0
	Flags: Linked
*/
function function_92b4b156()
{
	level flag::wait_till("writing_on_the_wall_complete");
	var_cb382f = struct::get("weapon_swapper_model", "targetname");
	var_cb382f.angles = vectorscale((0, 1, 0), 90);
	s_fx_pos = struct::get("weapon_swapper_fx", "targetname");
	v_fx_pos = s_fx_pos.origin;
	var_c59a59e1 = 0;
	var_3bb6997f = undefined;
	var_81f963f4 = spawn("trigger_radius_use", var_cb382f.origin, 0, 100, 100);
	var_81f963f4 sethintstring("");
	var_81f963f4 setcursorhint("HINT_NOICON");
	var_81f963f4 triggerignoreteam();
	var_81f963f4 usetriggerrequirelookat();
	exploder::exploder("fxexp_114 ");
	while(true)
	{
		switch(var_c59a59e1)
		{
			case 0:
			{
				var_81f963f4 waittill(#"trigger", trigplayer);
				if(isplayer(trigplayer) && !trigplayer laststand::player_is_in_laststand() && !(trigplayer.is_drinking > 0))
				{
					var_3bb6997f = trigplayer getcurrentweapon();
					if(!trigplayer hasweapon(var_3bb6997f))
					{
						continue;
					}
					b_valid_weapon = trigplayer function_a5a542a(var_3bb6997f, var_c59a59e1);
					if(!b_valid_weapon)
					{
						continue;
					}
					/#
						iprintlnbold("");
					#/
					var_f17eaf0 = trigplayer getweaponammostock(var_3bb6997f);
					var_5b3694f6 = trigplayer getweaponammoclip(var_3bb6997f);
					var_be26f631 = trigplayer getweaponammoclip(var_3bb6997f.dualwieldweapon);
					var_c02edaaf = trigplayer getbuildkitweaponoptions(var_3bb6997f);
					var_5c2e5267 = trigplayer getbuildkitattachmentcosmeticvariantindexes(var_3bb6997f);
					trigplayer takeweapon(var_3bb6997f);
					trigplayer zm_weapons::switch_back_primary_weapon(undefined);
					var_c59a59e1 = 1;
					var_81f963f4 sethintstring("");
					if(isdefined(trigplayer.var_fb11234e) && trigplayer.var_fb11234e == zm_weapons::get_base_weapon(var_3bb6997f))
					{
						var_3bb6997f = trigplayer.var_fb11234e;
					}
					level.var_3bb6997f = var_3bb6997f;
					e_model = zm_utility::spawn_buildkit_weapon_model(trigplayer, var_3bb6997f, undefined, var_cb382f.origin, var_cb382f.angles);
					if(var_3bb6997f.isdualwield)
					{
						var_1166f70b = var_3bb6997f;
						if(isdefined(var_3bb6997f.dualwieldweapon) && var_3bb6997f.dualwieldweapon != level.weaponnone)
						{
							var_1166f70b = var_3bb6997f.dualwieldweapon;
						}
						var_624e83a3 = zm_utility::spawn_buildkit_weapon_model(trigplayer, var_1166f70b, undefined, var_cb382f.origin - vectorscale((1, 1, 1), 3), var_cb382f.angles);
					}
				}
				break;
			}
			case 1:
			{
				e_model rotateroll(360, 1);
				if(isdefined(var_624e83a3))
				{
					var_624e83a3 rotateroll(360, 1);
				}
				wait(1);
				var_c59a59e1 = 2;
				var_81f963f4 sethintstring("");
				break;
			}
			case 2:
			{
				var_81f963f4 waittill(#"trigger", trigplayer);
				if(isplayer(trigplayer) && !trigplayer laststand::player_is_in_laststand() && !(trigplayer.is_drinking > 0))
				{
					b_valid_weapon = trigplayer function_a5a542a(var_3bb6997f, var_c59a59e1);
					if(!b_valid_weapon)
					{
						continue;
					}
					/#
						iprintlnbold("");
					#/
					weapon_limit = zm_utility::get_player_weapon_limit(trigplayer);
					trigplayer zm_weapons::weapon_give(var_3bb6997f);
					trigplayer setweaponammostock(var_3bb6997f, var_f17eaf0);
					trigplayer setweaponammoclip(var_3bb6997f, var_5b3694f6);
					trigplayer setweaponammoclip(var_3bb6997f.dualwieldweapon, var_be26f631);
					level.var_3bb6997f = undefined;
					var_c59a59e1 = 3;
					var_81f963f4 sethintstring("");
					e_model delete();
					if(isdefined(var_624e83a3))
					{
						var_624e83a3 delete();
					}
				}
				break;
			}
			case 3:
			{
				wait(1);
				var_c59a59e1 = 0;
				var_81f963f4 sethintstring("");
				break;
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_a5a542a
	Namespace: zm_genesis_minor_ee
	Checksum: 0x22C6A9F2
	Offset: 0x1230
	Size: 0x11E
	Parameters: 2
	Flags: Linked
*/
function function_a5a542a(var_3bb6997f, var_c59a59e1)
{
	if(self bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		return false;
	}
	if(zm_utility::is_hero_weapon(var_3bb6997f))
	{
		return false;
	}
	if(zm_equipment::is_equipment(var_3bb6997f))
	{
		return false;
	}
	if(zm_utility::is_placeable_mine(var_3bb6997f))
	{
		return false;
	}
	if(self zm_utility::has_powerup_weapon())
	{
		return false;
	}
	var_26e1938e = self getweaponslistprimaries();
	if(var_c59a59e1 == 0 && var_26e1938e.size < 2)
	{
		return false;
	}
	if(var_c59a59e1 == 2 && self zm_weapons::has_weapon_or_upgrade(var_3bb6997f))
	{
		return false;
	}
	return true;
}

/*
	Name: function_5af98f35
	Namespace: zm_genesis_minor_ee
	Checksum: 0xA01B2E30
	Offset: 0x1358
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_5af98f35()
{
	var_38d3be2e = getent("smg_thompson_wallbuy_chalk", "targetname");
	var_38d3be2e hide();
	level chalk_pickup();
	level thread function_ff9395ca();
}

/*
	Name: function_e1963311
	Namespace: zm_genesis_minor_ee
	Checksum: 0x2D353F26
	Offset: 0x13D8
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function function_e1963311()
{
	/#
		var_5dfe3e = getent("", "");
		if(!isdefined(var_5dfe3e))
		{
			return;
		}
		var_5dfe3e delete();
		iprintln("");
		e_who = getplayers()[0];
		e_who.var_fb4f9b70 = 1;
		level.var_6d7c54f9 = "";
		level notify(#"hash_94556ac9");
	#/
}

/*
	Name: chalk_pickup
	Namespace: zm_genesis_minor_ee
	Checksum: 0xCCF2985E
	Offset: 0x14B0
	Size: 0x13E
	Parameters: 0
	Flags: Linked
*/
function chalk_pickup()
{
	level endon(#"hash_94556ac9");
	var_6fdae6db = struct::get("chalk_pickup", "targetname");
	var_6fdae6db zm_unitrigger::create_unitrigger(undefined, 128);
	var_6fdae6db waittill(#"trigger_activated", e_who);
	e_who playsound("zmb_minor_writing_chalk_pickup");
	var_5dfe3e = getent("chalk_model", "targetname");
	var_5dfe3e ghost();
	/#
		iprintln("");
	#/
	e_who.var_fb4f9b70 = 1;
	e_who thread function_7367d2c6();
	if(!isdefined(level.var_6d7c54f9))
	{
		level.var_6d7c54f9 = "tag_origin";
	}
	level notify(#"hash_94556ac9");
}

/*
	Name: function_7367d2c6
	Namespace: zm_genesis_minor_ee
	Checksum: 0xC51594BD
	Offset: 0x15F8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_7367d2c6()
{
	level endon(#"writing_on_the_wall_complete");
	self waittill(#"disconnect");
	var_5dfe3e = getent("chalk_model", "targetname");
	var_5dfe3e show();
	level thread chalk_pickup();
}

/*
	Name: function_ff9395ca
	Namespace: zm_genesis_minor_ee
	Checksum: 0x50106055
	Offset: 0x1678
	Size: 0x112
	Parameters: 0
	Flags: Linked
*/
function function_ff9395ca()
{
	level.var_61d84403 = [];
	var_eb751e53 = struct::get_array("writing_trigger", "targetname");
	foreach(var_2ac294d8 in var_eb751e53)
	{
		var_3cbdaba3 = getent(var_2ac294d8.target, "targetname");
		array::add(level.var_61d84403, var_3cbdaba3);
		var_2ac294d8 thread function_a8fc7a77();
	}
}

/*
	Name: function_a8fc7a77
	Namespace: zm_genesis_minor_ee
	Checksum: 0x9BAE78F8
	Offset: 0x1798
	Size: 0x150
	Parameters: 0
	Flags: Linked
*/
function function_a8fc7a77()
{
	level endon(#"writing_on_the_wall_complete");
	self zm_unitrigger::create_unitrigger(undefined, 128);
	var_3cbdaba3 = getent(self.target, "targetname");
	while(true)
	{
		self waittill(#"trigger_activated", e_player);
		if(isdefined(e_player.var_fb4f9b70) && e_player.var_fb4f9b70)
		{
			var_5d3ba118 = level.var_6d7c54f9;
			if(level.var_6d7c54f9 == "tag_origin")
			{
				e_player playsound("zmb_minor_writing_erase");
			}
			else
			{
				e_player playsound("zmb_minor_writing_write");
			}
			level.var_6d7c54f9 = var_3cbdaba3.model;
			var_3cbdaba3 setmodel(var_5d3ba118);
			level thread function_d0f8a867();
		}
	}
}

/*
	Name: function_d0f8a867
	Namespace: zm_genesis_minor_ee
	Checksum: 0xC1F232A2
	Offset: 0x18F0
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function function_d0f8a867()
{
	b_complete = 1;
	foreach(var_3cbdaba3 in level.var_61d84403)
	{
		switch(var_3cbdaba3.targetname)
		{
			case "verruckt_writing":
			{
				if(var_3cbdaba3.model != "p7_zm_gen_writing_ver_wishing")
				{
					b_complete = 0;
				}
				break;
			}
			case "ndu_writing_1":
			{
				if(var_3cbdaba3.model != "p7_zm_gen_writing_nac_salvation")
				{
					b_complete = 0;
				}
				break;
			}
			case "ndu_writing_2":
			{
				if(var_3cbdaba3.model != "p7_zm_gen_writing_nac_ascend")
				{
					b_complete = 0;
				}
				break;
			}
			case "undercroft_writing":
			{
				if(var_3cbdaba3.model != "tag_origin")
				{
					b_complete = 0;
				}
				break;
			}
			case "prison_writing":
			{
				if(var_3cbdaba3.model != "p7_zm_gen_writing_mob_soul_alone")
				{
					b_complete = 0;
				}
				break;
			}
			case "theatre_writing":
			{
				if(var_3cbdaba3.model != "p7_zm_gen_writing_kin_scrawl_know")
				{
					b_complete = 0;
				}
				break;
			}
		}
	}
	if(b_complete)
	{
		playsoundatposition("zmb_minor_complete", (0, 0, 0));
		level flag::set("writing_on_the_wall_complete");
		var_38d3be2e = getent("smg_thompson_wallbuy_chalk", "targetname");
		var_38d3be2e show();
	}
}

/*
	Name: function_bc56f047
	Namespace: zm_genesis_minor_ee
	Checksum: 0xB3DEC32
	Offset: 0x1B40
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function function_bc56f047(e_player)
{
	if(self.weapon.name == "smg_thompson")
	{
		if(level flag::get("writing_on_the_wall_complete"))
		{
			return true;
		}
		self.stub.hint_string = "";
		self sethintstring("");
		self.stub.cursor_hint = "HINT_NOICON";
		self setcursorhint("HINT_NOICON");
		return false;
	}
	return true;
}

/*
	Name: lil_arnie_upgrade
	Namespace: zm_genesis_minor_ee
	Checksum: 0x855B2FD
	Offset: 0x1C10
	Size: 0x208
	Parameters: 0
	Flags: Linked
*/
function lil_arnie_upgrade()
{
	level.var_f11300cd = 0;
	level flag::init("lil_arnie_prereq_done");
	level flag::init("lil_arnie_done");
	/#
		if(getdvarint("") > 0)
		{
			level.var_f11300cd = 99;
		}
	#/
	zm_spawner::register_zombie_death_event_callback(&function_4a0f0038);
	level flag::wait_till("lil_arnie_prereq_done");
	zm_spawner::deregister_zombie_death_event_callback(&function_4a0f0038);
	level.check_b_valid_poi = &zm_genesis_ee_quest::function_5516baeb;
	level flag::wait_till("lil_arnie_done");
	foreach(player in level.activeplayers)
	{
		if(player hasweapon(level.w_octobomb))
		{
			player _zm_weap_octobomb::player_give_octobomb("octobomb_upgraded");
		}
	}
	level.zombie_weapons[level.w_octobomb].is_in_box = 0;
	level.zombie_weapons[level.w_octobomb_upgraded].is_in_box = 1;
}

/*
	Name: function_4a0f0038
	Namespace: zm_genesis_minor_ee
	Checksum: 0x2EBF350C
	Offset: 0x1E20
	Size: 0x76
	Parameters: 3
	Flags: Linked
*/
function function_4a0f0038(e_attacker, str_means_of_death, weapon)
{
	if(self.damageweapon === level.w_octobomb)
	{
		level.var_f11300cd++;
		if(level.var_f11300cd >= 100)
		{
			level flag::set("lil_arnie_prereq_done");
		}
	}
}

/*
	Name: function_131a352c
	Namespace: zm_genesis_minor_ee
	Checksum: 0x6FEE95CB
	Offset: 0x1EA0
	Size: 0x1A8
	Parameters: 1
	Flags: Linked
*/
function function_131a352c(b_valid_poi)
{
	s_target = struct::get("lil_arnie_upgrade", "targetname");
	if(distancesquared(self.origin, s_target.origin) < 7225)
	{
		self.origin = s_target.origin;
		self.angles = self.angles + vectorscale((1, 0, 1), 90);
		self.clone_model ghost();
		self.anim_model = util::spawn_model(level.mdl_octobomb, self.origin, (0, 0, 0));
		self.anim_model linkto(self.clone_model);
		self.anim_model clientfield::set("octobomb_fx", 3);
		wait(0.05);
		self.anim_model clientfield::set("octobomb_fx", 1);
		self thread _zm_weap_octobomb::animate_octobomb(0);
		wait(2);
		self.anim_model thread function_bf3603f7();
		return 0;
	}
	return b_valid_poi;
}

/*
	Name: function_bf3603f7
	Namespace: zm_genesis_minor_ee
	Checksum: 0x9E6A6B9D
	Offset: 0x2058
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_bf3603f7()
{
	wait(1);
	self zm_utility::self_delete();
	level flag::set("lil_arnie_done");
}

/*
	Name: function_be8c2f38
	Namespace: zm_genesis_minor_ee
	Checksum: 0x4B7270AF
	Offset: 0x20A0
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_be8c2f38()
{
	level.var_aa421b74 = [];
	level.var_557b53fd = [];
	level.var_557b53fd[1] = 25;
	level.var_557b53fd[2] = 15;
	level.var_557b53fd[3] = 12;
	level.var_557b53fd[4] = 2;
	level.var_8091d507 = 0;
	var_9bafc533 = struct::get_array("old_school_switch");
	array::thread_all(var_9bafc533, &function_6e14903b);
	while(level.var_8091d507 < var_9bafc533.size)
	{
		wait(0.05);
	}
	level thread function_77da8ee0();
}

/*
	Name: function_6e14903b
	Namespace: zm_genesis_minor_ee
	Checksum: 0x4A3B90CF
	Offset: 0x21A0
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_6e14903b()
{
	level endon(#"old_school_activated");
	level.var_c592ecc1 = 0;
	s_unitrigger = self zm_unitrigger::create_unitrigger(&"", 64, &function_b2869a31);
	s_unitrigger.require_look_at = 1;
	s_unitrigger.b_enabled = 1;
	array::add(level.var_aa421b74, s_unitrigger);
	while(true)
	{
		self waittill(#"trigger_activated", e_player);
		if(s_unitrigger.b_enabled == 1)
		{
			playsoundatposition("zmb_minor_skool_button", s_unitrigger.origin);
			if(level.var_c592ecc1 == 0)
			{
				level thread function_2d1b88ec();
				level.var_c592ecc1 = 1;
			}
			s_unitrigger.b_enabled = 0;
			level.var_8091d507++;
		}
	}
}

/*
	Name: function_b2869a31
	Namespace: zm_genesis_minor_ee
	Checksum: 0x6579764F
	Offset: 0x22F0
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_b2869a31(e_player)
{
	if(self.stub.b_enabled)
	{
		foreach(e_player in level.players)
		{
			self setvisibletoplayer(e_player);
		}
		return true;
	}
	foreach(e_player in level.players)
	{
		self setinvisibletoplayer(e_player);
	}
	return false;
}

/*
	Name: function_2d1b88ec
	Namespace: zm_genesis_minor_ee
	Checksum: 0x815C4915
	Offset: 0x2428
	Size: 0xD2
	Parameters: 0
	Flags: Linked
*/
function function_2d1b88ec()
{
	level endon(#"hash_b442f53");
	level endon(#"old_school_activated");
	wait(level.var_557b53fd[level.players.size]);
	level.var_c592ecc1 = 0;
	level.var_8091d507 = 0;
	foreach(s_unitrigger in level.var_aa421b74)
	{
		s_unitrigger.b_enabled = 1;
	}
	level notify(#"hash_b442f53");
}

/*
	Name: function_77da8ee0
	Namespace: zm_genesis_minor_ee
	Checksum: 0xB1EFB21
	Offset: 0x2508
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_77da8ee0()
{
	level flag::set("old_school_activated");
	playsoundatposition("zmb_minor_skool_complete", (0, 0, 0));
	foreach(s_unitrigger in level.var_aa421b74)
	{
		s_unitrigger.b_enabled = 0;
	}
	level thread zm_genesis_sound::function_b18c11d8();
}

/*
	Name: function_a1f4f500
	Namespace: zm_genesis_minor_ee
	Checksum: 0xCDFCE9A0
	Offset: 0x25F0
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function function_a1f4f500()
{
	level._bouncingbettywatchfortrigger = &function_82df6cd4;
	level thread function_f227a0ab();
}

/*
	Name: function_f227a0ab
	Namespace: zm_genesis_minor_ee
	Checksum: 0x99EC1590
	Offset: 0x2630
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_f227a0ab()
{
}

/*
	Name: function_c1ccaae0
	Namespace: zm_genesis_minor_ee
	Checksum: 0xA19B757A
	Offset: 0x2640
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function function_c1ccaae0()
{
	var_11f2bc16 = getent("gateworm_asteroid", "targetname");
	var_62ceb838 = util::spawn_model("gateworm", var_11f2bc16.origin);
	var_11f2bc16 delete();
	var_2b641c49 = struct::get("egg_destination", "targetname");
	var_62ceb838 moveto(var_2b641c49.origin, 3);
	var_62ceb838 waittill(#"movedone");
	var_6d268157 = var_2b641c49 zm_unitrigger::create_unitrigger(undefined, 64);
	while(true)
	{
		var_2b641c49 waittill(#"trigger_activated", e_who);
		if(!e_who flag::get("holding_egg"))
		{
			break;
		}
	}
	e_who.var_7f70ccd5 = 1;
	zm_unitrigger::unregister_unitrigger(var_6d268157);
	var_62ceb838 delete();
	level thread function_ee1274a2();
}

/*
	Name: function_ee1274a2
	Namespace: zm_genesis_minor_ee
	Checksum: 0xC15CB84B
	Offset: 0x27E0
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function function_ee1274a2()
{
	var_9c1e0e1a = struct::get("pot_trigger", "targetname");
	var_a0069a05 = var_9c1e0e1a zm_unitrigger::create_unitrigger(undefined, 64);
	while(true)
	{
		var_9c1e0e1a waittill(#"trigger_activated", e_who);
		if(isdefined(e_who.var_7f70ccd5) && e_who.var_7f70ccd5)
		{
			break;
		}
	}
	var_ed0817e0 = struct::get("egg_pot_location", "targetname");
	var_62ceb838 = util::spawn_model("gateworm", var_ed0817e0.origin);
	level waittill(#"start_of_round");
	level waittill(#"start_of_round");
	level waittill(#"start_of_round");
	while(true)
	{
		var_9c1e0e1a waittill(#"trigger_activated", e_who);
		if(isdefined(e_who.var_7f70ccd5) && e_who.var_7f70ccd5)
		{
			break;
		}
	}
	zm_unitrigger::unregister_unitrigger(var_a0069a05);
	level thread function_16401ba8();
}

/*
	Name: function_16401ba8
	Namespace: zm_genesis_minor_ee
	Checksum: 0x99EC1590
	Offset: 0x2988
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_16401ba8()
{
}

/*
	Name: function_82df6cd4
	Namespace: zm_genesis_minor_ee
	Checksum: 0x7C5BB7A2
	Offset: 0x2998
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_82df6cd4(watcher)
{
	self endon(#"death");
	self endon(#"hacked");
	self endon(#"kill_target_detection");
	e_trigger = getent("gateworm_meteor_trigger", "targetname");
	while(true)
	{
		if(self istouching(e_trigger))
		{
			break;
		}
		wait(0.05);
	}
	level thread function_c1ccaae0();
}

/*
	Name: function_1d13619e
	Namespace: zm_genesis_minor_ee
	Checksum: 0x6ADDE37A
	Offset: 0x2A48
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_1d13619e()
{
	/#
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_6cd2074);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_7c5650a5);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_c3100cb0);
		level thread zm_genesis_util::setup_devgui_func("", "", 1, &function_e1963311);
	#/
}

/*
	Name: function_7c5650a5
	Namespace: zm_genesis_minor_ee
	Checksum: 0x11782362
	Offset: 0x2B40
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_7c5650a5(n_val)
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_6cd2074
	Namespace: zm_genesis_minor_ee
	Checksum: 0xF6CE8395
	Offset: 0x2B78
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_6cd2074(n_val)
{
	/#
		level thread function_77da8ee0();
	#/
}

/*
	Name: function_c3100cb0
	Namespace: zm_genesis_minor_ee
	Checksum: 0x696291AE
	Offset: 0x2BA8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_c3100cb0(n_val)
{
	/#
		level flag::set("");
	#/
}

