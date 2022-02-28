// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\core\_multi_extracam;
#using scripts\mp\_devgui;
#using scripts\shared\_character_customization;
#using scripts\shared\_weapon_customization_icon;
#using scripts\shared\ai\archetype_damage_effects;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\zombie;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\custom_class;
#using scripts\shared\end_game_taunts;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\music_shared;
#using scripts\shared\player_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#using_animtree("generic");

class cmegachewfactory 
{
	var m_b_power_boost;
	var m_n_doubler_count;
	var m_n_tokens_spent;
	var m_a_vat_contents;
	var m_mdl_tube_front;
	var m_a_mdl_balls;
	var m_a_str_megachew_factory_result_flags;
	var m_a_mdl_doors;
	var m_b_doors_open;
	var m_a_str_megachew_factory_door_flags;
	var m_a_mdl_domes;
	var m_a_mdl_bodies;
	var m_a_o_megachewcarousels;
	var m_a_mdl_gearbox;
	var m_a_mdl_gear;
	var m_a_o_megachewvat;
	var m_a_o_megachewvatdialset;
	var m_n_result_ball_count;
	var m_a_uimodel_megachew;
	var m_o_megachewcounter;
	var m_o_megachewbuttons;
	var m_uimodel_instructions;
	var m_n_tokens_remaining;

	/*
		Name: constructor
		Namespace: cmegachewfactory
		Checksum: 0x99EC1590
		Offset: 0x9AE8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: cmegachewfactory
		Checksum: 0x99EC1590
		Offset: 0x9AF8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: get_megachew_factory_results
		Namespace: cmegachewfactory
		Checksum: 0x65B8514D
		Offset: 0x99E8
		Size: 0xF6
		Parameters: 0
		Flags: Linked
	*/
	function get_megachew_factory_results()
	{
		m_b_power_boost = 0;
		m_n_doubler_count = 0;
		n_nonawardable_powerup_count = 0;
		for(i = 0; i < 3; i++)
		{
			if(m_n_tokens_spent < (i + 1) && !m_b_power_boost)
			{
				break;
			}
			if("POWER_BOOST" == m_a_vat_contents[i])
			{
				m_b_power_boost = 1;
				n_nonawardable_powerup_count = n_nonawardable_powerup_count + 1;
			}
			if("DOUBLE_UP" == m_a_vat_contents[i])
			{
				m_n_doubler_count = m_n_doubler_count + 1;
				n_nonawardable_powerup_count = n_nonawardable_powerup_count + 1;
			}
		}
	}

	/*
		Name: set_megachew_result_anim_state
		Namespace: cmegachewfactory
		Checksum: 0x2E55EB3B
		Offset: 0x96F0
		Size: 0x2EC
		Parameters: 3
		Flags: Linked
	*/
	function set_megachew_result_anim_state(localclientnum, n_ball_index, n_anim_state)
	{
		level flag::clear(("megachew_factory_result_" + n_ball_index) + "_anim_done");
		str_ball_drop_anim = ("p7_fxanim_zm_bgb_tube_ball_" + n_ball_index) + "_drop_anim";
		str_ball_idle_anim = ("p7_fxanim_zm_bgb_tube_ball_" + n_ball_index) + "_idle_anim";
		str_ball_flush_anim = ("p7_fxanim_zm_bgb_tube_ball_" + n_ball_index) + "_flush_anim";
		str_tube_front_drop_anim = "p7_fxanim_zm_bgb_tube_front_drop_anim";
		str_tube_front_flush_anim = "p7_fxanim_zm_bgb_tube_front_flush_anim";
		m_mdl_tube_front util::waittill_dobj(localclientnum);
		m_mdl_tube_front clearanim(str_tube_front_drop_anim, 0);
		m_mdl_tube_front clearanim(str_tube_front_flush_anim, 0);
		mdl_ball = m_a_mdl_balls[n_ball_index];
		mdl_ball util::waittill_dobj(localclientnum);
		mdl_ball clearanim(str_ball_drop_anim, 0);
		mdl_ball clearanim(str_ball_idle_anim, 0);
		mdl_ball clearanim(str_ball_flush_anim, 0);
		switch(n_anim_state)
		{
			case 0:
			{
				m_mdl_tube_front thread animation::play(str_tube_front_drop_anim, undefined, undefined, 1);
				mdl_ball animation::play(str_ball_drop_anim, undefined, undefined, 1);
				break;
			}
			case 1:
			{
				mdl_ball animation::play(str_ball_idle_anim, undefined, undefined, 1);
				break;
			}
			case 2:
			{
				m_mdl_tube_front thread animation::play(str_tube_front_flush_anim, undefined, undefined, 1);
				mdl_ball animation::play(str_ball_flush_anim, undefined, undefined, 1);
				break;
			}
		}
		level flag::set(("megachew_factory_result_" + n_ball_index) + "_anim_done");
	}

	/*
		Name: set_megachew_results_anim_state
		Namespace: cmegachewfactory
		Checksum: 0x3C41A873
		Offset: 0x9668
		Size: 0x7C
		Parameters: 2
		Flags: Linked
	*/
	function set_megachew_results_anim_state(localclientnum, n_anim_state)
	{
		for(i = 0; i < 6; i++)
		{
			self thread set_megachew_result_anim_state(localclientnum, i, n_anim_state);
		}
		level flag::wait_till_all(m_a_str_megachew_factory_result_flags);
	}

	/*
		Name: set_megachew_factory_door_anim_state
		Namespace: cmegachewfactory
		Checksum: 0x2D0FA8A
		Offset: 0x94D8
		Size: 0x184
		Parameters: 2
		Flags: Linked
	*/
	function set_megachew_factory_door_anim_state(localclientnum, n_door_index)
	{
		level flag::clear(("megachew_factory_door_" + n_door_index) + "_anim_done");
		mdl_door = m_a_mdl_doors[n_door_index - 1];
		mdl_door util::waittill_dobj(localclientnum);
		if(m_b_doors_open)
		{
			exploder::exploder("zm_gumball_inside_" + n_door_index);
			mdl_door clearanim("p7_fxanim_zm_bgb_door_close_anim", 0);
			mdl_door animation::play("p7_fxanim_zm_bgb_door_open_anim", undefined, undefined, 1);
		}
		else
		{
			exploder::stop_exploder("zm_gumball_inside_" + n_door_index);
			mdl_door clearanim("p7_fxanim_zm_bgb_door_open_anim", 0);
			mdl_door animation::play("p7_fxanim_zm_bgb_door_close_anim", undefined, undefined, 1);
		}
		level flag::set(("megachew_factory_door_" + n_door_index) + "_anim_done");
	}

	/*
		Name: set_megachew_factory_doors_anim_state
		Namespace: cmegachewfactory
		Checksum: 0x6545928B
		Offset: 0x9418
		Size: 0xB2
		Parameters: 2
		Flags: Linked
	*/
	function set_megachew_factory_doors_anim_state(localclientnum, b_open)
	{
		if(m_b_doors_open === b_open)
		{
			return;
		}
		m_b_doors_open = b_open;
		for(i = 1; i <= 3; i++)
		{
			self thread set_megachew_factory_door_anim_state(localclientnum, i);
		}
		level flag::wait_till_all(m_a_str_megachew_factory_door_flags);
		if(!m_b_doors_open)
		{
			level notify(#"megachew_factory_doors_closed");
		}
	}

	/*
		Name: set_megachew_factory_label_light_state
		Namespace: cmegachewfactory
		Checksum: 0x450BB8D4
		Offset: 0x9338
		Size: 0xD6
		Parameters: 3
		Flags: Linked
	*/
	function set_megachew_factory_label_light_state(localclientnum, n_vat_index, n_label_light_state)
	{
		switch(n_label_light_state)
		{
			case 0:
			{
				exploder::stop_exploder("zm_gumball_sign_m_" + n_vat_index);
				exploder::stop_exploder("zm_gumball_sign_b_" + n_vat_index);
				break;
			}
			case 1:
			{
				exploder::exploder("zm_gumball_sign_m_" + n_vat_index);
				break;
			}
			case 2:
			{
				exploder::exploder("zm_gumball_sign_b_" + n_vat_index);
				break;
			}
		}
	}

	/*
		Name: set_megachew_factory_dome_anim_state
		Namespace: cmegachewfactory
		Checksum: 0x9DB0D006
		Offset: 0x8DF8
		Size: 0x536
		Parameters: 3
		Flags: Linked
	*/
	function set_megachew_factory_dome_anim_state(localclientnum, n_dome_index, n_anim_state)
	{
		str_dome_ambient_anim = ("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_idle_anim";
		if(vat_is_powered(n_dome_index - 1))
		{
			str_dome_active_anim = ("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_active_powered_anim";
			str_dome_end_anim = ("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_end_powered_anim";
			str_body_active_anim = "p7_fxanim_zm_bgb_body_active_powered_anim";
			str_body_end_anim = "p7_fxanim_zm_bgb_body_end_powered_anim";
		}
		else
		{
			str_dome_active_anim = ("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_active_unpowered_anim";
			str_dome_end_anim = ("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_end_unpowered_anim";
			str_body_active_anim = "p7_fxanim_zm_bgb_body_active_unpowered_anim";
			str_body_end_anim = "p7_fxanim_zm_bgb_body_end_unpowered_anim";
		}
		str_dome_turn_anim = ("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_turn_anim";
		str_dome_turn_select_anim = ("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_turn_select_anim";
		str_dome_reverse_anim = ("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_turn_reverse_anim";
		mdl_dome = m_a_mdl_domes[n_dome_index - 1];
		mdl_body = m_a_mdl_bodies[n_dome_index - 1];
		mdl_dome util::waittill_dobj(localclientnum);
		mdl_dome clearanim(str_dome_ambient_anim, 0);
		mdl_dome clearanim(("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_active_powered_anim", 0);
		mdl_dome clearanim(("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_active_unpowered_anim", 0);
		mdl_dome clearanim(("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_end_powered_anim", 0);
		mdl_dome clearanim(("p7_fxanim_zm_bgb_dome_0" + n_dome_index) + "_end_unpowered_anim", 0);
		mdl_dome clearanim(str_dome_turn_anim, 0);
		mdl_dome clearanim(str_dome_turn_select_anim, 0);
		mdl_dome clearanim(str_dome_reverse_anim, 0);
		n_anim_loop_speed_offset = 0.1;
		n_anim_loop_speed = 1 + ((n_dome_index - 1) * n_anim_loop_speed_offset);
		switch(n_anim_state)
		{
			case 0:
			{
				mdl_dome animation::play(str_dome_ambient_anim, undefined, undefined, 1);
				break;
			}
			case 1:
			{
				mdl_body thread animation::play(str_body_active_anim, undefined, undefined, n_anim_loop_speed);
				mdl_dome animation::play(str_dome_active_anim, undefined, undefined, n_anim_loop_speed);
				break;
			}
			case 2:
			{
				mdl_body thread animation::play(str_body_end_anim, undefined, undefined, 1);
				mdl_dome animation::play(str_dome_end_anim, undefined, undefined, 1);
				break;
			}
			case 3:
			{
				mdl_dome animation::play(str_dome_turn_anim, undefined, undefined, 1);
				break;
			}
			case 4:
			{
				exploder::exploder("zm_gumball_pipe_" + n_dome_index);
				mdl_dome animation::play(str_dome_turn_select_anim, undefined, undefined, 1);
				exploder::stop_exploder("zm_gumball_pipe_" + n_dome_index);
				break;
			}
			case 5:
			{
				mdl_dome animation::play(str_dome_reverse_anim, undefined, undefined, 1);
				level notify(#"megachew_dome_finished_reverse_anim");
				break;
			}
		}
	}

	/*
		Name: swap_spinning_carousel_gumball_on_notify
		Namespace: cmegachewfactory
		Checksum: 0xEEF439EC
		Offset: 0x8C88
		Size: 0x164
		Parameters: 3
		Flags: Linked
	*/
	function swap_spinning_carousel_gumball_on_notify(localclientnum, n_vat_index, n_ball_index)
	{
		self notify((("swap_spinning_carousel_gumball_on_notify_" + n_vat_index) + "_") + n_ball_index);
		self endon((("swap_spinning_carousel_gumball_on_notify_" + n_vat_index) + "_") + n_ball_index);
		self endon(#"megachew_factory_doors_closed");
		mdl_carousel = getent(localclientnum, "gumball_carousel_0" + (n_vat_index + 1), "targetname");
		while(true)
		{
			if(level flag::get("megachew_carousel_show_result") && n_ball_index == 0)
			{
				str_model = get_result_model_name_for_vat_contents(n_vat_index, 1);
			}
			else
			{
				str_model = get_random_model_name_to_attach_to_carousel();
			}
			[[ m_a_o_megachewcarousels[n_vat_index] ]]->update_model_on_carousel_tag(n_ball_index, str_model);
			mdl_carousel waittillmatch(#"_anim_notify_");
		}
	}

	/*
		Name: show_random_starting_gumballs_on_carousel
		Namespace: cmegachewfactory
		Checksum: 0xA73E5586
		Offset: 0x8C20
		Size: 0x5E
		Parameters: 2
		Flags: Linked
	*/
	function show_random_starting_gumballs_on_carousel(localclientnum, n_vat_index)
	{
		for(n_ball_index = 0; n_ball_index < 4; n_ball_index++)
		{
			self thread swap_spinning_carousel_gumball_on_notify(localclientnum, n_vat_index, n_ball_index);
		}
	}

	/*
		Name: show_random_starting_gumballs_on_carousels
		Namespace: cmegachewfactory
		Checksum: 0xDEC6D0EA
		Offset: 0x8BC8
		Size: 0x4E
		Parameters: 1
		Flags: Linked
	*/
	function show_random_starting_gumballs_on_carousels(localclientnum)
	{
		for(n_vat_index = 0; n_vat_index < 3; n_vat_index++)
		{
			self thread show_random_starting_gumballs_on_carousel(localclientnum, n_vat_index);
		}
	}

	/*
		Name: set_megachew_factory_carousel_anim_state
		Namespace: cmegachewfactory
		Checksum: 0x1D2D4BE6
		Offset: 0x8B48
		Size: 0x74
		Parameters: 3
		Flags: Linked
	*/
	function set_megachew_factory_carousel_anim_state(localclientnum, n_carousel_index, n_anim_state)
	{
		b_vat_is_powered = vat_is_powered(n_carousel_index - 1);
		[[ m_a_o_megachewcarousels[n_carousel_index - 1] ]]->set_carousel_anim_state(localclientnum, n_anim_state, b_vat_is_powered);
	}

	/*
		Name: play_powerup_activation_fx
		Namespace: cmegachewfactory
		Checksum: 0x9617A011
		Offset: 0x89D0
		Size: 0x170
		Parameters: 1
		Flags: Linked
	*/
	function play_powerup_activation_fx(localclientnum)
	{
		for(i = 0; i < 3; i++)
		{
			if(!vat_is_powered(i))
			{
				continue;
			}
			if(m_a_vat_contents[i] === "POWER_BOOST")
			{
				thread [[ m_a_o_megachewcarousels[i] ]]->play_carousel_effect(localclientnum, level._effect["ui/fx_megachew_ball_power_boost"], "tag_ball_0", 0.5);
				continue;
			}
			if(m_a_vat_contents[i] === "DOUBLE_UP")
			{
				thread [[ m_a_o_megachewcarousels[i] ]]->play_carousel_effect(localclientnum, level._effect["ui/fx_megachew_ball_double"], "tag_ball_0", 0.5);
				continue;
			}
			if(m_a_vat_contents[i] === "FREE_VIAL")
			{
				thread [[ m_a_o_megachewcarousels[i] ]]->play_carousel_effect(localclientnum, level._effect["ui/fx_megachew_ball_divinium"], "tag_ball_0", 0.5);
			}
		}
		wait(0.5);
	}

	/*
		Name: play_gumball_light_exploder
		Namespace: cmegachewfactory
		Checksum: 0xEB941250
		Offset: 0x88F0
		Size: 0xD4
		Parameters: 2
		Flags: Linked
	*/
	function play_gumball_light_exploder(n_vat_index, str_bgb_limit_type)
	{
		switch(str_bgb_limit_type)
		{
			case "activated":
			{
				str_exploder_name = "zm_gumball_purple_machine_";
				break;
			}
			case "event":
			{
				str_exploder_name = "zm_gumball_orange_machine_";
				break;
			}
			case "round":
			{
				str_exploder_name = "zm_gumball_blue_machine_";
				break;
			}
			case "time":
			{
				str_exploder_name = "zm_gumball_green_machine_";
				break;
			}
		}
		exploder::exploder(str_exploder_name + n_vat_index);
		level waittill(#"megachew_factory_doors_closed");
		exploder::stop_exploder(str_exploder_name + n_vat_index);
	}

	/*
		Name: play_gumball_vanishing_fx
		Namespace: cmegachewfactory
		Checksum: 0x5210CD90
		Offset: 0x8560
		Size: 0x386
		Parameters: 1
		Flags: Linked
	*/
	function play_gumball_vanishing_fx(localclientnum)
	{
		for(i = 0; i < 3; i++)
		{
			b_vat_should_launch_result = vat_should_launch_result(i);
			if(b_vat_should_launch_result)
			{
				if(m_a_vat_contents[i] === "FREE_VIAL")
				{
					self thread play_gumball_light_exploder(i + 1, "round");
					thread [[ m_a_o_megachewcarousels[i] ]]->play_carousel_effect(localclientnum, level._effect["ui/fx_megachew_ball_power_boost"], "tag_ball_0", 1);
				}
				else
				{
					str_bgb_limit_type = tablelookup("gamedata/stats/zm/zm_statstable.csv", 4, m_a_vat_contents[i], 20);
					self thread play_gumball_light_exploder(i + 1, str_bgb_limit_type);
					switch(str_bgb_limit_type)
					{
						case "activated":
						{
							thread [[ m_a_o_megachewcarousels[i] ]]->play_carousel_effect(localclientnum, level._effect["megachew_gumball_poof_purple"]);
							break;
						}
						case "event":
						{
							thread [[ m_a_o_megachewcarousels[i] ]]->play_carousel_effect(localclientnum, level._effect["megachew_gumball_poof_orange"]);
							break;
						}
						case "round":
						{
							thread [[ m_a_o_megachewcarousels[i] ]]->play_carousel_effect(localclientnum, level._effect["megachew_gumball_poof_blue"]);
							break;
						}
						case "time":
						{
							thread [[ m_a_o_megachewcarousels[i] ]]->play_carousel_effect(localclientnum, level._effect["megachew_gumball_poof_green"]);
							break;
						}
					}
				}
				[[ m_a_o_megachewcarousels[i] ]]->detach_all_models_from_carousel();
				continue;
			}
			if(vat_is_powered(i))
			{
				if(m_a_vat_contents[i] === "POWER_BOOST")
				{
					self thread play_gumball_light_exploder(i + 1, "round");
					thread [[ m_a_o_megachewcarousels[i] ]]->play_carousel_effect(localclientnum, level._effect["ui/fx_megachew_ball_divinium"], "tag_ball_0", 1);
				}
				else if(m_a_vat_contents[i] === "DOUBLE_UP")
				{
					self thread play_gumball_light_exploder(i + 1, "round");
					thread [[ m_a_o_megachewcarousels[i] ]]->play_carousel_effect(localclientnum, level._effect["ui/fx_megachew_ball_double"], "tag_ball_0", 1);
				}
				[[ m_a_o_megachewcarousels[i] ]]->detach_all_models_from_carousel();
			}
		}
	}

	/*
		Name: wind_down_gear_to_idle
		Namespace: cmegachewfactory
		Checksum: 0x8AD2A53E
		Offset: 0x84B0
		Size: 0xA4
		Parameters: 4
		Flags: Linked
	*/
	function wind_down_gear_to_idle(mdl_model, str_prev_anim, str_end_anim, str_idle_anim)
	{
		mdl_model clearanim(str_prev_anim, 0.1);
		mdl_model animation::play(str_end_anim, undefined, undefined, 1, 0.1);
		mdl_model thread animation::play(str_idle_anim, undefined, undefined, 1, 0.1);
	}

	/*
		Name: set_megachew_factory_gears_anim_state
		Namespace: cmegachewfactory
		Checksum: 0xA24CA18F
		Offset: 0x80E8
		Size: 0x3BA
		Parameters: 2
		Flags: Linked
	*/
	function set_megachew_factory_gears_anim_state(localclientnum, n_gears_state)
	{
		switch(n_gears_state)
		{
			case 0:
			{
				str_gearbox_anim = "p7_fxanim_zm_bgb_gears_idle_anim";
				str_gear_anim = "p7_fxanim_zm_bgb_gear_01_idle_anim";
				str_gearbox_prev_anim = "p7_fxanim_zm_bgb_gears_end_anim";
				str_gear_prev_anim = "p7_fxanim_zm_bgb_gear_01_end_anim";
				break;
			}
			case 1:
			{
				str_gearbox_anim = "p7_fxanim_zm_bgb_gears_active_anim";
				str_gear_anim = "p7_fxanim_zm_bgb_gear_01_active_anim";
				str_gearbox_prev_anim = "p7_fxanim_zm_bgb_gears_idle_anim";
				str_gear_prev_anim = "p7_fxanim_zm_bgb_gear_01_idle_anim";
				break;
			}
			case 2:
			{
				str_gearbox_anim = "p7_fxanim_zm_bgb_gears_end_anim";
				str_gear_anim = "p7_fxanim_zm_bgb_gear_01_end_anim";
				str_gearbox_prev_anim = "p7_fxanim_zm_bgb_gears_active_anim";
				str_gear_prev_anim = "p7_fxanim_zm_bgb_gear_01_active_anim";
				break;
			}
		}
		if(n_gears_state === 2)
		{
			foreach(mdl_gearbox in m_a_mdl_gearbox)
			{
				self thread wind_down_gear_to_idle(mdl_gearbox, str_gearbox_prev_anim, "p7_fxanim_zm_bgb_gears_end_anim", "p7_fxanim_zm_bgb_gears_idle_anim");
			}
			foreach(mdl_gear in m_a_mdl_gear)
			{
				self thread wind_down_gear_to_idle(mdl_gear, str_gearbox_prev_anim, "p7_fxanim_zm_bgb_gear_01_end_anim", "p7_fxanim_zm_bgb_gear_01_idle_anim");
			}
		}
		else
		{
			foreach(mdl_gearbox in m_a_mdl_gearbox)
			{
				mdl_gearbox clearanim(str_gearbox_prev_anim, 0.1);
				mdl_gearbox thread animation::play(str_gearbox_anim, undefined, undefined, 1, 0.1);
			}
			foreach(mdl_gear in m_a_mdl_gear)
			{
				mdl_gear clearanim(str_gear_prev_anim, 0.1);
				mdl_gear thread animation::play(str_gear_anim, undefined, undefined, 1, 0.1);
			}
		}
	}

	/*
		Name: set_megachew_factory_anim_state
		Namespace: cmegachewfactory
		Checksum: 0xA3470965
		Offset: 0x7860
		Size: 0x87E
		Parameters: 2
		Flags: Linked
	*/
	function set_megachew_factory_anim_state(localclientnum, n_anim_state)
	{
		switch(n_anim_state)
		{
			case 0:
			{
				m_b_power_boost = 0;
				clear_vat_labels(localclientnum);
				self thread set_megachew_factory_gears_anim_state(localclientnum, 0);
				set_megachew_factory_doors_anim_state(localclientnum, 0);
				for(i = 1; i <= 3; i++)
				{
					[[ m_a_o_megachewvat[i - 1] ]]->set_vat_state(localclientnum, 0, 0);
					[[ m_a_o_megachewvatdialset[i - 1] ]]->set_power(0);
				}
				for(i = 1; i <= 3; i++)
				{
					self thread set_megachew_factory_carousel_anim_state(localclientnum, i, 0);
				}
				break;
			}
			case 1:
			{
				self thread show_random_starting_gumballs_on_carousels(localclientnum);
				for(i = 0; i < 3; i++)
				{
					b_vat_is_powered = vat_is_powered(i);
					[[ m_a_o_megachewvat[i] ]]->set_vat_state(localclientnum, 1, b_vat_is_powered);
					[[ m_a_o_megachewvatdialset[i] ]]->set_power(b_vat_is_powered);
				}
				self thread set_megachew_factory_gears_anim_state(localclientnum, 1);
				wait(0.2);
				for(i = 1; i <= 3; i++)
				{
					self thread set_megachew_factory_dome_anim_state(localclientnum, i, n_anim_state);
				}
				for(i = 1; i <= 3; i++)
				{
					self thread set_megachew_factory_carousel_anim_state(localclientnum, i, n_anim_state);
				}
				wait(0.2);
				set_megachew_factory_doors_anim_state(localclientnum, 1);
				break;
			}
			case 2:
			{
				level flag::set("megachew_carousel_show_result");
				for(i = 1; i <= 3; i++)
				{
					self thread set_megachew_factory_dome_anim_state(localclientnum, i, 2);
					self thread set_megachew_factory_carousel_anim_state(localclientnum, i, n_anim_state);
					if(vat_should_launch_result(i - 1))
					{
						thread [[ m_a_o_megachewvat[i - 1] ]]->play_electrode_surge(localclientnum);
					}
				}
				self thread set_megachew_factory_gears_anim_state(localclientnum, 2);
				wait(0.25);
				for(i = 0; i < 3; i++)
				{
					[[ m_a_o_megachewvat[i] ]]->set_steam_fx(localclientnum, 0);
					[[ m_a_o_megachewvatdialset[i] ]]->set_power(0);
				}
				wait(0.25);
				play_powerup_activation_fx(localclientnum);
				if(m_b_power_boost)
				{
					wait(0.125);
					for(i = 0; i < 3; i++)
					{
						[[ m_a_o_megachewvat[i] ]]->set_vat_state(localclientnum, 0, 1);
						[[ m_a_o_megachewvatdialset[i] ]]->set_power(1);
					}
				}
				for(i = 1; i <= 3; i++)
				{
					[[ m_a_o_megachewvat[i - 1] ]]->set_electrode_fx(localclientnum, 0);
				}
				for(i = 1; i <= 3; i++)
				{
					if(vat_should_launch_result(i - 1))
					{
						[[ m_a_o_megachewvatdialset[i - 1] ]]->set_visibility_of_dials_attached_to_dome(0);
						self thread set_megachew_factory_dome_anim_state(localclientnum, i, 3);
					}
				}
				wait(0.5);
				self thread play_gumball_vanishing_fx(localclientnum);
				wait(0.25);
				set_megachew_factory_doors_anim_state(localclientnum, 0);
				wait(0.5);
				for(i = 1; i <= 3; i++)
				{
					if(vat_should_launch_result(i - 1))
					{
						self thread set_megachew_factory_dome_anim_state(localclientnum, i, 4);
					}
				}
				wait(0.25 * pow(2, m_n_doubler_count));
				for(i = 1; i <= 3; i++)
				{
					if(vat_should_launch_result(i - 1))
					{
						self thread set_megachew_factory_dome_anim_state(localclientnum, i, 5);
					}
				}
				for(i = 1; i <= 3; i++)
				{
					if(vat_should_launch_result(i - 1))
					{
						[[ m_a_o_megachewvatdialset[i - 1] ]]->set_visibility_of_dials_attached_to_dome(1);
					}
				}
				for(i = 0; i < 3; i++)
				{
					[[ m_a_o_megachewvat[i] ]]->set_light_fx(localclientnum, 0);
				}
				for(i = 0; i < 3; i++)
				{
					[[ m_a_o_megachewcarousels[i] ]]->detach_all_models_from_carousel();
				}
				break;
			}
			case 3:
			{
				level notify(#"megachew_factory_doors_closed");
				self thread set_megachew_factory_gears_anim_state(localclientnum, 2);
				set_megachew_factory_doors_anim_state(localclientnum, 0);
				for(i = 1; i <= 3; i++)
				{
					self thread set_megachew_factory_carousel_anim_state(localclientnum, i, n_anim_state);
					self thread set_megachew_factory_dome_anim_state(localclientnum, i, 2);
				}
				for(i = 0; i < 3; i++)
				{
					[[ m_a_o_megachewcarousels[i] ]]->detach_all_models_from_carousel();
				}
				break;
			}
		}
	}

	/*
		Name: attach_model_to_tag_until_notify
		Namespace: cmegachewfactory
		Checksum: 0xCDB28AA6
		Offset: 0x7750
		Size: 0x108
		Parameters: 4
		Flags: Linked
	*/
	function attach_model_to_tag_until_notify(mdl_base, str_mdl_to_attach, str_tag, str_notify)
	{
		if(!isdefined(mdl_base.str_mdl_attached))
		{
			mdl_base.str_mdl_attached = [];
		}
		if(isdefined(mdl_base.str_mdl_attached[str_tag]))
		{
			mdl_base detach(mdl_base.str_mdl_attached[str_tag], str_tag);
		}
		mdl_base attach(str_mdl_to_attach, str_tag);
		mdl_base.str_mdl_attached[str_tag] = str_mdl_to_attach;
		level waittill(str_notify);
		mdl_base detach(str_mdl_to_attach, str_tag);
		mdl_base.str_mdl_attached[str_tag] = undefined;
	}

	/*
		Name: hide_show_results
		Namespace: cmegachewfactory
		Checksum: 0x5313AD3
		Offset: 0x7540
		Size: 0x204
		Parameters: 1
		Flags: Linked
	*/
	function hide_show_results(localclientnum)
	{
		m_n_result_ball_count = 0;
		for(n_vat_index = 1; n_vat_index <= 3; n_vat_index++)
		{
			str_model = get_result_model_name_for_vat_contents(n_vat_index - 1, 0);
			if((m_a_vat_contents[n_vat_index - 1]) === "POWER_BOOST")
			{
				continue;
				continue;
			}
			if((m_a_vat_contents[n_vat_index - 1]) === "DOUBLE_UP")
			{
				continue;
				continue;
			}
			if(n_vat_index <= m_n_tokens_spent || m_b_power_boost)
			{
				n_times_to_give = int(pow(2, m_n_doubler_count));
				for(i = 0; i < n_times_to_give; i++)
				{
					str_notify = "megachew_factory_cycle_complete";
					mdl_ball = m_a_mdl_balls[m_n_result_ball_count];
					mdl_dome = m_a_mdl_domes[n_vat_index - 1];
					self thread attach_model_to_tag_until_notify(mdl_ball, str_model, "tag_ball_" + m_n_result_ball_count, str_notify);
					self thread attach_model_to_tag_until_notify(mdl_dome, str_model, "tag_ball_" + i, str_notify);
					m_n_result_ball_count = m_n_result_ball_count + 1;
				}
			}
		}
	}

	/*
		Name: get_effect_color_of_vat_contents
		Namespace: cmegachewfactory
		Checksum: 0x6BBE4440
		Offset: 0x7528
		Size: 0xC
		Parameters: 1
		Flags: Linked
	*/
	function get_effect_color_of_vat_contents(n_vat_index)
	{
	}

	/*
		Name: vat_is_powered
		Namespace: cmegachewfactory
		Checksum: 0x5A507618
		Offset: 0x74D0
		Size: 0x4A
		Parameters: 1
		Flags: Linked
	*/
	function vat_is_powered(n_vat_index)
	{
		if(!isdefined(m_n_tokens_spent))
		{
			return false;
		}
		if(n_vat_index < m_n_tokens_spent || (isdefined(m_b_power_boost) && m_b_power_boost))
		{
			return true;
		}
		return false;
	}

	/*
		Name: vat_contains_result_item
		Namespace: cmegachewfactory
		Checksum: 0x2B4221E5
		Offset: 0x7480
		Size: 0x48
		Parameters: 1
		Flags: Linked
	*/
	function vat_contains_result_item(n_vat_index)
	{
		if(m_a_vat_contents[n_vat_index] === "POWER_BOOST")
		{
			return false;
		}
		if(m_a_vat_contents[n_vat_index] === "DOUBLE_UP")
		{
			return false;
		}
		return true;
	}

	/*
		Name: vat_should_launch_result
		Namespace: cmegachewfactory
		Checksum: 0x90A24367
		Offset: 0x7430
		Size: 0x46
		Parameters: 1
		Flags: Linked
	*/
	function vat_should_launch_result(n_vat_index)
	{
		if(vat_contains_result_item(n_vat_index) && vat_is_powered(n_vat_index))
		{
			return true;
		}
		return false;
	}

	/*
		Name: get_random_model_name_to_attach_to_carousel
		Namespace: cmegachewfactory
		Checksum: 0xA2688EB5
		Offset: 0x7320
		Size: 0x102
		Parameters: 0
		Flags: Linked
	*/
	function get_random_model_name_to_attach_to_carousel()
	{
		n_roll = randomint(100);
		if(n_roll < 85)
		{
			str_item_index = tablelookup("gamedata/stats/zm/zm_statstable.csv", 0, get_random_bgb_consumable_item_index(), 4);
			str_gumball = ("p7_" + str_item_index) + "_ui_large";
		}
		else
		{
			if(n_roll < 90)
			{
				str_gumball = "p7_zm_bgb_wildcard_vial" + "_large";
			}
			else
			{
				if(n_roll < 95)
				{
					str_gumball = "p7_zm_bgb_wildcard_2x" + "_large";
				}
				else
				{
					str_gumball = "p7_zm_bgb_wildcard_boost" + "_large";
				}
			}
		}
		return str_gumball;
	}

	/*
		Name: get_random_bgb_consumable_item_index
		Namespace: cmegachewfactory
		Checksum: 0xAE75A60A
		Offset: 0x72C8
		Size: 0x4A
		Parameters: 0
		Flags: Linked
	*/
	function get_random_bgb_consumable_item_index()
	{
		first_bgb_consumable_item_index = 216;
		last_bgb_consumable_item_index = 233;
		return randomintrange(first_bgb_consumable_item_index, last_bgb_consumable_item_index + 1);
	}

	/*
		Name: get_result_model_name_for_vat_contents
		Namespace: cmegachewfactory
		Checksum: 0x88D09C64
		Offset: 0x7188
		Size: 0x132
		Parameters: 2
		Flags: Linked
	*/
	function get_result_model_name_for_vat_contents(n_vat_index, b_is_large_version)
	{
		switch(m_a_vat_contents[n_vat_index])
		{
			case "POWER_BOOST":
			{
				str_gumball = "p7_zm_bgb_wildcard_boost" + "_large";
				break;
			}
			case "DOUBLE_UP":
			{
				str_gumball = "p7_zm_bgb_wildcard_2x" + "_large";
				break;
			}
			case "FREE_VIAL":
			{
				if(b_is_large_version)
				{
					str_gumball = "p7_zm_bgb_wildcard_vial" + "_large";
				}
				else
				{
					str_gumball = "p7_zm_bgb_wildcard_vial" + "_small";
				}
				break;
			}
			default:
			{
				if(b_is_large_version)
				{
					str_gumball = ("p7_" + m_a_vat_contents[n_vat_index]) + "_ui_large";
				}
				else
				{
					str_gumball = ("p7_" + m_a_vat_contents[n_vat_index]) + "_ui_small";
				}
				break;
			}
		}
		return str_gumball;
	}

	/*
		Name: clear_vat_labels
		Namespace: cmegachewfactory
		Checksum: 0x8A9995A4
		Offset: 0x7100
		Size: 0x7E
		Parameters: 1
		Flags: Linked
	*/
	function clear_vat_labels(localclientnum)
	{
		for(i = 0; i < 3; i++)
		{
			setuimodelvalue(m_a_uimodel_megachew[i], "");
			set_megachew_factory_label_light_state(localclientnum, i + 1, 0);
		}
	}

	/*
		Name: rumble_loop
		Namespace: cmegachewfactory
		Checksum: 0x4F661FC9
		Offset: 0x70B0
		Size: 0x48
		Parameters: 1
		Flags: Linked
	*/
	function rumble_loop(localclientnum)
	{
		while(true)
		{
			playrumbleonposition(localclientnum, "damage_light", (-3243, 2521, 101));
			wait(0.1);
		}
	}

	/*
		Name: reset_megachew_factory
		Namespace: cmegachewfactory
		Checksum: 0x70923E08
		Offset: 0x6E88
		Size: 0x21A
		Parameters: 1
		Flags: Linked
	*/
	function reset_megachew_factory(localclientnum)
	{
		level notify(#"megachew_factory_doors_closed");
		[[ m_o_megachewcounter ]]->set_blinking(localclientnum, 0);
		update_token_display_counter(localclientnum, 1);
		set_megachew_factory_anim_state(localclientnum, 0);
		[[ m_o_megachewbuttons ]]->set_side_bulb_glow(localclientnum, 0);
		for(n_button_index = 1; n_button_index <= 3; n_button_index++)
		{
			exploder::stop_exploder("zm_gumball_" + n_button_index);
		}
		level notify(#"megachew_factory_cycle_complete");
		level flag::clear("megachew_sequence_active");
		for(i = 1; i <= 3; i++)
		{
			mdl_body = m_a_mdl_bodies[i - 1];
			mdl_body clearanim("p7_fxanim_zm_bgb_body_active_powered_anim", 0);
			mdl_body clearanim("p7_fxanim_zm_bgb_body_end_powered_anim", 0);
			mdl_body clearanim("p7_fxanim_zm_bgb_body_active_unpowered_anim", 0);
			mdl_body clearanim("p7_fxanim_zm_bgb_body_end_unpowered_anim", 0);
			if(isdefined(m_n_tokens_spent))
			{
				self thread set_megachew_factory_dome_anim_state(localclientnum, i, 0);
			}
		}
		for(i = 0; i < 3; i++)
		{
			[[ m_a_o_megachewcarousels[i] ]]->detach_all_models_from_carousel();
		}
	}

	/*
		Name: activate
		Namespace: cmegachewfactory
		Checksum: 0x43C27268
		Offset: 0x6980
		Size: 0x4FC
		Parameters: 2
		Flags: Linked
	*/
	function activate(localclientnum, n_button_index)
	{
		level flag::set("megachew_sequence_active");
		m_n_tokens_spent = n_button_index;
		m_a_vat_contents = array(undefined, undefined, undefined);
		level flag::clear("megachew_carousel_show_result");
		thread [[ m_o_megachewcounter ]]->set_blinking(localclientnum, 1);
		exploder::exploder("zm_gumball_" + n_button_index);
		thread [[ m_o_megachewbuttons ]]->press_button(localclientnum, n_button_index);
		wait(0.1);
		set_megachew_factory_anim_state(localclientnum, 1);
		[[ m_o_megachewbuttons ]]->set_button_glow(localclientnum, 1);
		level waittill(#"mega_chew_results", success, vat_0, vat_1, vat_2);
		m_a_vat_contents[0] = vat_0;
		m_a_vat_contents[1] = vat_1;
		m_a_vat_contents[2] = vat_2;
		if(!success || "" == vat_0 || "" == vat_1 || "" == vat_2)
		{
			set_megachew_factory_anim_state(localclientnum, 3);
			[[ m_o_megachewcounter ]]->set_blinking(localclientnum, 0);
			[[ m_o_megachewcounter ]]->update_number_display(localclientnum);
		}
		else
		{
			get_megachew_factory_results();
			for(i = 0; i < 3; i++)
			{
				if(m_a_vat_contents[i] === "POWER_BOOST")
				{
					str_item_name = "ZMUI_MEGACHEW_POWER_BOOST";
				}
				else
				{
					if(m_a_vat_contents[i] === "DOUBLE_UP")
					{
						str_item_name = "ZMUI_MEGACHEW_DOUBLER";
					}
					else
					{
						if(m_a_vat_contents[i] === "FREE_VIAL")
						{
							str_item_name = "ZMUI_MEGACHEW_VIAL";
						}
						else
						{
							str_item_name = tablelookup("gamedata/stats/zm/zm_statstable.csv", 4, m_a_vat_contents[i], 3);
							str_item_name = str_item_name + "_FACTORY_CAPS";
						}
					}
				}
				if(vat_is_powered(i))
				{
					set_megachew_factory_label_light_state(localclientnum, i + 1, 2);
				}
				else
				{
					set_megachew_factory_label_light_state(localclientnum, i + 1, 1);
				}
				setuimodelvalue(m_a_uimodel_megachew[i], str_item_name);
			}
			hide_show_results(localclientnum);
			[[ m_o_megachewcounter ]]->set_blinking(localclientnum, 0);
			[[ m_o_megachewcounter ]]->update_number_display(localclientnum);
			set_megachew_factory_anim_state(localclientnum, 2);
			wait(0.125);
			exploder::exploder("zm_gumball_pipe");
			for(i = 0; i < 3; i++)
			{
				set_megachew_results_anim_state(localclientnum, i);
			}
			exploder::stop_exploder("zm_gumball_pipe");
		}
		set_megachew_factory_anim_state(localclientnum, 0);
		[[ m_o_megachewbuttons ]]->set_button_glow(localclientnum, 0);
		exploder::stop_exploder("zm_gumball_" + n_button_index);
		level notify(#"megachew_factory_cycle_complete");
		level flag::clear("megachew_sequence_active");
	}

	/*
		Name: change_button_selected
		Namespace: cmegachewfactory
		Checksum: 0x7E096D6F
		Offset: 0x6910
		Size: 0x64
		Parameters: 2
		Flags: Linked
	*/
	function change_button_selected(localclientnum, n_button_index)
	{
		[[ m_o_megachewbuttons ]]->change_button_selected(localclientnum, n_button_index);
		setuimodelvalue(m_uimodel_instructions, ("ZMUI_MEGACHEW_" + (n_button_index + 1)) + "_TOKEN");
	}

	/*
		Name: update_token_display_counter
		Namespace: cmegachewfactory
		Checksum: 0xA42532DA
		Offset: 0x68A0
		Size: 0x64
		Parameters: 2
		Flags: Linked
	*/
	function update_token_display_counter(localclientnum, b_update_visual_counter = 0)
	{
		[[ m_o_megachewcounter ]]->set_number(localclientnum, m_n_tokens_remaining);
		if(b_update_visual_counter)
		{
			[[ m_o_megachewcounter ]]->update_number_display(localclientnum);
		}
	}

	/*
		Name: update_token_count
		Namespace: cmegachewfactory
		Checksum: 0xA15FEFD4
		Offset: 0x6880
		Size: 0x18
		Parameters: 1
		Flags: Linked
	*/
	function update_token_count(n_tokens)
	{
		m_n_tokens_remaining = n_tokens;
	}

	/*
		Name: init
		Namespace: cmegachewfactory
		Checksum: 0xE335D596
		Offset: 0x5A70
		Size: 0xE04
		Parameters: 1
		Flags: Linked
	*/
	function init(localclientnum)
	{
		m_a_str_megachew_factory_door_flags = [];
		m_a_str_megachew_factory_result_flags = [];
		m_a_mdl_domes = [];
		m_a_mdl_bodies = [];
		m_a_mdl_doors = [];
		m_a_mdl_carousels = [];
		m_a_mdl_balls = [];
		m_uimodel_instructions = createuimodel(getglobaluimodel(), "MegaChewLabelInstructions");
		m_a_uimodel_megachew = [];
		m_a_uimodel_megachew[0] = createuimodel(getglobaluimodel(), "MegaChewLabelLeft");
		m_a_uimodel_megachew[1] = createuimodel(getglobaluimodel(), "MegaChewLabelMiddle");
		m_a_uimodel_megachew[2] = createuimodel(getglobaluimodel(), "MegaChewLabelRight");
		clear_vat_labels(localclientnum);
		m_a_mdl_gearbox = getentarray(localclientnum, "ambient_gearbox", "targetname");
		foreach(mdl_gearbox in m_a_mdl_gearbox)
		{
			mdl_gearbox useanimtree($generic);
		}
		m_a_mdl_gear = getentarray(localclientnum, "ambient_gear", "targetname");
		foreach(mdl_gear in m_a_mdl_gear)
		{
			mdl_gear useanimtree($generic);
		}
		m_mdl_tube_front = getent(localclientnum, "tube_front", "targetname");
		m_mdl_tube_front useanimtree($generic);
		level._effect["megachew_gumball_poof_out"] = "ui/fx_megachew_ball_poof_01";
		level._effect["megachew_gumball_poof_blue"] = "ui/fx_megachew_ball_poof_blue";
		level._effect["megachew_gumball_poof_green"] = "ui/fx_megachew_ball_poof_green";
		level._effect["megachew_gumball_poof_orange"] = "ui/fx_megachew_ball_poof_orange";
		level._effect["megachew_gumball_poof_purple"] = "ui/fx_megachew_ball_poof_purple";
		level._effect["megachew_gumball_power_boost"] = "ui/fx_megachew_ball_power_boost";
		level._effect["megachew_vat_electrode_lg"] = "ui/fx_megachew_vat_electrode_lg_loop";
		level._effect["megachew_vat_electrode_sm"] = "ui/fx_megachew_vat_electrode_sm_loop";
		level._effect["megachew_vat_light_lg"] = "ui/fx_megachew_vat_light_lg_loop";
		level._effect["megachew_vat_light_sm"] = "ui/fx_megachew_vat_light_sm_loop";
		level._effect["megachew_vat_whistle"] = "ui/fx_megachew_vat_whistle_loop";
		level._effect["megachew_vat_electrode_center_lg"] = "ui/fx_megachew_vat_electrode_center_lg_loop";
		level._effect["megachew_vat_electrode_center_sm"] = "ui/fx_megachew_vat_electrode_center_sm_loop";
		level._effect["megachew_vat_electrode_surge_lg"] = "ui/fx_megachew_vat_electrode_surge_lg";
		level._effect["megachew_vat_electrode_surge_sm"] = "ui/fx_megachew_vat_electrode_surge_sm";
		level._effect["megachew_vat_whistle_sm"] = "ui/fx_megachew_vat_whistle_sm_loop";
		level._effect["ui/fx_megachew_ball_divinium"] = "ui/fx_megachew_ball_divinium";
		level._effect["ui/fx_megachew_ball_double"] = "ui/fx_megachew_ball_double";
		level._effect["ui/fx_megachew_ball_power_boost"] = "ui/fx_megachew_ball_power_boost";
		level._effect["ui/fx_megachew_ball_divinium"] = "ui/fx_megachew_ball_divinium";
		level._effect["ui/fx_megachew_ball_double"] = "ui/fx_megachew_ball_double";
		level._effect["ui/fx_megachew_ball_power_boost"] = "ui/fx_megachew_ball_power_boost";
		level flag::init("megachew_sequence_active");
		if(!isdefined(m_a_o_megachewcarousels))
		{
			m_a_o_megachewcarousels = [];
			for(i = 0; i < 3; i++)
			{
				if(!isdefined(m_a_o_megachewcarousels[i]))
				{
					m_a_o_megachewcarousels[i] = new cmegachewcarousel();
					[[ m_a_o_megachewcarousels[i] ]]->init(localclientnum, i + 1);
				}
			}
		}
		if(!isdefined(m_a_o_megachewvat))
		{
			m_a_o_megachewvat = [];
			for(i = 0; i < 3; i++)
			{
				if(!isdefined(m_a_o_megachewvat[i]))
				{
					m_a_o_megachewvat[i] = new cmegachewvat();
					[[ m_a_o_megachewvat[i] ]]->init(localclientnum, i + 1);
				}
			}
		}
		if(!isdefined(m_a_o_megachewvatdialset))
		{
			m_a_o_megachewvatdialset = [];
			for(i = 0; i < 3; i++)
			{
				if(!isdefined(m_a_o_megachewvatdialset[i]))
				{
					m_a_o_megachewvatdialset[i] = new cmegachewvatdialset();
					[[ m_a_o_megachewvatdialset[i] ]]->init(localclientnum, i + 1);
				}
			}
		}
		if(!isdefined(m_o_megachewbuttons))
		{
			m_o_megachewbuttons = new cmegachewbuttons();
			[[ m_o_megachewbuttons ]]->init(localclientnum);
		}
		vialdisplaymodel = getuimodel(getglobaluimodel(), "MegaChewFactoryVialDisplay");
		m_n_tokens_remaining = getuimodelvalue(vialdisplaymodel);
		if(m_n_tokens_remaining > 999)
		{
			m_n_tokens_remaining = 999;
		}
		if(!isdefined(m_o_megachewcounter))
		{
			m_o_megachewcounter = new cmegachewcounter();
			[[ m_o_megachewcounter ]]->init(localclientnum, m_n_tokens_remaining);
		}
		for(i = 1; i <= 3; i++)
		{
			str_megachew_factory_door_flag = ("megachew_factory_door_" + i) + "_anim_done";
			if(!isdefined(m_a_str_megachew_factory_door_flags))
			{
				m_a_str_megachew_factory_door_flags = [];
			}
			else if(!isarray(m_a_str_megachew_factory_door_flags))
			{
				m_a_str_megachew_factory_door_flags = array(m_a_str_megachew_factory_door_flags);
			}
			m_a_str_megachew_factory_door_flags[m_a_str_megachew_factory_door_flags.size] = str_megachew_factory_door_flag;
			level flag::init(str_megachew_factory_door_flag);
			mdl_dome = getent(localclientnum, ("bgb_0" + i) + "_dome", "targetname");
			if(!mdl_dome hasanimtree())
			{
				mdl_dome useanimtree($generic);
			}
			if(!isdefined(m_a_mdl_domes))
			{
				m_a_mdl_domes = [];
			}
			else if(!isarray(m_a_mdl_domes))
			{
				m_a_mdl_domes = array(m_a_mdl_domes);
			}
			m_a_mdl_domes[m_a_mdl_domes.size] = mdl_dome;
			mdl_body = getent(localclientnum, ("bgb_0" + i) + "_body", "targetname");
			if(!mdl_body hasanimtree())
			{
				mdl_body useanimtree($generic);
			}
			if(!isdefined(m_a_mdl_bodies))
			{
				m_a_mdl_bodies = [];
			}
			else if(!isarray(m_a_mdl_bodies))
			{
				m_a_mdl_bodies = array(m_a_mdl_bodies);
			}
			m_a_mdl_bodies[m_a_mdl_bodies.size] = mdl_body;
			mdl_door = getent(localclientnum, "main_doors_0" + i, "targetname");
			if(!mdl_door hasanimtree())
			{
				mdl_door useanimtree($generic);
			}
			if(!isdefined(m_a_mdl_doors))
			{
				m_a_mdl_doors = [];
			}
			else if(!isarray(m_a_mdl_doors))
			{
				m_a_mdl_doors = array(m_a_mdl_doors);
			}
			m_a_mdl_doors[m_a_mdl_doors.size] = mdl_door;
		}
		for(i = 0; i < 6; i++)
		{
			str_ball_targetname = "tube_ball_" + i;
			mdl_ball = getent(localclientnum, str_ball_targetname, "targetname");
			mdl_ball hidepart(localclientnum, "tag_ball_" + i);
			if(!mdl_ball hasanimtree())
			{
				mdl_ball useanimtree($generic);
			}
			if(!isdefined(m_a_mdl_balls))
			{
				m_a_mdl_balls = [];
			}
			else if(!isarray(m_a_mdl_balls))
			{
				m_a_mdl_balls = array(m_a_mdl_balls);
			}
			m_a_mdl_balls[m_a_mdl_balls.size] = mdl_ball;
			str_megachew_factory_result_flag = ("megachew_factory_result_" + i) + "_anim_done";
			if(!isdefined(m_a_str_megachew_factory_result_flags))
			{
				m_a_str_megachew_factory_result_flags = [];
			}
			else if(!isarray(m_a_str_megachew_factory_result_flags))
			{
				m_a_str_megachew_factory_result_flags = array(m_a_str_megachew_factory_result_flags);
			}
			m_a_str_megachew_factory_result_flags[m_a_str_megachew_factory_result_flags.size] = str_megachew_factory_result_flag;
			level flag::init(str_megachew_factory_result_flag);
		}
		level flag::init("megachew_carousel_show_result");
		self thread set_megachew_factory_anim_state(localclientnum, 0);
		change_button_selected(localclientnum, 0);
	}

}

class cmegachewcounter 
{
	var m_a_mdl_numbers;
	var m_n_count;
	var m_mdl_device;

	/*
		Name: constructor
		Namespace: cmegachewcounter
		Checksum: 0x99EC1590
		Offset: 0xA780
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: cmegachewcounter
		Checksum: 0x99EC1590
		Offset: 0xA790
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: turn_off_number_place
		Namespace: cmegachewcounter
		Checksum: 0x1C4EF3F
		Offset: 0xA6F0
		Size: 0x86
		Parameters: 2
		Flags: Linked
	*/
	function turn_off_number_place(localclientnum, n_place)
	{
		mdl_number = m_a_mdl_numbers[n_place - 1];
		for(i = 0; i < 10; i++)
		{
			mdl_number hidepart(localclientnum, "tag_number_" + i);
		}
	}

	/*
		Name: set_number_place
		Namespace: cmegachewcounter
		Checksum: 0x817AF470
		Offset: 0xA618
		Size: 0xCE
		Parameters: 3
		Flags: Linked
	*/
	function set_number_place(localclientnum, n_place, n_digit)
	{
		mdl_number = m_a_mdl_numbers[n_place - 1];
		for(i = 0; i < 10; i++)
		{
			if(i === n_digit)
			{
				mdl_number showpart(localclientnum, "tag_number_" + i);
				continue;
			}
			mdl_number hidepart(localclientnum, "tag_number_" + i);
		}
	}

	/*
		Name: get_nth_place_of_counter
		Namespace: cmegachewcounter
		Checksum: 0xCBC36598
		Offset: 0xA530
		Size: 0xE0
		Parameters: 2
		Flags: Linked, Private
	*/
	function private get_nth_place_of_counter(n_place, n_count)
	{
		n_mod_1 = int(pow(10, n_place));
		n_mod_2 = int(pow(10, n_place - 1));
		n_temp = n_count % n_mod_1;
		if(n_place > 1)
		{
			n_temp = n_temp - (n_count % n_mod_2);
			n_temp = n_temp / n_mod_2;
		}
		return n_temp;
	}

	/*
		Name: update_number_display
		Namespace: cmegachewcounter
		Checksum: 0x5B56225F
		Offset: 0xA4A8
		Size: 0x7E
		Parameters: 1
		Flags: Linked
	*/
	function update_number_display(localclientnum)
	{
		for(i = 1; i <= 3; i++)
		{
			n_digit = get_nth_place_of_counter(i, m_n_count);
			set_number_place(localclientnum, i, n_digit);
		}
	}

	/*
		Name: set_blinking
		Namespace: cmegachewcounter
		Checksum: 0xA11CF0D9
		Offset: 0xA3F0
		Size: 0xB0
		Parameters: 2
		Flags: Linked
	*/
	function set_blinking(localclientnum, b_on)
	{
		self notify(#"stop_blinking_counter");
		self endon(#"stop_blinking_counter");
		if(b_on)
		{
			while(true)
			{
				for(i = 1; i <= 3; i++)
				{
					self thread turn_off_number_place(localclientnum, i);
				}
				wait(0.2);
				update_number_display(localclientnum);
				wait(0.2);
			}
		}
	}

	/*
		Name: set_number
		Namespace: cmegachewcounter
		Checksum: 0x7908FF1A
		Offset: 0xA3C8
		Size: 0x20
		Parameters: 2
		Flags: Linked
	*/
	function set_number(localclientnum, n_count)
	{
		m_n_count = n_count;
	}

	/*
		Name: init
		Namespace: cmegachewcounter
		Checksum: 0x57AD98AA
		Offset: 0xA1F8
		Size: 0x1C4
		Parameters: 2
		Flags: Linked
	*/
	function init(localclientnum, start_count)
	{
		m_mdl_device = getent(localclientnum, "vial_counter", "targetname");
		m_a_mdl_numbers = [];
		m_n_count = start_count;
		for(i = 0; i < 3; i++)
		{
			v_origin = m_mdl_device gettagorigin("tag_numbers_position_" + i);
			v_angles = m_mdl_device gettagangles("tag_numbers_position_" + i);
			mdl_number = spawn(localclientnum, v_origin, "script_model");
			mdl_number setmodel("p7_zm_bgb_nixie_number_on");
			mdl_number.angles = v_angles;
			if(!isdefined(m_a_mdl_numbers))
			{
				m_a_mdl_numbers = [];
			}
			else if(!isarray(m_a_mdl_numbers))
			{
				m_a_mdl_numbers = array(m_a_mdl_numbers);
			}
			m_a_mdl_numbers[m_a_mdl_numbers.size] = mdl_number;
		}
		update_number_display(localclientnum);
	}

}

class cmegachewvat 
{
	var m_mdl_dome;
	var m_n_vat_index;
	var m_a_fx_id_electrode;
	var m_a_fx_id_light;
	var m_a_fx_id_steam;
	var m_b_vat_is_spinning;
	var m_b_vat_is_powered;

	/*
		Name: constructor
		Namespace: cmegachewvat
		Checksum: 0x99EC1590
		Offset: 0xB8F0
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: cmegachewvat
		Checksum: 0x99EC1590
		Offset: 0xB900
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: play_effect_on_tag_and_stop_after_pause
		Namespace: cmegachewvat
		Checksum: 0xD705A08D
		Offset: 0xB850
		Size: 0x94
		Parameters: 4
		Flags: Linked, Private
	*/
	function private play_effect_on_tag_and_stop_after_pause(localclientnum, str_fx, str_tag, n_pause = 2)
	{
		fx_id = playfxontag(localclientnum, str_fx, m_mdl_dome, str_tag);
		wait(n_pause);
		stopfx(localclientnum, fx_id);
	}

	/*
		Name: play_electrode_surge
		Namespace: cmegachewvat
		Checksum: 0xC444A32F
		Offset: 0xB650
		Size: 0x1F6
		Parameters: 1
		Flags: Linked
	*/
	function play_electrode_surge(localclientnum)
	{
		switch(m_n_vat_index)
		{
			case 1:
			{
				break;
			}
			case 2:
			{
				self thread play_effect_on_tag_and_stop_after_pause(localclientnum, level._effect["megachew_vat_electrode_surge_sm"], "tag_dome2_elect_01");
				self thread play_effect_on_tag_and_stop_after_pause(localclientnum, level._effect["megachew_vat_electrode_surge_sm"], "tag_dome2_elect_02");
				self thread play_effect_on_tag_and_stop_after_pause(localclientnum, level._effect["megachew_vat_electrode_center_sm"], "tag_dome2_elect_cnt_01");
				break;
			}
			case 3:
			{
				self thread play_effect_on_tag_and_stop_after_pause(localclientnum, level._effect["megachew_vat_electrode_surge_sm"], "tag_dome3_elect_01");
				self thread play_effect_on_tag_and_stop_after_pause(localclientnum, level._effect["megachew_vat_electrode_surge_sm"], "tag_dome3_elect_02");
				self thread play_effect_on_tag_and_stop_after_pause(localclientnum, level._effect["megachew_vat_electrode_center_sm"], "tag_dome3_elect_cnt_01");
				self thread play_effect_on_tag_and_stop_after_pause(localclientnum, level._effect["megachew_vat_electrode_center_lg"], "tag_dome3_elect_cnt_02");
				self thread play_effect_on_tag_and_stop_after_pause(localclientnum, level._effect["megachew_vat_electrode_surge_lg"], "tag_dome3_elect_03");
				self thread play_effect_on_tag_and_stop_after_pause(localclientnum, level._effect["megachew_vat_electrode_surge_lg"], "tag_dome3_elect_04");
				break;
			}
		}
	}

	/*
		Name: play_effect_on_tag_and_add_to_array
		Namespace: cmegachewvat
		Checksum: 0x827522E1
		Offset: 0xB470
		Size: 0x1D6
		Parameters: 4
		Flags: Linked, Private
	*/
	function private play_effect_on_tag_and_add_to_array(localclientnum, str_fx, str_tag, n_type_index)
	{
		fx_id = playfxontag(localclientnum, str_fx, m_mdl_dome, str_tag);
		switch(n_type_index)
		{
			case 2:
			{
				if(!isdefined(m_a_fx_id_electrode))
				{
					m_a_fx_id_electrode = [];
				}
				else if(!isarray(m_a_fx_id_electrode))
				{
					m_a_fx_id_electrode = array(m_a_fx_id_electrode);
				}
				m_a_fx_id_electrode[m_a_fx_id_electrode.size] = fx_id;
				break;
			}
			case 1:
			{
				if(!isdefined(m_a_fx_id_light))
				{
					m_a_fx_id_light = [];
				}
				else if(!isarray(m_a_fx_id_light))
				{
					m_a_fx_id_light = array(m_a_fx_id_light);
				}
				m_a_fx_id_light[m_a_fx_id_light.size] = fx_id;
				break;
			}
			case 3:
			{
				if(!isdefined(m_a_fx_id_steam))
				{
					m_a_fx_id_steam = [];
				}
				else if(!isarray(m_a_fx_id_steam))
				{
					m_a_fx_id_steam = array(m_a_fx_id_steam);
				}
				m_a_fx_id_steam[m_a_fx_id_steam.size] = fx_id;
				break;
			}
		}
	}

	/*
		Name: set_steam_fx
		Namespace: cmegachewvat
		Checksum: 0xD2D251FB
		Offset: 0xB300
		Size: 0x164
		Parameters: 2
		Flags: Linked
	*/
	function set_steam_fx(localclientnum, n_steam_level)
	{
		if(n_steam_level == 0)
		{
			foreach(fx_id in m_a_fx_id_steam)
			{
				stopfx(localclientnum, fx_id);
			}
			m_a_fx_id_steam = [];
		}
		else
		{
			if(n_steam_level == 1)
			{
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_whistle_sm"], ("tag_dome" + m_n_vat_index) + "_whistle", 3);
			}
			else if(n_steam_level == 2)
			{
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_whistle"], ("tag_dome" + m_n_vat_index) + "_whistle", 3);
			}
		}
	}

	/*
		Name: set_light_fx
		Namespace: cmegachewvat
		Checksum: 0x19E4EB38
		Offset: 0xAE58
		Size: 0x49E
		Parameters: 2
		Flags: Linked
	*/
	function set_light_fx(localclientnum, b_on)
	{
		if(!b_on)
		{
			foreach(fx_id in m_a_fx_id_light)
			{
				stopfx(localclientnum, fx_id);
			}
			m_a_fx_id_light = [];
			return;
		}
		switch(m_n_vat_index)
		{
			case 1:
			{
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_lg"], "tag_dome1_light_01", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_lg"], "tag_dome1_light_02", 1);
				break;
			}
			case 2:
			{
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_lg"], "tag_dome2_light_01", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_lg"], "tag_dome2_light_02", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome2_light_03", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome2_light_04", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome2_light_06", 1);
			}
			case 3:
			{
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_lg"], "tag_dome3_light_01", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_lg"], "tag_dome3_light_02", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome3_light_03", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome3_light_04", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome3_light_05", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome3_light_06", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome3_light_07", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome3_light_10", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome3_light_11", 1);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_light_sm"], "tag_dome3_light_12", 1);
				break;
			}
		}
	}

	/*
		Name: set_electrode_fx
		Namespace: cmegachewvat
		Checksum: 0xC097F528
		Offset: 0xAB70
		Size: 0x2DE
		Parameters: 2
		Flags: Linked
	*/
	function set_electrode_fx(localclientnum, b_on)
	{
		if(!b_on)
		{
			foreach(fx_id in m_a_fx_id_electrode)
			{
				stopfx(localclientnum, fx_id);
			}
			m_a_fx_id_electrode = [];
			return;
		}
		switch(m_n_vat_index)
		{
			case 1:
			{
				break;
			}
			case 2:
			{
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_electrode_sm"], "tag_dome2_elect_01", 2);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_electrode_sm"], "tag_dome2_elect_02", 2);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_electrode_center_sm"], "tag_dome2_elect_cnt_01", 2);
				break;
			}
			case 3:
			{
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_electrode_sm"], "tag_dome3_elect_01", 2);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_electrode_sm"], "tag_dome3_elect_02", 2);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_electrode_center_sm"], "tag_dome3_elect_cnt_01", 2);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_electrode_lg"], "tag_dome3_elect_03", 2);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_electrode_lg"], "tag_dome3_elect_04", 2);
				play_effect_on_tag_and_add_to_array(localclientnum, level._effect["megachew_vat_electrode_center_lg"], "tag_dome3_elect_cnt_02", 2);
				break;
			}
		}
	}

	/*
		Name: update_vat_effects
		Namespace: cmegachewvat
		Checksum: 0xB9EB8BE1
		Offset: 0xAAA0
		Size: 0xC4
		Parameters: 1
		Flags: Linked
	*/
	function update_vat_effects(localclientnum)
	{
		if(m_b_vat_is_spinning)
		{
			if(m_b_vat_is_powered)
			{
				set_steam_fx(localclientnum, 2);
			}
			else
			{
				set_steam_fx(localclientnum, 1);
			}
		}
		else
		{
			set_steam_fx(localclientnum, 0);
		}
		wait(0.1);
		set_electrode_fx(localclientnum, m_b_vat_is_powered);
		set_light_fx(localclientnum, m_b_vat_is_powered);
	}

	/*
		Name: set_vat_state
		Namespace: cmegachewvat
		Checksum: 0xA0CAF16E
		Offset: 0xAA28
		Size: 0x6C
		Parameters: 3
		Flags: Linked
	*/
	function set_vat_state(localclientnum, b_is_spinning, b_is_powered)
	{
		if(b_is_spinning != m_b_vat_is_spinning)
		{
			m_b_vat_is_spinning = b_is_spinning;
		}
		if(b_is_powered != m_b_vat_is_powered)
		{
			m_b_vat_is_powered = b_is_powered;
		}
		update_vat_effects(localclientnum);
	}

	/*
		Name: init
		Namespace: cmegachewvat
		Checksum: 0xDEFBD11E
		Offset: 0xA980
		Size: 0x9C
		Parameters: 2
		Flags: Linked
	*/
	function init(localclientnum, n_vat_index)
	{
		m_a_fx_id_electrode = [];
		m_a_fx_id_light = [];
		m_a_fx_id_steam = [];
		m_n_vat_index = n_vat_index;
		m_mdl_dome = getent(localclientnum, ("bgb_0" + n_vat_index) + "_dome", "targetname");
		m_b_vat_is_spinning = 0;
		m_b_vat_is_powered = 0;
	}

}

class cmegachewcarousel 
{
	var m_mdl_carousel;
	var m_a_str_vat_contents;
	var m_str_anim;

	/*
		Name: constructor
		Namespace: cmegachewcarousel
		Checksum: 0x99EC1590
		Offset: 0xBFA8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: cmegachewcarousel
		Checksum: 0x99EC1590
		Offset: 0xBFB8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: play_carousel_effect
		Namespace: cmegachewcarousel
		Checksum: 0x9BCC782B
		Offset: 0xBEE8
		Size: 0xB4
		Parameters: 4
		Flags: Linked
	*/
	function play_carousel_effect(localclientnum, fx_id, str_tag = "tag_ball_0", n_kill_after_seconds)
	{
		m_mdl_carousel util::waittill_dobj(localclientnum);
		fx_id = playfxontag(localclientnum, fx_id, m_mdl_carousel, str_tag);
		if(isdefined(n_kill_after_seconds))
		{
			wait(n_kill_after_seconds);
			stopfx(localclientnum, fx_id);
		}
	}

	/*
		Name: detach_model_from_carousel_tag
		Namespace: cmegachewcarousel
		Checksum: 0x4CA323BD
		Offset: 0xBE48
		Size: 0x98
		Parameters: 1
		Flags: Linked, Private
	*/
	function private detach_model_from_carousel_tag(n_tag_index)
	{
		if(!isdefined(m_a_str_vat_contents[n_tag_index]))
		{
			return;
		}
		str_model = m_a_str_vat_contents[n_tag_index];
		if(m_mdl_carousel isattached(str_model, "tag_ball_" + n_tag_index))
		{
			m_mdl_carousel detach(str_model, "tag_ball_" + n_tag_index);
		}
		m_a_str_vat_contents[n_tag_index] = undefined;
	}

	/*
		Name: attach_model_to_carousel_tag
		Namespace: cmegachewcarousel
		Checksum: 0x21186DF
		Offset: 0xBDF0
		Size: 0x4E
		Parameters: 2
		Flags: Linked, Private
	*/
	function private attach_model_to_carousel_tag(n_tag_index, str_model)
	{
		m_mdl_carousel attach(str_model, "tag_ball_" + n_tag_index);
		m_a_str_vat_contents[n_tag_index] = str_model;
	}

	/*
		Name: update_model_on_carousel_tag
		Namespace: cmegachewcarousel
		Checksum: 0xB7C06E11
		Offset: 0xBDA0
		Size: 0x44
		Parameters: 2
		Flags: Linked
	*/
	function update_model_on_carousel_tag(n_tag_index, str_model)
	{
		detach_model_from_carousel_tag(n_tag_index);
		attach_model_to_carousel_tag(n_tag_index, str_model);
	}

	/*
		Name: detach_all_models_from_carousel
		Namespace: cmegachewcarousel
		Checksum: 0x246E66DC
		Offset: 0xBD50
		Size: 0x46
		Parameters: 0
		Flags: Linked
	*/
	function detach_all_models_from_carousel()
	{
		for(i = 0; i < 4; i++)
		{
			detach_model_from_carousel_tag(i);
		}
	}

	/*
		Name: set_carousel_anim_state
		Namespace: cmegachewcarousel
		Checksum: 0x55ABBCED
		Offset: 0xBC00
		Size: 0x144
		Parameters: 3
		Flags: Linked
	*/
	function set_carousel_anim_state(localclientnum, n_anim_state, b_vat_is_powered)
	{
		if(b_vat_is_powered)
		{
			str_anim_active = "p7_fxanim_zm_bgb_carousel_active_powered_anim";
			str_anim_end = "p7_fxanim_zm_bgb_carousel_end_powered_anim";
		}
		else
		{
			str_anim_active = "p7_fxanim_zm_bgb_carousel_active_unpowered_anim";
			str_anim_end = "p7_fxanim_zm_bgb_carousel_end_unpowered_anim";
		}
		m_mdl_carousel util::waittill_dobj(localclientnum);
		if(isdefined(m_str_anim))
		{
			m_mdl_carousel clearanim(m_str_anim, 0);
		}
		switch(n_anim_state)
		{
			case 0:
			{
				return;
			}
			case 1:
			{
				m_str_anim = str_anim_active;
				break;
			}
			case 2:
			{
				m_str_anim = str_anim_end;
				break;
			}
			case 3:
			{
				m_str_anim = str_anim_end;
				break;
			}
		}
		m_mdl_carousel animation::play(m_str_anim, undefined, undefined, 1);
	}

	/*
		Name: init
		Namespace: cmegachewcarousel
		Checksum: 0x4CF779B6
		Offset: 0xBB50
		Size: 0xA4
		Parameters: 2
		Flags: Linked
	*/
	function init(localclientnum, n_carousel_index)
	{
		if(!isdefined(m_mdl_carousel))
		{
			m_mdl_carousel = getent(localclientnum, "gumball_carousel_0" + n_carousel_index, "targetname");
		}
		if(!m_mdl_carousel hasanimtree())
		{
			m_mdl_carousel useanimtree($generic);
		}
		if(!isdefined(m_a_str_vat_contents))
		{
			m_a_str_vat_contents = [];
		}
	}

}

class cmegachewvatdialset 
{
	var m_a_dials_small_that_turn;
	var m_a_dials_small;
	var m_a_dials_large;

	/*
		Name: constructor
		Namespace: cmegachewvatdialset
		Checksum: 0x99EC1590
		Offset: 0xCB40
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: cmegachewvatdialset
		Checksum: 0x99EC1590
		Offset: 0xCB50
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: set_visibility_of_dials_attached_to_dome
		Namespace: cmegachewvatdialset
		Checksum: 0xD1BA7B23
		Offset: 0xCA80
		Size: 0xB2
		Parameters: 1
		Flags: Linked
	*/
	function set_visibility_of_dials_attached_to_dome(b_on)
	{
		foreach(mdl_dial in m_a_dials_small_that_turn)
		{
			if(b_on)
			{
				mdl_dial show();
				continue;
			}
			mdl_dial hide();
		}
	}

	/*
		Name: set_power
		Namespace: cmegachewvatdialset
		Checksum: 0xF8AA3FF2
		Offset: 0xC878
		Size: 0x1FE
		Parameters: 1
		Flags: Linked
	*/
	function set_power(b_on)
	{
		for(i = 0; i < m_a_dials_small.size; i++)
		{
			mdl_dial = m_a_dials_small[i];
			if(b_on)
			{
				mdl_dial clearanim("p7_fxanim_zm_bgb_dial_sml_idle_anim", 0);
				mdl_dial thread animation::play("p7_fxanim_zm_bgb_dial_sml_active_anim", undefined, undefined, 1 + (i * 0.05));
				continue;
			}
			mdl_dial clearanim("p7_fxanim_zm_bgb_dial_sml_active_anim", 0);
			mdl_dial thread animation::play("p7_fxanim_zm_bgb_dial_sml_idle_anim", undefined, undefined, 1 + (i * 0.05));
		}
		for(i = 0; i < m_a_dials_large.size; i++)
		{
			mdl_dial = m_a_dials_large[i];
			if(b_on)
			{
				mdl_dial clearanim("p7_fxanim_zm_bgb_dial_lrg_idle_anim", 0);
				mdl_dial thread animation::play("p7_fxanim_zm_bgb_dial_lrg_active_anim", undefined, undefined, 1 + (i * 0.05));
				continue;
			}
			mdl_dial clearanim("p7_fxanim_zm_bgb_dial_lrg_active_anim", 0);
			mdl_dial thread animation::play("p7_fxanim_zm_bgb_dial_lrg_idle_anim", undefined, undefined, 1 + (i * 0.05));
		}
	}

	/*
		Name: init
		Namespace: cmegachewvatdialset
		Checksum: 0x14ADBE43
		Offset: 0xC1A8
		Size: 0x6C4
		Parameters: 2
		Flags: Linked
	*/
	function init(localclientnum, n_vat_index)
	{
		m_a_dials_large = [];
		m_a_dials_small = [];
		m_a_dials_small_that_turn = [];
		mdl_dome = getent(localclientnum, ("bgb_0" + n_vat_index) + "_dome", "targetname");
		mdl_body = getent(localclientnum, ("bgb_0" + n_vat_index) + "_body", "targetname");
		for(i = 1; i <= 2; i++)
		{
			str_tagname = ("tag_body_dial_0" + i) + "_link";
			v_origin = mdl_body gettagorigin(str_tagname);
			mdl_dial = spawn(localclientnum, v_origin, "script_model");
			mdl_dial.angles = mdl_body gettagangles(str_tagname);
			mdl_dial setmodel("p7_fxanim_zm_bgb_machine_dial_lrg_mod");
			mdl_dial useanimtree($generic);
			if(!isdefined(m_a_dials_large))
			{
				m_a_dials_large = [];
			}
			else if(!isarray(m_a_dials_large))
			{
				m_a_dials_large = array(m_a_dials_large);
			}
			m_a_dials_large[m_a_dials_large.size] = mdl_dial;
		}
		if(n_vat_index === 2)
		{
			str_tagname = "tag_dome2_dial_sml_01_link";
			v_origin = mdl_dome gettagorigin(str_tagname);
			mdl_dial = spawn(localclientnum, v_origin, "script_model");
			mdl_dial setmodel("p7_fxanim_zm_bgb_machine_dial_sml_mod");
			mdl_dial useanimtree($generic);
			mdl_dial.angles = mdl_dome gettagangles(str_tagname);
			if(!isdefined(m_a_dials_small))
			{
				m_a_dials_small = [];
			}
			else if(!isarray(m_a_dials_small))
			{
				m_a_dials_small = array(m_a_dials_small);
			}
			m_a_dials_small[m_a_dials_small.size] = mdl_dial;
			if(!isdefined(m_a_dials_small_that_turn))
			{
				m_a_dials_small_that_turn = [];
			}
			else if(!isarray(m_a_dials_small_that_turn))
			{
				m_a_dials_small_that_turn = array(m_a_dials_small_that_turn);
			}
			m_a_dials_small_that_turn[m_a_dials_small_that_turn.size] = mdl_dial;
		}
		else if(n_vat_index === 3)
		{
			str_tagname = "tag_dome3_dial_lrg_01_link";
			v_origin = mdl_dome gettagorigin(str_tagname);
			mdl_dial = spawn(localclientnum, v_origin, "script_model");
			mdl_dial setmodel("p7_fxanim_zm_bgb_machine_dial_lrg_mod");
			mdl_dial useanimtree($generic);
			mdl_dial.angles = mdl_dome gettagangles(str_tagname);
			if(!isdefined(m_a_dials_large))
			{
				m_a_dials_large = [];
			}
			else if(!isarray(m_a_dials_large))
			{
				m_a_dials_large = array(m_a_dials_large);
			}
			m_a_dials_large[m_a_dials_large.size] = mdl_dial;
			for(i = 1; i <= 4; i++)
			{
				str_tagname = ("tag_dome3_dial_sml_0" + i) + "_link";
				v_origin = mdl_dome gettagorigin(str_tagname);
				mdl_dial = spawn(localclientnum, v_origin, "script_model");
				mdl_dial setmodel("p7_fxanim_zm_bgb_machine_dial_sml_mod");
				mdl_dial useanimtree($generic);
				mdl_dial.angles = mdl_dome gettagangles(str_tagname);
				if(!isdefined(m_a_dials_small))
				{
					m_a_dials_small = [];
				}
				else if(!isarray(m_a_dials_small))
				{
					m_a_dials_small = array(m_a_dials_small);
				}
				m_a_dials_small[m_a_dials_small.size] = mdl_dial;
				if(i <= 2)
				{
					if(!isdefined(m_a_dials_small_that_turn))
					{
						m_a_dials_small_that_turn = [];
					}
					else if(!isarray(m_a_dials_small_that_turn))
					{
						m_a_dials_small_that_turn = array(m_a_dials_small_that_turn);
					}
					m_a_dials_small_that_turn[m_a_dials_small_that_turn.size] = mdl_dial;
				}
			}
		}
	}

}

class cmegachewbuttons 
{
	var m_a_mdl_buttons;
	var m_a_fx_id_light;
	var m_a_fx_id_sidebulbs;
	var m_n_button_selected;

	/*
		Name: constructor
		Namespace: cmegachewbuttons
		Checksum: 0x99EC1590
		Offset: 0xD3C8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: cmegachewbuttons
		Checksum: 0x99EC1590
		Offset: 0xD3D8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: play_effect_on_tag_and_add_to_array
		Namespace: cmegachewbuttons
		Checksum: 0x2A8B145A
		Offset: 0xD2F8
		Size: 0xC2
		Parameters: 3
		Flags: Linked, Private
	*/
	function private play_effect_on_tag_and_add_to_array(localclientnum, str_fx, str_tag)
	{
		fx_id = playfxontag(localclientnum, str_fx, m_a_mdl_buttons[2], str_tag);
		if(!isdefined(m_a_fx_id_light))
		{
			m_a_fx_id_light = [];
		}
		else if(!isarray(m_a_fx_id_light))
		{
			m_a_fx_id_light = array(m_a_fx_id_light);
		}
		m_a_fx_id_light[m_a_fx_id_light.size] = fx_id;
	}

	/*
		Name: set_side_bulb_glow
		Namespace: cmegachewbuttons
		Checksum: 0x8FA88E4F
		Offset: 0xD0E0
		Size: 0x20E
		Parameters: 2
		Flags: Linked
	*/
	function set_side_bulb_glow(localclientnum, b_on)
	{
		if(b_on)
		{
			fx_id = playfxontag(localclientnum, level._effect["megachew_vat_light_lg"], m_a_mdl_buttons[2], "tag_button3_light1");
			if(!isdefined(m_a_fx_id_sidebulbs))
			{
				m_a_fx_id_sidebulbs = [];
			}
			else if(!isarray(m_a_fx_id_sidebulbs))
			{
				m_a_fx_id_sidebulbs = array(m_a_fx_id_sidebulbs);
			}
			m_a_fx_id_sidebulbs[m_a_fx_id_sidebulbs.size] = fx_id;
			fx_id = playfxontag(localclientnum, level._effect["megachew_vat_light_lg"], m_a_mdl_buttons[2], "tag_button3_light2");
			if(!isdefined(m_a_fx_id_sidebulbs))
			{
				m_a_fx_id_sidebulbs = [];
			}
			else if(!isarray(m_a_fx_id_sidebulbs))
			{
				m_a_fx_id_sidebulbs = array(m_a_fx_id_sidebulbs);
			}
			m_a_fx_id_sidebulbs[m_a_fx_id_sidebulbs.size] = fx_id;
		}
		else
		{
			foreach(fx_id in m_a_fx_id_sidebulbs)
			{
				stopfx(localclientnum, fx_id);
			}
			m_a_fx_id_sidebulbs = [];
			return;
		}
	}

	/*
		Name: set_button_glow
		Namespace: cmegachewbuttons
		Checksum: 0x32CC9E74
		Offset: 0xCFC0
		Size: 0x116
		Parameters: 2
		Flags: Linked
	*/
	function set_button_glow(localclientnum, b_on)
	{
		if(!b_on)
		{
			set_side_bulb_glow(localclientnum, 0);
			exploder::stop_exploder(("zm_gumball_" + m_n_button_selected) + "cent");
			return;
		}
		for(i = 1; i <= 3; i++)
		{
			if(i == m_n_button_selected)
			{
				exploder::exploder(("zm_gumball_" + i) + "cent");
				set_side_bulb_glow(localclientnum, 1);
				continue;
			}
			exploder::stop_exploder(("zm_gumball_" + i) + "cent");
		}
	}

	/*
		Name: update_filaments
		Namespace: cmegachewbuttons
		Checksum: 0xC871D58
		Offset: 0xCEC8
		Size: 0xEE
		Parameters: 1
		Flags: Linked
	*/
	function update_filaments(localclientnum)
	{
		for(i = 0; i < 3; i++)
		{
			mdl_button = m_a_mdl_buttons[i];
			if(i === (m_n_button_selected - 1))
			{
				mdl_button hidepart(localclientnum, "tag_filament_off");
				mdl_button showpart(localclientnum, "tag_filament_on");
				continue;
			}
			mdl_button hidepart(localclientnum, "tag_filament_on");
			mdl_button showpart(localclientnum, "tag_filament_off");
		}
	}

	/*
		Name: press_button
		Namespace: cmegachewbuttons
		Checksum: 0x17FBD45A
		Offset: 0xCE20
		Size: 0x9C
		Parameters: 2
		Flags: Linked
	*/
	function press_button(localclientnum, n_button_index)
	{
		mdl_button = m_a_mdl_buttons[n_button_index - 1];
		mdl_button util::waittill_dobj(localclientnum);
		mdl_button clearanim("p7_fxanim_zm_bgb_button_push_anim", 0);
		mdl_button animation::play("p7_fxanim_zm_bgb_button_push_anim", undefined, undefined, 1);
	}

	/*
		Name: change_button_selected
		Namespace: cmegachewbuttons
		Checksum: 0xAF793F60
		Offset: 0xCDD8
		Size: 0x3C
		Parameters: 2
		Flags: Linked
	*/
	function change_button_selected(localclientnum, n_button_index)
	{
		m_n_button_selected = n_button_index + 1;
		update_filaments(localclientnum);
	}

	/*
		Name: init
		Namespace: cmegachewbuttons
		Checksum: 0x327EBE93
		Offset: 0xCC80
		Size: 0x14C
		Parameters: 1
		Flags: Linked
	*/
	function init(localclientnum)
	{
		m_a_mdl_buttons = [];
		m_a_fx_id_light = [];
		m_a_fx_id_sidebulbs = [];
		for(i = 1; i <= 3; i++)
		{
			mdl_button = getent(localclientnum, "bgb_button_0" + i, "targetname");
			if(!mdl_button hasanimtree())
			{
				mdl_button useanimtree($generic);
			}
			if(!isdefined(m_a_mdl_buttons))
			{
				m_a_mdl_buttons = [];
			}
			else if(!isarray(m_a_mdl_buttons))
			{
				m_a_mdl_buttons = array(m_a_mdl_buttons);
			}
			m_a_mdl_buttons[m_a_mdl_buttons.size] = mdl_button;
		}
		change_button_selected(localclientnum, 1);
	}

}

#namespace frontend;

/*
	Name: main
	Namespace: frontend
	Checksum: 0xD739B58B
	Offset: 0x21E8
	Size: 0x314
	Parameters: 0
	Flags: Linked
*/
function main()
{
	level.callbackentityspawned = &entityspawned;
	level.callbacklocalclientconnect = &localclientconnect;
	level.mpvignettepostfxactive = 0;
	if(!isdefined(level.str_current_safehouse))
	{
		level.str_current_safehouse = "mobile";
	}
	level.orbis = getdvarstring("orbisGame") == "true";
	level.durango = getdvarstring("durangoGame") == "true";
	clientfield::register("world", "first_time_flow", 1, getminbitcountfornum(1), "int", &first_time_flow, 0, 1);
	clientfield::register("world", "cp_bunk_anim_type", 1, getminbitcountfornum(1), "int", &cp_bunk_anim_type, 0, 1);
	customclass::init();
	level.cameras_active = 0;
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int", &zombie_eyes_clientfield_cb, 0, 1);
	clientfield::register("scriptmover", "dni_eyes", 1000, 1, "int", &dni_eyes, 0, 0);
	level._effect["eye_glow"] = "zombie/fx_glow_eye_orange_frontend";
	level._effect["bgb_machine_available"] = "zombie/fx_bgb_machine_available_zmb";
	level._effect["doa_frontend_cigar_lit"] = "fire/fx_cigar_getting_lit";
	level._effect["doa_frontend_cigar_puff"] = "fire/fx_cigar_getting_lit_puff";
	level._effect["doa_frontend_cigar_ash"] = "fire/fx_cigar_ash_emit";
	level._effect["doa_frontend_cigar_ambient"] = "fire/fx_cigar_lit_ambient";
	level._effect["doa_frontend_cigar_exhale"] = "smoke/fx_smk_cigar_exhale";
	level._effect["frontend_special_day"] = "zombie/fx_val_motes_100x100";
	level thread blackscreen_watcher();
	setstreamerrequest(1, "core_frontend");
}

/*
	Name: first_time_flow
	Namespace: frontend
	Checksum: 0x19F30812
	Offset: 0x2508
	Size: 0x3C
	Parameters: 7
	Flags: Linked
*/
function first_time_flow(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
}

/*
	Name: cp_bunk_anim_type
	Namespace: frontend
	Checksum: 0x6B523BB5
	Offset: 0x2550
	Size: 0x3C
	Parameters: 7
	Flags: Linked
*/
function cp_bunk_anim_type(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
}

/*
	Name: setupclientmenus
	Namespace: frontend
	Checksum: 0x22A39EE
	Offset: 0x2598
	Size: 0x127C
	Parameters: 1
	Flags: Linked
*/
function setupclientmenus(localclientnum)
{
	lui::initmenudata(localclientnum);
	lui::createcustomcameramenu("Main", localclientnum, &lobby_main, 1);
	lui::createcameramenu("Inspection", localclientnum, "spawn_char_lobbyslide", "cac_main_lobby_camera_01", "cam1", undefined, &start_character_rotating_any, &end_character_rotating_any);
	lui::linktocustomcharacter("Inspection", localclientnum, "inspection_character");
	data_struct = lui::getcharacterdataformenu("Inspection", localclientnum);
	data_struct.allow_showcase_weapons = 1;
	lui::createcameramenu("CPConfirmSelection", localclientnum, "spawn_char_custom", "c_fe_confirm_selection_cam", "cam1", undefined, &open_choose_head_menu, &close_choose_head_menu);
	lui::addmenuexploders("CPConfirmSelection", localclientnum, array("char_customization", "char_custom_bg"));
	lui::linktocustomcharacter("CPConfirmSelection", localclientnum, "character_customization");
	lui::createcustomcameramenu("PersonalizeCharacter", localclientnum, &personalize_characters_watch, 0, &start_character_rotating, &end_character_rotating);
	lui::addmenuexploders("PersonalizeCharacter", localclientnum, array("char_customization", "char_custom_bg"));
	lui::linktocustomcharacter("PersonalizeCharacter", localclientnum, "character_customization");
	lui::createcustomcameramenu("ChooseTaunts", localclientnum, &choose_taunts_camera_watch, 0);
	lui::addmenuexploders("ChooseTaunts", localclientnum, array("char_customization", "char_custom_bg"));
	lui::linktocustomcharacter("ChooseTaunts", localclientnum, "character_customization");
	lui::createcameramenu("OutfitsMainMenu", localclientnum, "spawn_char_custom", "ui_cam_character_customization", "cam_preview");
	lui::addmenuexploders("OutfitsMainMenu", localclientnum, array("char_customization", "char_custom_bg"));
	lui::linktocustomcharacter("OutfitsMainMenu", localclientnum, "character_customization");
	lui::createcameramenu("ChooseOutfit", localclientnum, "spawn_char_custom", "ui_cam_character_customization", "cam_preview", undefined, &start_character_rotating, &end_character_rotating);
	lui::addmenuexploders("ChooseOutfit", localclientnum, array("char_customization", "char_custom_bg"));
	lui::linktocustomcharacter("ChooseOutfit", localclientnum, "character_customization");
	lui::createcameramenu("ChooseHead", localclientnum, "spawn_char_custom", "ui_cam_character_customization", "cam_helmet", undefined, &open_choose_head_menu, &close_choose_head_menu);
	lui::addmenuexploders("ChooseHead", localclientnum, array("char_customization", "char_custom_bg"));
	lui::linktocustomcharacter("ChooseHead", localclientnum, "character_customization");
	lui::createcameramenu("ChoosePersonalizationCharacter", localclientnum, "room2_frontend_camera", "ui_cam_char_selection_background", "cam1", undefined, &open_choose_loadout_menu, &close_choose_loadout_menu);
	lui::createcustomextracamxcamdata("ChoosePersonalizationCharacter", localclientnum, 1, &choose_loadout_extracam_watch);
	lui::linktocustomcharacter("ChoosePersonalizationCharacter", localclientnum, "character_customization");
	lui::createcameramenu("ChooseCharacterLoadout", localclientnum, "room2_frontend_camera", "ui_cam_char_selection_background", "cam1", undefined, &open_choose_loadout_menu, &close_choose_loadout_menu);
	lui::linktocustomcharacter("ChooseCharacterLoadout", localclientnum, "character_customization");
	lui::createcameramenu("ChooseGender", localclientnum, "room2_frontend_camera", "ui_cam_char_selection_background", "cam1");
	lui::addmenuexploders("ChooseGender", localclientnum, array("char_customization", "char_custom_bg"));
	lui::linktocustomcharacter("ChooseGender", localclientnum, "character_customization");
	lui::createcameramenu("chooseClass", localclientnum, "spawn_char_cac_choose", "ui_cam_cac_specialist", "cam_specialist", undefined, &open_choose_class, &close_choose_class);
	lui::addmenuexploders("chooseClass", localclientnum, array("char_customization", "lights_paintshop", "weapon_kick", "char_custom_bg"));
	lui::linktocustomcharacter("chooseClass", localclientnum, "character_customization");
	lui::createcustomcameramenu("Paintshop", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("Paintshop", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("Gunsmith", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("Gunsmith", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("MyShowcase", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("MyShowcase", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("Community", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("Community", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("MyShowcase_Paintjobs", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("MyShowcase_Paintjobs", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("MyShowcase_Variants", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("MyShowcase_Variants", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("MyShowcase_Emblems", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("MyShowcase_Emblems", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("MyShowcase_CategorySelector", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("MyShowcase_CategorySelector", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("GroupHeadquarters", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("GroupHeadquarters", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("MediaManager", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("MediaManager", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcameramenu("WeaponBuildKits", localclientnum, "zm_weapon_position", "ui_cam_cac_specialist", "cam_specialist", undefined, &open_zm_bgb, &close_zm_bgb);
	lui::addmenuexploders("WeaponBuildKits", localclientnum, array("zm_weapon_kick", "zm_weapon_room"));
	lui::createcameramenu("CombatRecordWeaponsZM", localclientnum, "zm_weapon_position", "ui_cam_cac_specialist", "cam_specialist", undefined, &open_zm_bgb, &close_zm_bgb);
	lui::addmenuexploders("CombatRecordWeaponsZM", localclientnum, array("zm_weapon_kick", "zm_weapon_room"));
	lui::createcameramenu("BubblegumBuffs", localclientnum, "zm_loadout_position", "c_fe_zm_megachew_vign_camera_2", "c_fe_zm_megachew_vign_camera_2", undefined, &open_zm_bgb, &close_zm_bgb);
	lui::addmenuexploders("BubblegumBuffs", localclientnum, array("zm_gum_kick", "zm_gum_room", "zm_gumball_room_2"));
	playfx(localclientnum, level._effect["bgb_machine_available"], (-2542, 3996, 62) + (64, -1168, 0), anglestoforward(vectorscale((0, 1, 0), 330)), anglestoup(vectorscale((0, 1, 0), 330)));
	lui::createcameramenu("BubblegumPacks", localclientnum, "zm_loadout_position_shift", "c_fe_zm_megachew_vign_camera_2", "c_fe_zm_megachew_vign_camera_2");
	lui::addmenuexploders("BubblegumPacks", localclientnum, array("zm_gum_kick", "zm_gum_room", "zm_gumball_room_2"));
	lui::createcustomcameramenu("BubblegumPackEdit", localclientnum, undefined, undefined, &open_zm_buildkits, &close_zm_buildkits);
	lui::addmenuexploders("BubblegumPackEdit", localclientnum, array("zm_weapon_kick", "zm_weapon_room", "zm_gumball_room_3"));
	lui::createcustomcameramenu("BubblegumBuffSelect", localclientnum, undefined, undefined, &open_zm_buildkits, &close_zm_buildkits);
	lui::addmenuexploders("BubblegumBuffSelect", localclientnum, array("zm_weapon_kick", "zm_weapon_room", "zm_gumball_room_3"));
	lui::createcustomcameramenu("CombatRecordBubblegumBuffs", localclientnum, undefined, undefined, &open_zm_buildkits, &close_zm_buildkits);
	lui::addmenuexploders("CombatRecordBubblegumBuffs", localclientnum, array("zm_weapon_kick", "zm_weapon_room", "zm_gumball_room_3"));
	lui::createcameramenu("MegaChewFactory", localclientnum, "zm_gum_position", "c_fe_zm_megachew_vign_camera", "default", undefined, &open_zm_bgb_factory, &close_zm_bgb_factory);
	lui::addmenuexploders("MegaChewFactory", localclientnum, array("zm_gum_kick", "zm_gum_room"));
	lui::createcustomcameramenu("Pregame_Main", localclientnum, &lobby_main, 1);
	lui::createcameramenu("BlackMarket", localclientnum, "mp_frontend_blackmarket", "ui_cam_frontend_blackmarket", "cam_mpmain", undefined, &open_blackmarket, &close_blackmarket);
	lui::createcustomcameramenu("CombatRecordWeapons", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("CombatRecordWeapons", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("CombatRecordEquipment", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("CombatRecordEquipment", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("CombatRecordCybercore", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("CombatRecordCybercore", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcustomcameramenu("CombatRecordCollectibles", localclientnum, undefined, 0, undefined, undefined);
	lui::addmenuexploders("CombatRecordCollectibles", localclientnum, array("char_customization", "char_custom_bg"));
	lui::createcameramenu("CombatRecordSpecialists", localclientnum, "spawn_char_cac_choose", "ui_cam_cac_specialist", "cam_specialist", undefined, &open_choose_class, &close_choose_class);
	lui::addmenuexploders("CombatRecordSpecialists", localclientnum, array("char_customization", "lights_paintshop", "weapon_kick", "char_custom_bg"));
	lui::linktocustomcharacter("CombatRecordSpecialists", localclientnum, "character_customization");
}

/*
	Name: zombie_eyes_clientfield_cb
	Namespace: frontend
	Checksum: 0x24C5041A
	Offset: 0x3820
	Size: 0x154
	Parameters: 7
	Flags: Linked
*/
function zombie_eyes_clientfield_cb(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!isdefined(newval))
	{
		return;
	}
	if(newval)
	{
		self createzombieeyes(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color());
	}
	else
	{
		self deletezombieeyes(localclientnum);
		self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color());
	}
	if(isdefined(level.zombie_eyes_clientfield_cb_additional))
	{
		self [[level.zombie_eyes_clientfield_cb_additional]](localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump);
	}
}

/*
	Name: get_eyeball_on_luminance
	Namespace: frontend
	Checksum: 0x2BC97A79
	Offset: 0x3980
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_on_luminance()
{
	if(isdefined(level.eyeball_on_luminance_override))
	{
		return level.eyeball_on_luminance_override;
	}
	return 1;
}

/*
	Name: get_eyeball_off_luminance
	Namespace: frontend
	Checksum: 0x40E8B53
	Offset: 0x39A8
	Size: 0x1A
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_off_luminance()
{
	if(isdefined(level.eyeball_off_luminance_override))
	{
		return level.eyeball_off_luminance_override;
	}
	return 0;
}

/*
	Name: get_eyeball_color
	Namespace: frontend
	Checksum: 0xD46C8CE0
	Offset: 0x39D0
	Size: 0x48
	Parameters: 0
	Flags: Linked
*/
function get_eyeball_color()
{
	val = 0;
	if(isdefined(level.zombie_eyeball_color_override))
	{
		val = level.zombie_eyeball_color_override;
	}
	if(isdefined(self.zombie_eyeball_color_override))
	{
		val = self.zombie_eyeball_color_override;
	}
	return val;
}

/*
	Name: createzombieeyes
	Namespace: frontend
	Checksum: 0x9B2D9986
	Offset: 0x3A20
	Size: 0x24
	Parameters: 1
	Flags: Linked
*/
function createzombieeyes(localclientnum)
{
	self thread createzombieeyesinternal(localclientnum);
}

/*
	Name: deletezombieeyes
	Namespace: frontend
	Checksum: 0x94B0992B
	Offset: 0x3A50
	Size: 0x60
	Parameters: 1
	Flags: Linked
*/
function deletezombieeyes(localclientnum)
{
	if(isdefined(self._eyearray))
	{
		if(isdefined(self._eyearray[localclientnum]))
		{
			deletefx(localclientnum, self._eyearray[localclientnum], 1);
			self._eyearray[localclientnum] = undefined;
		}
	}
}

/*
	Name: createzombieeyesinternal
	Namespace: frontend
	Checksum: 0x2CC84229
	Offset: 0x3AB8
	Size: 0x102
	Parameters: 1
	Flags: Linked
*/
function createzombieeyesinternal(localclientnum)
{
	self endon(#"entityshutdown");
	self util::waittill_dobj(localclientnum);
	if(!isdefined(self._eyearray))
	{
		self._eyearray = [];
	}
	if(!isdefined(self._eyearray[localclientnum]))
	{
		linktag = "j_eyeball_le";
		effect = level._effect["eye_glow"];
		if(isdefined(level._override_eye_fx))
		{
			effect = level._override_eye_fx;
		}
		if(isdefined(self._eyeglow_fx_override))
		{
			effect = self._eyeglow_fx_override;
		}
		if(isdefined(self._eyeglow_tag_override))
		{
			linktag = self._eyeglow_tag_override;
		}
		self._eyearray[localclientnum] = playfxontag(localclientnum, effect, self, linktag);
	}
}

/*
	Name: dni_eyes
	Namespace: frontend
	Checksum: 0x42851BED
	Offset: 0x3BC8
	Size: 0x7C
	Parameters: 7
	Flags: Linked
*/
function dni_eyes(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self util::waittill_dobj(localclientnum);
	self mapshaderconstant(localclientnum, 0, "scriptVector0", 0, newval, 0, 0);
}

/*
	Name: blackscreen_watcher
	Namespace: frontend
	Checksum: 0xEDF1D3D6
	Offset: 0x3C50
	Size: 0x140
	Parameters: 0
	Flags: Linked
*/
function blackscreen_watcher()
{
	blackscreenuimodel = createuimodel(getglobaluimodel(), "hideWorldForStreamer");
	setuimodelvalue(blackscreenuimodel, 1);
	while(true)
	{
		level waittill(#"streamer_change", data_struct);
		setuimodelvalue(blackscreenuimodel, 1);
		wait(0.1);
		while(true)
		{
			charready = 1;
			if(isdefined(data_struct))
			{
				charready = character_customization::is_character_streamed(data_struct);
			}
			sceneready = getstreamerrequestprogress(0) >= 100;
			if(charready && sceneready)
			{
				break;
			}
			wait(0.1);
		}
		setuimodelvalue(blackscreenuimodel, 0);
	}
}

/*
	Name: streamer_change
	Namespace: frontend
	Checksum: 0x72781E51
	Offset: 0x3D98
	Size: 0x5E
	Parameters: 2
	Flags: Linked
*/
function streamer_change(hint, data_struct)
{
	if(isdefined(hint))
	{
		setstreamerrequest(0, hint);
	}
	else
	{
		clearstreamerrequest(0);
	}
	level notify(#"streamer_change", data_struct);
}

/*
	Name: plaympherovignettecam
	Namespace: frontend
	Checksum: 0x8E560517
	Offset: 0x3E00
	Size: 0x124
	Parameters: 3
	Flags: Linked
*/
function plaympherovignettecam(localclientnum, data_struct, changed)
{
	fields = getcharacterfields(data_struct.characterindex, 1);
	if(isdefined(fields) && isdefined(fields.frontendvignettestruct) && isdefined(fields.frontendvignettexcam))
	{
		if(isdefined(fields.frontendvignettestreamerhint))
		{
			streamer_change(fields.frontendvignettestreamerhint, data_struct);
		}
		position = struct::get(fields.frontendvignettestruct);
		playmaincamxcam(localclientnum, fields.frontendvignettexcam, 0, "", "", position.origin, position.angles);
	}
}

/*
	Name: handle_inspect_player
	Namespace: frontend
	Checksum: 0x1F5F2BDD
	Offset: 0x3F30
	Size: 0x78
	Parameters: 1
	Flags: Linked
*/
function handle_inspect_player(localclientnum)
{
	level endon(#"disconnect");
	while(true)
	{
		level waittill(#"inspect_player", xuid);
		/#
			assert(isdefined(xuid));
		#/
		level thread update_inspection_character(localclientnum, xuid);
	}
}

/*
	Name: update_inspection_character
	Namespace: frontend
	Checksum: 0x3BC5A391
	Offset: 0x3FB0
	Size: 0x4D4
	Parameters: 2
	Flags: Linked
*/
function update_inspection_character(localclientnum, xuid)
{
	level endon(#"disconnect");
	level endon(#"inspect_player");
	customization = getcharactercustomizationforxuid(localclientnum, xuid);
	while(!isdefined(customization))
	{
		customization = getcharactercustomizationforxuid(localclientnum, xuid);
		wait(1);
	}
	fields = getcharacterfields(customization.charactertype, customization.charactermode);
	params = spawnstruct();
	if(!isdefined(fields))
	{
		fields = spawnstruct();
	}
	params.anim_name = "pb_cac_main_lobby_idle";
	s_scene = struct::get_script_bundle("scene", "sb_frontend_inspection");
	s_align = struct::get(s_scene.aligntarget, "targetname");
	s_params = spawnstruct();
	s_params.scene = s_scene.name;
	data_struct = lui::getcharacterdataformenu("Inspection", localclientnum);
	if(sessionmodeiscampaigngame())
	{
		highestmapreached = getdstat(localclientnum, "highestMapReached");
		data_struct.force_prologue_body = !isdefined(highestmapreached) || highestmapreached == 0 && getdvarstring("mapname") == "core_frontend";
	}
	character_customization::set_character(data_struct, customization.charactertype);
	character_customization::set_character_mode(data_struct, customization.charactermode);
	character_customization::set_body(data_struct, customization.charactermode, customization.charactertype, customization.body.selectedindex, customization.body.colors);
	character_customization::set_head(data_struct, customization.charactermode, customization.head);
	character_customization::set_helmet(data_struct, customization.charactermode, customization.charactertype, customization.helmet.selectedindex, customization.helmet.colors);
	character_customization::set_showcase_weapon(data_struct, customization.charactermode, localclientnum, xuid, customization.charactertype, customization.showcaseweapon.weaponname, customization.showcaseweapon.attachmentinfo, customization.showcaseweapon.weaponrenderoptions, 1, 0);
	if(isdefined(data_struct.anim_name))
	{
		frontend_inspection_scenedef = struct::get_script_bundle("scene", s_scene.name);
		if(frontend_inspection_scenedef.objects.size > 0)
		{
			frontend_inspection_scenedef.objects[0].mainanim = data_struct.anim_name;
		}
	}
	character_customization::update(localclientnum, data_struct, params);
	if(isdefined(data_struct.charactermodel))
	{
		data_struct.charactermodel sethighdetail(1, 1);
	}
}

/*
	Name: entityspawned
	Namespace: frontend
	Checksum: 0xB3EADC6B
	Offset: 0x4490
	Size: 0xC
	Parameters: 1
	Flags: Linked
*/
function entityspawned(localclientnum)
{
}

/*
	Name: localclientconnect
	Namespace: frontend
	Checksum: 0xD891A47A
	Offset: 0x44A8
	Size: 0x2C8
	Parameters: 1
	Flags: Linked
*/
function localclientconnect(localclientnum)
{
	/#
		println("" + localclientnum);
	#/
	setupclientmenus(localclientnum);
	if(isdefined(level.charactercustomizationsetup))
	{
		[[level.charactercustomizationsetup]](localclientnum);
	}
	if(isdefined(level.weaponcustomizationiconsetup))
	{
		[[level.weaponcustomizationiconsetup]](localclientnum);
	}
	level.mp_lobby_data_struct = character_customization::create_character_data_struct(getent(localclientnum, "customization", "targetname"), localclientnum);
	lobbymodel = util::spawn_model(localclientnum, "tag_origin", (0, 0, 0));
	lobbymodel.targetname = "cp_lobby_player_model";
	level.cp_lobby_data_struct = character_customization::create_character_data_struct(lobbymodel, localclientnum);
	character_customization::update_show_helmets(localclientnum, level.cp_lobby_data_struct, 0);
	lobbymodel = util::spawn_model(localclientnum, "tag_origin", (0, 0, 0));
	lobbymodel.targetname = "zm_lobby_player_model";
	level.zm_lobby_data_struct = character_customization::create_character_data_struct(lobbymodel, localclientnum);
	callback::callback(#"hash_da8d7d74", localclientnum);
	customclass::localclientconnect(localclientnum);
	level thread handle_inspect_player(localclientnum);
	customclass::hide_paintshop_bg(localclientnum);
	globalmodel = getglobaluimodel();
	roommodel = createuimodel(globalmodel, "lobbyRoot.room");
	room = getuimodelvalue(roommodel);
	postfx::setfrontendstreamingoverlay(localclientnum, "frontend", 1);
	level.frontendclientconnected = 1;
	level notify("menu_change" + localclientnum, "Main", "opened", room);
}

/*
	Name: onprecachegametype
	Namespace: frontend
	Checksum: 0x99EC1590
	Offset: 0x4778
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onprecachegametype()
{
}

/*
	Name: onstartgametype
	Namespace: frontend
	Checksum: 0x99EC1590
	Offset: 0x4788
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
}

/*
	Name: open_choose_class
	Namespace: frontend
	Checksum: 0x2D0BC83D
	Offset: 0x4798
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function open_choose_class(localclientnum, menu_data)
{
	level thread character_customization::rotation_thread_spawner(localclientnum, menu_data.custom_character, "choose_class_closed" + localclientnum);
}

/*
	Name: close_choose_class
	Namespace: frontend
	Checksum: 0x808CAFE9
	Offset: 0x47F0
	Size: 0x58
	Parameters: 2
	Flags: Linked
*/
function close_choose_class(localclientnum, menu_data)
{
	enablefrontendlockedweaponoverlay(localclientnum, 0);
	enablefrontendtokenlockedweaponoverlay(localclientnum, 0);
	level notify("choose_class_closed" + localclientnum);
}

/*
	Name: open_zm_buildkits
	Namespace: frontend
	Checksum: 0xFDBFF992
	Offset: 0x4850
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function open_zm_buildkits(localclientnum, menu_data)
{
	level.weapon_position = struct::get("zm_loadout_gumball");
}

/*
	Name: close_zm_buildkits
	Namespace: frontend
	Checksum: 0xC4F33B46
	Offset: 0x4890
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function close_zm_buildkits(localclientnum, menu_data)
{
	level.weapon_position = struct::get("paintshop_weapon_position");
}

/*
	Name: open_zm_bgb
	Namespace: frontend
	Checksum: 0xD5C9B0CD
	Offset: 0x48D0
	Size: 0xBC
	Parameters: 2
	Flags: Linked
*/
function open_zm_bgb(localclientnum, menu_data)
{
	level.n_old_spotshadow = getdvarint("r_maxSpotShadowUpdates");
	setdvar("r_maxSpotShadowUpdates", 24);
	level.weapon_position = struct::get(menu_data.target_name);
	playradiantexploder(localclientnum, "zm_gum_room");
	playradiantexploder(localclientnum, "zm_gum_kick");
}

/*
	Name: close_zm_bgb
	Namespace: frontend
	Checksum: 0xE54FFAEC
	Offset: 0x4998
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function close_zm_bgb(localclientnum, menu_data)
{
	level.weapon_position = struct::get("paintshop_weapon_position");
	killradiantexploder(localclientnum, "zm_gum_room");
	killradiantexploder(localclientnum, "zm_gum_kick");
	setdvar("r_maxSpotShadowUpdates", level.n_old_spotshadow);
	enablefrontendlockedweaponoverlay(localclientnum, 0);
	enablefrontendtokenlockedweaponoverlay(localclientnum, 0);
}

/*
	Name: open_zm_bgb_factory
	Namespace: frontend
	Checksum: 0xE1167765
	Offset: 0x4A68
	Size: 0x114
	Parameters: 2
	Flags: Linked
*/
function open_zm_bgb_factory(localclientnum, menu_data)
{
	level.n_old_spotshadow = getdvarint("r_maxSpotShadowUpdates");
	setdvar("r_maxSpotShadowUpdates", 24);
	level.weapon_position = struct::get(menu_data.target_name);
	playradiantexploder(localclientnum, "zm_gum_room");
	playradiantexploder(localclientnum, "zm_gum_kick");
	if(!isdefined(level.o_megachewfactory))
	{
		level.o_megachewfactory = new cmegachewfactory();
		[[ level.o_megachewfactory ]]->init(localclientnum);
	}
	level thread wait_for_mega_chew_notifies(localclientnum, menu_data);
}

/*
	Name: close_zm_bgb_factory
	Namespace: frontend
	Checksum: 0xCF5B18D4
	Offset: 0x4B88
	Size: 0xC4
	Parameters: 2
	Flags: Linked
*/
function close_zm_bgb_factory(localclientnum, menu_data)
{
	level.weapon_position = struct::get("paintshop_weapon_position");
	killradiantexploder(localclientnum, "zm_gum_room");
	killradiantexploder(localclientnum, "zm_gum_kick");
	setdvar("r_maxSpotShadowUpdates", level.n_old_spotshadow);
	enablefrontendlockedweaponoverlay(localclientnum, 0);
	enablefrontendtokenlockedweaponoverlay(localclientnum, 0);
}

/*
	Name: play_crate_anims
	Namespace: frontend
	Checksum: 0x81A80B0D
	Offset: 0x4C58
	Size: 0x26C
	Parameters: 2
	Flags: Linked
*/
function play_crate_anims(localclientnum, type)
{
	level endon(#"blackmarket_crate_reset");
	level endon(#"wait_for_black_market_notifies");
	level endon(#"disconnect");
	level endon(#"blackmarket_closed");
	delay_before_crate_open = 0.5;
	delay_before_lights_on = 0.01;
	if(level.blackmarket_exploder != "")
	{
		exploder::stop_exploder(level.blackmarket_exploder);
	}
	wait(delay_before_lights_on);
	tintindex = 0;
	if(type == "common")
	{
		tintindex = 0;
		level.blackmarket_exploder = "exploder_blackmarket_crate_common";
	}
	else
	{
		if(type == "rare")
		{
			tintindex = 1;
			level.blackmarket_exploder = "exploder_blackmarket_crate_rare";
		}
		else
		{
			if(type == "legendary")
			{
				tintindex = 2;
				level.blackmarket_exploder = "exploder_blackmarket_crate_legendary";
			}
			else if(type == "epic")
			{
				tintindex = 3;
				level.blackmarket_exploder = "exploder_blackmarket_crate_epic";
			}
		}
	}
	self mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 1, tintindex, 0);
	wait(delay_before_crate_open - delay_before_lights_on);
	if(type != "common")
	{
		playsound(localclientnum, "uin_bm_chest_open_sparks");
	}
	exploder::exploder(level.blackmarket_exploder);
	self clearanim("o_loot_crate_idle", 0);
	self animation::play("o_loot_crate_open", undefined, undefined, 1, 0, 0, 0, 0);
	self animation::play("o_loot_crate_idle", undefined, undefined, 1, 0, 0, 0, 0);
}

/*
	Name: wait_for_black_market_notifies
	Namespace: frontend
	Checksum: 0xE7D8D5FE
	Offset: 0x4ED0
	Size: 0x35A
	Parameters: 1
	Flags: Linked
*/
function wait_for_black_market_notifies(localclientnum)
{
	level notify(#"wait_for_black_market_notifies");
	level endon(#"wait_for_black_market_notifies");
	level endon(#"disconnect");
	level endon(#"blackmarket_closed");
	camera_ent = struct::get("mp_frontend_blackmarket");
	crate = getent(localclientnum, "mp_frontend_blackmarket_crate", "targetname");
	crate useanimtree($generic);
	crate clearanim("o_loot_crate_idle", 0);
	crate mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
	if(level.blackmarket_exploder != "")
	{
		exploder::stop_exploder(level.blackmarket_exploder);
		level.blackmarket_exploder = "";
	}
	while(true)
	{
		level waittill(#"blackmarket", param1, param2);
		if(param1 == "crate_camera")
		{
			playmaincamxcam(localclientnum, "ui_cam_frontend_crate_in", 0, "cam_crate_in", "", camera_ent.origin, camera_ent.angles);
			crate thread play_crate_anims(localclientnum, param2);
		}
		else
		{
			if(param1 == "normal_camera")
			{
				level notify(#"blackmarket_crate_reset");
				crate clearanim("o_loot_crate_idle", 0);
				crate mapshaderconstant(localclientnum, 0, "scriptVector2", 0, 0, 0, 0);
				if(level.blackmarket_exploder != "")
				{
					exploder::stop_exploder(level.blackmarket_exploder);
					level.blackmarket_exploder = "";
				}
				playmaincamxcam(localclientnum, "ui_cam_frontend_blackmarket", 0, "cam_mpmain", "", camera_ent.origin, camera_ent.angles);
			}
			else
			{
				if(param1 == "cycle_start")
				{
					level.cyclehandle = crate playloopsound("uin_bm_cycle_loop");
				}
				else if(param1 == "cycle_stop" && isdefined(level.cyclehandle))
				{
					crate stoploopsound(level.cyclehandle);
					level.cyclehandle = undefined;
				}
			}
		}
	}
}

/*
	Name: open_blackmarket
	Namespace: frontend
	Checksum: 0x313E76F3
	Offset: 0x5238
	Size: 0x11C
	Parameters: 2
	Flags: Linked
*/
function open_blackmarket(localclientnum, menu_data)
{
	level.blackmarket_exploder = "";
	streamer_change("core_frontend_blackmarket");
	if(ispc())
	{
		level.r_volumetric_lighting_lights_skip_samples = getdvarint("r_volumetric_lighting_lights_skip_samples");
		level.r_volumetric_lighting_max_spot_samples = getdvarint("r_volumetric_lighting_max_spot_samples");
	}
	setdvar("r_volumetric_lighting_upsample_depth_threshold", 0.001);
	setdvar("r_volumetric_lighting_blur_depth_threshold", 1300);
	setdvar("r_volumetric_lighting_lights_skip_samples", 0);
	setdvar("r_volumetric_lighting_max_spot_samples", 40);
	level thread wait_for_black_market_notifies(localclientnum);
}

/*
	Name: close_blackmarket
	Namespace: frontend
	Checksum: 0x6EDAD874
	Offset: 0x5360
	Size: 0x152
	Parameters: 2
	Flags: Linked
*/
function close_blackmarket(localclientnum, menu_data)
{
	setdvar("r_volumetric_lighting_upsample_depth_threshold", 0.01);
	setdvar("r_volumetric_lighting_blur_depth_threshold", 2000);
	setdvar("r_volumetric_lighting_lights_skip_samples", 1);
	setdvar("r_volumetric_lighting_max_spot_samples", 8);
	if(ispc())
	{
		setdvar("r_volumetric_lighting_lights_skip_samples", level.r_volumetric_lighting_lights_skip_samples);
		setdvar("r_volumetric_lighting_max_spot_samples", level.r_volumetric_lighting_max_spot_samples);
	}
	if(isdefined(level.cyclehandle))
	{
		crate = getent(localclientnum, "mp_frontend_blackmarket_crate", "targetname");
		crate stoploopsound(level.cyclehandle);
		level.cyclehandle = undefined;
	}
	level notify(#"blackmarket_closed");
}

/*
	Name: disablemegachewfactoryinput
	Namespace: frontend
	Checksum: 0xFA90CC73
	Offset: 0x54C0
	Size: 0x64
	Parameters: 1
	Flags: Linked
*/
function disablemegachewfactoryinput(localclientnum)
{
	disableinputmodel = getuimodel(getuimodelforcontroller(localclientnum), "MegaChewFactory.disableInput");
	setuimodelvalue(disableinputmodel, 1);
}

/*
	Name: enablemegachewfactoryinput
	Namespace: frontend
	Checksum: 0xB35DA9E3
	Offset: 0x5530
	Size: 0x84
	Parameters: 1
	Flags: Linked
*/
function enablemegachewfactoryinput(localclientnum)
{
	level util::waittill_any_timeout(17, "megachew_factory_cycle_complete");
	disableinputmodel = getuimodel(getuimodelforcontroller(localclientnum), "MegaChewFactory.disableInput");
	setuimodelvalue(disableinputmodel, 0);
}

/*
	Name: wait_for_reset_megachew_factory
	Namespace: frontend
	Checksum: 0x9ED363CA
	Offset: 0x55C0
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function wait_for_reset_megachew_factory(localclientnum)
{
	level endon(#"wait_for_mega_chew_notifies");
	level endon(#"disconnect");
	while(true)
	{
		level waittill(#"resetmegachewfactory");
		[[ level.o_megachewfactory ]]->reset_megachew_factory(localclientnum);
	}
}

/*
	Name: wait_for_remaining_token_notifies
	Namespace: frontend
	Checksum: 0xBB9E08D3
	Offset: 0x5620
	Size: 0x124
	Parameters: 1
	Flags: Linked
*/
function wait_for_remaining_token_notifies(localclientnum)
{
	level endon(#"wait_for_mega_chew_notifies");
	level endon(#"disconnect");
	level endon(#"megachewfactory_closed");
	n_vials = getuimodelvalue(createuimodel(getglobaluimodel(), "MegaChewFactoryVialDisplay"));
	if(isdefined(n_vials))
	{
		[[ level.o_megachewfactory ]]->update_token_count(n_vials);
		[[ level.o_megachewfactory ]]->update_token_display_counter(localclientnum, 1);
	}
	while(true)
	{
		level waittill(#"mega_chew_remaining_tokens", n_tokens);
		if(n_tokens > 999)
		{
			n_tokens = 999;
		}
		[[ level.o_megachewfactory ]]->update_token_count(n_tokens);
		[[ level.o_megachewfactory ]]->update_token_display_counter(localclientnum, 1);
	}
}

/*
	Name: dolootquery
	Namespace: frontend
	Checksum: 0x44504C94
	Offset: 0x5750
	Size: 0x136
	Parameters: 2
	Flags: Linked
*/
function dolootquery(controllerindex, n_tokens)
{
	controllermodel = getuimodelforcontroller(controllerindex);
	megachewfactorymodel = getuimodel(controllermodel, "MegaChewFactory");
	lootquerymodel = createuimodel(megachewfactorymodel, "queryLoot");
	lootqueryresultmodel = createuimodel(megachewfactorymodel, "lootQueryResult");
	setuimodelvalue(lootqueryresultmodel, 0);
	setuimodelvalue(lootquerymodel, n_tokens);
	level util::waittill_any_timeout(5, "loot_query_result_ready");
	result = getuimodelvalue(lootqueryresultmodel);
	return isdefined(result) && result;
}

/*
	Name: wait_for_mega_chew_notifies
	Namespace: frontend
	Checksum: 0x14766B
	Offset: 0x5890
	Size: 0x1D6
	Parameters: 2
	Flags: Linked
*/
function wait_for_mega_chew_notifies(localclientnum, menu_data)
{
	level notify(#"wait_for_mega_chew_notifies");
	level endon(#"wait_for_mega_chew_notifies");
	level endon(#"disconnect");
	level endon(#"megachewfactory_closed");
	[[ level.o_megachewfactory ]]->set_megachew_factory_anim_state(localclientnum, 0);
	level thread wait_for_remaining_token_notifies(localclientnum);
	level thread wait_for_reset_megachew_factory(localclientnum);
	while(true)
	{
		level waittill(#"mega_chew_update", event, index, controllerindex);
		switch(event)
		{
			case "focus_changed":
			{
				[[ level.o_megachewfactory ]]->change_button_selected(localclientnum, index);
				break;
			}
			case "selected":
			{
				/#
					iprintlnbold("" + index);
					println("" + index);
				#/
				break;
			}
			case "purchased":
			{
				if(!dolootquery(controllerindex, index))
				{
					break;
				}
				disablemegachewfactoryinput(controllerindex);
				thread enablemegachewfactoryinput(controllerindex);
				[[ level.o_megachewfactory ]]->activate(localclientnum, index);
				break;
			}
		}
	}
}

/*
	Name: open_character_menu
	Namespace: frontend
	Checksum: 0x63AFFC39
	Offset: 0xD5C8
	Size: 0x6C
	Parameters: 2
	Flags: None
*/
function open_character_menu(localclientnum, menu_data)
{
	character_ent = getent(localclientnum, menu_data.target_name, "targetname");
	if(isdefined(character_ent))
	{
		character_ent show();
	}
}

/*
	Name: close_character_menu
	Namespace: frontend
	Checksum: 0xAB4F9133
	Offset: 0xD640
	Size: 0x6C
	Parameters: 2
	Flags: None
*/
function close_character_menu(localclientnum, menu_data)
{
	character_ent = getent(localclientnum, menu_data.target_name, "targetname");
	if(isdefined(character_ent))
	{
		character_ent hide();
	}
}

/*
	Name: choose_loadout_extracam_watch
	Namespace: frontend
	Checksum: 0x51242BEE
	Offset: 0xD6B8
	Size: 0x182
	Parameters: 3
	Flags: Linked
*/
function choose_loadout_extracam_watch(localclientnum, menu_name, extracam_data)
{
	level endon(menu_name + "_closed");
	while(true)
	{
		params = spawnstruct();
		character_customization::get_current_frozen_moment_params(localclientnum, level.liveccdata[localclientnum], params);
		if(isdefined(params.align_struct))
		{
			camera_ent = multi_extracam::extracam_init_item(localclientnum, params.align_struct, extracam_data.extracam_index);
			if(isdefined(camera_ent) && isdefined(params.xcam))
			{
				if(isdefined(params.xcamframe))
				{
					camera_ent playextracamxcam(params.xcam, 0, params.subxcam, params.xcamframe);
				}
				else
				{
					camera_ent playextracamxcam(params.xcam, 0, params.subxcam);
				}
			}
		}
		level waittill("frozenMomentChanged" + localclientnum);
	}
}

/*
	Name: open_choose_loadout_menu
	Namespace: frontend
	Checksum: 0x8813172F
	Offset: 0xD848
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function open_choose_loadout_menu(localclientnum, menu_data)
{
	menu_data.custom_character.charactermode = 1;
	character_customization::update_use_frozen_moments(localclientnum, menu_data.custom_character, 1);
}

/*
	Name: close_choose_loadout_menu
	Namespace: frontend
	Checksum: 0x7B799334
	Offset: 0xD8A8
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function close_choose_loadout_menu(localclientnum, menu_data)
{
	character_customization::update_use_frozen_moments(localclientnum, menu_data.custom_character, 0);
}

/*
	Name: start_character_rotating_any
	Namespace: frontend
	Checksum: 0x2F557B9E
	Offset: 0xD8F0
	Size: 0x66
	Parameters: 2
	Flags: Linked
*/
function start_character_rotating_any(localclientnum, menu_data)
{
	maxlocalclient = getmaxlocalclients();
	while(localclientnum < maxlocalclient)
	{
		start_character_rotating(localclientnum, menu_data);
		localclientnum++;
	}
}

/*
	Name: end_character_rotating_any
	Namespace: frontend
	Checksum: 0x1FB08E79
	Offset: 0xD960
	Size: 0x66
	Parameters: 2
	Flags: Linked
*/
function end_character_rotating_any(localclientnum, menu_data)
{
	maxlocalclient = getmaxlocalclients();
	while(localclientnum < maxlocalclient)
	{
		end_character_rotating(localclientnum, menu_data);
		localclientnum++;
	}
}

/*
	Name: start_character_rotating
	Namespace: frontend
	Checksum: 0x544BABCF
	Offset: 0xD9D0
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function start_character_rotating(localclientnum, menu_data)
{
	level thread character_customization::rotation_thread_spawner(localclientnum, menu_data.custom_character, "end_character_rotating" + localclientnum);
}

/*
	Name: end_character_rotating
	Namespace: frontend
	Checksum: 0x524D3E7C
	Offset: 0xDA28
	Size: 0x28
	Parameters: 2
	Flags: Linked
*/
function end_character_rotating(localclientnum, menu_data)
{
	level notify("end_character_rotating" + localclientnum);
}

/*
	Name: move_mp_character_to_inspect_room
	Namespace: frontend
	Checksum: 0x5E3DC3B6
	Offset: 0xDA58
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function move_mp_character_to_inspect_room(localclientnum, menu_data)
{
	character_customization::set_character_align(localclientnum, menu_data.custom_character, "spawn_char_lobbyslide");
}

/*
	Name: move_mp_character_from_inspect_room
	Namespace: frontend
	Checksum: 0xF02C30FF
	Offset: 0xDAA0
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function move_mp_character_from_inspect_room(localclientnum, menu_data)
{
	character_customization::set_character_align(localclientnum, menu_data.custom_character, undefined);
}

/*
	Name: open_choose_head_menu
	Namespace: frontend
	Checksum: 0x4F965C33
	Offset: 0xDAE8
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function open_choose_head_menu(localclientnum, menu_data)
{
	character_customization::update_show_helmets(localclientnum, menu_data.custom_character, 0);
	level notify(#"begin_personalizing_hero");
}

/*
	Name: close_choose_head_menu
	Namespace: frontend
	Checksum: 0xDA209402
	Offset: 0xDB40
	Size: 0x4A
	Parameters: 2
	Flags: Linked
*/
function close_choose_head_menu(localclientnum, menu_data)
{
	character_customization::update_show_helmets(localclientnum, menu_data.custom_character, 1);
	level notify(#"done_personalizing_hero");
}

/*
	Name: personalize_characters_watch
	Namespace: frontend
	Checksum: 0x5B7E11B
	Offset: 0xDB98
	Size: 0x1DA
	Parameters: 2
	Flags: Linked
*/
function personalize_characters_watch(localclientnum, menu_name)
{
	level endon(#"disconnect");
	level endon(menu_name + "_closed");
	s_cam = struct::get("personalizeHero_camera", "targetname");
	/#
		assert(isdefined(s_cam));
	#/
	animtime = 0;
	while(true)
	{
		level waittill("camera_change" + localclientnum, pose);
		if(pose === "exploring")
		{
			playmaincamxcam(localclientnum, "ui_cam_character_customization", animtime, "cam_preview", "", s_cam.origin, s_cam.angles);
		}
		else
		{
			if(pose === "inspecting_helmet")
			{
				playmaincamxcam(localclientnum, "ui_cam_character_customization", animtime, "cam_helmet", "", s_cam.origin, s_cam.angles);
			}
			else if(pose === "inspecting_body")
			{
				playmaincamxcam(localclientnum, "ui_cam_character_customization", animtime, "cam_select", "", s_cam.origin, s_cam.angles);
			}
		}
		animtime = 300;
	}
}

/*
	Name: choose_taunts_camera_watch
	Namespace: frontend
	Checksum: 0xCF67AD87
	Offset: 0xDD80
	Size: 0x258
	Parameters: 2
	Flags: Linked
*/
function choose_taunts_camera_watch(localclientnum, menu_name)
{
	s_cam = struct::get("personalizeHero_camera", "targetname");
	/#
		assert(isdefined(s_cam));
	#/
	playmaincamxcam(localclientnum, "ui_cam_character_customization", 300, "cam_topscorers", "", s_cam.origin, s_cam.angles);
	data_struct = lui::getcharacterdataformenu(menu_name, localclientnum);
	data_struct.charactermodel.anglesoverride = 1;
	data_struct.charactermodel.angles = vectorscale((0, 1, 0), 112);
	end_game_taunts::stream_epic_models();
	level waittill(menu_name + "_closed");
	end_game_taunts::stop_stream_epic_models();
	end_game_taunts::deletecameraglass(undefined);
	params = spawnstruct();
	params.anim_name = "pb_cac_main_lobby_idle";
	params.sessionmode = 1;
	character_customization::loadequippedcharacteronmodel(localclientnum, data_struct, data_struct.characterindex, params);
	playmaincamxcam(localclientnum, "ui_cam_character_customization", 300, "cam_preview", "", s_cam.origin, s_cam.angles);
	data_struct.charactermodel.angles = data_struct.angles;
	wait(0.3);
	data_struct.charactermodel.anglesoverride = 0;
}

/*
	Name: cp_lobby_room
	Namespace: frontend
	Checksum: 0xA6F7B984
	Offset: 0xDFE0
	Size: 0xBB2
	Parameters: 1
	Flags: Linked
*/
function cp_lobby_room(localclientnum)
{
	level endon(#"new_lobby");
	while(true)
	{
		str_queued_level = getdvarstring("ui_mapname");
		if(util::is_safehouse(str_queued_level))
		{
			str_safehouse = str_queued_level;
		}
		else
		{
			str_safehouse = util::get_next_safehouse(str_queued_level);
		}
		str_safehouse = getsubstr(str_safehouse, "cp_sh_".size);
		/#
			printtoprightln("" + str_queued_level, (1, 1, 1));
			str_debug_safehouse = getdvarstring("", "");
			if(str_debug_safehouse != "")
			{
				str_safehouse = str_debug_safehouse;
			}
		#/
		level.a_str_bunk_scenes = [];
		if(!isdefined(level.a_str_bunk_scenes))
		{
			level.a_str_bunk_scenes = [];
		}
		else if(!isarray(level.a_str_bunk_scenes))
		{
			level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
		}
		level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = "cp_cac_cp_lobby_idle_" + str_safehouse;
		if(!isdefined(level.a_str_bunk_scenes))
		{
			level.a_str_bunk_scenes = [];
		}
		else if(!isarray(level.a_str_bunk_scenes))
		{
			level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
		}
		level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = "cin_fe_cp_bunk_vign_smoke_read_" + str_safehouse;
		if(!isdefined(level.a_str_bunk_scenes))
		{
			level.a_str_bunk_scenes = [];
		}
		else if(!isarray(level.a_str_bunk_scenes))
		{
			level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
		}
		level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = "cin_fe_cp_desk_vign_work_" + str_safehouse;
		if(!isdefined(level.a_str_bunk_scenes))
		{
			level.a_str_bunk_scenes = [];
		}
		else if(!isarray(level.a_str_bunk_scenes))
		{
			level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
		}
		level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = "cin_fe_cp_desk_vign_type_" + str_safehouse;
		if(isdefined(level.a_str_bunk_scene_exploders))
		{
			for(i = 0; i < level.a_str_bunk_scene_exploders.size; i++)
			{
				killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
			}
		}
		level.a_str_bunk_scene_exploders = [];
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "cp_frontend_idle";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "cp_frontend_read";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "cp_frontend_work";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "cp_frontend_type";
		level.a_str_bunk_scene_hints = [];
		if(!isdefined(level.a_str_bunk_scene_hints))
		{
			level.a_str_bunk_scene_hints = [];
		}
		else if(!isarray(level.a_str_bunk_scene_hints))
		{
			level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
		}
		level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cp_frontend_idle";
		if(!isdefined(level.a_str_bunk_scene_hints))
		{
			level.a_str_bunk_scene_hints = [];
		}
		else if(!isarray(level.a_str_bunk_scene_hints))
		{
			level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
		}
		level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cp_frontend_read";
		if(!isdefined(level.a_str_bunk_scene_hints))
		{
			level.a_str_bunk_scene_hints = [];
		}
		else if(!isarray(level.a_str_bunk_scene_hints))
		{
			level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
		}
		level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cp_frontend_work";
		if(!isdefined(level.a_str_bunk_scene_hints))
		{
			level.a_str_bunk_scene_hints = [];
		}
		else if(!isarray(level.a_str_bunk_scene_hints))
		{
			level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
		}
		level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cp_frontend_type";
		if(!isdefined(level.n_cp_index))
		{
			if(level clientfield::get("first_time_flow"))
			{
				level.n_cp_index = 0;
				/#
					printtoprightln("", (1, 1, 1));
				#/
			}
			else
			{
				if(level clientfield::get("cp_bunk_anim_type") == 0)
				{
					level.n_cp_index = randomintrange(0, 2);
					/#
						printtoprightln("", (1, 1, 1));
					#/
				}
				else if(level clientfield::get("cp_bunk_anim_type") == 1)
				{
					level.n_cp_index = randomintrange(2, 4);
					/#
						printtoprightln("", (1, 1, 1));
					#/
				}
			}
		}
		/#
			if(getdvarint("", 0))
			{
				if(!isdefined(level.cp_debug_index))
				{
					level.cp_debug_index = level.n_cp_index;
				}
				level.cp_debug_index++;
				if(level.cp_debug_index == level.a_str_bunk_scenes.size)
				{
					level.cp_debug_index = 0;
				}
				level.n_cp_index = level.cp_debug_index;
			}
		#/
		s_scene = struct::get_script_bundle("scene", level.a_str_bunk_scenes[level.n_cp_index]);
		str_gender = getherogender(getequippedheroindex(localclientnum, 2), "cp");
		if(str_gender === "female" && isdefined(s_scene.femalebundle))
		{
			s_scene = struct::get_script_bundle("scene", s_scene.femalebundle);
		}
		/#
			printtoprightln(s_scene.name, (1, 1, 1));
		#/
		s_align = struct::get(s_scene.aligntarget, "targetname");
		playmaincamxcam(localclientnum, s_scene.cameraswitcher, 0, "", "", s_align.origin, s_align.angles);
		for(i = 0; i < level.a_str_bunk_scenes.size; i++)
		{
			if(i == level.n_cp_index)
			{
				playradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
				continue;
			}
			killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
		}
		s_params = spawnstruct();
		s_params.scene = s_scene.name;
		s_params.sessionmode = 2;
		character_customization::loadequippedcharacteronmodel(localclientnum, level.cp_lobby_data_struct, undefined, s_params);
		streamer_change(level.a_str_bunk_scene_hints[level.n_cp_index], level.cp_lobby_data_struct);
		setpbgactivebank(localclientnum, 1);
		/#
			if(getdvarint("", 0))
			{
				level.n_cp_index = undefined;
			}
		#/
		do
		{
			wait(0.016);
			str_queued_level_new = getdvarstring("ui_mapname");
		}
		while(str_queued_level_new == str_queued_level);
	}
}

/*
	Name: cpzm_lobby_room
	Namespace: frontend
	Checksum: 0xEC7A07DD
	Offset: 0xEBA0
	Size: 0xC5E
	Parameters: 1
	Flags: Linked
*/
function cpzm_lobby_room(localclientnum)
{
	str_safehouse = level.str_current_safehouse;
	/#
		str_debug_safehouse = getdvarstring("", "");
		if(str_debug_safehouse != "")
		{
			str_safehouse = str_debug_safehouse;
		}
	#/
	level.a_str_bunk_scenes = [];
	level.active_str_cpzm_scene = ("zm_cp_" + str_safehouse) + "_lobby_idle";
	if(!isdefined(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = [];
	}
	else if(!isarray(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
	}
	level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = level.active_str_cpzm_scene;
	if(isdefined(level.a_str_bunk_scene_exploders))
	{
		for(i = 0; i < level.a_str_bunk_scene_exploders.size; i++)
		{
			killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
		}
	}
	level.a_str_bunk_scene_exploders = [];
	if(str_safehouse == "cairo")
	{
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
	}
	else
	{
		if(str_safehouse == "mobile")
		{
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
		}
		else
		{
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
		}
	}
	level.a_str_bunk_scene_hints = [];
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	level.n_cp_index = 0;
	setpbgactivebank(localclientnum, 2);
	s_scene = struct::get_script_bundle("scene", level.a_str_bunk_scenes[level.n_cp_index]);
	str_gender = getherogender(getequippedheroindex(localclientnum, 2), "cp");
	if(str_gender === "female" && isdefined(s_scene.femalebundle))
	{
		s_scene = struct::get_script_bundle("scene", s_scene.femalebundle);
	}
	/#
		printtoprightln(s_scene.name, (1, 1, 1));
	#/
	s_align = struct::get(s_scene.aligntarget, "targetname");
	playmaincamxcam(localclientnum, s_scene.cameraswitcher, 0, "", "", s_align.origin, s_align.angles);
	for(i = 0; i < level.a_str_bunk_scenes.size; i++)
	{
		if(i == level.n_cp_index)
		{
			if(getdvarint("tu6_ffotd_zombieSpecialDayEffectsClient"))
			{
				switch(level.a_str_bunk_scene_exploders[i])
				{
					case "fx_frontend_zombie_fog_mobile":
					case "zm_bonus_idle":
					{
						position = (-1269, 1178, 562);
						break;
					}
					case "fx_frontend_zombie_fog_singapore":
					{
						position = (-1273, 1180, 320);
						break;
					}
					case "fx_frontend_zombie_fog_cairo":
					{
						position = (-1256, 1235, 61);
						break;
					}
				}
				level.frontendspecialfx = playfx(localclientnum, level._effect["frontend_special_day"], position);
			}
			playradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
			continue;
		}
		killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
	}
	s_params = spawnstruct();
	s_params.scene = s_scene.name;
	s_params.sessionmode = 2;
	female = 1;
	loadcpzmcharacteronmodel(localclientnum, level.cp_lobby_data_struct, female, s_params);
	streamer_change(level.a_str_bunk_scene_hints[level.n_cp_index], level.cp_lobby_data_struct);
	/#
		if(getdvarint("", 0))
		{
			level.n_cp_index = undefined;
		}
	#/
}

/*
	Name: doa_lobby_room_effects_cigar_inhale
	Namespace: frontend
	Checksum: 0x7F37E4F6
	Offset: 0xF808
	Size: 0x60
	Parameters: 2
	Flags: Linked
*/
function doa_lobby_room_effects_cigar_inhale(localclientnum, cigar)
{
	if(self != cigar)
	{
		return;
	}
	cigar.fx_inhale_id = playfxontag(localclientnum, level._effect["doa_frontend_cigar_lit"], self, "tag_fx_smoke");
}

/*
	Name: doa_lobby_room_effects_cigar_puff
	Namespace: frontend
	Checksum: 0x1304AA
	Offset: 0xF870
	Size: 0x60
	Parameters: 2
	Flags: Linked
*/
function doa_lobby_room_effects_cigar_puff(localclientnum, cigar)
{
	if(self != cigar)
	{
		return;
	}
	cigar.fx__puff_id = playfxontag(localclientnum, level._effect["doa_frontend_cigar_puff"], self, "tag_fx_smoke");
}

/*
	Name: doa_lobby_room_effects_cigar_flick
	Namespace: frontend
	Checksum: 0x8F73DC49
	Offset: 0xF8D8
	Size: 0x60
	Parameters: 2
	Flags: Linked
*/
function doa_lobby_room_effects_cigar_flick(localclientnum, cigar)
{
	if(self != cigar)
	{
		return;
	}
	cigar.fx__flick_id = playfxontag(localclientnum, level._effect["doa_frontend_cigar_ash"], self, "tag_fx_smoke");
}

/*
	Name: doa_lobby_room_effects_ape_exhale
	Namespace: frontend
	Checksum: 0xC5A2765D
	Offset: 0xF940
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function doa_lobby_room_effects_ape_exhale(localclientnum, ape)
{
	if(self != ape)
	{
		return;
	}
	playfxontag(localclientnum, level._effect["doa_frontend_cigar_exhale"], self, "tag_inhand");
}

/*
	Name: doa_lobby_room_effects
	Namespace: frontend
	Checksum: 0x23F3067C
	Offset: 0xF9A0
	Size: 0x1C4
	Parameters: 2
	Flags: Linked
*/
function doa_lobby_room_effects(a_ents, localclientnum)
{
	level._animnotetrackhandlers["inhale"] = undefined;
	level._animnotetrackhandlers["puff"] = undefined;
	level._animnotetrackhandlers["flick"] = undefined;
	level._animnotetrackhandlers["exhale"] = undefined;
	cigar = a_ents["cigar"];
	if(isdefined(cigar.fx_ambient_id))
	{
		stopfx(localclientnum, cigar.fx_ambient_id);
	}
	cigar.fx_ambient_id = playfxontag(localclientnum, level._effect["doa_frontend_cigar_ambient"], cigar, "tag_fx_smoke");
	animation::add_global_notetrack_handler("inhale", &doa_lobby_room_effects_cigar_inhale, localclientnum, cigar);
	animation::add_global_notetrack_handler("puff", &doa_lobby_room_effects_cigar_puff, localclientnum, cigar);
	animation::add_global_notetrack_handler("flick", &doa_lobby_room_effects_cigar_flick, localclientnum, cigar);
	ape = a_ents["zombie"];
	animation::add_global_notetrack_handler("exhale", &doa_lobby_room_effects_ape_exhale, localclientnum, ape);
}

/*
	Name: doa_lobby_room
	Namespace: frontend
	Checksum: 0x2382A458
	Offset: 0xFB70
	Size: 0x764
	Parameters: 1
	Flags: Linked
*/
function doa_lobby_room(localclientnum)
{
	str_safehouse = "mobile";
	level.a_str_bunk_scenes = [];
	level.active_str_cpzm_scene = ("zm_doa_" + str_safehouse) + "_lobby_idle";
	if(!isdefined(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = [];
	}
	else if(!isarray(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
	}
	level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = level.active_str_cpzm_scene;
	if(isdefined(level.a_str_bunk_scene_exploders))
	{
		for(i = 0; i < level.a_str_bunk_scene_exploders.size; i++)
		{
			killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
		}
	}
	level.a_str_bunk_scene_exploders = [];
	if(!isdefined(level.a_str_bunk_scene_exploders))
	{
		level.a_str_bunk_scene_exploders = [];
	}
	else if(!isarray(level.a_str_bunk_scene_exploders))
	{
		level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
	}
	level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "zm_bonus_idle";
	level.a_str_bunk_scene_hints = [];
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	level.n_cp_index = 0;
	setpbgactivebank(localclientnum, 2);
	s_scene = struct::get_script_bundle("scene", level.a_str_bunk_scenes[level.n_cp_index]);
	str_gender = getherogender(getequippedheroindex(localclientnum, 2), "cp");
	if(str_gender === "female" && isdefined(s_scene.femalebundle))
	{
		s_scene = struct::get_script_bundle("scene", s_scene.femalebundle);
	}
	/#
		printtoprightln(s_scene.name, (1, 1, 1));
	#/
	s_align = struct::get(s_scene.aligntarget, "targetname");
	playmaincamxcam(localclientnum, s_scene.cameraswitcher, 0, "", "", s_align.origin, s_align.angles);
	for(i = 0; i < level.a_str_bunk_scenes.size; i++)
	{
		if(i == level.n_cp_index)
		{
			if(getdvarint("tu6_ffotd_zombieSpecialDayEffectsClient"))
			{
				switch(level.a_str_bunk_scene_exploders[i])
				{
					case "fx_frontend_zombie_fog_mobile":
					case "zm_bonus_idle":
					{
						position = (-1269, 1178, 562);
						break;
					}
					case "fx_frontend_zombie_fog_singapore":
					{
						position = (-1273, 1180, 320);
						break;
					}
					case "fx_frontend_zombie_fog_cairo":
					{
						position = (-1256, 1235, 61);
						break;
					}
				}
				level.frontendspecialfx = playfx(localclientnum, level._effect["frontend_special_day"], position);
			}
			playradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
			continue;
		}
		killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
	}
	scene::add_scene_func(s_scene.name, &doa_lobby_room_effects, "play", localclientnum);
	s_params = spawnstruct();
	s_params.scene = s_scene.name;
	s_params.sessionmode = 2;
	female = 1;
	loadcpzmcharacteronmodel(localclientnum, level.cp_lobby_data_struct, female, s_params);
	streamer_change(level.a_str_bunk_scene_hints[level.n_cp_index], level.cp_lobby_data_struct);
	/#
		if(getdvarint("", 0))
		{
			level.n_cp_index = undefined;
		}
	#/
	level.cp_lobby_data_struct.charactermodel hide();
}

/*
	Name: loadcpzmcharacteronmodel
	Namespace: frontend
	Checksum: 0x15416774
	Offset: 0x102E0
	Size: 0x20A
	Parameters: 4
	Flags: Linked
*/
function loadcpzmcharacteronmodel(localclientnum, data_struct, characterindex, params)
{
	/#
		assert(isdefined(data_struct));
	#/
	defaultindex = undefined;
	if(isdefined(params.isdefaulthero) && params.isdefaulthero)
	{
		defaultindex = 0;
	}
	character_customization::set_character(data_struct, characterindex);
	charactermode = params.sessionmode;
	character_customization::set_character_mode(data_struct, charactermode);
	body = 1;
	bodycolors = character_customization::get_character_body_colors(localclientnum, charactermode, characterindex, body, params.extracam_data);
	character_customization::set_body(data_struct, charactermode, characterindex, body, bodycolors);
	head = 14;
	character_customization::set_head(data_struct, charactermode, head);
	helmet = 0;
	helmetcolors = character_customization::get_character_helmet_colors(localclientnum, charactermode, data_struct.characterindex, helmet, params.extracam_data);
	character_customization::set_helmet(data_struct, charactermode, characterindex, helmet, helmetcolors);
	return character_customization::update(localclientnum, data_struct, params);
}

/*
	Name: zm_lobby_room
	Namespace: frontend
	Checksum: 0x3E45522A
	Offset: 0x104F8
	Size: 0x138
	Parameters: 1
	Flags: Linked
*/
function zm_lobby_room(localclientnum)
{
	/#
		n_zm_max_char_index = 8;
		if(getdvarint("", 0))
		{
			if(!isdefined(level.zm_debug_index) || level.zm_debug_index > n_zm_max_char_index)
			{
				level.zm_debug_index = 0;
			}
		}
	#/
	s_scene = struct::get_script_bundle("scene", "cin_fe_zm_forest_vign_sitting");
	s_params = spawnstruct();
	s_params.scene = s_scene.name;
	s_params.sessionmode = 0;
	character_customization::loadequippedcharacteronmodel(localclientnum, level.zm_lobby_data_struct, level.zm_debug_index, s_params);
	/#
		if(getdvarint("", 0))
		{
			level.zm_debug_index++;
		}
	#/
}

/*
	Name: mp_lobby_room
	Namespace: frontend
	Checksum: 0xBC5AB80B
	Offset: 0x10638
	Size: 0x4F4
	Parameters: 2
	Flags: Linked
*/
function mp_lobby_room(localclientnum, state)
{
	character_index = getequippedheroindex(localclientnum, 1);
	fields = getcharacterfields(character_index, 1);
	params = spawnstruct();
	if(!isdefined(fields))
	{
		fields = spawnstruct();
	}
	if(isdefined(fields.frontendvignettestruct))
	{
		params.align_struct = struct::get(fields.frontendvignettestruct);
	}
	params.weapon_left = fields.frontendvignetteweaponleftmodel;
	params.weapon_right = fields.frontendvignetteweaponmodel;
	isabilityequipped = 1 == getequippedloadoutitemforhero(localclientnum, character_index);
	if(isabilityequipped)
	{
		params.anim_intro_name = fields.frontendvignetteabilityxanimintro;
		params.anim_name = fields.frontendvignetteabilityxanim;
		params.weapon_left_anim_intro = fields.frontendvignetteabilityweaponleftanimintro;
		params.weapon_left_anim = fields.frontendvignetteabilityweaponleftanim;
		params.weapon_right_anim_intro = fields.frontendvignetteabilityweaponrightanimintro;
		params.weapon_right_anim = fields.frontendvignetteabilityweaponrightanim;
		if(isdefined(fields.frontendvignetteuseweaponhidetagsforability) && fields.frontendvignetteuseweaponhidetagsforability)
		{
			params.weapon = getweaponforcharacter(character_index, 1);
		}
	}
	else
	{
		params.anim_intro_name = fields.frontendvignettexanimintro;
		params.anim_name = fields.frontendvignettexanim;
		params.weapon_left_anim_intro = fields.frontendvignetteweaponleftanimintro;
		params.weapon_left_anim = fields.frontendvignetteweaponleftanim;
		params.weapon_right_anim_intro = fields.frontendvignetteweaponanimintro;
		params.weapon_right_anim = fields.frontendvignetteweaponanim;
		params.weapon = getweaponforcharacter(character_index, 1);
	}
	params.sessionmode = 1;
	changed = character_customization::loadequippedcharacteronmodel(localclientnum, level.mp_lobby_data_struct, character_index, params);
	if(isdefined(level.mp_lobby_data_struct.charactermodel))
	{
		level.mp_lobby_data_struct.charactermodel sethighdetail(1, 1);
		if(isdefined(params.weapon))
		{
			level.mp_lobby_data_struct.charactermodel useweaponhidetags(params.weapon);
		}
		else
		{
			wait(0.016);
			level.mp_lobby_data_struct.charactermodel showallparts(localclientnum);
		}
		if(isdefined(level.mp_lobby_data_struct.stopsoundid))
		{
			stopsound(level.mp_lobby_data_struct.stopsoundid);
			level.mp_lobby_data_struct.stopsoundid = undefined;
		}
		if(isdefined(level.mp_lobby_data_struct.playsound))
		{
			level.mp_lobby_data_struct.stopsoundid = level.mp_lobby_data_struct.charactermodel playsound(undefined, level.mp_lobby_data_struct.playsound);
			level.mp_lobby_data_struct.playsound = undefined;
		}
	}
	plaympherovignettecam(localclientnum, level.mp_lobby_data_struct, changed);
	/#
		update_mp_lobby_room_devgui(localclientnum, state);
	#/
}

/*
	Name: lobby_main
	Namespace: frontend
	Checksum: 0xCAC2CC63
	Offset: 0x10B38
	Size: 0x59A
	Parameters: 3
	Flags: Linked
*/
function lobby_main(localclientnum, menu_name, state)
{
	level notify(#"new_lobby");
	setpbgactivebank(localclientnum, 1);
	if(isdefined(state) && !strstartswith(state, "cpzm") && !strstartswith(state, "doa"))
	{
		if(isdefined(level.frontendspecialfx))
		{
			killfx(localclientnum, level.frontendspecialfx);
		}
	}
	if(!isdefined(state) || state == "room2")
	{
		streamer_change();
		camera_ent = struct::get("mainmenu_frontend_camera");
		if(isdefined(camera_ent))
		{
			playmaincamxcam(localclientnum, "startmenu_camera_01", 0, "cam1", "", camera_ent.origin, camera_ent.angles);
		}
		/#
			update_room2_devgui(localclientnum);
		#/
	}
	else
	{
		if(state == "room1")
		{
			streamer_change("core_frontend_sitting_bull");
			camera_ent = struct::get("room1_frontend_camera");
			setallcontrollerslightbarcolor((1, 0.4, 0));
			level thread pulse_controller_color();
			if(isdefined(camera_ent))
			{
				playmaincamxcam(localclientnum, "startmenu_camera_01", 0, "cam1", "", camera_ent.origin, camera_ent.angles);
			}
		}
		else
		{
			if(state == "mp_theater")
			{
				streamer_change("frontend_theater");
				camera_ent = struct::get("frontend_theater");
				if(isdefined(camera_ent))
				{
					playmaincamxcam(localclientnum, "ui_cam_frontend_theater", 0, "cam1", "", camera_ent.origin, camera_ent.angles);
				}
			}
			else
			{
				if(state == "mp_freerun")
				{
					streamer_change("frontend_freerun");
					camera_ent = struct::get("frontend_freerun");
					if(isdefined(camera_ent))
					{
						playmaincamxcam(localclientnum, "ui_cam_frontend_freerun", 0, "cam1", "", camera_ent.origin, camera_ent.angles);
					}
				}
				else
				{
					if(strstartswith(state, "doa"))
					{
						doa_lobby_room(localclientnum);
					}
					else
					{
						if(strstartswith(state, "cpzm"))
						{
							cpzm_lobby_room(localclientnum);
						}
						else
						{
							if(strstartswith(state, "cp"))
							{
								cp_lobby_room(localclientnum);
							}
							else
							{
								if(strstartswith(state, "mp"))
								{
									mp_lobby_room(localclientnum, state);
								}
								else
								{
									if(strstartswith(state, "zm"))
									{
										streamer_change("core_frontend_zm_lobby");
										camera_ent = struct::get("zm_frontend_camera");
										if(isdefined(camera_ent))
										{
											playmaincamxcam(localclientnum, "zm_lobby_cam", 0, "default", "", camera_ent.origin, camera_ent.angles);
										}
										zm_lobby_room(localclientnum);
									}
									else
									{
										streamer_change();
									}
								}
							}
						}
					}
				}
			}
		}
	}
	if(!isdefined(state) || state != "room1")
	{
		setallcontrollerslightbarcolor();
		level notify(#"end_controller_pulse");
	}
}

/*
	Name: update_room2_devgui
	Namespace: frontend
	Checksum: 0x4CB300CC
	Offset: 0x110E0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function update_room2_devgui(localclientnum)
{
	/#
		level thread mp_devgui::remove_mp_contracts_devgui(localclientnum);
	#/
}

/*
	Name: update_mp_lobby_room_devgui
	Namespace: frontend
	Checksum: 0x1A887A93
	Offset: 0x11118
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function update_mp_lobby_room_devgui(localclientnum, state)
{
	/#
		if(state == "" || state == "")
		{
			level thread mp_devgui::create_mp_contracts_devgui(localclientnum);
		}
		else
		{
			level mp_devgui::remove_mp_contracts_devgui(localclientnum);
		}
	#/
}

/*
	Name: pulse_controller_color
	Namespace: frontend
	Checksum: 0xC5B34F65
	Offset: 0x11198
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function pulse_controller_color()
{
	level endon(#"end_controller_pulse");
	delta_t = -0.01;
	t = 1;
	while(true)
	{
		setallcontrollerslightbarcolor((1 * t, 0.2 * t, 0));
		t = t + delta_t;
		if(t < 0.2 || t > 0.99)
		{
			delta_t = delta_t * -1;
		}
		wait(0.016);
	}
}

