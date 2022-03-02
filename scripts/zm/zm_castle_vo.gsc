// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
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
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_elemental_bow;
#using scripts\zm\_zm_weapons;
#using scripts\zm\craftables\_zm_craftables;

#namespace zm_castle_vo;

/*
	Name: __init__sytem__
	Namespace: zm_castle_vo
	Checksum: 0xDC1A4324
	Offset: 0x1998
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_castle_vo", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_castle_vo
	Checksum: 0x3D027915
	Offset: 0x19D8
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_connect(&on_player_connect);
	callback::on_spawned(&on_player_spawned);
	level.a_e_speakers = [];
	level.var_82118499 = 0;
	level.var_169991e1 = 0;
	level thread function_7884e6b8();
	level thread function_65c13c89();
	level thread function_a1e1ab31();
	level thread function_8d44c804();
	level thread function_9f848cca();
	level thread function_7091d990();
	level thread function_cfd97735();
	level thread function_604361f();
	level thread function_68089900();
	level thread function_1bc76ea3();
	level thread function_fbe2f6cb();
	level.audio_get_mod_type = &custom_get_mod_type;
	level flag::init("story_playing");
}

/*
	Name: on_player_spawned
	Namespace: zm_castle_vo
	Checksum: 0xF4726083
	Offset: 0x1B88
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self.isspeaking = 0;
	self.n_vo_priority = 0;
}

/*
	Name: on_player_connect
	Namespace: zm_castle_vo
	Checksum: 0x99EC1590
	Offset: 0x1BB0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function on_player_connect()
{
}

/*
	Name: function_7884e6b8
	Namespace: zm_castle_vo
	Checksum: 0xFC7B75F0
	Offset: 0x1BC0
	Size: 0x16CE
	Parameters: 0
	Flags: Linked
*/
function function_7884e6b8()
{
	self endon(#"_zombie_game_over");
	level.var_4ea3bfd0 = [];
	level.var_4ea3bfd0[0][0] = array("vox_plr_0_round1_start_0", "vox_plr_2_round1_start_0");
	level.var_4ea3bfd0[0][1] = array("vox_plr_0_round1_end_0", "vox_plr_2_round1_end_0");
	level.var_4ea3bfd0[0][2] = array("vox_plr_0_round2_end_0", "vox_plr_2_round2_end_0");
	level.var_4ea3bfd0[1][0] = array("vox_plr_1_round1_start_0", "vox_plr_2_round1_start_0");
	level.var_4ea3bfd0[1][1] = array("vox_plr_1_round1_end_0", "vox_plr_2_round1_end_0");
	level.var_4ea3bfd0[1][2] = array("vox_plr_1_round2_end_0", "vox_plr_2_round2_end_0");
	level.var_4ea3bfd0[3][0] = array("vox_plr_3_round1_start_0", "vox_plr_2_round1_start_0");
	level.var_4ea3bfd0[3][1] = array("vox_plr_3_round1_end_0", "vox_plr_2_round1_end_0");
	level.var_4ea3bfd0[3][2] = array("vox_plr_3_round2_end_0", "vox_plr_2_round2_end_0");
	level.var_f8331b71 = [];
	level.var_f8331b71[0] = array(0, 0.5);
	level.var_f8331b71[1] = array(0, 0.5);
	level.var_f8331b71[2] = array(0, 0.5);
	level.var_524d2080 = [];
	level.var_524d2080[0][0] = "vox_grop_groph_2_0";
	level.var_524d2080[0][1][0] = array("vox_plr_2_groph_2_response_0_0", "vox_grop_groph_2_response_1_0", "vox_plr_2_groph_2_response_2_0");
	level.var_524d2080[0][2][0] = array("vox_plr_2_groph_2_response_0_pa_0", "vox_grop_groph_2_response_1_0", "vox_plr_2_groph_2_response_2_pa_0");
	level.var_524d2080[0][3] = undefined;
	level.var_524d2080[1][0] = "vox_grop_groph_1_0";
	level.var_524d2080[1][1][0] = array("vox_plr_2_groph_1_response_0_0", "vox_grop_groph_1_response_1_0", "vox_plr_2_groph_1_response_2_0", "vox_grop_groph_1_response_3_0", "vox_plr_2_groph_1_response_4_0");
	level.var_524d2080[1][2][0] = array("vox_plr_2_groph_1_response_0_pa_0", "vox_grop_groph_1_response_1_0", "vox_plr_2_groph_1_response_2_pa_0", "vox_grop_groph_1_response_3_0", "vox_plr_2_groph_1_response_4_pa_0");
	level.var_524d2080[1][3] = array("vox_plr_", "_groph_1_response_5_0");
	level.var_524d2080[2][0] = "vox_grop_groph_3_0";
	level.var_524d2080[2][1][0] = array("vox_plr_2_groph_3_response_0_0");
	level.var_524d2080[2][2][0] = array("vox_plr_2_groph_3_response_0_pa_0");
	level.var_524d2080[2][3] = array("vox_plr_", "_groph_3_response_1_0");
	level.var_956d74f = [];
	level.var_956d74f[4][0] = array(0.5, 0.5, 0.5);
	level.var_956d74f[5][0] = array(0.5, 0.5, 0.5, 0.5, 0.5);
	level.var_956d74f[6][0] = array(0.5);
	var_38607083 = [];
	var_38607083[0] = array("vox_plr_0_interaction_rich_demp_1_0", "vox_plr_2_interaction_rich_demp_1_1");
	var_38607083[1] = array("vox_plr_2_interaction_rich_demp_2_0", "vox_plr_0_interaction_rich_demp_2_1");
	var_38607083[2] = array("vox_plr_0_interaction_rich_demp_3_0", "vox_plr_2_interaction_rich_demp_3_1");
	var_38607083[3] = array("vox_plr_2_interaction_rich_demp_4_0", "vox_plr_0_interaction_rich_demp_4_1");
	var_38607083[4] = array("vox_plr_2_interaction_rich_demp_5_0", "vox_plr_0_interaction_rich_demp_5_1");
	var_7ff3a3c1 = [];
	var_7ff3a3c1[0] = array(0, 0.5);
	var_7ff3a3c1[1] = array(0, 0.5);
	var_7ff3a3c1[2] = array(0, 0.5);
	var_7ff3a3c1[3] = array(0, 0.5);
	var_7ff3a3c1[4] = array(0, 0.5);
	var_98d3df13 = 0;
	var_69c11398 = [];
	var_69c11398[0] = array("vox_plr_1_interaction_rich_niko_1_0", "vox_plr_2_interaction_rich_niko_1_1");
	var_69c11398[1] = array("vox_plr_1_interaction_rich_niko_2_0", "vox_plr_2_interaction_rich_niko_2_1");
	var_69c11398[2] = array("vox_plr_2_interaction_rich_niko_3_0", "vox_plr_1_interaction_rich_niko_3_1");
	var_69c11398[3] = array("vox_plr_2_interaction_rich_niko_4_0", "vox_plr_1_interaction_rich_niko_4_1");
	var_69c11398[4] = array("vox_plr_2_interaction_rich_niko_5_0", "vox_plr_1_interaction_rich_niko_5_1");
	var_3b4286c8 = [];
	var_3b4286c8[0] = array(0, 0.5);
	var_3b4286c8[1] = array(0, 0.5);
	var_3b4286c8[2] = array(0, 0.5, 0.5);
	var_3b4286c8[3] = array(0, 0.5);
	var_3b4286c8[4] = array(0, 0.5);
	var_f5c2b1e8 = 0;
	var_e2b4828c = [];
	var_e2b4828c[0] = array("vox_plr_3_interaction_rich_takeo_1_0", "vox_plr_2_interaction_rich_takeo_1_1");
	var_e2b4828c[1] = array("vox_plr_3_interaction_rich_takeo_2_0", "vox_plr_2_interaction_rich_takeo_2_1");
	var_e2b4828c[2] = array("vox_plr_3_interaction_rich_takeo_3_0", "vox_plr_2_interaction_rich_takeo_3_1");
	var_e2b4828c[3] = array("vox_plr_3_interaction_rich_takeo_4_0", "vox_plr_2_interaction_rich_takeo_4_1");
	var_e2b4828c[4] = array("vox_plr_2_interaction_rich_takeo_5_0", "vox_plr_3_interaction_rich_takeo_5_1");
	var_4cce0630 = [];
	var_4cce0630[0] = array(0, 0.5);
	var_4cce0630[1] = array(0, 0.5);
	var_4cce0630[2] = array(0, 0.5);
	var_4cce0630[3] = array(0, 0.5);
	var_4cce0630[4] = array(0, 0.5);
	var_9589fa70 = 0;
	var_1f05f8f0 = [];
	var_1f05f8f0[0] = array("vox_plr_0_interaction_demp_niko_1_0", "vox_plr_1_interaction_demp_niko_1_1");
	var_1f05f8f0[1] = array("vox_plr_0_interaction_demp_niko_2_0", "vox_plr_1_interaction_demp_niko_2_1");
	var_1f05f8f0[2] = array("vox_plr_1_interaction_demp_niko_3_0", "vox_plr_0_interaction_demp_niko_3_1");
	var_1f05f8f0[3] = array("vox_plr_0_interaction_demp_niko_4_0", "vox_plr_1_interaction_demp_niko_4_1");
	var_1f05f8f0[4] = array("vox_plr_0_interaction_demp_niko_5_0", "vox_plr_1_interaction_demp_niko_5_1");
	var_3993ba28 = [];
	var_3993ba28[0] = array(0, 0.5);
	var_3993ba28[1] = array(0, 0.5);
	var_3993ba28[2] = array(0, 0.5);
	var_3993ba28[3] = array(0, 0.5);
	var_3993ba28[4] = array(0, 0.5);
	var_ea6d33c8 = 0;
	var_26887a74 = [];
	var_26887a74[0] = array("vox_plr_0_interaction_demp_takeo_1_0", "vox_plr_3_interaction_demp_takeo_1_1");
	var_26887a74[1] = array("vox_plr_0_interaction_demp_takeo_2_0", "vox_plr_3_interaction_demp_takeo_2_1");
	var_26887a74[2] = array("vox_plr_3_interaction_demp_takeo_3_0", "vox_plr_0_interaction_demp_takeo_3_1");
	var_26887a74[3] = array("vox_plr_3_interaction_demp_takeo_4_0", "vox_plr_0_interaction_demp_takeo_4_1");
	var_26887a74[4] = array("vox_plr_0_interaction_demp_takeo_5_0", "vox_plr_3_interaction_demp_takeo_5_1");
	var_52697a10 = [];
	var_52697a10[0] = array(0, 0.5);
	var_52697a10[1] = array(0, 0.5);
	var_52697a10[2] = array(0, 0.5);
	var_52697a10[3] = array(0, 0.5);
	var_52697a10[4] = array(0, 0.5);
	var_b4e2f9d0 = 0;
	var_aeae7aa1 = [];
	var_aeae7aa1[0] = array("vox_plr_1_interaction_niko_takeo_1_0", "vox_plr_3_interaction_niko_takeo_1_1");
	var_aeae7aa1[1] = array("vox_plr_1_interaction_niko_takeo_2_0", "vox_plr_3_interaction_niko_takeo_2_1");
	var_aeae7aa1[2] = array("vox_plr_3_interaction_niko_takeo_3_0", "vox_plr_1_interaction_niko_takeo_3_1");
	var_aeae7aa1[3] = array("vox_plr_3_interaction_niko_takeo_4_0", "vox_plr_1_interaction_niko_takeo_4_1");
	var_aeae7aa1[4] = array("vox_plr_1_interaction_niko_takeo_5_0", "vox_plr_3_interaction_niko_takeo_5_1");
	var_d3757c7 = [];
	var_d3757c7[0] = array(0, 0.5);
	var_d3757c7[1] = array(0, 0.5);
	var_d3757c7[2] = array(0, 0.5);
	var_d3757c7[3] = array(0, 0.5);
	var_d3757c7[4] = array(0, 0.5);
	var_e60d01d = 0;
	level.var_1d8d988e = 0;
	level waittill(#"all_players_spawned");
	level waittill(#"start_of_round");
	function_6b96bf38();
	while(true)
	{
		level waittill(#"end_of_round");
		if(level.round_number == 2)
		{
			function_ef84a69b();
		}
		else
		{
			if(level.round_number == 3)
			{
				function_7d7d3760();
			}
			else
			{
				if(level.var_1d8d988e < 3)
				{
					function_c5237c88();
				}
				else if(level.activeplayers.size > 1)
				{
					n_counter = 0;
					var_261100d2 = undefined;
					n_player_index = randomint(level.activeplayers.size);
					var_e8669 = level.activeplayers[n_player_index];
					while(!zm_utility::is_player_valid(var_e8669) && n_counter < level.activeplayers.size)
					{
						n_player_index = ((n_player_index + 1) < level.activeplayers.size ? n_player_index + 1 : 0);
						var_e8669 = level.activeplayers[n_player_index];
						n_counter++;
					}
					if(zm_utility::is_player_valid(var_e8669))
					{
						var_a68de872 = array::remove_index(level.activeplayers, n_player_index);
						var_a68de872 = array::get_all_closest(var_e8669.origin, var_a68de872, undefined, 4, 900);
						foreach(e_player in var_a68de872)
						{
							if(zm_utility::is_player_valid(e_player))
							{
								var_261100d2 = e_player;
								break;
							}
						}
					}
					if(zm_utility::is_player_valid(var_e8669) && zm_utility::is_player_valid(var_261100d2))
					{
						var_3b5e4c24 = undefined;
						var_123bfae = array(0, 0);
						if(var_e8669.characterindex == 0 && var_261100d2.characterindex == 2 || (var_261100d2.characterindex == 0 && var_e8669.characterindex == 2))
						{
							if(var_98d3df13 < var_38607083.size)
							{
								function_c23e3a71(var_38607083, var_98d3df13, var_7ff3a3c1, 1);
								var_98d3df13++;
							}
						}
						else
						{
							if(var_e8669.characterindex == 2 && var_261100d2.characterindex == 1 || (var_261100d2.characterindex == 2 && var_e8669.characterindex == 1))
							{
								if(var_f5c2b1e8 < var_69c11398.size)
								{
									function_c23e3a71(var_69c11398, var_f5c2b1e8, var_3b4286c8, 1);
									var_f5c2b1e8++;
								}
							}
							else
							{
								if(var_e8669.characterindex == 2 && var_261100d2.characterindex == 3 || (var_261100d2.characterindex == 2 && var_e8669.characterindex == 3))
								{
									if(var_9589fa70 < var_e2b4828c.size)
									{
										function_c23e3a71(var_e2b4828c, var_9589fa70, var_4cce0630, 1);
										var_9589fa70++;
									}
								}
								else
								{
									if(var_e8669.characterindex == 1 && var_261100d2.characterindex == 0 || (var_261100d2.characterindex == 1 && var_e8669.characterindex == 0))
									{
										if(var_ea6d33c8 < var_1f05f8f0.size)
										{
											function_c23e3a71(var_1f05f8f0, var_ea6d33c8, var_3993ba28, 1);
											var_ea6d33c8++;
										}
									}
									else
									{
										if(var_e8669.characterindex == 0 && var_261100d2.characterindex == 3 || (var_261100d2.characterindex == 0 && var_e8669.characterindex == 3))
										{
											if(var_b4e2f9d0 < var_26887a74.size)
											{
												function_c23e3a71(var_26887a74, var_b4e2f9d0, var_52697a10, 1);
												var_b4e2f9d0++;
											}
										}
										else if(var_e8669.characterindex == 1 && var_261100d2.characterindex == 3 || (var_261100d2.characterindex == 1 && var_e8669.characterindex == 3))
										{
											if(var_e60d01d < var_aeae7aa1.size)
											{
												function_c23e3a71(var_aeae7aa1, var_e60d01d, var_d3757c7, 1);
												var_e60d01d++;
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}

/*
	Name: function_218256bd
	Namespace: zm_castle_vo
	Checksum: 0xE62B76EF
	Offset: 0x3298
	Size: 0x16A
	Parameters: 1
	Flags: Linked
*/
function function_218256bd(var_eca8128e)
{
	foreach(player in level.activeplayers)
	{
		if(isdefined(player))
		{
			player.dontspeak = var_eca8128e;
			player clientfield::set_to_player("isspeaking", var_eca8128e);
		}
	}
	if(var_eca8128e)
	{
		foreach(player in level.activeplayers)
		{
			while(isdefined(player) && (isdefined(player.isspeaking) && player.isspeaking))
			{
				wait(0.1);
			}
		}
	}
}

/*
	Name: function_cf8fccfe
	Namespace: zm_castle_vo
	Checksum: 0xDB3D25A8
	Offset: 0x3410
	Size: 0x70
	Parameters: 1
	Flags: None
*/
function function_cf8fccfe(var_eca8128e)
{
	self.dontspeak = var_eca8128e;
	self clientfield::set_to_player("isspeaking", var_eca8128e);
	if(var_eca8128e)
	{
		while(isdefined(self) && (isdefined(self.isspeaking) && self.isspeaking))
		{
			wait(0.1);
		}
	}
}

/*
	Name: function_ff6cc972
	Namespace: zm_castle_vo
	Checksum: 0x83C5542A
	Offset: 0x3488
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function function_ff6cc972()
{
	var_ceb8ae25 = array::random(level.activeplayers);
	while(level.activeplayers.size > 1 && var_ceb8ae25.characterindex == 2)
	{
		var_ceb8ae25 = array::random(level.activeplayers);
	}
	if(var_ceb8ae25.characterindex == 2)
	{
		return undefined;
	}
	return var_ceb8ae25;
}

/*
	Name: function_8b0b26a6
	Namespace: zm_castle_vo
	Checksum: 0x762D88B1
	Offset: 0x3530
	Size: 0x134
	Parameters: 0
	Flags: Linked
*/
function function_8b0b26a6()
{
	var_de84bd3f = [];
	var_ceb8ae25 = function_ff6cc972();
	if(isdefined(var_ceb8ae25))
	{
		if(var_ceb8ae25.characterindex == 1)
		{
			n_index = 2;
		}
		else
		{
			n_index = var_ceb8ae25.characterindex;
		}
		var_49617378 = (("vox_plr_" + var_ceb8ae25.characterindex) + "_time_1_") + n_index;
		if(!isdefined(var_de84bd3f))
		{
			var_de84bd3f = [];
		}
		else if(!isarray(var_de84bd3f))
		{
			var_de84bd3f = array(var_de84bd3f);
		}
		var_de84bd3f[var_de84bd3f.size] = var_49617378;
	}
	wait(1.5);
	if(var_de84bd3f.size > 0)
	{
		function_7aa5324a(var_de84bd3f, undefined, 1);
	}
}

/*
	Name: function_6184b9c1
	Namespace: zm_castle_vo
	Checksum: 0x7E76C3A0
	Offset: 0x3670
	Size: 0x474
	Parameters: 0
	Flags: Linked
*/
function function_6184b9c1()
{
	var_79076ca4 = [];
	var_ceb8ae25 = function_ff6cc972();
	if(isdefined(var_ceb8ae25))
	{
		if(!isdefined(var_79076ca4))
		{
			var_79076ca4 = [];
		}
		else if(!isarray(var_79076ca4))
		{
			var_79076ca4 = array(var_79076ca4);
		}
		var_79076ca4[var_79076ca4.size] = ("vox_plr_" + var_ceb8ae25.characterindex) + "_time_1_response_4_0";
		if(level.has_richtofen)
		{
			if(!isdefined(var_79076ca4))
			{
				var_79076ca4 = [];
			}
			else if(!isarray(var_79076ca4))
			{
				var_79076ca4 = array(var_79076ca4);
			}
			var_79076ca4[var_79076ca4.size] = "vox_plr_2_time_1_response_5_0";
			if(!isdefined(var_79076ca4))
			{
				var_79076ca4 = [];
			}
			else if(!isarray(var_79076ca4))
			{
				var_79076ca4 = array(var_79076ca4);
			}
			var_79076ca4[var_79076ca4.size] = ("vox_plr_" + var_ceb8ae25.characterindex) + "_time_1_response_6_0";
			if(!isdefined(var_79076ca4))
			{
				var_79076ca4 = [];
			}
			else if(!isarray(var_79076ca4))
			{
				var_79076ca4 = array(var_79076ca4);
			}
			var_79076ca4[var_79076ca4.size] = "vox_plr_2_time_1_response_7_0";
		}
		else
		{
			if(!isdefined(var_79076ca4))
			{
				var_79076ca4 = [];
			}
			else if(!isarray(var_79076ca4))
			{
				var_79076ca4 = array(var_79076ca4);
			}
			var_79076ca4[var_79076ca4.size] = "vox_plr_2_time_1_response_5_pa_0";
			if(!isdefined(var_79076ca4))
			{
				var_79076ca4 = [];
			}
			else if(!isarray(var_79076ca4))
			{
				var_79076ca4 = array(var_79076ca4);
			}
			var_79076ca4[var_79076ca4.size] = ("vox_plr_" + var_ceb8ae25.characterindex) + "_time_1_response_6_0";
			if(!isdefined(var_79076ca4))
			{
				var_79076ca4 = [];
			}
			else if(!isarray(var_79076ca4))
			{
				var_79076ca4 = array(var_79076ca4);
			}
			var_79076ca4[var_79076ca4.size] = "vox_plr_2_time_1_response_7_pa_0";
		}
	}
	else
	{
		if(!isdefined(var_79076ca4))
		{
			var_79076ca4 = [];
		}
		else if(!isarray(var_79076ca4))
		{
			var_79076ca4 = array(var_79076ca4);
		}
		var_79076ca4[var_79076ca4.size] = "vox_plr_2_time_1_response_5_0";
		if(!isdefined(var_79076ca4))
		{
			var_79076ca4 = [];
		}
		else if(!isarray(var_79076ca4))
		{
			var_79076ca4 = array(var_79076ca4);
		}
		var_79076ca4[var_79076ca4.size] = "vox_plr_2_time_1_response_7_0";
	}
	if(!isdefined(var_79076ca4))
	{
		var_79076ca4 = [];
	}
	else if(!isarray(var_79076ca4))
	{
		var_79076ca4 = array(var_79076ca4);
	}
	var_79076ca4[var_79076ca4.size] = "vox_grop_groph_additional3_0";
	level thread function_7520820b();
	if(var_79076ca4.size > 0)
	{
		function_7aa5324a(var_79076ca4, undefined, 1);
	}
}

/*
	Name: function_7520820b
	Namespace: zm_castle_vo
	Checksum: 0xC539E2BB
	Offset: 0x3AF0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_7520820b()
{
	level waittill(#"start_of_round");
	if(!level flag::get("death_ray_trap_used"))
	{
		function_897246e4("vox_grop_groph_additional4_0", undefined, 1);
	}
}

/*
	Name: function_44c11f63
	Namespace: zm_castle_vo
	Checksum: 0xFAC1A8CB
	Offset: 0x3B48
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function function_44c11f63()
{
	level.sndvoxoverride = 1;
	var_2e6638a7 = [];
	var_e9d68101 = struct::get("death_ray_button", "targetname");
	var_d808cbab = spawn("script_model", var_e9d68101.origin);
	var_d808cbab playsoundwithnotify("vox_grop_cyro_1_0", "sounddone");
	var_d808cbab waittill(#"sounddone");
	wait(0.75);
	level.sndvoxoverride = 0;
	var_ceb8ae25 = function_ff6cc972();
	if(isdefined(var_ceb8ae25))
	{
		var_49617378 = ("vox_plr_" + var_ceb8ae25.characterindex) + "_cyro_1_response_0_0";
		if(!isdefined(var_2e6638a7))
		{
			var_2e6638a7 = [];
		}
		else if(!isarray(var_2e6638a7))
		{
			var_2e6638a7 = array(var_2e6638a7);
		}
		var_2e6638a7[var_2e6638a7.size] = var_49617378;
	}
	if(level.has_richtofen)
	{
		if(!isdefined(var_2e6638a7))
		{
			var_2e6638a7 = [];
		}
		else if(!isarray(var_2e6638a7))
		{
			var_2e6638a7 = array(var_2e6638a7);
		}
		var_2e6638a7[var_2e6638a7.size] = "vox_plr_2_cyro_1_response_1_0";
	}
	else
	{
		if(!isdefined(var_2e6638a7))
		{
			var_2e6638a7 = [];
		}
		else if(!isarray(var_2e6638a7))
		{
			var_2e6638a7 = array(var_2e6638a7);
		}
		var_2e6638a7[var_2e6638a7.size] = "vox_plr_2_cyro_1_response_1_pa_0";
	}
	if(var_2e6638a7.size > 0)
	{
		function_7aa5324a(var_2e6638a7, undefined, 1);
	}
	var_d808cbab delete();
}

/*
	Name: function_70721c81
	Namespace: zm_castle_vo
	Checksum: 0x28F3053E
	Offset: 0x3DD8
	Size: 0x17C
	Parameters: 0
	Flags: Linked
*/
function function_70721c81()
{
	var_337b3942 = struct::get("mpd_pos", "targetname");
	e_speaker = spawn("script_model", var_337b3942.origin);
	function_8ac5430(1, var_337b3942.origin);
	e_speaker playsound("vox_groph_keeper_intro_sfx");
	e_speaker playsoundwithnotify("vox_grop_keeper_intro_0", "sounddone");
	e_speaker waittill(#"sounddone");
	wait(0.5);
	e_speaker playsoundwithnotify("vox_grop_keeper_intro_1", "sounddone");
	e_speaker waittill(#"sounddone");
	wait(1);
	e_speaker playsoundwithnotify("vox_grop_keeper_intro_2", "sounddone");
	e_speaker waittill(#"sounddone");
	e_speaker delete();
	function_8ac5430();
}

/*
	Name: function_698d2c6b
	Namespace: zm_castle_vo
	Checksum: 0x32F3C7D5
	Offset: 0x3F60
	Size: 0x234
	Parameters: 0
	Flags: Linked
*/
function function_698d2c6b()
{
	var_707e85a7 = [];
	var_ceb8ae25 = function_ff6cc972();
	if(isdefined(var_ceb8ae25))
	{
		var_49617378 = ("vox_plr_" + var_ceb8ae25.characterindex) + "_keeper_1_0";
		if(!isdefined(var_707e85a7))
		{
			var_707e85a7 = [];
		}
		else if(!isarray(var_707e85a7))
		{
			var_707e85a7 = array(var_707e85a7);
		}
		var_707e85a7[var_707e85a7.size] = var_49617378;
	}
	if(level.has_richtofen)
	{
		if(!isdefined(var_707e85a7))
		{
			var_707e85a7 = [];
		}
		else if(!isarray(var_707e85a7))
		{
			var_707e85a7 = array(var_707e85a7);
		}
		var_707e85a7[var_707e85a7.size] = "vox_plr_2_keeper_1_response_0_0";
	}
	else
	{
		if(!isdefined(var_707e85a7))
		{
			var_707e85a7 = [];
		}
		else if(!isarray(var_707e85a7))
		{
			var_707e85a7 = array(var_707e85a7);
		}
		var_707e85a7[var_707e85a7.size] = "vox_plr_2_keeper_1_response_0_pa_0";
	}
	if(!level flag::get("boss_fight_begin"))
	{
		if(!isdefined(var_707e85a7))
		{
			var_707e85a7 = [];
		}
		else if(!isarray(var_707e85a7))
		{
			var_707e85a7 = array(var_707e85a7);
		}
		var_707e85a7[var_707e85a7.size] = "vox_grop_groph_additional5_0";
	}
	if(var_707e85a7.size > 0)
	{
		function_7aa5324a(var_707e85a7, undefined, 1);
	}
}

/*
	Name: function_cbf21c9d
	Namespace: zm_castle_vo
	Checksum: 0xC63AAD7
	Offset: 0x41A0
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_cbf21c9d()
{
	var_7060fdf2 = [];
	var_ceb8ae25 = function_ff6cc972();
	if(isdefined(var_ceb8ae25))
	{
		var_49617378 = ("vox_plr_" + var_ceb8ae25.characterindex) + "_keeper_2_0";
		if(!isdefined(var_7060fdf2))
		{
			var_7060fdf2 = [];
		}
		else if(!isarray(var_7060fdf2))
		{
			var_7060fdf2 = array(var_7060fdf2);
		}
		var_7060fdf2[var_7060fdf2.size] = var_49617378;
	}
	if(level.has_richtofen)
	{
		if(!isdefined(var_7060fdf2))
		{
			var_7060fdf2 = [];
		}
		else if(!isarray(var_7060fdf2))
		{
			var_7060fdf2 = array(var_7060fdf2);
		}
		var_7060fdf2[var_7060fdf2.size] = "vox_plr_2_keeper_2_response_0_0";
	}
	else
	{
		if(!isdefined(var_7060fdf2))
		{
			var_7060fdf2 = [];
		}
		else if(!isarray(var_7060fdf2))
		{
			var_7060fdf2 = array(var_7060fdf2);
		}
		var_7060fdf2[var_7060fdf2.size] = "vox_plr_2_keeper_2_response_0_pa_0";
	}
	if(var_7060fdf2.size > 0)
	{
		function_7aa5324a(var_7060fdf2, undefined, 1);
	}
}

/*
	Name: function_6b44bc05
	Namespace: zm_castle_vo
	Checksum: 0x6B9172BB
	Offset: 0x4360
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_6b44bc05()
{
	var_3da2c171 = [];
	var_ceb8ae25 = function_ff6cc972();
	if(isdefined(var_ceb8ae25))
	{
		var_49617378 = ("vox_plr_" + var_ceb8ae25.characterindex) + "_keeper_3_0";
		if(!isdefined(var_3da2c171))
		{
			var_3da2c171 = [];
		}
		else if(!isarray(var_3da2c171))
		{
			var_3da2c171 = array(var_3da2c171);
		}
		var_3da2c171[var_3da2c171.size] = var_49617378;
	}
	if(level.has_richtofen)
	{
		if(!isdefined(var_3da2c171))
		{
			var_3da2c171 = [];
		}
		else if(!isarray(var_3da2c171))
		{
			var_3da2c171 = array(var_3da2c171);
		}
		var_3da2c171[var_3da2c171.size] = "vox_plr_2_keeper_3_response_0_0";
	}
	else
	{
		if(!isdefined(var_3da2c171))
		{
			var_3da2c171 = [];
		}
		else if(!isarray(var_3da2c171))
		{
			var_3da2c171 = array(var_3da2c171);
		}
		var_3da2c171[var_3da2c171.size] = "vox_plr_2_keeper_3_response_0_pa_0";
	}
	if(var_3da2c171.size > 0)
	{
		function_7aa5324a(var_3da2c171, undefined, 1);
	}
}

/*
	Name: function_64505195
	Namespace: zm_castle_vo
	Checksum: 0x8680D670
	Offset: 0x4520
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function function_64505195()
{
	function_897246e4("vox_grop_groph_additional6_0", undefined, 1);
}

/*
	Name: function_3ed74336
	Namespace: zm_castle_vo
	Checksum: 0x44479369
	Offset: 0x4550
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function function_3ed74336()
{
	var_3da2c171 = [];
	var_ceb8ae25 = function_ff6cc972();
	if(isdefined(var_ceb8ae25))
	{
		if(var_ceb8ae25.characterindex == 0)
		{
			var_49617378 = "vox_plr_0_keeper_4_0";
		}
		else
		{
			var_49617378 = ("vox_plr_" + var_ceb8ae25.characterindex) + "_keeper_4_response_0_0";
		}
		if(!isdefined(var_3da2c171))
		{
			var_3da2c171 = [];
		}
		else if(!isarray(var_3da2c171))
		{
			var_3da2c171 = array(var_3da2c171);
		}
		var_3da2c171[var_3da2c171.size] = var_49617378;
	}
	if(level.has_richtofen)
	{
		if(!isdefined(var_3da2c171))
		{
			var_3da2c171 = [];
		}
		else if(!isarray(var_3da2c171))
		{
			var_3da2c171 = array(var_3da2c171);
		}
		var_3da2c171[var_3da2c171.size] = "vox_plr_2_keeper_4_response_0_0";
	}
	else
	{
		if(!isdefined(var_3da2c171))
		{
			var_3da2c171 = [];
		}
		else if(!isarray(var_3da2c171))
		{
			var_3da2c171 = array(var_3da2c171);
		}
		var_3da2c171[var_3da2c171.size] = "vox_plr_2_keeper_4_response_0_pa_0";
	}
	if(var_3da2c171.size > 0)
	{
		function_7aa5324a(var_3da2c171, undefined, 1);
	}
}

/*
	Name: function_f28fd307
	Namespace: zm_castle_vo
	Checksum: 0x5B16CEE
	Offset: 0x4730
	Size: 0x3AC
	Parameters: 0
	Flags: Linked
*/
function function_f28fd307()
{
	var_180864bb = [];
	var_4ae0fc9f = struct::get("lower_tower", "script_noteworthy");
	var_ff1ab13b = spawn("script_model", var_4ae0fc9f.origin);
	function_8ac5430(1, var_4ae0fc9f.origin);
	var_ff1ab13b playsoundwithnotify("vox_grop_moon_intro_0", "sounddone");
	var_ff1ab13b waittill(#"sounddone");
	wait(0.5);
	var_ff1ab13b playsoundwithnotify("vox_grop_moon_intro_1", "sounddone");
	var_ff1ab13b waittill(#"sounddone");
	wait(1);
	var_ff1ab13b playsoundwithnotify("vox_grop_moon_intro_2", "sounddone");
	var_ff1ab13b waittill(#"sounddone");
	wait(1);
	var_ff1ab13b playsoundwithnotify("vox_grop_moon_intro_3", "sounddone");
	var_ff1ab13b waittill(#"sounddone");
	wait(1);
	var_ff1ab13b playsoundwithnotify("vox_grop_moon_intro_4", "sounddone");
	var_ff1ab13b waittill(#"sounddone");
	wait(2);
	function_8ac5430();
	var_ceb8ae25 = function_ff6cc972();
	if(isdefined(var_ceb8ae25))
	{
		var_49617378 = ("vox_plr_" + var_ceb8ae25.characterindex) + "_moon_1_response_0_0";
		if(!isdefined(var_180864bb))
		{
			var_180864bb = [];
		}
		else if(!isarray(var_180864bb))
		{
			var_180864bb = array(var_180864bb);
		}
		var_180864bb[var_180864bb.size] = var_49617378;
	}
	if(level.has_richtofen)
	{
		if(!isdefined(var_180864bb))
		{
			var_180864bb = [];
		}
		else if(!isarray(var_180864bb))
		{
			var_180864bb = array(var_180864bb);
		}
		var_180864bb[var_180864bb.size] = "vox_plr_2_moon_1_response_1_0";
	}
	else
	{
		if(!isdefined(var_180864bb))
		{
			var_180864bb = [];
		}
		else if(!isarray(var_180864bb))
		{
			var_180864bb = array(var_180864bb);
		}
		var_180864bb[var_180864bb.size] = "vox_plr_2_moon_1_response_1_pa_0";
	}
	if(var_180864bb.size > 0)
	{
		function_7aa5324a(var_180864bb, undefined, 1);
	}
	wait(1.5);
	level flag::set("rockets_to_moon_vo_complete");
	var_ff1ab13b delete();
}

/*
	Name: function_8ac5430
	Namespace: zm_castle_vo
	Checksum: 0x99945D63
	Offset: 0x4AE8
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function function_8ac5430(var_b20e186c = 0, v_position = (0, 0, 0))
{
	if(var_b20e186c)
	{
		level.sndvoxoverride = 1;
		level flag::set("story_playing");
		function_2426269b(v_position, 9999);
	}
	else
	{
		level flag::clear("story_playing");
		level.sndvoxoverride = 0;
	}
}

/*
	Name: function_5eded46b
	Namespace: zm_castle_vo
	Checksum: 0x7A8DB3F2
	Offset: 0x4BA0
	Size: 0x10C
	Parameters: 4
	Flags: Linked
*/
function function_5eded46b(str_vo_line, n_wait = 0, b_wait_if_busy, n_priority = 0)
{
	function_218256bd(1);
	for(i = 1; i < level.activeplayers.size; i++)
	{
		level.activeplayers[i] thread function_7b697614(str_vo_line, n_wait + 0.1, b_wait_if_busy, n_priority);
	}
	level.activeplayers[0] function_7b697614(str_vo_line, n_wait, b_wait_if_busy, n_priority);
	function_218256bd(0);
}

/*
	Name: function_7b697614
	Namespace: zm_castle_vo
	Checksum: 0x7CB398A4
	Offset: 0x4CB8
	Size: 0x350
	Parameters: 5
	Flags: Linked
*/
function function_7b697614(str_vo_alias, n_delay = 0, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(level flag::get("story_playing"))
	{
		return false;
	}
	if(zm_audio::arenearbyspeakersactive(10000) && (!(isdefined(var_d1295208) && var_d1295208)))
	{
		return false;
	}
	if(isdefined(self.isspeaking) && self.isspeaking || (isdefined(level.sndvoxoverride) && level.sndvoxoverride))
	{
		if(isdefined(b_wait_if_busy) && b_wait_if_busy)
		{
			while(isdefined(self.isspeaking) && self.isspeaking || (isdefined(level.sndvoxoverride) && level.sndvoxoverride))
			{
				wait(0.1);
			}
			wait(0.35);
		}
		else
		{
			return false;
		}
	}
	if(n_delay > 0)
	{
		wait(n_delay);
	}
	if(isdefined(self.isspeaking) && self.isspeaking && (isdefined(self.b_wait_if_busy) && self.b_wait_if_busy))
	{
		while(isdefined(self.isspeaking) && self.isspeaking)
		{
			wait(0.1);
		}
	}
	else if(isdefined(self.isspeaking) && self.isspeaking && (!(isdefined(self.b_wait_if_busy) && self.b_wait_if_busy)) || (isdefined(level.sndvoxoverride) && level.sndvoxoverride))
	{
		return false;
	}
	self notify(str_vo_alias + "_vo_started");
	self.isspeaking = 1;
	level.sndvoxoverride = 1;
	self thread function_b3baa665();
	self.n_vo_priority = n_priority;
	self.str_vo_being_spoken = str_vo_alias;
	array::add(level.a_e_speakers, self, 1);
	var_2df3d133 = str_vo_alias + "_vo_done";
	if(isactor(self) || isplayer(self))
	{
		self playsoundwithnotify(str_vo_alias, var_2df3d133, "J_head");
	}
	else
	{
		self playsoundwithnotify(str_vo_alias, var_2df3d133);
	}
	self waittill(var_2df3d133);
	self vo_clear();
	return true;
}

/*
	Name: function_b3baa665
	Namespace: zm_castle_vo
	Checksum: 0x2E953DCC
	Offset: 0x5010
	Size: 0x40
	Parameters: 0
	Flags: Linked
*/
function function_b3baa665()
{
	self endon(#"hash_2f69a80e");
	self util::waittill_any("death", "disconnect");
	level.sndvoxoverride = 0;
}

/*
	Name: vo_clear
	Namespace: zm_castle_vo
	Checksum: 0xE377D4C0
	Offset: 0x5058
	Size: 0x10C
	Parameters: 0
	Flags: Linked
*/
function vo_clear()
{
	self notify(#"hash_2f69a80e");
	self.str_vo_being_spoken = "";
	self.n_vo_priority = 0;
	self.isspeaking = 0;
	level.sndvoxoverride = 0;
	b_in_a_e_speakers = 0;
	foreach(e_checkme in level.a_e_speakers)
	{
		if(e_checkme == self)
		{
			b_in_a_e_speakers = 1;
			break;
		}
	}
	if(isdefined(b_in_a_e_speakers) && b_in_a_e_speakers)
	{
		arrayremovevalue(level.a_e_speakers, self);
	}
}

/*
	Name: function_502f946b
	Namespace: zm_castle_vo
	Checksum: 0x94A3211A
	Offset: 0x5170
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function function_502f946b()
{
	self endon(#"death");
	if(isdefined(self.str_vo_being_spoken) && self.str_vo_being_spoken != "")
	{
		self stopsound(self.str_vo_being_spoken);
	}
	vo_clear();
}

/*
	Name: function_2426269b
	Namespace: zm_castle_vo
	Checksum: 0x24729236
	Offset: 0x51D8
	Size: 0x232
	Parameters: 2
	Flags: Linked
*/
function function_2426269b(v_pos, n_range = 1000)
{
	if(isdefined(level.a_e_speakers))
	{
		foreach(var_d211180f in level.a_e_speakers)
		{
			if(!isdefined(var_d211180f))
			{
				continue;
			}
			if(!isdefined(v_pos) || distancesquared(var_d211180f.origin, v_pos) <= (n_range * n_range))
			{
				if(isdefined(var_d211180f.str_vo_being_spoken) && var_d211180f.str_vo_being_spoken != "")
				{
					var_d211180f stopsound(var_d211180f.str_vo_being_spoken);
				}
				var_d211180f.deleteme = 1;
				var_d211180f.str_vo_being_spoken = "";
				var_d211180f.n_vo_priority = 0;
				var_d211180f.isspeaking = 0;
			}
		}
		i = 0;
		while(isdefined(level.a_e_speakers) && i < level.a_e_speakers.size)
		{
			if(isdefined(level.a_e_speakers[i].deleteme) && level.a_e_speakers[i].deleteme == 1)
			{
				arrayremovevalue(level.a_e_speakers, level.a_e_speakers[i]);
				i = 0;
			}
			else
			{
				i++;
			}
		}
	}
}

/*
	Name: function_897246e4
	Namespace: zm_castle_vo
	Checksum: 0xB40C50BC
	Offset: 0x5418
	Size: 0x21C
	Parameters: 5
	Flags: Linked
*/
function function_897246e4(str_vo_alias, n_wait = 0, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	var_942373f4 = 0;
	var_9689ca97 = 0;
	var_81132431 = strtok(str_vo_alias, "_");
	if(var_81132431[1] === "grop")
	{
		var_942373f4 = 1;
	}
	else
	{
		if(var_81132431[7] === "pa")
		{
			var_9689ca97 = 1;
		}
		else
		{
			if(var_81132431[1] === "plr")
			{
				var_edf0b06 = int(var_81132431[2]);
				e_speaker = zm_utility::get_specific_character(var_edf0b06);
			}
			else
			{
				e_speaker = undefined;
				/#
					assert(0, ("" + str_vo_alias) + "");
				#/
			}
		}
	}
	if(!var_942373f4 && !var_9689ca97)
	{
		if(zm_utility::is_player_valid(e_speaker))
		{
			e_speaker function_7b697614(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
		}
	}
	else
	{
		function_5eded46b(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
}

/*
	Name: function_63c44c5a
	Namespace: zm_castle_vo
	Checksum: 0xCD8D9349
	Offset: 0x5640
	Size: 0x11C
	Parameters: 5
	Flags: None
*/
function function_63c44c5a(var_cbd11028, var_e21e86b8, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	function_218256bd(1);
	for(i = 0; i < var_cbd11028.size; i++)
	{
		if(isdefined(var_e21e86b8))
		{
			var_e27770b1 = var_e21e86b8[i];
		}
		else
		{
			var_e27770b1 = 0;
		}
		self function_7b697614(var_cbd11028[i], var_e27770b1, b_wait_if_busy, n_priority, var_d1295208);
	}
	function_218256bd(0);
}

/*
	Name: function_7aa5324a
	Namespace: zm_castle_vo
	Checksum: 0x45A65836
	Offset: 0x5768
	Size: 0x11C
	Parameters: 5
	Flags: Linked
*/
function function_7aa5324a(var_cbd11028, var_e21e86b8, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	function_218256bd(1);
	for(i = 0; i < var_cbd11028.size; i++)
	{
		if(isdefined(var_e21e86b8))
		{
			var_e27770b1 = var_e21e86b8[i];
		}
		else
		{
			var_e27770b1 = 0.5;
		}
		function_897246e4(var_cbd11028[i], var_e27770b1, b_wait_if_busy, n_priority, var_d1295208);
	}
	function_218256bd(0);
}

/*
	Name: function_c23e3a71
	Namespace: zm_castle_vo
	Checksum: 0x6F553DB2
	Offset: 0x5890
	Size: 0x144
	Parameters: 6
	Flags: Linked
*/
function function_c23e3a71(var_49fefccd, n_index, var_f781d8ce, b_wait_if_busy = 0, var_7e649f23 = 0, var_d1295208 = 0)
{
	/#
		assert(isdefined(var_49fefccd), "");
	#/
	/#
		assert(n_index < var_49fefccd.size, "");
	#/
	var_3b5e4c24 = var_49fefccd[n_index];
	var_123bfae = undefined;
	if(isdefined(var_f781d8ce))
	{
		/#
			assert(n_index < var_f781d8ce.size, "");
		#/
		var_123bfae = var_f781d8ce[n_index];
	}
	function_7aa5324a(var_3b5e4c24, var_123bfae, b_wait_if_busy, var_7e649f23, var_d1295208);
}

/*
	Name: custom_get_mod_type
	Namespace: zm_castle_vo
	Checksum: 0x8F69DA2C
	Offset: 0x59E0
	Size: 0x3C6
	Parameters: 7
	Flags: Linked
*/
function custom_get_mod_type(impact, mod, weapon, zombie, instakill, dist, player)
{
	close_dist = 4096;
	med_dist = 15376;
	far_dist = 160000;
	if(zombie.damageweapon.name == "sticky_grenade_widows_wine")
	{
		return "default";
	}
	if(function_b303f27c(weapon))
	{
		return undefined;
	}
	if(zm_utility::is_placeable_mine(weapon))
	{
		if(!instakill)
		{
			return "betty";
		}
		return "weapon_instakill";
	}
	if(zombie.damageweapon.name == "cymbal_monkey")
	{
		if(instakill)
		{
			return "weapon_instakill";
		}
		return "monkey";
	}
	if(weapon.name == "ray_gun" || weapon.name == "ray_gun_upgraded" && dist > far_dist)
	{
		if(!instakill)
		{
			return "raygun";
		}
		return "weapon_instakill";
	}
	if(zm_utility::is_headshot(weapon, impact, mod) && dist >= far_dist)
	{
		return "headshot";
	}
	if(mod == "MOD_MELEE" || mod == "MOD_UNKNOWN" && dist < close_dist)
	{
		if(!instakill)
		{
			return "melee";
		}
		return "melee_instakill";
	}
	if(zm_utility::is_explosive_damage(mod) && weapon.name != "ray_gun" && weapon.name != "ray_gun_upgraded" && (!(isdefined(zombie.is_on_fire) && zombie.is_on_fire)))
	{
		if(!instakill)
		{
			return "explosive";
		}
		return "weapon_instakill";
	}
	if(weapon.doesfiredamage && (mod == "MOD_BURNED" || mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH"))
	{
		if(!instakill)
		{
			return "flame";
		}
		return "weapon_instakill";
	}
	if(!isdefined(impact))
	{
		impact = "";
	}
	if(mod != "MOD_MELEE" && zombie.missinglegs)
	{
		return "crawler";
	}
	if(mod != "MOD_BURNED" && dist < close_dist)
	{
		return "close";
	}
	if(mod == "MOD_RIFLE_BULLET" || mod == "MOD_PISTOL_BULLET")
	{
		if(!instakill)
		{
			return "bullet";
		}
		return "weapon_instakill";
	}
	if(instakill)
	{
		return "default";
	}
	return "default";
}

/*
	Name: function_b303f27c
	Namespace: zm_castle_vo
	Checksum: 0x5EE6E5F5
	Offset: 0x5DB0
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_b303f27c(weapon)
{
	if(weapon.name == "elemental_bow" || weapon.name == "elemental_bow_rune_prison" || weapon.name == "elemental_bow_storm" || weapon.name == "elemental_bow_demongate" || weapon.name == "elemental_bow_wolf_howl")
	{
		return true;
	}
	return false;
}

/*
	Name: function_6b96bf38
	Namespace: zm_castle_vo
	Checksum: 0xAC1EBB13
	Offset: 0x5E60
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_6b96bf38()
{
	function_218256bd(1);
	if(level.activeplayers.size == 1)
	{
		var_b48c1dda = ("vox_plr_" + level.activeplayers[0].characterindex) + "_round1_start_solo_0";
		level.activeplayers[0] function_7b697614(var_b48c1dda, 0, 1);
	}
	else
	{
		function_a272201f(0);
	}
	function_218256bd(0);
}

/*
	Name: function_ef84a69b
	Namespace: zm_castle_vo
	Checksum: 0x565DA6B
	Offset: 0x5F28
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_ef84a69b()
{
	function_218256bd(1);
	if(level.activeplayers.size == 1)
	{
		var_b48c1dda = ("vox_plr_" + level.activeplayers[0].characterindex) + "_round1_end_solo_0";
		level.activeplayers[0] function_7b697614(var_b48c1dda, 0, 1);
	}
	else
	{
		function_a272201f(1);
	}
	function_218256bd(0);
}

/*
	Name: function_7d7d3760
	Namespace: zm_castle_vo
	Checksum: 0xB4DA809
	Offset: 0x5FF0
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_7d7d3760()
{
	function_218256bd(1);
	if(level.activeplayers.size == 1)
	{
		var_b48c1dda = ("vox_plr_" + level.activeplayers[0].characterindex) + "_round2_end_solo_0";
		level.activeplayers[0] function_7b697614(var_b48c1dda, 0, 1);
	}
	else
	{
		function_a272201f(2);
	}
	function_218256bd(0);
}

/*
	Name: function_a272201f
	Namespace: zm_castle_vo
	Checksum: 0x602798B7
	Offset: 0x60B8
	Size: 0x1FC
	Parameters: 1
	Flags: Linked
*/
function function_a272201f(var_3ef9e565)
{
	var_31408c0d = undefined;
	foreach(e_player in level.players)
	{
		if(e_player.characterindex == 2)
		{
			var_31408c0d = e_player;
			break;
		}
	}
	if(zm_utility::is_player_valid(var_31408c0d))
	{
		var_3cf0d54b = array::get_all_closest(var_31408c0d.origin, level.activeplayers, array(var_31408c0d), 4, 900);
		var_e4d5c0ab = undefined;
		foreach(e_player in var_3cf0d54b)
		{
			if(zm_utility::is_player_valid(e_player))
			{
				var_e4d5c0ab = e_player;
				break;
			}
		}
		if(zm_utility::is_player_valid(var_e4d5c0ab))
		{
			function_c23e3a71(level.var_4ea3bfd0[var_e4d5c0ab.characterindex], var_3ef9e565, level.var_f8331b71, 1);
		}
	}
}

/*
	Name: function_c5237c88
	Namespace: zm_castle_vo
	Checksum: 0x6E486456
	Offset: 0x62C0
	Size: 0x364
	Parameters: 0
	Flags: Linked
*/
function function_c5237c88()
{
	var_245be316 = level.var_1d8d988e;
	var_31408c0d = undefined;
	if(level.round_number == level.next_dog_round)
	{
		return;
	}
	wait(3);
	function_5eded46b(level.var_524d2080[var_245be316][0]);
	if(level.has_richtofen)
	{
		foreach(e_player in level.activeplayers)
		{
			if(e_player.characterindex == 2)
			{
				var_31408c0d = e_player;
				break;
			}
		}
	}
	if(zm_utility::is_player_valid(var_31408c0d))
	{
		function_c23e3a71(level.var_524d2080[var_245be316][1], 0, level.var_956d74f[var_245be316], 1);
	}
	else
	{
		function_c23e3a71(level.var_524d2080[var_245be316][2], 0, level.var_956d74f[var_245be316], 1);
	}
	if(isdefined(level.var_524d2080[var_245be316][3]))
	{
		var_238a1aba = undefined;
		if(isdefined(var_31408c0d))
		{
			var_ba724c3e = array::exclude(level.activeplayers, var_31408c0d);
			var_a68de872 = array::get_all_closest(var_31408c0d.origin, var_ba724c3e, undefined, 4, 900);
			foreach(e_player in var_a68de872)
			{
				if(zm_utility::is_player_valid(e_player))
				{
					var_238a1aba = e_player;
					break;
				}
			}
		}
		else
		{
			var_238a1aba = function_ff6cc972();
		}
		if(zm_utility::is_player_valid(var_238a1aba))
		{
			str_vo_line = (level.var_524d2080[var_245be316][3][0] + var_238a1aba.characterindex) + level.var_524d2080[var_245be316][3][1];
			var_238a1aba function_7b697614(str_vo_line, 1, 1);
		}
	}
	level.var_1d8d988e++;
}

/*
	Name: function_5803cf05
	Namespace: zm_castle_vo
	Checksum: 0x6B356D2D
	Offset: 0x6630
	Size: 0x82
	Parameters: 2
	Flags: None
*/
function function_5803cf05(n_max, var_6e653641)
{
	/#
		assert(!isdefined(var_6e653641) || var_6e653641 < n_max, "");
	#/
	do
	{
		n_new_value = randomint(n_max);
	}
	while(n_new_value === var_6e653641);
	return n_new_value;
}

/*
	Name: function_b6633a79
	Namespace: zm_castle_vo
	Checksum: 0xD82D4FCB
	Offset: 0x66C0
	Size: 0x156
	Parameters: 0
	Flags: Linked
*/
function function_b6633a79()
{
	if(!isdefined(level.var_98e8620a) || !isdefined(level.var_98e8620a[self.characterindex]) || (gettime() - level.var_98e8620a[self.characterindex]) > 45000)
	{
		var_70bd2a66 = randomint(5);
		if(isdefined(level.var_f9921c3e) && isdefined(level.var_f9921c3e[self.characterindex]))
		{
			while(var_70bd2a66 === level.var_f9921c3e[self.characterindex])
			{
				var_70bd2a66 = randomint(5);
			}
		}
		b_success = self function_7b697614((("vox_plr_" + self.characterindex) + "_need_fuse_") + var_70bd2a66, 4.6);
		if(isdefined(b_success) && b_success)
		{
			level.var_98e8620a[self.characterindex] = gettime();
			level.var_f9921c3e[self.characterindex] = var_70bd2a66;
		}
	}
}

/*
	Name: function_65c13c89
	Namespace: zm_castle_vo
	Checksum: 0xE6CF1872
	Offset: 0x6820
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_65c13c89()
{
	level.var_5307e651[0] = array(2);
	level.var_5307e651[1] = array(1);
	level.var_5307e651[2] = array(0, 2);
	level.var_5307e651[3] = array(1, 2);
	wait(1);
	array::thread_all(level.bgb_machines, &function_1d8b909c);
}

/*
	Name: function_1d8b909c
	Namespace: zm_castle_vo
	Checksum: 0x3F1DC3BA
	Offset: 0x68F8
	Size: 0x1B4
	Parameters: 0
	Flags: Linked
*/
function function_1d8b909c()
{
	while(true)
	{
		self waittill(#"left");
		var_bbced690 = undefined;
		var_4b41add1 = array::get_all_closest(self.origin, level.activeplayers, undefined, 4, 256);
		foreach(e_player in var_4b41add1)
		{
			if(zm_utility::is_player_valid(e_player) && e_player util::is_looking_at(self.origin, 0.9, 0, vectorscale((0, 0, 1), 50)))
			{
				var_bbced690 = e_player;
				break;
			}
		}
		if(isdefined(var_bbced690))
		{
			var_70bd2a66 = array::random(level.var_5307e651[var_bbced690.characterindex]);
			b_success = var_bbced690 function_7b697614((("vox_plr_" + var_bbced690.characterindex) + "_gum_move_") + var_70bd2a66);
		}
	}
}

/*
	Name: function_a1e1ab31
	Namespace: zm_castle_vo
	Checksum: 0xCD501D2A
	Offset: 0x6AB8
	Size: 0xE8
	Parameters: 0
	Flags: Linked
*/
function function_a1e1ab31()
{
	level waittill(#"start_zombie_round_logic");
	level.var_aea601e7[0] = 6;
	level.var_aea601e7[1] = 6;
	level.var_aea601e7[2] = 5;
	level.var_aea601e7[3] = 5;
	while(true)
	{
		level flag::wait_till("low_grav_on");
		zm_spawner::register_zombie_death_event_callback(&function_e58d3756);
		level flag::wait_till_clear("low_grav_on");
		zm_spawner::deregister_zombie_death_event_callback(&function_e58d3756);
	}
}

/*
	Name: function_e58d3756
	Namespace: zm_castle_vo
	Checksum: 0x9DB7F414
	Offset: 0x6BA8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_e58d3756(e_attacker)
{
	e_attacker thread function_7254ce1d();
}

/*
	Name: function_7254ce1d
	Namespace: zm_castle_vo
	Checksum: 0x804F36DA
	Offset: 0x6BD8
	Size: 0x1EE
	Parameters: 0
	Flags: Linked
*/
function function_7254ce1d()
{
	self endon(#"death");
	self endon(#"bled_out");
	if(!zm_utility::is_player_valid(self))
	{
		return;
	}
	if(!(isdefined(self.var_7dd18a0) && self.var_7dd18a0))
	{
		return;
	}
	wait(1);
	if(!self isonground() || self iswallrunning())
	{
		if(!isdefined(level.var_7cad3440) || !isdefined(level.var_7cad3440[self.characterindex]) || (gettime() - level.var_7cad3440[self.characterindex]) > 40000)
		{
			var_5959b8b8 = level.var_aea601e7[self.characterindex];
			var_70bd2a66 = randomint(var_5959b8b8);
			if(isdefined(level.var_3847cd08) && isdefined(level.var_3847cd08[self.characterindex]))
			{
				while(var_70bd2a66 === level.var_3847cd08[self.characterindex])
				{
					var_70bd2a66 = randomint(var_5959b8b8);
				}
			}
			b_success = self function_7b697614((("vox_plr_" + self.characterindex) + "_kill_low_grav_") + var_70bd2a66);
			if(isdefined(b_success) && b_success)
			{
				level.var_7cad3440[self.characterindex] = gettime();
				level.var_3847cd08[self.characterindex] = var_70bd2a66;
			}
		}
	}
}

/*
	Name: function_7091d990
	Namespace: zm_castle_vo
	Checksum: 0xABB37216
	Offset: 0x6DD0
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function function_7091d990()
{
	level.var_49365d20[0] = 7;
	level.var_49365d20[1] = 10;
	level.var_49365d20[2] = 8;
	level.var_49365d20[3] = 9;
	level.var_8ec9fe34[0] = array(1, 2, 3, 4, 5, 6);
	level.var_8ec9fe34[1] = array(2, 3, 4, 5, 6, 7, 9);
	level.var_8ec9fe34[2] = array(0, 1, 2, 3, 4, 5, 6, 7);
	level.var_8ec9fe34[3] = array(0, 1, 2, 3, 4, 5, 6, 7, 8);
	level thread function_24854f68();
	level thread function_5b684ae5();
}

/*
	Name: function_24854f68
	Namespace: zm_castle_vo
	Checksum: 0xB21B6E86
	Offset: 0x6F48
	Size: 0x58
	Parameters: 0
	Flags: Linked
*/
function function_24854f68()
{
	while(true)
	{
		level waittill(#"hash_de71acc2", e_zombie, var_ecf98bb6);
		e_zombie function_52f36cdc("masher", var_ecf98bb6);
	}
}

/*
	Name: function_5b684ae5
	Namespace: zm_castle_vo
	Checksum: 0xEC2E685F
	Offset: 0x6FA8
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function function_5b684ae5()
{
	while(true)
	{
		level waittill(#"trap_kill", e_zombie, var_f1c4d54d);
		var_ecf98bb6 = (isplayer(var_f1c4d54d) ? var_f1c4d54d : var_f1c4d54d.activated_by_player);
		e_zombie function_52f36cdc("generic", var_ecf98bb6);
	}
}

/*
	Name: function_52f36cdc
	Namespace: zm_castle_vo
	Checksum: 0x12FD6EFD
	Offset: 0x7040
	Size: 0x232
	Parameters: 2
	Flags: Linked
*/
function function_52f36cdc(str_type, var_ecf98bb6)
{
	var_ecf98bb6 endon(#"disconnect");
	var_ecf98bb6 endon(#"death");
	if(!isdefined(self))
	{
		return;
	}
	if(!zm_utility::is_player_valid(var_ecf98bb6))
	{
		return;
	}
	if(!isdefined(level.var_2038540a) || !isdefined(level.var_2038540a[var_ecf98bb6.characterindex]) || (gettime() - level.var_2038540a[var_ecf98bb6.characterindex]) > 40000)
	{
		if(distancesquared(self.origin, var_ecf98bb6.origin) < 262144)
		{
			if(var_ecf98bb6 util::is_looking_at(self getcentroid(), 0.85, 0))
			{
				var_70bd2a66 = function_73ee0fdd(str_type, var_ecf98bb6);
				if(isdefined(level.var_f590f5e2) && isdefined(level.var_f590f5e2[var_ecf98bb6.characterindex]))
				{
					while(var_70bd2a66 === level.var_f590f5e2[var_ecf98bb6.characterindex])
					{
						var_70bd2a66 = function_73ee0fdd(str_type, var_ecf98bb6);
					}
				}
				b_success = var_ecf98bb6 function_7b697614((("vox_plr_" + var_ecf98bb6.characterindex) + "_trap_kill_") + var_70bd2a66, 1);
				if(isdefined(b_success) && b_success)
				{
					level.var_2038540a[var_ecf98bb6.characterindex] = gettime();
					level.var_f590f5e2[var_ecf98bb6.characterindex] = var_70bd2a66;
				}
			}
		}
	}
}

/*
	Name: function_73ee0fdd
	Namespace: zm_castle_vo
	Checksum: 0x9A17A7F
	Offset: 0x7280
	Size: 0x96
	Parameters: 2
	Flags: Linked
*/
function function_73ee0fdd(str_type, var_ecf98bb6)
{
	switch(str_type)
	{
		case "masher":
		{
			return randomint(level.var_49365d20[var_ecf98bb6.characterindex]);
			break;
		}
		case "generic":
		{
			return array::random(level.var_8ec9fe34[var_ecf98bb6.characterindex]);
			break;
		}
	}
}

/*
	Name: function_8d44c804
	Namespace: zm_castle_vo
	Checksum: 0xC69F557
	Offset: 0x7320
	Size: 0x3F4
	Parameters: 0
	Flags: Linked
*/
function function_8d44c804()
{
	level.var_e1855a03[0]["elemental_bow"] = 10;
	level.var_e1855a03[1]["elemental_bow"] = 9;
	level.var_e1855a03[2]["elemental_bow"] = 8;
	level.var_e1855a03[3]["elemental_bow"] = 9;
	level.var_e1855a03[0]["elemental_bow_demongate"] = 10;
	level.var_e1855a03[1]["elemental_bow_demongate"] = 9;
	level.var_e1855a03[2]["elemental_bow_demongate"] = 10;
	level.var_e1855a03[3]["elemental_bow_demongate"] = 10;
	level.var_e1855a03[0]["elemental_bow_demongate4"] = 10;
	level.var_e1855a03[1]["elemental_bow_demongate4"] = 9;
	level.var_e1855a03[2]["elemental_bow_demongate4"] = 10;
	level.var_e1855a03[3]["elemental_bow_demongate4"] = 9;
	level.var_e1855a03[0]["elemental_bow_rune_prison"] = 7;
	level.var_e1855a03[1]["elemental_bow_rune_prison"] = 7;
	level.var_e1855a03[2]["elemental_bow_rune_prison"] = 7;
	level.var_e1855a03[3]["elemental_bow_rune_prison"] = 7;
	level.var_e1855a03[0]["elemental_bow_rune_prison4"] = 6;
	level.var_e1855a03[1]["elemental_bow_rune_prison4"] = 7;
	level.var_e1855a03[2]["elemental_bow_rune_prison4"] = 6;
	level.var_e1855a03[3]["elemental_bow_rune_prison4"] = 6;
	level.var_e1855a03[0]["elemental_bow_storm"] = 8;
	level.var_e1855a03[1]["elemental_bow_storm"] = 7;
	level.var_e1855a03[2]["elemental_bow_storm"] = 9;
	level.var_e1855a03[3]["elemental_bow_storm"] = 8;
	level.var_e1855a03[0]["elemental_bow_storm4"] = 8;
	level.var_e1855a03[1]["elemental_bow_storm4"] = 10;
	level.var_e1855a03[2]["elemental_bow_storm4"] = 9;
	level.var_e1855a03[3]["elemental_bow_storm4"] = 9;
	level.var_e1855a03[0]["elemental_bow_wolf_howl"] = 10;
	level.var_e1855a03[1]["elemental_bow_wolf_howl"] = 8;
	level.var_e1855a03[2]["elemental_bow_wolf_howl"] = 10;
	level.var_e1855a03[3]["elemental_bow_wolf_howl"] = 9;
	level.var_e1855a03[0]["elemental_bow_wolf_howl4"] = 10;
	level.var_e1855a03[1]["elemental_bow_wolf_howl4"] = 7;
	level.var_e1855a03[2]["elemental_bow_wolf_howl4"] = 10;
	level.var_e1855a03[3]["elemental_bow_wolf_howl4"] = 8;
	zm_spawner::register_zombie_death_event_callback(&function_1d0c9f25);
}

/*
	Name: function_1d0c9f25
	Namespace: zm_castle_vo
	Checksum: 0xC8ABB144
	Offset: 0x7720
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_1d0c9f25(e_attacker)
{
	self thread function_2f2899c1(e_attacker);
}

/*
	Name: function_2f2899c1
	Namespace: zm_castle_vo
	Checksum: 0x107575B3
	Offset: 0x7750
	Size: 0x412
	Parameters: 1
	Flags: Linked
*/
function function_2f2899c1(e_attacker)
{
	if(!zm_utility::is_player_valid(e_attacker))
	{
		return;
	}
	if(issubstr(self.damageweapon.name, "elemental_bow"))
	{
		var_7cc997ac = zm_weap_elemental_bow::function_1796e73(self.damageweapon.name);
		switch(var_7cc997ac)
		{
			case "elemental_bow":
			case "elemental_bow4":
			{
				var_25c1c42e = "bow_";
				var_7cc997ac = "elemental_bow";
				var_a1235bb2 = "bow";
				n_cooldown_time = 20000;
				break;
			}
			case "elemental_bow_demongate":
			case "elemental_bow_demongate4":
			{
				var_25c1c42e = "demongate_";
				if(isdefined(level.var_ecd0c077) && level.var_ecd0c077.size > 5)
				{
					var_25c1c42e = "demongate_charged_";
				}
				var_a1235bb2 = "demongate";
				n_cooldown_time = 20000;
				break;
			}
			case "elemental_bow_rune_prison":
			{
				var_25c1c42e = "rune_";
				var_a1235bb2 = "rune";
				n_cooldown_time = 20000;
				break;
			}
			case "elemental_bow_rune_prison4":
			{
				var_25c1c42e = "rune_charged_";
				var_a1235bb2 = "rune";
				n_cooldown_time = 20000;
				break;
			}
			case "elemental_bow_storm":
			{
				var_25c1c42e = "elemental_";
				var_a1235bb2 = "rune";
				n_cooldown_time = 20000;
				break;
			}
			case "elemental_bow_storm4":
			{
				var_25c1c42e = "elemental_charged_";
				var_a1235bb2 = "rune";
				n_cooldown_time = 20000;
				break;
			}
			case "elemental_bow_wolf_howl":
			{
				var_25c1c42e = "wolf_";
				var_a1235bb2 = "wolf";
				n_cooldown_time = 20000;
				break;
			}
			case "elemental_bow_wolf_howl4":
			{
				var_25c1c42e = "wolf_charged_";
				var_a1235bb2 = "wolf";
				n_cooldown_time = 20000;
				break;
			}
			default:
			{
				var_25c1c42e = "bow_";
				var_a1235bb2 = "bow";
				n_cooldown_time = 20000;
				break;
			}
		}
		if(!isdefined(level.var_d4abd41) || !isdefined(level.var_d4abd41[var_a1235bb2]) || (gettime() - level.var_d4abd41[var_a1235bb2]) > n_cooldown_time)
		{
			var_5959b8b8 = level.var_e1855a03[e_attacker.characterindex][var_7cc997ac];
			var_70bd2a66 = randomint(var_5959b8b8);
			if(isdefined(level.var_fc0c9427) && isdefined(level.var_fc0c9427[var_a1235bb2]))
			{
				while(var_70bd2a66 === level.var_fc0c9427[var_a1235bb2])
				{
					var_70bd2a66 = randomint(var_5959b8b8);
				}
			}
			b_success = e_attacker function_7b697614(((("vox_plr_" + e_attacker.characterindex) + "_kill_") + var_25c1c42e) + var_70bd2a66, 1);
			if(isdefined(b_success) && b_success)
			{
				level.var_d4abd41[var_a1235bb2] = gettime();
				level.var_fc0c9427[var_a1235bb2] = var_70bd2a66;
			}
		}
	}
}

/*
	Name: function_9f848cca
	Namespace: zm_castle_vo
	Checksum: 0xFFA0CE41
	Offset: 0x7B70
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function function_9f848cca()
{
	level.var_a2636bd5[0] = 6;
	level.var_a2636bd5[1] = 5;
	level.var_a2636bd5[2] = 5;
	level.var_a2636bd5[3] = 5;
	level waittill(#"hash_71de5140");
	zm_spawner::register_zombie_death_event_callback(&function_1c7c6e63);
}

/*
	Name: function_1c7c6e63
	Namespace: zm_castle_vo
	Checksum: 0x758B550F
	Offset: 0x7C00
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_1c7c6e63(e_attacker)
{
	self thread function_6b6a641f(e_attacker);
}

/*
	Name: function_6b6a641f
	Namespace: zm_castle_vo
	Checksum: 0x95A170B1
	Offset: 0x7C30
	Size: 0x1FE
	Parameters: 1
	Flags: Linked
*/
function function_6b6a641f(e_attacker)
{
	if(!zm_utility::is_player_valid(e_attacker))
	{
		return;
	}
	if(self.damageweapon.name === "hero_gravityspikes_melee" && (isdefined(self.b_melee_kill) && self.b_melee_kill))
	{
		if(!isdefined(level.var_d9cc186d) || !isdefined(level.var_d9cc186d[e_attacker.characterindex]) || (gettime() - level.var_d9cc186d[e_attacker.characterindex]) > 10000)
		{
			var_5959b8b8 = level.var_a2636bd5[e_attacker.characterindex];
			var_70bd2a66 = randomint(var_5959b8b8);
			if(isdefined(level.var_209998ed) && isdefined(level.var_209998ed[e_attacker.characterindex]))
			{
				while(var_70bd2a66 === level.var_209998ed[e_attacker.characterindex])
				{
					var_70bd2a66 = randomint(var_5959b8b8);
				}
			}
			b_success = e_attacker function_7b697614((("vox_plr_" + e_attacker.characterindex) + "_spikes_kill_") + var_70bd2a66, 1);
			if(isdefined(b_success) && b_success)
			{
				level.var_d9cc186d[e_attacker.characterindex] = gettime();
				level.var_209998ed[e_attacker.characterindex] = var_70bd2a66;
			}
		}
	}
}

/*
	Name: function_c166f48
	Namespace: zm_castle_vo
	Checksum: 0xA92B95A1
	Offset: 0x7E38
	Size: 0x14E
	Parameters: 0
	Flags: Linked
*/
function function_c166f48()
{
	if(!isdefined(level.var_89466e30) || !isdefined(level.var_89466e30[self.characterindex]) || (gettime() - level.var_89466e30[self.characterindex]) > 6000)
	{
		var_70bd2a66 = randomint(5);
		if(isdefined(level.var_9e809414) && isdefined(level.var_9e809414[self.characterindex]))
		{
			while(var_70bd2a66 === level.var_9e809414[self.characterindex])
			{
				var_70bd2a66 = randomint(5);
			}
		}
		b_success = self function_7b697614((("vox_plr_" + self.characterindex) + "_rocketshield_kill_") + var_70bd2a66, 1);
		if(isdefined(b_success) && b_success)
		{
			level.var_89466e30[self.characterindex] = gettime();
			level.var_9e809414[self.characterindex] = var_70bd2a66;
		}
	}
}

/*
	Name: function_cfd97735
	Namespace: zm_castle_vo
	Checksum: 0xAACA5C2E
	Offset: 0x7F90
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function function_cfd97735()
{
	level.var_9966a45d[0] = 11;
	level.var_9966a45d[1] = 10;
	level.var_9966a45d[2] = 10;
	level.var_9966a45d[3] = 10;
	level.var_872326d2 = array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
	array::randomize(level.var_872326d2);
}

/*
	Name: function_43b44df3
	Namespace: zm_castle_vo
	Checksum: 0x133B684D
	Offset: 0x8050
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function function_43b44df3()
{
	if(!isdefined(level.var_fc09cfc9))
	{
		level.var_fc09cfc9 = 0;
	}
	var_70bd2a66 = level.var_fc09cfc9;
	if(var_70bd2a66 > level.var_9966a45d[self.characterindex])
	{
		var_70bd2a66 = level.var_9966a45d[self.characterindex];
	}
	b_success = self function_7b697614((("vox_plr_" + self.characterindex) + "_pickup_generic_") + var_70bd2a66, 1);
	if(isdefined(b_success) && b_success)
	{
		level.var_fc09cfc9++;
	}
}

/*
	Name: function_4e11dfdc
	Namespace: zm_castle_vo
	Checksum: 0x79C7C3A3
	Offset: 0x8120
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_4e11dfdc()
{
	self function_7b697614((("vox_plr_" + self.characterindex) + "_pickup_spikes_") + randomint(5), 1);
}

/*
	Name: function_604361f
	Namespace: zm_castle_vo
	Checksum: 0x2B5D58DB
	Offset: 0x8178
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_604361f()
{
	while(true)
	{
		level waittill(#"shield_built", e_player);
		e_player thread function_7b697614((("vox_plr_" + e_player.characterindex) + "_pickup_rocket_") + randomint(5), 1);
	}
}

/*
	Name: function_ad27f488
	Namespace: zm_castle_vo
	Checksum: 0x7A4065B7
	Offset: 0x81F8
	Size: 0x1AE
	Parameters: 1
	Flags: Linked
*/
function function_ad27f488(var_c3426fee)
{
	level.var_82118499++;
	n_delay = var_c3426fee * 0.7;
	if(!zm_utility::is_player_valid(self))
	{
		return;
	}
	switch(level.var_82118499)
	{
		case 1:
		{
			self thread function_7b697614((("vox_plr_" + self.characterindex) + "_dragon_encounter_") + randomint(3), n_delay);
			break;
		}
		case 2:
		case 3:
		{
			var_70bd2a66 = randomint(5);
			if(isdefined(level.var_3ab1346f) && isdefined(level.var_3ab1346f[self.characterindex]))
			{
				while(var_70bd2a66 === level.var_3ab1346f[self.characterindex])
				{
					var_70bd2a66 = randomint(5);
				}
			}
			b_success = self function_7b697614((("vox_plr_" + self.characterindex) + "_dragon_generic_") + var_70bd2a66, n_delay);
			if(isdefined(b_success) && b_success)
			{
				level.var_3ab1346f[self.characterindex] = var_70bd2a66;
			}
			break;
		}
	}
}

/*
	Name: function_439c7159
	Namespace: zm_castle_vo
	Checksum: 0x9F40CF09
	Offset: 0x83B0
	Size: 0xCC
	Parameters: 0
	Flags: Linked
*/
function function_439c7159()
{
	if(!zm_utility::is_player_valid(self))
	{
		return;
	}
	var_70bd2a66 = randomint(5);
	if(self.characterindex == 2)
	{
		var_56f8b764 = array(1, 2, 4);
		var_70bd2a66 = array::random(var_56f8b764);
	}
	self thread function_7b697614((("vox_plr_" + self.characterindex) + "_dragon_final_") + var_70bd2a66, 6);
}

/*
	Name: base_bow_picked_up
	Namespace: zm_castle_vo
	Checksum: 0xE9B5B592
	Offset: 0x8488
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function base_bow_picked_up()
{
	if(!(isdefined(self.var_3f43dcf1) && self.var_3f43dcf1))
	{
		level notify(#"base_bow_picked_up");
		b_success = self function_7b697614((("vox_plr_" + self.characterindex) + "_pickup_bow_") + randomint(5), 0);
		if(isdefined(b_success) && b_success)
		{
			self.var_3f43dcf1 = 1;
		}
	}
}

/*
	Name: function_ce6b93fc
	Namespace: zm_castle_vo
	Checksum: 0x1662B3D5
	Offset: 0x8528
	Size: 0xFA
	Parameters: 0
	Flags: Linked
*/
function function_ce6b93fc()
{
	var_70bd2a66 = randomint(5);
	if(isdefined(level.var_a46c6d37) && isdefined(level.var_a46c6d37[self.characterindex]))
	{
		while(var_70bd2a66 === level.var_a46c6d37[self.characterindex])
		{
			var_70bd2a66 = randomint(5);
		}
	}
	b_success = self function_7b697614((("vox_plr_" + self.characterindex) + "_pap_teleport_") + var_70bd2a66, 1.4);
	if(isdefined(b_success) && b_success)
	{
		level.var_a46c6d37[self.characterindex] = var_70bd2a66;
	}
}

/*
	Name: function_68089900
	Namespace: zm_castle_vo
	Checksum: 0x7442152F
	Offset: 0x8630
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function function_68089900()
{
	level.var_32435277[0] = array(1, 2, 4);
	level.var_32435277[1] = array(2, 4);
	level.var_32435277[2] = array(3, 4);
	level.var_32435277[3] = array(1, 2, 3, 4);
	level.var_b3bb5f5f = 0;
}

/*
	Name: function_894d806e
	Namespace: zm_castle_vo
	Checksum: 0x2159CCEA
	Offset: 0x86F8
	Size: 0x242
	Parameters: 1
	Flags: Linked
*/
function function_894d806e(s_spawn_loc)
{
	if(!isdefined(s_spawn_loc))
	{
		return;
	}
	a_speakers = array::get_all_closest(s_spawn_loc.origin, level.activeplayers);
	e_speaker = a_speakers[0];
	while(!zm_utility::is_player_valid(e_speaker) || (isdefined(level.var_7eb6d8cb) && isdefined(level.var_7eb6d8cb[e_speaker.characterindex]) && (gettime() - level.var_7eb6d8cb[e_speaker.characterindex]) < 20000))
	{
		a_speakers = array::exclude(a_speakers, e_speaker);
		if(a_speakers.size)
		{
			e_speaker = a_speakers[0];
		}
		else
		{
			e_speaker = undefined;
			break;
		}
	}
	if(isdefined(e_speaker))
	{
		var_70bd2a66 = randomint(5);
		if(isdefined(level.var_c2a10a01) && isdefined(level.var_c2a10a01[e_speaker.characterindex]))
		{
			while(var_70bd2a66 === level.var_c2a10a01[e_speaker.characterindex])
			{
				var_70bd2a66 = randomint(5);
			}
		}
		b_success = e_speaker function_7b697614((("vox_plr_" + e_speaker.characterindex) + "_mechz_appear_") + var_70bd2a66, 2.8);
		if(isdefined(b_success) && b_success)
		{
			level.var_7eb6d8cb[e_speaker.characterindex] = gettime();
			level.var_c2a10a01[e_speaker.characterindex] = var_70bd2a66;
		}
	}
}

/*
	Name: function_e8a09e6e
	Namespace: zm_castle_vo
	Checksum: 0xAE5DF9DA
	Offset: 0x8948
	Size: 0x214
	Parameters: 0
	Flags: Linked
*/
function function_e8a09e6e()
{
	self endon(#"death");
	self endon(#"hash_fe8911ae");
	level.var_b3bb5f5f++;
	if(level.var_b3bb5f5f > 4)
	{
		return;
	}
	self thread function_6d7d2595();
	n_counter = 0;
	while(isdefined(self.has_faceplate) && self.has_faceplate && n_counter < 90)
	{
		wait(0.2);
		n_counter = n_counter + 0.2;
	}
	if(!(isdefined(self.has_faceplate) && self.has_faceplate))
	{
		if(!zm_utility::is_player_valid(self.attacker))
		{
			return;
		}
		e_attacker = self.attacker;
	}
	else
	{
		e_attacker = undefined;
		while(!isdefined(e_attacker))
		{
			self waittill(#"damage", n_damage, e_attacker);
			if(!zm_utility::is_player_valid(e_attacker))
			{
				e_attacker = undefined;
			}
		}
		if(self.faceplate_health < (level.mechz_faceplate_health * 0.5))
		{
			return;
		}
	}
	var_70bd2a66 = randomint(5);
	if(isdefined(level.var_a45398c8) && isdefined(level.var_a45398c8[e_attacker.characterindex]))
	{
		while(var_70bd2a66 === level.var_a45398c8[e_attacker.characterindex])
		{
			var_70bd2a66 = randomint(5);
		}
	}
	self thread function_bdcf0afc(e_attacker, var_70bd2a66, "_panzer_hint_");
}

/*
	Name: function_6d7d2595
	Namespace: zm_castle_vo
	Checksum: 0xD3B10021
	Offset: 0x8B68
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_6d7d2595()
{
	self endon(#"death");
	self endon(#"hash_fe8911ae");
	while(isdefined(self.powercap_covered) && self.powercap_covered)
	{
		wait(0.2);
	}
	if(!zm_utility::is_player_valid(self.attacker))
	{
		return;
	}
	e_attacker = self.attacker;
	var_70bd2a66 = array::random(level.var_32435277[e_attacker.characterindex]);
	if(isdefined(level.var_f63de82) && isdefined(level.var_f63de82[e_attacker.characterindex]))
	{
		while(var_70bd2a66 === level.var_f63de82[e_attacker.characterindex])
		{
			var_70bd2a66 = array::random(level.var_32435277[e_attacker.characterindex]);
		}
	}
	self thread function_bdcf0afc(e_attacker, var_70bd2a66, "_disable_claw_");
}

/*
	Name: function_bdcf0afc
	Namespace: zm_castle_vo
	Checksum: 0x26BCC6A9
	Offset: 0x8CC0
	Size: 0xEA
	Parameters: 3
	Flags: Linked
*/
function function_bdcf0afc(e_attacker, var_70bd2a66, var_68c69747)
{
	b_success = e_attacker function_7b697614((("vox_plr_" + e_attacker.characterindex) + var_68c69747) + var_70bd2a66);
	if(isdefined(b_success) && b_success)
	{
		if(var_68c69747 == "_panzer_hint_")
		{
			level.var_a45398c8[e_attacker.characterindex] = var_70bd2a66;
		}
		else
		{
			level.var_f63de82[e_attacker.characterindex] = var_70bd2a66;
		}
		if(isdefined(self) && isalive(self))
		{
			self notify(#"hash_fe8911ae");
		}
	}
}

/*
	Name: function_5e426b67
	Namespace: zm_castle_vo
	Checksum: 0xA07AFFCA
	Offset: 0x8DB8
	Size: 0x1BA
	Parameters: 0
	Flags: Linked
*/
function function_5e426b67()
{
	self waittill(#"death");
	if(!zm_utility::is_player_valid(self.attacker))
	{
		return;
	}
	e_attacker = self.attacker;
	if(!isdefined(level.var_91f5abdc) || !isdefined(level.var_91f5abdc[e_attacker.characterindex]) || (gettime() - level.var_91f5abdc[e_attacker.characterindex]) > 20000)
	{
		var_70bd2a66 = randomint(5);
		if(isdefined(level.var_4d539832) && isdefined(level.var_4d539832[e_attacker.characterindex]))
		{
			while(var_70bd2a66 === level.var_4d539832[e_attacker.characterindex])
			{
				var_70bd2a66 = randomint(5);
			}
		}
		b_success = e_attacker function_7b697614((("vox_plr_" + e_attacker.characterindex) + "_mechz_kill_") + var_70bd2a66, 2);
		if(isdefined(b_success) && b_success)
		{
			level.var_91f5abdc[e_attacker.characterindex] = gettime();
			level.var_4d539832[e_attacker.characterindex] = var_70bd2a66;
		}
	}
}

/*
	Name: function_1bc76ea3
	Namespace: zm_castle_vo
	Checksum: 0x3BAA218C
	Offset: 0x8F80
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_1bc76ea3()
{
	level.var_275b3aff = 0;
	var_9b37fac5 = struct::get_array("vo_room_intro", "targetname");
	array::thread_all(var_9b37fac5, &function_59fdea16);
}

/*
	Name: function_59fdea16
	Namespace: zm_castle_vo
	Checksum: 0x39784E36
	Offset: 0x8FF0
	Size: 0x8C
	Parameters: 0
	Flags: Linked
*/
function function_59fdea16()
{
	self.script_unitrigger_type = "unitrigger_radius";
	self.cursor_hint = "HINT_NOICON";
	self.require_look_at = 0;
	if(self.script_noteworthy === "zone_v10_pad_door")
	{
		self.origin = (4608, -2304, -2280);
		self.radius = 600;
	}
	zm_unitrigger::register_static_unitrigger(self, &function_88db2665);
}

/*
	Name: function_88db2665
	Namespace: zm_castle_vo
	Checksum: 0x90F4B2C6
	Offset: 0x9088
	Size: 0x56
	Parameters: 0
	Flags: Linked
*/
function function_88db2665()
{
	self endon(#"kill_trigger");
	while(true)
	{
		self waittill(#"trigger", e_player);
		self thread function_4b5f8d2e(e_player);
		wait(1);
	}
}

/*
	Name: function_4b5f8d2e
	Namespace: zm_castle_vo
	Checksum: 0xB2E4B0BE
	Offset: 0x90E8
	Size: 0x148
	Parameters: 1
	Flags: Linked
*/
function function_4b5f8d2e(e_player)
{
	if(isdefined(level.var_275b3aff) && level.var_275b3aff)
	{
		return;
	}
	if(!isdefined(level.var_d5c00ec8) || (gettime() - level.var_d5c00ec8) > 50000)
	{
		level.var_275b3aff = 1;
		s_unitrigger_stub = self.stub;
		var_45d9d86 = s_unitrigger_stub.script_string;
		e_player thread function_91db1c0b(((("vox_plr_" + e_player.characterindex) + "_room_") + var_45d9d86) + "_0", s_unitrigger_stub);
		b_success = e_player function_7b697614(((("vox_plr_" + e_player.characterindex) + "_room_") + var_45d9d86) + "_0");
		if(isdefined(b_success) && b_success)
		{
			level.var_d5c00ec8 = gettime();
		}
		level.var_275b3aff = 0;
	}
}

/*
	Name: function_91db1c0b
	Namespace: zm_castle_vo
	Checksum: 0xDC9B0475
	Offset: 0x9238
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function function_91db1c0b(str_vo_alias, s_unitrigger_stub)
{
	self waittill(str_vo_alias + "_vo_started");
	zm_unitrigger::unregister_unitrigger(s_unitrigger_stub);
}

/*
	Name: function_fbe2f6cb
	Namespace: zm_castle_vo
	Checksum: 0xF14DA16B
	Offset: 0x9280
	Size: 0x178
	Parameters: 0
	Flags: Linked
*/
function function_fbe2f6cb()
{
	level waittill(#"start_zombie_round_logic");
	var_1b10157c = 0;
	while(true)
	{
		str_result = level util::waittill_any_return("pap_reformed", "base_bow_picked_up");
		if(str_result == "pap_reformed")
		{
			var_1b10157c++;
			if(level.round_number > 5)
			{
				level.var_169991e1++;
				while(function_68ee653())
				{
					util::wait_network_frame();
				}
				level function_5eded46b(("vox_grop_groph_additional" + level.var_169991e1) + "_0");
			}
		}
		else if(str_result == "base_bow_picked_up")
		{
			var_1b10157c++;
			level.var_169991e1++;
			while(function_68ee653())
			{
				util::wait_network_frame();
			}
			level function_5eded46b(("vox_grop_groph_additional" + level.var_169991e1) + "_0");
		}
		if(var_1b10157c >= 2)
		{
			return;
		}
	}
}

/*
	Name: function_68ee653
	Namespace: zm_castle_vo
	Checksum: 0xBE5B5C1F
	Offset: 0x9400
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_68ee653()
{
	for(i = 0; i < level.activeplayers.size; i++)
	{
		if(level.activeplayers[i].isspeaking)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_f0b775a3
	Namespace: zm_castle_vo
	Checksum: 0xF13EA989
	Offset: 0x9460
	Size: 0x1AC
	Parameters: 3
	Flags: Linked
*/
function function_f0b775a3(str_label, var_ed01584 = 1, b_wait = 1)
{
	str_vo_alias = ("vox_arro_demongate_" + str_label) + "_0";
	self thread function_c123b81c(str_label, str_vo_alias);
	b_played = self function_7b697614(str_vo_alias, 0, b_wait, 0, 1);
	if(!(isdefined(b_played) && b_played))
	{
		level notify(str_vo_alias + "_vo_failed");
		return;
	}
	if(var_ed01584)
	{
		if(str_label == "name_incorrect")
		{
			if(isdefined(level.var_6e68c0d8))
			{
				level.var_6e68c0d8 thread function_7b697614(((("vox_plr_" + level.var_6e68c0d8.characterindex) + "_demongate_") + str_label) + "_response_0", 1);
			}
			return;
		}
		if(isdefined(level.var_6e68c0d8))
		{
			level.var_6e68c0d8 function_7b697614(((("vox_plr_" + level.var_6e68c0d8.characterindex) + "_demongate_") + str_label) + "_response_0");
		}
	}
}

/*
	Name: function_7c63dd65
	Namespace: zm_castle_vo
	Checksum: 0xD1D2B872
	Offset: 0x9618
	Size: 0x8A
	Parameters: 2
	Flags: Linked
*/
function function_7c63dd65(var_300b5632, b_wait = 1)
{
	str_vo_alias = ("vox_arro_demongate_" + var_300b5632) + "_0";
	self thread function_c123b81c(var_300b5632, str_vo_alias);
	return self function_7b697614(str_vo_alias, 0, b_wait, 0, 1);
}

/*
	Name: function_ebc3d584
	Namespace: zm_castle_vo
	Checksum: 0x9C512043
	Offset: 0x96B0
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function function_ebc3d584(var_cf6c6acd, var_b5991f0e = 0)
{
	switch(var_cf6c6acd)
	{
		case "lor":
		{
			str_vox = "ust";
			break;
		}
		case "ulla":
		{
			str_vox = "mar";
			break;
		}
		case "oth":
		{
			str_vox = "ath";
			break;
		}
		case "zor":
		{
			str_vox = "gor";
			break;
		}
		case "mar":
		{
			str_vox = "yit";
			break;
		}
		case "uja":
		{
			str_vox = "iyel";
			break;
		}
	}
	if(isdefined(str_vox))
	{
		self function_7b697614(("vox_spir_demongate_vowel_" + str_vox) + "_0", 0, var_b5991f0e, 0, 1);
	}
}

/*
	Name: function_56c65986
	Namespace: zm_castle_vo
	Checksum: 0xB9417C78
	Offset: 0x97D0
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function function_56c65986(b_correct)
{
	if(b_correct)
	{
		self thread function_c123b81c("name_correct", "vox_arro_demongate_name_correct_0");
		self function_7b697614("vox_arro_demongate_name_correct_0", 0, 1, 0, 1);
	}
	else
	{
		var_ed01584 = 0;
		if(!(isdefined(level.var_6e68c0d8.var_a53f437d) && level.var_6e68c0d8.var_a53f437d))
		{
			level.var_6e68c0d8.var_a53f437d = 1;
			var_ed01584 = 1;
		}
		self function_f0b775a3("name_incorrect", var_ed01584);
	}
}

/*
	Name: function_c123b81c
	Namespace: zm_castle_vo
	Checksum: 0xC1174472
	Offset: 0x98B8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function function_c123b81c(str_label, str_vo_alias)
{
	self endon(#"death");
	level endon(str_vo_alias + "_vo_failed");
	self waittill(str_vo_alias + "_vo_started");
	if(isdefined(level.var_6e68c0d8))
	{
		level.var_6e68c0d8 clientfield::increment_to_player("demon_vo_" + str_label, 1);
	}
}

/*
	Name: function_21c9c75b
	Namespace: zm_castle_vo
	Checksum: 0xCE68D34E
	Offset: 0x9940
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_21c9c75b()
{
	self function_7b697614(("vox_plr_" + self.characterindex) + "_clock_chime_0");
}

/*
	Name: function_5fa306b6
	Namespace: zm_castle_vo
	Checksum: 0x53FCC9D
	Offset: 0x9980
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function function_5fa306b6(var_62f94d00)
{
	str_alias = ((("vox_plr_" + self.characterindex) + "_quest_wolf_") + var_62f94d00) + "_0";
	if(!isdefined(self.var_b89ed4e5))
	{
		self.var_b89ed4e5 = [];
	}
	if(!array::contains(self.var_b89ed4e5, str_alias))
	{
		if(!isdefined(self.var_b89ed4e5))
		{
			self.var_b89ed4e5 = [];
		}
		else if(!isarray(self.var_b89ed4e5))
		{
			self.var_b89ed4e5 = array(self.var_b89ed4e5);
		}
		self.var_b89ed4e5[self.var_b89ed4e5.size] = str_alias;
		self function_7b697614(str_alias);
	}
}

