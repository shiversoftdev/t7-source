// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("mp_riotshield");

#namespace riotshield;

/*
	Name: init_shared
	Namespace: riotshield
	Checksum: 0x19D90BED
	Offset: 0x260
	Size: 0x82
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	clientfield::register("scriptmover", "riotshield_state", 1, 2, "int", &shield_state_change, 0, 0);
	level._effect["riotshield_light"] = "_t6/weapon/riotshield/fx_riotshield_depoly_lights";
	level._effect["riotshield_dust"] = "_t6/weapon/riotshield/fx_riotshield_depoly_dust";
}

/*
	Name: shield_state_change
	Namespace: riotshield
	Checksum: 0x4150614B
	Offset: 0x2F0
	Size: 0xBE
	Parameters: 7
	Flags: None
*/
function shield_state_change(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	switch(newval)
	{
		case 1:
		{
			instant = oldval == 2;
			self thread riotshield_deploy_anim(localclientnum, instant);
			break;
		}
		case 2:
		{
			self thread riotshield_destroy_anim(localclientnum);
			break;
		}
	}
}

/*
	Name: riotshield_deploy_anim
	Namespace: riotshield
	Checksum: 0x8D16BAC6
	Offset: 0x3B8
	Size: 0x154
	Parameters: 2
	Flags: None
*/
function riotshield_deploy_anim(localclientnum, instant)
{
	self endon(#"entityshutdown");
	self thread watch_riotshield_damage();
	self util::waittill_dobj(localclientnum);
	self useanimtree($mp_riotshield);
	if(instant)
	{
		self setanimtime(%mp_riotshield::o_riot_stand_deploy, 1);
	}
	else
	{
		self setanim(%mp_riotshield::o_riot_stand_deploy, 1, 0, 1);
		playfxontag(localclientnum, level._effect["riotshield_dust"], self, "tag_origin");
	}
	if(!instant)
	{
		wait(0.8);
	}
	self.shieldlightfx = playfxontag(localclientnum, level._effect["riotshield_light"], self, "tag_fx");
}

/*
	Name: watch_riotshield_damage
	Namespace: riotshield
	Checksum: 0x1D0E80E
	Offset: 0x518
	Size: 0x108
	Parameters: 0
	Flags: None
*/
function watch_riotshield_damage()
{
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"damage", damage_loc, damage_type);
		self useanimtree($mp_riotshield);
		if(damage_type == "MOD_MELEE" || damage_type == "MOD_MELEE_WEAPON_BUTT" || damage_type == "MOD_MELEE_ASSASSINATE")
		{
			self setanim(%mp_riotshield::o_riot_stand_melee_front, 1, 0, 1);
		}
		else
		{
			self setanim(%mp_riotshield::o_riot_stand_shot, 1, 0, 1);
		}
	}
}

/*
	Name: riotshield_destroy_anim
	Namespace: riotshield
	Checksum: 0x63BD9418
	Offset: 0x628
	Size: 0xE4
	Parameters: 1
	Flags: None
*/
function riotshield_destroy_anim(localclientnum)
{
	self endon(#"entityshutdown");
	if(isdefined(self.shieldlightfx))
	{
		stopfx(localclientnum, self.shieldlightfx);
	}
	wait(0.05);
	self playsound(localclientnum, "wpn_shield_destroy");
	self useanimtree($mp_riotshield);
	self setanim(%mp_riotshield::o_riot_stand_destroyed, 1, 0, 1);
	wait(1);
	self setforcenotsimple();
}

