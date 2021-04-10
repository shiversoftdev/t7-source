// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace animationselectortable;

/*
	Name: registeranimationselectortableevaluator
	Namespace: animationselectortable
	Checksum: 0x9C7915C
	Offset: 0x88
	Size: 0xA6
	Parameters: 2
	Flags: Linked
*/
function registeranimationselectortableevaluator(functionname, functionptr)
{
	if(!isdefined(level._astevaluatorscriptfunctions))
	{
		level._astevaluatorscriptfunctions = [];
	}
	functionname = tolower(functionname);
	/#
		assert(isdefined(functionname) && isdefined(functionptr));
	#/
	/#
		assert(!isdefined(level._astevaluatorscriptfunctions[functionname]));
	#/
	level._astevaluatorscriptfunctions[functionname] = functionptr;
}

