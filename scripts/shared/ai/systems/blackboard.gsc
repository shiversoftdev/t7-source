// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace blackboard;

/*
	Name: registerblackboardattribute
	Namespace: blackboard
	Checksum: 0x13510906
	Offset: 0x80
	Size: 0x11E
	Parameters: 4
	Flags: Linked
*/
function registerblackboardattribute(entity, attributename, defaultattributevalue, getterfunction)
{
	/#
		assert(isdefined(entity.__blackboard), "");
	#/
	/#
		assert(!isdefined(entity.__blackboard[attributename]), ("" + attributename) + "");
	#/
	if(isdefined(getterfunction))
	{
		/#
			assert(isfunctionptr(getterfunction));
		#/
		entity.__blackboard[attributename] = getterfunction;
	}
	else
	{
		if(!isdefined(defaultattributevalue))
		{
			defaultattributevalue = undefined;
		}
		entity.__blackboard[attributename] = defaultattributevalue;
	}
}

/*
	Name: getblackboardattribute
	Namespace: blackboard
	Checksum: 0x2BC848D0
	Offset: 0x1A8
	Size: 0x110
	Parameters: 2
	Flags: Linked
*/
function getblackboardattribute(entity, attributename)
{
	if(isfunctionptr(entity.__blackboard[attributename]))
	{
		getterfunction = entity.__blackboard[attributename];
		attributevalue = entity [[getterfunction]]();
		/#
			if(isactor(entity))
			{
				entity updatetrackedblackboardattribute(attributename);
			}
		#/
		return attributevalue;
	}
	/#
		if(isactor(entity))
		{
			entity updatetrackedblackboardattribute(attributename);
		}
	#/
	return entity.__blackboard[attributename];
}

/*
	Name: setblackboardattribute
	Namespace: blackboard
	Checksum: 0xD86DD684
	Offset: 0x2C8
	Size: 0x10C
	Parameters: 3
	Flags: Linked
*/
function setblackboardattribute(entity, attributename, attributevalue)
{
	if(isdefined(entity.__blackboard[attributename]))
	{
		if(!isdefined(attributevalue) && isfunctionptr(entity.__blackboard[attributename]))
		{
			return;
		}
		/#
			assert(!isfunctionptr(entity.__blackboard[attributename]), "");
		#/
	}
	entity.__blackboard[attributename] = attributevalue;
	/#
		if(isactor(entity))
		{
			entity updatetrackedblackboardattribute(attributename);
		}
	#/
}

/*
	Name: createblackboardforentity
	Namespace: blackboard
	Checksum: 0x3811A412
	Offset: 0x3E0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function createblackboardforentity(entity)
{
	if(!isdefined(entity.__blackboard))
	{
		entity.__blackboard = [];
	}
	if(!isdefined(level._setblackboardattributefunc))
	{
		level._setblackboardattributefunc = &setblackboardattribute;
	}
}

