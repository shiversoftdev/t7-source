// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace bot;

/*
	Name: tap_attack_button
	Namespace: bot
	Checksum: 0x75FFA77B
	Offset: 0x140
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function tap_attack_button()
{
	self bottapbutton(0);
}

/*
	Name: press_attack_button
	Namespace: bot
	Checksum: 0xB3D880D9
	Offset: 0x168
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function press_attack_button()
{
	self botpressbutton(0);
}

/*
	Name: release_attack_button
	Namespace: bot
	Checksum: 0xA48CF6E6
	Offset: 0x190
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function release_attack_button()
{
	self botreleasebutton(0);
}

/*
	Name: tap_melee_button
	Namespace: bot
	Checksum: 0x9D7D8ED0
	Offset: 0x1B8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function tap_melee_button()
{
	self bottapbutton(2);
}

/*
	Name: tap_reload_button
	Namespace: bot
	Checksum: 0xB6119DC2
	Offset: 0x1E0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function tap_reload_button()
{
	self bottapbutton(4);
}

/*
	Name: tap_use_button
	Namespace: bot
	Checksum: 0x7933018B
	Offset: 0x208
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function tap_use_button()
{
	self bottapbutton(3);
}

/*
	Name: press_crouch_button
	Namespace: bot
	Checksum: 0x17EE89DA
	Offset: 0x230
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function press_crouch_button()
{
	self botpressbutton(9);
}

/*
	Name: press_use_button
	Namespace: bot
	Checksum: 0xDDEC69CE
	Offset: 0x258
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function press_use_button()
{
	self botpressbutton(3);
}

/*
	Name: release_use_button
	Namespace: bot
	Checksum: 0xC4D15F07
	Offset: 0x280
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function release_use_button()
{
	self botreleasebutton(3);
}

/*
	Name: press_sprint_button
	Namespace: bot
	Checksum: 0x33F4E241
	Offset: 0x2A8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function press_sprint_button()
{
	self botpressbutton(1);
}

/*
	Name: release_sprint_button
	Namespace: bot
	Checksum: 0xC0CB8156
	Offset: 0x2D0
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function release_sprint_button()
{
	self botreleasebutton(1);
}

/*
	Name: press_frag_button
	Namespace: bot
	Checksum: 0xDA8D193C
	Offset: 0x2F8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function press_frag_button()
{
	self botpressbutton(14);
}

/*
	Name: release_frag_button
	Namespace: bot
	Checksum: 0xB1235AB2
	Offset: 0x320
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function release_frag_button()
{
	self botreleasebutton(14);
}

/*
	Name: tap_frag_button
	Namespace: bot
	Checksum: 0x43EC809C
	Offset: 0x348
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function tap_frag_button()
{
	self bottapbutton(14);
}

/*
	Name: press_offhand_button
	Namespace: bot
	Checksum: 0x68C94938
	Offset: 0x370
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function press_offhand_button()
{
	self botpressbutton(15);
}

/*
	Name: release_offhand_button
	Namespace: bot
	Checksum: 0xC60E6E25
	Offset: 0x398
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function release_offhand_button()
{
	self botreleasebutton(15);
}

/*
	Name: tap_offhand_button
	Namespace: bot
	Checksum: 0xEF948000
	Offset: 0x3C0
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function tap_offhand_button()
{
	self bottapbutton(15);
}

/*
	Name: press_throw_button
	Namespace: bot
	Checksum: 0xD3EFC323
	Offset: 0x3E8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function press_throw_button()
{
	self botpressbutton(24);
}

/*
	Name: release_throw_button
	Namespace: bot
	Checksum: 0x29270269
	Offset: 0x410
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function release_throw_button()
{
	self botreleasebutton(24);
}

/*
	Name: tap_jump_button
	Namespace: bot
	Checksum: 0x7E406C51
	Offset: 0x438
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function tap_jump_button()
{
	self bottapbutton(10);
}

/*
	Name: press_jump_button
	Namespace: bot
	Checksum: 0xE0BB035
	Offset: 0x460
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function press_jump_button()
{
	self botpressbutton(10);
}

/*
	Name: release_jump_button
	Namespace: bot
	Checksum: 0xC7AE8781
	Offset: 0x488
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function release_jump_button()
{
	self botreleasebutton(10);
}

/*
	Name: tap_ads_button
	Namespace: bot
	Checksum: 0x2D774993
	Offset: 0x4B0
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function tap_ads_button()
{
	self bottapbutton(11);
}

/*
	Name: press_ads_button
	Namespace: bot
	Checksum: 0x216C0D22
	Offset: 0x4D8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function press_ads_button()
{
	self botpressbutton(11);
}

/*
	Name: release_ads_button
	Namespace: bot
	Checksum: 0x9712A321
	Offset: 0x500
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function release_ads_button()
{
	self botreleasebutton(11);
}

/*
	Name: tap_doublejump_button
	Namespace: bot
	Checksum: 0xC260F5D0
	Offset: 0x528
	Size: 0x1C
	Parameters: 0
	Flags: None
*/
function tap_doublejump_button()
{
	self bottapbutton(65);
}

/*
	Name: press_doublejump_button
	Namespace: bot
	Checksum: 0xBF64306E
	Offset: 0x550
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function press_doublejump_button()
{
	self botpressbutton(65);
}

/*
	Name: release_doublejump_button
	Namespace: bot
	Checksum: 0x2FA85805
	Offset: 0x578
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function release_doublejump_button()
{
	self botreleasebutton(65);
}

/*
	Name: tap_offhand_special_button
	Namespace: bot
	Checksum: 0x4CCDE880
	Offset: 0x5A0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function tap_offhand_special_button()
{
	self bottapbutton(70);
}

/*
	Name: press_swim_up
	Namespace: bot
	Checksum: 0xF56FE6F8
	Offset: 0x5C8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function press_swim_up()
{
	self botpressbutton(67);
}

/*
	Name: release_swim_up
	Namespace: bot
	Checksum: 0xEA4C1900
	Offset: 0x5F0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function release_swim_up()
{
	self botreleasebutton(67);
}

/*
	Name: press_swim_down
	Namespace: bot
	Checksum: 0x5D43953C
	Offset: 0x618
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function press_swim_down()
{
	self botpressbutton(68);
}

/*
	Name: release_swim_down
	Namespace: bot
	Checksum: 0x87872C69
	Offset: 0x640
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function release_swim_down()
{
	self botreleasebutton(68);
}

