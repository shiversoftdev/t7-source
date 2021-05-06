// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace throttle;

/*
	Name: _updatethrottlethread
	Namespace: throttle
	Checksum: 0xAD52B6CF
	Offset: 0x78
	Size: 0x3C
	Parameters: 1
	Flags: Linked, Private
*/
private function _updatethrottlethread(throttle)
{
	while(isdefined(throttle))
	{
		[[ throttle ]]->_updatethrottle();
		wait(throttle.updaterate_);
	}
}

/*
	Name: __constructor
	Namespace: throttle
	Checksum: 0xE3809695
	Offset: 0xC0
	Size: 0x38
	Parameters: 0
	Flags: Linked
*/
function __constructor()
{
	self.queue_ = [];
	self.processed_ = 0;
	self.processlimit_ = 1;
	self.updaterate_ = 0.05;
}

/*
	Name: __destructor
	Namespace: throttle
	Checksum: 0x99EC1590
	Offset: 0x100
	Size: 0x4
	Parameters: 0
	Flags: Linked
*/
function __destructor()
{
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
private function _updatethrottle()
{
	self.processed_ = 0;
	currentqueue = self.queue_;
	self.queue_ = [];
	foreach(var_882cee42, item in currentqueue)
	{
		if(isdefined(item))
		{
			self.queue_[self.queue_.size] = item;
		}
	}
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
	self.processlimit_ = processlimit;
	self.updaterate_ = updaterate;
	self thread _updatethrottlethread(self);
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
	if(self.processed_ >= self.processlimit_)
	{
		self.queue_[self.queue_.size] = entity;
		firstinqueue = 0;
		while(!firstinqueue)
		{
			if(!isdefined(entity))
			{
				return;
			}
			if(self.processed_ < self.processlimit_ && self.queue_[0] === entity)
			{
				firstinqueue = 1;
				self.queue_[0] = undefined;
			}
			else
			{
				wait(self.updaterate_);
			}
		}
	}
	self.processed_++;
}

/*
	Name: throttle
	Namespace: throttle
	Checksum: 0x30CB32A
	Offset: 0x310
	Size: 0x146
	Parameters: 0
	Flags: AutoExec, Private
*/
private autoexec function throttle()
{
	classes.throttle[0] = spawnstruct();
	classes.throttle[0].__vtable[1123417372] = &waitinqueue;
	classes.throttle[0].__vtable[-422924033] = &initialize;
	classes.throttle[0].__vtable[-1487653173] = &_updatethrottle;
	classes.throttle[0].__vtable[1606033458] = &__destructor;
	classes.throttle[0].__vtable[-1690805083] = &__constructor;
	classes.throttle[0].__vtable[-758537977] = &_updatethrottlethread;
}

