// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_challenges_tomb;
#using scripts\zm\zm_tomb_capture_zones;
#using scripts\zm\zm_tomb_challenges;
#using scripts\zm\zm_tomb_chamber;
#using scripts\zm\zm_tomb_craftables;
#using scripts\zm\zm_tomb_tank;
#using scripts\zm\zm_tomb_teleporter;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;

#namespace zm_tomb_utility;

/*
	Name: setup_devgui
	Namespace: zm_tomb_utility
	Checksum: 0x2A9D9605
	Offset: 0x9C0
	Size: 0x894
	Parameters: 0
	Flags: Linked
*/
function setup_devgui()
{
	/#
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		setdvar("", "");
		execdevgui("");
		zm_devgui::add_custom_devgui_callback(&zombie_devgui_tomb);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		level thread watch_devgui_quadrotor();
		level thread watch_devgui_complete_puzzles();
		level thread function_d88b52e6();
		level thread watch_for_upgraded_staffs();
		level thread function_6f935c89();
		level thread function_23eb2509();
	#/
}

/*
	Name: zombie_devgui_tomb
	Namespace: zm_tomb_utility
	Checksum: 0x4A7558AB
	Offset: 0x1260
	Size: 0x14A
	Parameters: 1
	Flags: Linked
*/
function zombie_devgui_tomb(cmd)
{
	/#
		cmd_strings = strtok(cmd, "");
		switch(cmd_strings[0])
		{
			case "":
			{
				level notify(#"force_recapture_start");
				break;
			}
			case "":
			case "":
			case "":
			case "":
			case "":
			case "":
			{
				level notify(#"force_zone_capture", int(getsubstr(cmd_strings[0], 19)));
				break;
			}
			case "":
			case "":
			case "":
			case "":
			case "":
			case "":
			{
				level notify(#"force_zone_recapture", int(getsubstr(cmd_strings[0], 21)));
				break;
			}
		}
	#/
}

/*
	Name: function_23eb2509
	Namespace: zm_tomb_utility
	Checksum: 0xCF051245
	Offset: 0x13B8
	Size: 0x138
	Parameters: 0
	Flags: Linked
*/
function function_23eb2509()
{
	/#
		while(true)
		{
			if(getdvarstring("") != "")
			{
				n_zone = int(getdvarstring(""));
				level notify(#"force_zone_capture", n_zone);
				setdvar("", "");
			}
			if(getdvarstring("") != "")
			{
				n_zone = int(getdvarstring(""));
				level notify(#"force_zone_recapture", n_zone);
				setdvar("", "");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: function_6f935c89
	Namespace: zm_tomb_utility
	Checksum: 0x4A3631CA
	Offset: 0x14F8
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_6f935c89()
{
	/#
		while(true)
		{
			if(getdvarstring("") == "")
			{
				zm_tomb_capture_zones::function_b0debead();
				setdvar("", "");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: watch_for_upgraded_staffs
	Namespace: zm_tomb_utility
	Checksum: 0xABE7D99B
	Offset: 0x1578
	Size: 0x1B6
	Parameters: 0
	Flags: Linked
*/
function watch_for_upgraded_staffs()
{
	/#
		cmd = "";
		while(true)
		{
			wait(0.25);
			if(!isdefined(level.zombie_devgui_gun) || level.zombie_devgui_gun != cmd)
			{
				a_players = getplayers();
				foreach(player in a_players)
				{
					has_upgraded_staff = 0;
					a_w_weapons = player getweaponslist();
					foreach(w_weapon in a_w_weapons)
					{
						if(is_weapon_upgraded_staff(w_weapon))
						{
							has_upgraded_staff = 1;
						}
					}
					if(has_upgraded_staff)
					{
						player update_staff_accessories();
					}
				}
			}
		}
	#/
}

/*
	Name: function_d88b52e6
	Namespace: zm_tomb_utility
	Checksum: 0xEC0C90CA
	Offset: 0x1738
	Size: 0xCB8
	Parameters: 0
	Flags: Linked
*/
function function_d88b52e6()
{
	/#
		while(true)
		{
			if(getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
			}
			if(getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "")
			{
				level flag::set("");
				level waittill(#"little_girl_lost_step_1_over");
				level waittill(#"hash_e6967d42");
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
			}
			if(getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "")
			{
				level flag::set("");
				level waittill(#"little_girl_lost_step_2_over");
				level waittill(#"hash_4c5352e3");
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
			}
			if(getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "")
			{
				level flag::set("");
				var_5e72b36d = getent("", "");
				if(isdefined(var_5e72b36d))
				{
					var_5e72b36d delete();
				}
				t_hole = getent("", "");
				if(isdefined(t_hole))
				{
					t_hole delete();
				}
				level waittill(#"little_girl_lost_step_3_over");
				level waittill(#"hash_7bcf8600");
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
			}
			if(getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				level waittill(#"little_girl_lost_step_4_over");
				level waittill(#"hash_4f3f0441");
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
			}
			if(getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "")
			{
				level flag::set("");
				level waittill(#"little_girl_lost_step_5_over");
				level waittill(#"hash_8b0d379e");
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
			}
			if(getdvarstring("") == "" || getdvarstring("") == "" || getdvarstring("") == "")
			{
				level flag::set("");
				level waittill(#"little_girl_lost_step_6_over");
				level waittill(#"hash_ee01811f");
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
			}
			if(getdvarstring("") == "" || getdvarstring("") == "")
			{
				level flag::set("");
				level waittill(#"little_girl_lost_step_7_over");
				level waittill(#"hash_7f00c03c");
			}
			if(getdvarstring("") == "")
			{
				setdvar("", "");
				iprintlnbold("");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				level waittill(#"hash_738ebd3d");
				setdvar("", "");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: watch_devgui_complete_puzzles
	Namespace: zm_tomb_utility
	Checksum: 0xF65521E3
	Offset: 0x23F8
	Size: 0xA18
	Parameters: 0
	Flags: Linked
*/
function watch_devgui_complete_puzzles()
{
	/#
		while(true)
		{
			if(getdvarstring("") == "" || getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				level flag::set("");
				level flag::set("");
				level flag::set("");
				setdvar("", "");
				level notify(#"open_all_gramophone_doors");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				level flag::set("");
				level flag::set("");
				level flag::set("");
				level flag::set("");
				level flag::set("");
				level flag::set("");
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				level flag::set("");
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				level flag::set("");
				setdvar("", "");
			}
			if(getdvarstring("") == "")
			{
				zm_tomb_teleporter::stargate_teleport_enable(1);
				zm_tomb_teleporter::stargate_teleport_enable(2);
				zm_tomb_teleporter::stargate_teleport_enable(3);
				zm_tomb_teleporter::stargate_teleport_enable(4);
				setdvar("", "");
				level flag::set("");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: get_teleport_fx_from_enum
	Namespace: zm_tomb_utility
	Checksum: 0xE56D3E9F
	Offset: 0x2E18
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function get_teleport_fx_from_enum(n_enum)
{
	switch(n_enum)
	{
		case 1:
		{
			return "teleport_fire";
		}
		case 4:
		{
			return "teleport_ice";
		}
		case 3:
		{
			return "teleport_elec";
		}
		case 2:
		default:
		{
			return "teleport_air";
		}
	}
}

/*
	Name: watch_devgui_quadrotor
	Namespace: zm_tomb_utility
	Checksum: 0xCCC294F6
	Offset: 0x2E88
	Size: 0x1A2
	Parameters: 0
	Flags: Linked
*/
function watch_devgui_quadrotor()
{
	/#
		while(getdvarstring("") != "")
		{
			wait(0.1);
		}
		players = getplayers();
		foreach(player in players)
		{
			player zm_equipment::set_player_equipment("");
			player giveweapon("");
			player setweaponammoclip("", 1);
			player thread zm_equipment::show_hint("");
			player notify("" + "");
			player zm_equipment::set_equipment_invisibility_to_player("", 1);
			player setactionslot(1, "", "");
		}
	#/
}

/*
	Name: include_craftable
	Namespace: zm_tomb_utility
	Checksum: 0xEDCA92AE
	Offset: 0x3038
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function include_craftable(craftable_struct)
{
	/#
		println("" + craftable_struct.name);
	#/
	zm_craftables::include_zombie_craftable(craftable_struct);
}

/*
	Name: is_craftable
	Namespace: zm_tomb_utility
	Checksum: 0xC9F248DC
	Offset: 0x3098
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function is_craftable()
{
	return self zm_craftables::is_craftable();
}

/*
	Name: is_part_crafted
	Namespace: zm_tomb_utility
	Checksum: 0xAB6AD5C4
	Offset: 0x30C0
	Size: 0x2A
	Parameters: 2
	Flags: None
*/
function is_part_crafted(craftable_name, part_modelname)
{
	return zm_craftables::is_part_crafted(craftable_name, part_modelname);
}

/*
	Name: wait_for_craftable
	Namespace: zm_tomb_utility
	Checksum: 0x8DE399FB
	Offset: 0x30F8
	Size: 0x2E
	Parameters: 1
	Flags: None
*/
function wait_for_craftable(craftable_name)
{
	level waittill(craftable_name + "_crafted", player);
	return player;
}

/*
	Name: check_solo_status
	Namespace: zm_tomb_utility
	Checksum: 0x2CD72F6C
	Offset: 0x3130
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function check_solo_status()
{
	if(getnumexpectedplayers() == 1 && zm_utility::is_solo_ranked_game() || (getnumexpectedplayers() == 1 && !sessionmodeisonlinegame()))
	{
		level.is_forever_solo_game = 1;
	}
	else
	{
		level.is_forever_solo_game = 0;
	}
}

/*
	Name: player_slow_movement_speed_monitor
	Namespace: zm_tomb_utility
	Checksum: 0x96A32454
	Offset: 0x31B8
	Size: 0x2F8
	Parameters: 0
	Flags: Linked
*/
function player_slow_movement_speed_monitor()
{
	self endon(#"disconnect");
	n_movescale_delta_no_perk = 0.35 / 10;
	n_movescale_delta_staminup = 0.25 / 6;
	n_new_move_scale = 1;
	n_move_scale_delta = 1;
	self.n_move_scale = n_new_move_scale;
	while(true)
	{
		is_player_slowed = 0;
		self.is_player_slowed = 0;
		foreach(area in level.a_e_slow_areas)
		{
			if(self istouching(area))
			{
				self clientfield::set_to_player("sndMudSlow", 1);
				self allowslide(0);
				is_player_slowed = 1;
				self.is_player_slowed = 1;
				if(!(isdefined(self.played_mud_vo) && self.played_mud_vo) && (!(isdefined(self.dontspeak) && self.dontspeak)))
				{
					self thread zm_tomb_vo::struggle_mud_vo();
				}
				if(self hasperk("specialty_staminup"))
				{
					n_new_move_scale = 0.75;
					n_move_scale_delta = n_movescale_delta_staminup;
				}
				else
				{
					n_new_move_scale = 0.65;
					n_move_scale_delta = n_movescale_delta_no_perk;
				}
				break;
			}
		}
		if(!is_player_slowed)
		{
			self clientfield::set_to_player("sndMudSlow", 0);
			self notify(#"mud_slowdown_cleared");
			self allowslide(1);
			n_new_move_scale = 1;
		}
		if(self.n_move_scale != n_new_move_scale)
		{
			if(self.n_move_scale > (n_new_move_scale + n_move_scale_delta))
			{
				self.n_move_scale = self.n_move_scale - n_move_scale_delta;
			}
			else
			{
				self.n_move_scale = n_new_move_scale;
			}
			self setmovespeedscale(self.n_move_scale);
		}
		wait(0.1);
	}
}

/*
	Name: dug_zombie_spawn_init
	Namespace: zm_tomb_utility
	Checksum: 0x2854F82F
	Offset: 0x34B8
	Size: 0x55E
	Parameters: 1
	Flags: Linked
*/
function dug_zombie_spawn_init(animname_set = 0)
{
	self.targetname = "zombie";
	self.script_noteworthy = undefined;
	if(!animname_set)
	{
		self.animname = "zombie";
	}
	if(isdefined(zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")]]();
	}
	self thread zm_spawner::play_ambient_zombie_vocals();
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.allowdeath = 1;
	self.force_gib = 1;
	self.is_zombie = 1;
	self.missinglegs = 0;
	self allowedstances("stand");
	self.zombie_damaged_by_bar_knockdown = 0;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self setphysparams(15, 0, 72);
	self.disablearrivals = 1;
	self.disableexits = 1;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoresuppression = 1;
	self.suppressionthreshold = 1;
	self.nododgemove = 1;
	self.dontshootwhilemoving = 1;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatinitialized = 0;
	self.a.disablepain = 1;
	self zm_utility::disable_react();
	if(isdefined(level.zombie_health))
	{
		self.maxhealth = level.zombie_health;
		if(isdefined(level.a_zombie_respawn_health[self.archetype]) && level.a_zombie_respawn_health[self.archetype].size > 0)
		{
			self.health = level.a_zombie_respawn_health[self.archetype][0];
			arrayremovevalue(level.a_zombie_respawn_health[self.archetype], level.a_zombie_respawn_health[self.archetype][0]);
		}
		else
		{
			self.health = level.zombie_health;
		}
	}
	else
	{
		self.maxhealth = level.zombie_vars["zombie_health_start"];
		self.health = self.maxhealth;
	}
	self.freezegun_damage = 0;
	level thread zm_spawner::zombie_death_event(self);
	self zm_utility::init_zombie_run_cycle();
	self thread dug_zombie_think();
	self thread zombie_utility::zombie_gib_on_damage();
	self thread zm_spawner::zombie_damage_failsafe();
	self thread zm_spawner::enemy_death_detection();
	if(isdefined(level._zombie_custom_spawn_logic))
	{
		if(isarray(level._zombie_custom_spawn_logic))
		{
			for(i = 0; i < level._zombie_custom_spawn_logic.size; i++)
			{
				self thread [[level._zombie_custom_spawn_logic[i]]]();
			}
		}
		else
		{
			self thread [[level._zombie_custom_spawn_logic]]();
		}
	}
	if(!isdefined(self.no_eye_glow) || !self.no_eye_glow)
	{
		if(!(isdefined(self.is_inert) && self.is_inert))
		{
			self thread zombie_utility::delayed_zombie_eye_glow();
		}
	}
	self.deathfunction = &zm_spawner::zombie_death_animscript;
	self.flame_damage_time = 0;
	self.meleedamage = 60;
	self.no_powerups = 1;
	self zm_spawner::zombie_history(("zombie_spawn_init -> Spawned = ") + self.origin);
	self.thundergun_knockdown_func = level.basic_zombie_thundergun_knockdown;
	self.tesla_head_gib_func = &zm_spawner::zombie_tesla_head_gib;
	self.team = level.zombie_team;
	if(isdefined(zm_utility::get_gamemode_var("post_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("post_init_zombie_spawn_func")]]();
	}
	if(isdefined(level.zombie_init_done))
	{
		self [[level.zombie_init_done]]();
	}
	self.zombie_init_done = 1;
	self notify(#"zombie_init_done");
}

/*
	Name: dug_zombie_think
	Namespace: zm_tomb_utility
	Checksum: 0x9FCD31D6
	Offset: 0x3A20
	Size: 0x5C4
	Parameters: 0
	Flags: Linked
*/
function dug_zombie_think()
{
	self endon(#"death");
	/#
		assert(!self.isdog);
	#/
	self.ai_state = "zombie_think";
	find_flesh_struct_string = undefined;
	self waittill(#"zombie_custom_think_done", find_flesh_struct_string);
	node = undefined;
	desired_nodes = [];
	self.entrance_nodes = [];
	if(isdefined(level.max_barrier_search_dist_override))
	{
		max_dist = level.max_barrier_search_dist_override;
	}
	else
	{
		max_dist = 500;
	}
	if(!isdefined(find_flesh_struct_string) && isdefined(self.target) && self.target != "")
	{
		desired_origin = zombie_utility::get_desired_origin();
		/#
			assert(isdefined(desired_origin), ("" + self.origin) + "");
		#/
		origin = desired_origin;
		node = arraygetclosest(origin, level.exterior_goals);
		self.entrance_nodes[self.entrance_nodes.size] = node;
		self zm_spawner::zombie_history(("zombie_think -> #1 entrance (script_forcegoal) origin = ") + self.entrance_nodes[0].origin);
	}
	else
	{
		if(self zm_spawner::should_skip_teardown(find_flesh_struct_string))
		{
			self zm_spawner::zombie_setup_attack_properties();
			if(isdefined(self.target))
			{
				end_at_node = getnode(self.target, "targetname");
				if(isdefined(end_at_node))
				{
					self setgoalnode(end_at_node);
					self waittill(#"goal");
				}
			}
			if(isdefined(self.start_inert) && self.start_inert)
			{
				self zm_spawner::zombie_complete_emerging_into_playable_area();
			}
			else
			{
				self thread dug_zombie_entered_playable();
			}
			return;
		}
		if(isdefined(find_flesh_struct_string))
		{
			/#
				/#
					assert(isdefined(find_flesh_struct_string));
				#/
			#/
			for(i = 0; i < level.exterior_goals.size; i++)
			{
				if(level.exterior_goals[i].script_string == find_flesh_struct_string)
				{
					node = level.exterior_goals[i];
					break;
				}
			}
			self.entrance_nodes[self.entrance_nodes.size] = node;
			self zm_spawner::zombie_history(("zombie_think -> #1 entrance origin = ") + node.origin);
			self thread zm_spawner::zombie_assure_node();
		}
		else
		{
			origin = self.origin;
			desired_origin = zombie_utility::get_desired_origin();
			if(isdefined(desired_origin))
			{
				origin = desired_origin;
			}
			nodes = util::get_array_of_closest(origin, level.exterior_goals, undefined, 3);
			desired_nodes[0] = nodes[0];
			prev_dist = distance(self.origin, nodes[0].origin);
			for(i = 1; i < nodes.size; i++)
			{
				dist = distance(self.origin, nodes[i].origin);
				if((dist - prev_dist) > max_dist)
				{
					break;
				}
				prev_dist = dist;
				desired_nodes[i] = nodes[i];
			}
			node = desired_nodes[0];
			if(desired_nodes.size > 1)
			{
				node = desired_nodes[randomint(desired_nodes.size)];
			}
			self.entrance_nodes = desired_nodes;
			self zm_spawner::zombie_history(("zombie_think -> #1 entrance origin = ") + node.origin);
			self thread zm_spawner::zombie_assure_node();
		}
	}
	/#
		assert(isdefined(node), "");
	#/
	level thread zm_utility::draw_line_ent_to_pos(self, node.origin, "goal");
	self.first_node = node;
	self thread zm_spawner::zombie_goto_entrance(node);
}

/*
	Name: dug_zombie_entered_playable
	Namespace: zm_tomb_utility
	Checksum: 0xA4F88784
	Offset: 0x3FF0
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function dug_zombie_entered_playable()
{
	self endon(#"death");
	if(!isdefined(level.playable_areas))
	{
		level.playable_areas = getentarray("player_volume", "script_noteworthy");
	}
	while(true)
	{
		foreach(area in level.playable_areas)
		{
			if(self istouching(area))
			{
				self dug_zombie_complete_emerging_into_playable_area();
				return;
			}
		}
		wait(1);
	}
}

/*
	Name: dug_zombie_complete_emerging_into_playable_area
	Namespace: zm_tomb_utility
	Checksum: 0x68F439CC
	Offset: 0x40F0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function dug_zombie_complete_emerging_into_playable_area()
{
	self.completed_emerging_into_playable_area = 1;
	self notify(#"completed_emerging_into_playable_area");
	self.no_powerups = 1;
	self thread zm_spawner::zombie_free_cam_allowed();
}

/*
	Name: dug_zombie_rise
	Namespace: zm_tomb_utility
	Checksum: 0xBD244430
	Offset: 0x4140
	Size: 0x24C
	Parameters: 2
	Flags: Linked
*/
function dug_zombie_rise(spot, func_rise_fx = &zm_spawner::zombie_rise_fx)
{
	self endon(#"death");
	self.in_the_ground = 1;
	self.no_eye_glow = 1;
	if(!isdefined(spot.angles))
	{
		spot.angles = (0, 0, 0);
	}
	target_org = zombie_utility::get_desired_origin();
	if(isdefined(target_org))
	{
		spot.angles = vectortoangles(target_org - spot.origin);
	}
	level thread zombie_utility::zombie_rise_death(self, spot);
	spot thread [[func_rise_fx]](self);
	substate = 0;
	if(self.zombie_move_speed == "walk")
	{
		substate = randomint(2);
	}
	else
	{
		if(self.zombie_move_speed == "run")
		{
			substate = 2;
		}
		else if(self.zombie_move_speed == "sprint")
		{
			substate = 3;
		}
	}
	self playsound("zmb_vocals_capzomb_spawn");
	self function_f356818(spot);
	self notify(#"rise_anim_finished");
	spot notify(#"stop_zombie_rise_fx");
	self.in_the_ground = 0;
	self.no_eye_glow = 0;
	self thread zombie_utility::zombie_eye_glow();
	self notify(#"risen", spot.script_string);
	self.zombie_think_done = 1;
	self zm_spawner::zombie_complete_emerging_into_playable_area();
}

/*
	Name: function_f356818
	Namespace: zm_tomb_utility
	Checksum: 0xA7280003
	Offset: 0x4398
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function function_f356818(spot)
{
	self endon(#"death");
	self endon(#"hash_59e307f3");
	self thread function_4eb9088(2);
	spot scene::play("scene_zm_dlc5_zombie_traverse_ground_dugup", self);
	self notify(#"hash_59e307f3");
}

/*
	Name: function_4eb9088
	Namespace: zm_tomb_utility
	Checksum: 0x37AA8F06
	Offset: 0x4410
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function function_4eb9088(timeout)
{
	self endon(#"death");
	self endon(#"hash_59e307f3");
	wait(timeout);
	self notify(#"hash_59e307f3");
}

/*
	Name: is_weapon_upgraded_staff
	Namespace: zm_tomb_utility
	Checksum: 0x4975966E
	Offset: 0x4450
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function is_weapon_upgraded_staff(w_weapon)
{
	switch(w_weapon.name)
	{
		case "staff_air_upgraded":
		case "staff_fire_upgraded":
		case "staff_lightning_upgraded":
		case "staff_water_upgraded":
		{
			return true;
		}
		default:
		{
			return false;
		}
	}
}

/*
	Name: watch_staff_usage
	Namespace: zm_tomb_utility
	Checksum: 0x67F67E30
	Offset: 0x44B8
	Size: 0x390
	Parameters: 0
	Flags: Linked
*/
function watch_staff_usage()
{
	self notify(#"watch_staff_usage");
	self endon(#"watch_staff_usage");
	self endon(#"disconnect");
	self clientfield::set_to_player("player_staff_charge", 0);
	while(true)
	{
		self waittill(#"weapon_change", weapon);
		has_upgraded_staff = 0;
		has_revive_staff = 0;
		weapon_is_upgraded_staff = is_weapon_upgraded_staff(weapon);
		str_upgraded_staff_weapon = undefined;
		a_str_weapons = self getweaponslist();
		foreach(str_weapon in a_str_weapons)
		{
			if(is_weapon_upgraded_staff(str_weapon))
			{
				has_upgraded_staff = 1;
				str_upgraded_staff_weapon = str_weapon;
			}
			if(str_weapon.name == "staff_revive")
			{
				has_revive_staff = 1;
			}
		}
		/#
			if(has_upgraded_staff && !has_revive_staff)
			{
				has_revive_staff = 1;
			}
		#/
		if(has_upgraded_staff && !has_revive_staff)
		{
			self takeweapon(str_upgraded_staff_weapon);
			has_upgraded_staff = 0;
		}
		if(!has_upgraded_staff && has_revive_staff)
		{
			self takeweapon(getweapon("staff_revive"));
			has_revive_staff = 0;
		}
		if(!has_revive_staff || (!weapon_is_upgraded_staff && "none" != weapon.name && "none" != weapon.altweapon.name))
		{
			self setactionslot(3, "altmode");
			self clientfield::set_player_uimodel("hudItems.showDpadLeft_Staff", 0);
			self clientfield::set_player_uimodel("hudItems.dpadLeftAmmo", 0);
			self notify(#"hash_75edd128");
		}
		else
		{
			self setactionslot(3, "weapon", getweapon("staff_revive"));
			self clientfield::set_player_uimodel("hudItems.showDpadLeft_Staff", 1);
			self thread function_38af9e8e();
		}
		if(weapon_is_upgraded_staff)
		{
			self thread staff_charge_watch_wrapper(weapon);
		}
	}
}

/*
	Name: function_38af9e8e
	Namespace: zm_tomb_utility
	Checksum: 0x3AFB7AE9
	Offset: 0x4850
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function function_38af9e8e()
{
	self notify(#"hash_38af9e8e");
	self endon(#"hash_38af9e8e");
	self endon(#"hash_75edd128");
	self endon(#"disconnect");
	while(true)
	{
		ammo = self getammocount(level.var_2b2f83e5);
		self clientfield::set_player_uimodel("hudItems.dpadLeftAmmo", ammo);
		wait(0.05);
	}
}

/*
	Name: staff_charge_watch
	Namespace: zm_tomb_utility
	Checksum: 0x1BCF530E
	Offset: 0x48F0
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function staff_charge_watch()
{
	self endon(#"disconnect");
	self endon(#"player_downed");
	self endon(#"weapon_change");
	self endon(#"weapon_fired");
	while(!self attackbuttonpressed())
	{
		wait(0.05);
	}
	n_old_charge = 0;
	while(true)
	{
		if(n_old_charge != self.chargeshotlevel)
		{
			self clientfield::set_to_player("player_staff_charge", self.chargeshotlevel);
			n_old_charge = self.chargeshotlevel;
		}
		wait(0.1);
	}
}

/*
	Name: staff_charge_watch_wrapper
	Namespace: zm_tomb_utility
	Checksum: 0x8990F836
	Offset: 0x49B8
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function staff_charge_watch_wrapper(weapon)
{
	self notify(#"staff_charge_watch_wrapper");
	self endon(#"staff_charge_watch_wrapper");
	self endon(#"disconnect");
	self clientfield::set_to_player("player_staff_charge", 0);
	while(is_weapon_upgraded_staff(weapon))
	{
		self staff_charge_watch();
		self clientfield::set_to_player("player_staff_charge", 0);
		weapon = self getcurrentweapon();
	}
}

/*
	Name: door_record_hint
	Namespace: zm_tomb_utility
	Checksum: 0x2FDC93F4
	Offset: 0x4A88
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function door_record_hint()
{
	hud = setting_tutorial_hud();
	hud settext(&"ZM_TOMB_RU");
	wait(3);
	hud destroy();
}

/*
	Name: swap_staff_hint
	Namespace: zm_tomb_utility
	Checksum: 0x975C8F17
	Offset: 0x4AF0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function swap_staff_hint()
{
	level notify(#"staff_hint");
	hud = setting_tutorial_hud();
	hud settext(&"ZM_TOMB_OSO");
	level util::waittill_any_timeout(3, "staff_hint");
	hud destroy();
}

/*
	Name: door_gramophone_elsewhere_hint
	Namespace: zm_tomb_utility
	Checksum: 0xFD998FEB
	Offset: 0x4B88
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function door_gramophone_elsewhere_hint()
{
	hud = setting_tutorial_hud();
	hud settext(&"ZM_TOMB_GREL");
	wait(3);
	hud destroy();
}

/*
	Name: puzzle_debug_position
	Namespace: zm_tomb_utility
	Checksum: 0x64327085
	Offset: 0x4BF0
	Size: 0x146
	Parameters: 5
	Flags: Linked
*/
function puzzle_debug_position(string_to_show, color, origin, str_dvar, n_show_time)
{
	/#
		self endon(#"death");
		self endon(#"stop_debug_position");
		if(!isdefined(string_to_show))
		{
			string_to_show = "";
		}
		if(!isdefined(color))
		{
			color = vectorscale((1, 1, 1), 255);
		}
		if(isdefined(str_dvar))
		{
			while(getdvarstring("") != "")
			{
				wait(1);
			}
		}
		while(true)
		{
			if(isdefined(origin))
			{
				where_to_draw = origin;
			}
			else
			{
				where_to_draw = self.origin;
			}
			print3d(where_to_draw, string_to_show, color, 1);
			wait(0.1);
			if(isdefined(n_show_time))
			{
				n_show_time = n_show_time - 0.1;
				if(n_show_time <= 0)
				{
					break;
				}
			}
		}
	#/
}

/*
	Name: placeholder_puzzle_delete_ent
	Namespace: zm_tomb_utility
	Checksum: 0x513B87A7
	Offset: 0x4D40
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function placeholder_puzzle_delete_ent(str_flag_name)
{
	self endon(#"death");
	level flag::wait_till(str_flag_name);
	self delete();
}

/*
	Name: placeholder_puzzle_spin_model
	Namespace: zm_tomb_utility
	Checksum: 0xDC1CCF12
	Offset: 0x4D90
	Size: 0x40
	Parameters: 0
	Flags: None
*/
function placeholder_puzzle_spin_model()
{
	self endon(#"death");
	while(true)
	{
		self rotateyaw(360, 10, 0, 0);
		wait(9.9);
	}
}

/*
	Name: setting_tutorial_hud
	Namespace: zm_tomb_utility
	Checksum: 0x7ACCF5AF
	Offset: 0x4DD8
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function setting_tutorial_hud()
{
	client_hint = newclienthudelem(self);
	client_hint.alignx = "center";
	client_hint.aligny = "middle";
	client_hint.horzalign = "center";
	client_hint.vertalign = "bottom";
	client_hint.y = -120;
	client_hint.foreground = 1;
	client_hint.font = "default";
	client_hint.fontscale = 1.5;
	client_hint.alpha = 1;
	client_hint.color = (1, 1, 1);
	return client_hint;
}

/*
	Name: tomb_trigger_update_message
	Namespace: zm_tomb_utility
	Checksum: 0x380532DC
	Offset: 0x4ED8
	Size: 0x142
	Parameters: 1
	Flags: Linked
*/
function tomb_trigger_update_message(func_per_player_msg)
{
	a_players = getplayers();
	foreach(e_player in a_players)
	{
		n_player = e_player getentitynumber();
		if(!isdefined(self.stub.playertrigger[n_player]))
		{
			continue;
		}
		new_msg = self [[func_per_player_msg]](e_player);
		self.stub.playertrigger[n_player].stored_hint_string = new_msg;
		self.stub.playertrigger[n_player] sethintstring(new_msg);
	}
}

/*
	Name: set_unitrigger_hint_string
	Namespace: zm_tomb_utility
	Checksum: 0x333D009C
	Offset: 0x5028
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function set_unitrigger_hint_string(str_message)
{
	self.hint_string = str_message;
	zm_unitrigger::unregister_unitrigger(self);
	zm_unitrigger::register_unitrigger(self, &tomb_unitrigger_think);
}

/*
	Name: tomb_spawn_trigger_radius
	Namespace: zm_tomb_utility
	Checksum: 0xFF19AB6A
	Offset: 0x5080
	Size: 0x148
	Parameters: 5
	Flags: Linked
*/
function tomb_spawn_trigger_radius(origin, radius, use_trigger = 0, var_3fe858d9, func_visibility)
{
	trigger_stub = spawnstruct();
	trigger_stub.origin = origin;
	trigger_stub.radius = radius;
	if(use_trigger)
	{
		trigger_stub.cursor_hint = "HINT_NOICON";
		trigger_stub.script_unitrigger_type = "unitrigger_radius_use";
	}
	else
	{
		trigger_stub.script_unitrigger_type = "unitrigger_radius";
	}
	if(isdefined(var_3fe858d9))
	{
		trigger_stub.func_update_msg = var_3fe858d9;
		zm_unitrigger::unitrigger_force_per_player_triggers(trigger_stub, 1);
	}
	if(isdefined(func_visibility))
	{
		trigger_stub.prompt_and_visibility_func = func_visibility;
	}
	zm_unitrigger::register_unitrigger(trigger_stub, &tomb_unitrigger_think);
	return trigger_stub;
}

/*
	Name: tomb_unitrigger_think
	Namespace: zm_tomb_utility
	Checksum: 0x65BA8BA1
	Offset: 0x51D0
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function tomb_unitrigger_think()
{
	self endon(#"kill_trigger");
	if(isdefined(self.stub.func_update_msg))
	{
		self thread tomb_trigger_update_message(self.stub.func_update_msg);
	}
	while(true)
	{
		self waittill(#"trigger", player);
		self.stub notify(#"trigger", player);
	}
}

/*
	Name: tomb_unitrigger_delete
	Namespace: zm_tomb_utility
	Checksum: 0x1685DB52
	Offset: 0x5260
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function tomb_unitrigger_delete()
{
	zm_unitrigger::unregister_unitrigger(self);
}

/*
	Name: zombie_gib_all
	Namespace: zm_tomb_utility
	Checksum: 0x42FCB0AB
	Offset: 0x5288
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function zombie_gib_all()
{
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.is_mechz) && self.is_mechz)
	{
		return;
	}
	a_gib_ref = [];
	a_gib_ref[0] = level._zombie_gib_piece_index_all;
	self gib("normal", a_gib_ref);
	self ghost();
	wait(0.4);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: zombie_gib_guts
	Namespace: zm_tomb_utility
	Checksum: 0x3ACBEFA1
	Offset: 0x5340
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function zombie_gib_guts()
{
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.is_mechz) && self.is_mechz)
	{
		return;
	}
	v_origin = self gettagorigin("J_SpineLower");
	if(isdefined(v_origin))
	{
		v_forward = anglestoforward((0, randomint(360), 0));
		playfx(level._effect["zombie_guts_explosion"], v_origin, v_forward);
	}
	util::wait_network_frame();
	if(isdefined(self))
	{
		self ghost();
		wait(randomfloatrange(0.4, 1.1));
		if(isdefined(self))
		{
			self delete();
		}
	}
}

/*
	Name: link_platform_nodes
	Namespace: zm_tomb_utility
	Checksum: 0x33755F6E
	Offset: 0x5478
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function link_platform_nodes(nd_1, nd_2)
{
	if(!nodesarelinked(nd_1, nd_2))
	{
		zm_utility::link_nodes(nd_1, nd_2);
	}
	if(!nodesarelinked(nd_2, nd_1))
	{
		zm_utility::link_nodes(nd_2, nd_1);
	}
}

/*
	Name: unlink_platform_nodes
	Namespace: zm_tomb_utility
	Checksum: 0xF4787734
	Offset: 0x5508
	Size: 0x84
	Parameters: 2
	Flags: None
*/
function unlink_platform_nodes(nd_1, nd_2)
{
	if(nodesarelinked(nd_1, nd_2))
	{
		zm_utility::unlink_nodes(nd_1, nd_2);
	}
	if(nodesarelinked(nd_2, nd_1))
	{
		zm_utility::unlink_nodes(nd_2, nd_1);
	}
}

/*
	Name: init_weather_manager
	Namespace: zm_tomb_utility
	Checksum: 0x663C1168
	Offset: 0x5598
	Size: 0x186
	Parameters: 0
	Flags: Linked
*/
function init_weather_manager()
{
	level.weather_snow = 0;
	level.weather_rain = 0;
	level.weather_fog = 0;
	level.weather_vision = 0;
	level thread weather_manager();
	level thread rotate_skydome();
	callback::on_connect(&set_weather_to_player);
	level.force_weather = [];
	level.force_weather[1] = "none";
	if(math::cointoss())
	{
		level.force_weather[3] = "snow";
	}
	else
	{
		level.force_weather[4] = "snow";
	}
	for(i = 5; i <= 9; i++)
	{
		if(math::cointoss())
		{
			level.force_weather[i] = "none";
			continue;
		}
		level.force_weather[i] = "rain";
	}
	level.force_weather[10] = "snow";
	level notify(#"hash_149fa2ac");
}

/*
	Name: randomize_weather
	Namespace: zm_tomb_utility
	Checksum: 0x9886E581
	Offset: 0x5728
	Size: 0x1E0
	Parameters: 0
	Flags: Linked
*/
function randomize_weather()
{
	weather_name = level.force_weather[level.round_number];
	if(!isdefined(weather_name))
	{
		n_round_weather = randomint(100);
		rounds_since_snow = level.round_number - level.last_snow_round;
		rounds_since_rain = level.round_number - level.last_rain_round;
		if(n_round_weather < 40 || rounds_since_snow > 3)
		{
			weather_name = "snow";
		}
		else
		{
			if(n_round_weather < 80 || rounds_since_rain > 4)
			{
				weather_name = "rain";
			}
			else
			{
				weather_name = "none";
			}
		}
	}
	if(weather_name == "snow")
	{
		level.weather_snow = randomintrange(1, 5);
		level.weather_rain = 0;
		level.weather_vision = 2;
		level.last_snow_round = level.round_number;
	}
	else
	{
		if(weather_name == "rain")
		{
			level.weather_snow = 0;
			level.weather_rain = randomintrange(1, 5);
			level.weather_vision = 1;
			level.last_rain_round = level.round_number;
		}
		else
		{
			level.weather_snow = 0;
			level.weather_rain = 0;
			level.weather_vision = 3;
		}
	}
}

/*
	Name: weather_manager
	Namespace: zm_tomb_utility
	Checksum: 0x660D8A09
	Offset: 0x5910
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function weather_manager()
{
	level.last_snow_round = 0;
	level.last_rain_round = 0;
	level waittill(#"hash_149fa2ac");
	while(true)
	{
		randomize_weather();
		level clientfield::set("rain_level", level.weather_rain);
		level clientfield::set("snow_level", level.weather_snow);
		wait(2);
		foreach(player in getplayers())
		{
			if(zombie_utility::is_player_valid(player, 0, 1))
			{
				player set_weather_to_player();
			}
		}
		level waittill(#"end_of_round");
	}
}

/*
	Name: set_weather_to_player
	Namespace: zm_tomb_utility
	Checksum: 0xF8C4E0B7
	Offset: 0x5A78
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function set_weather_to_player()
{
	self clientfield::set_to_player("player_weather_visionset", level.weather_vision);
	switch(level.weather_vision)
	{
		case 3:
		{
			level util::set_lighting_state(0);
			break;
		}
		case 1:
		{
			level util::set_lighting_state(0);
			break;
		}
		case 2:
		{
			level util::set_lighting_state(1);
			break;
		}
	}
}

/*
	Name: rotate_skydome
	Namespace: zm_tomb_utility
	Checksum: 0x61B9F14E
	Offset: 0x5B30
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function rotate_skydome()
{
	level.sky_rotation = 360;
	while(true)
	{
		level.sky_rotation = level.sky_rotation - 0;
		if(level.sky_rotation < 0)
		{
			level.sky_rotation = level.sky_rotation + 360;
		}
		setdvar("r_skyRotation", level.sky_rotation);
		wait(0.1);
	}
}

/*
	Name: play_puzzle_stinger_on_all_players
	Namespace: zm_tomb_utility
	Checksum: 0x99EC1590
	Offset: 0x5BB8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function play_puzzle_stinger_on_all_players()
{
}

/*
	Name: puzzle_orb_move
	Namespace: zm_tomb_utility
	Checksum: 0x760BD61D
	Offset: 0x5BC8
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function puzzle_orb_move(v_to_pos)
{
	dist = distance(self.origin, v_to_pos);
	if(dist == 0)
	{
		return;
	}
	movetime = dist / 300;
	self moveto(v_to_pos, movetime, 0, 0);
	self waittill(#"movedone");
}

/*
	Name: puzzle_orb_follow_path
	Namespace: zm_tomb_utility
	Checksum: 0x140F6DBA
	Offset: 0x5C60
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function puzzle_orb_follow_path(s_start)
{
	s_next_pos = s_start;
	while(isdefined(s_next_pos))
	{
		self puzzle_orb_move(s_next_pos.origin);
		if(isdefined(s_next_pos.target))
		{
			s_next_pos = struct::get(s_next_pos.target, "targetname");
		}
		else
		{
			s_next_pos = undefined;
		}
	}
}

/*
	Name: puzzle_orb_follow_return_path
	Namespace: zm_tomb_utility
	Checksum: 0x2205778E
	Offset: 0x5D00
	Size: 0x1D2
	Parameters: 2
	Flags: Linked
*/
function puzzle_orb_follow_return_path(s_start, n_element)
{
	a_path = [];
	s_next = s_start;
	while(isdefined(s_next))
	{
		a_path[a_path.size] = s_next;
		if(isdefined(s_next.target))
		{
			s_next = struct::get(s_next.target, "targetname");
		}
		else
		{
			s_next = undefined;
		}
	}
	v_start = (a_path[a_path.size - 1].origin) + vectorscale((0, 0, 1), 1000);
	e_model = spawn("script_model", v_start);
	e_model setmodel(s_start.model);
	e_model clientfield::set("element_glow_fx", n_element);
	playfxontag(level._effect["puzzle_orb_trail"], e_model, "tag_origin");
	for(i = a_path.size - 1; i >= 0; i--)
	{
		e_model puzzle_orb_move(a_path[i].origin);
	}
	return e_model;
}

/*
	Name: puzzle_orb_pillar_show
	Namespace: zm_tomb_utility
	Checksum: 0x48F4CFF5
	Offset: 0x5EE0
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function puzzle_orb_pillar_show()
{
	level notify(#"sky_pillar_reset");
	level endon(#"sky_pillar_reset");
	s_pillar = struct::get("crypt_pillar", "targetname");
	exploder::exploder("fxexp_333");
	level thread exploder::stop_after_duration("fxexp_333", 28.5);
	if(isdefined(s_pillar.e_model))
	{
		s_pillar.e_model delete();
	}
	s_pillar.e_model = spawn("script_model", s_pillar.origin);
	s_pillar.e_model endon(#"death");
	s_pillar.e_model ghost();
	s_pillar.e_model setmodel("fxuse_sky_pillar_new");
	s_pillar.e_model clientfield::set("sky_pillar", 1);
	util::wait_network_frame();
	s_pillar.e_model show();
	wait(1);
	wait(27.5);
	s_pillar.e_model clientfield::set("sky_pillar", 0);
	wait(1);
	s_pillar.e_model delete();
}

/*
	Name: any_player_looking_at_plinth
	Namespace: zm_tomb_utility
	Checksum: 0x90265519
	Offset: 0x60F0
	Size: 0x184
	Parameters: 2
	Flags: Linked
*/
function any_player_looking_at_plinth(min_lookat_dot, n_near_dist_sq)
{
	players = getplayers();
	foreach(player in players)
	{
		dist_sq = distance2dsquared(player.origin, self.origin);
		if(dist_sq < n_near_dist_sq)
		{
			fvec = anglestoforward(player.angles);
			to_self = self.origin - player.origin;
			to_self = vectornormalize(to_self);
			dot_to_self = vectordot(to_self, fvec);
			if(dot_to_self > min_lookat_dot)
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: puzzle_orb_ready_to_leave
	Namespace: zm_tomb_utility
	Checksum: 0x34097C5
	Offset: 0x6280
	Size: 0x72
	Parameters: 3
	Flags: Linked
*/
function puzzle_orb_ready_to_leave(str_zone, min_lookat_dot, n_near_dist_sq)
{
	if(!level.zones[str_zone].is_occupied || level flag::get("chamber_puzzle_cheat"))
	{
		return 1;
	}
	return any_player_looking_at_plinth(min_lookat_dot, n_near_dist_sq);
}

/*
	Name: puzzle_orb_chamber_to_crypt
	Namespace: zm_tomb_utility
	Checksum: 0xAC22EF58
	Offset: 0x6300
	Size: 0x660
	Parameters: 2
	Flags: Linked
*/
function puzzle_orb_chamber_to_crypt(str_start_point, e_gem_pos)
{
	a_puzzle_flags = strtok(e_gem_pos.script_flag, " ");
	/#
		assert(a_puzzle_flags.size == 2);
	#/
	foreach(str_flag in a_puzzle_flags)
	{
		/#
			assert(level flag::exists(str_flag));
		#/
	}
	level flag::wait_till(a_puzzle_flags[0]);
	s_start = struct::get(str_start_point, "targetname");
	e_model = spawn("script_model", s_start.origin);
	e_model setmodel(s_start.model);
	e_model.script_int = e_gem_pos.script_int;
	util::wait_network_frame();
	e_model playsound("zmb_squest_crystal_leave");
	util::wait_network_frame();
	e_model playloopsound("zmb_squest_crystal_loop", 1);
	str_zone = zm_zonemgr::get_zone_from_position(s_start.origin, 1);
	time_looking_at_orb = 0;
	min_lookat_dot = cos(30);
	n_near_dist_sq = 32400;
	while(time_looking_at_orb < 1)
	{
		wait(0.1);
		if(s_start puzzle_orb_ready_to_leave(str_zone, min_lookat_dot, n_near_dist_sq))
		{
			time_looking_at_orb = time_looking_at_orb + 0.1;
		}
		else
		{
			time_looking_at_orb = 0;
		}
	}
	util::wait_network_frame();
	playfxontag(level._effect["puzzle_orb_trail"], e_model, "tag_origin");
	util::wait_network_frame();
	s_next_pos = struct::get(s_start.target, "targetname");
	e_model puzzle_orb_follow_path(s_next_pos);
	v_sky_pos = e_model.origin;
	v_sky_pos = (v_sky_pos[0], v_sky_pos[1], v_sky_pos[2] + 1000);
	e_model puzzle_orb_move(v_sky_pos);
	e_model ghost();
	s_descend_start = struct::get("orb_crypt_descent_path", "targetname");
	v_pos_above_gem = s_descend_start.origin + vectorscale((0, 0, 1), 3000);
	e_model moveto(v_pos_above_gem, 0.05, 0, 0);
	e_model waittill(#"movedone");
	level flag::wait_till(a_puzzle_flags[1]);
	e_model show();
	level thread puzzle_orb_pillar_show();
	e_model puzzle_orb_follow_path(s_descend_start);
	level flag::set("disc_rotation_active");
	e_model puzzle_orb_move(e_gem_pos.origin);
	e_model_nofx = spawn("script_model", e_model.origin);
	e_model_nofx setmodel(e_model.model);
	e_model_nofx.script_int = e_gem_pos.script_int;
	e_model delete();
	util::wait_network_frame();
	e_model_nofx playsound("zmb_squest_crystal_arrive");
	util::wait_network_frame();
	e_model_nofx playloopsound("zmb_squest_crystal_loop", 1);
	level flag::clear("disc_rotation_active");
	return e_model_nofx;
}

/*
	Name: capture_zombie_spawn_init
	Namespace: zm_tomb_utility
	Checksum: 0x7D7E225A
	Offset: 0x6968
	Size: 0x4CA
	Parameters: 1
	Flags: Linked
*/
function capture_zombie_spawn_init(animname_set = 0)
{
	self.targetname = "capture_zombie_ai";
	if(!animname_set)
	{
		self.animname = "zombie";
	}
	self.sndname = "capzomb";
	if(isdefined(zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")]]();
	}
	self thread zm_spawner::play_ambient_zombie_vocals();
	self.zmb_vocals_attack = "zmb_vocals_capzomb_attack";
	self.no_damage_points = 1;
	self.deathpoints_already_given = 1;
	self.ignore_enemy_count = 1;
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.allowdeath = 1;
	self.force_gib = 1;
	self.is_zombie = 1;
	self.missinglegs = 0;
	self allowedstances("stand");
	self.zombie_damaged_by_bar_knockdown = 0;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self.disablearrivals = 1;
	self.disableexits = 1;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoresuppression = 1;
	self.suppressionthreshold = 1;
	self.nododgemove = 1;
	self.dontshootwhilemoving = 1;
	self.pathenemylookahead = 0;
	self.badplaceawareness = 0;
	self.chatinitialized = 0;
	self.a.disablepain = 1;
	self zm_utility::disable_react();
	if(isdefined(level.zombie_health))
	{
		self.maxhealth = level.zombie_health;
		if(isdefined(level.a_zombie_respawn_health[self.archetype]) && level.a_zombie_respawn_health[self.archetype].size > 0)
		{
			self.health = level.a_zombie_respawn_health[self.archetype][0];
			arrayremovevalue(level.a_zombie_respawn_health[self.archetype], level.a_zombie_respawn_health[self.archetype][0]);
		}
		else
		{
			self.health = level.zombie_health;
		}
	}
	else
	{
		self.maxhealth = level.zombie_vars["zombie_health_start"];
		self.health = self.maxhealth;
	}
	self.freezegun_damage = 0;
	level thread zm_spawner::zombie_death_event(self);
	self zombie_utility::set_zombie_run_cycle();
	self thread dug_zombie_think();
	self thread zombie_utility::zombie_gib_on_damage();
	self thread zm_spawner::zombie_damage_failsafe();
	self thread zm_spawner::enemy_death_detection();
	if(!isdefined(self.no_eye_glow) || !self.no_eye_glow)
	{
		if(!(isdefined(self.is_inert) && self.is_inert))
		{
			self thread zombie_utility::delayed_zombie_eye_glow();
		}
	}
	self.deathfunction = &zm_spawner::zombie_death_animscript;
	self.flame_damage_time = 0;
	self.meleedamage = 60;
	self.no_powerups = 1;
	self zm_spawner::zombie_history(("zombie_spawn_init -> Spawned = ") + self.origin);
	self.thundergun_knockdown_func = level.basic_zombie_thundergun_knockdown;
	self.tesla_head_gib_func = &zm_spawner::zombie_tesla_head_gib;
	self.team = level.zombie_team;
	if(isdefined(zm_utility::get_gamemode_var("post_init_zombie_spawn_func")))
	{
		self [[zm_utility::get_gamemode_var("post_init_zombie_spawn_func")]]();
	}
	self.zombie_init_done = 1;
	self notify(#"zombie_init_done");
}

/*
	Name: rumble_players_in_chamber
	Namespace: zm_tomb_utility
	Checksum: 0x2FE763C7
	Offset: 0x6E40
	Size: 0x1A2
	Parameters: 2
	Flags: Linked
*/
function rumble_players_in_chamber(n_rumble_enum, n_rumble_time = 0.1)
{
	a_players = getplayers();
	a_rumbled_players = [];
	foreach(e_player in a_players)
	{
		if(zm_tomb_chamber::is_point_in_chamber(e_player.origin))
		{
			e_player clientfield::set_to_player("player_rumble_and_shake", n_rumble_enum);
			a_rumbled_players[a_rumbled_players.size] = e_player;
		}
	}
	wait(n_rumble_time);
	foreach(e_player in a_rumbled_players)
	{
		e_player clientfield::set_to_player("player_rumble_and_shake", 0);
	}
}

/*
	Name: rumble_nearby_players
	Namespace: zm_tomb_utility
	Checksum: 0x750455FF
	Offset: 0x6FF0
	Size: 0x1C2
	Parameters: 3
	Flags: Linked
*/
function rumble_nearby_players(v_center, n_range, n_rumble_enum)
{
	n_range_sq = n_range * n_range;
	a_players = getplayers();
	a_rumbled_players = [];
	foreach(e_player in a_players)
	{
		if(distancesquared(v_center, e_player.origin) < n_range_sq)
		{
			e_player clientfield::set_to_player("player_rumble_and_shake", n_rumble_enum);
			a_rumbled_players[a_rumbled_players.size] = e_player;
		}
	}
	util::wait_network_frame();
	foreach(e_player in a_rumbled_players)
	{
		e_player clientfield::set_to_player("player_rumble_and_shake", 0);
	}
}

/*
	Name: whirlwind_rumble_player
	Namespace: zm_tomb_utility
	Checksum: 0x5EF27798
	Offset: 0x71C0
	Size: 0x200
	Parameters: 2
	Flags: Linked
*/
function whirlwind_rumble_player(e_whirlwind, str_active_flag)
{
	if(isdefined(self.whirlwind_rumble_on) && self.whirlwind_rumble_on)
	{
		return;
	}
	self.whirlwind_rumble_on = 1;
	n_rumble_level = 1;
	self clientfield::set_to_player("player_rumble_and_shake", 4);
	dist_sq = distancesquared(self.origin, e_whirlwind.origin);
	range_inner_sq = 10000;
	range_sq = 90000;
	while(dist_sq < range_sq)
	{
		wait(0.05);
		if(!isdefined(e_whirlwind))
		{
			break;
		}
		if(isdefined(str_active_flag))
		{
			if(!level flag::get(str_active_flag))
			{
				break;
			}
		}
		dist_sq = distancesquared(self.origin, e_whirlwind.origin);
		if(n_rumble_level == 1 && dist_sq < range_inner_sq)
		{
			n_rumble_level = 2;
			self clientfield::set_to_player("player_rumble_and_shake", 5);
		}
		else if(n_rumble_level == 2 && dist_sq >= range_inner_sq)
		{
			n_rumble_level = 1;
			self clientfield::set_to_player("player_rumble_and_shake", 4);
		}
	}
	self clientfield::set_to_player("player_rumble_and_shake", 0);
	self.whirlwind_rumble_on = 0;
}

/*
	Name: whirlwind_rumble_nearby_players
	Namespace: zm_tomb_utility
	Checksum: 0x7B6FFC1F
	Offset: 0x73C8
	Size: 0x148
	Parameters: 1
	Flags: Linked
*/
function whirlwind_rumble_nearby_players(str_active_flag)
{
	range_sq = 90000;
	while(isdefined(self) && level flag::get(str_active_flag))
	{
		a_players = getplayers();
		foreach(player in a_players)
		{
			dist_sq = distancesquared(self.origin, player.origin);
			if(dist_sq < range_sq)
			{
				player thread whirlwind_rumble_player(self, str_active_flag);
			}
		}
		util::wait_network_frame();
	}
}

/*
	Name: clean_up_bunker_doors
	Namespace: zm_tomb_utility
	Checksum: 0xF82FF272
	Offset: 0x7518
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function clean_up_bunker_doors()
{
	a_door_models = getentarray("bunker_door", "script_noteworthy");
	array::thread_all(a_door_models, &bunker_door_clean_up);
}

/*
	Name: bunker_door_clean_up
	Namespace: zm_tomb_utility
	Checksum: 0x52CE0A7
	Offset: 0x7578
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function bunker_door_clean_up()
{
	self waittill(#"movedone");
	self delete();
}

/*
	Name: adjustments_for_solo
	Namespace: zm_tomb_utility
	Checksum: 0xD1C02DE5
	Offset: 0x75A8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function adjustments_for_solo()
{
	if(isdefined(level.is_forever_solo_game) && level.is_forever_solo_game)
	{
		a_door_buys = getentarray("zombie_door", "targetname");
		array::thread_all(a_door_buys, &door_price_reduction_for_solo);
		a_debris_buys = getentarray("zombie_debris", "targetname");
		array::thread_all(a_debris_buys, &door_price_reduction_for_solo);
	}
}

/*
	Name: door_price_reduction_for_solo
	Namespace: zm_tomb_utility
	Checksum: 0x88DA9CD6
	Offset: 0x7670
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function door_price_reduction_for_solo()
{
	if(self.zombie_cost >= 750)
	{
		self.zombie_cost = self.zombie_cost - 250;
		if(self.zombie_cost >= 2500)
		{
			self.zombie_cost = self.zombie_cost - 250;
		}
		if(self.targetname == "zombie_door")
		{
			self zm_utility::set_hint_string(self, "default_buy_door", self.zombie_cost);
		}
		else
		{
			self zm_utility::set_hint_string(self, "default_buy_debris", self.zombie_cost);
		}
	}
}

/*
	Name: change_weapon_cost
	Namespace: zm_tomb_utility
	Checksum: 0xAAEEE198
	Offset: 0x7738
	Size: 0x7C
	Parameters: 2
	Flags: None
*/
function change_weapon_cost(str_weapon, n_cost)
{
	level.zombie_weapons[str_weapon].cost = n_cost;
	level.zombie_weapons[str_weapon].ammo_cost = zm_utility::round_up_to_ten(int(n_cost * 0.5));
}

/*
	Name: zone_capture_powerup
	Namespace: zm_tomb_utility
	Checksum: 0x20FFDDDB
	Offset: 0x77C0
	Size: 0x1EE
	Parameters: 0
	Flags: Linked
*/
function zone_capture_powerup()
{
	while(true)
	{
		level flag::wait_till("zone_capture_in_progress");
		level flag::wait_till_clear("zone_capture_in_progress");
		wait(2);
		foreach(generator in level.zone_capture.zones)
		{
			if(generator flag::get("player_controlled"))
			{
				foreach(uts_box in level.a_uts_challenge_boxes)
				{
					if(uts_box.str_location == "start_bunker")
					{
						if(level.players.size == 1)
						{
							level thread zm_challenges_tomb::open_box(undefined, uts_box, &zm_tomb_challenges::reward_powerup_double_points, -1);
						}
						else
						{
							level thread zm_challenges_tomb::open_box(undefined, uts_box, &zm_tomb_challenges::reward_powerup_zombie_blood, -1);
						}
						return;
					}
				}
			}
		}
	}
}

/*
	Name: traversal_blocker
	Namespace: zm_tomb_utility
	Checksum: 0xD05283A0
	Offset: 0x79B8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function traversal_blocker()
{
	level flag::init("player_near_traversal");
	m_traversal_blocker = getent("traversal_blocker", "targetname");
	m_traversal_blocker thread traversal_blocker_disabler();
	level flag::wait_till_any(array("activate_zone_nml", "player_near_traversal"));
	m_traversal_blocker connectpaths();
	m_traversal_blocker delete();
}

/*
	Name: traversal_blocker_disabler
	Namespace: zm_tomb_utility
	Checksum: 0x1624759B
	Offset: 0x7A88
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function traversal_blocker_disabler()
{
	self endon(#"death");
	pos1 = (-1509, 3912, -168);
	pos2 = (672, 3720, -179);
	b_too_close = 0;
	while(level.round_number < 10 && !b_too_close)
	{
		a_players = getplayers();
		foreach(player in a_players)
		{
			if(distancesquared(player.origin, pos1) < 4096 || distancesquared(player.origin, pos2) < 4096)
			{
				b_too_close = 1;
			}
		}
		wait(1);
	}
	level flag::set("player_near_traversal");
}

/*
	Name: _kill_zombie_network_safe_internal
	Namespace: zm_tomb_utility
	Checksum: 0x9A865B86
	Offset: 0x7C18
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function _kill_zombie_network_safe_internal(e_attacker, str_weapon)
{
	if(!isdefined(self))
	{
		return;
	}
	if(!isalive(self))
	{
		return;
	}
	self.staff_dmg = str_weapon;
	self dodamage(self.health, self.origin, e_attacker, e_attacker, "none", self.kill_damagetype, 0, str_weapon);
}

/*
	Name: _damage_zombie_network_safe_internal
	Namespace: zm_tomb_utility
	Checksum: 0xB5A7433A
	Offset: 0x7CA8
	Size: 0x7C
	Parameters: 3
	Flags: Linked
*/
function _damage_zombie_network_safe_internal(e_attacker, str_weapon, n_damage_amt)
{
	if(!isdefined(self))
	{
		return;
	}
	if(!isalive(self))
	{
		return;
	}
	self dodamage(n_damage_amt, self.origin, e_attacker, e_attacker, "none", self.kill_damagetype, 0, str_weapon);
}

/*
	Name: do_damage_network_safe
	Namespace: zm_tomb_utility
	Checksum: 0xF41BF7AC
	Offset: 0x7D30
	Size: 0x184
	Parameters: 4
	Flags: Linked
*/
function do_damage_network_safe(e_attacker, n_amount, w_damage, str_mod)
{
	if(isstring(w_damage))
	{
		w_damage = getweapon(w_damage);
	}
	if(isdefined(self.is_mechz) && self.is_mechz)
	{
		self dodamage(n_amount, self.origin, e_attacker, e_attacker, "none", str_mod, 0, w_damage);
	}
	else
	{
		if(n_amount < self.health)
		{
			self.kill_damagetype = str_mod;
			zm_net::network_safe_init("dodamage", 6);
			self zm_net::network_choke_action("dodamage", &_damage_zombie_network_safe_internal, e_attacker, w_damage, n_amount);
		}
		else
		{
			self.kill_damagetype = str_mod;
			zm_net::network_safe_init("dodamage_kill", 4);
			self zm_net::network_choke_action("dodamage_kill", &_kill_zombie_network_safe_internal, e_attacker, w_damage);
		}
	}
}

/*
	Name: _throttle_bullet_trace_think
	Namespace: zm_tomb_utility
	Checksum: 0xAA8D93AA
	Offset: 0x7EC0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function _throttle_bullet_trace_think()
{
	do
	{
		level.bullet_traces_this_frame = 0;
		util::wait_network_frame();
	}
	while(1);
}

/*
	Name: bullet_trace_throttled
	Namespace: zm_tomb_utility
	Checksum: 0x1BBF971C
	Offset: 0x7EF8
	Size: 0x92
	Parameters: 3
	Flags: Linked
*/
function bullet_trace_throttled(v_start, v_end, e_ignore)
{
	if(!isdefined(level.bullet_traces_this_frame))
	{
		level thread _throttle_bullet_trace_think();
	}
	while(level.bullet_traces_this_frame >= 2)
	{
		util::wait_network_frame();
	}
	level.bullet_traces_this_frame++;
	return bullettracepassed(v_start, v_end, 0, e_ignore);
}

/*
	Name: function_d39fc97a
	Namespace: zm_tomb_utility
	Checksum: 0x6B987B3A
	Offset: 0x7F98
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function function_d39fc97a(player)
{
	if(isdefined(player.b_teleporting) && player.b_teleporting)
	{
		return false;
	}
	var_de0d565a = 0;
	var_561c025d = 0;
	if(isdefined(player.zone_name))
	{
		if(issubstr(player.zone_name, "zone_chamber"))
		{
			var_de0d565a = 1;
		}
	}
	if(isdefined(self.zone_name))
	{
		if(issubstr(self.zone_name, "zone_chamber"))
		{
			var_561c025d = 1;
		}
	}
	if(var_de0d565a && !var_561c025d)
	{
		return false;
	}
	if(!var_de0d565a && var_561c025d)
	{
		return false;
	}
	return true;
}

/*
	Name: tomb_get_closest_player_using_paths
	Namespace: zm_tomb_utility
	Checksum: 0xC3FD7AF1
	Offset: 0x80A0
	Size: 0x308
	Parameters: 2
	Flags: Linked
*/
function tomb_get_closest_player_using_paths(origin, players)
{
	min_length_to_player = 9999999;
	n_2d_distance_squared = 9999999;
	player_to_return = undefined;
	dist_to_tank = undefined;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(!isdefined(player))
		{
			continue;
		}
		if(isdefined(player.b_already_on_tank) && player.b_already_on_tank)
		{
			if(isdefined(self.b_on_tank) && self.b_on_tank)
			{
				continue;
			}
			else
			{
				if(!isdefined(dist_to_tank))
				{
					length_to_player = self zm_tomb_tank::tomb_get_path_length_to_tank();
					dist_to_tank = length_to_player;
				}
				else
				{
					length_to_player = dist_to_tank;
				}
			}
		}
		else
		{
			if(isdefined(self.b_on_tank) && self.b_on_tank)
			{
				continue;
			}
			if(self function_d39fc97a(player))
			{
				length_to_player = self zm_utility::approximate_path_dist(player);
			}
			else
			{
				length_to_player = undefined;
			}
		}
		if(!isdefined(length_to_player))
		{
			continue;
		}
		if(isdefined(level.validate_enemy_path_length))
		{
			if(length_to_player == 0)
			{
				valid = self thread [[level.validate_enemy_path_length]](player);
				if(!valid)
				{
					continue;
				}
			}
		}
		if(length_to_player < min_length_to_player)
		{
			min_length_to_player = length_to_player;
			player_to_return = player;
			n_2d_distance_squared = distance2dsquared(self.origin, player.origin);
			continue;
		}
		if(length_to_player == min_length_to_player && length_to_player <= 5)
		{
			n_new_distance = distance2dsquared(self.origin, player.origin);
			if(n_new_distance < n_2d_distance_squared)
			{
				min_length_to_player = length_to_player;
				player_to_return = player;
				n_2d_distance_squared = n_new_distance;
			}
		}
	}
	if(players.size > 1 && isdefined(player_to_return))
	{
		if(!(isdefined(player_to_return.b_already_on_tank) && player_to_return.b_already_on_tank))
		{
			self zm_utility::approximate_path_dist(player_to_return);
		}
	}
	return player_to_return;
}

/*
	Name: update_staff_accessories
	Namespace: zm_tomb_utility
	Checksum: 0x558873C
	Offset: 0x83B0
	Size: 0x46C
	Parameters: 1
	Flags: Linked
*/
function update_staff_accessories(n_element_index)
{
	/#
		if(!isdefined(n_element_index))
		{
			n_element_index = 0;
			str_weapon = self getcurrentweapon();
			if(is_weapon_upgraded_staff(str_weapon))
			{
				s_info = zm_tomb_craftables::get_staff_info_from_weapon_name(str_weapon);
				if(isdefined(s_info))
				{
					n_element_index = s_info.enum;
					s_info.charger.is_charged = 1;
				}
			}
		}
	#/
	if(!(isdefined(self.one_inch_punch_flag_has_been_init) && self.one_inch_punch_flag_has_been_init) && !self hasperk("specialty_widowswine"))
	{
		cur_weapon = self zm_utility::get_player_melee_weapon();
		weapon_to_keep = getweapon("knife");
		self.use_staff_melee = 0;
		if(n_element_index != 0)
		{
			staff_info = zm_tomb_craftables::get_staff_info_from_element_index(n_element_index);
			if(staff_info.charger.is_charged)
			{
				staff_info = staff_info.upgrade;
			}
			if(isdefined(staff_info.var_8f5a8751))
			{
				weapon_to_keep = staff_info.var_8f5a8751;
				self.use_staff_melee = 1;
			}
		}
		melee_changed = 0;
		if(cur_weapon != weapon_to_keep)
		{
			self takeweapon(cur_weapon);
			self giveweapon(weapon_to_keep);
			self zm_utility::set_player_melee_weapon(weapon_to_keep);
			melee_changed = 1;
		}
	}
	has_revive = self hasweapon(level.var_2b2f83e5);
	has_upgraded_staff = 0;
	a_weapons = self getweaponslistprimaries();
	staff_info = zm_tomb_craftables::get_staff_info_from_element_index(n_element_index);
	foreach(str_weapon in a_weapons)
	{
		if(is_weapon_upgraded_staff(str_weapon))
		{
			has_upgraded_staff = 1;
		}
	}
	if(has_revive && !has_upgraded_staff)
	{
		self setactionslot(3, "altmode");
		self takeweapon(level.var_2b2f83e5);
	}
	else if(!has_revive && has_upgraded_staff)
	{
		self setactionslot(3, "weapon", level.var_2b2f83e5);
		self giveweapon(level.var_2b2f83e5);
		if(isdefined(staff_info))
		{
			if(isdefined(staff_info.upgrade.revive_ammo_stock))
			{
				self setweaponammostock(level.var_2b2f83e5, staff_info.upgrade.revive_ammo_stock);
				self setweaponammoclip(level.var_2b2f83e5, staff_info.upgrade.revive_ammo_clip);
			}
		}
	}
}

/*
	Name: get_round_enemy_array_wrapper
	Namespace: zm_tomb_utility
	Checksum: 0xB58A33E4
	Offset: 0x8828
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function get_round_enemy_array_wrapper()
{
	if(isdefined(level.custom_get_round_enemy_array_func))
	{
		a_enemies = [[level.custom_get_round_enemy_array_func]]();
	}
	else
	{
		a_enemies = zombie_utility::get_round_enemy_array();
	}
	return a_enemies;
}

/*
	Name: add_ragdoll
	Namespace: zm_tomb_utility
	Checksum: 0x909F2BEE
	Offset: 0x8880
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function add_ragdoll()
{
	level.n_active_ragdolls++;
	wait(1);
	if(level.n_active_ragdolls > 0)
	{
		level.n_active_ragdolls--;
	}
}

/*
	Name: ragdoll_attempt
	Namespace: zm_tomb_utility
	Checksum: 0x1F07AC8C
	Offset: 0x88B8
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function ragdoll_attempt()
{
	if(level.n_active_ragdolls >= 4)
	{
		return false;
	}
	level thread add_ragdoll();
	return true;
}

