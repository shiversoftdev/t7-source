// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_weap_glaive;

/*
	Name: __init__sytem__
	Namespace: zm_weap_glaive
	Checksum: 0xB0BF3911
	Offset: 0x3D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_glaive", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_glaive
	Checksum: 0xD86598C6
	Offset: 0x418
	Size: 0x2AE
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "slam_fx", 1, 1, "counter", &do_slam_fx, 0, 0);
	clientfield::register("toplayer", "throw_fx", 1, 1, "counter", &function_6b6e650c, 0, 0);
	clientfield::register("toplayer", "swipe_fx", 1, 1, "counter", &do_swipe_fx, 0, 0);
	clientfield::register("toplayer", "swipe_lv2_fx", 1, 1, "counter", &function_647dc27d, 0, 0);
	clientfield::register("actor", "zombie_slice_r", 1, 2, "counter", &function_bbeb4c2c, 1, 0);
	clientfield::register("actor", "zombie_slice_l", 1, 2, "counter", &function_38924d95, 1, 0);
	level._effect["sword_swipe_1p"] = "zombie/fx_sword_trail_1p_zod_zmb";
	level._effect["sword_swipe_lv2_1p"] = "zombie/fx_sword_trail_1p_lvl2_zod_zmb";
	level._effect["sword_bloodswipe_r_1p"] = "zombie/fx_sword_slash_right_1p_zod_zmb";
	level._effect["sword_bloodswipe_l_1p"] = "zombie/fx_sword_slash_left_1p_zod_zmb";
	level._effect["sword_bloodswipe_r_level2_1p"] = "zombie/fx_keeper_death_zod_zmb";
	level._effect["sword_bloodswipe_l_level2_1p"] = "zombie/fx_keeper_death_zod_zmb";
	level._effect["groundhit_1p"] = "zombie/fx_sword_slam_elec_1p_zod_zmb";
	level._effect["groundhit_3p"] = "zombie/fx_sword_slam_elec_3p_zod_zmb";
	level._effect["sword_lvl2_throw"] = "zombie/fx_sword_lvl2_throw_1p_zod_zmb";
}

/*
	Name: do_swipe_fx
	Namespace: zm_weap_glaive
	Checksum: 0x14C14BCE
	Offset: 0x6D0
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function do_swipe_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	owner = self getowner(localclientnum);
	if(isdefined(owner) && owner == getlocalplayer(localclientnum))
	{
		swipe_fx = playviewmodelfx(localclientnum, level._effect["sword_swipe_1p"], "tag_flash");
		wait(3);
		deletefx(localclientnum, swipe_fx, 1);
	}
}

/*
	Name: function_647dc27d
	Namespace: zm_weap_glaive
	Checksum: 0x84B7450A
	Offset: 0x7C8
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function function_647dc27d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	owner = self getowner(localclientnum);
	if(isdefined(owner) && owner == getlocalplayer(localclientnum))
	{
		swipe_lv2_fx = playviewmodelfx(localclientnum, level._effect["sword_swipe_lv2_1p"], "tag_flash");
		wait(3);
		deletefx(localclientnum, swipe_lv2_fx, 1);
	}
}

/*
	Name: function_bbeb4c2c
	Namespace: zm_weap_glaive
	Checksum: 0xE4CC7B1C
	Offset: 0x8C0
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function function_bbeb4c2c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(util::is_mature() && !util::is_gib_restricted_build())
	{
		if(newval == 1)
		{
			playfxontag(localclientnum, level._effect["sword_bloodswipe_r_1p"], self, "j_spine4");
		}
		else if(newval == 2)
		{
			playfxontag(localclientnum, level._effect["sword_bloodswipe_r_level2_1p"], self, "j_spineupper");
		}
	}
	self playsound(0, "zmb_sword_zombie_explode");
}

/*
	Name: function_38924d95
	Namespace: zm_weap_glaive
	Checksum: 0x69290AD2
	Offset: 0x9D0
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function function_38924d95(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(util::is_mature() && !util::is_gib_restricted_build())
	{
		if(newval == 1)
		{
			playfxontag(localclientnum, level._effect["sword_bloodswipe_l_1p"], self, "j_spine4");
		}
		else if(newval == 2)
		{
			playfxontag(localclientnum, level._effect["sword_bloodswipe_l_level2_1p"], self, "j_spineupper");
		}
	}
	self playsound(0, "zmb_sword_zombie_explode");
}

/*
	Name: do_slam_fx
	Namespace: zm_weap_glaive
	Checksum: 0x639F2132
	Offset: 0xAE0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function do_slam_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	thread do_gravity_spike_fx(localclientnum, self, self.origin);
}

/*
	Name: function_6b6e650c
	Namespace: zm_weap_glaive
	Checksum: 0x3A70CC4D
	Offset: 0xB48
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function function_6b6e650c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	owner = self getowner(localclientnum);
	if(isdefined(owner) && owner == getlocalplayer(localclientnum))
	{
		var_b7fb3c1b = playfxoncamera(localclientnum, level._effect["sword_lvl2_throw"], (0, 0, 0), (0, 1, 0), (0, 0, 1));
		wait(3);
		deletefx(localclientnum, var_b7fb3c1b, 1);
	}
}

/*
	Name: do_gravity_spike_fx
	Namespace: zm_weap_glaive
	Checksum: 0x1E70591A
	Offset: 0xC40
	Size: 0x19C
	Parameters: 3
	Flags: Linked
*/
function do_gravity_spike_fx(localclientnum, owner, position)
{
	var_f31c9d4c = 0;
	if(self isplayer() && self islocalplayer() && !isdemoplaying())
	{
		if(!isdefined(self getlocalclientnumber()) || localclientnum == self getlocalclientnumber())
		{
			var_f31c9d4c = 1;
		}
	}
	if(var_f31c9d4c)
	{
		fx = level._effect["groundhit_1p"];
		fwd = anglestoforward(owner.angles);
		playfx(localclientnum, fx, position + (fwd * 100), fwd);
	}
	else
	{
		fx = level._effect["groundhit_3p"];
		fwd = anglestoforward(owner.angles);
		playfx(localclientnum, fx, position, fwd);
	}
}

/*
	Name: getideallocationforfx
	Namespace: zm_weap_glaive
	Checksum: 0x5E85FB25
	Offset: 0xDE8
	Size: 0xB6
	Parameters: 5
	Flags: None
*/
function getideallocationforfx(startpos, fxindex, fxcount, defaultdistance, rotation)
{
	currentangle = (360 / fxcount) * fxindex;
	coscurrent = cos(currentangle + rotation);
	sincurrent = sin(currentangle + rotation);
	return startpos + (defaultdistance * coscurrent, defaultdistance * sincurrent, 0);
}

/*
	Name: randomizelocation
	Namespace: zm_weap_glaive
	Checksum: 0x75A51745
	Offset: 0xEA8
	Size: 0xE2
	Parameters: 3
	Flags: None
*/
function randomizelocation(startpos, max_x_offset, max_y_offset)
{
	half_x = int(max_x_offset / 2);
	half_y = int(max_y_offset / 2);
	rand_x = randomintrange(half_x * -1, half_x);
	rand_y = randomintrange(half_y * -1, half_y);
	return startpos + (rand_x, rand_y, 0);
}

/*
	Name: ground_trace
	Namespace: zm_weap_glaive
	Checksum: 0x4FD5A9D4
	Offset: 0xF98
	Size: 0x72
	Parameters: 2
	Flags: None
*/
function ground_trace(startpos, owner)
{
	trace_height = 50;
	trace_depth = 100;
	return bullettrace(startpos + (0, 0, trace_height), startpos - (0, 0, trace_depth), 0, owner);
}

