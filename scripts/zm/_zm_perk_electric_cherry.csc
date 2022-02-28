// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_zm_perks;

#namespace zm_perk_electric_cherry;

/*
	Name: __init__sytem__
	Namespace: zm_perk_electric_cherry
	Checksum: 0x1158C942
	Offset: 0x380
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_electric_cherry", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_electric_cherry
	Checksum: 0x25DBBEA6
	Offset: 0x3C0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_perks::register_perk_clientfields("specialty_electriccherry", &electric_cherry_client_field_func, &electric_cherry_code_callback_func);
	zm_perks::register_perk_effects("specialty_electriccherry", "electric_light");
	zm_perks::register_perk_init_thread("specialty_electriccherry", &init_electric_cherry);
}

/*
	Name: init_electric_cherry
	Namespace: zm_perk_electric_cherry
	Checksum: 0x12B7F7BF
	Offset: 0x450
	Size: 0x226
	Parameters: 0
	Flags: Linked
*/
function init_electric_cherry()
{
	if(isdefined(level.enable_magic) && level.enable_magic)
	{
		level._effect["electric_light"] = "_t6/misc/fx_zombie_cola_revive_on";
	}
	registerclientfield("allplayers", "electric_cherry_reload_fx", 1, 2, "int", &electric_cherry_reload_attack_fx, 0);
	clientfield::register("actor", "tesla_death_fx", 1, 1, "int", &tesla_death_fx_callback, 0, 0);
	clientfield::register("vehicle", "tesla_death_fx_veh", 10000, 1, "int", &tesla_death_fx_callback, 0, 0);
	clientfield::register("actor", "tesla_shock_eyes_fx", 1, 1, "int", &tesla_shock_eyes_fx_callback, 0, 0);
	clientfield::register("vehicle", "tesla_shock_eyes_fx_veh", 10000, 1, "int", &tesla_shock_eyes_fx_callback, 0, 0);
	level._effect["electric_cherry_explode"] = "dlc1/castle/fx_castle_electric_cherry_down";
	level._effect["electric_cherry_trail"] = "dlc1/castle/fx_castle_electric_cherry_trail";
	level._effect["tesla_death_cherry"] = "zombie/fx_tesla_shock_zmb";
	level._effect["tesla_shock_eyes_cherry"] = "zombie/fx_tesla_shock_eyes_zmb";
	level._effect["tesla_shock_cherry"] = "zombie/fx_bmode_shock_os_zod_zmb";
}

/*
	Name: electric_cherry_client_field_func
	Namespace: zm_perk_electric_cherry
	Checksum: 0x6683C13D
	Offset: 0x680
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function electric_cherry_client_field_func()
{
	clientfield::register("clientuimodel", "hudItems.perks.electric_cherry", 1, 2, "int", undefined, 0, 1);
}

/*
	Name: electric_cherry_code_callback_func
	Namespace: zm_perk_electric_cherry
	Checksum: 0x99EC1590
	Offset: 0x6C8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function electric_cherry_code_callback_func()
{
}

/*
	Name: electric_cherry_reload_attack_fx
	Namespace: zm_perk_electric_cherry
	Checksum: 0x49A79681
	Offset: 0x6D8
	Size: 0x176
	Parameters: 7
	Flags: Linked
*/
function electric_cherry_reload_attack_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.electric_cherry_reload_fx))
	{
		stopfx(localclientnum, self.electric_cherry_reload_fx);
	}
	if(newval == 1)
	{
		self.electric_cherry_reload_fx = playfxontag(localclientnum, level._effect["electric_cherry_explode"], self, "tag_origin");
	}
	else
	{
		if(newval == 2)
		{
			self.electric_cherry_reload_fx = playfxontag(localclientnum, level._effect["electric_cherry_explode"], self, "tag_origin");
		}
		else
		{
			if(newval == 3)
			{
				self.electric_cherry_reload_fx = playfxontag(localclientnum, level._effect["electric_cherry_explode"], self, "tag_origin");
			}
			else
			{
				if(isdefined(self.electric_cherry_reload_fx))
				{
					stopfx(localclientnum, self.electric_cherry_reload_fx);
				}
				self.electric_cherry_reload_fx = undefined;
			}
		}
	}
}

/*
	Name: tesla_death_fx_callback
	Namespace: zm_perk_electric_cherry
	Checksum: 0xFF85CBD4
	Offset: 0x858
	Size: 0x12E
	Parameters: 7
	Flags: Linked
*/
function tesla_death_fx_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		str_tag = "J_SpineUpper";
		if(isdefined(self.str_tag_tesla_death_fx))
		{
			str_tag = self.str_tag_tesla_death_fx;
		}
		else if(isdefined(self.isdog) && self.isdog)
		{
			str_tag = "J_Spine1";
		}
		self.n_death_fx = playfxontag(localclientnum, level._effect["tesla_death_cherry"], self, str_tag);
		setfxignorepause(localclientnum, self.n_death_fx, 1);
	}
	else
	{
		if(isdefined(self.n_death_fx))
		{
			deletefx(localclientnum, self.n_death_fx, 1);
		}
		self.n_death_fx = undefined;
	}
}

/*
	Name: tesla_shock_eyes_fx_callback
	Namespace: zm_perk_electric_cherry
	Checksum: 0x5721B02D
	Offset: 0x990
	Size: 0x1C6
	Parameters: 7
	Flags: Linked
*/
function tesla_shock_eyes_fx_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		str_tag = "J_SpineUpper";
		if(isdefined(self.str_tag_tesla_shock_eyes_fx))
		{
			str_tag = self.str_tag_tesla_shock_eyes_fx;
		}
		else if(isdefined(self.isdog) && self.isdog)
		{
			str_tag = "J_Spine1";
		}
		self.n_shock_eyes_fx = playfxontag(localclientnum, level._effect["tesla_shock_eyes_cherry"], self, "J_Eyeball_LE");
		setfxignorepause(localclientnum, self.n_shock_eyes_fx, 1);
		self.n_shock_fx = playfxontag(localclientnum, level._effect["tesla_death_cherry"], self, str_tag);
		setfxignorepause(localclientnum, self.n_shock_fx, 1);
	}
	else
	{
		if(isdefined(self.n_shock_eyes_fx))
		{
			deletefx(localclientnum, self.n_shock_eyes_fx, 1);
			self.n_shock_eyes_fx = undefined;
		}
		if(isdefined(self.n_shock_fx))
		{
			deletefx(localclientnum, self.n_shock_fx, 1);
			self.n_shock_fx = undefined;
		}
	}
}

