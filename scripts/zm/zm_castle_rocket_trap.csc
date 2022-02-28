// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;

#namespace zm_castle_rocket_trap;

/*
	Name: main
	Namespace: zm_castle_rocket_trap
	Checksum: 0x102861ED
	Offset: 0x270
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function main()
{
	register_clientfields();
}

/*
	Name: register_clientfields
	Namespace: zm_castle_rocket_trap
	Checksum: 0x5F7BC4B5
	Offset: 0x290
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("world", "rocket_trap_warning_smoke", 1, 1, "int", &rocket_trap_warning_smoke, 0, 0);
	clientfield::register("world", "rocket_trap_warning_fire", 1, 1, "int", &rocket_trap_warning_fire, 0, 0);
	clientfield::register("world", "sndRocketAlarm", 5000, 2, "int", &sndrocketalarm, 0, 0);
	clientfield::register("world", "sndRocketTrap", 5000, 3, "int", &sndrockettrap, 0, 0);
}

/*
	Name: rocket_trap_warning_smoke
	Namespace: zm_castle_rocket_trap
	Checksum: 0xBC4E0B2E
	Offset: 0x3C0
	Size: 0x1BE
	Parameters: 7
	Flags: Linked
*/
function rocket_trap_warning_smoke(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_52d911b7 = struct::get("rocket_trap_warning_smoke", "targetname");
	v_forward = anglestoforward(var_52d911b7.angles);
	v_up = anglestoup(var_52d911b7.angles);
	if(isdefined(var_52d911b7.a_fx_id))
	{
		for(j = 0; j < var_52d911b7.a_fx_id.size; j++)
		{
			deletefx(localclientnum, var_52d911b7.a_fx_id[j], 0);
		}
		var_52d911b7.a_fx_id = [];
	}
	if(newval)
	{
		if(!isdefined(var_52d911b7.a_fx_id))
		{
			var_52d911b7.a_fx_id = [];
		}
		var_52d911b7.a_fx_id[localclientnum] = playfx(localclientnum, level._effect["rocket_warning_smoke"], var_52d911b7.origin, v_forward, v_up, 0);
	}
}

/*
	Name: rocket_trap_warning_fire
	Namespace: zm_castle_rocket_trap
	Checksum: 0x3D4737CD
	Offset: 0x588
	Size: 0x1DC
	Parameters: 7
	Flags: Linked
*/
function rocket_trap_warning_fire(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_52d911b7 = struct::get("rocket_trap_warning_fire", "targetname");
	v_forward = anglestoforward(var_52d911b7.angles);
	v_up = anglestoup(var_52d911b7.angles);
	if(isdefined(var_52d911b7.a_fx_id))
	{
		for(j = 0; j < var_52d911b7.a_fx_id.size; j++)
		{
			deletefx(localclientnum, var_52d911b7.a_fx_id[j], 0);
		}
		var_52d911b7.a_fx_id = [];
	}
	if(newval)
	{
		if(!isdefined(var_52d911b7.a_fx_id))
		{
			var_52d911b7.a_fx_id = [];
		}
		var_52d911b7.a_fx_id[localclientnum] = playfx(localclientnum, level._effect["rocket_warning_fire"], var_52d911b7.origin, v_forward, v_up, 0);
	}
	else
	{
		rocket_trap_blast(localclientnum);
	}
}

/*
	Name: rocket_trap_blast
	Namespace: zm_castle_rocket_trap
	Checksum: 0xFE04F401
	Offset: 0x770
	Size: 0x1BC
	Parameters: 1
	Flags: Linked
*/
function rocket_trap_blast(localclientnum)
{
	var_52d911b7 = struct::get("rocket_trap_blast", "targetname");
	v_forward = anglestoforward(var_52d911b7.angles);
	v_up = anglestoup(var_52d911b7.angles);
	n_fx_id = playfx(localclientnum, level._effect["rocket_side_blast"], var_52d911b7.origin, v_forward, v_up, 0);
	wait(0.4);
	var_a62b9cd7 = struct::get_array("rocket_trap_side_blast", "targetname");
	foreach(var_b25c0a2d in var_a62b9cd7)
	{
		var_b25c0a2d thread rocket_trap_side_blast(localclientnum);
	}
	wait(20);
	deletefx(localclientnum, n_fx_id, 0);
}

/*
	Name: rocket_trap_side_blast
	Namespace: zm_castle_rocket_trap
	Checksum: 0xFA2D34A0
	Offset: 0x938
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function rocket_trap_side_blast(localclientnum)
{
	v_forward = anglestoforward(self.angles);
	v_up = anglestoup(self.angles);
	wait(randomfloatrange(0, 1));
	n_id = playfx(localclientnum, level._effect["rocket_side_blast"], self.origin, v_forward, v_up, 0);
	wait(20);
	deletefx(localclientnum, n_id, 0);
}

/*
	Name: sndrocketalarm
	Namespace: zm_castle_rocket_trap
	Checksum: 0xBEA0761D
	Offset: 0xA20
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function sndrocketalarm(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(newval == 1)
		{
			audio::playloopat("evt_rocket_trap_alarm", (4202, -2096, -1438));
			audio::playloopat("evt_rocket_trap_alarm_dist", (4202, -2096, -1437));
		}
		if(newval == 2)
		{
			audio::stoploopat("evt_rocket_trap_alarm", (4202, -2096, -1438));
			audio::stoploopat("evt_rocket_trap_alarm_dist", (4202, -2096, -1437));
		}
	}
}

/*
	Name: sndrockettrap
	Namespace: zm_castle_rocket_trap
	Checksum: 0x65B9E015
	Offset: 0xB30
	Size: 0x1E4
	Parameters: 7
	Flags: Linked
*/
function sndrockettrap(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_dc3c5ca7 = (4202, -2249, -2127);
	if(newval)
	{
		if(newval == 1)
		{
			audio::playloopat("evt_rocket_trap_smoke", var_dc3c5ca7);
		}
		if(newval == 2)
		{
			audio::stoploopat("evt_rocket_trap_smoke", var_dc3c5ca7);
			audio::playloopat("evt_rocket_trap_ignite", var_dc3c5ca7);
			playsound(0, "evt_rocket_trap_ignite_one_shot", var_dc3c5ca7);
		}
		if(newval == 3)
		{
			audio::stoploopat("evt_rocket_trap_ignite", var_dc3c5ca7);
			audio::playloopat("evt_rocket_trap_burn", var_dc3c5ca7);
			playsound(0, "evt_rocket_trap_burn_one_shot", var_dc3c5ca7);
			audio::playloopat("evt_rocket_trap_burn_dist", var_dc3c5ca7 + vectorscale((0, 0, 1), 1000));
		}
		if(newval == 4)
		{
			audio::stoploopat("evt_rocket_trap_burn", var_dc3c5ca7);
			audio::stoploopat("evt_rocket_trap_burn_dist", var_dc3c5ca7 + vectorscale((0, 0, 1), 1000));
		}
	}
}

