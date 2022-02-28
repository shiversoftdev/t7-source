// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_accolades;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace namespace_b5b83650;

/*
	Name: function_4d39a2af
	Namespace: namespace_b5b83650
	Checksum: 0x345984B
	Offset: 0x5B0
	Size: 0x294
	Parameters: 0
	Flags: Linked
*/
function function_4d39a2af()
{
	accolades::register("MISSION_AQUIFER_UNTOUCHED");
	accolades::register("MISSION_AQUIFER_SCORE");
	accolades::register("MISSION_AQUIFER_COLLECTIBLE");
	accolades::register("MISSION_AQUIFER_CHALLENGE3", "aq_thirty_kill_vtol");
	accolades::register("MISSION_AQUIFER_CHALLENGE4", "aq_three_hunters_vtol");
	accolades::register("MISSION_AQUIFER_CHALLENGE5", "aq_quads_only_guns");
	accolades::register("MISSION_AQUIFER_CHALLENGE6", "aq_threefer_missile");
	accolades::register("MISSION_AQUIFER_CHALLENGE7", "aq_six_under_two");
	accolades::register("MISSION_AQUIFER_CHALLENGE9", "aq_zero_damage_defenses");
	accolades::register("MISSION_AQUIFER_CHALLENGE10", "aq_tnt");
	accolades::register("MISSION_AQUIFER_CHALLENGE11", "aq_defend_egyptians");
	accolades::register("MISSION_AQUIFER_CHALLENGE12", "aq_vtol_drop_block");
	accolades::register("MISSION_AQUIFER_CHALLENGE13", "aq_dogfight_kill_only_guns");
	accolades::register("MISSION_AQUIFER_CHALLENGE14", "aq_boss_zero_damage");
	accolades::register("MISSION_AQUIFER_CHALLENGE15", "aq_boss_cybercore_only");
	level.var_bb70984c = [];
	level.var_bb70984c["aq_thirty_kill_vtol"] = 90;
	level.var_bb70984c["aq_three_hunters_vtol"] = 7;
	level.var_bb70984c["aq_dogfight_kill_only_guns"] = 8;
	level.var_bb70984c["aq_threefer_missile"] = 1;
	level.var_bb70984c["aq_vtol_drop_block"] = 5;
	level.var_bb70984c["aq_tnt"] = 15;
	level.var_bb70984c["aq_defend_egyptians"] = 45;
	thread function_89f596d9();
}

/*
	Name: function_c27610f9
	Namespace: namespace_b5b83650
	Checksum: 0x401B6C66
	Offset: 0x850
	Size: 0x1EA
	Parameters: 3
	Flags: Linked
*/
function function_c27610f9(var_8e087689 = "dummy", var_70b01bd3, var_513753b4 = 1)
{
	if(!isdefined(level.var_bb70984c[var_8e087689]))
	{
		level.var_bb70984c[var_8e087689] = 1;
	}
	player = self;
	players = [];
	if(self == level)
	{
		players = level.activeplayers;
	}
	else
	{
		players[players.size] = self;
	}
	foreach(player in players)
	{
		if(!isdefined(player.var_ec496e8b))
		{
			player.var_ec496e8b = [];
		}
		if(!isdefined(player.var_ec496e8b[var_8e087689]))
		{
			player.var_ec496e8b[var_8e087689] = 0;
		}
		player.var_ec496e8b[var_8e087689]++;
		player notify(var_8e087689);
		/#
			iprintln((((("" + var_8e087689) + "") + player.var_ec496e8b[var_8e087689]) + "") + level.var_bb70984c[var_8e087689]);
		#/
	}
}

/*
	Name: function_89f596d9
	Namespace: namespace_b5b83650
	Checksum: 0xEFE3EEF1
	Offset: 0xA48
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function function_89f596d9()
{
	callback::on_ai_killed(&function_eab778af);
	thread function_a8831ac1();
	thread function_f208dfd8();
	callback::on_ai_killed(&function_e3e41d63);
	callback::on_ai_killed(&function_c7122e75);
	callback::on_ai_killed(&function_171499d7);
	callback::on_ai_killed(&function_6be65617);
	callback::on_vehicle_killed(&function_9cda9485);
	thread function_dcb19e2a();
	thread function_f42b5fa1();
}

/*
	Name: function_171499d7
	Namespace: namespace_b5b83650
	Checksum: 0x776CE5C8
	Offset: 0xB58
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function function_171499d7(params)
{
	if(isplayer(params.eattacker) && !isvehicle(self))
	{
		if(params.einflictor.targetname === "destructible")
		{
			params.eattacker accolades::increment("MISSION_AQUIFER_CHALLENGE10");
		}
	}
}

/*
	Name: function_6be65617
	Namespace: namespace_b5b83650
	Checksum: 0x9BA0CAD6
	Offset: 0xBF8
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function function_6be65617(params)
{
	if(level flag::get("destroy_defenses2_completed"))
	{
		callback::remove_on_ai_killed(&function_6be65617);
		return;
	}
	if(isplayer(params.eattacker) && !isvehicle(self) && level flag::get("destroy_defenses2"))
	{
		if(isdefined(params.eattacker.pvtol) && params.eattacker islinkedto(params.eattacker.pvtol))
		{
			params.eattacker accolades::increment("MISSION_AQUIFER_CHALLENGE11");
		}
	}
}

/*
	Name: function_c7122e75
	Namespace: namespace_b5b83650
	Checksum: 0xB373EC4C
	Offset: 0xD20
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_c7122e75(params)
{
	if(isplayer(params.eattacker) && !isvehicle(self) && self.team !== "allies")
	{
		if(isdefined(params.eattacker.pvtol) && params.eattacker islinkedto(params.eattacker.pvtol))
		{
			params.eattacker function_c27610f9("aq_thirty_kill_vtol", &function_b49b24ca);
		}
	}
}

/*
	Name: function_b49b24ca
	Namespace: namespace_b5b83650
	Checksum: 0x925AE9DB
	Offset: 0xE08
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_b49b24ca()
{
	callback::remove_on_ai_killed(&function_c7122e75);
}

/*
	Name: function_9cda9485
	Namespace: namespace_b5b83650
	Checksum: 0x48B513C7
	Offset: 0xE38
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_9cda9485(params)
{
	if(isplayer(params.eattacker) && isdefined(self.archetype) && self.archetype == "hunter")
	{
		if(isdefined(params.eattacker.pvtol) && params.eattacker islinkedto(params.eattacker.pvtol))
		{
			params.eattacker function_c27610f9("aq_three_hunters_vtol", &function_ff25056a);
		}
	}
}

/*
	Name: function_ff25056a
	Namespace: namespace_b5b83650
	Checksum: 0x89A459A0
	Offset: 0xF10
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_ff25056a()
{
	callback::remove_on_vehicle_killed(&function_9cda9485);
}

/*
	Name: function_a8831ac1
	Namespace: namespace_b5b83650
	Checksum: 0xD61D6B35
	Offset: 0xF40
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_a8831ac1()
{
	callback::on_vehicle_killed(&function_5ae2cb8a);
	level.var_67a0c1e2 = 0;
	flag::wait_till("destroy_defenses2_completed");
	if(level.var_67a0c1e2 == 0)
	{
		level function_c27610f9("aq_quads_only_guns");
	}
	callback::remove_on_vehicle_killed(&function_5ae2cb8a);
}

/*
	Name: function_5ae2cb8a
	Namespace: namespace_b5b83650
	Checksum: 0xD347D509
	Offset: 0xFE0
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function function_5ae2cb8a(params)
{
	if(isplayer(params.eattacker) && isdefined(self.archetype) && self.archetype == "quadtank")
	{
		if(isdefined(params.weapon) && params.weapon.name != "vtol_fighter_player_turret")
		{
			level.var_67a0c1e2 = 1;
		}
	}
}

/*
	Name: function_282c46db
	Namespace: namespace_b5b83650
	Checksum: 0x18EE2AF6
	Offset: 0x1080
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function function_282c46db()
{
	callback::remove_on_vehicle_killed(&function_9cda9485);
}

/*
	Name: function_eab778af
	Namespace: namespace_b5b83650
	Checksum: 0xC179F252
	Offset: 0x10B0
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function function_eab778af(params)
{
	if(isplayer(params.eattacker) && !isvehicle(self))
	{
		if(isdefined(params.eattacker.pvtol) && params.eattacker islinkedto(params.eattacker.pvtol) && params.weapon.type == "projectile")
		{
			if(!isdefined(params.eattacker.var_be2c6b19) || params.eattacker.var_be2c6b19 != gettime())
			{
				params.eattacker.var_be2c6b19 = gettime();
				params.eattacker.var_eb0c14e = 0;
			}
			params.eattacker.var_eb0c14e++;
			if(params.eattacker.var_eb0c14e >= 5)
			{
				params.eattacker function_c27610f9("aq_threefer_missile", &function_a3f650bc);
			}
		}
	}
}

/*
	Name: function_a3f650bc
	Namespace: namespace_b5b83650
	Checksum: 0x5AE42C36
	Offset: 0x1248
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_a3f650bc()
{
	callback::remove_on_ai_killed(&function_eab778af);
}

/*
	Name: function_e3e41d63
	Namespace: namespace_b5b83650
	Checksum: 0x10B8B370
	Offset: 0x1278
	Size: 0x21C
	Parameters: 1
	Flags: Linked
*/
function function_e3e41d63(params)
{
	if(isplayer(params.eattacker) && !isvehicle(self))
	{
		player = params.eattacker;
		if(isdefined(player.var_2aec500b))
		{
			return;
		}
		if(!isdefined(player.var_c3919891))
		{
			player.var_c3919891 = [];
		}
		t = gettime();
		if(player.var_c3919891.size > 0)
		{
			dirty = 1;
			while(dirty)
			{
				dirty = 0;
				for(i = 0; i < player.var_c3919891.size; i++)
				{
					if(player.var_c3919891[i] < t)
					{
						player.var_c3919891 = array::remove_index(player.var_c3919891, i);
						dirty = 1;
						break;
					}
				}
			}
		}
		player.var_c3919891[player.var_c3919891.size] = t + 2000;
		/#
			iprintln("" + player.var_c3919891.size);
		#/
		if(player.var_c3919891.size >= 10)
		{
			player.var_2aec500b = 1;
			player function_c27610f9("aq_six_under_two");
		}
	}
}

/*
	Name: function_8618bd31
	Namespace: namespace_b5b83650
	Checksum: 0x99EC1590
	Offset: 0x14A0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function function_8618bd31()
{
}

/*
	Name: function_3b8b405
	Namespace: namespace_b5b83650
	Checksum: 0xEBC84F05
	Offset: 0x14B0
	Size: 0x18E
	Parameters: 0
	Flags: None
*/
function function_3b8b405()
{
	flag::wait_till("player_active_in_level");
	flag::wait_till("intro_dogfight_completed");
	var_e4047762 = level.activeplayers;
	foreach(player in var_e4047762)
	{
		player thread function_2edc96bc();
	}
	flag::wait_till("destroy_defenses_completed");
	foreach(player in var_e4047762)
	{
		if(array::contains(level.activeplayers, player))
		{
			player notify(#"destroy_defenses_completed");
		}
	}
	wait(1);
	level notify(#"hash_ebe4266");
}

/*
	Name: function_2edc96bc
	Namespace: namespace_b5b83650
	Checksum: 0x676CDEB1
	Offset: 0x1648
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_2edc96bc()
{
	self endon(#"disconnect");
	self endon(#"death");
	level endon(#"hash_ebe4266");
	retval = self util::waittill_any_return("player_took_accolade_damage", "destroy_defenses_completed");
	if(isdefined(retval) && retval == "destroy_defenses_completed")
	{
		self function_c27610f9("aq_zero_damage_defenses");
	}
}

/*
	Name: function_f208dfd8
	Namespace: namespace_b5b83650
	Checksum: 0x45AD8FFA
	Offset: 0x16E8
	Size: 0x162
	Parameters: 0
	Flags: Linked
*/
function function_f208dfd8()
{
	level flag::wait_till("player_active_in_level");
	level flag::wait_till("intro_dogfight_completed");
	if(!level flag::get("destroy_defenses_completed"))
	{
		array::thread_all(level.activeplayers, &function_deee0b62);
	}
	level flag::wait_till("destroy_defenses_completed");
	foreach(player in level.activeplayers)
	{
		if(isdefined(player.var_80329ae2) && !player.var_80329ae2)
		{
			player function_c27610f9("aq_zero_damage_defenses");
		}
	}
}

/*
	Name: function_deee0b62
	Namespace: namespace_b5b83650
	Checksum: 0xF284C7F6
	Offset: 0x1858
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function function_deee0b62(params)
{
	self endon(#"disconnect");
	self endon(#"death");
	level endon(#"hash_4af9ae51");
	self.var_80329ae2 = 0;
	while(true)
	{
		if(isdefined(self.pvtol))
		{
			self.pvtol waittill(#"damage", damage, attacker, direction_vec, point, meansofdeath, tagname, modelname, partname, weapon);
			if(weapon.type != "bullet")
			{
				self.var_80329ae2 = 1;
			}
		}
		else
		{
			wait(0.05);
		}
	}
}

/*
	Name: function_dcb19e2a
	Namespace: namespace_b5b83650
	Checksum: 0xE638224
	Offset: 0x1960
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_dcb19e2a()
{
	flag::wait_till("player_active_in_level");
	flag::wait_till("destroy_defenses_completed");
	callback::on_vehicle_killed(&function_3718be07);
	flag::wait_till("hack_terminal_left_completed");
	flag::wait_till("hack_terminal_right_completed");
	flag::wait_till("hack_terminals3_completed");
	callback::remove_on_vehicle_killed(&function_3718be07);
}

/*
	Name: function_3718be07
	Namespace: namespace_b5b83650
	Checksum: 0xC80DC45C
	Offset: 0x1A28
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function function_3718be07(params)
{
	if(isplayer(params.eattacker) && (self.targetname == "res_vtol1_vh" || self.targetname == "res_vtol2_vh" || self.targetname == "port_vtol1_vh" || self.targetname == "port_vtol2_vh" || self.targetname == "lcombat_dropoff_vtol_vh"))
	{
		level function_c27610f9("aq_vtol_drop_block");
	}
}

/*
	Name: function_f42b5fa1
	Namespace: namespace_b5b83650
	Checksum: 0x1FBD553A
	Offset: 0x1AE8
	Size: 0x1CE
	Parameters: 0
	Flags: Linked
*/
function function_f42b5fa1()
{
	flag::wait_till("player_active_in_level");
	level flag::wait_till("start_battle");
	level flag::wait_till("sniper_boss_spawned");
	var_e4047762 = level.activeplayers;
	foreach(player in var_e4047762)
	{
		player thread function_a2aa8ca8();
		player thread function_b362fb44();
	}
	level flag::wait_till("end_battle");
	foreach(player in var_e4047762)
	{
		if(array::contains(level.activeplayers, player))
		{
			player notify(#"hash_8c7ead91");
		}
	}
	wait(1);
	level notify(#"hash_2899a2c7");
}

/*
	Name: function_a2aa8ca8
	Namespace: namespace_b5b83650
	Checksum: 0x37FAB50A
	Offset: 0x1CC0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_a2aa8ca8()
{
	self endon(#"disconnect");
	level endon(#"hash_2899a2c7");
	self thread function_c2ba8da();
	retval = self util::waittill_any_return("sniper_boss_damage", "accolades_boss_done");
	if(isdefined(retval) && retval == "accolades_boss_done")
	{
		self function_c27610f9("aq_boss_zero_damage");
	}
}

/*
	Name: function_c2ba8da
	Namespace: namespace_b5b83650
	Checksum: 0x67512523
	Offset: 0x1D68
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function function_c2ba8da()
{
	self endon(#"disconnect");
	level endon(#"hash_2899a2c7");
	attacker = self;
	while(attacker != level.sniper_boss)
	{
		self waittill(#"damage", damage, attacker, dir, loc, type, model, tag, part, weapon, flags);
	}
	self notify(#"hash_703e1e78");
}

/*
	Name: function_b362fb44
	Namespace: namespace_b5b83650
	Checksum: 0x771AD3F2
	Offset: 0x1E40
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_b362fb44()
{
	self endon(#"disconnect");
	level endon(#"hash_2899a2c7");
	retval = self util::waittill_any_return("weapon_fired", "accolades_boss_done");
	if(isdefined(retval) && retval == "accolades_boss_done")
	{
		self function_c27610f9("aq_boss_cybercore_only");
	}
}

