// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\aat_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_aat_fire_works;

/*
	Name: __init__sytem__
	Namespace: zm_aat_fire_works
	Checksum: 0x466D6962
	Offset: 0x168
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_fire_works", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_aat_fire_works
	Checksum: 0x8DB38E05
	Offset: 0x1A8
	Size: 0xA6
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	aat::register("zm_aat_fire_works", "zmui_zm_aat_fire_works", "t7_icon_zm_aat_fire_works");
	clientfield::register("scriptmover", "zm_aat_fire_works", 1, 1, "int", &zm_aat_fire_works_summon, 0, 0);
	level._effect["zm_aat_fire_works"] = "zombie/fx_aat_fireworks_zmb";
}

/*
	Name: zm_aat_fire_works_summon
	Namespace: zm_aat_fire_works
	Checksum: 0xF595EF0E
	Offset: 0x258
	Size: 0x116
	Parameters: 7
	Flags: Linked
*/
function zm_aat_fire_works_summon(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.aat_fire_works_fx = playfx(localclientnum, "zombie/fx_aat_fireworks_zmb", self.origin, anglestoforward(self.angles));
		playsound(localclientnum, "wpn_aat_firework_explo", self.origin);
		if(isdemoplaying())
		{
			self thread kill_fx_on_demo_jump(localclientnum);
		}
	}
	else if(isdefined(self.aat_fire_works_fx))
	{
		self notify(#"kill_fx_on_demo_jump");
		stopfx(localclientnum, self.aat_fire_works_fx);
		self.aat_fire_works_fx = undefined;
	}
}

/*
	Name: kill_fx_on_demo_jump
	Namespace: zm_aat_fire_works
	Checksum: 0x68A80B30
	Offset: 0x378
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function kill_fx_on_demo_jump(localclientnum)
{
	self notify(#"kill_fx_on_demo_jump");
	self endon(#"kill_fx_on_demo_jump");
	level waittill(#"demo_jump");
	if(isdefined(self.aat_fire_works_fx))
	{
		stopfx(localclientnum, self.aat_fire_works_fx);
		self.aat_fire_works_fx = undefined;
	}
}

