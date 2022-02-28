// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace dev;

/*
	Name: debug_sphere
	Namespace: dev
	Checksum: 0x6A755D42
	Offset: 0x150
	Size: 0xCC
	Parameters: 5
	Flags: Linked
*/
function debug_sphere(origin, radius, color, alpha, time)
{
	/#
		if(!isdefined(time))
		{
			time = 1000;
		}
		if(!isdefined(color))
		{
			color = (1, 1, 1);
		}
		sides = int(10 * (1 + (int(radius) % 100)));
		sphere(origin, radius, color, alpha, 1, sides, time);
	#/
}

/*
	Name: updateminimapsetting
	Namespace: dev
	Checksum: 0x9CB49404
	Offset: 0x228
	Size: 0xB1C
	Parameters: 0
	Flags: Linked
*/
function updateminimapsetting()
{
	/#
		requiredmapaspectratio = getdvarfloat("");
		if(!isdefined(level.minimapheight))
		{
			setdvar("", "");
			level.minimapheight = 0;
		}
		minimapheight = getdvarfloat("");
		if(minimapheight != level.minimapheight)
		{
			if(minimapheight <= 0)
			{
				util::gethostplayer() cameraactivate(0);
				level.minimapheight = minimapheight;
				level notify(#"end_draw_map_bounds");
			}
			if(minimapheight > 0)
			{
				level.minimapheight = minimapheight;
				players = getplayers();
				if(players.size > 0)
				{
					player = util::gethostplayer();
					corners = getentarray("", "");
					if(corners.size == 2)
					{
						viewpos = corners[0].origin + corners[1].origin;
						viewpos = (viewpos[0] * 0.5, viewpos[1] * 0.5, viewpos[2] * 0.5);
						level thread minimapwarn(corners);
						maxcorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
						mincorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
						if(corners[1].origin[0] > corners[0].origin[0])
						{
							maxcorner = (corners[1].origin[0], maxcorner[1], maxcorner[2]);
						}
						else
						{
							mincorner = (corners[1].origin[0], mincorner[1], mincorner[2]);
						}
						if(corners[1].origin[1] > corners[0].origin[1])
						{
							maxcorner = (maxcorner[0], corners[1].origin[1], maxcorner[2]);
						}
						else
						{
							mincorner = (mincorner[0], corners[1].origin[1], mincorner[2]);
						}
						viewpostocorner = maxcorner - viewpos;
						viewpos = (viewpos[0], viewpos[1], viewpos[2] + minimapheight);
						northvector = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
						eastvector = (northvector[1], 0 - northvector[0], 0);
						disttotop = vectordot(northvector, viewpostocorner);
						if(disttotop < 0)
						{
							disttotop = 0 - disttotop;
						}
						disttoside = vectordot(eastvector, viewpostocorner);
						if(disttoside < 0)
						{
							disttoside = 0 - disttoside;
						}
						if(requiredmapaspectratio > 0)
						{
							mapaspectratio = disttoside / disttotop;
							if(mapaspectratio < requiredmapaspectratio)
							{
								incr = requiredmapaspectratio / mapaspectratio;
								disttoside = disttoside * incr;
								addvec = vecscale(eastvector, (vectordot(eastvector, maxcorner - viewpos)) * (incr - 1));
								mincorner = mincorner - addvec;
								maxcorner = maxcorner + addvec;
							}
							else
							{
								incr = mapaspectratio / requiredmapaspectratio;
								disttotop = disttotop * incr;
								addvec = vecscale(northvector, (vectordot(northvector, maxcorner - viewpos)) * (incr - 1));
								mincorner = mincorner - addvec;
								maxcorner = maxcorner + addvec;
							}
						}
						if(level.console)
						{
							aspectratioguess = 1.777778;
							angleside = 2 * (atan((disttoside * 0.8) / minimapheight));
							angletop = 2 * (atan(((disttotop * aspectratioguess) * 0.8) / minimapheight));
						}
						else
						{
							aspectratioguess = 1.333333;
							angleside = 2 * (atan(disttoside / minimapheight));
							angletop = 2 * (atan((disttotop * aspectratioguess) / minimapheight));
						}
						if(angleside > angletop)
						{
							angle = angleside;
						}
						else
						{
							angle = angletop;
						}
						znear = minimapheight - 1000;
						if(znear < 16)
						{
							znear = 16;
						}
						if(znear > 10000)
						{
							znear = 10000;
						}
						player camerasetposition(viewpos, (90, getnorthyaw(), 0));
						player cameraactivate(1);
						player takeallweapons();
						setdvar("", 0);
						setdvar("", 0);
						setdvar("", 0);
						setdvar("", 0);
						setdvar("", 0);
						setdvar("", 0);
						setdvar("", znear);
						setdvar("", 0.1);
						setdvar("", 0);
						setdvar("", 1);
						setdvar("", 90);
						setdvar("", 0);
						setdvar("", 1);
						setdvar("", 1);
						setdvar("", 0);
						setdvar("", 0);
						setdvar("", "");
						if(isdefined(level.objpoints))
						{
							for(i = 0; i < level.objpointnames.size; i++)
							{
								if(isdefined(level.objpoints[level.objpointnames[i]]))
								{
									level.objpoints[level.objpointnames[i]] destroy();
								}
							}
							level.objpoints = [];
							level.objpointnames = [];
						}
						thread drawminimapbounds(viewpos, mincorner, maxcorner);
					}
					else
					{
						println("");
					}
				}
				else
				{
					setdvar("", "");
				}
			}
		}
	#/
}

/*
	Name: vecscale
	Namespace: dev
	Checksum: 0x301D0C37
	Offset: 0xD50
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function vecscale(vec, scalar)
{
	/#
		return (vec[0] * scalar, vec[1] * scalar, vec[2] * scalar);
	#/
}

/*
	Name: drawminimapbounds
	Namespace: dev
	Checksum: 0x6B765295
	Offset: 0xDA8
	Size: 0x3C0
	Parameters: 3
	Flags: Linked
*/
function drawminimapbounds(viewpos, mincorner, maxcorner)
{
	/#
		level notify(#"end_draw_map_bounds");
		level endon(#"end_draw_map_bounds");
		viewheight = viewpos[2] - maxcorner[2];
		north = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
		diaglen = length(mincorner - maxcorner);
		mincorneroffset = mincorner - viewpos;
		mincorneroffset = vectornormalize((mincorneroffset[0], mincorneroffset[1], 0));
		mincorner = mincorner + (vecscale(mincorneroffset, (diaglen * 1) / 800));
		maxcorneroffset = maxcorner - viewpos;
		maxcorneroffset = vectornormalize((maxcorneroffset[0], maxcorneroffset[1], 0));
		maxcorner = maxcorner + (vecscale(maxcorneroffset, (diaglen * 1) / 800));
		diagonal = maxcorner - mincorner;
		side = vecscale(north, vectordot(diagonal, north));
		sidenorth = vecscale(north, abs(vectordot(diagonal, north)));
		corner0 = mincorner;
		corner1 = mincorner + side;
		corner2 = maxcorner;
		corner3 = maxcorner - side;
		toppos = (vecscale(mincorner + maxcorner, 0.5)) + vecscale(sidenorth, 0.51);
		textscale = diaglen * 0.003;
		while(true)
		{
			line(corner0, corner1);
			line(corner1, corner2);
			line(corner2, corner3);
			line(corner3, corner0);
			print3d(toppos, "", (1, 1, 1), 1, textscale);
			wait(0.05);
		}
	#/
}

/*
	Name: minimapwarn
	Namespace: dev
	Checksum: 0x3ABD2D34
	Offset: 0x1170
	Size: 0x1E6
	Parameters: 1
	Flags: Linked
*/
function minimapwarn(corners)
{
	/#
		threshold = 10;
		width = abs(corners[0].origin[0] - corners[1].origin[0]);
		width = int(width);
		height = abs(corners[0].origin[1] - corners[1].origin[1]);
		height = int(height);
		if((abs(width - height)) > threshold)
		{
			for(;;)
			{
				iprintln(((("" + width) + "") + height) + "");
				if(height > width)
				{
					scale = height / width;
					iprintln(("" + scale) + "");
				}
				else
				{
					scale = width / height;
					iprintln(("" + scale) + "");
				}
				wait(10);
			}
		}
	#/
}

/*
	Name: body_customization_setup_helmet
	Namespace: dev
	Checksum: 0xF87EFA4F
	Offset: 0x1360
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function body_customization_setup_helmet(helmet_index)
{
	/#
		foreach(player in getplayers())
		{
			player setcharacterhelmetstyle(helmet_index);
		}
	#/
}

/*
	Name: body_customization_setup_body
	Namespace: dev
	Checksum: 0x22469CFD
	Offset: 0x1418
	Size: 0xCA
	Parameters: 2
	Flags: Linked
*/
function body_customization_setup_body(character_index, body_index)
{
	/#
		foreach(player in getplayers())
		{
			player setcharacterbodytype(character_index);
			player setcharacterbodystyle(body_index);
		}
	#/
}

/*
	Name: body_customization_process_command
	Namespace: dev
	Checksum: 0xCAEB5420
	Offset: 0x14F0
	Size: 0x21E
	Parameters: 1
	Flags: Linked
*/
function body_customization_process_command(character_index)
{
	/#
		split = strtok(character_index, "");
		switch(split.size)
		{
			case 1:
			default:
			{
				command0 = strtok(split[0], "");
				character_index = int(command0[1]);
				body_index = 0;
				helmet_index = 0;
				body_customization_setup_helmet(helmet_index);
				body_customization_setup_body(character_index, body_index);
				break;
			}
			case 2:
			{
				command0 = strtok(split[0], "");
				character_index = int(command0[1]);
				command1 = strtok(split[1], "");
				if(command1[0] == "")
				{
					body_index = int(command1[1]);
					body_customization_setup_body(character_index, body_index);
				}
				else if(command1[0] == "")
				{
					helmet_index = int(command1[1]);
					body_customization_setup_helmet(helmet_index);
				}
				break;
			}
		}
	#/
}

/*
	Name: body_customization_populate
	Namespace: dev
	Checksum: 0x13761B6
	Offset: 0x1718
	Size: 0x2E6
	Parameters: 1
	Flags: Linked
*/
function body_customization_populate(mode)
{
	/#
		bodies = getallcharacterbodies(mode);
		body_customization_devgui_base = "";
		foreach(playerbodytype in bodies)
		{
			body_name = (makelocalizedstring(getcharacterdisplayname(playerbodytype, mode)) + "") + getcharacterassetname(playerbodytype, mode) + "";
			adddebugcommand((((((((body_customization_devgui_base + body_name) + "") + "") + "") + "") + "") + playerbodytype) + "");
			for(i = 0; i < getcharacterbodymodelcount(playerbodytype, mode); i++)
			{
				adddebugcommand((((((((((((body_customization_devgui_base + body_name) + "") + i) + "") + "") + "") + "") + playerbodytype) + "") + "") + i) + "");
				wait(0.05);
			}
			for(i = 0; i < getcharacterhelmetmodelcount(playerbodytype, mode); i++)
			{
				adddebugcommand((((((((((((body_customization_devgui_base + body_name) + "") + i) + "") + "") + "") + "") + playerbodytype) + "") + "") + i) + "");
				wait(0.05);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: body_customization_devgui
	Namespace: dev
	Checksum: 0xCE02794D
	Offset: 0x1A08
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function body_customization_devgui(mode)
{
	/#
		thread body_customization_populate(mode);
		for(;;)
		{
			character_index = getdvarstring("");
			if(character_index != "")
			{
				body_customization_process_command(character_index);
			}
			setdvar("", "");
			wait(0.5);
		}
	#/
}

/*
	Name: add_perk_devgui
	Namespace: dev
	Checksum: 0xA9980C64
	Offset: 0x1AA8
	Size: 0xDC
	Parameters: 2
	Flags: None
*/
function add_perk_devgui(name, specialties)
{
	/#
		perk_devgui_base = "";
		perk_name = makelocalizedstring(name);
		test = (((((perk_devgui_base + perk_name) + "") + "") + "") + specialties) + "";
		adddebugcommand((((((perk_devgui_base + perk_name) + "") + "") + "") + specialties) + "");
	#/
}

