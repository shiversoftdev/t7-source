// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace delete;

/*
	Name: main
	Namespace: delete
	Checksum: 0xE409724C
	Offset: 0x70
	Size: 0xFC
	Parameters: 0
	Flags: Linked
*/
function main()
{
	/#
		assert(isdefined(self));
	#/
	wait(0);
	if(isdefined(self))
	{
		/#
			if(isdefined(self.classname))
			{
				if(self.classname == "" || self.classname == "" || self.classname == "")
				{
					println("");
					println((("" + self getentitynumber()) + "") + self.origin);
					println("");
				}
			}
		#/
		self delete();
	}
}

