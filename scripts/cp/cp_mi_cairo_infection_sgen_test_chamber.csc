// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace cp_mi_cairo_infection_sgen_test_chamber;

/*
	Name: main
	Namespace: cp_mi_cairo_infection_sgen_test_chamber
	Checksum: 0xF07B5103
	Offset: 0x2B8
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function main()
{
	init_clientfields();
}

/*
	Name: init_clientfields
	Namespace: cp_mi_cairo_infection_sgen_test_chamber
	Checksum: 0xB9BD98E3
	Offset: 0x2D8
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("world", "sgen_test_chamber_pod_graphics", 1, 1, "int", &function_8d81452c, 0, 0);
	clientfield::register("world", "sgen_test_chamber_time_lapse", 1, 1, "int", &callback_time_lapse, 0, 0);
	clientfield::register("scriptmover", "sgen_test_guys_decay", 1, 1, "int", &callback_guys_decay, 0, 0);
	clientfield::register("world", "fxanim_hive_cluster_break", 1, 1, "int", &fxanim_hive_cluster_break, 0, 0);
	clientfield::register("world", "fxanim_time_lapse_objects", 1, 1, "int", &fxanim_time_lapse_objects, 0, 0);
}

/*
	Name: fxanim_hive_cluster_break
	Namespace: cp_mi_cairo_infection_sgen_test_chamber
	Checksum: 0x2BE197B4
	Offset: 0x450
	Size: 0xBC
	Parameters: 7
	Flags: Linked
*/
function fxanim_hive_cluster_break(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level thread scene::init("p7_fxanim_cp_infection_sgen_hive_drop_bundle");
	}
	else
	{
		scene::add_scene_func("p7_fxanim_cp_infection_sgen_hive_drop_bundle", &callback_hive_remove, "play");
		level thread scene::play("p7_fxanim_cp_infection_sgen_hive_drop_bundle");
	}
}

/*
	Name: callback_hive_remove
	Namespace: cp_mi_cairo_infection_sgen_test_chamber
	Checksum: 0xB6AFE4B3
	Offset: 0x518
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function callback_hive_remove(a_ent)
{
	wait(8);
	a_ent["sgen_hive_drop"] delete();
}

/*
	Name: function_8d81452c
	Namespace: cp_mi_cairo_infection_sgen_test_chamber
	Checksum: 0xBC2ACDC3
	Offset: 0x558
	Size: 0x202
	Parameters: 7
	Flags: Linked
*/
function function_8d81452c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	testing_pod_ents = getentarray(localclientnum, "dni_testing_pod", "targetname");
	if(oldval != newval)
	{
		if(newval == 1)
		{
			foreach(testing_pod_ent in testing_pod_ents)
			{
				testing_pod_ent attach("p7_sgen_dni_testing_pod_graphics_01_screen", "tag_origin");
				testing_pod_ent attach("p7_sgen_dni_testing_pod_graphics_01_door", "tag_door_anim");
			}
		}
		else
		{
			foreach(testing_pod_ent in testing_pod_ents)
			{
				testing_pod_ent detach("p7_sgen_dni_testing_pod_graphics_01_screen", "tag_origin");
				testing_pod_ent detach("p7_sgen_dni_testing_pod_graphics_01_door", "tag_door_anim");
			}
		}
	}
}

/*
	Name: callback_time_lapse
	Namespace: cp_mi_cairo_infection_sgen_test_chamber
	Checksum: 0xAFD7DEEF
	Offset: 0x768
	Size: 0xF2
	Parameters: 7
	Flags: Linked
*/
function callback_time_lapse(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	testing_pod_ents = getentarray(localclientnum, "dni_testing_pod", "targetname");
	foreach(testing_pod_ent in testing_pod_ents)
	{
		testing_pod_ent thread time_lapse();
	}
}

/*
	Name: time_lapse
	Namespace: cp_mi_cairo_infection_sgen_test_chamber
	Checksum: 0x4F78C9B4
	Offset: 0x868
	Size: 0xB6
	Parameters: 0
	Flags: Linked
*/
function time_lapse()
{
	n_wait_per_cycle = 0.06666667;
	n_growth_increment = 1 / 180;
	n_growth = 0;
	i = 0;
	while(i <= 12)
	{
		self mapshaderconstant(0, 0, "scriptVector0", n_growth, 0, 0, 0);
		n_growth = n_growth + n_growth_increment;
		wait(n_wait_per_cycle);
		i = i + n_wait_per_cycle;
	}
}

/*
	Name: callback_guys_decay
	Namespace: cp_mi_cairo_infection_sgen_test_chamber
	Checksum: 0x4CF5C5F7
	Offset: 0x928
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function callback_guys_decay(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self thread decaymanmaterial(localclientnum);
}

/*
	Name: decaymanmaterial
	Namespace: cp_mi_cairo_infection_sgen_test_chamber
	Checksum: 0x9967399A
	Offset: 0x988
	Size: 0xDA
	Parameters: 1
	Flags: Linked
*/
function decaymanmaterial(localclientnum)
{
	self endon(#"disconnect");
	self endon(#"death");
	self notify(#"decaymanmaterial");
	self endon(#"decaymanmaterial");
	var_9ef7f234 = 1 / 6.5;
	i = 0;
	while(i <= 6.5)
	{
		if(!isdefined(self))
		{
			return;
		}
		self mapshaderconstant(localclientnum, 0, "scriptVector0", i * var_9ef7f234, 0, 0, 0);
		wait(0.01);
		i = i + 0.01;
	}
}

/*
	Name: fxanim_time_lapse_objects
	Namespace: cp_mi_cairo_infection_sgen_test_chamber
	Checksum: 0x3BEDD30B
	Offset: 0xA70
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function fxanim_time_lapse_objects(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		level thread scene::play("p7_fxanim_cp_infection_sgen_time_lapse_objects_bundle");
	}
}

