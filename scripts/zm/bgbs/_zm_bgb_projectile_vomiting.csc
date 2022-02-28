// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_projectile_vomiting;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_projectile_vomiting
	Checksum: 0x6DCE8D5F
	Offset: 0x248
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_projectile_vomiting", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_projectile_vomiting
	Checksum: 0xCC0EAEA8
	Offset: 0x288
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("actor", "projectile_vomit", 12000, 1, "counter", &function_6ac13208, 0, 0);
	bgb::register("zm_bgb_projectile_vomiting", "rounds");
	level._effect["bgb_puke_reaction"] = "zombie/fx_liquid_vomit_stream_zmb";
	level._effect["bgb_puke_reaction_no_head"] = "zombie/fx_liquid_vomit_stream_neck_zmb";
	level.var_e0154011 = 0;
}

/*
	Name: function_6ac13208
	Namespace: zm_bgb_projectile_vomiting
	Checksum: 0xB59A22BA
	Offset: 0x358
	Size: 0x10C
	Parameters: 7
	Flags: Linked
*/
function function_6ac13208(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(level.var_e0154011 < 10)
	{
		if(gibclientutils::isgibbed(localclientnum, self, 8))
		{
			playfxontag(localclientnum, level._effect["bgb_puke_reaction_no_head"], self, "j_neck");
		}
		else
		{
			playfxontag(localclientnum, level._effect["bgb_puke_reaction"], self, "j_neck");
		}
		self playsound(0, "zmb_bgb_vomit_vox");
		level thread function_6d325051();
	}
}

/*
	Name: function_6d325051
	Namespace: zm_bgb_projectile_vomiting
	Checksum: 0x3D371B8D
	Offset: 0x470
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_6d325051()
{
	level.var_e0154011++;
	wait(1);
	level.var_e0154011--;
}

