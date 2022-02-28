// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#using_animtree("zm_castle");

#namespace zm_castle_weap_quest;

/*
	Name: __init__sytem__
	Namespace: zm_castle_weap_quest
	Checksum: 0x62117A76
	Offset: 0x878
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_weap_quest", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_castle_weap_quest
	Checksum: 0xA87E869F
	Offset: 0x8B8
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.var_f302359b = struct::get_array("dragon_position", "targetname");
	clientfield::register("actor", "make_client_clone", 5000, 4, "int", &function_90c151e6, 0, 0);
	for(i = 0; i < level.var_f302359b.size; i++)
	{
		clientfield::register("world", level.var_f302359b[i].script_parameters, 5000, 3, "int", &function_cda3a15d, 0, 0);
	}
	clientfield::register("toplayer", "bow_pickup_fx", 5000, 1, "int", &function_4e75b7c1, 0, 0);
}

/*
	Name: main
	Namespace: zm_castle_weap_quest
	Checksum: 0xA1BD4BC4
	Offset: 0xA00
	Size: 0x6E4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level._effect["bow_spawn_fx"] = "dlc1/castle/fx_plinth_pick_up_base_bow";
	level._effect["mini_dragon_fire"] = "dlc1/castle/fx_dragon_head_mouth_fire_sm";
	level._effect["mini_dragon_eye"] = "dlc1/castle/fx_dragon_head_eye_glow_sm";
	level.var_b86a93ed = "cin_t7_ai_zm_dlc1_dragonhead_static";
	level.var_dd277883 = "cin_t7_ai_zm_dlc1_dragonhead_intro";
	level.var_160f7e80 = "cin_t7_zm_dlc1_dragonhead_depart";
	level.var_a79e1598 = [];
	level.var_a79e1598["dragonhead_1"] = "p7_fxanim_zm_castle_dragon_crumble_undercroft_bundle";
	level.var_a79e1598["dragonhead_2"] = "p7_fxanim_zm_castle_dragon_crumble_courtyard_bundle";
	level.var_a79e1598["dragonhead_3"] = "p7_fxanim_zm_castle_dragon_crumble_greathall_bundle";
	level.var_c7a1f434 = [];
	level.var_c7a1f434["right"] = "cin_t7_ai_zm_dlc1_dragonhead_pre_eat_r";
	level.var_c7a1f434["left"] = "cin_t7_ai_zm_dlc1_dragonhead_pre_eat_l";
	level.var_c7a1f434["front"] = "cin_t7_ai_zm_dlc1_dragonhead_pre_eat_f";
	level.var_c7a1f434["left_2_right"] = "cin_t7_ai_zm_dlc1_dragonhead_pre_eat_l_2_r";
	level.var_c7a1f434["right_2_left"] = "cin_t7_ai_zm_dlc1_dragonhead_pre_eat_r_2_l";
	level.var_977975d2 = [];
	level.var_977975d2["right"] = "cin_t7_ai_zm_dlc1_dragonhead_consume_r";
	level.var_977975d2["left"] = "cin_t7_ai_zm_dlc1_dragonhead_consume_l";
	level.var_977975d2["front"] = "cin_t7_ai_zm_dlc1_dragonhead_consume_f";
	level.var_d198ed8e = [];
	level.var_d198ed8e["right"] = %zm_castle::rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_r;
	level.var_d198ed8e["left"] = %zm_castle::rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_l;
	level.var_d198ed8e["front"] = %zm_castle::rtrg_ai_zm_dlc1_dragonhead_consume_zombie_align_f;
	level.var_93ad1521 = [];
	level.var_93ad1521[0] = "cin_t7_ai_zm_dlc1_dragonhead_idle";
	level.var_93ad1521[1] = "cin_t7_ai_zm_dlc1_dragonhead_idle_b";
	level.var_16db17aa = [];
	level.var_16db17aa[0] = "cin_t7_ai_zm_dlc1_dragonhead_idle_twitch_roar";
	scene::add_scene_func(level.var_93ad1521[0], &function_8cce2397);
	scene::add_scene_func(level.var_93ad1521[1], &function_8cce2397);
	scene::add_scene_func(level.var_16db17aa[0], &function_def5820e);
	level.var_f41bc81e = %zm_castle::ai_zm_dlc1_dragonhead_zombie_impact;
	function_46c9cb0();
	util::waitforallclients();
	wait(1);
	level.var_792780c0 = [];
	level.var_3cc6503b = [];
	level.var_abd9e961 = [];
	players = getlocalplayers();
	for(j = 0; j < players.size; j++)
	{
		level.var_792780c0[j] = [];
		level.var_3cc6503b[j] = [];
		level.var_abd9e961[j] = [];
		for(i = 0; i < level.var_f302359b.size; i++)
		{
			level.var_792780c0[j][level.var_f302359b[i].script_parameters] = getent(j, level.var_f302359b[i].script_label, "targetname");
			level.var_792780c0[j][level.var_f302359b[i].script_parameters] useanimtree($zm_castle);
			level.var_792780c0[j][level.var_f302359b[i].script_parameters] flag::init("dragon_far_right");
			level.var_792780c0[j][level.var_f302359b[i].script_parameters] flag::init("dragon_far_left");
			level.var_792780c0[j][level.var_f302359b[i].script_parameters].var_7d382bfa = 1;
			level.var_3cc6503b[j][level.var_f302359b[i].script_parameters] = getent(j, level.var_f302359b[i].script_friendname, "targetname");
			level.var_3cc6503b[j][level.var_f302359b[i].script_parameters] hide();
			level.var_3cc6503b[j][level.var_f302359b[i].script_parameters] useanimtree($zm_castle);
			level.var_abd9e961[j][level.var_f302359b[i].script_parameters] = getent(j, level.var_f302359b[i].script_label + "_mini", "targetname");
		}
		array::run_all(level.var_abd9e961[j], &function_c9ca8c4b, j);
	}
	level.var_ab74f2fa = 1;
}

/*
	Name: function_cda3a15d
	Namespace: zm_castle_weap_quest
	Checksum: 0x9156A2AB
	Offset: 0x10F0
	Size: 0x5E4
	Parameters: 7
	Flags: Linked
*/
function function_cda3a15d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	while(!isdefined(level.var_ab74f2fa))
	{
		wait(0.05);
	}
	if(newval == 7)
	{
		if(isdefined(level.var_792780c0[localclientnum][fieldname]))
		{
			level.var_792780c0[localclientnum][fieldname] thread function_a5ee5367(localclientnum);
		}
	}
	else
	{
		if(newval == 1)
		{
			level.var_3cc6503b[localclientnum][fieldname] hide();
			if(isdefined(level.var_792780c0[localclientnum][fieldname]))
			{
				level.var_792780c0[localclientnum][fieldname] show();
				level.var_792780c0[localclientnum][fieldname] thread function_2731927f(localclientnum);
				level.var_792780c0[localclientnum][fieldname] scene::play(level.var_dd277883, level.var_792780c0[localclientnum][fieldname]);
			}
		}
		else
		{
			if(newval == 2)
			{
				level.var_3cc6503b[localclientnum][fieldname] hide();
				if(isdefined(level.var_3cc6503b[localclientnum][fieldname].head))
				{
					if(isdefined(level.var_3cc6503b[localclientnum][fieldname].head.hat))
					{
						level.var_3cc6503b[localclientnum][fieldname].head.hat hide();
					}
					level.var_3cc6503b[localclientnum][fieldname].head hide();
				}
				if(isdefined(level.var_792780c0[localclientnum][fieldname]))
				{
					level.var_792780c0[localclientnum][fieldname] show();
					level.var_792780c0[localclientnum][fieldname] thread function_979d2797(localclientnum);
				}
			}
			else
			{
				if(newval == 3 || newval == 5 || newval == 4)
				{
					if(isdefined(level.var_792780c0[localclientnum][fieldname]))
					{
						level.var_792780c0[localclientnum][fieldname] show();
						if(newval == 3)
						{
							level.var_792780c0[localclientnum][fieldname] thread function_4ae89880(level.var_3cc6503b[localclientnum][fieldname], localclientnum, "front");
						}
						else
						{
							if(newval == 4)
							{
								level.var_792780c0[localclientnum][fieldname] thread function_4ae89880(level.var_3cc6503b[localclientnum][fieldname], localclientnum, "right");
							}
							else
							{
								level.var_792780c0[localclientnum][fieldname] thread function_4ae89880(level.var_3cc6503b[localclientnum][fieldname], localclientnum, "left");
							}
						}
					}
				}
				else
				{
					if(newval == 6)
					{
						level.var_3cc6503b[localclientnum][fieldname] hide();
						if(isdefined(level.var_3cc6503b[localclientnum][fieldname].head))
						{
							if(isdefined(level.var_3cc6503b[localclientnum][fieldname].head.hat))
							{
								level.var_3cc6503b[localclientnum][fieldname].head.hat hide();
							}
							level.var_3cc6503b[localclientnum][fieldname].head hide();
						}
						if(isdefined(level.var_792780c0[localclientnum][fieldname]))
						{
							level.var_792780c0[localclientnum][fieldname] show();
							level.var_792780c0[localclientnum][fieldname] thread function_aba7532b(localclientnum, level.var_3cc6503b[localclientnum][fieldname], level.var_abd9e961[localclientnum][fieldname]);
						}
					}
					else if(newval == 0)
					{
						level.var_792780c0[localclientnum][fieldname] thread function_8e438650();
					}
				}
			}
		}
	}
}

/*
	Name: function_2731927f
	Namespace: zm_castle_weap_quest
	Checksum: 0xF06BFB33
	Offset: 0x16E0
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function function_2731927f(localclientnum)
{
	forcestreamxmodel("c_zom_dragonhead_e");
	self function_c54660fa(localclientnum);
	self setmodel("c_zom_dragonhead_e");
	stopforcestreamingxmodel("c_zom_dragonhead_e");
	self thread function_aa74062f(localclientnum);
}

/*
	Name: function_c54660fa
	Namespace: zm_castle_weap_quest
	Checksum: 0x65EFC1B9
	Offset: 0x1778
	Size: 0x208
	Parameters: 1
	Flags: Linked
*/
function function_c54660fa(localclientnum)
{
	n_start_time = gettime();
	n_end_time = n_start_time + (3.6 * 1000);
	var_2f4dbfb7 = n_start_time + (0.5 * 1000);
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 1, 0, n_time);
		}
		if(n_time >= var_2f4dbfb7)
		{
			var_da3d41af = mapfloat(n_start_time, var_2f4dbfb7, 0, 3, var_2f4dbfb7);
		}
		else
		{
			var_da3d41af = mapfloat(n_start_time, var_2f4dbfb7, 0, 3, n_time);
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, var_da3d41af, 0);
		self mapshaderconstant(localclientnum, 0, "scriptVector0", n_shader_value, 0, 0);
		wait(0.01);
	}
}

/*
	Name: function_2ea674b8
	Namespace: zm_castle_weap_quest
	Checksum: 0x46AEC7D
	Offset: 0x1988
	Size: 0x160
	Parameters: 1
	Flags: Linked
*/
function function_2ea674b8(localclientnum)
{
	n_start_time = gettime();
	n_end_time = n_start_time + (7 * 1000);
	b_is_updating = 1;
	while(b_is_updating && isdefined(self))
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 0, 1, n_time);
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector0", n_shader_value, 0, 0);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0);
		wait(0.01);
	}
}

/*
	Name: function_aa74062f
	Namespace: zm_castle_weap_quest
	Checksum: 0x95F0896E
	Offset: 0x1AF0
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function function_aa74062f(localclientnum)
{
	n_start_time = gettime();
	n_end_time = n_start_time + (5 * 1000);
	b_is_updating = 1;
	while(b_is_updating)
	{
		n_time = gettime();
		if(n_time >= n_end_time)
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 0, 2, n_end_time);
			b_is_updating = 0;
		}
		else
		{
			n_shader_value = mapfloat(n_start_time, n_end_time, 0, 2, n_time);
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, n_shader_value, 0);
		wait(0.01);
	}
}

/*
	Name: function_a5ee5367
	Namespace: zm_castle_weap_quest
	Checksum: 0x113AB1A7
	Offset: 0x1C28
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_a5ee5367(localclientnum)
{
	self mapshaderconstant(localclientnum, 0, "scriptVector0", 1, 0, 0);
	self thread scene::play(level.var_b86a93ed, self);
}

/*
	Name: function_979d2797
	Namespace: zm_castle_weap_quest
	Checksum: 0xFD1E4ED3
	Offset: 0x1C88
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function function_979d2797(localclientnum)
{
	self endon(#"hash_4b8a9b1");
	self endon(#"hash_4846b79f");
	self notify(#"hash_8c17cec");
	if(isdefined(self.var_d90397ef) && self.var_d90397ef)
	{
		return;
	}
	self.var_d90397ef = 1;
	while(true)
	{
		var_68e7aa53 = array::random(level.var_93ad1521);
		self scene::play(var_68e7aa53, self);
		var_c5577e8a = array::random(level.var_16db17aa);
		self scene::play(var_c5577e8a, self);
	}
}

/*
	Name: function_90c151e6
	Namespace: zm_castle_weap_quest
	Checksum: 0xB10C46AC
	Offset: 0x1D70
	Size: 0x29E
	Parameters: 7
	Flags: Linked
*/
function function_90c151e6(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(!self hasdobj(localclientnum))
	{
		self util::waittill_dobj(localclientnum);
		wait(0.016);
	}
	while(!isdefined(level.var_ab74f2fa))
	{
		wait(0.05);
	}
	if(!isdefined(self))
	{
		return;
	}
	s_closest = array::get_all_closest(self.origin, level.var_f302359b);
	fieldname = s_closest[0].script_parameters;
	m_body = level.var_3cc6503b[localclientnum][fieldname];
	if(isdefined(m_body))
	{
		m_body delete();
		m_body = gibclientutils::createscriptmodelofentity(localclientnum, self);
		if(issubstr(m_body.model, "skeleton"))
		{
			m_body hidepart(localclientnum, "tag_weapon_left");
			m_body hidepart(localclientnum, "tag_weapon_right");
		}
		m_body gibclientutils::handlegibnotetracks(localclientnum);
		level.var_3cc6503b[localclientnum][fieldname] = m_body;
	}
	m_body useanimtree($zm_castle);
	m_body.origin = self.origin;
	m_body show();
	m_body clearanim(%zm_castle::root, 0.1);
	m_body setanimrestart(level.var_f41bc81e, 1, 0.2, 1);
	n_anim_time = getanimlength(level.var_f41bc81e) / 1;
}

/*
	Name: function_4bdc99a
	Namespace: zm_castle_weap_quest
	Checksum: 0xAADB632A
	Offset: 0x2018
	Size: 0x1BC
	Parameters: 4
	Flags: Linked
*/
function function_4bdc99a(m_body, var_e88629ec, localclientnum, direction)
{
	/#
		iprintlnbold("" + direction);
	#/
	var_3b282900 = level.var_c7a1f434[direction];
	if(var_e88629ec flag::get("dragon_far_left") && direction == "right")
	{
		var_3b282900 = level.var_c7a1f434["left_2_right"];
	}
	else if(var_e88629ec flag::get("dragon_far_right") && direction == "left")
	{
		var_3b282900 = level.var_c7a1f434["right_2_left"];
	}
	s_scenedef = struct::get_script_bundle("scene", var_3b282900);
	var_3c6f5c75 = s_scenedef.objects[0].mainanim;
	m_body unlink();
	m_body show();
	m_body thread function_939ae9de(var_e88629ec, localclientnum, direction, var_3c6f5c75);
	var_e88629ec scene::play(var_3b282900, var_e88629ec);
}

/*
	Name: function_8cce2397
	Namespace: zm_castle_weap_quest
	Checksum: 0x63737E2D
	Offset: 0x21E0
	Size: 0x110
	Parameters: 1
	Flags: Linked
*/
function function_8cce2397(a_ents)
{
	self notify(#"hash_7291a140");
	self endon(#"hash_7291a140");
	self endon(#"hash_4b8a9b1");
	self endon(#"hash_4846b79f");
	while(true)
	{
		self waittillmatch(#"_anim_notify_");
		self flag::set("dragon_far_right");
		self waittillmatch(#"_anim_notify_");
		self flag::clear("dragon_far_right");
		self waittillmatch(#"_anim_notify_");
		self flag::set("dragon_far_left");
		self waittillmatch(#"_anim_notify_");
		self flag::clear("dragon_far_left");
	}
}

/*
	Name: function_def5820e
	Namespace: zm_castle_weap_quest
	Checksum: 0x9FFB944
	Offset: 0x22F8
	Size: 0x110
	Parameters: 1
	Flags: Linked
*/
function function_def5820e(a_ents)
{
	self notify(#"hash_7291a140");
	self endon(#"hash_7291a140");
	self endon(#"hash_4b8a9b1");
	self endon(#"hash_4846b79f");
	while(true)
	{
		self waittillmatch(#"_anim_notify_");
		self flag::set("dragon_far_left");
		self waittillmatch(#"_anim_notify_");
		self flag::clear("dragon_far_left");
		self waittillmatch(#"_anim_notify_");
		self flag::set("dragon_far_right");
		self waittillmatch(#"_anim_notify_");
		self flag::clear("dragon_far_right");
	}
}

/*
	Name: function_939ae9de
	Namespace: zm_castle_weap_quest
	Checksum: 0xD7F1E87B
	Offset: 0x2410
	Size: 0x386
	Parameters: 4
	Flags: Linked
*/
function function_939ae9de(var_e88629ec, localclientnum, direction, var_3c6f5c75)
{
	if(!isdefined(self.var_bbb1ef87))
	{
		self.var_bbb1ef87 = spawn(localclientnum, self gettagorigin("J_SpineLower"), "script_model");
		self.var_bbb1ef87 setmodel("tag_origin");
	}
	self clearanim(%zm_castle::root, 0.2);
	self setanimrestart("ai_zm_dlc1_dragonhead_zombie_rise");
	var_1d199979 = var_e88629ec.origin - self.origin;
	var_6ea7737a = vectorscale(var_1d199979, 0.2);
	self.var_bbb1ef87.angles = vectortoangles(var_1d199979);
	self.var_bbb1ef87 linkto(self);
	wait(0.3);
	if(!isdefined(self))
	{
		return;
	}
	animlength = getanimlength(var_3c6f5c75);
	animlength = animlength - (animlength * var_e88629ec getanimtime(var_3c6f5c75));
	animlength = max(animlength, 0.05);
	self moveto(self.origin + var_6ea7737a, animlength * 0.75, animlength * 0.75, 0);
	var_31e7de73 = var_e88629ec gettagangles("tag_attach");
	self rotateto(var_31e7de73, animlength * 0.75);
	self waittill(#"movedone");
	animlength = getanimlength(var_3c6f5c75);
	animlength = animlength - (animlength * var_e88629ec getanimtime(var_3c6f5c75));
	animlength = max(animlength, 0.05);
	var_6b61dff7 = var_e88629ec gettagorigin("tag_attach");
	self moveto(var_6b61dff7, animlength, animlength, 0);
	self waittill(#"movedone");
	if(!isdefined(self))
	{
		return;
	}
	if(isdefined(self.var_bbb1ef87))
	{
		self.var_bbb1ef87 unlink();
		self.var_bbb1ef87 delete();
		self.var_bbb1ef87 = undefined;
	}
}

/*
	Name: function_4ae89880
	Namespace: zm_castle_weap_quest
	Checksum: 0x9F166A76
	Offset: 0x27A0
	Size: 0x224
	Parameters: 3
	Flags: Linked
*/
function function_4ae89880(body, localclientnum, direction)
{
	self endon(#"hash_8c17cec");
	self endon(#"hash_4846b79f");
	self notify(#"hash_4b8a9b1");
	self.var_d90397ef = 0;
	s_closest = array::get_all_closest(self.origin, level.var_f302359b);
	fieldname = s_closest[0].script_parameters;
	m_body = level.var_3cc6503b[localclientnum][fieldname];
	var_e88629ec = level.var_792780c0[localclientnum][fieldname];
	level function_4bdc99a(m_body, var_e88629ec, localclientnum, direction);
	if(!isdefined(var_e88629ec) || !isdefined(m_body))
	{
		return;
	}
	m_body.animname = "zombie";
	var_e88629ec.animname = "dragon";
	self thread function_badc23de(localclientnum);
	self scene::play(level.var_977975d2[direction], array(m_body, var_e88629ec));
	if(!isdefined(var_e88629ec) || !isdefined(m_body))
	{
		return;
	}
	m_body.animname = "";
	var_e88629ec.animname = "";
	playsound(0, "zmb_weap_wall", var_e88629ec.origin);
	var_e88629ec thread function_979d2797(localclientnum);
}

/*
	Name: function_badc23de
	Namespace: zm_castle_weap_quest
	Checksum: 0xFEC7B7A0
	Offset: 0x29D0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_badc23de(localclientnum)
{
	while(true)
	{
		self waittill(#"bite", note);
		if(note == "blood")
		{
		}
		else
		{
		}
	}
}

/*
	Name: function_aba7532b
	Namespace: zm_castle_weap_quest
	Checksum: 0xB361205C
	Offset: 0x2A30
	Size: 0x18C
	Parameters: 3
	Flags: Linked
*/
function function_aba7532b(localclientnum, body, mini)
{
	if(isdefined(self.var_7d382bfa) && self.var_7d382bfa)
	{
		self notify(#"hash_4846b79f");
		self.var_7d382bfa = undefined;
		var_1656bbd4 = level.var_a79e1598[self.targetname];
		self.var_d90397ef = 0;
		forcestreambundle(level.var_a79e1598[self.targetname]);
		self setmodel("c_zom_dragonhead");
		self thread function_2ea674b8(localclientnum);
		self scene::play(level.var_160f7e80, self);
		mini thread function_63f39fc0(localclientnum);
		self thread scene::play(var_1656bbd4);
		if(isdefined(self))
		{
			self hide();
		}
		stopforcestreamingxmodel("p7_fxanim_zm_castle_dragon_chunks_mod");
		stopforcestreamingxmodel("c_zom_dragonhead");
	}
	else if(isdefined(self))
	{
		self hide();
	}
}

/*
	Name: function_c9ca8c4b
	Namespace: zm_castle_weap_quest
	Checksum: 0x1FAB82B
	Offset: 0x2BC8
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function function_c9ca8c4b(localclientnum)
{
	self mapshaderconstant(localclientnum, 0, "scriptVector0", 1, 0, 0);
}

/*
	Name: function_63f39fc0
	Namespace: zm_castle_weap_quest
	Checksum: 0x3CD014E3
	Offset: 0x2C08
	Size: 0x128
	Parameters: 1
	Flags: Linked
*/
function function_63f39fc0(localclientnum)
{
	forcestreamxmodel("c_zom_dragonhead_small_e");
	self function_c54660fa(localclientnum);
	self setmodel("c_zom_dragonhead_small_e");
	stopforcestreamingxmodel("c_zom_dragonhead_small_e");
	self function_aa74062f(localclientnum);
	playfxontag(localclientnum, level._effect["mini_dragon_eye"], self, "tag_eye_left_fx");
	while(true)
	{
		wait(randomintrange(20, 40));
		playfxontag(localclientnum, level._effect["mini_dragon_fire"], self, "tag_throat_fx");
		wait(randomintrange(3, 5));
	}
}

/*
	Name: function_46c9cb0
	Namespace: zm_castle_weap_quest
	Checksum: 0x8EC37435
	Offset: 0x2D38
	Size: 0x62
	Parameters: 0
	Flags: Linked
*/
function function_46c9cb0()
{
	level.var_9c6cddc9[1] = "c_zom_der_zombie_head1";
	level.var_9c6cddc9[2] = "c_zom_der_zombie_head1";
	level.var_9c6cddc9[3] = "c_zom_der_zombie_head1";
	level.var_9c6cddc9[4] = "c_zom_der_zombie_head1";
}

/*
	Name: function_8e438650
	Namespace: zm_castle_weap_quest
	Checksum: 0x8943AC47
	Offset: 0x2DA8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_8e438650()
{
	forcestreamxmodel("p7_fxanim_zm_castle_dragon_chunks_mod");
	forcestreamxmodel("c_zom_dragonhead");
}

/*
	Name: function_4e75b7c1
	Namespace: zm_castle_weap_quest
	Checksum: 0x784F4360
	Offset: 0x2DE8
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function function_4e75b7c1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		exploder::exploder("lgt_bow_family");
	}
	else
	{
		exploder::stop_exploder("lgt_bow_family");
	}
	var_14ea0734 = struct::get("base_bow_pickup_struct", "targetname");
	if(isdefined(var_14ea0734))
	{
		playfx(localclientnum, level._effect["bow_spawn_fx"], var_14ea0734.origin);
	}
}

