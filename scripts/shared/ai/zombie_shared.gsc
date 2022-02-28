// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;

#namespace zombie_shared;

/*
	Name: deleteatlimit
	Namespace: zombie_shared
	Checksum: 0xF1BB0EFD
	Offset: 0x520
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function deleteatlimit()
{
	wait(30);
	self delete();
}

/*
	Name: lookatentity
	Namespace: zombie_shared
	Checksum: 0x8249CEAA
	Offset: 0x550
	Size: 0x2C
	Parameters: 5
	Flags: None
*/
function lookatentity(looktargetentity, lookduration, lookspeed, eyesonly, interruptothers)
{
}

/*
	Name: lookatposition
	Namespace: zombie_shared
	Checksum: 0x78B2033D
	Offset: 0x588
	Size: 0x1B2
	Parameters: 5
	Flags: None
*/
function lookatposition(looktargetpos, lookduration, lookspeed, eyesonly, interruptothers)
{
	/#
		assert(isai(self), "");
	#/
	/#
		assert(self.a.targetlookinitilized == 1, "");
	#/
	/#
		assert(lookspeed == "" || lookspeed == "", "");
	#/
	if(!isdefined(interruptothers) || interruptothers == "interrupt others" || gettime() > self.a.lookendtime)
	{
		self.a.looktargetpos = looktargetpos;
		self.a.lookendtime = gettime() + (lookduration * 1000);
		if(lookspeed == "casual")
		{
			self.a.looktargetspeed = 800;
		}
		else
		{
			self.a.looktargetspeed = 1600;
		}
		if(isdefined(eyesonly) && eyesonly == "eyes only")
		{
			self notify(#"hash_c1896d90");
		}
		else
		{
			self notify(#"hash_9a1a418c");
		}
	}
}

/*
	Name: lookatanimations
	Namespace: zombie_shared
	Checksum: 0xE5DFDF2C
	Offset: 0x748
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function lookatanimations(leftanim, rightanim)
{
	self.a.lookanimationleft = leftanim;
	self.a.lookanimationright = rightanim;
}

/*
	Name: handledogsoundnotetracks
	Namespace: zombie_shared
	Checksum: 0xCEF2EB
	Offset: 0x790
	Size: 0x138
	Parameters: 1
	Flags: None
*/
function handledogsoundnotetracks(note)
{
	if(note == "sound_dogstep_run_default" || note == "dogstep_rf" || note == "dogstep_lf")
	{
		self playsound("fly_dog_step_run_default");
		return true;
	}
	prefix = getsubstr(note, 0, 5);
	if(prefix != "sound")
	{
		return false;
	}
	alias = "aml" + getsubstr(note, 5);
	if(isalive(self))
	{
		self thread sound::play_on_tag(alias, "tag_eye");
	}
	else
	{
		self thread sound::play_in_space(alias, self gettagorigin("tag_eye"));
	}
	return true;
}

/*
	Name: growling
	Namespace: zombie_shared
	Checksum: 0xEFFF4CEB
	Offset: 0x8D0
	Size: 0xC
	Parameters: 0
	Flags: None
*/
function growling()
{
	return isdefined(self.script_growl);
}

/*
	Name: registernotetracks
	Namespace: zombie_shared
	Checksum: 0xF1673CD7
	Offset: 0x8E8
	Size: 0x2A6
	Parameters: 0
	Flags: None
*/
function registernotetracks()
{
	anim.notetracks["anim_pose = \"stand\""] = &notetrackposestand;
	anim.notetracks["anim_pose = \"crouch\""] = &notetrackposecrouch;
	anim.notetracks["anim_movement = \"stop\""] = &notetrackmovementstop;
	anim.notetracks["anim_movement = \"walk\""] = &notetrackmovementwalk;
	anim.notetracks["anim_movement = \"run\""] = &notetrackmovementrun;
	anim.notetracks["anim_alertness = causal"] = &notetrackalertnesscasual;
	anim.notetracks["anim_alertness = alert"] = &notetrackalertnessalert;
	anim.notetracks["gravity on"] = &notetrackgravity;
	anim.notetracks["gravity off"] = &notetrackgravity;
	anim.notetracks["gravity code"] = &notetrackgravity;
	anim.notetracks["bodyfall large"] = &notetrackbodyfall;
	anim.notetracks["bodyfall small"] = &notetrackbodyfall;
	anim.notetracks["footstep"] = &notetrackfootstep;
	anim.notetracks["step"] = &notetrackfootstep;
	anim.notetracks["footstep_right_large"] = &notetrackfootstep;
	anim.notetracks["footstep_right_small"] = &notetrackfootstep;
	anim.notetracks["footstep_left_large"] = &notetrackfootstep;
	anim.notetracks["footstep_left_small"] = &notetrackfootstep;
	anim.notetracks["footscrape"] = &notetrackfootscrape;
	anim.notetracks["land"] = &notetrackland;
	anim.notetracks["start_ragdoll"] = &notetrackstartragdoll;
}

/*
	Name: notetrackstopanim
	Namespace: zombie_shared
	Checksum: 0xF0B6C5D6
	Offset: 0xB98
	Size: 0x14
	Parameters: 2
	Flags: None
*/
function notetrackstopanim(note, flagname)
{
}

/*
	Name: notetrackstartragdoll
	Namespace: zombie_shared
	Checksum: 0x2B1B9CF
	Offset: 0xBB8
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function notetrackstartragdoll(note, flagname)
{
	if(isdefined(self.noragdoll))
	{
		return;
	}
	self unlink();
	self startragdoll();
}

/*
	Name: notetrackmovementstop
	Namespace: zombie_shared
	Checksum: 0xE3687222
	Offset: 0xC10
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function notetrackmovementstop(note, flagname)
{
	if(issentient(self))
	{
		self.a.movement = "stop";
	}
}

/*
	Name: notetrackmovementwalk
	Namespace: zombie_shared
	Checksum: 0x12B7E8C6
	Offset: 0xC60
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function notetrackmovementwalk(note, flagname)
{
	if(issentient(self))
	{
		self.a.movement = "walk";
	}
}

/*
	Name: notetrackmovementrun
	Namespace: zombie_shared
	Checksum: 0x42380774
	Offset: 0xCB0
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function notetrackmovementrun(note, flagname)
{
	if(issentient(self))
	{
		self.a.movement = "run";
	}
}

/*
	Name: notetrackalertnesscasual
	Namespace: zombie_shared
	Checksum: 0x56546D63
	Offset: 0xD00
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function notetrackalertnesscasual(note, flagname)
{
	if(issentient(self))
	{
		self.a.alertness = "casual";
	}
}

/*
	Name: notetrackalertnessalert
	Namespace: zombie_shared
	Checksum: 0x7D3C8C5F
	Offset: 0xD50
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function notetrackalertnessalert(note, flagname)
{
	if(issentient(self))
	{
		self.a.alertness = "alert";
	}
}

/*
	Name: notetrackposestand
	Namespace: zombie_shared
	Checksum: 0x64417B5C
	Offset: 0xDA0
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function notetrackposestand(note, flagname)
{
	self.a.pose = "stand";
	self notify("entered_pose" + "stand");
}

/*
	Name: notetrackposecrouch
	Namespace: zombie_shared
	Checksum: 0xB5B531DC
	Offset: 0xDF0
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function notetrackposecrouch(note, flagname)
{
	self.a.pose = "crouch";
	self notify("entered_pose" + "crouch");
	if(self.a.crouchpain)
	{
		self.a.crouchpain = 0;
		self.health = 150;
	}
}

/*
	Name: notetrackgravity
	Namespace: zombie_shared
	Checksum: 0xD08E891
	Offset: 0xE70
	Size: 0xEE
	Parameters: 2
	Flags: Linked
*/
function notetrackgravity(note, flagname)
{
	if(issubstr(note, "on"))
	{
		self animmode("gravity");
	}
	else
	{
		if(issubstr(note, "off"))
		{
			self animmode("nogravity");
			self.nogravity = 1;
		}
		else if(issubstr(note, "code"))
		{
			self animmode("none");
			self.nogravity = undefined;
		}
	}
}

/*
	Name: notetrackbodyfall
	Namespace: zombie_shared
	Checksum: 0x7996BDC3
	Offset: 0xF68
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function notetrackbodyfall(note, flagname)
{
	if(isdefined(self.groundtype))
	{
		groundtype = self.groundtype;
	}
	else
	{
		groundtype = "dirt";
	}
	if(issubstr(note, "large"))
	{
		self playsound("fly_bodyfall_large_" + groundtype);
	}
	else if(issubstr(note, "small"))
	{
		self playsound("fly_bodyfall_small_" + groundtype);
	}
}

/*
	Name: notetrackfootstep
	Namespace: zombie_shared
	Checksum: 0x80C74B0E
	Offset: 0x1038
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function notetrackfootstep(note, flagname)
{
	if(issubstr(note, "left"))
	{
		playfootstep("J_Ball_LE");
	}
	else
	{
		playfootstep("J_BALL_RI");
	}
	if(!level.clientscripts)
	{
		self playsound("fly_gear_run");
	}
}

/*
	Name: notetrackfootscrape
	Namespace: zombie_shared
	Checksum: 0xE08BF739
	Offset: 0x10D8
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function notetrackfootscrape(note, flagname)
{
	if(isdefined(self.groundtype))
	{
		groundtype = self.groundtype;
	}
	else
	{
		groundtype = "dirt";
	}
	self playsound("fly_step_scrape_" + groundtype);
}

/*
	Name: notetrackland
	Namespace: zombie_shared
	Checksum: 0x803319C9
	Offset: 0x1148
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function notetrackland(note, flagname)
{
	if(isdefined(self.groundtype))
	{
		groundtype = self.groundtype;
	}
	else
	{
		groundtype = "dirt";
	}
	self playsound("fly_land_npc_" + groundtype);
}

/*
	Name: handlenotetrack
	Namespace: zombie_shared
	Checksum: 0xBC00C609
	Offset: 0x11B8
	Size: 0x30A
	Parameters: 4
	Flags: Linked
*/
function handlenotetrack(note, flagname, customfunction, var1)
{
	if(isai(self) && isdefined(anim.notetracks))
	{
		notetrackfunc = anim.notetracks[note];
		if(isdefined(notetrackfunc))
		{
			return [[notetrackfunc]](note, flagname);
		}
	}
	switch(note)
	{
		case "end":
		case "finish":
		case "undefined":
		{
			return note;
		}
		case "swish small":
		{
			self thread sound::play_in_space("fly_gear_enemy", self gettagorigin("TAG_WEAPON_RIGHT"));
			break;
		}
		case "swish large":
		{
			self thread sound::play_in_space("fly_gear_enemy_large", self gettagorigin("TAG_WEAPON_RIGHT"));
			break;
		}
		case "no death":
		{
			self.a.nodeath = 1;
			break;
		}
		case "no pain":
		{
			self.allowpain = 0;
			break;
		}
		case "allow pain":
		{
			self.allowpain = 1;
			break;
		}
		case "anim_melee = \"right\"":
		case "anim_melee = right":
		{
			self.a.meleestate = "right";
			break;
		}
		case "anim_melee = \"left\"":
		case "anim_melee = left":
		{
			self.a.meleestate = "left";
			break;
		}
		case "swap taghelmet to tagleft":
		{
			if(isdefined(self.hatmodel))
			{
				if(isdefined(self.helmetsidemodel))
				{
					self detach(self.helmetsidemodel, "TAG_HELMETSIDE");
					self.helmetsidemodel = undefined;
				}
				self detach(self.hatmodel, "");
				self attach(self.hatmodel, "TAG_WEAPON_LEFT");
				self.hatmodel = undefined;
			}
			break;
		}
		default:
		{
			if(isdefined(customfunction))
			{
				if(!isdefined(var1))
				{
					return [[customfunction]](note);
				}
				else
				{
					return [[customfunction]](note, var1);
				}
			}
			break;
		}
	}
}

/*
	Name: donotetracks
	Namespace: zombie_shared
	Checksum: 0x293CF051
	Offset: 0x14D0
	Size: 0x8C
	Parameters: 3
	Flags: Linked
*/
function donotetracks(flagname, customfunction, var1)
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
	Name: donotetracksforeverproc
	Namespace: zombie_shared
	Checksum: 0x9CDDDEA5
	Offset: 0x1568
	Size: 0x13E
	Parameters: 5
	Flags: Linked
*/
function donotetracksforeverproc(notetracksfunc, flagname, killstring, customfunction, var1)
{
	if(isdefined(killstring))
	{
		self endon(killstring);
	}
	self endon(#"killanimscript");
	for(;;)
	{
		time = gettime();
		returnednote = [[notetracksfunc]](flagname, customfunction, var1);
		timetaken = gettime() - time;
		if(timetaken < 0.05)
		{
			time = gettime();
			returnednote = [[notetracksfunc]](flagname, customfunction, var1);
			timetaken = gettime() - time;
			if(timetaken < 0.05)
			{
				/#
					println(((((gettime() + "") + flagname) + "") + returnednote) + "");
				#/
				wait(0.05 - timetaken);
			}
		}
	}
}

/*
	Name: donotetracksforever
	Namespace: zombie_shared
	Checksum: 0xB6BF397D
	Offset: 0x16B0
	Size: 0x54
	Parameters: 4
	Flags: Linked
*/
function donotetracksforever(flagname, killstring, customfunction, var1)
{
	donotetracksforeverproc(&donotetracks, flagname, killstring, customfunction, var1);
}

/*
	Name: donotetracksfortimeproc
	Namespace: zombie_shared
	Checksum: 0xE9663CF2
	Offset: 0x1710
	Size: 0x5A
	Parameters: 6
	Flags: Linked
*/
function donotetracksfortimeproc(donotetracksforeverfunc, time, flagname, customfunction, ent, var1)
{
	ent endon(#"stop_notetracks");
	[[donotetracksforeverfunc]](flagname, undefined, customfunction, var1);
}

/*
	Name: donotetracksfortime
	Namespace: zombie_shared
	Checksum: 0xF012D78C
	Offset: 0x1778
	Size: 0x94
	Parameters: 4
	Flags: None
*/
function donotetracksfortime(time, flagname, customfunction, var1)
{
	ent = spawnstruct();
	ent thread donotetracksfortimeendnotify(time);
	donotetracksfortimeproc(&donotetracksforever, time, flagname, customfunction, ent, var1);
}

/*
	Name: donotetracksfortimeendnotify
	Namespace: zombie_shared
	Checksum: 0x132B5AAB
	Offset: 0x1818
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function donotetracksfortimeendnotify(time)
{
	wait(time);
	self notify(#"stop_notetracks");
}

/*
	Name: playfootstep
	Namespace: zombie_shared
	Checksum: 0xAC931724
	Offset: 0x1840
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function playfootstep(foot)
{
	if(!level.clientscripts)
	{
		if(!isai(self))
		{
			self playsound("fly_step_run_dirt");
			return;
		}
	}
	groundtype = undefined;
	if(!isdefined(self.groundtype))
	{
		if(!isdefined(self.lastgroundtype))
		{
			if(!level.clientscripts)
			{
				self playsound("fly_step_run_dirt");
			}
			return;
		}
		groundtype = self.lastgroundtype;
	}
	else
	{
		groundtype = self.groundtype;
		self.lastgroundtype = self.groundtype;
	}
	if(!level.clientscripts)
	{
		self playsound("fly_step_run_" + groundtype);
	}
	[[anim.optionalstepeffectfunction]](foot, groundtype);
}

/*
	Name: playfootstepeffect
	Namespace: zombie_shared
	Checksum: 0x5ACB6A2C
	Offset: 0x1958
	Size: 0x108
	Parameters: 2
	Flags: Linked
*/
function playfootstepeffect(foot, groundtype)
{
	if(level.clientscripts)
	{
		return;
	}
	for(i = 0; i < anim.optionalstepeffects.size; i++)
	{
		if(isdefined(self.fire_footsteps) && self.fire_footsteps)
		{
			groundtype = "fire";
		}
		if(groundtype != anim.optionalstepeffects[i])
		{
			continue;
		}
		org = self gettagorigin(foot);
		playfx(level._effect["step_" + anim.optionalstepeffects[i]], org, org + vectorscale((0, 0, 1), 100));
		return;
	}
}

/*
	Name: movetooriginovertime
	Namespace: zombie_shared
	Checksum: 0x31182A9B
	Offset: 0x1A68
	Size: 0x168
	Parameters: 2
	Flags: None
*/
function movetooriginovertime(origin, time)
{
	self endon(#"killanimscript");
	if(distancesquared(self.origin, origin) > 256 && !self maymovetopoint(origin))
	{
		/#
			println(("" + origin) + "");
		#/
		return;
	}
	self.keepclaimednodeingoal = 1;
	offset = self.origin - origin;
	frames = int(time * 20);
	offsetreduction = vectorscale(offset, 1 / frames);
	for(i = 0; i < frames; i++)
	{
		offset = offset - offsetreduction;
		self teleport(origin + offset);
		wait(0.05);
	}
	self.keepclaimednodeingoal = 0;
}

/*
	Name: returntrue
	Namespace: zombie_shared
	Checksum: 0x7F22AEB8
	Offset: 0x1BD8
	Size: 0x8
	Parameters: 0
	Flags: None
*/
function returntrue()
{
	return true;
}

/*
	Name: trackloop
	Namespace: zombie_shared
	Checksum: 0x343BDCCC
	Offset: 0x1BE8
	Size: 0x714
	Parameters: 0
	Flags: None
*/
function trackloop()
{
	players = getplayers();
	deltachangeperframe = 5;
	aimblendtime = 0.05;
	prevyawdelta = 0;
	prevpitchdelta = 0;
	maxyawdeltachange = 5;
	maxpitchdeltachange = 5;
	pitchadd = 0;
	yawadd = 0;
	if(self.type == "dog" || self.type == "zombie" || self.type == "zombie_dog")
	{
		domaxanglecheck = 0;
		self.shootent = self.enemy;
	}
	else
	{
		domaxanglecheck = 1;
		if(self.a.script == "cover_crouch" && isdefined(self.a.covermode) && self.a.covermode == "lean")
		{
			pitchadd = -1 * anim.covercrouchleanpitch;
		}
		if(self.a.script == "cover_left" || self.a.script == "cover_right" && isdefined(self.a.cornermode) && self.a.cornermode == "lean")
		{
			yawadd = self.covernode.angles[1] - self.angles[1];
		}
	}
	yawdelta = 0;
	pitchdelta = 0;
	firstframe = 1;
	for(;;)
	{
		incranimaimweight();
		selfshootatpos = (self.origin[0], self.origin[1], self geteye()[2]);
		shootpos = undefined;
		if(isdefined(self.enemy))
		{
			shootpos = self.enemy getshootatpos();
		}
		if(!isdefined(shootpos))
		{
			yawdelta = 0;
			pitchdelta = 0;
		}
		else
		{
			vectortoshootpos = shootpos - selfshootatpos;
			anglestoshootpos = vectortoangles(vectortoshootpos);
			pitchdelta = 360 - anglestoshootpos[0];
			pitchdelta = angleclamp180(pitchdelta + pitchadd);
			yawdelta = self.angles[1] - anglestoshootpos[1];
			yawdelta = angleclamp180(yawdelta + yawadd);
		}
		if(domaxanglecheck && (abs(yawdelta) > 60 || abs(pitchdelta) > 60))
		{
			yawdelta = 0;
			pitchdelta = 0;
		}
		else
		{
			if(yawdelta > self.rightaimlimit)
			{
				yawdelta = self.rightaimlimit;
			}
			else if(yawdelta < self.leftaimlimit)
			{
				yawdelta = self.leftaimlimit;
			}
			if(pitchdelta > self.upaimlimit)
			{
				pitchdelta = self.upaimlimit;
			}
			else if(pitchdelta < self.downaimlimit)
			{
				pitchdelta = self.downaimlimit;
			}
		}
		if(firstframe)
		{
			firstframe = 0;
		}
		else
		{
			yawdeltachange = yawdelta - prevyawdelta;
			if(abs(yawdeltachange) > maxyawdeltachange)
			{
				yawdelta = prevyawdelta + (maxyawdeltachange * math::sign(yawdeltachange));
			}
			pitchdeltachange = pitchdelta - prevpitchdelta;
			if(abs(pitchdeltachange) > maxpitchdeltachange)
			{
				pitchdelta = prevpitchdelta + (maxpitchdeltachange * math::sign(pitchdeltachange));
			}
		}
		prevyawdelta = yawdelta;
		prevpitchdelta = pitchdelta;
		updown = 0;
		leftright = 0;
		if(yawdelta > 0)
		{
			/#
				assert(yawdelta <= self.rightaimlimit);
			#/
			weight = (yawdelta / self.rightaimlimit) * self.a.aimweight;
			leftright = weight;
		}
		else if(yawdelta < 0)
		{
			/#
				assert(yawdelta >= self.leftaimlimit);
			#/
			weight = (yawdelta / self.leftaimlimit) * self.a.aimweight;
			leftright = -1 * weight;
		}
		if(pitchdelta > 0)
		{
			/#
				assert(pitchdelta <= self.upaimlimit);
			#/
			weight = (pitchdelta / self.upaimlimit) * self.a.aimweight;
			updown = weight;
		}
		else if(pitchdelta < 0)
		{
			/#
				assert(pitchdelta >= self.downaimlimit);
			#/
			weight = (pitchdelta / self.downaimlimit) * self.a.aimweight;
			updown = -1 * weight;
		}
		wait(0.05);
	}
}

/*
	Name: setanimaimweight
	Namespace: zombie_shared
	Checksum: 0x51A0DD60
	Offset: 0x2308
	Size: 0x108
	Parameters: 2
	Flags: None
*/
function setanimaimweight(goalweight, goaltime)
{
	if(!isdefined(goaltime) || goaltime <= 0)
	{
		self.a.aimweight = goalweight;
		self.a.aimweight_start = goalweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = 0;
	}
	else
	{
		self.a.aimweight = goalweight;
		self.a.aimweight_start = self.a.aimweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = int(goaltime * 20);
	}
	self.a.aimweight_t = 0;
}

/*
	Name: incranimaimweight
	Namespace: zombie_shared
	Checksum: 0x1AA70A61
	Offset: 0x2418
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function incranimaimweight()
{
	if(self.a.aimweight_t < self.a.aimweight_transframes)
	{
		self.a.aimweight_t++;
		t = (1 * self.a.aimweight_t) / self.a.aimweight_transframes;
		self.a.aimweight = (self.a.aimweight_start * (1 - t)) + (self.a.aimweight_end * t);
	}
}

