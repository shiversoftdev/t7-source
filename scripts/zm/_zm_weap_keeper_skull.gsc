// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_annihilator;
#using scripts\zm\_zm_weapons;

#using_animtree("generic");

#namespace keeper_skull;

/*
	Name: __init__sytem__
	Namespace: keeper_skull
	Checksum: 0x6A13479B
	Offset: 0x598
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("keeper_skull", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: keeper_skull
	Checksum: 0x1436F9D2
	Offset: 0x5E0
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "skull_beam_fx", 9000, 2, "int");
	clientfield::register("toplayer", "skull_torch_fx", 9000, 2, "int");
	clientfield::register("allplayers", "skull_beam_3p_fx", 9000, 2, "int");
	clientfield::register("allplayers", "skull_torch_3p_fx", 9000, 2, "int");
	clientfield::register("allplayers", "skull_emissive", 9000, 1, "int");
	clientfield::register("actor", "death_ray_shock_eye_fx", 9000, 1, "int");
	clientfield::register("actor", "entranced", 9000, 1, "int");
	clientfield::register("actor", "thrasher_skull_fire", 9000, 1, "int");
	clientfield::register("actor", "zombie_explode", 9000, 1, "int");
	level.var_c003f5b = getweapon("skull_gun");
	level.var_1f1a653b = getweapon("skull_gun_1");
	zm_hero_weapon::register_hero_weapon("skull_gun");
	zm_hero_weapon::register_hero_weapon("skull_gun_1");
}

/*
	Name: __main__
	Namespace: keeper_skull
	Checksum: 0x2FEFDB02
	Offset: 0x810
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	callback::on_connect(&function_3028b9ff);
}

/*
	Name: function_3028b9ff
	Namespace: keeper_skull
	Checksum: 0xA3F1B38E
	Offset: 0x840
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function function_3028b9ff()
{
	self flag::init("has_skull");
	self.var_118ab24e = 100;
	self.var_e1f8edd6 = 0;
	self.var_141d363e = 0;
	self.var_9adfaccf = 0;
	self thread function_de235a27();
	self thread function_e703c25f();
	self thread watch_weapon_change();
	self thread function_eadaeb18();
	self thread function_6a46a0e0();
	self thread function_2dda41f5();
	self thread function_6b7bd037();
	self thread watch_player_death();
}

/*
	Name: watch_player_death
	Namespace: keeper_skull
	Checksum: 0x604AEE1C
	Offset: 0x960
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function watch_player_death()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"bled_out");
		if(self flag::get("has_skull"))
		{
			self flag::clear("has_skull");
		}
	}
}

/*
	Name: function_6b7bd037
	Namespace: keeper_skull
	Checksum: 0xDB6173D4
	Offset: 0x9D0
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function function_6b7bd037()
{
	self endon(#"disconnect");
	while(true)
	{
		if(self hasweapon(level.var_c003f5b))
		{
			self.var_118ab24e = self gadgetpowerget(0);
			if(self.var_118ab24e == 100)
			{
				self setweaponammoclip(level.var_c003f5b, 100);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_2dda41f5
	Namespace: keeper_skull
	Checksum: 0x5088D8A1
	Offset: 0xA68
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function function_2dda41f5()
{
	self endon(#"disconnect");
	if(isdefined(level.var_615d751))
	{
		self flag::wait_till("has_skull");
	}
	var_18e42304 = 1;
	while(true)
	{
		var_e18bd995 = self gadgetpowerget(0);
		if(var_e18bd995 == 100 && var_18e42304 == 0)
		{
			if(!self laststand::player_is_in_laststand())
			{
				self notify(#"skull_weapon_fully_charged");
				var_18e42304 = 1;
				wait(30);
			}
		}
		else if(var_e18bd995 < 100)
		{
			var_18e42304 = 0;
		}
		wait(1);
	}
}

/*
	Name: function_de235a27
	Namespace: keeper_skull
	Checksum: 0x530B3081
	Offset: 0xB60
	Size: 0x1F8
	Parameters: 0
	Flags: Linked
*/
function function_de235a27()
{
	self endon(#"disconnect");
	if(isdefined(level.var_615d751))
	{
		self flag::wait_till("has_skull");
	}
	while(true)
	{
		self util::waittill_attack_button_pressed();
		if(self function_97d08b97())
		{
			if(!self.var_e1f8edd6 && !self ismeleeing())
			{
				self clientfield::set_to_player("skull_beam_fx", 1);
				self clientfield::set("skull_beam_3p_fx", 1);
				self function_123162a2();
				while(self util::attack_button_held() && self function_97d08b97() && !self.var_e1f8edd6 && self.var_118ab24e)
				{
					if(!self.var_9adfaccf)
					{
						self thread function_23e997f4();
					}
					self function_123162a2();
					wait(0.05);
				}
				self.var_9adfaccf = 0;
				self clientfield::set_to_player("skull_beam_fx", 0);
				self clientfield::set("skull_beam_3p_fx", 0);
			}
		}
		wait(0.05);
		self thread function_e00bc70a();
	}
}

/*
	Name: function_23e997f4
	Namespace: keeper_skull
	Checksum: 0x2FF4797D
	Offset: 0xD60
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_23e997f4()
{
	self endon(#"disconnect");
	self.var_9adfaccf = 1;
	wait(0.1);
	if(self util::attack_button_held() && !self.var_e1f8edd6)
	{
		self clientfield::set_to_player("skull_beam_fx", 2);
		self clientfield::set("skull_beam_3p_fx", 2);
	}
}

/*
	Name: function_123162a2
	Namespace: keeper_skull
	Checksum: 0x3C5F3C21
	Offset: 0xDF8
	Size: 0x17E
	Parameters: 0
	Flags: Linked
*/
function function_123162a2()
{
	a_zombies = getaiteamarray(level.zombie_team);
	a_targets = util::get_array_of_closest(self.origin, a_zombies, undefined, 8, 500);
	for(i = 0; i < a_targets.size; i++)
	{
		if(isalive(a_targets[i]))
		{
			if(a_targets[i].var_20b8c74a !== 1 && (!(isdefined(a_targets[i].var_3f6ea790) && a_targets[i].var_3f6ea790)) && self function_fb77a973(a_targets[i]) && (!(isdefined(a_targets[i].thrasherconsumed) && a_targets[i].thrasherconsumed)))
			{
				a_targets[i].var_20b8c74a = 1;
				self thread function_32afe89a(a_targets[i]);
				wait(0.05);
			}
		}
	}
}

/*
	Name: function_f51dbd0a
	Namespace: keeper_skull
	Checksum: 0xE31EFD8B
	Offset: 0xF80
	Size: 0x234
	Parameters: 0
	Flags: Linked
*/
function function_f51dbd0a()
{
	self notify(#"hash_f51dbd0a");
	self endon(#"hash_f51dbd0a");
	self endon(#"death");
	if(isdefined(self.isinmantleaction) && self.isinmantleaction)
	{
		var_553c631c = 1;
	}
	wait(0.05);
	self waittill(#"hash_2766d719");
	if(!(isdefined(var_553c631c) && var_553c631c) && !self zm::in_enabled_playable_area())
	{
		if(isdefined(self.chunk) && isdefined(self.first_node.zbarrier))
		{
			if(self.first_node.zbarrier getzbarrierpiecestate(self.chunk) == "opening")
			{
				self.first_node.zbarrier setzbarrierpiecestate(self.chunk, "open");
			}
			else
			{
				self.first_node.zbarrier setzbarrierpiecestate(self.chunk, "closed");
			}
		}
	}
	else if(isdefined(var_553c631c) && var_553c631c && isdefined(self.first_node) && isdefined(self.saved_attacking_spot_index))
	{
		forwardvec = anglestoforward(self.first_node.angles);
		var_9f8b01da = self.first_node.attack_spots[self.saved_attacking_spot_index] + (forwardvec * 75);
		var_9f8b01da = getclosestpointonnavmesh(var_9f8b01da);
		self forceteleport(var_9f8b01da, self getangles());
	}
}

/*
	Name: function_32afe89a
	Namespace: keeper_skull
	Checksum: 0xC1314E25
	Offset: 0x11C0
	Size: 0x62C
	Parameters: 1
	Flags: Linked
*/
function function_32afe89a(ai_zombie)
{
	self endon(#"disconnect");
	ai_zombie endon(#"death");
	if(ai_zombie.archetype === "zombie" || (isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0))
	{
		ai_zombie thread zombie_utility::zombie_eye_glow_stop();
		ai_zombie clientfield::set("death_ray_shock_eye_fx", 1);
		if(isalive(ai_zombie) && (!(isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0)))
		{
			if(ai_zombie isplayinganimscripted())
			{
				ai_zombie stopanimscripted(0.3);
				wait(0.1);
			}
			ai_zombie thread scene::play("cin_zm_dlc1_zombie_dth_deathray_04", ai_zombie);
			ai_zombie thread function_f51dbd0a();
		}
	}
	var_9ae6d5f2 = 0;
	while(self util::attack_button_held() && self function_97d08b97() && !self.var_e1f8edd6 && self.var_118ab24e)
	{
		if(isdefined(ai_zombie.b_is_spider) && ai_zombie.b_is_spider)
		{
			self function_4aedb20b(1);
			ai_zombie dodamage(ai_zombie.health, ai_zombie.origin, self);
			break;
		}
		ai_zombie.var_20b8c74a = 1;
		if(ai_zombie.archetype === "zombie" || (isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0))
		{
			ai_zombie thread zm_audio::zmbaivox_playvox(ai_zombie, "skull_scream", 1, 11);
			wait(1);
		}
		else
		{
			wait(3);
		}
		if(self util::attack_button_held() && self function_97d08b97() && !self.var_e1f8edd6 && self.var_118ab24e)
		{
			if(ai_zombie.archetype === "zombie")
			{
				ai_zombie clientfield::set("death_ray_shock_eye_fx", 0);
				self notify(#"skullweapon_killed_zombie");
				ai_zombie zombie_utility::zombie_head_gib(self);
				ai_zombie playsound("evt_zombie_skull_breathe");
			}
			wait(0.05);
			if(isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0)
			{
				if(var_9ae6d5f2 == 0)
				{
					ai_zombie clientfield::set("thrasher_skull_fire", 1);
				}
				if(var_9ae6d5f2 < ai_zombie.thrasherspores.size)
				{
					if(!ai_zombie.thrasherisberserk)
					{
						ai_zombie.thrasherragecount = 0;
					}
					var_9d06d0ea = ai_zombie.thrasherspores[var_9ae6d5f2];
					self function_4aedb20b(3);
					ai_zombie dodamage(var_9d06d0ea.health, ai_zombie gettagorigin(var_9d06d0ea.tag), self);
					var_9ae6d5f2++;
					ai_zombie.thrasherragecount = 0;
				}
			}
			else
			{
				self function_4aedb20b(2);
				ai_zombie thread function_e31d6184();
				ai_zombie clientfield::set("zombie_explode", 1);
				ai_zombie dodamage(ai_zombie.health, ai_zombie.origin, self);
			}
		}
	}
	ai_zombie.var_20b8c74a = 0;
	if(ai_zombie.archetype === "zombie" || (isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0))
	{
		ai_zombie notify(#"hash_2766d719");
		ai_zombie thread scene::stop("cin_zm_dlc1_zombie_dth_deathray_04");
		ai_zombie thread zombie_utility::zombie_eye_glow();
		ai_zombie clientfield::set("death_ray_shock_eye_fx", 0);
		if(isdefined(ai_zombie.var_61f7b3a0) && ai_zombie.var_61f7b3a0)
		{
			ai_zombie clientfield::set("thrasher_skull_fire", 0);
		}
	}
}

/*
	Name: function_e31d6184
	Namespace: keeper_skull
	Checksum: 0x2AE805A3
	Offset: 0x17F8
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_e31d6184()
{
	wait(0.05);
	if(isdefined(self))
	{
		if(math::cointoss())
		{
			gibserverutils::gibhead(self);
		}
		if(math::cointoss())
		{
			gibserverutils::gibleftarm(self);
		}
		if(math::cointoss())
		{
			gibserverutils::gibrightarm(self);
		}
		if(math::cointoss())
		{
			gibserverutils::giblegs(self);
		}
		self zombie_utility::zombie_gut_explosion();
	}
}

/*
	Name: function_e703c25f
	Namespace: keeper_skull
	Checksum: 0xEE4EC7E2
	Offset: 0x18D0
	Size: 0x450
	Parameters: 0
	Flags: Linked
*/
function function_e703c25f()
{
	self endon(#"disconnect");
	if(isdefined(level.var_615d751))
	{
		self flag::wait_till("has_skull");
	}
	while(true)
	{
		if(self util::ads_button_held())
		{
			if(!self function_97d08b97())
			{
				while(self adsbuttonpressed())
				{
					wait(0.05);
				}
			}
			else
			{
				if(self.var_118ab24e && !self attackbuttonpressed() && !self.var_e1f8edd6 && !self ismeleeing())
				{
					if(!self.var_141d363e)
					{
						self.var_141d363e = 1;
						self clientfield::set_to_player("skull_torch_fx", 1);
						self clientfield::set("skull_torch_3p_fx", 1);
						self clientfield::set("skull_emissive", 1);
						self thread function_993fa661();
					}
					a_zombies = getaiteamarray(level.zombie_team);
					a_targets = util::get_array_of_closest(self.origin, a_zombies, undefined, undefined, 500);
					foreach(ai_zombie in a_targets)
					{
						if(ai_zombie.var_9b59d7f8 !== 1 && self function_5fa274c1(ai_zombie) && ai_zombie.completed_emerging_into_playable_area === 1 && (!(isdefined(ai_zombie.thrasherconsumed) && ai_zombie.thrasherconsumed)) && (!(isdefined(ai_zombie.var_3f6ea790) && ai_zombie.var_3f6ea790)))
						{
							self thread function_c2e953fb(ai_zombie);
							self notify(#"skullweapon_mesmerized_zombie");
						}
					}
					wait(0.05);
				}
				else
				{
					self.var_141d363e = 0;
					self clientfield::set_to_player("skull_torch_fx", 0);
					self clientfield::set("skull_torch_3p_fx", 0);
					self clientfield::set("skull_emissive", 0);
				}
			}
		}
		else
		{
			self.var_141d363e = 0;
			if(self clientfield::get_to_player("skull_torch_fx"))
			{
				self clientfield::set_to_player("skull_torch_fx", 0);
			}
			if(self clientfield::get("skull_torch_3p_fx"))
			{
				self clientfield::set("skull_torch_3p_fx", 0);
			}
			if(self clientfield::get("skull_emissive"))
			{
				self clientfield::set("skull_emissive", 0);
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_993fa661
	Namespace: keeper_skull
	Checksum: 0x55FECCA4
	Offset: 0x1D28
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_993fa661()
{
	self endon(#"disconnect");
	self endon(#"weapon_change");
	wait(0.1);
	if(self util::ads_button_held() && !self.var_e1f8edd6)
	{
		self clientfield::set_to_player("skull_torch_fx", 2);
		self clientfield::set("skull_torch_3p_fx", 2);
	}
}

/*
	Name: function_c2e953fb
	Namespace: keeper_skull
	Checksum: 0xC74EE972
	Offset: 0x1DC0
	Size: 0x33C
	Parameters: 1
	Flags: Linked
*/
function function_c2e953fb(ai_zombie)
{
	self endon(#"disconnect");
	ai_zombie endon(#"death");
	while(self util::ads_button_held() && self.var_118ab24e && self function_5fa274c1(ai_zombie) && !self.var_9adfaccf && self function_97d08b97())
	{
		if(ai_zombie.var_9b59d7f8 !== 1)
		{
			ai_zombie.var_9b59d7f8 = 1;
			if(!(isdefined(ai_zombie.b_is_spider) && ai_zombie.b_is_spider))
			{
				ai_zombie thread zombie_utility::zombie_eye_glow_stop();
				ai_zombie clientfield::set("entranced", 1);
				ai_zombie thread function_3fca87eb();
			}
			else
			{
				if(isdefined(ai_zombie.var_b4e06d32) && ai_zombie.var_b4e06d32)
				{
					ai_zombie clientfield::set("spider_glow_fx", 1);
					ai_zombie flag::set("spider_from_mars_identified");
					if(isdefined(level.var_5f1b87ca))
					{
						self [[level.var_5f1b87ca]]();
					}
				}
				else
				{
					ai_zombie setgoal(ai_zombie.origin);
					ai_zombie ai::set_ignoreall(1);
				}
			}
		}
		wait(0.05);
	}
	ai_zombie.var_9b59d7f8 = 0;
	ai_zombie ai::set_ignoreall(0);
	if(!(isdefined(ai_zombie.b_is_spider) && ai_zombie.b_is_spider))
	{
		ai_zombie thread zombie_utility::zombie_eye_glow();
		ai_zombie clientfield::set("entranced", 0);
		ai_zombie notify(#"hash_11c32d95");
		if(ai_zombie isplayinganimscripted())
		{
			ai_zombie stopanimscripted(0.3);
		}
	}
	else if(isdefined(ai_zombie.var_b4e06d32) && ai_zombie.var_b4e06d32 && (!(isdefined(ai_zombie.var_f7522faa) && ai_zombie.var_f7522faa)))
	{
		ai_zombie clientfield::set("spider_glow_fx", 0);
	}
}

/*
	Name: function_3fca87eb
	Namespace: keeper_skull
	Checksum: 0x491CBC43
	Offset: 0x2108
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function function_3fca87eb()
{
	self endon(#"death");
	self endon(#"hash_11c32d95");
	n_index = randomintrange(1, 7);
	while(true)
	{
		self thread animation::play("ai_zm_dlc2_zombie_pacified_by_skullgun_" + n_index, self);
		wait(getanimlength("ai_zm_dlc2_zombie_pacified_by_skullgun_" + n_index));
	}
}

/*
	Name: function_5fa274c1
	Namespace: keeper_skull
	Checksum: 0xF9E2B8EB
	Offset: 0x21A0
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function function_5fa274c1(ai_zombie)
{
	if(distance2dsquared(self.origin, ai_zombie.origin) <= 250000)
	{
		return true;
	}
	return false;
}

/*
	Name: function_fb77a973
	Namespace: keeper_skull
	Checksum: 0xB8A93A
	Offset: 0x21F0
	Size: 0x86
	Parameters: 1
	Flags: Linked
*/
function function_fb77a973(ai_zombie)
{
	ai_zombie endon(#"death");
	if(self util::is_player_looking_at(ai_zombie.origin, 0.85, 0))
	{
		return true;
	}
	if(self util::is_player_looking_at(ai_zombie getcentroid(), 0.85, 0))
	{
		return true;
	}
	return false;
}

/*
	Name: function_3f3f64e9
	Namespace: keeper_skull
	Checksum: 0xCA8620CF
	Offset: 0x2280
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function function_3f3f64e9(e_prop)
{
	if(self util::is_player_looking_at(e_prop.origin, 0.85, 0))
	{
		return true;
	}
	if(self util::is_player_looking_at(e_prop getcentroid(), 0.85, 0))
	{
		return true;
	}
	return false;
}

/*
	Name: function_6a46a0e0
	Namespace: keeper_skull
	Checksum: 0xFD60FB63
	Offset: 0x2300
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function function_6a46a0e0()
{
	self endon(#"disconnect");
	while(true)
	{
		if(!self function_97d08b97())
		{
			self waittill(#"weapon_change");
			if(self.sessionstate != "spectator")
			{
				w_current = self getcurrentweapon();
				if(isdefined(w_current) && zm_utility::is_hero_weapon(w_current))
				{
					self.var_230f31ae = 1;
					self thread function_79e34741();
					wait(1);
				}
			}
		}
		if(self function_97d08b97() && (isdefined(self.var_230f31ae) && self.var_230f31ae))
		{
			if(self.sessionstate != "spectator")
			{
				self setweaponammoclip(level.var_c003f5b, int(self.var_118ab24e));
				if(self util::ads_button_held() || self util::attack_button_held())
				{
					if(self.var_118ab24e > 0)
					{
						self gadgetpowerset(0, self.var_118ab24e - 0.15);
					}
					else
					{
						self gadgetpowerset(0, 0);
						self setweaponammoclip(level.var_c003f5b, 0);
						self zm_weapons::switch_back_primary_weapon(undefined, 1);
						self.var_230f31ae = 0;
					}
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_79e34741
	Namespace: keeper_skull
	Checksum: 0xD706CA31
	Offset: 0x2518
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_79e34741()
{
	self endon(#"disconnect");
	while(true)
	{
		if(self weaponswitchbuttonpressed())
		{
			self.var_230f31ae = 0;
			self gadgetpowerset(0, self.var_118ab24e - 2);
			self setweaponammoclip(level.var_c003f5b, 0);
			self gadgetdeactivate(0, level.var_c003f5b);
			break;
		}
		wait(0.05);
	}
}

/*
	Name: function_97d08b97
	Namespace: keeper_skull
	Checksum: 0xE7665754
	Offset: 0x25D0
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function function_97d08b97()
{
	w_current = self getcurrentweapon();
	if(w_current == level.var_c003f5b || w_current == level.var_1f1a653b)
	{
		return true;
	}
	return false;
}

/*
	Name: watch_weapon_change
	Namespace: keeper_skull
	Checksum: 0x6841EDB4
	Offset: 0x2628
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function watch_weapon_change()
{
	self endon(#"disconnect");
	while(true)
	{
		if(self weaponswitchbuttonpressed() || self.var_118ab24e < 1)
		{
			self function_e00bc70a();
		}
		wait(0.05);
	}
}

/*
	Name: function_eadaeb18
	Namespace: keeper_skull
	Checksum: 0x97AACB83
	Offset: 0x2690
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_eadaeb18()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"weapon_change_complete");
		self function_e00bc70a();
	}
}

/*
	Name: function_e00bc70a
	Namespace: keeper_skull
	Checksum: 0x77462E92
	Offset: 0x26D8
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_e00bc70a()
{
	if(self clientfield::get_to_player("skull_beam_fx"))
	{
		self clientfield::set_to_player("skull_beam_fx", 0);
	}
	else if(self clientfield::get_to_player("skull_torch_fx"))
	{
		self clientfield::set_to_player("skull_torch_fx", 0);
		self clientfield::set("skull_torch_3p_fx", 0);
		self clientfield::set("skull_emissive", 0);
	}
	if(self clientfield::get("skull_beam_3p_fx"))
	{
		self clientfield::set("skull_beam_3p_fx", 0);
	}
	else if(self clientfield::get("skull_torch_3p_fx"))
	{
		self clientfield::set("skull_torch_3p_fx", 0);
	}
}

/*
	Name: function_4aedb20b
	Namespace: keeper_skull
	Checksum: 0x2BC66AD9
	Offset: 0x2828
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function function_4aedb20b(var_4ed57dca)
{
	if(self.var_118ab24e >= var_4ed57dca)
	{
		self gadgetpowerset(0, self.var_118ab24e - var_4ed57dca);
	}
	else
	{
		self gadgetpowerset(0, 0);
		self.var_230f31ae = 0;
	}
}

