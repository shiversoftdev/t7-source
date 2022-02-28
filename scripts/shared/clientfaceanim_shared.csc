// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace clientfaceanim;

/*
	Name: __init__sytem__
	Namespace: clientfaceanim
	Checksum: 0x80E118D8
	Offset: 0x328
	Size: 0x2C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("clientfaceanim_shared", undefined, &main, undefined);
}

/*
	Name: main
	Namespace: clientfaceanim
	Checksum: 0xA42D971C
	Offset: 0x360
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function main()
{
	callback::on_spawned(&on_player_spawned);
	level._clientfaceanimonplayerspawned = &on_player_spawned;
}

/*
	Name: on_player_spawned
	Namespace: clientfaceanim
	Checksum: 0xBBE2C022
	Offset: 0x3A8
	Size: 0x5C
	Parameters: 1
	Flags: Linked, Private
*/
function private on_player_spawned(localclientnum)
{
	facialanimationsinit(localclientnum);
	self callback::on_shutdown(&on_player_shutdown);
	self thread on_player_death(localclientnum);
}

/*
	Name: on_player_shutdown
	Namespace: clientfaceanim
	Checksum: 0x313D414B
	Offset: 0x410
	Size: 0xD8
	Parameters: 1
	Flags: Linked, Private
*/
function private on_player_shutdown(localclientnum)
{
	if(self isplayer())
	{
		self notify(#"stopfacialthread");
		corpse = self getplayercorpse();
		if(!isdefined(corpse))
		{
			return;
		}
		if(isdefined(corpse.facialdeathanimstarted) && corpse.facialdeathanimstarted)
		{
			return;
		}
		corpse util::waittill_dobj(localclientnum);
		if(isdefined(corpse))
		{
			corpse applydeathanim(localclientnum);
			corpse.facialdeathanimstarted = 1;
		}
	}
}

/*
	Name: on_player_death
	Namespace: clientfaceanim
	Checksum: 0xF32C995
	Offset: 0x4F0
	Size: 0xE8
	Parameters: 1
	Flags: Linked, Private
*/
function private on_player_death(localclientnum)
{
	self endon(#"entityshutdown");
	self waittill(#"death");
	if(self isplayer())
	{
		self notify(#"stopfacialthread");
		corpse = self getplayercorpse();
		if(isdefined(corpse.facialdeathanimstarted) && corpse.facialdeathanimstarted)
		{
			return;
		}
		corpse util::waittill_dobj(localclientnum);
		if(isdefined(corpse))
		{
			corpse applydeathanim(localclientnum);
			corpse.facialdeathanimstarted = 1;
		}
	}
}

/*
	Name: facialanimationsinit
	Namespace: clientfaceanim
	Checksum: 0xFA166F08
	Offset: 0x5E0
	Size: 0x54
	Parameters: 1
	Flags: Linked, Private
*/
function private facialanimationsinit(localclientnum)
{
	buildandvalidatefacialanimationlist(localclientnum);
	if(self isplayer())
	{
		self thread facialanimationthink(localclientnum);
	}
}

/*
	Name: buildandvalidatefacialanimationlist
	Namespace: clientfaceanim
	Checksum: 0xC86E8F29
	Offset: 0x640
	Size: 0x2BA
	Parameters: 1
	Flags: Linked
*/
function buildandvalidatefacialanimationlist(localclientnum)
{
	if(!isdefined(level.__clientfacialanimationslist))
	{
		level.__clientfacialanimationslist = [];
		level.__clientfacialanimationslist["combat"] = array("ai_face_male_generic_idle_1", "ai_face_male_generic_idle_2", "ai_face_male_generic_idle_3");
		level.__clientfacialanimationslist["combat_shoot"] = array("ai_face_male_aim_fire_1", "ai_face_male_aim_fire_2", "ai_face_male_aim_fire_3");
		level.__clientfacialanimationslist["death"] = array("ai_face_male_death_1", "ai_face_male_death_2", "ai_face_male_death_3");
		level.__clientfacialanimationslist["melee"] = array("ai_face_male_melee_1");
		level.__clientfacialanimationslist["pain"] = array("ai_face_male_pain_1");
		level.__clientfacialanimationslist["swimming"] = array("mp_face_male_swim_idle_1");
		level.__clientfacialanimationslist["jumping"] = array("mp_face_male_jump_idle_1");
		level.__clientfacialanimationslist["sliding"] = array("mp_face_male_slides_1");
		level.__clientfacialanimationslist["sprinting"] = array("mp_face_male_sprint_1");
		level.__clientfacialanimationslist["wallrunning"] = array("mp_face_male_wall_run_1");
		deathanims = level.__clientfacialanimationslist["death"];
		foreach(deathanim in deathanims)
		{
			/#
				assert(!isanimlooping(localclientnum, deathanim), ("" + deathanim) + "");
			#/
		}
	}
}

/*
	Name: facialanimationthink_getwaittime
	Namespace: clientfaceanim
	Checksum: 0x5CBB042C
	Offset: 0x908
	Size: 0x170
	Parameters: 1
	Flags: Linked, Private
*/
function private facialanimationthink_getwaittime(localclientnum)
{
	if(!isdefined(localclientnum))
	{
		return 1;
	}
	min_wait = 0.1;
	max_wait = 1;
	min_wait_distance_sq = 2500;
	max_wait_distance_sq = 640000;
	local_player = getlocalplayer(localclientnum);
	if(!isdefined(local_player))
	{
		return max_wait;
	}
	if(local_player == self && !isthirdperson(localclientnum))
	{
		return max_wait;
	}
	distancesq = distancesquared(local_player.origin, self.origin);
	if(distancesq > max_wait_distance_sq)
	{
		distance_factor = 1;
	}
	else
	{
		if(distancesq < min_wait_distance_sq)
		{
			distance_factor = 0;
		}
		else
		{
			distance_factor = (distancesq - min_wait_distance_sq) / (max_wait_distance_sq - min_wait_distance_sq);
		}
	}
	return ((max_wait - min_wait) * distance_factor) + min_wait;
}

/*
	Name: facialanimationthink
	Namespace: clientfaceanim
	Checksum: 0xB6D6EF24
	Offset: 0xA80
	Size: 0xF2
	Parameters: 1
	Flags: Linked, Private
*/
function private facialanimationthink(localclientnum)
{
	self endon(#"entityshutdown");
	self notify(#"stopfacialthread");
	self endon(#"stopfacialthread");
	if(isdefined(self.__clientfacialanimationsthinkstarted))
	{
		return;
	}
	self.__clientfacialanimationsthinkstarted = 1;
	/#
		assert(self isplayer());
	#/
	self util::waittill_dobj(localclientnum);
	while(isdefined(self))
	{
		updatefacialanimforplayer(localclientnum, self);
		wait_time = self facialanimationthink_getwaittime(localclientnum);
		if(!isdefined(wait_time))
		{
			wait_time = 1;
		}
		wait(wait_time);
	}
}

/*
	Name: updatefacialanimforplayer
	Namespace: clientfaceanim
	Checksum: 0x4E24A182
	Offset: 0xB80
	Size: 0x2A8
	Parameters: 2
	Flags: Linked, Private
*/
function private updatefacialanimforplayer(localclientnum, player)
{
	if(!isdefined(player))
	{
		return;
	}
	if(!isdefined(localclientnum))
	{
		return;
	}
	if(!isdefined(player._currentfacestate))
	{
		player._currentfacestate = "inactive";
	}
	currfacestate = player._currentfacestate;
	nextfacestate = player._currentfacestate;
	if(player isinscritpedanim())
	{
		clearallfacialanims(localclientnum);
		player._currentfacestate = "inactive";
		return;
	}
	if(player isplayerdead())
	{
		nextfacestate = "death";
	}
	else
	{
		if(player isplayerfiring())
		{
			nextfacestate = "combat_shoot";
		}
		else
		{
			if(player isplayersliding())
			{
				nextfacestate = "sliding";
			}
			else
			{
				if(player isplayerwallrunning())
				{
					nextfacestate = "wallrunning";
				}
				else
				{
					if(player isplayersprinting())
					{
						nextfacestate = "sprinting";
					}
					else
					{
						if(player isplayerjumping() || player isplayerdoublejumping())
						{
							nextfacestate = "jumping";
						}
						else
						{
							if(player isplayerswimming())
							{
								nextfacestate = "swimming";
							}
							else
							{
								nextfacestate = "combat";
							}
						}
					}
				}
			}
		}
	}
	if(player._currentfacestate == "inactive" || currfacestate != nextfacestate)
	{
		/#
			assert(isdefined(level.__clientfacialanimationslist[nextfacestate]));
		#/
		applynewfaceanim(localclientnum, array::random(level.__clientfacialanimationslist[nextfacestate]));
		player._currentfacestate = nextfacestate;
	}
}

/*
	Name: applynewfaceanim
	Namespace: clientfaceanim
	Checksum: 0x962F22E9
	Offset: 0xE30
	Size: 0x7C
	Parameters: 2
	Flags: Linked, Private
*/
function private applynewfaceanim(localclientnum, animation)
{
	clearallfacialanims(localclientnum);
	if(isdefined(animation))
	{
		self._currentfaceanim = animation;
		self setflaggedanimknob("ai_secondary_facial_anim", animation, 1, 0.1, 1);
	}
}

/*
	Name: applydeathanim
	Namespace: clientfaceanim
	Checksum: 0x4E830B8D
	Offset: 0xEB8
	Size: 0xA4
	Parameters: 1
	Flags: Linked, Private
*/
function private applydeathanim(localclientnum)
{
	if(isdefined(self._currentfacestate) && self._currentfacestate == "death")
	{
		return;
	}
	if(isdefined(self) && isdefined(level.__clientfacialanimationslist) && isdefined(level.__clientfacialanimationslist["death"]))
	{
		self._currentfacestate = "death";
		applynewfaceanim(localclientnum, array::random(level.__clientfacialanimationslist["death"]));
	}
}

/*
	Name: clearallfacialanims
	Namespace: clientfaceanim
	Checksum: 0x87D8F06A
	Offset: 0xF68
	Size: 0x66
	Parameters: 1
	Flags: Linked, Private
*/
function private clearallfacialanims(localclientnum)
{
	if(isdefined(self._currentfaceanim) && self hasdobj(localclientnum))
	{
		self clearanim(self._currentfaceanim, 0.2);
	}
	self._currentfaceanim = undefined;
}

