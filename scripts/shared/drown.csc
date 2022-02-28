// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace drown;

/*
	Name: __init__sytem__
	Namespace: drown
	Checksum: 0xA963C19B
	Offset: 0x220
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("drown", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: drown
	Checksum: 0x840F6871
	Offset: 0x260
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "drown_stage", 1, 3, "int", &drown_stage_callback, 0, 0);
	callback::on_localplayer_spawned(&player_spawned);
	level.playermaxhealth = getgametypesetting("playerMaxHealth");
	level.player_swim_damage_interval = getdvarfloat("player_swimDamagerInterval", 5000) * 1000;
	level.player_swim_damage = getdvarfloat("player_swimDamage", 5000);
	level.player_swim_time = getdvarfloat("player_swimTime", 5000) * 1000;
	level.player_swim_death_time = ((level.playermaxhealth / level.player_swim_damage) * level.player_swim_damage_interval) + 2000;
	visionset_mgr::register_overlay_info_style_speed_blur("drown_blur", 1, 1, 0.04, 1, 1, 0, 0, 125, 125, 0);
	setup_radius_values();
}

/*
	Name: setup_radius_values
	Namespace: drown
	Checksum: 0x78E0D25
	Offset: 0x3E8
	Size: 0x3C0
	Parameters: 0
	Flags: Linked
*/
function setup_radius_values()
{
	level.drown_radius["inner"]["begin"][1] = 0.8;
	level.drown_radius["inner"]["begin"][2] = 0.6;
	level.drown_radius["inner"]["begin"][3] = 0.6;
	level.drown_radius["inner"]["begin"][4] = 0.5;
	level.drown_radius["inner"]["end"][1] = 0.5;
	level.drown_radius["inner"]["end"][2] = 0.3;
	level.drown_radius["inner"]["end"][3] = 0.3;
	level.drown_radius["inner"]["end"][4] = 0.2;
	level.drown_radius["outer"]["begin"][1] = 1;
	level.drown_radius["outer"]["begin"][2] = 0.8;
	level.drown_radius["outer"]["begin"][3] = 0.8;
	level.drown_radius["outer"]["begin"][4] = 0.7;
	level.drown_radius["outer"]["end"][1] = 0.8;
	level.drown_radius["outer"]["end"][2] = 0.6;
	level.drown_radius["outer"]["end"][3] = 0.6;
	level.drown_radius["outer"]["end"][4] = 0.5;
	level.opacity["begin"][1] = 0.4;
	level.opacity["begin"][2] = 0.5;
	level.opacity["begin"][3] = 0.6;
	level.opacity["begin"][4] = 0.6;
	level.opacity["end"][1] = 0.5;
	level.opacity["end"][2] = 0.6;
	level.opacity["end"][3] = 0.7;
	level.opacity["end"][4] = 0.7;
}

/*
	Name: player_spawned
	Namespace: drown
	Checksum: 0x526A1F7F
	Offset: 0x7B0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function player_spawned(localclientnum)
{
	if(self != getlocalplayer(localclientnum))
	{
		return;
	}
	self player_init_drown_values();
	self thread player_watch_drown_shutdown(localclientnum);
}

/*
	Name: player_init_drown_values
	Namespace: drown
	Checksum: 0x39402047
	Offset: 0x810
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function player_init_drown_values()
{
	if(!isdefined(self.drown_start_time))
	{
		self.drown_start_time = 0;
		self.drown_outerradius = 0;
		self.drown_innerradius = 0;
		self.drown_opacity = 0;
	}
}

/*
	Name: player_watch_drown_shutdown
	Namespace: drown
	Checksum: 0x87BE34C2
	Offset: 0x858
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function player_watch_drown_shutdown(localclientnum)
{
	self util::waittill_any("entityshutdown", "death");
	self disable_drown(localclientnum);
}

/*
	Name: enable_drown
	Namespace: drown
	Checksum: 0xD41A63C
	Offset: 0x8B0
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function enable_drown(localclientnum, stage)
{
	filter::init_filter_drowning_damage(localclientnum);
	filter::enable_filter_drowning_damage(localclientnum, 1);
	self.drown_start_time = getservertime(localclientnum) - ((stage - 1) * level.player_swim_damage_interval);
	self.drown_outerradius = 0;
	self.drown_innerradius = 0;
	self.drown_opacity = 0;
}

/*
	Name: disable_drown
	Namespace: drown
	Checksum: 0x577FE723
	Offset: 0x958
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function disable_drown(localclientnum)
{
	filter::disable_filter_drowning_damage(localclientnum, 1);
}

/*
	Name: player_drown_fx
	Namespace: drown
	Checksum: 0xF743E8F6
	Offset: 0x988
	Size: 0x2C8
	Parameters: 2
	Flags: Linked
*/
function player_drown_fx(localclientnum, stage)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	self endon(#"player_fade_out_drown_fx");
	self notify(#"player_drown_fx");
	self endon(#"player_drown_fx");
	self player_init_drown_values();
	lastoutwatertimestage = self.drown_start_time + ((stage - 1) * level.player_swim_damage_interval);
	stageduration = level.player_swim_damage_interval;
	if(stage == 1)
	{
		stageduration = 2000;
	}
	while(true)
	{
		currenttime = getservertime(localclientnum);
		elapsedtime = currenttime - self.drown_start_time;
		stageratio = math::clamp((currenttime - lastoutwatertimestage) / stageduration, 0, 1);
		self.drown_outerradius = lerpfloat(level.drown_radius["outer"]["begin"][stage], level.drown_radius["outer"]["end"][stage], stageratio) * 1.41421;
		self.drown_innerradius = lerpfloat(level.drown_radius["inner"]["begin"][stage], level.drown_radius["inner"]["end"][stage], stageratio) * 1.41421;
		self.drown_opacity = lerpfloat(level.opacity["begin"][stage], level.opacity["end"][stage], stageratio);
		filter::set_filter_drowning_damage_inner_radius(localclientnum, 1, self.drown_innerradius);
		filter::set_filter_drowning_damage_outer_radius(localclientnum, 1, self.drown_outerradius);
		filter::set_filter_drowning_damage_opacity(localclientnum, 1, self.drown_opacity);
		wait(0.016);
	}
}

/*
	Name: player_fade_out_drown_fx
	Namespace: drown
	Checksum: 0xEBA819F9
	Offset: 0xC58
	Size: 0x1F4
	Parameters: 1
	Flags: Linked
*/
function player_fade_out_drown_fx(localclientnum)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	self endon(#"player_drown_fx");
	self notify(#"player_fade_out_drown_fx");
	self endon(#"player_fade_out_drown_fx");
	self player_init_drown_values();
	fadestarttime = getservertime(localclientnum);
	currenttime = getservertime(localclientnum);
	while((currenttime - fadestarttime) < 250)
	{
		ratio = (currenttime - fadestarttime) / 250;
		outerradius = lerpfloat(self.drown_outerradius, 1.41421, ratio);
		innerradius = lerpfloat(self.drown_innerradius, 1.41421, ratio);
		opacity = lerpfloat(self.drown_opacity, 0, ratio);
		filter::set_filter_drowning_damage_outer_radius(localclientnum, 1, outerradius);
		filter::set_filter_drowning_damage_inner_radius(localclientnum, 1, innerradius);
		filter::set_filter_drowning_damage_opacity(localclientnum, 1, opacity);
		wait(0.016);
		currenttime = getservertime(localclientnum);
	}
	self disable_drown(localclientnum);
}

/*
	Name: drown_stage_callback
	Namespace: drown
	Checksum: 0x51B7E3D
	Offset: 0xE58
	Size: 0xCC
	Parameters: 7
	Flags: Linked
*/
function drown_stage_callback(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval > 0)
	{
		self enable_drown(localclientnum, newval);
		self thread player_drown_fx(localclientnum, newval);
	}
	else
	{
		if(!bnewent)
		{
			self thread player_fade_out_drown_fx(localclientnum);
		}
		else
		{
			self disable_drown(localclientnum);
		}
	}
}

