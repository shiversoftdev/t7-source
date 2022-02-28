// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\zm\_zm_pack_a_punch;

#namespace zm_castle_pap_quest;

/*
	Name: main
	Namespace: zm_castle_pap_quest
	Checksum: 0x72592320
	Offset: 0x140
	Size: 0x2E
	Parameters: 0
	Flags: AutoExec
*/
function autoexec main()
{
	register_clientfields();
	level._effect["pap_tp"] = "dlc1/castle/fx_castle_pap_reform";
}

/*
	Name: register_clientfields
	Namespace: zm_castle_pap_quest
	Checksum: 0x3F56612B
	Offset: 0x178
	Size: 0x4C
	Parameters: 0
	Flags: Linked
*/
function register_clientfields()
{
	clientfield::register("scriptmover", "pap_tp_fx", 5000, 1, "counter", &pap_tp_fx, 0, 0);
}

/*
	Name: pap_tp_fx
	Namespace: zm_castle_pap_quest
	Checksum: 0xB5FAD7C4
	Offset: 0x1D0
	Size: 0x6C
	Parameters: 7
	Flags: Linked
*/
function pap_tp_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	playfx(localclientnum, level._effect["pap_tp"], self.origin);
}

