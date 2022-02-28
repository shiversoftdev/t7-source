// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_sidequests;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\zm_moon_fx;

#namespace zm_moon_sq;

/*
	Name: init_clientfields
	Namespace: zm_moon_sq
	Checksum: 0xB3AD3C70
	Offset: 0x4B8
	Size: 0x44C
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	level._ctt_targets = [];
	zm_sidequests::register_sidequest_icon("vril", 21000);
	zm_sidequests::register_sidequest_icon("anti115", 21000);
	zm_sidequests::register_sidequest_icon("generator", 21000);
	zm_sidequests::register_sidequest_icon("cgenerator", 21000);
	zm_sidequests::register_sidequest_icon("wire", 21000);
	zm_sidequests::register_sidequest_icon("datalog", 21000);
	clientfield::register("world", "raise_rockets", 21000, 1, "counter", &raise_rockets, 0, 0);
	clientfield::register("world", "rocket_launch", 21000, 1, "counter", &rocket_launch, 0, 0);
	clientfield::register("world", "rocket_explode", 21000, 1, "counter", &rocket_explode, 0, 0);
	clientfield::register("world", "charge_tank_1", 21000, 1, "counter", &charge_tank_1, 0, 0);
	clientfield::register("world", "charge_tank_2", 21000, 1, "counter", &charge_tank_2, 0, 0);
	clientfield::register("world", "charge_tank_cleanup", 21000, 1, "counter", &charge_tank_cleanup, 0, 0);
	clientfield::register("world", "sam_vo_rumble", 21000, 1, "int", &sam_vo_rumble, 0, 0);
	clientfield::register("world", "charge_vril_init", 21000, 1, "int", &charge_vril_init, 0, 0);
	clientfield::register("world", "sq_wire_init", 21000, 1, "int", &sq_wire_init, 0, 0);
	clientfield::register("world", "sam_init", 21000, 1, "int", &sam_init, 0, 0);
	n_bits = getminbitcountfornum(4);
	clientfield::register("world", "vril_generator", 21000, n_bits, "int", &vril_generator, 0, 0);
	clientfield::register("world", "sam_end_rumble", 21000, 1, "int", &sam_end_rumble, 0, 0);
}

/*
	Name: rocket_test
	Namespace: zm_moon_sq
	Checksum: 0x1787F7B3
	Offset: 0x910
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function rocket_test()
{
}

/*
	Name: charge_tank_cleanup
	Namespace: zm_moon_sq
	Checksum: 0x930E7D30
	Offset: 0x920
	Size: 0x48
	Parameters: 7
	Flags: Linked
*/
function charge_tank_cleanup(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level._ctt_targets = [];
}

/*
	Name: dest_debug
	Namespace: zm_moon_sq
	Checksum: 0x3586D40A
	Offset: 0x970
	Size: 0x4E
	Parameters: 1
	Flags: None
*/
function dest_debug(dest)
{
	while(true)
	{
		/#
			print3d(dest, "", vectorscale((1, 0, 0), 255), 30);
		#/
		wait(1);
	}
}

/*
	Name: vision_wobble
	Namespace: zm_moon_sq
	Checksum: 0x8BB418F4
	Offset: 0x9C8
	Size: 0x1EC
	Parameters: 0
	Flags: Linked
*/
function vision_wobble()
{
	setdvar("r_poisonFX_debug_amount", 0);
	setdvar("r_poisonFX_debug_enable", 1);
	setdvar("r_poisonFX_pulse", 2);
	setdvar("r_poisonFX_warpX", -0.3);
	setdvar("r_poisonFX_warpY", 0.15);
	setdvar("r_poisonFX_dvisionA", 0);
	setdvar("r_poisonFX_dvisionX", 0);
	setdvar("r_poisonFX_dvisionY", 0);
	setdvar("r_poisonFX_blurMin", 0);
	setdvar("r_poisonFX_blurMax", 3);
	delta = 0.064;
	amount = 1;
	setdvar("r_poisonFX_debug_amount", amount);
	waitrealtime(3);
	while(amount > 0)
	{
		amount = max(amount - delta, 0);
		setdvar("r_poisonFX_debug_amount", amount);
		wait(0.016);
	}
	setdvar("r_poisonFX_debug_amount", 0);
	setdvar("r_poisonFX_debug_enable", 0);
}

/*
	Name: soul_swap
	Namespace: zm_moon_sq
	Checksum: 0x1FE40261
	Offset: 0xBC0
	Size: 0x25E
	Parameters: 7
	Flags: Linked
*/
function soul_swap(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	if(bnewent)
	{
		return;
	}
	if(!newval)
	{
		return;
	}
	if(getlocalplayers().size == 1)
	{
		level thread vision_wobble();
	}
	for(i = 0; i < getlocalplayers().size; i++)
	{
		e = spawn(i, self.origin + vectorscale((0, 0, 1), 24), "script_model");
		e setmodel("tag_origin");
		if(i == 0)
		{
			e playsound(0, "zmb_squest_soul_leave");
		}
		e thread ctt_trail_runner(i, "soul_swap_trail", level._sam.origin + vectorscale((0, 0, 1), 24));
		e = spawn(i, level._sam.origin + vectorscale((0, 0, 1), 24), "script_model");
		e setmodel("tag_origin");
		if(i == 0)
		{
			e playsound(0, "zmb_squest_soul_leave");
		}
		e thread ctt_trail_runner(i, "soul_swap_trail", self.origin + vectorscale((0, 0, 1), 24));
	}
}

/*
	Name: ctt_trail_runner
	Namespace: zm_moon_sq
	Checksum: 0x558491B7
	Offset: 0xE28
	Size: 0xB4
	Parameters: 3
	Flags: Linked
*/
function ctt_trail_runner(localclientnum, fx_name, dest)
{
	playfxontag(localclientnum, level._effect[fx_name], self, "tag_origin");
	self moveto(dest, 0.5);
	self waittill(#"movedone");
	playsound(0, "zmb_squest_soul_impact", dest);
	self delete();
}

/*
	Name: zombie_release_soul
	Namespace: zm_moon_sq
	Checksum: 0xB518D361
	Offset: 0xEE8
	Size: 0x264
	Parameters: 7
	Flags: Linked
*/
function zombie_release_soul(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	closest = undefined;
	min_dist = 99980001;
	for(i = 0; i < level._ctt_targets.size; i++)
	{
		dist = distancesquared(self.origin, level._ctt_targets[i].origin);
		if(dist < min_dist)
		{
			min_dist = dist;
			closest = level._ctt_targets[i];
		}
	}
	if(isdefined(closest))
	{
		/#
			println((("" + self.origin) + "") + closest.origin);
		#/
		for(i = 0; i < getlocalplayers().size; i++)
		{
			e = spawn(i, self.origin + vectorscale((0, 0, 1), 24), "script_model");
			e setmodel("tag_origin");
			if(i == 0)
			{
				e playsound(0, "zmb_squest_soul_leave");
			}
			e thread ctt_trail_runner(i, "fx_weak_sauce_trail", closest.origin - vectorscale((0, 0, 1), 12));
		}
	}
	else
	{
		/#
			println("");
		#/
	}
}

/*
	Name: build_ctt_targets
	Namespace: zm_moon_sq
	Checksum: 0xCEDDB7AB
	Offset: 0x1158
	Size: 0x1E8
	Parameters: 2
	Flags: Linked
*/
function build_ctt_targets(tank_names, second_names)
{
	ret_array = [];
	tanks = struct::get_array(tank_names, "targetname");
	/#
		println("");
	#/
	for(i = 0; i < tanks.size; i++)
	{
		tank = tanks[i];
		capacitor = struct::get(tank.target, "targetname");
		s_target = struct::get(capacitor.target, "targetname");
		ret_array[ret_array.size] = s_target;
	}
	if(isdefined(second_names))
	{
		tanks = struct::get_array(second_names, "targetname");
		for(i = 0; i < tanks.size; i++)
		{
			tank = tanks[i];
			capacitor = struct::get(tank.target, "targetname");
			s_target = struct::get(capacitor.target, "targetname");
			ret_array[ret_array.size] = s_target;
		}
	}
	return ret_array;
}

/*
	Name: charge_vril_init
	Namespace: zm_moon_sq
	Checksum: 0xE37A84EE
	Offset: 0x1348
	Size: 0x11E
	Parameters: 7
	Flags: Linked
*/
function charge_vril_init(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		targs = struct::get_array("sq_cp_final", "targetname");
		for(i = 0; i < targs.size; i++)
		{
			targ = targs[i];
			var_93d55a25 = util::spawn_model(localclientnum, targ.model, targ.origin, targ.angles);
			var_93d55a25 playsound(localclientnum, "evt_clank");
		}
	}
}

/*
	Name: sq_wire_init
	Namespace: zm_moon_sq
	Checksum: 0x6F84C5F0
	Offset: 0x1470
	Size: 0xDC
	Parameters: 7
	Flags: Linked
*/
function sq_wire_init(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		targ = struct::get("sq_wire_final", "targetname");
		var_93d55a25 = util::spawn_model(localclientnum, targ.model, targ.origin, targ.angles);
		var_93d55a25 playsound(localclientnum, "evt_start_old_computer");
	}
}

/*
	Name: sam_rise_and_bob
	Namespace: zm_moon_sq
	Checksum: 0xC97E5AFC
	Offset: 0x1558
	Size: 0x150
	Parameters: 1
	Flags: Linked
*/
function sam_rise_and_bob(struct)
{
	endpos = struct::get(struct.target, "targetname");
	self moveto(endpos.origin, 3);
	self waittill(#"movedone");
	start_z = self.origin;
	amplitude = 7;
	frequency = 75;
	t = 0;
	level._sam = self;
	while(true)
	{
		normalized_wave_height = sin(frequency * t);
		wave_height_z = amplitude * normalized_wave_height;
		self.origin = start_z + (0, 0, wave_height_z);
		t = t + 0.016;
		wait(0.016);
	}
}

/*
	Name: sam_init
	Namespace: zm_moon_sq
	Checksum: 0xEC7F178A
	Offset: 0x16B0
	Size: 0x124
	Parameters: 7
	Flags: Linked
*/
function sam_init(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		targ = struct::get("sq_sam", "targetname");
		var_93d55a25 = util::spawn_model(localclientnum, targ.model, targ.origin, targ.angles);
		playfx(localclientnum, level._effect["lght_marker_flare"], targ.origin);
		var_93d55a25 thread sam_rise_and_bob(targ);
		var_93d55a25 playloopsound("evt_samantha_reveal_loop", 1);
	}
}

/*
	Name: bob_vg
	Namespace: zm_moon_sq
	Checksum: 0xCE9E6F97
	Offset: 0x17E0
	Size: 0xE0
	Parameters: 0
	Flags: Linked
*/
function bob_vg()
{
	self endon(#"death");
	start_z = self.origin;
	amplitude = 2;
	frequency = 100;
	t = 0;
	while(true)
	{
		normalized_wave_height = sin(frequency * t);
		wave_height_z = amplitude * normalized_wave_height;
		self.origin = start_z + (0, 0, wave_height_z);
		t = t + 0.016;
		wait(0.016);
	}
}

/*
	Name: vril_generator
	Namespace: zm_moon_sq
	Checksum: 0xEE4A25CB
	Offset: 0x18C8
	Size: 0x2F2
	Parameters: 7
	Flags: Linked
*/
function vril_generator(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	targ = struct::get("sq_charge_vg_pos", "targetname");
	if(!isdefined(level.a_ents))
	{
		level.a_ents = [];
	}
	switch(newval)
	{
		case 1:
		{
			var_93d55a25 = util::spawn_model(localclientnum, targ.model, targ.origin, targ.angles);
			var_93d55a25 thread bob_vg();
			level.a_ents[level.a_ents.size] = var_93d55a25;
			break;
		}
		case 2:
		{
			for(i = 0; i < level.a_ents.size; i++)
			{
				playfxontag(localclientnum, level._effect["vrill_glow"], level.a_ents[i], "tag_origin");
			}
			break;
		}
		case 3:
		{
			for(j = 0; j < level.a_ents.size; j++)
			{
				level.a_ents[j] delete();
			}
			level.a_ents = [];
			break;
		}
		case 4:
		{
			var_dbd86497 = struct::get("sq_vg_final", "targetname");
			level.a_ents = [];
			var_93d55a25 = util::spawn_model(localclientnum, var_dbd86497.model, var_dbd86497.origin, var_dbd86497.angles);
			level.a_ents[level.a_ents.size] = var_93d55a25;
			for(i = 0; i < level.a_ents.size; i++)
			{
				playfxontag(localclientnum, level._effect["vrill_glow"], level.a_ents[i], "tag_origin");
			}
			level._override_eye_fx = level._effect["blue_eyes"];
			break;
		}
	}
}

/*
	Name: charge_tank_1
	Namespace: zm_moon_sq
	Checksum: 0xCF01B906
	Offset: 0x1BC8
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function charge_tank_1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level._ctt_targets = build_ctt_targets("sq_first_tank");
}

/*
	Name: charge_tank_2
	Namespace: zm_moon_sq
	Checksum: 0x9499ED76
	Offset: 0x1C30
	Size: 0x64
	Parameters: 7
	Flags: Linked
*/
function charge_tank_2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level._ctt_targets = build_ctt_targets("sq_second_tank", "sq_first_tank");
}

/*
	Name: sam_end_rumble
	Namespace: zm_moon_sq
	Checksum: 0xD58008BB
	Offset: 0x1CA0
	Size: 0x76
	Parameters: 7
	Flags: Linked
*/
function sam_end_rumble(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval == 1)
	{
		level thread do_sr_rumble(localclientnum);
	}
	else
	{
		level notify(#"hash_f9b2abc9");
	}
}

/*
	Name: do_sr_rumble
	Namespace: zm_moon_sq
	Checksum: 0xC650302B
	Offset: 0x1D20
	Size: 0x138
	Parameters: 1
	Flags: Linked
*/
function do_sr_rumble(localclientnum)
{
	level endon(#"hash_f9b2abc9");
	var_845cd5d1 = struct::get("pyramid_walls_retract", "targetname");
	while(true)
	{
		a_players = getlocalplayers();
		for(i = 0; i < a_players.size; i++)
		{
			if(!isdefined(a_players[i]))
			{
				continue;
			}
			if(distancesquared(var_845cd5d1.origin, a_players[i].origin) < 562500)
			{
				a_players[i] playrumbleonentity(localclientnum, "slide_rumble");
			}
		}
		wait(randomfloatrange(0.05, 0.15));
	}
}

/*
	Name: sam_vo_rumble
	Namespace: zm_moon_sq
	Checksum: 0xAA1A7B90
	Offset: 0x1E60
	Size: 0x8E
	Parameters: 7
	Flags: Linked
*/
function sam_vo_rumble(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		array::thread_all(getlocalplayers(), &function_9b1295b1, localclientnum);
	}
	else
	{
		level notify(#"hash_306cf2d4");
	}
}

/*
	Name: function_9b1295b1
	Namespace: zm_moon_sq
	Checksum: 0xD533178D
	Offset: 0x1EF8
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function function_9b1295b1(localclientnum)
{
	self endon(#"disconnect");
	level endon(#"hash_306cf2d4");
	while(true)
	{
		self earthquake(randomfloatrange(0.2, 0.25), 5, self.origin, 100);
		self playrumbleonentity(localclientnum, "slide_rumble");
		wait(randomfloatrange(0.1, 0.15));
	}
}

/*
	Name: raise_rockets
	Namespace: zm_moon_sq
	Checksum: 0xBFDD5E48
	Offset: 0x1FB0
	Size: 0x6A
	Parameters: 7
	Flags: Linked
*/
function raise_rockets(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level thread do_rr_rumble();
	wait(4.5);
	level notify(#"_stop_rr");
}

/*
	Name: do_rr_rumble
	Namespace: zm_moon_sq
	Checksum: 0xFECA1520
	Offset: 0x2028
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function do_rr_rumble()
{
	level endon(#"_stop_rr");
	while(true)
	{
		for(i = 0; i < level.localplayers.size; i++)
		{
			player = getlocalplayers()[i];
			if(!isdefined(player))
			{
				continue;
			}
			player earthquake(randomfloatrange(0.15, 0.2), 5, player.origin, 100);
			player playrumbleonentity(i, "slide_rumble");
		}
		wait(randomfloatrange(0.1, 0.15));
	}
}

/*
	Name: rocket_launch
	Namespace: zm_moon_sq
	Checksum: 0x921B9621
	Offset: 0x2130
	Size: 0x66
	Parameters: 7
	Flags: Linked
*/
function rocket_launch(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level thread do_rl_rumble();
	wait(6);
	level notify(#"_stop_rl");
}

/*
	Name: do_rl_rumble
	Namespace: zm_moon_sq
	Checksum: 0xFB2814C2
	Offset: 0x21A0
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function do_rl_rumble()
{
	level endon(#"_stop_rl");
	while(true)
	{
		for(i = 0; i < level.localplayers.size; i++)
		{
			player = getlocalplayers()[i];
			if(!isdefined(player))
			{
				continue;
			}
			player earthquake(randomfloatrange(0.26, 0.31), 5, player.origin, 100);
			player playrumbleonentity(i, "damage_light");
		}
		wait(randomfloatrange(0.1, 0.15));
	}
}

/*
	Name: rocket_explode
	Namespace: zm_moon_sq
	Checksum: 0x91AFDD3B
	Offset: 0x22A8
	Size: 0x76
	Parameters: 7
	Flags: Linked
*/
function rocket_explode(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	level._dte_done = 1;
	wait(3.5);
	level thread do_de_rumble();
	wait(4);
	level notify(#"_stop_de");
}

/*
	Name: do_de_rumble
	Namespace: zm_moon_sq
	Checksum: 0x793E2651
	Offset: 0x2328
	Size: 0x1C0
	Parameters: 0
	Flags: Linked
*/
function do_de_rumble()
{
	level endon(#"_stop_de");
	for(i = 0; i < level.localplayers.size; i++)
	{
		player = getlocalplayers()[i];
		if(!isdefined(player))
		{
			continue;
		}
		player earthquake(randomfloatrange(0.4, 0.45), 5, player.origin, 100);
		player playrumbleonentity(i, "damage_heavy");
	}
	wait(0.2);
	while(true)
	{
		for(i = 0; i < level.localplayers.size; i++)
		{
			player = getlocalplayers()[i];
			if(!isdefined(player))
			{
				continue;
			}
			player earthquake(randomfloatrange(0.35, 0.4), 5, player.origin, 100);
			player playrumbleonentity(i, "damage_light");
		}
		wait(randomfloatrange(0.1, 0.15));
	}
}

/*
	Name: function_38a2773c
	Namespace: zm_moon_sq
	Checksum: 0x74636DAE
	Offset: 0x24F0
	Size: 0x124
	Parameters: 7
	Flags: Linked
*/
function function_38a2773c(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(localclientnum != 0)
	{
		return;
	}
	var_8c15cb32 = struct::get("sd_bowl", "targetname");
	e_origin = util::spawn_model(localclientnum, "tag_origin", self.origin + vectorscale((0, 0, 1), 24));
	if(localclientnum == 0)
	{
		e_origin playsound(localclientnum, "zmb_squest_soul_leave");
	}
	e_origin thread ctt_trail_runner(localclientnum, "fx_weak_sauce_trail", var_8c15cb32.origin - vectorscale((0, 0, 1), 12));
}

