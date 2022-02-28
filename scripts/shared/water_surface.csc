// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace water_surface;

/*
	Name: __init__sytem__
	Namespace: water_surface
	Checksum: 0xE5937B7
	Offset: 0x1C8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("water_surface", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: water_surface
	Checksum: 0xF3D74054
	Offset: 0x208
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["water_player_jump_in"] = "player/fx_plyr_water_jump_in_bubbles_1p";
	level._effect["water_player_jump_out"] = "player/fx_plyr_water_jump_out_splash_1p";
	if(isdefined(level.disablewatersurfacefx) && level.disablewatersurfacefx == 1)
	{
		return;
	}
	callback::on_localplayer_spawned(&localplayer_spawned);
}

/*
	Name: localplayer_spawned
	Namespace: water_surface
	Checksum: 0xCAB3EFF
	Offset: 0x290
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function localplayer_spawned(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	if(isdefined(level.disablewatersurfacefx) && level.disablewatersurfacefx == 1)
	{
		return;
	}
	filter::init_filter_water_sheeting(self);
	filter::init_filter_water_dive(self);
	self thread underwaterwatchbegin();
	self thread underwaterwatchend();
	filter::disable_filter_water_sheeting(self, 1);
	stop_player_fx(self);
}

/*
	Name: underwaterwatchbegin
	Namespace: water_surface
	Checksum: 0x68B8F1F0
	Offset: 0x370
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function underwaterwatchbegin()
{
	self notify(#"underwaterwatchbegin");
	self endon(#"underwaterwatchbegin");
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"underwater_begin", teleported);
		if(teleported)
		{
			filter::disable_filter_water_sheeting(self, 1);
			stop_player_fx(self);
			filter::disable_filter_water_dive(self, 1);
			stop_player_fx(self);
		}
		else
		{
			self thread underwaterbegin();
		}
	}
}

/*
	Name: underwaterwatchend
	Namespace: water_surface
	Checksum: 0xA38AC746
	Offset: 0x448
	Size: 0xD0
	Parameters: 0
	Flags: Linked
*/
function underwaterwatchend()
{
	self notify(#"underwaterwatchend");
	self endon(#"underwaterwatchend");
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"underwater_end", teleported);
		if(teleported)
		{
			filter::disable_filter_water_sheeting(self, 1);
			stop_player_fx(self);
			filter::disable_filter_water_dive(self, 1);
			stop_player_fx(self);
		}
		else
		{
			self thread underwaterend();
		}
	}
}

/*
	Name: underwaterbegin
	Namespace: water_surface
	Checksum: 0xF4984DE9
	Offset: 0x520
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function underwaterbegin()
{
	self notify(#"water_surface_underwater_begin");
	self endon(#"water_surface_underwater_begin");
	self endon(#"entityshutdown");
	localclientnum = self getlocalclientnumber();
	filter::disable_filter_water_sheeting(self, 1);
	stop_player_fx(self);
	if(islocalclientdead(localclientnum) == 0)
	{
		self.firstperson_water_fx = playfxoncamera(localclientnum, level._effect["water_player_jump_in"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
		if(!isdefined(self.playingpostfxbundle) || self.playingpostfxbundle != "pstfx_watertransition")
		{
			self thread postfx::playpostfxbundle("pstfx_watertransition");
		}
	}
}

/*
	Name: underwaterend
	Namespace: water_surface
	Checksum: 0xD40A9332
	Offset: 0x640
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function underwaterend()
{
	self notify(#"water_surface_underwater_end");
	self endon(#"water_surface_underwater_end");
	self endon(#"entityshutdown");
	localclientnum = self getlocalclientnumber();
	if(islocalclientdead(localclientnum) == 0)
	{
		if(!isdefined(self.playingpostfxbundle) || self.playingpostfxbundle != "pstfx_water_t_out")
		{
			self thread postfx::playpostfxbundle("pstfx_water_t_out");
		}
	}
}

/*
	Name: startwaterdive
	Namespace: water_surface
	Checksum: 0x4F941D8D
	Offset: 0x6F0
	Size: 0x24A
	Parameters: 0
	Flags: None
*/
function startwaterdive()
{
	filter::enable_filter_water_dive(self, 1);
	filter::set_filter_water_scuba_dive_speed(self, 1, 0.25);
	filter::set_filter_water_wash_color(self, 1, 0.16, 0.5, 0.9);
	filter::set_filter_water_wash_reveal_dir(self, 1, -1);
	i = 0;
	while(i < 0.05)
	{
		filter::set_filter_water_dive_bubbles(self, 1, i / 0.05);
		wait(0.01);
		i = i + 0.01;
	}
	filter::set_filter_water_dive_bubbles(self, 1, 1);
	filter::set_filter_water_scuba_bubble_attitude(self, 1, -1);
	filter::set_filter_water_scuba_bubbles(self, 1, 1);
	filter::set_filter_water_wash_reveal_dir(self, 1, 1);
	i = 0.2;
	while(i > 0)
	{
		filter::set_filter_water_dive_bubbles(self, 1, i / 0.2);
		wait(0.01);
		i = i - 0.01;
	}
	filter::set_filter_water_dive_bubbles(self, 1, 0);
	wait(0.1);
	i = 0.2;
	while(i > 0)
	{
		filter::set_filter_water_scuba_bubbles(self, 1, i / 0.2);
		wait(0.01);
		i = i - 0.01;
	}
}

/*
	Name: startwatersheeting
	Namespace: water_surface
	Checksum: 0x8E79A9E6
	Offset: 0x948
	Size: 0x214
	Parameters: 0
	Flags: None
*/
function startwatersheeting()
{
	self notify(#"startwatersheeting_singleton");
	self endon(#"startwatersheeting_singleton");
	self endon(#"entityshutdown");
	filter::enable_filter_water_sheeting(self, 1);
	filter::set_filter_water_sheet_reveal(self, 1, 1);
	filter::set_filter_water_sheet_speed(self, 1, 1);
	i = 2;
	while(i > 0)
	{
		filter::set_filter_water_sheet_reveal(self, 1, i / 2);
		filter::set_filter_water_sheet_speed(self, 1, i / 2);
		rivulet1 = (i / 2) - 0.19;
		rivulet2 = (i / 2) - 0.13;
		rivulet3 = (i / 2) - 0.07;
		filter::set_filter_water_sheet_rivulet_reveal(self, 1, rivulet1, rivulet2, rivulet3);
		wait(0.01);
		i = i - 0.01;
	}
	filter::set_filter_water_sheet_reveal(self, 1, 0);
	filter::set_filter_water_sheet_speed(self, 1, 0);
	filter::set_filter_water_sheet_rivulet_reveal(self, 1, 0, 0, 0);
}

/*
	Name: stop_player_fx
	Namespace: water_surface
	Checksum: 0x3A588FE3
	Offset: 0xB68
	Size: 0x72
	Parameters: 1
	Flags: Linked
*/
function stop_player_fx(localclient)
{
	if(isdefined(localclient.firstperson_water_fx))
	{
		localclientnum = localclient getlocalclientnumber();
		stopfx(localclientnum, localclient.firstperson_water_fx);
		localclient.firstperson_water_fx = undefined;
	}
}

