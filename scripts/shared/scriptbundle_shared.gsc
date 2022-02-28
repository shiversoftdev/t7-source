// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\lui_shared;
#using scripts\shared\util_shared;

class cscriptbundleobjectbase 
{
	var _e;
	var _o_bundle;
	var _s;

	/*
		Name: constructor
		Namespace: cscriptbundleobjectbase
		Checksum: 0x99EC1590
		Offset: 0x100
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: cscriptbundleobjectbase
		Checksum: 0x99EC1590
		Offset: 0x110
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: get_ent
		Namespace: cscriptbundleobjectbase
		Checksum: 0x54798668
		Offset: 0x418
		Size: 0xA
		Parameters: 0
		Flags: Linked
	*/
	function get_ent()
	{
		return _e;
	}

	/*
		Name: warning
		Namespace: cscriptbundleobjectbase
		Checksum: 0xEF96D976
		Offset: 0x348
		Size: 0xC4
		Parameters: 2
		Flags: Linked
	*/
	function warning(condition, str_msg)
	{
		if(condition)
		{
			str_msg = ((("[ " + ([[ _o_bundle ]]->get_name())) + " ] ") + (isdefined(_s.name) ? "" + _s.name : (isdefined("no name") ? "" + "no name" : "")) + ": ") + str_msg;
			scriptbundle::warning_on_screen(str_msg);
			return true;
		}
		return false;
	}

	/*
		Name: error
		Namespace: cscriptbundleobjectbase
		Checksum: 0x8F30BEF4
		Offset: 0x230
		Size: 0x110
		Parameters: 2
		Flags: Linked
	*/
	function error(condition, str_msg)
	{
		if(condition)
		{
			str_msg = ((("[ " + ([[ _o_bundle ]]->get_name())) + " ] ") + (isdefined(_s.name) ? "" + _s.name : (isdefined("no name") ? "" + "no name" : "")) + ": ") + str_msg;
			if([[ _o_bundle ]]->is_testing())
			{
				scriptbundle::error_on_screen(str_msg);
			}
			else
			{
				/#
					assertmsg(str_msg);
				#/
			}
			thread [[ _o_bundle ]]->on_error();
			return true;
		}
		return false;
	}

	/*
		Name: log
		Namespace: cscriptbundleobjectbase
		Checksum: 0xFB9CA0A7
		Offset: 0x168
		Size: 0xBC
		Parameters: 1
		Flags: Linked
	*/
	function log(str_msg)
	{
		/#
			println((((([[ _o_bundle ]]->get_type()) + "") + ([[ _o_bundle ]]->get_name()) + "") + (isdefined(_s.name) ? "" + _s.name : (isdefined("") ? "" + "" : "")) + "") + str_msg);
		#/
	}

	/*
		Name: init
		Namespace: cscriptbundleobjectbase
		Checksum: 0x5844D1C3
		Offset: 0x120
		Size: 0x40
		Parameters: 3
		Flags: Linked
	*/
	function init(s_objdef, o_bundle, e_ent)
	{
		_s = s_objdef;
		_o_bundle = o_bundle;
		_e = e_ent;
	}

}

class cscriptbundlebase 
{
	var _testing;
	var _str_name;
	var _s;
	var _a_objects;

	/*
		Name: constructor
		Namespace: cscriptbundlebase
		Checksum: 0x6DE21345
		Offset: 0x5C8
		Size: 0x1C
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		_a_objects = [];
		_testing = 0;
	}

	/*
		Name: destructor
		Namespace: cscriptbundlebase
		Checksum: 0x99EC1590
		Offset: 0x5F0
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: warning
		Namespace: cscriptbundlebase
		Checksum: 0x6ED1FA83
		Offset: 0x8A0
		Size: 0x5C
		Parameters: 2
		Flags: Linked
	*/
	function warning(condition, str_msg)
	{
		if(condition)
		{
			if(_testing)
			{
				scriptbundle::warning_on_screen((("[ " + _str_name) + " ]: ") + str_msg);
			}
			return true;
		}
		return false;
	}

	/*
		Name: error
		Namespace: cscriptbundlebase
		Checksum: 0x109A92D7
		Offset: 0x7F8
		Size: 0x9C
		Parameters: 2
		Flags: Linked
	*/
	function error(condition, str_msg)
	{
		if(condition)
		{
			if(_testing)
			{
				scriptbundle::error_on_screen(str_msg);
			}
			else
			{
				/#
					assertmsg((((_s.type + "") + _str_name) + "") + str_msg);
				#/
			}
			thread [[ self ]]->on_error();
			return true;
		}
		return false;
	}

	/*
		Name: log
		Namespace: cscriptbundlebase
		Checksum: 0x76DBFEE2
		Offset: 0x798
		Size: 0x54
		Parameters: 1
		Flags: Linked
	*/
	function log(str_msg)
	{
		/#
			println((((_s.type + "") + _str_name) + "") + str_msg);
		#/
	}

	/*
		Name: remove_object
		Namespace: cscriptbundlebase
		Checksum: 0x6F4CF57E
		Offset: 0x760
		Size: 0x2C
		Parameters: 1
		Flags: Linked
	*/
	function remove_object(o_object)
	{
		arrayremovevalue(_a_objects, o_object);
	}

	/*
		Name: add_object
		Namespace: cscriptbundlebase
		Checksum: 0x394EAE86
		Offset: 0x6D8
		Size: 0x7A
		Parameters: 1
		Flags: Linked
	*/
	function add_object(o_object)
	{
		if(!isdefined(_a_objects))
		{
			_a_objects = [];
		}
		else if(!isarray(_a_objects))
		{
			_a_objects = array(_a_objects);
		}
		_a_objects[_a_objects.size] = o_object;
	}

	/*
		Name: is_testing
		Namespace: cscriptbundlebase
		Checksum: 0x4394C8E9
		Offset: 0x6C0
		Size: 0xA
		Parameters: 0
		Flags: Linked
	*/
	function is_testing()
	{
		return _testing;
	}

	/*
		Name: get_objects
		Namespace: cscriptbundlebase
		Checksum: 0xD36AB5BC
		Offset: 0x6A0
		Size: 0x12
		Parameters: 0
		Flags: Linked
	*/
	function get_objects()
	{
		return _s.objects;
	}

	/*
		Name: get_vm
		Namespace: cscriptbundlebase
		Checksum: 0xC521A181
		Offset: 0x680
		Size: 0x12
		Parameters: 0
		Flags: Linked
	*/
	function get_vm()
	{
		return _s.vmtype;
	}

	/*
		Name: get_name
		Namespace: cscriptbundlebase
		Checksum: 0x3E31FF60
		Offset: 0x668
		Size: 0xA
		Parameters: 0
		Flags: Linked
	*/
	function get_name()
	{
		return _str_name;
	}

	/*
		Name: get_type
		Namespace: cscriptbundlebase
		Checksum: 0x63864013
		Offset: 0x648
		Size: 0x12
		Parameters: 0
		Flags: Linked
	*/
	function get_type()
	{
		return _s.type;
	}

	/*
		Name: init
		Namespace: cscriptbundlebase
		Checksum: 0xECFF8071
		Offset: 0x600
		Size: 0x40
		Parameters: 3
		Flags: Linked
	*/
	function init(str_name, s, b_testing)
	{
		_s = s;
		_str_name = str_name;
		_testing = b_testing;
	}

	/*
		Name: on_error
		Namespace: cscriptbundlebase
		Checksum: 0x67ED96C9
		Offset: 0x5B0
		Size: 0xC
		Parameters: 1
		Flags: Linked
	*/
	function on_error(e)
	{
	}

}

#namespace scriptbundle;

/*
	Name: error_on_screen
	Namespace: scriptbundle
	Checksum: 0xBF45821F
	Offset: 0xBD8
	Size: 0x184
	Parameters: 1
	Flags: Linked
*/
function error_on_screen(str_msg)
{
	if(str_msg != "")
	{
		if(!isdefined(level.scene_error_hud))
		{
			level.scene_error_hud = level.players[0] openluimenu("HudElementText");
			level.players[0] setluimenudata(level.scene_error_hud, "alignment", 2);
			level.players[0] setluimenudata(level.scene_error_hud, "x", 0);
			level.players[0] setluimenudata(level.scene_error_hud, "y", 10);
			level.players[0] setluimenudata(level.scene_error_hud, "width", 1280);
			level.players[0] lui::set_color(level.scene_error_hud, (1, 0, 0));
		}
		level.players[0] setluimenudata(level.scene_error_hud, "text", str_msg);
		self thread _destroy_error_on_screen();
	}
}

/*
	Name: _destroy_error_on_screen
	Namespace: scriptbundle
	Checksum: 0x1005FCA8
	Offset: 0xD68
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function _destroy_error_on_screen()
{
	level notify(#"_destroy_error_on_screen");
	level endon(#"_destroy_error_on_screen");
	self util::waittill_notify_or_timeout("stopped", 5);
	level.players[0] closeluimenu(level.scene_error_hud);
	level.scene_error_hud = undefined;
}

/*
	Name: warning_on_screen
	Namespace: scriptbundle
	Checksum: 0x6A7DD4E6
	Offset: 0xDE0
	Size: 0x18C
	Parameters: 1
	Flags: Linked
*/
function warning_on_screen(str_msg)
{
	/#
		if(str_msg != "")
		{
			if(!isdefined(level.scene_warning_hud))
			{
				level.scene_warning_hud = level.players[0] openluimenu("");
				level.players[0] setluimenudata(level.scene_warning_hud, "", 2);
				level.players[0] setluimenudata(level.scene_warning_hud, "", 0);
				level.players[0] setluimenudata(level.scene_warning_hud, "", 1060);
				level.players[0] setluimenudata(level.scene_warning_hud, "", 1280);
				level.players[0] lui::set_color(level.scene_warning_hud, (1, 1, 0));
			}
			level.players[0] setluimenudata(level.scene_warning_hud, "", str_msg);
			self thread _destroy_warning_on_screen();
		}
	#/
}

/*
	Name: _destroy_warning_on_screen
	Namespace: scriptbundle
	Checksum: 0xEF4B6A8F
	Offset: 0xF78
	Size: 0x6E
	Parameters: 0
	Flags: Linked
*/
function _destroy_warning_on_screen()
{
	level notify(#"_destroy_warning_on_screen");
	level endon(#"_destroy_warning_on_screen");
	self util::waittill_notify_or_timeout("stopped", 10);
	level.players[0] closeluimenu(level.scene_warning_hud);
	level.scene_warning_hud = undefined;
}

