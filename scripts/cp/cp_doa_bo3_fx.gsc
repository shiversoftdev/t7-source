// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;

#namespace namespace_e8effba5;

/*
	Name: main
	Namespace: namespace_e8effba5
	Checksum: 0x567E5419
	Offset: 0x188
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level._effect["raps_meteor_fire"] = "zombie/fx_meatball_trail_zmb";
	level._effect["lightning_raps_spawn"] = "zombie/fx_dog_lightning_buildup_zmb";
	level._effect["raps_gib"] = "zombie/fx_dog_explosion_zmb";
	level._effect["raps_trail_fire"] = "zombie/fx_raps_fire_trail_zmb";
	level._effect["raps_trail_ash"] = "zombie/fx_dog_ash_trail_zmb";
}

/*
	Name: raps_explode_fx
	Namespace: namespace_e8effba5
	Checksum: 0xB9768B45
	Offset: 0x220
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function raps_explode_fx(origin)
{
	playfx(level._effect["raps_gib"], origin);
	playsoundatposition("zmb_hellhound_explode", origin);
}

