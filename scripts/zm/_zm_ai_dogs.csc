// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\zm\_zm;

#namespace zm_ai_dogs;

/*
	Name: __init__sytem__
	Namespace: zm_ai_dogs
	Checksum: 0x81CFE88A
	Offset: 0x168
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_ai_dogs", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_ai_dogs
	Checksum: 0xC9EF2B95
	Offset: 0x1A8
	Size: 0x5C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	init_dog_fx();
	clientfield::register("actor", "dog_fx", 1, 1, "int", &dog_fx, 0, 0);
}

/*
	Name: init_dog_fx
	Namespace: zm_ai_dogs
	Checksum: 0xB159AC32
	Offset: 0x210
	Size: 0x3A
	Parameters: 0
	Flags: Linked
*/
function init_dog_fx()
{
	level._effect["dog_eye_glow"] = "zombie/fx_dog_eyes_zmb";
	level._effect["dog_trail_fire"] = "zombie/fx_dog_fire_trail_zmb";
}

/*
	Name: dog_fx
	Namespace: zm_ai_dogs
	Checksum: 0x1093AA1F
	Offset: 0x258
	Size: 0x17C
	Parameters: 7
	Flags: Linked
*/
function dog_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self._eyeglow_fx_override = level._effect["dog_eye_glow"];
		self zm::createzombieeyes(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, zm::get_eyeball_on_luminance(), self zm::get_eyeball_color());
		self.n_trails_fx_id = playfxontag(localclientnum, level._effect["dog_trail_fire"], self, "j_spine2");
	}
	else
	{
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, zm::get_eyeball_off_luminance(), self zm::get_eyeball_color());
		self zm::deletezombieeyes(localclientnum);
		if(isdefined(self.n_trails_fx_id))
		{
			deletefx(localclientnum, self.n_trails_fx_id);
		}
	}
}

