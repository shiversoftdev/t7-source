// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace mirg2000;

/*
	Name: __init__sytem__
	Namespace: mirg2000
	Checksum: 0xEA92BE10
	Offset: 0x4D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("mirg2000", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: mirg2000
	Checksum: 0x536A33D7
	Offset: 0x518
	Size: 0x2DA
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "plant_killer", 9000, getminbitcountfornum(4), "int", &function_23a70949, 0, 0);
	clientfield::register("vehicle", "mirg2000_spider_death_fx", 9000, 2, "int", &function_1d3d9723, 0, 0);
	clientfield::register("actor", "mirg2000_enemy_impact_fx", 9000, 2, "int", &function_15ad909d, 0, 0);
	clientfield::register("vehicle", "mirg2000_enemy_impact_fx", 9000, 2, "int", &function_15ad909d, 0, 0);
	clientfield::register("allplayers", "mirg2000_fire_button_held_sound", 9000, 1, "int", &mirg2000_fire_button_held_sound, 0, 0);
	clientfield::register("toplayer", "mirg2000_charge_glow", 9000, 2, "int", &mirg2000_charge_glow, 0, 0);
	level._effect["mirg2000_charged_shot_1"] = "dlc2/zmb_weapon/fx_mirg_impact_aoe_chrg2";
	level._effect["mirg2000_charged_shot_2"] = "dlc2/zmb_weapon/fx_mirg_impact_aoe_chrg3";
	level._effect["mirg2000_charged_shot_1_up"] = "dlc2/zmb_weapon/fx_mirg_impact_aoe_chrg2_ug";
	level._effect["mirg2000_charged_shot_2_up"] = "dlc2/zmb_weapon/fx_mirg_impact_aoe_chrg3_ug";
	level._effect["mirg2000_spider_death_fx"] = "dlc2/island/fx_spider_death_explo_mirg";
	level._effect["mirg2000_spider_death_fx_up"] = "dlc2/island/fx_spider_death_explo_mirg_ug";
	level._effect["mirg2000_enemy_impact"] = "dlc2/zmb_weapon/fx_mirg_impact_explo_default";
	level._effect["mirg2000_enemy_impact_up"] = "dlc2/zmb_weapon/fx_mirg_impact_explo_ug";
	level._effect["mirg2000_glow"] = "dlc2/zmb_weapon/fx_mirg_weapon_canister_light_green";
	level._effect["mirg2000_glow_up"] = "dlc2/zmb_weapon/fx_mirg_weapon_canister_light_blue";
}

/*
	Name: function_23a70949
	Namespace: mirg2000
	Checksum: 0x5F993857
	Offset: 0x800
	Size: 0x1DE
	Parameters: 7
	Flags: Linked
*/
function function_23a70949(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 0:
		{
			if(isdefined(self.var_b5dfc765))
			{
				stopfx(localclientnum, self.var_b5dfc765);
			}
			break;
		}
		case 1:
		{
			self.var_b5dfc765 = playfxontag(localclientnum, level._effect["mirg2000_charged_shot_1"], self, "tag_origin");
			break;
		}
		case 2:
		{
			self.var_b5dfc765 = playfxontag(localclientnum, level._effect["mirg2000_charged_shot_2"], self, "tag_origin");
			break;
		}
		case 3:
		{
			self.var_b5dfc765 = playfxontag(localclientnum, level._effect["mirg2000_charged_shot_1_up"], self, "tag_origin");
			break;
		}
		case 4:
		{
			self.var_b5dfc765 = playfxontag(localclientnum, level._effect["mirg2000_charged_shot_2_up"], self, "tag_origin");
			break;
		}
		default:
		{
			if(isdefined(self.var_b5dfc765))
			{
				stopfx(localclientnum, self.var_b5dfc765);
			}
			break;
		}
	}
}

/*
	Name: function_15ad909d
	Namespace: mirg2000
	Checksum: 0xA6E33B24
	Offset: 0x9E8
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function function_15ad909d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 2)
	{
		playfxontag(localclientnum, level._effect["mirg2000_enemy_impact_up"], self, "J_SpineUpper");
	}
	else if(newval == 1)
	{
		playfxontag(localclientnum, level._effect["mirg2000_enemy_impact"], self, "J_SpineUpper");
	}
}

/*
	Name: function_1d3d9723
	Namespace: mirg2000
	Checksum: 0xFE84FCFF
	Offset: 0xAB0
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function function_1d3d9723(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 2)
	{
		playfxontag(localclientnum, level._effect["mirg2000_spider_death_fx_up"], self, "tag_origin");
	}
	else if(newval == 1)
	{
		playfxontag(localclientnum, level._effect["mirg2000_spider_death_fx"], self, "tag_origin");
	}
}

/*
	Name: mirg2000_fire_button_held_sound
	Namespace: mirg2000
	Checksum: 0xE0F014D9
	Offset: 0xB78
	Size: 0xCE
	Parameters: 7
	Flags: Linked
*/
function mirg2000_fire_button_held_sound(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(!isdefined(self.var_c56da363))
		{
			self.var_c56da363 = self playloopsound("wpn_mirg2k_hold_lp", 1.25);
		}
	}
	else if(newval == 0)
	{
		if(isdefined(self.var_c56da363))
		{
			self stoploopsound(self.var_c56da363, 0.1);
			self.var_c56da363 = undefined;
		}
	}
}

/*
	Name: mirg2000_charge_glow
	Namespace: mirg2000
	Checksum: 0xF8D3E9CE
	Offset: 0xC50
	Size: 0x1B6
	Parameters: 7
	Flags: Linked
*/
function mirg2000_charge_glow(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	w_current = getcurrentweapon(localclientnum);
	str_weapon_name = w_current.name;
	self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 1, newval, 0);
	if(newval != 3 && (str_weapon_name == "hero_mirg2000_upgraded" || str_weapon_name == "hero_mirg2000"))
	{
		if(str_weapon_name == "hero_mirg2000_upgraded")
		{
			if(!isdefined(self.var_cdc68d78))
			{
				self.var_cdc68d78 = playviewmodelfx(localclientnum, level._effect["mirg2000_glow_up"], "tag_liquid");
			}
		}
		else if(!isdefined(self.var_cdc68d78))
		{
			self.var_cdc68d78 = playviewmodelfx(localclientnum, level._effect["mirg2000_glow"], "tag_liquid");
		}
	}
	else if(isdefined(self.var_cdc68d78))
	{
		stopfx(localclientnum, self.var_cdc68d78);
		self.var_cdc68d78 = undefined;
	}
}

