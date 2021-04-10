// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\util_shared;

#namespace cscriptbundleobjectbase;

/*
	Name: __constructor
	Namespace: cscriptbundleobjectbase
	Checksum: 0x99EC1590
	Offset: 0xC8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
}

/*
	Name: __destructor
	Namespace: cscriptbundleobjectbase
	Checksum: 0x99EC1590
	Offset: 0xD8
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
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
	self._s = s_objdef;
	self._o_bundle = o_bundle;
	if(isdefined(e_ent))
	{
		/#
			assert(!isdefined(localclientnum) || e_ent.localclientnum == localclientnum, "");
		#/
		self._n_clientnum = e_ent.localclientnum;
		self._e_array[self._n_clientnum] = e_ent;
	}
	else
	{
		self._e_array = [];
		if(isdefined(localclientnum))
		{
			self._n_clientnum = localclientnum;
		}
	}
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
		println([[ self._o_bundle ]]->get_type() + "" + [[ self._o_bundle ]]->get_name() + "" + (isdefined(self._s.name) ? "" + self._s.name : (isdefined("") ? "" + "" : "")) + "" + str_msg);
	#/
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
		if([[ self._o_bundle ]]->is_testing())
		{
			scriptbundle::error_on_screen(str_msg);
		}
		assertmsg([[ self._o_bundle ]]->get_type() + "" + [[ self._o_bundle ]]->get_name() + "" + (isdefined(self._s.name) ? "" + self._s.name : (isdefined("") ? "" + "" : "")) + "" + str_msg);
		thread [[ self._o_bundle ]]->on_error();
		return 1;
	}
	return 0;
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
	return self._e_array[localclientnum];
}

#namespace scriptbundle;

/*
	Name: cscriptbundleobjectbase
	Namespace: scriptbundle
	Checksum: 0xAFD6F135
	Offset: 0x3D8
	Size: 0x146
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cscriptbundleobjectbase()
{
	classes.cscriptbundleobjectbase[0] = spawnstruct();
	classes.cscriptbundleobjectbase[0].__vtable[964891661] = &cscriptbundleobjectbase::get_ent;
	classes.cscriptbundleobjectbase[0].__vtable[-32002227] = &cscriptbundleobjectbase::error;
	classes.cscriptbundleobjectbase[0].__vtable[1621988813] = &cscriptbundleobjectbase::log;
	classes.cscriptbundleobjectbase[0].__vtable[-1017222485] = &cscriptbundleobjectbase::init;
	classes.cscriptbundleobjectbase[0].__vtable[1606033458] = &cscriptbundleobjectbase::__destructor;
	classes.cscriptbundleobjectbase[0].__vtable[-1690805083] = &cscriptbundleobjectbase::__constructor;
}

#namespace cscriptbundlebase;

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

/*
	Name: __constructor
	Namespace: cscriptbundlebase
	Checksum: 0xAC1989E2
	Offset: 0x540
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	self._a_objects = [];
	self._testing = 0;
}

/*
	Name: __destructor
	Namespace: cscriptbundlebase
	Checksum: 0x99EC1590
	Offset: 0x568
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
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
	self._s = s;
	self._str_name = str_name;
	self._testing = b_testing;
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
	return self._s.type;
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
	return self._str_name;
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
	return self._s.vmtype;
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
	return self._s.objects;
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
	return self._testing;
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
	if(!isdefined(self._a_objects))
	{
		self._a_objects = [];
	}
	else if(!isarray(self._a_objects))
	{
		self._a_objects = array(self._a_objects);
	}
	self._a_objects[self._a_objects.size] = o_object;
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
	arrayremovevalue(self._a_objects, o_object);
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
		println(self._s.type + "" + self._str_name + "" + str_msg);
	#/
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
		if(self._testing)
		{
		}
		assertmsg(self._s.type + "" + self._str_name + "" + str_msg);
		thread [[ self ]]->on_error();
		return 1;
	}
	return 0;
}

#namespace scriptbundle;

/*
	Name: cscriptbundlebase
	Namespace: scriptbundle
	Checksum: 0xAA81C32C
	Offset: 0x800
	Size: 0x296
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cscriptbundlebase()
{
	classes.cscriptbundlebase[0] = spawnstruct();
	classes.cscriptbundlebase[0].__vtable[-32002227] = &cscriptbundlebase::error;
	classes.cscriptbundlebase[0].__vtable[1621988813] = &cscriptbundlebase::log;
	classes.cscriptbundlebase[0].__vtable[713694985] = &cscriptbundlebase::remove_object;
	classes.cscriptbundlebase[0].__vtable[178798596] = &cscriptbundlebase::add_object;
	classes.cscriptbundlebase[0].__vtable[1440274456] = &cscriptbundlebase::is_testing;
	classes.cscriptbundlebase[0].__vtable[-512051494] = &cscriptbundlebase::get_objects;
	classes.cscriptbundlebase[0].__vtable[575565049] = &cscriptbundlebase::get_vm;
	classes.cscriptbundlebase[0].__vtable[245263499] = &cscriptbundlebase::get_name;
	classes.cscriptbundlebase[0].__vtable[1872615990] = &cscriptbundlebase::get_type;
	classes.cscriptbundlebase[0].__vtable[-1017222485] = &cscriptbundlebase::init;
	classes.cscriptbundlebase[0].__vtable[1606033458] = &cscriptbundlebase::__destructor;
	classes.cscriptbundlebase[0].__vtable[-1690805083] = &cscriptbundlebase::__constructor;
	classes.cscriptbundlebase[0].__vtable[-498584435] = &cscriptbundlebase::on_error;
}

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

