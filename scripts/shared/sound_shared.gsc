// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\util_shared;

#namespace sound;

/*
	Name: loop_fx_sound
	Namespace: sound
	Checksum: 0x58245982
	Offset: 0xB8
	Size: 0xA4
	Parameters: 3
	Flags: Linked
*/
function loop_fx_sound(alias, origin, ender)
{
	org = spawn("script_origin", (0, 0, 0));
	if(isdefined(ender))
	{
		thread loop_delete(ender, org);
		self endon(ender);
	}
	org.origin = origin;
	org playloopsound(alias);
}

/*
	Name: loop_delete
	Namespace: sound
	Checksum: 0xD927BE59
	Offset: 0x168
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function loop_delete(ender, ent)
{
	ent endon(#"death");
	self waittill(ender);
	ent delete();
}

/*
	Name: play_in_space
	Namespace: sound
	Checksum: 0x5B6206DD
	Offset: 0x1B8
	Size: 0xC4
	Parameters: 3
	Flags: Linked
*/
function play_in_space(alias, origin, master)
{
	org = spawn("script_origin", (0, 0, 1));
	if(!isdefined(origin))
	{
		origin = self.origin;
	}
	org.origin = origin;
	org playsoundwithnotify(alias, "sounddone");
	org waittill(#"sounddone");
	if(isdefined(org))
	{
		org delete();
	}
}

/*
	Name: loop_on_tag
	Namespace: sound
	Checksum: 0xE6C1C665
	Offset: 0x288
	Size: 0x15C
	Parameters: 3
	Flags: Linked
*/
function loop_on_tag(alias, tag, bstopsoundondeath)
{
	org = spawn("script_origin", (0, 0, 0));
	org endon(#"death");
	if(!isdefined(bstopsoundondeath))
	{
		bstopsoundondeath = 1;
	}
	if(bstopsoundondeath)
	{
		thread util::delete_on_death(org);
	}
	if(isdefined(tag))
	{
		org linkto(self, tag, (0, 0, 0), (0, 0, 0));
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto(self);
	}
	org playloopsound(alias);
	self waittill("stop sound" + alias);
	org stoploopsound(alias);
	org delete();
}

/*
	Name: play_on_tag
	Namespace: sound
	Checksum: 0x4B1702D3
	Offset: 0x3F0
	Size: 0x19C
	Parameters: 3
	Flags: Linked
*/
function play_on_tag(alias, tag, ends_on_death)
{
	org = spawn("script_origin", (0, 0, 0));
	org endon(#"death");
	thread delete_on_death_wait(org, "sounddone");
	if(isdefined(tag))
	{
		org.origin = self gettagorigin(tag);
		org linkto(self, tag, (0, 0, 0), (0, 0, 0));
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto(self);
	}
	org playsoundwithnotify(alias, "sounddone");
	if(isdefined(ends_on_death))
	{
		/#
			assert(ends_on_death, "");
		#/
		wait_for_sounddone_or_death(org);
		wait(0.05);
	}
	else
	{
		org waittill(#"sounddone");
	}
	org delete();
}

/*
	Name: play_on_entity
	Namespace: sound
	Checksum: 0x5A2CFDDF
	Offset: 0x598
	Size: 0x24
	Parameters: 1
	Flags: None
*/
function play_on_entity(alias)
{
	play_on_tag(alias);
}

/*
	Name: wait_for_sounddone_or_death
	Namespace: sound
	Checksum: 0x32AE8974
	Offset: 0x5C8
	Size: 0x26
	Parameters: 1
	Flags: Linked
*/
function wait_for_sounddone_or_death(org)
{
	self endon(#"death");
	org waittill(#"sounddone");
}

/*
	Name: stop_loop_on_entity
	Namespace: sound
	Checksum: 0x16A8D5E0
	Offset: 0x5F8
	Size: 0x20
	Parameters: 1
	Flags: None
*/
function stop_loop_on_entity(alias)
{
	self notify("stop sound" + alias);
}

/*
	Name: loop_on_entity
	Namespace: sound
	Checksum: 0xE09CA0E2
	Offset: 0x620
	Size: 0x164
	Parameters: 2
	Flags: None
*/
function loop_on_entity(alias, offset)
{
	org = spawn("script_origin", (0, 0, 0));
	org endon(#"death");
	thread util::delete_on_death(org);
	if(isdefined(offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org linkto(self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto(self);
	}
	org playloopsound(alias);
	self waittill("stop sound" + alias);
	org stoploopsound(0.1);
	org delete();
}

/*
	Name: loop_in_space
	Namespace: sound
	Checksum: 0x43CF5034
	Offset: 0x790
	Size: 0xCC
	Parameters: 3
	Flags: None
*/
function loop_in_space(alias, origin, ender)
{
	org = spawn("script_origin", (0, 0, 1));
	if(!isdefined(origin))
	{
		origin = self.origin;
	}
	org.origin = origin;
	org playloopsound(alias);
	level waittill(ender);
	org stoploopsound();
	wait(0.1);
	org delete();
}

/*
	Name: delete_on_death_wait
	Namespace: sound
	Checksum: 0x5E68983
	Offset: 0x868
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function delete_on_death_wait(ent, sounddone)
{
	ent endon(#"death");
	self waittill(#"death");
	if(isdefined(ent))
	{
		ent delete();
	}
}

/*
	Name: play_on_players
	Namespace: sound
	Checksum: 0xE2110BAB
	Offset: 0x8C0
	Size: 0x176
	Parameters: 2
	Flags: None
*/
function play_on_players(sound, team)
{
	/#
		assert(isdefined(level.players));
	#/
	if(level.splitscreen)
	{
		if(isdefined(level.players[0]))
		{
			level.players[0] playlocalsound(sound);
		}
	}
	else
	{
		if(isdefined(team))
		{
			for(i = 0; i < level.players.size; i++)
			{
				player = level.players[i];
				if(isdefined(player.pers["team"]) && player.pers["team"] == team)
				{
					player playlocalsound(sound);
				}
			}
		}
		else
		{
			for(i = 0; i < level.players.size; i++)
			{
				level.players[i] playlocalsound(sound);
			}
		}
	}
}

