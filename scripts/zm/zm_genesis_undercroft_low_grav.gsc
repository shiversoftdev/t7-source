// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_genesis_portals;
#using scripts\zm\zm_genesis_zombie;

#namespace zm_genesis_undercroft_low_grav;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x39B65E8D
	Offset: 0x788
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_undercroft_low_grav", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xE7B11716
	Offset: 0x7D0
	Size: 0x16E
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "low_grav_powerup_triggered", 15000, 1, "counter");
	clientfield::register("toplayer", "player_screen_fx", 15000, 1, "int");
	clientfield::register("toplayer", "player_postfx", 15000, 1, "int");
	clientfield::register("scriptmover", "undercroft_emissives", 15000, 1, "int");
	clientfield::register("scriptmover", "undercroft_wall_panel_shutdown", 15000, 1, "counter");
	clientfield::register("scriptmover", "floor_panel_emissives_glow", 15000, 1, "int");
	clientfield::register("world", "snd_low_gravity_state", 15000, 2, "int");
	level._effect["low_grav_player_jump"] = "dlc1/castle/fx_plyr_115_liquid_trail";
}

/*
	Name: __main__
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x7286D077
	Offset: 0x948
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level flag::init("low_grav_countdown");
	level flag::init("low_grav_on");
	level.var_e3f239e5 = getent("undercroft_zone_lowgrav_trig", "targetname");
	level.var_4fb25bb9 = [];
	level.var_4fb25bb9["walk"] = 4;
	level.var_4fb25bb9["run"] = 4;
	level.var_4fb25bb9["sprint"] = 4;
	level.var_4fb25bb9["crawl"] = 3;
	/#
		level thread function_ab786717();
	#/
	level flag::wait_till("start_zombie_round_logic");
	level flag::init("pressure_pads_activated");
	level flag::init("undercroft_powerup_available");
	level flag::init("grav_off_for_ee");
	level function_3fa7f11a();
	level thread function_efcb9832();
	level thread function_c3e8e4a4();
}

/*
	Name: function_3fa7f11a
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x31BD156D
	Offset: 0xB08
	Size: 0x244
	Parameters: 0
	Flags: Linked
*/
function function_3fa7f11a()
{
	level endon(#"pressure_pads_activated");
	var_15ed352b = getentarray("grav_pad_trigger", "targetname");
	level.var_4a455ac4 = 0;
	level.var_eca8388c = [];
	foreach(var_3b9a12e0 in var_15ed352b)
	{
		var_3b9a12e0 thread function_e49e9c09();
		var_4de8678a = getent(var_3b9a12e0.target, "targetname");
		var_e3260cf = getent(var_4de8678a.target, "targetname");
		array::add(level.var_eca8388c, var_e3260cf);
	}
	while(level.var_4a455ac4 < var_15ed352b.size)
	{
		wait(0.05);
	}
	foreach(var_3b9a12e0 in var_15ed352b)
	{
		var_544a882 = getent(var_3b9a12e0.target, "targetname");
	}
	level thread function_ed0d48ca();
	level flag::set("pressure_pads_activated");
}

/*
	Name: function_ed0d48ca
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x89C8E24C
	Offset: 0xD58
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_ed0d48ca()
{
	wait(5);
	exploder::exploder_stop("lgt_grav_pad_n");
	exploder::exploder_stop("lgt_grav_pad_s");
	exploder::exploder_stop("lgt_grav_pad_e");
	exploder::exploder_stop("lgt_grav_pad_w");
}

/*
	Name: function_e49e9c09
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x7385AC27
	Offset: 0xDD0
	Size: 0x2F8
	Parameters: 0
	Flags: Linked
*/
function function_e49e9c09()
{
	var_4de8678a = getent(self.target, "targetname");
	var_4de8678a enablelinkto();
	var_e3260cf = getent(var_4de8678a.target, "targetname");
	var_e3260cf enablelinkto();
	var_e3260cf linkto(var_4de8678a);
	var_2e8e2853 = var_4de8678a.origin - vectorscale((0, 0, 1), 2);
	var_93f2a402 = var_4de8678a.origin;
	while(true)
	{
		self waittill(#"trigger", e_who);
		var_4de8678a moveto(var_2e8e2853, 0.5);
		playsoundatposition("evt_stone_plate_down", var_4de8678a.origin);
		var_4de8678a waittill(#"movedone");
		var_e3260cf clientfield::set("undercroft_emissives", 1);
		n_start_time = gettime();
		n_end_time = n_start_time + 3000;
		while(e_who istouching(self))
		{
			n_time = gettime();
			if(n_time >= n_end_time)
			{
				level.var_4a455ac4++;
				exploder::exploder("lgt_" + self.script_string);
				playsoundatposition("evt_stone_plate_up", var_4de8678a.origin);
				e_who playrumbleonentity("zm_castle_low_grav_panel_rumble");
				return;
			}
			wait(0.05);
		}
		var_4de8678a moveto(var_93f2a402, 0.5);
		playsoundatposition("evt_stone_plate_down", var_4de8678a.origin);
		var_e3260cf clientfield::set("undercroft_emissives", 0);
		var_e3260cf clientfield::increment("undercroft_wall_panel_shutdown");
	}
}

/*
	Name: function_efcb9832
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xFC9D4048
	Offset: 0x10D0
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function function_efcb9832()
{
	setdvar("wallrun_enabled", 1);
	setdvar("doublejump_enabled", 1);
	setdvar("playerEnergy_enabled", 1);
	setdvar("bg_lowGravity", 300);
	setdvar("wallRun_maxTimeMs_zm", 10000);
	setdvar("playerEnergy_maxReserve_zm", 200);
	setdvar("wallRun_peakTest_zm", 0);
	level thread function_5f1fa8cd();
}

/*
	Name: function_5f1fa8cd
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xDAFF1F72
	Offset: 0x11D0
	Size: 0x2AE
	Parameters: 1
	Flags: Linked
*/
function function_5f1fa8cd(n_duration = 50)
{
	/#
		level endon(#"hash_9c3be857");
	#/
	var_e31d98a1 = getentarray("lowgrav_glow", "targetname");
	var_8ff7104f = getentarray("pyramid", "targetname");
	var_e31d98a1 = arraycombine(var_8ff7104f, var_e31d98a1, 0, 0);
	level thread function_ba48ca38();
	while(true)
	{
		level flag::set("low_grav_on");
		exploder::exploder("lgt_low_gravity_on");
		if(!(isdefined(level.var_513683a6) && level.var_513683a6))
		{
			exploder::exploder("fxexp_117");
		}
		level clientfield::set("snd_low_gravity_state", 1);
		array::thread_all(var_e31d98a1, &clientfield::set, "undercroft_emissives", 1);
		array::thread_all(level.var_eca8388c, &clientfield::set, "floor_panel_emissives_glow", 1);
		wait(n_duration - 10);
		level function_e1998cb5();
		level flag::clear("low_grav_on");
		exploder::stop_exploder("lgt_low_gravity_on");
		level clientfield::set("snd_low_gravity_state", 0);
		array::thread_all(var_e31d98a1, &clientfield::set, "undercroft_emissives", 0);
		array::thread_all(level.var_eca8388c, &clientfield::set, "floor_panel_emissives_glow", 0);
		level flag::wait_till_clear("grav_off_for_ee");
		wait(60);
	}
}

/*
	Name: function_e1998cb5
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xFA6E2FA2
	Offset: 0x1488
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function function_e1998cb5()
{
	level clientfield::set("snd_low_gravity_state", 2);
	level flag::set("low_grav_countdown");
	exploder::exploder("lgt_low_gravity_flash");
	wait(7);
	exploder::stop_exploder("lgt_low_gravity_flash");
	exploder::stop_exploder("fxexp_117");
	exploder::exploder("lgt_low_gravity_flash_fast");
	wait(3);
	exploder::stop_exploder("lgt_low_gravity_flash_fast");
	level flag::clear("low_grav_countdown");
}

/*
	Name: function_3ccd9604
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xE549ACFC
	Offset: 0x1580
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function function_3ccd9604()
{
	self endon(#"death");
	while(true)
	{
		if(self istouching(level.var_e3f239e5) && level flag::get("low_grav_on") && self.low_gravity == 0)
		{
			self zm_genesis_zombie::set_gravity("low");
			self.low_gravity = 1;
		}
		else if(!self istouching(level.var_e3f239e5) || !level flag::get("low_grav_on"))
		{
			self zm_genesis_zombie::set_gravity("normal");
			self.low_gravity = 0;
		}
		wait(0.5);
	}
}

/*
	Name: function_f4766f6
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xFD7157B1
	Offset: 0x1698
	Size: 0x124
	Parameters: 0
	Flags: None
*/
function function_f4766f6()
{
	self endon(#"death");
	while(true)
	{
		if(self istouching(level.var_e3f239e5) && level flag::get("low_grav_on") && (!(isdefined(self.low_gravity) && self.low_gravity)))
		{
			self ai::set_behavior_attribute("gravity", "low");
			self.low_gravity = 1;
		}
		else if(!self istouching(level.var_e3f239e5) || !level flag::get("low_grav_on"))
		{
			self ai::set_behavior_attribute("gravity", "normal");
			self.low_gravity = 0;
		}
		wait(0.5);
	}
}

/*
	Name: function_c3f6aa22
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xF17DA384
	Offset: 0x17C8
	Size: 0x2B4
	Parameters: 0
	Flags: Linked
*/
function function_c3f6aa22()
{
	self endon(#"death");
	self endon(#"disconnect");
	level flag::wait_till("low_grav_on");
	self.var_6921c563 = 0;
	while(true)
	{
		while(self istouching(level.var_e3f239e5))
		{
			while(level flag::get("low_grav_on") && self istouching(level.var_e3f239e5))
			{
				if(self.var_6921c563 == 0)
				{
					self allowwallrun(1);
					self allowdoublejump(1);
					self setperk("specialty_lowgravity");
					self.var_6921c563 = 1;
					self clientfield::set_to_player("player_screen_fx", 1);
					self thread function_573a448e();
					self clientfield::set_to_player("player_postfx", 1);
					self thread function_e997f73a();
					/#
						if(getdvarint("") > 0)
						{
							setdvar("", getdvarint(""));
						}
					#/
				}
				wait(0.1);
			}
			if(self.var_6921c563 == 1)
			{
				self allowdoublejump(0);
				self allowwallrun(0);
				self unsetperk("specialty_lowgravity");
				self clientfield::set_to_player("player_screen_fx", 0);
				self clientfield::set_to_player("player_postfx", 0);
				self notify(#"hash_eb16fe00");
				self.var_6921c563 = 0;
			}
			wait(0.1);
		}
		wait(0.1);
	}
}

/*
	Name: function_e997f73a
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x94339071
	Offset: 0x1A88
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function function_e997f73a()
{
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"hash_eb16fe00");
	while(true)
	{
		if(self isonground() || self iswallrunning())
		{
			self setdoublejumpenergy(200);
		}
		wait(0.05);
	}
}

/*
	Name: function_573a448e
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x7397884A
	Offset: 0x1B10
	Size: 0x170
	Parameters: 0
	Flags: Linked
*/
function function_573a448e()
{
	self endon(#"death");
	self endon(#"disconnect");
	while(self.var_6921c563 == 1)
	{
		self waittill(#"jump_begin");
		var_5ed20759 = spawn("script_model", self.origin);
		var_5ed20759 setmodel("tag_origin");
		var_5ed20759 enablelinkto();
		var_5ed20759 linkto(self, "j_spineupper");
		playfxontag(level._effect["low_grav_player_jump"], var_5ed20759, "tag_origin");
		while(!self isonground() || self iswallrunning() && level flag::get("low_grav_on"))
		{
			wait(0.5);
		}
		var_5ed20759 delete();
		wait(0.5);
	}
}

/*
	Name: function_ba48ca38
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x52F483C4
	Offset: 0x1C88
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function function_ba48ca38()
{
	e_trig = getent("low_grav_tp_return", "targetname");
	while(true)
	{
		e_trig waittill(#"trigger", e_who);
		if(!isdefined(e_who.var_ee422cb0))
		{
			e_who thread function_23f211e9();
		}
	}
}

/*
	Name: function_23f211e9
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x845D1354
	Offset: 0x1D10
	Size: 0xAE
	Parameters: 0
	Flags: Linked
*/
function function_23f211e9()
{
	self.var_ee422cb0 = 1;
	self playlocalsound("zmb_teleporter_teleport_2d");
	playsoundatposition("zmb_teleporter_teleport_out", self.origin);
	a_s_port_locs = struct::get_array("temple_portal_top", "targetname");
	self zm_genesis_portals::portal_teleport_player(1, a_s_port_locs, undefined, self.origin, "temple_portal_top");
	self.var_ee422cb0 = undefined;
}

/*
	Name: function_c3e8e4a4
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x53904DA2
	Offset: 0x1DC8
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function function_c3e8e4a4()
{
	s_loc = struct::get("perk_powerup_loc", "targetname");
	level._powerup_timeout_override = &function_e4e4f426;
	foreach(e_player in level.players)
	{
		var_6e4b5e90 = level thread zm_powerups::specific_powerup_drop("free_perk", s_loc.origin, undefined, undefined, undefined, e_player);
	}
	wait(0.5);
	level._powerup_timeout_override = undefined;
}

/*
	Name: function_e4e4f426
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xA2503E07
	Offset: 0x1EE0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_e4e4f426()
{
	self endon(#"powerup_grabbed");
	self endon(#"death");
	self endon(#"powerup_reset");
	self zm_powerups::powerup_show(1);
}

/*
	Name: detect_reentry
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x20A43F1D
	Offset: 0x1F28
	Size: 0x36
	Parameters: 0
	Flags: Linked
*/
function detect_reentry()
{
	/#
		if(isdefined(self.var_8665ab89))
		{
			if(self.var_8665ab89 == gettime())
			{
				return true;
			}
		}
		self.var_8665ab89 = gettime();
		return false;
	#/
}

/*
	Name: function_ab786717
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0x1E4E9D3F
	Offset: 0x1F68
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_ab786717()
{
	/#
		level flagsys::wait_till("");
		wait(1);
		zm_devgui::add_custom_devgui_callback(&function_e41a2453);
		adddebugcommand("");
	#/
}

/*
	Name: function_e41a2453
	Namespace: zm_genesis_undercroft_low_grav
	Checksum: 0xA5F1D4A4
	Offset: 0x1FD8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function function_e41a2453(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				if(level detect_reentry())
				{
					return true;
				}
				level notify(#"hash_9c3be857");
				level thread function_5f1fa8cd(9999);
				return true;
			}
		}
		return false;
	#/
}

