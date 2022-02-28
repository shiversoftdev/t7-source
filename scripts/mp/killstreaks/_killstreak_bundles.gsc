// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\clientfield_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace killstreak_bundles;

/*
	Name: register_killstreak_bundle
	Namespace: killstreak_bundles
	Checksum: 0xE77FA818
	Offset: 0x3C8
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function register_killstreak_bundle(killstreaktype)
{
	level.killstreakbundle[killstreaktype] = struct::get_script_bundle("killstreak", "killstreak_" + killstreaktype);
	level.killstreakbundle["inventory_" + killstreaktype] = level.killstreakbundle[killstreaktype];
	level.killstreakmaxhealthfunction = &get_max_health;
	/#
		assert(isdefined(level.killstreakbundle[killstreaktype]));
	#/
}

/*
	Name: get_bundle
	Namespace: killstreak_bundles
	Checksum: 0x31A63280
	Offset: 0x478
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function get_bundle(killstreak)
{
	if(killstreak.archetype === "raps")
	{
		return level.killstreakbundle["raps_drone"];
	}
	return level.killstreakbundle[killstreak.killstreaktype];
}

/*
	Name: get_hack_timeout
	Namespace: killstreak_bundles
	Checksum: 0x92799069
	Offset: 0x4D8
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function get_hack_timeout()
{
	killstreak = self;
	bundle = get_bundle(killstreak);
	return bundle.kshacktimeout;
}

/*
	Name: get_hack_protection
	Namespace: killstreak_bundles
	Checksum: 0x64038185
	Offset: 0x528
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function get_hack_protection()
{
	killstreak = self;
	hackedprotection = 0;
	bundle = get_bundle(killstreak);
	if(isdefined(bundle.kshackprotection))
	{
		hackedprotection = bundle.kshackprotection;
	}
	return hackedprotection;
}

/*
	Name: get_hack_tool_inner_time
	Namespace: killstreak_bundles
	Checksum: 0xCED87196
	Offset: 0x5A8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function get_hack_tool_inner_time()
{
	killstreak = self;
	hacktoolinnertime = 10000;
	bundle = get_bundle(killstreak);
	if(isdefined(bundle.kshacktoolinnertime))
	{
		hacktoolinnertime = bundle.kshacktoolinnertime;
	}
	return hacktoolinnertime;
}

/*
	Name: get_hack_tool_outer_time
	Namespace: killstreak_bundles
	Checksum: 0xD0A46E66
	Offset: 0x628
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function get_hack_tool_outer_time()
{
	killstreak = self;
	hacktooloutertime = 10000;
	bundle = get_bundle(killstreak);
	if(isdefined(bundle.kshacktooloutertime))
	{
		hacktooloutertime = bundle.kshacktooloutertime;
	}
	return hacktooloutertime;
}

/*
	Name: get_hack_tool_inner_radius
	Namespace: killstreak_bundles
	Checksum: 0xF60136AD
	Offset: 0x6A8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function get_hack_tool_inner_radius()
{
	killstreak = self;
	hackedtoolinnerradius = 10000;
	bundle = get_bundle(killstreak);
	if(isdefined(bundle.kshacktoolinnerradius))
	{
		hackedtoolinnerradius = bundle.kshacktoolinnerradius;
	}
	return hackedtoolinnerradius;
}

/*
	Name: get_hack_tool_outer_radius
	Namespace: killstreak_bundles
	Checksum: 0x9A296C2C
	Offset: 0x728
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function get_hack_tool_outer_radius()
{
	killstreak = self;
	hackedtoolouterradius = 10000;
	bundle = get_bundle(killstreak);
	if(isdefined(bundle.kshacktoolouterradius))
	{
		hackedtoolouterradius = bundle.kshacktoolouterradius;
	}
	return hackedtoolouterradius;
}

/*
	Name: get_lost_line_of_sight_limit_msec
	Namespace: killstreak_bundles
	Checksum: 0xC1E267E9
	Offset: 0x7A8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function get_lost_line_of_sight_limit_msec()
{
	killstreak = self;
	hackedtoollostlineofsightlimitms = 1000;
	bundle = get_bundle(killstreak);
	if(isdefined(bundle.kshacktoollostlineofsightlimitms))
	{
		hackedtoollostlineofsightlimitms = bundle.kshacktoollostlineofsightlimitms;
	}
	return hackedtoollostlineofsightlimitms;
}

/*
	Name: get_hack_tool_no_line_of_sight_time
	Namespace: killstreak_bundles
	Checksum: 0x59D2A89E
	Offset: 0x828
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function get_hack_tool_no_line_of_sight_time()
{
	killstreak = self;
	hacktoolnolineofsighttime = 1000;
	bundle = get_bundle(killstreak);
	if(isdefined(bundle.kshacktoolnolineofsighttime))
	{
		hacktoolnolineofsighttime = bundle.kshacktoolnolineofsighttime;
	}
	return hacktoolnolineofsighttime;
}

/*
	Name: get_hack_scoreevent
	Namespace: killstreak_bundles
	Checksum: 0x4B1E05BB
	Offset: 0x8A8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function get_hack_scoreevent()
{
	killstreak = self;
	hackedscoreevent = undefined;
	bundle = get_bundle(killstreak);
	if(isdefined(bundle.kshackscoreevent))
	{
		hackedscoreevent = bundle.kshackscoreevent;
	}
	return hackedscoreevent;
}

/*
	Name: get_hack_fx
	Namespace: killstreak_bundles
	Checksum: 0x1CD81413
	Offset: 0x928
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function get_hack_fx()
{
	killstreak = self;
	hackfx = "";
	bundle = get_bundle(killstreak);
	if(isdefined(bundle.kshackfx))
	{
		hackfx = bundle.kshackfx;
	}
	return hackfx;
}

/*
	Name: get_hack_loop_fx
	Namespace: killstreak_bundles
	Checksum: 0xB6392611
	Offset: 0x9A8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function get_hack_loop_fx()
{
	killstreak = self;
	hackloopfx = "";
	bundle = get_bundle(killstreak);
	if(isdefined(bundle.kshackloopfx))
	{
		hackloopfx = bundle.kshackloopfx;
	}
	return hackloopfx;
}

/*
	Name: get_max_health
	Namespace: killstreak_bundles
	Checksum: 0x7F2B1FC4
	Offset: 0xA28
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function get_max_health(killstreaktype)
{
	bundle = level.killstreakbundle[killstreaktype];
	return bundle.kshealth;
}

/*
	Name: get_low_health
	Namespace: killstreak_bundles
	Checksum: 0x5E9C3CF5
	Offset: 0xA68
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function get_low_health(killstreaktype)
{
	bundle = level.killstreakbundle[killstreaktype];
	return bundle.kslowhealth;
}

/*
	Name: get_hacked_health
	Namespace: killstreak_bundles
	Checksum: 0xF15071D7
	Offset: 0xAA8
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function get_hacked_health(killstreaktype)
{
	bundle = level.killstreakbundle[killstreaktype];
	return bundle.kshackedhealth;
}

/*
	Name: get_shots_to_kill
	Namespace: killstreak_bundles
	Checksum: 0xD349528A
	Offset: 0xAE8
	Size: 0x236
	Parameters: 3
	Flags: Linked
*/
function get_shots_to_kill(weapon, meansofdeath, bundle)
{
	shotstokill = undefined;
	switch(weapon.rootweapon.name)
	{
		case "remote_missile_missile":
		{
			shotstokill = bundle.ksremote_missile_missile;
			break;
		}
		case "hero_annihilator":
		{
			shotstokill = bundle.kshero_annihilator;
			break;
		}
		case "hero_armblade":
		{
			shotstokill = bundle.kshero_armblade;
			break;
		}
		case "hero_bowlauncher":
		case "hero_bowlauncher2":
		case "hero_bowlauncher3":
		case "hero_bowlauncher4":
		{
			if(meansofdeath == "MOD_PROJECTILE_SPLASH" || meansofdeath == "MOD_PROJECTILE")
			{
				shotstokill = bundle.kshero_bowlauncher;
			}
			else
			{
				shotstokill = -1;
			}
			break;
		}
		case "hero_gravityspikes":
		{
			shotstokill = bundle.kshero_gravityspikes;
			break;
		}
		case "hero_lightninggun":
		{
			shotstokill = bundle.kshero_lightninggun;
			break;
		}
		case "hero_minigun":
		case "hero_minigun_body3":
		{
			shotstokill = bundle.kshero_minigun;
			break;
		}
		case "hero_pineapplegun":
		{
			shotstokill = bundle.kshero_pineapplegun;
			break;
		}
		case "hero_firefly_swarm":
		{
			shotstokill = (isdefined(bundle.kshero_firefly_swarm) ? bundle.kshero_firefly_swarm : 0) * 4;
			break;
		}
		case "dart_blade":
		case "dart_turret":
		{
			shotstokill = bundle.ksdartstokill;
			break;
		}
		case "gadget_heat_wave":
		{
			shotstokill = bundle.kshero_heatwave;
			break;
		}
	}
	return true;
}

/*
	Name: get_emp_grenade_damage
	Namespace: killstreak_bundles
	Checksum: 0xE69A35E2
	Offset: 0xD28
	Size: 0xC8
	Parameters: 2
	Flags: Linked
*/
function get_emp_grenade_damage(killstreaktype, maxhealth)
{
	emp_weapon_damage = undefined;
	if(isdefined(level.killstreakbundle[killstreaktype]))
	{
		bundle = level.killstreakbundle[killstreaktype];
		empgrenadestokill = (isdefined(bundle.ksempgrenadestokill) ? bundle.ksempgrenadestokill : 0);
		if(empgrenadestokill == 0)
		{
		}
		else
		{
			if(empgrenadestokill > 0)
			{
				emp_weapon_damage = (maxhealth / empgrenadestokill) + 1;
			}
			else
			{
				emp_weapon_damage = 0;
			}
		}
	}
	return emp_weapon_damage;
}

/*
	Name: get_weapon_damage
	Namespace: killstreak_bundles
	Checksum: 0x6098FAA7
	Offset: 0xDF8
	Size: 0x6CA
	Parameters: 8
	Flags: Linked
*/
function get_weapon_damage(killstreaktype, maxhealth, attacker, weapon, type, damage, flags, chargeshotlevel)
{
	weapon_damage = undefined;
	if(isdefined(level.killstreakbundle[killstreaktype]))
	{
		bundle = level.killstreakbundle[killstreaktype];
		if(isdefined(weapon))
		{
			shotstokill = get_shots_to_kill(weapon, type, bundle);
			if(shotstokill == 0)
			{
			}
			else
			{
				if(shotstokill > 0)
				{
					if(isdefined(chargeshotlevel) && chargeshotlevel > 0)
					{
						shotstokill = shotstokill / chargeshotlevel;
					}
					weapon_damage = (maxhealth / shotstokill) + 1;
				}
				else
				{
					weapon_damage = 0;
				}
			}
		}
		if(!isdefined(weapon_damage))
		{
			if(type == "MOD_RIFLE_BULLET" || type == "MOD_PISTOL_BULLET" || type == "MOD_HEAD_SHOT")
			{
				hasarmorpiercing = isdefined(attacker) && isplayer(attacker) && attacker hasperk("specialty_armorpiercing");
				clipstokill = (isdefined(bundle.ksclipstokill) ? bundle.ksclipstokill : 0);
				if(clipstokill == -1)
				{
					weapon_damage = 0;
				}
				else if(hasarmorpiercing && self.aitype !== "spawner_bo3_robot_grunt_assault_mp_escort")
				{
					weapon_damage = damage + (int(damage * level.cac_armorpiercing_data));
				}
				if(weapon.weapclass == "spread")
				{
					ksshotgunmultiplier = (isdefined(bundle.ksshotgunmultiplier) ? bundle.ksshotgunmultiplier : 1);
					if(ksshotgunmultiplier == 0)
					{
					}
					else if(ksshotgunmultiplier > 0)
					{
						weapon_damage = (isdefined(weapon_damage) ? weapon_damage : damage) * ksshotgunmultiplier;
					}
				}
			}
			else
			{
				if(type == "MOD_PROJECTILE" || type == "MOD_EXPLOSIVE" && (!isdefined(weapon.isempkillstreak) || !weapon.isempkillstreak) && weapon.statindex != level.weaponpistolenergy.statindex && weapon.statindex != level.weaponspecialcrossbow.statindex && weapon.statindex != level.weaponsmgnailgun.statindex && weapon.statindex != level.weaponbouncingbetty.statindex)
				{
					if(weapon.statindex == level.weaponshotgunenergy.statindex)
					{
						shotgunenergytokill = (isdefined(bundle.ksshotgunenergytokill) ? bundle.ksshotgunenergytokill : 0);
						if(shotgunenergytokill == 0)
						{
						}
						else
						{
							if(shotgunenergytokill > 0)
							{
								weapon_damage = (maxhealth / shotgunenergytokill) + 1;
							}
							else
							{
								weapon_damage = 0;
							}
						}
					}
					else
					{
						rocketstokill = (isdefined(bundle.ksrocketstokill) ? bundle.ksrocketstokill : 0);
						if(rocketstokill == 0)
						{
						}
						else
						{
							if(rocketstokill > 0)
							{
								if(weapon.rootweapon.name == "launcher_multi")
								{
									rocketstokill = rocketstokill * 2;
								}
								weapon_damage = (maxhealth / rocketstokill) + 1;
							}
							else
							{
								weapon_damage = 0;
							}
						}
					}
				}
				else
				{
					if(type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" && (!isdefined(weapon.isempkillstreak) || !weapon.isempkillstreak))
					{
						grenadedamagemultiplier = (isdefined(bundle.ksgrenadedamagemultiplier) ? bundle.ksgrenadedamagemultiplier : 0);
						if(grenadedamagemultiplier == 0)
						{
						}
						else
						{
							if(grenadedamagemultiplier > 0)
							{
								weapon_damage = damage * grenadedamagemultiplier;
							}
							else
							{
								weapon_damage = 0;
							}
						}
					}
					else
					{
						if(type == "MOD_MELEE_WEAPON_BUTT" || type == "MOD_MELEE")
						{
							ksmeleedamagemultiplier = (isdefined(bundle.ksmeleedamagemultiplier) ? bundle.ksmeleedamagemultiplier : 0);
							if(ksmeleedamagemultiplier == 0)
							{
							}
							else
							{
								if(ksmeleedamagemultiplier > 0)
								{
									weapon_damage = damage * ksmeleedamagemultiplier;
								}
								else
								{
									weapon_damage = 0;
								}
							}
						}
						else if(type == "MOD_PROJECTILE_SPLASH")
						{
							ksprojectilespashmultiplier = (isdefined(bundle.ksprojectilespashmultiplier) ? bundle.ksprojectilespashmultiplier : 0);
							if(ksprojectilespashmultiplier == 0)
							{
							}
							else
							{
								if(ksprojectilespashmultiplier > 0)
								{
									weapon_damage = damage * ksprojectilespashmultiplier;
								}
								else
								{
									weapon_damage = 0;
								}
							}
						}
					}
				}
			}
		}
	}
	return weapon_damage;
}

