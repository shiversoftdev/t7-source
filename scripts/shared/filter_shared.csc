// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\postfx_shared;

#namespace filter;

/*
	Name: init_filter_indices
	Namespace: filter
	Checksum: 0x99EC1590
	Offset: 0x5F0
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function init_filter_indices()
{
}

/*
	Name: map_material_helper_by_localclientnum
	Namespace: filter
	Checksum: 0xC55D5DA1
	Offset: 0x600
	Size: 0x3A
	Parameters: 2
	Flags: Linked
*/
function map_material_helper_by_localclientnum(localclientnum, materialname)
{
	level.filter_matid[materialname] = mapmaterialindex(localclientnum, materialname);
}

/*
	Name: map_material_if_undefined
	Namespace: filter
	Checksum: 0x9BFEE571
	Offset: 0x648
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function map_material_if_undefined(localclientnum, materialname)
{
	if(isdefined(mapped_material_id(materialname)))
	{
		return;
	}
	map_material_helper_by_localclientnum(localclientnum, materialname);
}

/*
	Name: map_material_helper
	Namespace: filter
	Checksum: 0x60AA26BD
	Offset: 0x6A0
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function map_material_helper(player, materialname)
{
	map_material_helper_by_localclientnum(player.localclientnum, materialname);
}

/*
	Name: mapped_material_id
	Namespace: filter
	Checksum: 0x41917D11
	Offset: 0x6E0
	Size: 0x30
	Parameters: 1
	Flags: Linked
*/
function mapped_material_id(materialname)
{
	if(!isdefined(level.filter_matid))
	{
		level.filter_matid = [];
	}
	return level.filter_matid[materialname];
}

/*
	Name: init_filter_binoculars
	Namespace: filter
	Checksum: 0xF903AD8E
	Offset: 0x718
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_binoculars(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_binoculars");
}

/*
	Name: enable_filter_binoculars
	Namespace: filter
	Checksum: 0x295BE456
	Offset: 0x760
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function enable_filter_binoculars(player, filterid, overlayid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_binoculars"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: disable_filter_binoculars
	Namespace: filter
	Checksum: 0x2BF24D00
	Offset: 0x7E8
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function disable_filter_binoculars(player, filterid, overlayid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_binoculars_with_outline
	Namespace: filter
	Checksum: 0xC82954DF
	Offset: 0x838
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_binoculars_with_outline(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_binoculars_with_outline");
}

/*
	Name: enable_filter_binoculars_with_outline
	Namespace: filter
	Checksum: 0xF1B61421
	Offset: 0x880
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function enable_filter_binoculars_with_outline(player, filterid, overlayid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_binoculars_with_outline"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: disable_filter_binoculars_with_outline
	Namespace: filter
	Checksum: 0x5108D15
	Offset: 0x908
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function disable_filter_binoculars_with_outline(player, filterid, overlayid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_hazmat
	Namespace: filter
	Checksum: 0xAF823DBA
	Offset: 0x958
	Size: 0xBC
	Parameters: 1
	Flags: None
*/
function init_filter_hazmat(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_hazmat");
	map_material_helper(player, "generic_overlay_hazmat_1");
	map_material_helper(player, "generic_overlay_hazmat_2");
	map_material_helper(player, "generic_overlay_hazmat_3");
	map_material_helper(player, "generic_overlay_hazmat_4");
}

/*
	Name: set_filter_hazmat_opacity
	Namespace: filter
	Checksum: 0xF2E53F9A
	Offset: 0xA20
	Size: 0x74
	Parameters: 4
	Flags: Linked
*/
function set_filter_hazmat_opacity(player, filterid, overlayid, opacity)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, opacity);
	setoverlayconstant(player.localclientnum, overlayid, 0, opacity);
}

/*
	Name: enable_filter_hazmat
	Namespace: filter
	Checksum: 0x4C87E0CE
	Offset: 0xAA0
	Size: 0x214
	Parameters: 5
	Flags: None
*/
function enable_filter_hazmat(player, filterid, overlayid, stage, opacity)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_hazmat"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	if(stage == 1)
	{
		setoverlaymaterial(player.localclientnum, overlayid, mapped_material_id("generic_overlay_hazmat_1"), 1);
	}
	else
	{
		if(stage == 2)
		{
			setoverlaymaterial(player.localclientnum, overlayid, mapped_material_id("generic_overlay_hazmat_2"), 1);
		}
		else
		{
			if(stage == 3)
			{
				setoverlaymaterial(player.localclientnum, overlayid, mapped_material_id("generic_overlay_hazmat_3"), 1);
			}
			else if(stage == 4)
			{
				setoverlaymaterial(player.localclientnum, overlayid, mapped_material_id("generic_overlay_hazmat_4"), 1);
			}
		}
	}
	setoverlayenabled(player.localclientnum, overlayid, 1);
	set_filter_hazmat_opacity(player, filterid, overlayid, opacity);
}

/*
	Name: disable_filter_hazmat
	Namespace: filter
	Checksum: 0xEB6C8B1A
	Offset: 0xCC0
	Size: 0x6C
	Parameters: 3
	Flags: None
*/
function disable_filter_hazmat(player, filterid, overlayid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
	setoverlayenabled(player.localclientnum, overlayid, 0);
}

/*
	Name: init_filter_helmet
	Namespace: filter
	Checksum: 0x7C178839
	Offset: 0xD38
	Size: 0x5C
	Parameters: 1
	Flags: None
*/
function init_filter_helmet(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_helmet");
	map_material_helper(player, "generic_overlay_helmet");
}

/*
	Name: enable_filter_helmet
	Namespace: filter
	Checksum: 0x9BE93CBD
	Offset: 0xDA0
	Size: 0xE4
	Parameters: 3
	Flags: None
*/
function enable_filter_helmet(player, filterid, overlayid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_helmet"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	setoverlaymaterial(player.localclientnum, overlayid, mapped_material_id("generic_overlay_helmet"), 1);
	setoverlayenabled(player.localclientnum, overlayid, 1);
}

/*
	Name: disable_filter_helmet
	Namespace: filter
	Checksum: 0xDF92121B
	Offset: 0xE90
	Size: 0x6C
	Parameters: 3
	Flags: None
*/
function disable_filter_helmet(player, filterid, overlayid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
	setoverlayenabled(player.localclientnum, overlayid, 0);
}

/*
	Name: init_filter_tacticalmask
	Namespace: filter
	Checksum: 0x216D97A2
	Offset: 0xF08
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_tacticalmask(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_overlay_tacticalmask");
}

/*
	Name: enable_filter_tacticalmask
	Namespace: filter
	Checksum: 0xBAA59C7B
	Offset: 0xF50
	Size: 0x74
	Parameters: 2
	Flags: None
*/
function enable_filter_tacticalmask(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_overlay_tacticalmask"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: disable_filter_tacticalmask
	Namespace: filter
	Checksum: 0x974A4F90
	Offset: 0xFD0
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_tacticalmask(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_hud_projected_grid
	Namespace: filter
	Checksum: 0x93919043
	Offset: 0x1018
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_hud_projected_grid(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_hud_projected_grid");
}

/*
	Name: init_filter_hud_projected_grid_haiti
	Namespace: filter
	Checksum: 0x117FCCF3
	Offset: 0x1060
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_hud_projected_grid_haiti(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_hud_projected_grid_haiti");
}

/*
	Name: set_filter_hud_projected_grid_position
	Namespace: filter
	Checksum: 0x9E2C74B2
	Offset: 0x10A8
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_hud_projected_grid_position(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: set_filter_hud_projected_grid_radius
	Namespace: filter
	Checksum: 0x4981F418
	Offset: 0x10F8
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_hud_projected_grid_radius(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 1, amount);
}

/*
	Name: enable_filter_hud_projected_grid
	Namespace: filter
	Checksum: 0xF1EA5617
	Offset: 0x1150
	Size: 0xB4
	Parameters: 2
	Flags: None
*/
function enable_filter_hud_projected_grid(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_hud_projected_grid"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	player set_filter_hud_projected_grid_position(player, filterid, 500);
	player set_filter_hud_projected_grid_radius(player, filterid, 200);
}

/*
	Name: enable_filter_hud_projected_grid_haiti
	Namespace: filter
	Checksum: 0x87393AC7
	Offset: 0x1210
	Size: 0xB4
	Parameters: 2
	Flags: None
*/
function enable_filter_hud_projected_grid_haiti(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_hud_projected_grid_haiti"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	player set_filter_hud_projected_grid_position(player, filterid, 500);
	player set_filter_hud_projected_grid_radius(player, filterid, 200);
}

/*
	Name: disable_filter_hud_projected_grid
	Namespace: filter
	Checksum: 0x6B849CFD
	Offset: 0x12D0
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_hud_projected_grid(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_emp
	Namespace: filter
	Checksum: 0xF1F343C3
	Offset: 0x1318
	Size: 0x44
	Parameters: 2
	Flags: None
*/
function init_filter_emp(player, materialname)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_emp_damage");
}

/*
	Name: set_filter_emp_amount
	Namespace: filter
	Checksum: 0x7AF4AAF1
	Offset: 0x1368
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function set_filter_emp_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: enable_filter_emp
	Namespace: filter
	Checksum: 0x1813FA47
	Offset: 0x13B8
	Size: 0x74
	Parameters: 2
	Flags: None
*/
function enable_filter_emp(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_emp_damage"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: disable_filter_emp
	Namespace: filter
	Checksum: 0x79AF8FA8
	Offset: 0x1438
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_emp(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_raindrops
	Namespace: filter
	Checksum: 0x2BFA8D48
	Offset: 0x1480
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_raindrops(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_raindrops");
}

/*
	Name: set_filter_raindrops_amount
	Namespace: filter
	Checksum: 0x4814E826
	Offset: 0x14C8
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_raindrops_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: enable_filter_raindrops
	Namespace: filter
	Checksum: 0xD12C835
	Offset: 0x1518
	Size: 0xBC
	Parameters: 2
	Flags: None
*/
function enable_filter_raindrops(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_raindrops"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	setfilterpassquads(player.localclientnum, filterid, 0, 400);
	set_filter_raindrops_amount(player, filterid, 1);
}

/*
	Name: disable_filter_raindrops
	Namespace: filter
	Checksum: 0xCA9B5F7
	Offset: 0x15E0
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_raindrops(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_squirrel_raindrops
	Namespace: filter
	Checksum: 0xC585747E
	Offset: 0x1628
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_squirrel_raindrops(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_squirrel_raindrops");
}

/*
	Name: set_filter_squirrel_raindrops_amount
	Namespace: filter
	Checksum: 0x277664D8
	Offset: 0x1670
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_squirrel_raindrops_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: enable_filter_squirrel_raindrops
	Namespace: filter
	Checksum: 0x5B36A2D6
	Offset: 0x16C0
	Size: 0xBC
	Parameters: 2
	Flags: None
*/
function enable_filter_squirrel_raindrops(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_squirrel_raindrops"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	setfilterpassquads(player.localclientnum, filterid, 0, 400);
	set_filter_squirrel_raindrops_amount(player, filterid, 1);
}

/*
	Name: disable_filter_squirrel_raindrops
	Namespace: filter
	Checksum: 0xAFE6A342
	Offset: 0x1788
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_squirrel_raindrops(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_radialblur
	Namespace: filter
	Checksum: 0x1C3DD214
	Offset: 0x17D0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_radialblur(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_radialblur");
}

/*
	Name: set_filter_radialblur_amount
	Namespace: filter
	Checksum: 0x4050A21E
	Offset: 0x1818
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_radialblur_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: enable_filter_radialblur
	Namespace: filter
	Checksum: 0xEB1E519A
	Offset: 0x1868
	Size: 0x94
	Parameters: 2
	Flags: None
*/
function enable_filter_radialblur(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_radialblur"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	set_filter_radialblur_amount(player, filterid, 1);
}

/*
	Name: disable_filter_radialblur
	Namespace: filter
	Checksum: 0xEAF40B1D
	Offset: 0x1908
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_radialblur(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_vehicle_damage
	Namespace: filter
	Checksum: 0xA22264C3
	Offset: 0x1950
	Size: 0x54
	Parameters: 2
	Flags: Linked
*/
function init_filter_vehicle_damage(player, materialname)
{
	init_filter_indices();
	if(!isdefined(level.filter_matid[materialname]))
	{
		map_material_helper(player, materialname);
	}
}

/*
	Name: set_filter_vehicle_damage_amount
	Namespace: filter
	Checksum: 0x530F1830
	Offset: 0x19B0
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_vehicle_damage_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: set_filter_vehicle_sun_position
	Namespace: filter
	Checksum: 0x69D4CEEB
	Offset: 0x1A00
	Size: 0x84
	Parameters: 4
	Flags: Linked
*/
function set_filter_vehicle_sun_position(player, filterid, x, y)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 4, x);
	setfilterpassconstant(player.localclientnum, filterid, 0, 5, y);
}

/*
	Name: enable_filter_vehicle_damage
	Namespace: filter
	Checksum: 0x6019D036
	Offset: 0x1A90
	Size: 0x84
	Parameters: 3
	Flags: Linked
*/
function enable_filter_vehicle_damage(player, filterid, materialname)
{
	if(isdefined(level.filter_matid[materialname]))
	{
		setfilterpassmaterial(player.localclientnum, filterid, 0, level.filter_matid[materialname]);
		setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	}
}

/*
	Name: disable_filter_vehicle_damage
	Namespace: filter
	Checksum: 0x1459A588
	Offset: 0x1B20
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_vehicle_damage(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_oob
	Namespace: filter
	Checksum: 0x316D124F
	Offset: 0x1B68
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_oob(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_out_of_bounds");
}

/*
	Name: enable_filter_oob
	Namespace: filter
	Checksum: 0x56B95E63
	Offset: 0x1BB0
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function enable_filter_oob(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_out_of_bounds"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: disable_filter_oob
	Namespace: filter
	Checksum: 0xCF83D4C8
	Offset: 0x1C30
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_oob(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_tactical
	Namespace: filter
	Checksum: 0x72741E89
	Offset: 0x1C78
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_tactical(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_tactical_damage");
}

/*
	Name: enable_filter_tactical
	Namespace: filter
	Checksum: 0x1B9F204A
	Offset: 0x1CC0
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function enable_filter_tactical(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_tactical_damage"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: set_filter_tactical_amount
	Namespace: filter
	Checksum: 0x93E595A7
	Offset: 0x1D40
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_tactical_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: disable_filter_tactical
	Namespace: filter
	Checksum: 0x74C408A9
	Offset: 0x1D90
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_tactical(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_water_sheeting
	Namespace: filter
	Checksum: 0x3177648
	Offset: 0x1DD8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_water_sheeting(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_water_sheeting");
}

/*
	Name: enable_filter_water_sheeting
	Namespace: filter
	Checksum: 0x4F1B1B72
	Offset: 0x1E20
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function enable_filter_water_sheeting(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_water_sheeting"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1, 0, 1);
}

/*
	Name: set_filter_water_sheet_reveal
	Namespace: filter
	Checksum: 0x724CE968
	Offset: 0x1EA8
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_water_sheet_reveal(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: set_filter_water_sheet_speed
	Namespace: filter
	Checksum: 0x7524CBF9
	Offset: 0x1EF8
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_water_sheet_speed(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 1, amount);
}

/*
	Name: set_filter_water_sheet_rivulet_reveal
	Namespace: filter
	Checksum: 0x32235F49
	Offset: 0x1F50
	Size: 0xBC
	Parameters: 5
	Flags: Linked
*/
function set_filter_water_sheet_rivulet_reveal(player, filterid, riv1, riv2, riv3)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 2, riv1);
	setfilterpassconstant(player.localclientnum, filterid, 0, 3, riv2);
	setfilterpassconstant(player.localclientnum, filterid, 0, 4, riv3);
}

/*
	Name: disable_filter_water_sheeting
	Namespace: filter
	Checksum: 0xB107D6DE
	Offset: 0x2018
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_water_sheeting(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_water_dive
	Namespace: filter
	Checksum: 0x834F7A8D
	Offset: 0x2060
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_water_dive(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_water_dive");
}

/*
	Name: enable_filter_water_dive
	Namespace: filter
	Checksum: 0x5FDAE4A3
	Offset: 0x20A8
	Size: 0x7C
	Parameters: 2
	Flags: Linked
*/
function enable_filter_water_dive(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_water_dive"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1, 0, 1);
}

/*
	Name: disable_filter_water_dive
	Namespace: filter
	Checksum: 0x6E7704B6
	Offset: 0x2130
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_water_dive(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: set_filter_water_dive_bubbles
	Namespace: filter
	Checksum: 0xC89F4625
	Offset: 0x2178
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_water_dive_bubbles(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: set_filter_water_scuba_bubbles
	Namespace: filter
	Checksum: 0x29531162
	Offset: 0x21C8
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_water_scuba_bubbles(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 1, amount);
}

/*
	Name: set_filter_water_scuba_dive_speed
	Namespace: filter
	Checksum: 0x77D37DFC
	Offset: 0x2220
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_water_scuba_dive_speed(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 2, amount);
}

/*
	Name: set_filter_water_scuba_bubble_attitude
	Namespace: filter
	Checksum: 0x63E2F848
	Offset: 0x2278
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_water_scuba_bubble_attitude(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 3, amount);
}

/*
	Name: set_filter_water_wash_reveal_dir
	Namespace: filter
	Checksum: 0x5BC7F455
	Offset: 0x22D0
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_water_wash_reveal_dir(player, filterid, dir)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 4, dir);
}

/*
	Name: set_filter_water_wash_color
	Namespace: filter
	Checksum: 0x616055E7
	Offset: 0x2328
	Size: 0xBC
	Parameters: 5
	Flags: Linked
*/
function set_filter_water_wash_color(player, filterid, red, green, blue)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 5, red);
	setfilterpassconstant(player.localclientnum, filterid, 0, 6, green);
	setfilterpassconstant(player.localclientnum, filterid, 0, 7, blue);
}

/*
	Name: init_filter_teleportation
	Namespace: filter
	Checksum: 0x20446804
	Offset: 0x23F0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_teleportation(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_teleportation");
}

/*
	Name: enable_filter_teleportation
	Namespace: filter
	Checksum: 0xF7B6F165
	Offset: 0x2438
	Size: 0x74
	Parameters: 2
	Flags: None
*/
function enable_filter_teleportation(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_teleportation"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: set_filter_teleportation_anus_zoom
	Namespace: filter
	Checksum: 0x77C0FAE5
	Offset: 0x24B8
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_anus_zoom(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: set_filter_teleportation_anus_amount
	Namespace: filter
	Checksum: 0x4684ECA
	Offset: 0x2508
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_anus_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 6, amount);
}

/*
	Name: set_filter_teleportation_panther_zoom
	Namespace: filter
	Checksum: 0xB835C0C
	Offset: 0x2560
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_panther_zoom(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 1, amount);
}

/*
	Name: set_filter_teleportation_panther_amount
	Namespace: filter
	Checksum: 0x6F6B6E2A
	Offset: 0x25B8
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_panther_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 7, amount);
}

/*
	Name: set_filter_teleportation_glow_radius
	Namespace: filter
	Checksum: 0xC64CCAB4
	Offset: 0x2610
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_glow_radius(player, filterid, radius)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 2, radius);
}

/*
	Name: set_filter_teleportation_warp_amount
	Namespace: filter
	Checksum: 0xFE253C29
	Offset: 0x2668
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_warp_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 3, amount);
}

/*
	Name: set_filter_teleportation_warp_direction
	Namespace: filter
	Checksum: 0xBB9B2408
	Offset: 0x26C0
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_warp_direction(player, filterid, direction)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 4, direction);
}

/*
	Name: set_filter_teleportation_lightning_reveal
	Namespace: filter
	Checksum: 0xB50F14B2
	Offset: 0x2718
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_lightning_reveal(player, filterid, threshold)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 5, threshold);
}

/*
	Name: set_filter_teleportation_faces_amount
	Namespace: filter
	Checksum: 0xCDDECCBD
	Offset: 0x2770
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_faces_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 8, amount);
}

/*
	Name: set_filter_teleportation_space_background
	Namespace: filter
	Checksum: 0x5B91C04F
	Offset: 0x27C8
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_space_background(player, filterid, set)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 9, set);
}

/*
	Name: set_filter_teleportation_sparkle_amount
	Namespace: filter
	Checksum: 0x75663EA3
	Offset: 0x2820
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_teleportation_sparkle_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 10, amount);
}

/*
	Name: disable_filter_teleportation
	Namespace: filter
	Checksum: 0x3562DC7C
	Offset: 0x2878
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_teleportation(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: settransported
	Namespace: filter
	Checksum: 0xFC0096ED
	Offset: 0x28C0
	Size: 0x2C
	Parameters: 1
	Flags: Linked
*/
function settransported(player)
{
	player thread postfx::playpostfxbundle("zm_teleporter");
}

/*
	Name: init_filter_ev_interference
	Namespace: filter
	Checksum: 0x7561B6DF
	Offset: 0x28F8
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_ev_interference(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_ev_interference");
}

/*
	Name: enable_filter_ev_interference
	Namespace: filter
	Checksum: 0xA5CFE597
	Offset: 0x2940
	Size: 0x9C
	Parameters: 2
	Flags: None
*/
function enable_filter_ev_interference(player, filterid)
{
	map_material_if_undefined(player.localclientnum, "generic_filter_ev_interference");
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_ev_interference"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: set_filter_ev_interference_amount
	Namespace: filter
	Checksum: 0x42954557
	Offset: 0x29E8
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function set_filter_ev_interference_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: disable_filter_ev_interference
	Namespace: filter
	Checksum: 0x3CC8EFAA
	Offset: 0x2A38
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_ev_interference(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_vehiclehijack
	Namespace: filter
	Checksum: 0x9E61D3B3
	Offset: 0x2A80
	Size: 0x52
	Parameters: 1
	Flags: None
*/
function init_filter_vehiclehijack(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_vehicle_takeover");
	return mapped_material_id("generic_filter_vehicle_takeover");
}

/*
	Name: enable_filter_vehiclehijack
	Namespace: filter
	Checksum: 0x2C47DC2F
	Offset: 0x2AE0
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function enable_filter_vehiclehijack(player, filterid, overlayid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_vehicle_takeover"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: disable_filter_vehiclehijack
	Namespace: filter
	Checksum: 0x45653F31
	Offset: 0x2B68
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function disable_filter_vehiclehijack(player, filterid, overlayid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: set_filter_ev_vehiclehijack_amount
	Namespace: filter
	Checksum: 0x82904649
	Offset: 0x2BB8
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function set_filter_ev_vehiclehijack_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: init_filter_vehicle_hijack_oor
	Namespace: filter
	Checksum: 0x87AC373B
	Offset: 0x2C08
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_vehicle_hijack_oor(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_vehicle_out_of_range");
}

/*
	Name: enable_filter_vehicle_hijack_oor
	Namespace: filter
	Checksum: 0xA01627FA
	Offset: 0x2C50
	Size: 0x134
	Parameters: 2
	Flags: None
*/
function enable_filter_vehicle_hijack_oor(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_vehicle_out_of_range"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	setfilterpassconstant(player.localclientnum, filterid, 0, 1, 0);
	setfilterpassconstant(player.localclientnum, filterid, 0, 2, 1);
	setfilterpassconstant(player.localclientnum, filterid, 0, 3, 0);
	setfilterpassconstant(player.localclientnum, filterid, 0, 4, -1);
}

/*
	Name: set_filter_vehicle_hijack_oor_noblack
	Namespace: filter
	Checksum: 0x30B9D563
	Offset: 0x2D90
	Size: 0x44
	Parameters: 2
	Flags: None
*/
function set_filter_vehicle_hijack_oor_noblack(player, filterid)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 3, 1);
}

/*
	Name: set_filter_vehicle_hijack_oor_amount
	Namespace: filter
	Checksum: 0x1C4DD1CA
	Offset: 0x2DE0
	Size: 0x74
	Parameters: 3
	Flags: None
*/
function set_filter_vehicle_hijack_oor_amount(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
	setfilterpassconstant(player.localclientnum, filterid, 0, 1, amount);
}

/*
	Name: disable_filter_vehicle_hijack_oor
	Namespace: filter
	Checksum: 0xCAD63941
	Offset: 0x2E60
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_vehicle_hijack_oor(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_speed_burst
	Namespace: filter
	Checksum: 0xD7B74551
	Offset: 0x2EA8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_speed_burst(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_speed_burst");
}

/*
	Name: enable_filter_speed_burst
	Namespace: filter
	Checksum: 0xB3BE6986
	Offset: 0x2EF0
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function enable_filter_speed_burst(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_speed_burst"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: set_filter_speed_burst
	Namespace: filter
	Checksum: 0x972286A4
	Offset: 0x2F70
	Size: 0x54
	Parameters: 4
	Flags: None
*/
function set_filter_speed_burst(player, filterid, constantindex, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, constantindex, amount);
}

/*
	Name: disable_filter_speed_burst
	Namespace: filter
	Checksum: 0xF4A92358
	Offset: 0x2FD0
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_speed_burst(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_overdrive
	Namespace: filter
	Checksum: 0x1FAF7A0B
	Offset: 0x3018
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function init_filter_overdrive(player)
{
	init_filter_indices();
	if(sessionmodeiscampaigngame())
	{
		map_material_helper(player, "generic_filter_overdrive_cp");
	}
}

/*
	Name: enable_filter_overdrive
	Namespace: filter
	Checksum: 0x9790B0AD
	Offset: 0x3070
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function enable_filter_overdrive(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_overdrive_cp"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: set_filter_overdrive
	Namespace: filter
	Checksum: 0x7E858ED
	Offset: 0x30F0
	Size: 0x54
	Parameters: 4
	Flags: None
*/
function set_filter_overdrive(player, filterid, constantindex, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, constantindex, amount);
}

/*
	Name: disable_filter_overdrive
	Namespace: filter
	Checksum: 0x999845A0
	Offset: 0x3150
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_overdrive(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_frost
	Namespace: filter
	Checksum: 0xE7755BF7
	Offset: 0x3198
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_frost(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_frost");
}

/*
	Name: enable_filter_frost
	Namespace: filter
	Checksum: 0x6A1FDC3
	Offset: 0x31E0
	Size: 0x74
	Parameters: 2
	Flags: None
*/
function enable_filter_frost(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_frost"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: set_filter_frost_layer_one
	Namespace: filter
	Checksum: 0xBA88D1F4
	Offset: 0x3260
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function set_filter_frost_layer_one(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, amount);
}

/*
	Name: set_filter_frost_layer_two
	Namespace: filter
	Checksum: 0xB1309FAC
	Offset: 0x32B0
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_frost_layer_two(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 1, amount);
}

/*
	Name: set_filter_frost_reveal_direction
	Namespace: filter
	Checksum: 0x3947AA0D
	Offset: 0x3308
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_frost_reveal_direction(player, filterid, direction)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 2, direction);
}

/*
	Name: disable_filter_frost
	Namespace: filter
	Checksum: 0xD672E56D
	Offset: 0x3360
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_frost(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_vision_pulse
	Namespace: filter
	Checksum: 0xDFF77D2B
	Offset: 0x33A8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_vision_pulse(localclientnum)
{
	init_filter_indices();
	map_material_helper_by_localclientnum(localclientnum, "generic_filter_vision_pulse");
}

/*
	Name: enable_filter_vision_pulse
	Namespace: filter
	Checksum: 0x8553119E
	Offset: 0x33F0
	Size: 0x84
	Parameters: 2
	Flags: Linked
*/
function enable_filter_vision_pulse(localclientnum, filterid)
{
	map_material_if_undefined(localclientnum, "generic_filter_vision_pulse");
	setfilterpassmaterial(localclientnum, filterid, 0, mapped_material_id("generic_filter_vision_pulse"));
	setfilterpassenabled(localclientnum, filterid, 0, 1);
}

/*
	Name: set_filter_vision_pulse_constant
	Namespace: filter
	Checksum: 0x221ED56
	Offset: 0x3480
	Size: 0x4C
	Parameters: 4
	Flags: Linked
*/
function set_filter_vision_pulse_constant(localclientnum, filterid, constid, value)
{
	setfilterpassconstant(localclientnum, filterid, 0, constid, value);
}

/*
	Name: disable_filter_vision_pulse
	Namespace: filter
	Checksum: 0xB70EA376
	Offset: 0x34D8
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function disable_filter_vision_pulse(localclientnum, filterid)
{
	setfilterpassenabled(localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_sprite_transition
	Namespace: filter
	Checksum: 0x27B06EBA
	Offset: 0x3518
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_sprite_transition(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_transition_sprite");
}

/*
	Name: enable_filter_sprite_transition
	Namespace: filter
	Checksum: 0x9CD8BA38
	Offset: 0x3560
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function enable_filter_sprite_transition(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 1, mapped_material_id("generic_filter_transition_sprite"));
	setfilterpassenabled(player.localclientnum, filterid, 1, 1);
	setfilterpassquads(player.localclientnum, filterid, 1, 2048);
}

/*
	Name: set_filter_sprite_transition_octogons
	Namespace: filter
	Checksum: 0xFDF7F0D7
	Offset: 0x3608
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_sprite_transition_octogons(player, filterid, octos)
{
	setfilterpassconstant(player.localclientnum, filterid, 1, 0, octos);
}

/*
	Name: set_filter_sprite_transition_blur
	Namespace: filter
	Checksum: 0xD51706D3
	Offset: 0x3660
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_sprite_transition_blur(player, filterid, blur)
{
	setfilterpassconstant(player.localclientnum, filterid, 1, 1, blur);
}

/*
	Name: set_filter_sprite_transition_boost
	Namespace: filter
	Checksum: 0xDAE9B14C
	Offset: 0x36B8
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_sprite_transition_boost(player, filterid, boost)
{
	setfilterpassconstant(player.localclientnum, filterid, 1, 2, boost);
}

/*
	Name: set_filter_sprite_transition_move_radii
	Namespace: filter
	Checksum: 0xECF5F5F9
	Offset: 0x3710
	Size: 0x84
	Parameters: 4
	Flags: Linked
*/
function set_filter_sprite_transition_move_radii(player, filterid, inner, outter)
{
	setfilterpassconstant(player.localclientnum, filterid, 1, 24, inner);
	setfilterpassconstant(player.localclientnum, filterid, 1, 25, outter);
}

/*
	Name: set_filter_sprite_transition_elapsed
	Namespace: filter
	Checksum: 0x37AF8EE
	Offset: 0x37A0
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_sprite_transition_elapsed(player, filterid, time)
{
	setfilterpassconstant(player.localclientnum, filterid, 1, 28, time);
}

/*
	Name: disable_filter_sprite_transition
	Namespace: filter
	Checksum: 0x17318892
	Offset: 0x37F8
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_sprite_transition(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 1, 0);
}

/*
	Name: init_filter_frame_transition
	Namespace: filter
	Checksum: 0x6D90DB4C
	Offset: 0x3840
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_frame_transition(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_transition_frame");
}

/*
	Name: enable_filter_frame_transition
	Namespace: filter
	Checksum: 0x10ED44E1
	Offset: 0x3888
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function enable_filter_frame_transition(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 2, mapped_material_id("generic_filter_transition_frame"));
	setfilterpassenabled(player.localclientnum, filterid, 2, 1);
}

/*
	Name: set_filter_frame_transition_heavy_hexagons
	Namespace: filter
	Checksum: 0xF821C3FA
	Offset: 0x3908
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_frame_transition_heavy_hexagons(player, filterid, hexes)
{
	setfilterpassconstant(player.localclientnum, filterid, 2, 0, hexes);
}

/*
	Name: set_filter_frame_transition_light_hexagons
	Namespace: filter
	Checksum: 0xF1941654
	Offset: 0x3960
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_frame_transition_light_hexagons(player, filterid, hexes)
{
	setfilterpassconstant(player.localclientnum, filterid, 2, 1, hexes);
}

/*
	Name: set_filter_frame_transition_flare
	Namespace: filter
	Checksum: 0xBEF0CEFE
	Offset: 0x39B8
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_frame_transition_flare(player, filterid, opacity)
{
	setfilterpassconstant(player.localclientnum, filterid, 2, 2, opacity);
}

/*
	Name: set_filter_frame_transition_blur
	Namespace: filter
	Checksum: 0xD5006C4E
	Offset: 0x3A10
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_frame_transition_blur(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 2, 3, amount);
}

/*
	Name: set_filter_frame_transition_iris
	Namespace: filter
	Checksum: 0x77DCB3E1
	Offset: 0x3A68
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_frame_transition_iris(player, filterid, opacity)
{
	setfilterpassconstant(player.localclientnum, filterid, 2, 4, opacity);
}

/*
	Name: set_filter_frame_transition_saved_frame_reveal
	Namespace: filter
	Checksum: 0xC4DF8919
	Offset: 0x3AC0
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_frame_transition_saved_frame_reveal(player, filterid, reveal)
{
	setfilterpassconstant(player.localclientnum, filterid, 2, 5, reveal);
}

/*
	Name: set_filter_frame_transition_warp
	Namespace: filter
	Checksum: 0xCCB0B10D
	Offset: 0x3B18
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_frame_transition_warp(player, filterid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, 2, 6, amount);
}

/*
	Name: disable_filter_frame_transition
	Namespace: filter
	Checksum: 0x87612297
	Offset: 0x3B70
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_frame_transition(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 2, 0);
}

/*
	Name: init_filter_base_frame_transition
	Namespace: filter
	Checksum: 0xAE5E92F6
	Offset: 0x3BB8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_base_frame_transition(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_transition_frame_base");
}

/*
	Name: enable_filter_base_frame_transition
	Namespace: filter
	Checksum: 0xFE308FC7
	Offset: 0x3C00
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function enable_filter_base_frame_transition(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_transition_frame_base"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: set_filter_base_frame_transition_warp
	Namespace: filter
	Checksum: 0x5159D083
	Offset: 0x3C80
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_base_frame_transition_warp(player, filterid, warp)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, warp);
}

/*
	Name: set_filter_base_frame_transition_boost
	Namespace: filter
	Checksum: 0x3BBE90D3
	Offset: 0x3CD0
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_base_frame_transition_boost(player, filterid, boost)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 1, boost);
}

/*
	Name: set_filter_base_frame_transition_durden
	Namespace: filter
	Checksum: 0x4D063A75
	Offset: 0x3D28
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_base_frame_transition_durden(player, filterid, opacity)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 2, opacity);
}

/*
	Name: set_filter_base_frame_transition_durden_blur
	Namespace: filter
	Checksum: 0x5D4DB11B
	Offset: 0x3D80
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_base_frame_transition_durden_blur(player, filterid, blur)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 3, blur);
}

/*
	Name: disable_filter_base_frame_transition
	Namespace: filter
	Checksum: 0x800DA7BF
	Offset: 0x3DD8
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_base_frame_transition(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_sprite_blood
	Namespace: filter
	Checksum: 0xFD90FF8D
	Offset: 0x3E20
	Size: 0x5C
	Parameters: 2
	Flags: None
*/
function init_filter_sprite_blood(localclientnum, digitalblood)
{
	if(digitalblood)
	{
		map_material_helper_by_localclientnum(localclientnum, "generic_filter_sprite_blood_damage_reaper");
	}
	else
	{
		map_material_helper_by_localclientnum(localclientnum, "generic_filter_sprite_blood_damage");
	}
}

/*
	Name: enable_filter_sprite_blood
	Namespace: filter
	Checksum: 0xC20B52E6
	Offset: 0x3E88
	Size: 0xD4
	Parameters: 4
	Flags: None
*/
function enable_filter_sprite_blood(localclientnum, filterid, passid, digitalblood)
{
	if(digitalblood)
	{
		setfilterpassmaterial(localclientnum, filterid, passid, mapped_material_id("generic_filter_sprite_blood_damage_reaper"));
	}
	else
	{
		setfilterpassmaterial(localclientnum, filterid, passid, mapped_material_id("generic_filter_sprite_blood_damage"));
	}
	setfilterpassenabled(localclientnum, filterid, passid, 1);
	setfilterpassquads(localclientnum, filterid, passid, 400);
}

/*
	Name: init_filter_sprite_blood_heavy
	Namespace: filter
	Checksum: 0x8CE4AF2F
	Offset: 0x3F68
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function init_filter_sprite_blood_heavy(localclientnum, digitalblood)
{
	if(digitalblood)
	{
		map_material_helper_by_localclientnum(localclientnum, "generic_filter_sprite_blood_heavy_damage_reaper");
	}
	else
	{
		map_material_helper_by_localclientnum(localclientnum, "generic_filter_sprite_blood_heavy_damage");
	}
}

/*
	Name: enable_filter_sprite_blood_heavy
	Namespace: filter
	Checksum: 0xC3DD809E
	Offset: 0x3FD0
	Size: 0xD4
	Parameters: 4
	Flags: Linked
*/
function enable_filter_sprite_blood_heavy(localclientnum, filterid, passid, digitalblood)
{
	if(digitalblood)
	{
		setfilterpassmaterial(localclientnum, filterid, passid, mapped_material_id("generic_filter_sprite_blood_heavy_damage_reaper"));
	}
	else
	{
		setfilterpassmaterial(localclientnum, filterid, passid, mapped_material_id("generic_filter_sprite_blood_heavy_damage"));
	}
	setfilterpassenabled(localclientnum, filterid, passid, 1);
	setfilterpassquads(localclientnum, filterid, passid, 400);
}

/*
	Name: set_filter_sprite_blood_opacity
	Namespace: filter
	Checksum: 0xEF1B6DF
	Offset: 0x40B0
	Size: 0x4C
	Parameters: 4
	Flags: Linked
*/
function set_filter_sprite_blood_opacity(localclientnum, filterid, passid, opacity)
{
	setfilterpassconstant(localclientnum, filterid, passid, 0, opacity);
}

/*
	Name: set_filter_sprite_blood_seed_offset
	Namespace: filter
	Checksum: 0x8536A5AB
	Offset: 0x4108
	Size: 0x4C
	Parameters: 4
	Flags: Linked
*/
function set_filter_sprite_blood_seed_offset(localclientnum, filterid, passid, offset)
{
	setfilterpassconstant(localclientnum, filterid, passid, 26, offset);
}

/*
	Name: set_filter_sprite_blood_elapsed
	Namespace: filter
	Checksum: 0xD3338612
	Offset: 0x4160
	Size: 0x4C
	Parameters: 4
	Flags: Linked
*/
function set_filter_sprite_blood_elapsed(localclientnum, filterid, passid, time)
{
	setfilterpassconstant(localclientnum, filterid, passid, 28, time);
}

/*
	Name: disable_filter_sprite_blood
	Namespace: filter
	Checksum: 0xA5A9375B
	Offset: 0x41B8
	Size: 0x3C
	Parameters: 3
	Flags: Linked
*/
function disable_filter_sprite_blood(localclientnum, filterid, passid)
{
	setfilterpassenabled(localclientnum, filterid, passid, 0);
}

/*
	Name: init_filter_feedback_blood
	Namespace: filter
	Checksum: 0xB4CAE356
	Offset: 0x4200
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function init_filter_feedback_blood(localclientnum, digitalblood)
{
	init_filter_indices();
	if(digitalblood)
	{
		map_material_helper_by_localclientnum(localclientnum, "generic_filter_blood_damage_reaper");
	}
	else
	{
		map_material_helper_by_localclientnum(localclientnum, "generic_filter_blood_damage");
	}
}

/*
	Name: enable_filter_feedback_blood
	Namespace: filter
	Checksum: 0x218FE9CD
	Offset: 0x4278
	Size: 0xB4
	Parameters: 4
	Flags: Linked
*/
function enable_filter_feedback_blood(localclientnum, filterid, passid, digitalblood)
{
	if(digitalblood)
	{
		setfilterpassmaterial(localclientnum, filterid, passid, mapped_material_id("generic_filter_blood_damage_reaper"));
	}
	else
	{
		setfilterpassmaterial(localclientnum, filterid, passid, mapped_material_id("generic_filter_blood_damage"));
	}
	setfilterpassenabled(localclientnum, filterid, passid, 1);
}

/*
	Name: set_filter_feedback_blood_opacity
	Namespace: filter
	Checksum: 0xBB190130
	Offset: 0x4338
	Size: 0x4C
	Parameters: 4
	Flags: Linked
*/
function set_filter_feedback_blood_opacity(localclientnum, filterid, passid, opacity)
{
	setfilterpassconstant(localclientnum, filterid, passid, 0, opacity);
}

/*
	Name: set_filter_feedback_blood_sundir
	Namespace: filter
	Checksum: 0xA3C386E3
	Offset: 0x4390
	Size: 0x7C
	Parameters: 5
	Flags: Linked
*/
function set_filter_feedback_blood_sundir(localclientnum, filterid, passid, pitch, yaw)
{
	setfilterpassconstant(localclientnum, filterid, passid, 1, pitch);
	setfilterpassconstant(localclientnum, filterid, passid, 2, yaw);
}

/*
	Name: set_filter_feedback_blood_vignette
	Namespace: filter
	Checksum: 0x680DDA36
	Offset: 0x4418
	Size: 0x4C
	Parameters: 4
	Flags: Linked
*/
function set_filter_feedback_blood_vignette(localclientnum, filterid, passid, amount)
{
	setfilterpassconstant(localclientnum, filterid, passid, 3, amount);
}

/*
	Name: set_filter_feedback_blood_drowning
	Namespace: filter
	Checksum: 0x2209A9A2
	Offset: 0x4470
	Size: 0x7C
	Parameters: 5
	Flags: None
*/
function set_filter_feedback_blood_drowning(localclientnum, filterid, passid, tintamount, allowtint)
{
	setfilterpassconstant(localclientnum, filterid, passid, 4, tintamount);
	setfilterpassconstant(localclientnum, filterid, passid, 5, allowtint);
}

/*
	Name: disable_filter_feedback_blood
	Namespace: filter
	Checksum: 0xCD830DC2
	Offset: 0x44F8
	Size: 0x3C
	Parameters: 3
	Flags: Linked
*/
function disable_filter_feedback_blood(localclientnum, filterid, passid)
{
	setfilterpassenabled(localclientnum, filterid, passid, 0);
}

/*
	Name: init_filter_sprite_rain
	Namespace: filter
	Checksum: 0x96A0D660
	Offset: 0x4540
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_sprite_rain(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_sprite_rain");
}

/*
	Name: enable_filter_sprite_rain
	Namespace: filter
	Checksum: 0x11E36924
	Offset: 0x4588
	Size: 0x9C
	Parameters: 2
	Flags: None
*/
function enable_filter_sprite_rain(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_sprite_rain"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	setfilterpassquads(player.localclientnum, filterid, 0, 2048);
}

/*
	Name: set_filter_sprite_rain_opacity
	Namespace: filter
	Checksum: 0x5985B593
	Offset: 0x4630
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function set_filter_sprite_rain_opacity(player, filterid, opacity)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, opacity);
}

/*
	Name: set_filter_sprite_rain_seed_offset
	Namespace: filter
	Checksum: 0xA59CEB44
	Offset: 0x4680
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_sprite_rain_seed_offset(player, filterid, offset)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 26, offset);
}

/*
	Name: set_filter_sprite_rain_elapsed
	Namespace: filter
	Checksum: 0xA82CDE89
	Offset: 0x46D8
	Size: 0x4C
	Parameters: 3
	Flags: None
*/
function set_filter_sprite_rain_elapsed(player, filterid, time)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 28, time);
}

/*
	Name: disable_filter_sprite_rain
	Namespace: filter
	Checksum: 0x94B6ED5D
	Offset: 0x4730
	Size: 0x3C
	Parameters: 2
	Flags: None
*/
function disable_filter_sprite_rain(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_sgen_sprite_rain
	Namespace: filter
	Checksum: 0x1D5F42BB
	Offset: 0x4778
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_sgen_sprite_rain(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_blkstn_sprite_rain");
}

/*
	Name: enable_filter_sgen_sprite_rain
	Namespace: filter
	Checksum: 0x8286419C
	Offset: 0x47C0
	Size: 0x9C
	Parameters: 2
	Flags: None
*/
function enable_filter_sgen_sprite_rain(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_blkstn_sprite_rain"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	setfilterpassquads(player.localclientnum, filterid, 0, 2048);
}

/*
	Name: init_filter_sprite_dirt
	Namespace: filter
	Checksum: 0x64FEE71D
	Offset: 0x4868
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_sprite_dirt(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_sprite_dirt");
}

/*
	Name: enable_filter_sprite_dirt
	Namespace: filter
	Checksum: 0xAB94915B
	Offset: 0x48B0
	Size: 0x9C
	Parameters: 2
	Flags: Linked
*/
function enable_filter_sprite_dirt(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_sprite_dirt"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
	setfilterpassquads(player.localclientnum, filterid, 0, 400);
}

/*
	Name: set_filter_sprite_dirt_opacity
	Namespace: filter
	Checksum: 0xD3BA8249
	Offset: 0x4958
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_sprite_dirt_opacity(player, filterid, opacity)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, opacity);
}

/*
	Name: set_filter_sprite_dirt_source_position
	Namespace: filter
	Checksum: 0xA53DF005
	Offset: 0x49A8
	Size: 0xBC
	Parameters: 5
	Flags: Linked
*/
function set_filter_sprite_dirt_source_position(player, filterid, right, up, distance)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 1, right);
	setfilterpassconstant(player.localclientnum, filterid, 0, 2, up);
	setfilterpassconstant(player.localclientnum, filterid, 0, 3, distance);
}

/*
	Name: set_filter_sprite_dirt_sun_position
	Namespace: filter
	Checksum: 0xE0356E5
	Offset: 0x4A70
	Size: 0x84
	Parameters: 4
	Flags: None
*/
function set_filter_sprite_dirt_sun_position(player, filterid, pitch, yaw)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 4, pitch);
	setfilterpassconstant(player.localclientnum, filterid, 0, 5, yaw);
}

/*
	Name: set_filter_sprite_dirt_seed_offset
	Namespace: filter
	Checksum: 0x8B28048D
	Offset: 0x4B00
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_sprite_dirt_seed_offset(player, filterid, offset)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 26, offset);
}

/*
	Name: set_filter_sprite_dirt_elapsed
	Namespace: filter
	Checksum: 0x875C6B30
	Offset: 0x4B58
	Size: 0x4C
	Parameters: 3
	Flags: Linked
*/
function set_filter_sprite_dirt_elapsed(player, filterid, time)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 28, time);
}

/*
	Name: disable_filter_sprite_dirt
	Namespace: filter
	Checksum: 0x93A61B67
	Offset: 0x4BB0
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_sprite_dirt(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_blood_spatter
	Namespace: filter
	Checksum: 0x9B763238
	Offset: 0x4BF8
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_blood_spatter(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_blood_spatter");
}

/*
	Name: enable_filter_blood_spatter
	Namespace: filter
	Checksum: 0xEA29C0EB
	Offset: 0x4C40
	Size: 0x74
	Parameters: 2
	Flags: Linked
*/
function enable_filter_blood_spatter(player, filterid)
{
	setfilterpassmaterial(player.localclientnum, filterid, 0, mapped_material_id("generic_filter_blood_spatter"));
	setfilterpassenabled(player.localclientnum, filterid, 0, 1);
}

/*
	Name: set_filter_blood_spatter_reveal
	Namespace: filter
	Checksum: 0xB661DD1A
	Offset: 0x4CC0
	Size: 0x7C
	Parameters: 4
	Flags: Linked
*/
function set_filter_blood_spatter_reveal(player, filterid, threshold, direction)
{
	setfilterpassconstant(player.localclientnum, filterid, 0, 0, threshold);
	setfilterpassconstant(player.localclientnum, filterid, 0, 1, direction);
}

/*
	Name: disable_filter_blood_spatter
	Namespace: filter
	Checksum: 0x4DB16AC6
	Offset: 0x4D48
	Size: 0x3C
	Parameters: 2
	Flags: Linked
*/
function disable_filter_blood_spatter(player, filterid)
{
	setfilterpassenabled(player.localclientnum, filterid, 0, 0);
}

/*
	Name: init_filter_teleporter_base
	Namespace: filter
	Checksum: 0xF09B2748
	Offset: 0x4D90
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_teleporter_base(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_zm_teleporter_base");
}

/*
	Name: enable_filter_teleporter_base
	Namespace: filter
	Checksum: 0xF3C2EC63
	Offset: 0x4DD8
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function enable_filter_teleporter_base(player, filterid, passid)
{
	setfilterpassmaterial(player.localclientnum, filterid, passid, mapped_material_id("generic_filter_zm_teleporter_base"));
	setfilterpassenabled(player.localclientnum, filterid, passid, 1);
}

/*
	Name: set_filter_teleporter_base_amount
	Namespace: filter
	Checksum: 0x612553D2
	Offset: 0x4E60
	Size: 0x54
	Parameters: 4
	Flags: None
*/
function set_filter_teleporter_base_amount(player, filterid, passid, amount)
{
	setfilterpassconstant(player.localclientnum, filterid, passid, 0, amount);
}

/*
	Name: disable_filter_teleporter_base
	Namespace: filter
	Checksum: 0x910852C
	Offset: 0x4EC0
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function disable_filter_teleporter_base(player, filterid, passid)
{
	setfilterpassenabled(player.localclientnum, filterid, passid, 0);
}

/*
	Name: init_filter_teleporter_sprite
	Namespace: filter
	Checksum: 0xEB306675
	Offset: 0x4F10
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_teleporter_sprite(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_zm_teleporter_sprite");
}

/*
	Name: enable_filter_teleporter_sprite
	Namespace: filter
	Checksum: 0x29A8B6D5
	Offset: 0x4F58
	Size: 0xA4
	Parameters: 3
	Flags: None
*/
function enable_filter_teleporter_sprite(player, filterid, passid)
{
	setfilterpassmaterial(player.localclientnum, filterid, passid, mapped_material_id("generic_filter_zm_teleporter_sprite"));
	setfilterpassenabled(player.localclientnum, filterid, passid, 1);
	setfilterpassquads(player.localclientnum, filterid, passid, 400);
}

/*
	Name: set_filter_teleporter_sprite_opacity
	Namespace: filter
	Checksum: 0x5C8F0DF5
	Offset: 0x5008
	Size: 0x54
	Parameters: 4
	Flags: None
*/
function set_filter_teleporter_sprite_opacity(player, filterid, passid, opacity)
{
	setfilterpassconstant(player.localclientnum, filterid, passid, 0, opacity);
}

/*
	Name: set_filter_teleporter_sprite_seed_offset
	Namespace: filter
	Checksum: 0x5AEAC5DF
	Offset: 0x5068
	Size: 0x54
	Parameters: 4
	Flags: None
*/
function set_filter_teleporter_sprite_seed_offset(player, filterid, passid, offset)
{
	setfilterpassconstant(player.localclientnum, filterid, passid, 26, offset);
}

/*
	Name: set_filter_teleporter_sprite_elapsed
	Namespace: filter
	Checksum: 0x8EA81183
	Offset: 0x50C8
	Size: 0x54
	Parameters: 4
	Flags: None
*/
function set_filter_teleporter_sprite_elapsed(player, filterid, passid, time)
{
	setfilterpassconstant(player.localclientnum, filterid, passid, 28, time);
}

/*
	Name: disable_filter_teleporter_sprite
	Namespace: filter
	Checksum: 0x80CFEAA5
	Offset: 0x5128
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function disable_filter_teleporter_sprite(player, filterid, passid)
{
	setfilterpassenabled(player.localclientnum, filterid, passid, 0);
}

/*
	Name: init_filter_teleporter_top
	Namespace: filter
	Checksum: 0xF0D1D8A1
	Offset: 0x5178
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_teleporter_top(player)
{
	init_filter_indices();
	map_material_helper(player, "generic_filter_zm_teleporter_base");
}

/*
	Name: enable_filter_teleporter_top
	Namespace: filter
	Checksum: 0x45B3A1CD
	Offset: 0x51C0
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function enable_filter_teleporter_top(player, filterid, passid)
{
	setfilterpassmaterial(player.localclientnum, filterid, passid, mapped_material_id("generic_filter_zm_teleporter_base"));
	setfilterpassenabled(player.localclientnum, filterid, passid, 1);
}

/*
	Name: set_filter_teleporter_top_reveal
	Namespace: filter
	Checksum: 0x1E7CEB51
	Offset: 0x5248
	Size: 0x8C
	Parameters: 5
	Flags: None
*/
function set_filter_teleporter_top_reveal(player, filterid, passid, threshold, direction)
{
	setfilterpassconstant(player.localclientnum, filterid, passid, 0, threshold);
	setfilterpassconstant(player.localclientnum, filterid, passid, 1, direction);
}

/*
	Name: disable_filter_teleporter_top
	Namespace: filter
	Checksum: 0xD48C270E
	Offset: 0x52E0
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function disable_filter_teleporter_top(player, filterid, passid)
{
	setfilterpassenabled(player.localclientnum, filterid, passid, 0);
}

/*
	Name: init_filter_keyline_blend
	Namespace: filter
	Checksum: 0x9CD8D46E
	Offset: 0x5330
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function init_filter_keyline_blend(player)
{
	init_filter_indices();
	map_material_helper(player, "postfx_keyline_blend");
}

/*
	Name: enable_filter_keyline_blend
	Namespace: filter
	Checksum: 0x3BF3D22
	Offset: 0x5378
	Size: 0x7C
	Parameters: 3
	Flags: None
*/
function enable_filter_keyline_blend(player, filterid, passid)
{
	setfilterpassmaterial(player.localclientnum, filterid, passid, mapped_material_id("postfx_keyline_blend"));
	setfilterpassenabled(player.localclientnum, filterid, passid, 1);
}

/*
	Name: set_filter_keyline_blend_opacity
	Namespace: filter
	Checksum: 0xAB064B86
	Offset: 0x5400
	Size: 0x54
	Parameters: 4
	Flags: None
*/
function set_filter_keyline_blend_opacity(player, filterid, passid, opacity)
{
	setfilterpassconstant(player.localclientnum, filterid, passid, 0, opacity);
}

/*
	Name: disable_filter_keyline_blend
	Namespace: filter
	Checksum: 0x1D4767FE
	Offset: 0x5460
	Size: 0x44
	Parameters: 3
	Flags: None
*/
function disable_filter_keyline_blend(player, filterid, passid)
{
	setfilterpassenabled(player.localclientnum, filterid, passid, 0);
}

/*
	Name: init_filter_drowning_damage
	Namespace: filter
	Checksum: 0x154CE281
	Offset: 0x54B0
	Size: 0x3C
	Parameters: 1
	Flags: Linked
*/
function init_filter_drowning_damage(localclientnum)
{
	init_filter_indices();
	map_material_helper_by_localclientnum(localclientnum, "generic_filter_drowning");
}

/*
	Name: enable_filter_drowning_damage
	Namespace: filter
	Checksum: 0xA77C970B
	Offset: 0x54F8
	Size: 0x6C
	Parameters: 2
	Flags: Linked
*/
function enable_filter_drowning_damage(localclientnum, passid)
{
	setfilterpassmaterial(localclientnum, 5, passid, mapped_material_id("generic_filter_drowning"));
	setfilterpassenabled(localclientnum, 5, passid, 1, 0, 1);
}

/*
	Name: set_filter_drowning_damage_opacity
	Namespace: filter
	Checksum: 0xB7240302
	Offset: 0x5570
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_drowning_damage_opacity(localclientnum, passid, opacity)
{
	setfilterpassconstant(localclientnum, 5, passid, 0, opacity);
}

/*
	Name: set_filter_drowning_damage_inner_radius
	Namespace: filter
	Checksum: 0x9A686710
	Offset: 0x55C0
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_drowning_damage_inner_radius(localclientnum, passid, inner)
{
	setfilterpassconstant(localclientnum, 5, passid, 1, inner);
}

/*
	Name: set_filter_drowning_damage_outer_radius
	Namespace: filter
	Checksum: 0x479CA350
	Offset: 0x5610
	Size: 0x44
	Parameters: 3
	Flags: Linked
*/
function set_filter_drowning_damage_outer_radius(localclientnum, passid, outer)
{
	setfilterpassconstant(localclientnum, 5, passid, 2, outer);
}

/*
	Name: disable_filter_drowning_damage
	Namespace: filter
	Checksum: 0xC79F0207
	Offset: 0x5660
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function disable_filter_drowning_damage(localclientnum, passid)
{
	setfilterpassenabled(localclientnum, 5, passid, 0);
}

