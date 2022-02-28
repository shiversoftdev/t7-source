// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;

#namespace bonuszm_dev;

/*
	Name: function_6f199738
	Namespace: bonuszm_dev
	Checksum: 0x2218B5B3
	Offset: 0x100
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_6f199738()
{
	/#
		execdevgui("");
		level thread function_17186302();
		level thread function_10489e30();
	#/
}

/*
	Name: function_17186302
	Namespace: bonuszm_dev
	Checksum: 0x9B383309
	Offset: 0x160
	Size: 0x758
	Parameters: 0
	Flags: Linked
*/
function function_17186302()
{
	/#
		setdvar("", 0);
		while(true)
		{
			if(isdefined(level.var_a9e78bf7) && getdvarstring("") == "")
			{
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln((((((("" + "") + "") + level.var_b1955bd6) + "") + level.var_d0e37460) + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
				printtoprightln(("" + "") + level.var_a9e78bf7[""]);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_10489e30
	Namespace: bonuszm_dev
	Checksum: 0x81F50A35
	Offset: 0x8C0
	Size: 0x248
	Parameters: 0
	Flags: Linked
*/
function function_10489e30()
{
	/#
		setdvar("", 0);
		while(true)
		{
			if(getdvarstring("") == "" || (isdefined(level.var_5deb2d16) && level.var_5deb2d16))
			{
				skiptos = getskiptos();
				if(!isdefined(level.var_c7b985ff))
				{
					level.var_c7b985ff = newhudelem();
					level.var_c7b985ff.alignx = "";
					level.var_c7b985ff.aligny = "";
					level.var_c7b985ff.x = 200;
					level.var_c7b985ff.y = 100;
					level.var_c7b985ff.fontscale = 2;
					level.var_c7b985ff.sort = 20;
					level.var_c7b985ff.alpha = 1;
					level.var_c7b985ff.color = vectorscale((1, 1, 1), 0.8);
					level.var_c7b985ff.font = "";
				}
				prefix = "";
				if(isdefined(level.var_5deb2d16) && level.var_5deb2d16)
				{
					prefix = "";
				}
				if(isdefined(level.current_skipto))
				{
					level.var_c7b985ff settext((prefix + "") + level.current_skipto);
				}
				else
				{
					level.var_c7b985ff settext((prefix + "") + "");
				}
			}
			else if(isdefined(level.var_c7b985ff))
			{
				level.var_c7b985ff destroy();
			}
			wait(0.05);
		}
	#/
}

/*
	Name: function_a2a8d5a6
	Namespace: bonuszm_dev
	Checksum: 0x6488E7FC
	Offset: 0xB10
	Size: 0x250
	Parameters: 0
	Flags: None
*/
function function_a2a8d5a6()
{
	/#
		setdvar("", 0);
		nodes = getallnodes();
		while(true)
		{
			if(getdvarstring("") == "")
			{
				level.var_915cfc91 = [];
				foreach(node in nodes)
				{
					if(node.type == "" || node.type == "")
					{
						if(isdefined(node.script_noteworthy) && node.script_noteworthy == "")
						{
							if(!isinarray(level.var_915cfc91, node.animscript))
							{
								level.var_915cfc91[level.var_915cfc91.size] = node.animscript;
							}
						}
					}
				}
				foreach(animscript in level.var_915cfc91)
				{
					println("" + animscript);
				}
			}
			setdvar("", 0);
			wait(0.1);
		}
	#/
}

