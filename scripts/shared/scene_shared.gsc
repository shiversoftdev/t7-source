// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scene_debug_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\scriptbundle_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using_animtree("all_player");
#using_animtree("generic");

#namespace scene;

/*
	Name: prepare_player_model_anim
	Namespace: scene
	Checksum: 0xCC50C126
	Offset: 0xBA0
	Size: 0x58
	Parameters: 1
	Flags: Linked, Private
*/
private function prepare_player_model_anim(ent)
{
	if(!ent.animtree === "all_player")
	{
		ent useanimtree($all_player);
		ent.animtree = "all_player";
	}
}

/*
	Name: prepare_generic_model_anim
	Namespace: scene
	Checksum: 0x60E80E8A
	Offset: 0xC00
	Size: 0x58
	Parameters: 1
	Flags: Linked, Private
*/
private function prepare_generic_model_anim(ent)
{
	if(!ent.animtree === "generic")
	{
		ent useanimtree($generic);
		ent.animtree = "generic";
	}
}

#namespace csceneobject;

/*
	Name: __constructor
	Namespace: csceneobject
	Checksum: 0xBD185AF2
	Offset: 0xC60
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	cscriptbundleobjectbase::__constructor();
	self._is_valid = 1;
	self._b_spawnonce_used = 0;
	self._b_set_goal = 1;
}

/*
	Name: __destructor
	Namespace: csceneobject
	Checksum: 0xFA65860E
	Offset: 0xCA0
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
	Checksum: 0x67F8A621
	Offset: 0xCC0
	Size: 0x4E
	Parameters: 3
	Flags: Linked
*/
function first_init(s_objdef, o_scene, e_ent)
{
	cscriptbundleobjectbase::init(s_objdef, o_scene, e_ent);
	_assign_unique_name();
	return self;
}

/*
	Name: initialize
	Namespace: csceneobject
	Checksum: 0x49D97A04
	Offset: 0xD18
	Size: 0x444
	Parameters: 1
	Flags: Linked
*/
function initialize(b_force_first_frame = 0)
{
	if(has_init_state() || b_force_first_frame)
	{
		flagsys::clear("ready");
		flagsys::clear("done");
		flagsys::clear("main_done");
		self._str_state = "init";
		self notify(#"new_state");
		self endon(#"new_state");
		self notify(#"init");
		cscriptbundleobjectbase::log("init");
		waittillframeend();
		if(!(isdefined(self._s.sharedigc) && self._s.sharedigc) && (!(isdefined(self._s.player) && self._s.player)) && (isdefined(self._s.spawnoninit) && self._s.spawnoninit) || b_force_first_frame)
		{
			_spawn(undefined, isdefined(self._s.firstframe) && self._s.firstframe || isdefined(self._s.initanim) || isdefined(self._s.initanimloop));
		}
		if(isdefined(self._s.firstframe) && self._s.firstframe || b_force_first_frame)
		{
			if(!cscriptbundleobjectbase::error(!isdefined(self._s.mainanim), "No animation defined for first frame."))
			{
				self._str_death_anim = self._s.mainanimdeath;
				self._str_death_anim_loop = self._s.mainanimdeathloop;
				_play_anim(self._s.mainanim, 0, 0, 0);
			}
		}
		else if(isdefined(self._s.initanim))
		{
			self._str_death_anim = self._s.initanimdeath;
			self._str_death_anim_loop = self._s.initanimdeathloop;
			_play_anim(self._s.initanim, self._s.initdelaymin, self._s.initdelaymax, 1);
			if(is_alive())
			{
				if(isdefined(self._s.initanimloop))
				{
					self._str_death_anim = self._s.initanimloopdeath;
					self._str_death_anim_loop = self._s.initanimloopdeathloop;
					_play_anim(self._s.initanimloop, 0, 0, 1);
				}
			}
		}
		else if(isdefined(self._s.initanimloop))
		{
			self._str_death_anim = self._s.initanimloopdeath;
			self._str_death_anim_loop = self._s.initanimloopdeathloop;
			_play_anim(self._s.initanimloop, self._s.initdelaymin, self._s.initdelaymax, 1);
		}
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
	Checksum: 0xF71B55E7
	Offset: 0x1168
	Size: 0x574
	Parameters: 0
	Flags: Linked
*/
function play()
{
	/#
		if(getdvarint("") > 0)
		{
			if(isdefined(self._s.name))
			{
				printtoprightln("" + self._s.name);
			}
			else
			{
				printtoprightln("" + self._s.model);
			}
		}
	#/
	flagsys::clear("ready");
	flagsys::clear("done");
	flagsys::clear("main_done");
	self._str_state = "play";
	self notify(#"new_state");
	self endon(#"new_state");
	self notify(#"play");
	cscriptbundleobjectbase::log("play");
	waittillframeend();
	if(isdefined(self._s.hide) && self._s.hide && self._is_valid)
	{
		_spawn(undefined, 0, 0);
		self._e hide();
	}
	else if(isdefined(self._s.mainanim) && self._is_valid)
	{
		self._str_death_anim = self._s.mainanimdeath;
		self._str_death_anim_loop = self._s.mainanimdeathloop;
		if(!(isdefined(self._s.iscutscene) && self._s.iscutscene))
		{
			if(!isdefined(self._s.mainblend) || self._s.mainblend == 0)
			{
				self._s.mainblend = 0.2;
			}
			else if(self._s.mainblend == 0.001)
			{
				self._s.mainblend = 0;
			}
		}
		_play_anim(self._s.mainanim, self._s.maindelaymin, self._s.maindelaymax, 1, self._s.mainblend, self._o_bundle.n_start_time);
		flagsys::set("main_done");
		if(isdefined(self._e) && (isdefined(self._s.dynamicpaths) && self._s.dynamicpaths))
		{
			if(distance2dsquared(self._e.origin, self._e.scene_orig_origin) > 4)
			{
				self._e disconnectpaths(2, 0);
			}
		}
		if(is_alive())
		{
			if(!isdefined(self._s.endblend) || self._s.endblend == 0)
			{
				self._s.endblend = 0.2;
			}
			if(isdefined(self._s.endanim))
			{
				self._str_death_anim = self._s.endanimdeath;
				self._str_death_anim_loop = self._s.endanimdeathloop;
				_play_anim(self._s.endanim, 0, 0, 1, self._s.endblend);
				if(is_alive())
				{
					if(isdefined(self._s.endanimloop))
					{
						self._str_death_anim = self._s.endanimloopdeath;
						self._str_death_anim_loop = self._s.endanimloopdeathloop;
						_play_anim(self._s.endanimloop, 0, 0, 1);
					}
				}
			}
			else if(isdefined(self._s.endanimloop))
			{
				self._str_death_anim = self._s.endanimloopdeath;
				self._str_death_anim_loop = self._s.endanimloopdeathloop;
				_play_anim(self._s.endanimloop, 0, 0, 1);
			}
		}
	}
	thread finish();
}

/*
	Name: stop
	Namespace: csceneobject
	Checksum: 0x12FF2A84
	Offset: 0x16E8
	Size: 0x21C
	Parameters: 3
	Flags: Linked
*/
function stop(b_clear = 0, b_dont_clear_anim = 0, b_finished = 0)
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + (isdefined(self._s.name) ? self._s.name : self._s.model));
		}
	#/
	if(isalive(self._e))
	{
		if(is_shared_player())
		{
			foreach(var_c8faff62, player in level.players)
			{
				player stopanimscripted(0.2);
			}
		}
		else if(!(isdefined(self._s.diewhenfinished) && self._s.diewhenfinished) || !b_finished)
		{
			if(!b_dont_clear_anim || isplayer(self._e))
			{
				self._e stopanimscripted(0.2);
			}
		}
	}
	finish(b_clear, !b_finished);
}

/*
	Name: get_align_ent
	Namespace: csceneobject
	Checksum: 0x589E4BDD
	Offset: 0x1910
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function get_align_ent()
{
	e_align = undefined;
	if(isdefined(self._s.aligntarget) && !self._s.aligntarget === self._o_bundle._s.aligntarget)
	{
		a_scene_ents = [[ self._o_bundle ]]->get_ents();
		if(isdefined(a_scene_ents[self._s.aligntarget]))
		{
			e_align = a_scene_ents[self._s.aligntarget];
		}
		else
		{
			e_align = scene::get_existing_ent(self._s.aligntarget, 0, 1);
		}
		if(!isdefined(e_align))
		{
			str_msg = "Align target '" + (isdefined(self._s.aligntarget) ? "" + self._s.aligntarget : "") + "' doesn't exist for scene object.";
			if(!cscriptbundleobjectbase::warning(self._o_bundle._testing, str_msg))
			{
				cscriptbundleobjectbase::error(getdvarint("scene_align_errors", 1), str_msg);
			}
		}
	}
	if(!isdefined(e_align))
	{
		e_align = [[ scene() ]]->get_align_ent();
	}
	return e_align;
}

/*
	Name: get_align_tag
	Namespace: csceneobject
	Checksum: 0x96E156CE
	Offset: 0x1AE0
	Size: 0x6A
	Parameters: 0
	Flags: Linked
*/
function get_align_tag()
{
	if(isdefined(self._s.aligntargettag))
	{
		return self._s.aligntargettag;
	}
	if(isdefined(self._o_bundle._e_root.e_scene_link))
	{
		return "tag_origin";
	}
	return self._o_bundle._s.aligntargettag;
}

/*
	Name: scene
	Namespace: csceneobject
	Checksum: 0x707FF5E8
	Offset: 0x1B58
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function scene()
{
	return self._o_bundle;
}

/*
	Name: _on_damage_run_scene_thread
	Namespace: csceneobject
	Checksum: 0x823860C5
	Offset: 0x1B70
	Size: 0x394
	Parameters: 0
	Flags: Linked
*/
function _on_damage_run_scene_thread()
{
	self endon(#"play");
	self endon(#"done");
	loc_00001C10:
	loc_00001C60:
	loc_00001CB0:
	loc_00001D00:
	str_damage_types = !isdefined(self._s.runsceneondmg0) || (self._s.runsceneondmg0 == "none" ? "" : self._s.runsceneondmg0) + !isdefined(self._s.runsceneondmg1) || (self._s.runsceneondmg1 == "none" ? "" : self._s.runsceneondmg1) + !isdefined(self._s.runsceneondmg2) || (self._s.runsceneondmg2 == "none" ? "" : self._s.runsceneondmg2) + !isdefined(self._s.runsceneondmg3) || (self._s.runsceneondmg3 == "none" ? "" : self._s.runsceneondmg3) + !isdefined(self._s.runsceneondmg4) || (self._s.runsceneondmg4 == "none" ? "" : self._s.runsceneondmg4);
	if(str_damage_types != "")
	{
		b_run_scene = 0;
		while(!b_run_scene)
		{
			self._e waittill(#"damage", n_amount, e_attacker, v_org, v_dir, str_mod);
			switch(str_mod)
			{
				case "MOD_PISTOL_BULLET":
				case "MOD_RIFLE_BULLET":
				{
					if(issubstr(str_damage_types, "bullet"))
					{
						b_run_scene = 1;
					}
					break;
				}
				case "MOD_EXPLOSIVE":
				case "MOD_GRENADE":
				case "MOD_GRENADE_SPLASH":
				{
					if(issubstr(str_damage_types, "explosive"))
					{
						b_run_scene = 1;
					}
					break;
				}
				case "MOD_PROJECTILE":
				case "MOD_PROJECTILE_SPLASH":
				{
					if(issubstr(str_damage_types, "projectile"))
					{
						b_run_scene = 1;
					}
					break;
				}
				case "MOD_MELEE":
				{
					if(issubstr(str_damage_types, "melee"))
					{
						b_run_scene = 1;
					}
					break;
				}
				default:
				{
					if(issubstr(str_damage_types, "all"))
					{
						b_run_scene = 1;
					}
				}
			}
		}
		thread [[ scene() ]]->play();
	}
}

/*
	Name: _assign_unique_name
	Namespace: csceneobject
	Checksum: 0xD934056B
	Offset: 0x1F10
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function _assign_unique_name()
{
	if(is_player())
	{
		self._str_name = "player " + self._s.player;
	}
	else if([[ scene() ]]->allows_multiple())
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
	Checksum: 0xE03FA585
	Offset: 0x2078
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
	Checksum: 0x2068C712
	Offset: 0x2090
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
	Checksum: 0x8F747061
	Offset: 0x20B0
	Size: 0x754
	Parameters: 3
	Flags: Linked
*/
function _spawn(e_spawner, b_hide = 1, b_set_ready_when_spawned = 1)
{
	if(isdefined(e_spawner))
	{
		self._e = e_spawner;
	}
	if(isdefined(self._e) && (isdefined(self._e.isdying) && self._e.isdying))
	{
		self._e delete();
	}
	if(is_player())
	{
		if(isplayer(self._e))
		{
			self._player = self._e;
		}
		else
		{
			n_player = getdvarint("scene_debug_player", 0);
			if(n_player > 0)
			{
				n_player--;
				if(n_player == self._s.player)
				{
					self._player = level.activeplayers[0];
				}
			}
			else
			{
				self._player = level.activeplayers[self._s.player];
			}
		}
	}
	b_skip = self._s.type === "actor" && issubstr(self._o_bundle._str_mode, "noai");
	b_skip = b_skip || (self._s.type === "player" && issubstr(self._o_bundle._str_mode, "noplayers"));
	if(!b_skip && _should_skip_entity())
	{
		b_skip = 1;
	}
	if(!b_skip)
	{
		if(!isdefined(self._e) && is_player() && (isdefined(self._s.newplayermethod) && self._s.newplayermethod))
		{
			self._e = self._player;
		}
		else if(!isdefined(self._e) || isspawner(self._e))
		{
			b_allows_multiple = [[ scene() ]]->allows_multiple();
			if(cscriptbundleobjectbase::error(b_allows_multiple && (isdefined(self._s.nospawn) && self._s.nospawn), "Scene that allow multiple instances must be allowed to spawn (uncheck 'Do Not Spawn')."))
			{
				return;
			}
			if(!isspawner(self._e))
			{
				e = scene::get_existing_ent(self._str_name, b_allows_multiple);
				if(!isdefined(e) && isdefined(self._s.name))
				{
					e = scene::get_existing_ent(self._s.name, b_allows_multiple);
				}
				if(isplayer(e))
				{
					if(!(isdefined(self._s.newplayermethod) && self._s.newplayermethod))
					{
						e = undefined;
					}
				}
				if(!isdefined(e) || isspawner(e) && (!(isdefined(self._s.nospawn) && self._s.nospawn) && !self._b_spawnonce_used || self._o_bundle._testing))
				{
					e_spawned = spawn_ent(e);
				}
			}
			else
			{
				e_spawned = spawn_ent(self._e);
			}
			if(isdefined(e_spawned))
			{
				if(b_hide && !self._o_bundle._s scene::is_igc())
				{
					e_spawned hide();
				}
				e_spawned dontinterpolate();
				e_spawned.scene_spawned = self._o_bundle._s.name;
				if(!isdefined(e_spawned.targetname))
				{
					e_spawned.targetname = self._s.name;
				}
				if(is_player())
				{
					e_spawned hide();
				}
			}
			self._e = (isdefined(e_spawned) ? e_spawned : e);
			if(isdefined(self._s.spawnonce) && self._s.spawnonce && self._b_spawnonce_used)
			{
				return;
			}
		}
		cscriptbundleobjectbase::error(!is_player() && (!(isdefined(self._s.nospawn) && self._s.nospawn)) && (!isdefined(self._e) || isspawner(self._e)), "Object failed to spawn or doesn't exist.");
	}
	if(isdefined(self._e) && !isspawner(self._e))
	{
		[[ self ]]->_prepare();
		if(b_set_ready_when_spawned)
		{
			flagsys::set("ready");
		}
		if(isdefined(self._s.spawnonce) && self._s.spawnonce)
		{
			self._b_spawnonce_used = 1;
		}
	}
	else
	{
		flagsys::set("ready");
		flagsys::set("done");
		finish();
	}
}

/*
	Name: _prepare
	Namespace: csceneobject
	Checksum: 0xDF620025
	Offset: 0x2810
	Size: 0x928
	Parameters: 0
	Flags: Linked
*/
function _prepare()
{
	if(isdefined(self._s.dynamicpaths) && self._s.dynamicpaths && self._str_state == "play")
	{
		self._e.scene_orig_origin = self._e.origin;
		self._e connectpaths();
	}
	if(self._e.current_scene === self._o_bundle._str_name)
	{
		[[ self._o_bundle ]]->trigger_scene_sequence_started(self, self._e);
		return 0;
	}
	self._e endon(#"death");
	if(!(isdefined(self._s.ignorealivecheck) && self._s.ignorealivecheck) && (cscriptbundleobjectbase::error(isai(self._e) && !isalive(self._e), "Trying to play a scene on a dead AI.")))
	{
		return;
	}
	if(isdefined(self._e._o_scene))
	{
		foreach(var_2d7ce3f1, obj in self._e._o_scene._a_objects)
		{
			if(obj._e === self._e)
			{
				[[ obj ]]->finish();
				break;
			}
		}
	}
	if(!isai(self._e) && !isplayer(self._e))
	{
		if(!is_player() || (!(isdefined(self._s.newplayermethod) && self._s.newplayermethod)))
		{
			if(is_player_model())
			{
				scene::prepare_player_model_anim(self._e);
			}
			else
			{
				scene::prepare_generic_model_anim(self._e);
			}
		}
	}
	if(!is_player())
	{
		if(!isdefined(self._e._scene_old_takedamage))
		{
			self._e._scene_old_takedamage = self._e.takedamage;
		}
		if(issentient(self._e))
		{
			self._e.takedamage = isdefined(self._e.takedamage) && self._e.takedamage && (isdefined(self._s.takedamage) && self._s.takedamage);
			if(!(isdefined(self._e.magic_bullet_shield) && self._e.magic_bullet_shield))
			{
				self._e.allowdeath = isdefined(self._s.allowdeath) && self._s.allowdeath;
			}
			if(isdefined(self._s.overrideaicharacter) && self._s.overrideaicharacter)
			{
				self._e detachall();
				self._e setmodel(self._s.model);
			}
		}
		else
		{
			self._e.health = (self._e.health > 0 ? self._e.health : 1);
			if(self._s.type === "actor")
			{
				self._e makefakeai();
				if(!(isdefined(self._s.removeweapon) && self._s.removeweapon))
				{
					self._e animation::attach_weapon(getweapon("ar_standard"));
				}
			}
			self._e.takedamage = isdefined(self._s.takedamage) && self._s.takedamage;
			self._e.allowdeath = isdefined(self._s.allowdeath) && self._s.allowdeath;
		}
		set_objective();
		if(isdefined(self._s.dynamicpaths) && self._s.dynamicpaths)
		{
			self._e disconnectpaths(2, 0);
		}
	}
	else if(!is_shared_player())
	{
		player = (isplayer(self._player) ? self._player : self._e);
		_prepare_player(player);
	}
	if(isdefined(self._s.removeweapon) && self._s.removeweapon)
	{
		if(!(isdefined(self._e.gun_removed) && self._e.gun_removed))
		{
			if(isplayer(self._e))
			{
				self._e player::take_weapons();
			}
			else
			{
				self._e animation::detach_weapon();
			}
		}
		else
		{
			self._e._scene_old_gun_removed = 1;
		}
	}
	self._e.animname = self._str_name;
	self._e.anim_debug_name = self._s.name;
	self._e flagsys::set("scene");
	self._e flagsys::set(self._o_bundle._str_name);
	self._e.current_scene = self._o_bundle._str_name;
	self._e.finished_scene = undefined;
	self._e._o_scene = scene();
	[[ self._o_bundle ]]->trigger_scene_sequence_started(self, self._e);
	if(isdefined(self._e.takedamage) && self._e.takedamage)
	{
		thread _on_damage_run_scene_thread();
		thread _on_death();
	}
	if(isactor(self._e))
	{
		thread _track_goal();
		if(isdefined(self._s.lookatplayer) && self._s.lookatplayer)
		{
			self._e lookatentity(level.activeplayers[0]);
		}
	}
	if(self._o_bundle._s scene::is_igc() || [[ self._o_bundle ]]->has_player())
	{
		if(!isplayer(self._e))
		{
			self._e sethighdetail(1);
		}
	}
	return 1;
}

/*
	Name: _prepare_player
	Namespace: csceneobject
	Checksum: 0x8E965A82
	Offset: 0x3140
	Size: 0x594
	Parameters: 1
	Flags: Linked
*/
function _prepare_player(player)
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("");
		}
	#/
	if(isdefined(player.play_scene_transition_effect) && player.play_scene_transition_effect)
	{
		player.play_scene_transition_effect = undefined;
		play_regroup_fx_for_scene(player);
	}
	if(player.current_player_scene === self._o_bundle._str_name)
	{
		[[ self._o_bundle ]]->trigger_scene_sequence_started(self, player);
		return 0;
	}
	player sethighdetail(1);
	if(player flagsys::get("mobile_armory_in_use"))
	{
		player flagsys::set("cancel_mobile_armory");
		player closemenu("ChooseClass_InGame");
		player notify(#"menuresponse", "ChooseClass_InGame", "cancel");
	}
	if(player flagsys::get("mobile_armory_begin_use"))
	{
		player util::_enableweapon();
		player flagsys::clear("mobile_armory_begin_use");
	}
	if(getdvarint("scene_hide_player") > 0)
	{
		player hide();
	}
	player.current_player_scene = self._o_bundle._str_name;
	if(!(isdefined(player.magic_bullet_shield) && player.magic_bullet_shield))
	{
		player.allowdeath = isdefined(self._s.allowdeath) && self._s.allowdeath;
	}
	player.scene_takedamage = isdefined(self._s.takedamage) && self._s.takedamage;
	if(isdefined(player.hijacked_vehicle_entity))
	{
		player.hijacked_vehicle_entity delete();
	}
	else if(player isinvehicle())
	{
		vh_occupied = player getvehicleoccupied();
		n_seat = vh_occupied getoccupantseat(player);
		vh_occupied usevehicle(player, n_seat);
	}
	revive_player(player);
	player thread scene::scene_disable_player_stuff(!(isdefined(self._s.showhud) && self._s.showhud));
	player.player_anim_look_enabled = !(isdefined(self._s.lockview) && self._s.lockview);
	player.player_anim_clamp_right = (isdefined(self._s.viewclampright) ? self._s.viewclampright : 0);
	player.player_anim_clamp_left = (isdefined(self._s.viewclampleft) ? self._s.viewclampleft : 0);
	player.player_anim_clamp_top = (isdefined(self._s.viewclampbottom) ? self._s.viewclampbottom : 0);
	player.player_anim_clamp_bottom = (isdefined(self._s.viewclampbottom) ? self._s.viewclampbottom : 0);
	if(!(isdefined(self._s.removeweapon) && self._s.removeweapon) || (isdefined(self._s.showweaponinfirstperson) && self._s.showweaponinfirstperson) && (!(isdefined(self._s.disableprimaryweaponswitch) && self._s.disableprimaryweaponswitch)))
	{
		player player::switch_to_primary_weapon(1);
	}
	set_player_stance(player);
}

/*
	Name: revive_player
	Namespace: csceneobject
	Checksum: 0xE0CE13F3
	Offset: 0x36E0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function revive_player(player)
{
	if(player.sessionstate === "spectator")
	{
		player thread [[level.spawnplayer]]();
	}
	else if(player laststand::player_is_in_laststand())
	{
		player notify(#"auto_revive");
	}
}

/*
	Name: set_player_stance
	Namespace: csceneobject
	Checksum: 0xDECCD62E
	Offset: 0x3750
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function set_player_stance(player)
{
	if(self._s.playerstance === "crouch")
	{
		player allowstand(0);
		player allowcrouch(1);
		player allowprone(0);
	}
	else if(self._s.playerstance === "prone")
	{
		player allowstand(0);
		player allowcrouch(0);
		player allowprone(1);
	}
	else
	{
		player allowstand(1);
		player allowcrouch(0);
		player allowprone(0);
	}
}

/*
	Name: finish
	Namespace: csceneobject
	Checksum: 0xF9181D76
	Offset: 0x3888
	Size: 0x704
	Parameters: 2
	Flags: Linked
*/
function finish(b_clear = 0, b_canceled = 0)
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + (isdefined(self._s.name) ? self._s.name : self._s.model));
		}
	#/
	if(isdefined(self._str_state))
	{
		self._str_state = undefined;
		self notify(#"new_state");
		if(!is_shared_player() && !is_alive())
		{
			_cleanup();
			self._e = undefined;
			self._is_valid = 0;
		}
		else if(!is_player())
		{
			if(isdefined(self._e._scene_old_takedamage))
			{
				self._e.takedamage = self._e._scene_old_takedamage;
			}
			if(!(isdefined(self._e.magic_bullet_shield) && self._e.magic_bullet_shield))
			{
				self._e.allowdeath = 1;
			}
			self._e._scene_old_takedamage = undefined;
			self._e._scene_old_gun_removed = undefined;
		}
		else if(is_shared_player())
		{
			foreach(var_89ebe278, player in level.players)
			{
				if(player flagsys::get("shared_igc"))
				{
					_finish_player(player);
				}
			}
		}
		else
		{
			player = (isplayer(self._player) ? self._player : self._e);
			_finish_player(player);
		}
		if(isdefined(self._s.removeweapon) && self._s.removeweapon && (!(isdefined(self._e._scene_old_gun_removed) && self._e._scene_old_gun_removed)))
		{
			if(isplayer(self._e))
			{
				/#
					if(getdvarint("") > 0)
					{
						printtoprightln("" + (isdefined(self._s.name) ? self._s.name : self._s.model));
					}
				#/
				self._e player::give_back_weapons();
			}
			else
			{
				/#
					if(getdvarint("") > 0)
					{
						printtoprightln("" + (isdefined(self._s.name) ? self._s.name : self._s.model));
					}
				#/
				self._e animation::attach_weapon();
			}
		}
		if(!isplayer(self._e))
		{
			if(isdefined(self._e))
			{
				self._e sethighdetail(0);
			}
		}
		flagsys::set("ready");
		flagsys::set("done");
		if(isdefined(self._e))
		{
			if(!is_player())
			{
				if(is_alive() && (isdefined(self._s.deletewhenfinished) && self._s.deletewhenfinished || b_clear))
				{
					self._e thread scene::synced_delete();
				}
				else if(is_alive() && (isdefined(self._s.diewhenfinished) && self._s.diewhenfinished) && !b_canceled)
				{
					self._e.skipdeath = 1;
					self._e.allowdeath = 1;
					self._e.skipscenedeath = 1;
					self._e kill();
				}
			}
			if(isactor(self._e) && isalive(self._e))
			{
				if(isdefined(self._s.delaymovementatend) && self._s.delaymovementatend)
				{
					self._e pathmode("move delayed", 1, randomfloatrange(2, 3));
				}
				else
				{
					self._e pathmode("move allowed");
				}
				if(isdefined(self._s.lookatplayer) && self._s.lookatplayer)
				{
					self._e lookatentity();
				}
			}
		}
		_cleanup();
	}
}

/*
	Name: _finish_player
	Namespace: csceneobject
	Checksum: 0xEB413B55
	Offset: 0x3F98
	Size: 0x2DC
	Parameters: 1
	Flags: Linked
*/
function _finish_player(player)
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("");
		}
	#/
	player.scene_set_visible_time = level.time;
	player setvisibletoall();
	player flagsys::clear("shared_igc");
	if(!(isdefined(player.magic_bullet_shield) && player.magic_bullet_shield))
	{
		player.allowdeath = 1;
	}
	player.current_player_scene = undefined;
	player.scene_takedamage = undefined;
	player._scene_old_gun_removed = undefined;
	player thread scene::scene_enable_player_stuff(!(isdefined(self._s.showhud) && self._s.showhud));
	if(![[ self._o_bundle ]]->has_next_scene())
	{
		if([[ self._o_bundle ]]->is_player_anim_ending_early())
		{
			if(!([[ self._o_bundle ]]->is_skipping_scene()) && [[ self._o_bundle ]]->is_scene_shared_sequence())
			{
				[[ self._o_bundle ]]->init_scene_sequence_started(0);
			}
			self._o_bundle thread cscene::_stop_camera_anim_on_player(player);
		}
		else if(self._o_bundle._s scene::is_igc())
		{
			self._o_bundle thread cscene::_stop_camera_anim_on_player(player);
		}
	}
	n_camera_tween_out = get_camera_tween_out();
	if(n_camera_tween_out > 0)
	{
		player startcameratween(n_camera_tween_out);
	}
	if(!(isdefined(self._s.dontreloadammo) && self._s.dontreloadammo))
	{
		player player::fill_current_clip();
	}
	player allowstand(1);
	player allowcrouch(1);
	player allowprone(1);
	player sethighdetail(0);
}

/*
	Name: set_objective
	Namespace: csceneobject
	Checksum: 0x75BED9A1
	Offset: 0x4280
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function set_objective()
{
	if(!isdefined(self._e.script_objective))
	{
		if(isdefined(self._o_bundle._e_root.script_objective))
		{
			self._e.script_objective = self._o_bundle._e_root.script_objective;
		}
		else if(isdefined(self._o_bundle._s.script_objective))
		{
			self._e.script_objective = self._o_bundle._s.script_objective;
		}
	}
}

/*
	Name: _on_death
	Namespace: csceneobject
	Checksum: 0xA654074C
	Offset: 0x4330
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function _on_death()
{
	self endon(#"cleanup");
	self._e waittill(#"death");
	if(isdefined(self._e) && (!(isdefined(self._e.skipscenedeath) && self._e.skipscenedeath)))
	{
		self thread do_death_anims();
	}
}

/*
	Name: do_death_anims
	Namespace: csceneobject
	Checksum: 0xC132012F
	Offset: 0x43A8
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function do_death_anims()
{
	ent = self._e;
	if(isai(ent) && !isdefined(self._str_death_anim) && !isdefined(self._str_death_anim_loop))
	{
		ent stopanimscripted();
		if(isactor(ent))
		{
			ent startragdoll();
		}
	}
	if(isdefined(self._str_death_anim))
	{
		ent.skipdeath = 1;
		ent animation::play(self._str_death_anim, ent, undefined, 1, 0.2, 0);
	}
	if(isdefined(self._str_death_anim_loop))
	{
		ent.skipdeath = 1;
		ent animation::play(self._str_death_anim_loop, ent, undefined, 1, 0, 0);
	}
}

/*
	Name: _cleanup
	Namespace: csceneobject
	Checksum: 0xA1FC53C2
	Offset: 0x44E0
	Size: 0x1D8
	Parameters: 0
	Flags: Linked
*/
function _cleanup()
{
	if(isdefined(self._e) && isdefined(self._e.current_scene))
	{
		self._e flagsys::clear(self._o_bundle._str_name);
		if(self._e.current_scene == self._o_bundle._str_name)
		{
			self._e flagsys::clear("scene");
			self._e.finished_scene = self._o_bundle._str_name;
			self._e.current_scene = undefined;
			self._e._o_scene = undefined;
			if(is_player())
			{
				if(!(isdefined(self._s.newplayermethod) && self._s.newplayermethod))
				{
					self._e delete();
					thread reset_player();
				}
				self._e.animname = undefined;
			}
		}
	}
	self notify(#"death");
	self endon(#"new_state");
	waittillframeend();
	self notify(#"cleanup");
	if(isai(self._e))
	{
		_set_goal();
	}
	if(isdefined(self._o_bundle) && (isdefined(self._o_bundle.scene_stopping) && self._o_bundle.scene_stopping))
	{
		self._o_bundle = undefined;
	}
}

/*
	Name: _set_goal
	Namespace: csceneobject
	Checksum: 0x543F0381
	Offset: 0x46C0
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function _set_goal()
{
	if(!(self._e.scene_spawned === self._o_bundle._s.name && isdefined(self._e.target)))
	{
		if(!isdefined(self._e.script_forcecolor))
		{
			if(!self._e flagsys::get("anim_reach"))
			{
				if(isdefined(self._e.scenegoal))
				{
					self._e setgoal(self._e.scenegoal);
					self._e.scenegoal = undefined;
				}
				else if(self._b_set_goal)
				{
					self._e setgoal(self._e.origin);
				}
			}
		}
	}
}

/*
	Name: _track_goal
	Namespace: csceneobject
	Checksum: 0x8940E196
	Offset: 0x47D0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function _track_goal()
{
	self endon(#"cleanup");
	self._e endon(#"death");
	self._e waittill(#"goal_changed");
	self._b_set_goal = 0;
}

/*
	Name: _play_anim
	Namespace: csceneobject
	Checksum: 0x78721EE
	Offset: 0x4818
	Size: 0xB6C
	Parameters: 6
	Flags: Linked
*/
function _play_anim(animation, n_delay_min = 0, n_delay_max = 0, n_rate = 1, n_blend = 0.2, n_time = 0)
{
	/#
		if(getdvarint("") > 0)
		{
			if(isdefined(self._s.name))
			{
				printtoprightln("" + self._s.name);
			}
			else
			{
				printtoprightln("" + self._s.model);
			}
		}
	#/
	if(_should_skip_anim(animation))
	{
		return;
	}
	if(n_time != 0)
	{
		n_time = [[ self._o_bundle ]]->get_anim_relative_start_time(animation, n_time);
	}
	n_delay = n_delay_min;
	if(n_delay_max > n_delay_min)
	{
		n_delay = randomfloatrange(n_delay_min, n_delay_max);
	}
	do_reach = n_time == 0 && (isdefined(self._s.doreach) && self._s.doreach && (!(isdefined(self._o_bundle._testing) && self._o_bundle._testing) || getdvarint("scene_test_with_reach", 0)));
	_spawn(undefined, !do_reach, !do_reach);
	if(!isactor(self._e))
	{
		do_reach = 0;
	}
	if(n_delay > 0)
	{
		if(n_delay > 0)
		{
			wait(n_delay);
		}
	}
	if(do_reach)
	{
		[[ scene() ]]->wait_till_scene_ready(self);
		if(isdefined(self._s.disablearrivalinreach) && self._s.disablearrivalinreach)
		{
			self._e animation::reach(animation, get_align_ent(), get_align_tag(), 1);
		}
		else
		{
			self._e animation::reach(animation, get_align_ent(), get_align_tag());
		}
		flagsys::set("ready");
	}
	else if(n_rate > 0)
	{
		[[ scene() ]]->wait_till_scene_ready();
	}
	else if(isdefined(self._s.aligntarget))
	{
		foreach(var_64090632, o_obj in self._o_bundle._a_objects)
		{
			if(o_obj._str_name == self._s.aligntarget)
			{
				o_obj flagsys::wait_till("ready");
				break;
			}
		}
	}
	if(is_alive())
	{
		align = get_align_ent();
		tag = get_align_tag();
		if(align == level)
		{
			align = (0, 0, 0);
			tag = (0, 0, 0);
		}
		if(is_shared_player())
		{
			_play_shared_player_anim(animation, align, tag, n_rate, n_time);
		}
		else if(is_player() && (!(isdefined(self._s.newplayermethod) && self._s.newplayermethod)))
		{
			thread link_player();
		}
		if(self._o_bundle._s scene::is_igc() || self._e.scene_spawned === self._o_bundle._s.name)
		{
			self._e dontinterpolate();
			self._e show();
		}
		n_lerp = get_lerp_time();
		if(isplayer(self._e) && !self._o_bundle._s scene::is_igc())
		{
			n_camera_tween = get_camera_tween();
			if(n_camera_tween > 0)
			{
				self._e startcameratween(n_camera_tween);
			}
		}
		if(![[ self._o_bundle ]]->has_next_scene())
		{
			n_blend_out = (isai(self._e) ? 0.2 : 0);
		}
		else
		{
			n_blend_out = 0;
		}
		if(isdefined(self._s.diewhenfinished) && self._s.diewhenfinished)
		{
			n_blend_out = 0;
		}
		/#
			if(getdvarint("") > 0)
			{
				printtoprightln("" + (isdefined(self._s.name) ? self._s.name : self._s.model) + "" + animation);
			}
		#/
		/#
			if(getdvarint("") > 0)
			{
				if(!isdefined(level.animation_played))
				{
					level.animation_played = [];
					animation_played_name = (isdefined(self._s.name) ? self._s.name : self._s.model) + "" + animation;
					if(!isdefined(level.animation_played))
					{
						level.animation_played = [];
					}
					else if(!isarray(level.animation_played))
					{
						level.animation_played = array(level.animation_played);
					}
					level.animation_played[level.animation_played.size] = animation_played_name;
				}
			}
		#/
		self.current_playing_anim = animation;
		if(isdefined([[ self._o_bundle ]]->is_skipping_scene()) && [[ self._o_bundle ]]->is_skipping_scene() && n_rate != 0)
		{
			thread skip_scene(1);
		}
		self._e animation::play(animation, align, tag, n_rate, n_blend, n_blend_out, n_lerp, n_time, self._s.showweaponinfirstperson);
		if(!isdefined(self._e) || !self._e isplayinganimscripted())
		{
			self.current_playing_anim = undefined;
		}
		/#
			if(getdvarint("") > 0)
			{
				if(isdefined(level.animation_played))
				{
					for(i = 0; i < level.animation_played.size; i++)
					{
						animation_played_name = (isdefined(self._s.name) ? self._s.name : self._s.model) + "" + animation;
						if(level.animation_played[i] == animation_played_name)
						{
							arrayremovevalue(level.animation_played, animation_played_name);
							i--;
							continue;
						}
					}
				}
			}
		#/
		/#
			if(getdvarint("") > 0)
			{
				printtoprightln("" + (isdefined(self._s.name) ? self._s.name : self._s.model) + "" + animation);
			}
		#/
	}
	cscriptbundleobjectbase::log("" + animation + "");
	self._is_valid = is_alive() && !in_a_different_scene();
}

/*
	Name: spawn_ent
	Namespace: csceneobject
	Checksum: 0x2799129B
	Offset: 0x5390
	Size: 0x28E
	Parameters: 1
	Flags: Linked
*/
function spawn_ent(e)
{
	b_disable_throttle = self._o_bundle._s scene::is_igc() || (isdefined(self._o_bundle._s.dontthrottle) && self._o_bundle._s.dontthrottle);
	if(is_player() && (!(isdefined(self._s.newplayermethod) && self._s.newplayermethod)))
	{
		system::wait_till("loadout");
		m_player = util::spawn_anim_model(level.player_interactive_model);
		return m_player;
	}
	if(isdefined(e))
	{
		if(isspawner(e))
		{
			/#
				if(self._o_bundle._testing)
				{
					e.count++;
				}
			#/
			if(!cscriptbundleobjectbase::error(e.count < 1, "Trying to spawn AI for scene with spawner count < 1"))
			{
				return e spawner::spawn(1, undefined, undefined, undefined, b_disable_throttle);
			}
		}
	}
	else if(isdefined(self._s.model))
	{
		new_model = undefined;
		if(is_player_model())
		{
			new_model = util::spawn_anim_player_model(self._s.model, self._o_bundle._e_root.origin, self._o_bundle._e_root.angles);
		}
		else
		{
			new_model = util::spawn_anim_model(self._s.model, self._o_bundle._e_root.origin, self._o_bundle._e_root.angles, undefined, !b_disable_throttle);
		}
		return new_model;
	}
}

/*
	Name: _play_shared_player_anim
	Namespace: csceneobject
	Checksum: 0x1CA0BC2D
	Offset: 0x5628
	Size: 0x350
	Parameters: 5
	Flags: Linked
*/
function _play_shared_player_anim(animation, align, tag, n_rate, n_time)
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + animation);
		}
	#/
	self.player_animation = animation;
	self.player_animation_notify = animation + "_notify";
	self.player_animation_length = getanimlength(animation);
	self.player_align = align;
	self.player_tag = tag;
	self.player_rate = n_rate;
	self.player_time_frac = n_time;
	self.player_start_time = gettime();
	callback::on_loadout(&_play_shared_player_anim_for_player, self);
	foreach(var_54300fbd, player in level.players)
	{
		if(player flagsys::get("loadout_given") && player.sessionstate !== "spectator")
		{
			self thread _play_shared_player_anim_for_player(player);
			continue;
		}
		if(isdefined(player.initialloadoutgiven) && player.initialloadoutgiven)
		{
			revive_player(player);
		}
	}
	waittillframeend();
	do
	{
		b_playing = 0;
		a_players = arraycopy(level.activeplayers);
		foreach(var_cb34bb1a, player in a_players)
		{
			if(isdefined(player) && player flagsys::get(self.player_animation_notify))
			{
				b_playing = 1;
				player flagsys::wait_till_clear(self.player_animation_notify);
				break;
			}
		}
	}
	while(b_playing);
	callback::remove_on_loadout(&_play_shared_player_anim_for_player, self);
	thread [[ self._o_bundle ]]->_call_state_funcs("players_done");
}

/*
	Name: _play_shared_player_anim_for_player
	Namespace: csceneobject
	Checksum: 0x6DD40827
	Offset: 0x5980
	Size: 0x78C
	Parameters: 1
	Flags: Linked
*/
function _play_shared_player_anim_for_player(player)
{
	player endon(#"death");
	/#
	#/
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + self.player_animation);
		}
	#/
	if(!isdefined(self._o_bundle))
	{
		return;
	}
	player flagsys::set("shared_igc");
	if(player flagsys::get(self.player_animation_notify))
	{
		player flagsys::set(self.player_animation_notify + "_skip_init_clear");
	}
	player flagsys::set(self.player_animation_notify);
	if(isdefined(player getlinkedent()))
	{
		player unlink();
	}
	if(!(isdefined(self._s.disabletransitionin) && self._s.disabletransitionin))
	{
		if(player != self._player || getdvarint("scr_player1_postfx", 0))
		{
			if(!isdefined(player.screen_fade_menus))
			{
				if(!(isdefined(level.chyron_text_active) && level.chyron_text_active))
				{
					if(!(isdefined(player.fullscreen_black_active) && player.fullscreen_black_active))
					{
						player.play_scene_transition_effect = 1;
					}
				}
			}
		}
	}
	player show();
	player setinvisibletoall();
	_prepare_player(player);
	n_time_passed = gettime() - self.player_start_time / 1000;
	n_start_time = self.player_time_frac * self.player_animation_length;
	n_time_left = self.player_animation_length - n_time_passed - n_start_time;
	n_time_frac = 1 - n_time_left / self.player_animation_length;
	if(isdefined(self._e) && player != self._e)
	{
		player dontinterpolate();
		player setorigin(self._e.origin);
		player setplayerangles(self._e getplayerangles());
	}
	n_lerp = get_lerp_time();
	if(!self._o_bundle._s scene::is_igc())
	{
		n_camera_tween = get_camera_tween();
		if(n_camera_tween > 0)
		{
			player startcameratween(n_camera_tween);
		}
	}
	if(n_time_frac < 1)
	{
		/#
			if(getdvarint("") > 0)
			{
				player hide();
			}
			if(getdvarint("") > 0)
			{
				printtoprightln("" + self._s.name + "" + self.player_animation);
			}
		#/
		str_animation = self.player_animation;
		if(player util::is_female())
		{
			if(isdefined(self._o_bundle._s.s_female_bundle))
			{
				s_bundle = self._o_bundle._s.s_female_bundle;
			}
		}
		else if(isdefined(self._o_bundle._s.s_male_bundle))
		{
			s_bundle = self._o_bundle._s.s_male_bundle;
		}
		if(isdefined(s_bundle))
		{
			foreach(var_a3afc98, s_object in s_bundle.objects)
			{
				if(isdefined(s_object) && s_object.type === "player")
				{
					str_animation = s_object.mainanim;
					break;
				}
			}
		}
		player_num = player getentitynumber();
		if(!isdefined(self.current_playing_anim))
		{
			self.current_playing_anim = [];
		}
		self.current_playing_anim[player_num] = str_animation;
		if(isdefined([[ self._o_bundle ]]->is_skipping_scene()) && [[ self._o_bundle ]]->is_skipping_scene())
		{
			thread skip_scene(1);
		}
		player animation::play(str_animation, self.player_align, self.player_tag, self.player_rate, 0, 0, n_lerp, n_time_frac, self._s.showweaponinfirstperson);
		if(!player flagsys::get(self.player_animation_notify + "_skip_init_clear"))
		{
			player flagsys::clear(self.player_animation_notify);
		}
		else
		{
			player flagsys::clear(self.player_animation_notify + "_skip_init_clear");
		}
		if(!player isplayinganimscripted())
		{
			self.current_playing_anim[player_num] = undefined;
		}
		/#
			if(getdvarint("") > 0)
			{
				printtoprightln("" + self._s.name + "" + self.player_animation);
			}
		#/
	}
}

/*
	Name: play_regroup_fx_for_scene
	Namespace: csceneobject
	Checksum: 0x79BF1223
	Offset: 0x6118
	Size: 0x1EC
	Parameters: 1
	Flags: Linked
*/
function play_regroup_fx_for_scene(e_player)
{
	align = get_align_ent();
	v_origin = align.origin;
	v_angles = align.angles;
	tag = get_align_tag();
	if(isdefined(tag))
	{
		v_origin = align gettagorigin(tag);
		v_angles = align gettagangles(tag);
	}
	v_start = getstartorigin(v_origin, v_angles, self._s.mainanim);
	n_dist_sq = distancesquared(e_player.origin, v_start);
	if(n_dist_sq > 250000 || isdefined(e_player.hijacked_vehicle_entity) && (!(isdefined(e_player.force_short_scene_transition_effect) && e_player.force_short_scene_transition_effect)))
	{
		self thread regroup_invulnerability(e_player);
		e_player clientfield::increment_to_player("postfx_igc", 1);
	}
	else
	{
		e_player clientfield::increment_to_player("postfx_igc", 3);
	}
	util::wait_network_frame();
}

/*
	Name: regroup_invulnerability
	Namespace: csceneobject
	Checksum: 0xEAB1AA8D
	Offset: 0x6310
	Size: 0x7A
	Parameters: 1
	Flags: Linked
*/
function regroup_invulnerability(e_player)
{
	e_player endon(#"disconnect");
	e_player.ignoreme = 1;
	e_player.b_teleport_invulnerability = 1;
	e_player util::streamer_wait(undefined, 0, 7);
	e_player.ignoreme = 0;
	e_player.b_teleport_invulnerability = undefined;
}

/*
	Name: get_lerp_time
	Namespace: csceneobject
	Checksum: 0x162E8AB9
	Offset: 0x6398
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function get_lerp_time()
{
	if(isplayer(self._e))
	{
		return (isdefined(self._s.lerptime) ? self._s.lerptime : 0);
	}
	return (isdefined(self._s.entitylerptime) ? self._s.entitylerptime : 0);
}

/*
	Name: get_camera_tween
	Namespace: csceneobject
	Checksum: 0x2B82B344
	Offset: 0x6420
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function get_camera_tween()
{
	return (isdefined(self._s.cameratween) ? self._s.cameratween : 0);
}

/*
	Name: get_camera_tween_out
	Namespace: csceneobject
	Checksum: 0xDF496D71
	Offset: 0x6458
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function get_camera_tween_out()
{
	return (isdefined(self._s.cameratweenout) ? self._s.cameratweenout : 0);
}

/*
	Name: link_player
	Namespace: csceneobject
	Checksum: 0x81F5C579
	Offset: 0x6490
	Size: 0x39C
	Parameters: 0
	Flags: Linked
*/
function link_player()
{
	self endon(#"done");
	level flag::wait_till("all_players_spawned");
	player = self._player;
	player hide();
	e_linked = player getlinkedent();
	if(isdefined(e_linked) && e_linked == self._e)
	{
		if(isdefined(self._s.lockview) && self._s.lockview)
		{
			player playerlinktoabsolute(self._e, "tag_player");
		}
		else
		{
			loc_0000659A:
			loc_000065C2:
			loc_000065EA:
			player lerpviewangleclamp(0.2, 0.1, 0.1, (isdefined(self._s.viewclampright) ? self._s.viewclampright : 0), (isdefined(self._s.viewclampleft) ? self._s.viewclampleft : 0), (isdefined(self._s.viewclamptop) ? self._s.viewclamptop : 0), (isdefined(self._s.viewclampbottom) ? self._s.viewclampbottom : 0));
		}
		return;
	}
	player disableusability();
	player disableoffhandweapons();
	player disableweapons();
	util::wait_network_frame();
	player notify(#"scene_link", self._s.cameratween > 0);
	waittillframeend();
	if(isdefined(self._s.lockview) && self._s.lockview)
	{
		player playerlinktoabsolute(self._e, "tag_player");
	}
	else
	{
		loc_0000673A:
		loc_00006762:
		loc_0000678A:
		player playerlinktodelta(self._e, "tag_player", 1, (isdefined(self._s.viewclampright) ? self._s.viewclampright : 0), (isdefined(self._s.viewclampleft) ? self._s.viewclampleft : 0), (isdefined(self._s.viewclamptop) ? self._s.viewclamptop : 0), (isdefined(self._s.viewclampbottom) ? self._s.viewclampbottom : 0), 1, 1);
	}
	wait((self._s.cameratween > 0.2 ? self._s.cameratween : 0.2));
	self._e show();
}

/*
	Name: reset_player
	Namespace: csceneobject
	Checksum: 0xEB7E7615
	Offset: 0x6838
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function reset_player()
{
	level flag::wait_till("all_players_spawned");
	player = self._player;
	player enableusability();
	player enableoffhandweapons();
	player enableweapons();
	player show();
}

/*
	Name: has_init_state
	Namespace: csceneobject
	Checksum: 0xB1BD7DB9
	Offset: 0x68D8
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
	Checksum: 0x4EFABA94
	Offset: 0x6900
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function is_alive()
{
	return isdefined(self._e) && (self._e.health > 0 || self._s.ignorealivecheck === 1);
}

/*
	Name: is_player
	Namespace: csceneobject
	Checksum: 0xC429227B
	Offset: 0x6948
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function is_player()
{
	return isdefined(self._s.player);
}

/*
	Name: is_player_model
	Namespace: csceneobject
	Checksum: 0x732F0216
	Offset: 0x6968
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function is_player_model()
{
	return self._s.type === "player model";
}

/*
	Name: is_shared_player
	Namespace: csceneobject
	Checksum: 0x5B09655E
	Offset: 0x6990
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function is_shared_player()
{
	return isdefined(self._s.player) && (isdefined(self._s.sharedigc) && self._s.sharedigc);
}

/*
	Name: in_a_different_scene
	Namespace: csceneobject
	Checksum: 0x16D8F436
	Offset: 0x69D8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function in_a_different_scene()
{
	return isdefined(self._e) && isdefined(self._e.current_scene) && self._e.current_scene != self._o_bundle._str_name;
}

/*
	Name: _should_skip_anim
	Namespace: csceneobject
	Checksum: 0x857799C5
	Offset: 0x6A28
	Size: 0x176
	Parameters: 1
	Flags: Linked
*/
function _should_skip_anim(animation)
{
	if(!(isdefined(self._s.player) && self._s.player) && (!(isdefined(self._s.sharedigc) && self._s.sharedigc)) && (!(isdefined(self._s.keepwhileskipping) && self._s.keepwhileskipping)) && (isdefined([[ self._o_bundle ]]->is_skipping_scene()) && [[ self._o_bundle ]]->is_skipping_scene()) && (isdefined(self._s.deletewhenfinished) && self._s.deletewhenfinished))
	{
		if(!animhasimportantnotifies(animation))
		{
			if(!isspawner(self._e))
			{
				b_allows_multiple = [[ scene() ]]->allows_multiple();
				e = scene::get_existing_ent(self._str_name, b_allows_multiple);
				if(isdefined(e))
				{
					return 0;
				}
			}
			return 1;
		}
	}
	return 0;
}

/*
	Name: _should_skip_entity
	Namespace: csceneobject
	Checksum: 0xB07EB728
	Offset: 0x6BA8
	Size: 0x216
	Parameters: 0
	Flags: Linked
*/
function _should_skip_entity()
{
	if(!(isdefined(self._s.player) && self._s.player) && (!(isdefined(self._s.sharedigc) && self._s.sharedigc)) && (!(isdefined(self._s.keepwhileskipping) && self._s.keepwhileskipping)) && (isdefined([[ self._o_bundle ]]->is_skipping_scene()) && [[ self._o_bundle ]]->is_skipping_scene()) && (isdefined(self._s.deletewhenfinished) && self._s.deletewhenfinished))
	{
		if(isdefined(self._s.initanim) && animhasimportantnotifies(self._s.initanim))
		{
			return 0;
		}
		if(isdefined(self._s.mainanim) && animhasimportantnotifies(self._s.mainanim))
		{
			return 0;
		}
		if(isdefined(self._s.endanim) && animhasimportantnotifies(self._s.endanim))
		{
			return 0;
		}
		if(!isspawner(self._e))
		{
			b_allows_multiple = [[ scene() ]]->allows_multiple();
			e = scene::get_existing_ent(self._str_name, b_allows_multiple);
			if(isdefined(e))
			{
				return 0;
			}
		}
		return 1;
	}
	return 0;
}

/*
	Name: skip_anim_on_client
	Namespace: csceneobject
	Checksum: 0x507B2946
	Offset: 0x6DC8
	Size: 0x8C
	Parameters: 2
	Flags: Linked, Private
*/
private function skip_anim_on_client(entity, anim_name)
{
	if(!isdefined(anim_name))
	{
		return;
	}
	if(!isdefined(entity))
	{
		return;
	}
	if(!entity isplayinganimscripted())
	{
		return;
	}
	is_looping = isanimlooping(anim_name);
	if(is_looping)
	{
		return;
	}
	entity clientfield::increment("player_scene_animation_skip");
}

/*
	Name: skip_anim_on_server
	Namespace: csceneobject
	Checksum: 0xA770363A
	Offset: 0x6E60
	Size: 0xBC
	Parameters: 2
	Flags: Linked, Private
*/
private function skip_anim_on_server(entity, anim_name)
{
	if(!isdefined(anim_name))
	{
		return;
	}
	if(!isdefined(entity))
	{
		return;
	}
	if(!entity isplayinganimscripted())
	{
		return;
	}
	is_looping = isanimlooping(anim_name);
	if(is_looping)
	{
		entity animation::stop();
	}
	else
	{
		entity setanimtimebyname(anim_name, 1);
	}
	entity stopsounds();
}

/*
	Name: skip_scene_on_client
	Namespace: csceneobject
	Checksum: 0xC8D00C1C
	Offset: 0x6F28
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function skip_scene_on_client()
{
	if(isdefined(self.current_playing_anim))
	{
		/#
			if(getdvarint("") > 0)
			{
				printtoprightln("" + self._s.mainanim + "" + gettime(), vectorscale((1, 1, 1), 0.8));
			}
		#/
		if(is_shared_player())
		{
			foreach(var_3df49f70, player in level.players)
			{
				skip_anim_on_client(player, self.current_playing_anim[player getentitynumber()]);
			}
		}
		else
		{
			skip_anim_on_client(self._e, self.current_playing_anim);
		}
		return 1;
	}
	return 0;
}

/*
	Name: skip_scene_on_server
	Namespace: csceneobject
	Checksum: 0x3D743F93
	Offset: 0x7090
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function skip_scene_on_server()
{
	if(isdefined(self.current_playing_anim))
	{
		/#
			if(getdvarint("") > 0)
			{
				printtoprightln("" + self._s.mainanim + "" + gettime(), (1, 1, 1));
			}
		#/
		if(is_shared_player())
		{
			foreach(var_77c735fe, player in level.players)
			{
				skip_anim_on_server(player, self.current_playing_anim[player getentitynumber()]);
			}
		}
		else
		{
			skip_anim_on_server(self._e, self.current_playing_anim);
		}
	}
}

/*
	Name: skip_scene
	Namespace: csceneobject
	Checksum: 0x74AB899
	Offset: 0x71E8
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function skip_scene(b_wait_one_frame)
{
	if(isdefined(b_wait_one_frame))
	{
		wait(0.05);
	}
	if(skip_scene_on_client())
	{
		wait(0.05);
	}
	skip_scene_on_server();
}

#namespace scene;

/*
	Name: csceneobject
	Namespace: scene
	Checksum: 0xEEF50CA
	Offset: 0x7248
	Size: 0xAD6
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function csceneobject()
{
	classes.csceneobject[0] = spawnstruct();
	classes.csceneobject[0].__vtable[964891661] = &cscriptbundleobjectbase::get_ent;
	classes.csceneobject[0].__vtable[-162565429] = &cscriptbundleobjectbase::warning;
	classes.csceneobject[0].__vtable[-32002227] = &cscriptbundleobjectbase::error;
	classes.csceneobject[0].__vtable[1621988813] = &cscriptbundleobjectbase::log;
	classes.csceneobject[0].__vtable[-1017222485] = &cscriptbundleobjectbase::init;
	classes.csceneobject[0].__vtable[1606033458] = &cscriptbundleobjectbase::__destructor;
	classes.csceneobject[0].__vtable[-1690805083] = &cscriptbundleobjectbase::__constructor;
	classes.csceneobject[0].__vtable[-533039539] = &csceneobject::skip_scene;
	classes.csceneobject[0].__vtable[59785327] = &csceneobject::skip_scene_on_server;
	classes.csceneobject[0].__vtable[793954659] = &csceneobject::skip_scene_on_client;
	classes.csceneobject[0].__vtable[-1908648798] = &csceneobject::skip_anim_on_server;
	classes.csceneobject[0].__vtable[74477678] = &csceneobject::skip_anim_on_client;
	classes.csceneobject[0].__vtable[1747665309] = &csceneobject::_should_skip_entity;
	classes.csceneobject[0].__vtable[930261435] = &csceneobject::_should_skip_anim;
	classes.csceneobject[0].__vtable[-1004716425] = &csceneobject::in_a_different_scene;
	classes.csceneobject[0].__vtable[-1769748375] = &csceneobject::is_shared_player;
	classes.csceneobject[0].__vtable[9120349] = &csceneobject::is_player_model;
	classes.csceneobject[0].__vtable[1426764347] = &csceneobject::is_player;
	classes.csceneobject[0].__vtable[-1924366689] = &csceneobject::is_alive;
	classes.csceneobject[0].__vtable[1064337886] = &csceneobject::has_init_state;
	classes.csceneobject[0].__vtable[-1437057178] = &csceneobject::reset_player;
	classes.csceneobject[0].__vtable[458145835] = &csceneobject::link_player;
	classes.csceneobject[0].__vtable[-1404324058] = &csceneobject::get_camera_tween_out;
	classes.csceneobject[0].__vtable[1796348751] = &csceneobject::get_camera_tween;
	classes.csceneobject[0].__vtable[-1574922781] = &csceneobject::get_lerp_time;
	classes.csceneobject[0].__vtable[-1725384325] = &csceneobject::regroup_invulnerability;
	classes.csceneobject[0].__vtable[372641686] = &csceneobject::play_regroup_fx_for_scene;
	classes.csceneobject[0].__vtable[1466913678] = &csceneobject::_play_shared_player_anim_for_player;
	classes.csceneobject[0].__vtable[-773801222] = &csceneobject::_play_shared_player_anim;
	classes.csceneobject[0].__vtable[-747054044] = &csceneobject::spawn_ent;
	classes.csceneobject[0].__vtable[-1706684566] = &csceneobject::_play_anim;
	classes.csceneobject[0].__vtable[-140819375] = &csceneobject::_track_goal;
	classes.csceneobject[0].__vtable[-1068382246] = &csceneobject::_set_goal;
	classes.csceneobject[0].__vtable[751796260] = &csceneobject::_cleanup;
	classes.csceneobject[0].__vtable[-480064742] = &csceneobject::do_death_anims;
	classes.csceneobject[0].__vtable[-1522430464] = &csceneobject::_on_death;
	classes.csceneobject[0].__vtable[1056386707] = &csceneobject::set_objective;
	classes.csceneobject[0].__vtable[-61589233] = &csceneobject::_finish_player;
	classes.csceneobject[0].__vtable[-1089329960] = &csceneobject::finish;
	classes.csceneobject[0].__vtable[-165058024] = &csceneobject::set_player_stance;
	classes.csceneobject[0].__vtable[724938382] = &csceneobject::revive_player;
	classes.csceneobject[0].__vtable[1573351179] = &csceneobject::_prepare_player;
	classes.csceneobject[0].__vtable[-800750439] = &csceneobject::_prepare;
	classes.csceneobject[0].__vtable[987150381] = &csceneobject::_spawn;
	classes.csceneobject[0].__vtable[-1878563751] = &csceneobject::get_orig_name;
	classes.csceneobject[0].__vtable[245263499] = &csceneobject::get_name;
	classes.csceneobject[0].__vtable[737108631] = &csceneobject::_assign_unique_name;
	classes.csceneobject[0].__vtable[1811815105] = &csceneobject::_on_damage_run_scene_thread;
	classes.csceneobject[0].__vtable[214070679] = &csceneobject::scene;
	classes.csceneobject[0].__vtable[-2100195004] = &csceneobject::get_align_tag;
	classes.csceneobject[0].__vtable[1666938539] = &csceneobject::get_align_ent;
	classes.csceneobject[0].__vtable[-51025227] = &csceneobject::stop;
	classes.csceneobject[0].__vtable[1131512199] = &csceneobject::play;
	classes.csceneobject[0].__vtable[-422924033] = &csceneobject::initialize;
	classes.csceneobject[0].__vtable[-1191896790] = &csceneobject::first_init;
	classes.csceneobject[0].__vtable[1606033458] = &csceneobject::__destructor;
	classes.csceneobject[0].__vtable[-1690805083] = &csceneobject::__constructor;
}

#namespace cscene;

/*
	Name: __constructor
	Namespace: cscene
	Checksum: 0xDF0F1158
	Offset: 0x7D28
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	cscriptbundlebase::__constructor();
	self._n_object_id = 0;
	self._str_mode = "";
	self._n_streamer_req = -1;
}

/*
	Name: __destructor
	Namespace: cscene
	Checksum: 0x8367A4AD
	Offset: 0x7D70
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
	Checksum: 0x563FCB33
	Offset: 0x7D90
	Size: 0x4A4
	Parameters: 5
	Flags: Linked
*/
function init(str_scenedef, s_scenedef, e_align, a_ents, b_test_run)
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + str_scenedef);
		}
		if(isdefined(level.scriptbundles[""][s_scenedef.name]))
		{
			level.scriptbundles[""][s_scenedef.name].used = 1;
		}
	#/
	cscriptbundlebase::init(str_scenedef, s_scenedef, b_test_run);
	if(isdefined(s_scenedef.streamerhint) && s_scenedef.streamerhint != "" && !is_skipping_scene())
	{
		self._n_streamer_req = streamerrequest("set", s_scenedef.streamerhint);
	}
	self._str_notify_name = (isstring(self._s.malebundle) ? self._s.malebundle : self._str_name);
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
		foreach(var_21f99a30, s_obj in a_objs)
		{
			cscriptbundlebase::add_object([[ [[ self ]]->new_object() ]]->first_init(s_obj, self));
		}
		self._n_request_time = gettime();
		if(!(isdefined(self._s.dontsync) && self._s.dontsync))
		{
			add_to_sync_list();
		}
		self thread initialize(a_ents);
	}
}

/*
	Name: add_to_sync_list
	Namespace: cscene
	Checksum: 0xF34FE90
	Offset: 0x8240
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function add_to_sync_list()
{
	if(!isdefined(level.scene_sync_list))
	{
		level.scene_sync_list = [];
	}
	if(!isdefined(level.scene_sync_list[self._n_request_time]))
	{
		level.scene_sync_list[self._n_request_time] = [];
	}
	array::add(level.scene_sync_list[self._n_request_time], self, 0);
}

/*
	Name: remove_from_sync_list
	Namespace: cscene
	Checksum: 0x4F49CE4F
	Offset: 0x82B8
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function remove_from_sync_list()
{
	if(isdefined(level.scene_sync_list) && isdefined(level.scene_sync_list[self._n_request_time]))
	{
		arrayremovevalue(level.scene_sync_list[self._n_request_time], self);
		if(!level.scene_sync_list[self._n_request_time].size)
		{
			level.scene_sync_list[self._n_request_time] = undefined;
		}
	}
}

/*
	Name: new_object
	Namespace: cscene
	Checksum: 0xB65273D4
	Offset: 0x8338
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function new_object()
{
	object = new csceneobject();
	[[ object ]]->__constructor();
	return object;
}

/*
	Name: get_valid_object_defs
	Namespace: cscene
	Checksum: 0xF324064D
	Offset: 0x8358
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function get_valid_object_defs()
{
	a_obj_defs = [];
	foreach(var_4b655191, s_obj in self._s.objects)
	{
		if(self._s.vmtype == "server" || s_obj.vmtype == "server")
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
	Checksum: 0x920C9A5B
	Offset: 0x8500
	Size: 0x1D4
	Parameters: 2
	Flags: Linked
*/
function initialize(a_ents, b_playing = 0)
{
	self notify(#"new_state");
	self endon(#"new_state");
	self thread sync_with_client_scene("init", self._testing);
	assign_ents(a_ents);
	if(get_valid_objects().size > 0)
	{
		level flagsys::set(self._str_name + "_initialized");
		self._str_state = "init";
		foreach(var_79c5e5b5, o_obj in self._a_objects)
		{
			thread [[ o_obj ]]->initialize();
		}
	}
	if(!b_playing)
	{
		thread _call_state_funcs("init");
	}
	wait_till_scene_ready();
	level flagsys::set(self._str_notify_name + "_ready");
	array::flagsys_wait(self._a_objects, "done");
	thread stop();
}

/*
	Name: get_object_id
	Namespace: cscene
	Checksum: 0xF449872A
	Offset: 0x86E0
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
	Name: sync_with_client_scene
	Namespace: cscene
	Checksum: 0x5DE58E10
	Offset: 0x8700
	Size: 0x164
	Parameters: 2
	Flags: Linked
*/
function sync_with_client_scene(str_state, b_test_run = 0)
{
	if(self._s.vmtype == "both" && !self._s scene::is_igc())
	{
		self endon(#"new_state");
		wait_till_scene_ready();
		n_val = undefined;
		if(b_test_run)
		{
			switch(str_state)
			{
				case "stop":
				{
					n_val = 3;
					break;
				}
				case "init":
				{
					n_val = 4;
					break;
				}
				case "play":
				{
					n_val = 5;
					break;
				}
			}
		}
		else
		{
			switch(str_state)
			{
				case "stop":
				{
					n_val = 0;
					break;
				}
				case "init":
				{
					n_val = 1;
					break;
				}
				case "play":
				{
					n_val = 2;
					break;
				}
			}
		}
		level clientfield::set(self._s.name, n_val);
	}
}

/*
	Name: assign_ents
	Namespace: cscene
	Checksum: 0x1FA40692
	Offset: 0x8870
	Size: 0x216
	Parameters: 1
	Flags: Linked
*/
function assign_ents(a_ents)
{
	if(!isdefined(a_ents))
	{
		a_ents = [];
	}
	else if(!isarray(a_ents))
	{
		a_ents = array(a_ents);
	}
	a_objects = arraycopy(self._a_objects);
	if(_assign_ents_by_name(a_objects, a_ents))
	{
		if(_assign_ents_by_type(a_objects, a_ents, "player", &_is_ent_player))
		{
			if(_assign_ents_by_type(a_objects, a_ents, "actor", &_is_ent_actor))
			{
				if(_assign_ents_by_type(a_objects, a_ents, "vehicle", &_is_ent_vehicle))
				{
					if(_assign_ents_by_type(a_objects, a_ents, "prop"))
					{
						foreach(var_d67a6b97, ent in a_ents)
						{
							obj = array::pop(a_objects);
							if(!cscriptbundlebase::error(!isdefined(obj), "No scene object to assign entity too.  You might have passed in more than the scene supports."))
							{
								obj._e = ent;
							}
						}
					}
				}
			}
		}
	}
}

/*
	Name: _assign_ents_by_name
	Namespace: cscene
	Checksum: 0x6AB56B48
	Offset: 0x8A90
	Size: 0x2A0
	Parameters: 2
	Flags: Linked
*/
function _assign_ents_by_name(a_objects, a_ents)
{
	if(a_ents.size)
	{
		foreach(str_name, e_ent in arraycopy(a_ents))
		{
			foreach(i, o_obj in arraycopy(a_objects))
			{
				if(isdefined(o_obj._s.name) && (isdefined(o_obj._s.name) ? "" + o_obj._s.name : "") == tolower((isdefined(str_name) ? "" + str_name : "")))
				{
					o_obj._e = e_ent;
					arrayremoveindex(a_ents, str_name, 1);
					arrayremoveindex(a_objects, i);
					break;
				}
			}
		}
		/#
			foreach(i, ent in a_ents)
			{
				cscriptbundlebase::error(isstring(i), "" + i + "");
			}
		#/
	}
	return a_ents.size;
}

/*
	Name: _assign_ents_by_type
	Namespace: cscene
	Checksum: 0x2B723095
	Offset: 0x8D38
	Size: 0x180
	Parameters: 4
	Flags: Linked
*/
function _assign_ents_by_type(a_objects, a_ents, str_type, func_test)
{
	if(a_ents.size)
	{
		a_objects_of_type = get_objects(str_type);
		if(a_objects_of_type.size)
		{
			foreach(var_513ae985, ent in arraycopy(a_ents))
			{
				if(isdefined(func_test) && [[func_test]](ent))
				{
					obj = array::pop_front(a_objects_of_type);
					if(isdefined(obj))
					{
						obj._e = ent;
						arrayremovevalue(a_ents, ent, 1);
						arrayremovevalue(a_objects, obj);
						continue;
					}
					break;
				}
			}
		}
	}
	return a_ents.size;
}

/*
	Name: _is_ent_player
	Namespace: cscene
	Checksum: 0x741AF0F0
	Offset: 0x8EC0
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function _is_ent_player(ent)
{
	return isplayer(ent);
}

/*
	Name: _is_ent_actor
	Namespace: cscene
	Checksum: 0x643EA8A6
	Offset: 0x8EF0
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function _is_ent_actor(ent)
{
	return isactor(ent) || isactorspawner(ent);
}

/*
	Name: _is_ent_vehicle
	Namespace: cscene
	Checksum: 0x6D65A597
	Offset: 0x8F38
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function _is_ent_vehicle(ent)
{
	return isvehicle(ent) || isvehiclespawner(ent);
}

/*
	Name: get_objects
	Namespace: cscene
	Checksum: 0x45DDEAEB
	Offset: 0x8F80
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function get_objects(str_type)
{
	a_ret = [];
	foreach(var_177984ed, obj in self._a_objects)
	{
		if(obj._s.type == str_type)
		{
			if(!isdefined(a_ret))
			{
				a_ret = [];
			}
			else if(!isarray(a_ret))
			{
				a_ret = array(a_ret);
			}
			a_ret[a_ret.size] = obj;
		}
	}
	return a_ret;
}

/*
	Name: get_anim_relative_start_time
	Namespace: cscene
	Checksum: 0x196EDE29
	Offset: 0x9098
	Size: 0xF8
	Parameters: 2
	Flags: Linked
*/
function get_anim_relative_start_time(animation, n_time)
{
	if(!isdefined(self.n_start_time) || self.n_start_time == 0 || !isdefined(self.longest_anim_length) || self.longest_anim_length == 0)
	{
		return n_time;
	}
	anim_length = getanimlength(animation);
	is_looping = isanimlooping(animation);
	n_time = self.longest_anim_length / anim_length * n_time;
	if(is_looping)
	{
		if(n_time > 0.95)
		{
			n_time = 0.95;
		}
	}
	else if(n_time > 0.99)
	{
		n_time = 0.99;
	}
	return n_time;
}

/*
	Name: is_player_anim_ending_early
	Namespace: cscene
	Checksum: 0x580C2457
	Offset: 0x9198
	Size: 0x136
	Parameters: 0
	Flags: Linked
*/
function is_player_anim_ending_early()
{
	max_anim_length = -1;
	player_anim_length = -1;
	foreach(var_b62b8a78, obj in self._a_objects)
	{
		if(isdefined(obj._s.mainanim))
		{
			anim_length = getanimlength(obj._s.mainanim);
		}
		if(obj._s.type === "player")
		{
			player_anim_length = anim_length;
		}
		if(anim_length > max_anim_length)
		{
			max_anim_length = anim_length;
		}
	}
	return player_anim_length < max_anim_length;
}

/*
	Name: play
	Namespace: cscene
	Checksum: 0x7B93E10E
	Offset: 0x92D8
	Size: 0xD84
	Parameters: 4
	Flags: Linked
*/
function play(str_state = "play", a_ents, b_testing = 0, str_mode = "")
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + self._s.name);
		}
	#/
	self notify(#"new_state");
	self endon(#"new_state");
	if(str_mode == "skip_scene")
	{
		thread skip_scene(1);
	}
	else if(str_mode == "skip_scene_player")
	{
		self.b_player_scene = 1;
		thread skip_scene(1);
	}
	else if(!is_skipping_scene() && is_scene_shared_sequence() && !is_scene_shared())
	{
		init_scene_sequence_started(0);
	}
	update_scene_sequence();
	self._testing = b_testing;
	self._str_mode = str_mode;
	if(isdefined(self._s.spectateonjoin) && self._s.spectateonjoin)
	{
		level.scene_should_spectate_on_hot_join = 1;
	}
	assign_ents(a_ents);
	if(strstartswith(self._str_mode, "capture"))
	{
		if(get_valid_objects().size)
		{
			foreach(var_a6c07c28, o_obj in self._a_objects)
			{
				thread [[ o_obj ]]->initialize(1);
			}
		}
		thread loop_camera_anim_to_set_up_for_capture();
		capture_player = level.players[0];
		v_origin = get_align_ent().origin;
		if(!isdefined(capture_player.e_capture_link))
		{
			capture_player.e_capture_link = util::spawn_model("tag_origin", v_origin);
			capture_player setorigin(v_origin);
			capture_player linkto(level.players[0].e_capture_link);
		}
		else
		{
			capture_player.e_capture_link.origin = v_origin;
		}
		wait(15);
		thread _stop_camera_anims();
	}
	self thread sync_with_client_scene("play", b_testing);
	self.n_start_time = 0;
	if(issubstr(str_mode, "skipto"))
	{
		args = strtok(str_mode, ":");
		if(isdefined(args[1]))
		{
			self.n_start_time = float(args[1]);
		}
		else
		{
			self.n_start_time = 0.95;
		}
		self.longest_anim_length = 0;
		foreach(var_37a55643, s_obj in self._a_objects)
		{
			if(isdefined(s_obj._s.mainanim))
			{
				anim_length = getanimlength(s_obj._s.mainanim);
				if(anim_length > self.longest_anim_length)
				{
					self.longest_anim_length = anim_length;
				}
			}
		}
	}
	if(get_valid_objects().size || self._s scene::is_igc())
	{
		level flagsys::set(self._str_name + "_playing");
		self._str_state = "play";
		foreach(var_908cd79e, o_obj in self._a_objects)
		{
			thread [[ o_obj ]]->play();
		}
		wait_till_scene_ready();
		level flagsys::set(self._str_notify_name + "_ready");
		if(strstartswith(self._str_mode, "capture"))
		{
			/#
				adddebugcommand("" + self._str_name + "" + self._str_name);
			#/
		}
		if(self.n_start_time == 0)
		{
			self thread _play_camera_anims();
		}
		/#
			if(is_scene_shared())
			{
				display_dev_info();
			}
		#/
		if(self._n_streamer_req != -1 && !is_skipping_scene())
		{
			streamerrequest("play", self._s.streamerhint);
		}
		thread _call_state_funcs("play");
		if(self._s scene::is_igc())
		{
			if(!(isdefined(self._s.disablesceneskipping) && self._s.disablesceneskipping) && self._str_state != "init")
			{
				trigger_scene_sequence_started(self);
			}
			if(isstring(self._s.cameraswitcher))
			{
				_wait_for_camera_animation(self._s.cameraswitcher, self.n_start_time);
			}
			else if(isstring(self._s.extracamswitcher1))
			{
				_wait_for_camera_animation(self._s.extracamswitcher1, self.n_start_time);
			}
			else if(isstring(self._s.extracamswitcher2))
			{
				_wait_for_camera_animation(self._s.extracamswitcher2, self.n_start_time);
			}
			else if(isstring(self._s.extracamswitcher3))
			{
				_wait_for_camera_animation(self._s.extracamswitcher3, self.n_start_time);
			}
			else if(isstring(self._s.extracamswitcher4))
			{
				_wait_for_camera_animation(self._s.extracamswitcher4, self.n_start_time);
			}
			foreach(var_d5231ee4, o_obj in self._a_objects)
			{
				thread [[ o_obj ]]->stop(0, isdefined(o_obj._s.dontclamp) && o_obj._s.dontclamp, 1);
			}
			self._e_root notify(#"scene_done", self._str_notify_name);
			thread _call_state_funcs("done");
			if(isdefined(self._s.spectateonjoin) && self._s.spectateonjoin)
			{
				level.scene_should_spectate_on_hot_join = undefined;
			}
		}
		else
		{
			array::flagsys_wait_any_flag(self._a_objects, "done", "main_done");
			if(isdefined(self._e_root))
			{
				self._e_root notify(#"scene_done", self._str_notify_name);
			}
			thread _call_state_funcs("done");
			if(isdefined(self._s.spectateonjoin) && self._s.spectateonjoin)
			{
				level.scene_should_spectate_on_hot_join = undefined;
			}
			array::flagsys_wait(self._a_objects, "done");
		}
		if(is_looping() || strendswith(self._str_mode, "loop"))
		{
			if(has_init_state())
			{
				level flagsys::clear(self._str_name + "_playing");
				thread initialize();
			}
			else
			{
				level flagsys::clear(self._str_name + "_initialized");
				thread play(str_state, undefined, b_testing, str_mode);
			}
		}
		else if(!strendswith(self._str_mode, "single"))
		{
			thread run_next();
		}
		else if(!is_skipping_scene())
		{
			if(is_scene_shared_sequence())
			{
				init_scene_sequence_started(0);
			}
		}
		else if(isdefined(level.linked_scenes))
		{
			arrayremovevalue(level.linked_scenes, self._s.name);
		}
		streamer_request_completed();
		if(!self._s scene::is_igc() || (!(isdefined(self._s.holdcameralastframe) && self._s.holdcameralastframe)))
		{
			thread stop(0, 1);
		}
	}
	else
	{
		thread stop(0, 1);
	}
}

/*
	Name: _wait_server_time
	Namespace: cscene
	Checksum: 0xF9DDB393
	Offset: 0xA068
	Size: 0xC0
	Parameters: 2
	Flags: Linked
*/
function _wait_server_time(n_time, n_start_time = 0)
{
	n_len = n_time - n_time * n_start_time;
	n_len = n_len / 0.05;
	n_len_int = int(n_len);
	if(n_len_int != n_len)
	{
		n_len = floor(n_len);
	}
	n_server_length = n_len * 0.05;
	wait(n_server_length);
}

/*
	Name: _wait_for_camera_animation
	Namespace: cscene
	Checksum: 0x7A2FE463
	Offset: 0xA130
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function _wait_for_camera_animation(str_cam, n_start_time)
{
	self endon(#"skip_camera_anims");
	if(iscamanimlooping(str_cam))
	{
		level waittill(#"forever");
	}
	else
	{
		_wait_server_time(getcamanimtime(str_cam) / 1000, n_start_time);
	}
}

/*
	Name: _play_camera_anims
	Namespace: cscene
	Checksum: 0x8B1484DB
	Offset: 0xA1B8
	Size: 0x46C
	Parameters: 0
	Flags: Linked
*/
function _play_camera_anims()
{
	level endon(#"stop_camera_anims");
	waittillframeend();
	e_align = get_align_ent();
	v_origin = (isdefined(e_align.origin) ? e_align.origin : (0, 0, 0));
	v_angles = (isdefined(e_align.angles) ? e_align.angles : (0, 0, 0));
	xcam_players = [];
	if(isdefined(self._s.linkxcamtooneplayer) && self._s.linkxcamtooneplayer)
	{
		foreach(var_15e6833c, o_obj in self._a_objects)
		{
			if(isdefined(o_obj) && [[ o_obj ]]->is_player() && !([[ o_obj ]]->is_shared_player()))
			{
				if(!isdefined(xcam_players))
				{
					xcam_players = [];
				}
				else if(!isarray(xcam_players))
				{
					xcam_players = array(xcam_players);
				}
				xcam_players[xcam_players.size] = o_obj._player;
			}
		}
		if(xcam_players.size == 0)
		{
			xcam_players = level.players;
		}
		else
		{
			self.a_xcam_players = xcam_players;
		}
	}
	else
	{
		xcam_players = level.players;
	}
	if(isstring(self._s.cameraswitcher))
	{
		if(!(isdefined(self._s.linkxcamtooneplayer) && self._s.linkxcamtooneplayer))
		{
			callback::on_loadout(&_play_camera_anim_on_player_callback, self);
		}
		self.camera_v_origin = v_origin;
		self.camera_v_angles = v_angles;
		self.camera_start_time = gettime();
		array::thread_all_ents(xcam_players, &_play_camera_anim_on_player, v_origin, v_angles, 0);
		/#
			display_dev_info();
		#/
	}
	if(isstring(self._s.extracamswitcher1))
	{
		array::thread_all_ents(xcam_players, &_play_extracam_on_player, 0, self._s.extracamswitcher1, v_origin, v_angles);
	}
	if(isstring(self._s.extracamswitcher2))
	{
		array::thread_all_ents(xcam_players, &_play_extracam_on_player, 1, self._s.extracamswitcher2, v_origin, v_angles);
	}
	if(isstring(self._s.extracamswitcher3))
	{
		array::thread_all_ents(xcam_players, &_play_extracam_on_player, 2, self._s.extracamswitcher3, v_origin, v_angles);
	}
	if(isstring(self._s.extracamswitcher4))
	{
		array::thread_all_ents(xcam_players, &_play_extracam_on_player, 3, self._s.extracamswitcher4, v_origin, v_angles);
	}
}

/*
	Name: _play_camera_anim_on_player_callback
	Namespace: cscene
	Checksum: 0x6350BAAE
	Offset: 0xA630
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function _play_camera_anim_on_player_callback(player)
{
	self thread _play_camera_anim_on_player(player, self.camera_v_origin, self.camera_v_angles, 1);
}

/*
	Name: _play_camera_anim_on_player
	Namespace: cscene
	Checksum: 0x86172340
	Offset: 0xA678
	Size: 0x11C
	Parameters: 4
	Flags: Linked
*/
function _play_camera_anim_on_player(player, v_origin, v_angles, ignore_initial_notetracks)
{
	player notify(#"new_camera_switcher");
	player dontinterpolate();
	player thread scene::scene_disable_player_stuff();
	self.played_camera_anims = 1;
	n_start_time = self.camera_start_time;
	if(!isdefined(self._s.cameraswitchergraphiccontents) || ismature(player))
	{
		camanimscripted(player, self._s.cameraswitcher, n_start_time, v_origin, v_angles);
	}
	else
	{
		camanimscripted(player, self._s.cameraswitchergraphiccontents, n_start_time, v_origin, v_angles);
	}
}

/*
	Name: loop_camera_anim_to_set_up_for_capture
	Namespace: cscene
	Checksum: 0xDAA6866E
	Offset: 0xA7A0
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function loop_camera_anim_to_set_up_for_capture()
{
	level endon(#"stop_camera_anims");
	while(true)
	{
		_play_camera_anims();
		_wait_for_camera_animation(self._s.cameraswitcher);
	}
}

/*
	Name: _play_extracam_on_player
	Namespace: cscene
	Checksum: 0xCC122E63
	Offset: 0xA7F8
	Size: 0x64
	Parameters: 5
	Flags: Linked
*/
function _play_extracam_on_player(player, n_index, str_camera_anim, v_origin, v_angles)
{
	self.played_camera_anims = 1;
	extracamanimscripted(player, n_index, str_camera_anim, gettime(), v_origin, v_angles);
}

/*
	Name: _stop_camera_anims
	Namespace: cscene
	Checksum: 0x1D1A0185
	Offset: 0xA868
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function _stop_camera_anims()
{
	if(!(isdefined(self.played_camera_anims) && self.played_camera_anims))
	{
		return;
	}
	level notify(#"stop_camera_anims");
	xcam_players = [];
	if(isdefined(self.a_xcam_players))
	{
		xcam_players = self.a_xcam_players;
	}
	else
	{
		xcam_players = getplayers();
	}
	foreach(var_50fdc189, player in xcam_players)
	{
		if(isdefined(player))
		{
			self thread _stop_camera_anim_on_player(player);
		}
	}
}

/*
	Name: _stop_camera_anim_on_player
	Namespace: cscene
	Checksum: 0xFC66B766
	Offset: 0xA978
	Size: 0x1D4
	Parameters: 1
	Flags: Linked
*/
function _stop_camera_anim_on_player(player)
{
	player endon(#"disconnect");
	if(isstring(self._s.cameraswitcher))
	{
		player endon(#"new_camera_switcher");
		player dontinterpolate();
		endcamanimscripted(player);
		player thread scene::scene_enable_player_stuff();
		if(!(isdefined(self._s.linkxcamtooneplayer) && self._s.linkxcamtooneplayer))
		{
			callback::remove_on_loadout(&_play_camera_anim_on_player_callback, self);
		}
	}
	if(isstring(self._s.extracamswitcher1))
	{
		endextracamanimscripted(player, 0);
	}
	if(isstring(self._s.extracamswitcher2))
	{
		endextracamanimscripted(player, 1);
	}
	if(isstring(self._s.extracamswitcher3))
	{
		endextracamanimscripted(player, 2);
	}
	if(isstring(self._s.extracamswitcher4))
	{
		endextracamanimscripted(player, 3);
	}
}

/*
	Name: display_dev_info
	Namespace: cscene
	Checksum: 0x19F69593
	Offset: 0xAB58
	Size: 0x374
	Parameters: 0
	Flags: Linked
*/
function display_dev_info()
{
	if(isstring(self._s.devstate) && getdvarint("scr_show_shot_info_for_igcs", 0))
	{
		if(!isdefined(level.hud_scene_dev_info1))
		{
			level.hud_scene_dev_info1 = newhudelem();
			level.hud_scene_dev_info1.alignx = "right";
			level.hud_scene_dev_info1.aligny = "bottom";
			level.hud_scene_dev_info1.horzalign = "user_right";
			level.hud_scene_dev_info1.y = 400;
			level.hud_scene_dev_info1.fontscale = 1.3;
			level.hud_scene_dev_info1.color = (0.4392157, 0.5019608, 0.5647059);
			level.hud_scene_dev_info1 settext("SCENE: " + toupper(self._s.name));
		}
		if(!isdefined(level.hud_scene_dev_info2))
		{
			level.hud_scene_dev_info2 = newhudelem();
			level.hud_scene_dev_info2.alignx = "right";
			level.hud_scene_dev_info2.aligny = "bottom";
			level.hud_scene_dev_info2.horzalign = "user_right";
			level.hud_scene_dev_info2.y = 420;
			level.hud_scene_dev_info2.fontscale = 1.3;
			level.hud_scene_dev_info2.color = (0.4392157, 0.5019608, 0.5647059);
		}
		level.hud_scene_dev_info2 settext("SHOT: " + toupper(self._s.name));
		if(!isdefined(level.hud_scene_dev_info3))
		{
			level.hud_scene_dev_info3 = newhudelem();
			level.hud_scene_dev_info3.alignx = "right";
			level.hud_scene_dev_info3.aligny = "bottom";
			level.hud_scene_dev_info3.horzalign = "user_right";
			level.hud_scene_dev_info3.y = 440;
			level.hud_scene_dev_info3.fontscale = 1.3;
			level.hud_scene_dev_info3.color = (0.4392157, 0.5019608, 0.5647059);
			level.hud_scene_dev_info3 settext("STATE: " + toupper(self._s.devstate));
		}
	}
	else
	{
		destroy_dev_info();
	}
}

/*
	Name: destroy_dev_info
	Namespace: cscene
	Checksum: 0x5BB01553
	Offset: 0xAED8
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function destroy_dev_info()
{
	if(isdefined(level.hud_scene_dev_info1))
	{
		level.hud_scene_dev_info1 destroy();
	}
	if(isdefined(level.hud_scene_dev_info2))
	{
		level.hud_scene_dev_info2 destroy();
	}
	if(isdefined(level.hud_scene_dev_info3))
	{
		level.hud_scene_dev_info3 destroy();
	}
}

/*
	Name: is_skipping_scene
	Namespace: cscene
	Checksum: 0x5CF91DB8
	Offset: 0xAF60
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function is_skipping_scene()
{
	if(self._s.name == "cin_ram_02_04_interview_part04")
	{
		return 0;
	}
	return isdefined(self.skipping_scene) && self.skipping_scene || self._str_mode == "skip_scene" || self._str_mode == "skip_scene_player";
}

/*
	Name: is_skipping_player_scene
	Namespace: cscene
	Checksum: 0x6F2E75AE
	Offset: 0xAFC8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function is_skipping_player_scene()
{
	return isdefined(self.b_player_scene) && self.b_player_scene || self._str_mode == "skip_scene_player" && !array::contains(level.linked_scenes, self._s.name);
}

/*
	Name: has_next_scene
	Namespace: cscene
	Checksum: 0x24D7AC82
	Offset: 0xB030
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function has_next_scene()
{
	return isdefined(self._s.nextscenebundle);
}

/*
	Name: run_next
	Namespace: cscene
	Checksum: 0x4110A62
	Offset: 0xB050
	Size: 0x42C
	Parameters: 0
	Flags: Linked
*/
function run_next()
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + gettime());
		}
	#/
	b_run_next_scene = 0;
	if(isdefined(self._s.nextscenebundle))
	{
		self waittill(#"stopped", b_finished);
		if(b_finished)
		{
			b_skip_scene = is_skipping_scene();
			if(b_skip_scene)
			{
				self util::waittill_any_timeout(5, "scene_skip_completed");
				/#
					if(getdvarint("") > 0)
					{
						printtoprightln("" + self._s.nextscenebundle + "" + gettime(), (1, 1, 0));
					}
				#/
			}
			/#
				if(getdvarint("") > 0)
				{
					printtoprightln("" + self._s.nextscenebundle + "" + gettime(), (1, 0, 0));
				}
			#/
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
			else if(b_skip_scene)
			{
				if(is_skipping_player_scene())
				{
					self._str_mode = "skip_scene_player";
				}
				else
				{
					self._str_mode = "skip_scene";
				}
			}
			else
			{
				b_run_next_scene = 1;
			}
			if(allows_multiple())
			{
				self._e_root thread scene::play(self._s.nextscenebundle, get_ents(), undefined, undefined, undefined, self._str_mode);
			}
			else
			{
				self._e_root thread scene::play(self._s.nextscenebundle, undefined, undefined, undefined, undefined, self._str_mode);
			}
		}
	}
	if(!(isdefined(b_run_next_scene) && b_run_next_scene))
	{
		if(!is_skipping_scene())
		{
			if(is_scene_shared_sequence())
			{
				init_scene_sequence_started(0);
			}
		}
		else if(isdefined(level.linked_scenes))
		{
			arrayremovevalue(level.linked_scenes, self._s.name);
		}
		streamer_request_completed();
	}
}

/*
	Name: streamer_request_completed
	Namespace: cscene
	Checksum: 0x398810E3
	Offset: 0xB488
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function streamer_request_completed()
{
	if(isstring(self._s._endstreamerhint))
	{
		if(getdvarint("scene_hide_player") > 0)
		{
			foreach(var_fdec9a, player in level.players)
			{
				player show();
			}
		}
		streamerrequest("clear", self._s._endstreamerhint);
	}
}

/*
	Name: stop
	Namespace: cscene
	Checksum: 0xB9DFBA90
	Offset: 0xB588
	Size: 0x4F4
	Parameters: 2
	Flags: Linked
*/
function stop(b_clear = 0, b_finished = 0)
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + self._s.name);
		}
	#/
	if(isdefined(self._str_state))
	{
		/#
			if(getdvarint("") > 0)
			{
				printtoprightln("" + self._s.name + "" + self._str_state);
			}
		#/
		/#
			if(strstartswith(self._str_mode, ""))
			{
				adddebugcommand("");
			}
		#/
		if(!b_finished)
		{
			streamer_request_completed();
		}
		if(!is_skipping_scene())
		{
			if(!isdefined(self._s.nextscenebundle) && is_scene_shared_sequence())
			{
				init_scene_sequence_started(0);
			}
		}
		self thread sync_with_client_scene("stop", b_clear);
		self._str_state = undefined;
		self notify(#"new_state");
		self notify(#"death");
		level flagsys::clear(self._str_name + "_playing");
		level flagsys::clear(self._str_name + "_initialized");
		thread _call_state_funcs("stop");
		self.scene_stopping = 1;
		if(isdefined(self._a_objects) && !b_finished)
		{
			foreach(var_178e0a73, o_obj in self._a_objects)
			{
				if(isdefined(o_obj) && !([[ o_obj ]]->in_a_different_scene()))
				{
					thread [[ o_obj ]]->stop(b_clear);
				}
			}
		}
		self thread _stop_camera_anims();
		/#
			if(!isdefined(self._s.nextscenebundle) || !b_finished)
			{
				destroy_dev_info();
			}
		#/
		/#
			if(getdvarint("") > 0)
			{
				printtoprightln("" + self._s.name);
			}
		#/
		self.scene_stopped = 1;
		self notify(#"stopped", b_finished);
		remove_from_sync_list();
		arrayremovevalue(level.active_scenes[self._str_name], self._e_root);
		if(level.active_scenes[self._str_name].size == 0)
		{
			level.active_scenes[self._str_name] = undefined;
		}
		if(isdefined(self._e_root))
		{
			arrayremovevalue(self._e_root.scenes, self);
			if(self._e_root.scenes.size == 0)
			{
				self._e_root.scenes = undefined;
			}
			self._e_root notify(#"scene_done", self._str_notify_name);
			self._e_root.scene_played = 1;
		}
	}
	if(isdefined(self._s.spectateonjoin) && self._s.spectateonjoin)
	{
		level.scene_should_spectate_on_hot_join = undefined;
	}
	self thread _release_object();
}

/*
	Name: _release_object
	Namespace: cscene
	Checksum: 0x78E38572
	Offset: 0xBA88
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function _release_object()
{
	wait(0.05);
	foreach(var_bea68918, o_obj in self._a_objects)
	{
		o_obj._o_bundle = undefined;
	}
}

/*
	Name: has_init_state
	Namespace: cscene
	Checksum: 0xE2F8F6D5
	Offset: 0xBB18
	Size: 0xAA
	Parameters: 0
	Flags: Linked
*/
function has_init_state()
{
	b_has_init_state = 0;
	foreach(var_79c6a3cf, o_scene_object in self._a_objects)
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
	Checksum: 0x448415B4
	Offset: 0xBBD0
	Size: 0x360
	Parameters: 1
	Flags: Linked
*/
function _call_state_funcs(str_state)
{
	self endon(#"stopped");
	wait_till_scene_ready(undefined, 1);
	if(str_state == "play")
	{
		waittillframeend();
	}
	level notify(self._str_notify_name + "_" + str_state);
	if(isdefined(level.scene_funcs) && isdefined(level.scene_funcs[self._str_notify_name]) && isdefined(level.scene_funcs[self._str_notify_name][str_state]))
	{
		a_ents = get_ents();
		foreach(var_121c3a0e, handler in level.scene_funcs[self._str_notify_name][str_state])
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

/*
	Name: get_ents
	Namespace: cscene
	Checksum: 0x6F1AB8A6
	Offset: 0xBF38
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function get_ents()
{
	a_ents = [];
	foreach(var_db604adf, o_obj in self._a_objects)
	{
		ent = [[ o_obj ]]->get_ent();
		if(isdefined(o_obj._s.name))
		{
			a_ents[o_obj._s.name] = ent;
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
	return a_ents;
}

/*
	Name: get_root
	Namespace: cscene
	Checksum: 0x15C68FCF
	Offset: 0xC088
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
	Checksum: 0x4A167F39
	Offset: 0xC0A0
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function get_align_ent()
{
	e_align = self._e_root;
	if(isdefined(self._s.aligntarget))
	{
		e_gdt_align = scene::get_existing_ent(self._s.aligntarget, 0, 1);
		if(isdefined(e_gdt_align))
		{
			e_align = e_gdt_align;
		}
		if(!isdefined(e_gdt_align))
		{
			str_msg = "Align target '" + (isdefined(self._s.aligntarget) ? "" + self._s.aligntarget : "") + "' doesn't exist for scene.";
			if(!cscriptbundlebase::warning(self._testing, str_msg))
			{
				cscriptbundlebase::error(getdvarint("scene_align_errors", 1), str_msg);
			}
		}
	}
	else if(isdefined(self._e_root.e_scene_link))
	{
		e_align = self._e_root.e_scene_link;
	}
	return e_align;
}

/*
	Name: allows_multiple
	Namespace: cscene
	Checksum: 0x41A897EC
	Offset: 0xC208
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
	Checksum: 0x22F3E629
	Offset: 0xC238
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
	Checksum: 0x5F04BA51
	Offset: 0xC268
	Size: 0x13C
	Parameters: 2
	Flags: Linked
*/
function wait_till_scene_ready(o_exclude, b_ignore_streamer = 0)
{
	a_objects = [];
	if(isdefined(o_exclude))
	{
		a_objects = array::exclude(self._a_objects, o_exclude);
	}
	else
	{
		a_objects = self._a_objects;
	}
	wait_till_objects_ready(a_objects);
	if(self._n_streamer_req != -1)
	{
		if(!b_ignore_streamer)
		{
			if(isdefined(level.wait_for_streamer_hint_scenes))
			{
				if(isinarray(level.wait_for_streamer_hint_scenes, self._s.name))
				{
					if(!is_skipping_scene())
					{
						level util::streamer_wait(self._n_streamer_req, 0, 5);
					}
				}
			}
		}
	}
	flagsys::set("ready");
	sync_with_other_scenes();
}

/*
	Name: wait_till_objects_ready
	Namespace: cscene
	Checksum: 0xF09A4FE0
	Offset: 0xC3B0
	Size: 0xF0
	Parameters: 1
	Flags: Linked
*/
function wait_till_objects_ready(array)
{
	do
	{
		recheck = 0;
		foreach(var_febf1a2f, ent in array)
		{
			if(isdefined(ent) && !ent flagsys::get("ready"))
			{
				ent util::waittill_either("death", "ready");
				recheck = 1;
				break;
			}
		}
	}
	while(recheck);
}

/*
	Name: sync_with_other_scenes
	Namespace: cscene
	Checksum: 0x35D433C4
	Offset: 0xC4A8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function sync_with_other_scenes()
{
	if(!(isdefined(self._s.dontsync) && self._s.dontsync) && isdefined(level.scene_sync_list) && isarray(level.scene_sync_list[self._n_request_time]))
	{
		wait_till_objects_ready(level.scene_sync_list[self._n_request_time]);
	}
}

/*
	Name: get_valid_objects
	Namespace: cscene
	Checksum: 0x7A0BC075
	Offset: 0xC538
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function get_valid_objects()
{
	a_obj = [];
	foreach(var_27bd264b, obj in self._a_objects)
	{
		if(obj._is_valid)
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
	Checksum: 0xF8F81798
	Offset: 0xC638
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
	Checksum: 0xBBEAFEB1
	Offset: 0xC658
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_state()
{
	return self._str_state;
}

/*
	Name: is_scene_shared
	Namespace: cscene
	Checksum: 0xD10977B7
	Offset: 0xC670
	Size: 0x152
	Parameters: 0
	Flags: Linked
*/
function is_scene_shared()
{
	if(!(isdefined(self._s.skip_scene) && self._s.skip_scene) && !self._s scene::is_igc())
	{
		foreach(var_30032512, o_scene_object in self._a_objects)
		{
			if(o_scene_object._is_valid && [[ o_scene_object ]]->is_shared_player())
			{
				b_shared_player = 1;
			}
		}
		if(!isdefined(b_shared_player))
		{
			/#
				if(getdvarint("") > 0)
				{
					printtoprightln("" + gettime(), (1, 0, 0));
				}
			#/
			self notify(#"scene_skip_completed");
			return 0;
		}
	}
	return 1;
}

/*
	Name: skip_scene
	Namespace: cscene
	Checksum: 0xFA5EC6BC
	Offset: 0xC7D0
	Size: 0x722
	Parameters: 1
	Flags: Linked
*/
function skip_scene(b_sequence)
{
	if(isdefined(b_sequence) && b_sequence && (isdefined(self._s.disablesceneskipping) && self._s.disablesceneskipping))
	{
		/#
			if(getdvarint("") > 0)
			{
				printtoprightln("" + self._s.name + "" + gettime(), (1, 0, 0));
			}
		#/
		finish_skip_scene();
		return;
	}
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + self._s.name + "" + gettime(), (0, 1, 0));
		}
	#/
	if(!(isdefined(b_sequence) && b_sequence))
	{
		if(self._str_state == "init")
		{
			while(self._str_state == "init")
			{
				wait(0.05);
			}
		}
		if(is_skipping_player_scene())
		{
			/#
				if(getdvarint("") > 0)
				{
					printtoprightln("" + gettime());
				}
			#/
			/#
				if(getdvarint("") == 0)
				{
					b_skip_fading = 0;
				}
				else
				{
					b_skip_fading = 1;
				}
			#/
			if(!(isdefined(b_skip_fading) && b_skip_fading))
			{
				foreach(var_b19df20e, player in level.players)
				{
					player freezecontrols(1);
				}
				level.suspend_scene_skip_until_fade = 1;
				level thread lui::screen_fade(1, 1, 0, "black", 0, "scene_system");
				wait(1);
				level.suspend_scene_skip_until_fade = undefined;
			}
			setpauseworld(0);
		}
		while(isdefined(level.suspend_scene_skip_until_fade) && level.suspend_scene_skip_until_fade)
		{
			wait(0.05);
		}
	}
	if(isdefined(self._s.nextscenebundle))
	{
		bnextsceneexist = 1;
	}
	else
	{
		bnextsceneexist = 0;
	}
	wait_till_scene_ready();
	wait(0.05);
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + self._s.name + "" + gettime(), (0, 0, 1));
		}
	#/
	_call_state_funcs("skip_started");
	thread _skip_scene();
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + gettime(), (0, 1, 0));
		}
	#/
	/#
		if(getdvarint("") > 0)
		{
			if(isdefined(level.animation_played))
			{
				for(i = 0; i < level.animation_played.size; i++)
				{
					printtoprightln("" + level.animation_played[i], (1, 0, 0), -1);
				}
			}
		}
	#/
	scene_skip_timeout = gettime() + 4000;
	while(!(isdefined(self.scene_stopped) && self.scene_stopped) && gettime() < scene_skip_timeout)
	{
		wait(0.05);
	}
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + self._s.name + "" + gettime(), (1, 0.5, 0));
		}
	#/
	_call_state_funcs("skip_completed");
	self notify(#"scene_skip_completed");
	if(!bnextsceneexist)
	{
		if(is_skipping_player_scene())
		{
			if(isdefined(level.linked_scenes))
			{
				linked_scenes_timeout = gettime() + 4000;
				while(level.linked_scenes.size > 0 && gettime() < linked_scenes_timeout)
				{
					wait(0.05);
				}
			}
			finish_skip_scene();
		}
		else if(isdefined(self.skipping_scene) && self.skipping_scene)
		{
			self.skipping_scene = undefined;
			if(isdefined(level.linked_scenes))
			{
				arrayremovevalue(level.linked_scenes, self._s.name);
			}
		}
	}
	else if(is_skipping_player_scene())
	{
		if(self._s scene::is_igc())
		{
			foreach(var_3f748429, player in level.players)
			{
				player stopsounds();
			}
		}
	}
}

/*
	Name: finish_skip_scene
	Namespace: cscene
	Checksum: 0xAB0FF12
	Offset: 0xCF00
	Size: 0x254
	Parameters: 0
	Flags: Linked, Private
*/
private function finish_skip_scene()
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("" + gettime(), (1, 0, 0));
		}
	#/
	if(isdefined(level.player_skipping_scene))
	{
		foreach(var_f1db902d, player in level.players)
		{
			player clientfield::increment_to_player("player_scene_skip_completed");
			player freezecontrols(0);
			player stopsounds();
		}
		self.b_player_scene = undefined;
		self.skipping_scene = undefined;
		level.player_skipping_scene = undefined;
		level.linked_scenes = undefined;
		init_scene_sequence_started(0);
		level notify(#"scene_skip_sequence_ended");
		if(isdefined(level.bzm_sceneseqendedcallback))
		{
			level thread [[level.bzm_sceneseqendedcallback]](self._s.name);
		}
		/#
			if(getdvarint("") > 0)
			{
				printtoprightln("" + gettime());
			}
		#/
		/#
			if(getdvarint("") == 0)
			{
				b_skip_fading = 0;
			}
			else
			{
				b_skip_fading = 1;
			}
		#/
		if(!(isdefined(b_skip_fading) && b_skip_fading))
		{
			if(!(isdefined(level.level_ending) && level.level_ending))
			{
				level thread lui::screen_fade(1, 0, 1, "black", 0, "scene_system");
			}
		}
	}
}

/*
	Name: _skip_scene
	Namespace: cscene
	Checksum: 0x69921A04
	Offset: 0xD160
	Size: 0x14A
	Parameters: 0
	Flags: Linked, Private
*/
private function _skip_scene()
{
	self endon(#"stopped");
	wait(0.05);
	foreach(var_86e9e81e, o_scene_object in self._a_objects)
	{
		if(o_scene_object._is_valid)
		{
			[[ o_scene_object ]]->skip_scene_on_client();
		}
	}
	wait(0.05);
	foreach(var_209ffd39, o_scene_object in self._a_objects)
	{
		if(o_scene_object._is_valid)
		{
			[[ o_scene_object ]]->skip_scene_on_server();
		}
	}
	self notify(#"skip_camera_anims");
}

/*
	Name: should_skip_linked_to_players_scene
	Namespace: cscene
	Checksum: 0xBCCC6F8D
	Offset: 0xD2B8
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function should_skip_linked_to_players_scene()
{
	if(isdefined(level.player_skipping_scene) && (!(isdefined(self._s.disablesceneskipping) && self._s.disablesceneskipping)) && array::contains(level.linked_scenes, self._s.name))
	{
		return 1;
	}
	return 0;
}

/*
	Name: is_scene_shared_sequence
	Namespace: cscene
	Checksum: 0x96435E5A
	Offset: 0xD330
	Size: 0x20
	Parameters: 0
	Flags: Linked, Private
*/
private function is_scene_shared_sequence()
{
	return isdefined(level.shared_scene_sequence_started) && isdefined(self._s.shared_scene_sequence);
}

/*
	Name: update_scene_sequence
	Namespace: cscene
	Checksum: 0x53FF8296
	Offset: 0xD358
	Size: 0x4A
	Parameters: 0
	Flags: Linked, Private
*/
private function update_scene_sequence()
{
	if(isdefined(self._s.shared_scene_sequence))
	{
		if(isdefined(level.shared_scene_sequence_started))
		{
			level.shared_scene_sequence_name = self._s.name;
		}
		else
		{
			level.shared_scene_sequence_name = undefined;
		}
	}
}

/*
	Name: init_scene_sequence_started
	Namespace: cscene
	Checksum: 0x662B861F
	Offset: 0xD3B0
	Size: 0x222
	Parameters: 1
	Flags: Linked, Private
*/
private function init_scene_sequence_started(b_started)
{
	if(isdefined(b_started) && b_started)
	{
		scene::waittill_skip_sequence_completed();
		if(isdefined(level.shared_scene_sequence_started))
		{
			return;
		}
		self._s.shared_scene_sequence = 1;
		if(isdefined(self._s.s_female_bundle))
		{
			self._s.s_female_bundle.shared_scene_sequence = self._s.shared_scene_sequence;
		}
		if(isstring(self._s.nextscenebundle))
		{
			s_cur_bundle = scene::get_scenedef(self._s.nextscenebundle);
			while(true)
			{
				s_cur_bundle.shared_scene_sequence = self._s.shared_scene_sequence;
				if(isdefined(s_cur_bundle.s_female_bundle))
				{
					s_cur_bundle.s_female_bundle.shared_scene_sequence = self._s.shared_scene_sequence;
				}
				if(isstring(s_cur_bundle.nextscenebundle))
				{
					s_cur_bundle = scene::get_scenedef(s_cur_bundle.nextscenebundle);
				}
				else
				{
					break;
				}
			}
		}
		level.shared_scene_sequence_started = 1;
		update_scene_sequence();
		level notify(#"scene_sequence_started");
	}
	else if(!isdefined(level.shared_scene_sequence_started))
	{
		return;
	}
	if(isdefined(self._s.shared_scene_sequence))
	{
		level.shared_scene_sequence_started = undefined;
		update_scene_sequence();
		level notify(#"scene_sequence_ended", self._s.name);
	}
}

/*
	Name: trigger_scene_sequence_started
	Namespace: cscene
	Checksum: 0x3873C558
	Offset: 0xD5E0
	Size: 0x13C
	Parameters: 2
	Flags: Linked, Private
*/
private function trigger_scene_sequence_started(scene_object, entity)
{
	if(self === scene_object)
	{
		if(!is_skipping_scene())
		{
			init_scene_sequence_started(1);
		}
		return;
	}
	if(isplayer(entity))
	{
		if(!(isdefined(self._s.disablesceneskipping) && self._s.disablesceneskipping) && !is_skipping_scene())
		{
			if([[ scene_object ]]->is_shared_player() || self._s scene::is_igc())
			{
				if(self._str_state != "init" || (isdefined(scene_object._s.initanim) || isdefined(scene_object._s.initanimloop)))
				{
					init_scene_sequence_started(1);
				}
			}
		}
	}
}

/*
	Name: has_player
	Namespace: cscene
	Checksum: 0x7A740448
	Offset: 0xD728
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function has_player()
{
	foreach(var_b1ddbdb4, obj in self._a_objects)
	{
		if(obj._s.type === "player")
		{
			return 1;
		}
	}
	return 0;
}

#namespace scene;

/*
	Name: cscene
	Namespace: scene
	Checksum: 0x2AD662AC
	Offset: 0xD7D0
	Size: 0xE36
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cscene()
{
	classes.cscene[0] = spawnstruct();
	classes.cscene[0].__vtable[-162565429] = &cscriptbundlebase::warning;
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
	classes.cscene[0].__vtable[-1880665427] = &cscene::has_player;
	classes.cscene[0].__vtable[-1576975760] = &cscene::trigger_scene_sequence_started;
	classes.cscene[0].__vtable[1513946904] = &cscene::init_scene_sequence_started;
	classes.cscene[0].__vtable[-984761095] = &cscene::update_scene_sequence;
	classes.cscene[0].__vtable[238059560] = &cscene::is_scene_shared_sequence;
	classes.cscene[0].__vtable[1986348612] = &cscene::should_skip_linked_to_players_scene;
	classes.cscene[0].__vtable[-526572144] = &cscene::_skip_scene;
	classes.cscene[0].__vtable[1874227759] = &cscene::finish_skip_scene;
	classes.cscene[0].__vtable[-533039539] = &cscene::skip_scene;
	classes.cscene[0].__vtable[-1865989864] = &cscene::is_scene_shared;
	classes.cscene[0].__vtable[1194857509] = &cscene::get_state;
	classes.cscene[0].__vtable[-498584435] = &cscene::on_error;
	classes.cscene[0].__vtable[-241958475] = &cscene::get_valid_objects;
	classes.cscene[0].__vtable[12225688] = &cscene::sync_with_other_scenes;
	classes.cscene[0].__vtable[1456932829] = &cscene::wait_till_objects_ready;
	classes.cscene[0].__vtable[792158469] = &cscene::wait_till_scene_ready;
	classes.cscene[0].__vtable[17277842] = &cscene::is_looping;
	classes.cscene[0].__vtable[400356434] = &cscene::allows_multiple;
	classes.cscene[0].__vtable[1666938539] = &cscene::get_align_ent;
	classes.cscene[0].__vtable[1282680066] = &cscene::get_root;
	classes.cscene[0].__vtable[64630156] = &cscene::get_ents;
	classes.cscene[0].__vtable[415171386] = &cscene::_call_state_funcs;
	classes.cscene[0].__vtable[1064337886] = &cscene::has_init_state;
	classes.cscene[0].__vtable[-494029713] = &cscene::_release_object;
	classes.cscene[0].__vtable[-51025227] = &cscene::stop;
	classes.cscene[0].__vtable[-452669220] = &cscene::streamer_request_completed;
	classes.cscene[0].__vtable[-1243624088] = &cscene::run_next;
	classes.cscene[0].__vtable[214463356] = &cscene::has_next_scene;
	classes.cscene[0].__vtable[-1889990966] = &cscene::is_skipping_player_scene;
	classes.cscene[0].__vtable[-1402092568] = &cscene::is_skipping_scene;
	classes.cscene[0].__vtable[-2083104676] = &cscene::destroy_dev_info;
	classes.cscene[0].__vtable[2077358244] = &cscene::display_dev_info;
	classes.cscene[0].__vtable[-2028962726] = &cscene::_stop_camera_anim_on_player;
	classes.cscene[0].__vtable[-890532943] = &cscene::_stop_camera_anims;
	classes.cscene[0].__vtable[229949954] = &cscene::_play_extracam_on_player;
	classes.cscene[0].__vtable[-1903538323] = &cscene::loop_camera_anim_to_set_up_for_capture;
	classes.cscene[0].__vtable[1001613456] = &cscene::_play_camera_anim_on_player;
	classes.cscene[0].__vtable[1009630058] = &cscene::_play_camera_anim_on_player_callback;
	classes.cscene[0].__vtable[238037755] = &cscene::_play_camera_anims;
	classes.cscene[0].__vtable[-270289448] = &cscene::_wait_for_camera_animation;
	classes.cscene[0].__vtable[-1564828019] = &cscene::_wait_server_time;
	classes.cscene[0].__vtable[1131512199] = &cscene::play;
	classes.cscene[0].__vtable[1999725373] = &cscene::is_player_anim_ending_early;
	classes.cscene[0].__vtable[1436097111] = &cscene::get_anim_relative_start_time;
	classes.cscene[0].__vtable[-512051494] = &cscene::get_objects;
	classes.cscene[0].__vtable[308264447] = &cscene::_is_ent_vehicle;
	classes.cscene[0].__vtable[1875786724] = &cscene::_is_ent_actor;
	classes.cscene[0].__vtable[1760832570] = &cscene::_is_ent_player;
	classes.cscene[0].__vtable[328967479] = &cscene::_assign_ents_by_type;
	classes.cscene[0].__vtable[1017166354] = &cscene::_assign_ents_by_name;
	classes.cscene[0].__vtable[1526733891] = &cscene::assign_ents;
	classes.cscene[0].__vtable[-569738146] = &cscene::sync_with_client_scene;
	classes.cscene[0].__vtable[-1443067443] = &cscene::get_object_id;
	classes.cscene[0].__vtable[-422924033] = &cscene::initialize;
	classes.cscene[0].__vtable[-794265383] = &cscene::get_valid_object_defs;
	classes.cscene[0].__vtable[900706181] = &cscene::new_object;
	classes.cscene[0].__vtable[1130660665] = &cscene::remove_from_sync_list;
	classes.cscene[0].__vtable[614912131] = &cscene::add_to_sync_list;
	classes.cscene[0].__vtable[-1017222485] = &cscene::init;
	classes.cscene[0].__vtable[1606033458] = &cscene::__destructor;
	classes.cscene[0].__vtable[-1690805083] = &cscene::__constructor;
}

#namespace cawarenesssceneobject;

/*
	Name: play
	Namespace: cawarenesssceneobject
	Checksum: 0xB31AC001
	Offset: 0xE610
	Size: 0x29C
	Parameters: 1
	Flags: Linked
*/
function play(str_alert_state)
{
	flagsys::clear("ready");
	flagsys::clear("done");
	flagsys::clear("main_done");
	self._str_state = "play";
	self notify(#"new_state");
	self endon(#"new_state");
	self notify(#"play");
	cscriptbundleobjectbase::log("play");
	waittillframeend();
	switch(str_alert_state)
	{
		case "low_alert":
		{
			cscriptbundleobjectbase::log("LOW ALERT");
			if(isdefined(self._s.lowalertanim))
			{
				self._str_death_anim = self._s.lowalertanimdeath;
				self._str_death_anim_loop = self._s.lowalertanimdeathloop;
				csceneobject::_play_anim(self._s.lowalertanim);
			}
			break;
		}
		case "high_alert":
		{
			cscriptbundleobjectbase::log("HIGH ALERT");
			if(isdefined(self._s.highalertanim))
			{
				self._str_death_anim = self._s.highalertanimdeath;
				self._str_death_anim_loop = self._s.highalertanimdeathloop;
				csceneobject::_play_anim(self._s.highalertanim);
			}
			break;
		}
		case "combat":
		{
			cscriptbundleobjectbase::log("COMBAT ALERT");
			if(isdefined(self._s.combatalertanim))
			{
				self._str_death_anim = self._s.combatalertanimdeath;
				self._str_death_anim_loop = self._s.combatalertanimdeathloop;
				csceneobject::_play_anim(self._s.combatalertanim);
			}
			break;
		}
		default:
		{
			cscriptbundleobjectbase::error(1, "Unsupported alert state");
		}
	}
	thread csceneobject::finish();
}

/*
	Name: _prepare
	Namespace: cawarenesssceneobject
	Checksum: 0x8E41C8C0
	Offset: 0xE8B8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function _prepare()
{
	if(csceneobject::_prepare())
	{
		if(isai(self._e))
		{
			thread _on_alert_run_scene_thread();
		}
	}
}

/*
	Name: _on_alert_run_scene_thread
	Namespace: cawarenesssceneobject
	Checksum: 0xF822E1FB
	Offset: 0xE908
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function _on_alert_run_scene_thread()
{
	self endon(#"play");
	self endon(#"done");
	self._e waittill(#"alert", str_alert_state);
	/#
		if(getdvarint("", 0))
		{
			print3d(self._e.origin, "", (1, 0, 0), 1, 0.5, 20);
		}
	#/
	thread [[ csceneobject::scene() ]]->play(str_alert_state);
}

/*
	Name: __constructor
	Namespace: cawarenesssceneobject
	Checksum: 0x7C31CD6D
	Offset: 0xE9D0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	csceneobject::__constructor();
}

/*
	Name: __destructor
	Namespace: cawarenesssceneobject
	Checksum: 0xC732E42C
	Offset: 0xE9F0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
	csceneobject::__destructor();
}

#namespace scene;

/*
	Name: cawarenesssceneobject
	Namespace: scene
	Checksum: 0x7387322E
	Offset: 0xEA10
	Size: 0xBC6
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cawarenesssceneobject()
{
	classes.cawarenesssceneobject[0] = spawnstruct();
	classes.cawarenesssceneobject[0].__vtable[964891661] = &cscriptbundleobjectbase::get_ent;
	classes.cawarenesssceneobject[0].__vtable[-162565429] = &cscriptbundleobjectbase::warning;
	classes.cawarenesssceneobject[0].__vtable[-32002227] = &cscriptbundleobjectbase::error;
	classes.cawarenesssceneobject[0].__vtable[1621988813] = &cscriptbundleobjectbase::log;
	classes.cawarenesssceneobject[0].__vtable[-1017222485] = &cscriptbundleobjectbase::init;
	classes.cawarenesssceneobject[0].__vtable[1606033458] = &cscriptbundleobjectbase::__destructor;
	classes.cawarenesssceneobject[0].__vtable[-1690805083] = &cscriptbundleobjectbase::__constructor;
	classes.cawarenesssceneobject[0].__vtable[-533039539] = &csceneobject::skip_scene;
	classes.cawarenesssceneobject[0].__vtable[59785327] = &csceneobject::skip_scene_on_server;
	classes.cawarenesssceneobject[0].__vtable[793954659] = &csceneobject::skip_scene_on_client;
	classes.cawarenesssceneobject[0].__vtable[-1908648798] = &csceneobject::skip_anim_on_server;
	classes.cawarenesssceneobject[0].__vtable[74477678] = &csceneobject::skip_anim_on_client;
	classes.cawarenesssceneobject[0].__vtable[1747665309] = &csceneobject::_should_skip_entity;
	classes.cawarenesssceneobject[0].__vtable[930261435] = &csceneobject::_should_skip_anim;
	classes.cawarenesssceneobject[0].__vtable[-1004716425] = &csceneobject::in_a_different_scene;
	classes.cawarenesssceneobject[0].__vtable[-1769748375] = &csceneobject::is_shared_player;
	classes.cawarenesssceneobject[0].__vtable[9120349] = &csceneobject::is_player_model;
	classes.cawarenesssceneobject[0].__vtable[1426764347] = &csceneobject::is_player;
	classes.cawarenesssceneobject[0].__vtable[-1924366689] = &csceneobject::is_alive;
	classes.cawarenesssceneobject[0].__vtable[1064337886] = &csceneobject::has_init_state;
	classes.cawarenesssceneobject[0].__vtable[-1437057178] = &csceneobject::reset_player;
	classes.cawarenesssceneobject[0].__vtable[458145835] = &csceneobject::link_player;
	classes.cawarenesssceneobject[0].__vtable[-1404324058] = &csceneobject::get_camera_tween_out;
	classes.cawarenesssceneobject[0].__vtable[1796348751] = &csceneobject::get_camera_tween;
	classes.cawarenesssceneobject[0].__vtable[-1574922781] = &csceneobject::get_lerp_time;
	classes.cawarenesssceneobject[0].__vtable[-1725384325] = &csceneobject::regroup_invulnerability;
	classes.cawarenesssceneobject[0].__vtable[372641686] = &csceneobject::play_regroup_fx_for_scene;
	classes.cawarenesssceneobject[0].__vtable[1466913678] = &csceneobject::_play_shared_player_anim_for_player;
	classes.cawarenesssceneobject[0].__vtable[-773801222] = &csceneobject::_play_shared_player_anim;
	classes.cawarenesssceneobject[0].__vtable[-747054044] = &csceneobject::spawn_ent;
	classes.cawarenesssceneobject[0].__vtable[-1706684566] = &csceneobject::_play_anim;
	classes.cawarenesssceneobject[0].__vtable[-140819375] = &csceneobject::_track_goal;
	classes.cawarenesssceneobject[0].__vtable[-1068382246] = &csceneobject::_set_goal;
	classes.cawarenesssceneobject[0].__vtable[751796260] = &csceneobject::_cleanup;
	classes.cawarenesssceneobject[0].__vtable[-480064742] = &csceneobject::do_death_anims;
	classes.cawarenesssceneobject[0].__vtable[-1522430464] = &csceneobject::_on_death;
	classes.cawarenesssceneobject[0].__vtable[1056386707] = &csceneobject::set_objective;
	classes.cawarenesssceneobject[0].__vtable[-61589233] = &csceneobject::_finish_player;
	classes.cawarenesssceneobject[0].__vtable[-1089329960] = &csceneobject::finish;
	classes.cawarenesssceneobject[0].__vtable[-165058024] = &csceneobject::set_player_stance;
	classes.cawarenesssceneobject[0].__vtable[724938382] = &csceneobject::revive_player;
	classes.cawarenesssceneobject[0].__vtable[1573351179] = &csceneobject::_prepare_player;
	classes.cawarenesssceneobject[0].__vtable[-800750439] = &csceneobject::_prepare;
	classes.cawarenesssceneobject[0].__vtable[987150381] = &csceneobject::_spawn;
	classes.cawarenesssceneobject[0].__vtable[-1878563751] = &csceneobject::get_orig_name;
	classes.cawarenesssceneobject[0].__vtable[245263499] = &csceneobject::get_name;
	classes.cawarenesssceneobject[0].__vtable[737108631] = &csceneobject::_assign_unique_name;
	classes.cawarenesssceneobject[0].__vtable[1811815105] = &csceneobject::_on_damage_run_scene_thread;
	classes.cawarenesssceneobject[0].__vtable[214070679] = &csceneobject::scene;
	classes.cawarenesssceneobject[0].__vtable[-2100195004] = &csceneobject::get_align_tag;
	classes.cawarenesssceneobject[0].__vtable[1666938539] = &csceneobject::get_align_ent;
	classes.cawarenesssceneobject[0].__vtable[-51025227] = &csceneobject::stop;
	classes.cawarenesssceneobject[0].__vtable[1131512199] = &csceneobject::play;
	classes.cawarenesssceneobject[0].__vtable[-422924033] = &csceneobject::initialize;
	classes.cawarenesssceneobject[0].__vtable[-1191896790] = &csceneobject::first_init;
	classes.cawarenesssceneobject[0].__vtable[1606033458] = &csceneobject::__destructor;
	classes.cawarenesssceneobject[0].__vtable[-1690805083] = &csceneobject::__constructor;
	classes.cawarenesssceneobject[0].__vtable[1606033458] = &cawarenesssceneobject::__destructor;
	classes.cawarenesssceneobject[0].__vtable[-1690805083] = &cawarenesssceneobject::__constructor;
	classes.cawarenesssceneobject[0].__vtable[546281630] = &cawarenesssceneobject::_on_alert_run_scene_thread;
	classes.cawarenesssceneobject[0].__vtable[-800750439] = &cawarenesssceneobject::_prepare;
	classes.cawarenesssceneobject[0].__vtable[1131512199] = &cawarenesssceneobject::play;
}

#namespace cawarenessscene;

/*
	Name: new_object
	Namespace: cawarenessscene
	Checksum: 0x327F8B3E
	Offset: 0xF5E0
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function new_object()
{
	object = new cawarenesssceneobject();
	[[ object ]]->__constructor();
	return object;
}

/*
	Name: init
	Namespace: cawarenessscene
	Checksum: 0x919E126F
	Offset: 0xF600
	Size: 0x54
	Parameters: 5
	Flags: Linked
*/
function init(str_scenedef, s_scenedef, e_align, a_ents, b_test_run)
{
	cscene::init(str_scenedef, s_scenedef, e_align, a_ents, b_test_run);
}

/*
	Name: play
	Namespace: cawarenessscene
	Checksum: 0x9881489A
	Offset: 0xF660
	Size: 0x1C4
	Parameters: 1
	Flags: Linked
*/
function play(str_awareness_state = "low_alert")
{
	self notify(#"new_state");
	self endon(#"new_state");
	if(cscene::get_valid_objects().size > 0)
	{
		foreach(var_b617f0ac, o_obj in self._a_objects)
		{
			thread [[ o_obj ]]->play(str_awareness_state);
		}
		level flagsys::set(self._str_name + "_playing");
		self._str_state = "play";
		cscene::wait_till_scene_ready();
		thread cscene::_call_state_funcs(str_awareness_state);
		array::flagsys_wait_any_flag(self._a_objects, "done", "main_done");
		if(cscene::is_looping())
		{
		}
		else
		{
			thread cscene::stop();
		}
	}
	else
	{
		thread cscene::stop(0, 1);
	}
}

/*
	Name: __constructor
	Namespace: cawarenessscene
	Checksum: 0x8B7BB795
	Offset: 0xF830
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	cscene::__constructor();
}

/*
	Name: __destructor
	Namespace: cawarenessscene
	Checksum: 0xC404B084
	Offset: 0xF850
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
	cscene::__destructor();
}

#namespace scene;

/*
	Name: cawarenessscene
	Namespace: scene
	Checksum: 0xFB01E4CB
	Offset: 0xF870
	Size: 0xF26
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cawarenessscene()
{
	classes.cawarenessscene[0] = spawnstruct();
	classes.cawarenessscene[0].__vtable[-162565429] = &cscriptbundlebase::warning;
	classes.cawarenessscene[0].__vtable[-32002227] = &cscriptbundlebase::error;
	classes.cawarenessscene[0].__vtable[1621988813] = &cscriptbundlebase::log;
	classes.cawarenessscene[0].__vtable[713694985] = &cscriptbundlebase::remove_object;
	classes.cawarenessscene[0].__vtable[178798596] = &cscriptbundlebase::add_object;
	classes.cawarenessscene[0].__vtable[1440274456] = &cscriptbundlebase::is_testing;
	classes.cawarenessscene[0].__vtable[-512051494] = &cscriptbundlebase::get_objects;
	classes.cawarenessscene[0].__vtable[575565049] = &cscriptbundlebase::get_vm;
	classes.cawarenessscene[0].__vtable[245263499] = &cscriptbundlebase::get_name;
	classes.cawarenessscene[0].__vtable[1872615990] = &cscriptbundlebase::get_type;
	classes.cawarenessscene[0].__vtable[-1017222485] = &cscriptbundlebase::init;
	classes.cawarenessscene[0].__vtable[1606033458] = &cscriptbundlebase::__destructor;
	classes.cawarenessscene[0].__vtable[-1690805083] = &cscriptbundlebase::__constructor;
	classes.cawarenessscene[0].__vtable[-498584435] = &cscriptbundlebase::on_error;
	classes.cawarenessscene[0].__vtable[-1880665427] = &cscene::has_player;
	classes.cawarenessscene[0].__vtable[-1576975760] = &cscene::trigger_scene_sequence_started;
	classes.cawarenessscene[0].__vtable[1513946904] = &cscene::init_scene_sequence_started;
	classes.cawarenessscene[0].__vtable[-984761095] = &cscene::update_scene_sequence;
	classes.cawarenessscene[0].__vtable[238059560] = &cscene::is_scene_shared_sequence;
	classes.cawarenessscene[0].__vtable[1986348612] = &cscene::should_skip_linked_to_players_scene;
	classes.cawarenessscene[0].__vtable[-526572144] = &cscene::_skip_scene;
	classes.cawarenessscene[0].__vtable[1874227759] = &cscene::finish_skip_scene;
	classes.cawarenessscene[0].__vtable[-533039539] = &cscene::skip_scene;
	classes.cawarenessscene[0].__vtable[-1865989864] = &cscene::is_scene_shared;
	classes.cawarenessscene[0].__vtable[1194857509] = &cscene::get_state;
	classes.cawarenessscene[0].__vtable[-498584435] = &cscene::on_error;
	classes.cawarenessscene[0].__vtable[-241958475] = &cscene::get_valid_objects;
	classes.cawarenessscene[0].__vtable[12225688] = &cscene::sync_with_other_scenes;
	classes.cawarenessscene[0].__vtable[1456932829] = &cscene::wait_till_objects_ready;
	classes.cawarenessscene[0].__vtable[792158469] = &cscene::wait_till_scene_ready;
	classes.cawarenessscene[0].__vtable[17277842] = &cscene::is_looping;
	classes.cawarenessscene[0].__vtable[400356434] = &cscene::allows_multiple;
	classes.cawarenessscene[0].__vtable[1666938539] = &cscene::get_align_ent;
	classes.cawarenessscene[0].__vtable[1282680066] = &cscene::get_root;
	classes.cawarenessscene[0].__vtable[64630156] = &cscene::get_ents;
	classes.cawarenessscene[0].__vtable[415171386] = &cscene::_call_state_funcs;
	classes.cawarenessscene[0].__vtable[1064337886] = &cscene::has_init_state;
	classes.cawarenessscene[0].__vtable[-494029713] = &cscene::_release_object;
	classes.cawarenessscene[0].__vtable[-51025227] = &cscene::stop;
	classes.cawarenessscene[0].__vtable[-452669220] = &cscene::streamer_request_completed;
	classes.cawarenessscene[0].__vtable[-1243624088] = &cscene::run_next;
	classes.cawarenessscene[0].__vtable[214463356] = &cscene::has_next_scene;
	classes.cawarenessscene[0].__vtable[-1889990966] = &cscene::is_skipping_player_scene;
	classes.cawarenessscene[0].__vtable[-1402092568] = &cscene::is_skipping_scene;
	classes.cawarenessscene[0].__vtable[-2083104676] = &cscene::destroy_dev_info;
	classes.cawarenessscene[0].__vtable[2077358244] = &cscene::display_dev_info;
	classes.cawarenessscene[0].__vtable[-2028962726] = &cscene::_stop_camera_anim_on_player;
	classes.cawarenessscene[0].__vtable[-890532943] = &cscene::_stop_camera_anims;
	classes.cawarenessscene[0].__vtable[229949954] = &cscene::_play_extracam_on_player;
	classes.cawarenessscene[0].__vtable[-1903538323] = &cscene::loop_camera_anim_to_set_up_for_capture;
	classes.cawarenessscene[0].__vtable[1001613456] = &cscene::_play_camera_anim_on_player;
	classes.cawarenessscene[0].__vtable[1009630058] = &cscene::_play_camera_anim_on_player_callback;
	classes.cawarenessscene[0].__vtable[238037755] = &cscene::_play_camera_anims;
	classes.cawarenessscene[0].__vtable[-270289448] = &cscene::_wait_for_camera_animation;
	classes.cawarenessscene[0].__vtable[-1564828019] = &cscene::_wait_server_time;
	classes.cawarenessscene[0].__vtable[1131512199] = &cscene::play;
	classes.cawarenessscene[0].__vtable[1999725373] = &cscene::is_player_anim_ending_early;
	classes.cawarenessscene[0].__vtable[1436097111] = &cscene::get_anim_relative_start_time;
	classes.cawarenessscene[0].__vtable[-512051494] = &cscene::get_objects;
	classes.cawarenessscene[0].__vtable[308264447] = &cscene::_is_ent_vehicle;
	classes.cawarenessscene[0].__vtable[1875786724] = &cscene::_is_ent_actor;
	classes.cawarenessscene[0].__vtable[1760832570] = &cscene::_is_ent_player;
	classes.cawarenessscene[0].__vtable[328967479] = &cscene::_assign_ents_by_type;
	classes.cawarenessscene[0].__vtable[1017166354] = &cscene::_assign_ents_by_name;
	classes.cawarenessscene[0].__vtable[1526733891] = &cscene::assign_ents;
	classes.cawarenessscene[0].__vtable[-569738146] = &cscene::sync_with_client_scene;
	classes.cawarenessscene[0].__vtable[-1443067443] = &cscene::get_object_id;
	classes.cawarenessscene[0].__vtable[-422924033] = &cscene::initialize;
	classes.cawarenessscene[0].__vtable[-794265383] = &cscene::get_valid_object_defs;
	classes.cawarenessscene[0].__vtable[900706181] = &cscene::new_object;
	classes.cawarenessscene[0].__vtable[1130660665] = &cscene::remove_from_sync_list;
	classes.cawarenessscene[0].__vtable[614912131] = &cscene::add_to_sync_list;
	classes.cawarenessscene[0].__vtable[-1017222485] = &cscene::init;
	classes.cawarenessscene[0].__vtable[1606033458] = &cscene::__destructor;
	classes.cawarenessscene[0].__vtable[-1690805083] = &cscene::__constructor;
	classes.cawarenessscene[0].__vtable[1606033458] = &cawarenessscene::__destructor;
	classes.cawarenessscene[0].__vtable[-1690805083] = &cawarenessscene::__constructor;
	classes.cawarenessscene[0].__vtable[1131512199] = &cawarenessscene::play;
	classes.cawarenessscene[0].__vtable[-1017222485] = &cawarenessscene::init;
	classes.cawarenessscene[0].__vtable[900706181] = &cawarenessscene::new_object;
}

/*
	Name: get_existing_ent
	Namespace: scene
	Checksum: 0x3478FC9D
	Offset: 0x107A0
	Size: 0x362
	Parameters: 3
	Flags: Linked
*/
function get_existing_ent(str_name, b_spawner_only = 0, b_nodes_and_structs = 0)
{
	e = undefined;
	if(b_spawner_only)
	{
		e_array = getspawnerarray(str_name, "script_animname");
		if(e_array.size == 0)
		{
			e_array = getspawnerarray(str_name, "targetname");
		}
		/#
			assert(e_array.size <= 1, "");
		#/
		foreach(var_b4e1a52a, ent in e_array)
		{
			if(!isdefined(ent.isdying))
			{
				e = ent;
				break;
			}
		}
	}
	else
	{
		e = getent(str_name, "animname", 0);
		if(!is_valid_ent(e))
		{
			e = getent(str_name, "script_animname");
			if(!is_valid_ent(e))
			{
				e = getent(str_name + "_ai", "targetname", 1);
				if(!is_valid_ent(e))
				{
					e = getent(str_name + "_vh", "targetname", 1);
					if(!is_valid_ent(e))
					{
						e = getent(str_name, "targetname", 1);
						if(!is_valid_ent(e))
						{
							e = getent(str_name, "targetname");
							if(!is_valid_ent(e) && b_nodes_and_structs)
							{
								e = getnode(str_name, "targetname");
								if(!is_valid_ent(e))
								{
									e = struct::get(str_name, "targetname");
								}
							}
						}
					}
				}
			}
		}
	}
	if(!is_valid_ent(e))
	{
		e = undefined;
	}
	return e;
}

/*
	Name: is_valid_ent
	Namespace: scene
	Checksum: 0x27C29796
	Offset: 0x10B10
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function is_valid_ent(ent)
{
	return isdefined(ent) && (!isdefined(ent.isdying) && !ent ai::is_dead_sentient() || self._s.ignorealivecheck === 1);
}

/*
	Name: synced_delete
	Namespace: scene
	Checksum: 0x1B69815
	Offset: 0x10B78
	Size: 0x194
	Parameters: 0
	Flags: Linked
*/
function synced_delete()
{
	self endon(#"death");
	self.isdying = 1;
	if(isdefined(self.targetname))
	{
		self.targetname = self.targetname + "_sync_deleting";
	}
	if(isdefined(self.animname))
	{
		self.animname = self.animname + "_sync_deleting";
	}
	if(isdefined(self.script_animname))
	{
		self.script_animname = self.script_animname + "_sync_deleting";
	}
	if(!isplayer(self))
	{
		sethideonclientwhenscriptedanimcompleted(self);
		self stopanimscripted();
	}
	else
	{
		wait(0.05);
		self ghost();
	}
	self notsolid();
	if(isalive(self))
	{
		if(issentient(self))
		{
			self.ignoreall = 1;
		}
		if(isactor(self))
		{
			self pathmode("dont move");
		}
	}
	wait(1);
	self delete();
}

/*
	Name: __init__sytem__
	Namespace: scene
	Checksum: 0xEFFEEE90
	Offset: 0x10D18
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
	Checksum: 0x2D9EBB0A
	Offset: 0x10D60
	Size: 0x83C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.scene_object_id = 0;
	level.active_scenes = [];
	level.sceneskippedcount = 0;
	level.wait_for_streamer_hint_scenes = [];
	streamerrequest("clear");
	foreach(var_1555660, s_scenedef in struct::get_script_bundles("scene"))
	{
		s_scenedef.editaction = undefined;
		s_scenedef.newobject = undefined;
		if(isstring(s_scenedef.femalebundle))
		{
			s_female_bundle = struct::get_script_bundle("scene", s_scenedef.femalebundle);
			s_female_bundle.malebundle = s_scenedef.name;
			s_scenedef.s_female_bundle = s_female_bundle;
			s_female_bundle.s_male_bundle = s_scenedef;
		}
		if(isstring(s_scenedef.nextscenebundle))
		{
			foreach(i, s_object in s_scenedef.objects)
			{
				if(s_object.type === "player")
				{
					s_object.disabletransitionout = 1;
				}
			}
			s_next_bundle = struct::get_script_bundle("scene", s_scenedef.nextscenebundle);
			s_next_bundle.dontsync = 1;
			foreach(i, s_object in s_next_bundle.objects)
			{
				if(s_object.type === "player")
				{
					s_object.disabletransitionin = 1;
				}
				s_object.iscutscene = 1;
			}
			if(isdefined(s_next_bundle.femalebundle))
			{
				s_next_female_bundle = struct::get_script_bundle("scene", s_next_bundle.femalebundle);
				if(isdefined(s_next_female_bundle))
				{
					s_next_female_bundle.dontsync = 1;
					foreach(i, s_object in s_next_female_bundle.objects)
					{
						if(s_object.type === "player")
						{
							s_object.disabletransitionin = 1;
						}
						s_object.iscutscene = 1;
					}
				}
			}
		}
		if(isstring(s_scenedef.streamerhint))
		{
			s_cur_bundle = s_scenedef;
			while(true)
			{
				s_cur_bundle._endstreamerhint = s_scenedef.streamerhint;
				if(isstring(s_cur_bundle.nextscenebundle))
				{
					s_cur_bundle = struct::get_script_bundle("scene", s_cur_bundle.nextscenebundle);
				}
				else
				{
					break;
				}
			}
		}
		foreach(i, s_object in s_scenedef.objects)
		{
			if(s_object.type === "player")
			{
				if(!isdefined(s_object.cameratween))
				{
					s_object.cameratween = 0;
				}
				if(isdefined(s_object.player))
				{
					s_object.player--;
				}
				else
				{
					s_object.player = 0;
				}
				s_object.name = "player " + s_object.player + 1;
				s_object.newplayermethod = 1;
				continue;
			}
			s_object.player = undefined;
		}
		if(s_scenedef.vmtype == "both" && !s_scenedef is_igc())
		{
			n_clientbits = getminbitcountfornum(3);
			/#
				n_clientbits = getminbitcountfornum(6);
			#/
			clientfield::register("world", s_scenedef.name, 1, n_clientbits, "int");
		}
	}
	clientfield::register("toplayer", "postfx_igc", 1, 2, "counter");
	clientfield::register("world", "in_igc", 1, 4, "int");
	clientfield::register("toplayer", "player_scene_skip_completed", 1, 2, "counter");
	clientfield::register("allplayers", "player_scene_animation_skip", 1, 2, "counter");
	clientfield::register("actor", "player_scene_animation_skip", 1, 2, "counter");
	clientfield::register("vehicle", "player_scene_animation_skip", 1, 2, "counter");
	clientfield::register("scriptmover", "player_scene_animation_skip", 1, 2, "counter");
	callback::on_connect(&on_player_connect);
	callback::on_disconnect(&on_player_disconnect);
}

/*
	Name: remove_invalid_scene_objects
	Namespace: scene
	Checksum: 0xE695983F
	Offset: 0x115A8
	Size: 0x182
	Parameters: 1
	Flags: Linked
*/
function remove_invalid_scene_objects(s_scenedef)
{
	a_invalid_object_indexes = [];
	foreach(i, s_object in s_scenedef.objects)
	{
		if(!isdefined(s_object.name) && !isdefined(s_object.model) && !s_object.type === "player")
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
	Name: __main__
	Namespace: scene
	Checksum: 0x9E97626D
	Offset: 0x11738
	Size: 0x394
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	a_instances = arraycombine(struct::get_array("scriptbundle_scene", "classname"), struct::get_array("scriptbundle_fxanim", "classname"), 0, 0);
	foreach(var_f3e9f540, s_instance in a_instances)
	{
		if(isdefined(s_instance.linkto))
		{
			s_instance thread _scene_link();
		}
		if(isdefined(s_instance.script_flag_set))
		{
			level flag::init(s_instance.script_flag_set);
		}
		if(isdefined(s_instance.scriptgroup_initscenes))
		{
			foreach(var_daca0760, trig in getentarray(s_instance.scriptgroup_initscenes, "scriptgroup_initscenes"))
			{
				s_instance thread _trigger_init(trig);
			}
		}
		if(isdefined(s_instance.scriptgroup_playscenes))
		{
			foreach(var_adddaa8, trig in getentarray(s_instance.scriptgroup_playscenes, "scriptgroup_playscenes"))
			{
				s_instance thread _trigger_play(trig);
			}
		}
		if(isdefined(s_instance.scriptgroup_stopscenes))
		{
			foreach(var_a566625d, trig in getentarray(s_instance.scriptgroup_stopscenes, "scriptgroup_stopscenes"))
			{
				s_instance thread _trigger_stop(trig);
			}
		}
	}
	level thread on_load_wait();
	level thread run_instances();
}

/*
	Name: _scene_link
	Namespace: scene
	Checksum: 0x6284FFD
	Offset: 0x11AD8
	Size: 0xBC
	Parameters: 0
	Flags: Linked, Private
*/
private function _scene_link()
{
	self.e_scene_link = util::spawn_model("tag_origin", self.origin, self.angles);
	e_linkto = getent(self.linkto, "linkname");
	self.e_scene_link linkto(e_linkto);
	util::waittill_any_ents_two(self, "death", e_linkto, "death");
	self.e_scene_link delete();
}

/*
	Name: on_load_wait
	Namespace: scene
	Checksum: 0x28242682
	Offset: 0x11BA0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function on_load_wait()
{
	util::wait_network_frame();
	util::wait_network_frame();
	level flagsys::set("scene_on_load_wait");
}

/*
	Name: run_instances
	Namespace: scene
	Checksum: 0x6ED72079
	Offset: 0x11BF0
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function run_instances()
{
	foreach(var_cc537bad, s_instance in struct::get_script_bundle_instances("scene"))
	{
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

/*
	Name: _trigger_init
	Namespace: scene
	Checksum: 0x1C41B7FE
	Offset: 0x11D18
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function _trigger_init(trig)
{
	trig endon(#"death");
	trig trigger::wait_till();
	a_ents = [];
	if(get_player_count(self.scriptbundlename) > 0)
	{
		if(isplayer(trig.who))
		{
			a_ents[0] = trig.who;
		}
	}
	self thread _init_instance(undefined, a_ents);
}

/*
	Name: _trigger_play
	Namespace: scene
	Checksum: 0xC091BC64
	Offset: 0x11DD0
	Size: 0xF6
	Parameters: 1
	Flags: Linked
*/
function _trigger_play(trig)
{
	trig endon(#"death");
	do
	{
		trig trigger::wait_till();
		a_ents = [];
		if(get_player_count(self.scriptbundlename) > 0)
		{
			if(isplayer(trig.who))
			{
				a_ents[0] = trig.who;
			}
		}
		self thread play(a_ents);
	}
	while(isdefined(get_scenedef(self.scriptbundlename).looping) && get_scenedef(self.scriptbundlename).looping);
}

/*
	Name: _trigger_stop
	Namespace: scene
	Checksum: 0xBF9F1DC
	Offset: 0x11ED0
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function _trigger_stop(trig)
{
	trig endon(#"death");
	trig trigger::wait_till();
	self thread stop();
}

/*
	Name: add_scene_func
	Namespace: scene
	Checksum: 0x9FAB0840
	Offset: 0x11F20
	Size: 0x12C
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
	array::add(level.scene_funcs[str_scenedef][str_state], array(func, vararg), 0);
}

/*
	Name: remove_scene_func
	Namespace: scene
	Checksum: 0xA5C585E7
	Offset: 0x12058
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
	Name: get_scenedef
	Namespace: scene
	Checksum: 0xAC6AF666
	Offset: 0x121B0
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
	Checksum: 0x66474AC7
	Offset: 0x121E8
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function get_scenedefs(str_type = "scene")
{
	a_scenedefs = [];
	foreach(var_d2840899, s_scenedef in struct::get_script_bundles("scene"))
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
	Name: spawn
	Namespace: scene
	Checksum: 0x8221B8E4
	Offset: 0x12320
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
	Checksum: 0x21414476
	Offset: 0x124D0
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
				foreach(var_411b17f, s_instance in a_instances)
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
	Name: _init_instance
	Namespace: scene
	Checksum: 0xE4B34C7C
	Offset: 0x12770
	Size: 0x274
	Parameters: 3
	Flags: Linked
*/
function _init_instance(str_scenedef = self.scriptbundlename, a_ents, b_test_run = 0)
{
	level flagsys::wait_till("scene_on_load_wait");
	/#
		if(array().size && !isinarray(array(), str_scenedef))
		{
			return;
		}
	#/
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
	if(!isdefined(o_scene))
	{
		if(s_bundle.scenetype == "awareness")
		{
			object = new cawarenessscene();
			[[ object ]]->__constructor();
			o_scene = object;
		}
		else
		{
			object = new cscene();
			[[ object ]]->__constructor();
			o_scene = object;
		}
		s_bundle = _load_female_scene(s_bundle, a_ents);
		[[ o_scene ]]->init(s_bundle.name, s_bundle, self, a_ents, b_test_run);
	}
	else
	{
		thread [[ o_scene ]]->initialize(a_ents, 1);
	}
	return o_scene;
}

/*
	Name: _load_female_scene
	Namespace: scene
	Checksum: 0xCAE68714
	Offset: 0x129F0
	Size: 0x264
	Parameters: 2
	Flags: Linked, Private
*/
private function _load_female_scene(s_bundle, a_ents)
{
	b_has_player = 0;
	foreach(var_17dfd065, s_object in s_bundle.objects)
	{
		if(!isdefined(s_object))
		{
			continue;
		}
		if(s_object.type === "player")
		{
			b_has_player = 1;
			break;
		}
	}
	if(b_has_player)
	{
		e_player = undefined;
		if(isplayer(a_ents))
		{
			e_player = a_ents;
		}
		else if(isarray(a_ents))
		{
			foreach(var_a8a994d4, ent in a_ents)
			{
				if(isplayer(ent))
				{
					e_player = ent;
					break;
				}
			}
		}
		if(!isdefined(e_player))
		{
			e_player = level.activeplayers[0];
		}
		if(isplayer(e_player) && e_player util::is_female())
		{
			if(isdefined(s_bundle.femalebundle))
			{
				s_female_bundle = struct::get_script_bundle("scene", s_bundle.femalebundle);
				if(isdefined(s_female_bundle))
				{
					return s_female_bundle;
				}
			}
		}
	}
	return s_bundle;
}

/*
	Name: play
	Namespace: scene
	Checksum: 0x88DFD8F8
	Offset: 0x12C60
	Size: 0x4BC
	Parameters: 6
	Flags: Linked
*/
function play(arg1, arg2, arg3, b_test_run = 0, str_state, str_mode = "")
{
	/#
		if(getdvarint("") > 0)
		{
			if(isdefined(arg1) && isstring(arg1))
			{
				printtoprightln("" + arg1);
			}
			else
			{
				printtoprightln("");
			}
		}
	#/
	if(isdefined(arg1) && isstring(arg1) && arg1 == "p7_fxanim_zm_castle_rocket_bell_tower_bundle")
	{
		arg1 = arg1;
	}
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
				self thread _play_instance(s_tracker, str_scenedef, a_ents, b_test_run, undefined, str_mode);
			}
			else
			{
				s_tracker.n_scene_count = a_instances.size;
				foreach(var_faf67a, s_instance in a_instances)
				{
					if(isdefined(s_instance))
					{
						s_instance thread _play_instance(s_tracker, str_scenedef, a_ents, b_test_run, str_state, str_mode);
					}
				}
			}
		}
	}
	else if(isstring(arg1))
	{
		self thread _play_instance(s_tracker, arg1, arg2, b_test_run, str_state, str_mode);
	}
	else
	{
		self thread _play_instance(s_tracker, arg2, arg1, b_test_run, str_state, str_mode);
	}
	for(i = 0; i < s_tracker.n_scene_count; i++)
	{
		s_tracker waittill(#"scene_done");
	}
}

/*
	Name: _play_instance
	Namespace: scene
	Checksum: 0x3269B728
	Offset: 0x13128
	Size: 0x2AC
	Parameters: 6
	Flags: Linked
*/
function _play_instance(s_tracker, str_scenedef, a_ents, b_test_run = 0, str_state, str_mode)
{
	/#
		if(array().size && !isinarray(array(), str_scenedef))
		{
			return;
		}
	#/
	if(!isdefined(str_scenedef))
	{
		str_scenedef = self.scriptbundlename;
	}
	if(self.scriptbundlename === str_scenedef)
	{
		if(!(isdefined(self.script_play_multiple) && self.script_play_multiple))
		{
			if(isdefined(self.scene_played) && self.scene_played && !b_test_run)
			{
				waittillframeend();
				while(is_playing(str_scenedef))
				{
					wait(0.05);
				}
				s_tracker notify(#"scene_done");
				return;
			}
		}
		self.scene_played = 1;
	}
	o_scene = _init_instance(str_scenedef, a_ents, b_test_run);
	if(isdefined(o_scene))
	{
		if(!isdefined(str_mode) || str_mode == "" && [[ o_scene ]]->should_skip_linked_to_players_scene())
		{
			skip_scene(o_scene._s.name, 0, 0, 1);
		}
		thread [[ o_scene ]]->play(str_state, a_ents, b_test_run, str_mode);
	}
	self waittill_match(#"scene_done");
	if(isdefined(self))
	{
		if(isdefined(self.scriptbundlename) && (isdefined(get_scenedef(self.scriptbundlename).looping) && get_scenedef(self.scriptbundlename).looping))
		{
			self.scene_played = 0;
		}
		if(isdefined(self.script_flag_set))
		{
			level flag::set(self.script_flag_set);
		}
	}
	s_tracker notify(#"scene_done", str_scenedef);
}

/*
	Name: skipto_end
	Namespace: scene
	Checksum: 0xE570DDD0
	Offset: 0x133E0
	Size: 0xB4
	Parameters: 5
	Flags: None
*/
function skipto_end(arg1, arg2, arg3, n_time, b_include_players = 0)
{
	str_mode = "skipto";
	if(!b_include_players)
	{
		str_mode = str_mode + "_noplayers";
	}
	if(isdefined(n_time))
	{
		str_mode = str_mode + ":" + n_time;
	}
	play(arg1, arg2, arg3, 0, undefined, str_mode);
}

/*
	Name: skipto_end_noai
	Namespace: scene
	Checksum: 0xE2DD1DB6
	Offset: 0x134A0
	Size: 0x84
	Parameters: 4
	Flags: None
*/
function skipto_end_noai(arg1, arg2, arg3, n_time)
{
	str_mode = "skipto_noai_noplayers";
	if(isdefined(n_time))
	{
		str_mode = str_mode + ":" + n_time;
	}
	play(arg1, arg2, arg3, 0, undefined, str_mode);
}

/*
	Name: stop
	Namespace: scene
	Checksum: 0xF46B53FD
	Offset: 0x13530
	Size: 0x274
	Parameters: 3
	Flags: Linked
*/
function stop(arg1, arg2, arg3)
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
						assert(a_instances.size, "" + str_key + "" + str_value + "");
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
			foreach(var_655121b1, s_instance in arraycopy(a_instances))
			{
				if(isdefined(s_instance))
				{
					s_instance _stop_instance(b_clear, str_value);
				}
			}
		}
	}
	else if(isstring(arg1))
	{
		_stop_instance(arg2, arg1);
	}
	else
	{
		_stop_instance(arg1);
	}
}

/*
	Name: _stop_instance
	Namespace: scene
	Checksum: 0xF0BB6473
	Offset: 0x137B0
	Size: 0x102
	Parameters: 2
	Flags: Linked
*/
function _stop_instance(b_clear = 0, str_scenedef)
{
	if(isdefined(self.scenes))
	{
		foreach(var_a62eaf95, o_scene in arraycopy(self.scenes))
		{
			str_scene_name = [[ o_scene ]]->get_name();
			if(!isdefined(str_scenedef) || str_scene_name == str_scenedef)
			{
				thread [[ o_scene ]]->stop(b_clear);
			}
		}
	}
}

/*
	Name: has_init_state
	Namespace: scene
	Checksum: 0x1ECAC53A
	Offset: 0x138C0
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function has_init_state(str_scenedef)
{
	s_scenedef = get_scenedef(str_scenedef);
	foreach(var_f0db5a3b, s_obj in s_scenedef.objects)
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
	Checksum: 0xE8D56C37
	Offset: 0x139B8
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
	Checksum: 0xF4950FBF
	Offset: 0x13A08
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
	Checksum: 0xD92C0E78
	Offset: 0x13A40
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
	Checksum: 0x17AAA7B0
	Offset: 0x13A78
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
	Checksum: 0x96A17CCA
	Offset: 0x13AB0
	Size: 0x2A
	Parameters: 1
	Flags: Linked
*/
function get_player_count(str_scenedef)
{
	return _get_type_count("player", str_scenedef);
}

/*
	Name: _get_type_count
	Namespace: scene
	Checksum: 0xCDEBBA46
	Offset: 0x13AE8
	Size: 0x138
	Parameters: 2
	Flags: Linked
*/
function _get_type_count(str_type, str_scenedef)
{
	s_scenedef = (isdefined(str_scenedef) ? get_scenedef(str_scenedef) : get_scenedef(self.scriptbundlename));
	n_count = 0;
	foreach(var_9850522f, s_obj in s_scenedef.objects)
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
	Checksum: 0xFD4D73A3
	Offset: 0x13C28
	Size: 0x4C
	Parameters: 1
	Flags: None
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
	Checksum: 0x1463E1B6
	Offset: 0x13C80
	Size: 0x94
	Parameters: 1
	Flags: Linked
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
	Name: is_ready
	Namespace: scene
	Checksum: 0xD5333108
	Offset: 0x13D20
	Size: 0x96
	Parameters: 1
	Flags: None
*/
function is_ready(str_scenedef)
{
	if(self == level)
	{
		return level flagsys::get(str_scenedef + "_ready");
	}
	if(!isdefined(str_scenedef))
	{
		str_scenedef = self.scriptbundlename;
	}
	o_scene = get_active_scene(str_scenedef);
	if(isdefined(o_scene))
	{
		return o_scene flagsys::get("ready");
	}
	return 0;
}

/*
	Name: get_active_scenes
	Namespace: scene
	Checksum: 0x2F9BC371
	Offset: 0x13DC0
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
	Checksum: 0x9C0EB389
	Offset: 0x13ED0
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function get_active_scene(str_scenedef)
{
	if(isdefined(str_scenedef) && isdefined(self.scenes))
	{
		foreach(var_7faf5530, o_scene in self.scenes)
		{
			if([[ o_scene ]]->get_name() == str_scenedef)
			{
				return o_scene;
			}
		}
	}
}

/*
	Name: delete_scene_data
	Namespace: scene
	Checksum: 0xDA0F40B2
	Offset: 0x13F90
	Size: 0x3E
	Parameters: 1
	Flags: None
*/
function delete_scene_data(str_scenename)
{
	if(isdefined(level.scriptbundles["scene"][str_scenename]))
	{
		level.scriptbundles["scene"][str_scenename] = undefined;
	}
}

/*
	Name: is_igc
	Namespace: scene
	Checksum: 0x66834A82
	Offset: 0x13FD8
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function is_igc()
{
	return isstring(self.cameraswitcher) || isstring(self.extracamswitcher1) || isstring(self.extracamswitcher2) || isstring(self.extracamswitcher3) || isstring(self.extracamswitcher4);
}

/*
	Name: scene_disable_player_stuff
	Namespace: scene
	Checksum: 0xF05CE6B5
	Offset: 0x14060
	Size: 0xF2
	Parameters: 1
	Flags: Linked
*/
function scene_disable_player_stuff(b_hide_hud = 1)
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("");
		}
	#/
	self notify(#"scene_disable_player_stuff");
	self notify(#"kill_hint_text");
	self disableoffhandweapons();
	if(b_hide_hud)
	{
		set_igc_active(1);
		level notify(#"disable_cybercom", self, 1);
		self util::show_hud(0);
		util::wait_network_frame();
		self notify(#"delete_weapon_objects");
	}
}

/*
	Name: scene_enable_player_stuff
	Namespace: scene
	Checksum: 0xC1B4962F
	Offset: 0x14160
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function scene_enable_player_stuff(b_hide_hud = 1)
{
	/#
		if(getdvarint("") > 0)
		{
			printtoprightln("");
		}
	#/
	self endon(#"scene_disable_player_stuff");
	self endon(#"disconnect");
	wait(0.5);
	self enableoffhandweapons();
	if(b_hide_hud)
	{
		set_igc_active(0);
		level notify(#"enable_cybercom", self);
		self notify(#"scene_enable_cybercom");
		self util::show_hud(1);
	}
}

/*
	Name: updateigcviewtime
	Namespace: scene
	Checksum: 0xC9FFC8F8
	Offset: 0x14250
	Size: 0x13A
	Parameters: 1
	Flags: Linked
*/
function updateigcviewtime(b_in_igc)
{
	if(b_in_igc && !isdefined(level.igcstarttime))
	{
		level.igcstarttime = gettime();
	}
	else if(!b_in_igc && isdefined(level.igcstarttime))
	{
		igcviewtimesec = gettime() - level.igcstarttime;
		level.igcstarttime = undefined;
		foreach(var_eeef7477, player in level.players)
		{
			if(!isdefined(player.totaligcviewtime))
			{
				player.totaligcviewtime = 0;
			}
			player.totaligcviewtime = player.totaligcviewtime + int(igcviewtimesec / 1000);
		}
	}
}

/*
	Name: set_igc_active
	Namespace: scene
	Checksum: 0x384B066F
	Offset: 0x14398
	Size: 0xD0
	Parameters: 1
	Flags: Linked
*/
function set_igc_active(b_in_igc)
{
	n_ent_num = self getentitynumber();
	n_players_in_igc_field = level clientfield::get("in_igc");
	if(b_in_igc)
	{
		n_players_in_igc_field = n_players_in_igc_field | 1 << n_ent_num;
	}
	else
	{
		~n_players_in_igc_field;
		n_players_in_igc_field = n_players_in_igc_field & 1 << n_ent_num;
	}
	updateigcviewtime(b_in_igc);
	level clientfield::set("in_igc", n_players_in_igc_field);
	/#
	#/
}

/*
	Name: is_igc_active
	Namespace: scene
	Checksum: 0x7493D96F
	Offset: 0x14470
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function is_igc_active()
{
	n_players_in_igc = level clientfield::get("in_igc");
	n_entnum = self getentitynumber();
	return n_players_in_igc & 1 << n_entnum;
}

/*
	Name: is_capture_mode
	Namespace: scene
	Checksum: 0x1DDC7420
	Offset: 0x144D8
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

/*
	Name: should_spectate_on_join
	Namespace: scene
	Checksum: 0xC92EBEF5
	Offset: 0x14540
	Size: 0x16
	Parameters: 0
	Flags: None
*/
function should_spectate_on_join()
{
	return isdefined(level.scene_should_spectate_on_hot_join) && level.scene_should_spectate_on_hot_join;
}

/*
	Name: wait_until_spectate_on_join_completes
	Namespace: scene
	Checksum: 0x8EDB56A3
	Offset: 0x14560
	Size: 0x28
	Parameters: 0
	Flags: None
*/
function wait_until_spectate_on_join_completes()
{
	while(isdefined(level.scene_should_spectate_on_hot_join) && level.scene_should_spectate_on_hot_join)
	{
		wait(0.05);
	}
}

/*
	Name: skip_scene
	Namespace: scene
	Checksum: 0xAF9E4FFA
	Offset: 0x14590
	Size: 0x5A2
	Parameters: 4
	Flags: Linked
*/
function skip_scene(scene_name, b_sequence, b_player_scene, b_check_linked_scene)
{
	if(!isdefined(scene_name))
	{
		if(isdefined(level.shared_scene_sequence_name))
		{
			scene_name = level.shared_scene_sequence_name;
		}
		if(!isdefined(scene_name))
		{
			if(isdefined(level.players) && isdefined(level.players[0].current_scene))
			{
				scene_name = level.players[0].current_scene;
			}
			if(!isdefined(scene_name))
			{
				foreach(var_250ab0fb, player in level.players)
				{
					if(isdefined(player.current_scene))
					{
						scene_name = player.current_scene;
						break;
					}
				}
			}
		}
	}
	/#
		if(getdvarint("") > 0)
		{
			if(isdefined(scene_name))
			{
				printtoprightln("" + scene_name + "" + gettime(), (1, 0.5, 0));
			}
			else
			{
				printtoprightln("" + gettime(), (1, 0.5, 0));
			}
		}
	#/
	if(!(isdefined(b_sequence) && b_sequence) && !isdefined(b_player_scene))
	{
		foreach(var_7edcd13d, player in level.players)
		{
			if(isdefined(player.current_scene) && player.current_scene == scene_name)
			{
				b_player_scene = 1;
				break;
			}
		}
	}
	if(!(isdefined(b_sequence) && b_sequence) && (isdefined(b_player_scene) && b_player_scene))
	{
		a_instances = get_active_scenes(scene_name);
		b_can_skip_player_scene = 0;
		foreach(var_7e8a3ba4, s_instance in arraycopy(a_instances))
		{
			if(isdefined(s_instance))
			{
				b_shared_scene = s_instance _skip_scene(scene_name, b_sequence, 1, 0);
				if(b_shared_scene == 2)
				{
					break;
				}
				if(b_shared_scene == 1)
				{
					b_can_skip_player_scene = 1;
					break;
				}
			}
		}
		if(isdefined(b_can_skip_player_scene) && b_can_skip_player_scene)
		{
			a_instances = get_active_scenes();
			foreach(var_b6dcf79, s_instance in arraycopy(a_instances))
			{
				if(isdefined(s_instance))
				{
					s_instance _skip_scene(scene_name, b_sequence, 0, 1);
				}
			}
		}
		else
		{
			level.shared_scene_sequence_started = undefined;
			level.shared_scene_sequence_name = undefined;
		}
		return;
	}
	a_instances = struct::get_array(scene_name, "targetname");
	if(!a_instances.size)
	{
		a_instances = get_active_scenes(scene_name);
	}
	foreach(var_5b62d89b, s_instance in arraycopy(a_instances))
	{
		if(isdefined(s_instance))
		{
			s_instance _skip_scene(scene_name, b_sequence, b_player_scene, b_check_linked_scene);
		}
	}
}

/*
	Name: _skip_scene
	Namespace: scene
	Checksum: 0xE6C62634
	Offset: 0x14B40
	Size: 0x456
	Parameters: 4
	Flags: Linked
*/
function _skip_scene(skipped_scene_name, b_sequence, b_player_scene, b_check_linked_scene)
{
	b_shared_scene = 0;
	if(isdefined(self.scenes))
	{
		foreach(var_43489f4e, o_scene in arraycopy(self.scenes))
		{
			if(isdefined(o_scene.skipping_scene) && o_scene.skipping_scene)
			{
				continue;
			}
			if(!(isdefined(b_sequence) && b_sequence) && (isdefined(b_player_scene) && b_player_scene) && (!(isdefined(b_check_linked_scene) && b_check_linked_scene)))
			{
				if(o_scene._s.name === skipped_scene_name)
				{
					if(isdefined(o_scene._s.disablesceneskipping) && o_scene._s.disablesceneskipping)
					{
						return 2;
					}
					if(o_scene._str_state === "init")
					{
						continue;
					}
					b_shared_scene = 1;
				}
				else if(!isdefined(skipped_scene_name))
				{
					if([[ o_scene ]]->is_scene_shared())
					{
						if(isdefined(o_scene._s.disablesceneskipping) && o_scene._s.disablesceneskipping)
						{
							return 2;
						}
						if(o_scene._str_state === "init")
						{
							continue;
						}
						b_shared_scene = 1;
					}
					else
					{
						continue;
					}
				}
				else
				{
					continue;
				}
			}
			str_scene_name = [[ o_scene ]]->get_name();
			if(!(isdefined(b_sequence) && b_sequence))
			{
				b_linked_scene = array::contains(level.linked_scenes, str_scene_name);
				if(isdefined(b_check_linked_scene) && b_check_linked_scene && (!b_linked_scene || (isdefined(o_scene._s.disablesceneskipping) && o_scene._s.disablesceneskipping)))
				{
					continue;
				}
				if(!b_linked_scene && o_scene._str_state === "init")
				{
					continue;
				}
				if(!isdefined(skipped_scene_name) || str_scene_name == skipped_scene_name || (b_linked_scene && (!(isdefined(o_scene._s.disablesceneskipping) && o_scene._s.disablesceneskipping))))
				{
					if(!isdefined(skipped_scene_name) || str_scene_name == skipped_scene_name && (isdefined(b_player_scene) && b_player_scene) && (!(isdefined(b_check_linked_scene) && b_check_linked_scene)) && !b_linked_scene)
					{
						b_shared_scene = 1;
						o_scene.b_player_scene = 1;
						level.player_skipping_scene = str_scene_name;
					}
					o_scene.skipping_scene = 1;
					thread [[ o_scene ]]->skip_scene(b_sequence);
				}
				continue;
			}
			o_scene.b_player_scene = b_player_scene;
			o_scene.skipping_scene = 1;
			thread [[ o_scene ]]->skip_scene(b_sequence);
		}
	}
	return b_shared_scene;
}

/*
	Name: add_player_linked_scene
	Namespace: scene
	Checksum: 0xF5887147
	Offset: 0x14FA0
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function add_player_linked_scene(linked_scene_str)
{
	if(!isdefined(level.linked_scenes))
	{
		level.linked_scenes = [];
	}
	array::add(level.linked_scenes, linked_scene_str);
}

/*
	Name: remove_player_linked_scene
	Namespace: scene
	Checksum: 0x41DF380F
	Offset: 0x14FF0
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function remove_player_linked_scene(linked_scene_str)
{
	if(isdefined(level.linked_scenes))
	{
		arrayremovevalue(level.linked_scenes, linked_scene_str);
	}
}

/*
	Name: waittill_skip_sequence_completed
	Namespace: scene
	Checksum: 0xFDB78DD2
	Offset: 0x15030
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function waittill_skip_sequence_completed()
{
	while(isdefined(level.player_skipping_scene))
	{
		wait(0.05);
	}
}

/*
	Name: is_skipping_in_progress
	Namespace: scene
	Checksum: 0xC457CE2F
	Offset: 0x15058
	Size: 0xC
	Parameters: 0
	Flags: None
*/
function is_skipping_in_progress()
{
	return isdefined(level.player_skipping_scene);
}

/*
	Name: watch_scene_skip_requests
	Namespace: scene
	Checksum: 0xA473C31A
	Offset: 0x15070
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function watch_scene_skip_requests()
{
	self endon(#"disconnect");
	while(true)
	{
		level waittill(#"scene_sequence_started");
		self thread should_skip_scene_loop();
		self thread watch_scene_ending();
		self thread watch_scene_skipping();
		level waittill(#"scene_sequence_ended");
	}
}

/*
	Name: clear_scene_skipping_ui
	Namespace: scene
	Checksum: 0xC8ED6D1D
	Offset: 0x150F8
	Size: 0xF0
	Parameters: 0
	Flags: Linked
*/
function clear_scene_skipping_ui()
{
	level endon(#"scene_sequence_started");
	if(isdefined(self.scene_skip_timer))
	{
		self.scene_skip_timer = undefined;
	}
	if(isdefined(self.scene_skip_start_time))
	{
		self.scene_skip_start_time = undefined;
	}
	foreach(var_dc1e7cf1, player in level.players)
	{
		if(isdefined(player.skip_scene_menu_handle))
		{
			player closeluimenu(player.skip_scene_menu_handle);
			player.skip_scene_menu_handle = undefined;
		}
	}
}

/*
	Name: watch_scene_ending
	Namespace: scene
	Checksum: 0x7C82604B
	Offset: 0x151F0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function watch_scene_ending()
{
	self endon(#"disconnect");
	self endon(#"scene_being_skipped");
	level waittill(#"scene_sequence_ended");
	clear_scene_skipping_ui();
}

/*
	Name: watch_scene_skipping
	Namespace: scene
	Checksum: 0x7C3F72A8
	Offset: 0x15238
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function watch_scene_skipping()
{
	self endon(#"disconnect");
	level endon(#"scene_sequence_ended");
	self waittill(#"scene_being_skipped");
	level.sceneskippedcount++;
	clear_scene_skipping_ui();
}

/*
	Name: should_skip_scene_loop
	Namespace: scene
	Checksum: 0xB09721B6
	Offset: 0x15288
	Size: 0x58C
	Parameters: 0
	Flags: Linked
*/
function should_skip_scene_loop()
{
	self endon(#"disconnect");
	level endon(#"scene_sequence_ended");
	b_skip_scene = 0;
	clear_scene_skipping_ui();
	wait(0.05);
	foreach(var_60622e26, player in level.players)
	{
		if(isdefined(player.skip_scene_menu_handle))
		{
			player closeluimenu(player.skip_scene_menu_handle);
			wait(0.05);
		}
		player.skip_scene_menu_handle = player openluimenu("CPSkipSceneMenu");
		player setluimenudata(player.skip_scene_menu_handle, "showSkipButton", 0);
		player setluimenudata(player.skip_scene_menu_handle, "hostIsSkipping", 0);
		player setluimenudata(player.skip_scene_menu_handle, "sceneSkipEndTime", 0);
	}
	while(true)
	{
		if(self any_button_pressed() && (!(isdefined(level.chyron_text_active) && level.chyron_text_active)))
		{
			if(!isdefined(self.scene_skip_timer))
			{
				self setluimenudata(self.skip_scene_menu_handle, "showSkipButton", 1);
			}
			self.scene_skip_timer = gettime();
		}
		else if(isdefined(self.scene_skip_timer))
		{
			if(gettime() - self.scene_skip_timer > 3000)
			{
				self setluimenudata(self.skip_scene_menu_handle, "showSkipButton", 2);
				self.scene_skip_timer = undefined;
			}
		}
		if(self primarybuttonpressedlocal() && (!(isdefined(level.chyron_text_active) && level.chyron_text_active)))
		{
			if(!isdefined(self.scene_skip_start_time))
			{
				foreach(var_a7c0b180, player in level.players)
				{
					if(player ishost())
					{
						player setluimenudata(player.skip_scene_menu_handle, "sceneSkipEndTime", gettime() + 2500);
						continue;
					}
					if(isdefined(player.skip_scene_menu_handle))
					{
						player setluimenudata(player.skip_scene_menu_handle, "hostIsSkipping", 1);
					}
				}
				self.scene_skip_start_time = gettime();
			}
			else if(gettime() - self.scene_skip_start_time > 2500)
			{
				b_skip_scene = 1;
				break;
			}
		}
		else if(isdefined(self.scene_skip_start_time))
		{
			foreach(var_34a236bd, player in level.players)
			{
				if(player ishost())
				{
					player setluimenudata(player.skip_scene_menu_handle, "sceneSkipEndTime", 0);
					continue;
				}
				if(isdefined(player.skip_scene_menu_handle))
				{
					player setluimenudata(player.skip_scene_menu_handle, "hostIsSkipping", 2);
				}
			}
			self.scene_skip_start_time = undefined;
		}
		if(isdefined(level.chyron_text_active) && level.chyron_text_active)
		{
			while(isdefined(level.chyron_text_active) && level.chyron_text_active)
			{
				wait(0.05);
			}
			wait(3);
		}
		wait(0.05);
	}
	if(b_skip_scene)
	{
		self playsound("uin_igc_skip");
		self notify(#"scene_being_skipped");
		level notify(#"scene_skip_sequence_started");
		skip_scene(level.shared_scene_sequence_name, 0, 1);
	}
}

/*
	Name: any_button_pressed
	Namespace: scene
	Checksum: 0x57E68DB3
	Offset: 0x15820
	Size: 0x1A6
	Parameters: 0
	Flags: Linked
*/
function any_button_pressed()
{
	if(self actionslotonebuttonpressed())
	{
		return 1;
	}
	if(self actionslottwobuttonpressed())
	{
		return 1;
	}
	if(self actionslotthreebuttonpressed())
	{
		return 1;
	}
	if(self actionslotfourbuttonpressed())
	{
		return 1;
	}
	if(self jumpbuttonpressed())
	{
		return 1;
	}
	if(self stancebuttonpressed())
	{
		return 1;
	}
	if(self weaponswitchbuttonpressed())
	{
		return 1;
	}
	if(self reloadbuttonpressed())
	{
		return 1;
	}
	if(self fragbuttonpressed())
	{
		return 1;
	}
	if(self throwbuttonpressed())
	{
		return 1;
	}
	if(self attackbuttonpressed())
	{
		return 1;
	}
	if(self secondaryoffhandbuttonpressed())
	{
		return 1;
	}
	if(self meleebuttonpressed())
	{
		return 1;
	}
	return 0;
}

/*
	Name: on_player_connect
	Namespace: scene
	Checksum: 0x4D0E085F
	Offset: 0x159D0
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
	if(self ishost())
	{
		self thread watch_scene_skip_requests();
	}
}

/*
	Name: on_player_disconnect
	Namespace: scene
	Checksum: 0x5A791FE8
	Offset: 0x15A10
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_disconnect()
{
	self set_igc_active(0);
}

/*
	Name: add_scene_ordered_notetrack
	Namespace: scene
	Checksum: 0xA3A9CB6B
	Offset: 0x15A38
	Size: 0xDC
	Parameters: 2
	Flags: None
*/
function add_scene_ordered_notetrack(group_name, str_note)
{
	if(!isdefined(level.scene_ordered_notetracks))
	{
		level.scene_ordered_notetracks = [];
	}
	group_obj = level.scene_ordered_notetracks[group_name];
	if(!isdefined(group_obj))
	{
		group_obj = spawnstruct();
		group_obj.count = 0;
		group_obj.current_count = 0;
		level.scene_ordered_notetracks[group_name] = group_obj;
	}
	group_obj.count++;
	self thread _wait_for_ordered_notify(group_obj.count - 1, group_obj, group_name, str_note);
}

/*
	Name: _wait_for_ordered_notify
	Namespace: scene
	Checksum: 0xF9E3E899
	Offset: 0x15B20
	Size: 0x254
	Parameters: 4
	Flags: Linked, Private
*/
private function _wait_for_ordered_notify(id, group_obj, group_name, str_note)
{
	self waittill(str_note);
	if(group_obj.current_count == id)
	{
		group_obj.current_count++;
		self notify("scene_" + str_note);
		wait(0.05);
		if(group_obj.current_count == group_obj.count)
		{
			group_obj.pending_notifies = undefined;
			level.scene_ordered_notetracks[group_name] = undefined;
		}
		else if(isdefined(group_obj.pending_notifies) && group_obj.current_count + group_obj.pending_notifies.size == group_obj.count)
		{
			self thread _fire_ordered_notitifes(group_obj, group_name);
		}
	}
	else if(!isdefined(group_obj.pending_notifies))
	{
		group_obj.pending_notifies = [];
	}
	notetrack = spawnstruct();
	notetrack.id = id;
	notetrack.str_note = str_note;
	for(i = 0; i < group_obj.pending_notifies.size && group_obj.pending_notifies[i].id < id; i++)
	{
	}
	arrayinsert(group_obj.pending_notifies, notetrack, i);
	if(group_obj.current_count + group_obj.pending_notifies.size == group_obj.count)
	{
		self thread _fire_ordered_notitifes(group_obj, group_name);
	}
}

/*
	Name: _fire_ordered_notitifes
	Namespace: scene
	Checksum: 0xEFF68B87
	Offset: 0x15D80
	Size: 0xB4
	Parameters: 2
	Flags: Linked, Private
*/
private function _fire_ordered_notitifes(group_obj, group_name)
{
	if(isdefined(group_obj.pending_notifies))
	{
		while(group_obj.pending_notifies.size > 0)
		{
			self notify("scene_" + group_obj.pending_notifies[0].str_note);
			arrayremoveindex(group_obj.pending_notifies, 0);
			wait(0.05);
		}
	}
	group_obj.pending_notifies = undefined;
	level.scene_ordered_notetracks[group_name] = undefined;
}

/*
	Name: add_wait_for_streamer_hint_scene
	Namespace: scene
	Checksum: 0x6E33476F
	Offset: 0x15E40
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function add_wait_for_streamer_hint_scene(str_scene_name)
{
	if(!isdefined(level.wait_for_streamer_hint_scenes))
	{
		level.wait_for_streamer_hint_scenes = [];
	}
	array::add(level.wait_for_streamer_hint_scenes, str_scene_name);
}

