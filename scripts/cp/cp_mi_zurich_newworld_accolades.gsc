// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_accolades;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_save;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#namespace namespace_37a1dc33;

/*
	Name: function_4d39a2af
	Namespace: namespace_37a1dc33
	Checksum: 0x39B206BC
	Offset: 0x5D0
	Size: 0x29C
	Parameters: 0
	Flags: Linked
*/
function function_4d39a2af()
{
	accolades::register("MISSION_NEWWORLD_UNTOUCHED");
	accolades::register("MISSION_NEWWORLD_SCORE");
	accolades::register("MISSION_NEWWORLD_COLLECTIBLE");
	accolades::register("MISSION_NEWWORLD_CHALLENGE3", "ch03_light_enemies_on_fire");
	accolades::register("MISSION_NEWWORLD_CHALLENGE4", "ch04_wall_run_kills");
	accolades::register("MISSION_NEWWORLD_CHALLENGE5", "ch05_penetrate_bullet_kills");
	accolades::register("MISSION_NEWWORLD_CHALLENGE6", "ch06_cybercom_robot_kills");
	accolades::register("MISSION_NEWWORLD_CHALLENGE7", "ch07_explosion_triple_kill");
	accolades::register("MISSION_NEWWORLD_CHALLENGE8", "ch08_grenade_throwback_kill");
	accolades::register("MISSION_NEWWORLD_CHALLENGE9", "ch09_icicle_kill");
	accolades::register("MISSION_NEWWORLD_CHALLENGE10", "ch10_disabled_robot_kill");
	accolades::register("MISSION_NEWWORLD_CHALLENGE11", "ch11_chase_no_reload");
	accolades::register("MISSION_NEWWORLD_CHALLENGE12", "ch12_chase_no_civilians");
	accolades::register("MISSION_NEWWORLD_CHALLENGE13", "ch13_turret_kill");
	accolades::register("MISSION_NEWWORLD_CHALLENGE14", "ch14_shotgun_kills");
	accolades::register("MISSION_NEWWORLD_CHALLENGE15", "ch15_wall_run_train");
	callback::on_spawned(&function_3a6b5b3e);
	function_89a4c66f();
	function_314eff4a();
	function_2b972244();
	function_e346bcd4();
	function_5a3da660();
	function_a87e96e();
	function_353e449e();
	function_6972c343();
	function_80820e19();
}

/*
	Name: function_3a6b5b3e
	Namespace: namespace_37a1dc33
	Checksum: 0xD029393
	Offset: 0x878
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_3a6b5b3e()
{
	self function_9f8d841b();
	self function_b4b1da62();
	self function_9c7144b6();
	self thread function_7e35ccbc();
}

/*
	Name: function_c27610f9
	Namespace: namespace_37a1dc33
	Checksum: 0xCF9AD48F
	Offset: 0x8E8
	Size: 0xD6
	Parameters: 2
	Flags: Linked
*/
function function_c27610f9(var_8e087689, var_70b01bd3)
{
	if(self == level)
	{
		foreach(player in level.activeplayers)
		{
			player notify(var_8e087689);
		}
	}
	else if(isplayer(self))
	{
		self notify(var_8e087689);
	}
	if(isdefined(var_70b01bd3))
	{
		[[var_70b01bd3]]();
	}
}

/*
	Name: function_9f8d841b
	Namespace: namespace_37a1dc33
	Checksum: 0x9AFAD62E
	Offset: 0x9C8
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function function_9f8d841b()
{
	self.var_57582aca = 0;
	self.var_6659e536 = undefined;
}

/*
	Name: function_89a4c66f
	Namespace: namespace_37a1dc33
	Checksum: 0xE8E41C32
	Offset: 0x9F0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_89a4c66f()
{
	callback::on_actor_killed(&function_595dc718);
}

/*
	Name: function_595dc718
	Namespace: namespace_37a1dc33
	Checksum: 0xAB731FC9
	Offset: 0xA20
	Size: 0x214
	Parameters: 1
	Flags: Linked
*/
function function_595dc718(params)
{
	if(isplayer(params.eattacker) && params.smeansofdeath == "MOD_BURNED")
	{
		if(!isdefined(params.eattacker.var_6659e536) || params.eattacker.var_6659e536 != params.einflictor)
		{
			params.eattacker.var_6659e536 = params.einflictor;
			params.eattacker.var_57582aca = 1;
			params.eattacker notify(#"hash_6daef24a");
			wait(0.05);
			if(params.eattacker.var_6659e536 == params.eattacker)
			{
				params.eattacker thread function_840d3bcc();
			}
		}
		else
		{
			if(params.eattacker.var_6659e536 === params.einflictor && !isdefined(self.var_93eeceb))
			{
				params.eattacker.var_57582aca++;
				self.var_93eeceb = 1;
				if(params.eattacker.var_57582aca == 3)
				{
					params.eattacker notify(#"hash_38998bd8");
				}
			}
			else
			{
				params.eattacker.var_6659e536 = params.einflictor;
				params.eattacker.var_57582aca = 1;
			}
		}
	}
}

/*
	Name: function_840d3bcc
	Namespace: namespace_37a1dc33
	Checksum: 0x42CBAA63
	Offset: 0xC40
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_840d3bcc()
{
	self endon(#"death");
	self endon(#"hash_6daef24a");
	self endon(#"hash_38998bd8");
	wait(0.5);
	self.var_6659e536 = undefined;
	self.var_57582aca = 0;
}

/*
	Name: function_314eff4a
	Namespace: namespace_37a1dc33
	Checksum: 0x79546174
	Offset: 0xC98
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_314eff4a()
{
	callback::on_ai_killed(&function_9257e223);
}

/*
	Name: function_9257e223
	Namespace: namespace_37a1dc33
	Checksum: 0xB2B3A567
	Offset: 0xCC8
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_9257e223(params)
{
	if(isplayer(params.eattacker))
	{
		player = params.eattacker;
		if(player iswallrunning())
		{
			player function_c27610f9("ch04_wall_run_kills");
		}
	}
}

/*
	Name: function_2b972244
	Namespace: namespace_37a1dc33
	Checksum: 0xABEAF6AA
	Offset: 0xD50
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_2b972244()
{
	callback::on_ai_killed(&function_9d5a87b1);
}

/*
	Name: function_9d5a87b1
	Namespace: namespace_37a1dc33
	Checksum: 0x74218BB8
	Offset: 0xD80
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_9d5a87b1(params)
{
	if(self.team !== "axis")
	{
		return;
	}
	if(isplayer(params.eattacker))
	{
		player = params.eattacker;
		var_3d9e461f = !bullettracepassed(player geteye(), self geteye(), 0, self);
		if(util::isbulletimpactmod(params.smeansofdeath) && var_3d9e461f)
		{
			player function_c27610f9("ch05_penetrate_bullet_kills");
		}
	}
}

/*
	Name: function_b4b1da62
	Namespace: namespace_37a1dc33
	Checksum: 0x6040BBBE
	Offset: 0xE88
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_b4b1da62()
{
	self.var_c81126e8 = 0;
	self.s_timer = util::new_timer(2);
}

/*
	Name: function_5a3da660
	Namespace: namespace_37a1dc33
	Checksum: 0x83CFE33C
	Offset: 0xEC0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_5a3da660()
{
	spawner::add_archetype_spawn_function("robot", &function_f9a5c6a1);
}

/*
	Name: function_f9a5c6a1
	Namespace: namespace_37a1dc33
	Checksum: 0x1243F60C
	Offset: 0xEF8
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_f9a5c6a1()
{
	self waittill(#"hash_f8c5dd60", weapon, eattacker);
	if(isplayer(eattacker))
	{
		if(eattacker.var_c81126e8 == 0)
		{
			eattacker.s_timer = util::new_timer(2);
			eattacker.var_c81126e8++;
		}
		else
		{
			eattacker.var_c81126e8++;
			if(eattacker.var_c81126e8 >= 5 && eattacker.s_timer util::get_time_left() > 0)
			{
				eattacker notify(#"hash_d28bfcb4");
			}
			else if(eattacker.s_timer util::get_time_left() <= 0)
			{
				eattacker.s_timer = util::new_timer(2);
				eattacker.var_c81126e8 = 1;
			}
		}
	}
}

/*
	Name: function_9c7144b6
	Namespace: namespace_37a1dc33
	Checksum: 0xF948F2E1
	Offset: 0x1050
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function function_9c7144b6()
{
	self.var_b2c73b97 = 0;
	self.var_b5385d9d = undefined;
}

/*
	Name: function_e346bcd4
	Namespace: namespace_37a1dc33
	Checksum: 0xFFF9A42F
	Offset: 0x1078
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_e346bcd4()
{
	callback::on_ai_killed(&function_1b6f43c5);
}

/*
	Name: function_1b6f43c5
	Namespace: namespace_37a1dc33
	Checksum: 0x7847D504
	Offset: 0x10A8
	Size: 0x210
	Parameters: 1
	Flags: Linked
*/
function function_1b6f43c5(params)
{
	if(self.team !== "axis")
	{
		return;
	}
	if(isplayer(params.eattacker) && (params.smeansofdeath == "MOD_GRENADE" || params.smeansofdeath == "MOD_GRENADE_SPLASH" || params.smeansofdeath == "MOD_EXPLOSIVE" || params.smeansofdeath == "MOD_EXPLOSIVE_SPLASH" || params.smeansofdeath == "MOD_PROJECTILE" || params.smeansofdeath == "MOD_PROJECTILE_SPLASH"))
	{
		if(!isdefined(params.eattacker.var_b5385d9d))
		{
			params.eattacker.var_b5385d9d = params.einflictor;
			params.eattacker.var_b2c73b97 = 1;
		}
		else
		{
			if(params.eattacker.var_b5385d9d === params.einflictor)
			{
				params.eattacker.var_b2c73b97++;
				if(params.eattacker.var_b2c73b97 >= 3)
				{
					params.eattacker notify(#"hash_f60a0b85");
				}
			}
			else
			{
				params.eattacker.var_b5385d9d = params.einflictor;
				params.eattacker.var_b2c73b97 = 1;
			}
		}
	}
}

/*
	Name: function_7e35ccbc
	Namespace: namespace_37a1dc33
	Checksum: 0x172DB8B4
	Offset: 0x12C0
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_7e35ccbc()
{
	self endon(#"death");
	self.var_c6c262e8 = 0;
	while(true)
	{
		self waittill(#"grenade_throwback", tosser, grenade);
		if(tosser.team == "axis")
		{
			self.var_fc30fc22 = grenade;
			self thread function_23ad043b();
		}
	}
}

/*
	Name: function_23ad043b
	Namespace: namespace_37a1dc33
	Checksum: 0x66E2613
	Offset: 0x1350
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_23ad043b()
{
	self endon(#"death");
	self.var_fc30fc22 waittill(#"explode");
	self.var_fc30fc22 = undefined;
	wait(0.5);
	self.var_c6c262e8 = 0;
}

/*
	Name: function_a87e96e
	Namespace: namespace_37a1dc33
	Checksum: 0xC6610F5
	Offset: 0x1398
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_a87e96e()
{
	callback::on_ai_killed(&function_ee3272c2);
}

/*
	Name: function_ee3272c2
	Namespace: namespace_37a1dc33
	Checksum: 0xE61E089A
	Offset: 0x13C8
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function function_ee3272c2(params)
{
	if(isplayer(params.eattacker))
	{
		if(isdefined(params.eattacker.var_fc30fc22))
		{
			if(params.einflictor == params.eattacker.var_fc30fc22)
			{
				params.eattacker.var_c6c262e8++;
				if(params.eattacker.var_c6c262e8 == 3)
				{
					params.eattacker notify(#"hash_8fa9da82");
				}
			}
		}
	}
}

/*
	Name: function_353e449e
	Namespace: namespace_37a1dc33
	Checksum: 0x842FCE29
	Offset: 0x1490
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_353e449e()
{
	callback::on_ai_killed(&function_3867e45c);
}

/*
	Name: function_3867e45c
	Namespace: namespace_37a1dc33
	Checksum: 0x7097BE11
	Offset: 0x14C0
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function function_3867e45c(params)
{
	if(isplayer(params.eattacker) && params.eattacker.weap === "icicle")
	{
		params.eattacker notify(#"hash_c347271c");
	}
}

/*
	Name: function_6972c343
	Namespace: namespace_37a1dc33
	Checksum: 0x7A38CFFB
	Offset: 0x1530
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_6972c343()
{
	spawner::add_archetype_spawn_function("robot", &function_deb99e6);
	callback::on_ai_killed(&function_c008ffe2);
}

/*
	Name: function_deb99e6
	Namespace: namespace_37a1dc33
	Checksum: 0xDB4B6E99
	Offset: 0x1588
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_deb99e6()
{
	self endon(#"death");
	while(true)
	{
		self.b_disabled = 0;
		self waittill(#"emp_fx_start");
		self.b_disabled = 1;
		self waittill(#"emp_shutdown_end");
		self.b_disabled = 0;
	}
}

/*
	Name: function_c008ffe2
	Namespace: namespace_37a1dc33
	Checksum: 0x734EA42E
	Offset: 0x15E8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_c008ffe2(params)
{
	if(isplayer(params.eattacker) && self.archetype == "robot")
	{
		if(self.b_disabled)
		{
			params.eattacker notify(#"hash_4c313fa2");
		}
	}
}

/*
	Name: function_cd261d0b
	Namespace: namespace_37a1dc33
	Checksum: 0xD12FA721
	Offset: 0x1658
	Size: 0x142
	Parameters: 0
	Flags: Linked
*/
function function_cd261d0b()
{
	level flag::wait_till("all_players_spawned");
	foreach(player in level.players)
	{
		player thread function_af529683();
	}
	level flag::wait_till("chase_done");
	foreach(player in level.players)
	{
		player thread function_2d344335();
	}
}

/*
	Name: function_af529683
	Namespace: namespace_37a1dc33
	Checksum: 0x7C53D562
	Offset: 0x17A8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_af529683()
{
	self endon(#"death");
	level endon(#"hash_3d00ae0c");
	self waittill(#"reload");
	self savegame::set_player_data("b_nw_accolade_11_failed", 1);
}

/*
	Name: function_2d344335
	Namespace: namespace_37a1dc33
	Checksum: 0x8D1DB050
	Offset: 0x1800
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_2d344335()
{
	if(self savegame::get_player_data("b_nw_accolade_11_failed") !== 1 && self savegame::get_player_data("b_has_done_chase") !== 0 && self savegame::get_player_data("b_nw_accolade_11_completed") !== 1)
	{
		self notify(#"hash_b83db00b");
		self savegame::set_player_data("b_nw_accolade_11_completed", 1);
	}
}

/*
	Name: function_323baa37
	Namespace: namespace_37a1dc33
	Checksum: 0xA450F35A
	Offset: 0x18B0
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_323baa37()
{
	level flag::wait_till("all_players_spawned");
	callback::on_actor_killed(&function_bc7f04af);
	callback::on_ai_spawned(&function_829b12c4);
	level flag::wait_till("chase_done");
	foreach(player in level.players)
	{
		player thread function_8af9d448();
	}
	callback::remove_on_actor_killed(&function_bc7f04af);
	callback::remove_on_ai_spawned(&function_829b12c4);
}

/*
	Name: function_bc7f04af
	Namespace: namespace_37a1dc33
	Checksum: 0x46CC825D
	Offset: 0x1A08
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_bc7f04af(params)
{
	if(self.archetype == "civilian" || self.archetype == "allies" && isplayer(params.eattacker))
	{
		params.eattacker savegame::set_player_data("b_nw_accolade_12_failed", 1);
	}
}

/*
	Name: function_829b12c4
	Namespace: namespace_37a1dc33
	Checksum: 0x5029A397
	Offset: 0x1A90
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_829b12c4(params)
{
	self endon(#"death");
	if(isdefined(self.archetype) && (self.archetype == "civilian" || self.archetype == "allies"))
	{
		self waittill(#"touch", e_toucher);
		if(isplayer(e_toucher))
		{
			e_toucher savegame::set_player_data("b_nw_accolade_12_failed", 1);
		}
	}
}

/*
	Name: function_8af9d448
	Namespace: namespace_37a1dc33
	Checksum: 0x4C2A8BBD
	Offset: 0x1B38
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_8af9d448()
{
	if(self savegame::get_player_data("b_nw_accolade_12_failed") !== 1 && self savegame::get_player_data("b_has_done_chase") !== 0 && self savegame::get_player_data("b_nw_accolade_12_completed") !== 1)
	{
		self notify(#"hash_690d946b");
		self savegame::set_player_data("b_nw_accolade_12_completed", 1);
	}
}

/*
	Name: function_f7dd9b2c
	Namespace: namespace_37a1dc33
	Checksum: 0x178D951E
	Offset: 0x1BE8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_f7dd9b2c()
{
	callback::on_ai_killed(&function_e50c8d4a);
	level waittill(#"hash_c37d20e3");
	callback::remove_on_ai_killed(&function_e50c8d4a);
}

/*
	Name: function_e50c8d4a
	Namespace: namespace_37a1dc33
	Checksum: 0x41F26345
	Offset: 0x1C48
	Size: 0xB8
	Parameters: 1
	Flags: Linked
*/
function function_e50c8d4a(params)
{
	if(isdefined(params.eattacker) && isplayer(params.eattacker) && isdefined(params.eattacker.hijacked_vehicle_entity) && params.eattacker.hijacked_vehicle_entity.archetype === "turret")
	{
		if(params.eattacker.hijacked_vehicle_entity !== self)
		{
			params.eattacker notify(#"hash_802ebfac");
		}
	}
}

/*
	Name: function_8bb97e0
	Namespace: namespace_37a1dc33
	Checksum: 0x4B4A0419
	Offset: 0x1D08
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_8bb97e0()
{
	foreach(player in level.players)
	{
		player thread function_ee166ee8();
	}
	callback::on_spawned(&function_ee166ee8);
	callback::on_ai_killed(&function_85ed003e);
}

/*
	Name: function_85ed003e
	Namespace: namespace_37a1dc33
	Checksum: 0x83940A47
	Offset: 0x1DE0
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function function_85ed003e(params)
{
	var_8c90e32b = util::getweaponclass(params.weapon);
	if(self.archetype === "robot" && var_8c90e32b === "weapon_cqb")
	{
		player = params.eattacker;
		player.var_89be6da0++;
		if(player.var_89be6da0 >= 8)
		{
			player notify(#"hash_c113aa12");
		}
	}
}

/*
	Name: function_ee166ee8
	Namespace: namespace_37a1dc33
	Checksum: 0xFA6E1C5D
	Offset: 0x1E98
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_ee166ee8()
{
	self endon(#"death");
	self.var_89be6da0 = 0;
	self waittill(#"reload");
	wait(0.05);
	self thread function_ee166ee8();
}

/*
	Name: function_80820e19
	Namespace: namespace_37a1dc33
	Checksum: 0xF1321C52
	Offset: 0x1EE8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_80820e19()
{
	var_4fa896d4 = getent("newworld_accolade_15", "targetname");
	var_4fa896d4 thread function_14316bd1();
}

/*
	Name: function_14316bd1
	Namespace: namespace_37a1dc33
	Checksum: 0x8BDB8ABC
	Offset: 0x1F38
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_14316bd1()
{
	level endon(#"hash_f7bb45b");
	while(true)
	{
		self waittill(#"trigger", ent);
		if(isplayer(ent) && ent iswallrunning())
		{
			a_trace = bullettrace(ent.origin, ent.origin - vectorscale((0, 0, 1), 1000), 0, ent);
			if(isdefined(a_trace["entity"]) && a_trace["entity"].script_noteworthy === "chase_train")
			{
				ent notify(#"hash_fda475d4");
			}
		}
	}
}

