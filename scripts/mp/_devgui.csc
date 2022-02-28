// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#namespace mp_devgui;

/*
	Name: __init__sytem__
	Namespace: mp_devgui
	Checksum: 0x9457F723
	Offset: 0xD8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("mp_devgui", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: mp_devgui
	Checksum: 0x99EC1590
	Offset: 0x118
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
}

/*
	Name: remove_mp_contracts_devgui
	Namespace: mp_devgui
	Checksum: 0xDBBA9D9C
	Offset: 0x128
	Size: 0x4E
	Parameters: 1
	Flags: Linked
*/
function remove_mp_contracts_devgui(localclientnum)
{
	/#
		if(level.mp_contracts_devgui_added === 1)
		{
			/#
				adddebugcommand(localclientnum, "");
			#/
			level.mp_contracts_devgui_added = undefined;
		}
	#/
}

/*
	Name: create_mp_contracts_devgui
	Namespace: mp_devgui
	Checksum: 0x2E67B32E
	Offset: 0x180
	Size: 0x110
	Parameters: 1
	Flags: Linked
*/
function create_mp_contracts_devgui(localclientnum)
{
	/#
		level notify(#"create_mp_contracts_devgui_singleton");
		level endon(#"create_mp_contracts_devgui_singleton");
		remove_mp_contracts_devgui(localclientnum);
		wait(0.05);
		if(0)
		{
			return;
		}
		frontend_slots = 4;
		for(slot = 0; slot < frontend_slots; slot++)
		{
			add_contract_slot(localclientnum, slot);
			wait(0.1);
		}
		wait(0.1);
		add_blackjack_contract(localclientnum);
		wait(0.1);
		add_devgui_scheduler(localclientnum);
		level thread watch_devgui();
		level.mp_contracts_devgui_added = 1;
	#/
}

/*
	Name: add_blackjack_contract
	Namespace: mp_devgui
	Checksum: 0xA22A1402
	Offset: 0x298
	Size: 0x476
	Parameters: 1
	Flags: Linked
*/
function add_blackjack_contract(localclientnum)
{
	/#
		root = "";
		next_cmd = "";
		add_blackjack_contract_set_count(localclientnum, root, 0);
		add_blackjack_contract_set_count(localclientnum, root, 1);
		add_blackjack_contract_set_count(localclientnum, root, 5);
		add_blackjack_contract_set_count(localclientnum, root, 10);
		add_blackjack_contract_set_count(localclientnum, root, 200);
		add_blackjack_contract_set_count(localclientnum, root, 3420);
		root = "";
		stat_write = "";
		set_blackjack = "";
		cmds = stat_write + "";
		add_devgui_cmd(localclientnum, root + "", cmds);
		cmds = stat_write + "";
		cmds = cmds + next_cmd;
		cmds = cmds + (stat_write + "");
		cmds = cmds + next_cmd;
		cmds = cmds + (set_blackjack + "");
		cmds = cmds + next_cmd;
		cmds = cmds + (set_blackjack + "");
		add_devgui_cmd(localclientnum, root + "", cmds);
		cmds = stat_write + "";
		add_devgui_cmd(localclientnum, root + "", cmds);
		cmds = stat_write + "";
		cmds = cmds + next_cmd;
		cmds = cmds + (stat_write + "");
		cmds = cmds + next_cmd;
		cmds = cmds + (set_blackjack + "");
		cmds = cmds + next_cmd;
		cmds = cmds + (set_blackjack + "");
		add_devgui_cmd(localclientnum, root + "", cmds);
		side_bet_root = "";
		stat_write_bjc = "";
		stat_write_bjc_master = "";
		for(i = 0; i <= 6; i++)
		{
			cmds = (stat_write_bjc + "") + i;
			cmds = cmds + next_cmd;
			cmds = cmds + ((stat_write_bjc + "") + i);
			cmds = cmds + next_cmd;
			cmds = cmds + (stat_write_bjc_master + "") + (i == 6 ? 1 : 0);
			cmds = cmds + next_cmd;
			cmds = cmds + (stat_write_bjc_master + "") + (i == 6 ? 1 : 0);
			add_devgui_cmd(localclientnum, (side_bet_root + "") + i, cmds);
		}
	#/
}

/*
	Name: add_blackjack_contract_set_count
	Namespace: mp_devgui
	Checksum: 0x9654F7FE
	Offset: 0x718
	Size: 0xAC
	Parameters: 3
	Flags: Linked
*/
function add_blackjack_contract_set_count(localclientnum, root, contract_count)
{
	/#
		cmds = "" + contract_count;
		item_text = (contract_count == 1 ? "" : "");
		add_devgui_cmd(localclientnum, ((((root + "") + contract_count) + item_text) + "") + contract_count, cmds);
	#/
}

/*
	Name: add_contract_slot
	Namespace: mp_devgui
	Checksum: 0x3CF3F061
	Offset: 0x7D0
	Size: 0x74C
	Parameters: 2
	Flags: Linked
*/
function add_contract_slot(localclientnum, slot)
{
	/#
		root = "" + slot;
		add_weekly = 1;
		add_daily = 1;
		var_5ed3f7ba = 0;
		switch(slot)
		{
			case 0:
			{
				root = root + "";
				add_daily = 0;
				break;
			}
			case 1:
			{
				root = root + "";
				add_daily = 0;
				break;
			}
			case 2:
			{
				root = root + "";
				add_weekly = 0;
				break;
			}
			case 3:
			{
				root = root + "";
				add_daily = 0;
				add_weekly = 0;
				var_5ed3f7ba = 1;
				break;
			}
			default:
			{
				root = root + "";
				break;
			}
		}
		root = root + (("" + slot) + "");
		table = "";
		num_rows = tablelookuprowcount(table);
		stat_write = "" + slot;
		next_cmd = "";
		max_title_width = 30;
		ellipsis = "";
		truncated_title_end_index = (max_title_width - ellipsis.size) - 1;
		cmds_added = 0;
		max_cmd_to_add = 5;
		for(row = 1; row < num_rows; row++)
		{
			row_info = tablelookuprow(table, row);
			if(strisnumber(row_info[0]))
			{
				table_index = int(row_info[0]);
				is_daily_index = table_index >= 1000 && table_index <= 2999;
				is_weekly_index = table_index >= 1 && table_index <= 999;
				var_a8c2111c = table_index >= 3000 && table_index <= 3999;
				if(is_daily_index && !add_daily)
				{
					continue;
				}
				if(is_weekly_index && !add_weekly)
				{
					continue;
				}
				if(var_a8c2111c && !var_5ed3f7ba)
				{
					continue;
				}
				title_str = (row_info[4].size > 0 ? row_info[4] : row_info[3]);
				title = makelocalizedstring("" + title_str);
				if(title.size > max_title_width)
				{
					title = getsubstr(title, 0, truncated_title_end_index) + ellipsis;
				}
				submenu_name = ((title + "") + table_index) + "";
				if(var_a8c2111c)
				{
					challenge_type = "";
				}
				else
				{
					challenge_type = (is_weekly_index ? "" : "");
				}
				cmds = (stat_write + "") + table_index;
				cmds = cmds + next_cmd;
				cmds = cmds + (stat_write + "");
				cmds = cmds + next_cmd;
				cmds = cmds + (stat_write + "");
				cmds = cmds + next_cmd;
				cmds = cmds + (stat_write + "");
				cmds = cmds + next_cmd;
				cmds = cmds + "";
				cmds = wrap_dvarconfig_cmds(cmds);
				if(var_5ed3f7ba)
				{
					by_index_name = "";
				}
				else
				{
					if(add_daily && add_weekly)
					{
						by_index_name = "";
					}
					else
					{
						if(add_daily)
						{
							by_index_name = "";
						}
						else
						{
							if(add_weekly)
							{
								by_index_name = "";
							}
							else
							{
								by_index_name = "";
							}
						}
					}
				}
				index_submenu_name = (submenu_name + "") + table_index;
				add_devgui_cmd(localclientnum, (root + challenge_type) + submenu_name, cmds);
				add_devgui_cmd(localclientnum, (root + by_index_name) + index_submenu_name, cmds);
				cmds_added++;
				if(cmds_added >= max_cmd_to_add)
				{
					wait(0.1);
					cmds_added = 0;
				}
			}
		}
		if(slot == 3)
		{
			cmds = stat_write + "";
			cmds = cmds + next_cmd;
			cmds = cmds + (stat_write + "");
			add_devgui_cmd(localclientnum, root + "", cmds);
		}
		cmds = stat_write + "";
		cmds = cmds + next_cmd;
		cmds = cmds + (stat_write + "");
		add_devgui_cmd(localclientnum, root + "", cmds);
	#/
}

/*
	Name: add_devgui_scheduler
	Namespace: mp_devgui
	Checksum: 0x8074706
	Offset: 0xF28
	Size: 0x2C4
	Parameters: 1
	Flags: Linked
*/
function add_devgui_scheduler(localclientnum)
{
	/#
		root = "";
		root_daily = root + "";
		add_contract_scheduler_daily_duration(localclientnum, root_daily, "", 86400);
		add_contract_scheduler_daily_duration(localclientnum, root_daily, "", 1);
		add_contract_scheduler_daily_duration(localclientnum, root_daily, "", 3);
		add_contract_scheduler_daily_duration(localclientnum, root_daily, "", 10);
		add_contract_scheduler_daily_duration(localclientnum, root_daily, "", 60);
		add_contract_scheduler_daily_duration(localclientnum, root_daily, "", 120);
		add_contract_scheduler_daily_duration(localclientnum, root_daily, "", 600);
		add_contract_scheduler_daily_duration(localclientnum, root_daily, "", 1800);
		add_contract_scheduler_daily_duration(localclientnum, root_daily, "", 3600);
		cmds = "";
		add_watched_devgui_cmd(localclientnum, root + "", cmds);
		cmds = "";
		add_watched_devgui_cmd(localclientnum, root + "", cmds);
		cmds = "";
		add_watched_devgui_cmd(localclientnum, root + "", cmds);
		cmds = "";
		add_watched_devgui_cmd(localclientnum, root + "", cmds);
		cmds = "";
		add_watched_devgui_cmd(localclientnum, root + "", cmds);
	#/
}

/*
	Name: add_watched_devgui_cmd
	Namespace: mp_devgui
	Checksum: 0xE607CA0A
	Offset: 0x11F8
	Size: 0x74
	Parameters: 3
	Flags: Linked
*/
function add_watched_devgui_cmd(localclientnum, root, cmds)
{
	/#
		next_cmd = "";
		cmds = cmds + next_cmd;
		cmds = cmds + "";
		add_devgui_cmd(localclientnum, root, cmds);
	#/
}

/*
	Name: add_contract_scheduler_daily_duration
	Namespace: mp_devgui
	Checksum: 0xD2411B73
	Offset: 0x1278
	Size: 0xBC
	Parameters: 4
	Flags: Linked
*/
function add_contract_scheduler_daily_duration(localclientnum, root, label, daily_duration)
{
	/#
		next_cmd = "";
		cmds = "" + daily_duration;
		cmds = cmds + next_cmd;
		cmds = cmds + "";
		cmds = wrap_dvarconfig_cmds(cmds);
		add_devgui_cmd(localclientnum, root + label, cmds);
	#/
}

/*
	Name: wrap_dvarconfig_cmds
	Namespace: mp_devgui
	Checksum: 0xC954FA29
	Offset: 0x1340
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function wrap_dvarconfig_cmds(cmds)
{
	/#
		next_cmd = "";
		newcmds = "";
		newcmds = newcmds + next_cmd;
		newcmds = newcmds + cmds;
		return newcmds;
	#/
}

/*
	Name: add_devgui_cmd
	Namespace: mp_devgui
	Checksum: 0xB16161D2
	Offset: 0x13A8
	Size: 0x64
	Parameters: 3
	Flags: Linked
*/
function add_devgui_cmd(localclientnum, menu_path, cmds)
{
	/#
		/#
			adddebugcommand(localclientnum, ((("" + menu_path) + "") + cmds) + "");
		#/
	#/
}

/*
	Name: calculate_schedule_start_time
	Namespace: mp_devgui
	Checksum: 0x3827E69A
	Offset: 0x1418
	Size: 0xE2
	Parameters: 1
	Flags: Linked
*/
function calculate_schedule_start_time(ref_time)
{
	/#
		new_start_time = ref_time;
		daily_duration = getdvarint("", 60);
		weekly_duration = daily_duration * 7;
		schedule_duration = weekly_duration * 8;
		max_multiple = int(ref_time / schedule_duration);
		half_max_multiple = int(max_multiple / 2);
		new_start_time = new_start_time - (half_max_multiple * schedule_duration);
		return new_start_time;
	#/
}

/*
	Name: watch_devgui
	Namespace: mp_devgui
	Checksum: 0x592BE4F0
	Offset: 0x1508
	Size: 0x298
	Parameters: 0
	Flags: Linked
*/
function watch_devgui()
{
	/#
		level notify(#"watch_devgui_client_mp_singleton");
		level endon(#"watch_devgui_client_mp_singleton");
		while(true)
		{
			wait(0.1);
			if(!dvar_has_value(""))
			{
				continue;
			}
			saved_dvarconfigenabled = getdvarint("", 1);
			if(dvar_has_value(""))
			{
				setdvar("", 0);
				now = getutc();
				setdvar("", calculate_schedule_start_time(now));
				clear_dvar("");
			}
			if(dvar_has_value(""))
			{
				update_contract_start_time(-1);
				clear_dvar("");
			}
			if(dvar_has_value(""))
			{
				update_contract_start_time(-7);
				clear_dvar("");
			}
			if(dvar_has_value(""))
			{
				update_contract_start_time(1);
				clear_dvar("");
			}
			if(dvar_has_value(""))
			{
				update_contract_start_time(7);
				clear_dvar("");
			}
			if(saved_dvarconfigenabled != getdvarint("", 1))
			{
				setdvar("", saved_dvarconfigenabled);
			}
			clear_dvar("");
		}
	#/
}

/*
	Name: update_contract_start_time
	Namespace: mp_devgui
	Checksum: 0x69A3BF23
	Offset: 0x17A8
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function update_contract_start_time(delta_days)
{
	/#
		setdvar("", 0);
		start_time = get_schedule_start_time();
		daily_duration = getdvarint("", 60);
		setdvar("", start_time + (daily_duration * delta_days));
	#/
}

/*
	Name: dvar_has_value
	Namespace: mp_devgui
	Checksum: 0xE52AA471
	Offset: 0x1850
	Size: 0x2E
	Parameters: 1
	Flags: Linked
*/
function dvar_has_value(dvar_name)
{
	/#
		return getdvarint(dvar_name, 0) != 0;
	#/
}

/*
	Name: clear_dvar
	Namespace: mp_devgui
	Checksum: 0x876F9ABF
	Offset: 0x1888
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function clear_dvar(dvar_name)
{
	/#
		setdvar(dvar_name, 0);
	#/
}

/*
	Name: get_schedule_start_time
	Namespace: mp_devgui
	Checksum: 0x305AB4BF
	Offset: 0x18C0
	Size: 0x2A
	Parameters: 0
	Flags: Linked
*/
function get_schedule_start_time()
{
	/#
		return getdvarint("", 1463418000);
	#/
}

