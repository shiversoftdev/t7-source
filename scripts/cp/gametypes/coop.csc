// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;

#namespace coop;

/*
	Name: init
	Namespace: coop
	Checksum: 0xA4072122
	Offset: 0xF0
	Size: 0x84
	Parameters: 0
	Flags: AutoExec
*/
function autoexec init()
{
	registerclientfield("playercorpse", "hide_body", 1, 1, "int", &function_d630ecfc, 0);
	registerclientfield("toplayer", "killcam_menu", 1, 1, "int", &function_9f1677e1, 0);
}

/*
	Name: main
	Namespace: coop
	Checksum: 0x99EC1590
	Offset: 0x180
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function main()
{
}

/*
	Name: onprecachegametype
	Namespace: coop
	Checksum: 0x99EC1590
	Offset: 0x190
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onprecachegametype()
{
}

/*
	Name: onstartgametype
	Namespace: coop
	Checksum: 0x99EC1590
	Offset: 0x1A0
	Size: 0x4
	Parameters: 0
	Flags: None
*/
function onstartgametype()
{
}

/*
	Name: function_9f1677e1
	Namespace: coop
	Checksum: 0x175A42BE
	Offset: 0x1B0
	Size: 0xD4
	Parameters: 7
	Flags: Linked
*/
function function_9f1677e1(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(getinkillcam(localclientnum))
	{
		return;
	}
	if(!isdefined(self.killcam_menu))
	{
		self.killcam_menu = createluimenu(localclientnum, "CPKillcam");
	}
	if(newval)
	{
		openluimenu(localclientnum, self.killcam_menu);
	}
	else
	{
		closeluimenu(localclientnum, self.killcam_menu);
	}
}

/*
	Name: function_d630ecfc
	Namespace: coop
	Checksum: 0xD464B116
	Offset: 0x290
	Size: 0x8C
	Parameters: 7
	Flags: Linked
*/
function function_d630ecfc(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	if(newval && !getinkillcam(localclientnum))
	{
		self hide();
	}
	else
	{
		self show();
	}
}

