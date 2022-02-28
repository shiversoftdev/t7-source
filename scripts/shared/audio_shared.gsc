// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\music_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace audio;

/*
	Name: __init__sytem__
	Namespace: audio
	Checksum: 0x4BE1C835
	Offset: 0x2A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("audio", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: audio
	Checksum: 0x41388FBE
	Offset: 0x2E0
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_spawned(&sndresetsoundsettings);
	callback::on_spawned(&missilelockwatcher);
	callback::on_spawned(&missilefirewatcher);
	callback::on_player_killed(&on_player_killed);
	callback::on_vehicle_spawned(&vehiclespawncontext);
	level thread register_clientfields();
	level thread sndchyronwatcher();
	level thread sndigcskipwatcher();
}

/*
	Name: register_clientfields
	Namespace: audio
	Checksum: 0xDB621717
	Offset: 0x3D8
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("world", "sndMatchSnapshot", 1, 2, "int");
	clientfield::register("world", "sndFoleyContext", 1, 1, "int");
	clientfield::register("scriptmover", "sndRattle", 1, 1, "int");
	clientfield::register("toplayer", "sndMelee", 1, 1, "int");
	clientfield::register("vehicle", "sndSwitchVehicleContext", 1, 3, "int");
	clientfield::register("toplayer", "sndCCHacking", 1, 2, "int");
	clientfield::register("toplayer", "sndTacRig", 1, 1, "int");
	clientfield::register("toplayer", "sndLevelStartSnapOff", 1, 1, "int");
	clientfield::register("world", "sndIGCsnapshot", 1, 4, "int");
	clientfield::register("world", "sndChyronLoop", 1, 1, "int");
	clientfield::register("world", "sndZMBFadeIn", 1, 1, "int");
}

/*
	Name: sndchyronwatcher
	Namespace: audio
	Checksum: 0x2AA593FA
	Offset: 0x5F8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function sndchyronwatcher()
{
	level waittill(#"chyron_menu_open");
	level clientfield::set("sndChyronLoop", 1);
	level waittill(#"chyron_menu_closed");
	level clientfield::set("sndChyronLoop", 0);
}

/*
	Name: sndigcskipwatcher
	Namespace: audio
	Checksum: 0x9624EC8B
	Offset: 0x660
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function sndigcskipwatcher()
{
	while(true)
	{
		level waittill(#"scene_skip_sequence_started");
		music::setmusicstate("death");
	}
}

/*
	Name: sndresetsoundsettings
	Namespace: audio
	Checksum: 0xDE1B5159
	Offset: 0x6A0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function sndresetsoundsettings()
{
	self clientfield::set_to_player("sndMelee", 0);
	self util::clientnotify("sndDEDe");
}

/*
	Name: on_player_killed
	Namespace: audio
	Checksum: 0x8F4BB61E
	Offset: 0x6F0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function on_player_killed()
{
	if(!(isdefined(self.killcam) && self.killcam))
	{
		self util::clientnotify("sndDED");
	}
}

/*
	Name: vehiclespawncontext
	Namespace: audio
	Checksum: 0x53079A11
	Offset: 0x730
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function vehiclespawncontext()
{
	self clientfield::set("sndSwitchVehicleContext", 1);
}

/*
	Name: sndupdatevehiclecontext
	Namespace: audio
	Checksum: 0x9B5D4E34
	Offset: 0x760
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function sndupdatevehiclecontext(added)
{
	if(!isdefined(self.sndoccupants))
	{
		self.sndoccupants = 0;
	}
	if(added)
	{
		self.sndoccupants++;
	}
	else
	{
		self.sndoccupants--;
		if(self.sndoccupants < 0)
		{
			self.sndoccupants = 0;
		}
	}
	self clientfield::set("sndSwitchVehicleContext", self.sndoccupants + 1);
}

/*
	Name: playtargetmissilesound
	Namespace: audio
	Checksum: 0x6C7FCCF5
	Offset: 0x7F0
	Size: 0xAA
	Parameters: 2
	Flags: Linked
*/
function playtargetmissilesound(alias, looping)
{
	self notify(#"stop_target_missile_sound");
	self endon(#"stop_target_missile_sound");
	self endon(#"disconnect");
	self endon(#"death");
	if(isdefined(alias))
	{
		time = soundgetplaybacktime(alias) * 0.001;
		if(time > 0)
		{
			do
			{
				self playlocalsound(alias);
				wait(time);
			}
			while(looping);
		}
	}
}

/*
	Name: missilelockwatcher
	Namespace: audio
	Checksum: 0xAC6D5BD3
	Offset: 0x8A8
	Size: 0x12E
	Parameters: 0
	Flags: Linked
*/
function missilelockwatcher()
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!self flag::exists("playing_stinger_fired_at_me"))
	{
		self flag::init("playing_stinger_fired_at_me", 0);
	}
	else
	{
		self flag::clear("playing_stinger_fired_at_me");
	}
	while(true)
	{
		self waittill(#"missile_lock", attacker, weapon);
		if(!flag::get("playing_stinger_fired_at_me"))
		{
			self thread playtargetmissilesound(weapon.lockontargetlockedsound, weapon.lockontargetlockedsoundloops);
			self util::waittill_any("stinger_fired_at_me", "missile_unlocked", "death");
			self notify(#"stop_target_missile_sound");
		}
	}
}

/*
	Name: missilefirewatcher
	Namespace: audio
	Checksum: 0xD9FCB40F
	Offset: 0x9E0
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function missilefirewatcher()
{
	self endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"stinger_fired_at_me", missile, weapon, attacker);
		waittillframeend();
		self flag::set("playing_stinger_fired_at_me");
		self thread playtargetmissilesound(weapon.lockontargetfiredonsound, weapon.lockontargetfiredonsoundloops);
		missile util::waittill_any("projectile_impact_explode", "death");
		self notify(#"stop_target_missile_sound");
		self flag::clear("playing_stinger_fired_at_me");
	}
}

/*
	Name: unlockfrontendmusic
	Namespace: audio
	Checksum: 0xEE899BB9
	Offset: 0xAE0
	Size: 0xFC
	Parameters: 2
	Flags: Linked
*/
function unlockfrontendmusic(unlockname, allplayers = 1)
{
	if(isdefined(allplayers) && allplayers)
	{
		if(isdefined(level.players) && level.players.size > 0)
		{
			foreach(player in level.players)
			{
				player unlocksongbyalias(unlockname);
			}
		}
	}
	else
	{
		self unlocksongbyalias(unlockname);
	}
}

