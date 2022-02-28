// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;

#namespace zm_weap_shrink_ray;

/*
	Name: __init__sytem__
	Namespace: zm_weap_shrink_ray
	Checksum: 0x12975D65
	Offset: 0x478
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_shrink_ray", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_shrink_ray
	Checksum: 0x3FC39EBE
	Offset: 0x4C0
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("actor", "fun_size", 5000, 1, "int");
	level.shrink_models = [];
	zombie_utility::set_zombie_var("shrink_ray_fling_range", 480);
	level._effect["shrink_ray_stepped_on"] = "dlc5/temple/fx_ztem_zombie_mini_squish";
	level._effect["shrink_ray_stepped_on_in_water"] = "dlc5/temple/fx_ztem_zombie_mini_drown";
	level._effect["shrink_ray_stepped_on_no_gore"] = "dlc5/temple/fx_ztem_monkey_shrink";
	level._effect["shrink"] = "dlc5/zmb_weapon/fx_shrink_ray_zombie_shrink";
	level._effect["unshrink"] = "dlc5/zmb_weapon/fx_shrink_ray_zombie_unshrink";
	callback::on_spawned(&function_37ce705e);
	level.var_c50bd012 = [];
	level.w_shrink_ray = getweapon("shrink_ray");
	level.w_shrink_ray_upgraded = getweapon("shrink_ray_upgraded");
	zm::register_player_damage_callback(&function_19171a77);
}

/*
	Name: __main__
	Namespace: zm_weap_shrink_ray
	Checksum: 0x8B11A348
	Offset: 0x640
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	if(isdefined(level.shrink_ray_model_mapping_func))
	{
		[[level.shrink_ray_model_mapping_func]]();
	}
}

/*
	Name: add_shrinkable_object
	Namespace: zm_weap_shrink_ray
	Checksum: 0x7D6A5113
	Offset: 0x668
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function add_shrinkable_object(ent)
{
	array::add(level.var_c50bd012, ent, 0);
}

/*
	Name: remove_shrinkable_object
	Namespace: zm_weap_shrink_ray
	Checksum: 0x32EB8F72
	Offset: 0x6A0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function remove_shrinkable_object(ent)
{
	arrayremovevalue(level.var_c50bd012, ent);
}

/*
	Name: function_ebf92008
	Namespace: zm_weap_shrink_ray
	Checksum: 0x5EDA1459
	Offset: 0x6D8
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function function_ebf92008()
{
	while(true)
	{
		level.var_1b24c8b0 = 0;
		util::wait_network_frame();
	}
}

/*
	Name: function_37ce705e
	Namespace: zm_weap_shrink_ray
	Checksum: 0xFE8F8CF3
	Offset: 0x710
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_37ce705e()
{
	self endon(#"disconnect");
	for(;;)
	{
		self waittill(#"weapon_fired");
		currentweapon = self getcurrentweapon();
		if(currentweapon == level.w_shrink_ray || currentweapon == level.w_shrink_ray_upgraded)
		{
			self thread function_fe7a4182(currentweapon == level.w_shrink_ray_upgraded);
		}
	}
}

/*
	Name: function_19171a77
	Namespace: zm_weap_shrink_ray
	Checksum: 0x1837C087
	Offset: 0x7A0
	Size: 0xA4
	Parameters: 13
	Flags: Linked
*/
function function_19171a77(e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, w_weapon, v_point, v_dir, str_hit_loc, psoffsettime, b_damage_from_underneath, n_model_index, str_part_name)
{
	if(isdefined(e_inflictor))
	{
		if(isdefined(e_inflictor.shrinked) && e_inflictor.shrinked)
		{
			return 5;
		}
	}
	return n_damage;
}

/*
	Name: function_fe7a4182
	Namespace: zm_weap_shrink_ray
	Checksum: 0x66095D4B
	Offset: 0x850
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_fe7a4182(upgraded)
{
	zombies = function_66ab6f95(upgraded, 0);
	objects = function_66ab6f95(upgraded, 1);
	zombies = arraycombine(zombies, objects, 1, 0);
	var_744b41f1 = 1000;
	for(i = 0; i < zombies.size && i < var_744b41f1; i++)
	{
		if(isai(zombies[i]))
		{
			zombies[i] thread shrink_zombie(upgraded, self);
			continue;
		}
		zombies[i] notify(#"shrunk", upgraded);
	}
}

/*
	Name: function_20c24bab
	Namespace: zm_weap_shrink_ray
	Checksum: 0xE66B2C8A
	Offset: 0x988
	Size: 0x7C
	Parameters: 2
	Flags: None
*/
function function_20c24bab(upgraded, player)
{
	damage = 10;
	self dodamage(damage, player.origin, player, undefined, "projectile");
	self function_9ae4cf1b(damage, (0, 1, 0));
}

/*
	Name: function_9af5d92d
	Namespace: zm_weap_shrink_ray
	Checksum: 0x94F50335
	Offset: 0xA10
	Size: 0x14C
	Parameters: 2
	Flags: None
*/
function function_9af5d92d(upgraded, attacker)
{
	if(isdefined(self.shrinked) && self.shrinked)
	{
		return;
	}
	self.shrinked = 1;
	var_36333499 = self getattachsize();
	for(i = var_36333499 - 1; i >= 0; i--)
	{
		model = self getattachmodelname(i);
		self detach(model);
		var_89a773f5 = level.shrink_models[model];
		if(isdefined(var_89a773f5))
		{
			self attach(var_89a773f5);
		}
	}
	var_87aa5c26 = level.shrink_models[self.model];
	if(isdefined(var_87aa5c26))
	{
		self setmodel(var_87aa5c26);
	}
}

/*
	Name: shrink_zombie
	Namespace: zm_weap_shrink_ray
	Checksum: 0xD22E8E38
	Offset: 0xB68
	Size: 0xACE
	Parameters: 2
	Flags: Linked
*/
function shrink_zombie(upgraded, attacker)
{
	self endon(#"death");
	if(isdefined(self.shrinked) && self.shrinked)
	{
		return;
	}
	if(!isdefined(self.var_bb09c29a))
	{
		self.var_bb09c29a = 0;
	}
	var_50d1f39 = 2.5;
	if(self.animname == "sonic_zombie")
	{
		if(self.var_bb09c29a == 0)
		{
			var_50d1f39 = 0.75;
		}
		else
		{
			if(self.var_bb09c29a == 1)
			{
				var_50d1f39 = 1.5;
			}
			else
			{
				var_50d1f39 = 2.5;
			}
		}
	}
	else
	{
		if(self.animname == "napalm_zombie")
		{
			if(self.var_bb09c29a == 0)
			{
				var_50d1f39 = 0.75;
			}
			else
			{
				if(self.var_bb09c29a == 1)
				{
					var_50d1f39 = 1.5;
				}
				else
				{
					var_50d1f39 = 2.5;
				}
			}
		}
		else
		{
			var_50d1f39 = 2.5;
			var_50d1f39 = var_50d1f39 + randomfloatrange(0, 0.5);
		}
	}
	if(upgraded)
	{
		var_50d1f39 = var_50d1f39 * 2;
	}
	self.var_bb09c29a++;
	var_f1754347 = 0;
	if(isactor(self))
	{
		self clientfield::set("fun_size", 1);
	}
	self notify(#"shrink");
	self.shrinked = 1;
	self.var_2209ea1b = attacker;
	self.kill_on_wine_coccon = 1;
	if(!isdefined(attacker.shrinked_zombies))
	{
		attacker.shrinked_zombies = [];
	}
	if(!isdefined(attacker.shrinked_zombies[self.animname]))
	{
		attacker.shrinked_zombies[self.animname] = 0;
	}
	attacker.shrinked_zombies[self.animname]++;
	var_cd13f0ff = self.model;
	health = self.health;
	if(isdefined(self.animname) && self.animname == "monkey_zombie")
	{
		if(isdefined(self.shrink_ray_fling))
		{
			self [[self.shrink_ray_fling]](attacker);
		}
		else
		{
			fling_range_squared = level.zombie_vars["shrink_ray_fling_range"] * level.zombie_vars["shrink_ray_fling_range"];
			view_pos = attacker getweaponmuzzlepoint();
			test_origin = self getcentroid();
			test_range_squared = distancesquared(view_pos, test_origin);
			dist_mult = (fling_range_squared - test_range_squared) / fling_range_squared;
			fling_vec = vectornormalize(test_origin - view_pos);
			fling_vec = (fling_vec[0], fling_vec[1], abs(fling_vec[2]));
			fling_vec = vectorscale(fling_vec, 100 + (100 * dist_mult));
			self dodamage(self.health + 666, attacker.origin, attacker);
			self startragdoll();
			self launchragdoll(fling_vec);
		}
	}
	else
	{
		if(self function_f23d2379())
		{
			self function_6140a171(attacker);
		}
		else
		{
			self playsound("evt_shrink");
			self.var_2209ea1b thread zm_audio::create_and_play_dialog("kill", "shrink");
			self thread function_259d2f7a("shrink", "J_MainRoot");
			var_939fbc94 = self.meleedamage;
			self.meleedamage = 5;
			self.no_gib = 1;
			self zombie_utility::zombie_eye_glow_stop();
			attachedmodels = [];
			attachedtags = [];
			hatmodel = self.hatmodel;
			var_36333499 = self getattachsize();
			for(i = var_36333499 - 1; i >= 0; i--)
			{
				model = self getattachmodelname(i);
				tag = self getattachtagname(i);
				var_4f32ff14 = isdefined(self.hatmodel) && self.hatmodel == model;
				if(var_4f32ff14)
				{
					self.hatmodel = undefined;
				}
				attachedmodels[attachedmodels.size] = model;
				attachedtags[attachedtags.size] = tag;
				self detach(model);
				var_89a773f5 = level.shrink_models[model];
				if(isdefined(var_89a773f5))
				{
					self attach(var_89a773f5);
					if(var_4f32ff14)
					{
						self.hatmodel = var_89a773f5;
					}
				}
			}
			var_87aa5c26 = level.shrink_models[self.model];
			if(isdefined(var_87aa5c26))
			{
				self setmodel(var_87aa5c26);
			}
			if(!self.missinglegs)
			{
				self setphysparams(8, -2, 32);
			}
			else
			{
				self allowpitchangle(0);
				neworigin = self.origin + vectorscale((0, 0, 1), 10);
				self teleport(neworigin, self.angles);
				self setphysparams(8, -16, 10);
			}
			self.health = 1;
			self thread function_6d284e94();
			self thread function_643fa9c8();
			self thread watch_for_death();
			self.zombie_board_tear_down_callback = &function_8b44a1f8;
			if(isdefined(self._zombie_shrink_callback))
			{
				self [[self._zombie_shrink_callback]]();
			}
			wait(var_50d1f39);
			self playsound("evt_unshrink");
			self thread function_259d2f7a("unshrink", "J_MainRoot");
			wait(0.5);
			self.zombie_board_tear_down_callback = undefined;
			if(isdefined(self._zombie_unshrink_callback))
			{
				self [[self._zombie_unshrink_callback]]();
			}
			var_36333499 = self getattachsize();
			for(i = var_36333499 - 1; i >= 0; i--)
			{
				model = self getattachmodelname(i);
				tag = self getattachtagname(i);
				self detach(model);
			}
			self.hatmodel = hatmodel;
			for(i = 0; i < attachedmodels.size; i++)
			{
				self attach(attachedmodels[i]);
			}
			self setmodel(var_cd13f0ff);
			if(!self.missinglegs)
			{
				self setphysparams(15, 0, 72);
			}
			else
			{
				self setphysparams(15, 0, 24);
				self allowpitchangle(1);
			}
			self.health = health;
			self.meleedamage = var_939fbc94;
			self.no_gib = 0;
		}
	}
	self zombie_utility::zombie_eye_glow();
	if(isactor(self))
	{
		self clientfield::set("fun_size", 0);
	}
	self notify(#"unshrink");
	self.shrinked = 0;
	self.var_2209ea1b = undefined;
	self.kill_on_wine_coccon = undefined;
}

/*
	Name: function_f23d2379
	Namespace: zm_weap_shrink_ray
	Checksum: 0x3608522C
	Offset: 0x1640
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function function_f23d2379()
{
	if(isdefined(self getlinkedent()))
	{
		return true;
	}
	if(isdefined(self.sliding) && self.sliding)
	{
		return true;
	}
	if(isdefined(self.in_the_ceiling) && self.in_the_ceiling)
	{
		return true;
	}
	return false;
}

/*
	Name: function_6d284e94
	Namespace: zm_weap_shrink_ray
	Checksum: 0xF402627F
	Offset: 0x16B0
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function function_6d284e94()
{
	self endon(#"unshrink");
	self endon(#"hash_b6537d92");
	self endon(#"kicked");
	self endon(#"death");
	wait(randomfloatrange(0.2, 0.5));
	while(true)
	{
		self playsound("zmb_mini_ambient");
		wait(randomfloatrange(1, 2.25));
	}
}

/*
	Name: function_259d2f7a
	Namespace: zm_weap_shrink_ray
	Checksum: 0x4FD1895A
	Offset: 0x1758
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function function_259d2f7a(fxname, jointname, offset)
{
	playfxontag(level._effect[fxname], self, "tag_origin");
}

/*
	Name: function_206493fd
	Namespace: zm_weap_shrink_ray
	Checksum: 0x1C90F728
	Offset: 0x17A8
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function function_206493fd(alias)
{
	self endon(#"death");
	wait(randomfloat(0.5));
	self zm_utility::play_sound_on_ent(alias);
}

/*
	Name: function_643fa9c8
	Namespace: zm_weap_shrink_ray
	Checksum: 0xC2FA3375
	Offset: 0x17F8
	Size: 0x2E0
	Parameters: 0
	Flags: Linked
*/
function function_643fa9c8()
{
	self endon(#"death");
	self endon(#"unshrink");
	self.var_f0dec186 = spawn("trigger_radius", self.origin, 0, 30, 24);
	self.var_f0dec186 sethintstring("");
	self.var_f0dec186 setcursorhint("HINT_NOICON");
	self.var_f0dec186 enablelinkto();
	self.var_f0dec186 linkto(self);
	self.var_f0dec186 thread function_2c318bd(self);
	self.var_f0dec186 endon(#"death");
	while(true)
	{
		self.var_f0dec186 waittill(#"trigger", who);
		if(!isplayer(who))
		{
			continue;
		}
		if(!(isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area))
		{
			continue;
		}
		if(isdefined(self.magic_bullet_shield) && self.magic_bullet_shield)
		{
			continue;
		}
		movement = who getnormalizedmovement();
		if(length(movement) < 0.1)
		{
			continue;
		}
		toenemy = self.origin - who.origin;
		toenemy = (toenemy[0], toenemy[1], 0);
		toenemy = vectornormalize(toenemy);
		forward_view_angles = anglestoforward(who.angles);
		var_884fd8ec = vectordot(forward_view_angles, toenemy);
		if(var_884fd8ec > 0.5 && movement[0] > 0)
		{
			self notify(#"kicked");
			who notify(#"hash_49423c6f");
			self function_867ec02b(who);
		}
		else
		{
			self notify(#"hash_b6537d92");
			self function_6140a171(who);
		}
	}
}

/*
	Name: function_2c318bd
	Namespace: zm_weap_shrink_ray
	Checksum: 0x6E64FE79
	Offset: 0x1AE0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_2c318bd(var_34c9bd99)
{
	self endon(#"death");
	var_34c9bd99 waittill(#"death");
	self delete();
}

/*
	Name: watch_for_death
	Namespace: zm_weap_shrink_ray
	Checksum: 0x73DB3762
	Offset: 0x1B28
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function watch_for_death()
{
	self endon(#"unshrink");
	self endon(#"hash_b6537d92");
	self endon(#"kicked");
	self waittill(#"death");
	self function_6140a171();
}

/*
	Name: function_12c1fddf
	Namespace: zm_weap_shrink_ray
	Checksum: 0x19F2988A
	Offset: 0x1B80
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_12c1fddf(v_launch)
{
	if(!isdefined(level.var_6d0abb4c))
	{
		level.var_6d0abb4c = 0;
	}
	if(level.var_6d0abb4c < 5)
	{
		level.var_6d0abb4c++;
		self launchragdoll(v_launch);
		wait(3);
		level.var_6d0abb4c--;
	}
}

/*
	Name: function_867ec02b
	Namespace: zm_weap_shrink_ray
	Checksum: 0x5C097801
	Offset: 0x1BF0
	Size: 0x28C
	Parameters: 1
	Flags: Linked
*/
function function_867ec02b(killer)
{
	if(level flag::get("world_is_paused"))
	{
		self setignorepauseworld(1);
	}
	self thread function_9ac50518();
	kickangles = killer.angles;
	kickangles = kickangles + (randomfloatrange(-30, -20), randomfloatrange(-5, 5), 0);
	launchdir = anglestoforward(kickangles);
	if(killer issprinting())
	{
		launchforce = randomfloatrange(350, 400);
	}
	else
	{
		vel = killer getvelocity();
		speed = length(vel);
		scale = math::clamp(speed / 190, 0.1, 1);
		launchforce = randomfloatrange(200 * scale, 250 * scale);
	}
	self startragdoll();
	self thread function_12c1fddf(launchdir * launchforce);
	util::wait_network_frame();
	killer thread zm_audio::create_and_play_dialog("kill", "shrunken");
	self dodamage(self.health + 666, self.origin, killer);
	if(isdefined(self.var_f0dec186))
	{
		self.var_f0dec186 delete();
	}
}

/*
	Name: function_9ac50518
	Namespace: zm_weap_shrink_ray
	Checksum: 0x35555096
	Offset: 0x1E88
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_9ac50518()
{
	if(!isdefined(level.var_1b24c8b0))
	{
		level thread function_ebf92008();
	}
	if(level.var_1b24c8b0 > 3)
	{
		return;
	}
	level.var_1b24c8b0++;
	playsoundatposition("zmb_mini_kicked", self.origin);
}

/*
	Name: function_6140a171
	Namespace: zm_weap_shrink_ray
	Checksum: 0xF1818AA6
	Offset: 0x1EF8
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function function_6140a171(killer)
{
	playsoundatposition("zmb_mini_squashed", self.origin);
	if(level flag::get("world_is_paused"))
	{
		self setignorepauseworld(1);
	}
	playfx(level._effect["shrink_ray_stepped_on_no_gore"], self.origin);
	self thread zombie_utility::zombie_eye_glow_stop();
	util::wait_network_frame();
	self hide();
	self dodamage(self.health + 666, self.origin, killer);
	if(isdefined(self.var_f0dec186))
	{
		self.var_f0dec186 delete();
	}
}

/*
	Name: function_66ab6f95
	Namespace: zm_weap_shrink_ray
	Checksum: 0x9DEE8EFA
	Offset: 0x2030
	Size: 0x586
	Parameters: 2
	Flags: Linked
*/
function function_66ab6f95(upgraded, var_5eafa9ab)
{
	range = 480;
	radius = 60;
	if(upgraded)
	{
		range = 1200;
		radius = 84;
	}
	var_91820d09 = [];
	view_pos = self getweaponmuzzlepoint();
	test_list = undefined;
	if(var_5eafa9ab)
	{
		test_list = level.var_c50bd012;
		range = range * 5;
	}
	else
	{
		test_list = getaispeciesarray(level.zombie_team, "all");
	}
	zombies = util::get_array_of_closest(view_pos, test_list, undefined, undefined, range * 1.1);
	if(!isdefined(zombies))
	{
		return;
	}
	range_squared = range * range;
	radius_squared = radius * radius;
	forward_view_angles = self getweaponforwarddir();
	end_pos = view_pos + vectorscale(forward_view_angles, range);
	/#
		if(2 == getdvarint(""))
		{
			near_circle_pos = view_pos + vectorscale(forward_view_angles, 2);
			circle(near_circle_pos, radius, (1, 0, 0), 0, 0, 100);
			line(near_circle_pos, end_pos, (0, 0, 1), 1, 0, 100);
			circle(end_pos, radius, (1, 0, 0), 0, 0, 100);
		}
	#/
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]) || (isai(zombies[i]) && !isalive(zombies[i])))
		{
			continue;
		}
		if(isdefined(zombies[i].shrinked) && zombies[i].shrinked)
		{
			zombies[i] function_9ae4cf1b("shrinked", (1, 0, 0));
			continue;
		}
		if(isdefined(zombies[i].no_shrink) && zombies[i].no_shrink)
		{
			zombies[i] function_9ae4cf1b("no_shrink", (1, 0, 0));
			continue;
		}
		test_origin = zombies[i] getcentroid();
		test_range_squared = distancesquared(view_pos, test_origin);
		if(test_range_squared > range_squared)
		{
			zombies[i] function_9ae4cf1b("range", (1, 0, 0));
			break;
		}
		normal = vectornormalize(test_origin - view_pos);
		dot = vectordot(forward_view_angles, normal);
		if(0 > dot)
		{
			zombies[i] function_9ae4cf1b("dot", (1, 0, 0));
			continue;
		}
		radial_origin = pointonsegmentnearesttopoint(view_pos, end_pos, test_origin);
		if(distancesquared(test_origin, radial_origin) > radius_squared)
		{
			zombies[i] function_9ae4cf1b("cylinder", (1, 0, 0));
			continue;
		}
		if(0 == zombies[i] damageconetrace(view_pos, self))
		{
			zombies[i] function_9ae4cf1b("cone", (1, 0, 0));
			continue;
		}
		var_91820d09[var_91820d09.size] = zombies[i];
	}
	return var_91820d09;
}

/*
	Name: function_9ae4cf1b
	Namespace: zm_weap_shrink_ray
	Checksum: 0xA6F3C4C6
	Offset: 0x25C0
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function function_9ae4cf1b(msg, color)
{
	/#
		if(!getdvarint(""))
		{
			return;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		print3d(self.origin + vectorscale((0, 0, 1), 60), msg, color, 1, 1, 40);
	#/
}

/*
	Name: function_8b44a1f8
	Namespace: zm_weap_shrink_ray
	Checksum: 0x71ACA6D8
	Offset: 0x2658
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_8b44a1f8()
{
	self endon(#"death");
	self endon(#"unshrink");
	while(true)
	{
		taunt_anim = array::random(level._zombie_board_taunt["zombie"]);
	}
}

