// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;

class cpoweronswitch 
{
	var m_t_switch;
	var m_arg1;
	var m_func;
	var m_n_power_index;
	var m_mdl_switch;

	/*
		Name: constructor
		Namespace: cpoweronswitch
		Checksum: 0x99EC1590
		Offset: 0x5D8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
	}

	/*
		Name: destructor
		Namespace: cpoweronswitch
		Checksum: 0x99EC1590
		Offset: 0x5E8
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: local_power_on
		Namespace: cpoweronswitch
		Checksum: 0xE984FEA1
		Offset: 0x538
		Size: 0x94
		Parameters: 0
		Flags: Linked
	*/
	function local_power_on()
	{
		m_t_switch sethintstring(&"ZM_ZOD_POWERSWITCH_POWERED");
		do
		{
			m_t_switch waittill(#"trigger", player);
		}
		while(!can_player_use(player));
		m_t_switch setinvisibletoall();
		[[m_func]](m_arg1);
	}

	/*
		Name: can_player_use
		Namespace: cpoweronswitch
		Checksum: 0x7076DE93
		Offset: 0x4E8
		Size: 0x46
		Parameters: 1
		Flags: Linked
	*/
	function can_player_use(player)
	{
		if(player zm_utility::in_revive_trigger())
		{
			return false;
		}
		if(player.is_drinking > 0)
		{
			return false;
		}
		return true;
	}

	/*
		Name: show_activated_state
		Namespace: cpoweronswitch
		Checksum: 0xCA7F8CCA
		Offset: 0x4C0
		Size: 0x1C
		Parameters: 0
		Flags: Linked
	*/
	function show_activated_state()
	{
		m_t_switch setinvisibletoall();
	}

	/*
		Name: poweronswitch_think
		Namespace: cpoweronswitch
		Checksum: 0x2E261650
		Offset: 0x478
		Size: 0x3C
		Parameters: 0
		Flags: Linked
	*/
	function poweronswitch_think()
	{
		level flag::wait_till("power_on" + m_n_power_index);
		local_power_on();
	}

	/*
		Name: filter_areaname
		Namespace: cpoweronswitch
		Checksum: 0xECC657E
		Offset: 0x428
		Size: 0x48
		Parameters: 2
		Flags: Linked
	*/
	function filter_areaname(e_entity, str_areaname)
	{
		if(!isdefined(e_entity.script_string) || e_entity.script_string != str_areaname)
		{
			return false;
		}
		return true;
	}

	/*
		Name: init_poweronswitch
		Namespace: cpoweronswitch
		Checksum: 0x7FD9638B
		Offset: 0x238
		Size: 0x1E4
		Parameters: 6
		Flags: Linked
	*/
	function init_poweronswitch(str_areaname, script_int, linkto_target, func, arg1, n_iter = 0)
	{
		a_mdl_switch = getentarray("stair_control", "targetname");
		a_mdl_switch = array::filter(a_mdl_switch, 0, &filter_areaname, str_areaname);
		m_mdl_switch = a_mdl_switch[n_iter];
		a_t_switch = getentarray("stair_control_usetrigger", "targetname");
		a_t_switch = array::filter(a_t_switch, 0, &filter_areaname, str_areaname);
		m_t_switch = a_t_switch[n_iter];
		m_t_switch sethintstring(&"ZM_ZOD_POWERSWITCH_UNPOWERED");
		m_n_power_index = script_int;
		m_func = func;
		m_arg1 = arg1;
		m_t_switch enablelinkto();
		m_t_switch linkto(m_mdl_switch);
		if(isdefined(linkto_target))
		{
			m_mdl_switch linkto(linkto_target);
		}
		self thread poweronswitch_think();
	}

}

