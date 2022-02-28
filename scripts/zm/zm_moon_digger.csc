// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace zm_moon_digger;

/*
	Name: main
	Namespace: zm_moon_digger
	Checksum: 0x4F4EED3C
	Offset: 0x268
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread init_excavator_consoles();
}

/*
	Name: digger_moving_earthquake_rumble
	Namespace: zm_moon_digger
	Checksum: 0xE01F350F
	Offset: 0x290
	Size: 0x1AA
	Parameters: 7
	Flags: Linked
*/
function digger_moving_earthquake_rumble(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(newval)
	{
		for(i = 0; i < level.localplayers.size; i++)
		{
			level thread do_digger_moving_earthquake_rumble(i, self);
		}
	}
	else
	{
		if(isdefined(self.headlight1))
		{
			for(i = 0; i < level.localplayers.size; i++)
			{
				stopfx(i, self.headlight1);
				stopfx(i, self.headlight2);
				stopfx(i, self.blink1);
				stopfx(i, self.blink2);
				if(isdefined(self.tread_fx))
				{
					stopfx(i, self.tread_fx);
				}
				if(isdefined(self.var_deef11e2))
				{
					stopfx(i, self.var_deef11e2);
				}
			}
		}
		self notify(#"stop_moving_rumble");
	}
}

/*
	Name: function_a0cf54a0
	Namespace: zm_moon_digger
	Checksum: 0x11B4843C
	Offset: 0x448
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function function_a0cf54a0(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		level thread function_1e254f15();
	}
}

/*
	Name: function_1e254f15
	Namespace: zm_moon_digger
	Checksum: 0xB3DABE75
	Offset: 0x4B0
	Size: 0x148
	Parameters: 0
	Flags: Linked
*/
function function_1e254f15()
{
	for(i = 0; i < level.localplayers.size; i++)
	{
		player = getlocalplayers()[i];
		if(!isdefined(player))
		{
			continue;
		}
		piece = struct::get("biodome_breached", "targetname");
		if(distancesquared(player.origin, piece.origin) < 6250000)
		{
			player earthquake(0.5, 3, player.origin, 1500);
			player thread bio_breach_rumble(i);
		}
		scene::play("p7_fxanim_zmhd_moon_biodome_glass_bundle");
		level notify(#"sl9");
		level notify(#"sl10");
	}
}

/*
	Name: bio_breach_rumble
	Namespace: zm_moon_digger
	Checksum: 0xDBFFF6D0
	Offset: 0x600
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function bio_breach_rumble(localclientnum)
{
	self endon(#"disconnect");
	for(i = 0; i < 10; i++)
	{
		self playrumbleonentity(localclientnum, "damage_heavy");
		wait(randomfloatrange(0.1, 0.2));
	}
}

/*
	Name: digger_digging_earthquake_rumble
	Namespace: zm_moon_digger
	Checksum: 0xC8BAE123
	Offset: 0x688
	Size: 0xAE
	Parameters: 7
	Flags: Linked
*/
function digger_digging_earthquake_rumble(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(newval)
	{
		for(i = 0; i < level.localplayers.size; i++)
		{
			level thread do_digger_digging_earthquake_rumble(i, self);
		}
	}
	else
	{
		self notify(#"stop_digging_rumble");
	}
}

/*
	Name: do_digger_moving_earthquake_rumble
	Namespace: zm_moon_digger
	Checksum: 0xA0B22697
	Offset: 0x740
	Size: 0x1D8
	Parameters: 2
	Flags: Linked
*/
function do_digger_moving_earthquake_rumble(localclientnum, quake_ent)
{
	quake_ent util::waittill_dobj(localclientnum);
	quake_ent endon(#"entityshutdown");
	quake_ent endon(#"stop_moving_rumble");
	dist_sqd = 6250000;
	quake_ent.tread_fx = playfxontag(localclientnum, level._effect["digger_treadfx_fwd"], quake_ent, "tag_origin");
	quake_ent.var_deef11e2 = playfxontag(localclientnum, level._effect["exca_body_all"], quake_ent, "tag_origin");
	player = getlocalplayers()[localclientnum];
	if(!isdefined(player))
	{
		return;
	}
	while(true)
	{
		if(!isdefined(player))
		{
			return;
		}
		player earthquake(randomfloatrange(0.15, 0.25), 3, quake_ent.origin, 2500);
		if(distancesquared(quake_ent.origin, player.origin) < dist_sqd)
		{
			player playrumbleonentity(localclientnum, "slide_rumble");
		}
		wait(randomfloatrange(0.05, 0.15));
	}
}

/*
	Name: do_digger_digging_earthquake_rumble
	Namespace: zm_moon_digger
	Checksum: 0x39B1720F
	Offset: 0x920
	Size: 0x198
	Parameters: 2
	Flags: Linked
*/
function do_digger_digging_earthquake_rumble(localclientnum, quake_ent)
{
	quake_ent endon(#"entityshutdown");
	quake_ent endon(#"stop_digging_rumble");
	player = getlocalplayers()[localclientnum];
	if(!isdefined(player))
	{
		return;
	}
	count = 0;
	dist = 2250000;
	while(true)
	{
		if(!isdefined(player))
		{
			return;
		}
		player earthquake(randomfloatrange(0.12, 0.17), 3, quake_ent.origin, 1500);
		if(distancesquared(quake_ent.origin, player.origin) < dist && (abs(quake_ent.origin[2] - player.origin[2])) < 750)
		{
			player playrumbleonentity(localclientnum, "grenade_rumble");
		}
		wait(randomfloatrange(0.1, 0.25));
	}
}

/*
	Name: digger_arm_fx
	Namespace: zm_moon_digger
	Checksum: 0xA4D7B11B
	Offset: 0xAC0
	Size: 0x15E
	Parameters: 7
	Flags: Linked
*/
function digger_arm_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(newval)
	{
		for(i = 0; i < level.localplayers.size; i++)
		{
			level thread do_digger_arm_fx(i, self);
		}
	}
	else
	{
		if(isdefined(self.blink1))
		{
			for(i = 0; i < level.localplayers.size; i++)
			{
				stopfx(i, self.blink1);
				stopfx(i, self.blink2);
			}
		}
		if(isdefined(self.var_5f9ccb3a))
		{
			for(i = 0; i < level.localplayers.size; i++)
			{
				stopfx(i, self.var_5f9ccb3a);
			}
		}
	}
}

/*
	Name: do_digger_arm_fx
	Namespace: zm_moon_digger
	Checksum: 0x405BEC01
	Offset: 0xC28
	Size: 0x90
	Parameters: 2
	Flags: Linked
*/
function do_digger_arm_fx(localclientnum, ent)
{
	ent endon(#"entityshutdown");
	player = getlocalplayers()[localclientnum];
	if(!isdefined(player))
	{
		return;
	}
	ent.var_5f9ccb3a = playfxontag(localclientnum, level._effect["exca_arm_all"], ent, "tag_origin");
}

/*
	Name: function_245b13ce
	Namespace: zm_moon_digger
	Checksum: 0xA1753AB6
	Offset: 0xCC0
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_245b13ce(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		level thread digger_visibility_toggle(localclientnum, "hide");
	}
	else
	{
		level thread digger_visibility_toggle(localclientnum, "show");
	}
}

/*
	Name: digger_visibility_toggle
	Namespace: zm_moon_digger
	Checksum: 0x2F718ED7
	Offset: 0xD58
	Size: 0x33A
	Parameters: 2
	Flags: Linked
*/
function digger_visibility_toggle(localclient, visible)
{
	diggers = getentarray(localclient, "digger_body", "targetname");
	tracks = getentarray(localclient, "tracks", "targetname");
	switch(visible)
	{
		case "hide":
		{
			for(i = 0; i < tracks.size; i++)
			{
				tracks[i] hide();
			}
			for(i = 0; i < diggers.size; i++)
			{
				arm = getent(localclient, diggers[i].target, "targetname");
				blade_center = getent(localclient, arm.target, "targetname");
				blade = getent(localclient, blade_center.target, "targetname");
				diggers[i] hide();
				arm hide();
				blade hide();
			}
			break;
		}
		case "show":
		{
			for(i = 0; i < tracks.size; i++)
			{
				tracks[i] show();
			}
			for(i = 0; i < diggers.size; i++)
			{
				arm = getent(localclient, diggers[i].target, "targetname");
				blade_center = getent(localclient, arm.target, "targetname");
				blade = getent(localclient, blade_center.target, "targetname");
				diggers[i] show();
				arm show();
				blade show();
			}
			break;
		}
	}
}

/*
	Name: init_excavator_consoles
	Namespace: zm_moon_digger
	Checksum: 0x31B1CC67
	Offset: 0x10A0
	Size: 0x176
	Parameters: 0
	Flags: Linked
*/
function init_excavator_consoles()
{
	wait(15);
	for(index = 0; index < level.localplayers.size; index++)
	{
		if(!level clientfield::get("TCA"))
		{
			var_cc373138 = getent(index, "tunnel_console", "targetname");
			function_9b3daafa(index, var_cc373138, 0);
		}
		if(!level clientfield::get("HCA"))
		{
			var_cc373138 = getent(index, "hangar_console", "targetname");
			function_9b3daafa(index, var_cc373138, 0);
		}
		if(!level clientfield::get("BCA"))
		{
			var_cc373138 = getent(index, "biodome_console", "targetname");
			function_9b3daafa(index, var_cc373138, 0);
		}
	}
}

/*
	Name: function_774edb15
	Namespace: zm_moon_digger
	Checksum: 0x77DA2126
	Offset: 0x1220
	Size: 0x10C
	Parameters: 7
	Flags: Linked
*/
function function_774edb15(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	switch(fieldname)
	{
		case "TCA":
		{
			var_ffc320da = "tunnel_console";
			break;
		}
		case "HCA":
		{
			var_ffc320da = "hangar_console";
			break;
		}
		case "BCA":
		{
			var_ffc320da = "biodome_console";
			break;
		}
	}
	var_cc373138 = getent(localclientnum, var_ffc320da, "targetname");
	if(newval)
	{
		function_9b3daafa(localclientnum, var_cc373138, 1);
	}
	else
	{
		function_9b3daafa(localclientnum, var_cc373138, 0);
	}
}

/*
	Name: function_9b3daafa
	Namespace: zm_moon_digger
	Checksum: 0x7278C0DE
	Offset: 0x1338
	Size: 0xE8
	Parameters: 3
	Flags: Linked
*/
function function_9b3daafa(localclientnum, var_cc373138, var_a61a4e58)
{
	if(isdefined(var_cc373138.n_fx_id))
	{
		stopfx(localclientnum, var_cc373138.n_fx_id);
	}
	if(var_a61a4e58)
	{
		var_cc373138.n_fx_id = playfxontag(localclientnum, level._effect["panel_on"], var_cc373138, "tag_origin");
	}
	else
	{
		var_cc373138.n_fx_id = playfxontag(localclientnum, level._effect["panel_off"], var_cc373138, "tag_origin");
	}
}

