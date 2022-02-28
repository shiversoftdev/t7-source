// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\cybercom\_cybercom_gadget_firefly;
#using scripts\cp\cybercom\_cybercom_gadget_misdirection;
#using scripts\cp\cybercom\_cybercom_gadget_security_breach;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace cybercom;

/*
	Name: __init__sytem__
	Namespace: cybercom
	Checksum: 0xF06EE7DA
	Offset: 0xB10
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("cybercom", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: cybercom
	Checksum: 0x3D97D02A
	Offset: 0xB50
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	setdvar("cybercom_fastswitch_enabled", "1");
	level.cybercom_status = 0;
	init_clientfields();
	function_15b9d1ea();
	callback::on_spawned(&on_player_spawned);
	cybercom_firefly::init();
	cybercom_security_breach::init();
	cybercom_misdirection::init();
}

/*
	Name: init_clientfields
	Namespace: cybercom
	Checksum: 0x8DA5274
	Offset: 0xC00
	Size: 0x5DA
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("world", "cybercom_disabled", 1, 1, "int", &cybercomdisabledall, 0, 0);
	clientfield::register("toplayer", "cybercom_disabled", 1, 1, "int", &cybercomdisabled, 0, 0);
	clientfield::register("vehicle", "cybercom_setiffname", 1, 3, "int", &setiffname, 0, 0);
	clientfield::register("actor", "cybercom_setiffname", 1, 3, "int", &setiffname, 0, 0);
	clientfield::register("actor", "cybercom_immolate", 1, 2, "int", &function_87475da2, 0, 0);
	clientfield::register("vehicle", "cybercom_immolate", 1, 1, "int", &function_a7363f41, 0, 0);
	clientfield::register("actor", "cybercom_sysoverload", 1, 2, "int", &function_572c7315, 0, 0);
	clientfield::register("vehicle", "cybercom_sysoverload", 1, 1, "int", &function_38510c4a, 0, 0);
	clientfield::register("actor", "cybercom_surge", 1, 2, "int", &function_2d61bf2e, 0, 0);
	clientfield::register("vehicle", "cybercom_surge", 1, 2, "int", &function_50dfd00b, 0, 0);
	clientfield::register("scriptmover", "cybercom_surge", 1, 1, "int", &function_38cc3f2e, 0, 0);
	clientfield::register("actor", "cybercom_shortout", 1, 2, "int", &function_82d4e6fe, 0, 0);
	clientfield::register("vehicle", "cybercom_shortout", 1, 2, "int", &function_6f88468d, 0, 0);
	clientfield::register("allplayers", "cyber_arm_pulse", 1, 2, "counter", &cyber_arm_pulse, 0, 0);
	clientfield::register("actor", "cyber_arm_pulse", 1, 2, "counter", &cyber_arm_pulse, 0, 0);
	clientfield::register("scriptmover", "cyber_arm_pulse", 1, 2, "counter", &cyber_arm_pulse, 0, 0);
	clientfield::register("actor", "sensory_overload", 1, 2, "int", &cybercom_sensoryoverload, 0, 0);
	clientfield::register("actor", "forced_malfunction", 1, 1, "int", &cybercom_forcedmalfunction, 0, 0);
	clientfield::register("toplayer", "hacking_progress", 1, 12, "int", &function_9439eecf, 0, 0);
	clientfield::register("toplayer", "resetAbilityWheel", 1, 1, "int", &function_806d1a61, 0, 0);
	level._effect["sensory_disable_human"] = "electric/fx_ability_elec_sensory_ol_human";
	level._effect["forced_malfunction"] = "electric/fx_ability_elec_sensory_ol_weapon";
}

/*
	Name: function_15b9d1ea
	Namespace: cybercom
	Checksum: 0xE224E8F4
	Offset: 0x11E8
	Size: 0x18A
	Parameters: 0
	Flags: Linked
*/
function function_15b9d1ea()
{
	level.var_6d1233cd = spawnstruct();
	level.var_6d1233cd.var_f9151455 = [];
	level.var_6d1233cd.var_f9151455[0] = 1;
	level.var_6d1233cd.var_f9151455[1] = 2;
	level.var_6d1233cd.var_f9151455[2] = 6;
	level.var_6d1233cd.var_f9151455[3] = 3;
	level.var_6d1233cd.var_f9151455[4] = 5;
	level.var_6d1233cd.var_f9151455[5] = 4;
	level.var_6d1233cd.var_7835feac = [];
	level.var_6d1233cd.var_7835feac[0] = 0;
	level.var_6d1233cd.var_7835feac[1] = 1;
	level.var_6d1233cd.var_7835feac[2] = 3;
	level.var_6d1233cd.var_7835feac[3] = 5;
	level.var_6d1233cd.var_7835feac[4] = 4;
	level.var_6d1233cd.var_7835feac[5] = 2;
}

/*
	Name: function_ff55db55
	Namespace: cybercom
	Checksum: 0x42990FE
	Offset: 0x1380
	Size: 0x20
	Parameters: 1
	Flags: None
*/
function function_ff55db55(var_29072664)
{
	return level.var_6d1233cd.var_f9151455[var_29072664];
}

/*
	Name: function_d3ef9004
	Namespace: cybercom
	Checksum: 0x665119D3
	Offset: 0x13A8
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function function_d3ef9004(var_b41337db)
{
	return level.var_6d1233cd.var_7835feac[var_b41337db];
}

/*
	Name: function_850a0f8d
	Namespace: cybercom
	Checksum: 0xADC74C16
	Offset: 0x13D0
	Size: 0xA8
	Parameters: 2
	Flags: Linked
*/
function function_850a0f8d(var_80c5df, start_index)
{
	for(index = 1; index < 6; index++)
	{
		var_93a57fde = (start_index + index) % 6;
		abilityindex = function_d3ef9004(var_93a57fde);
		if(self iscybercomindexenabled(var_80c5df, abilityindex))
		{
			return var_93a57fde;
		}
	}
	return undefined;
}

/*
	Name: function_5eccc9a4
	Namespace: cybercom
	Checksum: 0x3B2FD7A2
	Offset: 0x1480
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function function_5eccc9a4(localclientnum)
{
	var_28b99141 = self getcybercomtype();
	var_1d8356fd = function_371a93b4(localclientnum, var_28b99141);
	if(!isdefined(var_1d8356fd))
	{
		return;
	}
	var_f0285882 = self function_850a0f8d(var_28b99141, var_1d8356fd);
	if(!isdefined(var_f0285882))
	{
		return;
	}
	var_b536f3a3 = function_d3ef9004(var_f0285882);
	var_d2dd9579 = self getcybercomabilityname(self getcybercomtype(), var_b536f3a3);
	self setplayercybercomability(var_d2dd9579);
	function_62d5481c(localclientnum, var_28b99141, var_f0285882);
}

/*
	Name: on_player_spawned
	Namespace: cybercom
	Checksum: 0xBE3976B2
	Offset: 0x15C0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function on_player_spawned(localclientnum)
{
	self initcybercom(localclientnum);
	self thread watchmenu(localclientnum);
}

/*
	Name: opentacmenu
	Namespace: cybercom
	Checksum: 0x1F342338
	Offset: 0x1608
	Size: 0xD6
	Parameters: 1
	Flags: Linked
*/
function opentacmenu(localclientnum)
{
	if(!isdefined(self.tacticalmenu) && !isigcactive(localclientnum))
	{
		self.tacticalmenu = createluimenu(localclientnum, self.cybercom.menu);
		openluimenu(localclientnum, self.tacticalmenu);
		self setintacticalhud(1);
		audio::playloopat("gdt_tac_menu_snapshot_loop", (0, 0, 0));
	}
	else
	{
		self.var_316fa5e6 = 1;
	}
	self.var_5208f863 = undefined;
}

/*
	Name: freetacmenuhandle
	Namespace: cybercom
	Checksum: 0xBE7B628C
	Offset: 0x16E8
	Size: 0xD6
	Parameters: 2
	Flags: Linked
*/
function freetacmenuhandle(localclientnum, menu)
{
	self endon(#"disconnect");
	self notify(#"freetacmenuhandle");
	self endon(#"freetacmenuhandle");
	audio::stoploopat("gdt_tac_menu_snapshot_loop", (0, 0, 0));
	wait(0.25);
	closeluimenu(localclientnum, menu);
	if(!isdefined(self))
	{
		return;
	}
	self.tacticalmenu = undefined;
	self setintacticalhud(0);
	if(isdefined(self.var_316fa5e6) && self.var_316fa5e6)
	{
		self opentacmenu(localclientnum);
		self.var_316fa5e6 = undefined;
	}
}

/*
	Name: closetacmenu
	Namespace: cybercom
	Checksum: 0xB36F96C4
	Offset: 0x17C8
	Size: 0xD6
	Parameters: 1
	Flags: Linked
*/
function closetacmenu(localclientnum)
{
	if(isdefined(self.tacticalmenu))
	{
		setluimenudata(localclientnum, self.tacticalmenu, "close_current_menu", 1);
		self thread freetacmenuhandle(localclientnum, self.tacticalmenu);
	}
	else if(isdefined(self.var_5208f863) && (isdefined(self.var_5208f863) && self.var_5208f863) && getdvarint("cybercom_fastswitch_enabled") == 1)
	{
		self function_5eccc9a4(localclientnum);
	}
	self.var_316fa5e6 = undefined;
	self.var_5208f863 = undefined;
}

/*
	Name: watchmenuclose
	Namespace: cybercom
	Checksum: 0x8A0A1DEE
	Offset: 0x18A8
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function watchmenuclose(localclientnum)
{
	self endon(#"disconnect");
	self notify(#"watchmenuclosestart");
	self endon(#"watchmenuclosestart");
	for(;;)
	{
		self util::waittill_any("tactical_menu_close", "death");
		self closetacmenu(localclientnum);
	}
}

/*
	Name: function_524667f7
	Namespace: cybercom
	Checksum: 0x61042E36
	Offset: 0x1920
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function function_524667f7(localclientnum)
{
	self endon(#"tactical_menu_open");
	self endon(#"tactical_menu_close");
	self endon(#"watchmenuopenstart");
	self endon(#"death");
	self.var_5208f863 = 1;
	wait(0.15);
	self opentacmenu(localclientnum);
}

/*
	Name: watchmenuopen
	Namespace: cybercom
	Checksum: 0xD41E2F74
	Offset: 0x1998
	Size: 0x98
	Parameters: 1
	Flags: Linked
*/
function watchmenuopen(localclientnum)
{
	self notify(#"watchmenuopenstart");
	self endon(#"watchmenuopenstart");
	for(;;)
	{
		self waittill(#"tactical_menu_open");
		if(level.cybercom_status == 0 && (!(isdefined(self.cybercomdisabled) && self.cybercomdisabled)) && !isigcactive(localclientnum))
		{
			self thread function_524667f7(localclientnum);
		}
	}
}

/*
	Name: function_820cd75b
	Namespace: cybercom
	Checksum: 0x4108D146
	Offset: 0x1A38
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function function_820cd75b(localclientnum)
{
	self notify(#"hash_820cd75b");
	self endon(#"hash_820cd75b");
	for(;;)
	{
		self waittill(#"tactical_menu_toggle");
		if(isdefined(self.tacticalmenu))
		{
			self closetacmenu(localclientnum);
			continue;
		}
		if(level.cybercom_status == 0 && (!(isdefined(self.cybercomdisabled) && self.cybercomdisabled)) && !isigcactive(localclientnum))
		{
			self opentacmenu(localclientnum);
		}
	}
}

/*
	Name: watchmenu
	Namespace: cybercom
	Checksum: 0xEFA504B2
	Offset: 0x1B00
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function watchmenu(localclientnum)
{
	if(self islocalplayer())
	{
		self thread watchmenuopen(localclientnum);
		self thread watchmenuclose(localclientnum);
		self thread function_820cd75b(localclientnum);
	}
}

/*
	Name: cybercomdisabled
	Namespace: cybercom
	Checksum: 0xF5BC6F83
	Offset: 0x1B78
	Size: 0x72
	Parameters: 7
	Flags: Linked
*/
function cybercomdisabled(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self notify(#"tactical_menu_close");
		self.cybercomdisabled = 1;
	}
	else
	{
		self.cybercomdisabled = undefined;
	}
}

/*
	Name: cybercomdisabledall
	Namespace: cybercom
	Checksum: 0x6F90DCFA
	Offset: 0x1BF8
	Size: 0x190
	Parameters: 7
	Flags: Linked
*/
function cybercomdisabledall(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level.cybercom_status = newval;
	players = getlocalplayers();
	if(level.cybercom_status == 1)
	{
		foreach(player in players)
		{
			player notify(#"tactical_menu_close");
			player.cybercomdisabled = 1;
		}
	}
	else
	{
		foreach(player in players)
		{
			player notify(#"tactical_menu_close");
			player.cybercomdisabled = undefined;
		}
	}
}

/*
	Name: emergencyreserve
	Namespace: cybercom
	Checksum: 0x589409BF
	Offset: 0x1D90
	Size: 0x15C
	Parameters: 7
	Flags: None
*/
function emergencyreserve(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	/#
		assert(isdefined(player));
	#/
	if(isdefined(player.emergencyreserve) && player.emergencyreserve && !newval)
	{
		player.emergencyreserve = undefined;
		visionsetnaked(localclientnum, getdvarstring("mapname"), 0);
	}
	else if(!(isdefined(player.emergencyreserve) && player.emergencyreserve) && newval)
	{
		player.emergencyreserve = 1;
		visionsetnaked(localclientnum, "cheat_bw", 0.5);
	}
}

/*
	Name: repulsorarmorrecharging
	Namespace: cybercom
	Checksum: 0x611CD051
	Offset: 0x1EF8
	Size: 0x15C
	Parameters: 7
	Flags: None
*/
function repulsorarmorrecharging(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	/#
		assert(isdefined(player));
	#/
	if(isdefined(player.repulsorrecharging) && player.repulsorrecharging && !newval)
	{
		player.repulsorrecharging = undefined;
		visionsetnaked(localclientnum, getdvarstring("mapname"), 0);
	}
	else if(!(isdefined(player.repulsorrecharging) && player.repulsorrecharging) && newval)
	{
		player.repulsorrecharging = 1;
		visionsetnaked(localclientnum, "cheat_bw", 0.5);
	}
}

/*
	Name: castinganimationwatcher
	Namespace: cybercom
	Checksum: 0x57728CED
	Offset: 0x2060
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function castinganimationwatcher(localclientnum)
{
	self notify(#"castinganimationwatcher");
	self endon(#"castinganimationwatcher");
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	self.cybercom.lastcastat = 0;
	while(true)
	{
		self waittill(#"gadget_casting_anim");
		curtime = gettime();
		if((self.cybercom.lastcastat + 1000) < curtime)
		{
			cyber_arm_pulse(localclientnum, 0, 0);
			self.cybercom.lastcastat = curtime;
		}
	}
}

/*
	Name: initcybercom
	Namespace: cybercom
	Checksum: 0x13A4C30E
	Offset: 0x2130
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function initcybercom(localclientnum)
{
	if(!isdefined(self.cybercom))
	{
		self.cybercom = spawnstruct();
		self.cybercom.menu = "AbilityWheel";
		self.tacticalmenu = undefined;
	}
	self thread castinganimationwatcher(localclientnum);
}

/*
	Name: function_38510c4a
	Namespace: cybercom
	Checksum: 0xEA7CDCD0
	Offset: 0x21A8
	Size: 0x17E
	Parameters: 7
	Flags: Linked
*/
function function_38510c4a(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		playfx(localclientnum, "electric/fx_elec_sparks_burst_lg_os", self.origin);
		if(isdefined(self.archetype))
		{
			switch(self.archetype)
			{
				case "turret":
				{
					playsound(0, "gdt_cybercore_turret_shutdown", self.origin);
					break;
				}
				case "amws":
				{
					playsound(0, "gdt_cybercore_amws_shutdown", self.origin);
					break;
				}
				case "pamws":
				{
					playsound(0, "gdt_cybercore_amws_shutdown", self.origin);
					break;
				}
				case "raps":
				{
					playsound(0, "veh_raps_skid", self.origin);
					break;
				}
				case "wasp":
				{
					playsound(0, "gdt_cybercore_wasp_shutdown", self.origin);
					break;
				}
			}
		}
	}
}

/*
	Name: function_572c7315
	Namespace: cybercom
	Checksum: 0xD5119E89
	Offset: 0x2330
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function function_572c7315(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		playfxontag(localclientnum, "electric/fx_elec_sparks_burst_lg_os", self, "j_neck");
		self playsound(0, "fly_bot_disable");
	}
	else if(newval == 2)
	{
		playfxontag(localclientnum, "electric/fx_ability_elec_startup_robot", self, "j_spine4");
		self playsound(0, "fly_bot_reboot");
	}
}

/*
	Name: function_38cc3f2e
	Namespace: cybercom
	Checksum: 0x615904F3
	Offset: 0x2420
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_38cc3f2e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		playfxontag(localclientnum, "electric/fx_ability_elec_surge_trail", self, "tag_origin");
		self playsound(0, "gdt_surge_bounce");
	}
}

/*
	Name: function_2d61bf2e
	Namespace: cybercom
	Checksum: 0x571CE7E9
	Offset: 0x24B8
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function function_2d61bf2e(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_robot", self, "j_spine4");
		self playsound(0, "gdt_surge_impact");
	}
	else if(newval == 2)
	{
		playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_robot", self, "j_spine4");
		self playsound(0, "gdt_surge_chase");
	}
}

/*
	Name: function_50dfd00b
	Namespace: cybercom
	Checksum: 0xDB02D505
	Offset: 0x25A8
	Size: 0x356
	Parameters: 7
	Flags: Linked
*/
function function_50dfd00b(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_3949887b))
	{
		stopfx(localclientnum, self.var_3949887b);
	}
	if(newval == 1)
	{
		self playsound(0, "gdt_surge_impact");
		switch(self.archetype)
		{
			case "turret":
			{
				self.var_3949887b = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_turret", self, "tag_fx");
				break;
			}
			case "amws":
			{
				self.var_3949887b = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_amws", self, "tag_head_slide_animate");
				break;
			}
			case "pamws":
			{
				self.var_3949887b = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_pamws", self, "tag_head_slide_animate");
				break;
			}
			case "raps":
			{
				self.var_3949887b = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_raps", self, "tag_wheel_front_right_animate");
				break;
			}
			case "wasp":
			{
				self.var_3949887b = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_wasp", self, "tag_body");
				break;
			}
			default:
			{
				/#
					assert(0, "");
				#/
				break;
			}
		}
	}
	else if(newval == 2)
	{
		switch(self.archetype)
		{
			case "turret":
			{
				self.var_3949887b = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_turret", self, "tag_fx");
				break;
			}
			case "amws":
			{
				self.var_3949887b = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_amws", self, "tag_head_slide_animate");
				break;
			}
			case "pamws":
			{
				self.var_3949887b = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_pamws", self, "tag_head_slide_animate");
				break;
			}
			case "raps":
			{
				self.var_3949887b = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_raps", self, "tag_wheel_front_right_animate");
				break;
			}
			case "wasp":
			{
				self.var_3949887b = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_wasp", self, "tag_body");
				break;
			}
			default:
			{
				/#
					assert(0, "");
				#/
				break;
			}
		}
	}
}

/*
	Name: function_82d4e6fe
	Namespace: cybercom
	Checksum: 0x9CA258CE
	Offset: 0x2908
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function function_82d4e6fe(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self playsound(0, "gdt_servo_robot_die");
		playfxontag(localclientnum, "electric/fx_ability_servo_shortout_robot", self, "j_spine4");
	}
	if(newval == 2)
	{
		playfxontag(localclientnum, "destruct/fx_dest_robot_limb_sparks_right", self, "j_knee_ri");
		playfxontag(localclientnum, "destruct/fx_dest_robot_limb_sparks_left", self, "j_knee_le");
	}
}

/*
	Name: function_6f88468d
	Namespace: cybercom
	Checksum: 0xBD9CB45B
	Offset: 0x29F8
	Size: 0x356
	Parameters: 7
	Flags: Linked
*/
function function_6f88468d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_3e759796))
	{
		stopfx(localclientnum, self.var_3e759796);
	}
	if(newval == 1)
	{
		self playsound(0, "gdt_servo_robot_die");
		switch(self.archetype)
		{
			case "turret":
			{
				self.var_3e759796 = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_turret", self, "tag_fx");
				break;
			}
			case "amws":
			{
				self.var_3e759796 = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_amws", self, "tag_head_slide_animate");
				break;
			}
			case "pamws":
			{
				self.var_3e759796 = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_pamws", self, "tag_head_slide_animate");
				break;
			}
			case "raps":
			{
				self.var_3e759796 = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_raps", self, "tag_wheel_front_right_animate");
				break;
			}
			case "wasp":
			{
				self.var_3e759796 = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_wasp", self, "tag_body");
				break;
			}
			default:
			{
				/#
					assert(0, "");
				#/
				break;
			}
		}
	}
	else if(newval == 2)
	{
		switch(self.archetype)
		{
			case "turret":
			{
				self.var_3e759796 = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_turret", self, "tag_fx");
				break;
			}
			case "amws":
			{
				self.var_3e759796 = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_amws", self, "tag_head_slide_animate");
				break;
			}
			case "pamws":
			{
				self.var_3e759796 = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_pamws", self, "tag_head_slide_animate");
				break;
			}
			case "raps":
			{
				self.var_3e759796 = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_raps", self, "tag_wheel_front_right_animate");
				break;
			}
			case "wasp":
			{
				self.var_3e759796 = playfxontag(localclientnum, "electric/fx_ability_elec_surge_short_upgrade_wasp", self, "tag_body");
				break;
			}
			default:
			{
				/#
					assert(0, "");
				#/
				break;
			}
		}
	}
}

/*
	Name: function_87475da2
	Namespace: cybercom
	Checksum: 0xA879A994
	Offset: 0x2D58
	Size: 0x1EC
	Parameters: 7
	Flags: Linked
*/
function function_87475da2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(self.archetype == "robot")
	{
		if(newval == 1)
		{
			self playsound(0, "gdt_immolation_robot_countdown");
		}
		else if(newval == 2)
		{
			player = getlocalplayers()[0];
			player earthquake(0.5, 0.5, self.origin, 500);
			playrumbleonposition(localclientnum, "grenade_rumble", self.origin);
			playsound(0, "wpn_incendiary_explode", self.origin);
			playfxontag(localclientnum, "explosions/fx_ability_exp_immolation", self, "j_spinelower");
			physicsexplosionsphere(localclientnum, self.origin, 200, 32, 2, 10, 1, 1, 1);
		}
	}
	else if(self.archetype == "human" || self.archetype == "human_riotshield")
	{
		if(newval == 1)
		{
			self playsound(0, "gdt_immolation_human_countdown");
		}
	}
}

/*
	Name: function_a7363f41
	Namespace: cybercom
	Checksum: 0x90467609
	Offset: 0x2F50
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function function_a7363f41(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		self playsound(0, "gdt_immolation_robot_countdown");
	}
}

/*
	Name: setiffname
	Namespace: cybercom
	Checksum: 0x8C19CEE2
	Offset: 0x2FC0
	Size: 0x236
	Parameters: 7
	Flags: Linked
*/
function setiffname(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 0:
		{
			self setdrawname();
			self.var_2b998b77 = undefined;
			self notify(#"hash_e0f9c098");
			break;
		}
		case 1:
		{
			text = makelocalizedstring("WEAPON_LINK_INPROGRESS");
			self.var_2b998b77 = text;
			self setdrawname(self.var_2b998b77, 1);
			self playsound(0, "gdt_iff_activate");
			break;
		}
		case 2:
		{
			self.var_2b998b77 = function_a4cd6b9a();
			self setdrawname(self.var_2b998b77);
			self callback::on_shutdown(&function_d48fcfa6);
			break;
		}
		case 3:
		{
			text = makelocalizedstring("WEAPON_LINK_FAILURE");
			self.var_2b998b77 = text;
			self setdrawname(self.var_2b998b77, 1);
			break;
		}
		case 4:
		{
			text = makelocalizedstring("WEAPON_LINK_TERMINATED");
			self.var_2b998b77 = text;
			self setdrawname(self.var_2b998b77, 1);
			self playsound(0, "gdt_iff_deactivate");
			break;
		}
	}
}

/*
	Name: function_13f09a6b
	Namespace: cybercom
	Checksum: 0x3A2D7FB4
	Offset: 0x3200
	Size: 0x80
	Parameters: 0
	Flags: Private
*/
function private function_13f09a6b()
{
	self endon(#"entityshutdown");
	self notify(#"hash_e0f9c098");
	self endon(#"hash_e0f9c098");
	while(true)
	{
		wait(2);
		self setdrawname(self.var_2b998b77, 2);
		wait(2);
		self setdrawname(self.var_2b998b77, 1);
	}
}

/*
	Name: function_d48fcfa6
	Namespace: cybercom
	Checksum: 0xF9A8425F
	Offset: 0x3288
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private function_d48fcfa6(localclientnum)
{
	self setdrawname();
}

/*
	Name: function_66be631b
	Namespace: cybercom
	Checksum: 0x63FC349B
	Offset: 0x32B8
	Size: 0x198
	Parameters: 0
	Flags: Linked, Private
*/
function private function_66be631b()
{
	alpha = array("A", "B", "C", "D", "E", "F");
	digit = array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9");
	var_f00997fd = (randomint(100) < 50 ? alpha[randomint(alpha.size)] : digit[randomint(digit.size)]);
	var_160c1266 = (randomint(100) < 50 ? alpha[randomint(alpha.size)] : digit[randomint(digit.size)]);
	return var_f00997fd + var_160c1266;
}

/*
	Name: function_a4cd6b9a
	Namespace: cybercom
	Checksum: 0x55A79DB3
	Offset: 0x3458
	Size: 0x122
	Parameters: 0
	Flags: Linked, Private
*/
function private function_a4cd6b9a()
{
	name = "";
	if(issubstr(self.model, "_54i_"))
	{
		var_461b88f6 = "3534:49FF:FE";
	}
	else
	{
		if(issubstr(self.model, "_nrc_"))
		{
			var_461b88f6 = "4E52:43FF:FE";
		}
		else
		{
			var_461b88f6 = "4349:41FF:FE";
		}
	}
	var_13ff0d3c = function_66be631b();
	var_86067c77 = function_66be631b();
	var_6004020e = function_66be631b();
	name = (((var_461b88f6 + var_13ff0d3c) + ":") + var_86067c77) + var_6004020e;
	return name;
}

/*
	Name: cyber_arm_pulse
	Namespace: cybercom
	Checksum: 0x50CBBFA6
	Offset: 0x3588
	Size: 0x176
	Parameters: 7
	Flags: Linked
*/
function cyber_arm_pulse(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	n_effect_duration = 1;
	n_pulse_speed = 1;
	n_number_of_pulses = 1;
	switch(newval)
	{
		case 0:
		{
			self notify(#"hash_2f142d63");
			self thread function_38e32940();
			break;
		}
		case 1:
		{
			n_pulse_speed = 3.023;
			n_effect_duration = 3.05;
			n_number_of_pulses = 4;
			self notify(#"hash_2f142d63");
			self setarmpulse(n_effect_duration, n_pulse_speed, n_number_of_pulses, "gdt_cybercore_arm_pulse");
			break;
		}
		case 2:
		{
			n_pulse_speed = 3.023;
			n_effect_duration = 3.05;
			n_number_of_pulses = 5;
			self notify(#"hash_2f142d63");
			self setarmpulse(n_effect_duration, n_pulse_speed, n_number_of_pulses, "gdt_cybercore_arm_pulse");
			break;
		}
	}
}

/*
	Name: function_38e32940
	Namespace: cybercom
	Checksum: 0x16E8FB94
	Offset: 0x3708
	Size: 0x33E
	Parameters: 0
	Flags: Linked
*/
function function_38e32940()
{
	self endon(#"entityshutdown");
	self endon(#"disconnect");
	self endon(#"hash_2f142d63");
	var_f13af102 = 0;
	var_b608e411 = 0;
	var_9fd3593c = 1;
	time_counter = 0;
	var_a36d3ca2 = getdvarint("cybercom_arm_ready", 50);
	var_b6fa88aa = getdvarint("cybercom_move_down_arm", 110);
	var_293e9a7b = getdvarint("cybercom_hold_on_arm", 290);
	var_968d78d2 = getdvarfloat("cybercom_hand_glow_shader_pct", 0.46);
	var_191c13e8 = getdvarfloat("cybercom_hand_glow_start", 0.07);
	var_266a1a59 = 690;
	var_b608e411 = var_191c13e8;
	total_time = var_266a1a59;
	while(time_counter < total_time)
	{
		current_time = time_counter;
		switch(var_f13af102)
		{
			case 0:
			{
				if(current_time > var_a36d3ca2)
				{
					var_f13af102 = 1;
				}
				else
				{
					var_9fd3593c = (0.2 - var_191c13e8) / (var_a36d3ca2 * 0.09999999);
					var_b608e411 = var_b608e411 + var_9fd3593c;
					self setarmpulseposition(var_b608e411);
				}
				break;
			}
			case 1:
			{
				if(current_time > var_b6fa88aa)
				{
					var_f13af102 = 2;
				}
				else
				{
					var_9fd3593c = (var_968d78d2 - 0.2) / ((var_b6fa88aa - var_a36d3ca2) * 0.09999999);
					var_b608e411 = var_b608e411 + var_9fd3593c;
					self setarmpulseposition(var_b608e411);
				}
				break;
			}
			case 2:
			{
				if(current_time > var_293e9a7b)
				{
					var_9fd3593c = (1 - var_968d78d2) / ((total_time - current_time) * 0.09999999);
					var_f13af102 = 3;
				}
				break;
			}
			case 3:
			{
				var_b608e411 = var_b608e411 + var_9fd3593c;
				self setarmpulseposition(var_b608e411);
				break;
			}
		}
		wait(0.01);
		time_counter = time_counter + 10;
	}
}

/*
	Name: cybercom_forcedmalfunction
	Namespace: cybercom
	Checksum: 0xFAD030DF
	Offset: 0x3A50
	Size: 0x11C
	Parameters: 7
	Flags: Linked
*/
function cybercom_forcedmalfunction(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0 && isdefined(self.var_dea2a612))
	{
		deletefx(localclientnum, self.var_dea2a612);
	}
	if(newval == 1)
	{
		if(isdefined(self.var_dea2a612))
		{
			deletefx(localclientnum, self.var_dea2a612);
		}
		tagorigin = self gettagorigin("tag_brass");
		if(isdefined(tagorigin))
		{
			self.var_dea2a612 = playfxontag(localclientnum, level._effect["forced_malfunction"], self, "tag_brass");
		}
	}
}

/*
	Name: cybercom_sensoryoverload
	Namespace: cybercom
	Checksum: 0x9659B0DF
	Offset: 0x3B78
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function cybercom_sensoryoverload(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0 && isdefined(self.var_ac70f183))
	{
		deletefx(localclientnum, self.var_ac70f183);
	}
	if(newval == 2)
	{
	}
	else
	{
	}
	if(newval != 0)
	{
		if(isdefined(self.var_ac70f183))
		{
			deletefx(localclientnum, self.var_ac70f183);
		}
		self.var_ac70f183 = playfxontag(localclientnum, level._effect["sensory_disable_human"], self, "j_neck");
	}
}

/*
	Name: function_2aa9d708
	Namespace: cybercom
	Checksum: 0x103AB7D3
	Offset: 0x3C88
	Size: 0x11C
	Parameters: 3
	Flags: Linked
*/
function function_2aa9d708(model, range, start)
{
	self notify(#"hash_2aa9d708");
	self endon(#"hash_2aa9d708");
	self endon(#"hash_14a1bc97");
	starttime = getrealtime();
	val = start / range;
	while(val <= 1)
	{
		setuimodelvalue(model, val);
		totaltime = ((getrealtime() - starttime) / 1000) + start;
		val = math::clamp(totaltime / range, 0, 1);
		wait(0.016);
	}
	setuimodelvalue(model, 0);
}

/*
	Name: function_9439eecf
	Namespace: cybercom
	Checksum: 0x6E87CF72
	Offset: 0x3DB0
	Size: 0x116
	Parameters: 7
	Flags: Linked
*/
function function_9439eecf(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	model = getuimodel(getuimodelforcontroller(localclientnum), "WorldSpaceIndicators.hackingPercent");
	if(!isdefined(model))
	{
		return;
	}
	setuimodelvalue(model, 0);
	if(newval > 0)
	{
		range = newval & 31;
		start = ((newval >> 5) / 128) * range;
		self thread function_2aa9d708(model, range, start);
	}
	else
	{
		self notify(#"hash_14a1bc97");
	}
}

/*
	Name: function_806d1a61
	Namespace: cybercom
	Checksum: 0x5E0F8EAD
	Offset: 0x3ED0
	Size: 0x20C
	Parameters: 7
	Flags: Linked
*/
function function_806d1a61(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		controllermodel = getuimodelforcontroller(localclientnum);
		var_3d954e27 = getuimodel(controllermodel, "AbilityWheel.Selected1");
		if(!isdefined(var_3d954e27))
		{
			createuimodel(controllermodel, "AbilityWheel.Selected1");
			var_3d954e27 = getuimodel(controllermodel, "AbilityWheel.Selected1");
		}
		var_cb8ddeec = getuimodel(controllermodel, "AbilityWheel.Selected2");
		if(!isdefined(var_cb8ddeec))
		{
			createuimodel(controllermodel, "AbilityWheel.Selected2");
			var_cb8ddeec = getuimodel(controllermodel, "AbilityWheel.Selected2");
		}
		var_f1905955 = getuimodel(controllermodel, "AbilityWheel.Selected3");
		if(!isdefined(var_f1905955))
		{
			createuimodel(controllermodel, "AbilityWheel.Selected3");
			var_f1905955 = getuimodel(controllermodel, "AbilityWheel.Selected3");
		}
		setuimodelvalue(var_3d954e27, 1);
		setuimodelvalue(var_cb8ddeec, 1);
		setuimodelvalue(var_f1905955, 1);
	}
}

/*
	Name: function_62d5481c
	Namespace: cybercom
	Checksum: 0x57792AD
	Offset: 0x40E8
	Size: 0xAC
	Parameters: 3
	Flags: Linked
*/
function function_62d5481c(localclientnum, var_5a8c2a63, var_191d8f6d)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	var_e4d4320f = "AbilityWheel.Selected" + (var_5a8c2a63 + 1);
	selected = getuimodel(controllermodel, var_e4d4320f);
	setuimodelvalue(selected, var_191d8f6d + 1);
}

/*
	Name: function_371a93b4
	Namespace: cybercom
	Checksum: 0x9210948C
	Offset: 0x41A0
	Size: 0x140
	Parameters: 2
	Flags: Linked
*/
function function_371a93b4(localclientnum, var_c5f458e4)
{
	var_e4230c26 = self getcybercomtype();
	controllermodel = getuimodelforcontroller(localclientnum);
	var_29ad5b90 = undefined;
	if(var_e4230c26 == 0)
	{
		var_29ad5b90 = getuimodel(controllermodel, "AbilityWheel.Selected1");
	}
	else
	{
		if(var_e4230c26 == 1)
		{
			var_29ad5b90 = getuimodel(controllermodel, "AbilityWheel.Selected2");
		}
		else if(var_e4230c26 == 2)
		{
			var_29ad5b90 = getuimodel(controllermodel, "AbilityWheel.Selected3");
		}
	}
	if(!isdefined(var_29ad5b90))
	{
		return undefined;
	}
	var_191d8f6d = getuimodelvalue(var_29ad5b90);
	if(!isdefined(var_191d8f6d))
	{
		return undefined;
	}
	return var_191d8f6d - 1;
}

