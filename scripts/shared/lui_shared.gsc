// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\string_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace lui;

/*
	Name: __init__sytem__
	Namespace: lui
	Checksum: 0x7C192381
	Offset: 0x310
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
	Checksum: 0x3A3FBBD1
	Offset: 0x350
	Size: 0x24
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::on_spawned(&refresh_menu_values);
}

/*
	Name: refresh_menu_values
	Namespace: lui
	Checksum: 0x156EBB14
	Offset: 0x380
	Size: 0x130
	Parameters: 0
	Flags: Linked, Private
*/
function private refresh_menu_values()
{
	if(!isdefined(level.lui_script_globals))
	{
		return;
	}
	a_str_menus = getarraykeys(level.lui_script_globals);
	for(i = 0; i < a_str_menus.size; i++)
	{
		str_menu = a_str_menus[i];
		a_str_vars = getarraykeys(level.lui_script_globals[str_menu]);
		for(j = 0; j < a_str_vars.size; j++)
		{
			str_var = a_str_vars[j];
			value = level.lui_script_globals[str_menu][str_var];
			self set_value_for_player(str_menu, str_var, value);
		}
	}
}

/*
	Name: play_animation
	Namespace: lui
	Checksum: 0x1EEBB1F7
	Offset: 0x4B8
	Size: 0x9C
	Parameters: 2
	Flags: None
*/
function play_animation(menu, str_anim)
{
	str_curr_anim = self getluimenudata(menu, "current_animation");
	str_new_anim = str_anim;
	if(isdefined(str_curr_anim) && str_curr_anim == str_anim)
	{
		str_new_anim = "";
	}
	self setluimenudata(menu, "current_animation", str_new_anim);
}

/*
	Name: set_color
	Namespace: lui
	Checksum: 0x28DC005
	Offset: 0x560
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function set_color(menu, color)
{
	self setluimenudata(menu, "red", color[0]);
	self setluimenudata(menu, "green", color[1]);
	self setluimenudata(menu, "blue", color[2]);
}

/*
	Name: set_value_for_player
	Namespace: lui
	Checksum: 0x64F2902B
	Offset: 0x5F8
	Size: 0x94
	Parameters: 3
	Flags: Linked
*/
function set_value_for_player(str_menu_id, str_variable_id, value)
{
	if(!isdefined(self.lui_script_menus))
	{
		self.lui_script_menus = [];
	}
	if(!isdefined(self.lui_script_menus[str_menu_id]))
	{
		self.lui_script_menus[str_menu_id] = self openluimenu(str_menu_id);
	}
	self setluimenudata(self.lui_script_menus[str_menu_id], str_variable_id, value);
}

/*
	Name: set_global
	Namespace: lui
	Checksum: 0xC284CB4E
	Offset: 0x698
	Size: 0x112
	Parameters: 3
	Flags: None
*/
function set_global(str_menu_id, str_variable_id, value)
{
	if(!isdefined(level.lui_script_globals))
	{
		level.lui_script_globals = [];
	}
	if(!isdefined(level.lui_script_globals[str_menu_id]))
	{
		level.lui_script_globals[str_menu_id] = [];
	}
	level.lui_script_globals[str_menu_id][str_variable_id] = value;
	if(isdefined(level.players))
	{
		foreach(player in level.players)
		{
			player set_value_for_player(str_menu_id, str_variable_id, value);
		}
	}
}

/*
	Name: timer
	Namespace: lui
	Checksum: 0xBA93BEB8
	Offset: 0x7B8
	Size: 0x17C
	Parameters: 5
	Flags: None
*/
function timer(n_time, str_endon, x = 1080, y = 200, height = 60)
{
	lui = self openluimenu("HudElementTimer");
	self setluimenudata(lui, "x", x);
	self setluimenudata(lui, "y", y);
	self setluimenudata(lui, "height", height);
	self setluimenudata(lui, "time", gettime() + (n_time * 1000));
	if(isdefined(str_endon))
	{
		self util::waittill_notify_or_timeout(str_endon, n_time);
	}
	else
	{
		wait(n_time);
	}
	self closeluimenu(lui);
}

/*
	Name: prime_movie
	Namespace: lui
	Checksum: 0x1B165576
	Offset: 0x940
	Size: 0x10C
	Parameters: 3
	Flags: None
*/
function prime_movie(str_movie, b_looping = 0, str_key = "")
{
	if(self == level)
	{
		foreach(player in level.players)
		{
			player primemovie(str_movie, b_looping, str_key);
		}
	}
	else
	{
		player primemovie(str_movie, b_looping, str_key);
	}
}

/*
	Name: play_movie
	Namespace: lui
	Checksum: 0xBC4CEC1C
	Offset: 0xA58
	Size: 0x2FE
	Parameters: 5
	Flags: None
*/
function play_movie(str_movie, str_type, show_black_screen = 0, b_looping = 0, str_key = "")
{
	if(str_type === "fullscreen" || str_type === "fullscreen_additive")
	{
		b_hide_hud = 1;
	}
	if(self == level)
	{
		foreach(player in level.players)
		{
			if(isdefined(b_hide_hud))
			{
				player flagsys::set("playing_movie_hide_hud");
				player util::show_hud(0);
			}
			player thread _play_movie_for_player(str_movie, str_type, show_black_screen, b_looping, str_key);
		}
		array::wait_till(level.players, "movie_done");
		if(isdefined(b_hide_hud))
		{
			foreach(player in level.players)
			{
				player flagsys::clear("playing_movie_hide_hud");
				player util::show_hud(1);
			}
		}
	}
	else
	{
		if(isdefined(b_hide_hud))
		{
			self flagsys::set("playing_movie_hide_hud");
			self util::show_hud(0);
		}
		_play_movie_for_player(str_movie, str_type, 0, b_looping, str_key);
		if(isdefined(b_hide_hud))
		{
			self flagsys::clear("playing_movie_hide_hud");
			self util::show_hud(1);
		}
	}
	level notify(#"movie_done", str_type);
}

/*
	Name: _play_movie_for_player
	Namespace: lui
	Checksum: 0xA6F7E2B
	Offset: 0xD60
	Size: 0x2CE
	Parameters: 5
	Flags: Linked, Private
*/
function private _play_movie_for_player(str_movie, str_type, show_black_screen, b_looping, str_key)
{
	self endon(#"disconnect");
	str_menu = undefined;
	switch(str_type)
	{
		case "fullscreen":
		case "fullscreen_additive":
		{
			str_menu = "FullscreenMovie";
			break;
		}
		case "pip":
		{
			str_menu = "PiPMenu";
			break;
		}
		default:
		{
			/#
				assertmsg(("" + str_type) + "");
			#/
		}
	}
	if(str_type == "pip")
	{
		self playsoundtoplayer("uin_pip_open", self);
	}
	lui_menu = self openluimenu(str_menu);
	if(isdefined(lui_menu))
	{
		self setluimenudata(lui_menu, "movieName", str_movie);
		self setluimenudata(lui_menu, "movieKey", str_key);
		self setluimenudata(lui_menu, "showBlackScreen", show_black_screen);
		self setluimenudata(lui_menu, "looping", b_looping);
		self setluimenudata(lui_menu, "additive", 0);
		if(issubstr(str_type, "additive"))
		{
			self setluimenudata(lui_menu, "additive", 1);
		}
		while(true)
		{
			self waittill(#"menuresponse", menu, response);
			if(menu == str_menu && response == "finished_movie_playback")
			{
				if(str_type == "pip")
				{
					self playsoundtoplayer("uin_pip_close", self);
				}
				self closeluimenu(lui_menu);
				self notify(#"movie_done");
			}
		}
	}
}

/*
	Name: play_movie_with_timeout
	Namespace: lui
	Checksum: 0x77729E83
	Offset: 0x1038
	Size: 0x272
	Parameters: 6
	Flags: None
*/
function play_movie_with_timeout(str_movie, str_type, timeout, show_black_screen = 0, b_looping = 0, str_key = "")
{
	if(str_type === "fullscreen" || str_type === "fullscreen_additive")
	{
		b_hide_hud = 1;
	}
	/#
		assert(self == level);
	#/
	foreach(player in level.players)
	{
		if(isdefined(b_hide_hud))
		{
			player flagsys::set("playing_movie_hide_hud");
			player util::show_hud(0);
		}
		player thread _play_movie_for_player_with_timeout(str_movie, str_type, timeout, show_black_screen, b_looping, str_key);
	}
	array::wait_till(level.players, "movie_done");
	if(isdefined(b_hide_hud))
	{
		foreach(player in level.players)
		{
			player flagsys::clear("playing_movie_hide_hud");
			player util::show_hud(1);
		}
	}
	level notify(#"movie_done", str_type);
}

/*
	Name: _play_movie_for_player_with_timeout
	Namespace: lui
	Checksum: 0x55F86EA1
	Offset: 0x12B8
	Size: 0x292
	Parameters: 6
	Flags: Linked, Private
*/
function private _play_movie_for_player_with_timeout(str_movie, str_type, timeout, show_black_screen, b_looping, str_key)
{
	self endon(#"disconnect");
	str_menu = undefined;
	switch(str_type)
	{
		case "fullscreen":
		case "fullscreen_additive":
		{
			str_menu = "FullscreenMovie";
			break;
		}
		case "pip":
		{
			str_menu = "PiPMenu";
			break;
		}
		default:
		{
			/#
				assertmsg(("" + str_type) + "");
			#/
		}
	}
	if(str_type == "pip")
	{
		self playsoundtoplayer("uin_pip_open", self);
	}
	lui_menu = self openluimenu(str_menu);
	if(isdefined(lui_menu))
	{
		self setluimenudata(lui_menu, "movieName", str_movie);
		self setluimenudata(lui_menu, "movieKey", str_key);
		self setluimenudata(lui_menu, "showBlackScreen", show_black_screen);
		self setluimenudata(lui_menu, "looping", b_looping);
		self setluimenudata(lui_menu, "additive", 0);
		if(issubstr(str_type, "additive"))
		{
			self setluimenudata(lui_menu, "additive", 1);
		}
		wait(timeout);
		if(str_type == "pip")
		{
			self playsoundtoplayer("uin_pip_close", self);
		}
		self closeluimenu(lui_menu);
		self notify(#"movie_done");
	}
}

/*
	Name: screen_flash
	Namespace: lui
	Checksum: 0x148D648B
	Offset: 0x1558
	Size: 0x16C
	Parameters: 6
	Flags: Linked
*/
function screen_flash(n_fadein_time, n_hold_time, n_fadeout_time, n_target_alpha = 1, v_color, b_force_close_menu = 0)
{
	if(self == level)
	{
		foreach(player in level.players)
		{
			player thread screen_flash(n_fadein_time, n_hold_time, n_fadeout_time, n_target_alpha, v_color, b_force_close_menu);
		}
	}
	else
	{
		self endon(#"disconnect");
		self _screen_fade(n_fadein_time, n_target_alpha, 0, v_color, b_force_close_menu);
		wait(n_hold_time);
		self _screen_fade(n_fadeout_time, 0, n_target_alpha, v_color, b_force_close_menu);
	}
}

/*
	Name: screen_fade
	Namespace: lui
	Checksum: 0x712F7821
	Offset: 0x16D0
	Size: 0x14C
	Parameters: 6
	Flags: Linked
*/
function screen_fade(n_time, n_target_alpha = 1, n_start_alpha = 0, v_color, b_force_close_menu = 0, str_menu_id)
{
	if(self == level)
	{
		foreach(player in level.players)
		{
			player thread _screen_fade(n_time, n_target_alpha, n_start_alpha, v_color, b_force_close_menu, str_menu_id);
		}
	}
	else
	{
		self thread _screen_fade(n_time, n_target_alpha, n_start_alpha, v_color, b_force_close_menu, str_menu_id);
	}
}

/*
	Name: screen_fade_out
	Namespace: lui
	Checksum: 0x1F809824
	Offset: 0x1828
	Size: 0x4A
	Parameters: 3
	Flags: Linked
*/
function screen_fade_out(n_time, v_color, str_menu_id)
{
	screen_fade(n_time, 1, 0, v_color, 0, str_menu_id);
	wait(n_time);
}

/*
	Name: screen_fade_in
	Namespace: lui
	Checksum: 0xC7383E51
	Offset: 0x1880
	Size: 0x4A
	Parameters: 3
	Flags: Linked
*/
function screen_fade_in(n_time, v_color, str_menu_id)
{
	screen_fade(n_time, 0, 1, v_color, 1, str_menu_id);
	wait(n_time);
}

/*
	Name: screen_close_menu
	Namespace: lui
	Checksum: 0xA3A594AD
	Offset: 0x18D8
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
	Checksum: 0x3DEC8BA6
	Offset: 0x1998
	Size: 0xD6
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
		foreach(str_menu_id, lui_menu in self.screen_fade_menus)
		{
			self closeluimenu(lui_menu.lui_menu);
			self.screen_fade_menus[str_menu_id] = undefined;
		}
	}
}

/*
	Name: _screen_fade
	Namespace: lui
	Checksum: 0x6D24D048
	Offset: 0x1A78
	Size: 0x54E
	Parameters: 6
	Flags: Linked, Private
*/
function private _screen_fade(n_time, n_target_alpha, n_start_alpha, v_color, b_force_close_menu, str_menu_id = "default")
{
	self notify("_screen_fade_" + str_menu_id);
	self endon("_screen_fade_" + str_menu_id);
	self endon(#"disconnect");
	if(!isdefined(self.screen_fade_menus))
	{
		self.screen_fade_menus = [];
	}
	if(!isdefined(level.screen_fade_network_frame))
	{
		level.screen_fade_network_frame = 0;
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
		}
	}
	lui_menu = "";
	if(isdefined(self.screen_fade_menus[str_menu_id]))
	{
		s_menu = self.screen_fade_menus[str_menu_id];
		lui_menu = s_menu.lui_menu;
		_one_screen_fade_per_network_frame(s_menu);
		n_start_alpha = lerpfloat(s_menu.n_start_alpha, s_menu.n_target_alpha, gettime() - s_menu.n_start_time);
	}
	else
	{
		lui_menu = self openluimenu(str_menu);
		self.screen_fade_menus[str_menu_id] = spawnstruct();
		self.screen_fade_menus[str_menu_id].lui_menu = lui_menu;
	}
	self.screen_fade_menus[str_menu_id].n_start_alpha = n_start_alpha;
	self.screen_fade_menus[str_menu_id].n_target_alpha = n_target_alpha;
	self.screen_fade_menus[str_menu_id].n_target_time = n_time_ms;
	self.screen_fade_menus[str_menu_id].n_start_time = gettime();
	self set_color(lui_menu, v_color);
	self setluimenudata(lui_menu, "startAlpha", n_start_alpha);
	self setluimenudata(lui_menu, "endAlpha", n_target_alpha);
	self setluimenudata(lui_menu, "fadeOverTime", n_time_ms);
	/#
		if(!isdefined(level.n_fade_debug_time))
		{
			level.n_fade_debug_time = 0;
		}
		n_debug_time = gettime();
		if((n_debug_time - level.n_fade_debug_time) > 5000)
		{
			printtoprightln("");
		}
		level.n_fade_debug_time = n_debug_time;
		printtoprightln(((((("" + (string::rfill("" + gettime(), 6))) + "") + string::rfill(str_menu_id, 10) + "") + string::rfill(v_color, 11) + "") + (string::rfill((n_start_alpha + "") + n_target_alpha, 10)) + "") + string::rfill(n_time, 6) + "", (1, 1, 1));
	#/
	if(n_time > 0)
	{
		wait(n_time);
	}
	self setluimenudata(lui_menu, "fadeOverTime", 0);
	if(b_force_close_menu || n_target_alpha == 0)
	{
		if(isdefined(self.screen_fade_menus[str_menu_id]))
		{
			self closeluimenu(self.screen_fade_menus[str_menu_id].lui_menu);
		}
		self.screen_fade_menus[str_menu_id] = undefined;
		if(!self.screen_fade_menus.size)
		{
			self.screen_fade_menus = undefined;
		}
	}
}

/*
	Name: _one_screen_fade_per_network_frame
	Namespace: lui
	Checksum: 0x47E2B193
	Offset: 0x1FD0
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private _one_screen_fade_per_network_frame(s_menu)
{
	while(s_menu.screen_fade_network_frame === level.network_frame)
	{
		util::wait_network_frame();
	}
	s_menu.screen_fade_network_frame = level.network_frame;
}

/*
	Name: open_generic_script_dialog
	Namespace: lui
	Checksum: 0x5433E658
	Offset: 0x2030
	Size: 0xF4
	Parameters: 2
	Flags: None
*/
function open_generic_script_dialog(title, description)
{
	self endon(#"disconnect");
	dialog = self openluimenu("ScriptMessageDialog_Compact");
	self setluimenudata(dialog, "title", title);
	self setluimenudata(dialog, "description", description);
	do
	{
		self waittill(#"menuresponse", menu, response);
	}
	while(menu != "ScriptMessageDialog_Compact" || response != "close");
	self closeluimenu(dialog);
}

/*
	Name: open_script_dialog
	Namespace: lui
	Checksum: 0x6A19F2B5
	Offset: 0x2130
	Size: 0x94
	Parameters: 1
	Flags: None
*/
function open_script_dialog(dialog_name)
{
	self endon(#"disconnect");
	dialog = self openluimenu(dialog_name);
	do
	{
		self waittill(#"menuresponse", menu, response);
	}
	while(menu != dialog_name || response != "close");
	self closeluimenu(dialog);
}

