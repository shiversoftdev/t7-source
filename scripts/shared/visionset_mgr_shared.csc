// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace visionset_mgr;

/*
	Name: __init__sytem__
	Namespace: visionset_mgr
	Checksum: 0xD66FDC7F
	Offset: 0x330
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("visionset_mgr", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: visionset_mgr
	Checksum: 0x86E7BE4D
	Offset: 0x370
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.vsmgr_initializing = 1;
	level.vsmgr_default_info_name = "__none";
	level.vsmgr = [];
	level.vsmgr_states_inited = [];
	level.vsmgr_filter_custom_enable = [];
	level.vsmgr_filter_custom_disable = [];
	level thread register_type("visionset", &visionset_slot_cb, &visionset_lerp_cb, &visionset_update_cb);
	register_visionset_info(level.vsmgr_default_info_name, 1, 1, "undefined", "undefined");
	level thread register_type("overlay", &overlay_slot_cb, &overlay_lerp_cb, &overlay_update_cb);
	register_overlay_info_style_none(level.vsmgr_default_info_name, 1, 1);
	callback::on_finalize_initialization(&finalize_initialization);
	level thread monitor();
}

/*
	Name: register_visionset_info
	Namespace: visionset_mgr
	Checksum: 0x77AB809E
	Offset: 0x4E8
	Size: 0x100
	Parameters: 6
	Flags: Linked
*/
function register_visionset_info(name, version, lerp_step_count, visionset_from, visionset_to, visionset_type = 0)
{
	if(!register_info("visionset", name, version, lerp_step_count))
	{
		return;
	}
	level.vsmgr["visionset"].info[name].visionset_from = visionset_from;
	level.vsmgr["visionset"].info[name].visionset_to = visionset_to;
	level.vsmgr["visionset"].info[name].visionset_type = visionset_type;
}

/*
	Name: register_overlay_info_style_none
	Namespace: visionset_mgr
	Checksum: 0x9291B44E
	Offset: 0x5F0
	Size: 0x78
	Parameters: 3
	Flags: Linked
*/
function register_overlay_info_style_none(name, version, lerp_step_count)
{
	if(!register_info("overlay", name, version, lerp_step_count))
	{
		return;
	}
	level.vsmgr["overlay"].info[name].style = 0;
}

/*
	Name: register_overlay_info_style_filter
	Namespace: visionset_mgr
	Checksum: 0xCC96A556
	Offset: 0x670
	Size: 0x158
	Parameters: 7
	Flags: None
*/
function register_overlay_info_style_filter(name, version, lerp_step_count, filter_index, pass_index, material_name, constant_index)
{
	if(!register_info("overlay", name, version, lerp_step_count))
	{
		return;
	}
	level.vsmgr["overlay"].info[name].style = 2;
	level.vsmgr["overlay"].info[name].filter_index = filter_index;
	level.vsmgr["overlay"].info[name].pass_index = pass_index;
	level.vsmgr["overlay"].info[name].material_name = material_name;
	level.vsmgr["overlay"].info[name].constant_index = constant_index;
}

/*
	Name: register_overlay_info_style_blur
	Namespace: visionset_mgr
	Checksum: 0x4A2A223A
	Offset: 0x7D0
	Size: 0x120
	Parameters: 6
	Flags: None
*/
function register_overlay_info_style_blur(name, version, lerp_step_count, transition_in, transition_out, magnitude)
{
	if(!register_info("overlay", name, version, lerp_step_count))
	{
		return;
	}
	level.vsmgr["overlay"].info[name].style = 3;
	level.vsmgr["overlay"].info[name].transition_in = transition_in;
	level.vsmgr["overlay"].info[name].transition_out = transition_out;
	level.vsmgr["overlay"].info[name].magnitude = magnitude;
}

/*
	Name: register_overlay_info_style_electrified
	Namespace: visionset_mgr
	Checksum: 0xC4493FF4
	Offset: 0x8F8
	Size: 0xB0
	Parameters: 4
	Flags: None
*/
function register_overlay_info_style_electrified(name, version, lerp_step_count, duration)
{
	if(!register_info("overlay", name, version, lerp_step_count))
	{
		return;
	}
	level.vsmgr["overlay"].info[name].style = 4;
	level.vsmgr["overlay"].info[name].duration = duration;
}

/*
	Name: register_overlay_info_style_burn
	Namespace: visionset_mgr
	Checksum: 0xD6C38D2
	Offset: 0x9B0
	Size: 0xB0
	Parameters: 4
	Flags: None
*/
function register_overlay_info_style_burn(name, version, lerp_step_count, duration)
{
	if(!register_info("overlay", name, version, lerp_step_count))
	{
		return;
	}
	level.vsmgr["overlay"].info[name].style = 5;
	level.vsmgr["overlay"].info[name].duration = duration;
}

/*
	Name: register_overlay_info_style_poison
	Namespace: visionset_mgr
	Checksum: 0x7C740B03
	Offset: 0xA68
	Size: 0x78
	Parameters: 3
	Flags: None
*/
function register_overlay_info_style_poison(name, version, lerp_step_count)
{
	if(!register_info("overlay", name, version, lerp_step_count))
	{
		return;
	}
	level.vsmgr["overlay"].info[name].style = 6;
}

/*
	Name: register_overlay_info_style_transported
	Namespace: visionset_mgr
	Checksum: 0xFFE5A215
	Offset: 0xAE8
	Size: 0xB0
	Parameters: 4
	Flags: Linked
*/
function register_overlay_info_style_transported(name, version, lerp_step_count, duration)
{
	if(!register_info("overlay", name, version, lerp_step_count))
	{
		return;
	}
	level.vsmgr["overlay"].info[name].style = 7;
	level.vsmgr["overlay"].info[name].duration = duration;
}

/*
	Name: register_overlay_info_style_speed_blur
	Namespace: visionset_mgr
	Checksum: 0xEAFF77C2
	Offset: 0xBA0
	Size: 0x238
	Parameters: 11
	Flags: Linked
*/
function register_overlay_info_style_speed_blur(name, version, lerp_step_count, amount, inner_radius, outer_radius, velocity_should_scale, velocity_scale, blur_in, blur_out, should_offset)
{
	if(!register_info("overlay", name, version, lerp_step_count))
	{
		return;
	}
	level.vsmgr["overlay"].info[name].style = 8;
	level.vsmgr["overlay"].info[name].amount = amount;
	level.vsmgr["overlay"].info[name].inner_radius = inner_radius;
	level.vsmgr["overlay"].info[name].outer_radius = outer_radius;
	level.vsmgr["overlay"].info[name].velocity_should_scale = velocity_should_scale;
	level.vsmgr["overlay"].info[name].velocity_scale = velocity_scale;
	level.vsmgr["overlay"].info[name].blur_in = blur_in;
	level.vsmgr["overlay"].info[name].blur_out = blur_out;
	level.vsmgr["overlay"].info[name].should_offset = should_offset;
}

/*
	Name: register_overlay_info_style_postfx_bundle
	Namespace: visionset_mgr
	Checksum: 0xB9C67364
	Offset: 0xDE0
	Size: 0xE8
	Parameters: 5
	Flags: Linked
*/
function register_overlay_info_style_postfx_bundle(name, version, lerp_step_count, bundle, duration)
{
	if(!register_info("overlay", name, version, lerp_step_count))
	{
		return;
	}
	level.vsmgr["overlay"].info[name].style = 1;
	level.vsmgr["overlay"].info[name].bundle = bundle;
	level.vsmgr["overlay"].info[name].duration = duration;
}

/*
	Name: is_type_currently_default
	Namespace: visionset_mgr
	Checksum: 0x7EE1367F
	Offset: 0xED0
	Size: 0xA0
	Parameters: 2
	Flags: Linked
*/
function is_type_currently_default(localclientnum, type)
{
	if(!level.vsmgr[type].in_use)
	{
		return 1;
	}
	state = get_state(localclientnum, type);
	curr_info = get_info(type, state.curr_slot);
	return curr_info.name == level.vsmgr_default_info_name;
}

/*
	Name: register_type
	Namespace: visionset_mgr
	Checksum: 0x29A99C9A
	Offset: 0xF78
	Size: 0x198
	Parameters: 4
	Flags: Linked
*/
function register_type(type, cf_slot_cb, cf_lerp_cb, update_cb)
{
	level.vsmgr[type] = spawnstruct();
	level.vsmgr[type].type = type;
	level.vsmgr[type].in_use = 0;
	level.vsmgr[type].highest_version = 0;
	level.vsmgr[type].server_version = getserverhighestclientfieldversion();
	level.vsmgr[type].cf_slot_name = type + "_slot";
	level.vsmgr[type].cf_lerp_name = type + "_lerp";
	level.vsmgr[type].cf_slot_cb = cf_slot_cb;
	level.vsmgr[type].cf_lerp_cb = cf_lerp_cb;
	level.vsmgr[type].update_cb = update_cb;
	level.vsmgr[type].info = [];
	level.vsmgr[type].sorted_name_keys = [];
}

/*
	Name: finalize_initialization
	Namespace: visionset_mgr
	Checksum: 0x2D0C7D48
	Offset: 0x1118
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function finalize_initialization(localclientnum)
{
	thread finalize_clientfields();
	if(!isdefined(level._fv2vs_default_visionset))
	{
		init_fog_vol_to_visionset_monitor(getdvarstring("mapname"), 0);
		fog_vol_to_visionset_set_info(0, getdvarstring("mapname"));
	}
}

/*
	Name: finalize_clientfields
	Namespace: visionset_mgr
	Checksum: 0xCFD81463
	Offset: 0x11A0
	Size: 0x80
	Parameters: 0
	Flags: Linked
*/
function finalize_clientfields()
{
	typekeys = getarraykeys(level.vsmgr);
	for(type_index = 0; type_index < typekeys.size; type_index++)
	{
		level.vsmgr[typekeys[type_index]] thread finalize_type_clientfields();
	}
	level.vsmgr_initializing = 0;
}

/*
	Name: finalize_type_clientfields
	Namespace: visionset_mgr
	Checksum: 0xD9B11D58
	Offset: 0x1228
	Size: 0x284
	Parameters: 0
	Flags: Linked
*/
function finalize_type_clientfields()
{
	/#
		println(("" + self.type) + "");
	#/
	if(1 >= self.info.size)
	{
		return;
	}
	self.in_use = 1;
	self.cf_slot_bit_count = getminbitcountfornum(self.info.size - 1);
	self.cf_lerp_bit_count = self.info[self.sorted_name_keys[0]].lerp_bit_count;
	for(i = 0; i < self.sorted_name_keys.size; i++)
	{
		self.info[self.sorted_name_keys[i]].slot_index = i;
		if(self.info[self.sorted_name_keys[i]].lerp_bit_count > self.cf_lerp_bit_count)
		{
			self.cf_lerp_bit_count = self.info[self.sorted_name_keys[i]].lerp_bit_count;
		}
		/#
			println(((((("" + self.info[self.sorted_name_keys[i]].name) + "") + self.info[self.sorted_name_keys[i]].version) + "") + self.info[self.sorted_name_keys[i]].lerp_step_count) + "");
		#/
	}
	clientfield::register("toplayer", self.cf_slot_name, self.highest_version, self.cf_slot_bit_count, "int", self.cf_slot_cb, 0, 1);
	if(1 < self.cf_lerp_bit_count)
	{
		clientfield::register("toplayer", self.cf_lerp_name, self.highest_version, self.cf_lerp_bit_count, "float", self.cf_lerp_cb, 0, 1);
	}
}

/*
	Name: validate_info
	Namespace: visionset_mgr
	Checksum: 0xDD9BCDD1
	Offset: 0x14B8
	Size: 0x188
	Parameters: 3
	Flags: Linked
*/
function validate_info(type, name, version)
{
	keys = getarraykeys(level.vsmgr);
	for(i = 0; i < keys.size; i++)
	{
		if(type == keys[i])
		{
			break;
		}
	}
	/#
		assert(i < keys.size, ("" + type) + "");
	#/
	if(version > level.vsmgr[type].server_version)
	{
		return false;
	}
	if(isdefined(level.vsmgr[type].info[name]) && version < level.vsmgr[type].info[name].version)
	{
		if(version < level.vsmgr[type].info[name].version)
		{
			return false;
		}
		level.vsmgr[type].info[name] = undefined;
	}
	return true;
}

/*
	Name: add_sorted_name_key
	Namespace: visionset_mgr
	Checksum: 0x512C328F
	Offset: 0x1648
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function add_sorted_name_key(type, name)
{
	for(i = 0; i < level.vsmgr[type].sorted_name_keys.size; i++)
	{
		if(name < level.vsmgr[type].sorted_name_keys[i])
		{
			break;
		}
	}
	arrayinsert(level.vsmgr[type].sorted_name_keys, name, i);
}

/*
	Name: add_info
	Namespace: visionset_mgr
	Checksum: 0x601349B
	Offset: 0x1700
	Size: 0x74
	Parameters: 4
	Flags: Linked
*/
function add_info(type, name, version, lerp_step_count)
{
	self.type = type;
	self.name = name;
	self.version = version;
	self.lerp_step_count = lerp_step_count;
	self.lerp_bit_count = getminbitcountfornum(lerp_step_count);
}

/*
	Name: register_info
	Namespace: visionset_mgr
	Checksum: 0xB1F5CAFF
	Offset: 0x1780
	Size: 0x15C
	Parameters: 4
	Flags: Linked
*/
function register_info(type, name, version, lerp_step_count)
{
	/#
		assert(level.vsmgr_initializing, "");
	#/
	lower_name = tolower(name);
	if(!validate_info(type, lower_name, version))
	{
		return false;
	}
	add_sorted_name_key(type, lower_name);
	level.vsmgr[type].info[lower_name] = spawnstruct();
	level.vsmgr[type].info[lower_name] add_info(type, lower_name, version, lerp_step_count);
	if(version > level.vsmgr[type].highest_version)
	{
		level.vsmgr[type].highest_version = version;
	}
	return true;
}

/*
	Name: slot_cb
	Namespace: visionset_mgr
	Checksum: 0xA10C27
	Offset: 0x18E8
	Size: 0xC4
	Parameters: 8
	Flags: Linked
*/
function slot_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump, type)
{
	init_states(localclientnum);
	level.vsmgr[type].state[localclientnum].curr_slot = newval;
	if(bnewent || binitialsnap)
	{
		level.vsmgr[type].state[localclientnum].force_update = 1;
	}
}

/*
	Name: visionset_slot_cb
	Namespace: visionset_mgr
	Checksum: 0xF32A3314
	Offset: 0x19B8
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function visionset_slot_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self slot_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump, "visionset");
}

/*
	Name: overlay_slot_cb
	Namespace: visionset_mgr
	Checksum: 0x69CE8F1A
	Offset: 0x1A38
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function overlay_slot_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self slot_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump, "overlay");
}

/*
	Name: lerp_cb
	Namespace: visionset_mgr
	Checksum: 0xD786DB52
	Offset: 0x1AB8
	Size: 0xC4
	Parameters: 8
	Flags: Linked
*/
function lerp_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump, type)
{
	init_states(localclientnum);
	level.vsmgr[type].state[localclientnum].curr_lerp = newval;
	if(bnewent || binitialsnap)
	{
		level.vsmgr[type].state[localclientnum].force_update = 1;
	}
}

/*
	Name: visionset_lerp_cb
	Namespace: visionset_mgr
	Checksum: 0xFBDFDE08
	Offset: 0x1B88
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function visionset_lerp_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self lerp_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump, "visionset");
}

/*
	Name: overlay_lerp_cb
	Namespace: visionset_mgr
	Checksum: 0xA5CFC324
	Offset: 0x1C08
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function overlay_lerp_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self lerp_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump, "overlay");
}

/*
	Name: get_info
	Namespace: visionset_mgr
	Checksum: 0x67246E78
	Offset: 0x1C88
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function get_info(type, slot)
{
	return level.vsmgr[type].info[level.vsmgr[type].sorted_name_keys[slot]];
}

/*
	Name: get_state
	Namespace: visionset_mgr
	Checksum: 0x53A8F11F
	Offset: 0x1CD8
	Size: 0x30
	Parameters: 2
	Flags: Linked
*/
function get_state(localclientnum, type)
{
	return level.vsmgr[type].state[localclientnum];
}

/*
	Name: should_update_state
	Namespace: visionset_mgr
	Checksum: 0x3CBE7588
	Offset: 0x1D10
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function should_update_state()
{
	return self.force_update || self.prev_slot != self.curr_slot || self.prev_lerp != self.curr_lerp;
}

/*
	Name: transition_state
	Namespace: visionset_mgr
	Checksum: 0xA8090E35
	Offset: 0x1D50
	Size: 0x30
	Parameters: 0
	Flags: Linked
*/
function transition_state()
{
	self.prev_slot = self.curr_slot;
	self.prev_lerp = self.curr_lerp;
	self.force_update = 0;
}

/*
	Name: init_states
	Namespace: visionset_mgr
	Checksum: 0xE001F67F
	Offset: 0x1D88
	Size: 0x256
	Parameters: 1
	Flags: Linked
*/
function init_states(localclientnum)
{
	if(isdefined(level.vsmgr_states_inited[localclientnum]))
	{
		return;
	}
	typekeys = getarraykeys(level.vsmgr);
	for(type_index = 0; type_index < typekeys.size; type_index++)
	{
		type = typekeys[type_index];
		if(!level.vsmgr[type].in_use)
		{
			continue;
		}
		if(!isdefined(level.vsmgr[type].state))
		{
			level.vsmgr[type].state = [];
		}
		level.vsmgr[type].state[localclientnum] = spawnstruct();
		level.vsmgr[type].state[localclientnum].prev_slot = level.vsmgr[type].info[level.vsmgr_default_info_name].slot_index;
		level.vsmgr[type].state[localclientnum].curr_slot = level.vsmgr[type].info[level.vsmgr_default_info_name].slot_index;
		level.vsmgr[type].state[localclientnum].prev_lerp = 1;
		level.vsmgr[type].state[localclientnum].curr_lerp = 1;
		level.vsmgr[type].state[localclientnum].force_update = 0;
	}
	level.vsmgr_states_inited[localclientnum] = 1;
}

/*
	Name: demo_jump_monitor
	Namespace: visionset_mgr
	Checksum: 0x520440C9
	Offset: 0x1FE8
	Size: 0x10A
	Parameters: 0
	Flags: Linked
*/
function demo_jump_monitor()
{
	if(!level.isdemoplaying)
	{
		return;
	}
	typekeys = getarraykeys(level.vsmgr);
	oldlerps = [];
	while(true)
	{
		level util::waittill_any("demo_jump", "demo_player_switch", "visionset_mgr_reset");
		for(type_index = 0; type_index < typekeys.size; type_index++)
		{
			type = typekeys[type_index];
			if(!level.vsmgr[type].in_use)
			{
				continue;
			}
			level.vsmgr[type].state[0].force_update = 1;
		}
	}
}

/*
	Name: demo_spectate_monitor
	Namespace: visionset_mgr
	Checksum: 0xC5AFC9E5
	Offset: 0x2100
	Size: 0xDC
	Parameters: 0
	Flags: Linked
*/
function demo_spectate_monitor()
{
	if(!level.isdemoplaying)
	{
		return;
	}
	typekeys = getarraykeys(level.vsmgr);
	while(true)
	{
		if(isspectating(0, 0))
		{
			if(!(isdefined(level.vsmgr_is_spectating) && level.vsmgr_is_spectating))
			{
				fog_vol_to_visionset_force_instant_transition(0);
				level notify(#"visionset_mgr_reset");
			}
			level.vsmgr_is_spectating = 1;
		}
		else
		{
			if(isdefined(level.vsmgr_is_spectating) && level.vsmgr_is_spectating)
			{
				level notify(#"visionset_mgr_reset");
			}
			level.vsmgr_is_spectating = 0;
		}
		wait(0.016);
	}
}

/*
	Name: monitor
	Namespace: visionset_mgr
	Checksum: 0x4C8CB625
	Offset: 0x21E8
	Size: 0x1D4
	Parameters: 0
	Flags: Linked
*/
function monitor()
{
	while(level.vsmgr_initializing)
	{
		wait(0.016);
	}
	if(isdefined(level.isdemoplaying) && level.isdemoplaying)
	{
		level thread demo_spectate_monitor();
		level thread demo_jump_monitor();
	}
	typekeys = getarraykeys(level.vsmgr);
	while(true)
	{
		for(type_index = 0; type_index < typekeys.size; type_index++)
		{
			type = typekeys[type_index];
			if(!level.vsmgr[type].in_use)
			{
				continue;
			}
			for(localclientnum = 0; localclientnum < level.localplayers.size; localclientnum++)
			{
				init_states(localclientnum);
				if(level.vsmgr[type].state[localclientnum] should_update_state())
				{
					level.vsmgr[type] thread [[level.vsmgr[type].update_cb]](localclientnum, type);
					level.vsmgr[type].state[localclientnum] transition_state();
				}
			}
		}
		wait(0.016);
	}
}

/*
	Name: killcam_visionset_vehicle_mismatch
	Namespace: visionset_mgr
	Checksum: 0x39CD7E95
	Offset: 0x23C8
	Size: 0x50
	Parameters: 3
	Flags: Linked
*/
function killcam_visionset_vehicle_mismatch(visionset_to, visionset_vehicle, vehicletype)
{
	if(visionset_to == visionset_vehicle)
	{
		if(isdefined(self.vehicletype) && self.vehicletype != vehicletype)
		{
			return true;
		}
	}
	return false;
}

/*
	Name: killcam_visionset_player_mismatch
	Namespace: visionset_mgr
	Checksum: 0xE5FC4891
	Offset: 0x2420
	Size: 0x3E
	Parameters: 2
	Flags: Linked
*/
function killcam_visionset_player_mismatch(visionset_to, visionset_vehicle)
{
	if(visionset_to == visionset_vehicle)
	{
		if(!self isplayer())
		{
			return true;
		}
	}
	return false;
}

/*
	Name: visionset_update_cb
	Namespace: visionset_mgr
	Checksum: 0x59C625C4
	Offset: 0x2468
	Size: 0x41C
	Parameters: 2
	Flags: Linked
*/
function visionset_update_cb(localclientnum, type)
{
	state = get_state(localclientnum, type);
	curr_info = get_info(type, state.curr_slot);
	prev_info = get_info(type, state.prev_slot);
	/#
	#/
	if(isdefined(level.isdemoplaying) && level.isdemoplaying && isspectating(localclientnum, 1))
	{
		visionsetnaked(localclientnum, level._fv2vs_default_visionset, 0);
		return;
	}
	if(level.vsmgr_default_info_name == curr_info.name)
	{
		fog_vol_to_visionset_force_instant_transition(localclientnum);
		return;
	}
	player = getlocalplayer(localclientnum);
	if(player getinkillcam(localclientnum))
	{
		if(isdefined(curr_info.visionset_to))
		{
			killcament = player getkillcamentity(localclientnum);
			if(curr_info.visionset_to == "mp_vehicles_mothership")
			{
				if(killcament.type == "vehicle" && !killcament clientfield::get("mothership"))
				{
					return;
				}
			}
			if(curr_info.visionset_to == "mp_vehicles_agr" || curr_info.visionset_to == "mp_hellstorm")
			{
				if(killcament.type == "vehicle")
				{
					return;
				}
			}
			if(killcament killcam_visionset_vehicle_mismatch(curr_info.visionset_to, "mp_vehicles_dart", "veh_dart_mp"))
			{
				return;
			}
			if(killcament killcam_visionset_player_mismatch(curr_info.visionset_to, "mp_vehicles_turret"))
			{
				return;
			}
			if(killcament killcam_visionset_player_mismatch(curr_info.visionset_to, "mp_vehicles_sentinel"))
			{
				return;
			}
		}
	}
	if(!isdefined(curr_info.visionset_from))
	{
		if(curr_info.visionset_type == 6)
		{
			visionsetlaststandlerp(localclientnum, curr_info.visionset_to, level._fv2vs_prev_visionsets[localclientnum], state.curr_lerp);
		}
		else
		{
			visionsetnakedlerp(localclientnum, curr_info.visionset_to, level._fv2vs_prev_visionsets[localclientnum], state.curr_lerp);
		}
	}
	else
	{
		if(curr_info.visionset_type == 6)
		{
			visionsetlaststandlerp(localclientnum, curr_info.visionset_to, curr_info.visionset_from, state.curr_lerp);
		}
		else
		{
			visionsetnakedlerp(localclientnum, curr_info.visionset_to, curr_info.visionset_from, state.curr_lerp);
		}
	}
}

/*
	Name: set_poison_overlay
	Namespace: visionset_mgr
	Checksum: 0xBFEEEEBA
	Offset: 0x2890
	Size: 0x12C
	Parameters: 1
	Flags: Linked
*/
function set_poison_overlay(amount)
{
	setdvar("r_poisonFX_debug_enable", 1);
	setdvar("r_poisonFX_pulse", 2);
	setdvar("r_poisonFX_warpX", -0.3);
	setdvar("r_poisonFX_warpY", 0.15);
	setdvar("r_poisonFX_dvisionA", 0);
	setdvar("r_poisonFX_dvisionX", 0);
	setdvar("r_poisonFX_dvisionY", 0);
	setdvar("r_poisonFX_blurMin", 0);
	setdvar("r_poisonFX_blurMax", 3);
	setdvar("r_poisonFX_debug_amount", amount);
}

/*
	Name: clear_poison_overlay
	Namespace: visionset_mgr
	Checksum: 0xAA1DE7FA
	Offset: 0x29C8
	Size: 0x34
	Parameters: 0
	Flags: Linked
*/
function clear_poison_overlay()
{
	setdvar("r_poisonFX_debug_amount", 0);
	setdvar("r_poisonFX_debug_enable", 0);
}

/*
	Name: overlay_update_cb
	Namespace: visionset_mgr
	Checksum: 0xD6F3EF8B
	Offset: 0x2A08
	Size: 0xA76
	Parameters: 2
	Flags: Linked
*/
function overlay_update_cb(localclientnum, type)
{
	state = get_state(localclientnum, type);
	curr_info = get_info(type, state.curr_slot);
	prev_info = get_info(type, state.prev_slot);
	player = level.localplayers[localclientnum];
	/#
	#/
	if(state.force_update || state.prev_slot != state.curr_slot)
	{
		switch(prev_info.style)
		{
			case 0:
			{
				break;
			}
			case 1:
			{
				player thread postfx::exitpostfxbundle();
				break;
			}
			case 2:
			{
				if(isdefined(level.vsmgr_filter_custom_disable[curr_info.material_name]))
				{
					player [[level.vsmgr_filter_custom_disable[curr_info.material_name]]](state, prev_info, curr_info);
				}
				else
				{
					setfilterpassenabled(localclientnum, prev_info.filter_index, prev_info.pass_index, 0);
				}
				break;
			}
			case 3:
			{
				setblurbylocalclientnum(localclientnum, 0, prev_info.transition_out);
				break;
			}
			case 4:
			{
				setelectrified(localclientnum, 0);
				break;
			}
			case 5:
			{
				setburn(localclientnum, 0);
				break;
			}
			case 6:
			{
				clear_poison_overlay();
				break;
			}
			case 7:
			{
				player thread postfx::exitpostfxbundle();
				break;
			}
			case 8:
			{
				disablespeedblur(localclientnum);
				break;
			}
		}
	}
	if(isdefined(level.isdemoplaying) && level.isdemoplaying && isspectating(localclientnum, 0))
	{
		return;
	}
	switch(curr_info.style)
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			if(state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp)
			{
				player thread postfx::playpostfxbundle(curr_info.bundle);
			}
			break;
		}
		case 2:
		{
			if(state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp != state.curr_lerp)
			{
				if(isdefined(level.vsmgr_filter_custom_enable[curr_info.material_name]))
				{
					player [[level.vsmgr_filter_custom_enable[curr_info.material_name]]](state, prev_info, curr_info);
				}
				else
				{
					setfilterpassmaterial(localclientnum, curr_info.filter_index, curr_info.pass_index, level.filter_matid[curr_info.material_name]);
					setfilterpassenabled(localclientnum, curr_info.filter_index, curr_info.pass_index, 1);
					if(isdefined(curr_info.constant_index))
					{
						setfilterpassconstant(localclientnum, curr_info.filter_index, curr_info.pass_index, curr_info.constant_index, state.curr_lerp);
					}
				}
			}
			break;
		}
		case 3:
		{
			if(state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp)
			{
				setblurbylocalclientnum(localclientnum, curr_info.magnitude, curr_info.transition_in);
			}
			break;
		}
		case 4:
		{
			if(state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp)
			{
				setelectrified(localclientnum, curr_info.duration * state.curr_lerp);
			}
			break;
		}
		case 5:
		{
			if(state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp)
			{
				setburn(localclientnum, curr_info.duration * state.curr_lerp);
			}
			break;
		}
		case 6:
		{
			if(state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp != state.curr_lerp)
			{
				set_poison_overlay(state.curr_lerp);
			}
			break;
		}
		case 7:
		{
			if(state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp)
			{
				level thread filter::settransported(player);
			}
			break;
		}
		case 8:
		{
			if(state.force_update || state.prev_slot != state.curr_slot || state.prev_lerp <= state.curr_lerp)
			{
				if(isdefined(curr_info.should_offset))
				{
					enablespeedblur(localclientnum, curr_info.amount, curr_info.inner_radius, curr_info.outer_radius, curr_info.velocity_should_scale, curr_info.velocity_scale, curr_info.blur_in, curr_info.blur_out, curr_info.should_offset);
				}
				else
				{
					if(isdefined(curr_info.blur_out))
					{
						enablespeedblur(localclientnum, curr_info.amount, curr_info.inner_radius, curr_info.outer_radius, curr_info.velocity_should_scale, curr_info.velocity_scale, curr_info.blur_in, curr_info.blur_out);
					}
					else
					{
						if(isdefined(curr_info.blur_in))
						{
							enablespeedblur(localclientnum, curr_info.amount, curr_info.inner_radius, curr_info.outer_radius, curr_info.velocity_should_scale, curr_info.velocity_scale, curr_info.blur_in);
						}
						else
						{
							if(isdefined(curr_info.velocity_scale))
							{
								enablespeedblur(localclientnum, curr_info.amount, curr_info.inner_radius, curr_info.outer_radius, curr_info.velocity_should_scale, curr_info.velocity_scale);
							}
							else
							{
								if(isdefined(curr_info.velocity_should_scale))
								{
									enablespeedblur(localclientnum, curr_info.amount, curr_info.inner_radius, curr_info.outer_radius, curr_info.velocity_should_scale);
								}
								else
								{
									enablespeedblur(localclientnum, curr_info.amount, curr_info.inner_radius, curr_info.outer_radius);
								}
							}
						}
					}
				}
			}
			break;
		}
	}
}

/*
	Name: init_fog_vol_to_visionset_monitor
	Namespace: visionset_mgr
	Checksum: 0x8B2FE1D4
	Offset: 0x3488
	Size: 0x16C
	Parameters: 3
	Flags: Linked
*/
function init_fog_vol_to_visionset_monitor(default_visionset, default_trans_in, host_migration_active)
{
	level._fv2vs_default_visionset = default_visionset;
	level._fv2vs_default_trans_in = default_trans_in;
	level._fv2vs_suffix = "";
	level._fv2vs_unset_visionset = "_fv2vs_unset";
	level._fv2vs_prev_visionsets = [];
	level._fv2vs_prev_visionsets[0] = level._fv2vs_unset_visionset;
	level._fv2vs_prev_visionsets[1] = level._fv2vs_unset_visionset;
	level._fv2vs_prev_visionsets[2] = level._fv2vs_unset_visionset;
	level._fv2vs_prev_visionsets[3] = level._fv2vs_unset_visionset;
	level._fv2vs_force_instant_transition = [];
	level._fv2vs_force_instant_transition[0] = 0;
	level._fv2vs_force_instant_transition[1] = 0;
	level._fv2vs_force_instant_transition[2] = 0;
	level._fv2vs_force_instant_transition[3] = 0;
	if(!isdefined(host_migration_active))
	{
		level._fv2vs_infos = [];
		fog_vol_to_visionset_set_info(-1, default_visionset, default_trans_in);
	}
	level._fv2vs_inited = 1;
	level thread fog_vol_to_visionset_monitor();
	level thread reset_player_fv2vs_infos_on_respawn();
}

/*
	Name: fog_vol_to_visionset_set_suffix
	Namespace: visionset_mgr
	Checksum: 0x5F7D0CC1
	Offset: 0x3600
	Size: 0x18
	Parameters: 1
	Flags: None
*/
function fog_vol_to_visionset_set_suffix(suffix)
{
	level._fv2vs_suffix = suffix;
}

/*
	Name: fog_vol_to_visionset_set_info
	Namespace: visionset_mgr
	Checksum: 0x12122729
	Offset: 0x3620
	Size: 0x8C
	Parameters: 3
	Flags: Linked
*/
function fog_vol_to_visionset_set_info(id, visionset, trans_in = level._fv2vs_default_trans_in)
{
	level._fv2vs_infos[id] = spawnstruct();
	level._fv2vs_infos[id].visionset = visionset;
	level._fv2vs_infos[id].trans_in = trans_in;
}

/*
	Name: fog_vol_to_visionset_force_instant_transition
	Namespace: visionset_mgr
	Checksum: 0x52B9A314
	Offset: 0x36B8
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function fog_vol_to_visionset_force_instant_transition(localclientnum)
{
	if(!(isdefined(level._fv2vs_inited) && level._fv2vs_inited))
	{
		return;
	}
	level._fv2vs_force_instant_transition[localclientnum] = 1;
}

/*
	Name: fog_vol_to_visionset_instant_transition_monitor
	Namespace: visionset_mgr
	Checksum: 0x5E59337F
	Offset: 0x36F8
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function fog_vol_to_visionset_instant_transition_monitor()
{
	level endon(#"hmo");
	level thread fog_vol_to_visionset_hostmigration_monitor();
	while(true)
	{
		level util::waittill_any("demo_jump", "demo_player_switch");
		/#
		#/
		players = getlocalplayers();
		for(localclientnum = 0; localclientnum < players.size; localclientnum++)
		{
			level._fv2vs_force_instant_transition[localclientnum] = 1;
		}
	}
}

/*
	Name: fog_vol_to_visionset_hostmigration_monitor
	Namespace: visionset_mgr
	Checksum: 0x7960E9F
	Offset: 0x37B8
	Size: 0x4E
	Parameters: 0
	Flags: Linked
*/
function fog_vol_to_visionset_hostmigration_monitor()
{
	level waittill(#"hmo");
	wait(3);
	/#
	#/
	init_fog_vol_to_visionset_monitor(level._fv2vs_default_visionset, level._fv2vs_default_trans_in, 1);
	wait(1);
	level notify(#"visionset_mgr_reset");
}

/*
	Name: fog_vol_to_visionset_monitor
	Namespace: visionset_mgr
	Checksum: 0x9285043F
	Offset: 0x3810
	Size: 0x23A
	Parameters: 0
	Flags: Linked
*/
function fog_vol_to_visionset_monitor()
{
	level endon(#"hmo");
	level thread fog_vol_to_visionset_instant_transition_monitor();
	was_not_in_default_type = [];
	was_not_in_default_type[0] = 0;
	was_not_in_default_type[1] = 0;
	was_not_in_default_type[2] = 0;
	was_not_in_default_type[3] = 0;
	while(true)
	{
		wait(0.016);
		waittillframeend();
		players = getlocalplayers();
		for(localclientnum = 0; localclientnum < players.size; localclientnum++)
		{
			if(!is_type_currently_default(localclientnum, "visionset"))
			{
				was_not_in_default_type[localclientnum] = 1;
				continue;
			}
			id = getworldfogscriptid(localclientnum);
			if(!isdefined(level._fv2vs_infos[id]))
			{
				id = -1;
			}
			new_visionset = level._fv2vs_infos[id].visionset + level._fv2vs_suffix;
			if(was_not_in_default_type[localclientnum] || level._fv2vs_prev_visionsets[localclientnum] != new_visionset || level._fv2vs_force_instant_transition[localclientnum])
			{
				/#
				#/
				trans = level._fv2vs_infos[id].trans_in;
				if(level._fv2vs_force_instant_transition[localclientnum])
				{
					/#
					#/
					trans = 0;
				}
				visionsetnaked(localclientnum, new_visionset, trans);
				level._fv2vs_prev_visionsets[localclientnum] = new_visionset;
			}
			level._fv2vs_force_instant_transition[localclientnum] = 0;
			was_not_in_default_type[localclientnum] = 0;
		}
	}
}

/*
	Name: reset_player_fv2vs_infos_on_respawn
	Namespace: visionset_mgr
	Checksum: 0xA7345636
	Offset: 0x3A58
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function reset_player_fv2vs_infos_on_respawn()
{
	level endon(#"hmo");
	while(true)
	{
		level waittill(#"respawn");
		players = getlocalplayers();
		for(localclientnum = 0; localclientnum < players.size; localclientnum++)
		{
			level._fv2vs_prev_visionsets[localclientnum] = level._fv2vs_unset_visionset;
		}
	}
}

