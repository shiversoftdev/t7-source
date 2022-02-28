// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\util_shared;

#namespace notetracks;

/*
	Name: main
	Namespace: notetracks
	Checksum: 0xC0D60468
	Offset: 0x138
	Size: 0x8C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	if(sessionmodeiszombiesgame() && getdvarint("splitscreen_playerCount") > 2)
	{
		return;
	}
	if(sessionmodeiscampaigndeadopsgame() && getdvarint("splitscreen_playerCount") > 2)
	{
		return;
	}
	ai::add_ai_spawn_function(&initializenotetrackhandlers);
}

/*
	Name: initializenotetrackhandlers
	Namespace: notetracks
	Checksum: 0xCB1D4E7F
	Offset: 0x1D0
	Size: 0x84
	Parameters: 1
	Flags: Linked, Private
*/
function private initializenotetrackhandlers(localclientnum)
{
	addsurfacenotetrackfxhandler(localclientnum, "jumping", "surfacefxtable_jumping");
	addsurfacenotetrackfxhandler(localclientnum, "landing", "surfacefxtable_landing");
	addsurfacenotetrackfxhandler(localclientnum, "vtol_landing", "surfacefxtable_vtollanding");
}

/*
	Name: addsurfacenotetrackfxhandler
	Namespace: notetracks
	Checksum: 0xAD88A276
	Offset: 0x260
	Size: 0x4C
	Parameters: 3
	Flags: Linked, Private
*/
function private addsurfacenotetrackfxhandler(localclientnum, notetrack, surfacetable)
{
	entity = self;
	entity thread handlesurfacenotetrackfx(localclientnum, notetrack, surfacetable);
}

/*
	Name: handlesurfacenotetrackfx
	Namespace: notetracks
	Checksum: 0xAFA940E2
	Offset: 0x2B8
	Size: 0xB0
	Parameters: 3
	Flags: Linked, Private
*/
function private handlesurfacenotetrackfx(localclientnum, notetrack, surfacetable)
{
	entity = self;
	entity endon(#"entityshutdown");
	while(true)
	{
		entity waittill(notetrack);
		fxname = entity getaifxname(localclientnum, surfacetable);
		if(isdefined(fxname))
		{
			playfx(localclientnum, fxname, entity.origin);
		}
	}
}

