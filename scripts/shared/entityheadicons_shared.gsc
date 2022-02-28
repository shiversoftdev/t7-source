// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace entityheadicons;

/*
	Name: init_shared
	Namespace: entityheadicons
	Checksum: 0xFC589875
	Offset: 0x160
	Size: 0x24
	Parameters: 0
	Flags: None
*/
function init_shared()
{
	callback::on_start_gametype(&start_gametype);
}

/*
	Name: start_gametype
	Namespace: entityheadicons
	Checksum: 0xD3748ABF
	Offset: 0x190
	Size: 0xB8
	Parameters: 0
	Flags: Linked
*/
function start_gametype()
{
	if(isdefined(level.initedentityheadicons))
	{
		return;
	}
	level.initedentityheadicons = 1;
	/#
		assert(isdefined(game[""]), "");
	#/
	/#
		assert(isdefined(game[""]), "");
	#/
	if(!level.teambased)
	{
		return;
	}
	if(!isdefined(level.setentityheadicon))
	{
		level.setentityheadicon = &setentityheadicon;
	}
	level.entitieswithheadicons = [];
}

/*
	Name: setentityheadicon
	Namespace: entityheadicons
	Checksum: 0x349B1BC6
	Offset: 0x250
	Size: 0x384
	Parameters: 5
	Flags: Linked
*/
function setentityheadicon(team, owner, offset, objective, constant_size)
{
	if(!level.teambased && !isdefined(owner))
	{
		return;
	}
	if(!isdefined(constant_size))
	{
		constant_size = 0;
	}
	if(!isdefined(self.entityheadiconteam))
	{
		self.entityheadiconteam = "none";
		self.entityheadicons = [];
		self.entityheadobjectives = [];
	}
	if(level.teambased && !isdefined(owner))
	{
		if(team == self.entityheadiconteam)
		{
			return;
		}
		self.entityheadiconteam = team;
	}
	if(isdefined(offset))
	{
		self.entityheadiconoffset = offset;
	}
	else
	{
		self.entityheadiconoffset = (0, 0, 0);
	}
	if(isdefined(self.entityheadicons))
	{
		for(i = 0; i < self.entityheadicons.size; i++)
		{
			if(isdefined(self.entityheadicons[i]))
			{
				self.entityheadicons[i] destroy();
			}
		}
	}
	if(isdefined(self.entityheadobjectives))
	{
		for(i = 0; i < self.entityheadobjectives.size; i++)
		{
			if(isdefined(self.entityheadobjectives[i]))
			{
				objective_delete(self.entityheadobjectives[i]);
				self.entityheadobjectives[i] = undefined;
			}
		}
	}
	self.entityheadicons = [];
	self.entityheadobjectives = [];
	self notify(#"kill_entity_headicon_thread");
	if(!isdefined(objective))
	{
		objective = game["entity_headicon_" + team];
	}
	if(isdefined(objective))
	{
		if(isdefined(owner) && !level.teambased)
		{
			if(!isplayer(owner))
			{
				/#
					assert(isdefined(owner.owner), "");
				#/
				owner = owner.owner;
			}
			if(isstring(objective))
			{
				owner updateentityheadclienticon(self, objective, constant_size);
			}
			else
			{
				owner updateentityheadclientobjective(self, objective, constant_size);
			}
		}
		else if(isdefined(owner) && team != "none")
		{
			if(isstring(objective))
			{
				owner updateentityheadteamicon(self, team, objective, constant_size);
			}
			else
			{
				owner updateentityheadteamobjective(self, team, objective, constant_size);
			}
		}
	}
	self thread destroyheadiconsondeath();
}

/*
	Name: updateentityheadteamicon
	Namespace: entityheadicons
	Checksum: 0xC517F71F
	Offset: 0x5E0
	Size: 0x1AA
	Parameters: 4
	Flags: Linked
*/
function updateentityheadteamicon(entity, team, icon, constant_size)
{
	friendly_blue_color = array(0.584, 0.839, 0.867);
	headicon = newteamhudelem(team);
	headicon.archived = 1;
	headicon.x = entity.entityheadiconoffset[0];
	headicon.y = entity.entityheadiconoffset[1];
	headicon.z = entity.entityheadiconoffset[2];
	headicon.alpha = 0.8;
	headicon.color = (friendly_blue_color[0], friendly_blue_color[1], friendly_blue_color[2]);
	headicon setshader(icon, 6, 6);
	headicon setwaypoint(constant_size);
	headicon settargetent(entity);
	entity.entityheadicons[entity.entityheadicons.size] = headicon;
}

/*
	Name: updateentityheadclienticon
	Namespace: entityheadicons
	Checksum: 0x971BF79F
	Offset: 0x798
	Size: 0x14A
	Parameters: 3
	Flags: Linked
*/
function updateentityheadclienticon(entity, icon, constant_size)
{
	headicon = newclienthudelem(self);
	headicon.archived = 1;
	headicon.x = entity.entityheadiconoffset[0];
	headicon.y = entity.entityheadiconoffset[1];
	headicon.z = entity.entityheadiconoffset[2];
	headicon.alpha = 0.8;
	headicon setshader(icon, 6, 6);
	headicon setwaypoint(constant_size);
	headicon settargetent(entity);
	entity.entityheadicons[entity.entityheadicons.size] = headicon;
}

/*
	Name: updateentityheadteamobjective
	Namespace: entityheadicons
	Checksum: 0x1AD8570C
	Offset: 0x8F0
	Size: 0xC2
	Parameters: 4
	Flags: Linked
*/
function updateentityheadteamobjective(entity, team, objective, constant_size)
{
	headiconobjectiveid = gameobjects::get_next_obj_id();
	objective_add(headiconobjectiveid, "active", entity, objective);
	objective_team(headiconobjectiveid, team);
	objective_setcolor(headiconobjectiveid, &"FriendlyBlue");
	entity.entityheadobjectives[entity.entityheadobjectives.size] = headiconobjectiveid;
}

/*
	Name: updateentityheadclientobjective
	Namespace: entityheadicons
	Checksum: 0xAA858299
	Offset: 0x9C0
	Size: 0xD2
	Parameters: 3
	Flags: Linked
*/
function updateentityheadclientobjective(entity, objective, constant_size)
{
	headiconobjectiveid = gameobjects::get_next_obj_id();
	objective_add(headiconobjectiveid, "active", entity, objective);
	objective_setinvisibletoall(headiconobjectiveid);
	objective_setvisibletoplayer(headiconobjectiveid, self);
	objective_setcolor(headiconobjectiveid, &"FriendlyBlue");
	entity.entityheadobjectives[entity.entityheadobjectives.size] = headiconobjectiveid;
}

/*
	Name: destroyheadiconsondeath
	Namespace: entityheadicons
	Checksum: 0xE5451607
	Offset: 0xAA0
	Size: 0x11E
	Parameters: 0
	Flags: Linked
*/
function destroyheadiconsondeath()
{
	self notify(#"destroyheadiconsondeath_singleton");
	self endon(#"destroyheadiconsondeath_singleton");
	self util::waittill_any("death", "hacked");
	for(i = 0; i < self.entityheadicons.size; i++)
	{
		if(isdefined(self.entityheadicons[i]))
		{
			self.entityheadicons[i] destroy();
		}
	}
	for(i = 0; i < self.entityheadobjectives.size; i++)
	{
		if(isdefined(self.entityheadobjectives[i]))
		{
			gameobjects::release_obj_id(self.entityheadobjectives[i]);
			objective_delete(self.entityheadobjectives[i]);
		}
	}
}

/*
	Name: destroyentityheadicons
	Namespace: entityheadicons
	Checksum: 0x65AFF947
	Offset: 0xBC8
	Size: 0x100
	Parameters: 0
	Flags: None
*/
function destroyentityheadicons()
{
	if(isdefined(self.entityheadicons))
	{
		for(i = 0; i < self.entityheadicons.size; i++)
		{
			if(isdefined(self.entityheadicons[i]))
			{
				self.entityheadicons[i] destroy();
			}
		}
	}
	if(isdefined(self.entityheadobjectives))
	{
		for(i = 0; i < self.entityheadobjectives.size; i++)
		{
			if(isdefined(self.entityheadobjectives[i]))
			{
				gameobjects::release_obj_id(self.entityheadobjectives[i]);
				objective_delete(self.entityheadobjectives[i]);
			}
		}
	}
	self.entityheadobjectives = [];
}

/*
	Name: updateentityheadiconpos
	Namespace: entityheadicons
	Checksum: 0xE42C2E4F
	Offset: 0xCD0
	Size: 0x84
	Parameters: 1
	Flags: None
*/
function updateentityheadiconpos(headicon)
{
	headicon.x = self.origin[0] + self.entityheadiconoffset[0];
	headicon.y = self.origin[1] + self.entityheadiconoffset[1];
	headicon.z = self.origin[2] + self.entityheadiconoffset[2];
}

/*
	Name: setentityheadiconshiddenwhilecontrolling
	Namespace: entityheadicons
	Checksum: 0xD7BAE5E0
	Offset: 0xD60
	Size: 0x92
	Parameters: 0
	Flags: None
*/
function setentityheadiconshiddenwhilecontrolling()
{
	if(isdefined(self.entityheadicons))
	{
		foreach(icon in self.entityheadicons)
		{
			icon.hidewhileremotecontrolling = 1;
		}
	}
}

