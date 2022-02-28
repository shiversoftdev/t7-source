// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace achievements;

/*
	Name: __init__sytem__
	Namespace: achievements
	Checksum: 0xD606CA34
	Offset: 0x548
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("achievements", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: achievements
	Checksum: 0xCB5B452B
	Offset: 0x588
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
	callback::on_ai_spawned(&on_ai_spawned);
	callback::on_ai_damage(&on_ai_damage);
	callback::on_ai_killed(&on_ai_killed);
	callback::on_player_killed(&on_player_death);
	spawner::add_archetype_spawn_function("wasp", &function_632712d7, 3);
	function_4462a8b7();
}

/*
	Name: function_4462a8b7
	Namespace: achievements
	Checksum: 0x895DB7E7
	Offset: 0x678
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function function_4462a8b7()
{
	level.var_a4d4c1e3["cp_mi_cairo_aquifer"] = "CP_COMPLETE_AQUIFER";
	level.var_a4d4c1e3["cp_mi_sing_biodomes"] = "CP_COMPLETE_BIODOMES";
	level.var_a4d4c1e3["cp_mi_sing_blackstation"] = "CP_COMPLETE_BLACKSTATION";
	level.var_a4d4c1e3["cp_mi_cairo_infection"] = "CP_COMPLETE_INFECTION";
	level.var_a4d4c1e3["cp_mi_cairo_lotus"] = "CP_COMPLETE_LOTUS";
	level.var_a4d4c1e3["cp_mi_zurich_newworld"] = "CP_COMPLETE_NEWWORLD";
	level.var_a4d4c1e3["cp_mi_eth_prologue"] = "CP_COMPLETE_PROLOGUE";
	level.var_a4d4c1e3["cp_mi_cairo_ramses"] = "CP_COMPLETE_RAMSES";
	level.var_a4d4c1e3["cp_mi_sing_sgen"] = "CP_COMPLETE_SGEN";
	level.var_a4d4c1e3["cp_mi_sing_vengeance"] = "CP_COMPLETE_VENGEANCE";
}

/*
	Name: give_achievement
	Namespace: achievements
	Checksum: 0x188EF673
	Offset: 0x7A0
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function give_achievement(str_id, var_56503a18 = 0)
{
	if(sessionmodeiscampaignzombiesgame() && !var_56503a18)
	{
		return;
	}
	/#
		printtoprightln("" + str_id, (1, 1, 1));
		println("" + str_id);
	#/
	self giveachievement(str_id);
}

/*
	Name: on_player_connect
	Namespace: achievements
	Checksum: 0xF3D0C2ED
	Offset: 0x858
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self endon(#"disconnect");
	self.var_75cf9e2e = spawnstruct();
	self.var_75cf9e2e.killindex = 0;
	self.var_75cf9e2e.var_940a9f6e = 0;
	self.var_75cf9e2e.kills = [];
	self.var_75cf9e2e.var_43311285 = [];
	self thread function_34eaa01b();
	self thread function_e587e1f2();
	while(true)
	{
		self waittill(#"give_achievement", str_id);
		give_achievement(str_id);
	}
}

/*
	Name: function_5f2f7800
	Namespace: achievements
	Checksum: 0x94943805
	Offset: 0x948
	Size: 0x74
	Parameters: 3
	Flags: Linked
*/
function function_5f2f7800(eplayer, levelname, difficulty)
{
	if(!isdefined(levelname) || !isdefined(level.var_a4d4c1e3[levelname]))
	{
		return;
	}
	if(difficulty < 2)
	{
		return;
	}
	eplayer give_achievement(level.var_a4d4c1e3[levelname]);
}

/*
	Name: function_c3e7ff05
	Namespace: achievements
	Checksum: 0x5DAB7B87
	Offset: 0x9C8
	Size: 0x244
	Parameters: 1
	Flags: Linked
*/
function function_c3e7ff05(eplayer)
{
	var_44a14bc7 = [];
	for(index = 0; index <= 4; index++)
	{
		var_44a14bc7[index] = 0;
	}
	mission_list = skipto::function_23eda99c();
	var_f0ecfb92 = 0;
	foreach(mission in mission_list)
	{
		if(!eplayer getdstat("PlayerStatsByMap", mission, "hasBeenCompleted"))
		{
			continue;
		}
		highestdifficulty = eplayer getdstat("PlayerStatsByMap", mission, "highestStats", "HIGHEST_DIFFICULTY");
		if(!isdefined(var_44a14bc7[highestdifficulty]))
		{
			var_44a14bc7[highestdifficulty] = 0;
		}
		var_44a14bc7[highestdifficulty]++;
		var_f0ecfb92++;
	}
	var_98680dde = mission_list.size;
	if(var_f0ecfb92 == var_98680dde)
	{
		eplayer give_achievement("CP_CAMPAIGN_COMPLETE");
	}
	if(((var_44a14bc7[2] + var_44a14bc7[3]) + var_44a14bc7[4]) == var_98680dde)
	{
		eplayer give_achievement("CP_HARD_COMPLETE");
	}
	if(var_44a14bc7[4] == var_98680dde)
	{
		eplayer give_achievement("CP_REALISTIC_COMPLETE");
	}
}

/*
	Name: function_733a6065
	Namespace: achievements
	Checksum: 0x5DC98F99
	Offset: 0xC18
	Size: 0x64
	Parameters: 4
	Flags: Linked
*/
function function_733a6065(eplayer, levelname, difficulty, var_10c5a3ef)
{
	if(!var_10c5a3ef)
	{
		function_5f2f7800(eplayer, levelname, difficulty);
		function_c3e7ff05(eplayer);
	}
}

/*
	Name: function_34eaa01b
	Namespace: achievements
	Checksum: 0x609CFD03
	Offset: 0xC88
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function function_34eaa01b()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"wallrun_begin");
		v_start = self.origin;
		self waittill(#"wallrun_end");
		var_1d634a25 = distance(v_start, self.origin);
		n_current_dist = self getdstat("Achievements", "CP_COMPLETE_WALL_RUN");
		n_current_dist = n_current_dist + var_1d634a25;
		/#
			printtoprightln(n_current_dist, (1, 1, 1));
		#/
		if(n_current_dist >= 9843)
		{
			give_achievement("CP_COMPLETE_WALL_RUN");
			return;
		}
		self setdstat("Achievements", "CP_COMPLETE_WALL_RUN", int(n_current_dist));
	}
}

/*
	Name: on_ai_spawned
	Namespace: achievements
	Checksum: 0x99EC1590
	Offset: 0xDC8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_ai_spawned()
{
}

/*
	Name: on_ai_damage
	Namespace: achievements
	Checksum: 0x94078186
	Offset: 0xDD8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function on_ai_damage(s_params)
{
	self.var_74390712 = undefined;
	if(isplayer(s_params.eattacker))
	{
		if(s_params.idflags & 8)
		{
			self.var_74390712 = s_params.eattacker;
		}
	}
}

/*
	Name: on_player_death
	Namespace: achievements
	Checksum: 0xE1AEB598
	Offset: 0xE48
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function on_player_death(s_params)
{
	self.var_75cf9e2e.killindex = 0;
	self.var_75cf9e2e.var_940a9f6e = 0;
	self.var_75cf9e2e.kills = [];
	self.var_75cf9e2e.var_43311285 = [];
}

/*
	Name: function_1121f26a
	Namespace: achievements
	Checksum: 0x31717BFD
	Offset: 0xEB0
	Size: 0x16C
	Parameters: 2
	Flags: Linked, Private
*/
function private function_1121f26a(var_c856ad1d, evictim)
{
	if(isdefined(var_c856ad1d.hijacked_vehicle_entity))
	{
		var_1efe785f = distance(var_c856ad1d.hijacked_vehicle_entity.origin, evictim.origin);
	}
	else
	{
		var_1efe785f = distance(var_c856ad1d.origin, evictim.origin);
	}
	if(var_1efe785f >= 3937)
	{
		var_46907f23 = var_c856ad1d getdstat("Achievements", "CP_DISTANCE_KILL");
		var_46907f23++;
		/#
			printtoprightln((("" + var_1efe785f) + "") + var_46907f23, (1, 1, 1));
		#/
		if(var_46907f23 >= 5)
		{
			var_c856ad1d give_achievement("CP_DISTANCE_KILL");
		}
		else
		{
			var_c856ad1d setdstat("Achievements", "CP_DISTANCE_KILL", var_46907f23);
		}
	}
}

/*
	Name: function_914b8688
	Namespace: achievements
	Checksum: 0x82E2B9B4
	Offset: 0x1028
	Size: 0x48C
	Parameters: 4
	Flags: Linked, Private
*/
function private function_914b8688(player, evictim, weapon, einflictor)
{
	if(!isdefined(weapon))
	{
		return;
	}
	if(!isdefined(player.var_58477d59))
	{
		player.var_58477d59 = [];
		player.var_58477d59["CP_FLYING_WASP_KILL"] = 0;
		player.var_58477d59["CP_COMBAT_ROBOT_KILL"] = 0;
	}
	var_9663b3f1 = 0;
	if(weapon.name == "gadget_firefly_swarm" || weapon.name == "gadget_firefly_swarm_upgraded")
	{
		function_9dab90e7(player);
		var_9663b3f1 = 1;
	}
	else
	{
		if(isdefined(player.var_75cf9e2e.var_6ce188b0) && weapon.name == "gadget_unstoppable_force" || weapon.name == "gadget_unstoppable_force_upgraded")
		{
			player.var_75cf9e2e.var_6ce188b0++;
			if(player.var_75cf9e2e.var_6ce188b0 >= 5)
			{
				player give_achievement("CP_UNSTOPPABLE_KILL");
			}
		}
		else
		{
			if(isdefined(player.hijacked_vehicle_entity))
			{
				if(isdefined(player.hijacked_vehicle_entity.killcount))
				{
					player.hijacked_vehicle_entity.killcount++;
				}
				else
				{
					player.hijacked_vehicle_entity.killcount = 1;
				}
				if(player.hijacked_vehicle_entity.scriptvehicletype == "wasp" && player.hijacked_vehicle_entity.killcount >= 20)
				{
					if(!player.var_58477d59["CP_FLYING_WASP_KILL"])
					{
						player give_achievement("CP_FLYING_WASP_KILL");
						player.var_58477d59["CP_FLYING_WASP_KILL"] = 1;
					}
				}
				if(player.hijacked_vehicle_entity.killcount >= 10)
				{
					if(!player.var_58477d59["CP_COMBAT_ROBOT_KILL"])
					{
						player give_achievement("CP_COMBAT_ROBOT_KILL");
						player.var_58477d59["CP_COMBAT_ROBOT_KILL"] = 1;
					}
				}
			}
			else if(isai(einflictor) && isdefined(einflictor.remote_owner) && einflictor.remote_owner == player)
			{
				if(isdefined(einflictor.killcount))
				{
					einflictor.killcount++;
				}
				else
				{
					einflictor.killcount = 1;
				}
				if(einflictor.killcount >= 10)
				{
					if(!player.var_58477d59["CP_COMBAT_ROBOT_KILL"])
					{
						player give_achievement("CP_COMBAT_ROBOT_KILL");
						player.var_58477d59["CP_COMBAT_ROBOT_KILL"] = 1;
					}
				}
			}
		}
	}
	if(isdefined(evictim.swarm) && !var_9663b3f1)
	{
		function_9dab90e7(player);
	}
	if(isdefined(player.var_75cf9e2e.var_a4fb0163) && player.var_75cf9e2e.var_a4fb0163 >= 6)
	{
		player give_achievement("CP_FIREFLIES_KILL");
	}
}

/*
	Name: function_2b2fb40b
	Namespace: achievements
	Checksum: 0x4F15C880
	Offset: 0x14C0
	Size: 0x17C
	Parameters: 3
	Flags: Linked, Private
*/
function private function_2b2fb40b(player, var_aae1ed0d, weapon)
{
	player.var_75cf9e2e.var_940a9f6e++;
	currentindex = player.var_75cf9e2e.killindex;
	player.var_75cf9e2e.kills[currentindex] = gettime();
	player.var_75cf9e2e.killindex = (currentindex + 1) % 10;
	if(player.var_75cf9e2e.var_940a9f6e < 10)
	{
		return;
	}
	startindex = (currentindex + 1) % 10;
	starttime = player.var_75cf9e2e.kills[startindex];
	endtime = player.var_75cf9e2e.kills[currentindex];
	if(player.var_75cf9e2e.var_940a9f6e >= 10 && (endtime - starttime) <= 3000)
	{
		player give_achievement("CP_TIMED_KILL");
	}
}

/*
	Name: function_b1d71bd3
	Namespace: achievements
	Checksum: 0x25E2B1F9
	Offset: 0x1648
	Size: 0x18C
	Parameters: 2
	Flags: Linked, Private
*/
function private function_b1d71bd3(player, weapon)
{
	var_4c26012 = getbaseweaponitemindex(weapon);
	if(!isdefined(var_4c26012) || (var_4c26012 < 1 || var_4c26012 > 60))
	{
		return;
	}
	player.var_75cf9e2e.var_43311285[weapon.rootweapon.name] = gettime();
	var_6c46ba29 = 0;
	var_376861f6 = gettime() - 30000;
	if(var_376861f6 < 0)
	{
		var_376861f6 = 0;
	}
	foreach(lastkilltime in player.var_75cf9e2e.var_43311285)
	{
		if(lastkilltime > var_376861f6)
		{
			var_6c46ba29++;
		}
	}
	if(var_6c46ba29 >= 5)
	{
		player give_achievement("CP_DIFFERENT_GUN_KILL");
	}
}

/*
	Name: function_307b3ac3
	Namespace: achievements
	Checksum: 0x727CB614
	Offset: 0x17E0
	Size: 0x24C
	Parameters: 3
	Flags: Linked, Private
*/
function private function_307b3ac3(eplayer, evictim, var_433291aa)
{
	if(!evictim util::isentstunned() || evictim.team !== "axis")
	{
		return;
	}
	if(!isdefined(eplayer.var_75cf9e2e.var_6a670270))
	{
		eplayer.var_75cf9e2e.var_6a670270 = [];
	}
	if(!isdefined(eplayer.var_75cf9e2e.var_6a670270))
	{
		eplayer.var_75cf9e2e.var_6a670270 = [];
	}
	else if(!isarray(eplayer.var_75cf9e2e.var_6a670270))
	{
		eplayer.var_75cf9e2e.var_6a670270 = array(eplayer.var_75cf9e2e.var_6a670270);
	}
	eplayer.var_75cf9e2e.var_6a670270[eplayer.var_75cf9e2e.var_6a670270.size] = gettime();
	startindex = eplayer.var_75cf9e2e.var_6a670270.size - 1;
	maxtime = gettime() - 3000;
	for(var_7b5c89e6 = startindex; var_7b5c89e6 >= 0; var_7b5c89e6--)
	{
		if(eplayer.var_75cf9e2e.var_6a670270[var_7b5c89e6] < maxtime)
		{
			arrayremoveindex(eplayer.var_75cf9e2e.var_6a670270, var_7b5c89e6);
		}
	}
	if(eplayer.var_75cf9e2e.var_6a670270.size >= 5)
	{
		eplayer give_achievement("CP_TIMED_STUNNED_KILL");
	}
}

/*
	Name: function_c4f2de38
	Namespace: achievements
	Checksum: 0xC41A2FC8
	Offset: 0x1A38
	Size: 0xEC
	Parameters: 3
	Flags: Linked, Private
*/
function private function_c4f2de38(player, victim, inflictor)
{
	if(!isdefined(inflictor.weapon) || !isdefined(self.scriptvehicletype) || self.scriptvehicletype != "wasp" || inflictor.weapon.type != "grenade")
	{
		return;
	}
	if(!isdefined(inflictor.var_9bbaef3))
	{
		inflictor.var_9bbaef3 = 1;
	}
	else
	{
		inflictor.var_9bbaef3++;
	}
	if(inflictor.var_9bbaef3 >= 3)
	{
		player give_achievement("CP_KILL_WASPS");
	}
}

/*
	Name: function_17ec453c
	Namespace: achievements
	Checksum: 0x3027EED4
	Offset: 0x1B30
	Size: 0xC4
	Parameters: 3
	Flags: Linked
*/
function function_17ec453c(eattacker, evictim, var_433291aa)
{
	if(isdefined(eattacker.iffowner) && isplayer(eattacker.iffowner))
	{
		if(isdefined(eattacker.killcount))
		{
			eattacker.killcount++;
		}
		else
		{
			eattacker.killcount = 1;
		}
		if(eattacker.killcount >= 10)
		{
			eattacker.iffowner give_achievement("CP_COMBAT_ROBOT_KILL");
		}
	}
}

/*
	Name: function_99d6210d
	Namespace: achievements
	Checksum: 0x19CB686E
	Offset: 0x1C00
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function function_99d6210d(eplayer, evictim)
{
	if(isdefined(evictim.var_74390712) && evictim.var_74390712 == eplayer && evictim.team !== "allies")
	{
		eplayer give_achievement("CP_OBSTRUCTED_KILL");
	}
}

/*
	Name: function_fbe029db
	Namespace: achievements
	Checksum: 0xFCE6693E
	Offset: 0x1C88
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_fbe029db(eplayer)
{
	var_ba8faef8 = eplayer getmeleechaincount();
	if(2 <= var_ba8faef8)
	{
		eplayer give_achievement("CP_MELEE_COMBO_KILL");
	}
}

/*
	Name: on_ai_killed
	Namespace: achievements
	Checksum: 0x38B1BD89
	Offset: 0x1CF0
	Size: 0x1AC
	Parameters: 1
	Flags: Linked
*/
function on_ai_killed(s_params)
{
	if(isplayer(s_params.eattacker))
	{
		player = s_params.eattacker;
		function_1121f26a(player, self);
		function_914b8688(player, self, s_params.weapon, s_params.einflictor);
		function_fbe029db(player);
		function_2b2fb40b(player, self, s_params.weapon);
		function_b1d71bd3(player, s_params.weapon);
		function_c4f2de38(player, self, s_params.einflictor);
		function_307b3ac3(player, self, s_params.weapon);
		function_99d6210d(player, self);
	}
	else if(isai(s_params.eattacker))
	{
		function_17ec453c(s_params.eattacker, self, s_params.weapon);
	}
}

/*
	Name: function_632712d7
	Namespace: achievements
	Checksum: 0x6A438277
	Offset: 0x1EA8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_632712d7(n_count)
{
}

/*
	Name: function_9dab90e7
	Namespace: achievements
	Checksum: 0xF271B138
	Offset: 0x1EC0
	Size: 0x60
	Parameters: 1
	Flags: Linked, Private
*/
function private function_9dab90e7(player)
{
	if(!isdefined(player.var_75cf9e2e.var_a4fb0163))
	{
		player.var_75cf9e2e.var_a4fb0163 = 1;
	}
	else
	{
		player.var_75cf9e2e.var_a4fb0163++;
	}
}

/*
	Name: function_e587e1f2
	Namespace: achievements
	Checksum: 0x3D213ABF
	Offset: 0x1F28
	Size: 0xAC
	Parameters: 0
	Flags: Linked, Private
*/
function private function_e587e1f2()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"gun_level_complete", rewardxp, attachmentindex, itemindex, rankid, islastrank);
		if(islastrank && (itemindex >= 1 && itemindex <= 60))
		{
			self give_achievement("CP_ALL_WEAPON_ATTACHMENTS");
			break;
		}
	}
}

/*
	Name: checkweaponchallengecomplete
	Namespace: achievements
	Checksum: 0xDB95929F
	Offset: 0x1FE0
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function checkweaponchallengecomplete(var_e9af7d73)
{
	if(var_e9af7d73 == 3)
	{
		self give_achievement("CP_ALL_WEAPON_CAMOS");
	}
}

/*
	Name: function_b2d1aafa
	Namespace: achievements
	Checksum: 0x31223000
	Offset: 0x2020
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_b2d1aafa()
{
	if(level.cybercom.var_12f85dec == 0)
	{
		foreach(player in level.players)
		{
			if(!isdefined(player.var_75cf9e2e.var_a4fb0163))
			{
				continue;
			}
			player.var_75cf9e2e.var_a4fb0163 = undefined;
		}
	}
}

/*
	Name: function_386309ce
	Namespace: achievements
	Checksum: 0xCE3AD276
	Offset: 0x20E8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_386309ce(player)
{
	player.var_75cf9e2e.var_6ce188b0 = 0;
}

/*
	Name: function_6903d776
	Namespace: achievements
	Checksum: 0x536761BA
	Offset: 0x2118
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function function_6903d776(var_44c1c544)
{
	if(isdefined(var_44c1c544.killcount))
	{
		var_44c1c544.killcount = undefined;
	}
}

