// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_weap_one_inch_punch;
#using scripts\zm\zm_tomb_chamber;
#using scripts\zm\zm_tomb_ee_main;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;

#namespace zm_tomb_ee_main_step_6;

/*
	Name: init
	Namespace: zm_tomb_ee_main_step_6
	Checksum: 0x371B8720
	Offset: 0x2F8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function init()
{
	zm_sidequests::declare_sidequest_stage("little_girl_lost", "step_6", &init_stage, &stage_logic, &exit_stage);
}

/*
	Name: init_stage
	Namespace: zm_tomb_ee_main_step_6
	Checksum: 0x6BD11303
	Offset: 0x358
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function init_stage()
{
	level._cur_stage_name = "step_6";
	zm_spawner::add_custom_zombie_spawn_logic(&ruins_fist_glow_monitor);
}

/*
	Name: stage_logic
	Namespace: zm_tomb_ee_main_step_6
	Checksum: 0xCBEE04C9
	Offset: 0x398
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function stage_logic()
{
	/#
		iprintln(level._cur_stage_name + "");
	#/
	level flag::wait_till("ee_all_players_upgraded_punch");
	util::wait_network_frame();
	zm_sidequests::stage_completed("little_girl_lost", level._cur_stage_name);
}

/*
	Name: exit_stage
	Namespace: zm_tomb_ee_main_step_6
	Checksum: 0x4F9359C8
	Offset: 0x420
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function exit_stage(success)
{
	level notify(#"hash_ee01811f");
}

/*
	Name: ruins_fist_glow_monitor
	Namespace: zm_tomb_ee_main_step_6
	Checksum: 0xC8CF38D2
	Offset: 0x448
	Size: 0x240
	Parameters: 0
	Flags: Linked
*/
function ruins_fist_glow_monitor()
{
	if(level flag::get("ee_all_players_upgraded_punch"))
	{
		return;
	}
	if(isdefined(self.zone_name) && self.zone_name == "ug_bottom_zone")
	{
		wait(0.1);
		self clientfield::set("ee_zombie_fist_fx", 1);
		self.has_soul = 1;
		while(isalive(self))
		{
			self waittill(#"damage", amount, inflictor, direction, point, type, tagname, modelname, partname, weapon, idflags);
			if(!isdefined(inflictor.n_ee_punch_souls))
			{
				inflictor.n_ee_punch_souls = 0;
				inflictor.b_punch_upgraded = 0;
			}
			if(self.has_soul && inflictor.n_ee_punch_souls < 20 && isdefined(weapon) && weapon == level.var_653c9585 && (isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area))
			{
				self clientfield::set("ee_zombie_fist_fx", 0);
				self.has_soul = 0;
				playsoundatposition("zmb_squest_punchtime_punched", self.origin);
				inflictor.n_ee_punch_souls++;
				if(inflictor.n_ee_punch_souls == 20)
				{
					level thread spawn_punch_upgrade_tablet(self.origin, inflictor);
				}
			}
		}
	}
}

/*
	Name: spawn_punch_upgrade_tablet
	Namespace: zm_tomb_ee_main_step_6
	Checksum: 0x73DBBD53
	Offset: 0x690
	Size: 0x5EC
	Parameters: 2
	Flags: Linked
*/
function spawn_punch_upgrade_tablet(v_origin, e_player)
{
	m_tablet = spawn("script_model", v_origin + vectorscale((0, 0, 1), 50));
	m_tablet setmodel("p7_zm_ori_tablet_stone");
	m_fx = spawn("script_model", m_tablet.origin);
	m_fx setmodel("tag_origin");
	m_fx setinvisibletoall();
	m_fx setvisibletoplayer(e_player);
	m_tablet linkto(m_fx);
	playfxontag(level._effect["special_glow"], m_fx, "tag_origin");
	m_fx thread rotate_punch_upgrade_tablet();
	m_tablet playloopsound("zmb_squest_punchtime_tablet_loop", 0.5);
	m_tablet setinvisibletoall();
	m_tablet setvisibletoplayer(e_player);
	while(isdefined(e_player) && !e_player istouching(m_tablet))
	{
		wait(0.05);
	}
	m_tablet delete();
	m_fx delete();
	e_player playsound("zmb_squest_punchtime_tablet_pickup");
	if(isdefined(e_player))
	{
		e_player thread hud::fade_to_black_for_x_sec(0, 0.3, 0.5, 0.5, "white");
		a_zombies = getaispeciesarray(level.zombie_team, "all");
		foreach(zombie in a_zombies)
		{
			if(distance2dsquared(e_player.origin, zombie.origin) < 65536 && (!(isdefined(zombie.is_mechz) && zombie.is_mechz)) && (!(isdefined(zombie.missinglegs) && zombie.missinglegs)) && (isdefined(zombie.completed_emerging_into_playable_area) && zombie.completed_emerging_into_playable_area))
			{
				zombie.v_punched_from = e_player.origin;
				zombie animcustom(&_zm_weap_one_inch_punch::knockdown_zombie_animate);
			}
		}
		wait(1);
		e_player.b_punch_upgraded = 1;
		foreach(var_acc90d1d in level.a_elemental_staffs_upgraded)
		{
			if(e_player hasweapon(var_acc90d1d.w_weapon))
			{
				e_player.str_punch_element = var_acc90d1d.w_weapon.element;
			}
		}
		if(!isdefined(e_player.str_punch_element))
		{
			e_player.str_punch_element = "upgraded";
		}
		e_player thread _zm_weap_one_inch_punch::one_inch_punch_melee_attack();
		e_player thread _zm_weap_one_inch_punch::one_inch_punch_melee_attack();
		a_players = getplayers();
		foreach(player in a_players)
		{
			if(!isdefined(player.b_punch_upgraded) || !player.b_punch_upgraded)
			{
				return;
			}
		}
		level flag::set("ee_all_players_upgraded_punch");
	}
}

/*
	Name: rotate_punch_upgrade_tablet
	Namespace: zm_tomb_ee_main_step_6
	Checksum: 0x5AF0206F
	Offset: 0xC88
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function rotate_punch_upgrade_tablet()
{
	self endon(#"death");
	while(true)
	{
		self rotateyaw(360, 5);
		self waittill(#"rotatedone");
	}
}

