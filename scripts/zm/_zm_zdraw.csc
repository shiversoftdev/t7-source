// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

#namespace zm_zdraw;

/*
	Name: __init__sytem__
	Namespace: zm_zdraw
	Checksum: 0x40AE5D3
	Offset: 0x198
	Size: 0x44
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	/#
		system::register("", &__init__, &__main__, undefined);
	#/
}

/*
	Name: __init__
	Namespace: zm_zdraw
	Checksum: 0xBCF0CE2D
	Offset: 0x1E8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		setdvar("", "");
		level.zdraw = spawnstruct();
		function_3e630288();
		function_aa8545fe();
		function_404ac348();
		level thread function_41fec76e();
	#/
}

/*
	Name: __main__
	Namespace: zm_zdraw
	Checksum: 0xEB8FACF
	Offset: 0x280
	Size: 0x8
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	/#
	#/
}

/*
	Name: function_3e630288
	Namespace: zm_zdraw
	Checksum: 0x634BD6E3
	Offset: 0x290
	Size: 0x3BE
	Parameters: 0
	Flags: Linked
*/
function function_3e630288()
{
	/#
		level.zdraw.colors = [];
		level.zdraw.colors[""] = (1, 0, 0);
		level.zdraw.colors[""] = (0, 1, 0);
		level.zdraw.colors[""] = (0, 0, 1);
		level.zdraw.colors[""] = (1, 1, 0);
		level.zdraw.colors[""] = (1, 0.5, 0);
		level.zdraw.colors[""] = (0, 1, 1);
		level.zdraw.colors[""] = (1, 0, 1);
		level.zdraw.colors[""] = (0, 0, 0);
		level.zdraw.colors[""] = (1, 1, 1);
		level.zdraw.colors[""] = vectorscale((1, 1, 1), 0.75);
		level.zdraw.colors[""] = vectorscale((1, 1, 1), 0.1);
		level.zdraw.colors[""] = vectorscale((1, 1, 1), 0.2);
		level.zdraw.colors[""] = vectorscale((1, 1, 1), 0.3);
		level.zdraw.colors[""] = vectorscale((1, 1, 1), 0.4);
		level.zdraw.colors[""] = vectorscale((1, 1, 1), 0.5);
		level.zdraw.colors[""] = vectorscale((1, 1, 1), 0.6);
		level.zdraw.colors[""] = vectorscale((1, 1, 1), 0.7);
		level.zdraw.colors[""] = vectorscale((1, 1, 1), 0.8);
		level.zdraw.colors[""] = vectorscale((1, 1, 1), 0.9);
		level.zdraw.colors[""] = (0.4392157, 0.5019608, 0.5647059);
		level.zdraw.colors[""] = (1, 0.7529412, 0.7960784);
		level.zdraw.colors[""] = vectorscale((1, 1, 0), 0.5019608);
		level.zdraw.colors[""] = (0.5450981, 0.2705882, 0.07450981);
		level.zdraw.colors[""] = (1, 1, 1);
	#/
}

/*
	Name: function_aa8545fe
	Namespace: zm_zdraw
	Checksum: 0xF1BE390B
	Offset: 0x658
	Size: 0x1D6
	Parameters: 0
	Flags: Linked
*/
function function_aa8545fe()
{
	/#
		level.zdraw.commands = [];
		level.zdraw.commands[""] = &function_5ef6cf9b;
		level.zdraw.commands[""] = &function_eae4114a;
		level.zdraw.commands[""] = &function_f2f3c18e;
		level.zdraw.commands[""] = &function_8f04ad79;
		level.zdraw.commands[""] = &function_a13efe1c;
		level.zdraw.commands[""] = &function_b3b92edc;
		level.zdraw.commands[""] = &function_8c2ca616;
		level.zdraw.commands[""] = &function_3145e33f;
		level.zdraw.commands[""] = &function_f36ec3d2;
		level.zdraw.commands[""] = &function_7bdd3089;
		level.zdraw.commands[""] = &function_be7cf134;
	#/
}

/*
	Name: function_404ac348
	Namespace: zm_zdraw
	Checksum: 0x6298CA10
	Offset: 0x838
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_404ac348()
{
	/#
		level.zdraw.color = level.zdraw.colors[""];
		level.zdraw.alpha = 1;
		level.zdraw.scale = 1;
		level.zdraw.duration = int(1 * 62.5);
		level.zdraw.radius = 8;
		level.zdraw.sides = 10;
		level.zdraw.var_5f3c7817 = (0, 0, 0);
		level.zdraw.var_922ae5d = 0;
		level.zdraw.var_c1953771 = "";
	#/
}

/*
	Name: function_41fec76e
	Namespace: zm_zdraw
	Checksum: 0xC11A2415
	Offset: 0x938
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function function_41fec76e()
{
	/#
		level notify(#"hash_15f14510");
		level endon(#"hash_15f14510");
		for(;;)
		{
			cmd = getdvarstring("");
			if(cmd.size)
			{
				function_404ac348();
				params = strtok(cmd, "");
				function_4282fd75(params, 0, 1);
				setdvar("", "");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: function_4282fd75
	Namespace: zm_zdraw
	Checksum: 0xE3D442E7
	Offset: 0xA18
	Size: 0xE2
	Parameters: 3
	Flags: Linked
*/
function function_4282fd75(var_859cfb21, startat, var_37cd5424)
{
	/#
		if(!isdefined(var_37cd5424))
		{
			var_37cd5424 = 0;
		}
		while(isdefined(var_859cfb21[startat]))
		{
			if(isdefined(level.zdraw.commands[var_859cfb21[startat]]))
			{
				startat = [[level.zdraw.commands[var_859cfb21[startat]]]](var_859cfb21, startat + 1);
			}
			else
			{
				if(isdefined(var_37cd5424) && var_37cd5424)
				{
					function_c69caf7e("" + var_859cfb21[startat]);
				}
				return startat;
			}
		}
		return startat;
	#/
}

/*
	Name: function_7bdd3089
	Namespace: zm_zdraw
	Checksum: 0x3DCFCACE
	Offset: 0xB08
	Size: 0x16A
	Parameters: 2
	Flags: Linked
*/
function function_7bdd3089(var_859cfb21, startat)
{
	/#
		while(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				var_b78d9698 = function_36371547(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
					center = level.zdraw.var_5f3c7817;
					sphere(center, level.zdraw.radius, level.zdraw.color, level.zdraw.alpha, 1, level.zdraw.sides, level.zdraw.duration);
					level.zdraw.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = function_4282fd75(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
				}
				else
				{
					return startat;
				}
			}
		}
		return startat;
	#/
}

/*
	Name: function_f36ec3d2
	Namespace: zm_zdraw
	Checksum: 0x8C83621A
	Offset: 0xC80
	Size: 0x13A
	Parameters: 2
	Flags: Linked
*/
function function_f36ec3d2(var_859cfb21, startat)
{
	/#
		while(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				var_b78d9698 = function_36371547(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
					center = level.zdraw.var_5f3c7817;
					debugstar(center, level.zdraw.duration, level.zdraw.color);
					level.zdraw.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = function_4282fd75(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
				}
				else
				{
					return startat;
				}
			}
		}
		return startat;
	#/
}

/*
	Name: function_be7cf134
	Namespace: zm_zdraw
	Checksum: 0xD7519BA1
	Offset: 0xDC8
	Size: 0x19A
	Parameters: 2
	Flags: Linked
*/
function function_be7cf134(var_859cfb21, startat)
{
	/#
		level.zdraw.linestart = undefined;
		while(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				var_b78d9698 = function_36371547(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
					lineend = level.zdraw.var_5f3c7817;
					if(isdefined(level.zdraw.linestart))
					{
						line(level.zdraw.linestart, lineend, level.zdraw.color, level.zdraw.alpha, 1, level.zdraw.duration);
					}
					level.zdraw.linestart = lineend;
					level.zdraw.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = function_4282fd75(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
				}
				else
				{
					return startat;
				}
			}
		}
		return startat;
	#/
}

/*
	Name: function_3145e33f
	Namespace: zm_zdraw
	Checksum: 0x3F83E1B0
	Offset: 0xF70
	Size: 0x202
	Parameters: 2
	Flags: Linked
*/
function function_3145e33f(var_859cfb21, startat)
{
	/#
		level.zdraw.text = "";
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = function_ce50bae5(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.text = level.zdraw.var_c1953771;
				level.zdraw.var_c1953771 = "";
			}
		}
		while(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				var_b78d9698 = function_36371547(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
					center = level.zdraw.var_5f3c7817;
					print3d(center, level.zdraw.text, level.zdraw.color, level.zdraw.alpha, level.zdraw.scale, level.zdraw.duration);
					level.zdraw.var_5f3c7817 = (0, 0, 0);
				}
			}
			else
			{
				var_b78d9698 = function_4282fd75(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
				}
				else
				{
					return startat;
				}
			}
		}
		return startat;
	#/
}

/*
	Name: function_5ef6cf9b
	Namespace: zm_zdraw
	Checksum: 0x28301E68
	Offset: 0x1180
	Size: 0x178
	Parameters: 2
	Flags: Linked
*/
function function_5ef6cf9b(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				var_b78d9698 = function_36371547(var_859cfb21, startat);
				if(var_b78d9698 > startat)
				{
					startat = var_b78d9698;
					level.zdraw.color = level.zdraw.var_5f3c7817;
					level.zdraw.var_5f3c7817 = (0, 0, 0);
				}
				else
				{
					level.zdraw.color = (1, 1, 1);
				}
			}
			else
			{
				if(isdefined(level.zdraw.colors[var_859cfb21[startat]]))
				{
					level.zdraw.color = level.zdraw.colors[var_859cfb21[startat]];
				}
				else
				{
					level.zdraw.color = (1, 1, 1);
					function_c69caf7e("" + var_859cfb21[startat]);
				}
				startat = startat + 1;
			}
		}
		return startat;
	#/
}

/*
	Name: function_eae4114a
	Namespace: zm_zdraw
	Checksum: 0x22D4065C
	Offset: 0x1308
	Size: 0xB8
	Parameters: 2
	Flags: Linked
*/
function function_eae4114a(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.alpha = level.zdraw.var_922ae5d;
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.alpha = 1;
			}
		}
		return startat;
	#/
}

/*
	Name: function_a13efe1c
	Namespace: zm_zdraw
	Checksum: 0x51378D73
	Offset: 0x13D0
	Size: 0xB8
	Parameters: 2
	Flags: Linked
*/
function function_a13efe1c(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.scale = level.zdraw.var_922ae5d;
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.scale = 1;
			}
		}
		return startat;
	#/
}

/*
	Name: function_f2f3c18e
	Namespace: zm_zdraw
	Checksum: 0xAECAD868
	Offset: 0x1498
	Size: 0xE8
	Parameters: 2
	Flags: Linked
*/
function function_f2f3c18e(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.duration = int(level.zdraw.var_922ae5d);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.duration = int(1 * 62.5);
			}
		}
		return startat;
	#/
}

/*
	Name: function_8f04ad79
	Namespace: zm_zdraw
	Checksum: 0xFCC0D5ED
	Offset: 0x1590
	Size: 0xF0
	Parameters: 2
	Flags: Linked
*/
function function_8f04ad79(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.duration = int(62.5 * level.zdraw.var_922ae5d);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.duration = int(1 * 62.5);
			}
		}
		return startat;
	#/
}

/*
	Name: function_b3b92edc
	Namespace: zm_zdraw
	Checksum: 0xC3CBAEE6
	Offset: 0x1690
	Size: 0xB8
	Parameters: 2
	Flags: Linked
*/
function function_b3b92edc(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.radius = level.zdraw.var_922ae5d;
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.radius = 8;
			}
		}
		return startat;
	#/
}

/*
	Name: function_8c2ca616
	Namespace: zm_zdraw
	Checksum: 0xFE5106DB
	Offset: 0x1758
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function function_8c2ca616(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.sides = int(level.zdraw.var_922ae5d);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				level.zdraw.sides = 10;
			}
		}
		return startat;
	#/
}

/*
	Name: function_c0fb9425
	Namespace: zm_zdraw
	Checksum: 0x1C3EE0D0
	Offset: 0x1830
	Size: 0x86
	Parameters: 1
	Flags: Linked
*/
function function_c0fb9425(param)
{
	/#
		if(isdefined(param) && (isint(param) || isfloat(param) || (isstring(param) && strisnumber(param))))
		{
			return true;
		}
		return false;
	#/
}

/*
	Name: function_36371547
	Namespace: zm_zdraw
	Checksum: 0xB60484EA
	Offset: 0x18C0
	Size: 0x25E
	Parameters: 2
	Flags: Linked
*/
function function_36371547(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			var_b78d9698 = function_33acda19(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.var_5f3c7817 = (level.zdraw.var_922ae5d, level.zdraw.var_5f3c7817[1], level.zdraw.var_5f3c7817[2]);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				function_c69caf7e("");
				return startat;
			}
			var_b78d9698 = function_33acda19(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.var_5f3c7817 = (level.zdraw.var_5f3c7817[0], level.zdraw.var_922ae5d, level.zdraw.var_5f3c7817[2]);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				function_c69caf7e("");
				return startat;
			}
			var_b78d9698 = function_33acda19(var_859cfb21, startat);
			if(var_b78d9698 > startat)
			{
				startat = var_b78d9698;
				level.zdraw.var_5f3c7817 = (level.zdraw.var_5f3c7817[0], level.zdraw.var_5f3c7817[1], level.zdraw.var_922ae5d);
				level.zdraw.var_922ae5d = 0;
			}
			else
			{
				function_c69caf7e("");
				return startat;
			}
		}
		return startat;
	#/
}

/*
	Name: function_33acda19
	Namespace: zm_zdraw
	Checksum: 0x24066F26
	Offset: 0x1B28
	Size: 0x88
	Parameters: 2
	Flags: Linked
*/
function function_33acda19(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			if(function_c0fb9425(var_859cfb21[startat]))
			{
				level.zdraw.var_922ae5d = float(var_859cfb21[startat]);
				startat = startat + 1;
			}
		}
		return startat;
	#/
}

/*
	Name: function_ce50bae5
	Namespace: zm_zdraw
	Checksum: 0x2F7F683F
	Offset: 0x1BC0
	Size: 0x58
	Parameters: 2
	Flags: Linked
*/
function function_ce50bae5(var_859cfb21, startat)
{
	/#
		if(isdefined(var_859cfb21[startat]))
		{
			level.zdraw.var_c1953771 = var_859cfb21[startat];
			startat = startat + 1;
		}
		return startat;
	#/
}

/*
	Name: function_c69caf7e
	Namespace: zm_zdraw
	Checksum: 0x8CAFBD4A
	Offset: 0x1C28
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_c69caf7e(msg)
{
	/#
		println("" + msg);
	#/
}

