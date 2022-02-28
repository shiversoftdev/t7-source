// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_equip_shield;

/*
	Name: __init__sytem__
	Namespace: zm_equip_shield
	Checksum: 0xAF4A170C
	Offset: 0x1A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_equip_shield", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_equip_shield
	Checksum: 0x9D74529D
	Offset: 0x1E0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_spawned(&player_on_spawned);
	clientfield::register("clientuimodel", "zmInventory.shield_health", 11000, 4, "float", undefined, 0, 0);
}

/*
	Name: player_on_spawned
	Namespace: zm_equip_shield
	Checksum: 0x4F5C2330
	Offset: 0x248
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function player_on_spawned(localclientnum)
{
	self thread watch_weapon_changes(localclientnum);
}

/*
	Name: watch_weapon_changes
	Namespace: zm_equip_shield
	Checksum: 0x90B7D12E
	Offset: 0x278
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function watch_weapon_changes(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	while(isdefined(self))
	{
		self waittill(#"weapon_change", weapon);
		if(weapon.isriotshield)
		{
			self thread lock_weapon_models(localclientnum, weapon);
		}
	}
}

/*
	Name: lock_weapon_model
	Namespace: zm_equip_shield
	Checksum: 0x231A3FD1
	Offset: 0x2F8
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
	Namespace: zm_equip_shield
	Checksum: 0xAEE39B61
	Offset: 0x398
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
	Name: lock_weapon_models
	Namespace: zm_equip_shield
	Checksum: 0x5BAE0BAE
	Offset: 0x438
	Size: 0x104
	Parameters: 2
	Flags: Linked
*/
function lock_weapon_models(localclientnum, weapon)
{
	lock_weapon_model(weapon.worlddamagedmodel1);
	lock_weapon_model(weapon.worlddamagedmodel2);
	lock_weapon_model(weapon.worlddamagedmodel3);
	self util::waittill_any("weapon_change", "disconnect", "entityshutdown");
	unlock_weapon_model(weapon.worlddamagedmodel1);
	unlock_weapon_model(weapon.worlddamagedmodel2);
	unlock_weapon_model(weapon.worlddamagedmodel3);
}

