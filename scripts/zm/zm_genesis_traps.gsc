// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_trap_electric;
#using scripts\zm\_zm_traps;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace zm_genesis_traps;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_traps
	Checksum: 0x7D27CFDF
	Offset: 0x5E0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_genesis_traps", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_traps
	Checksum: 0xADFE041F
	Offset: 0x628
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.b_trap_start_custom_vo = 1;
}

/*
	Name: __main__
	Namespace: zm_genesis_traps
	Checksum: 0x21259EF7
	Offset: 0x640
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level flag::wait_till("start_zombie_round_logic");
	precache_scripted_fx();
	var_8fcfe322 = getentarray("t_flogger_trap", "targetname");
	array::thread_all(var_8fcfe322, &function_835fd6d8);
}

/*
	Name: precache_scripted_fx
	Namespace: zm_genesis_traps
	Checksum: 0xA1D27A59
	Offset: 0x6D0
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function precache_scripted_fx()
{
	level._effect["zapper"] = "dlc1/castle/fx_elec_trap_castle";
	level._effect["elec_md"] = "zombie/fx_elec_player_md_zmb";
	level._effect["elec_sm"] = "zombie/fx_elec_player_sm_zmb";
	level._effect["elec_torso"] = "zombie/fx_elec_player_torso_zmb";
}

/*
	Name: function_835fd6d8
	Namespace: zm_genesis_traps
	Checksum: 0x780BE34C
	Offset: 0x750
	Size: 0x2E4
	Parameters: 0
	Flags: Linked
*/
function function_835fd6d8()
{
	self flag::init("trap_active");
	self flag::init("trap_cooldown");
	self.zombie_cost = 1000;
	level.var_1183e023 = 0;
	self.var_ad39b789 = [];
	self.a_s_triggers = [];
	a_e_parts = getentarray(self.target, "targetname");
	for(i = 0; i < a_e_parts.size; i++)
	{
		if(isdefined(a_e_parts[i].script_noteworthy))
		{
			switch(a_e_parts[i].script_noteworthy)
			{
				case "pendulum":
				{
					self.var_4b6ad173 = a_e_parts[i];
					self enablelinkto();
					self linkto(self.var_4b6ad173);
					break;
				}
				case "gears":
				{
					self.var_52f6a55f = a_e_parts[i];
					break;
				}
				case "switch":
				{
					self.var_ad39b789[self.var_ad39b789.size] = a_e_parts[i];
					break;
				}
			}
		}
	}
	var_da104453 = struct::get_array(self.target, "targetname");
	for(i = 0; i < var_da104453.size; i++)
	{
		if(isdefined(var_da104453[i].script_noteworthy))
		{
			switch(var_da104453[i].script_noteworthy)
			{
				case "buy_trigger":
				{
					self.a_s_triggers[self.a_s_triggers.size] = var_da104453[i];
					break;
				}
				case "motor_sound_left":
				{
					self.var_f1693315 = var_da104453[i];
					break;
				}
				case "motor_sound_right":
				{
					self.var_736c69e7 = var_da104453[i];
					break;
				}
			}
		}
	}
	self thread trap_move_switches();
	self triggerenable(0);
	array::thread_all(self.a_s_triggers, &function_38d940ac, self);
}

/*
	Name: function_38d940ac
	Namespace: zm_genesis_traps
	Checksum: 0xCD3A2B81
	Offset: 0xA40
	Size: 0x210
	Parameters: 1
	Flags: Linked
*/
function function_38d940ac(var_60532813)
{
	s_unitrigger = self zm_unitrigger::create_unitrigger(&"ZOMBIE_NEED_POWER", 64, &function_dc9dafb8);
	s_unitrigger.require_look_at = 1;
	zm_unitrigger::unitrigger_force_per_player_triggers(s_unitrigger, 1);
	s_unitrigger.var_60532813 = var_60532813;
	s_unitrigger.script_int = var_60532813.script_int;
	var_60532813._trap_type = "flogger";
	while(true)
	{
		self waittill(#"trigger_activated", e_player);
		if(e_player zm_utility::in_revive_trigger())
		{
			continue;
		}
		if(e_player.is_drinking > 0)
		{
			continue;
		}
		if(!zm_utility::is_player_valid(e_player))
		{
			continue;
		}
		if(e_player zm_score::can_player_purchase(1000))
		{
			e_player zm_score::minus_to_player_score(1000);
			var_60532813 thread function_157a698(self, e_player);
			var_60532813.activated_by_player = e_player;
		}
		else
		{
			zm_utility::play_sound_at_pos("no_purchase", self.origin);
			if(isdefined(level.custom_generic_deny_vo_func))
			{
				e_player thread [[level.custom_generic_deny_vo_func]](1);
			}
			else
			{
				e_player zm_audio::create_and_play_dialog("general", "outofmoney");
			}
		}
	}
}

/*
	Name: function_dc9dafb8
	Namespace: zm_genesis_traps
	Checksum: 0xB65312AD
	Offset: 0xC58
	Size: 0x190
	Parameters: 1
	Flags: Linked
*/
function function_dc9dafb8(e_player)
{
	if(isdefined(e_player.zombie_vars["zombie_powerup_minigun_on"]) && e_player.zombie_vars["zombie_powerup_minigun_on"])
	{
		self sethintstring(&"");
		return false;
	}
	if(isdefined(self.stub.script_int) && !level flag::get("power_on" + self.stub.script_int))
	{
		self sethintstring(&"ZOMBIE_NEED_POWER");
		return false;
	}
	if(self.stub.var_60532813 flag::get("trap_active"))
	{
		self sethintstring(&"ZOMBIE_TRAP_ACTIVE");
		return false;
	}
	if(self.stub.var_60532813 flag::get("trap_cooldown"))
	{
		self sethintstring(&"ZOMBIE_TRAP_COOLDOWN");
		return false;
	}
	self sethintstring(&"ZOMBIE_BUTTON_BUY_TRAP", 1000);
	return true;
}

/*
	Name: trap_move_switches
	Namespace: zm_genesis_traps
	Checksum: 0x433DA91A
	Offset: 0xDF8
	Size: 0x278
	Parameters: 0
	Flags: Linked
*/
function trap_move_switches()
{
	for(i = 0; i < self.var_ad39b789.size; i++)
	{
		self.var_ad39b789[i] rotatepitch(-170, 0.5);
	}
	self.var_ad39b789[0] waittill(#"rotatedone");
	if(isdefined(self.script_int) && !level flag::get("power_on" + self.script_int))
	{
		level flag::wait_till("power_on" + self.script_int);
	}
	self trap_lights_green();
	while(true)
	{
		self flag::wait_till("trap_active");
		self trap_lights_red();
		for(i = 0; i < self.var_ad39b789.size; i++)
		{
			self.var_ad39b789[i] rotatepitch(170, 0.5);
			self.var_ad39b789[i] playsound("evt_switch_flip_trap");
		}
		self.var_ad39b789[0] waittill(#"rotatedone");
		self flag::wait_till("trap_cooldown");
		for(i = 0; i < self.var_ad39b789.size; i++)
		{
			self.var_ad39b789[i] rotatepitch(-170, 0.5);
		}
		self.var_ad39b789[0] waittill(#"rotatedone");
		self flag::wait_till_clear("trap_cooldown");
		self trap_lights_green();
	}
}

/*
	Name: trap_lights_red
	Namespace: zm_genesis_traps
	Checksum: 0x51CF7B6A
	Offset: 0x1078
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function trap_lights_red()
{
	if(isdefined(self.script_noteworthy))
	{
		exploder::exploder(self.script_noteworthy + "_red");
		exploder::stop_exploder(self.script_noteworthy + "_green");
	}
}

/*
	Name: trap_lights_green
	Namespace: zm_genesis_traps
	Checksum: 0xDE837D27
	Offset: 0x10E0
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function trap_lights_green()
{
	if(isdefined(self.script_noteworthy))
	{
		exploder::exploder(self.script_noteworthy + "_green");
		exploder::stop_exploder(self.script_noteworthy + "_red");
	}
}

/*
	Name: function_157a698
	Namespace: zm_genesis_traps
	Checksum: 0xB6286F6B
	Offset: 0x1148
	Size: 0x144
	Parameters: 2
	Flags: Linked
*/
function function_157a698(var_c4f1ee44, e_player)
{
	self triggerenable(1);
	self flag::set("trap_active");
	playsoundatposition("zmb_flogger_motor_start_l", self.var_f1693315.origin);
	playsoundatposition("zmb_flogger_motor_start_r", self.var_736c69e7.origin);
	wait(0.5);
	self thread function_bb59d4d9(var_c4f1ee44, e_player);
	self waittill(#"trap_done");
	self flag::clear("trap_active");
	self flag::set("trap_cooldown");
	self triggerenable(0);
	wait(45);
	self flag::clear("trap_cooldown");
}

/*
	Name: function_bb59d4d9
	Namespace: zm_genesis_traps
	Checksum: 0x7F61F5B2
	Offset: 0x1298
	Size: 0x21A
	Parameters: 2
	Flags: Linked
*/
function function_bb59d4d9(var_c4f1ee44, e_player)
{
	var_ffd9e7a0 = util::spawn_model("tag_origin", self.var_f1693315.origin);
	var_94be4c8f = util::spawn_model("tag_origin", self.var_736c69e7.origin);
	util::wait_network_frame();
	level notify(#"trap_activate", self);
	var_ffd9e7a0 playloopsound("zmb_flogger_motor_lp_l");
	var_94be4c8f playloopsound("zmb_flogger_motor_lp_r");
	self.var_4b6ad173 notsolid();
	self thread function_1f2a0da5(var_c4f1ee44, e_player);
	if(var_c4f1ee44.script_string === "reverse")
	{
		n_rotations = -14040;
	}
	else
	{
		n_rotations = 14040;
	}
	self.var_52f6a55f rotatepitch(n_rotations, 30, 6, 6);
	self.var_4b6ad173 rotatepitch(n_rotations, 30, 6, 6);
	level thread function_ec80dc42(self.var_4b6ad173);
	level thread function_e5b7e8b0(var_ffd9e7a0, var_94be4c8f);
	self.var_4b6ad173 waittill(#"rotatedone");
	self.var_4b6ad173 solid();
	self notify(#"trap_done");
}

/*
	Name: function_ec80dc42
	Namespace: zm_genesis_traps
	Checksum: 0x491C9211
	Offset: 0x14C0
	Size: 0x1C0
	Parameters: 1
	Flags: Linked
*/
function function_ec80dc42(var_4b6ad173)
{
	var_4b6ad173 endon(#"rotatedone");
	var_feed8b5b = var_4b6ad173.angles[0];
	var_dea46db3 = var_4b6ad173.angles[0];
	firsttime = 1;
	while(true)
	{
		wait(0.05);
		var_feed8b5b = var_4b6ad173.angles[0];
		var_b6c309e9 = var_dea46db3 - var_feed8b5b;
		if(firsttime)
		{
			if(var_b6c309e9 >= 80)
			{
				var_4b6ad173 playsound("zmb_flogger_blade_whoosh");
				firsttime = 0;
				var_dea46db3 = var_dea46db3 - 80;
			}
			else if(var_b6c309e9 <= -80)
			{
				var_4b6ad173 playsound("zmb_flogger_blade_whoosh");
				firsttime = 0;
				var_dea46db3 = var_dea46db3 + 80;
			}
		}
		else
		{
			if(var_b6c309e9 >= 180)
			{
				var_4b6ad173 playsound("zmb_flogger_blade_whoosh");
				var_dea46db3 = var_dea46db3 - 180;
			}
			else if(var_b6c309e9 <= -180)
			{
				var_4b6ad173 playsound("zmb_flogger_blade_whoosh");
				var_dea46db3 = var_dea46db3 + 180;
			}
		}
	}
}

/*
	Name: function_e5b7e8b0
	Namespace: zm_genesis_traps
	Checksum: 0x13BC6868
	Offset: 0x1688
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function function_e5b7e8b0(var_ffd9e7a0, var_94be4c8f)
{
	wait(24);
	var_ffd9e7a0 stoploopsound(4);
	var_ffd9e7a0 playsound("zmb_flogger_motor_stop_l");
	var_94be4c8f stoploopsound(4);
	var_94be4c8f playsound("zmb_flogger_motor_stop_r");
	wait(5);
	var_ffd9e7a0 delete();
	var_94be4c8f delete();
}

/*
	Name: function_1f2a0da5
	Namespace: zm_genesis_traps
	Checksum: 0x862E9C00
	Offset: 0x1758
	Size: 0x90
	Parameters: 2
	Flags: Linked
*/
function function_1f2a0da5(var_c4f1ee44, e_player)
{
	self endon(#"trap_done");
	while(true)
	{
		self waittill(#"trigger", e_who);
		if(isplayer(e_who))
		{
			e_who thread do_player_damage();
		}
		else
		{
			e_who thread function_af6b7901(var_c4f1ee44, e_player);
		}
	}
}

/*
	Name: do_player_damage
	Namespace: zm_genesis_traps
	Checksum: 0x1DD40823
	Offset: 0x17F0
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function do_player_damage()
{
	self endon(#"death");
	self endon(#"disconnect");
	if(level.activeplayers.size == 1)
	{
		if(!(isdefined(self.b_no_trap_damage) && self.b_no_trap_damage))
		{
			self dodamage(80, self.origin + vectorscale((0, 0, 1), 20));
		}
		self setstance("crouch");
	}
	else if(!self laststand::player_is_in_laststand())
	{
		if(!(isdefined(self.b_no_trap_damage) && self.b_no_trap_damage))
		{
			self dodamage(self.health + 100, self.origin + vectorscale((0, 0, 1), 20));
		}
	}
}

/*
	Name: function_af6b7901
	Namespace: zm_genesis_traps
	Checksum: 0x42CD2E1D
	Offset: 0x18F8
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function function_af6b7901(var_c4f1ee44, e_player)
{
	self endon(#"death");
	if(self.archetype === "parasite")
	{
		self kill();
	}
	else if(self.archetype === "zombie")
	{
		level notify(#"flogger_killed_zombie", self, e_player);
		if(!isdefined(self.var_b07a0f56))
		{
			self thread do_launch(var_c4f1ee44);
		}
	}
	if(isdefined(self.var_fbaea41d))
	{
		self thread [[self.var_fbaea41d]](e_player);
	}
}

/*
	Name: do_launch
	Namespace: zm_genesis_traps
	Checksum: 0x3AE67FD3
	Offset: 0x19C0
	Size: 0x1DC
	Parameters: 1
	Flags: Linked
*/
function do_launch(var_c4f1ee44)
{
	self.var_b07a0f56 = 1;
	self playsound("zmb_death_gibs");
	if(var_c4f1ee44.script_string === "reverse")
	{
		x = randomintrange(200, 250);
		y = randomintrange(-35, 35);
		z = randomintrange(95, 120);
	}
	else
	{
		x = randomintrange(-250, -200);
		y = randomintrange(-35, 35);
		z = randomintrange(95, 120);
	}
	if(level.var_1183e023 > 8)
	{
		self do_zombie_explode();
		return;
	}
	self thread function_f5ad0ae6();
	self startragdoll();
	self launchragdoll((x, y, z));
	util::wait_network_frame();
	self dodamage(self.health, self.origin);
	level.zombie_total++;
}

/*
	Name: function_f5ad0ae6
	Namespace: zm_genesis_traps
	Checksum: 0xF22F1E3
	Offset: 0x1BA8
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function function_f5ad0ae6()
{
	level.var_1183e023++;
	self waittill(#"death");
	level.var_1183e023--;
}

/*
	Name: do_zombie_explode
	Namespace: zm_genesis_traps
	Checksum: 0xDC003B0F
	Offset: 0x1BD0
	Size: 0x94
	Parameters: 0
	Flags: Linked, Private
*/
function private do_zombie_explode()
{
	util::wait_network_frame();
	if(isdefined(self))
	{
		self zombie_utility::zombie_eye_glow_stop();
		self clientfield::increment("skull_turret_explode_fx");
		self ghost();
		self util::delay(0.25, undefined, &zm_utility::self_delete);
	}
}

