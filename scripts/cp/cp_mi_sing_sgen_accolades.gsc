// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_accolades;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace namespace_99202726;

/*
	Name: function_66df416f
	Namespace: namespace_99202726
	Checksum: 0x6B1A0793
	Offset: 0x600
	Size: 0x396
	Parameters: 0
	Flags: Linked
*/
function function_66df416f()
{
	accolades::register("MISSION_SGEN_UNTOUCHED");
	accolades::register("MISSION_SGEN_SCORE");
	accolades::register("MISSION_SGEN_COLLECTIBLE");
	accolades::register("MISSION_SGEN_CHALLENGE3", "accolade_3_doubleshot_success");
	accolades::register("MISSION_SGEN_CHALLENGE4", "accolade_04_immolate_grant");
	accolades::register("MISSION_SGEN_CHALLENGE5", "accolade_05_melee_kill");
	accolades::register("MISSION_SGEN_CHALLENGE6", "accolade_06_confirmed_hit");
	accolades::register("MISSION_SGEN_CHALLENGE7", "accolade_07_stealth_kill");
	accolades::register("MISSION_SGEN_CHALLENGE8", "accolade_08_sniper_kill");
	accolades::register("MISSION_SGEN_CHALLENGE9", "accolade_09_long_shot_success");
	accolades::register("MISSION_SGEN_CHALLENGE10", "accolade_10_electro_bots_success");
	accolades::register("MISSION_SGEN_CHALLENGE11", "accolade_11_flood_exterminate_grant");
	accolades::register("MISSION_SGEN_CHALLENGE13", "accolade_13_stay_awhile_grant");
	accolades::register("MISSION_SGEN_CHALLENGE15", "accolade_15_depth_charge_damage_granted");
	accolades::register("MISSION_SGEN_CHALLENGE16", "accolade_16_kill_depth_charge_success");
	accolades::register("MISSION_SGEN_CHALLENGE17", "accolade_17_rocket_kill_success");
	level flag::wait_till("all_players_spawned");
	level thread function_b5ffeeac();
	level thread function_3fafea6d();
	level thread function_3bf99ff5();
	level thread function_3be7776b();
	level thread function_5335c37e();
	level thread function_a07abde9();
	callback::on_spawned(&function_d5c2bb53);
	level flag::wait_till("all_players_spawned");
	switch(level.current_skipto)
	{
		case "post_intro":
		{
			function_6a1ab5fc();
			function_b2309b8();
			function_6a2780bc();
			break;
		}
		case "enter_sgen":
		{
			function_6a1ab5fc();
			function_b2309b8();
			function_6a2780bc();
			break;
		}
		case "silo_swim":
		{
			function_f3915502();
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: function_d5c2bb53
	Namespace: namespace_99202726
	Checksum: 0x34E5263D
	Offset: 0x9A0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_d5c2bb53()
{
	self function_b67d38c4();
	self function_a07abde9();
}

/*
	Name: function_b5ffeeac
	Namespace: namespace_99202726
	Checksum: 0x73A73A4
	Offset: 0x9E0
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_b5ffeeac()
{
	callback::on_ai_killed(&function_6b1e8f3c);
	foreach(player in level.activeplayers)
	{
		player.var_f329477a = undefined;
	}
}

/*
	Name: function_b67d38c4
	Namespace: namespace_99202726
	Checksum: 0x2905DF66
	Offset: 0xA88
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function function_b67d38c4()
{
	self.var_f329477a = undefined;
}

/*
	Name: function_6b1e8f3c
	Namespace: namespace_99202726
	Checksum: 0xBC925887
	Offset: 0xAA0
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function function_6b1e8f3c(params)
{
	if(isplayer(params.eattacker))
	{
		if(isdefined(params.weapon) && (params.smeansofdeath == "MOD_PISTOL_BULLET" || params.smeansofdeath == "MOD_RIFLE_BULLET"))
		{
			if(isdefined(params.eattacker.var_f329477a))
			{
				if(params.eattacker.var_f329477a == params.eattacker._bbdata["shots"])
				{
					params.eattacker notify(#"hash_450a5f27");
				}
			}
			params.eattacker.var_f329477a = params.eattacker._bbdata["shots"];
		}
	}
}

/*
	Name: function_3fafea6d
	Namespace: namespace_99202726
	Checksum: 0x57209D47
	Offset: 0xBC0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_3fafea6d()
{
	foreach(player in level.activeplayers)
	{
		player.var_370e0a49 = 0;
	}
	callback::on_ai_killed(&function_ed6cec59);
}

/*
	Name: function_ed6cec59
	Namespace: namespace_99202726
	Checksum: 0xBF578BB6
	Offset: 0xC70
	Size: 0x264
	Parameters: 1
	Flags: Linked
*/
function function_ed6cec59(s_params)
{
	if(self.archetype === "robot" && s_params.weapon.name == "gadget_immolation")
	{
		if(!isdefined(s_params.eattacker.var_6749af1d))
		{
			s_params.eattacker.var_6749af1d = [];
		}
		n_time_current = gettime();
		if(!isdefined(s_params.eattacker.var_6749af1d))
		{
			s_params.eattacker.var_6749af1d = [];
		}
		else if(!isarray(s_params.eattacker.var_6749af1d))
		{
			s_params.eattacker.var_6749af1d = array(s_params.eattacker.var_6749af1d);
		}
		s_params.eattacker.var_6749af1d[s_params.eattacker.var_6749af1d.size] = n_time_current;
		if(s_params.eattacker.var_6749af1d.size >= 4)
		{
			var_10db1e52 = s_params.eattacker.var_6749af1d.size - 4;
			var_97e374a8 = n_time_current - 1500;
			var_84abbef6 = 0;
			for(i = var_10db1e52; i < s_params.eattacker.var_6749af1d.size; i++)
			{
				if(s_params.eattacker.var_6749af1d[i] >= var_97e374a8)
				{
					var_84abbef6++;
				}
			}
			if(var_84abbef6 >= 4)
			{
				s_params.eattacker notify(#"hash_be3e251c");
			}
		}
	}
}

/*
	Name: function_3bf99ff5
	Namespace: namespace_99202726
	Checksum: 0x867FB796
	Offset: 0xEE0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_3bf99ff5()
{
	callback::on_ai_killed(&function_25a5bc35);
}

/*
	Name: function_25a5bc35
	Namespace: namespace_99202726
	Checksum: 0x56AE5F94
	Offset: 0xF10
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_25a5bc35(params)
{
	if(self.archetype == "robot" && self.movemode == "run")
	{
		if(isplayer(params.eattacker))
		{
			if(function_3dc86a1(params))
			{
				params.eattacker notify(#"hash_55b52735");
			}
		}
	}
}

/*
	Name: function_3dc86a1
	Namespace: namespace_99202726
	Checksum: 0x4B5D14C7
	Offset: 0xFA0
	Size: 0xB8
	Parameters: 1
	Flags: Linked
*/
function function_3dc86a1(params)
{
	if(params.weapon.type == "melee")
	{
		return true;
	}
	if(params.smeansofdeath == "MOD_MELEE_WEAPON_BUTT")
	{
		return true;
	}
	if(params.weapon.name == "hero_gravity_spikes_cyebercom")
	{
		return true;
	}
	if(params.weapon.name == "hero_gravity_spikes_cyebercom_upgraded")
	{
		return true;
	}
	return false;
}

/*
	Name: function_3be7776b
	Namespace: namespace_99202726
	Checksum: 0xE156D92
	Offset: 0x1068
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_3be7776b()
{
	foreach(player in level.activeplayers)
	{
		player function_c05b6c67();
	}
	callback::on_spawned(&function_c05b6c67);
	callback::on_ai_damage(&function_d77515b3);
}

/*
	Name: function_c05b6c67
	Namespace: namespace_99202726
	Checksum: 0x463FC380
	Offset: 0x1140
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_c05b6c67()
{
	self.var_ad8b41e2 = 0;
	self.var_ad217527 = 0;
}

/*
	Name: function_d77515b3
	Namespace: namespace_99202726
	Checksum: 0x8CB63D04
	Offset: 0x1168
	Size: 0x204
	Parameters: 1
	Flags: Linked
*/
function function_d77515b3(params)
{
	if(isplayer(params.eattacker))
	{
		if(self.archetype == "robot")
		{
			if(params.shitloc == "head" || params.shitloc == "helmet" || params.shitloc == "neck")
			{
				if(!params.eattacker.var_ad8b41e2)
				{
					params.eattacker.var_ad217527 = params.eattacker._bbdata["shots"];
				}
				else
				{
					params.eattacker.var_ad217527++;
				}
				if(params.eattacker.var_ad217527 == params.eattacker._bbdata["shots"])
				{
					params.eattacker.var_ad8b41e2++;
					if(params.eattacker.var_ad8b41e2 >= 5)
					{
						params.eattacker notify(#"hash_d90d93fc");
					}
				}
				else
				{
					params.eattacker.var_ad217527 = params.eattacker._bbdata["shots"];
					params.eattacker.var_ad8b41e2 = 1;
				}
			}
			else
			{
				params.eattacker.var_ad8b41e2 = 0;
			}
		}
	}
}

/*
	Name: function_6a1ab5fc
	Namespace: namespace_99202726
	Checksum: 0xE0014840
	Offset: 0x1378
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_6a1ab5fc()
{
	callback::on_ai_killed(&function_94847029);
}

/*
	Name: function_94847029
	Namespace: namespace_99202726
	Checksum: 0xD3DB063
	Offset: 0x13A8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_94847029(params)
{
	if(isplayer(params.eattacker))
	{
		if(!level flag::get("exterior_gone_hot"))
		{
			params.eattacker notify(#"hash_8ff5db7c");
		}
	}
}

/*
	Name: function_45afef12
	Namespace: namespace_99202726
	Checksum: 0xE005F7B5
	Offset: 0x1418
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_45afef12()
{
	callback::remove_on_ai_killed(&function_94847029);
}

/*
	Name: function_b2309b8
	Namespace: namespace_99202726
	Checksum: 0x6EE91F97
	Offset: 0x1448
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_b2309b8()
{
	callback::on_ai_killed(&function_52b96b46);
}

/*
	Name: function_52b96b46
	Namespace: namespace_99202726
	Checksum: 0xCE1C8609
	Offset: 0x1478
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_52b96b46(params)
{
	if(isplayer(params.eattacker))
	{
		if(!level flag::get("exterior_gone_hot"))
		{
			if(self.scoretype == "_sniper")
			{
				params.eattacker notify(#"hash_4a89e4c7");
			}
		}
	}
}

/*
	Name: function_59fa6593
	Namespace: namespace_99202726
	Checksum: 0x58ED0BD6
	Offset: 0x1500
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_59fa6593()
{
	callback::remove_on_ai_killed(&function_52b96b46);
}

/*
	Name: function_6a2780bc
	Namespace: namespace_99202726
	Checksum: 0x2D80123B
	Offset: 0x1530
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_6a2780bc()
{
	callback::on_ai_killed(&function_707a731a);
}

/*
	Name: function_707a731a
	Namespace: namespace_99202726
	Checksum: 0x2296944E
	Offset: 0x1560
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_707a731a(params)
{
	if(isplayer(params.eattacker))
	{
		var_701fc082 = params.eattacker.origin;
		var_b0bb8558 = self.origin;
		if(distance(var_701fc082, var_b0bb8558) > 2500)
		{
			params.eattacker notify(#"hash_f1d371eb");
		}
	}
}

/*
	Name: function_6d2fd9d2
	Namespace: namespace_99202726
	Checksum: 0x6C2F219D
	Offset: 0x1608
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_6d2fd9d2()
{
	callback::remove_on_ai_killed(&function_707a731a);
}

/*
	Name: function_5335c37e
	Namespace: namespace_99202726
	Checksum: 0x8FD624A5
	Offset: 0x1638
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_5335c37e()
{
	callback::on_ai_killed(&function_e7cebc20);
}

/*
	Name: function_e7cebc20
	Namespace: namespace_99202726
	Checksum: 0xD9A76FF7
	Offset: 0x1668
	Size: 0x114
	Parameters: 1
	Flags: Linked
*/
function function_e7cebc20(params)
{
	if(isplayer(params.eattacker))
	{
		if(params.smeansofdeath == "MOD_ELECTROCUTED")
		{
			if(isdefined(params.eattacker.var_e6cc8b44))
			{
				if(params.eattacker.var_e6cc8b44 == params.einflictor)
				{
					params.eattacker.var_60d52155++;
					if(params.eattacker.var_60d52155 == 2)
					{
						params.eattacker notify(#"hash_b6737fd1");
					}
				}
				else
				{
					function_5fc826b3(params);
				}
			}
			else
			{
				function_5fc826b3(params);
			}
		}
	}
}

/*
	Name: function_17b77884
	Namespace: namespace_99202726
	Checksum: 0x4E02EC83
	Offset: 0x1788
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function function_17b77884()
{
	self.var_60d52155 = 0;
	self.var_e6cc8b44 = undefined;
}

/*
	Name: function_5fc826b3
	Namespace: namespace_99202726
	Checksum: 0xC44D4F3B
	Offset: 0x17B0
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function function_5fc826b3(params)
{
	params.eattacker.var_e6cc8b44 = params.einflictor;
	params.eattacker.var_60d52155 = 0;
}

/*
	Name: function_bc2458f5
	Namespace: namespace_99202726
	Checksum: 0x244AFE59
	Offset: 0x1800
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function function_bc2458f5()
{
	if(!level flag::get("flood_runner_escaped"))
	{
		foreach(player in level.activeplayers)
		{
			player notify(#"hash_ff15c287");
		}
	}
}

/*
	Name: function_c75f9c25
	Namespace: namespace_99202726
	Checksum: 0x2A3290A0
	Offset: 0x18B0
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function function_c75f9c25()
{
	foreach(player in level.players)
	{
		player notify(#"hash_4b80918a");
	}
}

/*
	Name: function_f3915502
	Namespace: namespace_99202726
	Checksum: 0x6488F5F7
	Offset: 0x1940
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_f3915502()
{
	foreach(player in level.activeplayers)
	{
		player function_79aac6ce();
	}
	callback::on_spawned(&function_79aac6ce);
}

/*
	Name: function_79aac6ce
	Namespace: namespace_99202726
	Checksum: 0x9DF26C98
	Offset: 0x19F8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_79aac6ce()
{
	self.var_bae308b3 = 0;
	self thread function_962154a7();
}

/*
	Name: function_962154a7
	Namespace: namespace_99202726
	Checksum: 0x639A69CD
	Offset: 0x1A28
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_962154a7()
{
	self endon(#"death");
	level endon(#"hash_1e73602d");
	while(true)
	{
		self waittill(#"damage", damage, attacker);
		if(isdefined(attacker.scoretype))
		{
			if(attacker.scoretype == "_depth_charge")
			{
				self.var_bae308b3 = 1;
			}
		}
	}
}

/*
	Name: function_fde8c3ce
	Namespace: namespace_99202726
	Checksum: 0x8CB72815
	Offset: 0x1AB8
	Size: 0x92
	Parameters: 0
	Flags: Linked
*/
function function_fde8c3ce()
{
	foreach(player in level.activeplayers)
	{
		if(!player.var_bae308b3)
		{
			player notify(#"hash_cdcbe1e7");
		}
	}
}

/*
	Name: function_e85e2afd
	Namespace: namespace_99202726
	Checksum: 0x7B01FFB6
	Offset: 0x1B58
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function function_e85e2afd(e_attacker)
{
	e_attacker notify(#"hash_5a5ed90f");
}

/*
	Name: function_a07abde9
	Namespace: namespace_99202726
	Checksum: 0x686B47E3
	Offset: 0x1B80
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_a07abde9()
{
	callback::on_ai_killed(&function_89c51083);
	foreach(player in level.activeplayers)
	{
		player.var_9dbb738f = undefined;
	}
}

/*
	Name: function_d669046f
	Namespace: namespace_99202726
	Checksum: 0xE82C2E16
	Offset: 0x1C28
	Size: 0xE
	Parameters: 0
	Flags: None
*/
function function_d669046f()
{
	self.var_9dbb738f = undefined;
}

/*
	Name: function_89c51083
	Namespace: namespace_99202726
	Checksum: 0x6623AA27
	Offset: 0x1C40
	Size: 0x110
	Parameters: 1
	Flags: Linked
*/
function function_89c51083(params)
{
	if(isplayer(params.eattacker))
	{
		if(!params.eattacker isonground())
		{
			if(params.weapon.weapclass == "rocketlauncher")
			{
				if(isdefined(params.eattacker.var_9dbb738f))
				{
					if(params.eattacker.var_9dbb738f == params.eattacker._bbdata["shots"])
					{
						params.eattacker notify(#"hash_ed8b1690");
					}
				}
				params.eattacker.var_9dbb738f = params.eattacker._bbdata["shots"];
			}
		}
	}
}

