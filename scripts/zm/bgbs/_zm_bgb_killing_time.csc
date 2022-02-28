// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_killing_time;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_killing_time
	Checksum: 0xC0FA76BD
	Offset: 0x1D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_killing_time", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_killing_time
	Checksum: 0x57DE1A93
	Offset: 0x218
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_killing_time", "activated");
	clientfield::register("actor", "zombie_instakill_fx", 1, 1, "int", &function_a81107fc, 0, 1);
	clientfield::register("toplayer", "instakill_upgraded_fx", 1, 1, "int", &function_cf8c9fce, 0, 0);
}

/*
	Name: function_cf8c9fce
	Namespace: zm_bgb_killing_time
	Checksum: 0x53C00BA2
	Offset: 0x2F0
	Size: 0x56
	Parameters: 7
	Flags: Linked
*/
function function_cf8c9fce(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
	}
	else
	{
		self notify(#"hash_eb366021");
	}
}

/*
	Name: function_2a30e2ca
	Namespace: zm_bgb_killing_time
	Checksum: 0x6E3D244B
	Offset: 0x350
	Size: 0x86
	Parameters: 1
	Flags: None
*/
function function_2a30e2ca(localclientnum)
{
	self endon(#"death");
	self endon(#"end_demo_jump_listener");
	self endon(#"entityshutdown");
	self notify(#"hash_eb366021");
	self endon(#"hash_eb366021");
	while(true)
	{
		self.var_dedf9511 = self playsound(localclientnum, "zmb_music_box", self.origin);
		wait(4);
	}
}

/*
	Name: function_a81107fc
	Namespace: zm_bgb_killing_time
	Checksum: 0x13EBA211
	Offset: 0x3E0
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_a81107fc(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	if(newval)
	{
		fxobj = util::spawn_model(localclientnum, "tag_origin", self.origin, self.angles);
		fxobj thread function_10dcbf51(localclientnum, fxobj);
	}
}

/*
	Name: function_10dcbf51
	Namespace: zm_bgb_killing_time
	Checksum: 0x4D0D7EF4
	Offset: 0x490
	Size: 0x54
	Parameters: 2
	Flags: Linked, Private
*/
function private function_10dcbf51(localclientnum, fxobj)
{
	fxobj playsound(localclientnum, "evt_ai_explode");
	wait(1);
	fxobj delete();
}

