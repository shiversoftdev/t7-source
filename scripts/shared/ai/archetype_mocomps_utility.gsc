// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;

#namespace archetype_mocomps_utility;

/*
	Name: registerdefaultanimationmocomps
	Namespace: archetype_mocomps_utility
	Checksum: 0x36894620
	Offset: 0x290
	Size: 0xAC
	Parameters: 0
	Flags: AutoExec
*/
function autoexec registerdefaultanimationmocomps()
{
	animationstatenetwork::registeranimationmocomp("adjust_to_cover", &mocompadjusttocoverinit, &mocompadjusttocoverupdate, &mocompadjusttocoverterminate);
	animationstatenetwork::registeranimationmocomp("locomotion_explosion_death", &mocomplocoexplosioninit, undefined, undefined);
	animationstatenetwork::registeranimationmocomp("mocomp_flank_stand", &mocompflankstandinit, undefined, undefined);
}

/*
	Name: initadjusttocoverparams
	Namespace: archetype_mocomps_utility
	Checksum: 0x60266A62
	Offset: 0x348
	Size: 0x694
	Parameters: 0
	Flags: AutoExec
*/
function autoexec initadjusttocoverparams()
{
	_addadjusttocover("human", "cover_any", "stance_any", 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.9, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8);
	_addadjusttocover("human", "cover_stand", "stance_any", 0.4, 0.8, 0.6, 0.4, 0.6, 0.3, 0.3, 0.6, 0.9, 0.6, 0.3, 0.4, 0.7, 0.6, 0.6, 0.6);
	_addadjusttocover("human", "cover_crouch", "stance_any", 0.4, 0.4, 0.4, 0.4, 0.8, 0.5, 0.2, 0.7, 0.9, 0.4, 0.2, 0.4, 0.5, 0.5, 0.5, 0.5);
	_addadjusttocover("human", "cover_left", "stand", 0.8, 0.4, 0.4, 0.4, 0.4, 0.7, 0.3, 0.5, 0.8, 0.8, 0.8, 0.9, 0.6, 0.6, 0.4, 0.4);
	_addadjusttocover("human", "cover_left", "crouch", 0.8, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.8, 0.8, 0.7, 0.6, 0.6, 0.4, 0.4);
	_addadjusttocover("human", "cover_right", "stand", 0.8, 0.4, 0.3, 0.4, 0.6, 0.8, 0.4, 0.4, 0.4, 0.4, 0.3, 0.4, 0.6, 0.6, 0.5, 0.4);
	_addadjusttocover("human", "cover_right", "crouch", 0.8, 0.4, 0.2, 0.4, 0.4, 0.7, 0.2, 0.3, 0.3, 0.5, 0.5, 0.7, 0.6, 0.6, 0.5, 0.4);
	_addadjusttocover("human", "cover_pillar", "stance_any", 0.8, 0.7, 0.6, 0.7, 0.6, 0.5, 0.4, 0.4, 0.4, 0.6, 0.4, 0.3, 0.7, 0.5, 0.1, 0.7);
	_addadjusttocover("robot", "cover_any", "stance_any", 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.4, 0.6, 0.7, 0.5, 0.5, 0.5, 0.5, 0.4, 0.4, 0.4);
	_addadjusttocover("robot", "cover_exposed", "stance_any", 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.9, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8);
}

/*
	Name: _addadjusttocover
	Namespace: archetype_mocomps_utility
	Checksum: 0x57FED533
	Offset: 0x9E8
	Size: 0x236
	Parameters: 19
	Flags: Linked, Private
*/
function private _addadjusttocover(archetype, node, stance, rot2, rot32, rot3, rot36, rot6, rot69, rot9, rot98, rot8, rot87, rot7, rot47, rot4, rot14, rot1, rot21)
{
	if(!isdefined(level.adjusttocover))
	{
		level.adjusttocover = [];
	}
	if(!isdefined(level.adjusttocover[archetype]))
	{
		level.adjusttocover[archetype] = [];
	}
	if(!isdefined(level.adjusttocover[archetype][node]))
	{
		level.adjusttocover[archetype][node] = [];
	}
	directions = [];
	directions[2] = rot2;
	directions[32] = rot32;
	directions[3] = rot3;
	directions[63] = rot36;
	directions[6] = rot6;
	directions[96] = rot69;
	directions[9] = rot9;
	directions[89] = rot98;
	directions[8] = rot8;
	directions[78] = rot87;
	directions[7] = rot7;
	directions[47] = rot47;
	directions[4] = rot4;
	directions[14] = rot14;
	directions[1] = rot1;
	directions[21] = rot21;
	level.adjusttocover[archetype][node][stance] = directions;
}

/*
	Name: _getadjusttocoverrotation
	Namespace: archetype_mocomps_utility
	Checksum: 0xF2DA7E91
	Offset: 0xC28
	Size: 0x3EE
	Parameters: 4
	Flags: Linked, Private
*/
function private _getadjusttocoverrotation(archetype, node, stance, angletonode)
{
	/#
		assert(isarray(level.adjusttocover[archetype]));
	#/
	if(!isdefined(level.adjusttocover[archetype][node]))
	{
		node = "cover_any";
	}
	/#
		assert(isarray(level.adjusttocover[archetype][node]));
	#/
	if(!isdefined(level.adjusttocover[archetype][node][stance]))
	{
		stance = "stance_any";
	}
	/#
		assert(isarray(level.adjusttocover[archetype][node][stance]));
	#/
	/#
		assert(angletonode >= 0 && angletonode < 360);
	#/
	direction = undefined;
	if(angletonode < 11.25)
	{
		direction = 2;
	}
	else
	{
		if(angletonode < 33.75)
		{
			direction = 32;
		}
		else
		{
			if(angletonode < 56.25)
			{
				direction = 3;
			}
			else
			{
				if(angletonode < 78.75)
				{
					direction = 63;
				}
				else
				{
					if(angletonode < 101.25)
					{
						direction = 6;
					}
					else
					{
						if(angletonode < 123.75)
						{
							direction = 96;
						}
						else
						{
							if(angletonode < 146.25)
							{
								direction = 9;
							}
							else
							{
								if(angletonode < 168.75)
								{
									direction = 89;
								}
								else
								{
									if(angletonode < 191.25)
									{
										direction = 8;
									}
									else
									{
										if(angletonode < 213.75)
										{
											direction = 78;
										}
										else
										{
											if(angletonode < 236.25)
											{
												direction = 7;
											}
											else
											{
												if(angletonode < 258.75)
												{
													direction = 47;
												}
												else
												{
													if(angletonode < 281.25)
													{
														direction = 4;
													}
													else
													{
														if(angletonode < 303.75)
														{
															direction = 14;
														}
														else
														{
															if(angletonode < 326.25)
															{
																direction = 1;
															}
															else
															{
																if(angletonode < 348.75)
																{
																	direction = 21;
																}
																else
																{
																	direction = 2;
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	/#
		assert(isdefined(level.adjusttocover[archetype][node][stance][direction]));
	#/
	adjusttime = level.adjusttocover[archetype][node][stance][direction];
	if(isdefined(adjusttime))
	{
		return adjusttime;
	}
	return 0.8;
}

/*
	Name: debuglocoexplosion
	Namespace: archetype_mocomps_utility
	Checksum: 0xD8DB1BE4
	Offset: 0x1020
	Size: 0x180
	Parameters: 1
	Flags: Linked, Private
*/
function private debuglocoexplosion(entity)
{
	entity endon(#"death");
	/#
		startorigin = entity.origin;
		startyawforward = anglestoforward((0, entity.angles[1], 0));
		damageyawforward = anglestoforward((0, entity.damageyaw - entity.angles[1], 0));
		starttime = gettime();
		while((gettime() - starttime) < 10000)
		{
			recordsphere(startorigin, 5, (1, 0, 0), "", entity);
			recordline(startorigin, startorigin + (startyawforward * 100), (0, 0, 1), "", entity);
			recordline(startorigin, startorigin + (damageyawforward * 100), (1, 0, 0), "", entity);
			wait(0.05);
		}
	#/
}

/*
	Name: mocompflankstandinit
	Namespace: archetype_mocomps_utility
	Checksum: 0x5D486610
	Offset: 0x11A8
	Size: 0xFC
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompflankstandinit(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity animmode("nogravity", 0);
	entity orientmode("face angle", entity.angles[1]);
	entity pathmode("move delayed", 0, randomfloatrange(0.5, 1));
	if(isdefined(entity.enemy))
	{
		entity getperfectinfo(entity.enemy);
		entity.newenemyreaction = 0;
	}
}

/*
	Name: mocomplocoexplosioninit
	Namespace: archetype_mocomps_utility
	Checksum: 0xDD0D7F58
	Offset: 0x12B0
	Size: 0xBC
	Parameters: 5
	Flags: Linked, Private
*/
function private mocomplocoexplosioninit(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity animmode("nogravity", 0);
	entity orientmode("face angle", entity.angles[1]);
	/#
		if(getdvarint(""))
		{
			entity thread debuglocoexplosion(entity);
		}
	#/
}

/*
	Name: mocompadjusttocoverinit
	Namespace: archetype_mocomps_utility
	Checksum: 0x87174EC9
	Offset: 0x1378
	Size: 0x2A8
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompadjusttocoverinit(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity orientmode("face angle", entity.angles[1]);
	entity animmode("angle deltas", 0);
	entity.blockingpain = 1;
	if(isdefined(entity.node))
	{
		entity.adjustnode = entity.node;
		entity.nodeoffsetorigin = entity getnodeoffsetposition(entity.node);
		entity.nodeoffsetangles = entity getnodeoffsetangles(entity.node);
		entity.nodeoffsetforward = anglestoforward(entity.nodeoffsetangles);
		entity.nodeforward = anglestoforward(entity.node.angles);
		entity.nodefinalstance = blackboard::getblackboardattribute(entity, "_desired_stance");
		covertype = blackboard::getblackboardattribute(entity, "_cover_type");
		if(!isdefined(entity.nodefinalstance))
		{
			entity.nodefinalstance = aiutility::gethighestnodestance(entity.adjustnode);
		}
		angledifference = floor(absangleclamp360(entity.angles[1] - entity.node.angles[1]));
		entity.mocompanglestarttime = _getadjusttocoverrotation(entity.archetype, covertype, entity.nodefinalstance, angledifference);
	}
}

/*
	Name: mocompadjusttocoverupdate
	Namespace: archetype_mocomps_utility
	Checksum: 0xEAACED7D
	Offset: 0x1628
	Size: 0x38C
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompadjusttocoverupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	if(!isdefined(entity.adjustnode))
	{
		return;
	}
	movevector = entity.nodeoffsetorigin - entity.origin;
	if(lengthsquared(movevector) > 1)
	{
		movevector = vectornormalize(movevector) * 1;
	}
	entity forceteleport(entity.origin + movevector, entity.angles, 0);
	normalizedtime = ((entity getanimtime(mocompanim) * getanimlength(mocompanim)) + mocompanimblendouttime) / mocompduration;
	if(normalizedtime > entity.mocompanglestarttime)
	{
		entity orientmode("face angle", entity.nodeoffsetangles);
		entity animmode("normal", 0);
	}
	/#
		if(getdvarint(""))
		{
			record3dtext(entity.mocompanglestarttime, entity.origin + vectorscale((0, 0, 1), 5), (0, 1, 0), "");
			hiptagorigin = entity gettagorigin("");
			recordline(entity.nodeoffsetorigin, entity.nodeoffsetorigin + (entity.nodeoffsetforward * 30), (1, 0.5, 0), "", entity);
			recordline(entity.adjustnode.origin, entity.adjustnode.origin + (entity.nodeforward * 20), (0, 1, 0), "", entity);
			recordline(entity.origin, entity.origin + (anglestoforward(entity.angles) * 10), (1, 0, 0), "", entity);
			recordline(hiptagorigin, (hiptagorigin[0], hiptagorigin[1], entity.origin[2]), (0, 0, 1), "", entity);
		}
	#/
}

/*
	Name: mocompadjusttocoverterminate
	Namespace: archetype_mocomps_utility
	Checksum: 0xC5349406
	Offset: 0x19C0
	Size: 0x11A
	Parameters: 5
	Flags: Linked, Private
*/
function private mocompadjusttocoverterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity.blockingpain = 0;
	entity.mocompanglestarttime = undefined;
	entity.nodeoffsetangle = undefined;
	entity.nodeoffsetforward = undefined;
	entity.nodeforward = undefined;
	entity.nodefinalstance = undefined;
	if(entity.adjustnode !== entity.node)
	{
		entity.nodeoffsetorigin = undefined;
		entity.nodeoffsetangles = undefined;
		entity.adjustnode = undefined;
		return;
	}
	entity forceteleport(entity.nodeoffsetorigin, entity.nodeoffsetangles, 0);
	entity.nodeoffsetorigin = undefined;
	entity.nodeoffsetangles = undefined;
	entity.adjustnode = undefined;
}

