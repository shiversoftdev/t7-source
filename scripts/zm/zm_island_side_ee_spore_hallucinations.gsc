// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_zonemgr;
#using scripts\zm\zm_island_util;

#namespace zm_island_side_ee_spore_hallucinations;

/*
	Name: __init__sytem__
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x361863EF
	Offset: 0x4A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_island_side_ee_spore_hallucinations", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x5B969E32
	Offset: 0x4E8
	Size: 0x116
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "hallucinate_bloody_walls", 9000, 1, "int");
	clientfield::register("toplayer", "hallucinate_spooky_sounds", 9000, 1, "int");
	callback::on_spawned(&on_player_spawned);
	callback::on_connect(&on_player_connected);
	level.var_40e8eaa5 = [];
	level.var_40e8eaa5["bloody_walls"] = getent("vol_hallucinate_bloody_walls", "targetname");
	level.var_40e8eaa5["corpses"] = getent("vol_hallucinate_corpses", "targetname");
}

/*
	Name: main
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x6FB9BFF0
	Offset: 0x608
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	/#
		level thread function_c6d55b0d();
	#/
}

/*
	Name: on_player_connected
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x8E40123B
	Offset: 0x630
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function on_player_connected()
{
	self flag::init("hallucination_spookysounds_on");
	self flag::init("hallucination_bloodywalls_on");
}

/*
	Name: on_player_spawned
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x73EBBDE2
	Offset: 0x680
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self.var_5f5af9f0 = 0;
	self thread function_e58be395();
}

/*
	Name: function_e58be395
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x213284E0
	Offset: 0x6B0
	Size: 0x90
	Parameters: 0
	Flags: Linked
*/
function function_e58be395()
{
	self endon(#"death");
	self thread function_b200c473();
	while(true)
	{
		self waittill(#"hash_ece519d9");
		self.var_5f5af9f0++;
		if(self.var_5f5af9f0 > 5)
		{
			self thread function_51d3efd();
		}
		if(self.var_5f5af9f0 > 15)
		{
			self thread function_5d6bcf98();
		}
	}
}

/*
	Name: function_b200c473
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x63D0E2E4
	Offset: 0x748
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function function_b200c473()
{
	self endon(#"death");
	while(true)
	{
		wait(300);
		if(self.var_5f5af9f0 > 0)
		{
			self.var_5f5af9f0--;
		}
	}
}

/*
	Name: function_51d3efd
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x7268493C
	Offset: 0x788
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function function_51d3efd()
{
	self endon(#"death");
	if(!self flag::get("hallucination_spookysounds_on"))
	{
		self flag::set("hallucination_spookysounds_on");
		while(self.var_5f5af9f0 >= 5)
		{
			var_2499b02a = self zm_island_util::function_1867f3e8(800);
			if(var_2499b02a <= 3 && !self laststand::player_is_in_laststand())
			{
				self function_5d3a5f36();
				wait(randomintrange(360, 480));
			}
			wait(5);
		}
		self flag::clear("hallucination_spookysounds_on");
	}
}

/*
	Name: function_5d6bcf98
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0xD00B27FF
	Offset: 0x890
	Size: 0x14C
	Parameters: 0
	Flags: Linked
*/
function function_5d6bcf98()
{
	self endon(#"death");
	if(!self flag::get("hallucination_bloodywalls_on"))
	{
		self flag::set("hallucination_bloodywalls_on");
		var_558d1e01 = getent("vol_hallucinate_bloody_walls", "targetname");
		var_58077680 = array("zone_jungle_lab_upper", "zone_swamp_lab_inside", "zone_operating_rooms");
		while(self.var_5f5af9f0 >= 15)
		{
			if(self zm_island_util::function_f2a55b5f(var_58077680) && self istouching(var_558d1e01))
			{
				self function_f0e36b57();
				wait(randomintrange(360, 480));
			}
			wait(5);
		}
		self flag::clear("hallucination_bloodywalls_on");
	}
}

/*
	Name: function_5d3a5f36
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0xEBCB71DD
	Offset: 0x9E8
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function function_5d3a5f36()
{
	self hallucinate_spooky_sounds(1);
	wait(randomintrange(10, 20));
	self hallucinate_spooky_sounds(0);
}

/*
	Name: function_f0e36b57
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x27CCA0D3
	Offset: 0xA40
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function function_f0e36b57()
{
	self hallucinate_bloody_walls(1);
	exploder::exploder("ex_ee_redtanks");
	wait(randomintrange(10, 20));
	self hallucinate_bloody_walls(0);
	exploder::stop_exploder("ex_ee_redtanks");
}

/*
	Name: hallucinate_bloody_walls
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x5A7450C2
	Offset: 0xAC8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function hallucinate_bloody_walls(b_on = 1)
{
	self clientfield::set_to_player("hallucinate_bloody_walls", b_on);
}

/*
	Name: hallucinate_spooky_sounds
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0xE06F5D35
	Offset: 0xB18
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function hallucinate_spooky_sounds(b_on = 1)
{
	self clientfield::set_to_player("hallucinate_spooky_sounds", b_on);
}

/*
	Name: function_c6d55b0d
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0xCF38628A
	Offset: 0xB68
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function function_c6d55b0d()
{
	/#
		zm_devgui::add_custom_devgui_callback(&function_4c6daca1);
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
		adddebugcommand("");
	#/
}

/*
	Name: function_4c6daca1
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0xAB39E749
	Offset: 0xC18
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function function_4c6daca1(cmd)
{
	/#
		switch(cmd)
		{
			case "":
			{
				level.activeplayers[0] thread function_f0e36b57();
				return true;
			}
			case "":
			{
				level.activeplayers[0] thread function_5d3a5f36();
				return true;
			}
			case "":
			{
				level thread function_ef6cd11(5);
				return true;
			}
			case "":
			{
				level thread function_ef6cd11(10);
				return true;
			}
			case "":
			{
				level thread function_ef6cd11(20);
				return true;
			}
		}
		return false;
	#/
}

/*
	Name: function_ef6cd11
	Namespace: zm_island_side_ee_spore_hallucinations
	Checksum: 0x96B544D3
	Offset: 0xD20
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function function_ef6cd11(var_7156fcfa)
{
	/#
		foreach(player in level.activeplayers)
		{
			player.var_5f5af9f0 = var_7156fcfa;
			if(var_7156fcfa > 5)
			{
				player thread function_51d3efd();
			}
			if(var_7156fcfa > 15)
			{
				player thread function_5d6bcf98();
			}
		}
	#/
}

