// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

#namespace zm_temple_geyser;

/*
	Name: main
	Namespace: zm_temple_geyser
	Checksum: 0xDBF776BC
	Offset: 0x190
	Size: 0x94
	Parameters: 0
	Flags: Linked
*/
function main()
{
	clientfield::register("allplayers", "geyserfakestand", 21000, 1, "int", &geyser_player_setup_stand, 0, 0);
	clientfield::register("allplayers", "geyserfakeprone", 21000, 1, "int", &geyser_player_setup_prone, 0, 0);
}

/*
	Name: geyser_player_setup_prone
	Namespace: zm_temple_geyser
	Checksum: 0xAAB74AA8
	Offset: 0x230
	Size: 0x10C
	Parameters: 7
	Flags: Linked
*/
function geyser_player_setup_prone()
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
	Cerberus.Logic.BasicBlock at 0x0230, end at 0x033D
	Cerberus.Logic.IfBlock at 0x0282, end at 0x029E
	Cerberus.Logic.IfBlock at 0x02B8, end at 0x033C
	Cerberus.Logic.IfBlock at 0x02E6, end at 0x0316
	Cerberus.Logic.IfBlock at 0x033C, end at 0x056E
	Cerberus.Logic.IfBlock at 0x0344, end at 0x0362
	Cerberus.Logic.IfBlock at 0x03D2, end at 0x0432
	Cerberus.Logic.IfBlock at 0x0466, end at 0x04B6
	Cerberus.Logic.ElseBlock at 0x0316, end at 0x033A
*/
	/* ======== */

}

/*Unknown Op Code (0x0318) at 0508*/
/*
	Name: geyser_player_setup_stand
	Namespace: zm_temple_geyser
	Checksum: 0xB8739EAE
	Offset: 0x658
	Size: 0x10C
	Parameters: 7
	Flags: Linked
*/
function geyser_player_setup_stand()
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
	Cerberus.Logic.BasicBlock at 0x0658, end at 0x0765
	Cerberus.Logic.IfBlock at 0x06AA, end at 0x06C6
	Cerberus.Logic.IfBlock at 0x06E0, end at 0x0764
	Cerberus.Logic.IfBlock at 0x070E, end at 0x073E
	Cerberus.Logic.IfBlock at 0x0764, end at 0x09BE
	Cerberus.Logic.IfBlock at 0x076C, end at 0x078A
	Cerberus.Logic.IfBlock at 0x07FA, end at 0x085A
	Cerberus.Logic.IfBlock at 0x088E, end at 0x08EE
	Cerberus.Logic.ElseBlock at 0x073E, end at 0x0762
*/
	/* ======== */

}

/*Unknown Op Code (0x1656) at 0940*/
/*
	Name: geyser_weapon_monitor
	Namespace: zm_temple_geyser
	Checksum: 0x8EAF6A1F
	Offset: 0xAA8
	Size: 0x74
	Parameters: 1
	Flags: Linked
*/
function geyser_weapon_monitor(fake_weapon)
{
	self endon(#"end_geyser");
	self endon(#"disconnect");
	while(self.weapon == "none")
	{
		wait(0.05);
	}
	if(self.weapon != "syrette")
	{
		fake_weapon useweaponhidetags(self.weapon);
	}
}

/*
	Name: player_disconnect_tracker
	Namespace: zm_temple_geyser
	Checksum: 0x612AEAE1
	Offset: 0xB28
	Size: 0x66
	Parameters: 0
	Flags: Linked
*/
function player_disconnect_tracker()
{
	self notify(#"stop_tracking");
	self endon(#"stop_tracking");
	ent_num = self getentitynumber();
	while(isdefined(self))
	{
		wait(0.05);
	}
	level notify(#"player_disconnected", ent_num);
}

/*
	Name: geyser_model_remover
	Namespace: zm_temple_geyser
	Checksum: 0xA15C22C1
	Offset: 0xB98
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function geyser_model_remover(str_endon, player)
{
	player endon(str_endon);
	level waittill(#"player_disconnected", client);
	if(isdefined(self.fake_weapon))
	{
		self.fake_weapon delete();
	}
	self delete();
}

/*
	Name: wait_for_geyser_player_to_disconnect
	Namespace: zm_temple_geyser
	Checksum: 0xA452BF0B
	Offset: 0xC18
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function wait_for_geyser_player_to_disconnect(localclientnum)
{
	str_endon = "player_geyser" + localclientnum;
	self.fake_player[localclientnum] thread geyser_model_remover(str_endon, self);
}

