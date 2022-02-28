// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace beam;

/*
	Name: launch
	Namespace: beam
	Checksum: 0xB7886A61
	Offset: 0x110
	Size: 0x1CC
	Parameters: 5
	Flags: Linked
*/
function launch(ent_1, str_tag1, ent_2, str_tag2, str_beam_type)
{
	s_beam = _get_beam(ent_1, str_tag1, ent_2, str_tag2, str_beam_type);
	if(!isdefined(s_beam))
	{
		s_beam = _new_beam(ent_1, str_tag1, ent_2, str_tag2, str_beam_type);
	}
	if(self == level)
	{
		if(isdefined(level.localplayers))
		{
			foreach(player in level.localplayers)
			{
				if(isdefined(player))
				{
					player launch(ent_1, str_tag1, ent_2, str_tag2, str_beam_type);
				}
			}
		}
	}
	else if(isdefined(s_beam))
	{
		s_beam.beam_id = beamlaunch(self.localclientnum, ent_1, str_tag1, ent_2, str_tag2, str_beam_type);
		self thread _kill_on_ent_death(s_beam, ent_1, ent_2);
		return s_beam.beam_id;
	}
}

/*
	Name: kill
	Namespace: beam
	Checksum: 0xF8CAF966
	Offset: 0x2E8
	Size: 0x184
	Parameters: 5
	Flags: Linked
*/
function kill(ent_1, str_tag1, ent_2, str_tag2, str_beam_type)
{
	if(isdefined(self.active_beams))
	{
		s_beam = _get_beam(ent_1, str_tag1, ent_2, str_tag2, str_beam_type);
		arrayremovevalue(self.active_beams, s_beam, 0);
	}
	if(self == level)
	{
		if(isdefined(level.localplayers))
		{
			foreach(player in level.localplayers)
			{
				if(isdefined(player))
				{
					player kill(ent_1, str_tag1, ent_2, str_tag2, str_beam_type);
				}
			}
		}
	}
	else if(isdefined(s_beam))
	{
		s_beam notify(#"kill");
		beamkill(self.localclientnum, s_beam.beam_id);
	}
}

/*
	Name: _new_beam
	Namespace: beam
	Checksum: 0x5E65883A
	Offset: 0x478
	Size: 0x136
	Parameters: 5
	Flags: Linked, Private
*/
function private _new_beam(ent_1, str_tag1, ent_2, str_tag2, str_beam_type)
{
	if(!isdefined(self.active_beams))
	{
		self.active_beams = [];
	}
	s_beam = spawnstruct();
	s_beam.ent_1 = ent_1;
	s_beam.str_tag1 = str_tag1;
	s_beam.ent_2 = ent_2;
	s_beam.str_tag2 = str_tag2;
	s_beam.str_beam_type = str_beam_type;
	if(!isdefined(self.active_beams))
	{
		self.active_beams = [];
	}
	else if(!isarray(self.active_beams))
	{
		self.active_beams = array(self.active_beams);
	}
	self.active_beams[self.active_beams.size] = s_beam;
	return s_beam;
}

/*
	Name: _get_beam
	Namespace: beam
	Checksum: 0x589DB238
	Offset: 0x5B8
	Size: 0x124
	Parameters: 5
	Flags: Linked, Private
*/
function private _get_beam(ent_1, str_tag1, ent_2, str_tag2, str_beam_type)
{
	if(isdefined(self.active_beams))
	{
		foreach(s_beam in self.active_beams)
		{
			if(s_beam.ent_1 == ent_1 && s_beam.str_tag1 == str_tag1 && s_beam.ent_2 == ent_2 && s_beam.str_tag2 == str_tag2 && s_beam.str_beam_type == str_beam_type)
			{
				return s_beam;
			}
		}
	}
}

/*
	Name: _kill_on_ent_death
	Namespace: beam
	Checksum: 0xAF2AF332
	Offset: 0x6E8
	Size: 0xBC
	Parameters: 3
	Flags: Linked, Private
*/
function private _kill_on_ent_death(s_beam, ent_1, ent_2)
{
	s_beam endon(#"kill");
	self endon(#"death");
	util::waittill_any_ents(ent_1, "entityshutdown", ent_2, "entityshutdown", s_beam, "kill", self, "death");
	if(isdefined(self))
	{
		arrayremovevalue(self.active_beams, s_beam, 0);
		beamkill(self.localclientnum, s_beam.beam_id);
	}
}

