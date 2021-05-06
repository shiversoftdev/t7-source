// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\cp_doa_bo3_enemy;
#using scripts\cp\cp_doa_bo3_silverback_battle;
#using scripts\cp\doa\_doa_arena;
#using scripts\cp\doa\_doa_audio;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_enemy;
#using scripts\cp\doa\_doa_enemy_boss;
#using scripts\cp\doa\_doa_fate;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_gibs;
#using scripts\cp\doa\_doa_hazard;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\cp\doa\_doa_round;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_sfx;
#using scripts\cp\doa\_doa_tesla_pickup;
#using scripts\cp\doa\_doa_turret_pickup;
#using scripts\cp\doa\_doa_utility;
#using scripts\cp\doa\_doa_vehicle_pickup;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;

#using_animtree("generic");

#namespace namespace_917e49b3;

/*
	Name: function_d4766377
	Namespace: namespace_917e49b3
	Checksum: 0x6BD79DB7
	Offset: 0xD98
	Size: 0x574
	Parameters: 0
	Flags: Linked
*/
function function_d4766377()
{
	if(!isdefined(level.doa.var_27f5178d))
	{
		level.doa.var_27f5178d = struct::get_array("podium_zombie_spectate", "targetname");
		level.doa.var_260a85f3 = array("c_zom_zod_zombie_cin_fb1", "c_zom_zod_zombie_cin_fb2", "c_zom_zod_zombie_cin_fb3", "c_zom_zod_zombie_fem_cin_fb1");
	}
	if(!isdefined(level.doa.var_799853ee))
	{
		level.doa.var_799853ee = getent("podium_damage_trigger", "targetname");
	}
	level.doa.var_799853ee triggerenable(0);
	if(!isdefined(level.doa.var_92721db3))
	{
		var_92721db3 = getentarray("podium_spot", "targetname");
		level.doa.var_92721db3 = [];
		for(i = 0; i < 4; i++)
		{
			for(j = 0; j < var_92721db3.size; j++)
			{
				if(i == int(var_92721db3[j].script_noteworthy))
				{
					end = level.doa.var_92721db3.size;
					level.doa.var_92721db3[end] = var_92721db3[j];
					level.doa.var_92721db3[end].position = i;
				}
			}
		}
	}
	foreach(var_19e1098b, podium in level.doa.var_92721db3)
	{
		if(isdefined(podium.var_53538eb0))
		{
			podium.var_53538eb0 delete();
		}
		if(isdefined(podium.playermodel))
		{
			podium.playermodel delete();
		}
		podium.player = undefined;
		podium hide();
		podium notsolid();
	}
	if(!isdefined(level.doa.var_b7f5f6c8))
	{
		var_b519899f = struct::get_array("podium_silverback", "targetname");
		level.doa.var_b7f5f6c8 = [];
		foreach(var_df802866, point in var_b519899f)
		{
			level.doa.var_b7f5f6c8[int(point.script_noteworthy)] = point;
		}
	}
	foreach(var_343e2beb, spot in level.doa.var_27f5178d)
	{
		if(isdefined(spot.spectator))
		{
			if(isdefined(spot.spectator.org))
			{
				spot.spectator.org delete();
			}
			spot.spectator delete();
		}
	}
	level clientfield::set("redinsExploder", 0);
	level clientfield::set("podiumEvent", 0);
}

/*
	Name: function_ef727812
	Namespace: namespace_917e49b3
	Checksum: 0xBA963CF9
	Offset: 0x1318
	Size: 0x2CC
	Parameters: 1
	Flags: Linked
*/
function function_ef727812(num)
{
	/#
		assert(isdefined(level.doa.var_92721db3));
	#/
	foreach(var_b6a7dd8, podium in level.doa.var_92721db3)
	{
		podium.var_53538eb0 = spawn("script_model", podium.origin);
		podium.var_53538eb0 thread doa_utility::function_783519c1("podiumAllDone", 1);
		podium.var_53538eb0 setmodel(podium.model);
		podium.var_53538eb0.angles = podium.angles;
		num--;
		if(num == 0)
		{
			break;
		}
	}
	level.doa.var_799853ee triggerenable(1);
	foreach(var_1acba872, spot in level.doa.var_27f5178d)
	{
		spot.spectator = spawn("script_model", spot.origin);
		spot.spectator thread doa_utility::function_783519c1("podiumAllDone", 1);
		spot.spectator.angles = spot.angles;
		spot.spectator thread function_5e06cff2();
	}
	level clientfield::set("podiumEvent", 1);
}

/*
	Name: function_a85eaca4
	Namespace: namespace_917e49b3
	Checksum: 0x46DC5F3
	Offset: 0x15F0
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_a85eaca4()
{
	level endon(#"hash_448ca7a6");
	players = function_4d8b6e1e();
	winner = players[0];
	while(true)
	{
		if(!isdefined(winner))
		{
			players = function_4d8b6e1e();
			winner = players[0];
		}
		if(!isdefined(winner))
		{
			return;
		}
		if(winner throwbuttonpressed())
		{
			level notify(#"hash_115c344c");
		}
		wait(0.05);
	}
}

/*
	Name: function_e2d6beb9
	Namespace: namespace_917e49b3
	Checksum: 0x3399359
	Offset: 0x16B8
	Size: 0x3CC
	Parameters: 0
	Flags: Linked
*/
function function_e2d6beb9()
{
	level clientfield::set("roundMenu", 0);
	level clientfield::set("teleportMenu", 0);
	level clientfield::set("numexits", 0);
	players = function_4d8b6e1e();
	function_ef727812(players.size);
	level.doa.var_44d58db8 = players;
	level.var_3997f9e8 = spawn("script_origin", (0, 0, 0));
	level.var_3997f9e8 playloopsound("evt_ending_zombies_looper", 3);
	i = 0;
	foreach(var_f18192b, player in players)
	{
		level.doa.var_92721db3[i].player = player;
		i++;
	}
	foreach(var_ffb6ee91, podium in level.doa.var_92721db3)
	{
		if(isdefined(podium.player))
		{
			level thread function_2b20420b(podium);
		}
	}
	level thread function_a85eaca4();
	level thread function_5e04bf78();
	level notify(#"hash_b96c96ac");
	level notify(#"hash_97276c43");
	wait(1);
	var_1a87bae6 = level.lighting_state;
	level thread doa_utility::set_lighting_state(1);
	level thread doa_utility::function_390adefe(0);
	level notify(#"hash_314666df");
	level thread function_d834fdd0();
	msg = level util::waittill_any_timeout(30, "silverbackAllDone");
	if(msg == "timeout")
	{
		level notify(#"hash_a099b4d6");
		level waittill(#"hash_115c344c");
	}
	level.var_3997f9e8 delete();
	doa_utility::function_44eb090b();
	level notify(#"hash_448ca7a6");
	function_d4766377();
	level thread doa_utility::function_13fbad22();
	level thread doa_utility::set_lighting_state(var_1a87bae6);
}

/*
	Name: function_5e04bf78
	Namespace: namespace_917e49b3
	Checksum: 0x525A5501
	Offset: 0x1A90
	Size: 0x12DE
	Parameters: 0
	Flags: Linked
*/
function function_5e04bf78()
{
	level endon(#"hash_115c344c");
	level waittill(#"hash_a099b4d6");
	point1 = level.doa.var_b7f5f6c8[0];
	point2 = level.doa.var_b7f5f6c8[1];
	point3 = level.doa.var_b7f5f6c8[2];
	org = spawn("script_model", point1.origin);
	org thread doa_utility::function_783519c1("podiumAllDone", 1);
	org setmodel("tag_origin");
	org2 = spawn("script_origin", org.origin + vectorscale((0, 0, 1), 2500));
	org2 thread doa_utility::function_783519c1("podiumAllDone", 1);
	org2.angles = point1.angles;
	playsoundatposition("zmb_ape_prespawn", org.origin);
	org thread namespace_eaa992c::function_285a2999("silverback_intro");
	wait(0.5);
	org thread namespace_eaa992c::function_285a2999("silverback_intro");
	org thread namespace_eaa992c::function_285a2999("stoneboss_shield_explode");
	wait(0.5);
	org thread namespace_eaa992c::function_285a2999("silverback_intro");
	org thread namespace_eaa992c::function_285a2999("stoneboss_shield_explode");
	wait(0.5);
	silverback = namespace_51bd792::function_36aa8b6c(org2);
	silverback thread doa_utility::function_783519c1("podiumAllDone", 1);
	silverback linkto(org2);
	silverback thread namespace_eaa992c::function_285a2999("player_trail_red");
	silverback thread namespace_eaa992c::function_285a2999("silverback_intro_trail1");
	silverback thread namespace_eaa992c::function_285a2999("silverback_intro_trail2");
	silverback forceteleport(org2.origin, org2.angles);
	org2 moveto(org.origin, 1);
	org2 util::waittill_any_timeout(1.5, "movedone");
	silverback.takedamage = 0;
	silverback thread namespace_eaa992c::function_285a2999("silverback_intro_explo");
	silverback thread namespace_eaa992c::turnofffx("silverback_intro_trail1");
	silverback thread namespace_eaa992c::turnofffx("silverback_intro_trail2");
	playrumbleonposition("explosion_generic", org.origin);
	playsoundatposition("zmb_ape_spawn", org.origin);
	silverback unlink();
	org2 delete();
	silverback playsound("zmb_simianaut_roar");
	silverback animscripted("pissedoff", silverback.origin, silverback.angles, "ai_zombie_doa_simianaut_ground_pound");
	silverback waittill_match(#"pissedoff");
	playfx(level._effect["ground_pound"], silverback.origin);
	silverback waittill_match(#"pissedoff");
	silverback playsound("zmb_simianaut_roar");
	silverback playsound("evt_turret_takeoff");
	silverback thread namespace_eaa992c::function_285a2999("boss_takeoff");
	silverback thread namespace_eaa992c::function_285a2999("crater_dust");
	playrumbleonposition("explosion_generic", silverback.origin);
	height = 800;
	timems = height / 1000 * 3000;
	org.angles = silverback.angles;
	org.origin = silverback.origin;
	silverback linkto(org);
	org namespace_a3646565::move_to_position_over_time(point2.origin, timems, height);
	silverback thread namespace_eaa992c::function_285a2999("turret_impact");
	silverback playsound("zmb_simianaut_roar");
	level.doa.var_63e2b87e = silverback;
	level notify(#"hash_5c2d4fa4", "end", "zombie_melee");
	level notify(#"hash_a284788a");
	wait(2);
	level thread function_46882430(&"DOA_ME_BACK", silverback.origin + vectorscale((0, 0, 1), 95), 2);
	wait(3);
	silverback playsound("zmb_simianaut_roar");
	wait(2);
	level thread function_46882430(&"DOA_MY_TREASURE", silverback.origin + vectorscale((0, 0, 1), 95), 2);
	wait(1.8);
	level notify(#"zombie_outro_mood_angry");
	level.doa.var_63e2b87e = level.doa.var_e102b46;
	silverback playsound("evt_turret_takeoff");
	silverback thread namespace_eaa992c::function_285a2999("boss_takeoff");
	silverback thread namespace_eaa992c::function_285a2999("crater_dust");
	playrumbleonposition("explosion_generic", silverback.origin);
	org.angles = silverback.angles;
	org.origin = silverback.origin;
	level notify(#"hash_ff1ecf6");
	org moveto(org.origin + vectorscale((0, 0, 1), 2000), 1.3);
	org util::waittill_any_timeout(1.5, "movedone");
	org.origin = point3.origin + vectorscale((0, 0, 1), 2000);
	org.angles = point3.angles;
	silverback delete();
	mech = level.doa.var_4f253f44 spawnfromspawner("silverback_mech", 1, 1, 1);
	mech thread doa_utility::function_783519c1("podiumAllDone", 1);
	mech ghost();
	wait(0.05);
	mech.origin = org.origin;
	mech.angles = org.angles;
	mech.nojumping = 1;
	mech vehicle_ai::start_scripted();
	mech.team = "axis";
	mech enablelinkto();
	mech.driver = spawn("script_model", mech gettagorigin("tag_driver"));
	mech.driver ghost();
	mech.driver thread doa_utility::function_783519c1("podiumAllDone", 1);
	mech.driver.angles = org.angles;
	mech.driver setmodel("c_rus_simianaut_body");
	mech.driver linkto(mech, "tag_driver");
	mech.driver thread function_fb3b78fe();
	mech linkto(org);
	org thread namespace_eaa992c::function_285a2999("fire_trail");
	wait(0.05);
	mech show();
	mech.driver show();
	org moveto(point3.origin, 2);
	mech playsound("evt_doa_monkeymech_land");
	org util::waittill_any_timeout(3, "movedone");
	org thread namespace_eaa992c::function_285a2999("def_explode");
	mech setturrettargetent(level.doa.var_c12009c9);
	mech setgunnertargetent(level.doa.var_c12009c9, (0, 0, 0), 1);
	mech unlink();
	level notify(#"hash_e4be85d1");
	wait(10);
	level thread function_46882430(&"DOA_TRY_THIS", mech.driver.origin + vectorscale((0, 0, 1), 145), 2);
	level notify(#"hash_5e4b910f");
	level.doa.var_799853ee thread function_4036d4c6();
	msg = self util::waittill_any_timeout(1, "turret_on_target");
	rounds = 40;
	faketarget = undefined;
	while(rounds)
	{
		mech fireweapon(2, level.doa.var_c12009c9, vectorscale((0, 0, -1), 15));
		wait(0.15);
		rounds--;
		if(rounds == 28)
		{
			level notify(#"hash_de8df0f3");
			level thread function_46882430(&"DOA_HAHAHA", mech.driver.origin + vectorscale((0, 0, 1), 145), 2);
		}
		if(rounds % 10 == 0)
		{
			if(isdefined(faketarget))
			{
				faketarget delete();
			}
			target = level.doa.var_92721db3[randomint(level.doa.var_92721db3.size)];
			faketarget = spawn("script_model", target.origin + vectorscale((0, 0, 1), 32));
			faketarget thread doa_utility::function_783519c1("podiumAllDone", 1);
			faketarget setmodel("tag_origin");
			faketarget makesentient();
			level.doa.var_c12009c9 = faketarget;
			mech setturrettargetent(level.doa.var_c12009c9);
			mech setgunnertargetent(level.doa.var_c12009c9);
			msg = self util::waittill_any_timeout(1, "turret_on_target");
		}
	}
	if(isdefined(faketarget))
	{
		faketarget delete();
	}
	mech cleargunnertarget(1);
	mech.driver.taunt = 1;
	mech.driver stopanimscripted();
	wait(1);
	level thread function_46882430(&"DOA_HAHAHA", mech.driver.origin + vectorscale((0, 0, 1), 145), 2);
	wait(2);
	level thread function_46882430(&"DOA_ME_WINNER", mech.driver.origin + vectorscale((0, 0, 1), 145), 2);
	mech.driver.taunt = undefined;
	wait(3);
	level thread function_46882430(&"DOA_BYE", mech.driver.origin + vectorscale((0, 0, 1), 145), 2);
	wait(2);
	mech linkto(org);
	mech playsound("evt_doa_monkeymech_takeoff");
	org thread namespace_eaa992c::function_285a2999("def_explode");
	org moveto(point3.origin + vectorscale((0, 0, 1), 2500), 2);
	org util::waittill_any_timeout(2.3, "movedone");
	if(isdefined(mech))
	{
		if(isdefined(mech.driver))
		{
			mech.driver delete();
		}
		mech delete();
	}
	if(isdefined(org))
	{
		org delete();
	}
	wait(4);
	level notify(#"hash_115c344c");
}

/*
	Name: function_f7e6e4b1
	Namespace: namespace_917e49b3
	Checksum: 0x8C0ECD04
	Offset: 0x2D78
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function function_f7e6e4b1(scale = 1, var_fb37ad89 = 9999)
{
	level endon(#"hash_448ca7a6");
	self endon(#"death");
	while(true)
	{
		level waittill(#"hash_71c0bde9");
		vector = (randomint(20), randomint(20), 30) * scale;
		self physicslaunch(self.origin, vector);
		var_fb37ad89--;
		if(var_fb37ad89 < 0)
		{
			return;
		}
	}
}

/*
	Name: function_d834fdd0
	Namespace: namespace_917e49b3
	Checksum: 0x96CF2D5F
	Offset: 0x2E70
	Size: 0x2DA
	Parameters: 0
	Flags: Linked
*/
function function_d834fdd0()
{
	level endon(#"hash_448ca7a6");
	level waittill(#"hash_71c0bde9");
	level.doa.var_e102b46 thread namespace_eaa992c::function_285a2999("bomb");
	foreach(var_a6c38c41, podium in level.doa.var_92721db3)
	{
		if(isdefined(podium.var_53538eb0))
		{
			podium.var_53538eb0 physicslaunch(podium.var_53538eb0.origin, (randomint(10), randomint(10), 80));
			podium.var_53538eb0 thread function_f7e6e4b1();
		}
		if(isdefined(podium.playermodel))
		{
			podium.playermodel stopanimscripted();
			podium.playermodel notsolid();
			podium.playermodel startragdoll(1);
			podium.playermodel notify(#"hash_cc763d5f");
			var_4671be4e = vectorscale((0, 0, 1), 130);
			podium.playermodel launchragdoll(var_4671be4e);
		}
	}
	foreach(var_2fb1e81, spot in level.doa.var_27f5178d)
	{
		if(isdefined(spot.spectator) && isdefined(spot.script_noteworthy))
		{
			spot.spectator thread function_566de51a();
		}
	}
}

/*
	Name: function_566de51a
	Namespace: namespace_917e49b3
	Checksum: 0x6EC5CCCD
	Offset: 0x3158
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_566de51a()
{
	self endon(#"death");
	self thread namespace_eaa992c::function_285a2999("bomb");
	self stopanimscripted();
	self startragdoll(1);
	util::wait_network_frame();
	var_4671be4e = vectorscale((0, 0, 1), 130);
	self launchragdoll(var_4671be4e);
}

/*
	Name: function_2b20420b
	Namespace: namespace_917e49b3
	Checksum: 0xEE8B64F9
	Offset: 0x3200
	Size: 0x24E
	Parameters: 1
	Flags: Linked
*/
function function_2b20420b(podium)
{
	level endon(#"hash_448ca7a6");
	podium.playermodel = function_5ec4f559(podium.player);
	spot = struct::get(podium.target, "targetname");
	podium.playermodel.origin = spot.origin;
	podium.playermodel.angles = spot.angles;
	podium.var_53538eb0 show();
	switch(podium.position)
	{
		case 0:
		{
			level.doa.var_e102b46 = podium;
			level thread function_d040f4a6(podium);
			wait(8);
			level thread fireworks();
			level notify(#"hash_86792d54");
			dropspot = level.doa.var_e102b46.origin + vectorscale((0, 0, 1), 600);
			level thread function_1aaa038(dropspot);
			wait(4);
			level thread function_1aaa038(dropspot);
			wait(6);
			level notify(#"hash_80a84385");
			break;
		}
		case 1:
		{
			level thread function_1b6034b2(podium);
			break;
		}
		case 2:
		{
			level thread function_87082601(podium);
			break;
		}
		case 3:
		{
			level thread function_b7bde10a(podium);
			break;
		}
	}
}

/*
	Name: function_1aaa038
	Namespace: namespace_917e49b3
	Checksum: 0x9A2E7A9A
	Offset: 0x3458
	Size: 0x26E
	Parameters: 1
	Flags: Linked
*/
function function_1aaa038(droporigin)
{
	var_9f9a4e58 = array("zombietron_ruby", "zombietron_diamond", "zombietron_sapphire");
	qty = 30;
	while(qty)
	{
		if(mayspawnentity())
		{
			gem = spawn("script_model", droporigin);
			gem.script_noteworthy = "a_pickup_item";
			gem.angles = (0, randomint(360), 0);
			gem setmodel(var_9f9a4e58[randomint(var_9f9a4e58.size)]);
			target_point = gem.origin + (randomint(2), randomint(2), 12);
			vel = target_point - gem.origin;
			gem.origin = gem.origin + 4 * vel;
			vel = vel * randomfloatrange(0.5, 3);
			gem physicslaunch(gem.origin, vel);
			gem thread doa_utility::function_783519c1("podiumAllDone", 1);
			gem thread function_f7e6e4b1(3, 20);
			gem thread namespace_1a381543::function_90118d8c("zmb_gem_quieter");
			qty--;
			util::wait_network_frame();
		}
		else
		{
			return;
		}
	}
}

/*
	Name: fireworks
	Namespace: namespace_917e49b3
	Checksum: 0x2088AB7E
	Offset: 0x36D0
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function fireworks()
{
	level endon(#"hash_448ca7a6");
	level endon(#"hash_80a84385");
	while(true)
	{
		level clientfield::set("redinsExploder", 2);
		wait(4);
		level clientfield::set("redinsExploder", 0);
		wait(1);
	}
}

/*
	Name: function_5ec4f559
	Namespace: namespace_917e49b3
	Checksum: 0x37B8C29F
	Offset: 0x3750
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function function_5ec4f559(player)
{
	model = spawn("script_model", player.origin);
	switch(player.entnum)
	{
		case 0:
		{
			body = "c_zombietron_player1_podium";
			break;
		}
		case 1:
		{
			body = "c_zombietron_player2_podium";
			break;
		}
		case 2:
		{
			body = "c_zombietron_player3_podium";
			break;
		}
		case 3:
		{
			body = "c_zombietron_player4_podium";
			break;
		}
	}
	model setmodel(body);
	return model;
}

/*
	Name: function_5e06cff2
	Namespace: namespace_917e49b3
	Checksum: 0x95BFA4DC
	Offset: 0x3840
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function function_5e06cff2()
{
	level endon(#"hash_448ca7a6");
	self useanimtree($generic);
	self setmodel(level.doa.var_260a85f3[randomint(level.doa.var_260a85f3.size)]);
	if(!isdefined(self.script_noteworthy))
	{
		org = spawn("script_model", self.origin);
		org thread doa_utility::function_783519c1("podiumAllDone", 1);
		org setmodel("tag_origin");
		org enablelinkto();
		org notsolid();
		org.angles = self.angles;
		self linkto(org);
		self.org = org;
		self thread function_78713841();
	}
	self thread function_b8de7628();
	self thread function_7206982b();
	self thread function_fccfcf0c();
}

/*
	Name: function_7206982b
	Namespace: namespace_917e49b3
	Checksum: 0xFF511C7A
	Offset: 0x3A08
	Size: 0xDE
	Parameters: 0
	Flags: Linked
*/
function function_7206982b()
{
	level endon(#"hash_448ca7a6");
	self endon(#"death");
	self notify(#"hash_7206982b");
	self endon(#"hash_7206982b");
	while(true)
	{
		idleanim = self.animarray[randomint(self.animarray.size)];
		self animscripted("zombieanim", self.origin, self.angles, idleanim, "normal", %generic::body, 1, 0.3, 0.3);
		self waittill_match(#"hash_24281fe0");
	}
}

/*
	Name: function_78713841
	Namespace: namespace_917e49b3
	Checksum: 0x7893005
	Offset: 0x3AF0
	Size: 0xF2
	Parameters: 0
	Flags: Linked
*/
function function_78713841()
{
	level endon(#"hash_448ca7a6");
	self endon(#"death");
	while(true)
	{
		if(!isdefined(level.doa.var_63e2b87e))
		{
			wait(randomfloatrange(0.1, 2));
		}
		else
		{
			anim_ang = vectortoangles(level.doa.var_63e2b87e.origin - self.origin);
			self.org rotateto((0, anim_ang[1], 0), randomfloatrange(0.5, 2));
			self.org waittill(#"rotatedone");
		}
	}
}

/*
	Name: function_b8de7628
	Namespace: namespace_917e49b3
	Checksum: 0xE925C19E
	Offset: 0x3BF0
	Size: 0x1A8
	Parameters: 0
	Flags: Linked
*/
function function_b8de7628()
{
	level endon(#"hash_448ca7a6");
	self endon(#"death");
	var_2c143867 = array(%generic::ai_zombie_base_idle_ad_v1, %generic::ai_zombie_base_idle_au_v1, %generic::bo3_ai_zombie_attack_v1, %generic::bo3_ai_zombie_attack_v2, %generic::bo3_ai_zombie_attack_v3, %generic::bo3_ai_zombie_attack_v4, %generic::bo3_ai_zombie_attack_v6);
	var_6ac65424 = array(%generic::ai_zombie_doa_cheer_v1, %generic::ai_zombie_doa_cheer_v2, %generic::ai_zombie_doa_cheer_v3);
	self.animarray = var_2c143867;
	self.var_b2f6b3b7 = "zombie_outro_mood_angry";
	while(true)
	{
		note = level util::waittill_any_return("zombie_outro_mood_angry", "zombie_outro_mood_happy", "zombie_outro_mood_lol");
		self.var_b2f6b3b7 = note;
		if(note == "zombie_outro_mood_angry")
		{
			self.animarray = var_2c143867;
		}
		else
		{
			self.animarray = var_6ac65424;
		}
		self thread function_7206982b();
	}
}

/*
	Name: function_fccfcf0c
	Namespace: namespace_917e49b3
	Checksum: 0x4F1B6A74
	Offset: 0x3DA0
	Size: 0x140
	Parameters: 0
	Flags: Linked
*/
function function_fccfcf0c()
{
	level endon(#"hash_448ca7a6");
	self endon(#"death");
	wait(randomfloatrange(0, 2));
	location = self.origin + vectorscale((0, 0, 1), 90);
	while(true)
	{
		if(randomint(getdvarint("scr_doa_zombie_talk_chance", 50)) == 0)
		{
			switch(self.var_b2f6b3b7)
			{
				case "zombie_outro_mood_angry":
				{
					function_46882430(&"DOA_GARRRR", location, 2);
					break;
				}
				case "zombie_outro_mood_happy":
				{
					function_46882430(&"DOA_GAR", location, 2);
					break;
				}
				case "zombie_outro_mood_lol":
				{
					function_46882430(&"DOA_GARHARHAR", location, 2);
					break;
				}
			}
		}
		wait(1);
	}
}

/*
	Name: function_fb3b78fe
	Namespace: namespace_917e49b3
	Checksum: 0x6DD936F7
	Offset: 0x3EE8
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function function_fb3b78fe()
{
	level endon(#"hash_448ca7a6");
	self endon(#"death");
	self useanimtree($generic);
	while(true)
	{
		if(isdefined(self.taunt) && self.taunt)
		{
			self animscripted("mech_taunt", self.origin, self.angles, "ai_zombie_doa_simianaut_mech_idle_taunt");
			self waittill_match(#"hash_3b8ce577");
		}
		else
		{
			self animscripted("mech_idle", self.origin, self.angles, "ai_zombie_doa_simianaut_mech_idle");
			self waittill_match(#"hash_4b135fff");
		}
	}
}

/*
	Name: function_4036d4c6
	Namespace: namespace_917e49b3
	Checksum: 0xDC186FCF
	Offset: 0x3FE0
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function function_4036d4c6()
{
	level endon(#"hash_448ca7a6");
	self notify(#"hash_4036d4c6");
	self endon(#"hash_4036d4c6");
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage");
		playrumbleonposition("explosion_generic", self.origin);
		physicsexplosionsphere(self.origin, 512, 512, 5);
		level notify(#"hash_71c0bde9");
	}
}

/*
	Name: function_e4d4b80
	Namespace: namespace_917e49b3
	Checksum: 0x41A3BBD2
	Offset: 0x4090
	Size: 0xDE
	Parameters: 1
	Flags: Linked
*/
function function_e4d4b80(animation)
{
	level endon(#"hash_448ca7a6");
	self notify(#"hash_e4d4b80");
	self endon(#"hash_e4d4b80");
	self useanimtree($generic);
	while(true)
	{
		self animscripted("podium", self.origin, self.angles, animation, "normal", %generic::body, 1, 0.5, 0.5);
		self waittill_match(#"podium");
		self notify(#"animation_loop", animation, "end");
	}
}

/*
	Name: function_46882430
	Namespace: namespace_917e49b3
	Checksum: 0x931BCC37
	Offset: 0x4178
	Size: 0xD4
	Parameters: 4
	Flags: Linked
*/
function function_46882430(string, location, hold = 3, fade = 1)
{
	id = doa_utility::function_c9fb43e9(string, location);
	level util::waittill_any_timeout(hold, "podiumAllDone", "killBubble");
	doa_utility::function_11f3f381(id, fade);
	level util::waittill_any_timeout(fade, "podiumAllDone");
}

/*
	Name: function_d040f4a6
	Namespace: namespace_917e49b3
	Checksum: 0x7EAECF4
	Offset: 0x4258
	Size: 0x334
	Parameters: 1
	Flags: Linked
*/
function function_d040f4a6(podium)
{
	level endon(#"hash_448ca7a6");
	level waittill(#"hash_314666df");
	playermodel = podium.playermodel;
	playermodel.team = "axis";
	playermodel useanimtree($generic);
	playermodel solid();
	playermodel.takedamage = 1;
	level.doa.var_c12009c9 = podium.var_53538eb0;
	offset = playermodel.origin + vectorscale((0, 0, 1), 90);
	playermodel thread function_e4d4b80(%generic::ch_ram_05_02_block_nrc_vign_cheering_d_loop);
	wait(3);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_1stplace_1");
	function_46882430(&"DOA_FIRST_PLACE", offset);
	function_46882430(&"DOA_OH_YEAH", offset, 2);
	function_46882430(&"DOA_RICH", offset, 4);
	wait(1);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_1stplace_2");
	function_46882430(&"DOA_WOOO", offset);
	function_46882430(&"DOA_WELL_HELLO", offset, 2);
	wait(1);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_1stplace_3");
	function_46882430(&"DOA_WANT_SOME", offset);
	function_46882430(&"DOA_WOOO", offset, 2);
	function_46882430(&"DOA_CANT_TOUCH", offset);
	level waittill(#"hash_ff1ecf6");
	wait(1);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_1stplace_4");
	function_46882430(&"DOA_WHATWASTHAT", offset);
	level waittill(#"hash_5e4b910f");
	if(level.doa.var_44d58db8.size == 4)
	{
		wait(1);
		function_46882430(&"DOA_II", offset, 3.5);
	}
	else
	{
		wait(1);
		function_46882430(&"DOA_NOOOO", offset, 2);
	}
}

/*
	Name: function_1b6034b2
	Namespace: namespace_917e49b3
	Checksum: 0x41831433
	Offset: 0x4598
	Size: 0x23C
	Parameters: 1
	Flags: Linked
*/
function function_1b6034b2(podium)
{
	level endon(#"hash_448ca7a6");
	level waittill(#"hash_314666df");
	playermodel = podium.playermodel;
	playermodel thread function_e4d4b80(%generic::ai_civ_base_cover_stn_pointidle);
	offset = playermodel.origin + vectorscale((0, 0, 1), 90);
	wait(4);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_2ndplace_1");
	function_46882430(&"DOA_SECOND_PLACE", offset);
	wait(1);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_2ndplace_2");
	function_46882430(&"DOA_FUN", offset);
	wait(1);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_2ndplace_3");
	function_46882430(&"DOA_AGAIN", offset);
	level waittill(#"hash_a284788a");
	wait(randomfloatrange(0, 2));
	function_46882430(&"DOA_UMM", offset);
	level waittill(#"hash_e4be85d1");
	function_46882430(&"DOA_NOTGOOD", offset);
	if(level.doa.var_44d58db8.size == 4)
	{
		level waittill(#"hash_5e4b910f");
		wait(1.5);
		function_46882430(&"DOA_T", offset);
	}
	else
	{
		wait(1);
		function_46882430(&"DOA_RUN", offset, 2);
	}
}

/*
	Name: function_87082601
	Namespace: namespace_917e49b3
	Checksum: 0x8900DDA7
	Offset: 0x47E0
	Size: 0x23C
	Parameters: 1
	Flags: Linked
*/
function function_87082601(podium)
{
	level endon(#"hash_448ca7a6");
	level waittill(#"hash_314666df");
	playermodel = podium.playermodel;
	offset = playermodel.origin + vectorscale((0, 0, 1), 90);
	playermodel thread function_e4d4b80(%generic::ai_civ_base_standidle_officer);
	wait(5);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_3rdplace_1");
	function_46882430(&"DOA_THIRD_PLACE", offset);
	wait(3);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_3rdplace_2");
	function_46882430(&"DOA_NEXTTIME", offset);
	wait(6);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_3rdplace_3");
	function_46882430(&"DOA_WHOISTHATGUY", offset);
	level waittill(#"hash_a284788a");
	wait(randomfloatrange(0, 2));
	function_46882430(&"DOA_UMM", offset);
	level waittill(#"hash_e4be85d1");
	wait(1);
	function_46882430(&"DOA_YOUTHINK", offset);
	if(level.doa.var_44d58db8.size == 4)
	{
		level waittill(#"hash_5e4b910f");
		wait(0.5);
		function_46882430(&"DOA_SH", offset, 4);
	}
	else
	{
		wait(1);
		function_46882430(&"DOA_BOOGIE", offset, 2);
	}
}

/*
	Name: function_b7bde10a
	Namespace: namespace_917e49b3
	Checksum: 0xC0079DB0
	Offset: 0x4A28
	Size: 0x22C
	Parameters: 1
	Flags: Linked
*/
function function_b7bde10a(podium)
{
	level endon(#"hash_448ca7a6");
	level waittill(#"hash_314666df");
	playermodel = podium.playermodel;
	right = anglestoright(playermodel.angles);
	offset = playermodel.origin + vectorscale((0, 0, 1), 80) + 30 * right;
	playermodel thread function_e4d4b80(%generic::ch_new_06_01_chase_vign_sitting_civs_right_civ01_loop);
	wait(6);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_4thplace_1");
	function_46882430(&"DOA_LAST_PLACE", offset);
	wait(3);
	playermodel thread namespace_1a381543::function_90118d8c("zmb_end_4thplace_2");
	function_46882430(&"DOA_CANTBETRUE", offset);
	function_46882430(&"DOA_CHICKENS", offset);
	level waittill(#"hash_a284788a");
	wait(randomfloatrange(0, 2));
	function_46882430(&"DOA_UMM", offset);
	level waittill(#"hash_e4be85d1");
	wait(2);
	function_46882430(&"DOA_SITTING", offset);
	if(level.doa.var_44d58db8.size == 4)
	{
		level waittill(#"hash_5e4b910f");
		function_46882430(&"DOA_OH", offset, 4.5);
	}
}

/*
	Name: function_4d8b6e1e
	Namespace: namespace_917e49b3
	Checksum: 0xB1BCD44E
	Offset: 0x4C60
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function function_4d8b6e1e()
{
	var_5198fae9 = getplayers();
	players = [];
	foreach(var_9e4a4934, player in var_5198fae9)
	{
		if(isdefined(player.doa))
		{
			players[players.size] = player;
		}
	}
	for(i = 1; i < players.size; i++)
	{
		for(j = i; j > 0 && int(players[j - 1] namespace_64c6b720::function_93ccc5da()) < int(players[j] namespace_64c6b720::function_93ccc5da()); j--)
		{
			array::swap(players, j, j - 1);
		}
	}
	return players;
}

