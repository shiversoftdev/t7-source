// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\util_shared;

#namespace zm_genesis_undercroft_low_grav;

/*
	Name: main
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x55165D48
	Offset: 0x3D0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function main()
{
	register_clientfields();
	level.var_51541120 = [];
	level._effect["low_grav_player_jump"] = "dlc1/castle/fx_plyr_115_liquid_trail";
	level._effect["low_grav_screen_fx"] = "dlc1/castle/fx_plyr_screen_115_liquid";
	level._effect["wall_dust"] = "dlc1/castle/fx_zombie_spawn_wallrun_castle";
	level thread function_554db684();
}

/*
	Name: register_clientfields
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x9BD418CB
	Offset: 0x460
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("scriptmover", "low_grav_powerup_triggered", 15000, 1, "counter", &function_69e96b4d, 0, 0);
	clientfield::register("toplayer", "player_postfx", 15000, 1, "int", &function_df81c23d, 0, 0);
	clientfield::register("toplayer", "player_screen_fx", 15000, 1, "int", &player_screen_fx, 0, 1);
	clientfield::register("scriptmover", "undercroft_emissives", 15000, 1, "int", &function_9a8a19ab, 0, 0);
	clientfield::register("scriptmover", "undercroft_wall_panel_shutdown", 15000, 1, "counter", &function_a3279a5, 0, 0);
	clientfield::register("scriptmover", "floor_panel_emissives_glow", 15000, 1, "int", &function_23861dfe, 0, 0);
	clientfield::register("world", "snd_low_gravity_state", 15000, 2, "int", &snd_low_gravity_state, 0, 0);
}

/*
	Name: function_554db684
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xC34B220A
	Offset: 0x668
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function function_554db684()
{
	setdvar("wallrun_enabled", 1);
	setdvar("doublejump_enabled", 1);
	setdvar("playerEnergy_enabled", 1);
	setdvar("bg_lowGravity", 300);
	setdvar("wallRun_maxTimeMs_zm", 10000);
	setdvar("playerEnergy_maxReserve_zm", 200);
	setdvar("wallRun_peakTest_zm", 0);
}

/*
	Name: function_69e96b4d
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xA940C708
	Offset: 0x750
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_69e96b4d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playsound(0, "zmb_cha_ching", self.origin);
}

/*
	Name: wall_dust
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x382BDABA
	Offset: 0x7C0
	Size: 0x6C
	Parameters: 7
	Flags: None
*/
function wall_dust(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfx(localclientnum, level._effect["wall_dust"], self.origin);
}

/*
	Name: player_screen_fx
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xA4D3AC17
	Offset: 0x838
	Size: 0xFC
	Parameters: 7
	Flags: Linked
*/
function player_screen_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(level.var_51541120[localclientnum]))
		{
			deletefx(localclientnum, level.var_51541120[localclientnum], 1);
		}
		level.var_51541120[localclientnum] = playfxoncamera(localclientnum, level._effect["low_grav_screen_fx"]);
	}
	else if(isdefined(level.var_51541120[localclientnum]))
	{
		deletefx(localclientnum, level.var_51541120[localclientnum], 1);
	}
}

/*
	Name: function_df81c23d
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x98A634B3
	Offset: 0x940
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function function_df81c23d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		setpbgactivebank(localclientnum, 2);
		self thread postfx::playpostfxbundle("pstfx_115_castle_loop");
	}
	else
	{
		setpbgactivebank(localclientnum, 1);
		self thread postfx::exitpostfxbundle();
	}
}

/*
	Name: function_9a8a19ab
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x4676C72C
	Offset: 0xA08
	Size: 0x278
	Parameters: 7
	Flags: Linked
*/
function function_9a8a19ab(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self notify(#"hash_67a9e087");
	self endon(#"hash_67a9e087");
	if(newval == 1)
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (1 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_end_time);
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
	else
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (2 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_end_time);
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_a3279a5
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x9D69E366
	Offset: 0xC88
	Size: 0x188
	Parameters: 7
	Flags: Linked
*/
function function_a3279a5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self notify(#"hash_67a9e087");
	self endon(#"hash_67a9e087");
	n_start_time = gettime();
	n_end_time = n_start_time + (1 * 1000);
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: function_23861dfe
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xEEC7C234
	Offset: 0xE18
	Size: 0x288
	Parameters: 7
	Flags: Linked
*/
function function_23861dfe(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self notify(#"hash_67a9e087");
	self endon(#"hash_67a9e087");
	if(newval == 1)
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (1 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0.3, 1, n_end_time);
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 0.3, 1, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
	else
	{
		n_start_time = gettime();
		n_end_time = n_start_time + (2 * 1000);
		b_is_updating = 1;
		while(b_is_updating)
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0.3, n_end_time);
				b_is_updating = 0;
			}
			else
			{
				n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0.3, n_time);
			}
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
			wait(0.01);
		}
	}
}

/*
	Name: function_a81107fc
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x883DCEA7
	Offset: 0x10A8
	Size: 0xA4
	Parameters: 7
	Flags: None
*/
function function_a81107fc(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	if(newval)
	{
		var_e6ddb5de = util::spawn_model(localclientnum, "tag_origin", self.origin, self.angles);
		var_e6ddb5de thread function_10dcbf51(localclientnum, var_e6ddb5de);
	}
}

/*
	Name: function_10dcbf51
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x8A9829E4
	Offset: 0x1158
	Size: 0x54
	Parameters: 2
	Flags: Linked, Private
*/
function private function_10dcbf51(localclientnum, var_e6ddb5de)
{
	var_e6ddb5de playsound(localclientnum, "evt_ai_explode");
	wait(1);
	var_e6ddb5de delete();
}

/*
	Name: snd_low_gravity_state
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x80D3479
	Offset: 0x11B8
	Size: 0x14C
	Parameters: 7
	Flags: Linked
*/
function snd_low_gravity_state(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		audio::playloopat("zmb_low_grav_room_loop", (-44, -6680, -1228));
		audio::playloopat("zmb_low_grav_machine_loop", (-44, -6680, -1228));
		playsound(0, "zmb_low_grav_machine_start", (-44, -6680, -1228));
	}
	if(newval == 2)
	{
		audio::stoploopat("zmb_low_grav_machine_loop", (-44, -6680, -1228));
		playsound(0, "zmb_low_grav_machine_stop", (-44, -6680, -1228));
	}
	else
	{
		audio::stoploopat("zmb_low_grav_room_loop", (-44, -6680, -1228));
	}
}

