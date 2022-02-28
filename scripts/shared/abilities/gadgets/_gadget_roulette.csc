// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace gadget_roulette;

/*
	Name: __init__sytem__
	Namespace: gadget_roulette
	Checksum: 0xFC02A92D
	Offset: 0x188
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_roulette", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: gadget_roulette
	Checksum: 0xDE03DE54
	Offset: 0x1C8
	Size: 0x6C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("toplayer", "roulette_state", 11000, 2, "int", &roulette_clientfield_cb, 0, 0);
	callback::on_localplayer_spawned(&on_localplayer_spawned);
}

/*
	Name: roulette_clientfield_cb
	Namespace: gadget_roulette
	Checksum: 0x58A93926
	Offset: 0x240
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function roulette_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	update_roulette(localclientnum, newval);
}

/*
	Name: update_roulette
	Namespace: gadget_roulette
	Checksum: 0x1896B8F6
	Offset: 0x2A0
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function update_roulette(localclientnum, newval)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	if(isdefined(controllermodel))
	{
		roulettestatusmodel = getuimodel(controllermodel, "playerAbilities.playerGadget3.rouletteStatus");
		if(isdefined(roulettestatusmodel))
		{
			setuimodelvalue(roulettestatusmodel, newval);
		}
	}
}

/*
	Name: on_localplayer_spawned
	Namespace: gadget_roulette
	Checksum: 0x2086FA7B
	Offset: 0x338
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_spawned(localclientnum)
{
	roulette_state = 0;
	if(getserverhighestclientfieldversion() >= 11000)
	{
		roulette_state = self clientfield::get_to_player("roulette_state");
	}
	update_roulette(localclientnum, roulette_state);
}

