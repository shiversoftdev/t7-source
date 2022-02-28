// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_idgun;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\zm_zod_smashables;
#using scripts\zm\zm_zod_sword_quest;
#using scripts\zm\zm_zod_util;
#using scripts\zm\zm_zod_vo;

#namespace zm_zod_idgun_quest;

/*
	Name: __init__sytem__
	Namespace: zm_zod_idgun_quest
	Checksum: 0xC1DDEEC0
	Offset: 0x600
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_zod_idgun_quest", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_zod_idgun_quest
	Checksum: 0x5D65E931
	Offset: 0x648
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	clientfield::register("world", "add_idgun_to_box", 1, 4, "int");
	clientfield::register("world", "remove_idgun_from_box", 1, 4, "int");
	level flag::init("second_idgun_time");
	for(i = 0; i < 3; i++)
	{
		level flag::init(("idgun_cocoon_" + i) + "_found");
	}
	/#
		level thread idgun_devgui();
		level thread idgun_quest_devgui();
	#/
}

/*
	Name: __main__
	Namespace: zm_zod_idgun_quest
	Checksum: 0xB38D215E
	Offset: 0x798
	Size: 0x1F0
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	a_str_idgun_wpnnames = array("idgun_0", "idgun_1", "idgun_2", "idgun_3");
	level construct_idgun_weapon_array();
	zm_spawner::register_zombie_death_event_callback(&idgun_zombie_death_watch);
	for(i = 0; i < 2; i++)
	{
		level.idgun[i] = spawnstruct();
		level.idgun[i].kill_count = 0;
		level.idgun[i].n_gun_index = i;
		a_str_idgun_wpnnames = array::randomize(a_str_idgun_wpnnames);
		level.idgun[i].str_wpnname = array::pop_front(a_str_idgun_wpnnames);
		zm_weapons::add_limited_weapon(level.idgun[i].str_wpnname, 1);
		for(j = 0; j < level.idgun_weapons.size; j++)
		{
			if(level.idgun[i].str_wpnname == level.idgun_weapons[j].name)
			{
				level.idgun[i].var_e787e99a = j;
				break;
			}
		}
	}
	wait(0.5);
}

/*
	Name: function_e1efbc50
	Namespace: zm_zod_idgun_quest
	Checksum: 0x8B83F51F
	Offset: 0x990
	Size: 0x8A
	Parameters: 1
	Flags: Linked
*/
function function_e1efbc50(var_9727e47e)
{
	if(var_9727e47e != level.weaponnone)
	{
		if(!isdefined(level.idgun_weapons))
		{
			level.idgun_weapons = [];
		}
		else if(!isarray(level.idgun_weapons))
		{
			level.idgun_weapons = array(level.idgun_weapons);
		}
		level.idgun_weapons[level.idgun_weapons.size] = var_9727e47e;
	}
}

/*
	Name: construct_idgun_weapon_array
	Namespace: zm_zod_idgun_quest
	Checksum: 0x283CFE5B
	Offset: 0xA28
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function construct_idgun_weapon_array()
{
	level.idgun_weapons = [];
	function_e1efbc50(getweapon("idgun_0"));
	function_e1efbc50(getweapon("idgun_1"));
	function_e1efbc50(getweapon("idgun_2"));
	function_e1efbc50(getweapon("idgun_3"));
	function_e1efbc50(getweapon("idgun_upgraded_0"));
	function_e1efbc50(getweapon("idgun_upgraded_1"));
	function_e1efbc50(getweapon("idgun_upgraded_2"));
	function_e1efbc50(getweapon("idgun_upgraded_3"));
}

/*
	Name: on_player_connect
	Namespace: zm_zod_idgun_quest
	Checksum: 0x99EC1590
	Offset: 0xB88
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: on_player_spawned
	Namespace: zm_zod_idgun_quest
	Checksum: 0x99EC1590
	Offset: 0xB98
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
}

/*
	Name: function_14e2eca6
	Namespace: zm_zod_idgun_quest
	Checksum: 0xF6C8B2D9
	Offset: 0xBA8
	Size: 0x248
	Parameters: 1
	Flags: Linked
*/
function function_14e2eca6(params)
{
	if(level.round_number < 12)
	{
		return;
	}
	if(self.does_not_count_to_round === 1)
	{
		return;
	}
	if(level flag::get("part_xenomatter" + "_found"))
	{
		return;
	}
	if(isdefined(level.var_689ff92e) && level.var_689ff92e)
	{
		return;
	}
	if(!isplayer(params.eattacker))
	{
		return;
	}
	n_rand = randomfloatrange(0, 1);
	if(n_rand >= 0.1)
	{
		return;
	}
	level.var_689ff92e = 1;
	var_dad4b542 = self getorigin();
	var_72cd7c0a = getclosestpointonnavmesh(var_dad4b542, 500, 0);
	var_ca79e2ce = (var_dad4b542[0], var_dad4b542[1], 0);
	var_dcaa8f8e = (var_72cd7c0a[0], var_72cd7c0a[1], 0);
	if(var_ca79e2ce == var_dcaa8f8e)
	{
		special_craftable_spawn(var_72cd7c0a, "part_xenomatter");
	}
	if(!level flag::get("part_xenomatter" + "_found"))
	{
		mdl_part = level zm_craftables::get_craftable_piece_model("idgun", "part_xenomatter");
		var_55d0f940 = struct::get("safe_place_for_items", "targetname");
		mdl_part.origin = var_55d0f940.origin;
		level.var_689ff92e = 0;
	}
}

/*
	Name: function_c3ffc175
	Namespace: zm_zod_idgun_quest
	Checksum: 0x885CFA7E
	Offset: 0xDF8
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_c3ffc175()
{
	if(level clientfield::get("bm_superbeast"))
	{
		function_6baaa92e();
	}
	else if(self.var_89905c65 !== 1)
	{
		function_44e0f6b4();
	}
}

/*
	Name: function_44e0f6b4
	Namespace: zm_zod_idgun_quest
	Checksum: 0xB1E0CC54
	Offset: 0xE68
	Size: 0x180
	Parameters: 0
	Flags: Linked
*/
function function_44e0f6b4()
{
	if(getdvarint("splitscreen_playerCount") > 2 && (!(isdefined(level.var_5fadf2ff) && level.var_5fadf2ff)))
	{
		function_6893c200();
		return;
	}
	if(isdefined(level.var_359f6a1d) && level.var_359f6a1d)
	{
		return;
	}
	level.var_359f6a1d = 1;
	drop_point = self getorigin();
	drop_point = drop_point + vectorscale((0, 0, 1), 30);
	special_craftable_spawn(drop_point, "part_heart");
	if(!level flag::get("part_heart" + "_found"))
	{
		mdl_part = level zm_craftables::get_craftable_piece_model("idgun", "part_heart");
		var_55d0f940 = struct::get("safe_place_for_items", "targetname");
		mdl_part.origin = var_55d0f940.origin;
		level.var_359f6a1d = 0;
	}
}

/*
	Name: function_6893c200
	Namespace: zm_zod_idgun_quest
	Checksum: 0xAA00D251
	Offset: 0xFF0
	Size: 0x118
	Parameters: 0
	Flags: Linked
*/
function function_6893c200()
{
	level.var_5fadf2ff = 1;
	drop_point = self getorigin();
	drop_point = drop_point + vectorscale((0, 0, 1), 30);
	special_craftable_spawn(drop_point, "part_skeleton");
	if(!level flag::get("part_skeleton" + "_found"))
	{
		mdl_part = level zm_craftables::get_craftable_piece_model("idgun", "part_skeleton");
		var_55d0f940 = struct::get("safe_place_for_items", "targetname");
		mdl_part.origin = var_55d0f940.origin;
		level.var_5fadf2ff = 0;
	}
}

/*
	Name: function_6baaa92e
	Namespace: zm_zod_idgun_quest
	Checksum: 0xBDE7DF9
	Offset: 0x1110
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_6baaa92e()
{
	drop_point = self getorigin();
	drop_point = drop_point + vectorscale((0, 0, 1), 30);
	e_heart = spawn("script_model", drop_point);
	e_heart setmodel("p7_zm_zod_margwa_heart");
	function_a3712047(e_heart);
}

/*
	Name: function_a3712047
	Namespace: zm_zod_idgun_quest
	Checksum: 0x84D2FF7F
	Offset: 0x11B8
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function function_a3712047(e_heart)
{
	width = 128;
	height = 128;
	length = 128;
	e_heart.unitrigger_stub = spawnstruct();
	e_heart.unitrigger_stub.origin = e_heart.origin;
	e_heart.unitrigger_stub.script_unitrigger_type = "unitrigger_box_use";
	e_heart.unitrigger_stub.cursor_hint = "HINT_NOICON";
	e_heart.unitrigger_stub.script_width = width;
	e_heart.unitrigger_stub.script_height = height;
	e_heart.unitrigger_stub.script_length = length;
	e_heart.unitrigger_stub.require_look_at = 0;
	e_heart.unitrigger_stub.prompt_and_visibility_func = &function_12fffd19;
	zm_unitrigger::register_static_unitrigger(e_heart.unitrigger_stub, &function_dd2f6fe3);
	wait(5);
	e_heart delete();
}

/*
	Name: function_12fffd19
	Namespace: zm_zod_idgun_quest
	Checksum: 0x48A555F6
	Offset: 0x1358
	Size: 0x62
	Parameters: 1
	Flags: Linked
*/
function function_12fffd19(player)
{
	b_is_invis = isdefined(player.beastmode) && player.beastmode;
	self setinvisibletoplayer(player, b_is_invis);
	return !b_is_invis;
}

/*
	Name: function_dd2f6fe3
	Namespace: zm_zod_idgun_quest
	Checksum: 0xE5974A5A
	Offset: 0x13C8
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function function_dd2f6fe3()
{
	if(1)
	{
		for(;;)
		{
			self waittill(#"trigger", player);
		}
		for(;;)
		{
		}
		for(;;)
		{
		}
		if(player zm_utility::in_revive_trigger())
		{
		}
		if(player.is_drinking > 0)
		{
		}
		if(!zm_utility::is_player_valid(player))
		{
		}
		player thread zm_audio::create_and_play_dialog("margwa", "heart_pickup");
		level thread function_32d36516(self);
		return;
	}
}

/*
	Name: function_32d36516
	Namespace: zm_zod_idgun_quest
	Checksum: 0x5BA6E2F2
	Offset: 0x1490
	Size: 0xAC
	Parameters: 1
	Flags: Linked
*/
function function_32d36516(e_heart)
{
	foreach(player in level.activeplayers)
	{
		player reviveplayer();
	}
	e_heart delete();
}

/*
	Name: special_craftable_spawn
	Namespace: zm_zod_idgun_quest
	Checksum: 0x32C4DBC8
	Offset: 0x1548
	Size: 0x1EA
	Parameters: 4
	Flags: Linked
*/
function special_craftable_spawn(v_origin, str_part, var_1907d45e = 1, var_6a2f1c3a = 0)
{
	level endon(#"idgun_part_found");
	if(!var_6a2f1c3a)
	{
		mdl_part = level zm_craftables::get_craftable_piece_model("idgun", str_part);
	}
	else
	{
		mdl_part = level zm_craftables::get_craftable_piece_model("second_idgun", str_part);
	}
	mdl_part.origin = v_origin;
	playable_area = getentarray("player_volume", "script_noteworthy");
	valid_drop = 0;
	for(i = 0; i < playable_area.size; i++)
	{
		if(mdl_part istouching(playable_area[i]))
		{
			valid_drop = 1;
		}
	}
	if(!valid_drop)
	{
		mdl_part setinvisibletoall();
		return;
	}
	mdl_part setvisibletoall();
	if(!var_1907d45e)
	{
		return;
	}
	wait(10);
	level thread idgun_part_blinks(mdl_part);
	wait(10);
	mdl_part setinvisibletoall();
	level notify(#"idgun_part_blinks");
}

/*
	Name: idgun_part_blinks
	Namespace: zm_zod_idgun_quest
	Checksum: 0x349E75F1
	Offset: 0x1740
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function idgun_part_blinks(mdl_part)
{
	level notify(#"idgun_part_blinks");
	level endon(#"idgun_part_blinks");
	level endon(#"idgun_part_found");
	while(true)
	{
		mdl_part setinvisibletoall();
		wait(0.5);
		mdl_part setvisibletoall();
		wait(0.5);
	}
}

/*
	Name: idgun_vo
	Namespace: zm_zod_idgun_quest
	Checksum: 0x7EF2E29E
	Offset: 0x17C8
	Size: 0x34
	Parameters: 1
	Flags: None
*/
function idgun_vo(s_idgun)
{
	if(isdefined(s_idgun.is_speaking) && s_idgun.is_speaking)
	{
		return;
	}
}

/*
	Name: idgun_zombie_death_watch
	Namespace: zm_zod_idgun_quest
	Checksum: 0xE6DC09AA
	Offset: 0x1808
	Size: 0x12E
	Parameters: 1
	Flags: Linked
*/
function idgun_zombie_death_watch(attacker)
{
	for(i = 0; i < level.idgun_weapons.size; i++)
	{
		wpn = level.idgun_weapons[i];
		if(!isdefined(self))
		{
			return;
		}
		if(self.damageweapon === wpn)
		{
			idgun = get_idgun_from_owner(self.attacker);
			if(!isdefined(idgun))
			{
				return;
			}
			idgun.kill_count++;
			if(level flag::get("second_idgun_time"))
			{
				return;
			}
			if(idgun.kill_count > 10)
			{
				level flag::set("second_idgun_time");
				idgun.owner zm_zod_vo::function_1a180bd3("vox_idgun_upgrade_ready");
			}
		}
	}
}

/*
	Name: get_idgun_from_owner
	Namespace: zm_zod_idgun_quest
	Checksum: 0x7114FF0D
	Offset: 0x1940
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function get_idgun_from_owner(player)
{
	for(i = 0; i < 2; i++)
	{
		if(level.idgun[i].owner === player)
		{
			return level.idgun[i];
		}
	}
}

/*
	Name: setup_idgun_upgrade_quest
	Namespace: zm_zod_idgun_quest
	Checksum: 0x78A12DB5
	Offset: 0x19B0
	Size: 0x256
	Parameters: 0
	Flags: None
*/
function setup_idgun_upgrade_quest()
{
	level flag::wait_till("second_idgun_time");
	var_ffcd34fb = struct::get_array("idgun_cocoon_point", "targetname");
	if(!isdefined(level.var_a26610f1))
	{
		level.var_a26610f1 = [];
	}
	for(i = 0; i < 3; i++)
	{
		switch(i)
		{
			case 0:
			{
				str_areaname = "theater";
				str_part = "part_heart";
				break;
			}
			case 1:
			{
				str_areaname = "slums";
				str_part = "part_skeleton";
				break;
			}
			case 2:
			{
				str_areaname = "canal";
				str_part = "part_xenomatter";
				break;
			}
		}
		var_c6a8002 = array::filter(var_ffcd34fb, 0, &filter_areaname, str_areaname);
		level.var_a26610f1[i] = array::random(var_c6a8002);
		mdl_cocoon = spawn("script_model", level.var_a26610f1[i].origin);
		mdl_cocoon setmodel("p7_zm_zod_cocoon");
		mdl_cocoon setcandamage(1);
		mdl_cocoon thread function_47867b41(i, str_part);
		if(isdefined(level.idgun[0].owner))
		{
			level.idgun[0].owner thread idgun_proximity_sensor(i);
		}
	}
}

/*
	Name: filter_areaname
	Namespace: zm_zod_idgun_quest
	Checksum: 0xC809A9E1
	Offset: 0x1C10
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function filter_areaname(e_entity, str_areaname)
{
	if(!isdefined(e_entity.script_string) || e_entity.script_string != str_areaname)
	{
		return false;
	}
	return true;
}

/*
	Name: function_47867b41
	Namespace: zm_zod_idgun_quest
	Checksum: 0x6FB988F5
	Offset: 0x1C60
	Size: 0x27A
	Parameters: 2
	Flags: Linked
*/
function function_47867b41(var_3fbc06aa, str_part)
{
	if(1)
	{
		self waittill(#"damage", amount, attacker, direction_vec, point, type, tagname, modelname, partname, weapon);
		level flag::set(("idgun_cocoon_" + var_3fbc06aa) + "_found");
		if((isdefined(zm::is_idgun_damage(weapon)) && zm::is_idgun_damage(weapon)) === 0)
		{
			return;
		}
		self show();
		v_origin = self getorigin();
		direction_vec = (0, 0, -1);
		scale = 8000;
		direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
		trace = bullettrace(v_origin, v_origin + direction_vec, 0, undefined);
		drop_point = trace["position"];
		drop_point = drop_point + vectorscale((0, 0, 1), 10);
		self moveto(drop_point, 1);
		wait(1);
		self hide();
		playfx(level._effect["idgun_cocoon_off"], self.origin);
		special_craftable_spawn(drop_point, str_part, 0, 1);
		return;
	}
}

/*
	Name: idgun_proximity_sensor
	Namespace: zm_zod_idgun_quest
	Checksum: 0xE68DD99B
	Offset: 0x1EE8
	Size: 0x3E4
	Parameters: 1
	Flags: Linked
*/
function idgun_proximity_sensor(var_3fbc06aa)
{
	self endon(#"bleed_out");
	self endon(#"death");
	self endon(#"disconnect");
	var_e610614b = level.var_a26610f1[var_3fbc06aa].origin;
	n_proximity_max_2 = 262144;
	n_proximity_min_2 = 4096;
	n_proximity_diff_2 = n_proximity_max_2 - n_proximity_min_2;
	n_pulse_delay_range = 0.7;
	n_scaled_pulse_delay = undefined;
	n_time_before_next_pulse = undefined;
	n_scale = undefined;
	var_887c2fcb = undefined;
	while(true)
	{
		var_5cc8da3f = self getcurrentweapon();
		weapon_idgun = getweapon(level.idgun[0].str_wpnname);
		if(var_5cc8da3f !== weapon_idgun)
		{
			wait(0.1);
			break;
		}
		var_888da1cf = (var_e610614b[0], var_e610614b[1], self.origin[2]);
		n_dist_2 = distancesquared(self.origin, var_888da1cf);
		if(n_dist_2 <= n_proximity_max_2)
		{
			n_time_before_next_pulse = 1;
			v_eye_origin = self getplayercamerapos();
			v_eye_direction = anglestoforward(self getplayerangles());
			var_744d3805 = vectornormalize(var_e610614b - v_eye_origin);
			n_dot = vectordot(var_744d3805, v_eye_direction);
			if(n_dot > 0.9)
			{
				n_time_before_next_pulse = 0.3;
				n_scale = 1;
				var_887c2fcb = 2;
			}
			else
			{
				if(n_dot <= 0.5)
				{
					n_dot = 0.5;
					n_scale = n_dot / 0.9;
					n_scaled_pulse_delay = n_scale * n_pulse_delay_range;
					n_time_before_next_pulse = 0.3 + n_scaled_pulse_delay;
					var_887c2fcb = 1;
				}
				else
				{
					n_scale = n_dot / 0.9;
					n_scaled_pulse_delay = n_scale * n_pulse_delay_range;
					n_time_before_next_pulse = 0.3 + n_scaled_pulse_delay;
					var_887c2fcb = 1;
				}
			}
		}
		else
		{
			n_time_before_next_pulse = undefined;
		}
		if(level flag::get(("idgun_cocoon_" + var_3fbc06aa) + "_found"))
		{
			return;
		}
		if(isdefined(n_time_before_next_pulse))
		{
			wait(n_time_before_next_pulse);
			self zm_zod_util::set_rumble_to_player(2);
			util::wait_network_frame();
			self zm_zod_util::set_rumble_to_player(0);
		}
		else
		{
			wait(0.05);
		}
	}
}

/*
	Name: give_idgun
	Namespace: zm_zod_idgun_quest
	Checksum: 0xDB675B88
	Offset: 0x22D8
	Size: 0x17C
	Parameters: 1
	Flags: Linked
*/
function give_idgun(n_idgun_level)
{
	if(n_idgun_level == 0)
	{
		wpn_idgun = getweapon(level.idgun[0].str_wpnname);
	}
	else
	{
		wpn_idgun = getweapon(level.idgun[0].str_wpnname);
		wpn_idgun = zm_weapons::get_upgrade_weapon(wpn_idgun, 0);
	}
	/#
		assert(isdefined(wpn_idgun));
	#/
	self zm_weapons::weapon_give(wpn_idgun, 0, 0);
	self switchtoweapon(wpn_idgun);
	if(!isdefined(level.idgun[0].owner))
	{
		var_6aa62cd2 = 0;
	}
	else
	{
		if(!isdefined(level.idgun[1].owner))
		{
			var_6aa62cd2 = 1;
		}
		else
		{
			return;
		}
	}
	level.idgun[var_6aa62cd2].owner = self;
	self zm_zod_vo::function_aca1bc0c(0);
}

/*
	Name: idgun_devgui
	Namespace: zm_zod_idgun_quest
	Checksum: 0xEA757C4E
	Offset: 0x2460
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function idgun_devgui()
{
	/#
		level thread zm_zod_util::setup_devgui_func("", "", 0, &devgui_idgun_give);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &devgui_idgun_give);
		level thread zm_zod_util::setup_devgui_func("", "", 1, &function_8c7ac1b9);
	#/
}

/*
	Name: idgun_quest_devgui
	Namespace: zm_zod_idgun_quest
	Checksum: 0x8AD5C04E
	Offset: 0x2518
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function idgun_quest_devgui()
{
	/#
		level thread zm_zod_util::setup_devgui_func("", "", 0, &function_1f7b4ebf);
	#/
}

/*
	Name: devgui_idgun_give
	Namespace: zm_zod_idgun_quest
	Checksum: 0xF26F30E3
	Offset: 0x2560
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function devgui_idgun_give(n_value)
{
	/#
		foreach(e_player in level.players)
		{
			e_player give_idgun(n_value);
			util::wait_network_frame();
		}
	#/
}

/*
	Name: function_1f7b4ebf
	Namespace: zm_zod_idgun_quest
	Checksum: 0xB3198B8E
	Offset: 0x2618
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function function_1f7b4ebf(n_val)
{
	/#
		level flag::set("");
	#/
}

/*
	Name: function_8c7ac1b9
	Namespace: zm_zod_idgun_quest
	Checksum: 0x3CCD0851
	Offset: 0x2650
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_8c7ac1b9(n_value)
{
	/#
		if(isdefined(level.idgun_draw_debug))
		{
			level.idgun_draw_debug = !level.idgun_draw_debug;
		}
		else
		{
			level.idgun_draw_debug = 1;
		}
	#/
}

