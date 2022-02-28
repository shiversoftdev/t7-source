// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\cp_doa_bo3_enemy;
#using scripts\cp\cp_doa_bo3_fx;
#using scripts\cp\cp_doa_bo3_sound;
#using scripts\cp\doa\_doa_arena;
#using scripts\cp\doa\_doa_chicken_pickup;
#using scripts\cp\doa\_doa_core;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_enemy;
#using scripts\cp\doa\_doa_fate;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_gibs;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_sfx;
#using scripts\cp\doa\_doa_utility;
#using scripts\cp\doa\_doa_vehicle_pickup;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_quadtank;

#using_animtree("critter");

#namespace namespace_df93fc7c;

/*
	Name: function_4c171b8e
	Namespace: namespace_df93fc7c
	Checksum: 0x584205E
	Offset: 0xF50
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_4c171b8e()
{
	self endon(#"disconnect");
	while(!isdefined(self.doa))
	{
		wait(0.05);
	}
	waittillframeend();
	startpoints = struct::get_array("spiral_player_spawnpoint");
	self freezecontrols(!level flag::get("doa_challenge_running"));
	spot = startpoints[self.entnum];
	self setorigin(spot.origin);
	self setplayerangles(spot.angles);
}

/*
	Name: function_bb59f698
	Namespace: namespace_df93fc7c
	Checksum: 0xDC565969
	Offset: 0x1038
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function function_bb59f698()
{
	level endon(#"hash_16154574");
	level endon(#"hash_d1f5acf7");
	trigger = getent("spiral_killAllEnemy", "targetname");
	trigger waittill(#"trigger");
	level thread doa_utility::killallenemy();
	level notify(#"hash_16154574");
}

/*
	Name: function_31c377e
	Namespace: namespace_df93fc7c
	Checksum: 0x3C09361A
	Offset: 0x10C0
	Size: 0x7AC
	Parameters: 1
	Flags: Linked
*/
function function_31c377e(room)
{
	room.text = &"CP_DOA_BO3_CHALLENGE_ROOM_SPIRAL";
	room.title = &"CP_DOA_BO3_TITLE_ROOM_SPIRAL";
	room.vox = "vox_doaa_temple_fortress";
	room.var_e5c8b9e7 = level.doa.var_bc9b7c71;
	level.doa.var_bc9b7c71 = &function_4c171b8e;
	level thread namespace_3ca3c537::function_4586479a(0);
	level thread function_bb59f698();
	room.glow = [];
	glow = spawn("script_model", namespace_3ca3c537::function_61d60e0b() + vectorscale((0, 0, 1), 36));
	glow.targetname = "spiralglow1";
	glow setmodel("tag_origin");
	glow thread namespace_eaa992c::function_285a2999("glow_blue");
	room.glow[room.glow.size] = glow;
	glow = spawn("script_model", namespace_3ca3c537::function_61d60e0b() + vectorscale((0, 0, 1), 72));
	glow.targetname = "spiralglow2";
	glow setmodel("tag_origin");
	glow thread namespace_eaa992c::function_285a2999("glow_blue");
	room.glow[room.glow.size] = glow;
	glow = spawn("script_model", namespace_3ca3c537::function_61d60e0b() + vectorscale((0, 0, 1), 128));
	glow.targetname = "spiralglow3";
	glow setmodel("tag_origin");
	glow thread namespace_eaa992c::function_285a2999("glow_blue");
	room.glow[room.glow.size] = glow;
	glow = spawn("script_model", namespace_3ca3c537::function_61d60e0b() + vectorscale((0, 0, 1), 160));
	glow.targetname = "spiralglow4";
	glow setmodel("tag_origin");
	glow thread namespace_eaa992c::function_285a2999("glow_blue");
	room.glow[room.glow.size] = glow;
	barricades = struct::get_array(room.name + "_destructible", "targetname");
	count = 0;
	foreach(item in barricades)
	{
		blocker = spawn("script_model", item.origin);
		blocker.targetname = "blockerSpiral";
		blocker.angles = item.angles;
		blocker setmodel(item.script_noteworthy);
		blocker solid();
		blocker.targetname = room.name + "_blocker";
		blocker thread function_e1b0de53(item.script_parameters);
		count++;
		if(count > 10)
		{
			wait(0.05);
			count = 0;
		}
	}
	var_2b8e59af = getentarray(room.name + "_barrier_trigger", "targetname");
	foreach(trigger in var_2b8e59af)
	{
		trigger thread triggernotify();
	}
	rewards = struct::get_array(room.name + "_challenge_reward");
	foreach(item in rewards)
	{
		doa_pickups::function_3238133b(item.script_noteworthy, item.origin, 1, 0);
	}
	foreach(player in getplayers())
	{
		player thread function_4c171b8e();
	}
	level flag::set("doa_challenge_ready");
}

/*
	Name: function_ffe2a6ea
	Namespace: namespace_df93fc7c
	Checksum: 0x952940E0
	Offset: 0x1878
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_ffe2a6ea()
{
	wait(randomfloatrange(0, 1));
	self moveto((self.origin[0], self.origin[1], self.origin[2] + 2000), 1);
	self util::waittill_any_timeout(1.5, "movedone");
	self delete();
}

/*
	Name: triggernotify
	Namespace: namespace_df93fc7c
	Checksum: 0x497498FC
	Offset: 0x1928
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function triggernotify()
{
	target = getent(self.target, "targetname");
	target.origin = (target.origin[0], target.origin[1], int(target.script_parameters));
	self waittill(#"trigger");
	target.origin = target.origin + vectorscale((0, 0, 1), 1000);
	level notify(self.script_parameters);
}

/*
	Name: function_e1b0de53
	Namespace: namespace_df93fc7c
	Checksum: 0xACD3CFB3
	Offset: 0x19F8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_e1b0de53(note)
{
	level endon(#"hash_16154574");
	level endon(#"hash_d1f5acf7");
	self.var_e2b2db7a = 1;
	level waittill(note);
	self thread function_ffe2a6ea();
}

/*
	Name: function_8e0e22bb
	Namespace: namespace_df93fc7c
	Checksum: 0x75FCDADF
	Offset: 0x1A50
	Size: 0x1FE
	Parameters: 1
	Flags: Linked
*/
function function_8e0e22bb(room)
{
	level endon(#"hash_16154574");
	level endon(#"hash_d1f5acf7");
	foreach(player in getplayers())
	{
		player freezecontrols(1);
		player.room = room;
	}
	level waittill(#"hash_97276c43");
	level flag::set("doa_challenge_running");
	foreach(player in getplayers())
	{
		player freezecontrols(0);
		player notify(#"hash_d28ba89d");
	}
	level thread function_533483a3(room);
	if(isdefined(level.var_1575b6db) && level.var_1575b6db)
	{
		level thread doa_utility::notify_timeout("teleporter_triggered", 10);
	}
	level waittill(#"hash_6df89d17");
	level notify(#"hash_16154574");
}

/*
	Name: function_47a3686b
	Namespace: namespace_df93fc7c
	Checksum: 0xE3D59817
	Offset: 0x1C58
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function function_47a3686b(room)
{
	doa_pickups::function_c1869ec8();
}

/*
	Name: function_7823dbb8
	Namespace: namespace_df93fc7c
	Checksum: 0x1590E2B1
	Offset: 0x1C80
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function function_7823dbb8(room)
{
	axis = getaiteamarray("axis");
	foreach(guy in axis)
	{
		guy kill();
	}
}

/*
	Name: function_eee6e911
	Namespace: namespace_df93fc7c
	Checksum: 0x458F3EFF
	Offset: 0x1D40
	Size: 0x234
	Parameters: 1
	Flags: Linked
*/
function function_eee6e911(room)
{
	ents = getentarray(room.name + "_blocker", "targetname");
	foreach(ent in ents)
	{
		ent delete();
	}
	if(isdefined(level.doa.teleporter))
	{
		level.doa.teleporter.trigger delete();
		level.doa.teleporter delete();
		level.doa.teleporter = undefined;
	}
	foreach(glow in room.glow)
	{
		if(isdefined(glow))
		{
			glow delete();
		}
	}
	level.doa.lastarena = namespace_3ca3c537::function_5835533a("temple");
	namespace_3ca3c537::function_5af67667(level.doa.lastarena, 1);
	doa_fate::function_77ed1bae();
}

/*
	Name: function_533483a3
	Namespace: namespace_df93fc7c
	Checksum: 0xE9CB8ECF
	Offset: 0x1F80
	Size: 0x32A
	Parameters: 1
	Flags: Linked, Private
*/
function private function_533483a3(room)
{
	level endon(#"hash_16154574");
	level endon(#"hash_d1f5acf7");
	level.doa.var_e0d67a74 = struct::get_array(room.name + "_rise_spot");
	var_48be25f5 = getent("spawner_zombietron_skeleton", "targetname");
	while(true)
	{
		axis = getaiteamarray("axis");
		if(axis.size < 40)
		{
			var_e1a06452 = randomintrange(3, 10);
			if((axis.size + var_e1a06452) > 40)
			{
				var_e1a06452 = 40 - axis.size;
			}
			var_1db14d86 = getplayers().size * 500;
			while(var_e1a06452)
			{
				var_e1a06452--;
				ai = namespace_51bd792::function_45849d81(var_48be25f5, undefined, undefined);
				if(isdefined(ai))
				{
					ai hidepart("TAG_WEAPON_LEFT");
					ai setavoidancemask("avoid none");
					ai pushactors(0);
					ai.var_ad61c13d = 1;
					ai.is_skeleton = 1;
					ai.nofire = 1;
					ai.doa.points = undefined;
					ai notify(#"hash_6e8326fc");
					roll = randomint(100);
					if(roll < 20)
					{
						ai.zombie_move_speed = "super_sprint";
					}
					else
					{
						if(roll < 45)
						{
							ai.zombie_move_speed = "sprint";
						}
						else
						{
							if(roll < 80)
							{
								ai.zombie_move_speed = "run";
							}
							else
							{
								ai.zombie_move_speed = "walk";
							}
						}
					}
					ai.health = 500 + var_1db14d86;
					ai thread function_c0808a91();
				}
				wait(0.05);
			}
		}
		wait(1);
	}
}

/*
	Name: function_c0808a91
	Namespace: namespace_df93fc7c
	Checksum: 0xDECA6A86
	Offset: 0x22B8
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function function_c0808a91()
{
	self endon(#"death");
	while(true)
	{
		if(isdefined(self.players_viscache))
		{
			foreach(player in getplayers())
			{
				idx = (isdefined(player.entnum) ? player.entnum : player getentitynumber());
				self.players_viscache[idx] = gettime() + 1000;
			}
		}
		wait(0.5);
	}
}

/*
	Name: function_b6c25c3c
	Namespace: namespace_df93fc7c
	Checksum: 0x85E7AF3D
	Offset: 0x23C8
	Size: 0x2E4
	Parameters: 1
	Flags: Linked
*/
function function_b6c25c3c(spot)
{
	self endon(#"disconnect");
	while(!isdefined(self.doa))
	{
		wait(0.05);
	}
	waittillframeend();
	if(!isdefined(spot))
	{
		startpoints = struct::get_array("tankmaze_player_spawnpoint");
		spot = startpoints[self.entnum];
	}
	self.room = level.doa.var_52cccfb6;
	tank = getent("doa_tankmaze_spawner", "targetname") spawner::spawn(1);
	self setorigin(spot.origin);
	tank setmodel("veh_t7_mil_tank_tiger_zombietron_" + namespace_831a4a7c::function_ee495f41(self.entnum));
	tank.origin = spot.origin;
	tank.spawnpoint = spot.origin;
	tank.angles = spot.angles;
	tank.spawnangles = spot.angles;
	tank.team = "allies";
	tank thread function_9c687a5d(self);
	tank usevehicle(self, 0);
	tank makeunusable();
	tank.owner = self;
	tank makesentient();
	self.doa.vehicle = tank;
	self.doa.var_3024fd0f = 1;
	self.doa.var_3e3bcaa1 = 1;
	self.doa.gpr = 0;
	self.ignoreme = 1;
	self freezecontrols(!level flag::get("doa_challenge_running"));
	wait(0.05);
	self thread function_810ced6b();
	self namespace_5e6c5d1f::function_8397461e();
}

/*
	Name: function_6aa91f48
	Namespace: namespace_df93fc7c
	Checksum: 0x28BBC71F
	Offset: 0x26B8
	Size: 0x23C
	Parameters: 1
	Flags: Linked
*/
function function_6aa91f48(room)
{
	level clientfield::set("set_scoreHidden", 1);
	room.var_dc49d6a4 = level.callbackvehicledamage;
	level.callbackvehicledamage = &function_fe1ce5f1;
	room.var_e5c8b9e7 = level.doa.var_bc9b7c71;
	level.doa.var_bc9b7c71 = &function_b6c25c3c;
	room.text = &"CP_DOA_BO3_CHALLENGE_ROOM_TANKMAZE";
	room.title = &"CP_DOA_BO3_TITLE_ROOM_TANKMAZE";
	room.vox = "vox_doaa_tank_vault";
	room.var_674e3329 = 1;
	room.enemy_spawns = struct::get_array("tankmaze_enemy", "script_noteworthy");
	room.var_4f002f93 = struct::get_array("tankmaze_gemspot", "script_noteworthy");
	room.var_e01f23f0 = [];
	room.host_migration = &function_c2b99e74;
	level thread function_246d3adb(room);
	level thread function_db531f2f(room);
	foreach(player in getplayers())
	{
		player thread function_b6c25c3c();
	}
	level thread function_ee260997(room);
}

/*
	Name: function_246d3adb
	Namespace: namespace_df93fc7c
	Checksum: 0xFD250CE9
	Offset: 0x2900
	Size: 0x49A
	Parameters: 1
	Flags: Linked
*/
function function_246d3adb(room)
{
	total = room.var_4f002f93.size;
	var_82361971 = int(ceil(total / 80));
	arena = level.doa.arenas[namespace_3ca3c537::function_5835533a(room.name)];
	var_86a35fbd = struct::get(arena.entity.target, "targetname");
	while(isdefined(var_86a35fbd) && total > 0)
	{
		for(var_2bb5aeba = 0; isdefined(var_86a35fbd) && var_2bb5aeba < var_82361971; var_2bb5aeba++)
		{
			reward = "zombietron_beryl";
			if(isdefined(var_86a35fbd.script_parameters))
			{
				switch(var_86a35fbd.script_parameters)
				{
					case "1":
					case "2":
					case "3":
					{
						reward = "zombietron_beryl";
						break;
					}
					default:
					{
						reward = var_86a35fbd.script_parameters;
						scale = 1;
						break;
					}
				}
			}
			item = doa_pickups::function_2d8cb175(reward, var_86a35fbd.origin, 1, 0, 0, (isdefined(scale) ? scale : 2), 0, 0, 1, 0)[0];
			item doa_pickups::function_32110b7d();
			item.trigger triggerenable(0);
			room.var_e01f23f0[room.var_e01f23f0.size] = item;
			if(isdefined(var_86a35fbd.target))
			{
				var_86a35fbd = struct::get(var_86a35fbd.target, "targetname");
				continue;
			}
			var_86a35fbd = undefined;
			total--;
		}
		wait(0.05);
	}
	var_4c36e42e = 0;
	room.var_e01f23f0 = array::remove_undefined(room.var_e01f23f0);
	foreach(gem in room.var_e01f23f0)
	{
		if(isdefined(gem))
		{
			gem doa_pickups::function_fbc5b316();
		}
		var_4c36e42e++;
		if(var_4c36e42e == var_82361971)
		{
			util::wait_network_frame();
			var_4c36e42e = 0;
		}
	}
	level waittill(#"hash_c8bd32b9");
	foreach(gem in room.var_e01f23f0)
	{
		if(isdefined(gem) && isdefined(gem.trigger))
		{
			gem.trigger triggerenable(1);
		}
	}
}

/*
	Name: function_5900e5de
	Namespace: namespace_df93fc7c
	Checksum: 0x10F7222B
	Offset: 0x2DA8
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function function_5900e5de(room)
{
	level endon(#"hash_16154574");
	level endon(#"hash_d1f5acf7");
	self waittill(#"death");
	room.var_74415e9d--;
}

/*
	Name: function_a1151ae3
	Namespace: namespace_df93fc7c
	Checksum: 0xA1DFE2AD
	Offset: 0x2DF0
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function function_a1151ae3(room)
{
	room.var_74415e9d++;
	self thread function_5900e5de(room);
	self endon(#"death");
	level endon(#"hash_16154574");
	level endon(#"hash_d1f5acf7");
}

/*
	Name: function_db531f2f
	Namespace: namespace_df93fc7c
	Checksum: 0x6D05B244
	Offset: 0x2E50
	Size: 0x370
	Parameters: 1
	Flags: Linked
*/
function function_db531f2f(room)
{
	level endon(#"hash_16154574");
	level endon(#"hash_d1f5acf7");
	room.var_74415e9d = 0;
	level waittill(#"hash_c8bd32b9");
	while(true)
	{
		if(room.var_74415e9d < (4 + getplayers().size))
		{
			spot = room.enemy_spawns[randomint(room.enemy_spawns.size)];
			dropspot = spot.origin + vectorscale((0, 0, 1), 2000);
			spawner = getent("spawner_doa_tankmaze_amws", "targetname");
			fake = spawn("script_model", dropspot);
			fake.targetname = "tankmaze_EnemySpawner";
			fake setmodel(level.doa.var_4aa90d77);
			fake.angles = spot.angles;
			fake thread namespace_eaa992c::function_285a2999("fire_trail");
			fake playsound("evt_amws_incoming");
			fake moveto(spot.origin, 0.75);
			fake thread doa_utility::function_1bd67aef(1);
			fake util::waittill_any_timeout(0.8, "movedone");
			playrumbleonposition("explosion_generic", spot.origin);
			fake delete();
			amws = spawner spawner::spawn(1);
			if(isdefined(amws))
			{
				amws.origin = spot.origin;
				amws.angles = spot.angles;
				amws.health = 100;
				amws.team = "axis";
				amws thread namespace_eaa992c::function_285a2999("turret_impact");
				amws.script_noteworthy = "tankmaze_enemy";
				amws thread function_a1151ae3(room);
			}
			wait(1 + (4 - getplayers().size));
		}
		wait(0.05);
	}
}

/*
	Name: function_ee260997
	Namespace: namespace_df93fc7c
	Checksum: 0x4D12511B
	Offset: 0x31C8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_ee260997(room)
{
	level waittill(#"hash_97276c43");
	level notify(#"hash_b0d5a848");
	wait(1);
	level clientfield::set("startCountdown", 3);
	wait(4);
	level clientfield::set("startCountdown", 0);
	level notify(#"hash_c8bd32b9");
	level flag::set("doa_challenge_ready");
}

/*
	Name: function_5f0b67a9
	Namespace: namespace_df93fc7c
	Checksum: 0xA426EFA5
	Offset: 0x3270
	Size: 0x212
	Parameters: 1
	Flags: Linked
*/
function function_5f0b67a9(room)
{
	foreach(player in getplayers())
	{
		player freezecontrols(1);
	}
	level waittill(#"hash_c8bd32b9");
	level flag::set("doa_challenge_running");
	foreach(player in getplayers())
	{
		player freezecontrols(0);
	}
	if(getdvarint("scr_doa_soak_think", 0) > 1)
	{
		totaltime = 5000;
	}
	else
	{
		totaltime = (room.timeout - 1) * 1000;
	}
	timeleft = gettime() + totaltime;
	while(gettime() < timeleft)
	{
		wait(0.5);
	}
	level clientfield::set("pumpBannerBar", 0);
	util::wait_network_frame();
	level notify(#"hash_16154574");
}

/*
	Name: function_9e5e0a15
	Namespace: namespace_df93fc7c
	Checksum: 0x7AAF7505
	Offset: 0x3490
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_9e5e0a15(room)
{
}

/*
	Name: function_a25fc96
	Namespace: namespace_df93fc7c
	Checksum: 0x4AB8F1E3
	Offset: 0x34A8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_a25fc96(room)
{
}

/*
	Name: function_f1915ffb
	Namespace: namespace_df93fc7c
	Checksum: 0x9E9D9272
	Offset: 0x34C0
	Size: 0x25C
	Parameters: 1
	Flags: Linked
*/
function function_f1915ffb(room)
{
	doa_pickups::function_c1869ec8();
	level thread doa_utility::killallenemy();
	players = getplayers();
	foreach(player in players)
	{
		if(!isdefined(player))
		{
			continue;
		}
		player notify(#"hash_7c5410c4");
		if(isdefined(player.doa))
		{
			if(isdefined(player.doa.vehicle))
			{
				player.doa.vehicle usevehicle(player, 0);
				player.doa.vehicle delete();
				player.doa.vehicle = undefined;
			}
			player namespace_831a4a7c::function_7d7a7fde();
			if(!isdefined(player))
			{
				continue;
			}
			player disableinvulnerability();
			player.doa.var_3024fd0f = undefined;
			player.doa.var_3e3bcaa1 = undefined;
		}
		player.ignoreme = 0;
		player namespace_2848f8c2::function_d41a4517();
	}
	level.doa.var_bc9b7c71 = room.var_e5c8b9e7;
	level.callbackvehicledamage = room.var_dc49d6a4;
	level clientfield::set("set_scoreHidden", 0);
}

/*
	Name: function_fe1ce5f1
	Namespace: namespace_df93fc7c
	Checksum: 0x2E62BE29
	Offset: 0x3728
	Size: 0x5A4
	Parameters: 14
	Flags: Linked
*/
function function_fe1ce5f1(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname)
{
	if(self.team == "axis")
	{
		self finishvehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, modelindex, partname, 0);
		return;
	}
	if(isdefined(self.var_a4ac052c) && gettime() < self.var_a4ac052c)
	{
		return 0;
	}
	player = self.owner;
	player cleardamageindicator();
	idamage = 0;
	scale = 0;
	switch(smeansofdeath)
	{
		case "MOD_RIFLE_BULLET":
		{
			scale = 0.1;
			break;
		}
		case "MOD_PROJECTILE":
		{
			scale = 1;
			break;
		}
		case "MOD_EXPLOSIVE":
		{
			scale = 0.4;
			break;
		}
	}
	if(scale == 0)
	{
		return;
	}
	var_516eed4b = int(getdvarint("scr_doa_tankMazeMaxGems", 10) * scale);
	var_b427d4ac = player.doa.multiplier;
	self.var_a4ac052c = gettime() + 5000;
	if(player.doa.fate == 2 || player.doa.fate == 11)
	{
		var_b427d4ac--;
	}
	if(player.doa.var_d55e6679 == 0 && var_b427d4ac == 0)
	{
		return idamage;
	}
	var_8cfdcf73 = randomintrange(0, int((level.doa.rules.var_d55e6679 * scale) * getdvarfloat("scr_doa_tankMazeIncScalar", 0.25)));
	player.doa.var_d55e6679 = player.doa.var_d55e6679 - var_8cfdcf73;
	if(var_b427d4ac > 1)
	{
		player.doa.multiplier = player.doa.multiplier - 1;
		player.doa.var_d55e6679 = player.doa.var_d55e6679 + level.doa.rules.var_d55e6679;
	}
	if(player.doa.var_d55e6679 < 0)
	{
		player.doa.var_d55e6679 = 0;
	}
	player.room.var_e01f23f0 = array::remove_undefined(player.room.var_e01f23f0);
	while(var_516eed4b && player.room.var_e01f23f0.size < 275)
	{
		switch(randomint(5))
		{
			case 0:
			{
				reward = "zombietron_emerald";
				break;
			}
			case 1:
			{
				reward = "zombietron_ruby";
				break;
			}
			case 2:
			{
				reward = "zombietron_diamond";
				break;
			}
			case 3:
			{
				reward = "zombietron_sapphire";
				break;
			}
			case 4:
			{
				reward = "zombietron_beryl";
				break;
			}
		}
		reward = "zombietron_beryl";
		player.room.var_e01f23f0[player.room.var_e01f23f0.size] = level doa_pickups::spawnubertreasure(self.origin + vectorscale((0, 0, 1), 48), 1, 70, 1, 1, 2, reward, 0.2, 1, 0, 0)[0];
		var_516eed4b--;
	}
	return idamage;
}

/*
	Name: function_c2b99e74
	Namespace: namespace_df93fc7c
	Checksum: 0x596E1741
	Offset: 0x3CD8
	Size: 0x31A
	Parameters: 1
	Flags: Linked
*/
function function_c2b99e74(room)
{
	/#
		doa_utility::debugmsg("");
	#/
	foreach(player in getplayers())
	{
		player freezecontrols(1);
		if(isdefined(player.doa.vehicle) && player.doa.vehicle getvehicleowner() == player)
		{
			/#
				doa_utility::debugmsg("" + player.name);
			#/
			player.doa.vehicle makeusable();
			player.doa.vehicle usevehicle(player, 0);
			player ghost();
		}
	}
	util::wait_network_frame();
	foreach(player in getplayers())
	{
		if(isdefined(player.doa.vehicle))
		{
			/#
				doa_utility::debugmsg("" + player.name);
			#/
			player.doa.vehicle usevehicle(player, 0);
			player.doa.vehicle makeunusable();
			player show();
		}
		player freezecontrols(!level flag::get("doa_challenge_running"));
	}
}

/*
	Name: function_9c687a5d
	Namespace: namespace_df93fc7c
	Checksum: 0x7D4BAD4C
	Offset: 0x4000
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_9c687a5d(player)
{
	self endon(#"death");
	player waittill(#"disconnect");
	self delete();
}

/*
	Name: function_14e75d7a
	Namespace: namespace_df93fc7c
	Checksum: 0x7D93E241
	Offset: 0x4048
	Size: 0x42C
	Parameters: 1
	Flags: Linked
*/
function function_14e75d7a(spot)
{
	self endon(#"disconnect");
	while(!isdefined(self.doa))
	{
		wait(0.05);
	}
	waittillframeend();
	if(!isdefined(spot))
	{
		startpoints = struct::get_array("redins_player_spawnpoint");
		spot = startpoints[self.entnum];
	}
	self.var_b1c8a8a2 = self.doa.bombs;
	self.var_e9aff98 = self.doa.boosters;
	var_f3a9458e = getent("doa_redins_truck", "targetname");
	truck = var_f3a9458e spawner::spawn(1);
	self setorigin(spot.origin);
	truck.origin = spot.origin;
	truck.spawnpoint = spot.origin;
	truck.angles = spot.angles;
	truck.spawnangles = spot.angles;
	truck.team = self.team;
	truck thread function_9c687a5d(self);
	truck usevehicle(self, 0);
	truck makeunusable();
	truck.takedamage = 0;
	truck.var_f71159da = 0;
	truck.owner = self;
	truck setmodel("veh_t7_civ_truck_pickup_tech_nrc_mini_" + namespace_831a4a7c::function_ee495f41(self.entnum));
	self.doa.vehicle = truck;
	self.doa.var_de24aff7 = 0;
	self.doa.var_37efabf7 = 1;
	self.doa.var_3024fd0f = 1;
	self.doa.var_3e3bcaa1 = 1;
	self thread function_c71e611c(truck);
	self thread function_d64204d9();
	self.doa.gpr = 0;
	self.doa.var_4b3052ec = 0;
	level clientfield::set("set_ui_gprDOA" + self.entnum, 0);
	level clientfield::set("set_ui_gpr2DOA" + self.entnum, 0);
	self.doa.bombs = level.doa.var_52cccfb6.var_2f400c3b;
	self.doa.boosters = self.doa.var_37efabf7;
	self freezecontrols(!level flag::get("doa_challenge_running"));
	wait(0.05);
	self enableinvulnerability();
	self thread function_810ced6b();
	self namespace_5e6c5d1f::function_8397461e();
}

/*
	Name: function_810ced6b
	Namespace: namespace_df93fc7c
	Checksum: 0xB6897C7D
	Offset: 0x4480
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_810ced6b()
{
	wait(1);
	self namespace_2848f8c2::function_d460de4b();
}

/*
	Name: function_ba487e2a
	Namespace: namespace_df93fc7c
	Checksum: 0x2EB73FDA
	Offset: 0x44A8
	Size: 0x2BC
	Parameters: 1
	Flags: Linked
*/
function function_ba487e2a(room)
{
	level clientfield::set("set_scoreHidden", 1);
	room.var_e5c8b9e7 = level.doa.var_bc9b7c71;
	level.doa.var_bc9b7c71 = &function_14e75d7a;
	room.text = &"CP_DOA_BO3_CHALLENGE_ROOM_REDINS";
	room.title = &"CP_DOA_BO3_TITLE_ROOM_REDINS";
	room.vox = "vox_doaa_redins_rally";
	room.var_674e3329 = 1;
	room.var_2f400c3b = math::clamp(2 + (getplayers().size * 2), 4, 8);
	room.var_462dd92 = 50 + (room.var_2f400c3b * 5);
	room.host_migration = &function_c2b99e74;
	if(getdvarint("scr_doa_soak_think", 0) > 1)
	{
		room.var_462dd92 = 10;
	}
	room.var_b57e2384 = room.var_462dd92;
	level thread function_36c315b();
	level thread function_e812f929();
	level clientfield::set("set_ui_GlobalGPR0", room.var_b57e2384);
	foreach(player in getplayers())
	{
		player thread function_14e75d7a();
	}
	level thread namespace_1a381543::function_68fdd800();
	level thread function_10aa3e48(room);
	level flag::set("doa_challenge_ready");
}

/*
	Name: function_f14ef72f
	Namespace: namespace_df93fc7c
	Checksum: 0x9A0113A0
	Offset: 0x4770
	Size: 0x28A
	Parameters: 1
	Flags: Linked
*/
function function_f14ef72f(room)
{
	foreach(player in getplayers())
	{
		player freezecontrols(1);
		player.room = room;
	}
	level waittill(#"hash_7b0c2638");
	level flag::set("doa_challenge_running");
	foreach(player in getplayers())
	{
		player freezecontrols(0);
	}
	level thread function_3ed913b4(room);
	level thread function_455c43ca();
	while(room.var_b57e2384 > 0)
	{
		msg = level util::waittill_any_timeout(1, "redins_rally_complete");
		if(msg == "redins_rally_complete")
		{
			room.title2 = &"CP_DOA_BO3_REDINS_TITLE2_SUCCESS";
			level notify(#"hash_16154574");
			return;
		}
		room.var_b57e2384 = room.var_b57e2384 - 1;
		level clientfield::set("set_ui_GlobalGPR0", room.var_b57e2384);
	}
	room.title2 = &"CP_DOA_BO3_REDINS_TITLE2_FAIL";
	level notify(#"hash_d1f5acf7");
}

/*
	Name: function_10aa3e48
	Namespace: namespace_df93fc7c
	Checksum: 0x2B431BBE
	Offset: 0x4A08
	Size: 0x122
	Parameters: 1
	Flags: Linked
*/
function function_10aa3e48(room)
{
	level waittill(#"fade_in_complete");
	level clientfield::set("redinstutorial", 1);
	level clientfield::set("redinsinstruct", room.var_2f400c3b + (room.var_b57e2384 << 4));
	level waittill(#"hash_97276c43");
	wait(1);
	level clientfield::set("startCountdown", 3);
	wait(4);
	level clientfield::set("redinstutorial", 0);
	level clientfield::set("startCountdown", 0);
	level clientfield::set("redinsinstruct", 0);
	level notify(#"hash_7b0c2638");
}

/*
	Name: function_e13abd74
	Namespace: namespace_df93fc7c
	Checksum: 0x5F30C1DB
	Offset: 0x4B38
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_e13abd74(room)
{
}

/*
	Name: function_9d1b24f7
	Namespace: namespace_df93fc7c
	Checksum: 0x643F4B0F
	Offset: 0x4B50
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_9d1b24f7(room)
{
}

/*
	Name: function_455c43ca
	Namespace: namespace_df93fc7c
	Checksum: 0xABCF65A6
	Offset: 0x4B68
	Size: 0x1AA
	Parameters: 0
	Flags: Linked
*/
function function_455c43ca()
{
	level endon(#"hash_276164a7");
	level endon(#"hash_16154574");
	level endon(#"hash_d1f5acf7");
	level endon(#"hash_9bc1268b");
	level waittill(#"hash_d9dd7818");
	var_48be25f5 = getent("doa_basic_spawner", "targetname");
	spawnpoints = struct::get_array("redins_riser_spot");
	while(true)
	{
		count = doa_utility::function_b99d78c7();
		if(count < getdvarint("scr_redins_enemy_count", 16))
		{
			ai = namespace_51bd792::function_45849d81(var_48be25f5, spawnpoints[randomint(spawnpoints.size)], undefined);
			ai forceteleport(ai.origin, (0, randomint(360), 0));
			ai.doa.var_4d252af6 = 1;
			wait(randomfloatrange(0.1, 2));
		}
		else
		{
			wait(3);
		}
	}
}

/*
	Name: function_ce5fc0d
	Namespace: namespace_df93fc7c
	Checksum: 0x4AB544A5
	Offset: 0x4D20
	Size: 0x384
	Parameters: 1
	Flags: Linked
*/
function function_ce5fc0d(room)
{
	doa_pickups::function_c1869ec8();
	level thread doa_utility::killallenemy();
	doa_utility::function_c157030a();
	waittillframeend();
	foreach(player in getplayers())
	{
		player notify(#"hash_7c5410c4");
		if(isdefined(player.doa))
		{
			if(isdefined(player.doa.vehicle))
			{
				player.doa.vehicle usevehicle(player, 0);
				player.doa.vehicle delete();
				player.doa.vehicle = undefined;
			}
			player namespace_831a4a7c::function_7d7a7fde();
			player disableinvulnerability();
			player.doa.var_3024fd0f = undefined;
			player.doa.var_f30b49ec = 1;
			player.doa.var_3e3bcaa1 = undefined;
			player.doa.var_e651a75e = undefined;
			player.doa.bombs = player.var_b1c8a8a2;
			player.doa.boosters = player.var_e9aff98;
		}
		player namespace_2848f8c2::function_d41a4517();
	}
	spots = struct::get_array("redins_pickup_location");
	level notify(#"ro");
	foreach(spot in spots)
	{
		if(isdefined(spot.gem))
		{
			spot.gem delete();
		}
	}
	level.doa.var_bc9b7c71 = room.var_e5c8b9e7;
	level clientfield::set("set_scoreHidden", 0);
	level clientfield::set("redinsExploder", 0);
}

/*
	Name: function_67b5ba67
	Namespace: namespace_df93fc7c
	Checksum: 0x6C79C7DF
	Offset: 0x50B0
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_67b5ba67()
{
	var_efa02a6c = getent("redins_finish_line", "targetname");
	level endon(#"hash_d1f5acf7");
	level endon(#"hash_16154574");
	while(true)
	{
		var_efa02a6c waittill(#"trigger", truck);
		if(truck.var_f71159da == level.doa.var_c93ed68a)
		{
			truck.var_bbda805b = 1;
			truck.var_f71159da = 0;
		}
	}
}

/*
	Name: function_3ed913b4
	Namespace: namespace_df93fc7c
	Checksum: 0x4C34F18B
	Offset: 0x5170
	Size: 0x6BE
	Parameters: 1
	Flags: Linked
*/
function function_3ed913b4(room)
{
	level endon(#"hash_d1f5acf7");
	level endon(#"hash_16154574");
	var_e0762056 = getentarray("redins_trigger_lap_latch", "targetname");
	foreach(trigger in var_e0762056)
	{
		trigger thread function_c218114a();
	}
	level thread function_67b5ba67();
	winner = undefined;
	var_64c1db98 = 0;
	while(!isdefined(winner))
	{
		players = getplayers();
		foreach(player in players)
		{
			if(!isdefined(player.doa) || !isdefined(player.doa.vehicle))
			{
				continue;
			}
			if(isdefined(player.doa.vehicle.var_bbda805b) && player.doa.vehicle.var_bbda805b)
			{
				player.doa.vehicle.var_bbda805b = undefined;
				switch(players.size)
				{
					case 1:
					{
						bonus = 8;
						break;
					}
					case 2:
					{
						bonus = 4;
						break;
					}
					case 3:
					{
						bonus = 3;
						break;
					}
					case 4:
					default:
					{
						bonus = 2;
						break;
					}
				}
				room.var_b57e2384 = room.var_b57e2384 + bonus;
				if(room.var_b57e2384 > room.var_462dd92)
				{
					room.var_b57e2384 = room.var_462dd92;
				}
				level clientfield::set("set_ui_GlobalGPR0", room.var_b57e2384);
				player.doa.var_de24aff7++;
				playsoundatposition("evt_lap_complete", (0, 0, 0));
				level notify(#"hash_d9dd7818");
				level notify(#"hash_6c12b0a2", player);
			}
			player.doa.bombs = room.var_2f400c3b - player.doa.var_de24aff7;
			player.doa.boosters = player.doa.var_37efabf7;
			if(player.doa.var_de24aff7 == (room.var_2f400c3b - 1) && (!(isdefined(var_64c1db98) && var_64c1db98)))
			{
				var_64c1db98 = 1;
				playsoundatposition("evt_final_lap", (0, 0, 0));
				level clientfield::set("redinsExploder", 1);
				level thread doa_utility::function_c5f3ece8(&"CP_DOA_BO3_LAST_LAP");
				continue;
			}
			if(player.doa.var_de24aff7 >= room.var_2f400c3b)
			{
				level clientfield::set("redinsExploder", 2);
				winner = player;
				break;
			}
		}
		wait(0.1);
	}
	foreach(player in getplayers())
	{
		if(isdefined(player.doa.vehicle))
		{
			player.doa.vehicle setbrake(1);
			player.doa.vehicle setspeedimmediate(0);
			player.doa.var_e651a75e = 1;
		}
	}
	level thread doa_utility::function_c5f3ece8(&"CP_DOA_BO3_REDINS_WINNER");
	wait(4);
	level thread doa_utility::function_37fb5c23(winner.name);
	winner.doa.var_74c73153++;
	spots = struct::get_array("redins_pickup_location");
	level notify(#"hash_e1dc3538");
	winner thread namespace_831a4a7c::function_139199e1();
	level notify(#"hash_276164a7", winner);
}

/*
	Name: function_2228a040
	Namespace: namespace_df93fc7c
	Checksum: 0x7FCF4EC0
	Offset: 0x5838
	Size: 0xAC
	Parameters: 1
	Flags: None
*/
function function_2228a040(item)
{
	self endon(#"disconnect");
	item endon(#"death");
	item.trigger triggerenable(0);
	self thread doa_pickups::function_30768f24(item, 1);
	self waittill(#"hash_30768f24");
	item.trigger triggerenable(1);
	item.trigger notify(#"trigger", self);
}

/*
	Name: function_c218114a
	Namespace: namespace_df93fc7c
	Checksum: 0x7823E39A
	Offset: 0x58F0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_c218114a()
{
	level endon(#"hash_276164a7");
	level endon(#"hash_d1f5acf7");
	myflag = int(self.script_parameters);
	level function_bbb36dbe(myflag);
	while(true)
	{
		self waittill(#"trigger", truck);
		truck.var_f71159da = truck.var_f71159da | (1 << myflag);
		/#
		#/
	}
}

/*
	Name: function_bbb36dbe
	Namespace: namespace_df93fc7c
	Checksum: 0xAE532E53
	Offset: 0x59A8
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function function_bbb36dbe(flag)
{
	if(!isdefined(level.doa.var_c93ed68a))
	{
		level.doa.var_c93ed68a = 0;
	}
	level.doa.var_c93ed68a = level.doa.var_c93ed68a | (1 << flag);
}

/*
	Name: function_fa6d5f56
	Namespace: namespace_df93fc7c
	Checksum: 0x214035AE
	Offset: 0x5A10
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_fa6d5f56()
{
	self endon(#"death");
	if(self clientfield::get("toggle_lights_group1"))
	{
		self vehicle::toggle_lights_group(1, 0);
		util::wait_network_frame();
	}
	self vehicle::toggle_lights_group(1, 1);
	self playsound("veh_doa_boost");
	wait(3);
	self vehicle::toggle_lights_group(1, 0);
}

/*
	Name: function_c71e611c
	Namespace: namespace_df93fc7c
	Checksum: 0xE12E46DE
	Offset: 0x5AD8
	Size: 0x1B6
	Parameters: 1
	Flags: Linked
*/
function function_c71e611c(vehicle)
{
	level endon(#"hash_276164a7");
	level endon(#"hash_d1f5acf7");
	self notify(#"hash_89f9d324");
	self endon(#"hash_89f9d324");
	self endon(#"disconnect");
	vehicle endon(#"death");
	level.launchforce = 500;
	vehicle vehicle::toggle_lights_group(1, 0);
	while(true)
	{
		wait(0.05);
		if(!level flag::get("doa_challenge_running"))
		{
			continue;
		}
		if(isdefined(self.doa.vehicle) && self changeseatbuttonpressed() && self.doa.var_37efabf7 > 0 && (!(isdefined(self.doa.var_e651a75e) && self.doa.var_e651a75e)))
		{
			self.doa.var_37efabf7--;
			curdir = (level.launchforce, 0, 0);
			vehicle launchvehicle(curdir, (0, 0, 0), 1);
			vehicle thread function_fa6d5f56();
			while(self changeseatbuttonpressed())
			{
				wait(0.05);
			}
			wait(1);
		}
	}
}

/*
	Name: function_36c315b
	Namespace: namespace_df93fc7c
	Checksum: 0x970B61CD
	Offset: 0x5C98
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_36c315b()
{
	hazards = getentarray("redins_water_hazard", "targetname");
	level thread function_41ecdf7e(hazards);
}

/*
	Name: function_e812f929
	Namespace: namespace_df93fc7c
	Checksum: 0x2FEBCF83
	Offset: 0x5CF0
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function function_e812f929()
{
	level endon(#"hash_276164a7");
	level endon(#"hash_d1f5acf7");
	spots = struct::get_array("redins_pickup_location");
	foreach(spot in spots)
	{
		spot thread function_fb199a7c();
	}
}

/*
	Name: function_fb199a7c
	Namespace: namespace_df93fc7c
	Checksum: 0xC1D36911
	Offset: 0x5DC0
	Size: 0x1E8
	Parameters: 0
	Flags: Linked
*/
function function_fb199a7c()
{
	level endon(#"hash_276164a7");
	level endon(#"hash_d1f5acf7");
	level endon(#"hash_e1dc3538");
	mytrigger = getent(self.target, "targetname");
	self.gem = doa_pickups::spawnubertreasure(self.origin, 1, 0, 0, 0, 5, self.script_noteworthy, undefined, 0, 0)[0];
	while(true)
	{
		mytrigger waittill(#"trigger", truck);
		if(isplayer(truck))
		{
			continue;
		}
		if(isdefined(truck) && isdefined(truck.owner) && isdefined(self.gem))
		{
			self.gem.trigger notify(#"trigger", truck.owner);
		}
		truck.owner.doa.var_4b3052ec++;
		level clientfield::set("set_ui_gpr2DOA" + truck.owner.entnum, truck.owner.doa.var_4b3052ec);
		wait(randomintrange(15, 45));
		self.gem = doa_pickups::spawnubertreasure(self.origin, 1, 0, 0, 0, 5, self.script_noteworthy, undefined, 0, 0)[0];
	}
}

/*
	Name: function_41ecdf7e
	Namespace: namespace_df93fc7c
	Checksum: 0xBCC6B6FA
	Offset: 0x5FB0
	Size: 0x368
	Parameters: 1
	Flags: Linked
*/
function function_41ecdf7e(triggers)
{
	level endon(#"hash_276164a7");
	level endon(#"hash_d1f5acf7");
	while(true)
	{
		players = getplayers();
		foreach(player in players)
		{
			if(!isdefined(player.doa))
			{
				continue;
			}
			if(isdefined(player.doa.vehicle))
			{
				truck = player.doa.vehicle;
			}
			else
			{
				continue;
			}
			touching = 0;
			foreach(trigger in triggers)
			{
				if(truck istouching(trigger))
				{
					touching = 1;
				}
			}
			if(touching)
			{
				dir = truck getvelocity();
				len = length(dir);
				if(len > 250)
				{
					dir = vectornormalize(dir) * 300;
				}
				dir = dir * -0.2;
				truck launchvehicle(dir, truck.origin + vectorscale((0, 0, 1), 9));
				if(len > 50)
				{
					forward = anglestoforward(truck.angles);
					playfxontag(level._effect["truck_splash"], truck, "tag_grill_d0");
					playfxontag(level._effect["truck_splash"], truck, "tag_bumper_rear_d0");
				}
				player.doa.var_e651a75e = 1;
				continue;
			}
			player.doa.var_e651a75e = 0;
		}
		wait(0.1);
	}
}

/*
	Name: function_d64204d9
	Namespace: namespace_df93fc7c
	Checksum: 0xB5161A51
	Offset: 0x6320
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function function_d64204d9()
{
	level endon(#"hash_276164a7");
	level endon(#"hash_16154574");
	level endon(#"hash_d1f5acf7");
	self endon(#"disconnect");
	self.doa.var_8779c24b = 0;
	while(true)
	{
		self waittill(#"hash_108fd845");
		if(!isdefined(self.room))
		{
			continue;
		}
		self.doa.var_8779c24b++;
		self.doa.gpr++;
		level clientfield::set("set_ui_gprDOA" + self.entnum, self.doa.gpr);
		self.room.var_b57e2384 = self.room.var_b57e2384 + 1;
		level clientfield::set("set_ui_GlobalGPR0", self.room.var_b57e2384);
		if(self.doa.var_8779c24b >= getdvarint("scr_redins_enemy_count", 1))
		{
			self.doa.var_8779c24b = 0;
			self.doa.var_37efabf7++;
			if(self.doa.var_37efabf7 > 3)
			{
				self.doa.var_37efabf7 = 3;
			}
			self.doa.boosters = self.doa.var_37efabf7;
		}
	}
}

/*
	Name: function_dae418ed
	Namespace: namespace_df93fc7c
	Checksum: 0x694F1F85
	Offset: 0x64D8
	Size: 0x3BC
	Parameters: 0
	Flags: Linked
*/
function function_dae418ed()
{
	self endon(#"disconnect");
	while(!isdefined(self.doa))
	{
		wait(0.05);
	}
	waittillframeend();
	startpoints = struct::get_array("truck_soccer_player_spawnpoint");
	foreach(point in startpoints)
	{
		if(self.entnum == int(point.script_noteworthy))
		{
			spot = point;
			break;
		}
	}
	var_f3a9458e = getent("doa_redins_truck", "targetname");
	truck = var_f3a9458e spawner::spawn(1);
	truck setmodel("veh_t7_civ_truck_pickup_tech_nrc_mini_" + namespace_831a4a7c::function_ee495f41(self.entnum));
	truck.origin = spot.origin;
	truck.spawnpoint = spot.origin;
	truck.angles = spot.angles;
	truck.spawnangles = spot.angles;
	truck thread function_9c687a5d(self);
	truck usevehicle(self, 0);
	truck makeunusable();
	truck.takedamage = 0;
	truck.team = self.team;
	truck.owner = self;
	truck.owner.doa.var_e9fdebdf = int(spot.script_parameters);
	self.doa.vehicle = truck;
	self.doa.var_3024fd0f = 1;
	self.doa.var_3e3bcaa1 = 1;
	self thread function_e619ee5(truck);
	truck thread namespace_eaa992c::function_285a2999("gem_trail_" + namespace_831a4a7c::function_ee495f41(self.entnum));
	self freezecontrols(!level flag::get("doa_challenge_running"));
	wait(0.05);
	self enableinvulnerability();
	self thread function_810ced6b();
	self namespace_5e6c5d1f::function_8397461e();
}

/*
	Name: function_c7e4d911
	Namespace: namespace_df93fc7c
	Checksum: 0x64F5F6A0
	Offset: 0x68A0
	Size: 0x364
	Parameters: 1
	Flags: Linked
*/
function function_c7e4d911(room)
{
	room.var_e5c8b9e7 = level.doa.var_bc9b7c71;
	level.doa.var_bc9b7c71 = &function_dae418ed;
	room.text = &"CP_DOA_BO3_CHALLENGE_ROOM_TRUCKSOCCER";
	room.title = &"CP_DOA_BO3_TITLE_ROOM_TRUCKSOCCER";
	room.vox = "vox_doaa_chicken_bowl";
	room.var_7daa1c03 = struct::get("truck_soccer_ball", "targetname");
	room.var_14ee1a58 = getent("doa_mork_veh", "targetname");
	room.safezone = namespace_3ca3c537::function_dc34896f();
	room.host_migration = &function_c2b99e74;
	room.var_677f63c8 = [];
	room.var_efbfafed = 0;
	foreach(player in getplayers())
	{
		player thread function_dae418ed();
	}
	triggers = getentarray("truck_soccerr_goal_trigger", "targetname");
	foreach(trigger in triggers)
	{
		trigger thread function_71be5ae5(room);
	}
	triggers = getentarray("truck_soccer_blowTrigger", "targetname");
	foreach(trigger in triggers)
	{
		trigger thread function_5dac2dae(room);
	}
	level thread function_88777838(room);
	level flag::set("doa_challenge_ready");
}

/*
	Name: function_5284e8dc
	Namespace: namespace_df93fc7c
	Checksum: 0xC8C11D9B
	Offset: 0x6C10
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function function_5284e8dc(room)
{
	level endon(#"hash_4f4a6e14");
	if(room.var_677f63c8.size > getdvarint("scr_doa_chicken_balls_max", 3))
	{
		return;
	}
	room.var_14ee1a58.ignorespawninglimit = 1;
	var_29833f21 = room.var_14ee1a58 spawner::spawn(1, undefined, (0, 0, 0));
	var_29833f21.origin = room.var_7daa1c03.origin;
	wait(0.05);
	var_29833f21.health = 6000;
	var_29833f21.var_6977f7b9 = 1;
	var_29833f21 launchvehicle(vectorscale((0, 0, 1), 100), (0, 0, 0), 1, 1);
	room.var_677f63c8[room.var_677f63c8.size] = var_29833f21;
	var_29833f21 thread function_76dd5557(room);
}

/*
	Name: function_76dd5557
	Namespace: namespace_df93fc7c
	Checksum: 0x63F59C27
	Offset: 0x6D78
	Size: 0x168
	Parameters: 1
	Flags: Linked
*/
function function_76dd5557(room)
{
	self endon(#"death");
	wait(8);
	while(true)
	{
		if(isdefined(self) && !self istouching(room.safezone))
		{
			arrayremovevalue(room.var_677f63c8, self);
			self delete();
		}
		if(isdefined(self.var_a2d7b04a))
		{
			self.var_a2d7b04a thread function_db9097e4(room);
			self thread namespace_1a381543::function_90118d8c("zmb_eggbowl_goal");
			level thread function_8f4c809d(room, self.var_a2d7b04a);
			arrayremovevalue(room.var_677f63c8, self);
			wait(5);
			self thread namespace_eaa992c::function_285a2999("egg_hatch");
			util::wait_network_frame();
			self delete();
		}
		wait(0.05);
	}
}

/*
	Name: function_90585f48
	Namespace: namespace_df93fc7c
	Checksum: 0xE88A10D1
	Offset: 0x6EE8
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function function_90585f48(room)
{
	level endon(#"hash_4f4a6e14");
	while(true)
	{
		level thread function_5284e8dc(room);
		wait(8);
	}
}

/*
	Name: function_ebb572b
	Namespace: namespace_df93fc7c
	Checksum: 0x754A7181
	Offset: 0x6F30
	Size: 0x1B2
	Parameters: 1
	Flags: Linked
*/
function function_ebb572b(player)
{
	var_516eed4b = randomint(6) + 1;
	switch(player.entnum)
	{
		case 0:
		{
			gem = "zombietron_emerald";
			break;
		}
		case 1:
		{
			gem = "zombietron_sapphire";
			break;
		}
		case 2:
		{
			gem = "zombietron_ruby";
			break;
		}
		case 3:
		{
			gem = "zombietron_beryl";
			break;
		}
	}
	items = level doa_pickups::spawnubertreasure(self.origin, var_516eed4b, 2, 0, 0, 3, gem);
	wait(1);
	foreach(item in items)
	{
		if(!isdefined(item))
		{
			continue;
		}
		if(isdefined(item.trigger))
		{
			item.trigger notify(#"trigger", player);
		}
		wait(0.5);
	}
}

/*
	Name: function_db9097e4
	Namespace: namespace_df93fc7c
	Checksum: 0x2166CA00
	Offset: 0x70F0
	Size: 0xA2
	Parameters: 1
	Flags: Linked
*/
function function_db9097e4(room)
{
	foreach(player in self.var_f1e29613)
	{
		if(!isdefined(player))
		{
			continue;
		}
		self thread function_ebb572b(player);
	}
}

/*
	Name: function_7c9617ef
	Namespace: namespace_df93fc7c
	Checksum: 0x6C501E7A
	Offset: 0x71A0
	Size: 0xCE
	Parameters: 2
	Flags: Linked
*/
function function_7c9617ef(var_7bb420a0, goaltrigger)
{
	self endon(#"death");
	level waittill(#"hash_130fa748");
	while(true)
	{
		self moveto(goaltrigger.posts[var_7bb420a0].origin, goaltrigger.movetime);
		self util::waittill_any_timeout(goaltrigger.movetime + 0.25, "movedone");
		var_7bb420a0++;
		if(var_7bb420a0 >= goaltrigger.posts.size)
		{
			var_7bb420a0 = 0;
		}
	}
}

/*
	Name: function_60fcd122
	Namespace: namespace_df93fc7c
	Checksum: 0x3F70F413
	Offset: 0x7278
	Size: 0x734
	Parameters: 2
	Flags: Linked
*/
function function_60fcd122(room, goaltrigger)
{
	level endon(#"hash_4f4a6e14");
	goaltrigger.movetime = getdvarfloat("scr_doa_chicken_bowl_glow_default_speed", 1.25);
	goaltrigger.posts = [];
	goaltrigger.posts[goaltrigger.posts.size] = struct::get(goaltrigger.target, "targetname");
	goaltrigger.colors = strtok(goaltrigger.posts[0].script_parameters, " ");
	next = struct::get(goaltrigger.posts[0].target, "targetname");
	while(next != goaltrigger.posts[0])
	{
		goaltrigger.posts[goaltrigger.posts.size] = next;
		next = struct::get(next.target, "targetname");
	}
	idx = 1;
	foreach(glow in goaltrigger.posts)
	{
		glow.org = spawn("script_model", glow.origin);
		glow.org.targetname = "glowOrg";
		glow.org setmodel("tag_origin");
		glow.org thread function_7c9617ef(idx, goaltrigger);
		idx++;
		if(idx >= goaltrigger.posts.size)
		{
			idx = 0;
		}
	}
	lastcount = 0;
	while(true)
	{
		if(goaltrigger.var_f1e29613.size == 0)
		{
			if(goaltrigger.var_f1e29613.size != lastcount)
			{
				foreach(glow in goaltrigger.posts)
				{
					if(!isdefined(glow.org))
					{
						continue;
					}
					foreach(color in goaltrigger.colors)
					{
						glow.org thread namespace_eaa992c::turnofffx("gem_trail_" + color);
					}
				}
				lastcount = 0;
			}
			wait(0.05);
			continue;
		}
		if(goaltrigger.var_f1e29613.size != lastcount)
		{
			count = 0;
			foreach(glow in goaltrigger.posts)
			{
				if(!isdefined(glow.org))
				{
					continue;
				}
				foreach(color in goaltrigger.colors)
				{
					glow.org thread namespace_eaa992c::turnofffx("gem_trail_" + color);
				}
				count++;
			}
			while(count > 0)
			{
				level util::waittill_any_timeout(1, "off_fx_queue_processed", "trucksoccer_rally_complete");
				count--;
			}
			idx = 0;
			foreach(glow in goaltrigger.posts)
			{
				if(!isdefined(glow.org))
				{
					continue;
				}
				player = goaltrigger.var_f1e29613[idx];
				idx++;
				if(idx >= goaltrigger.var_f1e29613.size)
				{
					idx = 0;
				}
				if(isdefined(player))
				{
					glow.org thread namespace_eaa992c::function_285a2999("gem_trail_" + namespace_831a4a7c::function_ee495f41(player.entnum));
				}
			}
			lastcount = goaltrigger.var_f1e29613.size;
		}
		wait(0.05);
	}
}

/*
	Name: function_5dac2dae
	Namespace: namespace_df93fc7c
	Checksum: 0xBB709A70
	Offset: 0x79B8
	Size: 0x248
	Parameters: 1
	Flags: Linked
*/
function function_5dac2dae(room)
{
	level endon(#"hash_4f4a6e14");
	self.org = spawn("script_model", self.origin);
	self.org.targetname = "trucksoccer_BlowTriggerThink";
	self.org setmodel("tag_origin");
	self.org thread namespace_eaa992c::function_285a2999("blow_hole");
	while(true)
	{
		self waittill(#"trigger", guy);
		if(!isdefined(guy))
		{
			continue;
		}
		if(isactor(guy) && (!(isdefined(guy.launched) && guy.launched)))
		{
			guy startragdoll();
			guy launchragdoll((0, 0, 220 + randomint(40)));
			guy.launched = 1;
			guy thread doa_utility::function_ba30b321(0.2);
		}
		else
		{
			if(isdefined(guy.var_6977f7b9) && guy.var_6977f7b9)
			{
				guy launchvehicle((0, 0, getdvarint("scr_doa_chicken_bowl_blow_force", 5)), (0, 0, 0), 1);
			}
			else if(isvehicle(guy))
			{
				guy launchvehicle((0, 0, getdvarint("scr_doa_chicken_bowl_blow_force", 50)), (0, 0, 0), 1);
			}
		}
	}
}

/*
	Name: function_8f4c809d
	Namespace: namespace_df93fc7c
	Checksum: 0x51DBD4EB
	Offset: 0x7C08
	Size: 0xC0
	Parameters: 2
	Flags: Linked
*/
function function_8f4c809d(room, goaltrigger)
{
	level endon(#"hash_4f4a6e14");
	goaltrigger notify(#"hash_8f4c809d");
	goaltrigger endon(#"hash_8f4c809d");
	room.var_efbfafed++;
	goaltrigger.movetime = getdvarfloat("scr_doa_chicken_bowl_glow_goal_speed", 0.1);
	wait(getdvarfloat("scr_doa_chicken_bowl_glow_celebrate_time", 4));
	goaltrigger.movetime = getdvarfloat("scr_doa_chicken_bowl_glow_default_speed", 1.25);
}

/*
	Name: function_71be5ae5
	Namespace: namespace_df93fc7c
	Checksum: 0xBE388BA4
	Offset: 0x7CD0
	Size: 0x268
	Parameters: 1
	Flags: Linked
*/
function function_71be5ae5(room)
{
	level endon(#"hash_4f4a6e14");
	self.var_f1e29613 = [];
	self.myteam = int(self.script_noteworthy);
	level thread function_60fcd122(room, self);
	while(true)
	{
		foreach(var_29833f21 in room.var_677f63c8)
		{
			if(isdefined(var_29833f21) && var_29833f21 istouching(self))
			{
				var_29833f21.var_a2d7b04a = self;
			}
		}
		var_9365e303 = 0;
		players = getplayers();
		self.var_f1e29613 = [];
		foreach(player in players)
		{
			if(!isdefined(player))
			{
				continue;
			}
			if(!isdefined(player.doa))
			{
				continue;
			}
			if(isdefined(player.doa.var_e9fdebdf) && player.doa.var_e9fdebdf == self.myteam)
			{
				if(!isinarray(self.var_f1e29613, player))
				{
					self.var_f1e29613[self.var_f1e29613.size] = player;
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_88777838
	Namespace: namespace_df93fc7c
	Checksum: 0xD6B17B88
	Offset: 0x7F40
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function function_88777838(room)
{
	level waittill(#"hash_97276c43");
	wait(1);
	level clientfield::set("startCountdown", 3);
	wait(4);
	level clientfield::set("startCountdown", 0);
	level notify(#"hash_130fa748");
}

/*
	Name: function_92349eb6
	Namespace: namespace_df93fc7c
	Checksum: 0xB6831738
	Offset: 0x7FC0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_92349eb6(room)
{
}

/*
	Name: function_fd4f5419
	Namespace: namespace_df93fc7c
	Checksum: 0xD380A261
	Offset: 0x7FD8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function function_fd4f5419(room)
{
}

/*
	Name: function_2ea4cb82
	Namespace: namespace_df93fc7c
	Checksum: 0x45046AA7
	Offset: 0x7FF0
	Size: 0x2CC
	Parameters: 1
	Flags: Linked
*/
function function_2ea4cb82(room)
{
	foreach(player in getplayers())
	{
		player freezecontrols(1);
		player.room = room;
		if(isdefined(player.doa))
		{
			player.doa.var_1951557 = 1;
		}
	}
	level waittill(#"hash_130fa748");
	level flag::set("doa_challenge_running");
	foreach(player in getplayers())
	{
		player freezecontrols(0);
		player.room = room;
		if(isdefined(player.doa))
		{
			player.doa.var_1951557 = undefined;
		}
	}
	level thread function_55e9043d();
	level thread function_90585f48(room);
	if(getdvarint("scr_doa_soak_think", 0) > 1)
	{
		wait(5);
	}
	else
	{
		wait(room.timeout - 1);
	}
	if(room.var_efbfafed > (getplayers().size * 3))
	{
		level notify(#"hash_16154574");
	}
	else
	{
		level notify(#"hash_d1f5acf7");
	}
	playsoundatposition("zmb_eggbowl_whistle", (0, 0, 0));
	level notify(#"hash_4f4a6e14");
	doa_pickups::function_c1869ec8();
}

/*
	Name: function_baa38e65
	Namespace: namespace_df93fc7c
	Checksum: 0xD2D3B733
	Offset: 0x82C8
	Size: 0x222
	Parameters: 1
	Flags: Linked
*/
function function_baa38e65(room)
{
	triggers = getentarray("truck_soccerr_goal_trigger", "targetname");
	foreach(trigger in triggers)
	{
		if(isdefined(trigger.posts))
		{
			foreach(post in trigger.posts)
			{
				if(isdefined(post.org))
				{
					post.org delete();
				}
			}
		}
	}
	triggers = getentarray("truck_soccer_blowTrigger", "targetname");
	foreach(trigger in triggers)
	{
		if(isdefined(trigger.org))
		{
			trigger.org delete();
		}
	}
}

/*
	Name: function_55e9043d
	Namespace: namespace_df93fc7c
	Checksum: 0x18C9FDCA
	Offset: 0x84F8
	Size: 0x1E2
	Parameters: 0
	Flags: Linked
*/
function function_55e9043d()
{
	level endon(#"hash_16154574");
	level endon(#"hash_d1f5acf7");
	level endon(#"hash_4f4a6e14");
	while(true)
	{
		level waittill(#"hash_c62f5087", left);
		if(left == 50)
		{
			break;
		}
	}
	var_48be25f5 = getent("doa_basic_spawner", "targetname");
	spawnpoints = struct::get_array("truck_soccer_dirt_spawner");
	while(true)
	{
		count = doa_utility::function_b99d78c7();
		if(count < getdvarint("scr_trucksoccer_enemy_count", 50))
		{
			ai = namespace_51bd792::function_45849d81(var_48be25f5, spawnpoints[randomint(spawnpoints.size)], undefined);
			if(isdefined(ai))
			{
				ai forceteleport(ai.origin, (0, randomint(360), 0));
				ai notify(#"hash_6e8326fc");
				ai thread doa_utility::function_24245456(level, "trucksoccer_rally_complete");
			}
			wait(randomfloatrange(0.05, 0.4));
		}
		else
		{
			wait(3);
		}
	}
}

/*
	Name: function_b3939e94
	Namespace: namespace_df93fc7c
	Checksum: 0xC3360678
	Offset: 0x86E8
	Size: 0x2B2
	Parameters: 1
	Flags: Linked
*/
function function_b3939e94(room)
{
	level notify(#"hash_4f4a6e14");
	doa_pickups::function_c1869ec8();
	level thread doa_utility::killallenemy();
	function_baa38e65(room);
	foreach(player in getplayers())
	{
		player notify(#"hash_7c5410c4");
		if(isdefined(player) && isdefined(player.doa))
		{
			if(isdefined(player.doa.vehicle))
			{
				player.doa.vehicle usevehicle(player, 0);
				player.doa.vehicle delete();
				player.doa.vehicle = undefined;
			}
			player.doa.var_3024fd0f = undefined;
			player.doa.var_3e3bcaa1 = undefined;
			player disableinvulnerability();
			player thread namespace_831a4a7c::turnplayershieldon(0);
			player namespace_2848f8c2::function_d41a4517();
		}
	}
	level.doa.var_bc9b7c71 = room.var_e5c8b9e7;
	foreach(egg in room.var_677f63c8)
	{
		if(isdefined(egg))
		{
			egg delete();
		}
	}
}

/*
	Name: function_6274a031
	Namespace: namespace_df93fc7c
	Checksum: 0x3477AC80
	Offset: 0x89A8
	Size: 0xBC
	Parameters: 0
	Flags: None
*/
function function_6274a031()
{
	self endon(#"death");
	if(self clientfield::get("toggle_lights_group1"))
	{
		self vehicle::toggle_lights_group(1, 0);
		util::wait_network_frame();
	}
	self vehicle::toggle_lights_group(1, 1);
	self playsound("veh_doa_boost");
	wait(3);
	self vehicle::toggle_lights_group(1, 0);
}

/*
	Name: function_e619ee5
	Namespace: namespace_df93fc7c
	Checksum: 0xA47A4758
	Offset: 0x8A70
	Size: 0x1E0
	Parameters: 1
	Flags: Linked
*/
function function_e619ee5(vehicle)
{
	level endon(#"hash_4f4a6e14");
	level endon(#"hash_d1f5acf7");
	self notify(#"hash_2747daf7");
	self endon(#"hash_2747daf7");
	self endon(#"disconnect");
	vehicle endon(#"death");
	level.launchforce = 500;
	vehicle vehicle::toggle_lights_group(1, 0);
	self.doa.var_f6a4f3f = 0;
	while(true)
	{
		wait(0.05);
		if(!level flag::get("doa_challenge_running"))
		{
			continue;
		}
		if(isdefined(self.doa.vehicle) && self changeseatbuttonpressed() && gettime() > self.doa.var_f6a4f3f && (!(isdefined(self.doa.var_1951557) && self.doa.var_1951557)))
		{
			self.doa.var_f6a4f3f = gettime() + getdvarint("scr_doa_chicken_bowl_boostinterval", 4000);
			curdir = (level.launchforce, 0, 0);
			vehicle launchvehicle(curdir, (0, 0, 0), 1);
			vehicle thread function_fa6d5f56();
			while(self changeseatbuttonpressed())
			{
				wait(0.05);
			}
		}
	}
}

/*
	Name: function_c0485deb
	Namespace: namespace_df93fc7c
	Checksum: 0xA4CA3F8D
	Offset: 0x8C58
	Size: 0x280
	Parameters: 1
	Flags: Linked
*/
function function_c0485deb(def)
{
	level endon(#"exit_taken");
	wait(7);
	level thread function_c35db0c1();
	var_a558424 = struct::get_array("farm_cow_spawn", "script_noteworthy");
	level.doa.var_99f9e71a["top"] = [];
	level.doa.var_99f9e71a["bottom"] = [];
	level.doa.var_99f9e71a["right"] = [];
	level.doa.var_99f9e71a["left"] = [];
	foreach(cow in var_a558424)
	{
		level.doa.var_99f9e71a[cow.script_parameters][level.doa.var_99f9e71a[cow.script_parameters].size] = cow;
	}
	lastside = doa_utility::function_5b4fbaef();
	lastlastside = lastside;
	while(level flag::get("doa_round_spawning"))
	{
		side = doa_utility::function_5b4fbaef();
		if(side == lastside || side == lastlastside)
		{
			wait(0.05);
			continue;
		}
		lastlastside = lastside;
		lastside = side;
		level function_dfbad276(randomintrange(5, 10), side);
		wait(randomintrange(1, 3));
	}
}

/*
	Name: function_dfbad276
	Namespace: namespace_df93fc7c
	Checksum: 0x5A525E22
	Offset: 0x8EE0
	Size: 0x526
	Parameters: 2
	Flags: Linked
*/
function function_dfbad276(number, startside)
{
	level endon(#"exit_taken");
	spawn_locations = level.doa.var_99f9e71a[startside];
	while(number > 0)
	{
		spawn_point = spawn_locations[randomint(spawn_locations.size)];
		dest_point = struct::get(spawn_point.target, "targetname");
		trace = bullettrace(spawn_point.origin, spawn_point.origin + (vectorscale((0, 0, -1), 500)), 0, undefined);
		spawn_point = (spawn_point.origin[0], spawn_point.origin[1], trace["position"][2]);
		trace = bullettrace(dest_point.origin, dest_point.origin + (vectorscale((0, 0, -1), 500)), 0, undefined);
		dest_point = (dest_point.origin[0], dest_point.origin[1], trace["position"][2]);
		desired_angles = vectortoangles(dest_point - spawn_point);
		var_3e02e245 = angleclamp180(desired_angles[1]);
		cow = spawn("script_model", spawn_point);
		cow.targetname = "cow";
		cow.angles = (0, var_3e02e245 + 90, 0);
		cow setmodel("zombietron_water_buffalo");
		cow makefakeai();
		cow setcandamage(1);
		cow.health = 3999999;
		cow.team = "axis";
		cow.script_noteworthy = "cow";
		cow.move_dist = distance(cow.origin, dest_point);
		cow.move_time = cow.move_dist / getdvarint("cp_doa_cow_run_units_per_sec", 207);
		cow setplayercollision(1);
		cow playloopsound("zmb_cow_run_lp", 2);
		if(randomint(getdvarint("cp_doa_sacred_cow_chance", 20)) == 0)
		{
			cow.sacred = 1;
			cow thread namespace_eaa992c::function_285a2999("cow_sacred");
		}
		trigger = spawn("trigger_radius", cow.origin + (vectorscale((0, 0, -1), 10)), 3, 34, 100);
		trigger.targetname = "cow";
		trigger enablelinkto();
		trigger linkto(cow);
		trigger thread cow_damage_trigger(cow);
		trigger thread doa_utility::function_981c685d(cow);
		cow.trigger = trigger;
		cow thread run_cow_run(dest_point);
		cow thread cow_deleter();
		wait(randomfloatrange(0.65, 2.5));
		number--;
	}
}

/*
	Name: function_caf96f2d
	Namespace: namespace_df93fc7c
	Checksum: 0x1E11E6BA
	Offset: 0x9410
	Size: 0x86
	Parameters: 0
	Flags: None
*/
function function_caf96f2d()
{
	self endon(#"death");
	self useanimtree($critter);
	while(true)
	{
		self animscripted("anim", self.origin, self.angles, self.animation);
		self waittillmatch(#"anim");
	}
}

/*
	Name: function_c9a224d9
	Namespace: namespace_df93fc7c
	Checksum: 0x6647C26B
	Offset: 0x94A0
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function function_c9a224d9()
{
	self endon(#"death");
	level waittill(#"exit_taken");
	self notify(#"medium_rare");
}

/*
	Name: cow_deleter
	Namespace: namespace_df93fc7c
	Checksum: 0xB1FB16E2
	Offset: 0x94D8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function cow_deleter()
{
	self endon(#"death");
	self thread function_c9a224d9();
	self waittill(#"medium_rare");
	util::wait_network_frame();
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: run_cow_run
	Namespace: namespace_df93fc7c
	Checksum: 0xF43C9C52
	Offset: 0x9548
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function run_cow_run(dest)
{
	self endon(#"death");
	self useanimtree($critter);
	self.animation = (randomint(2) ? %critter::a_water_buffalo_run_a : %critter::a_water_buffalo_run_b);
	self clientfield::set("runcowanim", 1);
	self thread cow_damage_watch();
	self moveto(dest, self.move_time, 0, 0);
	self waittill(#"movedone");
	self notify(#"medium_rare");
}

/*
	Name: cow_damage_trigger
	Namespace: namespace_df93fc7c
	Checksum: 0x61A5472F
	Offset: 0x9640
	Size: 0x278
	Parameters: 1
	Flags: Linked
*/
function cow_damage_trigger(cow)
{
	cow endon(#"death");
	while(true)
	{
		self waittill(#"trigger", guy);
		if(!isdefined(guy))
		{
			continue;
		}
		if(isdefined(guy.launched))
		{
			continue;
		}
		if(!issentient(guy))
		{
			continue;
		}
		if(!(isdefined(guy.takedamage) && guy.takedamage))
		{
			continue;
		}
		if(isdefined(guy.boss))
		{
			continue;
		}
		guy playsound("zmb_buffalo_impact");
		if(!isplayer(guy))
		{
			if(!isvehicle(guy))
			{
				guy clientfield::set("zombie_rhino_explosion", 1);
				namespace_fba031c8::trygibbinglimb(guy, 5000);
				namespace_fba031c8::trygibbinglegs(guy, 5000, undefined, 1);
				guy setplayercollision(0);
				guy startragdoll();
				guy launchragdoll(vectorscale((0, 0, 1), 220));
				guy.launched = 1;
				guy playsound("zmb_ragdoll_launched");
				guy thread doa_utility::function_ba30b321(0.2);
			}
			else
			{
				guy kill(guy.origin);
			}
		}
		else
		{
			guy dodamage(guy.health + 1000, guy.origin, undefined, undefined, "MOD_EXPLOSIVE");
		}
	}
}

/*
	Name: cow_damage_watch
	Namespace: namespace_df93fc7c
	Checksum: 0xA72D981B
	Offset: 0x98C0
	Size: 0x2C4
	Parameters: 0
	Flags: Linked
*/
function cow_damage_watch()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage", damagetaken, attacker, dir, point, dmg_type, model, tag, part, weapon, flags);
		if(dmg_type == "MOD_PROJECTILE" || dmg_type == "MOD_GRENADE" || dmg_type == "MOD_CRUSH" || weapon == level.doa.var_69899304)
		{
			if(isdefined(attacker))
			{
				if(isdefined(attacker.owner))
				{
					attacker = attacker.owner;
				}
				if(isplayer(attacker))
				{
					attacker.doa.var_ec573900++;
				}
			}
			self thread namespace_eaa992c::function_285a2999("cow_explode");
			self playsound("zmb_cow_explode");
			self notify(#"medium_rare");
			if(isdefined(self.sacred))
			{
				if(isplayer(attacker))
				{
					attacker.doa.var_130471f++;
				}
				self playsound("zmb_cow_explode_gold");
				location = self.origin;
				var_888caf9f = namespace_831a4a7c::function_5eb6e4d1().size + 10;
				maxamount = namespace_831a4a7c::function_5eb6e4d1().size + 20;
				level thread doa_pickups::spawnubertreasure(location, randomintrange(var_888caf9f, maxamount), 85, 1, 1, 1, undefined, 0);
				self.sacred = undefined;
			}
		}
		else
		{
			self.health = self.health + damagetaken;
		}
	}
}

/*
	Name: random_cow_stampede
	Namespace: namespace_df93fc7c
	Checksum: 0xCF675A3E
	Offset: 0x9B90
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function random_cow_stampede()
{
	level endon(#"exit_taken");
	while(level flag::get("doa_round_active") && !level flag::get("doa_game_is_over"))
	{
		side = doa_utility::function_5b4fbaef();
		function_dfbad276(randomintrange(2, 6), side);
		wait(randomintrange(10, 30));
	}
}

/*
	Name: function_c35db0c1
	Namespace: namespace_df93fc7c
	Checksum: 0x139EB767
	Offset: 0x9C58
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_c35db0c1()
{
	level endon(#"hash_6df89d17");
	while(!level flag::get("doa_game_is_over"))
	{
		level waittill(#"round_spawning_starting");
		wait(10);
		level thread random_cow_stampede();
	}
}

