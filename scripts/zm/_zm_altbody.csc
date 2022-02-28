// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_utility;

#namespace zm_altbody;

/*
	Name: __init__sytem__
	Namespace: zm_altbody
	Checksum: 0x51758F32
	Offset: 0x250
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_altbody", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_altbody
	Checksum: 0xCD8A76B9
	Offset: 0x290
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("clientuimodel", "player_mana", 1, 8, "float", &set_player_mana, 0, 1);
	clientfield::register("toplayer", "player_in_afterlife", 1, 1, "int", &toggle_player_altbody, 0, 1);
	clientfield::register("allplayers", "player_altbody", 1, 1, "int", &toggle_player_altbody_3p, 0, 1);
	setupclientfieldcodecallbacks("toplayer", 1, "player_in_afterlife");
}

/*
	Name: init
	Namespace: zm_altbody
	Checksum: 0x1A5E248B
	Offset: 0x3A0
	Size: 0x162
	Parameters: 9
	Flags: Linked
*/
function init(name, trigger_name, trigger_hint, visionset_name, visionset_priority, enter_callback, exit_callback, enter_3p_callback, exit_3p_callback)
{
	if(!isdefined(level.altbody_enter_callbacks))
	{
		level.altbody_enter_callbacks = [];
	}
	if(!isdefined(level.altbody_exit_callbacks))
	{
		level.altbody_exit_callbacks = [];
	}
	if(!isdefined(level.altbody_enter_3p_callbacks))
	{
		level.altbody_enter_3p_callbacks = [];
	}
	if(!isdefined(level.altbody_exit_3p_callbacks))
	{
		level.altbody_exit_3p_callbacks = [];
	}
	if(!isdefined(level.altbody_visionsets))
	{
		level.altbody_visionsets = [];
	}
	level.altbody_name = name;
	if(isdefined(visionset_name))
	{
		level.altbody_visionsets[name] = visionset_name;
		visionset_mgr::register_visionset_info(visionset_name, 1, 1, visionset_name, visionset_name);
	}
	level.altbody_enter_callbacks[name] = enter_callback;
	level.altbody_exit_callbacks[name] = exit_callback;
	level.altbody_enter_3p_callbacks[name] = enter_3p_callback;
	level.altbody_exit_3p_callbacks[name] = exit_3p_callback;
}

/*
	Name: set_player_mana
	Namespace: zm_altbody
	Checksum: 0xCF14282C
	Offset: 0x510
	Size: 0x48
	Parameters: 7
	Flags: Linked
*/
function set_player_mana(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self.mana = newval;
}

/*
	Name: toggle_player_altbody
	Namespace: zm_altbody
	Checksum: 0x2BCFD96F
	Offset: 0x560
	Size: 0x14E
	Parameters: 7
	Flags: Linked
*/
function toggle_player_altbody(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.altbody))
	{
		self.altbody = 0;
	}
	self usealternatehud(newval);
	if(self.altbody !== newval)
	{
		self.altbody = newval;
		if(bwastimejump)
		{
			self thread function_9927f5ae(localclientnum, newval);
		}
		else
		{
			self thread cover_transition(localclientnum, newval);
		}
		if(newval == 1)
		{
			callback = level.altbody_enter_callbacks[level.altbody_name];
			if(isdefined(callback))
			{
				self [[callback]](localclientnum);
			}
		}
		else
		{
			callback = level.altbody_exit_callbacks[level.altbody_name];
			if(isdefined(callback))
			{
				self [[callback]](localclientnum);
			}
		}
	}
}

/*
	Name: toggle_player_altbody_3p
	Namespace: zm_altbody
	Checksum: 0x5EC17C7A
	Offset: 0x6B8
	Size: 0xE6
	Parameters: 7
	Flags: Linked
*/
function toggle_player_altbody_3p(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(self islocalplayer())
	{
		return;
	}
	self.altbody_3p = newval;
	if(newval == 1)
	{
		callback = level.altbody_enter_3p_callbacks[level.altbody_name];
		if(isdefined(callback))
		{
			self [[callback]](localclientnum);
		}
	}
	else
	{
		callback = level.altbody_exit_3p_callbacks[level.altbody_name];
		if(isdefined(callback))
		{
			self [[callback]](localclientnum);
		}
	}
}

/*
	Name: cover_transition
	Namespace: zm_altbody
	Checksum: 0x6F9067A
	Offset: 0x7A8
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function cover_transition(localclientnum, onoff)
{
	if(!self islocalplayer() || isspectating(localclientnum, 0) || localclientnum !== self getlocalclientnumber())
	{
		return;
	}
	if(isdemoplaying() && demoisanyfreemovecamera())
	{
		return;
	}
	lui::screen_fade_out(0.05);
	level util::waittill_any_timeout(0.15, "demo_jump");
	if(isdefined(self))
	{
		lui::screen_fade_in(0.1);
	}
}

/*
	Name: function_9927f5ae
	Namespace: zm_altbody
	Checksum: 0xE36A93A2
	Offset: 0x8B0
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function function_9927f5ae(localclientnum, onoff)
{
	lui::screen_fade_in(0);
}

