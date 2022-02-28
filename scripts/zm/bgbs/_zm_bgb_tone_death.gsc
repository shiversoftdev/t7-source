// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_tone_death;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_tone_death
	Checksum: 0x4E9009C1
	Offset: 0x200
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_tone_death", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_tone_death
	Checksum: 0x7413B4CE
	Offset: 0x240
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_tone_death", "event", &event, undefined, undefined, undefined);
	bgb::register_actor_death_override("zm_bgb_tone_death", &actor_death_override);
}

/*
	Name: event
	Namespace: zm_bgb_tone_death
	Checksum: 0xDF37C053
	Offset: 0x2C8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function event()
{
	self endon(#"disconnect");
	self thread function_1473087b();
	self util::waittill_any("disconnect", "bled_out", "bgb_gumball_anim_give", "bgb_tone_death_maxed");
}

/*
	Name: function_1473087b
	Namespace: zm_bgb_tone_death
	Checksum: 0xE8D77D2F
	Offset: 0x330
	Size: 0x46
	Parameters: 0
	Flags: Linked
*/
function function_1473087b()
{
	self util::waittill_any("disconnect", "bled_out", "bgb_gumball_anim_give", "bgb_tone_death_maxed");
	self.n_bgb_tone_death_count = undefined;
}

/*
	Name: actor_death_override
	Namespace: zm_bgb_tone_death
	Checksum: 0x32ECD2B7
	Offset: 0x380
	Size: 0xE8
	Parameters: 1
	Flags: Linked
*/
function actor_death_override(e_attacker)
{
	if(self.archetype !== "zombie" || !isplayer(e_attacker))
	{
		return;
	}
	if(e_attacker bgb::is_enabled("zm_bgb_tone_death"))
	{
		self.bgb_tone_death = 1;
		if(!isdefined(e_attacker.n_bgb_tone_death_count))
		{
			e_attacker.n_bgb_tone_death_count = 25;
		}
		e_attacker.n_bgb_tone_death_count--;
		e_attacker bgb::set_timer(e_attacker.n_bgb_tone_death_count, 25);
		if(e_attacker.n_bgb_tone_death_count <= 0)
		{
			e_attacker notify(#"bgb_tone_death_maxed");
		}
	}
}

