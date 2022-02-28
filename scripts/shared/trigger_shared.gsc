// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace trigger;

/*
	Name: __init__sytem__
	Namespace: trigger
	Checksum: 0x382CAAEF
	Offset: 0x3E0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("trigger", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: trigger
	Checksum: 0x1BD073AB
	Offset: 0x420
	Size: 0x6A8
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.fog_trigger_current = undefined;
	level.trigger_hint_string = [];
	level.trigger_hint_func = [];
	if(!isdefined(level.trigger_flags))
	{
		init_flags();
	}
	trigger_funcs = [];
	trigger_funcs["trigger_unlock"] = &trigger_unlock;
	trigger_funcs["flag_set"] = &flag_set_trigger;
	trigger_funcs["flag_clear"] = &flag_clear_trigger;
	trigger_funcs["flag_set_touching"] = &flag_set_touching;
	trigger_funcs["friendly_respawn_trigger"] = &friendly_respawn_trigger;
	trigger_funcs["friendly_respawn_clear"] = &friendly_respawn_clear;
	trigger_funcs["trigger_delete"] = &trigger_turns_off;
	trigger_funcs["trigger_delete_on_touch"] = &trigger_delete_on_touch;
	trigger_funcs["trigger_off"] = &trigger_turns_off;
	trigger_funcs["delete_link_chain"] = &delete_link_chain;
	trigger_funcs["no_crouch_or_prone"] = &no_crouch_or_prone_think;
	trigger_funcs["no_prone"] = &no_prone_think;
	trigger_funcs["flood_spawner"] = &spawner::flood_trigger_think;
	trigger_funcs["trigger_spawner"] = &trigger_spawner;
	trigger_funcs["trigger_hint"] = &trigger_hint;
	trigger_funcs["exploder"] = &trigger_exploder;
	foreach(trig in get_all("trigger_radius", "trigger_multiple", "trigger_once", "trigger_box"))
	{
		if(isdefined(trig.spawnflags) && (trig.spawnflags & 256) == 256)
		{
			level thread trigger_look(trig);
		}
	}
	foreach(trig in get_all())
	{
		/#
			trig check_spawnflags();
		#/
		if(trig.classname != "trigger_damage")
		{
			if(trig.classname != "trigger_hurt")
			{
				if(isdefined(trig.spawnflags) && (trig.spawnflags & 32) == 32)
				{
					level thread trigger_spawner(trig);
				}
			}
		}
		if(trig.classname != "trigger_once" && is_trigger_once(trig))
		{
			level thread trigger_once(trig);
		}
		if(isdefined(trig.script_flag_true))
		{
			level thread script_flag_true_trigger(trig);
		}
		if(isdefined(trig.script_flag_set))
		{
			level thread flag_set_trigger(trig, trig.script_flag_set);
		}
		if(isdefined(trig.script_flag_set_on_touching) || isdefined(trig.script_flag_set_on_cleared))
		{
			level thread script_flag_set_touching(trig);
		}
		if(isdefined(trig.script_flag_clear))
		{
			level thread flag_clear_trigger(trig, trig.script_flag_clear);
		}
		if(isdefined(trig.script_flag_false))
		{
			level thread script_flag_false_trigger(trig);
		}
		if(isdefined(trig.script_trigger_group))
		{
			trig thread trigger_group();
		}
		if(isdefined(trig.script_notify))
		{
			level thread trigger_notify(trig, trig.script_notify);
		}
		if(isdefined(trig.script_fallback))
		{
			level thread spawner::fallback_think(trig);
		}
		if(isdefined(trig.script_killspawner))
		{
			level thread kill_spawner_trigger(trig);
		}
		if(isdefined(trig.targetname))
		{
			if(isdefined(trigger_funcs[trig.targetname]))
			{
				level thread [[trigger_funcs[trig.targetname]]](trig);
			}
		}
	}
}

/*
	Name: check_spawnflags
	Namespace: trigger
	Checksum: 0xD35D35AB
	Offset: 0xAD0
	Size: 0xCE
	Parameters: 0
	Flags: Linked
*/
function check_spawnflags()
{
}

/*
	Name: trigger_unlock
	Namespace: trigger
	Checksum: 0xC5736642
	Offset: 0xBA8
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function trigger_unlock(trigger)
{
	noteworthy = "not_set";
	if(isdefined(trigger.script_noteworthy))
	{
		noteworthy = trigger.script_noteworthy;
	}
	target_triggers = getentarray(trigger.target, "targetname");
	trigger thread trigger_unlock_death(trigger.target);
	while(true)
	{
		array::run_all(target_triggers, &triggerenable, 0);
		trigger waittill(#"trigger");
		array::run_all(target_triggers, &triggerenable, 1);
		wait_for_an_unlocked_trigger(target_triggers, noteworthy);
		array::notify_all(target_triggers, "relock");
	}
}

/*
	Name: trigger_unlock_death
	Namespace: trigger
	Checksum: 0x54BDFE14
	Offset: 0xCE0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function trigger_unlock_death(target)
{
	self waittill(#"death");
	target_triggers = getentarray(target, "targetname");
	array::run_all(target_triggers, &triggerenable, 0);
}

/*
	Name: wait_for_an_unlocked_trigger
	Namespace: trigger
	Checksum: 0xDD915932
	Offset: 0xD50
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function wait_for_an_unlocked_trigger(triggers, noteworthy)
{
	level endon("unlocked_trigger_hit" + noteworthy);
	ent = spawnstruct();
	for(i = 0; i < triggers.size; i++)
	{
		triggers[i] thread report_trigger(ent, noteworthy);
	}
	ent waittill(#"trigger");
	level notify("unlocked_trigger_hit" + noteworthy);
}

/*
	Name: report_trigger
	Namespace: trigger
	Checksum: 0xC11723AB
	Offset: 0xE08
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function report_trigger(ent, noteworthy)
{
	self endon(#"relock");
	level endon("unlocked_trigger_hit" + noteworthy);
	self waittill(#"trigger");
	ent notify(#"trigger");
}

/*
	Name: get_trigger_look_target
	Namespace: trigger
	Checksum: 0xAD36B5F5
	Offset: 0xE60
	Size: 0x200
	Parameters: 0
	Flags: Linked
*/
function get_trigger_look_target()
{
	if(isdefined(self.target))
	{
		a_potential_targets = getentarray(self.target, "targetname");
		a_targets = [];
		foreach(target in a_potential_targets)
		{
			if(target.classname === "script_origin")
			{
				if(!isdefined(a_targets))
				{
					a_targets = [];
				}
				else if(!isarray(a_targets))
				{
					a_targets = array(a_targets);
				}
				a_targets[a_targets.size] = target;
			}
		}
		a_potential_target_structs = struct::get_array(self.target);
		a_targets = arraycombine(a_targets, a_potential_target_structs, 1, 0);
		if(a_targets.size > 0)
		{
			/#
				assert(a_targets.size == 1, ("" + self.origin) + "");
			#/
			e_target = a_targets[0];
		}
	}
	if(!isdefined(e_target))
	{
		e_target = self;
	}
	return e_target;
}

/*
	Name: trigger_look
	Namespace: trigger
	Checksum: 0xEE18704E
	Offset: 0x1068
	Size: 0x2C0
	Parameters: 1
	Flags: Linked
*/
function trigger_look(trigger)
{
	trigger endon(#"death");
	e_target = trigger get_trigger_look_target();
	if(isdefined(trigger.script_flag) && !isdefined(level.flag[trigger.script_flag]))
	{
		level flag::init(trigger.script_flag, undefined, 1);
	}
	a_parameters = [];
	if(isdefined(trigger.script_parameters))
	{
		a_parameters = strtok(trigger.script_parameters, ",; ");
	}
	b_ads_check = isinarray(a_parameters, "check_ads");
	while(true)
	{
		trigger waittill(#"trigger", e_other);
		if(isplayer(e_other))
		{
			while(isdefined(e_other) && e_other istouching(trigger))
			{
				if(e_other util::is_looking_at(e_target, trigger.script_dot, isdefined(trigger.script_trace) && trigger.script_trace) && (!b_ads_check || !e_other util::is_ads()))
				{
					trigger notify(#"trigger_look", e_other);
					if(isdefined(trigger.script_flag))
					{
						level flag::set(trigger.script_flag);
					}
				}
				else if(isdefined(trigger.script_flag))
				{
					level flag::clear(trigger.script_flag);
				}
				wait(0.05);
			}
			if(isdefined(trigger.script_flag))
			{
				level flag::clear(trigger.script_flag);
			}
		}
		else
		{
			/#
				assertmsg("");
			#/
		}
	}
}

/*
	Name: trigger_spawner
	Namespace: trigger
	Checksum: 0x72C17349
	Offset: 0x1330
	Size: 0x12A
	Parameters: 1
	Flags: Linked
*/
function trigger_spawner(trigger)
{
	a_spawners = getspawnerarray(trigger.target, "targetname");
	/#
		assert(a_spawners.size > 0, ("" + trigger.origin) + "");
	#/
	trigger endon(#"death");
	trigger wait_till();
	foreach(sp in a_spawners)
	{
		if(isdefined(sp))
		{
			sp thread trigger_spawner_spawn();
		}
	}
}

/*
	Name: trigger_spawner_spawn
	Namespace: trigger
	Checksum: 0xB21063D5
	Offset: 0x1468
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function trigger_spawner_spawn()
{
	self endon(#"death");
	self flag::script_flag_wait();
	self util::script_delay();
	self spawner::spawn();
}

/*
	Name: trigger_notify
	Namespace: trigger
	Checksum: 0xF2A9D991
	Offset: 0x14C8
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function trigger_notify(trigger, msg)
{
	trigger endon(#"death");
	other = trigger wait_till();
	if(isdefined(trigger.target))
	{
		a_target_ents = getentarray(trigger.target, "targetname");
		foreach(notify_ent in a_target_ents)
		{
			notify_ent notify(msg, other);
		}
	}
	level notify(msg, other);
}

/*
	Name: flag_set_trigger
	Namespace: trigger
	Checksum: 0x7B311F80
	Offset: 0x15E8
	Size: 0xF8
	Parameters: 2
	Flags: Linked
*/
function flag_set_trigger(trigger, str_flag)
{
	trigger endon(#"death");
	if(!isdefined(str_flag))
	{
		str_flag = trigger.script_flag;
	}
	if(!level flag::exists(str_flag))
	{
		level flag::init(str_flag, undefined, 1);
	}
	while(true)
	{
		trigger wait_till();
		if(isdefined(trigger.targetname) && trigger.targetname == "flag_set")
		{
			trigger util::script_delay();
		}
		level flag::set(str_flag);
	}
}

/*
	Name: flag_clear_trigger
	Namespace: trigger
	Checksum: 0x21CBD72B
	Offset: 0x16E8
	Size: 0xF8
	Parameters: 2
	Flags: Linked
*/
function flag_clear_trigger(trigger, str_flag)
{
	trigger endon(#"death");
	if(!isdefined(str_flag))
	{
		str_flag = trigger.script_flag;
	}
	if(!level flag::exists(str_flag))
	{
		level flag::init(str_flag, undefined, 1);
	}
	while(true)
	{
		trigger wait_till();
		if(isdefined(trigger.targetname) && trigger.targetname == "flag_clear")
		{
			trigger util::script_delay();
		}
		level flag::clear(str_flag);
	}
}

/*
	Name: add_tokens_to_trigger_flags
	Namespace: trigger
	Checksum: 0x4E202BB
	Offset: 0x17E8
	Size: 0x92
	Parameters: 1
	Flags: Linked
*/
function add_tokens_to_trigger_flags(tokens)
{
	for(i = 0; i < tokens.size; i++)
	{
		flag = tokens[i];
		if(!isdefined(level.trigger_flags[flag]))
		{
			level.trigger_flags[flag] = [];
		}
		level.trigger_flags[flag][level.trigger_flags[flag].size] = self;
	}
}

/*
	Name: script_flag_false_trigger
	Namespace: trigger
	Checksum: 0x8EB2322E
	Offset: 0x1888
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function script_flag_false_trigger(trigger)
{
	tokens = util::create_flags_and_return_tokens(trigger.script_flag_false);
	trigger add_tokens_to_trigger_flags(tokens);
	trigger update_based_on_flags();
}

/*
	Name: script_flag_true_trigger
	Namespace: trigger
	Checksum: 0x268A7E3F
	Offset: 0x1900
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function script_flag_true_trigger(trigger)
{
	tokens = util::create_flags_and_return_tokens(trigger.script_flag_true);
	trigger add_tokens_to_trigger_flags(tokens);
	trigger update_based_on_flags();
}

/*
	Name: friendly_respawn_trigger
	Namespace: trigger
	Checksum: 0x341EB30F
	Offset: 0x1978
	Size: 0x178
	Parameters: 1
	Flags: Linked
*/
function friendly_respawn_trigger(trigger)
{
	trigger endon(#"death");
	spawners = getentarray(trigger.target, "targetname");
	/#
		assert(spawners.size == 1, ("" + trigger.target) + "");
	#/
	spawner = spawners[0];
	/#
		assert(!isdefined(spawner.script_forcecolor), ("" + spawner.origin) + "");
	#/
	spawners = undefined;
	spawner endon(#"death");
	while(true)
	{
		trigger waittill(#"trigger");
		if(isdefined(trigger.script_forcecolor))
		{
			level.respawn_spawners_specific[trigger.script_forcecolor] = spawner;
		}
		else
		{
			level.respawn_spawner = spawner;
		}
		level flag::set("respawn_friendlies");
		wait(0.5);
	}
}

/*
	Name: friendly_respawn_clear
	Namespace: trigger
	Checksum: 0x3F0B2F06
	Offset: 0x1AF8
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function friendly_respawn_clear(trigger)
{
	trigger endon(#"death");
	while(true)
	{
		trigger waittill(#"trigger");
		level flag::clear("respawn_friendlies");
		wait(0.5);
	}
}

/*
	Name: trigger_turns_off
	Namespace: trigger
	Checksum: 0x1182BF94
	Offset: 0x1B58
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function trigger_turns_off(trigger)
{
	trigger wait_till();
	trigger triggerenable(0);
	if(!isdefined(trigger.script_linkto))
	{
		return;
	}
	tokens = strtok(trigger.script_linkto, " ");
	for(i = 0; i < tokens.size; i++)
	{
		array::run_all(getentarray(tokens[i], "script_linkname"), &triggerenable, 0);
	}
}

/*
	Name: script_flag_set_touching
	Namespace: trigger
	Checksum: 0xF9F49D54
	Offset: 0x1C50
	Size: 0x1D8
	Parameters: 1
	Flags: Linked
*/
function script_flag_set_touching(trigger)
{
	trigger endon(#"death");
	if(isdefined(trigger.script_flag_set_on_touching))
	{
		level flag::init(trigger.script_flag_set_on_touching, undefined, 1);
	}
	if(isdefined(trigger.script_flag_set_on_cleared))
	{
		level flag::init(trigger.script_flag_set_on_cleared, undefined, 1);
	}
	trigger thread _detect_touched();
	while(true)
	{
		trigger.script_touched = 0;
		wait(0.05);
		waittillframeend();
		if(!trigger.script_touched)
		{
			wait(0.05);
			waittillframeend();
		}
		if(trigger.script_touched)
		{
			if(isdefined(trigger.script_flag_set_on_touching))
			{
				level flag::set(trigger.script_flag_set_on_touching);
			}
			if(isdefined(trigger.script_flag_set_on_cleared))
			{
				level flag::clear(trigger.script_flag_set_on_cleared);
			}
		}
		else
		{
			if(isdefined(trigger.script_flag_set_on_touching))
			{
				level flag::clear(trigger.script_flag_set_on_touching);
			}
			if(isdefined(trigger.script_flag_set_on_cleared))
			{
				level flag::set(trigger.script_flag_set_on_cleared);
			}
		}
	}
}

/*
	Name: _detect_touched
	Namespace: trigger
	Checksum: 0x7C5EEF1F
	Offset: 0x1E30
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function _detect_touched()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"trigger");
		self.script_touched = 1;
	}
}

/*
	Name: trigger_delete_on_touch
	Namespace: trigger
	Checksum: 0x1BD21478
	Offset: 0x1E70
	Size: 0x50
	Parameters: 1
	Flags: Linked
*/
function trigger_delete_on_touch(trigger)
{
	while(true)
	{
		trigger waittill(#"trigger", other);
		if(isdefined(other))
		{
			other delete();
		}
	}
}

/*
	Name: flag_set_touching
	Namespace: trigger
	Checksum: 0x5DF9BEF3
	Offset: 0x1EC8
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function flag_set_touching(trigger)
{
	str_flag = trigger.script_flag;
	if(!isdefined(level.flag[str_flag]))
	{
		level flag::init(str_flag, undefined, 1);
	}
	while(true)
	{
		trigger waittill(#"trigger", other);
		level flag::set(str_flag);
		while(isalive(other) && other istouching(trigger) && isdefined(trigger))
		{
			wait(0.25);
		}
		level flag::clear(str_flag);
	}
}

/*
	Name: trigger_once
	Namespace: trigger
	Checksum: 0xD3332659
	Offset: 0x1FD0
	Size: 0xF4
	Parameters: 1
	Flags: Linked
*/
function trigger_once(trig)
{
	trig endon(#"death");
	if(is_look_trigger(trig))
	{
		trig waittill(#"trigger_look");
	}
	else
	{
		trig waittill(#"trigger");
	}
	waittillframeend();
	waittillframeend();
	if(isdefined(trig))
	{
		/#
			println("");
			println((("" + trig getentitynumber()) + "") + trig.origin);
			println("");
		#/
		trig delete();
	}
}

/*
	Name: trigger_hint
	Namespace: trigger
	Checksum: 0xF3289391
	Offset: 0x20D0
	Size: 0x174
	Parameters: 1
	Flags: Linked
*/
function trigger_hint(trigger)
{
	/#
		assert(isdefined(trigger.script_hint), ("" + trigger.origin) + "");
	#/
	trigger endon(#"death");
	if(!isdefined(level.displayed_hints))
	{
		level.displayed_hints = [];
	}
	waittillframeend();
	/#
		assert(isdefined(level.trigger_hint_string[trigger.script_hint]), ("" + trigger.script_hint) + "");
	#/
	trigger waittill(#"trigger", other);
	/#
		assert(isplayer(other), "");
	#/
	if(isdefined(level.displayed_hints[trigger.script_hint]))
	{
		return;
	}
	level.displayed_hints[trigger.script_hint] = 1;
	display_hint(trigger.script_hint);
}

/*
	Name: trigger_exploder
	Namespace: trigger
	Checksum: 0xAA1FC07C
	Offset: 0x2250
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function trigger_exploder(trigger)
{
	trigger endon(#"death");
	while(true)
	{
		trigger waittill(#"trigger");
		if(isdefined(trigger.target))
		{
			activateclientradiantexploder(trigger.target);
		}
	}
}

/*
	Name: display_hint
	Namespace: trigger
	Checksum: 0x8EA8BF47
	Offset: 0x22B8
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function display_hint(hint)
{
	if(getdvarstring("chaplincheat") == "1")
	{
		return;
	}
	if(isdefined(level.trigger_hint_func[hint]))
	{
		if([[level.trigger_hint_func[hint]]]())
		{
			return;
		}
		_hint_print(level.trigger_hint_string[hint], level.trigger_hint_func[hint]);
	}
	else
	{
		_hint_print(level.trigger_hint_string[hint]);
	}
}

/*
	Name: _hint_print
	Namespace: trigger
	Checksum: 0x7022DF29
	Offset: 0x2378
	Size: 0x394
	Parameters: 2
	Flags: Linked
*/
function _hint_print(string, breakfunc)
{
	level flag::wait_till_clear("global_hint_in_use");
	level flag::set("global_hint_in_use");
	hint = hud::createfontstring("objective", 2);
	hint.alpha = 0.9;
	hint.x = 0;
	hint.y = -68;
	hint.alignx = "center";
	hint.aligny = "middle";
	hint.horzalign = "center";
	hint.vertalign = "middle";
	hint.foreground = 0;
	hint.hidewhendead = 1;
	hint settext(string);
	hint.alpha = 0;
	hint fadeovertime(1);
	hint.alpha = 0.95;
	_hint_print_wait(1);
	if(isdefined(breakfunc))
	{
		for(;;)
		{
			hint fadeovertime(0.75);
			hint.alpha = 0.4;
			_hint_print_wait(0.75, breakfunc);
			if([[breakfunc]]())
			{
				break;
			}
			hint fadeovertime(0.75);
			hint.alpha = 0.95;
			_hint_print_wait(0.75);
			if([[breakfunc]]())
			{
				break;
			}
		}
	}
	else
	{
		for(i = 0; i < 5; i++)
		{
			hint fadeovertime(0.75);
			hint.alpha = 0.4;
			_hint_print_wait(0.75);
			hint fadeovertime(0.75);
			hint.alpha = 0.95;
			_hint_print_wait(0.75);
		}
	}
	hint destroy();
	level flag::clear("global_hint_in_use");
}

/*
	Name: _hint_print_wait
	Namespace: trigger
	Checksum: 0x8A4EF5C5
	Offset: 0x2718
	Size: 0x82
	Parameters: 2
	Flags: Linked
*/
function _hint_print_wait(length, breakfunc)
{
	if(!isdefined(breakfunc))
	{
		wait(length);
		return;
	}
	timer = length * 20;
	for(i = 0; i < timer; i++)
	{
		if([[breakfunc]]())
		{
			break;
		}
		wait(0.05);
	}
}

/*
	Name: get_all
	Namespace: trigger
	Checksum: 0xC998FA6D
	Offset: 0x27A8
	Size: 0x524
	Parameters: 9
	Flags: Linked
*/
function get_all(type1, type2, type3, type4, type5, type6, type7, type8, type9)
{
	if(!isdefined(type1))
	{
		type1 = "trigger_damage";
		type2 = "trigger_hurt";
		type3 = "trigger_lookat";
		type4 = "trigger_once";
		type5 = "trigger_radius";
		type6 = "trigger_use";
		type7 = "trigger_use_touch";
		type8 = "trigger_box";
		type9 = "trigger_multiple";
		type10 = "trigger_out_of_bounds";
	}
	/#
		assert(_is_valid_trigger_type(type1));
	#/
	trigs = getentarray(type1, "classname");
	if(isdefined(type2))
	{
		/#
			assert(_is_valid_trigger_type(type2));
		#/
		trigs = arraycombine(trigs, getentarray(type2, "classname"), 1, 0);
	}
	if(isdefined(type3))
	{
		/#
			assert(_is_valid_trigger_type(type3));
		#/
		trigs = arraycombine(trigs, getentarray(type3, "classname"), 1, 0);
	}
	if(isdefined(type4))
	{
		/#
			assert(_is_valid_trigger_type(type4));
		#/
		trigs = arraycombine(trigs, getentarray(type4, "classname"), 1, 0);
	}
	if(isdefined(type5))
	{
		/#
			assert(_is_valid_trigger_type(type5));
		#/
		trigs = arraycombine(trigs, getentarray(type5, "classname"), 1, 0);
	}
	if(isdefined(type6))
	{
		/#
			assert(_is_valid_trigger_type(type6));
		#/
		trigs = arraycombine(trigs, getentarray(type6, "classname"), 1, 0);
	}
	if(isdefined(type7))
	{
		/#
			assert(_is_valid_trigger_type(type7));
		#/
		trigs = arraycombine(trigs, getentarray(type7, "classname"), 1, 0);
	}
	if(isdefined(type8))
	{
		/#
			assert(_is_valid_trigger_type(type8));
		#/
		trigs = arraycombine(trigs, getentarray(type8, "classname"), 1, 0);
	}
	if(isdefined(type9))
	{
		/#
			assert(_is_valid_trigger_type(type9));
		#/
		trigs = arraycombine(trigs, getentarray(type9, "classname"), 1, 0);
	}
	if(isdefined(type10))
	{
		/#
			assert(_is_valid_trigger_type(type9));
		#/
		trigs = arraycombine(trigs, getentarray(type10, "classname"), 1, 0);
	}
	return trigs;
}

/*
	Name: _is_valid_trigger_type
	Namespace: trigger
	Checksum: 0x96A071C8
	Offset: 0x2CD8
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function _is_valid_trigger_type(type)
{
	switch(type)
	{
		case "trigger_box":
		case "trigger_damage":
		case "trigger_hurt":
		case "trigger_lookat":
		case "trigger_multiple":
		case "trigger_once":
		case "trigger_out_of_bounds":
		case "trigger_radius":
		case "trigger_use":
		case "trigger_use_touch":
		{
			return true;
			break;
		}
		default:
		{
			return false;
		}
	}
}

/*
	Name: wait_till
	Namespace: trigger
	Checksum: 0x851AB05D
	Offset: 0x2D68
	Size: 0x1FC
	Parameters: 4
	Flags: Linked
*/
function wait_till(str_name, str_key = "targetname", e_entity, b_assert = 1)
{
	if(isdefined(str_name))
	{
		triggers = getentarray(str_name, str_key);
		if(sessionmodeiscampaignzombiesgame())
		{
			if(triggers.size <= 0)
			{
				return;
			}
		}
		else
		{
			/#
				assert(!b_assert || triggers.size > 0, (("" + str_name) + "") + str_key);
			#/
		}
		if(triggers.size > 0)
		{
			if(triggers.size == 1)
			{
				trigger_hit = triggers[0];
				trigger_hit _trigger_wait(e_entity);
			}
			else
			{
				s_tracker = spawnstruct();
				array::thread_all(triggers, &_trigger_wait_think, s_tracker, e_entity);
				s_tracker waittill(#"trigger", e_other, trigger_hit);
				trigger_hit.who = e_other;
			}
			return trigger_hit;
		}
	}
	else
	{
		if(sessionmodeiscampaignzombiesgame())
		{
			if(!isdefined(self))
			{
				return;
			}
		}
		return _trigger_wait(e_entity);
	}
}

/*
	Name: _trigger_wait
	Namespace: trigger
	Checksum: 0xCF084CC5
	Offset: 0x2F70
	Size: 0x202
	Parameters: 1
	Flags: Linked
*/
function _trigger_wait(e_entity)
{
	self endon(#"death");
	if(isdefined(e_entity))
	{
		e_entity endon(#"death");
	}
	/#
		if(is_look_trigger(self))
		{
			/#
				assert(!isarray(e_entity), "");
			#/
		}
		else if(self.classname === "")
		{
			/#
				assert(!isarray(e_entity), "");
			#/
		}
	#/
	while(true)
	{
		if(is_look_trigger(self))
		{
			self waittill(#"trigger_look", e_other);
			if(isdefined(e_entity))
			{
				if(e_other !== e_entity)
				{
					continue;
				}
			}
		}
		else
		{
			if(self.classname === "trigger_damage")
			{
				self waittill(#"trigger", e_other);
				if(isdefined(e_entity))
				{
					if(e_other !== e_entity)
					{
						continue;
					}
				}
			}
			else
			{
				self waittill(#"trigger", e_other);
				if(isdefined(e_entity))
				{
					if(isarray(e_entity))
					{
						if(!array::is_touching(e_entity, self))
						{
							continue;
						}
					}
					else if(!e_entity istouching(self) && e_entity !== e_other)
					{
						continue;
					}
				}
			}
		}
		break;
	}
	self.who = e_other;
	return self;
}

/*
	Name: _trigger_wait_think
	Namespace: trigger
	Checksum: 0xD47961F6
	Offset: 0x3180
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function _trigger_wait_think(s_tracker, e_entity)
{
	self endon(#"death");
	s_tracker endon(#"trigger");
	e_other = _trigger_wait(e_entity);
	s_tracker notify(#"trigger", e_other, self);
}

/*
	Name: use
	Namespace: trigger
	Checksum: 0xE767BE6F
	Offset: 0x31F0
	Size: 0x184
	Parameters: 4
	Flags: Linked
*/
function use(str_name, str_key = "targetname", ent = getplayers()[0], b_assert = 1)
{
	if(isdefined(str_name))
	{
		e_trig = getent(str_name, str_key);
		if(!isdefined(e_trig))
		{
			if(b_assert)
			{
				/#
					assertmsg((("" + str_name) + "") + str_key);
				#/
			}
			return;
		}
	}
	else
	{
		e_trig = self;
		str_name = self.targetname;
	}
	if(isdefined(ent))
	{
		e_trig useby(ent);
	}
	else
	{
		e_trig useby(e_trig);
	}
	level notify(str_name, ent);
	if(is_look_trigger(e_trig))
	{
		e_trig notify(#"trigger_look", ent);
	}
	return e_trig;
}

/*
	Name: set_flag_permissions
	Namespace: trigger
	Checksum: 0x661E9565
	Offset: 0x3380
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function set_flag_permissions(msg)
{
	if(!isdefined(level.trigger_flags) || !isdefined(level.trigger_flags[msg]))
	{
		return;
	}
	level.trigger_flags[msg] = array::remove_undefined(level.trigger_flags[msg]);
	array::thread_all(level.trigger_flags[msg], &update_based_on_flags);
}

/*
	Name: update_based_on_flags
	Namespace: trigger
	Checksum: 0x27FD0F50
	Offset: 0x3420
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function update_based_on_flags()
{
	true_on = 1;
	if(isdefined(self.script_flag_true))
	{
		true_on = 0;
		tokens = util::create_flags_and_return_tokens(self.script_flag_true);
		for(i = 0; i < tokens.size; i++)
		{
			if(level flag::get(tokens[i]))
			{
				true_on = 1;
				break;
			}
		}
	}
	false_on = 1;
	if(isdefined(self.script_flag_false))
	{
		tokens = util::create_flags_and_return_tokens(self.script_flag_false);
		for(i = 0; i < tokens.size; i++)
		{
			if(level flag::get(tokens[i]))
			{
				false_on = 0;
				break;
			}
		}
	}
	b_enable = true_on && false_on;
	self triggerenable(b_enable);
}

/*
	Name: init_flags
	Namespace: trigger
	Checksum: 0x4925B55F
	Offset: 0x3588
	Size: 0x10
	Parameters: 0
	Flags: Linked
*/
function init_flags()
{
	level.trigger_flags = [];
}

/*
	Name: is_look_trigger
	Namespace: trigger
	Checksum: 0xB8E393B9
	Offset: 0x35A0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function is_look_trigger(trig)
{
	return true;
}

/*
	Name: is_trigger_once
	Namespace: trigger
	Checksum: 0x294BE86E
	Offset: 0x3610
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function is_trigger_once(trig)
{
	return true;
}

/*
	Name: wait_for_either
	Namespace: trigger
	Checksum: 0xBCEE7960
	Offset: 0x3678
	Size: 0x11E
	Parameters: 2
	Flags: None
*/
function wait_for_either(str_targetname1, str_targetname2)
{
	ent = spawnstruct();
	array = [];
	array = arraycombine(array, getentarray(str_targetname1, "targetname"), 1, 0);
	array = arraycombine(array, getentarray(str_targetname2, "targetname"), 1, 0);
	for(i = 0; i < array.size; i++)
	{
		ent thread _ent_waits_for_trigger(array[i]);
	}
	ent waittill(#"done", t_hit);
	return t_hit;
}

/*
	Name: _ent_waits_for_trigger
	Namespace: trigger
	Checksum: 0x4D82AD59
	Offset: 0x37A0
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function _ent_waits_for_trigger(trigger)
{
	trigger wait_till();
	self notify(#"done", trigger);
}

/*
	Name: wait_or_timeout
	Namespace: trigger
	Checksum: 0xACBE479E
	Offset: 0x37E0
	Size: 0x8C
	Parameters: 3
	Flags: None
*/
function wait_or_timeout(n_time, str_name, str_key)
{
	if(isdefined(n_time))
	{
		__s = spawnstruct();
		__s endon(#"timeout");
		__s util::delay_notify(n_time, "timeout");
	}
	wait_till(str_name, str_key);
}

/*
	Name: trigger_on_timeout
	Namespace: trigger
	Checksum: 0x78B1E59F
	Offset: 0x3878
	Size: 0xEC
	Parameters: 4
	Flags: None
*/
function trigger_on_timeout(n_time, b_cancel_on_triggered = 1, str_name, str_key = "targetname")
{
	trig = self;
	if(isdefined(str_name))
	{
		trig = getent(str_name, str_key);
	}
	if(b_cancel_on_triggered)
	{
		if(is_look_trigger(trig))
		{
			trig endon(#"trigger_look");
		}
		else
		{
			trig endon(#"trigger");
		}
	}
	trig endon(#"death");
	wait(n_time);
	trig use();
}

/*
	Name: multiple_waits
	Namespace: trigger
	Checksum: 0x9513016F
	Offset: 0x3970
	Size: 0xBA
	Parameters: 2
	Flags: None
*/
function multiple_waits(str_trigger_name, str_trigger_notify)
{
	foreach(trigger in getentarray(str_trigger_name, "targetname"))
	{
		trigger thread multiple_wait(str_trigger_notify);
	}
}

/*
	Name: multiple_wait
	Namespace: trigger
	Checksum: 0xD8309A95
	Offset: 0x3A38
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function multiple_wait(str_trigger_notify)
{
	level endon(str_trigger_notify);
	self waittill(#"trigger");
	level notify(str_trigger_notify);
}

/*
	Name: add_function
	Namespace: trigger
	Checksum: 0x1F41C007
	Offset: 0x3A70
	Size: 0x84
	Parameters: 9
	Flags: Linked
*/
function add_function(trigger, str_remove_on, func, param_1, param_2, param_3, param_4, param_5, param_6)
{
	self thread _do_trigger_function(trigger, str_remove_on, func, param_1, param_2, param_3, param_4, param_5, param_6);
}

/*
	Name: _do_trigger_function
	Namespace: trigger
	Checksum: 0x541F3141
	Offset: 0x3B00
	Size: 0xF8
	Parameters: 9
	Flags: Linked
*/
function _do_trigger_function(trigger, str_remove_on, func, param_1, param_2, param_3, param_4, param_5, param_6)
{
	self endon(#"death");
	trigger endon(#"death");
	if(isdefined(str_remove_on))
	{
		trigger endon(str_remove_on);
	}
	while(true)
	{
		if(isstring(trigger))
		{
			wait_till(trigger);
		}
		else
		{
			trigger wait_till();
		}
		util::single_thread(self, func, param_1, param_2, param_3, param_4, param_5, param_6);
	}
}

/*
	Name: kill_spawner_trigger
	Namespace: trigger
	Checksum: 0xED3A87AB
	Offset: 0x3C00
	Size: 0x1BA
	Parameters: 1
	Flags: Linked
*/
function kill_spawner_trigger(trigger)
{
	trigger wait_till();
	a_spawners = getspawnerarray(trigger.script_killspawner, "script_killspawner");
	foreach(sp in a_spawners)
	{
		sp delete();
	}
	a_ents = getentarray(trigger.script_killspawner, "script_killspawner");
	foreach(ent in a_ents)
	{
		if(ent.classname === "spawn_manager" && ent != trigger)
		{
			ent delete();
		}
	}
}

/*
	Name: get_script_linkto_targets
	Namespace: trigger
	Checksum: 0x738183E4
	Offset: 0x3DC8
	Size: 0xDA
	Parameters: 0
	Flags: Linked
*/
function get_script_linkto_targets()
{
	targets = [];
	if(!isdefined(self.script_linkto))
	{
		return targets;
	}
	tokens = strtok(self.script_linkto, " ");
	for(i = 0; i < tokens.size; i++)
	{
		token = tokens[i];
		target = getent(token, "script_linkname");
		if(isdefined(target))
		{
			targets[targets.size] = target;
		}
	}
	return targets;
}

/*
	Name: delete_link_chain
	Namespace: trigger
	Checksum: 0x670CE103
	Offset: 0x3EB0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function delete_link_chain(trigger)
{
	trigger waittill(#"trigger");
	targets = trigger get_script_linkto_targets();
	array::thread_all(targets, &delete_links_then_self);
}

/*
	Name: delete_links_then_self
	Namespace: trigger
	Checksum: 0x4084765
	Offset: 0x3F20
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function delete_links_then_self()
{
	targets = get_script_linkto_targets();
	array::thread_all(targets, &delete_links_then_self);
	self delete();
}

/*
	Name: no_crouch_or_prone_think
	Namespace: trigger
	Checksum: 0x24CF126D
	Offset: 0x3F88
	Size: 0xD8
	Parameters: 1
	Flags: Linked
*/
function no_crouch_or_prone_think(trigger)
{
	while(true)
	{
		trigger waittill(#"trigger", other);
		if(!isplayer(other))
		{
			continue;
		}
		while(other istouching(trigger))
		{
			other allowprone(0);
			other allowcrouch(0);
			wait(0.05);
		}
		other allowprone(1);
		other allowcrouch(1);
	}
}

/*
	Name: no_prone_think
	Namespace: trigger
	Checksum: 0x2D266001
	Offset: 0x4068
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function no_prone_think(trigger)
{
	while(true)
	{
		trigger waittill(#"trigger", other);
		if(!isplayer(other))
		{
			continue;
		}
		while(other istouching(trigger))
		{
			other allowprone(0);
			wait(0.05);
		}
		other allowprone(1);
	}
}

/*
	Name: trigger_group
	Namespace: trigger
	Checksum: 0x543F1E8D
	Offset: 0x4118
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function trigger_group()
{
	self thread trigger_group_remove();
	level endon("trigger_group_" + self.script_trigger_group);
	self waittill(#"trigger");
	level notify("trigger_group_" + self.script_trigger_group, self);
}

/*
	Name: trigger_group_remove
	Namespace: trigger
	Checksum: 0xB072AA90
	Offset: 0x4178
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function trigger_group_remove()
{
	level waittill("trigger_group_" + self.script_trigger_group, trigger);
	if(self != trigger)
	{
		self delete();
	}
}

/*
	Name: function_d1278be0
	Namespace: trigger
	Checksum: 0xD35FE7B1
	Offset: 0x41C8
	Size: 0xFC
	Parameters: 3
	Flags: None
*/
function function_d1278be0(ent, on_enter_payload, on_exit_payload)
{
	ent endon(#"entityshutdown");
	if(ent ent_already_in(self))
	{
		return;
	}
	add_to_ent(ent, self);
	if(isdefined(on_enter_payload))
	{
		[[on_enter_payload]](ent);
	}
	while(isdefined(ent) && ent istouching(self))
	{
		wait(0.01);
	}
	if(isdefined(ent) && isdefined(on_exit_payload))
	{
		[[on_exit_payload]](ent);
	}
	if(isdefined(ent))
	{
		remove_from_ent(ent, self);
	}
}

/*
	Name: ent_already_in
	Namespace: trigger
	Checksum: 0x81A3626A
	Offset: 0x42D0
	Size: 0x70
	Parameters: 1
	Flags: Linked
*/
function ent_already_in(trig)
{
	if(!isdefined(self._triggers))
	{
		return false;
	}
	if(!isdefined(self._triggers[trig getentitynumber()]))
	{
		return false;
	}
	if(!self._triggers[trig getentitynumber()])
	{
		return false;
	}
	return true;
}

/*
	Name: add_to_ent
	Namespace: trigger
	Checksum: 0x69912A81
	Offset: 0x4348
	Size: 0x62
	Parameters: 2
	Flags: Linked
*/
function add_to_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
	{
		ent._triggers = [];
	}
	ent._triggers[trig getentitynumber()] = 1;
}

/*
	Name: remove_from_ent
	Namespace: trigger
	Checksum: 0x2AB5F476
	Offset: 0x43B8
	Size: 0x82
	Parameters: 2
	Flags: Linked
*/
function remove_from_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
	{
		return;
	}
	if(!isdefined(ent._triggers[trig getentitynumber()]))
	{
		return;
	}
	ent._triggers[trig getentitynumber()] = 0;
}

