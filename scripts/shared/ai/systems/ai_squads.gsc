// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace aisquads;

/*
	Name: __init__sytem__
	Namespace: aisquads
	Checksum: 0x912F91FC
	Offset: 0x190
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("ai_squads", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: aisquads
	Checksum: 0x67AAFBBE
	Offset: 0x1D0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._squads = [];
	actorspawnerarray = getactorspawnerteamarray("axis");
	array::run_all(actorspawnerarray, &spawner::add_spawn_function, &squadmemberthink);
}

#namespace squad;

/*
	Name: __constructor
	Namespace: squad
	Checksum: 0x4FA8A6EA
	Offset: 0x248
	Size: 0x28
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	self.squadleader = 0;
	self.squadmembers = [];
	self.squadbreadcrumb = [];
}

/*
	Name: addsquadbreadcrumbs
	Namespace: squad
	Checksum: 0x765756E1
	Offset: 0x278
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function addsquadbreadcrumbs(ai)
{
	/#
		assert(self.squadleader == ai);
	#/
	if(distance2dsquared(self.squadbreadcrumb, ai.origin) >= 9216)
	{
		/#
			recordcircle(ai.origin, 4, (0, 0, 1), "", ai);
		#/
		self.squadbreadcrumb = ai.origin;
	}
}

/*
	Name: getsquadbreadcrumb
	Namespace: squad
	Checksum: 0x6B4D95D4
	Offset: 0x338
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function getsquadbreadcrumb()
{
	return self.squadbreadcrumb;
}

/*
	Name: getleader
	Namespace: squad
	Checksum: 0xDC71063C
	Offset: 0x350
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function getleader()
{
	return self.squadleader;
}

/*
	Name: getmembers
	Namespace: squad
	Checksum: 0xFA8C37B4
	Offset: 0x368
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function getmembers()
{
	return self.squadmembers;
}

/*
	Name: addaitosquad
	Namespace: squad
	Checksum: 0x4437EDA6
	Offset: 0x380
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function addaitosquad(ai)
{
	if(!isinarray(self.squadmembers, ai))
	{
		if(ai.archetype == "robot")
		{
			ai ai::set_behavior_attribute("move_mode", "squadmember");
		}
		self.squadmembers[self.squadmembers.size] = ai;
	}
}

/*
	Name: removeaifromsqaud
	Namespace: squad
	Checksum: 0x96AA4CC2
	Offset: 0x410
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function removeaifromsqaud(ai)
{
	if(isinarray(self.squadmembers, ai))
	{
		arrayremovevalue(self.squadmembers, ai, 0);
		if(self.squadleader === ai)
		{
			self.squadleader = undefined;
		}
	}
}

/*
	Name: think
	Namespace: squad
	Checksum: 0xE3F2F60C
	Offset: 0x480
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function think()
{
	if(isint(self.squadleader) && self.squadleader == 0 || !isdefined(self.squadleader))
	{
		if(self.squadmembers.size > 0)
		{
			self.squadleader = self.squadmembers[0];
			self.squadbreadcrumb = self.squadleader.origin;
		}
		else
		{
			return 0;
		}
	}
	return 1;
}

/*
	Name: __destructor
	Namespace: squad
	Checksum: 0x99EC1590
	Offset: 0x510
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
}

#namespace aisquads;

/*
	Name: squad
	Namespace: aisquads
	Checksum: 0x9F08AEC8
	Offset: 0x520
	Size: 0x1D6
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function squad()
{
	classes.squad[0] = spawnstruct();
	classes.squad[0].__vtable[1606033458] = &squad::__destructor;
	classes.squad[0].__vtable[1077602763] = &squad::think;
	classes.squad[0].__vtable[-956678077] = &squad::removeaifromsqaud;
	classes.squad[0].__vtable[2131588255] = &squad::addaitosquad;
	classes.squad[0].__vtable[16176468] = &squad::getmembers;
	classes.squad[0].__vtable[-667235832] = &squad::getleader;
	classes.squad[0].__vtable[-407785572] = &squad::getsquadbreadcrumb;
	classes.squad[0].__vtable[-997895106] = &squad::addsquadbreadcrumbs;
	classes.squad[0].__vtable[-1690805083] = &squad::__constructor;
}

/*
	Name: createsquad
	Namespace: aisquads
	Checksum: 0xC47ACE35
	Offset: 0x700
	Size: 0x38
	Parameters: 1
	Flags: Linked, Private
*/
private function createsquad(squadname)
{
	object = new squad();
	[[ object ]]->__constructor();
	level._squads[squadname] = object;
	return level._squads[squadname];
}

/*
	Name: removesquad
	Namespace: aisquads
	Checksum: 0xB71A0BEE
	Offset: 0x740
	Size: 0x38
	Parameters: 1
	Flags: Linked, Private
*/
private function removesquad(squadname)
{
	if(isdefined(level._squads) && isdefined(level._squads[squadname]))
	{
		level._squads[squadname] = undefined;
	}
}

/*
	Name: getsquad
	Namespace: aisquads
	Checksum: 0x19402E25
	Offset: 0x780
	Size: 0x18
	Parameters: 1
	Flags: Linked, Private
*/
private function getsquad(squadname)
{
	return level._squads[squadname];
}

/*
	Name: thinksquad
	Namespace: aisquads
	Checksum: 0xFC4FD04C
	Offset: 0x7A0
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
private function thinksquad(squadname)
{
	while(true)
	{
		if([[ level._squads[squadname] ]]->think())
		{
			wait(0.5);
		}
		else
		{
			removesquad(squadname);
			break;
		}
	}
}

/*
	Name: squadmemberdeath
	Namespace: aisquads
	Checksum: 0x7D4AAC42
	Offset: 0x808
	Size: 0x54
	Parameters: 0
	Flags: Linked, Private
*/
private function squadmemberdeath()
{
	self waittill(#"death");
	if(isdefined(self.squadname) && isdefined(level._squads[self.squadname]))
	{
		[[ level._squads[self.squadname] ]]->removeaifromsqaud(self);
	}
}

/*
	Name: squadmemberthink
	Namespace: aisquads
	Checksum: 0x75D41FE9
	Offset: 0x868
	Size: 0x416
	Parameters: 0
	Flags: Linked, Private
*/
private function squadmemberthink()
{
	self endon(#"death");
	if(!isdefined(self.script_aisquadname))
	{
		return;
	}
	wait(0.5);
	self.squadname = self.script_aisquadname;
	if(isdefined(self.squadname))
	{
		if(!isdefined(level._squads[self.squadname]))
		{
			squad = createsquad(self.squadname);
			newsquadcreated = 1;
		}
		else
		{
			squad = getsquad(self.squadname);
		}
		[[ squad ]]->addaitosquad(self);
		self thread squadmemberdeath();
		if(isdefined(newsquadcreated) && newsquadcreated)
		{
			level thread thinksquad(self.squadname);
		}
		while(true)
		{
			squadleader = [[ level._squads[self.squadname] ]]->getleader();
			if(isdefined(squadleader) && (!(isint(squadleader) && squadleader == 0)))
			{
				if(squadleader == self)
				{
					/#
						recordenttext(self.squadname + "", self, (0, 1, 0), "");
					#/
					/#
						recordenttext(self.squadname + "", self, (0, 1, 0), "");
					#/
					/#
						recordcircle(self.origin, 300, (1, 0.5, 0), "", self);
					#/
					if(isdefined(self.enemy))
					{
						self setgoal(self.enemy);
					}
					[[ squad ]]->addsquadbreadcrumbs(self);
				}
				else
				{
					/#
						recordline(self.origin, squadleader.origin, (0, 1, 0), "", self);
					#/
					/#
						recordenttext(self.squadname + "", self, (0, 1, 0), "");
					#/
					followposition = [[ squad ]]->getsquadbreadcrumb();
					followdistsq = distance2dsquared(self.goalpos, followposition);
					if(isdefined(squadleader.enemy))
					{
						if(!isdefined(self.enemy) || (isdefined(self.enemy) && self.enemy != squadleader.enemy))
						{
							self setentitytarget(squadleader.enemy, 1);
						}
					}
					if(isdefined(self.goalpos) && followdistsq >= 256)
					{
						if(followdistsq >= 22500)
						{
							self ai::set_behavior_attribute("sprint", 1);
						}
						else
						{
							self ai::set_behavior_attribute("sprint", 0);
						}
						self setgoal(followposition, 1);
					}
				}
			}
			wait(1);
		}
	}
}

/*
	Name: isfollowingsquadleader
	Namespace: aisquads
	Checksum: 0x86AE2925
	Offset: 0xC88
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function isfollowingsquadleader(ai)
{
	if(ai ai::get_behavior_attribute("move_mode") != "squadmember")
	{
		return 0;
	}
	squadmember = issquadmember(ai);
	currentsquadleader = getsquadleader(ai);
	isaisquadleader = isdefined(currentsquadleader) && currentsquadleader == ai;
	if(squadmember && !isaisquadleader)
	{
		return 1;
	}
	return 0;
}

/*
	Name: issquadmember
	Namespace: aisquads
	Checksum: 0xC03C3F11
	Offset: 0xD50
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function issquadmember(ai)
{
	if(isdefined(ai.squadname))
	{
		squad = getsquad(ai.squadname);
		if(isdefined(squad))
		{
			return isinarray([[ squad ]]->getmembers(), ai);
		}
	}
	return 0;
}

/*
	Name: issquadleader
	Namespace: aisquads
	Checksum: 0xF0293A3F
	Offset: 0xDD0
	Size: 0x88
	Parameters: 1
	Flags: None
*/
function issquadleader(ai)
{
	if(isdefined(ai.squadname))
	{
		squad = getsquad(ai.squadname);
		if(isdefined(squad))
		{
			squadleader = [[ squad ]]->getleader();
			return isdefined(squadleader) && squadleader == ai;
		}
	}
	return 0;
}

/*
	Name: getsquadleader
	Namespace: aisquads
	Checksum: 0x166F1A3
	Offset: 0xE60
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function getsquadleader(ai)
{
	if(isdefined(ai.squadname))
	{
		squad = getsquad(ai.squadname);
		if(isdefined(squad))
		{
			return [[ squad ]]->getleader();
		}
	}
	return undefined;
}

