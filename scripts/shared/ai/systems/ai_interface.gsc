// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace ai_interface;

/*
	Name: main
	Namespace: ai_interface
	Checksum: 0x493A47D0
	Offset: 0xE8
	Size: 0x2C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	/#
		level.__ai_debuginterface = getdvarint("");
	#/
}

/*
	Name: _checkvalue
	Namespace: ai_interface
	Checksum: 0x85FDF085
	Offset: 0x120
	Size: 0x2D6
	Parameters: 3
	Flags: Linked, Private
*/
function private _checkvalue(archetype, attributename, value)
{
	/#
		attribute = level.__ai_interface[archetype][attributename];
		switch(attribute[""])
		{
			case "":
			{
				possiblevalues = attribute[""];
				/#
					assert(!isarray(possiblevalues) || isinarray(possiblevalues, value), ((("" + value) + "") + attributename) + "");
				#/
				break;
			}
			case "":
			{
				maxvalue = attribute[""];
				minvalue = attribute[""];
				/#
					assert(isint(value) || isfloat(value), ((("" + attributename) + "") + value) + "");
				#/
				/#
					assert(!isdefined(maxvalue) && !isdefined(minvalue) || (value <= maxvalue && value >= minvalue), ((((("" + value) + "") + minvalue) + "") + maxvalue) + "");
				#/
				break;
			}
			case "":
			{
				if(isdefined(value))
				{
					/#
						assert(isvec(value), ((("" + attributename) + "") + value) + "");
					#/
				}
				break;
			}
			default:
			{
				/#
					assert(((("" + attribute[""]) + "") + attributename) + "");
				#/
				break;
			}
		}
	#/
}

/*
	Name: _checkprerequisites
	Namespace: ai_interface
	Checksum: 0x7B801FCE
	Offset: 0x400
	Size: 0x2B4
	Parameters: 2
	Flags: Linked, Private
*/
function private _checkprerequisites(entity, attribute)
{
	/#
		/#
			assert(isentity(entity), "");
		#/
		/#
			assert(isactor(entity) || isvehicle(entity), "");
		#/
		/#
			assert(isstring(attribute), "");
		#/
		if(isdefined(level.__ai_debuginterface) && level.__ai_debuginterface > 0)
		{
			/#
				assert(isarray(entity.__interface), (("" + entity.archetype) + "") + "");
			#/
			/#
				assert(isarray(level.__ai_interface), "");
			#/
			/#
				assert(isarray(level.__ai_interface[entity.archetype]), ("" + entity.archetype) + "");
			#/
			/#
				assert(isarray(level.__ai_interface[entity.archetype][attribute]), ((("" + attribute) + "") + entity.archetype) + "");
			#/
			/#
				assert(isstring(level.__ai_interface[entity.archetype][attribute][""]), ("" + attribute) + "");
			#/
		}
	#/
}

/*
	Name: _checkregistrationprerequisites
	Namespace: ai_interface
	Checksum: 0x758169D8
	Offset: 0x6C0
	Size: 0xCC
	Parameters: 3
	Flags: Linked, Private
*/
function private _checkregistrationprerequisites(archetype, attribute, callbackfunction)
{
	/#
		/#
			assert(isstring(archetype), "");
		#/
		/#
			assert(isstring(attribute), "");
		#/
		/#
			assert(!isdefined(callbackfunction) || isfunctionptr(callbackfunction), "");
		#/
	#/
}

/*
	Name: _initializelevelinterface
	Namespace: ai_interface
	Checksum: 0xC53888B5
	Offset: 0x798
	Size: 0x46
	Parameters: 1
	Flags: Linked, Private
*/
function private _initializelevelinterface(archetype)
{
	if(!isdefined(level.__ai_interface))
	{
		level.__ai_interface = [];
	}
	if(!isdefined(level.__ai_interface[archetype]))
	{
		level.__ai_interface[archetype] = [];
	}
}

#namespace ai;

/*
	Name: createinterfaceforentity
	Namespace: ai
	Checksum: 0x16E05325
	Offset: 0x7E8
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function createinterfaceforentity(entity)
{
	if(!isdefined(entity.__interface))
	{
		entity.__interface = [];
	}
}

/*
	Name: getaiattribute
	Namespace: ai
	Checksum: 0xF3E78B73
	Offset: 0x820
	Size: 0x88
	Parameters: 2
	Flags: Linked
*/
function getaiattribute(entity, attribute)
{
	/#
		ai_interface::_checkprerequisites(entity, attribute);
	#/
	if(!isdefined(entity.__interface[attribute]))
	{
		return level.__ai_interface[entity.archetype][attribute]["default_value"];
	}
	return entity.__interface[attribute];
}

/*
	Name: hasaiattribute
	Namespace: ai
	Checksum: 0x1FEC0C42
	Offset: 0x8B0
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function hasaiattribute(entity, attribute)
{
	return isdefined(entity) && isdefined(attribute) && isdefined(entity.archetype) && isdefined(level.__ai_interface) && isdefined(level.__ai_interface[entity.archetype]) && isdefined(level.__ai_interface[entity.archetype][attribute]);
}

/*
	Name: registermatchedinterface
	Namespace: ai
	Checksum: 0x28515ADB
	Offset: 0x940
	Size: 0x1CC
	Parameters: 5
	Flags: Linked
*/
function registermatchedinterface(archetype, attribute, defaultvalue, possiblevalues, callbackfunction)
{
	/#
		ai_interface::_checkregistrationprerequisites(archetype, attribute, callbackfunction);
		/#
			assert(!isdefined(possiblevalues) || isarray(possiblevalues), "");
		#/
	#/
	ai_interface::_initializelevelinterface(archetype);
	/#
		/#
			assert(!isdefined(level.__ai_interface[archetype][attribute]), ((("" + attribute) + "") + archetype) + "");
		#/
	#/
	level.__ai_interface[archetype][attribute] = [];
	level.__ai_interface[archetype][attribute]["callback"] = callbackfunction;
	level.__ai_interface[archetype][attribute]["default_value"] = defaultvalue;
	level.__ai_interface[archetype][attribute]["type"] = "_interface_match";
	level.__ai_interface[archetype][attribute]["values"] = possiblevalues;
	/#
		ai_interface::_checkvalue(archetype, attribute, defaultvalue);
	#/
}

/*
	Name: registernumericinterface
	Namespace: ai
	Checksum: 0x29BA9605
	Offset: 0xB18
	Size: 0x304
	Parameters: 6
	Flags: Linked
*/
function registernumericinterface(archetype, attribute, defaultvalue, minimum, maximum, callbackfunction)
{
	/#
		ai_interface::_checkregistrationprerequisites(archetype, attribute, callbackfunction);
		/#
			assert(!isdefined(minimum) || isint(minimum) || isfloat(minimum), "");
		#/
		/#
			assert(!isdefined(maximum) || isint(maximum) || isfloat(maximum), "");
		#/
		/#
			assert(!isdefined(minimum) && !isdefined(maximum) || (isdefined(minimum) && isdefined(maximum)), "");
		#/
		/#
			assert(!isdefined(minimum) && !isdefined(maximum) || minimum <= maximum, (("" + attribute) + "") + "");
		#/
	#/
	ai_interface::_initializelevelinterface(archetype);
	/#
		/#
			assert(!isdefined(level.__ai_interface[archetype][attribute]), ((("" + attribute) + "") + archetype) + "");
		#/
	#/
	level.__ai_interface[archetype][attribute] = [];
	level.__ai_interface[archetype][attribute]["callback"] = callbackfunction;
	level.__ai_interface[archetype][attribute]["default_value"] = defaultvalue;
	level.__ai_interface[archetype][attribute]["max_value"] = maximum;
	level.__ai_interface[archetype][attribute]["min_value"] = minimum;
	level.__ai_interface[archetype][attribute]["type"] = "_interface_numeric";
	/#
		ai_interface::_checkvalue(archetype, attribute, defaultvalue);
	#/
}

/*
	Name: registervectorinterface
	Namespace: ai
	Checksum: 0xE702D1D2
	Offset: 0xE28
	Size: 0x15C
	Parameters: 4
	Flags: Linked
*/
function registervectorinterface(archetype, attribute, defaultvalue, callbackfunction)
{
	/#
		ai_interface::_checkregistrationprerequisites(archetype, attribute, callbackfunction);
	#/
	ai_interface::_initializelevelinterface(archetype);
	/#
		/#
			assert(!isdefined(level.__ai_interface[archetype][attribute]), ((("" + attribute) + "") + archetype) + "");
		#/
	#/
	level.__ai_interface[archetype][attribute] = [];
	level.__ai_interface[archetype][attribute]["callback"] = callbackfunction;
	level.__ai_interface[archetype][attribute]["default_value"] = defaultvalue;
	level.__ai_interface[archetype][attribute]["type"] = "_interface_vector";
	/#
		ai_interface::_checkvalue(archetype, attribute, defaultvalue);
	#/
}

/*
	Name: setaiattribute
	Namespace: ai
	Checksum: 0x4B1EB09
	Offset: 0xF90
	Size: 0x13A
	Parameters: 3
	Flags: Linked
*/
function setaiattribute(entity, attribute, value)
{
	/#
		ai_interface::_checkprerequisites(entity, attribute);
		ai_interface::_checkvalue(entity.archetype, attribute, value);
	#/
	oldvalue = entity.__interface[attribute];
	if(!isdefined(oldvalue))
	{
		oldvalue = level.__ai_interface[entity.archetype][attribute]["default_value"];
	}
	entity.__interface[attribute] = value;
	callback = level.__ai_interface[entity.archetype][attribute]["callback"];
	if(isfunctionptr(callback))
	{
		[[callback]](entity, attribute, oldvalue, value);
	}
}

