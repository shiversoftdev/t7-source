// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\init;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace ai_puppeteer;

/*
	Name: __init__sytem__
	Namespace: ai_puppeteer
	Checksum: 0x2FEB7CC4
	Offset: 0x178
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("ai_puppeteer", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: ai_puppeteer
	Checksum: 0xF2700EB1
	Offset: 0x1B8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	/#
		level thread ai_puppeteer_think();
	#/
}

/*
	Name: ai_puppeteer_think
	Namespace: ai_puppeteer
	Checksum: 0x7D4EFA32
	Offset: 0x1E0
	Size: 0x128
	Parameters: 0
	Flags: Linked
*/
function ai_puppeteer_think()
{
	/#
		while(true)
		{
			if(getdvarstring("") == "" && (!isdefined(level.ai_puppeteer_active) || level.ai_puppeteer_active == 0))
			{
				level.ai_puppeteer_active = 1;
				level notify(#"hash_23dbb5b");
				adddebugcommand("");
				thread ai_puppeteer();
			}
			else if(getdvarstring("") == "" && isdefined(level.ai_puppeteer_active) && level.ai_puppeteer_active == 1)
			{
				level.ai_puppeteer_active = 0;
				adddebugcommand("");
				level notify(#"hash_23dbb5b");
			}
			wait(0.05);
		}
	#/
}

/*
	Name: ai_puppeteer
	Namespace: ai_puppeteer
	Checksum: 0x7D23B61A
	Offset: 0x310
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function ai_puppeteer()
{
	/#
		player = undefined;
		while(!isplayer(player))
		{
			player = getplayers()[0];
			wait(0.05);
		}
		ai_puppeteer_create_hud();
		level.ai_puppet_highlighting = 0;
		player thread ai_puppet_cursor_tracker();
		player thread ai_puppet_manager();
		player.ignoreme = 1;
		level waittill(#"hash_23dbb5b");
		player.ignoreme = 0;
		ai_puppet_release(1);
		if(isdefined(level.ai_puppet_target))
		{
			level.ai_puppet_target delete();
		}
		ai_puppeteer_destroy_hud();
	#/
}

/*
	Name: ai_puppet_manager
	Namespace: ai_puppeteer
	Checksum: 0x83018ECE
	Offset: 0x440
	Size: 0xBD0
	Parameters: 0
	Flags: Linked
*/
function ai_puppet_manager()
{
	/#
		level endon(#"hash_23dbb5b");
		self endon(#"death");
		while(true)
		{
			if(isdefined(level.playercursor[""]) && isdefined(level.ai_puppet) && isdefined(level.ai_puppet.debuglookatenabled) && level.ai_puppet.debuglookatenabled == 1)
			{
				level.ai_puppet lookatpos(level.playercursor[""]);
			}
			if(self buttonpressed("") && self buttonpressed(""))
			{
				if(isdefined(level.ai_puppet))
				{
					level.ai_puppet forceteleport(level.playercursor[""], level.ai_puppet.angles);
				}
				wait(0.2);
			}
			else
			{
				if(self buttonpressed(""))
				{
					if(isdefined(level.ai_puppet))
					{
						if(isdefined(level.ai_puppet_target))
						{
							if(isai(level.ai_puppet_target))
							{
								self thread ai_puppeteer_highlight_ai(level.ai_puppet_target, (1, 0, 0));
								level.ai_puppet clearentitytarget();
								level.ai_puppet_target = undefined;
							}
							else
							{
								self thread ai_puppeteer_highlight_point(level.ai_puppet_target.origin, level.ai_puppet_target_normal, anglestoforward(self getplayerangles()), (1, 0, 0));
								level.ai_puppet clearentitytarget();
								level.ai_puppet_target delete();
							}
						}
						else
						{
							if(isdefined(level.playercursorai))
							{
								if(level.playercursorai != level.ai_puppet)
								{
									level.ai_puppet setentitytarget(level.playercursorai);
									level.ai_puppet_target = level.playercursorai;
									level.ai_puppet getperfectinfo(level.ai_puppet_target);
									self thread ai_puppeteer_highlight_ai(level.playercursorai, (1, 0, 0));
								}
							}
							else
							{
								level.ai_puppet_target = spawn("", level.playercursor[""]);
								level.ai_puppet_target_normal = level.playercursor[""];
								level.ai_puppet setentitytarget(level.ai_puppet_target);
								self thread ai_puppeteer_highlight_point(level.ai_puppet_target.origin, level.ai_puppet_target_normal, anglestoforward(self getplayerangles()), (1, 0, 0));
							}
						}
					}
					wait(0.2);
				}
				else
				{
					if(self buttonpressed(""))
					{
						if(isdefined(level.ai_puppet))
						{
							if(isdefined(level.playercursorai) && level.playercursorai != level.ai_puppet)
							{
								level.ai_puppet setgoal(level.playercursorai);
								level.ai_puppet.goalradius = 64;
								self thread ai_puppeteer_highlight_ai(level.playercursorai, (0, 1, 0));
							}
							else
							{
								if(isdefined(level.playercursornode))
								{
									level.ai_puppet setgoal(level.playercursornode);
									self thread ai_puppeteer_highlight_node(level.playercursornode);
								}
								else
								{
									if(isdefined(level.ai_puppet.scriptenemy))
									{
										to_target = level.ai_puppet.scriptenemy.origin - level.ai_puppet.origin;
									}
									else
									{
										to_target = level.playercursor[""] - level.ai_puppet.origin;
									}
									angles = vectortoangles(to_target);
									level.ai_puppet setgoal(level.playercursor[""]);
									self thread ai_puppeteer_highlight_point(level.playercursor[""], level.playercursor[""], anglestoforward(self getplayerangles()), (0, 1, 0));
								}
							}
						}
						wait(0.2);
					}
					else
					{
						if(self buttonpressed("") && self buttonpressed(""))
						{
							if(isdefined(level.ai_puppet))
							{
								if(isdefined(level.playercursorai) && level.playercursorai != level.ai_puppet)
								{
									level.ai_puppet setgoal(level.playercursorai);
									level.ai_puppet.goalradius = 64;
									self thread ai_puppeteer_highlight_ai(level.playercursorai, (0, 1, 0));
								}
								else
								{
									if(isdefined(level.playercursornode))
									{
										level.ai_puppet setgoal(level.playercursornode, 1);
										self thread ai_puppeteer_highlight_node(level.playercursornode);
									}
									else
									{
										if(isdefined(level.ai_puppet.scriptenemy))
										{
											to_target = level.ai_puppet.scriptenemy.origin - level.ai_puppet.origin;
										}
										else
										{
											to_target = level.playercursor[""] - level.ai_puppet.origin;
										}
										angles = vectortoangles(to_target);
										level.ai_puppet setgoal(level.playercursor[""], 1);
										self thread ai_puppeteer_highlight_point(level.playercursor[""], level.playercursor[""], anglestoforward(self getplayerangles()), (0, 1, 0));
									}
								}
							}
							wait(0.2);
						}
						else
						{
							if(self buttonpressed(""))
							{
								if(isdefined(level.playercursorai))
								{
									if(isdefined(level.ai_puppet) && level.playercursorai == level.ai_puppet)
									{
										ai_puppet_release(1);
									}
									else
									{
										if(isdefined(level.ai_puppet))
										{
											ai_puppet_release(0);
										}
										ai_puppet_set();
										self thread ai_puppeteer_highlight_ai(level.ai_puppet, (0, 1, 1));
									}
								}
								wait(0.2);
							}
							else if(self buttonpressed(""))
							{
								if(isdefined(level.ai_puppet))
								{
									level.ai_puppet clearforcedgoal();
								}
								wait(0.2);
							}
						}
					}
				}
			}
			if(isdefined(level.ai_puppet))
			{
				ai_puppeteer_render_ai(level.ai_puppet, (0, 1, 1));
				if(isdefined(level.ai_puppet.scriptenemy) && !level.ai_puppet_highlighting)
				{
					if(isai(level.ai_puppet.scriptenemy))
					{
						ai_puppeteer_render_ai(level.ai_puppet.scriptenemy, (1, 0, 0));
					}
					else if(isdefined(level.ai_puppet_target))
					{
						self thread ai_puppeteer_render_point(level.ai_puppet_target.origin, level.ai_puppet_target_normal, anglestoforward(self getplayerangles()), (1, 0, 0));
					}
				}
			}
			if(isdefined(level.ai_puppet))
			{
				if(self buttonpressed(""))
				{
					level.ai_puppet.goalradius = level.ai_puppet.goalradius + 64;
				}
				else
				{
					if(self buttonpressed(""))
					{
						radius = level.ai_puppet.goalradius - 64;
						if(radius < 16)
						{
							radius = 16;
						}
						level.ai_puppet.goalradius = radius;
					}
					else if(self buttonpressed(""))
					{
						level.ai_puppet.goalradius = 16;
					}
				}
			}
			if(isdefined(level.ai_puppet))
			{
				if(getdvarstring("") == "")
				{
					level.ai_puppet.fixednode = 1;
					ai_puppeteer_render_ai(level.ai_puppet, (1, 1, 1));
				}
				else
				{
					level.ai_puppet.fixednode = 0;
				}
			}
			wait(0.05);
		}
	#/
}

/*
	Name: ai_puppet_set
	Namespace: ai_puppeteer
	Checksum: 0xD212E734
	Offset: 0x1018
	Size: 0x7C
	Parameters: 0
	Flags: Linked
*/
function ai_puppet_set()
{
	/#
		level.ai_puppet = level.playercursorai;
		level.ai_puppet.ispuppet = 1;
		level.ai_puppet.old_goalradius = level.ai_puppet.goalradius;
		level.ai_puppet.goalradius = 16;
		level.ai_puppet stopanimscripted();
	#/
}

/*
	Name: ai_puppet_release
	Namespace: ai_puppeteer
	Checksum: 0xABA40A3B
	Offset: 0x10A0
	Size: 0x7E
	Parameters: 1
	Flags: Linked
*/
function ai_puppet_release(restore)
{
	/#
		if(isdefined(level.ai_puppet))
		{
			if(restore)
			{
				level.ai_puppet.goalradius = level.ai_puppet.old_goalradius;
				level.ai_puppet.ispuppet = 0;
				level.ai_puppet clearentitytarget();
			}
			level.ai_puppet = undefined;
		}
	#/
}

/*
	Name: ai_puppet_cursor_tracker
	Namespace: ai_puppeteer
	Checksum: 0xD09280A4
	Offset: 0x1128
	Size: 0x2D0
	Parameters: 0
	Flags: Linked
*/
function ai_puppet_cursor_tracker()
{
	/#
		level endon(#"hash_23dbb5b");
		self endon(#"death");
		while(true)
		{
			forward = anglestoforward(self getplayerangles());
			forward_vector = vectorscale(forward, 4000);
			level.playercursor = bullettrace(self geteye(), self geteye() + forward_vector, 1, self);
			level.playercursorai = undefined;
			level.playercursornode = undefined;
			cursorcolor = (0, 1, 1);
			hitent = level.playercursor[""];
			if(isdefined(hitent) && isai(hitent))
			{
				cursorcolor = (1, 0, 0);
				if(isdefined(level.ai_puppet) && level.ai_puppet != hitent)
				{
					if(!level.ai_puppet_highlighting)
					{
						ai_puppeteer_render_ai(hitent, cursorcolor);
					}
				}
				level.playercursorai = hitent;
			}
			else if(isdefined(level.ai_puppet))
			{
				nodes = getanynodearray(level.playercursor[""], 24);
				if(nodes.size > 0)
				{
					node = nodes[0];
					if(node.type != "" && distancesquared(node.origin, level.playercursor[""]) < 576)
					{
						if(!level.ai_puppet_highlighting)
						{
							ai_puppeteer_render_node(node, (0, 1, 1));
						}
						level.playercursornode = node;
					}
				}
			}
			if(!level.ai_puppet_highlighting)
			{
				ai_puppeteer_render_point(level.playercursor[""], level.playercursor[""], forward, cursorcolor);
			}
			wait(0.05);
		}
	#/
}

/*
	Name: ai_puppeteer_create_hud
	Namespace: ai_puppeteer
	Checksum: 0x578FD6BB
	Offset: 0x1400
	Size: 0x3AC
	Parameters: 0
	Flags: Linked
*/
function ai_puppeteer_create_hud()
{
	/#
		/#
			level.puppeteer_hud_select = newdebughudelem();
			level.puppeteer_hud_select.x = 0;
			level.puppeteer_hud_select.y = 180;
			level.puppeteer_hud_select.fontscale = 1;
			level.puppeteer_hud_select.alignx = "";
			level.puppeteer_hud_select.horzalign = "";
			level.puppeteer_hud_select.color = (0, 0, 1);
			level.puppeteer_hud_goto = newdebughudelem();
			level.puppeteer_hud_goto.x = 0;
			level.puppeteer_hud_goto.y = 200;
			level.puppeteer_hud_goto.fontscale = 1;
			level.puppeteer_hud_goto.alignx = "";
			level.puppeteer_hud_goto.horzalign = "";
			level.puppeteer_hud_goto.color = (0, 1, 0);
			level.puppeteer_hud_lookat = newdebughudelem();
			level.puppeteer_hud_lookat.x = 0;
			level.puppeteer_hud_lookat.y = 220;
			level.puppeteer_hud_lookat.fontscale = 1;
			level.puppeteer_hud_lookat.alignx = "";
			level.puppeteer_hud_lookat.horzalign = "";
			level.puppeteer_hud_lookat.color = (0, 1, 1);
			level.puppeteer_hud_shoot = newdebughudelem();
			level.puppeteer_hud_shoot.x = 0;
			level.puppeteer_hud_shoot.y = 240;
			level.puppeteer_hud_shoot.fontscale = 1;
			level.puppeteer_hud_shoot.alignx = "";
			level.puppeteer_hud_shoot.horzalign = "";
			level.puppeteer_hud_shoot.color = (1, 1, 1);
			level.puppeteer_hud_teleport = newdebughudelem();
			level.puppeteer_hud_teleport.x = 0;
			level.puppeteer_hud_teleport.y = 260;
			level.puppeteer_hud_teleport.fontscale = 1;
			level.puppeteer_hud_teleport.alignx = "";
			level.puppeteer_hud_teleport.horzalign = "";
			level.puppeteer_hud_teleport.color = (1, 0, 0);
			level.puppeteer_hud_select settext("");
			level.puppeteer_hud_goto settext("");
			level.puppeteer_hud_lookat settext("");
			level.puppeteer_hud_shoot settext("");
			level.puppeteer_hud_teleport settext("");
		#/
	#/
}

/*
	Name: ai_puppeteer_destroy_hud
	Namespace: ai_puppeteer
	Checksum: 0x400AB25A
	Offset: 0x17B8
	Size: 0xA4
	Parameters: 0
	Flags: Linked
*/
function ai_puppeteer_destroy_hud()
{
	/#
		if(isdefined(level.puppeteer_hud_select))
		{
			level.puppeteer_hud_select destroy();
		}
		if(isdefined(level.puppeteer_hud_lookat))
		{
			level.puppeteer_hud_lookat destroy();
		}
		if(isdefined(level.puppeteer_hud_goto))
		{
			level.puppeteer_hud_goto destroy();
		}
		if(isdefined(level.puppeteer_hud_shoot))
		{
			level.puppeteer_hud_shoot destroy();
		}
	#/
}

/*
	Name: ai_puppeteer_render_point
	Namespace: ai_puppeteer
	Checksum: 0x3CAE6BCB
	Offset: 0x1868
	Size: 0x164
	Parameters: 4
	Flags: Linked
*/
function ai_puppeteer_render_point(point, normal, forward, color)
{
	/#
		surface_vector = vectorcross(forward, normal);
		surface_vector = vectornormalize(surface_vector);
		line(point, point + vectorscale(surface_vector, 5), color, 1, 1);
		line(point, point + (vectorscale(surface_vector, -5)), color, 1, 1);
		surface_vector = vectorcross(normal, surface_vector);
		surface_vector = vectornormalize(surface_vector);
		line(point, point + vectorscale(surface_vector, 5), color, 1, 1);
		line(point, point + (vectorscale(surface_vector, -5)), color, 1, 1);
	#/
}

/*
	Name: ai_puppeteer_render_node
	Namespace: ai_puppeteer
	Checksum: 0x69B4D232
	Offset: 0x19D8
	Size: 0x124
	Parameters: 2
	Flags: Linked
*/
function ai_puppeteer_render_node(node, color)
{
	/#
		print3d(node.origin, node.type, color, 1, 0.35);
		box(node.origin, vectorscale((-1, -1, 0), 16), vectorscale((1, 1, 1), 16), node.angles[1], color, 1, 1);
		nodeforward = anglestoforward(node.angles);
		nodeforward = vectorscale(nodeforward, 8);
		line(node.origin, node.origin + nodeforward, color, 1, 1);
	#/
}

/*
	Name: ai_puppeteer_render_ai
	Namespace: ai_puppeteer
	Checksum: 0xEEF902B
	Offset: 0x1B08
	Size: 0xCC
	Parameters: 2
	Flags: Linked
*/
function ai_puppeteer_render_ai(ai, color)
{
	/#
		circle(ai.goalpos + (0, 0, 1), ai.goalradius, color, 0, 1);
		circle(ai.origin + (0, 0, 1), ai getpathfindingradius(), (1, 0, 0), 0, 1);
		line(ai.goalpos, ai.origin, color, 1, 1);
	#/
}

/*
	Name: ai_puppeteer_highlight_point
	Namespace: ai_puppeteer
	Checksum: 0x357DBADB
	Offset: 0x1BE0
	Size: 0xC8
	Parameters: 4
	Flags: Linked
*/
function ai_puppeteer_highlight_point(point, normal, forward, color)
{
	/#
		level endon(#"hash_23dbb5b");
		self endon(#"death");
		level.ai_puppet_highlighting = 1;
		timer = 0;
		while(timer < 0.7)
		{
			ai_puppeteer_render_point(point, normal, forward, color);
			timer = timer + 0.15;
			wait(0.15);
		}
		level.ai_puppet_highlighting = 0;
	#/
}

/*
	Name: ai_puppeteer_highlight_node
	Namespace: ai_puppeteer
	Checksum: 0xEFF01CBB
	Offset: 0x1CB0
	Size: 0xA8
	Parameters: 1
	Flags: Linked
*/
function ai_puppeteer_highlight_node(node)
{
	/#
		level endon(#"hash_23dbb5b");
		self endon(#"death");
		level.ai_puppet_highlighting = 1;
		timer = 0;
		while(timer < 0.7)
		{
			ai_puppeteer_render_node(node, (0, 1, 0));
			timer = timer + 0.15;
			wait(0.15);
		}
		level.ai_puppet_highlighting = 0;
	#/
}

/*
	Name: ai_puppeteer_highlight_ai
	Namespace: ai_puppeteer
	Checksum: 0x6A5D474
	Offset: 0x1D60
	Size: 0xC0
	Parameters: 2
	Flags: Linked
*/
function ai_puppeteer_highlight_ai(ai, color)
{
	/#
		level endon(#"hash_23dbb5b");
		self endon(#"death");
		level.ai_puppet_highlighting = 1;
		timer = 0;
		while(timer < 0.7 && isdefined(ai))
		{
			ai_puppeteer_render_ai(ai, color);
			timer = timer + 0.15;
			wait(0.15);
		}
		level.ai_puppet_highlighting = 0;
	#/
}

