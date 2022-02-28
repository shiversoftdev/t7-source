// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_mannequin;
#using scripts\shared\ai_shared;
#using scripts\shared\music_shared;
#using scripts\shared\util_shared;

#namespace nuketownmannequin;

/*
	Name: spawnmannequin
	Namespace: nuketownmannequin
	Checksum: 0xF253A467
	Offset: 0x188
	Size: 0x470
	Parameters: 5
	Flags: Linked
*/
function spawnmannequin(origin, angles, gender = "male", speed = undefined, weepingangel)
{
	if(!isdefined(level.mannequinspawn_music))
	{
		level.mannequinspawn_music = 1;
		music::setmusicstate("mann");
	}
	if(gender == "male")
	{
		mannequin = spawnactor("spawner_bo3_mannequin_male", origin, angles, "", 1, 1);
	}
	else
	{
		mannequin = spawnactor("spawner_bo3_mannequin_female", origin, angles, "", 1, 1);
	}
	rand = randomint(100);
	if(rand <= 35)
	{
		mannequin.zombie_move_speed = "walk";
	}
	else
	{
		if(rand <= 70)
		{
			mannequin.zombie_move_speed = "run";
		}
		else
		{
			mannequin.zombie_move_speed = "sprint";
		}
	}
	if(isdefined(speed))
	{
		mannequin.zombie_move_speed = speed;
	}
	if(isdefined(level.zm_variant_type_max))
	{
		mannequin.variant_type = randomintrange(1, level.zm_variant_type_max[mannequin.zombie_move_speed][mannequin.zombie_arms_position]);
	}
	mannequin ai::set_behavior_attribute("can_juke", 1);
	mannequin asmsetanimationrate(randomfloatrange(0.98, 1.02));
	mannequin.holdfire = 1;
	mannequin.canstumble = 1;
	mannequin.should_turn = 1;
	mannequin thread watch_game_ended();
	mannequin.team = "free";
	mannequin.overrideactordamage = &mannequindamage;
	mannequins = getaiarchetypearray("mannequin");
	foreach(othermannequin in mannequins)
	{
		if(othermannequin.archetype == "mannequin")
		{
			othermannequin setignoreent(mannequin, 1);
			mannequin setignoreent(othermannequin, 1);
		}
	}
	if(weepingangel)
	{
		mannequin thread _mannequin_unfreeze_ragdoll();
		mannequin.is_looking_at_me = 1;
		mannequin.was_looking_at_me = 0;
		mannequin _mannequin_update_freeze(mannequin.is_looking_at_me);
	}
	playfx("dlc0/nuketown/fx_de_rez_man_spawn", mannequin.origin, anglestoforward(mannequin.angles));
	return mannequin;
}

/*
	Name: mannequindamage
	Namespace: nuketownmannequin
	Checksum: 0x17F917DA
	Offset: 0x600
	Size: 0xA8
	Parameters: 12
	Flags: Linked
*/
function mannequindamage(inflictor, attacker, damage, dflags, mod, weapon, point, dir, hitloc, offsettime, boneindex, modelindex)
{
	if(isdefined(inflictor) && isactor(inflictor) && inflictor.archetype == "mannequin")
	{
		return 0;
	}
	return damage;
}

/*
	Name: watch_game_ended
	Namespace: nuketownmannequin
	Checksum: 0x980BD82B
	Offset: 0x6B0
	Size: 0x54
	Parameters: 0
	Flags: Linked, Private
*/
function private watch_game_ended()
{
	self endon(#"death");
	level waittill(#"game_ended");
	self setentitypaused(1);
	level waittill(#"endgame_sequence");
	self hide();
}

/*
	Name: _mannequin_unfreeze_ragdoll
	Namespace: nuketownmannequin
	Checksum: 0x7022E4B
	Offset: 0x710
	Size: 0x5C
	Parameters: 0
	Flags: Linked, Private
*/
function private _mannequin_unfreeze_ragdoll()
{
	self waittill(#"death");
	if(isdefined(self))
	{
		self setentitypaused(0);
		if(!self isragdoll())
		{
			self startragdoll();
		}
	}
}

/*
	Name: _mannequin_update_freeze
	Namespace: nuketownmannequin
	Checksum: 0x32CA7607
	Offset: 0x778
	Size: 0x8C
	Parameters: 1
	Flags: Linked, Private
*/
function private _mannequin_update_freeze(frozen)
{
	self.is_looking_at_me = frozen;
	if(self.is_looking_at_me && !self.was_looking_at_me)
	{
		self setentitypaused(1);
	}
	else if(!self.is_looking_at_me && self.was_looking_at_me)
	{
		self setentitypaused(0);
	}
	self.was_looking_at_me = self.is_looking_at_me;
}

/*
	Name: watch_player_looking
	Namespace: nuketownmannequin
	Checksum: 0xBD474627
	Offset: 0x810
	Size: 0x2A0
	Parameters: 0
	Flags: Linked
*/
function watch_player_looking()
{
	level endon(#"game_ended");
	level endon(#"mannequin_force_cleanup");
	while(true)
	{
		mannequins = getaiarchetypearray("mannequin");
		foreach(mannequin in mannequins)
		{
			mannequin.can_player_see_me = 1;
		}
		players = getplayers();
		unseenmannequins = mannequins;
		foreach(player in players)
		{
			unseenmannequins = player cantseeentities(unseenmannequins, 0.67, 0);
		}
		foreach(mannequin in unseenmannequins)
		{
			mannequin.can_player_see_me = 0;
		}
		foreach(mannequin in mannequins)
		{
			mannequin _mannequin_update_freeze(mannequin.can_player_see_me);
		}
		wait(0.05);
	}
}

