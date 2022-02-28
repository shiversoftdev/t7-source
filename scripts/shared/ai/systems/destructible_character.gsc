// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;

#namespace destructible_character;

/*
	Name: main
	Namespace: destructible_character
	Checksum: 0x80508B30
	Offset: 0x258
	Size: 0x3CE
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "destructible_character_state", 1, 21, "int");
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

#namespace destructserverutils;

/*
	Name: _getdestructstate
	Namespace: destructserverutils
	Checksum: 0x5B7D7283
	Offset: 0x630
	Size: 0x32
	Parameters: 1
	Flags: Linked, Private
*/
function private _getdestructstate(entity)
{
	if(isdefined(entity._destruct_state))
	{
		return entity._destruct_state;
	}
	return 0;
}

/*
	Name: _setdestructed
	Namespace: destructserverutils
	Checksum: 0xE9F4B4FF
	Offset: 0x670
	Size: 0x6C
	Parameters: 2
	Flags: Linked, Private
*/
function private _setdestructed(entity, destructflag)
{
	entity._destruct_state = _getdestructstate(entity) | destructflag;
	entity clientfield::set("destructible_character_state", entity._destruct_state);
}

/*
	Name: copydestructstate
	Namespace: destructserverutils
	Checksum: 0x7C881414
	Offset: 0x6E8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function copydestructstate(originalentity, newentity)
{
	newentity._destruct_state = _getdestructstate(originalentity);
	togglespawngibs(newentity, 0);
	reapplydestructedpieces(newentity);
}

/*
	Name: destructhitlocpieces
	Namespace: destructserverutils
	Checksum: 0xF486511E
	Offset: 0x760
	Size: 0xF6
	Parameters: 2
	Flags: Linked
*/
function destructhitlocpieces(entity, hitloc)
{
	if(isdefined(entity.destructibledef))
	{
		destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
		for(index = 1; index <= destructbundle.pieces.size; index++)
		{
			piece = destructbundle.pieces[index - 1];
			if(isdefined(piece.hitlocation) && piece.hitlocation == hitloc)
			{
				destructpiece(entity, index);
			}
		}
	}
}

/*
	Name: destructleftarmpieces
	Namespace: destructserverutils
	Checksum: 0x6431ABE9
	Offset: 0x860
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function destructleftarmpieces(entity)
{
	destructhitlocpieces(entity, "left_arm_upper");
	destructhitlocpieces(entity, "left_arm_lower");
	destructhitlocpieces(entity, "left_hand");
}

/*
	Name: destructleftlegpieces
	Namespace: destructserverutils
	Checksum: 0x4616100B
	Offset: 0x8D8
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function destructleftlegpieces(entity)
{
	destructhitlocpieces(entity, "left_leg_upper");
	destructhitlocpieces(entity, "left_leg_lower");
	destructhitlocpieces(entity, "left_foot");
}

/*
	Name: destructpiece
	Namespace: destructserverutils
	Checksum: 0xE0C62230
	Offset: 0x950
	Size: 0x194
	Parameters: 2
	Flags: Linked
*/
function destructpiece(entity, piecenumber)
{
	/#
		/#
			assert(1 <= piecenumber && piecenumber <= 20);
		#/
	#/
	if(isdestructed(entity, piecenumber))
	{
		return;
	}
	_setdestructed(entity, 1 << piecenumber);
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	piece = destructbundle.pieces[piecenumber - 1];
	if(isdefined(piece.hidetag) && entity haspart(piece.hidetag))
	{
		entity hidepart(piece.hidetag);
	}
	if(isdefined(piece.detachmodel))
	{
		entity detach(piece.detachmodel, "");
	}
}

/*
	Name: destructnumberrandompieces
	Namespace: destructserverutils
	Checksum: 0xB71E5D11
	Offset: 0xAF0
	Size: 0x188
	Parameters: 2
	Flags: Linked
*/
function destructnumberrandompieces(entity, num_pieces_to_destruct = 0)
{
	destructible_pieces_list = [];
	destructablepieces = getpiececount(entity);
	if(num_pieces_to_destruct == 0)
	{
		num_pieces_to_destruct = destructablepieces;
	}
	for(i = 0; i < destructablepieces; i++)
	{
		destructible_pieces_list[i] = i + 1;
	}
	destructible_pieces_list = array::randomize(destructible_pieces_list);
	foreach(piece in destructible_pieces_list)
	{
		if(!isdestructed(entity, piece))
		{
			destructpiece(entity, piece);
			num_pieces_to_destruct--;
			if(num_pieces_to_destruct == 0)
			{
				break;
			}
		}
	}
}

/*
	Name: destructrandompieces
	Namespace: destructserverutils
	Checksum: 0x69FABBAC
	Offset: 0xC80
	Size: 0x8E
	Parameters: 1
	Flags: Linked
*/
function destructrandompieces(entity)
{
	destructpieces = getpiececount(entity);
	for(index = 0; index < destructpieces; index++)
	{
		if(math::cointoss())
		{
			destructpiece(entity, index + 1);
		}
	}
}

/*
	Name: destructrightarmpieces
	Namespace: destructserverutils
	Checksum: 0x81D5BD7E
	Offset: 0xD18
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function destructrightarmpieces(entity)
{
	destructhitlocpieces(entity, "right_arm_upper");
	destructhitlocpieces(entity, "right_arm_lower");
	destructhitlocpieces(entity, "right_hand");
}

/*
	Name: destructrightlegpieces
	Namespace: destructserverutils
	Checksum: 0xD0A8F0CF
	Offset: 0xD90
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function destructrightlegpieces(entity)
{
	destructhitlocpieces(entity, "right_leg_upper");
	destructhitlocpieces(entity, "right_leg_lower");
	destructhitlocpieces(entity, "right_foot");
}

/*
	Name: getpiececount
	Namespace: destructserverutils
	Checksum: 0x5831DDDD
	Offset: 0xE08
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function getpiececount(entity)
{
	if(isdefined(entity.destructibledef))
	{
		destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
		if(isdefined(destructbundle))
		{
			return destructbundle.piececount;
		}
	}
	return 0;
}

/*
	Name: handledamage
	Namespace: destructserverutils
	Checksum: 0xB4D83525
	Offset: 0xE80
	Size: 0x100
	Parameters: 12
	Flags: Linked
*/
function handledamage(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime, boneindex, modelindex)
{
	entity = self;
	if(isdefined(entity.skipdeath) && entity.skipdeath)
	{
		return idamage;
	}
	if(isdefined(entity.var_132756fd) && entity.var_132756fd)
	{
		return idamage;
	}
	togglespawngibs(entity, 1);
	destructhitlocpieces(entity, shitloc);
	return idamage;
}

/*
	Name: isdestructed
	Namespace: destructserverutils
	Checksum: 0xF5E6BF8C
	Offset: 0xF88
	Size: 0x66
	Parameters: 2
	Flags: Linked
*/
function isdestructed(entity, piecenumber)
{
	/#
		/#
			assert(1 <= piecenumber && piecenumber <= 20);
		#/
	#/
	return _getdestructstate(entity) & (1 << piecenumber);
}

/*
	Name: reapplydestructedpieces
	Namespace: destructserverutils
	Checksum: 0x211C5F3E
	Offset: 0xFF8
	Size: 0x12E
	Parameters: 1
	Flags: Linked
*/
function reapplydestructedpieces(entity)
{
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	for(index = 1; index <= destructbundle.pieces.size; index++)
	{
		if(!isdestructed(entity, index))
		{
			continue;
		}
		piece = destructbundle.pieces[index - 1];
		if(isdefined(piece.hidetag) && entity haspart(piece.hidetag))
		{
			entity hidepart(piece.hidetag);
		}
	}
}

/*
	Name: showdestructedpieces
	Namespace: destructserverutils
	Checksum: 0xBBC3B6D1
	Offset: 0x1130
	Size: 0x10E
	Parameters: 1
	Flags: Linked
*/
function showdestructedpieces(entity)
{
	if(!isdefined(entity.destructibledef))
	{
		return;
	}
	destructbundle = struct::get_script_bundle("destructiblecharacterdef", entity.destructibledef);
	for(index = 1; index <= destructbundle.pieces.size; index++)
	{
		piece = destructbundle.pieces[index - 1];
		if(isdefined(piece.hidetag) && entity haspart(piece.hidetag))
		{
			entity showpart(piece.hidetag);
		}
	}
}

/*
	Name: togglespawngibs
	Namespace: destructserverutils
	Checksum: 0x50FBA039
	Offset: 0x1248
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function togglespawngibs(entity, shouldspawngibs)
{
	if(shouldspawngibs)
	{
		entity._destruct_state = _getdestructstate(entity) | 1;
	}
	else
	{
		entity._destruct_state = _getdestructstate(entity) & -2;
	}
	entity clientfield::set("destructible_character_state", entity._destruct_state);
}

