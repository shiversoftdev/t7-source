// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\shared\_oob;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\load_shared;
#using scripts\shared\player_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#namespace savegame;

/*
	Name: __init__sytem__
	Namespace: savegame
	Checksum: 0x941DE505
	Offset: 0x348
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("save", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: savegame
	Checksum: 0xA7F8EFEA
	Offset: 0x388
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!isdefined(world.loadout))
	{
		world.loadout = [];
	}
	if(!isdefined(world.mapdata))
	{
		world.mapdata = [];
	}
	if(!isdefined(world.playerdata))
	{
		world.playerdata = [];
	}
	foreach(trig in trigger::get_all())
	{
		if(isdefined(trig.var_d981bb2d) && trig.var_d981bb2d)
		{
			trig thread checkpoint_trigger();
		}
	}
	level.var_67e1f60e = [];
}

/*
	Name: save
	Namespace: savegame
	Checksum: 0x10F70FC8
	Offset: 0x4B0
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function save()
{
	if(!isdefined(world.loadout))
	{
		world.loadout = [];
	}
}

/*
	Name: load
	Namespace: savegame
	Checksum: 0x99EC1590
	Offset: 0x4D8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function load()
{
}

/*
	Name: set_mission_name
	Namespace: savegame
	Checksum: 0xFFAAD58A
	Offset: 0x4E8
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function set_mission_name(name)
{
	if(isdefined(level.savename) && level.savename != name)
	{
		/#
			errormsg(((("" + level.savename) + "") + name) + "");
		#/
	}
	level.savename = name;
}

/*
	Name: get_mission_name
	Namespace: savegame
	Checksum: 0x6AF5884B
	Offset: 0x568
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function get_mission_name()
{
	if(!isdefined(level.savename))
	{
		set_mission_name(level.script);
	}
	return level.savename;
}

/*
	Name: set_mission_data
	Namespace: savegame
	Checksum: 0x5D629A5E
	Offset: 0x5A8
	Size: 0x90
	Parameters: 2
	Flags: None
*/
function set_mission_data(name, value)
{
	id = get_mission_name();
	if(!isdefined(world.mapdata))
	{
		world.mapdata = [];
	}
	if(!isdefined(world.mapdata[id]))
	{
		world.mapdata[id] = [];
	}
	world.mapdata[id][name] = value;
}

/*
	Name: get_mission_data
	Namespace: savegame
	Checksum: 0x633206B1
	Offset: 0x640
	Size: 0x8C
	Parameters: 2
	Flags: None
*/
function get_mission_data(name, defval)
{
	id = get_mission_name();
	if(isdefined(world.mapdata) && isdefined(world.mapdata[id]) && isdefined(world.mapdata[id][name]))
	{
		return world.mapdata[id][name];
	}
	return defval;
}

/*
	Name: clear_mission_data
	Namespace: savegame
	Checksum: 0xA4EE0264
	Offset: 0x6D8
	Size: 0x5A
	Parameters: 0
	Flags: None
*/
function clear_mission_data()
{
	id = get_mission_name();
	if(isdefined(world.mapdata) && isdefined(world.mapdata[id]))
	{
		world.mapdata[id] = [];
	}
}

/*
	Name: get_player_unique_id
	Namespace: savegame
	Checksum: 0x40514082
	Offset: 0x740
	Size: 0xA
	Parameters: 0
	Flags: Linked, Private
*/
function private get_player_unique_id()
{
	return self.playername;
}

/*
	Name: set_player_data
	Namespace: savegame
	Checksum: 0xAAD627EC
	Offset: 0x758
	Size: 0x142
	Parameters: 2
	Flags: Linked
*/
function set_player_data(name, value)
{
	if(sessionmodeiscampaignzombiesgame())
	{
		var_98e91480 = "offline";
		if(sessionmodeisonlinegame())
		{
			var_98e91480 = "online";
		}
		var_c98fc56a = "CPZM" + var_98e91480;
	}
	else
	{
		var_c98fc56a = "CP";
	}
	id = self get_player_unique_id();
	if(!isdefined(world.playerdata))
	{
		world.playerdata = [];
	}
	if(!isdefined(world.playerdata[var_c98fc56a]))
	{
		world.playerdata[var_c98fc56a] = [];
	}
	if(!isdefined(world.playerdata[var_c98fc56a][id]))
	{
		world.playerdata[var_c98fc56a][id] = [];
	}
	world.playerdata[var_c98fc56a][id][name] = value;
}

/*
	Name: get_player_data
	Namespace: savegame
	Checksum: 0xC99594FE
	Offset: 0x8A8
	Size: 0x12A
	Parameters: 2
	Flags: Linked
*/
function get_player_data(name, defval)
{
	if(sessionmodeiscampaignzombiesgame())
	{
		var_98e91480 = "offline";
		if(sessionmodeisonlinegame())
		{
			var_98e91480 = "online";
		}
		var_c98fc56a = "CPZM" + var_98e91480;
	}
	else
	{
		var_c98fc56a = "CP";
	}
	id = self get_player_unique_id();
	if(isdefined(world.playerdata) && isdefined(world.playerdata[var_c98fc56a]) && isdefined(world.playerdata[var_c98fc56a][id]) && isdefined(world.playerdata[var_c98fc56a][id][name]))
	{
		return world.playerdata[var_c98fc56a][id][name];
	}
	return defval;
}

/*
	Name: clear_player_data
	Namespace: savegame
	Checksum: 0xEB4B79E7
	Offset: 0x9E0
	Size: 0xD2
	Parameters: 0
	Flags: None
*/
function clear_player_data()
{
	if(sessionmodeiscampaignzombiesgame())
	{
		var_98e91480 = "offline";
		if(sessionmodeisonlinegame())
		{
			var_98e91480 = "online";
		}
		var_c98fc56a = "CPZM" + var_98e91480;
	}
	else
	{
		var_c98fc56a = "CP";
	}
	id = self get_player_unique_id();
	if(isdefined(world.playerdata) && isdefined(world.playerdata[var_c98fc56a]))
	{
		world.playerdata[var_c98fc56a] = [];
	}
}

/*
	Name: function_37ae30c6
	Namespace: savegame
	Checksum: 0x8CB05BA6
	Offset: 0xAC0
	Size: 0x24A
	Parameters: 0
	Flags: Linked
*/
function function_37ae30c6()
{
	if(sessionmodeiscampaignzombiesgame())
	{
		var_98e91480 = "offline";
		if(sessionmodeisonlinegame())
		{
			var_98e91480 = "online";
		}
		var_c98fc56a = "CPZM" + var_98e91480;
	}
	else
	{
		var_c98fc56a = "CP";
	}
	if(!isdefined(world.playerdata))
	{
		world.playerdata = [];
	}
	if(!isdefined(world.playerdata[var_c98fc56a]))
	{
		world.playerdata[var_c98fc56a] = [];
	}
	keys = getarraykeys(world.playerdata[var_c98fc56a]);
	if(isdefined(keys))
	{
		foreach(key in keys)
		{
			key_found = 0;
			foreach(player in level.players)
			{
				if(key === player get_player_unique_id())
				{
					key_found = 1;
					break;
				}
			}
			if(!key_found)
			{
				arrayremoveindex(world.playerdata[var_c98fc56a], key, 1);
			}
		}
	}
}

/*
	Name: function_f6ab8f28
	Namespace: savegame
	Checksum: 0x89B48C00
	Offset: 0xD18
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function function_f6ab8f28()
{
	return getdvarint("ui_blocksaves", 1) == 0;
}

/*
	Name: function_fb150717
	Namespace: savegame
	Checksum: 0x3F0242E0
	Offset: 0xD48
	Size: 0x4C
	Parameters: 0
	Flags: None
*/
function function_fb150717()
{
	if(isdefined(level.var_cc93e6eb) && level.var_cc93e6eb || getdvarint("scr_no_checkpoints", 0))
	{
		return;
	}
	level thread function_74fcb9ca();
}

/*
	Name: function_74fcb9ca
	Namespace: savegame
	Checksum: 0x7B915531
	Offset: 0xDA0
	Size: 0x8C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_74fcb9ca()
{
	level notify(#"checkpoint_save");
	level endon(#"checkpoint_save");
	level endon(#"save_restore");
	checkpointcreate();
	wait(0.05);
	wait(0.05);
	checkpointcommit();
	show_checkpoint_reached();
	level thread function_152fdd8c(0);
}

/*
	Name: checkpoint_trigger
	Namespace: savegame
	Checksum: 0xC87FDA4F
	Offset: 0xE38
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function checkpoint_trigger()
{
	self endon(#"death");
	self waittill(#"trigger");
	checkpoint_save();
}

/*
	Name: checkpoint_save
	Namespace: savegame
	Checksum: 0x82F1B4C4
	Offset: 0xE70
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function checkpoint_save(var_c36855a9 = 0)
{
	level thread function_1add9d4a(var_c36855a9);
}

/*
	Name: show_checkpoint_reached
	Namespace: savegame
	Checksum: 0x99EC1590
	Offset: 0xEB0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function show_checkpoint_reached()
{
}

/*
	Name: function_152fdd8c
	Namespace: savegame
	Checksum: 0x3A937828
	Offset: 0xEC0
	Size: 0x29C
	Parameters: 1
	Flags: Linked
*/
function function_152fdd8c(delay)
{
	if(function_f6ab8f28())
	{
		wait(0.2);
		foreach(player in level.players)
		{
			player player::generate_weapon_data();
			player set_player_data("saved_weapon", player._generated_current_weapon.name);
			player set_player_data("saved_weapondata", player._generated_weapons);
			player set_player_data("lives", player.lives);
			player._generated_current_weapon = undefined;
			player._generated_weapons = undefined;
		}
		player = util::gethostplayer();
		if(isdefined(player))
		{
			player set_player_data("savegame_score", player.pers["score"]);
			player set_player_data("savegame_kills", player.pers["kills"]);
			player set_player_data("savegame_assists", player.pers["assists"]);
			player set_player_data("savegame_incaps", player.pers["incaps"]);
			player set_player_data("savegame_revives", player.pers["revives"]);
		}
		savegame_create();
		wait(delay);
		if(isdefined(player))
		{
			util::show_event_message(player, &"COOP_REACHED_SKIPTO");
		}
	}
}

/*
	Name: function_319d38eb
	Namespace: savegame
	Checksum: 0x856B9D76
	Offset: 0x1168
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function function_319d38eb()
{
	if(isdefined(level.missionfailed) && level.missionfailed)
	{
		return false;
	}
	foreach(player in level.players)
	{
		if(!isalive(player))
		{
			return false;
		}
		if(player clientfield::get("burn"))
		{
			return false;
		}
		if(player laststand::player_is_in_laststand())
		{
			return false;
		}
		if(player.sessionstate == "spectator")
		{
			if(isdefined(self.firstspawn))
			{
				return false;
			}
			return true;
		}
		if(player oob::isoutofbounds())
		{
			return false;
		}
		if(isdefined(player.burning) && player.burning)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_1add9d4a
	Namespace: savegame
	Checksum: 0x46ADFA6B
	Offset: 0x12E0
	Size: 0x13C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_1add9d4a(var_c36855a9)
{
	level notify(#"hash_1add9d4a");
	level endon(#"hash_1add9d4a");
	level endon(#"kill_save");
	level endon(#"save_restore");
	wait(0.1);
	while(true)
	{
		if(function_147f4ca3())
		{
			wait(0.1);
			checkpointcreate();
			wait(6);
			for(var_e2502f23 = 0; var_e2502f23 < 5; var_e2502f23++)
			{
				if(function_319d38eb())
				{
					break;
				}
				wait(1);
			}
			if(var_e2502f23 == 5)
			{
				continue;
			}
			checkpointcommit();
			show_checkpoint_reached();
			if(var_c36855a9)
			{
				level thread function_152fdd8c(1.5);
			}
			return;
		}
		wait(1);
	}
}

/*
	Name: function_147f4ca3
	Namespace: savegame
	Checksum: 0xF03359C1
	Offset: 0x1428
	Size: 0x1F0
	Parameters: 0
	Flags: Linked
*/
function function_147f4ca3()
{
	if(isdefined(level.var_cc93e6eb) && level.var_cc93e6eb)
	{
		return false;
	}
	if(getdvarint("scr_no_checkpoints", 0))
	{
		return false;
	}
	if(isdefined(level.missionfailed) && level.missionfailed)
	{
		return false;
	}
	var_3d59bfa3 = 0;
	foreach(player in level.players)
	{
		if(player function_2c89c30c())
		{
			var_3d59bfa3++;
		}
	}
	var_24cd4120 = level.players.size;
	if(var_3d59bfa3 < var_24cd4120)
	{
		return false;
	}
	if(!function_8dc86b60())
	{
		return false;
	}
	if(!function_a3a9b003())
	{
		return false;
	}
	if(isdefined(level.var_67e1f60e))
	{
		foreach(func in level.var_67e1f60e)
		{
			if(!level [[func]]())
			{
				return false;
			}
		}
	}
	return true;
}

/*
	Name: function_2c89c30c
	Namespace: savegame
	Checksum: 0xF56B5C4E
	Offset: 0x1620
	Size: 0x266
	Parameters: 0
	Flags: Linked, Private
*/
function private function_2c89c30c()
{
	healthfraction = 1;
	if(isdefined(self.health) && isdefined(self.maxhealth) && self.maxhealth > 0)
	{
		healthfraction = self.health / self.maxhealth;
	}
	if(healthfraction < 0.7)
	{
		return false;
	}
	if(isdefined(self.lastdamagetime) && self.lastdamagetime > (gettime() - 1500))
	{
		return false;
	}
	if(self clientfield::get("burn"))
	{
		return false;
	}
	if(self ismeleeing())
	{
		return false;
	}
	if(self isthrowinggrenade())
	{
		return false;
	}
	if(self isfiring())
	{
		return false;
	}
	if(self util::isflashed())
	{
		return false;
	}
	if(self laststand::player_is_in_laststand())
	{
		return false;
	}
	if(self.sessionstate == "spectator")
	{
		if(isdefined(self.firstspawn))
		{
			return false;
		}
		return true;
	}
	if(self oob::isoutofbounds())
	{
		return false;
	}
	if(isdefined(self.burning) && self.burning)
	{
		return false;
	}
	if(self flagsys::get("mobile_armory_in_use"))
	{
		return false;
	}
	foreach(weapon in self getweaponslist())
	{
		fraction = self getfractionmaxammo(weapon);
		if(fraction > 0.1)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_a3a9b003
	Namespace: savegame
	Checksum: 0x640ECE73
	Offset: 0x1890
	Size: 0x184
	Parameters: 0
	Flags: Linked, Private
*/
function private function_a3a9b003()
{
	if(!getdvarint("tu1_saveGameAiProximityCheck", 1))
	{
		return true;
	}
	ais = getaiteamarray("axis");
	foreach(ai in ais)
	{
		if(!isdefined(ai))
		{
			continue;
		}
		if(!isalive(ai))
		{
			continue;
		}
		if(isactor(ai) && ai isinscriptedstate())
		{
			continue;
		}
		if(isdefined(ai.ignoreall) && ai.ignoreall)
		{
			continue;
		}
		playerproximity = ai function_2808d83d();
		if(playerproximity <= 80)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: function_f70dd749
	Namespace: savegame
	Checksum: 0x800E3BA6
	Offset: 0x1A20
	Size: 0x126
	Parameters: 0
	Flags: Private
*/
function private function_f70dd749()
{
	if(!isdefined(self.enemy))
	{
		return true;
	}
	if(!isplayer(self.enemy))
	{
		return true;
	}
	if(isdefined(self.melee) && isdefined(self.melee.target) && isplayer(self.melee.target))
	{
		return false;
	}
	playerproximity = self function_2808d83d();
	if(playerproximity < 500)
	{
		return false;
	}
	if(playerproximity > 1000 || playerproximity < 0)
	{
		return true;
	}
	if(isactor(self) && self cansee(self.enemy) && self canshootenemy())
	{
		return false;
	}
	return true;
}

/*
	Name: function_2808d83d
	Namespace: savegame
	Checksum: 0x3D97FDB9
	Offset: 0x1B50
	Size: 0xDE
	Parameters: 0
	Flags: Linked
*/
function function_2808d83d()
{
	mindist = -1;
	foreach(player in level.activeplayers)
	{
		dist = distance(player.origin, self.origin);
		if(dist < mindist || mindist < 0)
		{
			mindist = dist;
		}
	}
	return mindist;
}

/*
	Name: function_8dc86b60
	Namespace: savegame
	Checksum: 0xDE2A5E1F
	Offset: 0x1C38
	Size: 0x182
	Parameters: 0
	Flags: Linked, Private
*/
function private function_8dc86b60()
{
	var_db6b9d9f = 0;
	foreach(grenade in getentarray("grenade", "classname"))
	{
		foreach(player in level.activeplayers)
		{
			distsq = distancesquared(grenade.origin, player.origin);
			if(distsq < 90000)
			{
				var_db6b9d9f++;
			}
		}
	}
	if(var_db6b9d9f > 0 && var_db6b9d9f >= level.activeplayers.size)
	{
		return false;
	}
	return true;
}

