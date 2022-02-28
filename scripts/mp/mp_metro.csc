// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\mp_metro_fx;
#using scripts\mp\mp_metro_sound;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#namespace mp_metro;

/*
	Name: main
	Namespace: mp_metro
	Checksum: 0xEE30CA84
	Offset: 0x278
	Size: 0x114
	Parameters: 0
	Flags: Linked
*/
function main()
{
	mp_metro_fx::main();
	mp_metro_sound::main();
	clientfield::register("scriptmover", "mp_metro_train_timer", 1, 1, "int", &traintimerspawned, 1, 0);
	load::main();
	level.domflagbasefxoverride = &dom_flag_base_fx_override;
	level.domflagcapfxoverride = &dom_flag_cap_fx_override;
	util::waitforclient(0);
	level.endgamexcamname = "ui_cam_endgame_mp_metro";
	setdvar("phys_buoyancy", 1);
	setdvar("phys_ragdoll_buoyancy", 1);
}

/*
	Name: train_countdown
	Namespace: mp_metro
	Checksum: 0xFDBFC8BB
	Offset: 0x398
	Size: 0x448
	Parameters: 1
	Flags: Linked
*/
function train_countdown(localclientnum)
{
	self endon(#"entityshutdown");
	angles = (self.angles[0], self.angles[1] * -1, 0);
	minutesorigin = self.origin + (cos(self.angles[1]) * 37, sin(self.angles[1]) * 37, 0);
	numbermodelminutes = util::spawn_model(localclientnum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", minutesorigin, angles);
	colonorigin = self.origin + ((cos(self.angles[1]) * 37) * 2, (sin(self.angles[1]) * 37) * 2, 0);
	numbermodelcolon = util::spawn_model(localclientnum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", colonorigin, angles);
	tensorigin = self.origin - (cos(self.angles[1]) * 37, sin(self.angles[1]) * 37, 0);
	numbermodeltens = util::spawn_model(localclientnum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", tensorigin, angles);
	onesorigin = self.origin - ((cos(self.angles[1]) * 37) * 2, (sin(self.angles[1]) * 37) * 2, 0);
	numbermodelones = util::spawn_model(localclientnum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", onesorigin, angles);
	currentnumber = 1;
	currentnumberlarge = 0;
	for(;;)
	{
		currentnumber++;
		if(currentnumber > 9)
		{
			currentnumber = 0;
		}
		displaynumber = int(ceil(self.angles[2]));
		if(displaynumber < 0)
		{
			displaynumber = displaynumber + 360;
		}
		if(displaynumber < 0 || displaynumber > 360)
		{
			displaynumber = 0;
		}
		numbermodelones setmodel(("p7_3d_txt_antiqua_bold_0" + (displaynumber % 10)) + "_brushed_aluminum");
		numbermodeltens setmodel(("p7_3d_txt_antiqua_bold_0" + (int((displaynumber % 60) / 10))) + "_brushed_aluminum");
		numbermodelminutes setmodel(("p7_3d_txt_antiqua_bold_0" + (int(displaynumber / 60))) + "_brushed_aluminum");
		wait(0.05);
	}
}

/*
	Name: traintimerspawned
	Namespace: mp_metro
	Checksum: 0x6323AED2
	Offset: 0x7E8
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function traintimerspawned(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(!newval)
	{
		return;
	}
	if(newval == 1)
	{
		self thread train_countdown(localclientnum);
	}
}

/*
	Name: dom_flag_base_fx_override
	Namespace: mp_metro
	Checksum: 0x146D954
	Offset: 0x860
	Size: 0xC2
	Parameters: 2
	Flags: Linked
*/
function dom_flag_base_fx_override(flag, team)
{
	switch(flag.name)
	{
		case "a":
		{
			if(team == "neutral")
			{
				return "ui/fx_dom_marker_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_marker_team_r120";
			}
			break;
		}
		case "b":
		{
			if(team == "neutral")
			{
				return "ui/fx_dom_marker_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_marker_team_r120";
			}
			break;
		}
		case "c":
		{
			if(team == "neutral")
			{
				return "ui/fx_dom_marker_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_marker_team_r120";
			}
			break;
		}
	}
}

/*
	Name: dom_flag_cap_fx_override
	Namespace: mp_metro
	Checksum: 0xFF48E7B
	Offset: 0x930
	Size: 0xC2
	Parameters: 2
	Flags: Linked
*/
function dom_flag_cap_fx_override(flag, team)
{
	switch(flag.name)
	{
		case "a":
		{
			if(team == "neutral")
			{
				return "ui/fx_dom_cap_indicator_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_cap_indicator_team_r120";
			}
			break;
		}
		case "b":
		{
			if(team == "neutral")
			{
				return "ui/fx_dom_cap_indicator_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_cap_indicator_team_r120";
			}
			break;
		}
		case "c":
		{
			if(team == "neutral")
			{
				return "ui/fx_dom_cap_indicator_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_cap_indicator_team_r120";
			}
			break;
		}
	}
}

