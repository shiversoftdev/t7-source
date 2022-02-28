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

#namespace zm_shadow_zombie;

/*
	Name: __init__sytem__
	Namespace: zm_shadow_zombie
	Checksum: 0xAD6DAD33
	Offset: 0x4A8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_shadow_zombie", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_shadow_zombie
	Checksum: 0x95DA11F4
	Offset: 0x4E8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	register_clientfields();
	if(!isdefined(level._effect["cursetrap_explosion"]))
	{
		level._effect["cursetrap_explosion"] = "dlc4/genesis/fx_zombie_shadow_trap_exp";
	}
	/#
		thread function_71c88f2b();
	#/
}

/*
	Name: register_clientfields
	Namespace: zm_shadow_zombie
	Checksum: 0xD04281E1
	Offset: 0x550
	Size: 0xC4
	Parameters: 0
	Flags: Linked, Private
*/
function private register_clientfields()
{
	clientfield::register("actor", "shadow_zombie_clientfield_aura_fx", 15000, 1, "int");
	clientfield::register("actor", "shadow_zombie_clientfield_death_fx", 15000, 1, "int");
	clientfield::register("actor", "shadow_zombie_clientfield_damaged_fx", 15000, 1, "counter");
	clientfield::register("scriptmover", "shadow_zombie_cursetrap_fx", 15000, 1, "int");
}

/*
	Name: function_1b2b62b
	Namespace: zm_shadow_zombie
	Checksum: 0xC1F1E85D
	Offset: 0x620
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function function_1b2b62b()
{
	ai_zombie = self;
	var_90bd2712 = zm_elemental_zombie::function_4aeed0a5("shadow");
	if(!isdefined(level.var_6041e4d5) || var_90bd2712 < level.var_6041e4d5)
	{
		if(!isdefined(ai_zombie.is_elemental_zombie) || ai_zombie.is_elemental_zombie == 0)
		{
			ai_zombie.is_elemental_zombie = 1;
			ai_zombie.var_9a02a614 = "shadow";
			ai_zombie clientfield::set("shadow_zombie_clientfield_aura_fx", 1);
			ai_zombie.health = int(ai_zombie.health * 1);
			ai_zombie thread function_32a2f099();
			ai_zombie thread shadow_zombie_damage_fx();
		}
	}
}

/*
	Name: shadow_zombie_damage_fx
	Namespace: zm_shadow_zombie
	Checksum: 0x6857E524
	Offset: 0x758
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function shadow_zombie_damage_fx()
{
	self endon(#"entityshutdown");
	self endon(#"death");
	while(true)
	{
		self waittill(#"damage");
		if(randomint(100) < 50)
		{
			self clientfield::increment("shadow_zombie_clientfield_damaged_fx");
		}
		wait(0.05);
	}
}

/*
	Name: function_32a2f099
	Namespace: zm_shadow_zombie
	Checksum: 0xA834F1A7
	Offset: 0x7D8
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function function_32a2f099()
{
	ai_zombie = self;
	ai_zombie waittill(#"death", attacker);
	if(!isdefined(ai_zombie) || ai_zombie.nuked === 1)
	{
		return;
	}
	v_origin = ai_zombie.origin;
	v_origin = v_origin + vectorscale((0, 0, 1), 2);
	level thread function_ada13668(v_origin, undefined, 0);
	ai_zombie clientfield::set("shadow_zombie_clientfield_death_fx", 1);
	ai_zombie zombie_utility::gib_random_parts();
	wait(0.05);
	ai_zombie hide();
	ai_zombie notsolid();
}

/*
	Name: function_ada13668
	Namespace: zm_shadow_zombie
	Checksum: 0xA63440EA
	Offset: 0x8F8
	Size: 0x130
	Parameters: 3
	Flags: Linked
*/
function function_ada13668(v_origin, n_duration, var_526fc172 = 0)
{
	if(var_526fc172)
	{
		while(function_ab84e253(v_origin, 64))
		{
			wait(0.25);
		}
	}
	if(!isdefined(n_duration))
	{
		n_duration = randomfloatrange(5, 10);
	}
	e_fx_origin = util::spawn_model("tag_origin", v_origin, vectorscale((-1, 0, 0), 90));
	e_fx_origin.targetname = "shadow_curse_trap";
	e_fx_origin clientfield::set("shadow_zombie_cursetrap_fx", 1);
	e_fx_origin thread function_57b55fe1(n_duration);
	e_fx_origin thread function_48fccb59();
	return e_fx_origin;
}

/*
	Name: function_57b55fe1
	Namespace: zm_shadow_zombie
	Checksum: 0xC3161B04
	Offset: 0xA30
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private function_57b55fe1(n_duration)
{
	wait(n_duration);
	if(isdefined(self))
	{
		if(isdefined(self.trigger))
		{
			self.trigger delete();
		}
		self delete();
	}
}

/*
	Name: function_48fccb59
	Namespace: zm_shadow_zombie
	Checksum: 0x9011C59A
	Offset: 0xA98
	Size: 0x1A2
	Parameters: 1
	Flags: Linked, Private
*/
function private function_48fccb59(var_7478a6b4 = undefined)
{
	if(isdefined(var_7478a6b4))
	{
		self.trigger = spawn("trigger_radius", self.origin, 2, 40, 50);
	}
	else
	{
		self.trigger = spawn("trigger_radius", self.origin, 2, 20, 25);
	}
	while(isdefined(self))
	{
		self.trigger waittill(#"trigger", guy);
		if(isdefined(self))
		{
			playfx(level._effect["cursetrap_explosion"], self.origin);
			guy playsound("zmb_zod_cursed_landmine_explode");
			guy dodamage(guy.health / 2, guy.origin, self, self);
			if(isdefined(var_7478a6b4))
			{
				var_7478a6b4.active = 0;
			}
			if(isdefined(self.trigger))
			{
				self.trigger delete();
			}
			self delete();
			return;
		}
	}
}

/*
	Name: function_ab84e253
	Namespace: zm_shadow_zombie
	Checksum: 0xA1C4D687
	Offset: 0xC48
	Size: 0xDA
	Parameters: 2
	Flags: Linked
*/
function function_ab84e253(v_origin, n_radius)
{
	var_5a3ad5d6 = n_radius * n_radius;
	foreach(player in level.activeplayers)
	{
		if(isdefined(player) && distance2dsquared(player.origin, v_origin) <= var_5a3ad5d6)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: function_71c88f2b
	Namespace: zm_shadow_zombie
	Checksum: 0xED321119
	Offset: 0xD30
	Size: 0x228
	Parameters: 0
	Flags: Linked
*/
function function_71c88f2b()
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
						zombie function_1b2b62b();
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
					a_zombies[0] function_1b2b62b();
				}
				setdvar("", "");
			}
			wait(0.05);
		}
	#/
}

