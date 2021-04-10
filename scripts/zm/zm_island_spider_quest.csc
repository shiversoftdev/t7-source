// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#using_animtree("generic");

#namespace zm_island_spider_quest;

/*
	Name: init
	Namespace: zm_island_spider_quest
	Checksum: 0xC0F65DD8
	Offset: 0x250
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function init()
{
	var_8b462b02 = getminbitcountfornum(2);
	var_fbab08c0 = getminbitcountfornum(3);
	clientfield::register("scriptmover", "spider_queen_mouth_weakspot", 9000, var_8b462b02, "int", &spider_queen_mouth_weakspot, 0, 0);
	clientfield::register("scriptmover", "spider_queen_bleed", 9000, 1, "counter", &spider_queen_bleed, 0, 0);
	clientfield::register("scriptmover", "spider_queen_stage_bleed", 9000, var_fbab08c0, "int", &spider_queen_stage_bleed, 0, 0);
	clientfield::register("scriptmover", "spider_queen_emissive_material", 9000, 1, "int", &spider_queen_emissive_material, 0, 0);
}

/*
	Name: spider_queen_mouth_weakspot
	Namespace: zm_island_spider_quest
	Checksum: 0x7974707B
	Offset: 0x3C0
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function spider_queen_mouth_weakspot(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_8dd4267f))
	{
		stopfx(localclientnum, self.var_8dd4267f);
		self.var_8dd4267f = undefined;
	}
	if(newval == 1)
	{
		self.var_8dd4267f = playfxontag(localclientnum, level._effect["spider_queen_weakspot"], self, "tag_turret");
	}
	else if(newval == 2)
	{
		self.var_8dd4267f = playfxontag(localclientnum, level._effect["spider_queen_mouth_glow"], self, "tag_turret");
	}
}

/*
	Name: spider_queen_bleed
	Namespace: zm_island_spider_quest
	Checksum: 0xA74FC48E
	Offset: 0x4C8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function spider_queen_bleed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["spider_queen_bleed_sm"], self, "tag_turret");
}

/*
	Name: spider_queen_stage_bleed
	Namespace: zm_island_spider_quest
	Checksum: 0xAAF8E76E
	Offset: 0x540
	Size: 0x14E
	Parameters: 7
	Flags: Linked
*/
function spider_queen_stage_bleed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_770499e7 = playfxontag(localclientnum, level._effect["spider_queen_bleed_lg"], self, "tag_turret");
	}
	if(newval == 2)
	{
		self.var_770499e7 = playfxontag(localclientnum, level._effect["spider_queen_bleed_md"], self, "tag_turret");
	}
	if(newval == 3)
	{
		self.var_770499e7 = playfxontag(localclientnum, level._effect["spider_queen_bleed_md"], self, "tag_turret");
	}
	wait(2.5);
	if(isdefined(self.var_770499e7))
	{
		stopfx(localclientnum, self.var_770499e7);
		self.var_770499e7 = undefined;
	}
}

/*
	Name: spider_queen_emissive_material
	Namespace: zm_island_spider_quest
	Checksum: 0x18DF7CF9
	Offset: 0x698
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function spider_queen_emissive_material(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 1, 1, 1, 0);
	}
	else
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
	}
}

