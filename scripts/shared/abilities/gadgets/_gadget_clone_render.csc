// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\system_shared;

#namespace _gadget_clone_render;

/*
	Name: __init__sytem__
	Namespace: _gadget_clone_render
	Checksum: 0x59A3DD01
	Offset: 0x218
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_clone_render", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _gadget_clone_render
	Checksum: 0x71194902
	Offset: 0x258
	Size: 0xD4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	duplicate_render::set_dr_filter_framebuffer("clone_ally", 90, "clone_ally_on", "clone_damage", 0, "mc/ability_clone_ally", 0);
	duplicate_render::set_dr_filter_framebuffer("clone_enemy", 90, "clone_enemy_on", "clone_damage", 0, "mc/ability_clone_enemy", 0);
	duplicate_render::set_dr_filter_framebuffer("clone_damage_ally", 90, "clone_ally_on,clone_damage", undefined, 0, "mc/ability_clone_ally_damage", 0);
	duplicate_render::set_dr_filter_framebuffer("clone_damage_enemy", 90, "clone_enemy_on,clone_damage", undefined, 0, "mc/ability_clone_enemy_damage", 0);
}

#namespace gadget_clone_render;

/*
	Name: transition_shader
	Namespace: gadget_clone_render
	Checksum: 0x4609929
	Offset: 0x338
	Size: 0xA4
	Parameters: 1
	Flags: Linked
*/
function transition_shader(localclientnum)
{
	self endon(#"entityshutdown");
	self endon(#"clone_shader_off");
	rampinshader = 0;
	while(rampinshader < 1)
	{
		if(isdefined(self))
		{
			self mapshaderconstant(localclientnum, 0, "scriptVector3", 1, rampinshader, 0, 0.04);
		}
		rampinshader = rampinshader + 0.04;
		wait(0.016);
	}
}

