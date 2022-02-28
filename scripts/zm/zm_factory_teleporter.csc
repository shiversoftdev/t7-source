// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_factory_teleporter;

/*
	Name: __init__sytem__
	Namespace: zm_factory_teleporter
	Checksum: 0x2C0DC174
	Offset: 0x1B0
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_factory_teleporter", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_factory_teleporter
	Checksum: 0x3DFBB13E
	Offset: 0x1F0
	Size: 0x74
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_factory_teleport", 1, 1, "pstfx_zm_der_teleport");
	level thread setup_teleport_aftereffects();
	level thread wait_for_black_box();
	level thread wait_for_teleport_aftereffect();
}

/*
	Name: setup_teleport_aftereffects
	Namespace: zm_factory_teleporter
	Checksum: 0x85DB533D
	Offset: 0x270
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function setup_teleport_aftereffects()
{
	util::waitforclient(0);
	level.teleport_ae_funcs = [];
	if(getlocalplayers().size == 1)
	{
		level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_fov;
	}
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_shellshock;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_shellshock_electric;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_bw_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_red_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_flashy_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_flare_vision;
}

/*
	Name: wait_for_black_box
	Namespace: zm_factory_teleporter
	Checksum: 0xBB9A0535
	Offset: 0x3A0
	Size: 0xD8
	Parameters: 0
	Flags: Linked
*/
function wait_for_black_box()
{
	secondclientnum = -1;
	while(true)
	{
		level waittill(#"black_box_start", localclientnum);
		/#
			assert(isdefined(localclientnum));
		#/
		savedvis = getvisionsetnaked(localclientnum);
		visionsetnaked(localclientnum, "default", 0);
		while(secondclientnum != localclientnum)
		{
			level waittill(#"black_box_end", secondclientnum);
		}
		visionsetnaked(localclientnum, savedvis, 0);
	}
}

/*
	Name: wait_for_teleport_aftereffect
	Namespace: zm_factory_teleporter
	Checksum: 0xD5C5543F
	Offset: 0x480
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function wait_for_teleport_aftereffect()
{
	while(true)
	{
		level waittill(#"tae", localclientnum);
		if(getdvarstring("factoryAftereffectOverride") == ("-1"))
		{
			self thread [[level.teleport_ae_funcs[randomint(level.teleport_ae_funcs.size)]]](localclientnum);
		}
		else
		{
			self thread [[level.teleport_ae_funcs[int(getdvarstring("factoryAftereffectOverride"))]]](localclientnum);
		}
	}
}

/*
	Name: teleport_aftereffect_shellshock
	Namespace: zm_factory_teleporter
	Checksum: 0xE2575983
	Offset: 0x550
	Size: 0x14
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_shellshock(localclientnum)
{
	wait(0.05);
}

/*
	Name: teleport_aftereffect_shellshock_electric
	Namespace: zm_factory_teleporter
	Checksum: 0xCAC0E792
	Offset: 0x570
	Size: 0x14
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_shellshock_electric(localclientnum)
{
	wait(0.05);
}

/*
	Name: teleport_aftereffect_fov
	Namespace: zm_factory_teleporter
	Checksum: 0x16725859
	Offset: 0x590
	Size: 0xDA
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_fov(localclientnum)
{
	/#
		println("");
	#/
	start_fov = 30;
	end_fov = getdvarfloat("cg_fov_default");
	duration = 0.5;
	i = 0;
	while(i < duration)
	{
		fov = start_fov + (end_fov - start_fov) * (i / duration);
		waitrealtime(0.017);
		i = i + 0.017;
	}
}

/*
	Name: teleport_aftereffect_bw_vision
	Namespace: zm_factory_teleporter
	Checksum: 0xAD5D515
	Offset: 0x678
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_bw_vision(localclientnum)
{
	/#
		println("");
	#/
	savedvis = getvisionsetnaked(localclientnum);
	visionsetnaked(localclientnum, "cheat_bw_invert_contrast", 0.4);
	wait(1.25);
	visionsetnaked(localclientnum, savedvis, 1);
}

/*
	Name: teleport_aftereffect_red_vision
	Namespace: zm_factory_teleporter
	Checksum: 0x1A38C860
	Offset: 0x720
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_red_vision(localclientnum)
{
	/#
		println("");
	#/
	savedvis = getvisionsetnaked(localclientnum);
	visionsetnaked(localclientnum, "zombie_turned", 0.4);
	wait(1.25);
	visionsetnaked(localclientnum, savedvis, 1);
}

/*
	Name: teleport_aftereffect_flashy_vision
	Namespace: zm_factory_teleporter
	Checksum: 0x840A0575
	Offset: 0x7C8
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_flashy_vision(localclientnum)
{
	/#
		println("");
	#/
	savedvis = getvisionsetnaked(localclientnum);
	visionsetnaked(localclientnum, "cheat_bw_invert_contrast", 0.1);
	wait(0.4);
	visionsetnaked(localclientnum, "cheat_bw_contrast", 0.1);
	wait(0.4);
	wait(0.4);
	wait(0.4);
	visionsetnaked(localclientnum, savedvis, 5);
}

/*
	Name: teleport_aftereffect_flare_vision
	Namespace: zm_factory_teleporter
	Checksum: 0xC483D9CF
	Offset: 0x8B0
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_flare_vision(localclientnum)
{
	/#
		println("");
	#/
	savedvis = getvisionsetnaked(localclientnum);
	visionsetnaked(localclientnum, "flare", 0.4);
	wait(1.25);
	visionsetnaked(localclientnum, savedvis, 1);
}

