// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerup_ww_grenade;

#namespace zm_perk_widows_wine;

/*
	Name: __init__sytem__
	Namespace: zm_perk_widows_wine
	Checksum: 0xD666C4AA
	Offset: 0x2D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_widows_wine", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_widows_wine
	Checksum: 0x84597B28
	Offset: 0x318
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_perks::register_perk_clientfields("specialty_widowswine", &widows_wine_client_field_func, &widows_wine_code_callback_func);
	zm_perks::register_perk_effects("specialty_widowswine", "widow_light");
	zm_perks::register_perk_init_thread("specialty_widowswine", &init_widows_wine);
	clientfield::register("toplayer", "widows_wine_1p_contact_explosion", 1, 1, "counter", &widows_wine_1p_contact_explosion, 0, 0);
}

/*
	Name: init_widows_wine
	Namespace: zm_perk_widows_wine
	Checksum: 0x6A7E7C02
	Offset: 0x3F0
	Size: 0x52
	Parameters: 0
	Flags: Linked
*/
function init_widows_wine()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["widow_light"] = "zombie/fx_perk_widows_wine_zmb";
		level._effect["widows_wine_wrap"] = "zombie/fx_widows_wrap_torso_zmb";
	}
}

/*
	Name: widows_wine_client_field_func
	Namespace: zm_perk_widows_wine
	Checksum: 0x3CB4E66D
	Offset: 0x450
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function widows_wine_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.widows_wine", 1, 2, "int", undefined, 0, 1);
	clientfield::register("actor", "widows_wine_wrapping", 1, 1, "int", &widows_wine_wrap_cb, 0, 1);
	clientfield::register("vehicle", "widows_wine_wrapping", 1, 1, "int", &widows_wine_wrap_cb, 0, 0);
}

/*
	Name: widows_wine_code_callback_func
	Namespace: zm_perk_widows_wine
	Checksum: 0x99EC1590
	Offset: 0x528
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function widows_wine_code_callback_func()
{
}

/*
	Name: widows_wine_wrap_cb
	Namespace: zm_perk_widows_wine
	Checksum: 0xD4216FC4
	Offset: 0x538
	Size: 0x194
	Parameters: 7
	Flags: Linked
*/
function widows_wine_wrap_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(isdefined(self) && isalive(self))
		{
			if(!isdefined(self.fx_widows_wine_wrap))
			{
				self.fx_widows_wine_wrap = playfxontag(localclientnum, level._effect["widows_wine_wrap"], self, "j_spineupper");
			}
			if(!isdefined(self.sndwidowswine))
			{
				self playsound(0, "wpn_wwgrenade_cocoon_imp");
				self.sndwidowswine = self playloopsound("wpn_wwgrenade_cocoon_lp", 0.1);
			}
		}
	}
	else
	{
		if(isdefined(self.fx_widows_wine_wrap))
		{
			stopfx(localclientnum, self.fx_widows_wine_wrap);
			self.fx_widows_wine_wrap = undefined;
		}
		if(isdefined(self.sndwidowswine))
		{
			self playsound(0, "wpn_wwgrenade_cocoon_stop");
			self stoploopsound(self.sndwidowswine, 0.1);
		}
	}
}

/*
	Name: widows_wine_1p_contact_explosion
	Namespace: zm_perk_widows_wine
	Checksum: 0xB25D1288
	Offset: 0x6D8
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function widows_wine_1p_contact_explosion(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	owner = self getowner(localclientnum);
	if(isdefined(owner) && owner == getlocalplayer(localclientnum))
	{
		thread widows_wine_1p_contact_explosion_play(localclientnum);
	}
}

/*
	Name: widows_wine_1p_contact_explosion_play
	Namespace: zm_perk_widows_wine
	Checksum: 0xFBB3E994
	Offset: 0x780
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function widows_wine_1p_contact_explosion_play(localclientnum)
{
	tag = "tag_flash";
	if(!viewmodelhastag(localclientnum, tag))
	{
		tag = "tag_weapon";
		if(!viewmodelhastag(localclientnum, tag))
		{
			return;
		}
	}
	fx_contact_explosion = playviewmodelfx(localclientnum, "zombie/fx_widows_exp_1p_zmb", tag);
	wait(2);
	deletefx(localclientnum, fx_contact_explosion, 1);
}

