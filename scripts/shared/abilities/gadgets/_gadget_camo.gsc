// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_gadgets;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;

#namespace _gadget_camo;

/*
	Name: __init__sytem__
	Namespace: _gadget_camo
	Checksum: 0x80DC872B
	Offset: 0x240
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_camo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_camo
	Checksum: 0x369FF94A
	Offset: 0x280
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ability_player::register_gadget_activation_callbacks(2, &camo_gadget_on, &camo_gadget_off);
	ability_player::register_gadget_possession_callbacks(2, &camo_on_give, &camo_on_take);
	ability_player::register_gadget_flicker_callbacks(2, &camo_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(2, &camo_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(2, &camo_is_flickering);
	clientfield::register("allplayers", "camo_shader", 1, 3, "int");
	callback::on_connect(&camo_on_connect);
	callback::on_spawned(&camo_on_spawn);
	callback::on_disconnect(&camo_on_disconnect);
}

/*
	Name: camo_is_inuse
	Namespace: _gadget_camo
	Checksum: 0xBA12034C
	Offset: 0x3E0
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function camo_is_inuse(slot)
{
	return self flagsys::get("camo_suit_on");
}

/*
	Name: camo_is_flickering
	Namespace: _gadget_camo
	Checksum: 0x9F07E019
	Offset: 0x418
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function camo_is_flickering(slot)
{
	return self gadgetflickering(slot);
}

/*
	Name: camo_on_connect
	Namespace: _gadget_camo
	Checksum: 0x45D05F04
	Offset: 0x448
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function camo_on_connect()
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self [[level.cybercom.active_camo._on_connect]]();
	}
}

/*
	Name: camo_on_disconnect
	Namespace: _gadget_camo
	Checksum: 0x92C8444A
	Offset: 0x498
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function camo_on_disconnect()
{
	if(isdefined(self.sound_ent))
	{
		self.sound_ent stoploopsound(0.05);
		self.sound_ent delete();
	}
}

/*
	Name: camo_on_spawn
	Namespace: _gadget_camo
	Checksum: 0x9052CB8A
	Offset: 0x4F0
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function camo_on_spawn()
{
	self flagsys::clear("camo_suit_on");
	self notify(#"camo_off");
	self camo_bread_crumb_delete();
	self clientfield::set("camo_shader", 0);
	if(isdefined(self.sound_ent))
	{
		self.sound_ent stoploopsound(0.05);
		self.sound_ent delete();
	}
}

/*
	Name: suspend_camo_suit
	Namespace: _gadget_camo
	Checksum: 0xBB00EBC5
	Offset: 0x5A8
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function suspend_camo_suit(slot, weapon)
{
	self endon(#"disconnect");
	self endon(#"camo_off");
	self clientfield::set("camo_shader", 2);
	suspend_camo_suit_wait(slot, weapon);
	if(self camo_is_inuse(slot))
	{
		self clientfield::set("camo_shader", 1);
	}
}

/*
	Name: suspend_camo_suit_wait
	Namespace: _gadget_camo
	Checksum: 0x746A90B9
	Offset: 0x650
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function suspend_camo_suit_wait(slot, weapon)
{
	self endon(#"death");
	self endon(#"camo_off");
	while(self camo_is_flickering(slot))
	{
		wait(0.5);
	}
}

/*
	Name: camo_on_give
	Namespace: _gadget_camo
	Checksum: 0xB1E399B4
	Offset: 0x6B0
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function camo_on_give(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self [[level.cybercom.active_camo._on_give]](slot, weapon);
	}
}

/*
	Name: camo_on_take
	Namespace: _gadget_camo
	Checksum: 0x2D124037
	Offset: 0x718
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function camo_on_take(slot, weapon)
{
	self notify(#"camo_removed");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self [[level.cybercom.active_camo._on_take]](slot, weapon);
	}
}

/*
	Name: camo_on_flicker
	Namespace: _gadget_camo
	Checksum: 0xDDC437A9
	Offset: 0x790
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function camo_on_flicker(slot, weapon)
{
	self thread camo_suit_flicker(slot, weapon);
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self thread [[level.cybercom.active_camo._on_flicker]](slot, weapon);
	}
}

/*
	Name: camo_all_actors
	Namespace: _gadget_camo
	Checksum: 0x9E667391
	Offset: 0x818
	Size: 0xCE
	Parameters: 1
	Flags: None
*/
function camo_all_actors(value)
{
	str_opposite_team = "axis";
	if(self.team == "axis")
	{
		str_opposite_team = "allies";
	}
	aitargets = getaiarray(str_opposite_team);
	for(i = 0; i < aitargets.size; i++)
	{
		testtarget = aitargets[i];
		if(!isdefined(testtarget) || !isalive(testtarget))
		{
			continue;
		}
	}
}

/*
	Name: camo_gadget_on
	Namespace: _gadget_camo
	Checksum: 0x17C1DCFB
	Offset: 0x8F0
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function camo_gadget_on(slot, weapon)
{
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self thread [[level.cybercom.active_camo._on]](slot, weapon);
	}
	self thread camo_takedown_watch(slot, weapon);
	self._gadget_camo_oldignoreme = self.ignoreme;
	self.ignoreme = 1;
	self clientfield::set("camo_shader", 1);
	self flagsys::set("camo_suit_on");
	self thread camo_bread_crumb(slot, weapon);
}

/*
	Name: camo_gadget_off
	Namespace: _gadget_camo
	Checksum: 0x3270DB9F
	Offset: 0x9F8
	Size: 0x10C
	Parameters: 2
	Flags: Linked
*/
function camo_gadget_off(slot, weapon)
{
	self flagsys::clear("camo_suit_on");
	if(isdefined(level.cybercom) && isdefined(level.cybercom.active_camo))
	{
		self thread [[level.cybercom.active_camo._off]](slot, weapon);
	}
	self notify(#"camo_off", isdefined(self.sound_ent));
	if(isdefined(self._gadget_camo_oldignoreme))
	{
		self.ignoreme = self._gadget_camo_oldignoreme;
		self._gadget_camo_oldignoreme = undefined;
	}
	else
	{
		self.ignoreme = 0;
	}
	self camo_bread_crumb_delete();
	self.gadget_camo_off_time = gettime();
	self clientfield::set("camo_shader", 0);
}

/*
	Name: camo_bread_crumb
	Namespace: _gadget_camo
	Checksum: 0x981B1C94
	Offset: 0xB10
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function camo_bread_crumb(slot, weapon)
{
	self notify(#"camo_bread_crumb");
	self endon(#"camo_bread_crumb");
	self camo_bread_crumb_delete();
	if(!self camo_is_inuse())
	{
		return;
	}
	self._camo_crumb = spawn("script_model", self.origin);
	self._camo_crumb setmodel("tag_origin");
	self camo_bread_crumb_wait(slot, weapon);
	self camo_bread_crumb_delete();
}

/*
	Name: camo_bread_crumb_wait
	Namespace: _gadget_camo
	Checksum: 0x231EB197
	Offset: 0xC00
	Size: 0xA0
	Parameters: 2
	Flags: Linked
*/
function camo_bread_crumb_wait(slot, weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"camo_off");
	self endon(#"camo_bread_crumb");
	starttime = gettime();
	while(true)
	{
		currenttime = gettime();
		if((currenttime - starttime) > self._gadgets_player[slot].gadget_breadcrumbduration)
		{
			return;
		}
		wait(0.5);
	}
}

/*
	Name: camo_bread_crumb_delete
	Namespace: _gadget_camo
	Checksum: 0xE237CB20
	Offset: 0xCA8
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function camo_bread_crumb_delete()
{
	if(isdefined(self._camo_crumb))
	{
		self._camo_crumb delete();
		self._camo_crumb = undefined;
	}
}

/*
	Name: camo_takedown_watch
	Namespace: _gadget_camo
	Checksum: 0x7DCA309
	Offset: 0xCE8
	Size: 0xA8
	Parameters: 2
	Flags: Linked
*/
function camo_takedown_watch(slot, weapon)
{
	self endon(#"disconnect");
	self endon(#"camo_off");
	while(true)
	{
		self waittill(#"weapon_assassination");
		if(self camo_is_inuse())
		{
			if(self._gadgets_player[slot].gadget_takedownrevealtime > 0)
			{
				self ability_gadgets::setflickering(slot, self._gadgets_player[slot].gadget_takedownrevealtime);
			}
		}
	}
}

/*
	Name: camo_temporary_dont_ignore
	Namespace: _gadget_camo
	Checksum: 0xB335FD5A
	Offset: 0xD98
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function camo_temporary_dont_ignore(slot)
{
	self endon(#"disconnect");
	if(!self camo_is_inuse())
	{
		return;
	}
	self notify(#"temporary_dont_ignore");
	wait(0.1);
	old_ignoreme = 0;
	if(isdefined(self._gadget_camo_oldignoreme))
	{
		old_ignoreme = self._gadget_camo_oldignoreme;
	}
	self.ignoreme = old_ignoreme;
	camo_temporary_dont_ignore_wait(slot);
	self.ignoreme = self camo_is_inuse() || old_ignoreme;
}

/*
	Name: camo_temporary_dont_ignore_wait
	Namespace: _gadget_camo
	Checksum: 0x1DCB40FD
	Offset: 0xE60
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function camo_temporary_dont_ignore_wait(slot)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"camo_off");
	self endon(#"temporary_dont_ignore");
	while(true)
	{
		if(!self camo_is_flickering(slot))
		{
			return;
		}
		wait(0.25);
	}
}

/*
	Name: camo_suit_flicker
	Namespace: _gadget_camo
	Checksum: 0xB85C6A43
	Offset: 0xED8
	Size: 0xD4
	Parameters: 2
	Flags: Linked
*/
function camo_suit_flicker(slot, weapon)
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"camo_off");
	if(!self camo_is_inuse())
	{
		return;
	}
	self thread camo_temporary_dont_ignore(slot);
	self thread suspend_camo_suit(slot, weapon);
	while(true)
	{
		if(!self camo_is_flickering(slot))
		{
			self thread camo_bread_crumb(slot);
			return;
		}
		wait(0.25);
	}
}

/*
	Name: set_camo_reveal_status
	Namespace: _gadget_camo
	Checksum: 0x3ACF1BA0
	Offset: 0xFB8
	Size: 0xA4
	Parameters: 2
	Flags: None
*/
function set_camo_reveal_status(status, time)
{
	timestr = "";
	self._gadget_camo_reveal_status = undefined;
	if(isdefined(time))
	{
		timestr = (", ^3time: ") + time;
		self._gadget_camo_reveal_status = status;
	}
	if(getdvarint("scr_cpower_debug_prints") > 0)
	{
		self iprintlnbold(("Camo Reveal: " + status) + timestr);
	}
}

