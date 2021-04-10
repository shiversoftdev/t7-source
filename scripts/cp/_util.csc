// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace util;

/*
	Name: set_streamer_hint_function
	Namespace: util
	Checksum: 0x2A4248A
	Offset: 0x170
	Size: 0x74
	Parameters: 2
	Flags: None
*/
function set_streamer_hint_function(func, number_of_zones)
{
	level.func_streamer_hint = func;
	clientfield::register("world", "force_streamer", 1, getminbitcountfornum(number_of_zones), "int", &_force_streamer, 0, 0);
}

/*
	Name: _force_streamer
	Namespace: util
	Checksum: 0x8C25F138
	Offset: 0x1F0
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function _force_streamer(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojumpid)
{
	if(newval == 0)
	{
		stopforcingstreamer();
	}
	else
	{
		[[level.func_streamer_hint]](newval);
		level waittill_notify_or_timeout("streamer_100", 15);
		streamernotify(newval);
	}
}

/*
	Name: init_breath_fx
	Namespace: util
	Checksum: 0x45EFD6D2
	Offset: 0x2A8
	Size: 0xD4
	Parameters: 0
	Flags: None
*/
function init_breath_fx()
{
	level.cold_breath = [];
	level._effect["player_cold_breath"] = "player/fx_plyr_breath_steam_1p";
	level._effect["ai_cold_breath"] = "player/fx_plyr_breath_steam_3p";
	clientfield::register("toplayer", "player_cold_breath", 1, 1, "int", &function_9d577661, 0, 0);
	clientfield::register("actor", "ai_cold_breath", 1, 1, "counter", &function_ddc76be5, 0, 0);
}

/*
	Name: function_9d577661
	Namespace: util
	Checksum: 0x4F1F90C5
	Offset: 0x388
	Size: 0xB2
	Parameters: 7
	Flags: Linked
*/
function function_9d577661(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		if(isdefined(level.cold_breath[localclientnum]) && level.cold_breath[localclientnum])
		{
			return;
		}
		level.cold_breath[localclientnum] = 1;
		self thread function_5556b03d(localclientnum);
	}
	else
	{
		level.cold_breath[localclientnum] = 0;
	}
}

/*
	Name: function_5556b03d
	Namespace: util
	Checksum: 0xD7F0B8CD
	Offset: 0x448
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function function_5556b03d(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	self endon(#"death");
	while(isdefined(level.cold_breath[localclientnum]) && level.cold_breath[localclientnum])
	{
		wait(randomintrange(5, 7));
		playfxoncamera(localclientnum, level._effect["player_cold_breath"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
	}
}

/*
	Name: function_ddc76be5
	Namespace: util
	Checksum: 0xBC408F40
	Offset: 0x4F8
	Size: 0xB8
	Parameters: 7
	Flags: Linked
*/
function function_ddc76be5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self endon(#"death");
	while(isalive(self))
	{
		wait(randomintrange(6, 8));
		playfxontag(localclientnum, level._effect["ai_cold_breath"], self, "j_head");
	}
}

