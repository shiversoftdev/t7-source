// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_aat_turned;

/*
	Name: __init__sytem__
	Namespace: zm_aat_turned
	Checksum: 0xF81D8648
	Offset: 0x190
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_turned", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_aat_turned
	Checksum: 0x392D117A
	Offset: 0x1D0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	aat::register("zm_aat_turned", "zmui_zm_aat_turned", "t7_icon_zm_aat_turned");
	clientfield::register("actor", "zm_aat_turned", 1, 1, "int", &zm_aat_turned_cb, 0, 0);
}

/*
	Name: zm_aat_turned_cb
	Namespace: zm_aat_turned
	Checksum: 0xDF75BB67
	Offset: 0x268
	Size: 0x166
	Parameters: 7
	Flags: Linked
*/
function zm_aat_turned_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self setdrawname(makelocalizedstring("zmui_zm_aat_turned"), 1);
		self.fx_aat_turned_eyes = playfxontag(localclientnum, "zombie/fx_glow_eye_green", self, "j_eyeball_le");
		self.fx_aat_turned_torso = playfxontag(localclientnum, "zombie/fx_aat_turned_spore_torso_zmb", self, "j_spine4");
		self playsound(localclientnum, "");
	}
	else
	{
		if(isdefined(self.fx_aat_turned_eyes))
		{
			stopfx(localclientnum, self.fx_aat_turned_eyes);
			self.fx_aat_turned_eyes = undefined;
		}
		if(isdefined(self.fx_aat_turned_torso))
		{
			stopfx(localclientnum, self.fx_aat_turned_torso);
			self.fx_aat_turned_torso = undefined;
		}
	}
}

