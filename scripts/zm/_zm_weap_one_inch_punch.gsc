// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace _zm_weap_one_inch_punch;

/*
	Name: init
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x9C253E4A
	Offset: 0x528
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("allplayers", "oneinchpunch_impact", 21000, 1, "int");
	clientfield::register("actor", "oneinchpunch_physics_launchragdoll", 21000, 1, "int");
	level.var_653c9585 = getweapon("one_inch_punch");
	level.var_4f241554 = getweapon("one_inch_punch_fire");
	level.var_e27d2514 = getweapon("one_inch_punch_air");
	level.var_590c486e = getweapon("one_inch_punch_lightning");
	level.var_af96dd85 = getweapon("one_inch_punch_ice");
	level.var_75ef78a0 = getweapon("one_inch_punch_upgraded");
	level.var_9d7b544c = getweapon("zombie_one_inch_punch_flourish");
	level.var_ee516197 = getweapon("zombie_one_inch_punch_upgrade_flourish");
	level._effect["oneinch_impact"] = "dlc5/tomb/fx_one_inch_punch_impact";
	level._effect["punch_knockdown_ground"] = "dlc5/zmb_weapon/fx_thundergun_knockback_ground";
	callback::on_connect(&one_inch_punch_take_think);
}

/*
	Name: widows_wine_knife_override
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0xCF722742
	Offset: 0x6F0
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function widows_wine_knife_override()
{
	if(!issubstr(self.w_widows_wine_prev_knife.name, "one_inch_punch"))
	{
		self takeweapon(self.w_widows_wine_prev_knife);
		if(self.w_widows_wine_prev_knife.name == "bowie_knife")
		{
			self giveweapon(level.w_widows_wine_bowie_knife);
			self zm_utility::set_player_melee_weapon(level.w_widows_wine_bowie_knife);
		}
		else
		{
			self giveweapon(level.w_widows_wine_knife);
			self zm_utility::set_player_melee_weapon(level.w_widows_wine_knife);
		}
	}
}

/*
	Name: one_inch_punch_melee_attack
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x47F9AF6A
	Offset: 0x7E0
	Size: 0x4BC
	Parameters: 0
	Flags: Linked
*/
function one_inch_punch_melee_attack()
{
	self endon(#"disconnect");
	self endon(#"stop_one_inch_punch_attack");
	if(!(isdefined(self.one_inch_punch_flag_has_been_init) && self.one_inch_punch_flag_has_been_init))
	{
		self flag::init("melee_punch_cooldown");
	}
	self.one_inch_punch_flag_has_been_init = 1;
	self.widows_wine_knife_override = &widows_wine_knife_override;
	current_melee_weapon = self zm_utility::get_player_melee_weapon();
	self takeweapon(current_melee_weapon);
	if(isdefined(self.b_punch_upgraded) && self.b_punch_upgraded)
	{
		w_weapon = self getcurrentweapon();
		self zm_utility::disable_player_move_states(1);
		self giveweapon(level.var_9d7b544c);
		self switchtoweapon(level.var_9d7b544c);
		self util::waittill_any("player_downed", "weapon_change_complete");
		self switchtoweapon(w_weapon);
		self zm_utility::enable_player_move_states();
		self takeweapon(level.var_9d7b544c);
		if(self.str_punch_element == "air")
		{
			self giveweapon(level.var_e27d2514);
			self zm_utility::set_player_melee_weapon(level.var_e27d2514);
		}
		else
		{
			if(self.str_punch_element == "fire")
			{
				self giveweapon(level.var_4f241554);
				self zm_utility::set_player_melee_weapon(level.var_4f241554);
			}
			else
			{
				if(self.str_punch_element == "ice")
				{
					self giveweapon(level.var_af96dd85);
					self zm_utility::set_player_melee_weapon(level.var_af96dd85);
				}
				else
				{
					if(self.str_punch_element == "lightning")
					{
						self giveweapon(level.var_590c486e);
						self zm_utility::set_player_melee_weapon(level.var_590c486e);
					}
					else
					{
						self giveweapon(level.var_75ef78a0);
						self zm_utility::set_player_melee_weapon(level.var_75ef78a0);
					}
				}
			}
		}
	}
	else
	{
		w_weapon = self getcurrentweapon();
		self zm_utility::disable_player_move_states(1);
		self giveweapon(level.var_9d7b544c);
		self switchtoweapon(level.var_9d7b544c);
		self util::waittill_any("player_downed", "weapon_change_complete");
		self switchtoweapon(w_weapon);
		self zm_utility::enable_player_move_states();
		self takeweapon(level.var_9d7b544c);
		self giveweapon(level.var_653c9585);
		self zm_utility::set_player_melee_weapon(level.var_653c9585);
		self thread zm_audio::create_and_play_dialog("perk", "one_inch");
	}
	self thread monitor_melee_swipe();
}

/*
	Name: monitor_melee_swipe
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x91B2A17D
	Offset: 0xCA8
	Size: 0x358
	Parameters: 0
	Flags: Linked
*/
function monitor_melee_swipe()
{
	self endon(#"disconnect");
	self notify(#"stop_monitor_melee_swipe");
	self endon(#"stop_monitor_melee_swipe");
	self endon(#"bled_out");
	var_ac486a40 = getweapon("tomb_shield");
	while(true)
	{
		while(!self ismeleeing())
		{
			wait(0.05);
		}
		if(self getcurrentweapon() == var_ac486a40)
		{
			wait(0.1);
			continue;
		}
		range_mod = 1;
		self clientfield::set("oneinchpunch_impact", 1);
		util::wait_network_frame();
		self clientfield::set("oneinchpunch_impact", 0);
		v_punch_effect_fwd = anglestoforward(self getplayerangles());
		v_punch_yaw = get_2d_yaw((0, 0, 0), v_punch_effect_fwd);
		if(isdefined(self.b_punch_upgraded) && self.b_punch_upgraded && isdefined(self.str_punch_element) && self.str_punch_element == "air")
		{
			range_mod = range_mod * 2;
		}
		a_zombies = getaispeciesarray(level.zombie_team, "all");
		a_zombies = util::get_array_of_closest(self.origin, a_zombies, undefined, undefined, 100);
		foreach(zombie in a_zombies)
		{
			if(self is_player_facing(zombie, v_punch_yaw) && distancesquared(self.origin, zombie.origin) <= (4096 * range_mod))
			{
				self thread zombie_punch_damage(zombie, 1);
				continue;
			}
			if(self is_player_facing(zombie, v_punch_yaw))
			{
				self thread zombie_punch_damage(zombie, 0.5);
			}
		}
		while(self ismeleeing())
		{
			wait(0.05);
		}
		wait(0.05);
	}
}

/*
	Name: is_player_facing
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x51023EF5
	Offset: 0x1008
	Size: 0x96
	Parameters: 2
	Flags: Linked
*/
function is_player_facing(zombie, v_punch_yaw)
{
	v_player_to_zombie_yaw = get_2d_yaw(self.origin, zombie.origin);
	yaw_diff = v_player_to_zombie_yaw - v_punch_yaw;
	if(yaw_diff < 0)
	{
		yaw_diff = yaw_diff * -1;
	}
	if(yaw_diff < 35)
	{
		return true;
	}
	return false;
}

/*
	Name: is_oneinch_punch_damage
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x441D9C5D
	Offset: 0x10A8
	Size: 0x20
	Parameters: 0
	Flags: None
*/
function is_oneinch_punch_damage()
{
	return isdefined(self.damageweapon) && self.damageweapon == level.var_653c9585;
}

/*
	Name: gib_zombies_head
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0xCFA0A756
	Offset: 0x10D0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function gib_zombies_head(player)
{
	player endon(#"disconnect");
	self zombie_utility::zombie_head_gib();
}

/*
	Name: punch_cooldown
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x669DBF5E
	Offset: 0x1108
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function punch_cooldown()
{
	wait(1);
	self flag::set("melee_punch_cooldown");
}

/*
	Name: zombie_punch_damage
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x8EFC4D39
	Offset: 0x1138
	Size: 0x38C
	Parameters: 2
	Flags: Linked
*/
function zombie_punch_damage(ai_zombie, n_mod)
{
	self endon(#"disconnect");
	ai_zombie.punch_handle_pain_notetracks = &handle_punch_pain_notetracks;
	if(isdefined(n_mod))
	{
		if(self hasperk("specialty_widowswine"))
		{
			n_mod = n_mod * 1.1;
		}
		if(isdefined(self.b_punch_upgraded) && self.b_punch_upgraded)
		{
			n_base_damage = 11275;
		}
		else
		{
			n_base_damage = 2250;
		}
		n_damage = int(n_base_damage * n_mod);
		if(!(isdefined(ai_zombie.is_mechz) && ai_zombie.is_mechz))
		{
			if(n_damage >= ai_zombie.health)
			{
				self thread zombie_punch_death(ai_zombie);
				self zm_utility::do_player_general_vox("kill", "one_inch_punch");
				if(isdefined(self.b_punch_upgraded) && self.b_punch_upgraded && isdefined(self.str_punch_element))
				{
					switch(self.str_punch_element)
					{
						case "fire":
						{
							ai_zombie clientfield::set("fire_char_fx", 1);
							break;
						}
						case "ice":
						{
							ai_zombie clientfield::set("attach_bullet_model", 1);
							break;
						}
						case "lightning":
						{
							if(isdefined(ai_zombie.is_mechz) && ai_zombie.is_mechz)
							{
								return;
							}
							if(isdefined(ai_zombie.is_electrocuted) && ai_zombie.is_electrocuted)
							{
								return;
							}
							tag = "J_SpineUpper";
							ai_zombie clientfield::set("lightning_impact_fx", 1);
							break;
						}
					}
				}
			}
			else
			{
				self zm_score::player_add_points("damage_light");
				if(isdefined(self.b_punch_upgraded) && self.b_punch_upgraded && isdefined(self.str_punch_element))
				{
					switch(self.str_punch_element)
					{
						case "fire":
						{
							ai_zombie clientfield::set("fire_char_fx", 1);
							break;
						}
						case "ice":
						{
							ai_zombie clientfield::set("attach_bullet_model", 1);
							break;
						}
						case "lightning":
						{
							ai_zombie clientfield::set("lightning_impact_fx", 1);
							break;
						}
					}
				}
			}
		}
		ai_zombie dodamage(n_damage, ai_zombie.origin, self, self, 0, "MOD_MELEE", 0, self.current_melee_weapon);
	}
}

/*
	Name: zombie_punch_death
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x5A636C7D
	Offset: 0x14D0
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function zombie_punch_death(ai_zombie)
{
	ai_zombie thread gib_zombies_head(self);
	if(isdefined(level.ragdoll_limit_check) && ![[level.ragdoll_limit_check]]())
	{
		return;
	}
	if(isdefined(ai_zombie))
	{
		ai_zombie startragdoll();
		v_launch = (vectornormalize(ai_zombie.origin - self.origin)) * randomintrange(125, 150) + (0, 0, randomintrange(75, 150));
		ai_zombie launchragdoll(v_launch);
	}
}

/*
	Name: handle_punch_pain_notetracks
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x7AFB0FE6
	Offset: 0x15C8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function handle_punch_pain_notetracks(note)
{
	if(note == "zombie_knockdown_ground_impact")
	{
		playfx(level._effect["punch_knockdown_ground"], self.origin, anglestoforward(self.angles), anglestoup(self.angles));
	}
}

/*
	Name: one_inch_punch_take_think
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x88FDED42
	Offset: 0x1648
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function one_inch_punch_take_think()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"bled_out");
		self.one_inch_punch_flag_has_been_init = 0;
		self.widows_wine_knife_override = undefined;
		if(self flag::exists("melee_punch_cooldown"))
		{
			self flag::delete("melee_punch_cooldown");
		}
	}
}

/*
	Name: knockdown_zombie_animate
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x15D1CB11
	Offset: 0x16C8
	Size: 0x43E
	Parameters: 0
	Flags: Linked
*/
function knockdown_zombie_animate()
{
	self notify(#"end_play_punch_pain_anim");
	self endon(#"killanimscript");
	self endon(#"death");
	self endon(#"end_play_punch_pain_anim");
	if(isdefined(self.marked_for_death) && self.marked_for_death)
	{
		return;
	}
	self.allowpain = 0;
	animation_direction = undefined;
	animation_legs = "";
	animation_side = undefined;
	animation_duration = "_default";
	v_forward = vectordot(anglestoforward(self.angles), vectornormalize(self.v_punched_from - self.origin));
	if(v_forward > 0.6)
	{
		animation_direction = "back";
		if(isdefined(self.missinglegs) && self.missinglegs)
		{
			animation_legs = "_crawl";
		}
		if(randomint(100) > 75)
		{
			animation_side = "belly";
		}
		else
		{
			animation_side = "back";
		}
	}
	else
	{
		if(self.damageyaw > 75 && self.damageyaw < 135)
		{
			animation_direction = "left";
			animation_side = "belly";
		}
		else
		{
			if(self.damageyaw > -135 && self.damageyaw < -75)
			{
				animation_direction = "right";
				animation_side = "belly";
			}
			else
			{
				animation_direction = "front";
				animation_side = "belly";
			}
		}
	}
	self thread knockdown_zombie_animate_state();
	self setanimstatefromasd(("zm_punch_fall_" + animation_direction) + animation_legs);
	self zombie_shared::donotetracks("punch_fall_anim", self.punch_handle_pain_notetracks);
	if(isdefined(self.missinglegs) && self.missinglegs || (isdefined(self.marked_for_death) && self.marked_for_death))
	{
		return;
	}
	if(isdefined(self.a.gib_ref))
	{
		if(self.a.gib_ref == "no_legs" || self.a.gib_ref == "no_arms" || (self.a.gib_ref == "left_leg" || self.a.gib_ref == "right_leg" && randomint(100) > 25) || (self.a.gib_ref == "left_arm" || self.a.gib_ref == "right_arm" && randomint(100) > 75))
		{
			animation_duration = "_late";
		}
		else if(randomint(100) > 75)
		{
			animation_duration = "_early";
		}
	}
	else if(randomint(100) > 25)
	{
		animation_duration = "_early";
	}
	self zombie_shared::donotetracks("punch_getup_anim");
	self.allowpain = 1;
	self notify(#"back_up");
}

/*
	Name: knockdown_zombie_animate_state
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x3E41776A
	Offset: 0x1B10
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function knockdown_zombie_animate_state()
{
	self endon(#"death");
	self.is_knocked_down = 1;
	self util::waittill_any("damage", "back_up");
	self.is_knocked_down = 0;
}

/*
	Name: get_2d_yaw
	Namespace: _zm_weap_one_inch_punch
	Checksum: 0x6483D1D1
	Offset: 0x1B68
	Size: 0x5A
	Parameters: 2
	Flags: Linked
*/
function get_2d_yaw(v_origin, v_target)
{
	v_forward = v_target - v_origin;
	v_angles = vectortoangles(v_forward);
	return v_angles[1];
}

