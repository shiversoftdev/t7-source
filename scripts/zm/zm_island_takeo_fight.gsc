// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_thrasher;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\zm\_zm_ai_spiders;
#using scripts\zm\_zm_ai_thrasher;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_island_skullweapon_quest;

#namespace zm_island_takeo_fight;

/*
	Name: __init__sytem__
	Namespace: zm_island_takeo_fight
	Checksum: 0x16288CAF
	Offset: 0xF38
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_takeo_fight", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_takeo_fight
	Checksum: 0xEE9C04E9
	Offset: 0xF78
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "takeofight_teleport_fx", 9000, 1, "int");
	clientfield::register("scriptmover", "takeo_arm_hit_fx", 1, 3, "int");
}

/*
	Name: function_a85ea965
	Namespace: zm_island_takeo_fight
	Checksum: 0x142E3372
	Offset: 0xFE8
	Size: 0x724
	Parameters: 0
	Flags: Linked
*/
function function_a85ea965()
{
	level flag::wait_till("flag_init_takeo_fight");
	level scene::init("cin_isl_outro_3rd_sh010");
	level clientfield::set("force_stream_takeo_arms", 1);
	level.var_bbdc1f95 = struct::get("s_takeofight_origin", "targetname");
	level.var_bbdc1f95.var_fbe5299e = 0;
	level.var_bbdc1f95.n_kill_count = 0;
	level.var_bbdc1f95.a_s_spawnpts = struct::get_array("s_takeofight_spawnpt", "targetname");
	level.var_bbdc1f95.var_69943735 = [];
	for(i = 1; i <= 3; i++)
	{
		level.var_bbdc1f95.var_69943735[i] = util::spawn_model("tag_origin", level.var_bbdc1f95.origin, level.var_bbdc1f95.angles);
		level.var_bbdc1f95.var_69943735[i].var_7168c71c = [];
		level.var_bbdc1f95.var_69943735[i].script_int = i;
	}
	level.var_bbdc1f95.var_e7eb4096 = util::spawn_model("tag_origin", level.var_bbdc1f95.origin, level.var_bbdc1f95.angles);
	level.var_bbdc1f95.var_e7eb4096.script_int = 4;
	level.var_bbdc1f95.var_e7eb4096.b_dead = 0;
	level.var_bbdc1f95.var_e7eb4096.var_7168c71c = [];
	var_9f68aa5 = getent("final_vine_postule", "targetname");
	var_9f68aa5.var_74d299dc = 1;
	var_9f68aa5.var_7117876c = var_9f68aa5.origin;
	var_9f68aa5.v_off_pos = var_9f68aa5.origin + (vectorscale((-1, 0, 0), 32));
	array::add(level.var_bbdc1f95.var_e7eb4096.var_7168c71c, var_9f68aa5);
	var_d8ec11a1 = getentarray("vine_postule", "targetname");
	foreach(var_fb97f73d in var_d8ec11a1)
	{
		var_fb97f73d.var_7117876c = var_fb97f73d.origin;
		var_fb97f73d.v_off_pos = var_fb97f73d.origin + (vectorscale((-1, 0, 0), 32));
		array::add(level.var_bbdc1f95.var_69943735[var_fb97f73d.script_int].var_7168c71c, var_fb97f73d);
	}
	level.var_bbdc1f95.var_cf5e2435 = getent("clip_takeofight_door", "targetname");
	level.var_bbdc1f95.var_c093c394 = getent("mdl_takeofight_room_seal", "targetname");
	level.var_bbdc1f95.var_c093c394.var_9c93e17 = level.var_bbdc1f95.var_c093c394.origin;
	level.var_bbdc1f95.var_c093c394.v_open_pos = level.var_bbdc1f95.var_c093c394.origin + vectorscale((0, 0, 1), 120);
	level.var_bbdc1f95.var_cf5e2435 linkto(level.var_bbdc1f95.var_c093c394);
	level flag::init("takeo_freed");
	level.var_4d97351 = 0;
	level.var_c70a4f00 = 0;
	for(i = 1; i <= level.var_bbdc1f95.var_69943735.size; i++)
	{
		level.var_bbdc1f95.var_69943735[i].b_dead = 0;
		foreach(var_fb97f73d in level.var_bbdc1f95.var_69943735[i].var_7168c71c)
		{
			var_fb97f73d function_269cf850(0);
			var_fb97f73d thread function_9c58350b();
		}
	}
	level.mdl_alttakeo = getent("mdl_alttakeo", "targetname");
	level.mdl_alttakeo thread function_75174ee();
	level.mdl_alttakeo playloopsound("zmb_takeo_heartbeat_far");
	level thread function_a49f3a92();
	level thread function_ed01b73c("pre_wave");
	level scene::init("p7_fxanim_zm_island_takeo_vines_bundle");
}

/*
	Name: main
	Namespace: zm_island_takeo_fight
	Checksum: 0xDF51967A
	Offset: 0x1718
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function main()
{
	/#
		level thread function_c2fee078();
	#/
	level thread function_a85ea965();
}

/*
	Name: function_9c58350b
	Namespace: zm_island_takeo_fight
	Checksum: 0xEE7DA9E
	Offset: 0x1758
	Size: 0x246
	Parameters: 0
	Flags: Linked
*/
function function_9c58350b()
{
	self endon(#"hash_c8e5500f");
	self endon(#"hash_9dad47cd");
	self.var_2340346c = 0;
	while(!level flag::get("takeo_freed") && (!(isdefined(self.var_2340346c) && self.var_2340346c)))
	{
		self waittill(#"damage", n_damage, e_attacker, v_vector, v_point, str_means_of_death, str_string_1, str_string_2, str_string_3, w_weapon);
		if(!self.takedamage)
		{
			continue;
		}
		self.health = 10000;
		if(zombie_utility::is_player_valid(e_attacker) && w_weapon.name === "hero_mirg2000_upgraded")
		{
			var_45e03445 = function_9f1fd468();
			switch(var_45e03445)
			{
				case "pre_wave":
				{
					level thread function_ed01b73c("attack_wave", level.var_bbdc1f95.var_69943735[self.script_int]);
					self.var_2340346c = 1;
					break;
				}
				case "next_wave_ready":
				{
					level thread function_ed01b73c("next_wave", level.var_bbdc1f95.var_69943735[self.script_int]);
					self.var_2340346c = 1;
					break;
				}
				case "retry_ready":
				{
					level thread function_ed01b73c("retry_start", level.var_bbdc1f95.var_69943735[self.script_int]);
					self.var_2340346c = 1;
					break;
				}
			}
		}
	}
}

/*
	Name: function_269cf850
	Namespace: zm_island_takeo_fight
	Checksum: 0x8AEFDFAC
	Offset: 0x19A8
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_269cf850(var_6c555b6c = 1)
{
	if(isdefined(var_6c555b6c) && var_6c555b6c)
	{
		self setcandamage(1);
	}
	else
	{
		self setcandamage(0);
	}
}

/*
	Name: function_bf38b3c9
	Namespace: zm_island_takeo_fight
	Checksum: 0xF1812173
	Offset: 0x1A18
	Size: 0x1BA
	Parameters: 2
	Flags: Linked
*/
function function_bf38b3c9(var_6c555b6c = 1, b_force = 0)
{
	if(b_force == 1 || (self.var_6c555b6c !== var_6c555b6c && (!(isdefined(self.b_dead) && self.b_dead))))
	{
		var_3a0318fc = self.script_int;
		if(var_6c555b6c == 1)
		{
			var_7814e8cc = function_b64005e8(var_3a0318fc, "open");
			level.mdl_alttakeo playsoundontag("zmb_takeo_vox_eye_open", "tag_eye");
		}
		else
		{
			var_7814e8cc = function_b64005e8(var_3a0318fc, "close");
		}
		self thread scene::play(var_7814e8cc);
		self.var_6c555b6c = var_6c555b6c;
		foreach(var_fb97f73d in self.var_7168c71c)
		{
			var_fb97f73d thread function_269cf850(var_6c555b6c);
		}
	}
}

/*
	Name: function_4c7498f7
	Namespace: zm_island_takeo_fight
	Checksum: 0xBBAF2144
	Offset: 0x1BE0
	Size: 0x224
	Parameters: 0
	Flags: Linked
*/
function function_4c7498f7()
{
	var_ac9b7de4 = level.var_bbdc1f95.var_69943735[3];
	if(!(isdefined(var_ac9b7de4.b_dead) && var_ac9b7de4.b_dead) && (!(isdefined(var_ac9b7de4.var_722e43d8) && var_ac9b7de4.var_722e43d8)))
	{
		var_ac9b7de4.var_722e43d8 = 1;
		var_f1a28621 = array("roar", "jawsnap");
		level thread function_6addaa9e(array::random(var_f1a28621));
		if(isdefined(var_ac9b7de4.var_6c555b6c) && var_ac9b7de4.var_6c555b6c)
		{
			var_ac9b7de4 thread scene::play("p7_fxanim_zm_island_takeo_arm3_open_slam_bundle");
		}
		else
		{
			var_ac9b7de4 thread scene::play("p7_fxanim_zm_island_takeo_arm3_close_slam_bundle");
		}
		level waittill(#"hash_4c7498f7");
		level thread scene::play("p7_fxanim_zm_island_takeo_vines_bundle");
		var_d034d3c3 = struct::get("s_vine_slam_impact_pos", "targetname");
		radiusdamage(var_d034d3c3.origin, 100, 480, 240, undefined, "MOD_GRENADE");
		playrumbleonposition("zm_island_rumble_takeo_vine_slam", var_d034d3c3.origin);
		exploder::exploder("fxexp_620");
		wait(1.5);
		var_ac9b7de4.var_722e43d8 = 0;
	}
}

/*
	Name: function_279705f
	Namespace: zm_island_takeo_fight
	Checksum: 0xCC3D905D
	Offset: 0x1E10
	Size: 0x88
	Parameters: 0
	Flags: Linked
*/
function function_279705f()
{
	level endon(#"hash_d1f7df7e");
	var_ac9b7de4 = level.var_bbdc1f95.var_69943735[3];
	while(!(isdefined(var_ac9b7de4.b_dead) && var_ac9b7de4.b_dead))
	{
		level thread function_4c7498f7();
		wait(randomintrange(10, 20));
	}
}

/*
	Name: function_c8dfb7e1
	Namespace: zm_island_takeo_fight
	Checksum: 0x59507538
	Offset: 0x1EA0
	Size: 0x32
	Parameters: 0
	Flags: Linked
*/
function function_c8dfb7e1()
{
	level.var_bbdc1f95.var_62473c4b function_54d91dfb();
	level.var_bbdc1f95.var_62473c4b = undefined;
}

/*
	Name: function_54d91dfb
	Namespace: zm_island_takeo_fight
	Checksum: 0x43610736
	Offset: 0x1EE0
	Size: 0x2DC
	Parameters: 0
	Flags: Linked
*/
function function_54d91dfb()
{
	self notify(#"hash_c8e5500f");
	self.b_dead = 1;
	foreach(var_fb97f73d in self.var_7168c71c)
	{
		var_fb97f73d function_269cf850(0);
		var_fb97f73d notify(#"hash_c8e5500f");
	}
	var_9f49d930 = "takeo_arm" + self.script_int;
	var_90f16638 = getent(var_9f49d930, "targetname");
	var_90f16638 clientfield::set("takeo_arm_hit_fx", self.script_int);
	level thread function_6addaa9e("pain_big");
	if(level flag::get("takeo_freed"))
	{
		level.mdl_alttakeo playsoundontag("zmb_takeo_vox_death", "tag_eye");
	}
	else
	{
		level.mdl_alttakeo playsoundontag("zmb_takeo_vox_pain_large", "tag_eye");
	}
	wait(0.1);
	str_tag = ("eye" + self.script_int) + "_side_jnt";
	var_90f16638 hidepart(str_tag);
	wait(2);
	var_87504ba3 = function_b64005e8(self.script_int, "retract");
	self thread scene::play(var_87504ba3);
	if(self.script_int === 2)
	{
		getent("takeo_boss_vine_clip_1", "targetname") notsolid();
	}
	else if(self.script_int === 4)
	{
		getent("takeo_boss_vine_clip_2", "targetname") notsolid();
	}
}

/*
	Name: function_6bc98691
	Namespace: zm_island_takeo_fight
	Checksum: 0x72F13975
	Offset: 0x21C8
	Size: 0x12A
	Parameters: 0
	Flags: Linked
*/
function function_6bc98691()
{
	if(isdefined(self.b_dead) && self.b_dead)
	{
		self show();
		str_idle = function_b64005e8(self.script_int, "idle_close");
		self thread scene::play(str_idle);
		self.b_dead = 0;
		foreach(var_fb97f73d in self.var_7168c71c)
		{
			var_fb97f73d function_269cf850(1);
			wait(0.35);
			var_fb97f73d thread function_9c58350b();
		}
	}
}

/*
	Name: function_b64005e8
	Namespace: zm_island_takeo_fight
	Checksum: 0x7A8B5F03
	Offset: 0x2300
	Size: 0x122
	Parameters: 2
	Flags: Linked
*/
function function_b64005e8(var_3a0318fc, str_state)
{
	switch(str_state)
	{
		case "close":
		{
			str_anim = ("p7_fxanim_zm_island_takeo_arm" + var_3a0318fc) + "_close_bundle";
			break;
		}
		case "open":
		{
			str_anim = ("p7_fxanim_zm_island_takeo_arm" + var_3a0318fc) + "_open_bundle";
			break;
		}
		case "idle_close":
		{
			str_anim = ("p7_fxanim_zm_island_takeo_arm" + var_3a0318fc) + "_idle_close_bundle";
			break;
		}
		case "idle_open":
		{
			str_anim = ("p7_fxanim_zm_island_takeo_arm" + var_3a0318fc) + "_idle_open_bundle";
			break;
		}
		case "slam":
		{
			str_anim = ("p7_fxanim_zm_island_takeo_arm" + var_3a0318fc) + "_close_slam_bundle";
			break;
		}
		case "retract":
		{
			str_anim = ("p7_fxanim_zm_island_takeo_arm" + var_3a0318fc) + "_retract_bundle";
			break;
		}
	}
	return str_anim;
}

/*
	Name: function_75174ee
	Namespace: zm_island_takeo_fight
	Checksum: 0xA8C2955E
	Offset: 0x2430
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function function_75174ee()
{
	level endon(#"flag_play_outro_cutscene");
	var_a175a10b = util::spawn_model("tag_origin", self.origin, self.angles);
	var_a175a10b thread function_5c1adaf1();
	self linkto(var_a175a10b);
	var_a175a10b rotateroll(1, 2.5);
	while(!level flag::get("flag_play_outro_cutscene"))
	{
		var_a175a10b rotateroll(-2, 5);
		var_a175a10b waittill(#"rotatedone");
		var_a175a10b rotateroll(2, 5);
		var_a175a10b waittill(#"rotatedone");
	}
}

/*
	Name: function_5c1adaf1
	Namespace: zm_island_takeo_fight
	Checksum: 0x43748F2A
	Offset: 0x2550
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_5c1adaf1()
{
	level flag::wait_till("flag_play_outro_cutscene");
	self delete();
}

/*
	Name: function_6addaa9e
	Namespace: zm_island_takeo_fight
	Checksum: 0xB4A94A5D
	Offset: 0x2598
	Size: 0x274
	Parameters: 1
	Flags: Linked
*/
function function_6addaa9e(str_state)
{
	if(isdefined(level.mdl_alttakeo))
	{
		switch(str_state)
		{
			case "jawsnap":
			{
				str_anim = "cin_isl_outro_1st_monsterhead_jaw_snapping";
				str_mode = "play";
				break;
			}
			case "roar":
			{
				str_anim = "cin_isl_outro_1st_monsterhead_angry_roar";
				str_mode = "play";
				str_exploder = "fxexp_620";
				var_bddce9ce = 1;
				break;
			}
			case "pain":
			{
				str_anim = "cin_isl_outro_1st_monsterhead_pain_scream";
				str_mode = "play";
				str_exploder = "fxexp_620";
				var_bddce9ce = 1;
				break;
			}
			case "pain_big":
			{
				str_anim = "cin_isl_outro_1st_monsterhead_big_pain_scream";
				str_mode = "play";
				str_exploder = "fxexp_620";
				var_bddce9ce = 1;
				break;
			}
			case "sleep":
			{
				str_anim = "cin_isl_outro_1st_monsterhead_sleep";
				str_mode = "init";
				break;
			}
		}
		if(isdefined(str_anim))
		{
			if(level.mdl_alttakeo.str_scene !== "")
			{
				level.mdl_alttakeo scene::stop();
			}
			if(str_mode === "play")
			{
				level.mdl_alttakeo thread scene::play(str_anim, level.mdl_alttakeo);
				level.mdl_alttakeo.str_scene = str_anim;
			}
			else if(str_mode === "init")
			{
				level.mdl_alttakeo thread scene::init(str_anim, level.mdl_alttakeo);
				level.mdl_alttakeo.str_scene = str_anim;
			}
			if(isdefined(str_exploder))
			{
				exploder::exploder(str_exploder);
			}
			if(isdefined(var_bddce9ce) && var_bddce9ce)
			{
				level scene::play("p7_fxanim_zm_island_takeo_vines_bundle");
			}
		}
	}
}

/*
	Name: function_ed01b73c
	Namespace: zm_island_takeo_fight
	Checksum: 0x3C6E5F9E
	Offset: 0x2818
	Size: 0x5F4
	Parameters: 2
	Flags: Linked
*/
function function_ed01b73c(str_state, var_3fd94cb9)
{
	if(str_state !== level.var_bbdc1f95.str_state)
	{
		switch(str_state)
		{
			case "pre_wave":
			case "retry_ready":
			{
				level.var_bbdc1f95.var_62473c4b = undefined;
				level.var_bbdc1f95.var_69943735[1] thread function_bf38b3c9(1, 1);
				level.var_bbdc1f95.var_69943735[2] thread function_bf38b3c9(1, 1);
				level.var_bbdc1f95.var_69943735[3] thread function_bf38b3c9(0, 1);
				level.var_bbdc1f95.var_e7eb4096 thread function_bf38b3c9(0, 1);
				level thread function_2ea7cbca();
				break;
			}
			case "timedout_attack_wave":
			{
				level thread function_bc851c3a(1);
				if(!level flag::get("takeofight_wave_spawning"))
				{
					level thread function_628b98fd(0);
				}
				break;
			}
			case "attack_wave":
			{
				level thread function_bc851c3a(1);
				if(isdefined(var_3fd94cb9))
				{
					level.var_bbdc1f95.var_62473c4b = var_3fd94cb9;
					level.var_bbdc1f95.var_62473c4b thread function_54d91dfb();
				}
				if(!level flag::get("takeofight_wave_spawning"))
				{
					level thread function_628b98fd();
				}
				break;
			}
			case "retry_start":
			{
				level thread function_bc851c3a(1);
				if(isdefined(var_3fd94cb9))
				{
					level.var_bbdc1f95.var_62473c4b = var_3fd94cb9;
					level.var_bbdc1f95.var_62473c4b thread function_54d91dfb();
				}
				if(!level flag::get("takeofight_wave_spawning"))
				{
					level thread function_628b98fd();
				}
				break;
			}
			case "next_wave_ready":
			{
				if(level.var_bbdc1f95.var_fbe5299e > 1)
				{
					level.var_bbdc1f95.var_69943735[3] thread function_bf38b3c9(1);
				}
				else
				{
					level.var_bbdc1f95.var_69943735[1] thread function_bf38b3c9(1);
					level.var_bbdc1f95.var_69943735[2] thread function_bf38b3c9(1);
				}
				level thread function_6addaa9e("jawsnap");
				break;
			}
			case "next_wave":
			{
				if(isdefined(var_3fd94cb9))
				{
					level.var_bbdc1f95.var_62473c4b = var_3fd94cb9;
					level.var_bbdc1f95.var_62473c4b thread function_54d91dfb();
				}
				level.var_bbdc1f95 thread function_87949ac6();
				break;
			}
			case "fight_end_ready":
			{
				if(isdefined(var_3fd94cb9))
				{
					level.var_bbdc1f95.var_62473c4b = var_3fd94cb9;
					level.var_bbdc1f95.var_62473c4b thread function_54d91dfb();
				}
				level thread function_4814eea9();
				break;
			}
			case "completed":
			{
				level thread util::player_lock_control();
				level thread exploder::exploder("fxexp_621");
				playrumbleonposition("zm_island_rumble_takeofight_end_quake", level.mdl_alttakeo.origin);
				wait(5);
				foreach(player in level.activeplayers)
				{
					player giveachievement("ZM_ISLAND_COMPLETE_EE");
				}
				level thread function_bc851c3a(0);
				level flag::set("flag_play_outro_cutscene");
				level thread function_b316383a();
				level clientfield::set("force_stream_takeo_arms", 0);
				break;
			}
		}
		level.var_bbdc1f95.str_state = str_state;
	}
}

/*
	Name: function_2ea7cbca
	Namespace: zm_island_takeo_fight
	Checksum: 0x17DD371C
	Offset: 0x2E18
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function function_2ea7cbca()
{
	level thread function_6addaa9e("sleep");
	var_1f146770 = 0;
	do
	{
		foreach(player in level.activeplayers)
		{
			if(player zm_zonemgr::entity_in_zone("zone_bunker_prison", 1))
			{
				var_1f146770 = 1;
			}
		}
		wait(0.5);
	}
	while(var_1f146770 != 1);
	wait(30);
	if(function_9f1fd468() == "pre_wave")
	{
		level thread function_ed01b73c("timedout_attack_wave");
	}
}

/*
	Name: function_a49f3a92
	Namespace: zm_island_takeo_fight
	Checksum: 0xD09F3A76
	Offset: 0x2F50
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function function_a49f3a92()
{
	level waittill(#"hash_add73e69");
	level flag::clear("spawn_zombies");
	var_fe3fa728 = 400 * 400;
	mdl_door = level.var_bbdc1f95.var_c093c394;
	var_1bc21233 = 0;
	while(var_1bc21233 != 1)
	{
		foreach(player in level.activeplayers)
		{
			if(zm_utility::is_player_valid(player) && distancesquared(player.origin, mdl_door.origin) <= var_fe3fa728)
			{
				var_1bc21233 = 1;
			}
		}
		wait(0.1);
	}
	level thread function_bc851c3a(0);
	wait(6);
	level util::clientnotify("sndTakeo");
	level.mdl_alttakeo scene::play("cin_isl_outro_1st_monsterhead_sleep");
	level thread scene::play("p7_fxanim_zm_island_takeo_vines_bundle");
}

/*
	Name: function_bc851c3a
	Namespace: zm_island_takeo_fight
	Checksum: 0xDF549F53
	Offset: 0x3130
	Size: 0x10C
	Parameters: 1
	Flags: Linked
*/
function function_bc851c3a(b_on)
{
	if(isdefined(b_on) && b_on)
	{
		level.var_bbdc1f95.var_c093c394 moveto(level.var_bbdc1f95.var_c093c394.var_9c93e17, 0.5);
		level.var_bbdc1f95.var_c093c394 playsound("zmb_takeoboss_door_close");
	}
	else
	{
		level.var_bbdc1f95.var_c093c394 moveto(level.var_bbdc1f95.var_c093c394.v_open_pos, 2.5, 0.5);
		level.var_bbdc1f95.var_c093c394 playsound("zmb_takeoboss_door_open");
	}
}

/*
	Name: function_9f1fd468
	Namespace: zm_island_takeo_fight
	Checksum: 0xD7A64945
	Offset: 0x3248
	Size: 0x12
	Parameters: 0
	Flags: Linked
*/
function function_9f1fd468()
{
	return level.var_bbdc1f95.str_state;
}

/*
	Name: function_87949ac6
	Namespace: zm_island_takeo_fight
	Checksum: 0xEEF7F43C
	Offset: 0x3268
	Size: 0x19C
	Parameters: 0
	Flags: Linked
*/
function function_87949ac6()
{
	level endon(#"hash_ec7f92f6");
	foreach(var_9c458cf5 in level.var_bbdc1f95.var_69943735)
	{
		var_9c458cf5 thread function_bf38b3c9(0);
	}
	if(self.var_fbe5299e <= 1)
	{
		level notify(#"hash_d1f7df7e");
		wait(1.5);
		level thread function_279705f();
		level waittill(#"hash_4c7498f7");
	}
	self function_2e25785c();
	self.var_fbe5299e++;
	if(level.var_bbdc1f95.var_fbe5299e < 3)
	{
		str_next_state = "next_wave_ready";
	}
	else
	{
		str_next_state = "fight_end_ready";
	}
	if(level.var_c70a4f00 == 0)
	{
		wait(60);
	}
	else
	{
		wait(level.var_c70a4f00);
	}
	if(level flag::get("takeofight_wave_spawning"))
	{
		function_ed01b73c(str_next_state);
	}
}

/*
	Name: function_2e25785c
	Namespace: zm_island_takeo_fight
	Checksum: 0x527A09B0
	Offset: 0x3410
	Size: 0x2CC
	Parameters: 0
	Flags: Linked
*/
function function_2e25785c()
{
	if(level.var_4d97351 > 0)
	{
		var_36e3085a = level.var_4d97351;
	}
	else
	{
		var_36e3085a = self.var_fbe5299e;
	}
	level.var_36d0a784 = 0;
	level.var_e6b38df = var_36e3085a + 3;
	level.var_2ddef893 = 0;
	switch(var_36e3085a)
	{
		case 0:
		{
			self.var_2e486eac = array(0, 5, 5, 6, 6);
			self.var_ce1421d3 = array(0, 3, 3, 4, 5);
			self.var_6033a1e7 = array(0, 2, 2, 3, 3);
			self.var_5687375e = 1;
			self.var_654ec44b = 1.5;
			self.var_62813733 = 0;
			break;
		}
		case 1:
		{
			self.var_2e486eac = array(0, 8, 8, 9, 9);
			self.var_ce1421d3 = array(0, 5, 5, 6, 7);
			self.var_6033a1e7 = array(0, 3, 3, 4, 4);
			self.var_5687375e = 0.75;
			self.var_654ec44b = 1;
			self.var_62813733 = 0;
			break;
		}
		case 2:
		{
			self.var_2e486eac = array(0, 10, 10, 10, 10);
			self.var_ce1421d3 = array(0, 6, 6, 7, 7);
			self.var_6033a1e7 = array(0, 4, 4, 5, 5);
			self.var_5687375e = 0.5;
			self.var_654ec44b = 0.5;
			self.var_62813733 = 1;
			break;
		}
	}
	self thread function_b96762d3();
}

/*
	Name: function_b96762d3
	Namespace: zm_island_takeo_fight
	Checksum: 0x7528E8D0
	Offset: 0x36E8
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function function_b96762d3()
{
	self.var_44da5f74 = self.var_6033a1e7[level.activeplayers.size];
	self.var_1fcf1bc4 = self.var_ce1421d3[level.activeplayers.size];
	self.var_fc3dea41 = self.var_2e486eac[level.activeplayers.size];
	if(isdefined(self.var_eca4fee1) && self.var_eca4fee1 > 0)
	{
		level.zombie_ai_limit = level.zombie_ai_limit + self.var_eca4fee1;
	}
	self.var_eca4fee1 = (self.var_44da5f74 + self.var_1fcf1bc4) + self.var_fc3dea41;
	level.zombie_ai_limit = level.zombie_ai_limit - self.var_eca4fee1;
}

/*
	Name: function_628b98fd
	Namespace: zm_island_takeo_fight
	Checksum: 0x8B20F5BD
	Offset: 0x37A8
	Size: 0x1BC
	Parameters: 1
	Flags: Linked
*/
function function_628b98fd(var_db18d39e = 1)
{
	level endon(#"hash_ec7f92f6");
	foreach(var_9c458cf5 in level.var_bbdc1f95.var_69943735)
	{
		var_9c458cf5 thread function_bf38b3c9(0);
	}
	wait(1.5);
	level thread function_279705f();
	level waittill(#"hash_4c7498f7");
	level.var_bbdc1f95 thread function_4ea8a87a();
	if(isdefined(var_db18d39e) && var_db18d39e)
	{
		level.var_bbdc1f95.var_fbe5299e++;
	}
	if(level.var_c70a4f00 == 0)
	{
		wait(60);
	}
	else
	{
		wait(level.var_c70a4f00);
	}
	if(level flag::get("takeofight_wave_spawning"))
	{
		if(level.var_bbdc1f95.var_fbe5299e < 3)
		{
			level thread function_ed01b73c("next_wave_ready");
		}
		else
		{
			level thread function_ed01b73c("fight_end_ready");
		}
	}
}

/*
	Name: function_4ea8a87a
	Namespace: zm_island_takeo_fight
	Checksum: 0x231FF481
	Offset: 0x3970
	Size: 0x71C
	Parameters: 0
	Flags: Linked
*/
function function_4ea8a87a()
{
	if(!level flag::get("takeofight_wave_spawning"))
	{
		level.disable_nuke_delay_spawning = 1;
		level.var_5c9015c4 = level.zombie_ai_limit;
		level.var_5258ba34 = 1;
		a_spawners = [];
		var_89f44116 = level.zombie_spawners;
		var_64cc2fa5 = level.var_feebf312;
		var_6469b451 = level.var_c38a4fee;
		var_62813733 = 0;
		a_spawners = array(var_64cc2fa5[0], var_6469b451[0], var_89f44116[0]);
		self function_2e25785c();
		var_19b19369 = "takeofight_enemy";
		self.var_bd61ef5b = 0;
		self.var_9defe760 = 0;
		self.var_bc88fb8b = 0;
		self.var_8a71c4c5 = 0;
		self.a_ai_attackers = [];
		self.a_s_spawnpts = array::randomize(self.a_s_spawnpts);
		zm_spawner::register_zombie_death_event_callback(&function_3127ccbd);
		callback::on_vehicle_killed(&function_a3420702);
		level flag::set("takeofight_wave_spawning");
		wait(0.1);
		level thread function_fe7b0c13();
		while(level flag::get("takeofight_wave_spawning") && (!(isdefined(level.var_f0fe245e) && level.var_f0fe245e)))
		{
			var_43b53d77 = self.a_s_spawnpts.size;
			for(i = 0; i < var_43b53d77; i++)
			{
				while(getfreeactorcount() < 1)
				{
					wait(0.05);
				}
				while(self.var_8a71c4c5 >= self.var_eca4fee1)
				{
					wait(0.05);
				}
				if(level flag::get("takeofight_wave_spawning") && (!(isdefined(level.var_f0fe245e) && level.var_f0fe245e)))
				{
					e_spawner = array::random(a_spawners);
					ai_attacker = undefined;
					switch(e_spawner.script_noteworthy)
					{
						case "zombie_spawner":
						{
							if(self.var_9defe760 < self.var_fc3dea41)
							{
								self.a_s_spawnpts[i].script_noteworthy = "riser_location";
								self.a_s_spawnpts[i].script_string = "find_flesh";
								ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369, self.a_s_spawnpts[i]);
							}
							break;
						}
						case "zombie_thrasher_spawner":
						{
							if(self.var_bd61ef5b < self.var_44da5f74)
							{
								self.a_s_spawnpts[i].script_noteworthy = "riser_location";
								ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369);
							}
							break;
						}
						case "zombie_spider_spawner":
						{
							if(self.var_bc88fb8b < self.var_1fcf1bc4)
							{
								self.a_s_spawnpts[i].script_noteworthy = "spider_location";
								ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369, self.a_s_spawnpts[i]);
							}
							break;
						}
					}
					wait(0.1);
					if(isalive(ai_attacker))
					{
						ai_attacker.ignore_enemy_count = 1;
						ai_attacker.no_damage_points = 1;
						ai_attacker.deathpoints_already_given = 1;
						ai_attacker.var_bf5bc647 = 1;
						self.var_8a71c4c5++;
						array::add(self.a_ai_attackers, ai_attacker);
						switch(e_spawner.script_noteworthy)
						{
							case "zombie_spawner":
							{
								self.var_9defe760++;
								break;
							}
							case "zombie_thrasher_spawner":
							{
								self.var_bd61ef5b++;
								ai_attacker zm_ai_thrasher::function_89976d94(self.a_s_spawnpts[i].origin);
								if(isdefined(var_62813733) && var_62813733)
								{
									thrasherserverutils::thrashergoberserk(ai_attacker);
								}
								break;
							}
							case "zombie_spider_spawner":
							{
								self.var_bc88fb8b++;
								ai_attacker.favoriteenemy = zm_ai_spiders::get_favorite_enemy();
								self.a_s_spawnpts[i] thread zm_ai_spiders::function_49e57a3b(ai_attacker, self.a_s_spawnpts[i]);
								break;
							}
						}
						wait(self.var_5687375e);
					}
					self function_b96762d3();
					continue;
				}
				break;
			}
			wait(self.var_654ec44b);
		}
		while(self.a_ai_attackers.size > 0 && (!(isdefined(level.var_f0fe245e) && level.var_f0fe245e)))
		{
			self.a_ai_attackers = array::remove_undefined(self.a_ai_attackers);
			wait(1);
		}
		zm_spawner::deregister_zombie_death_event_callback(&function_3127ccbd);
		callback::remove_on_vehicle_killed(&function_a3420702);
		level.var_5258ba34 = 0;
		level flag::clear("takeofight_wave_spawning");
		self thread function_612749c9();
	}
}

/*
	Name: function_612749c9
	Namespace: zm_island_takeo_fight
	Checksum: 0x24937D19
	Offset: 0x4098
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_612749c9()
{
	level.zombie_ai_limit = level.var_5c9015c4;
	self.var_eca4fee1 = 0;
	level notify(#"hash_ec7f92f6");
	function_9bbf4262();
	if(self.a_ai_attackers.size == 0)
	{
		self thread function_c3386633();
	}
	else
	{
		self thread function_18044002();
	}
}

/*
	Name: function_c3386633
	Namespace: zm_island_takeo_fight
	Checksum: 0xB1795AC6
	Offset: 0x4128
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function function_c3386633(b_debug = 0)
{
	if(isdefined(b_debug) && b_debug)
	{
		function_c8dfb7e1();
	}
	level thread function_ed01b73c("completed");
}

/*
	Name: function_b316383a
	Namespace: zm_island_takeo_fight
	Checksum: 0xF347EF03
	Offset: 0x4198
	Size: 0x384
	Parameters: 0
	Flags: Linked
*/
function function_b316383a()
{
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm1_close_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm1_open_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm1_idle_close_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm1_idle_open_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm1_retract_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm2_close_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm2_open_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm2_idle_close_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm2_idle_open_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm2_retract_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm3_close_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm3_open_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm3_idle_close_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm3_idle_open_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm3_retract_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm3_close_slam_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm3_open_slam_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm4_close_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm4_open_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm4_idle_close_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm4_idle_open_bundle");
	struct::delete_script_bundle("scene", "p7_fxanim_zm_island_takeo_arm4_retract_bundle");
	struct::delete_script_bundle("scene", "cin_isl_outro_1st_monsterhead_sleep");
	struct::delete_script_bundle("scene", "cin_isl_outro_1st_monsterhead_breathing");
	struct::delete_script_bundle("scene", "cin_isl_outro_1st_monsterhead_angry_roar");
	struct::delete_script_bundle("scene", "cin_isl_outro_1st_monsterhead_jaw_snapping");
	struct::delete_script_bundle("scene", "cin_isl_outro_1st_monsterhead_pain_scream");
	struct::delete_script_bundle("scene", "cin_isl_outro_1st_monsterhead_big_pain_scream");
}

/*
	Name: function_18044002
	Namespace: zm_island_takeo_fight
	Checksum: 0xAB6F57D4
	Offset: 0x4528
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function function_18044002()
{
	var_c5d0d808 = level.var_bbdc1f95.var_e7eb4096.var_7168c71c[0];
	var_c5d0d808 function_269cf850(0);
	level notify(#"hash_24bebb15");
	if(isdefined(level.var_bbdc1f95.var_62473c4b))
	{
		level.var_bbdc1f95.var_62473c4b thread function_6bc98691();
	}
	if(level.var_bbdc1f95.var_fbe5299e > 0)
	{
		level.var_bbdc1f95.var_fbe5299e--;
	}
	level thread function_ed01b73c("retry_ready");
	level flag::set("spawn_zombies");
	level.disable_nuke_delay_spawning = 0;
}

/*
	Name: function_4814eea9
	Namespace: zm_island_takeo_fight
	Checksum: 0x604A6BE3
	Offset: 0x4630
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function function_4814eea9()
{
	var_c5d0d808 = level.var_bbdc1f95.var_e7eb4096.var_7168c71c[0];
	var_c5d0d808 function_269cf850(1);
	level.var_bbdc1f95.var_e7eb4096 thread function_bf38b3c9(1, 1);
	while(!level flag::get("takeo_freed"))
	{
		var_c5d0d808 waittill(#"damage", n_damage, e_attacker, v_vector, v_point, str_means_of_death, str_string_1, str_string_2, str_string_3, w_weapon);
		if(zombie_utility::is_player_valid(e_attacker) && w_weapon.name === "hero_mirg2000_upgraded" && function_9f1fd468() == "fight_end_ready")
		{
			level flag::set("takeo_freed");
		}
	}
	level.var_bbdc1f95.var_e7eb4096 thread function_54d91dfb();
	level flag::clear("takeofight_wave_spawning");
	wait(1);
	level.var_bbdc1f95.a_ai_attackers = array::remove_undefined(level.var_bbdc1f95.a_ai_attackers);
	level thread function_9bbf4262();
	level util::clientnotify("sndTakeoEnd");
}

/*
	Name: function_9bbf4262
	Namespace: zm_island_takeo_fight
	Checksum: 0xE37996E1
	Offset: 0x4878
	Size: 0x11A
	Parameters: 0
	Flags: Linked
*/
function function_9bbf4262()
{
	a_enemies = getaiteamarray("axis");
	foreach(enemy in a_enemies)
	{
		if(isalive(enemy) && enemy zm_zonemgr::entity_in_zone("zone_bunker_prison", 1))
		{
			enemy util::stop_magic_bullet_shield();
			enemy kill();
			wait(randomfloatrange(0.05, 0.1));
		}
	}
}

/*
	Name: function_a3420702
	Namespace: zm_island_takeo_fight
	Checksum: 0x1F7942F6
	Offset: 0x49A0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_a3420702(params)
{
	self thread function_3127ccbd(params.eattacker);
}

/*
	Name: function_3127ccbd
	Namespace: zm_island_takeo_fight
	Checksum: 0xE021ECE8
	Offset: 0x49D8
	Size: 0x154
	Parameters: 1
	Flags: Linked
*/
function function_3127ccbd(e_attacker)
{
	if(isdefined(self) && (isdefined(self.var_bf5bc647) && self.var_bf5bc647))
	{
		level.var_bbdc1f95.var_8a71c4c5--;
		arrayremovevalue(level.var_bbdc1f95.a_ai_attackers, self);
		level.var_bbdc1f95.n_kill_count++;
		if(self.script_noteworthy === "zombie_thrasher_spawner")
		{
			level.var_bbdc1f95.var_bd61ef5b--;
			if(isdefined(self))
			{
				level thread function_55079785(self.origin);
				level thread function_6ccb6373();
			}
		}
		else
		{
			if(self.script_noteworthy === "zombie_spider_spawner")
			{
				level.var_bbdc1f95.var_bc88fb8b--;
			}
			else if(self.script_noteworthy === "zombie_spawner")
			{
				level.var_bbdc1f95.var_9defe760--;
			}
		}
		if(level.var_bbdc1f95.a_ai_attackers.size == 0)
		{
			zm_powerups::specific_powerup_drop("full_ammo", self.origin);
		}
	}
}

/*
	Name: function_55079785
	Namespace: zm_island_takeo_fight
	Checksum: 0xF5DE547E
	Offset: 0x4B38
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function function_55079785(v_pos)
{
	level.var_2ddef893++;
	if(level flag::get("takeofight_wave_spawning"))
	{
		if(!(isdefined(level.var_36d0a784) && level.var_36d0a784) && level.var_2ddef893 >= level.var_e6b38df)
		{
			level thread zm_powerups::specific_powerup_drop("full_ammo", v_pos);
			level.var_36d0a784 = 1;
		}
	}
}

/*
	Name: function_6ccb6373
	Namespace: zm_island_takeo_fight
	Checksum: 0xE58911B5
	Offset: 0x4BD0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_6ccb6373()
{
	if(!level flag::exists("thrasher_death_mourn_rumble_lock"))
	{
		level flag::init("thrasher_death_mourn_rumble_lock");
	}
	if(!level flag::get("thrasher_death_mourn_rumble_lock"))
	{
		level flag::set("thrasher_death_mourn_rumble_lock");
		level thread function_6addaa9e("pain");
		wait(2);
		level flag::clear("thrasher_death_mourn_rumble_lock");
	}
}

/*
	Name: function_fe7b0c13
	Namespace: zm_island_takeo_fight
	Checksum: 0x3ACECB4
	Offset: 0x4CA0
	Size: 0x33A
	Parameters: 0
	Flags: Linked
*/
function function_fe7b0c13()
{
	level endon(#"hash_ec7f92f6");
	var_d3111274 = "zone_bunker_prison";
	level.var_f0fe245e = 0;
	while(isdefined(level.var_5258ba34) && level.var_5258ba34 && (!(isdefined(level.var_f0fe245e) && level.var_f0fe245e)))
	{
		var_f66cf9d4 = [];
		var_75e586c5 = [];
		foreach(player in level.activeplayers)
		{
			if(player zm_zonemgr::entity_in_zone(var_d3111274, 1))
			{
				array::add(var_f66cf9d4, player);
				continue;
			}
			array::add(var_75e586c5, player);
		}
		if(var_75e586c5.size > 0)
		{
			foreach(player in var_75e586c5)
			{
				if(zm_utility::is_player_valid(player) && player zm_zonemgr::entity_in_active_zone())
				{
					if(!isdefined(player.var_6e61a720))
					{
						player function_75275516();
						wait(randomfloatrange(0.1, 0.5));
					}
				}
			}
		}
		var_c277590a = 0;
		foreach(player in var_f66cf9d4)
		{
			if(player laststand::player_is_in_laststand() && !isdefined(player.var_5942b967))
			{
				if(!level flag::get("solo_game"))
				{
					var_c277590a++;
				}
			}
		}
		if(var_c277590a === var_f66cf9d4.size && var_f66cf9d4.size > 0)
		{
			level.var_f0fe245e = 1;
			break;
		}
		wait(1);
	}
}

/*
	Name: function_75275516
	Namespace: zm_island_takeo_fight
	Checksum: 0x2D1F76FD
	Offset: 0x4FE8
	Size: 0x50C
	Parameters: 0
	Flags: Linked
*/
function function_75275516()
{
	zm_utility::increment_ignoreme();
	playsoundatposition("zmb_bgb_abh_teleport_out", self.origin);
	var_7fcbf214 = struct::get_array("s_takeofight_player_teleport", "targetname");
	s_respawn_point = var_7fcbf214[self.characterindex];
	self hide();
	self setorigin(s_respawn_point.origin);
	self freezecontrols(1);
	v_return_pos = self.origin + vectorscale((0, 0, 1), 60);
	a_ai = getaiteamarray(level.zombie_team);
	a_closest = [];
	ai_closest = undefined;
	if(a_ai.size > 0)
	{
		a_closest = arraysortclosest(a_ai, self.origin);
		foreach(ai in a_closest)
		{
			n_trace_val = ai sightconetrace(v_return_pos, self);
			if(n_trace_val > 0.2)
			{
				ai_closest = ai;
				break;
			}
		}
		if(isdefined(ai_closest))
		{
			self setplayerangles(vectortoangles(ai_closest getcentroid() - v_return_pos));
		}
	}
	self playsound("zmb_bgb_abh_teleport_in");
	wait(0.5);
	self show();
	self util::clientnotify("sndFBM");
	playfx(level._effect["teleport_splash"], self.origin);
	playfx(level._effect["teleport_aoe"], self.origin);
	a_ai = getaiarray();
	a_aoe_ai = arraysortclosest(a_ai, self.origin, a_ai.size, 0, 200);
	foreach(ai in a_aoe_ai)
	{
		if(isactor(ai))
		{
			if(ai.archetype === "zombie")
			{
				playfx(level._effect["teleport_aoe_kill"], ai gettagorigin("j_spineupper"));
			}
			else
			{
				playfx(level._effect["teleport_aoe_kill"], ai.origin);
			}
			ai.marked_for_recycle = 1;
			ai.has_been_damaged_by_player = 0;
			ai dodamage(ai.health + 1000, self.origin, self);
		}
	}
	wait(0.2);
	self freezecontrols(0);
	wait(3);
	zm_utility::decrement_ignoreme();
}

/*
	Name: function_c2fee078
	Namespace: zm_island_takeo_fight
	Checksum: 0x3F472479
	Offset: 0x5500
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_c2fee078()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_9eaf14a2);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: function_9eaf14a2
	Namespace: zm_island_takeo_fight
	Checksum: 0xCD4C4206
	Offset: 0x55C8
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function function_9eaf14a2(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				level thread function_c8af550a();
			}
			case "":
			{
				level thread function_39a206a1();
				return true;
			}
			case "":
			{
				level thread function_eff03897(1);
				return true;
			}
			case "":
			{
				level thread function_eff03897(2);
				return true;
			}
			case "":
			{
				level thread function_eff03897(3);
				return true;
			}
			case "":
			{
				level.var_bbdc1f95.var_e7eb4096 thread function_54d91dfb();
				return true;
			}
			case "":
			{
				level thread function_5ff8dc0c();
				return true;
			}
			case "":
			{
				level.var_c70a4f00 = 20;
				return true;
			}
			case "":
			{
				level.var_c70a4f00 = 0;
				return true;
			}
			case "":
			{
				level thread function_f59a935a();
				return true;
			}
		}
		return false;
	#/
}

/*
	Name: function_39a206a1
	Namespace: zm_island_takeo_fight
	Checksum: 0x293E685B
	Offset: 0x5758
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_39a206a1()
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_eff03897
	Namespace: zm_island_takeo_fight
	Checksum: 0x914D1BF9
	Offset: 0x5788
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function function_eff03897(var_3a0318fc)
{
	/#
		if(level flag::get(""))
		{
			level.var_bbdc1f95.var_62473c4b = level.var_bbdc1f95.var_69943735[var_3a0318fc];
			if(isdefined(level.var_bbdc1f95.var_62473c4b) && (!(isdefined(level.var_bbdc1f95.var_62473c4b.b_dead) && level.var_bbdc1f95.var_62473c4b.b_dead)))
			{
				level.var_bbdc1f95 thread function_c3386633(1);
			}
		}
	#/
}

/*
	Name: function_c8af550a
	Namespace: zm_island_takeo_fight
	Checksum: 0x8F347B3E
	Offset: 0x5850
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_c8af550a()
{
	/#
		if(!level flag::get(""))
		{
			level flag::set("");
			wait(1);
		}
		foreach(var_9c458cf5 in level.var_bbdc1f95.var_69943735)
		{
			var_9c458cf5 function_54d91dfb();
			var_9c458cf5 hide();
		}
		level.var_bbdc1f95.var_e7eb4096 function_54d91dfb();
		level.var_bbdc1f95.var_e7eb4096 hide();
	#/
}

/*
	Name: function_5ff8dc0c
	Namespace: zm_island_takeo_fight
	Checksum: 0xF2BECDAD
	Offset: 0x5990
	Size: 0x334
	Parameters: 0
	Flags: Linked
*/
function function_5ff8dc0c()
{
	/#
		if(level flag::get(""))
		{
			if(!isdefined(level.var_bbdc1f95.var_9326c958))
			{
				level.var_bbdc1f95.var_9326c958 = 1;
			}
			level.var_bbdc1f95.var_9326c958 = !level.var_bbdc1f95.var_9326c958;
			if(isdefined(level.var_bbdc1f95.var_9326c958) && level.var_bbdc1f95.var_9326c958)
			{
				foreach(var_9c458cf5 in level.var_bbdc1f95.var_69943735)
				{
					foreach(var_fb97f73d in var_9c458cf5.var_7168c71c)
					{
						var_fb97f73d show();
					}
					var_9c458cf5 show();
				}
				getent("", "") show();
			}
			else
			{
				foreach(var_9c458cf5 in level.var_bbdc1f95.var_69943735)
				{
					foreach(var_fb97f73d in var_9c458cf5.var_7168c71c)
					{
						var_fb97f73d hide();
					}
					var_9c458cf5 hide();
				}
				getent("", "") hide();
			}
		}
	#/
}

/*
	Name: function_f59a935a
	Namespace: zm_island_takeo_fight
	Checksum: 0xF28D37C7
	Offset: 0x5CD0
	Size: 0x2B2
	Parameters: 0
	Flags: Linked
*/
function function_f59a935a()
{
	/#
		foreach(player in level.activeplayers)
		{
			player.var_df4182b1 = 1;
			player giveweapon(level.weaponriotshield);
			player thread zm_island_skullquest::function_458f50f2();
			wait(1);
			player giveweapon(level.var_a4052592);
			player givemaxammo(level.var_a4052592);
			if(randomint(4) > 2)
			{
				str_gun = array::random(array("", "", "", ""));
			}
			else
			{
				str_gun = array::random(array("", "", "", ""));
			}
			var_f103fd79 = getweapon(str_gun);
			var_83ead5fb = zm_weapons::get_upgrade_weapon(var_f103fd79, 1);
			player giveweapon(var_83ead5fb);
			player switchtoweapon(var_83ead5fb);
			a_str_perks = getarraykeys(level._custom_perks);
			str_perk = array::random(a_str_perks);
			if(!player hasperk(str_perk))
			{
				player zm_perks::give_perk(str_perk, 0);
			}
		}
	#/
}

