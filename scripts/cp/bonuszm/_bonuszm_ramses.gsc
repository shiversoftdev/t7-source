// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_util;
#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\voice\voice_z_ramses;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace namespace_39f1482a;

/*
	Name: init
	Namespace: namespace_39f1482a
	Checksum: 0xEBB031B3
	Offset: 0xBA8
	Size: 0x18C
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
	if(!issubstr(mapname, "ramses"))
	{
		return;
	}
	namespace_c1b94c1e::init_voice();
	level.bzm_ramsesdialogue1callback = &function_dfa3a625;
	level.bzm_ramsesdialogue2callback = &function_5a6208e;
	level.bzm_ramsesdialogue3callback = &function_2ba89af7;
	level.bzm_ramsesdialogue3_1callback = &function_9c47b97f;
	level.bzm_ramsesdialogue3_2callback = &function_2a404a44;
	level.bzm_ramsesdialogue5callback = &function_4799bc81;
	level.bzm_ramsesdialogue5_1callback = &function_9a51f005;
	level.bzm_ramsesdialogue6callback = &function_6d9c36ea;
	level.bzm_ramsesdialogue7callback = &function_939eb153;
	level.bzm_ramsesdialogue7_1callback = &function_4d3f4c83;
	level.bzm_ramsesdialogue8callback = &function_898d5874;
	function_77e3cb91();
}

/*
	Name: function_77e3cb91
	Namespace: namespace_39f1482a
	Checksum: 0x93710A5
	Offset: 0xD40
	Size: 0x24
	Parameters: 0
	Flags: Linked, Private
*/
function private function_77e3cb91()
{
	callback::on_spawned(&function_3e52c274);
}

/*
	Name: function_3e52c274
	Namespace: namespace_39f1482a
	Checksum: 0x99EC1590
	Offset: 0xD70
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_3e52c274()
{
}

/*
	Name: function_dfa3a625
	Namespace: namespace_39f1482a
	Checksum: 0x9089121A
	Offset: 0xD80
	Size: 0x2F4
	Parameters: 0
	Flags: Linked
*/
function function_dfa3a625()
{
	level endon(#"bzm_sceneseqended");
	wait(6);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_pieces_were_comi_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_was_unhing_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_kane_came_with_she_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_weren_t_ready_for_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_this_place_if_the_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_wasn_t_just_the_c_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_between_the_flesh_ea_0");
	namespace_36e5bc12::function_cf21d35c("salm_for_that_very_reason_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_why_what_were_you_r_0");
	namespace_36e5bc12::function_cf21d35c("salm_from_the_creature_yo_0");
	wait(3);
	namespace_36e5bc12::function_ef0ce9fb("plyz_khalil_was_waiting_0");
	namespace_36e5bc12::function_cf21d35c("salm_how_was_khalil_happ_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_wasn_t_a_warm_wel_0");
	namespace_36e5bc12::function_cf21d35c("salm_he_was_angry_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_was_tired_tired_0");
	namespace_36e5bc12::function_cf21d35c("salm_what_was_coming_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_extinction_beat_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_khalil_s_rage_wasn_t_0");
	wait(2);
	namespace_36e5bc12::function_cf21d35c("salm_what_did_you_hope_to_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_how_to_stop_deimos_0");
	wait(3);
	namespace_36e5bc12::function_ef0ce9fb("plyz_kane_asked_what_was_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_dead_were_moving_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_that_set_hendricks_o_0");
	namespace_36e5bc12::function_cf21d35c("salm_how_did_khalil_respo_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_wa_command_was_down_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_khalil_led_us_to_int_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_but_if_we_could_get_0");
}

/*
	Name: function_5a6208e
	Namespace: namespace_39f1482a
	Checksum: 0xC99CAB19
	Offset: 0x1080
	Size: 0x20C
	Parameters: 0
	Flags: Linked
*/
function function_5a6208e()
{
	level endon(#"bzm_sceneseqended");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_certainly_weren_0");
	namespace_36e5bc12::function_cf21d35c("salm_you_say_it_like_i_ha_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_with_no_time_we_nee_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_truth_serum_w_0");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_told_us_to_1");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_asked_about_taylo_0");
	namespace_36e5bc12::function_cf21d35c("salm_and_i_told_him_as_i_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_like_puppets_on_stri_0");
	namespace_36e5bc12::function_cf21d35c("salm_the_undead_are_mindl_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_wanted_to_0");
	namespace_36e5bc12::function_cf21d35c("salm_for_many_years_i_had_0");
	namespace_36e5bc12::function_cf21d35c("salm_but_he_had_been_pull_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_demigoddess_his_0");
	namespace_36e5bc12::function_cf21d35c("salm_a_pawn_in_a_much_lar_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_you_you_told_him_0");
	namespace_36e5bc12::function_cf21d35c("salm_how_does_one_kill_a_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_was_to_send_him_back_0");
	namespace_36e5bc12::function_cf21d35c("salm_exactly_and_the_onl_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_is_to_open_the_ga_0");
	namespace_36e5bc12::function_cf21d35c("salm_as_we_are_doing_now_0");
}

/*
	Name: function_2ba89af7
	Namespace: namespace_39f1482a
	Checksum: 0xCD77BF64
	Offset: 0x1298
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_2ba89af7()
{
	level endon(#"bzm_sceneseqended");
	wait(13);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_assault_on_ramse_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_didn_t_have_time_0");
}

/*
	Name: function_9c47b97f
	Namespace: namespace_39f1482a
	Checksum: 0x2840E34C
	Offset: 0x12F0
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_9c47b97f()
{
	level endon(#"bzm_sceneseqended");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_weren_t_ready_for_1");
}

/*
	Name: function_2a404a44
	Namespace: namespace_39f1482a
	Checksum: 0x371D89C4
	Offset: 0x1328
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_2a404a44()
{
	level endon(#"bzm_sceneseqended");
	wait(5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_cairo_she_was_a_cit_0");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_didn_t_say_it_bu_0");
}

/*
	Name: function_4799bc81
	Namespace: namespace_39f1482a
	Checksum: 0x1AB403DA
	Offset: 0x1380
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_4799bc81()
{
	level endon(#"bzm_sceneseqended");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_was_a_simple_str_0");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_something_knocked_ou_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_turns_out_it_wasn_t_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_cairo_was_no_man_s_l_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_put_him_in_his_pla_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_grabbed_the_spike_0");
}

/*
	Name: function_9a51f005
	Namespace: namespace_39f1482a
	Checksum: 0x48313B65
	Offset: 0x1448
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_9a51f005()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_detonated_the_las_0");
}

/*
	Name: function_6d9c36ea
	Namespace: namespace_39f1482a
	Checksum: 0x4BEF2823
	Offset: 0x1480
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_6d9c36ea()
{
	level endon(#"bzm_sceneseqended");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_our_triggerman_got_h_0");
	level flag::wait_till("arena_defend_detonator_pickup");
	wait(5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_told_hendricks_i_n_0");
	wait(9);
	namespace_36e5bc12::function_ef0ce9fb("plyz_good_thing_hendricks_0");
	wait(26);
	namespace_36e5bc12::function_ef0ce9fb("plyz_khalil_thanked_us_0");
	wait(6);
	namespace_36e5bc12::function_ef0ce9fb("plyz_egyptian_army_comman_0");
}

/*
	Name: function_939eb153
	Namespace: namespace_39f1482a
	Checksum: 0x31FFAAD2
	Offset: 0x1558
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_939eb153()
{
	level endon(#"bzm_sceneseqended");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_gave_hendricks_a_h_0");
	wait(1);
	namespace_36e5bc12::function_cf21d35c("salm_you_went_in_to_save_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_does_that_matter_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_there_were_so_few_of_0");
	wait(0.5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_d_take_it_0");
	wait(1);
	wait(12);
	namespace_36e5bc12::function_cf21d35c("salm_strange_even_with_0");
	namespace_36e5bc12::function_cf21d35c("salm_he_clung_to_life_wit_0");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_turns_out_it_didn_t_0");
	wait(11);
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_didn_t_survive_th_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_safiya_square_was_a_0");
}

/*
	Name: function_4d3f4c83
	Namespace: namespace_39f1482a
	Checksum: 0x6D27BDE7
	Offset: 0x16A0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_4d3f4c83()
{
	level endon(#"bzm_sceneseqended");
	level flag::wait_till("quad_tank_2_spawned");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_didn_t_take_long_0");
	level flag::wait_till("spawn_quad_tank_3");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_was_only_a_matter_0");
}

/*
	Name: function_898d5874
	Namespace: namespace_39f1482a
	Checksum: 0x8AF22037
	Offset: 0x1738
	Size: 0x1F4
	Parameters: 0
	Flags: Linked
*/
function function_898d5874()
{
	level endon(#"bzm_sceneseqended");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_d_cleared_the_pla_0");
	wait(2);
	namespace_36e5bc12::function_cf21d35c("salm_what_did_you_hear_1");
	namespace_36e5bc12::function_ef0ce9fb("plyz_nothing_and_that_wa_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_something_had_taken_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_saw_reinforcement_0");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_got_out_of_the_op_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_and_there_it_was_th_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_kane_came_over_comms_0");
	wait(1.5);
	namespace_36e5bc12::function_cf21d35c("salm_and_hendricks_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_his_mind_was_melting_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_didn_t_like_that_0");
	namespace_36e5bc12::function_cf21d35c("salm_he_attacked_you_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_told_you_it_wasn_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_wasn_t_buying_thi_0");
	namespace_36e5bc12::function_cf21d35c("salm_what_did_he_say_0");
	namespace_36e5bc12::function_b4a3e925("dolo_salim_lies_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_didn_t_think_open_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_are_you_0");
}

