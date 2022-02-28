// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_ai_quad;

/*
	Name: __init__sytem__
	Namespace: zm_ai_quad
	Checksum: 0x205928DC
	Offset: 0x4F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_quad", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_quad
	Checksum: 0xF02F5832
	Offset: 0x530
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_quad_zombie_fx();
	if(!isdefined(level.ai_quad_register_overlay_override) || level.ai_quad_register_overlay_override)
	{
		register_overlay();
	}
	animationstatenetwork::registernotetrackhandlerfunction("quad_melee", &quadnotetrackmeleefire);
	behaviortreenetworkutility::registerbehaviortreescriptapi("quadDeathAction", &quaddeathaction);
	level thread aat::register_immunity("zm_aat_dead_wire", "zombie_quad", 1, 1, 1);
	level thread aat::register_immunity("zm_aat_turned", "zombie_quad", 1, 1, 1);
}

/*
	Name: quadnotetrackmeleefire
	Namespace: zm_ai_quad
	Checksum: 0x3F12100B
	Offset: 0x630
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function quadnotetrackmeleefire(entity)
{
	entity melee();
	/#
		record3dtext("", self.origin, (1, 0, 0), "", entity);
	#/
}

/*
	Name: quaddeathaction
	Namespace: zm_ai_quad
	Checksum: 0x50C719E6
	Offset: 0x698
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function quaddeathaction(entity)
{
	if(isdefined(entity.fx_quad_trail))
	{
		entity.fx_quad_trail unlink();
		entity.fx_quad_trail delete();
	}
	if(entity.can_explode && (!(isdefined(entity.guts_explosion) && entity.guts_explosion)))
	{
		entity thread quad_gas_explo_death();
	}
	entity startragdoll();
}

/*
	Name: function_5af423f4
	Namespace: zm_ai_quad
	Checksum: 0x9EB496EB
	Offset: 0x768
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_5af423f4()
{
	level.quad_spawners = getentarray("quad_zombie_spawner", "script_noteworthy");
	array::thread_all(level.quad_spawners, &spawner::add_spawn_function, &quad_prespawn);
	zm::register_custom_ai_spawn_check("quads", &quad_spawn_check, &get_quad_spawners);
}

/*
	Name: register_overlay
	Namespace: zm_ai_quad
	Checksum: 0x8594B272
	Offset: 0x810
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function register_overlay()
{
	if(!isdefined(level.vsmgr_prio_overlay_zm_ai_quad_blur))
	{
		level.vsmgr_prio_overlay_zm_ai_quad_blur = 50;
	}
	visionset_mgr::register_info("overlay", "zm_ai_quad_blur", 1, level.vsmgr_prio_overlay_zm_ai_quad_blur, 1, 1);
}

/*
	Name: quad_spawn_check
	Namespace: zm_ai_quad
	Checksum: 0x9FB89E92
	Offset: 0x870
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function quad_spawn_check()
{
	return isdefined(level.zm_loc_types["quad_location"]) && level.zm_loc_types["quad_location"].size > 0;
}

/*
	Name: get_quad_spawners
	Namespace: zm_ai_quad
	Checksum: 0x8FA3B2D0
	Offset: 0x8B0
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_quad_spawners()
{
	return level.quad_spawners;
}

/*
	Name: quad_prespawn
	Namespace: zm_ai_quad
	Checksum: 0x6057623
	Offset: 0x8C8
	Size: 0x260
	Parameters: 0
	Flags: Linked
*/
function quad_prespawn()
{
	self.animname = "quad_zombie";
	self.no_gib = 1;
	self.no_eye_glow = 1;
	self.no_widows_wine = 1;
	self.canbetargetedbyturnedzombies = 1;
	self.custom_location = &quad_location;
	self zm_spawner::zombie_spawn_init(1);
	self.zombie_can_sidestep = 0;
	self.maxhealth = int(self.maxhealth * 0.75);
	self.health = self.maxhealth;
	self.freezegun_damage = 0;
	self.meleedamage = 45;
	self playsound("zmb_quad_spawn");
	self.death_explo_radius_zomb = 96;
	self.death_explo_radius_plr = 96;
	self.death_explo_damage_zomb = 1.05;
	self.death_gas_radius = 125;
	self.death_gas_time = 7;
	if(isdefined(level.quad_explode) && level.quad_explode)
	{
		self.deathfunction = &quad_post_death;
		self.actor_killed_override = &quad_killed_override;
	}
	self set_default_attack_properties();
	self.thundergun_knockdown_func = &quad_thundergun_knockdown;
	self.pre_teleport_func = &quad_pre_teleport;
	self.post_teleport_func = &quad_post_teleport;
	self.can_explode = 0;
	self.exploded = 0;
	self thread quad_trail();
	self allowpitchangle(1);
	self setphysparams(15, 0, 24);
	if(isdefined(level.quad_prespawn))
	{
		self thread [[level.quad_prespawn]]();
	}
}

/*
	Name: init_quad_zombie_fx
	Namespace: zm_ai_quad
	Checksum: 0x74A6FBA2
	Offset: 0xB30
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function init_quad_zombie_fx()
{
	level._effect["quad_explo_gas"] = "dlc5/zmhd/fx_zombie_quad_gas_nova6";
	level._effect["quad_trail"] = "dlc5/zmhd/fx_zombie_quad_trail";
}

/*
	Name: quad_location
	Namespace: zm_ai_quad
	Checksum: 0x72BCECD3
	Offset: 0xB78
	Size: 0x336
	Parameters: 0
	Flags: Linked
*/
function quad_location()
{
	self endon(#"death");
	if(level.zm_loc_types["quad_location"].size <= 0)
	{
		/#
			println("" + "");
		#/
		self dodamage(self.health * 2, self.origin);
		return;
	}
	spot = array::random(level.zm_loc_types["quad_location"]);
	if(isdefined(spot.target))
	{
		self.target = spot.target;
	}
	if(isdefined(spot.zone_name))
	{
		self.zone_name = spot.zone_name;
	}
	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);
	if(!isdefined(spot.angles))
	{
		spot.angles = (0, 0, 0);
	}
	self ghost();
	self.anchor moveto(spot.origin, 0.05);
	self.anchor waittill(#"movedone");
	target_org = zombie_utility::get_desired_origin();
	if(isdefined(target_org))
	{
		anim_ang = vectortoangles(target_org - self.origin);
		self.anchor rotateto((0, anim_ang[1], 0), 0.05);
		self.anchor waittill(#"rotatedone");
	}
	if(isdefined(level.zombie_spawn_fx))
	{
		playfx(level.zombie_spawn_fx, spot.origin);
	}
	self unlink();
	if(isdefined(self.anchor))
	{
		self.anchor delete();
	}
	self show();
	self notify(#"risen", spot.script_string);
}

/*
	Name: quad_vox
	Namespace: zm_ai_quad
	Checksum: 0x1870F7C7
	Offset: 0xEB8
	Size: 0x198
	Parameters: 0
	Flags: None
*/
function quad_vox()
{
	self endon(#"death");
	wait(5);
	quad_wait = 5;
	while(true)
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(distancesquared(self.origin, players[i].origin) > 1440000)
			{
				self playsound("zmb_quad_amb");
				quad_wait = 7;
				continue;
			}
			if(distancesquared(self.origin, players[i].origin) > 40000)
			{
				self playsound("zmb_quad_vox");
				quad_wait = 5;
				continue;
			}
			if(distancesquared(self.origin, players[i].origin) < 22500)
			{
				wait(0.05);
			}
		}
		wait(randomfloatrange(1, quad_wait));
	}
}

/*
	Name: set_default_attack_properties
	Namespace: zm_ai_quad
	Checksum: 0x22A5B44E
	Offset: 0x1058
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function set_default_attack_properties()
{
	self.goalradius = 16;
	self.maxsightdistsqrd = 16384;
	self.can_leap = 0;
}

/*
	Name: quad_thundergun_knockdown
	Namespace: zm_ai_quad
	Checksum: 0x9345C1E6
	Offset: 0x1088
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function quad_thundergun_knockdown(player, gib)
{
	self endon(#"death");
	damage = int(self.maxhealth * 0.5);
	self dodamage(damage, player.origin, player);
}

/*
	Name: quad_gas_explo_death
	Namespace: zm_ai_quad
	Checksum: 0x24AD6DC7
	Offset: 0x1110
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function quad_gas_explo_death()
{
	death_vars = [];
	death_vars["explo_radius_zomb"] = self.death_explo_radius_zomb;
	death_vars["explo_radius_plr"] = self.death_explo_radius_plr;
	death_vars["explo_damage_zomb"] = self.death_explo_damage_zomb;
	death_vars["gas_radius"] = self.death_gas_radius;
	death_vars["gas_time"] = self.death_gas_time;
	self thread quad_death_explo(self.origin, death_vars);
	level thread quad_gas_area_of_effect(self.origin, death_vars);
}

/*
	Name: quad_death_explo
	Namespace: zm_ai_quad
	Checksum: 0x982DC282
	Offset: 0x11E8
	Size: 0x19C
	Parameters: 2
	Flags: Linked
*/
function quad_death_explo(origin, death_vars)
{
	playsoundatposition("zmb_quad_explo", origin);
	players = getplayers();
	zombies = getaiteamarray(level.zombie_team);
	for(i = 0; i < players.size; i++)
	{
		if(distance(origin, players[i].origin) <= death_vars["explo_radius_plr"])
		{
			is_immune = 0;
			if(isdefined(level.quad_gas_immune_func))
			{
				is_immune = players[i] thread [[level.quad_gas_immune_func]]();
			}
			if(!is_immune)
			{
				players[i] shellshock("explosion", 2.5);
			}
		}
	}
	self.exploded = 1;
	self radiusdamage(origin, death_vars["explo_radius_zomb"], level.zombie_health, level.zombie_health, self, "MOD_EXPLOSIVE");
}

/*
	Name: quad_damage_func
	Namespace: zm_ai_quad
	Checksum: 0xB4574222
	Offset: 0x1390
	Size: 0x22
	Parameters: 1
	Flags: None
*/
function quad_damage_func(player)
{
	if(self.exploded)
	{
		return 0;
	}
	return self.meleedamage;
}

/*
	Name: quad_gas_area_of_effect
	Namespace: zm_ai_quad
	Checksum: 0xA91F4CD0
	Offset: 0x13C0
	Size: 0x244
	Parameters: 2
	Flags: Linked
*/
function quad_gas_area_of_effect(origin, death_vars)
{
	effectarea = spawn("trigger_radius", origin, 0, death_vars["gas_radius"], 100);
	playfx(level._effect["quad_explo_gas"], origin);
	gas_time = 0;
	while(gas_time <= death_vars["gas_time"])
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			is_immune = 0;
			if(isdefined(level.quad_gas_immune_func))
			{
				is_immune = players[i] thread [[level.quad_gas_immune_func]]();
			}
			if(players[i] istouching(effectarea) && !is_immune)
			{
				visionset_mgr::activate("overlay", "zm_ai_quad_blur", players[i]);
				continue;
			}
			visionset_mgr::deactivate("overlay", "zm_ai_quad_blur", players[i]);
		}
		wait(1);
		gas_time = gas_time + 1;
	}
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		visionset_mgr::deactivate("overlay", "zm_ai_quad_blur", players[i]);
	}
	effectarea delete();
}

/*
	Name: quad_trail
	Namespace: zm_ai_quad
	Checksum: 0xD4E2880D
	Offset: 0x1610
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function quad_trail()
{
	self endon(#"death");
	self.fx_quad_trail = spawn("script_model", self gettagorigin("tag_origin"));
	self.fx_quad_trail.angles = self gettagangles("tag_origin");
	self.fx_quad_trail setmodel("tag_origin");
	self.fx_quad_trail linkto(self, "tag_origin");
	zm_net::network_safe_play_fx_on_tag("quad_fx", 2, level._effect["quad_trail"], self.fx_quad_trail, "tag_origin");
}

/*
	Name: quad_post_death
	Namespace: zm_ai_quad
	Checksum: 0x91C5BF65
	Offset: 0x1718
	Size: 0x5E
	Parameters: 8
	Flags: Linked
*/
function quad_post_death(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	self zm_spawner::zombie_death_animscript();
	return false;
}

/*
	Name: quad_killed_override
	Namespace: zm_ai_quad
	Checksum: 0xC71AB8AD
	Offset: 0x1780
	Size: 0xD8
	Parameters: 8
	Flags: Linked
*/
function quad_killed_override(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	if(smeansofdeath == "MOD_PISTOL_BULLET" || smeansofdeath == "MOD_RIFLE_BULLET")
	{
		self.can_explode = 1;
	}
	else
	{
		self.can_explode = 0;
		if(isdefined(self.fx_quad_trail))
		{
			self.fx_quad_trail unlink();
			self.fx_quad_trail delete();
		}
	}
	if(isdefined(level._override_quad_explosion))
	{
		[[level._override_quad_explosion]](self);
	}
}

/*
	Name: quad_pre_teleport
	Namespace: zm_ai_quad
	Checksum: 0x38EEB5EF
	Offset: 0x1860
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function quad_pre_teleport()
{
	if(isdefined(self.fx_quad_trail))
	{
		self.fx_quad_trail unlink();
		self.fx_quad_trail delete();
		wait(0.1);
	}
}

/*
	Name: quad_post_teleport
	Namespace: zm_ai_quad
	Checksum: 0xBF235BEA
	Offset: 0x18B8
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function quad_post_teleport()
{
	if(isdefined(self.fx_quad_trail))
	{
		self.fx_quad_trail unlink();
		self.fx_quad_trail delete();
	}
	if(self.health > 0)
	{
		self.fx_quad_trail = spawn("script_model", self gettagorigin("tag_origin"));
		self.fx_quad_trail.angles = self gettagangles("tag_origin");
		self.fx_quad_trail setmodel("tag_origin");
		self.fx_quad_trail linkto(self, "tag_origin");
		zm_net::network_safe_play_fx_on_tag("quad_fx", 2, level._effect["quad_trail"], self.fx_quad_trail, "tag_origin");
	}
}

