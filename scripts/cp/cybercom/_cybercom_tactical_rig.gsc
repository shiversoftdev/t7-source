// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_tactical_rig_copycat;
#using scripts\cp\cybercom\_cybercom_tactical_rig_emergencyreserve;
#using scripts\cp\cybercom\_cybercom_tactical_rig_multicore;
#using scripts\cp\cybercom\_cybercom_tactical_rig_playermovement;
#using scripts\cp\cybercom\_cybercom_tactical_rig_proximitydeterrent;
#using scripts\cp\cybercom\_cybercom_tactical_rig_repulsorarmor;
#using scripts\cp\cybercom\_cybercom_tactical_rig_sensorybuffer;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace cybercom_tacrig;

/*
	Name: init
	Namespace: cybercom_tacrig
	Checksum: 0xC26C7EC8
	Offset: 0x3B8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function init()
{
	cybercom_tacrig_sensorybuffer::init();
	cybercom_tacrig_emergencyreserve::init();
	cybercom_tacrig_proximitydeterrent::init();
	cybercom_tacrig_respulsorarmor::init();
	cybercom_tacrig_playermovement::init();
	cybercom_tacrig_copycat::init();
	cybercom_tacrig_multicore::init();
}

/*
	Name: main
	Namespace: cybercom_tacrig
	Checksum: 0xF4C1D185
	Offset: 0x438
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	cybercom_tacrig_sensorybuffer::main();
	cybercom_tacrig_emergencyreserve::main();
	cybercom_tacrig_proximitydeterrent::main();
	cybercom_tacrig_respulsorarmor::main();
	cybercom_tacrig_playermovement::main();
	cybercom_tacrig_copycat::main();
	cybercom_tacrig_multicore::main();
}

/*
	Name: on_player_connect
	Namespace: cybercom_tacrig
	Checksum: 0x99EC1590
	Offset: 0x4F8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: on_player_spawned
	Namespace: cybercom_tacrig
	Checksum: 0x99EC1590
	Offset: 0x508
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: register_cybercom_rig_ability
	Namespace: cybercom_tacrig
	Checksum: 0xE35B2A5C
	Offset: 0x518
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function register_cybercom_rig_ability(name, type)
{
	if(!isdefined(level._cybercom_rig_ability))
	{
		level._cybercom_rig_ability = [];
	}
	if(!isdefined(level._cybercom_rig_ability[name]))
	{
		level._cybercom_rig_ability[name] = spawnstruct();
		level._cybercom_rig_ability[name].name = name;
		level._cybercom_rig_ability[name].type = type;
	}
}

/*
	Name: register_cybercom_rig_possession_callbacks
	Namespace: cybercom_tacrig
	Checksum: 0x442EDE7
	Offset: 0x5C0
	Size: 0x282
	Parameters: 3
	Flags: Linked
*/
function register_cybercom_rig_possession_callbacks(name, on_give, on_take)
{
	/#
		assert(isdefined(level._cybercom_rig_ability[name]));
	#/
	if(!isdefined(level._cybercom_rig_ability[name].on_give))
	{
		level._cybercom_rig_ability[name].on_give = [];
	}
	if(!isdefined(level._cybercom_rig_ability[name].on_take))
	{
		level._cybercom_rig_ability[name].on_take = [];
	}
	if(isdefined(on_give))
	{
		if(!isdefined(level._cybercom_rig_ability[name].on_give))
		{
			level._cybercom_rig_ability[name].on_give = [];
		}
		else if(!isarray(level._cybercom_rig_ability[name].on_give))
		{
			level._cybercom_rig_ability[name].on_give = array(level._cybercom_rig_ability[name].on_give);
		}
		level._cybercom_rig_ability[name].on_give[level._cybercom_rig_ability[name].on_give.size] = on_give;
	}
	if(isdefined(on_take))
	{
		if(!isdefined(level._cybercom_rig_ability[name].on_take))
		{
			level._cybercom_rig_ability[name].on_take = [];
		}
		else if(!isarray(level._cybercom_rig_ability[name].on_take))
		{
			level._cybercom_rig_ability[name].on_take = array(level._cybercom_rig_ability[name].on_take);
		}
		level._cybercom_rig_ability[name].on_take[level._cybercom_rig_ability[name].on_take.size] = on_take;
	}
}

/*
	Name: register_cybercom_rig_activation_callbacks
	Namespace: cybercom_tacrig
	Checksum: 0xFD823F8C
	Offset: 0x850
	Size: 0x282
	Parameters: 3
	Flags: Linked
*/
function register_cybercom_rig_activation_callbacks(name, turn_on, turn_off)
{
	/#
		assert(isdefined(level._cybercom_rig_ability[name]));
	#/
	if(!isdefined(level._cybercom_rig_ability[name].turn_on))
	{
		level._cybercom_rig_ability[name].turn_on = [];
	}
	if(!isdefined(level._cybercom_rig_ability[name].turn_off))
	{
		level._cybercom_rig_ability[name].turn_off = [];
	}
	if(isdefined(turn_on))
	{
		if(!isdefined(level._cybercom_rig_ability[name].turn_on))
		{
			level._cybercom_rig_ability[name].turn_on = [];
		}
		else if(!isarray(level._cybercom_rig_ability[name].turn_on))
		{
			level._cybercom_rig_ability[name].turn_on = array(level._cybercom_rig_ability[name].turn_on);
		}
		level._cybercom_rig_ability[name].turn_on[level._cybercom_rig_ability[name].turn_on.size] = turn_on;
	}
	if(isdefined(turn_off))
	{
		if(!isdefined(level._cybercom_rig_ability[name].turn_off))
		{
			level._cybercom_rig_ability[name].turn_off = [];
		}
		else if(!isarray(level._cybercom_rig_ability[name].turn_off))
		{
			level._cybercom_rig_ability[name].turn_off = array(level._cybercom_rig_ability[name].turn_off);
		}
		level._cybercom_rig_ability[name].turn_off[level._cybercom_rig_ability[name].turn_off.size] = turn_off;
	}
}

/*
	Name: rigabilitygiven
	Namespace: cybercom_tacrig
	Checksum: 0x75067220
	Offset: 0xAE0
	Size: 0xD6
	Parameters: 2
	Flags: Linked
*/
function rigabilitygiven(type, upgraded)
{
	if(!isdefined(level._cybercom_rig_ability[type]))
	{
		return;
	}
	if(isdefined(level._cybercom_rig_ability[type].on_give))
	{
		foreach(on_give in level._cybercom_rig_ability[type].on_give)
		{
			self [[on_give]](type);
		}
	}
}

/*
	Name: giverigability
	Namespace: cybercom_tacrig
	Checksum: 0x642F9668
	Offset: 0xBC0
	Size: 0xF0
	Parameters: 4
	Flags: Linked
*/
function giverigability(type, upgraded = 0, slot, setflags = 1)
{
	if(!isdefined(level._cybercom_rig_ability[type]))
	{
		return false;
	}
	if(!isdefined(slot))
	{
		self setcybercomrig(type, upgraded);
	}
	else
	{
		self setcybercomrig(type, upgraded, slot);
	}
	if(setflags)
	{
		self cybercom::updatecybercomflags();
	}
	self rigabilitygiven(type);
	return true;
}

/*
	Name: function_ccca7010
	Namespace: cybercom_tacrig
	Checksum: 0x2BE67616
	Offset: 0xCB8
	Size: 0x40
	Parameters: 1
	Flags: None
*/
function function_ccca7010(type)
{
	if(!isdefined(level._cybercom_rig_ability[type]))
	{
		return false;
	}
	self _take_rig_ability(type);
	return true;
}

/*
	Name: _take_rig_ability
	Namespace: cybercom_tacrig
	Checksum: 0xD9625089
	Offset: 0xD00
	Size: 0x130
	Parameters: 1
	Flags: Linked, Private
*/
function private _take_rig_ability(type)
{
	if(!isdefined(level._cybercom_rig_ability[type]))
	{
		return false;
	}
	if(isdefined(level._cybercom_rig_ability[type]) && isdefined(level._cybercom_rig_ability[type].on_take))
	{
		foreach(on_take in level._cybercom_rig_ability[type].on_take)
		{
			self [[on_take]](type);
		}
	}
	self notify("take_ability_" + type);
	self clearcybercomrig(type);
	self cybercom::updatecybercomflags();
	return true;
}

/*
	Name: takeallrigabilities
	Namespace: cybercom_tacrig
	Checksum: 0x9FB48B37
	Offset: 0xE38
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function takeallrigabilities()
{
	foreach(ability in level._cybercom_rig_ability)
	{
		if(self hascybercomrig(ability.name) != 0)
		{
			_take_rig_ability(ability.name);
		}
	}
	self cybercom::updatecybercomflags();
}

/*
	Name: giveallrigabilities
	Namespace: cybercom_tacrig
	Checksum: 0x70F2CF9A
	Offset: 0xF18
	Size: 0xF4
	Parameters: 0
	Flags: None
*/
function giveallrigabilities()
{
	foreach(ability in level._cybercom_rig_ability)
	{
		status = self hascybercomrig(ability.name);
		if(status != 0)
		{
			self giverigability(ability.name, status == 2);
		}
	}
	self cybercom::updatecybercomflags();
}

/*
	Name: turn_rig_ability_on
	Namespace: cybercom_tacrig
	Checksum: 0xDF2D2562
	Offset: 0x1018
	Size: 0x102
	Parameters: 1
	Flags: Linked
*/
function turn_rig_ability_on(type)
{
	reserveability = self hascybercomrig(type);
	if(reserveability == 0)
	{
		return;
	}
	if(isdefined(level._cybercom_rig_ability[type]) && isdefined(level._cybercom_rig_ability[type].turn_on))
	{
		foreach(turn_on in level._cybercom_rig_ability[type].turn_on)
		{
			self [[turn_on]](type);
		}
	}
}

/*
	Name: turn_rig_ability_off
	Namespace: cybercom_tacrig
	Checksum: 0x80A4C4FF
	Offset: 0x1128
	Size: 0x102
	Parameters: 1
	Flags: Linked
*/
function turn_rig_ability_off(type)
{
	reserveability = self hascybercomrig(type);
	if(reserveability == 0)
	{
		return;
	}
	if(isdefined(level._cybercom_rig_ability[type]) && isdefined(level._cybercom_rig_ability[type].turn_off))
	{
		foreach(turn_off in level._cybercom_rig_ability[type].turn_off)
		{
			self [[turn_off]](type);
		}
	}
}

