// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_overdrive;

/*
	Name: __init__sytem__
	Namespace: _gadget_overdrive
	Checksum: 0xA4D5624
	Offset: 0x3F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_overdrive", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_overdrive
	Checksum: 0x6C8159D9
	Offset: 0x438
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_localclient_connect(&on_player_connect);
	callback::on_localplayer_spawned(&on_localplayer_spawned);
	callback::on_localclient_shutdown(&on_localplayer_shutdown);
	clientfield::register("toplayer", "overdrive_state", 1, 1, "int", &player_overdrive_handler, 0, 1);
	visionset_mgr::register_visionset_info("overdrive", 1, 15, undefined, "overdrive_initialize");
}

/*
	Name: on_localplayer_shutdown
	Namespace: _gadget_overdrive
	Checksum: 0x987D8DE2
	Offset: 0x518
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_shutdown(localclientnum)
{
	self overdrive_shutdown(localclientnum);
}

/*
	Name: on_localplayer_spawned
	Namespace: _gadget_overdrive
	Checksum: 0x1F8814C4
	Offset: 0x548
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_spawned(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	filter::init_filter_overdrive(self);
	filter::disable_filter_overdrive(self, 3);
	disablespeedblur(localclientnum);
}

/*
	Name: on_player_connect
	Namespace: _gadget_overdrive
	Checksum: 0x47F48451
	Offset: 0x5C0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function on_player_connect(local_client_num)
{
}

/*
	Name: player_overdrive_handler
	Namespace: _gadget_overdrive
	Checksum: 0x3A5806B7
	Offset: 0x5D8
	Size: 0x20C
	Parameters: 7
	Flags: Linked
*/
function player_overdrive_handler(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!self islocalplayer() || isspectating(localclientnum, 0) || (isdefined(level.localplayers[localclientnum]) && self getentitynumber() != level.localplayers[localclientnum] getentitynumber()))
	{
		return;
	}
	if(newval != oldval && newval)
	{
		enablespeedblur(localclientnum, getdvarfloat("scr_overdrive_amount", 0.15), getdvarfloat("scr_overdrive_inner_radius", 0.6), getdvarfloat("scr_overdrive_outer_radius", 1), getdvarint("scr_overdrive_velShouldScale", 1), getdvarint("scr_overdrive_velScale", 220));
		filter::enable_filter_overdrive(self, 3);
		self usealternateaimparams();
		self thread activation_flash(localclientnum);
		self boost_fx_on_velocity(localclientnum);
	}
	else if(newval != oldval && !newval)
	{
		self overdrive_shutdown(localclientnum);
	}
}

/*
	Name: activation_flash
	Namespace: _gadget_overdrive
	Checksum: 0xD920F6E5
	Offset: 0x7F0
	Size: 0x146
	Parameters: 1
	Flags: Linked
*/
function activation_flash(localclientnum)
{
	self notify(#"activation_flash");
	self endon(#"activation_flash");
	self endon(#"death");
	self endon(#"entityshutdown");
	self endon(#"stop_player_fx");
	self endon(#"disable_cybercom");
	self.whiteflashfade = 1;
	lui::screen_fade(getdvarfloat("scr_overdrive_flash_fade_in_time", 0.075), getdvarfloat("scr_overdrive_flash_alpha", 0.7), 0, "white");
	wait(getdvarfloat("scr_overdrive_flash_fade_in_time", 0.075));
	lui::screen_fade(getdvarfloat("scr_overdrive_flash_fade_out_time", 0.45), 0, getdvarfloat("scr_overdrive_flash_alpha", 0.7), "white");
	self.whiteflashfade = undefined;
}

/*
	Name: enable_boost_camera_fx
	Namespace: _gadget_overdrive
	Checksum: 0xD6D4C26B
	Offset: 0x940
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function enable_boost_camera_fx(localclientnum)
{
	if(isdefined(self.firstperson_fx_overdrive))
	{
		stopfx(localclientnum, self.firstperson_fx_overdrive);
		self.firstperson_fx_overdrive = undefined;
	}
	self.firstperson_fx_overdrive = playfxoncamera(localclientnum, "player/fx_plyr_ability_screen_blur_overdrive", (0, 0, 0), (1, 0, 0), (0, 0, 1));
	self thread watch_stop_player_fx(localclientnum, self.firstperson_fx_overdrive);
}

/*
	Name: watch_stop_player_fx
	Namespace: _gadget_overdrive
	Checksum: 0xEEF4F843
	Offset: 0x9D8
	Size: 0x96
	Parameters: 2
	Flags: Linked
*/
function watch_stop_player_fx(localclientnum, fx)
{
	self notify(#"watch_stop_player_fx");
	self endon(#"watch_stop_player_fx");
	self endon(#"entityshutdown");
	self util::waittill_any("stop_player_fx", "death", "disable_cybercom");
	if(isdefined(fx))
	{
		stopfx(localclientnum, fx);
		self.firstperson_fx_overdrive = undefined;
	}
}

/*
	Name: stop_boost_camera_fx
	Namespace: _gadget_overdrive
	Checksum: 0x48452796
	Offset: 0xA78
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function stop_boost_camera_fx(localclientnum)
{
	self notify(#"stop_player_fx");
	if(isdefined(self.whiteflashfade) && self.whiteflashfade)
	{
		lui::screen_fade(getdvarfloat("scr_overdrive_flash_fade_out_time", 0.45), 0, getdvarfloat("scr_overdrive_flash_alpha", 0.7), "white");
	}
}

/*
	Name: overdrive_boost_fx_interrupt_handler
	Namespace: _gadget_overdrive
	Checksum: 0xA37AFB7D
	Offset: 0xB10
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function overdrive_boost_fx_interrupt_handler(localclientnum)
{
	self endon(#"overdrive_boost_fx_interrupt_handler");
	self endon(#"end_overdrive_boost_fx");
	self endon(#"entityshutdown");
	self util::waittill_any("death", "disable_cybercom");
	self overdrive_shutdown(localclientnum);
}

/*
	Name: overdrive_shutdown
	Namespace: _gadget_overdrive
	Checksum: 0xC8707E66
	Offset: 0xB88
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function overdrive_shutdown(localclientnum)
{
	if(isdefined(localclientnum))
	{
		self stop_boost_camera_fx(localclientnum);
		self clearalternateaimparams();
		filter::disable_filter_overdrive(self, 3);
		disablespeedblur(localclientnum);
		self notify(#"end_overdrive_boost_fx");
	}
}

/*
	Name: boost_fx_on_velocity
	Namespace: _gadget_overdrive
	Checksum: 0x924A16FF
	Offset: 0xC18
	Size: 0x1C8
	Parameters: 1
	Flags: Linked
*/
function boost_fx_on_velocity(localclientnum)
{
	self endon(#"disable_cybercom");
	self endon(#"death");
	self endon(#"end_overdrive_boost_fx");
	self endon(#"disconnect");
	self enable_boost_camera_fx(localclientnum);
	self thread overdrive_boost_fx_interrupt_handler(localclientnum);
	wait(getdvarfloat("scr_overdrive_boost_fx_time", 0.75));
	while(isdefined(self))
	{
		v_player_velocity = self getvelocity();
		v_player_forward = anglestoforward(self.angles);
		n_dot = vectordot(vectornormalize(v_player_velocity), v_player_forward);
		n_speed = length(v_player_velocity);
		if(n_speed >= getdvarint("scr_overdrive_boost_speed_tol", 280) && n_dot > 0.8)
		{
			if(!isdefined(self.firstperson_fx_overdrive))
			{
				self enable_boost_camera_fx(localclientnum);
			}
		}
		else if(isdefined(self.firstperson_fx_overdrive))
		{
			self stop_boost_camera_fx(localclientnum);
		}
		wait(0.016);
	}
}

