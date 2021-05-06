// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace zm_tomb_quest_fire;

/*
	Name: main
	Namespace: zm_tomb_quest_fire
	Checksum: 0x9F4233FC
	Offset: 0x1A8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	clientfield::register("scriptmover", "barbecue_fx", 21000, 1, "int", &barbecue_fx, 0, 0);
}

/*
	Name: function_f53f6b0a
	Namespace: zm_tomb_quest_fire
	Checksum: 0x7BEC3A4F
	Offset: 0x200
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function function_f53f6b0a(localclientnum)
{
	self notify(#"stop_bbq_fx_loop");
	self endon(#"stop_bbq_fx_loop");
	self endon(#"entityshutdown");
	while(true)
	{
		playfxontag(localclientnum, level._effect["fire_sacrifice_flame"], self, "tag_origin");
		wait(0.5);
	}
}

/*
	Name: barbecue_fx
	Namespace: zm_tomb_quest_fire
	Checksum: 0x47660F45
	Offset: 0x280
	Size: 0x86
	Parameters: 7
	Flags: Linked
*/
function barbecue_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self thread function_f53f6b0a(localclientnum);
		level thread function_ebebc90(self);
	}
	else
	{
		self notify(#"stop_bbq_fx_loop");
	}
}

/*
	Name: function_ebebc90
	Namespace: zm_tomb_quest_fire
	Checksum: 0x2CA25794
	Offset: 0x310
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_ebebc90(entity)
{
	origin = entity.origin;
	audio::playloopat("zmb_squest_fire_bbq_lp", origin);
	entity util::waittill_any("stop_bbq_fx_loop", "entityshutdown");
	audio::stoploopat("zmb_squest_fire_bbq_lp", origin);
}

