// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\core\_multi_extracam;
#using scripts\shared\_character_customization;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("all_player");

#namespace lui;

/*
	Name: __init__sytem__
	Namespace: lui
	Checksum: 0x9856002
	Offset: 0x228
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("lui_shared", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: lui
	Checksum: 0x16B8AC5F
	Offset: 0x268
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.client_menus = associativearray();
	callback::on_localclient_connect(&on_player_connect);
}

/*
	Name: on_player_connect
	Namespace: lui
	Checksum: 0xA0D86AC1
	Offset: 0x2B0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function on_player_connect(localclientnum)
{
	level thread client_menus(localclientnum);
}

/*
	Name: initmenudata
	Namespace: lui
	Checksum: 0x98E37B12
	Offset: 0x2E0
	Size: 0x52
	Parameters: 1
	Flags: Linked
*/
function initmenudata(localclientnum)
{
	/#
		assert(!isdefined(level.client_menus[localclientnum]));
	#/
	level.client_menus[localclientnum] = associativearray();
}

/*
	Name: createextracamxcamdata
	Namespace: lui
	Checksum: 0xD3BB87F4
	Offset: 0x340
	Size: 0x1A6
	Parameters: 7
	Flags: None
*/
function createextracamxcamdata(menu_name, localclientnum, extracam_index, target_name, xcam, sub_xcam, xcam_frame)
{
	/#
		assert(isdefined(level.client_menus[localclientnum][menu_name]));
	#/
	menu_data = level.client_menus[localclientnum][menu_name];
	extracam_data = spawnstruct();
	extracam_data.extracam_index = extracam_index;
	extracam_data.target_name = target_name;
	extracam_data.xcam = xcam;
	extracam_data.sub_xcam = sub_xcam;
	extracam_data.xcam_frame = xcam_frame;
	if(!isdefined(menu_data.extra_cams))
	{
		menu_data.extra_cams = [];
	}
	else if(!isarray(menu_data.extra_cams))
	{
		menu_data.extra_cams = array(menu_data.extra_cams);
	}
	menu_data.extra_cams[menu_data.extra_cams.size] = extracam_data;
}

/*
	Name: createcustomextracamxcamdata
	Namespace: lui
	Checksum: 0x886A3FCE
	Offset: 0x4F0
	Size: 0x14E
	Parameters: 4
	Flags: Linked
*/
function createcustomextracamxcamdata(menu_name, localclientnum, extracam_index, camera_function)
{
	/#
		assert(isdefined(level.client_menus[localclientnum][menu_name]));
	#/
	menu_data = level.client_menus[localclientnum][menu_name];
	extracam_data = spawnstruct();
	extracam_data.extracam_index = extracam_index;
	extracam_data.camera_function = camera_function;
	if(!isdefined(menu_data.extra_cams))
	{
		menu_data.extra_cams = [];
	}
	else if(!isarray(menu_data.extra_cams))
	{
		menu_data.extra_cams = array(menu_data.extra_cams);
	}
	menu_data.extra_cams[menu_data.extra_cams.size] = extracam_data;
}

/*
	Name: addmenuexploders
	Namespace: lui
	Checksum: 0xDF29C4B5
	Offset: 0x648
	Size: 0x226
	Parameters: 3
	Flags: Linked
*/
function addmenuexploders(menu_name, localclientnum, exploder)
{
	/#
		assert(isdefined(level.client_menus[localclientnum][menu_name]));
	#/
	menu_data = level.client_menus[localclientnum][menu_name];
	if(isarray(exploder))
	{
		foreach(expl in exploder)
		{
			if(!isdefined(menu_data.exploders))
			{
				menu_data.exploders = [];
			}
			else if(!isarray(menu_data.exploders))
			{
				menu_data.exploders = array(menu_data.exploders);
			}
			menu_data.exploders[menu_data.exploders.size] = expl;
		}
	}
	else
	{
		if(!isdefined(menu_data.exploders))
		{
			menu_data.exploders = [];
		}
		else if(!isarray(menu_data.exploders))
		{
			menu_data.exploders = array(menu_data.exploders);
		}
		menu_data.exploders[menu_data.exploders.size] = exploder;
	}
}

/*
	Name: linktocustomcharacter
	Namespace: lui
	Checksum: 0x22739EAE
	Offset: 0x878
	Size: 0x154
	Parameters: 3
	Flags: Linked
*/
function linktocustomcharacter(menu_name, localclientnum, target_name)
{
	/#
		assert(isdefined(level.client_menus[localclientnum][menu_name]));
	#/
	menu_data = level.client_menus[localclientnum][menu_name];
	/#
		assert(!isdefined(menu_data.custom_character));
	#/
	model = getent(localclientnum, target_name, "targetname");
	if(!isdefined(model))
	{
		model = util::spawn_model(localclientnum, "tag_origin");
		model.targetname = target_name;
	}
	model useanimtree($all_player);
	menu_data.custom_character = character_customization::create_character_data_struct(model, localclientnum);
	model hide();
}

/*
	Name: getcharacterdataformenu
	Namespace: lui
	Checksum: 0xDC1C6DD2
	Offset: 0x9D8
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function getcharacterdataformenu(menu_name, localclientnum)
{
	if(isdefined(level.client_menus[localclientnum][menu_name]))
	{
		return level.client_menus[localclientnum][menu_name].custom_character;
	}
	return undefined;
}

/*
	Name: createcameramenu
	Namespace: lui
	Checksum: 0xD6CBF158
	Offset: 0xA30
	Size: 0x164
	Parameters: 8
	Flags: Linked
*/
function createcameramenu(menu_name, localclientnum, target_name, xcam, sub_xcam, xcam_frame = undefined, custom_open_fn = undefined, custom_close_fn = undefined)
{
	/#
		assert(!isdefined(level.client_menus[localclientnum][menu_name]));
	#/
	level.client_menus[localclientnum][menu_name] = spawnstruct();
	menu_data = level.client_menus[localclientnum][menu_name];
	menu_data.target_name = target_name;
	menu_data.xcam = xcam;
	menu_data.sub_xcam = sub_xcam;
	menu_data.xcam_frame = xcam_frame;
	menu_data.custom_open_fn = custom_open_fn;
	menu_data.custom_close_fn = custom_close_fn;
	return menu_data;
}

/*
	Name: createcustomcameramenu
	Namespace: lui
	Checksum: 0x594A6769
	Offset: 0xBA0
	Size: 0x11C
	Parameters: 6
	Flags: Linked
*/
function createcustomcameramenu(menu_name, localclientnum, camera_function, has_state, custom_open_fn = undefined, custom_close_fn = undefined)
{
	/#
		assert(!isdefined(level.client_menus[localclientnum][menu_name]));
	#/
	level.client_menus[localclientnum][menu_name] = spawnstruct();
	menu_data = level.client_menus[localclientnum][menu_name];
	menu_data.camera_function = camera_function;
	menu_data.has_state = has_state;
	menu_data.custom_open_fn = custom_open_fn;
	menu_data.custom_close_fn = custom_close_fn;
	return menu_data;
}

/*
	Name: setup_menu
	Namespace: lui
	Checksum: 0x7F3F05D1
	Offset: 0xCC8
	Size: 0x86A
	Parameters: 3
	Flags: Linked
*/
function setup_menu(localclientnum, menu_data, previous_menu)
{
	if(isdefined(previous_menu) && isdefined(level.client_menus[localclientnum][previous_menu.menu_name]))
	{
		previous_menu_info = level.client_menus[localclientnum][previous_menu.menu_name];
		if(isdefined(previous_menu_info.custom_close_fn))
		{
			if(isarray(previous_menu_info.custom_close_fn))
			{
				foreach(fn in previous_menu_info.custom_close_fn)
				{
					[[fn]](localclientnum, previous_menu_info);
				}
			}
			else
			{
				[[previous_menu_info.custom_close_fn]](localclientnum, previous_menu_info);
			}
		}
		if(isdefined(previous_menu_info.extra_cams))
		{
			foreach(extracam_data in previous_menu_info.extra_cams)
			{
				multi_extracam::extracam_reset_index(localclientnum, extracam_data.extracam_index);
			}
		}
		level notify(previous_menu.menu_name + "_closed");
		if(isdefined(previous_menu_info.camera_function))
		{
			stopmaincamxcam(localclientnum);
		}
		else if(isdefined(previous_menu_info.xcam))
		{
			stopmaincamxcam(localclientnum);
		}
		if(isdefined(previous_menu_info.custom_character))
		{
			previous_menu_info.custom_character.charactermodel hide();
		}
		if(isdefined(previous_menu_info.exploders))
		{
			foreach(exploder in previous_menu_info.exploders)
			{
				killradiantexploder(localclientnum, exploder);
			}
		}
	}
	if(isdefined(menu_data) && isdefined(level.client_menus[localclientnum][menu_data.menu_name]))
	{
		new_menu = level.client_menus[localclientnum][menu_data.menu_name];
		if(isdefined(new_menu.custom_character))
		{
			new_menu.custom_character.charactermodel show();
		}
		if(isdefined(new_menu.exploders))
		{
			foreach(exploder in new_menu.exploders)
			{
				playradiantexploder(localclientnum, exploder);
			}
		}
		if(isdefined(new_menu.camera_function))
		{
			if(new_menu.has_state === 1)
			{
				level thread [[new_menu.camera_function]](localclientnum, menu_data.menu_name, menu_data.state);
			}
			else
			{
				level thread [[new_menu.camera_function]](localclientnum, menu_data.menu_name);
			}
		}
		else if(isdefined(new_menu.xcam))
		{
			camera_ent = struct::get(new_menu.target_name);
			if(isdefined(camera_ent))
			{
				playmaincamxcam(localclientnum, new_menu.xcam, 0, new_menu.sub_xcam, "", camera_ent.origin, camera_ent.angles);
			}
		}
		if(isdefined(new_menu.custom_open_fn))
		{
			if(isarray(new_menu.custom_open_fn))
			{
				foreach(fn in new_menu.custom_open_fn)
				{
					[[fn]](localclientnum, new_menu);
				}
			}
			else
			{
				[[new_menu.custom_open_fn]](localclientnum, new_menu);
			}
		}
		if(isdefined(new_menu.extra_cams))
		{
			foreach(extracam_data in new_menu.extra_cams)
			{
				if(isdefined(extracam_data.camera_function))
				{
					if(new_menu.has_state === 1)
					{
						level thread [[extracam_data.camera_function]](localclientnum, menu_data.menu_name, extracam_data, menu_data.state);
					}
					else
					{
						level thread [[extracam_data.camera_function]](localclientnum, menu_data.menu_name, extracam_data);
					}
					continue;
				}
				camera_ent = multi_extracam::extracam_init_index(localclientnum, extracam_data.target_name, extracam_data.extracam_index);
				if(isdefined(camera_ent))
				{
					if(isdefined(extracam_data.xcam_frame))
					{
						camera_ent playextracamxcam(extracam_data.xcam, 0, extracam_data.sub_xcam, extracam_data.xcam_frame);
						continue;
					}
					camera_ent playextracamxcam(extracam_data.xcam, 0, extracam_data.sub_xcam);
				}
			}
		}
	}
}

/*
	Name: client_menus
	Namespace: lui
	Checksum: 0x9A1959C6
	Offset: 0x1540
	Size: 0x3F0
	Parameters: 1
	Flags: Linked
*/
function client_menus(localclientnum)
{
	level endon(#"disconnect");
	clientmenustack = array();
	while(true)
	{
		level waittill("menu_change" + localclientnum, menu_name, status, state);
		menu_index = undefined;
		for(i = 0; i < clientmenustack.size; i++)
		{
			if(clientmenustack[i].menu_name == menu_name)
			{
				menu_index = i;
				break;
			}
		}
		if(status === "closeToMenu" && isdefined(menu_index))
		{
			topmenu = undefined;
			for(i = 0; i < menu_index; i++)
			{
				popped = array::pop_front(clientmenustack, 0);
				if(!isdefined(topmenu))
				{
					topmenu = popped;
				}
			}
			setup_menu(localclientnum, clientmenustack[0], topmenu);
			continue;
		}
		statechange = isdefined(menu_index) && status !== "closed" && clientmenustack[menu_index].state !== state && (!(!isdefined(clientmenustack[menu_index].state) && !isdefined(state)));
		updateonly = statechange && menu_index !== 0;
		if(updateonly)
		{
			clientmenustack[i].state = state;
		}
		else
		{
			if(status === "closed" || statechange && isdefined(menu_index))
			{
				popped = undefined;
				if(getdvarint("ui_execdemo_e3") == 1)
				{
					while(menu_index >= 0)
					{
						if(!isdefined(popped))
						{
							popped = array::pop_front(clientmenustack, 0);
						}
						menu_index--;
					}
				}
				else
				{
					/#
						assert(menu_index == 0);
					#/
					popped = array::pop_front(clientmenustack, 0);
				}
				setup_menu(localclientnum, clientmenustack[0], popped);
			}
			if(status === "opened" && (!isdefined(menu_index) || statechange))
			{
				menu_data = spawnstruct();
				menu_data.menu_name = menu_name;
				menu_data.state = state;
				lastmenu = (clientmenustack.size > 0 ? clientmenustack[0] : undefined);
				setup_menu(localclientnum, menu_data, lastmenu);
				array::push_front(clientmenustack, menu_data);
			}
		}
	}
}

/*
	Name: screen_fade
	Namespace: lui
	Checksum: 0x83B27F4E
	Offset: 0x1938
	Size: 0x14C
	Parameters: 5
	Flags: Linked
*/
function screen_fade(n_time, n_target_alpha = 1, n_start_alpha = 0, str_color = "black", b_force_close_menu = 0)
{
	if(self == level)
	{
		foreach(player in level.players)
		{
			player thread _screen_fade(n_time, n_target_alpha, n_start_alpha, str_color, b_force_close_menu);
		}
	}
	else
	{
		self thread _screen_fade(n_time, n_target_alpha, n_start_alpha, str_color, b_force_close_menu);
	}
}

/*
	Name: screen_fade_out
	Namespace: lui
	Checksum: 0xB533994F
	Offset: 0x1A90
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function screen_fade_out(n_time, str_color)
{
	screen_fade(n_time, 1, 0, str_color, 0);
	wait(n_time);
}

/*
	Name: screen_fade_in
	Namespace: lui
	Checksum: 0xE6F355B3
	Offset: 0x1AD8
	Size: 0x42
	Parameters: 2
	Flags: Linked
*/
function screen_fade_in(n_time, str_color)
{
	screen_fade(n_time, 0, 1, str_color, 1);
	wait(n_time);
}

/*
	Name: screen_close_menu
	Namespace: lui
	Checksum: 0xB531D4AB
	Offset: 0x1B28
	Size: 0xB4
	Parameters: 0
	Flags: None
*/
function screen_close_menu()
{
	if(self == level)
	{
		foreach(player in level.players)
		{
			player thread _screen_close_menu();
		}
	}
	else
	{
		self thread _screen_close_menu();
	}
}

/*
	Name: _screen_close_menu
	Namespace: lui
	Checksum: 0xEEFC9064
	Offset: 0x1BE8
	Size: 0xF0
	Parameters: 0
	Flags: Linked, Private
*/
function private _screen_close_menu()
{
	self notify(#"_screen_fade");
	self endon(#"_screen_fade");
	self endon(#"disconnect");
	if(isdefined(self.screen_fade_menus))
	{
		str_menu = "FullScreenBlack";
		if(isdefined(self.screen_fade_menus[str_menu]))
		{
			closeluimenu(self.localclientnum, self.screen_fade_menus[str_menu].lui_menu);
			self.screen_fade_menus[str_menu] = undefined;
		}
		str_menu = "FullScreenWhite";
		if(isdefined(self.screen_fade_menus[str_menu]))
		{
			closeluimenu(self.localclientnum, self.screen_fade_menus[str_menu].lui_menu);
			self.screen_fade_menus[str_menu] = undefined;
		}
	}
}

/*
	Name: _screen_fade
	Namespace: lui
	Checksum: 0xBCA20E54
	Offset: 0x1CE0
	Size: 0x3D8
	Parameters: 5
	Flags: Linked, Private
*/
function private _screen_fade(n_time, n_target_alpha, n_start_alpha, v_color, b_force_close_menu)
{
	self notify(#"_screen_fade");
	self endon(#"_screen_fade");
	self endon(#"disconnect");
	self endon(#"entityshutdown");
	if(!isdefined(self.screen_fade_menus))
	{
		self.screen_fade_menus = [];
	}
	if(!isdefined(v_color))
	{
		v_color = (0, 0, 0);
	}
	n_time_ms = int(n_time * 1000);
	str_menu = "FullScreenBlack";
	if(isstring(v_color))
	{
		switch(v_color)
		{
			case "black":
			{
				v_color = (0, 0, 0);
				break;
			}
			case "white":
			{
				v_color = (1, 1, 1);
				break;
			}
			default:
			{
				/#
					assertmsg("");
				#/
			}
		}
	}
	lui_menu = "";
	if(isdefined(self.screen_fade_menus[str_menu]))
	{
		s_menu = self.screen_fade_menus[str_menu];
		lui_menu = s_menu.lui_menu;
		closeluimenu(self.localclientnum, lui_menu);
		n_start_alpha = lerpfloat(s_menu.n_start_alpha, s_menu.n_target_alpha, gettime() - s_menu.n_start_time);
	}
	lui_menu = createluimenu(self.localclientnum, str_menu);
	self.screen_fade_menus[str_menu] = spawnstruct();
	self.screen_fade_menus[str_menu].lui_menu = lui_menu;
	self.screen_fade_menus[str_menu].n_start_alpha = n_start_alpha;
	self.screen_fade_menus[str_menu].n_target_alpha = n_target_alpha;
	self.screen_fade_menus[str_menu].n_target_time = n_time_ms;
	self.screen_fade_menus[str_menu].n_start_time = gettime();
	self set_color(lui_menu, v_color);
	setluimenudata(self.localclientnum, lui_menu, "startAlpha", n_start_alpha);
	setluimenudata(self.localclientnum, lui_menu, "endAlpha", n_target_alpha);
	setluimenudata(self.localclientnum, lui_menu, "fadeOverTime", n_time_ms);
	openluimenu(self.localclientnum, lui_menu);
	wait(n_time);
	if(b_force_close_menu || n_target_alpha == 0)
	{
		closeluimenu(self.localclientnum, self.screen_fade_menus[str_menu].lui_menu);
		self.screen_fade_menus[str_menu] = undefined;
	}
}

/*
	Name: set_color
	Namespace: lui
	Checksum: 0xAEB53D61
	Offset: 0x20C0
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function set_color(menu, color)
{
	setluimenudata(self.localclientnum, menu, "red", color[0]);
	setluimenudata(self.localclientnum, menu, "green", color[1]);
	setluimenudata(self.localclientnum, menu, "blue", color[2]);
}

