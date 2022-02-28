// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace turret;

/*
	Name: __init__sytem__
	Namespace: turret
	Checksum: 0x161D6694
	Offset: 0x170
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("turret", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: turret
	Checksum: 0x24BC1512
	Offset: 0x1B0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("vehicle", "toggle_lensflare", 1, 1, "int", &field_toggle_lensflare, 0, 0);
}

/*
	Name: field_toggle_lensflare
	Namespace: turret
	Checksum: 0x5D22DAE
	Offset: 0x208
	Size: 0x120
	Parameters: 7
	Flags: Linked
*/
function field_toggle_lensflare(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(self.scriptbundlesettings))
	{
		return;
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", self.scriptbundlesettings);
	if(!isdefined(settings))
	{
		return;
	}
	if(isdefined(self.turret_lensflare_id))
	{
		deletefx(localclientnum, self.turret_lensflare_id);
		self.turret_lensflare_id = undefined;
	}
	if(newval)
	{
		if(isdefined(settings.lensflare_fx) && isdefined(settings.lensflare_tag))
		{
			self.turret_lensflare_id = playfxontag(localclientnum, settings.lensflare_fx, self, settings.lensflare_tag);
		}
	}
}

