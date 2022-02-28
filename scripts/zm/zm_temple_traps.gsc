// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_thundergun;
#using scripts\zm\zm_temple_triggers;

#namespace zm_temple_traps;

/*
	Name: init_temple_traps
	Namespace: zm_temple_traps
	Checksum: 0xD9E45A6C
	Offset: 0x520
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function init_temple_traps()
{
	level thread spear_trap_init();
	level thread waterfall_trap_init();
	level thread init_maze_trap();
}

/*
	Name: trigger_wait_for_power
	Namespace: zm_temple_traps
	Checksum: 0x73CDACE8
	Offset: 0x578
	Size: 0x6C
	Parameters: 0
	Flags: None
*/
function trigger_wait_for_power()
{
	self sethintstring(&"ZOMBIE_NEED_POWER");
	self setcursorhint("HINT_NOICON");
	self.in_use = 0;
	level flag::wait_till("power_on");
}

/*
	Name: spear_trap_init
	Namespace: zm_temple_traps
	Checksum: 0x6EEE6CE9
	Offset: 0x5F0
	Size: 0x10E
	Parameters: 0
	Flags: Linked
*/
function spear_trap_init()
{
	speartraps = getentarray("spear_trap", "targetname");
	for(i = 0; i < speartraps.size; i++)
	{
		speartrap = speartraps[i];
		speartrap.clip = getent(speartrap.target, "targetname");
		speartrap.clip notsolid();
		speartrap.clip connectpaths();
		speartrap.enable_flag = speartrap.script_noteworthy;
		speartrap thread spear_trap_think();
	}
}

/*
	Name: spear_trap_think
	Namespace: zm_temple_traps
	Checksum: 0x81E7C4AF
	Offset: 0x708
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function spear_trap_think()
{
	if(isdefined(self.enable_flag) && !level flag::get(self.enable_flag))
	{
		level flag::wait_till(self.enable_flag);
	}
	while(true)
	{
		self waittill(#"trigger", who);
		if(!isdefined(who) || !isplayer(who) || who.sessionstate == "spectator")
		{
			continue;
		}
		for(i = 0; i < 3; i++)
		{
			wait(0.4);
			self thread sprear_trap_activate_spears(i, who);
			wait(2);
		}
	}
}

/*
	Name: sprear_trap_activate_spears
	Namespace: zm_temple_traps
	Checksum: 0xC395BB44
	Offset: 0x820
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function sprear_trap_activate_spears(audio_counter, player)
{
	self spear_trap_damage_all_characters(audio_counter, player);
	self thread spear_activate(0);
}

/*
	Name: spear_trap_damage_all_characters
	Namespace: zm_temple_traps
	Checksum: 0x69963516
	Offset: 0x878
	Size: 0x156
	Parameters: 2
	Flags: Linked
*/
function spear_trap_damage_all_characters(audio_counter, player)
{
	wait(0.1);
	characters = arraycombine(getplayers(), getaispeciesarray("axis"), 1, 1);
	for(i = 0; i < characters.size; i++)
	{
		char = characters[i];
		if(self spear_trap_is_character_touching(char))
		{
			self thread spear_damage_character(char);
			continue;
		}
		if(isplayer(char) && audio_counter == 0 && randomintrange(0, 101) <= 10)
		{
			if(isdefined(player) && player == char)
			{
				char thread delayed_spikes_close_vox();
			}
		}
	}
}

/*
	Name: delayed_spikes_close_vox
	Namespace: zm_temple_traps
	Checksum: 0x5FC373AE
	Offset: 0x9D8
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function delayed_spikes_close_vox()
{
	self notify(#"playing_spikes_close_vox");
	self endon(#"death");
	self endon(#"playing_spikes_close_vox");
	wait(0.5);
	if(isdefined(self) && (!isdefined(self.spear_trap_slow) || (isdefined(self.spear_trap_slow) && self.spear_trap_slow == 0)))
	{
		self thread zm_audio::create_and_play_dialog("general", "spikes_close");
	}
}

/*
	Name: spear_damage_character
	Namespace: zm_temple_traps
	Checksum: 0xC21AF182
	Offset: 0xA70
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function spear_damage_character(char)
{
	char thread spear_trap_slow();
}

/*
	Name: spear_trap_slow
	Namespace: zm_temple_traps
	Checksum: 0x9C12E22B
	Offset: 0xAA0
	Size: 0x1A0
	Parameters: 0
	Flags: Linked
*/
function spear_trap_slow()
{
	self endon(#"death");
	if(isdefined(self.spear_trap_slow) && self.spear_trap_slow)
	{
		return;
	}
	self.spear_trap_slow = 1;
	if(isplayer(self))
	{
		if(zombie_utility::is_player_valid(self))
		{
			self thread zm_audio::create_and_play_dialog("general", "spikes_damage");
			self thread _fake_red();
			self dodamage(5, self.origin);
			playsoundatposition("evt_spear_butt", self.origin);
			self playrumbleonentity("pistol_fire");
		}
		self setvelocity((0, 0, 0));
		self setmovespeedscale(0.2);
		wait(1);
		self setmovespeedscale(1);
		wait(0.5);
	}
	else if(!(isdefined(self.missinglegs) && self.missinglegs))
	{
		self _zombie_spear_trap_damage_wait();
	}
	self.spear_trap_slow = 0;
}

/*
	Name: spear_choke
	Namespace: zm_temple_traps
	Checksum: 0xD713184D
	Offset: 0xC48
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function spear_choke()
{
	level._num_ai_released = 0;
	while(true)
	{
		wait(0.05);
		level._num_ai_released = 0;
	}
}

/*
	Name: _zombie_spear_trap_damage_wait
	Namespace: zm_temple_traps
	Checksum: 0xEFC2FAD9
	Offset: 0xC80
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function _zombie_spear_trap_damage_wait()
{
	self endon(#"death");
	if(!isdefined(level._spear_choke))
	{
		level._spear_choke = 1;
		level thread spear_choke();
	}
	endtime = gettime() + randomintrange(800, 1200);
	while(endtime > gettime())
	{
		if(isdefined(self.missinglegs) && self.missinglegs)
		{
			break;
		}
		wait(0.05);
	}
	while(level._num_ai_released > 2)
	{
		/#
			println("");
		#/
		wait(0.05);
	}
	self stopanimscripted(0.5);
	level._num_ai_released++;
}

/*
	Name: _fake_red
	Namespace: zm_temple_traps
	Checksum: 0xDE44C5D0
	Offset: 0xD88
	Size: 0x174
	Parameters: 0
	Flags: Linked
*/
function _fake_red()
{
	prompt = newclienthudelem(self);
	prompt.alignx = "left";
	prompt.x = 0;
	prompt.y = 0;
	prompt.alignx = "left";
	prompt.aligny = "top";
	prompt.horzalign = "fullscreen";
	prompt.vertalign = "fullscreen";
	fadetime = 1;
	prompt.color = vectorscale((1, 0, 0), 0.2);
	prompt.alpha = 0.7;
	prompt fadeovertime(fadetime);
	prompt.alpha = 0;
	prompt.shader = "white";
	prompt setshader("white", 640, 480);
	wait(fadetime);
	prompt destroy();
}

/*
	Name: spear_trap_is_character_touching
	Namespace: zm_temple_traps
	Checksum: 0x5E278EB9
	Offset: 0xF08
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function spear_trap_is_character_touching(char)
{
	return self istouching(char);
}

/*
	Name: spear_activate
	Namespace: zm_temple_traps
	Checksum: 0x6EF7956B
	Offset: 0xF38
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function spear_activate(delay)
{
	wait(delay);
	if(isdefined(self.clip))
	{
		self.clip solid();
		self.clip clientfield::set("spiketrap", 1);
	}
	wait(2);
	if(isdefined(self.clip))
	{
		self.clip notsolid();
		self.clip clientfield::set("spiketrap", 0);
	}
	wait(0.2);
}

/*
	Name: spear_kill
	Namespace: zm_temple_traps
	Checksum: 0x2C0A4874
	Offset: 0x1000
	Size: 0x94
	Parameters: 1
	Flags: None
*/
function spear_kill(magnitude)
{
	self startragdoll();
	self launchragdoll(vectorscale((0, 0, 1), 50));
	util::wait_network_frame();
	self.a.gib_ref = "head";
	self dodamage(self.health + 666, self.origin);
}

/*
	Name: temple_trap_move_switch
	Namespace: zm_temple_traps
	Checksum: 0xF0BF4A00
	Offset: 0x10A0
	Size: 0x1BE
	Parameters: 0
	Flags: Linked
*/
function temple_trap_move_switch()
{
	trap_switch = undefined;
	for(i = 0; i < self.trap_switches.size; i++)
	{
		trap_switch = self.trap_switches[i];
		trap_switch movey(-5, 0.75);
	}
	if(isdefined(trap_switch))
	{
		trap_switch playloopsound("zmb_pressure_plate_loop");
		trap_switch waittill(#"movedone");
		trap_switch stoploopsound();
		trap_switch playsound("zmb_pressure_plate_lock");
	}
	self notify(#"switch_activated");
	self waittill(#"trap_ready");
	for(i = 0; i < self.trap_switches.size; i++)
	{
		trap_switch = self.trap_switches[i];
		trap_switch movey(5, 0.75);
		trap_switch playloopsound("zmb_pressure_plate_loop");
		trap_switch waittill(#"movedone");
		trap_switch stoploopsound();
		trap_switch playsound("zmb_pressure_plate_lock");
	}
}

/*
	Name: waterfall_trap_init
	Namespace: zm_temple_traps
	Checksum: 0x9BF923BD
	Offset: 0x1268
	Size: 0x3C6
	Parameters: 0
	Flags: Linked
*/
function waterfall_trap_init()
{
	usetriggers = getentarray("waterfall_trap", "targetname");
	for(i = 0; i < usetriggers.size; i++)
	{
		trapstruct = spawnstruct();
		trapstruct.usetrigger = usetriggers[i];
		trapstruct.usetrigger sethintstring(&"ZOMBIE_NEED_POWER");
		trapstruct.usetrigger setcursorhint("HINT_NOICON");
		trapstruct.trap_switches = [];
		trapstruct.trap_damage = [];
		trapstruct.trap_shake = [];
		trapstruct.water_drop_trigs = [];
		trapstruct.var_41f396e4 = [];
		targetents = getentarray(trapstruct.usetrigger.target, "targetname");
		targetstructs = struct::get_array(trapstruct.usetrigger.target, "targetname");
		targets = arraycombine(targetents, targetstructs, 1, 1);
		for(j = 0; j < targets.size; j++)
		{
			if(!isdefined(targets[j].script_noteworthy))
			{
				continue;
			}
			switch(targets[j].script_noteworthy)
			{
				case "trap_switch":
				{
					trapstruct.trap_switches[trapstruct.trap_switches.size] = targets[j];
					break;
				}
				case "trap_damage":
				{
					trapstruct.trap_damage[trapstruct.trap_damage.size] = targets[j];
					break;
				}
				case "trap_shake":
				{
					trapstruct.trap_shake[trapstruct.trap_shake.size] = targets[j];
					break;
				}
				case "water_drop_trigger":
				{
					targets[j] triggerenable(0);
					trapstruct.water_drop_trigs[trapstruct.water_drop_trigs.size] = targets[j];
					break;
				}
				case "water_trap_trigger":
				{
					targets[j] triggerenable(0);
					trapstruct.var_41f396e4[trapstruct.var_41f396e4.size] = targets[j];
					break;
				}
			}
		}
		trapstruct.enable_flag = trapstruct.usetrigger.script_noteworthy;
		trapstruct waterfall_trap_think();
	}
}

/*
	Name: waterfall_trap_think
	Namespace: zm_temple_traps
	Checksum: 0xC5D45D1A
	Offset: 0x1638
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function waterfall_trap_think()
{
	while(true)
	{
		self notify(#"trap_ready");
		self.usetrigger sethintstring(&"ZM_TEMPLE_USE_WATER_TRAP");
		self.usetrigger waittill(#"trigger", who);
		if(zombie_utility::is_player_valid(who) && !who zm_utility::in_revive_trigger())
		{
			who.used_waterfall = 1;
			self thread temple_trap_move_switch();
			self waittill(#"switch_activated");
			self.usetrigger sethintstring("");
			waterfall_trap_on();
			wait(0.5);
			who.used_waterfall = 0;
			array::thread_all(self.trap_damage, &waterfall_trap_damage);
			activetime = 5.5;
			array::thread_all(self.var_41f396e4, &waterfall_screen_fx, activetime);
			self thread waterfall_screen_shake(activetime);
			wait(activetime);
			self notify(#"trap_off");
			self.usetrigger sethintstring(&"ZM_TEMPLE_WATER_TRAP_COOL");
			array::thread_all(self.var_41f396e4, &function_a6e2b85f);
			waterfall_trap_off();
			array::notify_all(self.trap_damage, "trap_off");
			wait(30);
		}
	}
}

/*
	Name: function_a6e2b85f
	Namespace: zm_temple_traps
	Checksum: 0x31CA6B67
	Offset: 0x1868
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function function_a6e2b85f()
{
	self triggerenable(0);
	self notify(#"waterfall_trap_off");
}

/*
	Name: waterfall_screen_fx
	Namespace: zm_temple_traps
	Checksum: 0xE8683894
	Offset: 0x18A0
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function waterfall_screen_fx(activetime)
{
	self.water_drop_time = 5;
	self.waterdrops = 1;
	self.watersheeting = 1;
	wait(1.5);
	self.watersheetingtime = activetime - 1.5;
	self thread function_b68fdf22();
}

/*
	Name: function_b68fdf22
	Namespace: zm_temple_traps
	Checksum: 0xA703DA4B
	Offset: 0x1918
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_b68fdf22()
{
	self endon(#"waterfall_trap_off");
	self triggerenable(1);
	while(true)
	{
		self waittill(#"trigger", who);
		if(isplayer(who))
		{
			self thread function_5e706bd9(who);
		}
	}
}

/*
	Name: function_5e706bd9
	Namespace: zm_temple_traps
	Checksum: 0xF89CE165
	Offset: 0x1998
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function function_5e706bd9(player)
{
	player endon(#"disconnect");
	self thread zm_temple_triggers::water_drop_trig_entered(player);
	while(isdefined(player) && player istouching(self) && self istriggerenabled())
	{
		wait(0.05);
	}
	self thread zm_temple_triggers::water_drop_trig_exit(player);
}

/*
	Name: waterfall_screen_shake
	Namespace: zm_temple_traps
	Checksum: 0x2977555E
	Offset: 0x1A38
	Size: 0x6E
	Parameters: 1
	Flags: Linked
*/
function waterfall_screen_shake(activetime)
{
	wait(1);
	for(i = 0; i < self.trap_shake.size; i++)
	{
		waterfall_screen_shake_single(activetime, self.trap_shake[i].origin);
	}
}

/*
	Name: waterfall_screen_shake_single
	Namespace: zm_temple_traps
	Checksum: 0xF0ADABF5
	Offset: 0x1AB0
	Size: 0xA2
	Parameters: 2
	Flags: Linked
*/
function waterfall_screen_shake_single(activetime, origin)
{
	remainingtime = 1;
	if(activetime > 6)
	{
		remainingtime = activetime - 6;
	}
	while(remainingtime > 0)
	{
		earthquake(0.14, activetime, origin, 400);
		wait(1);
		remainingtime = remainingtime - 1;
	}
}

/*
	Name: waterfall_trap_on
	Namespace: zm_temple_traps
	Checksum: 0x4BA2C357
	Offset: 0x1B60
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function waterfall_trap_on()
{
	soundstruct = struct::get("waterfall_trap_origin", "targetname");
	if(isdefined(soundstruct))
	{
		playsoundatposition("evt_waterfall_trap", soundstruct.origin);
	}
	level notify(#"waterfall");
	level clientfield::set("waterfall_trap", 1);
	exploder::exploder("fxexp_21");
	exploder::stop_exploder("fxexp_20");
}

/*
	Name: waterfall_trap_off
	Namespace: zm_temple_traps
	Checksum: 0x622A57F9
	Offset: 0x1C30
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function waterfall_trap_off()
{
	exploder::exploder("fxexp_20");
	exploder::stop_exploder("fxexp_21");
}

/*
	Name: waterfall_trap_damage
	Namespace: zm_temple_traps
	Checksum: 0xED467420
	Offset: 0x1C70
	Size: 0x1B0
	Parameters: 0
	Flags: Linked
*/
function waterfall_trap_damage()
{
	self endon(#"trap_off");
	fwd = anglestoforward(self.angles);
	zombies_knocked_down = [];
	while(true)
	{
		self waittill(#"trigger", who);
		if(isplayer(who))
		{
			if(isdefined(self.script_string) && self.script_string == "hurt_player")
			{
				who dodamage(20, self.origin);
				wait(1);
			}
			else
			{
				who thread waterfall_trap_player(fwd, 5.45);
			}
		}
		if(isdefined(who.animname) && who.animname == "monkey_zombie")
		{
			who thread waterfall_trap_monkey(randomintrange(30, 80), fwd);
		}
		else if(!ent_in_array(who, zombies_knocked_down))
		{
			zombies_knocked_down[zombies_knocked_down.size] = who;
			util::wait_network_frame();
			who thread zombie_waterfall_knockdown(self);
		}
	}
}

/*
	Name: waterfall_trap_player
	Namespace: zm_temple_traps
	Checksum: 0x21997B1F
	Offset: 0x1E28
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function waterfall_trap_player(fwd, time)
{
	wait(1);
	vel = self getvelocity();
	self setvelocity(vel + (fwd * 60));
	self playrumbleonentity("slide_rumble");
}

/*
	Name: waterfall_trap_monkey
	Namespace: zm_temple_traps
	Checksum: 0x10E036D8
	Offset: 0x1EB8
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function waterfall_trap_monkey(magnitude, dir)
{
	wait(1);
	self startragdoll();
	self launchragdoll(dir * magnitude);
	util::wait_network_frame();
	self dodamage(self.health + 666, self.origin);
}

/*
	Name: ent_in_array
	Namespace: zm_temple_traps
	Checksum: 0x5D0A9B5B
	Offset: 0x1F48
	Size: 0x5A
	Parameters: 2
	Flags: Linked
*/
function ent_in_array(ent, _array)
{
	for(i = 0; i < _array.size; i++)
	{
		if(_array[i] == ent)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: init_maze_trap
	Namespace: zm_temple_traps
	Checksum: 0x1BBEE468
	Offset: 0x1FB0
	Size: 0x5E4
	Parameters: 0
	Flags: Linked
*/
function init_maze_trap()
{
	level.mazecells = [];
	level.mazefloors = [];
	level.mazewalls = [];
	level.mazepath = [];
	level.startcells = [];
	level.pathplayers = [];
	level.pathactive = 0;
	mazeclip = getent("maze_path_clip", "targetname");
	if(isdefined(mazeclip))
	{
		mazeclip delete();
	}
	init_maze_paths();
	mazetriggers = getentarray("maze_trigger", "targetname");
	for(i = 0; i < mazetriggers.size; i++)
	{
		mazetrigger = mazetriggers[i];
		mazetrigger.pathcount = 0;
		triggernum = mazetrigger.script_int;
		if(!isdefined(triggernum))
		{
			continue;
		}
		_add_maze_cell(triggernum);
		level.mazecells[triggernum - 1].trigger = mazetrigger;
		if(isdefined(mazetrigger.script_string))
		{
			startcell = mazetrigger.script_string == "start";
			if(startcell)
			{
				level.startcells[level.startcells.size] = level.mazecells[triggernum - 1];
			}
		}
	}
	mazefloors = getentarray("maze_floor", "targetname");
	for(i = 0; i < mazefloors.size; i++)
	{
		mazefloor = mazefloors[i];
		floornum = mazefloor.script_int;
		if(!isdefined(floornum))
		{
			continue;
		}
		mazefloor init_maze_mover(16, 0.25, 0.5, 0, "evt_maze_floor_up", "evt_maze_floor_up", 0);
		level.mazecells[floornum - 1].floor = mazefloor;
		level.mazefloors[level.mazefloors.size] = mazefloor;
	}
	mazewalls = getentarray("maze_door", "targetname");
	for(i = 0; i < mazewalls.size; i++)
	{
		mazewall = mazewalls[i];
		wallnum = mazewall.script_int;
		if(!isdefined(wallnum))
		{
			continue;
		}
		mazewall init_maze_mover(-128, 0.25, 1, 1, "evt_maze_wall_down", "evt_maze_wall_up", 1);
		mazewall notsolid();
		mazewall connectpaths();
		mazewall.script_fxid = level._effect["maze_wall_impact"];
		mazewall.var_f88b106c = level._effect["maze_wall_raise"];
		mazewall.fx_active_offset = vectorscale((0, 0, -1), 60);
		mazewall.adjacentcells = [];
		adjacent_cell_nums = [];
		adjacent_cell_nums[0] = wallnum % 100;
		adjacent_cell_nums[1] = int((wallnum - (wallnum % 100)) / 100);
		for(j = 0; j < adjacent_cell_nums.size; j++)
		{
			cell_num = adjacent_cell_nums[j];
			if(cell_num == 0)
			{
				continue;
			}
			mazecell = level.mazecells[cell_num - 1];
			mazecell.walls[mazecell.walls.size] = mazewall;
			mazewall.adjacentcells[mazewall.adjacentcells.size] = mazecell;
		}
		level.mazewalls[level.mazewalls.size] = mazewall;
	}
	maze_show_starts();
	array::thread_all(level.mazecells, &maze_cell_watch);
}

/*
	Name: init_maze_paths
	Namespace: zm_temple_traps
	Checksum: 0x4D3854A1
	Offset: 0x25A0
	Size: 0x614
	Parameters: 0
	Flags: Linked
*/
function init_maze_paths()
{
	level.mazepathcounter = 0;
	level.mazepaths = [];
	add_maze_path(array(5, 4, 3));
	add_maze_path(array(5, 4, 1, 0, 3));
	add_maze_path(array(5, 4, 7, 6, 3));
	add_maze_path(array(5, 4, 3, 6, 9, 12));
	add_maze_path(array(5, 4, 7, 10, 11, 14, 13, 12));
	add_maze_path(array(5, 4, 1, 0, 3, 6, 9, 12));
	add_maze_path(array(5, 4, 7, 8), 1);
	add_maze_path(array(5, 4, 1, 0, 3, 6, 7, 8), 1);
	add_maze_path(array(3, 4, 7, 10, 13, 12));
	add_maze_path(array(3, 4, 5, 8, 7, 6, 9, 12));
	add_maze_path(array(3, 4, 1, 2, 5, 8, 11, 10, 9, 12));
	add_maze_path(array(3, 4, 5));
	add_maze_path(array(3, 4, 7, 6, 9, 10, 11, 8, 5));
	add_maze_path(array(3, 4, 1, 2, 5));
	add_maze_path(array(3, 4, 7, 6), 1);
	add_maze_path(array(3, 4, 1, 2, 5, 8, 7, 6), 1);
	add_maze_path(array(12, 9, 6, 3));
	add_maze_path(array(12, 9, 10, 7, 4, 3));
	add_maze_path(array(12, 9, 10, 13, 14, 11, 8, 5, 4, 3));
	add_maze_path(array(12, 9, 6, 3, 4, 5));
	add_maze_path(array(12, 9, 10, 11, 8, 7, 4, 5));
	add_maze_path(array(12, 9, 6, 3, 0, 1, 2, 5));
	add_maze_path(array(12, 9, 10, 13), 1);
	add_maze_path(array(12, 9, 6, 7, 10, 13), 1);
}

/*
	Name: add_maze_path
	Namespace: zm_temple_traps
	Checksum: 0x9DD3E1EA
	Offset: 0x2BC0
	Size: 0x86
	Parameters: 2
	Flags: Linked
*/
function add_maze_path(path, loopback = 0)
{
	s = spawnstruct();
	s.path = path;
	s.loopback = loopback;
	level.mazepaths[level.mazepaths.size] = s;
}

/*
	Name: init_maze_mover
	Namespace: zm_temple_traps
	Checksum: 0x2C4F2EF5
	Offset: 0x2C50
	Size: 0x130
	Parameters: 7
	Flags: Linked
*/
function init_maze_mover(movedist, moveuptime, movedowntime, blockspaths, moveupsound, movedownsound, cliponly)
{
	self.isactive = 0;
	self.activecount = 0;
	self.ismoving = 0;
	self.movedist = movedist;
	self.activeheight = self.origin[2] + movedist;
	self.moveuptime = moveuptime;
	self.movedowntime = movedowntime;
	self.pathblocker = blockspaths;
	self.alwaysactive = 0;
	self.moveupsound = moveupsound;
	self.movedownsound = movedownsound;
	self.startangles = self.angles;
	self.cliponly = cliponly;
	if(isdefined(self.script_string) && self.script_string == "always_active")
	{
		maze_mover_active(1);
		self.alwaysactive = 1;
	}
}

/*
	Name: _add_maze_cell
	Namespace: zm_temple_traps
	Checksum: 0x84B928B4
	Offset: 0x2D88
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function _add_maze_cell(cell_index)
{
	for(i = level.mazecells.size; i < cell_index; i++)
	{
		level.mazecells[i] = spawnstruct();
		level.mazecells[i] _init_maze_cell();
	}
}

/*
	Name: _init_maze_cell
	Namespace: zm_temple_traps
	Checksum: 0x76EFB1AA
	Offset: 0x2E10
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function _init_maze_cell()
{
	self.trigger = undefined;
	self.floor = undefined;
	self.walls = [];
}

/*
	Name: maze_mover_active
	Namespace: zm_temple_traps
	Checksum: 0x576ADDF7
	Offset: 0x2E38
	Size: 0x2FC
	Parameters: 1
	Flags: Linked
*/
function maze_mover_active(active)
{
	if(self.alwaysactive)
	{
		return;
	}
	if(active)
	{
		self.activecount++;
	}
	else
	{
		self.activecount = int(max(0, self.activecount - 1));
	}
	active = self.activecount > 0;
	if(self.isactive == active)
	{
		return;
	}
	if(active && isdefined(self.moveupsound))
	{
		self playsound(self.moveupsound);
	}
	if(!active && isdefined(self.movedownsound))
	{
		self playsound(self.movedownsound);
	}
	goalpos = (self.origin[0], self.origin[1], self.activeheight);
	if(!active)
	{
		goalpos = (goalpos[0], goalpos[1], goalpos[2] - self.movedist);
	}
	movetime = self.moveuptime;
	if(!active)
	{
		movetime = self.movedowntime;
	}
	if(self.ismoving)
	{
		currentz = self.origin[2];
		goalz = goalpos[2];
		ratio = (abs(goalz - currentz)) / abs(self.movedist);
		movetime = movetime * ratio;
	}
	self notify(#"stop_maze_mover");
	self.isactive = active;
	if(self.cliponly)
	{
		if(active)
		{
			self solid();
			self disconnectpaths();
			self clientfield::set("mazewall", 1);
		}
		else
		{
			self notsolid();
			self connectpaths();
			self clientfield::set("mazewall", 0);
		}
	}
	else
	{
		self thread _maze_mover_move(goalpos, movetime);
	}
}

/*
	Name: _maze_mover_move
	Namespace: zm_temple_traps
	Checksum: 0x8E8D01E6
	Offset: 0x3140
	Size: 0x10C
	Parameters: 2
	Flags: Linked
*/
function _maze_mover_move(goal, time)
{
	self endon(#"stop_maze_mover");
	self.ismoving = 1;
	if(time == 0)
	{
		time = 0.01;
	}
	self moveto(goal, time);
	self waittill(#"movedone");
	self.ismoving = 0;
	if(self.isactive)
	{
		_maze_mover_play_fx(self.script_fxid, self.fx_active_offset);
	}
	else
	{
		_maze_mover_play_fx(self.var_f88b106c, self.var_2f5c5654);
	}
	if(self.pathblocker)
	{
		if(self.isactive)
		{
			self disconnectpaths();
		}
		else
		{
			self connectpaths();
		}
	}
}

/*
	Name: _maze_mover_play_fx
	Namespace: zm_temple_traps
	Checksum: 0xE5B347D6
	Offset: 0x3258
	Size: 0x94
	Parameters: 2
	Flags: Linked
*/
function _maze_mover_play_fx(fx_name, offset)
{
	if(isdefined(fx_name))
	{
		vfwd = anglestoforward(self.angles);
		org = self.origin;
		if(isdefined(offset))
		{
			org = org + offset;
		}
		playfx(fx_name, org, vfwd, (0, 0, 1));
	}
}

/*
	Name: maze_cell_watch
	Namespace: zm_temple_traps
	Checksum: 0x60AA273C
	Offset: 0x32F8
	Size: 0x1D0
	Parameters: 0
	Flags: Linked
*/
function maze_cell_watch()
{
	level endon(#"fake_death");
	while(true)
	{
		self.trigger waittill(#"trigger", who);
		if(self.trigger.pathcount > 0)
		{
			if(isplayer(who))
			{
				if(who is_player_maze_slow())
				{
					continue;
				}
				if(who.sessionstate == "spectator")
				{
					continue;
				}
				self thread maze_cell_player_enter(who);
			}
			else if(isdefined(who.animname) && who.animname == "zombie")
			{
				self.trigger thread zombie_normal_trigger_exit(who);
			}
		}
		else
		{
			if(isplayer(who))
			{
				if(who is_player_on_path())
				{
					continue;
				}
				if(who.sessionstate == "spectator")
				{
					continue;
				}
				self.trigger thread watch_slow_trigger_exit(who);
			}
			else if(isdefined(who.animname) && who.animname == "zombie")
			{
				self.trigger thread zombie_slow_trigger_exit(who);
			}
		}
	}
}

/*
	Name: zombie_mud_move_slow
	Namespace: zm_temple_traps
	Checksum: 0xD45DB5D9
	Offset: 0x34D0
	Size: 0x76
	Parameters: 0
	Flags: Linked
*/
function zombie_mud_move_slow()
{
	self.var_5526feb3 = self.zombie_move_speed;
	switch(self.zombie_move_speed)
	{
		case "run":
		{
			self zombie_utility::set_zombie_run_cycle("walk");
			break;
		}
		case "sprint":
		{
			self zombie_utility::set_zombie_run_cycle("run");
			break;
		}
	}
}

/*
	Name: zombie_mud_move_normal
	Namespace: zm_temple_traps
	Checksum: 0x7D5FE3AA
	Offset: 0x3550
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function zombie_mud_move_normal()
{
	self zombie_utility::set_zombie_run_cycle(self.var_5526feb3);
}

/*
	Name: zombie_slow_trigger_exit
	Namespace: zm_temple_traps
	Checksum: 0x150A26E6
	Offset: 0x3580
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function zombie_slow_trigger_exit(zombie)
{
	zombie endon(#"death");
	if(isdefined(zombie.mud_triggers))
	{
		if(is_in_array(zombie.mud_triggers, self))
		{
			return;
		}
	}
	else
	{
		zombie.mud_triggers = [];
	}
	if(!zombie zombie_on_mud())
	{
		zombie zombie_mud_move_slow();
	}
	zombie.mud_triggers[zombie.mud_triggers.size] = self;
	while(self.pathcount == 0 && zombie istouching(self))
	{
		wait(0.1);
	}
	arrayremovevalue(zombie.mud_triggers, self);
	if(!zombie zombie_on_mud() && !zombie zombie_on_path())
	{
		zombie zombie_mud_move_normal();
	}
}

/*
	Name: is_in_array
	Namespace: zm_temple_traps
	Checksum: 0x9EC19CB9
	Offset: 0x36E0
	Size: 0x98
	Parameters: 2
	Flags: Linked
*/
function is_in_array(array, item)
{
	foreach(index in array)
	{
		if(index == item)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: zombie_on_path
	Namespace: zm_temple_traps
	Checksum: 0x3F2644F3
	Offset: 0x3780
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function zombie_on_path()
{
	return isdefined(self.path_triggers) && self.path_triggers.size > 0;
}

/*
	Name: zombie_on_mud
	Namespace: zm_temple_traps
	Checksum: 0x8A43C486
	Offset: 0x37A8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function zombie_on_mud()
{
	return isdefined(self.mud_triggers) && self.mud_triggers.size > 0;
}

/*
	Name: zombie_normal_trigger_exit
	Namespace: zm_temple_traps
	Checksum: 0x9B9293CF
	Offset: 0x37D0
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function zombie_normal_trigger_exit(zombie)
{
	zombie endon(#"death");
	if(isdefined(zombie.path_triggers))
	{
		if(is_in_array(zombie.path_triggers, self))
		{
			return;
		}
	}
	else
	{
		zombie.path_triggers = [];
	}
	if(!zombie zombie_on_path())
	{
		zombie zombie_mud_move_normal();
	}
	zombie.path_triggers[zombie.path_triggers.size] = self;
	while(self.pathcount != 0 && zombie istouching(self))
	{
		wait(0.1);
	}
	arrayremovevalue(zombie.path_triggers, self);
}

/*
	Name: is_player_on_path
	Namespace: zm_temple_traps
	Checksum: 0x43C04CB0
	Offset: 0x38E8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function is_player_on_path()
{
	return isdefined(self.mazepathcells) && self.mazepathcells.size > 0;
}

/*
	Name: is_player_maze_slow
	Namespace: zm_temple_traps
	Checksum: 0xFEE74F4B
	Offset: 0x3910
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function is_player_maze_slow()
{
	return isdefined(self.mazeslowtrigger) && self.mazeslowtrigger.size > 0;
}

/*
	Name: maze_cell_player_enter
	Namespace: zm_temple_traps
	Checksum: 0xB7F6391D
	Offset: 0x3938
	Size: 0x1E4
	Parameters: 1
	Flags: Linked
*/
function maze_cell_player_enter(player)
{
	if(isdefined(player.mazepathcells))
	{
		if(is_in_array(player.mazepathcells, self))
		{
			return;
		}
	}
	else
	{
		player.mazepathcells = [];
	}
	if(!is_in_array(level.pathplayers, player))
	{
		level.pathplayers[level.pathplayers.size] = player;
	}
	player.mazepathcells[player.mazepathcells.size] = self;
	if(!level.pathactive)
	{
		self maze_start_path();
	}
	on_maze_cell_enter();
	self path_trigger_wait(player);
	isplayervalid = isdefined(player);
	if(isplayervalid)
	{
		arrayremovevalue(player.mazepathcells, self);
	}
	if(!isplayervalid || !player is_player_on_path())
	{
		level.pathplayers = array::remove_undefined(level.pathplayers);
		if(isplayervalid)
		{
			arrayremovevalue(level.pathplayers, player);
		}
		if(level.pathplayers.size == 0)
		{
			maze_end_path();
		}
	}
	on_maze_cell_exit();
}

/*
	Name: path_trigger_wait
	Namespace: zm_temple_traps
	Checksum: 0xC3AFF33E
	Offset: 0x3B28
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function path_trigger_wait(player)
{
	player endon(#"disconnect");
	player endon(#"fake_death");
	player endon(#"death");
	level endon(#"maze_timer_end");
	while(self.trigger.pathcount != 0 && player istouching(self.trigger) && player.sessionstate != "spectator")
	{
		wait(0.1);
	}
}

/*
	Name: on_maze_cell_enter
	Namespace: zm_temple_traps
	Checksum: 0x1F8ABC2B
	Offset: 0x3BC8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function on_maze_cell_enter()
{
	current = self;
	previous = current cell_get_previous();
	next = current cell_get_next();
	raise_floor(previous);
	raise_floor(current);
	raise_floor(next);
	activate_walls(previous);
	activate_walls(current);
	activate_walls(next);
}

/*
	Name: on_maze_cell_exit
	Namespace: zm_temple_traps
	Checksum: 0xDB8309E9
	Offset: 0x3CB8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function on_maze_cell_exit()
{
	current = self;
	previous = current cell_get_previous();
	next = current cell_get_next();
	lower_floor(previous);
	lower_floor(current);
	lower_floor(next);
	lower_walls(previous);
	lower_walls(current);
	lower_walls(next);
}

/*
	Name: watch_slow_trigger_exit
	Namespace: zm_temple_traps
	Checksum: 0x105359C1
	Offset: 0x3DA8
	Size: 0x234
	Parameters: 1
	Flags: Linked
*/
function watch_slow_trigger_exit(player)
{
	player endon(#"death");
	player endon(#"fake_death");
	player endon(#"disconnect");
	player allowjump(0);
	if(isdefined(player.mazeslowtrigger))
	{
		if(is_in_array(player.mazeslowtrigger, self))
		{
			return;
		}
	}
	else
	{
		player.mazeslowtrigger = [];
	}
	if(!player is_player_maze_slow())
	{
		player allowsprint(0);
		player allowprone(0);
		player allowslide(0);
		player setmovespeedscale(0.35);
	}
	player.mazeslowtrigger[player.mazeslowtrigger.size] = self;
	while(self.pathcount == 0 && player istouching(self))
	{
		wait(0.1);
	}
	arrayremovevalue(player.mazeslowtrigger, self);
	if(!player is_player_maze_slow())
	{
		player allowjump(1);
		player allowsprint(1);
		player allowprone(1);
		player allowslide(1);
		player setmovespeedscale(1);
	}
}

/*
	Name: lower_walls
	Namespace: zm_temple_traps
	Checksum: 0xA8632B77
	Offset: 0x3FE8
	Size: 0x86
	Parameters: 1
	Flags: Linked
*/
function lower_walls(cell)
{
	if(!isdefined(cell))
	{
		return;
	}
	for(i = 0; i < cell.walls.size; i++)
	{
		wall = cell.walls[i];
		wall thread maze_mover_active(0);
	}
}

/*
	Name: activate_walls
	Namespace: zm_temple_traps
	Checksum: 0x72F22D4E
	Offset: 0x4078
	Size: 0x1AE
	Parameters: 1
	Flags: Linked
*/
function activate_walls(cell)
{
	if(!isdefined(cell))
	{
		return;
	}
	previous = cell cell_get_previous();
	next = cell cell_get_next();
	previoussharedwall = maze_cells_get_shared_wall(previous, cell);
	nextsharedwall = maze_cells_get_shared_wall(cell, next);
	for(i = 0; i < cell.walls.size; i++)
	{
		wall = cell.walls[i];
		activatewall = 1;
		if(isdefined(previoussharedwall) && wall == previoussharedwall || (isdefined(nextsharedwall) && wall == nextsharedwall) || (!isdefined(previous) && wall.adjacentcells.size == 1) || (!isdefined(next) && wall.adjacentcells.size == 1))
		{
			activatewall = 0;
		}
		wall thread maze_mover_active(activatewall);
	}
}

/*
	Name: raise_floor
	Namespace: zm_temple_traps
	Checksum: 0xDF1965BE
	Offset: 0x4230
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function raise_floor(mazecell)
{
	if(isdefined(mazecell))
	{
		mazecell.trigger.pathcount++;
		mazecell.floor thread maze_mover_active(1);
		level thread delete_cell_corpses(mazecell);
	}
}

/*
	Name: delete_cell_corpses
	Namespace: zm_temple_traps
	Checksum: 0xCA66184B
	Offset: 0x42A0
	Size: 0xEE
	Parameters: 1
	Flags: Linked
*/
function delete_cell_corpses(mazecell)
{
	bodies = getcorpsearray();
	for(i = 0; i < bodies.size; i++)
	{
		if(!isdefined(bodies[i]))
		{
			continue;
		}
		if(bodies[i] istouching(mazecell.trigger) || bodies[i] istouching(mazecell.floor))
		{
			bodies[i] thread delete_corpse();
			util::wait_network_frame();
		}
	}
}

/*
	Name: delete_corpse
	Namespace: zm_temple_traps
	Checksum: 0x204A83FF
	Offset: 0x4398
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function delete_corpse()
{
	self endon(#"death");
	playfx(level._effect["animscript_gib_fx"], self.origin);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: lower_floor
	Namespace: zm_temple_traps
	Checksum: 0xD4AE6023
	Offset: 0x4400
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function lower_floor(mazecell)
{
	if(isdefined(mazecell))
	{
		mazecell.trigger.pathcount--;
		mazecell.floor thread maze_mover_active(0);
	}
}

/*
	Name: maze_cells_get_shared_wall
	Namespace: zm_temple_traps
	Checksum: 0x5EA5E89A
	Offset: 0x4458
	Size: 0xD8
	Parameters: 2
	Flags: Linked
*/
function maze_cells_get_shared_wall(a, b)
{
	if(!isdefined(a) || !isdefined(b))
	{
		return undefined;
	}
	for(i = 0; i < a.walls.size; i++)
	{
		for(j = 0; j < b.walls.size; j++)
		{
			if(a.walls[i] == b.walls[j])
			{
				return a.walls[i];
			}
		}
	}
	return undefined;
}

/*
	Name: maze_show_starts
	Namespace: zm_temple_traps
	Checksum: 0x40273D55
	Offset: 0x4538
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function maze_show_starts()
{
	for(i = 0; i < level.startcells.size; i++)
	{
		raise_floor(level.startcells[i]);
	}
}

/*
	Name: maze_start_path
	Namespace: zm_temple_traps
	Checksum: 0x3FF346C7
	Offset: 0x4590
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function maze_start_path()
{
	level.pathactive = 1;
	for(i = 0; i < level.startcells.size; i++)
	{
		lower_floor(level.startcells[i]);
	}
	self maze_generate_path();
	level thread maze_path_timer(10);
}

/*
	Name: maze_end_path
	Namespace: zm_temple_traps
	Checksum: 0x44BC1800
	Offset: 0x4628
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function maze_end_path()
{
	level notify(#"maze_path_end");
	level.pathactive = 0;
	level thread maze_show_starts_delayed();
}

/*
	Name: maze_show_starts_delayed
	Namespace: zm_temple_traps
	Checksum: 0x5641CFFB
	Offset: 0x4668
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function maze_show_starts_delayed()
{
	level endon(#"maze_all_safe");
	wait(3);
	maze_show_starts();
}

/*
	Name: maze_path_timer
	Namespace: zm_temple_traps
	Checksum: 0x7AB7CB61
	Offset: 0x4698
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function maze_path_timer(time)
{
	level endon(#"maze_path_end");
	level endon(#"maze_all_safe");
	vibratetime = 3;
	wait(time - vibratetime);
	level thread maze_vibrate_floor_stop();
	level thread maze_vibrate_active_floors(vibratetime);
	wait(vibratetime);
	level notify(#"maze_timer_end");
	level thread repath_zombies_in_maze();
}

/*
	Name: repath_zombies_in_maze
	Namespace: zm_temple_traps
	Checksum: 0xDBD45999
	Offset: 0x4738
	Size: 0x12A
	Parameters: 0
	Flags: Linked
*/
function repath_zombies_in_maze()
{
	util::wait_network_frame();
	zombies = getaiteamarray(level.zombie_team);
	for(i = 0; i < zombies.size; i++)
	{
		zombie = zombies[i];
		if(!isdefined(zombie))
		{
			continue;
		}
		if(!isdefined(zombie.animname) || zombie.animname == "monkey_zombie")
		{
			continue;
		}
		if(zombie zombie_on_path() || zombie zombie_on_mud())
		{
			zombie notify(#"stop_find_flesh");
			zombie notify(#"zombie_acquire_enemy");
			util::wait_network_frame();
			zombie.ai_state = "find_flesh";
		}
	}
}

/*
	Name: maze_vibrate_active_floors
	Namespace: zm_temple_traps
	Checksum: 0x91B2B69B
	Offset: 0x4870
	Size: 0x19C
	Parameters: 1
	Flags: Linked
*/
function maze_vibrate_active_floors(time)
{
	level endon(#"maze_path_end");
	level endon(#"maze_all_safe");
	endtime = gettime() + (time * 1000);
	while(endtime > gettime())
	{
		for(i = 0; i < level.mazecells.size; i++)
		{
			cell = level.mazecells[i];
			if(cell.floor.isactive)
			{
				cell thread maze_vibrate_floor((endtime - gettime()) / 1000);
				players = getplayers();
				for(w = 0; w < players.size; w++)
				{
					if(players[w] istouching(cell.trigger))
					{
						cell.trigger thread trigger::function_d1278be0(players[w], &temple_maze_player_vibrate_on, &temple_maze_player_vibrate_off);
					}
				}
			}
		}
		wait(0.1);
	}
}

/*
	Name: temple_maze_player_vibrate_on
	Namespace: zm_temple_traps
	Checksum: 0xF621A88E
	Offset: 0x4A18
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function temple_maze_player_vibrate_on(player, endon_condition)
{
	if(isdefined(endon_condition))
	{
		player endon(endon_condition);
	}
	player clientfield::set_to_player("floorrumble", 1);
	util::wait_network_frame();
	self thread temple_inactive_floor_rumble_cancel(player);
}

/*
	Name: temple_maze_player_vibrate_off
	Namespace: zm_temple_traps
	Checksum: 0xE4646F47
	Offset: 0x4A98
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function temple_maze_player_vibrate_off(player)
{
	player endon(#"frc");
	player clientfield::set_to_player("floorrumble", 0);
	player notify(#"frc");
}

/*
	Name: temple_inactive_floor_rumble_cancel
	Namespace: zm_temple_traps
	Checksum: 0x917F4BD2
	Offset: 0x4AE8
	Size: 0x11C
	Parameters: 1
	Flags: Linked
*/
function temple_inactive_floor_rumble_cancel(ent_player)
{
	ent_player endon(#"frc");
	floor_piece = undefined;
	maze_floor_array = getentarray("maze_floor", "targetname");
	for(i = 0; i < maze_floor_array.size; i++)
	{
		if(maze_floor_array[i].script_int == self.script_int)
		{
			floor_piece = maze_floor_array[i];
		}
	}
	while(isdefined(floor_piece) && floor_piece.isactive == 1)
	{
		wait(0.05);
	}
	if(isdefined(ent_player))
	{
		ent_player clientfield::set_to_player("floorrumble", 0);
	}
	ent_player notify(#"frc");
}

/*
	Name: maze_vibrate_floor
	Namespace: zm_temple_traps
	Checksum: 0xFB5A4B6F
	Offset: 0x4C10
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function maze_vibrate_floor(time)
{
	if(isdefined(self.isvibrating) && self.isvibrating)
	{
		return;
	}
	self.floor playsound("evt_maze_floor_collapse");
	self.isvibrating = 1;
	dir = (randomfloatrange(-1, 1), randomfloatrange(-1, 1), 0);
	self.floor vibrate(dir, 0.75, 0.3, time);
	wait(time);
	self.isvibrating = 0;
}

/*
	Name: maze_vibrate_floor_stop
	Namespace: zm_temple_traps
	Checksum: 0x84AD0F6B
	Offset: 0x4CF0
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function maze_vibrate_floor_stop()
{
	level util::waittill_any("maze_path_end", "maze_timer_end", "maze_all_safe");
	for(i = 0; i < level.mazecells.size; i++)
	{
		cell = level.mazecells[i];
		if(isdefined(cell.isvibrating) && cell.isvibrating)
		{
			cell.floor vibrate((0, 0, 1), 1, 1, 0.05);
			cell.floor rotateto(cell.floor.startangles, 0.1);
			cell.floor stopsounds();
		}
	}
}

/*
	Name: maze_generate_path
	Namespace: zm_temple_traps
	Checksum: 0xA5545057
	Offset: 0x4E20
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function maze_generate_path()
{
	level.mazepath = [];
	for(i = 0; i < level.mazecells.size; i++)
	{
		level.mazecells[i].pathindex = -1;
	}
	path_index = self pick_random_path_index();
	path = level.mazepaths[path_index].path;
	level.mazepathlaststart = path[0];
	level.mazepathlastend = path[path.size - 1];
	for(i = 0; i < path.size; i++)
	{
		level.mazepath[i] = level.mazecells[path[i]];
		level.mazepath[i].pathindex = i;
	}
	level.mazepathcounter++;
}

/*
	Name: pick_random_path_index
	Namespace: zm_temple_traps
	Checksum: 0x5769542E
	Offset: 0x4F60
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function pick_random_path_index()
{
	startindex = 0;
	for(i = 0; i < level.mazecells.size; i++)
	{
		if(level.mazecells[i] == self)
		{
			startindex = i;
			break;
		}
	}
	path_indexes = [];
	for(i = 0; i < level.mazepaths.size; i++)
	{
		path_indexes[i] = i;
	}
	path_indexes = array::randomize(path_indexes);
	returnindex = -1;
	for(i = 0; i < path_indexes.size; i++)
	{
		index = path_indexes[i];
		path = level.mazepaths[index].path;
		if(level.mazepaths[index].loopback)
		{
			if(level.mazepathcounter < 3)
			{
				continue;
			}
			if(randomfloat(100) > 40)
			{
				continue;
			}
		}
		if(isdefined(level.mazepathlaststart) && isdefined(level.mazepathlastend))
		{
			if(level.mazepathlaststart == path[0] && level.mazepathlastend == (path[path.size - 1]))
			{
				continue;
			}
		}
		if(startindex == path[0])
		{
			returnindex = index;
			break;
		}
	}
	return returnindex;
}

/*
	Name: cell_get_next
	Namespace: zm_temple_traps
	Checksum: 0x2ACCA835
	Offset: 0x5160
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function cell_get_next()
{
	index = self.pathindex;
	if(index < (level.mazepath.size - 1))
	{
		return level.mazepath[index + 1];
	}
	return undefined;
}

/*
	Name: cell_get_previous
	Namespace: zm_temple_traps
	Checksum: 0x5DD35934
	Offset: 0x51B0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function cell_get_previous()
{
	index = self.pathindex;
	if(index > 0)
	{
		return level.mazepath[index - 1];
	}
	return undefined;
}

/*
	Name: zombie_waterfall_knockdown
	Namespace: zm_temple_traps
	Checksum: 0x8DEEEEEA
	Offset: 0x51F8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function zombie_waterfall_knockdown(entity)
{
	self endon(#"death");
	self.lander_knockdown = 1;
	wait(1.25);
	self zombie_utility::setup_zombie_knockdown(entity);
}

/*
	Name: override_thundergun_damage_func
	Namespace: zm_temple_traps
	Checksum: 0x3A438BC1
	Offset: 0x5248
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function override_thundergun_damage_func(player, gib)
{
	dmg_point = struct::get("waterfall_dmg_point", "script_noteworthy");
	self.thundergun_handle_pain_notetracks = &handle_knockdown_pain_notetracks;
	self dodamage(1, dmg_point.origin);
	self animcustom(&zm_weap_thundergun::playthundergunpainanim);
}

/*
	Name: handle_knockdown_pain_notetracks
	Namespace: zm_temple_traps
	Checksum: 0x3D0337CF
	Offset: 0x52F0
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function handle_knockdown_pain_notetracks(note)
{
}

