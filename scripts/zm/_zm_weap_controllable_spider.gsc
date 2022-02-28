// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\player_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\zm\_util;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;

#namespace controllable_spider;

/*
	Name: __init__sytem__
	Namespace: controllable_spider
	Checksum: 0xE78F4936
	Offset: 0x3C8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("controllable_spider", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: controllable_spider
	Checksum: 0x3157F87D
	Offset: 0x408
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	register_clientfields();
	zm_placeable_mine::add_mine_type("controllable_spider", &"");
	callback::on_spawned(&function_b2a01f79);
	level.w_controllable_spider = getweapon("controllable_spider");
	level flag::init("controllable_spider_equipped");
	/#
		function_be10e0f1();
	#/
}

/*
	Name: register_clientfields
	Namespace: controllable_spider
	Checksum: 0x13E990C3
	Offset: 0x4C0
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("scriptmover", "player_cocooned_fx", 9000, 1, "int");
	clientfield::register("allplayers", "player_cocooned_fx", 9000, 1, "int");
	clientfield::register("clientuimodel", "hudItems.showDpadRight_Spider", 9000, 1, "int");
}

/*
	Name: function_468b927
	Namespace: controllable_spider
	Checksum: 0x4BA0B3CC
	Offset: 0x560
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_468b927()
{
	if(!self hasweapon(level.w_controllable_spider))
	{
		self thread zm_placeable_mine::setup_for_player(level.w_controllable_spider, "hudItems.showDpadRight_Spider");
		self givemaxammo(level.w_controllable_spider);
		level thread function_160ff11f();
	}
}

/*
	Name: function_160ff11f
	Namespace: controllable_spider
	Checksum: 0xDD4C70F8
	Offset: 0x5F0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_160ff11f()
{
	if(!level flag::get("controllable_spider_equipped"))
	{
		level flag::set("controllable_spider_equipped");
		level.zone_occupied_func = &function_84313596;
		level.closest_player_targets_override = &closest_player_targets_override;
		level.get_closest_valid_player_override = &closest_player_targets_override;
	}
}

/*
	Name: function_b2a01f79
	Namespace: controllable_spider
	Checksum: 0xAFA161F7
	Offset: 0x688
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function function_b2a01f79()
{
	self endon(#"disconnect");
	var_97cffdb4 = "zone_bunker_interior_elevator";
	var_be85f81a = "zone_bunker_prison_entrance";
	while(true)
	{
		self waittill(#"weapon_change", w_current, w_previous);
		if(w_current === level.w_controllable_spider)
		{
			if(!ispointonnavmesh(self.origin) || (isdefined(self.var_b0329be9) && self.var_b0329be9) || !self isonground())
			{
				self switchtoweaponimmediate(w_previous);
				wait(0.05);
			}
			else
			{
				if(var_97cffdb4 === self zm_utility::get_current_zone() || (var_be85f81a === self zm_utility::get_current_zone() && level flag::get("elevator_in_use")))
				{
					self switchtoweaponimmediate(w_previous);
					wait(0.05);
				}
				else
				{
					n_ammo = self getammocount(level.w_controllable_spider);
					if(n_ammo <= 0)
					{
						continue;
					}
					n_ammo--;
					self setweaponammoclip(level.w_controllable_spider, n_ammo);
					self thread function_40296c9b(w_previous);
					self waittill(#"hash_6181e737");
				}
			}
		}
	}
}

/*
	Name: function_40296c9b
	Namespace: controllable_spider
	Checksum: 0xB7D4824
	Offset: 0x880
	Size: 0x2EC
	Parameters: 1
	Flags: Linked
*/
function function_40296c9b(w_previous)
{
	self notify(#"player_used_controllable_spider");
	var_cbe49ee = util::spawn_model("p7_zm_isl_cocoon_standing", self.origin, self.angles);
	var_cbe49ee clientfield::set("player_cocooned_fx", 1);
	self.var_cbe49ee = var_cbe49ee;
	e_spawner = getent("friendly_spider_spawner", "targetname");
	ai = zombie_utility::spawn_zombie(e_spawner);
	ai.origin = self.origin;
	ai.angles = self.angles;
	ai.am_i_valid = 1;
	ai thread player::last_valid_position();
	ai thread function_5ce6002e(self, w_previous);
	ai thread function_4e8bb77d();
	ai thread function_cb196021();
	ai usevehicle(self, 0);
	self freezecontrols(1);
	self lui::screen_fade_out(0.25);
	self.var_59bd3c5a = ai;
	self.old_origin = self.origin;
	self.old_angles = self.angles;
	self lui::screen_fade_in(0.25);
	self hide();
	self notsolid();
	self setplayercollision(0);
	self enableinvulnerability();
	self freezecontrols(0);
	self thread function_a21f0b74();
	self thread zm_equipment::show_hint_text(&"ZM_ISLAND_SPIDER_SELF_DESTRUCT", 4);
	self.dontspeak = 1;
	self clientfield::set_to_player("isspeaking", 1);
}

/*
	Name: function_5ce6002e
	Namespace: controllable_spider
	Checksum: 0x48C09DAC
	Offset: 0xB78
	Size: 0x2D4
	Parameters: 2
	Flags: Linked
*/
function function_5ce6002e(e_player, w_previous)
{
	e_player endon(#"disconnect");
	self waittill(#"death");
	var_cbe49ee = e_player.var_cbe49ee;
	e_player freezecontrols(1);
	e_player.ignoreme = 1;
	wait(1);
	e_player lui::screen_fade_out(0.25);
	self notify(#"stop_last_valid_position");
	self notify(#"exit_vehicle");
	e_player clientfield::set("player_cocooned_fx", 1);
	var_cbe49ee hide();
	e_player lui::screen_fade_in(0.25);
	e_player thread function_5a1c08d0();
	var_f1c825f6 = getclosestpointonnavmesh(e_player.old_origin, 1000, 15);
	e_player.var_59bd3c5a = undefined;
	e_player freezecontrols(0);
	e_player unlink();
	e_player show();
	e_player solid();
	e_player setplayercollision(1);
	e_player disableinvulnerability();
	e_player setorigin(var_f1c825f6);
	e_player.angles = e_player.old_angles;
	e_player switchtoweaponimmediate(w_previous);
	e_player.ignoreme = 0;
	while(true)
	{
		e_player waittill(#"weapon_change", w_current);
		if(w_current == w_previous)
		{
			break;
		}
	}
	e_player waittill(#"weapon_change_complete");
	e_player notify(#"hash_6181e737");
	e_player.dontspeak = 0;
	e_player clientfield::set_to_player("isspeaking", 0);
}

/*
	Name: function_5a1c08d0
	Namespace: controllable_spider
	Checksum: 0x779E8A76
	Offset: 0xE58
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_5a1c08d0()
{
	var_cbe49ee = self.var_cbe49ee;
	wait(1);
	var_cbe49ee delete();
}

/*
	Name: function_4e8bb77d
	Namespace: controllable_spider
	Checksum: 0xC7052B69
	Offset: 0xE98
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_4e8bb77d()
{
	self endon(#"death");
	wait(60);
	self dodamage(self.health + 1000, self.origin);
}

/*
	Name: function_cb196021
	Namespace: controllable_spider
	Checksum: 0xDE2055FF
	Offset: 0xEE0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_cb196021()
{
	self endon(#"death");
	if(level.round_number <= 30)
	{
		self.health = 200 * level.round_number;
	}
	else
	{
		self.health = 6000;
	}
}

/*
	Name: function_a21f0b74
	Namespace: controllable_spider
	Checksum: 0x5A1E50BA
	Offset: 0xF30
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_a21f0b74()
{
	self.var_59bd3c5a endon(#"death");
	self endon(#"disconnect");
	while(true)
	{
		if(self util::use_button_held())
		{
			self.var_59bd3c5a setteam("axis");
			self.var_59bd3c5a.takedamage = 1;
			self.var_59bd3c5a.owner = undefined;
			self.var_59bd3c5a dodamage(self.var_59bd3c5a.health + 1000, self.var_59bd3c5a.origin);
			return;
		}
		wait(0.05);
	}
}

/*
	Name: function_e889b7
	Namespace: controllable_spider
	Checksum: 0x4B3CE5F6
	Offset: 0x1008
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function function_e889b7()
{
	self endon(#"disconnect");
	level waittill(#"between_round_over");
	n_ammo = self getammocount(level.w_controllable_spider);
	if(n_ammo <= 0)
	{
		n_ammo++;
		self setweaponammoclip(level.w_controllable_spider, n_ammo);
	}
}

/*
	Name: function_84313596
	Namespace: controllable_spider
	Checksum: 0x5284B66F
	Offset: 0x1090
	Size: 0x1A6
	Parameters: 1
	Flags: Linked
*/
function function_84313596(zone_name)
{
	if(!zm_zonemgr::zone_is_enabled(zone_name))
	{
		return false;
	}
	zone = level.zones[zone_name];
	for(i = 0; i < zone.volumes.size; i++)
	{
		players = getplayers();
		for(j = 0; j < players.size; j++)
		{
			if(isdefined(players[j].var_59bd3c5a))
			{
				if(players[j].var_59bd3c5a istouching(zone.volumes[i]) && !players[j].var_59bd3c5a.sessionstate === "spectator")
				{
					return true;
				}
				continue;
			}
			if(players[j] istouching(zone.volumes[i]) && !players[j].sessionstate == "spectator")
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: closest_player_targets_override
	Namespace: controllable_spider
	Checksum: 0xA4649D13
	Offset: 0x1240
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function closest_player_targets_override()
{
	a_targets = getplayers();
	for(i = 0; i < a_targets.size; i++)
	{
		if(isdefined(a_targets[i].var_59bd3c5a))
		{
			a_targets[i] = a_targets[i].var_59bd3c5a;
		}
	}
	return a_targets;
}

/*
	Name: function_be10e0f1
	Namespace: controllable_spider
	Checksum: 0xE3F94B9
	Offset: 0x12D0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_be10e0f1()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_11949f35);
		adddebugcommand("");
	#/
}

/*
	Name: function_11949f35
	Namespace: controllable_spider
	Checksum: 0x5CD8EFE9
	Offset: 0x1320
	Size: 0xB8
	Parameters: 1
	Flags: Linked
*/
function function_11949f35(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				foreach(player in level.players)
				{
					player thread function_468b927();
				}
				return true;
			}
		}
		return false;
	#/
}

