// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_ai_mechz_claw;

/*
	Name: __init__sytem__
	Namespace: zm_ai_mechz_claw
	Checksum: 0x89E45E09
	Offset: 0x1B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_mechz_claw", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_mechz_claw
	Checksum: 0x4C4D1B5D
	Offset: 0x1F0
	Size: 0x13C
	Parameters: 0
	Flags: Linked, Private
*/
function private __init__()
{
	clientfield::register("actor", "mechz_fx", 21000, 12, "int", &function_22b149ce, 0, 0);
	clientfield::register("scriptmover", "mechz_claw", 21000, 1, "int", &function_2ad55883, 0, 0);
	clientfield::register("actor", "mechz_wpn_source", 21000, 1, "int", &function_54ae128d, 0, 0);
	clientfield::register("toplayer", "mechz_grab", 21000, 1, "int", &function_8dfa08c1, 0, 0);
	level.mechz_detach_claw_override = &mechz_detach_claw_override;
}

/*
	Name: __main__
	Namespace: zm_ai_mechz_claw
	Checksum: 0x99EC1590
	Offset: 0x338
	Size: 0x4
	Parameters: 0
	Flags: Private
*/
function private __main__()
{
}

/*
	Name: mechz_detach_claw_override
	Namespace: zm_ai_mechz_claw
	Checksum: 0xF9F83FD2
	Offset: 0x348
	Size: 0x174
	Parameters: 7
	Flags: Linked, Private
*/
function private mechz_detach_claw_override(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	pos = self gettagorigin("tag_claw");
	ang = self gettagangles("tag_claw");
	velocity = self getvelocity();
	dynent = createdynentandlaunch(localclientnum, "c_t7_zm_dlchd_origins_mech_claw", pos, ang, self.origin, velocity);
	playfxontag(localclientnum, level._effect["fx_mech_dmg_armor"], self, "tag_grappling_source_fx");
	self playsound(0, "zmb_ai_mechz_destruction");
	playfxontag(localclientnum, level._effect["fx_mech_dmg_sparks"], self, "tag_grappling_source_fx");
}

/*
	Name: function_22b149ce
	Namespace: zm_ai_mechz_claw
	Checksum: 0x9A423DC9
	Offset: 0x4C8
	Size: 0x3C
	Parameters: 7
	Flags: Linked, Private
*/
function private function_22b149ce(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
}

/*
	Name: function_2ad55883
	Namespace: zm_ai_mechz_claw
	Checksum: 0xC5EF36F3
	Offset: 0x510
	Size: 0x74
	Parameters: 7
	Flags: Linked, Private
*/
function private function_2ad55883(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		playfxontag(localclientnum, level._effect["mechz_claw"], self, "tag_origin");
	}
}

/*
	Name: function_54ae128d
	Namespace: zm_ai_mechz_claw
	Checksum: 0x4388791F
	Offset: 0x590
	Size: 0xB6
	Parameters: 7
	Flags: Linked, Private
*/
function private function_54ae128d(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		self.var_ba7e45cf = playfxontag(localclientnum, level._effect["mechz_wpn_source"], self, "j_elbow_le");
	}
	else if(isdefined(self.var_ba7e45cf))
	{
		stopfx(localclientnum, self.var_ba7e45cf);
		self.var_ba7e45cf = undefined;
	}
}

/*
	Name: function_8dfa08c1
	Namespace: zm_ai_mechz_claw
	Checksum: 0x92ADCC87
	Offset: 0x650
	Size: 0x74
	Parameters: 7
	Flags: Linked, Private
*/
function private function_8dfa08c1(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		self hideviewlegs();
	}
	else
	{
		self showviewlegs();
	}
}

