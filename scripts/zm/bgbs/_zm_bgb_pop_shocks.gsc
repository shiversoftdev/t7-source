// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_pop_shocks;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_pop_shocks
	Checksum: 0x5D6D53E0
	Offset: 0x1D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_pop_shocks", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_pop_shocks
	Checksum: 0x45DDD2C6
	Offset: 0x218
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_pop_shocks", "event", &event, undefined, undefined, undefined);
	bgb::register_actor_damage_override("zm_bgb_pop_shocks", &actor_damage_override);
	bgb::register_vehicle_damage_override("zm_bgb_pop_shocks", &vehicle_damage_override);
}

/*
	Name: event
	Namespace: zm_bgb_pop_shocks
	Checksum: 0x235259FA
	Offset: 0x2C8
	Size: 0x50
	Parameters: 0
	Flags: Linked
*/
function event()
{
	self endon(#"disconnect");
	self endon(#"death");
	self endon(#"bgb_update");
	self.var_69d5dd7c = 5;
	while(self.var_69d5dd7c > 0)
	{
		wait(0.1);
	}
}

/*
	Name: actor_damage_override
	Namespace: zm_bgb_pop_shocks
	Checksum: 0xAB421B3C
	Offset: 0x320
	Size: 0x90
	Parameters: 12
	Flags: Linked
*/
function actor_damage_override(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(meansofdeath === "MOD_MELEE")
	{
		attacker function_e0e68a99(self);
	}
	return damage;
}

/*
	Name: vehicle_damage_override
	Namespace: zm_bgb_pop_shocks
	Checksum: 0x8B94DF9E
	Offset: 0x3B8
	Size: 0xA8
	Parameters: 15
	Flags: Linked
*/
function vehicle_damage_override(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(smeansofdeath === "MOD_MELEE")
	{
		eattacker function_e0e68a99(self);
	}
	return idamage;
}

/*
	Name: function_e0e68a99
	Namespace: zm_bgb_pop_shocks
	Checksum: 0xB40BFF8C
	Offset: 0x468
	Size: 0x1CA
	Parameters: 1
	Flags: Linked
*/
function function_e0e68a99(target)
{
	if(isdefined(self.beastmode) && self.beastmode)
	{
		return;
	}
	self bgb::do_one_shot_use();
	self.var_69d5dd7c = self.var_69d5dd7c - 1;
	self bgb::set_timer(self.var_69d5dd7c, 5);
	self playsound("zmb_bgb_popshocks_impact");
	zombie_list = getaiteamarray(level.zombie_team);
	foreach(ai in zombie_list)
	{
		if(!isdefined(ai) || !isalive(ai))
		{
			continue;
		}
		test_origin = ai getcentroid();
		dist_sq = distancesquared(target.origin, test_origin);
		if(dist_sq < 16384)
		{
			self thread electrocute_actor(ai);
		}
	}
}

/*
	Name: electrocute_actor
	Namespace: zm_bgb_pop_shocks
	Checksum: 0x4D924C41
	Offset: 0x640
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function electrocute_actor(ai)
{
	self endon(#"disconnect");
	if(!isdefined(ai) || !isalive(ai))
	{
		return;
	}
	ai notify(#"bhtn_action_notify", "electrocute");
	if(!isdefined(self.tesla_enemies_hit))
	{
		self.tesla_enemies_hit = 1;
	}
	create_lightning_params();
	ai.tesla_death = 0;
	ai thread arc_damage_init(self);
	ai thread tesla_death();
}

/*
	Name: create_lightning_params
	Namespace: zm_bgb_pop_shocks
	Checksum: 0x2FBCB64C
	Offset: 0x710
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function create_lightning_params()
{
	level.zm_bgb_pop_shocks_lightning_params = lightning_chain::create_lightning_chain_params(5);
	level.zm_bgb_pop_shocks_lightning_params.head_gib_chance = 100;
	level.zm_bgb_pop_shocks_lightning_params.network_death_choke = 4;
	level.zm_bgb_pop_shocks_lightning_params.should_kill_enemies = 0;
}

/*
	Name: arc_damage_init
	Namespace: zm_bgb_pop_shocks
	Checksum: 0x2DA98F28
	Offset: 0x778
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function arc_damage_init(player)
{
	player endon(#"disconnect");
	if(isdefined(self.zombie_tesla_hit) && self.zombie_tesla_hit)
	{
		return;
	}
	self lightning_chain::arc_damage_ent(player, 1, level.zm_bgb_pop_shocks_lightning_params);
}

/*
	Name: tesla_death
	Namespace: zm_bgb_pop_shocks
	Checksum: 0xB398D8D7
	Offset: 0x7D8
	Size: 0x54
	Parameters: 0
	Flags: Linked
*/
function tesla_death()
{
	self endon(#"death");
	self thread function_862aadab(1);
	wait(2);
	self dodamage(self.health + 1, self.origin);
}

/*
	Name: function_862aadab
	Namespace: zm_bgb_pop_shocks
	Checksum: 0xB70D9173
	Offset: 0x838
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function function_862aadab(random_gibs)
{
	self waittill(#"death");
	if(isdefined(self) && isactor(self))
	{
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::gibhead(self);
		}
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::gibleftarm(self);
		}
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::gibrightarm(self);
		}
		if(!random_gibs || randomint(100) < 50)
		{
			gibserverutils::giblegs(self);
		}
	}
}

