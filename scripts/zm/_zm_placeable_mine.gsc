// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace zm_placeable_mine;

/*
	Name: __init__sytem__
	Namespace: zm_placeable_mine
	Checksum: 0xF8BBDC12
	Offset: 0x2A8
	Size: 0x2C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("placeable_mine", undefined, &__main__, undefined);
}

/*
	Name: __main__
	Namespace: zm_placeable_mine
	Checksum: 0x835E99C8
	Offset: 0x2E0
	Size: 0x24
	Parameters: 0
	Flags: Linked, Private
*/
function private __main__()
{
	if(isdefined(level.placeable_mines))
	{
		level thread replenish_after_rounds();
	}
}

/*
	Name: init_internal
	Namespace: zm_placeable_mine
	Checksum: 0x80B3D893
	Offset: 0x310
	Size: 0x70
	Parameters: 0
	Flags: Linked, Private
*/
function private init_internal()
{
	if(isdefined(level.placeable_mines))
	{
		return;
	}
	level.placeable_mines = [];
	level.placeable_mines_on_damage = &placeable_mine_damage;
	level.pickup_placeable_mine = &pickup_placeable_mine;
	level.pickup_placeable_mine_trigger_listener = &pickup_placeable_mine_trigger_listener;
	level.placeable_mine_planted_callbacks = [];
}

/*
	Name: get_first_available
	Namespace: zm_placeable_mine
	Checksum: 0x49678755
	Offset: 0x388
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function get_first_available()
{
	if(isdefined(level.placeable_mines) && level.placeable_mines.size > 0)
	{
		str_key = getarraykeys(level.placeable_mines)[0];
		return level.placeable_mines[str_key];
	}
	return level.weaponnone;
}

/*
	Name: add_mine_type
	Namespace: zm_placeable_mine
	Checksum: 0xAA8A7E11
	Offset: 0x3F8
	Size: 0x72
	Parameters: 2
	Flags: Linked
*/
function add_mine_type(mine_name, str_retrieval_prompt)
{
	init_internal();
	weaponobjects::createretrievablehint(mine_name, str_retrieval_prompt);
	level.placeable_mines[mine_name] = getweapon(mine_name);
	level.placeable_mine_planted_callbacks[mine_name] = [];
}

/*
	Name: add_weapon_to_mine_slot
	Namespace: zm_placeable_mine
	Checksum: 0xC8230F66
	Offset: 0x478
	Size: 0x92
	Parameters: 1
	Flags: None
*/
function add_weapon_to_mine_slot(mine_name)
{
	init_internal();
	level.placeable_mines[mine_name] = getweapon(mine_name);
	level.placeable_mine_planted_callbacks[mine_name] = [];
	if(!isdefined(level.placeable_mines_in_name_only))
	{
		level.placeable_mines_in_name_only = [];
	}
	level.placeable_mines_in_name_only[mine_name] = getweapon(mine_name);
}

/*
	Name: set_max_per_player
	Namespace: zm_placeable_mine
	Checksum: 0xF6D4CEF8
	Offset: 0x518
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function set_max_per_player(n_max_per_player)
{
	level.placeable_mines_max_per_player = n_max_per_player;
}

/*
	Name: add_planted_callback
	Namespace: zm_placeable_mine
	Checksum: 0x485A70A1
	Offset: 0x538
	Size: 0xB0
	Parameters: 2
	Flags: None
*/
function add_planted_callback(fn_planted_cb, wpn_name)
{
	if(!isdefined(level.placeable_mine_planted_callbacks[wpn_name]))
	{
		level.placeable_mine_planted_callbacks[wpn_name] = [];
	}
	else if(!isarray(level.placeable_mine_planted_callbacks[wpn_name]))
	{
		level.placeable_mine_planted_callbacks[wpn_name] = array(level.placeable_mine_planted_callbacks[wpn_name]);
	}
	level.placeable_mine_planted_callbacks[wpn_name][level.placeable_mine_planted_callbacks[wpn_name].size] = fn_planted_cb;
}

/*
	Name: run_planted_callbacks
	Namespace: zm_placeable_mine
	Checksum: 0x2D51C8F1
	Offset: 0x5F0
	Size: 0xA0
	Parameters: 1
	Flags: Linked, Private
*/
function private run_planted_callbacks(e_planter)
{
	foreach(fn in level.placeable_mine_planted_callbacks[self.weapon.name])
	{
		self thread [[fn]](e_planter);
	}
}

/*
	Name: safe_to_plant
	Namespace: zm_placeable_mine
	Checksum: 0xDF12834A
	Offset: 0x698
	Size: 0x34
	Parameters: 0
	Flags: Linked, Private
*/
function private safe_to_plant()
{
	if(isdefined(level.placeable_mines_max_per_player) && self.owner.placeable_mines.size >= level.placeable_mines_max_per_player)
	{
		return false;
	}
	return true;
}

/*
	Name: wait_and_detonate
	Namespace: zm_placeable_mine
	Checksum: 0xEA0A8BE2
	Offset: 0x6D8
	Size: 0x2C
	Parameters: 0
	Flags: Linked, Private
*/
function private wait_and_detonate()
{
	wait(0.1);
	self detonate(self.owner);
}

/*
	Name: mine_watch
	Namespace: zm_placeable_mine
	Checksum: 0xF8466FE8
	Offset: 0x710
	Size: 0x160
	Parameters: 1
	Flags: Linked, Private
*/
function private mine_watch(wpn_type)
{
	self endon(#"death");
	self notify(#"mine_watch");
	self endon(#"mine_watch");
	while(true)
	{
		self waittill(#"grenade_fire", mine, fired_weapon);
		if(fired_weapon == wpn_type)
		{
			mine.owner = self;
			mine.team = self.team;
			mine.weapon = fired_weapon;
			self notify(("zmb_enable_" + fired_weapon.name) + "_prompt");
			if(mine safe_to_plant())
			{
				mine run_planted_callbacks(self);
				self zm_stats::increment_client_stat(fired_weapon.name + "_planted");
				self zm_stats::increment_player_stat(fired_weapon.name + "_planted");
			}
			else
			{
				mine thread wait_and_detonate();
			}
		}
	}
}

/*
	Name: is_true_placeable_mine
	Namespace: zm_placeable_mine
	Checksum: 0xB8D25709
	Offset: 0x878
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function is_true_placeable_mine(mine_name)
{
	if(!isdefined(level.placeable_mines_in_name_only))
	{
		return true;
	}
	if(!isdefined(level.placeable_mines_in_name_only[mine_name]))
	{
		return true;
	}
	return false;
}

/*
	Name: setup_for_player
	Namespace: zm_placeable_mine
	Checksum: 0xE6820507
	Offset: 0x8C0
	Size: 0x170
	Parameters: 2
	Flags: Linked
*/
function setup_for_player(wpn_type, ui_model = "hudItems.showDpadRight")
{
	if(!isdefined(self.placeable_mines))
	{
		self.placeable_mines = [];
	}
	if(isdefined(self.last_placeable_mine_uimodel))
	{
		self clientfield::set_player_uimodel(self.last_placeable_mine_uimodel, 0);
	}
	if(is_true_placeable_mine(wpn_type.name))
	{
		self thread mine_watch(wpn_type);
	}
	self giveweapon(wpn_type);
	self zm_utility::set_player_placeable_mine(wpn_type);
	self setactionslot(4, "weapon", wpn_type);
	startammo = wpn_type.startammo;
	if(startammo)
	{
		self setweaponammostock(wpn_type, startammo);
	}
	if(isdefined(ui_model))
	{
		self clientfield::set_player_uimodel(ui_model, 1);
	}
	self.last_placeable_mine_uimodel = ui_model;
}

/*
	Name: disable_prompt_for_player
	Namespace: zm_placeable_mine
	Checksum: 0x56BD53EA
	Offset: 0xA38
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function disable_prompt_for_player(wpn_type)
{
	self notify(("zmb_disable_" + wpn_type.name) + "_prompt");
}

/*
	Name: disable_all_prompts_for_player
	Namespace: zm_placeable_mine
	Checksum: 0x97206E3D
	Offset: 0xA70
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function disable_all_prompts_for_player()
{
	foreach(mine in level.placeable_mines)
	{
		self disable_prompt_for_player(mine);
	}
}

/*
	Name: pickup_placeable_mine
	Namespace: zm_placeable_mine
	Checksum: 0xC346B41B
	Offset: 0xB08
	Size: 0x2BC
	Parameters: 0
	Flags: Linked, Private
*/
function private pickup_placeable_mine()
{
	player = self.owner;
	wpn_type = self.weapon;
	if(player.is_drinking > 0)
	{
		return;
	}
	current_player_mine = player zm_utility::get_player_placeable_mine();
	if(current_player_mine != wpn_type)
	{
		player takeweapon(current_player_mine);
	}
	if(!player hasweapon(wpn_type))
	{
		player thread mine_watch(wpn_type);
		player giveweapon(wpn_type);
		player zm_utility::set_player_placeable_mine(wpn_type);
		player setactionslot(4, "weapon", wpn_type);
		player setweaponammoclip(wpn_type, 0);
		player notify(("zmb_enable_" + wpn_type.name) + "_prompt");
	}
	else
	{
		clip_ammo = player getweaponammoclip(wpn_type);
		clip_max_ammo = wpn_type.clipsize;
		if(clip_ammo >= clip_max_ammo)
		{
			self zm_utility::destroy_ent();
			player disable_prompt_for_player(wpn_type);
			return;
		}
	}
	self zm_utility::pick_up();
	clip_ammo = player getweaponammoclip(wpn_type);
	clip_max_ammo = wpn_type.clipsize;
	if(clip_ammo >= clip_max_ammo)
	{
		player disable_prompt_for_player(wpn_type);
	}
	player zm_stats::increment_client_stat(wpn_type.name + "_pickedup");
	player zm_stats::increment_player_stat(wpn_type.name + "_pickedup");
}

/*
	Name: pickup_placeable_mine_trigger_listener
	Namespace: zm_placeable_mine
	Checksum: 0x9C0CE992
	Offset: 0xDD0
	Size: 0x54
	Parameters: 2
	Flags: Linked, Private
*/
function private pickup_placeable_mine_trigger_listener(trigger, player)
{
	self thread pickup_placeable_mine_trigger_listener_enable(trigger, player);
	self thread pickup_placeable_mine_trigger_listener_disable(trigger, player);
}

/*
	Name: pickup_placeable_mine_trigger_listener_enable
	Namespace: zm_placeable_mine
	Checksum: 0x76825AD7
	Offset: 0xE30
	Size: 0xB8
	Parameters: 2
	Flags: Linked, Private
*/
function private pickup_placeable_mine_trigger_listener_enable(trigger, player)
{
	self endon(#"delete");
	self endon(#"death");
	while(true)
	{
		player util::waittill_any(("zmb_enable_" + self.weapon.name) + "_prompt", "spawned_player");
		if(!isdefined(trigger))
		{
			return;
		}
		trigger triggerenable(1);
		trigger linkto(self);
	}
}

/*
	Name: pickup_placeable_mine_trigger_listener_disable
	Namespace: zm_placeable_mine
	Checksum: 0xE3D0407E
	Offset: 0xEF0
	Size: 0x98
	Parameters: 2
	Flags: Linked, Private
*/
function private pickup_placeable_mine_trigger_listener_disable(trigger, player)
{
	self endon(#"delete");
	self endon(#"death");
	while(true)
	{
		player waittill(("zmb_disable_" + self.weapon.name) + "_prompt");
		if(!isdefined(trigger))
		{
			return;
		}
		trigger unlink();
		trigger triggerenable(0);
	}
}

/*
	Name: placeable_mine_damage
	Namespace: zm_placeable_mine
	Checksum: 0x69C4B4EE
	Offset: 0xF90
	Size: 0x1AC
	Parameters: 0
	Flags: Linked, Private
*/
function private placeable_mine_damage()
{
	self endon(#"death");
	self setcandamage(1);
	self.health = 100000;
	self.maxhealth = self.health;
	attacker = undefined;
	while(true)
	{
		self waittill(#"damage", amount, attacker);
		if(!isdefined(self))
		{
			return;
		}
		self.health = self.maxhealth;
		if(!isplayer(attacker))
		{
			continue;
		}
		if(isdefined(self.owner) && attacker == self.owner)
		{
			continue;
		}
		if(isdefined(attacker.pers) && isdefined(attacker.pers["team"]) && attacker.pers["team"] != level.zombie_team)
		{
			continue;
		}
		break;
	}
	if(level.satchelexplodethisframe)
	{
		wait(0.1 + randomfloat(0.4));
	}
	else
	{
		wait(0.05);
	}
	if(!isdefined(self))
	{
		return;
	}
	level.satchelexplodethisframe = 1;
	thread reset_satchel_explode_this_frame();
	self detonate(attacker);
}

/*
	Name: reset_satchel_explode_this_frame
	Namespace: zm_placeable_mine
	Checksum: 0x36342F21
	Offset: 0x1148
	Size: 0x18
	Parameters: 0
	Flags: Linked, Private
*/
function private reset_satchel_explode_this_frame()
{
	wait(0.05);
	level.satchelexplodethisframe = 0;
}

/*
	Name: replenish_after_rounds
	Namespace: zm_placeable_mine
	Checksum: 0x977C8570
	Offset: 0x1168
	Size: 0x214
	Parameters: 0
	Flags: Linked, Private
*/
function private replenish_after_rounds()
{
	while(true)
	{
		level waittill(#"between_round_over");
		if(isdefined(level.func_custom_placeable_mine_round_replenish))
		{
			[[level.func_custom_placeable_mine_round_replenish]]();
			continue;
		}
		if(!level flag::exists("teleporter_used") || !level flag::get("teleporter_used"))
		{
			players = getplayers();
			for(i = 0; i < players.size; i++)
			{
				foreach(mine in level.placeable_mines)
				{
					if(players[i] zm_utility::is_player_placeable_mine(mine) && is_true_placeable_mine(mine.name))
					{
						players[i] giveweapon(mine);
						players[i] zm_utility::set_player_placeable_mine(mine);
						players[i] setactionslot(4, "weapon", mine);
						players[i] setweaponammoclip(mine, 2);
						break;
					}
				}
			}
		}
	}
}

/*
	Name: setup_watchers
	Namespace: zm_placeable_mine
	Checksum: 0x9343B07D
	Offset: 0x1388
	Size: 0x172
	Parameters: 0
	Flags: Linked
*/
function setup_watchers()
{
	if(isdefined(level.placeable_mines))
	{
		foreach(mine_type in level.placeable_mines)
		{
			watcher = self weaponobjects::createuseweaponobjectwatcher(mine_type.name, self.team);
			watcher.onspawnretrievetriggers = &on_spawn_retrieve_trigger;
			watcher.adjusttriggerorigin = &adjust_trigger_origin;
			watcher.pickup = level.pickup_placeable_mine;
			watcher.pickup_trigger_listener = level.pickup_placeable_mine_trigger_listener;
			watcher.skip_weapon_object_damage = 1;
			watcher.headicon = 0;
			watcher.watchforfire = 1;
			watcher.ondetonatecallback = &placeable_mine_detonate;
			watcher.ondamage = level.placeable_mines_on_damage;
		}
	}
}

/*
	Name: on_spawn_retrieve_trigger
	Namespace: zm_placeable_mine
	Checksum: 0x7C620D33
	Offset: 0x1508
	Size: 0x5C
	Parameters: 2
	Flags: Linked, Private
*/
function private on_spawn_retrieve_trigger(watcher, player)
{
	self weaponobjects::onspawnretrievableweaponobject(watcher, player);
	if(isdefined(self.pickuptrigger))
	{
		self.pickuptrigger sethintlowpriority(0);
	}
}

/*
	Name: adjust_trigger_origin
	Namespace: zm_placeable_mine
	Checksum: 0xC501C98E
	Offset: 0x1570
	Size: 0x28
	Parameters: 1
	Flags: Linked, Private
*/
function private adjust_trigger_origin(origin)
{
	origin = origin + vectorscale((0, 0, 1), 20);
	return origin;
}

/*
	Name: placeable_mine_detonate
	Namespace: zm_placeable_mine
	Checksum: 0x3FB965AA
	Offset: 0x15A0
	Size: 0xCC
	Parameters: 3
	Flags: Linked, Private
*/
function private placeable_mine_detonate(attacker, weapon, target)
{
	if(weapon.isemp)
	{
		self delete();
		return;
	}
	if(isdefined(attacker))
	{
		self detonate(attacker);
	}
	else
	{
		if(isdefined(self.owner) && isplayer(self.owner))
		{
			self detonate(self.owner);
		}
		else
		{
			self detonate();
		}
	}
}

