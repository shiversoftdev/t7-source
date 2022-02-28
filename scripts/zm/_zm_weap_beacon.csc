// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_beacon;

/*
	Name: init
	Namespace: _zm_weap_beacon
	Checksum: 0x6FCD52F9
	Offset: 0x358
	Size: 0x204
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.w_beacon = getweapon("beacon");
	level.var_67735adb = "wpn_t7_zmb_hd_g_strike_world";
	level._effect["beacon_glow"] = "dlc5/tomb/fx_tomb_beacon_glow";
	level._effect["beacon_launch_fx"] = "dlc5/tomb/fx_tomb_beacon_launch";
	level._effect["beacon_shell_explosion"] = "dlc5/tomb/fx_tomb_beacon_exp";
	level._effect["beacon_shell_trail"] = "dlc5/tomb/fx_tomb_beacon_trail";
	clientfield::register("world", "play_launch_artillery_fx_robot_0", 21000, 1, "int", &function_59491961, 0, 0);
	clientfield::register("world", "play_launch_artillery_fx_robot_1", 21000, 1, "int", &function_59491961, 0, 0);
	clientfield::register("world", "play_launch_artillery_fx_robot_2", 21000, 1, "int", &function_59491961, 0, 0);
	clientfield::register("scriptmover", "play_beacon_fx", 21000, 1, "int", &function_dc4ed336, 0, 0);
	clientfield::register("scriptmover", "play_artillery_barrage", 21000, 2, "int", &play_artillery_barrage, 0, 0);
}

/*
	Name: function_59491961
	Namespace: _zm_weap_beacon
	Checksum: 0x2310849F
	Offset: 0x568
	Size: 0x154
	Parameters: 7
	Flags: Linked
*/
function function_59491961(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(issubstr(fieldname, 0))
	{
		ai_robot = level.a_giant_robots[localclientnum][0];
	}
	else
	{
		if(issubstr(fieldname, 1))
		{
			ai_robot = level.a_giant_robots[localclientnum][1];
		}
		else
		{
			ai_robot = level.a_giant_robots[localclientnum][2];
		}
	}
	if(newval == 1)
	{
		playfx(localclientnum, level._effect["beacon_launch_fx"], ai_robot gettagorigin("tag_rocketpod"));
		level thread function_d391c94e(ai_robot gettagorigin("tag_rocketpod"));
	}
}

/*
	Name: function_d391c94e
	Namespace: _zm_weap_beacon
	Checksum: 0xAC61E5EF
	Offset: 0x6C8
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function function_d391c94e(origin)
{
	playsound(0, "zmb_homingbeacon_missiile_alarm", origin);
	for(i = 0; i < 5; i++)
	{
		playsound(0, "zmb_homingbeacon_missile_fire", origin);
		wait(0.15);
	}
}

/*
	Name: function_dc4ed336
	Namespace: _zm_weap_beacon
	Checksum: 0x59668049
	Offset: 0x750
	Size: 0xB0
	Parameters: 7
	Flags: Linked
*/
function function_dc4ed336(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	self endon(#"hash_962e0148");
	while(isdefined(self))
	{
		playsound(0, "evt_beacon_beep", self.origin);
		playfxontag(localclientnum, level._effect["beacon_glow"], self, "origin_animate_jnt");
		wait(1.5);
	}
}

/*
	Name: play_artillery_barrage
	Namespace: _zm_weap_beacon
	Checksum: 0x58BCE7C3
	Offset: 0x808
	Size: 0x2BA
	Parameters: 7
	Flags: Linked
*/
function play_artillery_barrage(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 0)
	{
		return;
	}
	if(newval == 1)
	{
		if(!isdefined(self.a_v_land_offsets))
		{
			self.a_v_land_offsets = [];
		}
		if(!isdefined(self.a_v_land_offsets[localclientnum]))
		{
			self.a_v_land_offsets[localclientnum] = self build_weap_beacon_landing_offsets();
		}
		if(!isdefined(self.a_v_start_offsets))
		{
			self.a_v_start_offsets = [];
		}
		if(!isdefined(self.a_v_start_offsets[localclientnum]))
		{
			self.a_v_start_offsets[localclientnum] = self build_weap_beacon_start_offsets();
		}
	}
	if(newval == 2)
	{
		if(!isdefined(self.a_v_land_offsets))
		{
			self.a_v_land_offsets = [];
		}
		if(!isdefined(self.a_v_land_offsets[localclientnum]))
		{
			self.a_v_land_offsets[localclientnum] = self build_weap_beacon_landing_offsets_ee();
		}
		if(!isdefined(self.a_v_start_offsets))
		{
			self.a_v_start_offsets = [];
		}
		if(!isdefined(self.a_v_start_offsets[localclientnum]))
		{
			self.a_v_start_offsets[localclientnum] = self build_weap_beacon_start_offsets_ee();
		}
	}
	if(!isdefined(self.var_f510f618))
	{
		self.var_f510f618 = [];
	}
	if(!isdefined(self.var_f510f618[localclientnum]))
	{
		self.var_f510f618[localclientnum] = 0;
	}
	n_index = self.var_f510f618[localclientnum];
	v_start = self.origin + self.a_v_start_offsets[localclientnum][n_index];
	shell = spawn(localclientnum, v_start, "script_model");
	shell.angles = vectorscale((-1, 0, 0), 90);
	shell setmodel("tag_origin");
	shell thread function_3700164e(self, n_index, v_start, localclientnum);
	self.var_f510f618[localclientnum]++;
}

/*
	Name: build_weap_beacon_landing_offsets
	Namespace: _zm_weap_beacon
	Checksum: 0x6319AC46
	Offset: 0xAD0
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function build_weap_beacon_landing_offsets()
{
	a_offsets = [];
	a_offsets[0] = (0, 0, 0);
	a_offsets[1] = vectorscale((-1, 1, 0), 72);
	a_offsets[2] = vectorscale((1, 1, 0), 72);
	a_offsets[3] = vectorscale((1, -1, 0), 72);
	a_offsets[4] = vectorscale((-1, -1, 0), 72);
	return a_offsets;
}

/*
	Name: build_weap_beacon_start_offsets
	Namespace: _zm_weap_beacon
	Checksum: 0x2D221072
	Offset: 0xB60
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function build_weap_beacon_start_offsets()
{
	a_offsets = [];
	a_offsets[0] = vectorscale((0, 0, 1), 8500);
	a_offsets[1] = (-6500, 6500, 8500);
	a_offsets[2] = (6500, 6500, 8500);
	a_offsets[3] = (6500, -6500, 8500);
	a_offsets[4] = (-6500, -6500, 8500);
	return a_offsets;
}

/*
	Name: build_weap_beacon_landing_offsets_ee
	Namespace: _zm_weap_beacon
	Checksum: 0x9C82ACC5
	Offset: 0xC00
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function build_weap_beacon_landing_offsets_ee()
{
	a_offsets = [];
	a_offsets[0] = (0, 0, 0);
	a_offsets[1] = vectorscale((-1, 1, 0), 72);
	a_offsets[2] = vectorscale((1, 1, 0), 72);
	a_offsets[3] = vectorscale((1, -1, 0), 72);
	a_offsets[4] = vectorscale((-1, -1, 0), 72);
	a_offsets[5] = vectorscale((-1, 1, 0), 72);
	a_offsets[6] = vectorscale((1, 1, 0), 72);
	a_offsets[7] = vectorscale((1, -1, 0), 72);
	a_offsets[8] = vectorscale((-1, -1, 0), 72);
	a_offsets[9] = vectorscale((-1, 1, 0), 72);
	a_offsets[10] = vectorscale((1, 1, 0), 72);
	a_offsets[11] = vectorscale((1, -1, 0), 72);
	a_offsets[12] = vectorscale((-1, -1, 0), 72);
	a_offsets[13] = vectorscale((-1, 1, 0), 72);
	a_offsets[14] = vectorscale((1, 1, 0), 72);
	return a_offsets;
}

/*
	Name: build_weap_beacon_start_offsets_ee
	Namespace: _zm_weap_beacon
	Checksum: 0xF9455FBB
	Offset: 0xD80
	Size: 0x19A
	Parameters: 0
	Flags: Linked
*/
function build_weap_beacon_start_offsets_ee()
{
	a_offsets = [];
	a_offsets[0] = vectorscale((0, 0, 1), 8500);
	a_offsets[1] = (-6500, 6500, 8500);
	a_offsets[2] = (6500, 6500, 8500);
	a_offsets[3] = (6500, -6500, 8500);
	a_offsets[4] = (-6500, -6500, 8500);
	a_offsets[5] = (-6500, 6500, 8500);
	a_offsets[6] = (6500, 6500, 8500);
	a_offsets[7] = (6500, -6500, 8500);
	a_offsets[8] = (-6500, -6500, 8500);
	a_offsets[9] = (-6500, 6500, 8500);
	a_offsets[10] = (6500, 6500, 8500);
	a_offsets[11] = (6500, -6500, 8500);
	a_offsets[12] = (-6500, -6500, 8500);
	a_offsets[13] = (-6500, 6500, 8500);
	a_offsets[14] = (6500, 6500, 8500);
	return a_offsets;
}

/*
	Name: function_3700164e
	Namespace: _zm_weap_beacon
	Checksum: 0xA062F7EA
	Offset: 0xF28
	Size: 0x1D4
	Parameters: 4
	Flags: Linked
*/
function function_3700164e(model, index, v_start, localclientnum)
{
	var_89ea469b = model.origin + model.a_v_land_offsets[localclientnum][index];
	v_start_trace = v_start - vectorscale((0, 0, 1), 5000);
	trace = bullettrace(v_start_trace, var_89ea469b, 0, undefined);
	var_89ea469b = trace["position"];
	self moveto(var_89ea469b, 3);
	playfxontag(localclientnum, level._effect["beacon_shell_trail"], self, "tag_origin");
	self playsound(0, "zmb_homingbeacon_missile_boom");
	self thread function_42cb41ec(var_89ea469b);
	self waittill(#"movedone");
	if(index == 1)
	{
		model notify(#"hash_962e0148");
	}
	playfx(localclientnum, level._effect["beacon_shell_explosion"], self.origin);
	playsound(0, "wpn_rocket_explode", self.origin);
	self delete();
}

/*
	Name: function_42cb41ec
	Namespace: _zm_weap_beacon
	Checksum: 0xC674DA7
	Offset: 0x1108
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_42cb41ec(origin)
{
	wait(2);
	playsound(0, "zmb_homingbeacon_missile_incoming", origin);
}

