// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace namespace_68dfcbbe;

/*
	Name: enemy_highlight_display
	Namespace: namespace_68dfcbbe
	Checksum: 0xAF4B7203
	Offset: 0x160
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function enemy_highlight_display(localclientnum, materialname, size, fovpercent, tracetimecheck, actorsonly, allymaterialname)
{
	self notify(#"enemy_highlight_display");
	self.enemy_highlight_display = 1;
	self thread enemy_highlight_display_pulse(localclientnum, actorsonly, allymaterialname);
	self thread enemy_highlight_display_frame(localclientnum, materialname, size, fovpercent, tracetimecheck, allymaterialname);
}

/*
	Name: enemy_highlight_display_pulse
	Namespace: namespace_68dfcbbe
	Checksum: 0x4DB856FE
	Offset: 0x218
	Size: 0x304
	Parameters: 3
	Flags: Linked
*/
function enemy_highlight_display_pulse(localclientnum, actorsonly, allymaterialname)
{
	self endon(#"enemy_highlight_display");
	if(!isdefined(actorsonly))
	{
		actorsonly = 0;
	}
	if(!isdefined(self.enemy_highlight_elems))
	{
		self.enemy_highlight_elems = [];
	}
	while(isdefined(self))
	{
		if(!isdefined(getluimenu(localclientnum, "HudElementImage")))
		{
			self.enemy_highlight_elems = [];
		}
		a_all_entities = getentarray(localclientnum);
		self.enemy_highlight_ents = [];
		foreach(entity in a_all_entities)
		{
			if(entity.type == "zbarrier")
			{
				continue;
			}
			if(actorsonly && entity.type != "actor" && entity.type != "player")
			{
				continue;
			}
			entnum = entity getentitynumber();
			isenemy = isdefined(entity.team) && entity.team == "axis";
			isally = !isenemy && isdefined(allymaterialname);
			showit = isalive(entity) && (isenemy || isally) && (!(isdefined(entity.no_highlight) && entity.no_highlight));
			if(showit && !isdefined(self.enemy_highlight_ents[entnum]))
			{
				self.enemy_highlight_ents[entnum] = entity;
				continue;
			}
			if(!showit && isdefined(self.enemy_highlight_ents[entnum]))
			{
				self.enemy_highlight_ents[entnum] = undefined;
				if(isdefined(self.enemy_highlight_elems[entnum]))
				{
					closeluimenu(localclientnum, self.enemy_highlight_elems[entnum]);
					self.enemy_highlight_elems[entnum] = undefined;
				}
			}
		}
		wait(1);
	}
}

/*
	Name: enemy_highlight_display_frame
	Namespace: namespace_68dfcbbe
	Checksum: 0xBD893A80
	Offset: 0x528
	Size: 0x964
	Parameters: 6
	Flags: Linked
*/
function enemy_highlight_display_frame(localclientnum, materialname, size, fovpercent, tracetimecheck, allymaterialname)
{
	self endon(#"enemy_highlight_display");
	if(!isdefined(self.enemy_highlight_elems))
	{
		self.enemy_highlight_elems = [];
	}
	if(!isdefined(tracetimecheck))
	{
		tracetimecheck = 1;
	}
	tracetimecheckhalfms = int(tracetimecheck * 500);
	while(isdefined(self))
	{
		if(!isdefined(getluimenu(localclientnum, "HudElementImage")))
		{
			self.enemy_highlight_elems = [];
		}
		eye = getlocalclienteyepos(localclientnum);
		angles = getlocalclientangles(localclientnum);
		if(isdefined(self.vehicle_camera_pos))
		{
			eye = self.vehicle_camera_pos;
			angles = self.vehicle_camera_ang;
		}
		dotlimit = cos(getlocalclientfov(localclientnum) * fovpercent);
		viewdir = anglestoforward(angles);
		visibleents = [];
		foreach(entnum, entity in self.enemy_highlight_ents)
		{
			if(!isdefined(entity) || !isdefined(entity.origin))
			{
				continue;
			}
			entpos = undefined;
			radialcoef = 0;
			isenemy = isdefined(entity.team) && entity.team == "axis";
			isally = !isenemy && isdefined(allymaterialname);
			showit = isalive(entity) && (isenemy || isally) && (!(isdefined(entity.no_highlight) && entity.no_highlight)) && entity != self;
			if(showit && self.enemy_highlight_elems.size >= 32 && !isdefined(self.enemy_highlight_elems[entnum]))
			{
				showit = 0;
			}
			if(showit)
			{
				if(entity.type == "actor" || entity.type == "player")
				{
					entpos = entity gettagorigin("J_Spine4");
				}
				if(!isdefined(entpos))
				{
					entpos = entity.origin + vectorscale((0, 0, 1), 40);
				}
				/#
					assert(isdefined(entpos));
				#/
				/#
					assert(isdefined(eye));
				#/
				deltadir = vectornormalize(entpos - eye);
				dot = vectordot(deltadir, viewdir);
				if(dot < dotlimit)
				{
					showit = 0;
				}
				else
				{
					radialcoef = max((1 - dot) / (1 - dotlimit) - 0.5, 0);
				}
				if(showit && (!isdefined(entity.highlight_trace_next) || entity.highlight_trace_next <= getservertime(localclientnum)))
				{
					from = eye + (deltadir * 100);
					to = entpos + (deltadir * -100);
					trace_point = tracepoint(from, to);
					entity.highlight_trace_result = trace_point["fraction"] >= 1;
					entity.highlight_trace_next = (getservertime(localclientnum) + tracetimecheckhalfms) + randomintrange(0, tracetimecheckhalfms);
				}
			}
			if(showit && entity.highlight_trace_result)
			{
				screenproj = project3dto2d(localclientnum, entpos);
				if(!isdefined(self.enemy_highlight_elems[entnum]))
				{
					if(isenemy)
					{
						self.enemy_highlight_elems[entnum] = self create_target_indicator(localclientnum, entity, materialname, size);
					}
					else
					{
						self.enemy_highlight_elems[entnum] = self create_target_indicator(localclientnum, entity, allymaterialname, size);
					}
				}
				elem = self.enemy_highlight_elems[entnum];
				if(isdefined(elem))
				{
					visibleents[entnum] = elem;
					setluimenudata(localclientnum, elem, "x", screenproj[0] - (size * 0.5));
					setluimenudata(localclientnum, elem, "y", screenproj[1] - (size * 0.5));
					setluimenudata(localclientnum, elem, "alpha", 1 - radialcoef);
					if(isenemy)
					{
						setluimenudata(localclientnum, elem, "red", 1);
						setluimenudata(localclientnum, elem, "green", 0);
						continue;
					}
					setluimenudata(localclientnum, elem, "red", 0);
					setluimenudata(localclientnum, elem, "green", 1);
				}
			}
		}
		removeents = [];
		foreach(entnum, val in self.enemy_highlight_elems)
		{
			if(!isdefined(visibleents[entnum]))
			{
				removeents[entnum] = entnum;
			}
		}
		foreach(entnum, val in removeents)
		{
			closeluimenu(localclientnum, self.enemy_highlight_elems[entnum]);
			self.enemy_highlight_elems[entnum] = undefined;
		}
		wait(0.016);
	}
}

/*
	Name: enemy_highlight_display_stop
	Namespace: namespace_68dfcbbe
	Checksum: 0x5CA34DA9
	Offset: 0xE98
	Size: 0xDA
	Parameters: 1
	Flags: Linked
*/
function enemy_highlight_display_stop(localclientnum)
{
	self notify(#"enemy_highlight_display");
	self endon(#"enemy_highlight_display");
	wait(0.016);
	if(isdefined(self.enemy_highlight_elems))
	{
		foreach(hudelem in self.enemy_highlight_elems)
		{
			closeluimenu(localclientnum, hudelem);
		}
		self.enemy_highlight_elems = undefined;
	}
	self.enemy_highlight_display = undefined;
}

/*
	Name: create_target_indicator
	Namespace: namespace_68dfcbbe
	Checksum: 0x24D1136B
	Offset: 0xF80
	Size: 0x1F8
	Parameters: 4
	Flags: Linked
*/
function create_target_indicator(localclientnum, entity, materialname, size)
{
	hudelem = createluimenu(localclientnum, "HudElementImage");
	if(isdefined(hudelem))
	{
		setluimenudata(localclientnum, hudelem, "x", 0);
		setluimenudata(localclientnum, hudelem, "y", 0);
		setluimenudata(localclientnum, hudelem, "width", size);
		setluimenudata(localclientnum, hudelem, "height", size);
		setluimenudata(localclientnum, hudelem, "alpha", 1);
		setluimenudata(localclientnum, hudelem, "material", materialname);
		setluimenudata(localclientnum, hudelem, "red", 1);
		setluimenudata(localclientnum, hudelem, "green", 0);
		setluimenudata(localclientnum, hudelem, "blue", 0);
		setluimenudata(localclientnum, hudelem, "zRot", 0);
		openluimenu(localclientnum, hudelem);
	}
	return hudelem;
}

