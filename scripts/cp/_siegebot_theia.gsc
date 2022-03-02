#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\ai\blackboard_vehicle;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_siegebot;
#using scripts\shared\weapons\_spike_charge_siegebot;

#using_animtree("generic");

#namespace siegebot_theia;

/*
	Name: __init__sytem__
	Namespace: siegebot_theia
	Checksum: 0xCDC49E6C
	Offset: 0x660
	Size: 0x0
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	// Unsupported VM revision (1B).
}

/*
	Name: __init__
	Namespace: siegebot_theia
	Checksum: 0xE12CD782
	Offset: 0x698
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function __init__()
{
	// Unsupported VM revision (1B).
}

/*
	Name: siegebot_initialize
	Namespace: siegebot_theia
	Checksum: 0x206A8F6F
	Offset: 0x720
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function siegebot_initialize()
{
	// Unsupported VM revision (1B).
}

/*
	Name: init_clientfields
	Namespace: siegebot_theia
	Checksum: 0x9353A324
	Offset: 0x9A8
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function init_clientfields()
{
	// Unsupported VM revision (1B).
}

/*
	Name: defaultrole
	Namespace: siegebot_theia
	Checksum: 0xA83C0FBE
	Offset: 0xA28
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function defaultrole()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_death_update
	Namespace: siegebot_theia
	Checksum: 0xE84E82A6
	Offset: 0xED0
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_death_update()
{
	// Unsupported VM revision (1B).
}

/*
	Name: clean_up_spawned
	Namespace: siegebot_theia
	Checksum: 0x682B04D4
	Offset: 0xF90
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function clean_up_spawned()
{
	// Unsupported VM revision (1B).
}

/*
	Name: pain_toggle
	Namespace: siegebot_theia
	Checksum: 0xBB309767
	Offset: 0x1058
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function pain_toggle()
{
	// Unsupported VM revision (1B).
}

/*
	Name: pain_canenter
	Namespace: siegebot_theia
	Checksum: 0xA47CA503
	Offset: 0x1078
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function pain_canenter()
{
	// Unsupported VM revision (1B).
}

/*
	Name: pain_enter
	Namespace: siegebot_theia
	Checksum: 0xF9D16950
	Offset: 0x10C0
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function pain_enter()
{
	// Unsupported VM revision (1B).
}

/*
	Name: pain_exit
	Namespace: siegebot_theia
	Checksum: 0xF5EF97A0
	Offset: 0x10E8
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function pain_exit()
{
	// Unsupported VM revision (1B).
}

/*
	Name: pain_update
	Namespace: siegebot_theia
	Checksum: 0xFAA5ED71
	Offset: 0x1110
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function pain_update()
{
	// Unsupported VM revision (1B).
}

/*
	Name: should_prepare_death
	Namespace: siegebot_theia
	Checksum: 0x21C07CFD
	Offset: 0x1220
	Size: 0x0
	Parameters: 3
	Flags: None
*/
function should_prepare_death()
{
	// Unsupported VM revision (1B).
}

/*
	Name: prepare_death_update
	Namespace: siegebot_theia
	Checksum: 0xB10B8358
	Offset: 0x1278
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function prepare_death_update()
{
	// Unsupported VM revision (1B).
}

/*
	Name: scripted_exit
	Namespace: siegebot_theia
	Checksum: 0xBEF5F61F
	Offset: 0x1408
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function scripted_exit()
{
	// Unsupported VM revision (1B).
}

/*
	Name: initjumpstruct
	Namespace: siegebot_theia
	Checksum: 0x91A85E36
	Offset: 0x1450
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function initjumpstruct()
{
	// Unsupported VM revision (1B).
}

/*
	Name: can_jump_up
	Namespace: siegebot_theia
	Checksum: 0xB095169A
	Offset: 0x1638
	Size: 0x0
	Parameters: 3
	Flags: None
*/
function can_jump_up()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_jumpup_enter
	Namespace: siegebot_theia
	Checksum: 0x97B730B3
	Offset: 0x16E8
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_jumpup_enter()
{
	// Unsupported VM revision (1B).
}

/*
	Name: can_jump_down
	Namespace: siegebot_theia
	Checksum: 0x2A6AB61C
	Offset: 0x1878
	Size: 0x0
	Parameters: 3
	Flags: None
*/
function can_jump_down()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_jumpdown_enter
	Namespace: siegebot_theia
	Checksum: 0x48AF7051
	Offset: 0x1910
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_jumpdown_enter()
{
	// Unsupported VM revision (1B).
}

/*
	Name: can_jump_ground_to_ground
	Namespace: siegebot_theia
	Checksum: 0xCE9B1101
	Offset: 0x1A98
	Size: 0x0
	Parameters: 3
	Flags: None
*/
function can_jump_ground_to_ground()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_jump_exit
	Namespace: siegebot_theia
	Checksum: 0xE34F5DA1
	Offset: 0x1B20
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_jump_exit()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_jumpdown_exit
	Namespace: siegebot_theia
	Checksum: 0xDCCB2274
	Offset: 0x1B48
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_jumpdown_exit()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_jump_update
	Namespace: siegebot_theia
	Checksum: 0x976A1429
	Offset: 0x1BA0
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_jump_update()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_balconycombat_enter
	Namespace: siegebot_theia
	Checksum: 0xF16A288C
	Offset: 0x25B0
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_balconycombat_enter()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_balconycombat_update
	Namespace: siegebot_theia
	Checksum: 0x2F212D1C
	Offset: 0x2648
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_balconycombat_update()
{
	// Unsupported VM revision (1B).
}

/*
	Name: side_step
	Namespace: siegebot_theia
	Checksum: 0xB422171B
	Offset: 0x2898
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function side_step()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_balconycombat_exit
	Namespace: siegebot_theia
	Checksum: 0xBFB70470
	Offset: 0x2AC0
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_balconycombat_exit()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_groundcombat_update
	Namespace: siegebot_theia
	Checksum: 0xE72F6EA
	Offset: 0x2B58
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_groundcombat_update()
{
	// Unsupported VM revision (1B).
}

/*
	Name: footstep_damage
	Namespace: siegebot_theia
	Checksum: 0x26246CAE
	Offset: 0x2C20
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function footstep_damage()
{
	// Unsupported VM revision (1B).
}

/*
	Name: footstep_left_monitor
	Namespace: siegebot_theia
	Checksum: 0x5A17C897
	Offset: 0x2D90
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function footstep_left_monitor()
{
	// Unsupported VM revision (1B).
}

/*
	Name: footstep_right_monitor
	Namespace: siegebot_theia
	Checksum: 0x452B49C7
	Offset: 0x2DE8
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function footstep_right_monitor()
{
	// Unsupported VM revision (1B).
}

/*
	Name: highgroundpoint
	Namespace: siegebot_theia
	Checksum: 0x34D4324F
	Offset: 0x2E40
	Size: 0x0
	Parameters: 4
	Flags: None
*/
function highgroundpoint()
{
	// Unsupported VM revision (1B).
}

/*
	Name: state_groundcombat_exit
	Namespace: siegebot_theia
	Checksum: 0x7E0D8E59
	Offset: 0x3098
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function state_groundcombat_exit()
{
	// Unsupported VM revision (1B).
}

/*
	Name: get_player_vehicle
	Namespace: siegebot_theia
	Checksum: 0xAFC3D17F
	Offset: 0x30E0
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function get_player_vehicle()
{
	// Unsupported VM revision (1B).
}

/*
	Name: get_player_and_vehicle_array
	Namespace: siegebot_theia
	Checksum: 0x52811575
	Offset: 0x3148
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function get_player_and_vehicle_array()
{
	// Unsupported VM revision (1B).
}

/*
	Name: init_player_threat
	Namespace: siegebot_theia
	Checksum: 0x26F063B5
	Offset: 0x3240
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function init_player_threat()
{
	// Unsupported VM revision (1B).
}

/*
	Name: init_player_threat_all
	Namespace: siegebot_theia
	Checksum: 0x22968FA2
	Offset: 0x3318
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function init_player_threat_all()
{
	// Unsupported VM revision (1B).
}

/*
	Name: reset_player_threat
	Namespace: siegebot_theia
	Checksum: 0xD0F7D87B
	Offset: 0x33E8
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function reset_player_threat()
{
	// Unsupported VM revision (1B).
}

/*
	Name: add_player_threat_damage
	Namespace: siegebot_theia
	Checksum: 0x330E699
	Offset: 0x3510
	Size: 0x0
	Parameters: 2
	Flags: None
*/
function add_player_threat_damage()
{
	// Unsupported VM revision (1B).
}

/*
	Name: add_player_threat_boost
	Namespace: siegebot_theia
	Checksum: 0x8BEFA096
	Offset: 0x3570
	Size: 0x0
	Parameters: 3
	Flags: None
*/
function add_player_threat_boost()
{
	// Unsupported VM revision (1B).
}

/*
	Name: get_player_threat
	Namespace: siegebot_theia
	Checksum: 0xB869AA19
	Offset: 0x3618
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function get_player_threat()
{
	// Unsupported VM revision (1B).
}

/*
	Name: update_target_player
	Namespace: siegebot_theia
	Checksum: 0xDE80E3B1
	Offset: 0x37B0
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function update_target_player()
{
	// Unsupported VM revision (1B).
}

/*
	Name: shoulder_light_focus
	Namespace: siegebot_theia
	Checksum: 0x94B8A9BE
	Offset: 0x3868
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function shoulder_light_focus()
{
	// Unsupported VM revision (1B).
}

/*
	Name: debug_line_to_target
	Namespace: siegebot_theia
	Checksum: 0x76C69FF0
	Offset: 0x38E0
	Size: 0x0
	Parameters: 3
	Flags: None
*/
function debug_line_to_target()
{
	// Unsupported VM revision (1B).
}

/*
	Name: pin_first_three_spikes_to_ground
	Namespace: siegebot_theia
	Checksum: 0x2ED8516C
	Offset: 0x3978
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function pin_first_three_spikes_to_ground()
{
	// Unsupported VM revision (1B).
}

/*
	Name: attack_thread_gun
	Namespace: siegebot_theia
	Checksum: 0x9E2EECC4
	Offset: 0x39F8
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function attack_thread_gun()
{
	// Unsupported VM revision (1B).
}

/*
	Name: attack_thread_rocket
	Namespace: siegebot_theia
	Checksum: 0x80220FC4
	Offset: 0x3D00
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function attack_thread_rocket()
{
	// Unsupported VM revision (1B).
}

/*
	Name: toggle_rocketaim
	Namespace: siegebot_theia
	Checksum: 0x6148A40C
	Offset: 0x42F8
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function toggle_rocketaim()
{
	// Unsupported VM revision (1B).
}

/*
	Name: locomotion_start
	Namespace: siegebot_theia
	Checksum: 0x488C0412
	Offset: 0x4328
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function locomotion_start()
{
	// Unsupported VM revision (1B).
}

/*
	Name: get_strong_target
	Namespace: siegebot_theia
	Checksum: 0x3E4B5DD9
	Offset: 0x4378
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function get_strong_target()
{
	// Unsupported VM revision (1B).
}

/*
	Name: movement_thread
	Namespace: siegebot_theia
	Checksum: 0x36ADCFAC
	Offset: 0x44C0
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function movement_thread()
{
	// Unsupported VM revision (1B).
}

/*
	Name: path_update_interrupt
	Namespace: siegebot_theia
	Checksum: 0xC065A68B
	Offset: 0x4700
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function path_update_interrupt()
{
	// Unsupported VM revision (1B).
}

/*
	Name: getnextmoveposition
	Namespace: siegebot_theia
	Checksum: 0x21D39470
	Offset: 0x4798
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function getnextmoveposition()
{
	// Unsupported VM revision (1B).
}

/*
	Name: _sort_by_distance2d
	Namespace: siegebot_theia
	Checksum: 0x9531FD6D
	Offset: 0x4CC8
	Size: 0x0
	Parameters: 3
	Flags: None
*/
function _sort_by_distance2d()
{
	// Unsupported VM revision (1B).
}

/*
	Name: too_close_to_high_ground
	Namespace: siegebot_theia
	Checksum: 0xE9B20E9E
	Offset: 0x4D40
	Size: 0x0
	Parameters: 2
	Flags: None
*/
function too_close_to_high_ground()
{
	// Unsupported VM revision (1B).
}

/*
	Name: get_jumpon_target
	Namespace: siegebot_theia
	Checksum: 0x8AB4D191
	Offset: 0x4DE0
	Size: 0x0
	Parameters: 6
	Flags: None
*/
function get_jumpon_target()
{
	// Unsupported VM revision (1B).
}

/*
	Name: stopmovementandsetbrake
	Namespace: siegebot_theia
	Checksum: 0xABC3FCAA
	Offset: 0x54B0
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function stopmovementandsetbrake()
{
	// Unsupported VM revision (1B).
}

/*
	Name: face_target
	Namespace: siegebot_theia
	Checksum: 0x9D3681F8
	Offset: 0x5520
	Size: 0x0
	Parameters: 2
	Flags: None
*/
function face_target()
{
	// Unsupported VM revision (1B).
}

/*
	Name: theia_callback_damage
	Namespace: siegebot_theia
	Checksum: 0xD3311C00
	Offset: 0x56C0
	Size: 0x0
	Parameters: 13
	Flags: None
*/
function theia_callback_damage()
{
	// Unsupported VM revision (1B).
}

/*
	Name: attack_javelin
	Namespace: siegebot_theia
	Checksum: 0xD055A05F
	Offset: 0x58B8
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function attack_javelin()
{
	// Unsupported VM revision (1B).
}

/*
	Name: javeline_incoming
	Namespace: siegebot_theia
	Checksum: 0x6085D1AB
	Offset: 0x5B10
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function javeline_incoming()
{
	// Unsupported VM revision (1B).
}

/*
	Name: init_fake_targets
	Namespace: siegebot_theia
	Checksum: 0xCE3C9382
	Offset: 0x5BF8
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function init_fake_targets()
{
	// Unsupported VM revision (1B).
}

/*
	Name: pin_to_ground
	Namespace: siegebot_theia
	Checksum: 0xB2FF8F51
	Offset: 0x5D08
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function pin_to_ground()
{
	// Unsupported VM revision (1B).
}

/*
	Name: pin_spike_to_ground
	Namespace: siegebot_theia
	Checksum: 0xE34B9EF1
	Offset: 0x5DA0
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function pin_spike_to_ground()
{
	// Unsupported VM revision (1B).
}

/*
	Name: spike_score
	Namespace: siegebot_theia
	Checksum: 0xE508587B
	Offset: 0x5EF8
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function spike_score()
{
	// Unsupported VM revision (1B).
}

/*
	Name: spike_group_score
	Namespace: siegebot_theia
	Checksum: 0x744147AD
	Offset: 0x5F80
	Size: 0x0
	Parameters: 3
	Flags: None
*/
function spike_group_score()
{
	// Unsupported VM revision (1B).
}

/*
	Name: attack_spike_minefield
	Namespace: siegebot_theia
	Checksum: 0xE9E7DE45
	Offset: 0x6058
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function attack_spike_minefield()
{
	// Unsupported VM revision (1B).
}

/*
	Name: delay_target_toenemy_thread
	Namespace: siegebot_theia
	Checksum: 0x2AADD339
	Offset: 0x64A8
	Size: 0x0
	Parameters: 3
	Flags: None
*/
function delay_target_toenemy_thread()
{
	// Unsupported VM revision (1B).
}

/*
	Name: is_valid_target
	Namespace: siegebot_theia
	Checksum: 0x87316059
	Offset: 0x6630
	Size: 0x0
	Parameters: 1
	Flags: None
*/
function is_valid_target()
{
	// Unsupported VM revision (1B).
}

/*
	Name: get_enemy
	Namespace: siegebot_theia
	Checksum: 0x16A4AF9
	Offset: 0x66F0
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function get_enemy()
{
	// Unsupported VM revision (1B).
}

/*
	Name: attack_minigun_sweep
	Namespace: siegebot_theia
	Checksum: 0xC6D984F2
	Offset: 0x6830
	Size: 0x0
	Parameters: 0
	Flags: None
*/
function attack_minigun_sweep()
{
	// Unsupported VM revision (1B).
}

