// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\cp\cp_doa_bo3_fx;
#using scripts\cp\cp_doa_bo3_sound;
#using scripts\cp\doa\_doa_core;
#using scripts\cp\doa\_doa_score;
#using scripts\cp\gametypes\coop;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_quadtank;

#using_animtree("critter");
#using_animtree("chicken_mech");

#namespace namespace_bb5d050c;

/*
	Name: main
	Namespace: namespace_bb5d050c
	Checksum: 0x30EFFFB5
	Offset: 0x620
	Size: 0x29C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	setdvar("doa_redins_rally", 0);
	level.var_2eda2d85 = &function_62423327;
	level.var_1f314fb9 = &function_4eb73a5;
	namespace_e8effba5::main();
	namespace_4fca3ee8::main();
	setdvar("bg_friendlyFireMode", 0);
	clientfield::register("world", "redinsExploder", 1, 2, "int", &function_1dd0a889, 0, 0);
	clientfield::register("world", "activateBanner", 1, 3, "int", &function_99e9c8d, 0, 0);
	clientfield::register("world", "pumpBannerBar", 1, 8, "float", &function_98982de8, 0, 0);
	clientfield::register("world", "redinstutorial", 1, 1, "int", &function_c7163a08, 0, 0);
	clientfield::register("world", "redinsinstruct", 1, 12, "int", &function_9cbb849c, 0, 0);
	clientfield::register("scriptmover", "runcowanim", 1, 1, "int", &function_caf96f2d, 0, 0);
	clientfield::register("scriptmover", "runsiegechickenanim", 8000, 2, "int", &function_f9064aec, 0, 0);
	namespace_693feb87::main();
	load::main();
}

/*
	Name: function_4eb73a5
	Namespace: namespace_bb5d050c
	Checksum: 0x37DA1161
	Offset: 0x8C8
	Size: 0x616
	Parameters: 3
	Flags: Linked
*/
function function_4eb73a5(localclientnum, mapname, var_5fb1dd3e)
{
	if(isdefined(level.weatherfx) && isdefined(level.weatherfx[localclientnum]))
	{
		stopfx(localclientnum, level.weatherfx[localclientnum]);
		level.weatherfx[localclientnum] = 0;
	}
	switch(mapname)
	{
		case "island":
		{
			break;
		}
		case "dock":
		{
			if(var_5fb1dd3e == "night")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_rainfall_" + randomintrange(1, 4)], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
		case "farm":
		{
			if(var_5fb1dd3e == "dusk" || var_5fb1dd3e == "night")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_snowfall_1"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
		case "graveyard":
		{
			if(var_5fb1dd3e == "noon")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_snowfall_1"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			else if(var_5fb1dd3e == "night")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_rainfall_" + randomintrange(1, 4)], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
		case "temple":
		{
			if(var_5fb1dd3e == "night")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_rainfall_" + randomintrange(1, 4)], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
		case "safehouse":
		{
			break;
		}
		case "blood":
		{
			if(var_5fb1dd3e != "dusk")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_snowfall_1"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
		case "cave":
		{
			break;
		}
		case "vengeance":
		{
			if(var_5fb1dd3e == "night")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_rainfall_" + randomintrange(1, 4)], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
		case "sgen":
		{
			break;
		}
		case "apartments":
		{
			if(var_5fb1dd3e == "night")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_rainfall_" + randomintrange(1, 4)], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
		case "sector":
		{
			break;
		}
		case "metro":
		{
			if(var_5fb1dd3e == "night")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_snowfall_1"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
		case "clearing":
		{
			if(var_5fb1dd3e != "night")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_snowfall_1"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
		case "newworld":
		{
			if(var_5fb1dd3e == "dusk" || var_5fb1dd3e == "night")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_snowfall_1"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
		case "boss":
		{
			if(var_5fb1dd3e == "night")
			{
				level.weatherfx[localclientnum] = playfxoncamera(localclientnum, level._effect["ambient_rainfall_" + randomintrange(1, 4)], (0, 0, 0), (1, 0, 0), (0, 0, 1));
			}
			break;
		}
	}
}

/*
	Name: function_62423327
	Namespace: namespace_bb5d050c
	Checksum: 0x8F58643F
	Offset: 0xEE8
	Size: 0x252
	Parameters: 1
	Flags: Linked
*/
function function_62423327(arena)
{
	switch(arena.name)
	{
		case "redins":
		{
			arena.var_f3114f93 = &function_787f2b69;
			arena.var_aad78940 = 99;
			arena.var_f4f1abf3 = 1;
			arena.var_dd94482c = (1 + 8) + 4;
			arena.var_ecf7ec70 = 0;
			break;
		}
		case "tankmaze":
		{
			arena.var_f3114f93 = &function_52612667;
			arena.var_aad78940 = 99;
			arena.var_dd94482c = 1 + 4;
			arena.var_ecf7ec70 = 2;
			break;
		}
		case "spiral":
		{
			arena.var_aad78940 = 2;
			arena.var_dd94482c = 1;
			arena.var_ecf7ec70 = 0;
			break;
		}
		case "truck_soccer":
		{
			arena.var_f3114f93 = &function_b5e8546d;
			arena.var_aad78940 = 99;
			arena.var_dd94482c = (1 + 8) + 4;
			arena.var_ecf7ec70 = 2;
			break;
		}
		case "alien_armory":
		case "armory":
		case "bomb_storage":
		case "coop":
		case "hangar":
		case "vault":
		case "wolfhole":
		{
			arena.var_dd94482c = 4;
			arena.var_ecf7ec70 = 2;
			break;
		}
		case "apartments":
		{
			arena.var_bfa5d6ae = 1;
			break;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: function_98982de8
	Namespace: namespace_bb5d050c
	Checksum: 0xF010A2CC
	Offset: 0x1148
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function function_98982de8(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(getuimodel(level.var_7e2a814c, "gpr0"), newval);
}

/*
	Name: function_99e9c8d
	Namespace: namespace_bb5d050c
	Checksum: 0xF77E8105
	Offset: 0x11C8
	Size: 0x7EE
	Parameters: 7
	Flags: Linked
*/
function function_99e9c8d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gbanner"), "");
	switch(newval)
	{
		case 6:
		{
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gbanner"), &"CP_DOA_BO3_BOSS_CYBERSILVERBACK_MECH");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gpr0"), 1);
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb1"), "255 0 0");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb2"), "255 128 0");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb3"), "255 0 32");
			break;
		}
		case 5:
		{
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gbanner"), &"CP_DOA_BO3_BOSS_CYBERSILVERBACK");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gpr0"), 1);
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb1"), "255 0 0");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb2"), "255 128 0");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb3"), "255 0 32");
			break;
		}
		case 4:
		{
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gbanner"), &"CP_DOA_BO3_BOSS_MARGWA");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gpr0"), 1);
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb1"), "255 0 0");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb2"), "255 128 0");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb3"), "255 0 32");
			break;
		}
		case 1:
		{
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gbanner"), &"CP_DOA_BO3_BOSS_STONEGUARDIAN");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gpr0"), 1);
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb1"), "255 0 0");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb2"), "255 128 0");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb3"), "255 0 32");
			break;
		}
		case 2:
		{
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gbanner"), &"CP_DOA_BO3_BANNER_CHICKENBOWL");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gpr0"), 1);
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb1"), "128 128 128");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb2"), "255 255 255");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb3"), "128 128 128");
			break;
		}
		case 3:
		{
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gbanner"), &"CP_DOA_BO3_BANNER_TANKMAZE");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gpr0"), 1);
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb1"), "16 16 16");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb2"), "31 10 255");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "grgb3"), "255 255 0");
			break;
		}
		default:
		{
			setuimodelvalue(createuimodel(level.var_7e2a814c, "gbanner"), "");
			setuimodelvalue(getuimodel(level.var_7e2a814c, "gpr0"), 0);
			break;
		}
	}
}

/*
	Name: function_b5e8546d
	Namespace: namespace_bb5d050c
	Checksum: 0xAC1D1A5
	Offset: 0x19C0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_b5e8546d(localclientnum)
{
	level.var_81528e19 = 2;
	setuimodelvalue(createuimodel(level.var_7e2a814c, "driving"), 1);
	level thread function_caffcc1d(localclientnum);
}

/*
	Name: function_caffcc1d
	Namespace: namespace_bb5d050c
	Checksum: 0xC95040B3
	Offset: 0x1A30
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_caffcc1d(localclientnum)
{
	level waittill(#"hash_ec7ca67b");
	level.var_81528e19 = undefined;
	setuimodelvalue(createuimodel(level.var_7e2a814c, "driving"), 0);
}

/*
	Name: function_c8020bd9
	Namespace: namespace_bb5d050c
	Checksum: 0xF0EFE55C
	Offset: 0x1A90
	Size: 0x294
	Parameters: 1
	Flags: Linked
*/
function function_c8020bd9(localclientnum)
{
	level waittill(#"hash_ec7ca67b");
	level.var_81528e19 = undefined;
	setuimodelvalue(createuimodel(level.var_7e2a814c, "redins"), "");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gtxt0"), "");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gpr0"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gpr1"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gpr2"), 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gpr3"), 0);
	foreach(player in getplayers(localclientnum))
	{
		setuimodelvalue(getuimodel(level.var_b9d30140[player getentitynumber()], "generic_txt"), "");
	}
	setdvar("doa_redins_rally", 0);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "driving"), 0);
}

/*
	Name: function_7183a31d
	Namespace: namespace_bb5d050c
	Checksum: 0x6F9026B6
	Offset: 0x1D30
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function function_7183a31d(fieldname, diff)
{
	level notify(#"hash_7183a31d");
	level endon(#"hash_7183a31d");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gtxt0"), ("+") + diff);
	wait(2);
	setuimodelvalue(createuimodel(level.var_7e2a814c, "gtxt0"), "");
}

/*
	Name: function_ec984567
	Namespace: namespace_bb5d050c
	Checksum: 0x8D746E19
	Offset: 0x1DE8
	Size: 0x68
	Parameters: 0
	Flags: Linked
*/
function function_ec984567()
{
	level endon(#"hash_ec7ca67b");
	while(true)
	{
		level waittill(#"hash_48152b36", fieldname, diff);
		if(diff > 0)
		{
			level thread function_7183a31d(fieldname, diff);
		}
	}
}

/*
	Name: function_1dd0a889
	Namespace: namespace_bb5d050c
	Checksum: 0x338D40BD
	Offset: 0x1E58
	Size: 0xD6
	Parameters: 7
	Flags: Linked
*/
function function_1dd0a889(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 0:
		{
			exploder::kill_exploder("fx_exploder_rally_ramp_fireworks");
			exploder::kill_exploder("fx_exploder_rally_winner_fireworks");
			break;
		}
		case 1:
		{
			exploder::exploder("fx_exploder_rally_ramp_fireworks");
			break;
		}
		case 2:
		{
			exploder::exploder("fx_exploder_rally_winner_fireworks");
			break;
		}
	}
}

/*
	Name: function_9cbb849c
	Namespace: namespace_bb5d050c
	Checksum: 0x75B9F59E
	Offset: 0x1F38
	Size: 0x114
	Parameters: 7
	Flags: Linked
*/
function function_9cbb849c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		var_a923fad3 = newval & 15;
		seconds = newval >> 4;
		text = sprintf(&"CP_DOA_BO3_REDINS_INSTRUCTION", var_a923fad3, seconds);
		setuimodelvalue(createuimodel(level.var_7e2a814c, "instruct"), text);
	}
	else
	{
		setuimodelvalue(createuimodel(level.var_7e2a814c, "instruct"), "");
	}
}

/*
	Name: function_c7163a08
	Namespace: namespace_bb5d050c
	Checksum: 0x70DAEACF
	Offset: 0x2058
	Size: 0x19E
	Parameters: 7
	Flags: Linked
*/
function function_c7163a08(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1 && (!(isdefined(level.var_f64ff200) && level.var_f64ff200)))
	{
		if(!isdefined(level.var_8c2ba713))
		{
			level.var_8c2ba713 = createluimenu(localclientnum, "DOA_ControlsMenu");
		}
		if(isdefined(level.var_8c2ba713))
		{
			openluimenu(localclientnum, level.var_8c2ba713);
			level.var_f64ff200 = 1;
			string = "CP_DOA_BO3_REDINS_HINT" + randomint(8);
			setuimodelvalue(createuimodel(level.var_7e2a814c, "hint"), istring(string));
			while(true)
			{
				level waittill(#"countdown", val);
				if(val <= 1)
				{
					break;
				}
			}
			closeluimenu(localclientnum, level.var_8c2ba713);
			level.var_8c2ba713 = undefined;
			level.var_f64ff200 = undefined;
		}
	}
}

/*
	Name: function_96abee17
	Namespace: namespace_bb5d050c
	Checksum: 0x40BB40BA
	Offset: 0x2200
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function function_96abee17(localclientnum)
{
	level waittill(#"hash_ec7ca67b");
	level.var_81528e19 = undefined;
}

/*
	Name: function_52612667
	Namespace: namespace_bb5d050c
	Checksum: 0x105D0475
	Offset: 0x2230
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function function_52612667(localclientnum)
{
	level endon(#"hash_ec7ca67b");
	if(isdefined(level.weatherfx) && isdefined(level.weatherfx[localclientnum]))
	{
		stopfx(localclientnum, level.weatherfx[localclientnum]);
		level.weatherfx[localclientnum] = 0;
	}
	level.var_81528e19 = 2;
	level thread function_96abee17(localclientnum);
}

/*
	Name: function_787f2b69
	Namespace: namespace_bb5d050c
	Checksum: 0xB426FE52
	Offset: 0x22D0
	Size: 0x420
	Parameters: 1
	Flags: Linked
*/
function function_787f2b69(localclientnum)
{
	level endon(#"hash_ec7ca67b");
	if(isdefined(level.weatherfx) && isdefined(level.weatherfx[localclientnum]))
	{
		stopfx(localclientnum, level.weatherfx[localclientnum]);
		level.weatherfx[localclientnum] = 0;
	}
	level.var_81528e19 = 2;
	level thread function_c8020bd9(localclientnum);
	setuimodelvalue(getuimodel(level.var_7e2a814c, "redins"), "1");
	setuimodelvalue(createuimodel(level.var_7e2a814c, "driving"), 1);
	setdvar("doa_redins_rally", 1);
	level thread function_ec984567();
	while(true)
	{
		for(i = 0; i < 4; i++)
		{
			setuimodelvalue(getuimodel(level.var_b9d30140[i], "name"), "");
			setuimodelvalue(getuimodel(level.var_b9d30140[i], "generic_txt"), "");
		}
		foreach(player in getplayers(localclientnum))
		{
			setuimodelvalue(getuimodel(level.var_b9d30140[player getentitynumber()], "name"), "");
			setuimodelvalue(getuimodel(level.var_b9d30140[player getentitynumber()], "generic_txt"), (isdefined(player.name) ? player.name : ""));
			switch(player getentitynumber())
			{
				case 0:
				{
					rgb = "0 255 0";
					break;
				}
				case 1:
				{
					rgb = "0 0 255";
					break;
				}
				case 2:
				{
					rgb = "255 0 0";
					break;
				}
				case 3:
				{
					rgb = "255 255 0";
					break;
				}
			}
			setuimodelvalue(getuimodel(level.var_b9d30140[player getentitynumber()], "gpr_rgb"), rgb);
		}
		wait(0.1);
	}
}

/*
	Name: function_a8eb710
	Namespace: namespace_bb5d050c
	Checksum: 0xBD477641
	Offset: 0x26F8
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_a8eb710()
{
	self endon(#"entityshutdown");
	self useanimtree($critter);
	self.animation = (randomint(2) ? %critter::a_water_buffalo_run_a : %critter::a_water_buffalo_run_b);
	self setanim(self.animation, 1, 0, 1);
}

/*
	Name: function_caf96f2d
	Namespace: namespace_bb5d050c
	Checksum: 0x4FA3529E
	Offset: 0x27A8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_caf96f2d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self thread function_a8eb710();
	}
}

/*
	Name: function_27542390
	Namespace: namespace_bb5d050c
	Checksum: 0xCB822D64
	Offset: 0x2810
	Size: 0x1C8
	Parameters: 2
	Flags: Linked
*/
function function_27542390(localclientnum, state)
{
	self endon(#"entityshutdown");
	self notify(#"animstate");
	self endon(#"animstate");
	self.animstate = state;
	self useanimtree($chicken_mech);
	while(true)
	{
		switch(self.animstate)
		{
			case 0:
			{
				if(isdefined(self.animation))
				{
					self clearanim(self.animation, 0);
					self.animation = undefined;
				}
				break;
			}
			case 1:
			{
				self.animation = %chicken_mech::a_chicken_mech_idle;
				self setanim(self.animation, 1, 0.2, 1);
				break;
			}
			case 2:
			{
				self.animation = %chicken_mech::a_chicken_mech_lay_egg;
				self setanimrestart(self.animation, 1, 0.2, 1);
				break;
			}
			case 3:
			{
				break;
			}
		}
		if(isdefined(self.animation))
		{
			time = getanimlength(self.animation);
			wait(time);
		}
		else
		{
			return;
		}
	}
}

/*
	Name: function_f9064aec
	Namespace: namespace_bb5d050c
	Checksum: 0xF0BE704A
	Offset: 0x29E0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_f9064aec(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread function_27542390(localclientnum, newval);
}

