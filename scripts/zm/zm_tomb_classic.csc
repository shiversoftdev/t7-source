// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\zm_tomb_craftables;

#namespace zm_tomb_classic;

/*
	Name: precache
	Namespace: zm_tomb_classic
	Checksum: 0x99EC1590
	Offset: 0x110
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function precache()
{
}

/*
	Name: premain
	Namespace: zm_tomb_classic
	Checksum: 0x89D5652D
	Offset: 0x120
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function premain()
{
	zm_tomb_craftables::include_craftables();
	zm_tomb_craftables::init_craftables();
}

/*
	Name: main
	Namespace: zm_tomb_classic
	Checksum: 0x99EC1590
	Offset: 0x150
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function main()
{
}

