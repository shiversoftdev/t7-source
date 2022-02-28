// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_weaponobjects;

#namespace heat_wave;

/*
	Name: __init__sytem__
	Namespace: heat_wave
	Checksum: 0x559395F0
	Offset: 0x440
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_heat_wave", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: heat_wave
	Checksum: 0x8E9BFD7B
	Offset: 0x480
	Size: 0x248
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(41, &gadget_heat_wave_on_activate, &gadget_heat_wave_on_deactivate);
	ability_player::register_gadget_possession_callbacks(41, &gadget_heat_wave_on_give, &gadget_heat_wave_on_take);
	ability_player::register_gadget_flicker_callbacks(41, &gadget_heat_wave_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(41, &gadget_heat_wave_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(41, &gadget_heat_wave_is_flickering);
	callback::on_connect(&gadget_heat_wave_on_connect);
	callback::on_spawned(&gadget_heat_wave_on_player_spawn);
	clientfield::register("scriptmover", "heatwave_fx", 1, 1, "int");
	clientfield::register("allplayers", "heatwave_victim", 1, 1, "int");
	clientfield::register("toplayer", "heatwave_activate", 1, 1, "int");
	if(!isdefined(level.vsmgr_prio_visionset_heatwave_activate))
	{
		level.vsmgr_prio_visionset_heatwave_activate = 52;
	}
	if(!isdefined(level.vsmgr_prio_visionset_heatwave_charred))
	{
		level.vsmgr_prio_visionset_heatwave_charred = 53;
	}
	visionset_mgr::register_info("visionset", "heatwave", 1, level.vsmgr_prio_visionset_heatwave_activate, 16, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
	visionset_mgr::register_info("visionset", "charred", 1, level.vsmgr_prio_visionset_heatwave_charred, 16, 1, &visionset_mgr::ramp_in_out_thread_per_player_death_shutdown, 0);
	/#
	#/
}

/*
	Name: updatedvars
	Namespace: heat_wave
	Checksum: 0x3909D333
	Offset: 0x6D0
	Size: 0x18
	Parameters: 0
	Flags: None
*/
function updatedvars()
{
	while(true)
	{
		wait(1);
	}
}

/*
	Name: gadget_heat_wave_is_inuse
	Namespace: heat_wave
	Checksum: 0x76DB6B76
	Offset: 0x6F0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_heat_wave_is_inuse(slot)
{
	return self gadgetisactive(slot);
}

/*
	Name: gadget_heat_wave_is_flickering
	Namespace: heat_wave
	Checksum: 0xC6D08034
	Offset: 0x720
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_heat_wave_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: gadget_heat_wave_on_flicker
	Namespace: heat_wave
	Checksum: 0x52CB0928
	Offset: 0x750
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_heat_wave_on_flicker(slot, weapon)
{
	self thread gadget_heat_wave_flicker(slot, weapon);
}

/*
	Name: gadget_heat_wave_on_give
	Namespace: heat_wave
	Checksum: 0xADBEADA5
	Offset: 0x790
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_heat_wave_on_give(slot, weapon)
{
}

/*
	Name: gadget_heat_wave_on_take
	Namespace: heat_wave
	Checksum: 0x20B60633
	Offset: 0x7B0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_heat_wave_on_take(slot, weapon)
{
	self clientfield::set_to_player("heatwave_activate", 0);
}

/*
	Name: gadget_heat_wave_on_connect
	Namespace: heat_wave
	Checksum: 0x99EC1590
	Offset: 0x7F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function gadget_heat_wave_on_connect()
{
}

/*
	Name: gadget_heat_wave_on_player_spawn
	Namespace: heat_wave
	Checksum: 0x6940A513
	Offset: 0x800
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function gadget_heat_wave_on_player_spawn()
{
	self clientfield::set("heatwave_victim", 0);
	self._heat_wave_stuned_end = 0;
	self._heat_wave_stunned_by = undefined;
	self thread watch_entity_shutdown();
}

/*
	Name: watch_entity_shutdown
	Namespace: heat_wave
	Checksum: 0x1F8EDB3
	Offset: 0x858
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function watch_entity_shutdown()
{
	self endon(#"disconnect");
	self waittill(#"death");
	if(self isremotecontrolling() == 0)
	{
		visionset_mgr::deactivate("visionset", "charred", self);
		visionset_mgr::deactivate("visionset", "heatwave", self);
	}
}

/*
	Name: gadget_heat_wave_on_activate
	Namespace: heat_wave
	Checksum: 0xF42DAA51
	Offset: 0x8E0
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function gadget_heat_wave_on_activate(slot, weapon)
{
	self playrumbleonentity("heat_wave_activate");
	self thread toggle_activate_clientfields();
	visionset_mgr::activate("visionset", "heatwave", self, 0.01, 0.1, 1.1);
	self thread heat_wave_think(slot, weapon);
}

/*
	Name: toggle_activate_clientfields
	Namespace: heat_wave
	Checksum: 0x2B5A6823
	Offset: 0x990
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function toggle_activate_clientfields()
{
	self endon(#"death");
	self endon(#"disconnect");
	self clientfield::set_to_player("heatwave_activate", 1);
	util::wait_network_frame();
	self clientfield::set_to_player("heatwave_activate", 0);
}

/*
	Name: gadget_heat_wave_on_deactivate
	Namespace: heat_wave
	Checksum: 0x63EEDD79
	Offset: 0xA08
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_heat_wave_on_deactivate(slot, weapon)
{
}

/*
	Name: gadget_heat_wave_flicker
	Namespace: heat_wave
	Checksum: 0x6DB021EA
	Offset: 0xA28
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_heat_wave_flicker(slot, weapon)
{
}

/*
	Name: set_gadget_status
	Namespace: heat_wave
	Checksum: 0x199CA3F3
	Offset: 0xA48
	Size: 0x9C
	Parameters: 2
	Flags: None
*/
function set_gadget_status(status, time)
{
	timestr = "";
	if(isdefined(time))
	{
		timestr = (("^3") + ", time: ") + time;
	}
	if(getdvarint("scr_cpower_debug_prints") > 0)
	{
		self iprintlnbold(("Gadget Heat Wave: " + status) + timestr);
	}
}

/*
	Name: is_entity_valid
	Namespace: heat_wave
	Checksum: 0x510A89F5
	Offset: 0xAF0
	Size: 0xC6
	Parameters: 2
	Flags: Linked
*/
function is_entity_valid(entity, heatwave)
{
	if(!isplayer(entity))
	{
		return false;
	}
	if(self getentitynumber() == entity getentitynumber())
	{
		return false;
	}
	if(!isalive(entity))
	{
		return false;
	}
	if(!entity util::mayapplyscreeneffect())
	{
		return false;
	}
	if(!heat_wave_trace_entity(entity, heatwave))
	{
		return false;
	}
	return true;
}

/*
	Name: heat_wave_trace_entity
	Namespace: heat_wave
	Checksum: 0xF4B9A7F0
	Offset: 0xBC0
	Size: 0xA8
	Parameters: 2
	Flags: Linked
*/
function heat_wave_trace_entity(entity, heatwave)
{
	entitypoint = entity.origin + vectorscale((0, 0, 1), 50);
	if(!bullettracepassed(heatwave.origin, entitypoint, 1, self, undefined, 0, 1))
	{
		return false;
	}
	/#
		thread util::draw_debug_line(heatwave.origin, entitypoint, 1);
	#/
	return true;
}

/*
	Name: heat_wave_fx_cleanup
	Namespace: heat_wave
	Checksum: 0x8138C621
	Offset: 0xC70
	Size: 0xB4
	Parameters: 2
	Flags: Linked
*/
function heat_wave_fx_cleanup(fxorg, direction)
{
	self util::waittill_any("heat_wave_think", "heat_wave_think_finished");
	if(isdefined(fxorg))
	{
		fxorg stoploopsound();
		fxorg playsound("gdt_heatwave_dissipate");
		fxorg clientfield::set("heatwave_fx", 0);
		fxorg delete();
	}
}

/*
	Name: heat_wave_fx
	Namespace: heat_wave
	Checksum: 0xDFCF81C0
	Offset: 0xD30
	Size: 0x180
	Parameters: 2
	Flags: Linked
*/
function heat_wave_fx(origin, direction)
{
	if(direction == (0, 0, 0))
	{
		direction = (0, 0, 1);
	}
	dirvec = vectornormalize(direction);
	angles = vectortoangles(dirvec);
	fxorg = spawn("script_model", origin + (vectorscale((0, 0, -1), 30)), 0, angles);
	fxorg.angles = angles;
	fxorg setowner(self);
	fxorg setmodel("tag_origin");
	fxorg clientfield::set("heatwave_fx", 1);
	fxorg playloopsound("gdt_heatwave_3p_loop");
	fxorg.soundmod = "heatwave";
	fxorg.hitsomething = 0;
	self thread heat_wave_fx_cleanup(fxorg, direction);
	return fxorg;
}

/*
	Name: heat_wave_setup
	Namespace: heat_wave
	Checksum: 0x37DEBEE2
	Offset: 0xEB8
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function heat_wave_setup(weapon)
{
	heatwave = spawnstruct();
	heatwave.radius = weapon.gadget_shockfield_radius;
	heatwave.origin = self geteye();
	heatwave.direction = anglestoforward(self getplayerangles());
	heatwave.up = anglestoup(self getplayerangles());
	heatwave.fxorg = heat_wave_fx(heatwave.origin, heatwave.direction);
	return heatwave;
}

/*
	Name: heat_wave_think
	Namespace: heat_wave
	Checksum: 0xE63CEDE6
	Offset: 0xFC8
	Size: 0x106
	Parameters: 2
	Flags: Linked
*/
function heat_wave_think(slot, weapon)
{
	self endon(#"disconnect");
	self notify(#"heat_wave_think");
	self endon(#"heat_wave_think");
	self.heroabilityactive = 1;
	heatwave = heat_wave_setup(weapon);
	glassradiusdamage(heatwave.origin, heatwave.radius, 400, 400, "MOD_BURNED");
	self thread heat_wave_damage_entities(weapon, heatwave);
	self thread heat_wave_damage_projectiles(weapon, heatwave);
	wait(0.25);
	self.heroabilityactive = 0;
	self notify(#"heat_wave_think_finished");
}

/*
	Name: heat_wave_damage_entities
	Namespace: heat_wave
	Checksum: 0xF9626BB2
	Offset: 0x10D8
	Size: 0x258
	Parameters: 2
	Flags: Linked
*/
function heat_wave_damage_entities(weapon, heatwave)
{
	self endon(#"disconnect");
	self endon(#"heat_wave_think");
	starttime = gettime();
	burnedenemy = 0;
	while((250 + starttime) > gettime())
	{
		entities = getdamageableentarray(heatwave.origin, heatwave.radius, 1);
		foreach(entity in entities)
		{
			if(isdefined(entity._heat_wave_damaged_time) && ((entity._heat_wave_damaged_time + 250) + 1) > gettime())
			{
				continue;
			}
			if(is_entity_valid(entity, heatwave))
			{
				burnedenemy = burnedenemy | heat_wave_burn_entities(weapon, entity, heatwave);
				continue;
			}
			if(!isplayer(entity))
			{
				entity dodamage(1, heatwave.origin, self, self, "none", "MOD_BURNED", 0, weapon);
				entity thread update_last_burned_by(heatwave);
			}
		}
		wait(0.05);
	}
	if(isalive(self) && (isdefined(burnedenemy) && burnedenemy) && isdefined(level.playgadgetsuccess))
	{
		self [[level.playgadgetsuccess]](weapon, "heatwaveSuccessDelay");
	}
}

/*
	Name: heat_wave_burn_entities
	Namespace: heat_wave
	Checksum: 0x63FC4747
	Offset: 0x1338
	Size: 0x160
	Parameters: 3
	Flags: Linked
*/
function heat_wave_burn_entities(weapon, entity, heatwave)
{
	burn_self = 0;
	burn_entity = 1;
	burned_enemy = 1;
	if(self.team == entity.team)
	{
		burned_enemy = 0;
		switch(level.friendlyfire)
		{
			case 0:
			{
				burn_entity = 0;
				break;
			}
			case 1:
			{
				break;
			}
			case 2:
			{
				burn_entity = 0;
				burn_self = 1;
				break;
			}
			case 3:
			{
				burn_self = 1;
				break;
			}
		}
	}
	if(burn_entity)
	{
		apply_burn(weapon, entity, heatwave);
		entity thread update_last_burned_by(heatwave);
	}
	if(burn_self)
	{
		apply_burn(weapon, self, heatwave);
		self thread update_last_burned_by(heatwave);
	}
	return burned_enemy;
}

/*
	Name: heat_wave_damage_projectiles
	Namespace: heat_wave
	Checksum: 0x18602068
	Offset: 0x14A0
	Size: 0x298
	Parameters: 2
	Flags: Linked
*/
function heat_wave_damage_projectiles(weapon, heatwave)
{
	self endon(#"disconnect");
	self endon(#"heat_wave_think");
	owner = self;
	starttime = gettime();
	while((250 + starttime) > gettime())
	{
		if(level.missileentities.size < 1)
		{
			wait(0.05);
			continue;
		}
		for(index = 0; index < level.missileentities.size; index++)
		{
			wait(0.05);
			grenade = level.missileentities[index];
			if(!isdefined(grenade))
			{
				continue;
			}
			if(grenade.weapon.istacticalinsertion)
			{
				continue;
			}
			switch(grenade.model)
			{
				case "t6_wpn_grenade_supply_projectile":
				{
					continue;
				}
			}
			if(!isdefined(grenade.owner))
			{
				grenade.owner = getmissileowner(grenade);
			}
			if(isdefined(grenade.owner))
			{
				if(level.teambased)
				{
					if(grenade.owner.team == owner.team)
					{
						continue;
					}
				}
				else if(grenade.owner == owner)
				{
					continue;
				}
				grenadedistancesquared = distancesquared(grenade.origin, heatwave.origin);
				if(grenadedistancesquared < (heatwave.radius * heatwave.radius))
				{
					if(bullettracepassed(grenade.origin, heatwave.origin + vectorscale((0, 0, 1), 29), 0, owner, grenade, 0, 1))
					{
						owner projectileexplode(grenade, heatwave, weapon);
						index--;
					}
				}
			}
		}
	}
}

/*
	Name: projectileexplode
	Namespace: heat_wave
	Checksum: 0xB07D4E51
	Offset: 0x1740
	Size: 0xAC
	Parameters: 3
	Flags: Linked
*/
function projectileexplode(projectile, heatwave, weapon)
{
	projposition = projectile.origin;
	playfx(level.trophydetonationfx, projposition);
	projectile notify(#"trophy_destroyed");
	self radiusdamage(projposition, 128, 105, 10, self, "MOD_BURNED", weapon);
	projectile delete();
}

/*
	Name: apply_burn
	Namespace: heat_wave
	Checksum: 0x3A19DFDA
	Offset: 0x17F8
	Size: 0x206
	Parameters: 3
	Flags: Linked
*/
function apply_burn(weapon, entity, heatwave)
{
	damage = floor(entity.health * 0.2);
	entity dodamage(damage, self.origin + vectorscale((0, 0, 1), 30), self, heatwave.fxorg, 0, "MOD_BURNED", 0, weapon);
	entity setdoublejumpenergy(0);
	entity clientfield::set("heatwave_victim", 1);
	visionset_mgr::activate("visionset", "charred", entity, 0.01, 2, 1.5);
	entity thread watch_burn_clear();
	entity resetdoublejumprechargetime();
	shellshock_duration = 2.5;
	entity._heat_wave_stuned_end = gettime() + (shellshock_duration * 1000);
	if(!isdefined(entity._heat_wave_stunned_by))
	{
		entity._heat_wave_stunned_by = [];
	}
	entity._heat_wave_stunned_by[self.clientid] = entity._heat_wave_stuned_end;
	entity shellshock("heat_wave", shellshock_duration, 1);
	entity thread heat_wave_burn_sound(shellshock_duration);
	burned = 1;
}

/*
	Name: watch_burn_clear
	Namespace: heat_wave
	Checksum: 0x356F2356
	Offset: 0x1A08
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function watch_burn_clear()
{
	self endon(#"disconnect");
	self endon(#"death");
	util::wait_network_frame();
	self clientfield::set("heatwave_victim", 0);
}

/*
	Name: update_last_burned_by
	Namespace: heat_wave
	Checksum: 0x7FD4F08A
	Offset: 0x1A60
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function update_last_burned_by(heatwave)
{
	self endon(#"disconnect");
	self endon(#"death");
	self._heat_wave_damaged_time = gettime();
	wait(250);
}

/*
	Name: heat_wave_burn_sound
	Namespace: heat_wave
	Checksum: 0x56683D25
	Offset: 0x1AA0
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function heat_wave_burn_sound(shellshock_duration)
{
	fire_sound_ent = spawn("script_origin", self.origin);
	fire_sound_ent linkto(self, "tag_origin", (0, 0, 0), (0, 0, 0));
	fire_sound_ent playloopsound("mpl_heatwave_burn_loop");
	wait(shellshock_duration);
	if(isdefined(fire_sound_ent))
	{
		fire_sound_ent stoploopsound(0.5);
		util::wait_network_frame();
		fire_sound_ent delete();
	}
}

