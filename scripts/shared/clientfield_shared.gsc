// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#namespace clientfield;

/*
	Name: register
	Namespace: clientfield
	Checksum: 0xE517FF89
	Offset: 0x78
	Size: 0x54
	Parameters: 5
	Flags: Linked
*/
function register(str_pool_name, str_name, n_version, n_bits, str_type)
{
	registerclientfield(str_pool_name, str_name, n_version, n_bits, str_type);
}

/*
	Name: set
	Namespace: clientfield
	Checksum: 0x4076E995
	Offset: 0xD8
	Size: 0x5C
	Parameters: 2
	Flags: Linked
*/
function set(str_field_name, n_value)
{
	if(self == level)
	{
		codesetworldclientfield(str_field_name, n_value);
	}
	else
	{
		codesetclientfield(self, str_field_name, n_value);
	}
}

/*
	Name: set_to_player
	Namespace: clientfield
	Checksum: 0x72F4F0BC
	Offset: 0x140
	Size: 0x34
	Parameters: 2
	Flags: Linked
*/
function set_to_player(str_field_name, n_value)
{
	codesetplayerstateclientfield(self, str_field_name, n_value);
}

/*
	Name: set_player_uimodel
	Namespace: clientfield
	Checksum: 0x7680423F
	Offset: 0x180
	Size: 0x4C
	Parameters: 2
	Flags: Linked
*/
function set_player_uimodel(str_field_name, n_value)
{
	if(!isentity(self))
	{
		return;
	}
	codesetuimodelclientfield(self, str_field_name, n_value);
}

/*
	Name: get_player_uimodel
	Namespace: clientfield
	Checksum: 0x794BB944
	Offset: 0x1D8
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function get_player_uimodel(str_field_name)
{
	return codegetuimodelclientfield(self, str_field_name);
}

/*
	Name: increment
	Namespace: clientfield
	Checksum: 0xA2ED5C1B
	Offset: 0x208
	Size: 0x8E
	Parameters: 2
	Flags: Linked
*/
function increment(str_field_name, n_increment_count = 1)
{
	for(i = 0; i < n_increment_count; i++)
	{
		if(self == level)
		{
			codeincrementworldclientfield(str_field_name);
			continue;
		}
		codeincrementclientfield(self, str_field_name);
	}
}

/*
	Name: increment_uimodel
	Namespace: clientfield
	Checksum: 0xF74DCBAF
	Offset: 0x2A0
	Size: 0x11E
	Parameters: 2
	Flags: Linked
*/
function increment_uimodel(str_field_name, n_increment_count = 1)
{
	if(self == level)
	{
		foreach(player in level.players)
		{
			for(i = 0; i < n_increment_count; i++)
			{
				codeincrementuimodelclientfield(player, str_field_name);
			}
		}
	}
	else
	{
		for(i = 0; i < n_increment_count; i++)
		{
			codeincrementuimodelclientfield(self, str_field_name);
		}
	}
}

/*
	Name: increment_to_player
	Namespace: clientfield
	Checksum: 0x6CC3899A
	Offset: 0x3C8
	Size: 0x66
	Parameters: 2
	Flags: Linked
*/
function increment_to_player(str_field_name, n_increment_count = 1)
{
	for(i = 0; i < n_increment_count; i++)
	{
		codeincrementplayerstateclientfield(self, str_field_name);
	}
}

/*
	Name: get
	Namespace: clientfield
	Checksum: 0x31FE6086
	Offset: 0x438
	Size: 0x4A
	Parameters: 1
	Flags: Linked
*/
function get(str_field_name)
{
	if(self == level)
	{
		return codegetworldclientfield(str_field_name);
	}
	return codegetclientfield(self, str_field_name);
}

/*
	Name: get_to_player
	Namespace: clientfield
	Checksum: 0x9D06D42D
	Offset: 0x490
	Size: 0x22
	Parameters: 1
	Flags: Linked
*/
function get_to_player(field_name)
{
	return codegetplayerstateclientfield(self, field_name);
}

