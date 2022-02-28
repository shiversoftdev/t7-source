// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

#namespace zombie_utility;

/*
	Name: zombiespawnsetup
	Namespace: zombie_utility
	Checksum: 0x3391397
	Offset: 0x748
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function zombiespawnsetup()
{
	self.zombie_move_speed = "walk";
	if(!isdefined(self.zombie_arms_position))
	{
		if(randomint(2) == 0)
		{
			self.zombie_arms_position = "up";
		}
		else
		{
			self.zombie_arms_position = "down";
		}
	}
	self.missinglegs = 0;
	self setavoidancemask("avoid none");
	self pushactors(1);
	clientfield::set("zombie", 1);
	self.ignorepathenemyfightdist = 1;
}

/*
	Name: get_closest_valid_player
	Namespace: zombie_utility
	Checksum: 0x884FFF41
	Offset: 0x820
	Size: 0x2E6
	Parameters: 3
	Flags: Linked
*/
function get_closest_valid_player(origin, ignore_player, ignore_laststand_players = 0)
{
	pixbeginevent("get_closest_valid_player");
	valid_player_found = 0;
	targets = getplayers();
	if(isdefined(level.closest_player_targets_override))
	{
		targets = [[level.closest_player_targets_override]]();
	}
	if(isdefined(ignore_player))
	{
		for(i = 0; i < ignore_player.size; i++)
		{
			arrayremovevalue(targets, ignore_player[i]);
		}
	}
	done = 1;
	while(targets.size && !done)
	{
		done = 1;
		for(i = 0; i < targets.size; i++)
		{
			target = targets[i];
			if(!is_player_valid(target, 1, ignore_laststand_players))
			{
				arrayremovevalue(targets, target);
				done = 0;
				break;
			}
		}
	}
	if(targets.size == 0)
	{
		pixendevent();
		return undefined;
	}
	if(isdefined(self.closest_player_override))
	{
		target = [[self.closest_player_override]](origin, targets);
	}
	else if(isdefined(level.closest_player_override))
	{
		target = [[level.closest_player_override]](origin, targets);
	}
	if(isdefined(target))
	{
		pixendevent();
		return target;
	}
	sortedpotentialtargets = arraysortclosest(targets, self.origin);
	while(sortedpotentialtargets.size)
	{
		if(is_player_valid(sortedpotentialtargets[0], 1, ignore_laststand_players))
		{
			pixendevent();
			return sortedpotentialtargets[0];
		}
		arrayremovevalue(sortedpotentialtargets, sortedpotentialtargets[0]);
	}
	pixendevent();
	return undefined;
}

/*
	Name: is_player_valid
	Namespace: zombie_utility
	Checksum: 0xD3EA5F4
	Offset: 0xB10
	Size: 0x1A0
	Parameters: 3
	Flags: Linked
*/
function is_player_valid(player, checkignoremeflag, ignore_laststand_players)
{
	if(!isdefined(player))
	{
		return 0;
	}
	if(!isalive(player))
	{
		return 0;
	}
	if(!isplayer(player))
	{
		return 0;
	}
	if(isdefined(player.is_zombie) && player.is_zombie == 1)
	{
		return 0;
	}
	if(player.sessionstate == "spectator")
	{
		return 0;
	}
	if(player.sessionstate == "intermission")
	{
		return 0;
	}
	if(isdefined(player.intermission) && player.intermission)
	{
		return 0;
	}
	if(!(isdefined(ignore_laststand_players) && ignore_laststand_players))
	{
		if(player laststand::player_is_in_laststand())
		{
			return 0;
		}
	}
	if(player isnotarget())
	{
		return 0;
	}
	if(isdefined(checkignoremeflag) && checkignoremeflag && player.ignoreme)
	{
		return 0;
	}
	if(isdefined(level.is_player_valid_override))
	{
		return [[level.is_player_valid_override]](player);
	}
	return 1;
}

/*
	Name: append_missing_legs_suffix
	Namespace: zombie_utility
	Checksum: 0x4169AD05
	Offset: 0xCB8
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function append_missing_legs_suffix(animstate)
{
	if(self.missinglegs && self hasanimstatefromasd(animstate + "_crawl"))
	{
		return animstate + "_crawl";
	}
	return animstate;
}

/*
	Name: initanimtree
	Namespace: zombie_utility
	Checksum: 0xA97FCBDD
	Offset: 0xD10
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function initanimtree(animscript)
{
	if(animscript != "pain" && animscript != "death")
	{
		self.a.special = "none";
	}
	/#
		assert(isdefined(animscript), "");
	#/
	self.a.script = animscript;
}

/*
	Name: updateanimpose
	Namespace: zombie_utility
	Checksum: 0x4F1FB2EF
	Offset: 0xD98
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function updateanimpose()
{
	/#
		assert(self.a.movement == "" || self.a.movement == "" || self.a.movement == "", (("" + self.a.pose) + "") + self.a.movement);
	#/
	self.desired_anim_pose = undefined;
}

/*
	Name: initialize
	Namespace: zombie_utility
	Checksum: 0x4DFD7A80
	Offset: 0xE48
	Size: 0x214
	Parameters: 1
	Flags: None
*/
function initialize(animscript)
{
	if(isdefined(self.longdeathstarting))
	{
		if(animscript != "pain" && animscript != "death")
		{
			self dodamage(self.health + 100, self.origin);
		}
		if(animscript != "pain")
		{
			self.longdeathstarting = undefined;
			self notify(#"kill_long_death");
		}
	}
	if(isdefined(self.a.mayonlydie) && animscript != "death")
	{
		self dodamage(self.health + 100, self.origin);
	}
	if(isdefined(self.a.postscriptfunc))
	{
		scriptfunc = self.a.postscriptfunc;
		self.a.postscriptfunc = undefined;
		[[scriptfunc]](animscript);
	}
	if(animscript != "death")
	{
		self.a.nodeath = 0;
	}
	self.isholdinggrenade = undefined;
	self.covernode = undefined;
	self.changingcoverpos = 0;
	self.a.scriptstarttime = gettime();
	self.a.atconcealmentnode = 0;
	if(isdefined(self.node) && (self.node.type == "Conceal Crouch" || self.node.type == "Conceal Stand"))
	{
		self.a.atconcealmentnode = 1;
	}
	initanimtree(animscript);
	updateanimpose();
}

/*
	Name: getnodeyawtoorigin
	Namespace: zombie_utility
	Checksum: 0x40933A12
	Offset: 0x1068
	Size: 0xA4
	Parameters: 1
	Flags: None
*/
function getnodeyawtoorigin(pos)
{
	if(isdefined(self.node))
	{
		yaw = self.node.angles[1] - getyaw(pos);
	}
	else
	{
		yaw = self.angles[1] - getyaw(pos);
	}
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: getnodeyawtoenemy
	Namespace: zombie_utility
	Checksum: 0x46671FF6
	Offset: 0x1118
	Size: 0x15C
	Parameters: 0
	Flags: None
*/
function getnodeyawtoenemy()
{
	pos = undefined;
	if(isvalidenemy(self.enemy))
	{
		pos = self.enemy.origin;
	}
	else
	{
		if(isdefined(self.node))
		{
			forward = anglestoforward(self.node.angles);
		}
		else
		{
			forward = anglestoforward(self.angles);
		}
		forward = vectorscale(forward, 150);
		pos = self.origin + forward;
	}
	if(isdefined(self.node))
	{
		yaw = self.node.angles[1] - getyaw(pos);
	}
	else
	{
		yaw = self.angles[1] - getyaw(pos);
	}
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: getcovernodeyawtoenemy
	Namespace: zombie_utility
	Checksum: 0xBC46F941
	Offset: 0x1280
	Size: 0x144
	Parameters: 0
	Flags: None
*/
function getcovernodeyawtoenemy()
{
	pos = undefined;
	if(isvalidenemy(self.enemy))
	{
		pos = self.enemy.origin;
	}
	else
	{
		forward = anglestoforward(self.covernode.angles + self.animarray["angle_step_out"][self.a.cornermode]);
		forward = vectorscale(forward, 150);
		pos = self.origin + forward;
	}
	yaw = (self.covernode.angles[1] + self.animarray["angle_step_out"][self.a.cornermode]) - getyaw(pos);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: getyawtospot
	Namespace: zombie_utility
	Checksum: 0xBA0E7779
	Offset: 0x13D0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function getyawtospot(spot)
{
	pos = spot;
	yaw = self.angles[1] - getyaw(pos);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: getyawtoenemy
	Namespace: zombie_utility
	Checksum: 0x39F9E1F6
	Offset: 0x1450
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function getyawtoenemy()
{
	pos = undefined;
	if(isvalidenemy(self.enemy))
	{
		pos = self.enemy.origin;
	}
	else
	{
		forward = anglestoforward(self.angles);
		forward = vectorscale(forward, 150);
		pos = self.origin + forward;
	}
	yaw = self.angles[1] - getyaw(pos);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: getyaw
	Namespace: zombie_utility
	Checksum: 0xD2926167
	Offset: 0x1540
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function getyaw(org)
{
	angles = vectortoangles(org - self.origin);
	return angles[1];
}

/*
	Name: getyaw2d
	Namespace: zombie_utility
	Checksum: 0x7EC814E7
	Offset: 0x1590
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function getyaw2d(org)
{
	angles = vectortoangles((org[0], org[1], 0) - (self.origin[0], self.origin[1], 0));
	return angles[1];
}

/*
	Name: absyawtoenemy
	Namespace: zombie_utility
	Checksum: 0x91006C28
	Offset: 0x1608
	Size: 0xB0
	Parameters: 0
	Flags: None
*/
function absyawtoenemy()
{
	/#
		assert(isvalidenemy(self.enemy));
	#/
	yaw = self.angles[1] - getyaw(self.enemy.origin);
	yaw = angleclamp180(yaw);
	if(yaw < 0)
	{
		yaw = -1 * yaw;
	}
	return yaw;
}

/*
	Name: absyawtoenemy2d
	Namespace: zombie_utility
	Checksum: 0x296B2BAD
	Offset: 0x16C0
	Size: 0xB0
	Parameters: 0
	Flags: None
*/
function absyawtoenemy2d()
{
	/#
		assert(isvalidenemy(self.enemy));
	#/
	yaw = self.angles[1] - getyaw2d(self.enemy.origin);
	yaw = angleclamp180(yaw);
	if(yaw < 0)
	{
		yaw = -1 * yaw;
	}
	return yaw;
}

/*
	Name: absyawtoorigin
	Namespace: zombie_utility
	Checksum: 0x626B22A4
	Offset: 0x1778
	Size: 0x78
	Parameters: 1
	Flags: None
*/
function absyawtoorigin(org)
{
	yaw = self.angles[1] - getyaw(org);
	yaw = angleclamp180(yaw);
	if(yaw < 0)
	{
		yaw = -1 * yaw;
	}
	return yaw;
}

/*
	Name: absyawtoangles
	Namespace: zombie_utility
	Checksum: 0x158B181E
	Offset: 0x17F8
	Size: 0x68
	Parameters: 1
	Flags: None
*/
function absyawtoangles(angles)
{
	yaw = self.angles[1] - angles;
	yaw = angleclamp180(yaw);
	if(yaw < 0)
	{
		yaw = -1 * yaw;
	}
	return yaw;
}

/*
	Name: getyawfromorigin
	Namespace: zombie_utility
	Checksum: 0x74DD03DB
	Offset: 0x1868
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function getyawfromorigin(org, start)
{
	angles = vectortoangles(org - start);
	return angles[1];
}

/*
	Name: getyawtotag
	Namespace: zombie_utility
	Checksum: 0x553C0875
	Offset: 0x18C0
	Size: 0x8C
	Parameters: 2
	Flags: None
*/
function getyawtotag(tag, org)
{
	yaw = self gettagangles(tag)[1] - getyawfromorigin(org, self gettagorigin(tag));
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: getyawtoorigin
	Namespace: zombie_utility
	Checksum: 0xDEAA4F52
	Offset: 0x1958
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function getyawtoorigin(org)
{
	yaw = self.angles[1] - getyaw(org);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: geteyeyawtoorigin
	Namespace: zombie_utility
	Checksum: 0x273F7FDC
	Offset: 0x19C0
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function geteyeyawtoorigin(org)
{
	yaw = self gettagangles("TAG_EYE")[1] - getyaw(org);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: getcovernodeyawtoorigin
	Namespace: zombie_utility
	Checksum: 0xB3C45013
	Offset: 0x1A40
	Size: 0x8C
	Parameters: 1
	Flags: None
*/
function getcovernodeyawtoorigin(org)
{
	yaw = (self.covernode.angles[1] + self.animarray["angle_step_out"][self.a.cornermode]) - getyaw(org);
	yaw = angleclamp180(yaw);
	return yaw;
}

/*
	Name: isstanceallowedwrapper
	Namespace: zombie_utility
	Checksum: 0xF6AE4FB6
	Offset: 0x1AD8
	Size: 0x4A
	Parameters: 1
	Flags: None
*/
function isstanceallowedwrapper(stance)
{
	if(isdefined(self.covernode))
	{
		return self.covernode doesnodeallowstance(stance);
	}
	return self isstanceallowed(stance);
}

/*
	Name: getclaimednode
	Namespace: zombie_utility
	Checksum: 0x767B0B2
	Offset: 0x1B30
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function getclaimednode()
{
	mynode = self.node;
	if(isdefined(mynode) && (self nearnode(mynode) || (isdefined(self.covernode) && mynode == self.covernode)))
	{
		return mynode;
	}
	return undefined;
}

/*
	Name: getnodetype
	Namespace: zombie_utility
	Checksum: 0x5BE591D9
	Offset: 0x1BA0
	Size: 0x3E
	Parameters: 0
	Flags: None
*/
function getnodetype()
{
	mynode = getclaimednode();
	if(isdefined(mynode))
	{
		return mynode.type;
	}
	return "none";
}

/*
	Name: getnodedirection
	Namespace: zombie_utility
	Checksum: 0x31AB9B92
	Offset: 0x1BE8
	Size: 0x46
	Parameters: 0
	Flags: None
*/
function getnodedirection()
{
	mynode = getclaimednode();
	if(isdefined(mynode))
	{
		return mynode.angles[1];
	}
	return self.desiredangle;
}

/*
	Name: getnodeforward
	Namespace: zombie_utility
	Checksum: 0x4628D046
	Offset: 0x1C38
	Size: 0x62
	Parameters: 0
	Flags: None
*/
function getnodeforward()
{
	mynode = getclaimednode();
	if(isdefined(mynode))
	{
		return anglestoforward(mynode.angles);
	}
	return anglestoforward(self.angles);
}

/*
	Name: getnodeorigin
	Namespace: zombie_utility
	Checksum: 0x90526271
	Offset: 0x1CA8
	Size: 0x3E
	Parameters: 0
	Flags: None
*/
function getnodeorigin()
{
	mynode = getclaimednode();
	if(isdefined(mynode))
	{
		return mynode.origin;
	}
	return self.origin;
}

/*
	Name: safemod
	Namespace: zombie_utility
	Checksum: 0x3AE2699
	Offset: 0x1CF0
	Size: 0x58
	Parameters: 2
	Flags: None
*/
function safemod(a, b)
{
	result = int(a) % b;
	result = result + b;
	return result % b;
}

/*
	Name: angleclamp
	Namespace: zombie_utility
	Checksum: 0xFB967858
	Offset: 0x1D50
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function angleclamp(angle)
{
	anglefrac = angle / 360;
	angle = (anglefrac - floor(anglefrac)) * 360;
	return angle;
}

/*
	Name: quadrantanimweights
	Namespace: zombie_utility
	Checksum: 0x1B8B7754
	Offset: 0x1DB0
	Size: 0x266
	Parameters: 1
	Flags: None
*/
function quadrantanimweights(yaw)
{
	forwardweight = (90 - abs(yaw)) / 90;
	leftweight = (90 - (absangleclamp180(abs(yaw - 90)))) / 90;
	result["front"] = 0;
	result["right"] = 0;
	result["back"] = 0;
	result["left"] = 0;
	if(isdefined(self.alwaysrunforward))
	{
		/#
			assert(self.alwaysrunforward);
		#/
		result["front"] = 1;
		return result;
	}
	useleans = getdvarint("ai_useLeanRunAnimations");
	if(forwardweight > 0)
	{
		result["front"] = forwardweight;
		if(leftweight > 0)
		{
			result["left"] = leftweight;
		}
		else
		{
			result["right"] = -1 * leftweight;
		}
	}
	else
	{
		if(useleans)
		{
			result["back"] = -1 * forwardweight;
			if(leftweight > 0)
			{
				result["left"] = leftweight;
			}
			else
			{
				result["right"] = -1 * leftweight;
			}
		}
		else
		{
			backweight = -1 * forwardweight;
			if(leftweight > backweight)
			{
				result["left"] = 1;
			}
			else
			{
				if(leftweight < forwardweight)
				{
					result["right"] = 1;
				}
				else
				{
					result["back"] = 1;
				}
			}
		}
	}
	return result;
}

/*
	Name: getquadrant
	Namespace: zombie_utility
	Checksum: 0x2E9EEC92
	Offset: 0x2020
	Size: 0xAC
	Parameters: 1
	Flags: None
*/
function getquadrant(angle)
{
	angle = angleclamp(angle);
	if(angle < 45 || angle > 315)
	{
		quadrant = "front";
	}
	else
	{
		if(angle < 135)
		{
			quadrant = "left";
		}
		else
		{
			if(angle < 225)
			{
				quadrant = "back";
			}
			else
			{
				quadrant = "right";
			}
		}
	}
	return quadrant;
}

/*
	Name: isinset
	Namespace: zombie_utility
	Checksum: 0x78A05E0E
	Offset: 0x20D8
	Size: 0x60
	Parameters: 2
	Flags: None
*/
function isinset(input, set)
{
	for(i = set.size - 1; i >= 0; i--)
	{
		if(input == set[i])
		{
			return true;
		}
	}
	return false;
}

/*
	Name: notifyaftertime
	Namespace: zombie_utility
	Checksum: 0xE063B167
	Offset: 0x2140
	Size: 0x3E
	Parameters: 3
	Flags: None
*/
function notifyaftertime(notifystring, killmestring, time)
{
	self endon(#"death");
	self endon(killmestring);
	wait(time);
	self notify(notifystring);
}

/*
	Name: drawstringtime
	Namespace: zombie_utility
	Checksum: 0x2756DD78
	Offset: 0x2188
	Size: 0x96
	Parameters: 4
	Flags: None
*/
function drawstringtime(msg, org, color, timer)
{
	/#
		maxtime = timer * 20;
		for(i = 0; i < maxtime; i++)
		{
			print3d(org, msg, color, 1, 1);
			wait(0.05);
		}
	#/
}

/*
	Name: showlastenemysightpos
	Namespace: zombie_utility
	Checksum: 0x82B288BB
	Offset: 0x2228
	Size: 0x100
	Parameters: 1
	Flags: None
*/
function showlastenemysightpos(string)
{
	/#
		self notify(#"hash_a5fb63c6");
		self endon(#"hash_a5fb63c6");
		self endon(#"death");
		if(!isvalidenemy(self.enemy))
		{
			return;
		}
		if(self.enemy.team == "")
		{
			color = (0.4, 0.7, 1);
		}
		else
		{
			color = (1, 0.7, 0.4);
		}
		while(true)
		{
			wait(0.05);
			if(!isdefined(self.lastenemysightpos))
			{
				continue;
			}
			print3d(self.lastenemysightpos, string, color, 1, 2.15);
		}
	#/
}

/*
	Name: debugtimeout
	Namespace: zombie_utility
	Checksum: 0xC4E4F278
	Offset: 0x2330
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function debugtimeout()
{
	wait(5);
	self notify(#"timeout");
}

/*
	Name: debugposinternal
	Namespace: zombie_utility
	Checksum: 0xA52B3DA9
	Offset: 0x2350
	Size: 0x120
	Parameters: 3
	Flags: Linked
*/
function debugposinternal(org, string, size)
{
	/#
		self endon(#"death");
		self notify("" + org);
		self endon("" + org);
		ent = spawnstruct();
		ent thread debugtimeout();
		ent endon(#"timeout");
		if(self.enemy.team == "")
		{
			color = (0.4, 0.7, 1);
		}
		else
		{
			color = (1, 0.7, 0.4);
		}
		while(true)
		{
			wait(0.05);
			print3d(org, string, color, 1, size);
		}
	#/
}

/*
	Name: debugpos
	Namespace: zombie_utility
	Checksum: 0xA32AA93E
	Offset: 0x2478
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function debugpos(org, string)
{
	thread debugposinternal(org, string, 2.15);
}

/*
	Name: debugpossize
	Namespace: zombie_utility
	Checksum: 0x96BBA678
	Offset: 0x24B8
	Size: 0x3C
	Parameters: 3
	Flags: None
*/
function debugpossize(org, string, size)
{
	thread debugposinternal(org, string, size);
}

/*
	Name: showdebugproc
	Namespace: zombie_utility
	Checksum: 0xDC4373FC
	Offset: 0x2500
	Size: 0xA0
	Parameters: 4
	Flags: Linked
*/
function showdebugproc(frompoint, topoint, color, printtime)
{
	/#
		self endon(#"death");
		timer = printtime * 20;
		i = 0;
		while(i < timer)
		{
			wait(0.05);
			line(frompoint, topoint, color);
			i = i + 1;
		}
	#/
}

/*
	Name: showdebugline
	Namespace: zombie_utility
	Checksum: 0x6D667A80
	Offset: 0x25A8
	Size: 0x5C
	Parameters: 4
	Flags: None
*/
function showdebugline(frompoint, topoint, color, printtime)
{
	self thread showdebugproc(frompoint, topoint + (vectorscale((0, 0, -1), 5)), color, printtime);
}

/*
	Name: getnodeoffset
	Namespace: zombie_utility
	Checksum: 0xCC6799FC
	Offset: 0x2610
	Size: 0x33A
	Parameters: 1
	Flags: None
*/
function getnodeoffset(node)
{
	if(isdefined(node.offset))
	{
		return node.offset;
	}
	cover_left_crouch_offset = (-26, 0.4, 36);
	cover_left_stand_offset = (-32, 7, 63);
	cover_right_crouch_offset = (43.5, 11, 36);
	cover_right_stand_offset = (36, 8.3, 63);
	cover_crouch_offset = (3.5, -12.5, 45);
	cover_stand_offset = (-3.7, -22, 63);
	cornernode = 0;
	nodeoffset = (0, 0, 0);
	right = anglestoright(node.angles);
	forward = anglestoforward(node.angles);
	switch(node.type)
	{
		case "Cover Left":
		case "Cover Left Wide":
		{
			if(node isnodedontstand() && !node isnodedontcrouch())
			{
				nodeoffset = calculatenodeoffset(right, forward, cover_left_crouch_offset);
			}
			else
			{
				nodeoffset = calculatenodeoffset(right, forward, cover_left_stand_offset);
			}
			break;
		}
		case "Cover Right":
		case "Cover Right Wide":
		{
			if(node isnodedontstand() && !node isnodedontcrouch())
			{
				nodeoffset = calculatenodeoffset(right, forward, cover_right_crouch_offset);
			}
			else
			{
				nodeoffset = calculatenodeoffset(right, forward, cover_right_stand_offset);
			}
			break;
		}
		case "Conceal Stand":
		case "Cover Stand":
		case "Turret":
		{
			nodeoffset = calculatenodeoffset(right, forward, cover_stand_offset);
			break;
		}
		case "Conceal Crouch":
		case "Cover Crouch":
		case "Cover Crouch Window":
		{
			nodeoffset = calculatenodeoffset(right, forward, cover_crouch_offset);
			break;
		}
	}
	node.offset = nodeoffset;
	return node.offset;
}

/*
	Name: calculatenodeoffset
	Namespace: zombie_utility
	Checksum: 0x8935161
	Offset: 0x2958
	Size: 0x4E
	Parameters: 3
	Flags: Linked
*/
function calculatenodeoffset(right, forward, baseoffset)
{
	return (vectorscale(right, baseoffset[0]) + vectorscale(forward, baseoffset[1])) + (0, 0, baseoffset[2]);
}

/*
	Name: checkpitchvisibility
	Namespace: zombie_utility
	Checksum: 0x44EFD1D8
	Offset: 0x29B0
	Size: 0xE6
	Parameters: 3
	Flags: None
*/
function checkpitchvisibility(frompoint, topoint, atnode)
{
	pitch = angleclamp180(vectortoangles(topoint - frompoint)[0]);
	if(abs(pitch) > 45)
	{
		if(isdefined(atnode) && atnode.type != "Cover Crouch" && atnode.type != "Conceal Crouch")
		{
			return false;
		}
		if(pitch > 45 || pitch < (anim.covercrouchleanpitch - 45))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: showlines
	Namespace: zombie_utility
	Checksum: 0x45D4391
	Offset: 0x2AA0
	Size: 0x78
	Parameters: 3
	Flags: None
*/
function showlines(start, end, end2)
{
	/#
		for(;;)
		{
			line(start, end, (1, 0, 0), 1);
			wait(0.05);
			line(start, end2, (0, 0, 1), 1);
			wait(0.05);
		}
	#/
}

/*
	Name: anim_array
	Namespace: zombie_utility
	Checksum: 0xA67F333A
	Offset: 0x2B20
	Size: 0x198
	Parameters: 2
	Flags: None
*/
function anim_array(animarray, animweights)
{
	total_anims = animarray.size;
	idleanim = randomint(total_anims);
	/#
		assert(total_anims);
	#/
	/#
		assert(animarray.size == animweights.size);
	#/
	if(total_anims == 1)
	{
		return animarray[0];
	}
	weights = 0;
	total_weight = 0;
	for(i = 0; i < total_anims; i++)
	{
		total_weight = total_weight + animweights[i];
	}
	anim_play = randomfloat(total_weight);
	current_weight = 0;
	for(i = 0; i < total_anims; i++)
	{
		current_weight = current_weight + animweights[i];
		if(anim_play >= current_weight)
		{
			continue;
		}
		idleanim = i;
		break;
	}
	return animarray[idleanim];
}

/*
	Name: notforcedcover
	Namespace: zombie_utility
	Checksum: 0xCF57C382
	Offset: 0x2CC0
	Size: 0x38
	Parameters: 0
	Flags: None
*/
function notforcedcover()
{
	return self.a.forced_cover == "none" || self.a.forced_cover == "Show";
}

/*
	Name: forcedcover
	Namespace: zombie_utility
	Checksum: 0x60BEF587
	Offset: 0x2D00
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function forcedcover(msg)
{
	return isdefined(self.a.forced_cover) && self.a.forced_cover == msg;
}

/*
	Name: print3dtime
	Namespace: zombie_utility
	Checksum: 0xD38243EC
	Offset: 0x2D40
	Size: 0xA6
	Parameters: 6
	Flags: None
*/
function print3dtime(timer, org, msg, color, alpha, scale)
{
	/#
		newtime = timer / 0.05;
		for(i = 0; i < newtime; i++)
		{
			print3d(org, msg, color, alpha, scale);
			wait(0.05);
		}
	#/
}

/*
	Name: print3drise
	Namespace: zombie_utility
	Checksum: 0x762FC8C1
	Offset: 0x2DF0
	Size: 0xD6
	Parameters: 5
	Flags: None
*/
function print3drise(org, msg, color, alpha, scale)
{
	/#
		newtime = 100;
		up = 0;
		org = org;
		for(i = 0; i < newtime; i++)
		{
			up = up + 0.5;
			print3d(org + (0, 0, up), msg, color, alpha, scale);
			wait(0.05);
		}
	#/
}

/*
	Name: crossproduct
	Namespace: zombie_utility
	Checksum: 0x7B09756
	Offset: 0x2ED0
	Size: 0x42
	Parameters: 2
	Flags: None
*/
function crossproduct(vec1, vec2)
{
	return (vec1[0] * vec2[1]) - (vec1[1] * vec2[0]) > 0;
}

/*
	Name: scriptchange
	Namespace: zombie_utility
	Checksum: 0xDB7EC4C7
	Offset: 0x2F20
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function scriptchange()
{
	self.a.current_script = "none";
	self notify(anim.scriptchange);
}

/*
	Name: delayedscriptchange
	Namespace: zombie_utility
	Checksum: 0xF526F987
	Offset: 0x2F58
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function delayedscriptchange()
{
	wait(0.05);
	scriptchange();
}

/*
	Name: sawenemymove
	Namespace: zombie_utility
	Checksum: 0x6CF78475
	Offset: 0x2F80
	Size: 0x32
	Parameters: 1
	Flags: None
*/
function sawenemymove(timer = 500)
{
	return (gettime() - self.personalsighttime) < timer;
}

/*
	Name: canthrowgrenade
	Namespace: zombie_utility
	Checksum: 0xF1397BF3
	Offset: 0x2FC0
	Size: 0x3A
	Parameters: 0
	Flags: None
*/
function canthrowgrenade()
{
	if(!self.grenadeammo)
	{
		return 0;
	}
	if(self.script_forcegrenade)
	{
		return 1;
	}
	return isplayer(self.enemy);
}

/*
	Name: random_weight
	Namespace: zombie_utility
	Checksum: 0x761AA871
	Offset: 0x3008
	Size: 0x110
	Parameters: 1
	Flags: None
*/
function random_weight(array)
{
	idleanim = randomint(array.size);
	if(array.size > 1)
	{
		anim_weight = 0;
		for(i = 0; i < array.size; i++)
		{
			anim_weight = anim_weight + array[i];
		}
		anim_play = randomfloat(anim_weight);
		anim_weight = 0;
		for(i = 0; i < array.size; i++)
		{
			anim_weight = anim_weight + array[i];
			if(anim_play < anim_weight)
			{
				idleanim = i;
				break;
			}
		}
	}
	return idleanim;
}

/*
	Name: setfootstepeffect
	Namespace: zombie_utility
	Checksum: 0x9506E38D
	Offset: 0x3120
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function setfootstepeffect(name, fx)
{
	/#
		assert(isdefined(name), "");
	#/
	/#
		assert(isdefined(fx), "");
	#/
	if(!isdefined(anim.optionalstepeffects))
	{
		anim.optionalstepeffects = [];
	}
	anim.optionalstepeffects[anim.optionalstepeffects.size] = name;
	level._effect["step_" + name] = fx;
	anim.optionalstepeffectfunction = &zombie_shared::playfootstepeffect;
}

/*
	Name: persistentdebugline
	Namespace: zombie_utility
	Checksum: 0x552355F3
	Offset: 0x3200
	Size: 0x78
	Parameters: 2
	Flags: None
*/
function persistentdebugline(start, end)
{
	/#
		self endon(#"death");
		level notify(#"newdebugline");
		level endon(#"newdebugline");
		for(;;)
		{
			line(start, end, (0.3, 1, 0), 1);
			wait(0.05);
		}
	#/
}

/*
	Name: isnodedontstand
	Namespace: zombie_utility
	Checksum: 0x143612E6
	Offset: 0x3280
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function isnodedontstand()
{
	return (self.spawnflags & 4) == 4;
}

/*
	Name: isnodedontcrouch
	Namespace: zombie_utility
	Checksum: 0x2C2E7FFA
	Offset: 0x32A0
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function isnodedontcrouch()
{
	return (self.spawnflags & 8) == 8;
}

/*
	Name: doesnodeallowstance
	Namespace: zombie_utility
	Checksum: 0x421E081F
	Offset: 0x32C0
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function doesnodeallowstance(stance)
{
	if(stance == "stand")
	{
		return !self isnodedontstand();
	}
	/#
		assert(stance == "");
	#/
	return !self isnodedontcrouch();
}

/*
	Name: animarray
	Namespace: zombie_utility
	Checksum: 0x93E9D02A
	Offset: 0x3340
	Size: 0xB8
	Parameters: 1
	Flags: None
*/
function animarray(animname)
{
	/#
		assert(isdefined(self.a.array));
	#/
	/#
		if(!isdefined(self.a.array[animname]))
		{
			dumpanimarray();
			/#
				assert(isdefined(self.a.array[animname]), ("" + animname) + "");
			#/
		}
	#/
	return self.a.array[animname];
}

/*
	Name: animarrayanyexist
	Namespace: zombie_utility
	Checksum: 0x254F2535
	Offset: 0x3400
	Size: 0xBE
	Parameters: 1
	Flags: None
*/
function animarrayanyexist(animname)
{
	/#
		assert(isdefined(self.a.array));
	#/
	/#
		if(!isdefined(self.a.array[animname]))
		{
			dumpanimarray();
			/#
				assert(isdefined(self.a.array[animname]), ("" + animname) + "");
			#/
		}
	#/
	return self.a.array[animname].size > 0;
}

/*
	Name: animarraypickrandom
	Namespace: zombie_utility
	Checksum: 0xA9064623
	Offset: 0x34C8
	Size: 0x14E
	Parameters: 1
	Flags: None
*/
function animarraypickrandom(animname)
{
	/#
		assert(isdefined(self.a.array));
	#/
	/#
		if(!isdefined(self.a.array[animname]))
		{
			dumpanimarray();
			/#
				assert(isdefined(self.a.array[animname]), ("" + animname) + "");
			#/
		}
	#/
	/#
		assert(self.a.array[animname].size > 0);
	#/
	if(self.a.array[animname].size > 1)
	{
		index = randomint(self.a.array[animname].size);
	}
	else
	{
		index = 0;
	}
	return self.a.array[animname][index];
}

/*
	Name: dumpanimarray
	Namespace: zombie_utility
	Checksum: 0x8E04679C
	Offset: 0x3620
	Size: 0x14E
	Parameters: 0
	Flags: Linked
*/
function dumpanimarray()
{
	/#
		println("");
		keys = getarraykeys(self.a.array);
		for(i = 0; i < keys.size; i++)
		{
			if(isarray(self.a.array[keys[i]]))
			{
				println(((("" + keys[i]) + "") + self.a.array[keys[i]].size) + "");
				continue;
			}
			println(("" + keys[i]) + "", self.a.array[keys[i]]);
		}
	#/
}

/*
	Name: getanimendpos
	Namespace: zombie_utility
	Checksum: 0xAF180F87
	Offset: 0x3778
	Size: 0x52
	Parameters: 1
	Flags: None
*/
function getanimendpos(theanim)
{
	movedelta = getmovedelta(theanim, 0, 1, self);
	return self localtoworldcoords(movedelta);
}

/*
	Name: isvalidenemy
	Namespace: zombie_utility
	Checksum: 0x1E99411E
	Offset: 0x37D8
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function isvalidenemy(enemy)
{
	if(!isdefined(enemy))
	{
		return false;
	}
	return true;
}

/*
	Name: damagelocationisany
	Namespace: zombie_utility
	Checksum: 0xCA1CE13C
	Offset: 0x3800
	Size: 0x226
	Parameters: 12
	Flags: Linked
*/
function damagelocationisany(a, b, c, d, e, f, g, h, i, j, k, ovr)
{
	if(!isdefined(self.damagelocation))
	{
		return false;
	}
	if(!isdefined(a))
	{
		return false;
	}
	if(self.damagelocation == a)
	{
		return true;
	}
	if(!isdefined(b))
	{
		return false;
	}
	if(self.damagelocation == b)
	{
		return true;
	}
	if(!isdefined(c))
	{
		return false;
	}
	if(self.damagelocation == c)
	{
		return true;
	}
	if(!isdefined(d))
	{
		return false;
	}
	if(self.damagelocation == d)
	{
		return true;
	}
	if(!isdefined(e))
	{
		return false;
	}
	if(self.damagelocation == e)
	{
		return true;
	}
	if(!isdefined(f))
	{
		return false;
	}
	if(self.damagelocation == f)
	{
		return true;
	}
	if(!isdefined(g))
	{
		return false;
	}
	if(self.damagelocation == g)
	{
		return true;
	}
	if(!isdefined(h))
	{
		return false;
	}
	if(self.damagelocation == h)
	{
		return true;
	}
	if(!isdefined(i))
	{
		return false;
	}
	if(self.damagelocation == i)
	{
		return true;
	}
	if(!isdefined(j))
	{
		return false;
	}
	if(self.damagelocation == j)
	{
		return true;
	}
	if(!isdefined(k))
	{
		return false;
	}
	if(self.damagelocation == k)
	{
		return true;
	}
	/#
		assert(!isdefined(ovr));
	#/
	return false;
}

/*
	Name: ragdolldeath
	Namespace: zombie_utility
	Checksum: 0x34A3AD80
	Offset: 0x3A30
	Size: 0xF8
	Parameters: 1
	Flags: None
*/
function ragdolldeath(moveanim)
{
	self endon(#"killanimscript");
	lastorg = self.origin;
	movevec = (0, 0, 0);
	for(;;)
	{
		wait(0.05);
		force = distance(self.origin, lastorg);
		lastorg = self.origin;
		if(self.health == 1)
		{
			self.a.nodeath = 1;
			self startragdoll();
			wait(0.05);
			physicsexplosionsphere(lastorg, 600, 0, force * 0.1);
			self notify(#"killanimscript");
			return;
		}
	}
}

/*
	Name: iscqbwalking
	Namespace: zombie_utility
	Checksum: 0x8B67D632
	Offset: 0x3B30
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function iscqbwalking()
{
	return isdefined(self.cqbwalking) && self.cqbwalking;
}

/*
	Name: squared
	Namespace: zombie_utility
	Checksum: 0x4056DF3
	Offset: 0x3B50
	Size: 0x16
	Parameters: 1
	Flags: None
*/
function squared(value)
{
	return value * value;
}

/*
	Name: randomizeidleset
	Namespace: zombie_utility
	Checksum: 0x2CFC6F7C
	Offset: 0x3B70
	Size: 0x2C
	Parameters: 0
	Flags: None
*/
function randomizeidleset()
{
	self.a.idleset = randomint(2);
}

/*
	Name: getrandomintfromseed
	Namespace: zombie_utility
	Checksum: 0x6A8584FD
	Offset: 0x3BA8
	Size: 0x66
	Parameters: 2
	Flags: None
*/
function getrandomintfromseed(intseed, intmax)
{
	/#
		assert(intmax > 0);
	#/
	index = intseed % anim.randominttablesize;
	return anim.randominttable[index] % intmax;
}

/*
	Name: is_banzai
	Namespace: zombie_utility
	Checksum: 0x17A77267
	Offset: 0x3C18
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function is_banzai()
{
	return isdefined(self.banzai) && self.banzai;
}

/*
	Name: is_heavy_machine_gun
	Namespace: zombie_utility
	Checksum: 0xB9912D43
	Offset: 0x3C38
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function is_heavy_machine_gun()
{
	return isdefined(self.heavy_machine_gunner) && self.heavy_machine_gunner;
}

/*
	Name: is_zombie
	Namespace: zombie_utility
	Checksum: 0x9698D414
	Offset: 0x3C58
	Size: 0x22
	Parameters: 0
	Flags: None
*/
function is_zombie()
{
	if(isdefined(self.is_zombie) && self.is_zombie)
	{
		return true;
	}
	return false;
}

/*
	Name: is_civilian
	Namespace: zombie_utility
	Checksum: 0xEE783B6F
	Offset: 0x3C88
	Size: 0x22
	Parameters: 0
	Flags: None
*/
function is_civilian()
{
	if(isdefined(self.is_civilian) && self.is_civilian)
	{
		return true;
	}
	return false;
}

/*
	Name: is_skeleton
	Namespace: zombie_utility
	Checksum: 0x14ECE863
	Offset: 0x3CB8
	Size: 0x68
	Parameters: 1
	Flags: None
*/
function is_skeleton(skeleton)
{
	if(skeleton == "base" && issubstr(get_skeleton(), "scaled"))
	{
		return 1;
	}
	return get_skeleton() == skeleton;
}

/*
	Name: get_skeleton
	Namespace: zombie_utility
	Checksum: 0xC4CC3F44
	Offset: 0x3D28
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function get_skeleton()
{
	if(isdefined(self.skeleton))
	{
		return self.skeleton;
	}
	return "base";
}

/*
	Name: set_orient_mode
	Namespace: zombie_utility
	Checksum: 0xE1B5945
	Offset: 0x3D58
	Size: 0xF4
	Parameters: 2
	Flags: None
*/
function set_orient_mode(mode, val1)
{
	/#
		if(level.dog_debug_orient == self getentnum())
		{
			if(isdefined(val1))
			{
				println((((("" + mode) + "") + val1) + "") + gettime());
			}
			else
			{
				println((("" + mode) + "") + gettime());
			}
		}
	#/
	if(isdefined(val1))
	{
		self orientmode(mode, val1);
	}
	else
	{
		self orientmode(mode);
	}
}

/*
	Name: debug_anim_print
	Namespace: zombie_utility
	Checksum: 0x288A36A5
	Offset: 0x3E58
	Size: 0x9C
	Parameters: 1
	Flags: None
*/
function debug_anim_print(text)
{
	/#
		if(isdefined(level.dog_debug_anims) && level.dog_debug_anims)
		{
			println((text + "") + gettime());
		}
		if(isdefined(level.dog_debug_anims_ent) && level.dog_debug_anims_ent == self getentnum())
		{
			println((text + "") + gettime());
		}
	#/
}

/*
	Name: debug_turn_print
	Namespace: zombie_utility
	Checksum: 0xA4B466E9
	Offset: 0x3F00
	Size: 0x194
	Parameters: 2
	Flags: None
*/
function debug_turn_print(text, line)
{
	/#
		if(isdefined(level.dog_debug_turns) && level.dog_debug_turns == self getentnum())
		{
			duration = 200;
			currentyawcolor = (1, 1, 1);
			lookaheadyawcolor = (1, 0, 0);
			desiredyawcolor = (1, 1, 0);
			currentyaw = angleclamp180(self.angles[1]);
			desiredyaw = angleclamp180(self.desiredangle);
			lookaheaddir = self.lookaheaddir;
			lookaheadangles = vectortoangles(lookaheaddir);
			lookaheadyaw = angleclamp180(lookaheadangles[1]);
			println(((((((text + "") + gettime() + "") + currentyaw) + "") + lookaheadyaw) + "") + desiredyaw);
		}
	#/
}

/*
	Name: debug_allow_combat
	Namespace: zombie_utility
	Checksum: 0x5E9098AB
	Offset: 0x40A0
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function debug_allow_combat()
{
	/#
		return anim_get_dvar_int("", "");
	#/
}

/*
	Name: debug_allow_movement
	Namespace: zombie_utility
	Checksum: 0x1E00FA8F
	Offset: 0x40D8
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function debug_allow_movement()
{
	/#
		return anim_get_dvar_int("", "");
	#/
}

/*
	Name: set_zombie_var
	Namespace: zombie_utility
	Checksum: 0x5E3BE6F9
	Offset: 0x4110
	Size: 0x14E
	Parameters: 5
	Flags: Linked
*/
function set_zombie_var(zvar, value, is_float = 0, column = 1, is_team_based = 0)
{
	if(!isdefined(level.zombie_vars))
	{
		level.zombie_vars = [];
	}
	if(is_team_based)
	{
		foreach(team in level.teams)
		{
			if(!isdefined(level.zombie_vars[team]))
			{
				level.zombie_vars[team] = [];
			}
			level.zombie_vars[team][zvar] = value;
		}
	}
	else
	{
		level.zombie_vars[zvar] = value;
	}
	return value;
}

/*
	Name: spawn_zombie
	Namespace: zombie_utility
	Checksum: 0xDE68798F
	Offset: 0x4268
	Size: 0x36E
	Parameters: 4
	Flags: Linked
*/
function spawn_zombie(spawner, target_name, spawn_point, round_number)
{
	if(!isdefined(spawner))
	{
		/#
			println("");
		#/
		return undefined;
	}
	while(getfreeactorcount() < 1)
	{
		wait(0.05);
	}
	spawner.script_moveoverride = 1;
	if(isdefined(spawner.script_forcespawn) && spawner.script_forcespawn)
	{
		if(sessionmodeiscampaignzombiesgame())
		{
			guy = spawner spawner::spawn(1);
		}
		else
		{
			if(isactorspawner(spawner) && isdefined(level.overridezombiespawn))
			{
				guy = [[level.overridezombiespawn]]();
			}
			else
			{
				guy = spawner spawnfromspawner(0, 1);
			}
		}
		if(!zombie_spawn_failed(guy))
		{
			guy.spawn_time = gettime();
			if(isdefined(level.giveextrazombies))
			{
				guy [[level.giveextrazombies]]();
			}
			guy enableaimassist();
			if(isdefined(round_number))
			{
				guy._starting_round_number = round_number;
			}
			guy.team = level.zombie_team;
			if(isactor(guy))
			{
				guy clearentityowner();
			}
			level.zombiemeleeplayercounter = 0;
			if(isactor(guy))
			{
				guy forceteleport(spawner.origin);
			}
			guy show();
			spawner.count = 666;
			if(isdefined(target_name))
			{
				guy.targetname = target_name;
			}
			if(isdefined(spawn_point) && isdefined(level.move_spawn_func))
			{
				guy thread [[level.move_spawn_func]](spawn_point);
			}
			/#
				if(isdefined(spawner.zm_variant_type))
				{
					guy.variant_type = spawner.zm_variant_type;
				}
			#/
			return guy;
		}
		/#
			println("", spawner.origin);
		#/
		return undefined;
	}
	/#
		println("", spawner.origin);
	#/
	return undefined;
}

/*
	Name: zombie_spawn_failed
	Namespace: zombie_utility
	Checksum: 0x53195F75
	Offset: 0x45E8
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function zombie_spawn_failed(spawn)
{
	if(isdefined(spawn) && isalive(spawn))
	{
		if(isalive(spawn))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: get_desired_origin
	Namespace: zombie_utility
	Checksum: 0x6A7F14C4
	Offset: 0x4640
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function get_desired_origin()
{
	if(isdefined(self.target))
	{
		ent = getent(self.target, "targetname");
		if(!isdefined(ent))
		{
			ent = struct::get(self.target, "targetname");
		}
		if(!isdefined(ent))
		{
			ent = getnode(self.target, "targetname");
		}
		/#
			assert(isdefined(ent), (("" + self.target) + "") + self.origin);
		#/
		return ent.origin;
	}
	return undefined;
}

/*
	Name: hide_pop
	Namespace: zombie_utility
	Checksum: 0x472329F3
	Offset: 0x4738
	Size: 0x70
	Parameters: 0
	Flags: Linked
*/
function hide_pop()
{
	self endon(#"death");
	self ghost();
	wait(0.5);
	if(isdefined(self))
	{
		self show();
		util::wait_network_frame();
		if(isdefined(self))
		{
			self.create_eyes = 1;
		}
	}
}

/*
	Name: handle_rise_notetracks
	Namespace: zombie_utility
	Checksum: 0x5CFC9630
	Offset: 0x47B0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function handle_rise_notetracks(note, spot)
{
	self thread finish_rise_notetracks(note, spot);
}

/*
	Name: finish_rise_notetracks
	Namespace: zombie_utility
	Checksum: 0xECC86D9B
	Offset: 0x47F0
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function finish_rise_notetracks(note, spot)
{
	if(note == "deathout" || note == "deathhigh")
	{
		self.zombie_rise_death_out = 1;
		self notify(#"zombie_rise_death_out");
		wait(2);
		spot notify(#"stop_zombie_rise_fx");
	}
}

/*
	Name: zombie_rise_death
	Namespace: zombie_utility
	Checksum: 0xBCF13E9
	Offset: 0x4860
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function zombie_rise_death(zombie, spot)
{
	zombie.zombie_rise_death_out = 0;
	zombie endon(#"rise_anim_finished");
	while(isdefined(zombie) && isdefined(zombie.health) && zombie.health > 1)
	{
		zombie waittill(#"damage", amount);
	}
	if(isdefined(spot))
	{
		spot notify(#"stop_zombie_rise_fx");
	}
	if(isdefined(zombie))
	{
		zombie.deathanim = zombie get_rise_death_anim();
		zombie stopanimscripted();
	}
}

/*
	Name: get_rise_death_anim
	Namespace: zombie_utility
	Checksum: 0xCB082283
	Offset: 0x4948
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function get_rise_death_anim()
{
	if(self.zombie_rise_death_out)
	{
		return "zm_rise_death_out";
	}
	self.noragdoll = 1;
	self.nodeathragdoll = 1;
	return "zm_rise_death_in";
}

/*
	Name: reset_attack_spot
	Namespace: zombie_utility
	Checksum: 0x2FAD8C84
	Offset: 0x4988
	Size: 0x5E
	Parameters: 0
	Flags: Linked
*/
function reset_attack_spot()
{
	if(isdefined(self.attacking_node))
	{
		node = self.attacking_node;
		index = self.attacking_spot_index;
		node.attack_spots_taken[index] = 0;
		self.attacking_node = undefined;
		self.attacking_spot_index = undefined;
	}
}

/*
	Name: zombie_gut_explosion
	Namespace: zombie_utility
	Checksum: 0x5995F8FB
	Offset: 0x49F0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function zombie_gut_explosion()
{
	self.guts_explosion = 1;
	gibserverutils::annihilate(self);
}

/*
	Name: delayed_zombie_eye_glow
	Namespace: zombie_utility
	Checksum: 0x49741C37
	Offset: 0x4A20
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function delayed_zombie_eye_glow()
{
	self endon(#"zombie_delete");
	self endon(#"death");
	if(isdefined(self.in_the_ground) && self.in_the_ground || (isdefined(self.in_the_ceiling) && self.in_the_ceiling))
	{
		while(!isdefined(self.create_eyes))
		{
			wait(0.1);
		}
	}
	else
	{
		wait(0.5);
	}
	self zombie_eye_glow();
}

/*
	Name: zombie_eye_glow
	Namespace: zombie_utility
	Checksum: 0xF1DC83D2
	Offset: 0x4AB0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function zombie_eye_glow()
{
	if(!isdefined(self) || !isactor(self))
	{
		return;
	}
	if(!isdefined(self.no_eye_glow) || !self.no_eye_glow)
	{
		self clientfield::set("zombie_has_eyes", 1);
	}
}

/*
	Name: zombie_eye_glow_stop
	Namespace: zombie_utility
	Checksum: 0x54EF903F
	Offset: 0x4B28
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function zombie_eye_glow_stop()
{
	if(!isdefined(self) || !isactor(self))
	{
		return;
	}
	if(!isdefined(self.no_eye_glow) || !self.no_eye_glow)
	{
		self clientfield::set("zombie_has_eyes", 0);
	}
}

/*
	Name: round_spawn_failsafe_debug_draw
	Namespace: zombie_utility
	Checksum: 0x7A6832ED
	Offset: 0x4B98
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function round_spawn_failsafe_debug_draw()
{
	self endon(#"death");
	prevorigin = self.origin;
	while(true)
	{
		if(isdefined(level.toggle_keyline_always) && level.toggle_keyline_always)
		{
			self clientfield::set("zombie_keyline_render", 1);
			wait(1);
			continue;
		}
		wait(4);
		if(isdefined(self.lastchunk_destroy_time))
		{
			if((gettime() - self.lastchunk_destroy_time) < 8000)
			{
				continue;
			}
		}
		if(distancesquared(self.origin, prevorigin) < 576)
		{
			self clientfield::set("zombie_keyline_render", 1);
		}
		else
		{
			self clientfield::set("zombie_keyline_render", 0);
		}
		prevorigin = self.origin;
	}
}

/*
	Name: round_spawn_failsafe
	Namespace: zombie_utility
	Checksum: 0x7BB333E6
	Offset: 0x4CB8
	Size: 0x2D8
	Parameters: 0
	Flags: Linked
*/
function round_spawn_failsafe()
{
	self endon(#"death");
	if(isdefined(level.debug_keyline_zombies) && level.debug_keyline_zombies)
	{
		self thread round_spawn_failsafe_debug_draw();
	}
	prevorigin = self.origin;
	while(true)
	{
		if(!level.zombie_vars["zombie_use_failsafe"])
		{
			return;
		}
		if(isdefined(self.ignore_round_spawn_failsafe) && self.ignore_round_spawn_failsafe)
		{
			return;
		}
		if(!isdefined(level.failsafe_waittime))
		{
			level.failsafe_waittime = 30;
		}
		wait(level.failsafe_waittime);
		if(self.missinglegs)
		{
			wait(10);
		}
		if(isdefined(self.is_inert) && self.is_inert)
		{
			continue;
		}
		if(isdefined(self.lastchunk_destroy_time))
		{
			if((gettime() - self.lastchunk_destroy_time) < 8000)
			{
				continue;
			}
		}
		if(self.origin[2] < level.zombie_vars["below_world_check"])
		{
			if(isdefined(level.put_timed_out_zombies_back_in_queue) && level.put_timed_out_zombies_back_in_queue && !level flag::get("special_round") && (!(isdefined(self.isscreecher) && self.isscreecher)))
			{
				level.zombie_total++;
				level.zombie_total_subtract++;
			}
			self dodamage(self.health + 100, (0, 0, 0));
			break;
		}
		if(distancesquared(self.origin, prevorigin) < 576)
		{
			if(isdefined(level.move_failsafe_override))
			{
				self thread [[level.move_failsafe_override]](prevorigin);
			}
			else
			{
				if(isdefined(level.put_timed_out_zombies_back_in_queue) && level.put_timed_out_zombies_back_in_queue && !level flag::get("special_round"))
				{
					if(!self.ignoreall && (!(isdefined(self.nuked) && self.nuked)) && (!(isdefined(self.marked_for_death) && self.marked_for_death)) && (!(isdefined(self.isscreecher) && self.isscreecher)) && !self.missinglegs)
					{
						level.zombie_total++;
						level.zombie_total_subtract++;
					}
				}
				level.zombies_timeout_playspace++;
				self dodamage(self.health + 100, (0, 0, 0));
			}
			break;
		}
		prevorigin = self.origin;
	}
}

/*
	Name: ai_calculate_health
	Namespace: zombie_utility
	Checksum: 0x27390E04
	Offset: 0x4F98
	Size: 0x106
	Parameters: 1
	Flags: Linked
*/
function ai_calculate_health(round_number)
{
	level.zombie_health = level.zombie_vars["zombie_health_start"];
	for(i = 2; i <= round_number; i++)
	{
		if(i >= 10)
		{
			old_health = level.zombie_health;
			level.zombie_health = level.zombie_health + (int(level.zombie_health * level.zombie_vars["zombie_health_increase_multiplier"]));
			if(level.zombie_health < old_health)
			{
				level.zombie_health = old_health;
				return;
			}
			continue;
		}
		level.zombie_health = int(level.zombie_health + level.zombie_vars["zombie_health_increase"]);
	}
}

/*
	Name: default_max_zombie_func
	Namespace: zombie_utility
	Checksum: 0xD1ECA8DD
	Offset: 0x50A8
	Size: 0x17C
	Parameters: 2
	Flags: Linked
*/
function default_max_zombie_func(max_num, n_round)
{
	/#
		count = getdvarint("", -1);
		if(count > -1)
		{
			return count;
		}
	#/
	max = max_num;
	if(n_round < 2)
	{
		max = int(max_num * 0.25);
	}
	else
	{
		if(n_round < 3)
		{
			max = int(max_num * 0.3);
		}
		else
		{
			if(n_round < 4)
			{
				max = int(max_num * 0.5);
			}
			else
			{
				if(n_round < 5)
				{
					max = int(max_num * 0.7);
				}
				else if(n_round < 6)
				{
					max = int(max_num * 0.9);
				}
			}
		}
	}
	return max;
}

/*
	Name: zombie_speed_up
	Namespace: zombie_utility
	Checksum: 0xE5253599
	Offset: 0x5230
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function zombie_speed_up()
{
	if(level.round_number <= 3)
	{
		return;
	}
	level endon(#"intermission");
	level endon(#"end_of_round");
	level endon(#"restart_round");
	level endon(#"kill_round");
	while(level.zombie_total > 4)
	{
		wait(3);
	}
	a_ai_zombies = get_round_enemy_array();
	while(a_ai_zombies.size > 0 || level.zombie_total > 0)
	{
		if(a_ai_zombies.size == 1)
		{
			ai_zombie = a_ai_zombies[0];
			if(isalive(ai_zombie))
			{
				if(isdefined(level.zombie_speed_up))
				{
					ai_zombie thread [[level.zombie_speed_up]]();
				}
				else if(!ai_zombie.zombie_move_speed === "sprint")
				{
					ai_zombie set_zombie_run_cycle("sprint");
					ai_zombie.zombie_move_speed_original = ai_zombie.zombie_move_speed;
				}
			}
		}
		wait(0.5);
		a_ai_zombies = get_round_enemy_array();
	}
}

/*
	Name: get_current_zombie_count
	Namespace: zombie_utility
	Checksum: 0xB303DB9
	Offset: 0x53B8
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function get_current_zombie_count()
{
	enemies = get_round_enemy_array();
	return enemies.size;
}

/*
	Name: get_round_enemy_array
	Namespace: zombie_utility
	Checksum: 0xBE85FF5A
	Offset: 0x53E8
	Size: 0xFE
	Parameters: 0
	Flags: Linked
*/
function get_round_enemy_array()
{
	a_ai_enemies = [];
	a_ai_valid_enemies = [];
	a_ai_enemies = getaiteamarray(level.zombie_team);
	for(i = 0; i < a_ai_enemies.size; i++)
	{
		if(isdefined(a_ai_enemies[i].ignore_enemy_count) && a_ai_enemies[i].ignore_enemy_count)
		{
			continue;
		}
		if(!isdefined(a_ai_valid_enemies))
		{
			a_ai_valid_enemies = [];
		}
		else if(!isarray(a_ai_valid_enemies))
		{
			a_ai_valid_enemies = array(a_ai_valid_enemies);
		}
		a_ai_valid_enemies[a_ai_valid_enemies.size] = a_ai_enemies[i];
	}
	return a_ai_valid_enemies;
}

/*
	Name: get_zombie_array
	Namespace: zombie_utility
	Checksum: 0x4DCC1C4D
	Offset: 0x54F0
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function get_zombie_array()
{
	enemies = [];
	valid_enemies = [];
	enemies = getaispeciesarray(level.zombie_team, "all");
	for(i = 0; i < enemies.size; i++)
	{
		if(enemies[i].archetype == "zombie")
		{
			if(!isdefined(valid_enemies))
			{
				valid_enemies = [];
			}
			else if(!isarray(valid_enemies))
			{
				valid_enemies = array(valid_enemies);
			}
			valid_enemies[valid_enemies.size] = enemies[i];
		}
	}
	return valid_enemies;
}

/*
	Name: set_zombie_run_cycle_override_value
	Namespace: zombie_utility
	Checksum: 0x9C8FF1F7
	Offset: 0x55F0
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function set_zombie_run_cycle_override_value(new_move_speed)
{
	set_zombie_run_cycle(new_move_speed);
	self.zombie_move_speed_override = new_move_speed;
}

/*
	Name: set_zombie_run_cycle_restore_from_override
	Namespace: zombie_utility
	Checksum: 0x7965EF61
	Offset: 0x5628
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function set_zombie_run_cycle_restore_from_override()
{
	str_restore_move_speed = self.zombie_move_speed_restore;
	self.zombie_move_speed_override = undefined;
	set_zombie_run_cycle(str_restore_move_speed);
}

/*
	Name: set_zombie_run_cycle
	Namespace: zombie_utility
	Checksum: 0xBE17265D
	Offset: 0x5670
	Size: 0x28C
	Parameters: 1
	Flags: Linked
*/
function set_zombie_run_cycle(new_move_speed)
{
	if(isdefined(self.zombie_move_speed_override))
	{
		self.zombie_move_speed_restore = new_move_speed;
		return;
	}
	self.zombie_move_speed_original = self.zombie_move_speed;
	if(isdefined(new_move_speed))
	{
		self.zombie_move_speed = new_move_speed;
	}
	else
	{
		if(level.gamedifficulty == 0)
		{
			self set_run_speed_easy();
		}
		else
		{
			self set_run_speed();
		}
	}
	if(isdefined(level.zm_variant_type_max))
	{
		/#
			if(0)
			{
				debug_variant_type = getdvarint("", -1);
				if(debug_variant_type != -1)
				{
					if(debug_variant_type <= level.zm_variant_type_max[self.zombie_move_speed][self.zombie_arms_position])
					{
						self.variant_type = debug_variant_type;
					}
					else
					{
						self.variant_type = level.zm_variant_type_max[self.zombie_move_speed][self.zombie_arms_position] - 1;
					}
				}
				else
				{
					self.variant_type = randomint(level.zm_variant_type_max[self.zombie_move_speed][self.zombie_arms_position]);
				}
			}
		#/
		if(self.archetype === "zombie")
		{
			if(isdefined(self.zm_variant_type_max))
			{
				self.variant_type = randomint(self.zm_variant_type_max[self.zombie_move_speed][self.zombie_arms_position]);
			}
			else
			{
				if(isdefined(level.zm_variant_type_max[self.zombie_move_speed]))
				{
					self.variant_type = randomint(level.zm_variant_type_max[self.zombie_move_speed][self.zombie_arms_position]);
				}
				else
				{
					/#
						errormsg("" + self.zombie_move_speed);
					#/
					self.variant_type = 0;
				}
			}
		}
	}
	self.needs_run_update = 1;
	self notify(#"needs_run_update");
	self.deathanim = self append_missing_legs_suffix("zm_death");
}

/*
	Name: set_run_speed
	Namespace: zombie_utility
	Checksum: 0x9C29ACA9
	Offset: 0x5908
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function set_run_speed()
{
	if(isdefined(level.zombie_force_run))
	{
		self.zombie_move_speed = "run";
		level.zombie_force_run--;
		if(level.zombie_force_run <= 0)
		{
			level.zombie_force_run = undefined;
		}
		return;
	}
	rand = randomintrange(level.zombie_move_speed, level.zombie_move_speed + 35);
	if(rand <= 35)
	{
		self.zombie_move_speed = "walk";
	}
	else
	{
		if(rand <= 70)
		{
			self.zombie_move_speed = "run";
		}
		else
		{
			self.zombie_move_speed = "sprint";
		}
	}
}

/*
	Name: set_run_speed_easy
	Namespace: zombie_utility
	Checksum: 0x65D99E22
	Offset: 0x59D8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function set_run_speed_easy()
{
	rand = randomintrange(level.zombie_move_speed, level.zombie_move_speed + 25);
	if(rand <= 35)
	{
		self.zombie_move_speed = "walk";
	}
	else
	{
		self.zombie_move_speed = "run";
	}
}

/*
	Name: setup_zombie_knockdown
	Namespace: zombie_utility
	Checksum: 0xE7FE41DE
	Offset: 0x5A50
	Size: 0x264
	Parameters: 1
	Flags: None
*/
function setup_zombie_knockdown(entity)
{
	self.knockdown = 1;
	zombie_to_entity = entity.origin - self.origin;
	zombie_to_entity_2d = vectornormalize((zombie_to_entity[0], zombie_to_entity[1], 0));
	zombie_forward = anglestoforward(self.angles);
	zombie_forward_2d = vectornormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = anglestoright(self.angles);
	zombie_right_2d = vectornormalize((zombie_right[0], zombie_right[1], 0));
	dot = vectordot(zombie_to_entity_2d, zombie_forward_2d);
	if(dot >= 0.5)
	{
		self.knockdown_direction = "front";
		self.getup_direction = "getup_back";
	}
	else
	{
		if(dot < 0.5 && dot > -0.5)
		{
			dot = vectordot(zombie_to_entity_2d, zombie_right_2d);
			if(dot > 0)
			{
				self.knockdown_direction = "right";
				if(math::cointoss())
				{
					self.getup_direction = "getup_back";
				}
				else
				{
					self.getup_direction = "getup_belly";
				}
			}
			else
			{
				self.knockdown_direction = "left";
				self.getup_direction = "getup_belly";
			}
		}
		else
		{
			self.knockdown_direction = "back";
			self.getup_direction = "getup_belly";
		}
	}
}

/*
	Name: clear_all_corpses
	Namespace: zombie_utility
	Checksum: 0x9E9B23D4
	Offset: 0x5CC0
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function clear_all_corpses()
{
	corpse_array = getcorpsearray();
	for(i = 0; i < corpse_array.size; i++)
	{
		if(isdefined(corpse_array[i]))
		{
			corpse_array[i] delete();
		}
	}
}

/*
	Name: get_current_actor_count
	Namespace: zombie_utility
	Checksum: 0x51B706A6
	Offset: 0x5D40
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function get_current_actor_count()
{
	count = 0;
	actors = getaispeciesarray(level.zombie_team, "all");
	if(isdefined(actors))
	{
		count = count + actors.size;
	}
	count = count + get_current_corpse_count();
	return count;
}

/*
	Name: get_current_corpse_count
	Namespace: zombie_utility
	Checksum: 0x76A9AC16
	Offset: 0x5DC8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function get_current_corpse_count()
{
	corpse_array = getcorpsearray();
	if(isdefined(corpse_array))
	{
		return corpse_array.size;
	}
	return 0;
}

/*
	Name: zombie_gib_on_damage
	Namespace: zombie_utility
	Checksum: 0xEFE1521D
	Offset: 0x5E08
	Size: 0x4F8
	Parameters: 0
	Flags: Linked
*/
function zombie_gib_on_damage()
{
	while(true)
	{
		self waittill(#"damage", amount, attacker, direction_vec, point, type, tagname, modelname, partname, weapon);
		if(!isdefined(self))
		{
			return;
		}
		if(!self zombie_should_gib(amount, attacker, type))
		{
			continue;
		}
		if(self head_should_gib(attacker, type, point) && type != "MOD_BURNED")
		{
			self zombie_head_gib(attacker, type);
			continue;
		}
		if(!(isdefined(self.gibbed) && self.gibbed) && isdefined(self.damagelocation))
		{
			if(self damagelocationisany("head", "helmet", "neck"))
			{
				continue;
			}
			self.stumble = undefined;
			switch(self.damagelocation)
			{
				case "torso_lower":
				case "torso_upper":
				{
					if(!gibserverutils::isgibbed(self, 32))
					{
						gibserverutils::gibrightarm(self);
					}
					break;
				}
				case "right_arm_lower":
				case "right_arm_upper":
				case "right_hand":
				{
					if(!gibserverutils::isgibbed(self, 32))
					{
						gibserverutils::gibrightarm(self);
					}
					break;
				}
				case "left_arm_lower":
				case "left_arm_upper":
				case "left_hand":
				{
					if(!gibserverutils::isgibbed(self, 16))
					{
						gibserverutils::gibleftarm(self);
					}
					break;
				}
				case "right_foot":
				case "right_leg_lower":
				case "right_leg_upper":
				{
					if(self.health <= 0)
					{
						gibserverutils::gibrightleg(self);
						if(randomint(100) > 75)
						{
							gibserverutils::gibleftleg(self);
						}
						self.missinglegs = 1;
					}
					break;
				}
				case "left_foot":
				case "left_leg_lower":
				case "left_leg_upper":
				{
					if(self.health <= 0)
					{
						gibserverutils::gibleftleg(self);
						if(randomint(100) > 75)
						{
							gibserverutils::gibrightleg(self);
						}
						self.missinglegs = 1;
					}
					break;
				}
				default:
				{
					if(self.damagelocation == "none")
					{
						if(type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH")
						{
							self derive_damage_refs(point);
							break;
						}
					}
				}
			}
			if(isdefined(self.missinglegs) && self.missinglegs && self.health > 0)
			{
				self allowedstances("crouch");
				self setphysparams(15, 0, 24);
				self allowpitchangle(1);
				self setpitchorient();
				health = self.health;
				health = health * 0.1;
				if(isdefined(self.crawl_anim_override))
				{
					self [[self.crawl_anim_override]]();
				}
			}
			if(self.health > 0)
			{
				if(isdefined(level.gib_on_damage))
				{
					self thread [[level.gib_on_damage]]();
				}
			}
		}
	}
}

/*
	Name: add_zombie_gib_weapon_callback
	Namespace: zombie_utility
	Checksum: 0x886A0FCD
	Offset: 0x6308
	Size: 0x72
	Parameters: 3
	Flags: Linked
*/
function add_zombie_gib_weapon_callback(weapon_name, gib_callback, gib_head_callback)
{
	if(!isdefined(level.zombie_gib_weapons))
	{
		level.zombie_gib_weapons = [];
	}
	if(!isdefined(level.zombie_gib_head_weapons))
	{
		level.zombie_gib_head_weapons = [];
	}
	level.zombie_gib_weapons[weapon_name] = gib_callback;
	level.zombie_gib_head_weapons[weapon_name] = gib_head_callback;
}

/*
	Name: have_zombie_weapon_gib_callback
	Namespace: zombie_utility
	Checksum: 0xC5F38764
	Offset: 0x6388
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function have_zombie_weapon_gib_callback(weapon)
{
	if(!isdefined(level.zombie_gib_weapons))
	{
		level.zombie_gib_weapons = [];
	}
	if(!isdefined(level.zombie_gib_head_weapons))
	{
		level.zombie_gib_head_weapons = [];
	}
	if(isweapon(weapon))
	{
		weapon = weapon.name;
	}
	if(isdefined(level.zombie_gib_weapons[weapon]))
	{
		return true;
	}
	return false;
}

/*
	Name: get_zombie_weapon_gib_callback
	Namespace: zombie_utility
	Checksum: 0x21D6478F
	Offset: 0x6418
	Size: 0xA0
	Parameters: 2
	Flags: Linked
*/
function get_zombie_weapon_gib_callback(weapon, damage_percent)
{
	if(!isdefined(level.zombie_gib_weapons))
	{
		level.zombie_gib_weapons = [];
	}
	if(!isdefined(level.zombie_gib_head_weapons))
	{
		level.zombie_gib_head_weapons = [];
	}
	if(isweapon(weapon))
	{
		weapon = weapon.name;
	}
	if(isdefined(level.zombie_gib_weapons[weapon]))
	{
		return self [[level.zombie_gib_weapons[weapon]]](damage_percent);
	}
	return 0;
}

/*
	Name: have_zombie_weapon_gib_head_callback
	Namespace: zombie_utility
	Checksum: 0xF3C78B59
	Offset: 0x64C0
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function have_zombie_weapon_gib_head_callback(weapon)
{
	if(!isdefined(level.zombie_gib_weapons))
	{
		level.zombie_gib_weapons = [];
	}
	if(!isdefined(level.zombie_gib_head_weapons))
	{
		level.zombie_gib_head_weapons = [];
	}
	if(isweapon(weapon))
	{
		weapon = weapon.name;
	}
	if(isdefined(level.zombie_gib_head_weapons[weapon]))
	{
		return true;
	}
	return false;
}

/*
	Name: get_zombie_weapon_gib_head_callback
	Namespace: zombie_utility
	Checksum: 0x28C8E02F
	Offset: 0x6550
	Size: 0xA0
	Parameters: 2
	Flags: Linked
*/
function get_zombie_weapon_gib_head_callback(weapon, damage_location)
{
	if(!isdefined(level.zombie_gib_weapons))
	{
		level.zombie_gib_weapons = [];
	}
	if(!isdefined(level.zombie_gib_head_weapons))
	{
		level.zombie_gib_head_weapons = [];
	}
	if(isweapon(weapon))
	{
		weapon = weapon.name;
	}
	if(isdefined(level.zombie_gib_head_weapons[weapon]))
	{
		return self [[level.zombie_gib_head_weapons[weapon]]](damage_location);
	}
	return 0;
}

/*
	Name: zombie_should_gib
	Namespace: zombie_utility
	Checksum: 0x209C6AA4
	Offset: 0x65F8
	Size: 0x28C
	Parameters: 3
	Flags: Linked
*/
function zombie_should_gib(amount, attacker, type)
{
	if(!isdefined(type))
	{
		return false;
	}
	if(isdefined(self.is_on_fire) && self.is_on_fire)
	{
		return false;
	}
	if(isdefined(self.no_gib) && self.no_gib == 1)
	{
		return false;
	}
	prev_health = amount + self.health;
	if(prev_health <= 0)
	{
		prev_health = 1;
	}
	damage_percent = (amount / prev_health) * 100;
	weapon = undefined;
	if(isdefined(attacker))
	{
		if(isplayer(attacker) || (isdefined(attacker.can_gib_zombies) && attacker.can_gib_zombies))
		{
			if(isplayer(attacker))
			{
				weapon = attacker getcurrentweapon();
			}
			else
			{
				weapon = attacker.weapon;
			}
			if(have_zombie_weapon_gib_callback(weapon))
			{
				if(self get_zombie_weapon_gib_callback(weapon, damage_percent))
				{
					return true;
				}
				return false;
			}
		}
	}
	switch(type)
	{
		case "MOD_BURNED":
		case "MOD_FALLING":
		case "MOD_SUICIDE":
		case "MOD_TELEFRAG":
		case "MOD_TRIGGER_HURT":
		case "MOD_UNKNOWN":
		{
			return false;
		}
		case "MOD_MELEE":
		{
			return false;
		}
	}
	if(type == "MOD_PISTOL_BULLET" || type == "MOD_RIFLE_BULLET")
	{
		if(!isdefined(attacker) || !isplayer(attacker))
		{
			return false;
		}
		if(weapon == level.weaponnone || (isdefined(level.start_weapon) && weapon == level.start_weapon) || weapon.isgasweapon)
		{
			return false;
		}
	}
	if(damage_percent < 10)
	{
		return false;
	}
	return true;
}

/*
	Name: head_should_gib
	Namespace: zombie_utility
	Checksum: 0x96052F9D
	Offset: 0x6890
	Size: 0x35A
	Parameters: 3
	Flags: Linked
*/
function head_should_gib(attacker, type, point)
{
	if(isdefined(self.head_gibbed) && self.head_gibbed)
	{
		return false;
	}
	if(!isdefined(attacker))
	{
		return false;
	}
	if(!isplayer(attacker))
	{
		if(!(isdefined(attacker.can_gib_zombies) && attacker.can_gib_zombies))
		{
			return false;
		}
	}
	if(isplayer(attacker))
	{
		weapon = attacker getcurrentweapon();
	}
	else
	{
		weapon = attacker.weapon;
	}
	if(have_zombie_weapon_gib_head_callback(weapon))
	{
		if(self get_zombie_weapon_gib_head_callback(weapon, self.damagelocation))
		{
			return true;
		}
		return false;
	}
	if(type != "MOD_RIFLE_BULLET" && type != "MOD_PISTOL_BULLET")
	{
		if(type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH")
		{
			if(distance(point, self gettagorigin("j_head")) > 55)
			{
				return false;
			}
			return true;
		}
		if(type == "MOD_PROJECTILE")
		{
			if(distance(point, self gettagorigin("j_head")) > 10)
			{
				return false;
			}
			return true;
		}
		if(weapon.weapclass != "spread")
		{
			return false;
		}
	}
	if(!self damagelocationisany("head", "helmet", "neck"))
	{
		return false;
	}
	if(type == "MOD_PISTOL_BULLET" && weapon.weapclass != "smg" && weapon.weapclass != "spread" || weapon == level.weaponnone || (isdefined(level.start_weapon) && weapon == level.start_weapon) || weapon.isgasweapon)
	{
		return false;
	}
	if(sessionmodeiscampaigngame() && (type == "MOD_PISTOL_BULLET" && weapon.weapclass != "smg"))
	{
		return false;
	}
	low_health_percent = (self.health / self.maxhealth) * 100;
	if(low_health_percent > 10)
	{
		return false;
	}
	return true;
}

/*
	Name: zombie_hat_gib
	Namespace: zombie_utility
	Checksum: 0xB688B1B
	Offset: 0x6BF8
	Size: 0xF8
	Parameters: 2
	Flags: None
*/
function zombie_hat_gib(attacker, means_of_death)
{
	self endon(#"death");
	if(isdefined(self.hat_gibbed) && self.hat_gibbed)
	{
		return;
	}
	if(!isdefined(self.gibspawn5) || !isdefined(self.gibspawntag5))
	{
		return;
	}
	self.hat_gibbed = 1;
	if(isdefined(self.hatmodel))
	{
		self detach(self.hatmodel, "");
	}
	temp_array = [];
	temp_array[0] = level._zombie_gib_piece_index_hat;
	self gib("normal", temp_array);
	if(isdefined(level.track_gibs))
	{
		level [[level.track_gibs]](self, temp_array);
	}
}

/*
	Name: head_gib_damage_over_time
	Namespace: zombie_utility
	Checksum: 0x40BF1520
	Offset: 0x6CF8
	Size: 0x178
	Parameters: 4
	Flags: Linked
*/
function head_gib_damage_over_time(dmg, delay, attacker, means_of_death)
{
	self endon(#"death");
	self endon(#"exploding");
	if(!isalive(self))
	{
		return;
	}
	if(!isplayer(attacker))
	{
		attacker = self;
	}
	if(!isdefined(means_of_death))
	{
		means_of_death = "MOD_UNKNOWN";
	}
	dot_location = self.damagelocation;
	dot_weapon = self.damageweapon;
	while(true)
	{
		if(isdefined(delay))
		{
			wait(delay);
		}
		if(isdefined(self))
		{
			if(isdefined(self.no_gib) && self.no_gib)
			{
				return;
			}
			if(isdefined(attacker))
			{
				self dodamage(dmg, self gettagorigin("j_neck"), attacker, self, dot_location, means_of_death, 0, dot_weapon);
			}
			else
			{
				self dodamage(dmg, self gettagorigin("j_neck"));
			}
		}
	}
}

/*
	Name: derive_damage_refs
	Namespace: zombie_utility
	Checksum: 0xA0DFB7A2
	Offset: 0x6E78
	Size: 0x360
	Parameters: 1
	Flags: Linked
*/
function derive_damage_refs(point)
{
	if(!isdefined(level.gib_tags))
	{
		init_gib_tags();
	}
	closesttag = undefined;
	for(i = 0; i < level.gib_tags.size; i++)
	{
		if(!isdefined(closesttag))
		{
			closesttag = level.gib_tags[i];
			continue;
		}
		if(distancesquared(point, self gettagorigin(level.gib_tags[i])) < distancesquared(point, self gettagorigin(closesttag)))
		{
			closesttag = level.gib_tags[i];
		}
	}
	if(closesttag == "J_SpineLower" || closesttag == "J_SpineUpper" || closesttag == "J_Spine4")
	{
		gibserverutils::gibrightarm(self);
	}
	else
	{
		if(closesttag == "J_Shoulder_LE" || closesttag == "J_Elbow_LE" || closesttag == "J_Wrist_LE")
		{
			if(!gibserverutils::isgibbed(self, 16))
			{
				gibserverutils::gibleftarm(self);
			}
		}
		else
		{
			if(closesttag == "J_Shoulder_RI" || closesttag == "J_Elbow_RI" || closesttag == "J_Wrist_RI")
			{
				if(!gibserverutils::isgibbed(self, 32))
				{
					gibserverutils::gibrightarm(self);
				}
			}
			else
			{
				if(closesttag == "J_Hip_LE" || closesttag == "J_Knee_LE" || closesttag == "J_Ankle_LE")
				{
					if(isdefined(self.nocrawler) && self.nocrawler)
					{
						return;
					}
					gibserverutils::gibleftleg(self);
					if(randomint(100) > 75)
					{
						gibserverutils::gibrightleg(self);
					}
					self.missinglegs = 1;
				}
				else if(closesttag == "J_Hip_RI" || closesttag == "J_Knee_RI" || closesttag == "J_Ankle_RI")
				{
					if(isdefined(self.nocrawler) && self.nocrawler)
					{
						return;
					}
					gibserverutils::gibrightleg(self);
					if(randomint(100) > 75)
					{
						gibserverutils::gibleftleg(self);
					}
					self.missinglegs = 1;
				}
			}
		}
	}
}

/*
	Name: init_gib_tags
	Namespace: zombie_utility
	Checksum: 0x46A361C
	Offset: 0x71E0
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function init_gib_tags()
{
	tags = [];
	tags[tags.size] = "J_SpineLower";
	tags[tags.size] = "J_SpineUpper";
	tags[tags.size] = "J_Spine4";
	tags[tags.size] = "J_Shoulder_LE";
	tags[tags.size] = "J_Elbow_LE";
	tags[tags.size] = "J_Wrist_LE";
	tags[tags.size] = "J_Shoulder_RI";
	tags[tags.size] = "J_Elbow_RI";
	tags[tags.size] = "J_Wrist_RI";
	tags[tags.size] = "J_Hip_LE";
	tags[tags.size] = "J_Knee_LE";
	tags[tags.size] = "J_Ankle_LE";
	tags[tags.size] = "J_Hip_RI";
	tags[tags.size] = "J_Knee_RI";
	tags[tags.size] = "J_Ankle_RI";
	level.gib_tags = tags;
}

/*
	Name: getanimdirection
	Namespace: zombie_utility
	Checksum: 0xCA700833
	Offset: 0x7338
	Size: 0x8A
	Parameters: 1
	Flags: None
*/
function getanimdirection(damageyaw)
{
	if(damageyaw > 135 || damageyaw <= -135)
	{
		return "front";
	}
	if(damageyaw > 45 && damageyaw <= 135)
	{
		return "right";
	}
	if(damageyaw > -45 && damageyaw <= 45)
	{
		return "back";
	}
	return "left";
}

/*
	Name: anim_get_dvar_int
	Namespace: zombie_utility
	Checksum: 0xA954F8DB
	Offset: 0x73D8
	Size: 0x42
	Parameters: 2
	Flags: Linked
*/
function anim_get_dvar_int(dvar, def)
{
	return int(anim_get_dvar(dvar, def));
}

/*
	Name: anim_get_dvar
	Namespace: zombie_utility
	Checksum: 0x49F6246F
	Offset: 0x7428
	Size: 0x70
	Parameters: 2
	Flags: Linked
*/
function anim_get_dvar(dvar, def)
{
	if(getdvarstring(dvar) != "")
	{
		return getdvarfloat(dvar);
	}
	setdvar(dvar, def);
	return def;
}

/*
	Name: makezombiecrawler
	Namespace: zombie_utility
	Checksum: 0xBF46BB28
	Offset: 0x74A8
	Size: 0x16A
	Parameters: 1
	Flags: Linked
*/
function makezombiecrawler(b_both_legs)
{
	if(isdefined(b_both_legs) && b_both_legs)
	{
		val = 100;
	}
	else
	{
		val = randomint(100);
	}
	if(val > 75)
	{
		gibserverutils::gibrightleg(self);
		gibserverutils::gibleftleg(self);
	}
	else
	{
		if(val > 37)
		{
			gibserverutils::gibrightleg(self);
		}
		else
		{
			gibserverutils::gibleftleg(self);
		}
	}
	self.missinglegs = 1;
	self allowedstances("crouch");
	self setphysparams(15, 0, 24);
	self allowpitchangle(1);
	self setpitchorient();
	health = self.health;
	health = health * 0.1;
}

/*
	Name: zombie_head_gib
	Namespace: zombie_utility
	Checksum: 0x4700581B
	Offset: 0x7620
	Size: 0xDC
	Parameters: 2
	Flags: Linked
*/
function zombie_head_gib(attacker, means_of_death)
{
	self endon(#"death");
	if(isdefined(self.head_gibbed) && self.head_gibbed)
	{
		return;
	}
	if(isdefined(self.no_gib) && self.no_gib)
	{
		return;
	}
	self.head_gibbed = 1;
	self zombie_eye_glow_stop();
	if(!(isdefined(self.disable_head_gib) && self.disable_head_gib))
	{
		gibserverutils::gibhead(self);
	}
	self thread head_gib_damage_over_time(ceil(self.health * 0.2), 1, attacker, means_of_death);
}

/*
	Name: gib_random_parts
	Namespace: zombie_utility
	Checksum: 0xBE13EC82
	Offset: 0x7708
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function gib_random_parts()
{
	if(isdefined(self.no_gib) && self.no_gib)
	{
		return;
	}
	val = randomint(100);
	if(val > 50)
	{
		self zombie_head_gib();
	}
	val = randomint(100);
	if(val > 50)
	{
		gibserverutils::gibrightleg(self);
	}
	val = randomint(100);
	if(val > 50)
	{
		gibserverutils::gibleftleg(self);
	}
	val = randomint(100);
	if(val > 50)
	{
		if(!gibserverutils::isgibbed(self, 32))
		{
			gibserverutils::gibrightarm(self);
		}
	}
	val = randomint(100);
	if(val > 50)
	{
		if(!gibserverutils::isgibbed(self, 16))
		{
			gibserverutils::gibleftarm(self);
		}
	}
}

/*
	Name: init_ignore_player_handler
	Namespace: zombie_utility
	Checksum: 0x415512D4
	Offset: 0x78A8
	Size: 0x10
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init_ignore_player_handler()
{
	level._ignore_player_handler = [];
}

/*
	Name: register_ignore_player_handler
	Namespace: zombie_utility
	Checksum: 0x8B94AAE4
	Offset: 0x78C0
	Size: 0x8E
	Parameters: 2
	Flags: Linked
*/
function register_ignore_player_handler(archetype, ignore_player_func)
{
	/#
		assert(isdefined(archetype), "");
	#/
	/#
		assert(!isdefined(level._ignore_player_handler[archetype]), ("" + archetype) + "");
	#/
	level._ignore_player_handler[archetype] = ignore_player_func;
}

/*
	Name: run_ignore_player_handler
	Namespace: zombie_utility
	Checksum: 0x9053EB8E
	Offset: 0x7958
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function run_ignore_player_handler()
{
	if(isdefined(level._ignore_player_handler[self.archetype]))
	{
		self [[level._ignore_player_handler[self.archetype]]]();
	}
}

/*
	Name: show_hit_marker
	Namespace: zombie_utility
	Checksum: 0x2CBF5B55
	Offset: 0x7998
	Size: 0x88
	Parameters: 0
	Flags: None
*/
function show_hit_marker()
{
	if(isdefined(self) && isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback setshader("damage_feedback", 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeovertime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

