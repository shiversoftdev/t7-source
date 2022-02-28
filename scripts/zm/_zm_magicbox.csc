// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_magicbox;

/*
	Name: __init__sytem__
	Namespace: zm_magicbox
	Checksum: 0x3041B061
	Offset: 0x228
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_magicbox", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_magicbox
	Checksum: 0x15A92A1E
	Offset: 0x268
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["chest_light"] = "zombie/fx_weapon_box_open_glow_zmb";
	level._effect["chest_light_closed"] = "zombie/fx_weapon_box_closed_glow_zmb";
	clientfield::register("zbarrier", "magicbox_open_glow", 1, 1, "int", &magicbox_open_glow_callback, 0, 0);
	clientfield::register("zbarrier", "magicbox_closed_glow", 1, 1, "int", &magicbox_closed_glow_callback, 0, 0);
	clientfield::register("zbarrier", "zbarrier_show_sounds", 1, 1, "counter", &magicbox_show_sounds_callback, 1, 0);
	clientfield::register("zbarrier", "zbarrier_leave_sounds", 1, 1, "counter", &magicbox_leave_sounds_callback, 1, 0);
	clientfield::register("scriptmover", "force_stream", 7000, 1, "int", &force_stream_changed, 0, 0);
}

/*
	Name: force_stream_changed
	Namespace: zm_magicbox
	Checksum: 0x2B7FF53B
	Offset: 0x410
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function force_stream_changed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		model = self.model;
		if(isdefined(model))
		{
			thread stream_model_for_time(localclientnum, model, 15);
		}
	}
}

/*
	Name: lock_weapon_model
	Namespace: zm_magicbox
	Checksum: 0x568C8C9F
	Offset: 0x4A0
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function lock_weapon_model(model)
{
	if(isdefined(model))
	{
		if(!isdefined(level.model_locks))
		{
			level.model_locks = [];
		}
		if(!isdefined(level.model_locks[model]))
		{
			level.model_locks[model] = 0;
		}
		if(level.model_locks[model] < 1)
		{
			forcestreamxmodel(model);
		}
		level.model_locks[model]++;
	}
}

/*
	Name: unlock_weapon_model
	Namespace: zm_magicbox
	Checksum: 0x83CF2AF1
	Offset: 0x540
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function unlock_weapon_model(model)
{
	if(isdefined(model))
	{
		if(!isdefined(level.model_locks))
		{
			level.model_locks = [];
		}
		if(!isdefined(level.model_locks[model]))
		{
			level.model_locks[model] = 0;
		}
		level.model_locks[model]--;
		if(level.model_locks[model] < 1)
		{
			stopforcestreamingxmodel(model);
		}
	}
}

/*
	Name: stream_model_for_time
	Namespace: zm_magicbox
	Checksum: 0xC01F8AE1
	Offset: 0x5E0
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function stream_model_for_time(localclientnum, model, time)
{
	lock_weapon_model(model);
	wait(time);
	unlock_weapon_model(model);
}

/*
	Name: magicbox_show_sounds_callback
	Namespace: zm_magicbox
	Checksum: 0xE8DFF6F1
	Offset: 0x640
	Size: 0xB4
	Parameters: 7
	Flags: Linked
*/
function magicbox_show_sounds_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playsound(localclientnum, "zmb_box_poof_land", self.origin);
	playsound(localclientnum, "zmb_couch_slam", self.origin);
	playsound(localclientnum, "zmb_box_poof", self.origin);
}

/*
	Name: magicbox_leave_sounds_callback
	Namespace: zm_magicbox
	Checksum: 0x54528E66
	Offset: 0x700
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function magicbox_leave_sounds_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playsound(localclientnum, "zmb_box_move", self.origin);
	playsound(localclientnum, "zmb_whoosh", self.origin);
}

/*
	Name: magicbox_open_glow_callback
	Namespace: zm_magicbox
	Checksum: 0xA0077F8E
	Offset: 0x798
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function magicbox_open_glow_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread magicbox_glow_callback(localclientnum, newval, level._effect["chest_light"]);
}

/*
	Name: magicbox_closed_glow_callback
	Namespace: zm_magicbox
	Checksum: 0x208DD9AD
	Offset: 0x810
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function magicbox_closed_glow_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread magicbox_glow_callback(localclientnum, newval, level._effect["chest_light_closed"]);
}

/*
	Name: magicbox_glow_callback
	Namespace: zm_magicbox
	Checksum: 0x18EECAAA
	Offset: 0x888
	Size: 0x154
	Parameters: 3
	Flags: Linked
*/
function magicbox_glow_callback(localclientnum, newval, fx)
{
	if(!isdefined(self.glow_obj_array))
	{
		self.glow_obj_array = [];
	}
	if(!isdefined(self.glow_fx_array))
	{
		self.glow_fx_array = [];
	}
	if(!isdefined(self.glow_obj_array[localclientnum]))
	{
		fx_obj = spawn(localclientnum, self.origin, "script_model");
		fx_obj setmodel("tag_origin");
		fx_obj.angles = self.angles;
		self.glow_obj_array[localclientnum] = fx_obj;
		wait(0.016);
	}
	self glow_obj_cleanup(localclientnum);
	if(newval)
	{
		self.glow_fx_array[localclientnum] = playfxontag(localclientnum, fx, self.glow_obj_array[localclientnum], "tag_origin");
		self glow_obj_demo_jump_listener(localclientnum);
	}
}

/*
	Name: glow_obj_demo_jump_listener
	Namespace: zm_magicbox
	Checksum: 0x2B5300AE
	Offset: 0x9E8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function glow_obj_demo_jump_listener(localclientnum)
{
	self endon(#"end_demo_jump_listener");
	level waittill(#"demo_jump");
	if(isdefined(self))
	{
		self glow_obj_cleanup(localclientnum);
	}
}

/*
	Name: glow_obj_cleanup
	Namespace: zm_magicbox
	Checksum: 0x2F8C75E0
	Offset: 0xA38
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function glow_obj_cleanup(localclientnum)
{
	if(isdefined(self.glow_fx_array[localclientnum]))
	{
		stopfx(localclientnum, self.glow_fx_array[localclientnum]);
		self.glow_fx_array[localclientnum] = undefined;
	}
	self notify(#"end_demo_jump_listener");
}

