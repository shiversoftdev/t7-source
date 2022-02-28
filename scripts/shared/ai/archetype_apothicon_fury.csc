// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace apothiconfurybehavior;

/*
	Name: main
	Namespace: apothiconfurybehavior
	Checksum: 0x9FC5252D
	Offset: 0x3F0
	Size: 0x262
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	ai::add_archetype_spawn_function("apothicon_fury", &apothiconspawnsetup);
	if(ai::shouldregisterclientfieldforarchetype("apothicon_fury"))
	{
		clientfield::register("actor", "fury_fire_damage", 15000, getminbitcountfornum(7), "counter", &apothiconfiredamageeffect, 0, 0);
		clientfield::register("actor", "furious_level", 15000, 1, "int", &apothiconfuriousmodeeffect, 0, 0);
		clientfield::register("actor", "bamf_land", 15000, 1, "counter", &apothiconbamflandeffect, 0, 0);
		clientfield::register("actor", "apothicon_fury_death", 15000, 2, "int", &apothiconfurydeath, 0, 0);
		clientfield::register("actor", "juke_active", 15000, 1, "int", &apothiconjukeactive, 0, 0);
	}
	level._effect["dlc4/genesis/fx_apothicon_fury_impact"] = "dlc4/genesis/fx_apothicon_fury_impact";
	level._effect["dlc4/genesis/fx_apothicon_fury_breath"] = "dlc4/genesis/fx_apothicon_fury_breath";
	level._effect["dlc4/genesis/fx_apothicon_fury_teleport_impact"] = "dlc4/genesis/fx_apothicon_fury_teleport_impact";
	level._effect["dlc4/genesis/fx_apothicon_fury_smk_body"] = "dlc4/genesis/fx_apothicon_fury_smk_body";
	level._effect["dlc4/genesis/fx_apothicon_fury_foot_amb"] = "dlc4/genesis/fx_apothicon_fury_foot_amb";
	level._effect["dlc4/genesis/fx_apothicon_fury_death"] = "dlc4/genesis/fx_apothicon_fury_death";
}

/*
	Name: apothiconspawnsetup
	Namespace: apothiconfurybehavior
	Checksum: 0x2E26B10F
	Offset: 0x660
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function apothiconspawnsetup(localclientnum)
{
	self thread apothiconspawnshader(localclientnum);
	self apothiconstartloopingeffects(localclientnum);
}

/*
	Name: apothiconstartloopingeffects
	Namespace: apothiconfurybehavior
	Checksum: 0xAE17E177
	Offset: 0x6A8
	Size: 0x192
	Parameters: 1
	Flags: Linked
*/
function apothiconstartloopingeffects(localclientnum)
{
	self.loopingeffects = [];
	self.loopingeffects[0] = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_apothicon_fury_breath"], self, "j_head");
	self.loopingeffects[1] = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_apothicon_fury_smk_body"], self, "j_spine4");
	self.loopingeffects[2] = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_apothicon_fury_foot_amb"], self, "j_ball_le");
	self.loopingeffects[3] = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_apothicon_fury_foot_amb"], self, "j_ball_ri");
	self.loopingeffects[4] = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_apothicon_fury_foot_amb"], self, "j_wrist_le");
	self.loopingeffects[5] = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_apothicon_fury_foot_amb"], self, "j_wrist_ri");
}

/*
	Name: apothiconstoploopingeffects
	Namespace: apothiconfurybehavior
	Checksum: 0xEF114DAF
	Offset: 0x848
	Size: 0x9A
	Parameters: 1
	Flags: Linked
*/
function apothiconstoploopingeffects(localclientnum)
{
	foreach(fx in self.loopingeffects)
	{
		killfx(localclientnum, fx);
	}
}

/*
	Name: apothiconspawnshader
	Namespace: apothiconfurybehavior
	Checksum: 0x29456767
	Offset: 0x8F0
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function apothiconspawnshader(localclientnum)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	s_timer = new_timer(localclientnum);
	n_phase_in = 1;
	do
	{
		util::server_wait(localclientnum, 0.11);
		n_current_time = s_timer get_time_in_seconds();
		n_delta_val = lerpfloat(0, 0.01, n_current_time / n_phase_in);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", n_delta_val);
	}
	while(n_current_time < n_phase_in);
	s_timer notify(#"timer_done");
}

/*
	Name: apothiconjukeactive
	Namespace: apothiconfurybehavior
	Checksum: 0x431D689
	Offset: 0xA10
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function apothiconjukeactive(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		playsound(0, "zmb_fury_bamf_teleport_in", self.origin);
		self apothiconstartloopingeffects(localclientnum);
	}
	else
	{
		playsound(0, "zmb_fury_bamf_teleport_out", self.origin);
		self apothiconstoploopingeffects(localclientnum);
	}
}

/*
	Name: apothiconfiredamageeffect
	Namespace: apothiconfurybehavior
	Checksum: 0xF91D4DF8
	Offset: 0xB08
	Size: 0x2A8
	Parameters: 7
	Flags: Linked
*/
function apothiconfiredamageeffect(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	tag = undefined;
	if(newval == 6)
	{
		tag = array::random(array("J_Hip_RI", "J_Knee_RI"));
	}
	if(newval == 7)
	{
		tag = array::random(array("J_Hip_LE", "J_Knee_LE"));
	}
	else
	{
		if(newval == 4)
		{
			tag = array::random(array("J_Shoulder_RI", "J_Shoulder_RI_tr", "J_Elbow_RI"));
		}
		else
		{
			if(newval == 5)
			{
				tag = array::random(array("J_Shoulder_LE", "J_Shoulder_LE_tr", "J_Elbow_LE"));
			}
			else
			{
				if(newval == 3)
				{
					tag = array::random(array("J_MainRoot"));
				}
				else
				{
					if(newval == 2)
					{
						tag = array::random(array("J_SpineUpper", "J_Clavicle_RI", "J_Clavicle_LE"));
					}
					else
					{
						tag = array::random(array("J_Neck", "J_Head", "J_Helmet"));
					}
				}
			}
		}
	}
	fx = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_apothicon_fury_impact"], self, tag);
}

/*
	Name: apothiconfurydeath
	Namespace: apothiconfurybehavior
	Checksum: 0x613EEF8F
	Offset: 0xDB8
	Size: 0x2EC
	Parameters: 7
	Flags: Linked
*/
function apothiconfurydeath(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval == 1)
	{
		s_timer = new_timer(localclientnum);
		n_phase_in = 1;
		self.removingfireshader = 1;
		do
		{
			util::server_wait(localclientnum, 0.11);
			n_current_time = s_timer get_time_in_seconds();
			n_delta_val = lerpfloat(1, 0.1, n_current_time / n_phase_in);
			self mapshaderconstant(localclientnum, 0, "scriptVector2", n_delta_val);
		}
		while(n_current_time < n_phase_in);
		s_timer notify(#"timer_done");
		self.removingfireshader = 0;
	}
	else if(newval == 2)
	{
		if(!isdefined(self))
		{
			return;
		}
		playfxontag(localclientnum, level._effect["dlc4/genesis/fx_apothicon_fury_death"], self, "j_spine4");
		self apothiconstoploopingeffects(localclientnum);
		n_phase_in = 0.3;
		s_timer = new_timer(localclientnum);
		stoptime = gettime() + (n_phase_in * 1000);
		do
		{
			util::server_wait(localclientnum, 0.11);
			n_current_time = s_timer get_time_in_seconds();
			n_delta_val = lerpfloat(1, 0, n_current_time / n_phase_in);
			self mapshaderconstant(localclientnum, 0, "scriptVector0", n_delta_val);
		}
		while(n_current_time < n_phase_in && gettime() <= stoptime);
		s_timer notify(#"timer_done");
		self mapshaderconstant(localclientnum, 0, "scriptVector0", 0);
	}
}

/*
	Name: apothiconfuriousmodeeffect
	Namespace: apothiconfurybehavior
	Checksum: 0xF6935C58
	Offset: 0x10B0
	Size: 0x150
	Parameters: 7
	Flags: Linked
*/
function apothiconfuriousmodeeffect(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		s_timer = new_timer(localclientnum);
		n_phase_in = 2;
		do
		{
			util::server_wait(localclientnum, 0.11);
			n_current_time = s_timer get_time_in_seconds();
			n_delta_val = lerpfloat(0.1, 1, n_current_time / n_phase_in);
			self mapshaderconstant(localclientnum, 0, "scriptVector2", n_delta_val);
		}
		while(n_current_time < n_phase_in);
		s_timer notify(#"timer_done");
	}
}

/*
	Name: new_timer
	Namespace: apothiconfurybehavior
	Checksum: 0x8B1CAEBD
	Offset: 0x1208
	Size: 0x58
	Parameters: 1
	Flags: Linked
*/
function new_timer(localclientnum)
{
	s_timer = spawnstruct();
	s_timer.n_time_current = 0;
	s_timer thread timer_increment_loop(localclientnum, self);
	return s_timer;
}

/*
	Name: timer_increment_loop
	Namespace: apothiconfurybehavior
	Checksum: 0x36624892
	Offset: 0x1268
	Size: 0x68
	Parameters: 2
	Flags: Linked
*/
function timer_increment_loop(localclientnum, entity)
{
	entity endon(#"entityshutdown");
	self endon(#"timer_done");
	while(isdefined(self))
	{
		util::server_wait(localclientnum, 0.016);
		self.n_time_current = self.n_time_current + 0.016;
	}
}

/*
	Name: get_time
	Namespace: apothiconfurybehavior
	Checksum: 0xD4B6B984
	Offset: 0x12D8
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function get_time()
{
	return self.n_time_current * 1000;
}

/*
	Name: get_time_in_seconds
	Namespace: apothiconfurybehavior
	Checksum: 0x628F4955
	Offset: 0x12F0
	Size: 0xA
	Parameters: 0
	Flags: Linked
*/
function get_time_in_seconds()
{
	return self.n_time_current;
}

/*
	Name: reset_timer
	Namespace: apothiconfurybehavior
	Checksum: 0x3194B06
	Offset: 0x1308
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function reset_timer()
{
	self.n_time_current = 0;
}

/*
	Name: apothiconbamflandeffect
	Namespace: apothiconfurybehavior
	Checksum: 0xEF3B58BE
	Offset: 0x1320
	Size: 0x11C
	Parameters: 7
	Flags: Linked
*/
function apothiconbamflandeffect(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		playfxontag(localclientnum, level._effect["dlc4/genesis/fx_apothicon_fury_teleport_impact"], self, "tag_origin");
	}
	player = getlocalplayer(localclientnum);
	player earthquake(0.5, 1.4, self.origin, 375);
	playrumbleonposition(localclientnum, "apothicon_fury_land", self.origin);
}

