// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_moon_amb;
#using scripts\zm\zm_moon_sq;

#namespace zm_moon_sq_datalogs;

/*
	Name: init
	Namespace: zm_moon_sq_datalogs
	Checksum: 0xFFAE8298
	Offset: 0x368
	Size: 0x404
	Parameters: 0
	Flags: Linked
*/
function init()
{
	datalogs = array("vox_story_2_log_1", "vox_story_2_log_2", "vox_story_2_log_3", "vox_story_2_log_4", "vox_story_2_log_5", "vox_story_2_log_6");
	datalogs_delay = [];
	datalogs_delay["vox_story_2_log_1"] = 40;
	datalogs_delay["vox_story_2_log_2"] = 28;
	datalogs_delay["vox_story_2_log_3"] = 29;
	datalogs_delay["vox_story_2_log_4"] = 52;
	datalogs_delay["vox_story_2_log_5"] = 37;
	datalogs_delay["vox_story_2_log_6"] = 138;
	i = 0;
	datalog_locs = struct::get_array("sq_datalog", "targetname");
	player = struct::get("sq_reel_to_reel", "targetname");
	datalog_locs = array::randomize(datalog_locs);
	while(i < datalogs.size)
	{
		log_struct = datalog_locs[0];
		log = spawn("script_model", log_struct.origin);
		if(isdefined(log_struct.angles))
		{
			log.angles = log_struct.angles;
		}
		log setmodel("p7_zm_moo_data_reel");
		log thread zm_sidequests::fake_use("pickedup");
		log waittill(#"pickedup", who);
		playsoundatposition("fly_log_pickup", who.origin);
		who._has_log = 1;
		log delete();
		who zm_sidequests::add_sidequest_icon("sq", "datalog");
		player thread zm_sidequests::fake_use("placed", &log_qualifier);
		player waittill(#"placed", who);
		who._has_log = undefined;
		who zm_sidequests::remove_sidequest_icon("sq", "datalog");
		sound_ent = spawn("script_origin", player.origin);
		sound_ent playsoundwithnotify(datalogs[i], "sounddone");
		sound_ent playloopsound("vox_radio_egg_snapshot", 1);
		wait(datalogs_delay[datalogs[i]]);
		sound_ent stoploopsound(1);
		i++;
		arrayremovevalue(datalog_locs, log_struct);
		datalog_locs = array::randomize(datalog_locs);
	}
}

/*
	Name: log_qualifier
	Namespace: zm_moon_sq_datalogs
	Checksum: 0x20A4EECD
	Offset: 0x778
	Size: 0x18
	Parameters: 0
	Flags: Linked
*/
function log_qualifier()
{
	if(isdefined(self._has_log))
	{
		return true;
	}
	return false;
}

