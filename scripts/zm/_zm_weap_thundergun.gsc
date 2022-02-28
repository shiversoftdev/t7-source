// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_weap_thundergun;

/*
	Name: __init__sytem__
	Namespace: zm_weap_thundergun
	Checksum: 0x40C4A654
	Offset: 0x560
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_thundergun", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_thundergun
	Checksum: 0xC67F9863
	Offset: 0x5A8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.weaponzmthundergun = getweapon("thundergun");
	level.weaponzmthundergunupgraded = getweapon("thundergun_upgraded");
}

/*
	Name: __main__
	Namespace: zm_weap_thundergun
	Checksum: 0xB7FE73B3
	Offset: 0x5F8
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level._effect["thundergun_knockdown_ground"] = "zombie/fx_thundergun_knockback_ground";
	level._effect["thundergun_smoke_cloud"] = "zombie/fx_thundergun_smoke_cloud";
	zombie_utility::set_zombie_var("thundergun_cylinder_radius", 180);
	zombie_utility::set_zombie_var("thundergun_fling_range", 480);
	zombie_utility::set_zombie_var("thundergun_gib_range", 900);
	zombie_utility::set_zombie_var("thundergun_gib_damage", 75);
	zombie_utility::set_zombie_var("thundergun_knockdown_range", 1200);
	zombie_utility::set_zombie_var("thundergun_knockdown_damage", 15);
	level.thundergun_gib_refs = [];
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "guts";
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "right_arm";
	level.thundergun_gib_refs[level.thundergun_gib_refs.size] = "left_arm";
	level.basic_zombie_thundergun_knockdown = &zombie_knockdown;
	if(!isdefined(level.override_thundergun_damage_func))
	{
		level.override_thundergun_damage_func = &override_thundergun_damage_func;
	}
	/#
		level thread thundergun_devgui_dvar_think();
	#/
	callback::on_connect(&thundergun_on_player_connect);
}

/*
	Name: thundergun_devgui_dvar_think
	Namespace: zm_weap_thundergun
	Checksum: 0x83CDA97E
	Offset: 0x7C8
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function thundergun_devgui_dvar_think()
{
	/#
		if(!zm_weapons::is_weapon_included(level.weaponzmthundergun))
		{
			return;
		}
		setdvar("", level.zombie_vars[""]);
		setdvar("", level.zombie_vars[""]);
		setdvar("", level.zombie_vars[""]);
		setdvar("", level.zombie_vars[""]);
		setdvar("", level.zombie_vars[""]);
		setdvar("", level.zombie_vars[""]);
		for(;;)
		{
			level.zombie_vars[""] = getdvarint("");
			level.zombie_vars[""] = getdvarint("");
			level.zombie_vars[""] = getdvarint("");
			level.zombie_vars[""] = getdvarint("");
			level.zombie_vars[""] = getdvarint("");
			level.zombie_vars[""] = getdvarint("");
			wait(0.5);
		}
	#/
}

/*
	Name: thundergun_on_player_connect
	Namespace: zm_weap_thundergun
	Checksum: 0x80B1CCB6
	Offset: 0x9F0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function thundergun_on_player_connect()
{
	self thread wait_for_thundergun_fired();
}

/*
	Name: wait_for_thundergun_fired
	Namespace: zm_weap_thundergun
	Checksum: 0x4D1F5A07
	Offset: 0xA18
	Size: 0x140
	Parameters: 0
	Flags: Linked
*/
function wait_for_thundergun_fired()
{
	self endon(#"disconnect");
	self waittill(#"spawned_player");
	for(;;)
	{
		self waittill(#"weapon_fired");
		currentweapon = self getcurrentweapon();
		if(currentweapon == level.weaponzmthundergun || currentweapon == level.weaponzmthundergunupgraded)
		{
			self thread thundergun_fired();
			view_pos = self gettagorigin("tag_flash") - self getplayerviewheight();
			view_angles = self gettagangles("tag_flash");
			playfx(level._effect["thundergun_smoke_cloud"], view_pos, anglestoforward(view_angles), anglestoup(view_angles));
		}
	}
}

/*
	Name: thundergun_network_choke
	Namespace: zm_weap_thundergun
	Checksum: 0x6B520414
	Offset: 0xB60
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function thundergun_network_choke()
{
	level.thundergun_network_choke_count++;
	if(!level.thundergun_network_choke_count % 10)
	{
		util::wait_network_frame();
		util::wait_network_frame();
		util::wait_network_frame();
	}
}

/*
	Name: thundergun_fired
	Namespace: zm_weap_thundergun
	Checksum: 0x770BB3DE
	Offset: 0xBB8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function thundergun_fired()
{
	physicsexplosioncylinder(self.origin, 600, 240, 1);
	self thread thundergun_affect_ais();
}

/*
	Name: thundergun_affect_ais
	Namespace: zm_weap_thundergun
	Checksum: 0xB7482FB5
	Offset: 0xC08
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function thundergun_affect_ais()
{
	if(!isdefined(level.thundergun_knockdown_enemies))
	{
		level.thundergun_knockdown_enemies = [];
		level.thundergun_knockdown_gib = [];
		level.thundergun_fling_enemies = [];
		level.thundergun_fling_vecs = [];
	}
	self thundergun_get_enemies_in_range();
	level.thundergun_network_choke_count = 0;
	for(i = 0; i < level.thundergun_fling_enemies.size; i++)
	{
		level.thundergun_fling_enemies[i] thread thundergun_fling_zombie(self, level.thundergun_fling_vecs[i], i);
	}
	for(i = 0; i < level.thundergun_knockdown_enemies.size; i++)
	{
		level.thundergun_knockdown_enemies[i] thread thundergun_knockdown_zombie(self, level.thundergun_knockdown_gib[i]);
	}
	level.thundergun_knockdown_enemies = [];
	level.thundergun_knockdown_gib = [];
	level.thundergun_fling_enemies = [];
	level.thundergun_fling_vecs = [];
}

/*
	Name: thundergun_get_enemies_in_range
	Namespace: zm_weap_thundergun
	Checksum: 0x643DC5C1
	Offset: 0xD58
	Size: 0x6AE
	Parameters: 0
	Flags: Linked
*/
function thundergun_get_enemies_in_range()
{
	view_pos = self getweaponmuzzlepoint();
	zombies = array::get_all_closest(view_pos, getaiteamarray(level.zombie_team), undefined, undefined, level.zombie_vars["thundergun_knockdown_range"]);
	if(!isdefined(zombies))
	{
		return;
	}
	knockdown_range_squared = level.zombie_vars["thundergun_knockdown_range"] * level.zombie_vars["thundergun_knockdown_range"];
	gib_range_squared = level.zombie_vars["thundergun_gib_range"] * level.zombie_vars["thundergun_gib_range"];
	fling_range_squared = level.zombie_vars["thundergun_fling_range"] * level.zombie_vars["thundergun_fling_range"];
	cylinder_radius_squared = level.zombie_vars["thundergun_cylinder_radius"] * level.zombie_vars["thundergun_cylinder_radius"];
	forward_view_angles = self getweaponforwarddir();
	end_pos = view_pos + vectorscale(forward_view_angles, level.zombie_vars["thundergun_knockdown_range"]);
	/#
		if(2 == getdvarint(""))
		{
			near_circle_pos = view_pos + vectorscale(forward_view_angles, 2);
			circle(near_circle_pos, level.zombie_vars[""], (1, 0, 0), 0, 0, 100);
			line(near_circle_pos, end_pos, (0, 0, 1), 1, 0, 100);
			circle(end_pos, level.zombie_vars[""], (1, 0, 0), 0, 0, 100);
		}
	#/
	for(i = 0; i < zombies.size; i++)
	{
		if(!isdefined(zombies[i]) || !isalive(zombies[i]))
		{
			continue;
		}
		test_origin = zombies[i] getcentroid();
		test_range_squared = distancesquared(view_pos, test_origin);
		if(test_range_squared > knockdown_range_squared)
		{
			zombies[i] thundergun_debug_print("range", (1, 0, 0));
			return;
		}
		normal = vectornormalize(test_origin - view_pos);
		dot = vectordot(forward_view_angles, normal);
		if(0 > dot)
		{
			zombies[i] thundergun_debug_print("dot", (1, 0, 0));
			continue;
		}
		radial_origin = pointonsegmentnearesttopoint(view_pos, end_pos, test_origin);
		if(distancesquared(test_origin, radial_origin) > cylinder_radius_squared)
		{
			zombies[i] thundergun_debug_print("cylinder", (1, 0, 0));
			continue;
		}
		if(0 == zombies[i] damageconetrace(view_pos, self))
		{
			zombies[i] thundergun_debug_print("cone", (1, 0, 0));
			continue;
		}
		if(test_range_squared < fling_range_squared)
		{
			level.thundergun_fling_enemies[level.thundergun_fling_enemies.size] = zombies[i];
			dist_mult = (fling_range_squared - test_range_squared) / fling_range_squared;
			fling_vec = vectornormalize(test_origin - view_pos);
			if(5000 < test_range_squared)
			{
				fling_vec = fling_vec + (vectornormalize(test_origin - radial_origin));
			}
			fling_vec = (fling_vec[0], fling_vec[1], abs(fling_vec[2]));
			fling_vec = vectorscale(fling_vec, 100 + (100 * dist_mult));
			level.thundergun_fling_vecs[level.thundergun_fling_vecs.size] = fling_vec;
			zombies[i] thread setup_thundergun_vox(self, 1, 0, 0);
			continue;
		}
		if(test_range_squared < gib_range_squared)
		{
			level.thundergun_knockdown_enemies[level.thundergun_knockdown_enemies.size] = zombies[i];
			level.thundergun_knockdown_gib[level.thundergun_knockdown_gib.size] = 1;
			zombies[i] thread setup_thundergun_vox(self, 0, 1, 0);
			continue;
		}
		level.thundergun_knockdown_enemies[level.thundergun_knockdown_enemies.size] = zombies[i];
		level.thundergun_knockdown_gib[level.thundergun_knockdown_gib.size] = 0;
		zombies[i] thread setup_thundergun_vox(self, 0, 0, 1);
	}
}

/*
	Name: thundergun_debug_print
	Namespace: zm_weap_thundergun
	Checksum: 0x3874B81
	Offset: 0x1410
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function thundergun_debug_print(msg, color)
{
	/#
		if(!getdvarint(""))
		{
			return;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		print3d(self.origin + vectorscale((0, 0, 1), 60), msg, color, 1, 1, 40);
	#/
}

/*
	Name: thundergun_fling_zombie
	Namespace: zm_weap_thundergun
	Checksum: 0x8C4F5405
	Offset: 0x14A8
	Size: 0x188
	Parameters: 3
	Flags: Linked
*/
function thundergun_fling_zombie(player, fling_vec, index)
{
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(isdefined(self.thundergun_fling_func))
	{
		self [[self.thundergun_fling_func]](player);
		return;
	}
	self.deathpoints_already_given = 1;
	self dodamage(self.health + 666, player.origin, player);
	if(self.health <= 0)
	{
		if(isdefined(player) && isdefined(level.hero_power_update))
		{
			level thread [[level.hero_power_update]](player, self);
		}
		points = 10;
		if(!index)
		{
			points = zm_score::get_zombie_death_player_points();
		}
		else if(1 == index)
		{
			points = 30;
		}
		player zm_score::player_add_points("thundergun_fling", points);
		self startragdoll();
		self launchragdoll(fling_vec);
		self.thundergun_death = 1;
	}
}

/*
	Name: zombie_knockdown
	Namespace: zm_weap_thundergun
	Checksum: 0x52C5207C
	Offset: 0x1638
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function zombie_knockdown(player, gib)
{
	if(gib && !self.gibbed)
	{
		self.a.gib_ref = array::random(level.thundergun_gib_refs);
		self thread zombie_death::do_gib();
	}
	if(isdefined(level.override_thundergun_damage_func))
	{
		self [[level.override_thundergun_damage_func]](player, gib);
	}
	else
	{
		damage = level.zombie_vars["thundergun_knockdown_damage"];
		self playsound("fly_thundergun_forcehit");
		self.thundergun_handle_pain_notetracks = &handle_thundergun_pain_notetracks;
		self dodamage(damage, player.origin, player);
		self animcustom(&playthundergunpainanim);
	}
}

/*
	Name: playthundergunpainanim
	Namespace: zm_weap_thundergun
	Checksum: 0xF9E2B555
	Offset: 0x1770
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function playthundergunpainanim()
{
	self notify(#"end_play_thundergun_pain_anim");
	self endon(#"killanimscript");
	self endon(#"death");
	self endon(#"end_play_thundergun_pain_anim");
	if(isdefined(self.marked_for_death) && self.marked_for_death)
	{
		return;
	}
	if(self.damageyaw <= -135 || self.damageyaw >= 135)
	{
		if(self.missinglegs)
		{
			fallanim = "zm_thundergun_fall_front_crawl";
		}
		else
		{
			fallanim = "zm_thundergun_fall_front";
		}
		getupanim = "zm_thundergun_getup_belly_early";
	}
	else
	{
		if(self.damageyaw > -135 && self.damageyaw < -45)
		{
			fallanim = "zm_thundergun_fall_left";
			getupanim = "zm_thundergun_getup_belly_early";
		}
		else
		{
			if(self.damageyaw > 45 && self.damageyaw < 135)
			{
				fallanim = "zm_thundergun_fall_right";
				getupanim = "zm_thundergun_getup_belly_early";
			}
			else
			{
				fallanim = "zm_thundergun_fall_back";
				if(randomint(100) < 50)
				{
					getupanim = "zm_thundergun_getup_back_early";
				}
				else
				{
					getupanim = "zm_thundergun_getup_back_late";
				}
			}
		}
	}
	self setanimstatefromasd(fallanim);
	self zombie_shared::donotetracks("thundergun_fall_anim", self.thundergun_handle_pain_notetracks);
	if(!isdefined(self) || !isalive(self) || self.missinglegs || (isdefined(self.marked_for_death) && self.marked_for_death))
	{
		return;
	}
	self setanimstatefromasd(getupanim);
	self zombie_shared::donotetracks("thundergun_getup_anim");
}

/*
	Name: thundergun_knockdown_zombie
	Namespace: zm_weap_thundergun
	Checksum: 0x764211F6
	Offset: 0x19B8
	Size: 0x88
	Parameters: 2
	Flags: Linked
*/
function thundergun_knockdown_zombie(player, gib)
{
	self endon(#"death");
	playsoundatposition("wpn_thundergun_proj_impact", self.origin);
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(isdefined(self.thundergun_knockdown_func))
	{
		self [[self.thundergun_knockdown_func]](player, gib);
	}
}

/*
	Name: handle_thundergun_pain_notetracks
	Namespace: zm_weap_thundergun
	Checksum: 0x2A3BD6D0
	Offset: 0x1A48
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function handle_thundergun_pain_notetracks(note)
{
	if(note == "zombie_knockdown_ground_impact")
	{
		playfx(level._effect["thundergun_knockdown_ground"], self.origin, anglestoforward(self.angles), anglestoup(self.angles));
		self playsound("fly_thundergun_forcehit");
	}
}

/*
	Name: is_thundergun_damage
	Namespace: zm_weap_thundergun
	Checksum: 0x2613C131
	Offset: 0x1AE8
	Size: 0x50
	Parameters: 0
	Flags: None
*/
function is_thundergun_damage()
{
	return self.damageweapon == level.weaponzmthundergun || self.damageweapon == level.weaponzmthundergunupgraded && (self.damagemod != "MOD_GRENADE" && self.damagemod != "MOD_GRENADE_SPLASH");
}

/*
	Name: enemy_killed_by_thundergun
	Namespace: zm_weap_thundergun
	Checksum: 0xA996C165
	Offset: 0x1B40
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function enemy_killed_by_thundergun()
{
	return isdefined(self.thundergun_death) && self.thundergun_death;
}

/*
	Name: thundergun_sound_thread
	Namespace: zm_weap_thundergun
	Checksum: 0xDACB7170
	Offset: 0x1B60
	Size: 0x118
	Parameters: 0
	Flags: None
*/
function thundergun_sound_thread()
{
	self endon(#"disconnect");
	self waittill(#"spawned_player");
	for(;;)
	{
		result = self util::waittill_any_return("grenade_fire", "death", "player_downed", "weapon_change", "grenade_pullback", "disconnect");
		if(!isdefined(result))
		{
			continue;
		}
		if(result == "weapon_change" || result == "grenade_fire" && self getcurrentweapon() == level.weaponzmthundergun)
		{
			self playloopsound("tesla_idle", 0.25);
			continue;
		}
		self notify(#"weap_away");
		self stoploopsound(0.25);
	}
}

/*
	Name: setup_thundergun_vox
	Namespace: zm_weap_thundergun
	Checksum: 0x3AFE3D84
	Offset: 0x1C80
	Size: 0xD4
	Parameters: 4
	Flags: Linked
*/
function setup_thundergun_vox(player, fling, gib, knockdown)
{
	if(!isdefined(self) || !isalive(self))
	{
		return;
	}
	if(!fling && (gib || knockdown))
	{
	}
	if(fling)
	{
		if(30 > randomintrange(1, 100))
		{
			player zm_audio::create_and_play_dialog("kill", "thundergun");
		}
	}
}

/*
	Name: override_thundergun_damage_func
	Namespace: zm_weap_thundergun
	Checksum: 0xFC474FD0
	Offset: 0x1D60
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function override_thundergun_damage_func(player, gib)
{
	self zombie_utility::setup_zombie_knockdown(player);
}

