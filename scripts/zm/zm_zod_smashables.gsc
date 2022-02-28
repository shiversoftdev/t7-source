// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_zod_portals;
#using scripts\zm\zm_zod_quest;

class csmashable 
{
	var var_afea543d;
	var var_6e27ff4;
	var m_e_trigger;
	var m_a_callbacks;
	var m_a_e_models;
	var m_a_clip;
	var m_func_trig;
	var m_arg;
	var m_b_shader_on;
	var m_a_b_parameters;
	var m_a_nodes;

	/*
		Name: constructor
		Namespace: csmashable
		Checksum: 0xC1BB7744
		Offset: 0x448
		Size: 0x28
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		m_a_callbacks = [];
		m_a_b_parameters = [];
		m_a_e_models = [];
	}

	/*
		Name: destructor
		Namespace: csmashable
		Checksum: 0x99EC1590
		Offset: 0x1610
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: function_3408f1a2
		Namespace: csmashable
		Checksum: 0x80B5AD1F
		Offset: 0x15E0
		Size: 0x22
		Parameters: 0
		Flags: Linked
	*/
	function function_3408f1a2()
	{
		if(var_afea543d && var_6e27ff4)
		{
			return true;
		}
		return false;
	}

	/*
		Name: function_89be164a
		Namespace: csmashable
		Checksum: 0xB649329C
		Offset: 0x1558
		Size: 0x80
		Parameters: 1
		Flags: Linked
	*/
	function function_89be164a(e_trigger)
	{
		if(isdefined(e_trigger.script_int) && isdefined(e_trigger.script_percent))
		{
			var_afea543d = e_trigger.script_int;
			var_6e27ff4 = e_trigger.script_percent;
		}
		else
		{
			var_afea543d = 0;
			var_6e27ff4 = 0;
		}
	}

	/*
		Name: watch_all_damage
		Namespace: csmashable
		Checksum: 0x99C7CBB2
		Offset: 0x1460
		Size: 0xEC
		Parameters: 1
		Flags: Linked
	*/
	function watch_all_damage(e_clip)
	{
		e_clip setcandamage(1);
		while(true)
		{
			e_clip waittill(#"damage", n_amt, e_attacker, v_dir, v_pos, str_type);
			if(isdefined(e_attacker) && isplayer(e_attacker) && (isdefined(e_attacker.beastmode) && e_attacker.beastmode) && str_type === "MOD_MELEE")
			{
				m_e_trigger notify(#"trigger", e_attacker);
				break;
			}
		}
	}

	/*
		Name: add_callback
		Namespace: csmashable
		Checksum: 0x9092C83D
		Offset: 0x1168
		Size: 0x2EA
		Parameters: 4
		Flags: Linked
	*/
	function add_callback(fn_callback, param1, param2, param3)
	{
		/#
			assert(isdefined(fn_callback) && isfunctionptr(fn_callback));
		#/
		s = spawnstruct();
		s.fn = fn_callback;
		s.params = [];
		if(isdefined(param1))
		{
			if(!isdefined(s.params))
			{
				s.params = [];
			}
			else if(!isarray(s.params))
			{
				s.params = array(s.params);
			}
			s.params[s.params.size] = param1;
		}
		if(isdefined(param2))
		{
			if(!isdefined(s.params))
			{
				s.params = [];
			}
			else if(!isarray(s.params))
			{
				s.params = array(s.params);
			}
			s.params[s.params.size] = param2;
		}
		if(isdefined(param3))
		{
			if(!isdefined(s.params))
			{
				s.params = [];
			}
			else if(!isarray(s.params))
			{
				s.params = array(s.params);
			}
			s.params[s.params.size] = param3;
		}
		if(!isdefined(m_a_callbacks))
		{
			m_a_callbacks = [];
		}
		else if(!isarray(m_a_callbacks))
		{
			m_a_callbacks = array(m_a_callbacks);
		}
		m_a_callbacks[m_a_callbacks.size] = s;
	}

	/*
		Name: execute_callbacks
		Namespace: csmashable
		Checksum: 0x2A99CCBA
		Offset: 0xFE0
		Size: 0x180
		Parameters: 0
		Flags: Linked, Private
	*/
	function private execute_callbacks()
	{
		foreach(s_cb in m_a_callbacks)
		{
			switch(s_cb.params.size)
			{
				case 0:
				{
					self thread [[s_cb.fn]]();
					break;
				}
				case 1:
				{
					self thread [[s_cb.fn]](s_cb.params[0]);
					break;
				}
				case 2:
				{
					self thread [[s_cb.fn]](s_cb.params[0], s_cb.params[1]);
					break;
				}
				case 3:
				{
					self thread [[s_cb.fn]](s_cb.params[0], s_cb.params[1], s_cb.params[2]);
					break;
				}
			}
		}
	}

	/*
		Name: main
		Namespace: csmashable
		Checksum: 0x9C3FA03F
		Offset: 0xD30
		Size: 0x2A8
		Parameters: 0
		Flags: Linked, Private
	*/
	function private main()
	{
		m_e_trigger waittill(#"trigger", who);
		if(isdefined(who))
		{
			who notify(#"smashable_smashed");
		}
		foreach(model in m_a_e_models)
		{
			if(model.targetname == "fxanim_beast_door")
			{
				model playsound("zmb_bm_interaction_door");
			}
			if(model.targetname == "fxanim_crate_breakable_01")
			{
				model playsound("zmb_bm_interaction_crate_large");
			}
			if(model.targetname == "fxanim_crate_breakable_02")
			{
				model playsound("zmb_bm_interaction_crate_small");
			}
			if(model.targetname == "fxanim_crate_breakable_03")
			{
				model playsound("zmb_bm_interaction_crate_small");
			}
		}
		execute_callbacks();
		foreach(e_clip in m_a_clip)
		{
			e_clip delete();
		}
		toggle_shader(0);
		function_6ea46467(0);
		if(isdefined(m_e_trigger.script_flag_set))
		{
			level flag::set(m_e_trigger.script_flag_set);
		}
		if(isdefined(m_func_trig))
		{
			[[m_func_trig]](m_arg);
		}
	}

	/*
		Name: function_387c449e
		Namespace: csmashable
		Checksum: 0x4BC00414
		Offset: 0xCF8
		Size: 0x2C
		Parameters: 0
		Flags: Linked, Private
	*/
	function private function_387c449e()
	{
		self waittill(#"hash_13f02a5d");
		self clientfield::set("set_fade_material", 0);
	}

	/*
		Name: function_d8055c34
		Namespace: csmashable
		Checksum: 0x3F763D8E
		Offset: 0xCB8
		Size: 0x36
		Parameters: 0
		Flags: Linked, Private
	*/
	function private function_d8055c34()
	{
		self thread function_387c449e();
		wait(10);
		if(isdefined(self))
		{
			self notify(#"hash_13f02a5d");
		}
	}

	/*
		Name: function_6ea46467
		Namespace: csmashable
		Checksum: 0xECDA0067
		Offset: 0xBF0
		Size: 0xBA
		Parameters: 1
		Flags: Linked, Private
	*/
	function private function_6ea46467(b_shader_on)
	{
		foreach(e_model in m_a_e_models)
		{
			if(b_shader_on)
			{
				e_model clientfield::set("set_fade_material", 1);
				continue;
			}
			e_model thread function_d8055c34();
		}
	}

	/*
		Name: toggle_shader
		Namespace: csmashable
		Checksum: 0x2F57BE24
		Offset: 0xB40
		Size: 0xA8
		Parameters: 1
		Flags: Linked, Private
	*/
	function private toggle_shader(b_shader_on)
	{
		foreach(e_model in m_a_e_models)
		{
			e_model clientfield::set("bminteract", b_shader_on);
		}
		m_b_shader_on = b_shader_on;
	}

	/*
		Name: function_82bc26b5
		Namespace: csmashable
		Checksum: 0x28B91CA8
		Offset: 0xAE0
		Size: 0x54
		Parameters: 0
		Flags: Linked
	*/
	function function_82bc26b5()
	{
		wait(1);
		level clientfield::set("breakable_show", var_afea543d);
		level clientfield::set("breakable_hide", var_6e27ff4);
	}

	/*
		Name: setup_fxanims
		Namespace: csmashable
		Checksum: 0x10F788AF
		Offset: 0x978
		Size: 0x15C
		Parameters: 0
		Flags: Linked, Private
	*/
	function private setup_fxanims()
	{
		s_bundle_inst = struct::get(m_e_trigger.target, "targetname");
		if(isdefined(s_bundle_inst) && isdefined(s_bundle_inst.scriptbundlename))
		{
			if(!isdefined(level.zod_smashable_scriptbundles))
			{
				level.zod_smashable_scriptbundles = [];
			}
			if(!isdefined(level.zod_smashable_scriptbundles[s_bundle_inst.scriptbundlename]))
			{
				level.zod_smashable_scriptbundles[s_bundle_inst.scriptbundlename] = s_bundle_inst.scriptbundlename;
			}
			if(function_3408f1a2())
			{
				self thread function_82bc26b5();
			}
			else
			{
				level scene::init(m_e_trigger.target, "targetname");
			}
			var_5b3a6271 = function_3408f1a2();
			add_callback(&zm_zod_smashables::cb_fxanim, var_5b3a6271, var_afea543d, var_6e27ff4);
		}
	}

	/*
		Name: add_model
		Namespace: csmashable
		Checksum: 0xC0BB2836
		Offset: 0x890
		Size: 0xDC
		Parameters: 1
		Flags: Linked
	*/
	function add_model(e_model)
	{
		if(!isdefined(m_a_e_models))
		{
			m_a_e_models = [];
		}
		else if(!isarray(m_a_e_models))
		{
			m_a_e_models = array(m_a_e_models);
		}
		m_a_e_models[m_a_e_models.size] = e_model;
		if(has_parameter("any_damage"))
		{
			thread watch_all_damage(e_model);
		}
		toggle_shader(m_b_shader_on);
		function_6ea46467(1);
	}

	/*
		Name: has_parameter
		Namespace: csmashable
		Checksum: 0xF0928BEC
		Offset: 0x858
		Size: 0x2C
		Parameters: 1
		Flags: Linked
	*/
	function has_parameter(str_parameter)
	{
		return isdefined(m_a_b_parameters[str_parameter]) && m_a_b_parameters[str_parameter];
	}

	/*
		Name: parse_parameters
		Namespace: csmashable
		Checksum: 0xDF483AB
		Offset: 0x660
		Size: 0x1EA
		Parameters: 0
		Flags: Linked, Private
	*/
	function private parse_parameters()
	{
		if(!isdefined(m_e_trigger.script_parameters))
		{
			return;
		}
		a_params = strtok(m_e_trigger.script_parameters, ",");
		foreach(str_param in a_params)
		{
			m_a_b_parameters[str_param] = 1;
			if(str_param == "connect_paths")
			{
				add_callback(&zm_zod_smashables::cb_connect_paths);
				continue;
			}
			if(str_param == "any_damage")
			{
				foreach(e_clip in m_a_clip)
				{
					thread watch_all_damage(e_clip);
				}
				continue;
			}
			/#
				/#
					assertmsg(((("" + str_param) + "") + m_e_trigger.targetname) + "");
				#/
			#/
		}
	}

	/*
		Name: set_trigger_func
		Namespace: csmashable
		Checksum: 0x9B0E0A50
		Offset: 0x628
		Size: 0x2C
		Parameters: 2
		Flags: Linked
	*/
	function set_trigger_func(func_trig, arg)
	{
		m_func_trig = func_trig;
		m_arg = arg;
	}

	/*
		Name: init
		Namespace: csmashable
		Checksum: 0x1CBC39F5
		Offset: 0x478
		Size: 0x1A4
		Parameters: 1
		Flags: Linked
	*/
	function init(e_trigger)
	{
		m_e_trigger = e_trigger;
		m_a_clip = getentarray(e_trigger.target, "targetname");
		m_a_nodes = getnodearray(e_trigger.target, "targetname");
		foreach(node in m_a_nodes)
		{
			if(isdefined(node.script_noteworthy) && node.script_noteworthy == "air_beast_node")
			{
				unlinktraversal(node);
			}
		}
		function_89be164a(e_trigger);
		setup_fxanims();
		parse_parameters();
		toggle_shader(1);
		function_6ea46467(1);
		thread main();
	}

}

#namespace zm_zod_smashables;

/*
	Name: __init__sytem__
	Namespace: zm_zod_smashables
	Checksum: 0x873314BF
	Offset: 0x408
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_smashables", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_smashables
	Checksum: 0x6A6BFEE7
	Offset: 0x19E0
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level thread init_smashables();
	foreach(str_bundle in level.zod_smashable_scriptbundles)
	{
		scene::add_scene_func(str_bundle, &add_scriptbundle_models, "init");
	}
}

/*
	Name: smashable_from_scriptbundle_targetname
	Namespace: zm_zod_smashables
	Checksum: 0xEE087432
	Offset: 0x1AA0
	Size: 0xBE
	Parameters: 1
	Flags: Linked, Private
*/
function private smashable_from_scriptbundle_targetname(str_targetname)
{
	foreach(o_smash in level.zod_smashables)
	{
		if(isdefined(o_smash.m_e_trigger.target) && o_smash.m_e_trigger.target == str_targetname)
		{
			return o_smash;
		}
	}
	return undefined;
}

/*
	Name: add_scriptbundle_models
	Namespace: zm_zod_smashables
	Checksum: 0xD83FC7C7
	Offset: 0x1B68
	Size: 0xE6
	Parameters: 1
	Flags: Linked, Private
*/
function private add_scriptbundle_models(a_models)
{
	o_smash = undefined;
	foreach(e_model in a_models)
	{
		if(!isdefined(o_smash))
		{
			o_smash = smashable_from_scriptbundle_targetname(e_model._o_scene._e_root.targetname);
		}
		if(isdefined(o_smash))
		{
			[[ o_smash ]]->add_model(e_model);
		}
	}
}

/*
	Name: init_smashables
	Namespace: zm_zod_smashables
	Checksum: 0xE898167C
	Offset: 0x1C58
	Size: 0x29A
	Parameters: 0
	Flags: Linked, Private
*/
function private init_smashables()
{
	level.zod_smashables = [];
	a_smashable_triggers = getentarray("beast_melee_only", "script_noteworthy");
	n_id = 0;
	foreach(trigger in a_smashable_triggers)
	{
		str_id = "smash_unnamed_" + n_id;
		if(isdefined(trigger.targetname))
		{
			str_id = trigger.targetname;
		}
		else
		{
			trigger.targetname = str_id;
			n_id++;
		}
		if(isdefined(level.zod_smashables[str_id]))
		{
			/#
				/#
					assertmsg(("" + str_id) + "");
				#/
			#/
			continue;
		}
		o_smashable = new csmashable();
		level.zod_smashables[str_id] = o_smashable;
		if(issubstr(str_id, "portal"))
		{
			[[ o_smashable ]]->set_trigger_func(&zm_zod_portals::function_54ec766b, str_id);
		}
		if(issubstr(str_id, "memento"))
		{
			[[ o_smashable ]]->set_trigger_func(&zm_zod_quest::reveal_personal_item, str_id);
		}
		if(issubstr(str_id, "beast_kiosk"))
		{
			[[ o_smashable ]]->set_trigger_func(&unlock_beast_kiosk, str_id);
		}
		if(str_id === "unlock_quest_key")
		{
			[[ o_smashable ]]->set_trigger_func(&unlock_quest_key, str_id);
		}
		[[ o_smashable ]]->init(trigger);
	}
}

/*
	Name: unlock_beast_kiosk
	Namespace: zm_zod_smashables
	Checksum: 0x194D5801
	Offset: 0x1F00
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function unlock_beast_kiosk(str_id)
{
	unlock_beast_trigger("beast_mode_kiosk_unavailable", str_id);
	unlock_beast_trigger("beast_mode_kiosk", str_id);
}

/*
	Name: unlock_beast_trigger
	Namespace: zm_zod_smashables
	Checksum: 0xC71A8978
	Offset: 0x1F58
	Size: 0xDA
	Parameters: 2
	Flags: Linked
*/
function unlock_beast_trigger(str_targetname, str_id)
{
	triggers = getentarray(str_targetname, "targetname");
	foreach(trigger in triggers)
	{
		if(trigger.script_noteworthy === str_id)
		{
			trigger.is_unlocked = 1;
		}
	}
}

/*
	Name: unlock_quest_key
	Namespace: zm_zod_smashables
	Checksum: 0xBD1DD1BD
	Offset: 0x2040
	Size: 0x18
	Parameters: 1
	Flags: Linked
*/
function unlock_quest_key(str_id)
{
	level.quest_key_can_be_picked_up = 1;
}

/*
	Name: add_callback
	Namespace: zm_zod_smashables
	Checksum: 0xF72C2CB0
	Offset: 0x2060
	Size: 0xA8
	Parameters: 5
	Flags: Linked
*/
function add_callback(targetname, fn_callback, param1, param2, param3)
{
	o_smashable = level.zod_smashables[targetname];
	if(!isdefined(o_smashable))
	{
		/#
			/#
				assertmsg(("" + targetname) + "");
			#/
		#/
		return;
	}
	[[ o_smashable ]]->add_callback(fn_callback, param1, param2, param3);
}

/*
	Name: cb_connect_paths
	Namespace: zm_zod_smashables
	Checksum: 0x3E491AF4
	Offset: 0x2110
	Size: 0xE2
	Parameters: 0
	Flags: Linked, Private
*/
function private cb_connect_paths()
{
	self.m_a_clip[0] connectpaths();
	if(isdefined(self.m_a_nodes))
	{
		foreach(node in self.m_a_nodes)
		{
			if(isdefined(node.script_noteworthy) && node.script_noteworthy == "air_beast_node")
			{
				linktraversal(node);
			}
		}
	}
}

/*
	Name: cb_fxanim
	Namespace: zm_zod_smashables
	Checksum: 0xEF2183CD
	Offset: 0x2200
	Size: 0xD4
	Parameters: 3
	Flags: Linked, Private
*/
function private cb_fxanim(var_5b3a6271, var_bc554281, var_6bf8cfb8)
{
	str_fxanim = self.m_e_trigger.target;
	s_fxanim = struct::get(str_fxanim, "targetname");
	if(var_bc554281)
	{
		level clientfield::set("breakable_hide", var_bc554281);
	}
	level scene::play(str_fxanim, "targetname");
	if(var_6bf8cfb8)
	{
		level clientfield::set("breakable_show", var_6bf8cfb8);
	}
}

