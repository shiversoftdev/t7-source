// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace cp_mi_sing_biodomes_sound;

/*
	Name: main
	Namespace: cp_mi_sing_biodomes_sound
	Checksum: 0xC3793C4B
	Offset: 0x98
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function main()
{
	thread party_stop();
}

/*
	Name: party_stop
	Namespace: cp_mi_sing_biodomes_sound
	Checksum: 0x8E3A563A
	Offset: 0xB8
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function party_stop()
{
	level notify(#"no_party");
}

