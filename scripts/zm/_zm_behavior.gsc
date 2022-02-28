// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_attackables;
#using scripts\zm\_zm_behavior_utility;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

#namespace zm_behavior;

/*
	Name: init
	Namespace: zm_behavior
	Checksum: 0xB790CCAE
	Offset: 0xAF0
	Size: 0x50
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	initzmbehaviorsandasm();
	level.zigzag_activation_distance = 240;
	level.zigzag_distance_min = 240;
	level.zigzag_distance_max = 480;
	level.inner_zigzag_radius = 0;
	level.outer_zigzag_radius = 96;
}

/*
	Name: initzmbehaviorsandasm
	Namespace: zm_behavior
	Checksum: 0xCFA1274F
	Offset: 0xB48
	Size: 0xA1C
	Parameters: 0
	Flags: Linked, Private
*/
function private initzmbehaviorsandasm()
{
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieFindFleshService", &zombiefindflesh);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieEnteredPlayableService", &zombieenteredplayable);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldMove", &shouldmovecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldTear", &zombieshouldtearcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldAttackThroughBoards", &zombieshouldattackthroughboardscondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldTaunt", &zombieshouldtauntcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieGotToEntrance", &zombiegottoentrancecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieGotToAttackSpot", &zombiegottoattackspotcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieHasAttackSpotAlready", &zombiehasattackspotalreadycondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldEnterPlayable", &zombieshouldenterplayablecondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("isChunkValid", &ischunkvalidcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("inPlayableArea", &inplayablearea);
	behaviortreenetworkutility::registerbehaviortreescriptapi("shouldSkipTeardown", &shouldskipteardown);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsThinkDone", &zombieisthinkdone);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsAtGoal", &zombieisatgoal);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsAtEntrance", &zombieisatentrance);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldMoveAway", &zombieshouldmoveawaycondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("wasKilledByTesla", &waskilledbyteslacondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldStun", &zombieshouldstun);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsBeingGrappled", &zombieisbeinggrappled);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieShouldKnockdown", &zombieshouldknockdown);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieIsPushed", &zombieispushed);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieKilledWhileGettingPulled", &zombiekilledwhilegettingpulled);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieKilledByBlackHoleBombCondition", &zombiekilledbyblackholebombcondition);
	behaviortreenetworkutility::registerbehaviortreescriptapi("disablePowerups", &disablepowerups);
	behaviortreenetworkutility::registerbehaviortreescriptapi("enablePowerups", &enablepowerups);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieMoveToEntranceAction", &zombiemovetoentranceaction, undefined, &zombiemovetoentranceactionterminate);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieMoveToAttackSpotAction", &zombiemovetoattackspotaction, undefined, &zombiemovetoattackspotactionterminate);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieIdleAction", undefined, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieMoveAway", &zombiemoveaway, undefined, undefined);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieTraverseAction", &zombietraverseaction, undefined, &zombietraverseactionterminate);
	behaviortreenetworkutility::registerbehaviortreeaction("holdBoardAction", &zombieholdboardaction, undefined, &zombieholdboardactionterminate);
	behaviortreenetworkutility::registerbehaviortreeaction("grabBoardAction", &zombiegrabboardaction, undefined, &zombiegrabboardactionterminate);
	behaviortreenetworkutility::registerbehaviortreeaction("pullBoardAction", &zombiepullboardaction, undefined, &zombiepullboardactionterminate);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieAttackThroughBoardsAction", &zombieattackthroughboardsaction, undefined, &zombieattackthroughboardsactionterminate);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieTauntAction", &zombietauntaction, undefined, &zombietauntactionterminate);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieMantleAction", &zombiemantleaction, undefined, &zombiemantleactionterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieStunActionStart", &zombiestunactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieStunActionEnd", &zombiestunactionend);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieGrappleActionStart", &zombiegrappleactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieKnockdownActionStart", &zombieknockdownactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieGetupActionTerminate", &zombiegetupactionterminate);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombiePushedActionStart", &zombiepushedactionstart);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombiePushedActionTerminate", &zombiepushedactionterminate);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieBlackHoleBombPullAction", &zombieblackholebombpullstart, &zombieblackholebombpullupdate, &zombieblackholebombpullend);
	behaviortreenetworkutility::registerbehaviortreeaction("zombieBlackHoleBombDeathAction", &zombiekilledbyblackholebombstart, undefined, &zombiekilledbyblackholebombend);
	behaviortreenetworkutility::registerbehaviortreescriptapi("getChunkService", &getchunkservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("updateChunkService", &updatechunkservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("updateAttackSpotService", &updateattackspotservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("findNodesService", &findnodesservice);
	behaviortreenetworkutility::registerbehaviortreescriptapi("zombieAttackableObjectService", &zombieattackableobjectservice);
	animationstatenetwork::registeranimationmocomp("mocomp_board_tear@zombie", &boardtearmocompstart, &boardtearmocompupdate, undefined);
	animationstatenetwork::registeranimationmocomp("mocomp_barricade_enter@zombie", &barricadeentermocompstart, &barricadeentermocompupdate, &barricadeentermocompterminate);
	animationstatenetwork::registeranimationmocomp("mocomp_barricade_enter_no_z@zombie", &barricadeentermocompnozstart, &barricadeentermocompnozupdate, &barricadeentermocompnozterminate);
	animationstatenetwork::registernotetrackhandlerfunction("destroy_piece", &notetrackboardtear);
	animationstatenetwork::registernotetrackhandlerfunction("zombie_window_melee", &notetrackboardmelee);
	animationstatenetwork::registernotetrackhandlerfunction("bhb_burst", &zombiebhbburst);
	setdvar("scr_zm_use_code_enemy_selection", 1);
}

/*
	Name: zombiefindflesh
	Namespace: zm_behavior
	Checksum: 0x5A6B6CA9
	Offset: 0x1570
	Size: 0x9F6
	Parameters: 1
	Flags: Linked
*/
function zombiefindflesh(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.enablepushtime))
	{
		if(gettime() >= behaviortreeentity.enablepushtime)
		{
			behaviortreeentity pushactors(1);
			behaviortreeentity.enablepushtime = undefined;
		}
	}
	if(getdvarint("scr_zm_use_code_enemy_selection", 0))
	{
		zombiefindfleshcode(behaviortreeentity);
		return;
	}
	if(level.intermission)
	{
		return;
	}
	if(behaviortreeentity getpathmode() == "dont move")
	{
		return;
	}
	behaviortreeentity.ignoreme = 0;
	behaviortreeentity.ignore_player = [];
	behaviortreeentity.goalradius = 30;
	if(isdefined(behaviortreeentity.ignore_find_flesh) && behaviortreeentity.ignore_find_flesh)
	{
		return;
	}
	if(behaviortreeentity.team == "allies")
	{
		behaviortreeentity findzombieenemy();
		return;
	}
	if(zombieshouldmoveawaycondition(behaviortreeentity))
	{
		return;
	}
	zombie_poi = behaviortreeentity zm_utility::get_zombie_point_of_interest(behaviortreeentity.origin);
	behaviortreeentity.zombie_poi = zombie_poi;
	players = getplayers();
	if(!isdefined(behaviortreeentity.ignore_player) || players.size == 1)
	{
		behaviortreeentity.ignore_player = [];
	}
	else if(!isdefined(level._should_skip_ignore_player_logic) || ![[level._should_skip_ignore_player_logic]]())
	{
		i = 0;
		while(i < behaviortreeentity.ignore_player.size)
		{
			if(isdefined(behaviortreeentity.ignore_player[i]) && isdefined(behaviortreeentity.ignore_player[i].ignore_counter) && behaviortreeentity.ignore_player[i].ignore_counter > 3)
			{
				behaviortreeentity.ignore_player[i].ignore_counter = 0;
				behaviortreeentity.ignore_player = arrayremovevalue(behaviortreeentity.ignore_player, behaviortreeentity.ignore_player[i]);
				if(!isdefined(behaviortreeentity.ignore_player))
				{
					behaviortreeentity.ignore_player = [];
				}
				i = 0;
				continue;
			}
			i++;
		}
	}
	behaviortreeentity zombie_utility::run_ignore_player_handler();
	player = zm_utility::get_closest_valid_player(behaviortreeentity.origin, behaviortreeentity.ignore_player);
	designated_target = 0;
	if(isdefined(player) && (isdefined(player.b_is_designated_target) && player.b_is_designated_target))
	{
		designated_target = 1;
	}
	if(!isdefined(player) && !isdefined(zombie_poi) && !isdefined(behaviortreeentity.attackable))
	{
		if(isdefined(behaviortreeentity.ignore_player))
		{
			if(isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]())
			{
				return;
			}
			behaviortreeentity.ignore_player = [];
		}
		/#
			if(isdefined(behaviortreeentity.ispuppet) && behaviortreeentity.ispuppet)
			{
				return;
			}
		#/
		if(isdefined(level.no_target_override))
		{
			[[level.no_target_override]](behaviortreeentity);
		}
		else
		{
			behaviortreeentity setgoal(behaviortreeentity.origin);
		}
		return;
	}
	if(!isdefined(level.check_for_alternate_poi) || ![[level.check_for_alternate_poi]]())
	{
		behaviortreeentity.enemyoverride = zombie_poi;
		behaviortreeentity.favoriteenemy = player;
	}
	if(isdefined(behaviortreeentity.v_zombie_custom_goal_pos))
	{
		goalpos = behaviortreeentity.v_zombie_custom_goal_pos;
		if(isdefined(behaviortreeentity.n_zombie_custom_goal_radius))
		{
			behaviortreeentity.goalradius = behaviortreeentity.n_zombie_custom_goal_radius;
		}
		behaviortreeentity setgoal(goalpos);
	}
	else
	{
		if(isdefined(behaviortreeentity.enemyoverride) && isdefined(behaviortreeentity.enemyoverride[1]))
		{
			behaviortreeentity.has_exit_point = undefined;
			goalpos = behaviortreeentity.enemyoverride[0];
			if(!isdefined(zombie_poi))
			{
				aiprofile_beginentry("zombiefindflesh-enemyoverride");
				queryresult = positionquery_source_navigation(goalpos, 0, 48, 36, 4);
				aiprofile_endentry();
				foreach(point in queryresult.data)
				{
					goalpos = point.origin;
					break;
				}
			}
			behaviortreeentity setgoal(goalpos);
		}
		else
		{
			if(isdefined(behaviortreeentity.attackable) && !designated_target)
			{
				if(isdefined(behaviortreeentity.attackable_slot))
				{
					if(isdefined(behaviortreeentity.attackable_goal_radius))
					{
						behaviortreeentity.goalradius = behaviortreeentity.attackable_goal_radius;
					}
					nav_mesh = getclosestpointonnavmesh(behaviortreeentity.attackable_slot.origin, 64);
					if(isdefined(nav_mesh))
					{
						behaviortreeentity setgoal(nav_mesh);
					}
					else
					{
						behaviortreeentity setgoal(behaviortreeentity.attackable_slot.origin);
					}
				}
			}
			else if(isdefined(behaviortreeentity.favoriteenemy))
			{
				behaviortreeentity.has_exit_point = undefined;
				behaviortreeentity.ignoreall = 0;
				if(isdefined(level.enemy_location_override_func))
				{
					goalpos = [[level.enemy_location_override_func]](behaviortreeentity, behaviortreeentity.favoriteenemy);
					if(isdefined(goalpos))
					{
						behaviortreeentity setgoal(goalpos);
					}
					else
					{
						behaviortreeentity zombieupdategoal();
					}
				}
				else
				{
					if(isdefined(behaviortreeentity.is_rat_test) && behaviortreeentity.is_rat_test)
					{
					}
					else
					{
						if(zombieshouldmoveawaycondition(behaviortreeentity))
						{
						}
						else if(isdefined(behaviortreeentity.favoriteenemy.last_valid_position))
						{
							behaviortreeentity zombieupdategoal();
						}
					}
				}
			}
		}
	}
	if(players.size > 1)
	{
		else
		{
		}
		for(i = 0; i < behaviortreeentity.ignore_player.size; i++)
		{
			if(isdefined(behaviortreeentity.ignore_player[i]))
			{
				if(!isdefined(behaviortreeentity.ignore_player[i].ignore_counter))
				{
					behaviortreeentity.ignore_player[i].ignore_counter = 0;
					continue;
				}
				behaviortreeentity.ignore_player[i].ignore_counter = behaviortreeentity.ignore_player[i].ignore_counter + 1;
			}
		}
	}
}

/*
	Name: zombiefindfleshcode
	Namespace: zm_behavior
	Checksum: 0xA24FD650
	Offset: 0x1F70
	Size: 0x46C
	Parameters: 1
	Flags: Linked
*/
function zombiefindfleshcode(behaviortreeentity)
{
	aiprofile_beginentry("zombieFindFleshCode");
	if(level.intermission)
	{
		aiprofile_endentry();
		return;
	}
	behaviortreeentity.ignore_player = [];
	behaviortreeentity.goalradius = 30;
	if(behaviortreeentity.team == "allies")
	{
		behaviortreeentity findzombieenemy();
		aiprofile_endentry();
		return;
	}
	if(level.wait_and_revive)
	{
		aiprofile_endentry();
		return;
	}
	if(level.zombie_poi_array.size > 0)
	{
		zombie_poi = behaviortreeentity zm_utility::get_zombie_point_of_interest(behaviortreeentity.origin);
	}
	behaviortreeentity zombie_utility::run_ignore_player_handler();
	zm_utility::update_valid_players(behaviortreeentity.origin, behaviortreeentity.ignore_player);
	if(!isdefined(behaviortreeentity.enemy) && !isdefined(zombie_poi))
	{
		/#
			if(isdefined(behaviortreeentity.ispuppet) && behaviortreeentity.ispuppet)
			{
				aiprofile_endentry();
				return;
			}
		#/
		if(isdefined(level.no_target_override))
		{
			[[level.no_target_override]](behaviortreeentity);
		}
		else
		{
			behaviortreeentity setgoal(behaviortreeentity.origin);
		}
		aiprofile_endentry();
		return;
	}
	behaviortreeentity.enemyoverride = zombie_poi;
	if(isdefined(behaviortreeentity.enemyoverride) && isdefined(behaviortreeentity.enemyoverride[1]))
	{
		behaviortreeentity.has_exit_point = undefined;
		goalpos = behaviortreeentity.enemyoverride[0];
		queryresult = positionquery_source_navigation(goalpos, 0, 48, 36, 4);
		foreach(point in queryresult.data)
		{
			goalpos = point.origin;
			break;
		}
		behaviortreeentity setgoal(goalpos);
	}
	else if(isdefined(behaviortreeentity.enemy))
	{
		behaviortreeentity.has_exit_point = undefined;
		/#
			if(isdefined(behaviortreeentity.is_rat_test) && behaviortreeentity.is_rat_test)
			{
				aiprofile_endentry();
				return;
			}
		#/
		if(isdefined(level.enemy_location_override_func))
		{
			goalpos = [[level.enemy_location_override_func]](behaviortreeentity, behaviortreeentity.enemy);
			if(isdefined(goalpos))
			{
				behaviortreeentity setgoal(goalpos);
			}
			else
			{
				behaviortreeentity zombieupdategoalcode();
			}
		}
		else if(isdefined(behaviortreeentity.enemy.last_valid_position))
		{
			behaviortreeentity zombieupdategoalcode();
		}
	}
	aiprofile_endentry();
}

/*
	Name: zombieupdategoal
	Namespace: zm_behavior
	Checksum: 0x601E002A
	Offset: 0x23E8
	Size: 0x604
	Parameters: 0
	Flags: Linked
*/
function zombieupdategoal()
{
	aiprofile_beginentry("zombieUpdateGoal");
	shouldrepath = 0;
	if(!shouldrepath && isdefined(self.favoriteenemy))
	{
		if(!isdefined(self.nextgoalupdate) || self.nextgoalupdate <= gettime())
		{
			shouldrepath = 1;
		}
		else
		{
			if(distancesquared(self.origin, self.favoriteenemy.origin) <= (level.zigzag_activation_distance * level.zigzag_activation_distance))
			{
				shouldrepath = 1;
			}
			else if(isdefined(self.pathgoalpos))
			{
				distancetogoalsqr = distancesquared(self.origin, self.pathgoalpos);
				shouldrepath = distancetogoalsqr < (72 * 72);
			}
		}
	}
	if(isdefined(level.validate_on_navmesh) && level.validate_on_navmesh)
	{
		if(!ispointonnavmesh(self.origin, self))
		{
			shouldrepath = 0;
		}
	}
	if(isdefined(self.keep_moving) && self.keep_moving)
	{
		if(gettime() > self.keep_moving_time)
		{
			self.keep_moving = 0;
		}
	}
	if(shouldrepath)
	{
		goalpos = self.favoriteenemy.origin;
		if(isdefined(self.favoriteenemy.last_valid_position))
		{
			goalpos = self.favoriteenemy.last_valid_position;
		}
		self setgoal(goalpos);
		should_zigzag = 1;
		if(isdefined(level.should_zigzag))
		{
			should_zigzag = self [[level.should_zigzag]]();
		}
		if(isdefined(level.do_randomized_zigzag_path) && level.do_randomized_zigzag_path && should_zigzag)
		{
			if(distancesquared(self.origin, goalpos) > (level.zigzag_activation_distance * level.zigzag_activation_distance))
			{
				self.keep_moving = 1;
				self.keep_moving_time = gettime() + 250;
				path = self calcapproximatepathtoposition(goalpos, 0);
				/#
					if(getdvarint(""))
					{
						for(index = 1; index < path.size; index++)
						{
							recordline(path[index - 1], path[index], (1, 0.5, 0), "", self);
						}
					}
				#/
				deviationdistance = randomintrange(level.zigzag_distance_min, level.zigzag_distance_max);
				if(isdefined(self.zigzag_distance_min) && isdefined(self.zigzag_distance_max))
				{
					deviationdistance = randomintrange(self.zigzag_distance_min, self.zigzag_distance_max);
				}
				segmentlength = 0;
				for(index = 1; index < path.size; index++)
				{
					currentseglength = distance(path[index - 1], path[index]);
					if((segmentlength + currentseglength) > deviationdistance)
					{
						remaininglength = deviationdistance - segmentlength;
						seedposition = (path[index - 1]) + ((vectornormalize(path[index] - (path[index - 1]))) * remaininglength);
						/#
							recordcircle(seedposition, 2, (1, 0.5, 0), "", self);
						#/
						innerzigzagradius = level.inner_zigzag_radius;
						outerzigzagradius = level.outer_zigzag_radius;
						queryresult = positionquery_source_navigation(seedposition, innerzigzagradius, outerzigzagradius, 36, 16, self, 16);
						positionquery_filter_inclaimedlocation(queryresult, self);
						if(queryresult.data.size > 0)
						{
							point = queryresult.data[randomint(queryresult.data.size)];
							self setgoal(point.origin);
						}
						break;
					}
					segmentlength = segmentlength + currentseglength;
				}
			}
		}
		self.nextgoalupdate = gettime() + randomintrange(500, 1000);
	}
	aiprofile_endentry();
}

/*
	Name: zombieupdategoalcode
	Namespace: zm_behavior
	Checksum: 0x3F20B860
	Offset: 0x29F8
	Size: 0x54C
	Parameters: 0
	Flags: Linked
*/
function zombieupdategoalcode()
{
	aiprofile_beginentry("zombieUpdateGoalCode");
	shouldrepath = 0;
	if(!shouldrepath && isdefined(self.enemy))
	{
		if(!isdefined(self.nextgoalupdate) || self.nextgoalupdate <= gettime())
		{
			shouldrepath = 1;
		}
		else
		{
			if(distancesquared(self.origin, self.enemy.origin) <= (200 * 200))
			{
				shouldrepath = 1;
			}
			else if(isdefined(self.pathgoalpos))
			{
				distancetogoalsqr = distancesquared(self.origin, self.pathgoalpos);
				shouldrepath = distancetogoalsqr < (72 * 72);
			}
		}
	}
	if(isdefined(self.keep_moving) && self.keep_moving)
	{
		if(gettime() > self.keep_moving_time)
		{
			self.keep_moving = 0;
		}
	}
	if(shouldrepath)
	{
		goalpos = self.enemy.origin;
		if(isdefined(self.enemy.last_valid_position))
		{
			goalpos = self.enemy.last_valid_position;
		}
		if(isdefined(level.do_randomized_zigzag_path) && level.do_randomized_zigzag_path)
		{
			if(distancesquared(self.origin, goalpos) > (240 * 240))
			{
				self.keep_moving = 1;
				self.keep_moving_time = gettime() + 250;
				path = self calcapproximatepathtoposition(goalpos, 0);
				/#
					if(getdvarint(""))
					{
						for(index = 1; index < path.size; index++)
						{
							recordline(path[index - 1], path[index], (1, 0.5, 0), "", self);
						}
					}
				#/
				deviationdistance = randomintrange(240, 480);
				segmentlength = 0;
				for(index = 1; index < path.size; index++)
				{
					currentseglength = distance(path[index - 1], path[index]);
					if((segmentlength + currentseglength) > deviationdistance)
					{
						remaininglength = deviationdistance - segmentlength;
						seedposition = (path[index - 1]) + ((vectornormalize(path[index] - (path[index - 1]))) * remaininglength);
						/#
							recordcircle(seedposition, 2, (1, 0.5, 0), "", self);
						#/
						innerzigzagradius = level.inner_zigzag_radius;
						outerzigzagradius = level.outer_zigzag_radius;
						queryresult = positionquery_source_navigation(seedposition, innerzigzagradius, outerzigzagradius, 36, 16, self, 16);
						positionquery_filter_inclaimedlocation(queryresult, self);
						if(queryresult.data.size > 0)
						{
							point = queryresult.data[randomint(queryresult.data.size)];
							if(tracepassedonnavmesh(seedposition, point.origin, 16))
							{
								goalpos = point.origin;
							}
						}
						break;
					}
					segmentlength = segmentlength + currentseglength;
				}
			}
		}
		self setgoal(goalpos);
		self.nextgoalupdate = gettime() + randomintrange(500, 1000);
	}
	aiprofile_endentry();
}

/*
	Name: zombieenteredplayable
	Namespace: zm_behavior
	Checksum: 0x7F76BCED
	Offset: 0x2F50
	Size: 0xF2
	Parameters: 1
	Flags: Linked
*/
function zombieenteredplayable(behaviortreeentity)
{
	if(!isdefined(level.playable_areas))
	{
		level.playable_areas = getentarray("player_volume", "script_noteworthy");
	}
	foreach(area in level.playable_areas)
	{
		if(behaviortreeentity istouching(area))
		{
			behaviortreeentity zm_spawner::zombie_complete_emerging_into_playable_area();
			return true;
		}
	}
	return false;
}

/*
	Name: shouldmovecondition
	Namespace: zm_behavior
	Checksum: 0xF2629051
	Offset: 0x3050
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function shouldmovecondition(behaviortreeentity)
{
	if(behaviortreeentity haspath())
	{
		return true;
	}
	if(isdefined(behaviortreeentity.keep_moving) && behaviortreeentity.keep_moving)
	{
		return true;
	}
	return false;
}

/*
	Name: zombieshouldmoveawaycondition
	Namespace: zm_behavior
	Checksum: 0xA201B4F1
	Offset: 0x30B8
	Size: 0x12
	Parameters: 1
	Flags: Linked
*/
function zombieshouldmoveawaycondition(behaviortreeentity)
{
	return level.wait_and_revive;
}

/*
	Name: waskilledbyteslacondition
	Namespace: zm_behavior
	Checksum: 0xBE9FE714
	Offset: 0x30D8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function waskilledbyteslacondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.tesla_death) && behaviortreeentity.tesla_death)
	{
		return true;
	}
	return false;
}

/*
	Name: disablepowerups
	Namespace: zm_behavior
	Checksum: 0x74A0F634
	Offset: 0x3120
	Size: 0x20
	Parameters: 1
	Flags: Linked
*/
function disablepowerups(behaviortreeentity)
{
	behaviortreeentity.no_powerups = 1;
}

/*
	Name: enablepowerups
	Namespace: zm_behavior
	Checksum: 0x178F55F4
	Offset: 0x3148
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function enablepowerups(behaviortreeentity)
{
	behaviortreeentity.no_powerups = 0;
}

/*
	Name: zombiemoveaway
	Namespace: zm_behavior
	Checksum: 0x650B76C7
	Offset: 0x3170
	Size: 0x316
	Parameters: 2
	Flags: Linked
*/
function zombiemoveaway(behaviortreeentity, asmstatename)
{
	player = util::gethostplayer();
	queryresult = level.move_away_points;
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	if(!isdefined(queryresult))
	{
		return 5;
	}
	for(i = 0; i < queryresult.data.size; i++)
	{
		if(!zm_utility::check_point_in_playable_area(queryresult.data[i].origin))
		{
			continue;
		}
		isbehind = vectordot(player.origin - behaviortreeentity.origin, queryresult.data[i].origin - behaviortreeentity.origin);
		if(isbehind < 0)
		{
			behaviortreeentity setgoal(queryresult.data[i].origin);
			arrayremoveindex(level.move_away_points.data, i, 0);
			i--;
			return 5;
		}
	}
	for(i = 0; i < queryresult.data.size; i++)
	{
		if(!zm_utility::check_point_in_playable_area(queryresult.data[i].origin))
		{
			continue;
		}
		dist_zombie = distancesquared(queryresult.data[i].origin, behaviortreeentity.origin);
		dist_player = distancesquared(queryresult.data[i].origin, player.origin);
		if(dist_zombie < dist_player)
		{
			behaviortreeentity setgoal(queryresult.data[i].origin);
			arrayremoveindex(level.move_away_points.data, i, 0);
			i--;
			return 5;
		}
	}
	return 5;
}

/*
	Name: zombieisbeinggrappled
	Namespace: zm_behavior
	Checksum: 0x192B5BCA
	Offset: 0x3490
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function zombieisbeinggrappled(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.grapple_is_fatal) && behaviortreeentity.grapple_is_fatal)
	{
		return true;
	}
	return false;
}

/*
	Name: zombieshouldknockdown
	Namespace: zm_behavior
	Checksum: 0x644E3673
	Offset: 0x34D8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function zombieshouldknockdown(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.knockdown) && behaviortreeentity.knockdown)
	{
		return true;
	}
	return false;
}

/*
	Name: zombieispushed
	Namespace: zm_behavior
	Checksum: 0xC1D32458
	Offset: 0x3520
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function zombieispushed(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.pushed) && behaviortreeentity.pushed)
	{
		return true;
	}
	return false;
}

/*
	Name: zombiegrappleactionstart
	Namespace: zm_behavior
	Checksum: 0x4B9473D4
	Offset: 0x3568
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function zombiegrappleactionstart(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_grapple_direction", self.grapple_direction);
}

/*
	Name: zombieknockdownactionstart
	Namespace: zm_behavior
	Checksum: 0x7E7CCF1B
	Offset: 0x35A8
	Size: 0x84
	Parameters: 1
	Flags: Linked, Private
*/
function private zombieknockdownactionstart(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_knockdown_direction", behaviortreeentity.knockdown_direction);
	blackboard::setblackboardattribute(behaviortreeentity, "_knockdown_type", behaviortreeentity.knockdown_type);
	blackboard::setblackboardattribute(behaviortreeentity, "_getup_direction", behaviortreeentity.getup_direction);
}

/*
	Name: zombiegetupactionterminate
	Namespace: zm_behavior
	Checksum: 0xA8D5D019
	Offset: 0x3638
	Size: 0x1C
	Parameters: 1
	Flags: Linked, Private
*/
function private zombiegetupactionterminate(behaviortreeentity)
{
	behaviortreeentity.knockdown = 0;
}

/*
	Name: zombiepushedactionstart
	Namespace: zm_behavior
	Checksum: 0x5BE79C35
	Offset: 0x3660
	Size: 0x34
	Parameters: 1
	Flags: Linked, Private
*/
function private zombiepushedactionstart(behaviortreeentity)
{
	blackboard::setblackboardattribute(behaviortreeentity, "_push_direction", behaviortreeentity.push_direction);
}

/*
	Name: zombiepushedactionterminate
	Namespace: zm_behavior
	Checksum: 0x73DD2705
	Offset: 0x36A0
	Size: 0x1C
	Parameters: 1
	Flags: Linked, Private
*/
function private zombiepushedactionterminate(behaviortreeentity)
{
	behaviortreeentity.pushed = 0;
}

/*
	Name: zombieshouldstun
	Namespace: zm_behavior
	Checksum: 0x91982099
	Offset: 0x36C8
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function zombieshouldstun(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.zombie_tesla_hit) && behaviortreeentity.zombie_tesla_hit && (!(isdefined(behaviortreeentity.tesla_death) && behaviortreeentity.tesla_death)))
	{
		return true;
	}
	return false;
}

/*
	Name: zombiestunactionstart
	Namespace: zm_behavior
	Checksum: 0x39BB1468
	Offset: 0x3730
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function zombiestunactionstart(behaviortreeentity)
{
}

/*
	Name: zombiestunactionend
	Namespace: zm_behavior
	Checksum: 0x15F20E20
	Offset: 0x3748
	Size: 0x1C
	Parameters: 1
	Flags: Linked
*/
function zombiestunactionend(behaviortreeentity)
{
	behaviortreeentity.zombie_tesla_hit = 0;
}

/*
	Name: zombietraverseaction
	Namespace: zm_behavior
	Checksum: 0xC396708F
	Offset: 0x3770
	Size: 0x60
	Parameters: 2
	Flags: Linked
*/
function zombietraverseaction(behaviortreeentity, asmstatename)
{
	aiutility::traverseactionstart(behaviortreeentity, asmstatename);
	behaviortreeentity.old_powerups = behaviortreeentity.no_powerups;
	disablepowerups(behaviortreeentity);
	return 5;
}

/*
	Name: zombietraverseactionterminate
	Namespace: zm_behavior
	Checksum: 0xFA7F2EF4
	Offset: 0x37D8
	Size: 0xB0
	Parameters: 2
	Flags: Linked
*/
function zombietraverseactionterminate(behaviortreeentity, asmstatename)
{
	if(behaviortreeentity asmgetstatus() == "asm_status_complete")
	{
		behaviortreeentity.no_powerups = behaviortreeentity.old_powerups;
		if(!(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs))
		{
			behaviortreeentity pushactors(0);
			behaviortreeentity.enablepushtime = gettime() + 1000;
		}
	}
	return 4;
}

/*
	Name: zombiegottoentrancecondition
	Namespace: zm_behavior
	Checksum: 0x467618B7
	Offset: 0x3890
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function zombiegottoentrancecondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.got_to_entrance) && behaviortreeentity.got_to_entrance)
	{
		return true;
	}
	return false;
}

/*
	Name: zombiegottoattackspotcondition
	Namespace: zm_behavior
	Checksum: 0x82A00
	Offset: 0x38D8
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function zombiegottoattackspotcondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.at_entrance_tear_spot) && behaviortreeentity.at_entrance_tear_spot)
	{
		return true;
	}
	return false;
}

/*
	Name: zombiehasattackspotalreadycondition
	Namespace: zm_behavior
	Checksum: 0x9F0B1708
	Offset: 0x3920
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function zombiehasattackspotalreadycondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.attacking_spot_index) && behaviortreeentity.attacking_spot_index >= 0)
	{
		return true;
	}
	return false;
}

/*
	Name: zombieshouldtearcondition
	Namespace: zm_behavior
	Checksum: 0xD55D1D5A
	Offset: 0x3968
	Size: 0x76
	Parameters: 1
	Flags: Linked
*/
function zombieshouldtearcondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.first_node) && isdefined(behaviortreeentity.first_node.barrier_chunks))
	{
		if(!zm_utility::all_chunks_destroyed(behaviortreeentity.first_node, behaviortreeentity.first_node.barrier_chunks))
		{
			return true;
		}
	}
	return false;
}

/*
	Name: zombieshouldattackthroughboardscondition
	Namespace: zm_behavior
	Checksum: 0x91D34010
	Offset: 0x39E8
	Size: 0x318
	Parameters: 1
	Flags: Linked
*/
function zombieshouldattackthroughboardscondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs)
	{
		return false;
	}
	if(isdefined(behaviortreeentity.first_node.zbarrier))
	{
		if(!behaviortreeentity.first_node.zbarrier zbarriersupportszombiereachthroughattacks())
		{
			chunks = undefined;
			if(isdefined(behaviortreeentity.first_node))
			{
				chunks = zm_utility::get_non_destroyed_chunks(behaviortreeentity.first_node, behaviortreeentity.first_node.barrier_chunks);
			}
			if(isdefined(chunks) && chunks.size > 0)
			{
				return false;
			}
		}
	}
	if(getdvarstring("zombie_reachin_freq") == "")
	{
		setdvar("zombie_reachin_freq", "50");
	}
	freq = getdvarint("zombie_reachin_freq");
	players = getplayers();
	attack = 0;
	behaviortreeentity.player_targets = [];
	for(i = 0; i < players.size; i++)
	{
		if(isalive(players[i]) && !isdefined(players[i].revivetrigger) && distance2d(behaviortreeentity.origin, players[i].origin) <= 109.8 && (!(isdefined(players[i].zombie_vars["zombie_powerup_zombie_blood_on"]) && players[i].zombie_vars["zombie_powerup_zombie_blood_on"])) && (!(isdefined(players[i].ignoreme) && players[i].ignoreme)))
		{
			behaviortreeentity.player_targets[behaviortreeentity.player_targets.size] = players[i];
			attack = 1;
		}
	}
	if(!attack || freq < randomint(100))
	{
		return false;
	}
	return true;
}

/*
	Name: zombieshouldtauntcondition
	Namespace: zm_behavior
	Checksum: 0xBB73BDD6
	Offset: 0x3D08
	Size: 0x118
	Parameters: 1
	Flags: Linked
*/
function zombieshouldtauntcondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs)
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.first_node.zbarrier))
	{
		return false;
	}
	if(!behaviortreeentity.first_node.zbarrier zbarriersupportszombietaunts())
	{
		return false;
	}
	if(getdvarstring("zombie_taunt_freq") == "")
	{
		setdvar("zombie_taunt_freq", "5");
	}
	freq = getdvarint("zombie_taunt_freq");
	if(freq >= randomint(100))
	{
		return true;
	}
	return false;
}

/*
	Name: zombieshouldenterplayablecondition
	Namespace: zm_behavior
	Checksum: 0xAA7C11FA
	Offset: 0x3E28
	Size: 0xC0
	Parameters: 1
	Flags: Linked
*/
function zombieshouldenterplayablecondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.first_node) && isdefined(behaviortreeentity.first_node.barrier_chunks))
	{
		if(zm_utility::all_chunks_destroyed(behaviortreeentity.first_node, behaviortreeentity.first_node.barrier_chunks))
		{
			if(isdefined(behaviortreeentity.at_entrance_tear_spot) && behaviortreeentity.at_entrance_tear_spot && (!(isdefined(behaviortreeentity.completed_emerging_into_playable_area) && behaviortreeentity.completed_emerging_into_playable_area)))
			{
				return true;
			}
		}
	}
	return false;
}

/*
	Name: ischunkvalidcondition
	Namespace: zm_behavior
	Checksum: 0xF0A95612
	Offset: 0x3EF0
	Size: 0x28
	Parameters: 1
	Flags: Linked
*/
function ischunkvalidcondition(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.chunk))
	{
		return true;
	}
	return false;
}

/*
	Name: inplayablearea
	Namespace: zm_behavior
	Checksum: 0xD6A5567
	Offset: 0x3F20
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function inplayablearea(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.completed_emerging_into_playable_area) && behaviortreeentity.completed_emerging_into_playable_area)
	{
		return true;
	}
	return false;
}

/*
	Name: shouldskipteardown
	Namespace: zm_behavior
	Checksum: 0x708AC40B
	Offset: 0x3F68
	Size: 0x36
	Parameters: 1
	Flags: Linked
*/
function shouldskipteardown(behaviortreeentity)
{
	if(behaviortreeentity zm_spawner::should_skip_teardown(behaviortreeentity.find_flesh_struct_string))
	{
		return true;
	}
	return false;
}

/*
	Name: zombieisthinkdone
	Namespace: zm_behavior
	Checksum: 0xAF3CA78C
	Offset: 0x3FA8
	Size: 0x66
	Parameters: 1
	Flags: Linked
*/
function zombieisthinkdone(behaviortreeentity)
{
	/#
		if(isdefined(behaviortreeentity.is_rat_test) && behaviortreeentity.is_rat_test)
		{
			return false;
		}
	#/
	if(isdefined(behaviortreeentity.zombie_think_done) && behaviortreeentity.zombie_think_done)
	{
		return true;
	}
	return false;
}

/*
	Name: zombieisatgoal
	Namespace: zm_behavior
	Checksum: 0xFD7EDCC0
	Offset: 0x4018
	Size: 0x34
	Parameters: 1
	Flags: Linked
*/
function zombieisatgoal(behaviortreeentity)
{
	isatscriptgoal = behaviortreeentity isatgoal();
	return isatscriptgoal;
}

/*
	Name: zombieisatentrance
	Namespace: zm_behavior
	Checksum: 0xBA1D2BCB
	Offset: 0x4058
	Size: 0x5A
	Parameters: 1
	Flags: Linked
*/
function zombieisatentrance(behaviortreeentity)
{
	isatscriptgoal = behaviortreeentity isatgoal();
	isatentrance = isdefined(behaviortreeentity.first_node) && isatscriptgoal;
	return isatentrance;
}

/*
	Name: getchunkservice
	Namespace: zm_behavior
	Checksum: 0xCDE610FC
	Offset: 0x40C0
	Size: 0xE4
	Parameters: 1
	Flags: Linked
*/
function getchunkservice(behaviortreeentity)
{
	behaviortreeentity.chunk = zm_utility::get_closest_non_destroyed_chunk(behaviortreeentity.origin, behaviortreeentity.first_node, behaviortreeentity.first_node.barrier_chunks);
	if(isdefined(behaviortreeentity.chunk))
	{
		behaviortreeentity.first_node.zbarrier setzbarrierpiecestate(behaviortreeentity.chunk, "targetted_by_zombie");
		behaviortreeentity.first_node thread zm_spawner::check_zbarrier_piece_for_zombie_death(behaviortreeentity.chunk, behaviortreeentity.first_node.zbarrier, behaviortreeentity);
	}
}

/*
	Name: updatechunkservice
	Namespace: zm_behavior
	Checksum: 0xE5F528BC
	Offset: 0x41B0
	Size: 0x80
	Parameters: 1
	Flags: Linked
*/
function updatechunkservice(behaviortreeentity)
{
	while(0 < behaviortreeentity.first_node.zbarrier.chunk_health[behaviortreeentity.chunk])
	{
		behaviortreeentity.first_node.zbarrier.chunk_health[behaviortreeentity.chunk]--;
	}
	behaviortreeentity.lastchunk_destroy_time = gettime();
}

/*
	Name: updateattackspotservice
	Namespace: zm_behavior
	Checksum: 0x783C6D47
	Offset: 0x4238
	Size: 0x100
	Parameters: 1
	Flags: Linked
*/
function updateattackspotservice(behaviortreeentity)
{
	if(isdefined(behaviortreeentity.marked_for_death) && behaviortreeentity.marked_for_death || behaviortreeentity.health < 0)
	{
		return false;
	}
	if(!isdefined(behaviortreeentity.attacking_spot))
	{
		if(!behaviortreeentity zm_spawner::get_attack_spot(behaviortreeentity.first_node))
		{
			return false;
		}
	}
	if(isdefined(behaviortreeentity.attacking_spot))
	{
		behaviortreeentity.goalradius = 8;
		behaviortreeentity setgoal(behaviortreeentity.attacking_spot);
		if(behaviortreeentity isatgoal())
		{
			behaviortreeentity.at_entrance_tear_spot = 1;
		}
		return true;
	}
	return false;
}

/*
	Name: findnodesservice
	Namespace: zm_behavior
	Checksum: 0x778F4413
	Offset: 0x4340
	Size: 0x1BE
	Parameters: 1
	Flags: Linked
*/
function findnodesservice(behaviortreeentity)
{
	node = undefined;
	behaviortreeentity.entrance_nodes = [];
	if(isdefined(behaviortreeentity.find_flesh_struct_string))
	{
		if(behaviortreeentity.find_flesh_struct_string == "find_flesh")
		{
			return false;
		}
		for(i = 0; i < level.exterior_goals.size; i++)
		{
			if(isdefined(level.exterior_goals[i].script_string) && level.exterior_goals[i].script_string == behaviortreeentity.find_flesh_struct_string)
			{
				node = level.exterior_goals[i];
				break;
			}
		}
		behaviortreeentity.entrance_nodes[behaviortreeentity.entrance_nodes.size] = node;
		/#
			assert(isdefined(node), ("" + behaviortreeentity.find_flesh_struct_string) + "");
		#/
		behaviortreeentity.first_node = node;
		behaviortreeentity.goalradius = 128;
		behaviortreeentity setgoal(node.origin);
		if(zombieisatentrance(behaviortreeentity))
		{
			behaviortreeentity.got_to_entrance = 1;
		}
		return true;
	}
}

/*
	Name: zombieattackableobjectservice
	Namespace: zm_behavior
	Checksum: 0x9F8F4BE6
	Offset: 0x4508
	Size: 0x13E
	Parameters: 1
	Flags: Linked
*/
function zombieattackableobjectservice(behaviortreeentity)
{
	if(!behaviortreeentity ai::has_behavior_attribute("use_attackable") || !behaviortreeentity ai::get_behavior_attribute("use_attackable"))
	{
		behaviortreeentity.attackable = undefined;
		return false;
	}
	if(isdefined(behaviortreeentity.missinglegs) && behaviortreeentity.missinglegs)
	{
		behaviortreeentity.attackable = undefined;
		return false;
	}
	if(isdefined(behaviortreeentity.aat_turned) && behaviortreeentity.aat_turned)
	{
		behaviortreeentity.attackable = undefined;
		return false;
	}
	if(!isdefined(behaviortreeentity.attackable))
	{
		behaviortreeentity.attackable = zm_attackables::get_attackable();
	}
	else if(!(isdefined(behaviortreeentity.attackable.is_active) && behaviortreeentity.attackable.is_active))
	{
		behaviortreeentity.attackable = undefined;
	}
}

/*
	Name: zombiemovetoentranceaction
	Namespace: zm_behavior
	Checksum: 0x8AFC9819
	Offset: 0x4650
	Size: 0x40
	Parameters: 2
	Flags: Linked
*/
function zombiemovetoentranceaction(behaviortreeentity, asmstatename)
{
	behaviortreeentity.got_to_entrance = 0;
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: zombiemovetoentranceactionterminate
	Namespace: zm_behavior
	Checksum: 0x75B055A5
	Offset: 0x4698
	Size: 0x44
	Parameters: 2
	Flags: Linked
*/
function zombiemovetoentranceactionterminate(behaviortreeentity, asmstatename)
{
	if(zombieisatentrance(behaviortreeentity))
	{
		behaviortreeentity.got_to_entrance = 1;
	}
	return 4;
}

/*
	Name: zombiemovetoattackspotaction
	Namespace: zm_behavior
	Checksum: 0x1F82E0B4
	Offset: 0x46E8
	Size: 0x40
	Parameters: 2
	Flags: Linked
*/
function zombiemovetoattackspotaction(behaviortreeentity, asmstatename)
{
	behaviortreeentity.at_entrance_tear_spot = 0;
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: zombiemovetoattackspotactionterminate
	Namespace: zm_behavior
	Checksum: 0xF92A0A96
	Offset: 0x4730
	Size: 0x2C
	Parameters: 2
	Flags: Linked
*/
function zombiemovetoattackspotactionterminate(behaviortreeentity, asmstatename)
{
	behaviortreeentity.at_entrance_tear_spot = 1;
	return 4;
}

/*
	Name: zombieholdboardaction
	Namespace: zm_behavior
	Checksum: 0x41BB5012
	Offset: 0x4768
	Size: 0x120
	Parameters: 2
	Flags: Linked
*/
function zombieholdboardaction(behaviortreeentity, asmstatename)
{
	behaviortreeentity.keepclaimednode = 1;
	blackboard::setblackboardattribute(behaviortreeentity, "_which_board_pull", int(behaviortreeentity.chunk));
	blackboard::setblackboardattribute(behaviortreeentity, "_board_attack_spot", float(behaviortreeentity.attacking_spot_index));
	boardactionast = behaviortreeentity astsearch(istring(asmstatename));
	boardactionanimation = animationstatenetworkutility::searchanimationmap(behaviortreeentity, boardactionast["animation"]);
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: zombieholdboardactionterminate
	Namespace: zm_behavior
	Checksum: 0xAB24CB44
	Offset: 0x4890
	Size: 0x28
	Parameters: 2
	Flags: Linked
*/
function zombieholdboardactionterminate(behaviortreeentity, asmstatename)
{
	behaviortreeentity.keepclaimednode = 0;
	return 4;
}

/*
	Name: zombiegrabboardaction
	Namespace: zm_behavior
	Checksum: 0x923D69E9
	Offset: 0x48C0
	Size: 0x120
	Parameters: 2
	Flags: Linked
*/
function zombiegrabboardaction(behaviortreeentity, asmstatename)
{
	behaviortreeentity.keepclaimednode = 1;
	blackboard::setblackboardattribute(behaviortreeentity, "_which_board_pull", int(behaviortreeentity.chunk));
	blackboard::setblackboardattribute(behaviortreeentity, "_board_attack_spot", float(behaviortreeentity.attacking_spot_index));
	boardactionast = behaviortreeentity astsearch(istring(asmstatename));
	boardactionanimation = animationstatenetworkutility::searchanimationmap(behaviortreeentity, boardactionast["animation"]);
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: zombiegrabboardactionterminate
	Namespace: zm_behavior
	Checksum: 0x64E7B453
	Offset: 0x49E8
	Size: 0x28
	Parameters: 2
	Flags: Linked
*/
function zombiegrabboardactionterminate(behaviortreeentity, asmstatename)
{
	behaviortreeentity.keepclaimednode = 0;
	return 4;
}

/*
	Name: zombiepullboardaction
	Namespace: zm_behavior
	Checksum: 0xFBF18931
	Offset: 0x4A18
	Size: 0x120
	Parameters: 2
	Flags: Linked
*/
function zombiepullboardaction(behaviortreeentity, asmstatename)
{
	behaviortreeentity.keepclaimednode = 1;
	blackboard::setblackboardattribute(behaviortreeentity, "_which_board_pull", int(behaviortreeentity.chunk));
	blackboard::setblackboardattribute(behaviortreeentity, "_board_attack_spot", float(behaviortreeentity.attacking_spot_index));
	boardactionast = behaviortreeentity astsearch(istring(asmstatename));
	boardactionanimation = animationstatenetworkutility::searchanimationmap(behaviortreeentity, boardactionast["animation"]);
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: zombiepullboardactionterminate
	Namespace: zm_behavior
	Checksum: 0x736701
	Offset: 0x4B40
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function zombiepullboardactionterminate(behaviortreeentity, asmstatename)
{
	behaviortreeentity.keepclaimednode = 0;
	self.lastchunk_destroy_time = gettime();
	return 4;
}

/*
	Name: zombieattackthroughboardsaction
	Namespace: zm_behavior
	Checksum: 0x58E79F43
	Offset: 0x4B80
	Size: 0x58
	Parameters: 2
	Flags: Linked
*/
function zombieattackthroughboardsaction(behaviortreeentity, asmstatename)
{
	behaviortreeentity.keepclaimednode = 1;
	behaviortreeentity.boardattack = 1;
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: zombieattackthroughboardsactionterminate
	Namespace: zm_behavior
	Checksum: 0x8A6207E6
	Offset: 0x4BE0
	Size: 0x38
	Parameters: 2
	Flags: Linked
*/
function zombieattackthroughboardsactionterminate(behaviortreeentity, asmstatename)
{
	behaviortreeentity.keepclaimednode = 0;
	behaviortreeentity.boardattack = 0;
	return 4;
}

/*
	Name: zombietauntaction
	Namespace: zm_behavior
	Checksum: 0x3ABC6F11
	Offset: 0x4C20
	Size: 0x48
	Parameters: 2
	Flags: Linked
*/
function zombietauntaction(behaviortreeentity, asmstatename)
{
	behaviortreeentity.keepclaimednode = 1;
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: zombietauntactionterminate
	Namespace: zm_behavior
	Checksum: 0x59D094B0
	Offset: 0x4C70
	Size: 0x28
	Parameters: 2
	Flags: Linked
*/
function zombietauntactionterminate(behaviortreeentity, asmstatename)
{
	behaviortreeentity.keepclaimednode = 0;
	return 4;
}

/*
	Name: zombiemantleaction
	Namespace: zm_behavior
	Checksum: 0xBE001776
	Offset: 0x4CA0
	Size: 0xD0
	Parameters: 2
	Flags: Linked
*/
function zombiemantleaction(behaviortreeentity, asmstatename)
{
	behaviortreeentity.clamptonavmesh = 0;
	if(isdefined(behaviortreeentity.attacking_spot_index))
	{
		behaviortreeentity.saved_attacking_spot_index = behaviortreeentity.attacking_spot_index;
		blackboard::setblackboardattribute(behaviortreeentity, "_board_attack_spot", float(behaviortreeentity.attacking_spot_index));
	}
	behaviortreeentity.isinmantleaction = 1;
	behaviortreeentity zombie_utility::reset_attack_spot();
	animationstatenetworkutility::requeststate(behaviortreeentity, asmstatename);
	return 5;
}

/*
	Name: zombiemantleactionterminate
	Namespace: zm_behavior
	Checksum: 0xB1760FF1
	Offset: 0x4D78
	Size: 0x50
	Parameters: 2
	Flags: Linked
*/
function zombiemantleactionterminate(behaviortreeentity, asmstatename)
{
	behaviortreeentity.clamptonavmesh = 1;
	behaviortreeentity.isinmantleaction = undefined;
	behaviortreeentity zm_behavior_utility::enteredplayablearea();
	return 4;
}

/*
	Name: boardtearmocompstart
	Namespace: zm_behavior
	Checksum: 0x8711E137
	Offset: 0x4DD0
	Size: 0x174
	Parameters: 5
	Flags: Linked
*/
function boardtearmocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	origin = getstartorigin(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompanim);
	angles = getstartangles(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompanim);
	entity forceteleport(origin, angles, 1);
	entity.pushable = 0;
	entity.blockingpain = 1;
	entity animmode("noclip", 1);
	entity orientmode("face angle", angles[1]);
}

/*
	Name: boardtearmocompupdate
	Namespace: zm_behavior
	Checksum: 0x612AB632
	Offset: 0x4F50
	Size: 0x70
	Parameters: 5
	Flags: Linked
*/
function boardtearmocompupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity animmode("noclip", 0);
	entity.pushable = 0;
	entity.blockingpain = 1;
}

/*
	Name: barricadeentermocompstart
	Namespace: zm_behavior
	Checksum: 0xD25CFFE7
	Offset: 0x4FC8
	Size: 0x1E0
	Parameters: 5
	Flags: Linked
*/
function barricadeentermocompstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	origin = getstartorigin(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompanim);
	angles = getstartangles(entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompanim);
	if(isdefined(entity.mocomp_barricade_offset))
	{
		origin = origin + (anglestoforward(angles) * entity.mocomp_barricade_offset);
	}
	entity forceteleport(origin, angles, 1);
	entity animmode("noclip", 0);
	entity orientmode("face angle", angles[1]);
	entity.pushable = 0;
	entity.blockingpain = 1;
	entity pathmode("dont move");
	entity.usegoalanimweight = 1;
}

/*
	Name: barricadeentermocompupdate
	Namespace: zm_behavior
	Checksum: 0x10BF7C6C
	Offset: 0x51B0
	Size: 0x5C
	Parameters: 5
	Flags: Linked
*/
function barricadeentermocompupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity animmode("noclip", 0);
	entity.pushable = 0;
}

/*
	Name: barricadeentermocompterminate
	Namespace: zm_behavior
	Checksum: 0x381E8F52
	Offset: 0x5218
	Size: 0xBC
	Parameters: 5
	Flags: Linked
*/
function barricadeentermocompterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity.pushable = 1;
	entity.blockingpain = 0;
	entity pathmode("move allowed");
	entity.usegoalanimweight = 0;
	entity animmode("normal", 0);
	entity orientmode("face motion");
}

/*
	Name: barricadeentermocompnozstart
	Namespace: zm_behavior
	Checksum: 0xBB5320A
	Offset: 0x52E0
	Size: 0x218
	Parameters: 5
	Flags: Linked
*/
function barricadeentermocompnozstart(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	zbarrier_origin = (entity.first_node.zbarrier.origin[0], entity.first_node.zbarrier.origin[1], entity.origin[2]);
	origin = getstartorigin(zbarrier_origin, entity.first_node.zbarrier.angles, mocompanim);
	angles = getstartangles(zbarrier_origin, entity.first_node.zbarrier.angles, mocompanim);
	if(isdefined(entity.mocomp_barricade_offset))
	{
		origin = origin + (anglestoforward(angles) * entity.mocomp_barricade_offset);
	}
	entity forceteleport(origin, angles, 1);
	entity animmode("noclip", 0);
	entity orientmode("face angle", angles[1]);
	entity.pushable = 0;
	entity.blockingpain = 1;
	entity pathmode("dont move");
	entity.usegoalanimweight = 1;
}

/*
	Name: barricadeentermocompnozupdate
	Namespace: zm_behavior
	Checksum: 0xDCC5821C
	Offset: 0x5500
	Size: 0x5C
	Parameters: 5
	Flags: Linked
*/
function barricadeentermocompnozupdate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity animmode("noclip", 0);
	entity.pushable = 0;
}

/*
	Name: barricadeentermocompnozterminate
	Namespace: zm_behavior
	Checksum: 0x1B7D2016
	Offset: 0x5568
	Size: 0xBC
	Parameters: 5
	Flags: Linked
*/
function barricadeentermocompnozterminate(entity, mocompanim, mocompanimblendouttime, mocompanimflag, mocompduration)
{
	entity.pushable = 1;
	entity.blockingpain = 0;
	entity pathmode("move allowed");
	entity.usegoalanimweight = 0;
	entity animmode("normal", 0);
	entity orientmode("face motion");
}

/*
	Name: notetrackboardtear
	Namespace: zm_behavior
	Checksum: 0x361F1351
	Offset: 0x5630
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function notetrackboardtear(animationentity)
{
	if(isdefined(animationentity.chunk))
	{
		animationentity.first_node.zbarrier setzbarrierpiecestate(animationentity.chunk, "opening");
	}
}

/*
	Name: notetrackboardmelee
	Namespace: zm_behavior
	Checksum: 0xE96DD3C0
	Offset: 0x5698
	Size: 0x2E4
	Parameters: 1
	Flags: Linked
*/
function notetrackboardmelee(animationentity)
{
	/#
		assert(animationentity.meleeweapon != level.weaponnone, "");
	#/
	if(isdefined(animationentity.first_node))
	{
		meleedistsq = 8100;
		if(isdefined(level.attack_player_thru_boards_range))
		{
			meleedistsq = level.attack_player_thru_boards_range * level.attack_player_thru_boards_range;
		}
		triggerdistsq = 2601;
		for(i = 0; i < animationentity.player_targets.size; i++)
		{
			playerdistsq = distance2dsquared(animationentity.player_targets[i].origin, animationentity.origin);
			heightdiff = abs(animationentity.player_targets[i].origin[2] - animationentity.origin[2]);
			if(playerdistsq < meleedistsq && (heightdiff * heightdiff) < meleedistsq)
			{
				playertriggerdistsq = distance2dsquared(animationentity.player_targets[i].origin, animationentity.first_node.trigger_location.origin);
				heightdiff = abs(animationentity.player_targets[i].origin[2] - animationentity.first_node.trigger_location.origin[2]);
				if(playertriggerdistsq < triggerdistsq && (heightdiff * heightdiff) < triggerdistsq)
				{
					animationentity.player_targets[i] dodamage(animationentity.meleeweapon.meleedamage, animationentity.origin, self, self, "none", "MOD_MELEE");
					break;
				}
			}
		}
	}
	else
	{
		animationentity melee();
	}
}

/*
	Name: findzombieenemy
	Namespace: zm_behavior
	Checksum: 0xB18B4352
	Offset: 0x5988
	Size: 0x21C
	Parameters: 0
	Flags: Linked
*/
function findzombieenemy()
{
	zombies = getaispeciesarray(level.zombie_team, "all");
	zombie_enemy = undefined;
	closest_dist = undefined;
	foreach(zombie in zombies)
	{
		if(isalive(zombie) && (isdefined(zombie.completed_emerging_into_playable_area) && zombie.completed_emerging_into_playable_area) && !zm_utility::is_magic_bullet_shield_enabled(zombie) && (zombie.archetype == "zombie" || (isdefined(zombie.canbetargetedbyturnedzombies) && zombie.canbetargetedbyturnedzombies)))
		{
			dist = distancesquared(self.origin, zombie.origin);
			if(!isdefined(closest_dist) || dist < closest_dist)
			{
				closest_dist = dist;
				zombie_enemy = zombie;
			}
		}
	}
	self.favoriteenemy = zombie_enemy;
	if(isdefined(self.favoriteenemy))
	{
		self setgoal(self.favoriteenemy.origin);
	}
	else
	{
		self setgoal(self.origin);
	}
}

/*
	Name: zombieblackholebombpullstart
	Namespace: zm_behavior
	Checksum: 0xEB2F342B
	Offset: 0x5BB0
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function zombieblackholebombpullstart(entity, asmstatename)
{
	entity.pulltime = gettime();
	entity.pullorigin = entity.origin;
	animationstatenetworkutility::requeststate(entity, asmstatename);
	zombieupdateblackholebombpullstate(entity);
	if(isdefined(entity.damageorigin))
	{
		entity.n_zombie_custom_goal_radius = 8;
		entity.v_zombie_custom_goal_pos = entity.damageorigin;
	}
	return 5;
}

/*
	Name: zombieupdateblackholebombpullstate
	Namespace: zm_behavior
	Checksum: 0x996AD1D3
	Offset: 0x5C78
	Size: 0xD4
	Parameters: 1
	Flags: Linked
*/
function zombieupdateblackholebombpullstate(entity)
{
	dist_to_bomb = distancesquared(entity.origin, entity.damageorigin);
	if(dist_to_bomb < 16384)
	{
		entity._black_hole_bomb_collapse_death = 1;
	}
	else
	{
		if(dist_to_bomb < 1048576)
		{
			blackboard::setblackboardattribute(entity, "_zombie_blackholebomb_pull_state", "bhb_pull_fast");
		}
		else if(dist_to_bomb < 4227136)
		{
			blackboard::setblackboardattribute(entity, "_zombie_blackholebomb_pull_state", "bhb_pull_slow");
		}
	}
}

/*
	Name: zombieblackholebombpullupdate
	Namespace: zm_behavior
	Checksum: 0x2D538B78
	Offset: 0x5D58
	Size: 0x254
	Parameters: 2
	Flags: Linked
*/
function zombieblackholebombpullupdate(entity, asmstatename)
{
	if(!isdefined(entity.interdimensional_gun_kill))
	{
		return 4;
	}
	zombieupdateblackholebombpullstate(entity);
	if(isdefined(entity._black_hole_bomb_collapse_death) && entity._black_hole_bomb_collapse_death)
	{
		entity.skipautoragdoll = 1;
		entity dodamage(entity.health + 666, entity.origin + vectorscale((0, 0, 1), 50), entity.interdimensional_gun_attacker, undefined, undefined, "MOD_CRUSH");
		return 4;
	}
	if(isdefined(entity.damageorigin))
	{
		entity.v_zombie_custom_goal_pos = entity.damageorigin;
	}
	if(!(isdefined(entity.missinglegs) && entity.missinglegs) && (gettime() - entity.pulltime) > 1000)
	{
		distsq = distance2dsquared(entity.origin, entity.pullorigin);
		if(distsq < 144)
		{
			entity setavoidancemask("avoid all");
			entity.cant_move = 1;
			if(isdefined(entity.cant_move_cb))
			{
				entity [[entity.cant_move_cb]]();
			}
		}
		else
		{
			entity setavoidancemask("avoid none");
			entity.cant_move = 0;
		}
		entity.pulltime = gettime();
		entity.pullorigin = entity.origin;
	}
	return 5;
}

/*
	Name: zombieblackholebombpullend
	Namespace: zm_behavior
	Checksum: 0x8D024D9C
	Offset: 0x5FB8
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function zombieblackholebombpullend(entity, asmstatename)
{
	entity.v_zombie_custom_goal_pos = undefined;
	entity.n_zombie_custom_goal_radius = undefined;
	entity.pulltime = undefined;
	entity.pullorigin = undefined;
	return 4;
}

/*
	Name: zombiekilledwhilegettingpulled
	Namespace: zm_behavior
	Checksum: 0xEF6E5CCD
	Offset: 0x6010
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function zombiekilledwhilegettingpulled(entity)
{
	if(!(isdefined(self.missinglegs) && self.missinglegs) && (isdefined(entity.interdimensional_gun_kill) && entity.interdimensional_gun_kill) && (!(isdefined(entity._black_hole_bomb_collapse_death) && entity._black_hole_bomb_collapse_death)))
	{
		return true;
	}
	return false;
}

/*
	Name: zombiekilledbyblackholebombcondition
	Namespace: zm_behavior
	Checksum: 0x2D8D7F2E
	Offset: 0x6090
	Size: 0x3A
	Parameters: 1
	Flags: Linked
*/
function zombiekilledbyblackholebombcondition(entity)
{
	if(isdefined(entity._black_hole_bomb_collapse_death) && entity._black_hole_bomb_collapse_death)
	{
		return true;
	}
	return false;
}

/*
	Name: zombiekilledbyblackholebombstart
	Namespace: zm_behavior
	Checksum: 0x52260EFF
	Offset: 0x60D8
	Size: 0x68
	Parameters: 2
	Flags: Linked
*/
function zombiekilledbyblackholebombstart(entity, asmstatename)
{
	animationstatenetworkutility::requeststate(entity, asmstatename);
	if(isdefined(level.black_hole_bomb_death_start_func))
	{
		entity thread [[level.black_hole_bomb_death_start_func]](entity.damageorigin, entity.interdimensional_gun_projectile);
	}
	return 5;
}

/*
	Name: zombiekilledbyblackholebombend
	Namespace: zm_behavior
	Checksum: 0xD775C87C
	Offset: 0x6148
	Size: 0xD8
	Parameters: 2
	Flags: Linked
*/
function zombiekilledbyblackholebombend(entity, asmstatename)
{
	if(isdefined(level._effect) && isdefined(level._effect["black_hole_bomb_zombie_gib"]))
	{
		fxorigin = entity gettagorigin("tag_origin");
		forward = anglestoforward(entity.angles);
		playfx(level._effect["black_hole_bomb_zombie_gib"], fxorigin, forward, (0, 0, 1));
	}
	entity hide();
	return 4;
}

/*
	Name: zombiebhbburst
	Namespace: zm_behavior
	Checksum: 0xBA70F331
	Offset: 0x6228
	Size: 0xB0
	Parameters: 1
	Flags: Linked
*/
function zombiebhbburst(entity)
{
	if(isdefined(level._effect) && isdefined(level._effect["black_hole_bomb_zombie_destroy"]))
	{
		fxorigin = entity gettagorigin("tag_origin");
		playfx(level._effect["black_hole_bomb_zombie_destroy"], fxorigin);
	}
	if(isdefined(entity.interdimensional_gun_projectile))
	{
		entity.interdimensional_gun_projectile notify(#"black_hole_bomb_kill");
	}
}

