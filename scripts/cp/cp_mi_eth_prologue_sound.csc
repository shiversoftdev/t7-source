// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;

#namespace cp_mi_eth_prologue_sound;

/*
	Name: main
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0x28A3CB86
	Offset: 0x218
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread function_aca4761();
	level thread function_669e0ca5();
	level thread function_6ce0e63();
	level thread function_35acdae6();
	level thread function_9806d032();
	level thread function_c943c5e5();
	level thread function_4b8b96fe();
	level thread function_7ec0e1ae();
	level thread function_eb4e50fb();
	level thread function_889a9ace();
}

/*
	Name: function_4b8b96fe
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0xCBBBE1A0
	Offset: 0x318
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_4b8b96fe()
{
	level audio::playloopat("amb_jail_scene_2", (5582, -2060, -218));
	level audio::playloopat("amb_jail_scene_3", (5528, -1844, -209));
	level audio::playloopat("amb_jail_scene_4", (6289, -1689, -163));
	level audio::playloopat("amb_jail_scene_5", (5530, -1634, -265));
}

/*
	Name: function_aca4761
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0x94CFB865
	Offset: 0x3C8
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function function_aca4761()
{
	level audio::playloopat("amb_firetruck_distant_alarm", (-1287, -1872, 535));
	level audio::playloopat("evt_firehose", (581, -857, 130));
	level waittill(#"hash_cfcc0f30");
	level audio::playloopat("amb_firetruck_close_alarm", (-169, -585, 161));
	level waittill(#"hash_da4c530f");
	level audio::stoploopat("amb_firetruck_distant_alarm", (-1287, -1872, 535));
	level audio::stoploopat("amb_firetruck_close_alarm", (-169, -585, 161));
	level audio::stoploopat("evt_firehose", (-169, -585, 161));
}

/*
	Name: function_669e0ca5
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0xDAF665E6
	Offset: 0x4E8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function function_669e0ca5()
{
	level audio::playloopat("vox_garbled_radio_a", (-840, -721, -13259));
	level audio::playloopat("vox_garbled_radio_b", (-1003, -580, -13262));
}

/*
	Name: function_6ce0e63
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0x2173CA22
	Offset: 0x548
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function function_6ce0e63()
{
	level audio::playloopat("evt_halway_equipment", (3437, 597, -341));
}

/*
	Name: function_eddf6028
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0x8C01DE15
	Offset: 0x580
	Size: 0x54
	Parameters: 0
	Flags: None
*/
function function_eddf6028()
{
	level waittill(#"hash_6e2fd964");
	audio::snd_set_snapshot("cp_prologue_exit_apc");
	level waittill(#"hash_36f74bd3");
	audio::snd_set_snapshot("default");
}

/*
	Name: function_35acdae6
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0x99EC1590
	Offset: 0x5E0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_35acdae6()
{
}

/*
	Name: function_9806d032
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0x6EA67287
	Offset: 0x5F0
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_9806d032()
{
	level waittill(#"hash_ef5b1f55");
	level endon(#"hash_73c9d58d");
	location1 = (15816, -749, 454);
	location2 = (15248, -749, 463);
	location3 = (15807, -1927, 478);
	count = 0;
	while(true)
	{
		level thread function_ab91e7b9(location1);
		if(count > 5)
		{
			level thread function_ab91e7b9(location2);
		}
		if(count > 10)
		{
			level thread function_ab91e7b9(location3);
		}
		wait(1);
		count++;
	}
}

/*
	Name: function_ab91e7b9
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0x682AB48B
	Offset: 0x6F8
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_ab91e7b9(location)
{
	wait(randomfloatrange(0.25, 2));
	playsound(0, "evt_garage_robot_hit", location);
}

/*
	Name: function_c943c5e5
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0x9CB278CC
	Offset: 0x750
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_c943c5e5()
{
	level waittill(#"saw");
	wait(5);
	level notify(#"hash_f8c8ddf6");
	audio::playloopat("amb_base_distant_walla", (12187, -167, 1183));
	audio::playloopat("amb_base_alert_outside", (14740, -1188, 751));
}

/*
	Name: function_7ec0e1ae
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0x56A57403
	Offset: 0x7D0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function function_7ec0e1ae()
{
	level waittill(#"hash_dade54fb");
	audio::playloopat("amb_distant_soldier_walla", (8160, 756, 270));
	level waittill(#"hash_d1ef0d27");
	level waittill(#"hash_d1ef0d27");
	audio::stoploopat("amb_distant_soldier_walla", (8160, 756, 270));
}

/*
	Name: function_eb4e50fb
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0xA8CA2E
	Offset: 0x850
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_eb4e50fb()
{
	level waittill(#"hash_caebb0ab");
	audio::playloopat("amb_distant_soldier_walla", (12604, 1857, 357));
	level waittill(#"hash_f8c8ddf6");
	audio::stoploopat("amb_distant_soldier_walla", (12604, 1857, 357));
}

/*
	Name: function_889a9ace
	Namespace: cp_mi_eth_prologue_sound
	Checksum: 0xDA0C9E29
	Offset: 0x8C0
	Size: 0x294
	Parameters: 0
	Flags: Linked
*/
function function_889a9ace()
{
	level waittill(#"hash_dccb7956");
	audio::playloopat("amb_darkbattle_battery_beep", (13849, 2832, 226));
	audio::playloopat("amb_darkbattle_battery_beep", (13521, 3259, 229));
	audio::playloopat("amb_darkbattle_battery_beep", (13287, 3267, 226));
	audio::playloopat("amb_darkbattle_battery_beep", (13584, 2694, 253));
	audio::playloopat("amb_darkbattle_battery_beep", (13008, 2740, 249));
	audio::playloopat("amb_darkbattle_battery_beep", (13008, 2549, 249));
	audio::playloopat("amb_darkbattle_battery_beep", (13147, 2544, 245));
	audio::playloopat("amb_darkbattle_battery_beep", (13870, 2403, 242));
	level waittill(#"hash_e94a4dcf");
	audio::stoploopat("amb_darkbattle_battery_beep", (13849, 2832, 226));
	audio::stoploopat("amb_darkbattle_battery_beep", (13521, 3259, 229));
	audio::stoploopat("amb_darkbattle_battery_beep", (13287, 3267, 226));
	audio::stoploopat("amb_darkbattle_battery_beep", (13584, 2694, 253));
	audio::stoploopat("amb_darkbattle_battery_beep", (13008, 2740, 249));
	audio::stoploopat("amb_darkbattle_battery_beep", (13008, 2549, 249));
	audio::stoploopat("amb_darkbattle_battery_beep", (13147, 2544, 245));
	audio::stoploopat("amb_darkbattle_battery_beep", (13870, 2403, 242));
}

