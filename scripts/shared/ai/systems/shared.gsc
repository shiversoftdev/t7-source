// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\init;
#using scripts\shared\ai\systems\weaponlist;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\throttle_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace shared;

/*
	Name: main
	Namespace: shared
	Checksum: 0x32100736
	Offset: 0x250
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	level.ai_weapon_throttle = new throttle();
	[[ level.ai_weapon_throttle ]]->initialize(1, 0.1);
}

/*
	Name: _throwstowedweapon
	Namespace: shared
	Checksum: 0x3EC5EBC2
	Offset: 0x298
	Size: 0x9C
	Parameters: 3
	Flags: Linked, Private
*/
function private _throwstowedweapon(entity, weapon, weaponmodel)
{
	entity waittill(#"death");
	if(isdefined(entity))
	{
		weaponmodel unlink();
		entity throwweapon(weapon, gettagforpos("back"), 0);
	}
	weaponmodel delete();
}

/*
	Name: stowweapon
	Namespace: shared
	Checksum: 0x3D6A37F0
	Offset: 0x340
	Size: 0xEC
	Parameters: 3
	Flags: None
*/
function stowweapon(weapon, positionoffset, orientationoffset)
{
	entity = self;
	if(!isdefined(positionoffset))
	{
		positionoffset = (0, 0, 0);
	}
	if(!isdefined(orientationoffset))
	{
		orientationoffset = (0, 0, 0);
	}
	weaponmodel = spawn("script_model", (0, 0, 0));
	weaponmodel setmodel(weapon.worldmodel);
	weaponmodel linkto(entity, "tag_stowed_back", positionoffset, orientationoffset);
	entity thread _throwstowedweapon(entity, weapon, weaponmodel);
}

/*
	Name: placeweaponon
	Namespace: shared
	Checksum: 0xFFFEDC67
	Offset: 0x438
	Size: 0x3DC
	Parameters: 2
	Flags: Linked
*/
function placeweaponon(weapon, position)
{
	self notify(#"weapon_position_change");
	if(isstring(weapon))
	{
		weapon = getweapon(weapon);
	}
	if(!isdefined(self.weaponinfo[weapon.name]))
	{
		self init::initweapon(weapon);
	}
	curposition = self.weaponinfo[weapon.name].position;
	/#
		assert(curposition == "" || self.a.weaponpos[curposition] == weapon);
	#/
	if(!isarray(self.a.weaponpos))
	{
		self.a.weaponpos = [];
	}
	/#
		assert(isarray(self.a.weaponpos));
	#/
	/#
		assert(position == "" || isdefined(self.a.weaponpos[position]), ("" + position) + "");
	#/
	/#
		assert(isweapon(weapon));
	#/
	if(position != "none" && self.a.weaponpos[position] == weapon)
	{
		return;
	}
	self detachallweaponmodels();
	if(curposition != "none")
	{
		self detachweapon(weapon);
	}
	if(position == "none")
	{
		self updateattachedweaponmodels();
		self aiutility::setcurrentweapon(level.weaponnone);
		return;
	}
	if(self.a.weaponpos[position] != level.weaponnone)
	{
		self detachweapon(self.a.weaponpos[position]);
	}
	if(position == "left" || position == "right")
	{
		self updatescriptweaponinfoandpos(weapon, position);
		self aiutility::setcurrentweapon(weapon);
	}
	else
	{
		self updatescriptweaponinfoandpos(weapon, position);
	}
	self updateattachedweaponmodels();
	/#
		assert(self.a.weaponpos[""] == level.weaponnone || self.a.weaponpos[""] == level.weaponnone);
	#/
}

/*
	Name: detachweapon
	Namespace: shared
	Checksum: 0x76FF76F0
	Offset: 0x820
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function detachweapon(weapon)
{
	self.a.weaponpos[self.weaponinfo[weapon.name].position] = level.weaponnone;
	self.weaponinfo[weapon.name].position = "none";
}

/*
	Name: updatescriptweaponinfoandpos
	Namespace: shared
	Checksum: 0xE6379C3C
	Offset: 0x898
	Size: 0x56
	Parameters: 2
	Flags: Linked
*/
function updatescriptweaponinfoandpos(weapon, position)
{
	self.weaponinfo[weapon.name].position = position;
	self.a.weaponpos[position] = weapon;
}

/*
	Name: detachallweaponmodels
	Namespace: shared
	Checksum: 0x53BCE2C7
	Offset: 0x8F8
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function detachallweaponmodels()
{
	if(isdefined(self.weapon_positions))
	{
		for(index = 0; index < self.weapon_positions.size; index++)
		{
			weapon = self.a.weaponpos[self.weapon_positions[index]];
			if(weapon == level.weaponnone)
			{
				continue;
			}
			self setactorweapon(level.weaponnone, self getactorweaponoptions());
		}
	}
}

/*
	Name: updateattachedweaponmodels
	Namespace: shared
	Checksum: 0x9AE828FC
	Offset: 0x9B0
	Size: 0x12E
	Parameters: 0
	Flags: Linked
*/
function updateattachedweaponmodels()
{
	if(isdefined(self.weapon_positions))
	{
		for(index = 0; index < self.weapon_positions.size; index++)
		{
			weapon = self.a.weaponpos[self.weapon_positions[index]];
			if(weapon == level.weaponnone)
			{
				continue;
			}
			if(self.weapon_positions[index] != "right")
			{
				continue;
			}
			self setactorweapon(weapon, self getactorweaponoptions());
			if(self.weaponinfo[weapon.name].useclip && !self.weaponinfo[weapon.name].hasclip)
			{
				self hidepart("tag_clip");
			}
		}
	}
}

/*
	Name: gettagforpos
	Namespace: shared
	Checksum: 0xD588D183
	Offset: 0xAE8
	Size: 0x9E
	Parameters: 1
	Flags: Linked
*/
function gettagforpos(position)
{
	switch(position)
	{
		case "chest":
		{
			return "tag_weapon_chest";
		}
		case "back":
		{
			return "tag_stowed_back";
		}
		case "left":
		{
			return "tag_weapon_left";
		}
		case "right":
		{
			return "tag_weapon_right";
		}
		case "hand":
		{
			return "tag_inhand";
		}
		default:
		{
			/#
				assertmsg("" + position);
			#/
			break;
		}
	}
}

/*
	Name: throwweapon
	Namespace: shared
	Checksum: 0x1FFBCE23
	Offset: 0xB90
	Size: 0x1EA
	Parameters: 3
	Flags: Linked
*/
function throwweapon(weapon, positiontag, scavenger)
{
	waittime = 0.1;
	linearscalar = 2;
	angularscalar = 10;
	startposition = self gettagorigin(positiontag);
	startangles = self gettagangles(positiontag);
	wait(waittime);
	if(isdefined(self))
	{
		endposition = self gettagorigin(positiontag);
		endangles = self gettagangles(positiontag);
		linearvelocity = (endposition - startposition) * (1 / waittime) * linearscalar;
		angularvelocity = (vectornormalize(endangles - startangles)) * angularscalar;
		throwweapon = self dropweapon(weapon, positiontag, linearvelocity, angularvelocity, scavenger);
		if(isdefined(throwweapon))
		{
			throwweapon setcontents(throwweapon setcontents(0) & (~(((32768 | 67108864) | 8388608) | 33554432)));
		}
		return throwweapon;
	}
}

/*
	Name: dropaiweapon
	Namespace: shared
	Checksum: 0x260B0B57
	Offset: 0xD88
	Size: 0x2D4
	Parameters: 0
	Flags: Linked
*/
function dropaiweapon()
{
	self endon(#"death");
	if(self.weapon == level.weaponnone)
	{
		return;
	}
	if(isdefined(self.script_nodropsecondaryweapon) && self.script_nodropsecondaryweapon && self.weapon == self.initial_secondaryweapon)
	{
		/#
			println(("" + self.weapon.name) + "");
		#/
		return;
	}
	if(isdefined(self.script_nodropsidearm) && self.script_nodropsidearm && self.weapon == self.sidearm)
	{
		/#
			println(("" + self.weapon.name) + "");
		#/
		return;
	}
	[[ level.ai_weapon_throttle ]]->waitinqueue(self);
	current_weapon = self.weapon;
	dropweaponname = player_weapon_drop(current_weapon);
	position = self.weaponinfo[current_weapon.name].position;
	shoulddropweapon = !isdefined(self.dontdropweapon) || self.dontdropweapon === 0;
	if(current_weapon.isscavengable == 0)
	{
		shoulddropweapon = 0;
	}
	if(shoulddropweapon && self.dropweapon)
	{
		self.dontdropweapon = 1;
		positiontag = gettagforpos(position);
		throwweapon(dropweaponname, positiontag, 0);
	}
	if(self.weapon != level.weaponnone)
	{
		placeweaponon(current_weapon, "none");
		if(self.weapon == self.primaryweapon)
		{
			self aiutility::setprimaryweapon(level.weaponnone);
		}
		else if(self.weapon == self.secondaryweapon)
		{
			self aiutility::setsecondaryweapon(level.weaponnone);
		}
	}
	self aiutility::setcurrentweapon(level.weaponnone);
}

/*
	Name: dropallaiweapons
	Namespace: shared
	Checksum: 0xC2C979BB
	Offset: 0x1068
	Size: 0x3F2
	Parameters: 0
	Flags: None
*/
function dropallaiweapons()
{
	if(isdefined(self.a.dropping_weapons) && self.a.dropping_weapons)
	{
		return;
	}
	if(!self.dropweapon)
	{
		if(self.weapon != level.weaponnone)
		{
			placeweaponon(self.weapon, "none");
			self aiutility::setcurrentweapon(level.weaponnone);
		}
		return;
	}
	self.a.dropping_weapons = 1;
	self detachallweaponmodels();
	droppedsidearm = 0;
	if(isdefined(self.weapon_positions))
	{
		for(index = 0; index < self.weapon_positions.size; index++)
		{
			weapon = self.a.weaponpos[self.weapon_positions[index]];
			if(weapon != level.weaponnone)
			{
				self.weaponinfo[weapon.name].position = "none";
				self.a.weaponpos[self.weapon_positions[index]] = level.weaponnone;
				if(isdefined(self.script_nodropsecondaryweapon) && self.script_nodropsecondaryweapon && weapon == self.initial_secondaryweapon)
				{
					/#
						println(("" + weapon.name) + "");
					#/
					continue;
				}
				if(isdefined(self.script_nodropsidearm) && self.script_nodropsidearm && weapon == self.sidearm)
				{
					/#
						println(("" + weapon.name) + "");
					#/
					continue;
				}
				velocity = self getvelocity();
				speed = length(velocity) * 0.5;
				weapon = player_weapon_drop(weapon);
				droppedweapon = self dropweapon(weapon, self.weapon_positions[index], speed);
				if(self.sidearm != level.weaponnone)
				{
					if(weapon == self.sidearm)
					{
						droppedsidearm = 1;
					}
				}
			}
		}
	}
	if(!droppedsidearm && self.sidearm != level.weaponnone)
	{
		if(randomint(100) <= 10)
		{
			velocity = self getvelocity();
			speed = length(velocity) * 0.5;
			droppedweapon = self dropweapon(self.sidearm, "chest", speed);
		}
	}
	self aiutility::setcurrentweapon(level.weaponnone);
	self.a.dropping_weapons = undefined;
}

/*
	Name: player_weapon_drop
	Namespace: shared
	Checksum: 0xBB911A10
	Offset: 0x1468
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function player_weapon_drop(weapon)
{
	if(issubstr(weapon.name, "rpg"))
	{
		return getweapon("rpg_player");
	}
	return weapon;
}

/*
	Name: handlenotetrack
	Namespace: shared
	Checksum: 0x1B5977B3
	Offset: 0x14C0
	Size: 0x24
	Parameters: 4
	Flags: Linked
*/
function handlenotetrack(note, flagname, customfunction, var1)
{
}

/*
	Name: donotetracks
	Namespace: shared
	Checksum: 0x16E30061
	Offset: 0x14F0
	Size: 0x94
	Parameters: 4
	Flags: Linked
*/
function donotetracks(flagname, customfunction, debugidentifier, var1)
{
	for(;;)
	{
		self waittill(flagname, note);
		if(!isdefined(note))
		{
			note = "undefined";
		}
		val = self handlenotetrack(note, flagname, customfunction, var1);
		if(isdefined(val))
		{
			return val;
		}
	}
}

/*
	Name: donotetracksintercept
	Namespace: shared
	Checksum: 0x3BBDAD8
	Offset: 0x1590
	Size: 0xD4
	Parameters: 3
	Flags: Linked
*/
function donotetracksintercept(flagname, interceptfunction, debugidentifier)
{
	/#
		assert(isdefined(interceptfunction));
	#/
	for(;;)
	{
		self waittill(flagname, note);
		if(!isdefined(note))
		{
			note = "undefined";
		}
		intercepted = [[interceptfunction]](note);
		if(isdefined(intercepted) && intercepted)
		{
			continue;
		}
		val = self handlenotetrack(note, flagname);
		if(isdefined(val))
		{
			return val;
		}
	}
}

/*
	Name: donotetrackspostcallback
	Namespace: shared
	Checksum: 0x369EE95D
	Offset: 0x1670
	Size: 0xAC
	Parameters: 2
	Flags: None
*/
function donotetrackspostcallback(flagname, postfunction)
{
	/#
		assert(isdefined(postfunction));
	#/
	for(;;)
	{
		self waittill(flagname, note);
		if(!isdefined(note))
		{
			note = "undefined";
		}
		val = self handlenotetrack(note, flagname);
		[[postfunction]](note);
		if(isdefined(val))
		{
			return val;
		}
	}
}

/*
	Name: donotetracksforever
	Namespace: shared
	Checksum: 0x6426AE61
	Offset: 0x1728
	Size: 0x54
	Parameters: 4
	Flags: Linked
*/
function donotetracksforever(flagname, killstring, customfunction, debugidentifier)
{
	donotetracksforeverproc(&donotetracks, flagname, killstring, customfunction, debugidentifier);
}

/*
	Name: donotetracksforeverintercept
	Namespace: shared
	Checksum: 0x753AF5B4
	Offset: 0x1788
	Size: 0x54
	Parameters: 4
	Flags: Linked
*/
function donotetracksforeverintercept(flagname, killstring, interceptfunction, debugidentifier)
{
	donotetracksforeverproc(&donotetracksintercept, flagname, killstring, interceptfunction, debugidentifier);
}

/*
	Name: donotetracksforeverproc
	Namespace: shared
	Checksum: 0x646E8812
	Offset: 0x17E8
	Size: 0x166
	Parameters: 5
	Flags: Linked
*/
function donotetracksforeverproc(notetracksfunc, flagname, killstring, customfunction, debugidentifier)
{
	if(isdefined(killstring))
	{
		self endon(killstring);
	}
	self endon(#"killanimscript");
	if(!isdefined(debugidentifier))
	{
		debugidentifier = "undefined";
	}
	for(;;)
	{
		time = gettime();
		returnednote = [[notetracksfunc]](flagname, customfunction, debugidentifier);
		timetaken = gettime() - time;
		if(timetaken < 0.05)
		{
			time = gettime();
			returnednote = [[notetracksfunc]](flagname, customfunction, debugidentifier);
			timetaken = gettime() - time;
			if(timetaken < 0.05)
			{
				/#
					println(((((((gettime() + "") + debugidentifier) + "") + flagname) + "") + returnednote) + "");
				#/
				wait(0.05 - timetaken);
			}
		}
	}
}

/*
	Name: donotetracksfortime
	Namespace: shared
	Checksum: 0x55E3B573
	Offset: 0x1958
	Size: 0x94
	Parameters: 4
	Flags: None
*/
function donotetracksfortime(time, flagname, customfunction, debugidentifier)
{
	ent = spawnstruct();
	ent thread donotetracksfortimeendnotify(time);
	donotetracksfortimeproc(&donotetracksforever, time, flagname, customfunction, debugidentifier, ent);
}

/*
	Name: donotetracksfortimeintercept
	Namespace: shared
	Checksum: 0x10EF8EFF
	Offset: 0x19F8
	Size: 0x94
	Parameters: 4
	Flags: None
*/
function donotetracksfortimeintercept(time, flagname, interceptfunction, debugidentifier)
{
	ent = spawnstruct();
	ent thread donotetracksfortimeendnotify(time);
	donotetracksfortimeproc(&donotetracksforeverintercept, time, flagname, interceptfunction, debugidentifier, ent);
}

/*
	Name: donotetracksfortimeproc
	Namespace: shared
	Checksum: 0xD5A663E0
	Offset: 0x1A98
	Size: 0x5A
	Parameters: 6
	Flags: Linked
*/
function donotetracksfortimeproc(donotetracksforeverfunc, time, flagname, customfunction, debugidentifier, ent)
{
	ent endon(#"stop_notetracks");
	[[donotetracksforeverfunc]](flagname, undefined, customfunction, debugidentifier);
}

/*
	Name: donotetracksfortimeendnotify
	Namespace: shared
	Checksum: 0xC7221F27
	Offset: 0x1B00
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function donotetracksfortimeendnotify(time)
{
	wait(time);
	self notify(#"stop_notetracks");
}

