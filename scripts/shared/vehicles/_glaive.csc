// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace glaive;

/*
	Name: main
	Namespace: glaive
	Checksum: 0xCBDF1820
	Offset: 0x1B0
	Size: 0x4C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("vehicle", "glaive_blood_fx", 1, 1, "int", &glaivebloodfxhandler, 0, 0);
}

/*
	Name: glaivebloodfxhandler
	Namespace: glaive
	Checksum: 0x4F87C05D
	Offset: 0x208
	Size: 0xDC
	Parameters: 7
	Flags: Linked, Private
*/
function private glaivebloodfxhandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(isdefined(self.bloodfxhandle))
	{
		stopfx(localclientnum, self.bloodfxhandle);
		self.bloodfxhandle = undefined;
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", "glaivesettings");
	if(isdefined(settings))
	{
		if(newvalue)
		{
			self.bloodfxhandle = playfxontag(localclientnum, settings.weakspotfx, self, "j_spineupper");
		}
	}
}

