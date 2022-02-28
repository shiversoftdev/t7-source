// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_laststand;
#using scripts\cp\_pickups;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;

class cpickupitem : cbaseinteractable
{
	var m_e_model;
	var m_e_body_trigger;
	var m_n_respawn_rounds;
	var m_n_respawn_time;
	var m_n_despawn_wait;
	var m_custom_despawn_func;
	var m_n_drop_offset;
	var m_str_modelname;
	var m_fx_glow;
	var m_str_itemname;
	var m_str_pickup_hintstring;
	var m_iscarryable;
	var m_custom_spawn_func;
	var m_str_holding_hintstring;
	var m_e_carry_model;
	var m_n_throw_distance_min;
	var m_n_throw_distance_max;
	var m_n_throw_max_hold_duration;
	var m_v_holding_angle;
	var m_v_holding_offset_angle;
	var m_n_holding_distance;
	var a_carry_threads;
	var a_drop_funcs;

	/*
		Name: constructor
		Namespace: cpickupitem
		Checksum: 0x6EE9770B
		Offset: 0x3C8
		Size: 0xE6
		Parameters: 0
		Flags: None
	*/
	constructor()
	{
		m_n_respawn_time = 1;
		m_n_respawn_rounds = 0;
		m_n_throw_distance_min = 128;
		m_n_throw_distance_max = 256;
		m_n_throw_max_hold_duration = 2;
		m_v_holding_angle = (0, 0, 0);
		m_n_despawn_wait = 0;
		m_v_holding_offset_angle = vectorscale((1, 0, 0), 45);
		m_n_holding_distance = 64;
		m_n_drop_offset = 0;
		m_iscarryable = 1;
		a_carry_threads = [];
		a_carry_threads[0] = &carry_pickupitem;
		a_drop_funcs = [];
		a_drop_funcs[0] = &drop_pickupitem;
	}

	/*
		Name: destructor
		Namespace: cpickupitem
		Checksum: 0x12461893
		Offset: 0xB10
		Size: 0x14
		Parameters: 0
		Flags: None
	*/
	destructor()
	{
	}

	/*
		Name: drop_pickupitem
		Namespace: cpickupitem
		Checksum: 0xFFB7B0CF
		Offset: 0xAD0
		Size: 0x34
		Parameters: 1
		Flags: None
	*/
	function drop_pickupitem(e_triggerer)
	{
		pickupitem_spawn(e_triggerer.origin, e_triggerer.angles);
	}

	/*
		Name: carry_pickupitem
		Namespace: cpickupitem
		Checksum: 0x112051C1
		Offset: 0xA88
		Size: 0x3C
		Parameters: 1
		Flags: None
	*/
	function carry_pickupitem(e_triggerer)
	{
		m_e_model delete();
		m_e_body_trigger setinvisibletoall();
	}

	/*
		Name: pickupitem_respawn_delay
		Namespace: cpickupitem
		Checksum: 0x6BED268A
		Offset: 0xA50
		Size: 0x30
		Parameters: 0
		Flags: None
	*/
	function pickupitem_respawn_delay()
	{
		if(m_n_respawn_rounds > 0)
		{
		}
		else if(m_n_respawn_time > 0)
		{
			wait(m_n_respawn_time);
		}
	}

	/*
		Name: pickupitem_despawn
		Namespace: cpickupitem
		Checksum: 0xFA6D1213
		Offset: 0xA30
		Size: 0x12
		Parameters: 0
		Flags: None
	*/
	function pickupitem_despawn()
	{
		self notify(#"respawn_pickupitem");
	}

	/*
		Name: debug_despawn_timer
		Namespace: cpickupitem
		Checksum: 0x27912AB0
		Offset: 0x988
		Size: 0x9E
		Parameters: 0
		Flags: None
	*/
	function debug_despawn_timer()
	{
		self endon(#"cancel_despawn");
		n_time_remaining = m_n_despawn_wait;
		while(n_time_remaining >= 0 && isdefined(m_e_model))
		{
			/#
				print3d(m_e_model.origin + vectorscale((0, 0, 1), 15), n_time_remaining, (1, 0, 0), 1, 1, 20);
			#/
			wait(1);
			n_time_remaining = n_time_remaining - 1;
		}
	}

	/*
		Name: pickupitem_despawn_timer
		Namespace: cpickupitem
		Checksum: 0x356DD499
		Offset: 0x910
		Size: 0x6C
		Parameters: 0
		Flags: None
	*/
	function pickupitem_despawn_timer()
	{
		self endon(#"cancel_despawn");
		if(m_n_despawn_wait <= 0)
		{
			return;
		}
		self thread debug_despawn_timer();
		wait(m_n_despawn_wait);
		if(isdefined(m_custom_despawn_func))
		{
			[[m_custom_despawn_func]]();
		}
		else
		{
			pickupitem_despawn();
		}
	}

	/*
		Name: pickupitem_spawn
		Namespace: cpickupitem
		Checksum: 0x908A9C1C
		Offset: 0x638
		Size: 0x2CC
		Parameters: 2
		Flags: None
	*/
	function pickupitem_spawn(v_pos, v_angles)
	{
		if(!isdefined(m_e_model))
		{
			m_e_model = util::spawn_model(m_str_modelname, v_pos + (0, 0, m_n_drop_offset), v_angles);
			m_e_model notsolid();
			if(isdefined(m_fx_glow))
			{
				playfxontag(m_fx_glow, m_e_model, "tag_origin");
			}
		}
		m_str_pickup_hintstring = ("Press and hold ^3[{+activate}]^7 to pick up ") + m_str_itemname;
		if(!isdefined(m_e_body_trigger))
		{
			e_trigger = cbaseinteractable::spawn_body_trigger(v_pos);
			cbaseinteractable::set_body_trigger(e_trigger);
		}
		m_e_body_trigger setvisibletoall();
		m_e_body_trigger.origin = v_pos;
		m_e_body_trigger notify(#"upgrade_trigger_moved");
		m_e_body_trigger notify(#"upgrade_trigger_enable", 1);
		m_e_body_trigger sethintstring(m_str_pickup_hintstring);
		m_e_body_trigger.str_itemname = m_str_itemname;
		if(!isdefined(m_e_body_trigger.targetname))
		{
			m_str_targetname = "";
			m_a_str_targetname = strtok(tolower(m_str_itemname), " ");
			foreach(n_index, m_str_targetname_piece in m_a_str_targetname)
			{
				if(n_index > 0)
				{
					m_str_targetname = m_str_targetname + "_";
				}
				m_str_targetname = m_str_targetname + m_str_targetname_piece;
			}
			m_e_body_trigger.targetname = "trigger_" + m_str_targetname;
		}
		if(m_iscarryable)
		{
			self thread cbaseinteractable::thread_allow_carry();
		}
	}

	/*
		Name: respawn_loop
		Namespace: cpickupitem
		Checksum: 0xAD595426
		Offset: 0x598
		Size: 0x98
		Parameters: 2
		Flags: None
	*/
	function respawn_loop(v_pos, v_angles)
	{
		while(true)
		{
			if(isdefined(m_custom_spawn_func))
			{
				[[m_custom_spawn_func]](v_pos, v_angles);
			}
			else
			{
				m_str_holding_hintstring = ("Press ^3[{+usereload}]^7 to drop ") + m_str_itemname;
				pickupitem_spawn(v_pos, v_angles);
			}
			self waittill(#"respawn_pickupitem");
			pickupitem_respawn_delay();
		}
	}

	/*
		Name: spawn_at_position
		Namespace: cpickupitem
		Checksum: 0x6734B55
		Offset: 0x560
		Size: 0x2C
		Parameters: 2
		Flags: None
	*/
	function spawn_at_position(v_pos, v_angles)
	{
		respawn_loop(v_pos, v_angles);
	}

	/*
		Name: spawn_at_struct
		Namespace: cpickupitem
		Checksum: 0x6E49965B
		Offset: 0x4F8
		Size: 0x5C
		Parameters: 1
		Flags: None
	*/
	function spawn_at_struct(str_struct)
	{
		if(!isdefined(str_struct.angles))
		{
			str_struct.angles = (0, 0, 0);
		}
		respawn_loop(str_struct.origin, str_struct.angles);
	}

	/*
		Name: get_model
		Namespace: cpickupitem
		Checksum: 0x2322EA50
		Offset: 0x4B8
		Size: 0x32
		Parameters: 0
		Flags: None
	*/
	function get_model()
	{
		if(isdefined(m_e_carry_model))
		{
			return m_e_carry_model;
		}
		if(isdefined(m_e_model))
		{
			return m_e_model;
		}
		return undefined;
	}

}

class cbaseinteractable 
{
	var m_n_body_trigger_height;
	var m_n_body_trigger_radius;
	var m_n_repair_height;
	var m_n_repair_radius;
	var m_e_player_currently_holding;
	var disable_object_pickup;
	var m_e_carry_model;
	var a_drop_funcs;
	var m_v_holding_offset_angle;
	var m_v_holding_angle;
	var m_n_holding_distance;
	var m_str_carry_model;
	var m_str_modelname;
	var m_str_itemname;
	var m_e_body_trigger;
	var a_carry_threads;
	var m_iscarryable;
	var m_allow_carry_custom_conditions_func;
	var m_repair_complete_func;
	var m_repair_custom_complete_func;
	var m_prompt_manager_custom_func;
	var m_isfunctional;
	var m_ishackable;

	/*
		Name: constructor
		Namespace: cbaseinteractable
		Checksum: 0xF8B46E77
		Offset: 0x12B0
		Size: 0x7C
		Parameters: 0
		Flags: None
	*/
	constructor()
	{
		m_isfunctional = 1;
		m_ishackable = 0;
		m_iscarryable = 0;
		m_n_body_trigger_radius = 36;
		m_n_body_trigger_height = 128;
		m_n_repair_radius = 72;
		m_n_repair_height = 128;
		m_repair_complete_func = &repair_completed;
		m_str_itemname = "Item";
	}

	/*
		Name: destructor
		Namespace: cbaseinteractable
		Checksum: 0x99EC1590
		Offset: 0x22F8
		Size: 0x4
		Parameters: 0
		Flags: None
	*/
	destructor()
	{
	}

	/*
		Name: spawn_interact_trigger
		Namespace: cbaseinteractable
		Checksum: 0x6EB896D7
		Offset: 0x2188
		Size: 0x168
		Parameters: 4
		Flags: None
	*/
	function spawn_interact_trigger(v_origin, n_radius, n_height, str_hint)
	{
		/#
			assert(isdefined(v_origin), "");
		#/
		/#
			assert(isdefined(n_radius), "");
		#/
		/#
			assert(isdefined(n_height), "");
		#/
		e_trigger = spawn("trigger_radius", v_origin, 0, n_radius, n_height);
		e_trigger triggerignoreteam();
		e_trigger setvisibletoall();
		e_trigger setteamfortrigger("none");
		e_trigger setcursorhint("HINT_NOICON");
		if(isdefined(str_hint))
		{
			e_trigger sethintstring(str_hint);
		}
		return e_trigger;
	}

	/*
		Name: spawn_body_trigger
		Namespace: cbaseinteractable
		Checksum: 0x1EA0C7
		Offset: 0x2118
		Size: 0x68
		Parameters: 1
		Flags: None
	*/
	function spawn_body_trigger(v_origin)
	{
		e_trigger = spawn_interact_trigger(v_origin, m_n_body_trigger_radius, m_n_body_trigger_height, "");
		e_trigger sethintlowpriority(1);
		return e_trigger;
	}

	/*
		Name: spawn_repair_trigger
		Namespace: cbaseinteractable
		Checksum: 0x9111D7EE
		Offset: 0x20C0
		Size: 0x4C
		Parameters: 1
		Flags: None
	*/
	function spawn_repair_trigger(v_origin)
	{
		e_repair_trigger = spawn_interact_trigger(v_origin, m_n_repair_radius, m_n_repair_height, "Bring Toolbox to repair");
		return e_repair_trigger;
	}

	/*
		Name: drop_on_death
		Namespace: cbaseinteractable
		Checksum: 0x2F2E6149
		Offset: 0x2048
		Size: 0x6C
		Parameters: 1
		Flags: None
	*/
	function drop_on_death(e_triggerer)
	{
		self notify(#"drop_on_death");
		self endon(#"drop_on_death");
		e_triggerer util::waittill_any("player_downed", "death");
		if(isdefined(m_e_player_currently_holding))
		{
			drop(e_triggerer);
		}
	}

	/*
		Name: _wait_for_button_release
		Namespace: cbaseinteractable
		Checksum: 0x3F68BC31
		Offset: 0x2008
		Size: 0x34
		Parameters: 0
		Flags: None
	*/
	function _wait_for_button_release()
	{
		self endon(#"player_downed");
		while(self usebuttonpressed())
		{
			wait(0.05);
		}
	}

	/*
		Name: wait_for_button_release
		Namespace: cbaseinteractable
		Checksum: 0x7ECAF472
		Offset: 0x1FC0
		Size: 0x3E
		Parameters: 0
		Flags: None
	*/
	function wait_for_button_release()
	{
		self endon(#"death_or_disconnect");
		disable_object_pickup = 1;
		self _wait_for_button_release();
		self.disable_object_pickup = undefined;
	}

	/*
		Name: destroy
		Namespace: cbaseinteractable
		Checksum: 0xE215B463
		Offset: 0x1F40
		Size: 0x78
		Parameters: 0
		Flags: None
	*/
	function destroy()
	{
		if(isdefined(m_e_player_currently_holding))
		{
			restore_player_controls_from_carry(m_e_player_currently_holding);
			m_e_player_currently_holding util::screen_message_delete_client();
		}
		if(isdefined(m_e_carry_model))
		{
			m_e_carry_model delete();
		}
		m_e_player_currently_holding = undefined;
	}

	/*
		Name: remove
		Namespace: cbaseinteractable
		Checksum: 0x46C8C2E1
		Offset: 0x1EB8
		Size: 0x7E
		Parameters: 1
		Flags: None
	*/
	function remove(e_triggerer)
	{
		restore_player_controls_from_carry(e_triggerer);
		e_triggerer util::screen_message_delete_client();
		if(isdefined(m_e_carry_model))
		{
			m_e_carry_model delete();
		}
		m_e_player_currently_holding = undefined;
		self notify(#"respawn_pickupitem");
	}

	/*
		Name: drop
		Namespace: cbaseinteractable
		Checksum: 0xBE645FBC
		Offset: 0x1D80
		Size: 0x12C
		Parameters: 1
		Flags: None
	*/
	function drop(e_triggerer)
	{
		restore_player_controls_from_carry(e_triggerer);
		e_triggerer util::screen_message_delete_client();
		if(isdefined(m_e_carry_model))
		{
			m_e_carry_model delete();
		}
		if(isdefined(a_drop_funcs))
		{
			foreach(drop_func in a_drop_funcs)
			{
				[[drop_func]](e_triggerer);
			}
		}
		m_e_player_currently_holding = undefined;
		self thread thread_allow_carry();
		e_triggerer thread wait_for_button_release();
	}

	/*
		Name: restore_player_controls_from_carry
		Namespace: cbaseinteractable
		Checksum: 0x578DB70B
		Offset: 0x1CF0
		Size: 0x84
		Parameters: 1
		Flags: None
	*/
	function restore_player_controls_from_carry(e_triggerer)
	{
		e_triggerer endon(#"death");
		e_triggerer endon(#"player_downed");
		if(!e_triggerer.is_carrying_pickupitem)
		{
			return;
		}
		e_triggerer notify(#"restore_player_controls_from_carry");
		e_triggerer enableweapons();
		e_triggerer.is_carrying_pickupitem = 0;
		e_triggerer allowjump(1);
	}

	/*
		Name: show_carry_model
		Namespace: cbaseinteractable
		Checksum: 0xB599F0F8
		Offset: 0x1AC0
		Size: 0x228
		Parameters: 1
		Flags: None
	*/
	function show_carry_model(e_triggerer)
	{
		e_triggerer endon(#"restore_player_controls_from_carry");
		e_triggerer endon(#"death");
		e_triggerer endon(#"player_downed");
		v_eye_origin = e_triggerer geteye();
		v_player_angles = e_triggerer getplayerangles();
		v_player_angles = v_player_angles + m_v_holding_offset_angle;
		v_player_angles = anglestoforward(v_player_angles);
		v_angles = e_triggerer.angles + m_v_holding_angle;
		v_origin = v_eye_origin + (v_player_angles * m_n_holding_distance);
		if(!isdefined(m_str_carry_model))
		{
			if(isdefined(m_str_modelname))
			{
				m_str_carry_model = m_str_modelname;
			}
			else
			{
				m_str_carry_model = "script_origin";
			}
		}
		m_e_carry_model = util::spawn_model(m_str_carry_model, v_origin, v_angles);
		m_e_carry_model notsolid();
		while(isdefined(m_e_carry_model))
		{
			v_eye_origin = e_triggerer geteye();
			v_player_angles = e_triggerer getplayerangles();
			v_player_angles = v_player_angles + m_v_holding_offset_angle;
			v_player_angles = anglestoforward(v_player_angles);
			m_e_carry_model.angles = e_triggerer.angles + m_v_holding_angle;
			m_e_carry_model.origin = v_eye_origin + (v_player_angles * m_n_holding_distance);
			wait(0.05);
		}
	}

	/*
		Name: thread_allow_drop
		Namespace: cbaseinteractable
		Checksum: 0x44A73738
		Offset: 0x1A00
		Size: 0xB4
		Parameters: 1
		Flags: None
	*/
	function thread_allow_drop(e_triggerer)
	{
		e_triggerer endon(#"restore_player_controls_from_carry");
		e_triggerer endon(#"death");
		e_triggerer endon(#"player_downed");
		self thread drop_on_death(e_triggerer);
		while(e_triggerer usebuttonpressed())
		{
			wait(0.05);
		}
		while(!e_triggerer usebuttonpressed())
		{
			wait(0.05);
		}
		self thread drop(e_triggerer);
	}

	/*
		Name: flash_drop_prompt_stop
		Namespace: cbaseinteractable
		Checksum: 0x20051AE
		Offset: 0x19C0
		Size: 0x34
		Parameters: 1
		Flags: None
	*/
	function flash_drop_prompt_stop(player)
	{
		player notify(#"stop_flashing_drop_prompt");
		player util::screen_message_delete_client();
	}

	/*
		Name: flash_drop_prompt
		Namespace: cbaseinteractable
		Checksum: 0x2BEF749C
		Offset: 0x1938
		Size: 0x80
		Parameters: 1
		Flags: None
	*/
	function flash_drop_prompt(player)
	{
		self endon(#"death");
		player endon(#"death");
		player endon(#"stop_flashing_drop_prompt");
		while(true)
		{
			player util::screen_message_create_client(get_drop_prompt(), undefined, undefined, 0, 0.35);
			wait(0.35);
		}
	}

	/*
		Name: show_drop_prompt
		Namespace: cbaseinteractable
		Checksum: 0x61EC9E7D
		Offset: 0x18F8
		Size: 0x34
		Parameters: 1
		Flags: None
	*/
	function show_drop_prompt(player)
	{
		player util::screen_message_create_client(get_drop_prompt());
	}

	/*
		Name: get_drop_prompt
		Namespace: cbaseinteractable
		Checksum: 0x24EECAE5
		Offset: 0x18D8
		Size: 0x14
		Parameters: 0
		Flags: None
	*/
	function get_drop_prompt()
	{
		return ("Press ^3[{+usereload}]^7 to drop ") + m_str_itemname;
	}

	/*
		Name: carry
		Namespace: cbaseinteractable
		Checksum: 0xE4F384FB
		Offset: 0x1758
		Size: 0x174
		Parameters: 1
		Flags: None
	*/
	function carry(e_triggerer)
	{
		e_triggerer endon(#"death");
		e_triggerer endon(#"player_downed");
		e_triggerer.o_pickupitem = self;
		m_e_player_currently_holding = e_triggerer;
		m_e_body_trigger notify(#"upgrade_trigger_enable", 0);
		self notify(#"cancel_despawn");
		e_triggerer disableweapons();
		wait(0.5);
		if(isdefined(a_carry_threads))
		{
			foreach(carry_thread in a_carry_threads)
			{
				self thread [[carry_thread]](e_triggerer);
			}
		}
		else
		{
			e_triggerer allowjump(0);
		}
		self thread show_drop_prompt(e_triggerer);
		self thread show_carry_model(e_triggerer);
		self thread thread_allow_drop(e_triggerer);
	}

	/*
		Name: thread_allow_carry
		Namespace: cbaseinteractable
		Checksum: 0xBD8CC8F3
		Offset: 0x1570
		Size: 0x1DA
		Parameters: 0
		Flags: None
	*/
	function thread_allow_carry()
	{
		self notify(#"thread_allow_carry");
		self endon(#"thread_allow_carry");
		self endon(#"unmake");
		if(1)
		{
			for(;;)
			{
				wait(0.05);
				return;
				m_e_body_trigger waittill(#"trigger", e_triggerer);
				m_e_body_trigger sethintstringforplayer(e_triggerer, "");
			}
			for(;;)
			{
			}
			for(;;)
			{
			}
			for(;;)
			{
			}
			for(;;)
			{
			}
			for(;;)
			{
				return;
			}
			for(;;)
			{
			}
			for(;;)
			{
			}
			if(!isdefined(m_e_body_trigger))
			{
			}
			if(isdefined(e_triggerer.is_carrying_pickupitem) && e_triggerer.is_carrying_pickupitem)
			{
			}
			if(!m_iscarryable)
			{
			}
			if(isdefined(e_triggerer.disable_object_pickup) && e_triggerer.disable_object_pickup)
			{
			}
			if(!e_triggerer util::use_button_held())
			{
			}
			if(isdefined(m_allow_carry_custom_conditions_func) && ![[m_allow_carry_custom_conditions_func]]())
			{
			}
			if(!isdefined(m_e_body_trigger))
			{
			}
			if(!e_triggerer istouching(m_e_body_trigger))
			{
			}
			if(isdefined(e_triggerer.is_carrying_pickupitem) && e_triggerer.is_carrying_pickupitem)
			{
			}
			if(e_triggerer laststand::player_is_in_laststand())
			{
			}
			e_triggerer.is_carrying_pickupitem = 1;
			self thread carry(e_triggerer);
			return;
		}
	}

	/*
		Name: disable_carry
		Namespace: cbaseinteractable
		Checksum: 0xBAE3018C
		Offset: 0x1548
		Size: 0x1E
		Parameters: 0
		Flags: None
	*/
	function disable_carry()
	{
		m_iscarryable = 0;
		self notify(#"thread_allow_carry");
	}

	/*
		Name: enable_carry
		Namespace: cbaseinteractable
		Checksum: 0x35DFCF4F
		Offset: 0x1518
		Size: 0x24
		Parameters: 0
		Flags: None
	*/
	function enable_carry()
	{
		m_iscarryable = 1;
		self thread thread_allow_carry();
	}

	/*
		Name: set_body_trigger
		Namespace: cbaseinteractable
		Checksum: 0xE5F1BD89
		Offset: 0x14D8
		Size: 0x38
		Parameters: 1
		Flags: None
	*/
	function set_body_trigger(e_trigger)
	{
		/#
			assert(!isdefined(m_e_body_trigger));
		#/
		m_e_body_trigger = e_trigger;
	}

	/*
		Name: repair_trigger
		Namespace: cbaseinteractable
		Checksum: 0xEBAEBEFF
		Offset: 0x1418
		Size: 0xB8
		Parameters: 0
		Flags: None
	*/
	function repair_trigger()
	{
		self endon(#"unmake");
		while(true)
		{
			m_e_body_trigger waittill(#"trigger", player);
			if(isdefined(player.is_carrying_pickupitem) && player.is_carrying_pickupitem && player.o_pickupitem.m_str_itemname == "Toolbox")
			{
				[[ player.o_pickupitem ]]->remove(player);
				[[m_repair_complete_func]](player);
			}
			wait(0.05);
		}
	}

	/*
		Name: repair_completed
		Namespace: cbaseinteractable
		Checksum: 0x602AC1CF
		Offset: 0x13D0
		Size: 0x3C
		Parameters: 1
		Flags: None
	*/
	function repair_completed(player)
	{
		self notify(#"repair_completed");
		if(isdefined(m_repair_custom_complete_func))
		{
			self thread [[m_repair_custom_complete_func]](player);
		}
	}

	/*
		Name: prompt_manager
		Namespace: cbaseinteractable
		Checksum: 0xABDBAA18
		Offset: 0x1350
		Size: 0x74
		Parameters: 0
		Flags: None
	*/
	function prompt_manager()
	{
		if(isdefined(m_prompt_manager_custom_func))
		{
			self thread [[m_prompt_manager_custom_func]]();
		}
		else
		{
			while(isdefined(m_e_body_trigger))
			{
				if(!m_isfunctional)
				{
					m_e_body_trigger sethintstring("Bring Toolbox to repair");
					wait(0.05);
					continue;
				}
				wait(0.05);
			}
		}
	}

	/*
		Name: get_player_currently_holding
		Namespace: cbaseinteractable
		Checksum: 0x70DD5230
		Offset: 0x1338
		Size: 0xA
		Parameters: 0
		Flags: None
	*/
	function get_player_currently_holding()
	{
		return m_e_player_currently_holding;
	}

}

