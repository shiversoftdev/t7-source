// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\lui_shared;
#using scripts\shared\util_shared;

#namespace hud;

/*
	Name: setparent
	Namespace: hud
	Checksum: 0x44B1A20E
	Offset: 0x2E0
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function setparent(element)
{
	if(isdefined(self.parent) && self.parent == element)
	{
		return;
	}
	if(isdefined(self.parent))
	{
		self.parent removechild(self);
	}
	self.parent = element;
	self.parent addchild(self);
	if(isdefined(self.point))
	{
		self setpoint(self.point, self.relativepoint, self.xoffset, self.yoffset);
	}
	else
	{
		self setpoint("TOP");
	}
}

/*
	Name: getparent
	Namespace: hud
	Checksum: 0x6ADBF6AC
	Offset: 0x3C8
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function getparent()
{
	return self.parent;
}

/*
	Name: addchild
	Namespace: hud
	Checksum: 0xEBB23835
	Offset: 0x3E0
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function addchild(element)
{
	element.index = self.children.size;
	self.children[self.children.size] = element;
}

/*
	Name: removechild
	Namespace: hud
	Checksum: 0x6B0DA04E
	Offset: 0x428
	Size: 0xC6
	Parameters: 1
	Flags: Linked
*/
function removechild(element)
{
	element.parent = undefined;
	if((self.children[self.children.size - 1]) != element)
	{
		self.children[element.index] = self.children[self.children.size - 1];
		self.children[element.index].index = element.index;
	}
	self.children[self.children.size - 1] = undefined;
	element.index = undefined;
}

/*
	Name: setpoint
	Namespace: hud
	Checksum: 0xBA0F5E96
	Offset: 0x4F8
	Size: 0x834
	Parameters: 5
	Flags: Linked
*/
function setpoint(point, relativepoint, xoffset, yoffset, movetime = 0)
{
	element = self getparent();
	if(movetime)
	{
		self moveovertime(movetime);
	}
	if(!isdefined(xoffset))
	{
		xoffset = 0;
	}
	self.xoffset = xoffset;
	if(!isdefined(yoffset))
	{
		yoffset = 0;
	}
	self.yoffset = yoffset;
	self.point = point;
	self.alignx = "center";
	self.aligny = "middle";
	switch(point)
	{
		case "CENTER":
		{
			break;
		}
		case "TOP":
		{
			self.aligny = "top";
			break;
		}
		case "BOTTOM":
		{
			self.aligny = "bottom";
			break;
		}
		case "LEFT":
		{
			self.alignx = "left";
			break;
		}
		case "RIGHT":
		{
			self.alignx = "right";
			break;
		}
		case "TOPRIGHT":
		case "TOP_RIGHT":
		{
			self.aligny = "top";
			self.alignx = "right";
			break;
		}
		case "TOPLEFT":
		case "TOP_LEFT":
		{
			self.aligny = "top";
			self.alignx = "left";
			break;
		}
		case "TOPCENTER":
		{
			self.aligny = "top";
			self.alignx = "center";
			break;
		}
		case "BOTTOM RIGHT":
		case "BOTTOM_RIGHT":
		{
			self.aligny = "bottom";
			self.alignx = "right";
			break;
		}
		case "BOTTOM LEFT":
		case "BOTTOM_LEFT":
		{
			self.aligny = "bottom";
			self.alignx = "left";
			break;
		}
		default:
		{
			/#
				println("" + point);
			#/
			break;
		}
	}
	if(!isdefined(relativepoint))
	{
		relativepoint = point;
	}
	self.relativepoint = relativepoint;
	relativex = "center";
	relativey = "middle";
	switch(relativepoint)
	{
		case "CENTER":
		{
			break;
		}
		case "TOP":
		{
			relativey = "top";
			break;
		}
		case "BOTTOM":
		{
			relativey = "bottom";
			break;
		}
		case "LEFT":
		{
			relativex = "left";
			break;
		}
		case "RIGHT":
		{
			relativex = "right";
			break;
		}
		case "TOPRIGHT":
		case "TOP_RIGHT":
		{
			relativey = "top";
			relativex = "right";
			break;
		}
		case "TOPLEFT":
		case "TOP_LEFT":
		{
			relativey = "top";
			relativex = "left";
			break;
		}
		case "TOPCENTER":
		{
			relativey = "top";
			relativex = "center";
			break;
		}
		case "BOTTOM RIGHT":
		case "BOTTOM_RIGHT":
		{
			relativey = "bottom";
			relativex = "right";
			break;
		}
		case "BOTTOM LEFT":
		case "BOTTOM_LEFT":
		{
			relativey = "bottom";
			relativex = "left";
			break;
		}
		default:
		{
			/#
				println("" + relativepoint);
			#/
			break;
		}
	}
	if(element == level.uiparent)
	{
		self.horzalign = relativex;
		self.vertalign = relativey;
	}
	else
	{
		self.horzalign = element.horzalign;
		self.vertalign = element.vertalign;
	}
	if(relativex == element.alignx)
	{
		offsetx = 0;
		xfactor = 0;
	}
	else
	{
		if(relativex == "center" || element.alignx == "center")
		{
			offsetx = int(element.width / 2);
			if(relativex == "left" || element.alignx == "right")
			{
				xfactor = -1;
			}
			else
			{
				xfactor = 1;
			}
		}
		else
		{
			offsetx = element.width;
			if(relativex == "left")
			{
				xfactor = -1;
			}
			else
			{
				xfactor = 1;
			}
		}
	}
	self.x = element.x + (offsetx * xfactor);
	if(relativey == element.aligny)
	{
		offsety = 0;
		yfactor = 0;
	}
	else
	{
		if(relativey == "middle" || element.aligny == "middle")
		{
			offsety = int(element.height / 2);
			if(relativey == "top" || element.aligny == "bottom")
			{
				yfactor = -1;
			}
			else
			{
				yfactor = 1;
			}
		}
		else
		{
			offsety = element.height;
			if(relativey == "top")
			{
				yfactor = -1;
			}
			else
			{
				yfactor = 1;
			}
		}
	}
	self.y = element.y + (offsety * yfactor);
	self.x = self.x + self.xoffset;
	self.y = self.y + self.yoffset;
	switch(self.elemtype)
	{
		case "bar":
		{
			setpointbar(point, relativepoint, xoffset, yoffset);
			self.barframe setparent(self getparent());
			self.barframe setpoint(point, relativepoint, xoffset, yoffset);
			break;
		}
	}
	self updatechildren();
}

/*
	Name: setpointbar
	Namespace: hud
	Checksum: 0x2B7DBBE2
	Offset: 0xD38
	Size: 0x1BC
	Parameters: 4
	Flags: Linked
*/
function setpointbar(point, relativepoint, xoffset, yoffset)
{
	self.bar.horzalign = self.horzalign;
	self.bar.vertalign = self.vertalign;
	self.bar.alignx = "left";
	self.bar.aligny = self.aligny;
	self.bar.y = self.y;
	if(self.alignx == "left")
	{
		self.bar.x = self.x;
	}
	else
	{
		if(self.alignx == "right")
		{
			self.bar.x = self.x - self.width;
		}
		else
		{
			self.bar.x = self.x - (int(self.width / 2));
		}
	}
	if(self.aligny == "top")
	{
		self.bar.y = self.y;
	}
	else if(self.aligny == "bottom")
	{
		self.bar.y = self.y;
	}
	self updatebar(self.bar.frac);
}

/*
	Name: updatebar
	Namespace: hud
	Checksum: 0xED78D51A
	Offset: 0xF00
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function updatebar(barfrac, rateofchange)
{
	if(self.elemtype == "bar")
	{
		updatebarscale(barfrac, rateofchange);
	}
}

/*
	Name: updatebarscale
	Namespace: hud
	Checksum: 0xC9043F0A
	Offset: 0xF50
	Size: 0x254
	Parameters: 2
	Flags: Linked
*/
function updatebarscale(barfrac, rateofchange)
{
	barwidth = int((self.width * barfrac) + 0.5);
	if(!barwidth)
	{
		barwidth = 1;
	}
	self.bar.frac = barfrac;
	self.bar setshader(self.bar.shader, barwidth, self.height);
	/#
		assert(barwidth <= self.width, (((("" + barwidth) + "") + self.width) + "") + barfrac);
	#/
	if(isdefined(rateofchange) && barwidth < self.width)
	{
		if(rateofchange > 0)
		{
			/#
				assert(((1 - barfrac) / rateofchange) > 0, (("" + barfrac) + "") + rateofchange);
			#/
			self.bar scaleovertime((1 - barfrac) / rateofchange, self.width, self.height);
		}
		else if(rateofchange < 0)
		{
			/#
				assert((barfrac / -1 * rateofchange) > 0, (("" + barfrac) + "") + rateofchange);
			#/
			self.bar scaleovertime(barfrac / -1 * rateofchange, 1, self.height);
		}
	}
	self.bar.rateofchange = rateofchange;
	self.bar.lastupdatetime = gettime();
}

/*
	Name: createfontstring
	Namespace: hud
	Checksum: 0x7D233E29
	Offset: 0x11B0
	Size: 0x130
	Parameters: 2
	Flags: Linked
*/
function createfontstring(font, fontscale)
{
	fontelem = newclienthudelem(self);
	fontelem.elemtype = "font";
	fontelem.font = font;
	fontelem.fontscale = fontscale;
	fontelem.x = 0;
	fontelem.y = 0;
	fontelem.width = 0;
	fontelem.height = int(level.fontheight * fontscale);
	fontelem.xoffset = 0;
	fontelem.yoffset = 0;
	fontelem.children = [];
	fontelem setparent(level.uiparent);
	fontelem.hidden = 0;
	return fontelem;
}

/*
	Name: createserverfontstring
	Namespace: hud
	Checksum: 0x6EA1784A
	Offset: 0x12E8
	Size: 0x158
	Parameters: 3
	Flags: Linked
*/
function createserverfontstring(font, fontscale, team)
{
	if(isdefined(team))
	{
		fontelem = newteamhudelem(team);
	}
	else
	{
		fontelem = newhudelem();
	}
	fontelem.elemtype = "font";
	fontelem.font = font;
	fontelem.fontscale = fontscale;
	fontelem.x = 0;
	fontelem.y = 0;
	fontelem.width = 0;
	fontelem.height = int(level.fontheight * fontscale);
	fontelem.xoffset = 0;
	fontelem.yoffset = 0;
	fontelem.children = [];
	fontelem setparent(level.uiparent);
	fontelem.hidden = 0;
	return fontelem;
}

/*
	Name: createservertimer
	Namespace: hud
	Checksum: 0x885877FD
	Offset: 0x1448
	Size: 0x158
	Parameters: 3
	Flags: None
*/
function createservertimer(font, fontscale, team)
{
	if(isdefined(team))
	{
		timerelem = newteamhudelem(team);
	}
	else
	{
		timerelem = newhudelem();
	}
	timerelem.elemtype = "timer";
	timerelem.font = font;
	timerelem.fontscale = fontscale;
	timerelem.x = 0;
	timerelem.y = 0;
	timerelem.width = 0;
	timerelem.height = int(level.fontheight * fontscale);
	timerelem.xoffset = 0;
	timerelem.yoffset = 0;
	timerelem.children = [];
	timerelem setparent(level.uiparent);
	timerelem.hidden = 0;
	return timerelem;
}

/*
	Name: createclienttimer
	Namespace: hud
	Checksum: 0xF387CCCB
	Offset: 0x15A8
	Size: 0x130
	Parameters: 2
	Flags: None
*/
function createclienttimer(font, fontscale)
{
	timerelem = newclienthudelem(self);
	timerelem.elemtype = "timer";
	timerelem.font = font;
	timerelem.fontscale = fontscale;
	timerelem.x = 0;
	timerelem.y = 0;
	timerelem.width = 0;
	timerelem.height = int(level.fontheight * fontscale);
	timerelem.xoffset = 0;
	timerelem.yoffset = 0;
	timerelem.children = [];
	timerelem setparent(level.uiparent);
	timerelem.hidden = 0;
	return timerelem;
}

/*
	Name: createicon
	Namespace: hud
	Checksum: 0x798E9BE7
	Offset: 0x16E0
	Size: 0x130
	Parameters: 3
	Flags: Linked
*/
function createicon(shader, width, height)
{
	iconelem = newclienthudelem(self);
	iconelem.elemtype = "icon";
	iconelem.x = 0;
	iconelem.y = 0;
	iconelem.width = width;
	iconelem.height = height;
	iconelem.xoffset = 0;
	iconelem.yoffset = 0;
	iconelem.children = [];
	iconelem setparent(level.uiparent);
	iconelem.hidden = 0;
	if(isdefined(shader))
	{
		iconelem setshader(shader, width, height);
	}
	return iconelem;
}

/*
	Name: createservericon
	Namespace: hud
	Checksum: 0x168C9662
	Offset: 0x1818
	Size: 0x158
	Parameters: 4
	Flags: None
*/
function createservericon(shader, width, height, team)
{
	if(isdefined(team))
	{
		iconelem = newteamhudelem(team);
	}
	else
	{
		iconelem = newhudelem();
	}
	iconelem.elemtype = "icon";
	iconelem.x = 0;
	iconelem.y = 0;
	iconelem.width = width;
	iconelem.height = height;
	iconelem.xoffset = 0;
	iconelem.yoffset = 0;
	iconelem.children = [];
	iconelem setparent(level.uiparent);
	iconelem.hidden = 0;
	if(isdefined(shader))
	{
		iconelem setshader(shader, width, height);
	}
	return iconelem;
}

/*
	Name: createserverbar
	Namespace: hud
	Checksum: 0xB0AC180F
	Offset: 0x1978
	Size: 0x470
	Parameters: 6
	Flags: Linked
*/
function createserverbar(color, width, height, flashfrac, team, selected)
{
	if(isdefined(team))
	{
		barelem = newteamhudelem(team);
	}
	else
	{
		barelem = newhudelem();
	}
	barelem.x = 0;
	barelem.y = 0;
	barelem.frac = 0;
	barelem.color = color;
	barelem.sort = -2;
	barelem.shader = "progress_bar_fill";
	barelem setshader("progress_bar_fill", width, height);
	barelem.hidden = 0;
	if(isdefined(flashfrac))
	{
		barelem.flashfrac = flashfrac;
	}
	if(isdefined(team))
	{
		barelemframe = newteamhudelem(team);
	}
	else
	{
		barelemframe = newhudelem();
	}
	barelemframe.elemtype = "icon";
	barelemframe.x = 0;
	barelemframe.y = 0;
	barelemframe.width = width;
	barelemframe.height = height;
	barelemframe.xoffset = 0;
	barelemframe.yoffset = 0;
	barelemframe.bar = barelem;
	barelemframe.barframe = barelemframe;
	barelemframe.children = [];
	barelemframe.sort = -1;
	barelemframe.color = (1, 1, 1);
	barelemframe setparent(level.uiparent);
	if(isdefined(selected))
	{
		barelemframe setshader("progress_bar_fg_sel", width, height);
	}
	else
	{
		barelemframe setshader("progress_bar_fg", width, height);
	}
	barelemframe.hidden = 0;
	if(isdefined(team))
	{
		barelembg = newteamhudelem(team);
	}
	else
	{
		barelembg = newhudelem();
	}
	barelembg.elemtype = "bar";
	barelembg.x = 0;
	barelembg.y = 0;
	barelembg.width = width;
	barelembg.height = height;
	barelembg.xoffset = 0;
	barelembg.yoffset = 0;
	barelembg.bar = barelem;
	barelembg.barframe = barelemframe;
	barelembg.children = [];
	barelembg.sort = -3;
	barelembg.color = (0, 0, 0);
	barelembg.alpha = 0.5;
	barelembg setparent(level.uiparent);
	barelembg setshader("progress_bar_bg", width, height);
	barelembg.hidden = 0;
	return barelembg;
}

/*
	Name: createbar
	Namespace: hud
	Checksum: 0x5D150E36
	Offset: 0x1DF0
	Size: 0x3F0
	Parameters: 4
	Flags: Linked
*/
function createbar(color, width, height, flashfrac)
{
	barelem = newclienthudelem(self);
	barelem.x = 0;
	barelem.y = 0;
	barelem.frac = 0;
	barelem.color = color;
	barelem.sort = -2;
	barelem.shader = "progress_bar_fill";
	barelem setshader("progress_bar_fill", width, height);
	barelem.hidden = 0;
	if(isdefined(flashfrac))
	{
		barelem.flashfrac = flashfrac;
	}
	barelemframe = newclienthudelem(self);
	barelemframe.elemtype = "icon";
	barelemframe.x = 0;
	barelemframe.y = 0;
	barelemframe.width = width;
	barelemframe.height = height;
	barelemframe.xoffset = 0;
	barelemframe.yoffset = 0;
	barelemframe.bar = barelem;
	barelemframe.barframe = barelemframe;
	barelemframe.children = [];
	barelemframe.sort = -1;
	barelemframe.color = (1, 1, 1);
	barelemframe setparent(level.uiparent);
	barelemframe.hidden = 0;
	barelembg = newclienthudelem(self);
	barelembg.elemtype = "bar";
	if(!level.splitscreen)
	{
		barelembg.x = -2;
		barelembg.y = -2;
	}
	barelembg.width = width;
	barelembg.height = height;
	barelembg.xoffset = 0;
	barelembg.yoffset = 0;
	barelembg.bar = barelem;
	barelembg.barframe = barelemframe;
	barelembg.children = [];
	barelembg.sort = -3;
	barelembg.color = (0, 0, 0);
	barelembg.alpha = 0.5;
	barelembg setparent(level.uiparent);
	if(!level.splitscreen)
	{
		barelembg setshader("progress_bar_bg", width + 4, height + 4);
	}
	else
	{
		barelembg setshader("progress_bar_bg", width + 0, height + 0);
	}
	barelembg.hidden = 0;
	return barelembg;
}

/*
	Name: getcurrentfraction
	Namespace: hud
	Checksum: 0xC01AF5D6
	Offset: 0x21E8
	Size: 0x94
	Parameters: 0
	Flags: None
*/
function getcurrentfraction()
{
	frac = self.bar.frac;
	if(isdefined(self.bar.rateofchange))
	{
		frac = frac + ((gettime() - self.bar.lastupdatetime) * self.bar.rateofchange);
		if(frac > 1)
		{
			frac = 1;
		}
		if(frac < 0)
		{
			frac = 0;
		}
	}
	return frac;
}

/*
	Name: createprimaryprogressbar
	Namespace: hud
	Checksum: 0x3C4BF479
	Offset: 0x2288
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function createprimaryprogressbar()
{
	bar = createbar((1, 1, 1), level.primaryprogressbarwidth, level.primaryprogressbarheight);
	if(level.splitscreen)
	{
		bar setpoint("TOP", undefined, level.primaryprogressbarx, level.primaryprogressbary);
	}
	else
	{
		bar setpoint("CENTER", undefined, level.primaryprogressbarx, level.primaryprogressbary);
	}
	return bar;
}

/*
	Name: createprimaryprogressbartext
	Namespace: hud
	Checksum: 0x29CCD3D1
	Offset: 0x2330
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function createprimaryprogressbartext()
{
	text = createfontstring("objective", level.primaryprogressbarfontsize);
	if(level.splitscreen)
	{
		text setpoint("TOP", undefined, level.primaryprogressbartextx, level.primaryprogressbartexty);
	}
	else
	{
		text setpoint("CENTER", undefined, level.primaryprogressbartextx, level.primaryprogressbartexty);
	}
	text.sort = -1;
	return text;
}

/*
	Name: createsecondaryprogressbar
	Namespace: hud
	Checksum: 0xBDF11818
	Offset: 0x23E8
	Size: 0x120
	Parameters: 0
	Flags: None
*/
function createsecondaryprogressbar()
{
	secondaryprogressbarheight = getdvarint("scr_secondaryProgressBarHeight", level.secondaryprogressbarheight);
	secondaryprogressbarx = getdvarint("scr_secondaryProgressBarX", level.secondaryprogressbarx);
	secondaryprogressbary = getdvarint("scr_secondaryProgressBarY", level.secondaryprogressbary);
	bar = createbar((1, 1, 1), level.secondaryprogressbarwidth, secondaryprogressbarheight);
	if(level.splitscreen)
	{
		bar setpoint("TOP", undefined, secondaryprogressbarx, secondaryprogressbary);
	}
	else
	{
		bar setpoint("CENTER", undefined, secondaryprogressbarx, secondaryprogressbary);
	}
	return bar;
}

/*
	Name: createsecondaryprogressbartext
	Namespace: hud
	Checksum: 0xFA96E4A8
	Offset: 0x2510
	Size: 0x104
	Parameters: 0
	Flags: None
*/
function createsecondaryprogressbartext()
{
	secondaryprogressbartextx = getdvarint("scr_btx", level.secondaryprogressbartextx);
	secondaryprogressbartexty = getdvarint("scr_bty", level.secondaryprogressbartexty);
	text = createfontstring("objective", level.primaryprogressbarfontsize);
	if(level.splitscreen)
	{
		text setpoint("TOP", undefined, secondaryprogressbartextx, secondaryprogressbartexty);
	}
	else
	{
		text setpoint("CENTER", undefined, secondaryprogressbartextx, secondaryprogressbartexty);
	}
	text.sort = -1;
	return text;
}

/*
	Name: createteamprogressbar
	Namespace: hud
	Checksum: 0xA7E34BD9
	Offset: 0x2620
	Size: 0x70
	Parameters: 1
	Flags: None
*/
function createteamprogressbar(team)
{
	bar = createserverbar((1, 0, 0), level.teamprogressbarwidth, level.teamprogressbarheight, undefined, team);
	bar setpoint("TOP", undefined, 0, level.teamprogressbary);
	return bar;
}

/*
	Name: createteamprogressbartext
	Namespace: hud
	Checksum: 0x2EAB32F8
	Offset: 0x2698
	Size: 0x70
	Parameters: 1
	Flags: None
*/
function createteamprogressbartext(team)
{
	text = createserverfontstring("default", level.teamprogressbarfontsize, team);
	text setpoint("TOP", undefined, 0, level.teamprogressbartexty);
	return text;
}

/*
	Name: setflashfrac
	Namespace: hud
	Checksum: 0xF0C54EBC
	Offset: 0x2710
	Size: 0x20
	Parameters: 1
	Flags: None
*/
function setflashfrac(flashfrac)
{
	self.bar.flashfrac = flashfrac;
}

/*
	Name: hideelem
	Namespace: hud
	Checksum: 0x2841263C
	Offset: 0x2738
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function hideelem()
{
	if(self.hidden)
	{
		return;
	}
	self.hidden = 1;
	if(self.alpha != 0)
	{
		self.alpha = 0;
	}
	if(self.elemtype == "bar" || self.elemtype == "bar_shader")
	{
		self.bar.hidden = 1;
		if(self.bar.alpha != 0)
		{
			self.bar.alpha = 0;
		}
		self.barframe.hidden = 1;
		if(self.barframe.alpha != 0)
		{
			self.barframe.alpha = 0;
		}
	}
}

/*
	Name: showelem
	Namespace: hud
	Checksum: 0x5BB7F40B
	Offset: 0x2818
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function showelem()
{
	if(!self.hidden)
	{
		return;
	}
	self.hidden = 0;
	if(self.elemtype == "bar" || self.elemtype == "bar_shader")
	{
		if(self.alpha != 0.5)
		{
			self.alpha = 0.5;
		}
		self.bar.hidden = 0;
		if(self.bar.alpha != 1)
		{
			self.bar.alpha = 1;
		}
		self.barframe.hidden = 0;
		if(self.barframe.alpha != 1)
		{
			self.barframe.alpha = 1;
		}
	}
	else if(self.alpha != 1)
	{
		self.alpha = 1;
	}
}

/*
	Name: flashthread
	Namespace: hud
	Checksum: 0x9172B9ED
	Offset: 0x2928
	Size: 0xF0
	Parameters: 0
	Flags: None
*/
function flashthread()
{
	self endon(#"death");
	if(!self.hidden)
	{
		self.alpha = 1;
	}
	while(true)
	{
		if(self.frac >= self.flashfrac)
		{
			if(!self.hidden)
			{
				self fadeovertime(0.3);
				self.alpha = 0.2;
				wait(0.35);
				self fadeovertime(0.3);
				self.alpha = 1;
			}
			wait(0.7);
		}
		else
		{
			if(!self.hidden && self.alpha != 1)
			{
				self.alpha = 1;
			}
			wait(0.05);
		}
	}
}

/*
	Name: destroyelem
	Namespace: hud
	Checksum: 0xE278F85
	Offset: 0x2A20
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function destroyelem()
{
	tempchildren = [];
	for(index = 0; index < self.children.size; index++)
	{
		if(isdefined(self.children[index]))
		{
			tempchildren[tempchildren.size] = self.children[index];
		}
	}
	for(index = 0; index < tempchildren.size; index++)
	{
		tempchildren[index] setparent(self getparent());
	}
	if(self.elemtype == "bar" || self.elemtype == "bar_shader")
	{
		self.bar destroy();
		self.barframe destroy();
	}
	self destroy();
}

/*
	Name: seticonshader
	Namespace: hud
	Checksum: 0x58D979D3
	Offset: 0x2B60
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function seticonshader(shader)
{
	self setshader(shader, self.width, self.height);
}

/*
	Name: setwidth
	Namespace: hud
	Checksum: 0x9A6E485
	Offset: 0x2BA0
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function setwidth(width)
{
	self.width = width;
}

/*
	Name: setheight
	Namespace: hud
	Checksum: 0x4299B34
	Offset: 0x2BC0
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function setheight(height)
{
	self.height = height;
}

/*
	Name: setsize
	Namespace: hud
	Checksum: 0x24809C94
	Offset: 0x2BE0
	Size: 0x2C
	Parameters: 2
	Flags: None
*/
function setsize(width, height)
{
	self.width = width;
	self.height = height;
}

/*
	Name: updatechildren
	Namespace: hud
	Checksum: 0x7816C1EA
	Offset: 0x2C18
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function updatechildren()
{
	for(index = 0; index < self.children.size; index++)
	{
		child = self.children[index];
		child setpoint(child.point, child.relativepoint, child.xoffset, child.yoffset);
	}
}

/*
	Name: createloadouticon
	Namespace: hud
	Checksum: 0x4D45072C
	Offset: 0x2CB8
	Size: 0x140
	Parameters: 5
	Flags: Linked
*/
function createloadouticon(player, verindex, horindex, xpos, ypos)
{
	iconsize = 32;
	if(player issplitscreen())
	{
		iconsize = 22;
	}
	ypos = ypos - (90 + (iconsize * (3 - verindex)));
	xpos = xpos - (10 + (iconsize * horindex));
	icon = createicon("white", iconsize, iconsize);
	icon setpoint("BOTTOM RIGHT", "BOTTOM RIGHT", xpos, ypos);
	icon.horzalign = "user_right";
	icon.vertalign = "user_bottom";
	icon.archived = 0;
	icon.foreground = 0;
	return icon;
}

/*
	Name: setloadouticoncoords
	Namespace: hud
	Checksum: 0xB22DA31F
	Offset: 0x2E00
	Size: 0x110
	Parameters: 5
	Flags: Linked
*/
function setloadouticoncoords(player, verindex, horindex, xpos, ypos)
{
	iconsize = 32;
	if(player issplitscreen())
	{
		iconsize = 22;
	}
	ypos = ypos - (90 + (iconsize * (3 - verindex)));
	xpos = xpos - (10 + (iconsize * horindex));
	self setpoint("BOTTOM RIGHT", "BOTTOM RIGHT", xpos, ypos);
	self.horzalign = "user_right";
	self.vertalign = "user_bottom";
	self.archived = 0;
	self.foreground = 0;
	self.alpha = 1;
}

/*
	Name: setloadouttextcoords
	Namespace: hud
	Checksum: 0x40882419
	Offset: 0x2F18
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function setloadouttextcoords(xcoord)
{
	self setpoint("RIGHT", "LEFT", xcoord, 0);
}

/*
	Name: createloadouttext
	Namespace: hud
	Checksum: 0x15F6A718
	Offset: 0x2F58
	Size: 0xD0
	Parameters: 2
	Flags: Linked
*/
function createloadouttext(icon, xcoord)
{
	text = createfontstring("small", 1);
	text setparent(icon);
	text setpoint("RIGHT", "LEFT", xcoord, 0);
	text.archived = 0;
	text.alignx = "right";
	text.aligny = "middle";
	text.foreground = 0;
	return text;
}

/*
	Name: showloadoutattribute
	Namespace: hud
	Checksum: 0x1EE9DA5F
	Offset: 0x3030
	Size: 0xBC
	Parameters: 5
	Flags: Linked
*/
function showloadoutattribute(iconelem, icon, alpha, textelem, text)
{
	iconsize = 32;
	iconelem.alpha = alpha;
	if(alpha)
	{
		iconelem setshader(icon, iconsize, iconsize);
	}
	if(isdefined(textelem))
	{
		textelem.alpha = alpha;
		if(alpha)
		{
			textelem settext(text);
		}
	}
}

/*
	Name: hideloadoutattribute
	Namespace: hud
	Checksum: 0xBC8A9C53
	Offset: 0x30F8
	Size: 0xC8
	Parameters: 4
	Flags: Linked
*/
function hideloadoutattribute(iconelem, fadetime, textelem, hidetextonly)
{
	if(isdefined(fadetime))
	{
		if(!isdefined(hidetextonly) || !hidetextonly)
		{
			iconelem fadeovertime(fadetime);
		}
		if(isdefined(textelem))
		{
			textelem fadeovertime(fadetime);
		}
	}
	if(!isdefined(hidetextonly) || !hidetextonly)
	{
		iconelem.alpha = 0;
	}
	if(isdefined(textelem))
	{
		textelem.alpha = 0;
	}
}

/*
	Name: showperks
	Namespace: hud
	Checksum: 0x62581FB
	Offset: 0x31C8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function showperks()
{
	self luinotifyevent(&"show_perk_notification", 0);
}

/*
	Name: showperk
	Namespace: hud
	Checksum: 0x6AF53447
	Offset: 0x31F8
	Size: 0x2DC
	Parameters: 3
	Flags: None
*/
function showperk(index, perk, ypos)
{
	/#
		assert(game[""] != "");
	#/
	if(!isdefined(self.perkicon))
	{
		self.perkicon = [];
		self.perkname = [];
	}
	if(!isdefined(self.perkicon[index]))
	{
		/#
			assert(!isdefined(self.perkname[index]));
		#/
		self.perkicon[index] = createloadouticon(self, index, 0, 200, ypos);
		self.perkname[index] = createloadouttext(self.perkicon[index], 160);
	}
	else
	{
		self.perkicon[index] setloadouticoncoords(self, index, 0, 200, ypos);
		self.perkname[index] setloadouttextcoords(160);
	}
	if(perk == "perk_null" || perk == "weapon_null" || perk == "specialty_null")
	{
		alpha = 0;
	}
	else
	{
		/#
			assert(isdefined(level.perknames[perk]), perk);
		#/
		alpha = 1;
	}
	showloadoutattribute(self.perkicon[index], perk, alpha, self.perkname[index], level.perknames[perk]);
	self.perkicon[index] moveovertime(0.3);
	self.perkicon[index].x = -5;
	self.perkicon[index].hidewheninmenu = 1;
	self.perkname[index] moveovertime(0.3);
	self.perkname[index].x = -40;
	self.perkname[index].hidewheninmenu = 1;
}

/*
	Name: hideperk
	Namespace: hud
	Checksum: 0xC4457C97
	Offset: 0x34E0
	Size: 0x17C
	Parameters: 3
	Flags: None
*/
function hideperk(index, fadetime = 0.05, hidetextonly)
{
	if(level.perksenabled == 1)
	{
		if(game["state"] == "postgame")
		{
			if(isdefined(self.perkicon))
			{
				/#
					assert(!isdefined(self.perkicon[index]));
				#/
				/#
					assert(!isdefined(self.perkname[index]));
				#/
			}
			return;
		}
		/#
			assert(isdefined(self.perkicon[index]));
		#/
		/#
			assert(isdefined(self.perkname[index]));
		#/
		if(isdefined(self.perkicon) && isdefined(self.perkicon[index]) && isdefined(self.perkname) && isdefined(self.perkname[index]))
		{
			hideloadoutattribute(self.perkicon[index], fadetime, self.perkname[index], hidetextonly);
		}
	}
}

/*
	Name: showkillstreak
	Namespace: hud
	Checksum: 0xE166C355
	Offset: 0x3668
	Size: 0x15C
	Parameters: 4
	Flags: None
*/
function showkillstreak(index, killstreak, xpos, ypos)
{
	/#
		assert(game[""] != "");
	#/
	if(!isdefined(self.killstreakicon))
	{
		self.killstreakicon = [];
	}
	if(!isdefined(self.killstreakicon[index]))
	{
		self.killstreakicon[index] = createloadouticon(self, 3, (self.killstreak.size - 1) - index, xpos, ypos);
	}
	if(killstreak == "killstreak_null" || killstreak == "weapon_null")
	{
		alpha = 0;
	}
	else
	{
		/#
			assert(isdefined(level.killstreakicons[killstreak]), killstreak);
		#/
		alpha = 1;
	}
	showloadoutattribute(self.killstreakicon[index], level.killstreakicons[killstreak], alpha);
}

/*
	Name: hidekillstreak
	Namespace: hud
	Checksum: 0x4F034ED1
	Offset: 0x37D0
	Size: 0xBC
	Parameters: 2
	Flags: None
*/
function hidekillstreak(index, fadetime)
{
	if(util::is_killstreaks_enabled())
	{
		if(game["state"] == "postgame")
		{
			/#
				assert(!isdefined(self.killstreakicon[index]));
			#/
			return;
		}
		/#
			assert(isdefined(self.killstreakicon[index]));
		#/
		hideloadoutattribute(self.killstreakicon[index], fadetime);
	}
}

/*
	Name: setgamemodeinfopoint
	Namespace: hud
	Checksum: 0x32844BC2
	Offset: 0x3898
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function setgamemodeinfopoint()
{
	self.x = 11;
	self.y = 120;
	self.horzalign = "user_left";
	self.vertalign = "user_top";
	self.alignx = "left";
	self.aligny = "top";
}

