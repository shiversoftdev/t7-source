// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\aat_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#namespace zm_aat_blast_furnace;

/*
	Name: __init__sytem__
	Namespace: zm_aat_blast_furnace
	Checksum: 0x45B18C7A
	Offset: 0x2A0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_blast_furnace", &__init__, undefined, "aat");
}

/*
	Name: __init__
	Namespace: zm_aat_blast_furnace
	Checksum: 0x3490D32E
	Offset: 0x2E0
	Size: 0x144
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	aat::register("zm_aat_blast_furnace", 0.15, 0, 15, 0, 1, &result, "t7_hud_zm_aat_blastfurnace", "wpn_aat_blast_furnace_plr");
	clientfield::register("actor", "zm_aat_blast_furnace" + "_explosion", 1, 1, "counter");
	clientfield::register("vehicle", "zm_aat_blast_furnace" + "_explosion_vehicle", 1, 1, "counter");
	clientfield::register("actor", "zm_aat_blast_furnace" + "_burn", 1, 1, "counter");
	clientfield::register("vehicle", "zm_aat_blast_furnace" + "_burn_vehicle", 1, 1, "counter");
}

/*
	Name: result
	Namespace: zm_aat_blast_furnace
	Checksum: 0xD336C103
	Offset: 0x430
	Size: 0x44
	Parameters: 4
	Flags: Linked
*/
function result(death, attacker, mod, weapon)
{
	self thread blast_furnace_explosion(attacker, weapon);
}

/*
	Name: blast_furnace_explosion
	Namespace: zm_aat_blast_furnace
	Checksum: 0xE49EC50E
	Offset: 0x480
	Size: 0x3CC
	Parameters: 2
	Flags: Linked
*/
function blast_furnace_explosion(e_attacker, w_weapon)
{
	if(isvehicle(self))
	{
		self thread clientfield::increment("zm_aat_blast_furnace" + "_explosion_vehicle");
	}
	else
	{
		self thread clientfield::increment("zm_aat_blast_furnace" + "_explosion");
	}
	a_e_blasted_zombies = array::get_all_closest(self.origin, getaiteamarray("axis"), undefined, undefined, 120);
	if(a_e_blasted_zombies.size > 0)
	{
		i = 0;
		while(i < a_e_blasted_zombies.size)
		{
			if(isalive(a_e_blasted_zombies[i]))
			{
				if(isdefined(level.aat["zm_aat_blast_furnace"].immune_result_indirect[a_e_blasted_zombies[i].archetype]) && level.aat["zm_aat_blast_furnace"].immune_result_indirect[a_e_blasted_zombies[i].archetype])
				{
					arrayremovevalue(a_e_blasted_zombies, a_e_blasted_zombies[i]);
					continue;
				}
				if(a_e_blasted_zombies[i] == self && (!(isdefined(level.aat["zm_aat_blast_furnace"].immune_result_direct[a_e_blasted_zombies[i].archetype]) && level.aat["zm_aat_blast_furnace"].immune_result_direct[a_e_blasted_zombies[i].archetype])))
				{
					self thread zombie_death_gib(e_attacker, w_weapon);
					if(isvehicle(a_e_blasted_zombies[i]))
					{
						a_e_blasted_zombies[i] thread clientfield::increment("zm_aat_blast_furnace" + "_burn_vehicle");
					}
					else
					{
						a_e_blasted_zombies[i] thread clientfield::increment("zm_aat_blast_furnace" + "_burn");
					}
					arrayremovevalue(a_e_blasted_zombies, a_e_blasted_zombies[i]);
					continue;
				}
				if(isvehicle(a_e_blasted_zombies[i]))
				{
					a_e_blasted_zombies[i] thread clientfield::increment("zm_aat_blast_furnace" + "_burn_vehicle");
				}
				else
				{
					a_e_blasted_zombies[i] thread clientfield::increment("zm_aat_blast_furnace" + "_burn");
				}
			}
			i++;
		}
		wait(0.25);
		a_e_blasted_zombies = array::remove_dead(a_e_blasted_zombies);
		a_e_blasted_zombies = array::remove_undefined(a_e_blasted_zombies);
		array::thread_all(a_e_blasted_zombies, &blast_furnace_zombie_burn, e_attacker, w_weapon);
	}
}

/*
	Name: blast_furnace_zombie_burn
	Namespace: zm_aat_blast_furnace
	Checksum: 0x4DBBDCE1
	Offset: 0x858
	Size: 0xD0
	Parameters: 2
	Flags: Linked
*/
function blast_furnace_zombie_burn(e_attacker, w_weapon)
{
	self endon(#"death");
	n_damage = self.health / 6;
	i = 0;
	while(i <= 6)
	{
		if(self.health < n_damage)
		{
			e_attacker zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_BLAST_FURNACE");
		}
		self dodamage(n_damage, self.origin, e_attacker, undefined, "none", "MOD_UNKNOWN", 0, w_weapon);
		i++;
		wait(0.5);
	}
}

/*
	Name: zombie_death_gib
	Namespace: zm_aat_blast_furnace
	Checksum: 0x8AD1D450
	Offset: 0x930
	Size: 0xEC
	Parameters: 2
	Flags: Linked
*/
function zombie_death_gib(e_attacker, w_weapon)
{
	gibserverutils::gibhead(self);
	if(math::cointoss())
	{
		gibserverutils::gibleftarm(self);
	}
	else
	{
		gibserverutils::gibrightarm(self);
	}
	gibserverutils::giblegs(self);
	self dodamage(self.health, self.origin, e_attacker);
	if(isdefined(e_attacker) && isplayer(e_attacker))
	{
		e_attacker zm_stats::increment_challenge_stat("ZOMBIE_HUNTER_BLAST_FURNACE");
	}
}

