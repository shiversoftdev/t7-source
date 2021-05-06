// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\util_shared;

#namespace burnplayer;

/*
	Name: initburnplayer
	Namespace: burnplayer
	Checksum: 0xDB1A9EC1
	Offset: 0x290
	Size: 0x20
	Parameters: 0
	Flags: None
*/
function initburnplayer()
{
	level.flamedamage = 15;
	level.flameburntime = 1.5;
}

/*
	Name: hitwithincendiary
	Namespace: burnplayer
	Checksum: 0xC392822C
	Offset: 0x2B8
	Size: 0x384
	Parameters: 3
	Flags: None
*/
function hitwithincendiary(attacker, inflictor, mod)
{
	if(isdefined(self.burning))
	{
		return;
	}
	self thread waitthenstoptanning(level.flameburntime);
	self endon(#"disconnect");
	attacker endon(#"disconnect");
	waittillframeend();
	self.burning = 1;
	self thread burn_blocker();
	tagarray = [];
	if(isai(self))
	{
		tagarray[tagarray.size] = "J_Wrist_RI";
		tagarray[tagarray.size] = "J_Wrist_LE";
		tagarray[tagarray.size] = "J_Elbow_LE";
		tagarray[tagarray.size] = "J_Elbow_RI";
		tagarray[tagarray.size] = "J_Knee_RI";
		tagarray[tagarray.size] = "J_Knee_LE";
		tagarray[tagarray.size] = "J_Ankle_RI";
		tagarray[tagarray.size] = "J_Ankle_LE";
	}
	else
	{
		tagarray[tagarray.size] = "J_Wrist_RI";
		tagarray[tagarray.size] = "J_Wrist_LE";
		tagarray[tagarray.size] = "J_Elbow_LE";
		tagarray[tagarray.size] = "J_Elbow_RI";
		tagarray[tagarray.size] = "J_Knee_RI";
		tagarray[tagarray.size] = "J_Knee_LE";
		tagarray[tagarray.size] = "J_Ankle_RI";
		tagarray[tagarray.size] = "J_Ankle_LE";
		if(isplayer(self) && self.health > 0)
		{
			self setburn(3);
		}
	}
	if(isdefined(level._effect["character_fire_death_torso"]))
	{
		for(arrayindex = 0; arrayindex < tagarray.size; arrayindex++)
		{
			playfxontag(level._effect["character_fire_death_sm"], self, tagarray[arrayindex]);
		}
	}
	if(isai(self))
	{
		playfxontag(level._effect["character_fire_death_torso"], self, "J_Spine1");
	}
	else
	{
		playfxontag(level._effect["character_fire_death_torso"], self, "J_SpineLower");
	}
	if(!isalive(self))
	{
		return;
	}
	if(isplayer(self))
	{
		self thread watchforwater(7);
		self thread watchfordeath();
	}
}

/*
	Name: hitwithnapalmstrike
	Namespace: burnplayer
	Checksum: 0x78DFAFC5
	Offset: 0x648
	Size: 0x3BC
	Parameters: 3
	Flags: None
*/
function hitwithnapalmstrike(attacker, inflictor, mod)
{
	if(isdefined(self.burning) || self hasperk("specialty_fireproof"))
	{
		return;
	}
	self thread waitthenstoptanning(level.flameburntime);
	self endon(#"disconnect");
	attacker endon(#"disconnect");
	self endon(#"death");
	if(isdefined(self.burning))
	{
		return;
	}
	self thread burn_blocker();
	waittillframeend();
	self.burning = 1;
	self thread burn_blocker();
	tagarray = [];
	if(isai(self))
	{
		tagarray[tagarray.size] = "J_Wrist_RI";
		tagarray[tagarray.size] = "J_Wrist_LE";
		tagarray[tagarray.size] = "J_Elbow_LE";
		tagarray[tagarray.size] = "J_Elbow_RI";
		tagarray[tagarray.size] = "J_Knee_RI";
		tagarray[tagarray.size] = "J_Knee_LE";
		tagarray[tagarray.size] = "J_Ankle_RI";
		tagarray[tagarray.size] = "J_Ankle_LE";
	}
	else
	{
		tagarray[tagarray.size] = "J_Wrist_RI";
		tagarray[tagarray.size] = "J_Wrist_LE";
		tagarray[tagarray.size] = "J_Elbow_LE";
		tagarray[tagarray.size] = "J_Elbow_RI";
		tagarray[tagarray.size] = "J_Knee_RI";
		tagarray[tagarray.size] = "J_Knee_LE";
		tagarray[tagarray.size] = "J_Ankle_RI";
		tagarray[tagarray.size] = "J_Ankle_LE";
		if(isplayer(self))
		{
			self setburn(3);
		}
	}
	if(isdefined(level._effect["character_fire_death_sm"]))
	{
		for(arrayindex = 0; arrayindex < tagarray.size; arrayindex++)
		{
			playfxontag(level._effect["character_fire_death_sm"], self, tagarray[arrayindex]);
		}
	}
	if(isdefined(level._effect["character_fire_death_torso"]))
	{
		playfxontag(level._effect["character_fire_death_torso"], self, "J_SpineLower");
	}
	if(!isalive(self))
	{
		return;
	}
	self thread donapalmstrikedamage(attacker, inflictor, mod);
	if(isplayer(self))
	{
		self thread watchforwater(7);
		self thread watchfordeath();
	}
}

/*
	Name: walkedthroughflames
	Namespace: burnplayer
	Checksum: 0x71486487
	Offset: 0xA10
	Size: 0x2B4
	Parameters: 3
	Flags: None
*/
function walkedthroughflames(attacker, inflictor, weapon)
{
	if(isdefined(self.burning) || self hasperk("specialty_fireproof"))
	{
		return;
	}
	self thread waitthenstoptanning(level.flameburntime);
	self endon(#"disconnect");
	waittillframeend();
	self.burning = 1;
	self thread burn_blocker();
	tagarray = [];
	if(isai(self))
	{
		tagarray[tagarray.size] = "J_Wrist_RI";
		tagarray[tagarray.size] = "J_Wrist_LE";
		tagarray[tagarray.size] = "J_Elbow_LE";
		tagarray[tagarray.size] = "J_Elbow_RI";
		tagarray[tagarray.size] = "J_Knee_RI";
		tagarray[tagarray.size] = "J_Knee_LE";
		tagarray[tagarray.size] = "J_Ankle_RI";
		tagarray[tagarray.size] = "J_Ankle_LE";
	}
	else
	{
		tagarray[tagarray.size] = "J_Knee_RI";
		tagarray[tagarray.size] = "J_Knee_LE";
		tagarray[tagarray.size] = "J_Ankle_RI";
		tagarray[tagarray.size] = "J_Ankle_LE";
	}
	if(isdefined(level._effect["character_fire_player_sm"]))
	{
		for(arrayindex = 0; arrayindex < tagarray.size; arrayindex++)
		{
			playfxontag(level._effect["character_fire_player_sm"], self, tagarray[arrayindex]);
		}
	}
	if(!isalive(self))
	{
		return;
	}
	self thread doflamedamage(attacker, inflictor, weapon, 1);
	if(isplayer(self))
	{
		self thread watchforwater(7);
		self thread watchfordeath();
	}
}

/*
	Name: burnedwithflamethrower
	Namespace: burnplayer
	Checksum: 0xFDE233A6
	Offset: 0xCD0
	Size: 0x266
	Parameters: 3
	Flags: None
*/
function burnedwithflamethrower(attacker, inflictor, weapon)
{
	if(isdefined(self.burning))
	{
		return;
	}
	self thread waitthenstoptanning(level.flameburntime);
	self endon(#"disconnect");
	waittillframeend();
	self.burning = 1;
	self thread burn_blocker();
	tagarray = [];
	if(isai(self))
	{
		tagarray[0] = "J_Spine1";
		tagarray[1] = "J_Elbow_LE";
		tagarray[2] = "J_Elbow_RI";
		tagarray[3] = "J_Head";
		tagarray[4] = "j_knee_ri";
		tagarray[5] = "j_knee_le";
	}
	else
	{
		tagarray[0] = "J_Elbow_RI";
		tagarray[1] = "j_knee_ri";
		tagarray[2] = "j_knee_le";
		if(isplayer(self) && self.health > 0)
		{
			self setburn(3);
		}
	}
	if(isplayer(self) && isalive(self))
	{
		self thread watchforwater(7);
		self thread watchfordeath();
	}
	if(isdefined(level._effect["character_fire_player_sm"]))
	{
		for(arrayindex = 0; arrayindex < tagarray.size; arrayindex++)
		{
			playfxontag(level._effect["character_fire_player_sm"], self, tagarray[arrayindex]);
		}
	}
}

/*
	Name: burnedwithdragonsbreath
	Namespace: burnplayer
	Checksum: 0xB18B1795
	Offset: 0xF40
	Size: 0x276
	Parameters: 3
	Flags: None
*/
function burnedwithdragonsbreath(attacker, inflictor, weapon)
{
	if(isdefined(self.burning))
	{
		return;
	}
	self thread waitthenstoptanning(level.flameburntime);
	self endon(#"disconnect");
	waittillframeend();
	self.burning = 1;
	self thread burn_blocker();
	tagarray = [];
	if(isai(self))
	{
		tagarray[0] = "J_Spine1";
		tagarray[1] = "J_Elbow_LE";
		tagarray[2] = "J_Elbow_RI";
		tagarray[3] = "J_Head";
		tagarray[4] = "j_knee_ri";
		tagarray[5] = "j_knee_le";
	}
	else
	{
		tagarray[0] = "j_spinelower";
		tagarray[1] = "J_Elbow_RI";
		tagarray[2] = "j_knee_ri";
		tagarray[3] = "j_knee_le";
		if(isplayer(self) && self.health > 0)
		{
			self setburn(3);
		}
	}
	if(isplayer(self) && isalive(self))
	{
		self thread watchforwater(7);
		self thread watchfordeath();
		return;
	}
	if(isdefined(level._effect["character_fire_player_sm"]))
	{
		for(arrayindex = 0; arrayindex < tagarray.size; arrayindex++)
		{
			playfxontag(level._effect["character_fire_player_sm"], self, tagarray[arrayindex]);
		}
	}
}

/*
	Name: burnedtodeath
	Namespace: burnplayer
	Checksum: 0x331C2CBF
	Offset: 0x11C0
	Size: 0x5C
	Parameters: 0
	Flags: None
*/
function burnedtodeath()
{
	self.burning = 1;
	self thread burn_blocker();
	self thread doburningsound();
	self thread waitthenstoptanning(level.flameburntime);
}

/*
	Name: watchfordeath
	Namespace: burnplayer
	Checksum: 0x550702D5
	Offset: 0x1228
	Size: 0x6E
	Parameters: 0
	Flags: None
*/
function watchfordeath()
{
	self endon(#"disconnect");
	self notify(#"hash_abaf0a23");
	self endon(#"hash_abaf0a23");
	self waittill(#"death");
	if(isplayer(self))
	{
		self _stopburning();
	}
	self.burning = undefined;
}

/*
	Name: watchforwater
	Namespace: burnplayer
	Checksum: 0xBFF4F6F2
	Offset: 0x12A0
	Size: 0xA8
	Parameters: 1
	Flags: None
*/
function watchforwater(time)
{
	self endon(#"disconnect");
	self notify(#"hash_bbb80fa");
	self endon(#"hash_bbb80fa");
	wait(0.1);
	looptime = 0.1;
	while(time > 0)
	{
		wait(looptime);
		if(self depthofplayerinwater() > 0)
		{
			finish_burn();
			time = 0;
		}
		time = time - looptime;
	}
}

/*
	Name: finish_burn
	Namespace: burnplayer
	Checksum: 0xB82D27E4
	Offset: 0x1350
	Size: 0x120
	Parameters: 0
	Flags: None
*/
function finish_burn()
{
	self notify(#"hash_3e41273b");
	tagarray = [];
	tagarray[0] = "j_spinelower";
	tagarray[1] = "J_Elbow_RI";
	tagarray[2] = "J_Head";
	tagarray[3] = "j_knee_ri";
	tagarray[4] = "j_knee_le";
	if(isdefined(level._effect["fx_fire_player_sm_smk_2sec"]))
	{
		for(arrayindex = 0; arrayindex < tagarray.size; arrayindex++)
		{
			playfxontag(level._effect["fx_fire_player_sm_smk_2sec"], self, tagarray[arrayindex]);
		}
	}
	self.burning = undefined;
	self _stopburning();
	self.ingroundnapalm = 0;
}

/*
	Name: donapalmstrikedamage
	Namespace: burnplayer
	Checksum: 0x6ED45AA1
	Offset: 0x1478
	Size: 0x116
	Parameters: 3
	Flags: None
*/
function donapalmstrikedamage(attacker, inflictor, mod)
{
	if(isai(self))
	{
		dodognapalmstrikedamage(attacker, inflictor, mod);
		return;
	}
	self endon(#"death");
	self endon(#"disconnect");
	attacker endon(#"disconnect");
	self endon(#"hash_3e41273b");
	while(isdefined(level.napalmstrikedamage) && isdefined(self) && self depthofplayerinwater() < 1)
	{
		self dodamage(level.napalmstrikedamage, self.origin, attacker, attacker, "none", mod, 0, getweapon("napalm"));
		wait(1);
	}
}

/*
	Name: donapalmgrounddamage
	Namespace: burnplayer
	Checksum: 0x4FFEC7E6
	Offset: 0x1598
	Size: 0x308
	Parameters: 3
	Flags: None
*/
function donapalmgrounddamage(attacker, inflictor, mod)
{
	if(self hasperk("specialty_fireproof"))
	{
		return;
	}
	if(level.teambased)
	{
		if(attacker != self && attacker.team == self.team)
		{
			return;
		}
	}
	if(isai(self))
	{
		dodognapalmgrounddamage(attacker, inflictor, mod);
		return;
	}
	if(isdefined(self.burning))
	{
		return;
	}
	self thread burn_blocker();
	self endon(#"death");
	self endon(#"disconnect");
	attacker endon(#"disconnect");
	self endon(#"hash_3e41273b");
	if(isdefined(level.groundburntime))
	{
		if(getdvarstring("scr_groundBurnTime") == "")
		{
			waittime = level.groundburntime;
		}
		else
		{
			waittime = getdvarfloat("scr_groundBurnTime");
		}
	}
	else
	{
		waittime = 100;
	}
	self walkedthroughflames(attacker, inflictor, getweapon("napalm"));
	self.ingroundnapalm = 1;
	if(isdefined(level.napalmgrounddamage))
	{
		if(getdvarstring("scr_napalmGroundDamage") == "")
		{
			napalmgrounddamage = level.napalmgrounddamage;
		}
		else
		{
			napalmgrounddamage = getdvarfloat("scr_napalmGroundDamage");
		}
		while(isdefined(self) && isdefined(inflictor) && self depthofplayerinwater() < 1 && waittime > 0)
		{
			self dodamage(level.napalmgrounddamage, self.origin, attacker, inflictor, "none", mod, 0, getweapon("napalm"));
			if(isplayer(self))
			{
				self setburn(1.1);
			}
			wait(1);
			waittime = waittime - 1;
		}
	}
	self.ingroundnapalm = 0;
}

/*
	Name: dodognapalmstrikedamage
	Namespace: burnplayer
	Checksum: 0xDC0E1D40
	Offset: 0x18A8
	Size: 0x96
	Parameters: 3
	Flags: None
*/
function dodognapalmstrikedamage(attacker, inflictor, mod)
{
	attacker endon(#"disconnect");
	self endon(#"death");
	self endon(#"hash_3e41273b");
	while(isdefined(level.napalmstrikedamage) && isdefined(self))
	{
		self dodamage(level.napalmstrikedamage, self.origin, attacker, attacker, "none", mod);
		wait(1);
	}
}

/*
	Name: dodognapalmgrounddamage
	Namespace: burnplayer
	Checksum: 0x3502B22D
	Offset: 0x1948
	Size: 0xAE
	Parameters: 3
	Flags: None
*/
function dodognapalmgrounddamage(attacker, inflictor, mod)
{
	attacker endon(#"disconnect");
	self endon(#"death");
	self endon(#"hash_3e41273b");
	while(isdefined(level.napalmgrounddamage) && isdefined(self))
	{
		self dodamage(level.napalmgrounddamage, self.origin, attacker, attacker, "none", mod, 0, getweapon("napalm"));
		wait(1);
	}
}

/*
	Name: burn_blocker
	Namespace: burnplayer
	Checksum: 0xDF5BA65E
	Offset: 0x1A00
	Size: 0x2A
	Parameters: 0
	Flags: None
*/
function burn_blocker()
{
	self endon(#"disconnect");
	self endon(#"death");
	wait(3);
	self.burning = undefined;
}

/*
	Name: doflamedamage
	Namespace: burnplayer
	Checksum: 0x6603A47
	Offset: 0x1A38
	Size: 0x204
	Parameters: 4
	Flags: None
*/
function doflamedamage(attacker, inflictor, weapon, time)
{
	if(isai(self))
	{
		dodogflamedamage(attacker, inflictor, weapon, time);
		return;
	}
	if(isdefined(attacker))
	{
		attacker endon(#"disconnect");
	}
	self endon(#"death");
	self endon(#"disconnect");
	self endon(#"hash_3e41273b");
	self thread doburningsound();
	self notify(#"snd_burn_scream");
	wait_time = 1;
	while(isdefined(level.flamedamage) && isdefined(self) && self depthofplayerinwater() < 1 && time > 0)
	{
		if(isdefined(attacker) && isdefined(inflictor) && isdefined(weapon))
		{
			if(damagefeedback::dodamagefeedback(weapon, attacker))
			{
				attacker damagefeedback::update();
			}
			self dodamage(level.flamedamage, self.origin, attacker, inflictor, "none", "MOD_BURNED", 0, weapon);
		}
		else
		{
			self dodamage(level.flamedamage, self.origin);
		}
		wait(wait_time);
		time = time - wait_time;
	}
	self thread finish_burn();
}

/*
	Name: dodogflamedamage
	Namespace: burnplayer
	Checksum: 0x5E4B1CB
	Offset: 0x1C48
	Size: 0x116
	Parameters: 4
	Flags: None
*/
function dodogflamedamage(attacker, inflictor, weapon, time)
{
	if(!isdefined(attacker) || !isdefined(inflictor) || !isdefined(weapon))
	{
		return;
	}
	attacker endon(#"disconnect");
	self endon(#"death");
	self endon(#"hash_3e41273b");
	self thread doburningsound();
	wait_time = 1;
	while(isdefined(level.flamedamage) && isdefined(self) && time > 0)
	{
		self dodamage(level.flamedamage, self.origin, attacker, inflictor, "none", "MOD_BURNED", 0, weapon);
		wait(wait_time);
		time = time - wait_time;
	}
}

/*
	Name: waitthenstoptanning
	Namespace: burnplayer
	Checksum: 0x991E2E71
	Offset: 0x1D68
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function waitthenstoptanning(time)
{
	self endon(#"disconnect");
	self endon(#"death");
	wait(time);
	self _stopburning();
}

/*
	Name: doburningsound
	Namespace: burnplayer
	Checksum: 0xB0B2142F
	Offset: 0x1DB0
	Size: 0x124
	Parameters: 0
	Flags: None
*/
function doburningsound()
{
	self endon(#"disconnect");
	self endon(#"death");
	fire_sound_ent = spawn("script_origin", self.origin);
	fire_sound_ent linkto(self, "tag_origin", (0, 0, 0), (0, 0, 0));
	fire_sound_ent playloopsound("mpl_player_burn_loop");
	self thread firesounddeath(fire_sound_ent);
	self waittill(#"stopburnsound");
	if(isdefined(fire_sound_ent))
	{
		fire_sound_ent stoploopsound(0.5);
	}
	wait(0.5);
	if(isdefined(fire_sound_ent))
	{
		fire_sound_ent delete();
	}
	/#
		println("");
	#/
}

/*
	Name: _stopburning
	Namespace: burnplayer
	Checksum: 0x7A6CF2FC
	Offset: 0x1EE0
	Size: 0x1A
	Parameters: 0
	Flags: None
*/
function _stopburning()
{
	self endon(#"disconnect");
	self notify(#"stopburnsound");
}

/*
	Name: firesounddeath
	Namespace: burnplayer
	Checksum: 0xA85C6B1D
	Offset: 0x1F08
	Size: 0x74
	Parameters: 1
	Flags: None
*/
function firesounddeath(ent)
{
	ent endon(#"death");
	self util::waittill_any("death", "disconnect");
	ent delete();
	/#
		println("");
	#/
}

