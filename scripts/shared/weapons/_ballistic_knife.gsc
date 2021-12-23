// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace ballistic_knife;

/*
	Name: init_shared
	Namespace: ballistic_knife
	Checksum: 0x79AD53C6
	Offset: 0x1C8
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	callback::add_weapon_watcher(&createballisticknifewatcher);
}

/*
	Name: onspawn
	Namespace: ballistic_knife
	Checksum: 0xB6F9F2BC
	Offset: 0x1F8
	Size: 0x334
	Parameters: 2
	Flags: None
*/
function onspawn(watcher, player)
{
	player endon(#"death");
	player endon(#"disconnect");
	level endon(#"game_ended");
	self waittill(#"stationary", endpos, normal, angles, attacker, prey, bone);
	isfriendly = 0;
	if(isdefined(endpos))
	{
		retrievable_model = spawn("script_model", endpos);
		retrievable_model setmodel("wpn_t7_loot_ballistic_knife_projectile");
		retrievable_model setteam(player.team);
		retrievable_model setowner(player);
		retrievable_model.owner = player;
		retrievable_model.angles = angles;
		retrievable_model.name = watcher.weapon;
		retrievable_model.targetname = "sticky_weapon";
		if(isdefined(prey))
		{
			if(level.teambased && player.team == prey.team)
			{
				isfriendly = 1;
			}
			if(!isfriendly)
			{
				if(isalive(prey))
				{
					retrievable_model droptoground(retrievable_model.origin, 80);
				}
				else
				{
					retrievable_model linkto(prey, bone);
				}
			}
			else if(isfriendly)
			{
				retrievable_model physicslaunch(normal, (randomint(10), randomint(10), randomint(10)));
				normal = (0, 0, 1);
			}
		}
		watcher.objectarray[watcher.objectarray.size] = retrievable_model;
		if(isfriendly)
		{
			retrievable_model waittill(#"stationary");
		}
		retrievable_model thread dropknivestoground();
		if(isfriendly)
		{
			player notify(#"ballistic_knife_stationary", retrievable_model, normal);
		}
		else
		{
			player notify(#"ballistic_knife_stationary", retrievable_model, normal, prey);
		}
	}
}

/*
	Name: watch_shutdown
	Namespace: ballistic_knife
	Checksum: 0xBED08E73
	Offset: 0x538
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function watch_shutdown()
{
	pickuptrigger = self.pickuptrigger;
	self waittill(#"death");
	if(isdefined(pickuptrigger))
	{
		pickuptrigger delete();
	}
}

/*
	Name: onspawnretrievetrigger
	Namespace: ballistic_knife
	Checksum: 0x33386E08
	Offset: 0x588
	Size: 0x32C
	Parameters: 2
	Flags: None
*/
function onspawnretrievetrigger(watcher, player)
{
	player endon(#"death");
	player endon(#"disconnect");
	level endon(#"game_ended");
	player waittill(#"ballistic_knife_stationary", retrievable_model, normal, prey);
	if(!isdefined(retrievable_model))
	{
		return;
	}
	vec_scale = 10;
	trigger_pos = [];
	if(isdefined(prey) && (isplayer(prey) || isai(prey)))
	{
		trigger_pos[0] = prey.origin[0];
		trigger_pos[1] = prey.origin[1];
		trigger_pos[2] = prey.origin[2] + vec_scale;
	}
	else
	{
		trigger_pos[0] = retrievable_model.origin[0] + (vec_scale * normal[0]);
		trigger_pos[1] = retrievable_model.origin[1] + (vec_scale * normal[1]);
		trigger_pos[2] = retrievable_model.origin[2] + (vec_scale * normal[2]);
	}
	trigger_pos[2] = trigger_pos[2] - 50;
	retrievable_model clientfield::set("retrievable", 1);
	pickup_trigger = spawn("trigger_radius", (trigger_pos[0], trigger_pos[1], trigger_pos[2]), 0, 50, 100);
	pickup_trigger.owner = player;
	retrievable_model.pickuptrigger = pickup_trigger;
	pickup_trigger enablelinkto();
	if(isdefined(prey))
	{
		pickup_trigger linkto(prey);
	}
	else
	{
		pickup_trigger linkto(retrievable_model);
	}
	retrievable_model thread watch_use_trigger(pickup_trigger, retrievable_model, &pick_up, watcher.pickupsoundplayer, watcher.pickupsound);
	retrievable_model thread watch_shutdown();
}

/*
	Name: watch_use_trigger
	Namespace: ballistic_knife
	Checksum: 0xA5C5FE6C
	Offset: 0x8C0
	Size: 0x2CE
	Parameters: 5
	Flags: None
*/
function watch_use_trigger(trigger, model, callback, playersoundonuse, npcsoundonuse)
{
	self endon(#"death");
	self endon(#"delete");
	level endon(#"game_ended");
	max_ammo = level.weaponballisticknife.maxammo + 1;
	while(true)
	{
		trigger waittill(#"trigger", player);
		if(!isalive(player))
		{
			continue;
		}
		if(!player isonground() && !sessionmodeismultiplayergame())
		{
			continue;
		}
		if(isdefined(trigger.triggerteam) && player.team != trigger.triggerteam)
		{
			continue;
		}
		if(isdefined(trigger.claimedby) && player != trigger.claimedby)
		{
			continue;
		}
		if(!player hasweapon(level.weaponballisticknife, 1))
		{
			continue;
		}
		heldballisticknife = player getweaponforweaponroot(level.weaponballisticknife);
		if(!isdefined(heldballisticknife))
		{
			continue;
		}
		ammo_stock = player getweaponammostock(heldballisticknife);
		ammo_clip = player getweaponammoclip(heldballisticknife);
		total_ammo = ammo_stock + ammo_clip;
		hasreloaded = 1;
		if(total_ammo > 0 && ammo_stock == total_ammo)
		{
			hasreloaded = 0;
		}
		if(total_ammo >= max_ammo || !hasreloaded)
		{
			continue;
		}
		if(isdefined(playersoundonuse))
		{
			player playlocalsound(playersoundonuse);
		}
		if(isdefined(npcsoundonuse))
		{
			player playsound(npcsoundonuse);
		}
		self thread [[callback]](player);
		break;
	}
}

/*
	Name: pick_up
	Namespace: ballistic_knife
	Checksum: 0xF774C980
	Offset: 0xB98
	Size: 0x18C
	Parameters: 1
	Flags: None
*/
function pick_up(player)
{
	self destroy_ent();
	current_weapon = player getcurrentweapon();
	player challenges::pickedupballisticknife();
	if(current_weapon.rootweapon != level.weaponballisticknife)
	{
		heldballisticknife = player getweaponforweaponroot(level.weaponballisticknife);
		if(!isdefined(heldballisticknife))
		{
			return;
		}
		clip_ammo = player getweaponammoclip(heldballisticknife);
		if(!clip_ammo)
		{
			player setweaponammoclip(heldballisticknife, 1);
		}
		else
		{
			new_ammo_stock = player getweaponammostock(heldballisticknife) + 1;
			player setweaponammostock(heldballisticknife, new_ammo_stock);
		}
	}
	else
	{
		new_ammo_stock = player getweaponammostock(current_weapon) + 1;
		player setweaponammostock(current_weapon, new_ammo_stock);
	}
}

/*
	Name: destroy_ent
	Namespace: ballistic_knife
	Checksum: 0xA5EFF024
	Offset: 0xD30
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function destroy_ent()
{
	if(isdefined(self))
	{
		pickuptrigger = self.pickuptrigger;
		if(isdefined(pickuptrigger))
		{
			pickuptrigger delete();
		}
		self delete();
	}
}

/*
	Name: dropknivestoground
	Namespace: ballistic_knife
	Checksum: 0x748F31AA
	Offset: 0xD98
	Size: 0x58
	Parameters: 0
	Flags: None
*/
function dropknivestoground()
{
	self endon(#"death");
	for(;;)
	{
		level waittill(#"drop_objects_to_ground", origin, radius);
		self droptoground(origin, radius);
	}
}

/*
	Name: droptoground
	Namespace: ballistic_knife
	Checksum: 0xF9503A0B
	Offset: 0xDF8
	Size: 0x7C
	Parameters: 2
	Flags: None
*/
function droptoground(origin, radius)
{
	if(distancesquared(origin, self.origin) < (radius * radius))
	{
		self physicslaunch((0, 0, 1), vectorscale((1, 1, 1), 5));
		self thread updateretrievetrigger();
	}
}

/*
	Name: updateretrievetrigger
	Namespace: ballistic_knife
	Checksum: 0x4CDEFEB9
	Offset: 0xE80
	Size: 0x84
	Parameters: 0
	Flags: None
*/
function updateretrievetrigger()
{
	self endon(#"death");
	self waittill(#"stationary");
	trigger = self.pickuptrigger;
	trigger.origin = (self.origin[0], self.origin[1], self.origin[2] + 10);
	trigger linkto(self);
}

/*
	Name: createballisticknifewatcher
	Namespace: ballistic_knife
	Checksum: 0x34016E70
	Offset: 0xF10
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function createballisticknifewatcher()
{
	watcher = self weaponobjects::createuseweaponobjectwatcher("knife_ballistic", self.team);
	watcher.onspawn = &onspawn;
	watcher.ondetonatecallback = &weaponobjects::deleteent;
	watcher.onspawnretrievetriggers = &onspawnretrievetrigger;
	watcher.storedifferentobject = 1;
}

