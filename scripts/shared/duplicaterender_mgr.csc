// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace duplicate_render;

/*
	Name: __init__sytem__
	Namespace: duplicate_render
	Checksum: 0x497C2333
	Offset: 0x4D0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("duplicate_render", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: duplicate_render
	Checksum: 0xC3C65DE2
	Offset: 0x510
	Size: 0x53C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!isdefined(level.drfilters))
	{
		level.drfilters = [];
	}
	callback::on_spawned(&on_player_spawned);
	callback::on_localclient_connect(&on_player_connect);
	set_dr_filter_framebuffer("none_fb", 0, undefined, undefined, 0, 1, 0);
	set_dr_filter_framebuffer_duplicate("none_fbd", 0, undefined, undefined, 1, 0, 0);
	set_dr_filter_offscreen("none_os", 0, undefined, undefined, 2, 0, 0);
	set_dr_filter_framebuffer("enveh_fb", 8, "enemyvehicle_fb", undefined, 0, 4, 1);
	set_dr_filter_framebuffer("frveh_fb", 8, "friendlyvehicle_fb", undefined, 0, 1, 1);
	set_dr_filter_offscreen("retrv", 5, "retrievable", undefined, 2, "mc/hud_keyline_retrievable", 1);
	set_dr_filter_offscreen("unplc", 7, "unplaceable", undefined, 2, "mc/hud_keyline_unplaceable", 1);
	set_dr_filter_offscreen("eneqp", 8, "enemyequip", undefined, 2, "mc/hud_outline_rim", 1);
	set_dr_filter_offscreen("enexp", 8, "enemyexplo", undefined, 2, "mc/hud_outline_rim", 1);
	set_dr_filter_offscreen("enveh", 8, "enemyvehicle", undefined, 2, "mc/hud_outline_rim", 1);
	set_dr_filter_offscreen("freqp", 8, "friendlyequip", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("frexp", 8, "friendlyexplo", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("frveh", 8, "friendlyvehicle", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("infrared", 9, "infrared_entity", undefined, 2, 2, 1);
	set_dr_filter_offscreen("threat_detector_enemy", 10, "threat_detector_enemy", undefined, 2, "mc/hud_keyline_enemyequip", 1);
	set_dr_filter_offscreen("hthacked", 5, "hacker_tool_hacked", undefined, 2, "mc/mtl_hacker_tool_hacked", 1);
	set_dr_filter_offscreen("hthacking", 5, "hacker_tool_hacking", undefined, 2, "mc/mtl_hacker_tool_hacking", 1);
	set_dr_filter_offscreen("htbreaching", 5, "hacker_tool_breaching", undefined, 2, "mc/mtl_hacker_tool_breaching", 1);
	set_dr_filter_offscreen("bcarrier", 9, "ballcarrier", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("poption", 9, "passoption", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("prop_look_through", 9, "prop_look_through", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("prop_ally", 8, "prop_ally", undefined, 2, "mc/hud_keyline_friendlyequip", 1);
	set_dr_filter_offscreen("prop_clone", 7, "prop_clone", undefined, 2, "mc/hud_keyline_ph_yellow", 1);
	level.friendlycontentoutlines = getdvarint("friendlyContentOutlines", 0);
}

/*
	Name: on_player_spawned
	Namespace: duplicate_render
	Checksum: 0xB8BC233
	Offset: 0xA58
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function on_player_spawned(local_client_num)
{
	self.currentdrfilter = [];
	self change_dr_flags(local_client_num);
	if(!level flagsys::get("duplicaterender_registry_ready"))
	{
		wait(0.016);
		level flagsys::set("duplicaterender_registry_ready");
	}
}

/*
	Name: on_player_connect
	Namespace: duplicate_render
	Checksum: 0x496BAB69
	Offset: 0xAE0
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function on_player_connect(localclientnum)
{
	level wait_team_changed(localclientnum);
}

/*
	Name: wait_team_changed
	Namespace: duplicate_render
	Checksum: 0xD432CA10
	Offset: 0xB10
	Size: 0x88
	Parameters: 1
	Flags: Linked
*/
function wait_team_changed(localclientnum)
{
	while(true)
	{
		level waittill(#"team_changed");
		while(!isdefined(getlocalplayer(localclientnum)))
		{
			wait(0.05);
		}
		player = getlocalplayer(localclientnum);
		player codcaster_keyline_enable(0);
	}
}

/*
	Name: set_dr_filter
	Namespace: duplicate_render
	Checksum: 0xCB29D2C9
	Offset: 0xBA0
	Size: 0x3B4
	Parameters: 14
	Flags: Linked
*/
function set_dr_filter(filterset, name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3)
{
	if(!isdefined(level.drfilters))
	{
		level.drfilters = [];
	}
	if(!isdefined(level.drfilters[filterset]))
	{
		level.drfilters[filterset] = [];
	}
	if(!isdefined(level.drfilters[filterset][name]))
	{
		level.drfilters[filterset][name] = spawnstruct();
	}
	filter = level.drfilters[filterset][name];
	filter.name = name;
	filter.priority = priority * -1;
	if(!isdefined(require_flags))
	{
		filter.require = [];
	}
	else
	{
		if(isarray(require_flags))
		{
			filter.require = require_flags;
		}
		else
		{
			filter.require = strtok(require_flags, ",");
		}
	}
	if(!isdefined(refuse_flags))
	{
		filter.refuse = [];
	}
	else
	{
		if(isarray(refuse_flags))
		{
			filter.refuse = refuse_flags;
		}
		else
		{
			filter.refuse = strtok(refuse_flags, ",");
		}
	}
	filter.types = [];
	filter.values = [];
	filter.culling = [];
	if(isdefined(drtype1))
	{
		idx = filter.types.size;
		filter.types[idx] = drtype1;
		filter.values[idx] = drval1;
		filter.culling[idx] = drcull1;
	}
	if(isdefined(drtype2))
	{
		idx = filter.types.size;
		filter.types[idx] = drtype2;
		filter.values[idx] = drval2;
		filter.culling[idx] = drcull2;
	}
	if(isdefined(drtype3))
	{
		idx = filter.types.size;
		filter.types[idx] = drtype3;
		filter.values[idx] = drval3;
		filter.culling[idx] = drcull3;
	}
	thread register_filter_materials(filter);
}

/*
	Name: set_dr_filter_framebuffer
	Namespace: duplicate_render
	Checksum: 0xDC5CA25A
	Offset: 0xF60
	Size: 0xBC
	Parameters: 13
	Flags: Linked
*/
function set_dr_filter_framebuffer(name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3)
{
	set_dr_filter("framebuffer", name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3);
}

/*
	Name: set_dr_filter_framebuffer_duplicate
	Namespace: duplicate_render
	Checksum: 0x32073C41
	Offset: 0x1028
	Size: 0xBC
	Parameters: 13
	Flags: Linked
*/
function set_dr_filter_framebuffer_duplicate(name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3)
{
	set_dr_filter("framebuffer_duplicate", name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3);
}

/*
	Name: set_dr_filter_offscreen
	Namespace: duplicate_render
	Checksum: 0xE6B67E0C
	Offset: 0x10F0
	Size: 0xBC
	Parameters: 13
	Flags: Linked
*/
function set_dr_filter_offscreen(name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3)
{
	set_dr_filter("offscreen", name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3);
}

/*
	Name: register_filter_materials
	Namespace: duplicate_render
	Checksum: 0xB54A7FAA
	Offset: 0x11B8
	Size: 0x1A0
	Parameters: 1
	Flags: Linked
*/
function register_filter_materials(filter)
{
	playercount = undefined;
	opts = filter.types.size;
	for(i = 0; i < opts; i++)
	{
		value = filter.values[i];
		if(isstring(value))
		{
			if(!isdefined(playercount))
			{
				while(!isdefined(level.localplayers) && !isdefined(level.frontendclientconnected))
				{
					wait(0.016);
				}
				if(isdefined(level.frontendclientconnected))
				{
					playercount = 1;
				}
				else
				{
					util::waitforallclients();
					playercount = level.localplayers.size;
				}
			}
			if(!isdefined(filter::mapped_material_id(value)))
			{
				for(localclientnum = 0; localclientnum < playercount; localclientnum++)
				{
					filter::map_material_helper_by_localclientnum(localclientnum, value);
				}
			}
		}
	}
	filter.priority = abs(filter.priority);
}

/*
	Name: update_dr_flag
	Namespace: duplicate_render
	Checksum: 0x307A9179
	Offset: 0x1360
	Size: 0x64
	Parameters: 3
	Flags: Linked
*/
function update_dr_flag(localclientnum, toset, setto = 1)
{
	if(set_dr_flag(toset, setto))
	{
		update_dr_filters(localclientnum);
	}
}

/*
	Name: set_dr_flag_not_array
	Namespace: duplicate_render
	Checksum: 0x74CFEAEF
	Offset: 0x13D0
	Size: 0xD0
	Parameters: 2
	Flags: Linked
*/
function set_dr_flag_not_array(toset, setto = 1)
{
	if(!isdefined(self.flag) || !isdefined(self.flag[toset]))
	{
		self flag::init(toset);
	}
	if(setto == self.flag[toset])
	{
		return false;
	}
	if(isdefined(setto) && setto)
	{
		self flag::set(toset);
	}
	else
	{
		self flag::clear(toset);
	}
	return true;
}

/*
	Name: set_dr_flag
	Namespace: duplicate_render
	Checksum: 0x461CE453
	Offset: 0x14A8
	Size: 0x198
	Parameters: 2
	Flags: Linked
*/
function set_dr_flag(toset, setto = 1)
{
	/#
		assert(isdefined(setto));
	#/
	if(isarray(toset))
	{
		foreach(ts in toset)
		{
			set_dr_flag(ts, setto);
		}
		return;
	}
	if(!isdefined(self.flag) || !isdefined(self.flag[toset]))
	{
		self flag::init(toset);
	}
	if(setto == self.flag[toset])
	{
		return false;
	}
	if(isdefined(setto) && setto)
	{
		self flag::set(toset);
	}
	else
	{
		self flag::clear(toset);
	}
	return true;
}

/*
	Name: clear_dr_flag
	Namespace: duplicate_render
	Checksum: 0x5DAEF493
	Offset: 0x1648
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function clear_dr_flag(toclear)
{
	set_dr_flag(toclear, 0);
}

/*
	Name: change_dr_flags
	Namespace: duplicate_render
	Checksum: 0x60513159
	Offset: 0x1678
	Size: 0xF4
	Parameters: 3
	Flags: Linked
*/
function change_dr_flags(localclientnum, toset, toclear)
{
	if(isdefined(toset))
	{
		if(isstring(toset))
		{
			toset = strtok(toset, ",");
		}
		self set_dr_flag(toset);
	}
	if(isdefined(toclear))
	{
		if(isstring(toclear))
		{
			toclear = strtok(toclear, ",");
		}
		self clear_dr_flag(toclear);
	}
	update_dr_filters(localclientnum);
}

/*
	Name: _update_dr_filters
	Namespace: duplicate_render
	Checksum: 0x5D7EC2FF
	Offset: 0x1778
	Size: 0x122
	Parameters: 1
	Flags: Linked
*/
function _update_dr_filters(localclientnum)
{
	self notify(#"update_dr_filters");
	self endon(#"update_dr_filters");
	self endon(#"entityshutdown");
	waittillframeend();
	foreach(key, filterset in level.drfilters)
	{
		filter = self find_dr_filter(filterset);
		if(isdefined(filter) && (!isdefined(self.currentdrfilter) || !self.currentdrfilter[key] === filter.name))
		{
			self apply_filter(localclientnum, filter, key);
		}
	}
}

/*
	Name: update_dr_filters
	Namespace: duplicate_render
	Checksum: 0x4EF65EA6
	Offset: 0x18A8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function update_dr_filters(localclientnum)
{
	self thread _update_dr_filters(localclientnum);
}

/*
	Name: find_dr_filter
	Namespace: duplicate_render
	Checksum: 0x701AB3F1
	Offset: 0x18D8
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function find_dr_filter(filterset = level.drfilters["framebuffer"])
{
	best = undefined;
	foreach(filter in filterset)
	{
		if(self can_use_filter(filter))
		{
			if(!isdefined(best) || filter.priority > best.priority)
			{
				best = filter;
			}
		}
	}
	return best;
}

/*
	Name: can_use_filter
	Namespace: duplicate_render
	Checksum: 0x109F258C
	Offset: 0x19E0
	Size: 0xC8
	Parameters: 1
	Flags: Linked
*/
function can_use_filter(filter)
{
	for(i = 0; i < filter.require.size; i++)
	{
		if(!self flagsys::get(filter.require[i]))
		{
			return false;
		}
	}
	for(i = 0; i < filter.refuse.size; i++)
	{
		if(self flagsys::get(filter.refuse[i]))
		{
			return false;
		}
	}
	return true;
}

/*
	Name: apply_filter
	Namespace: duplicate_render
	Checksum: 0x48752A49
	Offset: 0x1AB0
	Size: 0x364
	Parameters: 3
	Flags: Linked
*/
function apply_filter(localclientnum, filter, filterset = "framebuffer")
{
	if(isdefined(level.postgame) && level.postgame && (!(isdefined(level.showedtopthreeplayers) && level.showedtopthreeplayers)))
	{
		player = getlocalplayer(localclientnum);
		if(!player getinkillcam(localclientnum))
		{
			return;
		}
	}
	/#
		if(getdvarint(""))
		{
			name = "";
			if(self isplayer())
			{
				if(isdefined(self.name))
				{
					name = "" + self.name;
				}
			}
			else if(isdefined(self.model))
			{
				name = name + ("" + self.model);
			}
			msg = (((("" + filter.name) + "") + name) + "") + filterset;
			println(msg);
		}
	#/
	if(!isdefined(self.currentdrfilter))
	{
		self.currentdrfilter = [];
	}
	self.currentdrfilter[filterset] = filter.name;
	opts = filter.types.size;
	for(i = 0; i < opts; i++)
	{
		type = filter.types[i];
		value = filter.values[i];
		culling = filter.culling[i];
		material = undefined;
		if(isstring(value))
		{
			material = filter::mapped_material_id(value);
			value = 3;
			if(isdefined(value) && isdefined(material))
			{
				self addduplicaterenderoption(type, value, material, culling);
			}
			else
			{
				self.currentdrfilter[filterset] = undefined;
			}
			continue;
		}
		self addduplicaterenderoption(type, value, -1, culling);
	}
	if(sessionmodeismultiplayergame())
	{
		self thread disable_all_filters_on_game_ended();
	}
}

/*
	Name: disable_all_filters_on_game_ended
	Namespace: duplicate_render
	Checksum: 0xB86234DF
	Offset: 0x1E20
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function disable_all_filters_on_game_ended()
{
	self endon(#"entityshutdown");
	self notify(#"disable_all_filters_on_game_ended");
	self endon(#"disable_all_filters_on_game_ended");
	level waittill(#"post_game");
	self disableduplicaterendering();
}

/*
	Name: set_item_retrievable
	Namespace: duplicate_render
	Checksum: 0xB4BF1258
	Offset: 0x1E78
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function set_item_retrievable(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "retrievable", on_off);
}

/*
	Name: set_item_unplaceable
	Namespace: duplicate_render
	Checksum: 0xFC573133
	Offset: 0x1EC0
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_item_unplaceable(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "unplaceable", on_off);
}

/*
	Name: set_item_enemy_equipment
	Namespace: duplicate_render
	Checksum: 0x69FDC590
	Offset: 0x1F08
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function set_item_enemy_equipment(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "enemyequip", on_off);
}

/*
	Name: set_item_friendly_equipment
	Namespace: duplicate_render
	Checksum: 0x184C4AC5
	Offset: 0x1F50
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function set_item_friendly_equipment(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "friendlyequip", on_off);
}

/*
	Name: set_item_enemy_explosive
	Namespace: duplicate_render
	Checksum: 0x30626352
	Offset: 0x1F98
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_item_enemy_explosive(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "enemyexplo", on_off);
}

/*
	Name: set_item_friendly_explosive
	Namespace: duplicate_render
	Checksum: 0xD1E11E6
	Offset: 0x1FE0
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_item_friendly_explosive(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "friendlyexplo", on_off);
}

/*
	Name: set_item_enemy_vehicle
	Namespace: duplicate_render
	Checksum: 0xFEF61605
	Offset: 0x2028
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_item_enemy_vehicle(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "enemyvehicle", on_off);
}

/*
	Name: set_item_friendly_vehicle
	Namespace: duplicate_render
	Checksum: 0xC5C62DE3
	Offset: 0x2070
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_item_friendly_vehicle(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "friendlyvehicle", on_off);
}

/*
	Name: set_entity_thermal
	Namespace: duplicate_render
	Checksum: 0xA733342A
	Offset: 0x20B8
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_entity_thermal(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "infrared_entity", on_off);
}

/*
	Name: set_player_threat_detected
	Namespace: duplicate_render
	Checksum: 0x82D480D6
	Offset: 0x2100
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_player_threat_detected(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "threat_detector_enemy", on_off);
}

/*
	Name: set_hacker_tool_hacked
	Namespace: duplicate_render
	Checksum: 0x66D5F1E4
	Offset: 0x2148
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_hacker_tool_hacked(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "hacker_tool_hacked", on_off);
}

/*
	Name: set_hacker_tool_hacking
	Namespace: duplicate_render
	Checksum: 0x705F2D36
	Offset: 0x2190
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function set_hacker_tool_hacking(localclientnum, on_off)
{
	self update_dr_flag(localclientnum, "hacker_tool_hacking", on_off);
}

/*
	Name: set_hacker_tool_breaching
	Namespace: duplicate_render
	Checksum: 0x95FA120D
	Offset: 0x21D8
	Size: 0xD4
	Parameters: 2
	Flags: None
*/
function set_hacker_tool_breaching(localclientnum, on_off)
{
	flags_changed = self set_dr_flag("hacker_tool_breaching", on_off);
	if(on_off)
	{
		flags_changed = self set_dr_flag("enemyvehicle", 0) || flags_changed;
	}
	else if(isdefined(self.isenemyvehicle) && self.isenemyvehicle)
	{
		flags_changed = self set_dr_flag("enemyvehicle", 1) || flags_changed;
	}
	if(flags_changed)
	{
		update_dr_filters(localclientnum);
	}
}

/*
	Name: show_friendly_outlines
	Namespace: duplicate_render
	Checksum: 0x25D22344
	Offset: 0x22B8
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function show_friendly_outlines(local_client_num)
{
	if(!(isdefined(level.friendlycontentoutlines) && level.friendlycontentoutlines))
	{
		return false;
	}
	if(isshoutcaster(local_client_num))
	{
		return false;
	}
	return true;
}

