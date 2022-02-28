// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace cybercom_gadget_active_camo;

/*
	Name: init
	Namespace: cybercom_gadget_active_camo
	Checksum: 0x99EC1590
	Offset: 0x428
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: cybercom_gadget_active_camo
	Checksum: 0x8DCE94E8
	Offset: 0x438
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(1, 8, 1);
	level.cybercom.active_camo = spawnstruct();
	level.cybercom.active_camo._on_flicker = &_on_flicker;
	level.cybercom.active_camo._on_give = &_on_give;
	level.cybercom.active_camo._on_take = &_on_take;
	level.cybercom.active_camo._on_connect = &_on_connect;
	level.cybercom.active_camo._on = &_on;
	level.cybercom.active_camo._off = &_off;
	level.cybercom.active_cammo_upgraded_weap = getweapon("gadget_active_camo_upgraded");
	callback::on_disconnect(&_on_disconnect);
}

/*
	Name: _on_flicker
	Namespace: cybercom_gadget_active_camo
	Checksum: 0x7DB35DD1
	Offset: 0x5C0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: cybercom_gadget_active_camo
	Checksum: 0x63FAB902
	Offset: 0x5E0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.targetlockcb = undefined;
	self.cybercom.targetlockrequirementcb = undefined;
	self thread cybercom::function_b5f4e597(weapon);
}

/*
	Name: _on_take
	Namespace: cybercom_gadget_active_camo
	Checksum: 0x93E8D6D6
	Offset: 0x638
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
	self notify(#"active_camo_off");
	self notify(#"active_camo_taken");
	self notify(#"delete_false_target");
}

/*
	Name: _on_connect
	Namespace: cybercom_gadget_active_camo
	Checksum: 0x99EC1590
	Offset: 0x680
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on_disconnect
	Namespace: cybercom_gadget_active_camo
	Checksum: 0x4AD88A8D
	Offset: 0x690
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function _on_disconnect()
{
	self notify(#"delete_false_target");
	self notify(#"active_camo_off");
	self notify(#"active_camo_taken");
}

/*
	Name: _on
	Namespace: cybercom_gadget_active_camo
	Checksum: 0x1938CDF
	Offset: 0x6C8
	Size: 0x21C
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	self endon(#"active_camo_off");
	self endon(#"death");
	self endon(#"disconnect");
	self clientfield::set("camo_shader", 1);
	cybercom::function_adc40f11(weapon, 1);
	self.cybercom.oldignore = isdefined(self.ignoreme) && (self.ignoreme ? 1 : 0);
	self.ignoreme = 1;
	self.active_camo = 1;
	self playrumbleonentity("tank_rumble");
	self thread function_b4902c73(slot, weapon, "scene_disable_player_stuff", "active_camo_taken");
	self thread _camo_createfalsetarget();
	self thread cybercom::function_c3c6aff4(slot, weapon, "changed_class", "active_camo_off");
	self thread cybercom::function_c3c6aff4(slot, weapon, "cybercom_disabled", "active_camo_off");
	self thread function_cba091b7(slot, weapon);
	if(isplayer(self))
	{
		itemindex = getitemindexfromref("cybercom_camo");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: _off
	Namespace: cybercom_gadget_active_camo
	Checksum: 0xE1A843CC
	Offset: 0x8F0
	Size: 0xFE
	Parameters: 2
	Flags: Linked
*/
function _off(slot, weapon)
{
	if(getdvarint("tu1_cybercomActiveCamoIgnoreMeFix", 1))
	{
		if(isdefined(self.cybercom.oldignore) && self.cybercom.oldignore && self.ignoreme)
		{
		}
		else
		{
			self.ignoreme = 0;
		}
	}
	else if(isdefined(self.cybercom.oldignore))
	{
		self.ignoreme = self.cybercom.oldignore;
	}
	self.active_camo = undefined;
	/#
		if(isdefined(self.ignoreme) && self.ignoreme)
		{
			iprintlnbold("");
		}
	#/
	self notify(#"delete_false_target");
	self notify(#"active_camo_off");
}

/*
	Name: function_cba091b7
	Namespace: cybercom_gadget_active_camo
	Checksum: 0x1A5D7BA6
	Offset: 0x9F8
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function function_cba091b7(slot, weapon)
{
	self notify(#"hash_cba091b7");
	self endon(#"hash_cba091b7");
	self endon(#"disconnect");
	self endon(#"active_camo_off");
	self flagsys::wait_till("mobile_armory_in_use");
	self gadgetdeactivate(slot, weapon);
}

/*
	Name: function_b4902c73
	Namespace: cybercom_gadget_active_camo
	Checksum: 0xC0E39802
	Offset: 0xA88
	Size: 0xE4
	Parameters: 4
	Flags: Linked
*/
function function_b4902c73(slot, weapon, waitnote, endnote)
{
	self notify((endnote + waitnote) + weapon.name);
	self endon((endnote + waitnote) + weapon.name);
	self endon(endnote);
	self endon(#"disconnect");
	self waittill(waitnote);
	if(self hasweapon(weapon) && isdefined(self.cybercom.activecybercomweapon) && self.cybercom.activecybercomweapon == weapon)
	{
		self gadgetdeactivate(slot, weapon);
	}
}

/*
	Name: _camo_killreactivateonnotify
	Namespace: cybercom_gadget_active_camo
	Checksum: 0xCCC0772E
	Offset: 0xB78
	Size: 0xC2
	Parameters: 4
	Flags: Private
*/
function private _camo_killreactivateonnotify(slot, note, durationmin = 300, durationmax = 1000)
{
	self endon(#"active_camo_taken");
	self endon(#"disconnect");
	self notify(("_camo_killReActivateOnNotify" + slot) + note);
	self endon(("_camo_killReActivateOnNotify" + slot) + note);
	while(true)
	{
		self waittill(note, param);
		self notify(#"kill_active_cammo_reactivate");
	}
}

/*
	Name: _camo_createfalsetarget
	Namespace: cybercom_gadget_active_camo
	Checksum: 0x1FAA3ACF
	Offset: 0xC48
	Size: 0x224
	Parameters: 0
	Flags: Linked, Private
*/
function private _camo_createfalsetarget()
{
	self notify(#"delete_false_target");
	self endon(#"delete_false_target");
	fakeme = spawn("script_model", self.origin);
	fakeme setmodel("tag_origin");
	fakeme makesentient();
	fakeme.origin = fakeme.origin + vectorscale((0, 0, 1), 30);
	fakeme.team = self.team;
	self thread cybercom::deleteentonnote("disconnect", fakeme);
	self thread cybercom::deleteentonnote("active_camo_off", fakeme);
	self thread cybercom::deleteentonnote("delete_false_target", fakeme);
	self thread function_c51ef296(fakeme);
	zmin = self.origin[2];
	while(isdefined(fakeme))
	{
		fakeme.origin = fakeme.origin + (randomintrange(-50, 50), randomintrange(-50, 50), randomintrange(-5, 5));
		if(fakeme.origin[2] < zmin)
		{
			fakeme.origin = (fakeme.origin[0], fakeme.origin[1], zmin);
		}
		wait(0.5);
	}
}

/*
	Name: function_c51ef296
	Namespace: cybercom_gadget_active_camo
	Checksum: 0xDEF7CFEE
	Offset: 0xE78
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_c51ef296(fakeent)
{
	fakeent endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"weapon_fired", projectile);
		fakeent.origin = self.origin;
	}
}

/*
	Name: _active_cammo_reactivate
	Namespace: cybercom_gadget_active_camo
	Checksum: 0xBC6F286A
	Offset: 0xEE0
	Size: 0xE0
	Parameters: 0
	Flags: Private
*/
function private _active_cammo_reactivate()
{
	self notify(#"_active_cammo_reactivate");
	self endon(#"_active_cammo_reactivate");
	self endon(#"active_camo_taken");
	self endon(#"kill_active_cammo_reactivate");
	while(true)
	{
		self waittill(#"gadget_forced_off", slot, weapon);
		if(isdefined(weapon) && weapon == level.cybercom.active_cammo_upgraded_weap)
		{
			wait(getdvarint("scr_active_camo_melee_escape_duration_SEC", 1));
			if(!self gadgetisactive(slot))
			{
				self gadgetactivate(slot, weapon, 0);
			}
		}
	}
}

