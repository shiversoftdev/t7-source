// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\cp\cp_mi_cairo_ramses_fx;
#using scripts\cp\cp_mi_cairo_ramses_patch_c;
#using scripts\cp\cp_mi_cairo_ramses_sound;
#using scripts\cp\cp_mi_cairo_ramses_utility;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicles\_quadtank;

#namespace cp_mi_cairo_ramses;

/*
	Name: main
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x12D92210
	Offset: 0x528
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	util::set_streamer_hint_function(&force_streamer, 3);
	init_clientfields();
	cp_mi_cairo_ramses_fx::main();
	cp_mi_cairo_ramses_sound::main();
	callback::on_localclient_connect(&on_player_spawned);
	load::main();
	util::waitforclient(0);
	level.var_7ab81734 = findstaticmodelindexarray("station_shells");
	level thread set_foley_context();
	namespace_98e946e1::function_7403e82b();
}

/*
	Name: on_player_spawned
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x4FC4135F
	Offset: 0x620
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function on_player_spawned(localclientnum)
{
	player = getlocalplayer(localclientnum);
	filter::init_filter_ev_interference(player);
}

/*
	Name: init_clientfields
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x9C35B0C6
	Offset: 0x670
	Size: 0x28C
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("world", "hide_station_miscmodels", 1, 1, "int", &show_hide_staiton_props, 0, 0);
	clientfield::register("world", "turn_on_rotating_fxanim_fans", 1, 1, "int", &turn_on_rotating_fxanim_fans, 0, 0);
	clientfield::register("world", "turn_on_rotating_fxanim_lights", 1, 1, "int", &turn_on_rotating_fxanim_lights, 0, 0);
	clientfield::register("world", "delete_fxanim_fans", 1, 1, "int", &delete_fxanim_fans, 0, 0);
	clientfield::register("toplayer", "nasser_interview_extra_cam", 1, 1, "int", &function_6aab1d81, 0, 0);
	clientfield::register("world", "ramses_station_lamps", 1, 1, "int", &ramses_station_lamps, 0, 0);
	clientfield::register("toplayer", "rap_blood_on_player", 1, 1, "counter", &player_rap_blood_postfx, 0, 0);
	clientfield::register("world", "staging_area_intro", 1, 1, "int", &staging_area_intro, 0, 0);
	clientfield::register("toplayer", "filter_ev_interference_toggle", 1, 1, "int", &filter_ev_interference_toggle, 0, 0);
}

/*
	Name: force_streamer
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x3C23DFF
	Offset: 0x908
	Size: 0xB2
	Parameters: 1
	Flags: Linked
*/
function force_streamer(n_zone)
{
	switch(n_zone)
	{
		case 1:
		{
			break;
		}
		case 2:
		{
			forcestreamxmodel("c_ega_soldier_3_pincushion_fb");
			break;
		}
		case 3:
		{
			forcestreambundle("p_ramses_lift_wing_blockage");
			loadsiegeanim("p7_fxanim_cp_ramses_medical_tarp_cover_s3_sanim");
			loadsiegeanim("p7_fxanim_gp_drone_hunter_swarm_large_sanim");
			break;
		}
		default:
		{
			break;
		}
	}
}

/*
	Name: turn_on_rotating_fxanim_fans
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xB562177E
	Offset: 0x9C8
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function turn_on_rotating_fxanim_fans(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!scene::is_playing("p7_fxanim_gp_fan_digital_small_bundle"))
	{
		level thread scene::play("p7_fxanim_gp_fan_digital_small_bundle");
	}
}

/*
	Name: turn_on_rotating_fxanim_lights
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x552BD05
	Offset: 0xA48
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function turn_on_rotating_fxanim_lights(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!scene::is_playing("p7_fxanim_gp_light_emergency_military_01_bundle"))
	{
		level thread scene::play("p7_fxanim_gp_light_emergency_military_01_bundle");
	}
}

/*
	Name: delete_fxanim_fans
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x35CE2382
	Offset: 0xAC8
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function delete_fxanim_fans(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(scene::is_active("p7_fxanim_gp_fan_digital_small_bundle"))
	{
		level thread scene::stop("p7_fxanim_gp_fan_digital_small_bundle", 1);
	}
}

/*
	Name: staging_area_intro
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xD3E6FBE6
	Offset: 0xB48
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function staging_area_intro(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		level scene::init("p7_fxanim_cp_ramses_tarp_gust_01_bundle");
	}
	else
	{
		level thread scene::play("p7_fxanim_cp_ramses_tarp_gust_01_bundle");
	}
}

/*
	Name: ramses_station_lamps
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xC9952F07
	Offset: 0xBD8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function ramses_station_lamps(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self scene::play("ramses_station_lamps", "targetname");
	}
}

/*
	Name: attach_camera_to_train
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xEEF1C964
	Offset: 0xC50
	Size: 0x11C
	Parameters: 7
	Flags: None
*/
function attach_camera_to_train(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		s_org = struct::get("train_extra_cam", "targetname");
		self.e_extracam = spawn(localclientnum, s_org.origin, "script_origin");
		self.e_extracam.angles = s_org.angles;
		self.e_extracam linkto(self);
		level.e_train_extra_cam = self.e_extracam;
	}
	else if(isdefined(self.e_extracam))
	{
		self.e_extracam delete();
	}
}

/*
	Name: intro_reflection_extracam
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xC5578CAC
	Offset: 0xD78
	Size: 0xF4
	Parameters: 7
	Flags: None
*/
function intro_reflection_extracam(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		/#
			assert(isdefined(level.e_train_extra_cam), "");
		#/
		level.e_train_extra_cam setextracam(0);
		setdvar("r_extracam_custom_aspectratio", 0.769);
	}
	else
	{
		setdvar("r_extracam_custom_aspectratio", -1);
		if(isdefined(level.e_train_extra_cam))
		{
			level.e_train_extra_cam delete();
		}
	}
}

/*
	Name: function_6aab1d81
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x24FAFC41
	Offset: 0xE78
	Size: 0xCC
	Parameters: 7
	Flags: Linked
*/
function function_6aab1d81(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	e_extra_cam = getent(localclientnum, "interview_extra_cam", "targetname");
	if(newval == 1)
	{
		if(isdefined(e_extra_cam))
		{
			e_extra_cam setextracam(0);
		}
	}
	else if(isdefined(e_extra_cam))
	{
		e_extra_cam clearextracam();
	}
}

/*
	Name: player_rap_blood_postfx
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xD8044E97
	Offset: 0xF50
	Size: 0x9C
	Parameters: 7
	Flags: Linked
*/
function player_rap_blood_postfx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	setsoundcontext("foley", "normal");
	if(newval == 1)
	{
		if(!util::is_gib_restricted_build())
		{
			self thread postfx::playpostfxbundle("pstfx_blood_spatter");
		}
	}
}

/*
	Name: show_hide_staiton_props
	Namespace: cp_mi_cairo_ramses
	Checksum: 0xB796AD87
	Offset: 0xFF8
	Size: 0x1B6
	Parameters: 7
	Flags: Linked
*/
function show_hide_staiton_props(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	/#
		assert(isdefined(level.var_7ab81734), "");
	#/
	if(newval == 1)
	{
		foreach(i, model in level.var_7ab81734)
		{
			hidestaticmodel(model);
			if((i % 25) == 0)
			{
				wait(0.016);
			}
		}
	}
	else
	{
		foreach(i, model in level.var_7ab81734)
		{
			unhidestaticmodel(model);
			if((i % 10) == 0)
			{
				wait(0.016);
			}
		}
	}
}

/*
	Name: filter_ev_interference_toggle
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x971040E9
	Offset: 0x11B8
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function filter_ev_interference_toggle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 0)
	{
		filter::disable_filter_ev_interference(self, 0);
	}
	else
	{
		filter::enable_filter_ev_interference(self, 0);
		filter::set_filter_ev_interference_amount(self, 0, 1);
	}
}

/*
	Name: set_foley_context
	Namespace: cp_mi_cairo_ramses
	Checksum: 0x99EC1590
	Offset: 0x1250
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function set_foley_context()
{
}

