// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;

#namespace blackboard;

/*
	Name: registeractorblackboardattributes
	Namespace: blackboard
	Checksum: 0x4F82761F
	Offset: 0x398
	Size: 0x1DC
	Parameters: 0
	Flags: Linked
*/
function registeractorblackboardattributes()
{
	registerblackboardattribute(self, "_tactical_arrival_facing_yaw", undefined, &bb_gettacticalarrivalfacingyaw);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	registerblackboardattribute(self, "_human_locomotion_movement_type", undefined, &bb_getlocomotionmovementtype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	registerblackboardattribute(self, "_human_cover_flankability", undefined, &bb_getcoverflankability);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	registerblackboardattribute(self, "_arrival_type", undefined, &bb_getarrivaltype);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	registerblackboardattribute(self, "_human_locomotion_variation", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
}

/*
	Name: bb_getarrivaltype
	Namespace: blackboard
	Checksum: 0x79234B33
	Offset: 0x580
	Size: 0x36
	Parameters: 0
	Flags: Linked, Private
*/
function private bb_getarrivaltype()
{
	if(self ai::get_behavior_attribute("disablearrivals"))
	{
		return "dont_arrive_at_goal";
	}
	return "arrive_at_goal";
}

/*
	Name: bb_gettacticalarrivalfacingyaw
	Namespace: blackboard
	Checksum: 0x8DE58AA4
	Offset: 0x5C0
	Size: 0x3A
	Parameters: 0
	Flags: Linked, Private
*/
function private bb_gettacticalarrivalfacingyaw()
{
	return angleclamp180(self.angles[1] - self.node.angles[1]);
}

/*
	Name: bb_getlocomotionmovementtype
	Namespace: blackboard
	Checksum: 0x3714CB1B
	Offset: 0x608
	Size: 0x1BA
	Parameters: 0
	Flags: Linked, Private
*/
function private bb_getlocomotionmovementtype()
{
	if(!ai::getaiattribute(self, "disablesprint"))
	{
		if(ai::getaiattribute(self, "sprint"))
		{
			return "human_locomotion_movement_sprint";
		}
		if(!isdefined(self.nearbyfriendlycheck))
		{
			self.nearbyfriendlycheck = 0;
		}
		now = gettime();
		if(now >= self.nearbyfriendlycheck)
		{
			self.nearbyfriendlycount = getactorteamcountradius(self.origin, 120, self.team, "neutral");
			self.nearbyfriendlycheck = now + 500;
		}
		if(self.nearbyfriendlycount >= 3)
		{
			return "human_locomotion_movement_default";
		}
		if(isdefined(self.enemy) && isdefined(self.runandgundist))
		{
			if(distancesquared(self.origin, self lastknownpos(self.enemy)) > (self.runandgundist * self.runandgundist))
			{
				return "human_locomotion_movement_sprint";
			}
		}
		else if(isdefined(self.goalpos) && isdefined(self.runandgundist))
		{
			if(distancesquared(self.origin, self.goalpos) > (self.runandgundist * self.runandgundist))
			{
				return "human_locomotion_movement_sprint";
			}
		}
	}
	return "human_locomotion_movement_default";
}

/*
	Name: bb_getcoverflankability
	Namespace: blackboard
	Checksum: 0xAFBB2988
	Offset: 0x7D0
	Size: 0x1CE
	Parameters: 0
	Flags: Linked, Private
*/
function private bb_getcoverflankability()
{
	if(self asmistransitionrunning())
	{
		return "unflankable";
	}
	if(!isdefined(self.node))
	{
		return "unflankable";
	}
	covermode = getblackboardattribute(self, "_cover_mode");
	if(isdefined(covermode))
	{
		covernode = self.node;
		if(covermode == "cover_alert" || covermode == "cover_mode_none")
		{
			return "flankable";
		}
		if(covernode.type == "Cover Pillar")
		{
			return covermode == "cover_blind";
		}
		if(covernode.type == "Cover Left" || covernode.type == "Cover Right")
		{
			return covermode == "cover_blind" || covermode == "cover_over";
		}
		if(covernode.type == "Cover Stand" || covernode.type == "Conceal Stand" || (covernode.type == "Cover Crouch" || covernode.type == "Cover Crouch Window" || covernode.type == "Conceal Crouch"))
		{
			return "flankable";
		}
	}
	return "unflankable";
}

