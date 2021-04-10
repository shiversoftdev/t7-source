// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using_animtree("generic");

#namespace scripted;

/*
	Name: main
	Namespace: scripted
	Checksum: 0x31C6455E
	Offset: 0x98
	Size: 0x78
	Parameters: 0
	Flags: Linked
*/
function main()
{
	self endon(#"death");
	self notify(#"killanimscript");
	self notify(#"clearsuppressionattack");
	self.codescripted["root"] = %generic::body;
	self endon(#"end_sequence");
	self.a.script = "scripted";
	self waittill(#"killanimscript");
}

/*
	Name: init
	Namespace: scripted
	Checksum: 0xA67B02C3
	Offset: 0x118
	Size: 0x4C
	Parameters: 9
	Flags: None
*/
function init(notifyname, origin, angles, theanim, animmode, root, rate, goaltime, lerptime)
{
}

/*
	Name: end_script
	Namespace: scripted
	Checksum: 0xEA90FC5A
	Offset: 0x170
	Size: 0x20
	Parameters: 0
	Flags: Linked
*/
function end_script()
{
	if(isdefined(self.___archetypeonbehavecallback))
	{
		[[self.___archetypeonbehavecallback]](self);
	}
}

