// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_bgb_near_death_experience;

/*
	Name: __init__sytem__
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xD4499142
	Offset: 0x358
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_bgb_near_death_experience", &__init__, undefined, "bgb");
}

/*
	Name: __init__
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xF79B960
	Offset: 0x398
	Size: 0xF4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	clientfield::register("allplayers", "zm_bgb_near_death_experience_3p_fx", 15000, 1, "int");
	clientfield::register("toplayer", "zm_bgb_near_death_experience_1p_fx", 15000, 1, "int");
	bgb::register("zm_bgb_near_death_experience", "rounds", 3, &enable, &disable, undefined, undefined);
	bgb::register_lost_perk_override("zm_bgb_near_death_experience", &lost_perk_override, 1);
}

/*
	Name: enable
	Namespace: zm_bgb_near_death_experience
	Checksum: 0x16C20E6A
	Offset: 0x498
	Size: 0xAC
	Parameters: 0
	Flags: Linked
*/
function enable()
{
	self endon(#"disconnect");
	self endon(#"bled_out");
	self endon(#"bgb_update");
	if(!isdefined(level.var_81ca70ba))
	{
		level.var_81ca70ba = 0;
	}
	self thread bgb::function_4ed517b9(240, &function_ff41ae2d, &function_3c1690be);
	self thread function_1a31df5b();
	self thread function_d1a43fc9();
}

/*
	Name: disable
	Namespace: zm_bgb_near_death_experience
	Checksum: 0x99EC1590
	Offset: 0x550
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function disable()
{
}

/*
	Name: function_1a31df5b
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xFB568D8A
	Offset: 0x560
	Size: 0x82
	Parameters: 0
	Flags: Linked
*/
function function_1a31df5b()
{
	self endon(#"disconnect");
	self clientfield::set("zm_bgb_near_death_experience_3p_fx", 1);
	self util::waittill_either("bled_out", "bgb_update");
	self clientfield::set("zm_bgb_near_death_experience_3p_fx", 0);
	self notify(#"zm_bgb_near_death_experience_complete");
}

/*
	Name: function_d1a43fc9
	Namespace: zm_bgb_near_death_experience
	Checksum: 0x6E4D6282
	Offset: 0x5F0
	Size: 0x1DA
	Parameters: 0
	Flags: Linked
*/
function function_d1a43fc9()
{
	foreach(e_player in level.players)
	{
		e_player function_8b5fe69();
	}
	if(level.var_81ca70ba == 0)
	{
		callback::on_connect(&on_connect);
	}
	level.var_81ca70ba++;
	self util::waittill_any("disconnect", "bled_out", "bgb_update");
	level.var_81ca70ba--;
	if(level.var_81ca70ba == 0)
	{
		callback::remove_on_connect(&on_connect);
	}
	foreach(e_player in level.players)
	{
		e_player zm_laststand::deregister_revive_override(e_player.var_e82a0595[0]);
		arrayremoveindex(e_player.var_e82a0595, 0);
	}
}

/*
	Name: on_connect
	Namespace: zm_bgb_near_death_experience
	Checksum: 0x5C4F2489
	Offset: 0x7D8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_connect()
{
	self function_8b5fe69();
}

/*
	Name: function_8b5fe69
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xA3FAC9AC
	Offset: 0x800
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_8b5fe69()
{
	if(!isdefined(self.var_e82a0595))
	{
		self.var_e82a0595 = [];
	}
	s_revive_override = self zm_laststand::register_revive_override(&function_73277c01);
	if(!isdefined(self.var_e82a0595))
	{
		self.var_e82a0595 = [];
	}
	else if(!isarray(self.var_e82a0595))
	{
		self.var_e82a0595 = array(self.var_e82a0595);
	}
	self.var_e82a0595[self.var_e82a0595.size] = s_revive_override;
}

/*
	Name: function_73277c01
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xE615EB8A
	Offset: 0x8C0
	Size: 0x216
	Parameters: 1
	Flags: Linked
*/
function function_73277c01(e_revivee)
{
	if(!isdefined(e_revivee.revivetrigger))
	{
		return false;
	}
	if(!isalive(self))
	{
		return false;
	}
	if(self laststand::player_is_in_laststand())
	{
		return false;
	}
	if(self.team != e_revivee.team)
	{
		return false;
	}
	if(isdefined(self.is_zombie) && self.is_zombie)
	{
		return false;
	}
	if(isdefined(level.can_revive_use_depthinwater_test) && level.can_revive_use_depthinwater_test && e_revivee depthinwater() > 10)
	{
		return true;
	}
	if(isdefined(level.can_revive) && ![[level.can_revive]](e_revivee))
	{
		return false;
	}
	if(isdefined(level.can_revive_game_module) && ![[level.can_revive_game_module]](e_revivee))
	{
		return false;
	}
	if(e_revivee zm::in_kill_brush() || !e_revivee zm::in_enabled_playable_area())
	{
		return false;
	}
	if(self bgb::is_enabled("zm_bgb_near_death_experience") && isdefined(self.var_6638f10b) && array::contains(self.var_6638f10b, e_revivee))
	{
		return true;
	}
	if(e_revivee bgb::is_enabled("zm_bgb_near_death_experience") && isdefined(e_revivee.var_6638f10b) && array::contains(e_revivee.var_6638f10b, self))
	{
		return true;
	}
	return false;
}

/*
	Name: lost_perk_override
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xE882D5BB
	Offset: 0xAE0
	Size: 0x5E
	Parameters: 3
	Flags: Linked
*/
function lost_perk_override(perk, var_2488e46a = undefined, var_24df4040 = undefined)
{
	self thread bgb::revive_and_return_perk_on_bgb_activation(perk);
	return false;
}

/*
	Name: function_ff41ae2d
	Namespace: zm_bgb_near_death_experience
	Checksum: 0x9769D7B9
	Offset: 0xB48
	Size: 0x112
	Parameters: 1
	Flags: Linked
*/
function function_ff41ae2d(e_player)
{
	var_5b3c4fd2 = "zm_bgb_near_death_experience_proximity_end_" + self getentitynumber();
	e_player endon(var_5b3c4fd2);
	e_player endon(#"disconnect");
	self endon(#"disconnect");
	self endon(#"zm_bgb_near_death_experience_complete");
	while(true)
	{
		if(!e_player laststand::player_is_in_laststand() && !self laststand::player_is_in_laststand())
		{
			util::waittill_any_ents_two(e_player, "player_downed", self, "player_downed");
		}
		self thread function_1863dac5(e_player, var_5b3c4fd2);
		var_c888b99d = "zm_bgb_near_death_experience_1p_fx_stop_" + self getentitynumber();
		e_player waittill(var_c888b99d);
	}
}

/*
	Name: function_1863dac5
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xD2DF0EB3
	Offset: 0xC68
	Size: 0x10A
	Parameters: 2
	Flags: Linked
*/
function function_1863dac5(e_player, str_notify)
{
	var_ac3e3041 = self function_52d6b4dc(e_player, str_notify);
	if(!(isdefined(var_ac3e3041) && var_ac3e3041))
	{
		return;
	}
	self function_d1d595b5();
	e_player function_d1d595b5();
	self function_c8cee225(e_player, str_notify);
	if(isdefined(self))
	{
		self function_c0b35f9d();
	}
	if(isdefined(e_player))
	{
		e_player function_c0b35f9d();
		e_player notify("zm_bgb_near_death_experience_1p_fx_stop_" + self getentitynumber());
	}
}

/*
	Name: function_52d6b4dc
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xA73D97E9
	Offset: 0xD80
	Size: 0x90
	Parameters: 2
	Flags: Linked
*/
function function_52d6b4dc(e_player, str_notify)
{
	e_player endon(str_notify);
	e_player endon(#"disconnect");
	self endon(#"disconnect");
	self endon(#"zm_bgb_near_death_experience_complete");
	while(!self function_73277c01(e_player) && !e_player function_73277c01(self))
	{
		wait(0.1);
	}
	return true;
}

/*
	Name: function_c8cee225
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xBFD14348
	Offset: 0xE18
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function function_c8cee225(e_player, str_notify)
{
	e_player endon(str_notify);
	e_player endon(#"disconnect");
	self endon(#"disconnect");
	self endon(#"zm_bgb_near_death_experience_complete");
	while(self function_73277c01(e_player) || e_player function_73277c01(self))
	{
		wait(0.1);
	}
}

/*
	Name: function_3c1690be
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xB2D36609
	Offset: 0xEA8
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function function_3c1690be(e_player)
{
	str_notify = "zm_bgb_near_death_experience_proximity_end_" + self getentitynumber();
	e_player notify(str_notify);
}

/*
	Name: function_d1d595b5
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xF2EB5A4D
	Offset: 0xEF0
	Size: 0x60
	Parameters: 0
	Flags: Linked
*/
function function_d1d595b5()
{
	if(!isdefined(self.var_62125e4d) || self.var_62125e4d == 0)
	{
		self.var_62125e4d = 1;
		self clientfield::set_to_player("zm_bgb_near_death_experience_1p_fx", 1);
	}
	else
	{
		self.var_62125e4d++;
	}
}

/*
	Name: function_c0b35f9d
	Namespace: zm_bgb_near_death_experience
	Checksum: 0xF53890C7
	Offset: 0xF58
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function function_c0b35f9d()
{
	self.var_62125e4d--;
	if(self.var_62125e4d == 0)
	{
		self clientfield::set_to_player("zm_bgb_near_death_experience_1p_fx", 0);
	}
}

