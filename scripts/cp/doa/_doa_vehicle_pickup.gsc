// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_enemy;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\cp\doa\_doa_round;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_sfx;
#using scripts\cp\doa\_doa_utility;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");
#using_animtree("chicken_mech");

#namespace namespace_2848f8c2;

/*
	Name: init
	Namespace: namespace_2848f8c2
	Checksum: 0x2741869E
	Offset: 0x4D8
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.doa.var_b3040642 = getent("doa_heli", "targetname");
	level.doa.var_37219336 = getent("doa_siegebot", "targetname");
	level.doa.var_1179f89e = getent("doa_tank", "targetname");
	level.doa.var_95dee038 = getent("doa_rapps", "targetname");
	level.doa.var_82433985 = getent("doa_quadtank", "targetname");
	level.doa.var_32e07142 = getent("doa_siegechicken", "targetname");
}

/*
	Name: function_254eefd6
	Namespace: namespace_2848f8c2
	Checksum: 0x806E5972
	Offset: 0x608
	Size: 0x60
	Parameters: 2
	Flags: Linked
*/
function function_254eefd6(player, time)
{
	self endon(#"death");
	player endon(#"disconnect");
	player endon(#"hash_d28ba89d");
	level doa_utility::function_124b9a08();
	wait(time);
	player notify(#"hash_d28ba89d");
}

/*
	Name: function_ab709357
	Namespace: namespace_2848f8c2
	Checksum: 0xDD49BA42
	Offset: 0x670
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function function_ab709357(heli)
{
	self endon(#"hash_e8bfbd2b");
	while(isdefined(heli))
	{
		self.doa.var_8d2d32e7 = doa_utility::function_1c0abd70(heli.origin, 128, heli);
		wait(0.5);
	}
}

/*
	Name: function_f27a22c8
	Namespace: namespace_2848f8c2
	Checksum: 0x702456AC
	Offset: 0x6D8
	Size: 0x404
	Parameters: 2
	Flags: Linked
*/
function function_f27a22c8(player, origin)
{
	if(isdefined(player.doa.vehicle) || (isdefined(player.doa.var_52cb4fb9) && player.doa.var_52cb4fb9))
	{
		return;
	}
	player endon(#"disconnect");
	player.doa.var_52cb4fb9 = 1;
	player namespace_831a4a7c::function_4519b17(1);
	player function_d460de4b();
	level.doa.var_b3040642.count = 999999;
	heli = level.doa.var_b3040642 spawner::spawn(1);
	heli thread doa_utility::function_24245456(player, "disconnect");
	player.doa.var_52cb4fb9 = undefined;
	player.doa.vehicle = heli;
	heli.origin = origin + vectorscale((0, 0, 1), 70);
	heli.angles = player.angles;
	heli.vehaircraftcollisionenabled = 1;
	heli.health = 9999999;
	heli.team = player.team;
	heli setmodel("veh_t7_drone_hunter_zombietron_" + namespace_831a4a7c::function_ee495f41(player.entnum));
	heli usevehicle(player, 0);
	heli makeunusable();
	heli setheliheightlock(1);
	heli.owner = player;
	heli.playercontrolled = 1;
	heli.var_aaffbea7 = 1;
	player thread function_ab709357(heli);
	heli thread function_254eefd6(player, int(player doa_utility::function_1ded48e6(level.doa.rules.var_cd899ae7)));
	player waittill(#"hash_d28ba89d");
	player notify(#"hash_e8bfbd2b");
	if(isdefined(heli))
	{
		heli makeusable();
		var_85f85940 = heli.origin;
		if(isdefined(player))
		{
			heli usevehicle(player, 0);
		}
		heli makeunusable();
	}
	if(isdefined(player))
	{
		player thread function_3b1b644d(var_85f85940, heli);
	}
	else
	{
		heli delete();
	}
}

/*
	Name: function_db948b3
	Namespace: namespace_2848f8c2
	Checksum: 0x34F2AA82
	Offset: 0xAE8
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_db948b3()
{
	self endon(#"death");
	while(true)
	{
		pos = self getgunnertargetvec(0);
		self setgunnertargetvec(pos, 1);
		wait(0.05);
	}
}

/*
	Name: function_569d8fe3
	Namespace: namespace_2848f8c2
	Checksum: 0x79DBD678
	Offset: 0xB50
	Size: 0x84
	Parameters: 0
	Flags: None
*/
function function_569d8fe3()
{
	self endon(#"death");
	var_d22e1ab8 = self seatgetweapon(2);
	while(true)
	{
		if(self isgunnerfiring(0))
		{
			self fireweapon(2);
			wait(var_d22e1ab8.firetime);
		}
		else
		{
			wait(0.05);
		}
	}
}

/*
	Name: function_ee6962d9
	Namespace: namespace_2848f8c2
	Checksum: 0x7279C81F
	Offset: 0xBE0
	Size: 0xE0
	Parameters: 2
	Flags: Linked
*/
function function_ee6962d9(player, chicken)
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"hash_e15b53df");
		if(!level flag::get("doa_round_active"))
		{
			continue;
		}
		spot = chicken gettagorigin("tail") + vectorscale((0, 0, -1), 32);
		chicken thread namespace_1a381543::function_90118d8c("zmb_golden_chicken_pop");
		level doa_pickups::function_3238133b(level.doa.var_43922ff2, spot, 1);
	}
}

/*
	Name: function_2ef99744
	Namespace: namespace_2848f8c2
	Checksum: 0x21EC7617
	Offset: 0xCC8
	Size: 0x604
	Parameters: 2
	Flags: Linked
*/
function function_2ef99744(player, origin)
{
	if(!isdefined(player) || isdefined(player.doa.vehicle) || (isdefined(player.doa.var_52cb4fb9) && player.doa.var_52cb4fb9))
	{
		return;
	}
	player endon(#"disconnect");
	player.doa.var_52cb4fb9 = 1;
	player namespace_831a4a7c::function_4519b17(1);
	player function_d460de4b();
	level.doa.var_32e07142.count = 99999;
	siegebot = level.doa.var_32e07142 spawner::spawn(1);
	chicken = spawn("script_model", origin);
	chicken.targetname = "fidoMech";
	chicken setmodel("zombietron_anim_chicken_nolegs");
	chicken enablelinkto();
	siegebot thread doa_utility::function_a625b5d3(player);
	chicken thread doa_utility::function_a625b5d3(player);
	chicken thread doa_utility::function_75e76155(siegebot, "death");
	siegebot thread function_ee6962d9(player, chicken);
	player.doa.var_52cb4fb9 = undefined;
	player.doa.vehicle = siegebot;
	siegebot.origin = origin;
	siegebot.angles = player.angles;
	siegebot.team = player.team;
	siegebot.owner = player;
	siegebot.playercontrolled = 1;
	siegebot usevehicle(player, 0);
	siegebot makeunusable();
	chicken linkto(siegebot, "tag_driver", vectorscale((0, 0, -1), 70), vectorscale((0, -1, 0), 120));
	siegebot.health = 9999999;
	siegebot hidepart("tag_turret", "", 1);
	siegebot hidepart("tag_nameplate", "", 1);
	siegebot hidepart("tag_turret_canopy_animate", "", 1);
	siegebot hidepart("tag_light_attach_left", "", 1);
	siegebot hidepart("tag_light_attach_right", "", 1);
	siegebot thread function_cdfa9ce8(chicken);
	siegebot thread function_db948b3();
	player notify(#"hash_e8bfbd2b");
	var_523635a2 = 1;
	if(player.doa.fate == 2)
	{
		var_523635a2 = level.doa.rules.var_f2d5f54d;
	}
	else if(player.doa.fate == 11)
	{
		var_523635a2 = level.doa.rules.var_b3d39edc;
	}
	siegebot thread function_254eefd6(player, int(player doa_utility::function_1ded48e6(level.doa.rules.var_13276655, var_523635a2)));
	player waittill(#"hash_d28ba89d");
	if(isdefined(siegebot))
	{
		var_85f85940 = siegebot.origin;
		siegebot makeusable();
		if(isdefined(player))
		{
			siegebot usevehicle(player, 0);
		}
		siegebot makeunusable();
	}
	if(isdefined(player))
	{
		player thread function_3b1b644d(var_85f85940, siegebot);
	}
	else
	{
		siegebot delete();
	}
	chicken delete();
}

/*
	Name: function_21af9396
	Namespace: namespace_2848f8c2
	Checksum: 0xE2D7DB70
	Offset: 0x12D8
	Size: 0x454
	Parameters: 2
	Flags: Linked
*/
function function_21af9396(player, origin)
{
	if(!isdefined(player) || isdefined(player.doa.vehicle) || (isdefined(player.doa.var_52cb4fb9) && player.doa.var_52cb4fb9))
	{
		return;
	}
	player endon(#"disconnect");
	player.doa.var_52cb4fb9 = 1;
	player namespace_831a4a7c::function_4519b17(1);
	player function_d460de4b();
	level.doa.var_37219336.count = 99999;
	siegebot = level.doa.var_37219336 spawner::spawn(1);
	siegebot thread doa_utility::function_24245456(player, "disconnect");
	player.doa.var_52cb4fb9 = undefined;
	player.doa.vehicle = siegebot;
	siegebot.origin = origin;
	siegebot.angles = player.angles;
	siegebot.team = player.team;
	siegebot.owner = player;
	siegebot.playercontrolled = 1;
	siegebot setmodel("zombietron_siegebot_mini_" + namespace_831a4a7c::function_ee495f41(player.entnum));
	siegebot usevehicle(player, 0);
	siegebot makeunusable();
	siegebot.health = 9999999;
	siegebot thread function_db948b3();
	player notify(#"hash_e8bfbd2b");
	var_523635a2 = 1;
	if(player.doa.fate == 2)
	{
		var_523635a2 = level.doa.rules.var_f2d5f54d;
	}
	else if(player.doa.fate == 11)
	{
		var_523635a2 = level.doa.rules.var_b3d39edc;
	}
	siegebot thread function_254eefd6(player, int(player doa_utility::function_1ded48e6(level.doa.rules.var_91e6add5, var_523635a2)));
	player waittill(#"hash_d28ba89d");
	if(isdefined(siegebot))
	{
		var_85f85940 = siegebot.origin;
		siegebot makeusable();
		if(isdefined(player))
		{
			siegebot usevehicle(player, 0);
		}
		siegebot makeunusable();
	}
	if(isdefined(player))
	{
		player thread function_3b1b644d(var_85f85940, siegebot);
	}
	else
	{
		siegebot delete();
	}
}

/*
	Name: function_1e663abe
	Namespace: namespace_2848f8c2
	Checksum: 0xA3DDA49C
	Offset: 0x1738
	Size: 0x39C
	Parameters: 2
	Flags: Linked
*/
function function_1e663abe(player, origin)
{
	if(isdefined(player.doa.vehicle) || (isdefined(player.doa.var_52cb4fb9) && player.doa.var_52cb4fb9))
	{
		return;
	}
	player endon(#"disconnect");
	player.doa.var_52cb4fb9 = 1;
	player namespace_831a4a7c::function_4519b17(1);
	player function_d460de4b();
	var_e34a8df9 = level.doa.var_95dee038 spawner::spawn(1);
	var_e34a8df9 thread doa_utility::function_24245456(player, "disconnect");
	player.doa.var_52cb4fb9 = undefined;
	player.doa.vehicle = var_e34a8df9;
	var_e34a8df9.origin = origin;
	var_e34a8df9.angles = player.angles;
	var_e34a8df9.team = player.team;
	var_e34a8df9.playercontrolled = 1;
	var_e34a8df9 setmodel("veh_t7_drone_raps_zombietron_" + namespace_831a4a7c::function_ee495f41(player.entnum));
	var_e34a8df9.owner = player;
	var_e34a8df9 usevehicle(player, 0);
	var_e34a8df9 makeunusable();
	var_e34a8df9.health = 9999999;
	player notify(#"hash_e8bfbd2b");
	var_e34a8df9 thread function_254eefd6(player, int(player doa_utility::function_1ded48e6(level.doa.rules.var_7196fe3d)));
	player waittill(#"hash_d28ba89d");
	if(isdefined(var_e34a8df9))
	{
		var_85f85940 = var_e34a8df9.origin;
		if(isdefined(player))
		{
			origin = var_e34a8df9.origin;
			var_e34a8df9 makeusable();
			if(isdefined(player))
			{
				var_e34a8df9 usevehicle(player, 0);
			}
			var_e34a8df9 makeunusable();
		}
	}
	if(isdefined(player))
	{
		player thread function_3b1b644d(var_85f85940, var_e34a8df9);
	}
	else
	{
		var_e34a8df9 delete();
	}
}

/*
	Name: function_e9f445ce
	Namespace: namespace_2848f8c2
	Checksum: 0xC64D7377
	Offset: 0x1AE0
	Size: 0x39C
	Parameters: 2
	Flags: Linked
*/
function function_e9f445ce(player, origin)
{
	if(isdefined(player.doa.vehicle) || (isdefined(player.doa.var_52cb4fb9) && player.doa.var_52cb4fb9))
	{
		return;
	}
	player endon(#"disconnect");
	player.doa.var_52cb4fb9 = 1;
	player namespace_831a4a7c::function_4519b17(1);
	player function_d460de4b();
	var_b22d6040 = level.doa.var_1179f89e spawner::spawn(1);
	var_b22d6040 thread doa_utility::function_24245456(player, "disconnect");
	player.doa.var_52cb4fb9 = undefined;
	player.doa.vehicle = var_b22d6040;
	var_b22d6040.origin = origin;
	var_b22d6040.angles = player.angles;
	var_b22d6040.team = player.team;
	var_b22d6040.playercontrolled = 1;
	var_b22d6040 setmodel("veh_t7_mil_tank_tiger_zombietron_" + namespace_831a4a7c::function_ee495f41(player.entnum));
	var_b22d6040 usevehicle(player, 0);
	var_b22d6040 makeunusable();
	var_b22d6040.health = 9999999;
	player notify(#"hash_e8bfbd2b");
	var_b22d6040.owner = player;
	var_b22d6040 thread function_254eefd6(player, int(player doa_utility::function_1ded48e6(level.doa.rules.var_8b15034d)));
	player waittill(#"hash_d28ba89d");
	if(isdefined(var_b22d6040))
	{
		var_85f85940 = var_b22d6040.origin;
		if(isdefined(player))
		{
			origin = var_b22d6040.origin;
			var_b22d6040 makeusable();
			if(isdefined(player))
			{
				var_b22d6040 usevehicle(player, 0);
			}
			var_b22d6040 makeunusable();
		}
	}
	if(isdefined(player))
	{
		player thread function_3b1b644d(var_85f85940, var_b22d6040);
	}
	else
	{
		var_b22d6040 delete();
	}
}

/*
	Name: function_d460de4b
	Namespace: namespace_2848f8c2
	Checksum: 0x84AC7005
	Offset: 0x1E88
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_d460de4b()
{
	if(!isdefined(self) || !isdefined(self.doa))
	{
		return;
	}
	self thread namespace_831a4a7c::function_7f33210a();
	self thread namespace_831a4a7c::function_f2507519(0);
	self thread namespace_eaa992c::turnofffx("boots");
	self thread namespace_eaa992c::turnofffx("slow_feet");
	self.doa.var_c2b9d7d0 = gettime();
	self notify(#"hash_8820b45b");
	self notify(#"kill_chickens");
	util::wait_network_frame();
}

/*
	Name: function_d41a4517
	Namespace: namespace_2848f8c2
	Checksum: 0xF989605B
	Offset: 0x1F60
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_d41a4517()
{
	if(!isdefined(self) || !isdefined(self.doa))
	{
		return;
	}
	self endon(#"disconnect");
	util::wait_network_frame();
	self thread namespace_831a4a7c::turnplayershieldon();
	self thread namespace_831a4a7c::function_f2507519(level.doa.arena_round_number == 3);
	self thread namespace_831a4a7c::function_b5843d4f(level.doa.arena_round_number == 3);
	if(isdefined(self.doa) && (isdefined(self.doa.var_d5c84825) && self.doa.var_d5c84825))
	{
		self thread namespace_eaa992c::function_285a2999("slow_feet");
	}
	if(isdefined(self.doa) && (isdefined(self.doa.fast_feet) && self.doa.fast_feet))
	{
		self thread namespace_eaa992c::function_285a2999("boots");
	}
}

/*
	Name: function_33f0cca4
	Namespace: namespace_2848f8c2
	Checksum: 0x6F48D8A4
	Offset: 0x20B0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_33f0cca4(player)
{
	self endon(#"death");
	player waittill(#"disconnect");
	self delete();
}

/*
	Name: function_3b1b644d
	Namespace: namespace_2848f8c2
	Checksum: 0x7A69A295
	Offset: 0x20F8
	Size: 0x212
	Parameters: 2
	Flags: Linked
*/
function function_3b1b644d(var_85f85940, vehicle)
{
	self.doa.var_ccf4ef81 = 1;
	self endon(#"disconnect");
	vehicle thread function_33f0cca4(self);
	self namespace_831a4a7c::function_4519b17(1);
	wait(0.05);
	self.ignoreme = 0;
	self.doa.vehicle = undefined;
	self.doa.var_8d2d32e7 = undefined;
	spot = self doa_utility::function_5bca1086();
	if(isdefined(spot))
	{
		trace = bullettrace(spot + vectorscale((0, 0, 1), 48), spot + vectorscale((0, 0, -1), 64), 0, undefined);
		spot = trace["position"];
		self setorigin(spot);
	}
	else
	{
		self setorigin(var_85f85940);
	}
	self namespace_831a4a7c::function_4519b17(0);
	self function_d41a4517();
	if(isdefined(self.doa.var_65f7f2a9) && self.doa.var_65f7f2a9)
	{
		self clientfield::increment_to_player("goFPS");
	}
	else
	{
		self clientfield::increment_to_player("controlBinding");
	}
	if(isdefined(vehicle))
	{
		vehicle delete();
	}
	self.doa.var_ccf4ef81 = undefined;
}

/*
	Name: function_cdfa9ce8
	Namespace: namespace_2848f8c2
	Checksum: 0xB454709E
	Offset: 0x2318
	Size: 0x132
	Parameters: 1
	Flags: Linked
*/
function function_cdfa9ce8(bird)
{
	bird notify(#"hash_cf62504");
	bird endon(#"hash_cf62504");
	bird endon(#"death");
	bird useanimtree($chicken_mech);
	bird.animation = (randomint(2) ? %chicken_mech::a_chicken_mech_idle : %chicken_mech::a_chicken_mech_lay_egg);
	while(isdefined(bird))
	{
		bird clientfield::set("runsiegechickenanim", 1);
		wait(randomintrange(1, 5));
		if(randomint(100) < 15)
		{
			bird clientfield::set("runsiegechickenanim", 2);
			wait(1);
			self notify(#"hash_e15b53df");
		}
	}
}

