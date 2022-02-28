// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equip_hacker;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_hackables_box;

/*
	Name: box_hacks
	Namespace: zm_hackables_box
	Checksum: 0x652E047D
	Offset: 0x2B0
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function box_hacks()
{
	level flag::wait_till("start_zombie_round_logic");
	boxes = struct::get_array("treasure_chest_use", "targetname");
	for(i = 0; i < boxes.size; i++)
	{
		box = boxes[i];
		box.box_hacks["respin"] = &init_box_respin;
		box.box_hacks["respin_respin"] = &init_box_respin_respin;
		box.box_hacks["summon_box"] = &init_summon_box;
		box.last_hacked_round = 0;
	}
	level._zombiemode_chest_joker_chance_override_func = &check_for_free_locations;
	level._zombiemode_custom_box_move_logic = &custom_box_move_logic;
	level._zombiemode_check_firesale_loc_valid_func = &custom_check_firesale_loc_valid_func;
	level flag::init("override_magicbox_trigger_use");
	init_summon_hacks();
}

/*
	Name: custom_check_firesale_loc_valid_func
	Namespace: zm_hackables_box
	Checksum: 0xA557A71D
	Offset: 0x448
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function custom_check_firesale_loc_valid_func()
{
	if(isdefined(self.unitrigger_stub))
	{
		box = self.unitrigger_stub.trigger_target;
	}
	else
	{
		if(isdefined(self.stub))
		{
			box = self.stub.trigger_target;
		}
		else if(isdefined(self.owner))
		{
			box = self.owner;
		}
	}
	if(box.last_hacked_round >= level.round_number)
	{
		return false;
	}
	return true;
}

/*
	Name: custom_box_move_logic
	Namespace: zm_hackables_box
	Checksum: 0x585C6D2D
	Offset: 0x4E0
	Size: 0x12E
	Parameters: 0
	Flags: Linked
*/
function custom_box_move_logic()
{
	num_hacked_locs = 0;
	for(i = 0; i < level.chests.size; i++)
	{
		if(level.chests[i].last_hacked_round >= level.round_number)
		{
			num_hacked_locs++;
		}
	}
	if(num_hacked_locs == 0)
	{
		zm_magicbox::default_box_move_logic();
		return;
	}
	found_loc = 0;
	original_spot = level.chest_index;
	while(!found_loc)
	{
		level.chest_index++;
		if(original_spot == level.chest_index)
		{
			level.chest_index++;
		}
		level.chest_index = level.chest_index % level.chests.size;
		if(level.chests[level.chest_index].last_hacked_round < level.round_number)
		{
			found_loc = 1;
		}
	}
}

/*
	Name: check_for_free_locations
	Namespace: zm_hackables_box
	Checksum: 0x2B0BBA81
	Offset: 0x618
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function check_for_free_locations(chance)
{
	boxes = level.chests;
	stored_chance = chance;
	chance = -1;
	for(i = 0; i < boxes.size; i++)
	{
		if(i == level.chest_index)
		{
			continue;
		}
		if(boxes[i].last_hacked_round < level.round_number)
		{
			chance = stored_chance;
			break;
		}
	}
	return chance;
}

/*
	Name: init_box_respin
	Namespace: zm_hackables_box
	Checksum: 0x7B64E692
	Offset: 0x6D0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function init_box_respin(chest, player)
{
	self thread box_respin_think(chest, player);
}

/*
	Name: box_respin_think
	Namespace: zm_hackables_box
	Checksum: 0xA48E1934
	Offset: 0x710
	Size: 0x154
	Parameters: 2
	Flags: Linked
*/
function box_respin_think(chest, player)
{
	respin_hack = spawnstruct();
	respin_hack.origin = self.origin + vectorscale((0, 0, 1), 24);
	respin_hack.radius = 48;
	respin_hack.height = 72;
	respin_hack.script_int = 600;
	respin_hack.script_float = 1.5;
	respin_hack.player = player;
	respin_hack.no_bullet_trace = 1;
	respin_hack.chest = chest;
	zm_equip_hacker::register_pooled_hackable_struct(respin_hack, &respin_box, &hack_box_qualifier);
	self.weapon_model util::waittill_either("death", "kill_respin_think_thread");
	zm_equip_hacker::deregister_hackable_struct(respin_hack);
}

/*
	Name: respin_box_thread
	Namespace: zm_hackables_box
	Checksum: 0x78D59B9B
	Offset: 0x870
	Size: 0x1EC
	Parameters: 1
	Flags: Linked
*/
function respin_box_thread(hacker)
{
	if(isdefined(self.chest.zbarrier.weapon_model))
	{
		self.chest.zbarrier.weapon_model notify(#"kill_respin_think_thread");
	}
	self.chest.no_fly_away = 1;
	self.chest.zbarrier notify(#"box_hacked_respin");
	level flag::set("override_magicbox_trigger_use");
	zm_utility::play_sound_at_pos("open_chest", self.chest.zbarrier.origin);
	zm_utility::play_sound_at_pos("music_chest", self.chest.zbarrier.origin);
	self.chest.zbarrier thread zm_magicbox::treasure_chest_weapon_spawn(self.chest, hacker, 1);
	self.chest.zbarrier waittill(#"randomization_done");
	self.chest.no_fly_away = undefined;
	if(!level flag::get("moving_chest_now"))
	{
		self.chest.grab_weapon_hint = 1;
		self.chest.grab_weapon = self.chest.zbarrier.weapon;
		level flag::clear("override_magicbox_trigger_use");
		self.chest thread zm_magicbox::treasure_chest_timeout();
	}
}

/*
	Name: respin_box
	Namespace: zm_hackables_box
	Checksum: 0x9B8E2CC8
	Offset: 0xA68
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function respin_box(hacker)
{
	self thread respin_box_thread(hacker);
}

/*
	Name: hack_box_qualifier
	Namespace: zm_hackables_box
	Checksum: 0x8C0D3E9
	Offset: 0xA98
	Size: 0x40
	Parameters: 1
	Flags: Linked
*/
function hack_box_qualifier(player)
{
	if(player == self.chest.chest_user && isdefined(self.chest.weapon_out))
	{
		return true;
	}
	return false;
}

/*
	Name: init_box_respin_respin
	Namespace: zm_hackables_box
	Checksum: 0x2BFA7A76
	Offset: 0xAE0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function init_box_respin_respin(chest, player)
{
	self thread box_respin_respin_think(chest, player);
}

/*
	Name: box_respin_respin_think
	Namespace: zm_hackables_box
	Checksum: 0x781A6C5
	Offset: 0xB20
	Size: 0x154
	Parameters: 2
	Flags: Linked
*/
function box_respin_respin_think(chest, player)
{
	respin_hack = spawnstruct();
	respin_hack.origin = self.origin + vectorscale((0, 0, 1), 24);
	respin_hack.radius = 48;
	respin_hack.height = 72;
	respin_hack.script_int = -950;
	respin_hack.script_float = 1.5;
	respin_hack.player = player;
	respin_hack.no_bullet_trace = 1;
	respin_hack.chest = chest;
	zm_equip_hacker::register_pooled_hackable_struct(respin_hack, &respin_respin_box, &hack_box_qualifier);
	self.weapon_model util::waittill_either("death", "kill_respin_respin_think_thread");
	zm_equip_hacker::deregister_hackable_struct(respin_hack);
}

/*
	Name: respin_respin_box
	Namespace: zm_hackables_box
	Checksum: 0xB56E1AAC
	Offset: 0xC80
	Size: 0x1EC
	Parameters: 1
	Flags: Linked
*/
function respin_respin_box(hacker)
{
	org = self.chest.zbarrier.origin;
	if(isdefined(self.chest.zbarrier.weapon_model))
	{
		self.chest.zbarrier.weapon_model notify(#"kill_respin_respin_think_thread");
		self.chest.zbarrier.weapon_model notify(#"kill_weapon_movement");
		self.chest.zbarrier.weapon_model moveto(org + vectorscale((0, 0, 1), 40), 0.5);
	}
	if(isdefined(self.chest.zbarrier.weapon_model_dw))
	{
		self.chest.zbarrier.weapon_model_dw notify(#"kill_weapon_movement");
		self.chest.zbarrier.weapon_model_dw moveto((org + vectorscale((0, 0, 1), 40)) - vectorscale((1, 1, 1), 3), 0.5);
	}
	self.chest.zbarrier notify(#"box_hacked_rerespin");
	self.chest.box_rerespun = 1;
	self thread fake_weapon_powerup_thread(self.chest.zbarrier.weapon_model, self.chest.zbarrier.weapon_model_dw);
}

/*
	Name: fake_weapon_powerup_thread
	Namespace: zm_hackables_box
	Checksum: 0xA7FBCA3F
	Offset: 0xE78
	Size: 0x270
	Parameters: 2
	Flags: Linked
*/
function fake_weapon_powerup_thread(weapon1, weapon2)
{
	weapon1 endon(#"death");
	playfxontag(level._effect["powerup_on_solo"], weapon1, "tag_origin");
	playsoundatposition("zmb_spawn_powerup", weapon1.origin);
	weapon1 playloopsound("zmb_spawn_powerup_loop");
	self thread fake_weapon_powerup_timeout(weapon1, weapon2);
	while(isdefined(weapon1))
	{
		waittime = randomfloatrange(2.5, 5);
		yaw = randomint(360);
		if(yaw > 300)
		{
			yaw = 300;
		}
		else if(yaw < 60)
		{
			yaw = 60;
		}
		yaw = weapon1.angles[1] + yaw;
		weapon1 rotateto((-60 + randomint(120), yaw, -45 + randomint(90)), waittime, waittime * 0.5, waittime * 0.5);
		if(isdefined(weapon2))
		{
			weapon2 rotateto((-60 + randomint(120), yaw, -45 + randomint(90)), waittime, waittime * 0.5, waittime * 0.5);
		}
		wait(randomfloat(waittime - 0.1));
	}
}

/*
	Name: fake_weapon_powerup_timeout
	Namespace: zm_hackables_box
	Checksum: 0x1D842D09
	Offset: 0x10F0
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function fake_weapon_powerup_timeout(weapon1, weapon2)
{
	weapon1 endon(#"death");
	wait(15);
	for(i = 0; i < 40; i++)
	{
		if(i % 2)
		{
			weapon1 hide();
			if(isdefined(weapon2))
			{
				weapon2 hide();
			}
		}
		else
		{
			weapon1 show();
			if(isdefined(weapon2))
			{
				weapon2 hide();
			}
		}
		if(i < 15)
		{
			wait(0.5);
			continue;
		}
		if(i < 25)
		{
			wait(0.25);
			continue;
		}
		wait(0.1);
	}
	self.chest notify(#"trigger", level);
	if(isdefined(weapon1))
	{
		weapon1 delete();
	}
	if(isdefined(weapon2))
	{
		weapon2 delete();
	}
}

/*
	Name: init_summon_hacks
	Namespace: zm_hackables_box
	Checksum: 0xFC9F3C41
	Offset: 0x1260
	Size: 0x96
	Parameters: 0
	Flags: Linked
*/
function init_summon_hacks()
{
	chests = struct::get_array("treasure_chest_use", "targetname");
	for(i = 0; i < chests.size; i++)
	{
		chest = chests[i];
		chest init_summon_box(chest.hidden);
	}
}

/*
	Name: init_summon_box
	Namespace: zm_hackables_box
	Checksum: 0x92091288
	Offset: 0x1300
	Size: 0x176
	Parameters: 1
	Flags: Linked
*/
function init_summon_box(create)
{
	if(create)
	{
		if(isdefined(self._summon_hack_struct))
		{
			zm_equip_hacker::deregister_hackable_struct(self._summon_hack_struct);
			self._summon_hack_struct = undefined;
		}
		struct = spawnstruct();
		struct.origin = self.chest_box.origin + vectorscale((0, 0, 1), 24);
		struct.radius = 48;
		struct.height = 72;
		struct.script_int = 1200;
		struct.script_float = 5;
		struct.no_bullet_trace = 1;
		struct.chest = self;
		self._summon_hack_struct = struct;
		zm_equip_hacker::register_pooled_hackable_struct(struct, &summon_box, &summon_box_qualifier);
	}
	else if(isdefined(self._summon_hack_struct))
	{
		zm_equip_hacker::deregister_hackable_struct(self._summon_hack_struct);
		self._summon_hack_struct = undefined;
	}
}

/*
	Name: summon_box_thread
	Namespace: zm_hackables_box
	Checksum: 0xB9E7D356
	Offset: 0x1480
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function summon_box_thread(hacker)
{
	self.chest.last_hacked_round = level.round_number + randomintrange(2, 5);
	zm_equip_hacker::deregister_hackable_struct(self);
	self.chest thread zm_magicbox::show_chest();
	self.chest notify(#"kill_chest_think");
	self.chest.auto_open = 1;
	self.chest.no_charge = 1;
	self.chest.no_fly_away = 1;
	self.chest.forced_user = hacker;
	self.chest thread zm_magicbox::treasure_chest_think();
	self.chest.zbarrier waittill(#"closed");
	self.chest.forced_user = undefined;
	self.chest.auto_open = undefined;
	self.chest.no_charge = undefined;
	self.chest.no_fly_away = undefined;
	self.chest thread zm_magicbox::hide_chest();
}

/*
	Name: summon_box
	Namespace: zm_hackables_box
	Checksum: 0x5D81B593
	Offset: 0x15E8
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function summon_box(hacker)
{
	self thread summon_box_thread(hacker);
	if(isdefined(hacker))
	{
		hacker thread zm_audio::create_and_play_dialog("general", "hack_box");
	}
}

/*
	Name: summon_box_qualifier
	Namespace: zm_hackables_box
	Checksum: 0x71EB61EF
	Offset: 0x1648
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function summon_box_qualifier(player)
{
	if(self.chest.last_hacked_round > level.round_number)
	{
		return false;
	}
	if(isdefined(self.chest.zbarrier.chest_moving) && self.chest.zbarrier.chest_moving)
	{
		return false;
	}
	return true;
}

