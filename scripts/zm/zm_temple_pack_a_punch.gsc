// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;
#using scripts\zm\zm_temple;
#using scripts\zm\zm_temple_elevators;

#namespace zm_temple_pack_a_punch;

/*
	Name: init_pack_a_punch
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x744BF300
	Offset: 0x4A0
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function init_pack_a_punch()
{
	level flag::init("pap_round");
	level flag::init("pap_active");
	level flag::init("pap_open");
	level flag::init("pap_enabled");
	level.pack_a_punch_round_time = 30;
	level.pack_a_punch_stone_timer = getentarray("pack_a_punch_timer", "targetname");
	level.pack_a_punch_stone_timer_dist = 176;
	util::registerclientsys("pap_indicator_spinners");
	level.pap_active_time = 60;
	/#
		if(getdvarint(""))
		{
			level.pap_active_time = 20;
		}
	#/
	_setup_pap_blocker();
	_setup_pap_timer();
	_setup_pap_path();
	_setup_pap_fx();
}

/*
	Name: _setup_pap_blocker
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xF5B5EBC1
	Offset: 0x618
	Size: 0x554
	Parameters: 0
	Flags: Linked
*/
function _setup_pap_blocker()
{
	level thread _setup_simultaneous_pap_triggers();
	var_45648617 = getent("pap_stairs_mesh", "targetname");
	var_45648617 delete();
	level.pap_stairs = [];
	for(i = 0; i < 4; i++)
	{
		stair = getent("pap_stairs" + (i + 1), "targetname");
		if(!isdefined(stair.script_vector))
		{
			stair.script_vector = vectorscale((0, 0, 1), 72);
		}
		stair.movetime = 3;
		stair.movedist = stair.script_vector;
		if(i == 3)
		{
			stair.down_origin = stair.origin;
			stair.up_origin = stair.down_origin + stair.movedist;
		}
		else
		{
			stair.up_origin = stair.origin;
			stair.down_origin = stair.up_origin - stair.movedist;
			stair.origin = stair.down_origin;
		}
		stair.state = "down";
		level.pap_stairs[i] = stair;
	}
	level.pap_stairs_clip = getent("pap_stairs_clip", "targetname");
	if(isdefined(level.pap_stairs_clip))
	{
		level.pap_stairs_clip.zmove = 72;
	}
	level.pap_playerclip = getentarray("pap_playerclip", "targetname");
	for(i = 0; i < level.pap_playerclip.size; i++)
	{
		level.pap_playerclip[i].saved_origin = level.pap_playerclip[i].origin;
	}
	level.pap_ramp = getent("pap_ramp", "targetname");
	level.brush_pap_traversal = getent("brush_pap_traversal", "targetname");
	if(isdefined(level.brush_pap_traversal))
	{
		level.brush_pap_traversal solid();
		level.brush_pap_traversal disconnectpaths();
		a_nodes = getnodearray("node_pap_jump_bottom", "targetname");
		foreach(node in a_nodes)
		{
			linktraversal(node);
		}
	}
	level.brush_pap_side_l = getent("brush_pap_side_l", "targetname");
	if(isdefined(level.brush_pap_side_l))
	{
		level.brush_pap_side_l _pap_brush_disconnect_paths();
	}
	level.brush_pap_side_r = getent("brush_pap_side_r", "targetname");
	if(isdefined(level.brush_pap_side_r))
	{
		level.brush_pap_side_r _pap_brush_disconnect_paths();
	}
	brush_pap_pathing_ramp_r = getent("brush_pap_pathing_ramp_r", "targetname");
	if(isdefined(brush_pap_pathing_ramp_r))
	{
		brush_pap_pathing_ramp_r delete();
	}
	brush_pap_pathing_ramp_l = getent("brush_pap_pathing_ramp_l", "targetname");
	if(isdefined(brush_pap_pathing_ramp_l))
	{
		brush_pap_pathing_ramp_l delete();
	}
}

/*
	Name: _watch_for_fall
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x409AFE65
	Offset: 0xB78
	Size: 0x1D4
	Parameters: 0
	Flags: None
*/
function _watch_for_fall()
{
	wait(0.1);
	self setcontents(0);
	self startragdoll();
	self.base setcandamage(1);
	self.base.health = 1;
	self.base waittill(#"damage");
	mover = getent(self.base.target, "targetname");
	geyserfx = isdefined(self.base.script_string) && self.base.script_string == "geyser";
	self.base delete();
	self.base = undefined;
	wait(0.5);
	if(geyserfx)
	{
		level thread _play_geyser_fx(mover.origin);
	}
	mover movez(-14, 1, 0.2, 0);
	mover waittill(#"movedone");
	level.zombie_drops_left = level.zombie_drops_left - 1;
	if(level.zombie_drops_left <= 0)
	{
		level flag::set("pap_enabled");
	}
}

/*
	Name: _play_geyser_fx
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xCF66F97C
	Offset: 0xD58
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function _play_geyser_fx(origin)
{
	fxobj = spawnfx(level._effect["geyser_active"], origin);
	triggerfx(fxobj);
	wait(3);
	fxobj delete();
}

/*
	Name: power
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xC92C8A02
	Offset: 0xDD8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function power(base, exp)
{
	/#
		assert(exp >= 0);
	#/
	if(exp == 0)
	{
		return 1;
	}
	return base * (power(base, exp - 1));
}

/*
	Name: _setup_simultaneous_pap_triggers
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x7B8DE192
	Offset: 0xE50
	Size: 0x3F8
	Parameters: 0
	Flags: Linked
*/
function _setup_simultaneous_pap_triggers()
{
	spots = getentarray("hanging_base", "targetname");
	for(i = 0; i < spots.size; i++)
	{
		spots[i] delete();
	}
	level flag::wait_till("power_on");
	triggers = [];
	for(i = 0; i < 4; i++)
	{
		triggers[i] = getent("pap_blocker_trigger" + (i + 1), "targetname");
	}
	_randomize_pressure_plates(triggers);
	array::thread_all(triggers, &_pap_pressure_plate_move);
	wait(1);
	last_num_plates_active = -1;
	last_plate_state = -1;
	while(true)
	{
		players = getplayers();
		num_plates_needed = players.size;
		/#
			if(getdvarint("") == 2)
			{
				num_plates_needed = 1;
			}
		#/
		num_plates_active = 0;
		plate_state = 0;
		for(i = 0; i < triggers.size; i++)
		{
			if(triggers[i].plate.active)
			{
				num_plates_active++;
			}
			if(triggers[i].plate.active || (triggers[i].requiredplayers - 1) >= num_plates_needed)
			{
				plate_state = plate_state + (power(2, triggers[i].requiredplayers - 1));
			}
		}
		if(last_num_plates_active != num_plates_active || plate_state != last_plate_state)
		{
			last_num_plates_active = num_plates_active;
			last_plate_state = plate_state;
			_set_num_plates_active(num_plates_active, plate_state);
		}
		_update_stairs(triggers);
		if(num_plates_active >= num_plates_needed)
		{
			for(i = 0; i < triggers.size; i++)
			{
				triggers[i] notify(#"pap_active");
				triggers[i].plate _plate_move_down();
			}
			_pap_think();
			_randomize_pressure_plates(triggers);
			array::thread_all(triggers, &_pap_pressure_plate_move);
			_set_num_plates_active(4, 15);
			wait(1);
		}
		util::wait_network_frame();
	}
}

/*
	Name: _randomize_pressure_plates
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x8A49EE3D
	Offset: 0x1250
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function _randomize_pressure_plates(triggers)
{
	rand_nums = array(1, 2, 3, 4);
	rand_nums = array::randomize(rand_nums);
	for(i = 0; i < triggers.size; i++)
	{
		triggers[i].requiredplayers = rand_nums[i];
	}
}

/*
	Name: _update_stairs
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xE7B4F7AD
	Offset: 0x12F8
	Size: 0x106
	Parameters: 1
	Flags: Linked
*/
function _update_stairs(triggers)
{
	numtouched = 0;
	for(i = 0; i < triggers.size; i++)
	{
		if(isdefined(triggers[i].touched) && triggers[i].touched)
		{
			numtouched++;
		}
	}
	for(i = 0; i < numtouched; i++)
	{
		level.pap_stairs[i] _stairs_move_up();
	}
	for(i = numtouched; i < level.pap_stairs.size; i++)
	{
		level.pap_stairs[i] _stairs_move_down();
	}
}

/*
	Name: _pap_pressure_plate_move_enabled
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x43BE0F43
	Offset: 0x1408
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function _pap_pressure_plate_move_enabled()
{
	numplayers = getplayers().size;
	if(numplayers >= self.requiredplayers)
	{
		return true;
	}
	return false;
}

/*
	Name: _pap_pressure_plate_move
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x74E8C822
	Offset: 0x1450
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function _pap_pressure_plate_move()
{
	self endon(#"pap_active");
	plate = getent(self.target, "targetname");
	self.plate = plate;
	plate.movetime = 2;
	plate.movedist = vectorscale((0, 0, 1), 10);
	plate.down_origin = plate.origin;
	plate.up_origin = plate.origin + plate.movedist;
	plate.origin = plate.down_origin;
	plate.state = "down";
	movespeed = 10;
	while(true)
	{
		while(!self _pap_pressure_plate_move_enabled())
		{
			plate.active = 0;
			self.touched = 0;
			plate thread _plate_move_down();
			wait(0.1);
		}
		plate.active = 0;
		self.touched = 0;
		plate _plate_move_up();
		plate waittill(#"state_set");
		while(self _pap_pressure_plate_move_enabled())
		{
			players = getplayers();
			touching = 0;
			if(!self _pap_pressure_plate_move_enabled())
			{
				break;
			}
			for(i = 0; i < players.size && !touching; i++)
			{
				if(players[i].sessionstate != "spectator")
				{
					touching = players[i] istouching(self);
				}
			}
			self.touched = touching;
			if(touching)
			{
				plate _plate_move_down();
			}
			else
			{
				plate _plate_move_up();
			}
			plate.active = plate.state == "down";
			wait(0.1);
		}
	}
}

/*
	Name: _stairs_playmovesound
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xCCDCE5FB
	Offset: 0x1750
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function _stairs_playmovesound()
{
	self _stairs_stopmovesound();
	self playloopsound("zmb_staircase_loop");
}

/*
	Name: _stairs_stopmovesound
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x4B3CD9B4
	Offset: 0x1798
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function _stairs_stopmovesound()
{
	self stoploopsound();
}

/*
	Name: _stairs_playlockedsound
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xE12F5A74
	Offset: 0x17C0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function _stairs_playlockedsound()
{
	self playsound("zmb_staircase_lock");
}

/*
	Name: _plate_playmovesound
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xE18AB681
	Offset: 0x17F0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function _plate_playmovesound()
{
	self _plate_stopmovesound();
	self playloopsound("zmb_pressure_plate_loop");
}

/*
	Name: _plate_stopmovesound
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x270677C3
	Offset: 0x1838
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function _plate_stopmovesound()
{
	self stoploopsound();
}

/*
	Name: _plate_playlockedsound
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x8DD455AB
	Offset: 0x1860
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function _plate_playlockedsound()
{
	self playsound("zmb_pressure_plate_lock");
}

/*
	Name: _mover_get_origin
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x7B463015
	Offset: 0x1890
	Size: 0x42
	Parameters: 1
	Flags: Linked
*/
function _mover_get_origin(state)
{
	if(state == "up")
	{
		return self.up_origin;
	}
	if(state == "down")
	{
		return self.down_origin;
	}
	return undefined;
}

/*
	Name: _move_pap_mover_wait
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x34ED23BB
	Offset: 0x18E0
	Size: 0x14A
	Parameters: 3
	Flags: Linked
*/
function _move_pap_mover_wait(state, onmovefunc, onstopfunc)
{
	self endon(#"move");
	goalorigin = self _mover_get_origin(state);
	movetime = self.movetime;
	timescale = (abs(self.origin[2] - goalorigin[2])) / self.movedist[2];
	movetime = movetime * timescale;
	self.state = "moving_" + state;
	if(movetime > 0)
	{
		if(isdefined(onmovefunc))
		{
			self thread [[onmovefunc]]();
		}
		self moveto(goalorigin, movetime);
		self waittill(#"movedone");
		if(isdefined(onstopfunc))
		{
			self thread [[onstopfunc]]();
		}
	}
	self.state = state;
	self notify(#"state_set");
}

/*
	Name: _move_pap_mover
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x7ABD5F42
	Offset: 0x1A38
	Size: 0x74
	Parameters: 3
	Flags: Linked
*/
function _move_pap_mover(state, onmovefunc, onstopfunc)
{
	if(self.state == state || self.state == ("moving_" + state))
	{
		return;
	}
	self notify(#"move");
	self thread _move_pap_mover_wait(state, onmovefunc, onstopfunc);
}

/*
	Name: _move_down
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xC3246341
	Offset: 0x1AB8
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function _move_down(onmovefunc, onstopfunc)
{
	self thread _move_pap_mover("down", onmovefunc, onstopfunc);
}

/*
	Name: _move_up
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x3CC92FDE
	Offset: 0x1B00
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function _move_up(onmovefunc, onstopfunc)
{
	self thread _move_pap_mover("up", onmovefunc, onstopfunc);
}

/*
	Name: _plate_move_up
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xF1170644
	Offset: 0x1B48
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function _plate_move_up()
{
	onmovefunc = &_plate_onmove;
	onstopfunc = &_plate_onstop;
	self thread _move_up(onmovefunc, onstopfunc);
}

/*
	Name: _plate_move_down
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x3B854B52
	Offset: 0x1BA8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function _plate_move_down()
{
	onmovefunc = &_plate_onmove;
	onstopfunc = &_plate_onstop;
	self thread _move_down(onmovefunc, onstopfunc);
}

/*
	Name: _plate_onmove
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xD842F6E
	Offset: 0x1C08
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function _plate_onmove()
{
	self _plate_playmovesound();
}

/*
	Name: _plate_onstop
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x37CA33E
	Offset: 0x1C30
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function _plate_onstop()
{
	self _plate_stopmovesound();
	self _plate_playlockedsound();
}

/*
	Name: _move_all_stairs_down
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x5EFF0BA2
	Offset: 0x1C70
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function _move_all_stairs_down()
{
	for(i = 0; i < level.pap_stairs.size; i++)
	{
		level.pap_stairs[i] thread _stairs_move_down();
	}
}

/*
	Name: _move_all_stairs_up
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x1C590D5
	Offset: 0x1CC8
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function _move_all_stairs_up()
{
	for(i = 0; i < level.pap_stairs.size; i++)
	{
		level.pap_stairs[i] thread _stairs_move_up();
	}
}

/*
	Name: _stairs_move_up
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xE13D06E6
	Offset: 0x1D20
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function _stairs_move_up()
{
	onmovefunc = &_stairs_onmove;
	onstopfunc = &_stairs_onstop;
	self _move_up(onmovefunc, onstopfunc);
}

/*
	Name: _stairs_move_down
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x3811C7D9
	Offset: 0x1D80
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function _stairs_move_down()
{
	onmovefunc = &_stairs_onmove;
	onstopfunc = &_stairs_onstop;
	self _move_down(onmovefunc, onstopfunc);
}

/*
	Name: _stairs_onmove
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xCF2BAA59
	Offset: 0x1DE0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function _stairs_onmove()
{
	self _stairs_playmovesound();
}

/*
	Name: _stairs_onstop
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x872BCF5F
	Offset: 0x1E08
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function _stairs_onstop()
{
	self _stairs_stopmovesound();
	self _stairs_playlockedsound();
}

/*
	Name: _wait_for_all_stairs
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x4A62A31C
	Offset: 0x1E48
	Size: 0x82
	Parameters: 1
	Flags: Linked
*/
function _wait_for_all_stairs(state)
{
	for(i = 0; i < level.pap_stairs.size; i++)
	{
		stair = level.pap_stairs[i];
		while(true)
		{
			if(stair.state == state)
			{
				break;
			}
			wait(0.1);
		}
	}
}

/*
	Name: _wait_for_all_stairs_up
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xABBF9D59
	Offset: 0x1ED8
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function _wait_for_all_stairs_up()
{
	_wait_for_all_stairs("up");
	if(isdefined(level.brush_pap_traversal))
	{
		a_nodes = getnodearray("node_pap_jump_bottom", "targetname");
		foreach(node in a_nodes)
		{
			unlinktraversal(node);
		}
		level.brush_pap_traversal notsolid();
		level.brush_pap_traversal connectpaths();
	}
	if(isdefined(level.brush_pap_side_l))
	{
		level.brush_pap_side_l _pap_brush_connect_paths();
	}
	if(isdefined(level.brush_pap_side_r))
	{
		level.brush_pap_side_r _pap_brush_connect_paths();
	}
}

/*
	Name: _wait_for_all_stairs_down
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x78F25BB9
	Offset: 0x2040
	Size: 0x15C
	Parameters: 0
	Flags: Linked
*/
function _wait_for_all_stairs_down()
{
	_wait_for_all_stairs("down");
	if(isdefined(level.brush_pap_traversal))
	{
		a_nodes = getnodearray("node_pap_jump_bottom", "targetname");
		foreach(node in a_nodes)
		{
			linktraversal(node);
		}
		level.brush_pap_traversal solid();
		level.brush_pap_traversal disconnectpaths();
	}
	if(isdefined(level.brush_pap_side_l))
	{
		level.brush_pap_side_l _pap_brush_disconnect_paths();
	}
	if(isdefined(level.brush_pap_side_r))
	{
		level.brush_pap_side_r _pap_brush_disconnect_paths();
	}
}

/*
	Name: _pap_think
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x55A6832
	Offset: 0x21A8
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function _pap_think()
{
	player_blocker = getent("pap_stairs_player_clip", "targetname");
	level flag::set("pap_active");
	level thread _pap_clean_up_corpses();
	if(isdefined(level.pap_stairs_clip))
	{
		level.pap_stairs_clip movez(level.pap_stairs_clip.zmove, 2, 0.5, 0.5);
	}
	_move_all_stairs_up();
	_wait_for_all_stairs_up();
	if(isdefined(player_blocker))
	{
		player_blocker notsolid();
	}
	level stop_pap_fx();
	level thread _wait_for_pap_reset();
	level waittill(#"flush_done");
	level flag::clear("pap_active");
	if(isdefined(level.pap_stairs_clip))
	{
		level.pap_stairs_clip movez(-1 * level.pap_stairs_clip.zmove, 2, 0.5, 0.5);
	}
	level thread _pap_ramp();
	_move_all_stairs_down();
	_wait_for_all_stairs_down();
}

/*
	Name: _pap_clean_up_corpses
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x6B6746C9
	Offset: 0x2388
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function _pap_clean_up_corpses()
{
	corpse_trig = getent("pap_target_finder", "targetname");
	stairs_trig = getent("pap_target_finder2", "targetname");
	corpses = getcorpsearray();
	if(isdefined(corpses))
	{
		for(i = 0; i < corpses.size; i++)
		{
			if(corpses[i] istouching(corpse_trig) || corpses[i] istouching(stairs_trig))
			{
				corpses[i] thread _pap_remove_corpse();
			}
		}
	}
}

/*
	Name: _pap_remove_corpse
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x71C79A4B
	Offset: 0x24A8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function _pap_remove_corpse()
{
	playfx(level._effect["corpse_gib"], self.origin);
	self delete();
}

/*
	Name: _pap_ramp
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x4963679B
	Offset: 0x2500
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function _pap_ramp()
{
	if(isdefined(level.pap_ramp))
	{
		level thread playerclip_restore();
		if(!isdefined(level.pap_ramp.original_origin))
		{
			level.pap_ramp.original_origin = level.pap_ramp.origin;
		}
		level.pap_ramp rotateroll(45, 0.5);
		wait(1);
		level.pap_ramp rotateroll(45, 0.5);
		level.pap_ramp moveto(struct::get("pap_ramp_push1", "targetname").origin, 1);
		level.pap_ramp waittill(#"movedone");
		level.pap_ramp moveto(struct::get("pap_ramp_push2", "targetname").origin, 2);
		level.pap_ramp waittill(#"movedone");
		level.pap_ramp.origin = level.pap_ramp.original_origin;
		level.pap_ramp rotateroll(-90, 0.5);
	}
}

/*
	Name: playerclip_restore
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xE6ADFE1C
	Offset: 0x26B0
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function playerclip_restore()
{
	volume = getent("pap_target_finder", "targetname");
	while(true)
	{
		touching = 0;
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(players[i] istouching(volume) || players[i] istouching(level.pap_player_flush_temp_trig))
			{
				touching = 1;
			}
		}
		if(!touching)
		{
			break;
		}
		wait(0.05);
	}
	player_clip = getent("pap_stairs_player_clip", "targetname");
	if(isdefined(player_clip))
	{
		player_clip solid();
	}
	if(isdefined(level.pap_player_flush_temp_trig))
	{
		level.pap_player_flush_temp_trig delete();
	}
}

/*
	Name: _wait_for_pap_reset
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x168EB14B
	Offset: 0x2838
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function _wait_for_pap_reset()
{
	level endon(#"fake_death");
	array::thread_all(level.pap_timers, &_move_visual_timer);
	array::thread_all(level.pap_timers, &_pack_a_punch_timer_sounds);
	level thread _pack_a_punch_warning_fx(level.pap_active_time);
	fx_time_offset = 0.5;
	wait(level.pap_active_time - fx_time_offset);
	level start_pap_fx();
	level thread _pap_fx_timer();
	wait(fx_time_offset);
	_find_ents_to_flush();
}

/*
	Name: _pap_fx_timer
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xCEED6217
	Offset: 0x2928
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function _pap_fx_timer()
{
	wait(5.5);
	level notify(#"flush_fx_done");
}

/*
	Name: _pack_a_punch_warning_fx
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xF59486B9
	Offset: 0x2950
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function _pack_a_punch_warning_fx(pap_time)
{
	wait(pap_time - 5);
	exploder::exploder("fxexp_60");
}

/*
	Name: _pack_a_punch_timer_sounds
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x3CD98C0C
	Offset: 0x2990
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function _pack_a_punch_timer_sounds()
{
	pap_timer_length = 8.5;
	self playsound("evt_pap_timer_start");
	self playloopsound("evt_pap_timer_loop");
	wait(level.pap_active_time - pap_timer_length);
	self playsound("evt_pap_timer_countdown");
	wait(pap_timer_length);
	self stoploopsound();
	self playsound("evt_pap_timer_stop");
}

/*
	Name: _find_ents_to_flush
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x94ACED7F
	Offset: 0x2A50
	Size: 0x30E
	Parameters: 0
	Flags: Linked
*/
function _find_ents_to_flush()
{
	level notify(#"flush_ents");
	level endon(#"fake_death");
	_play_flush_sounds();
	level.flushspeed = 400;
	level.ents_being_flushed = 0;
	level.flushscale = 1;
	volume = getent("pap_target_finder", "targetname");
	level.pap_player_flush_temp_trig = spawn("trigger_radius", (-8, 560, 288), 0, 768, 256);
	players = getplayers();
	touching_players = [];
	for(i = 0; i < players.size; i++)
	{
		touching = players[i] istouching(volume) || players[i] istouching(level.pap_player_flush_temp_trig);
		if(touching)
		{
			touching_players[touching_players.size] = players[i];
			players[i] thread _player_flushed_out(volume);
		}
	}
	bottom_stairs_vol = getent("pap_target_finder2", "targetname");
	zombies_to_flush = [];
	zombies = getaispeciesarray("axis", "all");
	for(i = 0; i < zombies.size; i++)
	{
		if(zombies[i] istouching(volume) || zombies[i] istouching(bottom_stairs_vol))
		{
			zombies_to_flush[zombies_to_flush.size] = zombies[i];
		}
	}
	if(zombies_to_flush.size > 0)
	{
		level thread do_zombie_flush(zombies_to_flush);
	}
	level notify(#"flush_done");
	while(level.ents_being_flushed > 0)
	{
		util::wait_network_frame();
	}
	level notify(#"pap_reset_complete");
}

/*
	Name: _player_flushed_out
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x612B2908
	Offset: 0x2D68
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function _player_flushed_out(volume)
{
	self endon(#"death");
	self endon(#"disconnect");
	level endon(#"flush_fx_done");
	water_start_org = (0, 408, 304);
	max_dist = 400;
	time = 1.5;
	dist = distance(self.origin, water_start_org);
	scale_dist = dist / max_dist;
	time = time * scale_dist;
	wait(time);
	while(true)
	{
		if(!self istouching(volume))
		{
			break;
		}
		util::wait_network_frame();
	}
}

/*
	Name: _play_flush_sounds
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x1E20C649
	Offset: 0x2E70
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function _play_flush_sounds()
{
	snd_struct = struct::get("pap_water", "targetname");
	if(isdefined(snd_struct))
	{
		level thread sound::play_in_space("evt_pap_water", snd_struct.origin);
	}
}

/*
	Name: _flush_compare_func
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xF9695AD4
	Offset: 0x2EE0
	Size: 0x92
	Parameters: 2
	Flags: None
*/
function _flush_compare_func(p1, p2)
{
	dist1 = distancesquared(p1.origin, level.flush_path.origin);
	dist2 = distancesquared(p2.origin, level.flush_path.origin);
	return dist1 > dist2;
}

/*
	Name: _player_flush
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x5AA7E5C7
	Offset: 0x2F80
	Size: 0x4B4
	Parameters: 1
	Flags: None
*/
function _player_flush(index)
{
	self enableinvulnerability();
	self allowprone(0);
	self allowcrouch(0);
	self playrumblelooponentity("tank_rumble");
	self thread pap_flush_screen_shake(3);
	mover = spawn("script_origin", self.origin);
	self playerlinkto(mover);
	pc = level.pap_playerclip[index];
	pc.origin = self.origin;
	pc linkto(self);
	level.ents_being_flushed++;
	self.flushed = 1;
	useaccel = 1;
	flushspeed = level.flushspeed - (30 * index);
	wait(index * 0.1);
	nexttarget = self _ent_getnextflushtarget();
	while(isdefined(nexttarget))
	{
		movetarget = (self.origin[0], nexttarget.origin[1], nexttarget.origin[2]);
		if(!isdefined(nexttarget.next))
		{
			movetarget = (movetarget[0], self.origin[1] + ((movetarget[1] - self.origin[1]) * level.flushscale), movetarget[2]);
			level.flushscale = level.flushscale - 0.25;
			if(level.flushscale <= 0)
			{
				level.flushscale = 0.1;
			}
		}
		dist = abs(nexttarget.origin[1] - self.origin[1]);
		time = dist / flushspeed;
		accel = 0;
		decel = 0;
		if(useaccel)
		{
			useaccel = 0;
			accel = min(0.2, time);
		}
		if(!isdefined(nexttarget.target))
		{
			accel = 0;
			decel = time;
			time = time + 0.5;
		}
		mover moveto(movetarget, time, accel, decel);
		waittime = max(time, 0);
		wait(waittime);
		nexttarget = nexttarget.next;
	}
	mover delete();
	self stoprumble("tank_rumble");
	self notify(#"pap_flush_done");
	pc unlink();
	pc.origin = pc.saved_origin;
	self allowprone(1);
	self allowcrouch(1);
	self.flushed = 0;
	self disableinvulnerability();
	level.ents_being_flushed--;
}

/*
	Name: pap_flush_screen_shake
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xF5D1B2ED
	Offset: 0x3440
	Size: 0xA0
	Parameters: 1
	Flags: Linked
*/
function pap_flush_screen_shake(activetime)
{
	self endon(#"pap_flush_done");
	while(true)
	{
		earthquake(randomfloatrange(0.2, 0.4), randomfloatrange(1, 2), self.origin, 100, self);
		wait(randomfloatrange(0.1, 0.3));
	}
}

/*
	Name: do_zombie_flush
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x61286185
	Offset: 0x34E8
	Size: 0x86
	Parameters: 1
	Flags: Linked
*/
function do_zombie_flush(zombies_to_flush)
{
	for(i = 0; i < zombies_to_flush.size; i++)
	{
		if(isdefined(zombies_to_flush[i]) && isalive(zombies_to_flush[i]))
		{
			zombies_to_flush[i] thread _zombie_flush();
		}
	}
}

/*
	Name: _zombie_flush
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xE517C5C4
	Offset: 0x3578
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function _zombie_flush()
{
	self endon(#"death");
	water_start_org = (0, 408, 304);
	max_dist = 400;
	time = 1.5;
	dist = distance(self.origin, water_start_org);
	scale_dist = dist / max_dist;
	time = time * scale_dist;
	wait(time);
	self startragdoll();
	nexttarget = self _ent_getnextflushtarget();
	launchdir = nexttarget.origin - self.origin;
	launchdir = (0, launchdir[1], launchdir[2]);
	launchdir = vectornormalize(launchdir);
	self launchragdoll(launchdir * 50);
	util::wait_network_frame();
	self.no_gib = 1;
	level.zombie_total++;
	self dodamage(self.health + 666, self.origin);
}

/*
	Name: _ent_getnextflushtarget
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xE8FF3350
	Offset: 0x3740
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function _ent_getnextflushtarget()
{
	current_node = level.flush_path;
	while(true)
	{
		if(self.origin[1] >= current_node.origin[1])
		{
			break;
		}
		current_node = current_node.next;
	}
	return current_node;
}

/*
	Name: _set_num_plates_active
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x72717874
	Offset: 0x37B0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function _set_num_plates_active(num, state)
{
	level.pap_plates_active = num;
	level.pap_plates_state = state;
	clientfield::set("papspinners", state);
}

/*
	Name: _setup_pap_timer
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x9E96B542
	Offset: 0x3808
	Size: 0x2D8
	Parameters: 0
	Flags: Linked
*/
function _setup_pap_timer()
{
	level.pap_timers = getentarray("pap_timer", "targetname");
	for(i = 0; i < level.pap_timers.size; i++)
	{
		timer = level.pap_timers[i];
		timer.path = [];
		targetname = timer.target;
		while(isdefined(targetname))
		{
			s = struct::get(targetname, "targetname");
			if(!isdefined(s))
			{
				break;
			}
			timer.path[timer.path.size] = s;
			targetname = s.target;
		}
		timer.origin = timer.path[0].origin;
		pathlength = 0;
		for(p = 1; p < timer.path.size; p++)
		{
			length = distance(timer.path[p - 1].origin, timer.path[p].origin);
			timer.path[p].pathlength = length;
			pathlength = pathlength + length;
		}
		timer.pathlength = pathlength;
		for(p = timer.path.size - 2; p >= 0; p--)
		{
			length = distance(timer.path[p + 1].origin, timer.path[p].origin);
			timer.path[p].pathlengthreverse = length;
		}
	}
}

/*
	Name: _move_visual_timer
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x2946EDF8
	Offset: 0x3AE8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function _move_visual_timer()
{
	reversespin = self.angles[1] != 0;
	speed = self.pathlength / level.pap_active_time;
	self _travel_path(speed, reversespin);
	returntime = 4;
	speed = self.pathlength / returntime;
	self _travel_path_reverse(speed, reversespin);
	self.origin = self.path[0].origin;
}

/*
	Name: _travel_path
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xCE2A2992
	Offset: 0x3BB0
	Size: 0x17A
	Parameters: 2
	Flags: Linked
*/
function _travel_path(speed, reversespin)
{
	for(i = 1; i < self.path.size; i++)
	{
		length = self.path[i].pathlength;
		time = length / speed;
		acceltime = 0;
		deceltime = 0;
		if(i == 1)
		{
			acceltime = 0.2;
		}
		else if(i == (self.path.size - 1))
		{
			deceltime = 0.2;
		}
		self moveto(self.path[i].origin, time, acceltime, deceltime);
		rotatespeed = speed * -4;
		if(reversespin)
		{
			rotatespeed = rotatespeed * -1;
		}
		self rotatevelocity((0, 0, rotatespeed), time);
		self waittill(#"movedone");
	}
}

/*
	Name: _travel_path_reverse
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x3A675B4
	Offset: 0x3D38
	Size: 0x1B6
	Parameters: 2
	Flags: Linked
*/
function _travel_path_reverse(speed, reversespin)
{
	for(i = self.path.size - 2; i >= 0; i--)
	{
		length = self.path[i].pathlengthreverse;
		time = length / speed;
		acceltime = 0;
		deceltime = 0;
		if(i == (self.path.size - 2))
		{
			acceltime = 0.2;
		}
		else if(i == 0)
		{
			deceltime = 0.5;
		}
		self moveto(self.path[i].origin, time, acceltime, deceltime);
		rotatespeed = speed * 4;
		if(reversespin)
		{
			rotatespeed = rotatespeed * -1;
		}
		self rotatevelocity((0, 0, rotatespeed), time);
		self waittill(#"movedone");
		self playsound("evt_pap_timer_stop");
		self playsound("evt_pap_timer_start");
	}
}

/*
	Name: _setup_pap_path
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x799F76F2
	Offset: 0x3EF8
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function _setup_pap_path()
{
	level.flush_path = struct::get("pap_flush_path", "targetname");
	current_node = level.flush_path;
	while(true)
	{
		if(!isdefined(current_node.target))
		{
			break;
		}
		next_node = struct::get(current_node.target, "targetname");
		current_node.next = next_node;
		current_node = next_node;
	}
}

/*
	Name: _setup_pap_fx
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x99EC1590
	Offset: 0x3FB8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _setup_pap_fx()
{
}

/*
	Name: start_pap_fx
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x8124E1C7
	Offset: 0x3FC8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function start_pap_fx()
{
	exploder::exploder("fxexp_61");
}

/*
	Name: stop_pap_fx
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x6D52A295
	Offset: 0x3FF0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function stop_pap_fx()
{
	exploder::stop_exploder("fxexp_61");
}

/*
	Name: _pap_brush_disconnect_paths
	Namespace: zm_temple_pack_a_punch
	Checksum: 0x580C02A3
	Offset: 0x4018
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function _pap_brush_disconnect_paths()
{
	self solid();
	self disconnectpaths();
	self notsolid();
}

/*
	Name: _pap_brush_connect_paths
	Namespace: zm_temple_pack_a_punch
	Checksum: 0xD5A62504
	Offset: 0x4070
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function _pap_brush_connect_paths()
{
	self solid();
	self connectpaths();
	self notsolid();
}

