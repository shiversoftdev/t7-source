// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\throttle_shared;

#namespace gib;

/*
	Name: fields_equal
	Namespace: gib
	Checksum: 0x42D702E7
	Offset: 0x388
	Size: 0x5C
	Parameters: 2
	Flags: Linked, Private
*/
function private fields_equal(field_a, field_b)
{
	if(!isdefined(field_a) && !isdefined(field_b))
	{
		return true;
	}
	if(isdefined(field_a) && isdefined(field_b) && field_a == field_b)
	{
		return true;
	}
	return false;
}

/*
	Name: _isdefaultplayergib
	Namespace: gib
	Checksum: 0xE3E8B332
	Offset: 0x3F0
	Size: 0x136
	Parameters: 2
	Flags: Linked, Private
*/
function private _isdefaultplayergib(gibpieceflag, gibstruct)
{
	if(!fields_equal(level.playergibbundle.gibs[gibpieceflag].gibdynentfx, gibstruct.gibdynentfx))
	{
		return false;
	}
	if(!fields_equal(level.playergibbundle.gibs[gibpieceflag].gibfxtag, gibstruct.gibfxtag))
	{
		return false;
	}
	if(!fields_equal(level.playergibbundle.gibs[gibpieceflag].gibfx, gibstruct.gibfx))
	{
		return false;
	}
	if(!fields_equal(level.playergibbundle.gibs[gibpieceflag].gibtag, gibstruct.gibtag))
	{
		return false;
	}
	return true;
}

/*
	Name: main
	Namespace: gib
	Checksum: 0x2643FFA5
	Offset: 0x530
	Size: 0x9B0
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	clientfield::register("actor", "gib_state", 1, 9, "int");
	clientfield::register("playercorpse", "gib_state", 1, 15, "int");
	gibdefinitions = struct::get_script_bundles("gibcharacterdef");
	gibpiecelookup = [];
	gibpiecelookup[2] = "annihilate";
	gibpiecelookup[8] = "head";
	gibpiecelookup[16] = "rightarm";
	gibpiecelookup[32] = "leftarm";
	gibpiecelookup[128] = "rightleg";
	gibpiecelookup[256] = "leftleg";
	processedbundles = [];
	if(sessionmodeismultiplayergame())
	{
		level.playergibbundle = spawnstruct();
		level.playergibbundle.gibs = [];
		level.playergibbundle.name = "default_player";
		level.playergibbundle.gibs[2] = spawnstruct();
		level.playergibbundle.gibs[8] = spawnstruct();
		level.playergibbundle.gibs[32] = spawnstruct();
		level.playergibbundle.gibs[256] = spawnstruct();
		level.playergibbundle.gibs[16] = spawnstruct();
		level.playergibbundle.gibs[128] = spawnstruct();
		level.playergibbundle.gibs[2].gibfxtag = "j_spinelower";
		level.playergibbundle.gibs[2].gibfx = "blood/fx_blood_impact_exp_body_lg";
		level.playergibbundle.gibs[32].gibmodel = "c_t7_mp_battery_mpc_body1_s_larm";
		level.playergibbundle.gibs[32].gibdynentfx = "blood/fx_blood_gib_limb_trail_emitter";
		level.playergibbundle.gibs[32].gibfxtag = "j_elbow_le";
		level.playergibbundle.gibs[32].gibfx = "blood/fx_blood_gib_arm_sever_burst";
		level.playergibbundle.gibs[32].gibtag = "j_elbow_le";
		level.playergibbundle.gibs[256].gibmodel = "c_t7_mp_battery_mpc_body1_s_lleg";
		level.playergibbundle.gibs[256].gibdynentfx = "blood/fx_blood_gib_limb_trail_emitter";
		level.playergibbundle.gibs[256].gibfxtag = "j_knee_le";
		level.playergibbundle.gibs[256].gibfx = "blood/fx_blood_gib_leg_sever_burst";
		level.playergibbundle.gibs[256].gibtag = "j_knee_le";
		level.playergibbundle.gibs[16].gibmodel = "c_t7_mp_battery_mpc_body1_s_rarm";
		level.playergibbundle.gibs[16].gibdynentfx = "blood/fx_blood_gib_limb_trail_emitter";
		level.playergibbundle.gibs[16].gibfxtag = "j_elbow_ri";
		level.playergibbundle.gibs[16].gibfx = "blood/fx_blood_gib_arm_sever_burst_rt";
		level.playergibbundle.gibs[16].gibtag = "j_elbow_ri";
		level.playergibbundle.gibs[128].gibmodel = "c_t7_mp_battery_mpc_body1_s_rleg";
		level.playergibbundle.gibs[128].gibdynentfx = "blood/fx_blood_gib_limb_trail_emitter";
		level.playergibbundle.gibs[128].gibfxtag = "j_knee_ri";
		level.playergibbundle.gibs[128].gibfx = "blood/fx_blood_gib_leg_sever_burst_rt";
		level.playergibbundle.gibs[128].gibtag = "j_knee_ri";
	}
	foreach(definitionname, definition in gibdefinitions)
	{
		gibbundle = spawnstruct();
		gibbundle.gibs = [];
		gibbundle.name = definitionname;
		default_player = 0;
		foreach(gibpieceflag, gibpiecename in gibpiecelookup)
		{
			gibstruct = spawnstruct();
			gibstruct.gibmodel = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibmodel");
			gibstruct.gibtag = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibtag");
			gibstruct.gibfx = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibfx");
			gibstruct.gibfxtag = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibeffecttag");
			gibstruct.gibdynentfx = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibdynentfx");
			gibstruct.gibsound = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibsound");
			gibstruct.gibhidetag = getstructfield(definition, gibpiecelookup[gibpieceflag] + "_gibhidetag");
			if(sessionmodeismultiplayergame() && _isdefaultplayergib(gibpieceflag, gibstruct))
			{
				default_player = 1;
			}
			gibbundle.gibs[gibpieceflag] = gibstruct;
		}
		if(sessionmodeismultiplayergame() && default_player)
		{
			processedbundles[definitionname] = level.playergibbundle;
			continue;
		}
		processedbundles[definitionname] = gibbundle;
	}
	level.scriptbundles["gibcharacterdef"] = processedbundles;
	if(!isdefined(level.gib_throttle))
	{
		level.gib_throttle = new throttle();
		[[ level.gib_throttle ]]->initialize(2, 0.2);
	}
}

#namespace gibserverutils;

/*
	Name: _annihilate
	Namespace: gibserverutils
	Checksum: 0x5DBFCA45
	Offset: 0xEE8
	Size: 0x2C
	Parameters: 1
	Flags: Linked, Private
*/
function private _annihilate(entity)
{
	if(isdefined(entity))
	{
		entity notsolid();
	}
}

/*
	Name: _getgibextramodel
	Namespace: gibserverutils
	Checksum: 0x479C7B20
	Offset: 0xF20
	Size: 0xCC
	Parameters: 2
	Flags: Linked, Private
*/
function private _getgibextramodel(entity, gibflag)
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
	Name: _gibextra
	Namespace: gibserverutils
	Checksum: 0xA2F9D2FE
	Offset: 0xFF8
	Size: 0x78
	Parameters: 2
	Flags: Linked, Private
*/
function private _gibextra(entity, gibflag)
{
	if(isgibbed(entity, gibflag))
	{
		return false;
	}
	if(!_hasgibdef(entity))
	{
		return false;
	}
	entity thread _gibextrainternal(entity, gibflag);
	return true;
}

/*
	Name: _gibextrainternal
	Namespace: gibserverutils
	Checksum: 0xDAA335D6
	Offset: 0x1078
	Size: 0x1F4
	Parameters: 2
	Flags: Linked, Private
*/
function private _gibextrainternal(entity, gibflag)
{
	if(entity.gib_time !== gettime())
	{
		[[ level.gib_throttle ]]->waitinqueue(entity);
	}
	if(!isdefined(entity))
	{
		return;
	}
	entity.gib_time = gettime();
	if(isgibbed(entity, gibflag))
	{
		return false;
	}
	if(gibflag == 8)
	{
		if(isdefined((isdefined(entity.gib_data) ? entity.gib_data.torsodmg5 : entity.torsodmg5)))
		{
			entity attach((isdefined(entity.gib_data) ? entity.gib_data.torsodmg5 : entity.torsodmg5), "", 1);
		}
	}
	_setgibbed(entity, gibflag, undefined);
	destructserverutils::showdestructedpieces(entity);
	showhiddengibpieces(entity);
	gibmodel = _getgibextramodel(entity, gibflag);
	if(isdefined(gibmodel))
	{
		entity detach(gibmodel, "");
	}
	destructserverutils::reapplydestructedpieces(entity);
	reapplyhiddengibpieces(entity);
}

/*
	Name: _gibentity
	Namespace: gibserverutils
	Checksum: 0x52FD8A3F
	Offset: 0x1278
	Size: 0x98
	Parameters: 2
	Flags: Linked, Private
*/
function private _gibentity(entity, gibflag)
{
	if(isgibbed(entity, gibflag) || !_hasgibpieces(entity, gibflag))
	{
		return false;
	}
	if(!_hasgibdef(entity))
	{
		return false;
	}
	entity thread _gibentityinternal(entity, gibflag);
	return true;
}

/*
	Name: _gibentityinternal
	Namespace: gibserverutils
	Checksum: 0xDBE849CE
	Offset: 0x1318
	Size: 0x1A4
	Parameters: 2
	Flags: Linked, Private
*/
function private _gibentityinternal(entity, gibflag)
{
	if(entity.gib_time !== gettime())
	{
		[[ level.gib_throttle ]]->waitinqueue(entity);
	}
	if(!isdefined(entity))
	{
		return;
	}
	entity.gib_time = gettime();
	if(isgibbed(entity, gibflag))
	{
		return;
	}
	destructserverutils::showdestructedpieces(entity);
	showhiddengibpieces(entity);
	if(!_getgibbedstate(entity) < 16)
	{
		legmodel = _getgibbedlegmodel(entity);
		entity detach(legmodel);
	}
	_setgibbed(entity, gibflag, undefined);
	entity setmodel(_getgibbedtorsomodel(entity));
	entity attach(_getgibbedlegmodel(entity));
	destructserverutils::reapplydestructedpieces(entity);
	reapplyhiddengibpieces(entity);
}

/*
	Name: _getgibbedlegmodel
	Namespace: gibserverutils
	Checksum: 0xB30D77F3
	Offset: 0x14C8
	Size: 0x176
	Parameters: 1
	Flags: Linked, Private
*/
function private _getgibbedlegmodel(entity)
{
	gibstate = _getgibbedstate(entity);
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
	Name: _getgibbedstate
	Namespace: gibserverutils
	Checksum: 0xB55C6C41
	Offset: 0x1648
	Size: 0x32
	Parameters: 1
	Flags: Linked, Private
*/
function private _getgibbedstate(entity)
{
	if(isdefined(entity.gib_state))
	{
		return entity.gib_state;
	}
	return 0;
}

/*
	Name: _getgibbedtorsomodel
	Namespace: gibserverutils
	Checksum: 0xB5A41075
	Offset: 0x1688
	Size: 0x176
	Parameters: 1
	Flags: Linked, Private
*/
function private _getgibbedtorsomodel(entity)
{
	gibstate = _getgibbedstate(entity);
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
	Name: _hasgibdef
	Namespace: gibserverutils
	Checksum: 0x157917AD
	Offset: 0x1808
	Size: 0x1C
	Parameters: 1
	Flags: Linked, Private
*/
function private _hasgibdef(entity)
{
	return isdefined(entity.gibdef);
}

/*
	Name: _hasgibpieces
	Namespace: gibserverutils
	Checksum: 0xB07614EF
	Offset: 0x1830
	Size: 0xC0
	Parameters: 2
	Flags: Linked, Private
*/
function private _hasgibpieces(entity, gibflag)
{
	hasgibpieces = 0;
	gibstate = _getgibbedstate(entity);
	entity.gib_state = gibstate | (gibflag & (512 - 1));
	if(isdefined(_getgibbedtorsomodel(entity)) && isdefined(_getgibbedlegmodel(entity)))
	{
		hasgibpieces = 1;
	}
	entity.gib_state = gibstate;
	return hasgibpieces;
}

/*
	Name: _setgibbed
	Namespace: gibserverutils
	Checksum: 0x7DF5D939
	Offset: 0x18F8
	Size: 0x144
	Parameters: 3
	Flags: Linked, Private
*/
function private _setgibbed(entity, gibflag, gibdir)
{
	if(isdefined(gibdir))
	{
		angles = vectortoangles(gibdir);
		yaw = angles[1];
		yaw_bits = getbitsforangle(yaw, 3);
		entity.gib_state = (_getgibbedstate(entity) | (gibflag & (512 - 1))) + (yaw_bits << 9);
	}
	else
	{
		entity.gib_state = _getgibbedstate(entity) | (gibflag & (512 - 1));
	}
	entity.gibbed = 1;
	entity clientfield::set("gib_state", entity.gib_state);
}

/*
	Name: annihilate
	Namespace: gibserverutils
	Checksum: 0x276243B5
	Offset: 0x1A48
	Size: 0x104
	Parameters: 1
	Flags: Linked
*/
function annihilate(entity)
{
	if(!_hasgibdef(entity))
	{
		return false;
	}
	gibbundle = struct::get_script_bundle("gibcharacterdef", entity.gibdef);
	if(!isdefined(gibbundle) || !isdefined(gibbundle.gibs))
	{
		return false;
	}
	gibpiecestruct = gibbundle.gibs[2];
	if(isdefined(gibpiecestruct))
	{
		if(isdefined(gibpiecestruct.gibfx))
		{
			_setgibbed(entity, 2, undefined);
			entity thread _annihilate(entity);
			return true;
		}
	}
	return false;
}

/*
	Name: copygibstate
	Namespace: gibserverutils
	Checksum: 0xFCAD44A4
	Offset: 0x1B58
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function copygibstate(originalentity, newentity)
{
	newentity.gib_state = _getgibbedstate(originalentity);
	togglespawngibs(newentity, 0);
	reapplyhiddengibpieces(newentity);
}

/*
	Name: isgibbed
	Namespace: gibserverutils
	Checksum: 0x80D566BF
	Offset: 0x1BD0
	Size: 0x30
	Parameters: 2
	Flags: Linked
*/
function isgibbed(entity, gibflag)
{
	return _getgibbedstate(entity) & gibflag;
}

/*
	Name: gibhat
	Namespace: gibserverutils
	Checksum: 0x17F2938B
	Offset: 0x1C08
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function gibhat(entity)
{
	return _gibextra(entity, 4);
}

/*
	Name: gibhead
	Namespace: gibserverutils
	Checksum: 0xE759E19A
	Offset: 0x1C38
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function gibhead(entity)
{
	gibhat(entity);
	return _gibextra(entity, 8);
}

/*
	Name: gibleftarm
	Namespace: gibserverutils
	Checksum: 0x17F592C0
	Offset: 0x1C80
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function gibleftarm(entity)
{
	if(isgibbed(entity, 16))
	{
		return false;
	}
	if(_gibentity(entity, 32))
	{
		destructserverutils::destructleftarmpieces(entity);
		return true;
	}
	return false;
}

/*
	Name: gibrightarm
	Namespace: gibserverutils
	Checksum: 0x8F925700
	Offset: 0x1CF0
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function gibrightarm(entity)
{
	if(isgibbed(entity, 32))
	{
		return false;
	}
	if(_gibentity(entity, 16))
	{
		destructserverutils::destructrightarmpieces(entity);
		entity thread shared::dropaiweapon();
		return true;
	}
	return false;
}

/*
	Name: gibleftleg
	Namespace: gibserverutils
	Checksum: 0xF18CC13B
	Offset: 0x1D78
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function gibleftleg(entity)
{
	if(_gibentity(entity, 256))
	{
		destructserverutils::destructleftlegpieces(entity);
		return true;
	}
	return false;
}

/*
	Name: gibrightleg
	Namespace: gibserverutils
	Checksum: 0x7C71D188
	Offset: 0x1DC8
	Size: 0x44
	Parameters: 1
	Flags: Linked
*/
function gibrightleg(entity)
{
	if(_gibentity(entity, 128))
	{
		destructserverutils::destructrightlegpieces(entity);
		return true;
	}
	return false;
}

/*
	Name: giblegs
	Namespace: gibserverutils
	Checksum: 0x725869FA
	Offset: 0x1E18
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function giblegs(entity)
{
	if(_gibentity(entity, 384))
	{
		destructserverutils::destructrightlegpieces(entity);
		destructserverutils::destructleftlegpieces(entity);
		return true;
	}
	return false;
}

/*
	Name: playergibleftarm
	Namespace: gibserverutils
	Checksum: 0x5846B8FD
	Offset: 0x1E80
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function playergibleftarm(entity)
{
	if(isdefined(entity.body))
	{
		dir = (1, 0, 0);
		_setgibbed(entity.body, 32, dir);
	}
}

/*
	Name: playergibrightarm
	Namespace: gibserverutils
	Checksum: 0x59A20878
	Offset: 0x1EE8
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function playergibrightarm(entity)
{
	if(isdefined(entity.body))
	{
		dir = (1, 0, 0);
		_setgibbed(entity.body, 16, dir);
	}
}

/*
	Name: playergibleftleg
	Namespace: gibserverutils
	Checksum: 0x478EDFE7
	Offset: 0x1F50
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function playergibleftleg(entity)
{
	if(isdefined(entity.body))
	{
		dir = (1, 0, 0);
		_setgibbed(entity.body, 256, dir);
	}
}

/*
	Name: playergibrightleg
	Namespace: gibserverutils
	Checksum: 0x669F5CC8
	Offset: 0x1FB8
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function playergibrightleg(entity)
{
	if(isdefined(entity.body))
	{
		dir = (1, 0, 0);
		_setgibbed(entity.body, 128, dir);
	}
}

/*
	Name: playergiblegs
	Namespace: gibserverutils
	Checksum: 0x251702AB
	Offset: 0x2020
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function playergiblegs(entity)
{
	if(isdefined(entity.body))
	{
		dir = (1, 0, 0);
		_setgibbed(entity.body, 128, dir);
		_setgibbed(entity.body, 256, dir);
	}
}

/*
	Name: playergibleftarmvel
	Namespace: gibserverutils
	Checksum: 0x3E16A791
	Offset: 0x20B0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function playergibleftarmvel(entity, dir)
{
	if(isdefined(entity.body))
	{
		_setgibbed(entity.body, 32, dir);
	}
}

/*
	Name: playergibrightarmvel
	Namespace: gibserverutils
	Checksum: 0x3A735DD7
	Offset: 0x2108
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function playergibrightarmvel(entity, dir)
{
	if(isdefined(entity.body))
	{
		_setgibbed(entity.body, 16, dir);
	}
}

/*
	Name: playergibleftlegvel
	Namespace: gibserverutils
	Checksum: 0xC4DA859B
	Offset: 0x2160
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function playergibleftlegvel(entity, dir)
{
	if(isdefined(entity.body))
	{
		_setgibbed(entity.body, 256, dir);
	}
}

/*
	Name: playergibrightlegvel
	Namespace: gibserverutils
	Checksum: 0xBCF2EDC
	Offset: 0x21B8
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function playergibrightlegvel(entity, dir)
{
	if(isdefined(entity.body))
	{
		_setgibbed(entity.body, 128, dir);
	}
}

/*
	Name: playergiblegsvel
	Namespace: gibserverutils
	Checksum: 0x4C1ADF1C
	Offset: 0x2210
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function playergiblegsvel(entity, dir)
{
	if(isdefined(entity.body))
	{
		_setgibbed(entity.body, 128, dir);
		_setgibbed(entity.body, 256, dir);
	}
}

/*
	Name: reapplyhiddengibpieces
	Namespace: gibserverutils
	Checksum: 0xA1208547
	Offset: 0x2290
	Size: 0x192
	Parameters: 1
	Flags: Linked
*/
function reapplyhiddengibpieces(entity)
{
	if(!_hasgibdef(entity))
	{
		return;
	}
	gibbundle = struct::get_script_bundle("gibcharacterdef", entity.gibdef);
	foreach(gibflag, gib in gibbundle.gibs)
	{
		if(!isgibbed(entity, gibflag))
		{
			continue;
		}
		if(isdefined(gib.gibhidetag) && isalive(entity) && entity haspart(gib.gibhidetag))
		{
			if(!(isdefined(entity.skipdeath) && entity.skipdeath))
			{
				entity hidepart(gib.gibhidetag, "", 1);
			}
		}
	}
}

/*
	Name: showhiddengibpieces
	Namespace: gibserverutils
	Checksum: 0x42C66B39
	Offset: 0x2430
	Size: 0x132
	Parameters: 1
	Flags: Linked
*/
function showhiddengibpieces(entity)
{
	if(!_hasgibdef(entity))
	{
		return;
	}
	gibbundle = struct::get_script_bundle("gibcharacterdef", entity.gibdef);
	foreach(gib in gibbundle.gibs)
	{
		if(isdefined(gib.gibhidetag) && entity haspart(gib.gibhidetag))
		{
			entity showpart(gib.gibhidetag, "", 1);
		}
	}
}

/*
	Name: togglespawngibs
	Namespace: gibserverutils
	Checksum: 0xADA9F41D
	Offset: 0x2570
	Size: 0xA4
	Parameters: 2
	Flags: Linked
*/
function togglespawngibs(entity, shouldspawngibs)
{
	if(!shouldspawngibs)
	{
		entity.gib_state = _getgibbedstate(entity) | 1;
	}
	else
	{
		entity.gib_state = _getgibbedstate(entity) & -2;
	}
	entity clientfield::set("gib_state", entity.gib_state);
}

