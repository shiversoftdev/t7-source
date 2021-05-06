// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_bb;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace bgb_machine;

/*
	Name: __init__sytem__
	Namespace: bgb_machine
	Checksum: 0x88E3F9C8
	Offset: 0x540
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("bgb_machine", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: bgb_machine
	Checksum: 0xCF3111BF
	Offset: 0x588
	Size: 0x17C
	Parameters: 0
	Flags: Linked, Private
*/
private function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	callback::on_connect(&on_player_connect);
	callback::on_disconnect(&on_player_disconnect);
	clientfield::register("zbarrier", "zm_bgb_machine", 1, 1, "int");
	clientfield::register("zbarrier", "zm_bgb_machine_selection", 1, 8, "int");
	clientfield::register("zbarrier", "zm_bgb_machine_fx_state", 1, 3, "int");
	clientfield::register("zbarrier", "zm_bgb_machine_ghost_ball", 1, 1, "int");
	clientfield::register("toplayer", "zm_bgb_machine_round_buys", 10000, 3, "int");
	level thread function_4fb7632c();
	if(!isdefined(level.var_42792b8b))
	{
		level.var_42792b8b = 0;
	}
}

/*
	Name: __main__
	Namespace: bgb_machine
	Checksum: 0x8A8D9F59
	Offset: 0x710
	Size: 0x12C
	Parameters: 0
	Flags: Linked, Private
*/
private function __main__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	if(!isdefined(level.var_6cb6a683))
	{
		level.var_6cb6a683 = 3;
	}
	if(!isdefined(level.var_f02c5598))
	{
		level.var_f02c5598 = 1000;
	}
	if(!isdefined(level.var_e1dee7ba))
	{
		level.var_e1dee7ba = 10;
	}
	if(!isdefined(level.var_a3e3127d))
	{
		level.var_a3e3127d = 2;
	}
	if(!isdefined(level.var_8ef45dc2))
	{
		level.var_8ef45dc2 = 10;
	}
	if(!isdefined(level.var_1485dcdc))
	{
		level.var_1485dcdc = 2;
	}
	if(!isdefined(level.var_d776839c))
	{
		level.var_d776839c = 1000;
	}
	if(!isdefined(level.var_d453a2ed))
	{
		level.var_d453a2ed = 1;
	}
	if(!isdefined(level.var_cc480293))
	{
		level.var_cc480293 = &function_cffffa44;
	}
	/#
		level thread setup_devgui();
	#/
	level thread function_8115371();
}

/*
	Name: on_player_connect
	Namespace: bgb_machine
	Checksum: 0xAD8B048A
	Offset: 0x848
	Size: 0x34
	Parameters: 0
	Flags: Linked, Private
*/
private function on_player_connect()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	level thread function_d83737d3();
}

/*
	Name: on_player_disconnect
	Namespace: bgb_machine
	Checksum: 0x6935E52B
	Offset: 0x888
	Size: 0x34
	Parameters: 0
	Flags: Linked, Private
*/
private function on_player_disconnect()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	level thread function_d83737d3();
}

/*
	Name: setup_devgui
	Namespace: bgb_machine
	Checksum: 0xCC01B82C
	Offset: 0x8C8
	Size: 0x254
	Parameters: 0
	Flags: Linked, Private
*/
private function setup_devgui()
{
	/#
		waittillframeend();
		setdvar("", 0);
		setdvar("", 0);
		setdvar("", "");
		setdvar("", 0);
		setdvar("", 0);
		bgb_devgui_base = "";
		adddebugcommand(bgb_devgui_base + "" + "" + "");
		keys = getarraykeys(level.bgb);
		for(i = 0; i < keys.size; i++)
		{
			adddebugcommand(bgb_devgui_base + "" + keys[i] + "" + "" + "" + keys[i] + "");
		}
		adddebugcommand(bgb_devgui_base + "" + "" + "");
		adddebugcommand(bgb_devgui_base + "" + "" + "");
		adddebugcommand(bgb_devgui_base + "" + "" + "");
		adddebugcommand(bgb_devgui_base + "" + "" + "");
		level thread function_95dc1528();
	#/
}

/*
	Name: function_95dc1528
	Namespace: bgb_machine
	Checksum: 0x71FB99E9
	Offset: 0xB28
	Size: 0x3A8
	Parameters: 0
	Flags: Linked, Private
*/
private function function_95dc1528()
{
	/#
		for(;;)
		{
			arrive = getdvarint("");
			move = getdvarint("");
			if(move || arrive)
			{
				pos = level.players[0].origin;
				best_dist_sq = 999999999;
				best_index = -1;
				for(i = 0; i < level.var_5081bd63.size; i++)
				{
					var_7f58a9c3 = distancesquared(pos, level.var_5081bd63[i].origin);
					if(var_7f58a9c3 < best_dist_sq)
					{
						best_index = i;
						best_dist_sq = var_7f58a9c3;
					}
				}
				if(0 <= best_index)
				{
					if(arrive)
					{
						if(!level.var_5081bd63[best_index].var_4d6e7e5e)
						{
							for(i = 0; i < level.var_5081bd63.size; i++)
							{
								if(level.var_5081bd63[i].var_4d6e7e5e)
								{
									level.var_5081bd63[i] thread function_3f75d3b();
									break;
								}
							}
							level.var_5081bd63[best_index].var_4d6e7e5e = 1;
							level.var_5081bd63[best_index] thread function_13565590();
						}
					}
					else
					{
						level.var_5081bd63[best_index] thread function_872660fc();
					}
				}
				setdvar("", 0);
				setdvar("", 0);
			}
			var_113a43ca = getdvarstring("");
			if(getdvarint("") || "" != var_113a43ca)
			{
				for(i = 0; i < level.players.size; i++)
				{
					level.players[i].var_85da8a33 = 0;
					level.players[i] clientfield::set_to_player("", level.players[i].var_85da8a33);
				}
				setdvar("", 0);
			}
			if("" != var_113a43ca)
			{
				level.var_fcfc78d0 = var_113a43ca;
				setdvar("", "");
			}
			wait(0.5);
		}
	#/
}

/*
	Name: function_8115371
	Namespace: bgb_machine
	Checksum: 0xA7B45725
	Offset: 0xED8
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
private function function_8115371()
{
	waittillframeend();
	level.var_5081bd63 = getentarray("bgb_machine_use", "targetname");
	function_62051f89();
}

/*
	Name: function_62051f89
	Namespace: bgb_machine
	Checksum: 0xE939DD37
	Offset: 0xF20
	Size: 0x1F4
	Parameters: 0
	Flags: Linked, Private
*/
private function function_62051f89()
{
	if(!level.var_5081bd63.size)
	{
		return;
	}
	for(i = 0; i < level.var_5081bd63.size; i++)
	{
		if(!isdefined(level.var_5081bd63[i].base_cost))
		{
			level.var_5081bd63[i].base_cost = 500;
		}
		level.var_5081bd63[i].old_cost = level.var_5081bd63[i].base_cost;
		level.var_5081bd63[i].var_4d6e7e5e = 0;
		level.var_5081bd63[i].uses_at_current_location = 0;
		level.var_5081bd63[i] function_c4ed49b();
	}
	if(!level.enable_magic)
	{
		foreach(var_18d6dc71, bgb_machine in level.var_5081bd63)
		{
			bgb_machine thread function_3f75d3b();
		}
		return;
	}
	level.var_5081bd63 = array::randomize(level.var_5081bd63);
	function_a5bbc4ee();
	array::thread_all(level.var_5081bd63, &function_d9f9a9c1);
}

/*
	Name: function_a5bbc4ee
	Namespace: bgb_machine
	Checksum: 0xC5B5EBC5
	Offset: 0x1120
	Size: 0x214
	Parameters: 0
	Flags: Linked, Private
*/
private function function_a5bbc4ee()
{
	var_ed3848d8 = 0;
	var_ff664010 = [];
	for(i = 0; i < level.var_5081bd63.size; i++)
	{
		level.var_5081bd63[i] clientfield::set("zm_bgb_machine", 1);
		if(var_ed3848d8 >= level.var_d776839c || !isdefined(level.var_5081bd63[i].script_noteworthy) || !issubstr(level.var_5081bd63[i].script_noteworthy, "start_bgb_machine"))
		{
			var_ff664010[var_ff664010.size] = level.var_5081bd63[i];
			continue;
		}
		level.var_5081bd63[i].hidden = 0;
		level.var_5081bd63[i].var_4d6e7e5e = 1;
		level.var_5081bd63[i] function_561f90cb("initial");
		var_ed3848d8++;
	}
	for(i = 0; i < var_ff664010.size; i++)
	{
		if(var_ed3848d8 >= level.var_d776839c)
		{
			var_ff664010[i] thread function_3f75d3b();
			continue;
		}
		var_ff664010[i].hidden = 0;
		var_ff664010[i].var_4d6e7e5e = 1;
		var_ff664010[i] function_561f90cb("initial");
		var_ed3848d8++;
	}
}

/*
	Name: function_c4ed49b
	Namespace: bgb_machine
	Checksum: 0xD9B7226F
	Offset: 0x1340
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function function_c4ed49b()
{
	self.unitrigger_stub = spawnstruct();
	self.unitrigger_stub.script_width = 30;
	self.unitrigger_stub.script_height = 70;
	self.unitrigger_stub.script_length = 25;
	self.unitrigger_stub.origin = self.origin + anglestoright(self.angles) * self.unitrigger_stub.script_length + anglestoup(self.angles) * self.unitrigger_stub.script_height / 2;
	self.unitrigger_stub.angles = self.angles;
	self.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	self.unitrigger_stub.trigger_target = self;
	zm_unitrigger::unitrigger_force_per_player_triggers(self.unitrigger_stub, 1);
	self.unitrigger_stub.prompt_and_visibility_func = &function_30e4012c;
}

/*
	Name: function_30e4012c
	Namespace: bgb_machine
	Checksum: 0x664AA04F
	Offset: 0x1490
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function function_30e4012c(player)
{
	can_use = self function_ec0482ba(player);
	if(isdefined(self.hint_string))
	{
		if(isdefined(self.hint_parm1))
		{
			self sethintstring(self.hint_string, self.hint_parm1);
		}
		else
		{
			self sethintstring(self.hint_string);
		}
	}
	return can_use;
}

/*
	Name: function_6c7a96b4
	Namespace: bgb_machine
	Checksum: 0xC25EA1F0
	Offset: 0x1528
	Size: 0x1C8
	Parameters: 2
	Flags: Linked
*/
function function_6c7a96b4(player, base_cost)
{
	if(player.var_85da8a33 < 1 && getdvarint("scr_firstGumFree") === 1)
	{
		return 0;
	}
	if(!isdefined(level.var_f02c5598))
	{
		level.var_f02c5598 = 1000;
	}
	if(!isdefined(level.var_e1dee7ba))
	{
		level.var_e1dee7ba = 10;
	}
	if(!isdefined(level.var_1485dcdc))
	{
		level.var_1485dcdc = 2;
	}
	cost = 500;
	if(player.var_85da8a33 >= 1)
	{
		var_33ea806b = floor(level.round_number / level.var_e1dee7ba);
		var_33ea806b = math::clamp(var_33ea806b, 0, level.var_8ef45dc2);
		var_39a90c5a = pow(level.var_a3e3127d, var_33ea806b);
		cost = cost + level.var_f02c5598 * var_39a90c5a;
	}
	if(player.var_85da8a33 >= 2)
	{
		cost = cost * level.var_1485dcdc;
	}
	cost = int(cost);
	if(500 != base_cost)
	{
		cost = cost - 500 - base_cost;
	}
	return cost;
}

/*
	Name: function_ec0482ba
	Namespace: bgb_machine
	Checksum: 0xBC9C007E
	Offset: 0x16F8
	Size: 0x248
	Parameters: 1
	Flags: Linked
*/
function function_ec0482ba(player)
{
	b_result = 0;
	if(!self trigger_visible_to_player(player))
	{
		return b_result;
	}
	self.hint_parm1 = undefined;
	if(isdefined(self.stub.trigger_target.var_a2b01d1d) && self.stub.trigger_target.var_a2b01d1d)
	{
		if(!(isdefined(self.stub.trigger_target.var_16d95df4) && self.stub.trigger_target.var_16d95df4))
		{
			str_hint = &"ZOMBIE_BGB_MACHINE_OUT_OF";
			b_result = 0;
		}
		else
		{
			str_hint = &"ZOMBIE_BGB_MACHINE_OFFERING";
			b_result = 1;
		}
		cursor_hint = "HINT_BGB";
		var_562e3c5 = level.bgb[self.stub.trigger_target.var_b287be].item_index;
		self setcursorhint(cursor_hint, var_562e3c5);
		self.hint_string = str_hint;
	}
	else
	{
		self setcursorhint("HINT_NOICON");
		if(player.var_85da8a33 < level.var_6cb6a683)
		{
			if(isdefined(level.var_42792b8b) && level.var_42792b8b)
			{
				self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE_CFILL";
			}
			else
			{
				self.hint_string = &"ZOMBIE_BGB_MACHINE_AVAILABLE";
				self.hint_parm1 = function_6c7a96b4(player, self.stub.trigger_target.base_cost);
			}
			b_result = 1;
		}
		else
		{
			self.hint_string = &"ZOMBIE_BGB_MACHINE_COMEBACK";
			b_result = 0;
		}
	}
	return b_result;
}

/*
	Name: trigger_visible_to_player
	Namespace: bgb_machine
	Checksum: 0x189F1957
	Offset: 0x1948
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function trigger_visible_to_player(player)
{
	self setinvisibletoplayer(player);
	visible = 1;
	if(!player zm_magicbox::can_buy_weapon())
	{
		visible = 0;
	}
	if(!visible)
	{
		return 0;
	}
	if(isdefined(self.stub.trigger_target.var_492b876) && player !== self.stub.trigger_target.var_492b876)
	{
		return 0;
	}
	self setvisibletoplayer(player);
	return 1;
}

/*
	Name: function_ededc488
	Namespace: bgb_machine
	Checksum: 0x346BA220
	Offset: 0x1A10
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_ededc488()
{
	self endon(#"kill_trigger");
	while(true)
	{
		self waittill(#"trigger", player);
		self.stub.trigger_target notify(#"trigger", player);
	}
}

/*
	Name: function_13565590
	Namespace: bgb_machine
	Checksum: 0xA993BA4C
	Offset: 0x1A70
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_13565590()
{
	self function_561f90cb("arriving");
	self waittill(#"arrived");
	self.hidden = 0;
}

/*
	Name: function_3f75d3b
	Namespace: bgb_machine
	Checksum: 0xA81C74FE
	Offset: 0x1AB8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function function_3f75d3b(var_4600cfd0)
{
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	self.hidden = 1;
	self.uses_at_current_location = 0;
	self.var_4d6e7e5e = 0;
	if(isdefined(var_4600cfd0) && var_4600cfd0)
	{
		self thread function_561f90cb("leaving");
	}
	else
	{
		self thread function_561f90cb("away");
	}
}

/*
	Name: function_5bd3a49b
	Namespace: bgb_machine
	Checksum: 0xBCCB4055
	Offset: 0x1B60
	Size: 0x1CA
	Parameters: 1
	Flags: Linked, Private
*/
private function function_5bd3a49b(player)
{
	if(!player.var_8414308a.size)
	{
		player.var_8414308a = array::randomize(player.var_98ba48a2);
	}
	self.var_b287be = array::pop_front(player.var_8414308a);
	/#
		if(isdefined(level.var_fcfc78d0))
		{
			self.var_b287be = level.var_fcfc78d0;
			level.var_fcfc78d0 = undefined;
			if("" == self.var_b287be)
			{
				keys = array::randomize(getarraykeys(level.bgb));
				for(i = 0; i < keys.size; i++)
				{
					if(level.bgb[keys[i]].consumable)
					{
						self.var_b287be = keys[i];
						break;
					}
				}
				clientfield::set("", level.bgb[self.var_b287be].item_index);
				return 0;
			}
		}
	#/
	clientfield::set("zm_bgb_machine_selection", level.bgb[self.var_b287be].item_index);
	return player bgb::function_f59fbff(self.var_b287be);
}

/*
	Name: function_d9f9a9c1
	Namespace: bgb_machine
	Checksum: 0x29F0CC66
	Offset: 0x1D38
	Size: 0xA1C
	Parameters: 0
	Flags: Linked
*/
function function_d9f9a9c1()
{
	var_9bbdff4d = -1;
	while(true)
	{
		var_5e7af4df = undefined;
		self waittill(#"trigger", user);
		var_9bbdff4d = -1;
		if(isdefined(user.bgb) && isdefined(level.bgb[user.bgb]))
		{
			var_9bbdff4d = level.bgb[user.bgb].item_index;
		}
		var_5e7af4df = gettime();
		if(user == level)
		{
			continue;
		}
		if(user zm_utility::in_revive_trigger())
		{
			wait(0.1);
			continue;
		}
		if(user.is_drinking > 0)
		{
			wait(0.1);
			continue;
		}
		if(isdefined(self.disabled) && self.disabled)
		{
			wait(0.1);
			continue;
		}
		if(user getcurrentweapon() == level.weaponnone)
		{
			wait(0.1);
			continue;
		}
		var_625e97d1 = 0;
		cost = function_6c7a96b4(user, self.base_cost);
		if(zm_utility::is_player_valid(user) && user zm_score::can_player_purchase(cost))
		{
			user zm_score::minus_to_player_score(cost);
			self.var_492b876 = user;
			self.current_cost = cost;
			if(user bgb::is_enabled("zm_bgb_shopping_free"))
			{
				var_625e97d1 = 1;
			}
			break;
		}
		else
		{
			zm_utility::play_sound_at_pos("no_purchase", self.origin);
			user zm_audio::create_and_play_dialog("general", "outofmoney");
			continue;
		}
		wait(0.05);
	}
	if(isdefined(level.var_5912cc2e))
	{
		user thread [[level.var_5912cc2e]]();
	}
	user.var_85da8a33++;
	user clientfield::set_to_player("zm_bgb_machine_round_buys", user.var_85da8a33);
	self.var_492b876 = user;
	self.var_bc4509eb = 1;
	self.var_a23dc60f = 0;
	if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		self.var_a23dc60f = 1;
	}
	else
	{
		self.uses_at_current_location++;
	}
	self.var_16d95df4 = self thread function_5bd3a49b(user);
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	self function_561f90cb("open");
	self waittill(#"hash_c5d46831");
	self.var_a2b01d1d = 1;
	self thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &function_ededc488);
	gumballtaken = 0;
	gumballoffered = 0;
	var_8a2037cd = 0;
	if(self.var_16d95df4)
	{
		bb::function_91f32a58(user, self, self.current_cost, self.var_b287be, 0, "_bgb", "_offered");
		if(isdefined(level.bgb[self.var_b287be]))
		{
			gumballoffered = level.bgb[self.var_b287be].item_index;
		}
		while(true)
		{
			self waittill(#"trigger", grabber);
			if(isdefined(grabber.is_drinking) && grabber.is_drinking > 0)
			{
				wait(0.1);
				continue;
			}
			if(grabber == user && user getcurrentweapon() == level.weaponnone)
			{
				wait(0.1);
				continue;
			}
			if(grabber == user || grabber == level)
			{
				current_weapon = level.weaponnone;
				if(zm_utility::is_player_valid(user))
				{
					current_weapon = user getcurrentweapon();
				}
				if(grabber == user && zm_utility::is_player_valid(user) && !(user.is_drinking > 0) && !zm_utility::is_placeable_mine(current_weapon) && !zm_equipment::is_equipment(current_weapon) && !user zm_utility::is_player_revive_tool(current_weapon) && !current_weapon.isheroweapon && !current_weapon.isgadget)
				{
					self notify(#"hash_69873c12");
					user notify(#"hash_69873c12");
					bb::function_91f32a58(user, self, self.current_cost, self.var_b287be, 0, "_bgb", "_grabbed");
					user recordmapevent(3, gettime(), user.origin, level.round_number, var_9bbdff4d, gumballoffered);
					user __protected__notelootconsume(self.var_b287be, 1);
					user bgb::function_66a597c1(self.var_b287be);
					gumballtaken = 1;
					__protected__setbgbunlocked(1);
					user thread bgb::bgb_gumball_anim(self.var_b287be, 0);
					__protected__setbgbunlocked(0);
					if(isdefined(level.var_361ee139))
					{
						user thread [[level.var_361ee139]](self);
					}
					else
					{
						user thread function_acf1c4da(self);
					}
					user zm_stats::increment_challenge_stat("ZM_DAILY_EAT_GOBBLEGUM");
					break;
				}
				else if(grabber == level)
				{
					bb::function_91f32a58(user, self, self.current_cost, self.var_b287be, 0, "_bgb", "_returned");
					break;
				}
			}
			wait(0.05);
		}
		if(grabber == user)
		{
			self function_561f90cb("close");
			self waittill(#"closed");
		}
	}
	else
	{
		self waittill(#"trigger");
		bb::function_91f32a58(user, self, self.current_cost, self.var_b287be, 0, "_bgb", "_ghostball");
		if(!var_625e97d1)
		{
			user zm_score::add_to_player_score(self.current_cost, 0, "bgb_machine_ghost_ball");
		}
		var_8a2037cd = 1;
	}
	user recordzombiegumballevent(var_5e7af4df, self.origin, gumballoffered, var_9bbdff4d, gumballtaken, var_8a2037cd, self.var_a23dc60f);
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	self.var_a2b01d1d = 0;
	wait(1);
	if(function_d8680cd2())
	{
		self thread function_872660fc();
	}
	else if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"] || self.var_4d6e7e5e)
	{
		self thread function_561f90cb("initial");
	}
	self.var_bc4509eb = 0;
	self.var_a23dc60f = 0;
	self.var_492b876 = undefined;
	self notify(#"hash_62124c1e");
	self thread function_d9f9a9c1();
}

/*
	Name: function_d8680cd2
	Namespace: bgb_machine
	Checksum: 0x1913383E
	Offset: 0x2760
	Size: 0xA4
	Parameters: 0
	Flags: Linked, Private
*/
private function function_d8680cd2()
{
	/#
		if(getdvarint(""))
		{
			return 0;
		}
	#/
	if(isdefined(level.var_d453a2ed) && level.var_d453a2ed)
	{
		return 0;
	}
	if(self.uses_at_current_location >= level.var_d118bcf4)
	{
		return 1;
	}
	if(self.uses_at_current_location < level.var_82f744de)
	{
		return 0;
	}
	if(randomint(100) < 30)
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_d83737d3
	Namespace: bgb_machine
	Checksum: 0x7584FCB8
	Offset: 0x2810
	Size: 0xCA
	Parameters: 0
	Flags: Linked, Private
*/
private function function_d83737d3()
{
	if(isdefined(level.var_cfc8eddf))
	{
		[[level.var_cfc8eddf]]();
		return;
	}
	switch(level.players.size)
	{
		case 1:
		{
			level.var_82f744de = 1;
			level.var_d118bcf4 = 3;
			break;
		}
		case 2:
		{
			level.var_82f744de = 1;
			level.var_d118bcf4 = 4;
			break;
		}
		case 3:
		{
			level.var_82f744de = 3;
			level.var_d118bcf4 = 5;
			break;
		}
		case 4:
		{
			level.var_82f744de = 3;
			level.var_d118bcf4 = 6;
			break;
		}
	}
}

/*
	Name: turn_on_fire_sale
	Namespace: bgb_machine
	Checksum: 0x2E12BC0B
	Offset: 0x28E8
	Size: 0xD6
	Parameters: 0
	Flags: Linked
*/
function turn_on_fire_sale()
{
	for(i = 0; i < level.var_5081bd63.size; i++)
	{
		level.var_5081bd63[i].old_cost = level.var_5081bd63[i].base_cost;
		level.var_5081bd63[i].base_cost = 10;
		if(!level.var_5081bd63[i].var_4d6e7e5e)
		{
			level.var_5081bd63[i].var_7ec446a0 = 1;
			level.var_5081bd63[i] thread function_13565590();
		}
	}
}

/*
	Name: turn_off_fire_sale
	Namespace: bgb_machine
	Checksum: 0xDD5B9175
	Offset: 0x29C8
	Size: 0xEE
	Parameters: 0
	Flags: Linked
*/
function turn_off_fire_sale()
{
	for(i = 0; i < level.var_5081bd63.size; i++)
	{
		level.var_5081bd63[i].base_cost = level.var_5081bd63[i].old_cost;
		if(!level.var_5081bd63[i].var_4d6e7e5e && (isdefined(level.var_5081bd63[i].var_7ec446a0) && level.var_5081bd63[i].var_7ec446a0))
		{
			level.var_5081bd63[i].var_7ec446a0 = undefined;
			level.var_5081bd63[i] thread function_348263ec();
		}
	}
}

/*
	Name: function_348263ec
	Namespace: bgb_machine
	Checksum: 0xF0DCDE0F
	Offset: 0x2AC0
	Size: 0x84
	Parameters: 0
	Flags: Linked, Private
*/
private function function_348263ec()
{
	while(isdefined(self.var_492b876) || (isdefined(self.var_bc4509eb) && self.var_bc4509eb))
	{
		util::wait_network_frame();
	}
	if(level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		self.var_7ec446a0 = 1;
		self.base_cost = 10;
		return;
	}
	self thread function_3f75d3b(1);
}

/*
	Name: function_872660fc
	Namespace: bgb_machine
	Checksum: 0xAEED0965
	Offset: 0x2B50
	Size: 0x1F2
	Parameters: 0
	Flags: Linked
*/
function function_872660fc()
{
	self function_3f75d3b(1);
	wait(0.1);
	post_selection_wait_duration = 7;
	if(isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]) && level.zombie_vars["zombie_powerup_fire_sale_on"])
	{
		current_sale_time = level.zombie_vars["zombie_powerup_fire_sale_time"];
		util::wait_network_frame();
		self thread fire_sale_fix();
		level.zombie_vars["zombie_powerup_fire_sale_time"] = current_sale_time;
		while(level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
		{
			wait(0.1);
		}
	}
	else
	{
		post_selection_wait_duration = post_selection_wait_duration + 5;
	}
	wait(post_selection_wait_duration);
	keys = getarraykeys(level.var_5081bd63);
	keys = array::randomize(keys);
	for(i = 0; i < keys.size; i++)
	{
		if(self == level.var_5081bd63[keys[i]] || level.var_5081bd63[keys[i]].var_4d6e7e5e)
		{
			continue;
		}
		level.var_5081bd63[keys[i]].var_4d6e7e5e = 1;
		level.var_5081bd63[keys[i]] function_13565590();
		break;
	}
}

/*
	Name: fire_sale_fix
	Namespace: bgb_machine
	Checksum: 0x47B2B5CE
	Offset: 0x2D50
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function fire_sale_fix()
{
	if(!isdefined(level.zombie_vars["zombie_powerup_fire_sale_on"]))
	{
		return;
	}
	self.old_cost = self.base_cost;
	self thread function_13565590();
	self.base_cost = 10;
	util::wait_network_frame();
	level waittill(#"fire_sale_off");
	while(isdefined(self.var_bc4509eb) && self.var_bc4509eb)
	{
		wait(0.1);
	}
	self thread function_3f75d3b(1);
	self.base_cost = self.old_cost;
}

/*
	Name: function_ca233e7d
	Namespace: bgb_machine
	Checksum: 0xDEC16793
	Offset: 0x2E18
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_ca233e7d()
{
	self endon(#"zbarrier_state_change");
	clientfield::set("zm_bgb_machine_fx_state", 1);
	self setzbarrierpiecestate(0, "closed");
	self setzbarrierpiecestate(5, "closed");
	while(true)
	{
		wait(randomfloatrange(180, 1800));
		self setzbarrierpiecestate(0, "opening");
		wait(randomfloatrange(180, 1800));
		self setzbarrierpiecestate(0, "closing");
	}
}

/*
	Name: function_1174bcd9
	Namespace: bgb_machine
	Checksum: 0x34A4D46A
	Offset: 0x2F08
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_1174bcd9()
{
	clientfield::set("zm_bgb_machine_fx_state", 4);
	self setzbarrierpiecestate(2, "open");
	self setzbarrierpiecestate(3, "open");
	self setzbarrierpiecestate(5, "closed");
}

/*
	Name: function_e7f3a3f5
	Namespace: bgb_machine
	Checksum: 0xFF4549D8
	Offset: 0x2F98
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_e7f3a3f5()
{
	self endon(#"zbarrier_state_change");
	self setzbarrierpiecestate(3, "closed");
	clientfield::set("zm_bgb_machine_fx_state", 2);
	self setzbarrierpiecestate(1, "opening");
	while(self getzbarrierpiecestate(1) == "opening")
	{
		wait(0.05);
	}
	self setzbarrierpiecestate(1, "closing");
	self setzbarrierpiecestate(3, "opening");
	while(self getzbarrierpiecestate(1) == "closing")
	{
		wait(0.05);
	}
	self notify(#"arrived");
	self thread function_561f90cb("initial");
}

/*
	Name: function_4aa434eb
	Namespace: bgb_machine
	Checksum: 0x66B60AEB
	Offset: 0x30D8
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_4aa434eb()
{
	self endon(#"zbarrier_state_change");
	self setzbarrierpiecestate(3, "open");
	clientfield::set("zm_bgb_machine_fx_state", 2);
	self setzbarrierpiecestate(1, "opening");
	while(self getzbarrierpiecestate(1) == "opening")
	{
		wait(0.05);
	}
	self setzbarrierpiecestate(1, "closing");
	self setzbarrierpiecestate(3, "closing");
	while(self getzbarrierpiecestate(1) == "closing")
	{
		wait(0.05);
	}
	self notify(#"left");
	self thread function_561f90cb("away");
}

/*
	Name: function_118970ca
	Namespace: bgb_machine
	Checksum: 0x5D71BA03
	Offset: 0x3218
	Size: 0x1CA
	Parameters: 0
	Flags: Linked
*/
function function_118970ca()
{
	self endon(#"zbarrier_state_change");
	self setzbarrierpiecestate(3, "open");
	self setzbarrierpiecestate(5, "closed");
	clientfield::set("zm_bgb_machine_ghost_ball", !self.var_16d95df4);
	state = "opening";
	if(math::cointoss())
	{
		state = "closing";
	}
	self setzbarrierpiecestate(4, state);
	while(self getzbarrierpiecestate(4) == state)
	{
		wait(0.05);
	}
	self setzbarrierpiecestate(2, "opening");
	wait(1);
	clientfield::set("zm_bgb_machine_fx_state", 3);
	self notify(#"hash_c5d46831");
	wait(5.5);
	clientfield::set("zm_bgb_machine_fx_state", 4);
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	while(self getzbarrierpiecestate(2) == "opening")
	{
		wait(0.05);
	}
	self notify(#"trigger", level);
}

/*
	Name: function_ed2e5150
	Namespace: bgb_machine
	Checksum: 0xA3177C7
	Offset: 0x33F0
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function function_ed2e5150()
{
	self endon(#"zbarrier_state_change");
	self setzbarrierpiecestate(3, "open");
	self setzbarrierpiecestate(5, "closed");
	clientfield::set("zm_bgb_machine_fx_state", 4);
	self setzbarrierpiecestate(2, "closing");
	while(self getzbarrierpiecestate(2) == "closing")
	{
		wait(0.05);
	}
	self notify(#"closed");
}

/*
	Name: function_b56ef180
	Namespace: bgb_machine
	Checksum: 0x33CC9153
	Offset: 0x34C8
	Size: 0x50
	Parameters: 0
	Flags: None
*/
function function_b56ef180()
{
	curr_state = self function_8ae729a7();
	if(curr_state == "open" || curr_state == "close")
	{
		return 1;
	}
	return 0;
}

/*
	Name: function_8ae729a7
	Namespace: bgb_machine
	Checksum: 0x87E5FA36
	Offset: 0x3520
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function function_8ae729a7()
{
	return self.state;
}

/*
	Name: function_561f90cb
	Namespace: bgb_machine
	Checksum: 0xA4F5D29A
	Offset: 0x3538
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function function_561f90cb(state)
{
	for(i = 0; i < self getnumzbarrierpieces(); i++)
	{
		self hidezbarrierpiece(i);
	}
	self notify(#"zbarrier_state_change");
	self [[level.var_cc480293]](state);
}

/*
	Name: function_cffffa44
	Namespace: bgb_machine
	Checksum: 0x73DAF883
	Offset: 0x35C0
	Size: 0x33A
	Parameters: 1
	Flags: Linked
*/
function function_cffffa44(state)
{
	switch(state)
	{
		case "away":
		{
			self showzbarrierpiece(0);
			self showzbarrierpiece(5);
			self thread function_ca233e7d();
			self.state = "away";
			break;
		}
		case "arriving":
		{
			self showzbarrierpiece(1);
			self showzbarrierpiece(3);
			self thread function_e7f3a3f5();
			self.state = "arriving";
			break;
		}
		case "initial":
		{
			self showzbarrierpiece(2);
			self showzbarrierpiece(3);
			self showzbarrierpiece(5);
			self thread function_1174bcd9();
			self thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &function_ededc488);
			self.state = "initial";
			break;
		}
		case "open":
		{
			self showzbarrierpiece(2);
			self showzbarrierpiece(3);
			self showzbarrierpiece(4);
			self showzbarrierpiece(5);
			self thread function_118970ca();
			self.state = "open";
			break;
		}
		case "close":
		{
			self showzbarrierpiece(2);
			self showzbarrierpiece(3);
			self showzbarrierpiece(5);
			self thread function_ed2e5150();
			self.state = "close";
			break;
		}
		case "leaving":
		{
			self showzbarrierpiece(1);
			self showzbarrierpiece(3);
			self thread function_4aa434eb();
			self.state = "leaving";
			break;
		}
		default:
		{
			if(isdefined(level.var_50c3449d))
			{
				self [[level.var_50c3449d]](state);
			}
			break;
		}
	}
}

/*
	Name: function_4fb7632c
	Namespace: bgb_machine
	Checksum: 0xB0454634
	Offset: 0x3908
	Size: 0xF6
	Parameters: 0
	Flags: Linked
*/
function function_4fb7632c()
{
	level endon(#"end_game");
	level notify(#"hash_4fb7632c");
	level endon(#"hash_4fb7632c");
	while(true)
	{
		level waittill(#"host_migration_end");
		if(!isdefined(level.var_5081bd63))
		{
			continue;
		}
		foreach(var_e4848d2, bgb_machine in level.var_5081bd63)
		{
			util::wait_network_frame();
		}
	}
}

/*
	Name: function_acf1c4da
	Namespace: bgb_machine
	Checksum: 0xBE0ED8CB
	Offset: 0x3A08
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_acf1c4da(machine)
{
	if(isdefined(level.bgb[machine.var_b287be]) && level.bgb[machine.var_b287be].limit_type == "activated")
	{
		self zm_audio::create_and_play_dialog("bgb", "buy");
	}
	else
	{
		self zm_audio::create_and_play_dialog("bgb", "eat");
	}
}

