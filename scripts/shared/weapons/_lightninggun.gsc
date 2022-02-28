// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\killcam_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace lightninggun;

/*
	Name: init_shared
	Namespace: lightninggun
	Checksum: 0x4D8BFBF6
	Offset: 0x358
	Size: 0x184
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	level.weaponlightninggun = getweapon("hero_lightninggun");
	level.weaponlightninggunarc = getweapon("hero_lightninggun_arc");
	level.weaponlightninggunkillcamtime = getdvarfloat("scr_lightningGunKillcamTime", 0.35);
	level.weaponlightninggunkillcamdecelpercent = getdvarfloat("scr_lightningGunKillcamDecelPercent", 0.25);
	level.weaponlightninggunkillcamoffset = getdvarfloat("scr_lightningGunKillcamOffset", 150);
	level.lightninggun_arc_range = 300;
	level.lightninggun_arc_range_sq = level.lightninggun_arc_range * level.lightninggun_arc_range;
	level.lightninggun_arc_speed = 650;
	level.lightninggun_arc_speed_sq = level.lightninggun_arc_speed * level.lightninggun_arc_speed;
	level.lightninggun_arc_fx_min_range = 1;
	level.lightninggun_arc_fx_min_range_sq = level.lightninggun_arc_fx_min_range * level.lightninggun_arc_fx_min_range;
	level._effect["lightninggun_arc"] = "weapon/fx_lightninggun_arc";
	callback::add_weapon_damage(level.weaponlightninggun, &on_damage_lightninggun);
	/#
		level thread update_dvars();
	#/
}

/*
	Name: update_dvars
	Namespace: lightninggun
	Checksum: 0x33CC7E23
	Offset: 0x4E8
	Size: 0x90
	Parameters: 0
	Flags: None
*/
function update_dvars()
{
	/#
		while(true)
		{
			wait(1);
			level.weaponlightninggunkillcamtime = getdvarfloat("", 0.35);
			level.weaponlightninggunkillcamdecelpercent = getdvarfloat("", 0.25);
			level.weaponlightninggunkillcamoffset = getdvarfloat("", 150);
		}
	#/
}

/*
	Name: lightninggun_start_damage_effects
	Namespace: lightninggun
	Checksum: 0xB8A571B7
	Offset: 0x580
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function lightninggun_start_damage_effects(eattacker)
{
	self endon(#"disconnect");
	/#
		if(isgodmode(self))
		{
			return;
		}
	#/
	self setelectrifiedstate(1);
	self.electrifiedby = eattacker;
	self playrumbleonentity("lightninggun_victim");
	wait(2);
	self.electrifiedby = undefined;
	self setelectrifiedstate(0);
}

/*
	Name: lightninggun_arc_killcam
	Namespace: lightninggun
	Checksum: 0xD1B58D17
	Offset: 0x628
	Size: 0xB4
	Parameters: 5
	Flags: None
*/
function lightninggun_arc_killcam(arc_source_pos, arc_target, arc_target_pos, original_killcam_ent, waittime)
{
	arc_target.killcamkilledbyent = create_killcam_entity(original_killcam_ent.origin, original_killcam_ent.angles, level.weaponlightninggunarc);
	arc_target.killcamkilledbyent killcam::store_killcam_entity_on_entity(original_killcam_ent);
	arc_target.killcamkilledbyent killcam_move(arc_source_pos, arc_target_pos, waittime);
}

/*
	Name: lightninggun_arc_fx
	Namespace: lightninggun
	Checksum: 0xF3E1E87A
	Offset: 0x6E8
	Size: 0x282
	Parameters: 5
	Flags: None
*/
function lightninggun_arc_fx(arc_source_pos, arc_target, arc_target_pos, distancesq, original_killcam_ent)
{
	if(!isdefined(arc_target) || !isdefined(original_killcam_ent))
	{
		return;
	}
	waittime = 0.25;
	if(level.lightninggun_arc_speed_sq > 100 && distancesq > 1)
	{
		waittime = distancesq / level.lightninggun_arc_speed_sq;
	}
	lightninggun_arc_killcam(arc_source_pos, arc_target, arc_target_pos, original_killcam_ent, waittime);
	killcamentity = arc_target.killcamkilledbyent;
	if(!isdefined(arc_target) || !isdefined(original_killcam_ent))
	{
		return;
	}
	if(distancesq < level.lightninggun_arc_fx_min_range_sq)
	{
		wait(waittime);
		killcamentity delete();
		if(isdefined(arc_target))
		{
			arc_target.killcamkilledbyent = undefined;
		}
		return;
	}
	fxorg = spawn("script_model", arc_source_pos);
	fxorg setmodel("tag_origin");
	fx = playfxontag(level._effect["lightninggun_arc"], fxorg, "tag_origin");
	playsoundatposition("wpn_lightning_gun_bounce", fxorg.origin);
	fxorg moveto(arc_target_pos, waittime);
	fxorg waittill(#"movedone");
	util::wait_network_frame();
	util::wait_network_frame();
	util::wait_network_frame();
	fxorg delete();
	killcamentity delete();
	if(isdefined(arc_target))
	{
		arc_target.killcamkilledbyent = undefined;
	}
}

/*
	Name: lightninggun_arc
	Namespace: lightninggun
	Checksum: 0xF42CCA32
	Offset: 0x978
	Size: 0x164
	Parameters: 8
	Flags: None
*/
function lightninggun_arc(delay, eattacker, arc_source, arc_source_origin, arc_source_pos, arc_target, arc_target_pos, distancesq)
{
	if(delay)
	{
		wait(delay);
		if(!isdefined(arc_target) || !isalive(arc_target))
		{
			return;
		}
		distancesq = distancesquared(arc_target.origin, arc_source_origin);
		if(distancesq > level.lightninggun_arc_range_sq)
		{
			return;
		}
	}
	if(!isdefined(arc_source))
	{
		return;
	}
	if(!isdefined(arc_source.killcamkilledbyent))
	{
		return;
	}
	level thread lightninggun_arc_fx(arc_source_pos, arc_target, arc_target_pos, distancesq, arc_source.killcamkilledbyent);
	arc_target thread lightninggun_start_damage_effects(eattacker);
	arc_target dodamage(arc_target.health, arc_source_pos, eattacker, arc_source, "none", "MOD_PISTOL_BULLET", 0, level.weaponlightninggunarc);
}

/*
	Name: lightninggun_find_arc_targets
	Namespace: lightninggun
	Checksum: 0x17C5DC1A
	Offset: 0xAE8
	Size: 0x23C
	Parameters: 4
	Flags: None
*/
function lightninggun_find_arc_targets(eattacker, arc_source, arc_source_origin, arc_source_pos)
{
	delay = 0.05;
	if(!isdefined(eattacker))
	{
		return;
	}
	allenemyaliveplayers = util::get_other_teams_alive_players_s(eattacker.team);
	closestplayers = arraysort(allenemyaliveplayers.a, arc_source_origin, 1);
	foreach(player in closestplayers)
	{
		if(isdefined(arc_source) && player == arc_source)
		{
			continue;
		}
		if(player player::is_spawn_protected())
		{
			continue;
		}
		distancesq = distancesquared(player.origin, arc_source_origin);
		if(distancesq > level.lightninggun_arc_range_sq)
		{
			break;
		}
		if(eattacker != player && weaponobjects::friendlyfirecheck(eattacker, player))
		{
			if(isdefined(self) && !player damageconetrace(arc_source_pos, self))
			{
				continue;
			}
			level thread lightninggun_arc(delay, eattacker, arc_source, arc_source_origin, arc_source_pos, player, player gettagorigin("j_spineupper"), distancesq);
			delay = delay + 0.05;
		}
	}
}

/*
	Name: create_killcam_entity
	Namespace: lightninggun
	Checksum: 0x2AC7397F
	Offset: 0xD30
	Size: 0x98
	Parameters: 3
	Flags: None
*/
function create_killcam_entity(origin, angles, weapon)
{
	killcamkilledbyent = spawn("script_model", origin);
	killcamkilledbyent setmodel("tag_origin");
	killcamkilledbyent.angles = angles;
	killcamkilledbyent setweapon(weapon);
	return killcamkilledbyent;
}

/*
	Name: killcam_move
	Namespace: lightninggun
	Checksum: 0x553F1292
	Offset: 0xDD0
	Size: 0x140
	Parameters: 3
	Flags: None
*/
function killcam_move(start_origin, end_origin, time)
{
	delta = end_origin - start_origin;
	dist = length(delta);
	delta = vectornormalize(delta);
	move_to_dist = dist - level.weaponlightninggunkillcamoffset;
	end_angles = (0, 0, 0);
	if(move_to_dist > 0)
	{
		move_to_pos = start_origin + (delta * move_to_dist);
		self moveto(move_to_pos, time, 0, time * level.weaponlightninggunkillcamdecelpercent);
		end_angles = vectortoangles(delta);
	}
	else
	{
		delta = end_origin - self.origin;
		end_angles = vectortoangles(delta);
	}
}

/*
	Name: lightninggun_damage_response
	Namespace: lightninggun
	Checksum: 0xC9EA10C6
	Offset: 0xF18
	Size: 0x252
	Parameters: 5
	Flags: None
*/
function lightninggun_damage_response(eattacker, einflictor, weapon, meansofdeath, damage)
{
	source_pos = eattacker.origin;
	bolt_source_pos = eattacker gettagorigin("tag_flash");
	arc_source = self;
	arc_source_origin = self.origin;
	arc_source_pos = self gettagorigin("j_spineupper");
	delta = arc_source_pos - bolt_source_pos;
	angles = (0, 0, 0);
	arc_source.killcamkilledbyent = create_killcam_entity(bolt_source_pos, angles, weapon);
	arc_source.killcamkilledbyent killcam_move(bolt_source_pos, arc_source_pos, level.weaponlightninggunkillcamtime);
	killcamentity = arc_source.killcamkilledbyent;
	self thread lightninggun_start_damage_effects(eattacker);
	wait(2);
	if(!isdefined(self))
	{
		self thread lightninggun_find_arc_targets(eattacker, undefined, arc_source_origin, arc_source_pos);
		return;
	}
	if(isdefined(self.body))
	{
		arc_source_origin = self.body.origin;
		arc_source_pos = self.body gettagorigin("j_spineupper");
	}
	self thread lightninggun_find_arc_targets(eattacker, arc_source, arc_source_origin, arc_source_pos);
	wait(0.45);
	killcamentity delete();
	if(isdefined(arc_source))
	{
		arc_source.killcamkilledbyent = undefined;
	}
}

/*
	Name: on_damage_lightninggun
	Namespace: lightninggun
	Checksum: 0x9B115F62
	Offset: 0x1178
	Size: 0x74
	Parameters: 5
	Flags: None
*/
function on_damage_lightninggun(eattacker, einflictor, weapon, meansofdeath, damage)
{
	if("MOD_PISTOL_BULLET" != meansofdeath && "MOD_HEAD_SHOT" != meansofdeath)
	{
		return;
	}
	self thread lightninggun_damage_response(eattacker, einflictor, weapon, meansofdeath, damage);
}

