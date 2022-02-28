// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_callbacks;
#using scripts\mp\_util;
#using scripts\mp\_vehicle;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_driving_fx;

#namespace rcbomb;

/*
	Name: __init__sytem__
	Namespace: rcbomb
	Checksum: 0x5841E3E2
	Offset: 0x3F8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("rcbomb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: rcbomb
	Checksum: 0xC34EC220
	Offset: 0x438
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["rcbomb_enemy_light"] = "killstreaks/fx_rcxd_lights_blinky";
	level._effect["rcbomb_friendly_light"] = "killstreaks/fx_rcxd_lights_solid";
	level._effect["rcbomb_enemy_light_blink"] = "killstreaks/fx_rcxd_lights_red";
	level._effect["rcbomb_friendly_light_blink"] = "killstreaks/fx_rcxd_lights_grn";
	level._effect["rcbomb_stunned"] = "_t6/weapon/grenade/fx_spark_disabled_rc_car";
	level.rcbombbundle = struct::get_script_bundle("killstreak", "killstreak_rcbomb");
	clientfield::register("vehicle", "rcbomb_stunned", 1, 1, "int", &callback::callback_stunned, 0, 0);
	vehicle::add_vehicletype_callback("rc_car_mp", &spawned);
}

/*
	Name: spawned
	Namespace: rcbomb
	Checksum: 0x589B0510
	Offset: 0x568
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function spawned(localclientnum)
{
	self thread demo_think(localclientnum);
	self thread stunnedhandler(localclientnum);
	self thread boost_think(localclientnum);
	self thread shutdown_think(localclientnum);
	self.driving_fx_collision_override = &ondrivingfxcollision;
	self.driving_fx_jump_landing_override = &ondrivingfxjumplanding;
	self.killstreakbundle = level.rcbombbundle;
}

/*
	Name: demo_think
	Namespace: rcbomb
	Checksum: 0xE2B080B1
	Offset: 0x620
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function demo_think(localclientnum)
{
	self endon(#"entityshutdown");
	if(!isdemoplaying())
	{
		return;
	}
	for(;;)
	{
		level util::waittill_any("demo_jump", "demo_player_switch");
		self vehicle::lights_off(localclientnum);
	}
}

/*
	Name: boost_blur
	Namespace: rcbomb
	Checksum: 0x92166ED
	Offset: 0x698
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function boost_blur(localclientnum)
{
	self endon(#"entityshutdown");
	if(isdefined(self.owner) && self.owner islocalplayer())
	{
		enablespeedblur(localclientnum, getdvarfloat("scr_rcbomb_amount", 0.1), getdvarfloat("scr_rcbomb_inner_radius", 0.5), getdvarfloat("scr_rcbomb_outer_radius", 0.75), 0, 0);
		wait(getdvarfloat("scr_rcbomb_duration", 1));
		disablespeedblur(localclientnum);
	}
}

/*
	Name: boost_think
	Namespace: rcbomb
	Checksum: 0xBBE128CA
	Offset: 0x790
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function boost_think(localclientnum)
{
	self endon(#"entityshutdown");
	for(;;)
	{
		self waittill(#"veh_boost");
		self boost_blur(localclientnum);
	}
}

/*
	Name: shutdown_think
	Namespace: rcbomb
	Checksum: 0x352B2B00
	Offset: 0x7D8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function shutdown_think(localclientnum)
{
	self waittill(#"entityshutdown");
	disablespeedblur(localclientnum);
}

/*
	Name: play_screen_fx_dirt
	Namespace: rcbomb
	Checksum: 0xE90B31E1
	Offset: 0x810
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function play_screen_fx_dirt(localclientnum)
{
}

/*
	Name: play_screen_fx_dust
	Namespace: rcbomb
	Checksum: 0xCF6F7B27
	Offset: 0x828
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function play_screen_fx_dust(localclientnum)
{
}

/*
	Name: play_driving_screen_fx
	Namespace: rcbomb
	Checksum: 0xA1EE086D
	Offset: 0x840
	Size: 0x122
	Parameters: 1
	Flags: None
*/
function play_driving_screen_fx(localclientnum)
{
	speed_fraction = 0;
	while(true)
	{
		speed = self getspeed();
		maxspeed = self getmaxspeed();
		if(speed < 0)
		{
			maxspeed = self getmaxreversespeed();
		}
		if(maxspeed > 0)
		{
			speed_fraction = abs(speed) / maxspeed;
		}
		else
		{
			speed_fraction = 0;
		}
		if(self iswheelcolliding("back_left") || self iswheelcolliding("back_right"))
		{
		}
	}
}

/*
	Name: play_boost_fx
	Namespace: rcbomb
	Checksum: 0x6453FCFE
	Offset: 0x970
	Size: 0x90
	Parameters: 1
	Flags: None
*/
function play_boost_fx(localclientnum)
{
	self endon(#"entityshutdown");
	while(true)
	{
		speed = self getspeed();
		if(speed > 400)
		{
			self playsound(localclientnum, "mpl_veh_rc_boost");
			return;
		}
		util::server_wait(localclientnum, 0.1);
	}
}

/*
	Name: stunnedhandler
	Namespace: rcbomb
	Checksum: 0x949ACDBA
	Offset: 0xA08
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function stunnedhandler(localclientnum)
{
	self endon(#"entityshutdown");
	self thread enginestutterhandler(localclientnum);
	while(true)
	{
		self waittill(#"stunned");
		self setstunned(1);
		self thread notstunnedhandler(localclientnum);
		self thread play_stunned_fx_handler(localclientnum);
	}
}

/*
	Name: notstunnedhandler
	Namespace: rcbomb
	Checksum: 0x1E3E0337
	Offset: 0xAA0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function notstunnedhandler(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"stunned");
	self waittill(#"not_stunned");
	self setstunned(0);
}

/*
	Name: play_stunned_fx_handler
	Namespace: rcbomb
	Checksum: 0x8C318AA1
	Offset: 0xAF0
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function play_stunned_fx_handler(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"stunned");
	self endon(#"not_stunned");
	while(true)
	{
		playfxontag(localclientnum, level._effect["rcbomb_stunned"], self, "tag_origin");
		wait(0.5);
	}
}

/*
	Name: enginestutterhandler
	Namespace: rcbomb
	Checksum: 0x13A9B3A4
	Offset: 0xB68
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
	Name: ondrivingfxcollision
	Namespace: rcbomb
	Checksum: 0xFACF62C9
	Offset: 0xC08
	Size: 0x124
	Parameters: 5
	Flags: Linked
*/
function ondrivingfxcollision(localclientnum, player, hip, hitn, hit_intensity)
{
	if(isdefined(hit_intensity) && hit_intensity > 15)
	{
		volume = driving_fx::get_impact_vol_from_speed();
		if(isdefined(self.sounddef))
		{
			alias = self.sounddef + "_suspension_lg_hd";
		}
		else
		{
			alias = "veh_default_suspension_lg_hd";
		}
		id = playsound(0, alias, self.origin, volume);
		player earthquake(0.7, 0.25, player.origin, 1500);
		player playrumbleonentity(localclientnum, "damage_heavy");
	}
}

/*
	Name: ondrivingfxjumplanding
	Namespace: rcbomb
	Checksum: 0xEBCDBA72
	Offset: 0xD38
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function ondrivingfxjumplanding(localclientnum, player)
{
}

