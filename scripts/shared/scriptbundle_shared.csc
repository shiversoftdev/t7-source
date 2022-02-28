// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\util_shared;

class cscriptbundleobjectbase 
{
	var _e_array;
	var _o_bundle;
	var _s;
	var _n_clientnum;

	/*
		Name: constructor
		Namespace: cscriptbundleobjectbase
		Checksum: 0x99EC1590
		Offset: 0xC8
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
		Offset: 0xD8
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
		Checksum: 0x9F43D606
		Offset: 0x3B8
		Size: 0x18
		Parameters: 1
		Flags: Linked
	*/
	function get_ent(localclientnum)
	{
		return _e_array[localclientnum];
	}

	/*
		Name: error
		Namespace: cscriptbundleobjectbase
		Checksum: 0x7646283A
		Offset: 0x290
		Size: 0x120
		Parameters: 2
		Flags: Linked
	*/
	function error(condition, str_msg)
	{
		if(condition)
		{
			if([[ _o_bundle ]]->is_testing())
			{
				scriptbundle::error_on_screen(str_msg);
			}
			else
			{
				/#
					assertmsg((((([[ _o_bundle ]]->get_type()) + "") + ([[ _o_bundle ]]->get_name()) + "") + (isdefined(_s.name) ? "" + _s.name : (isdefined("") ? "" + "" : "")) + "") + str_msg);
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
		Checksum: 0xB01247DA
		Offset: 0x1C8
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
		Checksum: 0x43C9E43A
		Offset: 0xE8
		Size: 0xD8
		Parameters: 4
		Flags: Linked
	*/
	function init(s_objdef, o_bundle, e_ent, localclientnum)
	{
		_s = s_objdef;
		_o_bundle = o_bundle;
		if(isdefined(e_ent))
		{
			/#
				assert(!isdefined(localclientnum) || e_ent.localclientnum == localclientnum, "");
			#/
			_n_clientnum = e_ent.localclientnum;
			_e_array[_n_clientnum] = e_ent;
		}
		else
		{
			_e_array = [];
			if(isdefined(localclientnum))
			{
				_n_clientnum = localclientnum;
			}
		}
	}

}

class cscriptbundlebase 
{
	var _testing;
	var _s;
	var _str_name;
	var _a_objects;

	/*
		Name: constructor
		Namespace: cscriptbundlebase
		Checksum: 0xAC1989E2
		Offset: 0x540
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
		Offset: 0x568
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: error
		Namespace: cscriptbundlebase
		Checksum: 0x1D5FC6B9
		Offset: 0x770
		Size: 0x84
		Parameters: 2
		Flags: Linked
	*/
	function error(condition, str_msg)
	{
		if(condition)
		{
			if(_testing)
			{
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
		Checksum: 0xA969E1B3
		Offset: 0x710
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
		Checksum: 0x263AC26F
		Offset: 0x6D8
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
		Checksum: 0x8072093
		Offset: 0x650
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
		Checksum: 0x1B2EC48B
		Offset: 0x638
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
		Checksum: 0x72042D02
		Offset: 0x618
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
		Checksum: 0xBDFEB2BC
		Offset: 0x5F8
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
		Checksum: 0xCD14F293
		Offset: 0x5E0
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
		Checksum: 0xC9A13037
		Offset: 0x5C0
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
		Checksum: 0xE513F66
		Offset: 0x578
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
		Checksum: 0x2FD958C7
		Offset: 0x528
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
	Checksum: 0x622E9E5E
	Offset: 0xAA0
	Size: 0x14C
	Parameters: 1
	Flags: Linked
*/
function error_on_screen(str_msg)
{
	if(str_msg != "")
	{
		if(!isdefined(level.scene_error_hud))
		{
			level.scene_error_hud = createluimenu(0, "HudElementText");
			setluimenudata(0, level.scene_error_hud, "alignment", 1);
			setluimenudata(0, level.scene_error_hud, "x", 0);
			setluimenudata(0, level.scene_error_hud, "y", 10);
			setluimenudata(0, level.scene_error_hud, "width", 1920);
			openluimenu(0, level.scene_error_hud);
		}
		setluimenudata(0, level.scene_error_hud, "text", str_msg);
		self thread _destroy_error_on_screen();
	}
}

/*
	Name: _destroy_error_on_screen
	Namespace: scriptbundle
	Checksum: 0xC8B25732
	Offset: 0xBF8
	Size: 0x66
	Parameters: 0
	Flags: Linked
*/
function _destroy_error_on_screen()
{
	level notify(#"_destroy_error_on_screen");
	level endon(#"_destroy_error_on_screen");
	self util::waittill_notify_or_timeout("stopped", 5);
	closeluimenu(0, level.scene_error_hud);
	level.scene_error_hud = undefined;
}

