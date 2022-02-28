// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

#namespace zombie_death;

/*
	Name: init_fire_fx
	Namespace: zombie_death
	Checksum: 0x70598E7A
	Offset: 0x180
	Size: 0x5A
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init_fire_fx()
{
	wait(0.016);
	if(!isdefined(level._effect))
	{
		level._effect = [];
	}
	level._effect["character_fire_death_sm"] = "zombie/fx_fire_torso_zmb";
	level._effect["character_fire_death_torso"] = "zombie/fx_fire_torso_zmb";
}

/*
	Name: on_fire_timeout
	Namespace: zombie_death
	Checksum: 0xEB2011AA
	Offset: 0x1E8
	Size: 0x5E
	Parameters: 1
	Flags: Linked
*/
function on_fire_timeout(localclientnum)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	wait(12);
	if(isdefined(self) && isalive(self))
	{
		self.is_on_fire = 0;
		self notify(#"stop_flame_damage");
	}
}

/*
	Name: flame_death_fx
	Namespace: zombie_death
	Checksum: 0xDADB1011
	Offset: 0x250
	Size: 0x334
	Parameters: 1
	Flags: Linked
*/
function flame_death_fx(localclientnum)
{
	self endon(#"death");
	self endon(#"entityshutdown");
	if(isdefined(self.is_on_fire) && self.is_on_fire)
	{
		return;
	}
	self.is_on_fire = 1;
	self thread on_fire_timeout();
	if(isdefined(level._effect) && isdefined(level._effect["character_fire_death_torso"]))
	{
		fire_tag = "j_spinelower";
		if(!isdefined(self gettagorigin(fire_tag)))
		{
			fire_tag = "tag_origin";
		}
		if(!isdefined(self.isdog) || !self.isdog)
		{
			playfxontag(localclientnum, level._effect["character_fire_death_torso"], self, fire_tag);
		}
	}
	else
	{
		/#
			println("");
		#/
	}
	if(isdefined(level._effect) && isdefined(level._effect["character_fire_death_sm"]))
	{
		if(self.archetype !== "parasite" && self.archetype !== "raps")
		{
			wait(1);
			tagarray = [];
			tagarray[0] = "J_Elbow_LE";
			tagarray[1] = "J_Elbow_RI";
			tagarray[2] = "J_Knee_RI";
			tagarray[3] = "J_Knee_LE";
			tagarray = randomize_array(tagarray);
			playfxontag(localclientnum, level._effect["character_fire_death_sm"], self, tagarray[0]);
			wait(1);
			tagarray[0] = "J_Wrist_RI";
			tagarray[1] = "J_Wrist_LE";
			if(!(isdefined(self.missinglegs) && self.missinglegs))
			{
				tagarray[2] = "J_Ankle_RI";
				tagarray[3] = "J_Ankle_LE";
			}
			tagarray = randomize_array(tagarray);
			playfxontag(localclientnum, level._effect["character_fire_death_sm"], self, tagarray[0]);
			playfxontag(localclientnum, level._effect["character_fire_death_sm"], self, tagarray[1]);
		}
	}
	else
	{
		/#
			println("");
		#/
	}
}

/*
	Name: randomize_array
	Namespace: zombie_death
	Checksum: 0x9FDF39C8
	Offset: 0x590
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function randomize_array(array)
{
	for(i = 0; i < array.size; i++)
	{
		j = randomint(array.size);
		temp = array[i];
		array[i] = array[j];
		array[j] = temp;
	}
	return array;
}

