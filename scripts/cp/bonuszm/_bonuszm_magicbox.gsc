// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_util;
#using scripts\cp\bonuszm\_bonuszm_data;
#using scripts\cp\bonuszm\_bonuszm_dev;
#using scripts\cp\bonuszm\_bonuszm_spawner_shared;
#using scripts\cp\bonuszm\_bonuszm_weapons;
#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_save;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;

class class_dafbfd8e 
{
	var var_b8eeb0fe;
	var var_2bcbe272;
	var var_3f29a509;
	var var_7c66997c;

	/*
		Name: constructor
		Namespace: namespace_dafbfd8e
		Checksum: 0x199D3232
		Offset: 0xA30
		Size: 0x10
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		var_2bcbe272 = 0;
	}

	/*
		Name: destructor
		Namespace: namespace_dafbfd8e
		Checksum: 0x99EC1590
		Offset: 0xA48
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: function_b449e467
		Namespace: namespace_dafbfd8e
		Checksum: 0xD4BDFC92
		Offset: 0x1888
		Size: 0xD8
		Parameters: 0
		Flags: Linked
	*/
	function function_b449e467()
	{
		var_b8eeb0fe.weapon_model clientfield::set("weapon_disappear_fx", 1);
		util::wait_network_frame();
		var_b8eeb0fe.weapon_model delete();
		wait(1);
		var_b8eeb0fe setzbarrierpiecestate(2, "closing");
		while(var_b8eeb0fe getzbarrierpiecestate(2) == "closing")
		{
			wait(0.1);
		}
		var_b8eeb0fe notify(#"closed");
	}

	/*
		Name: function_cf5042c5
		Namespace: namespace_dafbfd8e
		Checksum: 0xE41281E5
		Offset: 0x1670
		Size: 0x20C
		Parameters: 0
		Flags: Linked
	*/
	function function_cf5042c5()
	{
		var_b8eeb0fe setzbarrierpiecestate(2, "opening");
		while(var_b8eeb0fe getzbarrierpiecestate(2) != "open")
		{
			wait(0.1);
		}
		var_b8eeb0fe setzbarrierpiecestate(3, "closed");
		var_b8eeb0fe setzbarrierpiecestate(4, "closed");
		util::wait_network_frame();
		var_b8eeb0fe zbarrierpieceuseboxriselogic(3);
		var_b8eeb0fe zbarrierpieceuseboxriselogic(4);
		var_b8eeb0fe showzbarrierpiece(3);
		var_b8eeb0fe showzbarrierpiece(4);
		var_b8eeb0fe setzbarrierpiecestate(3, "opening");
		var_b8eeb0fe setzbarrierpiecestate(4, "opening");
		while(var_b8eeb0fe getzbarrierpiecestate(3) != "open")
		{
			wait(0.5);
		}
		var_b8eeb0fe hidezbarrierpiece(3);
		var_b8eeb0fe hidezbarrierpiece(4);
	}

	/*
		Name: function_f555c05b
		Namespace: namespace_dafbfd8e
		Checksum: 0x502C7259
		Offset: 0x1638
		Size: 0x2C
		Parameters: 0
		Flags: Linked
	*/
	function function_f555c05b()
	{
		weaponinfo = namespace_fdfaa57d::function_1e2e0936(1);
		return weaponinfo;
	}

	/*
		Name: function_c3e9e1ab
		Namespace: namespace_dafbfd8e
		Checksum: 0x982E330E
		Offset: 0x1390
		Size: 0x2A0
		Parameters: 1
		Flags: Linked
	*/
	function function_c3e9e1ab(e_player)
	{
		weapon = level.weaponnone;
		modelname = undefined;
		rand = undefined;
		number_cycles = 40;
		self thread function_cf5042c5();
		for(i = 0; i < number_cycles; i++)
		{
			if(i < 20)
			{
				wait(0.05);
				continue;
			}
			if(i < 30)
			{
				wait(0.1);
				continue;
			}
			if(i < 35)
			{
				wait(0.2);
				continue;
			}
			if(i < 38)
			{
				wait(0.3);
			}
		}
		wait(1);
		var_b8eeb0fe.weaponinfo = function_f555c05b();
		v_float = anglestoup(var_b8eeb0fe.angles) * 40;
		var_b8eeb0fe.weapon_model = spawn("script_model", var_b8eeb0fe.origin + v_float, 0);
		var_b8eeb0fe.weapon_model.angles = (var_b8eeb0fe.angles[0] * -1, var_b8eeb0fe.angles[1] + 180, var_b8eeb0fe.angles[2] * -1);
		var_b8eeb0fe.weapon_model useweaponmodel(var_b8eeb0fe.weaponinfo[0], var_b8eeb0fe.weaponinfo[0].worldmodel);
		var_b8eeb0fe.weapon_model setweaponrenderoptions(var_b8eeb0fe.weaponinfo[2], 0, 0, 0, 0);
		var_b8eeb0fe notify(#"randomization_done");
	}

	/*
		Name: function_7429abd1
		Namespace: namespace_dafbfd8e
		Checksum: 0x75EDB728
		Offset: 0x1300
		Size: 0x84
		Parameters: 3
		Flags: Linked
	*/
	function function_7429abd1(var_7983c848, weaponinfo, e_player)
	{
		/#
			assert(isdefined(weaponinfo));
		#/
		e_player namespace_fdfaa57d::function_43128d49(weaponinfo, 0);
		var_7983c848 notify(#"hash_1285c563");
		e_player unlink();
	}

	/*
		Name: function_83bb9b69
		Namespace: namespace_dafbfd8e
		Checksum: 0x37FBCE72
		Offset: 0xF80
		Size: 0x378
		Parameters: 1
		Flags: Linked
	*/
	function function_83bb9b69(e_player)
	{
		if(var_2bcbe272)
		{
			return;
		}
		var_3f29a509.gameobject gameobjects::disable_object(1);
		var_2bcbe272 = 1;
		var_b8eeb0fe clientfield::set("magicbox_closed_glow", 0);
		var_b8eeb0fe clientfield::set("magicbox_open_glow", 1);
		weaponinfo = function_c3e9e1ab(e_player);
		var_7983c848 = spawn("trigger_radius_use", var_3f29a509.origin + vectorscale((0, 0, 1), 3), 0, 94, 64);
		var_7983c848 triggerignoreteam();
		var_7983c848 setvisibletoall();
		var_7983c848 usetriggerrequirelookat();
		var_7983c848 setteamfortrigger("none");
		var_7983c848 setcursorhint("HINT_INTERACTIVE_PROMPT");
		var_7983c848 sethintstring(&"COOP_MAGICBOX_SWAP_WEAPON");
		var_b8eeb0fe.var_7983c848 = var_7983c848;
		var_aafa484e = util::init_interactive_gameobject(var_7983c848, &"cp_magic_box", &"COOP_MAGICBOX_SWAP_WEAPON", &onuse);
		var_aafa484e.dontlinkplayertotrigger = 1;
		var_aafa484e.classobj = self;
		var_aafa484e enablelinkto();
		var_aafa484e linkto(var_7983c848);
		e_player unlink();
		var_7983c848 util::waittill_any_timeout(6, "player_took_weapon");
		var_7983c848 notify(#"hash_49d64e9");
		var_aafa484e gameobjects::destroy_object(1, 1);
		self thread function_b449e467();
		var_aafa484e delete();
		var_b8eeb0fe waittill(#"closed");
		var_b8eeb0fe clientfield::set("magicbox_closed_glow", 1);
		var_b8eeb0fe clientfield::set("magicbox_open_glow", 0);
		var_3f29a509.gameobject gameobjects::enable_object(1);
		var_2bcbe272 = 0;
	}

	/*
		Name: onbeginuse
		Namespace: namespace_dafbfd8e
		Checksum: 0xA9DF236C
		Offset: 0xF68
		Size: 0xC
		Parameters: 1
		Flags: Linked
	*/
	function onbeginuse(e_player)
	{
	}

	/*
		Name: onuse
		Namespace: namespace_dafbfd8e
		Checksum: 0xEED7F6D2
		Offset: 0xEF0
		Size: 0x6C
		Parameters: 1
		Flags: Linked
	*/
	function onuse(e_player)
	{
		if(!var_2bcbe272)
		{
			self thread function_83bb9b69(e_player);
		}
		else
		{
			e_player thread function_7429abd1(var_b8eeb0fe.var_7983c848, var_b8eeb0fe.weaponinfo, e_player);
		}
	}

	/*
		Name: function_b471f57b
		Namespace: namespace_dafbfd8e
		Checksum: 0xA68DEB28
		Offset: 0xE68
		Size: 0x7C
		Parameters: 0
		Flags: Linked
	*/
	function function_b471f57b()
	{
		if(!var_2bcbe272)
		{
			var_3f29a509.gameobject gameobjects::destroy_object(1, 1);
			var_b8eeb0fe clientfield::set("magicbox_closed_glow", 0);
			util::wait_network_frame();
			var_b8eeb0fe hide();
		}
	}

	/*
		Name: function_309dd42b
		Namespace: namespace_dafbfd8e
		Checksum: 0x8BC511E3
		Offset: 0xA58
		Size: 0x404
		Parameters: 1
		Flags: Linked
	*/
	function function_309dd42b(mdl_mobile_armory)
	{
		e_trigger = spawn("trigger_radius_use", mdl_mobile_armory.origin + vectorscale((0, 0, 1), 3), 0, 94, 64);
		e_trigger triggerignoreteam();
		e_trigger setvisibletoall();
		e_trigger usetriggerrequirelookat();
		e_trigger setteamfortrigger("none");
		e_trigger setcursorhint("HINT_INTERACTIVE_PROMPT");
		e_trigger sethintstring(&"COOP_MAGICBOX");
		var_9fd18135 = getentarray("bonuszm_magicbox", "script_noteworthy");
		var_b8eeb0fe = arraygetclosest(e_trigger.origin, var_9fd18135);
		var_b8eeb0fe.origin = mdl_mobile_armory.origin;
		var_b8eeb0fe.angles = mdl_mobile_armory.angles + (vectorscale((0, -1, 0), 90));
		var_b8eeb0fe hidezbarrierpiece(1);
		if(isdefined(mdl_mobile_armory.script_linkto))
		{
			moving_platform = getent(mdl_mobile_armory.script_linkto, "targetname");
			mdl_mobile_armory linkto(moving_platform);
			var_b8eeb0fe linkto(moving_platform);
			e_trigger enablelinkto();
			e_trigger linkto(moving_platform);
		}
		s_mobile_armory_object = util::init_interactive_gameobject(e_trigger, &"cp_magic_box", &"COOP_OPEN", &onuse);
		s_mobile_armory_object.dontlinkplayertotrigger = 1;
		s_mobile_armory_object.classobj = self;
		if(!isdefined(mdl_mobile_armory.script_linkto))
		{
			s_mobile_armory_object enablelinkto();
			s_mobile_armory_object linkto(e_trigger);
		}
		mdl_mobile_armory.gameobject = s_mobile_armory_object;
		var_b8eeb0fe.gameobject = s_mobile_armory_object;
		var_3f29a509 = mdl_mobile_armory;
		var_7c66997c = e_trigger;
		var_b8eeb0fe hidezbarrierpiece(0);
		var_b8eeb0fe clientfield::set("magicbox_closed_glow", 1);
		var_b8eeb0fe clientfield::set("magicbox_open_glow", 0);
		var_b8eeb0fe playloopsound("zmb_box_zcamp_loop");
		var_3f29a509 ghost();
		var_3f29a509 notsolid();
	}

}

#namespace bonuszm;

/*
	Name: __init__sytem__
	Namespace: bonuszm
	Checksum: 0xCA80034
	Offset: 0x4C0
	Size: 0x3C
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("cp_mobile_magicbox", &__init__, &__main__, undefined);
}

/*
	Name: __init__
	Namespace: bonuszm
	Checksum: 0xABA8E5C8
	Offset: 0x508
	Size: 0xEC
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level.var_40b3237f = &function_999eb742;
	if(!sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	level.bzm_hideallmagicboxescallback = &function_89a0f2a6;
	level.bzm_cleanupmagicboxondeletioncallback = &function_76eab3e;
	clientfield::register("zbarrier", "magicbox_open_glow", 1, 1, "int");
	clientfield::register("zbarrier", "magicbox_closed_glow", 1, 1, "int");
	clientfield::register("scriptmover", "weapon_disappear_fx", 1, 1, "int");
}

/*
	Name: __main__
	Namespace: bonuszm
	Checksum: 0xE339B3E7
	Offset: 0x600
	Size: 0x302
	Parameters: 0
	Flags: Linked
*/
function __main__()
{
	if(!sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	wait(0.05);
	a_mdl_mobile_armory_clip = getentarray("mobile_armory_clip", "script_noteworthy");
	foreach(clip in a_mdl_mobile_armory_clip)
	{
		clip delete();
	}
	mapname = getdvarstring("mapname");
	a_mdl_mobile_armory = getentarray("mobile_armory", "script_noteworthy");
	foreach(mdl_mobile_armory in a_mdl_mobile_armory)
	{
		if(mapname == "cp_mi_cairo_lotus")
		{
			if((distancesquared(mdl_mobile_armory.origin, (-7469, 1031, 4029))) < 22500)
			{
				var_9ff80c52 = 1;
			}
		}
		if(isdefined(var_9ff80c52) && var_9ff80c52)
		{
			var_40d9775d = getentarray("bonuszm_magicbox", "script_noteworthy");
			var_381b4609 = array::get_all_closest(mdl_mobile_armory.origin, var_40d9775d, array(mdl_mobile_armory), 1, 100);
			if(isdefined(var_381b4609) && isarray(var_381b4609) && var_381b4609.size)
			{
				var_381b4609[0] delete();
			}
			mdl_mobile_armory show();
			continue;
		}
		mdl_mobile_armory thread function_2816573(mdl_mobile_armory);
	}
}

/*
	Name: function_2816573
	Namespace: bonuszm
	Checksum: 0xABF81680
	Offset: 0x910
	Size: 0x54
	Parameters: 1
	Flags: Linked
*/
function function_2816573(mdl_mobile_armory)
{
	var_6982c48a = new class_dafbfd8e();
	[[ var_6982c48a ]]->function_309dd42b(mdl_mobile_armory);
	mdl_mobile_armory.var_b10011b8 = var_6982c48a;
}

/*
	Name: function_999eb742
	Namespace: bonuszm
	Checksum: 0x2B34B239
	Offset: 0x970
	Size: 0xB2
	Parameters: 0
	Flags: Linked
*/
function function_999eb742()
{
	var_40d9775d = getentarray("bonuszm_magicbox", "script_noteworthy");
	foreach(magicbox in var_40d9775d)
	{
		magicbox delete();
	}
}

/*
	Name: function_89a0f2a6
	Namespace: bonuszm
	Checksum: 0xAB63D8B8
	Offset: 0x1BD8
	Size: 0x122
	Parameters: 0
	Flags: Linked
*/
function function_89a0f2a6()
{
	if(!sessionmodeiscampaignzombiesgame())
	{
		return;
	}
	var_7e526b74 = getentarray("bonuszm_magicbox", "script_noteworthy");
	foreach(magicbox in var_7e526b74)
	{
		magicbox.gameobject gameobjects::destroy_object(1, 1);
		magicbox clientfield::set("magicbox_closed_glow", 0);
		util::wait_network_frame();
		magicbox hide();
	}
}

/*
	Name: function_76eab3e
	Namespace: bonuszm
	Checksum: 0x26114334
	Offset: 0x1D08
	Size: 0x7C
	Parameters: 1
	Flags: Linked
*/
function function_76eab3e(magicbox)
{
	if(magicbox.script_noteworthy === "bonuszm_magicbox")
	{
		if(isdefined(magicbox.gameobject))
		{
			magicbox.gameobject gameobjects::destroy_object(1, 1);
		}
		magicbox thread function_73ea8d16(magicbox);
	}
}

/*
	Name: function_73ea8d16
	Namespace: bonuszm
	Checksum: 0x301860B3
	Offset: 0x1D90
	Size: 0x5C
	Parameters: 1
	Flags: Linked
*/
function function_73ea8d16(magicbox)
{
	magicbox endon(#"death");
	magicbox clientfield::set("magicbox_closed_glow", 0);
	util::wait_network_frame();
	magicbox delete();
}

