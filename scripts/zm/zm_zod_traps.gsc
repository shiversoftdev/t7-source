// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_bb;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_zod_quest;

#using_animtree("generic");

class ctrap 
{
	var m_n_state;
	var m_a_e_heart;
	var m_e_who;
	var m_n_zombie_damage;
	var m_t_damage;
	var m_n_duration_zombie_damage_cooldown;
	var m_n_player_damage;
	var m_n_duration_player_damage_cooldown;
	var var_54d81d07;
	var m_b_discovered;
	var m_n_cost;
	var m_str_trap_available;
	var m_a_t_use;
	var m_str_trap_active;
	var m_str_trap_cooldown;
	var m_str_trap_unavailable;
	var targetname;
	var m_n_duration_active;
	var m_n_duration_cooldown;
	var m_t_rumble;
	var m_s_audio_location;
	var m_b_are_strikers_moving;

	/*
		Name: constructor
		Namespace: ctrap
		Checksum: 0x99EC1590
		Offset: 0x2270
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: ctrap
		Checksum: 0x99EC1590
		Offset: 0x2280
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: function_7e393675
		Namespace: ctrap
		Checksum: 0x98782565
		Offset: 0x1D58
		Size: 0x50E
		Parameters: 1
		Flags: Linked
	*/
	function function_7e393675(n_time)
	{
		switch(m_n_state)
		{
			case 1:
			{
				foreach(e_heart in m_a_e_heart)
				{
					e_heart thread scene::play("p7_fxanim_zm_zod_chain_trap_heart_low_bundle", e_heart);
				}
				break;
			}
			case 2:
			{
				foreach(e_heart in m_a_e_heart)
				{
					e_heart scene::stop("p7_fxanim_zm_zod_chain_trap_heart_low_bundle");
				}
				for(i = 0; i < m_a_e_heart.size; i++)
				{
					e_heart = m_a_e_heart[i];
					if((i + 1) == m_a_e_heart.size)
					{
						e_heart scene::play("p7_fxanim_zm_zod_chain_trap_heart_pull_bundle", e_heart);
						continue;
					}
					e_heart thread scene::play("p7_fxanim_zm_zod_chain_trap_heart_pull_bundle", e_heart);
				}
				n_wait = n_time / 3;
				foreach(e_heart in m_a_e_heart)
				{
					e_heart thread scene::play("p7_fxanim_zm_zod_chain_trap_heart_low_bundle", e_heart);
				}
				wait(n_wait);
				foreach(e_heart in m_a_e_heart)
				{
					e_heart scene::stop("p7_fxanim_zm_zod_chain_trap_heart_low_bundle");
					e_heart thread scene::play("p7_fxanim_zm_zod_chain_trap_heart_med_bundle", e_heart);
				}
				wait(n_wait);
				foreach(e_heart in m_a_e_heart)
				{
					e_heart scene::stop("p7_fxanim_zm_zod_chain_trap_heart_med_bundle");
					e_heart thread scene::play("p7_fxanim_zm_zod_chain_trap_heart_fast_bundle", e_heart);
				}
				wait(n_wait);
				foreach(e_heart in m_a_e_heart)
				{
					e_heart scene::stop("p7_fxanim_zm_zod_chain_trap_heart_fast_bundle");
				}
				foreach(e_heart in m_a_e_heart)
				{
					e_heart thread scene::play("p7_fxanim_zm_zod_chain_trap_heart_low_bundle", e_heart);
				}
				break;
			}
			case 3:
			{
				break;
			}
			case 0:
			{
				break;
			}
		}
	}

	/*
		Name: hint_string
		Namespace: ctrap
		Checksum: 0x2FBB851F
		Offset: 0x1CD0
		Size: 0x7C
		Parameters: 2
		Flags: Linked
	*/
	function hint_string(string, cost)
	{
		if(isdefined(cost))
		{
			self sethintstring(string, cost);
		}
		else
		{
			self sethintstring(string);
		}
		self setcursorhint("HINT_NOICON");
	}

	/*
		Name: update_chain_animation
		Namespace: ctrap
		Checksum: 0xD20AFD6
		Offset: 0x1C90
		Size: 0x34
		Parameters: 0
		Flags: Linked
	*/
	function update_chain_animation()
	{
		m_a_e_heart[0] clientfield::set("trap_chain_state", m_n_state);
	}

	/*
		Name: trap_death_nonplayer
		Namespace: ctrap
		Checksum: 0x1C926487
		Offset: 0x1BA0
		Size: 0xE4
		Parameters: 1
		Flags: Linked
	*/
	function trap_death_nonplayer(ent)
	{
		if(!isvehicle(ent) && ent.team != "allies")
		{
			ent.a.gib_ref = array::random(array("guts", "right_arm", "left_arm", "head"));
			ent thread zombie_death::do_gib();
			if(isplayer(m_e_who))
			{
				m_e_who zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_KILL_TRAP");
			}
		}
	}

	/*
		Name: trap_damage_nonplayer
		Namespace: ctrap
		Checksum: 0xA86C9C3B
		Offset: 0x19C0
		Size: 0x1D2
		Parameters: 1
		Flags: Linked
	*/
	function trap_damage_nonplayer(ent)
	{
		ent endon(#"death");
		if(isdefined(ent.trap_damage_cooldown))
		{
			return;
		}
		ent.trap_damage_cooldown = 1;
		if(isdefined(ent.maxhealth) && m_n_zombie_damage >= ent.maxhealth && !isvehicle(ent))
		{
			trap_death_nonplayer(ent);
			ent dodamage(ent.maxhealth * 0.5, ent.origin, m_t_damage, m_t_damage, "MOD_GRENADE");
			wait(m_n_duration_zombie_damage_cooldown);
			trap_death_nonplayer(ent);
			ent dodamage(ent.maxhealth, ent.origin, m_t_damage, m_t_damage, "MOD_GRENADE");
			ent.trap_damage_cooldown = undefined;
		}
		else
		{
			trap_death_nonplayer(ent);
			ent dodamage(m_n_zombie_damage, ent.origin, m_t_damage, m_t_damage, "MOD_GRENADE");
			wait(m_n_duration_zombie_damage_cooldown);
			ent.trap_damage_cooldown = undefined;
		}
	}

	/*
		Name: trap_damage_player
		Namespace: ctrap
		Checksum: 0x3C64BFA
		Offset: 0x1880
		Size: 0x132
		Parameters: 1
		Flags: Linked
	*/
	function trap_damage_player(ent)
	{
		ent endon(#"death");
		ent endon(#"disconnect");
		if(ent laststand::player_is_in_laststand())
		{
			return;
		}
		if(isdefined(ent.trap_damage_cooldown))
		{
			return;
		}
		ent.trap_damage_cooldown = 1;
		if(!ent hasperk("specialty_armorvest") || (ent.health - 100) < 1)
		{
			ent dodamage(m_n_player_damage, ent.origin);
			ent.trap_damage_cooldown = undefined;
		}
		else
		{
			ent dodamage(m_n_player_damage / 2, ent.origin);
			wait(m_n_duration_player_damage_cooldown);
			ent.trap_damage_cooldown = undefined;
		}
	}

	/*
		Name: trap_damage
		Namespace: ctrap
		Checksum: 0x10350FC0
		Offset: 0x1710
		Size: 0x168
		Parameters: 0
		Flags: Linked
	*/
	function trap_damage()
	{
		self endon(#"trap_done");
		m_t_damage._trap_type = "chain";
		while(true)
		{
			m_t_damage waittill(#"trigger", ent);
			m_t_damage.activated_by_player = m_e_who;
			if(isplayer(ent))
			{
				if(ent getstance() == "prone" || ent isonslide())
				{
					continue;
				}
				thread trap_damage_player(ent);
			}
			else
			{
				if(isdefined(ent.marked_for_death))
				{
					continue;
				}
				if(isdefined(ent.missinglegs) && ent.missinglegs)
				{
					continue;
				}
				if(isdefined(ent.var_de36fc8))
				{
					ent [[ent.var_de36fc8]](self);
					continue;
				}
				thread trap_damage_nonplayer(ent);
			}
		}
	}

	/*
		Name: trap_unavailable
		Namespace: ctrap
		Checksum: 0x9F6A23C4
		Offset: 0x16D0
		Size: 0x34
		Parameters: 0
		Flags: Linked
	*/
	function trap_unavailable()
	{
		m_t_damage setinvisibletoall();
		m_t_damage triggerenable(0);
	}

	/*
		Name: trap_cooldown
		Namespace: ctrap
		Checksum: 0xCE326D45
		Offset: 0x1690
		Size: 0x34
		Parameters: 0
		Flags: Linked
	*/
	function trap_cooldown()
	{
		m_t_damage setinvisibletoall();
		m_t_damage triggerenable(0);
	}

	/*
		Name: trap_active
		Namespace: ctrap
		Checksum: 0x46D92123
		Offset: 0x1618
		Size: 0x6C
		Parameters: 0
		Flags: Linked
	*/
	function trap_active()
	{
		/#
			println("");
		#/
		m_t_damage setvisibletoall();
		m_t_damage triggerenable(1);
		thread trap_damage();
	}

	/*
		Name: trap_available
		Namespace: ctrap
		Checksum: 0x944AFDAA
		Offset: 0x15D8
		Size: 0x34
		Parameters: 0
		Flags: Linked
	*/
	function trap_available()
	{
		m_t_damage setinvisibletoall();
		m_t_damage triggerenable(0);
	}

	/*
		Name: trap_update_state
		Namespace: ctrap
		Checksum: 0x17A3AA36
		Offset: 0x1520
		Size: 0xAE
		Parameters: 0
		Flags: Linked
	*/
	function trap_update_state()
	{
		switch(m_n_state)
		{
			case 1:
			{
				[[ self ]]->trap_available();
				break;
			}
			case 2:
			{
				[[ self ]]->trap_active();
				self notify(#"trap_start");
				break;
			}
			case 3:
			{
				[[ self ]]->trap_cooldown();
				self notify(#"trap_done");
				break;
			}
			case 0:
			{
				[[ self ]]->trap_unavailable();
				self notify(#"trap_done");
				break;
			}
		}
	}

	/*
		Name: switch_unavailable
		Namespace: ctrap
		Checksum: 0x3FE25A4E
		Offset: 0x14E0
		Size: 0x34
		Parameters: 1
		Flags: Linked
	*/
	function switch_unavailable(t_use)
	{
		self thread update_chain_animation();
	}

	/*
		Name: switch_cooldown
		Namespace: ctrap
		Checksum: 0xFABC8336
		Offset: 0x13D8
		Size: 0xFC
		Parameters: 1
		Flags: Linked
	*/
	function switch_cooldown(t_use)
	{
		function_7e393675(undefined);
		foreach(e_heart in m_a_e_heart)
		{
			e_heart moveto(e_heart.origin - (vectorscale((0, 0, -1), 32)), 0.25);
		}
		wait(0.25);
		self thread update_chain_animation();
	}

	/*
		Name: switch_active
		Namespace: ctrap
		Checksum: 0x3EAF304F
		Offset: 0x1320
		Size: 0xAC
		Parameters: 1
		Flags: Linked
	*/
	function switch_active(t_use)
	{
		if(!m_b_discovered)
		{
			level thread zm_audio::sndmusicsystem_playstate("trap");
			m_b_discovered = 1;
		}
		var_74a8cf96 = 30;
		self thread function_7e393675(var_74a8cf96);
		wait(0.25);
		m_t_damage playsound("zmb_trap_activate");
		self thread update_chain_animation();
	}

	/*
		Name: switch_available
		Namespace: ctrap
		Checksum: 0x8BCD29B7
		Offset: 0x12C8
		Size: 0x4C
		Parameters: 1
		Flags: Linked
	*/
	function switch_available(t_use)
	{
		function_7e393675(undefined);
		self thread update_chain_animation();
	}

	/*
		Name: switch_update_state
		Namespace: ctrap
		Checksum: 0xEFF06CA4
		Offset: 0x1220
		Size: 0x9E
		Parameters: 1
		Flags: Linked
	*/
	function switch_update_state(t_use)
	{
		switch(m_n_state)
		{
			case 1:
			{
				[[ self ]]->switch_available(t_use);
				break;
			}
			case 2:
			{
				[[ self ]]->switch_active(t_use);
				break;
			}
			case 3:
			{
				[[ self ]]->switch_cooldown(t_use);
				break;
			}
			case 0:
			{
				[[ self ]]->switch_unavailable(t_use);
				break;
			}
		}
	}

	/*
		Name: strings_update_state
		Namespace: ctrap
		Checksum: 0x5F2465E1
		Offset: 0x10F8
		Size: 0x11E
		Parameters: 0
		Flags: Linked
	*/
	function strings_update_state()
	{
		switch(m_n_state)
		{
			case 1:
			{
				array::thread_all(m_a_t_use, &hint_string, m_str_trap_available, m_n_cost);
				break;
			}
			case 2:
			{
				array::thread_all(m_a_t_use, &hint_string, m_str_trap_active);
				break;
			}
			case 3:
			{
				array::thread_all(m_a_t_use, &hint_string, m_str_trap_cooldown);
				break;
			}
			case 0:
			{
				array::thread_all(m_a_t_use, &hint_string, m_str_trap_unavailable);
				break;
			}
		}
	}

	/*
		Name: use_trig_think
		Namespace: ctrap
		Checksum: 0xB6D7F878
		Offset: 0xE98
		Size: 0x258
		Parameters: 1
		Flags: Linked
	*/
	function use_trig_think(o_trap)
	{
		while(true)
		{
			self waittill(#"trigger", who);
			if(who zm_utility::in_revive_trigger())
			{
				continue;
			}
			if(who.is_drinking > 0)
			{
				continue;
			}
			if(!zm_utility::is_player_valid(who))
			{
				continue;
			}
			if(!who zm_score::can_player_purchase(o_trap.m_n_cost))
			{
				continue;
			}
			if(o_trap.m_n_state != 1)
			{
				continue;
			}
			o_trap.m_n_state = 2;
			o_trap.m_e_who = who;
			bb::logpurchaseevent(who, self, o_trap.m_n_cost, targetname, 0, "_trap", "_purchased");
			who zm_score::minus_to_player_score(o_trap.m_n_cost);
			[[ o_trap ]]->strings_update_state();
			[[ o_trap ]]->switch_update_state(self);
			[[ o_trap ]]->trap_update_state();
			who thread zm_audio::create_and_play_dialog("trap", "start");
			wait(o_trap.m_n_duration_active);
			o_trap.m_n_state = 3;
			[[ o_trap ]]->trap_update_state();
			[[ o_trap ]]->switch_update_state(self);
			[[ o_trap ]]->strings_update_state();
			wait(o_trap.m_n_duration_cooldown);
			o_trap.m_n_state = 1;
			[[ o_trap ]]->strings_update_state();
			[[ o_trap ]]->switch_update_state(self);
			[[ o_trap ]]->trap_update_state();
		}
	}

	/*
		Name: filter_areaname
		Namespace: ctrap
		Checksum: 0x7E4FB803
		Offset: 0xE58
		Size: 0x34
		Parameters: 2
		Flags: Linked
	*/
	function filter_areaname(e_entity, str_area_name)
	{
		if(e_entity.prefabname !== str_area_name)
		{
			return false;
		}
		return true;
	}

	/*
		Name: init_trap
		Namespace: ctrap
		Checksum: 0x8E2E5E79
		Offset: 0x9B0
		Size: 0x49C
		Parameters: 1
		Flags: Linked
	*/
	function init_trap(str_area_name)
	{
		m_n_state = 1;
		m_b_discovered = 0;
		var_54d81d07 = 0;
		m_n_cost = 1000;
		m_n_duration_active = 25;
		m_n_duration_cooldown = 25;
		m_n_duration_player_damage_cooldown = 1;
		m_n_duration_zombie_damage_cooldown = 0.25;
		m_n_player_damage = 25;
		m_n_zombie_damage = 6500;
		m_str_trap_unavailable = &"ZM_ZOD_TRAP_CHAIN_UNAVAILABLE";
		m_str_trap_available = &"ZM_ZOD_TRAP_CHAIN_AVAILABLE";
		m_str_trap_active = &"ZM_ZOD_TRAP_CHAIN_ACTIVE";
		m_str_trap_cooldown = &"ZM_ZOD_TRAP_CHAIN_COOLDOWN";
		m_a_t_damage = getentarray("trap_chain_damage", "targetname");
		m_a_t_damage = array::filter(m_a_t_damage, 0, &filter_areaname, str_area_name);
		m_a_t_rumble = getentarray("trap_chain_rumble", "targetname");
		m_a_t_rumble = array::filter(m_a_t_damage, 0, &filter_areaname, str_area_name);
		m_a_e_heart = getentarray("trap_chain_heart", "targetname");
		m_a_e_heart = array::filter(m_a_e_heart, 0, &filter_areaname, str_area_name);
		m_a_t_use = getentarray("use_trap_chain", "targetname");
		m_a_t_use = array::filter(m_a_t_use, 0, &filter_areaname, str_area_name);
		strings_update_state();
		array::thread_all(m_a_t_use, &use_trig_think, self);
		var_d186b130 = [];
		var_d186b130[0] = "theater";
		var_d186b130[1] = "slums";
		var_d186b130[2] = "canals";
		var_d186b130[3] = "pap";
		foreach(heart in m_a_e_heart)
		{
			for(i = 0; i < var_d186b130.size; i++)
			{
				if(var_d186b130[i] == heart.prefabname)
				{
					heart clientfield::set("trap_chain_location", i);
				}
			}
		}
		m_t_damage = m_a_t_damage[0];
		m_t_rumble = m_a_t_rumble[0];
		a_audio_structs = struct::get_array("trap_chain_audio_loc", "targetname");
		a_audio_structs = array::filter(a_audio_structs, 0, &filter_areaname, str_area_name);
		m_s_audio_location = a_audio_structs[0];
		m_s_audio_location = spawn("script_origin", m_s_audio_location.origin);
		m_b_are_strikers_moving = 0;
		self thread update_chain_animation();
	}

}

#namespace zm_zod_traps;

/*
	Name: __init__sytem__
	Namespace: zm_zod_traps
	Checksum: 0xB414E397
	Offset: 0x528
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_traps", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_traps
	Checksum: 0x1B9AB328
	Offset: 0x568
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "trap_chain_state", 1, 2, "int");
	clientfield::register("scriptmover", "trap_chain_location", 1, 2, "int");
}

/*
	Name: init_traps
	Namespace: zm_zod_traps
	Checksum: 0x87FFF9BD
	Offset: 0x5D8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function init_traps()
{
	if(!isdefined(level.a_o_trap_chain))
	{
		level.a_o_trap_chain = [];
		init_trap("theater");
		init_trap("slums");
		init_trap("canals");
		init_trap("pap");
	}
	flag::wait_till("all_players_spawned");
	function_89303c72(undefined);
}

/*
	Name: init_trap
	Namespace: zm_zod_traps
	Checksum: 0x69AC3FEF
	Offset: 0x690
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function init_trap(str_area_name)
{
	if(!isdefined(level.a_o_trap_chain[str_area_name]))
	{
		level.a_o_trap_chain[str_area_name] = new ctrap();
		[[ level.a_o_trap_chain[str_area_name] ]]->init_trap(str_area_name);
	}
}

/*
	Name: function_89303c72
	Namespace: zm_zod_traps
	Checksum: 0xA031D45B
	Offset: 0x6F8
	Size: 0x1E4
	Parameters: 1
	Flags: Linked
*/
function function_89303c72(var_f6caa7fd)
{
	var_cdd779bd = getarraykeys(level.a_o_trap_chain);
	foreach(str_index in var_cdd779bd)
	{
		if(str_index != "pap")
		{
			level.a_o_trap_chain[str_index].m_n_state = 1;
			[[ level.a_o_trap_chain[str_index] ]]->trap_update_state();
			[[ level.a_o_trap_chain[str_index] ]]->switch_update_state(level.a_o_trap_chain[str_index].m_a_e_heart[0]);
			[[ level.a_o_trap_chain[str_index] ]]->strings_update_state();
		}
	}
	level.a_o_trap_chain["pap"].m_n_state = 0;
	[[ level.a_o_trap_chain["pap"] ]]->trap_update_state();
	[[ level.a_o_trap_chain["pap"] ]]->switch_update_state(level.a_o_trap_chain["pap"].m_a_e_heart[0]);
	[[ level.a_o_trap_chain["pap"] ]]->strings_update_state();
	level thread function_8144bbbe();
}

/*
	Name: function_8144bbbe
	Namespace: zm_zod_traps
	Checksum: 0x887FCCEF
	Offset: 0x8E8
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function function_8144bbbe()
{
	level flag::wait_till("pap_door_open");
	level.a_o_trap_chain["pap"].m_n_state = 1;
	[[ level.a_o_trap_chain["pap"] ]]->trap_update_state();
	[[ level.a_o_trap_chain["pap"] ]]->switch_update_state(level.a_o_trap_chain["pap"].m_a_e_heart[0]);
	[[ level.a_o_trap_chain["pap"] ]]->strings_update_state();
}

