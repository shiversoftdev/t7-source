// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

class squad 
{
	var squadleader;
	var squadmembers;
	var squadbreadcrumb;

	/*
		Name: constructor
		Namespace: squad
		Checksum: 0x4FA8A6EA
		Offset: 0x248
		Size: 0x28
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		squadleader = 0;
		squadmembers = [];
		squadbreadcrumb = [];
	}

	/*
		Name: destructor
		Namespace: squad
		Checksum: 0x99EC1590
		Offset: 0x510
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
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
		if(isint(squadleader) && squadleader == 0 || !isdefined(squadleader))
		{
			if(squadmembers.size > 0)
			{
				squadleader = squadmembers[0];
				squadbreadcrumb = squadleader.origin;
			}
			else
			{
				return false;
			}
		}
		return true;
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
		if(isinarray(squadmembers, ai))
		{
			arrayremovevalue(squadmembers, ai, 0);
			if(squadleader === ai)
			{
				squadleader = undefined;
			}
		}
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
		if(!isinarray(squadmembers, ai))
		{
			if(ai.archetype == "robot")
			{
				ai ai::set_behavior_attribute("move_mode", "squadmember");
			}
			squadmembers[squadmembers.size] = ai;
		}
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
		return squadmembers;
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
		return squadleader;
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
		return squadbreadcrumb;
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
			assert(squadleader == ai);
		#/
		if(distance2dsquared(squadbreadcrumb, ai.origin) >= 9216)
		{
			/#
				recordcircle(ai.origin, 4, (0, 0, 1), "", ai);
			#/
			squadbreadcrumb = ai.origin;
		}
	}

}

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
function autoexec __init__sytem__()
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

/*
	Name: createsquad
	Namespace: aisquads
	Checksum: 0xC47ACE35
	Offset: 0x700
	Size: 0x38
	Parameters: 1
	Flags: Linked, Private
*/
function private createsquad(squadname)
{
	level._squads[squadname] = new squad();
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
function private removesquad(squadname)
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
function private getsquad(squadname)
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
function private thinksquad(squadname)
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
function private squadmemberdeath()
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
function private squadmemberthink()
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
		return false;
	}
	squadmember = issquadmember(ai);
	currentsquadleader = getsquadleader(ai);
	isaisquadleader = isdefined(currentsquadleader) && currentsquadleader == ai;
	if(squadmember && !isaisquadleader)
	{
		return true;
	}
	return false;
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

