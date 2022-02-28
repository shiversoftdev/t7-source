// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace mirg2000;

/*
	Name: __init__sytem__
	Namespace: mirg2000
	Checksum: 0xBAC84CB5
	Offset: 0x708
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("mirg2000", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: mirg2000
	Checksum: 0xFBC1135B
	Offset: 0x750
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.var_5e75629a = getweapon("hero_mirg2000");
	level.var_a367ea52 = getweapon("hero_mirg2000_1");
	level.var_7d656fe9 = getweapon("hero_mirg2000_2");
	level.var_a4052592 = getweapon("hero_mirg2000_upgraded");
	level.var_5c210a9a = getweapon("hero_mirg2000_upgraded_1");
	level.var_361e9031 = getweapon("hero_mirg2000_upgraded_2");
	clientfield::register("scriptmover", "plant_killer", 9000, getminbitcountfornum(4), "int");
	clientfield::register("vehicle", "mirg2000_spider_death_fx", 9000, 2, "int");
	clientfield::register("actor", "mirg2000_enemy_impact_fx", 9000, 2, "int");
	clientfield::register("vehicle", "mirg2000_enemy_impact_fx", 9000, 2, "int");
	clientfield::register("allplayers", "mirg2000_fire_button_held_sound", 9000, 1, "int");
	clientfield::register("toplayer", "mirg2000_charge_glow", 9000, 2, "int");
}

/*
	Name: __main__
	Namespace: mirg2000
	Checksum: 0xCC835182
	Offset: 0x950
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	callback::on_connect(&function_182a023);
}

/*
	Name: function_182a023
	Namespace: mirg2000
	Checksum: 0x8F90155C
	Offset: 0x980
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_182a023()
{
	self thread function_56c8d7bb();
	self thread function_3940d816();
	self thread watch_weapon_change();
	self thread function_9e09b719();
}

/*
	Name: is_wonder_weapon
	Namespace: mirg2000
	Checksum: 0xCB816734
	Offset: 0x9F0
	Size: 0x228
	Parameters: 2
	Flags: Linked
*/
function is_wonder_weapon(weapon, str_type = "any")
{
	if(!isdefined(weapon))
	{
		return false;
	}
	switch(str_type)
	{
		case "any":
		{
			if(weapon == level.var_5e75629a || weapon == level.var_a367ea52 || weapon == level.var_7d656fe9 || weapon == level.var_a4052592 || weapon == level.var_5c210a9a || weapon == level.var_361e9031)
			{
				return true;
			}
			break;
		}
		case "default":
		{
			if(weapon == level.var_5e75629a || weapon == level.var_a367ea52 || weapon == level.var_7d656fe9)
			{
				return true;
			}
			break;
		}
		case "default_charged_shot":
		{
			if(weapon == level.var_a367ea52 || weapon == level.var_7d656fe9)
			{
				return true;
			}
			break;
		}
		case "upgraded":
		{
			if(weapon == level.var_a4052592 || weapon == level.var_5c210a9a || weapon == level.var_361e9031)
			{
				return true;
			}
			break;
		}
		case "upgraded_charged_shot":
		{
			if(weapon == level.var_5c210a9a || weapon == level.var_361e9031)
			{
				return true;
			}
			break;
		}
		default:
		{
			if(weapon == level.var_5e75629a || weapon == level.var_a367ea52 || weapon == level.var_7d656fe9 || weapon == level.var_a4052592 || weapon == level.var_5c210a9a || weapon == level.var_361e9031)
			{
				return true;
			}
			break;
		}
	}
	return false;
}

/*
	Name: function_a1fce678
	Namespace: mirg2000
	Checksum: 0x447EBD4
	Offset: 0xC20
	Size: 0xCE
	Parameters: 1
	Flags: Linked
*/
function function_a1fce678(var_2b568a63 = 0)
{
	if(self hasweapon(level.var_a4052592))
	{
		if(var_2b568a63)
		{
			if(self.chargeshotlevel > 2)
			{
				n_range_sq = 22500;
			}
			else
			{
				n_range_sq = 7225;
			}
		}
		else
		{
			n_range_sq = 7225;
		}
	}
	else
	{
		if(var_2b568a63)
		{
			if(self.chargeshotlevel > 2)
			{
				n_range_sq = 22500;
			}
			else
			{
				n_range_sq = 7225;
			}
		}
		else
		{
			n_range_sq = 7225;
		}
	}
	return n_range_sq;
}

/*
	Name: function_8734b840
	Namespace: mirg2000
	Checksum: 0xA80A1EF1
	Offset: 0xCF8
	Size: 0xAE
	Parameters: 4
	Flags: Linked
*/
function function_8734b840(v_start, v_end, n_range_sq, var_a8ed33a = 72)
{
	n_height_diff = abs(v_end[2] - v_start[2]);
	if(distance2dsquared(v_start, v_end) <= n_range_sq && n_height_diff <= var_a8ed33a)
	{
		return true;
	}
	return false;
}

/*
	Name: function_794992bd
	Namespace: mirg2000
	Checksum: 0x20D778AE
	Offset: 0xDB0
	Size: 0xB4
	Parameters: 2
	Flags: Linked
*/
function function_794992bd(player, v_pos)
{
	if(player hasweapon(level.var_a4052592))
	{
		n_damage = 7000;
		var_a9fb62c6 = 2;
	}
	else
	{
		n_damage = 1750;
		var_a9fb62c6 = 1;
	}
	self dodamage(n_damage, v_pos, player, player);
	self clientfield::set("mirg2000_enemy_impact_fx", var_a9fb62c6);
}

/*
	Name: function_b926526f
	Namespace: mirg2000
	Checksum: 0x3D4A684C
	Offset: 0xE70
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function function_b926526f(mod, weapon)
{
	return is_wonder_weapon(weapon) && (mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH");
}

/*
	Name: watch_weapon_change
	Namespace: mirg2000
	Checksum: 0x658A0233
	Offset: 0xEC8
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function watch_weapon_change()
{
	self endon(#"disconnect");
	while(true)
	{
		str_notify = self util::waittill_any_return("weapon_fired", "weapon_melee", "weapon_change", "reload", "reload_start", "disconnect");
		w_current = self getcurrentweapon();
		if(is_wonder_weapon(w_current))
		{
			n_ammo_clip = self getweaponammoclip(w_current);
			if(n_ammo_clip == 0 || str_notify == "reload_start")
			{
				self clientfield::set_to_player("mirg2000_charge_glow", 3);
			}
			else
			{
				self clientfield::set_to_player("mirg2000_charge_glow", 2);
			}
		}
		else if(str_notify == "weapon_change" && !is_wonder_weapon(w_current))
		{
			self clientfield::set_to_player("mirg2000_charge_glow", 3);
		}
	}
}

/*
	Name: function_3940d816
	Namespace: mirg2000
	Checksum: 0x85F78EE3
	Offset: 0x1048
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function function_3940d816()
{
	self endon(#"disconnect");
	while(true)
	{
		w_current = self getcurrentweapon();
		if(is_wonder_weapon(w_current) && self.chargeshotlevel > 1)
		{
			var_6e3a6054 = self getweaponammoclip(w_current);
			if(self.chargeshotlevel > var_6e3a6054)
			{
				var_941e50a8 = var_6e3a6054;
			}
			else
			{
				var_941e50a8 = self.chargeshotlevel;
				self playsound("zmb_mirg_charge_" + var_941e50a8);
			}
			switch(var_941e50a8)
			{
				case 1:
				{
					self clientfield::set_to_player("mirg2000_charge_glow", 2);
					break;
				}
				case 2:
				{
					self clientfield::set_to_player("mirg2000_charge_glow", 1);
					self notify(#"hash_be077d23");
					break;
				}
				case 3:
				{
					self clientfield::set_to_player("mirg2000_charge_glow", 0);
					self notify(#"hash_be077d23");
					break;
				}
				default:
				{
					self clientfield::set_to_player("mirg2000_charge_glow", 3);
					break;
				}
			}
			while(self.chargeshotlevel == var_941e50a8)
			{
				wait(0.1);
			}
			if(self.chargeshotlevel == 0 && !self isreloading())
			{
				self clientfield::set_to_player("mirg2000_charge_glow", 2);
			}
		}
		wait(0.1);
	}
}

/*
	Name: function_9e09b719
	Namespace: mirg2000
	Checksum: 0x1EA364CD
	Offset: 0x1278
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function function_9e09b719()
{
	self endon(#"disconnect");
	self.var_c654a75a = 0;
	while(true)
	{
		if(self util::attack_button_held())
		{
			weapon = self getcurrentweapon();
			if(is_wonder_weapon(weapon) && !self.var_c654a75a)
			{
				self.var_c654a75a = 1;
				self clientfield::set("mirg2000_fire_button_held_sound", 1);
			}
		}
		else if(!self util::attack_button_held() && self.var_c654a75a)
		{
			self.var_c654a75a = 0;
			self clientfield::set("mirg2000_fire_button_held_sound", 0);
		}
		wait(0.05);
	}
}

/*
	Name: function_56c8d7bb
	Namespace: mirg2000
	Checksum: 0xC87EC92C
	Offset: 0x1388
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function function_56c8d7bb()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"grenade_launcher_fire", grenade, weapon);
		if(!is_wonder_weapon(weapon))
		{
			continue;
		}
		if(!isdefined(grenade))
		{
			continue;
		}
		if(!isdefined(self.chargeshotlevel))
		{
			continue;
		}
		self.var_72053d6e = 0;
		var_e4a438f3 = self getweaponammoclip(self getcurrentweapon());
		var_d24bfa82 = self function_25db292d(var_e4a438f3 + 1);
		grenade thread function_74a68c49(self, var_d24bfa82);
	}
}

/*
	Name: function_25db292d
	Namespace: mirg2000
	Checksum: 0xBA5691C4
	Offset: 0x1490
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function function_25db292d(var_e4a438f3)
{
	if(var_e4a438f3 >= self.chargeshotlevel)
	{
		n_ammo = var_e4a438f3 - self.chargeshotlevel;
		self setweaponammoclip(self getcurrentweapon(), n_ammo);
		n_chargelevel = self.chargeshotlevel;
	}
	else
	{
		if(var_e4a438f3 > 1 && self.chargeshotlevel > var_e4a438f3)
		{
			self setweaponammoclip(self getcurrentweapon(), 0);
			n_chargelevel = var_e4a438f3;
		}
		else
		{
			n_chargelevel = var_e4a438f3;
		}
	}
	return n_chargelevel;
}

/*
	Name: function_74a68c49
	Namespace: mirg2000
	Checksum: 0x92F1DC7E
	Offset: 0x1578
	Size: 0x174
	Parameters: 2
	Flags: Linked
*/
function function_74a68c49(player, var_d24bfa82)
{
	self waittill(#"death");
	v_position = self.origin;
	v_angles = self.angles;
	if(!isdefined(v_position) || !isdefined(v_angles))
	{
		return;
	}
	switch(var_d24bfa82)
	{
		case 1:
		{
			player thread function_e0d7bd91(v_position);
			break;
		}
		case 2:
		case 3:
		{
			player thread function_1e4094ac(v_position, var_d24bfa82);
			break;
		}
		default:
		{
			player thread function_e0d7bd91(v_position);
			break;
		}
	}
	level thread function_4a06c777(v_position, player);
	level thread function_508749d7(v_position, player);
	level thread function_570d6f32(v_position, player);
	level thread function_9844cc8a(v_position, player);
}

/*
	Name: function_1e4094ac
	Namespace: mirg2000
	Checksum: 0x881E80C6
	Offset: 0x16F8
	Size: 0x17C
	Parameters: 2
	Flags: Linked
*/
function function_1e4094ac(v_position, var_d24bfa82)
{
	self endon(#"disconnect");
	v_pos = getclosestpointonnavmesh(v_position, 80);
	if(isdefined(v_pos))
	{
		var_31678178 = util::spawn_model("tag_origin", v_pos);
		var_31678178 endon(#"death");
		if(self hasweapon(level.var_a4052592))
		{
			var_a00b8053 = var_d24bfa82 + 1;
		}
		else
		{
			var_a00b8053 = var_d24bfa82 - 1;
		}
		var_31678178 clientfield::set("plant_killer", var_a00b8053);
		var_31678178 thread function_3604c7ec(self);
		self thread function_d3b8fbb0(v_pos, var_31678178);
		var_31678178 waittill(#"hash_2b1c6c7");
		var_31678178 clientfield::set("plant_killer", 0);
		wait(0.1);
		var_31678178 delete();
	}
}

/*
	Name: function_3604c7ec
	Namespace: mirg2000
	Checksum: 0xC26C17DB
	Offset: 0x1880
	Size: 0xB6
	Parameters: 1
	Flags: Linked
*/
function function_3604c7ec(player)
{
	self endon(#"death");
	player endon(#"disconnect");
	w_current_weapon = player getcurrentweapon();
	if(is_wonder_weapon(w_current_weapon, "upgraded"))
	{
		n_timeout = player.chargeshotlevel * 5;
	}
	else
	{
		n_timeout = player.chargeshotlevel * 3;
	}
	wait(n_timeout);
	self notify(#"hash_2b1c6c7");
}

/*
	Name: function_d3b8fbb0
	Namespace: mirg2000
	Checksum: 0x13DCD105
	Offset: 0x1940
	Size: 0x2B4
	Parameters: 2
	Flags: Linked
*/
function function_d3b8fbb0(v_pos, var_31678178)
{
	self endon(#"disconnect");
	var_31678178 endon(#"hash_2b1c6c7");
	n_kills = 0;
	n_range_sq = self function_a1fce678(1);
	w_current_weapon = self getcurrentweapon();
	if(is_wonder_weapon(w_current_weapon, "upgraded"))
	{
		var_31678178.n_kills = 9;
	}
	else
	{
		var_31678178.n_kills = 6;
	}
	while(true)
	{
		a_ai_zombies = getaiteamarray(level.zombie_team);
		foreach(ai_zombie in a_ai_zombies)
		{
			if(isalive(ai_zombie) && !isdefined(ai_zombie.var_3f6ea790) && (!(isdefined(ai_zombie.thrasherconsumed) && ai_zombie.thrasherconsumed)))
			{
				if(!(isdefined(ai_zombie.var_20b8c74a) && ai_zombie.var_20b8c74a) && function_8734b840(ai_zombie.origin, v_pos, n_range_sq))
				{
					self thread function_79504f13(ai_zombie, v_pos);
					n_kills++;
					if(n_kills >= var_31678178.n_kills)
					{
						var_31678178 notify(#"hash_2b1c6c7");
					}
					if(!(isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0) && (!(isdefined(ai_zombie.b_is_spider) && ai_zombie.b_is_spider)))
					{
						wait(0.5);
					}
				}
			}
		}
		wait(0.25);
	}
}

/*
	Name: function_b6ac59ff
	Namespace: mirg2000
	Checksum: 0xA559DA82
	Offset: 0x1C00
	Size: 0xB8
	Parameters: 2
	Flags: None
*/
function function_b6ac59ff(v_pos, n_range_sq)
{
	self endon(#"death");
	self.var_988ea0d8 = 1;
	self.var_317d58a6 = self.zombie_move_speed;
	self zombie_utility::set_zombie_run_cycle("walk");
	while(function_8734b840(self.origin, v_pos, n_range_sq))
	{
		wait(0.5);
	}
	self zombie_utility::set_zombie_run_cycle(self.var_317d58a6);
	self.var_988ea0d8 = 0;
}

/*
	Name: function_4a06c777
	Namespace: mirg2000
	Checksum: 0x93F3EE7B
	Offset: 0x1CC0
	Size: 0x122
	Parameters: 2
	Flags: Linked
*/
function function_4a06c777(v_position, player)
{
	if(!isdefined(level.var_1abc7758))
	{
		return;
	}
	n_range_sq = player function_a1fce678();
	foreach(var_f58ff028 in level.var_1abc7758)
	{
		if(!isdefined(var_f58ff028.t_spore_damage))
		{
			continue;
		}
		if(function_8734b840(var_f58ff028.origin, v_position, n_range_sq))
		{
			var_f58ff028.t_spore_damage dodamage(1, v_position, player, player);
		}
	}
}

/*
	Name: function_508749d7
	Namespace: mirg2000
	Checksum: 0x48C44CC4
	Offset: 0x1DF0
	Size: 0x132
	Parameters: 2
	Flags: Linked
*/
function function_508749d7(v_position, player)
{
	player endon(#"disconnect");
	if(!isdefined(level.a_s_planting_spots))
	{
		return;
	}
	n_range_sq = player function_a1fce678();
	foreach(s_planting_spot in level.a_s_planting_spots)
	{
		if(!(isdefined(s_planting_spot.var_75c7a97e) && s_planting_spot.var_75c7a97e))
		{
			continue;
		}
		if(function_8734b840(s_planting_spot.origin, v_position, n_range_sq))
		{
			s_planting_spot notify(#"hash_8dfde2c8");
			player notify(#"player_hit_plant_with_mirg2000");
		}
	}
}

/*
	Name: function_570d6f32
	Namespace: mirg2000
	Checksum: 0x3E6ABA17
	Offset: 0x1F30
	Size: 0x132
	Parameters: 2
	Flags: Linked
*/
function function_570d6f32(v_position, player)
{
	player endon(#"disconnect");
	if(!isdefined(level.var_d3b40681))
	{
		return;
	}
	n_range_sq = player function_a1fce678();
	foreach(trigger in level.var_d3b40681)
	{
		if(!(isdefined(trigger.var_f83345c7) && trigger.var_f83345c7))
		{
			continue;
		}
		if(function_8734b840(trigger.origin, v_position, n_range_sq))
		{
			trigger thread function_4a1cb794(player);
		}
	}
}

/*
	Name: function_4a1cb794
	Namespace: mirg2000
	Checksum: 0xFA36C998
	Offset: 0x2070
	Size: 0x294
	Parameters: 1
	Flags: Linked
*/
function function_4a1cb794(player)
{
	self endon(#"death");
	player endon(#"disconnect");
	if(player hasweapon(level.var_a4052592))
	{
		var_6d5757ae = 1;
	}
	else
	{
		var_6d5757ae = 0;
	}
	if(isdefined(self.var_1c12769f))
	{
		v_origin = self.var_1c12769f.origin;
		v_angles = self.var_1c12769f.angles;
		switch(self.var_1c12769f.script_string)
		{
			case "spider_web_particle_bgb":
			{
				if(var_6d5757ae)
				{
					self thread fx::play("bgb_web_ww_dissolve_ug", v_origin, v_angles);
				}
				else
				{
					self thread fx::play("bgb_web_ww_dissolve", v_origin, v_angles);
				}
				break;
			}
			case "spider_web_particle_perk_machine":
			{
				if(var_6d5757ae)
				{
					self thread fx::play("perk_web_ww_dissolve_ug", v_origin, v_angles);
				}
				else
				{
					self thread fx::play("perk_web_ww_dissolve", v_origin, v_angles);
				}
				break;
			}
			case "spider_web_particle_doorbuy":
			{
				if(var_6d5757ae)
				{
					self thread fx::play("doorbuy_web_ww_dissolve_ug", v_origin, v_angles);
				}
				else
				{
					self thread fx::play("doorbuy_web_ww_dissolve", v_origin, v_angles);
				}
				break;
			}
			default:
			{
				if(var_6d5757ae)
				{
					self thread fx::play("bgb_web_ww_dissolve_ug", v_origin, v_angles);
				}
				else
				{
					self thread fx::play("bgb_web_ww_dissolve", v_origin, v_angles);
				}
				break;
			}
		}
	}
	if(isdefined(self.var_f83345c7) && self.var_f83345c7)
	{
		self notify(#"web_torn");
		player.var_5c159c87 = 1;
		player zm_ai_spiders::function_20915a1a();
	}
}

/*
	Name: function_79504f13
	Namespace: mirg2000
	Checksum: 0x9DF526A8
	Offset: 0x2310
	Size: 0x104
	Parameters: 2
	Flags: Linked
*/
function function_79504f13(ai_zombie, v_pos)
{
	self endon(#"disconnect");
	ai_zombie endon(#"death");
	if(self hasweapon(level.var_a4052592))
	{
		e_grenade = magicbullet(level.var_a4052592, v_pos, ai_zombie getcentroid());
	}
	else
	{
		e_grenade = magicbullet(level.var_5e75629a, v_pos, ai_zombie getcentroid());
	}
	if(isdefined(e_grenade))
	{
		e_grenade thread function_74a68c49(self, 1);
		wait(0.5);
		self thread function_d150c3fe(ai_zombie);
	}
}

/*
	Name: function_9844cc8a
	Namespace: mirg2000
	Checksum: 0x614564BF
	Offset: 0x2420
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function function_9844cc8a(v_position, player)
{
	player endon(#"disconnect");
	if(!isdefined(level.var_49c3bf90))
	{
		return;
	}
	if(level flag::exists("spider_queen_weak_spot_exposed") && level flag::exists("spider_queen_dead"))
	{
		if(level flag::get("spider_queen_dead"))
		{
			return;
		}
		n_range_sq = player function_a1fce678();
		if(level flag::get("spider_queen_weak_spot_exposed"))
		{
			if(function_8734b840(level.var_49c3bf90.origin, v_position, n_range_sq))
			{
				level.var_49c3bf90 dodamage(10, level.var_49c3bf90.origin, player, player);
			}
		}
	}
}

/*
	Name: function_e0d7bd91
	Namespace: mirg2000
	Checksum: 0x84E4FF88
	Offset: 0x2558
	Size: 0x294
	Parameters: 1
	Flags: Linked
*/
function function_e0d7bd91(v_position)
{
	self endon(#"disconnect");
	a_ai_zombies = getaiteamarray(level.zombie_team);
	if(!a_ai_zombies.size)
	{
		return;
	}
	n_range_sq = self function_a1fce678();
	var_bd236d05 = 0;
	var_75e02ae0 = arraygetclosest(v_position, a_ai_zombies);
	if(function_8734b840(var_75e02ae0.origin, v_position, n_range_sq) && (!(isdefined(var_75e02ae0.var_3f6ea790) && var_75e02ae0.var_3f6ea790)))
	{
		self thread function_d150c3fe(var_75e02ae0);
		arrayremovevalue(a_ai_zombies, var_75e02ae0);
		var_bd236d05++;
	}
	foreach(ai_zombie in a_ai_zombies)
	{
		if(isalive(ai_zombie) && !isdefined(ai_zombie.var_3f6ea790))
		{
			if(function_8734b840(ai_zombie.origin, v_position, n_range_sq) && var_bd236d05 < 1)
			{
				self thread function_d150c3fe(ai_zombie);
				if(!(isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0))
				{
					var_bd236d05++;
				}
				if(!(isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0) && (!(isdefined(ai_zombie.b_is_spider) && ai_zombie.b_is_spider)))
				{
					wait(1);
				}
			}
		}
	}
}

/*
	Name: function_d150c3fe
	Namespace: mirg2000
	Checksum: 0xF2C76906
	Offset: 0x27F8
	Size: 0x64C
	Parameters: 1
	Flags: Linked
*/
function function_d150c3fe(ai_zombie)
{
	self endon(#"disconnect");
	ai_zombie endon(#"death");
	if(isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0)
	{
		if(!(isdefined(ai_zombie.var_365c1d50) && ai_zombie.var_365c1d50))
		{
			foreach(var_92b2f038 in ai_zombie.thrasherspores)
			{
				if(var_92b2f038.health > 0)
				{
					var_278bf215 = var_92b2f038;
					break;
				}
			}
			if(isdefined(ai_zombie.maxhealth) && isdefined(var_278bf215))
			{
				switch(self.chargeshotlevel)
				{
					case 1:
					{
						ai_zombie dodamage(var_278bf215.maxhealth / 2, ai_zombie gettagorigin(var_278bf215.tag), self);
						ai_zombie thread function_dadca53(1.5);
						break;
					}
					case 2:
					{
						ai_zombie dodamage(var_278bf215.maxhealth / 2, ai_zombie gettagorigin(var_278bf215.tag), self);
						ai_zombie thread function_dadca53(0.75);
						break;
					}
					case 3:
					{
						ai_zombie dodamage(var_278bf215.maxhealth / 2, ai_zombie gettagorigin(var_278bf215.tag), self);
						ai_zombie thread function_dadca53(0.5);
						break;
					}
					default:
					{
						ai_zombie dodamage(var_278bf215.maxhealth / 2, ai_zombie gettagorigin(var_278bf215.tag), self);
						ai_zombie thread function_dadca53(1.5);
						return;
					}
				}
			}
		}
		return;
	}
	if(ai_zombie.var_3f6ea790 !== 1 && (!(isdefined(ai_zombie.var_20b8c74a) && ai_zombie.var_20b8c74a)) && (!(isdefined(ai_zombie.var_34d00e7) && ai_zombie.var_34d00e7)) && (!(isdefined(ai_zombie.thrasherconsumed) && ai_zombie.thrasherconsumed)))
	{
		ai_zombie ai::set_ignoreall(1);
		ai_zombie.var_3f6ea790 = 1;
		ai_zombie notify(#"hash_87952665");
		if(!(isdefined(ai_zombie.b_is_spider) && ai_zombie.b_is_spider) && (!(isdefined(ai_zombie.var_2f846873) && ai_zombie.var_2f846873)))
		{
			if(zm_utility::is_player_valid(self))
			{
				self notify(#"player_killed_zombie_with_mirg2000");
			}
			ai_zombie.ignore_game_over_death = 1;
			if(isdefined(ai_zombie.missinglegs) && ai_zombie.missinglegs)
			{
				ai_zombie function_b7e68127(1);
			}
			else
			{
				ai_zombie function_b7e68127(0);
			}
			self.var_72053d6e++;
			if(self.var_72053d6e >= 10)
			{
				self notify(#"hash_cf72c127");
			}
			self thread function_3bc42e24(ai_zombie);
		}
		if(isdefined(ai_zombie.b_is_spider) && ai_zombie.b_is_spider)
		{
			if(self hasweapon(level.var_a4052592))
			{
				ai_zombie clientfield::set("mirg2000_spider_death_fx", 2);
			}
			else
			{
				ai_zombie clientfield::set("mirg2000_spider_death_fx", 1);
			}
		}
		if(!(isdefined(ai_zombie.b_is_spider) && ai_zombie.b_is_spider))
		{
			level thread zm_spawner::zombie_death_points(ai_zombie.origin, "MOD_EXPLOSIVE", "head", self, ai_zombie);
		}
		ai_zombie thread zombie_utility::zombie_gut_explosion();
		ai_zombie dodamage(ai_zombie.health, ai_zombie.origin, self);
	}
}

/*
	Name: function_3bc42e24
	Namespace: mirg2000
	Checksum: 0x4B657D12
	Offset: 0x2E50
	Size: 0x192
	Parameters: 1
	Flags: Linked
*/
function function_3bc42e24(var_8b84dc1b)
{
	a_ai_zombies = getaiteamarray(level.zombie_team);
	var_5074f697 = var_8b84dc1b getcentroid();
	n_range_sq = self function_a1fce678();
	arrayremovevalue(a_ai_zombies, var_8b84dc1b);
	foreach(var_fd970238 in a_ai_zombies)
	{
		if(isalive(var_fd970238) && (!(isdefined(var_fd970238.var_3f6ea790) && var_fd970238.var_3f6ea790)) && function_8734b840(var_fd970238.origin, var_5074f697, n_range_sq))
		{
			var_fd970238 function_794992bd(self, var_5074f697);
			util::wait_network_frame();
		}
	}
}

/*
	Name: function_b7e68127
	Namespace: mirg2000
	Checksum: 0x94530D4F
	Offset: 0x2FF0
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function function_b7e68127(var_7364b0dd)
{
	self endon(#"death");
	if(!isdefined(level.var_d290a02b))
	{
		level.var_d290a02b = 0;
	}
	if(!isdefined(level.var_7a9b882a))
	{
		level.var_7a9b882a = 0;
	}
	self.marked_for_death = 1;
	if(var_7364b0dd)
	{
		level.var_d290a02b++;
		if(level.var_d290a02b > 2)
		{
			level.var_d290a02b = 1;
		}
		if(isalive(self) && !self isragdoll())
		{
			self scene::play(("p7_fxanim_zm_island_mirg_trap_crawl_" + level.var_d290a02b) + "_bundle", self);
		}
	}
	else
	{
		level.var_7a9b882a++;
		if(level.var_7a9b882a > 5)
		{
			level.var_7a9b882a = 1;
		}
		if(isalive(self) && !self isragdoll())
		{
			self scene::play(("p7_fxanim_zm_island_mirg_trap_" + level.var_7a9b882a) + "_bundle", self);
		}
	}
}

/*
	Name: function_dadca53
	Namespace: mirg2000
	Checksum: 0xD133573A
	Offset: 0x3170
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function function_dadca53(var_2b49e04f = 1)
{
	self endon(#"death");
	self.var_365c1d50 = 1;
	wait(var_2b49e04f);
	self.var_365c1d50 = 0;
}

/*
	Name: function_24d57358
	Namespace: mirg2000
	Checksum: 0x4A551A9F
	Offset: 0x31C0
	Size: 0xC4
	Parameters: 15
	Flags: None
*/
function function_24d57358(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(isdefined(weapon))
	{
		if(function_b926526f(weapon) && (!(isdefined(self.var_91bc5bf2) && self.var_91bc5bf2)))
		{
			idamage = 0;
		}
	}
	return idamage;
}

