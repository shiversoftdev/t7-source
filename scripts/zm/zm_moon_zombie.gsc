// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_black_hole_bomb;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_remaster_zombie;

#namespace zm_moon_zombie;

/*
	Name: init
	Namespace: zm_moon_zombie
	Checksum: 0x75E6897A
	Offset: 0x420
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzmbehaviorsandasm();
	level thread zm_remaster_zombie::update_closest_player();
	level.last_valid_position_override = &moon_last_valid_position;
}

/*
	Name: initzmbehaviorsandasm
	Namespace: zm_moon_zombie
	Checksum: 0x5EB80163
	Offset: 0x470
	Size: 0xA4
	Parameters: 0
	Flags: Linked, Private
*/
function private initzmbehaviorsandasm()
{
	spawner::add_archetype_spawn_function("zombie", &function_7a726580);
	behaviortreenetworkutility::registerbehaviortreescriptapi("moonZombieKilledByMicrowaveGunDw", &killedbymicrowavegundw);
	behaviortreenetworkutility::registerbehaviortreescriptapi("moonZombieKilledByMicrowaveGun", &killedbymicrowavegun);
	behaviortreenetworkutility::registerbehaviortreescriptapi("moonShouldMoveLowg", &moonshouldmovelowg);
}

/*
	Name: teleporttraversalmocompstart
	Namespace: zm_moon_zombie
	Checksum: 0xFCA9F6F4
	Offset: 0x520
	Size: 0x19C
	Parameters: 5
	Flags: None
*/
function teleporttraversalmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.angles[1]);
	entity animmode("normal");
	if(isdefined(entity.traverseendnode))
	{
		/#
			print3d(entity.traversestartnode.origin, "", (1, 0, 0), 1, 1, 60);
			print3d(entity.traverseendnode.origin, "", (0, 1, 0), 1, 1, 60);
			line(entity.traversestartnode.origin, entity.traverseendnode.origin, (0, 1, 0), 1, 0, 60);
		#/
		entity forceteleport(entity.traverseendnode.origin, entity.traverseendnode.angles, 0);
	}
}

/*
	Name: zodshouldmove
	Namespace: zm_moon_zombie
	Checksum: 0x16A304C0
	Offset: 0x6C8
	Size: 0x18A
	Parameters: 1
	Flags: None
*/
function zodshouldmove(entity)
{
	if(isdefined(entity.zombie_tesla_hit) && entity.zombie_tesla_hit && (!(isdefined(entity.tesla_death) && entity.tesla_death)))
	{
		return false;
	}
	if(isdefined(entity.pushed) && entity.pushed)
	{
		return false;
	}
	if(isdefined(entity.knockdown) && entity.knockdown)
	{
		return false;
	}
	if(isdefined(entity.grapple_is_fatal) && entity.grapple_is_fatal)
	{
		return false;
	}
	if(level.wait_and_revive)
	{
		if(!(isdefined(entity.var_1e3fb1c) && entity.var_1e3fb1c))
		{
			return false;
		}
	}
	if(isdefined(entity.stumble))
	{
		return false;
	}
	if(zombiebehavior::zombieshouldmeleecondition(entity))
	{
		return false;
	}
	if(entity haspath())
	{
		return true;
	}
	if(isdefined(entity.keep_moving) && entity.keep_moving)
	{
		return true;
	}
	return false;
}

/*
	Name: function_7a726580
	Namespace: zm_moon_zombie
	Checksum: 0xFC1EA588
	Offset: 0x860
	Size: 0x34
	Parameters: 0
	Flags: Linked, Private
*/
function private function_7a726580()
{
	self.cant_move_cb = &moon_cant_move_cb;
	self.closest_player_override = &zm_remaster_zombie::remaster_closest_player;
}

/*
	Name: moon_cant_move_cb
	Namespace: zm_moon_zombie
	Checksum: 0x437A67E1
	Offset: 0x8A0
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private moon_cant_move_cb()
{
	self pushactors(0);
	self.enablepushtime = gettime() + 1000;
}

/*
	Name: killedbymicrowavegundw
	Namespace: zm_moon_zombie
	Checksum: 0xB0447E76
	Offset: 0x8D8
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function killedbymicrowavegundw(entity)
{
	return isdefined(entity.microwavegun_dw_death) && entity.microwavegun_dw_death;
}

/*
	Name: killedbymicrowavegun
	Namespace: zm_moon_zombie
	Checksum: 0x35DF044E
	Offset: 0x910
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function killedbymicrowavegun(entity)
{
	return isdefined(entity.microwavegun_death) && entity.microwavegun_death;
}

/*
	Name: moonshouldmovelowg
	Namespace: zm_moon_zombie
	Checksum: 0x58C9938F
	Offset: 0x948
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function moonshouldmovelowg(entity)
{
	return isdefined(entity.in_low_gravity) && entity.in_low_gravity;
}

/*
	Name: moon_last_valid_position
	Namespace: zm_moon_zombie
	Checksum: 0x486B431E
	Offset: 0x980
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function moon_last_valid_position()
{
	if(isdefined(self.in_low_gravity) && self.in_low_gravity)
	{
		if(self isonground())
		{
			return false;
		}
		trace = groundtrace(self.origin + vectorscale((0, 0, 1), 15), self.origin + (vectorscale((0, 0, -1), 1000)), 0, undefined);
		ground_pos = trace["position"];
		if(isdefined(ground_pos))
		{
			if(ispointonnavmesh(ground_pos, self))
			{
				self.last_valid_position = ground_pos;
				return true;
			}
		}
	}
	return false;
}

