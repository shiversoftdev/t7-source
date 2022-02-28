// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\_burnplayer;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_elemental_zombies;

#namespace zm_light_zombie;

/*
	Name: __init__sytem__
	Namespace: zm_light_zombie
	Checksum: 0xD7E28D21
	Offset: 0x418
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_light_zombie", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_light_zombie
	Checksum: 0xAF548679
	Offset: 0x458
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	register_clientfields();
	/#
		thread function_ff8b7145();
	#/
}

/*
	Name: register_clientfields
	Namespace: zm_light_zombie
	Checksum: 0x660078B6
	Offset: 0x490
	Size: 0x94
	Parameters: 0
	Flags: Linked, Private
*/
function private register_clientfields()
{
	clientfield::register("actor", "light_zombie_clientfield_aura_fx", 15000, 1, "int");
	clientfield::register("actor", "light_zombie_clientfield_death_fx", 15000, 1, "int");
	clientfield::register("actor", "light_zombie_clientfield_damaged_fx", 15000, 1, "counter");
}

/*
	Name: function_a35db70f
	Namespace: zm_light_zombie
	Checksum: 0xDCEA95C4
	Offset: 0x530
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_a35db70f()
{
	ai_zombie = self;
	var_715d2624 = zm_elemental_zombie::function_4aeed0a5("light");
	if(!isdefined(level.var_4a762097) || var_715d2624 < level.var_4a762097)
	{
		if(!isdefined(ai_zombie.is_elemental_zombie) || ai_zombie.is_elemental_zombie == 0)
		{
			ai_zombie.is_elemental_zombie = 1;
			ai_zombie.var_9a02a614 = "light";
			ai_zombie.health = int(ai_zombie.health * 1);
			ai_zombie thread light_zombie_death();
			ai_zombie thread function_68da949();
			ai_zombie thread function_cb744db7();
		}
	}
}

/*
	Name: function_cb744db7
	Namespace: zm_light_zombie
	Checksum: 0x3B185D59
	Offset: 0x658
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function function_cb744db7()
{
	self endon(#"death");
	wait(2);
	self clientfield::set("light_zombie_clientfield_aura_fx", 1);
}

/*
	Name: function_68da949
	Namespace: zm_light_zombie
	Checksum: 0xB0D7002A
	Offset: 0x698
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function function_68da949()
{
	self endon(#"entityshutdown");
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage");
		if(randomint(100) < 50)
		{
			self clientfield::increment("light_zombie_clientfield_damaged_fx");
		}
		wait(0.05);
	}
}

/*
	Name: light_zombie_death
	Namespace: zm_light_zombie
	Checksum: 0xD1349829
	Offset: 0x718
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function light_zombie_death()
{
	ai_zombie = self;
	ai_zombie waittill(#"death", attacker);
	if(!isdefined(ai_zombie) || ai_zombie.nuked === 1)
	{
		return;
	}
	v_origin = ai_zombie.origin;
	v_origin = v_origin + vectorscale((0, 0, 1), 2);
	ai_zombie clientfield::set("light_zombie_clientfield_death_fx", 1);
	ai_zombie zombie_utility::gib_random_parts();
	wait(0.05);
	var_e0d84aa = "MOD_EXPLOSIVE";
	radiusdamage(ai_zombie.origin + vectorscale((0, 0, 1), 35), 128, 30, 10, self, var_e0d84aa);
	a_players = getplayers();
	foreach(player in a_players)
	{
		player thread function_4745b0a9(ai_zombie.origin);
	}
	ai_zombie hide();
	ai_zombie notsolid();
}

/*
	Name: function_4745b0a9
	Namespace: zm_light_zombie
	Checksum: 0x7D16CC23
	Offset: 0x920
	Size: 0x194
	Parameters: 1
	Flags: Linked
*/
function function_4745b0a9(flash_origin)
{
	self endon(#"death");
	self endon(#"disconnect");
	player = self;
	dist_sq = distancesquared(player.origin, flash_origin);
	var_bfff29b1 = 16384;
	var_1536d9e9 = 4096;
	var_b79af7d4 = var_bfff29b1 - var_1536d9e9;
	if(dist_sq <= var_bfff29b1 && (!(isdefined(player.var_442e1e5b) && player.var_442e1e5b)))
	{
		if(dist_sq < var_1536d9e9)
		{
			flash_time = 1;
		}
		else
		{
			var_ff8b2f91 = (var_bfff29b1 - dist_sq) / var_b79af7d4;
			var_6e07e9bc = var_ff8b2f91 * 0.5;
			flash_time = 1 - var_6e07e9bc;
		}
		if(isdefined(flash_time))
		{
			flash_time = math::clamp(flash_time, 0.5, 1);
			player thread function_2335214f(flash_time);
		}
	}
}

/*
	Name: function_2335214f
	Namespace: zm_light_zombie
	Checksum: 0xC3B9D835
	Offset: 0xAC0
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_2335214f(flash_time)
{
	self endon(#"death");
	self endon(#"disconnect");
	player = self;
	player.var_442e1e5b = 1;
	player shellshock("light_zombie_death", flash_time, 0);
	wait(5);
	player.var_442e1e5b = 0;
}

/*
	Name: function_ff8b7145
	Namespace: zm_light_zombie
	Checksum: 0x9B395481
	Offset: 0xB48
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function function_ff8b7145()
{
	/#
		wait(0.05);
		level waittill(#"start_zombie_round_logic");
		wait(0.05);
		str_cmd = "";
		adddebugcommand(str_cmd);
		str_cmd = "";
		adddebugcommand(str_cmd);
		while(true)
		{
			string = getdvarstring("");
			if(string == "")
			{
				a_zombies = zm_elemental_zombie::function_d41418b8();
				if(a_zombies.size > 0)
				{
					foreach(zombie in a_zombies)
					{
						zombie function_a35db70f();
					}
				}
				setdvar("", "");
			}
			if(string == "")
			{
				a_zombies = zm_elemental_zombie::function_d41418b8();
				if(a_zombies.size > 0)
				{
					a_zombies = arraysortclosest(a_zombies, level.players[0].origin);
					a_zombies[0] function_a35db70f();
				}
				setdvar("", "");
			}
			wait(0.05);
		}
	#/
}

