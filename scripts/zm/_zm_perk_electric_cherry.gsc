// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pers_upgrades_system;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_perk_electric_cherry;

/*
	Name: __init__sytem__
	Namespace: zm_perk_electric_cherry
	Checksum: 0x86578C6A
	Offset: 0x5C8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_electric_cherry", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_electric_cherry
	Checksum: 0x72B251FD
	Offset: 0x608
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	enable_electric_cherry_perk_for_level();
}

/*
	Name: enable_electric_cherry_perk_for_level
	Namespace: zm_perk_electric_cherry
	Checksum: 0x7CC9ABD7
	Offset: 0x628
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function enable_electric_cherry_perk_for_level()
{
	zm_perks::register_perk_basic_info("specialty_electriccherry", "electric_cherry", 10, &"ZOMBIE_PERK_WIDOWSWINE", getweapon("zombie_perk_bottle_cherry"));
	zm_perks::register_perk_precache_func("specialty_electriccherry", &electric_cherry_precache);
	zm_perks::register_perk_clientfields("specialty_electriccherry", &electric_cherry_register_clientfield, &electric_cherry_set_clientfield);
	zm_perks::register_perk_machine("specialty_electriccherry", &electric_cherry_perk_machine_setup);
	zm_perks::register_perk_host_migration_params("specialty_electriccherry", "vending_electriccherry", "electric_cherry_light");
	zm_perks::register_perk_threads("specialty_electriccherry", &electric_cherry_reload_attack, &electric_cherry_perk_lost);
	if(isdefined(level.custom_electric_cherry_perk_threads) && level.custom_electric_cherry_perk_threads)
	{
		level thread [[level.custom_electric_cherry_perk_threads]]();
	}
	init_electric_cherry();
}

/*
	Name: electric_cherry_precache
	Namespace: zm_perk_electric_cherry
	Checksum: 0x8CDC1928
	Offset: 0x798
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function electric_cherry_precache()
{
	if(isdefined(level.electric_cherry_precache_override_func))
	{
		[[level.electric_cherry_precache_override_func]]();
		return;
	}
	level._effect["electric_cherry_light"] = "_t6/misc/fx_zombie_cola_revive_on";
	level.machine_assets["specialty_electriccherry"] = spawnstruct();
	level.machine_assets["specialty_electriccherry"].weapon = getweapon("zombie_perk_bottle_cherry");
	level.machine_assets["specialty_electriccherry"].off_model = "p7_zm_vending_nuke";
	level.machine_assets["specialty_electriccherry"].on_model = "p7_zm_vending_nuke";
}

/*
	Name: electric_cherry_register_clientfield
	Namespace: zm_perk_electric_cherry
	Checksum: 0xD936F383
	Offset: 0x880
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function electric_cherry_register_clientfield()
{
	clientfield::register("clientuimodel", "hudItems.perks.electric_cherry", 1, 2, "int");
}

/*
	Name: electric_cherry_set_clientfield
	Namespace: zm_perk_electric_cherry
	Checksum: 0xFB26C83C
	Offset: 0x8C0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function electric_cherry_set_clientfield(state)
{
	self clientfield::set_player_uimodel("hudItems.perks.electric_cherry", state);
}

/*
	Name: electric_cherry_perk_machine_setup
	Namespace: zm_perk_electric_cherry
	Checksum: 0xD9458972
	Offset: 0x8F8
	Size: 0xBC
	Parameters: 4
	Flags: Linked
*/
function electric_cherry_perk_machine_setup(use_trigger, perk_machine, bump_trigger, collision)
{
	use_trigger.script_sound = "mus_perks_stamin_jingle";
	use_trigger.script_string = "marathon_perk";
	use_trigger.script_label = "mus_perks_stamin_sting";
	use_trigger.target = "vending_marathon";
	perk_machine.script_string = "marathon_perk";
	perk_machine.targetname = "vending_marathon";
	if(isdefined(bump_trigger))
	{
		bump_trigger.script_string = "marathon_perk";
	}
}

/*
	Name: init_electric_cherry
	Namespace: zm_perk_electric_cherry
	Checksum: 0x441BA4D1
	Offset: 0x9C0
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function init_electric_cherry()
{
	level._effect["electric_cherry_explode"] = "dlc1/castle/fx_castle_electric_cherry_down";
	level.custom_laststand_func = &electric_cherry_laststand;
	zombie_utility::set_zombie_var("tesla_head_gib_chance", 50);
	clientfield::register("allplayers", "electric_cherry_reload_fx", 1, 2, "int");
	clientfield::register("actor", "tesla_death_fx", 1, 1, "int");
	clientfield::register("vehicle", "tesla_death_fx_veh", 10000, 1, "int");
	clientfield::register("actor", "tesla_shock_eyes_fx", 1, 1, "int");
	clientfield::register("vehicle", "tesla_shock_eyes_fx_veh", 10000, 1, "int");
}

/*
	Name: electric_cherry_perk_machine_think
	Namespace: zm_perk_electric_cherry
	Checksum: 0x34CB633C
	Offset: 0xB10
	Size: 0x268
	Parameters: 0
	Flags: None
*/
function electric_cherry_perk_machine_think()
{
	init_electric_cherry();
	while(true)
	{
		machine = getentarray("vendingelectric_cherry", "targetname");
		machine_triggers = getentarray("vending_electriccherry", "target");
		for(i = 0; i < machine.size; i++)
		{
			machine[i] setmodel("p7_zm_vending_nuke");
		}
		level thread zm_perks::do_initial_power_off_callback(machine, "electriccherry");
		array::thread_all(machine_triggers, &zm_perks::set_power_on, 0);
		level waittill(#"electric_cherry_on");
		for(i = 0; i < machine.size; i++)
		{
			machine[i] setmodel("p7_zm_vending_nuke");
			machine[i] vibrate(vectorscale((0, -1, 0), 100), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread zm_perks::perk_fx("electriccherry");
			machine[i] thread zm_perks::play_loop_on_machine();
		}
		level notify(#"specialty_grenadepulldeath_power_on");
		array::thread_all(machine_triggers, &zm_perks::set_power_on, 1);
		level waittill(#"electric_cherry_off");
		array::thread_all(machine_triggers, &zm_perks::turn_perk_off);
	}
}

/*
	Name: electric_cherry_host_migration_func
	Namespace: zm_perk_electric_cherry
	Checksum: 0x1C6161F7
	Offset: 0xD80
	Size: 0x10A
	Parameters: 0
	Flags: None
*/
function electric_cherry_host_migration_func()
{
	a_electric_cherry_perk_machines = getentarray("vending_electriccherry", "targetname");
	foreach(perk_machine in a_electric_cherry_perk_machines)
	{
		if(isdefined(perk_machine.model) && perk_machine.model == "p7_zm_vending_nuke")
		{
			perk_machine zm_perks::perk_fx(undefined, 1);
			perk_machine thread zm_perks::perk_fx("electriccherry");
		}
	}
}

/*
	Name: electric_cherry_laststand
	Namespace: zm_perk_electric_cherry
	Checksum: 0x437AE361
	Offset: 0xE98
	Size: 0x232
	Parameters: 0
	Flags: Linked
*/
function electric_cherry_laststand()
{
	visionsetlaststand("zombie_last_stand", 1);
	if(isdefined(self))
	{
		playfx(level._effect["electric_cherry_explode"], self.origin);
		self playsound("zmb_cherry_explode");
		self notify(#"electric_cherry_start");
		wait(0.05);
		a_zombies = zombie_utility::get_round_enemy_array();
		a_zombies = util::get_array_of_closest(self.origin, a_zombies, undefined, undefined, 500);
		for(i = 0; i < a_zombies.size; i++)
		{
			if(isalive(self) && isalive(a_zombies[i]))
			{
				if(a_zombies[i].health <= 1000)
				{
					a_zombies[i] thread electric_cherry_death_fx();
					if(isdefined(self.cherry_kills))
					{
						self.cherry_kills++;
					}
					self zm_score::add_to_player_score(40);
				}
				else
				{
					a_zombies[i] thread electric_cherry_stun();
					a_zombies[i] thread electric_cherry_shock_fx();
				}
				wait(0.1);
				a_zombies[i] dodamage(1000, self.origin, self, self, "none");
			}
		}
		self notify(#"electric_cherry_end");
	}
}

/*
	Name: electric_cherry_death_fx
	Namespace: zm_perk_electric_cherry
	Checksum: 0xEB513D4
	Offset: 0x10D8
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function electric_cherry_death_fx()
{
	self endon(#"death");
	self playsound("zmb_elec_jib_zombie");
	if(!(isdefined(self.head_gibbed) && self.head_gibbed))
	{
		if(isvehicle(self))
		{
			self clientfield::set("tesla_shock_eyes_fx_veh", 1);
		}
		else
		{
			self clientfield::set("tesla_shock_eyes_fx", 1);
		}
	}
	else
	{
		if(isvehicle(self))
		{
			self clientfield::set("tesla_death_fx_veh", 1);
		}
		else
		{
			self clientfield::set("tesla_death_fx", 1);
		}
	}
}

/*
	Name: electric_cherry_shock_fx
	Namespace: zm_perk_electric_cherry
	Checksum: 0xC9729BC5
	Offset: 0x11E0
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function electric_cherry_shock_fx()
{
	self endon(#"death");
	if(isvehicle(self))
	{
		self clientfield::set("tesla_shock_eyes_fx_veh", 1);
	}
	else
	{
		self clientfield::set("tesla_shock_eyes_fx", 1);
	}
	self playsound("zmb_elec_jib_zombie");
	self waittill(#"stun_fx_end");
	if(isvehicle(self))
	{
		self clientfield::set("tesla_shock_eyes_fx_veh", 0);
	}
	else
	{
		self clientfield::set("tesla_shock_eyes_fx", 0);
	}
}

/*
	Name: electric_cherry_stun
	Namespace: zm_perk_electric_cherry
	Checksum: 0xAB067F48
	Offset: 0x12D8
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function electric_cherry_stun()
{
	self endon(#"death");
	self notify(#"stun_zombie");
	self endon(#"stun_zombie");
	if(self.health <= 0)
	{
		/#
			iprintln("");
		#/
		return;
	}
	if(self.ai_state !== "zombie_think")
	{
		return;
	}
	self.zombie_tesla_hit = 1;
	self.ignoreall = 1;
	wait(4);
	if(isdefined(self))
	{
		self.zombie_tesla_hit = 0;
		self.ignoreall = 0;
		self notify(#"stun_fx_end");
	}
}

/*
	Name: electric_cherry_reload_attack
	Namespace: zm_perk_electric_cherry
	Checksum: 0x53E5867C
	Offset: 0x13A0
	Size: 0x4A6
	Parameters: 0
	Flags: Linked
*/
function electric_cherry_reload_attack()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon("specialty_electriccherry" + "_stop");
	self.wait_on_reload = [];
	self.consecutive_electric_cherry_attacks = 0;
	while(true)
	{
		self waittill(#"reload_start");
		current_weapon = self getcurrentweapon();
		if(isinarray(self.wait_on_reload, current_weapon))
		{
			continue;
		}
		self.wait_on_reload[self.wait_on_reload.size] = current_weapon;
		self.consecutive_electric_cherry_attacks++;
		n_clip_current = 1;
		n_clip_max = 10;
		n_fraction = n_clip_current / n_clip_max;
		perk_radius = math::linear_map(n_fraction, 1, 0, 32, 128);
		perk_dmg = math::linear_map(n_fraction, 1, 0, 1, 1045);
		self thread check_for_reload_complete(current_weapon);
		if(isdefined(self))
		{
			switch(self.consecutive_electric_cherry_attacks)
			{
				case 0:
				case 1:
				{
					n_zombie_limit = undefined;
					break;
				}
				case 2:
				{
					n_zombie_limit = 8;
					break;
				}
				case 3:
				{
					n_zombie_limit = 4;
					break;
				}
				case 4:
				{
					n_zombie_limit = 2;
					break;
				}
				default:
				{
					n_zombie_limit = 0;
				}
			}
			self thread electric_cherry_cooldown_timer(current_weapon);
			if(isdefined(n_zombie_limit) && n_zombie_limit == 0)
			{
				continue;
			}
			self thread electric_cherry_reload_fx(n_fraction);
			self notify(#"electric_cherry_start");
			self playsound("zmb_cherry_explode");
			a_zombies = zombie_utility::get_round_enemy_array();
			a_zombies = util::get_array_of_closest(self.origin, a_zombies, undefined, undefined, perk_radius);
			n_zombies_hit = 0;
			for(i = 0; i < a_zombies.size; i++)
			{
				if(isalive(self) && isalive(a_zombies[i]))
				{
					if(isdefined(n_zombie_limit))
					{
						if(n_zombies_hit < n_zombie_limit)
						{
							n_zombies_hit++;
						}
						else
						{
							break;
						}
					}
					if(a_zombies[i].health <= perk_dmg)
					{
						a_zombies[i] thread electric_cherry_death_fx();
						if(isdefined(self.cherry_kills))
						{
							self.cherry_kills++;
						}
						self zm_score::add_to_player_score(40);
					}
					else
					{
						if(!isdefined(a_zombies[i].is_brutus))
						{
							a_zombies[i] thread electric_cherry_stun();
						}
						a_zombies[i] thread electric_cherry_shock_fx();
					}
					wait(0.1);
					if(isdefined(a_zombies[i]) && isalive(a_zombies[i]))
					{
						a_zombies[i] dodamage(perk_dmg, self.origin, self, self, "none");
					}
				}
			}
			self notify(#"electric_cherry_end");
		}
	}
}

/*
	Name: electric_cherry_cooldown_timer
	Namespace: zm_perk_electric_cherry
	Checksum: 0xEFF8F650
	Offset: 0x1850
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function electric_cherry_cooldown_timer(current_weapon)
{
	self notify(#"electric_cherry_cooldown_started");
	self endon(#"electric_cherry_cooldown_started");
	self endon(#"death");
	self endon(#"disconnect");
	n_reload_time = 0.25;
	if(self hasperk("specialty_fastreload"))
	{
		n_reload_time = n_reload_time * getdvarfloat("perk_weapReloadMultiplier");
	}
	n_cooldown_time = n_reload_time + 3;
	wait(n_cooldown_time);
	self.consecutive_electric_cherry_attacks = 0;
}

/*
	Name: check_for_reload_complete
	Namespace: zm_perk_electric_cherry
	Checksum: 0x8B499772
	Offset: 0x1920
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function check_for_reload_complete(weapon)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon("player_lost_weapon_" + weapon.name);
	self thread weapon_replaced_monitor(weapon);
	while(true)
	{
		self waittill(#"reload");
		current_weapon = self getcurrentweapon();
		if(current_weapon == weapon)
		{
			arrayremovevalue(self.wait_on_reload, weapon);
			self notify("weapon_reload_complete_" + weapon.name);
			break;
		}
	}
}

/*
	Name: weapon_replaced_monitor
	Namespace: zm_perk_electric_cherry
	Checksum: 0xA73BD877
	Offset: 0x1A00
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function weapon_replaced_monitor(weapon)
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon("weapon_reload_complete_" + weapon.name);
	while(true)
	{
		self waittill(#"weapon_change");
		primaryweapons = self getweaponslistprimaries();
		if(!isinarray(primaryweapons, weapon))
		{
			self notify("player_lost_weapon_" + weapon.name);
			arrayremovevalue(self.wait_on_reload, weapon);
			break;
		}
	}
}

/*
	Name: electric_cherry_reload_fx
	Namespace: zm_perk_electric_cherry
	Checksum: 0x387B6F04
	Offset: 0x1AD8
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function electric_cherry_reload_fx(n_fraction)
{
	if(n_fraction >= 0.67)
	{
		codesetclientfield(self, "electric_cherry_reload_fx", 1);
	}
	else
	{
		if(n_fraction >= 0.33 && n_fraction < 0.67)
		{
			codesetclientfield(self, "electric_cherry_reload_fx", 2);
		}
		else
		{
			codesetclientfield(self, "electric_cherry_reload_fx", 3);
		}
	}
	wait(1);
	codesetclientfield(self, "electric_cherry_reload_fx", 0);
}

/*
	Name: electric_cherry_perk_lost
	Namespace: zm_perk_electric_cherry
	Checksum: 0x3108134D
	Offset: 0x1BB8
	Size: 0x34
	Parameters: 3
	Flags: Linked
*/
function electric_cherry_perk_lost(b_pause, str_perk, str_result)
{
	self notify("specialty_electriccherry" + "_stop");
}

