// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_util;
#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\voice\voice_z_zurich;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace namespace_cc6db628;

/*
	Name: init
	Namespace: namespace_cc6db628
	Checksum: 0x8ACE922B
	Offset: 0xF50
	Size: 0x34C
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
	if(mapname != "cp_mi_zurich_coalescence")
	{
		return;
	}
	namespace_738cec14::init_voice();
	level.bzm_zurichdialogue1callback = &function_8924576f;
	level.bzm_zurichdialogue1_1callback = &function_465e0207;
	level.bzm_zurichdialogue1_2callback = &function_d45692cc;
	level.bzm_zurichdialogue1_3callback = &function_fa590d35;
	level.bzm_zurichdialogue1_4callback = &function_88519dfa;
	level.bzm_zurichdialogue2callback = &function_171ce834;
	level.bzm_zurichdialogue3callback = &function_3d1f629d;
	level.bzm_zurichdialogue4callback = &function_cb17f362;
	level.bzm_zurichdialogue4_1callback = &function_b80578aa;
	level.bzm_zurichdialogue5callback = &function_f11a6dcb;
	level.bzm_zurichdialogue6callback = &function_7f12fe90;
	level.bzm_zurichdialogue7callback = &function_a51578f9;
	level.bzm_zurichdialogue9callback = &function_b9382ab7;
	level.bzm_zurichdialogue10callback = &function_32beb00d;
	level.bzm_zurichdialogue11callback = &function_cbc35a4;
	level.bzm_zurichdialogue12callback = &function_7ec3a4df;
	level.bzm_zurichdialogue13callback = &function_58c12a76;
	level.bzm_zurichdialogue14callback = &function_9ab4c669;
	level.bzm_zurichdialogue15callback = &function_74b24c00;
	level.bzm_zurichdialogue16callback = &function_e6b9bb3b;
	level.bzm_zurichdialogue17callback = &function_c0b740d2;
	level.bzm_zurichdialogue18callback = &function_62d28355;
	level.bzm_zurichdialogue19callback = &function_3cd008ec;
	level.bzm_zurichdialogue20callback = &function_760a962c;
	level.bzm_zurichdialogue21callback = &function_9c0d1095;
	level.bzm_zurichdialogue22callback = &function_c20f8afe;
	level.bzm_zurichdialogue23callback = &function_e8120567;
	level flag::init("BZM_ZURICHDialogue23");
	level.bzm_zurichdialogue24callback = &function_de00ac88;
	level.bzm_zurichdialogue25callback = &function_40326f1;
	function_6ff1594f();
}

/*
	Name: function_6ff1594f
	Namespace: namespace_cc6db628
	Checksum: 0xC7A9ACAA
	Offset: 0x12A8
	Size: 0x24
	Parameters: 0
	Flags: Linked, Private
*/
function private function_6ff1594f()
{
	callback::on_spawned(&function_cee0476);
}

/*
	Name: function_cee0476
	Namespace: namespace_cc6db628
	Checksum: 0x99EC1590
	Offset: 0x12D8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_cee0476()
{
}

/*
	Name: function_8924576f
	Namespace: namespace_cc6db628
	Checksum: 0x8EF8E17
	Offset: 0x12E8
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_8924576f()
{
	level endon(#"bzm_sceneseqended");
	wait(1);
	namespace_36e5bc12::function_45809471("deim_with_hendricks_as_my_0");
	wait(3);
	namespace_36e5bc12::function_45809471("deim_zurich_was_one_of_th_0");
	wait(2);
	namespace_36e5bc12::function_45809471("deim_i_needed_to_separate_0");
	namespace_36e5bc12::function_45809471("deim_but_before_that_you_1");
}

/*
	Name: function_465e0207
	Namespace: namespace_cc6db628
	Checksum: 0xA346DDA7
	Offset: 0x1378
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_465e0207()
{
	level endon(#"bzm_sceneseqended");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_city_systems_had_0");
}

/*
	Name: function_d45692cc
	Namespace: namespace_cc6db628
	Checksum: 0xD3DD10BD
	Offset: 0x13B0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_d45692cc()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_used_hendricks_d_0");
}

/*
	Name: function_fa590d35
	Namespace: namespace_cc6db628
	Checksum: 0x3D64C6E
	Offset: 0x13E0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_fa590d35()
{
	level endon(#"bzm_sceneseqended");
	wait(5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_and_you_built_yourse_0");
}

/*
	Name: function_88519dfa
	Namespace: namespace_cc6db628
	Checksum: 0x8DBA09A2
	Offset: 0x1418
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_88519dfa()
{
	level endon(#"bzm_sceneseqended");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_by_the_time_we_made_0");
	wait(1);
	namespace_36e5bc12::function_45809471("deim_and_soon_that_too_w_0");
}

/*
	Name: function_171ce834
	Namespace: namespace_cc6db628
	Checksum: 0x818801D
	Offset: 0x1470
	Size: 0x1AC
	Parameters: 0
	Flags: Linked
*/
function function_171ce834()
{
	level endon(#"bzm_sceneseqended");
	wait(12);
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_trapped_us_in_a_0");
	namespace_36e5bc12::function_45809471("deim_61_15_the_virus_tha_0");
	namespace_36e5bc12::function_45809471("deim_and_i_had_enough_to_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_had_triggered_mu_0");
	level flag::wait_till("flag_start_kane_sacrifice_igc");
	wait(6);
	namespace_36e5bc12::function_45809471("deim_and_kane_acted_as_i_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_she_sacrificed_herse_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_but_wait_no_the_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_lied_you_tric_0");
	wait(1);
	namespace_36e5bc12::function_45809471("deim_i_ripped_her_from_yo_0");
	wait(1);
	namespace_36e5bc12::function_45809471("deim_i_won_t_understand_y_0");
	wait(1);
	namespace_36e5bc12::function_45809471("deim_you_tie_yourselves_t_0");
	namespace_36e5bc12::function_45809471("deim_you_give_your_lives_0");
	wait(1);
	namespace_36e5bc12::function_45809471("deim_keep_moving_you_re_0");
}

/*
	Name: function_3d1f629d
	Namespace: namespace_cc6db628
	Checksum: 0xF1A37188
	Offset: 0x1628
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_3d1f629d()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_45809471("deim_do_you_remember_this_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_found_krueger_t_0");
	namespace_36e5bc12::function_45809471("deim_it_was_time_to_open_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_couldn_t_let_you_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_shot_each_other_0");
	namespace_36e5bc12::function_45809471("deim_but_now_you_will_sho_0");
	namespace_36e5bc12::function_45809471("deim_change_your_fate_0");
	namespace_36e5bc12::function_b4a3e925("dolo_let_him_win_e_0");
	namespace_36e5bc12::function_45809471("deim_good_now_sacrifice_0");
	namespace_36e5bc12::function_b4a3e925("dolo_do_as_he_asks_let_h_0");
	namespace_36e5bc12::function_b4a3e925("dolo_offer_yourself_to_hi_0");
}

/*
	Name: function_cb17f362
	Namespace: namespace_cc6db628
	Checksum: 0xF1860B34
	Offset: 0x1758
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function function_cb17f362()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_wait_what_where_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_what_are_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_can_t_i_can_t_h_0");
	namespace_36e5bc12::function_b4a3e925("dolo_humans_have_no_voice_0");
	wait(3);
	namespace_36e5bc12::function_45809471("deim_how_is_this_possible_1");
	namespace_36e5bc12::function_ef0ce9fb("plyz_deimos_what_s_happ_0");
	wait(1);
	namespace_36e5bc12::function_45809471("deim_why_don_t_you_ask_yo_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_he_won_t_speak_0");
	wait(1);
	namespace_36e5bc12::function_45809471("deim_of_course_not_of_co_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_where_is_here_0");
	wait(1);
	namespace_36e5bc12::function_45809471("deim_like_you_don_t_know_1");
}

/*
	Name: function_b80578aa
	Namespace: namespace_cc6db628
	Checksum: 0xAFA7F434
	Offset: 0x18B8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_b80578aa()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_45809471("deim_you_you_did_this_y_0");
	wait(1);
	namespace_36e5bc12::function_45809471("deim_and_yet_we_have_anot_0");
	namespace_36e5bc12::function_45809471("deim_what_are_you_saying_0");
	namespace_36e5bc12::function_45809471("deim_look_at_him_angry_a_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_deimos_i_don_t_know_0");
	namespace_36e5bc12::function_45809471("deim_enough_in_time_i_m_0");
}

/*
	Name: function_f11a6dcb
	Namespace: namespace_cc6db628
	Checksum: 0x99EC1590
	Offset: 0x1970
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_f11a6dcb()
{
}

/*
	Name: function_7f12fe90
	Namespace: namespace_cc6db628
	Checksum: 0x2838440
	Offset: 0x1980
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_7f12fe90()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_hello_who_s_there_0");
	namespace_36e5bc12::function_b4a3e925("dolo_this_is_your_new_hom_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_who_are_you_i_i_0");
	namespace_36e5bc12::function_b4a3e925("dolo_i_am_the_reason_you_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_fun_to_be_had_who_0");
	namespace_36e5bc12::function_b4a3e925("dolo_i_am_dolos_demigodd_1");
}

/*
	Name: function_a51578f9
	Namespace: namespace_cc6db628
	Checksum: 0x9E3D864F
	Offset: 0x1A38
	Size: 0x23C
	Parameters: 0
	Flags: Linked
*/
function function_a51578f9()
{
	level endon(#"bzm_sceneseqended");
	if(isdefined(level.var_a51578f9) && level.var_a51578f9)
	{
		return;
	}
	level.var_a51578f9 = 1;
	wait(4);
	namespace_36e5bc12::function_45809471("deim_and_still_you_live_0");
	namespace_36e5bc12::function_45809471("deim_this_poor_babbling_0");
	namespace_36e5bc12::function_ef0ce9fb("deim_but_how_did_you_send_0");
	namespace_36e5bc12::function_b4a3e925("dolo_she_may_be_mortal_m_0");
	namespace_36e5bc12::function_45809471("deim_no_no_you_th_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_deimos_where_are_yo_0");
	namespace_36e5bc12::function_45809471("deim_i_don_t_know_what_yo_0");
	namespace_36e5bc12::function_45809471("deim_this_poor_soul_didn_0");
	namespace_36e5bc12::function_b4a3e925("dolo_it_wasn_t_her_littl_0");
	namespace_36e5bc12::function_45809471("deim_no_no_that_s_i_0");
	wait(1);
	namespace_36e5bc12::function_b4a3e925("dolo_i_ve_ended_your_litt_0");
	namespace_36e5bc12::function_45809471("deim_no_no_no_no_0");
	wait(1);
	namespace_36e5bc12::function_b4a3e925("dolo_but_but_deimos_i_0");
	namespace_36e5bc12::function_45809471("deim_humanity_was_mine_to_0");
	namespace_36e5bc12::function_b4a3e925("dolo_humanity_will_destro_1");
	namespace_36e5bc12::function_45809471("deim_sister_you_ve_mad_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_taylor_is_that_you_0");
	wait(1);
	namespace_36e5bc12::function_b4a3e925("dolo_it_s_not_taylor_it_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_where_is_he_taking_m_0");
	namespace_36e5bc12::function_b4a3e925("dolo_to_one_of_deimos_he_0");
}

/*
	Name: function_b9382ab7
	Namespace: namespace_cc6db628
	Checksum: 0x210407C4
	Offset: 0x1C80
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function function_b9382ab7()
{
	level endon(#"bzm_sceneseqended");
	wait(4);
	namespace_36e5bc12::function_b4a3e925("dolo_this_cold_world_is_d_1");
	wait(1);
	namespace_36e5bc12::function_b4a3e925("dolo_it_s_outstayed_its_w_0");
	namespace_36e5bc12::function_45809471("deim_you_think_i_will_let_0");
	namespace_36e5bc12::function_b4a3e925("dolo_of_course_you_were_0");
	namespace_36e5bc12::function_45809471("deim_petty_you_dare_ca_0");
}

/*
	Name: function_32beb00d
	Namespace: namespace_cc6db628
	Checksum: 0x67E291AF
	Offset: 0x1D20
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function function_32beb00d()
{
	level endon(#"bzm_sceneseqended");
}

/*
	Name: function_cbc35a4
	Namespace: namespace_cc6db628
	Checksum: 0x35D336AE
	Offset: 0x1D38
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_cbc35a4()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_deimos_dolos_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_taylor_is_anyone_th_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_dolos_where_are_we_0");
	wait(2);
	namespace_36e5bc12::function_b4a3e925("dolo_malum_is_a_realm_bey_0");
}

/*
	Name: function_7ec3a4df
	Namespace: namespace_cc6db628
	Checksum: 0x3CF6E8EC
	Offset: 0x1DD0
	Size: 0x9C
	Parameters: 0
	Flags: Linked
*/
function function_7ec3a4df()
{
	level endon(#"bzm_sceneseqended");
	wait(3);
	namespace_36e5bc12::function_b4a3e925("dolo_i_arrived_on_earth_w_0");
	wait(1);
	namespace_36e5bc12::function_b4a3e925("dolo_dr_salim_and_deimos_0");
	namespace_36e5bc12::function_b4a3e925("dolo_revenge_power_viol_0");
	wait(1);
	namespace_36e5bc12::function_b4a3e925("dolo_and_i_was_comfortabl_0");
	namespace_36e5bc12::function_b4a3e925("dolo_so_i_sat_back_while_0");
}

/*
	Name: function_58c12a76
	Namespace: namespace_cc6db628
	Checksum: 0xEE2B8383
	Offset: 0x1E78
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_58c12a76()
{
	level endon(#"bzm_sceneseqended");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_you_were_kane_0");
	wait(2);
	namespace_36e5bc12::function_b4a3e925("dolo_i_m_not_my_brother_0");
	wait(1);
	namespace_36e5bc12::function_b4a3e925("dolo_go_destroy_the_he_0");
	namespace_36e5bc12::function_45809471("deim_i_will_break_you_ri_0");
}

/*
	Name: function_9ab4c669
	Namespace: namespace_cc6db628
	Checksum: 0x91A6B05B
	Offset: 0x1F08
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function function_9ab4c669()
{
	level endon(#"bzm_sceneseqended");
}

/*
	Name: function_74b24c00
	Namespace: namespace_cc6db628
	Checksum: 0xF7D9C46E
	Offset: 0x1F20
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_74b24c00()
{
	level endon(#"bzm_sceneseqended");
	wait(5);
	namespace_36e5bc12::function_45809471("deim_you_must_realize_the_0");
	namespace_36e5bc12::function_b4a3e925("dolo_ah_but_brother_she_0");
	namespace_36e5bc12::function_45809471("deim_how_could_you_have_k_0");
	namespace_36e5bc12::function_b4a3e925("dolo_because_it_was_i_who_0");
	namespace_36e5bc12::function_45809471("deim_it_s_a_pity_she_won_0");
}

/*
	Name: function_e6b9bb3b
	Namespace: namespace_cc6db628
	Checksum: 0x99226D53
	Offset: 0x1FB8
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_e6b9bb3b()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_b4a3e925("dolo_taylor_found_us_easi_0");
	wait(3);
	namespace_36e5bc12::function_b4a3e925("dolo_deimos_deimos_is_0");
	wait(2);
	namespace_36e5bc12::function_b4a3e925("dolo_in_truth_i_was_bored_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_let_him_destroy_0");
	wait(1);
	namespace_36e5bc12::function_b4a3e925("dolo_it_ll_turn_back_hum_0");
}

/*
	Name: function_c0b740d2
	Namespace: namespace_cc6db628
	Checksum: 0xC091890C
	Offset: 0x2070
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_c0b740d2()
{
	level endon(#"bzm_sceneseqended");
	wait(3);
	namespace_36e5bc12::function_45809471("deim_and_then_what_after_0");
	wait(1);
	namespace_36e5bc12::function_45809471("dolo_no_humanity_is_insa_0");
}

/*
	Name: function_62d28355
	Namespace: namespace_cc6db628
	Checksum: 0xF27D47D4
	Offset: 0x20C8
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function function_62d28355()
{
	level endon(#"bzm_sceneseqended");
}

/*
	Name: function_3cd008ec
	Namespace: namespace_cc6db628
	Checksum: 0x2FE2C4C8
	Offset: 0x20E0
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_3cd008ec()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_b4a3e925("dolo_you_know_if_you_def_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_if_killing_that_fuck_0");
	wait(1);
	namespace_36e5bc12::function_b4a3e925("dolo_girl_after_my_own_he_0");
}

/*
	Name: function_760a962c
	Namespace: namespace_cc6db628
	Checksum: 0x1EB54B96
	Offset: 0x2158
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function function_760a962c()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_b4a3e925("dolo_deimos_did_exactly_a_0");
	wait(3);
	namespace_36e5bc12::function_b4a3e925("dolo_but_to_enslave_human_0");
	wait(2);
	namespace_36e5bc12::function_b4a3e925("dolo_you_know_he_is_not_w_0");
	wait(3);
	namespace_36e5bc12::function_b4a3e925("dolo_you_force_yourself_t_0");
	wait(1);
	namespace_36e5bc12::function_b4a3e925("dolo_which_is_what_humani_0");
}

/*
	Name: function_9c0d1095
	Namespace: namespace_cc6db628
	Checksum: 0x199A4B94
	Offset: 0x2210
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_9c0d1095()
{
	level endon(#"bzm_sceneseqended");
	wait(16);
	namespace_36e5bc12::function_45809471("deim_i_won_t_let_you_do_t_0");
	namespace_36e5bc12::function_b4a3e925("dolo_she_s_burned_your_he_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_what_choice_do_you_h_0");
	namespace_36e5bc12::function_45809471("deim_i_ll_kill_you_i_can_0");
}

/*
	Name: function_c20f8afe
	Namespace: namespace_cc6db628
	Checksum: 0x991F404D
	Offset: 0x2290
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_c20f8afe()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_45809471("deim_why_do_you_fight_0");
	namespace_36e5bc12::function_b4a3e925("dolo_i_ll_hold_him_this_0");
	namespace_36e5bc12::function_b4a3e925("dolo_do_it_kill_him_0");
	namespace_36e5bc12::function_45809471("deim_no_the_throne_is_mi_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_oh_yeah_how_s_this_0");
}

/*
	Name: function_e8120567
	Namespace: namespace_cc6db628
	Checksum: 0x2235B4B4
	Offset: 0x2320
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_e8120567()
{
	level endon(#"bzm_sceneseqended");
	wait(5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_wait_this_is_eart_0");
	namespace_36e5bc12::function_b4a3e925("dolo_they_re_coming_for_y_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_who_is_0");
	namespace_36e5bc12::function_b4a3e925("dolo_my_brothers_my_sist_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_let_them_come_0");
	namespace_36e5bc12::function_b4a3e925("dolo_i_like_the_enthusias_0");
	level flag::set("BZM_ZURICHDialogue23");
}

/*
	Name: function_de00ac88
	Namespace: namespace_cc6db628
	Checksum: 0x9518B892
	Offset: 0x23F0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_de00ac88()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_kill_every_last_o_0");
}

/*
	Name: function_40326f1
	Namespace: namespace_cc6db628
	Checksum: 0xE95FAA2C
	Offset: 0x2428
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function function_40326f1()
{
	level endon(#"bzm_sceneseqended");
	time = 8;
	wait(time);
}

