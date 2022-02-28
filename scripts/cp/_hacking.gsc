// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\gametypes\_save;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\load_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace hacking;

/*
	Name: __init__sytem__
	Namespace: hacking
	Checksum: 0xA04A14DF
	Offset: 0x340
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("hacking", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: hacking
	Checksum: 0xCA384341
	Offset: 0x380
	Size: 0x3C
	Parameters: 0
	Flags: None
*/
function __init__()
{
	level.hacking = spawnstruct();
	level.hacking flag::init("in_progress");
}

/*
	Name: hack
	Namespace: hacking
	Checksum: 0x67B3E7C1
	Offset: 0x3C8
	Size: 0x4C
	Parameters: 2
	Flags: None
*/
function hack(n_hacking_time, e_hacking_player)
{
	onbeginuse(e_hacking_player);
	wait(n_hacking_time);
	onenduse(undefined, e_hacking_player, 1);
}

/*
	Name: init_hack_trigger
	Namespace: hacking
	Checksum: 0x791D6C21
	Offset: 0x420
	Size: 0x2D8
	Parameters: 6
	Flags: None
*/
function init_hack_trigger(n_hacking_time = 0.5, str_objective = &"cp_hacking", str_hint_text, var_84221fce, a_keyline_objects, var_27d1693f)
{
	if(isdefined(str_hint_text))
	{
		self sethintstring(str_hint_text);
	}
	self setcursorhint("HINT_INTERACTIVE_PROMPT");
	if(!isdefined(a_keyline_objects))
	{
		a_keyline_objects = [];
	}
	else
	{
		if(!isdefined(a_keyline_objects))
		{
			a_keyline_objects = [];
		}
		else if(!isarray(a_keyline_objects))
		{
			a_keyline_objects = array(a_keyline_objects);
		}
		foreach(mdl in a_keyline_objects)
		{
			mdl oed::enable_keyline(1);
		}
	}
	visuals = [];
	game_object = gameobjects::create_use_object("any", self, visuals, (0, 0, 0), str_objective);
	game_object gameobjects::allow_use("any");
	game_object gameobjects::set_use_time(0.35);
	game_object gameobjects::set_owner_team("allies");
	game_object gameobjects::set_visible_team("any");
	game_object.onuse = &onuse;
	game_object.onbeginuse = &onbeginuse;
	game_object.onenduse = &onenduse;
	game_object.var_84221fce = var_84221fce;
	game_object.keepweapon = 1;
	game_object.var_27d1693f = var_27d1693f;
	return game_object;
}

/*
	Name: trigger_wait
	Namespace: hacking
	Checksum: 0xFCBD28CB
	Offset: 0x700
	Size: 0x20
	Parameters: 0
	Flags: None
*/
function trigger_wait()
{
	self waittill(#"trigger_hack", e_who);
	return e_who;
}

/*
	Name: onbeginuse
	Namespace: hacking
	Checksum: 0xEF3157B8
	Offset: 0x728
	Size: 0xC
	Parameters: 1
	Flags: None
*/
function onbeginuse(player)
{
}

/*
	Name: onenduse
	Namespace: hacking
	Checksum: 0x2DF3C2E7
	Offset: 0x740
	Size: 0x1C
	Parameters: 3
	Flags: None
*/
function onenduse(team, player, result)
{
}

/*
	Name: onuse
	Namespace: hacking
	Checksum: 0x827BCF4C
	Offset: 0x768
	Size: 0x2C4
	Parameters: 1
	Flags: None
*/
function onuse(player)
{
	self gameobjects::disable_object();
	if(isdefined(player))
	{
		level.hacking flag::set("in_progress");
		player cybercom::cybercom_armpulse(1);
		player clientfield::set_to_player("sndCCHacking", 2);
		player util::delay(1, undefined, &clientfield::increment_to_player, "hack_dni_fx");
		if(isdefined(self.var_27d1693f))
		{
			var_c4ed51d5 = util::spawn_model("tag_origin", player.origin, player.angles);
			var_c4ed51d5 linkto(self.var_27d1693f);
			player playerlinkto(var_c4ed51d5, "tag_origin");
			var_c4ed51d5 scene::play("cin_gen_player_hack_start", player);
			var_c4ed51d5 delete();
		}
		else
		{
			s_align = player;
			if(isdefined(self.trigger.target))
			{
				s_align = struct::get(self.trigger.target, "targetname");
			}
			s_align scene::play("cin_gen_player_hack_start", player);
		}
		level notify(#"hacking_complete", 1, player);
		self.trigger notify(#"trigger_hack", player);
		if(isdefined(player))
		{
			player clientfield::set_to_player("sndCCHacking", 0);
		}
		level.hacking flag::clear("in_progress");
	}
	if(isdefined(self.var_84221fce))
	{
		[[self.var_84221fce]]();
	}
	objective_clearentity(self.objectiveid);
	self gameobjects::destroy_object(1, undefined, 1);
}

