// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace cybercom_misdirection;

/*
	Name: init
	Namespace: cybercom_misdirection
	Checksum: 0xCFF9DBEB
	Offset: 0x2E8
	Size: 0x14
	Parameters: 0
	Flags: Linked
*/
function init()
{
	init_clientfields();
}

/*
	Name: init_clientfields
	Namespace: cybercom_misdirection
	Checksum: 0xCC0D3757
	Offset: 0x308
	Size: 0xC4
	Parameters: 0
	Flags: Linked
*/
function init_clientfields()
{
	clientfield::register("toplayer", "misdirection_enable", 1, 1, "int", &function_ec87e5c5, 0, 0);
	clientfield::register("scriptmover", "makedecoy", 1, 1, "int", &function_ac2a831d, 0, 0);
	duplicate_render::set_dr_filter_framebuffer_duplicate("armor_pl", 0, "armor_on", undefined, 1, "mc/mtl_power_armor", 0);
}

/*
	Name: function_ec87e5c5
	Namespace: cybercom_misdirection
	Checksum: 0x22EF6C6C
	Offset: 0x3D8
	Size: 0x54
	Parameters: 7
	Flags: Linked
*/
function function_ec87e5c5(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	misdirectionenable(localclientnum, newval);
}

/*
	Name: function_2c16a75b
	Namespace: cybercom_misdirection
	Checksum: 0xD69D6BB
	Offset: 0x438
	Size: 0x144
	Parameters: 1
	Flags: Linked
*/
function function_2c16a75b(localclientnum)
{
	self endon(#"entityshutdown");
	wait(0.016);
	var_76dfdc9 = self.origin;
	amplitude = randomfloatrange(4, 12);
	dz = randomfloatrange(0.2, 1);
	z = randomint(360);
	while(true)
	{
		z = z + dz;
		if(z > 360)
		{
			z = int(z) % 360;
		}
		var_50413d99 = sin(z);
		shift = amplitude * var_50413d99;
		self.origin = var_76dfdc9 + (0, 0, shift);
		wait(0.016);
	}
}

/*
	Name: function_ac2a831d
	Namespace: cybercom_misdirection
	Checksum: 0xA9084D34
	Offset: 0x588
	Size: 0x38C
	Parameters: 7
	Flags: Linked
*/
function function_ac2a831d(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval)
	{
		self.decoy = spawn(localclientnum, self.origin, "script_model");
		if(isdefined(self.decoy))
		{
			self.decoy setmodel("veh_t7_wasp_cybercom");
			self.decoy.angles = (0, randomint(360), 0);
			self.decoy hide();
			self.decoy thread function_2c16a75b();
			self.decoy duplicate_render::set_dr_flag("armor_on", 1);
			self.decoy duplicate_render::update_dr_filters(localclientnum);
			var_aa5d763a = "scriptVector3";
			var_fc81e73c = 0.4;
			var_754d7044 = 1;
			var_e754df7f = 0.45;
			var_595c4eba = 0;
			var_6c5c3132 = "scriptVector4";
			var_93429fd9 = 0.6;
			self.decoy mapshaderconstant(localclientnum, 0, var_aa5d763a, var_fc81e73c, var_754d7044, var_e754df7f, var_595c4eba);
			self.decoy mapshaderconstant(localclientnum, 0, var_6c5c3132, var_93429fd9, 0, 0, 0);
			playfxontag(localclientnum, "vehicle/fx_veh_dni_wasp_rez_in", self.decoy, "tag_origin");
			wait(0.25);
			self.decoy show();
		}
		self playsound(0, "gdt_cybercore_decoy_spawn");
		self.snd = self playloopsound("gdt_cybercore_decoy_lp", 0.75);
		self thread function_4fbb807c(self.origin);
	}
	else if(isdefined(self.decoy))
	{
		playfxontag(localclientnum, "vehicle/fx_veh_dni_wasp_rez_out", self.decoy, "tag_origin");
		self.decoy duplicate_render::set_dr_flag("armor_on", 0);
		decoy = self.decoy;
		wait(0.25);
		decoy delete();
	}
}

/*
	Name: function_4fbb807c
	Namespace: cybercom_misdirection
	Checksum: 0x8585797C
	Offset: 0x920
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function function_4fbb807c(sndorigin)
{
	self waittill(#"entityshutdown");
	playsound(0, "gdt_cybercore_decoy_delete", sndorigin);
}

