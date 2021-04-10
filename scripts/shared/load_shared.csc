// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\_explode;
#using scripts\shared\blood;
#using scripts\shared\drown;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\player_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\water_surface;
#using scripts\shared\weapons\_empgrenade;
#using scripts\shared\weapons_shared;

#namespace load;

/*
	Name: __init__sytem__
	Namespace: load
	Checksum: 0xA6285F1A
	Offset: 0x228
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("load", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: load
	Checksum: 0xEB152B63
	Offset: 0x268
	Size: 0x2C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		level thread first_frame();
	#/
	function_b018f2a7();
}

/*
	Name: first_frame
	Namespace: load
	Checksum: 0xBF1FDC1
	Offset: 0x2A0
	Size: 0x26
	Parameters: 0
	Flags: Linked
*/
function first_frame()
{
	/#
		level.first_frame = 1;
		wait(0.05);
		level.first_frame = undefined;
	#/
}

/*
	Name: function_b018f2a7
	Namespace: load
	Checksum: 0xCB85F097
	Offset: 0x2D0
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function function_b018f2a7()
{
	var_ae867510 = getdvarfloat("tu16_physicsPushOutThreshold", -1);
	if(var_ae867510 != -1)
	{
		setdvar("tu16_physicsPushOutThreshold", 20);
	}
}

/*
	Name: art_review
	Namespace: load
	Checksum: 0xC008A629
	Offset: 0x340
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function art_review()
{
	if(getdvarstring("art_review") == "")
	{
		setdvar("art_review", "0");
	}
	if(getdvarstring("art_review") == "1")
	{
		level waittill(#"forever");
	}
}

