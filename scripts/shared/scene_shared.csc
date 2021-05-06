// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_debug_shared;
#using scripts\shared\scriptbundle_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace scene;

/*
	Name: player_scene_animation_skip
	Namespace: scene
	Checksum: 0xD4A1ED75
	Offset: 0x640
	Size: 0x124
	Parameters: 7
	Flags: Linked
*/
function player_scene_animation_skip(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	anim_name = self getcurrentanimscriptedname();
	if(isdefined(anim_name) && anim_name != "")
	{
		is_looping = isanimlooping(localclientnum, anim_name);
		if(!is_looping)
		{
			/#
				if(getdvarint("") > 0)
				{
					printtoprightln("" + anim_name + "" + gettime(), vectorscale((1, 1, 1), 0.6));
				}
			#/
			self setanimtimebyname(anim_name, 1, 1);
		}
	}
}

/*
	Name: player_scene_skip_completed
	Namespace: scene
	Checksum: 0xD3017F8
	Offset: 0x770
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function player_scene_skip_completed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	flushsubtitles(localclientnum);
	setdvar("r_graphicContentBlur", 0);
	setdvar("r_makeDark_enable", 0);
}

#namespace csceneobject;

/*
	Name: __constructor
	Namespace: csceneobject
	Checksum: 0xEAF1916D
	Offset: 0x800
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	cscriptbundleobjectbase::__constructor();
	self._b_spawnonce_used = 0;
	self._is_valid = 1;
}

/*
	Name: __destructor
	Namespace: csceneobject
	Checksum: 0x68D45E22
	Offset: 0x838
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
	cscriptbundleobjectbase::__destructor();
}

/*
	Name: first_init
	Namespace: csceneobject
	Checksum: 0x45DC0719
	Offset: 0x858
	Size: 0x7E
	Parameters: 4
	Flags: Linked
*/
function first_init(s_objdef, o_scene, e_ent, localclientnum)
{
	cscriptbundleobjectbase::init(s_objdef, o_scene, e_ent, localclientnum);
	_assign_unique_name();
	if(self._e_array.size)
	{
		_prepare(self._n_clientnum);
	}
	return self;
}

/*
	Name: initialize
	Namespace: csceneobject
	Checksum: 0x2F9C8F4C
	Offset: 0x8E0
	Size: 0x2EC
	Parameters: 0
	Flags: Linked
*/
function initialize()
{
	if(isdefined(self._s.spawnoninit) && self._s.spawnoninit)
	{
		if(isdefined(self._n_clientnum))
		{
			_spawn(self._n_clientnum, isdefined(self._s.firstframe) && self._s.firstframe || isdefined(self._s.initanim) || isdefined(self._s.initanimloop));
		}
		else
		{
			_spawn(0, isdefined(self._s.firstframe) && self._s.firstframe || isdefined(self._s.initanim) || isdefined(self._s.initanimloop));
			for(clientnum = 1; clientnum < getmaxlocalclients(); clientnum++)
			{
				if(isdefined(getlocalplayer(clientnum)))
				{
					if(isdefined(self._s.spawnoninit) && self._s.spawnoninit)
					{
						_spawn(clientnum, isdefined(self._s.firstframe) && self._s.firstframe || isdefined(self._s.initanim) || isdefined(self._s.initanimloop));
					}
				}
			}
		}
	}
	flagsys::clear("ready");
	flagsys::clear("done");
	flagsys::clear("main_done");
	self notify(#"new_state");
	self endon(#"new_state");
	self notify(#"init");
	waittillframeend();
	if(isdefined(self._n_clientnum))
	{
		thread initialize_per_client(self._n_clientnum);
	}
	else
	{
		for(clientnum = 1; clientnum < getmaxlocalclients(); clientnum++)
		{
			if(isdefined(getlocalplayer(clientnum)))
			{
				thread initialize_per_client(clientnum);
			}
		}
		initialize_per_client(0);
	}
}

/*
	Name: initialize_per_client
	Namespace: csceneobject
	Checksum: 0xA4DE13E7
	Offset: 0xBD8
	Size: 0x244
	Parameters: 1
	Flags: Linked
*/
function initialize_per_client(clientnum)
{
	self endon(#"new_state");
	if(isdefined(self._s.firstframe) && self._s.firstframe)
	{
		if(!cscriptbundleobjectbase::error(!isdefined(self._s.mainanim), "No animation defined for first frame."))
		{
			_play_anim(clientnum, self._s.mainanim, 0, 0, 0, undefined, self._s.mainshot);
		}
	}
	else if(isdefined(self._s.initanim))
	{
		_play_anim(clientnum, self._s.initanim, self._s.initdelaymin, self._s.initdelaymax, 1, undefined, self._s.initshot);
		if(is_alive(clientnum))
		{
			if(isdefined(self._s.initanimloop))
			{
				_play_anim(clientnum, self._s.initanimloop, 0, 0, 1, undefined, self._s.initshotloop, 1);
			}
		}
	}
	else if(isdefined(self._s.initanimloop))
	{
		_play_anim(clientnum, self._s.initanimloop, self._s.initdelaymin, self._s.initdelaymax, 1, undefined, self._s.initshotloop, 1);
	}
	else
	{
		flagsys::set("ready");
	}
	if(!self._is_valid)
	{
		flagsys::set("done");
	}
}

/*
	Name: play
	Namespace: csceneobject
	Checksum: 0xB5328D40
	Offset: 0xE28
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function play()
{
	flagsys::clear("ready");
	flagsys::clear("done");
	flagsys::clear("main_done");
	self notify(#"new_state");
	self endon(#"new_state");
	self notify(#"play");
	waittillframeend();
	if(isdefined(self._n_clientnum))
	{
		play_per_client(self._n_clientnum);
	}
	else
	{
		for(clientnum = 1; clientnum < getmaxlocalclients(); clientnum++)
		{
			if(isdefined(getlocalplayer(clientnum)))
			{
				thread play_per_client(clientnum);
			}
		}
		play_per_client(0);
	}
}

/*
	Name: play_per_client
	Namespace: csceneobject
	Checksum: 0x6C84BAC0
	Offset: 0xF50
	Size: 0x1FC
	Parameters: 1
	Flags: Linked
*/
function play_per_client(clientnum)
{
	self endon(#"new_state");
	if(isdefined(self._s.mainanim))
	{
		_play_anim(clientnum, self._s.mainanim, self._s.maindelaymin, self._s.maindelaymax, 1, self._s.mainblend, self._s.mainshot);
		flagsys::set("main_done");
		if(is_alive(clientnum))
		{
			if(isdefined(self._s.endanim))
			{
				_play_anim(clientnum, self._s.endanim, 0, 0, 1, undefined, self._s.endshot, 1);
				if(is_alive(clientnum))
				{
					if(isdefined(self._s.endanimloop))
					{
						_play_anim(clientnum, self._s.endanimloop, 0, 0, 1, undefined, self._s.endshotloop, 1);
					}
				}
			}
			else if(isdefined(self._s.endanimloop))
			{
				_play_anim(clientnum, self._s.endanimloop, 0, 0, 1, undefined, self._s.endshotloop, 1);
			}
		}
	}
	thread finish_per_client(clientnum);
}

/*
	Name: finish
	Namespace: csceneobject
	Checksum: 0xF5354C11
	Offset: 0x1158
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function finish(b_clear = 0)
{
	self notify(#"new_state");
	if(isdefined(self._n_clientnum))
	{
		finish_per_client(self._n_clientnum, b_clear);
	}
	else
	{
		for(clientnum = 1; clientnum < getmaxlocalclients(); clientnum++)
		{
			if(isdefined(getlocalplayer(clientnum)))
			{
				finish_per_client(clientnum, b_clear);
			}
		}
		finish_per_client(0, b_clear);
	}
}

/*
	Name: finish_per_client
	Namespace: csceneobject
	Checksum: 0x877B71D
	Offset: 0x1240
	Size: 0x12C
	Parameters: 2
	Flags: Linked
*/
function finish_per_client(clientnum, b_clear = 0)
{
	if(!is_alive(clientnum))
	{
		_cleanup(clientnum);
		self._e_array[clientnum] = undefined;
		self._is_valid = 0;
	}
	flagsys::set("ready");
	flagsys::set("done");
	if(isdefined(self._e_array[clientnum]))
	{
		if(is_alive(clientnum) && (isdefined(self._s.deletewhenfinished) && self._s.deletewhenfinished || b_clear))
		{
			self._e_array[clientnum] delete();
		}
	}
	_cleanup(clientnum);
}

/*
	Name: get_align_ent
	Namespace: csceneobject
	Checksum: 0x8801C705
	Offset: 0x1378
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function get_align_ent(clientnum)
{
	e_align = undefined;
	if(isdefined(self._s.aligntarget))
	{
		a_scene_ents = [[ self._o_bundle ]]->get_ents();
		if(isdefined(a_scene_ents[clientnum][self._s.aligntarget]))
		{
			e_align = a_scene_ents[clientnum][self._s.aligntarget];
		}
		else
		{
			e_align = scene::get_existing_ent(clientnum, self._s.aligntarget);
		}
		cscriptbundleobjectbase::error(!isdefined(e_align), "Align target '" + (isdefined(self._s.aligntarget) ? "" + self._s.aligntarget : "") + "' doesn't exist for scene object.");
	}
	if(!isdefined(e_align))
	{
		e_align = [[ scene() ]]->get_align_ent(clientnum);
	}
	return e_align;
}

/*
	Name: scene
	Namespace: csceneobject
	Checksum: 0xD376B57B
	Offset: 0x14D8
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function scene()
{
	return self._o_bundle;
}

/*
	Name: _assign_unique_name
	Namespace: csceneobject
	Checksum: 0x78723F65
	Offset: 0x14F0
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function _assign_unique_name()
{
	if([[ scene() ]]->allows_multiple())
	{
		if(isdefined(self._s.name))
		{
			self._str_name = self._s.name + "_gen" + level.scene_object_id;
		}
		else
		{
			self._str_name = [[ scene() ]]->get_name() + "_noname" + level.scene_object_id;
		}
		level.scene_object_id++;
	}
	else if(isdefined(self._s.name))
	{
		self._str_name = self._s.name;
	}
	else
	{
		self._str_name = [[ scene() ]]->get_name() + "_noname" + [[ scene() ]]->get_object_id();
	}
}

/*
	Name: get_name
	Namespace: csceneobject
	Checksum: 0x76170705
	Offset: 0x1620
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_name()
{
	return self._str_name;
}

/*
	Name: get_orig_name
	Namespace: csceneobject
	Checksum: 0x563CC1A3
	Offset: 0x1638
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function get_orig_name()
{
	return self._s.name;
}

/*
	Name: _spawn
	Namespace: csceneobject
	Checksum: 0x83C31024
	Offset: 0x1658
	Size: 0x3C8
	Parameters: 2
	Flags: Linked
*/
function _spawn(clientnum, b_hide = 1)
{
	if(!isdefined(self._e_array[clientnum]))
	{
		b_allows_multiple = [[ scene() ]]->allows_multiple();
		if(cscriptbundleobjectbase::error(b_allows_multiple && (isdefined(self._s.nospawn) && self._s.nospawn), "Scene that allow multiple instances must be allowed to spawn (uncheck 'Do Not Spawn')."))
		{
			return;
		}
		self._e_array[clientnum] = scene::get_existing_ent(clientnum, self._str_name);
		if(!isdefined(self._e_array[clientnum]) && isdefined(self._s.name) && !b_allows_multiple)
		{
			self._e_array[clientnum] = scene::get_existing_ent(clientnum, self._s.name);
		}
		if(!isdefined(self._e_array[clientnum]) && (!(isdefined(self._s.nospawn) && self._s.nospawn)) && !self._b_spawnonce_used)
		{
			_e_align = get_align_ent(clientnum);
			self._e_array[clientnum] = util::spawn_model(clientnum, self._s.model, _e_align.origin, _e_align.angles);
			if(isdefined(self._e_array[clientnum]))
			{
				if(b_hide)
				{
					self._e_array[clientnum] hide();
				}
				self._e_array[clientnum].scene_spawned = self._o_bundle._s.name;
				self._e_array[clientnum].targetname = self._s.name;
			}
			else
			{
				cscriptbundleobjectbase::error(!(isdefined(self._s.nospawn) && self._s.nospawn), "No entity exists with matching name of scene object.");
			}
		}
		if(isdefined(self._s.spawnonce) && self._s.spawnonce && self._b_spawnonce_used)
		{
			return;
		}
		if(!(cscriptbundleobjectbase::error(!(isdefined(self._s.nospawn) && self._s.nospawn) && !isdefined(self._e_array[clientnum]), "No entity exists with matching name of scene object. Make sure a model is specified if you want to spawn it.")))
		{
			_prepare(clientnum);
		}
	}
	if(isdefined(self._e_array[clientnum]))
	{
		flagsys::set("ready");
		if(isdefined(self._s.spawnonce) && self._s.spawnonce)
		{
			self._b_spawnonce_used = 1;
		}
	}
}

/*
	Name: _prepare
	Namespace: csceneobject
	Checksum: 0x5ED05F14
	Offset: 0x1A28
	Size: 0x15A
	Parameters: 1
	Flags: Linked
*/
function _prepare(clientnum)
{
	if(!(isdefined(self._s.issiege) && self._s.issiege))
	{
		if(!self._e_array[clientnum] hasanimtree())
		{
			self._e_array[clientnum] useanimtree($generic);
		}
	}
	self._e_array[clientnum].animname = self._str_name;
	self._e_array[clientnum].anim_debug_name = self._s.name;
	self._e_array[clientnum] flagsys::set("scene");
	self._e_array[clientnum] flagsys::set(self._o_bundle._str_name);
	self._e_array[clientnum].current_scene = self._o_bundle._str_name;
	self._e_array[clientnum].finished_scene = undefined;
}

/*
	Name: _cleanup
	Namespace: csceneobject
	Checksum: 0xAF66C5EA
	Offset: 0x1B90
	Size: 0x15C
	Parameters: 1
	Flags: Linked
*/
function _cleanup(clientnum)
{
	if(isdefined(self._e_array[clientnum]) && isdefined(self._e_array[clientnum].current_scene))
	{
		self._e_array[clientnum] flagsys::clear(self._o_bundle._str_name);
		if(self._e_array[clientnum].current_scene == self._o_bundle._str_name)
		{
			self._e_array[clientnum] flagsys::clear("scene");
			self._e_array[clientnum].finished_scene = self._o_bundle._str_name;
			self._e_array[clientnum].current_scene = undefined;
		}
	}
	if(clientnum === self._n_clientnum || clientnum == 0)
	{
		if(isdefined(self._o_bundle) && (isdefined(self._o_bundle.scene_stopped) && self._o_bundle.scene_stopped))
		{
			self._o_bundle = undefined;
		}
	}
}

/*
	Name: _play_anim
	Namespace: csceneobject
	Checksum: 0xC6944AF9
	Offset: 0x1CF8
	Size: 0x2A4
	Parameters: 8
	Flags: Linked
*/
function _play_anim(clientnum, animation, n_delay_min = 0, n_delay_max = 0, n_rate = 1, n_blend, str_siege_shot, loop)
{
	n_delay = n_delay_min;
	if(n_delay_max > n_delay_min)
	{
		n_delay = randomfloatrange(n_delay_min, n_delay_max);
	}
	if(n_delay > 0)
	{
		flagsys::set("ready");
		wait(n_delay);
		_spawn(clientnum);
	}
	else
	{
		_spawn(clientnum);
	}
	if(is_alive(clientnum))
	{
		self._e_array[clientnum] show();
		if(isdefined(self._s.issiege) && self._s.issiege)
		{
			self._e_array[clientnum] notify(#"end");
			self._e_array[clientnum] animation::play_siege(animation, str_siege_shot, n_rate, loop);
		}
		else
		{
			align = get_align_ent(clientnum);
			tag = get_align_tag();
			if(align == level)
			{
				align = (0, 0, 0);
				tag = (0, 0, 0);
			}
			self._e_array[clientnum] animation::play(animation, align, tag, n_rate, n_blend);
		}
	}
	cscriptbundleobjectbase::log("" + animation + "");
	self._is_valid = is_alive(clientnum);
}

/*
	Name: get_align_tag
	Namespace: csceneobject
	Checksum: 0xA8DFED11
	Offset: 0x1FA8
	Size: 0x42
	Parameters: 0
	Flags: Linked
*/
function get_align_tag()
{
	if(isdefined(self._s.aligntargettag))
	{
		return self._s.aligntargettag;
	}
	return self._o_bundle._s.aligntargettag;
}

/*
	Name: wait_till_scene_ready
	Namespace: csceneobject
	Checksum: 0x40202F70
	Offset: 0x1FF8
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function wait_till_scene_ready()
{
	[[ scene() ]]->wait_till_scene_ready();
}

/*
	Name: has_init_state
	Namespace: csceneobject
	Checksum: 0xFAECC5A3
	Offset: 0x2028
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function has_init_state()
{
	return self._s scene::_has_init_state();
}

/*
	Name: is_alive
	Namespace: csceneobject
	Checksum: 0x2A65885D
	Offset: 0x2050
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function is_alive(clientnum)
{
	return isdefined(self._e_array[clientnum]);
}

/*
	Name: in_a_different_scene
	Namespace: csceneobject
	Checksum: 0xE43A5B4D
	Offset: 0x2078
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function in_a_different_scene()
{
	if(isdefined(self._n_clientnum))
	{
		if(isdefined(self._e_array[self._n_clientnum]) && isdefined(self._e_array[self._n_clientnum].current_scene) && self._e_array[self._n_clientnum].current_scene != self._o_bundle._str_name)
		{
			return 1;
		}
	}
	else if(isdefined(self._e_array[0]) && isdefined(self._e_array[0].current_scene) && self._e_array[0].current_scene != self._o_bundle._str_name)
	{
		return 1;
	}
	return 0;
}

#namespace scene;

/*
	Name: csceneobject
	Namespace: scene
	Checksum: 0x3DF11B57
	Offset: 0x2160
	Size: 0x596
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function csceneobject()
{
	classes.csceneobject[0] = spawnstruct();
	classes.csceneobject[0].__vtable[964891661] = &cscriptbundleobjectbase::get_ent;
	classes.csceneobject[0].__vtable[-32002227] = &cscriptbundleobjectbase::error;
	classes.csceneobject[0].__vtable[1621988813] = &cscriptbundleobjectbase::log;
	classes.csceneobject[0].__vtable[-1017222485] = &cscriptbundleobjectbase::init;
	classes.csceneobject[0].__vtable[1606033458] = &cscriptbundleobjectbase::__destructor;
	classes.csceneobject[0].__vtable[-1690805083] = &cscriptbundleobjectbase::__constructor;
	classes.csceneobject[0].__vtable[-1004716425] = &csceneobject::in_a_different_scene;
	classes.csceneobject[0].__vtable[-1924366689] = &csceneobject::is_alive;
	classes.csceneobject[0].__vtable[1064337886] = &csceneobject::has_init_state;
	classes.csceneobject[0].__vtable[792158469] = &csceneobject::wait_till_scene_ready;
	classes.csceneobject[0].__vtable[-2100195004] = &csceneobject::get_align_tag;
	classes.csceneobject[0].__vtable[-1706684566] = &csceneobject::_play_anim;
	classes.csceneobject[0].__vtable[751796260] = &csceneobject::_cleanup;
	classes.csceneobject[0].__vtable[-800750439] = &csceneobject::_prepare;
	classes.csceneobject[0].__vtable[987150381] = &csceneobject::_spawn;
	classes.csceneobject[0].__vtable[-1878563751] = &csceneobject::get_orig_name;
	classes.csceneobject[0].__vtable[245263499] = &csceneobject::get_name;
	classes.csceneobject[0].__vtable[737108631] = &csceneobject::_assign_unique_name;
	classes.csceneobject[0].__vtable[214070679] = &csceneobject::scene;
	classes.csceneobject[0].__vtable[1666938539] = &csceneobject::get_align_ent;
	classes.csceneobject[0].__vtable[847716238] = &csceneobject::finish_per_client;
	classes.csceneobject[0].__vtable[-1089329960] = &csceneobject::finish;
	classes.csceneobject[0].__vtable[-1148721625] = &csceneobject::play_per_client;
	classes.csceneobject[0].__vtable[1131512199] = &csceneobject::play;
	classes.csceneobject[0].__vtable[-675334113] = &csceneobject::initialize_per_client;
	classes.csceneobject[0].__vtable[-422924033] = &csceneobject::initialize;
	classes.csceneobject[0].__vtable[-1191896790] = &csceneobject::first_init;
	classes.csceneobject[0].__vtable[1606033458] = &csceneobject::__destructor;
	classes.csceneobject[0].__vtable[-1690805083] = &csceneobject::__constructor;
}

#namespace cscene;

/*
	Name: __constructor
	Namespace: cscene
	Checksum: 0x2BEFF95F
	Offset: 0x2700
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	cscriptbundlebase::__constructor();
	self._n_object_id = 0;
	self._str_state = "";
}

/*
	Name: __destructor
	Namespace: cscene
	Checksum: 0xA2582C78
	Offset: 0x2738
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
	cscriptbundlebase::__destructor();
}

/*
	Name: init
	Namespace: cscene
	Checksum: 0xA85F5853
	Offset: 0x2758
	Size: 0x4CC
	Parameters: 5
	Flags: Linked
*/
function init(str_scenedef, s_scenedef, e_align, a_ents, b_test_run)
{
	cscriptbundlebase::init(str_scenedef, s_scenedef, b_test_run);
	if(!isdefined(a_ents))
	{
		a_ents = [];
	}
	else if(!isarray(a_ents))
	{
		a_ents = array(a_ents);
	}
	if(!cscriptbundlebase::error(a_ents.size > self._s.objects.size, "Trying to use more entities than scene supports."))
	{
		self._e_root = e_align;
		if(!isdefined(level.active_scenes[self._str_name]))
		{
			level.active_scenes[self._str_name] = [];
		}
		else if(!isarray(level.active_scenes[self._str_name]))
		{
			level.active_scenes[self._str_name] = array(level.active_scenes[self._str_name]);
		}
		level.active_scenes[self._str_name][level.active_scenes[self._str_name].size] = self._e_root;
		if(!isdefined(self._e_root.scenes))
		{
			self._e_root.scenes = [];
		}
		else if(!isarray(self._e_root.scenes))
		{
			self._e_root.scenes = array(self._e_root.scenes);
		}
		self._e_root.scenes[self._e_root.scenes.size] = self;
		a_objs = get_valid_object_defs();
		foreach(str_name, e_ent in arraycopy(a_ents))
		{
			foreach(i, s_obj in arraycopy(a_objs))
			{
				if(s_obj.name === (isdefined(str_name) ? "" + str_name : ""))
				{
					object = new csceneobject();
					[[ object ]]->__constructor();
					cscriptbundlebase::add_object([[ object ]]->first_init(s_obj, self, e_ent, self._e_root.localclientnum));
					arrayremoveindex(a_ents, str_name);
					arrayremoveindex(a_objs, i);
					break;
				}
			}
		}
		foreach(var_99c6d62c, s_obj in a_objs)
		{
			object = new csceneobject();
			[[ object ]]->__constructor();
			cscriptbundlebase::add_object([[ object ]]->first_init(s_obj, self, array::pop(a_ents), self._e_root.localclientnum));
		}
		self thread initialize();
	}
}

/*
	Name: get_valid_object_defs
	Namespace: cscene
	Checksum: 0x335E1C45
	Offset: 0x2C30
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function get_valid_object_defs()
{
	a_obj_defs = [];
	foreach(var_21d78be8, s_obj in self._s.objects)
	{
		if(self._s.vmtype == "client" || s_obj.vmtype == "client")
		{
			if(isdefined(s_obj.name) || isdefined(s_obj.model) || isdefined(s_obj.initanim) || isdefined(s_obj.mainanim))
			{
				if(!(isdefined(s_obj.disabled) && s_obj.disabled))
				{
					if(!isdefined(a_obj_defs))
					{
						a_obj_defs = [];
					}
					else if(!isarray(a_obj_defs))
					{
						a_obj_defs = array(a_obj_defs);
					}
					a_obj_defs[a_obj_defs.size] = s_obj;
				}
			}
		}
	}
	return a_obj_defs;
}

/*
	Name: initialize
	Namespace: cscene
	Checksum: 0xC2EB031F
	Offset: 0x2DD8
	Size: 0x14C
	Parameters: 1
	Flags: Linked
*/
function initialize(b_playing = 0)
{
	self notify(#"new_state");
	self endon(#"new_state");
	if(get_valid_objects().size > 0)
	{
		level flagsys::set(self._str_name + "_initialized");
		self._str_state = "init";
		foreach(var_fec15ad5, o_obj in self._a_objects)
		{
			thread [[ o_obj ]]->initialize();
		}
		if(!b_playing)
		{
			thread _call_state_funcs("init");
		}
	}
	wait_till_scene_done();
	thread stop();
}

/*
	Name: get_object_id
	Namespace: cscene
	Checksum: 0xC389D09B
	Offset: 0x2F30
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function get_object_id()
{
	self._n_object_id++;
	return self._n_object_id;
}

/*
	Name: play
	Namespace: cscene
	Checksum: 0xB43C8A89
	Offset: 0x2F50
	Size: 0x30C
	Parameters: 2
	Flags: Linked
*/
function play(b_testing = 0, str_mode = "")
{
	level endon(#"demo_jump");
	self notify(#"new_state");
	self endon(#"new_state");
	self._testing = b_testing;
	self._str_mode = str_mode;
	if(get_valid_objects().size > 0)
	{
		foreach(var_fae08ee2, o_obj in self._a_objects)
		{
			thread [[ o_obj ]]->play();
		}
		level flagsys::set(self._str_name + "_playing");
		self._str_state = "play";
		wait_till_scene_ready();
		thread _call_state_funcs("play");
		wait_till_scene_done();
		array::flagsys_wait_any_flag(self._a_objects, "done", "main_done");
		if(isdefined(self._e_root))
		{
			self._e_root notify(#"scene_done", self._str_name);
			thread _call_state_funcs("done");
		}
		array::flagsys_wait(self._a_objects, "done");
		if(is_looping() || self._str_mode == "loop")
		{
			if(has_init_state())
			{
				level flagsys::clear(self._str_name + "_playing");
				thread initialize();
			}
			else
			{
				level flagsys::clear(self._str_name + "_initialized");
				thread play(b_testing, str_mode);
			}
		}
		else
		{
			thread run_next();
			thread stop(0, 1);
		}
	}
	else
	{
		thread stop(0, 1);
	}
}

/*
	Name: run_next
	Namespace: cscene
	Checksum: 0xAA417818
	Offset: 0x3268
	Size: 0x1E4
	Parameters: 0
	Flags: Linked
*/
function run_next()
{
	if(isdefined(self._s.nextscenebundle) && self._s.vmtype != "both")
	{
		self waittill(#"stopped", b_finished);
		if(b_finished)
		{
			if(self._s.scenetype == "fxanim" && self._s.nextscenemode === "init")
			{
				if(!cscriptbundlebase::error(!has_init_state(), "Scene can't init next scene '" + self._s.nextscenebundle + "' because it doesn't have an init state."))
				{
					if(allows_multiple())
					{
						self._e_root thread scene::init(self._s.nextscenebundle, get_ents());
					}
					else
					{
						self._e_root thread scene::init(self._s.nextscenebundle);
					}
				}
			}
			else if(allows_multiple())
			{
				self._e_root thread scene::play(self._s.nextscenebundle, get_ents());
			}
			else
			{
				self._e_root thread scene::play(self._s.nextscenebundle);
			}
		}
	}
}

/*
	Name: stop
	Namespace: cscene
	Checksum: 0xDBEFFB09
	Offset: 0x3458
	Size: 0x280
	Parameters: 2
	Flags: Linked
*/
function stop(b_clear = 0, b_finished = 0)
{
	self notify(#"new_state");
	level flagsys::clear(self._str_name + "_playing");
	level flagsys::clear(self._str_name + "_initialized");
	self._str_state = "";
	thread _call_state_funcs("stop");
	self.scene_stopped = 1;
	foreach(var_d12044a9, o_obj in self._a_objects)
	{
		if(isdefined(o_obj) && !([[ o_obj ]]->in_a_different_scene()))
		{
			thread [[ o_obj ]]->finish(b_clear);
		}
	}
	self notify(#"stopped", b_finished);
	if(isdefined(level.active_scenes[self._str_name]))
	{
		arrayremovevalue(level.active_scenes[self._str_name], self._e_root);
		if(level.active_scenes[self._str_name].size == 0)
		{
			level.active_scenes[self._str_name] = undefined;
		}
	}
	if(isdefined(self._e_root) && isdefined(self._e_root.scenes))
	{
		arrayremovevalue(self._e_root.scenes, self);
		if(self._e_root.scenes.size == 0)
		{
			self._e_root.scenes = undefined;
		}
		self._e_root notify(#"scene_done", self._str_name);
		self._e_root.scene_played = 1;
	}
}

/*
	Name: has_init_state
	Namespace: cscene
	Checksum: 0x3D90F786
	Offset: 0x36E0
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function has_init_state()
{
	b_has_init_state = 0;
	foreach(var_79e3a313, o_scene_object in self._a_objects)
	{
		if([[ o_scene_object ]]->has_init_state())
		{
			b_has_init_state = 1;
			break;
		}
	}
	return b_has_init_state;
}

/*
	Name: _call_state_funcs
	Namespace: cscene
	Checksum: 0x24E99D13
	Offset: 0x3798
	Size: 0x3CE
	Parameters: 1
	Flags: Linked
*/
function _call_state_funcs(str_state)
{
	self endon(#"stopped");
	wait_till_scene_ready();
	if(str_state == "play")
	{
		waittillframeend();
	}
	level notify(self._str_name + "_" + str_state);
	if(isdefined(level.scene_funcs) && isdefined(level.scene_funcs[self._str_name]) && isdefined(level.scene_funcs[self._str_name][str_state]))
	{
		a_all_ents = get_ents();
		foreach(clientnum, a_ents in a_all_ents)
		{
			foreach(var_f13ae409, handler in level.scene_funcs[self._str_name][str_state])
			{
				func = handler[0];
				args = handler[1];
				switch(args.size)
				{
					case 6:
					{
						self._e_root thread [[func]](a_ents, args[0], args[1], args[2], args[3], args[4], args[5]);
						break;
					}
					case 5:
					{
						self._e_root thread [[func]](a_ents, args[0], args[1], args[2], args[3], args[4]);
						break;
					}
					case 4:
					{
						self._e_root thread [[func]](a_ents, args[0], args[1], args[2], args[3]);
						break;
					}
					case 3:
					{
						self._e_root thread [[func]](a_ents, args[0], args[1], args[2]);
						break;
					}
					case 2:
					{
						self._e_root thread [[func]](a_ents, args[0], args[1]);
						break;
					}
					case 1:
					{
						self._e_root thread [[func]](a_ents, args[0]);
						break;
					}
					case 0:
					{
						self._e_root thread [[func]](a_ents);
						break;
					}
					default:
					{
						/#
							assertmsg("");
						#/
					}
				}
			}
		}
	}
}

/*
	Name: get_ents
	Namespace: cscene
	Checksum: 0xA7AF3FE1
	Offset: 0x3B70
	Size: 0x1AE
	Parameters: 0
	Flags: Linked
*/
function get_ents()
{
	a_ents = [];
	for(clientnum = 0; clientnum < getmaxlocalclients(); clientnum++)
	{
		if(isdefined(getlocalplayer(clientnum)))
		{
			a_ents[clientnum] = [];
			foreach(var_6d102207, o_obj in self._a_objects)
			{
				ent = [[ o_obj ]]->get_ent(clientnum);
				if(isdefined(o_obj._s.name))
				{
					a_ents[clientnum][o_obj._s.name] = ent;
					continue;
				}
				if(!isdefined(a_ents))
				{
					a_ents = [];
				}
				else if(!isarray(a_ents))
				{
					a_ents = array(a_ents);
				}
				a_ents[a_ents.size] = ent;
			}
		}
	}
	return a_ents;
}

/*
	Name: get_root
	Namespace: cscene
	Checksum: 0xE82BCB26
	Offset: 0x3D28
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_root()
{
	return self._e_root;
}

/*
	Name: get_align_ent
	Namespace: cscene
	Checksum: 0x34BA963D
	Offset: 0x3D40
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function get_align_ent(clientnum)
{
	e_align = self._e_root;
	if(isdefined(self._s.aligntarget))
	{
		e_gdt_align = scene::get_existing_ent(clientnum, self._s.aligntarget);
		if(isdefined(e_gdt_align))
		{
			e_align = e_gdt_align;
		}
	}
	return e_align;
}

/*
	Name: allows_multiple
	Namespace: cscene
	Checksum: 0xB376D501
	Offset: 0x3DC8
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function allows_multiple()
{
	return isdefined(self._s.allowmultiple) && self._s.allowmultiple;
}

/*
	Name: is_looping
	Namespace: cscene
	Checksum: 0xF318E046
	Offset: 0x3DF8
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function is_looping()
{
	return isdefined(self._s.looping) && self._s.looping;
}

/*
	Name: wait_till_scene_ready
	Namespace: cscene
	Checksum: 0x69DC4DD6
	Offset: 0x3E28
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function wait_till_scene_ready()
{
	if(isdefined(self._a_objects))
	{
		array::flagsys_wait(self._a_objects, "ready");
	}
}

/*
	Name: wait_till_scene_done
	Namespace: cscene
	Checksum: 0x543BFC11
	Offset: 0x3E68
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function wait_till_scene_done()
{
	array::flagsys_wait(self._a_objects, "done");
}

/*
	Name: get_valid_objects
	Namespace: cscene
	Checksum: 0xFA5AD4C4
	Offset: 0x3E98
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function get_valid_objects()
{
	a_obj = [];
	foreach(var_917c3cbf, obj in self._a_objects)
	{
		if(obj._is_valid && !([[ obj ]]->in_a_different_scene()))
		{
			if(!isdefined(a_obj))
			{
				a_obj = [];
			}
			else if(!isarray(a_obj))
			{
				a_obj = array(a_obj);
			}
			a_obj[a_obj.size] = obj;
		}
	}
	return a_obj;
}

/*
	Name: on_error
	Namespace: cscene
	Checksum: 0x30D4688A
	Offset: 0x3FB0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function on_error()
{
	stop();
}

/*
	Name: get_state
	Namespace: cscene
	Checksum: 0xDB7643BE
	Offset: 0x3FD0
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_state()
{
	return self._str_state;
}

#namespace scene;

/*
	Name: cscene
	Namespace: scene
	Checksum: 0xC5A34294
	Offset: 0x3FE8
	Size: 0x686
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cscene()
{
	classes.cscene[0] = spawnstruct();
	classes.cscene[0].__vtable[-32002227] = &cscriptbundlebase::error;
	classes.cscene[0].__vtable[1621988813] = &cscriptbundlebase::log;
	classes.cscene[0].__vtable[713694985] = &cscriptbundlebase::remove_object;
	classes.cscene[0].__vtable[178798596] = &cscriptbundlebase::add_object;
	classes.cscene[0].__vtable[1440274456] = &cscriptbundlebase::is_testing;
	classes.cscene[0].__vtable[-512051494] = &cscriptbundlebase::get_objects;
	classes.cscene[0].__vtable[575565049] = &cscriptbundlebase::get_vm;
	classes.cscene[0].__vtable[245263499] = &cscriptbundlebase::get_name;
	classes.cscene[0].__vtable[1872615990] = &cscriptbundlebase::get_type;
	classes.cscene[0].__vtable[-1017222485] = &cscriptbundlebase::init;
	classes.cscene[0].__vtable[1606033458] = &cscriptbundlebase::__destructor;
	classes.cscene[0].__vtable[-1690805083] = &cscriptbundlebase::__constructor;
	classes.cscene[0].__vtable[-498584435] = &cscriptbundlebase::on_error;
	classes.cscene[0].__vtable[1194857509] = &cscene::get_state;
	classes.cscene[0].__vtable[-498584435] = &cscene::on_error;
	classes.cscene[0].__vtable[-241958475] = &cscene::get_valid_objects;
	classes.cscene[0].__vtable[-399287968] = &cscene::wait_till_scene_done;
	classes.cscene[0].__vtable[792158469] = &cscene::wait_till_scene_ready;
	classes.cscene[0].__vtable[17277842] = &cscene::is_looping;
	classes.cscene[0].__vtable[400356434] = &cscene::allows_multiple;
	classes.cscene[0].__vtable[1666938539] = &cscene::get_align_ent;
	classes.cscene[0].__vtable[1282680066] = &cscene::get_root;
	classes.cscene[0].__vtable[64630156] = &cscene::get_ents;
	classes.cscene[0].__vtable[415171386] = &cscene::_call_state_funcs;
	classes.cscene[0].__vtable[1064337886] = &cscene::has_init_state;
	classes.cscene[0].__vtable[-51025227] = &cscene::stop;
	classes.cscene[0].__vtable[-1243624088] = &cscene::run_next;
	classes.cscene[0].__vtable[1131512199] = &cscene::play;
	classes.cscene[0].__vtable[-1443067443] = &cscene::get_object_id;
	classes.cscene[0].__vtable[-422924033] = &cscene::initialize;
	classes.cscene[0].__vtable[-794265383] = &cscene::get_valid_object_defs;
	classes.cscene[0].__vtable[-1017222485] = &cscene::init;
	classes.cscene[0].__vtable[1606033458] = &cscene::__destructor;
	classes.cscene[0].__vtable[-1690805083] = &cscene::__constructor;
}

/*
	Name: get_existing_ent
	Namespace: scene
	Checksum: 0xF3679CA8
	Offset: 0x4678
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function get_existing_ent(clientnum, str_name)
{
	e = getent(clientnum, str_name, "animname");
	if(!isdefined(e))
	{
		e = getent(clientnum, str_name, "script_animname");
		if(!isdefined(e))
		{
			e = getent(clientnum, str_name, "targetname");
			if(!isdefined(e))
			{
				e = struct::get(str_name, "targetname");
			}
		}
	}
	return e;
}

/*
	Name: __init__sytem__
	Namespace: scene
	Checksum: 0xCE6A6039
	Offset: 0x4750
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("scene", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: scene
	Checksum: 0xF6F1967E
	Offset: 0x4798
	Size: 0x3BC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	a_scenedefs = struct::get_script_bundles("scene");
	level.server_scenes = [];
	foreach(var_9e0c33af, s_scenedef in a_scenedefs)
	{
		s_scenedef.editaction = undefined;
		s_scenedef.newobject = undefined;
		if(s_scenedef is_igc())
		{
			level.server_scenes[s_scenedef.name] = s_scenedef;
			continue;
		}
		if(s_scenedef.vmtype == "both")
		{
			n_clientbits = getminbitcountfornum(3);
			/#
				n_clientbits = getminbitcountfornum(6);
			#/
			clientfield::register("world", s_scenedef.name, 1, n_clientbits, "int", &cf_server_sync, 0, 0);
		}
	}
	clientfield::register("toplayer", "postfx_igc", 1, 2, "counter", &postfx_igc, 0, 0);
	clientfield::register("world", "in_igc", 1, 4, "int", &in_igc, 0, 0);
	clientfield::register("toplayer", "player_scene_skip_completed", 1, 2, "counter", &player_scene_skip_completed, 0, 0);
	clientfield::register("allplayers", "player_scene_animation_skip", 1, 2, "counter", &player_scene_animation_skip, 0, 0);
	clientfield::register("actor", "player_scene_animation_skip", 1, 2, "counter", &player_scene_animation_skip, 0, 0);
	clientfield::register("vehicle", "player_scene_animation_skip", 1, 2, "counter", &player_scene_animation_skip, 0, 0);
	clientfield::register("scriptmover", "player_scene_animation_skip", 1, 2, "counter", &player_scene_animation_skip, 0, 0);
	level.scene_object_id = 0;
	level.active_scenes = [];
	callback::on_localclient_shutdown(&on_localplayer_shutdown);
}

/*
	Name: in_igc
	Namespace: scene
	Checksum: 0xA99E32
	Offset: 0x4B60
	Size: 0xD0
	Parameters: 7
	Flags: Linked
*/
function in_igc(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	player = getlocalplayer(localclientnum);
	n_entnum = player getentitynumber();
	b_igc_active = 0;
	if(newval & 1 << n_entnum)
	{
		b_igc_active = 1;
	}
	igcactive(localclientnum, b_igc_active);
	/#
	#/
}

/*
	Name: on_localplayer_shutdown
	Namespace: scene
	Checksum: 0x8BD9BB9B
	Offset: 0x4C38
	Size: 0xDC
	Parameters: 1
	Flags: Linked, Private
*/
private function on_localplayer_shutdown(localclientnum)
{
	localplayer = self;
	codelocalplayer = getlocalplayer(localclientnum);
	if(isdefined(localplayer) && isdefined(localplayer.localclientnum) && isdefined(codelocalplayer) && localplayer == codelocalplayer)
	{
		filter::disable_filter_base_frame_transition(localplayer, 5);
		filter::disable_filter_sprite_transition(localplayer, 5);
		filter::disable_filter_frame_transition(localplayer, 5);
		localplayer.postfx_igc_on = undefined;
		localplayer.pstfx_world_construction = 0;
	}
}

/*
	Name: postfx_igc
	Namespace: scene
	Checksum: 0xE77C235B
	Offset: 0x4D20
	Size: 0x1096
	Parameters: 7
	Flags: Linked
*/
function postfx_igc(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(isdefined(self.postfx_igc_on) && self.postfx_igc_on)
	{
		return;
	}
	if(sessionmodeiszombiesgame())
	{
		postfx_igc_zombies(localclientnum);
		return;
	}
	if(newval == 3)
	{
		self thread postfx_igc_short(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
		return;
	}
	self.postfx_igc_on = 1;
	codeimagename = "postfx_igc_image" + localclientnum;
	createscenecodeimage(localclientnum, codeimagename);
	captureframe(localclientnum, codeimagename);
	filter::init_filter_base_frame_transition(self);
	filter::init_filter_sprite_transition(self);
	filter::init_filter_frame_transition(self);
	setfilterpasscodetexture(localclientnum, 5, 0, 0, codeimagename);
	setfilterpasscodetexture(localclientnum, 5, 1, 0, codeimagename);
	setfilterpasscodetexture(localclientnum, 5, 2, 0, codeimagename);
	filter::enable_filter_base_frame_transition(self, 5);
	filter::enable_filter_sprite_transition(self, 5);
	filter::enable_filter_frame_transition(self, 5);
	filter::set_filter_base_frame_transition_warp(self, 5, 1);
	filter::set_filter_base_frame_transition_boost(self, 5, 0.5);
	filter::set_filter_base_frame_transition_durden(self, 5, 1);
	filter::set_filter_base_frame_transition_durden_blur(self, 5, 1);
	filter::set_filter_sprite_transition_elapsed(self, 5, 0);
	filter::set_filter_sprite_transition_octogons(self, 5, 1);
	filter::set_filter_sprite_transition_blur(self, 5, 0);
	filter::set_filter_sprite_transition_boost(self, 5, 0);
	filter::set_filter_frame_transition_light_hexagons(self, 5, 0);
	filter::set_filter_frame_transition_heavy_hexagons(self, 5, 0);
	filter::set_filter_frame_transition_flare(self, 5, 0);
	filter::set_filter_frame_transition_blur(self, 5, 0);
	filter::set_filter_frame_transition_iris(self, 5, 0);
	filter::set_filter_frame_transition_saved_frame_reveal(self, 5, 0);
	filter::set_filter_frame_transition_warp(self, 5, 0);
	filter::set_filter_sprite_transition_move_radii(self, 5, 0, 0);
	filter::set_filter_base_frame_transition_warp(self, 5, 1);
	filter::set_filter_base_frame_transition_boost(self, 5, 1);
	n_hex = 0;
	b_streamer_wait = 1;
	i = 0;
	while(i < 2000)
	{
		st = i / 1000;
		if(b_streamer_wait && st >= 0.65)
		{
			n_streamer_time_total = 0;
			while(!isstreamerready() && n_streamer_time_total < 5000)
			{
				n_streamer_time = gettime();
				j = 650;
				while(j < 1150)
				{
					jt = j / 1000;
					filter::set_filter_frame_transition_heavy_hexagons(self, 5, mapfloat(0.65, 1.15, 0, 1, jt));
					wait(0.016);
					j = j + 16;
				}
				j = 1150;
				while(j < 650)
				{
					jt = j / 1000;
					filter::set_filter_frame_transition_heavy_hexagons(self, 5, mapfloat(0.65, 1.15, 0, 1, jt));
					wait(0.016);
					j = j - 16;
				}
				n_streamer_time_total = n_streamer_time_total + gettime() - n_streamer_time;
			}
			b_streamer_wait = 0;
		}
		if(st <= 0.5)
		{
			filter::set_filter_frame_transition_iris(self, 5, mapfloat(0, 0.5, 0, 1, st));
		}
		else if(st > 0.5 && st <= 0.85)
		{
			filter::set_filter_frame_transition_iris(self, 5, 1 - mapfloat(0.5, 0.85, 0, 1, st));
		}
		else
		{
			filter::set_filter_frame_transition_iris(self, 5, 0);
		}
		if(newval == 2)
		{
			if(st > 1 && (!(isdefined(self.pstfx_world_construction) && self.pstfx_world_construction)))
			{
				self thread postfx::playpostfxbundle("pstfx_world_construction");
				self.pstfx_world_construction = 1;
			}
		}
		if(st > 0.5 && st <= 1)
		{
			n_hex = mapfloat(0.5, 1, 0, 1, st);
			filter::set_filter_frame_transition_light_hexagons(self, 5, n_hex);
			if(st >= 0.8)
			{
				filter::set_filter_frame_transition_flare(self, 5, mapfloat(0.8, 1, 0, 1, st));
			}
		}
		else if(st > 1 && st < 1.5)
		{
			filter::set_filter_frame_transition_light_hexagons(self, 5, 1);
			filter::set_filter_frame_transition_flare(self, 5, 1);
		}
		else
		{
			filter::set_filter_frame_transition_light_hexagons(self, 5, 0);
			filter::set_filter_frame_transition_flare(self, 5, 0);
		}
		if(st > 0.65 && st <= 1.15)
		{
			filter::set_filter_frame_transition_heavy_hexagons(self, 5, mapfloat(0.65, 1.15, 0, 1, st));
		}
		else if(st > 1.21 && st < 1.5)
		{
			filter::set_filter_frame_transition_heavy_hexagons(self, 5, 1);
		}
		else
		{
			filter::set_filter_frame_transition_heavy_hexagons(self, 5, 0);
		}
		if(st > 1.21 && st <= 1.5)
		{
			filter::set_filter_frame_transition_blur(self, 5, mapfloat(1, 1.5, 0, 1, st));
			filter::set_filter_sprite_transition_boost(self, 5, mapfloat(1, 1.5, 0, 1, st));
			filter::set_filter_frame_transition_saved_frame_reveal(self, 5, mapfloat(1, 1.5, 0, 1, st));
			filter::set_filter_base_frame_transition_durden_blur(self, 5, 1 - mapfloat(1, 1.5, 0, 1, st));
			filter::set_filter_sprite_transition_blur(self, 5, mapfloat(1, 1.5, 0, 0.1, st));
		}
		else if(st > 1.5)
		{
			filter::set_filter_frame_transition_blur(self, 5, 1);
			filter::set_filter_sprite_transition_boost(self, 5, 1);
			filter::set_filter_frame_transition_saved_frame_reveal(self, 5, 1);
			filter::set_filter_base_frame_transition_durden_blur(self, 5, 0);
			filter::set_filter_sprite_transition_blur(self, 5, 0.1);
		}
		if(st > 1 && st <= 1.45)
		{
			filter::set_filter_base_frame_transition_boost(self, 5, mapfloat(1, 1.45, 0.5, 1, st));
		}
		else if(st > 1.45 && st < 1.75)
		{
			filter::set_filter_base_frame_transition_boost(self, 5, 1);
		}
		else if(st >= 1.75)
		{
			filter::set_filter_base_frame_transition_boost(self, 5, 1 - mapfloat(1.75, 2, 0, 1, st));
		}
		if(st >= 1.75)
		{
			val = 1 - mapfloat(1.75, 2, 0, 1, st);
			filter::set_filter_frame_transition_blur(self, 5, val);
			filter::set_filter_base_frame_transition_warp(self, 5, val);
		}
		if(st >= 1.25)
		{
			val = 1 - mapfloat(1.25, 1.75, 0, 1, st);
			filter::set_filter_sprite_transition_octogons(self, 5, val);
		}
		if(st >= 1.75 && st < 2)
		{
			filter::set_filter_base_frame_transition_durden(self, 5, 1 - mapfloat(1.75, 2, 0, 1, st));
		}
		if(st > 1)
		{
			filter::set_filter_sprite_transition_elapsed(self, 5, i - 1000);
			outer_radii = mapfloat(1, 1.5, 0, 2000, st);
			filter::set_filter_sprite_transition_move_radii(self, 5, outer_radii - 256, outer_radii);
		}
		if(st > 1.15 && st < 1.85)
		{
			filter::set_filter_frame_transition_warp(self, 5, -1 * mapfloat(1.15, 1.85, 0, 1, st));
		}
		else if(st >= 1.85)
		{
			filter::set_filter_frame_transition_warp(self, 5, -1 * 1 - mapfloat(1.85, 2, 0, 1, st));
		}
		wait(0.016);
		i = i + 16;
	}
	filter::disable_filter_base_frame_transition(self, 5);
	filter::disable_filter_sprite_transition(self, 5);
	filter::disable_filter_frame_transition(self, 5);
	self.pstfx_world_construction = 0;
	freecodeimage(localclientnum, codeimagename);
	self.postfx_igc_on = undefined;
}

/*
	Name: postfx_igc_zombies
	Namespace: scene
	Checksum: 0x75FBB1F6
	Offset: 0x5DC0
	Size: 0x56
	Parameters: 1
	Flags: Linked
*/
function postfx_igc_zombies(localclientnum)
{
	lui::screen_fade_out(0, "black");
	wait(0.016);
	lui::screen_fade_in(0.3);
	self.postfx_igc_on = undefined;
}

/*
	Name: postfx_igc_short
	Namespace: scene
	Checksum: 0xAAC913F6
	Offset: 0x5E20
	Size: 0x386
	Parameters: 7
	Flags: Linked
*/
function postfx_igc_short(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self.postfx_igc_on = 1;
	codeimagename = "postfx_igc_image" + localclientnum;
	createscenecodeimage(localclientnum, codeimagename);
	captureframe(localclientnum, codeimagename);
	filter::init_filter_base_frame_transition(self);
	filter::init_filter_sprite_transition(self);
	filter::init_filter_frame_transition(self);
	setfilterpasscodetexture(localclientnum, 5, 0, 0, codeimagename);
	setfilterpasscodetexture(localclientnum, 5, 1, 0, codeimagename);
	setfilterpasscodetexture(localclientnum, 5, 2, 0, codeimagename);
	filter::enable_filter_base_frame_transition(self, 5);
	filter::enable_filter_sprite_transition(self, 5);
	filter::enable_filter_frame_transition(self, 5);
	filter::set_filter_frame_transition_iris(self, 5, 0);
	b_streamer_wait = 1;
	i = 0;
	while(i < 850)
	{
		st = i / 1000;
		if(st <= 0.5)
		{
			filter::set_filter_frame_transition_iris(self, 5, mapfloat(0, 0.5, 0, 1, st));
		}
		else if(st > 0.5 && st <= 0.85)
		{
			filter::set_filter_frame_transition_iris(self, 5, 1 - mapfloat(0.5, 0.85, 0, 1, st));
		}
		else
		{
			filter::set_filter_frame_transition_iris(self, 5, 0);
		}
		wait(0.016);
		i = i + 16;
	}
	filter::disable_filter_base_frame_transition(self, 5);
	filter::disable_filter_sprite_transition(self, 5);
	filter::disable_filter_frame_transition(self, 5);
	freecodeimage(localclientnum, codeimagename);
	self.postfx_igc_on = undefined;
}

/*
	Name: cf_server_sync
	Namespace: scene
	Checksum: 0xF8235B94
	Offset: 0x61B0
	Size: 0x196
	Parameters: 7
	Flags: Linked
*/
function cf_server_sync(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 0:
		{
			if(is_active(fieldname))
			{
				level thread stop(fieldname);
			}
			break;
		}
		case 1:
		{
			level thread init(fieldname);
			break;
		}
		case 2:
		{
			level thread play(fieldname);
			break;
		}
	}
	/#
		switch(newval)
		{
			case 3:
			{
				if(is_active(fieldname))
				{
					level thread stop(fieldname, 1, undefined, undefined, 1);
				}
				break;
			}
			case 4:
			{
				level thread init(fieldname, undefined, undefined, 1);
				break;
			}
			case 5:
			{
				level thread play(fieldname, undefined, undefined, 1);
				break;
			}
		}
	#/
}

/*
	Name: remove_invalid_scene_objects
	Namespace: scene
	Checksum: 0xAC0EC652
	Offset: 0x6350
	Size: 0x16A
	Parameters: 1
	Flags: Linked
*/
function remove_invalid_scene_objects(s_scenedef)
{
	a_invalid_object_indexes = [];
	foreach(i, s_object in s_scenedef.objects)
	{
		if(!isdefined(s_object.name) && !isdefined(s_object.model))
		{
			if(!isdefined(a_invalid_object_indexes))
			{
				a_invalid_object_indexes = [];
			}
			else if(!isarray(a_invalid_object_indexes))
			{
				a_invalid_object_indexes = array(a_invalid_object_indexes);
			}
			a_invalid_object_indexes[a_invalid_object_indexes.size] = i;
		}
	}
	for(i = a_invalid_object_indexes.size - 1; i >= 0; i--)
	{
		arrayremoveindex(s_scenedef.objects, a_invalid_object_indexes[i]);
	}
	return s_scenedef;
}

/*
	Name: is_igc
	Namespace: scene
	Checksum: 0x259FB470
	Offset: 0x64C8
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function is_igc()
{
	return isstring(self.cameraswitcher) || isstring(self.extracamswitcher1) || isstring(self.extracamswitcher2) || isstring(self.extracamswitcher3) || isstring(self.extracamswitcher4);
}

/*
	Name: __main__
	Namespace: scene
	Checksum: 0x6B8262B2
	Offset: 0x6550
	Size: 0x2DA
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	wait(0.05);
	if(isdefined(level.disablefxaniminsplitscreencount))
	{
		if(isdefined(level.localplayers))
		{
			if(level.localplayers.size >= level.disablefxaniminsplitscreencount)
			{
				return;
			}
		}
	}
	a_instances = arraycombine(struct::get_array("scriptbundle_scene", "classname"), struct::get_array("scriptbundle_fxanim", "classname"), 0, 0);
	foreach(var_5fd567c6, s_instance in a_instances)
	{
	}
	foreach(var_84fb7a86, s_instance in a_instances)
	{
		s_scenedef = struct::get_script_bundle("scene", s_instance.scriptbundlename);
		/#
			assert(isdefined(s_scenedef), "" + s_instance.origin + "" + s_instance.scriptbundlename + "");
		#/
		if(s_scenedef.vmtype == "client")
		{
			if(isdefined(level.var_283122e6) && [[level.var_283122e6]](s_instance.scriptbundlename))
			{
				continue;
			}
			if(isdefined(s_instance.spawnflags) && s_instance.spawnflags & 2 == 2)
			{
				s_instance thread play();
				continue;
			}
			if(isdefined(s_instance.spawnflags) && s_instance.spawnflags & 1 == 1)
			{
				s_instance thread init();
			}
		}
	}
}

/*
	Name: _trigger_init
	Namespace: scene
	Checksum: 0xD2FB4DFF
	Offset: 0x6838
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function _trigger_init(trig)
{
	trig endon(#"entityshutdown");
	trig waittill(#"trigger");
	_init_instance();
}

/*
	Name: _trigger_play
	Namespace: scene
	Checksum: 0x314CD7B2
	Offset: 0x6880
	Size: 0x86
	Parameters: 1
	Flags: None
*/
function _trigger_play(trig)
{
	trig endon(#"entityshutdown");
	do
	{
		trig waittill(#"trigger");
		_play_instance();
	}
	while(isdefined(get_scenedef(self.scriptbundlename).looping) && get_scenedef(self.scriptbundlename).looping);
}

/*
	Name: _trigger_stop
	Namespace: scene
	Checksum: 0xDC027431
	Offset: 0x6910
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function _trigger_stop(trig)
{
	trig endon(#"entityshutdown");
	trig waittill(#"trigger");
	_stop_instance();
}

/*
	Name: add_scene_func
	Namespace: scene
	Checksum: 0xCA6922F0
	Offset: 0x6958
	Size: 0x19E
	Parameters: 4
	Flags: Linked, Variadic
*/
function add_scene_func(str_scenedef, func, str_state = "play", vararg)
{
	/#
		/#
			assert(isdefined(get_scenedef(str_scenedef)), "" + str_scenedef + "");
		#/
	#/
	if(!isdefined(level.scene_funcs))
	{
		level.scene_funcs = [];
	}
	if(!isdefined(level.scene_funcs[str_scenedef]))
	{
		level.scene_funcs[str_scenedef] = [];
	}
	if(!isdefined(level.scene_funcs[str_scenedef][str_state]))
	{
		level.scene_funcs[str_scenedef][str_state] = [];
	}
	else if(!isarray(level.scene_funcs[str_scenedef][str_state]))
	{
		level.scene_funcs[str_scenedef][str_state] = array(level.scene_funcs[str_scenedef][str_state]);
	}
	level.scene_funcs[str_scenedef][str_state][level.scene_funcs[str_scenedef][str_state].size] = array(func, vararg);
}

/*
	Name: remove_scene_func
	Namespace: scene
	Checksum: 0x3F26A687
	Offset: 0x6B00
	Size: 0x14E
	Parameters: 3
	Flags: None
*/
function remove_scene_func(str_scenedef, func, str_state = "play")
{
	/#
		/#
			assert(isdefined(get_scenedef(str_scenedef)), "" + str_scenedef + "");
		#/
	#/
	if(!isdefined(level.scene_funcs))
	{
		level.scene_funcs = [];
	}
	if(isdefined(level.scene_funcs[str_scenedef]) && isdefined(level.scene_funcs[str_scenedef][str_state]))
	{
		for(i = level.scene_funcs[str_scenedef][str_state].size - 1; i >= 0; i--)
		{
			if(level.scene_funcs[str_scenedef][str_state][i][0] == func)
			{
				arrayremoveindex(level.scene_funcs[str_scenedef][str_state], i);
			}
		}
	}
}

/*
	Name: spawn
	Namespace: scene
	Checksum: 0x5750D335
	Offset: 0x6C58
	Size: 0x1A8
	Parameters: 5
	Flags: None
*/
function spawn(arg1, arg2, arg3, arg4, b_test_run)
{
	str_scenedef = arg1;
	/#
		assert(isdefined(str_scenedef), "");
	#/
	if(isvec(arg2))
	{
		v_origin = arg2;
		v_angles = arg3;
		a_ents = arg4;
	}
	else
	{
		a_ents = arg2;
		v_origin = arg3;
		v_angles = arg4;
	}
	s_instance = spawnstruct();
	s_instance.origin = (isdefined(v_origin) ? v_origin : (0, 0, 0));
	s_instance.angles = (isdefined(v_angles) ? v_angles : (0, 0, 0));
	s_instance.classname = "scriptbundle_scene";
	s_instance.scriptbundlename = str_scenedef;
	s_instance struct::init();
	s_instance init(str_scenedef, a_ents, undefined, b_test_run);
	return s_instance;
}

/*
	Name: init
	Namespace: scene
	Checksum: 0xCBA0D410
	Offset: 0x6E08
	Size: 0x298
	Parameters: 4
	Flags: Linked
*/
function init(arg1, arg2, arg3, b_test_run)
{
	if(self == level)
	{
		if(isstring(arg1))
		{
			if(isstring(arg2))
			{
				str_value = arg1;
				str_key = arg2;
				a_ents = arg3;
			}
			else
			{
				str_value = arg1;
				a_ents = arg2;
			}
			if(isdefined(str_key))
			{
				a_instances = struct::get_array(str_value, str_key);
				/#
					/#
						assert(a_instances.size, "" + str_key + "" + str_value + "");
					#/
				#/
			}
			else
			{
				a_instances = struct::get_array(str_value, "targetname");
				if(!a_instances.size)
				{
					a_instances = struct::get_array(str_value, "scriptbundlename");
				}
			}
			if(!a_instances.size)
			{
				_init_instance(str_value, a_ents, b_test_run);
			}
			else
			{
				foreach(var_3d968a3b, s_instance in a_instances)
				{
					if(isdefined(s_instance))
					{
						s_instance thread _init_instance(undefined, a_ents, b_test_run);
					}
				}
			}
		}
	}
	else if(isstring(arg1))
	{
		_init_instance(arg1, arg2, b_test_run);
	}
	else
	{
		_init_instance(arg2, arg1, b_test_run);
	}
	return self;
}

/*
	Name: get_scenedef
	Namespace: scene
	Checksum: 0xC44FF642
	Offset: 0x70A8
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function get_scenedef(str_scenedef)
{
	return struct::get_script_bundle("scene", str_scenedef);
}

/*
	Name: get_scenedefs
	Namespace: scene
	Checksum: 0x6C5F10DA
	Offset: 0x70E0
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function get_scenedefs(str_type = "scene")
{
	a_scenedefs = [];
	foreach(var_3ced29f8, s_scenedef in struct::get_script_bundles("scene"))
	{
		if(s_scenedef.scenetype == str_type)
		{
			if(!isdefined(a_scenedefs))
			{
				a_scenedefs = [];
			}
			else if(!isarray(a_scenedefs))
			{
				a_scenedefs = array(a_scenedefs);
			}
			a_scenedefs[a_scenedefs.size] = s_scenedef;
		}
	}
	return a_scenedefs;
}

/*
	Name: _init_instance
	Namespace: scene
	Checksum: 0x31F219CA
	Offset: 0x7218
	Size: 0x1BC
	Parameters: 3
	Flags: Linked
*/
function _init_instance(str_scenedef = self.scriptbundlename, a_ents, b_test_run = 0)
{
	s_bundle = get_scenedef(str_scenedef);
	/#
		/#
			assert(isdefined(str_scenedef), "" + (isdefined(self.origin) ? self.origin : "") + "");
		#/
		/#
			assert(isdefined(s_bundle), "" + (isdefined(self.origin) ? self.origin : "") + "" + str_scenedef + "");
		#/
	#/
	o_scene = get_active_scene(str_scenedef);
	if(isdefined(o_scene))
	{
		if(isdefined(self.scriptbundlename) && !b_test_run)
		{
			return o_scene;
		}
		thread [[ o_scene ]]->initialize(1);
	}
	else
	{
		object = new cscene();
		[[ object ]]->__constructor();
		o_scene = object;
		[[ o_scene ]]->init(str_scenedef, s_bundle, self, a_ents, b_test_run);
	}
	return o_scene;
}

/*
	Name: play
	Namespace: scene
	Checksum: 0x9DA0CD6A
	Offset: 0x73E0
	Size: 0x3BC
	Parameters: 5
	Flags: Linked
*/
function play(arg1, arg2, arg3, b_test_run = 0, str_mode = "")
{
	s_tracker = spawnstruct();
	s_tracker.n_scene_count = 1;
	if(self == level)
	{
		if(isstring(arg1))
		{
			if(isstring(arg2))
			{
				str_value = arg1;
				str_key = arg2;
				a_ents = arg3;
			}
			else
			{
				str_value = arg1;
				a_ents = arg2;
			}
			str_scenedef = str_value;
			if(isdefined(str_key))
			{
				a_instances = struct::get_array(str_value, str_key);
				str_scenedef = undefined;
				/#
					/#
						assert(a_instances.size, "" + str_key + "" + str_value + "");
					#/
				#/
			}
			else
			{
				a_instances = struct::get_array(str_value, "targetname");
				if(!a_instances.size)
				{
					a_instances = struct::get_array(str_value, "scriptbundlename");
				}
				else
				{
					str_scenedef = undefined;
				}
			}
			if(isdefined(str_scenedef))
			{
				a_active_instances = get_active_scenes(str_scenedef);
				a_instances = arraycombine(a_active_instances, a_instances, 0, 0);
			}
			if(!a_instances.size)
			{
				self thread _play_instance(s_tracker, str_scenedef, a_ents, b_test_run, str_mode);
			}
			else
			{
				s_tracker.n_scene_count = a_instances.size;
				foreach(var_c8315da4, s_instance in a_instances)
				{
					if(isdefined(s_instance))
					{
						s_instance thread _play_instance(s_tracker, str_scenedef, a_ents, b_test_run, str_mode);
					}
				}
			}
		}
	}
	else if(isstring(arg1))
	{
		self thread _play_instance(s_tracker, arg1, arg2, b_test_run, str_mode);
	}
	else
	{
		self thread _play_instance(s_tracker, arg2, arg1, b_test_run, str_mode);
	}
	waittill_scene_done(s_tracker);
}

/*
	Name: waittill_scene_done
	Namespace: scene
	Checksum: 0x43CD7EA2
	Offset: 0x77A8
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
private function waittill_scene_done(s_tracker)
{
	level endon(#"demo_jump");
	for(i = 0; i < s_tracker.n_scene_count; i++)
	{
		s_tracker waittill(#"scene_done");
	}
}

/*
	Name: _play_instance
	Namespace: scene
	Checksum: 0xF0B42825
	Offset: 0x7808
	Size: 0x150
	Parameters: 5
	Flags: Linked
*/
function _play_instance(s_tracker, str_scenedef = self.scriptbundlename, a_ents, b_test_run, str_mode)
{
	if(self.scriptbundlename === str_scenedef)
	{
		str_scenedef = self.scriptbundlename;
		self.scene_played = 1;
	}
	o_scene = _init_instance(str_scenedef, a_ents, b_test_run);
	if(isdefined(o_scene))
	{
		thread [[ o_scene ]]->play(b_test_run, str_mode);
	}
	self waittill_instance_scene_done(str_scenedef);
	if(isdefined(self))
	{
		if(isdefined(self.scriptbundlename) && (isdefined(get_scenedef(self.scriptbundlename).looping) && get_scenedef(self.scriptbundlename).looping))
		{
			self.scene_played = 0;
		}
	}
	s_tracker notify(#"scene_done");
}

/*
	Name: waittill_instance_scene_done
	Namespace: scene
	Checksum: 0x6867A7DA
	Offset: 0x7960
	Size: 0x2A
	Parameters: 1
	Flags: Linked, Private
*/
private function waittill_instance_scene_done(str_scenedef)
{
	level endon(#"demo_jump");
	self waittill_match(#"scene_done");
}

/*
	Name: stop
	Namespace: scene
	Checksum: 0xE6F7D47B
	Offset: 0x7998
	Size: 0x2AC
	Parameters: 5
	Flags: Linked
*/
function stop(arg1, arg2, arg3, b_cancel, b_no_assert = 0)
{
	if(self == level)
	{
		if(isstring(arg1))
		{
			if(isstring(arg2))
			{
				str_value = arg1;
				str_key = arg2;
				b_clear = arg3;
			}
			else
			{
				str_value = arg1;
				b_clear = arg2;
			}
			if(isdefined(str_key))
			{
				a_instances = struct::get_array(str_value, str_key);
				/#
					/#
						assert(b_no_assert || a_instances.size, "" + str_key + "" + str_value + "");
					#/
				#/
				str_value = undefined;
			}
			else
			{
				a_instances = struct::get_array(str_value, "targetname");
				if(!a_instances.size)
				{
					a_instances = get_active_scenes(str_value);
				}
				else
				{
					str_value = undefined;
				}
			}
			foreach(var_71d5773f, s_instance in arraycopy(a_instances))
			{
				if(isdefined(s_instance))
				{
					s_instance _stop_instance(b_clear, str_value, b_cancel);
				}
			}
		}
	}
	else if(isstring(arg1))
	{
		_stop_instance(arg2, arg1, b_cancel);
	}
	else
	{
		_stop_instance(arg1, arg2, b_cancel);
	}
}

/*
	Name: _stop_instance
	Namespace: scene
	Checksum: 0xBB55AE47
	Offset: 0x7C50
	Size: 0x11E
	Parameters: 3
	Flags: Linked
*/
function _stop_instance(b_clear = 0, str_scenedef, b_cancel = 0)
{
	if(isdefined(self.scenes))
	{
		foreach(var_c3c2471a, o_scene in arraycopy(self.scenes))
		{
			str_scene_name = [[ o_scene ]]->get_name();
			if(!isdefined(str_scenedef) || str_scene_name == str_scenedef)
			{
				thread [[ o_scene ]]->stop(b_clear, b_cancel);
			}
		}
	}
}

/*
	Name: cancel
	Namespace: scene
	Checksum: 0xF50F7A1A
	Offset: 0x7D78
	Size: 0x3C
	Parameters: 3
	Flags: None
*/
function cancel(arg1, arg2, arg3)
{
	stop(arg1, arg2, arg3, 1);
}

/*
	Name: has_init_state
	Namespace: scene
	Checksum: 0x65A90505
	Offset: 0x7DC0
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function has_init_state(str_scenedef)
{
	s_scenedef = get_scenedef(str_scenedef);
	foreach(var_b1a828c9, s_obj in s_scenedef.objects)
	{
		if(!(isdefined(s_obj.disabled) && s_obj.disabled) && s_obj _has_init_state())
		{
			return 1;
		}
	}
	return 0;
}

/*
	Name: _has_init_state
	Namespace: scene
	Checksum: 0xF51E0C3B
	Offset: 0x7EB8
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function _has_init_state()
{
	return isdefined(self.spawnoninit) && self.spawnoninit || isdefined(self.initanim) || isdefined(self.initanimloop) || (isdefined(self.firstframe) && self.firstframe);
}

/*
	Name: get_prop_count
	Namespace: scene
	Checksum: 0x33D116EF
	Offset: 0x7F08
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function get_prop_count(str_scenedef)
{
	return _get_type_count("prop", str_scenedef);
}

/*
	Name: get_vehicle_count
	Namespace: scene
	Checksum: 0x2A373B43
	Offset: 0x7F40
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function get_vehicle_count(str_scenedef)
{
	return _get_type_count("vehicle", str_scenedef);
}

/*
	Name: get_actor_count
	Namespace: scene
	Checksum: 0x28CE90AF
	Offset: 0x7F78
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function get_actor_count(str_scenedef)
{
	return _get_type_count("actor", str_scenedef);
}

/*
	Name: get_player_count
	Namespace: scene
	Checksum: 0x24EE00F3
	Offset: 0x7FB0
	Size: 0x2A
	Parameters: 1
	Flags: None
*/
function get_player_count(str_scenedef)
{
	return _get_type_count("player", str_scenedef);
}

/*
	Name: _get_type_count
	Namespace: scene
	Checksum: 0xB865B883
	Offset: 0x7FE8
	Size: 0x138
	Parameters: 2
	Flags: Linked
*/
function _get_type_count(str_type, str_scenedef)
{
	s_scenedef = (isdefined(str_scenedef) ? get_scenedef(str_scenedef) : get_scenedef(self.scriptbundlename));
	n_count = 0;
	foreach(var_7ca84b55, s_obj in s_scenedef.objects)
	{
		if(isdefined(s_obj.type))
		{
			if(tolower(s_obj.type) == tolower(str_type))
			{
				n_count++;
			}
		}
	}
	return n_count;
}

/*
	Name: is_active
	Namespace: scene
	Checksum: 0x53AE60E5
	Offset: 0x8128
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function is_active(str_scenedef)
{
	if(self == level)
	{
		return get_active_scenes(str_scenedef).size > 0;
	}
	return isdefined(get_active_scene(str_scenedef));
}

/*
	Name: is_playing
	Namespace: scene
	Checksum: 0xF9A181B8
	Offset: 0x8180
	Size: 0x94
	Parameters: 1
	Flags: None
*/
function is_playing(str_scenedef)
{
	if(self == level)
	{
		return level flagsys::get(str_scenedef + "_playing");
	}
	if(!isdefined(str_scenedef))
	{
		str_scenedef = self.scriptbundlename;
	}
	o_scene = get_active_scene(str_scenedef);
	if(isdefined(o_scene))
	{
		return o_scene._str_state === "play";
	}
	return 0;
}

/*
	Name: get_active_scenes
	Namespace: scene
	Checksum: 0x97AC7EE9
	Offset: 0x8220
	Size: 0x102
	Parameters: 1
	Flags: Linked
*/
function get_active_scenes(str_scenedef)
{
	if(!isdefined(level.active_scenes))
	{
		level.active_scenes = [];
	}
	if(isdefined(str_scenedef))
	{
		return (isdefined(level.active_scenes[str_scenedef]) ? level.active_scenes[str_scenedef] : []);
	}
	a_active_scenes = [];
	foreach(str_scenedef, _ in level.active_scenes)
	{
		a_active_scenes = arraycombine(a_active_scenes, level.active_scenes[str_scenedef], 0, 0);
	}
	return a_active_scenes;
}

/*
	Name: get_active_scene
	Namespace: scene
	Checksum: 0xF7F21354
	Offset: 0x8330
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function get_active_scene(str_scenedef)
{
	if(isdefined(str_scenedef) && isdefined(self.scenes))
	{
		foreach(var_596d20e0, o_scene in self.scenes)
		{
			if([[ o_scene ]]->get_name() == str_scenedef)
			{
				return o_scene;
			}
		}
	}
}

/*
	Name: is_capture_mode
	Namespace: scene
	Checksum: 0x7EDA69AC
	Offset: 0x83F0
	Size: 0x5A
	Parameters: 0
	Flags: None
*/
function is_capture_mode()
{
	str_mode = getdvarstring("scene_menu_mode", "default");
	if(issubstr(str_mode, "capture"))
	{
		return 1;
	}
	return 0;
}

