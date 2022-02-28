// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\postfx_shared;

#namespace zm_genesis_flingers;

/*
	Name: main
	Namespace: zm_genesis_flingers
	Checksum: 0xC6C2070C
	Offset: 0x3D8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	register_clientfields();
	level thread function_4208db02();
}

/*
	Name: register_clientfields
	Namespace: zm_genesis_flingers
	Checksum: 0x66D4FC8B
	Offset: 0x410
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("toplayer", "flinger_flying_postfx", 15000, 1, "int", &flinger_flying_postfx, 0, 0);
	clientfield::register("toplayer", "flinger_land_smash", 15000, 1, "counter", &flinger_land_smash, 0, 0);
	clientfield::register("toplayer", "flinger_cooldown_start", 15000, 4, "int", &flinger_cooldown_start, 0, 0);
	clientfield::register("toplayer", "flinger_cooldown_end", 15000, 4, "int", &flinger_cooldown_end, 0, 0);
	clientfield::register("scriptmover", "player_visibility", 15000, 1, "int", &function_a0a5829, 0, 0);
	clientfield::register("scriptmover", "flinger_launch_fx", 15000, 1, "counter", &function_3762396c, 0, 0);
	clientfield::register("scriptmover", "flinger_pad_active_fx", 15000, 4, "int", &flinger_pad_active_fx, 0, 0);
}

/*
	Name: flinger_flying_postfx
	Namespace: zm_genesis_flingers
	Checksum: 0x4C265362
	Offset: 0x618
	Size: 0x15C
	Parameters: 7
	Flags: Linked
*/
function flinger_flying_postfx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self.var_6f6f69f0 = playfxontag(localclientnum, level._effect["flinger_trail"], self, "tag_origin");
		self.var_bb0de733 = self playloopsound("zmb_fling_windwhoosh_2d");
		self thread postfx::playpostfxbundle("pstfx_zm_screen_warp");
	}
	else
	{
		if(isdefined(self.var_6f6f69f0))
		{
			deletefx(localclientnum, self.var_6f6f69f0, 1);
			self.var_6f6f69f0 = undefined;
		}
		if(isdefined(self.var_bb0de733))
		{
			self stoploopsound(self.var_bb0de733, 0.75);
			self.var_bb0de733 = undefined;
		}
		self thread postfx::exitpostfxbundle();
	}
}

/*
	Name: function_ddcc2bf9
	Namespace: zm_genesis_flingers
	Checksum: 0x9624BF55
	Offset: 0x780
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function function_ddcc2bf9(localclientnum, var_bfcf4a2a)
{
	if(!self hasdobj(localclientnum))
	{
		return;
	}
	if(var_bfcf4a2a == 1)
	{
		self hidepart(localclientnum, "tag_blue");
		self showpart(localclientnum, "tag_red");
	}
	else
	{
		self hidepart(localclientnum, "tag_red");
		self showpart(localclientnum, "tag_blue");
	}
}

/*
	Name: flinger_pad_active_fx
	Namespace: zm_genesis_flingers
	Checksum: 0x2CFEB18C
	Offset: 0x850
	Size: 0xF4
	Parameters: 7
	Flags: Linked
*/
function flinger_pad_active_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval > 0)
	{
		var_1143aa58 = getent(localclientnum, level.var_5646965[newval]["pad"], "targetname");
		var_1143aa58 thread function_ddcc2bf9(localclientnum, 0);
		exploder::stop_exploder(level.var_5646965[newval]["cooldown"]);
		exploder::exploder(level.var_5646965[newval]["ready"]);
	}
}

/*
	Name: flinger_land_smash
	Namespace: zm_genesis_flingers
	Checksum: 0x6D03CAB9
	Offset: 0x950
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function flinger_land_smash(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level notify(#"hash_92663c14");
	playfxontag(localclientnum, level._effect["flinger_land"], self, "tag_origin");
}

/*
	Name: flinger_cooldown_start
	Namespace: zm_genesis_flingers
	Checksum: 0xE0045620
	Offset: 0x9D8
	Size: 0x1C4
	Parameters: 7
	Flags: Linked
*/
function flinger_cooldown_start(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval > 0)
	{
		var_1143aa58 = getent(localclientnum, level.var_5646965[newval]["pad"], "targetname");
		var_1143aa58 thread function_ddcc2bf9(localclientnum, 1);
		exploder::stop_exploder(level.var_5646965[newval]["ready"]);
		exploder::exploder(level.var_5646965[newval]["cooldown"]);
		var_32149294 = level.var_5646965[newval]["landpad"];
		var_f201110a = getent(localclientnum, level.var_5646965[var_32149294]["pad"], "targetname");
		var_f201110a thread function_ddcc2bf9(localclientnum, 1);
		exploder::stop_exploder(level.var_5646965[var_32149294]["ready"]);
		exploder::exploder(level.var_5646965[var_32149294]["cooldown"]);
	}
}

/*
	Name: flinger_cooldown_end
	Namespace: zm_genesis_flingers
	Checksum: 0x1087EBD4
	Offset: 0xBA8
	Size: 0x1C4
	Parameters: 7
	Flags: Linked
*/
function flinger_cooldown_end(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval > 0)
	{
		var_1143aa58 = getent(localclientnum, level.var_5646965[newval]["pad"], "targetname");
		var_1143aa58 thread function_ddcc2bf9(localclientnum, 0);
		exploder::stop_exploder(level.var_5646965[newval]["cooldown"]);
		exploder::exploder(level.var_5646965[newval]["ready"]);
		var_32149294 = level.var_5646965[newval]["landpad"];
		var_f201110a = getent(localclientnum, level.var_5646965[var_32149294]["pad"], "targetname");
		var_f201110a thread function_ddcc2bf9(localclientnum, 0);
		exploder::stop_exploder(level.var_5646965[var_32149294]["cooldown"]);
		exploder::exploder(level.var_5646965[var_32149294]["ready"]);
	}
}

/*
	Name: function_3762396c
	Namespace: zm_genesis_flingers
	Checksum: 0x42417813
	Offset: 0xD78
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function function_3762396c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfxontag(localclientnum, level._effect["flinger_launch"], self, "tag_origin");
}

/*
	Name: function_4208db02
	Namespace: zm_genesis_flingers
	Checksum: 0x49841DCD
	Offset: 0xDF0
	Size: 0x474
	Parameters: 0
	Flags: Linked
*/
function function_4208db02()
{
	level.var_5646965 = [];
	level.var_5646965[1] = [];
	level.var_5646965[2] = [];
	level.var_5646965[3] = [];
	level.var_5646965[4] = [];
	level.var_5646965[5] = [];
	level.var_5646965[6] = [];
	level.var_5646965[7] = [];
	level.var_5646965[8] = [];
	level.var_5646965[1]["ready"] = "fxexp_150";
	level.var_5646965[1]["cooldown"] = "fxexp_350";
	level.var_5646965[1]["pad"] = "upper_courtyard_flinger_base7";
	level.var_5646965[1]["landpad"] = 8;
	level.var_5646965[2]["ready"] = "fxexp_151";
	level.var_5646965[2]["cooldown"] = "fxexp_351";
	level.var_5646965[2]["pad"] = "upper_courtyard_flinger_base12";
	level.var_5646965[2]["landpad"] = 3;
	level.var_5646965[3]["ready"] = "fxexp_152";
	level.var_5646965[3]["cooldown"] = "fxexp_352";
	level.var_5646965[3]["pad"] = "upper_courtyard_flinger_base11";
	level.var_5646965[3]["landpad"] = 2;
	level.var_5646965[4]["ready"] = "fxexp_153";
	level.var_5646965[4]["cooldown"] = "fxexp_353";
	level.var_5646965[4]["pad"] = "upper_courtyard_flinger_base4";
	level.var_5646965[4]["landpad"] = 5;
	level.var_5646965[5]["ready"] = "fxexp_154";
	level.var_5646965[5]["cooldown"] = "fxexp_354";
	level.var_5646965[5]["pad"] = "upper_courtyard_flinger_base3";
	level.var_5646965[5]["landpad"] = 4;
	level.var_5646965[6]["ready"] = "fxexp_155";
	level.var_5646965[6]["cooldown"] = "fxexp_355";
	level.var_5646965[6]["pad"] = "upper_courtyard_flinger_base5";
	level.var_5646965[6]["landpad"] = 7;
	level.var_5646965[7]["ready"] = "fxexp_156";
	level.var_5646965[7]["cooldown"] = "fxexp_356";
	level.var_5646965[7]["pad"] = "upper_courtyard_flinger_base6";
	level.var_5646965[7]["landpad"] = 6;
	level.var_5646965[8]["ready"] = "fxexp_157";
	level.var_5646965[8]["cooldown"] = "fxexp_357";
	level.var_5646965[8]["pad"] = "upper_courtyard_flinger_base8";
	level.var_5646965[8]["landpad"] = 1;
}

/*
	Name: function_a0a5829
	Namespace: zm_genesis_flingers
	Checksum: 0x7FDD1481
	Offset: 0x1270
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function function_a0a5829(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		if(self.owner == getlocalplayer(localclientnum))
		{
			self thread function_7bd5b92f(localclientnum);
		}
	}
}

/*
	Name: function_7bd5b92f
	Namespace: zm_genesis_flingers
	Checksum: 0x887ED4AC
	Offset: 0x1300
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_7bd5b92f(localclientnum)
{
	player = getlocalplayer(localclientnum);
	if(isdefined(player))
	{
		if(isthirdperson(localclientnum))
		{
			self show();
			player hide();
		}
		else
		{
			self hide();
		}
	}
}

