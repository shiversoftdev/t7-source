// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\zm\_filter;

#namespace _zm_pack_a_punch;

/*
	Name: __init__sytem__
	Namespace: _zm_pack_a_punch
	Checksum: 0x58763584
	Offset: 0x248
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
function autoexec __init__sytem__()
{
	system::register("zm_pack_a_punch", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: _zm_pack_a_punch
	Checksum: 0x6C3915B8
	Offset: 0x288
	Size: 0x64
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	level._effect["pap_working_fx"] = "dlc1/castle/fx_packapunch_castle";
	clientfield::register("zbarrier", "pap_working_FX", 5000, 1, "int", &pap_working_fx_handler, 0, 0);
}

/*
	Name: pap_working_fx_handler
	Namespace: _zm_pack_a_punch
	Checksum: 0x8FDC16D5
	Offset: 0x2F8
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function pap_working_fx_handler(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval == 1)
	{
		pap_play_fx(localclientnum, 0, "base_jnt");
	}
	else
	{
		if(isdefined(self.n_pap_fx))
		{
			stopfx(localclientnum, self.n_pap_fx);
			self.n_pap_fx = undefined;
		}
		wait(1);
		if(isdefined(self.mdl_fx))
		{
			self.mdl_fx delete();
		}
	}
}

/*
	Name: pap_play_fx
	Namespace: _zm_pack_a_punch
	Checksum: 0x7EFDDBA2
	Offset: 0x3D8
	Size: 0x14C
	Parameters: 3
	Flags: Linked, Private
*/
function private pap_play_fx(localclientnum, n_piece_index, str_tag)
{
	mdl_piece = self zbarriergetpiece(n_piece_index);
	if(isdefined(self.mdl_fx))
	{
		self.mdl_fx delete();
	}
	if(isdefined(self.n_pap_fx))
	{
		deletefx(localclientnum, self.n_pap_fx);
		self.n_pap_fx = undefined;
	}
	self.mdl_fx = util::spawn_model(localclientnum, "tag_origin", mdl_piece gettagorigin(str_tag), mdl_piece gettagangles(str_tag));
	self.mdl_fx linkto(mdl_piece, str_tag);
	self.n_pap_fx = playfxontag(localclientnum, level._effect["pap_working_fx"], self.mdl_fx, "tag_origin");
}

