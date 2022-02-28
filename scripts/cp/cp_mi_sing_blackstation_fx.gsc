// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace cp_mi_sing_blackstation_fx;

/*
	Name: main
	Namespace: cp_mi_sing_blackstation_fx
	Checksum: 0x52CBD27
	Offset: 0x168
	Size: 0x72
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level._effect["rain_light"] = "weather/fx_rain_system_lite_runner";
	level._effect["rain_medium"] = "weather/fx_rain_system_med_runner";
	level._effect["rain_heavy"] = "weather/fx_rain_system_hvy_runner_blackstation";
	level._effect["barge_sheeting"] = "weather/fx_rain_barge_sheeting_blkstn";
}

