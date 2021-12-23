// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace behaviortreenetwork;

/*
	Name: registerbehaviortreescriptapiinternal
	Namespace: behaviortreenetwork
	Checksum: 0x8007C77E
	Offset: 0xC0
	Size: 0xB6
	Parameters: 2
	Flags: Linked
*/
function registerbehaviortreescriptapiinternal(functionname, functionptr)
{
	if(!isdefined(level._behaviortreescriptfunctions))
	{
		level._behaviortreescriptfunctions = [];
	}
	functionname = tolower(functionname);
	/#
		assert(isdefined(functionname) && isdefined(functionptr), "");
	#/
	/#
		assert(!isdefined(level._behaviortreescriptfunctions[functionname]), "");
	#/
	level._behaviortreescriptfunctions[functionname] = functionptr;
}

/*
	Name: registerbehaviortreeactioninternal
	Namespace: behaviortreenetwork
	Checksum: 0x23618E0F
	Offset: 0x180
	Size: 0x1F8
	Parameters: 4
	Flags: Linked
*/
function registerbehaviortreeactioninternal(actionname, startfuncptr, updatefuncptr, terminatefuncptr)
{
	if(!isdefined(level._behaviortreeactions))
	{
		level._behaviortreeactions = [];
	}
	actionname = tolower(actionname);
	/#
		assert(isstring(actionname), "");
	#/
	/#
		assert(!isdefined(level._behaviortreeactions[actionname]), ("" + actionname) + "");
	#/
	level._behaviortreeactions[actionname] = array();
	if(isdefined(startfuncptr))
	{
		/#
			assert(isfunctionptr(startfuncptr), "");
		#/
		level._behaviortreeactions[actionname]["bhtn_action_start"] = startfuncptr;
	}
	if(isdefined(updatefuncptr))
	{
		/#
			assert(isfunctionptr(updatefuncptr), "");
		#/
		level._behaviortreeactions[actionname]["bhtn_action_update"] = updatefuncptr;
	}
	if(isdefined(terminatefuncptr))
	{
		/#
			assert(isfunctionptr(terminatefuncptr), "");
		#/
		level._behaviortreeactions[actionname]["bhtn_action_terminate"] = terminatefuncptr;
	}
}

#namespace behaviortreenetworkutility;

/*
	Name: registerbehaviortreescriptapi
	Namespace: behaviortreenetworkutility
	Checksum: 0xD6399A01
	Offset: 0x380
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function registerbehaviortreescriptapi(functionname, functionptr)
{
	behaviortreenetwork::registerbehaviortreescriptapiinternal(functionname, functionptr);
}

/*
	Name: registerbehaviortreeaction
	Namespace: behaviortreenetworkutility
	Checksum: 0x1B4911C3
	Offset: 0x3B8
	Size: 0x44
	Parameters: 4
	Flags: Linked
*/
function registerbehaviortreeaction(actionname, startfuncptr, updatefuncptr, terminatefuncptr)
{
	behaviortreenetwork::registerbehaviortreeactioninternal(actionname, startfuncptr, updatefuncptr, terminatefuncptr);
}

