// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;

#namespace aat;

/*
	Name: __init__sytem__
	Namespace: aat
	Checksum: 0x76876137
	Offset: 0x1F0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("aat", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: aat
	Checksum: 0xBB1B5306
	Offset: 0x238
	Size: 0x1BC
	Parameters: 0
	Flags: Linked, Private
*/
function private __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	level.aat_initializing = 1;
	level.aat = [];
	level.aat["none"] = spawnstruct();
	level.aat["none"].name = "none";
	level.aat_reroll = [];
	callback::on_connect(&on_player_connect);
	spawners = getspawnerarray();
	foreach(spawner in spawners)
	{
		spawner spawner::add_spawn_function(&aat_cooldown_init);
	}
	level.aat_exemptions = [];
	zm::register_vehicle_damage_callback(&aat_vehicle_damage_monitor);
	callback::on_finalize_initialization(&finalize_clientfields);
	/#
		level thread setup_devgui();
	#/
}

/*
	Name: __main__
	Namespace: aat
	Checksum: 0x8A25A474
	Offset: 0x400
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	zm::register_zombie_damage_override_callback(&aat_response);
}

/*
	Name: on_player_connect
	Namespace: aat
	Checksum: 0x4DFE6E68
	Offset: 0x448
	Size: 0xD8
	Parameters: 0
	Flags: Linked, Private
*/
function private on_player_connect()
{
	self.aat = [];
	self.aat_cooldown_start = [];
	keys = getarraykeys(level.aat);
	foreach(key in keys)
	{
		self.aat_cooldown_start[key] = 0;
	}
	self thread watch_weapon_changes();
	/#
	#/
}

/*
	Name: setup_devgui
	Namespace: aat
	Checksum: 0x6F2A47F7
	Offset: 0x528
	Size: 0x184
	Parameters: 0
	Flags: Linked, Private
*/
function private setup_devgui()
{
	/#
		waittillframeend();
		setdvar("", "");
		aat_devgui_base = "";
		keys = getarraykeys(level.aat);
		foreach(key in keys)
		{
			if(key != "")
			{
				adddebugcommand((((((aat_devgui_base + key) + "") + "") + "") + key) + "");
			}
		}
		adddebugcommand(((((aat_devgui_base + "") + "") + "") + "") + "");
		level thread aat_devgui_think();
	#/
}

/*
	Name: aat_devgui_think
	Namespace: aat
	Checksum: 0x249169AE
	Offset: 0x6B8
	Size: 0x158
	Parameters: 0
	Flags: Linked, Private
*/
function private aat_devgui_think()
{
	/#
		for(;;)
		{
			aat_name = getdvarstring("");
			if(aat_name != "")
			{
				for(i = 0; i < level.players.size; i++)
				{
					if(aat_name == "")
					{
						level.players[i] thread remove(level.players[i] getcurrentweapon());
					}
					else
					{
						level.players[i] thread acquire(level.players[i] getcurrentweapon(), aat_name);
					}
					level.players[i] thread aat_set_debug_text(aat_name, 0, 0, 0);
				}
			}
			setdvar("", "");
			wait(0.5);
		}
	#/
}

/*
	Name: aat_debug_text_display_init
	Namespace: aat
	Checksum: 0x516DC590
	Offset: 0x818
	Size: 0x15C
	Parameters: 0
	Flags: Private
*/
function private aat_debug_text_display_init()
{
	/#
		self.aat_debug_text = newclienthudelem(self);
		self.aat_debug_text.elemtype = "";
		self.aat_debug_text.font = "";
		self.aat_debug_text.fontscale = 1.8;
		self.aat_debug_text.horzalign = "";
		self.aat_debug_text.vertalign = "";
		self.aat_debug_text.alignx = "";
		self.aat_debug_text.aligny = "";
		self.aat_debug_text.x = 15;
		self.aat_debug_text.y = 15;
		self.aat_debug_text.sort = 2;
		self.aat_debug_text.color = (1, 1, 1);
		self.aat_debug_text.alpha = 1;
		self.aat_debug_text.hidewheninmenu = 1;
		self thread aat_debug_text_display_monitor();
	#/
}

/*
	Name: aat_debug_text_display_monitor
	Namespace: aat
	Checksum: 0x7B8DE09D
	Offset: 0x980
	Size: 0x90
	Parameters: 0
	Flags: Linked, Private
*/
function private aat_debug_text_display_monitor()
{
	/#
		self endon(#"disconnect");
		while(true)
		{
			self waittill(#"weapon_change", weapon);
			name = "";
			if(isdefined(self.aat[weapon]))
			{
				name = self.aat[weapon];
			}
			self thread aat_set_debug_text(name, 0, 0, 0);
		}
	#/
}

/*
	Name: aat_set_debug_text
	Namespace: aat
	Checksum: 0x7EAA0364
	Offset: 0xA18
	Size: 0x1F4
	Parameters: 4
	Flags: Linked, Private
*/
function private aat_set_debug_text(name, success, success_reroll, fail)
{
	/#
		self notify(#"aat_set_debug_text_thread");
		self endon(#"aat_set_debug_text_thread");
		self endon(#"disconnect");
		if(!isdefined(self.aat_debug_text))
		{
			return;
		}
		percentage = "";
		if(isdefined(level.aat[name]) && name != "")
		{
			percentage = level.aat[name].percentage;
		}
		self.aat_debug_text fadeovertime(0.05);
		self.aat_debug_text.alpha = 1;
		self.aat_debug_text settext((("" + name) + "") + percentage);
		if(success)
		{
			self.aat_debug_text.color = (0, 1, 0);
		}
		else
		{
			if(success_reroll)
			{
				self.aat_debug_text.color = vectorscale((1, 0, 1), 0.8);
			}
			else
			{
				if(fail)
				{
					self.aat_debug_text.color = (1, 0, 0);
				}
				else
				{
					self.aat_debug_text.color = (1, 1, 1);
				}
			}
		}
		wait(1);
		self.aat_debug_text fadeovertime(1);
		self.aat_debug_text.color = (1, 1, 1);
		if("" == name)
		{
			self.aat_debug_text.alpha = 0;
		}
	#/
}

/*
	Name: aat_cooldown_init
	Namespace: aat
	Checksum: 0x9C126700
	Offset: 0xC18
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function aat_cooldown_init()
{
	self.aat_cooldown_start = [];
	keys = getarraykeys(level.aat);
	foreach(key in keys)
	{
		self.aat_cooldown_start[key] = 0;
	}
}

/*
	Name: aat_vehicle_damage_monitor
	Namespace: aat
	Checksum: 0x9E699FB9
	Offset: 0xCD8
	Size: 0x100
	Parameters: 15
	Flags: Linked, Private
*/
function private aat_vehicle_damage_monitor(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	willbekilled = (self.health - idamage) <= 0;
	if(isdefined(level.aat_in_use) && level.aat_in_use)
	{
		self thread aat_response(willbekilled, einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, damagefromunderneath, vsurfacenormal);
	}
	return idamage;
}

/*
	Name: get_nonalternate_weapon
	Namespace: aat
	Checksum: 0x8503CB0E
	Offset: 0xDE0
	Size: 0x38
	Parameters: 1
	Flags: Linked
*/
function get_nonalternate_weapon(weapon)
{
	if(isdefined(weapon) && weapon.isaltmode)
	{
		return weapon.altweapon;
	}
	return weapon;
}

/*
	Name: aat_response
	Namespace: aat
	Checksum: 0x2031490D
	Offset: 0xE20
	Size: 0x5FC
	Parameters: 13
	Flags: Linked
*/
function aat_response(death, inflictor, attacker, damage, flags, mod, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(!isplayer(attacker))
	{
		return;
	}
	if(mod != "MOD_PISTOL_BULLET" && mod != "MOD_RIFLE_BULLET" && mod != "MOD_GRENADE" && mod != "MOD_PROJECTILE" && mod != "MOD_EXPLOSIVE" && mod != "MOD_IMPACT")
	{
		return;
	}
	weapon = get_nonalternate_weapon(weapon);
	name = attacker.aat[weapon];
	if(!isdefined(name))
	{
		return;
	}
	if(death && !level.aat[name].occurs_on_death)
	{
		return;
	}
	if(!isdefined(self.archetype))
	{
		return;
	}
	if(isdefined(level.aat[name].immune_trigger[self.archetype]) && level.aat[name].immune_trigger[self.archetype])
	{
		return;
	}
	now = gettime() / 1000;
	if(now <= (self.aat_cooldown_start[name] + level.aat[name].cooldown_time_entity))
	{
		return;
	}
	if(now <= (attacker.aat_cooldown_start[name] + level.aat[name].cooldown_time_attacker))
	{
		return;
	}
	if(now <= (level.aat[name].cooldown_time_global_start + level.aat[name].cooldown_time_global))
	{
		return;
	}
	if(isdefined(level.aat[name].validation_func))
	{
		if(!self [[level.aat[name].validation_func]]())
		{
			return;
		}
	}
	success = 0;
	reroll_icon = undefined;
	percentage = level.aat[name].percentage;
	/#
		aat_percentage_override = getdvarfloat("");
		if(aat_percentage_override > 0)
		{
			percentage = aat_percentage_override;
		}
	#/
	if(percentage >= randomfloat(1))
	{
		success = 1;
		attacker thread aat_set_debug_text(name, 1, 0, 0);
	}
	if(!success)
	{
		keys = getarraykeys(level.aat_reroll);
		keys = array::randomize(keys);
		foreach(key in keys)
		{
			if(attacker [[level.aat_reroll[key].active_func]]())
			{
				for(i = 0; i < level.aat_reroll[key].count; i++)
				{
					if(percentage >= randomfloat(1))
					{
						success = 1;
						reroll_icon = level.aat_reroll[key].damage_feedback_icon;
						attacker thread aat_set_debug_text(name, 0, 1, 0);
						break;
					}
				}
			}
			if(success)
			{
				break;
			}
		}
	}
	if(!success)
	{
		attacker thread aat_set_debug_text(name, 0, 0, 1);
		return;
	}
	level.aat[name].cooldown_time_global_start = now;
	attacker.aat_cooldown_start[name] = now;
	self thread [[level.aat[name].result_func]](death, attacker, mod, weapon);
	attacker thread damagefeedback::update_override(level.aat[name].damage_feedback_icon, level.aat[name].damage_feedback_sound, reroll_icon);
}

/*
	Name: register
	Namespace: aat
	Checksum: 0x412B79F4
	Offset: 0x1428
	Size: 0x5E8
	Parameters: 10
	Flags: Linked
*/
function register(name, percentage, cooldown_time_entity, cooldown_time_attacker, cooldown_time_global, occurs_on_death, result_func, damage_feedback_icon, damage_feedback_sound, validation_func)
{
	/#
		assert(isdefined(level.aat_initializing) && level.aat_initializing, "");
	#/
	/#
		assert(isdefined(name), "");
	#/
	/#
		assert("" != name, ("" + "") + "");
	#/
	/#
		assert(!isdefined(level.aat[name]), ("" + name) + "");
	#/
	/#
		assert(isdefined(percentage), ("" + name) + "");
	#/
	/#
		assert(0 <= percentage && 1 > percentage, ("" + name) + "");
	#/
	/#
		assert(isdefined(cooldown_time_entity), ("" + name) + "");
	#/
	/#
		assert(0 <= cooldown_time_entity, ("" + name) + "");
	#/
	/#
		assert(isdefined(cooldown_time_entity), ("" + name) + "");
	#/
	/#
		assert(0 <= cooldown_time_entity, ("" + name) + "");
	#/
	/#
		assert(isdefined(cooldown_time_global), ("" + name) + "");
	#/
	/#
		assert(0 <= cooldown_time_global, ("" + name) + "");
	#/
	/#
		assert(isdefined(occurs_on_death), ("" + name) + "");
	#/
	/#
		assert(isdefined(result_func), ("" + name) + "");
	#/
	/#
		assert(isdefined(damage_feedback_icon), ("" + name) + "");
	#/
	/#
		assert(isstring(damage_feedback_icon), ("" + name) + "");
	#/
	/#
		assert(isdefined(damage_feedback_sound), ("" + name) + "");
	#/
	/#
		assert(isstring(damage_feedback_sound), ("" + name) + "");
	#/
	level.aat[name] = spawnstruct();
	level.aat[name].name = name;
	level.aat[name].var_2c8ee667 = hashstring(name);
	level.aat[name].percentage = percentage;
	level.aat[name].cooldown_time_entity = cooldown_time_entity;
	level.aat[name].cooldown_time_attacker = cooldown_time_attacker;
	level.aat[name].cooldown_time_global = cooldown_time_global;
	level.aat[name].cooldown_time_global_start = 0;
	level.aat[name].occurs_on_death = occurs_on_death;
	level.aat[name].result_func = result_func;
	level.aat[name].damage_feedback_icon = damage_feedback_icon;
	level.aat[name].damage_feedback_sound = damage_feedback_sound;
	level.aat[name].validation_func = validation_func;
	level.aat[name].immune_trigger = [];
	level.aat[name].immune_result_direct = [];
	level.aat[name].immune_result_indirect = [];
}

/*
	Name: register_immunity
	Namespace: aat
	Checksum: 0x37AAA5CD
	Offset: 0x1A18
	Size: 0x21E
	Parameters: 5
	Flags: Linked
*/
function register_immunity(name, archetype, immune_trigger, immune_result_direct, immune_result_indirect)
{
	while(level.aat_initializing !== 0)
	{
		wait(0.05);
	}
	/#
		assert(isdefined(name), "");
	#/
	/#
		assert(isdefined(archetype), "");
	#/
	/#
		assert(isdefined(immune_trigger), "");
	#/
	/#
		assert(isdefined(immune_result_direct), "");
	#/
	/#
		assert(isdefined(immune_result_indirect), "");
	#/
	if(!isdefined(level.aat[name].immune_trigger))
	{
		level.aat[name].immune_trigger = [];
	}
	if(!isdefined(level.aat[name].immune_result_direct))
	{
		level.aat[name].immune_result_direct = [];
	}
	if(!isdefined(level.aat[name].immune_result_indirect))
	{
		level.aat[name].immune_result_indirect = [];
	}
	level.aat[name].immune_trigger[archetype] = immune_trigger;
	level.aat[name].immune_result_direct[archetype] = immune_result_direct;
	level.aat[name].immune_result_indirect[archetype] = immune_result_indirect;
}

/*
	Name: finalize_clientfields
	Namespace: aat
	Checksum: 0x6B9ED8D1
	Offset: 0x1C40
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function finalize_clientfields()
{
	/#
		println("");
	#/
	if(level.aat.size > 1)
	{
		array::alphabetize(level.aat);
		i = 0;
		foreach(aat in level.aat)
		{
			aat.clientfield_index = i;
			i++;
			/#
				println("" + aat.name);
			#/
		}
		n_bits = getminbitcountfornum(level.aat.size - 1);
		clientfield::register("toplayer", "aat_current", 1, n_bits, "int");
	}
	level.aat_initializing = 0;
}

/*
	Name: register_aat_exemption
	Namespace: aat
	Checksum: 0xD31EFC16
	Offset: 0x1DC8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function register_aat_exemption(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	level.aat_exemptions[weapon] = 1;
}

/*
	Name: is_exempt_weapon
	Namespace: aat
	Checksum: 0xFC2A3A52
	Offset: 0x1E10
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function is_exempt_weapon(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	return isdefined(level.aat_exemptions[weapon]);
}

/*
	Name: register_reroll
	Namespace: aat
	Checksum: 0xC6AF835A
	Offset: 0x1E50
	Size: 0x264
	Parameters: 4
	Flags: Linked
*/
function register_reroll(name, count, active_func, damage_feedback_icon)
{
	/#
		assert(isdefined(name), "");
	#/
	/#
		assert("" != name, ("" + "") + "");
	#/
	/#
		assert(!isdefined(level.aat[name]), ("" + name) + "");
	#/
	/#
		assert(isdefined(count), ("" + name) + "");
	#/
	/#
		assert(0 < count, ("" + name) + "");
	#/
	/#
		assert(isdefined(active_func), ("" + name) + "");
	#/
	/#
		assert(isdefined(damage_feedback_icon), ("" + name) + "");
	#/
	/#
		assert(isstring(damage_feedback_icon), ("" + name) + "");
	#/
	level.aat_reroll[name] = spawnstruct();
	level.aat_reroll[name].name = name;
	level.aat_reroll[name].count = count;
	level.aat_reroll[name].active_func = active_func;
	level.aat_reroll[name].damage_feedback_icon = damage_feedback_icon;
}

/*
	Name: getaatonweapon
	Namespace: aat
	Checksum: 0xCD56BAF7
	Offset: 0x20C0
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function getaatonweapon(weapon)
{
	weapon = get_nonalternate_weapon(weapon);
	if(weapon == level.weaponnone || (!(isdefined(level.aat_in_use) && level.aat_in_use)) || is_exempt_weapon(weapon) || (!isdefined(self.aat) || !isdefined(self.aat[weapon])) || !isdefined(level.aat[self.aat[weapon]]))
	{
		return undefined;
	}
	return level.aat[self.aat[weapon]];
}

/*
	Name: acquire
	Namespace: aat
	Checksum: 0x35532001
	Offset: 0x2188
	Size: 0x25C
	Parameters: 2
	Flags: Linked
*/
function acquire(weapon, name)
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	/#
		assert(isdefined(weapon), "");
	#/
	/#
		assert(weapon != level.weaponnone, "");
	#/
	weapon = get_nonalternate_weapon(weapon);
	if(is_exempt_weapon(weapon))
	{
		return;
	}
	if(isdefined(name))
	{
		/#
			assert("" != name, ("" + "") + "");
		#/
		/#
			assert(isdefined(level.aat[name]), ("" + name) + "");
		#/
		self.aat[weapon] = name;
	}
	else
	{
		keys = getarraykeys(level.aat);
		arrayremovevalue(keys, "none");
		if(isdefined(self.aat[weapon]))
		{
			arrayremovevalue(keys, self.aat[weapon]);
		}
		rand = randomint(keys.size);
		self.aat[weapon] = keys[rand];
	}
	if(weapon == self getcurrentweapon())
	{
		self clientfield::set_to_player("aat_current", level.aat[self.aat[weapon]].clientfield_index);
	}
}

/*
	Name: remove
	Namespace: aat
	Checksum: 0x27EB2834
	Offset: 0x23F0
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function remove(weapon)
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	/#
		assert(isdefined(weapon), "");
	#/
	/#
		assert(weapon != level.weaponnone, "");
	#/
	weapon = get_nonalternate_weapon(weapon);
	self.aat[weapon] = undefined;
}

/*
	Name: watch_weapon_changes
	Namespace: aat
	Checksum: 0xD8E52F7B
	Offset: 0x24A0
	Size: 0xC8
	Parameters: 0
	Flags: Linked
*/
function watch_weapon_changes()
{
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	while(isdefined(self))
	{
		self waittill(#"weapon_change", weapon);
		weapon = get_nonalternate_weapon(weapon);
		name = "none";
		if(isdefined(self.aat[weapon]))
		{
			name = self.aat[weapon];
		}
		self clientfield::set_to_player("aat_current", level.aat[name].clientfield_index);
	}
}

