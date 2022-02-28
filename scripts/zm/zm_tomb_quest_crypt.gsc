// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;
#using scripts\zm\zm_tomb_amb;
#using scripts\zm\zm_tomb_utility;
#using scripts\zm\zm_tomb_vo;

#using_animtree("generic");

#namespace zm_tomb_quest_crypt;

/*
	Name: main
	Namespace: zm_tomb_quest_crypt
	Checksum: 0xE8A89FE7
	Offset: 0x680
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function main()
{
	callback::on_connect(&on_player_connect_crypt);
	level flag::init("disc_rotation_active");
	level thread zm_tomb_vo::watch_one_shot_line("puzzle", "try_puzzle", "vo_try_puzzle_crypt");
	init_crypt_gems();
	chamber_disc_puzzle_init();
}

/*
	Name: on_player_connect_crypt
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x5059281B
	Offset: 0x720
	Size: 0xCA
	Parameters: 0
	Flags: Linked
*/
function on_player_connect_crypt()
{
	discs = getentarray("crypt_puzzle_disc", "script_noteworthy");
	foreach(disc in discs)
	{
		disc util::delay(0.5, undefined, &bryce_cake_light_update, 0);
	}
}

/*
	Name: chamber_disc_puzzle_init
	Namespace: zm_tomb_quest_crypt
	Checksum: 0xF521C73F
	Offset: 0x7F8
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function chamber_disc_puzzle_init()
{
	scene::add_scene_func("p7_fxanim_zm_ori_chamber_mid_ring_bundle", &function_746282b3, "init");
	level.gem_start_pos = [];
	level.gem_start_pos["crypt_gem_fire"] = 2;
	level.gem_start_pos["crypt_gem_air"] = 3;
	level.gem_start_pos["crypt_gem_ice"] = 0;
	level.gem_start_pos["crypt_gem_elec"] = 1;
	chamber_discs = getentarray("crypt_puzzle_disc", "script_noteworthy");
	array::thread_all(chamber_discs, &chamber_disc_run);
	level util::waittill_any("gramophone_vinyl_player_picked_up", "open_sesame", "open_all_gramophone_doors");
	chamber_discs_randomize();
}

/*
	Name: chamber_disc_run
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x6CDDBD4A
	Offset: 0x930
	Size: 0x2BC
	Parameters: 0
	Flags: Linked
*/
function chamber_disc_run()
{
	self.position = 0;
	if(!isdefined(level.var_6d86123b))
	{
		level.var_6d86123b = [];
	}
	level flag::wait_till("start_zombie_round_logic");
	self bryce_cake_light_update(0);
	if(isdefined(self.target))
	{
		a_levers = getentarray(self.target, "targetname");
		foreach(e_lever in a_levers)
		{
			e_lever.trigger_stub = zm_tomb_utility::tomb_spawn_trigger_radius(e_lever.origin, 100, 1);
			e_lever.trigger_stub.require_look_at = 0;
			clockwise = e_lever.script_string === "clockwise";
			e_lever.trigger_stub thread chamber_disc_trigger_run(self, e_lever, clockwise);
		}
		self thread chamber_disc_move_to_position();
	}
	self useanimtree($generic);
	if(!isdefined(self.script_int))
	{
		self animscripted("disc_idle", self.origin, self.angles, "p7_fxanim_zm_ori_chamber_mid_ring_idle_anim");
		return;
	}
	level.var_6d86123b[self.script_int] = self;
	n_wait = randomfloatrange(0, 5);
	wait(n_wait);
	self.v_start_origin = self.origin;
	self.v_start_angles = self.angles;
	wait(0.05);
	str_name = "fxanim_disc" + self.script_int;
	level scene::play(str_name, "targetname");
}

/*
	Name: function_746282b3
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x983B703D
	Offset: 0xBF8
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_746282b3(a_ents)
{
	var_4316fdf6 = a_ents["chamber_mid_ring"];
	switch(self.targetname)
	{
		case "fxanim_disc1":
		{
			n_index = 1;
			break;
		}
		case "fxanim_disc2":
		{
			n_index = 2;
			break;
		}
		case "fxanim_disc3":
		{
			n_index = 3;
			break;
		}
		case "fxanim_disc4":
		{
			n_index = 4;
			break;
		}
	}
	var_4316fdf6 linkto(level.var_6d86123b[n_index]);
	level.var_6d86123b[n_index].var_b1c02d8a = var_4316fdf6;
	wait(0.05);
	level.var_6d86123b[n_index] ghost();
}

/*
	Name: init_crypt_gems
	Namespace: zm_tomb_quest_crypt
	Checksum: 0xAA1ACF72
	Offset: 0xD10
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function init_crypt_gems()
{
	disc = getent("crypt_puzzle_disc_main", "targetname");
	gems = getentarray("crypt_gem", "script_noteworthy");
	foreach(gem in gems)
	{
		gem linkto(disc);
		gem thread run_crypt_gem_pos();
	}
}

/*
	Name: light_discs_bottom_to_top
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x7B6498EF
	Offset: 0xE20
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function light_discs_bottom_to_top()
{
	discs = getentarray("crypt_puzzle_disc", "script_noteworthy");
	for(i = 1; i <= 4; i++)
	{
		foreach(disc in discs)
		{
			if(disc.script_int === i)
			{
				disc bryce_cake_light_update(1);
				break;
			}
		}
		wait(1);
	}
}

/*
	Name: run_crypt_gem_pos
	Namespace: zm_tomb_quest_crypt
	Checksum: 0xBC46551B
	Offset: 0xF38
	Size: 0x7D4
	Parameters: 0
	Flags: Linked
*/
function run_crypt_gem_pos()
{
	str_weapon = undefined;
	complete_flag = undefined;
	str_orb_path = undefined;
	str_glow_fx = undefined;
	n_element = self.script_int;
	switch(self.targetname)
	{
		case "crypt_gem_air":
		{
			w_weapon = level.a_elemental_staffs["staff_air"].w_weapon;
			complete_flag = "staff_air_upgrade_unlocked";
			str_orb_path = "air_orb_exit_path";
			str_final_pos = "air_orb_plinth_final";
			break;
		}
		case "crypt_gem_ice":
		{
			w_weapon = level.a_elemental_staffs["staff_water"].w_weapon;
			complete_flag = "staff_water_upgrade_unlocked";
			str_orb_path = "ice_orb_exit_path";
			str_final_pos = "ice_orb_plinth_final";
			break;
		}
		case "crypt_gem_fire":
		{
			w_weapon = level.a_elemental_staffs["staff_fire"].w_weapon;
			complete_flag = "staff_fire_upgrade_unlocked";
			str_orb_path = "fire_orb_exit_path";
			str_final_pos = "fire_orb_plinth_final";
			break;
		}
		case "crypt_gem_elec":
		{
			w_weapon = level.a_elemental_staffs["staff_lightning"].w_weapon;
			complete_flag = "staff_lightning_upgrade_unlocked";
			str_orb_path = "lightning_orb_exit_path";
			str_final_pos = "lightning_orb_plinth_final";
			break;
		}
		default:
		{
			/#
				assertmsg("" + self.targetname);
			#/
			return;
		}
	}
	e_gem_model = zm_tomb_utility::puzzle_orb_chamber_to_crypt(str_orb_path, self);
	e_main_disc = getent("crypt_puzzle_disc_main", "targetname");
	e_gem_model linkto(e_main_disc);
	str_targetname = self.targetname;
	self delete();
	e_gem_model setcandamage(1);
	while(true)
	{
		e_gem_model waittill(#"damage", damage, attacker, direction_vec, point, mod, tagname, modelname, partname, weapon);
		if(weapon == w_weapon)
		{
			break;
		}
	}
	e_gem_model clientfield::set("element_glow_fx", n_element);
	e_gem_model playsound("zmb_squest_crystal_charge");
	e_gem_model playloopsound("zmb_squest_crystal_charge_loop", 2);
	while(true)
	{
		if(chamber_disc_gem_has_clearance(str_targetname))
		{
			break;
		}
		level waittill(#"crypt_disc_rotation");
	}
	level flag::set("disc_rotation_active");
	level thread zm_tomb_amb::sndplaystinger("side_sting_5");
	light_discs_bottom_to_top();
	level thread zm_tomb_utility::puzzle_orb_pillar_show();
	e_gem_model unlink();
	s_ascent = struct::get("orb_crypt_ascent_path", "targetname");
	v_next_pos = (e_gem_model.origin[0], e_gem_model.origin[1], s_ascent.origin[2]);
	e_gem_model clientfield::set("element_glow_fx", n_element);
	playfxontag(level._effect["puzzle_orb_trail"], e_gem_model, "tag_origin");
	e_gem_model playsound("zmb_squest_crystal_leave");
	e_gem_model zm_tomb_utility::puzzle_orb_move(v_next_pos);
	level flag::clear("disc_rotation_active");
	level thread chamber_discs_randomize();
	e_gem_model zm_tomb_utility::puzzle_orb_follow_path(s_ascent);
	v_next_pos = (e_gem_model.origin[0], e_gem_model.origin[1], e_gem_model.origin[2] + 2000);
	e_gem_model zm_tomb_utility::puzzle_orb_move(v_next_pos);
	s_chamber_path = struct::get(str_orb_path, "targetname");
	str_model = e_gem_model.model;
	e_gem_model delete();
	e_gem_model = zm_tomb_utility::puzzle_orb_follow_return_path(s_chamber_path, n_element);
	s_final = struct::get(str_final_pos, "targetname");
	e_gem_model zm_tomb_utility::puzzle_orb_move(s_final.origin);
	e_new_gem = spawn("script_model", s_final.origin);
	e_new_gem setmodel(e_gem_model.model);
	e_new_gem.script_int = n_element;
	e_new_gem clientfield::set("element_glow_fx", n_element);
	e_gem_model delete();
	e_new_gem playsound("zmb_squest_crystal_arrive");
	e_new_gem playloopsound("zmb_squest_crystal_charge_loop", 0.1);
	level flag::set(complete_flag);
}

/*
	Name: chamber_disc_move_to_position
	Namespace: zm_tomb_quest_crypt
	Checksum: 0xEA7C1173
	Offset: 0x1718
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function chamber_disc_move_to_position()
{
	new_angles = (self.angles[0], self.position * 90, self.angles[2]);
	self rotateto(new_angles, 1, 0, 0);
	self playsound("zmb_crypt_disc_turn");
	wait(1 * 0.75);
	self bryce_cake_light_update(0);
	wait(1 * 0.25);
	self bryce_cake_light_update(0);
	self playsound("zmb_crypt_disc_stop");
	zm_tomb_utility::rumble_nearby_players(self.origin, 1000, 2);
}

/*
	Name: chamber_discs_move_all_to_position
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x8C1C62AC
	Offset: 0x1840
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function chamber_discs_move_all_to_position(discs = getentarray("chamber_puzzle_disc", "script_noteworthy"))
{
	level flag::set("disc_rotation_active");
	foreach(e_disc in discs)
	{
		e_disc chamber_disc_move_to_position();
	}
	level flag::clear("disc_rotation_active");
}

/*
	Name: chamber_disc_get_gem_position
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x655D3709
	Offset: 0x1950
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function chamber_disc_get_gem_position(gem_name)
{
	disc = getent("crypt_puzzle_disc_main", "targetname");
	return (disc.position + level.gem_start_pos[gem_name]) % 4;
}

/*
	Name: chamber_disc_gem_has_clearance
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x98C0C8A1
	Offset: 0x19B8
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function chamber_disc_gem_has_clearance(gem_name)
{
	gem_position = chamber_disc_get_gem_position(gem_name);
	discs = getentarray("crypt_puzzle_disc", "script_noteworthy");
	foreach(disc in discs)
	{
		if(disc.targetname === "crypt_puzzle_disc_main")
		{
			continue;
		}
		if(disc.position != gem_position)
		{
			return false;
		}
	}
	return true;
}

/*
	Name: chamber_disc_rotate
	Namespace: zm_tomb_quest_crypt
	Checksum: 0xC402872E
	Offset: 0x1AD0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function chamber_disc_rotate(b_clockwise)
{
	if(b_clockwise)
	{
		self.position = (self.position + 1) % 4;
	}
	else
	{
		self.position = (self.position + 3) % 4;
	}
	self chamber_disc_move_to_position();
}

/*
	Name: bryce_cake_light_update
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x497F5BA8
	Offset: 0x1B40
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function bryce_cake_light_update(b_on = 1)
{
	if(!isdefined(self.n_bryce_cake))
	{
		self.n_bryce_cake = 0;
	}
	if(!b_on)
	{
		self.n_bryce_cake = (self.n_bryce_cake + 1) % 2;
	}
	else
	{
		self.n_bryce_cake = 2;
	}
	if(isdefined(self.var_b1c02d8a))
	{
		self.var_b1c02d8a clientfield::set("bryce_cake", self.n_bryce_cake);
	}
}

/*
	Name: chamber_discs_randomize
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x40AAA704
	Offset: 0x1BF0
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function chamber_discs_randomize()
{
	discs = getentarray("crypt_puzzle_disc", "script_noteworthy");
	prev_disc_pos = 0;
	foreach(disc in discs)
	{
		if(!isdefined(disc.target))
		{
			continue;
		}
		disc.position = (prev_disc_pos + randomintrange(1, 3)) % 4;
		prev_disc_pos = disc.position;
	}
	chamber_discs_move_all_to_position(discs);
}

/*
	Name: chamber_disc_switch_spark
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x87C4F173
	Offset: 0x1D20
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function chamber_disc_switch_spark()
{
	self clientfield::set("switch_spark", 1);
	wait(0.5);
	self clientfield::set("switch_spark", 0);
}

/*
	Name: chamber_disc_trigger_run
	Namespace: zm_tomb_quest_crypt
	Checksum: 0x81149237
	Offset: 0x1D78
	Size: 0x1DE
	Parameters: 3
	Flags: Linked
*/
function chamber_disc_trigger_run(e_disc, e_lever, b_clockwise)
{
	discs_to_rotate = array(e_disc);
	e_lever useanimtree($generic);
	n_anim_time = getanimlength(%generic::p7_fxanim_zm_ori_puzzle_switch_anim);
	while(true)
	{
		self waittill(#"trigger", e_triggerer);
		if(!level flag::get("disc_rotation_active"))
		{
			level flag::set("disc_rotation_active");
			e_lever animscripted("lever_switch", e_lever.origin, e_lever.angles, "p7_fxanim_zm_ori_puzzle_switch_anim");
			e_lever playsound("zmb_crypt_lever");
			wait(n_anim_time * 0.5);
			e_lever thread chamber_disc_switch_spark();
			array::thread_all(discs_to_rotate, &chamber_disc_rotate, b_clockwise);
			wait(1);
			level flag::clear("disc_rotation_active");
			level notify(#"vo_try_puzzle_crypt", e_triggerer);
		}
		level notify(#"crypt_disc_rotation");
	}
}

