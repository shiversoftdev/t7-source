// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace dragon_strike;

/*
	Name: __init__sytem__
	Namespace: dragon_strike
	Checksum: 0x3B620DB8
	Offset: 0x490
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_dragon_strike", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: dragon_strike
	Checksum: 0x356358DD
	Offset: 0x4D0
	Size: 0x416
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "dragon_strike_spawn_fx", 12000, 1, "int", &dragon_strike_spawn_fx, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_on", 12000, 1, "int", &dragon_strike_marker_on, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_fx", 12000, 1, "counter", &dragon_strike_marker_fx, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_upgraded_fx", 12000, 1, "counter", &dragon_strike_marker_upgraded_fx, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_invalid_fx", 12000, 1, "counter", &dragon_strike_marker_invalid_fx, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_upgraded_invalid_fx", 12000, 1, "counter", &dragon_strike_marker_upgraded_invalid_fx, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_flare_fx", 12000, 1, "int", &dragon_strike_flare_fx, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_fx_fadeout", 12000, 1, "counter", &dragon_strike_marker_fx_fadeout, 0, 0);
	clientfield::register("scriptmover", "dragon_strike_marker_upgraded_fx_fadeout", 12000, 1, "counter", &dragon_strike_marker_upgraded_fx_fadeout, 0, 0);
	clientfield::register("actor", "dragon_strike_zombie_fire", 12000, 2, "int", &dragon_strike_zombie_fire, 0, 0);
	clientfield::register("vehicle", "dragon_strike_zombie_fire", 12000, 2, "int", &dragon_strike_zombie_fire, 0, 0);
	clientfield::register("clientuimodel", "dragon_strike_invalid_use", 12000, 1, "counter", undefined, 0, 0);
	clientfield::register("clientuimodel", "hudItems.showDpadRight_DragonStrike", 12000, 1, "int", undefined, 0, 0);
	level._effect["dragon_strike_portal"] = "dlc3/stalingrad/fx_dragonstrike_portal_flash";
	level._effect["dragon_strike_beacon"] = "dlc3/stalingrad/fx_light_flare_sky_marker_red";
	level._effect["dragon_strike_zombie_fire"] = "dlc3/stalingrad/fx_fire_torso_zmb_green";
	level._effect["dragon_strike_mouth"] = "dlc3/stalingrad/fx_dragon_mouth_drips_boss";
	level._effect["dragon_strike_tongue"] = "dlc3/stalingrad/fx_dragon_mouth_drips_tongue_boss";
}

/*
	Name: dragon_strike_spawn_fx
	Namespace: dragon_strike
	Checksum: 0x4C679876
	Offset: 0x8F0
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function dragon_strike_spawn_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfxontag(localclientnum, level._effect["dragon_strike_portal"], self, "tag_neck_fx");
		playfxontag(localclientnum, level._effect["dragon_strike_mouth"], self, "tag_throat_fx");
		playfxontag(localclientnum, level._effect["dragon_strike_tongue"], self, "tag_mouth_floor_fx");
	}
}

/*
	Name: dragon_strike_marker_on
	Namespace: dragon_strike
	Checksum: 0x3F7B2534
	Offset: 0x9D0
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function dragon_strike_marker_on(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self dragonstrike_enable(1);
		self thread function_778495b0(localclientnum);
	}
	else
	{
		self notify(#"hash_e98f7ec4");
		self dragonstrike_enable(0);
	}
}

/*
	Name: function_778495b0
	Namespace: dragon_strike
	Checksum: 0x79D6D7C0
	Offset: 0xA78
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function function_778495b0(localclientnum)
{
	self endon(#"hash_e98f7ec4");
	self endon(#"entityshutdown");
	while(isdefined(self))
	{
		self dragonstrike_setposition(self.origin);
		wait(0.016);
	}
}

/*
	Name: dragon_strike_marker_fx
	Namespace: dragon_strike
	Checksum: 0x222CEC20
	Offset: 0xAD0
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function dragon_strike_marker_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self dragonstrike_setcolorradiusspinpulse(0.25, 3, 0.25, 128, 0.5, 0);
}

/*
	Name: dragon_strike_marker_upgraded_fx
	Namespace: dragon_strike
	Checksum: 0xA0F6A8C8
	Offset: 0xB58
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function dragon_strike_marker_upgraded_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self dragonstrike_setcolorradiusspinpulse(0.15, 3, 0.15, 128, 0.75, 0);
}

/*
	Name: dragon_strike_marker_invalid_fx
	Namespace: dragon_strike
	Checksum: 0xABBF7E1F
	Offset: 0xBE0
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function dragon_strike_marker_invalid_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self dragonstrike_setcolorradiusspinpulse(4, 0.5, 0.25, 128, 0.5, 0);
}

/*
	Name: dragon_strike_marker_upgraded_invalid_fx
	Namespace: dragon_strike
	Checksum: 0xEF0E6351
	Offset: 0xC68
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function dragon_strike_marker_upgraded_invalid_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self dragonstrike_setcolorradiusspinpulse(4, 0.5, 0.25, 128, 0.75, 0);
}

/*
	Name: dragon_strike_flare_fx
	Namespace: dragon_strike
	Checksum: 0xC8E7EA1A
	Offset: 0xCF0
	Size: 0xB6
	Parameters: 7
	Flags: Linked
*/
function dragon_strike_flare_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.fx_flare = playfx(localclientnum, level._effect["dragon_strike_beacon"], self.origin);
	}
	else if(isdefined(self.fx_flare))
	{
		deletefx(localclientnum, self.fx_flare, 1);
		self.fx_flare = undefined;
	}
}

/*
	Name: dragon_strike_marker_fx_fadeout
	Namespace: dragon_strike
	Checksum: 0x235DE35D
	Offset: 0xDB0
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function dragon_strike_marker_fx_fadeout(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread function_1ba92b11(0.25, 3, 0.25, 0.5);
}

/*
	Name: dragon_strike_marker_upgraded_fx_fadeout
	Namespace: dragon_strike
	Checksum: 0x45C02EC4
	Offset: 0xE30
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function dragon_strike_marker_upgraded_fx_fadeout(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread function_1ba92b11(0.15, 3, 0.15, 0.75);
}

/*
	Name: function_1ba92b11
	Namespace: dragon_strike
	Checksum: 0x2189F563
	Offset: 0xEB0
	Size: 0xFE
	Parameters: 4
	Flags: Linked
*/
function function_1ba92b11(var_6d056a0e, var_9ad65443, var_cddc37e, var_76d07324)
{
	var_e0a873d1 = var_6d056a0e / 16;
	var_24ce51da = var_9ad65443 / 16;
	var_1e73d761 = var_cddc37e / 16;
	for(i = 0; i < 16; i++)
	{
		var_6d056a0e = var_6d056a0e - var_e0a873d1;
		var_9ad65443 = var_9ad65443 - var_24ce51da;
		var_cddc37e = var_cddc37e - var_1e73d761;
		self dragonstrike_setcolorradiusspinpulse(var_6d056a0e, var_9ad65443, var_cddc37e, 128, var_76d07324, 0);
		wait(0.016);
	}
}

/*
	Name: dragon_strike_zombie_fire
	Namespace: dragon_strike
	Checksum: 0x98E285C
	Offset: 0xFB8
	Size: 0x11C
	Parameters: 7
	Flags: Linked
*/
function dragon_strike_zombie_fire(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 2)
	{
		self zombie_death::flame_death_fx(localclientnum);
	}
	else
	{
		str_tag = "j_spinelower";
		v_tag = self gettagorigin(str_tag);
		if(!isdefined(v_tag))
		{
			str_tag = "tag_origin";
		}
		self.var_9f5c18b = 1;
		if(isdefined(self))
		{
			self.dragon_strike_zombie_fire = playfxontag(localclientnum, level._effect["dragon_strike_zombie_fire"], self, str_tag);
			self thread function_3cc1555d(localclientnum);
		}
	}
}

/*
	Name: function_3cc1555d
	Namespace: dragon_strike
	Checksum: 0x271D424
	Offset: 0x10E0
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function function_3cc1555d(localclientnum)
{
	self endon(#"entityshutdown");
	wait(12);
	if(isdefined(self) && isalive(self))
	{
		stopfx(localclientnum, self.dragon_strike_zombie_fire);
		self.var_9f5c18b = 0;
	}
}

