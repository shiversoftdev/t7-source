// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace keepercompanionbehavior;

/*
	Name: main
	Namespace: keepercompanionbehavior
	Checksum: 0xD76E2ED8
	Offset: 0x4E0
	Size: 0x3AE
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	ai::add_archetype_spawn_function("keeper_companion", &function_bfd27b96);
	clientfield::register("allplayers", "being_keeper_revived", 15000, 1, "int", &function_802744a7, 0, 0);
	clientfield::register("actor", "keeper_reviving", 15000, 1, "int", &function_a9b854ea, 0, 0);
	clientfield::register("actor", "kc_effects", 15000, 1, "int", &keeper_fx, 0, 0);
	clientfield::register("world", "kc_callbox_lights", 15000, 2, "int", &function_b945954d, 0, 0);
	clientfield::register("actor", "keeper_ai_death_effect", 15000, 1, "int", &function_2935ac4d, 0, 0);
	clientfield::register("vehicle", "keeper_ai_death_effect", 15000, 1, "int", &function_2935ac4d, 0, 0);
	clientfield::register("scriptmover", "keeper_ai_spawn_tell", 15000, 1, "int", &function_fa8bf98f, 0, 0);
	clientfield::register("actor", "keeper_thunderwall", 15000, 1, "counter", &keeper_thunderwall, 0, 0);
	clientfield::register("scriptmover", "keeper_thunderwall_360", 15000, 1, "counter", &keeper_thunderwall_360, 0, 0);
	level._effect["dlc4/genesis/fx_keeperprot_revive_kp"] = "dlc4/genesis/fx_keeperprot_revive_kp";
	level._effect["dlc4/genesis/fx_keeperprot_revive_player"] = "dlc4/genesis/fx_keeperprot_revive_player";
	level._effect["dlc4/genesis/fx_keeperprot_underlit_amb"] = "dlc4/genesis/fx_keeperprot_underlit_amb";
	level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit"] = "dlc4/genesis/fx_keeperprot_cone_attack_hit";
	level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit_trails"] = "dlc4/genesis/fx_keeperprot_cone_attack_hit_trails";
	level._effect["dlc4/genesis/fx_keeperprot_spawn_tell"] = "dlc4/genesis/fx_keeperprot_spawn_tell";
	level._effect["dlc4/genesis/fx_keeperprot_energy_ball"] = "dlc4/genesis/fx_keeperprot_energy_ball";
	level._effect["dlc4/genesis/fx_keeperprot_cone_attack"] = "dlc4/genesis/fx_keeperprot_cone_attack";
	level._effect["dlc4/genesis/fx_keeperprot_360_attack"] = "dlc4/genesis/fx_keeperprot_360_attack";
}

/*
	Name: function_b945954d
	Namespace: keepercompanionbehavior
	Checksum: 0x6C98C685
	Offset: 0x898
	Size: 0x1A6
	Parameters: 7
	Flags: Linked
*/
function function_b945954d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	switch(newval)
	{
		case 1:
		{
			exploder::exploder("lgt_companion_callbox_green");
			exploder::stop_exploder("lgt_companion_callbox_red");
			exploder::stop_exploder("lgt_companion_callbox_yellow");
			break;
		}
		case 2:
		{
			exploder::stop_exploder("lgt_companion_callbox_green");
			exploder::exploder("lgt_companion_callbox_red");
			exploder::stop_exploder("lgt_companion_callbox_yellow");
			break;
		}
		case 3:
		{
			exploder::stop_exploder("lgt_companion_callbox_green");
			exploder::stop_exploder("lgt_companion_callbox_red");
			exploder::exploder("lgt_companion_callbox_yellow");
			break;
		}
		default:
		{
			exploder::stop_exploder("lgt_companion_callbox_green");
			exploder::stop_exploder("lgt_companion_callbox_red");
			exploder::stop_exploder("lgt_companion_callbox_yellow");
			break;
		}
	}
}

/*
	Name: function_bfd27b96
	Namespace: keepercompanionbehavior
	Checksum: 0x1C8E9184
	Offset: 0xA48
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function function_bfd27b96(localclientnum)
{
	self thread function_8aaa4093(localclientnum);
}

/*
	Name: function_8aaa4093
	Namespace: keepercompanionbehavior
	Checksum: 0x57F357C
	Offset: 0xA78
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function function_8aaa4093(localclientnum)
{
	self endon(#"entityshutdown");
	self notify(#"hash_6f5d947d");
	self endon(#"hash_6f5d947d");
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
		n_delta_val = lerpfloat(0, 1, n_current_time / n_phase_in);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", n_delta_val);
	}
	while(n_current_time < n_phase_in);
	s_timer notify(#"timer_done");
}

/*
	Name: function_55296393
	Namespace: keepercompanionbehavior
	Checksum: 0x6CA10925
	Offset: 0xBB0
	Size: 0x130
	Parameters: 1
	Flags: Linked
*/
function function_55296393(localclientnum)
{
	self endon(#"entityshutdown");
	self notify(#"hash_6f5d947d");
	self endon(#"hash_6f5d947d");
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
		n_delta_val = lerpfloat(1, 0, n_current_time / n_phase_in);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", n_delta_val);
	}
	while(n_current_time < n_phase_in);
	s_timer notify(#"timer_done");
}

/*
	Name: keeper_fx
	Namespace: keepercompanionbehavior
	Checksum: 0x9301D8A
	Offset: 0xCE8
	Size: 0x184
	Parameters: 7
	Flags: Linked
*/
function keeper_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval === 1)
	{
		self.var_2afcd501 = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_underlit_amb"], self, "tag_origin");
		self.var_2a264f57 = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_energy_ball"], self, "tag_weapon_right");
		self.sndlooper = self playloopsound("zmb_keeper_looper");
	}
	else
	{
		if(isdefined(self.var_2afcd501))
		{
			deletefx(localclientnum, self.var_2afcd501, 1);
			self.var_2afcd501 = undefined;
		}
		if(isdefined(self.var_2a264f57))
		{
			deletefx(localclientnum, self.var_2a264f57, 1);
			self.var_2a264f57 = undefined;
		}
		self stopallloopsounds(1);
		self thread function_55296393(localclientnum);
	}
}

/*
	Name: function_a9b854ea
	Namespace: keepercompanionbehavior
	Checksum: 0xA2BF5CE5
	Offset: 0xE78
	Size: 0xE4
	Parameters: 7
	Flags: Linked, Private
*/
function private function_a9b854ea(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_a9b854ea) && oldval == 1 && newval == 0)
	{
		stopfx(localclientnum, self.var_a9b854ea);
	}
	if(newval === 1)
	{
		self.var_a9b854ea = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_revive_kp"], self, "tag_weapon_right");
		self playsound(0, "zmb_keeperprot_revive");
	}
}

/*
	Name: function_802744a7
	Namespace: keepercompanionbehavior
	Checksum: 0x2D7E6419
	Offset: 0xF68
	Size: 0xDC
	Parameters: 7
	Flags: Linked, Private
*/
function private function_802744a7(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.var_b4d5098) && oldval == 1 && newval == 0)
	{
		stopfx(localclientnum, self.var_b4d5098);
	}
	if(newval === 1)
	{
		self playsound(0, "zmb_keeperprot_revive_player");
		self.var_b4d5098 = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_revive_player"], self, "j_spineupper");
	}
}

/*
	Name: keeper_thunderwall
	Namespace: keepercompanionbehavior
	Checksum: 0x1F6F1FEC
	Offset: 0x1050
	Size: 0xA8
	Parameters: 7
	Flags: Linked
*/
function keeper_thunderwall(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		fx = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_cone_attack"], self, "tag_weapon_right");
	}
}

/*
	Name: keeper_thunderwall_360
	Namespace: keepercompanionbehavior
	Checksum: 0xD6ACDE6E
	Offset: 0x1100
	Size: 0x98
	Parameters: 7
	Flags: Linked
*/
function keeper_thunderwall_360(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		fx = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_360_attack"], self, "tag_origin");
	}
}

/*
	Name: function_2935ac4d
	Namespace: keepercompanionbehavior
	Checksum: 0x4F612082
	Offset: 0x11A0
	Size: 0x1E8
	Parameters: 7
	Flags: Linked
*/
function function_2935ac4d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self))
	{
		return;
	}
	tag = "J_SpineUpper";
	if(self.type == "vehicle" || self.type == "helicopter" || self.type == "plane")
	{
		tag = "tag_origin";
	}
	if(newval)
	{
		fx = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit"], self, tag);
		if(self.type != "vehicle" && self.type != "helicopter" && self.type != "plane")
		{
			fx = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit_trails"], self, "J_Wrist_LE");
			fx = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit_trails"], self, "J_Wrist_RI");
		}
		else
		{
			fx = playfxontag(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_cone_attack_hit_trails"], self, tag);
		}
	}
}

/*
	Name: function_fa8bf98f
	Namespace: keepercompanionbehavior
	Checksum: 0xC4747BBF
	Offset: 0x1390
	Size: 0xEC
	Parameters: 7
	Flags: Linked
*/
function function_fa8bf98f(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	if(!isdefined(self))
	{
		return;
	}
	if(newval)
	{
		self.var_7b3e5077 = playfx(localclientnum, level._effect["dlc4/genesis/fx_keeperprot_spawn_tell"], self.origin);
		playsound(0, "zmb_keeperprot_spawn_tell", self.origin);
	}
	else if(isdefined(self.var_7b3e5077))
	{
		stopfx(localclientnum, self.var_7b3e5077);
	}
}

/*
	Name: new_timer
	Namespace: keepercompanionbehavior
	Checksum: 0x71DEF7AB
	Offset: 0x1488
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
	Namespace: keepercompanionbehavior
	Checksum: 0xC0822774
	Offset: 0x14E8
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
	Namespace: keepercompanionbehavior
	Checksum: 0x9FFCD470
	Offset: 0x1558
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
	Namespace: keepercompanionbehavior
	Checksum: 0xA2707C0E
	Offset: 0x1570
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
	Namespace: keepercompanionbehavior
	Checksum: 0x76DD02BB
	Offset: 0x1588
	Size: 0x10
	Parameters: 0
	Flags: None
*/
function reset_timer()
{
	self.n_time_current = 0;
}

