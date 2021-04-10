// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

#namespace burnplayer;

/*
	Name: initflamefx
	Namespace: burnplayer
	Checksum: 0x99EC1590
	Offset: 0x140
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function initflamefx()
{
}

/*
	Name: corpseflamefx
	Namespace: burnplayer
	Checksum: 0x16DFC1BC
	Offset: 0x150
	Size: 0x19C
	Parameters: 1
	Flags: None
*/
function corpseflamefx(localclientnum)
{
	self util::waittill_dobj(localclientnum);
	if(!isdefined(level._effect["character_fire_death_torso"]))
	{
		initflamefx();
	}
	tagarray = [];
	tagarray[tagarray.size] = "J_Wrist_RI";
	tagarray[tagarray.size] = "J_Wrist_LE";
	tagarray[tagarray.size] = "J_Elbow_LE";
	tagarray[tagarray.size] = "J_Elbow_RI";
	tagarray[tagarray.size] = "J_Knee_RI";
	tagarray[tagarray.size] = "J_Knee_LE";
	tagarray[tagarray.size] = "J_Ankle_RI";
	tagarray[tagarray.size] = "J_Ankle_LE";
	if(isdefined(level._effect["character_fire_death_sm"]))
	{
		for(arrayindex = 0; arrayindex < tagarray.size; arrayindex++)
		{
			playfxontag(localclientnum, level._effect["character_fire_death_sm"], self, tagarray[arrayindex]);
		}
	}
	playfxontag(localclientnum, level._effect["character_fire_death_torso"], self, "J_SpineLower");
}

