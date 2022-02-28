// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_achievements;
#using scripts\cp\_decorations;
#using scripts\cp\_util;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace challenges;

/*
	Name: __init__sytem__
	Namespace: challenges
	Checksum: 0xD8275CFE
	Offset: 0x5F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("challenges", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: challenges
	Checksum: 0x74775EF2
	Offset: 0x630
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_shared();
	callback::on_start_gametype(&start_gametype);
}

/*
	Name: start_gametype
	Namespace: challenges
	Checksum: 0x38E32DDB
	Offset: 0x670
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function start_gametype()
{
	if(!isdefined(level.challengescallbacks))
	{
		level.challengescallbacks = [];
	}
	waittillframeend();
	if(canprocesschallenges())
	{
		registerchallengescallback("actorKilled", &challengeactorkills);
		registerchallengescallback("actorDamaged", &function_e0360654);
		registerchallengescallback("VehicleKilled", &function_2acd9b03);
		registerchallengescallback("VehicleDamage", &challengeactorkills);
	}
	callback::on_connect(&on_player_connect);
	callback::on_connect(&function_dadf37f9);
}

/*
	Name: function_2acd9b03
	Namespace: challenges
	Checksum: 0x993A9A3D
	Offset: 0x790
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function function_2acd9b03(data, time)
{
	challengeactorkills(data, time);
}

/*
	Name: function_7d1957ed
	Namespace: challenges
	Checksum: 0xC5A0048
	Offset: 0x7C8
	Size: 0x2C
	Parameters: 2
	Flags: None
*/
function function_7d1957ed(data, time)
{
	function_e0360654(data, time);
}

/*
	Name: function_e0360654
	Namespace: challenges
	Checksum: 0x863CBAFF
	Offset: 0x800
	Size: 0x112
	Parameters: 2
	Flags: Linked
*/
function function_e0360654(data, time)
{
	if(isdefined(data))
	{
		switch(data.weapon.rootweapon.name)
		{
			case "emp_grenade":
			{
				break;
			}
			case "ravage_core_emp_grenade":
			case "ravage_core_emp_grenade_upg":
			{
				if(!isdefined(data.victim.var_fcad099b) && data.victim.archetype != "human")
				{
					data.attacker addplayerstat("cybercom_uses_esdamage", 1);
					data.attacker addplayerstat("cybercom_uses_ravagecore", 1);
					data.victim.var_fcad099b = 1;
				}
				break;
			}
		}
	}
}

/*
	Name: challengeactorkills
	Namespace: challenges
	Checksum: 0xB272C501
	Offset: 0x920
	Size: 0x5AC
	Parameters: 2
	Flags: Linked
*/
function challengeactorkills(data, time)
{
	if(isdefined(data))
	{
		if(isdefined(data.victim) && isdefined(data.victim.swarm))
		{
			data.attacker addplayerstat("cybercom_uses_fireflies", 1);
			data.attacker thread function_96ed590f("cybercom_uses_chaos");
		}
		if(isdefined(data.attacker.hijacked_vehicle_entity))
		{
			data.attacker addplayerstat("cybercom_uses_remotehijack", 1);
		}
		if(data.smeansofdeath == "MOD_GRENADE_SPLASH" || data.smeansofdeath == "MOD_ELECTROCUTED" || data.smeansofdeath == "MOD_GRENADE" || data.smeansofdeath == "MOD_EXPLOSIVE" || data.smeansofdeath == "MOD_BURNED" || data.smeansofdeath == "MOD_PROJECTILE_SPLASH")
		{
			if(data.weapon.rootweapon.name != "gadget_concussive_wave" && data.weapon.rootweapon.name != "hero_gravityspikes_cybercom_upgraded")
			{
				data.attacker addplayerstat("cybercom_uses_explosives", 1);
				if(isdefined(data.attacker.heroability))
				{
					if(data.attacker.heroability.name == "gadget_immolation_upgraded" || data.attacker.heroability.name == "gadget_immolation")
					{
						data.attacker notify(#"hash_a15c319", data.victim);
					}
				}
			}
		}
		switch(data.weapon.rootweapon.name)
		{
			case "gadget_rapid_strike":
			case "gadget_rapid_strike_upgraded":
			{
				data.attacker notify(#"hash_e11b0770");
				data.attacker thread function_4c17acc8();
				break;
			}
			case "gadget_immolation":
			case "gadget_immolation_upgraded":
			{
				if(isdefined(data.victim) && isdefined(data.attacker) && !isdefined(data.victim.var_e9560d5))
				{
					data.victim.var_e9560d5 = 1;
					data.attacker addplayerstat("cybercom_uses_immolation", 1);
					data.attacker thread function_8ef347b3(data.victim.origin);
				}
				break;
			}
			case "gadget_unstoppable_force":
			case "gadget_unstoppable_force_upgraded":
			{
				data.attacker addplayerstat("cybercom_uses_force", 1);
				data.attacker addplayerstat("cybercom_uses_martial", 1);
				break;
			}
			case "ravage_core_emp_grenade":
			case "ravage_core_emp_grenade_upg":
			{
				if(isdefined(data.victim) && !isdefined(data.victim.var_fcad099b))
				{
					data.attacker addplayerstat("cybercom_uses_ravagecore", 1);
					data.victim.var_fcad099b = 1;
				}
				break;
			}
			case "gadget_concussive_wave":
			case "hero_gravityspikes_cybercom_upgraded":
			{
				if(isvehicle(data.victim))
				{
					data.attacker addplayerstat("cybercom_uses_martial", 1);
					data.attacker addplayerstat("cybercom_uses_concussive", 1);
				}
				break;
			}
		}
		if(isdefined(data.attacker) && isplayer(data.attacker))
		{
			data.attacker decorations::function_2bc66a34();
		}
	}
}

/*
	Name: function_8ef347b3
	Namespace: challenges
	Checksum: 0xAC05F0D4
	Offset: 0xED8
	Size: 0x128
	Parameters: 1
	Flags: Linked
*/
function function_8ef347b3(v_location)
{
	self endon(#"death");
	self endon(#"hash_31573b44");
	if(!isdefined(v_location))
	{
		return;
	}
	self util::delay_notify(2, "stop_catching_immolation_secondaries");
	n_start_time = gettime();
	while((gettime() - n_start_time) < 2)
	{
		self waittill(#"hash_a15c319", e_enemy);
		if(!isdefined(e_enemy))
		{
			break;
		}
		if((length(v_location - e_enemy.origin)) < 200)
		{
			if(isdefined(e_enemy) && isdefined(self) && !isdefined(e_enemy.var_e9560d5))
			{
				e_enemy.var_e9560d5 = 1;
				self addplayerstat("cybercom_uses_immolation", 1);
			}
		}
	}
}

/*
	Name: function_4c17acc8
	Namespace: challenges
	Checksum: 0xC776FE1D
	Offset: 0x1008
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function function_4c17acc8()
{
	self endon(#"death");
	self endon(#"hash_534b9c4b");
	self util::delay_notify(2, "stop_catching_rapid_strike_attacks");
	n_start_time = gettime();
	while((gettime() - n_start_time) < 2)
	{
		self waittill(#"hash_e11b0770");
		self addplayerstat("cybercom_uses_rapidstrike", 1);
	}
}

/*
	Name: actorkilled
	Namespace: challenges
	Checksum: 0xAD7FFF03
	Offset: 0x10A0
	Size: 0x164
	Parameters: 6
	Flags: Linked
*/
function actorkilled(einflictor, attacker, idamage, smeansofdeath, weapon = level.weaponnone, shitloc)
{
	attacker endon(#"disconnect");
	data = spawnstruct();
	data.victim = self;
	data.einflictor = einflictor;
	data.attacker = attacker;
	data.idamage = idamage;
	data.smeansofdeath = smeansofdeath;
	data.weapon = weapon;
	data.shitloc = shitloc;
	data.time = gettime();
	data.victimweapon = data.victim.currentweapon;
	waitandprocessactorkilledcallback(data);
	data.attacker notify(#"actorkilledchallengesprocessed");
}

/*
	Name: waitandprocessactorkilledcallback
	Namespace: challenges
	Checksum: 0xF2197840
	Offset: 0x1210
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function waitandprocessactorkilledcallback(data)
{
	if(isdefined(data.attacker))
	{
		data.attacker endon(#"disconnect");
	}
	wait(0.05);
	util::waittillslowprocessallowed();
	level thread dochallengecallback("actorKilled", data);
	level thread doscoreeventcallback("actorKilled", data);
}

/*
	Name: actordamaged
	Namespace: challenges
	Checksum: 0x5DC5E347
	Offset: 0x12A8
	Size: 0x144
	Parameters: 5
	Flags: Linked
*/
function actordamaged(einflictor, attacker, idamage, weapon = level.weaponnone, shitloc)
{
	attacker endon(#"disconnect");
	data = spawnstruct();
	data.victim = self;
	data.einflictor = einflictor;
	data.attacker = attacker;
	data.idamage = idamage;
	data.weapon = weapon;
	data.shitloc = shitloc;
	data.time = gettime();
	data.victimweapon = data.victim.currentweapon;
	function_2a703585(data);
	data.attacker notify(#"hash_3cf360d1");
}

/*
	Name: function_2a703585
	Namespace: challenges
	Checksum: 0x4B995B36
	Offset: 0x13F8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_2a703585(data)
{
	if(isdefined(data.attacker))
	{
		data.attacker endon(#"disconnect");
	}
	wait(0.05);
	util::waittillslowprocessallowed();
	level thread dochallengecallback("actorDamaged", data);
}

/*
	Name: vehiclekilled
	Namespace: challenges
	Checksum: 0xE3C968F5
	Offset: 0x1470
	Size: 0x164
	Parameters: 6
	Flags: Linked
*/
function vehiclekilled(einflictor, attacker, idamage, smeansofdeath, weapon = level.weaponnone, shitloc)
{
	attacker endon(#"disconnect");
	data = spawnstruct();
	data.victim = self;
	data.einflictor = einflictor;
	data.attacker = attacker;
	data.idamage = idamage;
	data.smeansofdeath = smeansofdeath;
	data.weapon = weapon;
	data.shitloc = shitloc;
	data.time = gettime();
	data.victimweapon = data.victim.currentweapon;
	function_79c2e402(data);
	data.attacker notify(#"hash_962e5616");
}

/*
	Name: function_79c2e402
	Namespace: challenges
	Checksum: 0x117E1508
	Offset: 0x15E0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_79c2e402(data)
{
	if(isdefined(data.attacker))
	{
		data.attacker endon(#"disconnect");
	}
	wait(0.05);
	util::waittillslowprocessallowed();
	level thread dochallengecallback("VehicleKilled", data);
}

/*
	Name: vehicledamaged
	Namespace: challenges
	Checksum: 0x18D2845E
	Offset: 0x1658
	Size: 0x144
	Parameters: 5
	Flags: Linked
*/
function vehicledamaged(einflictor, attacker, idamage, weapon = level.weaponnone, shitloc)
{
	attacker endon(#"disconnect");
	data = spawnstruct();
	data.victim = self;
	data.einflictor = einflictor;
	data.attacker = attacker;
	data.idamage = idamage;
	data.weapon = weapon;
	data.shitloc = shitloc;
	data.time = gettime();
	data.victimweapon = data.victim.currentweapon;
	function_c0fc6584(data);
	data.attacker notify(#"hash_37eb53e2");
}

/*
	Name: function_c0fc6584
	Namespace: challenges
	Checksum: 0xA9095C
	Offset: 0x17A8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_c0fc6584(data)
{
	if(isdefined(data.attacker))
	{
		data.attacker endon(#"disconnect");
	}
	wait(0.05);
	util::waittillslowprocessallowed();
	level thread dochallengecallback("VehicleDamaged", data);
}

/*
	Name: function_85ec34dc
	Namespace: challenges
	Checksum: 0xF525F3C3
	Offset: 0x1820
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_85ec34dc()
{
	self thread function_96ed590f("career_decorations");
}

/*
	Name: function_96ed590f
	Namespace: challenges
	Checksum: 0xD204CEAE
	Offset: 0x1850
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function function_96ed590f(statname, n_amount = 1)
{
	self endon(#"disconnect");
	if(!isplayer(self))
	{
		return;
	}
	self addplayerstat(statname, n_amount);
}

/*
	Name: function_dadf37f9
	Namespace: challenges
	Checksum: 0xF86D77FB
	Offset: 0x18C0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_dadf37f9()
{
	self.challenge_callback_cp = &function_97666686;
	/#
		self thread function_4f96d6bd();
	#/
}

/*
	Name: function_7fd6c70d
	Namespace: challenges
	Checksum: 0x1AC98396
	Offset: 0x1900
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function function_7fd6c70d(challenge_index)
{
	return tablelookup("gamedata/stats/cp/statsmilestones3.csv", 0, challenge_index, 5);
}

/*
	Name: function_97666686
	Namespace: challenges
	Checksum: 0x396AB483
	Offset: 0x1938
	Size: 0x216
	Parameters: 7
	Flags: Linked
*/
function function_97666686(rewardxp, maxval, row, tablenumber, challengetype, itemindex, challengeindex)
{
	self function_5bb05b72();
	if(challengeindex == 565)
	{
		self givedecoration("cp_medal_all_accolades");
	}
	tier = int(tablelookup("gamedata/stats/cp/statsmilestones3.csv", 0, challengeindex, 1));
	switch(challengetype)
	{
		case 0:
		{
			challengename = function_7fd6c70d(challengeindex);
			switch(challengename)
			{
				case "CP_CHALLENGES_CAREER_MASTERY":
				{
					break;
				}
				case "CP_CHALLENGES_ALL_COMPLETE":
				{
					self givedecoration("cp_medal_all_calling_cards");
					break;
				}
			}
			break;
		}
		case 1:
		{
			if(itemindex != 0)
			{
				self setdstat("ItemStats", itemindex, "challengeCompleted", tier, 1);
				self achievements::checkweaponchallengecomplete(tier);
			}
			break;
		}
		case 4:
		{
			var_2de0b3d4 = tablelookup("gamedata/stats/cp/statsmilestones3.csv", 0, challengeindex, 13);
			self setdstat("Attachments", var_2de0b3d4, "challengeCompleted", tier, 1);
			break;
		}
	}
}

/*
	Name: function_5bb05b72
	Namespace: challenges
	Checksum: 0x36B617A0
	Offset: 0x1B58
	Size: 0x2AC
	Parameters: 0
	Flags: Linked
*/
function function_5bb05b72()
{
	if(sessionmodeisonlinegame())
	{
		return;
	}
	var_671e7f8c = self getdstat("PlayerStatsList", "cp_challenges", "statValue");
	if(var_671e7f8c > 0)
	{
		var_2b0fb6af = tablelookuprowcount("gamedata/stats/cp/statsmilestones3.csv");
		challenge_data = [];
		for(i = 0; i < (var_2b0fb6af - 1); i++)
		{
			challenge_data = tablelookuprow("gamedata/stats/cp/statsmilestones3.csv", i);
			var_ec486758 = challenge_data[3];
			if(var_ec486758 == "global")
			{
				challenge_stat_name = challenge_data[4];
				if(isdefined(challenge_stat_name) && challenge_stat_name != "")
				{
					var_db5490e3 = self getdstat("PlayerStatsList", challenge_stat_name, "statValue");
					if(challenge_data[10] != "")
					{
						var_60596ad1 = int(challenge_data[2]);
						if(var_db5490e3 >= var_60596ad1)
						{
							var_9050c19b = "";
							var_9050c19b = challenge_data[16];
							switch(var_9050c19b)
							{
								case "missions":
								{
									self addplayerstat("conf_gamemode_mastery", 1);
									break;
								}
								case "tott":
								{
									self addplayerstat("hq_gamemode_mastery", 1);
									break;
								}
								case "career":
								{
									self addplayerstat("career_mastery", 1);
									break;
								}
							}
						}
					}
				}
			}
		}
		self setdstat("PlayerStatsList", "cp_challenges", "StatValue", 0);
	}
}

/*
	Name: function_4f96d6bd
	Namespace: challenges
	Checksum: 0xF99A4F15
	Offset: 0x1E10
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function function_4f96d6bd()
{
	/#
		while(true)
		{
			if(getdvarint("", 0) == 1)
			{
				self function_f2d8f1d0();
				setdvar("", 0);
			}
			wait(0.1);
		}
	#/
}

/*
	Name: function_f2d8f1d0
	Namespace: challenges
	Checksum: 0x52124038
	Offset: 0x1E88
	Size: 0x4CA
	Parameters: 0
	Flags: Linked
*/
function function_f2d8f1d0()
{
	/#
		var_2884746a = [];
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		array::add(var_2884746a, "");
		foreach(challenge in var_2884746a)
		{
			self addplayerstat(challenge, 1000);
			iprintln("" + challenge);
			wait(1);
		}
	#/
}

