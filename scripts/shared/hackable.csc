// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace hackable;

/*
	Name: __init__sytem__
	Namespace: hackable
	Checksum: 0xE1CDF26E
	Offset: 0x170
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hackable", &init, undefined, undefined);
}

/*
	Name: init
	Namespace: hackable
	Checksum: 0x1ADAF659
	Offset: 0x1B0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function init()
{
	callback::on_localclient_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: hackable
	Checksum: 0x71B76B02
	Offset: 0x1E0
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function on_player_connect(localclientnum)
{
	duplicate_render::set_dr_filter_offscreen("hacking", 75, "being_hacked", undefined, 2, "mc/hud_keyline_orange", 1);
}

/*
	Name: set_hacked_ent
	Namespace: hackable
	Checksum: 0xEC346A6D
	Offset: 0x230
	Size: 0x94
	Parameters: 2
	Flags: None
*/
function set_hacked_ent(local_client_num, ent)
{
	if(!ent === self.hacked_ent)
	{
		if(isdefined(self.hacked_ent))
		{
			self.hacked_ent duplicate_render::change_dr_flags(local_client_num, undefined, "being_hacked");
		}
		self.hacked_ent = ent;
		if(isdefined(self.hacked_ent))
		{
			self.hacked_ent duplicate_render::change_dr_flags(local_client_num, "being_hacked", undefined);
		}
	}
}

