// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace _gadget_unstoppable_force;

/*
	Name: __init__sytem__
	Namespace: _gadget_unstoppable_force
	Checksum: 0x8A3AC9EB
	Offset: 0x400
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_unstoppable_force", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_unstoppable_force
	Checksum: 0x696B3347
	Offset: 0x440
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_localclient_shutdown(&on_localplayer_shutdown);
	clientfield::register("toplayer", "unstoppableforce_state", 1, 1, "int", &player_unstoppableforce_handler, 0, 1);
}

/*
	Name: on_localplayer_shutdown
	Namespace: _gadget_unstoppable_force
	Checksum: 0x4601B7B
	Offset: 0x4B8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_shutdown(localclientnum)
{
	stop_boost_camera_fx(localclientnum);
}

/*
	Name: player_unstoppableforce_handler
	Namespace: _gadget_unstoppable_force
	Checksum: 0xD388CBA4
	Offset: 0x4E8
	Size: 0x202
	Parameters: 7
	Flags: Linked
*/
function player_unstoppableforce_handler(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!self islocalplayer() || isspectating(localclientnum, 0) || (isdefined(level.localplayers[localclientnum]) && self getentitynumber() != level.localplayers[localclientnum] getentitynumber()))
	{
		return;
	}
	if(newval != oldval && newval)
	{
		enablespeedblur(localclientnum, getdvarfloat("scr_unstoppableforce_amount", 0.15), getdvarfloat("scr_unstoppableforce_inner_radius", 0.6), getdvarfloat("scr_unstoppableforce_outer_radius", 1), getdvarint("scr_unstoppableforce_velShouldScale", 1), getdvarint("scr_unstoppableforce_velScale", 220));
		self thread activation_flash(localclientnum);
		self boost_fx_on_velocity(localclientnum);
	}
	else if(newval != oldval && !newval)
	{
		self stop_boost_camera_fx(localclientnum);
		disablespeedblur(localclientnum);
		self notify(#"end_unstoppableforce_boost_fx");
	}
}

/*
	Name: activation_flash
	Namespace: _gadget_unstoppable_force
	Checksum: 0x3F45A0BA
	Offset: 0x6F8
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function activation_flash(localclientnum)
{
	self util::waittill_any_timeout(getdvarfloat("scr_unstoppableforce_activation_delay", 0.35), "unstoppableforce_arm_cross_end");
	lui::screen_fade(getdvarfloat("scr_unstoppableforce_flash_fade_in_time", 0.075), getdvarfloat("scr_unstoppableforce_flash_alpha", 0.6), 0, "white");
	wait(getdvarfloat("scr_unstoppableforce_flash_fade_in_time", 0.075));
	lui::screen_fade(getdvarfloat("scr_unstoppableforce_flash_fade_out_time", 0.9), 0, getdvarfloat("scr_unstoppableforce_flash_alpha", 0.6), "white");
}

/*
	Name: enable_boost_camera_fx
	Namespace: _gadget_unstoppable_force
	Checksum: 0x36D6BD01
	Offset: 0x820
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function enable_boost_camera_fx(localclientnum)
{
	self.firstperson_fx_unstoppableforce = playfxoncamera(localclientnum, "player/fx_plyr_ability_screen_blur_overdrive", (0, 0, 0), (1, 0, 0), (0, 0, 1));
}

/*
	Name: stop_boost_camera_fx
	Namespace: _gadget_unstoppable_force
	Checksum: 0xAD92A861
	Offset: 0x868
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function stop_boost_camera_fx(localclientnum)
{
	if(isdefined(self.firstperson_fx_unstoppableforce))
	{
		stopfx(localclientnum, self.firstperson_fx_unstoppableforce);
		self.firstperson_fx_unstoppableforce = undefined;
	}
}

/*
	Name: boost_fx_interrupt_handler
	Namespace: _gadget_unstoppable_force
	Checksum: 0xD6D4FAB3
	Offset: 0x8B0
	Size: 0x62
	Parameters: 1
	Flags: Linked
*/
function boost_fx_interrupt_handler(localclientnum)
{
	self endon(#"end_unstoppableforce_boost_fx");
	self util::waittill_any("disable_cybercom", "death");
	stop_boost_camera_fx(localclientnum);
	self notify(#"end_unstoppableforce_boost_fx");
}

/*
	Name: boost_fx_on_velocity
	Namespace: _gadget_unstoppable_force
	Checksum: 0xB760393A
	Offset: 0x920
	Size: 0x190
	Parameters: 1
	Flags: Linked
*/
function boost_fx_on_velocity(localclientnum)
{
	self endon(#"disable_cybercom");
	self endon(#"death");
	self endon(#"end_unstoppableforce_boost_fx");
	self endon(#"disconnect");
	self thread boost_fx_interrupt_handler(localclientnum);
	while(isdefined(self))
	{
		v_player_velocity = self getvelocity();
		v_player_forward = anglestoforward(self.angles);
		n_dot = vectordot(vectornormalize(v_player_velocity), v_player_forward);
		n_speed = length(v_player_velocity);
		if(n_speed >= getdvarint("scr_unstoppableforce_boost_speed_tol", 320) && n_dot > 0.8)
		{
			if(!isdefined(self.firstperson_fx_unstoppableforce))
			{
				self enable_boost_camera_fx(localclientnum);
			}
		}
		else if(isdefined(self.firstperson_fx_unstoppableforce))
		{
			self stop_boost_camera_fx(localclientnum);
		}
		wait(0.016);
	}
}

