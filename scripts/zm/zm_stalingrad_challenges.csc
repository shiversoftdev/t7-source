// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_stalingrad_challenges;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_challenges
	Checksum: 0x3B5AD3F9
	Offset: 0x3B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_challenges", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_challenges
	Checksum: 0x8A3D9FC6
	Offset: 0x3F0
	Size: 0x3E4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	var_a42274ee = struct::get_array("challenge_fire_struct", "targetname");
	foreach(var_d2c81bd9 in var_a42274ee)
	{
		var_d2c81bd9.var_90369c89 = [];
	}
	level function_5d17d17c();
	level._effect["grave_fire"] = "dlc3/stalingrad/fx_grave_stone_glow";
	level._effect["grave_arm_fx"] = "dlc3/stalingrad/fx_dirt_hand_burst_challenges";
	level._effect["pr_c_fx"] = "fire/fx_fire_candle_flame_tall";
	clientfield::register("toplayer", "challenge_grave_fire", 12000, 2, "int", &function_6f749a23, 0, 1);
	clientfield::register("scriptmover", "challenge_arm_reveal", 12000, 1, "counter", &function_87a462eb, 0, 0);
	clientfield::register("toplayer", "pr_b", 12000, 3, "int", &function_93efc4ef, 0, 1);
	clientfield::register("toplayer", "pr_c", 12000, 3, "int", &function_553225f, 0, 1);
	clientfield::register("toplayer", "pr_l_c", 12000, 1, "int", &function_20880e24, 0, 0);
	clientfield::register("missile", "pr_gm_e_fx", 12000, 1, "int", &function_e28f1c4a, 0, 0);
	clientfield::register("scriptmover", "pr_g_c_fx", 12000, 1, "int", &function_d4db02b2, 0, 0);
	clientfield::register("toplayer", "challenge1state", 14000, 2, "int", &function_4ff59189, 0, 0);
	clientfield::register("toplayer", "challenge2state", 14000, 2, "int", &function_4ff59189, 0, 0);
	clientfield::register("toplayer", "challenge3state", 14000, 2, "int", &function_4ff59189, 0, 0);
}

/*
	Name: function_5d17d17c
	Namespace: zm_stalingrad_challenges
	Checksum: 0xE83B2096
	Offset: 0x7E0
	Size: 0x166
	Parameters: 0
	Flags: Linked
*/
function function_5d17d17c()
{
	var_77797571 = struct::get_array("pr_b_spawn", "targetname");
	foreach(var_4af818ae in var_77797571)
	{
		var_4af818ae.var_46f4840b = [];
	}
	var_977659a7 = struct::get_array("pr_c_spawn", "targetname");
	foreach(var_238c2594 in var_977659a7)
	{
		var_238c2594.var_453e8445 = [];
		var_238c2594.var_90369c89 = [];
	}
}

/*
	Name: function_6f749a23
	Namespace: zm_stalingrad_challenges
	Checksum: 0x8774C0A6
	Offset: 0x950
	Size: 0x1F6
	Parameters: 7
	Flags: Linked
*/
function function_6f749a23(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_a42274ee = struct::get_array("challenge_fire_struct", "targetname");
	foreach(var_d2c81bd9 in var_a42274ee)
	{
		if(var_d2c81bd9.script_int == self getentitynumber())
		{
			if(!isdefined(var_d2c81bd9.var_90369c89[localclientnum]))
			{
				var_d2c81bd9.var_90369c89[localclientnum] = playfx(localclientnum, level._effect["grave_fire"], var_d2c81bd9.origin + (vectorscale((0, 0, -1), 8)));
				audio::playloopat("zmb_challenge_fire_lp", var_d2c81bd9.origin);
			}
			continue;
		}
		if(isdefined(var_d2c81bd9.var_90369c89[localclientnum]))
		{
			deletefx(localclientnum, var_d2c81bd9.var_90369c89[localclientnum]);
			var_d2c81bd9.var_90369c89[localclientnum] = undefined;
		}
	}
}

/*
	Name: function_87a462eb
	Namespace: zm_stalingrad_challenges
	Checksum: 0x2AF06309
	Offset: 0xB50
	Size: 0xA4
	Parameters: 7
	Flags: Linked
*/
function function_87a462eb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playrumbleonposition(localclientnum, "zm_stalingrad_challenge_arm_rumble", self.origin);
		playfx(localclientnum, level._effect["grave_arm_fx"], self.origin, (0, 0, 1));
	}
}

/*
	Name: function_93efc4ef
	Namespace: zm_stalingrad_challenges
	Checksum: 0x8EB9F25B
	Offset: 0xC00
	Size: 0x25A
	Parameters: 7
	Flags: Linked
*/
function function_93efc4ef(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_77797571 = struct::get_array("pr_b_spawn", "targetname");
	if(newval == 4)
	{
		foreach(var_4af818ae in var_77797571)
		{
			if(isdefined(var_4af818ae.var_46f4840b[localclientnum]))
			{
				var_4af818ae.var_46f4840b[localclientnum] delete();
			}
		}
	}
	else
	{
		foreach(var_4af818ae in var_77797571)
		{
			if(var_4af818ae.script_int == self getentitynumber())
			{
				if(!isdefined(var_4af818ae.var_46f4840b[localclientnum]))
				{
					var_4af818ae.var_46f4840b[localclientnum] = util::spawn_model(localclientnum, "p7_foliage_flower_bouquet_glass", var_4af818ae.origin, var_4af818ae.angles);
				}
				continue;
			}
			if(isdefined(var_4af818ae.var_46f4840b[localclientnum]))
			{
				var_4af818ae.var_46f4840b[localclientnum] delete();
			}
		}
	}
}

/*
	Name: function_553225f
	Namespace: zm_stalingrad_challenges
	Checksum: 0x3F4A4969
	Offset: 0xE68
	Size: 0x37A
	Parameters: 7
	Flags: Linked
*/
function function_553225f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	var_977659a7 = struct::get_array("pr_c_spawn", "targetname");
	if(newval == 4)
	{
		foreach(var_238c2594 in var_977659a7)
		{
			if(isdefined(var_238c2594.var_453e8445[localclientnum]))
			{
				var_238c2594.var_453e8445[localclientnum] delete();
			}
			if(isdefined(var_238c2594.var_90369c89[localclientnum]))
			{
				deletefx(localclientnum, var_238c2594.var_90369c89[localclientnum]);
			}
		}
	}
	else
	{
		foreach(var_238c2594 in var_977659a7)
		{
			if(var_238c2594.script_int == self getentitynumber())
			{
				if(!isdefined(var_238c2594.var_453e8445[localclientnum]))
				{
					if(isdefined(self.var_d3aeebe1) && self.var_d3aeebe1)
					{
						str_model = "p7_candle_tall_on";
						var_238c2594.var_90369c89[localclientnum] = playfx(localclientnum, level._effect["pr_c_fx"], var_238c2594.origin + (-1.25, 0, 5));
					}
					else
					{
						str_model = "p7_candle_tall";
					}
					var_238c2594.var_453e8445[localclientnum] = util::spawn_model(localclientnum, str_model, var_238c2594.origin, var_238c2594.angles);
				}
				continue;
			}
			if(isdefined(var_238c2594.var_453e8445[localclientnum]))
			{
				var_238c2594.var_453e8445[localclientnum] delete();
			}
			if(isdefined(var_238c2594.var_90369c89[localclientnum]))
			{
				deletefx(localclientnum, var_238c2594.var_90369c89[localclientnum]);
			}
		}
	}
}

/*
	Name: function_20880e24
	Namespace: zm_stalingrad_challenges
	Checksum: 0x568E291A
	Offset: 0x11F0
	Size: 0x1FC
	Parameters: 7
	Flags: Linked
*/
function function_20880e24(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		var_977659a7 = struct::get_array("pr_c_spawn", "targetname");
		foreach(var_238c2594 in var_977659a7)
		{
			if(var_238c2594.script_int == self getentitynumber())
			{
				if(isdefined(var_238c2594.var_453e8445[localclientnum]) && (!(isdefined(self.var_d3aeebe1) && self.var_d3aeebe1)))
				{
					self.var_d3aeebe1 = 1;
					var_238c2594.var_453e8445[localclientnum] setmodel("p7_candle_tall_on");
					var_238c2594.var_453e8445[localclientnum] playloopsound("zmb_candle_pickup_lp");
					var_238c2594.var_90369c89[localclientnum] = playfx(localclientnum, level._effect["pr_c_fx"], var_238c2594.origin + (-1.25, 0, 5));
				}
			}
		}
	}
}

/*
	Name: function_e28f1c4a
	Namespace: zm_stalingrad_challenges
	Checksum: 0xC5947C59
	Offset: 0x13F8
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function function_e28f1c4a(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfx(localclientnum, level._effect["generic_explosion"], self.origin);
		playrumbleonposition(localclientnum, "zm_stalingrad_ee_safe_smash", self.origin);
		self playsound(0, "wpn_grenade_explode");
	}
}

/*
	Name: function_d4db02b2
	Namespace: zm_stalingrad_challenges
	Checksum: 0x7D99140A
	Offset: 0x14C0
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function function_d4db02b2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.n_fx_id = playfx(localclientnum, level._effect["pr_c_fx"], self.origin + (-1.25, 0, 5));
	}
	else
	{
		stopfx(localclientnum, self.n_fx_id);
	}
}

/*
	Name: function_4ff59189
	Namespace: zm_stalingrad_challenges
	Checksum: 0x5C5B9777
	Offset: 0x1578
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function function_4ff59189(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isspectating(localclientnum))
	{
		return;
	}
	var_42bfa7b6 = getuimodel(getuimodelforcontroller(localclientnum), "trialWidget." + fieldname);
	if(isdefined(var_42bfa7b6))
	{
		setuimodelvalue(var_42bfa7b6, newval);
	}
}

