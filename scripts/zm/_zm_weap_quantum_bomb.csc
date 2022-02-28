// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm_weapons;

#namespace zm_weap_quantum_bomb;

/*
	Name: __init__sytem__
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x3333389C
	Offset: 0x1D8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_weap_quantum_bomb", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x23D6B394
	Offset: 0x218
	Size: 0x84
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	callback::add_weapon_type(getweapon("quantum_bomb"), &quantum_bomb_spawned);
	level._effect["quantum_bomb_viewmodel_twist"] = "dlc5/zmb_weapon/fx_twist";
	level._effect["quantum_bomb_viewmodel_press"] = "dlc5/zmb_weapon/fx_press";
	level thread quantum_bomb_notetrack_think();
}

/*
	Name: quantum_bomb_notetrack_think
	Namespace: zm_weap_quantum_bomb
	Checksum: 0x8D1F7953
	Offset: 0x2A8
	Size: 0xBA
	Parameters: 0
	Flags: Linked
*/
function quantum_bomb_notetrack_think()
{
	for(;;)
	{
		level waittill(#"notetrack", localclientnum, note);
		switch(note)
		{
			case "quantum_bomb_twist":
			{
				playviewmodelfx(localclientnum, level._effect["quantum_bomb_viewmodel_twist"], "tag_weapon");
				break;
			}
			case "quantum_bomb_press":
			{
				playviewmodelfx(localclientnum, level._effect["quantum_bomb_viewmodel_press"], "tag_weapon");
				break;
			}
		}
	}
}

/*
	Name: quantum_bomb_spawned
	Namespace: zm_weap_quantum_bomb
	Checksum: 0xC30F72D7
	Offset: 0x370
	Size: 0xAC
	Parameters: 2
	Flags: Linked
*/
function quantum_bomb_spawned(localclientnum, play_sound)
{
	temp_ent = spawn(0, self.origin, "script_origin");
	temp_ent playloopsound("wpn_quantum_rise", 0.5);
	while(isdefined(self))
	{
		temp_ent.origin = self.origin;
		wait(0.05);
	}
	temp_ent delete();
}

