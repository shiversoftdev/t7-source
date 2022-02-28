// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_island_power;

/*
	Name: init
	Namespace: zm_island_power
	Checksum: 0xA58A8E1A
	Offset: 0x258
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("scriptmover", "bucket_fx", 9000, 1, "int", &bucket_fx, 0, 0);
	clientfield::register("world", "power_switch_1_fx", 9000, 1, "int", &power_switch_1_fx, 0, 0);
	clientfield::register("world", "power_switch_2_fx", 9000, 1, "int", &power_switch_2_fx, 0, 0);
	clientfield::register("world", "penstock_fx_anim", 9000, 1, "int", &function_8816d2aa, 0, 0);
	clientfield::register("scriptmover", "power_plant_glow", 9000, 1, "int", &power_plant_glow, 0, 0);
}

/*
	Name: bucket_fx
	Namespace: zm_island_power
	Checksum: 0x5C8CEBD
	Offset: 0x3D0
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function bucket_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.fx_id))
	{
		deletefx(localclientnum, self.fx_id);
		self.fx_id = undefined;
	}
	if(newval == 1)
	{
		self.fx_id = playfxontag(localclientnum, level._effect["bucket_fx"], self, "tag_origin");
	}
}

/*
	Name: power_switch_1_fx
	Namespace: zm_island_power
	Checksum: 0xB2C01677
	Offset: 0x4B8
	Size: 0x3A4
	Parameters: 7
	Flags: Linked
*/
function power_switch_1_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	a_s_fx = struct::get_array("power_switch_1_fx", "targetname");
	foreach(s_fx in a_s_fx)
	{
		if(isdefined(s_fx.a_fx_id))
		{
			a_keys = getarraykeys(s_fx.a_fx_id);
			if(isinarray(a_keys, localclientnum))
			{
				deletefx(localclientnum, s_fx.a_fx_id[localclientnum], 0);
			}
		}
	}
	if(newval == 1)
	{
		var_92ee343f = getent(localclientnum, "power_wires_lab_a", "targetname");
		var_92ee343f thread function_5ae9f178(localclientnum, 0);
		foreach(s_fx in a_s_fx)
		{
			if(!isdefined(s_fx.a_fx_id))
			{
				s_fx.a_fx_id = [];
			}
			s_fx.a_fx_id[localclientnum] = playfx(localclientnum, level._effect["tower_light_red"], s_fx.origin);
		}
	}
	else
	{
		var_92ee343f = getent(localclientnum, "power_wires_lab_a", "targetname");
		var_92ee343f thread function_5ae9f178(localclientnum, 1);
		foreach(s_fx in a_s_fx)
		{
			if(!isdefined(s_fx.a_fx_id))
			{
				s_fx.a_fx_id = [];
			}
			s_fx.a_fx_id[localclientnum] = playfx(localclientnum, level._effect["tower_light_green"], s_fx.origin);
		}
	}
}

/*
	Name: power_switch_2_fx
	Namespace: zm_island_power
	Checksum: 0x8315189E
	Offset: 0x868
	Size: 0x3A4
	Parameters: 7
	Flags: Linked
*/
function power_switch_2_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	a_s_fx = struct::get_array("power_switch_2_fx", "targetname");
	foreach(s_fx in a_s_fx)
	{
		if(isdefined(s_fx.a_fx_id))
		{
			a_keys = getarraykeys(s_fx.a_fx_id);
			if(isinarray(a_keys, localclientnum))
			{
				deletefx(localclientnum, s_fx.a_fx_id[localclientnum], 0);
			}
		}
	}
	if(newval == 1)
	{
		var_92ee343f = getent(localclientnum, "power_wires_lab_b", "targetname");
		var_92ee343f thread function_5ae9f178(localclientnum, 0);
		foreach(s_fx in a_s_fx)
		{
			if(!isdefined(s_fx.a_fx_id))
			{
				s_fx.a_fx_id = [];
			}
			s_fx.a_fx_id[localclientnum] = playfx(localclientnum, level._effect["tower_light_red"], s_fx.origin);
		}
	}
	else
	{
		var_92ee343f = getent(localclientnum, "power_wires_lab_b", "targetname");
		var_92ee343f thread function_5ae9f178(localclientnum, 1);
		foreach(s_fx in a_s_fx)
		{
			if(!isdefined(s_fx.a_fx_id))
			{
				s_fx.a_fx_id = [];
			}
			s_fx.a_fx_id[localclientnum] = playfx(localclientnum, level._effect["tower_light_green"], s_fx.origin);
		}
	}
}

/*
	Name: function_5ae9f178
	Namespace: zm_island_power
	Checksum: 0x3EB5843
	Offset: 0xC18
	Size: 0x1C0
	Parameters: 2
	Flags: Linked
*/
function function_5ae9f178(localclientnum, b_on = 1)
{
	self endon(#"entityshutdown");
	self notify(#"hash_67a9e087");
	self endon(#"hash_67a9e087");
	n_start_time = gettime();
	n_end_time = n_start_time + (2 * 1000);
	b_is_updating = 1;
	if(isdefined(b_on) && b_on)
	{
		n_max = 1;
		n_min = 0;
	}
	else
	{
		n_max = 0;
		n_min = 1;
	}
	while(b_is_updating)
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_time);
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: function_8816d2aa
	Namespace: zm_island_power
	Checksum: 0x50BB08B9
	Offset: 0xDE0
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_8816d2aa(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		scene::init("p7_fxanim_zm_island_penstock_vent_stuck_bundle");
	}
	else
	{
		scene::play("p7_fxanim_zm_island_penstock_vent_stuck_bundle");
	}
}

/*
	Name: power_plant_glow
	Namespace: zm_island_power
	Checksum: 0x114B2009
	Offset: 0xE70
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function power_plant_glow(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self thread function_a88bde9b(localclientnum, 1);
	}
	else
	{
		self thread function_a88bde9b(localclientnum, 0);
	}
}

/*
	Name: function_a88bde9b
	Namespace: zm_island_power
	Checksum: 0x77305CEE
	Offset: 0xF00
	Size: 0x1C0
	Parameters: 2
	Flags: Linked
*/
function function_a88bde9b(localclientnum, b_on = 1)
{
	self endon(#"entityshutdown");
	self notify(#"hash_67a9e087");
	self endon(#"hash_67a9e087");
	n_start_time = gettime();
	n_end_time = n_start_time + (2 * 1000);
	b_is_updating = 1;
	if(isdefined(b_on) && b_on)
	{
		n_max = 1;
		n_min = 0;
	}
	else
	{
		n_max = 0;
		n_min = 1;
	}
	while(b_is_updating)
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, n_min, n_max, n_time);
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

