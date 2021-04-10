// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace killcam;

/*
	Name: get_killcam_entity_start_time
	Namespace: killcam
	Checksum: 0xB03FD074
	Offset: 0x78
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function get_killcam_entity_start_time(killcamentity)
{
	killcamentitystarttime = 0;
	if(isdefined(killcamentity))
	{
		if(isdefined(killcamentity.starttime))
		{
			killcamentitystarttime = killcamentity.starttime;
		}
		else
		{
			killcamentitystarttime = killcamentity.birthtime;
		}
		if(!isdefined(killcamentitystarttime))
		{
			killcamentitystarttime = 0;
		}
	}
	return killcamentitystarttime;
}

/*
	Name: store_killcam_entity_on_entity
	Namespace: killcam
	Checksum: 0x9AA781F7
	Offset: 0x100
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function store_killcam_entity_on_entity(killcam_entity)
{
	/#
		assert(isdefined(killcam_entity));
	#/
	self.killcamentitystarttime = get_killcam_entity_start_time(killcam_entity);
	self.killcamentityindex = killcam_entity getentitynumber();
}

