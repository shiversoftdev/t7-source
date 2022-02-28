// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
class throttle 
{
	var processed_;
	var processlimit_;
	var queue_;
	var updaterate_;

	/*
		Name: constructor
		Namespace: throttle
		Checksum: 0xE3809695
		Offset: 0xC0
		Size: 0x38
		Parameters: 0
		Flags: Linked
	*/
	constructor()
	{
		queue_ = [];
		processed_ = 0;
		processlimit_ = 1;
		updaterate_ = 0.05;
	}

	/*
		Name: destructor
		Namespace: throttle
		Checksum: 0x99EC1590
		Offset: 0x100
		Size: 0x4
		Parameters: 0
		Flags: Linked
	*/
	destructor()
	{
	}

	/*
		Name: waitinqueue
		Namespace: throttle
		Checksum: 0xE35B4ACD
		Offset: 0x250
		Size: 0xB4
		Parameters: 1
		Flags: Linked
	*/
	function waitinqueue(entity)
	{
		if(processed_ >= processlimit_)
		{
			queue_[queue_.size] = entity;
			firstinqueue = 0;
			while(!firstinqueue)
			{
				if(!isdefined(entity))
				{
					return;
				}
				if(processed_ < processlimit_ && queue_[0] === entity)
				{
					firstinqueue = 1;
					queue_[0] = undefined;
				}
				else
				{
					wait(updaterate_);
				}
			}
		}
		processed_++;
	}

	/*
		Name: initialize
		Namespace: throttle
		Checksum: 0x6BF13DD3
		Offset: 0x1D8
		Size: 0x6C
		Parameters: 2
		Flags: Linked
	*/
	function initialize(processlimit = 1, updaterate = 0.05)
	{
		processlimit_ = processlimit;
		updaterate_ = updaterate;
		self thread _updatethrottlethread(self);
	}

	/*
		Name: _updatethrottle
		Namespace: throttle
		Checksum: 0x2064FB3C
		Offset: 0x110
		Size: 0xC0
		Parameters: 0
		Flags: Linked, Private
	*/
	function private _updatethrottle()
	{
		processed_ = 0;
		currentqueue = queue_;
		queue_ = [];
		foreach(item in currentqueue)
		{
			if(isdefined(item))
			{
				queue_[queue_.size] = item;
			}
		}
	}

	/*
		Name: _updatethrottlethread
		Namespace: throttle
		Checksum: 0xAD52B6CF
		Offset: 0x78
		Size: 0x3C
		Parameters: 1
		Flags: Linked, Private
	*/
	function private _updatethrottlethread(throttle)
	{
		while(isdefined(throttle))
		{
			[[ throttle ]]->_updatethrottle();
			wait(throttle.updaterate_);
		}
	}

}

