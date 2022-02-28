// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_util;
#using scripts\mp\_vehicle;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace qrdrone;

/*
	Name: __init__sytem__
	Namespace: qrdrone
	Checksum: 0x51E371A1
	Offset: 0x390
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("qrdrone", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: qrdrone
	Checksum: 0x7A198956
	Offset: 0x3D0
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	type = "qrdrone_mp";
	clientfield::register("helicopter", "qrdrone_state", 1, 3, "int", &statechange, 0, 0);
	clientfield::register("vehicle", "qrdrone_state", 1, 3, "int", &statechange, 0, 0);
	level._effect["qrdrone_enemy_light"] = "killstreaks/fx_drgnfire_light_red_3p";
	level._effect["qrdrone_friendly_light"] = "killstreaks/fx_drgnfire_light_green_3p";
	level._effect["qrdrone_viewmodel_light"] = "killstreaks/fx_drgnfire_light_green_1p";
	clientfield::register("helicopter", "qrdrone_countdown", 1, 1, "int", &start_blink, 0, 0);
	clientfield::register("helicopter", "qrdrone_timeout", 1, 1, "int", &final_blink, 0, 0);
	clientfield::register("vehicle", "qrdrone_countdown", 1, 1, "int", &start_blink, 0, 0);
	clientfield::register("vehicle", "qrdrone_timeout", 1, 1, "int", &final_blink, 0, 0);
	clientfield::register("vehicle", "qrdrone_out_of_range", 1, 1, "int", &out_of_range_update, 0, 0);
	vehicle::add_vehicletype_callback("qrdrone_mp", &spawned);
}

/*
	Name: spawned
	Namespace: qrdrone
	Checksum: 0xFB2023B2
	Offset: 0x660
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function spawned(localclientnum)
{
	self util::waittill_dobj(localclientnum);
	self thread restartfx(localclientnum, 0);
	self thread collisionhandler(localclientnum);
	self thread enginestutterhandler(localclientnum);
	self thread qrdrone_watch_distance();
}

/*
	Name: statechange
	Namespace: qrdrone
	Checksum: 0xC64AF6F3
	Offset: 0x6F0
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function statechange(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	self restartfx(localclientnum, newval);
}

/*
	Name: restartfx
	Namespace: qrdrone
	Checksum: 0xC5F2AB6C
	Offset: 0x778
	Size: 0x124
	Parameters: 2
	Flags: Linked
*/
function restartfx(localclientnum, blinkstage)
{
	self notify(#"restart_fx");
	/#
		println("" + blinkstage);
	#/
	switch(blinkstage)
	{
		case 0:
		{
			self spawn_solid_fx(localclientnum);
			break;
		}
		case 1:
		{
			self.fx_interval = 1;
			self spawn_blinking_fx(localclientnum);
			break;
		}
		case 2:
		{
			self.fx_interval = 0.133;
			self spawn_blinking_fx(localclientnum);
			break;
		}
		case 3:
		{
			self notify(#"stopfx");
			self notify(#"fx_death");
			return;
		}
	}
	self thread watchrestartfx(localclientnum);
}

/*
	Name: watchrestartfx
	Namespace: qrdrone
	Checksum: 0x26E2652
	Offset: 0x8A8
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function watchrestartfx(localclientnum)
{
	self endon(#"entityshutdown");
	level util::waittill_any("demo_jump", "player_switch", "killcam_begin", "killcam_end");
	self restartfx(localclientnum, clientfield::get("qrdrone_state"));
}

/*
	Name: spawn_solid_fx
	Namespace: qrdrone
	Checksum: 0x25424073
	Offset: 0x930
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function spawn_solid_fx(localclientnum)
{
	if(self islocalclientdriver(localclientnum))
	{
		fx_handle = playfxontag(localclientnum, level._effect["qrdrone_viewmodel_light"], self, "tag_body");
	}
	else
	{
		if(self util::friend_not_foe(localclientnum))
		{
			fx_handle = playfxontag(localclientnum, level._effect["qrdrone_friendly_light"], self, "tag_body");
		}
		else
		{
			fx_handle = playfxontag(localclientnum, level._effect["qrdrone_enemy_light"], self, "tag_body");
		}
	}
	self thread cleanupfx(localclientnum, fx_handle);
}

/*
	Name: spawn_blinking_fx
	Namespace: qrdrone
	Checksum: 0xC2B54E8F
	Offset: 0xA40
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function spawn_blinking_fx(localclientnum)
{
	self thread blink_fx_and_sound(localclientnum, "wpn_qr_alert");
}

/*
	Name: blink_fx_and_sound
	Namespace: qrdrone
	Checksum: 0x7E25AFA6
	Offset: 0xA78
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function blink_fx_and_sound(localclientnum, soundalias)
{
	self endon(#"entityshutdown");
	self endon(#"restart_fx");
	self endon(#"fx_death");
	if(!isdefined(self.interval))
	{
		self.interval = 1;
	}
	while(true)
	{
		self playsound(localclientnum, soundalias);
		self spawn_solid_fx(localclientnum);
		util::server_wait(localclientnum, self.interval / 2);
		self notify(#"stopfx");
		util::server_wait(localclientnum, self.interval / 2);
		self.interval = self.interval / 1.17;
		if(self.interval < 0.1)
		{
			self.interval = 0.1;
		}
	}
}

/*
	Name: cleanupfx
	Namespace: qrdrone
	Checksum: 0x101C5E13
	Offset: 0xBB0
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function cleanupfx(localclientnum, handle)
{
	self util::waittill_any("entityshutdown", "blink", "stopfx", "restart_fx");
	stopfx(localclientnum, handle);
}

/*
	Name: start_blink
	Namespace: qrdrone
	Checksum: 0x85C5BC61
	Offset: 0xC20
	Size: 0x52
	Parameters: 7
	Flags: Linked
*/
function start_blink(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	self notify(#"blink");
}

/*
	Name: final_blink
	Namespace: qrdrone
	Checksum: 0x7AD3DBF6
	Offset: 0xC80
	Size: 0x58
	Parameters: 7
	Flags: Linked
*/
function final_blink(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	self.interval = 0.133;
}

/*
	Name: out_of_range_update
	Namespace: qrdrone
	Checksum: 0xB067C9C9
	Offset: 0xCE0
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function out_of_range_update(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	model = getuimodel(getuimodelforcontroller(localclientnum), "vehicle.outOfRange");
	if(isdefined(model))
	{
		setuimodelvalue(model, newval);
	}
}

/*
	Name: loop_local_sound
	Namespace: qrdrone
	Checksum: 0xE7160056
	Offset: 0xD88
	Size: 0x144
	Parameters: 4
	Flags: Linked
*/
function loop_local_sound(localclientnum, alias, interval, fx)
{
	self endon(#"entityshutdown");
	self endon(#"stopfx");
	level endon(#"demo_jump");
	level endon(#"player_switch");
	if(!isdefined(self.interval))
	{
		self.interval = interval;
	}
	while(true)
	{
		self playsound(localclientnum, alias);
		self spawn_solid_fx(localclientnum);
		util::server_wait(localclientnum, self.interval / 2);
		self notify(#"stopfx");
		util::server_wait(localclientnum, self.interval / 2);
		self.interval = self.interval / 1.17;
		if(self.interval < 0.1)
		{
			self.interval = 0.1;
		}
	}
}

/*
	Name: check_for_player_switch_or_time_jump
	Namespace: qrdrone
	Checksum: 0xA3B6EEB2
	Offset: 0xED8
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function check_for_player_switch_or_time_jump(localclientnum)
{
	self endon(#"entityshutdown");
	level util::waittill_any("demo_jump", "player_switch", "killcam_begin");
	self notify(#"stopfx");
	waittillframeend();
	self thread blink_light(localclientnum);
	if(isdefined(self.blinkstarttime) && self.blinkstarttime <= level.servertime)
	{
		self.interval = 1;
		self thread start_blink(localclientnum, 1);
	}
	else
	{
		self spawn_solid_fx(localclientnum);
	}
	self thread check_for_player_switch_or_time_jump(localclientnum);
}

/*
	Name: blink_light
	Namespace: qrdrone
	Checksum: 0xE6E462C8
	Offset: 0xFD0
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function blink_light(localclientnum)
{
	self endon(#"entityshutdown");
	level endon(#"demo_jump");
	level endon(#"player_switch");
	level endon(#"killcam_begin");
	self waittill(#"blink");
	if(!isdefined(self.blinkstarttime))
	{
		self.blinkstarttime = level.servertime;
	}
	if(self islocalclientdriver(localclientnum))
	{
		self thread loop_local_sound(localclientnum, "wpn_qr_alert", 1, level._effect["qrdrone_viewmodel_light"]);
	}
	else
	{
		if(self util::friend_not_foe(localclientnum))
		{
			self thread loop_local_sound(localclientnum, "wpn_qr_alert", 1, level._effect["qrdrone_friendly_light"]);
		}
		else
		{
			self thread loop_local_sound(localclientnum, "wpn_qr_alert", 1, level._effect["qrdrone_enemy_light"]);
		}
	}
}

/*
	Name: collisionhandler
	Namespace: qrdrone
	Checksum: 0xF0FEAC6E
	Offset: 0x1120
	Size: 0x108
	Parameters: 1
	Flags: Linked
*/
function collisionhandler(localclientnum)
{
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"veh_collision", hip, hitn, hit_intensity);
		driver_local_client = self getlocalclientdriver();
		if(isdefined(driver_local_client))
		{
			player = getlocalplayer(driver_local_client);
			if(isdefined(player))
			{
				if(hit_intensity > 15)
				{
					player playrumbleonentity(driver_local_client, "damage_heavy");
				}
				else
				{
					player playrumbleonentity(driver_local_client, "damage_light");
				}
			}
		}
	}
}

/*
	Name: enginestutterhandler
	Namespace: qrdrone
	Checksum: 0x4AD9BFE8
	Offset: 0x1230
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function enginestutterhandler(localclientnum)
{
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"veh_engine_stutter");
		if(self islocalclientdriver(localclientnum))
		{
			player = getlocalplayer(localclientnum);
			if(isdefined(player))
			{
				player playrumbleonentity(localclientnum, "rcbomb_engine_stutter");
			}
		}
	}
}

/*
	Name: getminimumflyheight
	Namespace: qrdrone
	Checksum: 0x6B7A9D62
	Offset: 0x12D0
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function getminimumflyheight()
{
	if(!isdefined(level.airsupportheightscale))
	{
		level.airsupportheightscale = 1;
	}
	airsupport_height = struct::get("air_support_height", "targetname");
	if(isdefined(airsupport_height))
	{
		planeflyheight = airsupport_height.origin[2];
	}
	else
	{
		/#
			println("");
		#/
		planeflyheight = 850;
		if(isdefined(level.airsupportheightscale))
		{
			level.airsupportheightscale = getdvarint("scr_airsupportHeightScale", level.airsupportheightscale);
			planeflyheight = planeflyheight * getdvarint("scr_airsupportHeightScale", level.airsupportheightscale);
		}
		if(isdefined(level.forceairsupportmapheight))
		{
			planeflyheight = planeflyheight + level.forceairsupportmapheight;
		}
	}
	return planeflyheight;
}

/*
	Name: qrdrone_watch_distance
	Namespace: qrdrone
	Checksum: 0x6E6CE98
	Offset: 0x1400
	Size: 0x2D4
	Parameters: 0
	Flags: Linked
*/
function qrdrone_watch_distance()
{
	self endon(#"entityshutdown");
	qrdrone_height = struct::get("qrdrone_height", "targetname");
	if(isdefined(qrdrone_height))
	{
		self.maxheight = qrdrone_height.origin[2];
	}
	else
	{
		self.maxheight = int(getminimumflyheight());
	}
	self.maxdistance = 12800;
	level.mapcenter = getmapcenter();
	self.minheight = level.mapcenter[2] - 800;
	inrangepos = self.origin;
	soundent = spawn(0, self.origin, "script_origin");
	soundent linkto(self);
	self thread qrdrone_staticstopondeath(soundent);
	while(true)
	{
		if(!self qrdrone_in_range())
		{
			staticalpha = 0;
			while(!self qrdrone_in_range())
			{
				if(isdefined(self.heliinproximity))
				{
					dist = distance(self.origin, self.heliinproximity.origin);
					staticalpha = 1 - ((dist - 150) / 150);
				}
				else
				{
					dist = distance(self.origin, inrangepos);
					staticalpha = min(1, dist / 200);
				}
				sid = soundent playloopsound("veh_qrdrone_static_lp", 0.2);
				self vehicle::set_static_amount(staticalpha * 2);
				wait(0.05);
			}
			self thread qrdrone_staticfade(staticalpha, soundent, sid);
		}
		inrangepos = self.origin;
		wait(0.05);
	}
}

/*
	Name: qrdrone_in_range
	Namespace: qrdrone
	Checksum: 0x5856028A
	Offset: 0x16E0
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function qrdrone_in_range()
{
	if(self.origin[2] < self.maxheight && self.origin[2] > self.minheight)
	{
		if(self isinsideheightlock())
		{
			return true;
		}
	}
	return false;
}

/*
	Name: qrdrone_staticfade
	Namespace: qrdrone
	Checksum: 0xB2DEBDE
	Offset: 0x1740
	Size: 0xF8
	Parameters: 3
	Flags: Linked
*/
function qrdrone_staticfade(staticalpha, sndent, sid)
{
	self endon(#"entityshutdown");
	while(self qrdrone_in_range())
	{
		staticalpha = staticalpha - 0.05;
		if(staticalpha <= 0)
		{
			sndent stopallloopsounds(0.5);
			self vehicle::set_static_amount(0);
			break;
		}
		setsoundvolumerate(sid, 0.6);
		setsoundvolume(sid, staticalpha);
		self vehicle::set_static_amount(staticalpha * 2);
		wait(0.05);
	}
}

/*
	Name: qrdrone_staticstopondeath
	Namespace: qrdrone
	Checksum: 0x37CAA1C4
	Offset: 0x1840
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function qrdrone_staticstopondeath(sndent)
{
	self waittill(#"entityshutdown");
	sndent stopallloopsounds(0.1);
	sndent delete();
}

