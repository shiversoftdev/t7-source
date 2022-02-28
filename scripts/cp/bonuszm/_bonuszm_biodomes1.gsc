// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_util;
#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\voice\voice_z_provocation;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#namespace namespace_3530eac4;

/*
	Name: init
	Namespace: namespace_3530eac4
	Checksum: 0x2E0D034F
	Offset: 0x768
	Size: 0x1BC
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	if(!sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	mapname = getdvarstring("mapname");
	if(mapname == "cp_mi_sing_biodomes" || mapname == "cp_mi_sing_biodomes2")
	{
		namespace_27f0ae11::init_voice();
		level.bzm_biodialogue1callback = &function_30d5fd50;
		level.bzm_biodialogue2callback = &function_a2dd6c8b;
		level.bzm_biodialogue2_2callback = &function_8d77af70;
		level.bzm_biodialogue2_3callback = &function_b37a29d9;
		level.bzm_biodialogue2_4callback = &function_71868de6;
		level.bzm_biodialogue3callback = &function_7cdaf222;
		level.bzm_biodialogue4callback = &function_eee2615d;
		level.bzm_biodialogue5callback = &function_c8dfe6f4;
		level.bzm_biodialogue5_1callback = &function_ed187ea8;
		level.bzm_biodialogue5_2callback = &function_5f1fede3;
		level.bzm_biodialogue5_3callback = &function_391d737a;
		level.bzm_biodialogue5_4callback = &function_ab24e2b5;
		level.bzm_biodialogue6callback = &function_3ae7562f;
		function_f0d84c78();
	}
}

/*
	Name: function_f0d84c78
	Namespace: namespace_3530eac4
	Checksum: 0xDAE52221
	Offset: 0x930
	Size: 0x1B2
	Parameters: 0
	Flags: Linked
*/
function function_f0d84c78()
{
	var_80b8c18d = [];
	array::add(var_80b8c18d, "warehouse");
	array::add(var_80b8c18d, "cloudmountain");
	array::add(var_80b8c18d, "markets1");
	array::add(var_80b8c18d, "markets2");
	foreach(str_area in var_80b8c18d)
	{
		var_9108873 = getent("trig_out_of_bound_" + str_area, "targetname");
		e_clip = getent("player_clip_" + str_area, "targetname");
		if(isdefined(var_9108873))
		{
			var_9108873 delete();
		}
		if(isdefined(e_clip))
		{
			e_clip delete();
		}
	}
}

/*
	Name: function_30d5fd50
	Namespace: namespace_3530eac4
	Checksum: 0x71D3EA7E
	Offset: 0xAF0
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function function_30d5fd50()
{
	level endon(#"bzm_sceneseqended");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_getting_in_was_easy_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_at_the_time_the_biod_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_had_a_cont_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_not_only_that_they_0");
	namespace_36e5bc12::function_cf21d35c("salm_they_had_this_inform_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_they_claimed_to_dan_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_still_didn_t_mean_t_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_but_that_didn_t_chan_0");
	namespace_36e5bc12::function_cf21d35c("salm_you_cannot_blame_you_0");
	namespace_36e5bc12::function_cf21d35c("salm_there_were_powers_in_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_mean_deimos_0");
	namespace_36e5bc12::function_cf21d35c("salm_how_do_you_mean_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_know_that_saying_to_0");
	namespace_36e5bc12::function_cf21d35c("salm_the_goh_siblings_da_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_no_no_no_this_was_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_thing_about_deadkill_0");
}

/*
	Name: function_a2dd6c8b
	Namespace: namespace_3530eac4
	Checksum: 0xAA6C1A73
	Offset: 0xCC0
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_a2dd6c8b()
{
	level endon(#"bzm_sceneseqended");
	wait(6);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_d_worried_about_b_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_became_quickly_ap_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_was_about_to_beco_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_had_to_move_we_h_0");
}

/*
	Name: function_8d77af70
	Namespace: namespace_3530eac4
	Checksum: 0x263ABB85
	Offset: 0xD50
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_8d77af70()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_don_t_know_how_the_0");
}

/*
	Name: function_b37a29d9
	Namespace: namespace_3530eac4
	Checksum: 0x130A7D84
	Offset: 0xD80
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_b37a29d9()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_heard_that_famili_0");
}

/*
	Name: function_71868de6
	Namespace: namespace_3530eac4
	Checksum: 0xD74C61E5
	Offset: 0xDB0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_71868de6()
{
	level endon(#"bzm_sceneseqended");
	wait(6);
	namespace_36e5bc12::function_ef0ce9fb("plyz_with_the_shipping_ya_0");
}

/*
	Name: function_7cdaf222
	Namespace: namespace_3530eac4
	Checksum: 0xED9724CE
	Offset: 0xDE8
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function function_7cdaf222()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_cf21d35c("salm_what_happened_in_the_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_by_the_time_we_got_t_0");
	namespace_36e5bc12::function_cf21d35c("salm_why_did_she_lock_you_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_sounded_crazy_bu_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_tried_to_g_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_could_hear_the_ho_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_but_she_did_have_two_0");
	namespace_36e5bc12::function_cf21d35c("salm_you_cut_off_her_hand_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_took_a_gamble_i_h_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_and_it_did_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_interfaced_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_finding_out_what_goh_0");
}

/*
	Name: function_eee2615d
	Namespace: namespace_3530eac4
	Checksum: 0x25E625FB
	Offset: 0xF60
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_eee2615d()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_extracted_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_our_pick_up_was_in_p_0");
}

/*
	Name: function_c8dfe6f4
	Namespace: namespace_3530eac4
	Checksum: 0xF224F8A2
	Offset: 0xFA8
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_c8dfe6f4()
{
	level endon(#"bzm_sceneseqended");
	wait(8);
	namespace_36e5bc12::function_ef0ce9fb("plyz_our_bird_wasn_t_alon_0");
}

/*
	Name: function_ed187ea8
	Namespace: namespace_3530eac4
	Checksum: 0xDD0A70BE
	Offset: 0xFE0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_ed187ea8()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_with_in_those_flesh_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_had_to_haul_ass_a_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_but_they_weren_t_our_0");
}

/*
	Name: function_5f1fede3
	Namespace: namespace_3530eac4
	Checksum: 0xD5FF2968
	Offset: 0x1058
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_5f1fede3()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_supertree_was_co_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_chatter_confirmed_th_0");
}

/*
	Name: function_391d737a
	Namespace: namespace_3530eac4
	Checksum: 0xA6ED8C8
	Offset: 0x10A8
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function function_391d737a()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_from_the_sound_of_it_0");
	wait(6);
	namespace_36e5bc12::function_ef0ce9fb("plyz_looked_like_we_were_0");
}

/*
	Name: function_ab24e2b5
	Namespace: namespace_3530eac4
	Checksum: 0xB7503599
	Offset: 0x10F8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_ab24e2b5()
{
	level endon(#"bzm_sceneseqended");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_commandeer_0");
	wait(2);
	namespace_36e5bc12::function_cf21d35c("plyz_and_that_hunter_stil_0");
	wait(57);
	namespace_36e5bc12::function_cf21d35c("salm_but_you_escaped_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_our_exfil_was_just_a_0");
	namespace_36e5bc12::function_cf21d35c("salm_what_about_taylor_w_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_nothing_it_had_been_0");
}

/*
	Name: function_3ae7562f
	Namespace: namespace_3530eac4
	Checksum: 0x6EBF487F
	Offset: 0x11C0
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function function_3ae7562f()
{
	level endon(#"bzm_sceneseqended");
}

