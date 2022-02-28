// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace aat;

/*
	Name: __init__sytem__
	Namespace: aat
	Checksum: 0x7A1F1815
	Offset: 0x150
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("aat", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: aat
	Checksum: 0x79F2846A
	Offset: 0x190
	Size: 0x84
	Parameters: 0
	Flags: Linked, Private
*/
function private __init__()
{
	level.aat_initializing = 1;
	level.aat_default_info_name = "none";
	level.aat_default_info_icon = "blacktransparent";
	level.aat = [];
	register("none", level.aat_default_info_name, level.aat_default_info_icon);
	callback::on_finalize_initialization(&finalize_clientfields);
}

/*
	Name: register
	Namespace: aat
	Checksum: 0xC478BD7C
	Offset: 0x220
	Size: 0x178
	Parameters: 3
	Flags: Linked
*/
function register(name, localized_string, icon)
{
	/#
		assert(isdefined(level.aat_initializing) && level.aat_initializing, "");
	#/
	/#
		assert(isdefined(name), "");
	#/
	/#
		assert(!isdefined(level.aat[name]), ("" + name) + "");
	#/
	/#
		assert(isdefined(localized_string), "");
	#/
	/#
		assert(isdefined(icon), "");
	#/
	level.aat[name] = spawnstruct();
	level.aat[name].name = name;
	level.aat[name].localized_string = localized_string;
	level.aat[name].icon = icon;
}

/*
	Name: aat_hud_manager
	Namespace: aat
	Checksum: 0x3E92723B
	Offset: 0x3A0
	Size: 0x74
	Parameters: 7
	Flags: Linked
*/
function aat_hud_manager(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(isdefined(level.update_aat_hud))
	{
		[[level.update_aat_hud]](localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
	}
}

/*
	Name: finalize_clientfields
	Namespace: aat
	Checksum: 0xD278F4B0
	Offset: 0x420
	Size: 0x190
	Parameters: 0
	Flags: Linked
*/
function finalize_clientfields()
{
	/#
		println("");
	#/
	if(level.aat.size > 1)
	{
		array::alphabetize(level.aat);
		i = 0;
		foreach(aat in level.aat)
		{
			aat.n_index = i;
			i++;
			/#
				println("" + aat.name);
			#/
		}
		n_bits = getminbitcountfornum(level.aat.size - 1);
		clientfield::register("toplayer", "aat_current", 1, n_bits, "int", &aat_hud_manager, 0, 1);
	}
	level.aat_initializing = 0;
}

/*
	Name: get_string
	Namespace: aat
	Checksum: 0x958679C9
	Offset: 0x5B8
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function get_string(n_aat_index)
{
	foreach(aat in level.aat)
	{
		if(aat.n_index == n_aat_index)
		{
			return aat.localized_string;
		}
	}
	return level.aat_default_info_name;
}

/*
	Name: get_icon
	Namespace: aat
	Checksum: 0xB001F4E2
	Offset: 0x670
	Size: 0xAA
	Parameters: 1
	Flags: Linked
*/
function get_icon(n_aat_index)
{
	foreach(aat in level.aat)
	{
		if(aat.n_index == n_aat_index)
		{
			return aat.icon;
		}
	}
	return level.aat_default_info_icon;
}

