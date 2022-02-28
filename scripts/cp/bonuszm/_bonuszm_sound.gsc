// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_load;
#using scripts\cp\_oed;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\gametypes\_save;
#using scripts\shared\_oob;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\ammo_shared;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\clientids_shared;
#using scripts\shared\containers_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\load_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\weapons_shared;

#namespace namespace_36e5bc12;

/*
	Name: init
	Namespace: namespace_36e5bc12
	Checksum: 0x1E88E82A
	Offset: 0x738
	Size: 0x13C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	if(!sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	level.var_a5375ea0 = 0;
	level.var_5de673a6 = spawn("script_origin", (0, 0, 0));
	level.var_af2fbbad = spawn("script_origin", (0, 0, 0));
	level.var_e96fb1cb = spawn("script_origin", (0, 0, 0));
	level.var_971e6055 = spawn("script_origin", (0, 0, 0));
	level.var_c9205007 = &function_cf21d35c;
	level.var_9b1300c2 = &function_ef0ce9fb;
	level.var_c75c7dba = &function_b4a3e925;
	level.var_4f24fec0 = &function_45809471;
	level.bzm_sceneseqendedcallback = &bzm_sceneseqended;
}

/*
	Name: bzm_sceneseqended
	Namespace: namespace_36e5bc12
	Checksum: 0x3F8657D0
	Offset: 0x880
	Size: 0x160
	Parameters: 1
	Flags: Linked
*/
function bzm_sceneseqended(scenename)
{
	level notify(#"bzm_sceneseqended");
	if(isdefined(level.var_5de673a6.var_478c7e3e))
	{
		level.var_5de673a6 stopsound(level.var_5de673a6.var_478c7e3e);
	}
	level.var_5de673a6 notify(#"hash_2d8828d0");
	if(isdefined(level.var_af2fbbad.var_478c7e3e))
	{
		level.var_af2fbbad stopsound(level.var_af2fbbad.var_478c7e3e);
	}
	level.var_af2fbbad notify(#"hash_2d8828d0");
	if(isdefined(level.var_e96fb1cb.var_478c7e3e))
	{
		level.var_e96fb1cb stopsound(level.var_e96fb1cb.var_478c7e3e);
	}
	level.var_e96fb1cb notify(#"hash_2d8828d0");
	if(isdefined(level.var_971e6055.var_478c7e3e))
	{
		level.var_971e6055 stopsound(level.var_971e6055.var_478c7e3e);
	}
	level.var_971e6055 notify(#"hash_2d8828d0");
}

/*
	Name: say
	Namespace: namespace_36e5bc12
	Checksum: 0x577A3A3F
	Offset: 0x9E8
	Size: 0x144
	Parameters: 1
	Flags: Linked, Private
*/
function private say(alias)
{
	self notify(#"hash_2d8828d0");
	self endon(#"hash_2d8828d0");
	if(isdefined(self.var_478c7e3e))
	{
		self stopsound(self.var_478c7e3e);
	}
	wait(0.1);
	uniquenotify = (alias + " ") + level.var_a5375ea0;
	level.var_a5375ea0 = level.var_a5375ea0 + 1;
	if(isdefined(level.scr_sound) && isdefined(level.scr_sound["generic"]))
	{
		str_vox_file = level.scr_sound["generic"][alias];
	}
	else
	{
		return;
	}
	if(!isdefined(str_vox_file))
	{
		return;
	}
	self.var_478c7e3e = str_vox_file;
	self playsoundwithnotify(str_vox_file, uniquenotify);
	self util::waittill_any("death", "bzm_cancel_speaking", uniquenotify);
}

/*
	Name: function_cf21d35c
	Namespace: namespace_36e5bc12
	Checksum: 0x3A691CDD
	Offset: 0xB38
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function function_cf21d35c(alias, blocking = 1)
{
	/#
		assert(sessionmodeiscampaignzombiesgame());
	#/
	/#
		assert(isdefined(level.var_5de673a6));
	#/
	if(blocking)
	{
		level.var_5de673a6 say(alias);
	}
	else
	{
		level.var_5de673a6 thread say(alias);
	}
}

/*
	Name: function_ef0ce9fb
	Namespace: namespace_36e5bc12
	Checksum: 0x189B26F4
	Offset: 0xC00
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function function_ef0ce9fb(alias, blocking = 1)
{
	/#
		assert(sessionmodeiscampaignzombiesgame());
	#/
	if(blocking)
	{
		level.var_971e6055 say(alias);
	}
	else
	{
		level.var_971e6055 thread say(alias);
	}
}

/*
	Name: function_b4a3e925
	Namespace: namespace_36e5bc12
	Checksum: 0x26E4BD51
	Offset: 0xCA8
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function function_b4a3e925(alias, blocking = 1)
{
	/#
		assert(sessionmodeiscampaignzombiesgame());
	#/
	if(blocking)
	{
		level.var_af2fbbad say(alias);
	}
	else
	{
		level.var_af2fbbad thread say(alias);
	}
}

/*
	Name: function_45809471
	Namespace: namespace_36e5bc12
	Checksum: 0x200232C6
	Offset: 0xD50
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function function_45809471(alias, blocking = 1)
{
	/#
		assert(sessionmodeiscampaignzombiesgame());
	#/
	if(blocking)
	{
		level.var_e96fb1cb say(alias);
	}
	else
	{
		level.var_e96fb1cb thread say(alias);
	}
}

/*
	Name: function_f46e57be
	Namespace: namespace_36e5bc12
	Checksum: 0xF1A64FB4
	Offset: 0xDF8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_f46e57be()
{
	self endon(#"death");
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	self thread function_f93398c4();
	self thread function_b7efd00a();
	self thread function_acd6c6f8();
}

/*
	Name: function_b7efd00a
	Namespace: namespace_36e5bc12
	Checksum: 0xA8609CA9
	Offset: 0xE68
	Size: 0x152
	Parameters: 0
	Flags: Linked
*/
function function_b7efd00a()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"bhtn_action_notify", notify_string);
		if(isdefined(level.bzm_worldpaused) && level.bzm_worldpaused)
		{
			continue;
		}
		if(self isinscriptedstate())
		{
			continue;
		}
		switch(notify_string)
		{
			case "attack_melee":
			case "behind":
			case "close":
			case "death":
			case "electrocute":
			{
				level thread function_dc28c71b(self, notify_string, 1);
				break;
			}
			case "ambient":
			case "crawler":
			case "sprint":
			case "taunt":
			case "teardown":
			{
				level thread function_dc28c71b(self, notify_string, 0);
				break;
			}
			default:
			{
				if(isdefined(level.var_61e4e12e))
				{
					if(isdefined(level.var_61e4e12e[notify_string]))
					{
						level thread function_dc28c71b(self, notify_string, 0);
					}
				}
				break;
			}
		}
	}
}

/*
	Name: function_dc28c71b
	Namespace: namespace_36e5bc12
	Checksum: 0x6D15B00F
	Offset: 0xFC8
	Size: 0x17C
	Parameters: 3
	Flags: Linked
*/
function function_dc28c71b(zombie, type, override)
{
	zombie endon(#"death");
	if(!isdefined(zombie))
	{
		return;
	}
	if(!isdefined(zombie.voiceprefix))
	{
		return;
	}
	alias = (("zmb_vocals_" + zombie.voiceprefix) + "_") + type;
	if(sndisnetworksafe())
	{
		if(isdefined(override) && override)
		{
			if(type == "death")
			{
				zombie playsound(alias);
			}
			else
			{
				zombie playsoundontag(alias, "j_neck");
			}
		}
		else if(!(isdefined(zombie.talking) && zombie.talking))
		{
			zombie.talking = 1;
			zombie playsoundwithnotify(alias, "sounddone", "j_neck");
			zombie waittill(#"sounddone");
			zombie.talking = 0;
		}
	}
}

/*
	Name: function_f93398c4
	Namespace: namespace_36e5bc12
	Checksum: 0x3C6935D4
	Offset: 0x1150
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function function_f93398c4()
{
	self endon(#"death");
	wait(randomfloatrange(1, 3));
	while(true)
	{
		type = "ambient";
		if(!isdefined(self.zombie_move_speed))
		{
			wait(0.5);
			continue;
		}
		switch(self.zombie_move_speed)
		{
			case "walk":
			{
				type = "ambient";
				break;
			}
			case "run":
			{
				type = "sprint";
				break;
			}
			case "sprint":
			{
				type = "sprint";
				break;
			}
		}
		if(isdefined(self.missinglegs) && self.missinglegs)
		{
			type = "crawler";
		}
		self notify(#"bhtn_action_notify", type);
		wait(randomfloatrange(1, 4));
	}
}

/*
	Name: function_acd6c6f8
	Namespace: namespace_36e5bc12
	Checksum: 0x15684D5D
	Offset: 0x1270
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_acd6c6f8()
{
	self endon(#"disconnect");
	self waittill(#"death", attacker, meansofdeath);
	if(isdefined(self))
	{
		level thread function_dc28c71b(self, "death", 1);
	}
}

/*
	Name: networksafereset
	Namespace: namespace_36e5bc12
	Checksum: 0x33A22EE5
	Offset: 0x12D8
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function networksafereset()
{
	while(true)
	{
		level.var_384c508a = 0;
		util::wait_network_frame();
	}
}

/*
	Name: sndisnetworksafe
	Namespace: namespace_36e5bc12
	Checksum: 0xED567E0F
	Offset: 0x1310
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function sndisnetworksafe()
{
	if(!isdefined(level.var_384c508a))
	{
		level thread networksafereset();
	}
	if(level.var_384c508a >= 2)
	{
		return false;
	}
	level.var_384c508a++;
	return true;
}

/*
	Name: function_b80a73a4
	Namespace: namespace_36e5bc12
	Checksum: 0x60CBF68B
	Offset: 0x1360
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function function_b80a73a4()
{
	level endon(#"unloaded");
	self endon(#"death_or_disconnect");
	if(!isdefined(level._zbv_vox_last_update_time))
	{
		level._zbv_vox_last_update_time = 0;
		level._audio_zbv_shared_ent_list = getaiteamarray("axis");
	}
	while(true)
	{
		wait(1);
		t = gettime();
		if(t > (level._zbv_vox_last_update_time + 1000))
		{
			level._zbv_vox_last_update_time = t;
			level._audio_zbv_shared_ent_list = getaiteamarray("axis");
		}
		zombs = level._audio_zbv_shared_ent_list;
		played_sound = 0;
		for(i = 0; i < zombs.size; i++)
		{
			if(!isdefined(zombs[i]))
			{
				continue;
			}
			if(isdefined(self.archetype) && self.archetype != "zombie")
			{
				level._audio_zbv_shared_ent_list = array::remove_index(level._audio_zbv_shared_ent_list, i);
				continue;
			}
			dist = 250;
			z_dist = 50;
			if(distancesquared(zombs[i].origin, self.origin) < (dist * dist))
			{
				var_3bd0b11d = vectortoangles(zombs[i].origin - self.origin);
				yaw = self.angles[1] - var_3bd0b11d[1];
				yaw = angleclamp180(yaw);
				z_diff = self.origin[2] - zombs[i].origin[2];
				if(yaw < -95 || yaw > 95 && abs(z_diff) < 50)
				{
					zombs[i] notify(#"bhtn_action_notify", "behind");
					played_sound = 1;
					break;
				}
			}
		}
		if(played_sound)
		{
			wait(5);
		}
	}
}

