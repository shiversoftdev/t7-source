// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_state_machine;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\spawner_shared;

#namespace archetype_civilian;

/*
	Name: main
	Namespace: archetype_civilian
	Checksum: 0xC28BD094
	Offset: 0x2A8
	Size: 0x14
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	archetypecivilian::registerbehaviorscriptfunctions();
}

#namespace archetypecivilian;

/*
	Name: registerbehaviorscriptfunctions
	Namespace: archetypecivilian
	Checksum: 0x9A35315C
	Offset: 0x2C8
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function registerbehaviorscriptfunctions()
{
	spawner::add_archetype_spawn_function("civilian", &civilianblackboardinit);
	spawner::add_archetype_spawn_function("civilian", &archetypecivilianinit);
	ai::registermatchedinterface("civilian", "sprint", 0, array(1, 0));
	ai::registermatchedinterface("civilian", "panic", 0, array(1, 0));
	behaviortreenetworkutility::registerbehaviortreeaction("civilianMoveAction", &civilianmoveactioninitialize, undefined, &civilianmoveactionfinalize);
	behaviortreenetworkutility::registerbehaviortreeaction("civilianCowerAction", &civiliancoweractioninitialize, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreescriptapi("civilianIsPanicked", &civilianispanicked);
	behaviortreenetworkutility::registerbehaviortreescriptapi("civilianPanic", &civilianpanic);
	behaviorstatemachine::registerbsmscriptapiinternal("civilianPanic", &civilianpanic);
}

/*
	Name: civilianblackboardinit
	Namespace: archetypecivilian
	Checksum: 0x625AB7AD
	Offset: 0x478
	Size: 0x13C
	Parameters: 0
	Flags: Linked, Private
*/
function private civilianblackboardinit()
{
	blackboard::createblackboardforentity(self);
	ai::createinterfaceforentity(self);
	self aiutility::registerutilityblackboardattributes();
	blackboard::registerblackboardattribute(self, "_panic", "calm", &bb_getpanic);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	blackboard::registerblackboardattribute(self, "_human_locomotion_variation", undefined, undefined);
	if(isactor(self))
	{
		/#
			self trackblackboardattribute("");
		#/
	}
	self.___archetypeonanimscriptedcallback = &civilianonanimscriptedcallback;
	/#
		self finalizetrackedblackboardattributes();
	#/
}

/*
	Name: archetypecivilianinit
	Namespace: archetypecivilian
	Checksum: 0x357563BD
	Offset: 0x5C0
	Size: 0xBC
	Parameters: 0
	Flags: Linked, Private
*/
function private archetypecivilianinit()
{
	entity = self;
	locomotiontypes = array("alt1", "alt2", "alt3", "alt4");
	altindex = entity getentitynumber() % locomotiontypes.size;
	blackboard::setblackboardattribute(entity, "_human_locomotion_variation", locomotiontypes[altindex]);
	entity setavoidancemask("avoid ai");
}

/*
	Name: bb_getpanic
	Namespace: archetypecivilian
	Checksum: 0x59AD0BC9
	Offset: 0x688
	Size: 0x36
	Parameters: 0
	Flags: Linked, Private
*/
function private bb_getpanic()
{
	if(ai::getaiattribute(self, "panic"))
	{
		return "panic";
	}
	return "calm";
}

/*
	Name: civilianonanimscriptedcallback
	Namespace: archetypecivilian
	Checksum: 0x81C13565
	Offset: 0x6C8
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private civilianonanimscriptedcallback(entity)
{
	entity.__blackboard = undefined;
	entity civilianblackboardinit();
}

/*
	Name: civilianmoveactioninitialize
	Namespace: archetypecivilian
	Checksum: 0xD7523D1D
	Offset: 0x708
	Size: 0x58
	Parameters: 2
	Flags: Linked, Private
*/
function private civilianmoveactioninitialize(entity, asmstatename)
{
	blackboard::setblackboardattribute(entity, "_desired_stance", "stand");
	animationstatenetworkutility::requeststate(entity, asmstatename);
	return 5;
}

/*
	Name: civilianmoveactionfinalize
	Namespace: archetypecivilian
	Checksum: 0x2DFDCED8
	Offset: 0x768
	Size: 0x68
	Parameters: 2
	Flags: Linked, Private
*/
function private civilianmoveactionfinalize(entity, asmstatename)
{
	if(blackboard::getblackboardattribute(entity, "_stance") != "stand")
	{
		blackboard::setblackboardattribute(entity, "_desired_stance", "stand");
	}
	return 4;
}

/*
	Name: civiliancoweractioninitialize
	Namespace: archetypecivilian
	Checksum: 0xCFA539E
	Offset: 0x7D8
	Size: 0xC8
	Parameters: 2
	Flags: Linked, Private
*/
function private civiliancoweractioninitialize(entity, asmstatename)
{
	if(isdefined(entity.node))
	{
		higheststance = aiutility::gethighestnodestance(entity.node);
		if(higheststance == "crouch")
		{
			blackboard::setblackboardattribute(entity, "_stance", "crouch");
		}
		else
		{
			blackboard::setblackboardattribute(entity, "_stance", "stand");
		}
	}
	animationstatenetworkutility::requeststate(entity, asmstatename);
	return 5;
}

/*
	Name: civilianispanicked
	Namespace: archetypecivilian
	Checksum: 0xAE944285
	Offset: 0x8A8
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private civilianispanicked(entity)
{
	return blackboard::getblackboardattribute(entity, "_panic") == "panic";
}

/*
	Name: civilianpanic
	Namespace: archetypecivilian
	Checksum: 0x58B3C3EE
	Offset: 0x8E8
	Size: 0x30
	Parameters: 1
	Flags: Linked, Private
*/
function private civilianpanic(entity)
{
	entity ai::set_behavior_attribute("panic", 1);
	return true;
}

