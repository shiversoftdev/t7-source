// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#namespace tomb_magicbox;

/*
	Name: __init__sytem__
	Namespace: tomb_magicbox
	Checksum: 0xC6DA96E3
	Offset: 0x248
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("tomb_magicbox", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: tomb_magicbox
	Checksum: 0xAEFCF4F1
	Offset: 0x288
	Size: 0x1A4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("zbarrier", "magicbox_initial_fx", 21000, 1, "int");
	clientfield::register("zbarrier", "magicbox_amb_fx", 21000, 2, "int");
	clientfield::register("zbarrier", "magicbox_open_fx", 21000, 1, "int");
	clientfield::register("zbarrier", "magicbox_leaving_fx", 21000, 1, "int");
	level.chest_joker_custom_movement = &custom_joker_movement;
	level.custom_magic_box_timer_til_despawn = &custom_magic_box_timer_til_despawn;
	level.custom_magic_box_do_weapon_rise = &custom_magic_box_do_weapon_rise;
	level.custom_magic_box_weapon_wait = &custom_magic_box_weapon_wait;
	level.custom_magicbox_float_height = 50;
	level.custom_magic_box_fx = &function_61903aae;
	level.custom_treasure_chest_glowfx = &function_e4e60ea;
	level.magic_box_zbarrier_state_func = &set_magic_box_zbarrier_state;
	level thread wait_then_create_base_magic_box_fx();
	level thread handle_fire_sale();
}

/*
	Name: function_61903aae
	Namespace: tomb_magicbox
	Checksum: 0x99EC1590
	Offset: 0x438
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_61903aae()
{
}

/*
	Name: function_e4e60ea
	Namespace: tomb_magicbox
	Checksum: 0x99EC1590
	Offset: 0x448
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function function_e4e60ea()
{
}

/*
	Name: custom_joker_movement
	Namespace: tomb_magicbox
	Checksum: 0xC3EBAB52
	Offset: 0x458
	Size: 0x1DE
	Parameters: 0
	Flags: Linked
*/
function custom_joker_movement()
{
	v_origin = self.weapon_model.origin - vectorscale((0, 0, 1), 5);
	self.weapon_model delete();
	m_lock = util::spawn_model(level.chest_joker_model, v_origin, self.angles);
	m_lock playsound("zmb_hellbox_bear");
	wait(0.5);
	level notify(#"weapon_fly_away_start");
	wait(1);
	m_lock rotateyaw(3000, 4, 4);
	wait(3);
	v_angles = anglestoforward(self.angles - vectorscale((0, 1, 0), 90));
	m_lock moveto(m_lock.origin + (20 * v_angles), 0.5, 0.5);
	m_lock waittill(#"movedone");
	m_lock moveto(m_lock.origin + -100 * v_angles, 0.5, 0.5);
	m_lock waittill(#"movedone");
	m_lock delete();
	self notify(#"box_moving");
	level notify(#"weapon_fly_away_end");
}

/*
	Name: custom_magic_box_timer_til_despawn
	Namespace: tomb_magicbox
	Checksum: 0x64BA8F14
	Offset: 0x640
	Size: 0xCC
	Parameters: 1
	Flags: Linked
*/
function custom_magic_box_timer_til_despawn(magic_box)
{
	self endon(#"kill_weapon_movement");
	putbacktime = 12;
	v_float = (anglestoforward(magic_box.angles - vectorscale((0, 1, 0), 90))) * 40;
	self moveto(self.origin - (v_float * 0.25), putbacktime, putbacktime * 0.5);
	wait(putbacktime);
	if(isdefined(self))
	{
		self delete();
	}
}

/*
	Name: custom_magic_box_weapon_wait
	Namespace: tomb_magicbox
	Checksum: 0x5F337FCE
	Offset: 0x718
	Size: 0xC
	Parameters: 0
	Flags: Linked
*/
function custom_magic_box_weapon_wait()
{
	wait(0.5);
}

/*
	Name: wait_then_create_base_magic_box_fx
	Namespace: tomb_magicbox
	Checksum: 0xFF0846BE
	Offset: 0x730
	Size: 0xEA
	Parameters: 0
	Flags: Linked
*/
function wait_then_create_base_magic_box_fx()
{
	while(!isdefined(level.chests))
	{
		wait(0.5);
	}
	while(!isdefined(level.chests[level.chests.size - 1].zbarrier))
	{
		wait(0.5);
	}
	foreach(chest in level.chests)
	{
		chest.zbarrier clientfield::set("magicbox_initial_fx", 1);
	}
}

/*
	Name: set_magic_box_zbarrier_state
	Namespace: tomb_magicbox
	Checksum: 0x8DEB4968
	Offset: 0x828
	Size: 0x2BE
	Parameters: 1
	Flags: Linked
*/
function set_magic_box_zbarrier_state(state)
{
	for(i = 0; i < self getnumzbarrierpieces(); i++)
	{
		self hidezbarrierpiece(i);
	}
	self notify(#"zbarrier_state_change");
	switch(state)
	{
		case "away":
		{
			self showzbarrierpiece(0);
			self.state = "away";
			self.owner.is_locked = 0;
			break;
		}
		case "arriving":
		{
			self showzbarrierpiece(1);
			self thread magic_box_arrives();
			self.state = "arriving";
			break;
		}
		case "initial":
		{
			self showzbarrierpiece(1);
			self thread magic_box_initial();
			thread zm_unitrigger::register_static_unitrigger(self.owner.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think);
			self.state = "close";
			break;
		}
		case "open":
		{
			self showzbarrierpiece(2);
			self thread magic_box_opens();
			self.state = "open";
			break;
		}
		case "close":
		{
			self showzbarrierpiece(2);
			self thread magic_box_closes();
			self.state = "close";
			break;
		}
		case "leaving":
		{
			self showzbarrierpiece(1);
			self thread magic_box_leaves();
			self.state = "leaving";
			self.owner.is_locked = 0;
			break;
		}
		default:
		{
			if(isdefined(level.custom_magicbox_state_handler))
			{
				self [[level.custom_magicbox_state_handler]](state);
			}
			break;
		}
	}
}

/*
	Name: magic_box_initial
	Namespace: tomb_magicbox
	Checksum: 0x7E4F1856
	Offset: 0xAF0
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function magic_box_initial()
{
	self setzbarrierpiecestate(1, "open");
	wait(1);
	self clientfield::set("magicbox_amb_fx", 1);
}

/*
	Name: magic_box_arrives
	Namespace: tomb_magicbox
	Checksum: 0x3F37CB33
	Offset: 0xB48
	Size: 0x12C
	Parameters: 0
	Flags: Linked
*/
function magic_box_arrives()
{
	self clientfield::set("magicbox_leaving_fx", 0);
	self setzbarrierpiecestate(1, "opening");
	while(self getzbarrierpiecestate(1) == "opening")
	{
		wait(0.05);
	}
	self notify(#"arrived");
	self.state = "close";
	s_zone_capture_area = level.zone_capture.zones[self.zone_capture_area];
	if(isdefined(s_zone_capture_area))
	{
		if(!s_zone_capture_area flag::get("player_controlled"))
		{
			self clientfield::set("magicbox_amb_fx", 1);
		}
		else
		{
			self clientfield::set("magicbox_amb_fx", 2);
		}
	}
}

/*
	Name: magic_box_leaves
	Namespace: tomb_magicbox
	Checksum: 0x64F0EDA5
	Offset: 0xC80
	Size: 0x188
	Parameters: 0
	Flags: Linked
*/
function magic_box_leaves()
{
	self notify(#"stop_open_idle");
	self clientfield::set("magicbox_leaving_fx", 1);
	self clientfield::set("magicbox_open_fx", 0);
	self setzbarrierpiecestate(1, "closing");
	self playsound("zmb_hellbox_rise");
	while(self getzbarrierpiecestate(1) == "closing")
	{
		wait(0.1);
	}
	self notify(#"left");
	s_zone_capture_area = level.zone_capture.zones[self.zone_capture_area];
	if(isdefined(s_zone_capture_area))
	{
		if(s_zone_capture_area flag::get("player_controlled"))
		{
			self clientfield::set("magicbox_amb_fx", 3);
		}
		else
		{
			self clientfield::set("magicbox_amb_fx", 0);
		}
	}
	if(isdefined(level.dig_magic_box_moved) && !level.dig_magic_box_moved)
	{
		level.dig_magic_box_moved = 1;
	}
}

/*
	Name: magic_box_opens
	Namespace: tomb_magicbox
	Checksum: 0xF61D9DC9
	Offset: 0xE10
	Size: 0xB4
	Parameters: 0
	Flags: Linked
*/
function magic_box_opens()
{
	self clientfield::set("magicbox_open_fx", 1);
	self setzbarrierpiecestate(2, "opening");
	self playsound("zmb_hellbox_open");
	while(self getzbarrierpiecestate(2) == "opening")
	{
		wait(0.1);
	}
	self notify(#"opened");
	self thread magic_box_open_idle();
}

/*
	Name: magic_box_open_idle
	Namespace: tomb_magicbox
	Checksum: 0x4FA48284
	Offset: 0xED0
	Size: 0x98
	Parameters: 0
	Flags: Linked
*/
function magic_box_open_idle()
{
	self endon(#"stop_open_idle");
	self hidezbarrierpiece(2);
	self showzbarrierpiece(5);
	while(true)
	{
		self setzbarrierpiecestate(5, "opening");
		while(self getzbarrierpiecestate(5) != "open")
		{
			wait(0.05);
		}
	}
}

/*
	Name: magic_box_closes
	Namespace: tomb_magicbox
	Checksum: 0x4E92E672
	Offset: 0xF70
	Size: 0xE2
	Parameters: 0
	Flags: Linked
*/
function magic_box_closes()
{
	self notify(#"stop_open_idle");
	self hidezbarrierpiece(5);
	self showzbarrierpiece(2);
	self setzbarrierpiecestate(2, "closing");
	self playsound("zmb_hellbox_close");
	self clientfield::set("magicbox_open_fx", 0);
	while(self getzbarrierpiecestate(2) == "closing")
	{
		wait(0.1);
	}
	self notify(#"closed");
}

/*
	Name: custom_magic_box_do_weapon_rise
	Namespace: tomb_magicbox
	Checksum: 0xDD61BD07
	Offset: 0x1060
	Size: 0x16C
	Parameters: 0
	Flags: Linked
*/
function custom_magic_box_do_weapon_rise()
{
	self endon(#"box_hacked_respin");
	wait(0.5);
	self setzbarrierpiecestate(3, "closed");
	self setzbarrierpiecestate(4, "closed");
	util::wait_network_frame();
	self zbarrierpieceuseboxriselogic(3);
	self zbarrierpieceuseboxriselogic(4);
	self showzbarrierpiece(3);
	self showzbarrierpiece(4);
	self setzbarrierpiecestate(3, "opening");
	self setzbarrierpiecestate(4, "opening");
	while(self getzbarrierpiecestate(3) != "open")
	{
		wait(0.5);
	}
	self hidezbarrierpiece(3);
	self hidezbarrierpiece(4);
}

/*
	Name: handle_fire_sale
	Namespace: tomb_magicbox
	Checksum: 0xFBF850B3
	Offset: 0x11D8
	Size: 0x15A
	Parameters: 0
	Flags: Linked
*/
function handle_fire_sale()
{
	while(true)
	{
		level waittill(#"fire_sale_off");
		for(i = 0; i < level.chests.size; i++)
		{
			if(level.chest_index != i && isdefined(level.chests[i].was_temp))
			{
				if(isdefined(level.chests[i].zbarrier.zone_capture_area) && level.zone_capture.zones[level.chests[i].zbarrier.zone_capture_area] flag::get("player_controlled"))
				{
					level.chests[i].zbarrier clientfield::set("magicbox_amb_fx", 3);
					continue;
				}
				level.chests[i].zbarrier clientfield::set("magicbox_amb_fx", 0);
			}
		}
	}
}

