// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#using_animtree("zm_ally");

#namespace zm_clone;

/*
	Name: spawn_player_clone
	Namespace: zm_clone
	Checksum: 0x46C1B98D
	Offset: 0x1A8
	Size: 0x2F4
	Parameters: 4
	Flags: None
*/
function spawn_player_clone(player, origin = player.origin, forceweapon, forcemodel)
{
	primaryweapons = player getweaponslistprimaries();
	if(isdefined(forceweapon))
	{
		weapon = forceweapon;
	}
	else
	{
		if(primaryweapons.size)
		{
			weapon = primaryweapons[0];
		}
		else
		{
			weapon = player getcurrentweapon();
		}
	}
	weaponmodel = weapon.worldmodel;
	spawner = getent("fake_player_spawner", "targetname");
	if(isdefined(spawner))
	{
		clone = spawner spawnfromspawner();
		clone.origin = origin;
		clone.isactor = 1;
	}
	else
	{
		clone = spawn("script_model", origin);
		clone.isactor = 0;
	}
	if(isdefined(forcemodel))
	{
		clone setmodel(forcemodel);
	}
	else
	{
		mdl_body = player getcharacterbodymodel();
		clone setmodel(mdl_body);
		bodyrenderoptions = player getcharacterbodyrenderoptions();
		clone setbodyrenderoptions(bodyrenderoptions, bodyrenderoptions, bodyrenderoptions);
	}
	if(weaponmodel != "" && weaponmodel != "none")
	{
		clone attach(weaponmodel, "tag_weapon_right");
	}
	clone.team = player.team;
	clone.is_inert = 1;
	clone.zombie_move_speed = "walk";
	clone.script_noteworthy = "corpse_clone";
	clone.actor_damage_func = &clone_damage_func;
	return clone;
}

/*
	Name: clone_damage_func
	Namespace: zm_clone
	Checksum: 0x2B27C8A2
	Offset: 0x4A8
	Size: 0xA2
	Parameters: 11
	Flags: Linked
*/
function clone_damage_func(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex)
{
	idamage = 0;
	if(weapon.isballisticknife && zm_weapons::is_weapon_upgraded(weapon))
	{
		self notify(#"player_revived", eattacker);
	}
	return idamage;
}

/*
	Name: clone_give_weapon
	Namespace: zm_clone
	Checksum: 0x81E12050
	Offset: 0x558
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function clone_give_weapon(weapon)
{
	weaponmodel = weapon.worldmodel;
	if(weaponmodel != "" && weaponmodel != "none")
	{
		self attach(weaponmodel, "tag_weapon_right");
	}
}

/*
	Name: clone_animate
	Namespace: zm_clone
	Checksum: 0x4348116F
	Offset: 0x5D0
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function clone_animate(animtype)
{
	if(self.isactor)
	{
		self thread clone_actor_animate(animtype);
	}
	else
	{
		self thread clone_mover_animate(animtype);
	}
}

/*
	Name: clone_actor_animate
	Namespace: zm_clone
	Checksum: 0x47FBB9DC
	Offset: 0x628
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function clone_actor_animate(animtype)
{
	wait(0.1);
	switch(animtype)
	{
		case "laststand":
		{
			self setanimstatefromasd("laststand");
			break;
		}
		case "idle":
		default:
		{
			self setanimstatefromasd("idle");
			break;
		}
	}
}

/*
	Name: clone_mover_animate
	Namespace: zm_clone
	Checksum: 0x853F6AF0
	Offset: 0x6B0
	Size: 0x12E
	Parameters: 1
	Flags: Linked
*/
function clone_mover_animate(animtype)
{
	self useanimtree($zm_ally);
	switch(animtype)
	{
		case "laststand":
		{
			self setanim(%zm_ally::pb_laststand_idle);
			break;
		}
		case "afterlife":
		{
			self setanim(%zm_ally::pb_afterlife_laststand_idle);
			break;
		}
		case "chair":
		{
			self setanim(%zm_ally::ai_actor_elec_chair_idle);
			break;
		}
		case "falling":
		{
			self setanim(%zm_ally::pb_falling_loop);
			break;
		}
		case "idle":
		default:
		{
			self setanim(%zm_ally::pb_stand_alert);
			break;
		}
	}
}

