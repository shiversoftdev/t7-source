// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_mind_blown;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_mind_blown
	Checksum: 0x50AEDD93
	Offset: 0x260
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_mind_blown", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_mind_blown
	Checksum: 0x1648F2DF
	Offset: 0x2A0
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("actor", "zm_bgb_mind_pop_fx", 15000, 1, "int");
	clientfield::register("actor", "zm_bgb_mind_ray_fx", 15000, 1, "int");
	bgb::register("zm_bgb_mind_blown", "activated", 3, undefined, undefined, &validation, &activation);
	level.var_3e825919 = lightning_chain::create_lightning_chain_params(0, 1, 300, 20, 100, 0.11, 10, 0, 4, 1, 0, undefined, 1, 1);
}

/*
	Name: validation
	Namespace: zm_bgb_mind_blown
	Checksum: 0x407677EF
	Offset: 0x3C0
	Size: 0x22
	Parameters: 0
	Flags: Linked
*/
function validation()
{
	if(isdefined(level.var_398d0113) && level.var_398d0113)
	{
		return false;
	}
	return true;
}

/*
	Name: activation
	Namespace: zm_bgb_mind_blown
	Checksum: 0x91F886D3
	Offset: 0x3F0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function activation()
{
	self endon(#"disconnect");
	self thread function_2a8862aa();
	level thread function_80e37569();
}

/*
	Name: function_80e37569
	Namespace: zm_bgb_mind_blown
	Checksum: 0x8898C747
	Offset: 0x438
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function function_80e37569()
{
	level.var_398d0113 = 1;
	wait(5);
	level.var_398d0113 = 0;
}

/*
	Name: function_2a8862aa
	Namespace: zm_bgb_mind_blown
	Checksum: 0x138B871
	Offset: 0x460
	Size: 0x304
	Parameters: 0
	Flags: Linked
*/
function function_2a8862aa()
{
	self endon(#"disconnect");
	self endon(#"hash_7946ded7");
	var_bd6badee = 1200 * 1200;
	var_3c48f56 = [];
	allai = getaiarray();
	foreach(ai in allai)
	{
		if(isdefined(ai.var_5691b7d8) && ai [[ai.var_5691b7d8]]())
		{
			continue;
		}
		if(distance2dsquared(ai.origin, self.origin) >= var_bd6badee)
		{
			continue;
		}
		if(isalive(ai) && !ai ispaused() && ai.team == level.zombie_team && ai.archetype === "zombie" && !ai ishidden() && (!(isdefined(ai.var_85934541) && ai.var_85934541)))
		{
			array::add(var_3c48f56, ai);
		}
	}
	var_e4760c66 = [];
	var_e37fbbbd = [];
	foreach(ai in var_3c48f56)
	{
		if(distance2dsquared(ai.origin, self.origin) >= var_bd6badee)
		{
			var_e4760c66[var_e4760c66.size] = ai;
			continue;
		}
		var_e37fbbbd[var_e37fbbbd.size] = ai;
	}
	function_2ca71d8b(var_e4760c66, 1);
	function_2ca71d8b(var_e37fbbbd, 0, 75);
}

/*
	Name: function_2ca71d8b
	Namespace: zm_bgb_mind_blown
	Checksum: 0x8D63B5E0
	Offset: 0x770
	Size: 0x152
	Parameters: 3
	Flags: Linked, Private
*/
function private function_2ca71d8b(allai, trace, degree = 45)
{
	var_f1649153 = allai;
	players = getplayers();
	var_445b9352 = cos(degree);
	var_f1649153 = self cantseeentities(var_f1649153, var_445b9352, trace);
	foreach(ai in allai)
	{
		if(isinarray(var_f1649153, ai))
		{
			continue;
		}
		thread function_1bb7ee0(ai);
	}
}

/*
	Name: function_1bb7ee0
	Namespace: zm_bgb_mind_blown
	Checksum: 0xCC76E78F
	Offset: 0x8D0
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function function_1bb7ee0(ai)
{
	ai.marked_for_death = 1;
	ai.var_85934541 = 1;
	ai.no_powerups = 1;
	ai.deathpoints_already_given = 1;
	ai.tesla_head_gib_func = &zombie_head_gib;
	ai lightning_chain::arc_damage(ai, self, 1, level.var_3e825919);
}

/*
	Name: zombie_head_gib
	Namespace: zm_bgb_mind_blown
	Checksum: 0x74BBAFEA
	Offset: 0x980
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function zombie_head_gib()
{
	self endon(#"death");
	self clientfield::set("zm_bgb_mind_ray_fx", 1);
	wait(randomfloatrange(0.65, 2.5));
	self clientfield::set("zm_bgb_mind_pop_fx", 1);
	self playsoundontag("zmb_bgb_mindblown_pop", "tag_eye");
	self zombie_utility::zombie_head_gib();
}

