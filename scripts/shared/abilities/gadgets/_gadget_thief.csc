// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace gadget_thief;

/*
	Name: __init__sytem__
	Namespace: gadget_thief
	Checksum: 0xA3A55712
	Offset: 0x2C0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("gadget_thief", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: gadget_thief
	Checksum: 0x35CB5C53
	Offset: 0x300
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("scriptmover", "gadget_thief_fx", 11000, 1, "int", &thief_clientfield_cb, 0, 0);
	clientfield::register("toplayer", "thief_state", 11000, 2, "int", &thief_ui_model_clientfield_cb, 0, 0);
	clientfield::register("toplayer", "thief_weapon_option", 11000, 4, "int", &thief_weapon_option_ui_model_clientfield_cb, 0, 0);
	clientfield::register("clientuimodel", "playerAbilities.playerGadget3.flashStart", 11000, 3, "int", undefined, 0, 0);
	clientfield::register("clientuimodel", "playerAbilities.playerGadget3.flashEnd", 11000, 3, "int", undefined, 0, 0);
	level._effect["fx_hero_blackjack_beam_source"] = "weapon/fx_hero_blackjack_beam_source";
	level._effect["fx_hero_blackjack_beam_target"] = "weapon/fx_hero_blackjack_beam_target";
	callback::on_localplayer_spawned(&on_localplayer_spawned);
}

/*
	Name: thief_clientfield_cb
	Namespace: gadget_thief
	Checksum: 0x35CA392E
	Offset: 0x4B0
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function thief_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self endon(#"entityshutdown");
	playfxoncamera(localclientnum, level._effect["fx_hero_blackjack_beam_target"], (0, 0, 0), (1, 0, 0), (0, 0, 1));
	playfx(localclientnum, level._effect["fx_hero_blackjack_beam_source"], self.origin);
}

/*
	Name: thief_ui_model_clientfield_cb
	Namespace: gadget_thief
	Checksum: 0x20CA9E20
	Offset: 0x568
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function thief_ui_model_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	update_thief(localclientnum, newval);
}

/*
	Name: thief_weapon_option_ui_model_clientfield_cb
	Namespace: gadget_thief
	Checksum: 0x972C15D5
	Offset: 0x5C8
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function thief_weapon_option_ui_model_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	update_thief_weapon(localclientnum, newval);
}

/*
	Name: update_thief
	Namespace: gadget_thief
	Checksum: 0x13A18E5E
	Offset: 0x628
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function update_thief(localclientnum, newval)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	if(isdefined(controllermodel))
	{
		thiefstatusmodel = getuimodel(controllermodel, "playerAbilities.playerGadget3.thiefStatus");
		if(isdefined(thiefstatusmodel))
		{
			setuimodelvalue(thiefstatusmodel, newval);
		}
	}
}

/*
	Name: update_thief_weapon
	Namespace: gadget_thief
	Checksum: 0xA47497FB
	Offset: 0x6C0
	Size: 0x8C
	Parameters: 2
	Flags: Linked
*/
function update_thief_weapon(localclientnum, newval)
{
	controllermodel = getuimodelforcontroller(localclientnum);
	if(isdefined(controllermodel))
	{
		thiefstatusmodel = getuimodel(controllermodel, "playerAbilities.playerGadget3.thiefWeaponStatus");
		if(isdefined(thiefstatusmodel))
		{
			setuimodelvalue(thiefstatusmodel, newval);
		}
	}
}

/*
	Name: on_localplayer_spawned
	Namespace: gadget_thief
	Checksum: 0xB162C55C
	Offset: 0x758
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function on_localplayer_spawned(localclientnum)
{
	thief_state = 0;
	thief_weapon_option = 0;
	if(getserverhighestclientfieldversion() >= 11000)
	{
		thief_state = self clientfield::get_to_player("thief_state");
		thief_weapon_option = self clientfield::get_to_player("thief_weapon_option");
	}
	update_thief(localclientnum, thief_state);
	update_thief_weapon(localclientnum, thief_weapon_option);
}

