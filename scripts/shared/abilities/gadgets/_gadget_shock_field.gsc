// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace _gadget_shock_field;

/*
	Name: __init__sytem__
	Namespace: _gadget_shock_field
	Checksum: 0x16894BC6
	Offset: 0x260
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_shock_field", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_shock_field
	Checksum: 0x552495A1
	Offset: 0x2A0
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("allplayers", "shock_field", 1, 1, "int");
	ability_player::register_gadget_activation_callbacks(39, &gadget_shock_field_on, &gadget_shock_field_off);
	ability_player::register_gadget_possession_callbacks(39, &gadget_shock_field_on_give, &gadget_shock_field_on_take);
	ability_player::register_gadget_flicker_callbacks(39, &gadget_shock_field_on_flicker);
	ability_player::register_gadget_is_inuse_callbacks(39, &gadget_shock_field_is_inuse);
	ability_player::register_gadget_is_flickering_callbacks(39, &gadget_shock_field_is_flickering);
	callback::on_connect(&gadget_shock_field_on_connect);
}

/*
	Name: gadget_shock_field_is_inuse
	Namespace: _gadget_shock_field
	Checksum: 0x5BAE1465
	Offset: 0x3C0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gadget_shock_field_is_inuse(slot)
{
	return self gadgetisactive(slot);
}

/*
	Name: gadget_shock_field_is_flickering
	Namespace: _gadget_shock_field
	Checksum: 0x295742D3
	Offset: 0x3F0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function gadget_shock_field_is_flickering(slot)
{
}

/*
	Name: gadget_shock_field_on_flicker
	Namespace: _gadget_shock_field
	Checksum: 0x388F0484
	Offset: 0x408
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function gadget_shock_field_on_flicker(slot, weapon)
{
}

/*
	Name: gadget_shock_field_on_give
	Namespace: _gadget_shock_field
	Checksum: 0x61BF7317
	Offset: 0x428
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_shock_field_on_give(slot, weapon)
{
	self clientfield::set("shock_field", 0);
}

/*
	Name: gadget_shock_field_on_take
	Namespace: _gadget_shock_field
	Checksum: 0x8C45E4C6
	Offset: 0x468
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function gadget_shock_field_on_take(slot, weapon)
{
	self clientfield::set("shock_field", 0);
}

/*
	Name: gadget_shock_field_on_connect
	Namespace: _gadget_shock_field
	Checksum: 0x99EC1590
	Offset: 0x4A8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function gadget_shock_field_on_connect()
{
}

/*
	Name: gadget_shock_field_on
	Namespace: _gadget_shock_field
	Checksum: 0x78865025
	Offset: 0x4B8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function gadget_shock_field_on(slot, weapon)
{
	self gadgetsetactivatetime(slot, gettime());
	self thread shock_field_think(slot, weapon);
	self clientfield::set("shock_field", 1);
}

/*
	Name: gadget_shock_field_off
	Namespace: _gadget_shock_field
	Checksum: 0x3F54A044
	Offset: 0x530
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function gadget_shock_field_off(slot, weapon)
{
	self notify(#"shock_field_off");
	self clientfield::set("shock_field", 0);
}

/*
	Name: shock_field_think
	Namespace: _gadget_shock_field
	Checksum: 0x3647E524
	Offset: 0x580
	Size: 0x2DE
	Parameters: 2
	Flags: Linked
*/
function shock_field_think(slot, weapon)
{
	self endon(#"shock_field_off");
	self notify(#"shock_field_on");
	self endon(#"shock_field_on");
	while(true)
	{
		wait(0.25);
		if(!self gadget_shock_field_is_inuse(slot))
		{
			return;
		}
		entities = getdamageableentarray(self.origin, weapon.gadget_shockfield_radius);
		foreach(entity in entities)
		{
			if(isplayer(entity))
			{
				if(self getentitynumber() == entity getentitynumber())
				{
					continue;
				}
				if(self.team == entity.team)
				{
					continue;
				}
				if(!isalive(entity))
				{
					continue;
				}
				if(bullettracepassed(self.origin + vectorscale((0, 0, 1), 30), entity.origin + vectorscale((0, 0, 1), 30), 1, self, undefined, 0, 1))
				{
					entity dodamage(weapon.gadget_shockfield_damage, self.origin + vectorscale((0, 0, 1), 30), self, self, 0, "MOD_GRENADE_SPLASH");
					entity setdoublejumpenergy(0);
					entity resetdoublejumprechargetime();
					entity thread shock_field_zap_sound(weapon);
					self thread flicker_field_fx();
					shellshock_duration = 0.25;
					if(entity util::mayapplyscreeneffect())
					{
						shellshock_duration = 0.5;
						entity shellshock("proximity_grenade", shellshock_duration, 0);
					}
				}
			}
		}
	}
}

/*
	Name: shock_field_zap_sound
	Namespace: _gadget_shock_field
	Checksum: 0x852D1FA3
	Offset: 0x868
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function shock_field_zap_sound(weapon)
{
	if(isdefined(self.shock_field_zap_sound) && self.shock_field_zap_sound)
	{
		return;
	}
	self.shock_field_zap_sound = 1;
	self playsound("wpn_taser_mine_zap");
	wait(1);
	if(isdefined(self))
	{
		self.shock_field_zap_sound = 0;
	}
}

/*
	Name: flicker_field_fx
	Namespace: _gadget_shock_field
	Checksum: 0x3B5B5E28
	Offset: 0x8D8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function flicker_field_fx()
{
	self endon(#"shock_field_off");
	self notify(#"flicker_field_fx");
	self endon(#"flicker_field_fx");
	self clientfield::set("shock_field", 0);
	wait(randomfloatrange(0.03, 0.23));
	if(isdefined(self))
	{
		self clientfield::set("shock_field", 1);
	}
}

