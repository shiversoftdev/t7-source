// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_weapons;

#namespace _zm_weap_tesla;

/*
	Name: init
	Namespace: _zm_weap_tesla
	Checksum: 0x744BFA64
	Offset: 0x340
	Size: 0x184
	Parameters: 0
	Flags: None
*/
function init()
{
	level.weaponzmteslagun = getweapon("tesla_gun");
	level.weaponzmteslagunupgraded = getweapon("tesla_gun_upgraded");
	if(!zm_weapons::is_weapon_included(level.weaponzmteslagun) && (!(isdefined(level.uses_tesla_powerup) && level.uses_tesla_powerup)))
	{
		return;
	}
	level._effect["tesla_viewmodel_rail"] = "zombie/fx_tesla_rail_view_zmb";
	level._effect["tesla_viewmodel_tube"] = "zombie/fx_tesla_tube_view_zmb";
	level._effect["tesla_viewmodel_tube2"] = "zombie/fx_tesla_tube_view2_zmb";
	level._effect["tesla_viewmodel_tube3"] = "zombie/fx_tesla_tube_view3_zmb";
	level._effect["tesla_viewmodel_rail_upgraded"] = "zombie/fx_tesla_rail_view_ug_zmb";
	level._effect["tesla_viewmodel_tube_upgraded"] = "zombie/fx_tesla_tube_view_ug_zmb";
	level._effect["tesla_viewmodel_tube2_upgraded"] = "zombie/fx_tesla_tube_view2_ug_zmb";
	level._effect["tesla_viewmodel_tube3_upgraded"] = "zombie/fx_tesla_tube_view3_ug_zmb";
	level thread player_init();
	level thread tesla_notetrack_think();
}

/*
	Name: player_init
	Namespace: _zm_weap_tesla
	Checksum: 0x69C2FB84
	Offset: 0x4D0
	Size: 0x10E
	Parameters: 0
	Flags: Linked
*/
function player_init()
{
	util::waitforclient(0);
	level.tesla_play_fx = [];
	level.tesla_play_rail = 1;
	players = getlocalplayers();
	for(i = 0; i < players.size; i++)
	{
		level.tesla_play_fx[i] = 0;
		players[i] thread tesla_fx_rail(i);
		players[i] thread tesla_fx_tube(i);
		players[i] thread tesla_happy(i);
		players[i] thread tesla_change_watcher(i);
	}
}

/*
	Name: tesla_fx_rail
	Namespace: _zm_weap_tesla
	Checksum: 0x308FBEA
	Offset: 0x5E8
	Size: 0x0
	Parameters: 1
	Flags: Linked
*/
function tesla_fx_rail(localclientnum)
{
}

/*Unknown Op Code (0x0B28) at 0630*/
/*
	Name: tesla_fx_tube
	Namespace: _zm_weap_tesla
	Checksum: 0x5C5F757E
	Offset: 0x7A8
	Size: 0x0
	Parameters: 1
	Flags: Linked
*/
function tesla_fx_tube(localclientnum)
{
}

/*Unknown Op Code (0x0540) at 07F0*/
/*
	Name: tesla_notetrack_think
	Namespace: _zm_weap_tesla
	Checksum: 0x2EA8FE49
	Offset: 0xB00
	Size: 0x7A
	Parameters: 0
	Flags: Linked
*/
function tesla_notetrack_think()
{
	for(;;)
	{
		level waittill(#"notetrack", localclientnum, note);
		switch(note)
		{
			case "tesla_play_fx_off":
			{
				level.tesla_play_fx[localclientnum] = 0;
				break;
			}
			case "tesla_play_fx_on":
			{
				level.tesla_play_fx[localclientnum] = 1;
				break;
			}
		}
	}
}

/*
	Name: tesla_happy
	Namespace: _zm_weap_tesla
	Checksum: 0x8011AB1B
	Offset: 0xB88
	Size: 0x0
	Parameters: 1
	Flags: Linked
*/
function tesla_happy()
{
System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at System.Collections.Generic.List`1.get_Item(Int32 index)
   at Cerberus.Logic.Decompiler.FindElseIfStatements() in D:\Modding\Call of Duty\t89-dec\Cerberus.Logic\Decompiler\Decompiler.cs:line 649
   at Cerberus.Logic.Decompiler..ctor(ScriptExport function, ScriptBase script) in D:\Modding\Call of Duty\t89-dec\Cerberus.Logic\Decompiler\Decompiler.cs:line 211
/*
No Output
*/

	/* ======== */

/* 
	Stack: 
*/
	/* ======== */

/* 
	Blocks: 
	Cerberus.Logic.BasicBlock at 0x0B88, end at 0x0B89
	Cerberus.Logic.IfBlock at 0x0BBE, end at 0x0C22
*/
	/* ======== */

}

/*Unknown Op Code (0x1C63) at 0C12*/
/*
	Name: tesla_change_watcher
	Namespace: _zm_weap_tesla
	Checksum: 0xE074B7D5
	Offset: 0xC30
	Size: 0x48
	Parameters: 1
	Flags: Linked
*/
function tesla_change_watcher(localclientnum)
{
	self endon(#"disconnect");
	while(true)
	{
		self waittill(#"weapon_change");
		self clear_tesla_tube_effect(localclientnum);
	}
}

/*
	Name: clear_tesla_tube_effect
	Namespace: _zm_weap_tesla
	Checksum: 0x94EA0EE4
	Offset: 0xC80
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function clear_tesla_tube_effect(localclientnum)
{
	if(isdefined(self.n_tesla_tube_fx_id))
	{
		deletefx(localclientnum, self.n_tesla_tube_fx_id, 1);
		self.n_tesla_tube_fx_id = undefined;
		self.str_tesla_current_tube_effect = undefined;
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 1, 3, 0);
	}
}

