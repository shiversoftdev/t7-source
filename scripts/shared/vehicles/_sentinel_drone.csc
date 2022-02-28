// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using_animtree("generic");

#namespace sentinel_drone;

/*
	Name: __init__sytem__
	Namespace: sentinel_drone
	Checksum: 0xE866954C
	Offset: 0x8B8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("sentinel_drone", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: sentinel_drone
	Checksum: 0x5809DDBD
	Offset: 0x8F8
	Size: 0x866
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "sentinel_drone_beam_set_target_id", 12000, 5, "int", &sentinel_drone_beam_set_target_id, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_beam_set_source_to_target", 12000, 5, "int", &sentinel_drone_beam_set_source_to_target, 0, 0);
	clientfield::register("toplayer", "sentinel_drone_damage_player_fx", 12000, 1, "counter", &sentinel_drone_damage_player_fx, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_beam_fire1", 12000, 1, "int", &sentinel_drone_beam_fire1, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_beam_fire2", 12000, 1, "int", &sentinel_drone_beam_fire2, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_beam_fire3", 12000, 1, "int", &sentinel_drone_beam_fire3, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_arm_cut_1", 12000, 1, "int", &sentinel_drone_arm_cut_1, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_arm_cut_2", 12000, 1, "int", &sentinel_drone_arm_cut_2, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_arm_cut_3", 12000, 1, "int", &sentinel_drone_arm_cut_3, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_face_cut", 12000, 1, "int", &sentinel_drone_face_cut, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_beam_charge", 12000, 1, "int", &sentinel_drone_beam_charge, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_camera_scanner", 12000, 1, "int", &sentinel_drone_camera_scanner, 0, 0);
	clientfield::register("vehicle", "sentinel_drone_camera_destroyed", 12000, 1, "int", &sentinel_drone_camera_destroyed, 0, 0);
	clientfield::register("scriptmover", "sentinel_drone_deathfx", 1, 1, "int", &sentinel_drone_deathfx, 0, 0);
	level._sentinel_enemy_detected_taunts = [];
	if(!isdefined(level._sentinel_enemy_detected_taunts))
	{
		level._sentinel_enemy_detected_taunts = [];
	}
	else if(!isarray(level._sentinel_enemy_detected_taunts))
	{
		level._sentinel_enemy_detected_taunts = array(level._sentinel_enemy_detected_taunts);
	}
	level._sentinel_enemy_detected_taunts[level._sentinel_enemy_detected_taunts.size] = "vox_valk_valkyrie_detected_0";
	if(!isdefined(level._sentinel_enemy_detected_taunts))
	{
		level._sentinel_enemy_detected_taunts = [];
	}
	else if(!isarray(level._sentinel_enemy_detected_taunts))
	{
		level._sentinel_enemy_detected_taunts = array(level._sentinel_enemy_detected_taunts);
	}
	level._sentinel_enemy_detected_taunts[level._sentinel_enemy_detected_taunts.size] = "vox_valk_valkyrie_detected_1";
	if(!isdefined(level._sentinel_enemy_detected_taunts))
	{
		level._sentinel_enemy_detected_taunts = [];
	}
	else if(!isarray(level._sentinel_enemy_detected_taunts))
	{
		level._sentinel_enemy_detected_taunts = array(level._sentinel_enemy_detected_taunts);
	}
	level._sentinel_enemy_detected_taunts[level._sentinel_enemy_detected_taunts.size] = "vox_valk_valkyrie_detected_2";
	if(!isdefined(level._sentinel_enemy_detected_taunts))
	{
		level._sentinel_enemy_detected_taunts = [];
	}
	else if(!isarray(level._sentinel_enemy_detected_taunts))
	{
		level._sentinel_enemy_detected_taunts = array(level._sentinel_enemy_detected_taunts);
	}
	level._sentinel_enemy_detected_taunts[level._sentinel_enemy_detected_taunts.size] = "vox_valk_valkyrie_detected_3";
	if(!isdefined(level._sentinel_enemy_detected_taunts))
	{
		level._sentinel_enemy_detected_taunts = [];
	}
	else if(!isarray(level._sentinel_enemy_detected_taunts))
	{
		level._sentinel_enemy_detected_taunts = array(level._sentinel_enemy_detected_taunts);
	}
	level._sentinel_enemy_detected_taunts[level._sentinel_enemy_detected_taunts.size] = "vox_valk_valkyrie_detected_4";
	level._sentinel_attack_taunts = [];
	if(!isdefined(level._sentinel_attack_taunts))
	{
		level._sentinel_attack_taunts = [];
	}
	else if(!isarray(level._sentinel_attack_taunts))
	{
		level._sentinel_attack_taunts = array(level._sentinel_attack_taunts);
	}
	level._sentinel_attack_taunts[level._sentinel_attack_taunts.size] = "vox_valk_valkyrie_attack_0";
	if(!isdefined(level._sentinel_attack_taunts))
	{
		level._sentinel_attack_taunts = [];
	}
	else if(!isarray(level._sentinel_attack_taunts))
	{
		level._sentinel_attack_taunts = array(level._sentinel_attack_taunts);
	}
	level._sentinel_attack_taunts[level._sentinel_attack_taunts.size] = "vox_valk_valkyrie_attack_1";
	if(!isdefined(level._sentinel_attack_taunts))
	{
		level._sentinel_attack_taunts = [];
	}
	else if(!isarray(level._sentinel_attack_taunts))
	{
		level._sentinel_attack_taunts = array(level._sentinel_attack_taunts);
	}
	level._sentinel_attack_taunts[level._sentinel_attack_taunts.size] = "vox_valk_valkyrie_attack_2";
	if(!isdefined(level._sentinel_attack_taunts))
	{
		level._sentinel_attack_taunts = [];
	}
	else if(!isarray(level._sentinel_attack_taunts))
	{
		level._sentinel_attack_taunts = array(level._sentinel_attack_taunts);
	}
	level._sentinel_attack_taunts[level._sentinel_attack_taunts.size] = "vox_valk_valkyrie_attack_3";
	if(!isdefined(level._sentinel_attack_taunts))
	{
		level._sentinel_attack_taunts = [];
	}
	else if(!isarray(level._sentinel_attack_taunts))
	{
		level._sentinel_attack_taunts = array(level._sentinel_attack_taunts);
	}
	level._sentinel_attack_taunts[level._sentinel_attack_taunts.size] = "vox_valk_valkyrie_attack_4";
}

/*
	Name: sentinel_is_drone_initialized
	Namespace: sentinel_drone
	Checksum: 0xD258EA6B
	Offset: 0x1168
	Size: 0xDE
	Parameters: 2
	Flags: Linked
*/
function sentinel_is_drone_initialized(localclientnum, b_check_for_target_existance_only)
{
	if(!(isdefined(b_check_for_target_existance_only) && b_check_for_target_existance_only))
	{
		if(!(isdefined(self.init) && self.init))
		{
			return false;
		}
		if(!self hasdobj(localclientnum))
		{
			return false;
		}
		return true;
	}
	source_num = self getentitynumber();
	if(isdefined(level.sentinel_drone_source_to_target) && isdefined(level.sentinel_drone_source_to_target[source_num]) && isdefined(level.sentinel_drone_target_id) && isdefined(level.sentinel_drone_target_id[level.sentinel_drone_source_to_target[source_num]]))
	{
		return true;
	}
	return false;
}

/*
	Name: sentinel_drone_damage_player_fx
	Namespace: sentinel_drone
	Checksum: 0x9A3ADF8A
	Offset: 0x1250
	Size: 0x84
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_damage_player_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	localplayer = getlocalplayer(localclientnum);
	if(isdefined(localplayer))
	{
		localplayer thread postfx::playpostfxbundle("sentinel_pstfx_shock_charge");
	}
}

/*
	Name: sentinel_drone_deathfx
	Namespace: sentinel_drone
	Checksum: 0x6F40C38F
	Offset: 0x12E0
	Size: 0x118
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_deathfx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	settings = struct::get_script_bundle("vehiclecustomsettings", "sentinel_drone_settings");
	if(isdefined(settings))
	{
		if(newval)
		{
			handle = playfx(localclientnum, settings.drone_secondary_death_fx_1, self.origin);
			setfxignorepause(localclientnum, handle, 1);
			if(isdefined(self.beam_target_fx) && isdefined(self.beam_target_fx[localclientnum]))
			{
				stopfx(localclientnum, self.beam_target_fx[localclientnum]);
				self.beam_target_fx[localclientnum] = undefined;
			}
		}
	}
}

/*
	Name: sentinel_drone_camera_scanner
	Namespace: sentinel_drone
	Checksum: 0xC80599F
	Offset: 0x1400
	Size: 0x16C
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_camera_scanner(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!sentinel_is_drone_initialized(localclientnum))
	{
		return false;
	}
	if(newval == 1)
	{
		if(!isdefined(self.camerascannerfx) && (!(isdefined(self.cameradestroyed) && self.cameradestroyed)))
		{
			self.camerascannerfx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_scanner_light_glow", self, "tag_flash");
		}
		sentinel_play_engine_fx(localclientnum, 0, 1);
	}
	else
	{
		/#
			keep_scanner_on = getdvarint("", 0);
		#/
		if(isdefined(self.camerascannerfx) && (!(isdefined(keep_scanner_on) && keep_scanner_on)))
		{
			stopfx(localclientnum, self.camerascannerfx);
			self.camerascannerfx = undefined;
		}
		sentinel_play_engine_fx(localclientnum, 1, 0);
	}
}

/*
	Name: sentinel_drone_camera_destroyed
	Namespace: sentinel_drone
	Checksum: 0x37C4EEE5
	Offset: 0x1578
	Size: 0xB6
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_camera_destroyed(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self.cameradestroyed = 1;
	if(isdefined(self.camerascannerfx))
	{
		stopfx(localclientnum, self.camerascannerfx);
		self.camerascannerfx = undefined;
	}
	if(isdefined(self.cameraambientfx))
	{
		stopfx(localclientnum, self.cameraambientfx);
		self.cameraambientfx = undefined;
	}
}

/*
	Name: sentinel_drone_beam_fire1
	Namespace: sentinel_drone
	Checksum: 0xD1BA0FA9
	Offset: 0x1638
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_beam_fire1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	sentinel_drone_beam_fire(localclientnum, newval, "tag_fx1");
}

/*
	Name: sentinel_drone_beam_fire2
	Namespace: sentinel_drone
	Checksum: 0xBA5149AD
	Offset: 0x16A0
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_beam_fire2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	sentinel_drone_beam_fire(localclientnum, newval, "tag_fx2");
}

/*
	Name: sentinel_drone_beam_fire3
	Namespace: sentinel_drone
	Checksum: 0xC1E29887
	Offset: 0x1708
	Size: 0x5C
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_beam_fire3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	sentinel_drone_beam_fire(localclientnum, newval, "tag_fx3");
}

/*
	Name: sentinel_drone_beam_fire
	Namespace: sentinel_drone
	Checksum: 0x1D8BB6A9
	Offset: 0x1770
	Size: 0x284
	Parameters: 3
	Flags: Linked
*/
function sentinel_drone_beam_fire(localclientnum, newval, tag_id)
{
	if(sentinel_is_drone_initialized(localclientnum, newval == 0))
	{
		source_num = self getentitynumber();
		beam_target = level.sentinel_drone_target_id[level.sentinel_drone_source_to_target[source_num]];
	}
	else
	{
		return;
	}
	if(newval == 1)
	{
		level beam::launch(self, tag_id, beam_target, "tag_origin", "electric_taser_beam_1");
		self playsound(0, "zmb_sentinel_attack_short");
		if(!isdefined(beam_target.beam_target_fx))
		{
			beam_target.beam_target_fx = [];
		}
		if(!isdefined(beam_target.beam_target_fx[localclientnum]))
		{
			beam_target.beam_target_fx[localclientnum] = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_taser_fire_tgt", beam_target, "tag_origin");
		}
		/#
			keep_scanner_on = getdvarint("", 0);
		#/
		if(isdefined(self.camerascannerfx) && (!(isdefined(keep_scanner_on) && keep_scanner_on)))
		{
			stopfx(localclientnum, self.camerascannerfx);
			self.camerascannerfx = undefined;
		}
	}
	else
	{
		level beam::kill(self, tag_id, beam_target, "tag_origin", "electric_taser_beam_1");
		if(isdefined(beam_target.beam_target_fx) && isdefined(beam_target.beam_target_fx[localclientnum]))
		{
			stopfx(localclientnum, beam_target.beam_target_fx[localclientnum]);
			beam_target.beam_target_fx[localclientnum] = undefined;
		}
		self sentinel_play_claws_ambient_fx(localclientnum);
	}
}

/*
	Name: sentinel_drone_beam_set_target_id
	Namespace: sentinel_drone
	Checksum: 0x4CBF813
	Offset: 0x1A00
	Size: 0x66
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_beam_set_target_id(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.sentinel_drone_target_id))
	{
		level.sentinel_drone_target_id = [];
	}
	level.sentinel_drone_target_id[newval] = self;
}

/*
	Name: sentinel_drone_beam_set_source_to_target
	Namespace: sentinel_drone
	Checksum: 0xF588F741
	Offset: 0x1A70
	Size: 0x174
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_beam_set_source_to_target(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(level.sentinel_drone_source_to_target))
	{
		level.sentinel_drone_source_to_target = [];
	}
	source_num = self getentitynumber();
	level.sentinel_drone_source_to_target[source_num] = newval;
	self.init = 1;
	self sentinel_play_claws_ambient_fx(localclientnum);
	self.cameraambientfx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_eye_camera_lens_glow", self, "tag_flash");
	self.camerascannerfx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_scanner_light_glow", self, "tag_flash");
	sentinel_play_engine_fx(localclientnum, 1, 0);
	self useanimtree($generic);
	self setanim("ai_zm_dlc3_sentinel_antenna_twitch");
}

/*
	Name: sentinel_drone_arm_cut_1
	Namespace: sentinel_drone
	Checksum: 0x225AB245
	Offset: 0x1BF0
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_arm_cut_1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	sentinel_drone_arm_cut(localclientnum, 1);
}

/*
	Name: sentinel_drone_arm_cut_2
	Namespace: sentinel_drone
	Checksum: 0x8F4C8905
	Offset: 0x1C50
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_arm_cut_2(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	sentinel_drone_arm_cut(localclientnum, 2);
}

/*
	Name: sentinel_drone_arm_cut_3
	Namespace: sentinel_drone
	Checksum: 0x3EC54C3D
	Offset: 0x1CB0
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_arm_cut_3(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	sentinel_drone_arm_cut(localclientnum, 3);
}

/*
	Name: sentinel_spawn_broken_arm
	Namespace: sentinel_drone
	Checksum: 0x828D04A1
	Offset: 0x1D10
	Size: 0x2CC
	Parameters: 4
	Flags: Linked
*/
function sentinel_spawn_broken_arm(localclientnum, arm, arm_tag, claw_tag)
{
	if(!sentinel_is_drone_initialized(localclientnum))
	{
		return false;
	}
	velocity = self getvelocity();
	velocity_normal = vectornormalize(velocity);
	velocity_length = length(velocity);
	if(arm == 3)
	{
		launch_dir = anglestoforward(self.angles) * -1;
		launch_dir = launch_dir + (0, 0, 1);
		launch_dir = vectornormalize(launch_dir);
	}
	else
	{
		if(arm == 1)
		{
			launch_dir = anglestoright(self.angles);
		}
		else
		{
			launch_dir = anglestoright(self.angles) * -1;
		}
	}
	velocity_length = velocity_length * 0.1;
	if(velocity_length < 10)
	{
		velocity_length = 10;
	}
	launch_dir = (launch_dir * 0.5) + (velocity_normal * 0.5);
	launch_dir = launch_dir * velocity_length;
	claw_pos = self gettagorigin(claw_tag) + (launch_dir * 3);
	claw_ang = self gettagangles(claw_tag);
	thread sentinel_launch_piece(localclientnum, "veh_t7_dlc3_sentinel_drone_spawn_claw", claw_pos, claw_ang, self.origin, launch_dir * 1.3);
	arm_pos = self gettagorigin(arm_tag) + (launch_dir * 2);
	arm_ang = self gettagangles(arm_tag);
	thread sentinel_launch_piece(localclientnum, "veh_t7_dlc3_sentinel_drone_spawn_arm", arm_pos, arm_ang, self.origin, launch_dir);
}

/*
	Name: sentinel_drone_arm_cut
	Namespace: sentinel_drone
	Checksum: 0x1625828D
	Offset: 0x1FE8
	Size: 0x3EC
	Parameters: 2
	Flags: Linked
*/
function sentinel_drone_arm_cut(localclientnum, arm)
{
	if(arm == 1)
	{
		if(!(isdefined(self.rightarmlost) && self.rightarmlost))
		{
			sentinel_spawn_broken_arm(localclientnum, 1, "tag_arm_right_04_d1", "tag_fx1");
			self.rightarmlost = 1;
			sentinel_drone_beam_fire(localclientnum, 0, "tag_fx1");
			if(isdefined(self.rightclawambientfx))
			{
				stopfx(localclientnum, self.rightclawambientfx);
				self.rightclawambientfx = undefined;
			}
			if(isdefined(self.rightclawchargefx))
			{
				stopfx(localclientnum, self.rightclawchargefx);
				self.rightclawchargefx = undefined;
			}
			if(sentinel_is_drone_initialized(localclientnum))
			{
				playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_dest_arm", self, "tag_arm_right_04_d1");
				self setanim("ai_zm_dlc3_sentinel_arms_broken_right");
			}
		}
	}
	else
	{
		if(arm == 2)
		{
			if(!(isdefined(self.leftarmlost) && self.leftarmlost))
			{
				sentinel_spawn_broken_arm(localclientnum, 2, "tag_arm_left_03_d1", "tag_fx2");
				self.leftarmlost = 1;
				sentinel_drone_beam_fire(localclientnum, 0, "tag_fx2");
				if(isdefined(self.leftclawambientfx))
				{
					stopfx(localclientnum, self.leftclawambientfx);
					self.leftclawambientfx = undefined;
				}
				if(isdefined(self.leftclawchargefx))
				{
					stopfx(localclientnum, self.leftclawchargefx);
					self.leftclawchargefx = undefined;
				}
				if(sentinel_is_drone_initialized(localclientnum))
				{
					playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_dest_arm", self, "tag_arm_left_03_d1");
					self setanim("ai_zm_dlc3_sentinel_arms_broken_left");
				}
			}
		}
		else if(arm == 3)
		{
			if(!(isdefined(self.toparmlost) && self.toparmlost))
			{
				sentinel_spawn_broken_arm(localclientnum, 3, "tag_arm_top_03_d1", "tag_fx3");
				self.toparmlost = 1;
				sentinel_drone_beam_fire(localclientnum, 0, "tag_fx3");
				if(isdefined(self.topclawambientfx))
				{
					stopfx(localclientnum, self.topclawambientfx);
					self.topclawambientfx = undefined;
				}
				if(isdefined(self.topclawchargefx))
				{
					stopfx(localclientnum, self.topclawchargefx);
					self.topclawchargefx = undefined;
				}
				if(sentinel_is_drone_initialized(localclientnum))
				{
					playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_dest_arm", self, "tag_arm_top_03_d1");
					self setanim("ai_zm_dlc3_sentinel_arms_broken_top");
				}
			}
		}
	}
}

/*
	Name: sentinel_drone_beam_charge
	Namespace: sentinel_drone
	Checksum: 0x5C45125B
	Offset: 0x23E0
	Size: 0x2A6
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_beam_charge(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!sentinel_is_drone_initialized(localclientnum))
	{
		return false;
	}
	if(newval == 1)
	{
		if(!isdefined(self.camerascannerfx))
		{
			self.camerascannerfx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_scanner_light_glow", self, "tag_flash");
		}
		self sentinel_play_claws_ambient_fx(localclientnum, 1);
		if(!(isdefined(self.rightarmlost) && self.rightarmlost))
		{
			self.rightclawchargefx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_taser_charging", self, "tag_fx1");
		}
		if(!(isdefined(self.leftarmlost) && self.leftarmlost))
		{
			self.leftclawchargefx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_taser_charging", self, "tag_fx2");
		}
		if(!(isdefined(self.toparmlost) && self.toparmlost))
		{
			self.topclawchargefx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_taser_charging", self, "tag_fx3");
		}
		if(isdefined(self.enemy_already_spotted))
		{
			if(randomint(100) < 30)
			{
				sentinel_play_taunt(localclientnum, level._sentinel_attack_taunts);
			}
		}
		else
		{
			self.enemy_already_spotted = 1;
			sentinel_play_taunt(localclientnum, level._sentinel_enemy_detected_taunts);
		}
	}
	else
	{
		if(isdefined(self.rightclawchargefx))
		{
			stopfx(localclientnum, self.rightclawchargefx);
			self.rightclawchargefx = undefined;
		}
		if(isdefined(self.leftclawchargefx))
		{
			stopfx(localclientnum, self.leftclawchargefx);
			self.leftclawchargefx = undefined;
		}
		if(isdefined(self.topclawchargefx))
		{
			stopfx(localclientnum, self.topclawchargefx);
			self.topclawchargefx = undefined;
		}
	}
}

/*
	Name: sentinel_drone_face_cut
	Namespace: sentinel_drone
	Checksum: 0xFC7A6FE9
	Offset: 0x2690
	Size: 0x20C
	Parameters: 7
	Flags: Linked
*/
function sentinel_drone_face_cut(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!sentinel_is_drone_initialized(localclientnum))
	{
		return false;
	}
	face_pos = self gettagorigin("tag_faceplate_d0");
	face_ang = self gettagangles("tag_faceplate_d0");
	velocity = self getvelocity();
	velocity_normal = vectornormalize(velocity);
	velocity_length = length(velocity);
	launch_dir = anglestoforward(self.angles);
	velocity_length = velocity_length * 0.1;
	if(velocity_length < 10)
	{
		velocity_length = 10;
	}
	launch_dir = (launch_dir * 0.5) + (velocity_normal * 0.5);
	launch_dir = launch_dir * velocity_length;
	thread sentinel_launch_piece(localclientnum, "veh_t7_dlc3_sentinel_drone_faceplate", face_pos, face_ang, self.origin, launch_dir);
	playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_dest_core", self, "tag_faceplate_d0");
	playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_energy_core_glow", self, "ag_core_d0");
}

/*
	Name: sentinel_play_claws_ambient_fx
	Namespace: sentinel_drone
	Checksum: 0xB5CE96D
	Offset: 0x28A8
	Size: 0x1DE
	Parameters: 2
	Flags: Linked
*/
function sentinel_play_claws_ambient_fx(localclientnum, b_false)
{
	if(!sentinel_is_drone_initialized(localclientnum))
	{
		return false;
	}
	if(!(isdefined(b_false) && b_false))
	{
		if(!(isdefined(self.rightarmlost) && self.rightarmlost) && !isdefined(self.rightclawambientfx))
		{
			self.rightclawambientfx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_taser_idle", self, "tag_fx1");
		}
		if(!(isdefined(self.leftarmlost) && self.leftarmlost) && !isdefined(self.leftclawambientfx))
		{
			self.leftclawambientfx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_taser_idle", self, "tag_fx2");
		}
		if(!(isdefined(self.toparmlost) && self.toparmlost) && !isdefined(self.topclawambientfx))
		{
			self.topclawambientfx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_taser_idle", self, "tag_fx3");
		}
	}
	else
	{
		if(isdefined(self.rightclawambientfx))
		{
			stopfx(localclientnum, self.rightclawambientfx);
			self.rightclawambientfx = undefined;
		}
		if(isdefined(self.leftclawambientfx))
		{
			stopfx(localclientnum, self.leftclawambientfx);
			self.leftclawambientfx = undefined;
		}
		if(isdefined(self.topclawambientfx))
		{
			stopfx(localclientnum, self.topclawambientfx);
			self.topclawambientfx = undefined;
		}
	}
}

/*
	Name: sentinel_play_engine_fx
	Namespace: sentinel_drone
	Checksum: 0xA36319B6
	Offset: 0x2A90
	Size: 0x11C
	Parameters: 3
	Flags: Linked
*/
function sentinel_play_engine_fx(localclientnum, b_engine, b_roll_engine)
{
	if(!sentinel_is_drone_initialized(localclientnum))
	{
		return false;
	}
	if(isdefined(b_engine) && b_engine)
	{
		self.enginefx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_engine_idle", self, "tag_fx_engine_left");
	}
	else if(isdefined(self.enginefx))
	{
		stopfx(localclientnum, self.enginefx);
	}
	if(isdefined(b_roll_engine) && b_roll_engine)
	{
		self.enginerollfx = playfxontag(localclientnum, "dlc3/stalingrad/fx_sentinel_drone_engine_smk_fast", self, "tag_fx_engine_left");
	}
	else if(isdefined(self.enginerollfx))
	{
		stopfx(localclientnum, self.enginerollfx);
	}
}

/*
	Name: sentinel_play_taunt
	Namespace: sentinel_drone
	Checksum: 0x2C17BB0E
	Offset: 0x2BB8
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function sentinel_play_taunt(localclientnum, taunt_arr)
{
	if(isdefined(level._lastplayed_drone_taunt) && (gettime() - level._lastplayed_drone_taunt) < 6000)
	{
		return;
	}
	if(isdefined(level.voxaideactivate) && level.voxaideactivate)
	{
		return;
	}
	taunt = randomint(taunt_arr.size);
	level._lastplayed_drone_taunt = gettime();
	self playsound(localclientnum, taunt_arr[taunt]);
}

/*
	Name: sentinel_launch_piece
	Namespace: sentinel_drone
	Checksum: 0xA8B65AD7
	Offset: 0x2C68
	Size: 0x284
	Parameters: 6
	Flags: Linked
*/
function sentinel_launch_piece(localclientnum, model, pos, angles, hitpos, force)
{
	dynent = createdynentandlaunch(localclientnum, model, pos, angles, hitpos, force);
	if(!isdefined(dynent))
	{
		return;
	}
	posheight = pos[2];
	wait(0.5);
	if(!isdefined(dynent) || !isdynentvalid(dynent))
	{
		return false;
	}
	if(dynent.origin == pos)
	{
		setdynentenabled(dynent, 0);
		return;
	}
	pos = dynent.origin;
	wait(0.4);
	if(!isdefined(dynent) || !isdynentvalid(dynent))
	{
		return false;
	}
	if(dynent.origin == pos)
	{
		setdynentenabled(dynent, 0);
		return;
	}
	wait(1);
	if(!isdefined(dynent) || !isdynentvalid(dynent))
	{
		return false;
	}
	count = 0;
	old_pos = dynent.origin;
	while(isdefined(dynent) && isdynentvalid(dynent))
	{
		if(old_pos == dynent.origin)
		{
			old_pos = dynent.origin;
			count++;
			if(count == 5)
			{
				if((posheight - dynent.origin[2]) < 15)
				{
					setdynentenabled(dynent, 0);
				}
				else
				{
					break;
				}
			}
		}
		else
		{
			count = 0;
		}
		wait(0.2);
	}
}

