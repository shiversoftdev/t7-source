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
#using scripts\zm\_zm_zonemgr;

#namespace zm_asylum_zombie;

/*
	Name: init
	Namespace: zm_asylum_zombie
	Checksum: 0x4788ECA5
	Offset: 0x3E8
	Size: 0x64
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	function_ee90a52a();
	setdvar("tu5_zmPathDistanceCheckTolarance", 20);
	setdvar("scr_zm_use_code_enemy_selection", 0);
	level.move_valid_poi_to_navmesh = 1;
	level.pathdist_type = 2;
}

/*
	Name: function_ee90a52a
	Namespace: zm_asylum_zombie
	Checksum: 0x442110AD
	Offset: 0x458
	Size: 0x84
	Parameters: 0
	Flags: Linked, Private
*/
function private function_ee90a52a()
{
	animationstatenetwork::registeranimationmocomp("mocomp_teleport_traversal@zombie", &teleporttraversalmocompstart, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zodShouldMove", &zodshouldmove);
	spawner::add_archetype_spawn_function("zombie", &function_5bf6989a);
}

/*
	Name: teleporttraversalmocompstart
	Namespace: zm_asylum_zombie
	Checksum: 0xA12EF3A8
	Offset: 0x4E8
	Size: 0x19C
	Parameters: 5
	Flags: Linked
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
	Namespace: zm_asylum_zombie
	Checksum: 0x98BDD08B
	Offset: 0x690
	Size: 0x18A
	Parameters: 1
	Flags: Linked
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
	Name: function_5bf6989a
	Namespace: zm_asylum_zombie
	Checksum: 0x98553D4C
	Offset: 0x828
	Size: 0x1C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_5bf6989a()
{
	self.cant_move_cb = &function_9f18c3b1;
}

/*
	Name: function_9f18c3b1
	Namespace: zm_asylum_zombie
	Checksum: 0x57FAB375
	Offset: 0x850
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_9f18c3b1()
{
	self pushactors(0);
	self.enablepushtime = gettime() + 1000;
}

