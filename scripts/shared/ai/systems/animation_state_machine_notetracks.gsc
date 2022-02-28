// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\blackboard;

#namespace animationstatenetwork;

/*
	Name: initnotetrackhandler
	Namespace: animationstatenetwork
	Checksum: 0xF8F80D1F
	Offset: 0xC0
	Size: 0x10
	Parameters: 0
	Flags: AutoExec
*/
function autoexec initnotetrackhandler()
{
	level._notetrack_handler = [];
}

/*
	Name: runnotetrackhandler
	Namespace: animationstatenetwork
	Checksum: 0x3DCF0A81
	Offset: 0xD8
	Size: 0x8E
	Parameters: 2
	Flags: Linked, Private
*/
function private runnotetrackhandler(entity, notetracks)
{
	/#
		assert(isarray(notetracks));
	#/
	for(index = 0; index < notetracks.size; index++)
	{
		handlenotetrack(entity, notetracks[index]);
	}
}

/*
	Name: handlenotetrack
	Namespace: animationstatenetwork
	Checksum: 0x93449524
	Offset: 0x170
	Size: 0x9C
	Parameters: 2
	Flags: Linked, Private
*/
function private handlenotetrack(entity, notetrack)
{
	notetrackhandler = level._notetrack_handler[notetrack];
	if(!isdefined(notetrackhandler))
	{
		return;
	}
	if(isfunctionptr(notetrackhandler))
	{
		[[notetrackhandler]](entity);
	}
	else
	{
		blackboard::setblackboardattribute(entity, notetrackhandler.blackboardattributename, notetrackhandler.blackboardvalue);
	}
}

/*
	Name: registernotetrackhandlerfunction
	Namespace: animationstatenetwork
	Checksum: 0x2FFE03ED
	Offset: 0x218
	Size: 0xD6
	Parameters: 2
	Flags: Linked
*/
function registernotetrackhandlerfunction(notetrackname, notetrackfuncptr)
{
	/#
		assert(isstring(notetrackname), "");
	#/
	/#
		assert(isfunctionptr(notetrackfuncptr), "");
	#/
	/#
		assert(!isdefined(level._notetrack_handler[notetrackname]), ("" + notetrackname) + "");
	#/
	level._notetrack_handler[notetrackname] = notetrackfuncptr;
}

/*
	Name: registerblackboardnotetrackhandler
	Namespace: animationstatenetwork
	Checksum: 0x7075B8B9
	Offset: 0x2F8
	Size: 0x72
	Parameters: 3
	Flags: Linked
*/
function registerblackboardnotetrackhandler(notetrackname, blackboardattributename, blackboardvalue)
{
	notetrackhandler = spawnstruct();
	notetrackhandler.blackboardattributename = blackboardattributename;
	notetrackhandler.blackboardvalue = blackboardvalue;
	level._notetrack_handler[notetrackname] = notetrackhandler;
}

