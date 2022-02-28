// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_slaughter_slide;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_slaughter_slide
	Checksum: 0x7A3A96B
	Offset: 0x170
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_slaughter_slide", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_slaughter_slide
	Checksum: 0xD3822A92
	Offset: 0x1B0
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	bgb::register("zm_bgb_slaughter_slide", "event", &event, undefined, undefined, undefined);
	bgb::register_actor_damage_override("zm_bgb_slaughter_slide", &actor_damage_override);
	bgb::register_vehicle_damage_override("zm_bgb_slaughter_slide", &vehicle_damage_override);
	level.var_77eb3698 = getweapon("frag_grenade_slaughter_slide");
}

/*
	Name: event
	Namespace: zm_bgb_slaughter_slide
	Checksum: 0xECF54B59
	Offset: 0x280
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function event()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_update");
	self.var_abd23dd0 = 6;
	while(self.var_abd23dd0 > 0)
	{
		var_2a23ce90 = self is_sliding(2);
		if(var_2a23ce90)
		{
			self thread function_42722ac4();
			while(self issliding())
			{
				wait(0.2);
			}
		}
		wait(0.05);
	}
}

/*
	Name: is_sliding
	Namespace: zm_bgb_slaughter_slide
	Checksum: 0xBC1FB679
	Offset: 0x340
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function is_sliding(n_count)
{
	var_2a23ce90 = 0;
	for(x = 0; x < n_count; x++)
	{
		var_2a23ce90 = self issliding();
		wait(0.05);
	}
	return var_2a23ce90;
}

/*
	Name: function_42722ac4
	Namespace: zm_bgb_slaughter_slide
	Checksum: 0x85313658
	Offset: 0x3B0
	Size: 0x164
	Parameters: 0
	Flags: Linked
*/
function function_42722ac4()
{
	v_launch_offset = vectorscale((0, 0, 1), 48);
	v_facing = anglestoforward(self.angles);
	v_right = anglestoright(self.angles);
	self magicgrenadetype(level.var_77eb3698, self.origin + v_launch_offset, v_facing * 1000, 0.5);
	util::wait_network_frame();
	self magicgrenadetype(level.var_77eb3698, self.origin + v_launch_offset, (v_facing * -1) * 100, 0.05);
	self bgb::do_one_shot_use();
	self.var_abd23dd0--;
	self bgb::set_timer(self.var_abd23dd0, 6);
}

/*
	Name: actor_damage_override
	Namespace: zm_bgb_slaughter_slide
	Checksum: 0x4BE7629A
	Offset: 0x520
	Size: 0xCE
	Parameters: 12
	Flags: Linked
*/
function actor_damage_override(inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if(weapon === level.var_77eb3698)
	{
		if(isdefined(self.ignore_nuke) && self.ignore_nuke || (isdefined(self.marked_for_death) && self.marked_for_death) || zm_utility::is_magic_bullet_shield_enabled(self))
		{
			return damage;
		}
		return self.health + 666;
	}
	return damage;
}

/*
	Name: vehicle_damage_override
	Namespace: zm_bgb_slaughter_slide
	Checksum: 0x5428EC4D
	Offset: 0x5F8
	Size: 0xE6
	Parameters: 15
	Flags: Linked
*/
function vehicle_damage_override(einflictor, eattacker, idamage, idflags, smeansofdeath, weapon, vpoint, vdir, shitloc, vdamageorigin, psoffsettime, damagefromunderneath, modelindex, partname, vsurfacenormal)
{
	if(weapon === level.var_77eb3698)
	{
		if(isdefined(self.ignore_nuke) && self.ignore_nuke || (isdefined(self.marked_for_death) && self.marked_for_death) || zm_utility::is_magic_bullet_shield_enabled(self))
		{
			return idamage;
		}
		return self.health + 666;
	}
	return idamage;
}

