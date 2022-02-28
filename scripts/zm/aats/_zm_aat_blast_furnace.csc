// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\shared\aat_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

#namespace zm_aat_blast_furnace;

/*
	Name: __init__sytem__
	Namespace: zm_aat_blast_furnace
	Checksum: 0xD0F7F4E4
	Offset: 0x208
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_aat_blast_furnace", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_aat_blast_furnace
	Checksum: 0xCC7FFFCC
	Offset: 0x248
	Size: 0x19E
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	if(!(isdefined(level.aat_in_use) && level.aat_in_use))
	{
		return;
	}
	aat::register("zm_aat_blast_furnace", "zmui_zm_aat_blast_furnace", "t7_icon_zm_aat_blast_furnace");
	clientfield::register("actor", "zm_aat_blast_furnace" + "_explosion", 1, 1, "counter", &zm_aat_blast_furnace_explosion, 0, 0);
	clientfield::register("vehicle", "zm_aat_blast_furnace" + "_explosion_vehicle", 1, 1, "counter", &zm_aat_blast_furnace_explosion_vehicle, 0, 0);
	clientfield::register("actor", "zm_aat_blast_furnace" + "_burn", 1, 1, "counter", &zm_aat_blast_furnace_burn, 0, 0);
	clientfield::register("vehicle", "zm_aat_blast_furnace" + "_burn_vehicle", 1, 1, "counter", &zm_aat_blast_furnace_burn_vehicle, 0, 0);
	level._effect["zm_aat_blast_furnace"] = "zombie/fx_aat_blast_furnace_zmb";
}

/*
	Name: zm_aat_blast_furnace_explosion
	Namespace: zm_aat_blast_furnace
	Checksum: 0xCD864AEF
	Offset: 0x3F0
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function zm_aat_blast_furnace_explosion(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playsound(0, "wpn_aat_blastfurnace_explo", self.origin);
	s_aat_blast_furnace_explosion = spawnstruct();
	s_aat_blast_furnace_explosion.origin = self.origin;
	s_aat_blast_furnace_explosion.angles = self.angles;
	s_aat_blast_furnace_explosion thread zm_aat_blast_furnace_explosion_think(localclientnum);
}

/*
	Name: zm_aat_blast_furnace_explosion_vehicle
	Namespace: zm_aat_blast_furnace
	Checksum: 0x94A81634
	Offset: 0x4C0
	Size: 0xC4
	Parameters: 7
	Flags: Linked
*/
function zm_aat_blast_furnace_explosion_vehicle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playsound(0, "wpn_aat_blastfurnace_explo", self.origin);
	s_aat_blast_furnace_explosion = spawnstruct();
	s_aat_blast_furnace_explosion.origin = self.origin;
	s_aat_blast_furnace_explosion.angles = self.angles;
	s_aat_blast_furnace_explosion thread zm_aat_blast_furnace_explosion_think(localclientnum);
}

/*
	Name: zm_aat_blast_furnace_explosion_think
	Namespace: zm_aat_blast_furnace
	Checksum: 0x24F5845D
	Offset: 0x590
	Size: 0xAE
	Parameters: 1
	Flags: Linked
*/
function zm_aat_blast_furnace_explosion_think(localclientnum)
{
	angles = self.angles;
	if(lengthsquared(angles) < 0.001)
	{
		angles = (1, 0, 0);
	}
	self.fx_aat_blast_furnace_explode = playfx(localclientnum, "zombie/fx_aat_blast_furnace_zmb", self.origin, angles);
	wait(2.5);
	stopfx(localclientnum, self.fx_aat_blast_furnace_explode);
	self.fx_aat_blast_furnace_explode = undefined;
}

/*
	Name: zm_aat_blast_furnace_burn
	Namespace: zm_aat_blast_furnace
	Checksum: 0xC1CCE69
	Offset: 0x648
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function zm_aat_blast_furnace_burn(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	tag = "j_spine4";
	v_tag = self gettagorigin(tag);
	if(!isdefined(v_tag))
	{
		tag = "tag_origin";
	}
	level thread zm_aat_blast_furnace_burn_think(localclientnum, self, tag);
}

/*
	Name: zm_aat_blast_furnace_burn_vehicle
	Namespace: zm_aat_blast_furnace
	Checksum: 0xA860803B
	Offset: 0x700
	Size: 0xAC
	Parameters: 7
	Flags: Linked
*/
function zm_aat_blast_furnace_burn_vehicle(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	tag = "tag_body";
	v_tag = self gettagorigin(tag);
	if(!isdefined(v_tag))
	{
		tag = "tag_origin";
	}
	level thread zm_aat_blast_furnace_burn_think(localclientnum, self, tag);
}

/*
	Name: zm_aat_blast_furnace_burn_think
	Namespace: zm_aat_blast_furnace
	Checksum: 0x590D4A43
	Offset: 0x7B8
	Size: 0xCC
	Parameters: 3
	Flags: Linked
*/
function zm_aat_blast_furnace_burn_think(localclientnum, e_zombie, tag)
{
	e_zombie.fx_aat_blast_furnace_burn = playfxontag(localclientnum, "zombie/fx_bgb_burned_out_fire_torso_zmb", e_zombie, tag);
	e_zombie playloopsound("chr_burn_npc_loop1", 0.5);
	e_zombie waittill(#"entityshutdown");
	if(isdefined(e_zombie))
	{
		e_zombie stopallloopsounds(1.5);
		stopfx(localclientnum, e_zombie.fx_aat_blast_furnace_burn);
	}
}

