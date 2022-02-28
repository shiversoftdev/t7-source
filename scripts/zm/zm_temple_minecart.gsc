// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace zm_temple_minecart;

/*
	Name: precache_assets
	Namespace: zm_temple_minecart
	Checksum: 0x62CAB016
	Offset: 0x5A8
	Size: 0x1E
	Parameters: 0
	Flags: None
*/
function precache_assets()
{
	level._effect["fx_headlight"] = "env/light/fx_flashlight_ai_spotlight";
}

/*
	Name: minecart_main
	Namespace: zm_temple_minecart
	Checksum: 0x4FB7C879
	Offset: 0x5D0
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function minecart_main()
{
	level flag::init("players_riding_minecart");
	level.var_b2360d92 = getentarray("minecart_lever_trigger", "targetname");
	for(i = 0; i < level.var_b2360d92.size; i++)
	{
		level.var_b2360d92[i] thread function_f8358462();
	}
}

/*
	Name: function_807ee0b0
	Namespace: zm_temple_minecart
	Checksum: 0x8C7FB37F
	Offset: 0x670
	Size: 0x764
	Parameters: 0
	Flags: Linked
*/
function function_807ee0b0()
{
	self.drivepath = 0;
	self.accel = 5;
	self.decel = 30;
	self.loopingpath = self.script_string === "loopingPath";
	self.away = 0;
	self.passengers = [];
	self.var_d20e4724 = 24;
	self.width = 20;
	self.linkents = [];
	function_2ae67320((50, self.width, self.var_d20e4724));
	function_2ae67320((50, 0 - self.width, self.var_d20e4724));
	function_2ae67320((-66, self.width, self.var_d20e4724));
	function_2ae67320((-66, 0 - self.width, self.var_d20e4724));
	function_2ae67320((-8, 0, self.var_d20e4724));
	self.var_66b5ee1a = (87, 0, 15);
	self.var_fdb1feb7 = (0, 0, 0);
	self.var_88249cb5 = (0 - self.var_66b5ee1a[0], self.var_66b5ee1a[1], self.var_66b5ee1a[2]);
	self.var_629f3738 = vectorscale((0, 1, 0), 180);
	self.var_c25552a2 = getent(self.targetname + "_start_switch", "targetname");
	self.cage = getent(self.targetname + "_cage", "targetname");
	if(isdefined(self.cage))
	{
		self.cage linkto(self);
	}
	self.var_cd74abf8 = getent(self.targetname + "_cage_door", "targetname");
	if(isdefined(self.var_cd74abf8))
	{
		self.var_cd74abf8 linkto(self);
		self.var_cd74abf8 notsolid();
	}
	self.door = getent(self.targetname + "_door", "targetname");
	if(isdefined(self.door))
	{
		self.door.closed = 1;
		self.door.clip = getent(self.targetname + "_door_clip", "targetname");
		self thread function_c379c791(1);
	}
	self.pusher = getent(self.targetname + "_pusher", "targetname");
	if(isdefined(self.pusher))
	{
		self.pusher.out = 0;
	}
	self.floor = getent(self.targetname + "_floor", "targetname");
	if(isdefined(self.floor))
	{
		self.floor linkto(self);
	}
	self.front = getent(self.targetname + "_front", "targetname");
	if(isdefined(self.front))
	{
		self.front linkto(self);
	}
	self.var_54b40cc8 = getentarray(self.targetname + "_front_door", "targetname");
	self.var_ab67891f = 1;
	self.var_7c850021 = getent(self.targetname + "_front_door_clip", "targetname");
	self.var_a1647650 = getent(self.targetname + "_start_volume", "targetname");
	if(isdefined(self.var_a1647650))
	{
		self.var_a1647650.minecart = self;
		self.var_a1647650 thread function_7fec5b68();
	}
	self.var_be938773 = getent("trigger_minecart_water_splash", "targetname");
	if(isdefined(self.var_be938773))
	{
		self.var_be938773 thread function_68c61932();
	}
	self.speaker_left = spawn("script_model", self.origin);
	self.speaker_left setmodel("tag_origin");
	self.speaker_left linkto(self, "tag_origin", (0, 32, 40));
	util::wait_network_frame();
	self.speaker_right = spawn("script_model", self.origin);
	self.speaker_right setmodel("tag_origin");
	self.speaker_right linkto(self, "tag_origin", (0, -32, 40));
	blockers = getentarray(self.targetname + "_blocker", "targetname");
	array::thread_all(blockers, &blocker_think, self);
	level.minecart_force_zone_active = 0;
	self function_b6cb1d5a("start");
	self function_f16a275();
}

/*
	Name: blocker_think
	Namespace: zm_temple_minecart
	Checksum: 0x7BF882AF
	Offset: 0xDE0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function blocker_think(minecart)
{
	minecart endon(#"hash_76e3734");
	minecart waittill(#"hash_4c5d405f");
	while(true)
	{
		if(self function_742e2b0d(minecart))
		{
			self thread function_78442d5();
			break;
		}
		wait(0.05);
	}
}

/*
	Name: function_742e2b0d
	Namespace: zm_temple_minecart
	Checksum: 0xDAD062F3
	Offset: 0xE58
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function function_742e2b0d(minecart)
{
	dist2 = distance2dsquared(minecart.origin, self.origin);
	return dist2 < 4900;
}

/*
	Name: function_1306489b
	Namespace: zm_temple_minecart
	Checksum: 0xDFFBA077
	Offset: 0xEB0
	Size: 0x70
	Parameters: 0
	Flags: None
*/
function function_1306489b()
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] istouching(self))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_78442d5
	Namespace: zm_temple_minecart
	Checksum: 0x153B5B05
	Offset: 0xF28
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_78442d5()
{
	level thread scene::play("p7_fxanim_zm_sha_minecart_gate_bundle");
	exploder::exploder("fxexp_400");
	self playsound("evt_minecart_barrier");
}

/*
	Name: function_2ae67320
	Namespace: zm_temple_minecart
	Checksum: 0x82DFFCBA
	Offset: 0xF90
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function function_2ae67320(offsetorigin)
{
	linkent = spawn("script_model", (0, 0, 0));
	linkent.offsetorigin = offsetorigin;
	linkent linkto(self, "", linkent.offsetorigin, (0, 0, 0));
	linkent setmodel("tag_origin");
	linkent.occupied = 0;
	self.linkents[self.linkents.size] = linkent;
	util::wait_network_frame();
}

/*
	Name: function_46d092ff
	Namespace: zm_temple_minecart
	Checksum: 0x1B994E5B
	Offset: 0x1070
	Size: 0x4CC
	Parameters: 0
	Flags: Linked
*/
function function_46d092ff()
{
	wait(0.5);
	players = getplayers();
	if(isdefined(self.var_cd74abf8))
	{
		self.var_cd74abf8 solid();
	}
	for(i = 0; i < self.linkents.size; i++)
	{
		self.linkents[i].claimed = 0;
	}
	var_c22b6489 = [];
	for(p = 0; p < players.size; p++)
	{
		player = players[p];
		closestent = undefined;
		closestdist = 0;
		var_99732e8 = self function_a3fe9db2(player);
		if(!var_99732e8)
		{
			continue;
		}
		var_c22b6489[var_c22b6489.size] = player;
		for(e = 0; e < self.linkents.size; e++)
		{
			linkent = self.linkents[e];
			dist = distancesquared(player.origin, linkent.origin);
			if(!linkent.claimed && (!isdefined(closestent) || dist < closestdist))
			{
				closestent = linkent;
				closestdist = dist;
			}
		}
		closestent.claimed = 1;
		player.var_68072c39 = closestent;
	}
	array::thread_all(var_c22b6489, &function_3ae7bd53, self);
	level thread function_82d1ad64(var_c22b6489);
	zombies = getaispeciesarray("axis", "all");
	zombie_sort = util::get_array_of_closest(self.origin, zombies, undefined, undefined, 300);
	self.var_54277932 = [];
	for(i = 0; i < zombie_sort.size; i++)
	{
		zombie = zombie_sort[i];
		closestent = undefined;
		closestdist = 0;
		if(zombie.animname == "monkey_zombie")
		{
			continue;
		}
		if(isdefined(zombie.shrinked) && zombie.shrinked)
		{
			continue;
		}
		var_a9be802d = self function_a3fe9db2(zombie);
		if(!var_a9be802d)
		{
			continue;
		}
		for(e = 0; e < self.linkents.size; e++)
		{
			linkent = self.linkents[e];
			dist = distancesquared(zombie.origin, linkent.origin);
			if(!linkent.claimed && (!isdefined(closestent) || dist < closestdist))
			{
				closestent = linkent;
				closestdist = dist;
			}
		}
		if(isdefined(closestent))
		{
			closestent.claimed = 1;
			zombie.var_68072c39 = closestent;
			self.var_54277932[self.var_54277932.size] = zombie;
		}
	}
	array::thread_all(self.var_54277932, &function_a676846, self);
}

/*
	Name: function_3ae7bd53
	Namespace: zm_temple_minecart
	Checksum: 0x3867337F
	Offset: 0x1548
	Size: 0x16C
	Parameters: 1
	Flags: Linked
*/
function function_3ae7bd53(minecart)
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"hash_76e3734");
	self.is_on_minecart = 1;
	self allowsprint(0);
	turn_angle = 360;
	pitch_up = 90;
	pitch_down = 75;
	if(self laststand::player_is_in_laststand())
	{
		self setorigin(self.var_68072c39.origin);
		while(self laststand::player_is_in_laststand())
		{
			wait(0.1);
		}
	}
	else
	{
		self enableinvulnerability();
		self function_dd13ce12(360);
		wait(1);
	}
	self enableinvulnerability();
	self function_dd13ce12(360);
	self thread function_3321eefe();
}

/*
	Name: function_a676846
	Namespace: zm_temple_minecart
	Checksum: 0xE1772631
	Offset: 0x16C0
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_a676846(minecart)
{
	level endon(#"hash_76e3734");
	self setplayercollision(0);
	self linkto(self.var_68072c39, "tag_origin", (0, 0, 0), (0, 0, 0));
	self waittill(#"death");
	self unlink();
}

/*
	Name: function_3321eefe
	Namespace: zm_temple_minecart
	Checksum: 0xC89A9E03
	Offset: 0x1748
	Size: 0xD0
	Parameters: 1
	Flags: Linked
*/
function function_3321eefe(activetime)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"hash_aa83d93d");
	self clientfield::set_to_player("minecart_rumble", 1);
	while(true)
	{
		earthquake(randomfloatrange(0.1, 0.2), randomfloatrange(1, 2), self.origin, 100, self);
		wait(randomfloatrange(0.1, 0.3));
	}
}

/*
	Name: function_dd13ce12
	Namespace: zm_temple_minecart
	Checksum: 0x2F7EFEC1
	Offset: 0x1820
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function function_dd13ce12(var_717a30ce)
{
	if(!self laststand::player_is_in_laststand())
	{
		self setstance("crouch");
		self allowstand(0);
		self allowprone(0);
		self clientfield::set("player_legs_hide", 1);
	}
	self playerlinktodelta(self.var_68072c39, undefined, 1, var_717a30ce, var_717a30ce, 90, 75, 1);
}

/*
	Name: function_d7bc1fd8
	Namespace: zm_temple_minecart
	Checksum: 0x4EA130DE
	Offset: 0x18F8
	Size: 0x1F6
	Parameters: 1
	Flags: Linked
*/
function function_d7bc1fd8(var_f127a043)
{
	self notify(#"hash_76e3734");
	level notify(#"hash_76e3734");
	if(isdefined(self.front))
	{
		self.front notsolid();
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(isdefined(player.var_68072c39))
		{
			player clientfield::set("player_legs_hide", 0);
			player unlink();
			player setvelocity(var_f127a043);
			player.var_68072c39 = undefined;
			player.is_on_minecart = 0;
			inlaststand = player laststand::player_is_in_laststand();
			if(!inlaststand)
			{
				player allowcrouch(1);
				player allowprone(1);
				player allowlean(1);
				player allowstand(1);
				player setstance("stand");
			}
			player allowsprint(1);
		}
	}
}

/*
	Name: function_41ad38d8
	Namespace: zm_temple_minecart
	Checksum: 0x6416859A
	Offset: 0x1AF8
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function function_41ad38d8(zombie, vel)
{
	if(!isdefined(zombie))
	{
		return;
	}
	zombie startragdoll();
	zombie launchragdoll(vel);
	util::wait_network_frame();
	level.zombie_total++;
	if(isdefined(zombie))
	{
		zombie dodamage(zombie.health + 666, zombie.origin);
	}
}

/*
	Name: function_a3fe9db2
	Namespace: zm_temple_minecart
	Checksum: 0x72836A8F
	Offset: 0x1BA8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_a3fe9db2(ent)
{
	if(isdefined(self.var_a1647650))
	{
		return ent istouching(self.var_a1647650);
	}
	return distance2d(ent.origin, self.origin) < 120;
}

/*
	Name: get_ai_touching_volume
	Namespace: zm_temple_minecart
	Checksum: 0x56C4EFEB
	Offset: 0x1C18
	Size: 0xE2
	Parameters: 2
	Flags: Linked
*/
function get_ai_touching_volume(team, volume)
{
	ai_list = getaiarray();
	var_fadec02a = [];
	foreach(ai in ai_list)
	{
		if(ai istouching(volume))
		{
			var_fadec02a[var_fadec02a.size] = ai;
		}
	}
	return var_fadec02a;
}

/*
	Name: function_81a9b489
	Namespace: zm_temple_minecart
	Checksum: 0x7C189904
	Offset: 0x1D08
	Size: 0xFE
	Parameters: 0
	Flags: Linked
*/
function function_81a9b489()
{
	ai_list = get_ai_touching_volume(level.zombie_team, self.var_a1647650);
	for(i = 0; i < ai_list.size; i++)
	{
		wait(randomfloatrange(0.05, 0.1));
		if(!isdefined(ai_list[i]))
		{
			continue;
		}
		if(isdefined(ai_list[i].var_68072c39))
		{
			continue;
		}
		level.zombie_total++;
		ai_list[i] dodamage(ai_list[i].health + 100, ai_list[i].origin);
	}
}

/*
	Name: function_9c70545
	Namespace: zm_temple_minecart
	Checksum: 0x679FEEA7
	Offset: 0x1E10
	Size: 0x1A6
	Parameters: 0
	Flags: Linked
*/
function function_9c70545()
{
	if(!isdefined(level.spikemores) || level.spikemores.size <= 0)
	{
		return;
	}
	var_3a52b05 = [];
	for(i = 0; i < level.spikemores.size; i++)
	{
		if(!isdefined(level.spikemores[i]))
		{
			continue;
		}
		trace = groundtrace(level.spikemores[i].origin, level.spikemores[i].origin + (vectorscale((0, 0, -1), 24)), 0, level.spikemores[i]);
		if(isdefined(trace["entity"]))
		{
			if(self == trace["entity"] || (isdefined(self.floor) && self.floor == trace["entity"]))
			{
				if(!isdefined(var_3a52b05))
				{
					var_3a52b05 = [];
				}
				else if(!isarray(var_3a52b05))
				{
					var_3a52b05 = array(var_3a52b05);
				}
				var_3a52b05[var_3a52b05.size] = level.spikemores[i];
			}
		}
	}
}

/*
	Name: function_539188d5
	Namespace: zm_temple_minecart
	Checksum: 0x99EC1590
	Offset: 0x1FC0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function function_539188d5()
{
}

/*
	Name: function_b6cb1d5a
	Namespace: zm_temple_minecart
	Checksum: 0x89263928
	Offset: 0x1FD0
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_b6cb1d5a(name)
{
	node = getvehiclenode((self.targetname + "_") + name, "targetname");
	if(isdefined(node))
	{
		self attachpath(node);
		self startpath();
	}
}

/*
	Name: function_4c5d405f
	Namespace: zm_temple_minecart
	Checksum: 0xE15A5E5C
	Offset: 0x2060
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_4c5d405f(accel)
{
	self notify(#"hash_4c5d405f");
	if(!isdefined(accel))
	{
		accel = self.accel;
	}
	self resumespeed(accel);
	self thread function_7e02ada5();
}

/*
	Name: function_7e02ada5
	Namespace: zm_temple_minecart
	Checksum: 0x6861B2B5
	Offset: 0x20D0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function function_7e02ada5()
{
	self endon(#"death");
	if(!isdefined(self.var_282f646e))
	{
		self.var_282f646e = 1;
	}
	self waittill(#"hash_709c9be8");
}

/*
	Name: function_f16a275
	Namespace: zm_temple_minecart
	Checksum: 0x97096CD5
	Offset: 0x2110
	Size: 0x72
	Parameters: 2
	Flags: Linked
*/
function function_f16a275(accel = self.accel, decel = self.decel)
{
	self setspeed(0, accel, decel);
	self notify(#"hash_709c9be8");
}

/*
	Name: function_b1da7b23
	Namespace: zm_temple_minecart
	Checksum: 0x762C05CE
	Offset: 0x2190
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function function_b1da7b23()
{
	self setspeed(0, 10000);
	self notify(#"hash_709c9be8");
}

/*
	Name: function_b02072a5
	Namespace: zm_temple_minecart
	Checksum: 0x81428B6E
	Offset: 0x21C8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_b02072a5(var_2f6d87e4)
{
	playsoundatposition("evt_mine_cart_bar", self.origin);
	if(self.var_de36bfb8)
	{
		if(var_2f6d87e4)
		{
			self setvisibletoall();
		}
		else
		{
			self setinvisibletoall();
		}
	}
}

/*
	Name: function_f8358462
	Namespace: zm_temple_minecart
	Checksum: 0xC1280592
	Offset: 0x2240
	Size: 0xAFA
	Parameters: 0
	Flags: Linked
*/
function function_f8358462()
{
	level endon(#"fake_death");
	if(!isdefined(self.zombie_cost))
	{
		self.zombie_cost = 250;
	}
	self.var_e70591 = 10;
	self.var_de36bfb8 = 0;
	self setcursorhint("HINT_NOICON");
	self sethintstring("");
	self usetriggerrequirelookat();
	self.cost = 250;
	minecart_poi = getent("minecart_poi", "targetname");
	minecart_poi zm_utility::create_zombie_point_of_interest(undefined, 30, 0, 0);
	minecart_poi thread zm_utility::create_zombie_point_of_interest_attractor_positions(4, 45);
	if(isdefined(self.target))
	{
		self.minecart = getent(self.target, "targetname");
	}
	else
	{
		self.minecart = getent("minecart", "targetname");
	}
	self.minecart function_807ee0b0();
	self function_b02072a5(0);
	wait_for_flags = 1;
	/#
		wait_for_flags = getdvarint("") == 0;
	#/
	if(wait_for_flags)
	{
		self sethintstring(&"ZOMBIE_NEED_POWER");
		level flag::wait_till("power_on");
		self sethintstring(&"ZM_TEMPLE_DESTINATION_NOT_OPEN");
		level flag::wait_till_any(array("cave_water_to_waterfall", "waterfall_to_tunnel"));
	}
	wait(1);
	level notify(#"hash_25007749");
	while(true)
	{
		self function_b02072a5(1);
		if(isdefined(self.minecart.cage))
		{
			self.minecart.cage solid();
		}
		if(isdefined(self.minecart.var_cd74abf8))
		{
			self.minecart.var_cd74abf8 notsolid();
		}
		if(isdefined(self.minecart.front))
		{
			self.minecart.front solid();
		}
		self sethintstring(&"ZM_TEMPLE_MINECART_COST", self.zombie_cost);
		while(true)
		{
			self waittill(#"trigger", player);
			if(player zm_score::can_player_purchase(self.zombie_cost))
			{
				zm_utility::play_sound_at_pos("purchase", self.origin);
				player zm_score::minus_to_player_score(self.zombie_cost);
				break;
			}
		}
		level flag::set("players_riding_minecart");
		level thread function_43dedd2a();
		self triggerenable(0);
		self sethintstring(&"ZM_TEMPLE_MINECART_UNAVAILABLE");
		if(isdefined(self.minecart.var_c25552a2))
		{
			self.minecart.var_c25552a2 rotateroll(180, 0.3, 0.1, 0.1);
			self.minecart.var_c25552a2 waittill(#"rotatedone");
		}
		var_f60bdab9 = 0.25;
		self.minecart thread function_31bd47e5(var_f60bdab9);
		self.minecart thread function_9c70545();
		self.minecart thread function_e42c263d();
		self.minecart thread function_5b5fcc02();
		self.minecart.away = 1;
		self.minecart function_4c5d405f();
		self.minecart.speaker_left playsound("evt_minecart_l");
		self.minecart.speaker_right playsound("evt_minecart_r");
		self.minecart.speaker_left playloopsound("zmb_singing", 5);
		self thread function_b02072a5(0);
		self.minecart function_46d092ff();
		self.minecart thread function_81a9b489();
		self.minecart thread function_a4db8189(2);
		var_db67a5d6 = 0.5;
		self.minecart thread function_b97fa0a1(var_db67a5d6, 2);
		var_ef4c4f55 = function_b56e3436();
		self.minecart thread function_131c0ce7();
		zm_zonemgr::zone_init("waterfall_lower_zone");
		zm_zonemgr::enable_zone("waterfall_lower_zone");
		if(var_ef4c4f55)
		{
			minecart_poi zm_utility::activate_zombie_point_of_interest();
		}
		wait(1);
		self triggerenable(1);
		self.minecart waittill(#"reached_end_node");
		self.minecart function_a2aafac6();
		self.minecart.speaker_left stoploopsound(1);
		wait(1);
		level flag::clear("players_riding_minecart");
		if(var_ef4c4f55)
		{
			minecart_poi zm_utility::deactivate_zombie_point_of_interest();
		}
		if(!getdvarint("scr_minecart_cheat"))
		{
			var_246ba808 = spawnvehicle("zombie_minecart", self.minecart.origin, self.minecart.angles, self.minecart.targetname + "_reverse");
			var_246ba808.drivepath = 0;
			var_246ba808.var_66b5ee1a = self.minecart.var_88249cb5;
			var_246ba808.var_fdb1feb7 = self.minecart.var_629f3738;
			var_246ba808 function_b1da7b23();
			var_246ba808 function_b6cb1d5a("start");
			var_246ba808 ghost();
			function_59dcb5d1(self.minecart, var_246ba808);
			var_246ba808 playloopsound("evt_minecart_climb_loop");
			self.minecart.away = 0;
			self.minecart function_b6cb1d5a("start");
			var_246ba808 function_4c5d405f(self.minecart.accel);
			var_246ba808 waittill(#"reached_end_node");
			var_246ba808 function_f16a275(self.minecart.accel, self.minecart.decel);
			function_59dcb5d1(var_246ba808, self.minecart);
			var_246ba808 stoploopsound();
			self.minecart playsound("evt_spiketrap_warn");
			var_246ba808 delete();
		}
		else
		{
			self.minecart.away = 0;
			self.minecart function_b6cb1d5a("start");
		}
		if(isdefined(self.minecart.var_c25552a2))
		{
			self.minecart.var_c25552a2 rotateroll(-180, 0.3, 0.1, 0.1);
			self.minecart.var_c25552a2 waittill(#"rotatedone");
		}
	}
}

/*
	Name: function_b56e3436
	Namespace: zm_temple_minecart
	Checksum: 0xB658202E
	Offset: 0x2D48
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_b56e3436()
{
	var_6fbe862f = 1;
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i] laststand::player_is_in_laststand())
		{
			continue;
		}
		if(!(isdefined(players[i].is_on_minecart) && players[i].is_on_minecart))
		{
			var_6fbe862f = 0;
		}
	}
	return var_6fbe862f;
}

/*
	Name: function_59dcb5d1
	Namespace: zm_temple_minecart
	Checksum: 0x398C27EA
	Offset: 0x2E10
	Size: 0x18C
	Parameters: 3
	Flags: Linked
*/
function function_59dcb5d1(var_e48fa956, var_8c9fa61, time)
{
	model = spawn("script_model", var_e48fa956.origin);
	model setmodel(var_e48fa956.model);
	model.angles = var_e48fa956.angles;
	var_e48fa956 ghost();
	model moveto(var_8c9fa61.origin, 1, 0.1, 0.1);
	rotateangles = (0 - var_8c9fa61.angles[0], var_8c9fa61.angles[1] - 180, 0);
	model rotateto(rotateangles, 1, 0.1, 0.1);
	model waittill(#"movedone");
	model delete();
	var_8c9fa61 show();
}

/*
	Name: function_a2aafac6
	Namespace: zm_temple_minecart
	Checksum: 0x90EBB348
	Offset: 0x2FA8
	Size: 0x4BE
	Parameters: 0
	Flags: Linked
*/
function function_a2aafac6()
{
	speed = 500;
	self function_b1da7b23();
	exploder::exploder("fxexp_6");
	if(isdefined(self.var_be938773))
	{
		self.var_be938773 thread function_86d73e41();
	}
	forward = anglestoforward(self.angles);
	forwarddist = 370;
	var_f127a043 = (forward * forwarddist) + vectorscale((0, 0, 1), 110);
	time = forwarddist / speed;
	players = getplayers();
	var_e6eabdfa = [];
	if(isdefined(self.front))
	{
		self.front notsolid();
	}
	for(i = 0; i < self.var_54277932.size; i++)
	{
		self thread function_41ad38d8(self.var_54277932[i], var_f127a043 / 2);
	}
	var_8e3b7101 = [];
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!isdefined(player.var_68072c39))
		{
			continue;
		}
		var_8e3b7101[var_8e3b7101.size] = player;
		var_e6eabdfa[var_e6eabdfa.size] = player;
		player notify(#"hash_aa83d93d");
		player clientfield::set_to_player("minecart_rumble", 0);
		player playrumbleonentity("damage_heavy");
		earthquake(0.5, 2, player.origin, 100, player);
		player.var_e4bd94c = gettime() + 2000;
		player.var_68072c39 unlink();
		if(!isdefined(player getlinkedent()))
		{
			player function_dd13ce12(360);
		}
		player enableinvulnerability();
		player util::delay(2, undefined, &function_5724a279);
		player.var_68072c39 movegravity(var_f127a043, time);
	}
	var_f127a043 = (0, 0, 0);
	wait((time * 0.9) - 0.1);
	if(var_8e3b7101.size > 0)
	{
		old_origin = var_8e3b7101[0].var_68072c39.origin;
		wait(0.1);
		var_f127a043 = (var_8e3b7101[0].var_68072c39.origin - old_origin) * 10;
	}
	else
	{
		wait(0.1);
	}
	self function_d7bc1fd8(var_f127a043);
	wait(0.5);
	for(i = 0; i < self.linkents.size; i++)
	{
		e = self.linkents[i];
		e unlink();
		e.origin = (0, 0, 0);
		e linkto(self, "", e.offsetorigin, (0, 0, 0));
	}
}

/*
	Name: function_5724a279
	Namespace: zm_temple_minecart
	Checksum: 0x537BD127
	Offset: 0x3470
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_5724a279()
{
	if(isdefined(self))
	{
		self disableinvulnerability();
	}
}

/*
	Name: function_b65d8973
	Namespace: zm_temple_minecart
	Checksum: 0x2EABFA1B
	Offset: 0x34A0
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function function_b65d8973(minecart)
{
	minecart waittill(#"reached_end_node");
	self zm_utility::deactivate_zombie_point_of_interest();
}

/*
	Name: function_131c0ce7
	Namespace: zm_temple_minecart
	Checksum: 0x77B49A94
	Offset: 0x34D8
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function function_131c0ce7()
{
	trigger = getent("force_waterfall_active", "script_noteworthy");
	if(isdefined(trigger))
	{
		trigger waittill(#"trigger");
		level.minecart_force_zone_active = 1;
		self waittill(#"reached_end_node");
		level.minecart_force_zone_active = 0;
	}
}

/*
	Name: function_b97fa0a1
	Namespace: zm_temple_minecart
	Checksum: 0x995373E7
	Offset: 0x3550
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function function_b97fa0a1(time, delay)
{
	wait(delay);
	self thread function_c379c791(time);
}

/*
	Name: function_c379c791
	Namespace: zm_temple_minecart
	Checksum: 0x8D87B856
	Offset: 0x3590
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_c379c791(time)
{
	if(isdefined(self.door))
	{
		if(self.door.closed)
		{
			self.door movez(-130, time, 0.1, 0.1);
			self.door.clip movez(-130, time, 0.1, 0.1);
			self.door waittill(#"movedone");
			self.door.closed = 0;
			self.door.clip connectpaths();
		}
	}
}

/*
	Name: function_e42c263d
	Namespace: zm_temple_minecart
	Checksum: 0x77727FB6
	Offset: 0x3678
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_e42c263d()
{
	if(isdefined(self.door))
	{
		if(!self.door.closed)
		{
			self.door movez(130, 0.5, 0.1, 0.1);
			self.door.clip movez(130, 0.1);
			self.door waittill(#"movedone");
			self.door.closed = 1;
			self.door.clip disconnectpaths();
		}
	}
}

/*
	Name: function_31bd47e5
	Namespace: zm_temple_minecart
	Checksum: 0x563143E5
	Offset: 0x3750
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function function_31bd47e5(time)
{
	if(self.var_ab67891f)
	{
		door = undefined;
		for(i = 0; i < self.var_54b40cc8.size; i++)
		{
			door = self.var_54b40cc8[i];
			door rotateyaw(door.script_vector[1], time, 0.1, 0.1);
		}
		if(isdefined(door))
		{
			door waittill(#"rotatedone");
		}
		self.var_ab67891f = 0;
		if(isdefined(self.var_7c850021))
		{
			self.var_7c850021 notsolid();
		}
	}
}

/*
	Name: function_290ed469
	Namespace: zm_temple_minecart
	Checksum: 0xC96A3FCE
	Offset: 0x3848
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_290ed469()
{
	if(!self.var_ab67891f)
	{
		if(isdefined(self.var_7c850021))
		{
			self.var_7c850021 solid();
		}
		door = undefined;
		for(i = 0; i < self.var_54b40cc8.size; i++)
		{
			door = self.var_54b40cc8[i];
			door rotateyaw(-1 * door.script_vector[1], 1, 0.1, 0.1);
		}
		if(isdefined(door))
		{
			door waittill(#"rotatedone");
		}
		self.var_ab67891f = 1;
	}
}

/*
	Name: function_a4db8189
	Namespace: zm_temple_minecart
	Checksum: 0x40FF18C
	Offset: 0x3940
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_a4db8189(delay)
{
	wait(delay);
	self thread function_290ed469();
}

/*
	Name: function_5b5fcc02
	Namespace: zm_temple_minecart
	Checksum: 0x267E3C77
	Offset: 0x3970
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_5b5fcc02()
{
	if(isdefined(self.pusher))
	{
		if(!self.pusher.out)
		{
			wait(0.3);
			self.pusher movey(166, 2, 0.25, 0.1);
			self.pusher waittill(#"movedone");
			self.pusher.out = 1;
			level waittill(#"hash_c6b9857c");
			wait(2.7);
			self thread function_c716b3b7();
		}
	}
}

/*
	Name: function_c716b3b7
	Namespace: zm_temple_minecart
	Checksum: 0x427567AD
	Offset: 0x3A30
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_c716b3b7()
{
	if(isdefined(self.pusher))
	{
		if(self.pusher.out)
		{
			self.pusher movey(-166, 4, 0.25, 0.1);
			self.pusher waittill(#"movedone");
			self.pusher.out = 0;
		}
	}
}

/*
	Name: function_7fec5b68
	Namespace: zm_temple_minecart
	Checksum: 0x19241B5B
	Offset: 0x3AB0
	Size: 0x428
	Parameters: 0
	Flags: Linked
*/
function function_7fec5b68()
{
	height = 0;
	scale = getent("minecart1_scale", "targetname");
	if(!isdefined(scale))
	{
		return;
	}
	scale.origin = scale.origin + (vectorscale((0, 0, -1), 37));
	level waittill(#"hash_25007749");
	while(true)
	{
		count = 0;
		if(isdefined(self.minecart) && !self.minecart.away)
		{
			players = getplayers();
			for(i = 0; i < players.size; i++)
			{
				if(players[i] istouching(self))
				{
					count++;
				}
			}
		}
		if(height < count)
		{
			while(height < count)
			{
				rise = 0;
				if(height == 3)
				{
					rise = 10;
				}
				else
				{
					if(height == 0)
					{
						rise = 11;
					}
					else
					{
						rise = 8;
					}
				}
				height++;
				if(height == count)
				{
					rise = rise + 1;
				}
				scale movez(rise, 0.35, 0.05, 0);
				scale waittill(#"movedone");
			}
			scale movez(-2, 0.2, 0, 0);
			scale waittill(#"movedone");
			scale movez(1, 0.1, 0, 0);
			scale waittill(#"movedone");
		}
		else if(height > count)
		{
			drop = 0;
			time = 0;
			pop = 2;
			dip = -1;
			while(height > count)
			{
				if(height == 4)
				{
					drop = drop + -10;
				}
				else
				{
					if(height == 1)
					{
						drop = drop + -11;
					}
					else
					{
						drop = drop + -8;
					}
				}
				time = time + 0.2;
				height--;
			}
			if(height == 0)
			{
				pop = 1;
			}
			else
			{
				drop = drop + -1;
			}
			scale movez(drop, time, 0.1, 0);
			scale waittill(#"movedone");
			scale movez(pop, pop * 0.1, 0, 0);
			scale waittill(#"movedone");
			scale movez(dip, abs(dip * 0.1), 0, 0);
			scale waittill(#"movedone");
		}
		wait(0.1);
	}
}

/*
	Name: function_86d73e41
	Namespace: zm_temple_minecart
	Checksum: 0xA95569BB
	Offset: 0x3EE0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_86d73e41()
{
	self triggerenable(1);
	wait(3);
	self triggerenable(0);
}

/*
	Name: function_68c61932
	Namespace: zm_temple_minecart
	Checksum: 0xB4AE8342
	Offset: 0x3F28
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_68c61932()
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(isdefined(player) && isdefined(player.var_e4bd94c) && player.var_e4bd94c > gettime())
		{
			playfx(level._effect["player_water_splash"], player.origin);
			player playsound("fly_bodyfall_large_water");
			player.var_e4bd94c = 0;
		}
	}
}

/*
	Name: function_82d1ad64
	Namespace: zm_temple_minecart
	Checksum: 0x454099B9
	Offset: 0x3FF0
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function function_82d1ad64(array)
{
	if(array.size == 0)
	{
		return;
	}
	wait(6);
	player = array[randomintrange(0, array.size)];
	if(isdefined(player) && isplayer(player))
	{
		player thread zm_audio::create_and_play_dialog("general", "mine_ride");
	}
}

/*
	Name: function_43dedd2a
	Namespace: zm_temple_minecart
	Checksum: 0x27915BF8
	Offset: 0x4090
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function function_43dedd2a()
{
	corpse_trig = getent("minecart1_start_volume", "targetname");
	corpses = getcorpsearray();
	if(isdefined(corpses))
	{
		for(i = 0; i < corpses.size; i++)
		{
			if(corpses[i] istouching(corpse_trig))
			{
				corpses[i] thread function_edc2ec93();
			}
		}
	}
}

/*
	Name: function_edc2ec93
	Namespace: zm_temple_minecart
	Checksum: 0x6AAA0453
	Offset: 0x4160
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_edc2ec93()
{
	playfx(level._effect["corpse_gib"], self.origin);
	self delete();
}

