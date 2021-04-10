// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\warlord;

#namespace warlordinterface;

/*
	Name: registerwarlordinterfaceattributes
	Namespace: warlordinterface
	Checksum: 0xB93C4B1A
	Offset: 0xE8
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function registerwarlordinterfaceattributes()
{
	ai::registermatchedinterface("warlord", "can_be_meleed", 0, array(1, 0));
}

/*
	Name: addpreferedpoint
	Namespace: warlordinterface
	Checksum: 0x8EA2474C
	Offset: 0x130
	Size: 0x4C
	Parameters: 4
	Flags: None
*/
function addpreferedpoint(position, min_duration, max_duration, name)
{
	warlordserverutils::addpreferedpoint(self, position, min_duration, max_duration, name);
}

/*
	Name: deletepreferedpoint
	Namespace: warlordinterface
	Checksum: 0x3C9366C3
	Offset: 0x188
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function deletepreferedpoint(name)
{
	warlordserverutils::deletepreferedpoint(self, name);
}

/*
	Name: clearallpreferedpoints
	Namespace: warlordinterface
	Checksum: 0x195BB928
	Offset: 0x1B8
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function clearallpreferedpoints()
{
	warlordserverutils::clearallpreferedpoints(self);
}

/*
	Name: clearpreferedpointsoutsidegoal
	Namespace: warlordinterface
	Checksum: 0x1BE4A021
	Offset: 0x1E0
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function clearpreferedpointsoutsidegoal()
{
	warlordserverutils::clearpreferedpointsoutsidegoal(self);
}

/*
	Name: setwarlordaggressivemode
	Namespace: warlordinterface
	Checksum: 0xF5A33898
	Offset: 0x208
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function setwarlordaggressivemode(b_aggressive_mode)
{
	warlordserverutils::setwarlordaggressivemode(self);
}

