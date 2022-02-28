// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace _zm_ai_monkey;

/*
	Name: __init__sytem__
	Namespace: _zm_ai_monkey
	Checksum: 0xF3F06799
	Offset: 0x130
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("monkey", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_ai_monkey
	Checksum: 0xE54DF840
	Offset: 0x170
	Size: 0x8E
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	ai::add_archetype_spawn_function("monkey", &function_70fb871f);
	clientfield::register("actor", "monkey_eye_glow", 21000, 1, "int", &function_2e74dabc, 0, 0);
	level._effect["monkey_eye_glow"] = "dlc5/zmhd/fx_zmb_monkey_eyes";
}

/*
	Name: function_70fb871f
	Namespace: _zm_ai_monkey
	Checksum: 0x89B64DCA
	Offset: 0x208
	Size: 0x24
	Parameters: 1
	Flags: Linked, Private
*/
function private function_70fb871f(localclientnum)
{
	self suppressragdollselfcollision(1);
}

/*
	Name: function_2e74dabc
	Namespace: _zm_ai_monkey
	Checksum: 0xD9E32814
	Offset: 0x238
	Size: 0x158
	Parameters: 7
	Flags: Linked
*/
function function_2e74dabc(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(newval)
	{
		waittillframeend();
		if(!isdefined(self))
		{
			return;
		}
		var_f9e79b00 = self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 1, 3, 0);
		self._eyearray[localclientnum] = playfxontag(localclientnum, level._effect["monkey_eye_glow"], self, "j_eyeball_le");
	}
	else
	{
		waittillframeend();
		if(!isdefined(self))
		{
			return;
		}
		var_f9e79b00 = self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 3, 0);
		if(isdefined(self._eyearray))
		{
			if(isdefined(self._eyearray[localclientnum]))
			{
				deletefx(localclientnum, self._eyearray[localclientnum], 1);
				self._eyearray[localclientnum] = undefined;
			}
		}
	}
}

