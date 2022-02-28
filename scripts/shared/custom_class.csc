// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\core\_multi_extracam;
#using scripts\shared\_character_customization;
#using scripts\shared\ai\archetype_damage_effects;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\zombie;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\util_shared;

#namespace customclass;

/*
	Name: localclientconnect
	Namespace: customclass
	Checksum: 0x9276F3AB
	Offset: 0x580
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function localclientconnect(localclientnum)
{
	level thread custom_class_init(localclientnum);
}

/*
	Name: init
	Namespace: customclass
	Checksum: 0x86D13E10
	Offset: 0x5B0
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function init()
{
	level.weapon_script_model = [];
	level.preload_weapon_model = [];
	level.last_weapon_name = [];
	level.current_weapon = [];
	level.attachment_names = [];
	level.attachment_indices = [];
	level.paintshophiddenposition = [];
	level.camo_index = [];
	level.reticle_index = [];
	level.show_player_tag = [];
	level.show_emblem = [];
	level.preload_weapon_complete = [];
	level.preload_weapon_complete = [];
	level.weapon_clientscript_cac_model = [];
	level.weaponnone = getweapon("none");
	level.weapon_position = struct::get("paintshop_weapon_position");
	duplicate_render::set_dr_filter_offscreen("cac_locked_weapon", 10, "cac_locked_weapon", undefined, 2, "mc/sonar_frontend_locked_gun", 1);
}

/*
	Name: custom_class_init
	Namespace: customclass
	Checksum: 0x6B4B9546
	Offset: 0x6E0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function custom_class_init(localclientnum)
{
	level.last_weapon_name[localclientnum] = "";
	level.current_weapon[localclientnum] = undefined;
	level thread custom_class_start_threads(localclientnum);
	level thread handle_cac_customization(localclientnum);
}

/*
	Name: custom_class_start_threads
	Namespace: customclass
	Checksum: 0x94EAAC47
	Offset: 0x750
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function custom_class_start_threads(localclientnum)
{
	level endon(#"disconnect");
	while(true)
	{
		level thread custom_class_update(localclientnum);
		level thread custom_class_attachment_select_focus(localclientnum);
		level thread custom_class_remove(localclientnum);
		level thread custom_class_closed(localclientnum);
		level util::waittill_any("CustomClass_update" + localclientnum, "CustomClass_focus" + localclientnum, "CustomClass_remove" + localclientnum, "CustomClass_closed" + localclientnum);
	}
}

/*
	Name: handle_cac_customization
	Namespace: customclass
	Checksum: 0xA92B3143
	Offset: 0x820
	Size: 0xBA
	Parameters: 1
	Flags: Linked
*/
function handle_cac_customization(localclientnum)
{
	level endon(#"disconnect");
	self.lastxcam = [];
	self.lastsubxcam = [];
	self.lastnotetrack = [];
	while(true)
	{
		level thread handle_cac_customization_focus(localclientnum);
		level thread handle_cac_customization_weaponoption(localclientnum);
		level thread handle_cac_customization_attachmentvariant(localclientnum);
		level thread handle_cac_customization_closed(localclientnum);
		level waittill("cam_customization_closed" + localclientnum);
	}
}

/*
	Name: custom_class_update
	Namespace: customclass
	Checksum: 0xA5071951
	Offset: 0x8E8
	Size: 0x3D4
	Parameters: 1
	Flags: Linked
*/
function custom_class_update(localclientnum)
{
	level endon(#"disconnect");
	level endon("CustomClass_focus" + localclientnum);
	level endon("CustomClass_remove" + localclientnum);
	level endon("CustomClass_closed" + localclientnum);
	level waittill("CustomClass_update" + localclientnum, param1, param2, param3, param4, param5, param6, param7);
	base_weapon_slot = param1;
	weapon_full_name = param2;
	camera = param3;
	weapon_options_param = param4;
	acv_param = param5;
	is_item_unlocked = param6;
	is_item_tokenlocked = param7;
	if(!isdefined(is_item_unlocked))
	{
		is_item_unlocked = 1;
	}
	if(!isdefined(is_item_tokenlocked))
	{
		is_item_tokenlocked = 0;
	}
	if(isdefined(weapon_full_name))
	{
		if(isdefined(acv_param) && acv_param != "none")
		{
			set_attachment_cosmetic_variants(localclientnum, acv_param);
		}
		if(isdefined(weapon_options_param) && weapon_options_param != "none")
		{
			set_weapon_options(localclientnum, weapon_options_param);
		}
		postfx::setfrontendstreamingoverlay(localclientnum, "cac", 1);
		position = level.weapon_position;
		if(!isdefined(level.weapon_script_model[localclientnum]))
		{
			level.weapon_script_model[localclientnum] = spawn_weapon_model(localclientnum, position.origin, position.angles);
			level.preload_weapon_model[localclientnum] = spawn_weapon_model(localclientnum, position.origin, position.angles);
			level.preload_weapon_model[localclientnum] hide();
		}
		toggle_locked_weapon_shader(localclientnum, is_item_unlocked);
		toggle_tokenlocked_weapon_shader(localclientnum, is_item_unlocked && is_item_tokenlocked);
		update_weapon_script_model(localclientnum, weapon_full_name, undefined, is_item_unlocked, is_item_tokenlocked);
		level notify(#"xcammoved");
		lerpduration = get_lerp_duration(camera);
		setup_paintshop_bg(localclientnum, camera);
		level transition_camera_immediate(localclientnum, base_weapon_slot, "cam_cac_weapon", "cam_cac", lerpduration, camera);
	}
	else if(isdefined(param1) && param1 == "purchased")
	{
		toggle_tokenlocked_weapon_shader(localclientnum, 0);
	}
}

/*
	Name: toggle_locked_weapon_shader
	Namespace: customclass
	Checksum: 0xE6833470
	Offset: 0xCC8
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function toggle_locked_weapon_shader(localclientnum, is_item_unlocked = 1)
{
	if(!isdefined(level.weapon_script_model[localclientnum]))
	{
		return;
	}
	if(is_item_unlocked != 1)
	{
		enablefrontendlockedweaponoverlay(localclientnum, 1);
	}
	else
	{
		enablefrontendlockedweaponoverlay(localclientnum, 0);
	}
}

/*
	Name: toggle_tokenlocked_weapon_shader
	Namespace: customclass
	Checksum: 0xE05208A5
	Offset: 0xD58
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function toggle_tokenlocked_weapon_shader(localclientnum, is_item_tokenlocked = 0)
{
	if(!isdefined(level.weapon_script_model[localclientnum]))
	{
		return;
	}
	if(is_item_tokenlocked)
	{
		enablefrontendtokenlockedweaponoverlay(localclientnum, 1);
	}
	else
	{
		enablefrontendtokenlockedweaponoverlay(localclientnum, 0);
	}
}

/*
	Name: is_optic
	Namespace: customclass
	Checksum: 0xB71F6687
	Offset: 0xDE0
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function is_optic(attachmentname)
{
	csv_filename = "gamedata/weapons/common/attachmentTable.csv";
	row = tablelookuprownum(csv_filename, 4, attachmentname);
	if(row > -1)
	{
		group = tablelookupcolumnforrow(csv_filename, row, 2);
		return group == "optic";
	}
	return 0;
}

/*
	Name: custom_class_attachment_select_focus
	Namespace: customclass
	Checksum: 0x43C1D25A
	Offset: 0xE78
	Size: 0x344
	Parameters: 1
	Flags: Linked
*/
function custom_class_attachment_select_focus(localclientnum)
{
	level endon(#"disconnect");
	level endon("CustomClass_update" + localclientnum);
	level endon("CustomClass_remove" + localclientnum);
	level endon("CustomClass_closed" + localclientnum);
	level waittill("CustomClass_focus" + localclientnum, param1, param2, param3, param4, param5, param6);
	level endon("CustomClass_focus" + localclientnum);
	base_weapon_slot = param1;
	weapon_full_name = param2;
	attachment = param3;
	weapon_options_param = param4;
	acv_param = param5;
	donotmovecamera = param6;
	update_weapon_options = 0;
	weaponattachmentintersection = get_attachments_intersection(level.last_weapon_name[localclientnum], weapon_full_name);
	if(isdefined(acv_param) && acv_param != "none")
	{
		set_attachment_cosmetic_variants(localclientnum, acv_param);
	}
	initialdelay = 0.3;
	lerpduration = 400;
	if(is_optic(attachment))
	{
		initialdelay = 0;
		lerpduration = 200;
	}
	preload_weapon_model(localclientnum, weaponattachmentintersection, update_weapon_options);
	wait_preload_weapon(localclientnum);
	update_weapon_script_model(localclientnum, weaponattachmentintersection, update_weapon_options);
	if(weapon_full_name == weaponattachmentintersection)
	{
		weapon_full_name = undefined;
	}
	if(isdefined(donotmovecamera) && donotmovecamera)
	{
		if(isdefined(weapon_full_name))
		{
			preload_weapon_model(localclientnum, weapon_full_name, 0);
			wait(initialdelay);
			wait_preload_weapon(localclientnum);
			update_weapon_script_model(localclientnum, weapon_full_name, 0);
		}
	}
	else
	{
		level thread transition_camera(localclientnum, base_weapon_slot, "cam_cac_attachments", "cam_cac", initialdelay, lerpduration, attachment, weapon_full_name);
	}
	if(isdefined(weapon_options_param) && weapon_options_param != "none")
	{
		set_weapon_options(localclientnum, weapon_options_param);
	}
}

/*
	Name: custom_class_remove
	Namespace: customclass
	Checksum: 0x648093A7
	Offset: 0x11C8
	Size: 0x1D2
	Parameters: 1
	Flags: Linked
*/
function custom_class_remove(localclientnum)
{
	level endon(#"disconnect");
	level endon("CustomClass_update" + localclientnum);
	level endon("CustomClass_focus" + localclientnum);
	level endon("CustomClass_closed" + localclientnum);
	level waittill("CustomClass_remove" + localclientnum, param1, param2, param3, param4, param5, param6);
	postfx::setfrontendstreamingoverlay(localclientnum, "cac", 0);
	enablefrontendlockedweaponoverlay(localclientnum, 0);
	enablefrontendtokenlockedweaponoverlay(localclientnum, 0);
	position = level.weapon_position;
	camera = "select01";
	xcamname = "ui_cam_cac_ar_standard";
	playmaincamxcam(localclientnum, xcamname, 0, "cam_cac", camera, position.origin, position.angles);
	setup_paintshop_bg(localclientnum, camera);
	if(isdefined(level.weapon_script_model[localclientnum]))
	{
		level.weapon_script_model[localclientnum] forcedelete();
	}
	level.last_weapon_name[localclientnum] = "";
}

/*
	Name: custom_class_closed
	Namespace: customclass
	Checksum: 0x1A54D780
	Offset: 0x13A8
	Size: 0x13A
	Parameters: 1
	Flags: Linked
*/
function custom_class_closed(localclientnum)
{
	level endon(#"disconnect");
	level endon("CustomClass_update" + localclientnum);
	level endon("CustomClass_focus" + localclientnum);
	level endon("CustomClass_remove" + localclientnum);
	level waittill("CustomClass_closed" + localclientnum, param1, param2, param3, param4, param5, param6);
	if(isdefined(level.weapon_script_model[localclientnum]))
	{
		level.weapon_script_model[localclientnum] forcedelete();
	}
	postfx::setfrontendstreamingoverlay(localclientnum, "cac", 0);
	enablefrontendlockedweaponoverlay(localclientnum, 0);
	enablefrontendtokenlockedweaponoverlay(localclientnum, 0);
	level.last_weapon_name[localclientnum] = "";
}

/*
	Name: spawn_weapon_model
	Namespace: customclass
	Checksum: 0xEEDD8DAB
	Offset: 0x14F0
	Size: 0x84
	Parameters: 3
	Flags: Linked
*/
function spawn_weapon_model(localclientnum, origin, angles)
{
	weapon_model = spawn(localclientnum, origin, "script_model");
	weapon_model sethighdetail(1, 1);
	if(isdefined(angles))
	{
		weapon_model.angles = angles;
	}
	return weapon_model;
}

/*
	Name: set_attachment_cosmetic_variants
	Namespace: customclass
	Checksum: 0xB2EF07EE
	Offset: 0x1580
	Size: 0x108
	Parameters: 2
	Flags: Linked
*/
function set_attachment_cosmetic_variants(localclientnum, acv_param)
{
	acv_indexes = strtok(acv_param, ",");
	level.attachment_names[localclientnum] = [];
	level.attachment_indices[localclientnum] = [];
	i = 0;
	while((i + 1) < acv_indexes.size)
	{
		level.attachment_names[localclientnum][level.attachment_names[localclientnum].size] = acv_indexes[i];
		level.attachment_indices[localclientnum][level.attachment_indices[localclientnum].size] = int(acv_indexes[i + 1]);
		i = i + 2;
	}
}

/*
	Name: hide_paintshop_bg
	Namespace: customclass
	Checksum: 0x5F20B684
	Offset: 0x1690
	Size: 0xC4
	Parameters: 1
	Flags: Linked
*/
function hide_paintshop_bg(localclientnum)
{
	paintshop_bg = getent(localclientnum, "paintshop_black", "targetname");
	if(isdefined(paintshop_bg))
	{
		if(!isdefined(level.paintshophiddenposition[localclientnum]))
		{
			level.paintshophiddenposition[localclientnum] = paintshop_bg.origin;
		}
		paintshop_bg hide();
		paintshop_bg moveto(level.paintshophiddenposition[localclientnum], 0.01);
	}
}

/*
	Name: show_paintshop_bg
	Namespace: customclass
	Checksum: 0x9B49EF47
	Offset: 0x1760
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function show_paintshop_bg(localclientnum)
{
	paintshop_bg = getent(localclientnum, "paintshop_black", "targetname");
	if(isdefined(paintshop_bg))
	{
		paintshop_bg show();
		paintshop_bg moveto(level.paintshophiddenposition[localclientnum] + vectorscale((0, 0, 1), 227), 0.01);
	}
}

/*
	Name: get_camo_index
	Namespace: customclass
	Checksum: 0x1446350E
	Offset: 0x1808
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function get_camo_index(localclientnum)
{
	if(!isdefined(level.camo_index[localclientnum]))
	{
		level.camo_index[localclientnum] = 0;
	}
	return level.camo_index[localclientnum];
}

/*
	Name: get_reticle_index
	Namespace: customclass
	Checksum: 0xCFD735D9
	Offset: 0x1850
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function get_reticle_index(localclientnum)
{
	if(!isdefined(level.reticle_index[localclientnum]))
	{
		level.reticle_index[localclientnum] = 0;
	}
	return level.reticle_index[localclientnum];
}

/*
	Name: get_show_payer_tag
	Namespace: customclass
	Checksum: 0x9E65D4B5
	Offset: 0x1898
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function get_show_payer_tag(localclientnum)
{
	if(!isdefined(level.show_player_tag[localclientnum]))
	{
		level.show_player_tag[localclientnum] = 0;
	}
	return level.show_player_tag[localclientnum];
}

/*
	Name: get_show_emblem
	Namespace: customclass
	Checksum: 0x2F13A37
	Offset: 0x18E0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function get_show_emblem(localclientnum)
{
	if(!isdefined(level.show_emblem[localclientnum]))
	{
		level.show_emblem[localclientnum] = 0;
	}
	return level.show_emblem[localclientnum];
}

/*
	Name: get_show_paintshop
	Namespace: customclass
	Checksum: 0xF03ABBD5
	Offset: 0x1928
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function get_show_paintshop(localclientnum)
{
	if(!isdefined(level.show_paintshop[localclientnum]))
	{
		level.show_paintshop[localclientnum] = 0;
	}
	return level.show_paintshop[localclientnum];
}

/*
	Name: set_weapon_options
	Namespace: customclass
	Checksum: 0x3CD10E22
	Offset: 0x1970
	Size: 0x18C
	Parameters: 2
	Flags: Linked
*/
function set_weapon_options(localclientnum, weapon_options_param)
{
	weapon_options = strtok(weapon_options_param, ",");
	level.camo_index[localclientnum] = int(weapon_options[0]);
	level.show_player_tag[localclientnum] = 0;
	level.show_emblem[localclientnum] = 0;
	level.reticle_index[localclientnum] = int(weapon_options[1]);
	level.show_paintshop[localclientnum] = int(weapon_options[2]);
	if(isdefined(weapon_options) && isdefined(level.weapon_script_model[localclientnum]))
	{
		level.weapon_script_model[localclientnum] setweaponrenderoptions(get_camo_index(localclientnum), get_reticle_index(localclientnum), get_show_payer_tag(localclientnum), get_show_emblem(localclientnum), get_show_paintshop(localclientnum));
	}
}

/*
	Name: get_lerp_duration
	Namespace: customclass
	Checksum: 0x7B9A907F
	Offset: 0x1B08
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function get_lerp_duration(camera)
{
	lerpduration = 0;
	if(isdefined(camera))
	{
		paintshopcameracloseup = camera == "left" || camera == "right" || camera == "top" || camera == "paintshop_preview_left" || camera == "paintshop_preview_right" || camera == "paintshop_preview_top";
		if(paintshopcameracloseup)
		{
			lerpduration = 500;
		}
	}
	return lerpduration;
}

/*
	Name: setup_paintshop_bg
	Namespace: customclass
	Checksum: 0x70878526
	Offset: 0x1BB8
	Size: 0x19C
	Parameters: 2
	Flags: Linked
*/
function setup_paintshop_bg(localclientnum, camera)
{
	if(isdefined(camera))
	{
		paintshopcameracloseup = camera == "left" || camera == "right" || camera == "top" || camera == "paintshop_preview_left" || camera == "paintshop_preview_right" || camera == "paintshop_preview_top";
		playradiantexploder(localclientnum, "weapon_kick");
		if(paintshopcameracloseup)
		{
			show_paintshop_bg(localclientnum);
			killradiantexploder(localclientnum, "lights_paintshop");
			killradiantexploder(localclientnum, "weapon_kick");
			playradiantexploder(localclientnum, "lights_paintshop_zoom");
		}
		else
		{
			hide_paintshop_bg(localclientnum);
			killradiantexploder(localclientnum, "lights_paintshop_zoom");
			playradiantexploder(localclientnum, "lights_paintshop");
			playradiantexploder(localclientnum, "weapon_kick");
		}
	}
}

/*
	Name: transition_camera_immediate
	Namespace: customclass
	Checksum: 0xBB8CE4E7
	Offset: 0x1D60
	Size: 0x28C
	Parameters: 6
	Flags: Linked
*/
function transition_camera_immediate(localclientnum, weapontype, camera, subxcam, lerpduration, notetrack)
{
	xcam = getweaponxcam(level.current_weapon[localclientnum], camera);
	if(!isdefined(xcam))
	{
		if(strstartswith(weapontype, "specialty"))
		{
			xcam = "ui_cam_cac_perk";
		}
		else
		{
			if(strstartswith(weapontype, "bonuscard"))
			{
				xcam = "ui_cam_cac_wildcard";
			}
			else
			{
				if(strstartswith(weapontype, "cybercore") || strstartswith(weapontype, "cybercom"))
				{
					xcam = "ui_cam_cac_perk";
				}
				else
				{
					if(strstartswith(weapontype, "bubblegum"))
					{
						xcam = "ui_cam_cac_bgb";
					}
					else
					{
						xcam = getweaponxcam(getweapon("ar_standard"), camera);
					}
				}
			}
		}
	}
	self.lastxcam[weapontype] = xcam;
	self.lastsubxcam[weapontype] = subxcam;
	self.lastnotetrack[weapontype] = notetrack;
	position = level.weapon_position;
	model = level.weapon_script_model[localclientnum];
	playmaincamxcam(localclientnum, xcam, lerpduration, subxcam, notetrack, position.origin, position.angles, model, position.origin, position.angles);
	if(notetrack == "top" || notetrack == "right" || notetrack == "left")
	{
		setallowxcamrightstickrotation(localclientnum, 0);
	}
}

/*
	Name: wait_preload_weapon
	Namespace: customclass
	Checksum: 0xFF1D246D
	Offset: 0x1FF8
	Size: 0x32
	Parameters: 1
	Flags: Linked
*/
function wait_preload_weapon(localclientnum)
{
	if(level.preload_weapon_complete[localclientnum])
	{
		return;
	}
	level waittill("preload_weapon_complete_" + localclientnum);
}

/*
	Name: preload_weapon_watcher
	Namespace: customclass
	Checksum: 0x37D959D2
	Offset: 0x2038
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function preload_weapon_watcher(localclientnum)
{
	level endon("preload_weapon_changing_" + localclientnum);
	level endon("preload_weapon_complete_" + localclientnum);
	while(true)
	{
		if(level.preload_weapon_model[localclientnum] isstreamed())
		{
			level.preload_weapon_complete[localclientnum] = 1;
			level notify("preload_weapon_complete_" + localclientnum);
			return;
		}
		wait(0.1);
	}
}

/*
	Name: preload_weapon_model
	Namespace: customclass
	Checksum: 0x5670F520
	Offset: 0x20D0
	Size: 0x2FC
	Parameters: 3
	Flags: Linked
*/
function preload_weapon_model(localclientnum, newweaponstring, should_update_weapon_options = 1)
{
	level notify("preload_weapon_changing_" + localclientnum);
	level.preload_weapon_complete[localclientnum] = 0;
	current_weapon = getweaponwithattachments(newweaponstring);
	if(current_weapon == level.weaponnone)
	{
		level.preload_weapon_complete[localclientnum] = 1;
		level notify("preload_weapon_complete_" + localclientnum);
		return;
	}
	if(isdefined(current_weapon.frontendmodel))
	{
		/#
			println((("" + current_weapon.name) + "") + current_weapon.frontendmodel);
		#/
		level.preload_weapon_model[localclientnum] useweaponmodel(current_weapon, current_weapon.frontendmodel);
	}
	else
	{
		/#
			println("" + current_weapon.name);
		#/
		level.preload_weapon_model[localclientnum] useweaponmodel(current_weapon);
	}
	if(isdefined(level.preload_weapon_model[localclientnum]))
	{
		if(isdefined(level.attachment_names[localclientnum]) && isdefined(level.attachment_indices[localclientnum]))
		{
			for(i = 0; i < level.attachment_names[localclientnum].size; i++)
			{
				level.preload_weapon_model[localclientnum] setattachmentcosmeticvariantindex(newweaponstring, level.attachment_names[localclientnum][i], level.attachment_indices[localclientnum][i]);
			}
		}
		if(should_update_weapon_options)
		{
			level.preload_weapon_model[localclientnum] setweaponrenderoptions(get_camo_index(localclientnum), get_reticle_index(localclientnum), get_show_payer_tag(localclientnum), get_show_emblem(localclientnum), get_show_paintshop(localclientnum));
		}
	}
	level thread preload_weapon_watcher(localclientnum);
}

/*
	Name: update_weapon_script_model
	Namespace: customclass
	Checksum: 0xC490E1F1
	Offset: 0x23D8
	Size: 0x474
	Parameters: 5
	Flags: Linked
*/
function update_weapon_script_model(localclientnum, newweaponstring, should_update_weapon_options = 1, is_item_unlocked = 1, is_item_tokenlocked = 0)
{
	level.last_weapon_name[localclientnum] = newweaponstring;
	level.current_weapon[localclientnum] = getweaponwithattachments(level.last_weapon_name[localclientnum]);
	if(level.current_weapon[localclientnum] == level.weaponnone)
	{
		level.weapon_script_model[localclientnum] delete();
		position = level.weapon_position;
		level.weapon_script_model[localclientnum] = spawn_weapon_model(localclientnum, position.origin, position.angles);
		toggle_locked_weapon_shader(localclientnum, is_item_unlocked);
		toggle_tokenlocked_weapon_shader(localclientnum, is_item_unlocked && is_item_tokenlocked);
		level.weapon_script_model[localclientnum] setmodel(level.last_weapon_name[localclientnum]);
		level.weapon_script_model[localclientnum] setdedicatedshadow(1);
		return;
	}
	if(isdefined(level.current_weapon[localclientnum].frontendmodel))
	{
		/#
			println((("" + level.current_weapon[localclientnum].name) + "") + level.current_weapon[localclientnum].frontendmodel);
		#/
		level.weapon_script_model[localclientnum] useweaponmodel(level.current_weapon[localclientnum], level.current_weapon[localclientnum].frontendmodel);
	}
	else
	{
		/#
			println("" + level.current_weapon[localclientnum].name);
		#/
		level.weapon_script_model[localclientnum] useweaponmodel(level.current_weapon[localclientnum]);
	}
	if(isdefined(level.weapon_script_model[localclientnum]))
	{
		if(isdefined(level.attachment_names[localclientnum]) && isdefined(level.attachment_indices[localclientnum]))
		{
			for(i = 0; i < level.attachment_names[localclientnum].size; i++)
			{
				level.weapon_script_model[localclientnum] setattachmentcosmeticvariantindex(newweaponstring, level.attachment_names[localclientnum][i], level.attachment_indices[localclientnum][i]);
			}
		}
		if(should_update_weapon_options)
		{
			level.weapon_script_model[localclientnum] setweaponrenderoptions(get_camo_index(localclientnum), get_reticle_index(localclientnum), get_show_payer_tag(localclientnum), get_show_emblem(localclientnum), get_show_paintshop(localclientnum));
		}
	}
	level.weapon_script_model[localclientnum] setdedicatedshadow(1);
}

/*
	Name: transition_camera
	Namespace: customclass
	Checksum: 0x12E5E38
	Offset: 0x2858
	Size: 0x134
	Parameters: 9
	Flags: Linked
*/
function transition_camera(localclientnum, weapontype, camera, subxcam, initialdelay, lerpduration, notetrack, newweaponstring, should_update_weapon_options = 0)
{
	self endon(#"entityshutdown");
	self notify(#"xcammoved");
	self endon(#"xcammoved");
	level endon(#"cam_customization_closed");
	if(isdefined(newweaponstring))
	{
		preload_weapon_model(localclientnum, newweaponstring, should_update_weapon_options);
	}
	wait(initialdelay);
	transition_camera_immediate(localclientnum, weapontype, camera, subxcam, lerpduration, notetrack);
	if(isdefined(newweaponstring))
	{
		wait(lerpduration / 1000);
		wait_preload_weapon(localclientnum);
		update_weapon_script_model(localclientnum, newweaponstring, should_update_weapon_options);
	}
}

/*
	Name: get_attachments_intersection
	Namespace: customclass
	Checksum: 0x89325B4D
	Offset: 0x2998
	Size: 0x11C
	Parameters: 2
	Flags: Linked
*/
function get_attachments_intersection(oldweapon, newweapon)
{
	if(!isdefined(oldweapon))
	{
		return newweapon;
	}
	oldweaponparams = strtok(oldweapon, "+");
	newweaponparams = strtok(newweapon, "+");
	if(oldweaponparams[0] != newweaponparams[0])
	{
		return newweapon;
	}
	newweaponstring = newweaponparams[0];
	for(i = 1; i < newweaponparams.size; i++)
	{
		if(isinarray(oldweaponparams, newweaponparams[i]))
		{
			newweaponstring = newweaponstring + (("+") + newweaponparams[i]);
		}
	}
	return newweaponstring;
}

/*
	Name: handle_cac_customization_focus
	Namespace: customclass
	Checksum: 0xD249EC2B
	Offset: 0x2AC0
	Size: 0xF8
	Parameters: 1
	Flags: Linked
*/
function handle_cac_customization_focus(localclientnum)
{
	level endon(#"disconnect");
	level endon("cam_customization_closed" + localclientnum);
	while(true)
	{
		level waittill("cam_customization_focus" + localclientnum, param1, param2);
		base_weapon_slot = param1;
		notetrack = param2;
		if(isdefined(level.weapon_script_model[localclientnum]))
		{
			should_update_weapon_options = 1;
			level thread transition_camera(localclientnum, base_weapon_slot, "cam_cac_weapon", "cam_cac", 0.3, 400, notetrack, level.last_weapon_name[localclientnum], should_update_weapon_options);
		}
	}
}

/*
	Name: handle_cac_customization_weaponoption
	Namespace: customclass
	Checksum: 0x1C1A08F1
	Offset: 0x2BC0
	Size: 0x1E0
	Parameters: 1
	Flags: Linked
*/
function handle_cac_customization_weaponoption(localclientnum)
{
	level endon(#"disconnect");
	level endon("cam_customization_closed" + localclientnum);
	while(true)
	{
		level waittill("cam_customization_wo" + localclientnum, weapon_option, weapon_option_new_index, is_item_locked);
		if(isdefined(level.weapon_script_model[localclientnum]))
		{
			if(isdefined(is_item_locked) && is_item_locked)
			{
				weapon_option_new_index = 0;
			}
			switch(weapon_option)
			{
				case "camo":
				{
					level.camo_index[localclientnum] = int(weapon_option_new_index);
					break;
				}
				case "reticle":
				{
					level.reticle_index[localclientnum] = int(weapon_option_new_index);
					break;
				}
				case "paintjob":
				{
					level.show_paintshop[localclientnum] = int(weapon_option_new_index);
					break;
				}
				default:
				{
					break;
				}
			}
			level.weapon_script_model[localclientnum] setweaponrenderoptions(get_camo_index(localclientnum), get_reticle_index(localclientnum), get_show_payer_tag(localclientnum), get_show_emblem(localclientnum), get_show_paintshop(localclientnum));
		}
	}
}

/*
	Name: handle_cac_customization_attachmentvariant
	Namespace: customclass
	Checksum: 0x8F953D29
	Offset: 0x2DA8
	Size: 0x138
	Parameters: 1
	Flags: Linked
*/
function handle_cac_customization_attachmentvariant(localclientnum)
{
	level endon(#"disconnect");
	level endon("cam_customization_closed" + localclientnum);
	while(true)
	{
		level waittill("cam_customization_acv" + localclientnum, weapon_attachment_name, acv_index);
		for(i = 0; i < level.attachment_names[localclientnum].size; i++)
		{
			if(level.attachment_names[localclientnum][i] == weapon_attachment_name)
			{
				level.attachment_indices[localclientnum][i] = int(acv_index);
				break;
			}
		}
		if(isdefined(level.weapon_script_model[localclientnum]))
		{
			level.weapon_script_model[localclientnum] setattachmentcosmeticvariantindex(level.last_weapon_name[localclientnum], weapon_attachment_name, int(acv_index));
		}
	}
}

/*
	Name: handle_cac_customization_closed
	Namespace: customclass
	Checksum: 0x1B7053D2
	Offset: 0x2EE8
	Size: 0x1BE
	Parameters: 1
	Flags: Linked
*/
function handle_cac_customization_closed(localclientnum)
{
	level endon(#"disconnect");
	level waittill("cam_customization_closed" + localclientnum, param1, param2, param3, param4);
	if(isdefined(level.weapon_clientscript_cac_model[localclientnum]) && isdefined(level.weapon_clientscript_cac_model[localclientnum][level.loadout_slot_name]))
	{
		level.weapon_clientscript_cac_model[localclientnum][level.loadout_slot_name] setweaponrenderoptions(get_camo_index(localclientnum), get_reticle_index(localclientnum), get_show_payer_tag(localclientnum), get_show_emblem(localclientnum), get_show_paintshop(localclientnum));
		for(i = 0; i < level.attachment_names[localclientnum].size; i++)
		{
			level.weapon_clientscript_cac_model[localclientnum][level.loadout_slot_name] setattachmentcosmeticvariantindex(level.last_weapon_name[localclientnum], level.attachment_names[localclientnum][i], level.attachment_indices[localclientnum][i]);
		}
	}
}

