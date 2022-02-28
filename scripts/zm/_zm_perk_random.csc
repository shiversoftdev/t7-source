// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

#namespace zm_perk_random;

/*
	Name: __init__sytem__
	Namespace: zm_perk_random
	Checksum: 0x46092603
	Offset: 0x3E8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_perk_random", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_perk_random
	Checksum: 0x4F228BC0
	Offset: 0x428
	Size: 0x2FA
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "perk_bottle_cycle_state", 5000, 2, "int", &start_bottle_cycling, 0, 0);
	clientfield::register("zbarrier", "set_client_light_state", 5000, 2, "int", &set_light_state, 0, 0);
	clientfield::register("zbarrier", "init_perk_random_machine", 5000, 1, "int", &perk_random_machine_init, 0, 0);
	clientfield::register("zbarrier", "client_stone_emmissive_blink", 5000, 1, "int", &perk_random_machine_rock_emissive, 0, 0);
	clientfield::register("scriptmover", "turn_active_perk_light_green", 5000, 1, "int", &turn_on_active_light_green, 0, 0);
	clientfield::register("scriptmover", "turn_on_location_indicator", 5000, 1, "int", &turn_on_location_indicator, 0, 0);
	clientfield::register("zbarrier", "lightning_bolt_FX_toggle", 10000, 1, "int", &lightning_bolt_fx_toggle, 0, 0);
	clientfield::register("scriptmover", "turn_active_perk_ball_light", 5000, 1, "int", &turn_on_active_ball_light, 0, 0);
	clientfield::register("scriptmover", "zone_captured", 5000, 1, "int", &zone_captured_cb, 0, 0);
	level._effect["perk_machine_light_yellow"] = "dlc1/castle/fx_wonder_fizz_light_yellow";
	level._effect["perk_machine_light_red"] = "dlc1/castle/fx_wonder_fizz_light_red";
	level._effect["perk_machine_light_green"] = "dlc1/castle/fx_wonder_fizz_light_green";
	level._effect["perk_machine_location"] = "zombie/fx_wonder_fizz_lightning_all";
}

/*
	Name: init_animtree
	Namespace: zm_perk_random
	Checksum: 0x99EC1590
	Offset: 0x730
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function init_animtree()
{
}

/*
	Name: turn_on_location_indicator
	Namespace: zm_perk_random
	Checksum: 0xC7CDAE1
	Offset: 0x740
	Size: 0x3C
	Parameters: 7
	Flags: Linked
*/
function turn_on_location_indicator(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
}

/*
	Name: lightning_bolt_fx_toggle
	Namespace: zm_perk_random
	Checksum: 0x3B9412CA
	Offset: 0x788
	Size: 0x1AA
	Parameters: 7
	Flags: Linked
*/
function lightning_bolt_fx_toggle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdemoplaying() && getdemoversion() < 17)
	{
		return;
	}
	self notify("lightning_bolt_fx_toggle" + localclientnum);
	self endon("lightning_bolt_fx_toggle" + localclientnum);
	player = getlocalplayer(localclientnum);
	player endon(#"entityshutdown");
	if(!isdefined(self._location_indicator))
	{
		self._location_indicator = [];
	}
	while(true)
	{
		if(newval == 1 && !isigcactive(localclientnum))
		{
			if(!isdefined(self._location_indicator[localclientnum]))
			{
				self._location_indicator[localclientnum] = playfx(localclientnum, level._effect["perk_machine_location"], self.origin);
			}
		}
		else if(isdefined(self._location_indicator[localclientnum]))
		{
			stopfx(localclientnum, self._location_indicator[localclientnum]);
			self._location_indicator[localclientnum] = undefined;
		}
		wait(1);
	}
}

/*
	Name: zone_captured_cb
	Namespace: zm_perk_random
	Checksum: 0x13E5CEF0
	Offset: 0x940
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function zone_captured_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.mapped_const))
	{
		self mapshaderconstant(localclientnum, 1, "ScriptVector0");
		self.mapped_const = 1;
	}
	if(newval == 1)
	{
	}
	else
	{
		self.artifact_glow_setting = 1;
		self.machinery_glow_setting = 0;
		self setshaderconstant(localclientnum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
	}
}

/*
	Name: perk_random_machine_rock_emissive
	Namespace: zm_perk_random
	Checksum: 0x325A36FD
	Offset: 0xA20
	Size: 0xB8
	Parameters: 7
	Flags: Linked
*/
function perk_random_machine_rock_emissive(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		piece = self zbarriergetpiece(3);
		piece.blinking = 1;
		piece thread rock_emissive_think(localclientnum);
	}
	else if(newval == 0)
	{
		self.blinking = 0;
	}
}

/*
	Name: rock_emissive_think
	Namespace: zm_perk_random
	Checksum: 0xED6F7B1E
	Offset: 0xAE0
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function rock_emissive_think(localclientnum)
{
	level endon(#"demo_jump");
	while(isdefined(self.blinking) && self.blinking)
	{
		self rock_emissive_fade(localclientnum, 8, 0);
		self rock_emissive_fade(localclientnum, 0, 8);
	}
}

/*
	Name: rock_emissive_fade
	Namespace: zm_perk_random
	Checksum: 0x5862D218
	Offset: 0xB58
	Size: 0x190
	Parameters: 3
	Flags: Linked
*/
function rock_emissive_fade(localclientnum, n_max_val, n_min_val)
{
	n_start_time = gettime();
	n_end_time = n_start_time + (0.5 * 1000);
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min_val, n_max_val, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min_val, n_max_val, n_time);
		}
		if(isdefined(self))
		{
			self mapshaderconstant(localclientnum, 0, "scriptVector2", n_shader_value, 0, 0);
			self mapshaderconstant(localclientnum, 0, "scriptVector0", 0, n_shader_value, 0);
			self mapshaderconstant(localclientnum, 0, "scriptVector0", 0, 0, n_shader_value);
		}
		wait(0.01);
	}
}

/*
	Name: perk_random_machine_init
	Namespace: zm_perk_random
	Checksum: 0xD0352B43
	Offset: 0xCF0
	Size: 0xAA
	Parameters: 7
	Flags: Linked, Private
*/
function private perk_random_machine_init(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.perk_random_machine_fx))
	{
		return;
	}
	if(!isdefined(self))
	{
		return;
	}
	self.perk_random_machine_fx = [];
	self.perk_random_machine_fx["tag_animate" + 1] = [];
	self.perk_random_machine_fx["tag_animate" + 2] = [];
	self.perk_random_machine_fx["tag_animate" + 3] = [];
}

/*
	Name: set_light_state
	Namespace: zm_perk_random
	Checksum: 0x4F3A0AF9
	Offset: 0xDA8
	Size: 0x194
	Parameters: 7
	Flags: Linked
*/
function set_light_state(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	a_n_piece_indices = array(1, 2, 3);
	foreach(n_piece_index in a_n_piece_indices)
	{
		if(newval == 0)
		{
			perk_random_machine_play_fx(localclientnum, n_piece_index, "tag_animate", undefined);
			continue;
		}
		if(newval == 3)
		{
			perk_random_machine_play_fx(localclientnum, n_piece_index, "tag_animate", level._effect["perk_machine_light_red"]);
			continue;
		}
		if(newval == 1)
		{
			perk_random_machine_play_fx(localclientnum, n_piece_index, "tag_animate", level._effect["perk_machine_light_green"]);
			continue;
		}
	}
}

/*
	Name: perk_random_machine_play_fx
	Namespace: zm_perk_random
	Checksum: 0x8BC5BB2E
	Offset: 0xF48
	Size: 0x11C
	Parameters: 5
	Flags: Linked, Private
*/
function private perk_random_machine_play_fx(localclientnum, piece_index, tag, fx, deleteimmediate = 1)
{
	piece = self zbarriergetpiece(piece_index);
	if(isdefined(self.perk_random_machine_fx[tag + piece_index][localclientnum]))
	{
		deletefx(localclientnum, self.perk_random_machine_fx[tag + piece_index][localclientnum], deleteimmediate);
		self.perk_random_machine_fx[tag + piece_index][localclientnum] = undefined;
	}
	if(isdefined(fx))
	{
		self.perk_random_machine_fx[tag + piece_index][localclientnum] = playfxontag(localclientnum, fx, piece, tag);
	}
}

/*
	Name: turn_on_active_light_green
	Namespace: zm_perk_random
	Checksum: 0x9AA4F1A9
	Offset: 0x1070
	Size: 0x98
	Parameters: 7
	Flags: Linked
*/
function turn_on_active_light_green(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.artifact_glow_setting = 1;
		self.machinery_glow_setting = 0.7;
		self setshaderconstant(localclientnum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
	}
}

/*
	Name: turn_on_active_ball_light
	Namespace: zm_perk_random
	Checksum: 0x9D6F1754
	Offset: 0x1110
	Size: 0x98
	Parameters: 7
	Flags: Linked
*/
function turn_on_active_ball_light(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.artifact_glow_setting = 1;
		self.machinery_glow_setting = 1;
		self setshaderconstant(localclientnum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
	}
}

/*
	Name: start_bottle_cycling
	Namespace: zm_perk_random
	Checksum: 0x6DAE7C8
	Offset: 0x11B0
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function start_bottle_cycling(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self thread start_vortex_fx(localclientnum);
	}
	else
	{
		self thread stop_vortex_fx(localclientnum);
	}
}

/*
	Name: start_vortex_fx
	Namespace: zm_perk_random
	Checksum: 0x6317473E
	Offset: 0x1240
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function start_vortex_fx(localclientnum)
{
	self endon(#"activation_electricity_finished");
	self endon(#"entityshutdown");
	if(!isdefined(self.glow_location))
	{
		self.glow_location = spawn(localclientnum, self.origin, "script_model");
		self.glow_location.angles = self.angles;
		self.glow_location setmodel("tag_origin");
	}
	self thread fx_activation_electric_loop(localclientnum);
	self thread fx_artifact_pulse_thread(localclientnum);
	wait(0.5);
	self thread fx_bottle_cycling(localclientnum);
}

/*
	Name: stop_vortex_fx
	Namespace: zm_perk_random
	Checksum: 0xE99C53BB
	Offset: 0x1330
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function stop_vortex_fx(localclientnum)
{
	self endon(#"entityshutdown");
	self notify(#"bottle_cycling_finished");
	wait(0.5);
	if(!isdefined(self))
	{
		return;
	}
	self notify(#"activation_electricity_finished");
	if(isdefined(self.glow_location))
	{
		self.glow_location delete();
	}
	self.artifact_glow_setting = 1;
	self.machinery_glow_setting = 0.7;
	self setshaderconstant(localclientnum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
}

/*
	Name: fx_artifact_pulse_thread
	Namespace: zm_perk_random
	Checksum: 0x86047606
	Offset: 0x13F0
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function fx_artifact_pulse_thread(localclientnum)
{
	self endon(#"activation_electricity_finished");
	self endon(#"entityshutdown");
	while(isdefined(self))
	{
		shader_amount = sin(getrealtime() * 0.2);
		if(shader_amount < 0)
		{
			shader_amount = shader_amount * -1;
		}
		shader_amount = 0.75 - (shader_amount * 0.75);
		self.artifact_glow_setting = shader_amount;
		self.machinery_glow_setting = 1;
		self setshaderconstant(localclientnum, 1, self.artifact_glow_setting, 0, self.machinery_glow_setting, 0);
		wait(0.05);
	}
}

/*
	Name: fx_activation_electric_loop
	Namespace: zm_perk_random
	Checksum: 0x1713E312
	Offset: 0x14F8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function fx_activation_electric_loop(localclientnum)
{
	self endon(#"activation_electricity_finished");
	self endon(#"entityshutdown");
	while(true)
	{
		wait(0.1);
	}
}

/*
	Name: fx_bottle_cycling
	Namespace: zm_perk_random
	Checksum: 0x9C2C2AA0
	Offset: 0x1548
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function fx_bottle_cycling(localclientnum)
{
	self endon(#"bottle_cycling_finished");
	while(true)
	{
		wait(0.1);
	}
}

