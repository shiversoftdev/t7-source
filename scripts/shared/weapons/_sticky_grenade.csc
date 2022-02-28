// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace sticky_grenade;

/*
	Name: __init__sytem__
	Namespace: sticky_grenade
	Checksum: 0x2F7CBAF1
	Offset: 0x1F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("sticky_grenade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: sticky_grenade
	Checksum: 0x550C155C
	Offset: 0x238
	Size: 0x44
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level._effect["grenade_light"] = "weapon/fx_equip_light_os";
	callback::add_weapon_type("sticky_grenade", &spawned);
}

/*
	Name: spawned
	Namespace: sticky_grenade
	Checksum: 0x90778741
	Offset: 0x288
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function spawned(localclientnum)
{
	if(self isgrenadedud())
	{
		return;
	}
	self thread fx_think(localclientnum);
}

/*
	Name: stop_sound_on_ent_shutdown
	Namespace: sticky_grenade
	Checksum: 0xC914722A
	Offset: 0x2D8
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function stop_sound_on_ent_shutdown(handle)
{
	self waittill(#"entityshutdown");
	stopsound(handle);
}

/*
	Name: fx_think
	Namespace: sticky_grenade
	Checksum: 0xA452FDC0
	Offset: 0x310
	Size: 0x20C
	Parameters: 1
	Flags: None
*/
function fx_think(localclientnum)
{
	self notify(#"light_disable");
	self endon(#"light_disable");
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	handle = self playsound(localclientnum, "wpn_semtex_countdown");
	self thread stop_sound_on_ent_shutdown(handle);
	interval = 0.3;
	for(;;)
	{
		self stop_light_fx(localclientnum);
		localplayer = getlocalplayer(localclientnum);
		if(!localplayer isentitylinkedtotag(self, "j_head") && !localplayer isentitylinkedtotag(self, "j_elbow_le") && !localplayer isentitylinkedtotag(self, "j_spineupper"))
		{
			self start_light_fx(localclientnum);
		}
		self fullscreen_fx(localclientnum);
		util::server_wait(localclientnum, interval, 0.01, "player_switch");
		self util::waittill_dobj(localclientnum);
		interval = math::clamp(interval / 1.2, 0.08, 0.3);
	}
}

/*
	Name: start_light_fx
	Namespace: sticky_grenade
	Checksum: 0x1E1CD13D
	Offset: 0x528
	Size: 0x6C
	Parameters: 1
	Flags: None
*/
function start_light_fx(localclientnum)
{
	player = getlocalplayer(localclientnum);
	self.fx = playfxontag(localclientnum, level._effect["grenade_light"], self, "tag_fx");
}

/*
	Name: stop_light_fx
	Namespace: sticky_grenade
	Checksum: 0x42AB7A2C
	Offset: 0x5A0
	Size: 0x4E
	Parameters: 1
	Flags: None
*/
function stop_light_fx(localclientnum)
{
	if(isdefined(self.fx) && self.fx != 0)
	{
		stopfx(localclientnum, self.fx);
		self.fx = undefined;
	}
}

/*
	Name: sticky_indicator
	Namespace: sticky_grenade
	Checksum: 0x98E7F689
	Offset: 0x5F8
	Size: 0xD4
	Parameters: 2
	Flags: None
*/
function sticky_indicator(player, localclientnum)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	stickyimagemodel = createuimodel(controllermodel, "hudItems.stickyImage");
	setuimodelvalue(stickyimagemodel, "hud_icon_stuck_semtex");
	player thread stick_indicator_watch_early_shutdown(stickyimagemodel);
	while(isdefined(self))
	{
		wait(0.016);
	}
	setuimodelvalue(stickyimagemodel, "blacktransparent");
	player notify(#"sticky_shutdown");
}

/*
	Name: stick_indicator_watch_early_shutdown
	Namespace: sticky_grenade
	Checksum: 0xCA91A046
	Offset: 0x6D8
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function stick_indicator_watch_early_shutdown(stickyimagemodel)
{
	self endon(#"sticky_shutdown");
	self endon(#"entityshutdown");
	self waittill(#"player_flashback");
	setuimodelvalue(stickyimagemodel, "blacktransparent");
}

/*
	Name: fullscreen_fx
	Namespace: sticky_grenade
	Checksum: 0x2D0EE09B
	Offset: 0x730
	Size: 0x12C
	Parameters: 1
	Flags: None
*/
function fullscreen_fx(localclientnum)
{
	player = getlocalplayer(localclientnum);
	if(isdefined(player))
	{
		if(player getinkillcam(localclientnum))
		{
			return;
		}
		if(player util::is_player_view_linked_to_entity(localclientnum))
		{
			return;
		}
	}
	if(self isfriendly(localclientnum))
	{
		return;
	}
	parent = self getparententity();
	if(isdefined(parent) && parent == player)
	{
		parent playrumbleonentity(localclientnum, "buzz_high");
		if(getdvarint("ui_hud_hardcore") == 0)
		{
			self thread sticky_indicator(player, localclientnum);
		}
	}
}

