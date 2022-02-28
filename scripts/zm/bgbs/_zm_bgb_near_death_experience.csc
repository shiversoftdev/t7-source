// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_near_death_experience;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xAD32B558
	Offset: 0x220
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_near_death_experience", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xA21B77B
	Offset: 0x260
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("allplayers", "zm_bgb_near_death_experience_3p_fx", 15000, 1, "int", &function_24480126, 0, 0);
	clientfield::register("toplayer", "zm_bgb_near_death_experience_1p_fx", 15000, 1, "int", &function_11972f24, 0, 1);
	bgb::register("zm_bgb_near_death_experience", "rounds");
	level.var_3b53e98b = [];
}

/*
	Name: function_24480126
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xF9B89D2F
	Offset: 0x340
	Size: 0x128
	Parameters: 7
	Flags: Linked
*/
function function_24480126(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	e_local_player = getlocalplayer(localclientnum);
	if(newval)
	{
		if(e_local_player != self)
		{
			if(!isdefined(self.var_6b39dbae))
			{
				self.var_6b39dbae = [];
			}
			if(isdefined(self.var_6b39dbae[localclientnum]))
			{
				return;
			}
			self.var_6b39dbae[localclientnum] = playfxontag(localclientnum, "zombie/fx_bgb_near_death_3p", self, "j_spine4");
		}
	}
	else if(isdefined(self.var_6b39dbae) && isdefined(self.var_6b39dbae[localclientnum]))
	{
		stopfx(localclientnum, self.var_6b39dbae[localclientnum]);
		self.var_6b39dbae[localclientnum] = undefined;
	}
}

/*
	Name: function_11972f24
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xC232C717
	Offset: 0x470
	Size: 0xF8
	Parameters: 7
	Flags: Linked
*/
function function_11972f24(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(isdefined(level.var_3b53e98b[localclientnum]))
		{
			deletefx(localclientnum, level.var_3b53e98b[localclientnum]);
		}
		level.var_3b53e98b[localclientnum] = playfxoncamera(localclientnum, "zombie/fx_bgb_near_death_1p", (0, 0, 0), (1, 0, 0));
	}
	else if(isdefined(level.var_3b53e98b[localclientnum]))
	{
		stopfx(localclientnum, level.var_3b53e98b[localclientnum]);
		level.var_3b53e98b[localclientnum] = undefined;
	}
}

