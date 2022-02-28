// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace lightning_chain;

/*
	Name: __init__sytem__
	Namespace: lightning_chain
	Checksum: 0x31266CCA
	Offset: 0x258
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("lightning_chain", &init, undefined, undefined);
}

/*
	Name: init
	Namespace: lightning_chain
	Checksum: 0x43B3577A
	Offset: 0x298
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level._effect["tesla_bolt"] = "zombie/fx_tesla_bolt_secondary_zmb";
	level._effect["tesla_shock"] = "zombie/fx_tesla_shock_zmb";
	level._effect["tesla_shock_secondary"] = "zombie/fx_tesla_bolt_secondary_zmb";
	level._effect["tesla_shock_nonfatal"] = "zombie/fx_bmode_shock_os_zod_zmb";
	level._effect["tesla_shock_eyes"] = "zombie/fx_tesla_shock_eyes_zmb";
	clientfield::register("actor", "lc_fx", 1, 2, "int", &lc_shock_fx, 0, 1);
	clientfield::register("vehicle", "lc_fx", 1, 2, "int", &lc_shock_fx, 0, 0);
	clientfield::register("actor", "lc_death_fx", 1, 2, "int", &lc_play_death_fx, 0, 0);
	clientfield::register("vehicle", "lc_death_fx", 8000, 2, "int", &lc_play_death_fx, 0, 0);
}

/*
	Name: lc_shock_fx
	Namespace: lightning_chain
	Checksum: 0x7A432861
	Offset: 0x450
	Size: 0x166
	Parameters: 7
	Flags: Linked
*/
function lc_shock_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(newval)
	{
		if(!isdefined(self.lc_shock_fx))
		{
			str_tag = "J_SpineUpper";
			str_fx = "tesla_shock";
			if(!self isai())
			{
				str_tag = "tag_origin";
			}
			if(newval > 1)
			{
				str_fx = "tesla_shock_secondary";
			}
			self.lc_shock_fx = playfxontag(localclientnum, level._effect[str_fx], self, str_tag);
			self playsound(0, "zmb_electrocute_zombie");
		}
	}
	else if(isdefined(self.lc_shock_fx))
	{
		stopfx(localclientnum, self.lc_shock_fx);
		self.lc_shock_fx = undefined;
	}
}

/*
	Name: lc_play_death_fx
	Namespace: lightning_chain
	Checksum: 0x9E4AC16F
	Offset: 0x5C0
	Size: 0x164
	Parameters: 7
	Flags: Linked
*/
function lc_play_death_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	str_tag = "J_SpineUpper";
	if(isdefined(self.isdog) && self.isdog)
	{
		str_tag = "J_Spine1";
	}
	if(!self.archetype === "zombie")
	{
		tag = "tag_origin";
	}
	switch(newval)
	{
		case 2:
		{
			str_fx = level._effect["tesla_shock_secondary"];
			break;
		}
		case 3:
		{
			str_fx = level._effect["tesla_shock_nonfatal"];
			break;
		}
		default:
		{
			str_fx = level._effect["tesla_shock"];
			break;
		}
	}
	playfxontag(localclientnum, str_fx, self, str_tag);
}

