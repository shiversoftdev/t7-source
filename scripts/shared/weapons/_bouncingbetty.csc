// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

#using_animtree("bouncing_betty");

#namespace bouncingbetty;

/*
	Name: init_shared
	Namespace: bouncingbetty
	Checksum: 0xE3073727
	Offset: 0x2E0
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function init_shared(localclientnum)
{
	level.explode_1st_offset = 55;
	level.explode_2nd_offset = 95;
	level.explode_main_offset = 140;
	level._effect["fx_betty_friendly_light"] = "weapon/fx_betty_light_blue";
	level._effect["fx_betty_enemy_light"] = "weapon/fx_betty_light_orng";
	level._effect["fx_betty_exp"] = "weapon/fx_betty_exp";
	level._effect["fx_betty_exp_death"] = "weapon/fx_betty_exp_death";
	level._effect["fx_betty_launch_dust"] = "weapon/fx_betty_launch_dust";
	clientfield::register("missile", "bouncingbetty_state", 1, 2, "int", &bouncingbetty_state_change, 0, 0);
	clientfield::register("scriptmover", "bouncingbetty_state", 1, 2, "int", &bouncingbetty_state_change, 0, 0);
}

/*
	Name: bouncingbetty_state_change
	Namespace: bouncingbetty
	Checksum: 0x4670DA60
	Offset: 0x430
	Size: 0xC6
	Parameters: 7
	Flags: Linked
*/
function bouncingbetty_state_change(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newval)
	{
		case 1:
		{
			self thread bouncingbetty_detonating(localclientnum);
			break;
		}
		case 2:
		{
			self thread bouncingbetty_deploying(localclientnum);
			break;
		}
	}
}

/*
	Name: bouncingbetty_deploying
	Namespace: bouncingbetty
	Checksum: 0x98D16B11
	Offset: 0x500
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function bouncingbetty_deploying(localclientnum)
{
	self endon(#"entityshutdown");
	self useanimtree($bouncing_betty);
	self setanim(%bouncing_betty::o_spider_mine_deploy, 1, 0, 1);
}

/*
	Name: bouncingbetty_detonating
	Namespace: bouncingbetty
	Checksum: 0x72050A31
	Offset: 0x578
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function bouncingbetty_detonating(localclientnum)
{
	self endon(#"entityshutdown");
	up = anglestoup(self.angles);
	forward = anglestoforward(self.angles);
	playfx(localclientnum, level._effect["fx_betty_launch_dust"], self.origin, up, forward);
	self playsound(localclientnum, "wpn_betty_jump");
	self useanimtree($bouncing_betty);
	self setanim(%bouncing_betty::o_spider_mine_detonate, 1, 0, 1);
	self thread watchforexplosionnotetracks(localclientnum, up, forward);
}

/*
	Name: watchforexplosionnotetracks
	Namespace: bouncingbetty
	Checksum: 0x9A05C0DD
	Offset: 0x6B8
	Size: 0x1CE
	Parameters: 3
	Flags: Linked
*/
function watchforexplosionnotetracks(localclientnum, up, forward)
{
	self endon(#"entityshutdown");
	while(true)
	{
		notetrack = self util::waittill_any_return("explode_1st", "explode_2nd", "explode_main", "entityshutdown");
		switch(notetrack)
		{
			case "explode_1st":
			{
				playfx(localclientnum, level._effect["fx_betty_exp"], self.origin + (up * level.explode_1st_offset), up, forward);
				break;
			}
			case "explode_2nd":
			{
				playfx(localclientnum, level._effect["fx_betty_exp"], self.origin + (up * level.explode_2nd_offset), up, forward);
				break;
			}
			case "explode_main":
			{
				playfx(localclientnum, level._effect["fx_betty_exp"], self.origin + (up * level.explode_main_offset), up, forward);
				playfx(localclientnum, level._effect["fx_betty_exp_death"], self.origin, up, forward);
				break;
			}
			default:
			{
				break;
			}
		}
	}
}

