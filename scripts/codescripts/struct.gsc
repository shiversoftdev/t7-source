// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\scene_shared;

#namespace struct;

/*
	Name: __init__
	Namespace: struct
	Checksum: 0x7DA99B52
	Offset: 0x170
	Size: 0x24
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__()
{
	if(!isdefined(level.struct))
	{
		init_structs();
	}
}

/*
	Name: init_structs
	Namespace: struct
	Checksum: 0x98B4DD06
	Offset: 0x1A0
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function init_structs()
{
	level.struct = [];
	level.scriptbundles = [];
	level.scriptbundlelists = [];
	level.struct_class_names = [];
	level.struct_class_names["target"] = [];
	level.struct_class_names["targetname"] = [];
	level.struct_class_names["script_noteworthy"] = [];
	level.struct_class_names["script_linkname"] = [];
	level.struct_class_names["script_label"] = [];
	level.struct_class_names["classname"] = [];
	level.struct_class_names["script_unitrigger_type"] = [];
	level.struct_class_names["scriptbundlename"] = [];
	level.struct_class_names["prefabname"] = [];
}

/*
	Name: remove_unneeded_kvps
	Namespace: struct
	Checksum: 0x198D4C90
	Offset: 0x298
	Size: 0x68
	Parameters: 1
	Flags: Linked
*/
function remove_unneeded_kvps(struct)
{
	struct.igdtseqnum = undefined;
	struct.configstringfiletype = undefined;
	/#
		devstate = struct.devstate;
	#/
	struct.devstate = undefined;
	/#
		struct.devstate = devstate;
	#/
}

/*
	Name: createstruct
	Namespace: struct
	Checksum: 0xA9EFCA9E
	Offset: 0x308
	Size: 0x1FC
	Parameters: 3
	Flags: Linked
*/
function createstruct(struct, type, name)
{
	if(!isdefined(level.struct))
	{
		init_structs();
	}
	if(isdefined(type))
	{
		isfrontend = getdvarstring("mapname") == "core_frontend";
		if(!isdefined(level.scriptbundles[type]))
		{
			level.scriptbundles[type] = [];
		}
		if(isdefined(level.scriptbundles[type][name]))
		{
			return level.scriptbundles[type][name];
		}
		if(type == "scene")
		{
			level.scriptbundles[type][name] = scene::remove_invalid_scene_objects(struct);
		}
		else
		{
			if(!(sessionmodeismultiplayergame() || isfrontend) && type == "mpdialog_player")
			{
			}
			else
			{
				if(!(sessionmodeismultiplayergame() || isfrontend) && type == "gibcharacterdef" && issubstr(name, "c_t7_mp_"))
				{
				}
				else
				{
					if(!(sessionmodeiscampaigngame() || isfrontend) && type == "collectibles")
					{
					}
					else
					{
						level.scriptbundles[type][name] = struct;
					}
				}
			}
		}
		remove_unneeded_kvps(struct);
	}
	else
	{
		struct init();
	}
}

/*
	Name: createscriptbundlelist
	Namespace: struct
	Checksum: 0xAF40FD54
	Offset: 0x510
	Size: 0x54
	Parameters: 3
	Flags: Linked
*/
function createscriptbundlelist(items, var_1578b6b3, name)
{
	if(!isdefined(level.struct))
	{
		init_structs();
	}
	level.scriptbundlelists[var_1578b6b3][name] = items;
}

/*
	Name: init
	Namespace: struct
	Checksum: 0xAA77F2F9
	Offset: 0x570
	Size: 0x93E
	Parameters: 0
	Flags: Linked
*/
function init()
{
	if(!isdefined(level.struct))
	{
		level.struct = [];
	}
	else if(!isarray(level.struct))
	{
		level.struct = array(level.struct);
	}
	level.struct[level.struct.size] = self;
	if(!isdefined(self.angles))
	{
		self.angles = (0, 0, 0);
	}
	if(isdefined(self.targetname))
	{
		if(!isdefined(level.struct_class_names["targetname"][self.targetname]))
		{
			level.struct_class_names["targetname"][self.targetname] = [];
		}
		else if(!isarray(level.struct_class_names["targetname"][self.targetname]))
		{
			level.struct_class_names["targetname"][self.targetname] = array(level.struct_class_names["targetname"][self.targetname]);
		}
		level.struct_class_names["targetname"][self.targetname][level.struct_class_names["targetname"][self.targetname].size] = self;
	}
	if(isdefined(self.target))
	{
		if(!isdefined(level.struct_class_names["target"][self.target]))
		{
			level.struct_class_names["target"][self.target] = [];
		}
		else if(!isarray(level.struct_class_names["target"][self.target]))
		{
			level.struct_class_names["target"][self.target] = array(level.struct_class_names["target"][self.target]);
		}
		level.struct_class_names["target"][self.target][level.struct_class_names["target"][self.target].size] = self;
	}
	if(isdefined(self.script_noteworthy))
	{
		if(!isdefined(level.struct_class_names["script_noteworthy"][self.script_noteworthy]))
		{
			level.struct_class_names["script_noteworthy"][self.script_noteworthy] = [];
		}
		else if(!isarray(level.struct_class_names["script_noteworthy"][self.script_noteworthy]))
		{
			level.struct_class_names["script_noteworthy"][self.script_noteworthy] = array(level.struct_class_names["script_noteworthy"][self.script_noteworthy]);
		}
		level.struct_class_names["script_noteworthy"][self.script_noteworthy][level.struct_class_names["script_noteworthy"][self.script_noteworthy].size] = self;
	}
	if(isdefined(self.script_linkname))
	{
		/#
			assert(!isdefined(level.struct_class_names[""][self.script_linkname]), "");
		#/
		level.struct_class_names["script_linkname"][self.script_linkname][0] = self;
	}
	if(isdefined(self.script_label))
	{
		if(!isdefined(level.struct_class_names["script_label"][self.script_label]))
		{
			level.struct_class_names["script_label"][self.script_label] = [];
		}
		else if(!isarray(level.struct_class_names["script_label"][self.script_label]))
		{
			level.struct_class_names["script_label"][self.script_label] = array(level.struct_class_names["script_label"][self.script_label]);
		}
		level.struct_class_names["script_label"][self.script_label][level.struct_class_names["script_label"][self.script_label].size] = self;
	}
	if(isdefined(self.classname))
	{
		if(!isdefined(level.struct_class_names["classname"][self.classname]))
		{
			level.struct_class_names["classname"][self.classname] = [];
		}
		else if(!isarray(level.struct_class_names["classname"][self.classname]))
		{
			level.struct_class_names["classname"][self.classname] = array(level.struct_class_names["classname"][self.classname]);
		}
		level.struct_class_names["classname"][self.classname][level.struct_class_names["classname"][self.classname].size] = self;
	}
	if(isdefined(self.script_unitrigger_type))
	{
		if(!isdefined(level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type]))
		{
			level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type] = [];
		}
		else if(!isarray(level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type]))
		{
			level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type] = array(level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type]);
		}
		level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type][level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type].size] = self;
	}
	if(isdefined(self.scriptbundlename))
	{
		if(!isdefined(level.struct_class_names["scriptbundlename"][self.scriptbundlename]))
		{
			level.struct_class_names["scriptbundlename"][self.scriptbundlename] = [];
		}
		else if(!isarray(level.struct_class_names["scriptbundlename"][self.scriptbundlename]))
		{
			level.struct_class_names["scriptbundlename"][self.scriptbundlename] = array(level.struct_class_names["scriptbundlename"][self.scriptbundlename]);
		}
		level.struct_class_names["scriptbundlename"][self.scriptbundlename][level.struct_class_names["scriptbundlename"][self.scriptbundlename].size] = self;
	}
	if(isdefined(self.prefabname))
	{
		if(!isdefined(level.struct_class_names["prefabname"][self.prefabname]))
		{
			level.struct_class_names["prefabname"][self.prefabname] = [];
		}
		else if(!isarray(level.struct_class_names["prefabname"][self.prefabname]))
		{
			level.struct_class_names["prefabname"][self.prefabname] = array(level.struct_class_names["prefabname"][self.prefabname]);
		}
		level.struct_class_names["prefabname"][self.prefabname][level.struct_class_names["prefabname"][self.prefabname].size] = self;
	}
}

/*
	Name: get
	Namespace: struct
	Checksum: 0xF9CFB9
	Offset: 0xEB8
	Size: 0xD2
	Parameters: 2
	Flags: Linked
*/
function get(kvp_value, kvp_key = "targetname")
{
	if(isdefined(level.struct_class_names[kvp_key]) && isdefined(level.struct_class_names[kvp_key][kvp_value]))
	{
		/#
			if(level.struct_class_names[kvp_key][kvp_value].size > 1)
			{
				/#
					assertmsg(((("" + kvp_key) + "") + kvp_value) + "");
				#/
				return undefined;
			}
		#/
		return level.struct_class_names[kvp_key][kvp_value][0];
	}
}

/*
	Name: spawn
	Namespace: struct
	Checksum: 0x6F176828
	Offset: 0xF98
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function spawn(v_origin = (0, 0, 0), v_angles = (0, 0, 0))
{
	s = spawnstruct();
	s.origin = v_origin;
	s.angles = v_angles;
	return s;
}

/*
	Name: get_array
	Namespace: struct
	Checksum: 0x31B74458
	Offset: 0x1028
	Size: 0x6E
	Parameters: 2
	Flags: Linked
*/
function get_array(kvp_value, kvp_key = "targetname")
{
	if(isdefined(level.struct_class_names[kvp_key][kvp_value]))
	{
		return arraycopy(level.struct_class_names[kvp_key][kvp_value]);
	}
	return [];
}

/*
	Name: delete
	Namespace: struct
	Checksum: 0x75BCE4B5
	Offset: 0x10A0
	Size: 0x1FC
	Parameters: 0
	Flags: Linked
*/
function delete()
{
	if(isdefined(self.target))
	{
		arrayremovevalue(level.struct_class_names["target"][self.target], self);
	}
	if(isdefined(self.targetname))
	{
		arrayremovevalue(level.struct_class_names["targetname"][self.targetname], self);
	}
	if(isdefined(self.script_noteworthy))
	{
		arrayremovevalue(level.struct_class_names["script_noteworthy"][self.script_noteworthy], self);
	}
	if(isdefined(self.script_linkname))
	{
		arrayremovevalue(level.struct_class_names["script_linkname"][self.script_linkname], self);
	}
	if(isdefined(self.script_label))
	{
		arrayremovevalue(level.struct_class_names["script_label"][self.script_label], self);
	}
	if(isdefined(self.classname))
	{
		arrayremovevalue(level.struct_class_names["classname"][self.classname], self);
	}
	if(isdefined(self.script_unitrigger_type))
	{
		arrayremovevalue(level.struct_class_names["script_unitrigger_type"][self.script_unitrigger_type], self);
	}
	if(isdefined(self.scriptbundlename))
	{
		arrayremovevalue(level.struct_class_names["scriptbundlename"][self.scriptbundlename], self);
	}
	if(isdefined(self.prefabname))
	{
		arrayremovevalue(level.struct_class_names["prefabname"][self.prefabname], self);
	}
}

/*
	Name: get_script_bundle
	Namespace: struct
	Checksum: 0xF37A50F0
	Offset: 0x12A8
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function get_script_bundle(str_type, str_name)
{
	if(isdefined(level.scriptbundles[str_type]) && isdefined(level.scriptbundles[str_type][str_name]))
	{
		return level.scriptbundles[str_type][str_name];
	}
}

/*
	Name: delete_script_bundle
	Namespace: struct
	Checksum: 0x8F5993BA
	Offset: 0x1308
	Size: 0x52
	Parameters: 2
	Flags: None
*/
function delete_script_bundle(str_type, str_name)
{
	if(isdefined(level.scriptbundles[str_type]) && isdefined(level.scriptbundles[str_type][str_name]))
	{
		level.scriptbundles[str_type][str_name] = undefined;
	}
}

/*
	Name: get_script_bundles
	Namespace: struct
	Checksum: 0xACD6EAEB
	Offset: 0x1368
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function get_script_bundles(str_type)
{
	if(isdefined(level.scriptbundles) && isdefined(level.scriptbundles[str_type]))
	{
		return level.scriptbundles[str_type];
	}
	return [];
}

/*
	Name: get_script_bundle_list
	Namespace: struct
	Checksum: 0x6E491D6
	Offset: 0x13B0
	Size: 0x54
	Parameters: 2
	Flags: None
*/
function get_script_bundle_list(str_type, str_name)
{
	if(isdefined(level.scriptbundlelists[str_type]) && isdefined(level.scriptbundlelists[str_type][str_name]))
	{
		return level.scriptbundlelists[str_type][str_name];
	}
}

/*
	Name: get_script_bundle_instances
	Namespace: struct
	Checksum: 0x817C52F3
	Offset: 0x1410
	Size: 0x116
	Parameters: 2
	Flags: Linked
*/
function get_script_bundle_instances(str_type, str_name = "")
{
	a_instances = get_array("scriptbundle_" + str_type, "classname");
	if(str_name != "")
	{
		foreach(i, s_instance in a_instances)
		{
			if(s_instance.name != str_name)
			{
				arrayremoveindex(a_instances, i, 1);
			}
		}
	}
	return a_instances;
}

/*
	Name: findstruct
	Namespace: struct
	Checksum: 0x404B2231
	Offset: 0x1530
	Size: 0x314
	Parameters: 3
	Flags: Linked
*/
function findstruct(param1, name, index)
{
	if(isvec(param1))
	{
		position = param1;
		foreach(key, _ in level.struct_class_names)
		{
			foreach(s_array in level.struct_class_names[key])
			{
				foreach(struct in s_array)
				{
					if(distancesquared(struct.origin, position) < 1)
					{
						return struct;
					}
				}
			}
		}
		if(isdefined(level.struct))
		{
			foreach(struct in level.struct)
			{
				if(distancesquared(struct.origin, position) < 1)
				{
					return struct;
				}
			}
		}
	}
	else
	{
		s = get(param1);
		if(isdefined(s))
		{
			return s;
		}
		s = get_script_bundle(param1, name);
		if(isdefined(s))
		{
			if(index < 0)
			{
				return s;
			}
			if(isdefined(s.objects))
			{
				return s.objects[index];
			}
		}
	}
	return undefined;
}

