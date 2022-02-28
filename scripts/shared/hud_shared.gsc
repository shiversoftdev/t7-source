// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\system_shared;

#namespace hud;

/*
	Name: __init__sytem__
	Namespace: hud
	Checksum: 0xACBA1B15
	Offset: 0x128
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hud", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: hud
	Checksum: 0x67B6B5B9
	Offset: 0x168
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_start_gametype(&init);
}

/*
	Name: init
	Namespace: hud
	Checksum: 0xCEA92629
	Offset: 0x198
	Size: 0x384
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.uiparent = spawnstruct();
	level.uiparent.horzalign = "left";
	level.uiparent.vertalign = "top";
	level.uiparent.alignx = "left";
	level.uiparent.aligny = "top";
	level.uiparent.x = 0;
	level.uiparent.y = 0;
	level.uiparent.width = 0;
	level.uiparent.height = 0;
	level.uiparent.children = [];
	level.fontheight = 12;
	foreach(team in level.teams)
	{
		level.hud[team] = spawnstruct();
	}
	level.primaryprogressbary = -61;
	level.primaryprogressbarx = 0;
	level.primaryprogressbarheight = 9;
	level.primaryprogressbarwidth = 120;
	level.primaryprogressbartexty = -75;
	level.primaryprogressbartextx = 0;
	level.primaryprogressbarfontsize = 1.4;
	if(level.splitscreen)
	{
		level.primaryprogressbarx = 20;
		level.primaryprogressbartextx = 20;
		level.primaryprogressbary = 15;
		level.primaryprogressbartexty = 0;
		level.primaryprogressbarheight = 2;
	}
	level.secondaryprogressbary = -85;
	level.secondaryprogressbarx = 0;
	level.secondaryprogressbarheight = 9;
	level.secondaryprogressbarwidth = 120;
	level.secondaryprogressbartexty = -100;
	level.secondaryprogressbartextx = 0;
	level.secondaryprogressbarfontsize = 1.4;
	if(level.splitscreen)
	{
		level.secondaryprogressbarx = 20;
		level.secondaryprogressbartextx = 20;
		level.secondaryprogressbary = 15;
		level.secondaryprogressbartexty = 0;
		level.secondaryprogressbarheight = 2;
	}
	level.teamprogressbary = 32;
	level.teamprogressbarheight = 14;
	level.teamprogressbarwidth = 192;
	level.teamprogressbartexty = 8;
	level.teamprogressbarfontsize = 1.65;
	setdvar("ui_generic_status_bar", 0);
	if(level.splitscreen)
	{
		level.lowertextyalign = "BOTTOM";
		level.lowertexty = -42;
		level.lowertextfontsize = 1.4;
	}
	else
	{
		level.lowertextyalign = "CENTER";
		level.lowertexty = 40;
		level.lowertextfontsize = 1.4;
	}
}

/*
	Name: font_pulse_init
	Namespace: hud
	Checksum: 0x1D41364
	Offset: 0x528
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function font_pulse_init()
{
	self.basefontscale = self.fontscale;
	self.maxfontscale = self.fontscale * 2;
	self.inframes = 1.5;
	self.outframes = 3;
}

/*
	Name: font_pulse
	Namespace: hud
	Checksum: 0x225808C6
	Offset: 0x578
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function font_pulse(player)
{
	self notify(#"fontpulse");
	self endon(#"fontpulse");
	self endon(#"death");
	player endon(#"disconnect");
	player endon(#"joined_team");
	player endon(#"joined_spectators");
	if(self.outframes == 0)
	{
		self.fontscale = 0.01;
	}
	else
	{
		self.fontscale = self.fontscale;
	}
	if(self.inframes > 0)
	{
		self changefontscaleovertime(self.inframes * 0.05);
		self.fontscale = self.maxfontscale;
		wait(self.inframes * 0.05);
	}
	else
	{
		self.fontscale = self.maxfontscale;
		self.alpha = 0;
		self fadeovertime(self.outframes * 0.05);
		self.alpha = 1;
	}
	if(self.outframes > 0)
	{
		self changefontscaleovertime(self.outframes * 0.05);
		self.fontscale = self.basefontscale;
	}
}

/*
	Name: fade_to_black_for_x_sec
	Namespace: hud
	Checksum: 0x2D9AF48C
	Offset: 0x6F8
	Size: 0x74
	Parameters: 5
	Flags: Linked
*/
function fade_to_black_for_x_sec(startwait, blackscreenwait, fadeintime, fadeouttime, shadername)
{
	self endon(#"disconnect");
	wait(startwait);
	lui::screen_fade_out(fadeintime, shadername);
	wait(blackscreenwait);
	lui::screen_fade_in(fadeouttime, shadername);
}

/*
	Name: screen_fade_in
	Namespace: hud
	Checksum: 0xC469113F
	Offset: 0x778
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function screen_fade_in(fadeintime)
{
	lui::screen_fade_in(fadeintime);
}

