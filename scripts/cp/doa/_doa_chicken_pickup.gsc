// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_sfx;
#using scripts\cp\doa\_doa_utility;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#using_animtree("critter");

#namespace namespace_5e6c5d1f;

/*
	Name: function_cdfa9ce8
	Namespace: namespace_5e6c5d1f
	Checksum: 0x7F90AFB1
	Offset: 0x588
	Size: 0x31E
	Parameters: 1
	Flags: Linked
*/
function function_cdfa9ce8(bird)
{
	bird notify(#"hash_cf62504");
	bird endon(#"hash_cf62504");
	bird endon(#"death");
	bird useanimtree($critter);
	curanim = %critter::a_chicken_react_up_down;
	lastanim = %critter::a_chicken_idle_peck;
	bird thread namespace_1a381543::function_90118d8c("zmb_dblshot_squawk");
	while(isdefined(bird))
	{
		if(randomint(100) > 15)
		{
			bird thread namespace_1a381543::function_90118d8c("zmb_dblshot_squawk");
		}
		if(isdefined(self.var_3424aae1) && self.var_3424aae1)
		{
			curanim = %critter::a_chicken_react_up_down;
			bird thread namespace_1a381543::function_90118d8c("zmb_dblshot_squawk");
		}
		else if(isdefined(self.var_a732885d) && self.var_a732885d)
		{
			curanim = %critter::a_chicken_react_up_down;
			bird thread namespace_1a381543::function_90118d8c("zmb_dblshot_squawk");
		}
		else if(isdefined(self.var_7d36ff94) && self.var_7d36ff94)
		{
			curanim = %critter::a_chicken_react_up_down;
			self.var_7d36ff94 = undefined;
			bird thread namespace_1a381543::function_90118d8c("zmb_dblshot_squawk");
		}
		else if(isdefined(self.var_efa2b784) && self.var_efa2b784)
		{
			curanim = %critter::a_chicken_react_to_front_notrans;
		}
		else if(isdefined(self.is_moving) && self.is_moving)
		{
			curanim = %critter::a_chicken_run;
		}
		bird animscripted("chicken_anim", bird.origin, bird.angles, curanim);
		animlength = getanimlength(curanim);
		wait(animlength);
		lastanim = curanim;
		switch(randomint(3))
		{
			case 0:
			{
				curanim = %critter::a_chicken_idle_peck;
				break;
			}
			case 1:
			{
				curanim = %critter::a_chicken_idle_a;
				break;
			}
			case 2:
			{
				curanim = %critter::a_chicken_idle;
				break;
			}
		}
	}
}

/*
	Name: add_a_chicken
	Namespace: namespace_5e6c5d1f
	Checksum: 0xB1F54B69
	Offset: 0x8B0
	Size: 0x5D4
	Parameters: 4
	Flags: Linked
*/
function add_a_chicken(model, scale, fated, var_5c667593)
{
	if(!isdefined(self.doa))
	{
		return;
	}
	if(!mayspawnentity())
	{
		return;
	}
	orb = spawn("script_model", self.origin + (0, 0, getdvarint("scr_doa_chickenZ", 50)));
	orb.targetname = "add_a_chicken";
	orb setmodel("tag_origin");
	orb enablelinkto();
	orb notsolid();
	bird = spawn("script_model", orb.origin);
	bird.targetname = "chicken";
	bird setmodel(model);
	bird linkto(orb, "tag_origin");
	bird notsolid();
	orb.var_6e0abf98 = scale;
	bird setscale(scale);
	orb.bird = bird;
	bird.orb = orb;
	orb.player = self;
	orb.owner = self;
	orb.team = self.team;
	orb.special = fated;
	orb.var_cdf31c46 = 0;
	orb.var_fe6ede28 = 0;
	orb.var_947e1f34 = (self.doa.var_3cdd8203.size == 0 ? self : self.doa.var_3cdd8203[self.doa.var_3cdd8203.size - 1]);
	orb enablelinkto();
	orb thread function_cdfa9ce8(bird);
	if(isdefined(orb.special) && orb.special && self.doa.var_3cdd8203.size > 0)
	{
		arrayinsert(self.doa.var_3cdd8203, orb, 0);
		var_bd097d49 = self;
		foreach(var_9d8c8c73, chicken in self.doa.var_3cdd8203)
		{
			chicken.var_947e1f34 = var_bd097d49;
			var_bd097d49 = chicken;
		}
	}
	else
	{
		self.doa.var_3cdd8203[self.doa.var_3cdd8203.size] = orb;
	}
	if(self.doa.var_3cdd8203.size > getdvarint("scr_doa_max_chickens", 5))
	{
		foreach(var_fc5be8d7, chicken in self.doa.var_3cdd8203)
		{
			if(!(isdefined(chicken.special) && chicken.special))
			{
				chicken notify(#"spin_out");
				break;
			}
		}
	}
	orb thread function_d7142cd(self);
	orb thread function_3118ca4d(self);
	orb thread function_8b81d592(self);
	orb thread function_8fb467a7(self);
	orb thread function_4ef3ec52();
	orb thread function_da8e9c9b();
	orb thread function_44ff9baa(self);
	orb thread function_e636d9c5(self);
	if(isdefined(var_5c667593) && var_5c667593)
	{
		orb thread function_cff32183(self);
	}
}

/*
	Name: function_8397461e
	Namespace: namespace_5e6c5d1f
	Checksum: 0xAB98E37B
	Offset: 0xE90
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function function_8397461e()
{
	if(!isdefined(self.doa.var_3cdd8203))
	{
		return;
	}
	foreach(var_40ce22db, bird in self.doa.var_3cdd8203)
	{
		if(isdefined(bird.special) && bird.special)
		{
			continue;
		}
		bird notify(#"spin_out", 1);
	}
}

/*
	Name: function_d7142cd
	Namespace: namespace_5e6c5d1f
	Checksum: 0x23D9ACD0
	Offset: 0xF68
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function function_d7142cd(player)
{
	self endon(#"death");
	player waittill(#"disconnect");
	if(isdefined(self.special) && self.special)
	{
		if(isdefined(self.bird))
		{
			self.bird delete();
		}
		self delete();
	}
	else
	{
		self notify(#"spin_out");
	}
}

/*
	Name: function_3118ca4d
	Namespace: namespace_5e6c5d1f
	Checksum: 0xCF7FCB2B
	Offset: 0x1000
	Size: 0x30C
	Parameters: 1
	Flags: Linked
*/
function function_3118ca4d(player)
{
	if(isdefined(self.special) && self.special)
	{
		return;
	}
	self notify(#"hash_3118ca4d");
	self endon(#"hash_3118ca4d");
	self endon(#"death");
	self waittill(#"spin_out", immediate);
	waittillframeend();
	self notify(#"spinning_out");
	arrayremovevalue(player.doa.var_3cdd8203, self);
	if(!(isdefined(immediate) && immediate))
	{
		self.var_3424aae1 = 1;
		var_46d4563e = player;
		foreach(var_5b1d0dfd, chicken in player.doa.var_3cdd8203)
		{
			chicken.var_947e1f34 = var_46d4563e;
			var_46d4563e = chicken;
		}
		weapon = function_4d01b327(player);
		self.spinouttime = randomfloatrange(5, 8);
		firetime = 0.15;
		while(self.spinouttime > 0)
		{
			rotate180time = 1;
			self rotateto(self.angles + vectorscale((0, 1, 0), 180), rotate180time);
			localrotatetime = rotate180time;
			while(localrotatetime > 0)
			{
				self function_cea0c915(player, weapon);
				wait(firetime);
				localrotatetime = localrotatetime - firetime;
			}
			self.spinouttime = self.spinouttime - rotate180time;
		}
	}
	self thread namespace_1a381543::function_90118d8c("zmb_dblshot_end");
	self.bird thread namespace_eaa992c::function_285a2999("chicken_explode");
	util::wait_network_frame();
	if(isdefined(self.bird))
	{
		self.bird delete();
	}
	self delete();
}

/*
	Name: function_4dd46e10
	Namespace: namespace_5e6c5d1f
	Checksum: 0x4CE03344
	Offset: 0x1318
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function function_4dd46e10(follow_points, num_follow_points)
{
	for(i = 0; i < num_follow_points; i++)
	{
		follow_points[i] = self.origin;
	}
}

/*
	Name: function_e636d9c5
	Namespace: namespace_5e6c5d1f
	Checksum: 0x318C58CA
	Offset: 0x1370
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_e636d9c5(player)
{
	self endon(#"death");
	player endon(#"disconnect");
	while(true)
	{
		level waittill(#"hash_31680c6");
		if(!isdefined(player))
		{
			return;
		}
		if(isdefined(self.var_3424aae1) && self.var_3424aae1)
		{
			self.spinouttime = 0;
		}
		self.var_6fdb49e0 = 1;
		var_7bb420a0 = self function_bd97e9ba(player) + 1;
		forward = anglestoforward(player.angles);
		offset = forward * (24 * var_7bb420a0, 0, 0);
		self.origin = player.origin - offset;
	}
}

/*
	Name: function_44ff9baa
	Namespace: namespace_5e6c5d1f
	Checksum: 0x13AF23A5
	Offset: 0x1488
	Size: 0x398
	Parameters: 1
	Flags: Linked
*/
function function_44ff9baa(player)
{
	self endon(#"death");
	self endon(#"spinning_out");
	follow_index = 0;
	next_index = follow_index + 1;
	num_follow_points = getdvarint("scr_doa_max_chicken_points", 5);
	follow_points = [];
	self.var_6fdb49e0 = 1;
	while(true)
	{
		util::wait_network_frame();
		if(isdefined(self.var_efa2b784) && self.var_efa2b784)
		{
			self.var_6fdb49e0 = 1;
			continue;
		}
		if(isdefined(self.var_a732885d) && self.var_a732885d)
		{
			self.var_6fdb49e0 = 1;
			continue;
		}
		if(self.var_6fdb49e0)
		{
			self.var_6fdb49e0 = 0;
			function_4dd46e10(follow_points, num_follow_points);
		}
		if(isdefined(self.var_947e1f34))
		{
			if(isplayer(self.var_947e1f34))
			{
				angles = self.var_947e1f34 getplayerangles();
			}
			else
			{
				angles = self.var_947e1f34.angles;
			}
			self.angles = (angles[0], angles[1], 0);
			self.bird.angles = self.angles;
			self.bird.origin = self.origin;
			self.is_moving = 0;
			if(distance2dsquared(self.var_947e1f34.origin, follow_points[follow_index]) > getdvarint("scr_doa_follow_point_spacing", 4 * 4))
			{
				follow_pt = self.var_947e1f34.origin;
				if(isplayer(self.var_947e1f34))
				{
					if(isdefined(self.var_947e1f34.doa.var_65f7f2a9) && self.var_947e1f34.doa.var_65f7f2a9 || isdefined(self.var_5c667593))
					{
						z = getdvarint("scr_doa_chickenZ", 20);
					}
					else
					{
						z = getdvarint("scr_doa_chickenZ", 50);
					}
					follow_pt = follow_pt + (0, 0, z);
				}
				follow_points[next_index] = follow_pt;
				follow_index = next_index;
				next_index++;
				next_index = next_index % num_follow_points;
				self.is_moving = 1;
				self moveto(follow_points[next_index], getdvarfloat("scr_doa_chicken_speed", 0.15), 0, 0);
			}
		}
	}
}

/*
	Name: function_8b81d592
	Namespace: namespace_5e6c5d1f
	Checksum: 0x44F069A7
	Offset: 0x1828
	Size: 0x17E
	Parameters: 1
	Flags: Linked
*/
function function_8b81d592(player)
{
	self endon(#"spinning_out");
	self endon(#"death");
	time = level.doa.rules.var_da7e08a6 * 1000;
	if(player.doa.fate == 3 || player.doa.fate == 12)
	{
		time = time * level.doa.rules.var_ef3d9a29;
	}
	level doa_utility::function_c8f4d63a();
	timeout = gettime() + time;
	while(gettime() < timeout)
	{
		if(!isdefined(player))
		{
			self notify(#"spin_out");
		}
		if(level flag::get("doa_game_is_over"))
		{
			self notify(#"spin_out");
		}
		wait(0.05);
	}
	while(isdefined(self.var_a732885d) && self.var_a732885d || (isdefined(self.var_efa2b784) && self.var_efa2b784))
	{
		wait(1);
	}
	self notify(#"spin_out");
}

/*
	Name: function_4d01b327
	Namespace: namespace_5e6c5d1f
	Checksum: 0xF41141B5
	Offset: 0x19B0
	Size: 0x202
	Parameters: 1
	Flags: Linked
*/
function function_4d01b327(player)
{
	weapon = level.doa.var_362a104d;
	if(isdefined(self.special) && self.special)
	{
		weapon = level.doa.var_4a3223bd;
	}
	switch(self.var_cdf31c46)
	{
		case 0:
		{
			if(isdefined(player) && isdefined(player.doa.var_d898dd8e))
			{
				weapon = player.doa.var_d898dd8e;
			}
			if(isdefined(player.doa.vehicle))
			{
				if(isdefined(player.doa.vehicle.var_aaffbea7) && player.doa.vehicle.var_aaffbea7)
				{
					weapon = level.doa.var_c1b50f26;
				}
				else
				{
					weapon = level.doa.var_e6a7c945;
				}
			}
			break;
		}
		case 1:
		{
			weapon = level.doa.var_b6808b5a;
			break;
		}
		case 2:
		case 3:
		{
			weapon = level.doa.var_e00fcc77;
			break;
		}
		case 4:
		case 5:
		{
			weapon = level.doa.var_a9c9b20;
			break;
		}
		case 6:
		case 7:
		{
			weapon = level.doa.var_ccb54987;
			break;
		}
		case 8:
		{
			weapon = level.doa.var_69899304;
			break;
		}
	}
	return weapon;
}

/*
	Name: function_be58e20c
	Namespace: namespace_5e6c5d1f
	Checksum: 0xCFDED672
	Offset: 0x1BC0
	Size: 0xFE
	Parameters: 1
	Flags: Linked
*/
function function_be58e20c(player)
{
	while(isdefined(self) && (!(isdefined(self.var_3424aae1) && self.var_3424aae1)))
	{
		if(isdefined(player.doa.vehicle))
		{
			msg = player.doa.vehicle util::waittill_any_timeout(0.1, "weapon_fired", "gunner_weapon_fired");
		}
		else
		{
			msg = player util::waittill_any_timeout(0.1, "weapon_fired", "gunner_weapon_fired", "disconnect");
		}
		if(isdefined(msg) && msg != "timeout")
		{
			self notify(#"hash_4148f7d1");
		}
	}
}

/*
	Name: function_8fb467a7
	Namespace: namespace_5e6c5d1f
	Checksum: 0x20935FBE
	Offset: 0x1CC8
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function function_8fb467a7(player)
{
	self endon(#"death");
	self endon(#"spinning_out");
	self thread function_be58e20c(player);
	while(true)
	{
		self waittill(#"hash_4148f7d1");
		if(isdefined(self.var_18845184) && self.var_18845184)
		{
			continue;
		}
		weapon = self function_4d01b327(player);
		self function_cea0c915(player, weapon);
		extrawait = weapon.firetime - 0.05;
		if(extrawait > 0)
		{
			wait(extrawait);
		}
	}
}

/*
	Name: function_cea0c915
	Namespace: namespace_5e6c5d1f
	Checksum: 0xF4D0D72F
	Offset: 0x1DB8
	Size: 0x184
	Parameters: 2
	Flags: Linked, Private
*/
private function function_cea0c915(player, weapon)
{
	if(isdefined(player))
	{
		forward = anglestoforward(self.angles + (player.doa.var_7a1de0da, 0, 0));
	}
	else
	{
		forward = anglestoforward(self.angles);
	}
	offset = forward * 12 + vectorscale((0, 0, 1), 6);
	start = self.bird.origin + offset;
	if(getdvarint("scr_doa_debug_chicken_fire", 0))
	{
		level thread namespace_2f63e553::function_a0e51d80(start, 5, 20, (1, 0, 0));
		level thread namespace_2f63e553::debugline(start, self.origin + forward * 1000, 5, (1, 0, 0));
	}
	magicbullet(weapon, start, start + forward * 1000, (isdefined(player) ? player : self.bird));
}

/*
	Name: function_da8e9c9b
	Namespace: namespace_5e6c5d1f
	Checksum: 0x7FE37564
	Offset: 0x1F48
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function function_da8e9c9b()
{
	self endon(#"spinning_out");
	self endon(#"death");
	while(isdefined(self))
	{
		rand = randomintrange(0, 100);
		if(rand > 30)
		{
			self thread namespace_1a381543::function_90118d8c("zmb_dblshot_wingflap");
		}
		if(rand > 70)
		{
			self thread namespace_1a381543::function_90118d8c("zmb_dblshot_squawk");
		}
		wait(randomfloatrange(1, 3));
	}
}

/*
	Name: function_4ef3ec52
	Namespace: namespace_5e6c5d1f
	Checksum: 0x6CEE218C
	Offset: 0x2008
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_4ef3ec52()
{
	self endon(#"death");
	self waittill(#"spinning_out");
	while(isdefined(self))
	{
		self thread namespace_1a381543::function_90118d8c("zmb_dblshot_wingflap");
		self thread namespace_1a381543::function_90118d8c("zmb_dblshot_death");
		wait(randomfloatrange(0.5, 1));
	}
}

/*
	Name: function_9d2031fa
	Namespace: namespace_5e6c5d1f
	Checksum: 0xBDCCF3A
	Offset: 0x2098
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function function_9d2031fa()
{
	self notify(#"hash_599dc0d7");
	self endon(#"hash_599dc0d7");
	msg = self util::waittill_any_return("death", "disconnect", "chicken_disconnect_watch");
	foreach(var_9358f23, chicken in self.doa.var_3cdd8203)
	{
		if(msg == "disconnect" || (!(isdefined(chicken.special) && chicken.special)))
		{
			chicken notify(#"spin_out");
		}
	}
}

/*
	Name: function_d35a405a
	Namespace: namespace_5e6c5d1f
	Checksum: 0xBE85E597
	Offset: 0x21C0
	Size: 0x104
	Parameters: 3
	Flags: Linked
*/
function function_d35a405a(model, fated = 0, var_c29d1327 = 1)
{
	if(!isdefined(self.doa.var_3cdd8203))
	{
		self.doa.var_3cdd8203 = [];
	}
	self thread function_9d2031fa();
	def = doa_pickups::function_bac08508(5);
	if(!isdefined(model))
	{
		model = level.doa.var_8d63e734;
	}
	self add_a_chicken(model, def.scale * var_c29d1327, fated != 0, fated == 2);
}

/*
	Name: function_83df0c19
	Namespace: namespace_5e6c5d1f
	Checksum: 0x5BB47626
	Offset: 0x22D0
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function function_83df0c19()
{
	number = 0;
	foreach(var_8e751135, chicken in self.doa.var_3cdd8203)
	{
		if(!(isdefined(chicken.special) && chicken.special))
		{
			number++;
		}
	}
	return number;
}

/*
	Name: function_bd97e9ba
	Namespace: namespace_5e6c5d1f
	Checksum: 0xF24F50F8
	Offset: 0x2398
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function function_bd97e9ba(player)
{
	number = 0;
	foreach(var_93c4e2f0, chicken in player.doa.var_3cdd8203)
	{
		if(chicken == self)
		{
			break;
		}
		number++;
	}
	return number;
}

/*
	Name: function_c397fab3
	Namespace: namespace_5e6c5d1f
	Checksum: 0x8EF2AAC6
	Offset: 0x2458
	Size: 0x1B2
	Parameters: 1
	Flags: Linked
*/
function function_c397fab3(player)
{
	self endon(#"death");
	self endon(#"spinning_out");
	while(true)
	{
		player waittill(#"player_died");
		/#
			doa_utility::debugmsg("");
		#/
		var_141b6128 = self.var_fe6ede28 * 0.98;
		self.var_1f6fdc8f = 1;
		while(self.var_fe6ede28 > var_141b6128)
		{
			self.var_fe6ede28 = self.var_fe6ede28 - 0.05;
			self.bird setscale(self.var_6e0abf98 + self.var_fe6ede28);
			/#
				doa_utility::debugmsg("" + self getentitynumber() + "" + self.var_fe6ede28);
			#/
			wait(0.05);
		}
		/#
			doa_utility::debugmsg("" + self getentitynumber() + "" + self.var_fe6ede28);
		#/
		self.var_fe6ede28 = math::clamp(var_141b6128, 0, getdvarfloat("scr_doa_chicken_max_plump", 3));
		self.var_1f6fdc8f = undefined;
	}
}

/*
	Name: function_cff32183
	Namespace: namespace_5e6c5d1f
	Checksum: 0x8469E485
	Offset: 0x2618
	Size: 0x3A0
	Parameters: 1
	Flags: Linked
*/
function function_cff32183(player)
{
	self endon(#"death");
	self endon(#"spinning_out");
	self.var_fe6ede28 = 0;
	self.var_5c667593 = 1;
	self thread function_c397fab3(player);
	while(true)
	{
		wait(getdvarfloat("scr_doa_chicken_inc_interval", 15));
		if(level flag::get("doa_round_active"))
		{
			numchickens = player function_83df0c19() + 1;
			increment = getdvarfloat("scr_doa_chicken_inc_plump", 0.035) * numchickens;
			if(!(isdefined(self.var_1f6fdc8f) && self.var_1f6fdc8f))
			{
				self.var_fe6ede28 = math::clamp(self.var_fe6ede28 + increment, 0, getdvarfloat("scr_doa_chicken_max_plump", 3));
				/#
					doa_utility::debugmsg("" + self getentitynumber() + "" + self.var_fe6ede28);
				#/
			}
			self.bird setscale(self.var_6e0abf98 + self.var_fe6ede28);
			var_cdf31c46 = 0;
			frac = self.var_fe6ede28 / getdvarfloat("scr_doa_chicken_max_plump", 3);
			if(frac > 0.03)
			{
				var_cdf31c46 = 1;
			}
			if(frac > 0.12)
			{
				var_cdf31c46 = 2;
			}
			if(frac > 0.3)
			{
				var_cdf31c46 = 3;
			}
			if(frac > 0.5)
			{
				var_cdf31c46 = 4;
			}
			if(frac > 0.7)
			{
				var_cdf31c46 = 5;
			}
			if(frac > 0.82)
			{
				var_cdf31c46 = 6;
			}
			if(frac > 0.94)
			{
				var_cdf31c46 = 7;
			}
			if(self.var_cdf31c46 != var_cdf31c46)
			{
				self thread namespace_1a381543::function_90118d8c("zmb_golden_chicken_grow");
				self.var_7d36ff94 = 1;
				self.var_cdf31c46 = var_cdf31c46;
			}
			if(self.var_fe6ede28 == getdvarfloat("scr_doa_chicken_max_plump", 3))
			{
				wait(getdvarfloat("scr_doa_chicken_waitfull_plump", 30));
				self function_2d0f96ef(player);
				self.var_fe6ede28 = 0;
				self.var_cdf31c46 = 0;
				self.bird setscale(self.var_6e0abf98 + self.var_fe6ede28);
			}
		}
	}
}

/*
	Name: function_2d0f96ef
	Namespace: namespace_5e6c5d1f
	Checksum: 0x727AD8B2
	Offset: 0x29C0
	Size: 0x4B2
	Parameters: 1
	Flags: Linked
*/
function function_2d0f96ef(player)
{
	self endon(#"death");
	self endon(#"spinning_out");
	/#
		doa_utility::debugmsg("" + self getentitynumber());
	#/
	self.var_a732885d = 1;
	self.var_18845184 = 1;
	var_ff37339 = 32;
	pos = 0;
	i = 0;
	var_fb842d4e = gettime() + getdvarfloat("scr_doa_chicken_egg_lay_duration", 12) * 1000;
	self thread namespace_1a381543::function_90118d8c("zmb_golden_chicken_dance");
	while(gettime() < var_fb842d4e)
	{
		foreach(var_6142a614, chicken in player.doa.var_3cdd8203)
		{
			if(isdefined(chicken.var_a732885d) && chicken.var_a732885d)
			{
				continue;
			}
			if(isdefined(chicken.var_efa2b784) && chicken.var_efa2b784)
			{
				continue;
			}
			i++;
			offset = 48 + var_ff37339 * floor(i / 4);
			chicken thread function_5af02c44(self, i, offset);
		}
		self rotateto(self.angles + vectorscale((0, 1, 0), 180), 1);
		wait(1);
	}
	self thread namespace_1a381543::function_90118d8c("zmb_golden_chicken_pop");
	chance = 100;
	scale = 1;
	var_19a5d5 = 2 + randomint(5);
	roll = randomint(100);
	while(var_19a5d5)
	{
		if(roll <= chance)
		{
			level doa_pickups::function_3238133b(level.doa.var_468af4f0, self.origin);
		}
		else
		{
			level doa_pickups::function_3238133b(level.doa.var_43922ff2, self.origin);
		}
		var_19a5d5--;
		scale = scale * 0.72;
		chance = int(chance * scale + 0.9);
	}
	while(self.var_fe6ede28 > 0)
	{
		self.var_fe6ede28 = self.var_fe6ede28 - 0.05;
		self.bird setscale(self.var_6e0abf98 + self.var_fe6ede28);
		wait(0.05);
	}
	foreach(var_c5cf7f78, chicken in player.doa.var_3cdd8203)
	{
		chicken.var_a732885d = undefined;
		chicken.var_efa2b784 = undefined;
		chicken.var_18845184 = undefined;
		chicken notify(#"hash_e6885d7c");
	}
}

/*
	Name: function_5af02c44
	Namespace: namespace_5e6c5d1f
	Checksum: 0x8B2E20BF
	Offset: 0x2E80
	Size: 0x254
	Parameters: 3
	Flags: Linked, Private
*/
private function function_5af02c44(target, num, offset)
{
	self endon(#"death");
	self endon(#"spinning_out");
	self.var_efa2b784 = 1;
	self.var_18845184 = 1;
	anim_ang = vectortoangles(target.origin - self.origin);
	self rotateto((0, anim_ang[1], 0), 0.5);
	pos = num % 4;
	switch(pos)
	{
		case 0:
		{
			spot = (offset, 0, getdvarint("scr_doa_chickenZ", 50));
			break;
		}
		case 1:
		{
			spot = (0, offset, getdvarint("scr_doa_chickenZ", 50));
			break;
		}
		case 2:
		{
			spot = (offset * -1, 0, getdvarint("scr_doa_chickenZ", 50));
			break;
		}
		case 3:
		{
			spot = (0, offset * -1, getdvarint("scr_doa_chickenZ", 50));
			break;
		}
	}
	self moveto(target.origin, 1);
	self util::waittill_any_timeout(2, "movedone");
	self linkto(target, "tag_origin", spot);
	self waittill(#"hash_e6885d7c");
	self unlink();
}

/*
	Name: function_e4f21fa9
	Namespace: namespace_5e6c5d1f
	Checksum: 0xE027BD9C
	Offset: 0x30E0
	Size: 0xEC
	Parameters: 0
	Flags: Linked, Private
*/
private function function_e4f21fa9()
{
	roll = randomint(100);
	prize = "none";
	if(roll < 2)
	{
		prize = level.doa.extra_life_model;
	}
	else if(roll < 6)
	{
		prize = level.doa.var_501f85b4;
	}
	else if(roll < 16)
	{
		prize = level.doa.booster_model;
	}
	else if(roll <= 40)
	{
		prize = level.doa.var_8d63e734;
	}
	else
	{
		prize = "zombietron_diamond";
	}
	return prize;
}

/*
	Name: function_d63bdb9
	Namespace: namespace_5e6c5d1f
	Checksum: 0xFAA79F58
	Offset: 0x31D8
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_d63bdb9(hop)
{
	if(hop)
	{
		self physicslaunch(self.origin, (randomintrange(-10, 10), randomintrange(-10, 10), 30));
		self thread namespace_1a381543::function_90118d8c("zmb_egg_shake");
	}
}

/*
	Name: function_4c41e6af
	Namespace: namespace_5e6c5d1f
	Checksum: 0xCE2AFB5A
	Offset: 0x3268
	Size: 0x278
	Parameters: 0
	Flags: Linked
*/
function function_4c41e6af()
{
	self endon(#"death");
	while(true)
	{
		var_9c9d6a5c = doa_utility::getarrayitemswithin(self.origin, getaiteamarray("axis"), 2304);
		for(i = 0; i < var_9c9d6a5c.size; i++)
		{
			zombie = var_9c9d6a5c[i];
			if(isdefined(zombie.var_2d8174e3) && zombie.var_2d8174e3)
			{
				continue;
			}
			zombie setentitytarget(self);
			dir = vectornormalize(self.origin - zombie.origin) * 30;
			self physicslaunch(self.origin, (dir[0], dir[1], dir[2] + 10));
			self.health = self.health - 40;
			if(self.health < 0)
			{
				self thread namespace_1a381543::function_90118d8c("zmb_explode");
				self thread namespace_eaa992c::function_285a2999("egg_explode");
				physicsexplosionsphere(self.origin, 200, 128, 2);
				self radiusdamage(self.origin, 72, 2000, 1000);
				playrumbleonposition("explosion_generic", self.origin);
				self waittill(#"hash_6a404ade");
				self delete();
			}
		}
		wait(1);
		self.var_111c7bbb = getclosestpointonnavmesh(self.origin, 64, 16);
	}
}

/*
	Name: function_7b8c015c
	Namespace: namespace_5e6c5d1f
	Checksum: 0x6D2FAA82
	Offset: 0x34E8
	Size: 0x274
	Parameters: 0
	Flags: Linked
*/
function function_7b8c015c()
{
	self endon(#"death");
	if(self.def.type == 36)
	{
		self.prize = level.doa.extra_life_model;
	}
	self physicslaunch(self.origin, vectorscale((0, 0, 1), 10));
	self.health = 1500 + level.doa.var_da96f13c * 500;
	if(self.def.type == 36)
	{
		self.health = self.health + 3000;
	}
	self thread function_4c41e6af();
	self.team = "allies";
	wait(1);
	self makesentient();
	self.threatbias = 0;
	doa_utility::function_5fd5c3ea(self);
	self.var_b2290d2d = 1;
	self waittill(#"pickup_timeout");
	wait(1);
	self thread namespace_1a381543::function_90118d8c("zmb_egg_hatch");
	self thread namespace_eaa992c::function_285a2999("egg_hatch");
	if(isdefined(self.prize))
	{
		prize = self.prize;
	}
	else
	{
		prize = function_e4f21fa9();
	}
	origin = doa_utility::function_1c0abd70(self.origin, 10, self);
	if(prize != "zombietron_diamond")
	{
		level doa_pickups::function_3238133b(prize, origin + vectorscale((0, 0, 1), 12));
	}
	else
	{
		level thread doa_pickups::spawnubertreasure(origin, 1 + randomintrange(2, 6), 0, 1);
	}
	self waittill(#"hash_6a404ade");
	self delete();
}

