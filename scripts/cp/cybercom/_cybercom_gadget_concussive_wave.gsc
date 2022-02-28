// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_challenges;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace cybercom_gadget_concussive_wave;

/*
	Name: init
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x99EC1590
	Offset: 0x548
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init()
{
}

/*
	Name: main
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x9B7E42C4
	Offset: 0x558
	Size: 0x184
	Parameters: 0
	Flags: Linked
*/
function main()
{
	cybercom_gadget::registerability(1, 4, 1);
	level.cybercom.concussive_wave = spawnstruct();
	level.cybercom.concussive_wave._is_flickering = &_is_flickering;
	level.cybercom.concussive_wave._on_flicker = &_on_flicker;
	level.cybercom.concussive_wave._on_give = &_on_give;
	level.cybercom.concussive_wave._on_take = &_on_take;
	level.cybercom.concussive_wave._on_connect = &_on_connect;
	level.cybercom.concussive_wave._on = &_on;
	level.cybercom.concussive_wave._off = &_off;
	level.cybercom.concussive_wave._is_primed = &_is_primed;
}

/*
	Name: _is_flickering
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x5BF952C9
	Offset: 0x6E8
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function _is_flickering(slot)
{
}

/*
	Name: _on_flicker
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0xF3CEFFC0
	Offset: 0x700
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_flicker(slot, weapon)
{
}

/*
	Name: _on_give
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x48CC573F
	Offset: 0x720
	Size: 0x1A4
	Parameters: 2
	Flags: Linked
*/
function _on_give(slot, weapon)
{
	self.cybercom.concussive_wave_radius = getdvarint("scr_concussive_wave_radius", 310);
	self.cybercom.spikeweapon = getweapon("hero_gravityspikes_cybercom");
	self.cybercom.var_46ad3e37 = getdvarint("scr_concussive_wave_kill_radius", 195);
	if(self hascybercomability("cybercom_concussive") == 2)
	{
		self.cybercom.concussive_wave_radius = getdvarint("scr_concussive_wave_upg_radius", 310);
		self.cybercom.spikeweapon = getweapon("hero_gravityspikes_cybercom_upgraded");
	}
	self.cybercom.concussive_wave_knockdown_damage = 5 * getdvarfloat("scr_concussive_wave_scale", 1);
	self.cybercom.targetlockcb = &_get_valid_targets;
	self.cybercom.targetlockrequirementcb = &_lock_requirement;
	self thread cybercom::function_b5f4e597(weapon);
}

/*
	Name: _on_take
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x8BD4B8D7
	Offset: 0x8D0
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _on_take(slot, weapon)
{
}

/*
	Name: _on_connect
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x99EC1590
	Offset: 0x8F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function _on_connect()
{
}

/*
	Name: _on
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x1AAEEE4C
	Offset: 0x900
	Size: 0x1A4
	Parameters: 2
	Flags: Linked
*/
function _on(slot, weapon)
{
	if(self getstance() == "prone")
	{
		self gadgetdeactivate(slot, weapon, 2);
		return;
	}
	if(self isswitchingweapons())
	{
		self gadgetdeactivate(slot, weapon, 2);
		return;
	}
	if(self isonladder())
	{
		self gadgetdeactivate(slot, weapon, 2);
		return;
	}
	cybercom::function_adc40f11(weapon, 1);
	self thread create_concussion_wave(self.cybercom.concussive_wave_damage, slot, weapon);
	level.var_b1ae49b1 = gettime();
	if(isplayer(self))
	{
		itemindex = getitemindexfromref("cybercom_concussive");
		if(isdefined(itemindex))
		{
			self adddstat("ItemStats", itemindex, "stats", "used", "statValue", 1);
		}
	}
}

/*
	Name: _off
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x16603A71
	Offset: 0xAB0
	Size: 0x20
	Parameters: 2
	Flags: Linked
*/
function _off(slot, weapon)
{
	level.var_61196c7 = gettime();
}

/*
	Name: _is_primed
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x61077BD7
	Offset: 0xAD8
	Size: 0x14
	Parameters: 2
	Flags: Linked
*/
function _is_primed(slot, weapon)
{
}

/*
	Name: ai_activateconcussivewave
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x4C5460A0
	Offset: 0xAF8
	Size: 0xE4
	Parameters: 2
	Flags: Linked
*/
function ai_activateconcussivewave(damage, var_9bc2efcb = 1)
{
	if(isdefined(var_9bc2efcb) && var_9bc2efcb)
	{
		type = self cybercom::function_5e3d3aa();
		self orientmode("face default");
		self animscripted("ai_cybercom_anim", self.origin, self.angles, ("ai_base_rifle_" + type) + "_exposed_cybercom_activate");
		self waittillmatch(#"ai_cybercom_anim");
	}
	self create_concussion_wave(damage);
}

/*
	Name: _get_valid_targets
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x50B7817F
	Offset: 0xBE8
	Size: 0x162
	Parameters: 1
	Flags: Linked, Private
*/
function private _get_valid_targets(weapon)
{
	humans = arraycombine(getaispeciesarray("axis", "human"), getaispeciesarray("team3", "human"), 0, 0);
	robots = arraycombine(getaispeciesarray("axis", "robot"), getaispeciesarray("team3", "robot"), 0, 0);
	zombies = arraycombine(getaispeciesarray("axis", "zombie"), getaispeciesarray("team3", "zombie"), 0, 0);
	return arraycombine(zombies, arraycombine(humans, robots, 0, 0), 0, 0);
}

/*
	Name: _lock_requirement
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x4A108F88
	Offset: 0xD58
	Size: 0x5E
	Parameters: 1
	Flags: Linked, Private
*/
function private _lock_requirement(target)
{
	if(target cybercom::cybercom_aicheckoptout("cybercom_concussive"))
	{
		return false;
	}
	if(isdefined(target.usingvehicle) && target.usingvehicle)
	{
		return false;
	}
	return true;
}

/*
	Name: is_jumping
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x9D5316A2
	Offset: 0xDC0
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function is_jumping()
{
	ground_ent = self getgroundent();
	return !isdefined(ground_ent);
}

/*
	Name: create_damage_wave
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x1F696B0C
	Offset: 0xDF8
	Size: 0x77A
	Parameters: 2
	Flags: Linked
*/
function create_damage_wave(damage, attacker)
{
	if(!isplayer(attacker))
	{
		playfx("weapon/fx_ability_concussive_wave_impact", attacker.origin);
	}
	/#
		assert(isdefined(attacker));
	#/
	enemies = _get_valid_targets();
	if(enemies.size == 0)
	{
		return;
	}
	radius = (isdefined(attacker.cybercom) ? attacker.cybercom.concussive_wave_radius : getdvarint("scr_concussive_wave_radius", 310));
	var_7c2e0a1a = (isdefined(attacker.cybercom) ? attacker.cybercom.var_46ad3e37 : getdvarint("scr_concussive_wave_kill_radius", 195));
	var_f52a5901 = (isdefined(attacker.cybercom) ? attacker.cybercom.concussive_wave_knockdown_damage : 5);
	closetargets = arraysortclosest(enemies, attacker.origin, enemies.size, 0, radius);
	weapon = getweapon("gadget_concussive_wave");
	physicsexplosionsphere(attacker.origin, 512, 512, 1);
	if(isdefined(closetargets) && closetargets.size)
	{
		foreach(enemy in closetargets)
		{
			if(!isdefined(enemy) || !isdefined(enemy.origin))
			{
				continue;
			}
			if(!cybercom::targetisvalid(enemy, weapon))
			{
				continue;
			}
			enemy notify(#"hash_f8c5dd60", weapon, attacker);
			attacker notify(#"hash_f045e164");
			if(enemy cybercom::function_421746e0())
			{
				enemy kill(enemy.origin, attacker);
				continue;
			}
			if(enemy.archetype == "human" || enemy.archetype == "warlord" || enemy.archetype == "human_riotshield")
			{
				enemy dodamage(var_f52a5901, attacker.origin, attacker, attacker, "none", "MOD_UNKNOWN", 0, weapon, -1, 1);
				enemy notify(#"bhtn_action_notify", "reactBodyBlow");
				enemy thread function_78e146a3();
				attacker thread challenges::function_96ed590f("cybercom_uses_martial");
				attacker thread challenges::function_96ed590f("cybercom_uses_concussive");
				continue;
			}
			if(enemy.archetype == "robot")
			{
				if((length(attacker.origin - enemy.origin)) < var_7c2e0a1a)
				{
					enemy thread function_74fb2002(randomfloatrange(1, 2.5), attacker, weapon);
				}
				else if(function_f98dd1a9(enemy, attacker) < 0.83)
				{
					enemy thread function_74fb2002(randomfloatrange(0.5, 1.5), attacker, weapon);
				}
				enemy clientfield::set("cybercom_shortout", 0);
				enemy ai::set_behavior_attribute("force_crawler", "gib_legs");
				attacker thread challenges::function_96ed590f("cybercom_uses_martial");
				attacker thread challenges::function_96ed590f("cybercom_uses_concussive");
				continue;
			}
			if(enemy.archetype == "zombie")
			{
				enemy dodamage(enemy.health + 1, enemy.origin, attacker, attacker, (randomint(100) > 50 ? "right_leg_lower" : "left_leg_lower"), "MOD_UNKNOWN", 0, getweapon("frag_grenade"), -1, 1);
				attacker thread challenges::function_96ed590f("cybercom_uses_martial");
				attacker thread challenges::function_96ed590f("cybercom_uses_concussive");
				if(!isalive(enemy))
				{
					enemy startragdoll();
					launchdir = vectornormalize(enemy.origin - attacker.origin);
					enemy launchragdoll((launchdir[0] * 70, launchdir[1] * 70, 120));
				}
			}
		}
	}
}

/*
	Name: function_74fb2002
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0xA886E96D
	Offset: 0x1580
	Size: 0x74
	Parameters: 3
	Flags: Linked
*/
function function_74fb2002(n_time, attacker, weapon)
{
	self endon(#"death");
	wait(n_time);
	self dodamage(self.health + 1, self.origin, attacker, attacker, "none", "MOD_UNKNOWN", 0, weapon);
}

/*
	Name: function_f98dd1a9
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0xB8D005F9
	Offset: 0x1600
	Size: 0x92
	Parameters: 2
	Flags: Linked
*/
function function_f98dd1a9(enemy, attacker)
{
	v_to_enemy = enemy.origin - attacker.origin;
	var_2e3e72d7 = anglestoforward(attacker.angles);
	return vectordot(var_2e3e72d7, vectornormalize(v_to_enemy));
}

/*
	Name: function_78e146a3
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x4438C821
	Offset: 0x16A0
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function function_78e146a3()
{
	self endon(#"death");
	self endon(#"hash_c76d622a");
	wait(1.75);
	self notify(#"bhtn_action_notify", "concussiveReact");
}

/*
	Name: create_concussion_wave
	Namespace: cybercom_gadget_concussive_wave
	Checksum: 0x5821E62D
	Offset: 0x16E8
	Size: 0x39C
	Parameters: 3
	Flags: Linked
*/
function create_concussion_wave(damage, slot, weapon)
{
	if(!isplayer(self))
	{
		level thread create_damage_wave(damage, self);
		return;
	}
	self endon(#"disconnect");
	self.cybercom.var_dd2f3b84 = 1;
	self clientfield::set_to_player("cybercom_disabled", 1);
	self.var_bdd60914 = self allowsprint(0);
	if(isdefined(self.cybercom) && isdefined(self.cybercom.spikeweapon))
	{
		spikeweapon = self.cybercom.spikeweapon;
	}
	else
	{
		spikeweapon = getweapon("hero_gravityspikes_cybercom");
	}
	/#
		assert(isdefined(spikeweapon));
	#/
	self.cybercom.var_ebeecfd5 = 1;
	self giveweapon(spikeweapon);
	self setweaponammoclip(spikeweapon, 2);
	if(self hascybercomability("cybercom_concussive") == 2)
	{
		failsafe = gettime() + 800;
		while(self is_jumping() == 0 && self hasweapon(spikeweapon) && gettime() < failsafe)
		{
			wait(0.05);
		}
		while(self is_jumping() == 1 && self hasweapon(spikeweapon) && gettime() < failsafe)
		{
			wait(0.05);
		}
	}
	else
	{
		wait(0.6);
	}
	self playrumbleonentity("grenade_rumble");
	earthquake(0.6, 0.5, self.origin, 256);
	if(isdefined(spikeweapon) && self hasweapon(spikeweapon))
	{
		self takeweapon(spikeweapon);
	}
	self.cybercom.var_ebeecfd5 = undefined;
	level thread create_damage_wave(damage, self);
	wait(getdvarint("scr_concussive_wave_no_sprint", 1));
	self allowsprint(self.var_bdd60914);
	self.var_bdd60914 = undefined;
	self.cybercom.var_dd2f3b84 = undefined;
	self clientfield::set_to_player("cybercom_disabled", 0);
	wait(0.1);
}

