// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace hazard;

/*
	Name: __init__sytem__
	Namespace: hazard
	Checksum: 0x4D9CADCF
	Offset: 0x248
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hazard", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: hazard
	Checksum: 0xBC6FBDBE
	Offset: 0x288
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	add_hazard("heat", 500, 50, 1, &function_476442fb);
	add_hazard("filter", 500, 50, 2);
	add_hazard("o2", 500, 60, 3, &function_8b413656);
	add_hazard("radation", 500, 50, 4);
	add_hazard("biohazard", 500, 50, 5);
	callback::on_spawned(&on_player_spawned);
	callback::on_player_killed(&on_player_killed);
	callback::on_connect(&on_player_connect);
}

/*
	Name: add_hazard
	Namespace: hazard
	Checksum: 0x3D1698C4
	Offset: 0x3D0
	Size: 0xEC
	Parameters: 5
	Flags: Linked
*/
function add_hazard(str_name, n_max_protection, n_regen_rate, n_type, func_update)
{
	if(!isdefined(level.hazards))
	{
		level.hazards = [];
	}
	if(!isdefined(level.hazards[str_name]))
	{
		level.hazards[str_name] = spawnstruct();
	}
	level.hazards[str_name].n_max_protection = n_max_protection;
	level.hazards[str_name].n_regen_rate = n_regen_rate;
	level.hazards[str_name].n_type = n_type;
	level.hazards[str_name].func_update = func_update;
}

/*
	Name: on_player_spawned
	Namespace: hazard
	Checksum: 0x3F6EEE1C
	Offset: 0x4C8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	reset(1);
}

/*
	Name: on_player_connect
	Namespace: hazard
	Checksum: 0x8B2A3FCF
	Offset: 0x4F0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	reset(0);
	self thread function_b6af57a8();
	self thread function_a421f870();
}

/*
	Name: on_player_killed
	Namespace: hazard
	Checksum: 0xAB3171A
	Offset: 0x548
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_killed()
{
	reset(1);
}

/*
	Name: reset
	Namespace: hazard
	Checksum: 0x7100897C
	Offset: 0x570
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function reset(var_b18f74fe)
{
	foreach(str_name, _ in level.hazards)
	{
		self.hazard_damage[str_name] = 0;
		self.var_6c3e78bb[str_name] = 1;
	}
	self.hazard_ui_models = [];
	self.hazard_ui_models["hudItems.hess1"] = 0;
	self.hazard_ui_models["hudItems.hess2"] = 0;
	if(var_b18f74fe)
	{
		self setcontrolleruimodelvalue("hudItems.hess1.type", 0);
		self setcontrolleruimodelvalue("hudItems.hess2.type", 0);
	}
}

/*
	Name: function_b6af57a8
	Namespace: hazard
	Checksum: 0xB6FDD4C3
	Offset: 0x698
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function function_b6af57a8()
{
	self endon(#"disconnect");
	while(true)
	{
		level waittill(#"save_restore");
		if(isdefined(self.var_8dcb3948) && self.var_8dcb3948)
		{
			continue;
		}
		var_8601d520 = getarraykeys(level.hazards);
		foreach(str_name in var_8601d520)
		{
			self do_damage(str_name, 3, undefined);
			wait(0.1);
		}
	}
}

/*
	Name: function_a421f870
	Namespace: hazard
	Checksum: 0xCFE483D9
	Offset: 0x798
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function function_a421f870()
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"player_revived");
		foreach(str_name, _ in level.hazards)
		{
			if(function_b78a859e(str_name) >= 1)
			{
				function_12231466(str_name);
			}
		}
	}
}

/*
	Name: function_12231466
	Namespace: hazard
	Checksum: 0x6F222BBB
	Offset: 0x870
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function function_12231466(str_name)
{
	/#
		assert(isdefined(level.hazards[str_name]), ("" + str_name) + "");
	#/
	self.hazard_damage[str_name] = 0;
}

/*
	Name: do_damage
	Namespace: hazard
	Checksum: 0xBFDE7E7B
	Offset: 0x8D0
	Size: 0x1C6
	Parameters: 4
	Flags: Linked
*/
function do_damage(str_name, n_damage, e_ent, disable_ui)
{
	/#
		assert(isdefined(level.hazards[str_name]), ("" + str_name) + "");
	#/
	if(!isdefined(disable_ui))
	{
		disable_ui = 0;
	}
	if(scene::is_igc_active())
	{
		return false;
	}
	s_hazard = level.hazards[str_name];
	self.hazard_damage[str_name] = min(self.hazard_damage[str_name] + n_damage, s_hazard.n_max_protection);
	if(self.hazard_damage[str_name] < s_hazard.n_max_protection)
	{
		self thread _fill_hazard_protection(str_name, e_ent, disable_ui);
		return true;
	}
	switch(str_name)
	{
		case "o2":
		{
			str_mod = "MOD_DROWN";
			break;
		}
		case "heat":
		{
			str_mod = "MOD_BURNED";
			break;
		}
		default:
		{
			str_mod = "MOD_UNKNOWN";
		}
	}
	self dodamage(self.health, self.origin, undefined, undefined, undefined, str_mod);
	return false;
}

/*
	Name: function_eaa9157d
	Namespace: hazard
	Checksum: 0xE9FCF0C3
	Offset: 0xAA0
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function function_eaa9157d(str_name)
{
	/#
		assert(isdefined(self.hazard_damage[str_name]), ("" + str_name) + "");
	#/
	return self.hazard_damage[str_name];
}

/*
	Name: function_b78a859e
	Namespace: hazard
	Checksum: 0xE1B74171
	Offset: 0xAF8
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function function_b78a859e(str_name)
{
	/#
		assert(isdefined(self.hazard_damage[str_name]), ("" + str_name) + "");
	#/
	return self.hazard_damage[str_name] / level.hazards[str_name].n_max_protection;
}

/*
	Name: function_459e5eff
	Namespace: hazard
	Checksum: 0xE491CFF7
	Offset: 0xB68
	Size: 0x76
	Parameters: 2
	Flags: Linked
*/
function function_459e5eff(str_name, var_5b9ad5b3 = 1)
{
	/#
		assert(isdefined(self.var_6c3e78bb[str_name]), ("" + str_name) + "");
	#/
	self.var_6c3e78bb[str_name] = var_5b9ad5b3;
}

/*
	Name: _fill_hazard_protection
	Namespace: hazard
	Checksum: 0xF67374C3
	Offset: 0xBE8
	Size: 0x38C
	Parameters: 3
	Flags: Linked, Private
*/
function private _fill_hazard_protection(str_name, e_ent, disable_ui)
{
	self notify("_hazard_protection_" + str_name);
	self endon("_hazard_protection_" + str_name);
	self endon(#"death");
	s_hazard = level.hazards[str_name];
	str_ui_model = "";
	foreach(model, type in self.hazard_ui_models)
	{
		if(type == s_hazard.n_type)
		{
			str_ui_model = model;
			break;
		}
	}
	if(str_ui_model == "")
	{
		foreach(model, type in self.hazard_ui_models)
		{
			if(type == 0)
			{
				str_ui_model = model;
				break;
			}
		}
	}
	if(str_ui_model != "")
	{
		if(!disable_ui)
		{
			self setcontrolleruimodelvalue(str_ui_model + ".type", s_hazard.n_type);
		}
		self.hazard_ui_models[str_ui_model] = s_hazard.n_type;
	}
	do
	{
		n_frac = mapfloat(0, s_hazard.n_max_protection, 1, 0, self.hazard_damage[str_name]);
		if(str_ui_model != "" && !disable_ui)
		{
			self setcontrolleruimodelvalue(str_ui_model + ".ratio", n_frac);
		}
		if(isdefined(s_hazard.func_update))
		{
			[[s_hazard.func_update]](n_frac, e_ent);
		}
		wait(0.05);
		if(self.var_6c3e78bb[str_name] == 1)
		{
			self.hazard_damage[str_name] = self.hazard_damage[str_name] - (s_hazard.n_regen_rate * 0.05);
		}
	}
	while(self.hazard_damage[str_name] >= 0);
	self function_45f02912();
	if(str_ui_model != "")
	{
		if(!disable_ui)
		{
			self setcontrolleruimodelvalue(str_ui_model + ".type", 0);
		}
		self.hazard_ui_models[str_ui_model] = 0;
	}
	else
	{
		/#
			assert("");
		#/
	}
}

/*
	Name: function_45f02912
	Namespace: hazard
	Checksum: 0xFDB4C3A0
	Offset: 0xF80
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_45f02912()
{
	self clientfield::set("burn", 0);
	self clientfield::set_to_player("player_cam_bubbles", 0);
}

/*
	Name: function_476442fb
	Namespace: hazard
	Checksum: 0xDF4B273F
	Offset: 0xFD0
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function function_476442fb(n_damage_frac, e_ent)
{
	if(!isdefined(e_ent) || scene::is_igc_active())
	{
		self.var_65e617f8 = undefined;
		self clientfield::set("burn", 0);
		return;
	}
	if(!(isdefined(self.var_65e617f8) && self.var_65e617f8) && self istouching(e_ent))
	{
		self clientfield::set("burn", 1);
	}
	else
	{
		self.var_65e617f8 = undefined;
		self clientfield::set("burn", 0);
	}
}

/*
	Name: function_503a50a8
	Namespace: hazard
	Checksum: 0xE9C8FD62
	Offset: 0x10C0
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_503a50a8()
{
	self endon(#"death");
	self clientfield::set_to_player("player_cam_bubbles", 1);
	wait(4);
	self clientfield::set_to_player("player_cam_bubbles", 0);
}

/*
	Name: function_8b413656
	Namespace: hazard
	Checksum: 0x173E20B7
	Offset: 0x1120
	Size: 0x214
	Parameters: 2
	Flags: Linked
*/
function function_8b413656(var_d2eebe84, e_ent)
{
	if(!isdefined(self.var_18c7e911))
	{
		self.var_18c7e911 = 0;
	}
	if(var_d2eebe84 <= 0.2)
	{
		if(self.var_18c7e911 > 0.2)
		{
			self thread function_503a50a8();
		}
	}
	else if(var_d2eebe84 <= 0.1)
	{
		if(self.var_18c7e911 > 0.1)
		{
			self thread function_503a50a8();
		}
	}
	var_b45ec125 = array(0.5, 0.3, 0.2, 0.15, 0.1, 0.5);
	foreach(num in var_b45ec125)
	{
		if(var_d2eebe84 != 0 && var_d2eebe84 <= num)
		{
			if(self.var_18c7e911 > num)
			{
				self playsound("vox_plyr_uw_gasp");
				if(num < 0.4)
				{
					self thread function_fda01c41("vox_plyr_uw_emerge_gasp");
				}
				else
				{
					self thread function_fda01c41("vox_plyr_uw_emerge");
				}
				break;
			}
		}
	}
	self.var_18c7e911 = var_d2eebe84;
}

/*
	Name: function_fda01c41
	Namespace: hazard
	Checksum: 0x15C159CC
	Offset: 0x1340
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function function_fda01c41(alias)
{
	self notify(#"hash_fda01c41");
	self endon(#"hash_fda01c41");
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"save_restore");
	while(self isplayerunderwater())
	{
		wait(0.1);
	}
	self playsound(alias);
}

/*
	Name: function_e9b126ef
	Namespace: hazard
	Checksum: 0x76E0FF17
	Offset: 0x13D0
	Size: 0x54
	Parameters: 2
	Flags: None
*/
function function_e9b126ef(n_time, var_827d6de0 = 1)
{
	self thread function_ccddb105("o2", 4, n_time, var_827d6de0);
}

/*
	Name: function_ccddb105
	Namespace: hazard
	Checksum: 0x40DDE053
	Offset: 0x1430
	Size: 0x1FA
	Parameters: 4
	Flags: Linked
*/
function function_ccddb105(var_be6a04c9, var_6d20ee14, n_time, var_827d6de0)
{
	/#
		assert(isdefined(level.hazards[var_be6a04c9]), ("" + var_be6a04c9) + "");
	#/
	self notify("stop_hazard_dot_" + var_be6a04c9);
	self endon("stop_hazard_dot_" + var_be6a04c9);
	self endon(#"death");
	self function_459e5eff(var_be6a04c9, 0);
	var_dd075cd2 = 1;
	s_hazard = level.hazards[var_be6a04c9];
	n_damage = var_6d20ee14;
	if(isdefined(n_time))
	{
		var_97dd249c = self function_eaa9157d(var_be6a04c9);
		var_90d01cd2 = s_hazard.n_max_protection;
		var_7046c7b3 = var_827d6de0 * var_90d01cd2;
		var_a6321c17 = var_7046c7b3 - var_97dd249c;
		if(var_a6321c17 > 0)
		{
			n_damage = var_a6321c17 / n_time;
		}
	}
	while(true)
	{
		wait(1);
		var_dd075cd2 = self do_damage(var_be6a04c9, n_damage);
		var_7ba0abc9 = self function_b78a859e(var_be6a04c9);
		if(n_damage > var_6d20ee14 && var_7ba0abc9 >= var_827d6de0)
		{
			n_damage = var_6d20ee14;
		}
	}
}

/*
	Name: function_60455f28
	Namespace: hazard
	Checksum: 0x10C8CC52
	Offset: 0x1638
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function function_60455f28(var_be6a04c9)
{
	self notify("stop_hazard_dot_" + var_be6a04c9);
	self function_459e5eff(var_be6a04c9, 1);
}

