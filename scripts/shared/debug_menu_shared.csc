// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#namespace debug_menu;

/*
	Name: open
	Namespace: debug_menu
	Checksum: 0xDA27FA8C
	Offset: 0x138
	Size: 0xC4
	Parameters: 2
	Flags: None
*/
function open(localclientnum, a_menu_items)
{
	close(localclientnum);
	level flagsys::set("menu_open");
	populatescriptdebugmenu(localclientnum, a_menu_items);
	luiload("uieditor.menus.ScriptDebugMenu");
	level.scriptdebugmenu = createluimenu(localclientnum, "ScriptDebugMenu");
	openluimenu(localclientnum, level.scriptdebugmenu);
}

/*
	Name: close
	Namespace: debug_menu
	Checksum: 0x1625BACB
	Offset: 0x208
	Size: 0x5E
	Parameters: 1
	Flags: None
*/
function close(localclientnum)
{
	level flagsys::clear("menu_open");
	if(isdefined(level.scriptdebugmenu))
	{
		closeluimenu(localclientnum, level.scriptdebugmenu);
		level.scriptdebugmenu = undefined;
	}
}

/*
	Name: set_item_text
	Namespace: debug_menu
	Checksum: 0xCCAC289
	Offset: 0x270
	Size: 0xB4
	Parameters: 3
	Flags: None
*/
function set_item_text(localclientnum, index, name)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	parentmodel = getuimodel(controllermodel, "cscDebugMenu.listItem" + index);
	model = getuimodel(parentmodel, "name");
	setuimodelvalue(model, name);
}

/*
	Name: set_item_color
	Namespace: debug_menu
	Checksum: 0x7E599460
	Offset: 0x330
	Size: 0x11C
	Parameters: 3
	Flags: None
*/
function set_item_color(localclientnum, index, color)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	parentmodel = getuimodel(controllermodel, "cscDebugMenu.listItem" + index);
	model = getuimodel(parentmodel, "color");
	if(isvec(color))
	{
		color = ((("" + (color[0] * 255)) + " ") + (color[1] * 255) + " ") + (color[2] * 255);
	}
	setuimodelvalue(model, color);
}

