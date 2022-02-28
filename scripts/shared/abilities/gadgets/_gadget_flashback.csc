// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_flashback;

/*
	Name: __init__sytem__
	Namespace: _gadget_flashback
	Checksum: 0x5D2A0D9F
	Offset: 0x3A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_flashback", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_flashback
	Checksum: 0x5D4D7917
	Offset: 0x3E0
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "flashback_trail_fx", 1, 1, "int", &set_flashback_trail_fx, 0, 0);
	clientfield::register("playercorpse", "flashback_clone", 1, 1, "int", &clone_flashback_changed, 0, 0);
	clientfield::register("allplayers", "flashback_activated", 1, 1, "int", &flashback_activated, 0, 0);
	visionset_mgr::register_overlay_info_style_postfx_bundle("flashback_warp", 1, 1, "pstfx_flashback_warp", 0.8);
	duplicate_render::set_dr_filter_framebuffer("flashback", 90, "flashback_on", "", 0, "mc/mtl_glitch", 0);
}

/*
	Name: flashback_activated
	Namespace: _gadget_flashback
	Checksum: 0x271CC57E
	Offset: 0x530
	Size: 0x134
	Parameters: 7
	Flags: Linked
*/
function flashback_activated(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self notify(#"player_flashback");
	player = getlocalplayer(localclientnum);
	isfirstperson = !isthirdperson(localclientnum) && player == self;
	if(newval)
	{
		if(isfirstperson)
		{
			self playsound(localclientnum, "mpl_flashback_reappear_plr");
		}
		else
		{
			self endon(#"entityshutdown");
			self util::waittill_dobj(localclientnum);
			self playsound(localclientnum, "mpl_flashback_reappear_npc");
			playtagfxset(localclientnum, "gadget_flashback_3p_off", self);
		}
	}
}

/*
	Name: set_flashback_trail_fx
	Namespace: _gadget_flashback
	Checksum: 0x293D556B
	Offset: 0x670
	Size: 0x174
	Parameters: 7
	Flags: Linked
*/
function set_flashback_trail_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	isfirstperson = !isthirdperson(localclientnum) && isdefined(self.owner) && isdefined(player) && self.owner == player;
	if(newval)
	{
		if(isfirstperson)
		{
			player playsound(localclientnum, "mpl_flashback_disappear_plr");
		}
		else
		{
			self endon(#"entityshutdown");
			self util::waittill_dobj(localclientnum);
			self playsound(localclientnum, "mpl_flashback_disappear_npc");
			playfxontag(localclientnum, "player/fx_plyr_flashback_demat", self, "tag_origin");
			playfxontag(localclientnum, "player/fx_plyr_flashback_trail", self, "tag_origin");
		}
	}
}

/*
	Name: clone_flashback_changed
	Namespace: _gadget_flashback
	Checksum: 0xD2C1EFEA
	Offset: 0x7F0
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function clone_flashback_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self clone_flashback_changed_event(localclientnum, newval);
	}
}

/*
	Name: clone_fade
	Namespace: _gadget_flashback
	Checksum: 0xD789A522
	Offset: 0x860
	Size: 0x13C
	Parameters: 1
	Flags: Linked
*/
function clone_fade(localclientnum)
{
	self endon(#"entityshutdown");
	starttime = getservertime(localclientnum);
	while(true)
	{
		currenttime = getservertime(localclientnum);
		elapsedtime = currenttime - starttime;
		elapsedtime = float(elapsedtime / 1000);
		if(elapsedtime < 1)
		{
			amount = 1 - (elapsedtime / 1);
			self mapshaderconstant(localclientnum, 0, "scriptVector3", 1, 1, 0, amount);
		}
		else
		{
			self mapshaderconstant(localclientnum, 0, "scriptVector3", 1, 1, 0, 0);
			break;
		}
		wait(0.016);
	}
}

/*
	Name: clone_flashback_changed_event
	Namespace: _gadget_flashback
	Checksum: 0x35D10CE2
	Offset: 0x9A8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function clone_flashback_changed_event(localclientnum, armorstatusnew)
{
	if(armorstatusnew)
	{
		self duplicate_render::set_dr_flag("flashback_on", 1);
		self duplicate_render::update_dr_filters(localclientnum);
		self clone_fade(localclientnum);
	}
}

