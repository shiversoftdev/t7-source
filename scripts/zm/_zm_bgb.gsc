// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_bgb_machine;
#using scripts\zm\_zm_bgb_token;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\gametypes\_globallogic_score;

#namespace bgb;

/*
	Name: __init__sytem__
	Namespace: bgb
	Checksum: 0x213594A4
	Offset: 0x7C0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bgb", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: bgb
	Checksum: 0x37DC04E3
	Offset: 0x808
	Size: 0x1FC
	Parameters: 0
	Flags: Linked, Private
*/
function private __init__()
{
	callback::on_spawned(&on_player_spawned);
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	level.weaponbgbgrab = getweapon("zombie_bgb_grab");
	level.weaponbgbuse = getweapon("zombie_bgb_use");
	level.bgb = [];
	clientfield::register("clientuimodel", "bgb_current", 1, 8, "int");
	clientfield::register("clientuimodel", "bgb_display", 1, 1, "int");
	clientfield::register("clientuimodel", "bgb_timer", 1, 8, "float");
	clientfield::register("clientuimodel", "bgb_activations_remaining", 1, 3, "int");
	clientfield::register("clientuimodel", "bgb_invalid_use", 1, 1, "counter");
	clientfield::register("clientuimodel", "bgb_one_shot_use", 1, 1, "counter");
	clientfield::register("toplayer", "bgb_blow_bubble", 1, 1, "counter");
	zm::register_vehicle_damage_callback(&vehicle_damage_override);
}

/*
	Name: __main__
	Namespace: bgb
	Checksum: 0x29F60E58
	Offset: 0xA10
	Size: 0x5E
	Parameters: 0
	Flags: Linked, Private
*/
function private __main__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb_finalize();
	/#
		level thread setup_devgui();
	#/
	level._effect["samantha_steal"] = "zombie/fx_monkey_lightning_zmb";
}

/*
	Name: on_player_spawned
	Namespace: bgb
	Checksum: 0x4420286E
	Offset: 0xA78
	Size: 0x5C
	Parameters: 0
	Flags: Linked, Private
*/
function private on_player_spawned()
{
	self.bgb = "none";
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	self function_52dbea8c();
	self thread bgb_player_init();
}

/*
	Name: function_52dbea8c
	Namespace: bgb
	Checksum: 0xFE8C66BC
	Offset: 0xAE0
	Size: 0x50
	Parameters: 0
	Flags: Linked, Private
*/
function private function_52dbea8c()
{
	if(!(isdefined(self.var_c2d95bad) && self.var_c2d95bad))
	{
		self.var_c2d95bad = 1;
		self globallogic_score::initpersstat("bgb_tokens_gained_this_game", 0);
		self.bgb_tokens_gained_this_game = 0;
	}
}

/*
	Name: bgb_player_init
	Namespace: bgb
	Checksum: 0xA7559F80
	Offset: 0xB38
	Size: 0x1EC
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_player_init()
{
	if(isdefined(self.bgb_pack))
	{
		return;
	}
	self.bgb_pack = self getbubblegumpack();
	self.bgb_pack_randomized = [];
	self.bgb_stats = [];
	foreach(bgb in self.bgb_pack)
	{
		if(bgb == "weapon_null")
		{
			continue;
		}
		if(!(isdefined(level.bgb[bgb].consumable) && level.bgb[bgb].consumable))
		{
			continue;
		}
		self.bgb_stats[bgb] = spawnstruct();
		self.bgb_stats[bgb].var_e0b06b47 = self getbgbremaining(bgb);
		self.bgb_stats[bgb].bgb_used_this_game = 0;
	}
	self.bgb_machine_uses_this_round = 0;
	self clientfield::set_to_player("zm_bgb_machine_round_buys", self.bgb_machine_uses_this_round);
	self init_weapon_cycling();
	self thread bgb_player_monitor();
	self thread bgb_end_game();
}

/*
	Name: bgb_end_game
	Namespace: bgb
	Checksum: 0x9DFCA1C2
	Offset: 0xD30
	Size: 0x20C
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_end_game()
{
	self endon(#"disconnect");
	if(!level flag::exists("consumables_reported"))
	{
		level flag::init("consumables_reported");
	}
	self flag::init("finished_reporting_consumables");
	self waittill(#"report_bgb_consumption");
	self thread take();
	self __protected__reportnotedloot();
	self zm_stats::set_global_stat("bgb_tokens_gained_this_game", self.bgb_tokens_gained_this_game);
	foreach(bgb in self.bgb_pack)
	{
		if(!isdefined(self.bgb_stats[bgb]) || !self.bgb_stats[bgb].bgb_used_this_game)
		{
			continue;
		}
		level flag::set("consumables_reported");
		zm_utility::increment_zm_dash_counter("end_consumables_count", self.bgb_stats[bgb].bgb_used_this_game);
		self reportlootconsume(bgb, self.bgb_stats[bgb].bgb_used_this_game);
	}
	self flag::set("finished_reporting_consumables");
}

/*
	Name: bgb_finalize
	Namespace: bgb
	Checksum: 0x9290E1BB
	Offset: 0xF48
	Size: 0x2D6
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_finalize()
{
	statstablename = util::getstatstablename();
	keys = getarraykeys(level.bgb);
	for(i = 0; i < keys.size; i++)
	{
		level.bgb[keys[i]].item_index = getitemindexfromref(keys[i]);
		level.bgb[keys[i]].rarity = int(tablelookup(statstablename, 0, level.bgb[keys[i]].item_index, 16));
		if(0 == level.bgb[keys[i]].rarity || 4 == level.bgb[keys[i]].rarity)
		{
			level.bgb[keys[i]].consumable = 0;
		}
		else
		{
			level.bgb[keys[i]].consumable = 1;
		}
		level.bgb[keys[i]].camo_index = int(tablelookup(statstablename, 0, level.bgb[keys[i]].item_index, 5));
		var_cf65a2c0 = tablelookup(statstablename, 0, level.bgb[keys[i]].item_index, 15);
		if(issubstr(var_cf65a2c0, "dlc"))
		{
			level.bgb[keys[i]].dlc_index = int(var_cf65a2c0[3]);
			continue;
		}
		level.bgb[keys[i]].dlc_index = 0;
	}
}

/*
	Name: bgb_player_monitor
	Namespace: bgb
	Checksum: 0xE1E0D6B1
	Offset: 0x1228
	Size: 0xD8
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_player_monitor()
{
	self endon(#"disconnect");
	while(true)
	{
		str_return = level util::waittill_any_return("between_round_over", "restart_round");
		if(isdefined(level.var_4824bb2d))
		{
			if(!(isdefined(self [[level.var_4824bb2d]]()) && self [[level.var_4824bb2d]]()))
			{
				continue;
			}
		}
		if(str_return === "restart_round")
		{
			level waittill(#"between_round_over");
		}
		else
		{
			self.bgb_machine_uses_this_round = 0;
			self clientfield::set_to_player("zm_bgb_machine_round_buys", self.bgb_machine_uses_this_round);
		}
	}
}

/*
	Name: setup_devgui
	Namespace: bgb
	Checksum: 0x795C8A15
	Offset: 0x1308
	Size: 0x264
	Parameters: 0
	Flags: Linked, Private
*/
function private setup_devgui()
{
	/#
		waittillframeend();
		setdvar("", "");
		setdvar("", -1);
		bgb_devgui_base = "";
		keys = getarraykeys(level.bgb);
		foreach(key in keys)
		{
			adddebugcommand((((((bgb_devgui_base + key) + "") + "") + "") + key) + "");
		}
		adddebugcommand(((((bgb_devgui_base + "") + "") + "") + "") + "");
		adddebugcommand(((((bgb_devgui_base + "") + "") + "") + "") + "");
		for(i = 0; i < 4; i++)
		{
			playernum = i + 1;
			adddebugcommand(((((((bgb_devgui_base + "") + playernum) + "") + "") + "") + i) + "");
		}
		level thread bgb_devgui_think();
	#/
}

/*
	Name: bgb_devgui_think
	Namespace: bgb
	Checksum: 0x286D0311
	Offset: 0x1578
	Size: 0x80
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_devgui_think()
{
	/#
		for(;;)
		{
			var_fe9a7d67 = getdvarstring("");
			if(var_fe9a7d67 != "")
			{
				bgb_devgui_acquire(var_fe9a7d67);
			}
			setdvar("", "");
			wait(0.5);
		}
	#/
}

/*
	Name: bgb_devgui_acquire
	Namespace: bgb
	Checksum: 0xAB92DEAA
	Offset: 0x1600
	Size: 0x11E
	Parameters: 1
	Flags: Linked, Private
*/
function private bgb_devgui_acquire(bgb_name)
{
	/#
		playerid = getdvarint("");
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(playerid != -1 && playerid != i)
			{
				continue;
			}
			if("" == bgb_name)
			{
				players[i] thread take();
				continue;
			}
			__protected__setbgbunlocked(1);
			players[i] thread bgb_gumball_anim(bgb_name, 0);
			__protected__setbgbunlocked(0);
		}
	#/
}

/*
	Name: bgb_debug_text_display_init
	Namespace: bgb
	Checksum: 0x852D87D8
	Offset: 0x1728
	Size: 0x144
	Parameters: 0
	Flags: Private
*/
function private bgb_debug_text_display_init()
{
	/#
		self.bgb_debug_text = newclienthudelem(self);
		self.bgb_debug_text.elemtype = "";
		self.bgb_debug_text.font = "";
		self.bgb_debug_text.fontscale = 1.8;
		self.bgb_debug_text.horzalign = "";
		self.bgb_debug_text.vertalign = "";
		self.bgb_debug_text.alignx = "";
		self.bgb_debug_text.aligny = "";
		self.bgb_debug_text.x = 15;
		self.bgb_debug_text.y = 35;
		self.bgb_debug_text.sort = 2;
		self.bgb_debug_text.color = (1, 1, 1);
		self.bgb_debug_text.alpha = 1;
		self.bgb_debug_text.hidewheninmenu = 1;
	#/
}

/*
	Name: bgb_set_debug_text
	Namespace: bgb
	Checksum: 0xAF0B2D35
	Offset: 0x1878
	Size: 0x1F0
	Parameters: 2
	Flags: Linked, Private
*/
function private bgb_set_debug_text(name, activations_remaining)
{
	/#
		if(!isdefined(self.bgb_debug_text))
		{
			return;
		}
		if(isdefined(activations_remaining))
		{
			self clientfield::set_player_uimodel("", 1);
		}
		else
		{
			self clientfield::set_player_uimodel("", 0);
		}
		self notify(#"bgb_set_debug_text_thread");
		self endon(#"bgb_set_debug_text_thread");
		self endon(#"disconnect");
		self.bgb_debug_text fadeovertime(0.05);
		self.bgb_debug_text.alpha = 1;
		prefix = "";
		short_name = name;
		if(issubstr(name, prefix))
		{
			short_name = getsubstr(name, prefix.size);
		}
		if(isdefined(activations_remaining))
		{
			self.bgb_debug_text settext(((("" + short_name) + "") + activations_remaining) + "");
		}
		else
		{
			self.bgb_debug_text settext("" + short_name);
		}
		wait(1);
		if("" == name)
		{
			self.bgb_debug_text fadeovertime(1);
			self.bgb_debug_text.alpha = 0;
		}
	#/
}

/*
	Name: bgb_print_stats
	Namespace: bgb
	Checksum: 0x5B63E5FA
	Offset: 0x1A70
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function bgb_print_stats(bgb)
{
	/#
		printtoprightln((bgb + "") + self.bgb_stats[bgb].var_e0b06b47, (1, 1, 1));
		printtoprightln((bgb + "") + self.bgb_stats[bgb].bgb_used_this_game, (1, 1, 1));
		n_available = self.bgb_stats[bgb].var_e0b06b47 - self.bgb_stats[bgb].bgb_used_this_game;
		printtoprightln((bgb + "") + n_available, (1, 1, 1));
	#/
}

/*
	Name: has_consumable_bgb
	Namespace: bgb
	Checksum: 0x147B9851
	Offset: 0x1B70
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private has_consumable_bgb(bgb)
{
	if(!isdefined(self.bgb_stats[bgb]) || (!(isdefined(level.bgb[bgb].consumable) && level.bgb[bgb].consumable)))
	{
		return false;
	}
	return true;
}

/*
	Name: sub_consumable_bgb
	Namespace: bgb
	Checksum: 0xA2DCCF17
	Offset: 0x1BE0
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function sub_consumable_bgb(bgb)
{
	if(!has_consumable_bgb(bgb))
	{
		return;
	}
	if(isdefined(level.bgb[bgb].var_35e23ba2) && ![[level.bgb[bgb].var_35e23ba2]]())
	{
		return;
	}
	self.bgb_stats[bgb].bgb_used_this_game++;
	self flag::set("used_consumable");
	zm_utility::increment_zm_dash_counter("consumables_used", 1);
	if(level flag::exists("first_consumables_used"))
	{
		level flag::set("first_consumables_used");
	}
	self luinotifyevent(&"zombie_bgb_used", 1, level.bgb[bgb].item_index);
	/#
		bgb_print_stats(bgb);
	#/
}

/*
	Name: get_bgb_available
	Namespace: bgb
	Checksum: 0x22869CFC
	Offset: 0x1D40
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function get_bgb_available(bgb)
{
	if(!isdefined(self.bgb_stats[bgb]))
	{
		return 1;
	}
	var_3232aae6 = self.bgb_stats[bgb].var_e0b06b47;
	n_bgb_used_this_game = self.bgb_stats[bgb].bgb_used_this_game;
	n_bgb_remaining = var_3232aae6 - n_bgb_used_this_game;
	return 0 < n_bgb_remaining;
}

/*
	Name: function_c3e0b2ba
	Namespace: bgb
	Checksum: 0xD1A78E06
	Offset: 0x1DD8
	Size: 0xC4
	Parameters: 2
	Flags: Linked, Private
*/
function private function_c3e0b2ba(bgb, activating)
{
	if(!(isdefined(level.bgb[bgb].var_7ca0e2a7) && level.bgb[bgb].var_7ca0e2a7))
	{
		return;
	}
	was_invulnerable = self enableinvulnerability();
	self util::waittill_any_timeout(2, "bgb_bubble_blow_complete");
	if(isdefined(self) && (!(isdefined(was_invulnerable) && was_invulnerable)))
	{
		self disableinvulnerability();
	}
}

/*
	Name: bgb_gumball_anim
	Namespace: bgb
	Checksum: 0x5B4FDEA6
	Offset: 0x1EA8
	Size: 0x3D8
	Parameters: 2
	Flags: Linked
*/
function bgb_gumball_anim(bgb, activating)
{
	self endon(#"disconnect");
	level endon(#"end_game");
	unlocked = __protected__getbgbunlocked();
	if(activating)
	{
		self thread function_c3e0b2ba(bgb);
		self thread zm_audio::create_and_play_dialog("bgb", "eat");
	}
	while(self isswitchingweapons())
	{
		self waittill(#"weapon_change_complete");
	}
	gun = self bgb_play_gumball_anim_begin(bgb, activating);
	evt = self util::waittill_any_return("fake_death", "death", "player_downed", "weapon_change_complete", "disconnect");
	succeeded = 0;
	if(evt == "weapon_change_complete")
	{
		succeeded = 1;
		if(activating)
		{
			if(isdefined(level.bgb[bgb].var_7ea552f4) && level.bgb[bgb].var_7ea552f4 || self function_b616fe7a(1))
			{
				self notify(#"hash_83da9d01", bgb);
				self activation_start();
				self thread run_activation_func(bgb);
			}
			else
			{
				succeeded = 0;
			}
		}
		else
		{
			if(!(isdefined(unlocked) && unlocked))
			{
				return 0;
			}
			self notify(#"bgb_gumball_anim_give", bgb);
			self thread give(bgb);
			self zm_stats::increment_client_stat("bgbs_chewed");
			self zm_stats::increment_player_stat("bgbs_chewed");
			self zm_stats::increment_challenge_stat("GUM_GOBBLER_CONSUME");
			self adddstat("ItemStats", level.bgb[bgb].item_index, "stats", "used", "statValue", 1);
			health = 0;
			if(isdefined(self.health))
			{
				health = self.health;
			}
			self recordmapevent(4, gettime(), self.origin, level.round_number, level.bgb[bgb].item_index, health);
			demo::bookmark("zm_player_bgb_grab", gettime(), self);
			if(sessionmodeisonlinegame())
			{
				util::function_a4c90358("zm_bgb_consumed", 1);
			}
		}
	}
	self bgb_play_gumball_anim_end(gun, bgb, activating);
	return succeeded;
}

/*
	Name: run_activation_func
	Namespace: bgb
	Checksum: 0x4953F724
	Offset: 0x2288
	Size: 0xA4
	Parameters: 1
	Flags: Linked, Private
*/
function private run_activation_func(bgb)
{
	self endon(#"disconnect");
	self set_active(1);
	self do_one_shot_use();
	self notify(#"bgb_bubble_blow_complete");
	self [[level.bgb[bgb].activation_func]]();
	self set_active(0);
	self activation_complete();
}

/*
	Name: bgb_get_gumball_anim_weapon
	Namespace: bgb
	Checksum: 0xB2C38A9F
	Offset: 0x2338
	Size: 0x2A
	Parameters: 2
	Flags: Linked, Private
*/
function private bgb_get_gumball_anim_weapon(bgb, activating)
{
	if(activating)
	{
		return level.weaponbgbuse;
	}
	return level.weaponbgbgrab;
}

/*
	Name: bgb_play_gumball_anim_begin
	Namespace: bgb
	Checksum: 0xC3775DB
	Offset: 0x2370
	Size: 0x158
	Parameters: 2
	Flags: Linked, Private
*/
function private bgb_play_gumball_anim_begin(bgb, activating)
{
	self zm_utility::increment_is_drinking();
	self zm_utility::disable_player_move_states(1);
	w_original = self getcurrentweapon();
	weapon = bgb_get_gumball_anim_weapon(bgb, activating);
	self giveweapon(weapon, self calcweaponoptions(level.bgb[bgb].camo_index, 0, 0));
	self switchtoweapon(weapon);
	if(weapon == level.weaponbgbgrab)
	{
		self playsound("zmb_bgb_powerup_default");
	}
	if(weapon == level.weaponbgbuse)
	{
		self clientfield::increment_to_player("bgb_blow_bubble");
	}
	return w_original;
}

/*
	Name: bgb_play_gumball_anim_end
	Namespace: bgb
	Checksum: 0xCA8BF35F
	Offset: 0x24D0
	Size: 0x254
	Parameters: 3
	Flags: Linked, Private
*/
function private bgb_play_gumball_anim_end(w_original, bgb, activating)
{
	/#
		assert(!w_original.isperkbottle);
	#/
	/#
		assert(w_original != level.weaponrevivetool);
	#/
	self zm_utility::enable_player_move_states();
	weapon = bgb_get_gumball_anim_weapon(bgb, activating);
	if(self laststand::player_is_in_laststand() || (isdefined(self.intermission) && self.intermission))
	{
		self takeweapon(weapon);
		return;
	}
	self takeweapon(weapon);
	if(self zm_utility::is_multiple_drinking())
	{
		self zm_utility::decrement_is_drinking();
		return;
	}
	if(w_original != level.weaponnone && !zm_utility::is_placeable_mine(w_original) && !zm_equipment::is_equipment_that_blocks_purchase(w_original))
	{
		self zm_weapons::switch_back_primary_weapon(w_original);
		if(zm_utility::is_melee_weapon(w_original))
		{
			self zm_utility::decrement_is_drinking();
			return;
		}
	}
	else
	{
		self zm_weapons::switch_back_primary_weapon();
	}
	self util::waittill_any_timeout(1, "weapon_change_complete");
	if(!self laststand::player_is_in_laststand() && (!(isdefined(self.intermission) && self.intermission)))
	{
		self zm_utility::decrement_is_drinking();
	}
}

/*
	Name: bgb_clear_monitors_and_clientfields
	Namespace: bgb
	Checksum: 0x5D3EB4BD
	Offset: 0x2730
	Size: 0x74
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_clear_monitors_and_clientfields()
{
	self notify(#"bgb_limit_monitor");
	self notify(#"bgb_activation_monitor");
	self clientfield::set_player_uimodel("bgb_display", 0);
	self clientfield::set_player_uimodel("bgb_activations_remaining", 0);
	self clear_timer();
}

/*
	Name: bgb_limit_monitor
	Namespace: bgb
	Checksum: 0x3651469
	Offset: 0x27B0
	Size: 0x524
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_limit_monitor()
{
	self endon(#"disconnect");
	self endon(#"bgb_update");
	self notify(#"bgb_limit_monitor");
	self endon(#"bgb_limit_monitor");
	self clientfield::set_player_uimodel("bgb_display", 1);
	self thread function_5fc6d844(self.bgb);
	switch(level.bgb[self.bgb].limit_type)
	{
		case "activated":
		{
			self thread bgb_activation_monitor();
			for(i = level.bgb[self.bgb].limit; i > 0; i--)
			{
				level.bgb[self.bgb].var_32fa3cb7 = i;
				if(level.bgb[self.bgb].var_336ffc4e)
				{
					function_497386b0();
				}
				else
				{
					self set_timer(i, level.bgb[self.bgb].limit);
				}
				self clientfield::set_player_uimodel("bgb_activations_remaining", i);
				self thread bgb_set_debug_text(self.bgb, i);
				self waittill(#"bgb_activation");
				while(isdefined(self get_active()) && self get_active())
				{
					wait(0.05);
				}
				self playsoundtoplayer("zmb_bgb_power_decrement", self);
			}
			level.bgb[self.bgb].var_32fa3cb7 = 0;
			self playsoundtoplayer("zmb_bgb_power_done_delayed", self);
			self set_timer(0, level.bgb[self.bgb].limit);
			while(isdefined(self.bgb_activation_in_progress) && self.bgb_activation_in_progress)
			{
				wait(0.05);
			}
			break;
		}
		case "time":
		{
			self thread bgb_set_debug_text(self.bgb);
			self thread run_timer(level.bgb[self.bgb].limit);
			wait(level.bgb[self.bgb].limit);
			self playsoundtoplayer("zmb_bgb_power_done", self);
			break;
		}
		case "rounds":
		{
			self thread bgb_set_debug_text(self.bgb);
			count = level.bgb[self.bgb].limit + 1;
			for(i = 0; i < count; i++)
			{
				self set_timer(count - i, count);
				level waittill(#"end_of_round");
				self playsoundtoplayer("zmb_bgb_power_decrement", self);
			}
			self playsoundtoplayer("zmb_bgb_power_done_delayed", self);
			break;
		}
		case "event":
		{
			self thread bgb_set_debug_text(self.bgb);
			self bgb_set_timer_clientfield(1);
			self [[level.bgb[self.bgb].limit]]();
			self playsoundtoplayer("zmb_bgb_power_done_delayed", self);
			break;
		}
		default:
		{
			/#
				assert(0, ((("" + self.bgb) + "") + level.bgb[self.bgb].limit_type) + "");
			#/
		}
	}
	self thread take();
}

/*
	Name: bgb_bled_out_monitor
	Namespace: bgb
	Checksum: 0xB19D48FE
	Offset: 0x2CE0
	Size: 0x6C
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_bled_out_monitor()
{
	self endon(#"disconnect");
	self endon(#"bgb_update");
	self notify(#"bgb_bled_out_monitor");
	self endon(#"bgb_bled_out_monitor");
	self waittill(#"bled_out");
	self notify(#"bgb_about_to_take_on_bled_out");
	wait(0.1);
	self thread take();
}

/*
	Name: bgb_activation_monitor
	Namespace: bgb
	Checksum: 0xB16E64C3
	Offset: 0x2D58
	Size: 0xB6
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_activation_monitor()
{
	self endon(#"disconnect");
	self notify(#"bgb_activation_monitor");
	self endon(#"bgb_activation_monitor");
	if("activated" != level.bgb[self.bgb].limit_type)
	{
		return;
	}
	for(;;)
	{
		self waittill(#"bgb_activation_request");
		if(!self function_b616fe7a(0))
		{
			continue;
		}
		if(self bgb_gumball_anim(self.bgb, 1))
		{
			self notify(#"bgb_activation", self.bgb);
		}
	}
}

/*
	Name: function_b616fe7a
	Namespace: bgb
	Checksum: 0x17FBD8B1
	Offset: 0x2E18
	Size: 0x144
	Parameters: 1
	Flags: Linked, Private
*/
function private function_b616fe7a(var_5827b083 = 0)
{
	var_bb1d9487 = isdefined(level.bgb[self.bgb].validation_func) && !self [[level.bgb[self.bgb].validation_func]]();
	var_847ec8da = isdefined(level.var_9cef605e) && !self [[level.var_9cef605e]]();
	if(!var_5827b083 && (isdefined(self.is_drinking) && self.is_drinking) || (isdefined(self.bgb_activation_in_progress) && self.bgb_activation_in_progress) || self laststand::player_is_in_laststand() || var_bb1d9487 || var_847ec8da)
	{
		self clientfield::increment_uimodel("bgb_invalid_use");
		self playlocalsound("zmb_bgb_deny_plr");
		return false;
	}
	return true;
}

/*
	Name: function_5fc6d844
	Namespace: bgb
	Checksum: 0x542A2377
	Offset: 0x2F68
	Size: 0xA4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_5fc6d844(bgb)
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_update");
	if(isdefined(level.bgb[bgb].var_50fe45f6) && level.bgb[bgb].var_50fe45f6)
	{
		function_650ca64(6);
	}
	else
	{
		return;
	}
	self waittill(#"bgb_activation_request");
	self thread take();
}

/*
	Name: function_650ca64
	Namespace: bgb
	Checksum: 0x981D146B
	Offset: 0x3018
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_650ca64(n_value)
{
	self setactionslot(1, "bgb");
	self clientfield::set_player_uimodel("bgb_activations_remaining", n_value);
}

/*
	Name: function_eabb0903
	Namespace: bgb
	Checksum: 0x5CF03FCD
	Offset: 0x3070
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_eabb0903(n_value)
{
	self clientfield::set_player_uimodel("bgb_activations_remaining", 0);
}

/*
	Name: function_336ffc4e
	Namespace: bgb
	Checksum: 0xEF99BB19
	Offset: 0x30A8
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function function_336ffc4e(name)
{
	level.bgb[name].var_336ffc4e = 1;
}

/*
	Name: do_one_shot_use
	Namespace: bgb
	Checksum: 0x5D7A7D6D
	Offset: 0x30D8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function do_one_shot_use(skip_demo_bookmark = 0)
{
	self clientfield::increment_uimodel("bgb_one_shot_use");
	if(!skip_demo_bookmark)
	{
		demo::bookmark("zm_player_bgb_activate", gettime(), self);
	}
}

/*
	Name: activation_start
	Namespace: bgb
	Checksum: 0xA8BE8A8A
	Offset: 0x3148
	Size: 0x10
	Parameters: 0
	Flags: Linked, Private
*/
function private activation_start()
{
	self.bgb_activation_in_progress = 1;
}

/*
	Name: activation_complete
	Namespace: bgb
	Checksum: 0x3430D9A
	Offset: 0x3160
	Size: 0x1E
	Parameters: 0
	Flags: Linked, Private
*/
function private activation_complete()
{
	self.bgb_activation_in_progress = 0;
	self notify(#"activation_complete");
}

/*
	Name: set_active
	Namespace: bgb
	Checksum: 0x33259947
	Offset: 0x3188
	Size: 0x18
	Parameters: 1
	Flags: Linked, Private
*/
function private set_active(b_is_active)
{
	self.bgb_active = b_is_active;
}

/*
	Name: get_active
	Namespace: bgb
	Checksum: 0xDA2694C2
	Offset: 0x31A8
	Size: 0x16
	Parameters: 0
	Flags: Linked
*/
function get_active()
{
	return isdefined(self.bgb_active) && self.bgb_active;
}

/*
	Name: is_active
	Namespace: bgb
	Checksum: 0x33748679
	Offset: 0x31C8
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function is_active(name)
{
	if(!isdefined(self.bgb))
	{
		return 0;
	}
	return self.bgb == name && (isdefined(self.bgb_active) && self.bgb_active);
}

/*
	Name: is_team_active
	Namespace: bgb
	Checksum: 0x74678969
	Offset: 0x3210
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function is_team_active(name)
{
	foreach(player in level.players)
	{
		if(player is_active(name))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: increment_ref_count
	Namespace: bgb
	Checksum: 0x97E3FEAA
	Offset: 0x32C0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function increment_ref_count(name)
{
	if(!isdefined(level.bgb[name]))
	{
		return 0;
	}
	var_ad8303b0 = level.bgb[name].ref_count;
	level.bgb[name].ref_count++;
	return var_ad8303b0;
}

/*
	Name: decrement_ref_count
	Namespace: bgb
	Checksum: 0x1DC94792
	Offset: 0x3330
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function decrement_ref_count(name)
{
	if(!isdefined(level.bgb[name]))
	{
		return 0;
	}
	level.bgb[name].ref_count--;
	return level.bgb[name].ref_count;
}

/*
	Name: calc_remaining_duration_lerp
	Namespace: bgb
	Checksum: 0xAF7D7B74
	Offset: 0x3390
	Size: 0x92
	Parameters: 2
	Flags: Linked, Private
*/
function private calc_remaining_duration_lerp(start_time, end_time)
{
	if(0 >= (end_time - start_time))
	{
		return 0;
	}
	now = gettime();
	frac = (float(end_time - now)) / (float(end_time - start_time));
	return math::clamp(frac, 0, 1);
}

/*
	Name: function_f9fad8b3
	Namespace: bgb
	Checksum: 0xCDE8A8E
	Offset: 0x3430
	Size: 0xD8
	Parameters: 2
	Flags: Linked, Private
*/
function private function_f9fad8b3(var_eeab9300, percent)
{
	self endon(#"disconnect");
	self endon(#"hash_f9fad8b3");
	start_time = gettime();
	end_time = start_time + 1000;
	var_6d8b0ec7 = var_eeab9300;
	while(var_6d8b0ec7 > percent)
	{
		var_6d8b0ec7 = lerpfloat(percent, var_eeab9300, calc_remaining_duration_lerp(start_time, end_time));
		self clientfield::set_player_uimodel("bgb_timer", var_6d8b0ec7);
		wait(0.05);
	}
}

/*
	Name: bgb_set_timer_clientfield
	Namespace: bgb
	Checksum: 0x90DF0BDF
	Offset: 0x3510
	Size: 0xAC
	Parameters: 1
	Flags: Linked, Private
*/
function private bgb_set_timer_clientfield(percent)
{
	self notify(#"hash_f9fad8b3");
	var_eeab9300 = self clientfield::get_player_uimodel("bgb_timer");
	if(percent < var_eeab9300 && 0.1 <= (var_eeab9300 - percent))
	{
		self thread function_f9fad8b3(var_eeab9300, percent);
	}
	else
	{
		self clientfield::set_player_uimodel("bgb_timer", percent);
	}
}

/*
	Name: function_497386b0
	Namespace: bgb
	Checksum: 0x84F0B914
	Offset: 0x35C8
	Size: 0x1C
	Parameters: 0
	Flags: Linked, Private
*/
function private function_497386b0()
{
	self bgb_set_timer_clientfield(1);
}

/*
	Name: set_timer
	Namespace: bgb
	Checksum: 0x425FDFE8
	Offset: 0x35F0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function set_timer(current, max)
{
	self bgb_set_timer_clientfield(current / max);
}

/*
	Name: run_timer
	Namespace: bgb
	Checksum: 0x57C0F587
	Offset: 0x3630
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function run_timer(max)
{
	self endon(#"disconnect");
	self notify(#"bgb_run_timer");
	self endon(#"bgb_run_timer");
	current = max;
	while(current > 0)
	{
		self set_timer(current, max);
		wait(0.05);
		current = current - 0.05;
	}
	self clear_timer();
}

/*
	Name: clear_timer
	Namespace: bgb
	Checksum: 0xA40ABFCD
	Offset: 0x36D8
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function clear_timer()
{
	self bgb_set_timer_clientfield(0);
	self notify(#"bgb_run_timer");
}

/*
	Name: register
	Namespace: bgb
	Checksum: 0x294E0264
	Offset: 0x3710
	Size: 0x530
	Parameters: 7
	Flags: Linked
*/
function register(name, limit_type, limit, enable_func, disable_func, validation_func, activation_func)
{
	/#
		assert(isdefined(name), "");
	#/
	/#
		assert("" != name, ("" + "") + "");
	#/
	/#
		assert(!isdefined(level.bgb[name]), ("" + name) + "");
	#/
	/#
		assert(isdefined(limit_type), ("" + name) + "");
	#/
	/#
		assert(isdefined(limit), ("" + name) + "");
	#/
	/#
		assert(!isdefined(enable_func) || isfunctionptr(enable_func), ("" + name) + "");
	#/
	/#
		assert(!isdefined(disable_func) || isfunctionptr(disable_func), ("" + name) + "");
	#/
	switch(limit_type)
	{
		case "activated":
		{
			/#
				assert(!isdefined(validation_func) || isfunctionptr(validation_func), ((("" + name) + "") + limit_type) + "");
			#/
			/#
				assert(isdefined(activation_func), ((("" + name) + "") + limit_type) + "");
			#/
			/#
				assert(isfunctionptr(activation_func), ((("" + name) + "") + limit_type) + "");
			#/
		}
		case "rounds":
		case "time":
		{
			/#
				assert(isint(limit), ((((("" + name) + "") + limit) + "") + limit_type) + "");
			#/
			break;
		}
		case "event":
		{
			/#
				assert(isfunctionptr(limit), ((("" + name) + "") + limit_type) + "");
			#/
			break;
		}
		default:
		{
			/#
				assert(0, ((("" + name) + "") + limit_type) + "");
			#/
		}
	}
	level.bgb[name] = spawnstruct();
	level.bgb[name].name = name;
	level.bgb[name].limit_type = limit_type;
	level.bgb[name].limit = limit;
	level.bgb[name].enable_func = enable_func;
	level.bgb[name].disable_func = disable_func;
	if("activated" == limit_type)
	{
		level.bgb[name].validation_func = validation_func;
		level.bgb[name].activation_func = activation_func;
		level.bgb[name].var_336ffc4e = 0;
	}
	level.bgb[name].ref_count = 0;
}

/*
	Name: register_actor_damage_override
	Namespace: bgb
	Checksum: 0xB600CE11
	Offset: 0x3C48
	Size: 0x68
	Parameters: 2
	Flags: Linked
*/
function register_actor_damage_override(name, actor_damage_override_func)
{
	/#
		assert(isdefined(level.bgb[name]), ("" + name) + "");
	#/
	level.bgb[name].actor_damage_override_func = actor_damage_override_func;
}

/*
	Name: register_vehicle_damage_override
	Namespace: bgb
	Checksum: 0x28F077E3
	Offset: 0x3CB8
	Size: 0x68
	Parameters: 2
	Flags: Linked
*/
function register_vehicle_damage_override(name, vehicle_damage_override_func)
{
	/#
		assert(isdefined(level.bgb[name]), ("" + name) + "");
	#/
	level.bgb[name].vehicle_damage_override_func = vehicle_damage_override_func;
}

/*
	Name: register_actor_death_override
	Namespace: bgb
	Checksum: 0xB5137758
	Offset: 0x3D28
	Size: 0x68
	Parameters: 2
	Flags: Linked
*/
function register_actor_death_override(name, actor_death_override_func)
{
	/#
		assert(isdefined(level.bgb[name]), ("" + name) + "");
	#/
	level.bgb[name].actor_death_override_func = actor_death_override_func;
}

/*
	Name: register_lost_perk_override
	Namespace: bgb
	Checksum: 0x75A50890
	Offset: 0x3D98
	Size: 0x8C
	Parameters: 3
	Flags: Linked
*/
function register_lost_perk_override(name, lost_perk_override_func, lost_perk_override_func_always_run)
{
	/#
		assert(isdefined(level.bgb[name]), ("" + name) + "");
	#/
	level.bgb[name].lost_perk_override_func = lost_perk_override_func;
	level.bgb[name].lost_perk_override_func_always_run = lost_perk_override_func_always_run;
}

/*
	Name: function_ff4b2998
	Namespace: bgb
	Checksum: 0xCD6631BB
	Offset: 0x3E30
	Size: 0x8C
	Parameters: 3
	Flags: Linked
*/
function function_ff4b2998(name, add_to_player_score_override_func, add_to_player_score_override_func_always_run)
{
	/#
		assert(isdefined(level.bgb[name]), ("" + name) + "");
	#/
	level.bgb[name].add_to_player_score_override_func = add_to_player_score_override_func;
	level.bgb[name].add_to_player_score_override_func_always_run = add_to_player_score_override_func_always_run;
}

/*
	Name: function_4cda71bf
	Namespace: bgb
	Checksum: 0xC631F42D
	Offset: 0x3EC8
	Size: 0x68
	Parameters: 2
	Flags: Linked
*/
function function_4cda71bf(name, var_7ca0e2a7)
{
	/#
		assert(isdefined(level.bgb[name]), ("" + name) + "");
	#/
	level.bgb[name].var_7ca0e2a7 = var_7ca0e2a7;
}

/*
	Name: function_93da425
	Namespace: bgb
	Checksum: 0xE1943FD8
	Offset: 0x3F38
	Size: 0x68
	Parameters: 2
	Flags: None
*/
function function_93da425(name, var_35e23ba2)
{
	/#
		assert(isdefined(level.bgb[name]), ("" + name) + "");
	#/
	level.bgb[name].var_35e23ba2 = var_35e23ba2;
}

/*
	Name: function_2060b89
	Namespace: bgb
	Checksum: 0x1163C55B
	Offset: 0x3FA8
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function function_2060b89(name)
{
	/#
		assert(isdefined(level.bgb[name]), ("" + name) + "");
	#/
	level.bgb[name].var_50fe45f6 = 1;
}

/*
	Name: function_f132da9c
	Namespace: bgb
	Checksum: 0x3F20E3AF
	Offset: 0x4010
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function function_f132da9c(name)
{
	/#
		assert(isdefined(level.bgb[name]), ("" + name) + "");
	#/
	level.bgb[name].var_7ea552f4 = 1;
}

/*
	Name: function_d35f60a1
	Namespace: bgb
	Checksum: 0xA8E2EFFA
	Offset: 0x4078
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function function_d35f60a1(name)
{
	unlocked = __protected__getbgbunlocked();
	if(unlocked)
	{
		self give(name);
	}
}

/*
	Name: give
	Namespace: bgb
	Checksum: 0xC2F91B7E
	Offset: 0x40D0
	Size: 0x1C4
	Parameters: 1
	Flags: Linked
*/
function give(name)
{
	self thread take();
	if("none" == name)
	{
		return;
	}
	/#
		assert(isdefined(level.bgb[name]), ("" + name) + "");
	#/
	self notify(#"bgb_update", name, self.bgb);
	self notify("bgb_update_give_" + name);
	self.bgb = name;
	self clientfield::set_player_uimodel("bgb_current", level.bgb[name].item_index);
	self luinotifyevent(&"zombie_bgb_notification", 1, level.bgb[name].item_index);
	if(isdefined(level.bgb[name].enable_func))
	{
		self thread [[level.bgb[name].enable_func]]();
	}
	if(isdefined("activated" == level.bgb[name].limit_type))
	{
		self setactionslot(1, "bgb");
	}
	self thread bgb_limit_monitor();
	self thread bgb_bled_out_monitor();
}

/*
	Name: take
	Namespace: bgb
	Checksum: 0x1CE0D3EE
	Offset: 0x42A0
	Size: 0xF8
	Parameters: 0
	Flags: Linked
*/
function take()
{
	if("none" == self.bgb)
	{
		return;
	}
	self setactionslot(1, "");
	self thread bgb_set_debug_text("none");
	if(isdefined(level.bgb[self.bgb].disable_func))
	{
		self thread [[level.bgb[self.bgb].disable_func]]();
	}
	self bgb_clear_monitors_and_clientfields();
	self notify(#"bgb_update", "none", self.bgb);
	self notify("bgb_update_take_" + self.bgb);
	self.bgb = "none";
}

/*
	Name: get_enabled
	Namespace: bgb
	Checksum: 0xBAEC966
	Offset: 0x43A0
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_enabled()
{
	return self.bgb;
}

/*
	Name: is_enabled
	Namespace: bgb
	Checksum: 0x369A99AA
	Offset: 0x43B8
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function is_enabled(name)
{
	/#
		assert(isdefined(self.bgb));
	#/
	return self.bgb == name;
}

/*
	Name: any_enabled
	Namespace: bgb
	Checksum: 0x4A6FEAAC
	Offset: 0x43F8
	Size: 0x34
	Parameters: 0
	Flags: None
*/
function any_enabled()
{
	/#
		assert(isdefined(self.bgb));
	#/
	return self.bgb !== "none";
}

/*
	Name: is_team_enabled
	Namespace: bgb
	Checksum: 0xDD73CECB
	Offset: 0x4438
	Size: 0xC2
	Parameters: 1
	Flags: Linked
*/
function is_team_enabled(str_name)
{
	foreach(player in level.players)
	{
		/#
			assert(isdefined(player.bgb));
		#/
		if(player.bgb == str_name)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: get_player_dropped_powerup_origin
	Namespace: bgb
	Checksum: 0x1DB6D96
	Offset: 0x4508
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function get_player_dropped_powerup_origin()
{
	powerup_origin = (self.origin + vectorscale(anglestoforward((0, self getplayerangles()[1], 0)), 60)) + vectorscale((0, 0, 1), 5);
	self zm_stats::increment_challenge_stat("GUM_GOBBLER_POWERUPS");
	return powerup_origin;
}

/*
	Name: function_dea74fb0
	Namespace: bgb
	Checksum: 0xADF187F6
	Offset: 0x4598
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function function_dea74fb0(str_powerup, v_origin = self get_player_dropped_powerup_origin())
{
	var_93eb638b = zm_powerups::specific_powerup_drop(str_powerup, v_origin);
	wait(1);
	if(isdefined(var_93eb638b) && (!var_93eb638b zm::in_enabled_playable_area() && !var_93eb638b zm::in_life_brush()))
	{
		level thread function_434235f9(var_93eb638b);
	}
}

/*
	Name: function_434235f9
	Namespace: bgb
	Checksum: 0x7EED9115
	Offset: 0x4668
	Size: 0x37C
	Parameters: 1
	Flags: Linked
*/
function function_434235f9(var_93eb638b)
{
	if(!isdefined(var_93eb638b))
	{
		return;
	}
	var_93eb638b ghost();
	var_93eb638b.clone_model = util::spawn_model(var_93eb638b.model, var_93eb638b.origin, var_93eb638b.angles);
	var_93eb638b.clone_model linkto(var_93eb638b);
	direction = var_93eb638b.origin;
	direction = (direction[1], direction[0], 0);
	if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	{
		direction = (direction[0], direction[1] * -1, 0);
	}
	else if(direction[0] < 0)
	{
		direction = (direction[0] * -1, direction[1], 0);
	}
	if(!(isdefined(var_93eb638b.sndnosamlaugh) && var_93eb638b.sndnosamlaugh))
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(isalive(players[i]))
			{
				players[i] playlocalsound(level.zmb_laugh_alias);
			}
		}
	}
	playfxontag(level._effect["samantha_steal"], var_93eb638b, "tag_origin");
	var_93eb638b.clone_model unlink();
	var_93eb638b.clone_model movez(60, 1, 0.25, 0.25);
	var_93eb638b.clone_model vibrate(direction, 1.5, 2.5, 1);
	var_93eb638b.clone_model waittill(#"movedone");
	if(isdefined(self.damagearea))
	{
		self.damagearea delete();
	}
	var_93eb638b.clone_model delete();
	if(isdefined(var_93eb638b))
	{
		if(isdefined(var_93eb638b.damagearea))
		{
			var_93eb638b.damagearea delete();
		}
		var_93eb638b zm_powerups::powerup_delete();
	}
}

/*
	Name: actor_damage_override
	Namespace: bgb
	Checksum: 0x2EA7AF6E
	Offset: 0x49F0
	Size: 0x150
	Parameters: 12
	Flags: Linked
*/
function actor_damage_override(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return damage;
	}
	if(isplayer(attacker))
	{
		name = attacker get_enabled();
		if(name !== "none" && isdefined(level.bgb[name]) && isdefined(level.bgb[name].actor_damage_override_func))
		{
			damage = [[level.bgb[name].actor_damage_override_func]](inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype);
		}
	}
	return damage;
}

/*
	Name: vehicle_damage_override
	Namespace: bgb
	Checksum: 0x8CCDAA93
	Offset: 0x4B48
	Size: 0x174
	Parameters: 15
	Flags: Linked
*/
function vehicle_damage_override(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return idamage;
	}
	if(isplayer(eattacker))
	{
		name = eattacker get_enabled();
		if(name !== "none" && isdefined(level.bgb[name]) && isdefined(level.bgb[name].vehicle_damage_override_func))
		{
			idamage = [[level.bgb[name].vehicle_damage_override_func]](einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal);
		}
	}
	return idamage;
}

/*
	Name: actor_death_override
	Namespace: bgb
	Checksum: 0xD80802EA
	Offset: 0x4CC8
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function actor_death_override(attacker)
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return 0;
	}
	if(isplayer(attacker))
	{
		name = attacker get_enabled();
		if(name !== "none" && isdefined(level.bgb[name]) && isdefined(level.bgb[name].actor_death_override_func))
		{
			damage = [[level.bgb[name].actor_death_override_func]](attacker);
		}
	}
	return damage;
}

/*
	Name: lost_perk_override
	Namespace: bgb
	Checksum: 0x3E1114E7
	Offset: 0x4DA8
	Size: 0x254
	Parameters: 1
	Flags: Linked
*/
function lost_perk_override(perk)
{
	b_result = 0;
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return b_result;
	}
	if(!(isdefined(self.laststand) && self.laststand))
	{
		return b_result;
	}
	keys = getarraykeys(level.bgb);
	for(i = 0; i < keys.size; i++)
	{
		name = keys[i];
		if(isdefined(level.bgb[name].lost_perk_override_func_always_run) && level.bgb[name].lost_perk_override_func_always_run && isdefined(level.bgb[name].lost_perk_override_func))
		{
			b_result = [[level.bgb[name].lost_perk_override_func]](perk, self, undefined);
			if(b_result)
			{
				return b_result;
			}
		}
	}
	foreach(player in level.activeplayers)
	{
		name = player get_enabled();
		if(name !== "none" && isdefined(level.bgb[name]) && isdefined(level.bgb[name].lost_perk_override_func))
		{
			b_result = [[level.bgb[name].lost_perk_override_func]](perk, self, player);
			if(b_result)
			{
				return b_result;
			}
		}
	}
	return b_result;
}

/*
	Name: add_to_player_score_override
	Namespace: bgb
	Checksum: 0xFC6E925F
	Offset: 0x5008
	Size: 0x1C4
	Parameters: 2
	Flags: Linked
*/
function add_to_player_score_override(n_points, str_awarded_by)
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return n_points;
	}
	str_enabled = self get_enabled();
	keys = getarraykeys(level.bgb);
	for(i = 0; i < keys.size; i++)
	{
		str_bgb = keys[i];
		if(str_bgb === str_enabled)
		{
			continue;
		}
		if(isdefined(level.bgb[str_bgb].add_to_player_score_override_func_always_run) && level.bgb[str_bgb].add_to_player_score_override_func_always_run && isdefined(level.bgb[str_bgb].add_to_player_score_override_func))
		{
			n_points = [[level.bgb[str_bgb].add_to_player_score_override_func]](n_points, str_awarded_by, 0);
		}
	}
	if(str_enabled !== "none" && isdefined(level.bgb[str_enabled]) && isdefined(level.bgb[str_enabled].add_to_player_score_override_func))
	{
		n_points = [[level.bgb[str_enabled].add_to_player_score_override_func]](n_points, str_awarded_by, 1);
	}
	return n_points;
}

/*
	Name: function_d51db887
	Namespace: bgb
	Checksum: 0x5FCF4FAE
	Offset: 0x51D8
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_d51db887()
{
	keys = array::randomize(getarraykeys(level.bgb));
	for(i = 0; i < keys.size; i++)
	{
		if(level.bgb[keys[i]].rarity != 1)
		{
			continue;
		}
		if(level.bgb[keys[i]].dlc_index > 0)
		{
			continue;
		}
		return keys[i];
	}
}

/*
	Name: function_4ed517b9
	Namespace: bgb
	Checksum: 0x23D70B86
	Offset: 0x52A8
	Size: 0x20C
	Parameters: 3
	Flags: Linked
*/
function function_4ed517b9(n_max_distance, var_98a3e738, var_287a7adb)
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_update");
	self.var_6638f10b = [];
	while(true)
	{
		foreach(e_player in level.players)
		{
			if(e_player == self)
			{
				continue;
			}
			array::remove_undefined(self.var_6638f10b);
			var_368e2240 = array::contains(self.var_6638f10b, e_player);
			var_50fd5a04 = zm_utility::is_player_valid(e_player, 0, 1) && function_2469cfe8(n_max_distance, self, e_player);
			if(!var_368e2240 && var_50fd5a04)
			{
				array::add(self.var_6638f10b, e_player, 0);
				if(isdefined(var_98a3e738))
				{
					self thread [[var_98a3e738]](e_player);
				}
				continue;
			}
			if(var_368e2240 && !var_50fd5a04)
			{
				arrayremovevalue(self.var_6638f10b, e_player);
				if(isdefined(var_287a7adb))
				{
					self thread [[var_287a7adb]](e_player);
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_2469cfe8
	Namespace: bgb
	Checksum: 0x6C2A4F72
	Offset: 0x54C0
	Size: 0x7E
	Parameters: 3
	Flags: Linked, Private
*/
function private function_2469cfe8(n_distance, var_d21815c4, var_441f84ff)
{
	var_31dc18aa = n_distance * n_distance;
	var_2931dc75 = distancesquared(var_d21815c4.origin, var_441f84ff.origin);
	if(var_2931dc75 <= var_31dc18aa)
	{
		return true;
	}
	return false;
}

/*
	Name: function_ca189700
	Namespace: bgb
	Checksum: 0x194165CC
	Offset: 0x5548
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_ca189700()
{
	self clientfield::increment_uimodel("bgb_invalid_use");
	self playlocalsound("zmb_bgb_deny_plr");
}

/*
	Name: suspend_weapon_cycling
	Namespace: bgb
	Checksum: 0xBB0CA501
	Offset: 0x5598
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function suspend_weapon_cycling()
{
	self flag::clear("bgb_weapon_cycling");
}

/*
	Name: resume_weapon_cycling
	Namespace: bgb
	Checksum: 0x5E7C3417
	Offset: 0x55C8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function resume_weapon_cycling()
{
	self flag::set("bgb_weapon_cycling");
}

/*
	Name: init_weapon_cycling
	Namespace: bgb
	Checksum: 0xEE0C457D
	Offset: 0x55F8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function init_weapon_cycling()
{
	if(!self flag::exists("bgb_weapon_cycling"))
	{
		self flag::init("bgb_weapon_cycling");
	}
	self flag::set("bgb_weapon_cycling");
}

/*
	Name: function_378bff5d
	Namespace: bgb
	Checksum: 0xACCEF0B8
	Offset: 0x5668
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_378bff5d()
{
	self flag::wait_till("bgb_weapon_cycling");
}

/*
	Name: revive_and_return_perk_on_bgb_activation
	Namespace: bgb
	Checksum: 0x8ADBAAE7
	Offset: 0x5698
	Size: 0x1A4
	Parameters: 1
	Flags: Linked
*/
function revive_and_return_perk_on_bgb_activation(perk)
{
	self notify("revive_and_return_perk_on_bgb_activation" + perk);
	self endon("revive_and_return_perk_on_bgb_activation" + perk);
	self endon(#"disconnect");
	self endon(#"bled_out");
	if(perk == "specialty_widowswine")
	{
		var_376ad33c = self getweaponammoclip(self.current_lethal_grenade);
	}
	self waittill(#"player_revived", e_reviver);
	if(isdefined(self.var_df0decf1) && self.var_df0decf1 || (isdefined(e_reviver) && (isdefined(self.bgb) && self is_enabled("zm_bgb_near_death_experience")) || (isdefined(e_reviver.bgb) && e_reviver is_enabled("zm_bgb_near_death_experience"))))
	{
		if(zm_perks::use_solo_revive() && perk == "specialty_quickrevive")
		{
			level.solo_game_free_player_quickrevive = 1;
		}
		wait(0.05);
		self thread zm_perks::give_perk(perk, 0);
		if(perk == "specialty_widowswine" && isdefined(var_376ad33c))
		{
			self setweaponammoclip(self.current_lethal_grenade, var_376ad33c);
		}
	}
}

/*
	Name: bgb_revive_watcher
	Namespace: bgb
	Checksum: 0x37E45910
	Offset: 0x5848
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function bgb_revive_watcher()
{
	self endon(#"disconnect");
	self endon(#"death");
	self.var_df0decf1 = 1;
	self waittill(#"player_revived", e_reviver);
	wait(0.05);
	if(isdefined(self.var_df0decf1) && self.var_df0decf1)
	{
		self notify(#"bgb_revive");
		self.var_df0decf1 = undefined;
	}
}

