// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_proximity_grenade;

#namespace armblade;

/*
	Name: __init__sytem__
	Namespace: armblade
	Checksum: 0xAADAF54
	Offset: 0x190
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("armblade", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: armblade
	Checksum: 0x78FF9695
	Offset: 0x1D0
	Size: 0x44
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.weaponarmblade = getweapon("hero_armblade");
	callback::on_spawned(&on_player_spawned);
}

/*
	Name: on_player_spawned
	Namespace: armblade
	Checksum: 0x77FAFF85
	Offset: 0x220
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function on_player_spawned()
{
	self thread armblade_sound_thread();
}

/*
	Name: armblade_sound_thread
	Namespace: armblade
	Checksum: 0xC0D48719
	Offset: 0x248
	Size: 0x130
	Parameters: 0
	Flags: Linked
*/
function armblade_sound_thread()
{
	self endon(#"disconnect");
	self endon(#"death");
	for(;;)
	{
		result = self util::waittill_any_return("weapon_change", "disconnect");
		if(isdefined(result))
		{
			if(result == "weapon_change" && self getcurrentweapon() == level.weaponarmblade)
			{
				if(!isdefined(self.armblade_loop_sound))
				{
					self.armblade_loop_sound = spawn("script_origin", self.origin);
					self.armblade_loop_sound linkto(self);
				}
				self.armblade_loop_sound playloopsound("wpn_armblade_idle", 0.25);
				continue;
			}
			if(isdefined(self.armblade_loop_sound))
			{
				self.armblade_loop_sound stoploopsound(0.25);
			}
		}
	}
}

