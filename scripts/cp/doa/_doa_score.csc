// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\cp_doa_bo3_fx;
#using scripts\cp\cp_doa_bo3_sound;
#using scripts\cp\doa\_doa_arena;
#using scripts\cp\doa\_doa_camera;
#using scripts\cp\doa\_doa_core;
#using scripts\cp\doa\_doa_fx;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace namespace_64c6b720;

/*
	Name: init
	Namespace: namespace_64c6b720
	Checksum: 0xCD6B6813
	Offset: 0x438
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function init()
{
	clientfield::register("world", "set_scoreHidden", 1, 1, "int", &function_7fe5e3f4, 0, 0);
	for(i = 0; i < 4; i++)
	{
		clientfield::register("world", "set_ui_gprDOA" + i, 1, 30, "int", &function_2db8b053, 0, 0);
		clientfield::register("world", "set_ui_gpr2DOA" + i, 1, 30, "int", &function_b9397b2b, 0, 0);
		clientfield::register("world", "set_ui_GlobalGPR" + i, 1, 30, "int", &function_e0f15ca4, 0, 0);
	}
	clientfield::register("world", "startCountdown", 1, 3, "int", &function_75319a37, 0, 0);
	callback::on_spawned(&on_player_spawn);
	function_6fa6dee2();
}

/*
	Name: function_6fa6dee2
	Namespace: namespace_64c6b720
	Checksum: 0x3BBC555D
	Offset: 0x600
	Size: 0x9EC
	Parameters: 0
	Flags: Linked
*/
function function_6fa6dee2()
{
	globalmodel = getglobaluimodel();
	level.var_7e2a814c = createuimodel(globalmodel, "DeadOpsArcadeGlobal");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gbanner"), "");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "grgb1"), "0 255 0");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "grgb2"), "255 255 0");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "grgb3"), "255 0 0");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gtxt0"), "");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gpr0"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gpr1"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gpr2"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gpr3"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "redins"), "");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "countdown"), "");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "level"), 1);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "driving"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "hint"), "");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "instruct"), "");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "round"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "teleporter"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "numexits"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gameover"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "doafps"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "changingLevel"), 0);
	level.var_b9d30140 = [];
	var_483f522 = createuimodel(globalmodel, "DeadOpsArcadePlayers");
	for(i = 1; i <= 4; i++)
	{
		model = createuimodel(var_483f522, "player" + i);
		setuimodelvalue(createuimodel(model, "name"), "");
		setuimodelvalue(createuimodel(model, "lives"), 0);
		setuimodelvalue(createuimodel(model, "bombs"), 0);
		setuimodelvalue(createuimodel(model, "boosts"), 0);
		setuimodelvalue(createuimodel(model, "score"), "0");
		setuimodelvalue(createuimodel(model, "multiplier"), 0);
		setuimodelvalue(createuimodel(model, "xbar"), 0);
		setuimodelvalue(createuimodel(model, "bulletbar"), 0);
		setuimodelvalue(createuimodel(model, "bulletbar_rgb"), "255 208 0");
		setuimodelvalue(createuimodel(model, "ribbon"), 0);
		setuimodelvalue(createuimodel(model, "gpr_rgb"), "0 255 0");
		setuimodelvalue(createuimodel(model, "generic_txt"), "");
		setuimodelvalue(createuimodel(model, "gpr"), 0);
		setuimodelvalue(createuimodel(model, "gpr2"), 0);
		setuimodelvalue(createuimodel(model, "weaplevel1"), 0);
		setuimodelvalue(createuimodel(model, "weaplevel2"), 0);
		setuimodelvalue(createuimodel(model, "respawn"), "");
		level.var_b9d30140[level.var_b9d30140.size] = model;
	}
	level.var_c8a4d758 = 0;
	level.gpr = array(0, 0, 0, 0);
	level.var_29e6f519 = [];
	for(i = 0; i < 4; i++)
	{
		doa = spawnstruct();
		doa.ui_model = level.var_b9d30140[i];
		level.var_29e6f519[level.var_29e6f519.size] = doa;
		function_e06716c7(doa, i);
	}
	level thread function_cdb6d911();
	level thread function_4d819138();
	level thread function_2c9a6a47();
}

/*
	Name: function_d3f117f9
	Namespace: namespace_64c6b720
	Checksum: 0x1413355F
	Offset: 0xFF8
	Size: 0x1F8
	Parameters: 2
	Flags: Linked
*/
function function_d3f117f9(doa, idx)
{
	if(!isdefined(doa))
	{
		return;
	}
	/#
		for(i = 0; i < level.var_29e6f519.size; i++)
		{
			if(level.var_29e6f519[i] == doa)
			{
				idx = i;
				break;
			}
		}
		loc_00001094:
		txt = "" + (isdefined(idx) ? idx : "") + "" + (isdefined(doa.player) ? doa.player getentitynumber() : "");
		namespace_693feb87::debugmsg(txt);
	#/
	doa.score = 0;
	doa.var_db3637c0 = 0;
	doa.var_c4c3767e = 0;
	doa.lives = 3;
	doa.bombs = 1;
	doa.boosters = 2;
	doa.var_4d5a5848 = 0;
	doa.multiplier = 1;
	doa.name = "";
	doa.gpr = 0;
	doa.var_4b3052ec = 0;
	doa.var_4f0e30c = 0;
	doa.var_c88a6593 = 0;
	doa.var_c86225b5 = 0;
}

/*
	Name: function_e06716c7
	Namespace: namespace_64c6b720
	Checksum: 0x6A1B22D2
	Offset: 0x11F8
	Size: 0x4A4
	Parameters: 2
	Flags: Linked
*/
function function_e06716c7(doa, idx)
{
	function_d3f117f9(doa, idx);
	if(isdefined(doa.ui_model) && isdefined(getuimodel(doa.ui_model, "name")))
	{
		setuimodelvalue(getuimodel(doa.ui_model, "name"), doa.name);
		setuimodelvalue(getuimodel(doa.ui_model, "lives"), doa.lives);
		setuimodelvalue(getuimodel(doa.ui_model, "bombs"), doa.bombs);
		setuimodelvalue(getuimodel(doa.ui_model, "boosts"), doa.boosters);
		setuimodelvalue(getuimodel(doa.ui_model, "score"), "" + doa.score);
		setuimodelvalue(getuimodel(doa.ui_model, "multiplier"), doa.multiplier);
		setuimodelvalue(getuimodel(doa.ui_model, "xbar"), doa.var_c4c3767e);
		setuimodelvalue(getuimodel(doa.ui_model, "bulletbar"), doa.var_4d5a5848);
		setuimodelvalue(getuimodel(doa.ui_model, "bulletbar_rgb"), "255 208 0");
		setuimodelvalue(getuimodel(doa.ui_model, "ribbon"), 0);
		setuimodelvalue(getuimodel(doa.ui_model, "gpr_rgb"), "0 255 0");
		setuimodelvalue(getuimodel(doa.ui_model, "generic_txt"), "");
		setuimodelvalue(getuimodel(doa.ui_model, "gpr"), doa.gpr);
		setuimodelvalue(getuimodel(doa.ui_model, "gpr2"), doa.var_4b3052ec);
		setuimodelvalue(getuimodel(doa.ui_model, "weaplevel1"), 0);
		setuimodelvalue(getuimodel(doa.ui_model, "weaplevel2"), 0);
		setuimodelvalue(getuimodel(doa.ui_model, "respawn"), "");
	}
}

/*
	Name: function_cdb6d911
	Namespace: namespace_64c6b720
	Checksum: 0x328408C6
	Offset: 0x16A8
	Size: 0x1EE
	Parameters: 0
	Flags: Linked
*/
function function_cdb6d911()
{
	self notify(#"hash_cdb6d911");
	self endon(#"hash_cdb6d911");
	while(true)
	{
		foreach(var_40ce22db, model in level.var_b9d30140)
		{
			setuimodelvalue(getuimodel(model, "ribbon"), 0);
		}
		var_324ecf57 = level.var_29e6f519[0];
		foreach(var_cae08306, doa in level.var_29e6f519)
		{
			if(doa.score > var_324ecf57.score)
			{
				var_324ecf57 = doa;
			}
		}
		if(getplayers(0).size > 1 && isdefined(var_324ecf57))
		{
			setuimodelvalue(getuimodel(var_324ecf57.ui_model, "ribbon"), 1);
		}
		wait(1);
	}
}

/*
	Name: function_4d819138
	Namespace: namespace_64c6b720
	Checksum: 0x11C2E5B8
	Offset: 0x18A0
	Size: 0x288
	Parameters: 0
	Flags: Linked
*/
function function_4d819138()
{
	self notify(#"hash_4d819138");
	self endon(#"hash_4d819138");
	while(true)
	{
		foreach(var_8cc4e06f, doa in level.var_29e6f519)
		{
			if(!isdefined(doa.player))
			{
				continue;
			}
			var_9c4a2a35 = doa.player.score + doa.var_db3637c0 * int(4000000);
			delta = var_9c4a2a35 - doa.score;
			if(delta > 0)
			{
				inc = 1;
				frac = int(0.01 * delta);
				units = int(frac / inc);
				inc = inc + units * inc;
				doa.score = doa.score + inc;
				if(doa.score > var_9c4a2a35)
				{
					doa.score = var_9c4a2a35;
				}
			}
			else if(delta < 0)
			{
				doa.score = 0;
			}
			score = doa.score * 25;
			setuimodelvalue(getuimodel(doa.ui_model, "score"), "" + score);
		}
		wait(0.016);
	}
}

/*
	Name: function_2c9a6a47
	Namespace: namespace_64c6b720
	Checksum: 0x68482663
	Offset: 0x1B30
	Size: 0xA6E
	Parameters: 0
	Flags: Linked
*/
function function_2c9a6a47()
{
	self notify(#"hash_2c9a6a47");
	self endon(#"hash_2c9a6a47");
	while(true)
	{
		wait(0.016);
		foreach(var_32495fea, doa in level.var_29e6f519)
		{
			setuimodelvalue(getuimodel(doa.ui_model, "respawn"), "");
			if(isdefined(level.var_c8a4d758) && level.var_c8a4d758)
			{
				setuimodelvalue(getuimodel(doa.ui_model, "name"), "");
				setuimodelvalue(getuimodel(doa.ui_model, "weaplevel1"), 0);
				setuimodelvalue(getuimodel(doa.ui_model, "weaplevel2"), 0);
			}
			else
			{
				name = "";
				if(isdefined(doa.player) && isdefined(doa.player.name))
				{
					name = doa.player.name;
				}
				setuimodelvalue(getuimodel(doa.ui_model, "name"), name);
				if(isdefined(doa.var_c86225b5) && doa.var_c86225b5)
				{
					setuimodelvalue(createuimodel(doa.ui_model, "name"), istring("DOA_RESPAWNING"));
					val = "" + int(ceil(doa.var_c4c3767e * 60));
					setuimodelvalue(getuimodel(doa.ui_model, "respawn"), val);
				}
			}
			if(isdefined(doa.player))
			{
				doa.lives = doa.player.headshots & 61440 >> 12;
				doa.bombs = doa.player.headshots & 3840 >> 8;
				doa.boosters = doa.player.headshots & 240 >> 4;
				doa.multiplier = doa.player.headshots & 15;
				doa.var_c4c3767e = doa.player.downs >> 2 / 255;
				doa.var_4d5a5848 = doa.player.revives >> 2 / 255;
				doa.var_4f0e30c = doa.player.downs & 3;
				doa.var_c86225b5 = doa.player.assists & 1;
				doa.var_db3637c0 = doa.player.assists >> 2;
				doa.var_c88a6593 = doa.player.revives & 3;
				if(!isdefined(doa.player.var_8064cb04) || doa.player.var_8064cb04 != doa.var_c88a6593)
				{
					level notify(#"hash_aae01d5a", doa.player.entnum, doa.var_c88a6593);
				}
			}
			setuimodelvalue(getuimodel(doa.ui_model, "bombs"), doa.bombs);
			setuimodelvalue(getuimodel(doa.ui_model, "boosts"), doa.boosters);
			setuimodelvalue(getuimodel(doa.ui_model, "lives"), doa.lives);
			setuimodelvalue(getuimodel(doa.ui_model, "multiplier"), doa.multiplier);
			setuimodelvalue(getuimodel(doa.ui_model, "xbar"), doa.var_c4c3767e);
			setuimodelvalue(getuimodel(doa.ui_model, "bulletbar"), doa.var_4d5a5848);
			setuimodelvalue(getuimodel(doa.ui_model, "weaplevel1"), 0);
			setuimodelvalue(getuimodel(doa.ui_model, "weaplevel2"), 0);
			if(!(isdefined(level.var_c8a4d758) && level.var_c8a4d758))
			{
				switch(doa.var_4f0e30c)
				{
					case 0:
					{
						setuimodelvalue(getuimodel(doa.ui_model, "weaplevel1"), 0);
						setuimodelvalue(getuimodel(doa.ui_model, "weaplevel2"), 0);
						setuimodelvalue(getuimodel(doa.ui_model, "bulletbar_rgb"), "255 208 0");
						break;
					}
					case 1:
					{
						setuimodelvalue(getuimodel(doa.ui_model, "weaplevel1"), 1);
						setuimodelvalue(getuimodel(doa.ui_model, "weaplevel2"), 0);
						setuimodelvalue(getuimodel(doa.ui_model, "bulletbar_rgb"), "255 0 0");
						break;
					}
					case 2:
					{
						setuimodelvalue(getuimodel(doa.ui_model, "weaplevel1"), 1);
						setuimodelvalue(getuimodel(doa.ui_model, "weaplevel2"), 1);
						setuimodelvalue(getuimodel(doa.ui_model, "bulletbar_rgb"), "128 0 255");
						break;
					}
				}
			}
			setuimodelvalue(getuimodel(doa.ui_model, "gpr"), doa.gpr);
			setuimodelvalue(getuimodel(doa.ui_model, "gpr2"), doa.var_4b3052ec);
		}
	}
}

/*
	Name: on_shutdown
	Namespace: namespace_64c6b720
	Checksum: 0xAE7C7E1
	Offset: 0x25A8
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function on_shutdown(localclientnum, ent)
{
	if(isdefined(ent) && self === ent)
	{
		/#
			namespace_693feb87::debugmsg("" + (isdefined(self.name) ? self.name : self getentitynumber()));
		#/
		if(isdefined(self.doa))
		{
			function_e06716c7(self.doa);
		}
	}
}

/*
	Name: on_player_spawn
	Namespace: namespace_64c6b720
	Checksum: 0x801C95EE
	Offset: 0x2650
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function on_player_spawn(localclientnum)
{
	self callback::on_shutdown(&on_shutdown, self);
}

/*
	Name: function_7fe5e3f4
	Namespace: namespace_64c6b720
	Checksum: 0x82EEDF2C
	Offset: 0x2688
	Size: 0x48
	Parameters: 7
	Flags: Linked
*/
function function_7fe5e3f4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level.var_c8a4d758 = newval;
}

/*
	Name: function_e0f15ca4
	Namespace: namespace_64c6b720
	Checksum: 0xA3B1FA89
	Offset: 0x26D8
	Size: 0x134
	Parameters: 7
	Flags: Linked
*/
function function_e0f15ca4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	diff = newval - oldval;
	if(diff)
	{
		level notify(#"hash_48152b36", fieldname, diff);
	}
	idx = int(fieldname[fieldname.size - 1]);
	/#
		assert(idx >= 0 && idx < level.gpr.size);
	#/
	level.gpr[idx] = newval;
	field = "gpr" + idx;
	setuimodelvalue(createuimodel(level.var_7e2a814c, field), newval);
}

/*
	Name: function_2db8b053
	Namespace: namespace_64c6b720
	Checksum: 0x7436D51
	Offset: 0x2818
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_2db8b053(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playernum = int(fieldname[fieldname.size - 1]);
	level.var_29e6f519[playernum].gpr = newval;
}

/*
	Name: function_b9397b2b
	Namespace: namespace_64c6b720
	Checksum: 0x809A7227
	Offset: 0x28B0
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_b9397b2b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playernum = int(fieldname[fieldname.size - 1]);
	level.var_29e6f519[playernum].var_4b3052ec = newval;
}

/*
	Name: function_6ccafee6
	Namespace: namespace_64c6b720
	Checksum: 0xF012797E
	Offset: 0x2948
	Size: 0x3C
	Parameters: 7
	Flags: None
*/
function function_6ccafee6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
}

/*
	Name: function_75319a37
	Namespace: namespace_64c6b720
	Checksum: 0x2AC96C0B
	Offset: 0x2990
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_75319a37(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		return;
	}
	if(isdefined(level.var_b1ce5a88) && level.var_b1ce5a88)
	{
		return;
	}
	level thread function_56dd76b(newval);
}

/*
	Name: function_a08fe7c3
	Namespace: namespace_64c6b720
	Checksum: 0xA0414CE1
	Offset: 0x2A18
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function function_a08fe7c3(totaltime)
{
	totaltime = totaltime * 1000;
	curtime = gettime();
	endtime = curtime + totaltime;
	while(curtime < endtime)
	{
		curtime = gettime();
		diff = endtime - curtime;
		ratio = diff / totaltime;
		r = 255 * ratio;
		g = 255 * 1 - ratio;
		rgb = r + " " + g + " 0";
		setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb1"), rgb);
		wait(0.016);
	}
}

/*
	Name: function_56dd76b
	Namespace: namespace_64c6b720
	Checksum: 0xB31B4EEB
	Offset: 0x2B50
	Size: 0x1E0
	Parameters: 1
	Flags: Linked
*/
function function_56dd76b(val)
{
	level.var_b1ce5a88 = 1;
	startval = val;
	level thread function_a08fe7c3(startval * 1.1);
	while(val > 0)
	{
		setuimodelvalue(getuimodel(level.var_7e2a814c, "countdown"), "" + val);
		playsound(0, "evt_countdown", (0, 0, 0));
		wait(1.05);
		setuimodelvalue(getuimodel(level.var_7e2a814c, "countdown"), "");
		wait(0.016);
		val = val - 1;
		level notify(#"countdown", val);
	}
	level notify(#"countdown", 0);
	setuimodelvalue(getuimodel(level.var_7e2a814c, "countdown"), &"CP_DOA_BO3_GO");
	playsound(0, "evt_countdown_go", (0, 0, 0));
	wait(1.1);
	setuimodelvalue(getuimodel(level.var_7e2a814c, "countdown"), "");
	level.var_b1ce5a88 = 0;
}

/*
	Name: function_ecca2450
	Namespace: namespace_64c6b720
	Checksum: 0x9B1ECB2C
	Offset: 0x2D38
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function function_ecca2450(text)
{
	setuimodelvalue(getuimodel(level.var_7e2a814c, "countdown"), text);
}

