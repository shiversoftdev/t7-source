// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\abilities\gadgets\_gadget_camo_render;
#using scripts\shared\abilities\gadgets\_gadget_clone_render;
#using scripts\shared\ai\systems\fx_character;
#using scripts\shared\animation_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using_animtree("all_player");

#namespace end_game_taunts;

/*
	Name: __init__sytem__
	Namespace: end_game_taunts
	Checksum: 0x807E8586
	Offset: 0x20D0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("end_game_taunts", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: end_game_taunts
	Checksum: 0x8780258C
	Offset: 0x2110
	Size: 0x3A4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	animation::add_notetrack_func("taunts::hide", &hidemodel);
	animation::add_notetrack_func("taunts::show", &showmodel);
	animation::add_notetrack_func("taunts::cloneshaderon", &cloneshaderon);
	animation::add_notetrack_func("taunts::cloneshaderoff", &cloneshaderoff);
	animation::add_notetrack_func("taunts::camoshaderon", &camoshaderon);
	animation::add_notetrack_func("taunts::camoshaderoff", &camoshaderoff);
	animation::add_notetrack_func("taunts::spawncameraglass", &spawncameraglass);
	animation::add_notetrack_func("taunts::deletecameraglass", &deletecameraglass);
	animation::add_notetrack_func("taunts::reaperbulletglass", &reaperbulletglass);
	animation::add_notetrack_func("taunts::centerbulletglass", &centerbulletglass);
	animation::add_notetrack_func("taunts::talonbulletglassleft", &talonbulletglassleft);
	animation::add_notetrack_func("taunts::talonbulletglassright", &talonbulletglassright);
	animation::add_notetrack_func("taunts::fireweapon", &fireweapon);
	animation::add_notetrack_func("taunts::stopfireweapon", &stopfireweapon);
	animation::add_notetrack_func("taunts::firebeam", &firebeam);
	animation::add_notetrack_func("taunts::stopfirebeam", &stopfirebeam);
	animation::add_notetrack_func("taunts::playwinnerteamfx", &playwinnerteamfx);
	animation::add_notetrack_func("taunts::playlocalteamfx", &playlocalteamfx);
	level.epictauntxmodels = array("gfx_p7_zm_asc_data_recorder_glass", "wpn_t7_hero_reaper_minigun_prop", "wpn_t7_loot_hero_reaper3_minigun_prop", "c_zsf_robot_grunt_body", "c_zsf_robot_grunt_head", "veh_t7_drone_raps_mp_lite", "veh_t7_drone_raps_mp_dark", "veh_t7_drone_attack_gun_litecolor", "veh_t7_drone_attack_gun_darkcolor", "wpn_t7_arm_blade_prop", "wpn_t7_hero_annihilator_prop", "wpn_t7_hero_bow_prop", "wpn_t7_hero_electro_prop_animate", "wpn_t7_hero_flamethrower_world", "wpn_t7_hero_mgl_world", "wpn_t7_hero_mgl_prop", "wpn_t7_hero_spike_prop", "wpn_t7_hero_seraph_machete_prop", "wpn_t7_loot_crowbar_world", "wpn_t7_spider_mine_world", "wpn_t7_zmb_katana_prop");
	stop_stream_epic_models();
}

/*
	Name: check_force_taunt
	Namespace: end_game_taunts
	Checksum: 0x7542072F
	Offset: 0x24C0
	Size: 0x238
	Parameters: 0
	Flags: None
*/
function check_force_taunt()
{
	/#
		while(true)
		{
			setdvar("", "");
			wait(0.05);
			taunt = getdvarstring("");
			if(taunt == "")
			{
				continue;
			}
			model = level.topplayercharacters[0];
			if(!isdefined(model) || isdefined(model.playingtaunt) || (isdefined(model.playinggesture) && model.playinggesture))
			{
				continue;
			}
			bodytype = getdvarint("", -1);
			setdvar("", -1);
			if(bodytype >= 0)
			{
				tauntmodel = spawn_temp_specialist_model(model.localclientnum, bodytype, model.origin, model.angles, model.showcaseweapon);
				model hide();
			}
			else
			{
				tauntmodel = model;
			}
			idleanimname = getidleanimname(model.localclientnum, model, 0);
			playtaunt(model.localclientnum, tauntmodel, 0, idleanimname, taunt);
			if(tauntmodel != model)
			{
				tauntmodel delete();
				model show();
			}
		}
	#/
}

/*
	Name: check_force_gesture
	Namespace: end_game_taunts
	Checksum: 0x3007C725
	Offset: 0x2700
	Size: 0x140
	Parameters: 0
	Flags: None
*/
function check_force_gesture()
{
	/#
		while(true)
		{
			setdvar("", "");
			wait(0.05);
			gesture = getdvarstring("");
			if(gesture == "")
			{
				continue;
			}
			model = level.topplayercharacters[0];
			if(!isdefined(model) || isdefined(model.playingtaunt) || (isdefined(model.playinggesture) && model.playinggesture))
			{
				continue;
			}
			idleanimname = getidleanimname(model.localclientnum, model, 0);
			playgesture(model.localclientnum, model, 0, idleanimname, gesture, 1);
		}
	#/
}

/*
	Name: draw_runner_up_bounds
	Namespace: end_game_taunts
	Checksum: 0x7143C398
	Offset: 0x2848
	Size: 0xDA
	Parameters: 0
	Flags: None
*/
function draw_runner_up_bounds()
{
	/#
		while(true)
		{
			wait(0.016);
			if(!getdvarint("", 0))
			{
				continue;
			}
			for(i = 1; i < 3; i++)
			{
				model = level.topplayercharacters[i];
				box(model.origin, vectorscale((-1, -1, 0), 15), (15, 15, 72), model.angles[1], (0, 0, 1), 0, 1);
			}
		}
	#/
}

/*
	Name: spawn_temp_specialist_model
	Namespace: end_game_taunts
	Checksum: 0x37198B44
	Offset: 0x2930
	Size: 0x210
	Parameters: 5
	Flags: Linked
*/
function spawn_temp_specialist_model(localclientnum, characterindex, origin, angles, showcaseweapon)
{
	/#
		tempmodel = spawn(localclientnum, origin, "");
		tempmodel.angles = angles;
		tempmodel.showcaseweapon = showcaseweapon;
		tempmodel.bodymodel = getcharacterbodymodel(characterindex, 0, currentsessionmode());
		tempmodel.helmetmodel = getcharacterhelmetmodel(characterindex, 0, currentsessionmode());
		tempmodel setmodel(tempmodel.bodymodel);
		tempmodel attach(tempmodel.helmetmodel, "");
		tempmodel.moderenderoptions = getcharactermoderenderoptions(currentsessionmode());
		tempmodel.bodyrenderoptions = getcharacterbodyrenderoptions(characterindex, 0, 0, 0, 0);
		tempmodel.helmetrenderoptions = getcharacterhelmetrenderoptions(characterindex, 0, 0, 0, 0);
		tempmodel setbodyrenderoptions(tempmodel.moderenderoptions, tempmodel.bodyrenderoptions, tempmodel.helmetrenderoptions, tempmodel.helmetrenderoptions);
		return tempmodel;
	#/
}

/*
	Name: playcurrenttaunt
	Namespace: end_game_taunts
	Checksum: 0x2984B9C6
	Offset: 0x2B50
	Size: 0x94
	Parameters: 3
	Flags: None
*/
function playcurrenttaunt(localclientnum, charactermodel, topplayerindex)
{
	tauntanimname = gettopplayerstaunt(localclientnum, topplayerindex, 0);
	idleanimname = getidleanimname(localclientnum, charactermodel, topplayerindex);
	playtaunt(localclientnum, charactermodel, topplayerindex, idleanimname, tauntanimname);
}

/*
	Name: previewtaunt
	Namespace: end_game_taunts
	Checksum: 0xF74C229
	Offset: 0x2BF0
	Size: 0x7C
	Parameters: 4
	Flags: Linked
*/
function previewtaunt(localclientnum, charactermodel, idleanimname, tauntanimname)
{
	cancelgesture(charactermodel);
	deletecameraglass(undefined);
	playtaunt(localclientnum, charactermodel, 0, idleanimname, tauntanimname, 0, 0);
}

/*
	Name: playtaunt
	Namespace: end_game_taunts
	Checksum: 0x2BF2E78C
	Offset: 0x2C78
	Size: 0x29C
	Parameters: 7
	Flags: Linked
*/
function playtaunt(localclientnum, charactermodel, topplayerindex, idleanimname, tauntanimname, totauntblendtime = 0, playtransitions = 1)
{
	if(!isdefined(tauntanimname) || tauntanimname == "")
	{
		return;
	}
	canceltaunt(localclientnum, charactermodel);
	charactermodel stopsounds();
	charactermodel endon(#"canceltaunt");
	charactermodel util::waittill_dobj(localclientnum);
	if(!charactermodel hasanimtree())
	{
		charactermodel useanimtree($all_player);
	}
	charactermodel.playingtaunt = tauntanimname;
	charactermodel notify(#"tauntstarted");
	charactermodel clearanim(idleanimname, totauntblendtime);
	idleinanimname = getidleinanimname(charactermodel, topplayerindex);
	hideweapon(charactermodel);
	charactermodel thread playepictauntscene(localclientnum, tauntanimname);
	charactermodel animation::play(tauntanimname, undefined, undefined, 1, totauntblendtime, 0.4);
	if(isdefined(playtransitions) && playtransitions)
	{
		self thread waitappearweapon(charactermodel);
		playtransitionanim(charactermodel, idleinanimname, 0.4, 0.4);
	}
	showweapon(charactermodel);
	charactermodel thread animation::play(idleanimname, undefined, undefined, 1, 0.4, 0);
	charactermodel.playingtaunt = undefined;
	charactermodel notify(#"tauntfinished");
	charactermodel shutdownepictauntmodels();
}

/*
	Name: canceltaunt
	Namespace: end_game_taunts
	Checksum: 0x2BFB978A
	Offset: 0x2F20
	Size: 0xBE
	Parameters: 2
	Flags: Linked
*/
function canceltaunt(localclientnum, charactermodel)
{
	if(isdefined(charactermodel.playingtaunt))
	{
		charactermodel cloneshaderoff();
		charactermodel shutdownepictauntmodels();
		charactermodel stopepictauntscene(localclientnum, charactermodel.playingtaunt);
		charactermodel stopsounds();
	}
	charactermodel notify(#"canceltaunt");
	charactermodel.playingtaunt = undefined;
	charactermodel.epictauntmodels = undefined;
}

/*
	Name: playgesturetype
	Namespace: end_game_taunts
	Checksum: 0x2AD0302C
	Offset: 0x2FE8
	Size: 0x9C
	Parameters: 4
	Flags: None
*/
function playgesturetype(localclientnum, charactermodel, topplayerindex, gesturetype)
{
	idleanimname = getidleanimname(localclientnum, charactermodel, topplayerindex);
	gestureanimname = gettopplayersgesture(localclientnum, topplayerindex, gesturetype);
	playgesture(localclientnum, charactermodel, topplayerindex, idleanimname, gestureanimname);
}

/*
	Name: previewgesture
	Namespace: end_game_taunts
	Checksum: 0xF2F74FE6
	Offset: 0x3090
	Size: 0x7C
	Parameters: 4
	Flags: Linked
*/
function previewgesture(localclientnum, charactermodel, idleanimname, gestureanimname)
{
	canceltaunt(localclientnum, charactermodel);
	deletecameraglass(undefined);
	playgesture(localclientnum, charactermodel, 0, idleanimname, gestureanimname, 0);
}

/*
	Name: playgesture
	Namespace: end_game_taunts
	Checksum: 0x7E7752DC
	Offset: 0x3118
	Size: 0x2BC
	Parameters: 6
	Flags: Linked
*/
function playgesture(localclientnum, charactermodel, topplayerindex, idleanimname, gestureanimname, playtransitions = 1)
{
	if(!isdefined(gestureanimname) || gestureanimname == "")
	{
		return;
	}
	cancelgesture(charactermodel);
	charactermodel endon(#"cancelgesture");
	charactermodel util::waittill_dobj(localclientnum);
	if(!charactermodel hasanimtree())
	{
		charactermodel useanimtree($all_player);
	}
	charactermodel.playinggesture = 1;
	charactermodel notify(#"gesturestarted");
	charactermodel clearanim(idleanimname, 0.4);
	idleoutanimname = getidleoutanimname(charactermodel, topplayerindex);
	idleinanimname = getidleinanimname(charactermodel, topplayerindex);
	if(isdefined(playtransitions) && playtransitions)
	{
		self thread waitremoveweapon(charactermodel);
		playtransitionanim(charactermodel, idleoutanimname, 0.4, 0.4);
	}
	hideweapon(charactermodel);
	charactermodel animation::play(gestureanimname, undefined, undefined, 1, 0.4, 0.4);
	if(isdefined(playtransitions) && playtransitions)
	{
		self thread waitappearweapon(charactermodel);
		playtransitionanim(charactermodel, idleinanimname, 0.4, 0.4);
	}
	showweapon(charactermodel);
	charactermodel thread animation::play(idleanimname, undefined, undefined, 1, 0.4, 0);
	charactermodel.playinggesture = 0;
	charactermodel notify(#"gesturefinished");
}

/*
	Name: cancelgesture
	Namespace: end_game_taunts
	Checksum: 0x1FCD374E
	Offset: 0x33E0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function cancelgesture(charactermodel)
{
	charactermodel notify(#"cancelgesture");
	charactermodel.playinggesture = 0;
}

/*
	Name: playtransitionanim
	Namespace: end_game_taunts
	Checksum: 0xBA3E102C
	Offset: 0x3418
	Size: 0x9C
	Parameters: 4
	Flags: Linked
*/
function playtransitionanim(charactermodel, transitionanimname, blendintime = 0, blendouttime = 0)
{
	charactermodel endon(#"canceltaunt");
	if(!isdefined(transitionanimname) || transitionanimname == "")
	{
		return;
	}
	charactermodel animation::play(transitionanimname, undefined, undefined, 1, blendintime, blendouttime);
}

/*
	Name: waitremoveweapon
	Namespace: end_game_taunts
	Checksum: 0x2B49BBC0
	Offset: 0x34C0
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function waitremoveweapon(charactermodel)
{
	charactermodel endon(#"weaponhidden");
	while(true)
	{
		charactermodel waittill(#"_anim_notify_", param1);
		if(param1 == "remove_from_hand")
		{
			hideweapon(charactermodel);
			return;
		}
	}
}

/*
	Name: waitappearweapon
	Namespace: end_game_taunts
	Checksum: 0xDF6FA944
	Offset: 0x3538
	Size: 0x6A
	Parameters: 1
	Flags: Linked
*/
function waitappearweapon(charactermodel)
{
	charactermodel endon(#"weaponshown");
	while(true)
	{
		charactermodel waittill(#"_anim_notify_", param1);
		if(param1 == "appear_in_hand")
		{
			showweapon(charactermodel);
			return;
		}
	}
}

/*
	Name: hideweapon
	Namespace: end_game_taunts
	Checksum: 0x866CEE6A
	Offset: 0x35B0
	Size: 0x94
	Parameters: 1
	Flags: Linked
*/
function hideweapon(charactermodel)
{
	if(charactermodel.weapon == level.weaponnone)
	{
		return;
	}
	markasdirty(charactermodel);
	charactermodel attachweapon(level.weaponnone);
	charactermodel useweaponhidetags(level.weaponnone);
	charactermodel notify(#"weaponhidden");
}

/*
	Name: showweapon
	Namespace: end_game_taunts
	Checksum: 0xE9F9F1EB
	Offset: 0x3650
	Size: 0xFC
	Parameters: 1
	Flags: Linked
*/
function showweapon(charactermodel)
{
	if(!isdefined(charactermodel.showcaseweapon) || charactermodel.weapon != level.weaponnone)
	{
		return;
	}
	markasdirty(charactermodel);
	if(isdefined(charactermodel.showcaseweaponrenderoptions))
	{
		charactermodel attachweapon(charactermodel.showcaseweapon, charactermodel.showcaseweaponrenderoptions, charactermodel.showcaseweaponacvi);
		charactermodel useweaponhidetags(charactermodel.showcaseweapon);
	}
	else
	{
		charactermodel attachweapon(charactermodel.showcaseweapon);
	}
	charactermodel notify(#"weaponshown");
}

/*
	Name: getidleanimname
	Namespace: end_game_taunts
	Checksum: 0xFAF2F370
	Offset: 0x3758
	Size: 0x10AE
	Parameters: 3
	Flags: Linked
*/
function getidleanimname(localclientnum, charactermodel, topplayerindex)
{
	if(isdefined(charactermodel.weapon))
	{
		weapon_group = getitemgroupforweaponname(charactermodel.weapon.rootweapon.name);
		if(weapon_group == "weapon_launcher")
		{
			if(charactermodel.weapon.rootweapon.name == "launcher_lockonly" || charactermodel.weapon.rootweapon.name == "launcher_multi")
			{
				weapon_group = "weapon_launcher_alt";
			}
			else if(charactermodel.weapon.rootweapon.name == "launcher_ex41")
			{
				weapon_group = "weapon_smg_ppsh";
			}
		}
		else
		{
			if(weapon_group == "weapon_pistol" && charactermodel.weapon.isdualwield)
			{
				weapon_group = "weapon_pistol_dw";
			}
			else
			{
				if(weapon_group == "weapon_smg")
				{
					if(charactermodel.weapon.rootweapon.name == "smg_ppsh")
					{
						weapon_group = "weapon_smg_ppsh";
					}
				}
				else
				{
					if(weapon_group == "weapon_cqb")
					{
						if(charactermodel.weapon.rootweapon.name == "shotgun_olympia")
						{
							weapon_group = "weapon_smg_ppsh";
						}
					}
					else
					{
						if(weapon_group == "weapon_special")
						{
							if(charactermodel.weapon.rootweapon.name == "special_crossbow" || charactermodel.weapon.rootweapon.name == "special_discgun")
							{
								weapon_group = "weapon_smg";
							}
							else
							{
								if(charactermodel.weapon.rootweapon.name == "special_crossbow_dw")
								{
									weapon_group = "weapon_pistol_dw";
								}
								else if(charactermodel.weapon.rootweapon.name == "knife_ballistic")
								{
									weapon_group = "weapon_knife_ballistic";
								}
							}
						}
						else
						{
							if(weapon_group == "weapon_knife")
							{
								if(charactermodel.weapon.rootweapon.name == "melee_wrench" || charactermodel.weapon.rootweapon.name == "melee_crowbar" || charactermodel.weapon.rootweapon.name == "melee_improvise" || charactermodel.weapon.rootweapon.name == "melee_shockbaton" || charactermodel.weapon.rootweapon.name == "melee_shovel")
								{
									return array("pb_wrench_endgame_1stplace_idle", "pb_wrench_endgame_2ndplace_idle", "pb_wrench_endgame_3rdplace_idle")[topplayerindex];
								}
								if(charactermodel.weapon.rootweapon.name == "melee_knuckles")
								{
									return array("pb_brass_knuckles_endgame_1stplace_idle", "pb_brass_knuckles_endgame_2ndplace_idle", "pb_brass_knuckles_endgame_3rdplace_idle")[topplayerindex];
								}
								if(charactermodel.weapon.rootweapon.name == "melee_chainsaw" || charactermodel.weapon.rootweapon.name == "melee_boneglass" || charactermodel.weapon.rootweapon.name == "melee_crescent")
								{
									return array("pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle")[topplayerindex];
								}
								if(charactermodel.weapon.rootweapon.name == "melee_boxing")
								{
									return array("pb_boxing_gloves_endgame_1stplace_idle", "pb_boxing_gloves_endgame_2ndplace_idle", "pb_boxing_gloves_endgame_3rdplace_idle")[topplayerindex];
								}
								if(charactermodel.weapon.rootweapon.name == "melee_sword" || charactermodel.weapon.rootweapon.name == "melee_katana")
								{
									return array("pb_sword_endgame_1stplace_idle", "pb_sword_endgame_2ndplace_idle", "pb_sword_endgame_3rdplace_idle")[topplayerindex];
								}
								if(charactermodel.weapon.rootweapon.name == "melee_nunchuks")
								{
									return array("pb_nunchucks_endgame_1stplace_idle", "pb_nunchucks_endgame_2ndplace_idle", "pb_nunchucks_endgame_3rdplace_idle")[topplayerindex];
								}
								if(charactermodel.weapon.rootweapon.name == "melee_bat" || charactermodel.weapon.rootweapon.name == "melee_fireaxe" || charactermodel.weapon.rootweapon.name == "melee_mace")
								{
									return array("pb_mace_endgame_1stplace_idle", "pb_mace_endgame_2ndplace_idle", "pb_mace_endgame_3rdplace_idle")[topplayerindex];
								}
								if(charactermodel.weapon.rootweapon.name == "melee_prosthetic")
								{
									return array("pb_prosthetic_arm_endgame_1stplace_idle", "pb_prosthetic_arm_endgame_2ndplace_idle", "pb_prosthetic_arm_endgame_3rdplace_idle")[topplayerindex];
								}
							}
							else if(weapon_group == "miscweapon")
							{
								if(charactermodel.weapon.rootweapon.name == "blackjack_coin")
								{
									return array("pb_brawler_endgame_1stplace_idle", "pb_brawler_endgame_2ndplace_idle", "pb_brawler_endgame_3rdplace_idle")[topplayerindex];
								}
								if(charactermodel.weapon.rootweapon.name == "blackjack_cards")
								{
									return array("pb_brawler_endgame_1stplace_idle", "pb_brawler_endgame_2ndplace_idle", "pb_brawler_endgame_3rdplace_idle")[topplayerindex];
								}
							}
						}
					}
				}
			}
		}
		if(isdefined(associativearray("weapon_smg", array("pb_smg_endgame_1stplace_idle", "pb_smg_endgame_2ndplace_idle", "pb_smg_endgame_3rdplace_idle"), "weapon_assault", array("pb_rifle_endgame_1stplace_idle", "pb_rifle_endgame_2ndplace_idle", "pb_rifle_endgame_3rdplace_idle"), "weapon_cqb", array("pb_shotgun_endgame_1stplace_idle", "pb_shotgun_endgame_2ndplace_idle", "pb_shotgun_endgame_3rdplace_idle"), "weapon_lmg", array("pb_lmg_endgame_1stplace_idle", "pb_lmg_endgame_2ndplace_idle", "pb_lmg_endgame_3rdplace_idle"), "weapon_sniper", array("pb_sniper_endgame_1stplace_idle", "pb_sniper_endgame_2ndplace_idle", "pb_sniper_endgame_3rdplace_idle"), "weapon_pistol", array("pb_pistol_endgame_1stplace_idle", "pb_pistol_endgame_2ndplace_idle", "pb_pistol_endgame_3rdplace_idle"), "weapon_pistol_dw", array("pb_pistol_dw_endgame_1stplace_idle", "pb_pistol_dw_endgame_2ndplace_idle", "pb_pistol_dw_endgame_3rdplace_idle"), "weapon_launcher", array("pb_launcher_endgame_1stplace_idle", "pb_launcher_endgame_2ndplace_idle", "pb_launcher_endgame_3rdplace_idle"), "weapon_launcher_alt", array("pb_launcher_alt_endgame_1stplace_idle", "pb_launcher_alt_endgame_2ndplace_idle", "pb_launcher_alt_endgame_3rdplace_idle"), "weapon_knife", array("pb_knife_endgame_1stplace_idle", "pb_knife_endgame_2ndplace_idle", "pb_knife_endgame_3rdplace_idle"), "weapon_knuckles", array("pb_brass_knuckles_endgame_1stplace_idle", "pb_brass_knuckles_endgame_2ndplace_idle", "pb_brass_knuckles_endgame_3rdplace_idle"), "weapon_boxing", array("pb_boxing_gloves_endgame_1stplace_idle", "pb_boxing_gloves_endgame_2ndplace_idle", "pb_boxing_gloves_endgame_3rdplace_idle"), "weapon_wrench", array("pb_wrench_endgame_1stplace_idle", "pb_wrench_endgame_2ndplace_idle", "pb_wrench_endgame_3rdplace_idle"), "weapon_sword", array("pb_sword_endgame_1stplace_idle", "pb_sword_endgame_2ndplace_idle", "pb_sword_endgame_3rdplace_idle"), "weapon_nunchucks", array("pb_nunchucks_endgame_1stplace_idle", "pb_nunchucks_endgame_2ndplace_idle", "pb_nunchucks_endgame_3rdplace_idle"), "weapon_mace", array("pb_mace_endgame_1stplace_idle", "pb_mace_endgame_2ndplace_idle", "pb_mace_endgame_3rdplace_idle"), "brawler", array("pb_brawler_endgame_1stplace_idle", "pb_brawler_endgame_2ndplace_idle", "pb_brawler_endgame_3rdplace_idle"), "weapon_prosthetic", array("pb_prosthetic_arm_endgame_1stplace_idle", "pb_prosthetic_arm_endgame_2ndplace_idle", "pb_prosthetic_arm_endgame_3rdplace_idle"), "weapon_chainsaw", array("pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle"), "weapon_smg_ppsh", array("pb_smg_ppsh_endgame_1stplace_idle", "pb_smg_ppsh_endgame_1stplace_idle", "pb_smg_ppsh_endgame_1stplace_idle"), "weapon_knife_ballistic", array("pb_b_knife_endgame_1stplace_idle", "pb_b_knife_endgame_2ndplace_idle", "pb_b_knife_endgame_3rdplace_idle"))[weapon_group]))
		{
			anim_name = associativearray("weapon_smg", array("pb_smg_endgame_1stplace_idle", "pb_smg_endgame_2ndplace_idle", "pb_smg_endgame_3rdplace_idle"), "weapon_assault", array("pb_rifle_endgame_1stplace_idle", "pb_rifle_endgame_2ndplace_idle", "pb_rifle_endgame_3rdplace_idle"), "weapon_cqb", array("pb_shotgun_endgame_1stplace_idle", "pb_shotgun_endgame_2ndplace_idle", "pb_shotgun_endgame_3rdplace_idle"), "weapon_lmg", array("pb_lmg_endgame_1stplace_idle", "pb_lmg_endgame_2ndplace_idle", "pb_lmg_endgame_3rdplace_idle"), "weapon_sniper", array("pb_sniper_endgame_1stplace_idle", "pb_sniper_endgame_2ndplace_idle", "pb_sniper_endgame_3rdplace_idle"), "weapon_pistol", array("pb_pistol_endgame_1stplace_idle", "pb_pistol_endgame_2ndplace_idle", "pb_pistol_endgame_3rdplace_idle"), "weapon_pistol_dw", array("pb_pistol_dw_endgame_1stplace_idle", "pb_pistol_dw_endgame_2ndplace_idle", "pb_pistol_dw_endgame_3rdplace_idle"), "weapon_launcher", array("pb_launcher_endgame_1stplace_idle", "pb_launcher_endgame_2ndplace_idle", "pb_launcher_endgame_3rdplace_idle"), "weapon_launcher_alt", array("pb_launcher_alt_endgame_1stplace_idle", "pb_launcher_alt_endgame_2ndplace_idle", "pb_launcher_alt_endgame_3rdplace_idle"), "weapon_knife", array("pb_knife_endgame_1stplace_idle", "pb_knife_endgame_2ndplace_idle", "pb_knife_endgame_3rdplace_idle"), "weapon_knuckles", array("pb_brass_knuckles_endgame_1stplace_idle", "pb_brass_knuckles_endgame_2ndplace_idle", "pb_brass_knuckles_endgame_3rdplace_idle"), "weapon_boxing", array("pb_boxing_gloves_endgame_1stplace_idle", "pb_boxing_gloves_endgame_2ndplace_idle", "pb_boxing_gloves_endgame_3rdplace_idle"), "weapon_wrench", array("pb_wrench_endgame_1stplace_idle", "pb_wrench_endgame_2ndplace_idle", "pb_wrench_endgame_3rdplace_idle"), "weapon_sword", array("pb_sword_endgame_1stplace_idle", "pb_sword_endgame_2ndplace_idle", "pb_sword_endgame_3rdplace_idle"), "weapon_nunchucks", array("pb_nunchucks_endgame_1stplace_idle", "pb_nunchucks_endgame_2ndplace_idle", "pb_nunchucks_endgame_3rdplace_idle"), "weapon_mace", array("pb_mace_endgame_1stplace_idle", "pb_mace_endgame_2ndplace_idle", "pb_mace_endgame_3rdplace_idle"), "brawler", array("pb_brawler_endgame_1stplace_idle", "pb_brawler_endgame_2ndplace_idle", "pb_brawler_endgame_3rdplace_idle"), "weapon_prosthetic", array("pb_prosthetic_arm_endgame_1stplace_idle", "pb_prosthetic_arm_endgame_2ndplace_idle", "pb_prosthetic_arm_endgame_3rdplace_idle"), "weapon_chainsaw", array("pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle", "pb_chainsaw_endgame_1stplace_idle"), "weapon_smg_ppsh", array("pb_smg_ppsh_endgame_1stplace_idle", "pb_smg_ppsh_endgame_1stplace_idle", "pb_smg_ppsh_endgame_1stplace_idle"), "weapon_knife_ballistic", array("pb_b_knife_endgame_1stplace_idle", "pb_b_knife_endgame_2ndplace_idle", "pb_b_knife_endgame_3rdplace_idle"))[weapon_group][topplayerindex];
		}
	}
	if(!isdefined(anim_name))
	{
		anim_name = array("pb_brawler_endgame_1stplace_idle", "pb_brawler_endgame_2ndplace_idle", "pb_brawler_endgame_3rdplace_idle")[topplayerindex];
	}
	return anim_name;
}

/*
	Name: getidleoutanimname
	Namespace: end_game_taunts
	Checksum: 0x2D91FAD9
	Offset: 0x4810
	Size: 0x4AE
	Parameters: 2
	Flags: Linked
*/
function getidleoutanimname(charactermodel, topplayerindex)
{
	weapon_group = getweapongroup(charactermodel);
	switch(weapon_group)
	{
		case "weapon_smg":
		{
			return array("pb_smg_endgame_1stplace_out", "pb_smg_endgame_2ndplace_out", "pb_smg_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_assault":
		{
			return array("pb_rifle_endgame_1stplace_out", "pb_rifle_endgame_2ndplace_out", "pb_rifle_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_cqb":
		{
			return array("pb_shotgun_endgame_1stplace_out", "pb_shotgun_endgame_2ndplace_out", "pb_shotgun_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_lmg":
		{
			return array("pb_lmg_endgame_1stplace_out", "pb_lmg_endgame_2ndplace_out", "pb_lmg_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_sniper":
		{
			return array("pb_sniper_endgame_1stplace_out", "pb_sniper_endgame_2ndplace_out", "pb_sniper_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_pistol":
		{
			return array("pb_pistol_endgame_1stplace_out", "pb_pistol_endgame_2ndplace_out", "pb_pistol_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_pistol_dw":
		{
			return array("pb_pistol_dw_endgame_1stplace_out", "pb_pistol_dw_endgame_2ndplace_out", "pb_pistol_dw_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_launcher":
		{
			return array("pb_launcher_endgame_1stplace_out", "pb_launcher_endgame_2ndplace_out", "pb_launcher_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_launcher_alt":
		{
			return array("pb_launcher_alt_endgame_1stplace_out", "pb_launcher_alt_endgame_2ndplace_out", "pb_launcher_alt_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_knife":
		{
			return array("pb_knife_endgame_1stplace_out", "pb_knife_endgame_2ndplace_out", "pb_knife_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_knuckles":
		{
			return array("pb_brass_knuckles_endgame_1stplace_out", "pb_brass_knuckles_endgame_2ndplace_out", "pb_brass_knuckles_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_boxing":
		{
			return array("pb_boxing_gloves_endgame_1stplace_out", "pb_boxing_gloves_endgame_2ndplace_out", "pb_boxing_gloves_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_wrench":
		{
			return array("pb_wrench_endgame_1stplace_out", "pb_wrench_endgame_2ndplace_out", "pb_wrench_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_sword":
		{
			return array("pb_sword_endgame_1stplace_out", "pb_sword_endgame_2ndplace_out", "pb_sword_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_nunchucks":
		{
			return array("pb_nunchucks_endgame_1stplace_out", "pb_nunchucks_endgame_2ndplace_out", "pb_nunchucks_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_mace":
		{
			return array("pb_mace_endgame_1stplace_out", "pb_mace_endgame_2ndplace_out", "pb_mace_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_prosthetic":
		{
			return array("pb_prosthetic_arm_endgame_1stplace_out", "pb_prosthetic_arm_endgame_2ndplace_out", "pb_prosthetic_arm_endgame_3rdplace_out")[topplayerindex];
		}
		case "weapon_chainsaw":
		{
			return array("pb_chainsaw_endgame_1stplace_idle_out", "pb_chainsaw_endgame_1stplace_idle_out", "pb_chainsaw_endgame_1stplace_idle_out")[topplayerindex];
		}
		case "weapon_smg_ppsh":
		{
			return array("pb_smg_ppsh_endgame_1stplace_out", "pb_smg_ppsh_endgame_1stplace_out", "pb_smg_ppsh_endgame_1stplace_out")[topplayerindex];
		}
		case "weapon_knife_ballistic":
		{
			return array("pb_b_knife_endgame_1stplace_out", "pb_b_knife_endgame_1stplace_out", "pb_b_knife_endgame_1stplace_out")[topplayerindex];
		}
	}
	return "";
}

/*
	Name: getidleinanimname
	Namespace: end_game_taunts
	Checksum: 0xC84431FE
	Offset: 0x4CC8
	Size: 0x4AE
	Parameters: 2
	Flags: Linked
*/
function getidleinanimname(charactermodel, topplayerindex)
{
	weapon_group = getweapongroup(charactermodel);
	switch(weapon_group)
	{
		case "weapon_smg":
		{
			return array("pb_smg_endgame_1stplace_in", "pb_smg_endgame_2ndplace_in", "pb_smg_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_assault":
		{
			return array("pb_rifle_endgame_1stplace_in", "pb_rifle_endgame_2ndplace_in", "pb_rifle_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_cqb":
		{
			return array("pb_shotgun_endgame_1stplace_in", "pb_shotgun_endgame_2ndplace_in", "pb_shotgun_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_lmg":
		{
			return array("pb_lmg_endgame_1stplace_in", "pb_lmg_endgame_2ndplace_in", "pb_lmg_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_sniper":
		{
			return array("pb_sniper_endgame_1stplace_in", "pb_sniper_endgame_2ndplace_in", "pb_sniper_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_pistol":
		{
			return array("pb_pistol_endgame_1stplace_in", "pb_pistol_endgame_2ndplace_in", "pb_pistol_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_pistol_dw":
		{
			return array("pb_pistol_dw_endgame_1stplace_in", "pb_pistol_dw_endgame_2ndplace_in", "pb_pistol_dw_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_launcher":
		{
			return array("pb_launcher_endgame_1stplace_in", "pb_launcher_endgame_2ndplace_in", "pb_launcher_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_launcher_alt":
		{
			return array("pb_launcher_alt_endgame_1stplace_in", "pb_launcher_alt_endgame_2ndplace_in", "pb_launcher_alt_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_knife":
		{
			return array("pb_knife_endgame_1stplace_in", "pb_knife_endgame_2ndplace_in", "pb_knife_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_knuckles":
		{
			return array("pb_brass_knuckles_endgame_1stplace_in", "pb_brass_knuckles_endgame_2ndplace_in", "pb_brass_knuckles_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_boxing":
		{
			return array("pb_boxing_gloves_endgame_1stplace_in", "pb_boxing_gloves_endgame_2ndplace_in", "pb_boxing_gloves_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_wrench":
		{
			return array("pb_wrench_endgame_1stplace_in", "pb_wrench_endgame_2ndplace_in", "pb_wrench_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_sword":
		{
			return array("pb_sword_endgame_1stplace_in", "pb_sword_endgame_2ndplace_in", "pb_sword_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_nunchucks":
		{
			return array("pb_nunchucks_endgame_1stplace_in", "pb_nunchucks_endgame_2ndplace_in", "pb_nunchucks_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_mace":
		{
			return array("pb_mace_endgame_1stplace_in", "pb_mace_endgame_2ndplace_in", "pb_mace_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_prosthetic":
		{
			return array("pb_prosthetic_arm_endgame_1stplace_in", "pb_prosthetic_arm_endgame_2ndplace_in", "pb_prosthetic_arm_endgame_3rdplace_in")[topplayerindex];
		}
		case "weapon_chainsaw":
		{
			return array("pb_chainsaw_endgame_1stplace_idle_in", "pb_chainsaw_endgame_1stplace_idle_in", "pb_chainsaw_endgame_1stplace_idle_in")[topplayerindex];
		}
		case "weapon_smg_ppsh":
		{
			return array("pb_smg_ppsh_endgame_1stplace_in", "pb_smg_ppsh_endgame_1stplace_in", "pb_smg_ppsh_endgame_1stplace_in")[topplayerindex];
		}
		case "weapon_knife_ballistic":
		{
			return array("pb_b_knife_endgame_1stplace_in", "pb_b_knife_endgame_1stplace_in", "pb_b_knife_endgame_1stplace_in")[topplayerindex];
		}
	}
	return "";
}

/*
	Name: getweapongroup
	Namespace: end_game_taunts
	Checksum: 0x80F9ED8
	Offset: 0x5180
	Size: 0x69C
	Parameters: 1
	Flags: Linked
*/
function getweapongroup(charactermodel)
{
	if(!isdefined(charactermodel.weapon))
	{
		return "";
	}
	weapon = charactermodel.weapon;
	if(weapon == level.weaponnone && isdefined(charactermodel.showcaseweapon))
	{
		weapon = charactermodel.showcaseweapon;
	}
	weapon_group = getitemgroupforweaponname(weapon.rootweapon.name);
	if(weapon_group == "weapon_launcher")
	{
		if(charactermodel.weapon.rootweapon.name == "launcher_lockonly" || charactermodel.weapon.rootweapon.name == "launcher_multi")
		{
			weapon_group = "weapon_launcher_alt";
		}
		else if(charactermodel.weapon.rootweapon.name == "launcher_ex41")
		{
			weapon_group = "weapon_smg_ppsh";
		}
	}
	else
	{
		if(weapon_group == "weapon_pistol" && weapon.isdualwield)
		{
			weapon_group = "weapon_pistol_dw";
		}
		else
		{
			if(weapon_group == "weapon_smg")
			{
				if(charactermodel.weapon.rootweapon.name == "smg_ppsh")
				{
					weapon_group = "weapon_smg_ppsh";
				}
			}
			else
			{
				if(weapon_group == "weapon_cqb")
				{
					if(charactermodel.weapon.rootweapon.name == "shotgun_olympia")
					{
						weapon_group = "weapon_smg_ppsh";
					}
				}
				else
				{
					if(weapon_group == "weapon_special")
					{
						if(charactermodel.weapon.rootweapon.name == "special_crossbow" || charactermodel.weapon.rootweapon.name == "special_discgun")
						{
							weapon_group = "weapon_smg";
						}
						else
						{
							if(charactermodel.weapon.rootweapon.name == "special_crossbow_dw")
							{
								weapon_group = "weapon_pistol_dw";
							}
							else if(charactermodel.weapon.rootweapon.name == "knife_ballistic")
							{
								weapon_group = "weapon_knife_ballistic";
							}
						}
					}
					else if(weapon_group == "weapon_knife")
					{
						if(charactermodel.weapon.rootweapon.name == "melee_wrench" || charactermodel.weapon.rootweapon.name == "melee_crowbar" || charactermodel.weapon.rootweapon.name == "melee_improvise" || charactermodel.weapon.rootweapon.name == "melee_shockbaton" || charactermodel.weapon.rootweapon.name == "melee_shovel")
						{
							weapon_group = "weapon_wrench";
						}
						else
						{
							if(charactermodel.weapon.rootweapon.name == "melee_knuckles")
							{
								weapon_group = "weapon_knuckles";
							}
							else
							{
								if(charactermodel.weapon.rootweapon.name == "melee_chainsaw" || charactermodel.weapon.rootweapon.name == "melee_boneglass" || charactermodel.weapon.rootweapon.name == "melee_crescent")
								{
									weapon_group = "weapon_chainsaw";
								}
								else
								{
									if(charactermodel.weapon.rootweapon.name == "melee_boxing")
									{
										weapon_group = "weapon_boxing";
									}
									else
									{
										if(charactermodel.weapon.rootweapon.name == "melee_sword" || charactermodel.weapon.rootweapon.name == "melee_katana")
										{
											weapon_group = "weapon_sword";
										}
										else
										{
											if(charactermodel.weapon.rootweapon.name == "melee_nunchuks")
											{
												weapon_group = "weapon_nunchucks";
											}
											else
											{
												if(charactermodel.weapon.rootweapon.name == "melee_bat" || charactermodel.weapon.rootweapon.name == "melee_fireaxe" || charactermodel.weapon.rootweapon.name == "melee_mace")
												{
													weapon_group = "weapon_mace";
												}
												else if(charactermodel.weapon.rootweapon.name == "melee_prosthetic")
												{
													weapon_group = "weapon_prosthetic";
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
	return weapon_group;
}

/*
	Name: stream_epic_models
	Namespace: end_game_taunts
	Checksum: 0xC0B1A3AB
	Offset: 0x5828
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function stream_epic_models()
{
	foreach(model in level.epictauntxmodels)
	{
		forcestreamxmodel(model);
	}
}

/*
	Name: stop_stream_epic_models
	Namespace: end_game_taunts
	Checksum: 0x3B56F213
	Offset: 0x58C0
	Size: 0x8A
	Parameters: 0
	Flags: Linked
*/
function stop_stream_epic_models()
{
	foreach(model in level.epictauntxmodels)
	{
		stopforcestreamingxmodel(model);
	}
}

/*
	Name: playepictauntscene
	Namespace: end_game_taunts
	Checksum: 0x756DBDD1
	Offset: 0x5958
	Size: 0x280
	Parameters: 2
	Flags: Linked
*/
function playepictauntscene(localclientnum, tauntanimname)
{
	scenebundle = struct::get_script_bundle("scene", tauntanimname);
	if(!isdefined(scenebundle))
	{
		return false;
	}
	switch(tauntanimname)
	{
		case "t7_loot_taunt_e_reaper_01":
		{
			self thread setupreaperminigun(localclientnum);
			break;
		}
		case "t7_loot_taunt_e_nomad_03":
		{
			self thread spawngiunit(localclientnum, "gi_unit_victim");
			break;
		}
		case "t7_loot_taunt_e_seraph_04":
		{
			self thread spawnrap(localclientnum, "rap_1");
			self thread spawnrap(localclientnum, "rap_2");
			break;
		}
		case "t7_loot_taunt_e_reaper_main_03":
		{
			self thread spawnhiddenclone(localclientnum, "reaper_l");
			self thread spawnhiddenclone(localclientnum, "reaper_r");
			break;
		}
		case "t7_loot_taunt_e_spectre_03":
		{
			if(getdvarstring("mapname") == "core_frontend")
			{
				self sethighdetail(1, 0);
				self handlecamochange(self.localclientnum, 1);
			}
			else
			{
				self thread gadget_camo_render::forceon(localclientnum);
			}
			self thread spawngiunit(localclientnum, "gi_unit_victim");
			break;
		}
		case "t7_loot_taunt_e_outrider_05":
		{
			self thread spawntalon(localclientnum, "talon_bro_1", 0.65);
			self thread spawntalon(localclientnum, "talon_bro_2", 0.65);
			break;
		}
	}
	self thread scene::play(tauntanimname);
	return true;
}

/*
	Name: stopepictauntscene
	Namespace: end_game_taunts
	Checksum: 0x46049441
	Offset: 0x5BE0
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function stopepictauntscene(localclientnum, tauntanimname)
{
	scenebundle = struct::get_script_bundle("scene", tauntanimname);
	if(!isdefined(scenebundle))
	{
		return;
	}
	switch(tauntanimname)
	{
		case "t7_loot_taunt_e_spectre_03":
		{
			if(getdvarstring("mapname") == "core_frontend")
			{
				self sethighdetail(1, 0);
			}
			break;
		}
	}
	self thread scene::stop(tauntanimname);
}

/*
	Name: addepicscenefunc
	Namespace: end_game_taunts
	Checksum: 0xAF4B0597
	Offset: 0x5CA8
	Size: 0x74
	Parameters: 3
	Flags: None
*/
function addepicscenefunc(tauntanimname, func, state)
{
	scenebundle = struct::get_script_bundle("scene", tauntanimname);
	if(!isdefined(scenebundle))
	{
		return;
	}
	scene::add_scene_func(tauntanimname, func, state);
}

/*
	Name: shutdownepictauntmodels
	Namespace: end_game_taunts
	Checksum: 0x1E3C7E0
	Offset: 0x5D28
	Size: 0xC2
	Parameters: 0
	Flags: Linked
*/
function shutdownepictauntmodels()
{
	if(isdefined(self.epictauntmodels))
	{
		foreach(model in self.epictauntmodels)
		{
			if(isdefined(model))
			{
				model stopsounds();
				model delete();
			}
		}
		self.epictauntmodels = undefined;
	}
}

/*
	Name: hidemodel
	Namespace: end_game_taunts
	Checksum: 0x326600BE
	Offset: 0x5DF8
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function hidemodel(param)
{
	self hide();
}

/*
	Name: showmodel
	Namespace: end_game_taunts
	Checksum: 0x86B4A77F
	Offset: 0x5E28
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function showmodel(param)
{
	self show();
}

/*
	Name: spawncameraglass
	Namespace: end_game_taunts
	Checksum: 0x2F187BE
	Offset: 0x5E58
	Size: 0xB4
	Parameters: 1
	Flags: Linked
*/
function spawncameraglass(param)
{
	if(isdefined(level.cameraglass))
	{
		deletecameraglass(param);
	}
	level.cameraglass = spawn(self.localclientnum, (0, 0, 0), "script_model");
	level.cameraglass setmodel("gfx_p7_zm_asc_data_recorder_glass");
	level.cameraglass setscale(2);
	level.cameraglass thread updateglassposition();
}

/*
	Name: updateglassposition
	Namespace: end_game_taunts
	Checksum: 0x7FCD81E2
	Offset: 0x5F18
	Size: 0xC0
	Parameters: 0
	Flags: Linked
*/
function updateglassposition()
{
	self endon(#"entityshutdown");
	while(true)
	{
		camangles = getcamanglesbylocalclientnum(self.localclientnum);
		campos = getcamposbylocalclientnum(self.localclientnum);
		fwd = anglestoforward(camangles);
		self.origin = campos + (fwd * 60);
		self.angles = camangles + vectorscale((0, 1, 0), 180);
		wait(0.016);
	}
}

/*
	Name: deletecameraglass
	Namespace: end_game_taunts
	Checksum: 0x77DB1C2D
	Offset: 0x5FE0
	Size: 0x3E
	Parameters: 1
	Flags: Linked
*/
function deletecameraglass(param)
{
	if(!isdefined(level.cameraglass))
	{
		return;
	}
	level.cameraglass delete();
	level.cameraglass = undefined;
}

/*
	Name: reaperbulletglass
	Namespace: end_game_taunts
	Checksum: 0x2086F689
	Offset: 0x6028
	Size: 0xE0
	Parameters: 1
	Flags: Linked
*/
function reaperbulletglass(param)
{
	waittillframeend();
	minigun = getweapon("hero_minigun");
	i = 30;
	while(i > -30)
	{
		if(!isdefined(self))
		{
			return;
		}
		self magicglassbullet(self.localclientnum, minigun, randomfloatrange(2, 12), i);
		self playsound(0, "pfx_magic_bullet_glass");
		wait(minigun.firetime);
		i = i - 7;
	}
}

/*
	Name: centerbulletglass
	Namespace: end_game_taunts
	Checksum: 0x52A7EB9D
	Offset: 0x6110
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function centerbulletglass(weaponname)
{
	waittillframeend();
	weapon = getweapon(weaponname);
	if(weapon == level.weaponnone)
	{
		return;
	}
	self magicglassbullet(self.localclientnum, weapon, 4, -2);
	self playsound(0, "pfx_magic_bullet_glass");
}

/*
	Name: talonbulletglassleft
	Namespace: end_game_taunts
	Checksum: 0xB89878CB
	Offset: 0x61A8
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function talonbulletglassleft(param)
{
	self talonbulletglass(-28, -10);
}

/*
	Name: talonbulletglassright
	Namespace: end_game_taunts
	Checksum: 0x2ABC79EE
	Offset: 0x61E0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function talonbulletglassright(param)
{
	self talonbulletglass(10, 28);
}

/*
	Name: talonbulletglass
	Namespace: end_game_taunts
	Checksum: 0x415873A1
	Offset: 0x6218
	Size: 0xEE
	Parameters: 2
	Flags: Linked
*/
function talonbulletglass(yawmin, yawmax)
{
	waittillframeend();
	minigun = getweapon("hero_minigun");
	for(i = 0; i < 15; i++)
	{
		if(!isdefined(self))
		{
			return;
		}
		self magicglassbullet(self.localclientnum, minigun, randomfloatrange(4, 16), randomfloatrange(yawmin, yawmax));
		self playsound(0, "pfx_magic_bullet_glass");
		wait(minigun.firetime);
	}
}

/*
	Name: cloneshaderon
	Namespace: end_game_taunts
	Checksum: 0xBD49F12F
	Offset: 0x6310
	Size: 0x134
	Parameters: 1
	Flags: Linked
*/
function cloneshaderon(param)
{
	if(getdvarstring("mapname") == "core_frontend")
	{
		self sethighdetail(1, 0);
	}
	localplayerteam = getlocalplayerteam(self.localclientnum);
	topplayerteam = gettopplayersteam(self.localclientnum, 0);
	friendly = localplayerteam === topplayerteam;
	if(friendly)
	{
		self duplicate_render::update_dr_flag(self.localclientnum, "clone_ally_on", 1);
	}
	else
	{
		self duplicate_render::update_dr_flag(self.localclientnum, "clone_enemy_on", 1);
	}
	self thread gadget_clone_render::transition_shader(self.localclientnum);
}

/*
	Name: cloneshaderoff
	Namespace: end_game_taunts
	Checksum: 0x564291C7
	Offset: 0x6450
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function cloneshaderoff(param)
{
	self duplicate_render::update_dr_flag(self.localclientnum, "clone_ally_on", 0);
	self duplicate_render::update_dr_flag(self.localclientnum, "clone_enemy_on", 0);
}

/*
	Name: handlecamochange
	Namespace: end_game_taunts
	Checksum: 0x36E8F8C2
	Offset: 0x64B8
	Size: 0x13C
	Parameters: 2
	Flags: Linked
*/
function handlecamochange(localclientnum, camo_on)
{
	flags_changed = self duplicate_render::set_dr_flag("gadget_camo_friend", 0);
	flags_changed = flags_changed && self duplicate_render::set_dr_flag("gadget_camo_flicker", 0);
	flags_changed = flags_changed && self duplicate_render::set_dr_flag("gadget_camo_break", 0);
	flags_changed = flags_changed && self duplicate_render::set_dr_flag("gadget_camo_reveal", 0);
	flags_changed = flags_changed && self duplicate_render::set_dr_flag("gadget_camo_on", 0);
	if(flags_changed)
	{
		self duplicate_render::update_dr_filters();
	}
	if(camo_on)
	{
		self thread gadget_camo_render::forceon(localclientnum);
	}
	else
	{
		self thread gadget_camo_render::doreveal(self.localclientnum, 0);
	}
}

/*
	Name: camoshaderon
	Namespace: end_game_taunts
	Checksum: 0xEB61CCF2
	Offset: 0x6600
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function camoshaderon(param)
{
	if(getdvarstring("mapname") == "core_frontend")
	{
		self handlecamochange(self.localclientnum, 1);
	}
	else
	{
		self thread gadget_camo_render::doreveal(self.localclientnum, 1);
	}
}

/*
	Name: camoshaderoff
	Namespace: end_game_taunts
	Checksum: 0x702FDFCE
	Offset: 0x6688
	Size: 0x6C
	Parameters: 1
	Flags: Linked
*/
function camoshaderoff(param)
{
	if(getdvarstring("mapname") == "core_frontend")
	{
		self handlecamochange(self.localclientnum, 0);
	}
	else
	{
		self thread gadget_camo_render::doreveal(self.localclientnum, 0);
	}
}

/*
	Name: fireweapon
	Namespace: end_game_taunts
	Checksum: 0x89D96E8
	Offset: 0x6700
	Size: 0x90
	Parameters: 1
	Flags: Linked
*/
function fireweapon(weaponname)
{
	if(!isdefined(weaponname))
	{
		return;
	}
	self endon(#"stopfireweapon");
	weapon = getweapon(weaponname);
	waittillframeend();
	while(1 && isdefined(self))
	{
		self magicbullet(weapon, (0, 0, 0), (0, 0, 0));
		wait(weapon.firetime);
	}
}

/*
	Name: stopfireweapon
	Namespace: end_game_taunts
	Checksum: 0x7E3B1268
	Offset: 0x6798
	Size: 0x1A
	Parameters: 1
	Flags: Linked
*/
function stopfireweapon(param)
{
	self notify(#"stopfireweapon");
}

/*
	Name: firebeam
	Namespace: end_game_taunts
	Checksum: 0x4E6681C8
	Offset: 0x67C0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function firebeam(beam)
{
	if(isdefined(self.beamfx))
	{
		return;
	}
	self.beamfx = beamlaunch(self.localclientnum, self, "tag_flash", undefined, "none", beam);
}

/*
	Name: stopfirebeam
	Namespace: end_game_taunts
	Checksum: 0xB0A7AA00
	Offset: 0x6818
	Size: 0x46
	Parameters: 1
	Flags: Linked
*/
function stopfirebeam(param)
{
	if(!isdefined(self.beamfx))
	{
		return;
	}
	beamkill(self.localclientnum, self.beamfx);
	self.beamfx = undefined;
}

/*
	Name: playwinnerteamfx
	Namespace: end_game_taunts
	Checksum: 0xDD69D537
	Offset: 0x6868
	Size: 0xBC
	Parameters: 1
	Flags: Linked
*/
function playwinnerteamfx(fxname)
{
	waittillframeend();
	topplayerteam = gettopplayersteam(self.localclientnum, 0);
	if(!isdefined(topplayerteam))
	{
		topplayerteam = getlocalplayerteam(self.localclientnum);
	}
	fxhandle = playfxontag(self.localclientnum, fxname, self, "tag_origin");
	if(isdefined(fxhandle))
	{
		setfxteam(self.localclientnum, fxhandle, topplayerteam);
	}
}

/*
	Name: playlocalteamfx
	Namespace: end_game_taunts
	Checksum: 0x98DD951A
	Offset: 0x6930
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function playlocalteamfx(fxname)
{
	waittillframeend();
	localplayerteam = getlocalplayerteam(self.localclientnum);
	fxhandle = playfxontag(self.localclientnum, fxname, self, "tag_origin");
	if(isdefined(fxhandle))
	{
		setfxteam(self.localclientnum, fxhandle, localplayerteam);
	}
}

/*
	Name: magicglassbullet
	Namespace: end_game_taunts
	Checksum: 0xBC5CD021
	Offset: 0x69C8
	Size: 0xAC
	Parameters: 4
	Flags: Linked
*/
function magicglassbullet(localclientnum, weapon, pitchangle, yawangle)
{
	campos = getcamposbylocalclientnum(localclientnum);
	camangles = getcamanglesbylocalclientnum(localclientnum);
	bulletangles = camangles + (pitchangle, yawangle, 0);
	self magicbullet(weapon, campos, bulletangles);
}

/*
	Name: launchprojectile
	Namespace: end_game_taunts
	Checksum: 0xE1888072
	Offset: 0x6A80
	Size: 0xF4
	Parameters: 3
	Flags: None
*/
function launchprojectile(localclientnum, projectilemodel, projectiletrail)
{
	launchorigin = self gettagorigin("tag_flash");
	if(!isdefined(launchorigin))
	{
		return;
	}
	launchangles = self gettagangles("tag_flash");
	launchdir = anglestoforward(launchangles);
	createdynentandlaunch(localclientnum, projectilemodel, launchorigin, (0, 0, 0), launchorigin, launchdir * getdvarfloat("launchspeed", 3.5), projectiletrail);
}

/*
	Name: setupreaperminigun
	Namespace: end_game_taunts
	Checksum: 0x3C938B09
	Offset: 0x6B80
	Size: 0x1B2
	Parameters: 1
	Flags: Linked
*/
function setupreaperminigun(localclientnum)
{
	model = spawn(localclientnum, self.origin, "script_model");
	model.angles = self.angles;
	model.targetname = "scythe_prop";
	model sethighdetail(1);
	scythemodel = "wpn_t7_hero_reaper_minigun_prop";
	if(isdefined(self.bodymodel))
	{
		if(strstartswith(self.bodymodel, "c_t7_mp_reaper_mpc_body3"))
		{
			scythemodel = "wpn_t7_loot_hero_reaper3_minigun_prop";
		}
	}
	model setmodel(scythemodel);
	model setbodyrenderoptions(self.moderenderoptions, self.bodyrenderoptions, self.helmetrenderoptions, self.helmetrenderoptions);
	self hidepart(localclientnum, "tag_minigun_flaps");
	if(!isdefined(self.epictauntmodels))
	{
		self.epictauntmodels = [];
	}
	else if(!isarray(self.epictauntmodels))
	{
		self.epictauntmodels = array(self.epictauntmodels);
	}
	self.epictauntmodels[self.epictauntmodels.size] = model;
}

/*
	Name: spawnhiddenclone
	Namespace: end_game_taunts
	Checksum: 0x9774556B
	Offset: 0x6D40
	Size: 0x13A
	Parameters: 2
	Flags: Linked
*/
function spawnhiddenclone(localclientnum, targetname)
{
	clone = self spawnplayermodel(localclientnum, targetname, self.origin, self.angles, self.bodymodel, self.helmetmodel, self.moderenderoptions, self.bodyrenderoptions, self.helmetrenderoptions);
	clone setscale(0);
	wait(0.016);
	clone hide();
	clone setscale(1);
	if(!isdefined(self.epictauntmodels))
	{
		self.epictauntmodels = [];
	}
	else if(!isarray(self.epictauntmodels))
	{
		self.epictauntmodels = array(self.epictauntmodels);
	}
	self.epictauntmodels[self.epictauntmodels.size] = clone;
}

/*
	Name: spawntopplayermodel
	Namespace: end_game_taunts
	Checksum: 0xCB6CFAD
	Offset: 0x6E88
	Size: 0x12A
	Parameters: 5
	Flags: None
*/
function spawntopplayermodel(localclientnum, targetname, origin, angles, topplayerindex)
{
	bodymodel = gettopplayersbodymodel(localclientnum, topplayerindex);
	helmetmodel = gettopplayershelmetmodel(localclientnum, topplayerindex);
	moderenderoptions = getcharactermoderenderoptions(currentsessionmode());
	bodyrenderoptions = gettopplayersbodyrenderoptions(localclientnum, topplayerindex);
	helmetrenderoptions = gettopplayershelmetrenderoptions(localclientnum, topplayerindex);
	return spawnplayermodel(localclientnum, targetname, origin, angles, bodymodel, helmetmodel, moderenderoptions, bodyrenderoptions, helmetrenderoptions);
}

/*
	Name: spawnplayermodel
	Namespace: end_game_taunts
	Checksum: 0x271FD9D1
	Offset: 0x6FC0
	Size: 0x158
	Parameters: 9
	Flags: Linked
*/
function spawnplayermodel(localclientnum, targetname, origin, angles, bodymodel, helmetmodel, moderenderoptions, bodyrenderoptions, helmetrenderoptions)
{
	model = spawn(localclientnum, origin, "script_model");
	model.angles = angles;
	model.targetname = targetname;
	model sethighdetail(1);
	model setmodel(bodymodel);
	model attach(helmetmodel, "");
	model setbodyrenderoptions(moderenderoptions, bodyrenderoptions, helmetrenderoptions, helmetrenderoptions);
	model hide();
	model useanimtree($all_player);
	return model;
}

/*
	Name: spawngiunit
	Namespace: end_game_taunts
	Checksum: 0xAEAFA648
	Offset: 0x7120
	Size: 0x142
	Parameters: 2
	Flags: Linked
*/
function spawngiunit(localclientnum, targetname)
{
	model = spawn(localclientnum, self.origin, "script_model");
	model.angles = self.angles;
	model.targetname = targetname;
	model sethighdetail(1);
	model setmodel("c_zsf_robot_grunt_body");
	model attach("c_zsf_robot_grunt_head", "");
	if(!isdefined(self.epictauntmodels))
	{
		self.epictauntmodels = [];
	}
	else if(!isarray(self.epictauntmodels))
	{
		self.epictauntmodels = array(self.epictauntmodels);
	}
	self.epictauntmodels[self.epictauntmodels.size] = model;
}

/*
	Name: spawnrap
	Namespace: end_game_taunts
	Checksum: 0xBC048767
	Offset: 0x7270
	Size: 0x1BA
	Parameters: 2
	Flags: Linked
*/
function spawnrap(localclientnum, targetname)
{
	model = spawn(localclientnum, self.origin, "script_model");
	model.angles = self.angles;
	model.targetname = targetname;
	localplayerteam = getlocalplayerteam(self.localclientnum);
	topplayerteam = gettopplayersteam(localclientnum, 0);
	if(!isdefined(topplayerteam) || localplayerteam == topplayerteam)
	{
		model setmodel("veh_t7_drone_raps_mp_lite");
		fxteam = localplayerteam;
	}
	else
	{
		model setmodel("veh_t7_drone_raps_mp_dark");
		fxteam = topplayerteam;
	}
	model util::waittill_dobj(localclientnum);
	if(!isdefined(self.epictauntmodels))
	{
		self.epictauntmodels = [];
	}
	else if(!isarray(self.epictauntmodels))
	{
		self.epictauntmodels = array(self.epictauntmodels);
	}
	self.epictauntmodels[self.epictauntmodels.size] = model;
}

/*
	Name: spawntalon
	Namespace: end_game_taunts
	Checksum: 0x7664F7D
	Offset: 0x7438
	Size: 0x242
	Parameters: 3
	Flags: Linked
*/
function spawntalon(localclientnum, targetname, scale = 1)
{
	model = spawn(localclientnum, self.origin, "script_model");
	model.angles = self.angles;
	model.targetname = targetname;
	localplayerteam = getlocalplayerteam(self.localclientnum);
	topplayerteam = gettopplayersteam(localclientnum, 0);
	if(!isdefined(topplayerteam) || localplayerteam == topplayerteam)
	{
		model setmodel("veh_t7_drone_attack_gun_litecolor");
		fxteam = localplayerteam;
	}
	else
	{
		model setmodel("veh_t7_drone_attack_gun_darkcolor");
		fxteam = topplayerteam;
	}
	model setscale(scale);
	model util::waittill_dobj(localclientnum);
	fxhandle = playfxontag(localclientnum, "player/fx_loot_taunt_outrider_talon_lights", model, "tag_body");
	setfxteam(localclientnum, fxhandle, fxteam);
	if(!isdefined(self.epictauntmodels))
	{
		self.epictauntmodels = [];
	}
	else if(!isarray(self.epictauntmodels))
	{
		self.epictauntmodels = array(self.epictauntmodels);
	}
	self.epictauntmodels[self.epictauntmodels.size] = model;
}

