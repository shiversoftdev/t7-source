// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace replay_gun;

/*
	Name: __init__sytem__
	Namespace: replay_gun
	Checksum: 0x2FA347FC
	Offset: 0x1C0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("replay_gun", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: replay_gun
	Checksum: 0xC7683596
	Offset: 0x200
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level thread player_init();
	duplicate_render::set_dr_filter_offscreen("replay", 75, "replay_locked", undefined, 2, "mc/hud_outline_model_red", 0);
}

/*
	Name: player_init
	Namespace: replay_gun
	Checksum: 0x22F3E668
	Offset: 0x258
	Size: 0xC2
	Parameters: 0
	Flags: Linked
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
	Namespace: replay_gun
	Checksum: 0xD0EDC5DC
	Offset: 0x328
	Size: 0x176
	Parameters: 1
	Flags: Linked
*/
function watch_lockon(localclientnum)
{
	while(true)
	{
		self waittill(#"lockon_changed", state, target);
		if(isdefined(self.replay_lock) && (!isdefined(target) || self.replay_lock != target))
		{
			self.replay_lock duplicate_render::change_dr_flags(localclientnum, undefined, "replay_locked");
			self.replay_lock = undefined;
		}
		if(isdefined(target) && (target isplayer() || target isai()) && isalive(target))
		{
			switch(state)
			{
				case 0:
				case 1:
				case 3:
				{
					target duplicate_render::change_dr_flags(localclientnum, undefined, "replay_locked");
					break;
				}
				case 2:
				case 4:
				{
					target duplicate_render::change_dr_flags(localclientnum, "replay_locked", undefined);
					self.replay_lock = target;
					break;
				}
			}
		}
	}
}

