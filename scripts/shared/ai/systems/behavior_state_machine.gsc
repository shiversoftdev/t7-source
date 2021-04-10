// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace behaviorstatemachine;

/*
	Name: registerbsmscriptapiinternal
	Namespace: behaviorstatemachine
	Checksum: 0x2B8AA8F7
	Offset: 0x88
	Size: 0xB6
	Parameters: 2
	Flags: Linked
*/
function registerbsmscriptapiinternal(functionname, scriptfunction)
{
	if(!isdefined(level._bsmscriptfunctions))
	{
		level._bsmscriptfunctions = [];
	}
	functionname = tolower(functionname);
	/#
		assert(isdefined(scriptfunction) && isdefined(scriptfunction), "");
	#/
	/#
		assert(!isdefined(level._bsmscriptfunctions[functionname]), "");
	#/
	level._bsmscriptfunctions[functionname] = scriptfunction;
}

