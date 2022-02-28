// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_elemental_zombies;

#namespace zm_shadow_zombie;

/*
	Name: __init__sytem__
	Namespace: zm_shadow_zombie
	Checksum: 0xE4D80363
	Offset: 0x3C8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_shadow_zombie", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_shadow_zombie
	Checksum: 0xFC736E13
	Offset: 0x408
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
	Namespace: zm_shadow_zombie
	Checksum: 0xE77BBFA5
	Offset: 0x438
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function init_fx()
{
	level._effect["shadow_zombie_fx"] = "dlc4/genesis/fx_zombie_shadow_ambient_trail";
	level._effect["shadow_zombie_suicide"] = "dlc4/genesis/fx_zombie_shadow_death";
	level._effect["dlc4/genesis/fx_zombie_shadow_damage"] = "shadow_zombie_damage_fx";
	if(!isdefined(level._effect["mini_curse_circle"]))
	{
		level._effect["mini_curse_circle"] = "dlc4/genesis/fx_zombie_shadow_trap_ambient";
	}
}

/*
	Name: register_clientfields
	Namespace: zm_shadow_zombie
	Checksum: 0xF52FFAC4
	Offset: 0x4D0
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("actor", "shadow_zombie_clientfield_aura_fx", 15000, 1, "int", &function_384150e9, 0, 0);
	clientfield::register("actor", "shadow_zombie_clientfield_death_fx", 15000, 1, "int", &function_ac1abcb6, 0, 0);
	clientfield::register("actor", "shadow_zombie_clientfield_damaged_fx", 15000, 1, "counter", &function_b3071651, 0, 0);
	clientfield::register("scriptmover", "shadow_zombie_cursetrap_fx", 15000, 1, "int", &shadow_zombie_cursetrap_fx, 0, 0);
}

/*
	Name: function_ac1abcb6
	Namespace: zm_shadow_zombie
	Checksum: 0x18E8E2EF
	Offset: 0x600
	Size: 0x98
	Parameters: 7
	Flags: Linked
*/
function function_ac1abcb6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(oldval !== newval && newval === 1)
	{
		fx = playfxontag(localclientnum, level._effect["shadow_zombie_suicide"], self, "j_spineupper");
	}
}

/*
	Name: function_b3071651
	Namespace: zm_shadow_zombie
	Checksum: 0x651A5EFB
	Offset: 0x6A0
	Size: 0x144
	Parameters: 7
	Flags: Linked
*/
function function_b3071651(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		if(isdefined(level._effect["dlc4/genesis/fx_zombie_shadow_damage"]))
		{
			playsound(localclientnum, "gdt_electro_bounce", self.origin);
			locs = array("j_wrist_le", "j_wrist_ri");
			fx = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_zombie_shadow_damage"], self, array::random(locs));
			setfxignorepause(localclientnum, fx, 1);
		}
	}
}

/*
	Name: function_384150e9
	Namespace: zm_shadow_zombie
	Checksum: 0xC2AB0E57
	Offset: 0x7F0
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function function_384150e9(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	if(newval == 1)
	{
		fx = playfxontag(localclientnum, level._effect["shadow_zombie_fx"], self, "j_spineupper");
		fx2 = playfxontag(localclientnum, level._effect["shadow_zombie_fx"], self, "j_head");
		setfxignorepause(localclientnum, fx, 1);
	}
}

/*
	Name: shadow_zombie_cursetrap_fx
	Namespace: zm_shadow_zombie
	Checksum: 0xF50F6103
	Offset: 0x8E8
	Size: 0x114
	Parameters: 7
	Flags: Linked
*/
function shadow_zombie_cursetrap_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.sndlooper))
	{
		self stoploopsound(self.sndlooper, 0.5);
		self.sndlooper = undefined;
		self playsound(0, "zmb_zod_cursed_landmine_end");
	}
	if(newval)
	{
		self.sndlooper = self playloopsound("zmb_zod_cursed_landmine_lp", 1);
		self playsound(0, "zmb_zod_cursed_landmine_start");
	}
	self function_267f859f(localclientnum, level._effect["mini_curse_circle"], newval, 1);
}

/*
	Name: function_267f859f
	Namespace: zm_shadow_zombie
	Checksum: 0x98BCBF9A
	Offset: 0xA08
	Size: 0x18E
	Parameters: 5
	Flags: Linked
*/
function function_267f859f(localclientnum, fx_id = undefined, b_on = 1, var_afcc5d76 = 0, str_tag = "tag_origin")
{
	if(b_on)
	{
		if(isdefined(self.vfx_ref))
		{
			stopfx(localclientnum, self.vfx_ref);
		}
		if(var_afcc5d76)
		{
			self.vfx_ref = playfxontag(localclientnum, fx_id, self, str_tag);
		}
		else
		{
			if(self.angles === (0, 0, 0))
			{
				self.vfx_ref = playfx(localclientnum, fx_id, self.origin);
			}
			else
			{
				self.vfx_ref = playfx(localclientnum, fx_id, self.origin, self.angles);
			}
		}
	}
	else if(isdefined(self.vfx_ref))
	{
		stopfx(localclientnum, self.vfx_ref);
		self.vfx_ref = undefined;
	}
}

