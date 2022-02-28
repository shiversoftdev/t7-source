// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_gadget_sensory_overload;
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace cybercom_gadget_smokescreen;

/*
	Name: init
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x99EC1590
	Offset: 0x440
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0xEEDC48A8
	Offset: 0x450
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(1, 1);
	level.cybercom.smokescreen = spawnstruct();
	level.cybercom.smokescreen._is_flickering = &_is_flickering;
	level.cybercom.smokescreen._on_flicker = &_on_flicker;
	level.cybercom.smokescreen._on_give = &_on_give;
	level.cybercom.smokescreen._on_take = &_on_take;
	level.cybercom.smokescreen._on_connect = &_on_connect;
	level.cybercom.smokescreen._on = &_on;
	level.cybercom.smokescreen._off = &_off;
	level.cybercom.smokescreen._is_primed = &_is_primed;
}

/*
	Name: _is_flickering
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0xD230F060
	Offset: 0x5D8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x78B18FC8
	Offset: 0x5F0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x1D5424
	Offset: 0x610
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
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x19113CA5
	Offset: 0x668
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
}

/*
	Name: _on_connect
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x99EC1590
	Offset: 0x688
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0xB8CCD566
	Offset: 0x698
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	cybercom::function_adc40f11(weapon, 1);
	level thread spawn_smokescreen(self, self hascybercomability("cybercom_smokescreen") == 2);
	if(isplayer(self))
	{
		itemindex = getitemindexfromref("cybercom_smokescreen");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: _off
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x63E3CFD5
	Offset: 0x788
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _off(slot, weapon)
{
}

/*
	Name: _is_primed
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0xAFACF266
	Offset: 0x7A8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _is_primed(slot, weapon)
{
}

/*
	Name: rotateforwardxy
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x172CB9C9
	Offset: 0x7C8
	Size: 0xE2
	Parameters: 2
	Flags: Linked
*/
function rotateforwardxy(vtorotate, fangledegrees)
{
	x = (vtorotate[0] * cos(fangledegrees)) + (vtorotate[1] * sin(fangledegrees));
	y = -1 * vtorotate[0] * sin(fangledegrees) + (vtorotate[1] * cos(fangledegrees));
	z = vtorotate[2];
	return (x, y, z);
}

/*
	Name: spawn_smokescreen
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0xBB3A8301
	Offset: 0x8B8
	Size: 0x3D4
	Parameters: 2
	Flags: Linked
*/
function spawn_smokescreen(owner, upgraded = 0)
{
	weapon = (upgraded ? getweapon("smoke_cybercom_upgraded") : getweapon("smoke_cybercom"));
	forward = anglestoforward(owner.angles);
	center = (40 * forward) + owner.origin;
	frontspot = (140 * forward) + center;
	owner thread _cloudcreate(frontspot, weapon, upgraded);
	playsoundatposition("gdt_cybercore_smokescreen", frontspot);
	rotated = rotateforwardxy(forward, 23);
	var_ae0aa92 = (rotated * 140) + center;
	rotated = rotateforwardxy(forward, 46);
	var_e4de3029 = (rotated * 140) + center;
	rotated = rotateforwardxy(forward, 69);
	var_bedbb5c0 = (rotated * 140) + center;
	owner thread _cloudcreate(var_ae0aa92, weapon, upgraded);
	util::wait_network_frame();
	owner thread _cloudcreate(var_e4de3029, weapon, upgraded);
	util::wait_network_frame();
	owner thread _cloudcreate(var_bedbb5c0, weapon, upgraded);
	util::wait_network_frame();
	rotated = rotateforwardxy(forward, -23);
	var_354533f = (rotated * 140) + center;
	rotated = rotateforwardxy(forward, -46);
	var_914ce404 = (rotated * 140) + center;
	rotated = rotateforwardxy(forward, -69);
	var_b74f5e6d = (rotated * 140) + center;
	owner thread _cloudcreate(var_354533f, weapon, upgraded);
	util::wait_network_frame();
	owner thread _cloudcreate(var_914ce404, weapon, upgraded);
	util::wait_network_frame();
	owner thread _cloudcreate(var_b74f5e6d, weapon, upgraded);
	util::wait_network_frame();
	owner thread function_e52895b(center);
}

/*
	Name: _cloudcreate
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0xA466CABF
	Offset: 0xC98
	Size: 0x290
	Parameters: 3
	Flags: Linked, Private
*/
function private _cloudcreate(origin, weapon, createionfield)
{
	timestep = 2;
	cloud = _createnosightcloud(origin, getdvarint("scr_smokescreen_duration", 7), weapon);
	cloud thread _deleteaftertime(getdvarint("scr_smokescreen_duration", 7));
	cloud thread _scaleovertime(getdvarint("scr_smokescreen_duration", 7), 1, 2);
	cloud setteam(self.team);
	if(isplayer(self))
	{
		cloud setowner(self);
	}
	cloud.durationleft = getdvarint("scr_smokescreen_duration", 7);
	if(createionfield)
	{
		cloud thread _ionizedhazard(self, timestep);
	}
	if(getdvarint("scr_smokescreen_debug", 0))
	{
		cloud thread _debug_cloud(getdvarint("scr_smokescreen_duration", 7));
		level thread cybercom_dev::function_a0e51d80(cloud.origin, getdvarint("scr_smokescreen_duration", 7), 16, (1, 0, 0));
	}
	cloud endon(#"death");
	while(true)
	{
		fxblocksight(cloud, cloud.currentradius);
		wait(timestep);
		cloud.durationleft = cloud.durationleft - timestep;
		if(cloud.durationleft < 0)
		{
			cloud.durationleft = 0;
		}
	}
}

/*
	Name: _ionizedhazard
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x6C6A6796
	Offset: 0xF30
	Size: 0xB6
	Parameters: 2
	Flags: Linked, Private
*/
function private _ionizedhazard(player, timestep)
{
	self endon(#"death");
	while(true)
	{
		if(isdefined(self.trigger))
		{
			self.trigger delete();
		}
		self.trigger = spawn("trigger_radius", self.origin, 25, self.currentradius, self.currentradius);
		self.trigger thread _ionizedhazardthink(player, self);
		wait(timestep);
	}
}

/*
	Name: _ionizedhazardthink
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x6751A475
	Offset: 0xFF0
	Size: 0x31A
	Parameters: 2
	Flags: Linked, Private
*/
function private _ionizedhazardthink(player, cloud)
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger", guy);
		if(!isdefined(cloud))
		{
			return;
		}
		if(!isdefined(guy))
		{
			continue;
		}
		if(!isalive(guy))
		{
			continue;
		}
		if(isdefined(guy.is_disabled) && guy.is_disabled)
		{
			return false;
		}
		if(!(isdefined(guy.takedamage) && guy.takedamage))
		{
			return false;
		}
		if(isdefined(guy._ai_melee_opponent))
		{
			return false;
		}
		if(isdefined(guy.is_disabled) && guy.is_disabled)
		{
			continue;
		}
		if(guy cybercom::cybercom_aicheckoptout("cybercom_smokescreen"))
		{
			continue;
		}
		if(isdefined(guy.magic_bullet_shield) && guy.magic_bullet_shield)
		{
			continue;
		}
		if(isactor(guy) && guy isinscriptedstate())
		{
			continue;
		}
		if(isdefined(guy.allowdeath) && !guy.allowdeath)
		{
			continue;
		}
		if(isvehicle(guy))
		{
			if(!isdefined(guy.var_5895314d))
			{
				player thread challenges::function_96ed590f("cybercom_uses_martial");
				guy.var_5895314d = 1;
			}
			guy thread cybercom_gadget_system_overload::system_overload(player, cloud.durationleft * 1000);
		}
		if(isdefined(guy.archetype))
		{
			switch(guy.archetype)
			{
				case "robot":
				{
					player thread challenges::function_96ed590f("cybercom_uses_martial");
					guy thread cybercom_gadget_system_overload::system_overload(player, cloud.durationleft * 1000);
					break;
				}
				case "human":
				case "human_riotshield":
				{
					player thread challenges::function_96ed590f("cybercom_uses_martial");
					guy thread cybercom_gadget_sensory_overload::sensory_overload(player, "cybercom_smokescreen");
					break;
				}
			}
		}
	}
}

/*
	Name: _moveindirection
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0xC0551218
	Offset: 0x1318
	Size: 0x90
	Parameters: 3
	Flags: Private
*/
function private _moveindirection(dir, unitstomove, seconds)
{
	self endon(#"death");
	ticks = seconds * 20;
	dxstep = (unitstomove / ticks) * vectornormalize(dir);
	while(ticks)
	{
		ticks--;
		self.origin = self.origin + dxstep;
	}
}

/*
	Name: _createnosightcloud
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0xD20BE4A2
	Offset: 0x13B0
	Size: 0x88
	Parameters: 3
	Flags: Linked, Private
*/
function private _createnosightcloud(origin, duration, weapon)
{
	smokescreen = spawntimedfx(weapon, origin, (0, 0, 1), duration);
	smokescreen.currentradius = getdvarint("scr_smokescreen_radius", 60);
	smokescreen.currentscale = 1;
	return smokescreen;
}

/*
	Name: _deleteaftertime
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x251EC98A
	Offset: 0x1440
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private _deleteaftertime(time)
{
	self endon(#"death");
	wait(time);
	if(isdefined(self.trigger))
	{
		self.trigger delete();
	}
	self delete();
}

/*
	Name: _scaleovertime
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x9C661A40
	Offset: 0x14A8
	Size: 0x176
	Parameters: 3
	Flags: Linked, Private
*/
function private _scaleovertime(time, startscale, maxscale)
{
	self endon(#"death");
	if(maxscale < 1)
	{
		maxscale = 1;
	}
	self.currentscale = startscale;
	serverticks = time * 20;
	up = maxscale > startscale;
	if(up)
	{
		deltascale = maxscale - startscale;
		deltastep = deltascale / serverticks;
	}
	else
	{
		deltascale = startscale - maxscale;
		deltastep = (deltascale / serverticks) * -1;
	}
	while(serverticks)
	{
		self.currentscale = self.currentscale + deltastep;
		if(self.currentscale > maxscale)
		{
			self.currentscale = maxscale;
		}
		if(self.currentscale < 1)
		{
			self.currentscale = 1;
		}
		self.currentradius = getdvarint("scr_smokescreen_radius", 60) * self.currentscale;
		wait(0.05);
		serverticks--;
	}
}

/*
	Name: _debug_cloud
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0x32B6A896
	Offset: 0x1628
	Size: 0x70
	Parameters: 1
	Flags: Linked, Private
*/
function private _debug_cloud(time)
{
	self endon(#"death");
	serverticks = time * 20;
	while(serverticks)
	{
		serverticks--;
		level thread cybercom::debug_sphere(self.origin, self.currentradius);
		wait(0.05);
	}
}

/*
	Name: ai_activatesmokescreen
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0xAD1BBA24
	Offset: 0x16A0
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function ai_activatesmokescreen(var_9bc2efcb = 1, upgraded = 0)
{
	if(isdefined(var_9bc2efcb) && var_9bc2efcb)
	{
		type = self cybercom::function_5e3d3aa();
		self orientmode("face default");
		self animscripted("ai_cybercom_anim", self.origin, self.angles, ("ai_base_rifle_" + type) + "_exposed_cybercom_activate");
		self waittillmatch(#"ai_cybercom_anim");
	}
	level thread spawn_smokescreen(self, upgraded);
}

/*
	Name: function_e52895b
	Namespace: cybercom_gadget_smokescreen
	Checksum: 0xA78C071E
	Offset: 0x17A8
	Size: 0x8E
	Parameters: 1
	Flags: Linked, Private
*/
function private function_e52895b(origin)
{
	self endon(#"death");
	var_9f9fc36f = 1;
	timeleft = getdvarint("scr_smokescreen_duration", 7);
	while(timeleft > 0)
	{
		resetvisibilitycachewithinradius(origin, 1000);
		wait(var_9f9fc36f);
		timeleft = timeleft - var_9f9fc36f;
	}
}

