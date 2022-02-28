// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\table_shared;
#using scripts\shared\util_shared;

#namespace zm_frontend_zm_bgb_chance;

/*
	Name: zm_frontend_bgb_slots_logic
	Namespace: zm_frontend_zm_bgb_chance
	Checksum: 0xC27953BE
	Offset: 0x1A8
	Size: 0x1C
	Parameters: 0
	Flags: Linked
*/
function zm_frontend_bgb_slots_logic()
{
	/#
		level thread zm_frontend_bgb_devgui();
	#/
}

/*
	Name: zm_frontend_bgb_devgui
	Namespace: zm_frontend_zm_bgb_chance
	Checksum: 0xABA81FC3
	Offset: 0x1D0
	Size: 0x1BC
	Parameters: 0
	Flags: Linked
*/
function zm_frontend_bgb_devgui()
{
	/#
		setdvar("", "");
		setdvar("", "");
		bgb_devgui_base = "";
		a_n_amounts = array(1, 5, 10, 100);
		for(i = 0; i < a_n_amounts.size; i++)
		{
			n_amount = a_n_amounts[i];
			adddebugcommand((((((bgb_devgui_base + i) + "") + n_amount) + "") + n_amount) + "");
		}
		adddebugcommand((((("" + "") + "") + "") + 1) + "");
		adddebugcommand((((("" + "") + "") + "") + 1) + "");
		level thread bgb_devgui_think();
	#/
}

/*
	Name: bgb_devgui_think
	Namespace: zm_frontend_zm_bgb_chance
	Checksum: 0x98C1DCC6
	Offset: 0x398
	Size: 0x1C0
	Parameters: 0
	Flags: Linked
*/
function bgb_devgui_think()
{
	/#
		b_powerboost_toggle = 0;
		b_successfail_toggle = 0;
		for(;;)
		{
			n_val_powerboost = getdvarstring("");
			n_val_successfail = getdvarstring("");
			if(n_val_powerboost != "")
			{
				b_powerboost_toggle = !b_powerboost_toggle;
				level clientfield::set("", b_powerboost_toggle);
				if(b_powerboost_toggle)
				{
					iprintlnbold("");
				}
				else
				{
					iprintlnbold("");
				}
			}
			if(n_val_successfail != "")
			{
				b_successfail_toggle = !b_successfail_toggle;
				level clientfield::set("", b_successfail_toggle);
				if(b_successfail_toggle)
				{
					iprintlnbold("");
				}
				else
				{
					iprintlnbold("");
				}
			}
			setdvar("", "");
			setdvar("", "");
			wait(0.5);
		}
	#/
}

