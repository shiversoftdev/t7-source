// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_ai_monkey;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_cosmodrome_ai_monkey;

/*
	Name: init
	Namespace: zm_cosmodrome_ai_monkey
	Checksum: 0x889D33BC
	Offset: 0x1F8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.monkey_zombie_enter_level = &monkey_cosmodrome_enter_level;
}

/*
	Name: monkey_cosmodrome_enter_level
	Namespace: zm_cosmodrome_ai_monkey
	Checksum: 0x6E75E3CE
	Offset: 0x220
	Size: 0x27C
	Parameters: 0
	Flags: Linked
*/
function monkey_cosmodrome_enter_level()
{
	self endon(#"death");
	end = self monkey_lander_get_closest_dest();
	end_launch = struct::get(end.target, "targetname");
	start_launch = end_launch.origin + vectorscale((0, 0, 1), 2000);
	lander = spawn("script_model", start_launch);
	angles = vectortoangles(end.origin - start_launch);
	lander.angles = angles;
	lander setmodel("p7_fxanim_zm_asc_lander_crash_mod");
	lander hide();
	lander thread clear_lander();
	self hide();
	util::wait_network_frame();
	lander clientfield::set("COSMO_MONKEY_LANDER_FX", 1);
	self forceteleport(lander.origin);
	self linkto(lander);
	wait(2.5);
	lander show();
	lander moveto(end.origin, 0.6);
	lander waittill(#"movedone");
	lander clientfield::set("COSMO_MONKEY_LANDER_FX", 0);
	wait(2);
	self unlink();
	self show();
}

/*
	Name: clear_lander
	Namespace: zm_cosmodrome_ai_monkey
	Checksum: 0x9CE6AF15
	Offset: 0x4A8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function clear_lander()
{
	wait(8);
	self movez(-100, 0.5);
	self waittill(#"movedone");
	self delete();
}

/*
	Name: monkey_lander_get_closest_dest
	Namespace: zm_cosmodrome_ai_monkey
	Checksum: 0xB076B3AD
	Offset: 0x500
	Size: 0x1D2
	Parameters: 0
	Flags: Linked
*/
function monkey_lander_get_closest_dest()
{
	if(!isdefined(level._lander_endarray))
	{
		level._lander_endarray = [];
	}
	if(!isdefined(level._lander_endarray[self.script_noteworthy]))
	{
		level._lander_endarray[self.script_noteworthy] = [];
		end_spots = struct::get_array("monkey_land", "targetname");
		for(i = 0; i < end_spots.size; i++)
		{
			if(self.script_noteworthy == end_spots[i].script_noteworthy)
			{
				level._lander_endarray[self.script_noteworthy][level._lander_endarray[self.script_noteworthy].size] = end_spots[i];
			}
		}
	}
	choice = level._lander_endarray[self.script_noteworthy][0];
	max_dist = 1410065408;
	for(i = 0; i < level._lander_endarray[self.script_noteworthy].size; i++)
	{
		dist = distance2d(self.origin, level._lander_endarray[self.script_noteworthy][i].origin);
		if(dist < max_dist)
		{
			max_dist = dist;
			choice = level._lander_endarray[self.script_noteworthy][i];
		}
	}
	return choice;
}

/*
	Name: monkey_cosmodrome_prespawn
	Namespace: zm_cosmodrome_ai_monkey
	Checksum: 0x95D900D3
	Offset: 0x6E0
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function monkey_cosmodrome_prespawn()
{
	self.lander_death = &monkey_cosmodrome_lander_death;
}

/*
	Name: monkey_cosmodrome_failsafe
	Namespace: zm_cosmodrome_ai_monkey
	Checksum: 0xC9ABFFA7
	Offset: 0x708
	Size: 0xA4
	Parameters: 0
	Flags: None
*/
function monkey_cosmodrome_failsafe()
{
	self endon(#"death");
	while(true)
	{
		if(self.state != "bhb_jump")
		{
			if(!zm_utility::check_point_in_playable_area(self.origin))
			{
				break;
			}
		}
		wait(1);
	}
	/#
		assertmsg("" + self.origin);
	#/
	self dodamage(self.health + 100, self.origin);
}

/*
	Name: monkey_cosmodrome_lander_death
	Namespace: zm_cosmodrome_ai_monkey
	Checksum: 0xD83ED238
	Offset: 0x7B8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function monkey_cosmodrome_lander_death()
{
	self zombie_utility::reset_attack_spot();
	self thread zombie_utility::zombie_eye_glow_stop();
	level.monkey_death++;
	level.monkey_death_total++;
	self zm_ai_monkey::monkey_remove_from_pack();
	util::wait_network_frame();
}

