// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_dialog;
#using scripts\cp\_util;
#using scripts\cp\bonuszm\_bonuszm;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\voice\voice_z_prologue;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#namespace namespace_a6c5bfea;

/*
	Name: init
	Namespace: namespace_a6c5bfea
	Checksum: 0xA71805C5
	Offset: 0x890
	Size: 0x1C4
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
	if(mapname != "cp_mi_eth_prologue")
	{
		return;
	}
	namespace_babdccbe::init_voice();
	level.bzm_prologuedialogue1callback = &function_da4ce9e5;
	level.bzm_prologuedialogue2callback = &function_4f644e;
	level.bzm_prologuedialogue2_1callback = &function_9d3fff7e;
	level.bzm_prologuedialogue3callback = &function_2651deb7;
	level.bzm_prologuedialogue4callback = &function_1c4085d8;
	level.bzm_prologuedialogue5callback = &function_42430041;
	level.bzm_prologuedialogue5_1callback = &function_a82e9445;
	level.bzm_prologuedialogue5_2callback = &function_ce310eae;
	level.bzm_prologuedialogue5_3callback = &function_f4338917;
	level.bzm_prologuedialogue6callback = &function_68457aaa;
	level.bzm_prologuedialogue6_1callback = &function_8f2579e2;
	level.bzm_prologuedialogue6_2callback = &function_6922ff79;
	level.bzm_prologuedialogue7callback = &function_8e47f513;
	level.bzm_prologuedialogue8callback = &function_84369c34;
	function_6872fad1();
}

/*
	Name: function_6872fad1
	Namespace: namespace_a6c5bfea
	Checksum: 0x3415E4F2
	Offset: 0xA60
	Size: 0x24
	Parameters: 0
	Flags: Linked, Private
*/
function private function_6872fad1()
{
	callback::on_spawned(&function_6122f0b4);
}

/*
	Name: function_6122f0b4
	Namespace: namespace_a6c5bfea
	Checksum: 0x99EC1590
	Offset: 0xA90
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_6122f0b4()
{
}

/*
	Name: function_da4ce9e5
	Namespace: namespace_a6c5bfea
	Checksum: 0x415228BB
	Offset: 0xAA0
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_da4ce9e5()
{
	level endon(#"bzm_sceneseqended");
	wait(10);
	namespace_36e5bc12::function_ef0ce9fb("plyz_with_the_dead_crawli_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_weren_t_deadkille_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_lucky_for_us_there_w_0");
	namespace_36e5bc12::function_cf21d35c("salm_so_you_created_the_d_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_and_taylor_s_team_pr_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_reset_the_dead_sy_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_turns_out_the_undead_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_and_all_we_had_to_do_0");
	wait(11);
	namespace_36e5bc12::function_ef0ce9fb("plyz_unfortunately_we_cou_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_alerted_ta_0");
}

/*
	Name: function_4f644e
	Namespace: namespace_a6c5bfea
	Checksum: 0x34FC8F63
	Offset: 0xBE8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_4f644e()
{
	level endon(#"bzm_sceneseqended");
	wait(7.5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_had_to_move_bish_0");
	wait(36);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_ordered_we_0");
}

/*
	Name: function_9d3fff7e
	Namespace: namespace_a6c5bfea
	Checksum: 0xC7A087F4
	Offset: 0xC48
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_9d3fff7e()
{
	level endon(#"bzm_sceneseqended");
	level flag::wait_till("tower_doors_open");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_crossed_the_tarma_0");
}

/*
	Name: function_2651deb7
	Namespace: namespace_a6c5bfea
	Checksum: 0x32E37B1A
	Offset: 0xCA0
	Size: 0x13C
	Parameters: 0
	Flags: Linked
*/
function function_2651deb7()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_took_out_t_0");
	wait(2);
	namespace_36e5bc12::function_cf21d35c("salm_there_were_still_nrc_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_they_kidnapped_bisho_0");
	wait(3);
	namespace_36e5bc12::function_ef0ce9fb("plyz_they_d_torture_these_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_it_wasn_t_personal_0");
	wait(3);
	namespace_36e5bc12::function_ef0ce9fb("plyz_with_the_secret_out_0");
	wait(1);
	namespace_36e5bc12::function_cf21d35c("salm_you_can_rationalize_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_nothing_about_this_w_0");
	while(!(isdefined(level.minister_located) && level.minister_located))
	{
		wait(0.5);
	}
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_had_been_escorted_0");
}

/*
	Name: function_1c4085d8
	Namespace: namespace_a6c5bfea
	Checksum: 0x2D22B1AA
	Offset: 0xDE8
	Size: 0x154
	Parameters: 0
	Flags: Linked
*/
function function_1c4085d8()
{
	level endon(#"bzm_sceneseqended");
	wait(20);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_told_bisho_0");
	wait(1);
	namespace_36e5bc12::function_cf21d35c("salm_sounds_like_you_were_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_said_for_the_cure_0");
	namespace_36e5bc12::function_cf21d35c("salm_in_a_way_you_and_the_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_our_method_was_diffe_0");
	wait(1);
	level flag::wait_till("khalil_door_breached");
	wait(3);
	namespace_36e5bc12::function_cf21d35c("salm_who_was_inside_the_c_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_lt_zeyad_khalil_me_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_cut_him_do_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_taylor_said_we_didn_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_needed_to_get_mov_0");
}

/*
	Name: function_42430041
	Namespace: namespace_a6c5bfea
	Checksum: 0x73851092
	Offset: 0xF48
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_42430041()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_remaining_nrc_fo_0");
	wait(3);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_d_never_seen_dead_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_wait_a_minute_0");
	namespace_36e5bc12::function_b4a3e925("dolo_do_not_be_deceived_b_0");
	namespace_36e5bc12::function_b4a3e925("dolo_remember_your_pas_0");
	namespace_36e5bc12::function_b4a3e925("dolo_remember_when_you_0");
	namespace_36e5bc12::function_b4a3e925("dolo_remember_the_trut_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_wait_this_is_all_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_why_did_you_tell_me_0");
	namespace_36e5bc12::function_cf21d35c("salm_focus_you_need_to_c_0");
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_were_still_on_poi_0");
}

/*
	Name: function_a82e9445
	Namespace: namespace_a6c5bfea
	Checksum: 0xDB7CBB32
	Offset: 0x1078
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_a82e9445()
{
	level endon(#"bzm_sceneseqended");
	wait(5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hall_grabbed_us_afte_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_she_was_to_take_us_t_0");
}

/*
	Name: function_ce310eae
	Namespace: namespace_a6c5bfea
	Checksum: 0x2783715B
	Offset: 0x10D0
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_ce310eae()
{
	level endon(#"bzm_sceneseqended");
	namespace_36e5bc12::function_ef0ce9fb("plyz_after_the_bridge_we_0");
}

/*
	Name: function_f4338917
	Namespace: namespace_a6c5bfea
	Checksum: 0xDA2DEF48
	Offset: 0x1100
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_f4338917()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_could_hear_the_un_0");
}

/*
	Name: function_68457aaa
	Namespace: namespace_a6c5bfea
	Checksum: 0xAE2A9E56
	Offset: 0x1138
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_68457aaa()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_cf21d35c("salm_you_were_forced_into_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_hendric_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_taylor_said_bishop_w_0");
	wait(2);
	namespace_36e5bc12::function_cf21d35c("salm_what_did_taylor_do_0");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_he_volunteered_to_ta_0");
	wait(5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_hendricks_told_us_to_0");
}

/*
	Name: function_8f2579e2
	Namespace: namespace_a6c5bfea
	Checksum: 0x6E1A4BBF
	Offset: 0x1210
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function function_8f2579e2()
{
	level endon(#"bzm_sceneseqended");
	wait(4);
	namespace_36e5bc12::function_ef0ce9fb("plyz_the_apc_stalled_on_u_0");
	level flag::wait_till("apc_crash");
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_we_came_in_too_fast_0");
}

/*
	Name: function_6922ff79
	Namespace: namespace_a6c5bfea
	Checksum: 0x8CC710F0
	Offset: 0x1288
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_6922ff79()
{
	level endon(#"bzm_sceneseqended");
	wait(2);
	namespace_36e5bc12::function_cf21d35c("salm_what_happened_1");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_airspace_was_comprom_0");
	wait(2);
	namespace_36e5bc12::function_ef0ce9fb("plyz_no_i_can_t_do_this_0");
	namespace_36e5bc12::function_cf21d35c("salm_i_am_sorry_you_must_0");
}

/*
	Name: function_8e47f513
	Namespace: namespace_a6c5bfea
	Checksum: 0x9F8ECB8F
	Offset: 0x1318
	Size: 0xE
	Parameters: 0
	Flags: Linked
*/
function function_8e47f513()
{
	level endon(#"bzm_sceneseqended");
}

/*
	Name: function_84369c34
	Namespace: namespace_a6c5bfea
	Checksum: 0xAF13B70D
	Offset: 0x1330
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_84369c34()
{
	level endon(#"bzm_sceneseqended");
	wait(7.5);
	wait(1);
	namespace_36e5bc12::function_ef0ce9fb("plyz_no_no_no_please_0");
	namespace_36e5bc12::function_cf21d35c("salm_if_you_wish_to_defea_1");
	namespace_36e5bc12::function_ef0ce9fb("plyz_i_should_ve_died_i_0");
	wait(1.5);
	namespace_36e5bc12::function_ef0ce9fb("plyz_that_was_the_day_i_m_0");
}

