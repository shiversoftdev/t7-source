// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\shared\music_shared;
#using scripts\shared\util_shared;

#namespace cp_mi_cairo_lotus_sound;

/*
	Name: main
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0xB4B6074B
	Offset: 0x1A8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_cf637cc();
	level thread function_ba59ec78();
}

/*
	Name: function_cf637cc
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0xF899AC1B
	Offset: 0x1E8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_cf637cc()
{
	level waittill(#"hash_72d53556");
	level util::clientnotify("start_battle_sound");
}

/*
	Name: function_ba59ec78
	Namespace: cp_mi_cairo_lotus_sound
	Checksum: 0x19E4574D
	Offset: 0x220
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_ba59ec78()
{
	level waittill(#"hash_fe7439eb");
	level util::clientnotify("kill_security_chatter");
}

#namespace namespace_66fe78fb;

/*
	Name: play_intro
	Namespace: namespace_66fe78fb
	Checksum: 0xE25AAF7D
	Offset: 0x258
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function play_intro()
{
	music::setmusicstate("intro");
}

/*
	Name: function_36e942f6
	Namespace: namespace_66fe78fb
	Checksum: 0x9FE9C94B
	Offset: 0x280
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_36e942f6()
{
	music::setmusicstate("battle_one_part_one");
}

/*
	Name: function_f3bdd599
	Namespace: namespace_66fe78fb
	Checksum: 0xDBF01AA6
	Offset: 0x2A8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_f3bdd599()
{
	music::setmusicstate("elevator_ride");
}

/*
	Name: function_d116b1d8
	Namespace: namespace_66fe78fb
	Checksum: 0xC238B5B0
	Offset: 0x2D0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_d116b1d8()
{
	wait(10);
	music::setmusicstate("battle_one_part_two");
}

/*
	Name: function_f2d3d939
	Namespace: namespace_66fe78fb
	Checksum: 0x3725FC8B
	Offset: 0x300
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_f2d3d939()
{
	music::setmusicstate("air_duct");
	wait(15);
	util::clientnotify("sndRampair");
	wait(25);
	util::clientnotify("sndRampEnd");
}

/*
	Name: function_86781870
	Namespace: namespace_66fe78fb
	Checksum: 0x3CFA9B48
	Offset: 0x368
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_86781870()
{
	wait(0.5);
	music::setmusicstate("hq_battle");
}

/*
	Name: function_8836c025
	Namespace: namespace_66fe78fb
	Checksum: 0xC5595AC1
	Offset: 0x398
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_8836c025()
{
	music::setmusicstate("computer_hack");
}

/*
	Name: function_fd00a4f2
	Namespace: namespace_66fe78fb
	Checksum: 0x392417EB
	Offset: 0x3C0
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function function_fd00a4f2()
{
	music::setmusicstate("breach_stinger");
}

/*
	Name: function_51e72857
	Namespace: namespace_66fe78fb
	Checksum: 0xA2151A2E
	Offset: 0x3E8
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function function_51e72857()
{
	music::setmusicstate("battle_two");
}

/*
	Name: function_973b77f9
	Namespace: namespace_66fe78fb
	Checksum: 0x83899D83
	Offset: 0x410
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_973b77f9()
{
	music::setmusicstate("none");
}

