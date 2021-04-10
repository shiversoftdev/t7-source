// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#namespace multi_extracam;

/*
	Name: extracam_reset_index
	Namespace: multi_extracam
	Checksum: 0x20DB4B53
	Offset: 0x130
	Size: 0xB6
	Parameters: 2
	Flags: Linked
*/
function extracam_reset_index(localclientnum, index)
{
	if(!isdefined(level.camera_ents) || !isdefined(level.camera_ents[localclientnum]))
	{
		return;
	}
	if(isdefined(level.camera_ents[localclientnum][index]))
	{
		level.camera_ents[localclientnum][index] clearextracam();
		level.camera_ents[localclientnum][index] delete();
		level.camera_ents[localclientnum][index] = undefined;
	}
}

/*
	Name: extracam_init_index
	Namespace: multi_extracam
	Checksum: 0x1EDAFE9A
	Offset: 0x1F0
	Size: 0x62
	Parameters: 3
	Flags: Linked
*/
function extracam_init_index(localclientnum, target, index)
{
	camerastruct = struct::get(target, "targetname");
	return extracam_init_item(localclientnum, camerastruct, index);
}

/*
	Name: extracam_init_item
	Namespace: multi_extracam
	Checksum: 0x5E84865C
	Offset: 0x260
	Size: 0x182
	Parameters: 3
	Flags: Linked
*/
function extracam_init_item(localclientnum, copy_ent, index)
{
	if(!isdefined(level.camera_ents))
	{
		level.camera_ents = [];
	}
	if(!isdefined(level.camera_ents[localclientnum]))
	{
		level.camera_ents[localclientnum] = [];
	}
	if(isdefined(level.camera_ents[localclientnum][index]))
	{
		level.camera_ents[localclientnum][index] clearextracam();
		level.camera_ents[localclientnum][index] delete();
		level.camera_ents[localclientnum][index] = undefined;
	}
	if(isdefined(copy_ent))
	{
		level.camera_ents[localclientnum][index] = spawn(localclientnum, copy_ent.origin, "script_origin");
		level.camera_ents[localclientnum][index].angles = copy_ent.angles;
		level.camera_ents[localclientnum][index] setextracam(index);
		return level.camera_ents[localclientnum][index];
	}
	return undefined;
}

