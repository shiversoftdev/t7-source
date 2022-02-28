// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;

#namespace cybercom_dev;

/*
	Name: function_a0e51d80
	Namespace: cybercom_dev
	Checksum: 0xC5B65AEA
	Offset: 0x318
	Size: 0x1C0
	Parameters: 4
	Flags: Linked
*/
function function_a0e51d80(point, timesec, size, color)
{
	end = gettime() + (timesec * 1000);
	halfwidth = int(size / 2);
	l1 = point + (halfwidth * -1, 0, 0);
	l2 = point + (halfwidth, 0, 0);
	var_5e2b69e1 = point + (0, halfwidth * -1, 0);
	var_842de44a = point + (0, halfwidth, 0);
	h1 = point + (0, 0, halfwidth * -1);
	h2 = point + (0, 0, halfwidth);
	while(end > gettime())
	{
		/#
			line(l1, l2, color, 1, 0, 1);
			line(var_5e2b69e1, var_842de44a, color, 1, 0, 1);
			line(h1, h2, color, 1, 0, 1);
		#/
		wait(0.05);
	}
}

/*
	Name: cybercom_setupdevgui
	Namespace: cybercom_dev
	Checksum: 0xFDD5B616
	Offset: 0x4E0
	Size: 0x3C
	Parameters: 0
	Flags: Linked
*/
function cybercom_setupdevgui()
{
	/#
		execdevgui("");
		level thread cybercom_devguithink();
	#/
}

/*
	Name: constantjuice
	Namespace: cybercom_dev
	Checksum: 0x85BBAA5
	Offset: 0x528
	Size: 0x108
	Parameters: 0
	Flags: Linked
*/
function constantjuice()
{
	self notify(#"constantjuice");
	self endon(#"constantjuice");
	self endon(#"disconnect");
	self endon(#"spawned");
	while(true)
	{
		wait(1);
		if(isdefined(self.cybercom.var_ebeecfd5) && self.cybercom.var_ebeecfd5)
		{
			continue;
		}
		if(isdefined(self.cybercom.activecybercomweapon))
		{
			slot = self gadgetgetslot(self.cybercom.activecybercomweapon);
			var_d921672c = self gadgetcharging(slot);
			if(var_d921672c)
			{
				self gadgetpowerchange(slot, 100);
			}
		}
	}
}

/*
	Name: cybercom_devguithink
	Namespace: cybercom_dev
	Checksum: 0x38569580
	Offset: 0x638
	Size: 0x710
	Parameters: 0
	Flags: Linked
*/
function cybercom_devguithink()
{
	setdvar("devgui_cybercore", "");
	setdvar("devgui_cybercore_upgrade", "");
	while(true)
	{
		cmd = getdvarstring("devgui_cybercore");
		if(cmd == "")
		{
			wait(0.5);
			continue;
		}
		playernum = getdvarint("scr_player_number") - 1;
		players = getplayers();
		if(playernum >= players.size)
		{
			setdvar("devgui_cybercore", "");
			setdvar("devgui_cybercore_upgrade", "");
			iprintlnbold("Invalid Player specified. Use SET PLAYER NUMBER in Cybercom DEVGUI to set valid player");
			continue;
		}
		if(cmd == "juiceme")
		{
			setdvar("devgui_cybercore", "");
			setdvar("devgui_cybercore_upgrade", "");
			iprintlnbold("Giving Constant Juice to all players");
			foreach(player in players)
			{
				player thread constantjuice();
			}
			continue;
		}
		if(cmd == "clearAll")
		{
			iprintlnbold("Clearing all abilities on all players");
			foreach(player in players)
			{
				player cybercom_tacrig::takeallrigabilities();
				player cybercom_gadget::takeallabilities();
			}
			setdvar("devgui_cybercore", "");
			setdvar("devgui_cybercore_upgrade", "");
			continue;
		}
		if(cmd == "giveAll")
		{
			iprintlnbold("Giving all abilities on all players");
			foreach(player in players)
			{
				player cybercom_gadget::function_edff667f();
			}
			setdvar("devgui_cybercore", "");
			setdvar("devgui_cybercore_upgrade", "");
			continue;
		}
		player = players[playernum];
		playernum++;
		upgrade = getdvarint("devgui_cybercore_upgrade");
		if(cmd == "clearPlayer")
		{
			iprintlnbold("Clearing abilities on player: " + playernum);
			player cybercom_tacrig::takeallrigabilities();
			player cybercom_gadget::takeallabilities();
			setdvar("devgui_cybercore", "");
			setdvar("devgui_cybercore_upgrade", "");
			continue;
		}
		else
		{
			if(cmd == "control")
			{
				setdvar("devgui_cybercore", "");
				setdvar("devgui_cybercore_upgrade", "");
				continue;
			}
			else
			{
				if(cmd == "martial")
				{
					setdvar("devgui_cybercore", "");
					setdvar("devgui_cybercore_upgrade", "");
					continue;
				}
				else if(cmd == "chaos")
				{
					setdvar("devgui_cybercore", "");
					setdvar("devgui_cybercore_upgrade", "");
					continue;
				}
			}
		}
		if(isdefined(level._cybercom_rig_ability[cmd]))
		{
			player cybercom_tacrig::giverigability(cmd, upgrade);
		}
		else
		{
			player cybercom_gadget::giveability(cmd, upgrade);
		}
		iprintlnbold(((("Adding ability on player: " + playernum) + (" --> ") + cmd) + "  Upgraded:") + (upgrade ? "TRUE" : "FALSE"));
		setdvar("devgui_cybercore", "");
		setdvar("devgui_cybercore_upgrade", "");
	}
}

