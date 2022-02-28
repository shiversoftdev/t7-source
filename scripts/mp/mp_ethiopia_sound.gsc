// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;

#namespace mp_ethiopia_sound;

/*
	Name: main
	Namespace: mp_ethiopia_sound
	Checksum: 0xC6C346D
	Offset: 0x108
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level thread snd_dmg_monk();
	level thread snd_dmg_cheet();
	level thread snd_dmg_boar();
}

/*
	Name: snd_dmg_monk
	Namespace: mp_ethiopia_sound
	Checksum: 0x14146546
	Offset: 0x160
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function snd_dmg_monk()
{
	trigger = getent("snd_monkey", "targetname");
	if(!isdefined(trigger))
	{
		return;
	}
	while(true)
	{
		trigger waittill(#"trigger", who);
		if(isplayer(who))
		{
			trigger playsound("amb_monkey_shot");
			wait(15);
		}
	}
}

/*
	Name: snd_dmg_cheet
	Namespace: mp_ethiopia_sound
	Checksum: 0x3FCF38F
	Offset: 0x208
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function snd_dmg_cheet()
{
	trigger = getent("snd_cheet", "targetname");
	if(!isdefined(trigger))
	{
		return;
	}
	while(true)
	{
		trigger waittill(#"trigger", who);
		if(isplayer(who))
		{
			trigger playsound("amb_cheeta_shot");
			wait(15);
		}
	}
}

/*
	Name: snd_dmg_boar
	Namespace: mp_ethiopia_sound
	Checksum: 0xC97A31F
	Offset: 0x2B0
	Size: 0x9E
	Parameters: 0
	Flags: Linked
*/
function snd_dmg_boar()
{
	trigger = getent("snd_boar", "targetname");
	if(!isdefined(trigger))
	{
		return;
	}
	while(true)
	{
		trigger waittill(#"trigger", who);
		if(isplayer(who))
		{
			trigger playsound("amb_boar_shot");
			wait(15);
		}
	}
}

