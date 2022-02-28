// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace _zm_pack_a_punch;

/*
	Name: __init__sytem__
	Namespace: _zm_pack_a_punch
	Checksum: 0x2B4F5016
	Offset: 0x718
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_pack_a_punch", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: _zm_pack_a_punch
	Checksum: 0x994DDDF
	Offset: 0x760
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	zm_pap_util::init_parameters();
	clientfield::register("zbarrier", "pap_working_FX", 5000, 1, "int");
}

/*
	Name: __main__
	Namespace: _zm_pack_a_punch
	Checksum: 0x8DC97A36
	Offset: 0x7B0
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	if(!isdefined(level.pap_zbarrier_state_func))
	{
		level.pap_zbarrier_state_func = &process_pap_zbarrier_state;
	}
	spawn_init();
	vending_weapon_upgrade_trigger = zm_pap_util::get_triggers();
	if(vending_weapon_upgrade_trigger.size >= 1)
	{
		array::thread_all(vending_weapon_upgrade_trigger, &vending_weapon_upgrade);
	}
	old_packs = getentarray("zombie_vending_upgrade", "targetname");
	for(i = 0; i < old_packs.size; i++)
	{
		vending_weapon_upgrade_trigger[vending_weapon_upgrade_trigger.size] = old_packs[i];
	}
	level flag::init("pack_machine_in_use");
}

/*
	Name: spawn_init
	Namespace: _zm_pack_a_punch
	Checksum: 0x90676372
	Offset: 0x8C8
	Size: 0x484
	Parameters: 0
	Flags: Linked, Private
*/
function private spawn_init()
{
	zbarriers = getentarray("zm_pack_a_punch", "targetname");
	for(i = 0; i < zbarriers.size; i++)
	{
		if(!zbarriers[i] iszbarrier())
		{
			continue;
		}
		if(!isdefined(level.pack_a_punch.interaction_height))
		{
			level.pack_a_punch.interaction_height = 35;
		}
		if(!isdefined(level.pack_a_punch.interaction_trigger_radius))
		{
			level.pack_a_punch.interaction_trigger_radius = 40;
		}
		if(!isdefined(level.pack_a_punch.interaction_trigger_height))
		{
			level.pack_a_punch.interaction_trigger_height = 70;
		}
		use_trigger = spawn("trigger_radius_use", zbarriers[i].origin + (0, 0, level.pack_a_punch.interaction_height), 0, level.pack_a_punch.interaction_trigger_radius, level.pack_a_punch.interaction_trigger_height);
		use_trigger.script_noteworthy = "pack_a_punch";
		use_trigger triggerignoreteam();
		use_trigger thread pap_trigger_hintstring_monitor();
		use_trigger flag::init("pap_offering_gun");
		collision = spawn("script_model", zbarriers[i].origin, 1);
		collision.angles = zbarriers[i].angles;
		collision setmodel("zm_collision_perks1");
		collision.script_noteworthy = "clip";
		collision disconnectpaths();
		use_trigger.clip = collision;
		use_trigger.zbarrier = zbarriers[i];
		use_trigger.script_sound = "mus_perks_packa_jingle";
		use_trigger.script_label = "mus_perks_packa_sting";
		use_trigger.longjinglewait = 1;
		use_trigger.target = "vending_packapunch";
		use_trigger.zbarrier.targetname = "vending_packapunch";
		powered_on = get_start_state();
		use_trigger.powered = zm_power::add_powered_item(&turn_on, &turn_off, &get_range, &cost_func, 0, powered_on, use_trigger);
		if(isdefined(level.pack_a_punch.custom_power_think))
		{
			use_trigger thread [[level.pack_a_punch.custom_power_think]](powered_on);
		}
		else
		{
			use_trigger thread toggle_think(powered_on);
		}
		if(!isdefined(level.pack_a_punch.triggers))
		{
			level.pack_a_punch.triggers = [];
		}
		else if(!isarray(level.pack_a_punch.triggers))
		{
			level.pack_a_punch.triggers = array(level.pack_a_punch.triggers);
		}
		level.pack_a_punch.triggers[level.pack_a_punch.triggers.size] = use_trigger;
	}
}

/*
	Name: pap_trigger_hintstring_monitor
	Namespace: _zm_pack_a_punch
	Checksum: 0x2DF1E363
	Offset: 0xD58
	Size: 0xE8
	Parameters: 0
	Flags: Linked, Private
*/
function private pap_trigger_hintstring_monitor()
{
	level endon(#"pack_a_punch_off");
	level waittill(#"pack_a_punch_on");
	self thread pap_trigger_hintstring_monitor_reset();
	while(true)
	{
		foreach(e_player in level.players)
		{
			if(e_player istouching(self))
			{
				self zm_pap_util::update_hint_string(e_player);
			}
		}
		wait(0.05);
	}
}

/*
	Name: pap_trigger_hintstring_monitor_reset
	Namespace: _zm_pack_a_punch
	Checksum: 0xFD722404
	Offset: 0xE48
	Size: 0x24
	Parameters: 0
	Flags: Linked, Private
*/
function private pap_trigger_hintstring_monitor_reset()
{
	level waittill(#"pack_a_punch_off");
	self thread pap_trigger_hintstring_monitor();
}

/*
	Name: third_person_weapon_upgrade
	Namespace: _zm_pack_a_punch
	Checksum: 0x2FCA6D05
	Offset: 0xE78
	Size: 0x4BC
	Parameters: 5
	Flags: Linked, Private
*/
function private third_person_weapon_upgrade(current_weapon, upgrade_weapon, packa_rollers, pap_machine, trigger)
{
	level endon(#"pack_a_punch_off");
	trigger endon(#"pap_player_disconnected");
	current_weapon = self getbuildkitweapon(current_weapon, 0);
	upgrade_weapon = self getbuildkitweapon(upgrade_weapon, 1);
	trigger.current_weapon = current_weapon;
	trigger.current_weapon_options = self getbuildkitweaponoptions(trigger.current_weapon);
	trigger.current_weapon_acvi = self getbuildkitattachmentcosmeticvariantindexes(trigger.current_weapon, 0);
	trigger.upgrade_weapon = upgrade_weapon;
	upgrade_weapon.pap_camo_to_use = zm_weapons::get_pack_a_punch_camo_index(upgrade_weapon.pap_camo_to_use);
	trigger.upgrade_weapon_options = self getbuildkitweaponoptions(trigger.upgrade_weapon, upgrade_weapon.pap_camo_to_use);
	trigger.upgrade_weapon_acvi = self getbuildkitattachmentcosmeticvariantindexes(trigger.upgrade_weapon, 1);
	trigger.zbarrier setweapon(trigger.current_weapon);
	trigger.zbarrier setweaponoptions(trigger.current_weapon_options);
	trigger.zbarrier setattachmentcosmeticvariantindexes(trigger.current_weapon_acvi);
	trigger.zbarrier set_pap_zbarrier_state("take_gun");
	rel_entity = trigger.pap_machine;
	origin_offset = (0, 0, 0);
	angles_offset = (0, 0, 0);
	origin_base = self.origin;
	angles_base = self.angles;
	if(isdefined(rel_entity))
	{
		origin_offset = (0, 0, level.pack_a_punch.interaction_height);
		angles_offset = vectorscale((0, 1, 0), 90);
		origin_base = rel_entity.origin;
		angles_base = rel_entity.angles;
	}
	else
	{
		rel_entity = self;
	}
	forward = anglestoforward(angles_base + angles_offset);
	interact_offset = origin_offset + (forward * -25);
	offsetdw = vectorscale((1, 1, 1), 3);
	pap_machine [[level.pack_a_punch.move_in_func]](self, trigger, origin_offset, angles_offset);
	self playsound("zmb_perks_packa_upgrade");
	wait(0.35);
	wait(3);
	trigger.zbarrier setweapon(upgrade_weapon);
	trigger.zbarrier setweaponoptions(trigger.upgrade_weapon_options);
	trigger.zbarrier setattachmentcosmeticvariantindexes(trigger.upgrade_weapon_acvi);
	trigger.zbarrier set_pap_zbarrier_state("eject_gun");
	if(isdefined(self))
	{
		self playsound("zmb_perks_packa_ready");
	}
	else
	{
		return;
	}
	rel_entity thread [[level.pack_a_punch.move_out_func]](self, trigger, origin_offset, interact_offset);
}

/*
	Name: can_pack_weapon
	Namespace: _zm_pack_a_punch
	Checksum: 0xE5E9C4E1
	Offset: 0x1340
	Size: 0xE6
	Parameters: 1
	Flags: Linked, Private
*/
function private can_pack_weapon(weapon)
{
	if(weapon.isriotshield)
	{
		return false;
	}
	if(level flag::get("pack_machine_in_use"))
	{
		return true;
	}
	if(!(isdefined(level.b_allow_idgun_pap) && level.b_allow_idgun_pap) && isdefined(level.idgun_weapons))
	{
		if(isinarray(level.idgun_weapons, weapon))
		{
			return false;
		}
	}
	weapon = self zm_weapons::get_nonalternate_weapon(weapon);
	if(!zm_weapons::is_weapon_or_base_included(weapon))
	{
		return false;
	}
	if(!self zm_weapons::can_upgrade_weapon(weapon))
	{
		return false;
	}
	return true;
}

/*
	Name: player_use_can_pack_now
	Namespace: _zm_pack_a_punch
	Checksum: 0x572511FF
	Offset: 0x1430
	Size: 0x100
	Parameters: 0
	Flags: Linked, Private
*/
function private player_use_can_pack_now()
{
	if(self laststand::player_is_in_laststand() || (isdefined(self.intermission) && self.intermission) || self isthrowinggrenade())
	{
		return false;
	}
	if(!self zm_magicbox::can_buy_weapon() || self bgb::is_enabled("zm_bgb_disorderly_combat"))
	{
		return false;
	}
	if(self zm_equipment::hacker_active())
	{
		return false;
	}
	current_weapon = self getcurrentweapon();
	if(!self can_pack_weapon(current_weapon) && !zm_weapons::weapon_supports_aat(current_weapon))
	{
		return false;
	}
	return true;
}

/*
	Name: pack_a_punch_machine_trigger_think
	Namespace: _zm_pack_a_punch
	Checksum: 0x48227DCE
	Offset: 0x1538
	Size: 0x144
	Parameters: 0
	Flags: Linked, Private
*/
function private pack_a_punch_machine_trigger_think()
{
	self endon(#"death");
	self endon(#"pack_a_punch_off");
	self notify(#"pack_a_punch_trigger_think");
	self endon(#"pack_a_punch_trigger_think");
	while(true)
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(isdefined(self.pack_player) && self.pack_player != players[i] || !players[i] player_use_can_pack_now() || players[i] bgb::is_active("zm_bgb_ephemeral_enhancement"))
			{
				self setinvisibletoplayer(players[i], 1);
				continue;
			}
			self setinvisibletoplayer(players[i], 0);
		}
		wait(0.1);
	}
}

/*
	Name: vending_weapon_upgrade
	Namespace: _zm_pack_a_punch
	Checksum: 0x31E2906D
	Offset: 0x1688
	Size: 0xB88
	Parameters: 0
	Flags: Linked, Private
*/
function private vending_weapon_upgrade()
{
	level endon(#"pack_a_punch_off");
	pap_machine = getent(self.target, "targetname");
	self.pap_machine = pap_machine;
	pap_machine_sound = getentarray("perksacola", "targetname");
	packa_rollers = spawn("script_origin", self.origin);
	packa_timer = spawn("script_origin", self.origin);
	packa_rollers linkto(self);
	packa_timer linkto(self);
	self usetriggerrequirelookat();
	self sethintstring(&"ZOMBIE_NEED_POWER");
	self setcursorhint("HINT_NOICON");
	power_off = !self is_on();
	if(power_off)
	{
		pap_array = [];
		pap_array[0] = pap_machine;
		level waittill(#"pack_a_punch_on");
	}
	self triggerenable(1);
	if(isdefined(level.pack_a_punch.power_on_callback))
	{
		pap_machine thread [[level.pack_a_punch.power_on_callback]]();
	}
	self thread pack_a_punch_machine_trigger_think();
	pap_machine playloopsound("zmb_perks_packa_loop");
	self thread shutoffpapsounds(pap_machine, packa_rollers, packa_timer);
	self thread vending_weapon_upgrade_cost();
	for(;;)
	{
		self.pack_player = undefined;
		self waittill(#"trigger", player);
		if(isdefined(pap_machine.state) && pap_machine.state == "leaving")
		{
			continue;
		}
		index = zm_utility::get_player_index(player);
		current_weapon = player getcurrentweapon();
		current_weapon = player zm_weapons::switch_from_alt_weapon(current_weapon);
		if(isdefined(level.pack_a_punch.custom_validation))
		{
			valid = self [[level.pack_a_punch.custom_validation]](player);
			if(!valid)
			{
				continue;
			}
		}
		if(!player zm_magicbox::can_buy_weapon() || player laststand::player_is_in_laststand() || (isdefined(player.intermission) && player.intermission) || player isthrowinggrenade() || (!player zm_weapons::can_upgrade_weapon(current_weapon) && !zm_weapons::weapon_supports_aat(current_weapon)))
		{
			wait(0.1);
			continue;
		}
		if(player isswitchingweapons())
		{
			wait(0.1);
			if(player isswitchingweapons())
			{
				continue;
			}
		}
		if(!zm_weapons::is_weapon_or_base_included(current_weapon))
		{
			continue;
		}
		current_cost = self.cost;
		player.restore_ammo = undefined;
		player.restore_clip = undefined;
		player.restore_stock = undefined;
		player_restore_clip_size = undefined;
		player.restore_max = undefined;
		b_weapon_supports_aat = zm_weapons::weapon_supports_aat(current_weapon);
		isrepack = 0;
		currentaathashid = -1;
		if(b_weapon_supports_aat)
		{
			current_cost = self.aat_cost;
			currentaat = player aat::getaatonweapon(current_weapon);
			if(isdefined(currentaat))
			{
				currentaathashid = currentaat.var_2c8ee667;
			}
			player.restore_ammo = 1;
			player.restore_clip = player getweaponammoclip(current_weapon);
			player.restore_clip_size = current_weapon.clipsize;
			player.restore_stock = player getweaponammostock(current_weapon);
			player.restore_max = current_weapon.maxammo;
			isrepack = 1;
		}
		if(player zm_pers_upgrades_functions::is_pers_double_points_active())
		{
			current_cost = player zm_pers_upgrades_functions::pers_upgrade_double_points_cost(current_cost);
		}
		if(!player zm_score::can_player_purchase(current_cost))
		{
			self playsound("zmb_perks_packa_deny");
			if(isdefined(level.pack_a_punch.custom_deny_func))
			{
				player [[level.pack_a_punch.custom_deny_func]]();
			}
			else
			{
				player zm_audio::create_and_play_dialog("general", "outofmoney", 0);
			}
			continue;
		}
		self.pack_player = player;
		level flag::set("pack_machine_in_use");
		demo::bookmark("zm_player_use_packapunch", gettime(), player);
		player zm_stats::increment_client_stat("use_pap");
		player zm_stats::increment_player_stat("use_pap");
		weaponidx = undefined;
		if(isdefined(current_weapon))
		{
			weaponidx = matchrecordgetweaponindex(current_weapon);
		}
		if(isdefined(weaponidx))
		{
			if(!isrepack)
			{
				player recordmapevent(19, gettime(), player.origin, level.round_number, weaponidx, current_cost);
				player zm_stats::increment_challenge_stat("ZM_DAILY_PACK_5_WEAPONS");
				player zm_stats::increment_challenge_stat("ZM_DAILY_PACK_10_WEAPONS");
			}
			else
			{
				player recordmapevent(25, gettime(), player.origin, level.round_number, weaponidx, currentaathashid);
				player zm_stats::increment_challenge_stat("ZM_DAILY_REPACK_WEAPONS");
			}
		}
		self thread destroy_weapon_in_blackout(player);
		player zm_score::minus_to_player_score(current_cost);
		self thread zm_audio::sndperksjingles_player(1);
		player zm_audio::create_and_play_dialog("general", "pap_wait");
		self triggerenable(0);
		player thread do_knuckle_crack();
		self.current_weapon = current_weapon;
		upgrade_weapon = zm_weapons::get_upgrade_weapon(current_weapon, b_weapon_supports_aat);
		player third_person_weapon_upgrade(current_weapon, upgrade_weapon, packa_rollers, pap_machine, self);
		self triggerenable(1);
		self setcursorhint("HINT_WEAPON", upgrade_weapon);
		self flag::set("pap_offering_gun");
		if(isdefined(player))
		{
			self setinvisibletoall();
			self setvisibletoplayer(player);
			self thread wait_for_player_to_take(player, current_weapon, packa_timer, b_weapon_supports_aat, isrepack);
			self thread wait_for_timeout(current_weapon, packa_timer, player, isrepack);
			self util::waittill_any("pap_timeout", "pap_taken", "pap_player_disconnected");
		}
		else
		{
			self wait_for_timeout(current_weapon, packa_timer, player, isrepack);
		}
		self.zbarrier set_pap_zbarrier_state("powered");
		self setcursorhint("HINT_NOICON");
		self.current_weapon = level.weaponnone;
		self flag::clear("pap_offering_gun");
		self thread pack_a_punch_machine_trigger_think();
		self.pack_player = undefined;
		level flag::clear("pack_machine_in_use");
	}
}

/*
	Name: shutoffpapsounds
	Namespace: _zm_pack_a_punch
	Checksum: 0xCBC2B9B9
	Offset: 0x2218
	Size: 0xB0
	Parameters: 3
	Flags: Linked, Private
*/
function private shutoffpapsounds(ent1, ent2, ent3)
{
	while(true)
	{
		level waittill(#"pack_a_punch_off");
		level thread turnonpapsounds(ent1);
		ent1 stoploopsound(0.1);
		ent2 stoploopsound(0.1);
		ent3 stoploopsound(0.1);
	}
}

/*
	Name: turnonpapsounds
	Namespace: _zm_pack_a_punch
	Checksum: 0x8657725F
	Offset: 0x22D0
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private turnonpapsounds(ent)
{
	level waittill(#"pack_a_punch_on");
	ent playloopsound("zmb_perks_packa_loop");
}

/*
	Name: vending_weapon_upgrade_cost
	Namespace: _zm_pack_a_punch
	Checksum: 0x1B0B260D
	Offset: 0x2310
	Size: 0x64
	Parameters: 0
	Flags: Linked, Private
*/
function private vending_weapon_upgrade_cost()
{
	level endon(#"pack_a_punch_off");
	while(true)
	{
		self.cost = 5000;
		self.aat_cost = 2500;
		level waittill(#"hash_ab83a4db");
		self.cost = 1000;
		self.aat_cost = 500;
		level waittill(#"bonfire_sale_off");
	}
}

/*
	Name: wait_for_player_to_take
	Namespace: _zm_pack_a_punch
	Checksum: 0xDFF64BF0
	Offset: 0x2380
	Size: 0x64C
	Parameters: 5
	Flags: Linked, Private
*/
function private wait_for_player_to_take(player, weapon, packa_timer, b_weapon_supports_aat, isrepack)
{
	current_weapon = self.current_weapon;
	upgrade_weapon = self.upgrade_weapon;
	/#
		assert(isdefined(current_weapon), "");
	#/
	/#
		assert(isdefined(upgrade_weapon), "");
	#/
	self endon(#"pap_timeout");
	level endon(#"pack_a_punch_off");
	while(isdefined(player))
	{
		packa_timer playloopsound("zmb_perks_packa_ticktock");
		self waittill(#"trigger", trigger_player);
		if(level.pack_a_punch.grabbable_by_anyone)
		{
			player = trigger_player;
		}
		packa_timer stoploopsound(0.05);
		if(trigger_player == player)
		{
			player zm_stats::increment_client_stat("pap_weapon_grabbed");
			player zm_stats::increment_player_stat("pap_weapon_grabbed");
			current_weapon = player getcurrentweapon();
			/#
				if(level.weaponnone == current_weapon)
				{
					iprintlnbold("");
				}
			#/
			if(zm_utility::is_player_valid(player) && !(player.is_drinking > 0) && !zm_utility::is_placeable_mine(current_weapon) && !zm_equipment::is_equipment(current_weapon) && !player zm_utility::is_player_revive_tool(current_weapon) && level.weaponnone != current_weapon && !player zm_equipment::hacker_active())
			{
				demo::bookmark("zm_player_grabbed_packapunch", gettime(), player);
				self notify(#"pap_taken");
				player notify(#"pap_taken");
				player.pap_used = 1;
				weapon_limit = zm_utility::get_player_weapon_limit(player);
				player zm_weapons::take_fallback_weapon();
				primaries = player getweaponslistprimaries();
				if(isdefined(primaries) && primaries.size >= weapon_limit)
				{
					upgrade_weapon = player zm_weapons::weapon_give(upgrade_weapon);
				}
				else
				{
					upgrade_weapon = player zm_weapons::give_build_kit_weapon(upgrade_weapon);
					player givestartammo(upgrade_weapon);
				}
				player notify(#"weapon_give", upgrade_weapon);
				aatid = -1;
				if(isdefined(b_weapon_supports_aat) && b_weapon_supports_aat)
				{
					player thread aat::acquire(upgrade_weapon);
					aatobj = player aat::getaatonweapon(upgrade_weapon);
					if(isdefined(aatobj))
					{
						aatid = aatobj.var_2c8ee667;
					}
				}
				else
				{
					player thread aat::remove(upgrade_weapon);
				}
				weaponidx = undefined;
				if(isdefined(weapon))
				{
					weaponidx = matchrecordgetweaponindex(weapon);
				}
				if(isdefined(weaponidx))
				{
					if(!isrepack)
					{
						player recordmapevent(27, gettime(), player.origin, level.round_number, weaponidx, aatid);
					}
					else
					{
						player recordmapevent(28, gettime(), player.origin, level.round_number, weaponidx, aatid);
					}
				}
				player switchtoweapon(upgrade_weapon);
				if(isdefined(player.restore_ammo) && player.restore_ammo)
				{
					new_clip = player.restore_clip + (upgrade_weapon.clipsize - player.restore_clip_size);
					new_stock = player.restore_stock + (upgrade_weapon.maxammo - player.restore_max);
					player setweaponammostock(upgrade_weapon, new_stock);
					player setweaponammoclip(upgrade_weapon, new_clip);
				}
				player.restore_ammo = undefined;
				player.restore_clip = undefined;
				player.restore_stock = undefined;
				player.restore_max = undefined;
				player.restore_clip_size = undefined;
				player zm_weapons::play_weapon_vo(upgrade_weapon);
				return;
			}
		}
		wait(0.05);
	}
}

/*
	Name: wait_for_timeout
	Namespace: _zm_pack_a_punch
	Checksum: 0x36EAFFD3
	Offset: 0x29D8
	Size: 0x204
	Parameters: 4
	Flags: Linked, Private
*/
function private wait_for_timeout(weapon, packa_timer, player, isrepack)
{
	self endon(#"pap_taken");
	self endon(#"pap_player_disconnected");
	self thread wait_for_disconnect(player);
	wait(level.pack_a_punch.timeout);
	self notify(#"pap_timeout");
	packa_timer stoploopsound(0.05);
	packa_timer playsound("zmb_perks_packa_deny");
	if(isdefined(player))
	{
		player zm_stats::increment_client_stat("pap_weapon_not_grabbed");
		player zm_stats::increment_player_stat("pap_weapon_not_grabbed");
		weaponidx = undefined;
		if(isdefined(weapon))
		{
			weaponidx = matchrecordgetweaponindex(weapon);
		}
		if(isdefined(weaponidx))
		{
			if(!isrepack)
			{
				player recordmapevent(20, gettime(), player.origin, level.round_number, weaponidx);
			}
			else
			{
				aatonweapon = player aat::getaatonweapon(weapon);
				aathash = -1;
				if(isdefined(aatonweapon))
				{
					aathash = aatonweapon.var_2c8ee667;
				}
				player recordmapevent(26, gettime(), player.origin, level.round_number, weaponidx, aathash);
			}
		}
	}
}

/*
	Name: wait_for_disconnect
	Namespace: _zm_pack_a_punch
	Checksum: 0x6C21B74E
	Offset: 0x2BE8
	Size: 0x62
	Parameters: 1
	Flags: Linked, Private
*/
function private wait_for_disconnect(player)
{
	self endon(#"pap_taken");
	self endon(#"pap_timeout");
	while(isdefined(player))
	{
		wait(0.1);
	}
	/#
		println("");
	#/
	self notify(#"pap_player_disconnected");
}

/*
	Name: destroy_weapon_in_blackout
	Namespace: _zm_pack_a_punch
	Checksum: 0xEFA9743C
	Offset: 0x2C58
	Size: 0xA4
	Parameters: 1
	Flags: Linked, Private
*/
function private destroy_weapon_in_blackout(player)
{
	self endon(#"pap_timeout");
	self endon(#"pap_taken");
	self endon(#"pap_player_disconnected");
	level waittill(#"pack_a_punch_off");
	self.zbarrier set_pap_zbarrier_state("take_gun");
	player playlocalsound(level.zmb_laugh_alias);
	wait(1.5);
	self.zbarrier set_pap_zbarrier_state("power_off");
}

/*
	Name: do_knuckle_crack
	Namespace: _zm_pack_a_punch
	Checksum: 0x2E8EC0DA
	Offset: 0x2D08
	Size: 0x74
	Parameters: 0
	Flags: Linked, Private
*/
function private do_knuckle_crack()
{
	self endon(#"disconnect");
	self upgrade_knuckle_crack_begin();
	self util::waittill_any("fake_death", "death", "player_downed", "weapon_change_complete");
	self upgrade_knuckle_crack_end();
}

/*
	Name: upgrade_knuckle_crack_begin
	Namespace: _zm_pack_a_punch
	Checksum: 0x783B0945
	Offset: 0x2D88
	Size: 0x13C
	Parameters: 0
	Flags: Linked, Private
*/
function private upgrade_knuckle_crack_begin()
{
	self zm_utility::increment_is_drinking();
	self zm_utility::disable_player_move_states(1);
	primaries = self getweaponslistprimaries();
	original_weapon = self getcurrentweapon();
	weapon = getweapon("zombie_knuckle_crack");
	if(original_weapon != level.weaponnone && !zm_utility::is_placeable_mine(original_weapon) && !zm_equipment::is_equipment(original_weapon))
	{
		self notify(#"zmb_lost_knife");
		self takeweapon(original_weapon);
	}
	else
	{
		return;
	}
	self giveweapon(weapon);
	self switchtoweapon(weapon);
}

/*
	Name: upgrade_knuckle_crack_end
	Namespace: _zm_pack_a_punch
	Checksum: 0x22BD43A8
	Offset: 0x2ED0
	Size: 0x104
	Parameters: 0
	Flags: Linked, Private
*/
function private upgrade_knuckle_crack_end()
{
	self zm_utility::enable_player_move_states();
	weapon = getweapon("zombie_knuckle_crack");
	if(self laststand::player_is_in_laststand() || (isdefined(self.intermission) && self.intermission))
	{
		self takeweapon(weapon);
		return;
	}
	self zm_utility::decrement_is_drinking();
	self takeweapon(weapon);
	primaries = self getweaponslistprimaries();
	if(self.is_drinking > 0)
	{
		return;
	}
	self zm_weapons::switch_back_primary_weapon();
}

/*
	Name: get_range
	Namespace: _zm_pack_a_punch
	Checksum: 0xF4F4E538
	Offset: 0x2FE0
	Size: 0xF2
	Parameters: 3
	Flags: Linked, Private
*/
function private get_range(delta, origin, radius)
{
	if(isdefined(self.target))
	{
		paporigin = self.target.origin;
		if(isdefined(self.target.trigger_off) && self.target.trigger_off)
		{
			paporigin = self.target.realorigin;
		}
		else if(isdefined(self.target.disabled) && self.target.disabled)
		{
			paporigin = paporigin + vectorscale((0, 0, 1), 10000);
		}
		if(distancesquared(paporigin, origin) < (radius * radius))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: turn_on
	Namespace: _zm_pack_a_punch
	Checksum: 0x221ABC61
	Offset: 0x30E0
	Size: 0x42
	Parameters: 2
	Flags: Linked, Private
*/
function private turn_on(origin, radius)
{
	/#
		println("");
	#/
	level notify(#"pack_a_punch_on");
}

/*
	Name: turn_off
	Namespace: _zm_pack_a_punch
	Checksum: 0x21CEBB9D
	Offset: 0x3130
	Size: 0x6C
	Parameters: 2
	Flags: Linked, Private
*/
function private turn_off(origin, radius)
{
	/#
		println("");
	#/
	level notify(#"pack_a_punch_off");
	self.target notify(#"death");
	self.target thread vending_weapon_upgrade();
}

/*
	Name: is_on
	Namespace: _zm_pack_a_punch
	Checksum: 0xB9B8C0FF
	Offset: 0x31A8
	Size: 0x22
	Parameters: 0
	Flags: Linked, Private
*/
function private is_on()
{
	if(isdefined(self.powered))
	{
		return self.powered.power;
	}
	return 0;
}

/*
	Name: get_start_state
	Namespace: _zm_pack_a_punch
	Checksum: 0x95727F74
	Offset: 0x31D8
	Size: 0x22
	Parameters: 0
	Flags: Linked, Private
*/
function private get_start_state()
{
	if(isdefined(level.vending_machines_powered_on_at_start) && level.vending_machines_powered_on_at_start)
	{
		return true;
	}
	return false;
}

/*
	Name: cost_func
	Namespace: _zm_pack_a_punch
	Checksum: 0xAC719AD8
	Offset: 0x3208
	Size: 0x6E
	Parameters: 0
	Flags: Linked, Private
*/
function private cost_func()
{
	if(isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost = undefined;
		return cost;
	}
	if(isdefined(level._power_global) && level._power_global)
	{
		return 0;
	}
	if(isdefined(self.self_powered) && self.self_powered)
	{
		return 0;
	}
	return 1;
}

/*
	Name: toggle_think
	Namespace: _zm_pack_a_punch
	Checksum: 0x4A89C120
	Offset: 0x3280
	Size: 0xA4
	Parameters: 1
	Flags: Linked, Private
*/
function private toggle_think(powered_on)
{
	if(!powered_on)
	{
		self.zbarrier set_pap_zbarrier_state("initial");
		level waittill(#"pack_a_punch_on");
	}
	for(;;)
	{
		self.zbarrier set_pap_zbarrier_state("power_on");
		level waittill(#"pack_a_punch_off");
		self.zbarrier set_pap_zbarrier_state("power_off");
		level waittill(#"pack_a_punch_on");
	}
}

/*
	Name: pap_initial
	Namespace: _zm_pack_a_punch
	Checksum: 0xB6FB840B
	Offset: 0x3330
	Size: 0x3C
	Parameters: 0
	Flags: Linked, Private
*/
function private pap_initial()
{
	self zbarrierpieceuseattachweapon(3);
	self setzbarrierpiecestate(0, "closed");
}

/*
	Name: pap_power_off
	Namespace: _zm_pack_a_punch
	Checksum: 0x5671F2CE
	Offset: 0x3378
	Size: 0x24
	Parameters: 0
	Flags: Linked, Private
*/
function private pap_power_off()
{
	self setzbarrierpiecestate(0, "closing");
}

/*
	Name: pap_power_on
	Namespace: _zm_pack_a_punch
	Checksum: 0x922584AA
	Offset: 0x33A8
	Size: 0x9C
	Parameters: 0
	Flags: Linked, Private
*/
function private pap_power_on()
{
	self endon(#"zbarrier_state_change");
	self setzbarrierpiecestate(0, "opening");
	while(self getzbarrierpiecestate(0) == "opening")
	{
		wait(0.05);
	}
	self playsound("zmb_perks_power_on");
	self thread set_pap_zbarrier_state("powered");
}

/*
	Name: pap_powered
	Namespace: _zm_pack_a_punch
	Checksum: 0x309C4005
	Offset: 0x3450
	Size: 0xF0
	Parameters: 0
	Flags: Linked, Private
*/
function private pap_powered()
{
	self endon(#"zbarrier_state_change");
	self setzbarrierpiecestate(4, "closed");
	if(self.classname === "zbarrier_zm_castle_packapunch" || self.classname === "zbarrier_zm_tomb_packapunch")
	{
		self clientfield::set("pap_working_FX", 0);
	}
	while(true)
	{
		wait(randomfloatrange(180, 1800));
		self setzbarrierpiecestate(4, "opening");
		wait(randomfloatrange(180, 1800));
		self setzbarrierpiecestate(4, "closing");
	}
}

/*
	Name: pap_take_gun
	Namespace: _zm_pack_a_punch
	Checksum: 0x7AAB39D1
	Offset: 0x3548
	Size: 0xB4
	Parameters: 0
	Flags: Linked, Private
*/
function private pap_take_gun()
{
	self setzbarrierpiecestate(1, "opening");
	self setzbarrierpiecestate(2, "opening");
	self setzbarrierpiecestate(3, "opening");
	wait(0.1);
	if(self.classname === "zbarrier_zm_castle_packapunch" || self.classname === "zbarrier_zm_tomb_packapunch")
	{
		self clientfield::set("pap_working_FX", 1);
	}
}

/*
	Name: pap_eject_gun
	Namespace: _zm_pack_a_punch
	Checksum: 0x1C6CA453
	Offset: 0x3608
	Size: 0x64
	Parameters: 0
	Flags: Linked, Private
*/
function private pap_eject_gun()
{
	self setzbarrierpiecestate(1, "closing");
	self setzbarrierpiecestate(2, "closing");
	self setzbarrierpiecestate(3, "closing");
}

/*
	Name: pap_leaving
	Namespace: _zm_pack_a_punch
	Checksum: 0xBC096C7B
	Offset: 0x3678
	Size: 0x82
	Parameters: 0
	Flags: Linked, Private
*/
function private pap_leaving()
{
	self setzbarrierpiecestate(5, "closing");
	do
	{
		wait(0.05);
	}
	while(self getzbarrierpiecestate(5) == "closing");
	self setzbarrierpiecestate(5, "closed");
	self notify(#"leave_anim_done");
}

/*
	Name: pap_arriving
	Namespace: _zm_pack_a_punch
	Checksum: 0xAB54EAB1
	Offset: 0x3708
	Size: 0x9C
	Parameters: 0
	Flags: Linked, Private
*/
function private pap_arriving()
{
	self endon(#"zbarrier_state_change");
	self setzbarrierpiecestate(0, "opening");
	while(self getzbarrierpiecestate(0) == "opening")
	{
		wait(0.05);
	}
	self playsound("zmb_perks_power_on");
	self thread set_pap_zbarrier_state("powered");
}

/*
	Name: get_pap_zbarrier_state
	Namespace: _zm_pack_a_punch
	Checksum: 0xBFB74BB9
	Offset: 0x37B0
	Size: 0xA
	Parameters: 0
	Flags: Private
*/
function private get_pap_zbarrier_state()
{
	return self.state;
}

/*
	Name: set_pap_zbarrier_state
	Namespace: _zm_pack_a_punch
	Checksum: 0xE8B5831B
	Offset: 0x37C8
	Size: 0x80
	Parameters: 1
	Flags: Linked, Private
*/
function private set_pap_zbarrier_state(state)
{
	for(i = 0; i < self getnumzbarrierpieces(); i++)
	{
		self hidezbarrierpiece(i);
	}
	self notify(#"zbarrier_state_change");
	self [[level.pap_zbarrier_state_func]](state);
}

/*
	Name: process_pap_zbarrier_state
	Namespace: _zm_pack_a_punch
	Checksum: 0x91BCEFC5
	Offset: 0x3850
	Size: 0x326
	Parameters: 1
	Flags: Linked, Private
*/
function private process_pap_zbarrier_state(state)
{
	switch(state)
	{
		case "initial":
		{
			self showzbarrierpiece(0);
			self thread pap_initial();
			self.state = "initial";
			break;
		}
		case "power_off":
		{
			self showzbarrierpiece(0);
			self thread pap_power_off();
			self.state = "power_off";
			break;
		}
		case "power_on":
		{
			self showzbarrierpiece(0);
			self thread pap_power_on();
			self.state = "power_on";
			break;
		}
		case "powered":
		{
			self showzbarrierpiece(4);
			self thread pap_powered();
			self.state = "powered";
			break;
		}
		case "take_gun":
		{
			self showzbarrierpiece(1);
			self showzbarrierpiece(2);
			self showzbarrierpiece(3);
			self thread pap_take_gun();
			self.state = "take_gun";
			break;
		}
		case "eject_gun":
		{
			self showzbarrierpiece(1);
			self showzbarrierpiece(2);
			self showzbarrierpiece(3);
			self thread pap_eject_gun();
			self.state = "eject_gun";
			break;
		}
		case "leaving":
		{
			self showzbarrierpiece(5);
			self thread pap_leaving();
			self.state = "leaving";
			break;
		}
		case "arriving":
		{
			self showzbarrierpiece(0);
			self thread pap_arriving();
			self.state = "arriving";
			break;
		}
		case "hidden":
		{
			self.state = "hidden";
			break;
		}
		default:
		{
			if(isdefined(level.custom_pap_state_handler))
			{
				self [[level.custom_pap_state_handler]](state);
			}
			break;
		}
	}
}

/*
	Name: set_state_initial
	Namespace: _zm_pack_a_punch
	Checksum: 0x40CB1AFE
	Offset: 0x3B80
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function set_state_initial()
{
	self set_pap_zbarrier_state("initial");
}

/*
	Name: set_state_leaving
	Namespace: _zm_pack_a_punch
	Checksum: 0xADCBDDB1
	Offset: 0x3BB0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function set_state_leaving()
{
	self set_pap_zbarrier_state("leaving");
}

/*
	Name: set_state_arriving
	Namespace: _zm_pack_a_punch
	Checksum: 0x788533D
	Offset: 0x3BE0
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function set_state_arriving()
{
	self set_pap_zbarrier_state("arriving");
}

/*
	Name: set_state_power_on
	Namespace: _zm_pack_a_punch
	Checksum: 0xF57FEA00
	Offset: 0x3C10
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function set_state_power_on()
{
	self set_pap_zbarrier_state("power_on");
}

/*
	Name: set_state_hidden
	Namespace: _zm_pack_a_punch
	Checksum: 0xD3C7E32D
	Offset: 0x3C40
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function set_state_hidden()
{
	self set_pap_zbarrier_state("hidden");
}

