// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_ai_faller;

/*
	Name: init
	Namespace: zm_ai_faller
	Checksum: 0x13FA66B9
	Offset: 0x578
	Size: 0x64
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initfallerbehaviorsandasm();
	animationstatenetwork::registernotetrackhandlerfunction("faller_melee", &handle_fall_notetracks);
	animationstatenetwork::registernotetrackhandlerfunction("deathout", &handle_fall_death_notetracks);
}

/*
	Name: initfallerbehaviorsandasm
	Namespace: zm_ai_faller
	Checksum: 0xF8CC7C68
	Offset: 0x5E8
	Size: 0x124
	Parameters: 0
	Flags: Linked, Private
*/
function private initfallerbehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreeaction("fallerDropAction", &fallerdropaction, &fallerdropactionupdate, &fallerdropactionterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldFallerDrop", &shouldfallerdrop);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isFallerInCeiling", &isfallerinceiling);
	behaviortreenetworkutility::registerbehaviortreescriptapi("fallerCeilingDeath", &fallerceilingdeath);
	animationstatenetwork::registeranimationmocomp("mocomp_drop@faller", &mocompfallerdrop, undefined, undefined);
	animationstatenetwork::registeranimationmocomp("mocomp_ceiling_death@faller", &mocompceilingdeath, undefined, undefined);
}

/*
	Name: fallerdropaction
	Namespace: zm_ai_faller
	Checksum: 0xCA56724B
	Offset: 0x718
	Size: 0x30
	Parameters: 2
	Flags: Linked
*/
function fallerdropaction(entity, asmstatename)
{
	animationstatenetworkutility::requeststate(entity, asmstatename);
	return 5;
}

/*
	Name: fallerdropactionupdate
	Namespace: zm_ai_faller
	Checksum: 0xA4416119
	Offset: 0x750
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function fallerdropactionupdate(entity, asmstatename)
{
	ground_pos = zm_utility::groundpos_ignore_water_new(entity.origin);
	if((entity.origin[2] - ground_pos[2]) < 20)
	{
		return 4;
	}
	return 5;
}

/*
	Name: fallerdropactionterminate
	Namespace: zm_ai_faller
	Checksum: 0xAA4040C8
	Offset: 0x7D0
	Size: 0x28
	Parameters: 2
	Flags: Linked
*/
function fallerdropactionterminate(entity, asmstatename)
{
	entity.faller_drop = 0;
	return 4;
}

/*
	Name: shouldfallerdrop
	Namespace: zm_ai_faller
	Checksum: 0xE233545E
	Offset: 0x800
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function shouldfallerdrop(entity)
{
	if(isdefined(entity.faller_drop) && entity.faller_drop)
	{
		return true;
	}
	return false;
}

/*
	Name: isfallerinceiling
	Namespace: zm_ai_faller
	Checksum: 0x513C4537
	Offset: 0x848
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function isfallerinceiling(entity)
{
	if(isdefined(entity.in_the_ceiling) && entity.in_the_ceiling && (!(isdefined(entity.normal_death) && entity.normal_death)))
	{
		return true;
	}
	return false;
}

/*
	Name: fallerceilingdeath
	Namespace: zm_ai_faller
	Checksum: 0x61F297D1
	Offset: 0x8B0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function fallerceilingdeath(entity)
{
}

/*
	Name: mocompfallerdrop
	Namespace: zm_ai_faller
	Checksum: 0xA7CBE30
	Offset: 0x8C8
	Size: 0x4C
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompfallerdrop(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity animmode("nogravity", 0);
}

/*
	Name: mocompceilingdeath
	Namespace: zm_ai_faller
	Checksum: 0x3DA83C5C
	Offset: 0x920
	Size: 0x4C
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompceilingdeath(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity animmode("noclip", 0);
}

/*
	Name: zombie_faller_delete
	Namespace: zm_ai_faller
	Checksum: 0x3CE509A6
	Offset: 0x978
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function zombie_faller_delete()
{
	level.zombie_total++;
	self zombie_utility::reset_attack_spot();
	if(isdefined(self.zombie_faller_location))
	{
		self.zombie_faller_location.is_enabled = 1;
		self.zombie_faller_location = undefined;
	}
	self delete();
}

/*
	Name: faller_script_parameters
	Namespace: zm_ai_faller
	Checksum: 0x67A401F2
	Offset: 0x9E8
	Size: 0x112
	Parameters: 0
	Flags: Linked
*/
function faller_script_parameters()
{
	if(isdefined(self.script_parameters))
	{
		parms = strtok(self.script_parameters, ";");
		if(isdefined(parms) && parms.size > 0)
		{
			for(i = 0; i < parms.size; i++)
			{
				if(parms[i] == "drop_now")
				{
					self.drop_now = 1;
				}
				if(parms[i] == "drop_not_occupied")
				{
					self.drop_not_occupied = 1;
				}
				if(parms[i] == "emerge_top")
				{
					self.emerge_top = 1;
				}
				if(parms[i] == "emerge_bottom")
				{
					self.emerge_bottom = 1;
				}
			}
		}
	}
}

/*
	Name: setup_deathfunc
	Namespace: zm_ai_faller
	Checksum: 0x3AD4A001
	Offset: 0xB08
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function setup_deathfunc(func_name)
{
	self endon(#"death");
	while(!(isdefined(self.zombie_init_done) && self.zombie_init_done))
	{
		util::wait_network_frame();
	}
	if(isdefined(func_name))
	{
		self.deathfunction = func_name;
	}
	else
	{
		if(isdefined(level.custom_faller_death))
		{
			self.deathfunction = level.custom_faller_death;
		}
		else
		{
			self.deathfunction = &zombie_fall_death_func;
		}
	}
}

/*
	Name: do_zombie_fall
	Namespace: zm_ai_faller
	Checksum: 0x9CA4D436
	Offset: 0xBB0
	Size: 0x4BA
	Parameters: 1
	Flags: Linked
*/
function do_zombie_fall(spot)
{
	self endon(#"death");
	if(!(isdefined(level.faller_init) && level.faller_init))
	{
		level.faller_init = 1;
		faller_anim = self animmappingsearch(istring("anim_faller_emerge"));
		level.faller_emerge_time = getanimlength(faller_anim);
		faller_anim = self animmappingsearch(istring("anim_faller_attack_01"));
		level.faller_attack_01_time = getanimlength(faller_anim);
		faller_anim = self animmappingsearch(istring("anim_faller_attack_02"));
		level.faller_attack_02_time = getanimlength(faller_anim);
		faller_anim = self animmappingsearch(istring("anim_faller_fall"));
		level.faller_fall_time = getanimlength(faller_anim);
	}
	self.zombie_faller_location = spot;
	self.zombie_faller_location.is_enabled = 0;
	self.zombie_faller_location faller_script_parameters();
	if(isdefined(self.zombie_faller_location.emerge_bottom) && self.zombie_faller_location.emerge_bottom || (isdefined(self.zombie_faller_location.emerge_top) && self.zombie_faller_location.emerge_top))
	{
		self do_zombie_emerge(spot);
		return;
	}
	self thread setup_deathfunc();
	self.no_powerups = 1;
	self.in_the_ceiling = 1;
	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);
	if(!isdefined(spot.angles))
	{
		spot.angles = (0, 0, 0);
	}
	anim_org = spot.origin;
	anim_ang = spot.angles;
	self ghost();
	self.anchor moveto(anim_org, 0.05);
	self.anchor waittill(#"movedone");
	target_org = zombie_utility::get_desired_origin();
	if(isdefined(target_org))
	{
		anim_ang = vectortoangles(target_org - self.origin);
		self.anchor rotateto((0, anim_ang[1], 0), 0.05);
		self.anchor waittill(#"rotatedone");
	}
	self unlink();
	if(isdefined(self.anchor))
	{
		self.anchor delete();
	}
	self thread zombie_utility::hide_pop();
	self thread zombie_fall_death(spot);
	self thread zombie_fall_fx(spot);
	self thread zombie_faller_death_wait();
	self thread zombie_faller_do_fall();
	self.no_powerups = 0;
	self notify(#"risen", spot.script_string);
}

/*
	Name: zombie_faller_do_fall
	Namespace: zm_ai_faller
	Checksum: 0x1FD59106
	Offset: 0x1078
	Size: 0x470
	Parameters: 0
	Flags: Linked
*/
function zombie_faller_do_fall()
{
	self endon(#"death");
	self animscripted("fall_anim", self.origin, self.zombie_faller_location.angles, "ai_zm_dlc5_zombie_ceiling_emerge_01");
	wait(level.faller_emerge_time);
	self.zombie_faller_wait_start = gettime();
	self.zombie_faller_should_drop = 0;
	self thread zombie_fall_wait();
	self thread zombie_faller_watch_all_players();
	while(!self.zombie_faller_should_drop)
	{
		if(self zombie_fall_should_attack(self.zombie_faller_location))
		{
			if(math::cointoss())
			{
				self animscripted("fall_anim", self.origin, self.zombie_faller_location.angles, "ai_zm_dlc5_zombie_ceiling_attack_01");
				wait(level.faller_attack_01_time);
			}
			else
			{
				self animscripted("fall_anim", self.origin, self.zombie_faller_location.angles, "ai_zm_dlc5_zombie_ceiling_attack_02");
				wait(level.faller_attack_02_time);
			}
			if(!self zombie_faller_always_drop() && randomfloat(1) > 0.5)
			{
				self.zombie_faller_should_drop = 1;
			}
		}
		else
		{
			if(self zombie_faller_always_drop())
			{
				self.zombie_faller_should_drop = 1;
				break;
			}
			else
			{
				if(gettime() >= (self.zombie_faller_wait_start + 20000))
				{
					self.zombie_faller_should_drop = 1;
					break;
				}
				else
				{
					if(self zombie_faller_drop_not_occupied())
					{
						self.zombie_faller_should_drop = 1;
						break;
					}
					else
					{
						if(math::cointoss())
						{
							self animscripted("fall_anim", self.origin, self.zombie_faller_location.angles, "ai_zm_dlc5_zombie_ceiling_attack_01");
							wait(level.faller_attack_01_time);
						}
						else
						{
							self animscripted("fall_anim", self.origin, self.zombie_faller_location.angles, "ai_zm_dlc5_zombie_ceiling_attack_02");
							wait(level.faller_attack_02_time);
						}
					}
				}
			}
		}
	}
	self notify(#"falling");
	spot = self.zombie_faller_location;
	self zombie_faller_enable_location();
	self animscripted("fall_anim", self.origin, spot.angles, "ai_zm_dlc5_zombie_ceiling_dropdown_01");
	wait(level.faller_fall_time);
	self.deathfunction = &zm_spawner::zombie_death_animscript;
	self.normal_death = 1;
	self notify(#"fall_anim_finished");
	spot notify(#"stop_zombie_fall_fx");
	self stopanimscripted();
	landanimdelta = 15;
	ground_pos = zm_utility::groundpos_ignore_water_new(self.origin);
	physdist = (self.origin[2] - ground_pos[2]) + landanimdelta;
	if(physdist > 0)
	{
		self.faller_drop = 1;
		self waittill(#"zombie_land_done");
	}
	self.in_the_ceiling = 0;
	self traversemode("gravity");
	self.no_powerups = 0;
}

/*
	Name: zombie_fall_loop
	Namespace: zm_ai_faller
	Checksum: 0xC94DD61A
	Offset: 0x14F0
	Size: 0x98
	Parameters: 0
	Flags: None
*/
function zombie_fall_loop()
{
	self endon(#"death");
	self setanimstatefromasd("zm_faller_fall_loop");
	while(true)
	{
		ground_pos = zm_utility::groundpos_ignore_water_new(self.origin);
		if((self.origin[2] - ground_pos[2]) < 20)
		{
			self notify(#"faller_on_ground");
			break;
		}
		wait(0.05);
	}
}

/*
	Name: zombie_land
	Namespace: zm_ai_faller
	Checksum: 0x75137165
	Offset: 0x1590
	Size: 0x4A
	Parameters: 0
	Flags: None
*/
function zombie_land()
{
	self setanimstatefromasd("zm_faller_land");
	zombie_shared::donotetracks("land_anim");
	self notify(#"zombie_land_done");
}

/*
	Name: zombie_faller_always_drop
	Namespace: zm_ai_faller
	Checksum: 0xB5405E42
	Offset: 0x15E8
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function zombie_faller_always_drop()
{
	if(isdefined(self.zombie_faller_location.drop_now) && self.zombie_faller_location.drop_now)
	{
		return true;
	}
	return false;
}

/*
	Name: zombie_faller_drop_not_occupied
	Namespace: zm_ai_faller
	Checksum: 0x4CBF7802
	Offset: 0x1628
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function zombie_faller_drop_not_occupied()
{
	if(isdefined(self.zombie_faller_location.drop_not_occupied) && self.zombie_faller_location.drop_not_occupied)
	{
		if(isdefined(self.zone_name) && isdefined(level.zones[self.zone_name]))
		{
			return !level.zones[self.zone_name].is_occupied;
		}
	}
	return 0;
}

/*
	Name: zombie_faller_watch_all_players
	Namespace: zm_ai_faller
	Checksum: 0x7AD7E060
	Offset: 0x16A0
	Size: 0x66
	Parameters: 0
	Flags: Linked
*/
function zombie_faller_watch_all_players()
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		self thread zombie_faller_watch_player(players[i]);
	}
}

/*
	Name: zombie_faller_watch_player
	Namespace: zm_ai_faller
	Checksum: 0xD09BE2A
	Offset: 0x1710
	Size: 0x298
	Parameters: 1
	Flags: Linked
*/
function zombie_faller_watch_player(player)
{
	self endon(#"falling");
	self endon(#"death");
	player endon(#"disconnect");
	range = 200;
	rangesqr = range * range;
	timer = 5000;
	inrange = 0;
	inrangetime = 0;
	closerange = 60;
	closerangesqr = closerange * closerange;
	dirtoplayerenter = (0, 0, 0);
	incloserange = 0;
	while(true)
	{
		distsqr = distance2dsquared(self.origin, player.origin);
		if(distsqr < rangesqr)
		{
			if(inrange)
			{
				if((inrangetime + timer) < gettime())
				{
					self.zombie_faller_should_drop = 1;
					break;
				}
			}
			else
			{
				inrange = 1;
				inrangetime = gettime();
			}
		}
		else
		{
			inrange = 0;
		}
		if(distsqr < closerangesqr)
		{
			if(!incloserange)
			{
				dirtoplayerenter = player.origin - self.origin;
				dirtoplayerenter = (dirtoplayerenter[0], dirtoplayerenter[1], 0);
				dirtoplayerenter = vectornormalize(dirtoplayerenter);
			}
			incloserange = 1;
		}
		else
		{
			if(incloserange)
			{
				dirtoplayerexit = player.origin - self.origin;
				dirtoplayerexit = (dirtoplayerexit[0], dirtoplayerexit[1], 0);
				dirtoplayerexit = vectornormalize(dirtoplayerexit);
				if(vectordot(dirtoplayerenter, dirtoplayerexit) < 0)
				{
					self.zombie_faller_should_drop = 1;
					break;
				}
			}
			incloserange = 0;
		}
		wait(0.1);
	}
}

/*
	Name: zombie_fall_wait
	Namespace: zm_ai_faller
	Checksum: 0x1920C2C8
	Offset: 0x19B0
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function zombie_fall_wait()
{
	self endon(#"falling");
	self endon(#"death");
	if(isdefined(self.zone_name))
	{
		if(isdefined(level.zones) && isdefined(level.zones[self.zone_name]))
		{
			zone = level.zones[self.zone_name];
			while(true)
			{
				if(!zone.is_enabled || !zone.is_active)
				{
					if(!self potentially_visible(2250000))
					{
						if(self.health != level.zombie_health)
						{
							self.zombie_faller_should_drop = 1;
							break;
						}
						else
						{
							self zombie_faller_delete();
							return;
						}
					}
				}
				wait(0.5);
			}
		}
	}
}

/*
	Name: zombie_fall_should_attack
	Namespace: zm_ai_faller
	Checksum: 0xDE7B74D6
	Offset: 0x1AC0
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function zombie_fall_should_attack(spot)
{
	victims = zombie_fall_get_vicitims(spot);
	return victims.size > 0;
}

/*
	Name: zombie_fall_get_vicitims
	Namespace: zm_ai_faller
	Checksum: 0xE7BC0DAC
	Offset: 0x1B08
	Size: 0x1AE
	Parameters: 1
	Flags: Linked
*/
function zombie_fall_get_vicitims(spot)
{
	ret = [];
	players = getplayers();
	checkdist2 = 40;
	checkdist2 = checkdist2 * checkdist2;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player laststand::player_is_in_laststand())
		{
			continue;
		}
		stance = player getstance();
		if(stance == "crouch" || stance == "prone")
		{
			continue;
		}
		zcheck = self.origin[2] - player.origin[2];
		if(zcheck < 0 || zcheck > 120)
		{
			continue;
		}
		dist2 = distance2dsquared(player.origin, self.origin);
		if(dist2 < checkdist2)
		{
			ret[ret.size] = player;
		}
	}
	return ret;
}

/*
	Name: get_fall_anim
	Namespace: zm_ai_faller
	Checksum: 0x73A5A7EA
	Offset: 0x1CC0
	Size: 0x26
	Parameters: 1
	Flags: None
*/
function get_fall_anim(spot)
{
	return level._zombie_fall_anims[self.animname]["fall"];
}

/*
	Name: zombie_faller_enable_location
	Namespace: zm_ai_faller
	Checksum: 0xB23E972
	Offset: 0x1CF0
	Size: 0x2E
	Parameters: 0
	Flags: Linked
*/
function zombie_faller_enable_location()
{
	if(isdefined(self.zombie_faller_location))
	{
		self.zombie_faller_location.is_enabled = 1;
		self.zombie_faller_location = undefined;
	}
}

/*
	Name: zombie_faller_death_wait
	Namespace: zm_ai_faller
	Checksum: 0x3274533
	Offset: 0x1D28
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function zombie_faller_death_wait(endon_notify)
{
	self endon(#"falling");
	if(isdefined(endon_notify))
	{
		self endon(endon_notify);
	}
	self waittill(#"death");
	self zombie_faller_enable_location();
}

/*
	Name: zombie_fall_death_func
	Namespace: zm_ai_faller
	Checksum: 0x8C496C28
	Offset: 0x1D80
	Size: 0x8A
	Parameters: 8
	Flags: Linked
*/
function zombie_fall_death_func(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	self animmode("noclip");
	self.deathanim = "zm_faller_emerge_death";
	return self zm_spawner::zombie_death_animscript();
}

/*
	Name: zombie_fall_death
	Namespace: zm_ai_faller
	Checksum: 0xE99C5569
	Offset: 0x1E18
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function zombie_fall_death(spot)
{
	self endon(#"fall_anim_finished");
	while(self.health > 1)
	{
		self waittill(#"damage", amount, attacker, dir, p, type);
	}
	self stopanimscripted();
	spot notify(#"stop_zombie_fall_fx");
}

/*
	Name: _damage_mod_to_damage_type
	Namespace: zm_ai_faller
	Checksum: 0x2E4DF493
	Offset: 0x1EC0
	Size: 0xC4
	Parameters: 1
	Flags: None
*/
function _damage_mod_to_damage_type(type)
{
	toks = strtok(type, "_");
	if(toks.size < 2)
	{
		return type;
	}
	returnstr = toks[1];
	for(i = 2; i < toks.size; i++)
	{
		returnstr = returnstr + toks[i];
	}
	returnstr = tolower(returnstr);
	return returnstr;
}

/*
	Name: zombie_fall_fx
	Namespace: zm_ai_faller
	Checksum: 0x261FDF1A
	Offset: 0x1F90
	Size: 0x9E
	Parameters: 1
	Flags: Linked
*/
function zombie_fall_fx(spot)
{
	spot thread zombie_fall_dust_fx(self);
	spot thread zombie_fall_burst_fx();
	playsoundatposition("zmb_zombie_spawn", spot.origin);
	self endon(#"death");
	spot endon(#"stop_zombie_fall_fx");
	wait(1);
	if(self.zombie_move_speed != "sprint")
	{
		wait(1);
	}
}

/*
	Name: zombie_fall_burst_fx
	Namespace: zm_ai_faller
	Checksum: 0xDA8A2CE2
	Offset: 0x2038
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function zombie_fall_burst_fx()
{
	self endon(#"stop_zombie_fall_fx");
	self endon(#"fall_anim_finished");
	playfx(level._effect["rise_burst"], self.origin + (0, 0, randomintrange(5, 10)));
	wait(0.25);
	playfx(level._effect["rise_billow"], self.origin + (randomintrange(-10, 10), randomintrange(-10, 10), randomintrange(5, 10)));
}

/*
	Name: zombie_fall_dust_fx
	Namespace: zm_ai_faller
	Checksum: 0x369DB453
	Offset: 0x2130
	Size: 0xCE
	Parameters: 1
	Flags: Linked
*/
function zombie_fall_dust_fx(zombie)
{
	dust_tag = "J_SpineUpper";
	self endon(#"stop_zombie_fall_dust_fx");
	self thread stop_zombie_fall_dust_fx(zombie);
	dust_time = 4.5;
	dust_interval = 0.3;
	t = 0;
	while(t < dust_time)
	{
		playfxontag(level._effect["rise_dust"], zombie, dust_tag);
		wait(dust_interval);
		t = t + dust_interval;
	}
}

/*
	Name: stop_zombie_fall_dust_fx
	Namespace: zm_ai_faller
	Checksum: 0x3E2CBD5E
	Offset: 0x2208
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function stop_zombie_fall_dust_fx(zombie)
{
	zombie waittill(#"death");
	self notify(#"stop_zombie_fall_dust_fx");
}

/*
	Name: handle_fall_death_notetracks
	Namespace: zm_ai_faller
	Checksum: 0x42ACDB67
	Offset: 0x2238
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function handle_fall_death_notetracks(entity)
{
	self.in_the_ceiling = 0;
}

/*
	Name: handle_fall_notetracks
	Namespace: zm_ai_faller
	Checksum: 0x68D7655F
	Offset: 0x2258
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function handle_fall_notetracks(entity)
{
	victims = zombie_fall_get_vicitims(entity.zombie_faller_location);
	for(i = 0; i < victims.size; i++)
	{
		victims[i] dodamage(entity.meleedamage, entity.origin, self, self, "none", "MOD_MELEE");
		entity.zombie_faller_should_drop = 1;
	}
}

/*
	Name: faller_death_ragdoll
	Namespace: zm_ai_faller
	Checksum: 0xF3E64135
	Offset: 0x2328
	Size: 0x8A
	Parameters: 8
	Flags: Linked
*/
function faller_death_ragdoll(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	self startragdoll();
	self launchragdoll((0, 0, -1));
	return self zm_spawner::zombie_death_animscript();
}

/*
	Name: in_player_fov
	Namespace: zm_ai_faller
	Checksum: 0x3F7FCF10
	Offset: 0x23C0
	Size: 0x1C0
	Parameters: 1
	Flags: Linked
*/
function in_player_fov(player)
{
	playerangles = player getplayerangles();
	playerforwardvec = anglestoforward(playerangles);
	playerunitforwardvec = vectornormalize(playerforwardvec);
	banzaipos = self.origin;
	playerpos = player getorigin();
	playertobanzaivec = banzaipos - playerpos;
	playertobanzaiunitvec = vectornormalize(playertobanzaivec);
	forwarddotbanzai = vectordot(playerunitforwardvec, playertobanzaiunitvec);
	anglefromcenter = acos(forwarddotbanzai);
	playerfov = getdvarfloat("cg_fov");
	banzaivsplayerfovbuffer = getdvarfloat("g_banzai_player_fov_buffer");
	if(banzaivsplayerfovbuffer <= 0)
	{
		banzaivsplayerfovbuffer = 0.2;
	}
	inplayerfov = anglefromcenter <= (playerfov * 0.5) * (1 - banzaivsplayerfovbuffer);
	return inplayerfov;
}

/*
	Name: potentially_visible
	Namespace: zm_ai_faller
	Checksum: 0x57E9A328
	Offset: 0x2588
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function potentially_visible(how_close = 1000000)
{
	potentiallyvisible = 0;
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		dist = distancesquared(self.origin, players[i].origin);
		if(dist < how_close)
		{
			inplayerfov = self in_player_fov(players[i]);
			if(inplayerfov)
			{
				potentiallyvisible = 1;
				break;
			}
		}
	}
	return potentiallyvisible;
}

/*
	Name: do_zombie_emerge
	Namespace: zm_ai_faller
	Checksum: 0xB9414A6
	Offset: 0x2698
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function do_zombie_emerge(spot)
{
	self endon(#"death");
	self thread setup_deathfunc(&faller_death_ragdoll);
	self.no_powerups = 1;
	self.in_the_ceiling = 1;
	anim_org = spot.origin;
	anim_ang = spot.angles;
	self thread zombie_emerge_fx(spot);
	self thread zombie_faller_death_wait("risen");
	if(isdefined(level.custom_faller_entrance_logic))
	{
		self thread [[level.custom_faller_entrance_logic]]();
	}
	self zombie_faller_emerge(spot);
	self.create_eyes = 1;
	wait(0.1);
	self notify(#"risen", spot.script_string);
	self zombie_faller_enable_location();
}

/*
	Name: zombie_faller_emerge
	Namespace: zm_ai_faller
	Checksum: 0xE181AE95
	Offset: 0x27D8
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function zombie_faller_emerge(spot)
{
	self endon(#"death");
	if(isdefined(self.zombie_faller_location.emerge_bottom) && self.zombie_faller_location.emerge_bottom)
	{
		self animscripted("fall_anim", self.zombie_faller_location.origin, self.zombie_faller_location.angles, "zombie_riser_elevator_from_floor");
	}
	else
	{
		self animscripted("fall_anim", self.zombie_faller_location.origin, self.zombie_faller_location.angles, "zombie_riser_elevator_from_ceiling");
	}
	self zombie_shared::donotetracks("rise_anim");
	self.deathfunction = &zm_spawner::zombie_death_animscript;
	self.in_the_ceiling = 0;
	self.no_powerups = 0;
}

/*
	Name: zombie_emerge_fx
	Namespace: zm_ai_faller
	Checksum: 0x56F15670
	Offset: 0x2900
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function zombie_emerge_fx(spot)
{
	spot thread zombie_emerge_dust_fx(self);
	playsoundatposition("zmb_zombie_spawn", spot.origin);
	self endon(#"death");
	spot endon(#"stop_zombie_fall_fx");
	wait(1);
}

/*
	Name: zombie_emerge_dust_fx
	Namespace: zm_ai_faller
	Checksum: 0x66E0BADE
	Offset: 0x2978
	Size: 0xCE
	Parameters: 1
	Flags: Linked
*/
function zombie_emerge_dust_fx(zombie)
{
	dust_tag = "J_SpineUpper";
	self endon(#"stop_zombie_fall_dust_fx");
	self thread stop_zombie_fall_dust_fx(zombie);
	dust_time = 3.5;
	dust_interval = 0.5;
	t = 0;
	while(t < dust_time)
	{
		playfxontag(level._effect["rise_dust"], zombie, dust_tag);
		wait(dust_interval);
		t = t + dust_interval;
	}
}

/*
	Name: stop_zombie_emerge_dust_fx
	Namespace: zm_ai_faller
	Checksum: 0xE0DCD8A0
	Offset: 0x2A50
	Size: 0x26
	Parameters: 1
	Flags: None
*/
function stop_zombie_emerge_dust_fx(zombie)
{
	zombie waittill(#"death");
	self notify(#"stop_zombie_fall_dust_fx");
}

