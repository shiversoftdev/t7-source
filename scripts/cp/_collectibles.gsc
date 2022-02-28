// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_challenges;
#using scripts\cp\_objectives;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_save;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace collectibles;

/*
	Name: __init__sytem__
	Namespace: collectibles
	Checksum: 0x12E3FC4C
	Offset: 0x338
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("collectibles", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: collectibles
	Checksum: 0x2EB0B64
	Offset: 0x380
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.mission_name = getmissionname();
	level.map_name = getrootmapname();
	level.var_3efe1e22 = [];
}

/*
	Name: __main__
	Namespace: collectibles
	Checksum: 0x973F638E
	Offset: 0x3C8
	Size: 0x1D2
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level.collectibles = [];
	mdl_collectibles = getentarray("collectible", "script_noteworthy");
	if(mdl_collectibles.size == 0)
	{
		return;
	}
	if(!function_148c7e54())
	{
		foreach(mdl_collectible in mdl_collectibles)
		{
			collectible = function_8765a33c(mdl_collectible);
			array::add(level.collectibles, collectible, 0);
		}
		callback::on_spawned(&on_player_spawned);
		callback::on_connect(&on_player_connect);
	}
	else
	{
		foreach(mdl_collectible in mdl_collectibles)
		{
			mdl_collectible hide();
		}
	}
}

/*
	Name: function_37aecd21
	Namespace: collectibles
	Checksum: 0x5D3EEB48
	Offset: 0x5A8
	Size: 0xF6
	Parameters: 0
	Flags: None
*/
function function_37aecd21()
{
	if(!isdefined(level.collectibles))
	{
		return;
	}
	foreach(collectible in level.collectibles)
	{
		var_3efe1e22 = level.var_3efe1e22[collectible.mdl_collectible.model];
		if(isdefined(var_3efe1e22))
		{
			collectible.trigger.origin = collectible.trigger.origin + var_3efe1e22.offset;
		}
	}
}

/*
	Name: function_93523442
	Namespace: collectibles
	Checksum: 0xEF876F8D
	Offset: 0x6A8
	Size: 0xB4
	Parameters: 3
	Flags: None
*/
function function_93523442(var_977e0f67, radius = 60, offset = (0, 0, 0))
{
	if(!isdefined(level.var_3efe1e22[var_977e0f67]))
	{
		level.var_3efe1e22[var_977e0f67] = spawnstruct();
	}
	level.var_3efe1e22[var_977e0f67].radius = radius;
	level.var_3efe1e22[var_977e0f67].offset = offset;
}

/*
	Name: function_148c7e54
	Namespace: collectibles
	Checksum: 0x5BACD759
	Offset: 0x768
	Size: 0x2A
	Parameters: 0
	Flags: Linked, Private
*/
function private function_148c7e54()
{
	return isdefined(level.var_bca96223) && level.var_bca96223 || sessionmodeiscampaignzombiesgame();
}

/*
	Name: on_player_spawned
	Namespace: collectibles
	Checksum: 0x976820EC
	Offset: 0x7A0
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	if(!isdefined(self.var_b3dc8451))
	{
		self.var_b3dc8451 = [];
	}
	foreach(collectible in level.collectibles)
	{
		if(self getdstat("PlayerStatsByMap", level.map_name, "collectibles", collectible.index))
		{
			self.var_b3dc8451[collectible.mdl_collectible.model] = 1;
			collectible.mdl_collectible setinvisibletoplayer(self);
			objective_setinvisibletoplayer(collectible.objectiveid, self);
			collectible.trigger setinvisibletoplayer(self);
			continue;
		}
		self.var_b3dc8451[collectible.mdl_collectible.model] = 0;
	}
	self function_3955ccef();
}

/*
	Name: on_player_connect
	Namespace: collectibles
	Checksum: 0x3B028329
	Offset: 0x970
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	self thread function_332e2cfd();
}

/*
	Name: function_6ba0709f
	Namespace: collectibles
	Checksum: 0x724B6757
	Offset: 0x998
	Size: 0x80
	Parameters: 0
	Flags: None
*/
function function_6ba0709f()
{
	self endon(#"disconnect");
	if(!missionhascollectibles(getrootmapname()))
	{
		return;
	}
	while(true)
	{
		level util::waittill_any("checkpoint_save", "_checkpoint_save_safe");
		self function_d100c544();
	}
}

/*
	Name: function_332e2cfd
	Namespace: collectibles
	Checksum: 0x5EC59084
	Offset: 0xA20
	Size: 0x368
	Parameters: 0
	Flags: Linked
*/
function function_332e2cfd()
{
	self endon(#"disconnect");
	if(!missionhascollectibles(getrootmapname()))
	{
		return;
	}
	while(true)
	{
		level waittill(#"save_restore");
		if(!isdefined(self.var_b3dc8451))
		{
			self.var_b3dc8451 = [];
		}
		foreach(collectible in level.collectibles)
		{
			var_6b074374 = self function_70b41d41(collectible.index);
			has_collectible = self getdstat("PlayerStatsByMap", level.map_name, "collectibles", collectible.index);
			if(isdefined(var_6b074374) && var_6b074374 && (!(isdefined(has_collectible) && has_collectible)))
			{
				self.var_b3dc8451[collectible.mdl_collectible.model] = 1;
				collectible.mdl_collectible setinvisibletoplayer(self);
				objective_setinvisibletoplayer(collectible.objectiveid, self);
				collectible.trigger setinvisibletoplayer(self);
				self setdstat("PlayerStatsByMap", level.map_name, "collectibles", collectible.index, 1);
				self addrankxpvalue("picked_up_collectible", 500);
				uploadstats(self);
				self function_a8d8b9c7();
				self challenges::function_96ed590f("career_collectibles");
				continue;
			}
			if(!(isdefined(self getdstat("PlayerStatsByMap", level.map_name, "collectibles", collectible.index)) && self getdstat("PlayerStatsByMap", level.map_name, "collectibles", collectible.index)))
			{
				self.var_b3dc8451[collectible.mdl_collectible.model] = 0;
			}
		}
		self function_a8d8b9c7();
	}
}

/*
	Name: function_b963f25
	Namespace: collectibles
	Checksum: 0x7B07F2F9
	Offset: 0xD90
	Size: 0xB8
	Parameters: 1
	Flags: Linked, Private
*/
function private function_b963f25(mdl_collectible)
{
	mdl_collectible.radius = 60;
	mdl_collectible.offset = vectorscale((0, 0, 1), 5);
	var_3efe1e22 = level.var_3efe1e22[mdl_collectible.model];
	if(isdefined(var_3efe1e22))
	{
		mdl_collectible.radius = var_3efe1e22.radius;
		mdl_collectible.offset = mdl_collectible.offset + var_3efe1e22.offset;
	}
	return mdl_collectible;
}

/*
	Name: function_8765a33c
	Namespace: collectibles
	Checksum: 0x50815F5B
	Offset: 0xE50
	Size: 0x33C
	Parameters: 1
	Flags: Linked
*/
function function_8765a33c(mdl_collectible)
{
	mdl_collectible = function_b963f25(mdl_collectible);
	trigger_use = spawn("trigger_radius_use", mdl_collectible.origin + mdl_collectible.offset, 0, mdl_collectible.radius, mdl_collectible.radius);
	trigger_use triggerignoreteam();
	trigger_use setvisibletoall();
	trigger_use usetriggerrequirelookat();
	trigger_use setteamfortrigger("none");
	trigger_use setcursorhint("HINT_INTERACTIVE_PROMPT");
	trigger_use sethintstring(&"COLLECTIBLE_PICK_UP");
	istring = istring(mdl_collectible.model);
	var_837a6185 = gameobjects::create_use_object("any", trigger_use, array(mdl_collectible), (0, 0, 0), istring);
	var_837a6185 gameobjects::allow_use("any");
	var_837a6185 gameobjects::set_use_time(0.35);
	var_837a6185 gameobjects::set_owner_team("allies");
	var_837a6185 gameobjects::set_visible_team("any");
	var_837a6185.mdl_collectible = mdl_collectible;
	var_837a6185.onuse = &onuse;
	var_837a6185.onbeginuse = &onbeginuse;
	var_837a6185.single_use = 1;
	var_837a6185.origin = mdl_collectible.origin;
	var_837a6185.angles = var_837a6185.angles;
	if(isdefined(mdl_collectible.script_int))
	{
		var_837a6185.index = mdl_collectible.script_int - 1;
	}
	else
	{
		var_837a6185.index = (int(getsubstr(mdl_collectible.model, mdl_collectible.model.size - 2))) - 1;
	}
	return var_837a6185;
}

/*
	Name: onuse
	Namespace: collectibles
	Checksum: 0x3E3B4033
	Offset: 0x1198
	Size: 0x1CC
	Parameters: 1
	Flags: Linked
*/
function onuse(e_player)
{
	e_player.var_b3dc8451[self.mdl_collectible.model] = 1;
	self.mdl_collectible setinvisibletoplayer(e_player);
	self gameobjects::hide_waypoint(e_player);
	self.trigger setinvisibletoplayer(e_player);
	if(missionhascollectibles(getrootmapname()))
	{
		e_player setdstat("PlayerStatsByMap", level.map_name, "collectibles", self.index, 1);
		e_player addrankxpvalue("picked_up_collectible", 500);
		uploadstats(e_player);
		e_player function_8acd43fd(self.index, 1);
		e_player function_a8d8b9c7();
	}
	util::show_event_message(e_player, istring("COLLECTIBLE_DISCOVERED"));
	e_player playsoundtoplayer("uin_collectible_pickup", e_player);
	e_player notify(#"hash_eb5cc7bc");
	e_player challenges::function_96ed590f("career_collectibles");
}

/*
	Name: onbeginuse
	Namespace: collectibles
	Checksum: 0x7FCDCE93
	Offset: 0x1370
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function onbeginuse(e_player)
{
}

/*
	Name: function_ccb1e08d
	Namespace: collectibles
	Checksum: 0x52865663
	Offset: 0x1388
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function function_ccb1e08d(map_name = getrootmapname())
{
	if(!isdefined(map_name))
	{
		return;
	}
	var_8a9d11b = 0;
	for(var_a34073af = 0; var_a34073af < 10; var_a34073af++)
	{
		if(self getdstat("PlayerStatsByMap", map_name, "collectibles", var_a34073af))
		{
			var_8a9d11b++;
		}
	}
	return var_8a9d11b;
}

/*
	Name: function_3955ccef
	Namespace: collectibles
	Checksum: 0x55FC12C4
	Offset: 0x1440
	Size: 0x7E
	Parameters: 0
	Flags: Linked
*/
function function_3955ccef()
{
	var_8a9d11b = self function_ccb1e08d(getrootmapname());
	var_b95ead22 = getnumberofcollectiblesforlevel(getrootmapname());
	if(var_8a9d11b == var_b95ead22)
	{
		return true;
	}
	return false;
}

/*
	Name: function_e1aad2b1
	Namespace: collectibles
	Checksum: 0xCFFD827F
	Offset: 0x14C8
	Size: 0xD2
	Parameters: 0
	Flags: Linked, Private
*/
function private function_e1aad2b1()
{
	self endon(#"disconnect");
	self notify(#"hash_e1aad2b1");
	self endon(#"hash_e1aad2b1");
	self util::waittill_notify_or_timeout("stats_changed", 2);
	if(isdefined(self) && self hascollectedallcollectibles())
	{
		self setdstat("PlayerStatsList", "ALL_COLLECTIBLES_COLLECTED", "statValue", 1);
		self givedecoration("cp_medal_all_collectibles");
		self notify(#"give_achievement", "CP_ALL_COLLECTIBLES");
	}
}

/*
	Name: function_a8d8b9c7
	Namespace: collectibles
	Checksum: 0x6D58962F
	Offset: 0x15A8
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_a8d8b9c7()
{
	/#
		assert(isplayer(self));
	#/
	if(self function_3955ccef())
	{
		self setdstat("PlayerStatsByMap", getrootmapname(), "allCollectiblesCollected", 1);
		self notify(#"give_achievement", "CP_MISSION_COLLECTIBLES");
	}
	self thread function_e1aad2b1();
}

/*
	Name: function_8acd43fd
	Namespace: collectibles
	Checksum: 0xFB53950C
	Offset: 0x1658
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function function_8acd43fd(var_5c0b5b64, value)
{
	self setnoncheckpointdata(("collectibles" + var_5c0b5b64) + "value", value);
}

/*
	Name: function_70b41d41
	Namespace: collectibles
	Checksum: 0x4BF1DF55
	Offset: 0x16A8
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function function_70b41d41(var_5c0b5b64)
{
	return self getnoncheckpointdata(("collectibles" + var_5c0b5b64) + "value");
}

/*
	Name: function_d100c544
	Namespace: collectibles
	Checksum: 0xC9577C27
	Offset: 0x16E8
	Size: 0xA2
	Parameters: 0
	Flags: Linked
*/
function function_d100c544()
{
	foreach(collectible in level.collectibles)
	{
		self clearnoncheckpointdata(("collectibles" + collectible.index) + "value");
	}
}

