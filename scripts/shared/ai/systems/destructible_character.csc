// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\clientfield_shared;

#namespace destructible_character;

/*
	Name: main
	Namespace: destructible_character
	Checksum: 0xD7C6F9F5
	Offset: 0x198
	Size: 0x3E6
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "destructible_character_state", 1, 21, "int", &destructclientutils::_destructhandler, 0, 0);
	destructibles = struct::get_script_bundles("destructiblecharacterdef");
	processedbundles = [];
	foreach(destructiblename, destructible in destructibles)
	{
		destructbundle = spawnstruct();
		destructbundle.piececount = destructible.piececount;
		destructbundle.pieces = [];
		destructbundle.name = destructiblename;
		for(index = 1; index <= destructbundle.piececount; index++)
		{
			piecestruct = spawnstruct();
			piecestruct.gibmodel = getstructfield(destructible, ("piece" + index) + "_gibmodel");
			piecestruct.gibtag = getstructfield(destructible, ("piece" + index) + "_gibtag");
			piecestruct.gibfx = getstructfield(destructible, ("piece" + index) + "_gibfx");
			piecestruct.gibfxtag = getstructfield(destructible, ("piece" + index) + "_gibeffecttag");
			piecestruct.gibdynentfx = getstructfield(destructible, ("piece" + index) + "_gibdynentfx");
			piecestruct.gibsound = getstructfield(destructible, ("piece" + index) + "_gibsound");
			piecestruct.hitlocation = getstructfield(destructible, ("piece" + index) + "_hitlocation");
			piecestruct.hidetag = getstructfield(destructible, ("piece" + index) + "_hidetag");
			piecestruct.detachmodel = getstructfield(destructible, ("piece" + index) + "_detachmodel");
			destructbundle.pieces[destructbundle.pieces.size] = piecestruct;
		}
		processedbundles[destructiblename] = destructbundle;
	}
	level.scriptbundles["destructiblecharacterdef"] = processedbundles;
}

#namespace destructclientutils;

/*
	Name: _destructhandler
	Namespace: destructclientutils
	Checksum: 0xACFAC1D4
	Offset: 0x588
	Size: 0x138
	Parameters: 7
	Flags: Linked, Private
*/
function private _destructhandler(localclientnum, oldvalue, newvalue, bnewent, binitialsnap, fieldname, wasdemojump)
{
	entity = self;
	destructflags = oldvalue ^ newvalue;
	shouldspawngibs = newvalue & 1;
	if(bnewent)
	{
		destructflags = 0 ^ newvalue;
	}
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	currentdestructflag = 2;
	piecenumber = 1;
	while(destructflags >= currentdestructflag)
	{
		if(destructflags & currentdestructflag)
		{
			_destructpiece(localclientnum, entity, piecenumber, shouldspawngibs);
		}
		currentdestructflag = currentdestructflag << 1;
		piecenumber++;
	}
	entity._destruct_state = newvalue;
}

/*
	Name: _destructpiece
	Namespace: destructclientutils
	Checksum: 0x521F25B2
	Offset: 0x6C8
	Size: 0x164
	Parameters: 4
	Flags: Linked, Private
*/
function private _destructpiece(localclientnum, entity, piecenumber, shouldspawngibs)
{
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	piece = destructbundle.pieces[piecenumber - 1];
	if(isdefined(piece))
	{
		if(shouldspawngibs)
		{
			gibclientutils::_playgibfx(localclientnum, entity, piece.gibfx, piece.gibfxtag);
			entity thread gibclientutils::_gibpiece(localclientnum, entity, piece.gibmodel, piece.gibtag, piece.gibdynentfx);
			gibclientutils::_playgibsound(localclientnum, entity, piece.gibsound);
		}
		_handledestructcallbacks(localclientnum, entity, piecenumber);
	}
}

/*
	Name: _getdestructstate
	Namespace: destructclientutils
	Checksum: 0x557F08AF
	Offset: 0x838
	Size: 0x3A
	Parameters: 2
	Flags: Linked, Private
*/
function private _getdestructstate(localclientnum, entity)
{
	if(isdefined(entity._destruct_state))
	{
		return entity._destruct_state;
	}
	return 0;
}

/*
	Name: _handledestructcallbacks
	Namespace: destructclientutils
	Checksum: 0xE0D458C6
	Offset: 0x880
	Size: 0xF4
	Parameters: 3
	Flags: Linked, Private
*/
function private _handledestructcallbacks(localclientnum, entity, piecenumber)
{
	if(isdefined(entity._destructcallbacks) && isdefined(entity._destructcallbacks[piecenumber]))
	{
		foreach(callback in entity._destructcallbacks[piecenumber])
		{
			if(isfunctionptr(callback))
			{
				[[callback]](localclientnum, entity, piecenumber);
			}
		}
	}
}

/*
	Name: adddestructpiececallback
	Namespace: destructclientutils
	Checksum: 0xB1C157A2
	Offset: 0x980
	Size: 0xF6
	Parameters: 4
	Flags: Linked
*/
function adddestructpiececallback(localclientnum, entity, piecenumber, callbackfunction)
{
	/#
		assert(isfunctionptr(callbackfunction));
	#/
	if(!isdefined(entity._destructcallbacks))
	{
		entity._destructcallbacks = [];
	}
	if(!isdefined(entity._destructcallbacks[piecenumber]))
	{
		entity._destructcallbacks[piecenumber] = [];
	}
	destructcallbacks = entity._destructcallbacks[piecenumber];
	destructcallbacks[destructcallbacks.size] = callbackfunction;
	entity._destructcallbacks[piecenumber] = destructcallbacks;
}

/*
	Name: ispiecedestructed
	Namespace: destructclientutils
	Checksum: 0x50F61D1F
	Offset: 0xA80
	Size: 0x3E
	Parameters: 3
	Flags: Linked
*/
function ispiecedestructed(localclientnum, entity, piecenumber)
{
	return _getdestructstate(localclientnum, entity) & (1 << piecenumber);
}

