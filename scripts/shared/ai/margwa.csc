// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace margwa;

/*
	Name: main
	Namespace: margwa
	Checksum: 0xCF7B9303
	Offset: 0x760
	Size: 0x69E
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "margwa_head_left", 1, 2, "int", &margwaclientutils::margwaheadleftcallback, 0, 0);
	clientfield::register("actor", "margwa_head_mid", 1, 2, "int", &margwaclientutils::margwaheadmidcallback, 0, 0);
	clientfield::register("actor", "margwa_head_right", 1, 2, "int", &margwaclientutils::margwaheadrightcallback, 0, 0);
	clientfield::register("actor", "margwa_fx_in", 1, 1, "counter", &margwaclientutils::margwafxincallback, 0, 0);
	clientfield::register("actor", "margwa_fx_out", 1, 1, "counter", &margwaclientutils::margwafxoutcallback, 0, 0);
	clientfield::register("actor", "margwa_fx_spawn", 1, 1, "counter", &margwaclientutils::margwafxspawncallback, 0, 0);
	clientfield::register("actor", "margwa_smash", 1, 1, "counter", &margwaclientutils::margwasmashcallback, 0, 0);
	clientfield::register("actor", "margwa_head_left_hit", 1, 1, "counter", &margwaclientutils::margwalefthitcallback, 0, 0);
	clientfield::register("actor", "margwa_head_mid_hit", 1, 1, "counter", &margwaclientutils::margwamidhitcallback, 0, 0);
	clientfield::register("actor", "margwa_head_right_hit", 1, 1, "counter", &margwaclientutils::margwarighthitcallback, 0, 0);
	clientfield::register("actor", "margwa_head_killed", 1, 2, "int", &margwaclientutils::margwaheadkilledcallback, 0, 0);
	clientfield::register("actor", "margwa_jaw", 1, 6, "int", &margwaclientutils::margwajawcallback, 0, 0);
	clientfield::register("toplayer", "margwa_head_explosion", 1, 1, "counter", &margwaclientutils::margwaheadexplosion, 0, 0);
	clientfield::register("scriptmover", "margwa_fx_travel", 1, 1, "int", &margwaclientutils::margwafxtravelcallback, 0, 0);
	clientfield::register("scriptmover", "margwa_fx_travel_tell", 1, 1, "int", &margwaclientutils::margwafxtraveltellcallback, 0, 0);
	clientfield::register("actor", "supermargwa", 1, 1, "int", undefined, 0, 0);
	ai::add_archetype_spawn_function("margwa", &margwaclientutils::margwaspawn);
	level._jaw = [];
	level._jaw[1] = "idle_1";
	level._jaw[3] = "idle_pain_head_l_explode";
	level._jaw[4] = "idle_pain_head_m_explode";
	level._jaw[5] = "idle_pain_head_r_explode";
	level._jaw[6] = "react_stun";
	level._jaw[8] = "react_idgun";
	level._jaw[9] = "react_idgun_pack";
	level._jaw[7] = "run_charge_f";
	level._jaw[13] = "run_f";
	level._jaw[14] = "smash_attack_1";
	level._jaw[15] = "swipe";
	level._jaw[16] = "swipe_player";
	level._jaw[17] = "teleport_in";
	level._jaw[18] = "teleport_out";
	level._jaw[19] = "trv_jump_across_256";
	level._jaw[20] = "trv_jump_down_128";
	level._jaw[21] = "trv_jump_down_36";
	level._jaw[22] = "trv_jump_down_96";
	level._jaw[23] = "trv_jump_up_128";
	level._jaw[24] = "trv_jump_up_36";
	level._jaw[25] = "trv_jump_up_96";
}

/*
	Name: precache
	Namespace: margwa
	Checksum: 0x5B5921E6
	Offset: 0xE08
	Size: 0xC6
	Parameters: 0
	Flags: AutoExec
*/
function autoexec precache()
{
	level._effect["fx_margwa_teleport_zod_zmb"] = "zombie/fx_margwa_teleport_zod_zmb";
	level._effect["fx_margwa_teleport_travel_zod_zmb"] = "zombie/fx_margwa_teleport_travel_zod_zmb";
	level._effect["fx_margwa_teleport_tell_zod_zmb"] = "zombie/fx_margwa_teleport_tell_zod_zmb";
	level._effect["fx_margwa_teleport_intro_zod_zmb"] = "zombie/fx_margwa_teleport_intro_zod_zmb";
	level._effect["fx_margwa_head_shot_zod_zmb"] = "zombie/fx_margwa_head_shot_zod_zmb";
	level._effect["fx_margwa_roar_zod_zmb"] = "zombie/fx_margwa_roar_zod_zmb";
	level._effect["fx_margwa_roar_purple_zod_zmb"] = "zombie/fx_margwa_roar_purple_zod_zmb";
}

#namespace margwaclientutils;

/*
	Name: margwaspawn
	Namespace: margwaclientutils
	Checksum: 0x879A66C0
	Offset: 0xED8
	Size: 0x340
	Parameters: 1
	Flags: Linked, Private
*/
function private margwaspawn(localclientnum)
{
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	self setanim("ai_margwa_head_l_closed_add", 1, 0.2, 1);
	self setanim("ai_margwa_head_m_closed_add", 1, 0.2, 1);
	self setanim("ai_margwa_head_r_closed_add", 1, 0.2, 1);
	for(i = 1; i <= 7; i++)
	{
		lefttentacle = "ai_margwa_tentacle_l_0" + i;
		righttentacle = "ai_margwa_tentacle_r_0" + i;
		self setanim(lefttentacle, 1, 0.2, 1);
		self setanim(righttentacle, 1, 0.2, 1);
	}
	level._footstepcbfuncs[self.archetype] = &margwaprocessfootstep;
	self.heads = [];
	self.heads[1] = spawnstruct();
	self.heads[1].index = 1;
	self.heads[1].prevheadanim = "ai_margwa_head_l_closed_add";
	self.heads[1].jawbase = "ai_margwa_jaw_l_";
	self.heads[2] = spawnstruct();
	self.heads[2].index = 2;
	self.heads[2].prevheadanim = "ai_margwa_head_m_closed_add";
	self.heads[2].jawbase = "ai_margwa_jaw_m_";
	self.heads[3] = spawnstruct();
	self.heads[3].index = 3;
	self.heads[3].prevheadanim = "ai_margwa_head_r_closed_add";
	self.heads[3].jawbase = "ai_margwa_jaw_r_";
}

/*
	Name: margwaheadleftcallback
	Namespace: margwaclientutils
	Checksum: 0x39899429
	Offset: 0x1220
	Size: 0x40E
	Parameters: 7
	Flags: Linked, Private
*/
function private margwaheadleftcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(isdefined(self.leftglowfx))
	{
		stopfx(localclientnum, self.leftglowfx);
	}
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newvalue)
	{
		case 1:
		{
			self.heads[1].prevheadanim = "ai_margwa_head_l_open_add";
			self setanim("ai_margwa_head_l_open_add", 1, 0.1, 1);
			self clearanim("ai_margwa_head_l_closed_add", 0.1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.leftglowfx = playfxontag(localclientnum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_left");
			}
			else
			{
				self.leftglowfx = playfxontag(localclientnum, roar_effect, self, "tag_head_left");
			}
			break;
		}
		case 2:
		{
			self.heads[1].prevheadanim = "ai_margwa_head_l_closed_add";
			self setanim("ai_margwa_head_l_closed_add", 1, 0.1, 1);
			self clearanim("ai_margwa_head_l_open_add", 0.1);
			self clearanim("ai_margwa_head_l_smash_attack_1", 0.1);
			break;
		}
		case 3:
		{
			self.heads[1].prevheadanim = "ai_margwa_head_l_smash_attack_1";
			self clearanim("ai_margwa_head_l_open_add", 0.1);
			self clearanim("ai_margwa_head_l_closed_add", 0.1);
			self setanimrestart("ai_margwa_head_l_smash_attack_1", 1, 0.1, 1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.leftglowfx = playfxontag(localclientnum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_left");
			}
			else
			{
				self.leftglowfx = playfxontag(localclientnum, roar_effect, self, "tag_head_left");
			}
			self thread margwastopsmashfx(localclientnum);
			break;
		}
	}
}

/*
	Name: margwaheadmidcallback
	Namespace: margwaclientutils
	Checksum: 0xE539DFDD
	Offset: 0x1638
	Size: 0x3A6
	Parameters: 7
	Flags: Linked, Private
*/
function private margwaheadmidcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(isdefined(self.midglowfx))
	{
		stopfx(localclientnum, self.midglowfx);
	}
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newvalue)
	{
		case 1:
		{
			self setanim("ai_margwa_head_m_open_add", 1, 0.1, 1);
			self clearanim("ai_margwa_head_m_closed_add", 0.1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.midglowfx = playfxontag(localclientnum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_mid");
			}
			else
			{
				self.midglowfx = playfxontag(localclientnum, roar_effect, self, "tag_head_mid");
			}
			break;
		}
		case 2:
		{
			self setanim("ai_margwa_head_m_closed_add", 1, 0.1, 1);
			self clearanim("ai_margwa_head_m_open_add", 0.1);
			self clearanim("ai_margwa_head_m_smash_attack_1", 0.1);
			break;
		}
		case 3:
		{
			self clearanim("ai_margwa_head_m_open_add", 0.1);
			self clearanim("ai_margwa_head_m_closed_add", 0.1);
			self setanimrestart("ai_margwa_head_m_smash_attack_1", 1, 0.1, 1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.midglowfx = playfxontag(localclientnum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_mid");
			}
			else
			{
				self.midglowfx = playfxontag(localclientnum, roar_effect, self, "tag_head_mid");
			}
			self thread margwastopsmashfx(localclientnum);
			break;
		}
	}
}

/*
	Name: margwaheadrightcallback
	Namespace: margwaclientutils
	Checksum: 0xC6C44191
	Offset: 0x19E8
	Size: 0x3A6
	Parameters: 7
	Flags: Linked, Private
*/
function private margwaheadrightcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(isdefined(self.rightglowfx))
	{
		stopfx(localclientnum, self.rightglowfx);
	}
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	switch(newvalue)
	{
		case 1:
		{
			self setanim("ai_margwa_head_r_open_add", 1, 0.1, 1);
			self clearanim("ai_margwa_head_r_closed_add", 0.1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.rightglowfx = playfxontag(localclientnum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_right");
			}
			else
			{
				self.rightglowfx = playfxontag(localclientnum, roar_effect, self, "tag_head_right");
			}
			break;
		}
		case 2:
		{
			self setanim("ai_margwa_head_r_closed_add", 1, 0.1, 1);
			self clearanim("ai_margwa_head_r_open_add", 0.1);
			self clearanim("ai_margwa_head_r_smash_attack_1", 0.1);
			break;
		}
		case 3:
		{
			self clearanim("ai_margwa_head_r_open_add", 0.1);
			self clearanim("ai_margwa_head_r_closed_add", 0.1);
			self setanimrestart("ai_margwa_head_r_smash_attack_1", 1, 0.1, 1);
			roar_effect = level._effect["fx_margwa_roar_zod_zmb"];
			if(isdefined(self.margwa_roar_effect))
			{
				roar_effect = self.margwa_roar_effect;
			}
			if(self clientfield::get("supermargwa"))
			{
				self.rightglowfx = playfxontag(localclientnum, level._effect["fx_margwa_roar_purple_zod_zmb"], self, "tag_head_right");
			}
			else
			{
				self.rightglowfx = playfxontag(localclientnum, roar_effect, self, "tag_head_right");
			}
			self thread margwastopsmashfx(localclientnum);
			break;
		}
	}
}

/*
	Name: margwastopsmashfx
	Namespace: margwaclientutils
	Checksum: 0xEDFE9ECD
	Offset: 0x1D98
	Size: 0x9C
	Parameters: 1
	Flags: Linked, Private
*/
function private margwastopsmashfx(localclientnum)
{
	self endon(#"entityshutdown");
	wait(0.6);
	if(isdefined(self.leftglowfx))
	{
		stopfx(localclientnum, self.leftglowfx);
	}
	if(isdefined(self.midglowfx))
	{
		stopfx(localclientnum, self.midglowfx);
	}
	if(isdefined(self.rightglowfx))
	{
		stopfx(localclientnum, self.rightglowfx);
	}
}

/*
	Name: margwafxincallback
	Namespace: margwaclientutils
	Checksum: 0x915558A6
	Offset: 0x1E40
	Size: 0x94
	Parameters: 7
	Flags: Linked, Private
*/
function private margwafxincallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		self.teleportfxin = playfx(localclientnum, level._effect["fx_margwa_teleport_zod_zmb"], self gettagorigin("j_spine_1"));
	}
}

/*
	Name: margwafxoutcallback
	Namespace: margwaclientutils
	Checksum: 0xD40F1B8B
	Offset: 0x1EE0
	Size: 0xA4
	Parameters: 7
	Flags: Linked, Private
*/
function private margwafxoutcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		tagpos = self gettagorigin("j_spine_1");
		self.teleportfxout = playfx(localclientnum, level._effect["fx_margwa_teleport_zod_zmb"], tagpos);
	}
}

/*
	Name: margwafxtravelcallback
	Namespace: margwaclientutils
	Checksum: 0x90B68D05
	Offset: 0x1F90
	Size: 0xBE
	Parameters: 7
	Flags: Linked, Private
*/
function private margwafxtravelcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	switch(newvalue)
	{
		case 0:
		{
			deletefx(localclientnum, self.travelerfx);
			break;
		}
		case 1:
		{
			self.travelerfx = playfxontag(localclientnum, level._effect["fx_margwa_teleport_travel_zod_zmb"], self, "tag_origin");
			break;
		}
	}
}

/*
	Name: margwafxtraveltellcallback
	Namespace: margwaclientutils
	Checksum: 0x819F763B
	Offset: 0x2058
	Size: 0xDE
	Parameters: 7
	Flags: Linked, Private
*/
function private margwafxtraveltellcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	switch(newvalue)
	{
		case 0:
		{
			deletefx(localclientnum, self.travelertellfx);
			self notify(#"stop_margwatraveltell");
			break;
		}
		case 1:
		{
			self.travelertellfx = playfxontag(localclientnum, level._effect["fx_margwa_teleport_tell_zod_zmb"], self, "tag_origin");
			self thread margwatraveltellupdate(localclientnum);
			break;
		}
	}
}

/*
	Name: margwatraveltellupdate
	Namespace: margwaclientutils
	Checksum: 0xAB59EBAC
	Offset: 0x2140
	Size: 0xD8
	Parameters: 1
	Flags: Linked, Private
*/
function private margwatraveltellupdate(localclientnum)
{
	self notify(#"stop_margwatraveltell");
	self endon(#"stop_margwatraveltell");
	self endon(#"entityshutdown");
	player = getlocalplayer(localclientnum);
	while(true)
	{
		if(isdefined(player))
		{
			dist_sq = distancesquared(player.origin, self.origin);
			if(dist_sq < 1000000)
			{
				player playrumbleonentity(localclientnum, "tank_rumble");
			}
		}
		wait(0.05);
	}
}

/*
	Name: margwafxspawncallback
	Namespace: margwaclientutils
	Checksum: 0x477C632A
	Offset: 0x2220
	Size: 0x114
	Parameters: 7
	Flags: Linked, Private
*/
function private margwafxspawncallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		spawnfx = level._effect["fx_margwa_teleport_intro_zod_zmb"];
		if(isdefined(self.margwa_spawn_effect))
		{
			spawnfx = self.margwa_spawn_effect;
		}
		if(isdefined(self.margwa_play_spawn_effect))
		{
			self thread [[self.margwa_play_spawn_effect]](localclientnum);
		}
		else
		{
			self.spawnfx = playfx(localclientnum, spawnfx, self gettagorigin("j_spine_1"));
		}
		playsound(0, "zmb_margwa_spawn", self gettagorigin("j_spine_1"));
	}
}

/*
	Name: margwaheadexplosion
	Namespace: margwaclientutils
	Checksum: 0x54ECFD4E
	Offset: 0x2340
	Size: 0x64
	Parameters: 7
	Flags: Linked, Private
*/
function private margwaheadexplosion(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		self postfx::playpostfxbundle("pstfx_parasite_dmg");
	}
}

/*
	Name: margwaprocessfootstep
	Namespace: margwaclientutils
	Checksum: 0xC39DCBF6
	Offset: 0x23B0
	Size: 0x20C
	Parameters: 5
	Flags: Linked
*/
function margwaprocessfootstep(localclientnum, pos, surface, notetrack, bone)
{
	e_player = getlocalplayer(localclientnum);
	n_dist = distancesquared(pos, e_player.origin);
	n_margwa_dist = getdvarint("scr_margwa_footstep_eq_radius", 1000) * getdvarint("scr_margwa_footstep_eq_radius", 1000);
	if(n_margwa_dist > 0)
	{
		n_scale = (n_margwa_dist - n_dist) / n_margwa_dist;
	}
	else
	{
		return;
	}
	if(n_scale > 1 || n_scale < 0)
	{
		return;
	}
	n_scale = n_scale * 0.25;
	if(n_scale <= 0.01)
	{
		return;
	}
	e_player earthquake(n_scale, 0.1, pos, n_dist);
	if(n_scale <= 0.25 && n_scale > 0.2)
	{
		e_player playrumbleonentity(localclientnum, "shotgun_fire");
	}
	else
	{
		if(n_scale <= 0.2 && n_scale > 0.1)
		{
			e_player playrumbleonentity(localclientnum, "damage_heavy");
		}
		else
		{
			e_player playrumbleonentity(localclientnum, "reload_small");
		}
	}
}

/*
	Name: margwasmashcallback
	Namespace: margwaclientutils
	Checksum: 0x61E8731C
	Offset: 0x25C8
	Size: 0x194
	Parameters: 7
	Flags: Linked, Private
*/
function private margwasmashcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		e_player = getlocalplayer(localclientnum);
		smashpos = self.origin + vectorscale(anglestoforward(self.angles), 60);
		distsq = distancesquared(smashpos, e_player.origin);
		if(distsq < 20736)
		{
			e_player earthquake(0.7, 0.25, e_player.origin, 3000);
			e_player playrumbleonentity(localclientnum, "shotgun_fire");
		}
		else if(distsq < 36864)
		{
			e_player earthquake(0.7, 0.25, e_player.origin, 1500);
			e_player playrumbleonentity(localclientnum, "damage_heavy");
		}
	}
}

/*
	Name: margwalefthitcallback
	Namespace: margwaclientutils
	Checksum: 0xF2B2D95
	Offset: 0x2768
	Size: 0xAC
	Parameters: 7
	Flags: Linked, Private
*/
function private margwalefthitcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		effect = level._effect["fx_margwa_head_shot_zod_zmb"];
		if(isdefined(self.margwa_head_hit_fx))
		{
			effect = self.margwa_head_hit_fx;
		}
		self.lefthitfx = playfxontag(localclientnum, effect, self, "tag_head_left");
	}
}

/*
	Name: margwamidhitcallback
	Namespace: margwaclientutils
	Checksum: 0x42A9F94F
	Offset: 0x2820
	Size: 0xAC
	Parameters: 7
	Flags: Linked, Private
*/
function private margwamidhitcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		effect = level._effect["fx_margwa_head_shot_zod_zmb"];
		if(isdefined(self.margwa_head_hit_fx))
		{
			effect = self.margwa_head_hit_fx;
		}
		self.midhitfx = playfxontag(localclientnum, effect, self, "tag_head_mid");
	}
}

/*
	Name: margwarighthitcallback
	Namespace: margwaclientutils
	Checksum: 0xE19FCFAF
	Offset: 0x28D8
	Size: 0xAC
	Parameters: 7
	Flags: Linked, Private
*/
function private margwarighthitcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		effect = level._effect["fx_margwa_head_shot_zod_zmb"];
		if(isdefined(self.margwa_head_hit_fx))
		{
			effect = self.margwa_head_hit_fx;
		}
		self.righthitfx = playfxontag(localclientnum, effect, self, "tag_head_right");
	}
}

/*
	Name: margwaheadkilledcallback
	Namespace: margwaclientutils
	Checksum: 0x3C4188
	Offset: 0x2990
	Size: 0x60
	Parameters: 7
	Flags: Linked, Private
*/
function private margwaheadkilledcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		self.heads[newvalue].killed = 1;
	}
}

/*
	Name: margwajawcallback
	Namespace: margwaclientutils
	Checksum: 0x94DDD068
	Offset: 0x29F8
	Size: 0x1C2
	Parameters: 7
	Flags: Linked, Private
*/
function private margwajawcallback(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		foreach(head in self.heads)
		{
			if(isdefined(head.killed) && head.killed)
			{
				if(isdefined(head.prevjawanim))
				{
					self clearanim(head.prevjawanim, 0.2);
				}
				if(isdefined(head.prevheadanim))
				{
					self clearanim(head.prevheadanim, 0.1);
				}
				jawanim = head.jawbase + level._jaw[newvalue];
				head.prevjawanim = jawanim;
				self setanim(jawanim, 1, 0.2, 1);
			}
		}
	}
}

