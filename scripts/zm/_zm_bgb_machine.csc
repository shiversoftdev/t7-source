// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm_bgb;

#namespace bgb_machine;

/*
	Name: __init__sytem__
	Namespace: bgb_machine
	Checksum: 0xE3EA3E58
	Offset: 0x980
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("bgb_machine", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: bgb_machine
	Checksum: 0x587388D8
	Offset: 0x9C0
	Size: 0x4BC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.bgb_in_use) && level.bgb_in_use))
	{
		return;
	}
	level.var_962d1590 = 0.016;
	clientfield::register("zbarrier", "zm_bgb_machine", 1, 1, "int", &bgb_machine_init, 0, 0);
	clientfield::register("zbarrier", "zm_bgb_machine_selection", 1, 8, "int", &bgb_machine_selection, 1, 0);
	clientfield::register("zbarrier", "zm_bgb_machine_fx_state", 1, 3, "int", &bgb_machine_fx_state, 0, 0);
	clientfield::register("zbarrier", "zm_bgb_machine_ghost_ball", 1, 1, "int", undefined, 0, 0);
	clientfield::register("toplayer", "zm_bgb_machine_round_buys", 10000, 3, "int", &function_27a93844, 0, 0);
	level._effect["zm_bgb_machine_eye_away"] = "zombie/fx_bgb_machine_eye_away_zmb";
	level._effect["zm_bgb_machine_eye_activated"] = "zombie/fx_bgb_machine_eye_activated_zmb";
	level._effect["zm_bgb_machine_eye_event"] = "zombie/fx_bgb_machine_eye_event_zmb";
	level._effect["zm_bgb_machine_eye_rounds"] = "zombie/fx_bgb_machine_eye_rounds_zmb";
	level._effect["zm_bgb_machine_eye_time"] = "zombie/fx_bgb_machine_eye_time_zmb";
	if(!isdefined(level._effect["zm_bgb_machine_available"]))
	{
		level._effect["zm_bgb_machine_available"] = "zombie/fx_bgb_machine_available_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_away"]))
	{
		level._effect["zm_bgb_machine_bulb_away"] = "zombie/fx_bgb_machine_bulb_away_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_available"]))
	{
		level._effect["zm_bgb_machine_bulb_available"] = "zombie/fx_bgb_machine_bulb_available_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_activated"]))
	{
		level._effect["zm_bgb_machine_bulb_activated"] = "zombie/fx_bgb_machine_bulb_activated_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_event"]))
	{
		level._effect["zm_bgb_machine_bulb_event"] = "zombie/fx_bgb_machine_bulb_event_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_rounds"]))
	{
		level._effect["zm_bgb_machine_bulb_rounds"] = "zombie/fx_bgb_machine_bulb_rounds_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_bulb_time"]))
	{
		level._effect["zm_bgb_machine_bulb_time"] = "zombie/fx_bgb_machine_bulb_time_zmb";
	}
	level._effect["zm_bgb_machine_bulb_spark"] = "zombie/fx_bgb_machine_bulb_spark_zmb";
	level._effect["zm_bgb_machine_flying_elec"] = "zombie/fx_bgb_machine_flying_elec_zmb";
	level._effect["zm_bgb_machine_flying_embers_down"] = "zombie/fx_bgb_machine_flying_embers_down_zmb";
	level._effect["zm_bgb_machine_flying_embers_up"] = "zombie/fx_bgb_machine_flying_embers_up_zmb";
	level._effect["zm_bgb_machine_smoke"] = "zombie/fx_bgb_machine_smoke_zmb";
	level._effect["zm_bgb_machine_gumball_halo"] = "zombie/fx_bgb_machine_gumball_halo_zmb";
	level._effect["zm_bgb_machine_gumball_ghost"] = "zombie/fx_bgb_gumball_ghost_zmb";
	if(!isdefined(level._effect["zm_bgb_machine_light_interior"]))
	{
		level._effect["zm_bgb_machine_light_interior"] = "zombie/fx_bgb_machine_light_interior_zmb";
	}
	if(!isdefined(level._effect["zm_bgb_machine_light_interior_away"]))
	{
		level._effect["zm_bgb_machine_light_interior_away"] = "zombie/fx_bgb_machine_light_interior_away_zmb";
	}
	function_b90b22b6();
}

/*
	Name: bgb_machine_init
	Namespace: bgb_machine
	Checksum: 0xF86E5C92
	Offset: 0xE88
	Size: 0x3CC
	Parameters: 7
	Flags: Linked, Private
*/
function private bgb_machine_init(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(self.bgb_machine_fx))
	{
		return;
	}
	if(!isdefined(level.bgb_machines))
	{
		level.bgb_machines = [];
	}
	array::add(level.bgb_machines, self);
	var_962d1590 = level.var_962d1590;
	level.var_962d1590 = level.var_962d1590 + 0.016;
	wait(var_962d1590);
	if(!isdefined(self))
	{
		return;
	}
	if(!isdefined(level.bgb_machine_streamer_forced))
	{
		piececount = self getnumzbarrierpieces();
		for(i = 0; i < piececount; i++)
		{
			piece = self zbarriergetpiece(i);
			forcestreamxmodel(piece.model);
		}
		level.bgb_machine_streamer_forced = 1;
	}
	self.bgb_machine_fx = [];
	self.bgb_machine_fx["tag_origin"] = [];
	self.bgb_machine_fx["tag_fx_light_lion_lft_eye_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_lion_rt_eye_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_top_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_lft_top_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_lft_mid_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_lft_btm_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_rt_top_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_rt_mid_jnt"] = [];
	self.bgb_machine_fx["tag_fx_light_side_rt_btm_jnt"] = [];
	self.bgb_machine_fx["tag_fx_glass_cntr_jnt"] = [];
	self.bgb_machine_fx["tag_gumball_ghost"] = [];
	self.bgb_machine_fx_bulb_tags = [];
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_top_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_lft_top_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_lft_mid_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_lft_btm_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_rt_top_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_rt_mid_jnt";
	self.bgb_machine_fx_bulb_tags[self.bgb_machine_fx_bulb_tags.size] = "tag_fx_light_side_rt_btm_jnt";
	self thread bgb_machine_flying_ember_think(localclientnum, "closing", level._effect["zm_bgb_machine_flying_embers_down"]);
	self thread bgb_machine_flying_ember_think(localclientnum, "opening", level._effect["zm_bgb_machine_flying_embers_up"]);
	self thread bgb_machine_flying_gumballs_think(localclientnum);
	self thread bgb_machine_give_gumball_think(localclientnum);
	self thread bgb_machine_interior_light_shake_piece_think(localclientnum);
}

/*
	Name: bgb_machine_selection
	Namespace: bgb_machine
	Checksum: 0x221F43A3
	Offset: 0x1260
	Size: 0x62
	Parameters: 7
	Flags: Linked, Private
*/
function private bgb_machine_selection(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	bgb = level.bgb_item_index_to_name[newval];
}

/*
	Name: bgb_machine_play_random_sparks
	Namespace: bgb_machine
	Checksum: 0x5162026D
	Offset: 0x12D0
	Size: 0x100
	Parameters: 3
	Flags: Linked, Private
*/
function private bgb_machine_play_random_sparks(localclientnum, fx, piece)
{
	piece endon(#"opened");
	piece endon(#"closed");
	self.bgb_machine_fx_bulb_tags = array::randomize(self.bgb_machine_fx_bulb_tags);
	for(i = 0; i < self.bgb_machine_fx_bulb_tags.size; i++)
	{
		if(randomintrange(0, 4))
		{
			playfxontag(localclientnum, fx, piece, self.bgb_machine_fx_bulb_tags[i]);
		}
		wait_time = randomfloatrange(0, 0.2);
		if(wait_time)
		{
			wait(wait_time);
		}
	}
}

/*
	Name: bgb_machine_flying_ember_think
	Namespace: bgb_machine
	Checksum: 0x568D4594
	Offset: 0x13D8
	Size: 0x170
	Parameters: 3
	Flags: Linked, Private
*/
function private bgb_machine_flying_ember_think(localclientnum, notifyname, fx)
{
	listen_piece = self zbarriergetpiece(3);
	fx_piece = self zbarriergetpiece(5);
	for(;;)
	{
		listen_piece waittill(notifyname);
		tag_angles = fx_piece gettagangles("tag_fx_glass_cntr_jnt");
		playfx(localclientnum, fx, fx_piece gettagorigin("tag_fx_glass_cntr_jnt"), anglestoforward(tag_angles), anglestoup(tag_angles));
		playfx(localclientnum, level._effect["zm_bgb_machine_smoke"], self.origin);
		self thread bgb_machine_play_random_sparks(localclientnum, level._effect["zm_bgb_machine_bulb_spark"], fx_piece);
		wait(0.01);
	}
}

/*
	Name: bgb_machine_flying_gumballs_think
	Namespace: bgb_machine
	Checksum: 0x4A3F6CB9
	Offset: 0x1550
	Size: 0x314
	Parameters: 1
	Flags: Linked, Private
*/
function private bgb_machine_flying_gumballs_think(localclientnum)
{
	gumballs_piece = self zbarriergetpiece(4);
	fx_piece = self zbarriergetpiece(5);
	for(;;)
	{
		function_5885778a(gumballs_piece);
		if(!isdefined(self))
		{
			return;
		}
		if(!isdefined(gumballs_piece))
		{
			gumballs_piece = self zbarriergetpiece(4);
			fx_piece = self zbarriergetpiece(5);
		}
		bgb_item_index = self clientfield::get("zm_bgb_machine_selection");
		bgb = level.bgb_item_index_to_name[bgb_item_index];
		if(!isdefined(bgb))
		{
			continue;
		}
		self thread function_5f830538(localclientnum);
		playfxontag(localclientnum, level._effect["zm_bgb_machine_flying_elec"], fx_piece, "tag_fx_glass_cntr_jnt");
		gumballs_piece hidepart(localclientnum, "tag_gumballs", "", 1);
		bgb_pack = [];
		for(i = 0; i < level.bgb_pack[localclientnum].size; i++)
		{
			if(bgb == level.bgb_pack[localclientnum][i])
			{
				continue;
			}
			bgb_pack[bgb_pack.size] = level.bgb_pack[localclientnum][i];
		}
		for(i = 0; i < level.bgb_pack[localclientnum].size; i++)
		{
			bgb_pack[bgb_pack.size] = level.bgb_pack[localclientnum][i];
		}
		bgb_pack = array::randomize(bgb_pack);
		array::push_front(bgb_pack, bgb);
		for(i = 0; i < 10; i++)
		{
			gumballs_piece showpart(localclientnum, (level.bgb[bgb_pack[i]].flying_gumball_tag + "_") + i);
		}
		wait(0.01);
	}
}

/*
	Name: function_5885778a
	Namespace: bgb_machine
	Checksum: 0x5C4AF776
	Offset: 0x1870
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_5885778a(piece)
{
	level endon(#"demo_jump");
	piece util::waittill_any("opening", "closing");
}

/*
	Name: bgb_machine_give_gumball_think
	Namespace: bgb_machine
	Checksum: 0x9EB4133D
	Offset: 0x18B8
	Size: 0x180
	Parameters: 1
	Flags: Linked, Private
*/
function private bgb_machine_give_gumball_think(localclientnum)
{
	piece = self zbarriergetpiece(2);
	while(isdefined(self))
	{
		function_36a807de(piece);
		if(!isdefined(self))
		{
			return;
		}
		if(!isdefined(piece))
		{
			piece = self zbarriergetpiece(2);
		}
		bgb_item_index = self clientfield::get("zm_bgb_machine_selection");
		bgb = level.bgb_item_index_to_name[bgb_item_index];
		if(!isdefined(bgb))
		{
			continue;
		}
		piece hidepart(localclientnum, "tag_gumballs", "", 1);
		if(self clientfield::get("zm_bgb_machine_ghost_ball"))
		{
			piece showpart(localclientnum, "tag_gumball_ghost");
		}
		else
		{
			piece showpart(localclientnum, level.bgb[bgb].var_ece14434);
		}
		wait(0.01);
	}
}

/*
	Name: function_36a807de
	Namespace: bgb_machine
	Checksum: 0x9FECF8F6
	Offset: 0x1A40
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function function_36a807de(piece)
{
	level endon(#"demo_jump");
	piece waittill(#"opening");
}

/*
	Name: bgb_machine_interior_light_shake_piece_think
	Namespace: bgb_machine
	Checksum: 0x329CC8E6
	Offset: 0x1A70
	Size: 0x78
	Parameters: 1
	Flags: Linked, Private
*/
function private bgb_machine_interior_light_shake_piece_think(localclientnum)
{
	piece = self zbarriergetpiece(1);
	for(;;)
	{
		piece waittill(#"opening");
		bgb_machine_play_fx(localclientnum, piece, "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior"]);
		wait(0.01);
	}
}

/*
	Name: bgb_machine_get_eye_fx_for_selected_bgb
	Namespace: bgb_machine
	Checksum: 0x830DBC28
	Offset: 0x1AF0
	Size: 0xE4
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_machine_get_eye_fx_for_selected_bgb()
{
	bgb_item_index = self clientfield::get("zm_bgb_machine_selection");
	bgb = level.bgb_item_index_to_name[bgb_item_index];
	switch(level.bgb[bgb].limit_type)
	{
		case "activated":
		{
			return level._effect["zm_bgb_machine_eye_activated"];
		}
		case "event":
		{
			return level._effect["zm_bgb_machine_eye_event"];
		}
		case "rounds":
		{
			return level._effect["zm_bgb_machine_eye_rounds"];
		}
		case "time":
		{
			return level._effect["zm_bgb_machine_eye_time"];
		}
	}
	return undefined;
}

/*
	Name: bgb_machine_get_bulb_fx_for_selected_bgb
	Namespace: bgb_machine
	Checksum: 0x93521BB0
	Offset: 0x1BE0
	Size: 0xE4
	Parameters: 0
	Flags: Linked, Private
*/
function private bgb_machine_get_bulb_fx_for_selected_bgb()
{
	bgb_item_index = self clientfield::get("zm_bgb_machine_selection");
	bgb = level.bgb_item_index_to_name[bgb_item_index];
	switch(level.bgb[bgb].limit_type)
	{
		case "activated":
		{
			return level._effect["zm_bgb_machine_bulb_activated"];
		}
		case "event":
		{
			return level._effect["zm_bgb_machine_bulb_event"];
		}
		case "rounds":
		{
			return level._effect["zm_bgb_machine_bulb_rounds"];
		}
		case "time":
		{
			return level._effect["zm_bgb_machine_bulb_time"];
		}
	}
	return undefined;
}

/*
	Name: bgb_machine_play_fx
	Namespace: bgb_machine
	Checksum: 0xB1E36F70
	Offset: 0x1CD0
	Size: 0xD8
	Parameters: 5
	Flags: Linked, Private
*/
function private bgb_machine_play_fx(localclientnum, piece, tag, fx, deleteimmediate = 1)
{
	if(isdefined(self.bgb_machine_fx[tag][localclientnum]))
	{
		deletefx(localclientnum, self.bgb_machine_fx[tag][localclientnum], deleteimmediate);
		self.bgb_machine_fx[tag][localclientnum] = undefined;
	}
	if(isdefined(fx))
	{
		self.bgb_machine_fx[tag][localclientnum] = playfxontag(localclientnum, fx, piece, tag);
	}
}

/*
	Name: bgb_machine_play_top_fx
	Namespace: bgb_machine
	Checksum: 0x57F88F67
	Offset: 0x1DB0
	Size: 0x44
	Parameters: 3
	Flags: Linked, Private
*/
function private bgb_machine_play_top_fx(localclientnum, piece, fx)
{
	bgb_machine_play_fx(localclientnum, piece, "tag_fx_light_top_jnt", fx);
}

/*
	Name: bgb_machine_play_top_side_fx
	Namespace: bgb_machine
	Checksum: 0xE976FE0C
	Offset: 0x1E00
	Size: 0x6C
	Parameters: 3
	Flags: Linked, Private
*/
function private bgb_machine_play_top_side_fx(localclientnum, piece, fx)
{
	bgb_machine_play_fx(localclientnum, piece, "tag_fx_light_side_lft_top_jnt", fx);
	bgb_machine_play_fx(localclientnum, piece, "tag_fx_light_side_rt_top_jnt", fx);
}

/*
	Name: bgb_machine_play_mid_side_fx
	Namespace: bgb_machine
	Checksum: 0x46228CA6
	Offset: 0x1E78
	Size: 0x6C
	Parameters: 3
	Flags: Linked, Private
*/
function private bgb_machine_play_mid_side_fx(localclientnum, piece, fx)
{
	bgb_machine_play_fx(localclientnum, piece, "tag_fx_light_side_lft_mid_jnt", fx);
	bgb_machine_play_fx(localclientnum, piece, "tag_fx_light_side_rt_mid_jnt", fx);
}

/*
	Name: bgb_machine_play_btm_side_fx
	Namespace: bgb_machine
	Checksum: 0x15AC5003
	Offset: 0x1EF0
	Size: 0x6C
	Parameters: 3
	Flags: Linked, Private
*/
function private bgb_machine_play_btm_side_fx(localclientnum, piece, fx)
{
	bgb_machine_play_fx(localclientnum, piece, "tag_fx_light_side_lft_btm_jnt", fx);
	bgb_machine_play_fx(localclientnum, piece, "tag_fx_light_side_rt_btm_jnt", fx);
}

/*
	Name: bgb_machine_play_all_bulb_fx
	Namespace: bgb_machine
	Checksum: 0x4404DCD8
	Offset: 0x1F68
	Size: 0x9C
	Parameters: 3
	Flags: Linked, Private
*/
function private bgb_machine_play_all_bulb_fx(localclientnum, piece, fx)
{
	bgb_machine_play_top_fx(localclientnum, piece, fx);
	bgb_machine_play_top_side_fx(localclientnum, piece, fx);
	bgb_machine_play_mid_side_fx(localclientnum, piece, fx);
	bgb_machine_play_btm_side_fx(localclientnum, piece, fx);
}

/*
	Name: bgb_machine_play_sound
	Namespace: bgb_machine
	Checksum: 0xB691EEF7
	Offset: 0x2010
	Size: 0x64
	Parameters: 3
	Flags: Linked, Private
*/
function private bgb_machine_play_sound(localclientnum, entity, alias)
{
	origin = entity gettagorigin("tag_fx_light_top_jnt");
	playsound(localclientnum, alias, origin);
}

/*
	Name: function_d5f882d0
	Namespace: bgb_machine
	Checksum: 0x7740EBF
	Offset: 0x2080
	Size: 0x44
	Parameters: 1
	Flags: Linked, Private
*/
function private function_d5f882d0(localclientnum)
{
	self bgb_machine_play_fx(localclientnum, self zbarriergetpiece(5), "tag_origin", undefined);
}

/*
	Name: function_eb5b80c5
	Namespace: bgb_machine
	Checksum: 0x62D16D2
	Offset: 0x20D0
	Size: 0xA4
	Parameters: 1
	Flags: Linked, Private
*/
function private function_eb5b80c5(localclientnum)
{
	self notify(#"bgb_machine_bulb_fx_start");
	self endon(#"bgb_machine_bulb_fx_start");
	self bgb_machine_play_all_bulb_fx(localclientnum, self zbarriergetpiece(5), undefined);
	self bgb_machine_play_fx(localclientnum, self zbarriergetpiece(5), "tag_origin", level._effect["zm_bgb_machine_available"]);
}

/*
	Name: bgb_machine_bulb_flash
	Namespace: bgb_machine
	Checksum: 0xA9376D4B
	Offset: 0x2180
	Size: 0xCE
	Parameters: 5
	Flags: Linked, Private
*/
function private bgb_machine_bulb_flash(localclientnum, piece, fx, flash_time, alias)
{
	self notify(#"bgb_machine_bulb_fx_start");
	self endon(#"bgb_machine_bulb_fx_start");
	function_d5f882d0(localclientnum);
	for(;;)
	{
		bgb_machine_play_all_bulb_fx(localclientnum, piece, fx);
		if(isdefined(alias))
		{
			bgb_machine_play_sound(localclientnum, piece, alias);
		}
		wait(flash_time);
		bgb_machine_play_all_bulb_fx(localclientnum, piece, undefined);
		wait(flash_time);
	}
}

/*
	Name: bgb_machine_bulb_flash_selected_bgb
	Namespace: bgb_machine
	Checksum: 0xD4F806F1
	Offset: 0x2258
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private bgb_machine_bulb_flash_selected_bgb(localclientnum)
{
	self thread bgb_machine_bulb_flash(localclientnum, self zbarriergetpiece(5), self bgb_machine_get_bulb_fx_for_selected_bgb(), 0.4, "zmb_bgb_machine_light_ready");
}

/*
	Name: function_5f830538
	Namespace: bgb_machine
	Checksum: 0x47301EA5
	Offset: 0x22C8
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private function_5f830538(localclientnum)
{
	self thread bgb_machine_bulb_flash(localclientnum, self zbarriergetpiece(5), level._effect["zm_bgb_machine_bulb_available"], 0.2, "zmb_bgb_machine_light_click");
}

/*
	Name: bgb_machine_bulb_flash_away
	Namespace: bgb_machine
	Checksum: 0xB3A8ED9E
	Offset: 0x2338
	Size: 0x64
	Parameters: 1
	Flags: Linked, Private
*/
function private bgb_machine_bulb_flash_away(localclientnum)
{
	self thread bgb_machine_bulb_flash(localclientnum, self zbarriergetpiece(1), level._effect["zm_bgb_machine_bulb_away"], 0.4, "zmb_bgb_machine_light_leaving");
}

/*
	Name: bgb_machine_bulb_solid_away
	Namespace: bgb_machine
	Checksum: 0x7AC62F10
	Offset: 0x23A8
	Size: 0x74
	Parameters: 1
	Flags: Linked, Private
*/
function private bgb_machine_bulb_solid_away(localclientnum)
{
	self notify(#"bgb_machine_bulb_fx_start");
	function_d5f882d0(localclientnum);
	bgb_machine_play_all_bulb_fx(localclientnum, self zbarriergetpiece(5), level._effect["zm_bgb_machine_bulb_away"]);
}

/*
	Name: bgb_machine_fx_state
	Namespace: bgb_machine
	Checksum: 0x43AA040D
	Offset: 0x2428
	Size: 0x38C
	Parameters: 7
	Flags: Linked, Private
*/
function private bgb_machine_fx_state(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	bgb_machine_init(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
	if(!isdefined(self))
	{
		return;
	}
	eye_fx = undefined;
	light_interior_fx = undefined;
	switch(newval)
	{
		case 1:
		{
			bgb_machine_play_fx(localclientnum, self zbarriergetpiece(5), "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior_away"]);
			self thread bgb_machine_bulb_solid_away(localclientnum);
			break;
		}
		case 2:
		{
			eye_fx = level._effect["zm_bgb_machine_eye_away"];
			eye_piece = self zbarriergetpiece(1);
			self thread bgb_machine_bulb_flash_away(localclientnum);
			break;
		}
		case 3:
		{
			light_interior_fx = level._effect["zm_bgb_machine_light_interior"];
			light_interior_piece = self zbarriergetpiece(5);
			eye_fx = bgb_machine_get_eye_fx_for_selected_bgb();
			eye_piece = self zbarriergetpiece(2);
			self thread bgb_machine_bulb_flash_selected_bgb(localclientnum);
			if(self clientfield::get("zm_bgb_machine_ghost_ball"))
			{
				bgb_machine_play_fx(localclientnum, eye_piece, "tag_gumball_ghost", level._effect["zm_bgb_machine_gumball_ghost"]);
			}
			else
			{
				bgb_machine_play_fx(localclientnum, eye_piece, "tag_gumball_ghost", level._effect["zm_bgb_machine_gumball_halo"]);
			}
			break;
		}
		case 4:
		{
			bgb_machine_play_fx(localclientnum, self zbarriergetpiece(5), "tag_fx_glass_cntr_jnt", level._effect["zm_bgb_machine_light_interior"]);
			self thread function_eb5b80c5(localclientnum);
			halo_piece = self zbarriergetpiece(2);
			bgb_machine_play_fx(localclientnum, halo_piece, "tag_gumball_ghost", undefined, 0);
			break;
		}
	}
	bgb_machine_play_fx(localclientnum, eye_piece, "tag_fx_light_lion_lft_eye_jnt", eye_fx);
	bgb_machine_play_fx(localclientnum, eye_piece, "tag_fx_light_lion_rt_eye_jnt", eye_fx);
}

/*
	Name: function_b90b22b6
	Namespace: bgb_machine
	Checksum: 0xED282766
	Offset: 0x27C0
	Size: 0x11C
	Parameters: 0
	Flags: Linked
*/
function function_b90b22b6()
{
	if(!isdefined(level.bgb_machine_max_uses_per_round))
	{
		level.bgb_machine_max_uses_per_round = 3;
	}
	if(!isdefined(level.var_f02c5598))
	{
		level.var_f02c5598 = 1000;
	}
	if(!isdefined(level.var_e1dee7ba))
	{
		level.var_e1dee7ba = 10;
	}
	if(!isdefined(level.var_a3e3127d))
	{
		level.var_a3e3127d = 2;
	}
	if(!isdefined(level.var_8ef45dc2))
	{
		level.var_8ef45dc2 = 10;
	}
	if(!isdefined(level.var_1485dcdc))
	{
		level.var_1485dcdc = 2;
	}
	if(!isdefined(level.var_bb2b3f61))
	{
		level.var_bb2b3f61 = [];
	}
	if(!isdefined(level.var_32948a58))
	{
		level.var_32948a58 = [];
	}
	if(!isdefined(level.var_f26edb66))
	{
		level.var_f26edb66 = [];
	}
	if(!isdefined(level.var_6c7a96b4))
	{
		level.var_6c7a96b4 = &function_6c7a96b4;
	}
	callback::on_localplayer_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: bgb_machine
	Checksum: 0x6EB53440
	Offset: 0x28E8
	Size: 0xFC
	Parameters: 1
	Flags: Linked, Private
*/
function private on_player_spawned(localclientnum)
{
	if(!isdefined(level.var_bb2b3f61[localclientnum]))
	{
		level.var_bb2b3f61[localclientnum] = 0;
	}
	if(!isdefined(level.var_32948a58[localclientnum]))
	{
		level.var_32948a58[localclientnum] = 0;
	}
	if(!isdefined(level.var_f26edb66[localclientnum]))
	{
		level.var_f26edb66[localclientnum] = 0;
	}
	function_725214c(localclientnum, level.var_bb2b3f61[localclientnum], level.var_32948a58[localclientnum], level.var_f26edb66[localclientnum]);
	self thread function_763ef0fd(localclientnum);
	self thread function_5d9d13da(localclientnum);
	self thread function_fda54943(localclientnum);
}

/*
	Name: function_763ef0fd
	Namespace: bgb_machine
	Checksum: 0x67486D7A
	Offset: 0x29F0
	Size: 0xCE
	Parameters: 1
	Flags: Linked, Private
*/
function private function_763ef0fd(localclientnum)
{
	self notify(#"hash_763ef0fd");
	self endon(#"hash_763ef0fd");
	self endon(#"entityshutdown");
	while(true)
	{
		rounds = getroundsplayed(localclientnum);
		if(rounds != level.var_bb2b3f61[localclientnum])
		{
			level.var_bb2b3f61[localclientnum] = rounds;
			function_725214c(localclientnum, level.var_bb2b3f61[localclientnum], level.var_32948a58[localclientnum], level.var_f26edb66[localclientnum]);
		}
		wait(1);
	}
}

/*
	Name: function_5d9d13da
	Namespace: bgb_machine
	Checksum: 0xCD47F3D6
	Offset: 0x2AC8
	Size: 0xC0
	Parameters: 1
	Flags: Linked, Private
*/
function private function_5d9d13da(localclientnum)
{
	self notify(#"hash_5d9d13da");
	self endon(#"hash_5d9d13da");
	self endon(#"entityshutdown");
	while(true)
	{
		self waittill(#"powerup", powerup, state);
		if(powerup == "powerup_fire_sale")
		{
			level.var_f26edb66[localclientnum] = state;
			function_725214c(localclientnum, level.var_bb2b3f61[localclientnum], level.var_32948a58[localclientnum], level.var_f26edb66[localclientnum]);
		}
	}
}

/*
	Name: function_fda54943
	Namespace: bgb_machine
	Checksum: 0xF65EAE22
	Offset: 0x2B90
	Size: 0x16E
	Parameters: 1
	Flags: Linked, Private
*/
function private function_fda54943(localclientnum)
{
	self endon(#"entityshutdown");
	var_89caac36 = 160000;
	while(true)
	{
		if(isdefined(level.bgb_machines))
		{
			foreach(machine in level.bgb_machines)
			{
				if(distancesquared(self.origin, machine.origin) <= var_89caac36 && 96 > (abs(self.origin[2] - machine.origin[2])))
				{
					wait(randomintrange(1, 4));
					machine playsound(localclientnum, "zmb_bgb_lionhead_roar");
					wait(130);
					break;
				}
			}
		}
		wait(1);
	}
}

/*
	Name: function_27a93844
	Namespace: bgb_machine
	Checksum: 0x717F7168
	Offset: 0x2D08
	Size: 0x8C
	Parameters: 7
	Flags: Linked, Private
*/
function private function_27a93844(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	level.var_32948a58[localclientnum] = newval;
	function_725214c(localclientnum, level.var_bb2b3f61[localclientnum], level.var_32948a58[localclientnum], level.var_f26edb66[localclientnum]);
}

/*
	Name: function_725214c
	Namespace: bgb_machine
	Checksum: 0x1935A457
	Offset: 0x2DA0
	Size: 0x8C
	Parameters: 4
	Flags: Linked, Private
*/
function private function_725214c(localclientnum, rounds, buys, firesale)
{
	base_cost = 500;
	if(firesale)
	{
		base_cost = 10;
	}
	cost = [[level.var_6c7a96b4]](self, base_cost, buys, rounds, firesale);
	setbgbcost(localclientnum, cost);
}

/*
	Name: function_6c7a96b4
	Namespace: bgb_machine
	Checksum: 0x5353186D
	Offset: 0x2E38
	Size: 0x1C8
	Parameters: 5
	Flags: Linked
*/
function function_6c7a96b4(player, base_cost, buys, rounds, firesale)
{
	if(buys < 1 && getdvarint("scr_firstGumFree") === 1)
	{
		return 0;
	}
	if(!isdefined(level.var_f02c5598))
	{
		level.var_f02c5598 = 1000;
	}
	if(!isdefined(level.var_e1dee7ba))
	{
		level.var_e1dee7ba = 10;
	}
	if(!isdefined(level.var_1485dcdc))
	{
		level.var_1485dcdc = 2;
	}
	cost = 500;
	if(buys >= 1)
	{
		var_33ea806b = floor(rounds / level.var_e1dee7ba);
		var_33ea806b = math::clamp(var_33ea806b, 0, level.var_8ef45dc2);
		var_39a90c5a = pow(level.var_a3e3127d, var_33ea806b);
		cost = cost + (level.var_f02c5598 * var_39a90c5a);
	}
	if(buys >= 2)
	{
		cost = cost * level.var_1485dcdc;
	}
	cost = int(cost);
	if(500 != base_cost)
	{
		cost = cost - (500 - base_cost);
	}
	return cost;
}

