// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_unbearable;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_unbearable
	Checksum: 0x286A1BBB
	Offset: 0x248
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_unbearable", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_unbearable
	Checksum: 0xA2A4BDB2
	Offset: 0x288
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_unbearable", "event", &event, undefined, undefined, undefined);
	clientfield::register("zbarrier", "zm_bgb_unbearable", 1, 1, "counter");
}

/*
	Name: event
	Namespace: zm_bgb_unbearable
	Checksum: 0x9EAB77A
	Offset: 0x318
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function event()
{
	self endon(#"disconnect");
	self endon(#"bgb_update");
	self waittill(#"zm_bgb_unbearable", var_c3763c58);
	self bgb::do_one_shot_use(1);
	var_c3763c58 thread function_7a5dc39b(self);
}

/*
	Name: function_7a5dc39b
	Namespace: zm_bgb_unbearable
	Checksum: 0xCA6CD13
	Offset: 0x388
	Size: 0x1CC
	Parameters: 1
	Flags: Linked
*/
function function_7a5dc39b(player)
{
	self.zbarrier notify(#"randomization_done");
	self.zbarrier function_a612a2b3();
	self.zbarrier clientfield::increment("zm_bgb_unbearable");
	self.no_fly_away = 1;
	self.zbarrier notify(#"box_hacked_respin");
	self.zbarrier playsound("zmb_bgb_powerup_respin");
	self thread zm_unitrigger::unregister_unitrigger(self.unitrigger_stub);
	zm_utility::play_sound_at_pos("open_chest", self.zbarrier.origin);
	zm_utility::play_sound_at_pos("music_chest", self.zbarrier.origin);
	self.zbarrier thread zm_magicbox::treasure_chest_weapon_spawn(self, player);
	self.zbarrier waittill(#"randomization_done");
	self.no_fly_away = undefined;
	if(!level flag::get("moving_chest_now"))
	{
		self.grab_weapon_hint = 1;
		self.grab_weapon = self.zbarrier.weapon;
		self thread zm_unitrigger::register_static_unitrigger(self.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think);
		self thread zm_magicbox::treasure_chest_timeout();
	}
}

/*
	Name: function_a612a2b3
	Namespace: zm_bgb_unbearable
	Checksum: 0xCAF5B481
	Offset: 0x560
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function function_a612a2b3()
{
	v_origin = self.weapon_model.origin;
	self.weapon_model delete();
	self.weapon_model = util::spawn_model(level.chest_joker_model, v_origin, self.angles + vectorscale((0, 1, 0), 180));
	self.weapon_model playsound("zmb_bgb_unbearable_activate");
	wait(0.35);
	self.weapon_model moveto(self.origin, 1, 0.5);
	self.weapon_model waittill(#"movedone");
	self.weapon_model delete();
}

