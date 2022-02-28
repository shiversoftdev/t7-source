// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace item_drop;

/*
	Name: main
	Namespace: item_drop
	Checksum: 0x19FAE8B3
	Offset: 0x1F8
	Size: 0x5C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	if(!isdefined(level.item_drops))
	{
		level.item_drops = [];
	}
	level thread watch_level_drops();
	wait(0.05);
	callback::on_actor_killed(&actor_killed_check_drops);
}

/*
	Name: add_drop
	Namespace: item_drop
	Checksum: 0x1E0C7D51
	Offset: 0x260
	Size: 0xC0
	Parameters: 3
	Flags: None
*/
function add_drop(name, model, callback)
{
	if(!isdefined(level.item_drops))
	{
		level.item_drops = [];
	}
	if(!isdefined(level.item_drops[name]))
	{
		level.item_drops[name] = spawnstruct();
	}
	level.item_drops[name].name = name;
	level.item_drops[name].model = model;
	level.item_drops[name].callback = callback;
}

/*
	Name: add_drop_onaikilled
	Namespace: item_drop
	Checksum: 0xB3428DA2
	Offset: 0x328
	Size: 0x9C
	Parameters: 2
	Flags: None
*/
function add_drop_onaikilled(name, dropchance)
{
	if(!isdefined(level.item_drops))
	{
		level.item_drops = [];
	}
	if(!isdefined(level.item_drops[name]))
	{
		level.item_drops[name] = spawnstruct();
	}
	level.item_drops[name].name = name;
	level.item_drops[name].onaikilled = dropchance;
}

/*
	Name: add_drop_spawnpoints
	Namespace: item_drop
	Checksum: 0x9CAB6C7A
	Offset: 0x3D0
	Size: 0x9C
	Parameters: 2
	Flags: None
*/
function add_drop_spawnpoints(name, spawnpoints)
{
	if(!isdefined(level.item_drops))
	{
		level.item_drops = [];
	}
	if(!isdefined(level.item_drops[name]))
	{
		level.item_drops[name] = spawnstruct();
	}
	level.item_drops[name].name = name;
	level.item_drops[name].spawnpoints = spawnpoints;
}

/*
	Name: actor_killed_check_drops
	Namespace: item_drop
	Checksum: 0xF325CFDD
	Offset: 0x478
	Size: 0x25C
	Parameters: 1
	Flags: None
*/
function actor_killed_check_drops(params)
{
	if(level.script != "sp_proto_characters" && level.script != "challenge_bloodbath")
	{
		return;
	}
	if(isdefined(self.item_drops_checked) && self.item_drops_checked)
	{
		return;
	}
	self.item_drops_checked = 1;
	drop = array::random(level.item_drops);
	/#
		if(isdefined(drop.onaikilled))
		{
			drop.onaikilled = getdvarfloat("" + drop.name);
		}
	#/
	if(getdvarint("scr_drop_autorecover"))
	{
		killer = self.dds_dmg_attacker;
		if(isdefined(killer))
		{
			if(isdefined(drop.callback))
			{
				multiplier = self actor_drop_multiplier();
				if(!killer [[drop.callback]](multiplier))
				{
					return;
				}
			}
			playsoundatposition("fly_supply_bag_pick_up", killer.origin);
		}
	}
	else if(isdefined(drop.onaikilled) && randomfloat(1) < drop.onaikilled)
	{
		origin = self.origin + vectorscale((0, 0, 1), 30);
		newdrop = spawn_drop(drop, origin);
		newdrop.multiplier = self actor_drop_multiplier();
		level.item_drops_current[level.item_drops_current.size] = newdrop;
		newdrop thread watch_player_pickup();
	}
}

/*
	Name: actor_drop_multiplier
	Namespace: item_drop
	Checksum: 0x66A5E242
	Offset: 0x6E0
	Size: 0xB0
	Parameters: 0
	Flags: None
*/
function actor_drop_multiplier()
{
	min_mult = getdvarfloat("scr_drop_default_min");
	if(isdefined(self.drop_min_multiplier))
	{
		min_mult = self.drop_min_multiplier;
	}
	max_mult = getdvarfloat("scr_drop_default_max");
	if(isdefined(self.drop_max_multiplier))
	{
		max_mult = self.drop_max_multiplier;
	}
	if(min_mult < max_mult)
	{
		return randomfloatrange(min_mult, max_mult);
	}
	return min_mult;
}

/*
	Name: watch_level_drops
	Namespace: item_drop
	Checksum: 0xDAAB1E00
	Offset: 0x798
	Size: 0x120
	Parameters: 0
	Flags: None
*/
function watch_level_drops()
{
	level.item_drops_current = [];
	level flag::wait_till("all_players_spawned");
	while(true)
	{
		wait(15);
		if(level.item_drops_current.size < 1 && level.item_drops.size > 0)
		{
			drop = array::random(level.item_drops);
			if(isdefined(drop.spawnpoints))
			{
				origin = array::random(drop.spawnpoints);
				newdrop = spawn_drop(drop, origin);
				level.item_drops_current[level.item_drops_current.size] = newdrop;
				newdrop thread watch_player_pickup();
			}
		}
	}
}

/*
	Name: spawn_drop
	Namespace: item_drop
	Checksum: 0xC54FFAEF
	Offset: 0x8C0
	Size: 0xF8
	Parameters: 2
	Flags: None
*/
function spawn_drop(drop, origin)
{
	nd = spawnstruct();
	nd.drop = drop;
	nd.origin = origin;
	nd.model = spawn("script_model", nd.origin);
	nd.model setmodel(drop.model);
	nd.model thread spin_it();
	playsoundatposition("fly_supply_bag_drop", origin);
	return nd;
}

/*
	Name: spin_it
	Namespace: item_drop
	Checksum: 0xD60423AA
	Offset: 0x9C0
	Size: 0x76
	Parameters: 0
	Flags: None
*/
function spin_it()
{
	angle = 0;
	time = 0;
	self endon(#"death");
	while(isdefined(self))
	{
		angle = time * 90;
		self.angles = (0, angle, 0);
		wait(0.05);
		time = time + 0.05;
	}
}

/*
	Name: watch_player_pickup
	Namespace: item_drop
	Checksum: 0x30B7D420
	Offset: 0xA40
	Size: 0x9C
	Parameters: 0
	Flags: None
*/
function watch_player_pickup()
{
	trigger = spawn("trigger_radius", self.origin, 0, 60, 60);
	self.pickuptrigger = trigger;
	while(isdefined(self))
	{
		trigger waittill(#"trigger", player);
		if(player thread pickup(self))
		{
			break;
		}
	}
	trigger delete();
}

/*
	Name: pickup
	Namespace: item_drop
	Checksum: 0x28155834
	Offset: 0xAE8
	Size: 0xF0
	Parameters: 1
	Flags: None
*/
function pickup(drop)
{
	if(isdefined(drop.drop.callback))
	{
		multiplier = 1;
		if(isdefined(drop.multiplier))
		{
			multiplier = drop.multiplier;
		}
		if(!self [[drop.drop.callback]](multiplier))
		{
			return false;
		}
	}
	playsoundatposition("fly_supply_bag_pick_up", self.origin);
	drop.model delete();
	arrayremovevalue(level.item_drops_current, drop);
	return true;
}

