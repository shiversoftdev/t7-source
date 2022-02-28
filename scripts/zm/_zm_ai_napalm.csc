// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_ai_napalm;

/*
	Name: __init__sytem__
	Namespace: zm_ai_napalm
	Checksum: 0x24B0F94B
	Offset: 0x410
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_napalm", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_napalm
	Checksum: 0x86BF967C
	Offset: 0x450
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_clientfields();
	init_napalm_zombie();
}

/*
	Name: init_clientfields
	Namespace: zm_ai_napalm
	Checksum: 0x10590FFC
	Offset: 0x480
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("actor", "napalmwet", 21000, 1, "int", &napalm_zombie_wet_callback, 0, 0);
	clientfield::register("actor", "napalmexplode", 21000, 1, "int", &napalm_zombie_explode_callback, 0, 0);
	clientfield::register("actor", "isnapalm", 21000, 1, "int", &napalm_zombie_spawn, 0, 0);
	clientfield::register("toplayer", "napalm_pstfx_burn", 21000, 1, "int", &function_8b5f66c2, 0, 0);
}

/*
	Name: init_napalm_zombie
	Namespace: zm_ai_napalm
	Checksum: 0x7A32B6F3
	Offset: 0x5B0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function init_napalm_zombie()
{
	level.napalmplayerwarningradiussqr = 400;
	level.napalmplayerwarningradiussqr = level.napalmplayerwarningradiussqr * level.napalmplayerwarningradiussqr;
	napalm_fx();
}

/*
	Name: napalm_fx
	Namespace: zm_ai_napalm
	Checksum: 0xB10B526C
	Offset: 0x5F8
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function napalm_fx()
{
	level._effect["napalm_fire_forearm"] = "dlc5/temple/fx_ztem_napalm_zombie_forearm";
	level._effect["napalm_fire_torso"] = "dlc5/temple/fx_ztem_napalm_zombie_torso";
	level._effect["napalm_distortion"] = "dlc5/temple/fx_ztem_napalm_zombie_heat";
	level._effect["napalm_fire_forearm_end"] = "dlc5/temple/fx_ztem_napalm_zombie_forearm_end";
	level._effect["napalm_fire_torso_end"] = "dlc5/temple/fx_ztem_napalm_zombie_torso_end";
	level._effect["napalm_steam"] = "dlc5/temple/fx_ztem_zombie_torso_steam_runner";
	level._effect["napalm_feet_steam"] = "dlc5/temple/fx_ztem_zombie_torso_steam_runner";
}

/*
	Name: napalm_zombie_spawn
	Namespace: zm_ai_napalm
	Checksum: 0x3FC63F46
	Offset: 0x6C8
	Size: 0x126
	Parameters: 7
	Flags: Linked
*/
function napalm_zombie_spawn(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		level.napalm_zombie = self;
		self.var_d88a44cf = 1;
		self thread set_footstep_override_for_napalm_zombie(1);
		self thread napalm_glow_normal(localclientnum);
		self thread _napalm_zombie_runeffects(localclientnum);
		self thread _napalm_zombie_runsteameffects(localclientnum);
		self thread function_dfc155a2(localclientnum);
	}
	else
	{
		self notify(#"stop_fx");
		self notify(#"napalm_killed");
		if(isdefined(self.steam_fx))
		{
			self.steam_fx delete();
		}
		level.napalm_zombie = undefined;
	}
}

/*
	Name: function_dfc155a2
	Namespace: zm_ai_napalm
	Checksum: 0xF98AEEED
	Offset: 0x7F8
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function function_dfc155a2(localclientnum)
{
	self endon(#"napalm_killed");
	while(isdefined(self))
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 1, 0, 0);
		wait(0.05);
	}
}

/*
	Name: _napalm_zombie_runsteameffects
	Namespace: zm_ai_napalm
	Checksum: 0x25553926
	Offset: 0x850
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function _napalm_zombie_runsteameffects(client_num)
{
	self endon(#"napalm_killed");
	self endon(#"death");
	self endon(#"entityshutdown");
	while(true)
	{
		waterheight = -15000;
		underwater = waterheight > self.origin[2];
		if(underwater)
		{
			if(!isdefined(self.steam_fx))
			{
				effectent = spawn(client_num, self.origin, "script_model");
				effectent setmodel("tag_origin");
				playfxontag(client_num, level._effect["napalm_feet_steam"], effectent, "tag_origin");
				self.steam_fx = effectent;
			}
			origin = (self.origin[0], self.origin[1], waterheight);
			self.steam_fx.origin = origin;
		}
		else if(isdefined(self.steam_fx))
		{
			self.steam_fx delete();
			self.steam_fx = undefined;
		}
		wait(0.1);
	}
}

/*
	Name: _napalm_zombie_runeffects
	Namespace: zm_ai_napalm
	Checksum: 0x4DAC8CCC
	Offset: 0x9F0
	Size: 0x2A6
	Parameters: 1
	Flags: Linked
*/
function _napalm_zombie_runeffects(localclientnum)
{
	self.var_61c885f9 = [];
	wait(1);
	var_b73afa37 = playfxontag(localclientnum, level._effect["napalm_fire_forearm"], self, "J_Wrist_RI");
	array::add(self.var_61c885f9, var_b73afa37, 0);
	var_2848fc16 = playfxontag(localclientnum, level._effect["napalm_fire_forearm"], self, "J_Wrist_LE");
	array::add(self.var_61c885f9, var_2848fc16, 0);
	var_f86ab686 = playfxontag(localclientnum, level._effect["napalm_fire_torso"], self, "J_SpineLower");
	array::add(self.var_61c885f9, var_f86ab686, 0);
	var_19cf783f = playfxontag(localclientnum, level._effect["napalm_fire_forearm"], self, "J_Head");
	array::add(self.var_61c885f9, var_19cf783f, 0);
	var_bc3301ad = playfxontag(localclientnum, level._effect["napalm_distortion"], self, "tag_origin");
	array::add(self.var_61c885f9, var_bc3301ad, 0);
	self playloopsound("evt_napalm_zombie_loop", 2);
	self util::waittill_any("stop_fx", "entityshutdown");
	if(isdefined(self))
	{
		self stopallloopsounds(0.25);
		for(i = 0; i < self.var_61c885f9.size; i++)
		{
			stopfx(localclientnum, self.var_61c885f9[i]);
		}
		self.var_61c885f9 = undefined;
	}
}

/*
	Name: napalm_zombie_explode_callback
	Namespace: zm_ai_napalm
	Checksum: 0x2BF20574
	Offset: 0xCA0
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function napalm_zombie_explode_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self thread napalm_glow_explode(localclientnum);
	self thread _zombie_runexplosionwindupeffects(localclientnum);
}

/*
	Name: function_8b5f66c2
	Namespace: zm_ai_napalm
	Checksum: 0x24A9141A
	Offset: 0xD18
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_8b5f66c2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self thread postfx::playpostfxbundle("pstfx_burn_loop");
	}
	else
	{
		self thread postfx::exitpostfxbundle();
	}
}

/*
	Name: _zombie_runexplosionwindupeffects
	Namespace: zm_ai_napalm
	Checksum: 0x89808B0F
	Offset: 0xDA0
	Size: 0x25E
	Parameters: 1
	Flags: Linked
*/
function _zombie_runexplosionwindupeffects(localclientnum)
{
	self.var_a8353e57 = [];
	var_ba4bf47b = playfxontag(localclientnum, level._effect["napalm_fire_forearm_end"], self, "J_Elbow_LE");
	array::add(self.var_a8353e57, var_ba4bf47b, 0);
	var_968c6325 = playfxontag(localclientnum, level._effect["napalm_fire_forearm_end"], self, "J_Elbow_RI");
	array::add(self.var_a8353e57, var_968c6325, 0);
	var_955eea4 = playfxontag(localclientnum, level._effect["napalm_fire_forearm_end"], self, "J_Clavicle_LE");
	array::add(self.var_a8353e57, var_955eea4, 0);
	var_4d8c73aa = playfxontag(localclientnum, level._effect["napalm_fire_forearm_end"], self, "J_Clavicle_RI");
	array::add(self.var_a8353e57, var_4d8c73aa, 0);
	var_f86ab686 = playfxontag(localclientnum, level._effect["napalm_fire_torso_end"], self, "J_SpineLower");
	array::add(self.var_a8353e57, var_f86ab686, 0);
	self util::waittill_any("stop_fx", "entityshutdown");
	if(isdefined(self))
	{
		for(i = 0; i < self.var_a8353e57.size; i++)
		{
			stopfx(localclientnum, self.var_a8353e57[i]);
		}
		self.var_a8353e57 = undefined;
	}
}

/*
	Name: _napalm_zombie_runweteffects
	Namespace: zm_ai_napalm
	Checksum: 0xA5C631D9
	Offset: 0x1008
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function _napalm_zombie_runweteffects(localclientnum)
{
	var_f86ab686 = playfxontag(localclientnum, level._effect["napalm_steam"], self, "J_SpineLower");
	self util::waittill_any("stop_fx", "entityshutdown");
	if(isdefined(self))
	{
		stopfx(localclientnum, var_f86ab686);
	}
}

/*
	Name: set_footstep_override_for_napalm_zombie
	Namespace: zm_ai_napalm
	Checksum: 0x8F47DC1C
	Offset: 0x10A0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function set_footstep_override_for_napalm_zombie(set)
{
	if(set)
	{
		level._footstepcbfuncs[self.archetype] = &function_3753bc33;
		self.step_sound = "zmb_napalm_step";
	}
	else
	{
		level._footstepcbfuncs[self.archetype] = undefined;
		self.step_sound = "zmb_napalm_step";
	}
}

/*
	Name: function_3753bc33
	Namespace: zm_ai_napalm
	Checksum: 0x78E6BDAF
	Offset: 0x1118
	Size: 0x74
	Parameters: 5
	Flags: Linked
*/
function function_3753bc33(localclientnum, pos, surface, notetrack, bone)
{
	if(isdefined(self.var_d88a44cf) && self.var_d88a44cf)
	{
		playfxontag(localclientnum, level._effect["napalm_zombie_footstep"], self, bone);
	}
}

/*
	Name: player_napalm_radius_overlay_fade
	Namespace: zm_ai_napalm
	Checksum: 0xFE622337
	Offset: 0x1198
	Size: 0x1C8
	Parameters: 0
	Flags: None
*/
function player_napalm_radius_overlay_fade()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	prevfrac = 0;
	while(true)
	{
		frac = 0;
		if(!isdefined(level.napalm_zombie) || (isdefined(level.napalm_zombie.wet) && level.napalm_zombie.wet) || player_can_see_napalm(level.napalm_zombie))
		{
			frac = 0;
		}
		else
		{
			dist_to_napalm = distancesquared(self.origin, level.napalm_zombie.origin);
			if(dist_to_napalm < level.napalmplayerwarningradiussqr)
			{
				frac = (level.napalmplayerwarningradiussqr - dist_to_napalm) / level.napalmplayerwarningradiussqr;
				frac = frac * 1.1;
				if(frac > 1)
				{
					frac = 1;
				}
			}
		}
		delta = math::clamp(frac - prevfrac, -0.1, 0.1);
		frac = prevfrac + delta;
		prevfrac = frac;
		setsaveddvar("r_flameScaler", frac);
		wait(0.1);
	}
}

/*
	Name: player_can_see_napalm
	Namespace: zm_ai_napalm
	Checksum: 0x18BF01B9
	Offset: 0x1368
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function player_can_see_napalm(ent_napalm)
{
	trace = undefined;
	if(isdefined(level.napalm_zombie))
	{
		trace = bullettrace(self geteye(), level.napalm_zombie.origin, 0, self);
		if(isdefined(trace) && trace["fraction"] < 0.85)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: napalm_zombie_wet_callback
	Namespace: zm_ai_napalm
	Checksum: 0xA063C9B6
	Offset: 0x1408
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function napalm_zombie_wet_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		self napalm_start_wet_fx(localclientnum);
	}
	else
	{
		self napalm_end_wet_fx(localclientnum);
	}
}

/*
	Name: napalm_start_wet_fx
	Namespace: zm_ai_napalm
	Checksum: 0x5BE679B4
	Offset: 0x1490
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function napalm_start_wet_fx(client_num)
{
	self notify(#"stop_fx");
	self thread _napalm_zombie_runweteffects(client_num);
	self.wet = 1;
	self thread napalm_glow_wet(client_num);
	self thread set_footstep_override_for_napalm_zombie(0);
}

/*
	Name: napalm_end_wet_fx
	Namespace: zm_ai_napalm
	Checksum: 0xCA6756C3
	Offset: 0x1510
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function napalm_end_wet_fx(client_num)
{
	self notify(#"stop_fx");
	self thread _napalm_zombie_runeffects(client_num);
	self.wet = 0;
	self thread napalm_glow_normal(client_num);
	self thread set_footstep_override_for_napalm_zombie(1);
}

/*
	Name: napalm_set_glow
	Namespace: zm_ai_napalm
	Checksum: 0x9C36257A
	Offset: 0x1590
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function napalm_set_glow(client_num, glowval)
{
	self.glow_val = glowval;
	self setshaderconstant(client_num, 0, 0, 0, 0, glowval);
}

/*
	Name: napalm_glow_normal
	Namespace: zm_ai_napalm
	Checksum: 0xC5BE5B7D
	Offset: 0x15E0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function napalm_glow_normal(client_num)
{
	self thread napalm_glow_lerp(client_num, 2.5);
}

/*
	Name: napalm_glow_explode
	Namespace: zm_ai_napalm
	Checksum: 0x5EF8973E
	Offset: 0x1618
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function napalm_glow_explode(client_num)
{
	self thread napalm_glow_lerp(client_num, 10);
}

/*
	Name: napalm_glow_wet
	Namespace: zm_ai_napalm
	Checksum: 0x75EC393A
	Offset: 0x1650
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function napalm_glow_wet(client_num)
{
	self thread napalm_glow_lerp(client_num, 0.5);
}

/*
	Name: napalm_glow_lerp
	Namespace: zm_ai_napalm
	Checksum: 0x62E5C152
	Offset: 0x1688
	Size: 0x174
	Parameters: 2
	Flags: Linked
*/
function napalm_glow_lerp(client_num, glowval)
{
	self notify(#"glow_lerp");
	self endon(#"glow_lerp");
	self endon(#"death");
	self endon(#"entityshutdown");
	startval = self.glow_val;
	endval = glowval;
	if(isdefined(startval))
	{
		delta = glowval - self.glow_val;
		lerptime = 1000;
		starttime = getrealtime();
		while((starttime + lerptime) > getrealtime())
		{
			s = (getrealtime() - starttime) / lerptime;
			newval = startval + ((endval - startval) * s);
			self napalm_set_glow(client_num, newval);
			waitrealtime(0.05);
		}
	}
	self napalm_set_glow(client_num, endval);
}

