// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace gibclientutils;

/*
	Name: main
	Namespace: gibclientutils
	Checksum: 0x79A307F1
	Offset: 0x208
	Size: 0x434
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "gib_state", 1, 9, "int", &_gibhandler, 0, 0);
	clientfield::register("playercorpse", "gib_state", 1, 15, "int", &_gibhandler, 0, 0);
	gibdefinitions = struct::get_script_bundles("gibcharacterdef");
	gibpiecelookup = [];
	gibpiecelookup[2] = "annihilate";
	gibpiecelookup[8] = "head";
	gibpiecelookup[16] = "rightarm";
	gibpiecelookup[32] = "leftarm";
	gibpiecelookup[128] = "rightleg";
	gibpiecelookup[256] = "leftleg";
	processedbundles = [];
	foreach(definitionname, definition in gibdefinitions)
	{
		gibbundle = spawnstruct();
		gibbundle.gibs = [];
		gibbundle.name = definitionname;
		foreach(gibpieceflag, gibpiecename in gibpiecelookup)
		{
			gibstruct = spawnstruct();
			gibstruct.gibmodel = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibmodel");
			gibstruct.gibtag = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibtag");
			gibstruct.gibfx = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibfx");
			gibstruct.gibfxtag = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibeffecttag");
			gibstruct.gibdynentfx = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibdynentfx");
			gibstruct.gibsound = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibsound");
			gibbundle.gibs[gibpieceflag] = gibstruct;
		}
		processedbundles[definitionname] = gibbundle;
	}
	level.scriptbundles["gibcharacterdef"] = processedbundles;
	level thread _annihilatecorpse();
}

/*
	Name: _annihilatecorpse
	Namespace: gibclientutils
	Checksum: 0x19FDF876
	Offset: 0x648
	Size: 0x1F8
	Parameters: 0
	Flags: Linked, Private
*/
function private _annihilatecorpse()
{
	while(true)
	{
		level waittill(#"corpse_explode", localclientnum, body, origin);
		if(!util::is_mature() || util::is_gib_restricted_build())
		{
			continue;
		}
		if(isdefined(body) && _hasgibdef(body) && body isragdoll())
		{
			cliententgibhead(localclientnum, body);
			cliententgibrightarm(localclientnum, body);
			cliententgibleftarm(localclientnum, body);
			cliententgibrightleg(localclientnum, body);
			cliententgibleftleg(localclientnum, body);
		}
		if(isdefined(body) && _hasgibdef(body) && body.archetype == "human")
		{
			if(randomint(100) >= 50)
			{
				continue;
			}
			if(isdefined(origin) && distancesquared(body.origin, origin) <= 14400)
			{
				body.ignoreragdoll = 1;
				body _gibentity(localclientnum, 50 | 384, 1);
			}
		}
	}
}

/*
	Name: _clonegibdata
	Namespace: gibclientutils
	Checksum: 0x41014BCC
	Offset: 0x848
	Size: 0x20C
	Parameters: 3
	Flags: Linked, Private
*/
function private _clonegibdata(localclientnum, entity, clone)
{
	clone.gib_data = spawnstruct();
	clone.gib_data.gib_state = entity.gib_state;
	clone.gib_data.gibdef = entity.gibdef;
	clone.gib_data.hatmodel = entity.hatmodel;
	clone.gib_data.head = entity.head;
	clone.gib_data.legdmg1 = entity.legdmg1;
	clone.gib_data.legdmg2 = entity.legdmg2;
	clone.gib_data.legdmg3 = entity.legdmg3;
	clone.gib_data.legdmg4 = entity.legdmg4;
	clone.gib_data.torsodmg1 = entity.torsodmg1;
	clone.gib_data.torsodmg2 = entity.torsodmg2;
	clone.gib_data.torsodmg3 = entity.torsodmg3;
	clone.gib_data.torsodmg4 = entity.torsodmg4;
	clone.gib_data.torsodmg5 = entity.torsodmg5;
}

/*
	Name: _getgibdef
	Namespace: gibclientutils
	Checksum: 0x51917E21
	Offset: 0xA60
	Size: 0x92
	Parameters: 1
	Flags: Linked, Private
*/
function private _getgibdef(entity)
{
	if(entity isplayer() || entity isplayercorpse())
	{
		return entity getplayergibdef();
	}
	if(isdefined(entity.gib_data))
	{
		return entity.gib_data.gibdef;
	}
	return entity.gibdef;
}

/*
	Name: _getgibbedstate
	Namespace: gibclientutils
	Checksum: 0xF077F9C0
	Offset: 0xB00
	Size: 0x86
	Parameters: 2
	Flags: Linked, Private
*/
function private _getgibbedstate(localclientnum, entity)
{
	if(isdefined(entity.gib_data) && isdefined(entity.gib_data.gib_state))
	{
		return entity.gib_data.gib_state;
	}
	if(isdefined(entity.gib_state))
	{
		return entity.gib_state;
	}
	return 0;
}

/*
	Name: _getgibbedlegmodel
	Namespace: gibclientutils
	Checksum: 0xB4C565C0
	Offset: 0xB90
	Size: 0x17E
	Parameters: 2
	Flags: Linked, Private
*/
function private _getgibbedlegmodel(localclientnum, entity)
{
	gibstate = _getgibbedstate(localclientnum, entity);
	rightleggibbed = gibstate & 128;
	leftleggibbed = gibstate & 256;
	if(rightleggibbed && leftleggibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.legdmg4 : entity.legdmg4);
	}
	if(rightleggibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.legdmg2 : entity.legdmg2);
	}
	if(leftleggibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.legdmg3 : entity.legdmg3);
	}
	return (isdefined(entity.gib_data) ? entity.gib_data.legdmg1 : entity.legdmg1);
}

/*
	Name: _getgibextramodel
	Namespace: gibclientutils
	Checksum: 0xFE07E53D
	Offset: 0xD18
	Size: 0xD4
	Parameters: 3
	Flags: Linked, Private
*/
function private _getgibextramodel(localclientnumm, entity, gibflag)
{
	if(gibflag == 4)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.hatmodel : entity.hatmodel);
	}
	if(gibflag == 8)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.head : entity.head);
	}
	/#
		assertmsg("");
	#/
}

/*
	Name: _getgibbedtorsomodel
	Namespace: gibclientutils
	Checksum: 0xF5514252
	Offset: 0xDF8
	Size: 0x17E
	Parameters: 2
	Flags: Linked, Private
*/
function private _getgibbedtorsomodel(localclientnum, entity)
{
	gibstate = _getgibbedstate(localclientnum, entity);
	rightarmgibbed = gibstate & 16;
	leftarmgibbed = gibstate & 32;
	if(rightarmgibbed && leftarmgibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.torsodmg2 : entity.torsodmg2);
	}
	if(rightarmgibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.torsodmg2 : entity.torsodmg2);
	}
	if(leftarmgibbed)
	{
		return (isdefined(entity.gib_data) ? entity.gib_data.torsodmg3 : entity.torsodmg3);
	}
	return (isdefined(entity.gib_data) ? entity.gib_data.torsodmg1 : entity.torsodmg1);
}

/*
	Name: _gibpiecetag
	Namespace: gibclientutils
	Checksum: 0xC9277A10
	Offset: 0xF80
	Size: 0xB4
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibpiecetag(localclientnum, entity, gibflag)
{
	if(!_hasgibdef(self))
	{
		return;
	}
	gibbundle = struct::get_script_bundle("gibcharacterdef", _getgibdef(entity));
	gibpiece = gibbundle.gibs[gibflag];
	if(isdefined(gibpiece))
	{
		return gibpiece.gibfxtag;
	}
}

/*
	Name: _gibentity
	Namespace: gibclientutils
	Checksum: 0x227FAC2A
	Offset: 0x1040
	Size: 0x2A0
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibentity(localclientnum, gibflags, shouldspawngibs)
{
	entity = self;
	if(!_hasgibdef(entity))
	{
		return;
	}
	currentgibflag = 2;
	gibdir = undefined;
	if(entity isplayer() || entity isplayercorpse())
	{
		yaw_bits = (gibflags >> 9) & (8 - 1);
		yaw = getanglefrombits(yaw_bits, 3);
		gibdir = anglestoforward((0, yaw, 0));
	}
	gibbundle = struct::get_script_bundle("gibcharacterdef", _getgibdef(entity));
	while(gibflags >= currentgibflag)
	{
		if(gibflags & currentgibflag)
		{
			gibpiece = gibbundle.gibs[currentgibflag];
			if(isdefined(gibpiece))
			{
				if(shouldspawngibs)
				{
					entity thread _gibpiece(localclientnum, entity, gibpiece.gibmodel, gibpiece.gibtag, gibpiece.gibdynentfx, gibdir);
				}
				_playgibfx(localclientnum, entity, gibpiece.gibfx, gibpiece.gibfxtag);
				_playgibsound(localclientnum, entity, gibpiece.gibsound);
				if(currentgibflag == 2)
				{
					entity hide();
					entity.ignoreragdoll = 1;
				}
			}
			_handlegibcallbacks(localclientnum, entity, currentgibflag);
		}
		currentgibflag = currentgibflag << 1;
	}
}

/*
	Name: _setgibbed
	Namespace: gibclientutils
	Checksum: 0xC67CD0A3
	Offset: 0x12E8
	Size: 0x98
	Parameters: 3
	Flags: Linked, Private
*/
function private _setgibbed(localclientnum, entity, gibflag)
{
	gib_state = _getgibbedstate(localclientnum, entity) | (gibflag & (512 - 1));
	if(isdefined(entity.gib_data))
	{
		entity.gib_data.gib_state = gib_state;
	}
	else
	{
		entity.gib_state = gib_state;
	}
}

/*
	Name: _gibcliententityinternal
	Namespace: gibclientutils
	Checksum: 0x9B25048B
	Offset: 0x1388
	Size: 0x1C4
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibcliententityinternal(localclientnum, entity, gibflag)
{
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	if(!isdefined(entity) || !_hasgibdef(entity))
	{
		return;
	}
	if(entity.type !== "scriptmover")
	{
		return;
	}
	if(isgibbed(localclientnum, entity, gibflag))
	{
		return;
	}
	if(!_getgibbedstate(localclientnum, entity) < 16)
	{
		legmodel = _getgibbedlegmodel(localclientnum, entity);
		entity detach(legmodel, "");
	}
	_setgibbed(localclientnum, entity, gibflag);
	entity setmodel(_getgibbedtorsomodel(localclientnum, entity));
	entity attach(_getgibbedlegmodel(localclientnum, entity), "");
	entity _gibentity(localclientnum, gibflag, 1);
}

/*
	Name: _gibclientextrainternal
	Namespace: gibclientutils
	Checksum: 0xA71976E1
	Offset: 0x1558
	Size: 0x1EC
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibclientextrainternal(localclientnum, entity, gibflag)
{
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	if(!isdefined(entity))
	{
		return;
	}
	if(entity.type !== "scriptmover")
	{
		return;
	}
	if(isgibbed(localclientnum, entity, gibflag))
	{
		return;
	}
	gibmodel = _getgibextramodel(localclientnum, entity, gibflag);
	if(isdefined(gibmodel) && entity isattached(gibmodel, ""))
	{
		entity detach(gibmodel, "");
	}
	if(gibflag == 8)
	{
		if(isdefined((isdefined(entity.gib_data) ? entity.gib_data.torsodmg5 : entity.torsodmg5)))
		{
			entity attach((isdefined(entity.gib_data) ? entity.gib_data.torsodmg5 : entity.torsodmg5), "");
		}
	}
	_setgibbed(localclientnum, entity, gibflag);
	entity _gibentity(localclientnum, gibflag, 1);
}

/*
	Name: _gibhandler
	Namespace: gibclientutils
	Checksum: 0x8F4D523D
	Offset: 0x1750
	Size: 0x1B0
	Parameters: 7
	Flags: Linked, Private
*/
function private _gibhandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	if(entity isplayer() || entity isplayercorpse())
	{
		if(!util::is_mature() || util::is_gib_restricted_build())
		{
			return;
		}
	}
	else
	{
		if(isdefined(entity.maturegib) && entity.maturegib && !util::is_mature())
		{
			return;
		}
		if(isdefined(entity.restrictedgib) && entity.restrictedgib && !isshowgibsenabled())
		{
			return;
		}
	}
	gibflags = oldvalue ^ newvalue;
	shouldspawngibs = !newvalue & 1;
	if(bnewent)
	{
		gibflags = 0 ^ newvalue;
	}
	entity _gibentity(localclientnum, gibflags, shouldspawngibs);
	entity.gib_state = newvalue;
}

/*
	Name: _gibpiece
	Namespace: gibclientutils
	Checksum: 0x9567B73A
	Offset: 0x1908
	Size: 0x304
	Parameters: 6
	Flags: Linked
*/
function _gibpiece(localclientnum, entity, gibmodel, gibtag, gibfx, gibdir)
{
	if(!isdefined(gibtag) || !isdefined(gibmodel))
	{
		return;
	}
	startposition = entity gettagorigin(gibtag);
	startangles = entity gettagangles(gibtag);
	endposition = startposition;
	endangles = startangles;
	forwardvector = undefined;
	if(!isdefined(startposition) || !isdefined(startangles))
	{
		return false;
	}
	if(isdefined(gibdir))
	{
		startposition = (0, 0, 0);
		forwardvector = gibdir;
		forwardvector = forwardvector * randomfloatrange(100, 500);
	}
	else
	{
		wait(0.016);
		if(isdefined(entity))
		{
			endposition = entity gettagorigin(gibtag);
			endangles = entity gettagangles(gibtag);
		}
		else
		{
			endposition = startposition + (anglestoforward(startangles) * 10);
			endangles = startangles;
		}
		if(!isdefined(endposition) || !isdefined(endangles))
		{
			return false;
		}
		forwardvector = vectornormalize(endposition - startposition);
		forwardvector = forwardvector * randomfloatrange(0.6, 1);
		forwardvector = forwardvector + (randomfloatrange(0, 0.2), randomfloatrange(0, 0.2), randomfloatrange(0.2, 0.7));
	}
	if(isdefined(entity))
	{
		gibentity = createdynentandlaunch(localclientnum, gibmodel, endposition, endangles, startposition, forwardvector, gibfx, 1);
		if(isdefined(gibentity))
		{
			setdynentbodyrenderoptionspacked(gibentity, entity getbodyrenderoptionspacked());
		}
	}
}

/*
	Name: _handlegibcallbacks
	Namespace: gibclientutils
	Checksum: 0x9789438D
	Offset: 0x1C18
	Size: 0xDE
	Parameters: 3
	Flags: Linked, Private
*/
function private _handlegibcallbacks(localclientnum, entity, gibflag)
{
	if(isdefined(entity._gibcallbacks) && isdefined(entity._gibcallbacks[gibflag]))
	{
		foreach(callback in entity._gibcallbacks[gibflag])
		{
			[[callback]](localclientnum, entity, gibflag);
		}
	}
}

/*
	Name: _handlegibannihilate
	Namespace: gibclientutils
	Checksum: 0x2230DBA5
	Offset: 0x1D00
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibannihilate(localclientnum)
{
	entity = self;
	entity endon(#"entityshutdown");
	entity waittillmatch(#"_anim_notify_");
	cliententgibannihilate(localclientnum, entity);
}

/*
	Name: _handlegibhead
	Namespace: gibclientutils
	Checksum: 0x12A546E0
	Offset: 0x1D68
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibhead(localclientnum)
{
	entity = self;
	entity endon(#"entityshutdown");
	entity waittillmatch(#"_anim_notify_");
	cliententgibhead(localclientnum, entity);
}

/*
	Name: _handlegibrightarm
	Namespace: gibclientutils
	Checksum: 0xCC7FEB5C
	Offset: 0x1DD0
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibrightarm(localclientnum)
{
	entity = self;
	entity endon(#"entityshutdown");
	entity waittillmatch(#"_anim_notify_");
	cliententgibrightarm(localclientnum, entity);
}

/*
	Name: _handlegibleftarm
	Namespace: gibclientutils
	Checksum: 0x45FD21E3
	Offset: 0x1E38
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibleftarm(localclientnum)
{
	entity = self;
	entity endon(#"entityshutdown");
	entity waittillmatch(#"_anim_notify_");
	cliententgibleftarm(localclientnum, entity);
}

/*
	Name: _handlegibrightleg
	Namespace: gibclientutils
	Checksum: 0x9C070701
	Offset: 0x1EA0
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibrightleg(localclientnum)
{
	entity = self;
	entity endon(#"entityshutdown");
	entity waittillmatch(#"_anim_notify_");
	cliententgibrightleg(localclientnum, entity);
}

/*
	Name: _handlegibleftleg
	Namespace: gibclientutils
	Checksum: 0xCEE07666
	Offset: 0x1F08
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private _handlegibleftleg(localclientnum)
{
	entity = self;
	entity endon(#"entityshutdown");
	entity waittillmatch(#"_anim_notify_");
	cliententgibleftleg(localclientnum, entity);
}

/*
	Name: _hasgibdef
	Namespace: gibclientutils
	Checksum: 0xC685497C
	Offset: 0x1F70
	Size: 0x6C
	Parameters: 1
	Flags: Linked, Private
*/
function private _hasgibdef(entity)
{
	return isdefined(entity.gib_data) && isdefined(entity.gib_data.gibdef) || isdefined(entity.gibdef) || entity getplayergibdef() != "unknown";
}

/*
	Name: _playgibfx
	Namespace: gibclientutils
	Checksum: 0x1E96FE57
	Offset: 0x1FE8
	Size: 0x10A
	Parameters: 4
	Flags: Linked
*/
function _playgibfx(localclientnum, entity, fxfilename, fxtag)
{
	if(isdefined(fxfilename) && isdefined(fxtag) && entity hasdobj(localclientnum))
	{
		fx = playfxontag(localclientnum, fxfilename, entity, fxtag);
		if(isdefined(fx))
		{
			if(isdefined(entity.team))
			{
				setfxteam(localclientnum, fx, entity.team);
			}
			if(isdefined(level.setgibfxtoignorepause) && level.setgibfxtoignorepause)
			{
				setfxignorepause(localclientnum, fx, 1);
			}
		}
		return fx;
	}
}

/*
	Name: _playgibsound
	Namespace: gibclientutils
	Checksum: 0xFBC0048
	Offset: 0x2100
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function _playgibsound(localclientnum, entity, soundalias)
{
	if(isdefined(soundalias))
	{
		playsound(localclientnum, soundalias, entity.origin);
	}
}

/*
	Name: addgibcallback
	Namespace: gibclientutils
	Checksum: 0x30D2D745
	Offset: 0x2158
	Size: 0xF6
	Parameters: 4
	Flags: Linked
*/
function addgibcallback(localclientnum, entity, gibflag, callbackfunction)
{
	/#
		assert(isfunctionptr(callbackfunction));
	#/
	if(!isdefined(entity._gibcallbacks))
	{
		entity._gibcallbacks = [];
	}
	if(!isdefined(entity._gibcallbacks[gibflag]))
	{
		entity._gibcallbacks[gibflag] = [];
	}
	gibcallbacks = entity._gibcallbacks[gibflag];
	gibcallbacks[gibcallbacks.size] = callbackfunction;
	entity._gibcallbacks[gibflag] = gibcallbacks;
}

/*
	Name: cliententgibannihilate
	Namespace: gibclientutils
	Checksum: 0x5D4A37DD
	Offset: 0x2258
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function cliententgibannihilate(localclientnum, entity)
{
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		return;
	}
	entity.ignoreragdoll = 1;
	entity _gibentity(localclientnum, 50 | 384, 1);
}

/*
	Name: cliententgibhead
	Namespace: gibclientutils
	Checksum: 0x99ACDA71
	Offset: 0x22E0
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function cliententgibhead(localclientnum, entity)
{
	_gibclientextrainternal(localclientnum, entity, 4);
	_gibclientextrainternal(localclientnum, entity, 8);
}

/*
	Name: cliententgibleftarm
	Namespace: gibclientutils
	Checksum: 0x33BACE49
	Offset: 0x2340
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function cliententgibleftarm(localclientnum, entity)
{
	if(isgibbed(localclientnum, entity, 16))
	{
		return;
	}
	_gibcliententityinternal(localclientnum, entity, 32);
}

/*
	Name: cliententgibrightarm
	Namespace: gibclientutils
	Checksum: 0xDB348E9D
	Offset: 0x23A0
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function cliententgibrightarm(localclientnum, entity)
{
	if(isgibbed(localclientnum, entity, 32))
	{
		return;
	}
	_gibcliententityinternal(localclientnum, entity, 16);
}

/*
	Name: cliententgibleftleg
	Namespace: gibclientutils
	Checksum: 0x10359DCA
	Offset: 0x2400
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function cliententgibleftleg(localclientnum, entity)
{
	_gibcliententityinternal(localclientnum, entity, 256);
}

/*
	Name: cliententgibrightleg
	Namespace: gibclientutils
	Checksum: 0xADC4650A
	Offset: 0x2440
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function cliententgibrightleg(localclientnum, entity)
{
	_gibcliententityinternal(localclientnum, entity, 128);
}

/*
	Name: createscriptmodelofentity
	Namespace: gibclientutils
	Checksum: 0x6E4C48B6
	Offset: 0x2480
	Size: 0x378
	Parameters: 2
	Flags: None
*/
function createscriptmodelofentity(localclientnum, entity)
{
	clone = spawn(localclientnum, entity.origin, "script_model");
	clone.angles = entity.angles;
	_clonegibdata(localclientnum, entity, clone);
	gibstate = _getgibbedstate(localclientnum, clone);
	if(!util::is_mature() || util::is_gib_restricted_build())
	{
		gibstate = 0;
	}
	if(!_getgibbedstate(localclientnum, entity) < 16)
	{
		clone setmodel(_getgibbedtorsomodel(localclientnum, entity));
		clone attach(_getgibbedlegmodel(localclientnum, entity), "");
	}
	else
	{
		clone setmodel(entity.model);
	}
	if(gibstate & 8)
	{
		if(isdefined((isdefined(clone.gib_data) ? clone.gib_data.torsodmg5 : clone.torsodmg5)))
		{
			clone attach((isdefined(clone.gib_data) ? clone.gib_data.torsodmg5 : clone.torsodmg5), "");
		}
	}
	else
	{
		if(isdefined((isdefined(clone.gib_data) ? clone.gib_data.head : clone.head)))
		{
			clone attach((isdefined(clone.gib_data) ? clone.gib_data.head : clone.head), "");
		}
		if(!gibstate & 4 && isdefined((isdefined(clone.gib_data) ? clone.gib_data.hatmodel : clone.hatmodel)))
		{
			clone attach((isdefined(clone.gib_data) ? clone.gib_data.hatmodel : clone.hatmodel), "");
		}
	}
	return clone;
}

/*
	Name: isgibbed
	Namespace: gibclientutils
	Checksum: 0xB80F09C8
	Offset: 0x2800
	Size: 0x38
	Parameters: 3
	Flags: Linked
*/
function isgibbed(localclientnum, entity, gibflag)
{
	return _getgibbedstate(localclientnum, entity) & gibflag;
}

/*
	Name: isundamaged
	Namespace: gibclientutils
	Checksum: 0x62794254
	Offset: 0x2840
	Size: 0x2E
	Parameters: 2
	Flags: None
*/
function isundamaged(localclientnum, entity)
{
	return _getgibbedstate(localclientnum, entity) == 0;
}

/*
	Name: gibentity
	Namespace: gibclientutils
	Checksum: 0xC94319C4
	Offset: 0x2878
	Size: 0x64
	Parameters: 2
	Flags: Linked
*/
function gibentity(localclientnum, gibflags)
{
	self _gibentity(localclientnum, gibflags, 1);
	self.gib_state = _getgibbedstate(localclientnum, self) | (gibflags & (512 - 1));
}

/*
	Name: handlegibnotetracks
	Namespace: gibclientutils
	Checksum: 0x85465374
	Offset: 0x28E8
	Size: 0xAC
	Parameters: 1
	Flags: None
*/
function handlegibnotetracks(localclientnum)
{
	entity = self;
	entity thread _handlegibannihilate(localclientnum);
	entity thread _handlegibhead(localclientnum);
	entity thread _handlegibrightarm(localclientnum);
	entity thread _handlegibleftarm(localclientnum);
	entity thread _handlegibrightleg(localclientnum);
	entity thread _handlegibleftleg(localclientnum);
}

/*
	Name: playergibleftarm
	Namespace: gibclientutils
	Checksum: 0xF57717A3
	Offset: 0x29A0
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function playergibleftarm(localclientnum)
{
	self gibentity(localclientnum, 32);
}

/*
	Name: playergibrightarm
	Namespace: gibclientutils
	Checksum: 0xDB12AA18
	Offset: 0x29D8
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function playergibrightarm(localclientnum)
{
	self gibentity(localclientnum, 16);
}

/*
	Name: playergibleftleg
	Namespace: gibclientutils
	Checksum: 0x4987943E
	Offset: 0x2A10
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function playergibleftleg(localclientnum)
{
	self gibentity(localclientnum, 256);
}

/*
	Name: playergibrightleg
	Namespace: gibclientutils
	Checksum: 0x219354D
	Offset: 0x2A48
	Size: 0x2C
	Parameters: 1
	Flags: None
*/
function playergibrightleg(localclientnum)
{
	self gibentity(localclientnum, 128);
}

/*
	Name: playergiblegs
	Namespace: gibclientutils
	Checksum: 0x3C5F7A02
	Offset: 0x2A80
	Size: 0x4C
	Parameters: 1
	Flags: None
*/
function playergiblegs(localclientnum)
{
	self gibentity(localclientnum, 128);
	self gibentity(localclientnum, 256);
}

/*
	Name: playergibtag
	Namespace: gibclientutils
	Checksum: 0x1D8D4FBA
	Offset: 0x2AD8
	Size: 0x32
	Parameters: 2
	Flags: None
*/
function playergibtag(localclientnum, gibflag)
{
	return _gibpiecetag(localclientnum, self, gibflag);
}

