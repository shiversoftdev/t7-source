// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace mp_stronghold_sound;

/*
	Name: main
	Namespace: mp_stronghold_sound
	Checksum: 0x877E1B58
	Offset: 0xB8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread snd_dmg_chant();
}

/*
	Name: snd_dmg_chant
	Namespace: mp_stronghold_sound
	Checksum: 0xD411DBB5
	Offset: 0xE0
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function snd_dmg_chant()
{
	trigger = getent("snd_chant", "targetname");
	if(!isdefined(trigger))
	{
		return;
	}
	while(true)
	{
		trigger waittill(#"trigger", who);
		if(isplayer(who))
		{
			trigger playsound("amb_monk_chant");
		}
	}
}

