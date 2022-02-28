// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace zm_stalingrad_eye_beam_trap;

/*
	Name: __init__sytem__
	Namespace: zm_stalingrad_eye_beam_trap
	Checksum: 0x4EE396EE
	Offset: 0x228
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_stalingrad_eye_beam_trap", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_stalingrad_eye_beam_trap
	Checksum: 0x736FE9CD
	Offset: 0x268
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "eye_beam_trap_postfx", 12000, 1, "int", &function_822dbe7f, 0, 0);
	clientfield::register("world", "eye_beam_rumble_factory", 12000, 1, "int", &function_3d1860f, 0, 0);
	clientfield::register("world", "eye_beam_rumble_library", 12000, 1, "int", &function_ea1e41d4, 0, 0);
}

/*
	Name: function_822dbe7f
	Namespace: zm_stalingrad_eye_beam_trap
	Checksum: 0xC918714A
	Offset: 0x350
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function function_822dbe7f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self thread postfx::playpostfxbundle("pstfx_eye_beam_dmg");
	}
	else
	{
		self thread postfx::stoppostfxbundle();
	}
}

/*
	Name: function_3d1860f
	Namespace: zm_stalingrad_eye_beam_trap
	Checksum: 0x133B4D5A
	Offset: 0x3D8
	Size: 0xF4
	Parameters: 7
	Flags: Linked
*/
function function_3d1860f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	e_player = getlocalplayer(localclientnum);
	if(newval)
	{
		e_player.var_ce79a8bf = function_3975127(localclientnum, "factory");
	}
	else if(isdefined(e_player.var_ce79a8bf))
	{
		e_player.var_ce79a8bf stoprumble(localclientnum, "zm_stalingrad_eye_beam_rumble");
		e_player.var_ce79a8bf delete();
	}
}

/*
	Name: function_ea1e41d4
	Namespace: zm_stalingrad_eye_beam_trap
	Checksum: 0xCCD8526
	Offset: 0x4D8
	Size: 0xF4
	Parameters: 7
	Flags: Linked
*/
function function_ea1e41d4(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	e_player = getlocalplayer(localclientnum);
	if(newval)
	{
		e_player.var_5082384e = function_3975127(localclientnum, "library");
	}
	else if(isdefined(e_player.var_5082384e))
	{
		e_player.var_5082384e stoprumble(localclientnum, "zm_stalingrad_eye_beam_rumble");
		e_player.var_5082384e delete();
	}
}

/*
	Name: function_3975127
	Namespace: zm_stalingrad_eye_beam_trap
	Checksum: 0x9B6FD2A6
	Offset: 0x5D8
	Size: 0xA8
	Parameters: 2
	Flags: Linked
*/
function function_3975127(localclientnum, str_location)
{
	var_459eee06 = struct::get("eye_beam_rumble_" + str_location, "targetname");
	var_7cbc8176 = util::spawn_model(localclientnum, "tag_origin", var_459eee06.origin);
	var_7cbc8176 playrumbleonentity(localclientnum, "zm_stalingrad_eye_beam_rumble");
	return var_7cbc8176;
}

