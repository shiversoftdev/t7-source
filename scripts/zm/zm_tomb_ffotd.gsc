// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;

#namespace zm_tomb_ffotd;

/*
	Name: main_start
	Namespace: zm_tomb_ffotd
	Checksum: 0xC534AC31
	Offset: 0x288
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function main_start()
{
	level.added_initial_streamer_blackscreen = 2;
	level thread spawned_collision_ffotd();
	level thread function_3fd88dcb();
	level.var_361ee139 = &function_acf1c4da;
}

/*
	Name: main_end
	Namespace: zm_tomb_ffotd
	Checksum: 0xB037E1
	Offset: 0x2F0
	Size: 0x2C8
	Parameters: 0
	Flags: Linked
*/
function main_end()
{
	spawncollision("collision_player_256x256x256", "collider", (11200, -6722, -132), (0, 0, 0));
	spawncollision("collision_player_wall_256x256x10", "collider", (-339.75, 83, 448), (0, 0, 0));
	spawncollision("collision_player_cylinder_32x256", "collider", (167, 404, 442), (0, 0, 0));
	spawncollision("collision_player_wall_256x256x10", "collider", (55, 391, 450), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_wall_256x256x10", "collider", (70.75, -379, 555), vectorscale((0, 1, 0), 270));
	spawncollision("collision_player_wall_256x256x10", "collider", (-130.25, -356.5, 545.25), vectorscale((0, 1, 0), 180));
	spawncollision("collision_player_wedge_32x256", "collider", (2196.91, -634.245, 224), vectorscale((0, 1, 0), 289.698));
	level.var_144b78ee = spawncollision("collision_player_wedge_32x256", "collider", (-2148.74, 571, 237.5), vectorscale((0, 1, 0), 7.6));
	t_killbrush_1 = spawn("trigger_box", (54.5, -372.5, 130.5), 0, 350, 100, 250);
	t_killbrush_1.angles = (0, 0, 0);
	t_killbrush_1.script_noteworthy = "kill_brush";
	t_killbrush_2 = spawn("trigger_box", (83, 387, 130.5), 0, 300, 100, 250);
	t_killbrush_2.angles = (0, 0, 0);
	t_killbrush_2.script_noteworthy = "kill_brush";
}

/*
	Name: function_3fd88dcb
	Namespace: zm_tomb_ffotd
	Checksum: 0xE185E6D1
	Offset: 0x5C0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_3fd88dcb()
{
	level flagsys::wait_till("start_zombie_round_logic");
	level flag::wait_till("activate_zone_farm");
	if(isdefined(level.var_144b78ee))
	{
		level.var_144b78ee delete();
	}
}

/*
	Name: spawned_collision_ffotd
	Namespace: zm_tomb_ffotd
	Checksum: 0xEC082254
	Offset: 0x638
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function spawned_collision_ffotd()
{
	level flagsys::wait_till("start_zombie_round_logic");
}

/*
	Name: function_acf1c4da
	Namespace: zm_tomb_ffotd
	Checksum: 0xA526D938
	Offset: 0x680
	Size: 0xEC
	Parameters: 1
	Flags: Linked
*/
function function_acf1c4da(machine)
{
	if(isdefined(level.bgb[machine.selected_bgb]) && level.bgb[machine.selected_bgb].limit_type == "activated")
	{
		if(self.characterindex == 0)
		{
			self zm_audio::create_and_play_dialog("bgb", "buy", self function_af29034());
			return;
		}
		self zm_audio::create_and_play_dialog("bgb", "buy");
	}
	else
	{
		self zm_audio::create_and_play_dialog("bgb", "eat");
	}
}

/*
	Name: function_af29034
	Namespace: zm_tomb_ffotd
	Checksum: 0xA658742C
	Offset: 0x778
	Size: 0xB0
	Parameters: 0
	Flags: Linked
*/
function function_af29034()
{
	if(!isdefined(self.var_52b965ea) || self.var_52b965ea.size <= 0)
	{
		self.var_52b965ea = array(0, 1, 2, 3);
		self.var_52b965ea = array::randomize(self.var_52b965ea);
	}
	var_1b07cebe = self.var_52b965ea[0];
	self.var_52b965ea = array::remove_index(self.var_52b965ea, 0);
	return var_1b07cebe;
}

