// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\mp\_teamops;
#using scripts\mp\_util;
#using scripts\mp\gametypes\_dogtags;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_spawn;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_prop_controls;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\gametypes\prop;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\bots\_bot;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#namespace namespace_baba9b52;

/*
	Name: function_6edad947
	Namespace: namespace_baba9b52
	Checksum: 0x10EE84F4
	Offset: 0x340
	Size: 0x9C
	Parameters: 2
	Flags: None
*/
function function_6edad947(path, var_66e49a4e)
{
	/#
		var_13265 = ("" + path) + "";
		var_fe387e48 = ("" + var_66e49a4e) + "";
		var_282f0c8d = (("" + var_13265) + "") + var_fe387e48;
		adddebugcommand(var_282f0c8d);
	#/
}

/*
	Name: function_6c015e54
	Namespace: namespace_baba9b52
	Checksum: 0xAAFD4EBC
	Offset: 0x3E8
	Size: 0x1720
	Parameters: 0
	Flags: None
*/
function function_6c015e54()
{
	/#
		var_b58392ae = 0;
		var_8b6a1374 = 0;
		var_ccd61088 = 0;
		var_6c9fc047 = 0;
		var_f0760dd5 = 0;
		var_8c45c976 = 0;
		var_fe10d650 = 0;
		var_74fced3d = 0;
		minigame_on = getdvarint("", 1);
		var_5f965ece = getdvarint("", 1);
		var_100dc1ab = getdvarfloat("");
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 1);
		util::set_dvar_int_if_unset("", 1);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		util::set_dvar_int_if_unset("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", 0);
		if(getdvarint("", 0) != 0)
		{
			adddebugcommand("");
		}
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", ("" + 4) + "");
		function_6edad947("", ("" + 0.25) + "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		function_6edad947("", "");
		while(true)
		{
			if(isdefined(level.prematch_over) && level.prematch_over)
			{
				level.allow_teamchange = "" + getdvarint("", 0);
				level.var_2898ef72 = getdvarint("", 0) != 0;
			}
			if(getdvarint("", 0) != var_5f965ece && isdefined(level.players))
			{
				var_5f965ece = getdvarint("", 0);
				if(!isdefined(level.players[0].changepropkey))
				{
					iprintlnbold("");
				}
				else
				{
					foreach(player in level.players)
					{
						if(isdefined(player.team) && player util::isprop())
						{
							player namespace_4c773ed3::propabilitykeysvisible(var_5f965ece, 1);
						}
					}
					level.elim_hud.alpha = var_5f965ece;
				}
			}
			if(getdvarint("", 0) != var_ccd61088 && isdefined(level.players))
			{
				foreach(player in level.players)
				{
					if(player util::isprop())
					{
						var_ccd61088 = getdvarint("", 0);
						player.var_c4494f8d = !(isdefined(player.var_c4494f8d) && player.var_c4494f8d);
						player iprintlnbold((player.var_c4494f8d ? "" : ""));
					}
				}
			}
			if(getdvarint("", 0) != var_6c9fc047 && isdefined(level.players))
			{
				foreach(player in level.players)
				{
					if(player util::isprop())
					{
						var_6c9fc047 = getdvarint("", 0);
						player.var_b53602f4 = !(isdefined(player.var_b53602f4) && player.var_b53602f4);
						player iprintlnbold((player.var_b53602f4 ? "" : ""));
					}
				}
			}
			if(getdvarint("", 0) != var_f0760dd5 && isdefined(level.players))
			{
				foreach(player in level.players)
				{
					if(player util::isprop())
					{
						var_f0760dd5 = getdvarint("", 0);
						player.var_2f1101f4 = !(isdefined(player.var_2f1101f4) && player.var_2f1101f4);
						player iprintlnbold((player.var_2f1101f4 ? "" : ""));
					}
				}
			}
			if(getdvarint("", 0) != var_8c45c976)
			{
				var_8c45c976 = getdvarint("", 0);
				if(var_8c45c976)
				{
					setdvar("", 1);
					setdvar("", 1);
					setdvar("", 10000);
				}
				else
				{
					setdvar("", 1600);
					setdvar("", 1000);
					setdvar("", 400);
					iprintlnbold((var_8c45c976 ? "" : ""));
				}
			}
			if(getdvarint("", 0) != var_fe10d650 && isdefined(level.players))
			{
				foreach(player in level.players)
				{
					if(player prop::function_e4b2f23())
					{
						var_fe10d650 = getdvarint("", 0);
						player.var_74ca9cd1 = !(isdefined(player.var_74ca9cd1) && player.var_74ca9cd1);
						player iprintlnbold((player.var_74ca9cd1 ? "" : ""));
					}
				}
			}
			var_9c4c453 = getdvarint("", 0);
			if(var_9c4c453 != var_b58392ae)
			{
				var_b58392ae = var_9c4c453;
				function_f35dfc64(!var_9c4c453);
			}
			var_504c9134 = getdvarint("", 0);
			if(var_504c9134 != var_8b6a1374)
			{
				var_8b6a1374 = var_504c9134;
				result = function_194631ab(var_504c9134);
				if(!result)
				{
					var_8b6a1374 = !var_504c9134;
				}
				if(var_8b6a1374)
				{
					level.drown_damage = 0;
				}
				else
				{
					level.drown_damage = var_100dc1ab;
				}
			}
			if(getdvarint("", 0) != 0)
			{
				function_543336f9();
				setdvar("", 0);
			}
			if(getdvarint("", 0) != 0)
			{
				function_a8147bf9();
				setdvar("", 0);
			}
			if(getdvarint("", 0) != 0)
			{
				function_1a022b4b();
				setdvar("", 0);
			}
			if(getdvarint("", 0) != 0)
			{
				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					level thread prop::function_435d5169(&"", level.players[0]);
				}
				setdvar("", 0);
			}
			if(getdvarint("", 0) != 0)
			{
				function_276ad638();
			}
			if(getdvarint("", 0))
			{
				function_b02387d6();
			}
			if(getdvarint("", 0) != 0)
			{
				function_ad9aebcc();
				setdvar("", 0);
			}
			if(getdvarint("", 0) != 0)
			{
				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					level.players[0] namespace_4c773ed3::canlock();
				}
			}
			if(getdvarint("", 0) != 0 || getdvarint("", 0) != 0)
			{
				function_36895abd();
			}
			if(getdvarint("", 0) != 0)
			{
				function_6863880e();
				setdvar("", 0);
			}
			if(getdvarint("", 0) != 0)
			{
				function_9b9725b1();
				setdvar("", 0);
			}
			if(getdvarint("", 0) != 0 && isdefined(level.players))
			{
				foreach(player in level.players)
				{
					player notify(#"hash_b83e2d54");
				}
				setdvar("", 0);
			}
			if(getdvarint("", 0) != 0)
			{
				function_b52ad1b2();
			}
			if(getdvarint("", 0) != 0)
			{
				function_5e127ae8();
			}
			if(getdvarint("", 0) != 0)
			{
				function_b9002790();
			}
			if(getdvarint("", 1) != minigame_on && isdefined(level.players) && level.players.size > 0)
			{
				minigame_on = getdvarint("", 1);
				iprintlnbold((minigame_on ? "" : ""));
			}
			if(getdvarint("", 0) != var_74fced3d && isdefined(level.players) && level.players.size > 0)
			{
				var_74fced3d = getdvarint("", 0);
				if(var_74fced3d == 2)
				{
					iprintlnbold("");
				}
				else
				{
					if(var_74fced3d == 1)
					{
						iprintlnbold("");
					}
					else
					{
						iprintlnbold("");
					}
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_f35dfc64
	Namespace: namespace_baba9b52
	Checksum: 0xD6FDB526
	Offset: 0x1B10
	Size: 0xEC
	Parameters: 1
	Flags: None
*/
function function_f35dfc64(enabled)
{
	/#
		setdvar("", enabled);
		setdvar("", enabled);
		setdvar("", enabled);
		setdvar("", enabled);
		setdvar("", enabled);
		setdvar("", enabled);
		setdvar("", enabled);
	#/
}

/*
	Name: function_194631ab
	Namespace: namespace_baba9b52
	Checksum: 0x7BA3ECBF
	Offset: 0x1C08
	Size: 0xE0
	Parameters: 1
	Flags: None
*/
function function_194631ab(enabled)
{
	/#
		if(!isdefined(level.players) || level.players.size == 0)
		{
			return false;
		}
		player = level.players[0];
		if(!isdefined(player) || !isalive(player) || isdefined(player.placementoffset) || !isdefined(player.prop))
		{
			return false;
		}
		if(enabled)
		{
			player function_1b260dda();
		}
		else
		{
			player function_bff3e3c5();
		}
		return true;
	#/
}

/*
	Name: function_e7f343ff
	Namespace: namespace_baba9b52
	Checksum: 0xA3E9F7E5
	Offset: 0x1CF8
	Size: 0x8C
	Parameters: 5
	Flags: None
*/
function function_e7f343ff(color, label, value, text, var_5f790513)
{
	/#
		hudelem = namespace_4c773ed3::addupperrighthudelem(label, value, text, var_5f790513);
		hudelem.alpha = 0.5;
		hudelem.color = color;
		return hudelem;
	#/
}

/*
	Name: function_1b260dda
	Namespace: namespace_baba9b52
	Checksum: 0x21B8F9EF
	Offset: 0x1D90
	Size: 0x4EC
	Parameters: 0
	Flags: None
*/
function function_1b260dda()
{
	/#
		self namespace_4c773ed3::cleanuppropcontrolshud();
		self namespace_4c773ed3::function_3122ae57();
		if(self issplitscreen())
		{
			self.currenthudy = -10;
		}
		else
		{
			self.currenthudy = -80;
		}
		self.var_4efaa35 = function_639754d0(self.prop.info.modelname);
		white = (1, 1, 1);
		red = (1, 0, 0);
		green = (0, 1, 0);
		blue = (0, 0.5, 1);
		self.var_c9f40191 = function_e7f343ff(white, &"", self.prop.info.proprange);
		self.var_40dabe6f = function_e7f343ff(white, &"", self.prop.info.propheight);
		self.var_f1fdc495 = function_e7f343ff(white, &"", self.prop.info.anglesoffset[2]);
		self.var_e7ec6bb6 = function_e7f343ff(white, &"", self.prop.info.anglesoffset[1]);
		self.var_3e02b967 = function_e7f343ff(white, &"", self.prop.info.anglesoffset[0]);
		self.var_381d73f7 = function_e7f343ff(blue, &"", self.prop.info.xyzoffset[2]);
		self.var_c61604bc = function_e7f343ff(green, &"", self.prop.info.xyzoffset[1]);
		self.var_ec187f25 = function_e7f343ff(red, &"", self.prop.info.xyzoffset[0]);
		self.var_f3f7c094 = function_e7f343ff(white, &"", self.prop.info.var_bbac36c8);
		self.var_6b04bc54 = function_e7f343ff(white, &"", self.prop.info.propsize);
		self.var_b97b612d = function_e7f343ff(white, undefined, undefined, "" + self.prop.info.propsizetext);
		self.placementmodel = function_e7f343ff(white, undefined, undefined, (("" + self.var_4efaa35) + "") + self.prop.info.modelname);
		self.var_af6ef079 = array(self.placementmodel, self.var_b97b612d, self.var_6b04bc54, self.var_f3f7c094, self.var_ec187f25, self.var_c61604bc, self.var_381d73f7, self.var_3e02b967, self.var_e7ec6bb6, self.var_f1fdc495, self.var_40dabe6f, self.var_c9f40191);
		self.placementindex = 0;
		self function_9cfa92f3();
		self thread function_d8d922ad();
		self thread function_18a45f58();
		self thread function_8bd2ff0();
	#/
}

/*
	Name: function_bff3e3c5
	Namespace: namespace_baba9b52
	Checksum: 0x43B9E33E
	Offset: 0x2288
	Size: 0x17C
	Parameters: 0
	Flags: None
*/
function function_bff3e3c5()
{
	/#
		self notify(#"hash_bff3e3c5");
		namespace_4c773ed3::safedestroy(self.placementmodel);
		namespace_4c773ed3::safedestroy(self.var_b97b612d);
		namespace_4c773ed3::safedestroy(self.var_6b04bc54);
		namespace_4c773ed3::safedestroy(self.var_f3f7c094);
		namespace_4c773ed3::safedestroy(self.var_ec187f25);
		namespace_4c773ed3::safedestroy(self.var_c61604bc);
		namespace_4c773ed3::safedestroy(self.var_381d73f7);
		namespace_4c773ed3::safedestroy(self.var_3e02b967);
		namespace_4c773ed3::safedestroy(self.var_e7ec6bb6);
		namespace_4c773ed3::safedestroy(self.var_f1fdc495);
		namespace_4c773ed3::safedestroy(self.var_40dabe6f);
		namespace_4c773ed3::safedestroy(self.var_c9f40191);
		self function_4e71de66();
		self namespace_4c773ed3::propcontrolshud();
		self namespace_4c773ed3::setupkeybindings();
	#/
}

/*
	Name: function_8bd2ff0
	Namespace: namespace_baba9b52
	Checksum: 0x5B4E48D4
	Offset: 0x2410
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function function_8bd2ff0()
{
	/#
		self endon(#"game_ended");
		self endon(#"disconnect");
		self endon(#"hash_bff3e3c5");
		self waittill(#"death");
		setdvar("", 0);
	#/
}

/*
	Name: debugaxis
	Namespace: namespace_baba9b52
	Checksum: 0xC28DFE5C
	Offset: 0x2470
	Size: 0x13C
	Parameters: 6
	Flags: None
*/
function debugaxis(origin, angles, size, alpha, depthtest, duration)
{
	/#
		var_d937a872 = anglestoforward(angles) * size;
		var_ff3a22db = anglestoright(angles) * size;
		var_8d32b3a0 = anglestoup(angles) * size;
		line(origin, origin + var_d937a872, (1, 0, 0), alpha, 0, duration);
		line(origin, origin + var_ff3a22db, (0, 1, 0), alpha, 0, duration);
		line(origin, origin + var_8d32b3a0, (0, 0, 1), alpha, 0, duration);
	#/
}

/*
	Name: function_d8d922ad
	Namespace: namespace_baba9b52
	Checksum: 0xA3D2D16E
	Offset: 0x25B8
	Size: 0xB0
	Parameters: 0
	Flags: None
*/
function function_d8d922ad()
{
	/#
		self endon(#"hash_bff3e3c5");
		while(true)
		{
			debugaxis(self.origin, self.angles, 100, 1, 0, 1);
			box(self.origin, self getmins(), self getmaxs(), self.angles[1], (1, 0, 1), 1, 0, 1);
			wait(0.05);
		}
	#/
}

/*
	Name: function_18a45f58
	Namespace: namespace_baba9b52
	Checksum: 0x1970135E
	Offset: 0x2670
	Size: 0x178
	Parameters: 0
	Flags: None
*/
function function_18a45f58()
{
	/#
		self endon(#"hash_bff3e3c5");
		self function_9c8c6fe4(0);
		while(true)
		{
			msg = self util::waittill_any_return("", "", "", "", "");
			if(!isdefined(msg))
			{
				continue;
			}
			if(msg == "")
			{
				self function_6049bca3(-1);
			}
			else
			{
				if(msg == "")
				{
					self function_6049bca3(1);
				}
				else
				{
					if(msg == "")
					{
						self function_a24562f8(1);
					}
					else
					{
						if(msg == "")
						{
							self function_a24562f8(-1);
						}
						else if(msg == "")
						{
							function_c64fb4ca();
						}
					}
				}
			}
		}
	#/
}

/*
	Name: function_6049bca3
	Namespace: namespace_baba9b52
	Checksum: 0x691CBAF6
	Offset: 0x27F0
	Size: 0x68
	Parameters: 1
	Flags: None
*/
function function_6049bca3(val)
{
	/#
		self endon(#"hash_c1452ba");
		function_9c8c6fe4(val);
		wait(0.5);
		while(true)
		{
			function_9c8c6fe4(val);
			wait(0.05);
		}
	#/
}

/*
	Name: function_9c8c6fe4
	Namespace: namespace_baba9b52
	Checksum: 0x51C5A6CE
	Offset: 0x2860
	Size: 0xF4
	Parameters: 1
	Flags: None
*/
function function_9c8c6fe4(val)
{
	/#
		hudelem = self.var_af6ef079[self.placementindex];
		hudelem.alpha = 0.5;
		hudelem.fontscale = 1;
		self.placementindex = self.placementindex + val;
		if(self.placementindex >= self.var_af6ef079.size)
		{
			self.placementindex = 0;
		}
		else if(self.placementindex < 0)
		{
			self.placementindex = self.var_af6ef079.size - 1;
		}
		hudelem = self.var_af6ef079[self.placementindex];
		hudelem.alpha = 1;
		hudelem.fontscale = 1.3;
	#/
}

/*
	Name: function_a24562f8
	Namespace: namespace_baba9b52
	Checksum: 0x979BDB9
	Offset: 0x2960
	Size: 0x68
	Parameters: 1
	Flags: None
*/
function function_a24562f8(val)
{
	/#
		self endon(#"hash_c1452ba");
		function_8bdc662f(val);
		wait(0.5);
		while(true)
		{
			function_8bdc662f(val);
			wait(0.05);
		}
	#/
}

/*
	Name: function_e52aa8bb
	Namespace: namespace_baba9b52
	Checksum: 0x876BB00D
	Offset: 0x29D0
	Size: 0x78
	Parameters: 1
	Flags: None
*/
function function_e52aa8bb(var_6866c6f1)
{
	/#
		var_f1858fdd = self.var_4efaa35 + var_6866c6f1;
		if(var_f1858fdd >= level.propindex.size)
		{
			var_f1858fdd = 0;
		}
		else if(var_f1858fdd < 0)
		{
			var_f1858fdd = level.propindex.size - 1;
		}
		self.var_4efaa35 = var_f1858fdd;
	#/
}

/*
	Name: function_639754d0
	Namespace: namespace_baba9b52
	Checksum: 0x83DF7DEE
	Offset: 0x2A50
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function function_639754d0(var_95f39eee)
{
	/#
		for(index = 0; index < level.propindex.size; index++)
		{
			if(level.proplist[level.propindex[index][0]][level.propindex[index][1]].modelname == var_95f39eee)
			{
				return index;
			}
		}
	#/
}

/*
	Name: function_8bdc662f
	Namespace: namespace_baba9b52
	Checksum: 0xB3F2FFAD
	Offset: 0x2AE0
	Size: 0xF5C
	Parameters: 1
	Flags: None
*/
function function_8bdc662f(val)
{
	/#
		hudelem = self.var_af6ef079[self.placementindex];
		if(hudelem == self.placementmodel)
		{
			function_e52aa8bb(val);
			self.prop.info = level.proplist[level.propindex[self.var_4efaa35][0]][level.propindex[self.var_4efaa35][1]];
			namespace_4c773ed3::propchangeto(self.prop.info);
			self.placementmodel settext((("" + self.var_4efaa35) + "") + self.prop.info.modelname);
			self.var_b97b612d settext("" + self.prop.info.propsizetext);
			self.var_6b04bc54 setvalue(self.prop.info.propsize);
			self.var_f3f7c094 setvalue(self.prop.info.var_bbac36c8);
			self.var_ec187f25 setvalue(self.prop.info.xyzoffset[0]);
			self.var_c61604bc setvalue(self.prop.info.xyzoffset[1]);
			self.var_381d73f7 setvalue(self.prop.info.xyzoffset[2]);
			self.var_3e02b967 setvalue(self.prop.info.anglesoffset[0]);
			self.var_e7ec6bb6 setvalue(self.prop.info.anglesoffset[1]);
			self.var_f1fdc495 setvalue(self.prop.info.anglesoffset[2]);
			self.var_40dabe6f setvalue(self.prop.info.propheight);
			self.var_c9f40191 setvalue(self.prop.info.proprange);
		}
		else
		{
			if(hudelem == self.var_b97b612d || hudelem == self.var_6b04bc54)
			{
				sizes = array("", "", "", "", "", "");
				index = 0;
				for(i = 0; i < sizes.size; i++)
				{
					if(sizes[i] == self.prop.info.propsizetext)
					{
						index = i;
						break;
					}
				}
				index = index + val;
				if(index < 0)
				{
					index = sizes.size - 1;
				}
				else if(index >= sizes.size)
				{
					index = 0;
				}
				self.prop.info.propsizetext = sizes[index];
				self.prop.info.propsize = prop::getpropsize(self.prop.info.propsizetext);
				self.var_b97b612d settext("" + self.prop.info.propsizetext);
				self.var_6b04bc54 setvalue(self.prop.info.propsize);
				self.health = self.prop.info.propsize;
				self.maxhealth = self.health;
			}
			else
			{
				if(hudelem == self.var_f3f7c094)
				{
					var_759a3fa8 = 0.1;
					var_c5fe12fe = 10;
					var_edcea860 = 0.01;
					self.prop.info.var_bbac36c8 = self.prop.info.var_bbac36c8 + (var_edcea860 * val);
					self.prop.info.var_bbac36c8 = math::clamp(self.prop.info.var_bbac36c8, var_759a3fa8, var_c5fe12fe);
					self.prop setscale(self.prop.info.var_bbac36c8, 1);
					self.var_f3f7c094 setvalue(self.prop.info.var_bbac36c8);
				}
				else
				{
					if(hudelem == self.var_ec187f25)
					{
						self.prop unlink();
						self.prop.info.xyzoffset = (self.prop.info.xyzoffset[0] + val, self.prop.info.xyzoffset[1], self.prop.info.xyzoffset[2]);
						self.prop.xyzoffset = self.prop.info.xyzoffset;
						self.var_ec187f25 setvalue(self.prop.info.xyzoffset[0]);
						function_4ef69a48();
					}
					else
					{
						if(hudelem == self.var_c61604bc)
						{
							self.prop unlink();
							self.prop.info.xyzoffset = (self.prop.info.xyzoffset[0], self.prop.info.xyzoffset[1] + val, self.prop.info.xyzoffset[2]);
							self.prop.xyzoffset = self.prop.info.xyzoffset;
							self.var_c61604bc setvalue(self.prop.info.xyzoffset[1]);
							function_4ef69a48();
						}
						else
						{
							if(hudelem == self.var_381d73f7)
							{
								self.prop unlink();
								self.prop.info.xyzoffset = (self.prop.info.xyzoffset[0], self.prop.info.xyzoffset[1], self.prop.info.xyzoffset[2] + val);
								self.prop.xyzoffset = self.prop.info.xyzoffset;
								self.var_381d73f7 setvalue(self.prop.info.xyzoffset[2]);
								function_4ef69a48();
							}
							else
							{
								if(hudelem == self.var_3e02b967)
								{
									self.prop unlink();
									self.prop.info.anglesoffset = (self.prop.info.anglesoffset[0] + val, self.prop.info.anglesoffset[1], self.prop.info.anglesoffset[2]);
									self.prop.anglesoffset = self.prop.info.anglesoffset;
									self.var_3e02b967 setvalue(self.prop.info.anglesoffset[0]);
									function_4ef69a48();
								}
								else
								{
									if(hudelem == self.var_e7ec6bb6)
									{
										self.prop unlink();
										self.prop.info.anglesoffset = (self.prop.info.anglesoffset[0], self.prop.info.anglesoffset[1] + val, self.prop.info.anglesoffset[2]);
										self.prop.anglesoffset = self.prop.info.anglesoffset;
										self.var_e7ec6bb6 setvalue(self.prop.info.anglesoffset[1]);
										function_4ef69a48();
									}
									else
									{
										if(hudelem == self.var_f1fdc495)
										{
											self.prop unlink();
											self.prop.info.anglesoffset = (self.prop.info.anglesoffset[0], self.prop.info.anglesoffset[1], self.prop.info.anglesoffset[2] + val);
											self.prop.anglesoffset = self.prop.info.anglesoffset;
											self.var_f1fdc495 setvalue(self.prop.info.anglesoffset[2]);
											function_4ef69a48();
										}
										else
										{
											if(hudelem == self.var_40dabe6f)
											{
												adjust = 10;
												self.prop.info.propheight = self.prop.info.propheight + (adjust * val);
												self.prop.info.propheight = math::clamp(self.prop.info.propheight, -30, 40);
												self.thirdpersonheightoffset = self.prop.info.propheight;
												self setclientthirdperson(1, self.thirdpersonrange, self.thirdpersonheightoffset);
												self.var_40dabe6f setvalue(self.prop.info.propheight);
											}
											else if(hudelem == self.var_c9f40191)
											{
												adjust = 10;
												self.prop.info.proprange = self.prop.info.proprange + (adjust * val);
												self.prop.info.proprange = math::clamp(self.prop.info.proprange, 50, 360);
												self.thirdpersonrange = self.prop.info.proprange;
												self setclientthirdperson(1, self.thirdpersonrange, self.thirdpersonheightoffset);
												self.var_c9f40191 setvalue(self.prop.info.proprange);
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	#/
}

/*
	Name: function_4ef69a48
	Namespace: namespace_baba9b52
	Checksum: 0x4757A0ED
	Offset: 0x3A48
	Size: 0x74
	Parameters: 0
	Flags: None
*/
function function_4ef69a48()
{
	/#
		self.prop.origin = self.propent.origin;
		self prop::applyxyzoffset();
		self prop::applyanglesoffset();
		self.prop linkto(self.propent);
	#/
}

/*
	Name: function_9cfa92f3
	Namespace: namespace_baba9b52
	Checksum: 0x5B8E6721
	Offset: 0x3AC8
	Size: 0x1E4
	Parameters: 0
	Flags: None
*/
function function_9cfa92f3()
{
	/#
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
		self namespace_4c773ed3::notifyonplayercommand("", "");
	#/
}

/*
	Name: function_4e71de66
	Namespace: namespace_baba9b52
	Checksum: 0xF5D14F24
	Offset: 0x3CB8
	Size: 0x1E4
	Parameters: 0
	Flags: None
*/
function function_4e71de66()
{
	/#
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
		self namespace_4c773ed3::notifyonplayercommandremove("", "");
	#/
}

/*
	Name: function_b7096a63
	Namespace: namespace_baba9b52
	Checksum: 0xF0F7E163
	Offset: 0x3EA8
	Size: 0x4A
	Parameters: 1
	Flags: None
*/
function function_b7096a63(vec)
{
	/#
		return isdefined(vec) && (vec[0] != 0 || vec[1] != 0 || vec[2] != 0);
	#/
}

/*
	Name: function_f0e744af
	Namespace: namespace_baba9b52
	Checksum: 0x26E43A0
	Offset: 0x3F00
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function function_f0e744af(propinfo)
{
	/#
		return isdefined(propinfo.propheight) && propinfo.propheight != prop::getthirdpersonheightoffsetforsize(propinfo.propsize);
	#/
}

/*
	Name: function_52e4c413
	Namespace: namespace_baba9b52
	Checksum: 0x3832FF7
	Offset: 0x3F60
	Size: 0x54
	Parameters: 1
	Flags: None
*/
function function_52e4c413(propinfo)
{
	/#
		return isdefined(propinfo.proprange) && propinfo.proprange != prop::getthirdpersonrangeforsize(propinfo.propsize);
	#/
}

/*
	Name: function_954fa963
	Namespace: namespace_baba9b52
	Checksum: 0x276C8E5C
	Offset: 0x3FC0
	Size: 0x2A4
	Parameters: 2
	Flags: None
*/
function function_954fa963(file, propinfo)
{
	/#
		var_d7f5ec3f = (((("" + propinfo.modelname) + "") + propinfo.propsizetext) + "") + propinfo.var_bbac36c8;
		if(function_b7096a63(propinfo.xyzoffset))
		{
			var_d7f5ec3f = var_d7f5ec3f + ((((("" + propinfo.xyzoffset[0]) + "") + propinfo.xyzoffset[1]) + "") + propinfo.xyzoffset[2]);
		}
		else
		{
			var_d7f5ec3f = var_d7f5ec3f + "";
		}
		if(function_b7096a63(propinfo.anglesoffset))
		{
			var_d7f5ec3f = var_d7f5ec3f + ((((("" + propinfo.anglesoffset[0]) + "") + propinfo.anglesoffset[1]) + "") + propinfo.anglesoffset[2]);
		}
		else
		{
			var_d7f5ec3f = var_d7f5ec3f + "";
		}
		if(function_f0e744af(propinfo))
		{
			var_d7f5ec3f = var_d7f5ec3f + ("" + propinfo.propheight);
		}
		else
		{
			var_d7f5ec3f = var_d7f5ec3f + ("" + prop::getthirdpersonheightoffsetforsize(propinfo.propsize));
		}
		if(function_52e4c413(propinfo))
		{
			var_d7f5ec3f = var_d7f5ec3f + ("" + propinfo.proprange);
		}
		else
		{
			var_d7f5ec3f = var_d7f5ec3f + ("" + prop::getthirdpersonrangeforsize(propinfo.propsize));
		}
		fprintln(file, var_d7f5ec3f);
	#/
}

/*
	Name: function_90b01d01
	Namespace: namespace_baba9b52
	Checksum: 0x645EFCDA
	Offset: 0x4270
	Size: 0x5C
	Parameters: 2
	Flags: None
*/
function function_90b01d01(file, propinfo)
{
	/#
		var_d7f5ec3f = ("" + propinfo.modelname) + "";
		fprintln(file, var_d7f5ec3f);
	#/
}

/*
	Name: function_74e29250
	Namespace: namespace_baba9b52
	Checksum: 0x78E0E2CF
	Offset: 0x42D8
	Size: 0x128
	Parameters: 2
	Flags: None
*/
function function_74e29250(file, propsizetext)
{
	/#
		foreach(var_bf81cb42 in level.proplist)
		{
			foreach(propinfo in var_bf81cb42)
			{
				if(propinfo.propsizetext == propsizetext)
				{
					function_954fa963(file, propinfo);
				}
			}
		}
	#/
}

/*
	Name: function_bce1e8ea
	Namespace: namespace_baba9b52
	Checksum: 0xB6EE1CEE
	Offset: 0x4408
	Size: 0x128
	Parameters: 2
	Flags: None
*/
function function_bce1e8ea(file, propsizetext)
{
	/#
		foreach(var_bf81cb42 in level.proplist)
		{
			foreach(propinfo in var_bf81cb42)
			{
				if(propinfo.propsizetext == propsizetext)
				{
					function_90b01d01(file, propinfo);
				}
			}
		}
	#/
}

/*
	Name: function_d3a80896
	Namespace: namespace_baba9b52
	Checksum: 0x1E42A382
	Offset: 0x4538
	Size: 0x324
	Parameters: 2
	Flags: None
*/
function function_d3a80896(file, var_dc7b1be6)
{
	/#
		var_7b625b5a = var_dc7b1be6 + "";
		var_74036302 = var_dc7b1be6 + "";
		var_11e4d40d = var_dc7b1be6 + "";
		var_9f31b917 = level.script + "";
		var_a0b36f12 = level.script + "";
		var_43a6e14b = "";
		var_6da36d3e = "";
		var_586b7057 = "";
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, ("" + var_7b625b5a) + "");
		fprintln(file, ("" + var_74036302) + "");
		fprintln(file, (("" + var_11e4d40d) + "") + var_43a6e14b);
		fprintln(file, (("" + var_7b625b5a) + "") + var_586b7057);
		fprintln(file, (("" + var_74036302) + "") + var_6da36d3e);
		fprintln(file, "");
		fprintln(file, (("" + var_9f31b917) + "") + var_dc7b1be6);
		fprintln(file, ((("" + var_a0b36f12) + "") + var_74036302) + "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
	#/
}

/*
	Name: function_543336f9
	Namespace: namespace_baba9b52
	Checksum: 0x1B15ACA1
	Offset: 0x4868
	Size: 0x3C4
	Parameters: 0
	Flags: None
*/
function function_543336f9()
{
	/#
		platform = "";
		if(level.orbis)
		{
			platform = "";
		}
		else if(level.durango)
		{
			platform = "";
		}
		var_dc7b1be6 = level.script + "";
		var_7b625b5a = var_dc7b1be6 + "";
		var_36b45864 = ("" + platform) + "";
		var_586b7057 = "";
		file = openfile(var_7b625b5a, "");
		if(file == -1)
		{
			iprintlnbold((("" + var_36b45864) + var_7b625b5a) + "");
			println((("" + var_36b45864) + var_7b625b5a) + "");
			return;
		}
		function_d3a80896(file, var_dc7b1be6);
		fprintln(file, "");
		function_74e29250(file, "");
		fprintln(file, "");
		fprintln(file, "");
		function_74e29250(file, "");
		fprintln(file, "");
		fprintln(file, "");
		function_74e29250(file, "");
		fprintln(file, "");
		fprintln(file, "");
		function_74e29250(file, "");
		fprintln(file, "");
		fprintln(file, "");
		function_74e29250(file, "");
		iprintlnbold(((("" + var_36b45864) + var_7b625b5a) + "") + var_586b7057);
		println(((("" + var_36b45864) + var_7b625b5a) + "") + var_586b7057);
		closefile(file);
	#/
}

/*
	Name: function_a8147bf9
	Namespace: namespace_baba9b52
	Checksum: 0xC289C660
	Offset: 0x4C38
	Size: 0x3A4
	Parameters: 0
	Flags: None
*/
function function_a8147bf9()
{
	/#
		platform = "";
		if(level.orbis)
		{
			platform = "";
		}
		else if(level.durango)
		{
			platform = "";
		}
		var_dc7b1be6 = level.script + "";
		var_7b625b5a = var_dc7b1be6 + "";
		var_36b45864 = ("" + platform) + "";
		var_586b7057 = "";
		file = openfile(var_7b625b5a, "");
		if(file == -1)
		{
			iprintlnbold((("" + var_36b45864) + var_7b625b5a) + "");
			println((("" + var_36b45864) + var_7b625b5a) + "");
			return;
		}
		fprintln(file, "");
		function_bce1e8ea(file, "");
		fprintln(file, "");
		fprintln(file, "");
		function_bce1e8ea(file, "");
		fprintln(file, "");
		fprintln(file, "");
		function_bce1e8ea(file, "");
		fprintln(file, "");
		fprintln(file, "");
		function_bce1e8ea(file, "");
		fprintln(file, "");
		fprintln(file, "");
		function_bce1e8ea(file, "");
		iprintlnbold(((("" + var_36b45864) + var_7b625b5a) + "") + var_586b7057);
		println(((("" + var_36b45864) + var_7b625b5a) + "") + var_586b7057);
		closefile(file);
	#/
}

/*
	Name: function_1a022b4b
	Namespace: namespace_baba9b52
	Checksum: 0xAA973459
	Offset: 0x4FE8
	Size: 0xC54
	Parameters: 0
	Flags: None
*/
function function_1a022b4b()
{
	/#
		platform = "";
		if(level.orbis)
		{
			platform = "";
		}
		else if(level.durango)
		{
			platform = "";
		}
		var_dc7b1be6 = level.script + "";
		var_7b625b5a = var_dc7b1be6 + "";
		var_74036302 = var_dc7b1be6 + "";
		var_11e4d40d = var_dc7b1be6 + "";
		var_9f31b917 = level.script + "";
		var_a0b36f12 = level.script + "";
		var_36b45864 = ("" + platform) + "";
		var_43a6e14b = "";
		var_6da36d3e = "";
		var_586b7057 = "";
		file = openfile(var_7b625b5a, "");
		if(file == -1)
		{
			iprintlnbold((("" + var_36b45864) + var_7b625b5a) + "");
			println((("" + var_36b45864) + var_7b625b5a) + "");
			return;
		}
		function_d3a80896(file, var_dc7b1be6);
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		closefile(file);
		file = openfile(var_74036302, "");
		if(file == -1)
		{
			iprintlnbold((("" + var_36b45864) + var_74036302) + "");
			println((("" + var_36b45864) + var_74036302) + "");
			return;
		}
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		fprintln(file, "");
		closefile(file);
		file = openfile(var_11e4d40d, "");
		if(file == -1)
		{
			iprintlnbold((("" + var_36b45864) + var_11e4d40d) + "");
			println((("" + var_36b45864) + var_11e4d40d) + "");
			return;
		}
		fprintln(file, "" + var_7b625b5a);
		fprintln(file, "" + var_74036302);
		closefile(file);
		iprintlnbold("" + var_36b45864);
		println("" + var_36b45864);
	#/
}

/*
	Name: function_c64fb4ca
	Namespace: namespace_baba9b52
	Checksum: 0x4B50B060
	Offset: 0x5C48
	Size: 0x3E8
	Parameters: 0
	Flags: None
*/
function function_c64fb4ca()
{
	/#
		player = level.players[0];
		if(!isdefined(player) || !isalive(player) || (!(isdefined(player.hasspawned) && player.hasspawned)))
		{
			return;
		}
		if(isdefined(level.players[1]))
		{
			var_21281cd2 = level.players[1];
		}
		else
		{
			var_21281cd2 = bot::add_bot(util::getotherteam(player.team));
		}
		if(!isdefined(var_21281cd2.pers[""]))
		{
			var_21281cd2.pers[""] = 0;
		}
		if(!isdefined(var_21281cd2.hits))
		{
			var_21281cd2.hits = 0;
		}
		setdvar("", 0);
		setdvar("", 0);
		player.health = player.maxhealth;
		weapon = getweapon("");
		end = player.origin;
		dir = anglestoforward(player.angles);
		start = (end + (dir * 100)) + vectorscale((0, 0, 1), 30);
		magicbullet(weapon, start, end, var_21281cd2);
		var_c2423fb7 = -1 * dir;
		start = (end + (var_c2423fb7 * 100)) + vectorscale((0, 0, 1), 30);
		magicbullet(weapon, start, end, var_21281cd2);
		var_f8c4f14c = anglestoright(player.angles);
		start = (end + (var_f8c4f14c * 100)) + vectorscale((0, 0, 1), 30);
		magicbullet(weapon, start, end, var_21281cd2);
		var_f8388de1 = -1 * var_f8c4f14c;
		start = (end + (var_f8388de1 * 100)) + vectorscale((0, 0, 1), 30);
		magicbullet(weapon, start, end, var_21281cd2);
		start = end + vectorscale((0, 0, 1), 100);
		magicbullet(weapon, start, end, var_21281cd2);
		player util::waittill_notify_or_timeout("", 0.3);
		wait(0.5);
		player.health = player.maxhealth;
	#/
}

/*
	Name: function_276ad638
	Namespace: namespace_baba9b52
	Checksum: 0xA85FB79D
	Offset: 0x6038
	Size: 0x10A
	Parameters: 0
	Flags: None
*/
function function_276ad638()
{
	/#
		if(!isdefined(level.players))
		{
			return;
		}
		foreach(player in level.players)
		{
			if(isdefined(player) && isdefined(player.team) && player.team == game[""])
			{
				print3d(player.origin + vectorscale((0, 0, 1), 50), "" + player.health);
			}
		}
	#/
}

/*
	Name: function_b52ad1b2
	Namespace: namespace_baba9b52
	Checksum: 0xBDB77043
	Offset: 0x6150
	Size: 0x132
	Parameters: 0
	Flags: None
*/
function function_b52ad1b2()
{
	/#
		if(!isdefined(level.players))
		{
			return;
		}
		foreach(player in level.players)
		{
			velocity = player getvelocity();
			var_6c52699a = (velocity[0], velocity[1], 0);
			speed = length(var_6c52699a);
			print3d(player.origin + vectorscale((0, 0, 1), 50), "" + speed);
		}
	#/
}

/*
	Name: function_b02387d6
	Namespace: namespace_baba9b52
	Checksum: 0x3B365809
	Offset: 0x6290
	Size: 0xCA
	Parameters: 0
	Flags: None
*/
function function_b02387d6()
{
	/#
		if(!isdefined(level.players))
		{
			return;
		}
		foreach(player in level.players)
		{
			if(isdefined(player) && isdefined(player.prop))
			{
				player namespace_4c773ed3::get_ground_normal(player.prop, 1);
			}
		}
	#/
}

/*
	Name: function_61b27799
	Namespace: namespace_baba9b52
	Checksum: 0xDF8FDF55
	Offset: 0x6368
	Size: 0x328
	Parameters: 3
	Flags: None
*/
function function_61b27799(propinfo, origin, angles)
{
	/#
		propent = spawn("", origin);
		propent setcontents(0);
		propent notsolid();
		propent setplayercollision(0);
		prop = spawn("", propent.origin);
		prop.angles = angles;
		prop setmodel(propinfo.modelname);
		prop setscale(propinfo.var_bbac36c8, 1);
		prop setcandamage(1);
		prop.xyzoffset = propinfo.xyzoffset;
		prop.anglesoffset = propinfo.anglesoffset;
		prop.health = 1;
		prop setplayercollision(0);
		forward = anglestoforward(angles) * prop.xyzoffset[0];
		right = anglestoright(angles) * prop.xyzoffset[1];
		up = anglestoup(angles) * prop.xyzoffset[2];
		prop.origin = prop.origin + forward;
		prop.origin = prop.origin + right;
		prop.origin = prop.origin + up;
		prop.angles = prop.angles + prop.anglesoffset;
		prop linkto(propent);
		propent.prop = prop;
		propent.propinfo = propinfo;
		return propent;
	#/
}

/*
	Name: function_ad9aebcc
	Namespace: namespace_baba9b52
	Checksum: 0x6628B56A
	Offset: 0x66A0
	Size: 0x264
	Parameters: 0
	Flags: None
*/
function function_ad9aebcc()
{
	/#
		player = level.players[0];
		angles = player.angles;
		dir = anglestoforward(angles);
		origin = player.origin + vectorscale((0, 0, 1), 100);
		if(!isdefined(level.var_7627c471))
		{
			level.var_7627c471 = [];
			foreach(category in level.proplist)
			{
				foreach(propinfo in category)
				{
					level.var_7627c471[level.var_7627c471.size] = function_61b27799(propinfo, origin, angles);
					origin = origin + (dir * 60);
				}
			}
		}
		else
		{
			foreach(propent in level.var_7627c471)
			{
				propent.origin = origin;
				origin = origin + (dir * 60);
			}
		}
	#/
}

/*
	Name: function_36895abd
	Namespace: namespace_baba9b52
	Checksum: 0xE76F612
	Offset: 0x6910
	Size: 0x334
	Parameters: 0
	Flags: None
*/
function function_36895abd()
{
	/#
		if(!isdefined(level.var_ec1690fd))
		{
			return;
		}
		color = (0, 1, 0);
		if(!level.var_ec1690fd.success)
		{
			color = (1, 0, 0);
		}
		print3d(level.var_ec1690fd.playerorg + vectorscale((0, 0, 1), 50), level.var_ec1690fd.type);
		box(level.var_ec1690fd.playerorg, level.var_ec1690fd.playermins, level.var_ec1690fd.playermaxs, level.var_ec1690fd.playerangles[1], color);
		if(isdefined(level.var_ec1690fd.origin1))
		{
			sphere(level.var_ec1690fd.origin1, 5, color);
			line(level.var_ec1690fd.playerorg, level.var_ec1690fd.origin1);
			if(isdefined(level.var_ec1690fd.text1))
			{
				print3d(level.var_ec1690fd.origin1 + (vectorscale((0, 0, -1), 10)), level.var_ec1690fd.text1);
			}
		}
		if(isdefined(level.var_ec1690fd.origin2))
		{
			sphere(level.var_ec1690fd.origin2, 5, color);
			line(level.var_ec1690fd.playerorg, level.var_ec1690fd.origin2);
			if(isdefined(level.var_ec1690fd.text2))
			{
				print3d(level.var_ec1690fd.origin2 + vectorscale((0, 0, 1), 10), level.var_ec1690fd.text2);
			}
		}
		if(isdefined(level.var_ec1690fd.origin3))
		{
			sphere(level.var_ec1690fd.origin3, 5, color);
			line(level.var_ec1690fd.playerorg, level.var_ec1690fd.origin3);
			if(isdefined(level.var_ec1690fd.text3))
			{
				print3d(level.var_ec1690fd.origin3 + vectorscale((0, 0, 1), 30), level.var_ec1690fd.text3);
			}
		}
	#/
}

/*
	Name: function_b2eba1e3
	Namespace: namespace_baba9b52
	Checksum: 0x868DBD0
	Offset: 0x6C50
	Size: 0x19C
	Parameters: 4
	Flags: None
*/
function function_b2eba1e3(propinfo, origin, angles, team)
{
	/#
		var_a20cbf64 = spawn("", origin);
		var_a20cbf64.targetname = "";
		var_a20cbf64 setmodel(propinfo.modelname);
		var_a20cbf64 setscale(propinfo.var_bbac36c8, 1);
		var_a20cbf64.angles = angles;
		var_a20cbf64 setcandamage(1);
		var_a20cbf64.fakehealth = 50;
		var_a20cbf64.health = 99999;
		var_a20cbf64.maxhealth = 99999;
		var_a20cbf64 thread prop::function_500dc7d9(&namespace_4c773ed3::damageclonewatch);
		var_a20cbf64 setplayercollision(0);
		var_a20cbf64 makesentient();
		var_a20cbf64 notsolidcapsule();
		var_a20cbf64 setteam(team);
	#/
}

/*
	Name: function_9b9725b1
	Namespace: namespace_baba9b52
	Checksum: 0x5E43D0EB
	Offset: 0x6DF8
	Size: 0x268
	Parameters: 0
	Flags: None
*/
function function_9b9725b1()
{
	/#
		player = level.players[0];
		angles = player.angles;
		dir = anglestoforward(angles);
		origin = player.origin + vectorscale((0, 0, 1), 100);
		if(isdefined(level.var_79ca1379))
		{
			foreach(clone in level.var_79ca1379)
			{
				clone namespace_4c773ed3::function_a40d8853();
			}
		}
		level.var_79ca1379 = [];
		foreach(category in level.proplist)
		{
			foreach(propinfo in category)
			{
				level.var_79ca1379[level.var_79ca1379.size] = function_b2eba1e3(propinfo, origin, angles, util::getotherteam(player.team));
				origin = origin + (dir * 60);
			}
		}
	#/
}

/*
	Name: function_6863880e
	Namespace: namespace_baba9b52
	Checksum: 0xFBC664A3
	Offset: 0x7068
	Size: 0x11E
	Parameters: 0
	Flags: None
*/
function function_6863880e()
{
	/#
		player = level.players[0];
		angles = player.angles;
		dir = anglestoforward(angles);
		origin = player.origin + (dir * vectorscale((0, 0, 1), 100));
		propinfo = prop::getnextprop(player);
		if(!isdefined(level.var_79ca1379))
		{
			level.var_79ca1379 = [];
		}
		level.var_79ca1379[level.var_79ca1379.size] = function_b2eba1e3(propinfo, origin, angles, util::getotherteam(player.team));
	#/
}

/*
	Name: function_5e127ae8
	Namespace: namespace_baba9b52
	Checksum: 0x69DC4CDD
	Offset: 0x7190
	Size: 0xF2
	Parameters: 0
	Flags: None
*/
function function_5e127ae8()
{
	/#
		if(!isdefined(level.players))
		{
			return;
		}
		foreach(player in level.players)
		{
			box(player.origin, player getmins(), player getmaxs(), player.angles[1], (1, 0, 1), 1, 0, 1);
		}
	#/
}

/*
	Name: function_b9002790
	Namespace: namespace_baba9b52
	Checksum: 0x9A50EFEB
	Offset: 0x7290
	Size: 0xD6
	Parameters: 0
	Flags: None
*/
function function_b9002790()
{
	/#
		if(!isdefined(level.var_e5ad813f) || !isdefined(level.var_e5ad813f.targets))
		{
			return;
		}
		for(i = 0; i < level.var_e5ad813f.targets.size; i++)
		{
			target = level.var_e5ad813f.targets[i];
			if(isdefined(target))
			{
				print3d(target.origin + vectorscale((0, 0, 1), 30), "" + target.fakehealth);
			}
		}
	#/
}

