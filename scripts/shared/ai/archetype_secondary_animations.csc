// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;

#using_animtree("generic");

#namespace archetype_secondary_animations;

/*
	Name: main
	Namespace: archetype_secondary_animations
	Checksum: 0xD888C374
	Offset: 0x3C0
	Size: 0xA4
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	if(sessionmodeiszombiesgame() && getdvarint("splitscreen_playerCount") > 2)
	{
		return;
	}
	ai::add_archetype_spawn_function("human", &secondaryanimationsinit);
	ai::add_archetype_spawn_function("zombie", &secondaryanimationsinit);
	ai::add_ai_spawn_function(&on_entity_spawn);
}

/*
	Name: secondaryanimationsinit
	Namespace: archetype_secondary_animations
	Checksum: 0xF3450D01
	Offset: 0x470
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private secondaryanimationsinit(localclientnum)
{
	if(!isdefined(level.__facialanimationslist))
	{
		buildandvalidatefacialanimationlist(localclientnum);
	}
	self callback::on_shutdown(&on_entity_shutdown);
	self thread secondaryfacialanimationthink(localclientnum);
}

/*
	Name: on_entity_spawn
	Namespace: archetype_secondary_animations
	Checksum: 0xF119293A
	Offset: 0x4E0
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private on_entity_spawn(localclientnum)
{
	if(self hasdobj(localclientnum))
	{
		self clearanim(%generic::faces, 0);
	}
	self._currentfacestate = "inactive";
}

/*
	Name: on_entity_shutdown
	Namespace: archetype_secondary_animations
	Checksum: 0x14A1909C
	Offset: 0x548
	Size: 0x60
	Parameters: 1
	Flags: Linked, Private
*/
function private on_entity_shutdown(localclientnum)
{
	if(isdefined(self))
	{
		self notify(#"stopfacialthread");
		if(isdefined(self.facialdeathanimstarted) && self.facialdeathanimstarted)
		{
			return;
		}
		self applydeathanim(localclientnum);
		self.facialdeathanimstarted = 1;
	}
}

/*
	Name: buildandvalidatefacialanimationlist
	Namespace: archetype_secondary_animations
	Checksum: 0x3C7D436E
	Offset: 0x5B0
	Size: 0x5A2
	Parameters: 1
	Flags: Linked
*/
function buildandvalidatefacialanimationlist(localclientnum)
{
	/#
		assert(!isdefined(level.__facialanimationslist));
	#/
	level.__facialanimationslist = [];
	level.__facialanimationslist["human"] = [];
	level.__facialanimationslist["human"]["combat"] = array("ai_face_male_generic_idle_1", "ai_face_male_generic_idle_2", "ai_face_male_generic_idle_3");
	level.__facialanimationslist["human"]["combat_aim"] = array("ai_face_male_aim_idle_1", "ai_face_male_aim_idle_2", "ai_face_male_aim_idle_3");
	level.__facialanimationslist["human"]["combat_shoot"] = array("ai_face_male_aim_fire_1", "ai_face_male_aim_fire_2", "ai_face_male_aim_fire_3");
	level.__facialanimationslist["human"]["death"] = array("ai_face_male_death_1", "ai_face_male_death_2", "ai_face_male_death_3");
	level.__facialanimationslist["human"]["melee"] = array("ai_face_male_melee_1");
	level.__facialanimationslist["human"]["pain"] = array("ai_face_male_pain_1");
	level.__facialanimationslist["human"]["animscripted"] = array("ai_face_male_generic_idle_1");
	level.__facialanimationslist["zombie"] = [];
	level.__facialanimationslist["zombie"]["combat"] = array("ai_face_zombie_generic_idle_1");
	level.__facialanimationslist["zombie"]["combat_aim"] = array("ai_face_zombie_generic_idle_1");
	level.__facialanimationslist["zombie"]["combat_shoot"] = array("ai_face_zombie_generic_idle_1");
	level.__facialanimationslist["zombie"]["death"] = array("ai_face_zombie_generic_death_1");
	level.__facialanimationslist["zombie"]["melee"] = array("ai_face_zombie_generic_attack_1");
	level.__facialanimationslist["zombie"]["pain"] = array("ai_face_zombie_generic_pain_1");
	level.__facialanimationslist["zombie"]["animscripted"] = array("ai_face_zombie_generic_idle_1");
	deathanims = [];
	foreach(animation in level.__facialanimationslist["human"]["death"])
	{
		array::add(deathanims, animation);
	}
	foreach(animation in level.__facialanimationslist["zombie"]["death"])
	{
		array::add(deathanims, animation);
	}
	foreach(deathanim in deathanims)
	{
		/#
			assert(!isanimlooping(localclientnum, deathanim), ("" + deathanim) + "");
		#/
	}
}

/*
	Name: getfacialanimoverride
	Namespace: archetype_secondary_animations
	Checksum: 0x7C0B2A0E
	Offset: 0xB60
	Size: 0x18E
	Parameters: 1
	Flags: Linked, Private
*/
function private getfacialanimoverride(localclientnum)
{
	if(sessionmodeiscampaigngame())
	{
		primarydeltaanim = self getprimarydeltaanim();
		if(isdefined(primarydeltaanim))
		{
			primarydeltaanimlength = getanimlength(primarydeltaanim);
			notetracks = getnotetracksindelta(primarydeltaanim, 0, 1);
			foreach(notetrack in notetracks)
			{
				if(notetrack[1] == "facial_anim")
				{
					facialanim = notetrack[2];
					facialanimlength = getanimlength(facialanim);
					/#
					#/
					return facialanim;
				}
			}
		}
	}
	return undefined;
}

/*
	Name: secondaryfacialanimationthink
	Namespace: archetype_secondary_animations
	Checksum: 0x7CAAE203
	Offset: 0xCF8
	Size: 0x5FC
	Parameters: 1
	Flags: Linked, Private
*/
function private secondaryfacialanimationthink(localclientnum)
{
	/#
		assert(isdefined(self.archetype) && (self.archetype == "" || self.archetype == ""));
	#/
	self endon(#"entityshutdown");
	self endon(#"stopfacialthread");
	self._currentfacestate = "inactive";
	while(true)
	{
		if(self.archetype == "human" && self clientfield::get("facial_dial"))
		{
			self._currentfacestate = "inactive";
			self clearcurrentfacialanim(localclientnum);
			wait(0.5);
			continue;
		}
		animoverride = self getfacialanimoverride(localclientnum);
		asmstatus = self asmgetstatus(localclientnum);
		forcenewanim = 0;
		switch(asmstatus)
		{
			case "asm_status_terminated":
			{
				return;
			}
			case "asm_status_inactive":
			{
				if(isdefined(animoverride))
				{
					scriptedanim = self getprimarydeltaanim();
					if(isdefined(scriptedanim) && (!isdefined(self._scriptedanim) || self._scriptedanim != scriptedanim))
					{
						self._scriptedanim = scriptedanim;
						forcenewanim = 1;
					}
					if(isdefined(animoverride) && animoverride !== self._currentfaceanim)
					{
						forcenewanim = 1;
					}
				}
				else
				{
					if(self._currentfacestate !== "death")
					{
						self._currentfacestate = "inactive";
						self clearcurrentfacialanim(localclientnum);
					}
					wait(0.5);
					continue;
				}
			}
		}
		closestplayer = arraygetclosest(self.origin, level.localplayers, getdvarint("ai_clientFacialCullDist", 2000));
		if(!isdefined(closestplayer))
		{
			wait(0.5);
			continue;
		}
		if(!self hasdobj(localclientnum) || !self hasanimtree())
		{
			wait(0.5);
			continue;
		}
		currfacestate = self._currentfacestate;
		currentasmstate = self asmgetcurrentstate(localclientnum);
		if(isdefined(currentasmstate))
		{
			currentasmstate = tolower(currentasmstate);
		}
		if(self asmisterminating(localclientnum))
		{
			nextfacestate = "death";
		}
		else
		{
			if(asmstatus == "asm_status_inactive")
			{
				nextfacestate = "animscripted";
			}
			else
			{
				if(isdefined(currentasmstate) && issubstr(currentasmstate, "pain"))
				{
					nextfacestate = "pain";
				}
				else
				{
					if(isdefined(currentasmstate) && issubstr(currentasmstate, "melee"))
					{
						nextfacestate = "melee";
					}
					else
					{
						if(self asmisshootlayeractive(localclientnum))
						{
							nextfacestate = "combat_shoot";
						}
						else
						{
							if(self asmisaimlayeractive(localclientnum))
							{
								nextfacestate = "combat_aim";
							}
							else
							{
								nextfacestate = "combat";
							}
						}
					}
				}
			}
		}
		if(currfacestate == "inactive" || currfacestate != nextfacestate || forcenewanim)
		{
			/#
				assert(isdefined(level.__facialanimationslist[self.archetype][nextfacestate]));
			#/
			clearoncompletion = 0;
			animtoplay = array::random(level.__facialanimationslist[self.archetype][nextfacestate]);
			if(isdefined(animoverride))
			{
				animtoplay = animoverride;
				/#
					assert(nextfacestate != "" || !isanimlooping(localclientnum, animtoplay), ("" + animtoplay) + "");
				#/
			}
			applynewfaceanim(localclientnum, animtoplay, clearoncompletion);
			self._currentfacestate = nextfacestate;
		}
		if(self._currentfacestate == "death")
		{
			break;
		}
		wait(0.25);
	}
}

/*
	Name: applynewfaceanim
	Namespace: archetype_secondary_animations
	Checksum: 0xCBC5A89F
	Offset: 0x1300
	Size: 0xFC
	Parameters: 3
	Flags: Linked, Private
*/
function private applynewfaceanim(localclientnum, animation, clearoncompletion = 0)
{
	clearcurrentfacialanim(localclientnum);
	if(isdefined(animation))
	{
		self._currentfaceanim = animation;
		if(self hasdobj(localclientnum) && self hasanimtree())
		{
			self setflaggedanimknob("ai_secondary_facial_anim", animation, 1, 0.1, 1);
			if(clearoncompletion)
			{
				wait(getanimlength(animation));
				clearcurrentfacialanim(localclientnum);
			}
		}
	}
}

/*
	Name: applydeathanim
	Namespace: archetype_secondary_animations
	Checksum: 0xED6696AD
	Offset: 0x1408
	Size: 0x134
	Parameters: 1
	Flags: Linked, Private
*/
function private applydeathanim(localclientnum)
{
	if(isdefined(self._currentfacestate) && self._currentfacestate == "death")
	{
		return;
	}
	if(getmigrationstatus(localclientnum))
	{
		return;
	}
	if(isdefined(self) && isdefined(level.__facialanimationslist) && isdefined(level.__facialanimationslist[self.archetype]) && isdefined(level.__facialanimationslist[self.archetype]["death"]))
	{
		animtoplay = array::random(level.__facialanimationslist[self.archetype]["death"]);
		animoverride = self getfacialanimoverride(localclientnum);
		if(isdefined(animoverride))
		{
			animtoplay = animoverride;
		}
		self._currentfacestate = "death";
		applynewfaceanim(localclientnum, animtoplay);
	}
}

/*
	Name: clearcurrentfacialanim
	Namespace: archetype_secondary_animations
	Checksum: 0xA313C959
	Offset: 0x1548
	Size: 0x7E
	Parameters: 1
	Flags: Linked, Private
*/
function private clearcurrentfacialanim(localclientnum)
{
	if(isdefined(self._currentfaceanim) && self hasdobj(localclientnum) && self hasanimtree())
	{
		self clearanim(self._currentfaceanim, 0.2);
	}
	self._currentfaceanim = undefined;
}

