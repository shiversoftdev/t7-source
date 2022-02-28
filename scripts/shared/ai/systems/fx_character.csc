// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;

#namespace fx_character;

/*
	Name: main
	Namespace: fx_character
	Checksum: 0xBEA295CF
	Offset: 0x168
	Size: 0x2D6
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	fxbundles = struct::get_script_bundles("fxcharacterdef");
	processedfxbundles = [];
	foreach(fxbundlename, fxbundle in fxbundles)
	{
		processedfxbundle = spawnstruct();
		processedfxbundle.effectcount = fxbundle.effectcount;
		processedfxbundle.fx = [];
		processedfxbundle.name = fxbundlename;
		for(index = 1; index <= fxbundle.effectcount; index++)
		{
			fx = getstructfield(fxbundle, ("effect" + index) + "_fx");
			if(isdefined(fx))
			{
				fxstruct = spawnstruct();
				fxstruct.attachtag = getstructfield(fxbundle, ("effect" + index) + "_attachtag");
				fxstruct.fx = getstructfield(fxbundle, ("effect" + index) + "_fx");
				fxstruct.stopongib = fxclientutils::_gibpartnametogibflag(getstructfield(fxbundle, ("effect" + index) + "_stopongib"));
				fxstruct.stoponpiecedestroyed = getstructfield(fxbundle, ("effect" + index) + "_stoponpiecedestroyed");
				processedfxbundle.fx[processedfxbundle.fx.size] = fxstruct;
			}
		}
		processedfxbundles[fxbundlename] = processedfxbundle;
	}
	level.scriptbundles["fxcharacterdef"] = processedfxbundles;
}

#namespace fxclientutils;

/*
	Name: _configentity
	Namespace: fxclientutils
	Checksum: 0xD069E952
	Offset: 0x448
	Size: 0x156
	Parameters: 2
	Flags: Linked, Private
*/
function private _configentity(localclientnum, entity)
{
	if(!isdefined(entity._fxcharacter))
	{
		entity._fxcharacter = [];
		handledgibs = array(8, 16, 32, 128, 256);
		foreach(gibflag in handledgibs)
		{
			gibclientutils::addgibcallback(localclientnum, entity, gibflag, &_gibhandler);
		}
		for(index = 1; index <= 20; index++)
		{
			destructclientutils::adddestructpiececallback(localclientnum, entity, index, &_destructhandler);
		}
	}
}

/*
	Name: _destructhandler
	Namespace: fxclientutils
	Checksum: 0xEDC6AABF
	Offset: 0x5A8
	Size: 0x166
	Parameters: 3
	Flags: Linked, Private
*/
function private _destructhandler(localclientnum, entity, piecenumber)
{
	if(!isdefined(entity._fxcharacter))
	{
		return;
	}
	foreach(fxbundlename, fxbundleinst in entity._fxcharacter)
	{
		fxbundle = struct::get_script_bundle("fxcharacterdef", fxbundlename);
		for(index = 0; index < fxbundle.fx.size; index++)
		{
			if(isdefined(fxbundleinst[index]) && fxbundle.fx[index].stoponpiecedestroyed === piecenumber)
			{
				stopfx(localclientnum, fxbundleinst[index]);
				fxbundleinst[index] = undefined;
			}
		}
	}
}

/*
	Name: _gibhandler
	Namespace: fxclientutils
	Checksum: 0xA16325FF
	Offset: 0x718
	Size: 0x166
	Parameters: 3
	Flags: Linked, Private
*/
function private _gibhandler(localclientnum, entity, gibflag)
{
	if(!isdefined(entity._fxcharacter))
	{
		return;
	}
	foreach(fxbundlename, fxbundleinst in entity._fxcharacter)
	{
		fxbundle = struct::get_script_bundle("fxcharacterdef", fxbundlename);
		for(index = 0; index < fxbundle.fx.size; index++)
		{
			if(isdefined(fxbundleinst[index]) && fxbundle.fx[index].stopongib === gibflag)
			{
				stopfx(localclientnum, fxbundleinst[index]);
				fxbundleinst[index] = undefined;
			}
		}
	}
}

/*
	Name: _gibpartnametogibflag
	Namespace: fxclientutils
	Checksum: 0xB67E2208
	Offset: 0x888
	Size: 0x6E
	Parameters: 1
	Flags: Linked, Private
*/
function private _gibpartnametogibflag(gibpartname)
{
	if(isdefined(gibpartname))
	{
		switch(gibpartname)
		{
			case "head":
			{
				return 8;
			}
			case "right arm":
			{
				return 16;
			}
			case "left arm":
			{
				return 32;
			}
			case "right leg":
			{
				return 128;
			}
			case "left leg":
			{
				return 256;
			}
		}
	}
}

/*
	Name: _isgibbed
	Namespace: fxclientutils
	Checksum: 0x9C83D894
	Offset: 0x900
	Size: 0x4A
	Parameters: 3
	Flags: Linked, Private
*/
function private _isgibbed(localclientnum, entity, stopongibflag)
{
	if(!isdefined(stopongibflag))
	{
		return 0;
	}
	return gibclientutils::isgibbed(localclientnum, entity, stopongibflag);
}

/*
	Name: _ispiecedestructed
	Namespace: fxclientutils
	Checksum: 0x4227EFD6
	Offset: 0x958
	Size: 0x4A
	Parameters: 3
	Flags: Linked, Private
*/
function private _ispiecedestructed(localclientnum, entity, stoponpiecedestroyed)
{
	if(!isdefined(stoponpiecedestroyed))
	{
		return 0;
	}
	return destructclientutils::ispiecedestructed(localclientnum, entity, stoponpiecedestroyed);
}

/*
	Name: _shouldplayfx
	Namespace: fxclientutils
	Checksum: 0x53BF3B0A
	Offset: 0x9B0
	Size: 0x7E
	Parameters: 3
	Flags: Linked, Private
*/
function private _shouldplayfx(localclientnum, entity, fxstruct)
{
	if(_isgibbed(localclientnum, entity, fxstruct.stopongib))
	{
		return false;
	}
	if(_ispiecedestructed(localclientnum, entity, fxstruct.stoponpiecedestroyed))
	{
		return false;
	}
	return true;
}

/*
	Name: playfxbundle
	Namespace: fxclientutils
	Checksum: 0x72DD5148
	Offset: 0xA38
	Size: 0x18E
	Parameters: 3
	Flags: Linked
*/
function playfxbundle(localclientnum, entity, fxscriptbundle)
{
	if(!isdefined(fxscriptbundle))
	{
		return;
	}
	_configentity(localclientnum, entity);
	fxbundle = struct::get_script_bundle("fxcharacterdef", fxscriptbundle);
	if(isdefined(entity._fxcharacter[fxbundle.name]))
	{
		return;
	}
	if(isdefined(fxbundle))
	{
		playingfx = [];
		for(index = 0; index < fxbundle.fx.size; index++)
		{
			fxstruct = fxbundle.fx[index];
			if(_shouldplayfx(localclientnum, entity, fxstruct))
			{
				playingfx[index] = gibclientutils::_playgibfx(localclientnum, entity, fxstruct.fx, fxstruct.attachtag);
			}
		}
		if(playingfx.size > 0)
		{
			entity._fxcharacter[fxbundle.name] = playingfx;
		}
	}
}

/*
	Name: stopallfxbundles
	Namespace: fxclientutils
	Checksum: 0x9B874D97
	Offset: 0xBD0
	Size: 0x14A
	Parameters: 2
	Flags: Linked
*/
function stopallfxbundles(localclientnum, entity)
{
	_configentity(localclientnum, entity);
	fxbundlenames = [];
	foreach(fxbundlename, fxbundle in entity._fxcharacter)
	{
		fxbundlenames[fxbundlenames.size] = fxbundlename;
	}
	foreach(fxbundlename in fxbundlenames)
	{
		stopfxbundle(localclientnum, entity, fxbundlename);
	}
}

/*
	Name: stopfxbundle
	Namespace: fxclientutils
	Checksum: 0xB0508C91
	Offset: 0xD28
	Size: 0x154
	Parameters: 3
	Flags: Linked
*/
function stopfxbundle(localclientnum, entity, fxscriptbundle)
{
	if(!isdefined(fxscriptbundle))
	{
		return;
	}
	_configentity(localclientnum, entity);
	fxbundle = struct::get_script_bundle("fxcharacterdef", fxscriptbundle);
	if(isdefined(entity._fxcharacter[fxbundle.name]))
	{
		foreach(fx in entity._fxcharacter[fxbundle.name])
		{
			if(isdefined(fx))
			{
				stopfx(localclientnum, fx);
			}
		}
		entity._fxcharacter[fxbundle.name] = undefined;
	}
}

