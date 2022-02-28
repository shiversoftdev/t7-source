// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace character;

/*
	Name: setmodelfromarray
	Namespace: character
	Checksum: 0xB8CDA92D
	Offset: 0xD0
	Size: 0x3C
	Parameters: 1
	Flags: None
*/
function setmodelfromarray(a)
{
	self setmodel(a[randomint(a.size)]);
}

/*
	Name: randomelement
	Namespace: character
	Checksum: 0x5D8097C3
	Offset: 0x118
	Size: 0x28
	Parameters: 1
	Flags: None
*/
function randomelement(a)
{
	return a[randomint(a.size)];
}

/*
	Name: attachfromarray
	Namespace: character
	Checksum: 0xDC69E339
	Offset: 0x148
	Size: 0x44
	Parameters: 1
	Flags: None
*/
function attachfromarray(a)
{
	self attach(randomelement(a), "", 1);
}

/*
	Name: newcharacter
	Namespace: character
	Checksum: 0xA087E372
	Offset: 0x198
	Size: 0x64
	Parameters: 0
	Flags: None
*/
function newcharacter()
{
	self detachall();
	oldgunhand = self.anim_gunhand;
	if(!isdefined(oldgunhand))
	{
		return;
	}
	self.anim_gunhand = "none";
	self [[anim.putguninhand]](oldgunhand);
}

/*
	Name: save
	Namespace: character
	Checksum: 0xC734A501
	Offset: 0x208
	Size: 0x1A8
	Parameters: 0
	Flags: None
*/
function save()
{
	info["gunHand"] = self.anim_gunhand;
	info["gunInHand"] = self.anim_guninhand;
	info["model"] = self.model;
	info["hatModel"] = self.hatmodel;
	info["gearModel"] = self.gearmodel;
	if(isdefined(self.name))
	{
		info["name"] = self.name;
		/#
			println("", self.name);
		#/
	}
	else
	{
		/#
			println("");
		#/
	}
	attachsize = self getattachsize();
	for(i = 0; i < attachsize; i++)
	{
		info["attach"][i]["model"] = self getattachmodelname(i);
		info["attach"][i]["tag"] = self getattachtagname(i);
	}
	return info;
}

/*
	Name: load
	Namespace: character
	Checksum: 0x7B4ECA7
	Offset: 0x3B8
	Size: 0x196
	Parameters: 1
	Flags: None
*/
function load(info)
{
	self detachall();
	self.anim_gunhand = info["gunHand"];
	self.anim_guninhand = info["gunInHand"];
	self setmodel(info["model"]);
	self.hatmodel = info["hatModel"];
	self.gearmodel = info["gearModel"];
	if(isdefined(info["name"]))
	{
		self.name = info["name"];
		/#
			println("", self.name);
		#/
	}
	else
	{
		/#
			println("");
		#/
	}
	attachinfo = info["attach"];
	attachsize = attachinfo.size;
	for(i = 0; i < attachsize; i++)
	{
		self attach(attachinfo[i]["model"], attachinfo[i]["tag"]);
	}
}

/*
	Name: get_random_character
	Namespace: character
	Checksum: 0xFFCA34A7
	Offset: 0x558
	Size: 0x1F2
	Parameters: 1
	Flags: None
*/
function get_random_character(amount)
{
	self_info = strtok(self.classname, "_");
	if(self_info.size <= 2)
	{
		return randomint(amount);
	}
	group = "auto";
	index = undefined;
	prefix = self_info[2];
	if(isdefined(self.script_char_index))
	{
		index = self.script_char_index;
	}
	if(isdefined(self.script_char_group))
	{
		type = "grouped";
		group = "group_" + self.script_char_group;
	}
	if(!isdefined(level.character_index_cache))
	{
		level.character_index_cache = [];
	}
	if(!isdefined(level.character_index_cache[prefix]))
	{
		level.character_index_cache[prefix] = [];
	}
	if(!isdefined(level.character_index_cache[prefix][group]))
	{
		initialize_character_group(prefix, group, amount);
	}
	if(!isdefined(index))
	{
		index = get_least_used_index(prefix, group);
		if(!isdefined(index))
		{
			index = randomint(5000);
		}
	}
	while(index >= amount)
	{
		index = index - amount;
	}
	level.character_index_cache[prefix][group][index]++;
	return index;
}

/*
	Name: get_least_used_index
	Namespace: character
	Checksum: 0xD768CA27
	Offset: 0x758
	Size: 0x152
	Parameters: 2
	Flags: None
*/
function get_least_used_index(prefix, group)
{
	lowest_indices = [];
	lowest_use = level.character_index_cache[prefix][group][0];
	lowest_indices[0] = 0;
	for(i = 1; i < level.character_index_cache[prefix][group].size; i++)
	{
		if(level.character_index_cache[prefix][group][i] > lowest_use)
		{
			continue;
		}
		if(level.character_index_cache[prefix][group][i] < lowest_use)
		{
			lowest_indices = [];
			lowest_use = level.character_index_cache[prefix][group][i];
		}
		lowest_indices[lowest_indices.size] = i;
	}
	/#
		assert(lowest_indices.size, "");
	#/
	return random(lowest_indices);
}

/*
	Name: initialize_character_group
	Namespace: character
	Checksum: 0xD3155A34
	Offset: 0x8B8
	Size: 0x60
	Parameters: 3
	Flags: None
*/
function initialize_character_group(prefix, group, amount)
{
	for(i = 0; i < amount; i++)
	{
		level.character_index_cache[prefix][group][i] = 0;
	}
}

/*
	Name: random
	Namespace: character
	Checksum: 0x4B076887
	Offset: 0x920
	Size: 0x56
	Parameters: 1
	Flags: None
*/
function random(array)
{
	keys = getarraykeys(array);
	return array[keys[randomint(keys.size)]];
}

