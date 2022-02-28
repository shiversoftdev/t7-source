// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace antipersonnel_guidance;

/*
	Name: __init__sytem__
	Namespace: antipersonnel_guidance
	Checksum: 0x391D5CDF
	Offset: 0x1D0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("antipersonnel_guidance", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: antipersonnel_guidance
	Checksum: 0xF734480
	Offset: 0x210
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level thread player_init();
	duplicate_render::set_dr_filter_offscreen("ap", 75, "ap_locked", undefined, 2, "mc/hud_outline_model_red", 0);
}

/*
	Name: player_init
	Namespace: antipersonnel_guidance
	Checksum: 0x3D39523A
	Offset: 0x268
	Size: 0xC2
	Parameters: 0
	Flags: None
*/
function player_init()
{
	util::waitforclient(0);
	players = getlocalplayers();
	foreach(player in players)
	{
		player thread watch_lockon(0);
	}
}

/*
	Name: watch_lockon
	Namespace: antipersonnel_guidance
	Checksum: 0x52DEE59B
	Offset: 0x338
	Size: 0x126
	Parameters: 1
	Flags: None
*/
function watch_lockon(localclientnum)
{
	while(true)
	{
		self waittill(#"lockon_changed", state, target);
		if(isdefined(self.replay_lock) && (!isdefined(target) || self.replay_lock != target))
		{
			self.ap_lock duplicate_render::change_dr_flags(localclientnum, undefined, "ap_locked");
			self.ap_lock = undefined;
		}
		switch(state)
		{
			case 0:
			case 1:
			case 3:
			{
				target duplicate_render::change_dr_flags(localclientnum, undefined, "ap_locked");
				break;
			}
			case 2:
			case 4:
			{
				target duplicate_render::change_dr_flags(localclientnum, "ap_locked", undefined);
				self.ap_lock = target;
				break;
			}
		}
	}
}

