// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_weap_shrink_ray;
#using scripts\zm\zm_temple_sq;
#using scripts\zm\zm_temple_sq_brock;
#using scripts\zm\zm_temple_sq_skits;

#using_animtree("generic");

#namespace zm_temple_sq_lgs;

/*
	Name: init
	Namespace: zm_temple_sq_lgs
	Checksum: 0x80503B50
	Offset: 0x530
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level flag::init("meteor_impact");
	zm_sidequests::declare_sidequest_stage("sq", "LGS", &init_stage, &stage_logic, &exit_stage);
	zm_sidequests::set_stage_time_limit("sq", "LGS", 300);
	zm_sidequests::declare_stage_asset_from_struct("sq", "LGS", "sq_lgs_crystal", &lgs_crystal);
}

/*
	Name: init_stage
	Namespace: zm_temple_sq_lgs
	Checksum: 0xCE6E87EF
	Offset: 0x610
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function init_stage()
{
	zm_temple_sq_brock::delete_radio();
	level flag::clear("meteor_impact");
	level thread lgs_intro();
	/#
		if(getplayers().size == 1)
		{
			getplayers()[0] giveweapon(level.w_shrink_ray_upgraded);
		}
	#/
}

/*
	Name: lgs_intro
	Namespace: zm_temple_sq_lgs
	Checksum: 0x10A7C695
	Offset: 0x6B8
	Size: 0x104
	Parameters: 0
	Flags: Linked
*/
function lgs_intro()
{
	exploder::exploder("fxexp_600");
	wait(4);
	level thread play_intro_audio();
	exploder::exploder("fxexp_601");
	level thread zm_temple_sq_skits::start_skit("tt3");
	level thread play_nikolai_farting();
	wait(2);
	wait(1.5);
	earthquake(1, 0.8, getplayers()[0].origin, 200);
	wait(1);
	level flag::set("meteor_impact");
}

/*
	Name: play_nikolai_farting
	Namespace: zm_temple_sq_lgs
	Checksum: 0x92D0F2E8
	Offset: 0x7C8
	Size: 0xA0
	Parameters: 0
	Flags: Linked
*/
function play_nikolai_farting()
{
	level endon(#"sq_lgs_over");
	wait(2);
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		if(players[i].characterindex == 1)
		{
			players[i] playsound("evt_sq_lgs_fart");
			return;
		}
	}
}

/*
	Name: play_intro_audio
	Namespace: zm_temple_sq_lgs
	Checksum: 0xD339E6DE
	Offset: 0x870
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function play_intro_audio()
{
	playsoundatposition("evt_sq_lgs_meteor_incoming", (-1680, -780, 147));
	wait(3.3);
	playsoundatposition("evt_sq_lgs_meteor_impact", (-1229, -1642, 198));
}

/*
	Name: first_damage
	Namespace: zm_temple_sq_lgs
	Checksum: 0x7880C66D
	Offset: 0x8D8
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function first_damage()
{
	self endon(#"death");
	self endon(#"first_damage_done");
	while(true)
	{
		self waittill(#"damage", amount, attacker, direction, point, dmg_type, modelname, tagname);
		if(isplayer(attacker) && (dmg_type == "MOD_PROJECTILE" || dmg_type == "MOD_PROJECTILE_SPLASH" || dmg_type == "MOD_EXPLOSIVE" || dmg_type == "MOD_EXPLOSIVE_SPLASH" || dmg_type == "MOD_GRENADE" || dmg_type == "MOD_GRENADE_SPLASH"))
		{
			self.owner_ent notify(#"triggered");
			attacker thread zm_audio::create_and_play_dialog("eggs", "quest3", 1);
			return;
		}
		if(isplayer(attacker))
		{
			attacker thread zm_audio::create_and_play_dialog("eggs", "quest3", 2);
		}
	}
}

/*
	Name: wait_for_player_to_get_close
	Namespace: zm_temple_sq_lgs
	Checksum: 0xE0A5BDC8
	Offset: 0xA60
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function wait_for_player_to_get_close()
{
	self endon(#"death");
	self endon(#"first_damage_done");
	while(true)
	{
		players = getplayers();
		for(i = 0; i < players.size; i++)
		{
			if(distancesquared(self.origin, players[i].origin) <= 250000)
			{
				players[i] thread zm_audio::create_and_play_dialog("eggs", "quest3", 0);
				return;
			}
		}
		wait(0.1);
	}
}

/*
	Name: report_melee_early
	Namespace: zm_temple_sq_lgs
	Checksum: 0x42980918
	Offset: 0xB48
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function report_melee_early()
{
	self endon(#"death");
	self endon(#"shrunk");
	while(true)
	{
		self waittill(#"damage", amount, attacker, direction, point, dmg_type, modelname, tagname);
		if(isplayer(attacker) && dmg_type == "MOD_MELEE")
		{
			attacker thread zm_audio::create_and_play_dialog("eggs", "quest3", 3);
			wait(5);
		}
	}
}

/*
	Name: wait_for_melee
	Namespace: zm_temple_sq_lgs
	Checksum: 0x6F99D187
	Offset: 0xC38
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function wait_for_melee()
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage", amount, attacker, direction, point, dmg_type, modelname, tagname);
		if(isplayer(attacker) && dmg_type == "MOD_MELEE")
		{
			self.owner_ent notify(#"triggered");
			attacker thread zm_audio::create_and_play_dialog("eggs", "quest3", 6);
			return;
		}
	}
}

/*
	Name: check_for_closed_slide
	Namespace: zm_temple_sq_lgs
	Checksum: 0x3C212C22
	Offset: 0xD28
	Size: 0x23A
	Parameters: 1
	Flags: Linked
*/
function check_for_closed_slide(ent)
{
	if(!level flag::get("waterslide_open"))
	{
		self endon(#"death");
		self endon(#"reached_end_node");
		while(true)
		{
			self waittill(#"reached_node", node);
			if(isdefined(node.script_noteworthy) && node.script_noteworthy == "pre_gate")
			{
				if(!level flag::get("waterslide_open"))
				{
					players = getplayers();
					for(i = 0; i < players.size; i++)
					{
						if(distancesquared(self.origin, players[i].origin) <= 250000)
						{
							players[i] thread zm_audio::create_and_play_dialog("eggs", "quest3", 7);
						}
					}
					self._crystal stopanimscripted();
					while(!level flag::get("waterslide_open"))
					{
						self setspeedimmediate(0);
						wait(0.05);
					}
					wait(0.5);
					self._crystal animscripted("spin", self._crystal.origin, self._crystal.angles, "p7_fxanim_zm_sha_crystal_sml_anim");
					self resumespeed(12);
					return;
				}
			}
		}
	}
}

/*
	Name: water_trail
	Namespace: zm_temple_sq_lgs
	Checksum: 0x6D34D502
	Offset: 0xF70
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function water_trail(ent)
{
	self endon(#"death");
	while(true)
	{
		self waittill(#"reached_node", node);
		if(isdefined(node.script_int))
		{
			if(node.script_int == 1)
			{
				ent clientfield::set("watertrail", 1);
			}
			else if(node.script_int == 0)
			{
				ent clientfield::set("watertrail", 0);
			}
		}
	}
}

/*
	Name: function_c7e74d12
	Namespace: zm_temple_sq_lgs
	Checksum: 0x3672C023
	Offset: 0x1038
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_c7e74d12()
{
	self endon(#"triggered");
	level endon(#"end_game");
	exploder::exploder("fxexp_602");
	level util::waittill_any("sq_lgs_over", "sq_lgs_failed");
	exploder::stop_exploder("fxexp_602");
}

/*
	Name: lgs_crystal
	Namespace: zm_temple_sq_lgs
	Checksum: 0x4E25620
	Offset: 0x10B8
	Size: 0xB0C
	Parameters: 0
	Flags: Linked
*/
function lgs_crystal()
{
	self endon(#"death");
	self ghost();
	self.trigger = getent("sq_lgs_crystal_trig", "targetname");
	self.trigger.var_b82c7478 = 1;
	self.trigger.origin = self.origin;
	self.trigger.var_d5784b10 = self.trigger.origin;
	self.trigger.owner_ent = self;
	self.trigger notsolid();
	self.trigger.takedamage = 0;
	level flag::wait_till("meteor_impact");
	self show();
	self.trigger solid();
	self.trigger.takedamage = 1;
	self.trigger thread first_damage();
	self.trigger thread wait_for_player_to_get_close();
	self thread function_c7e74d12();
	self waittill(#"triggered");
	self.trigger notify(#"first_damage_done");
	exploder::stop_exploder("fxexp_602");
	self playsound("evt_sq_lgs_crystal_pry");
	target = self.target;
	while(isdefined(target))
	{
		struct = struct::get(target, "targetname");
		if(isdefined(struct.script_parameters))
		{
			time = float(struct.script_parameters);
		}
		else
		{
			time = 1;
		}
		self moveto(struct.origin, time, time / 10);
		self waittill(#"movedone");
		self playsound("evt_sq_lgs_crystal_hit1");
		target = struct.target;
	}
	self playsound("evt_sq_lgs_crystal_land");
	self.trigger.origin = self.origin;
	self.trigger thread report_melee_early();
	zm_weap_shrink_ray::add_shrinkable_object(self);
	self waittill(#"shrunk");
	players = getplayers();
	for(i = 0; i < players.size; i++)
	{
		currentweapon = players[i] getcurrentweapon();
		if(currentweapon == level.w_shrink_ray || currentweapon == level.w_shrink_ray_upgraded)
		{
			players[i] thread zm_audio::create_and_play_dialog("eggs", "quest3", 4);
		}
	}
	self playsound("evt_sq_lgs_crystal_shrink");
	self setmodel("p7_fxanim_zm_sha_crystal_sml_mod");
	vn = getvehiclenode("sq_lgs_node_start", "targetname");
	self.origin = vn.origin;
	self.trigger notify(#"shrunk");
	zm_weap_shrink_ray::remove_shrinkable_object(self);
	self.trigger thread wait_for_melee();
	self waittill(#"triggered");
	self playsound("evt_sq_lgs_crystal_knife");
	self playloopsound("evt_sq_lgs_crystal_roll", 2);
	self.trigger.origin = self.trigger.var_d5784b10;
	self.trigger notsolid();
	self.trigger.takedamage = 0;
	self notsolid();
	self useanimtree($generic);
	self.animname = "crystal";
	vehicle = getent("crystal_mover", "targetname");
	vehicle.origin = self.origin;
	vehicle.angles = self.angles;
	vehicle._crystal = self;
	level._lgs_veh = vehicle;
	util::wait_network_frame();
	origin_animate = util::spawn_model("tag_origin_animate", vehicle.origin);
	self linkto(origin_animate, "origin_animate_jnt", (0, 0, 0), vectorscale((1, 0, 0), 90));
	origin_animate linkto(vehicle);
	self animscripted("spin", self.origin, self.angles, "p7_fxanim_zm_sha_crystal_sml_anim");
	vehicle vehicle::get_on_and_go_path("sq_lgs_node_start");
	vehicle._origin_animate = origin_animate;
	vehicle thread water_trail(self);
	vehicle thread check_for_closed_slide(self);
	vehicle waittill(#"reached_end_node");
	self stopanimscripted();
	self unlink();
	self stoploopsound();
	self playsound("evt_sq_lgs_crystal_land_2");
	vehicle delete();
	origin_animate delete();
	self thread crystal_bobble();
	level flag::wait_till("minecart_geyser_active");
	self notify(#"kill_bobble");
	self clientfield::set("watertrail", 1);
	self moveto(self.origin + vectorscale((0, 0, 1), 4000), 2, 0.1);
	level notify(#"suspend_timer");
	level notify(#"raise_crystal_1");
	level notify(#"raise_crystal_2");
	level notify(#"raise_crystal_3", 1);
	level waittill(#"hash_18e4f2bc");
	self clientfield::set("watertrail", 0);
	wait(2);
	holder = getent("empty_holder", "script_noteworthy");
	self.origin = (holder.origin[0], holder.origin[1], self.origin[2]);
	self setmodel("p7_zm_sha_crystal");
	playsoundatposition("evt_sq_lgs_crystal_incoming", (holder.origin[0], holder.origin[1], holder.origin[2] + 134));
	self moveto((holder.origin[0], holder.origin[1], holder.origin[2] + 134), 2);
	self waittill(#"movedone");
	self playsound("evt_sq_lgs_crystal_landinholder");
	players = getplayers();
	players[randomintrange(0, players.size)] thread zm_audio::create_and_play_dialog("eggs", "quest3", 8);
	level notify(#"crystal_dropped");
	self ghost();
	wait(5);
	zm_sidequests::stage_completed("sq", "LGS");
}

/*
	Name: crystal_spin
	Namespace: zm_temple_sq_lgs
	Checksum: 0x9486057B
	Offset: 0x1BD0
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function crystal_spin()
{
	self endon(#"death");
	self endon(#"kill_bobble");
	while(true)
	{
		t = randomfloatrange(0.2, 0.8);
		self rotateto((180 + randomfloat(180), 300 + randomfloat(60), 180 + randomfloat(180)), t);
		wait(t);
	}
}

/*
	Name: crystal_bobble
	Namespace: zm_temple_sq_lgs
	Checksum: 0x43E7B0C7
	Offset: 0x1CA0
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function crystal_bobble()
{
	self endon(#"death");
	self endon(#"kill_bobble");
	self thread crystal_spin();
	node = getvehiclenode("crystal_end", "script_noteworthy");
	bottom_pos = node.origin + vectorscale((0, 0, 1), 4);
	top_pos = bottom_pos + vectorscale((0, 0, 1), 3);
	while(true)
	{
		self moveto(top_pos + (0, 0, randomfloat(3)), 0.2 + randomfloat(0.1), 0.1);
		self waittill(#"movedone");
		self moveto(bottom_pos + (0, 0, randomfloat(5)), 0.05 + randomfloat(0.07), 0, 0.03);
		self waittill(#"movedone");
	}
}

/*
	Name: stage_logic
	Namespace: zm_temple_sq_lgs
	Checksum: 0x99EC1590
	Offset: 0x1E28
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function stage_logic()
{
}

/*
	Name: exit_stage
	Namespace: zm_temple_sq_lgs
	Checksum: 0xF59F6B2F
	Offset: 0x1E38
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function exit_stage(success)
{
	if(isdefined(level._lgs_veh))
	{
		if(isdefined(level._lgs_veh._origin_animate))
		{
			level._lgs_veh._origin_animate delete();
		}
		level._lgs_veh delete();
	}
	level._lgs_veh = undefined;
	if(success)
	{
		zm_temple_sq_brock::create_radio(4, &zm_temple_sq_brock::radio4_override);
	}
	else
	{
		zm_temple_sq_brock::create_radio(3);
		level thread zm_temple_sq_skits::fail_skit();
	}
}

