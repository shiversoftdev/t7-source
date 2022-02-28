// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\zm\zm_sumpf_perks;
#using scripts\zm\zm_sumpf_trap_pendulum;
#using scripts\zm\zm_sumpf_zipline;

#namespace zm_sumpf_magic_box;

/*
	Name: magic_box_init
	Namespace: zm_sumpf_magic_box
	Checksum: 0xD83F6499
	Offset: 0x2C8
	Size: 0xBC
	Parameters: 0
	Flags: Linked
*/
function magic_box_init()
{
	level thread waitfor_flag_open_chest_location("nw_magic_box");
	level thread waitfor_flag_open_chest_location("ne_magic_box");
	level thread waitfor_flag_open_chest_location("se_magic_box");
	level thread waitfor_flag_open_chest_location("sw_magic_box");
	level thread waitfor_flag_open_chest_location("start_zombie_round_logic");
	level.pandora_fx_func = &swamp_pandora_fx_func;
}

/*
	Name: swamp_pandora_fx_func
	Namespace: zm_sumpf_magic_box
	Checksum: 0x85698F57
	Offset: 0x390
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function swamp_pandora_fx_func()
{
	self.pandora_light = spawn("script_model", self.origin);
	self.pandora_light.angles = self.angles + (vectorscale((-1, -1, 0), 90));
	self.pandora_light setmodel("tag_origin");
	if(self.script_noteworthy == "start_chest")
	{
		playfxontag(level._effect["lght_marker"], self.pandora_light, "tag_origin");
	}
	else
	{
		playfxontag(level._effect["lght_marker_old"], self.pandora_light, "tag_origin");
	}
}

/*
	Name: waitfor_flag_open_chest_location
	Namespace: zm_sumpf_magic_box
	Checksum: 0xDC865184
	Offset: 0x490
	Size: 0x2FA
	Parameters: 1
	Flags: Linked
*/
function waitfor_flag_open_chest_location(which)
{
	wait(3);
	switch(which)
	{
		case "nw_magic_box":
		{
			function_a0db1fb9();
			break;
		}
		case "ne_magic_box":
		{
			level flag::wait_till("ne_magic_box");
			level thread zm_sumpf_zipline::initzipline();
			break;
		}
		case "se_magic_box":
		{
			level flag::wait_till("se_magic_box");
			break;
		}
		case "sw_magic_box":
		{
			level flag::wait_till("sw_magic_box");
			break;
		}
		case "start_zombie_round_logic":
		{
			level flag::wait_till("start_zombie_round_logic");
			break;
		}
		default:
		{
			return;
		}
	}
	if(isdefined(level.randomize_perks) && level.randomize_perks == 0)
	{
		zm_sumpf_perks::randomize_vending_machines();
		level.vending_model_info = [];
		level.vending_model_info[level.vending_model_info.size] = "p7_zm_vending_jugg";
		level.vending_model_info[level.vending_model_info.size] = "p7_zm_vending_doubletap2";
		level.vending_model_info[level.vending_model_info.size] = "p7_zm_vending_revive";
		level.vending_model_info[level.vending_model_info.size] = "p7_zm_vending_sleight";
		level.vending_model_info[level.vending_model_info.size] = "p7_zm_vending_three_gun";
		level.randomize_perks = 1;
	}
	switch(which)
	{
		case "nw_magic_box":
		{
			level flag::wait_till("northwest_building_unlocked");
			zm_sumpf_perks::vending_randomization_effect(0);
			break;
		}
		case "ne_magic_box":
		{
			level flag::wait_till("northeast_building_unlocked");
			zm_sumpf_perks::vending_randomization_effect(1);
			break;
		}
		case "se_magic_box":
		{
			level flag::wait_till("southeast_building_unlocked");
			zm_sumpf_perks::vending_randomization_effect(2);
			break;
		}
		case "sw_magic_box":
		{
			level flag::wait_till("southwest_building_unlocked");
			zm_sumpf_perks::vending_randomization_effect(3);
			break;
		}
		case "start_zombie_round_logic":
		{
			break;
		}
	}
}

/*
	Name: function_a0db1fb9
	Namespace: zm_sumpf_magic_box
	Checksum: 0x1AA1F55A
	Offset: 0x798
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function function_a0db1fb9()
{
	penbuytrigger = getentarray("pendulum_buy_trigger", "targetname");
	foreach(var_d8a7af6f in penbuytrigger)
	{
		var_d8a7af6f sethintstring(&"ZOMBIE_CLEAR_DEBRIS");
		var_d8a7af6f setcursorhint("HINT_NOICON");
	}
	level flag::wait_till("nw_magic_box");
	zm_sumpf_trap_pendulum::initpendulumtrap();
	array::thread_all(penbuytrigger, &zm_sumpf_trap_pendulum::penthink);
}

