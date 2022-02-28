// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_aat_fire_works;

/*
	Name: __init__sytem__
	Namespace: zm_aat_fire_works
	Checksum: 0xC17731D1
	Offset: 0x278
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_fire_works", &__init__, undefined, "aat");
}

/*
	Name: __init__
	Namespace: zm_aat_fire_works
	Checksum: 0xBB18DE24
	Offset: 0x2B8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	aat::register("zm_aat_fire_works", 0.1, 0, 20, 10, 1, &result, "t7_hud_zm_aat_fireworks", "wpn_aat_fire_works_plr", &fire_works_zombie_validation);
	clientfield::register("scriptmover", "zm_aat_fire_works", 1, 1, "int");
	zm_spawner::register_zombie_damage_callback(&zm_aat_fire_works_zombie_damage_response);
	zm_spawner::register_zombie_death_event_callback(&zm_aat_fire_works_death_callback);
}

/*
	Name: result
	Namespace: zm_aat_fire_works
	Checksum: 0xB159B0AB
	Offset: 0x3A8
	Size: 0x44
	Parameters: 4
	Flags: Linked
*/
function result(death, attacker, mod, weapon)
{
	self fire_works_summon(attacker, weapon);
}

/*
	Name: fire_works_zombie_validation
	Namespace: zm_aat_fire_works
	Checksum: 0x2E06D898
	Offset: 0x3F8
	Size: 0x86
	Parameters: 0
	Flags: Linked
*/
function fire_works_zombie_validation()
{
	if(isdefined(self.barricade_enter) && self.barricade_enter)
	{
		return false;
	}
	if(isdefined(self.is_traversing) && self.is_traversing)
	{
		return false;
	}
	if(!(isdefined(self.completed_emerging_into_playable_area) && self.completed_emerging_into_playable_area) && !isdefined(self.first_node))
	{
		return false;
	}
	if(isdefined(self.is_leaping) && self.is_leaping)
	{
		return false;
	}
	return true;
}

/*
	Name: fire_works_summon
	Namespace: zm_aat_fire_works
	Checksum: 0xC8ECFECC
	Offset: 0x488
	Size: 0x3E4
	Parameters: 2
	Flags: Linked
*/
function fire_works_summon(e_player, w_weapon)
{
	w_summoned_weapon = e_player getcurrentweapon();
	v_target_zombie_origin = self.origin;
	if(!(isdefined(level.aat["zm_aat_fire_works"].immune_result_direct[self.archetype]) && level.aat["zm_aat_fire_works"].immune_result_direct[self.archetype]))
	{
		self thread zombie_death_gib(e_player, w_weapon, e_player);
	}
	v_firing_pos = v_target_zombie_origin + vectorscale((0, 0, 1), 56);
	v_start_yaw = vectortoangles(v_firing_pos - v_target_zombie_origin);
	v_start_yaw = (0, v_start_yaw[1], 0);
	mdl_weapon = zm_utility::spawn_weapon_model(w_summoned_weapon, undefined, v_target_zombie_origin, v_start_yaw);
	mdl_weapon.owner = e_player;
	mdl_weapon.b_aat_fire_works_weapon = 1;
	mdl_weapon.allow_zombie_to_target_ai = 1;
	mdl_weapon thread clientfield::set("zm_aat_fire_works", 1);
	mdl_weapon moveto(v_firing_pos, 0.5);
	mdl_weapon waittill(#"movedone");
	for(i = 0; i < 10; i++)
	{
		zombie = mdl_weapon zm_aat_fire_works_get_target();
		if(!isdefined(zombie))
		{
			v_curr_yaw = (0, randomintrange(0, 360), 0);
			v_target_pos = mdl_weapon.origin + vectorscale(anglestoforward(v_curr_yaw), 40);
		}
		else
		{
			v_target_pos = zombie getcentroid();
		}
		mdl_weapon.angles = vectortoangles(v_target_pos - mdl_weapon.origin);
		v_flash_pos = mdl_weapon gettagorigin("tag_flash");
		mdl_weapon dontinterpolate();
		magicbullet(w_summoned_weapon, v_flash_pos, v_target_pos, mdl_weapon);
		util::wait_network_frame();
	}
	mdl_weapon moveto(v_target_zombie_origin, 0.5);
	mdl_weapon waittill(#"movedone");
	mdl_weapon clientfield::set("zm_aat_fire_works", 0);
	util::wait_network_frame();
	util::wait_network_frame();
	util::wait_network_frame();
	mdl_weapon delete();
	wait(0.25);
}

/*
	Name: zm_aat_fire_works_get_target
	Namespace: zm_aat_fire_works
	Checksum: 0x67FA111B
	Offset: 0x878
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function zm_aat_fire_works_get_target()
{
	a_ai_zombies = array::randomize(getaiteamarray("axis"));
	los_checks = 0;
	for(i = 0; i < a_ai_zombies.size; i++)
	{
		zombie = a_ai_zombies[i];
		test_origin = zombie getcentroid();
		if(distancesquared(self.origin, test_origin) > 360000)
		{
			continue;
		}
		if(los_checks < 3 && !zombie damageconetrace(self.origin))
		{
			los_checks++;
			continue;
		}
		return zombie;
	}
	if(a_ai_zombies.size)
	{
		return a_ai_zombies[0];
	}
	return undefined;
}

/*
	Name: zm_aat_fire_works_zombie_damage_response
	Namespace: zm_aat_fire_works
	Checksum: 0xB56BE1FC
	Offset: 0x9A8
	Size: 0x11C
	Parameters: 13
	Flags: Linked
*/
function zm_aat_fire_works_zombie_damage_response(str_mod, str_hit_location, v_hit_origin, e_attacker, n_amount, w_weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)
{
	if(isdefined(level.aat["zm_aat_fire_works"].immune_result_indirect[self.archetype]) && level.aat["zm_aat_fire_works"].immune_result_indirect[self.archetype])
	{
		return false;
	}
	if(isdefined(e_attacker.b_aat_fire_works_weapon) && e_attacker.b_aat_fire_works_weapon)
	{
		self thread zombie_death_gib(e_attacker, w_weapon, e_attacker.owner);
		return true;
	}
	return false;
}

/*
	Name: zm_aat_fire_works_death_callback
	Namespace: zm_aat_fire_works
	Checksum: 0x5C4DBB96
	Offset: 0xAD0
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function zm_aat_fire_works_death_callback(attacker)
{
	if(isdefined(attacker))
	{
		if(isdefined(attacker.b_aat_fire_works_weapon) && attacker.b_aat_fire_works_weapon)
		{
			if(isdefined(attacker.owner))
			{
				e_attacking_player = attacker.owner;
			}
		}
	}
}

/*
	Name: zombie_death_gib
	Namespace: zm_aat_fire_works
	Checksum: 0x9D35D25F
	Offset: 0xB40
	Size: 0x104
	Parameters: 3
	Flags: Linked
*/
function zombie_death_gib(e_attacker, w_weapon, e_owner)
{
	gibserverutils::gibhead(self);
	if(math::cointoss())
	{
		gibserverutils::gibleftarm(self);
	}
	else
	{
		gibserverutils::gibrightarm(self);
	}
	gibserverutils::giblegs(self);
	self dodamage(self.health, self.origin, e_attacker, w_weapon, "torso_upper");
	if(isdefined(e_owner) && isplayer(e_owner))
	{
		e_owner zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_FIRE_WORKS");
	}
}

