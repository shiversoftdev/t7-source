// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _zm_weap_raygun_mark3;

/*
	Name: __init__sytem__
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0x304A131A
	Offset: 0x468
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_raygun_mark3", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0xEAA6CF0
	Offset: 0x4A8
	Size: 0x2C4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.w_raygun_mark3 = getweapon("raygun_mark3");
	level.w_raygun_mark3_upgraded = getweapon("raygun_mark3_upgraded");
	level._effect["raygun_ai_slow_vortex_small"] = "dlc3/stalingrad/fx_raygun_l_projectile_blackhole_sm_hit";
	level._effect["raygun_ai_slow_vortex_large"] = "dlc3/stalingrad/fx_raygun_l_projectile_blackhole_lg_hit";
	level._effect["raygun_slow_vortex_small"] = "dlc3/stalingrad/fx_raygun_l_projectile_blackhole_sm";
	level._effect["raygun_slow_vortex_large"] = "dlc3/stalingrad/fx_raygun_l_projectile_blackhole_lg";
	clientfield::register("scriptmover", "slow_vortex_fx", 12000, 2, "int", &slow_vortex_fx, 0, 0);
	clientfield::register("actor", "ai_disintegrate", 12000, 1, "int", &ai_disintegrate, 0, 0);
	clientfield::register("vehicle", "ai_disintegrate", 12000, 1, "int", &ai_disintegrate, 0, 0);
	clientfield::register("actor", "ai_slow_vortex_fx", 12000, 2, "int", &ai_slow_vortex_fx, 0, 0);
	clientfield::register("vehicle", "ai_slow_vortex_fx", 12000, 2, "int", &ai_slow_vortex_fx, 0, 0);
	visionset_mgr::register_visionset_info("raygun_mark3_vortex_visionset", 1, 30, undefined, "zm_idgun_vortex");
	visionset_mgr::register_overlay_info_style_speed_blur("raygun_mark3_vortex_blur", 1, 30, 0.08, 0.75, 0.9);
	duplicate_render::set_dr_filter_framebuffer("dissolve", 10, "dissolve_on", undefined, 0, "mc/mtl_c_zom_dlc3_zombie_dissolve_base", 0);
	callback::on_localclient_connect(&monitor_raygun_mark3);
}

/*
	Name: is_beam_raygun
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0x8322BB81
	Offset: 0x778
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function is_beam_raygun(weapon)
{
	if(weapon === level.w_raygun_mark3 || weapon === level.w_raygun_mark3_upgraded)
	{
		return true;
	}
	return false;
}

/*
	Name: monitor_raygun_mark3
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0xE800478A
	Offset: 0x7B8
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function monitor_raygun_mark3(n_local_client)
{
	player = getlocalplayer(n_local_client);
	player endon(#"death");
	while(true)
	{
		player waittill(#"weapon_change", weapon);
		if(is_beam_raygun(weapon))
		{
			player mapshaderconstant(n_local_client, 0, "scriptVector2", 0, 1, 0, 0);
			player thread glow_monitor(n_local_client);
		}
		else
		{
			player notify(#"glow_monitor");
			player mapshaderconstant(n_local_client, 0, "scriptVector2", 0, 0, 0, 0);
		}
	}
}

/*
	Name: glow_monitor
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0xB9A9B102
	Offset: 0x8C0
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function glow_monitor(n_local_client)
{
	self notify(#"glow_monitor");
	self endon(#"glow_monitor");
	self endon(#"death");
	while(true)
	{
		self waittill_notetrack("clamps_open");
		self mapshaderconstant(n_local_client, 0, "scriptVector2", 0, 0, 0, 0);
		self waittill_notetrack("clamps_close");
		self mapshaderconstant(n_local_client, 0, "scriptVector2", 0, 1, 0, 0);
	}
}

/*
	Name: waittill_notetrack
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0x6F4BED28
	Offset: 0x990
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function waittill_notetrack(str_notetrack)
{
	self endon(#"glow_monitor");
	self endon(#"death");
	while(true)
	{
		self waittill(#"notetrack", str_note);
		if(str_note == str_notetrack)
		{
			return;
		}
	}
}

/*
	Name: slow_vortex_fx
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0x6714F73
	Offset: 0x9F0
	Size: 0x134
	Parameters: 7
	Flags: Linked
*/
function slow_vortex_fx(n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump)
{
	if(isdefined(self.fx_slow_vortex))
	{
		killfx(n_local_client, self.fx_slow_vortex);
	}
	if(n_new)
	{
		if(n_new == 1)
		{
			self.fx_slow_vortex = playfxontag(n_local_client, level._effect["raygun_slow_vortex_small"], self, "tag_origin");
		}
		else
		{
			self.fx_slow_vortex = playfxontag(n_local_client, level._effect["raygun_slow_vortex_large"], self, "tag_origin");
			self playrumbleonentity(n_local_client, "artillery_rumble");
		}
		self thread vortex_shake_and_rumble(n_local_client, n_new);
	}
}

/*
	Name: ai_slow_vortex_fx
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0x71253CC3
	Offset: 0xB30
	Size: 0x154
	Parameters: 7
	Flags: Linked
*/
function ai_slow_vortex_fx(n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump)
{
	if(n_new)
	{
		if(n_new == 1)
		{
			self.fx_ai_slow_vortex = playfxontag(n_local_client, level._effect["raygun_ai_slow_vortex_small"], self, "J_SpineUpper");
			self thread zombie_blacken(n_local_client, 1);
		}
		else
		{
			self.fx_ai_slow_vortex = playfxontag(n_local_client, level._effect["raygun_ai_slow_vortex_large"], self, "J_SpineUpper");
			self thread zombie_blacken(n_local_client, 1);
		}
	}
	else if(isdefined(self.fx_ai_slow_vortex))
	{
		killfx(n_local_client, self.fx_ai_slow_vortex);
		self thread zombie_blacken(n_local_client, 0);
	}
}

/*
	Name: vortex_shake_and_rumble
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0xE0070E9F
	Offset: 0xC90
	Size: 0xA0
	Parameters: 2
	Flags: Linked
*/
function vortex_shake_and_rumble(n_local_client, n_damage_level)
{
	self notify(#"vortex_shake_and_rumble");
	self endon(#"vortex_shake_and_rumble");
	self endon(#"entity_shutdown");
	if(n_damage_level == 1)
	{
		str_rumble = "raygun_mark3_vortex_sm";
	}
	else
	{
		str_rumble = "raygun_mark3_vortex_lg";
	}
	while(isdefined(self))
	{
		self playrumbleonentity(n_local_client, str_rumble);
		wait(0.083);
	}
}

/*
	Name: zombie_blacken
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0x921731EC
	Offset: 0xD38
	Size: 0x120
	Parameters: 2
	Flags: Linked
*/
function zombie_blacken(n_local_client, b_blacken)
{
	self endon(#"entity_shutdown");
	if(!isdefined(self.n_blacken))
	{
		self.n_blacken = 0;
	}
	if(b_blacken)
	{
		while(isdefined(self) && self.n_blacken < 1)
		{
			self.n_blacken = self.n_blacken + 0.2;
			self mapshaderconstant(n_local_client, 0, "scriptVector0", self.n_blacken);
			wait(0.05);
		}
	}
	else
	{
		while(isdefined(self) && self.n_blacken > 0)
		{
			self.n_blacken = self.n_blacken - 0.2;
			self mapshaderconstant(n_local_client, 0, "scriptVector0", self.n_blacken);
			wait(0.05);
		}
	}
}

/*
	Name: ai_disintegrate
	Namespace: _zm_weap_raygun_mark3
	Checksum: 0xFC9F7296
	Offset: 0xE60
	Size: 0x124
	Parameters: 7
	Flags: Linked
*/
function ai_disintegrate(n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump)
{
	self endon(#"entity_shutdown");
	self duplicate_render::set_dr_flag("dissolve_on", n_new);
	self duplicate_render::update_dr_filters(n_local_client);
	self.n_dissolve = 1;
	while(isdefined(self) && self.n_dissolve > 0)
	{
		self mapshaderconstant(n_local_client, 0, "scriptVector0", self.n_dissolve);
		self.n_dissolve = self.n_dissolve - 0.0166;
		wait(0.0166);
	}
	if(isdefined(self))
	{
		self mapshaderconstant(n_local_client, 0, "scriptVector0", 0);
	}
}

