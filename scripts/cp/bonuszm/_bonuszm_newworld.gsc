// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_util;
#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\voice\voice_z_newworld;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace namespace_5242444b;

/*
	Name: init
	Namespace: namespace_5242444b
	Checksum: 0xDBCAA1BB
	Offset: 0xC50
	Size: 0x1DC
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
	if(mapname != "cp_mi_zurich_newworld")
	{
		return;
	}
	namespace_70ee1527::init_voice();
	level.bzm_newworlddialogue1callback = &function_abbfb056;
	level.bzm_newworlddialogue2callback = &function_85bd35ed;
	level.bzm_newworlddialogue2_2callback = &function_3468d5a2;
	level.bzm_newworlddialogue2_3callback = &function_5a6b500b;
	level.bzm_newworlddialogue2_4callback = &function_806dca74;
	level.bzm_newworlddialogue3callback = &function_5fbabb84;
	level.bzm_newworlddialogue4callback = &function_39b8411b;
	level.bzm_newworlddialogue5callback = &function_13b5c6b2;
	level.bzm_newworlddialogue6callback = &function_edb34c49;
	level.bzm_newworlddialogue7callback = &function_c7b0d1e0;
	level.bzm_newworlddialogue8callback = &function_1d5fe07;
	level.bzm_newworlddialogue9callback = &function_dbd3839e;
	level.bzm_newworlddialogue10callback = &function_14ea3df2;
	level.bzm_newworlddialogue11callback = &function_3aecb85b;
	level.bzm_newworlddialogue12callback = &function_c8e54920;
	function_f5c6d60c();
}

/*
	Name: function_f5c6d60c
	Namespace: namespace_5242444b
	Checksum: 0x93CD2126
	Offset: 0xE38
	Size: 0x24
	Parameters: 0
	Flags: Linked, Private
*/
function private function_f5c6d60c()
{
	callback::on_spawned(&function_95d2ec9f);
}

/*
	Name: function_95d2ec9f
	Namespace: namespace_5242444b
	Checksum: 0x36B5C7B3
	Offset: 0xE68
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function function_95d2ec9f()
{
	self allowdoublejump(1);
}

/*
	Name: function_abbfb056
	Namespace: namespace_5242444b
	Checksum: 0xD7F7206E
	Offset: 0xE90
	Size: 0x1C4
	Parameters: 0
	Flags: Linked
*/
function function_abbfb056()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_cf21d35c("salm_think_back_to_2065_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_snow_country_s_0");
	namespace_36e5bc12::function_cf21d35c("salm_what_about_taylor_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_that_s_him_commande_0");
	namespace_36e5bc12::function_cf21d35c("salm_this_was_your_first_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_was_our_first_mis_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_this_this_is_wron_0");
	wait(1.5);
	namespace_36e5bc12::function_cf21d35c("salm_i_m_not_doing_anythi_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_no_stop_make_it_st_0");
	level flag::wait_till("train_terrain_pause");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_dr_salim_what_0");
	namespace_36e5bc12::function_cf21d35c("salm_it_isn_t_it_s_your_0");
	namespace_36e5bc12::function_cf21d35c("salm_this_never_happened_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_then_what_the_hell_a_0");
	namespace_36e5bc12::function_cf21d35c("salm_the_human_mind_is_fr_0");
	wait(1.5);
	namespace_36e5bc12::function_cf21d35c("salm_start_from_the_begin_0");
}

/*
	Name: function_85bd35ed
	Namespace: namespace_5242444b
	Checksum: 0x816A29F7
	Offset: 0x1060
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_85bd35ed()
{
	level endon(#"bzm_sceneseqended");
	wait(0.25);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_raid_there_wa_0");
	namespace_36e5bc12::function_cf21d35c("salm_stop_relax_don_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_taylor_he_told_us_t_0");
	namespace_36e5bc12::function_cf21d35c("salm_who_s_that_with_tayl_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_that_s_sebastian_dia_0");
	namespace_36e5bc12::function_cf21d35c("salm_the_man_who_would_di_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_yeah_but_that_was_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_they_were_so_relaxed_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_if_we_were_gonna_lea_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_for_him_it_was_just_0");
}

/*
	Name: function_3468d5a2
	Namespace: namespace_5242444b
	Checksum: 0x626A1AA7
	Offset: 0x1188
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_3468d5a2()
{
	level endon(#"bzm_sceneseqended");
	level flag::wait_till("init_wallrun_tutorial");
	namespace_36e5bc12::function_ef0ce9fb("plyz_what_are_these_drops_0");
	namespace_36e5bc12::function_cf21d35c("salm_it_s_your_mind_tryin_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_still_have_to_get_0");
}

/*
	Name: function_5a6b500b
	Namespace: namespace_5242444b
	Checksum: 0xC05B37C7
	Offset: 0x1210
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_5a6b500b()
{
	level endon(#"bzm_sceneseqended");
	wait(3);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_entrance_was_loc_0");
	wait(1);
	namespace_36e5bc12::function_cf21d35c("salm_in_a_way_he_was_acti_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_diaz_wanted_to_see_m_0");
}

/*
	Name: function_806dca74
	Namespace: namespace_5242444b
	Checksum: 0x8823676E
	Offset: 0x1280
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_806dca74()
{
	level endon(#"bzm_sceneseqended");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_cotardist_base_o_0");
}

/*
	Name: function_5fbabb84
	Namespace: namespace_5242444b
	Checksum: 0xE5EA8A44
	Offset: 0x12B8
	Size: 0x18C
	Parameters: 0
	Flags: Linked
*/
function function_5fbabb84()
{
	level endon(#"bzm_sceneseqended");
	wait(6);
	namespace_36e5bc12::function_ef0ce9fb("plyz_dr_salim_what_s_h_0");
	namespace_36e5bc12::function_cf21d35c("salm_stay_with_me_come_b_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_can_t_i_don_t_und_0");
	namespace_36e5bc12::function_cf21d35c("salm_tell_me_what_happene_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_saw_i_don_t_kno_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_what_s_happening_to_0");
	namespace_36e5bc12::function_cf21d35c("salm_it_s_a_lapse_your_m_0");
	namespace_36e5bc12::function_cf21d35c("salm_you_were_saying_the_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_i_diaz_told_0");
	namespace_36e5bc12::function_cf21d35c("salm_had_you_ever_extract_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_no_nothing_can_re_0");
	namespace_36e5bc12::function_cf21d35c("salm_what_did_it_show_you_0");
	wait(0.5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_cotardists_had_a_1");
	wait(0.5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_had_extensive_sec_0");
	namespace_36e5bc12::function_cf21d35c("salm_then_let_s_find_him_0");
}

/*
	Name: function_39b8411b
	Namespace: namespace_5242444b
	Checksum: 0x99EC1590
	Offset: 0x1450
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_39b8411b()
{
}

/*
	Name: function_13b5c6b2
	Namespace: namespace_5242444b
	Checksum: 0x51B4BCA5
	Offset: 0x1460
	Size: 0x102
	Parameters: 0
	Flags: Linked
*/
function function_13b5c6b2()
{
	level endon(#"bzm_sceneseqended");
	wait(5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_didn_t_go_as_plan_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_was_ready_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_had_to_get_after_h_0");
	namespace_36e5bc12::function_cf21d35c("salm_but_it_wasn_t_just_y_0");
	wait(3);
	namespace_36e5bc12::function_ef0ce9fb("plyz_taylor_no_taylor_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_sarah_hall_was_with_0");
	wait(3);
	namespace_36e5bc12::function_ef0ce9fb("plyz_she_d_been_with_tayl_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_today_john_taylor_wa_0");
	wait(1);
}

/*
	Name: function_edb34c49
	Namespace: namespace_5242444b
	Checksum: 0x485DBFBB
	Offset: 0x1570
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_edb34c49()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_this_guy_wasn_t_fuck_0");
}

/*
	Name: function_c7b0d1e0
	Namespace: namespace_5242444b
	Checksum: 0x7DC88BBD
	Offset: 0x15A0
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function function_c7b0d1e0()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_cf21d35c("salm_what_happened_when_y_0");
	wait(0.5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_our_mark_was_bleedin_0");
	namespace_36e5bc12::function_cf21d35c("salm_so_what_did_you_do_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_did_what_hendrick_0");
	namespace_36e5bc12::function_cf21d35c("salm_you_make_it_sound_co_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_have_to_make_it_0");
	namespace_36e5bc12::function_cf21d35c("salm_even_though_it_would_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_even_though_beat_0");
	namespace_36e5bc12::function_cf21d35c("salm_ironic_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hall_standing_there_0");
	wait(0.5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_but_we_do_what_we_ha_0");
	namespace_36e5bc12::function_cf21d35c("salm_that_s_a_heavy_burde_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_if_not_us_than_who_0");
	wait(1);
	namespace_36e5bc12::function_cf21d35c("salm_what_did_you_find_w_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_cotardist_group_0");
	namespace_36e5bc12::function_cf21d35c("salm_information_that_wou_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_yeah_the_greater_0");
	namespace_36e5bc12::function_cf21d35c("salm_and_your_mark_what_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_was_gone_dead_0");
}

/*
	Name: function_1d5fe07
	Namespace: namespace_5242444b
	Checksum: 0x550567F9
	Offset: 0x17A0
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function function_1d5fe07()
{
	level endon(#"bzm_sceneseqended");
	wait(7);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_tunnels_we_tr_0");
	namespace_36e5bc12::function_cf21d35c("salm_who_joined_you_in_th_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_taylor_and_peter_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_and_a_self_proclaime_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_well_if_it_wasn_t_f_0");
	namespace_36e5bc12::function_cf21d35c("salm_at_the_abandoned_ref_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_had_a_pivotal_par_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_knew_the_way_to_t_0");
}

/*
	Name: function_dbd3839e
	Namespace: namespace_5242444b
	Checksum: 0x79029A7B
	Offset: 0x1890
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function function_dbd3839e()
{
	level endon(#"bzm_sceneseqended");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_cotardist_group_1");
	namespace_36e5bc12::function_ef0ce9fb("plyz_they_were_going_to_d_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_taylor_said_there_wa_0");
}

/*
	Name: function_14ea3df2
	Namespace: namespace_5242444b
	Checksum: 0x1D73EFB7
	Offset: 0x18F8
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_14ea3df2()
{
	level endon(#"bzm_sceneseqended");
	wait(5);
	namespace_36e5bc12::function_cf21d35c("salm_good_you_didn_t_eve_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_now_what_happens_0");
	namespace_36e5bc12::function_cf21d35c("salm_now_we_set_things_ri_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_and_by_doing_this_0");
	wait(1);
	namespace_36e5bc12::function_cf21d35c("salm_you_ll_be_able_to_op_0");
}

/*
	Name: function_3aecb85b
	Namespace: namespace_5242444b
	Checksum: 0x1B3B5562
	Offset: 0x1998
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_3aecb85b()
{
	level endon(#"bzm_sceneseqended");
	wait(6);
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_found_the_bomb_car_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_there_there_wasn_0");
	namespace_36e5bc12::function_cf21d35c("salm_so_what_did_you_do_1");
	namespace_36e5bc12::function_ef0ce9fb("plyz_remember_how_we_can_0");
	wait(0.5);
	namespace_36e5bc12::function_cf21d35c("salm_and_you_lived_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_didn_t_know_i_d_ma_0");
}

/*
	Name: function_c8e54920
	Namespace: namespace_5242444b
	Checksum: 0xC458CE0C
	Offset: 0x1A50
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_c8e54920()
{
	level endon(#"bzm_sceneseqended");
	wait(2.5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_no_no_no_no_i_re_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_dr_salim_what_am_i_0");
	wait(0.5);
	namespace_36e5bc12::function_cf21d35c("salm_you_must_let_this_go_0");
	namespace_36e5bc12::function_cf21d35c("salm_relax_come_back_to_0");
}

