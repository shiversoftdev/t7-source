// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\_challenges;
#using scripts\cp\_objectives;
#using scripts\cp\_util;
#using scripts\cp\gametypes\_save;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;

#namespace collectibles;

/*
	Name: __init__sytem__
	Namespace: collectibles
	Checksum: 0xF37EF3F8
	Offset: 0x5F8
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bzm_collectibles", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: collectibles
	Checksum: 0x484EBC81
	Offset: 0x640
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	clientfield::register("world", "cpzm_song_suppression", 1, 1, "int");
	level.mission_name = getmissionname();
	level.map_name = getrootmapname();
	level.var_3efe1e22 = [];
	level thread function_7c315d3a();
}

/*
	Name: __main__
	Namespace: collectibles
	Checksum: 0x63F57881
	Offset: 0x6E8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	if(!sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	thread function_ab60ef67();
}

/*
	Name: function_ab60ef67
	Namespace: collectibles
	Checksum: 0xAD974EDE
	Offset: 0x720
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function function_ab60ef67()
{
	wait(2);
	level.var_8a9d11b = 0;
	level.var_7e93a355 = 0;
	level.collectibles = [];
	mdl_collectibles = getentarray("collectible", "script_noteworthy");
	if(mdl_collectibles.size <= 1)
	{
		return;
	}
	mapname = getdvarstring("mapname");
	if(issubstr(mapname, "blackstation"))
	{
		var_12d65c22 = 1;
	}
	else
	{
		var_12d65c22 = 0;
	}
	level.var_f5f95e45 = -1;
	foreach(mdl_collectible in mdl_collectibles)
	{
		if(var_12d65c22 && (distancesquared((-1492, 1690, -640), mdl_collectible.origin)) <= (200 * 200))
		{
			continue;
		}
		level.var_f5f95e45++;
		mdl_collectible.index = level.var_f5f95e45;
		collectible = function_8765a33c(mdl_collectible);
		array::add(level.collectibles, collectible, 0);
	}
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: function_b963f25
	Namespace: collectibles
	Checksum: 0xE2C8EC89
	Offset: 0x938
	Size: 0xE4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_b963f25(mdl_collectible)
{
	mdl_collectible.radius = 60;
	mdl_collectible.offset = vectorscale((0, 0, 1), 5);
	mdl_collectible.origin = mdl_collectible.origin + vectorscale((0, 0, 1), 35);
	var_3efe1e22 = level.var_3efe1e22[mdl_collectible.model];
	if(isdefined(var_3efe1e22))
	{
		mdl_collectible.radius = var_3efe1e22.radius;
		mdl_collectible.offset = mdl_collectible.offset + var_3efe1e22.offset;
	}
	return mdl_collectible;
}

/*
	Name: on_player_spawned
	Namespace: collectibles
	Checksum: 0x99EC1590
	Offset: 0xA28
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: function_8765a33c
	Namespace: collectibles
	Checksum: 0xEFD0FCB2
	Offset: 0xA38
	Size: 0x3A8
	Parameters: 1
	Flags: Linked
*/
function function_8765a33c(mdl_collectible)
{
	mdl_collectible show();
	mdl_collectible = function_b963f25(mdl_collectible);
	trigger_use = spawn("trigger_radius_use", mdl_collectible.origin + mdl_collectible.offset, 0, 100, mdl_collectible.radius);
	trigger_use triggerignoreteam();
	trigger_use setvisibletoall();
	trigger_use usetriggerrequirelookat();
	trigger_use setteamfortrigger("none");
	trigger_use setcursorhint("HINT_INTERACTIVE_PROMPT");
	trigger_use sethintstring(&"COLLECTIBLE_PICK_UP");
	var_837a6185 = gameobjects::create_use_object("any", trigger_use, array(mdl_collectible), (0, 0, 0), &"cp_magic_song");
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
	mdl_collectible setmodel("p7_zm_teddybear_sitting");
	mdl_collectible clientfield::set("powerup_on_fx", 2);
	mdl_collectible setscale(0.7);
	/#
		level thread debug_draw_line(var_837a6185.origin);
	#/
	return var_837a6185;
}

/*
	Name: function_9b46b73e
	Namespace: collectibles
	Checksum: 0xC218DE9A
	Offset: 0xDE8
	Size: 0x1A0
	Parameters: 0
	Flags: Linked
*/
function function_9b46b73e()
{
	mapname = getrootmapname();
	foreach(collectible in level.collectibles)
	{
		foreach(player in level.players)
		{
			if(player getdstat("PlayerStatsByMap", mapname, "collectibles", collectible.index))
			{
				collectible.mdl_collectible setinvisibletoplayer(player);
				objective_setinvisibletoplayer(collectible.objectiveid, player);
				collectible.trigger setinvisibletoplayer(player);
			}
		}
	}
}

/*
	Name: onuse
	Namespace: collectibles
	Checksum: 0xB72548EA
	Offset: 0xF90
	Size: 0x4E2
	Parameters: 1
	Flags: Linked
*/
function onuse(e_player)
{
	mapname = getrootmapname();
	foreach(player in level.players)
	{
		player playsoundtoplayer("uin_collectible_pickup", player);
		self.mdl_collectible setinvisibletoplayer(player);
		self gameobjects::hide_waypoint(player);
		self.trigger setinvisibletoplayer(player);
		player setdstat("PlayerStatsByMap", mapname, "collectibles", self.index, 1);
		uploadstats(player);
		util::show_event_message(player, istring("COLLECTIBLE_DISCOVERED"));
	}
	level.var_8a9d11b++;
	var_27fba3a4 = level.collectibles.size;
	if(var_27fba3a4 > 3)
	{
		if(level.var_8a9d11b < 3)
		{
			return;
		}
	}
	else if((var_27fba3a4 - level.var_8a9d11b) > 0)
	{
		return;
	}
	level thread function_9b46b73e();
	if(level.var_7e93a355 <= 1)
	{
		mapname = getrootmapname();
		level.var_7e93a355++;
		state = undefined;
		unlockname = undefined;
		switch(mapname)
		{
			case "cp_mi_cairo_aquifer_nightmares":
			{
				state = "zm_abra";
				unlockname = "mus_abra_cadavre_intro";
				break;
			}
			case "cp_mi_cairo_lotus_nightmares":
			{
				state = "zm_always_running";
				unlockname = "mus_always_running_intro";
				break;
			}
			case "cp_mi_cairo_ramses_nightmares":
			{
				state = "zm_wafd";
				unlockname = "mus_we_all_fall_down_intro";
				break;
			}
			case "cp_mi_eth_prologue_nightmares":
			{
				state = "zm_pareidolia";
				unlockname = "mus_pareidolia_intro";
				break;
			}
			case "cp_mi_sing_biodomes_nightmares":
			{
				state = "zm_boa";
				unlockname = "mus_beauty_of_annihilation_intro";
				break;
			}
			case "cp_mi_sing_blackstation_nightmares":
			{
				state = "zm_carrion";
				unlockname = "mus_carrion_intro";
				break;
			}
			case "cp_mi_sing_sgen_nightmares":
			{
				state = "zm_lullaby";
				unlockname = "mus_lullaby_for_a_dead_man_intro";
				break;
			}
			case "cp_mi_sing_vengeance_nightmares":
			{
				state = "zm_coming_home";
				unlockname = "mus_coming_home_intro";
				break;
			}
			case "cp_mi_zurich_coalescence_nightmares":
			{
				state = "zm_archangel";
				unlockname = "mus_archangel_intro";
				break;
			}
			case "cp_mi_zurich_newworld_nightmares":
			{
				state = "zm_the_one";
				unlockname = "mus_the_one_intro";
				break;
			}
			case "cp_mi_cairo_infection_nightmares":
			{
				state = "zm_wawg";
				unlockname = "mus_where_are_we_going_intro";
				break;
			}
		}
		if(isdefined(state))
		{
			/#
				iprintln("" + unlockname);
			#/
			music::setmusicstate(state);
			level.bonuszm_musicoverride = 1;
			level thread function_d789d2e(state);
		}
		foreach(player in level.players)
		{
			if(isdefined(unlockname))
			{
				player unlocksongbyalias(unlockname);
			}
		}
	}
}

/*
	Name: function_d789d2e
	Namespace: collectibles
	Checksum: 0x5B565DEB
	Offset: 0x1480
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_d789d2e(state)
{
	aliasname = ("mus_" + state) + "_intro";
	playbacktime = soundgetplaybacktime(aliasname);
	if(!isdefined(playbacktime) || playbacktime <= 0)
	{
		waittime = 1;
	}
	else
	{
		waittime = playbacktime * 0.001;
	}
	wait(waittime);
	level.bonuszm_musicoverride = 0;
}

/*
	Name: onbeginuse
	Namespace: collectibles
	Checksum: 0x2BED3B14
	Offset: 0x1530
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function onbeginuse(e_player)
{
}

/*
	Name: debug_draw_line
	Namespace: collectibles
	Checksum: 0xDD46CDE6
	Offset: 0x1548
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function debug_draw_line(origin1)
{
	/#
		while(true)
		{
			recordline(origin1, origin1 + vectorscale((0, 0, 1), 2000), (1, 1, 1), "");
			wait(0.05);
		}
	#/
}

/*
	Name: function_7c315d3a
	Namespace: collectibles
	Checksum: 0xF6B94855
	Offset: 0x15A8
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_7c315d3a()
{
	while(true)
	{
		level waittill(#"scene_sequence_started");
		if(isdefined(level.bonuszm_musicoverride) && level.bonuszm_musicoverride)
		{
			level clientfield::set("cpzm_song_suppression", 1);
		}
		level waittill(#"scene_sequence_ended");
		level clientfield::set("cpzm_song_suppression", 0);
	}
}

