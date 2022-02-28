// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_elemental_zombies;

#namespace zm_light_zombie;

/*
	Name: __init__sytem__
	Namespace: zm_light_zombie
	Checksum: 0xB1B5EB6E
	Offset: 0x2F0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_light_zombie", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_light_zombie
	Checksum: 0x57C1363B
	Offset: 0x330
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_fx();
	register_clientfields();
}

/*
	Name: init_fx
	Namespace: zm_light_zombie
	Checksum: 0x40A47149
	Offset: 0x360
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function init_fx()
{
	level._effect["light_zombie_fx"] = "dlc1/zmb_weapon/fx_bow_wolf_wrap_torso";
	level._effect["light_zombie_suicide"] = "explosions/fx_exp_grenade_flshbng";
	level._effect["dlc1/zmb_weapon/fx_bow_wolf_impact_zm"] = "lihgt_zombie_damage_fx";
}

/*
	Name: register_clientfields
	Namespace: zm_light_zombie
	Checksum: 0xFD5B8FD5
	Offset: 0x3C0
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("actor", "light_zombie_clientfield_aura_fx", 15000, 1, "int", &function_98e8bc87, 0, 0);
	clientfield::register("actor", "light_zombie_clientfield_death_fx", 15000, 1, "int", &function_9127e2f8, 0, 0);
	clientfield::register("actor", "light_zombie_clientfield_damaged_fx", 15000, 1, "counter", &function_ad4789b4, 0, 0);
}

/*
	Name: function_9127e2f8
	Namespace: zm_light_zombie
	Checksum: 0xD3C8763
	Offset: 0x4A8
	Size: 0x98
	Parameters: 7
	Flags: Linked
*/
function function_9127e2f8(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(oldval !== newval && newval === 1)
	{
		fx = playfxontag(localclientnum, level._effect["light_zombie_suicide"], self, "j_spineupper");
	}
}

/*
	Name: function_ad4789b4
	Namespace: zm_light_zombie
	Checksum: 0x19E4ADF
	Offset: 0x548
	Size: 0x144
	Parameters: 7
	Flags: Linked
*/
function function_ad4789b4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(isdefined(level._effect["dlc1/zmb_weapon/fx_bow_wolf_impact_zm"]))
		{
			playsound(localclientnum, "gdt_electro_bounce", self.origin);
			locs = array("j_wrist_le", "j_wrist_ri");
			fx = playfxontag(localclientnum, level._effect["dlc1/zmb_weapon/fx_bow_wolf_impact_zm"], self, array::random(locs));
			setfxignorepause(localclientnum, fx, 1);
		}
	}
}

/*
	Name: function_98e8bc87
	Namespace: zm_light_zombie
	Checksum: 0x577939D8
	Offset: 0x698
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function function_98e8bc87(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	if(newval == 1)
	{
		fx = playfxontag(localclientnum, level._effect["light_zombie_fx"], self, "j_spineupper");
		setfxignorepause(localclientnum, fx, 1);
	}
}

