// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_keeper_skull;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#namespace zm_island_util;

/*
	Name: spawn_trigger_radius
	Namespace: zm_island_util
	Checksum: 0xEDFDAB31
	Offset: 0x3D0
	Size: 0x5A
	Parameters: 4
	Flags: Linked
*/
function spawn_trigger_radius(origin, radius, use_trigger = 0, func_per_player_msg)
{
	return spawn_unitrigger(origin, undefined, radius, use_trigger, func_per_player_msg);
}

/*
	Name: spawn_unitrigger
	Namespace: zm_island_util
	Checksum: 0xB27FE2A0
	Offset: 0x438
	Size: 0x1F8
	Parameters: 5
	Flags: Linked, Private
*/
function private spawn_unitrigger(origin, angles, radius_or_dims, use_trigger = 0, func_per_player_msg)
{
	trigger_stub = spawnstruct();
	trigger_stub.origin = origin;
	str_type = "unitrigger_radius";
	if(isvec(radius_or_dims))
	{
		trigger_stub.script_length = radius_or_dims[0];
		trigger_stub.script_width = radius_or_dims[1];
		trigger_stub.script_height = radius_or_dims[2];
		str_type = "unitrigger_box";
		if(!isdefined(angles))
		{
			angles = (0, 0, 0);
		}
		trigger_stub.angles = angles;
	}
	else
	{
		trigger_stub.radius = radius_or_dims;
	}
	if(use_trigger)
	{
		trigger_stub.cursor_hint = "HINT_NOICON";
		trigger_stub.script_unitrigger_type = str_type + "_use";
	}
	else
	{
		trigger_stub.script_unitrigger_type = str_type;
	}
	if(isdefined(func_per_player_msg))
	{
		trigger_stub.func_unitrigger_message = func_per_player_msg;
		zm_unitrigger::unitrigger_force_per_player_triggers(trigger_stub, 1);
	}
	trigger_stub.prompt_and_visibility_func = &function_5ea427bf;
	zm_unitrigger::register_unitrigger(trigger_stub, &unitrigger_think);
	return trigger_stub;
}

/*
	Name: function_5ea427bf
	Namespace: zm_island_util
	Checksum: 0xCEA5676
	Offset: 0x638
	Size: 0x170
	Parameters: 1
	Flags: Linked
*/
function function_5ea427bf(player)
{
	b_visible = 1;
	if(isdefined(player.beastmode) && player.beastmode && (!(isdefined(self.allow_beastmode) && self.allow_beastmode)))
	{
		b_visible = 0;
	}
	else if(isdefined(self.stub.func_unitrigger_visible))
	{
		b_visible = self [[self.stub.func_unitrigger_visible]](player);
	}
	str_msg = &"";
	param1 = undefined;
	if(b_visible)
	{
		if(isdefined(self.stub.func_unitrigger_message))
		{
			str_msg = self [[self.stub.func_unitrigger_message]](player);
		}
		else
		{
			str_msg = self.stub.hint_string;
			param1 = self.stub.hint_parm1;
		}
	}
	if(isdefined(param1))
	{
		self sethintstring(str_msg, param1);
	}
	else
	{
		self sethintstring(str_msg);
	}
	return b_visible;
}

/*
	Name: unitrigger_think
	Namespace: zm_island_util
	Checksum: 0xCEB4F4F2
	Offset: 0x7B0
	Size: 0x60
	Parameters: 0
	Flags: Linked, Private
*/
function private unitrigger_think()
{
	self endon(#"kill_trigger");
	self.stub thread unitrigger_refresh_message();
	while(true)
	{
		self waittill(#"trigger", player);
		self.stub notify(#"trigger", player);
	}
}

/*
	Name: unitrigger_refresh_message
	Namespace: zm_island_util
	Checksum: 0x68689137
	Offset: 0x818
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function unitrigger_refresh_message()
{
	self zm_unitrigger::run_visibility_function_for_all_triggers();
}

/*
	Name: function_acd04dc9
	Namespace: zm_island_util
	Checksum: 0x4CFD57A9
	Offset: 0x840
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function function_acd04dc9()
{
	self endon(#"death");
	self waittill(#"completed_emerging_into_playable_area");
	self.no_powerups = 1;
}

/*
	Name: function_7448e472
	Namespace: zm_island_util
	Checksum: 0x623A4F3D
	Offset: 0x870
	Size: 0x324
	Parameters: 1
	Flags: Linked
*/
function function_7448e472(e_target)
{
	self endon(#"death");
	if(isdefined(e_target.targetname))
	{
		var_241c185a = "someone_revealed_" + e_target.targetname;
		self endon(var_241c185a);
	}
	var_c2b47c7a = 0;
	self.var_abd1c759 = e_target;
	while(isdefined(e_target) && (!(isdefined(var_c2b47c7a) && var_c2b47c7a)))
	{
		if(self hasweapon(level.var_c003f5b))
		{
			if(self util::ads_button_held())
			{
				if(self getcurrentweapon() !== level.var_c003f5b)
				{
					while(self adsbuttonpressed())
					{
						wait(0.05);
					}
				}
				else if(self getammocount(level.var_c003f5b))
				{
					if(self keeper_skull::function_3f3f64e9(e_target) && self keeper_skull::function_5fa274c1(e_target))
					{
						self playrumbleonentity("zm_island_skull_reveal");
						n_count = 0;
						while(self util::ads_button_held())
						{
							wait(1);
							n_count++;
							if(n_count >= 2)
							{
								break;
							}
						}
						if(n_count >= 2)
						{
							e_target.var_f0b65c0a = self;
							var_c2b47c7a = 1;
							playsoundatposition("zmb_wpn_skullgun_discover", e_target.origin);
							self notify(#"skullweapon_revealed_location");
							self thread function_4aedb20b();
							foreach(player in level.players)
							{
								if(e_target === player.var_abd1c759)
								{
									player.var_abd1c759 = undefined;
									if(isdefined(var_241c185a) && player != self)
									{
										player notify(var_241c185a);
									}
								}
							}
							break;
						}
						else
						{
							self stoprumble("zm_island_skull_reveal");
						}
					}
				}
			}
		}
		wait(0.05);
	}
	return var_c2b47c7a;
}

/*
	Name: function_4aedb20b
	Namespace: zm_island_util
	Checksum: 0xB69E2633
	Offset: 0xBA0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_4aedb20b()
{
	if(self.var_118ab24e >= 33)
	{
		self gadgetpowerset(0, self.var_118ab24e - 33);
	}
	else
	{
		self gadgetpowerset(0, 0);
	}
}

/*
	Name: function_925aa63a
	Namespace: zm_island_util
	Checksum: 0xC2793D9B
	Offset: 0xC10
	Size: 0x182
	Parameters: 4
	Flags: Linked
*/
function function_925aa63a(var_fedda046, n_delay = 0.1, n_value, b_delete = 1)
{
	foreach(var_1c7231df in var_fedda046)
	{
		if(isdefined(var_1c7231df))
		{
			var_1c7231df clientfield::set("do_fade_material", n_value);
			wait(n_delay);
		}
	}
	wait(1);
	if(isdefined(b_delete) && b_delete)
	{
		foreach(var_1c7231df in var_fedda046)
		{
			var_1c7231df delete();
		}
	}
}

/*
	Name: function_f2a55b5f
	Namespace: zm_island_util
	Checksum: 0xE2EE335F
	Offset: 0xDA0
	Size: 0x62
	Parameters: 1
	Flags: Linked
*/
function function_f2a55b5f(a_str_zones)
{
	if(!zm_utility::is_player_valid(self))
	{
		return 0;
	}
	str_player_zone = self zm_zonemgr::get_player_zone();
	return isinarray(a_str_zones, str_player_zone);
}

/*
	Name: is_facing
	Namespace: zm_island_util
	Checksum: 0x1C271C0A
	Offset: 0xE10
	Size: 0x142
	Parameters: 2
	Flags: Linked
*/
function is_facing(target, n_tolerance = 0.707)
{
	if(isentity(target))
	{
		v_target = target.origin;
	}
	else if(isvec(target))
	{
		v_target = target;
	}
	var_7ef98cb2 = v_target - self.origin;
	var_7ec36342 = vectornormalize(var_7ef98cb2);
	var_bedf3d47 = anglestoforward(self.angles);
	var_c67c7281 = vectornormalize(var_bedf3d47);
	n_dot = vectordot(var_7ec36342, var_c67c7281);
	return n_dot >= n_tolerance;
}

/*
	Name: function_1867f3e8
	Namespace: zm_island_util
	Checksum: 0x5BBDA886
	Offset: 0xF60
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function function_1867f3e8(n_distance)
{
	n_dist_sq = n_distance * n_distance;
	str_player_zone = self zm_zonemgr::get_player_zone();
	a_enemies = getaiteamarray("axis");
	var_9efb74d5 = 0;
	foreach(enemy in a_enemies)
	{
		if(isalive(enemy) && enemy zm_zonemgr::entity_in_zone(str_player_zone) && distancesquared(self.origin, enemy.origin) < n_dist_sq)
		{
			var_9efb74d5++;
		}
	}
	return var_9efb74d5;
}

/*
	Name: function_4bf4ac40
	Namespace: zm_island_util
	Checksum: 0xF03D770
	Offset: 0x10C8
	Size: 0xD2
	Parameters: 1
	Flags: Linked
*/
function function_4bf4ac40(v_loc)
{
	a_players = arraycopy(level.activeplayers);
	e_player = undefined;
	do
	{
		if(isdefined(v_loc))
		{
			e_player = arraygetclosest(v_loc, a_players);
		}
		else
		{
			e_player = array::random(a_players);
		}
		arrayremovevalue(a_players, e_player);
	}
	while(!zm_utility::is_player_valid(e_player) && a_players.size > 0);
	return e_player;
}

/*
	Name: any_player_looking_at
	Namespace: zm_island_util
	Checksum: 0x2C12842F
	Offset: 0x11A8
	Size: 0xDC
	Parameters: 4
	Flags: Linked
*/
function any_player_looking_at(v_org, n_dot, b_do_trace, e_ignore)
{
	foreach(player in level.players)
	{
		if(zm_utility::is_player_valid(player) && player util::is_player_looking_at(v_org, n_dot, b_do_trace, e_ignore))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: swap_weapon
	Namespace: zm_island_util
	Checksum: 0x83F1C76A
	Offset: 0x1290
	Size: 0x242
	Parameters: 1
	Flags: Linked
*/
function swap_weapon(wpn_new)
{
	wpn_current = self getcurrentweapon();
	if(!zm_utility::is_player_valid(self))
	{
		return;
	}
	if(self.is_drinking > 0)
	{
		return;
	}
	if(zm_utility::is_placeable_mine(wpn_current) || zm_equipment::is_equipment(wpn_current) || wpn_current == level.weaponnone)
	{
		return;
	}
	if(!self zm_weapons::has_weapon_or_upgrade(wpn_new))
	{
		if(wpn_new.type === "melee")
		{
			self function_3420bc2f(wpn_new);
		}
		else
		{
			if(wpn_new.type === "grenade")
			{
				self zm_weapons::weapon_give(wpn_new);
			}
			else
			{
				self take_old_weapon_and_give_new(wpn_current, wpn_new);
			}
		}
	}
	else
	{
		var_c259e5ce = self zm_weapons::get_player_weapon_with_same_base(wpn_new);
		var_6c6831af = self getweaponslist(1);
		foreach(weapon in var_6c6831af)
		{
			if(self zm_weapons::get_player_weapon_with_same_base(weapon) === var_c259e5ce)
			{
				self givemaxammo(weapon);
			}
		}
	}
}

/*
	Name: take_old_weapon_and_give_new
	Namespace: zm_island_util
	Checksum: 0xBB6AB070
	Offset: 0x14E0
	Size: 0xA0
	Parameters: 2
	Flags: Linked
*/
function take_old_weapon_and_give_new(current_weapon, weapon)
{
	a_weapons = self getweaponslistprimaries();
	if(isdefined(a_weapons) && a_weapons.size >= zm_utility::get_player_weapon_limit(self))
	{
		self takeweapon(current_weapon);
	}
	var_7b9ca68 = self zm_weapons::give_build_kit_weapon(weapon);
}

/*
	Name: function_3420bc2f
	Namespace: zm_island_util
	Checksum: 0x23F61BBF
	Offset: 0x1588
	Size: 0x140
	Parameters: 1
	Flags: Linked
*/
function function_3420bc2f(wpn_new)
{
	var_c5716cdc = self getweaponslist(1);
	foreach(weapon in var_c5716cdc)
	{
		if(weapon.type === "melee")
		{
			self takeweapon(weapon);
			break;
		}
	}
	if(self hasperk("specialty_widowswine"))
	{
		var_7b9ca68 = self zm_weapons::give_build_kit_weapon(level.w_widows_wine_bowie_knife);
	}
	else
	{
		var_7b9ca68 = self zm_weapons::give_build_kit_weapon(wpn_new);
	}
}

/*
	Name: function_8faf1d24
	Namespace: zm_island_util
	Checksum: 0xAFA07A94
	Offset: 0x16D0
	Size: 0x108
	Parameters: 4
	Flags: Linked
*/
function function_8faf1d24(v_color, var_8882142e, n_scale, str_endon)
{
	/#
		if(!isdefined(v_color))
		{
			v_color = vectorscale((0, 0, 1), 255);
		}
		if(!isdefined(var_8882142e))
		{
			var_8882142e = "";
		}
		if(!isdefined(n_scale))
		{
			n_scale = 0.25;
		}
		if(!isdefined(str_endon))
		{
			str_endon = "";
		}
		if(getdvarint("") == 0)
		{
			return;
		}
		if(isdefined(str_endon))
		{
			self endon(str_endon);
		}
		origin = self.origin;
		while(true)
		{
			print3d(origin, var_8882142e, v_color, n_scale);
			wait(0.1);
		}
	#/
}

