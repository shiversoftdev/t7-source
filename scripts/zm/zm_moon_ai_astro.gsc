// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\zm_zmhd_cleanup_mgr;

#namespace zm_moon_ai_astro;

/*
	Name: init
	Namespace: zm_moon_ai_astro
	Checksum: 0xEEEA9004
	Offset: 0x240
	Size: 0xE8
	Parameters: 0
	Flags: None
*/
function init()
{
	level.astro_zombie_enter_level = &moon_astro_enter_level;
	level.aat["zm_aat_blast_furnace"].validation_func = &function_82c2a8f1;
	level.aat["zm_aat_dead_wire"].validation_func = &function_82c2a8f1;
	level.aat["zm_aat_fire_works"].validation_func = &function_82c2a8f1;
	level.aat["zm_aat_thunder_wall"].validation_func = &function_82c2a8f1;
	level.aat["zm_aat_turned"].validation_func = &function_82c2a8f1;
}

/*
	Name: zombie_set_fake_playername
	Namespace: zm_moon_ai_astro
	Checksum: 0x755CDD
	Offset: 0x330
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function zombie_set_fake_playername()
{
	self setzombiename("SpaceZom");
}

/*
	Name: function_82c2a8f1
	Namespace: zm_moon_ai_astro
	Checksum: 0xC1061C52
	Offset: 0x360
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function function_82c2a8f1()
{
	if(isdefined(self) && isdefined(self.animname) && self.animname == "astro_zombie")
	{
		return false;
	}
	return true;
}

/*
	Name: moon_astro_enter_level
	Namespace: zm_moon_ai_astro
	Checksum: 0x9697D9BB
	Offset: 0x3A0
	Size: 0x1B4
	Parameters: 0
	Flags: None
*/
function moon_astro_enter_level()
{
	self endon(#"death");
	self hide();
	self.entered_level = 1;
	self.no_widows_wine = 1;
	astro_struct = self moon_astro_get_spawn_struct();
	if(isdefined(astro_struct))
	{
		self forceteleport(astro_struct.origin, astro_struct.angles);
		util::wait_network_frame();
	}
	playfx(level._effect["astro_spawn"], self.origin);
	self playsound("zmb_hellhound_bolt");
	self playsound("zmb_hellhound_spawn");
	playrumbleonposition("explosion_generic", self.origin);
	self playloopsound("zmb_zombie_astronaut_loop", 1);
	self thread play_line_if_player_can_see();
	self zombie_set_fake_playername();
	util::wait_network_frame();
	self show();
}

/*
	Name: play_line_if_player_can_see
	Namespace: zm_moon_ai_astro
	Checksum: 0x7C143243
	Offset: 0x560
	Size: 0xE0
	Parameters: 0
	Flags: None
*/
function play_line_if_player_can_see()
{
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(distancesquared(self.origin, players[i].origin) <= 640000)
		{
			cansee = self zmhd_cleanup::player_can_see_me(players[i]);
			if(cansee)
			{
				players[i] thread zm_audio::create_and_play_dialog("general", "astro_spawn");
				return;
			}
		}
	}
}

/*
	Name: moon_astro_get_spawn_struct
	Namespace: zm_moon_ai_astro
	Checksum: 0x98B44FEB
	Offset: 0x648
	Size: 0x216
	Parameters: 0
	Flags: None
*/
function moon_astro_get_spawn_struct()
{
	keys = getarraykeys(level.zones);
	for(i = 0; i < level.zones.size; i++)
	{
		if(keys[i] == "nml_zone")
		{
			continue;
		}
		if(level.zones[keys[i]].is_occupied)
		{
			locs = struct::get_array(level.zones[keys[i]].volumes[0].target + "_astro", "targetname");
			if(isdefined(locs) && locs.size > 0)
			{
				locs = array::randomize(locs);
				return locs[0];
			}
		}
	}
	for(i = 0; i < level.zones.size; i++)
	{
		if(keys[i] == "nml_zone")
		{
			continue;
		}
		if(level.zones[keys[i]].is_active)
		{
			locs = struct::get_array(level.zones[keys[i]].volumes[0].target + "_astro", "targetname");
			if(isdefined(locs) && locs.size > 0)
			{
				locs = array::randomize(locs);
				return locs[0];
			}
		}
	}
	return undefined;
}

