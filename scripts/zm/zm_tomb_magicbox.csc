// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace tomb_magicbox;

/*
	Name: __init__sytem__
	Namespace: tomb_magicbox
	Checksum: 0x92F4C972
	Offset: 0x220
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
	Checksum: 0x16DB8F03
	Offset: 0x260
	Size: 0x124
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	clientfield::register("zbarrier", "magicbox_initial_fx", 21000, 1, "int", &magicbox_initial_closed_fx, 0, 0);
	clientfield::register("zbarrier", "magicbox_amb_fx", 21000, 2, "int", &magicbox_ambient_fx, 0, 0);
	clientfield::register("zbarrier", "magicbox_open_fx", 21000, 1, "int", &magicbox_open_fx, 0, 0);
	clientfield::register("zbarrier", "magicbox_leaving_fx", 21000, 1, "int", &magicbox_leaving_fx, 0, 0);
}

/*
	Name: magicbox_leaving_fx
	Namespace: tomb_magicbox
	Checksum: 0x8D02CD90
	Offset: 0x390
	Size: 0x104
	Parameters: 7
	Flags: Linked
*/
function magicbox_leaving_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = spawn(localclientnum, self.origin, "script_model");
		self.fx_obj.angles = self.angles;
		self.fx_obj setmodel("tag_origin");
	}
	if(newval == 1)
	{
		self.fx_obj.curr_leaving_fx = playfxontag(localclientnum, level._effect["box_is_leaving"], self.fx_obj, "tag_origin");
	}
}

/*
	Name: magicbox_open_fx
	Namespace: tomb_magicbox
	Checksum: 0xE0CB8762
	Offset: 0x4A0
	Size: 0x20C
	Parameters: 7
	Flags: Linked
*/
function magicbox_open_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = spawn(localclientnum, self.origin, "script_model");
		self.fx_obj.angles = self.angles;
		self.fx_obj setmodel("tag_origin");
	}
	if(!isdefined(self.fx_obj_2))
	{
		self.fx_obj_2 = spawn(localclientnum, self.origin, "script_model");
		self.fx_obj_2.angles = self.angles;
		self.fx_obj_2 setmodel("tag_origin");
	}
	if(newval == 0)
	{
		stopfx(localclientnum, self.fx_obj.curr_open_fx);
		self.fx_obj_2 stoploopsound(1);
		self notify(#"magicbox_portal_finished");
	}
	else if(newval == 1)
	{
		self.fx_obj.curr_open_fx = playfxontag(localclientnum, level._effect["box_is_open"], self.fx_obj, "tag_origin");
		self.fx_obj_2 playloopsound("zmb_hellbox_open_effect");
		self thread fx_magicbox_portal(localclientnum);
	}
}

/*
	Name: fx_magicbox_portal
	Namespace: tomb_magicbox
	Checksum: 0x56EC1106
	Offset: 0x6B8
	Size: 0x8C
	Parameters: 1
	Flags: Linked
*/
function fx_magicbox_portal(localclientnum)
{
	wait(0.5);
	self.fx_obj_2.curr_portal_fx = playfxontag(localclientnum, level._effect["box_portal"], self.fx_obj_2, "tag_origin");
	self waittill(#"magicbox_portal_finished");
	stopfx(localclientnum, self.fx_obj_2.curr_portal_fx);
}

/*
	Name: magicbox_initial_closed_fx
	Namespace: tomb_magicbox
	Checksum: 0xE6A4DEF0
	Offset: 0x750
	Size: 0xE4
	Parameters: 7
	Flags: Linked
*/
function magicbox_initial_closed_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = spawn(localclientnum, self.origin, "script_model");
		self.fx_obj.angles = self.angles;
		self.fx_obj setmodel("tag_origin");
	}
	else
	{
		return;
	}
	if(newval == 1)
	{
		self.fx_obj playloopsound("zmb_hellbox_amb_low");
	}
}

/*
	Name: magicbox_ambient_fx
	Namespace: tomb_magicbox
	Checksum: 0x9FAC0535
	Offset: 0x840
	Size: 0x474
	Parameters: 7
	Flags: Linked
*/
function magicbox_ambient_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwasdemojump)
{
	if(!isdefined(self.fx_obj))
	{
		self.fx_obj = spawn(localclientnum, self.origin, "script_model");
		self.fx_obj.angles = self.angles;
		self.fx_obj setmodel("tag_origin");
	}
	if(isdefined(self.fx_obj.curr_amb_fx))
	{
		stopfx(localclientnum, self.fx_obj.curr_amb_fx);
	}
	if(isdefined(self.fx_obj.curr_amb_fx_power))
	{
		stopfx(localclientnum, self.fx_obj.curr_amb_fx_power);
	}
	if(newval == 0)
	{
		self.fx_obj playloopsound("zmb_hellbox_amb_low");
		playsound(0, "zmb_hellbox_leave", self.fx_obj.origin);
		stopfx(localclientnum, self.fx_obj.curr_amb_fx);
	}
	else
	{
		if(newval == 1)
		{
			self.fx_obj.curr_amb_fx_power = playfxontag(localclientnum, level._effect["box_unpowered"], self.fx_obj, "tag_origin");
			self.fx_obj.curr_amb_fx = playfxontag(localclientnum, level._effect["box_here_ambient"], self.fx_obj, "tag_origin");
			self.fx_obj playloopsound("zmb_hellbox_amb_low");
			playsound(0, "zmb_hellbox_arrive", self.fx_obj.origin);
		}
		else
		{
			if(newval == 2)
			{
				self.fx_obj.curr_amb_fx_power = playfxontag(localclientnum, level._effect["box_powered"], self.fx_obj, "tag_origin");
				self.fx_obj.curr_amb_fx = playfxontag(localclientnum, level._effect["box_here_ambient"], self.fx_obj, "tag_origin");
				self.fx_obj playloopsound("zmb_hellbox_amb_high");
				playsound(0, "zmb_hellbox_arrive", self.fx_obj.origin);
			}
			else if(newval == 3)
			{
				self.fx_obj.curr_amb_fx_power = playfxontag(localclientnum, level._effect["box_unpowered"], self.fx_obj, "tag_origin");
				self.fx_obj.curr_amb_fx = playfxontag(localclientnum, level._effect["box_gone_ambient"], self.fx_obj, "tag_origin");
				self.fx_obj playloopsound("zmb_hellbox_amb_high");
				playsound(0, "zmb_hellbox_leave", self.fx_obj.origin);
			}
		}
	}
}

