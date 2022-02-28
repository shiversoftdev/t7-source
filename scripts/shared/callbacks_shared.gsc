// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\simple_hostmigration;
#using scripts\shared\system_shared;

#namespace callback;

/*
	Name: callback
	Namespace: callback
	Checksum: 0xBF800C51
	Offset: 0x1E8
	Size: 0x134
	Parameters: 2
	Flags: Linked
*/
function callback(event, params)
{
	if(isdefined(level._callbacks) && isdefined(level._callbacks[event]))
	{
		for(i = 0; i < level._callbacks[event].size; i++)
		{
			callback = level._callbacks[event][i][0];
			obj = level._callbacks[event][i][1];
			if(!isdefined(callback))
			{
				continue;
			}
			if(isdefined(obj))
			{
				if(isdefined(params))
				{
					obj thread [[callback]](self, params);
				}
				else
				{
					obj thread [[callback]](self);
				}
				continue;
			}
			if(isdefined(params))
			{
				self thread [[callback]](params);
				continue;
			}
			self thread [[callback]]();
		}
	}
}

/*
	Name: add_callback
	Namespace: callback
	Checksum: 0xF8621DC8
	Offset: 0x328
	Size: 0x18C
	Parameters: 3
	Flags: Linked
*/
function add_callback(event, func, obj)
{
	/#
		assert(isdefined(event), "");
	#/
	if(!isdefined(level._callbacks) || !isdefined(level._callbacks[event]))
	{
		level._callbacks[event] = [];
	}
	foreach(callback in level._callbacks[event])
	{
		if(callback[0] == func)
		{
			if(!isdefined(obj) || callback[1] == obj)
			{
				return;
			}
		}
	}
	array::add(level._callbacks[event], array(func, obj), 0);
	if(isdefined(obj))
	{
		obj thread remove_callback_on_death(event, func);
	}
}

/*
	Name: remove_callback_on_death
	Namespace: callback
	Checksum: 0xE9A29850
	Offset: 0x4C0
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function remove_callback_on_death(event, func)
{
	self waittill(#"death");
	remove_callback(event, func, self);
}

/*
	Name: remove_callback
	Namespace: callback
	Checksum: 0x47454813
	Offset: 0x508
	Size: 0x13E
	Parameters: 3
	Flags: Linked
*/
function remove_callback(event, func, obj)
{
	/#
		assert(isdefined(event), "");
	#/
	/#
		assert(isdefined(level._callbacks[event]), "");
	#/
	foreach(index, func_group in level._callbacks[event])
	{
		if(func_group[0] == func)
		{
			if(func_group[1] === obj)
			{
				arrayremoveindex(level._callbacks[event], index, 0);
				break;
			}
		}
	}
}

/*
	Name: on_finalize_initialization
	Namespace: callback
	Checksum: 0x59FB6166
	Offset: 0x650
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_finalize_initialization(func, obj)
{
	add_callback(#"hash_36fb1b1a", func, obj);
}

/*
	Name: on_connect
	Namespace: callback
	Checksum: 0xA3BB1492
	Offset: 0x690
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_connect(func, obj)
{
	add_callback(#"hash_eaffea17", func, obj);
}

/*
	Name: remove_on_connect
	Namespace: callback
	Checksum: 0x4A68B221
	Offset: 0x6D0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function remove_on_connect(func, obj)
{
	remove_callback(#"hash_eaffea17", func, obj);
}

/*
	Name: on_connecting
	Namespace: callback
	Checksum: 0x21382839
	Offset: 0x710
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_connecting(func, obj)
{
	add_callback(#"hash_fefe13f5", func, obj);
}

/*
	Name: remove_on_connecting
	Namespace: callback
	Checksum: 0xC650034D
	Offset: 0x750
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_connecting(func, obj)
{
	remove_callback(#"hash_fefe13f5", func, obj);
}

/*
	Name: on_disconnect
	Namespace: callback
	Checksum: 0x4F79BAC7
	Offset: 0x790
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_disconnect(func, obj)
{
	add_callback(#"hash_aebdd257", func, obj);
}

/*
	Name: remove_on_disconnect
	Namespace: callback
	Checksum: 0xEEEFC98A
	Offset: 0x7D0
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_disconnect(func, obj)
{
	remove_callback(#"hash_aebdd257", func, obj);
}

/*
	Name: on_spawned
	Namespace: callback
	Checksum: 0xB675CD4E
	Offset: 0x810
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_spawned(func, obj)
{
	add_callback(#"hash_bc12b61f", func, obj);
}

/*
	Name: remove_on_spawned
	Namespace: callback
	Checksum: 0x1B1F5633
	Offset: 0x850
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_spawned(func, obj)
{
	remove_callback(#"hash_bc12b61f", func, obj);
}

/*
	Name: on_loadout
	Namespace: callback
	Checksum: 0x12DE6700
	Offset: 0x890
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_loadout(func, obj)
{
	add_callback(#"hash_33bba039", func, obj);
}

/*
	Name: remove_on_loadout
	Namespace: callback
	Checksum: 0x2B2C56FC
	Offset: 0x8D0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function remove_on_loadout(func, obj)
{
	remove_callback(#"hash_33bba039", func, obj);
}

/*
	Name: on_player_damage
	Namespace: callback
	Checksum: 0x4683F8BD
	Offset: 0x910
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function on_player_damage(func, obj)
{
	add_callback(#"hash_ab5ecf6c", func, obj);
}

/*
	Name: remove_on_player_damage
	Namespace: callback
	Checksum: 0x96EAA2DE
	Offset: 0x950
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_player_damage(func, obj)
{
	remove_callback(#"hash_ab5ecf6c", func, obj);
}

/*
	Name: on_start_gametype
	Namespace: callback
	Checksum: 0x29A20C08
	Offset: 0x990
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_start_gametype(func, obj)
{
	add_callback(#"hash_cc62acca", func, obj);
}

/*
	Name: on_joined_team
	Namespace: callback
	Checksum: 0x8D185449
	Offset: 0x9D0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_joined_team(func, obj)
{
	add_callback(#"hash_95a6c4c0", func, obj);
}

/*
	Name: on_joined_spectate
	Namespace: callback
	Checksum: 0xA955467D
	Offset: 0xA10
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_joined_spectate(func, obj)
{
	add_callback(#"hash_4c5ae192", func, obj);
}

/*
	Name: on_player_killed
	Namespace: callback
	Checksum: 0x48CFDE09
	Offset: 0xA50
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_player_killed(func, obj)
{
	add_callback(#"hash_bc435202", func, obj);
}

/*
	Name: remove_on_player_killed
	Namespace: callback
	Checksum: 0xA9CBF769
	Offset: 0xA90
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_player_killed(func, obj)
{
	remove_callback(#"hash_bc435202", func, obj);
}

/*
	Name: on_ai_killed
	Namespace: callback
	Checksum: 0x1BA9BEF2
	Offset: 0xAD0
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function on_ai_killed(func, obj)
{
	add_callback(#"hash_fc2ec5ff", func, obj);
}

/*
	Name: remove_on_ai_killed
	Namespace: callback
	Checksum: 0x4FA015B1
	Offset: 0xB10
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_ai_killed(func, obj)
{
	remove_callback(#"hash_fc2ec5ff", func, obj);
}

/*
	Name: on_actor_killed
	Namespace: callback
	Checksum: 0x40C25DA0
	Offset: 0xB50
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_actor_killed(func, obj)
{
	add_callback(#"hash_8c38c12e", func, obj);
}

/*
	Name: remove_on_actor_killed
	Namespace: callback
	Checksum: 0x464D37E4
	Offset: 0xB90
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_actor_killed(func, obj)
{
	remove_callback(#"hash_8c38c12e", func, obj);
}

/*
	Name: on_vehicle_spawned
	Namespace: callback
	Checksum: 0xB1A13417
	Offset: 0xBD0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_vehicle_spawned(func, obj)
{
	add_callback(#"hash_bae82b92", func, obj);
}

/*
	Name: remove_on_vehicle_spawned
	Namespace: callback
	Checksum: 0x4E9ADD3B
	Offset: 0xC10
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_vehicle_spawned(func, obj)
{
	remove_callback(#"hash_bae82b92", func, obj);
}

/*
	Name: on_vehicle_killed
	Namespace: callback
	Checksum: 0xF010E8CA
	Offset: 0xC50
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_vehicle_killed(func, obj)
{
	add_callback(#"hash_acb66515", func, obj);
}

/*
	Name: remove_on_vehicle_killed
	Namespace: callback
	Checksum: 0x1019C3F2
	Offset: 0xC90
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_vehicle_killed(func, obj)
{
	remove_callback(#"hash_acb66515", func, obj);
}

/*
	Name: on_ai_damage
	Namespace: callback
	Checksum: 0xA0498752
	Offset: 0xCD0
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function on_ai_damage(func, obj)
{
	add_callback(#"hash_eb4a4369", func, obj);
}

/*
	Name: remove_on_ai_damage
	Namespace: callback
	Checksum: 0x6A025514
	Offset: 0xD10
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_ai_damage(func, obj)
{
	remove_callback(#"hash_eb4a4369", func, obj);
}

/*
	Name: on_ai_spawned
	Namespace: callback
	Checksum: 0xB48F6CED
	Offset: 0xD50
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_ai_spawned(func, obj)
{
	add_callback(#"hash_f96ca9bc", func, obj);
}

/*
	Name: remove_on_ai_spawned
	Namespace: callback
	Checksum: 0x6519D1EE
	Offset: 0xD90
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_ai_spawned(func, obj)
{
	remove_callback(#"hash_f96ca9bc", func, obj);
}

/*
	Name: on_actor_damage
	Namespace: callback
	Checksum: 0xA14636CB
	Offset: 0xDD0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_actor_damage(func, obj)
{
	add_callback(#"hash_7b543e98", func, obj);
}

/*
	Name: remove_on_actor_damage
	Namespace: callback
	Checksum: 0xAFE44382
	Offset: 0xE10
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_actor_damage(func, obj)
{
	remove_callback(#"hash_7b543e98", func, obj);
}

/*
	Name: on_vehicle_damage
	Namespace: callback
	Checksum: 0xB00793E5
	Offset: 0xE50
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_vehicle_damage(func, obj)
{
	add_callback(#"hash_9bd1e27f", func, obj);
}

/*
	Name: remove_on_vehicle_damage
	Namespace: callback
	Checksum: 0x180D0C44
	Offset: 0xE90
	Size: 0x34
	Parameters: 2
	Flags: None
*/
function remove_on_vehicle_damage(func, obj)
{
	remove_callback(#"hash_9bd1e27f", func, obj);
}

/*
	Name: on_laststand
	Namespace: callback
	Checksum: 0x49724D9C
	Offset: 0xED0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_laststand(func, obj)
{
	add_callback(#"hash_6751ab5b", func, obj);
}

/*
	Name: on_challenge_complete
	Namespace: callback
	Checksum: 0xC2655BD9
	Offset: 0xF10
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function on_challenge_complete(func, obj)
{
	add_callback(#"hash_b286c65c", func, obj);
}

/*
	Name: codecallback_preinitialization
	Namespace: callback
	Checksum: 0xD96BE601
	Offset: 0xF50
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function codecallback_preinitialization()
{
	callback(#"hash_ecc6aecf");
	system::run_pre_systems();
}

/*
	Name: codecallback_finalizeinitialization
	Namespace: callback
	Checksum: 0xF10ABC5D
	Offset: 0xF88
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function codecallback_finalizeinitialization()
{
	system::run_post_systems();
	callback(#"hash_36fb1b1a");
}

/*
	Name: add_weapon_damage
	Namespace: callback
	Checksum: 0x8ED56E39
	Offset: 0xFC0
	Size: 0x3E
	Parameters: 2
	Flags: Linked
*/
function add_weapon_damage(weapontype, callback)
{
	if(!isdefined(level.weapon_damage_callback_array))
	{
		level.weapon_damage_callback_array = [];
	}
	level.weapon_damage_callback_array[weapontype] = callback;
}

/*
	Name: callback_weapon_damage
	Namespace: callback
	Checksum: 0x817BF70F
	Offset: 0x1008
	Size: 0xDA
	Parameters: 5
	Flags: None
*/
function callback_weapon_damage(eattacker, einflictor, weapon, meansofdeath, damage)
{
	if(isdefined(level.weapon_damage_callback_array))
	{
		if(isdefined(level.weapon_damage_callback_array[weapon]))
		{
			self thread [[level.weapon_damage_callback_array[weapon]]](eattacker, einflictor, weapon, meansofdeath, damage);
			return true;
		}
		if(isdefined(level.weapon_damage_callback_array[weapon.rootweapon]))
		{
			self thread [[level.weapon_damage_callback_array[weapon.rootweapon]]](eattacker, einflictor, weapon, meansofdeath, damage);
			return true;
		}
	}
	return false;
}

/*
	Name: add_weapon_watcher
	Namespace: callback
	Checksum: 0x39EAFCCA
	Offset: 0x10F0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function add_weapon_watcher(callback)
{
	if(!isdefined(level.weapon_watcher_callback_array))
	{
		level.weapon_watcher_callback_array = [];
	}
	array::add(level.weapon_watcher_callback_array, callback);
}

/*
	Name: callback_weapon_watcher
	Namespace: callback
	Checksum: 0x40668F64
	Offset: 0x1140
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function callback_weapon_watcher()
{
	if(isdefined(level.weapon_watcher_callback_array))
	{
		for(x = 0; x < level.weapon_watcher_callback_array.size; x++)
		{
			self [[level.weapon_watcher_callback_array[x]]]();
		}
	}
}

/*
	Name: codecallback_startgametype
	Namespace: callback
	Checksum: 0xB20B5DFC
	Offset: 0x11A0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function codecallback_startgametype()
{
	if(!isdefined(level.gametypestarted) || !level.gametypestarted)
	{
		[[level.callbackstartgametype]]();
		level.gametypestarted = 1;
	}
}

/*
	Name: codecallback_playerconnect
	Namespace: callback
	Checksum: 0x117EE0D9
	Offset: 0x11E8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function codecallback_playerconnect()
{
	self endon(#"disconnect");
	[[level.callbackplayerconnect]]();
}

/*
	Name: codecallback_playerdisconnect
	Namespace: callback
	Checksum: 0x850DE460
	Offset: 0x1210
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function codecallback_playerdisconnect()
{
	self notify(#"death");
	self.player_disconnected = 1;
	self notify(#"disconnect");
	level notify(#"disconnect", self);
	[[level.callbackplayerdisconnect]]();
	callback(#"hash_aebdd257");
}

/*
	Name: codecallback_migration_setupgametype
	Namespace: callback
	Checksum: 0x7FF90849
	Offset: 0x1280
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function codecallback_migration_setupgametype()
{
	/#
		println("");
	#/
	simple_hostmigration::migration_setupgametype();
}

/*
	Name: codecallback_hostmigration
	Namespace: callback
	Checksum: 0xA3E742C0
	Offset: 0x12C0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function codecallback_hostmigration()
{
	/#
		println("");
	#/
	[[level.callbackhostmigration]]();
}

/*
	Name: codecallback_hostmigrationsave
	Namespace: callback
	Checksum: 0x1DA9CAB5
	Offset: 0x1300
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function codecallback_hostmigrationsave()
{
	/#
		println("");
	#/
	[[level.callbackhostmigrationsave]]();
}

/*
	Name: codecallback_prehostmigrationsave
	Namespace: callback
	Checksum: 0x5BD0D6FD
	Offset: 0x1340
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function codecallback_prehostmigrationsave()
{
	/#
		println("");
	#/
	[[level.callbackprehostmigrationsave]]();
}

/*
	Name: codecallback_playermigrated
	Namespace: callback
	Checksum: 0xEEABBFA5
	Offset: 0x1380
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function codecallback_playermigrated()
{
	/#
		println("");
	#/
	[[level.callbackplayermigrated]]();
}

/*
	Name: codecallback_playerdamage
	Namespace: callback
	Checksum: 0x8F21F542
	Offset: 0x13C0
	Size: 0xB8
	Parameters: 13
	Flags: Linked
*/
function codecallback_playerdamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, vsurfacenormal)
{
	self endon(#"disconnect");
	[[level.callbackplayerdamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, vsurfacenormal);
}

/*
	Name: codecallback_playerkilled
	Namespace: callback
	Checksum: 0x91ABE38A
	Offset: 0x1480
	Size: 0x88
	Parameters: 9
	Flags: Linked
*/
function codecallback_playerkilled(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, timeoffset, deathanimduration)
{
	self endon(#"disconnect");
	[[level.callbackplayerkilled]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, timeoffset, deathanimduration);
}

/*
	Name: codecallback_playerlaststand
	Namespace: callback
	Checksum: 0x3CF3C93E
	Offset: 0x1510
	Size: 0x88
	Parameters: 9
	Flags: Linked
*/
function codecallback_playerlaststand(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, timeoffset, delayoverride)
{
	self endon(#"disconnect");
	[[level.callbackplayerlaststand]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, timeoffset, delayoverride);
}

/*
	Name: codecallback_playermelee
	Namespace: callback
	Checksum: 0x21B2FC39
	Offset: 0x15A0
	Size: 0x7C
	Parameters: 8
	Flags: Linked
*/
function codecallback_playermelee(eattacker, idamage, weapon, vorigin, vdir, boneindex, shieldhit, frombehind)
{
	self endon(#"disconnect");
	[[level.callbackplayermelee]](eattacker, idamage, weapon, vorigin, vdir, boneindex, shieldhit, frombehind);
}

/*
	Name: codecallback_actorspawned
	Namespace: callback
	Checksum: 0x48935066
	Offset: 0x1628
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function codecallback_actorspawned(spawner)
{
	[[level.callbackactorspawned]](spawner);
}

/*
	Name: codecallback_actordamage
	Namespace: callback
	Checksum: 0x1A0221F0
	Offset: 0x1650
	Size: 0xC8
	Parameters: 15
	Flags: Linked
*/
function codecallback_actordamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, modelindex, surfacetype, surfacenormal)
{
	[[level.callbackactordamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, boneindex, modelindex, surfacetype, surfacenormal);
}

/*
	Name: codecallback_actorkilled
	Namespace: callback
	Checksum: 0x2ECFC077
	Offset: 0x1720
	Size: 0x74
	Parameters: 8
	Flags: Linked
*/
function codecallback_actorkilled(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, timeoffset)
{
	[[level.callbackactorkilled]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, timeoffset);
}

/*
	Name: codecallback_actorcloned
	Namespace: callback
	Checksum: 0x7B9FAD6F
	Offset: 0x17A0
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function codecallback_actorcloned(original)
{
	[[level.callbackactorcloned]](original);
}

/*
	Name: codecallback_vehiclespawned
	Namespace: callback
	Checksum: 0xD98FF782
	Offset: 0x17C8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function codecallback_vehiclespawned(spawner)
{
	if(isdefined(level.callbackvehiclespawned))
	{
		[[level.callbackvehiclespawned]](spawner);
	}
}

/*
	Name: codecallback_vehiclekilled
	Namespace: callback
	Checksum: 0x33EDC3BA
	Offset: 0x1800
	Size: 0x74
	Parameters: 8
	Flags: Linked
*/
function codecallback_vehiclekilled(einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	[[level.callbackvehiclekilled]](einflictor, eattacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime);
}

/*
	Name: codecallback_vehicledamage
	Namespace: callback
	Checksum: 0xB692CFA
	Offset: 0x1880
	Size: 0xC8
	Parameters: 15
	Flags: Linked
*/
function codecallback_vehicledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	[[level.callbackvehicledamage]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, timeoffset, damagefromunderneath, modelindex, partname, vsurfacenormal);
}

/*
	Name: codecallback_vehicleradiusdamage
	Namespace: callback
	Checksum: 0xED79F1CC
	Offset: 0x1950
	Size: 0xB0
	Parameters: 13
	Flags: Linked
*/
function codecallback_vehicleradiusdamage(einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, timeoffset)
{
	[[level.callbackvehicleradiusdamage]](einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, weapon, vpoint, fradius, fconeanglecos, vconedir, timeoffset);
}

/*
	Name: finishcustomtraversallistener
	Namespace: callback
	Checksum: 0xAC8C0A8D
	Offset: 0x1A08
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function finishcustomtraversallistener()
{
	self endon(#"death");
	self waittillmatch(#"custom_traversal_anim_finished");
	self finishtraversal();
	self unlink();
	self.usegoalanimweight = 0;
	self.blockingpain = 0;
	self.customtraverseendnode = undefined;
	self.customtraversestartnode = undefined;
	self notify(#"custom_traversal_cleanup", "end");
}

/*
	Name: killedcustomtraversallistener
	Namespace: callback
	Checksum: 0x404E990C
	Offset: 0x1AA0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function killedcustomtraversallistener()
{
	self endon(#"custom_traversal_cleanup");
	self waittill(#"death");
	if(isdefined(self))
	{
		self finishtraversal();
		self stopanimscripted();
		self unlink();
	}
}

/*
	Name: codecallback_playcustomtraversal
	Namespace: callback
	Checksum: 0xE2C15BC
	Offset: 0x1B18
	Size: 0x1BC
	Parameters: 10
	Flags: Linked
*/
function codecallback_playcustomtraversal(entity, beginparent, endparent, origin, angles, animhandle, animmode, playbackspeed, goaltime, lerptime)
{
	entity.blockingpain = 1;
	entity.usegoalanimweight = 1;
	entity.customtraverseendnode = entity.traverseendnode;
	entity.customtraversestartnode = entity.traversestartnode;
	entity animmode("noclip", 0);
	entity orientmode("face angle", angles[1]);
	if(isdefined(endparent))
	{
		offset = entity.origin - endparent.origin;
		entity linkto(endparent, "", offset);
	}
	entity animscripted("custom_traversal_anim_finished", origin, angles, animhandle, animmode, undefined, playbackspeed, goaltime, lerptime);
	entity thread finishcustomtraversallistener();
	entity thread killedcustomtraversallistener();
}

/*
	Name: codecallback_faceeventnotify
	Namespace: callback
	Checksum: 0x8EDE0787
	Offset: 0x1CE0
	Size: 0x94
	Parameters: 2
	Flags: None
*/
function codecallback_faceeventnotify(notify_msg, ent)
{
	if(isdefined(ent) && isdefined(ent.do_face_anims) && ent.do_face_anims)
	{
		if(isdefined(level.face_event_handler) && isdefined(level.face_event_handler.events[notify_msg]))
		{
			ent sendfaceevent(level.face_event_handler.events[notify_msg]);
		}
	}
}

/*
	Name: codecallback_menuresponse
	Namespace: callback
	Checksum: 0x85C5EE2F
	Offset: 0x1D80
	Size: 0xDE
	Parameters: 2
	Flags: Linked
*/
function codecallback_menuresponse(action, arg)
{
	if(!isdefined(level.menuresponsequeue))
	{
		level.menuresponsequeue = [];
		level thread menu_response_queue_pump();
	}
	index = level.menuresponsequeue.size;
	level.menuresponsequeue[index] = spawnstruct();
	level.menuresponsequeue[index].action = action;
	level.menuresponsequeue[index].arg = arg;
	level.menuresponsequeue[index].ent = self;
	level notify(#"menuresponse_queue");
}

/*
	Name: menu_response_queue_pump
	Namespace: callback
	Checksum: 0x1E62D2E1
	Offset: 0x1E68
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function menu_response_queue_pump()
{
	while(true)
	{
		level waittill(#"menuresponse_queue");
		do
		{
			level.menuresponsequeue[0].ent notify(#"menuresponse", level.menuresponsequeue[0].action, level.menuresponsequeue[0].arg);
			arrayremoveindex(level.menuresponsequeue, 0, 0);
			wait(0.05);
		}
		while(level.menuresponsequeue.size > 0);
	}
}

/*
	Name: codecallback_callserverscript
	Namespace: callback
	Checksum: 0x542A4E23
	Offset: 0x1F08
	Size: 0x5A
	Parameters: 3
	Flags: Linked
*/
function codecallback_callserverscript(pself, label, param)
{
	if(!isdefined(level._animnotifyfuncs))
	{
		return;
	}
	if(isdefined(level._animnotifyfuncs[label]))
	{
		pself [[level._animnotifyfuncs[label]]](param);
	}
}

/*
	Name: codecallback_callserverscriptonlevel
	Namespace: callback
	Checksum: 0xB90539AC
	Offset: 0x1F70
	Size: 0x52
	Parameters: 2
	Flags: Linked
*/
function codecallback_callserverscriptonlevel(label, param)
{
	if(!isdefined(level._animnotifyfuncs))
	{
		return;
	}
	if(isdefined(level._animnotifyfuncs[label]))
	{
		level [[level._animnotifyfuncs[label]]](param);
	}
}

/*
	Name: codecallback_launchsidemission
	Namespace: callback
	Checksum: 0xC1A0E47E
	Offset: 0x1FD0
	Size: 0x94
	Parameters: 4
	Flags: Linked
*/
function codecallback_launchsidemission(str_mapname, str_gametype, int_list_index, int_lighting)
{
	switchmap_preload(str_mapname, str_gametype, int_lighting);
	luinotifyevent(&"open_side_mission_countdown", 1, int_list_index);
	wait(10);
	luinotifyevent(&"close_side_mission_countdown");
	switchmap_switch();
}

/*
	Name: codecallback_fadeblackscreen
	Namespace: callback
	Checksum: 0x1C1E0FBB
	Offset: 0x2070
	Size: 0x86
	Parameters: 2
	Flags: Linked
*/
function codecallback_fadeblackscreen(duration, blendtime)
{
	for(i = 0; i < level.players.size; i++)
	{
		if(isdefined(level.players[i]))
		{
			level.players[i] thread hud::fade_to_black_for_x_sec(0, duration, blendtime, blendtime);
		}
	}
}

/*
	Name: codecallback_setactivecybercomability
	Namespace: callback
	Checksum: 0x3F1F9D49
	Offset: 0x2100
	Size: 0x1E
	Parameters: 1
	Flags: Linked
*/
function codecallback_setactivecybercomability(new_ability)
{
	self notify(#"setcybercomability", new_ability);
}

/*
	Name: abort_level
	Namespace: callback
	Checksum: 0x2F23F6EF
	Offset: 0x2128
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function abort_level()
{
	/#
		println("");
	#/
	level.callbackstartgametype = &callback_void;
	level.callbackplayerconnect = &callback_void;
	level.callbackplayerdisconnect = &callback_void;
	level.callbackplayerdamage = &callback_void;
	level.callbackplayerkilled = &callback_void;
	level.callbackplayerlaststand = &callback_void;
	level.callbackplayermelee = &callback_void;
	level.callbackactordamage = &callback_void;
	level.callbackactorkilled = &callback_void;
	level.callbackvehicledamage = &callback_void;
	level.callbackvehiclekilled = &callback_void;
	level.callbackactorspawned = &callback_void;
	level.callbackbotentereduseredge = &callback_void;
	if(isdefined(level._gametype_default))
	{
		setdvar("g_gametype", level._gametype_default);
	}
	exitlevel(0);
}

/*
	Name: codecallback_glasssmash
	Namespace: callback
	Checksum: 0x7E7088B0
	Offset: 0x22D8
	Size: 0x2A
	Parameters: 2
	Flags: Linked
*/
function codecallback_glasssmash(pos, dir)
{
	level notify(#"glass_smash", pos, dir);
}

/*
	Name: codecallback_botentereduseredge
	Namespace: callback
	Checksum: 0x3EB81165
	Offset: 0x2310
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function codecallback_botentereduseredge(startnode, endnode)
{
	[[level.callbackbotentereduseredge]](startnode, endnode);
}

/*
	Name: codecallback_decoration
	Namespace: callback
	Checksum: 0x23BE3DEA
	Offset: 0x2348
	Size: 0xD0
	Parameters: 1
	Flags: Linked
*/
function codecallback_decoration(name)
{
	a_decorations = self getdecorations(1);
	if(!isdefined(a_decorations))
	{
		return;
	}
	if(a_decorations.size == 12)
	{
		self notify(#"give_achievement", "CP_ALL_DECORATIONS");
	}
	a_all_decorations = self getdecorations();
	if(a_decorations.size == (a_all_decorations.size - 1))
	{
		self givedecoration("cp_medal_all_decorations");
	}
	level notify(#"decoration_awarded");
	[[level.callbackdecorationawarded]]();
}

/*
	Name: callback_void
	Namespace: callback
	Checksum: 0x99EC1590
	Offset: 0x2420
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function callback_void()
{
}

