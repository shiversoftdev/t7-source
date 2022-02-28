// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_riotshield;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craft_shield;
#using scripts\zm\zm_castle_vo;

#namespace castle_rocketshield;

/*
	Name: __init__sytem__
	Namespace: castle_rocketshield
	Checksum: 0x57B348D5
	Offset: 0x610
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_castle_rocketshield", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: castle_rocketshield
	Checksum: 0x17500068
	Offset: 0x658
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_craft_shield::init("craft_shield_zm", "castle_riotshield", "wpn_t7_zmb_zod_rocket_shield_world");
	clientfield::register("allplayers", "rs_ammo", 1, 1, "int");
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	level.weaponriotshield = getweapon("castle_riotshield");
	zm_equipment::register("castle_riotshield", &"ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_RIOTSHIELD_HOWTO", undefined, "riotshield");
	level.weaponriotshieldupgraded = getweapon("castle_riotshield_upgraded");
	zm_equipment::register("castle_riotshield_upgraded", &"ZOMBIE_EQUIP_RIOTSHIELD_PICKUP_HINT_STRING", &"ZOMBIE_EQUIP_RIOTSHIELD_HOWTO", undefined, "riotshield");
}

/*
	Name: __main__
	Namespace: castle_rocketshield
	Checksum: 0x252E4DC0
	Offset: 0x7A0
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	zm_equipment::register_for_level("castle_riotshield");
	zm_equipment::include("castle_riotshield");
	zm_equipment::set_ammo_driven("castle_riotshield", level.weaponriotshield.startammo, 1);
	zm_equipment::register_for_level("castle_riotshield_upgraded");
	zm_equipment::include("castle_riotshield_upgraded");
	zm_equipment::set_ammo_driven("castle_riotshield_upgraded", level.weaponriotshieldupgraded.startammo, 1);
	setdvar("juke_enabled", 1);
	zombie_utility::set_zombie_var("riotshield_fling_damage_shield", 100);
	zombie_utility::set_zombie_var("riotshield_knockdown_damage_shield", 15);
	zombie_utility::set_zombie_var("riotshield_juke_damage_shield", 0);
	zombie_utility::set_zombie_var("riotshield_fling_force_juke", 175);
	zombie_utility::set_zombie_var("riotshield_fling_range", 120);
	zombie_utility::set_zombie_var("riotshield_gib_range", 120);
	zombie_utility::set_zombie_var("riotshield_knockdown_range", 120);
	level thread spawn_recharge_tanks();
	level.zombie_craftablestubs["craft_shield_zm"].v_origin_offset = vectorscale((0, 0, 1), 30);
	/#
		level thread function_3f94d6cf();
	#/
}

/*
	Name: on_player_connect
	Namespace: castle_rocketshield
	Checksum: 0x62E18907
	Offset: 0x9C0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread function_e8141489();
	self thread function_bbf98b84();
}

/*
	Name: function_e8141489
	Namespace: castle_rocketshield
	Checksum: 0xEEB34BCD
	Offset: 0xA00
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_e8141489()
{
	self endon(#"disconnect");
	while(isdefined(self))
	{
		self waittill(#"weapon_change", w_weapon);
		if(w_weapon.isriotshield)
		{
			break;
		}
	}
	self.rocket_shield_hint_shown = 1;
	zm_equipment::show_hint_text(&"ZM_CASTLE_ROCKET_HINT", 5);
}

/*
	Name: function_bbf98b84
	Namespace: castle_rocketshield
	Checksum: 0xD687ADAA
	Offset: 0xA80
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_bbf98b84()
{
	self endon(#"disconnect");
	while(isdefined(self))
	{
		level waittill(#"shield_built", e_who);
		if(e_who === self)
		{
			self playrumbleonentity("zm_castle_interact_rumble");
		}
	}
}

/*
	Name: on_player_spawned
	Namespace: castle_rocketshield
	Checksum: 0xD5FE91F9
	Offset: 0xAE8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread player_watch_shield_juke();
	self thread player_watch_ammo_change();
	self thread player_watch_max_ammo();
}

/*
	Name: player_watch_ammo_change
	Namespace: castle_rocketshield
	Checksum: 0x85C7760
	Offset: 0xB40
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function player_watch_ammo_change()
{
	self notify(#"player_watch_ammo_change");
	self endon(#"player_watch_ammo_change");
	for(;;)
	{
		self waittill(#"equipment_ammo_changed", equipment);
		if(isstring(equipment))
		{
			equipment = getweapon(equipment);
		}
		if(equipment == getweapon("castle_riotshield") || equipment == getweapon("castle_riotshield_upgraded"))
		{
			self thread check_weapon_ammo(equipment);
		}
	}
}

/*
	Name: player_watch_max_ammo
	Namespace: castle_rocketshield
	Checksum: 0x275F5D62
	Offset: 0xC10
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function player_watch_max_ammo()
{
	self notify(#"player_watch_max_ammo");
	self endon(#"player_watch_max_ammo");
	for(;;)
	{
		self waittill(#"zmb_max_ammo");
		wait(0.05);
		if(isdefined(self.hasriotshield) && self.hasriotshield)
		{
			self thread check_weapon_ammo(self.weaponriotshield);
		}
	}
}

/*
	Name: check_weapon_ammo
	Namespace: castle_rocketshield
	Checksum: 0xD01E0872
	Offset: 0xC80
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function check_weapon_ammo(weapon)
{
	wait(0.05);
	if(isdefined(self))
	{
		ammo = self getweaponammoclip(weapon);
		self clientfield::set("rs_ammo", ammo);
	}
}

/*
	Name: player_watch_shield_juke
	Namespace: castle_rocketshield
	Checksum: 0x46241C3F
	Offset: 0xCF0
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function player_watch_shield_juke()
{
	self notify(#"player_watch_shield_juke");
	self endon(#"player_watch_shield_juke");
	for(;;)
	{
		self waittill(#"weapon_melee_juke", weapon);
		if(weapon.isriotshield)
		{
			self disableoffhandweapons();
			self playsound("zmb_rocketshield_start");
			self riotshield_melee_juke(weapon);
			self playsound("zmb_rocketshield_end");
			self enableoffhandweapons();
			self thread check_weapon_ammo(weapon);
			self notify(#"shield_juke_done");
		}
	}
}

/*
	Name: riotshield_melee_juke
	Namespace: castle_rocketshield
	Checksum: 0x51E891B7
	Offset: 0xDF0
	Size: 0x2C8
	Parameters: 1
	Flags: Linked
*/
function riotshield_melee_juke(weapon)
{
	self endon(#"weapon_melee");
	self endon(#"weapon_melee_power");
	self endon(#"weapon_melee_charge");
	var_27e95375 = 0;
	start_time = gettime();
	if(!isdefined(level.riotshield_knockdown_enemies))
	{
		level.riotshield_knockdown_enemies = [];
	}
	if(!isdefined(level.riotshield_knockdown_gib))
	{
		level.riotshield_knockdown_gib = [];
	}
	if(!isdefined(level.riotshield_fling_enemies))
	{
		level.riotshield_fling_enemies = [];
	}
	if(!isdefined(level.riotshield_fling_vecs))
	{
		level.riotshield_fling_vecs = [];
	}
	while((start_time + 3000) > gettime())
	{
		self playrumbleonentity("zod_shield_juke");
		forward = anglestoforward(self getplayerangles());
		shield_damage = 0;
		enemies = riotshield_get_juke_enemies_in_range();
		if(isdefined(level.riotshield_melee_juke_callback) && isfunctionptr(level.riotshield_melee_juke_callback))
		{
			[[level.riotshield_melee_juke_callback]](enemies);
		}
		foreach(zombie in enemies)
		{
			self playsound("zmb_rocketshield_imp");
			zombie thread riotshield::riotshield_fling_zombie(self, zombie.fling_vec, 0);
			shield_damage = shield_damage + level.zombie_vars["riotshield_juke_damage_shield"];
			if(!var_27e95375)
			{
				self thread zm_castle_vo::function_c166f48();
				var_27e95375 = 1;
			}
		}
		if(shield_damage)
		{
			self riotshield::player_damage_shield(shield_damage, 0);
		}
		level.riotshield_knockdown_enemies = [];
		level.riotshield_knockdown_gib = [];
		level.riotshield_fling_enemies = [];
		level.riotshield_fling_vecs = [];
		wait(0.1);
	}
}

/*
	Name: function_92debe0a
	Namespace: castle_rocketshield
	Checksum: 0x206269EE
	Offset: 0x10C0
	Size: 0x15E
	Parameters: 0
	Flags: None
*/
function function_92debe0a()
{
	/#
		level waittill(#"start_of_round");
		foreach(player in getplayers())
		{
		}
		while(true)
		{
			level waittill(#"start_of_round");
			foreach(player in getplayers())
			{
				if(isdefined(player.hasriotshield) && player.hasriotshield)
				{
					player givestartammo(player.weaponriotshield);
				}
			}
		}
	#/
}

/*
	Name: riotshield_get_juke_enemies_in_range
	Namespace: castle_rocketshield
	Checksum: 0x5B8FC41F
	Offset: 0x1228
	Size: 0x356
	Parameters: 0
	Flags: Linked
*/
function riotshield_get_juke_enemies_in_range()
{
	view_pos = self.origin;
	zombies = array::get_all_closest(view_pos, getaiteamarray(level.zombie_team), undefined, undefined, 120);
	if(!isdefined(zombies))
	{
		return;
	}
	forward = anglestoforward(self getplayerangles());
	up = anglestoup(self getplayerangles());
	segment_start = view_pos + (36 * forward);
	segment_end = segment_start + ((120 - 36) * forward);
	fling_force = level.zombie_vars["riotshield_fling_force_juke"];
	fling_force_vlo = fling_force * 0.5;
	fling_force_vhi = fling_force * 0.6;
	enemies = [];
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]) || !isalive(zombies[i]))
		{
			continue;
		}
		if(zombies[i].archetype == "margwa")
		{
			continue;
		}
		test_origin = zombies[i] getcentroid();
		radial_origin = pointonsegmentnearesttopoint(segment_start, segment_end, test_origin);
		lateral = test_origin - radial_origin;
		if(abs(lateral[2]) > 72)
		{
			continue;
		}
		lateral = (lateral[0], lateral[1], 0);
		len = length(lateral);
		if(len > 36)
		{
			continue;
		}
		lateral = (lateral[0], lateral[1], 0);
		zombies[i].fling_vec = (fling_force * forward) + (randomfloatrange(fling_force_vlo, fling_force_vhi) * up);
		enemies[enemies.size] = zombies[i];
	}
	return enemies;
}

/*
	Name: spawn_recharge_tanks
	Namespace: castle_rocketshield
	Checksum: 0xE1EC2936
	Offset: 0x1588
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function spawn_recharge_tanks()
{
	level flag::wait_till("all_players_spawned");
	n_spawned = 0;
	n_charges = level.players.size + 3;
	a_e_spawnpoints = array::randomize(struct::get_array("castle_shield_charge"));
	/#
		level thread function_fc8bb1d(a_e_spawnpoints);
	#/
	foreach(e_spawnpoint in a_e_spawnpoints)
	{
		if(isdefined(e_spawnpoint.spawned) && e_spawnpoint.spawned)
		{
			n_spawned++;
		}
	}
	foreach(e_spawnpoint in a_e_spawnpoints)
	{
		if(n_spawned < n_charges)
		{
			if(!(isdefined(e_spawnpoint.spawned) && e_spawnpoint.spawned))
			{
				e_spawnpoint thread create_bottle_unitrigger(e_spawnpoint.origin, e_spawnpoint.angles);
				n_spawned++;
			}
			continue;
		}
		break;
	}
	level waittill(#"start_of_round");
	level thread spawn_recharge_tanks();
}

/*
	Name: create_bottle_unitrigger
	Namespace: castle_rocketshield
	Checksum: 0xBA21900C
	Offset: 0x17D0
	Size: 0x290
	Parameters: 2
	Flags: Linked
*/
function create_bottle_unitrigger(v_origin, v_angles)
{
	s_struct = self;
	if(self == level)
	{
		s_struct = spawnstruct();
		s_struct.origin = v_origin;
		s_struct.angles = v_angles;
	}
	width = 128;
	height = 128;
	length = 128;
	unitrigger_stub = spawnstruct();
	unitrigger_stub.origin = v_origin;
	unitrigger_stub.angles = v_angles;
	unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	unitrigger_stub.cursor_hint = "HINT_NOICON";
	unitrigger_stub.script_width = width;
	unitrigger_stub.script_height = height;
	unitrigger_stub.script_length = length;
	unitrigger_stub.require_look_at = 0;
	unitrigger_stub.mdl_shield_recharge = spawn("script_model", v_origin);
	modelname = "p7_zm_zod_nitrous_tank";
	if(isdefined(s_struct.model) && isstring(s_struct.model))
	{
		modelname = s_struct.model;
	}
	unitrigger_stub.mdl_shield_recharge setmodel(modelname);
	unitrigger_stub.mdl_shield_recharge.angles = v_angles;
	s_struct.spawned = 1;
	unitrigger_stub.shield_recharge_spawnpoint = s_struct;
	unitrigger_stub.prompt_and_visibility_func = &bottle_trigger_visibility;
	zm_unitrigger::register_static_unitrigger(unitrigger_stub, &shield_recharge_trigger_think);
	return unitrigger_stub;
}

/*
	Name: function_fc8bb1d
	Namespace: castle_rocketshield
	Checksum: 0xD96273ED
	Offset: 0x1A68
	Size: 0x166
	Parameters: 1
	Flags: Linked
*/
function function_fc8bb1d(a_spawnpoints)
{
	/#
		level notify(#"hash_afd0dfa9");
		level endon(#"hash_afd0dfa9");
		while(true)
		{
			n_debug = getdvarint("", 0);
			if(n_debug > 0)
			{
				foreach(spawnpoint in a_spawnpoints)
				{
					v_color = (1, 1, 1);
					if(isdefined(spawnpoint.spawned) && spawnpoint.spawned)
					{
						v_color = (0, 1, 0);
					}
					sphere(spawnpoint.origin, 25, v_color, 0.1, 0, 25, 10);
				}
			}
			wait(10 * 0.05);
		}
	#/
}

/*
	Name: bottle_trigger_visibility
	Namespace: castle_rocketshield
	Checksum: 0x6D69E46F
	Offset: 0x1BD8
	Size: 0xCA
	Parameters: 1
	Flags: Linked
*/
function bottle_trigger_visibility(player)
{
	self sethintstring(&"ZM_CASTLE_PICKUP_BOTTLE");
	if(!(isdefined(player.hasriotshield) && player.hasriotshield) || player getammocount(player.weaponriotshield) == player.weaponriotshield.maxammo)
	{
		b_is_invis = 1;
	}
	else
	{
		b_is_invis = 0;
	}
	self setinvisibletoplayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: shield_recharge_trigger_think
	Namespace: castle_rocketshield
	Checksum: 0xD2301469
	Offset: 0x1CB0
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function shield_recharge_trigger_think()
{
	while(true)
	{
		self waittill(#"trigger", player);
		if(player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(player.is_drinking > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(player))
		{
			continue;
		}
		level thread bottle_trigger_activate(self.stub, player);
		break;
	}
}

/*
	Name: bottle_trigger_activate
	Namespace: castle_rocketshield
	Checksum: 0xDB8F4B56
	Offset: 0x1D60
	Size: 0x10A
	Parameters: 2
	Flags: Linked
*/
function bottle_trigger_activate(trig_stub, player)
{
	trig_stub notify(#"bottle_collected");
	if(isdefined(player.hasriotshield) && player.hasriotshield)
	{
		player zm_equipment::change_ammo(player.weaponriotshield, 1);
	}
	v_origin = trig_stub.mdl_shield_recharge.origin;
	v_angles = trig_stub.mdl_shield_recharge.angles;
	trig_stub.mdl_shield_recharge delete();
	zm_unitrigger::unregister_unitrigger(trig_stub);
	trig_stub.shield_recharge_spawnpoint.spawned = undefined;
}

/*
	Name: function_3f94d6cf
	Namespace: castle_rocketshield
	Checksum: 0xC244A8D0
	Offset: 0x1E78
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function function_3f94d6cf()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_e2f5a93);
		adddebugcommand("");
		adddebugcommand("");
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			ip1 = i + 1;
		}
	#/
}

/*
	Name: function_e2f5a93
	Namespace: castle_rocketshield
	Checksum: 0x1B44271F
	Offset: 0x1F60
	Size: 0xCE
	Parameters: 1
	Flags: Linked
*/
function function_e2f5a93(cmd)
{
	/#
		players = getplayers();
		retval = 0;
		switch(cmd)
		{
			case "":
			{
				array::thread_all(players, &zm_devgui::zombie_devgui_equipment_give, "");
				retval = 1;
				break;
			}
			case "":
			{
				array::thread_all(players, &function_3796f8bc);
				retval = 1;
				break;
			}
		}
		return retval;
	#/
}

/*
	Name: detect_reentry
	Namespace: castle_rocketshield
	Checksum: 0xF37CD911
	Offset: 0x2038
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function detect_reentry()
{
	/#
		if(isdefined(self.devgui_preserve_time))
		{
			if(self.devgui_preserve_time == gettime())
			{
				return true;
			}
		}
		self.devgui_preserve_time = gettime();
		return false;
	#/
}

/*
	Name: function_3796f8bc
	Namespace: castle_rocketshield
	Checksum: 0x5CEB888F
	Offset: 0x2078
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function function_3796f8bc()
{
	/#
		if(self detect_reentry())
		{
			return;
		}
		self notify(#"hash_3796f8bc");
		self endon(#"hash_3796f8bc");
		level flagsys::wait_till("");
		self.var_3796f8bc = !(isdefined(self.var_3796f8bc) && self.var_3796f8bc);
		if(self.var_3796f8bc)
		{
			while(isdefined(self))
			{
				damagemax = level.weaponriotshield.weaponstarthitpoints;
				if(isdefined(self.weaponriotshield))
				{
					damagemax = self.weaponriotshield.weaponstarthitpoints;
				}
				shieldhealth = self damageriotshield(0);
				if(shieldhealth == 0)
				{
					shieldhealth = self damageriotshield(damagemax * -1);
				}
				else
				{
					shieldhealth = self damageriotshield(int(damagemax / 10));
				}
				wait(0.5);
			}
		}
	#/
}

