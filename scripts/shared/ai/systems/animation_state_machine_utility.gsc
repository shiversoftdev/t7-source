// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;

#namespace animationstatenetworkutility;

/*
	Name: requeststate
	Namespace: animationstatenetworkutility
	Checksum: 0x435607BF
	Offset: 0xC0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function requeststate(entity, statename)
{
	/#
		assert(isdefined(entity));
	#/
	entity asmrequestsubstate(statename);
}

/*
	Name: searchanimationmap
	Namespace: animationstatenetworkutility
	Checksum: 0xBE537519
	Offset: 0x118
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function searchanimationmap(entity, aliasname)
{
	if(isdefined(entity) && isdefined(aliasname))
	{
		animationname = entity animmappingsearch(istring(aliasname));
		if(isdefined(animationname))
		{
			return findanimbyname("generic", animationname);
		}
	}
}

