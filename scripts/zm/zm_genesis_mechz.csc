// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_genesis_mechz;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_mechz
	Checksum: 0xF7C34F46
	Offset: 0x2B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_mechz", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_mechz
	Checksum: 0xCF13C96E
	Offset: 0x2F0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["tesla_zombie_shock"] = "dlc4/genesis/fx_elec_trap_body_shock";
	if(ai::shouldregisterclientfieldforarchetype("mechz"))
	{
		clientfield::register("actor", "death_ray_shock_fx", 15000, 1, "int", &death_ray_shock_fx, 0, 0);
	}
	clientfield::register("actor", "mechz_fx_spawn", 15000, 1, "counter", &function_4b9cfd4c, 0, 0);
}

/*
	Name: death_ray_shock_fx
	Namespace: zm_genesis_mechz
	Checksum: 0x6328DA43
	Offset: 0x3C0
	Size: 0x124
	Parameters: 7
	Flags: Linked
*/
function death_ray_shock_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self function_51adc559(localclientnum);
	if(newval)
	{
		if(!isdefined(self.tesla_shock_fx))
		{
			tag = "J_SpineUpper";
			if(!self isai())
			{
				tag = "tag_origin";
			}
			self.tesla_shock_fx = playfxontag(localclientnum, level._effect["tesla_zombie_shock"], self, tag);
			self playsound(0, "zmb_electrocute_zombie");
		}
		if(isdemoplaying())
		{
			self thread function_7772592b(localclientnum);
		}
	}
}

/*
	Name: function_7772592b
	Namespace: zm_genesis_mechz
	Checksum: 0xF53BC5BA
	Offset: 0x4F0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_7772592b(localclientnum)
{
	self notify(#"hash_51adc559");
	self endon(#"hash_51adc559");
	level waittill(#"demo_jump");
	self function_51adc559(localclientnum);
}

/*
	Name: function_51adc559
	Namespace: zm_genesis_mechz
	Checksum: 0xB537C374
	Offset: 0x548
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function function_51adc559(localclientnum)
{
	if(isdefined(self.tesla_shock_fx))
	{
		deletefx(localclientnum, self.tesla_shock_fx, 1);
		self.tesla_shock_fx = undefined;
	}
	self notify(#"hash_51adc559");
}

/*
	Name: function_4b9cfd4c
	Namespace: zm_genesis_mechz
	Checksum: 0xEDC769C0
	Offset: 0x5A8
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_4b9cfd4c(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		self.spawnfx = playfxontag(localclientnum, level._effect["mechz_ground_spawn"], self, "tag_origin");
		playsound(0, "zmb_mechz_spawn_nofly", self.origin);
	}
}

