// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace animationstatenetwork;

/*
	Name: initanimationmocomps
	Namespace: animationstatenetwork
	Checksum: 0x7DC7C359
	Offset: 0xC8
	Size: 0x10
	Parameters: 0
	Flags: AutoExec
*/
function autoexec initanimationmocomps()
{
	level._animationmocomps = [];
}

/*
	Name: runanimationmocomp
	Namespace: animationstatenetwork
	Checksum: 0xB8F8ACDE
	Offset: 0xE0
	Size: 0x13C
	Parameters: 6
	Flags: Linked
*/
function runanimationmocomp(mocompname, mocompstatus, asmentity, mocompanim, mocompanimblendouttime, mocompduration)
{
	/#
		assert(mocompstatus >= 0 && mocompstatus <= 2, ("" + mocompstatus) + "");
	#/
	/#
		assert(isdefined(level._animationmocomps[mocompname]), ("" + mocompname) + "");
	#/
	if(mocompstatus == 0)
	{
		mocompstatus = "asm_mocomp_start";
	}
	else
	{
		if(mocompstatus == 1)
		{
			mocompstatus = "asm_mocomp_update";
		}
		else
		{
			mocompstatus = "asm_mocomp_terminate";
		}
	}
	animationmocompresult = asmentity [[level._animationmocomps[mocompname][mocompstatus]]](asmentity, mocompanim, mocompanimblendouttime, "", mocompduration);
	return animationmocompresult;
}

/*
	Name: registeranimationmocomp
	Namespace: animationstatenetwork
	Checksum: 0x789731E0
	Offset: 0x228
	Size: 0x234
	Parameters: 4
	Flags: Linked
*/
function registeranimationmocomp(mocompname, startfuncptr, updatefuncptr, terminatefuncptr)
{
	mocompname = tolower(mocompname);
	/#
		assert(isstring(mocompname), "");
	#/
	/#
		assert(!isdefined(level._animationmocomps[mocompname]), ("" + mocompname) + "");
	#/
	level._animationmocomps[mocompname] = array();
	/#
		assert(isdefined(startfuncptr) && isfunctionptr(startfuncptr), "");
	#/
	level._animationmocomps[mocompname]["asm_mocomp_start"] = startfuncptr;
	if(isdefined(updatefuncptr))
	{
		/#
			assert(isfunctionptr(updatefuncptr), "");
		#/
		level._animationmocomps[mocompname]["asm_mocomp_update"] = updatefuncptr;
	}
	else
	{
		level._animationmocomps[mocompname]["asm_mocomp_update"] = &animationmocompemptyfunc;
	}
	if(isdefined(terminatefuncptr))
	{
		/#
			assert(isfunctionptr(terminatefuncptr), "");
		#/
		level._animationmocomps[mocompname]["asm_mocomp_terminate"] = terminatefuncptr;
	}
	else
	{
		level._animationmocomps[mocompname]["asm_mocomp_terminate"] = &animationmocompemptyfunc;
	}
}

/*
	Name: animationmocompemptyfunc
	Namespace: animationstatenetwork
	Checksum: 0x2CF62241
	Offset: 0x468
	Size: 0x2C
	Parameters: 5
	Flags: Linked
*/
function animationmocompemptyfunc(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
}

