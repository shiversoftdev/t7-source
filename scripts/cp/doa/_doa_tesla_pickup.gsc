// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\doa\_doa_dev;
#using scripts\cp\doa\_doa_enemy;
#using scripts\cp\doa\_doa_fx;
#using scripts\cp\doa\_doa_gibs;
#using scripts\cp\doa\_doa_pickups;
#using scripts\cp\doa\_doa_player_utility;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\doa\_doa_sfx;
#using scripts\cp\doa\_doa_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#using_animtree("generic_human");

#namespace namespace_3f3eaecb;

/*
	Name: init
	Namespace: namespace_3f3eaecb
	Checksum: 0x7A44167F
	Offset: 0x460
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.weaponzmteslagun = getweapon("tesla_gun");
	level.weaponzmteslagunupgraded = getweapon("tesla_gun_upgraded");
	level.doa.rules.tesla_max_arcs = 5;
	level.doa.rules.tesla_max_enemies_killed = 20;
	level.doa.rules.tesla_radius_start = 300;
	level.doa.rules.tesla_radius_decay = 20;
	level.doa.rules.tesla_head_gib_chance = 50;
	level.doa.rules.var_37d05402 = 30;
}

/*
	Name: tesla_discharge_mechanic
	Namespace: namespace_3f3eaecb
	Checksum: 0xFEADCEA
	Offset: 0x558
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function tesla_discharge_mechanic()
{
	self endon(#"tesla_discharge_mechanic");
	self notify(#"tesla_discharge_mechanic");
	self endon(#"disconnect");
	while(true)
	{
		self.tesla_discharge = 1;
		self waittill(#"tesla_discharged");
		self.tesla_discharge = 0;
		wait(2);
	}
}

/*
	Name: tesla_ok_to_discharge
	Namespace: namespace_3f3eaecb
	Checksum: 0xED26D94F
	Offset: 0x5C0
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function tesla_ok_to_discharge(player)
{
	if(!isdefined(player.tesla_discharge))
	{
		return 1;
	}
	if(player.tesla_discharge == 0)
	{
		return 0;
	}
	return 1;
}

/*
	Name: tesla_damage_init
	Namespace: namespace_3f3eaecb
	Checksum: 0x78FEC1CF
	Offset: 0x610
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function tesla_damage_init(player)
{
	player endon(#"disconnect");
	player endon(#"death");
	waittillframeend();
	if(!tesla_ok_to_discharge(player))
	{
		return;
	}
	if(isdefined(self.zombie_tesla_hit) && self.zombie_tesla_hit)
	{
		return;
	}
	player.tesla_enemies = undefined;
	player.tesla_enemies_hit = 1;
	player.tesla_powerup_dropped = 0;
	player notify(#"tesla_discharged");
	self thread namespace_eaa992c::function_285a2999("tesla_shock");
	if(!(isdefined(self.boss) && self.boss))
	{
		self tesla_arc_damage(self, player, 0);
	}
	player.tesla_enemies_hit = 0;
}

/*
	Name: tesla_arc_damage
	Namespace: namespace_3f3eaecb
	Checksum: 0xDBFA5FB6
	Offset: 0x710
	Size: 0x20E
	Parameters: 3
	Flags: Linked
*/
function tesla_arc_damage(source_enemy, player, arc_num)
{
	player endon(#"disconnect");
	player endon(#"death");
	tesla_flag_hit(self, 1);
	radius_decay = level.doa.rules.tesla_radius_decay * arc_num;
	enemies = tesla_get_enemies_in_area(self gettagorigin("j_head"), level.doa.rules.tesla_radius_start - radius_decay, player);
	tesla_flag_hit(enemies, 1);
	self thread tesla_do_damage(source_enemy, arc_num, player);
	for(i = 0; i < enemies.size; i++)
	{
		if(enemies[i] == self)
		{
			continue;
		}
		if(isdefined(enemies[i].boss) && enemies[i].boss == 1)
		{
			continue;
		}
		if(tesla_end_arc_damage(arc_num + 1, player.tesla_enemies_hit))
		{
			tesla_flag_hit(enemies[i], 0);
			continue;
		}
		player.tesla_enemies_hit++;
		enemies[i] thread tesla_arc_damage(self, player, arc_num + 1);
	}
}

/*
	Name: tesla_end_arc_damage
	Namespace: namespace_3f3eaecb
	Checksum: 0xE143672
	Offset: 0x928
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function tesla_end_arc_damage(arc_num, enemies_hit_num)
{
	if(arc_num >= level.doa.rules.tesla_max_arcs)
	{
		return 1;
	}
	if(enemies_hit_num >= level.doa.rules.tesla_max_enemies_killed)
	{
		return 1;
	}
	radius_decay = level.doa.rules.tesla_radius_decay * arc_num;
	if(level.doa.rules.tesla_radius_start - radius_decay <= 0)
	{
		return 1;
	}
	return 0;
}

/*
	Name: tesla_get_enemies_in_area
	Namespace: namespace_3f3eaecb
	Checksum: 0x5783B256
	Offset: 0x9F0
	Size: 0x1E8
	Parameters: 3
	Flags: Linked
*/
function tesla_get_enemies_in_area(origin, distance, player)
{
	distance_squared = distance * distance;
	enemies = [];
	if(!isdefined(player.tesla_enemies))
	{
		player.tesla_enemies = getaispeciesarray("axis", "all");
		player.tesla_enemies = util::get_array_of_closest(origin, player.tesla_enemies);
	}
	zombies = player.tesla_enemies;
	if(isdefined(zombies))
	{
		for(i = 0; i < zombies.size; i++)
		{
			if(!isdefined(zombies[i]))
			{
				continue;
			}
			test_origin = zombies[i] gettagorigin("j_head");
			if(isdefined(zombies[i].zombie_tesla_hit) && zombies[i].zombie_tesla_hit == 1)
			{
				continue;
			}
			if(distancesquared(origin, test_origin) > distance_squared)
			{
				continue;
			}
			if(!bullettracepassed(origin, test_origin, 0, undefined))
			{
				continue;
			}
			enemies[enemies.size] = zombies[i];
		}
	}
	return enemies;
}

/*
	Name: tesla_flag_hit
	Namespace: namespace_3f3eaecb
	Checksum: 0xA6185FF4
	Offset: 0xBE0
	Size: 0x90
	Parameters: 2
	Flags: Linked
*/
function tesla_flag_hit(enemy, hit)
{
	if(!isdefined(enemy))
	{
		return;
	}
	if(isarray(enemy))
	{
		for(i = 0; i < enemy.size; i++)
		{
			enemy[i].zombie_tesla_hit = hit;
		}
	}
	else
	{
		enemy.zombie_tesla_hit = hit;
	}
}

/*
	Name: tesla_do_damage
	Namespace: namespace_3f3eaecb
	Checksum: 0xD915E289
	Offset: 0xC78
	Size: 0x1F4
	Parameters: 3
	Flags: Linked
*/
function tesla_do_damage(source_enemy, arc_num, player)
{
	player endon(#"disconnect");
	timetowait = 0.2 * arc_num;
	if(timetowait > 0)
	{
		wait(timetowait);
	}
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(isdefined(source_enemy) && source_enemy != self)
	{
		source_enemy tesla_play_arc_fx(self);
	}
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	self.tesla_death = 1;
	self thread tesla_play_death_fx(arc_num);
	origin = player.origin;
	if(isdefined(source_enemy) && source_enemy != self)
	{
		origin = source_enemy.origin;
	}
	if(self.archetype == "zombie")
	{
		self clientfield::set("zombie_gut_explosion", 1);
	}
	if(self.archetype == "robot")
	{
		self namespace_fba031c8::function_7b3e39cb();
	}
	if(isdefined(self.tesla_damage_func))
	{
		self [[self.tesla_damage_func]](origin, player);
		return;
	}
	self dodamage(self.health + 666, origin, player, player);
}

/*
	Name: tesla_play_death_fx
	Namespace: namespace_3f3eaecb
	Checksum: 0x23BD0038
	Offset: 0xE78
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function tesla_play_death_fx(arc_num)
{
	if(arc_num > 1)
	{
		self thread namespace_eaa992c::function_285a2999("tesla_shock_eyes");
	}
	self thread namespace_eaa992c::function_285a2999("tesla_shock");
	self thread namespace_1a381543::function_90118d8c("zmb_pwup_coco_impact");
	if(isdefined(self.tesla_head_gib_func))
	{
		[[self.tesla_head_gib_func]]();
	}
}

/*
	Name: tesla_play_arc_fx
	Namespace: namespace_3f3eaecb
	Checksum: 0x93C713FE
	Offset: 0xF10
	Size: 0x28C
	Parameters: 1
	Flags: Linked
*/
function tesla_play_arc_fx(target)
{
	if(!isdefined(self) || !isdefined(target))
	{
		wait(getdvarfloat("scr_arc_travel_time", 0.05));
		return;
	}
	tag = "J_SpineUpper";
	if(self.isdog)
	{
		tag = "J_Spine1";
	}
	target_tag = "J_SpineUpper";
	if(target.isdog)
	{
		target_tag = "J_Spine1";
	}
	origin = self gettagorigin(tag);
	target_origin = target gettagorigin(target_tag);
	distsq = distancesquared(origin, target_origin);
	var_3d719a1d = distsq / 128 * 128;
	timemove = var_3d719a1d * getdvarfloat("scr_arc_travel_time", 0.05);
	if(timemove < 0.2)
	{
		timemove = 0.2;
	}
	fxorg = spawn("script_model", origin);
	fxorg.targetname = "tesla_trail";
	fxorg setmodel("tag_origin");
	fxorg thread namespace_eaa992c::function_285a2999("tesla_trail");
	fxorg thread namespace_1a381543::function_90118d8c("zmb_pwup_coco_bounce");
	fxorg moveto(target_origin, timemove);
	fxorg util::waittill_any_timeout(timemove + 1, "movedone");
	fxorg delete();
}

/*
	Name: tesla_debug_arc
	Namespace: namespace_3f3eaecb
	Checksum: 0xE464F405
	Offset: 0x11A8
	Size: 0x6C
	Parameters: 2
	Flags: None
*/
function tesla_debug_arc(origin, distance)
{
	/#
		if(getdvarint(#"hash_fa91ea91") != 3)
		{
			return;
		}
		start = gettime();
		while(gettime() < start + 3000)
		{
			wait(0.05);
		}
	#/
}

/*
	Name: enemy_killed_by_tesla
	Namespace: namespace_3f3eaecb
	Checksum: 0x5A82EAB7
	Offset: 0x1220
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function enemy_killed_by_tesla()
{
	return isdefined(self.tesla_death) && self.tesla_death;
}

/*
	Name: function_395fdfb8
	Namespace: namespace_3f3eaecb
	Checksum: 0x4D86147E
	Offset: 0x1240
	Size: 0xF4
	Parameters: 2
	Flags: Linked
*/
function function_395fdfb8(guy, attacker)
{
	if(!isdefined(guy))
	{
		return 0;
	}
	if(isdefined(guy.boss) && guy.boss)
	{
		return 0;
	}
	if(isdefined(guy.damagedby) && guy.damagedby == "tesla" || (isdefined(guy.tesla_death) && guy.tesla_death))
	{
		return 0;
	}
	if(tesla_ok_to_discharge(attacker))
	{
		guy.damagedby = "tesla";
		guy thread tesla_damage_init(attacker);
		return 1;
	}
	return 0;
}

/*
	Name: tesla_blockers_damage_trigger
	Namespace: namespace_3f3eaecb
	Checksum: 0x56FFB1CC
	Offset: 0x1340
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function tesla_blockers_damage_trigger(player, note)
{
	player endon(note);
	player endon(#"disconnect");
	while(true)
	{
		self waittill(#"trigger", guy);
		if(level thread function_395fdfb8(guy, player))
		{
			self.triggered = 1;
			break;
		}
	}
}

/*
	Name: tesla_blockers_timeout
	Namespace: namespace_3f3eaecb
	Checksum: 0x8DA5BE2B
	Offset: 0x13D0
	Size: 0xEE
	Parameters: 2
	Flags: Linked
*/
function tesla_blockers_timeout(org, note)
{
	self endon(note);
	self endon(#"disconnect");
	org playloopsound("zmb_pwup_coco_loop");
	level doa_utility::function_124b9a08();
	wait(self doa_utility::function_1ded48e6(level.doa.rules.var_37d05402));
	org stopsounds();
	org stoploopsound(0.5);
	self thread namespace_1a381543::function_90118d8c("zmb_pwup_coco_end");
	self notify(note);
}

/*
	Name: function_ccf71744
	Namespace: namespace_3f3eaecb
	Checksum: 0xE9ABE27B
	Offset: 0x14C8
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function function_ccf71744(org, vel)
{
	self moveto(org.origin, 0.5);
	self util::waittill_any_timeout(1, "movedone");
	vel = vel * 0.4;
	self thread namespace_eaa992c::function_285a2999("tesla_launch");
	self physicslaunch(self.origin, vel);
}

/*
	Name: function_89843a06
	Namespace: namespace_3f3eaecb
	Checksum: 0x5CDB3F0B
	Offset: 0x1580
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function function_89843a06(player)
{
	self endon(#"death");
	player waittill(#"disconnect");
	for(i = 0; i < self.triggers.size; i++)
	{
		if(isdefined(self.triggers[i]))
		{
			self.triggers[i] delete();
			self.objects[i] unlink();
		}
	}
	wait(2);
	for(i = 0; i < self.objects.size; i++)
	{
		if(isdefined(self.objects[i]))
		{
			self.objects[i] delete();
		}
	}
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: tesla_blockers_cleanup
	Namespace: namespace_3f3eaecb
	Checksum: 0xEB6CA3E1
	Offset: 0x16B0
	Size: 0x224
	Parameters: 2
	Flags: Linked
*/
function tesla_blockers_cleanup(org, note)
{
	self util::waittill_any(note, "disconnect", "player_died", "kill_shield", "doa_playerVehiclePickup");
	if(isdefined(self))
	{
		self notify(note);
	}
	if(isdefined(org))
	{
		for(i = 0; i < org.triggers.size; i++)
		{
			if(isdefined(org.triggers[i]))
			{
				org.triggers[i] delete();
				org.objects[i] unlink();
				if(isdefined(self))
				{
					vel = org.objects[i].origin - self.origin;
					org.objects[i] thread function_ccf71744(org, vel);
				}
			}
		}
	}
	wait(2);
	if(isdefined(org))
	{
		for(i = 0; i < org.objects.size; i++)
		{
			if(isdefined(org.objects[i]))
			{
				org.objects[i] delete();
			}
		}
	}
	if(isdefined(self))
	{
		self.doa.tesla_blockers = undefined;
	}
	if(isdefined(org))
	{
		org delete();
	}
}

/*
	Name: tesla_blockers_deletion_monitors
	Namespace: namespace_3f3eaecb
	Checksum: 0xCAD648F4
	Offset: 0x18E0
	Size: 0x13C
	Parameters: 2
	Flags: Linked
*/
function tesla_blockers_deletion_monitors(org, note)
{
	self endon(note);
	org endon(#"death");
	count = 0;
	while(true)
	{
		for(i = 0; i < org.objects.size; i++)
		{
			if(isdefined(org.triggers[i]) && isdefined(org.triggers[i].triggered))
			{
				org.triggers[i] delete();
				org.objects[i] delete();
				count++;
				if(count >= 4)
				{
					org stoploopsound(0.5);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: tesla_blockers_move
	Namespace: namespace_3f3eaecb
	Checksum: 0xFED77A14
	Offset: 0x1A28
	Size: 0x76
	Parameters: 2
	Flags: Linked
*/
function tesla_blockers_move(org, note)
{
	self endon(note);
	org endon(#"death");
	while(true)
	{
		org rotateto(org.angles + vectorscale((0, 1, 0), 180), 1);
		wait(1);
	}
}

/*
	Name: tesla_blockers_fx
	Namespace: namespace_3f3eaecb
	Checksum: 0x85CA1AA1
	Offset: 0x1AA8
	Size: 0xC6
	Parameters: 1
	Flags: Linked
*/
function tesla_blockers_fx(org)
{
	self endon(#"death");
	self endon(#"disconnect");
	for(i = 0; i < org.objects.size; i++)
	{
		if(isdefined(org.objects[i]))
		{
			org.objects[i] thread namespace_eaa992c::function_285a2999("tesla_trail");
			org.objects[i] thread namespace_eaa992c::function_285a2999("tesla_ball");
		}
	}
}

/*
	Name: tesla_blockers_update
	Namespace: namespace_3f3eaecb
	Checksum: 0x44D991C9
	Offset: 0x1B78
	Size: 0x92C
	Parameters: 0
	Flags: Linked
*/
function tesla_blockers_update()
{
	note = doa_utility::function_2ccf4b82("end_tesla_pickup");
	self endon(note);
	self thread tesla_discharge_mechanic();
	if(!mayspawnentity())
	{
		return;
	}
	org = spawn("script_model", self.origin);
	org.targetname = "tesla_blockers_update";
	org.angles = (0, randomint(180), 0);
	org.triggers = [];
	org.objects = [];
	def = doa_pickups::function_bac08508(6);
	self.doa.tesla_blockers = org;
	org setmodel("tag_origin");
	org linkto(self, "tag_origin");
	if(mayspawnentity() && mayspawnfakeentity())
	{
		tesla = spawn("script_model", self.origin);
		tesla.targetname = "teslaball1";
		tesla setmodel(level.doa.var_f6e22ab8);
		tesla setscale(def.scale);
		tesla linkto(org, "tag_origin", (0, 60, 50));
		trigger = spawn("trigger_radius", tesla.origin, 9, 18, 50);
		trigger.targetname = "tesla1";
		trigger enablelinkto();
		trigger linkto(tesla);
		trigger thread tesla_blockers_damage_trigger(self, note);
		org.objects[org.objects.size] = tesla;
		org.triggers[org.triggers.size] = trigger;
	}
	if(mayspawnentity() && mayspawnfakeentity())
	{
		tesla = spawn("script_model", self.origin);
		tesla.targetname = "teslaball2";
		tesla setmodel(level.doa.var_f6e22ab8);
		tesla setscale(def.scale);
		tesla linkto(org, "tag_origin", (0, -60, 50));
		trigger = spawn("trigger_radius", tesla.origin, 9, 18, 50);
		trigger.targetname = "tesla2";
		trigger enablelinkto();
		trigger linkto(tesla);
		trigger thread tesla_blockers_damage_trigger(self, note);
		org.objects[org.objects.size] = tesla;
		org.triggers[org.triggers.size] = trigger;
	}
	if(mayspawnentity() && mayspawnfakeentity())
	{
		tesla = spawn("script_model", self.origin);
		tesla.targetname = "teslaball3";
		tesla setmodel(level.doa.var_f6e22ab8);
		tesla setscale(def.scale);
		tesla linkto(org, "tag_origin", (60, 0, 50));
		trigger = spawn("trigger_radius", tesla.origin, 9, 18, 50);
		trigger.targetname = "tesla3";
		trigger enablelinkto();
		trigger linkto(tesla);
		trigger thread tesla_blockers_damage_trigger(self, note);
		org.objects[org.objects.size] = tesla;
		org.triggers[org.triggers.size] = trigger;
	}
	if(mayspawnentity() && mayspawnfakeentity())
	{
		tesla = spawn("script_model", self.origin);
		tesla.targetname = "teslaball4";
		tesla setmodel(level.doa.var_f6e22ab8);
		tesla setscale(def.scale);
		tesla linkto(org, "tag_origin", (-60, 0, 50));
		trigger = spawn("trigger_radius", tesla.origin, 9, 18, 50);
		trigger.targetname = "tesla4";
		trigger enablelinkto();
		trigger linkto(tesla);
		trigger thread tesla_blockers_damage_trigger(self, note);
		org.objects[org.objects.size] = tesla;
		org.triggers[org.triggers.size] = trigger;
	}
	util::wait_network_frame();
	self thread tesla_blockers_move(org, note);
	self thread tesla_blockers_fx(org);
	self thread tesla_blockers_deletion_monitors(org, note);
	self thread tesla_blockers_timeout(org, note);
	self thread tesla_blockers_cleanup(org, note);
	org thread function_89843a06(self);
}

