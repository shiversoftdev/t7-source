// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#namespace parasite;

/*
	Name: main
	Namespace: parasite
	Checksum: 0x8EE26695
	Offset: 0x270
	Size: 0x104
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("vehicle", "parasite_tell_fx", 1, 1, "int", &parasitetellfxhandler, 0, 0);
	clientfield::register("toplayer", "parasite_damage", 1, 1, "counter", &parasite_damage, 0, 0);
	clientfield::register("vehicle", "parasite_secondary_deathfx", 1, 1, "int", &parasitesecondarydeathfxhandler, 0, 0);
	vehicle::add_vehicletype_callback("parasite", &_setup_);
}

/*
	Name: parasitetellfxhandler
	Namespace: parasite
	Checksum: 0xBD1ACD9C
	Offset: 0x380
	Size: 0x12C
	Parameters: 7
	Flags: Linked, Private
*/
function private parasitetellfxhandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(isdefined(self.tellfxhandle))
	{
		stopfx(localclientnum, self.tellfxhandle);
		self.tellfxhandle = undefined;
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0.1);
	}
	settings = struct::get_script_bundle("vehiclecustomsettings", "parasitesettings");
	if(isdefined(settings))
	{
		if(newvalue)
		{
			self.tellfxhandle = playfxontag(localclientnum, settings.weakspotfx, self, "tag_flash");
			self mapshaderconstant(localclientnum, 0, "scriptVector2", 1);
		}
	}
}

/*
	Name: parasite_damage
	Namespace: parasite
	Checksum: 0x4AFF30DA
	Offset: 0x4B8
	Size: 0x64
	Parameters: 7
	Flags: Linked, Private
*/
function private parasite_damage(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	if(newvalue)
	{
		self postfx::playpostfxbundle("pstfx_parasite_dmg");
	}
}

/*
	Name: parasitesecondarydeathfxhandler
	Namespace: parasite
	Checksum: 0xCF923992
	Offset: 0x528
	Size: 0xE4
	Parameters: 7
	Flags: Linked, Private
*/
function private parasitesecondarydeathfxhandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	settings = struct::get_script_bundle("vehiclecustomsettings", "parasitesettings");
	if(isdefined(settings))
	{
		if(newvalue)
		{
			handle = playfx(localclientnum, settings.secondary_death_fx_1, self gettagorigin(settings.secondary_death_tag_1));
			setfxignorepause(localclientnum, handle, 1);
		}
	}
}

/*
	Name: _setup_
	Namespace: parasite
	Checksum: 0x9BEA6617
	Offset: 0x618
	Size: 0x84
	Parameters: 1
	Flags: Linked, Private
*/
function private _setup_(localclientnum)
{
	self mapshaderconstant(localclientnum, 0, "scriptVector2", 0.1);
	if(isdefined(level.debug_keyline_zombies) && level.debug_keyline_zombies)
	{
		self duplicate_render::set_dr_flag("keyline_active", 1);
		self duplicate_render::update_dr_filters(localclientnum);
	}
}

