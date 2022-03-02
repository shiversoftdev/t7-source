// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;

#namespace zm_factory_vo;

/*
	Name: __init__sytem__
	Namespace: zm_factory_vo
	Checksum: 0xE2924806
	Offset: 0xA38
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_factory_vo", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: zm_factory_vo
	Checksum: 0x99EC1590
	Offset: 0xA80
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: __main__
	Namespace: zm_factory_vo
	Checksum: 0x57BC9CAC
	Offset: 0xA90
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	level thread function_7884e6b8();
}

/*
	Name: function_7884e6b8
	Namespace: zm_factory_vo
	Checksum: 0xA35586B8
	Offset: 0xAB8
	Size: 0xB88
	Parameters: 0
	Flags: Linked
*/
function function_7884e6b8()
{
	self endon(#"_zombie_game_over");
	level.a_e_speakers = [];
	var_f01f6eb2 = [];
	array::add(var_f01f6eb2, array("vox_plr_3_interaction_takeo_rich_1_0", "vox_plr_2_interaction_takeo_rich_1_0"));
	array::add(var_f01f6eb2, array("vox_plr_3_interaction_takeo_rich_2_0", "vox_plr_2_interaction_takeo_rich_2_0"));
	array::add(var_f01f6eb2, array("vox_plr_3_interaction_takeo_rich_3_0", "vox_plr_2_interaction_takeo_rich_3_0"));
	array::add(var_f01f6eb2, array("vox_plr_3_interaction_takeo_rich_4_0", "vox_plr_2_interaction_takeo_rich_4_0"));
	array::add(var_f01f6eb2, array("vox_plr_3_interaction_takeo_rich_5_0", "vox_plr_2_interaction_takeo_rich_5_0"));
	var_e140097c = 0;
	var_5fda2472 = [];
	array::add(var_5fda2472, array("vox_plr_0_interaction_takeo_demp_1_0", "vox_plr_3_interaction_takeo_demp_1_0"));
	array::add(var_5fda2472, array("vox_plr_0_interaction_takeo_demp_2_0", "vox_plr_3_interaction_takeo_demp_2_0"));
	array::add(var_5fda2472, array("vox_plr_0_interaction_takeo_demp_3_0", "vox_plr_3_interaction_takeo_demp_3_0"));
	array::add(var_5fda2472, array("vox_plr_0_interaction_takeo_demp_4_0", "vox_plr_3_interaction_takeo_demp_4_0"));
	array::add(var_5fda2472, array("vox_plr_0_interaction_takeo_demp_5_0", "vox_plr_3_interaction_takeo_demp_5_0"));
	var_b7adf76 = 0;
	var_aeae7aa1 = [];
	array::add(var_aeae7aa1, array("vox_plr_3_interaction_niko_takeo_1_0", "vox_plr_1_interaction_niko_takeo_1_0"));
	array::add(var_aeae7aa1, array("vox_plr_3_interaction_niko_takeo_2_0", "vox_plr_1_interaction_niko_takeo_2_0"));
	array::add(var_aeae7aa1, array("vox_plr_1_interaction_niko_takeo_3_0", "vox_plr_3_interaction_niko_takeo_3_0"));
	array::add(var_aeae7aa1, array("vox_plr_3_interaction_niko_takeo_4_0", "vox_plr_1_interaction_niko_takeo_4_0"));
	array::add(var_aeae7aa1, array("vox_plr_3_interaction_niko_takeo_5_0", "vox_plr_1_interaction_niko_takeo_5_0"));
	var_e60d01d = 0;
	var_db90c17b = [];
	array::add(var_db90c17b, array("vox_plr_0_interaction_demp_rich_1_0", "vox_plr_2_interaction_demp_rich_1_0"));
	array::add(var_db90c17b, array("vox_plr_0_interaction_demp_rich_2_0", "vox_plr_2_interaction_demp_rich_2_0"));
	array::add(var_db90c17b, array("vox_plr_0_interaction_demp_rich_3_0", "vox_plr_2_interaction_demp_rich_3_0"));
	array::add(var_db90c17b, array("vox_plr_0_interaction_demp_rich_4_0", "vox_plr_2_interaction_demp_rich_4_0"));
	array::add(var_db90c17b, array("vox_plr_0_interaction_demp_rich_5_0", "vox_plr_2_interaction_demp_rich_5_0"));
	var_93378973 = 0;
	var_e341729a = [];
	array::add(var_e341729a, array("vox_plr_1_interaction_niko_rich_1_0", "vox_plr_2_interaction_niko_rich_1_0"));
	array::add(var_e341729a, array("vox_plr_1_interaction_niko_rich_2_0", "vox_plr_2_interaction_niko_rich_2_0"));
	array::add(var_e341729a, array("vox_plr_1_interaction_niko_rich_3_0", "vox_plr_2_interaction_niko_rich_3_0"));
	array::add(var_e341729a, array("vox_plr_1_interaction_niko_rich_4_0", "vox_plr_2_interaction_niko_rich_4_0"));
	array::add(var_e341729a, array("vox_plr_2_interaction_niko_rich_5_0", "vox_plr_1_interaction_niko_rich_5_0"));
	var_94078d12 = 0;
	var_4c7aad4a = [];
	array::add(var_4c7aad4a, array("vox_plr_0_interaction_niko_demp_1_0", "vox_plr_1_interaction_niko_demp_1_0"));
	array::add(var_4c7aad4a, array("vox_plr_1_interaction_niko_demp_2_0", "vox_plr_0_interaction_niko_demp_2_0"));
	array::add(var_4c7aad4a, array("vox_plr_1_interaction_niko_demp_3_0", "vox_plr_0_interaction_niko_demp_3_0"));
	array::add(var_4c7aad4a, array("vox_plr_1_interaction_niko_demp_4_0", "vox_plr_0_interaction_niko_demp_4_0"));
	array::add(var_4c7aad4a, array("vox_plr_1_interaction_niko_demp_5_0", "vox_plr_0_interaction_niko_demp_5_0"));
	var_22f40782 = 0;
	level waittill(#"all_players_spawned");
	wait(1);
	while(true)
	{
		if(level.round_number > 4)
		{
			level waittill(#"end_of_round");
			if(level.activeplayers.size > 1 && !level flag::get("flytrap"))
			{
				n_player_index = randomint(level.activeplayers.size);
				var_e8669 = level.activeplayers[n_player_index];
				var_a68de872 = array::remove_index(level.activeplayers, n_player_index);
				var_261100d2 = arraygetclosest(var_e8669.origin, var_a68de872);
				if(zm_utility::is_player_valid(var_e8669) && zm_utility::is_player_valid(var_261100d2) && distance(var_e8669.origin, var_261100d2.origin) <= 900)
				{
					var_3b5e4c24 = undefined;
					if(var_e8669.characterindex == 3 && var_261100d2.characterindex == 2 || (var_261100d2.characterindex == 3 && var_e8669.characterindex == 2))
					{
						if(var_e140097c < var_f01f6eb2.size)
						{
							function_c23e3a71(var_f01f6eb2, var_e140097c, 1);
							var_e140097c++;
						}
					}
					else
					{
						if(var_e8669.characterindex == 3 && var_261100d2.characterindex == 0 || (var_261100d2.characterindex == 3 && var_e8669.characterindex == 0))
						{
							if(var_b7adf76 < var_5fda2472.size)
							{
								function_c23e3a71(var_5fda2472, var_b7adf76, 1);
								var_b7adf76++;
							}
						}
						else
						{
							if(var_e8669.characterindex == 3 && var_261100d2.characterindex == 1 || (var_261100d2.characterindex == 3 && var_e8669.characterindex == 1))
							{
								if(var_e60d01d < var_aeae7aa1.size)
								{
									function_c23e3a71(var_aeae7aa1, var_e60d01d, 1);
									var_e60d01d++;
								}
							}
							else
							{
								if(var_e8669.characterindex == 2 && var_261100d2.characterindex == 0 || (var_261100d2.characterindex == 2 && var_e8669.characterindex == 0))
								{
									if(var_93378973 < var_db90c17b.size)
									{
										function_c23e3a71(var_db90c17b, var_93378973, 1);
										var_93378973++;
									}
								}
								else
								{
									if(var_e8669.characterindex == 2 && var_261100d2.characterindex == 1 || (var_261100d2.characterindex == 2 && var_e8669.characterindex == 1))
									{
										if(var_94078d12 < var_e341729a.size)
										{
											function_c23e3a71(var_e341729a, var_94078d12, 1);
											var_94078d12++;
										}
									}
									else if(var_e8669.characterindex == 0 && var_261100d2.characterindex == 1 || (var_261100d2.characterindex == 0 && var_e8669.characterindex == 1))
									{
										if(var_22f40782 < var_4c7aad4a.size)
										{
											function_c23e3a71(var_4c7aad4a, var_22f40782, 1);
											var_22f40782++;
										}
									}
								}
							}
						}
					}
				}
			}
		}
		wait(0.05);
	}
}

/*
	Name: function_c23e3a71
	Namespace: zm_factory_vo
	Checksum: 0xC8CA1A8A
	Offset: 0x1648
	Size: 0xE4
	Parameters: 5
	Flags: Linked
*/
function function_c23e3a71(var_49fefccd, n_index, b_wait_if_busy = 0, var_7e649f23 = 0, var_d1295208 = 0)
{
	/#
		assert(isdefined(var_49fefccd), "");
	#/
	/#
		assert(n_index < var_49fefccd.size, "");
	#/
	var_3b5e4c24 = var_49fefccd[n_index];
	function_7aa5324a(var_3b5e4c24, b_wait_if_busy, var_7e649f23, var_d1295208);
}

/*
	Name: function_7aa5324a
	Namespace: zm_factory_vo
	Checksum: 0xA73FC471
	Offset: 0x1738
	Size: 0x10C
	Parameters: 4
	Flags: Linked
*/
function function_7aa5324a(var_cbd11028, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	function_218256bd(1);
	for(i = 0; i < var_cbd11028.size; i++)
	{
		if(i == 0)
		{
			var_e27770b1 = 0;
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
	Name: function_218256bd
	Namespace: zm_factory_vo
	Checksum: 0x69594EEC
	Offset: 0x1850
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
	Name: function_897246e4
	Namespace: zm_factory_vo
	Checksum: 0x23700ED8
	Offset: 0x19C8
	Size: 0x17C
	Parameters: 5
	Flags: Linked
*/
function function_897246e4(str_vo_alias, n_wait = 0, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	var_81132431 = strtok(str_vo_alias, "_");
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
	if(zm_utility::is_player_valid(e_speaker))
	{
		e_speaker function_7b697614(str_vo_alias, n_wait, b_wait_if_busy, n_priority);
	}
}

/*
	Name: function_7b697614
	Namespace: zm_factory_vo
	Checksum: 0x2830973F
	Offset: 0x1B50
	Size: 0x30C
	Parameters: 5
	Flags: Linked
*/
function function_7b697614(str_vo_alias, n_delay = 0, b_wait_if_busy = 0, n_priority = 0, var_d1295208 = 0)
{
	self endon(#"death");
	self endon(#"disconnect");
	if(!self flag::exists("in_beastmode") || !self flag::get("in_beastmode"))
	{
		if(zm_audio::arenearbyspeakersactive(10000) && (!(isdefined(var_d1295208) && var_d1295208)))
		{
			return;
		}
		if(isdefined(self.isspeaking) && self.isspeaking || (isdefined(level.sndvoxoverride) && level.sndvoxoverride))
		{
			if(isdefined(b_wait_if_busy) && b_wait_if_busy)
			{
				while(self.isspeaking || (isdefined(level.sndvoxoverride) && level.sndvoxoverride))
				{
					wait(0.1);
				}
				wait(0.35);
			}
			else
			{
				return;
			}
		}
		if(n_delay > 0)
		{
			wait(n_delay);
		}
		if(isdefined(self.isspeaking) && self.isspeaking && (isdefined(self.b_wait_if_busy) && self.b_wait_if_busy))
		{
			while(self.isspeaking)
			{
				wait(0.1);
			}
		}
		else if(isdefined(self.isspeaking) && self.isspeaking && (!(isdefined(self.b_wait_if_busy) && self.b_wait_if_busy)) || (isdefined(level.sndvoxoverride) && level.sndvoxoverride))
		{
			return;
		}
		self.isspeaking = 1;
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
	}
}

/*
	Name: vo_clear
	Namespace: zm_factory_vo
	Checksum: 0x86C0863E
	Offset: 0x1E68
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function vo_clear()
{
	self.str_vo_being_spoken = "";
	self.n_vo_priority = 0;
	self.isspeaking = 0;
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

