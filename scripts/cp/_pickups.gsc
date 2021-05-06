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

#namespace cpickupitem;

/*
	Name: __constructor
	Namespace: cpickupitem
	Checksum: 0x6EE9770B
	Offset: 0x3C8
	Size: 0xE6
	Parameters: 0
	Flags: None
*/
function __constructor()
{
	cbaseinteractable::__constructor();
	self.m_n_respawn_time = 1;
	self.m_n_respawn_rounds = 0;
	self.m_n_throw_distance_min = 128;
	self.m_n_throw_distance_max = 256;
	self.m_n_throw_max_hold_duration = 2;
	self.m_v_holding_angle = (0, 0, 0);
	self.m_n_despawn_wait = 0;
	self.m_v_holding_offset_angle = vectorscale((1, 0, 0), 45);
	self.m_n_holding_distance = 64;
	self.m_n_drop_offset = 0;
	self.m_iscarryable = 1;
	self.a_carry_threads = [];
	self.a_carry_threads[0] = &carry_pickupitem;
	self.a_drop_funcs = [];
	self.a_drop_funcs[0] = &drop_pickupitem;
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
	if(isdefined(self.m_e_carry_model))
	{
		return self.m_e_carry_model;
	}
	if(isdefined(self.m_e_model))
	{
		return self.m_e_model;
	}
	return undefined;
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
		if(isdefined(self.m_custom_spawn_func))
		{
			[[self.m_custom_spawn_func]](v_pos, v_angles);
		}
		else
		{
			self.m_str_holding_hintstring = "Press ^3[{+usereload}]^7 to drop " + self.m_str_itemname;
			pickupitem_spawn(v_pos, v_angles);
		}
		self waittill(#"respawn_pickupitem");
		pickupitem_respawn_delay();
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
	if(!isdefined(self.m_e_model))
	{
		self.m_e_model = util::spawn_model(self.m_str_modelname, v_pos + (0, 0, self.m_n_drop_offset), v_angles);
		self.m_e_model notsolid();
		if(isdefined(self.m_fx_glow))
		{
			playfxontag(self.m_fx_glow, self.m_e_model, "tag_origin");
		}
	}
	self.m_str_pickup_hintstring = "Press and hold ^3[{+activate}]^7 to pick up " + self.m_str_itemname;
	if(!isdefined(self.m_e_body_trigger))
	{
		e_trigger = cbaseinteractable::spawn_body_trigger(v_pos);
		cbaseinteractable::set_body_trigger(e_trigger);
	}
	self.m_e_body_trigger setvisibletoall();
	self.m_e_body_trigger.origin = v_pos;
	self.m_e_body_trigger notify(#"upgrade_trigger_moved");
	self.m_e_body_trigger notify(#"upgrade_trigger_enable", 1);
	self.m_e_body_trigger sethintstring(self.m_str_pickup_hintstring);
	self.m_e_body_trigger.str_itemname = self.m_str_itemname;
	if(!isdefined(self.m_e_body_trigger.targetname))
	{
		m_str_targetname = "";
		m_a_str_targetname = strtok(tolower(self.m_str_itemname), " ");
		foreach(n_index, m_str_targetname_piece in m_a_str_targetname)
		{
			if(n_index > 0)
			{
				m_str_targetname = m_str_targetname + "_";
			}
			m_str_targetname = m_str_targetname + m_str_targetname_piece;
		}
		self.m_e_body_trigger.targetname = "trigger_" + m_str_targetname;
	}
	if(self.m_iscarryable)
	{
		self thread cbaseinteractable::thread_allow_carry();
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
	if(self.m_n_despawn_wait <= 0)
	{
		return;
	}
	self thread debug_despawn_timer();
	wait(self.m_n_despawn_wait);
	if(isdefined(self.m_custom_despawn_func))
	{
		[[self.m_custom_despawn_func]]();
	}
	else
	{
		pickupitem_despawn();
	}
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
	n_time_remaining = self.m_n_despawn_wait;
	while(n_time_remaining >= 0 && isdefined(self.m_e_model))
	{
		/#
			print3d(self.m_e_model.origin + vectorscale((0, 0, 1), 15), n_time_remaining, (1, 0, 0), 1, 1, 20);
		#/
		wait(1);
		n_time_remaining = n_time_remaining - 1;
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
	if(self.m_n_respawn_rounds > 0)
	{
	}
	else if(self.m_n_respawn_time > 0)
	{
		wait(self.m_n_respawn_time);
	}
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
	self.m_e_model delete();
	self.m_e_body_trigger setinvisibletoall();
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
	Name: __destructor
	Namespace: cpickupitem
	Checksum: 0x12461893
	Offset: 0xB10
	Size: 0x14
	Parameters: 0
	Flags: None
*/
function __destructor()
{
	cbaseinteractable::__destructor();
}

#namespace pickups;

/*
	Name: cpickupitem
	Namespace: pickups
	Checksum: 0x1ED54090
	Offset: 0xB30
	Size: 0x776
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cpickupitem()
{
	classes.cpickupitem[0] = spawnstruct();
	classes.cpickupitem[0].__vtable[-1422930206] = &cbaseinteractable::spawn_interact_trigger;
	classes.cpickupitem[0].__vtable[-1993785684] = &cbaseinteractable::spawn_body_trigger;
	classes.cpickupitem[0].__vtable[-1918751361] = &cbaseinteractable::spawn_repair_trigger;
	classes.cpickupitem[0].__vtable[738951197] = &cbaseinteractable::drop_on_death;
	classes.cpickupitem[0].__vtable[-1751768132] = &cbaseinteractable::_wait_for_button_release;
	classes.cpickupitem[0].__vtable[-908068637] = &cbaseinteractable::wait_for_button_release;
	classes.cpickupitem[0].__vtable[-1983032275] = &cbaseinteractable::destroy;
	classes.cpickupitem[0].__vtable[1998664073] = &cbaseinteractable::remove;
	classes.cpickupitem[0].__vtable[1355165250] = &cbaseinteractable::drop;
	classes.cpickupitem[0].__vtable[-419528313] = &cbaseinteractable::restore_player_controls_from_carry;
	classes.cpickupitem[0].__vtable[1137419972] = &cbaseinteractable::show_carry_model;
	classes.cpickupitem[0].__vtable[1366098661] = &cbaseinteractable::thread_allow_drop;
	classes.cpickupitem[0].__vtable[87726411] = &cbaseinteractable::flash_drop_prompt_stop;
	classes.cpickupitem[0].__vtable[2111823028] = &cbaseinteractable::flash_drop_prompt;
	classes.cpickupitem[0].__vtable[1002111075] = &cbaseinteractable::show_drop_prompt;
	classes.cpickupitem[0].__vtable[1562574218] = &cbaseinteractable::get_drop_prompt;
	classes.cpickupitem[0].__vtable[-234604426] = &cbaseinteractable::carry;
	classes.cpickupitem[0].__vtable[-1490407061] = &cbaseinteractable::thread_allow_carry;
	classes.cpickupitem[0].__vtable[-444976957] = &cbaseinteractable::disable_carry;
	classes.cpickupitem[0].__vtable[1291604272] = &cbaseinteractable::enable_carry;
	classes.cpickupitem[0].__vtable[562069659] = &cbaseinteractable::set_body_trigger;
	classes.cpickupitem[0].__vtable[-1223116993] = &cbaseinteractable::repair_trigger;
	classes.cpickupitem[0].__vtable[1291392716] = &cbaseinteractable::repair_completed;
	classes.cpickupitem[0].__vtable[-896363193] = &cbaseinteractable::prompt_manager;
	classes.cpickupitem[0].__vtable[131884998] = &cbaseinteractable::get_player_currently_holding;
	classes.cpickupitem[0].__vtable[-1690805083] = &cbaseinteractable::__constructor;
	classes.cpickupitem[0].__vtable[1606033458] = &cpickupitem::__destructor;
	classes.cpickupitem[0].__vtable[-129543972] = &cpickupitem::drop_pickupitem;
	classes.cpickupitem[0].__vtable[-1856534048] = &cpickupitem::carry_pickupitem;
	classes.cpickupitem[0].__vtable[-756947043] = &cpickupitem::pickupitem_respawn_delay;
	classes.cpickupitem[0].__vtable[-822313845] = &cpickupitem::pickupitem_despawn;
	classes.cpickupitem[0].__vtable[-1407138253] = &cpickupitem::debug_despawn_timer;
	classes.cpickupitem[0].__vtable[276497145] = &cpickupitem::pickupitem_despawn_timer;
	classes.cpickupitem[0].__vtable[1301438056] = &cpickupitem::pickupitem_spawn;
	classes.cpickupitem[0].__vtable[559289500] = &cpickupitem::respawn_loop;
	classes.cpickupitem[0].__vtable[-1889623724] = &cpickupitem::spawn_at_position;
	classes.cpickupitem[0].__vtable[-1912518662] = &cpickupitem::spawn_at_struct;
	classes.cpickupitem[0].__vtable[-444750419] = &cpickupitem::get_model;
	classes.cpickupitem[0].__vtable[-1690805083] = &cpickupitem::__constructor;
}

#namespace cbaseinteractable;

/*
	Name: __constructor
	Namespace: cbaseinteractable
	Checksum: 0xF8B46E77
	Offset: 0x12B0
	Size: 0x7C
	Parameters: 0
	Flags: None
*/
function __constructor()
{
	self.m_isfunctional = 1;
	self.m_ishackable = 0;
	self.m_iscarryable = 0;
	self.m_n_body_trigger_radius = 36;
	self.m_n_body_trigger_height = 128;
	self.m_n_repair_radius = 72;
	self.m_n_repair_height = 128;
	self.m_repair_complete_func = &repair_completed;
	self.m_str_itemname = "Item";
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
	return self.m_e_player_currently_holding;
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
	if(isdefined(self.m_prompt_manager_custom_func))
	{
		self thread [[self.m_prompt_manager_custom_func]]();
	}
	else
	{
		while(isdefined(self.m_e_body_trigger))
		{
			if(!self.m_isfunctional)
			{
				self.m_e_body_trigger sethintstring("Bring Toolbox to repair");
				wait(0.05);
				continue;
			}
			wait(0.05);
		}
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
	if(isdefined(self.m_repair_custom_complete_func))
	{
		self thread [[self.m_repair_custom_complete_func]](player);
	}
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
		self.m_e_body_trigger waittill(#"trigger", player);
		if(isdefined(player.is_carrying_pickupitem) && player.is_carrying_pickupitem && player.o_pickupitem.m_str_itemname == "Toolbox")
		{
			[[ player.o_pickupitem ]]->remove(player);
			[[self.m_repair_complete_func]](player);
		}
		wait(0.05);
	}
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
		assert(!isdefined(self.m_e_body_trigger));
	#/
	self.m_e_body_trigger = e_trigger;
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
	self.m_iscarryable = 1;
	self thread thread_allow_carry();
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
	self.m_iscarryable = 0;
	self notify(#"thread_allow_carry");
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
			self.m_e_body_trigger waittill(#"trigger", e_triggerer);
			self.m_e_body_trigger sethintstringforplayer(e_triggerer, "");
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
		if(!isdefined(self.m_e_body_trigger))
		{
		}
		if(isdefined(e_triggerer.is_carrying_pickupitem) && e_triggerer.is_carrying_pickupitem)
		{
		}
		if(!self.m_iscarryable)
		{
		}
		if(isdefined(e_triggerer.disable_object_pickup) && e_triggerer.disable_object_pickup)
		{
		}
		if(!e_triggerer util::use_button_held())
		{
		}
		if(isdefined(self.m_allow_carry_custom_conditions_func) && ![[self.m_allow_carry_custom_conditions_func]]())
		{
		}
		if(!isdefined(self.m_e_body_trigger))
		{
		}
		if(!e_triggerer istouching(self.m_e_body_trigger))
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
	self.m_e_player_currently_holding = e_triggerer;
	self.m_e_body_trigger notify(#"upgrade_trigger_enable", 0);
	self notify(#"cancel_despawn");
	e_triggerer disableweapons();
	wait(0.5);
	if(isdefined(self.a_carry_threads))
	{
		foreach(var_5b900a43, carry_thread in self.a_carry_threads)
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
	return "Press ^3[{+usereload}]^7 to drop " + self.m_str_itemname;
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
	v_player_angles = v_player_angles + self.m_v_holding_offset_angle;
	v_player_angles = anglestoforward(v_player_angles);
	v_angles = e_triggerer.angles + self.m_v_holding_angle;
	v_origin = v_eye_origin + v_player_angles * self.m_n_holding_distance;
	if(!isdefined(self.m_str_carry_model))
	{
		if(isdefined(self.m_str_modelname))
		{
			self.m_str_carry_model = self.m_str_modelname;
		}
		else
		{
			self.m_str_carry_model = "script_origin";
		}
	}
	self.m_e_carry_model = util::spawn_model(self.m_str_carry_model, v_origin, v_angles);
	self.m_e_carry_model notsolid();
	while(isdefined(self.m_e_carry_model))
	{
		v_eye_origin = e_triggerer geteye();
		v_player_angles = e_triggerer getplayerangles();
		v_player_angles = v_player_angles + self.m_v_holding_offset_angle;
		v_player_angles = anglestoforward(v_player_angles);
		self.m_e_carry_model.angles = e_triggerer.angles + self.m_v_holding_angle;
		self.m_e_carry_model.origin = v_eye_origin + v_player_angles * self.m_n_holding_distance;
		wait(0.05);
	}
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
	if(isdefined(self.m_e_carry_model))
	{
		self.m_e_carry_model delete();
	}
	if(isdefined(self.a_drop_funcs))
	{
		foreach(var_ad517e9c, drop_func in self.a_drop_funcs)
		{
			[[drop_func]](e_triggerer);
		}
	}
	self.m_e_player_currently_holding = undefined;
	self thread thread_allow_carry();
	e_triggerer thread wait_for_button_release();
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
	if(isdefined(self.m_e_carry_model))
	{
		self.m_e_carry_model delete();
	}
	self.m_e_player_currently_holding = undefined;
	self notify(#"respawn_pickupitem");
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
	if(isdefined(self.m_e_player_currently_holding))
	{
		restore_player_controls_from_carry(self.m_e_player_currently_holding);
		self.m_e_player_currently_holding util::screen_message_delete_client();
	}
	if(isdefined(self.m_e_carry_model))
	{
		self.m_e_carry_model delete();
	}
	self.m_e_player_currently_holding = undefined;
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
	self.disable_object_pickup = 1;
	self _wait_for_button_release();
	self.disable_object_pickup = undefined;
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
	if(isdefined(self.m_e_player_currently_holding))
	{
		drop(e_triggerer);
	}
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
	e_repair_trigger = spawn_interact_trigger(v_origin, self.m_n_repair_radius, self.m_n_repair_height, "Bring Toolbox to repair");
	return e_repair_trigger;
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
	e_trigger = spawn_interact_trigger(v_origin, self.m_n_body_trigger_radius, self.m_n_body_trigger_height, "");
	e_trigger sethintlowpriority(1);
	return e_trigger;
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
	Name: __destructor
	Namespace: cbaseinteractable
	Checksum: 0x99EC1590
	Offset: 0x22F8
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function __destructor()
{
}

#namespace pickups;

/*
	Name: cbaseinteractable
	Namespace: pickups
	Checksum: 0x11C3C08
	Offset: 0x2308
	Size: 0x536
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function cbaseinteractable()
{
	classes.cbaseinteractable[0] = spawnstruct();
	classes.cbaseinteractable[0].__vtable[1606033458] = &cbaseinteractable::__destructor;
	classes.cbaseinteractable[0].__vtable[-1422930206] = &cbaseinteractable::spawn_interact_trigger;
	classes.cbaseinteractable[0].__vtable[-1993785684] = &cbaseinteractable::spawn_body_trigger;
	classes.cbaseinteractable[0].__vtable[-1918751361] = &cbaseinteractable::spawn_repair_trigger;
	classes.cbaseinteractable[0].__vtable[738951197] = &cbaseinteractable::drop_on_death;
	classes.cbaseinteractable[0].__vtable[-1751768132] = &cbaseinteractable::_wait_for_button_release;
	classes.cbaseinteractable[0].__vtable[-908068637] = &cbaseinteractable::wait_for_button_release;
	classes.cbaseinteractable[0].__vtable[-1983032275] = &cbaseinteractable::destroy;
	classes.cbaseinteractable[0].__vtable[1998664073] = &cbaseinteractable::remove;
	classes.cbaseinteractable[0].__vtable[1355165250] = &cbaseinteractable::drop;
	classes.cbaseinteractable[0].__vtable[-419528313] = &cbaseinteractable::restore_player_controls_from_carry;
	classes.cbaseinteractable[0].__vtable[1137419972] = &cbaseinteractable::show_carry_model;
	classes.cbaseinteractable[0].__vtable[1366098661] = &cbaseinteractable::thread_allow_drop;
	classes.cbaseinteractable[0].__vtable[87726411] = &cbaseinteractable::flash_drop_prompt_stop;
	classes.cbaseinteractable[0].__vtable[2111823028] = &cbaseinteractable::flash_drop_prompt;
	classes.cbaseinteractable[0].__vtable[1002111075] = &cbaseinteractable::show_drop_prompt;
	classes.cbaseinteractable[0].__vtable[1562574218] = &cbaseinteractable::get_drop_prompt;
	classes.cbaseinteractable[0].__vtable[-234604426] = &cbaseinteractable::carry;
	classes.cbaseinteractable[0].__vtable[-1490407061] = &cbaseinteractable::thread_allow_carry;
	classes.cbaseinteractable[0].__vtable[-444976957] = &cbaseinteractable::disable_carry;
	classes.cbaseinteractable[0].__vtable[1291604272] = &cbaseinteractable::enable_carry;
	classes.cbaseinteractable[0].__vtable[562069659] = &cbaseinteractable::set_body_trigger;
	classes.cbaseinteractable[0].__vtable[-1223116993] = &cbaseinteractable::repair_trigger;
	classes.cbaseinteractable[0].__vtable[1291392716] = &cbaseinteractable::repair_completed;
	classes.cbaseinteractable[0].__vtable[-896363193] = &cbaseinteractable::prompt_manager;
	classes.cbaseinteractable[0].__vtable[131884998] = &cbaseinteractable::get_player_currently_holding;
	classes.cbaseinteractable[0].__vtable[-1690805083] = &cbaseinteractable::__constructor;
}

